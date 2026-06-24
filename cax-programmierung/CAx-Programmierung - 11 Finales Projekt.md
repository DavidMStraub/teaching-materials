---
marp: true
theme: hm
paginate: true
html: true
math: mathjax
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
5. Datenaustausch
6. Meshing & Simulation
7. Parametrische Robustheit & Optimierung
8. **Finales Projekt: Rotorblatt**

### Projektziel

End-to-end-Workflow für ein **Windkraftanlagen-Rotorblatt** in vier Schritten:

**Äußere Geometrie → Vernetzung → Simulation → Optimierung**

In dieser Einheit: **Schritt 1 – äußere Geometrie**

Ein Rotorblatt entsteht durch das Zusammensetzen **aerodynamischer Querschnitte** entlang der Spannweite und ist vollständig **parametrisch**:

- Profilform (NACA-Parameter)
- Sehnenlänge entlang der Spannweite
- Verwindungswinkel entlang der Spannweite

## Aerodynamisches Profil

### Was ist ein Profil?

Ein **aerodynamisches Profil** (*airfoil*) ist die zweidimensionale Querschnittform eines Tragflügels oder Rotorblatts.

Wichtige geometrische Begriffe:

| Begriff | Beschreibung |
|---------|-------------|
| **Profilsehne** (*chord*, Länge c) | Verbindungsgerade von Vorder- zu Hinterkante |
| **Profildicke** (*thickness*) | maximale Profilerhebung, als Anteil von c |
| **Wölbungslinie** (*camber line*) | Mittellinie zwischen Ober- und Unterseite |
| **Wölbung** (*camber*) | maximaler Abstand der Wölbungslinie von der Sehne |

![bg right:50% 95%](https://upload.wikimedia.org/wikipedia/commons/e/e8/Chord_length_definition_%28en%29.svg)

### NACA 4-stelliges Profil

Die **NACA 4-digit-Serie** (National Advisory Committee for Aeronautics, 1933) beschreibt ein Profil durch vier Ziffern **MPTT**:

| Ziffer | Bedeutung | Beispiel NACA **2412** |
|--------|-----------|----------------------|
| **M** | Max. Wölbung in % der Sehne | **2** % |
| **P** | Lage der max. Wölbung in Zehnteln der Sehne | bei **4**0 % |
| **TT** | Max. Dicke in % der Sehne | **12** % |

- **NACA 0012** – symmetrisches Profil, 12 % Dicke
- **NACA 2412** – klassisches Tragflächenprofil mit leichter Wölbung
- **NACA 4412** – stärkere Wölbung, typisch für Windkraftanlagen

![bg right:30% 90%](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Aerofoil.svg/1200px-Aerofoil.svg.png)

### Vorgaben (1): Funktionen

In `rotorblatt.py` sind folgende Funktionen fertig implementiert:

```python
NacaPoints = list[tuple[float, float]]  # normierter 2-D Profilumriss

# 2-D Profilpunkte aus 4-stelligem NACA-Code
naca_points(digits: str, n: int = 60) -> NacaPoints

# 2-D Profilpunkte aus kontinuierlichen NACA-Parametern (für Interpolation)
naca_profile(m: float, p: float, t: float, n: int = 60) -> NacaPoints

# Profilquerschnitt als build123d-Face bei z = r
pts_to_face(pts_2d: NacaPoints,
            r: float, chord: float, twist_deg: float) -> bd.Face

# Spanweise Arrays + Kreisquerschnitte (Geometrie vorberechnet)
_span_params(p: BladeParam) -> SpanParams
```

### Vorgaben (2): BladeParam

```python
@dataclass
class BladeParam:
    span:          float = 45.0 * bd.M    # Blattlaenge
    chord_max:     float =  3.5 * bd.M    # max. Sehnlaenge an der Schulter
    chord_tip:     float = 50.0 * bd.CM   # Sehnlaenge an der Spitze
    r_shoulder:    float = 12.0 * bd.M    # radiale Position der Schulter
    twist_root:    float = 20.0           # Verwindung Wurzel [Grad]
    twist_tip:     float =  3.0           # Verwindung Spitze [Grad]
    naca_root:     str   = "2060"         # Profil an der Wurzel
    naca_tip:      str   = "6418"         # Profil an der Spitze
    n_sections:    int   = 10             # Anzahl Loft-Querschnitte
    flange_radius: float = 80.0 * bd.CM   # Flanschradius
    flange_length: float = 150.0 * bd.CM  # Flanschlaenge
```

### Aufgabe 1: Profil in build123d

Implementieren Sie:

```python
def profile_face(r: float, chord: float, twist_deg: float,
                 naca: str = "4418", n: int = 60) -> bd.Face:
```

**Hinweis:** Rufen Sie `naca_points` auf, um die normierten 2-D-Punkte zu erhalten, und übergeben Sie das Ergebnis an `pts_to_face`.

```python
import ocp_vscode
ocp_vscode.show(profile_face(r=0, chord=1000, twist_deg=0))
```

### Aufgabe 2: Loft-Querschnitte

Implementieren Sie `loft_sections(p: BladeParam) -> list[bd.Face]`:

```python
sp = _span_params(p)  # sp.circles, sp.r_vals, sp.chords, sp.twists, sp.ms, sp.ps, sp.ts
```

Erstellen Sie mit `naca_profile` und `pts_to_face` für jede Sektion eine Face, und geben Sie `sp.circles + blade_faces` zurück.

### Aufgabe 3: Rotorblatt

Implementieren Sie `rotor_blade(p: BladeParam) -> bd.Solid`:

1. Flansch: `bd.Cylinder` mit `bd.Align.MIN` entlang *z*
2. `bd.loft(loft_sections(p))`
3. `flange + blade_loft`

### *Fortsetzung folgt …*
