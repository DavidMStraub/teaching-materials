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
3. Grundformen
4. Kurven
5. **Freiformgeometrie**
6. Profile
7. Codequalität
8. Datenaustausch
9. Robustheit
10. Simulation
11. Optimierung

## Freiformgeometrie

- Von Kontrollpunkten zu Freiformkurven: Bézier → B-Spline → NURBS
- Stetigkeit: $C^0$, $G^1$, $G^2$ – und wo sie wirklich zählt
- Freiformflächen: was Loft & Co. eigentlich erzeugen

*Durchgängiges Beispiel:* das Kühlkanal-Profil – Einlass- und Auslass-Querschnitt als Spline

### Rückblick: die analytische Familie ist zu klein

Letzte Woche: schon der Versatz einer **Ellipse** war keine Ellipse mehr (`OFFSET`).

Der **Kühlkanal** des Moduls braucht ein frei geformtes Profil – über Linie, Kreis und Ellipse hinaus:

- Bisher: Profile aus analytischen Kurven
- Heute: ein frei geformtes, glattes Profil

**Frage:** Wie beschreibt man eine *beliebige* glatte Kurve mathematisch?

## Theorie A: Von Kontrollpunkten zu B-Splines

### Warum Polynome – aber niedrigen Grades?

![bg right:30% 90%](assets/cax05_runge.svg)

Eine Kurve ist $\mathbf{C}(u) = (x(u), y(u), z(u))$ – welche Funktion?

| Ansatz | Problem |
|---|---|
| Lineare Interpolation | Knick an jedem Stützpunkt |
| Sinus/Kosinus | schwer zu verketten, teuer |
| Ein Polynom hohen Grades | Runge-Phänomen: Oszillation (rechts oben) |
| **Stückweise Polynome niedrigen Grades** | ✓ flexibel, stabil, lokal steuerbar |

→ Alle Freiformkurven (Bézier, B-Spline, NURBS) sind **stückweise Polynome niedrigen Grades**.

### Erster Ansatz: Potenzbasis

Koordinaten direkt als Polynom in $u$:

$$\mathbf{C}(u) = \mathbf{a}_0 + \mathbf{a}_1 u + \mathbf{a}_2 u^2 + \cdots + \mathbf{a}_n u^n$$

In der Praxis ungeeignet:

- **Kein geometrischer Bezug:** aus $\mathbf{a}_3$ liest man den Kurvenverlauf nicht ab
- **Numerisch empfindlich** bei hohem Grad
- **Ändern = Gleichungssystem lösen**, nicht per Hand

→ Gesucht: eine Basis, deren Parameter **selbst Punkte im Raum** sind.

### Bézier: Kontrollpunkte statt Koeffizienten

![bg right:25% 80%](assets/bezier_degrees.svg)

Renault, 1962 (Karosseriedesign). Kurve direkt über $n+1$ **Kontrollpunkte**:

$$\mathbf{C}(u) = \sum_{i=0}^{n} B_{i,n}(u)\, \mathbf{P}_i, \qquad B_{i,n}(u) = \binom{n}{i} u^i (1-u)^{n-i}, \quad u \in [0,1]$$

- $B_{i,n}$: **Bernstein-Basis** – nicht-negativ, $\sum_i B_{i,n} = 1$. Jeder Kurvenpunkt ist also ein gewichteter Mittelwert der Kontrollpunkte (**Konvexkombination**).
- Folge: Die Kurve liegt in der **konvexen Hülle** – dem kleinsten konvexen Polygon um alle Kontrollpunkte.
- Läuft durch $\mathbf{P}_0$ und $\mathbf{P}_n$; Tangente in $\mathbf{P}_0$: Richtung $\mathbf{P}_1 - \mathbf{P}_0$

### Die Grenzen der einzelnen Bézier-Kurve

Eine einzelne Bézier-Kurve über *alle* Punkte hat zwei Schwächen:

