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
7. **Parametrische Robustheit & Optimierung**

## Parametrische Robustheit & Optimierung

- **Parametrische Robustheit:** Modelle, die bei ungültigen Parametern nicht abstürzen
- **Optimierungsproblem:** Design-Variablen, Zielfunktion, Nebenbedingungen
- **Algorithmen:** `scipy.optimize` für CAD-Anwendungen
- **Vollständiger Workflow:** von Parametern zum optimalen Bauteil

## Parametrische Robustheit

### Das Problem: Topologische Instabilität

Ein parametrisches Modell kann bei bestimmten Parameterwerten **versagen**:

```python
def rundzelle(r_aussen, wandstaerke, hoehe):
    aussen = bd.Cylinder(radius=r_aussen, height=hoehe)
    innen  = bd.Cylinder(radius=r_aussen - wandstaerke, height=hoehe)
    return aussen - innen

rundzelle(9.0, 2.0,  65)   # ✓ funktioniert
rundzelle(9.0, 9.5,  65)   # ✗ r_innen < 0 → Fehler
rundzelle(9.0, 0.0,  65)   # ✗ wandstaerke = 0 → entartete Geometrie
rundzelle(9.0, 2.0, -10)   # ✗ negative Höhe
```

**Im interaktiven Betrieb:** Fehlermeldung → manuell korrigieren → weiter.
**Im Optimierungsloop:** Eine Exception stoppt den gesamten Lauf.

### Ungültige Parameter abfangen

Ungültige Parameter **vor** der Modellierung abfangen:

```python
def rundzelle(r_aussen: float, wandstaerke: float, hoehe: float) -> bd.Part:
    if wandstaerke <= 0:
        raise ValueError(f"wandstaerke muss > 0 sein, ist {wandstaerke}")
    if r_aussen - wandstaerke <= 0.5:
        raise ValueError(f"Innenradius zu klein: {r_aussen - wandstaerke:.2f} mm")
    if hoehe <= 0:
        raise ValueError(f"hoehe muss > 0 sein, ist {hoehe}")

    aussen = bd.Cylinder(radius=r_aussen, height=hoehe)
    # +1: überragt → keine koinzidenten Flächen
    innen  = bd.Cylinder(radius=r_aussen - wandstaerke, height=hoehe + 1)
    return aussen - innen
```

→ Frühe, klare Fehlermeldung statt kryptischer OCCT-Ausnahme.

### Konstruktive Absicherung

Nicht jeden Grenzwert prüfen – Parameter im Code **weich kappen**:

```python
def rundzelle(r_aussen, wandstaerke, hoehe, fasen_radius=1.0):
    fasen_radius = min(fasen_radius, wandstaerke * 0.45)  # kein Crash bei zu großem Radius
    ...
```

Der Optimierer bleibt immer im validen Bereich – der Parameter klebt an der geometrisch möglichen Grenze statt eine Exception zu werfen.

→ Sinnvoll bei geometrisch motivierten Grenzen (`fillet_radius < wandstaerke / 2`).  
→ Nicht für physikalisch sinnlose Werte – negative Maße immer explizit ablehnen (`if/raise`).

### Weitere Quellen für Instabilität

| Parameterwert | Symptom |
|---------------|---------|
| `fillet_radius > wandstaerke / 2` | Verrundung kann nicht erzeugt werden |
| Bohrungstiefe > Körperhöhe | Durchgangsbohrung statt Sackloch |
| `r_aussen - wandstaerke ≤ 0` | Innenkörper größer als Außenkörper |
| Pfad-Krümmungsradius < Querschnittsbreite | Sweep degeneriert (Innenseite faltet sich) |
| Bool'sche Op auf tangentialen Flächen | Numerisch instabiles Ergebnis |

→ OCCT gibt nicht immer eine saubere Fehlermeldung – manchmal entsteht stilles Fehlverhalten.

*Koinzidente Flächen:* Liegt die Schnittfläche exakt auf einer Körperfläche, entstehen durch Fließkomma-Ungenauigkeiten des CAD-Kerns „Geisterflächen”. Gegenmittel: das Werkzeug in Schnittrichtung immer **überragen lassen**.

### Das „Topological Naming Problem“

Parametrische Änderungen können die **Indexreihenfolge** von Kanten und Flächen verschieben:

```python
# ✗ fragil – edges()[3] ist heute die Oberkante, nach Parameteränderung eine andere
bauteil = fillet(bauteil.edges()[3], radius=1.0)
```

OCCT vergibt topologische IDs bei jeder Neuberechnung intern neu.

