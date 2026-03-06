---
marp: true
theme: hm
paginate: true
language: de
footer: CAx-Programmierung – D. Straub
headingDivider: 3
jupyter:
  jupytext:
    cell_metadata_filter: -all
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.17.3
  kernelspec:
    display_name: Python 3
    language: python
    name: python3
---

# Programmierung von CAx-Systemen

David Straub

### Gliederung

1. Einführung
2. Topologie
3. **Geometrie**
4. Modellierungsstrategien
5. Datenaustausch
6. Simulation
7. Optimierung
8. Fertigung

## Geometrie I: Kurven und Koordinatensysteme

- Geometrie im B-Rep
- Parametrische Darstellung
- Koordinatensysteme und Transformationen
- Analytische Kurven: Linie, Kreis, Ellipse
- Beispiel: Versatz einer Kurve

## Rückblick: Geometrie im B-Rep

### Was steckt hinter einer Kante?

Letzte Vorlesung: das B-Rep-Gerüst

```
Solid → Shell → Face → Wire → Edge → Vertex
```

Topologie beschreibt die **Struktur** – aber noch nicht die Form.

**Geometrie beantwortet:** *wo* und *wie* liegt ein Element im Raum?

| Topologieelement | trägt als Geometrie |
|---|---|
| `Vertex` | Punkt $(x,\, y,\, z)$ |
| `Edge` | parametrische **Kurve** $\mathbf{C}(u)$ + Parameterintervall $[u_1, u_2]$ |
| `Face` | parametrische **Fläche** $\mathbf{S}(u,v)$ + Parameterbereich |

### Geometrie im B-Rep ablesen

`geom_type` verrät, welche Geometrie OCCT einem Element intern zuordnet:

| Element | `geom_type` | charakteristische Größe |
|---|---|---|
| Kreiskante (Deckel/Boden) | `CIRCLE` | Radius, Mittelpunkt |
| Nahtkante (Mantellinie) | `LINE` | Richtungsvektor |
| Mantelfläche | `CYLINDER` | Achse, Radius |
| Deckel-/Bodenfläche | `PLANE` | Normalenvektor, Ursprung |

```python
zyl = bd.Cylinder(radius=10, height=20)
for e in zyl.edges():
    print(e.geom_type, round(e.length, 2))
# → CIRCLE 62.83  /  CIRCLE 62.83  /  LINE 20.0
```

## Parametrische Darstellung

### Drei Darstellungsformen

Wie lässt sich ein geometrisches Objekt mathematisch beschreiben?

| Form | Kreis (Beispiel) | Problem |
|---|---|---|
| **Explizit** | $y = \pm\sqrt{R^2 - x^2}$ | mehrwertig; versagt bei senkrechter Tangente |
| **Implizit** | $x^2 + y^2 - R^2 = 0$ | schwer auszuwerten; kein natürlicher Startpunkt |
| **Parametrisch** | $x = R\cos u,\quad y = R\sin u$ | universell, eindeutig auswertbar |

> CAD-Systeme verwenden ausschließlich die **parametrische** Darstellung – für Kurven und Flächen.

### Parametrische Kurven

Eine Kurve im 3D-Raum als Funktion eines Parameters $u$:

$$\mathbf{C}(u) = \begin{pmatrix} x(u) \\ y(u) \\ z(u) \end{pmatrix}, \qquad u \in [u_{\min},\; u_{\max}]$$

**Abgeleitete Größen:**

- **Tangentenvektor:** $\quad\mathbf{T}(u) = \mathbf{C}'(u) = \dfrac{d\mathbf{C}}{du}$

  Richtung und „Geschwindigkeit" entlang der Kurve

- **Krümmung:** $\quad\kappa(u) = \dfrac{|\mathbf{C}' \times \mathbf{C}''|}{|\mathbf{C}'|^3}$

  Wie stark biegt die Kurve? Kehrwert des Krümmungsradius.

### Der Parameterraum