- **Grad = Punktzahl − 1:** 20 Punkte → Grad 19 → numerisch instabil, wellig
- **Globale Kontrolle:** jeder Punkt beeinflusst die **ganze** Kurve – kein lokales Anpassen

### Stückweise Bézier: Übergänge

**Ausweg:** die Kurve in **Segmente** teilen, jedes ein Bézier-Stück niedrigen Grades. Am Übergang trifft der letzte Kontrollpunkt $\mathbf{P}_3$ eines Segments auf den ersten $\mathbf{Q}_0$ des nächsten.

Wie glatt ist der Übergang?

- $C^0$: $\mathbf{Q}_0 = \mathbf{P}_3$ – kein Spalt
- $C^k$: zusätzlich stimmen die ersten $k$ **Ableitungen nach $u$** überein
- $G^1$: nur die **Richtung** der Tangente stimmt, ihre Länge darf springen

$C$ steht für die Parametrisierung, $G$ für die Geometrie: $G^1$ fragt nur, ob die Kurve glatt *aussieht*.

### Übergänge im Editor ausprobieren

[Piecewise Bézier Editor](https://davidstraub.de/teaching-apps/bezier-editor/) – stellen Sie **kubisch** ein, dann nacheinander $C^0$, $G^1$, $C^1$, $C^2$. Ziehen Sie jeweils einen Griff direkt neben einem Übergang.

| Bedingung | Was bewegt sich auf der anderen Seite des Übergangs mit? |
|---|---|
| $C^0$ | |
| $G^1$ | |
| $C^1$ | |
| $C^2$ | |

Wie viele der vier Kontrollpunkte eines Segments können Sie bei $C^2$ noch frei setzen?

### Der B-Spline: überlappende Fenster

![bg right:46% 92%](assets/bspline_fenster.svg)

Der **B-Spline** nimmt diese Buchhaltung ab: benachbarte Spannen teilen sich alle Kontrollpunkte **bis auf einen**.

- **Eine Bézier-Kurve:** eine Spanne, jeder Punkt wirkt überall
- **Stückweise Bézier:** eigene Punkte je Spanne, jeder Übergang von Hand
- **B-Spline:** überlappende Spannen → Stetigkeit entsteht **von selbst**

→ Automatische Stetigkeit *und* lokale Kontrolle, ohne Übergangsgleichungen.

### Die B-Spline-Formel

![bg right:38% 90%](assets/control_comparison.svg)

$$\mathbf{C}(u) = \sum_{i=0}^{n} \mathbf{P}_i\, N_{i,p}(u)$$

- $\mathbf{P}_i$ – die $n+1$ **Kontrollpunkte** (die Griffe)
- $N_{i,p}(u)$ – **Basisfunktionen** vom Grad $p$ (kubisch: $p = 3$): das Gewicht, mit dem $\mathbf{P}_i$ beim Parameter $u$ zieht
- jede $N_{i,p}$ ist nur über ein **Fenster** ungleich null → **lokale** Kontrolle (rechts: Bézier global, B-Spline lokal)
- $\sum_i N_{i,p}(u) = 1$ → Konvexkombination wie bei Bézier

### Der Knotenvektor

Was die $N_{i,p}$ überhaupt festlegt, ist der **Knotenvektor**:

$$U = (u_0 \le u_1 \le \dots \le u_m)$$

- eine **nicht-fallende** Folge von Parameterwerten, den **Knoten**
- die Knoten teilen die Parameterachse in **Spannen** und legen fest, **wo** jede $N_{i,p}$ ihr Fenster hat
- bei lauter verschiedenen Knoten ist eine Kurve vom Grad $p$ überall **$C^{p-1}$** – kubisch also $C^2$, der CAD-Standard
- ein Knotenwert darf **mehrfach** vorkommen; wie oft, heißt seine **Multiplizität**

### Knoten im Editor ausprobieren

[B-Spline-Editor](https://davidstraub.de/teaching-apps/bspline-editor/) – kubisch, unten die Basisfunktionen $N_{i,3}$ und die Knoten-Ticks

1. Ziehen Sie einen Kontrollpunkt. Welcher Teil der Kurve bewegt sich? Vergleichen Sie mit den Basisfunktionen.
2. **Sagen Sie zuerst voraus:** Was passiert an einer Stelle, an der zwei Knoten zusammenfallen? Und bei drei?
3. Probieren Sie es aus: Schieben Sie Knoten-Ticks aufeinander.

### Interpolation: Kurve durch gegebene Punkte

![bg right:33% 90%](assets/spline_interpolation.svg)

Kontrollpunkte sind Hebel – die Kurve läuft an ihnen vorbei. Oft liegen die Punkte aber **fest**: gemessen, aus einer Tabelle, aus einer Formel. Dann soll die Kurve **genau hindurch**.

Das ist **Interpolation**: Zu den Datenpunkten $\mathbf{Q}_i$ löst der Kern die passenden Kontrollpunkte $\mathbf{P}_i$ – ein lineares Gleichungssystem.

Rechts: die Kurve trifft jeden Datenpunkt (rot), die dafür berechneten Kontrollpunkte (blau) liegen woanders.

## Praktikum A: Kühlkanal-Querschnitt als Spline

### Aufgabe 1: Spline durch Punkte

Legen Sie eine Kurve durch fünf frei gewählte Punkte – einmal als **Spline**, einmal als **Polyline**.

1. Aus wie vielen Kanten bestehen beide, und welchen `geomType` haben die Kanten?
2. **Sagen Sie zuerst voraus:** Sie verschieben einen mittleren Punkt um 5 mm. Ändert sich der Spline nur in der Nähe dieses Punktes oder überall? Prüfen Sie es.
3. Passt das Ergebnis zur lokalen Kontrolle aus der Theorie?

*Hinweise:* `cf.spline`, `cf.polyline`, `.Edges()`, `e.geomType()`; beide Splines im Viewer übereinander zeigen

### Aufgabe 2: Der Einlass-Querschnitt

![bg right:40% 92%](assets/cax05_kuehlkanal.png)

Der Kühlkanal verjüngt sich vom Einlass zum Auslass (rechts; den Körper baut Einheit 6).

Bauen Sie den Einlass-Querschnitt als **geschlossene, glatte** Kurve aus etwa acht Punkten (Breite ≈ 50 mm, Höhe ≈ 14 mm) und daraus eine Fläche.

1. Prüfen Sie `IsClosed()` und den Flächeninhalt – plausibel ist ein Wert nahe $\frac{\pi}{4} \cdot 50 \cdot 14 \approx 550$ mm².
2. Vergleichen Sie mit `periodic=False` und dupliziertem Endpunkt: Wo entsteht der Knick?

*Hinweise:* `cf.spline(*pts, periodic=True)` – den Startpunkt am Ende **nicht** wiederholen; `cf.face`, `.IsClosed()`, `.Area()`

## Theorie B: NURBS, Stetigkeit, Flächen

### Ein exakter Kreis als B-Spline?

Ein B-Spline ist in jeder Spanne ein **Polynom** in $u$.

**Kann ein B-Spline einen exakten Kreis darstellen?** Begründen Sie Ihre Antwort.

*Tipp:* Was müsste für $x(u)^2 + y(u)^2$ gelten?

### NURBS: Kurven mit Gewichten

![bg right:36% 90%](assets/nurbs_circle.svg)

Jeder Kontrollpunkt bekommt ein **Gewicht** $h_i > 0$. Die Kurve wird ein Bruch zweier Polynome – eine **rationale** Kurve:

$$\mathbf{C}(u) = \frac{\sum_i h_i\, \mathbf{P}_i\, N_{i,p}(u)}{\sum_i h_i\, N_{i,p}(u)}$$

NURBS = **N**on-**U**niform **R**ational **B**-**S**pline.

Viertelkreis exakt: 3 Punkte, Gewichte $1, \tfrac{\sqrt2}{2}, 1$. Rechts: gleiche Punkte – mit gleichen Gewichten wölbt sich die Kurve, mit dem kleineren Gewicht in der Mitte trifft sie den Bogen exakt.

### NURBS ist die universelle Darstellung

**Linie ⊂ Bézier ⊂ B-Spline ⊂ NURBS**

Jede analytische Kurve ist ein NURBS-Spezialfall → **einheitlicher Standard** (CATIA, SolidWorks, NX, OCCT).

| `geomType` | Bedeutung |
|---|---|
| `LINE`, `CIRCLE`, `ELLIPSE` | analytisch, exakt gespeichert |
| `BSPLINE` | Freiformkurve (B-Spline / NURBS – dieselbe Klasse) |

Beim STEP-Import erscheinen Freiformkurven als `BSPLINE`, teils sogar ursprüngliche Kreise – je nach exportierendem System.

### Stetigkeit: $C^0$, $G^1$, $G^2$

![bg right:34% 95%](assets/cax05_stetigkeit.svg)

Aus Theorie A: $C$ fragt nach den Ableitungen nach $u$, $G$ nur nach der Geometrie. Beim Aneinanderstoßen von Kurven und Flächen zählen im CAD vor allem:

| Klasse | stimmt überein | sichtbar |
|---|---|---|
| $C^0$ | Position | Knick erlaubt |
| $G^1$ | Tangentenrichtung | glatt fürs Auge |
| $G^2$ | Krümmung | reflexionsglatt |

Rechts der **Krümmungskamm**: Striche senkrecht zur Kurve, ihre Länge ist proportional zur Krümmung.

### Wo Stetigkeit wirklich zählt

$G^2$ ist nicht überall nötig. Hier schon:

| Anwendung | warum $G^2$ |
|---|---|
| Optik / Design | Lichtreflexion folgt der Krümmung – ein Sprung ist sichtbar |
| Fertigung | Fräserbahn = Versatz der Fläche – Krümmungssprung → Maßfehler |
| Aerodynamik | Grenzschicht reagiert auf Krümmungsänderung |
| Kontakt / Implantate | Spannungsspitze genau am Krümmungssprung |

Faustregel: $C^0$ für boolesche Kanten, $G^2$ für Karosserie und Strömung.

### Von Kurven zu Flächen

![bg right:36% 92%](assets/cax05_flaeche.png)

Eine Fläche hat **zwei** Parameter:
$$\mathbf{S}(u, v) = \begin{pmatrix} x(u,v) \\ y(u,v) \\ z(u,v) \end{pmatrix}$$

Alles von den Kurven gilt eine Dimension höher weiter. Die **analytische Familie** (Ebene, Zylinder, Kegel, Kugel, Torus) reicht für Standardkörper – der Rest wird `BSPLINE`.

Hält man $u$ oder $v$ fest, entsteht eine Kurve auf der Fläche (rechts). Die Normale ist $\mathbf{S}_u \times \mathbf{S}_v$ (normiert) – genau das, was `normalAt()` berechnet.

### Was Loft erzeugt: `ruled` vs. glatt

![bg right:40% 90%](assets/loft_continuity.png)

Das **Eingangsprofil** bestimmt die Ausgabefläche. Loft hat zusätzlich eine Stetigkeits-Entscheidung:

```python
from cadquery import func as cf

secs = [cf.wire(cf.circle(10)),
        cf.wire(cf.circle(16)).moved(z=25),
        cf.wire(cf.circle(10)).moved(z=50)]

cf.loft(secs, ruled=True)    # ['CONE', 'CONE'] – Knick in der Mitte
cf.loft(secs, ruled=False)   # ['BSPLINE'] – eine glatte Fläche
```

`ruled=True`: gerade Verbindung, $C^0$ (Bézier-Analogon). Default glatt: eine B-Spline-Fläche über alle Schnitte.

### `fillet` ist ein Flächenerzeuger

```python
box = cf.box(50, 30, 20)
box_f = cf.fillet(box, box.edges(), 3.0)
print(sorted(set(f.geomType() for f in box_f.Faces())))
# ['CYLINDER', 'PLANE', 'SPHERE']
```

- Zylinderfläche entlang jeder gerundeten Kante
- Kugelfläche in jeder Ecke

Das ist dieselbe Verrundung wie seit Einheit 1 – jetzt sehen Sie, *welche* Flächen sie erzeugt.

### Welche Stetigkeit hat die Verrundung?

An `box_f` stößt eine ebene Seitenfläche an die Zylinderfläche der Verrundung ($r = 3$ mm).

**Welche Stetigkeit hat dieser Übergang?**

A) $C^0$ &nbsp;&nbsp; B) $G^1$ &nbsp;&nbsp; C) $G^2$