**Lösung:** geometrische Selektoren statt fester Indizes:

```python
# ✓ robust – immer die geometrisch oberste Kante, unabhängig von der Indexreihenfolge
oberkante = bauteil.edges().sort_by(Axis.Z).last
bauteil   = fillet(oberkante, radius=1.0)
```

### Stilles Kernel-Versagen

Parameter können gültig sein, aber OCCT trotzdem **lautlos ein leeres Compound** zurückgeben – kein Exception, trotzdem kaputtes Ergebnis (z. B. bei tangentialen Boole'schen Operationen).

```python
    ergebnis = aussen - innen
    assert isinstance(ergebnis, bd.Solid), "Boolean-Operation hat keinen Solid erzeugt"
    return ergebnis  # Typ ist jetzt Solid, nicht Shape
```

Der Kernel gibt laut Stubs `Shape` zurück – `assert isinstance` **narrowt den Typ** auf `Solid` und prüft gleichzeitig zur Laufzeit: ein leeres Compound ist kein `Solid` (→ Einheit X3).

### `assert` — Werkzeug für Invarianten

`assert expr, "msg"` ist eine Abkürzung für:

```python
if __debug__:
    if not expr:
        raise AssertionError("msg")
```

`__debug__` ist normalerweise `True`, mit `python -O` wird es `False`. `assert` ist **bewusst deaktivierbar** — es ist ein Werkzeug für Entwicklung und Debugging, nicht für Laufzeitfehler im Produktivbetrieb.

### Wann `assert`, wann `if/raise`?

| Einsatz | Mittel |
|---------|--------|
| **Sanity-Check:** Invariante, die bei fehlerfreiem Code *nie* verletzt wird | `assert` |
| **Fehlerbehandlung:** Fehler durch Eingaben, externe Bibliotheken, Laufzeitbedingungen | `if/raise ValueError` |

`assert isinstance(ergebnis, bd.Solid)` ist ein Sanity-Check: bei validen Eingaben *weiß* man, dass ein `Solid` herauskommen muss — schlägt es fehl, liegt ein Bug im eigenen Code vor.

Soll die Prüfung auch im Produktivbetrieb sicher feuern: `if not isinstance(ergebnis, bd.Solid): raise ValueError(...)`.

### Fail-Fast im Optimierungsloop

Kernel-Operationen kosten **Sekunden** – arithmetische Checks kosten **Nanosekunden**.

| Schritt | Mittel | Kosten |
|---------|--------|--------|
| 1. Eingabevalidierung | `if/raise` | ~0 |
| 2. Geometrieerzeugung & Boolean | Kernel (OCCT) | Sekunden |
| 3. Ergebnisvalidierung | `assert` / `if/raise` | ~0 |

→ Ungültige Parameter werden abgefangen, bevor der Kernel überhaupt gestartet wird.

### Checkliste: Robustes parametrisches Modell

- **Eingaben zuerst** – `if/raise` vor dem ersten OCCT-Aufruf
- **Keine festen Indizes** – geometrische Selektoren statt `edges()[3]`
- **Werkzeug überragen lassen** – bei Boolean-Subtraktion `height + ε` verwenden
- **Parameter weich kappen** – `min(radius, wandstaerke * 0.45)` statt crashen
- **Ergebnis prüfen** – `isinstance(ergebnis, bd.Solid)` nach Boolean-Operationen

## Einschub: Dataclasses

### Parametersatz als Typ

Parametrische Modelle haben oft viele Parameter, die man als Einheit behandeln will – speichern, vergleichen, leicht variieren:

```python
# Variante mit anderer Höhe → alle Argumente wiederholen
rundzelle(r_aussen=9.0, wandstaerke=2.0, hoehe=65)
rundzelle(r_aussen=9.0, wandstaerke=2.0, hoehe=50)
```

```python
from dataclasses import dataclass, replace

p_basis    = RundzellParam(r_aussen=9.0, wandstaerke=2.0, hoehe=65)
p_variante = replace(p_basis, hoehe=50)   # Kopie, nur hoehe geändert

rundzelle(p_basis)
rundzelle(p_variante)
```

Dataclass: Parametersatz als **Typ** – speicherbar, vergleichbar, variierbar.

### `@dataclass` – Syntax

```python
from dataclasses import dataclass, replace

@dataclass
class RundzellParam:
    r_aussen:    float = 9.0  # Typannotation Pflicht; Standardwert optional
    wandstaerke: float = 2.0
    hoehe:       float = 65.0

p  = RundzellParam(r_aussen=12.0)  # Rest: Defaults
p2 = replace(p, hoehe=50)          # Kopie mit einer Änderung

p.r_aussen   # 12.0
print(p)     # RundzellParam(r_aussen=12.0, wandstaerke=2.0, hoehe=65.0)
```

## Praktikum: Parametrische Robustheit

### L-Halter

![bg right:25% 90%](assets/l_halter_iso.svg)

```python
@dataclass
class LHalterParam:
    laenge:    float = 80.0
    breite:    float = 40.0
    dicke_h:   float = 5.0
    hoehe_v:   float = 60.0
    dicke_v:   float = 5.0
    r_bohrung: float = 4.0
    t_bohrung: float = 4.0
    r_vr:      float = 2.0

def l_halter(p: LHalterParam) -> bd.Solid: ...
```

Horizontaler und vertikaler Flansch, zwei Sacklöcher, Verrundung an der Innenecke.

### Aufgabe 1: Grundmodell

Implementieren Sie `l_halter(p: LHalterParam)` in build123d.

Testen Sie danach – was beobachten Sie?

| Aufruf | Beobachtung |
|--------|-------------|
| `LHalterParam()` | |
| `LHalterParam(dicke_h=0)` | |
| `LHalterParam(r_bohrung=25)` | |
| `LHalterParam(t_bohrung=9)` | |

### Aufgabe 1: Hinweise

```python
def l_halter(p: LHalterParam) -> bd.Solid:
    h = bd.Box(p.laenge, p.breite, p.dicke_h)

    v = bd.Box(p.dicke_v, p.breite, p.hoehe_v)
    v = bd.Pos(..., 0, ...) * v  # x: linkes Ende; z: auf den horizontalen Flansch

    halter = h + v

    for x_pos in [p.laenge / 4, -p.laenge / 4 + p.dicke_v / 2]:
        bohrung = bd.Cylinder(radius=p.r_bohrung, height=p.t_bohrung + 1)
        bohrung = bd.Pos(x_pos, 0, ...) * bohrung  # z so wählen, dass Werkzeug überragt
        halter = halter - bohrung

    return bd.Solid(halter)
```

*Frage:* Was passiert bei `LHalterParam(t_bohrung=9)`? Öffnen Sie das Modell im Viewer.

### Aufgabe 2: Modell absichern

Ergänzen Sie `l_halter` um:

1. **Gültigkeitsprüfungen** – jede kritische Bedingung soll einen `ValueError` werfen:

| Bedingung | Problem |
|-----------|---------|
| `p.dicke_h <= 0` oder `p.dicke_v <= 0` | entartete Geometrie |
| `p.hoehe_v <= 0` | kein vertikaler Flansch |
| `p.r_bohrung >= p.breite / 2` | Bohrung breiter als Bauteil |
| `p.t_bohrung > p.dicke_h` | Sackloch wird Durchgangsbohrung |

2. **`assert isinstance`** nach der Boolean-Vereinigung der Flansche
3. **Koinzidente Flächen** zwischen den Flanschen beseitigen

### Aufgabe 2: Hinweis – Koinzidente Flächen

Bei naiver Positionierung liegen die Oberkante von `h` und die Unterkante von `v` exakt aufeinander:

```python
# ✗ koinzidente Fläche: Unterkante v liegt genau auf Oberkante h
v = bd.Pos(..., 0, p.dicke_h / 2 + p.hoehe_v / 2) * v

# ✓ vertikaler Flansch überragt 0,5 mm nach unten
v = bd.Pos(..., 0, p.dicke_h / 2 + p.hoehe_v / 2 - 0.5) * v
```

→ Selbes Prinzip wie `height = hoehe + 1` beim Innenzylinder.

### Aufgabe 3: Verrundung *(Zusatz)*

Fügen Sie eine Verrundung an der Innenecke hinzu.

1. Zunächst mit festem Index:
   ```python
   halter = bd.fillet(halter.edges()[?], radius=p.r_vr)
   ```
   Variieren Sie `p.dicke_v`: 3 mm, 8 mm, 15 mm. Was passiert?

2. Beheben Sie das Topological Naming Problem. Die Innenecke ist die Y-Kante auf Höhe der Oberkante des horizontalen Flansches – linkeste Kante in der mittleren Z-Gruppe:
   ```python
   innenecke = (halter.edges()
                      .filter_by(Axis.Y)
                      .group_by(Axis.Z)[1]
                      .sort_by(Axis.X)[0])
   halter = bd.fillet(innenecke, radius=p.r_vr).solids()[0]
   ```
