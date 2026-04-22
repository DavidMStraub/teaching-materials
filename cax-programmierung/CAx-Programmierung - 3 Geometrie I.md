---
marp: true
theme: hm
paginate: true
language: de
footer: CAx-Programmierung – D. Straub
headingDivider: 3
math: katex
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

## Aufgabe 1: Geometrie im B-Rep ablesen

### Startcode

```python
import build123d as bd
from build123d import Axis, Plane, Location, Vector
```

### 1.1 – Zylinder analysieren

Erstellen Sie einen Zylinder (`radius=15`, `height=30`) und geben Sie aus:

1. Für jede **Fläche**: `geom_type` und Flächeninhalt (`area`)
2. Für jede **Kante**: `geom_type` und Länge (`length`)

Beantworten Sie:
- Wie viele Kanten hat der Zylinder? Welche Geometrietypen kommen vor?
- Welche Kante hat `geom_type = LINE`? Was stellt sie geometrisch dar?

*Hinweise:* `.faces()`, `.edges()`, `.geom_type`, `.area`, `.length`

### 1.2 – Vergleich mit anderen Körpern

Erstellen Sie einen **Quader** (`Box(30, 20, 10)`) und eine **Kugel** (`Sphere(radius=10)`).

1. Welche `geom_type`-Werte kommen bei Flächen und Kanten vor?
2. Warum hat die Kugel nur **eine** Fläche? Überprüfen Sie es.
3. Vergleichen Sie mit dem Zylinder: Was haben alle drei gemein, was unterscheidet sie?

*Hinweise:* `set(f.geom_type for f in ...)`, `len(...)`

### 1.3 – Kegel

Erstellen Sie einen Kegel:

```python
kegel = bd.Cone(bottom_radius=20, top_radius=0, height=30)
```

1. Welchen `geom_type` hat die Mantelfläche? Was erwarten Sie – und warum?
2. Wie viele Kanten hat der Kegel? Welche Typen?
3. Vergleichen Sie mit dem Zylinder: Was fehlt beim Kegel und warum?

*Hinweise:* `.geom_type`, `.faces()`, `.edges()`

## Parametrische Darstellung

### Drei Darstellungsformen

Wie lässt sich ein geometrisches Objekt mathematisch beschreiben?

| Form | Kreis (Beispiel) | Problem |
|---|---|---|
| **Explizit** | $y = \pm\sqrt{R^2 - x^2}$ | mehrwertig; versagt bei senkrechter Tangente |
| **Implizit** | $x^2 + y^2 - R^2 = 0$ | schwer auszuwerten; kein natürlicher Startpunkt |
| **Parametrisch** | $x = R\cos u,\quad y = R\sin u$ | universell, eindeutig auswertbar |

> CAD-Systeme verwenden ausschließlich die **parametrische** Darstellung – für Kurven und Flächen.

### Was kann man damit anstellen?

Eine parametrische Kurve erlaubt geometrische **Anfragen**, die mit einer bloßen Formel nicht möglich wären:

- Punkt und Tangentenvektor bei beliebigem $u$: $\mathbf{C}(u)$, $\mathbf{C}'(u)$
- Bogenlänge zwischen zwei Parameterwerten
- Krümmung $\kappa(u)$
- Nächster Kurvenpunkt zu einem gegebenen Raumpunkt (Projektion)

```python
e.position_at(0.5)   # Punkt bei t = 0.5
e.tangent_at(0.5)    # Tangentenvektor dort
e.length             # Gesamtlänge
```

### Tangentenvektor

Eine Kurve im 3D-Raum als Funktion eines Parameters $u$:

$$\mathbf{C}(u) = \begin{pmatrix} x(u) \\ y(u) \\ z(u) \end{pmatrix}, \qquad u \in [u_{\min},\; u_{\max}]$$

Der **Tangentenvektor** gibt Richtung und Geschwindigkeit entlang der Kurve an:

$$\mathbf{T}(u) = \mathbf{C}'(u) = \frac{d\mathbf{C}}{du}$$

- **Richtung:** zeigt in die momentane Bewegungsrichtung
- **Länge** $|\mathbf{T}|$: „Geschwindigkeit“ im Parameterraum – hängt von der Parametrisierung ab