### Stetigkeit sehen: Zebra-Streifen

Der Reiter *Zebra* im Viewer spiegelt parallele Lichtstreifen auf der Oberfläche – wie die Leuchtröhren im Karosseriebau. An jedem Übergang zeigt der Streifenverlauf die Stetigkeit:

| Klasse | Streifen am Übergang |
|---|---|
| $C^0$ | reißen ab, versetzt |
| $G^1$ | laufen durch, mit Knick |
| $G^2$ | laufen glatt durch |

**Prüfen Sie Ihre Antwort:** Zeigen Sie `box_f`, `cf.loft(secs, ruled=True)` und `cf.loft(secs)` im Viewer und öffnen Sie den Reiter *Zebra*. Welche Stetigkeit hat jeder Übergang?

## Praktikum B: Auslass-Querschnitt und Kurveneigenschaften

### Aufgabe 3: Der Auslass-Querschnitt

Der Kanal verjüngt sich zum Auslass (gleichmäßige Flussverteilung). Bauen Sie den Auslass als zweiten Querschnitt:

- gleiche Form wie Ihr Einlass, aber nur **≈ 36 × 10 mm**
- **40 mm** über dem Einlass (`.moved(z=40)`) – so verbindet Einheit 6 beide per Loft

*Prüfen:* Fläche nahe $\frac{\pi}{4} \cdot 36 \cdot 10 \approx 280$ mm²; `BoundingBox().zmin` ≈ 40

