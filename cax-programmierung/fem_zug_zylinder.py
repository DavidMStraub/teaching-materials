import cadgmsh
from build123d import Cylinder, Axis
from skfem.io.meshio import from_meshio
import numpy as np
import pyvista as pv
from skfem import Basis, ElementVector, ElementTetP1
from skfem.models.elasticity import linear_elasticity, lame_parameters, sym_grad
from skfem.utils import solve, condense

# 1. CAD-Modell
part = Cylinder(radius=10, height=40)  # r=10 mm, h=40 mm, z ∈ [-20, 20]

# 2. Vernetzung mit benannten Rändern
cadmesh = cadgmsh.mesh(
    part,
    dim=3,
    lc=2.0,
    physical={
        "top": part.faces().sort_by(Axis.Z).last,
        "bottom": part.faces().sort_by(Axis.Z).first,
    },
)
mesh = from_meshio(cadmesh)

# 4. FEM-Aufbau  (Einheiten: MPa, mm)
E, nu = 210e3, 0.3  # Stahl
lam, mu = lame_parameters(E, nu)

basis = Basis(mesh, ElementVector(ElementTetP1()))
K = linear_elasticity(lam, mu).assemble(basis)

# 1000 N Zug an Oberseite, gleichmäßig verteilt
f = basis.zeros()
top_dofs = basis.get_dofs(mesh.boundaries["top"]).nodal["u^3"]
f[top_dofs] = 1000.0 / len(top_dofs)

# Einspannung Unterseite
fixed_dofs = basis.get_dofs(mesh.boundaries["bottom"]).all()

# 5. Lösen
u = solve(*condense(K, f, D=fixed_dofs))

# 6. Von-Mises-Spannung
u_h = basis.interpolate(u)
eps = sym_grad(u_h)
sigma = (
    lam * np.einsum("ii...", eps) * np.eye(3)[..., np.newaxis, np.newaxis]
    + 2 * mu * eps
)
s = sigma.mean(axis=-1)  # Quadraturpunkt-Mittel
vm = np.sqrt(
    0.5
    * (
        (s[0, 0] - s[1, 1]) ** 2
        + (s[1, 1] - s[2, 2]) ** 2
        + (s[2, 2] - s[0, 0]) ** 2
        + 6 * (s[0, 1] ** 2 + s[1, 2] ** 2 + s[0, 2] ** 2)
    )
)

print(f"Maximale Verschiebung:   {np.max(np.abs(u)):.4f} mm")
print(f"Maximale Von-Mises-Spg.: {vm.max():.2f} MPa")

# 7. Visualisierung
cells = np.hstack([np.full((mesh.t.shape[1], 1), 4), mesh.t.T]).ravel()
cell_types = np.full(mesh.t.shape[1], pv.CellType.TETRA)
grid = pv.UnstructuredGrid(cells, cell_types, mesh.p.T)

grid.point_data["Verschiebung z [mm]"] = u[basis.nodal_dofs[2]]
grid.cell_data["Von-Mises [MPa]"] = vm

p = pv.Plotter(shape=(1, 2))
p.subplot(0, 0)
p.add_text("Verschiebung z", font_size=10)
p.add_mesh(grid, scalars="Verschiebung z [mm]", show_edges=False)

p.subplot(0, 1)
p.add_text("Von-Mises-Spannung", font_size=10)
p.add_mesh(grid, scalars="Von-Mises [MPa]", show_edges=False)

p.link_views()
p.show()
