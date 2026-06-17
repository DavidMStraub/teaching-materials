---
marp: true
theme: hm
paginate: true
html: true
language: de
footer: CAx-Programmierung – D. Straub
headingDivider: 3
---

# Programmierung von CAx-Systemen

David Straub

### Gliederung

1. Einführung
2. Topologie
3. Geometrie
4. Modellierungsstrategien
5. **Datenaustausch**
6. Meshing
7. Simulation
8. Optimierung

## Datenaustausch

- **STEP:** Industriestandard für CAD-Interoperabilität
- **BREP:** Natives OpenCASCADE-Format zum Zwischenspeichern

## Überblick: Dateiformate

### Welches Format wofür?

| Format | Typ | Inhalt | Anwendungsfall |
|--------|-----|--------|----------------|
| **STEP** | 3D B-Rep | Exakte Geometrie, Farben, Labels | Austausch mit anderen CAD-Programmen |
| **BREP** | 3D B-Rep | Exakte OpenCASCADE-Geometrie | Zwischenspeichern, build123d-intern |
| **DXF / SVG** | 2D Vektor | Linien, Bögen (keine Bemaßung) | 2D-Weiterverarbeitung |
| STL | 3D Mesh | Dreiecksnetze (verlustbehaftet) | 3D-Druck → *siehe Einheit Meshing* |

> **B-Rep-Formate** erhalten exakte Geometrie (Kurven, Flächen) –
> Mesh-Formate approximieren sie durch Dreiecke.

## STEP

### STEP – Standard for the Exchange of Product Model Data

**ISO 10303** – universeller Austauschstandard für CAD-Daten

- Exakte Geometrie (Kurven, Flächen, Volumenkörper)
- Produktstruktur: Baugruppen mit Unterkomponenten
- Metadaten: **Farben**, **Labels**, Maßeinheiten
- Unterstützt von allen professionellen CAD-Systemen (FreeCAD, Fusion 360, CATIA, …)

> **Faustregel:** STEP verwenden, wenn das Modell in einem anderen CAD-Programm weiterbearbeitet werden soll.

### STEP exportieren

```python
from pathlib import Path
from build123d import Cylinder, Color, Shape, export_step

def exportiere_welle(radius: float, laenge: float, pfad: Path) -> bool:
    welle = Cylinder(radius, laenge)
    welle.color = Color("steelblue")
    welle.label = "Welle"
    return export_step(welle, pfad)

exportiere_welle(10, 80, Path("welle.step"))
```

### STEP – Baugruppe exportieren

```python
from pathlib import Path
from build123d import Box, Compound, Color, Location, Align, export_step

def baue_gehaeuse(l: float, b: float, h: float) -> Compound:
    deckel = Box(l, b, 5)
    deckel.color = Color("lightgrey")
    deckel.label = "Deckel"

    korpus = Box(l, b, h, align=(Align.CENTER, Align.CENTER, Align.MIN))
    korpus.color = Color("darkgrey")
    korpus.label = "Korpus"

    baugruppe = Compound(children=[deckel.moved(Location((0, 0, h))), korpus])
    baugruppe.label = "Gehäuse"
    return baugruppe

export_step(baue_gehaeuse(60, 40, 30), Path("gehaeuse.step"))
```

→ FreeCAD / Fusion 360 öffnet die Baugruppe mit Farben und Bauteilnamen.

### STEP importieren

```python
from pathlib import Path
from build123d import Compound, import_step

def lade_baugruppe(pfad: Path) -> Compound:
    return import_step(pfad)

modell: Compound = lade_baugruppe(Path("gehaeuse.step"))

for teil in modell.children:
    print(f"{teil.label}: {teil.bounding_box().size}")
```

> `import_step` liefert immer ein `Compound` –
> auch wenn die Datei nur einen einzigen Körper enthält.

## BREP

### BREP – Boundary Representation

**OpenCASCADE-natives Format** – verlustfrei und schnell

- Speichert exakt die interne Datenstruktur von build123d / OpenCASCADE
- Kein Informationsverlust, keine Konvertierung
- **Kein** Industriestandard → nur für den Eigenbedarf

**Typischer Einsatz:**
- Zwischenergebnisse langer Berechnungen speichern (Caching)
- Debugging: Modellzustand zu einem bestimmten Schritt festhalten

