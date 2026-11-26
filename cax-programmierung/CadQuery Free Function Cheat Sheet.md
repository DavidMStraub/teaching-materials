# CadQuery Cheat Sheet: Free Function API

```python
import cadquery as cq
from cadquery import func as cf
```

Längen in mm, Winkel in Grad.

## Grundkörper

| Aufruf | Lage |
|:---|:---|
| `cf.box(w, l, h)` | in X und Y zentriert, Unterseite auf z = 0 |
| `cf.cylinder(d, h)` | Achse Z, Grundfläche im Ursprung zentriert |
| `cf.cone(d, h)` · `cf.cone(d1, d2, h)` | wie Zylinder; Spitze bzw. Durchmesser `d2` bei z = h |
| `cf.sphere(d)` | Mittelpunkt im Ursprung |
| `cf.torus(d1, d2)` | Mittelpunkt im Ursprung, Achse Z |

`cylinder`, `cone`, `sphere` und `torus` erwarten **Durchmesser**.

## Kurven und Profile

Alle Kurven liegen in der XY-Ebene, um den Ursprung zentriert.

| Aufruf | Ergebnis |
|:---|:---|
| `cf.segment(p1, p2)` | Strecke (Edge) |
| `cf.circle(r)` · `cf.circle(r, start, end)` | Kreis bzw. Kreisbogen (Edge), **Radius** |
| `cf.ellipse(r1, r2)` | Ellipse (Edge), Halbachsen in X und Y |
| `cf.spline(p1, p2, …, periodic=False)` | B-Spline durch die Punkte (Edge) |
| `cf.polyline(p1, p2, …)` | offener Linienzug (Wire) |
| `cf.polygon(p1, p2, …)` | geschlossener Linienzug (Wire) |
| `cf.rect(w, h)` | Rechteck (Wire) |
| `cf.vertex(x, y, z)` | Punkt (Vertex) |
| `cf.wire(e1, e2, …)` | Kanten zu einem Kantenzug (Wire) |
| `cf.face(w)` | ebene Fläche aus geschlossenem Wire (Face) |
| `cf.offset2D(w, t)` | Versatz eines Wires um `t` (Wire); `t < 0` nach innen |
| `cf.compound(s1, s2, …)` | Sammlung (Compound) |

## Vom Profil zum Körper

| Aufruf | Wirkung |
|:---|:---|
| `cf.extrude(face, (dx, dy, dz))` | Profil entlang Vektor ziehen |
| `cf.revolve(face, p, d, winkel)` | Profil um Achse durch `p` mit Richtung `d` drehen |
| `cf.loft([w1, w2, …], cap=False, ruled=False)` | Fläche durch Querschnitte; `cap=True` schließt zum Körper, `ruled=True` verbindet geradlinig |
| `cf.sweep(profil, pfad)` | Profil entlang Pfad |
| `cf.sweep(…, transition="round")` | Pfadecken: `"transformed"` (Standard), `"round"`, `"right"` |

## Boolean und Features

| Aufruf | Wirkung |
|:---|:---|
| `a + b` · `a - b` · `a * b` | Vereinigung · Differenz · Schnitt |
| `cf.fillet(s, kanten, r)` | Kanten verrunden |
| `cf.chamfer(s, kanten, d)` | Kanten fasen |
| `s.mirror("YZ", basePointVector=(0, 0, 0))` | an Ebene spiegeln (`"XY"`, `"XZ"`, `"YZ"`) |

## Lage: Location und Plane

| Aufruf | Wirkung |
|:---|:---|
| `cf.Location((x, y, z))` | Verschiebung |
| `cf.Location((x, y, z), (rx, ry, rz))` | erst Drehung um X, Y, Z (um den Ursprung), dann Verschiebung |
| `loc1 * loc2` | `loc2` im Koordinatensystem von `loc1` |
| `cf.Plane(origin=(x, y, z), normal=(nx, ny, nz))` | Ebene; `cf.Location(ebene)` legt ein Teil darauf |
| `s.moved(loc)` | Kopie von `s` an neuer Lage |
| `s.moved(x=…, y=…, z=…, rx=…, ry=…, rz=…)` | wie `cf.Location`: erst Drehung, dann Verschiebung |

