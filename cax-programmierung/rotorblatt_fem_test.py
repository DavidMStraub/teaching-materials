import meshio
import numpy as np
import pytest
import build123d as bd
import cadgmsh
from skfem.io.meshio import from_meshio
from skfem import Basis, ElementVector, ElementTetP1

from rotorblatt_fem import (
    SimParam,
    lame_parameters,
    nodal_displacements,
    simulate_flapwise,
    von_mises,
)


class TestSimParam:
    def test_defaults_positive(self) -> None:
        p = SimParam()
        assert p.E > 0
        assert p.pressure > 0

    def test_nu_in_valid_range(self) -> None:
        assert 0 < SimParam().nu < 0.5

    def test_custom_values_stored(self) -> None:
        p = SimParam(E=210_000.0, nu=0.28, pressure=0.005)
        assert p.E == 210_000.0
        assert p.nu == pytest.approx(0.28)
        assert p.pressure == pytest.approx(0.005)


class TestLameParameters:
    def test_positive_outputs(self) -> None:
        lam, mu = lame_parameters(25_000.0, 0.3)
        assert lam > 0 and mu > 0

    def test_recover_E_and_nu(self) -> None:
        E, nu = 25_000.0, 0.3
        lam, mu = lame_parameters(E, nu)
        assert mu * (3 * lam + 2 * mu) / (lam + mu) == pytest.approx(E, rel=1e-10)
        assert lam / (2 * (lam + mu)) == pytest.approx(nu, rel=1e-10)

    def test_mu_equals_shear_modulus(self) -> None:
        E, nu = 30_000.0, 0.25
        _, mu = lame_parameters(E, nu)
        assert mu == pytest.approx(E / (2 * (1 + nu)), rel=1e-10)

    def test_steel_known_values(self) -> None:
        lam, mu = lame_parameters(210_000.0, 0.3)
        assert lam == pytest.approx(121_153.8, rel=1e-4)
        assert mu  == pytest.approx(80_769.2,  rel=1e-4)

    def test_incompressible_limit_large_lam(self) -> None:
        # nu → 0.5 drives lam → ∞; mu = E/2(1+nu) stays finite and positive
        lam_hi, mu_hi = lame_parameters(10_000.0, 0.499)
        assert lam_hi > 1e5
        assert mu_hi > 0


@pytest.fixture(scope="module")
def cube_fem() -> tuple[Basis, object]:
    """Minimal tetrahedral mesh of a 10 mm cube."""
    m    = cadgmsh.mesh(bd.Box(10, 10, 10), lc=4.0, dim=3)
    mesh = from_meshio(m)
    return Basis(mesh, ElementVector(ElementTetP1())), mesh


class TestVonMises:
    def test_zero_displacement_zero_stress(self, cube_fem) -> None:
        basis, _ = cube_fem
        vm = von_mises(basis, basis.zeros(), *lame_parameters(25_000.0, 0.3))
        assert np.allclose(vm, 0.0, atol=1e-8)

    def test_output_length_equals_n_elements(self, cube_fem) -> None:
        basis, mesh = cube_fem
        vm = von_mises(basis, basis.zeros(), *lame_parameters(25_000.0, 0.3))
        assert len(vm) == mesh.t.shape[1]

    def test_non_negative_for_random_displacement(self, cube_fem) -> None:
        basis, _ = cube_fem
        u = np.random.default_rng(42).standard_normal(basis.N)
        vm = von_mises(basis, u, *lame_parameters(25_000.0, 0.3))
        assert np.all(vm >= 0.0)

    def test_uniaxial_strain_matches_analytical(self, cube_fem) -> None:
        """Homogeneous ε_zz = ε  →  σ_vm = 2μ·ε  (exact for P1 elements)."""
        basis, mesh = cube_fem
        eps = 0.001
        u   = basis.zeros()
        u[basis.nodal_dofs[2]] = eps * mesh.p[2]   # u_z = ε·z, others zero
        lam, mu = lame_parameters(25_000.0, 0.3)
        vm = von_mises(basis, u, lam, mu)
        assert np.allclose(vm, 2 * mu * eps, rtol=1e-6)