```
u:   0.0       0.25      0.5       0.75      1.0
     ●─────────●─────────●─────────●─────────●
     C(0)                C(½)               C(1)
```

- Der Parameter läuft **gleichmäßig** von $u_{\min}$ bis $u_{\max}$
- Die Punkte $\mathbf{C}(u)$ im Raum sind dabei **nicht gleichmäßig** verteilt
- **Kreis:** $u \in [0, 2\pi]$ – der Parameter entspricht dem Winkel

In build123d: `position_at(s)` mit $s \in [0, 1]$ liefert den Punkt, `tangent_at(s)` den Tangentenvektor.

### Parametrische Flächen

Flächen sind Funktionen von **zwei** Parametern $u$ und $v$:

$$\mathbf{S}(u, v) = \begin{pmatrix} x(u,v) \\ y(u,v) \\ z(u,v) \end{pmatrix}, \qquad u \in [u_0, u_1],\quad v \in [v_0, v_1]$$

Der **Normalenvektor** ergibt sich aus den Tangenten in $u$- und $v$-Richtung:

$$\mathbf{n}(u,v) = \frac{\partial \mathbf{S}}{\partial u} \times \frac{\partial \mathbf{S}}{\partial v}$$

→ Vorzeichen bestimmt, welche Seite „außen" ist (erinnert an Orientierung aus VL2)

Die **Flächentypen** (Ebene, Zylinder, NURBS-Flächen, …) sind Thema von **Vorlesung 4**.

## Koordinatensysteme und Transformationen

### Vektoren, Achsen, Ebenen

Drei Grundobjekte für die Arbeit im Raum:

| Klasse | Bedeutung | Beispiel |
|---|---|---|
| `Vector` | Punkt oder freier Vektor | `Vector(1, 2, 3)` |
| `Axis` | Ursprung + Richtung (Achse) | `Axis((0,0,0), (0,0,1))` |
| `Plane` | Ebene: Ursprung + Orientierung | `Plane.XY` |

Auf `Vector` sind die üblichen Operationen definiert: Addition, Skalierung, Länge (`v.length`), Normierung, Skalarprodukt (`v.dot(w)`), Kreuzprodukt (`v.cross(w)`).

### Standardachsen und Standardebenen

Vordefinierte Achsen: `Axis.X`, `Axis.Y`, `Axis.Z` (Weltkoordinatensystem)

Vordefinierte Ebenen:

| Ebene | Normalenrichtung | Verwendung |
|---|---|---|
| `Plane.XY` | $z$-Achse | Standard-Skizzierebene |
| `Plane.XZ` | $y$-Achse | Frontansicht |
| `Plane.YZ` | $x$-Achse | Seitenansicht |

Benutzerdefiniert:
- `Axis((5, 3, 0), (0, 0, 1))` – Achse durch beliebigen Punkt
- `Plane(origin=(0,0,10), z_dir=(1,0,0))` – Ebene mit beliebiger Normalen

### Location: Lage eines Objekts im Raum

Jedes Objekt hat eine **Location** – seine Position und Orientierung im Weltkoordinatensystem.

Eine Location kodiert:
- **Translation:** Verschiebung $(dx,\, dy,\, dz)$
- **Rotation:** Orientierung (als Quaternion / Rotationsmatrix gespeichert)

> Location ist das lokale **Koordinatensystem** eines Objekts relativ zur Welt.

Kann aus einem Punkt (`Location((20, 10, 5))`) oder aus einer Ebene (`Location(Plane.XZ)`) erzeugt werden.

### Transformationen

| Operation | Methode |
|---|---|
| Verschiebung | `obj.move(Location((dx, dy, dz)))` |
| Drehung | `obj.rotate(Axis.Z, winkel_grad)` |
| Spiegelung | `obj.mirror(Plane.XZ)` |
| Skalierung | `obj.scale(faktor)` |

**Wichtig:** Jede Transformation liefert ein **neues Objekt** – das Original bleibt unverändert.

Transformationen lassen sich verketten:
`zyl.rotate(Axis.Z, 30).move(Location((20, 0, 0)))`

