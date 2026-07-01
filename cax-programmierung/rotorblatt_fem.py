"""FEM utilities for linear-elastic static analysis of the rotor blade.

All functions assume the mesh coordinates are in **millimetres** (build123d
internal unit), forces in **Newton**, and stresses in **N/mm² = MPa**.

Workflow::

    from skfem.io.meshio import from_meshio
    from skfem import Basis, FacetBasis, ElementVector, ElementTetP1, LinearForm
    from skfem.models.elasticity import linear_elasticity
    from skfem.utils import solve, condense
    from rotorblatt_fem import SimParam, lame_parameters, von_mises, nodal_displacements

    param = SimParam()
    lam, mu = lame_parameters(param.E, param.nu)

    mesh   = from_meshio(m)                          # meshio → skfem
    elem   = ElementVector(ElementTetP1())
    basis  = Basis(mesh, elem)
    K      = linear_elasticity(lam, mu).assemble(basis)

    fbasis = FacetBasis(mesh, elem, facets=mesh.boundaries["upper_skin"])

    @LinearForm
    def pressure_load(v, w):
        return -param.pressure * v[1]                # flapwise = −Y

    f     = pressure_load.assemble(fbasis)
    fixed = basis.get_dofs(mesh.boundaries["root"]).all()
    u     = solve(*condense(K, f, D=fixed))

    ux, uy, uz = nodal_displacements(u, basis)
    vm         = von_mises(basis, u, lam, mu)
"""

from dataclasses import dataclass

import meshio
import numpy as np
from skfem import Basis, ElementVector, ElementTetP1, FacetBasis, LinearForm, Mesh
from skfem.io.meshio import from_meshio
from skfem.models.elasticity import linear_elasticity, sym_grad
from skfem.utils import condense, solve


@dataclass
class SimParam:
    """Material and load parameters for the flapwise static simulation.

    All stress / stiffness values are in N/mm² = MPa to match the millimetre
    coordinate system produced by build123d and cadgmsh.

    Attributes:
        E:        In-plane Young's modulus in MPa.
                  GFK (glass-fibre/epoxy biaxial laminate): 20 000–30 000 MPa.
                  Carbon-fibre spar caps: 70 000–120 000 MPa.
        nu:       Poisson's ratio (dimensionless).
                  Typical GFK laminate: 0.25–0.35.
        pressure: Aerodynamic suction pressure in N/mm² applied uniformly to
                  the ``upper_skin`` physical group (suction side).
                  2 kPa = 0.002 N/mm² is a representative peak value for a
                  2 MW turbine in rated-wind conditions.
    """

    E: float = 25_000.0
    nu: float = 0.3
    pressure: float = 0.002


def lame_parameters(E: float, nu: float) -> tuple[float, float]:
    """Convert Young's modulus and Poisson's ratio to Lamé parameters.

    The first Lamé parameter λ and the shear modulus μ appear in the isotropic
    linear-elastic constitutive law:

    .. math::
        \\boldsymbol{\\sigma} = \\lambda \\operatorname{tr}(\\boldsymbol{\\varepsilon})
        \\mathbf{I} + 2\\mu\\,\\boldsymbol{\\varepsilon}

    Args:
        E:  Young's modulus in MPa.
        nu: Poisson's ratio (dimensionless, must satisfy 0 < nu < 0.5).

    Returns:
        Tuple ``(lam, mu)`` of Lamé parameters in MPa.

    Example::

        lam, mu = lame_parameters(25_000, 0.3)   # GFK
        lam, mu = lame_parameters(210_000, 0.28) # Stahl
    """
    lam = E * nu / ((1 + nu) * (1 - 2 * nu))
    mu  = E / (2 * (1 + nu))
    return lam, mu


def von_mises(basis: Basis, u: np.ndarray, lam: float, mu: float) -> np.ndarray:
    """Compute the von Mises equivalent stress for each element.

    The von Mises criterion combines all stress components into a single
    scalar that can be compared to the uniaxial yield / allowable stress:

    .. math::
        \\sigma_\\text{vm} = \\sqrt{\\tfrac{1}{2}\\bigl[
            (\\sigma_{xx}-\\sigma_{yy})^2 +
            (\\sigma_{yy}-\\sigma_{zz})^2 +
            (\\sigma_{zz}-\\sigma_{xx})^2 +
            6(\\tau_{xy}^2 + \\tau_{yz}^2 + \\tau_{xz}^2)
        \\bigr]}

    The stress tensor is recovered from the displacement field via Hooke's law.
    Values are averaged over each element's quadrature points, producing one
    scalar per element suitable for ``pyvista`` cell data.

    Args:
        basis: Assembled ``skfem.Basis`` used for the FEM solve.
        u:     Displacement DOF vector as returned by ``skfem.solve``.
        lam:   First Lamé parameter in MPa (from :func:`lame_parameters`).
        mu:    Shear modulus in MPa (from :func:`lame_parameters`).

    Returns:
        1-D ``numpy`` array of length ``n_elements`` with per-element von Mises
        stress in MPa.  Use as ``grid.cell_data["vm"] = von_mises(...)`` in
        pyvista.
    """
    u_h   = basis.interpolate(u)
    eps   = sym_grad(u_h)
    sigma = (
        lam * np.einsum("ii...", eps) * np.eye(3)[..., np.newaxis, np.newaxis]
        + 2 * mu * eps
    )
    s = sigma.mean(axis=-1)   # mean over quadrature points → shape (3, 3, n_elems)
    return np.sqrt(0.5 * (
        (s[0, 0] - s[1, 1]) ** 2
        + (s[1, 1] - s[2, 2]) ** 2
        + (s[2, 2] - s[0, 0]) ** 2
        + 6 * (s[0, 1] ** 2 + s[1, 2] ** 2 + s[0, 2] ** 2)
    ))