### Bogenlänge

Die **Bogenlänge** $s$ misst die tatsächlich zurückgelegte Weglänge entlang der Kurve:

$$s(u) = \int_{u_0}^{u} \bigl|\mathbf{C}'(\tilde{u})\bigr| \, d\tilde{u}, \qquad \frac{ds}{du} = |\mathbf{C}'(u)|$$

**Bogenlängenparametrisierung** ($s$ als Parameter):

$$\left|\frac{d\mathbf{C}}{ds}\right| = 1$$

→ Tangentenvektor hat immer Länge 1

→ Geometrisch „natürliche“ Parametrisierung; rechnerisch aufwändig

### Krümmung

Die **Krümmung** $\kappa$ misst, wie stark sich die Tangentenrichtung mit der zurückgelegten Weglänge ändert:

$$\kappa = \left|\frac{d^2\mathbf{C}}{ds^2}\right|$$

→ Bogenlängenparametrisierung

Für beliebige Parametrisierung (via Kettenregel + Lagrange-Identität):

$$\kappa(u) = \frac{|\mathbf{C}' \times \mathbf{C}''|}{|\mathbf{C}'|^3}$$

- $\kappa = 0$: Gerade  $\quad|\quad$  $\kappa = 1/R$: Kreis mit Radius $R$
- $R_K = 1/\kappa$: **Krümmungsradius** – Radius des anliegenden Kreises