class TestNodalDisplacements:
    def test_output_shapes_equal_n_nodes(self, cube_fem) -> None:
        basis, mesh = cube_fem
        ux, uy, uz = nodal_displacements(basis.zeros(), basis)
        n = mesh.p.shape[1]
        assert ux.shape == (n,) and uy.shape == (n,) and uz.shape == (n,)

    def test_zero_input_zero_output(self, cube_fem) -> None:
        basis, _ = cube_fem
        for component in nodal_displacements(basis.zeros(), basis):
            assert np.all(component == 0.0)

    def test_x_only_displacement(self, cube_fem) -> None:
        basis, _ = cube_fem
        u = basis.zeros()
        u[basis.nodal_dofs[0]] = 1.0
        ux, uy, uz = nodal_displacements(u, basis)
        assert np.allclose(ux, 1.0)
        assert np.allclose(uy, 0.0)
        assert np.allclose(uz, 0.0)

    def test_values_match_raw_dof_indexing(self, cube_fem) -> None:
        basis, _ = cube_fem
        u = np.random.default_rng(7).standard_normal(basis.N)
        ux, uy, uz = nodal_displacements(u, basis)
        assert np.array_equal(ux, u[basis.nodal_dofs[0]])
        assert np.array_equal(uy, u[basis.nodal_dofs[1]])
        assert np.array_equal(uz, u[basis.nodal_dofs[2]])


@pytest.fixture(scope="module")
def cantilever_mesh() -> meshio.Mesh:
    """10×10×40 mm cantilever, clamped at z=0, free at z=40, top face loadable."""
    box = bd.Box(
        10, 10, 40,
        align=(bd.Align.CENTER, bd.Align.CENTER, bd.Align.MIN),
    )
    faces = box.faces()
    bottom = faces.sort_by(bd.Axis.Z).first
    top    = faces.sort_by(bd.Axis.Z).last
    return cadgmsh.mesh(box, lc=4.0, dim=3, physical={"bottom": bottom, "top": top})


class TestSimulateFlapwise:
    def test_returns_correct_shapes(self, cantilever_mesh) -> None:
        result = simulate_flapwise(
            cantilever_mesh, pressure_boundary="top", fixed_boundary="bottom"
        )
        n_nodes = result.mesh.p.shape[1]
        n_elems = result.mesh.t.shape[1]
        assert result.ux.shape == (n_nodes,)
        assert result.uy.shape == (n_nodes,)
        assert result.uz.shape == (n_nodes,)
        assert result.vm.shape == (n_elems,)

    def test_fixed_boundary_has_zero_displacement(self, cantilever_mesh) -> None:
        result = simulate_flapwise(
            cantilever_mesh, pressure_boundary="top", fixed_boundary="bottom"
        )
        bottom_dofs = result.basis.get_dofs(result.mesh.boundaries["bottom"]).all()
        assert np.allclose(result.u[bottom_dofs], 0.0, atol=1e-10)

    def test_pressure_deflects_in_negative_y(self, cantilever_mesh) -> None:
        result = simulate_flapwise(
            cantilever_mesh, pressure_boundary="top", fixed_boundary="bottom"
        )
        assert result.uy.min() < 0.0

    def test_stiffer_material_deflects_less(self, cantilever_mesh) -> None:
        soft = simulate_flapwise(
            cantilever_mesh, SimParam(E=10_000.0, nu=0.3),
            pressure_boundary="top", fixed_boundary="bottom",
        )
        stiff = simulate_flapwise(
            cantilever_mesh, SimParam(E=100_000.0, nu=0.3),
            pressure_boundary="top", fixed_boundary="bottom",
        )
        assert np.abs(stiff.uy).max() < np.abs(soft.uy).max()

    def test_custom_boundary_names_required(self, cantilever_mesh) -> None:
        with pytest.raises(KeyError):
            simulate_flapwise(cantilever_mesh)   # defaults don't exist on this mesh