Jedes weitere `.moved(…)` wirkt im globalen Koordinatensystem:
`s.moved(rz=90).moved(x=40)` dreht zuerst und verschiebt dann.

## Topologie und Selektoren

| Aufruf | Ergebnis |
|:---|:---|
| `s.Solids()` `s.Shells()` `s.Faces()` `s.Wires()` `s.Edges()` `s.Vertices()` | **Liste** der Teilelemente |
| `s.faces("…")` · `s.edges("…")` · `s.vertices("…")` | **Shape** (ein Element oder Compound), als Argument für `fillet`, `chamfer` usw. |
| `s.ShapeType()` | `"Solid"`, `"Face"`, `"Edge"`, … |
| `f.geomType()` | Typ der Geometrie, siehe unten |

**Selektor-Strings**

| String | Auswahl |
|:---|:---|
| `">Z"` · `"<Z"` | Element mit größtem · kleinstem Z |
| `"\|Z"` | Kanten parallel zu Z · Flächen mit Normale parallel zu Z |
| `"#Z"` | Kanten senkrecht zu Z · Flächen mit Normale senkrecht zu Z |
| `"+Z"` · `"-Z"` | Flächennormale zeigt in +Z · −Z |
| `"%CIRCLE"` · `"%PLANE"` … | Geometrietyp |
| `"and"` · `"or"` · `"not"` | verknüpfen, z. B. `">Z and %CIRCLE"` |

**Geometrietypen**

- Edge: `LINE`, `CIRCLE`, `ELLIPSE`, `BEZIER`, `BSPLINE`, `OFFSET`, …
- Face: `PLANE`, `CYLINDER`, `CONE`, `SPHERE`, `TORUS`, `BEZIER`, `BSPLINE`, `REVOLUTION`, `EXTRUSION`, `OFFSET`, …

## Messen und prüfen

| Aufruf | Ergebnis |
|:---|:---|
| `s.Volume()` · `s.Area()` | Volumen · Oberfläche |
| `s.Center()` | Schwerpunkt (Vector) |
| `s.BoundingBox()` | `.xmin` `.xmax` `.xlen` … `.zlen` |
| `s.isValid()` | Topologie und Geometrie konsistent |
| `s.distance(t)` | kleinster Abstand zweier Shapes |
| `f.normalAt()` · `f.normalAt(p)` | Flächennormale (nach außen) |

**Kurven** (Edge oder Wire); `d` ist der Anteil der Bogenlänge, 0 bis 1:

| Aufruf | Ergebnis |
|:---|:---|
| `e.Length()` · `e.radius()` | Bogenlänge · Radius (nur Kreis) |
| `e.positionAt(d)` · `e.tangentAt(d)` | Punkt · Einheitstangente |
| `e.curvatureAt(d)` | Krümmung κ |
| `e.locationAt(d)` | Koordinatensystem auf der Kurve (z. B. für Sweep-Profil) |
| `e.paramAt(d)` | Rohparameter der Kurve an dieser Stelle |

Mit `mode="parameter"` statt Bogenlänge: z. B. `e.positionAt(t, mode="parameter")`.

## Baugruppen und Export

| Aufruf | Wirkung |
|:---|:---|
| `assy = cq.Assembly(name="…")` | leere Baugruppe (Wurzel) |
| `assy.add(teil, name="…", loc=…)` | Teil oder Unterbaugruppe anhängen; optional `color=cq.Color("red")` |
| `assy.constrain("a", fa, "b", fb, "Plane")` · `assy.solve()` | Lage über Constraint |
| `assy.export("datei.step")` | Format aus der Endung (STEP, STL, GLTF, …) |
| `cq.Assembly.load("a.step")` | STEP-Datei als Baugruppe einlesen |
| `s.exportStep("datei.step")` | exakte Geometrie (B-Rep) |
| `s.exportStl("datei.stl", tolerance=…, angularTolerance=…)` | Dreiecksnetz |
| `cq.exporters.export(s, "datei.dxf")` | Format aus der Endung (DXF, 3MF, SVG, …) |
| `s.tessellate(tol, winkel_tol)` | Netz: (Punktliste, Liste von Index-Tripeln) |