### Drehungen im Raum

Eine Drehung im 3D-Raum ist durch **Achse + Winkel** vollständig beschrieben:

$$\text{Drehung} = \bigl(\hat{\mathbf{e}},\; \varphi\bigr)$$

- $\hat{\mathbf{e}}$: Einheitsvektor der Drehachse (beliebig im Raum)
- $\varphi$: Drehwinkel (im Uhrzeigersinn von oben, Rechte-Hand-Regel)

Intern wird daraus eine **Rotationsmatrix** $\mathbf{R} \in \mathbb{R}^{3\times 3}$ berechnet, die auf jeden Punkt angewendet wird: $\mathbf{p}' = \mathbf{R}\,\mathbf{p}$

```python
# Drehung um die Z-Achse, 45°
zyl.rotate(Axis.Z, 45)

# Drehung um eine beliebige Achse durch Punkt (5, 0, 0)
zyl.rotate(Axis((5, 0, 0), (0, 0, 1)), 30)
```

### Reihenfolge von Transformationen

Translationen **kommutieren** – die Reihenfolge ist egal:

$$\mathbf{T}_1\,\mathbf{T}_2 = \mathbf{T}_2\,\mathbf{T}_1$$

Rotationen **kommutieren nicht** – die Reihenfolge ist entscheidend:

$$\mathbf{R}_x\,\mathbf{R}_z \neq \mathbf{R}_z\,\mathbf{R}_x$$

Rotation + Translation **kommutieren ebenfalls nicht**:

$$\mathbf{T}\,\mathbf{R} \neq \mathbf{R}\,\mathbf{T}$$

→ Bei verketteten Transformationen immer auf die **Reihenfolge** achten.

### Ebene aus einer Fläche

Ein besonders nützliches Muster: Konstruktionsebene direkt aus einer vorhandenen Fläche ableiten.

```python
ebene = Plane(oberseite)   # Ursprung + Orientierung der Fläche
```

Die Ebene übernimmt automatisch den Flächenmittelpunkt als Ursprung und die Flächennormale als $z$-Richtung.

**Anwendung:** Bohrung senkrecht auf einer schrägen Fläche – die Skizze wird auf der Fläche platziert, unabhängig von deren Lage im Raum.

## Kurventypen

### Analytische Kurven

Exakt durch eine geschlossene Formel beschreibbar:

| Typ | $\mathbf{C}(u)$ | `geom_type` | Vorkommen |
|---|---|---|---|
| Linie | $\mathbf{A} + u\,\mathbf{d}$ | `LINE` | Kanten eines Quaders |
| Kreis | $\mathbf{M} + R\bigl(\cos u\;\mathbf{e}_1 + \sin u\;\mathbf{e}_2\bigr)$ | `CIRCLE` | Kanten eines Zylinders |
| Ellipse | wie Kreis, aber $R_x \neq R_y$ | `ELLIPSE` | Kegelschnitte |

Für Standardkörper (`Box`, `Cylinder`, `Sphere`, …) reichen analytische Kurven vollständig aus.

### Krümmung einer Kurve

Die **Krümmung** $\kappa$ beschreibt, wie stark sich eine Kurve biegt:

$$\kappa(u) = \frac{1}{R_K(u)} = \frac{|\mathbf{C}' \times \mathbf{C}''|}{|\mathbf{C}'|^3}$$

- $R_K$: **Krümmungsradius** – Radius des anliegenden Kreises
- Gerade: $\kappa = 0$ (unendlich flach)
- Kreis (Radius $R$): $\kappa = 1/R$ überall **konstant**

Die Krümmungsverteilung entscheidet, wie geometrische Operationen (Versatz, Abrundung, Sweep) auf eine Kurve wirken.

### Ellipse: variable Krümmung

$$\mathbf{C}(u) = \begin{pmatrix}a\cos u \\ b\sin u\end{pmatrix}, \qquad
\kappa(u) = \frac{ab}{\bigl(a^2\sin^2 u + b^2\cos^2 u\bigr)^{3/2}}$$