### Aufgabe 4: Kurveneigenschaften auslesen

1. `geomType()` Ihrer Splines – und eines Kreises (`cf.circle`). Was fällt auf?
2. Tasten Sie `curvatureAt(t)` an 100 Stellen entlang Ihres Einlass-Profils ab. Wo ist die Krümmung am größten, und wie groß ist dort der Krümmungsradius?
3. Für die Strömung soll der Kanal nirgends enger als **R = 3 mm** gekrümmt sein. Erfüllt Ihr Profil das?

*Hinweise:* `for i in range(100):` mit `t = i / 100`, `max(...)`, `.positionAt(t)`

### Aufgabe 5 *(Zusatz)*: Profil glätten

Verschieben Sie Punkte Ihres Einlass-Profils, bis der kleinste Krümmungsradius **mindestens 3 mm** beträgt – bei unveränderter Breite und Höhe.

1. Welche Punkte bewirken am meisten?
2. Wie ändert sich dabei der Flächeninhalt?

## Abschluss

### Leseauftrag & Ausblick

- **Leseauftrag:** Buch Kapitel 6 ab „Building Curves from Control Points“
- **Wer mehr will:** einen Loft der beiden Profile schon vorab probieren (`cf.loft`) – und `ruled=True` vs. `False` vergleichen
- **Nächste Woche:** Profile – Sweep und Loft: die beiden Querschnitte werden zum verjüngten Kühlkanal (Loft), der Kanal läuft als Sweep durch die Platte
- Bis dahin: `w05/` (beide Profile) committet und gepusht