![bg right:35% 90%](https://upload.wikimedia.org/wikipedia/commons/8/84/Osculating_circle.svg)

### Der Parameterraum

```
u:   0.0       0.25      0.5       0.75      1.0
     ●─────────●─────────●─────────●─────────●
     C(0)                C(½)               C(1)
```

- Der Parameter läuft **gleichmäßig** von $u_{\min}$ bis $u_{\max}$
- Die Punkte $\mathbf{C}(u)$ im Raum sind dabei **nicht gleichmäßig** verteilt
- **Kreis:** $u \in [0, 2\pi]$ – der Parameter entspricht dem Winkel

In build123d: `position_at(t)` mit $t \in [0, 1]$ liefert den Punkt, `tangent_at(t)` den Tangentenvektor.

### Parametrische Flächen

Flächen sind Funktionen von **zwei** Parametern $u$ und $v$:

$$\mathbf{S}(u, v) = \begin{pmatrix} x(u,v) \\ y(u,v) \\ z(u,v) \end{pmatrix}, \qquad u \in [u_0, u_1],\quad v \in [v_0, v_1]$$

Der **Normalenvektor** ergibt sich aus den Tangenten in $u$- und $v$-Richtung:

$$\mathbf{n}(u,v) = \frac{\partial \mathbf{S}}{\partial u} \times \frac{\partial \mathbf{S}}{\partial v}$$

→ Vorzeichen bestimmt, welche Seite „außen“ ist (erinnert an Orientierung aus VL2)

Die **Flächentypen** (Ebene, Zylinder, NURBS-Flächen, …) sind Thema von **Vorlesung 4**.

## Aufgabe 2: Parametrische Kurven erkunden

### 2.1 – Punkte auf einer Kreiskante

Nehmen Sie den Zylinder aus Aufgabe 1.1. Selektieren Sie eine Kreiskante und berechnen Sie `position_at` für $t \in \{0{,}0;\; 0{,}25;\; 0{,}5;\; 0{,}75\}$.

1. Auf welcher Höhe liegen die Punkte? Auf dem Deckel oder dem Boden?
2. Berechnen Sie die Abstände zwischen aufeinanderfolgenden Punkten. Sind sie gleich?
3. Erklärt das Ergebnis, warum der Parameter $t$ **nicht** dem Bogenmaß entspricht?

*Hinweise:* `.filter_by(bd.GeomType.CIRCLE)[0]`, `.position_at(t)`, `(p2 - p1).length`

### 2.2 – Tangente und Normalenrichtung

Berechnen Sie für dieselbe Kreiskante `tangent_at(t)` bei $t \in \{0{,}0;\; 0{,}25;\; 0{,}5;\; 0{,}75\}$.

1. In welche Richtung zeigt die Tangente bei $t = 0{,}0$? Macht das geometrisch Sinn?
2. Berechnen Sie den Radiusvektor (Richtung vom Kreismittelpunkt zum Punkt) und das Skalarprodukt mit der Tangente. Was ergibt sich – und warum?

*Hinweise:* `.tangent_at(t)`, `Vector(0, 0, z)`, `.dot()`, `.normalized()`

### 2.3 – Ellipse: gleichmäßiger Parameter, ungleichmäßige Punkte?

Erstellen Sie eine Ellipse und berechnen Sie 8 gleichmäßig verteilte Parameterpunkte:

```python
ellipse = bd.Edge.make_ellipse(x_radius=30, y_radius=15)
punkte = [ellipse.position_at(i / 8) for i in range(8)]
```

1. Berechnen Sie die Abstände zwischen aufeinanderfolgenden Punkten.
2. Sind die Abstände gleichmäßig? Was sagt das über die Parametrisierung aus?
3. Wo auf der Ellipse liegen die „dichteren" Punkte – bei großer oder kleiner Krümmung?

*Hinweise:* `(p2 - p1).length`, Folie „Parametrische Kurven"

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

## Aufgabe 3: Transformationen

### 3.1 – Reihenfolge von Drehen und Verschieben

Erstellen Sie einen Zylinder (`radius=10`, `height=20`) und führen Sie die gleichen Operationen in **unterschiedlicher Reihenfolge** durch:

- Variante A: 45° um die Z-Achse drehen, dann um $(30, 0, 0)$ verschieben
- Variante B: um $(30, 0, 0)$ verschieben, dann 45° um die Z-Achse drehen

1. Wo liegt der Mittelpunkt (`center()`) jeweils?
2. Erklären Sie anhand der Formel $\mathbf{T}\mathbf{R} \neq \mathbf{R}\mathbf{T}$ den Unterschied.

*Hinweise:* `.rotate(Axis.Z, winkel)`, `.move(Location((dx, dy, dz)))`, `.center()`

### 3.2 – Konstruktionsebene aus Fläche

Erstellen Sie einen Quader (`Box(40, 30, 10)`) und leiten Sie eine Konstruktionsebene von der **Oberseite** ab. Platzieren Sie darauf einen Zylinder (`radius=8`, `height=15`).

1. Wo liegt der Ursprung der abgeleiteten Ebene?
2. Verbinden Sie Quader und Zapfen. Wie viele Flächen hat der Gesamtkörper?
3. **Diskussion:** Was wäre der Nachteil, wenn Sie statt `Plane(oberseite)` direkt `Plane.XY.offset(5)` verwendet hätten?

*Hinweise:* `.faces().sort_by(Axis.Z).last`, `Plane(face)`, `ebene * bd.Cylinder(...)`, `+` oder `fuse`

### 3.3 – Spiegelung

Bauen Sie eine asymmetrische Form aus zwei Quadern (sie sollen nicht spiegelsymmetrisch sein). Spiegeln Sie die Form an `Plane.YZ` und verbinden Sie Original und Spiegelbild.

1. Überprüfen Sie, dass Original und Spiegelbild zusammen eine symmetrische Form ergeben.
2. Welche Flächen „verschwinden" beim Verbinden?

*Hinweise:* `.mirror(Plane.YZ)`, `bd.Pos(x, y) * ...`, `+`

## Kurventypen

### Analytische Kurven

Exakt durch eine geschlossene Formel beschreibbar:

| Typ | $\mathbf{C}(u)$ | `geom_type` | Vorkommen |
|---|---|---|---|
| Linie | $\mathbf{A} + u\,\mathbf{d}$ | `LINE` | Kanten eines Quaders |
| Kreis | $\mathbf{M} + R\bigl(\cos u\;\mathbf{e}_1 + \sin u\;\mathbf{e}_2\bigr)$ | `CIRCLE` | Kanten eines Zylinders |
| Ellipse | wie Kreis, aber $R_x \neq R_y$ | `ELLIPSE` | Kegelschnitte |

Für Standardkörper (`Box`, `Cylinder`, `Sphere`, …) reichen analytische Kurven vollständig aus.

### Trimming: wie wird eine Kurve endlich?

Analytische Kurven sind mathematisch **unbegrenzt** – eine Linie reicht von $-\infty$ bis $+\infty$.

Eine `Edge` ist immer ein **endliches Stück**: Kurve + Parameterintervall $[u_1,\, u_2]$

```
Geom_Line (unendlich):   ────────────────────────────────
                                  ↑             ↑
                                 u₁            u₂
Edge (getrimmt):                  ●─────────────●
```

→ Dasselbe Kreisobjekt steckt hinter einem Halbkreis-Edge wie hinter einem Viertelkreis –
nur das Intervall $[u_1, u_2]$ unterscheidet sie.


### Ellipse: variable Krümmung

$$\mathbf{C}(u) = \begin{pmatrix}a\cos u \\ b\sin u\end{pmatrix}, \qquad
\kappa(u) = \frac{ab}{\bigl(a^2\sin^2 u + b^2\cos^2 u\bigr)^{3/2}}$$

An den vier Scheitelpunkten:

| Stelle | $\kappa$ | $R_K = 1/\kappa$ |
|---|---|---|
| Ende der großen Halbachse ($u = 0°$) | $b/a^2$ | $a^2/b$ (flach) |
| Ende der kleinen Halbachse ($u = 90°$) | $a/b^2$ | $b^2/a$ (stark gebogen) |

→ Die Ellipse hat **keine** konstante Krümmung – im Gegensatz zum Kreis, und das entscheidet, wie Operationen wie Versatz oder Abrundung auf sie wirken.

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

$$R_{\text{offset}} = R + d$$

→ wieder ein Kreis!

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

## Aufgabe 4: Versatzkurven

### 4.1 – Versatz eines Kreises

Erstellen Sie einen freistehenden Kreis und berechnen Sie den Versatz:

```python
kreis = bd.Edge.make_circle(radius=20)
versatz = kreis.offset_2d(5)
```

1. Welchen `geom_type` haben die resultierenden Kanten? Was bedeutet das geometrisch?
2. Warum liefert `offset_2d` einen `Wire` (mehrere Kanten) statt einer einzelnen Kante?
3. Wie groß ist der Radius der Versatz-Kanten? Berechnen Sie ihn aus der Länge.

*Hinweise:* `.edges()`, `.geom_type`, `.length`, $r = l / (2\pi)$ (voller Kreis) oder $r = l / \pi$ (Halbkreis)

### 4.2 – Versatz einer Ellipse

Erstellen Sie eine Ellipse (`x_radius=30`, `y_radius=15`) und versetzen Sie sie um 5.

1. Welchen `geom_type` haben die resultierenden Kanten? Unterschied zu 4.1?
2. Warum ergibt der Versatz keine analytische Ellipse mehr? (Folie „Versatz einer Ellipse")
3. Vergrößern Sie den Versatz auf 20. Was passiert und warum?

*Hinweise:* `.offset_2d(d)`, `.edges()`, `.geom_type`

### Zusammenfassung

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

## Zusatzaufgabe: Lochkreis analysieren

### Ringscheibe mit Bohrungen

Erstellen Sie eine Ringscheibe mit 6 Bohrungen auf einem Lochkreis:

```python
import math

scheibe = bd.Cylinder(radius=40, height=8) - bd.Cylinder(radius=12, height=8)

for winkel in range(0, 360, 60):
    x = 28 * math.cos(math.radians(winkel))
    y = 28 * math.sin(math.radians(winkel))
    scheibe = scheibe - bd.Pos(x, y) * bd.Cylinder(radius=4, height=8)
```

### Geometrieanalyse

1. Wie viele Kanten hat die Scheibe? Welche Geometrietypen kommen vor und wie oft?
2. Selektieren Sie alle Kreiskanten und bestimmen Sie die verschiedenen **Radien**. Welche Radien erwarten Sie – und passen sie zu den Konstruktionsmaßen?
3. Verrunden Sie alle **oberen** Kreiskanten (Bohrungseintritt oben) mit `radius=0.5`.

*Hinweise:* `collections.Counter`, `.filter_by(bd.GeomType.CIRCLE)`, `.radius`,
`.filter_by_position(Axis.Z, minimum=..., maximum=...)`, `bd.fillet(..., radius=...)`