An den vier Scheitelpunkten:

| Stelle | $\kappa$ | $R_K = 1/\kappa$ |
|---|---|---|
| Ende der großen Halbachse ($u = 0°$) | $b/a^2$ | $a^2/b$ (flach) |
| Ende der kleinen Halbachse ($u = 90°$) | $a/b^2$ | $b^2/a$ (stark gebogen) |

→ Die Ellipse hat **keine** konstante Krümmung – im Gegensatz zum Kreis.

## Beispiel: Versatz einer Kurve

### Was ist ein Versatz (Offset)?

Eine **Versatzkurve** entsteht, indem jeder Punkt der Originalkurve um eine konstante Distanz $d$ entlang des Normalenvektors verschoben wird:

$$\mathbf{C}_{\text{offset}}(u) = \mathbf{C}(u) + d \cdot \hat{\mathbf{n}}(u)$$

**Typische CAD-Anwendungen:**
- Wanddicke bei Dünnwandteilen
- Freiraum um ein Bauteil (Kollisionsprüfung)
- Werkzeugpfad beim Fräsen

### Versatz eines Kreises

Kreis (Radius $R$): alle Normalen zeigen durch den **Mittelpunkt** → der Versatz verschiebt den Radius gleichmäßig.

$$R_{\text{offset}} = R + d \quad \longrightarrow \quad \text{wieder ein Kreis!}$$

**Grund:** Konstante Krümmung → Normalen drehen gleichmäßig → Versatz ändert nur den Radius.

### Versatz einer Ellipse

Ellipse ($a = 30$, $b = 15$): Normalen drehen **ungleichmäßig** – die Krümmung variiert.

Die Versatzkurve lässt sich nicht als $a'\cos u,\; b'\sin u$ schreiben:

```python
ellipse = bd.Edge.make_ellipse(x_radius=30, y_radius=15)
offset  = ellipse.offset_2d(5)
for e in offset.edges():
    print(e.geom_type)   # → OFFSET
```

OCCT berechnet den Versatz numerisch als **Offset-Kurve** – keine analytische Ellipse mehr.

### Warum ist die Versatzkurve keine Ellipse mehr?

Bei konstanter Krümmung (Kreis) wirkt der Versatz überall gleich.
Bei **variabler Krümmung** (Ellipse) wirkt er ungleichmäßig:

- Stark gebogene Stellen (kleiner $R_K$): Versatz „staucht“ die Kurve
- Flache Stellen (großer $R_K$): Versatz ändert die Form kaum

> Geometrische Operationen erzeugen häufig Kurven **höherer Komplexität** als die Eingabe —
> selbst bei einfachen Ausgangskurven.

Daher brauchen CAD-Systeme eine Darstellung, die **beliebige** glatte Kurven beschreiben kann.

## Zusammenfassung

### Kernkonzepte dieser Vorlesung

- `Edge` trägt eine Kurve $\mathbf{C}(u)$, `Face` trägt eine Fläche $\mathbf{S}(u,v)$
- Parametrische Darstellung: universell, eindeutig auswertbar
- Tangente $\mathbf{C}'(u)$ und Krümmung $\kappa = 1/R_K$ aus Ableitungen
- `Vector`, `Axis`, `Plane`, `Location` – räumliches Handwerkszeug; Transformationen erzeugen neue Objekte
- Analytische Kurven (Linie, Kreis, Ellipse): exakt, aber begrenzt
- Geometrische Operationen erzeugen komplexere Geometrie: Versatz einer Ellipse → keine Ellipse mehr

### Ausblick: Geometrie II

- **Freiformkurven:** Bézier, B-Spline, NURBS
- **Stetigkeitsbedingungen:** $C^0 / C^1 / C^2$ beim Verbinden von Kurven
- **Flächen:** analytisch, Sweep-Flächen, NURBS-Flächen
- **Geometrische Anfragen:** Projektion, Abstand, Schnittpunkte