def nodal_displacements(
    u: np.ndarray, basis: Basis
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Extract per-node x/y/z displacement components from the DOF vector.

    For ``ElementVector(ElementTetP1())`` with *n* nodes, the global DOF vector
    has length 3n.  ``basis.nodal_dofs`` has shape ``(3, n)``: row 0 contains
    the x-DOF indices for every node, row 1 the y-DOF indices, row 2 the
    z-DOF indices.  Indexing ``u`` with these arrays returns nodal values
    directly.

    Args:
        u:     Displacement DOF vector from ``skfem.solve``.
        basis: Basis used for the FEM solve.

    Returns:
        Tuple ``(ux, uy, uz)`` of per-node displacement arrays in mm.
        Suitable for ``grid.point_data`` in pyvista.

    Example::

        ux, uy, uz = nodal_displacements(u, basis)
        print(f"Max flapwise tip deflection: {abs(uy).max():.0f} mm")
        grid.point_data["u"] = np.column_stack([ux, uy, uz])
    """
    return (
        u[basis.nodal_dofs[0]],
        u[basis.nodal_dofs[1]],
        u[basis.nodal_dofs[2]],
    )


@dataclass
class SimResult:
    """Result of a static linear-elastic simulation.

    Attributes:
        mesh:  The skfem mesh the system was solved on.
        basis: The vector-valued ``Basis`` used for the solve.
        u:     Raw displacement DOF vector, as returned by ``skfem.solve``.
        ux, uy, uz: Per-node displacement components in mm (see
            :func:`nodal_displacements`).
        vm:    Per-element von Mises stress in MPa (see :func:`von_mises`).
    """

    mesh: Mesh
    basis: Basis
    u: np.ndarray
    ux: np.ndarray
    uy: np.ndarray
    uz: np.ndarray
    vm: np.ndarray


def simulate_flapwise(
    m: meshio.Mesh,
    param: SimParam = SimParam(),
    pressure_boundary: str = "upper_skin",
    fixed_boundary: str = "root",
) -> SimResult:
    """Solve a static flapwise-bending load case on a meshed rotor blade.

    Black-box simulation: clamps ``fixed_boundary`` (Dirichlet, u = 0) and
    applies a uniform pressure on ``pressure_boundary`` in the −Y direction
    (Neumann), using isotropic linear elasticity with the material in
    ``param``. No skfem knowledge is required to call this function — see
    :func:`lame_parameters`, :func:`von_mises`, and :func:`nodal_displacements`,
    or this module's docstring, if you want to see what happens inside.

    The mesh must carry named physical groups for both ``pressure_boundary``
    and ``fixed_boundary``, e.g. as produced by
    ``cadgmsh.mesh(shape, dim=3, physical={...})``.

    Args:
        m: Volumetric tetrahedral mesh with named physical groups.
        param: Material and load parameters. Defaults to GFK / 2 kPa.
        pressure_boundary: Name of the physical group the pressure acts on.
            Must be a key in ``m``'s physical groups.
        fixed_boundary: Name of the physical group that is rigidly clamped.
            Must be a key in ``m``'s physical groups.

    Returns:
        :class:`SimResult` with nodal displacements and per-element von Mises
        stress.

    Example::

        m = cadgmsh.mesh(structured, dim=3, lc=100, physical={
            "upper_skin": ..., "lower_skin": ..., "root": ..., "spars": ...,
        })
        result = simulate_flapwise(m)
        print(f"Max. Schlagbiegung: {abs(result.uy).max():.0f} mm")

        # Carbon spar caps instead of GFK:
        result_cf = simulate_flapwise(m, SimParam(E=120_000.0, nu=0.28))
    """
    mesh = from_meshio(m)
    lam, mu = lame_parameters(param.E, param.nu)

    elem  = ElementVector(ElementTetP1())
    basis = Basis(mesh, elem)
    K     = linear_elasticity(lam, mu).assemble(basis)

    fbasis = FacetBasis(mesh, elem, facets=mesh.boundaries[pressure_boundary])

    @LinearForm
    def pressure_load(v, w):
        return -param.pressure * v[1]   # flapwise = −Y

    f     = pressure_load.assemble(fbasis)
    fixed = basis.get_dofs(mesh.boundaries[fixed_boundary]).all()
    u     = solve(*condense(K, f, D=fixed))

    ux, uy, uz = nodal_displacements(u, basis)
    vm = von_mises(basis, u, lam, mu)

    return SimResult(mesh=mesh, basis=basis, u=u, ux=ux, uy=uy, uz=uz, vm=vm)