### BREP vs. STEP

| | BREP | STEP |
|-|------|------|
| Geometrie | ✅ exakt (keine Konvertierung) | ✅ exakt (standardisiert) |
| Kompatibilität | ❌ nur OpenCASCADE | ✅ universell |
| Farben / Labels | ❌ nein | ✅ ja |
| Geschwindigkeit | ✅ sehr schnell | etwas langsamer |

STEP ist ebenfalls exakt – aber BREP überspringt die Konvertierung in das STEP-Format vollständig.
Kein Rundungsfehler, keine Toleranzentscheidung, keine Neuinterpretation.

### BREP exportieren und importieren

```python
from pathlib import Path
from build123d import Sphere, Shape, export_brep, import_brep

def speichere(form: Shape, pfad: Path) -> bool:
    return export_brep(form, pfad)

def lade(pfad: Path) -> Shape:
    return import_brep(pfad)

speichere(Sphere(25), Path("kugel.brep"))
kugel: Shape = lade(Path("kugel.brep"))
```

### BREP – Caching

```python
from pathlib import Path
from build123d import Box, Cylinder, Location, Shape, export_brep, import_brep

def berechne_lochplatte(n: int) -> Shape:
    platte: Shape = Box(200, 200, 10)
    for i in range(n):
        x, y = (i % 10) * 20 - 90, (i // 10) * 20 - 90
        platte -= Cylinder(4, 12).moved(Location((x, y, 0)))
    return platte
def lade_oder_berechne(cache: Path) -> Shape:
    if cache.exists():
        return import_brep(cache)
    ergebnis: Shape = berechne_lochplatte(n=50)
    export_brep(ergebnis, cache)
    return ergebnis

platte = lade_oder_berechne(Path("lochplatte.brep"))
```

> Zweiter Aufruf: sofort – die Geometrie wird nicht neu berechnet.

## Praktikum

### Too Tall Toby – Modellierungsaufgaben

**Too Tall Toby (TTT)** ist eine bekannte Serie von CAD-Speedmodeling-Aufgaben.
Jede Aufgabe zeigt eine technische Zeichnung – das Ziel ist, das Bauteil nachzubauen und die angegebene Masse zu treffen.

**Regeln:**
- ❌ Keine Builder API (`with BuildPart()`) – nur Algebra-Modus
- ❌ Keine Referenzimplementierung anschauen
- ✅ Konstanten für alle Maße

### Schema

```python
from build123d import ...         # Importe
from ocp_vscode import show

HOEHE = 133.0                     # Konstanten
...

teil = ...                        # Implementierung

show(teil)                        # Visualisierung

dichte = 1020 / 1e6
assert abs(teil.volume * dichte - 57.08) < 1
```

### Aufgabe 1: Paste Sleeve

![bg right:45% 90%](https://build123d.readthedocs.io/en/latest/_images/ttt-ppp0105.png)

[build123d.readthedocs.io → TTT → Party Pack 01-05](https://build123d.readthedocs.io/en/latest/tttt.html#ttt-ppp0105)

- Material: ABS (ρ = 1,02 g/cm³)
- Ziel: **57,08 g** (Toleranz ±1 g)

### Aufgabe 1: Hinweise

**Nützliche Operationen:**
- `SlotOverall(length, diameter)` – Langloch-Profil (Länge Mitte-Mitte + Durchmesser)
- `loft([sketch1, sketch2])` – Übergang zwischen zwei Profilen
- `offset(amount=...)` – Profil nach außen vergrößern
- `Plane.XY.offset(z)` – verschobene Arbeitsebene

**Vorgehen:**
1. Äußere Hülle: Loft von unterem zu oberem Profil
2. Innere Aussparung: Loft subtrahieren
3. Bodenflansch: `extrude` der Unterseite nach unten

### Weitere Aufgaben *(falls Zeit)*

| Teil | Link |
|------|------|
| Party Pack 01-03 C Clamp Base | [tttt.html#ttt-ppp0103](https://build123d.readthedocs.io/en/latest/tttt.html#ttt-ppp0103) |
| Party Pack 01-08 Tie Plate | [tttt.html#ttt-ppp0108](https://build123d.readthedocs.io/en/latest/tttt.html#ttt-ppp0108) |

