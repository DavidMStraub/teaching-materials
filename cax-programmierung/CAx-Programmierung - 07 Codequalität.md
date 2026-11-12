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
5. Freiformgeometrie
6. Profile
7. **Codequalität**
8. Datenaustausch
9. Robustheit
10. Simulation
11. Optimierung

## Codequalität

- **Type Hints:** Typfehler finden, bevor der Code läuft
- **Unittests:** die Geometrie bei jeder Änderung automatisch prüfen
- **CI:** beides läuft bei jedem Push auf GitLab

*Durchgängiges Beispiel:* Ihr Batteriemodul aus Einheit 3 und 4, an einem Ort gesammelt, annotiert und getestet

### Rückblick: der Modul-Code

Ihr Modul-Code liegt bisher verteilt:

- `w03/`: `ModulParam`, `zelle_bauen`, `stapel_bauen`, `endplatten`
- `w04/`: dieselben Funktionen mit Tab und Flip, `ModulParam` noch einmal kopiert

Jede Datei baut beim Start das Modul und zeigt es an. Ob nach einer Änderung noch alles stimmt, sehen Sie nur im Viewer.

**Heute:** Der Code kommt an einen Ort: `w07/modul.py`. Danach prüfen ihn zwei Werkzeuge bei jeder Änderung: ein Type-Checker und Unittests.

Die Folien verwenden die Namen aus der Referenzlösung, etwa `platten_t` oder `stapel_hoehe`.

## Theorie A: Type Hints

### Ausgangspunkt: `ModulParam`

```python
from dataclasses import dataclass
from cadquery import func as cf
from ocp_vscode import show

@dataclass
class ModulParam:
    zell_b: float = 148.0        # mm, Zellbreite
    zell_h: float = 98.0         # mm, Zellhöhe
    zell_t: float = 11.0         # mm, Zelldicke
    zell_r: float = 6.0          # mm, Eckradius der Zelle
    n_zellen: int = 12           # Anzahl Zellen im Stapel
    spacer: float = 1.5          # mm, Kompressionspad zwischen den Zellen
    tab_l: float = 12.0          # mm, Überstand des Tabs über die kurze Seite
    tab_b: float = 24.0          # mm, Tabbreite
    tab_t: float = 6.0           # mm, Tabdicke, mittig in der Zelldicke
    platten_rand: float = 12.0   # mm, Endplatte größer als Zellquerschnitt
    platten_t: float = 8.0       # mm, Endplattendicke
    zapfen_d: float = 16.0       # mm, Zentrierbohrung
```

### Was meldet Python?

```python
def stapel_hoehe(p: ModulParam) -> float:
    return (p.n_zellen - 1) * (p.zell_t + p.spacer) + p.zell_t


def endplatten(p: ModulParam):
    unten = cf.box(p.zell_b + p.platten_rand, p.zell_h + p.platten_rand, p.platten_t)
    z_mitte = p.platten_t + stapel_hoehe(p) / 2
    oben = unten.mirror("XY", basePointVector=(0, 0, z_mitte))
    unten + oben


platten = endplatten(ModulParam())
show(platten.moved(cf.Location((0, 0, 6))))
```

**Was passiert beim Ausführen, und in welcher Zeile meldet Python den Fehler?**

### Der Fehler fällt weit entfernt auf

```
    show(platten.moved(cf.Location((0, 0, 6))))
         ^^^^^^^^^^^^^
AttributeError: 'NoneType' object has no attribute 'moved'
```

- In `endplatten` fehlt das `return`. Ohne `return` liefert jede Funktion `None`.
- Python meldet den Fehler erst dort, wo das Ergebnis **benutzt** wird, nicht in `endplatten`.

Python prüft Typen **zur Laufzeit** und nur in Zeilen, die tatsächlich laufen. `None` hat keine Methode `moved`.

### Dynamisch und statisch typisiert

| | **dynamisch** | **statisch** |
|---|---|---|
| Typ steht fest | zur Laufzeit, pro Objekt | im Quelltext, pro Variable |
| geprüft wird | beim Ausführen | vor dem Ausführen |
| Fehler sichtbar | wenn die Zeile dran ist | sofort im Editor / Compiler |
| Sprachen | Python, JavaScript | C, Java, Rust |

In C weist der Compiler `int x = "hallo";` ab, bevor das Programm existiert. Python nimmt jede Zuweisung an. Der Fehler zeigt sich erst, wenn der Wert benutzt wird.

**Wenn statische Typen Fehler früher finden: Warum schreiben wir CAD-Code nicht gleich in C?**

### Typen nachrüsten

- **Ausprobieren:** Kurze Skripte ohne Deklarationen, dafür steht Python im Kurs.
- **Wachsender Code:** Wird eine Funktion importiert und von anderen aufgerufen, kommen unerwartete Werte an.
- **Gradual Typing:** Annotationen sind freiwillig. Man setzt sie an die Signaturen von wiederverwendetem Code.
- **Alle Zweige:** Ein Probelauf prüft nur die ausgeführten Zeilen, ein Type-Checker auch selten laufende Zweige.

### Annotationen: den Typ hinschreiben

In Einheit 3 standen schon Typ-Hinweise, in der Dataclass und an einer Funktion:

```python
zell_t: float = 11.0
def zell_volumen(p: ModulParam) -> float: ...
```

`: float`, `p: ModulParam` und `-> float` sind **Type Hints** (Annotationen). Python selbst ignoriert sie und führt den Code genauso aus, auch bei falscher Annotation:

```python
def verdopple(x: str) -> int:
    return x * 2

verdopple(5)      # läuft durch, ohne Warnung
```

In einer Dataclass macht erst die Annotation eine Zeile zum Feld. Den Typ prüft aber auch `@dataclass` nicht: `ModulParam(n_zellen="12")` läuft durch.

### Type-Checker: lesen, ohne auszuführen

Die Annotationen wertet ein **Type-Checker** aus, ein zweites Programm. Es liest den Quelltext, verfolgt die Typen durch die Funktionen und meldet Widersprüche, ohne eine Zeile auszuführen:

| Tool | Wann | Wie |
|---|---|---|
| **Pylance** | beim Tippen | Wellenlinie im Editor (VS Code) |
| **mypy** | Kommandozeile / CI | `uv run mypy w07/` |

Mit `def endplatten(p: ModulParam) -> cf.Shape:` meldet mypy den Fehler in der Funktion selbst:

```
w07/modul.py:51: error: Missing return statement  [return]
```

Pylance kommt mit der Python-Erweiterung von VS Code, mypy steht seit Woche 1 in Ihrer `pyproject.toml`. Dort stehen auch ihre Einstellungen.

### Syntax: Parameter, Rückgabe, `| None`

```python
def stapel_hoehe(p: ModulParam) -> float: ...
def zelle_bauen(p: ModulParam) -> cf.Shape: ...
def bericht(p: ModulParam) -> None: ...          # gibt nichts zurück

@dataclass
class ModulParam:
    n_zellen: int = 12
    zapfen_d: float | None = 16.0                 # None: ohne Zentrierbohrung
```

- `-> None`: Die Funktion gibt nichts zurück. Trotzdem hinschreiben: **Funktionen ganz ohne Annotation prüft mypy nicht.**
- `float | None`: Der senkrechte Strich heißt **„oder“**. Wer den Wert benutzt, muss mit beidem rechnen.

### CadQuery-Typen

| Typ | Bedeutung |
|---|---|
| `cf.Shape` | Oberbegriff für alle Formen |
| `cf.Solid`, `cf.Face`, `cf.Wire`, `cf.Edge` | die konkreten Topologie-Elemente aus Einheit 2 |

- Grundkörper wie `cf.box` und `cf.cylinder` liefern `cf.Solid`.
- Boolean, Fillet, Extrude, Loft und Selektoren liefern `cf.Shape`. Ob ein Körper entsteht oder mehrere (`Compound`), zeigt erst das Ergebnis: Der Typ hängt von der Topologie ab.

Einheiten kann kein Typ ausdrücken. Der Ersatz sind **aussagekräftige Namen**: `zell_t`, `platten_rand`, `winkel_grad`.

### Was meldet mypy?

```python
p = ModulParam()
platte = cf.box(170, 110, 6)
platte = cf.fillet(platte, platte.edges("|Z"), 6)      # A
boden = platte.faces("<Z").outerWire()                 # B
bohrung = cf.cylinder(d=p.zapfen_d, h=10)              # C
v = platte.Volume() / 1000                             # D
```

`ModulParam` ist die Version von der vorigen Folie, mit `zapfen_d: float | None`.

**Welche Zeilen meldet mypy?** Stimmen Sie ab. Nachprüfen können Sie es in Aufgabe 3.

### Regeln hinter den Meldungen

- **Erste Zuweisung:** Eine Variable behält den Typ ihrer ersten Zuweisung. Abhilfe: neuer Name oder `x: cf.Shape = ...`
- **Konkrete Methoden:** Was es nur am `Face` gibt, verlangt ein `Face`. Ein `Shape` reicht nicht.
- **`| None`:** Erst nach `if x is not None:` darf der Wert benutzt werden.

mypy ist bei Zuweisungen strenger als Pylance, deshalb läuft in der CI mypy.

### Den Typ verengen: `assert isinstance`

Liefert ein Selektor ein `Shape` und Sie brauchen ein `Face`, gibt es drei Wege:

```python
from typing import cast

boden = platte.faces("<Z")              # Typ: Shape

cast(cf.Face, boden)                    # behauptet es, prüft nichts
boden.outerWire()  # type: ignore       # blendet die Meldung nur aus

assert isinstance(boden, cf.Face)       # prüft es wirklich und verengt den Typ
kontur = boden.outerWire()
```

`isinstance(x, Typ)` ist `True`, wenn `x` von diesem Typ ist. `assert bedingung` bricht mit Fehler ab, wenn die Bedingung falsch ist. Trifft der Selektor einmal zwei Flächen, scheitert diese Zeile **an Ort und Stelle**. Mit `cast` oder `# type: ignore` kommt der Fehler erst später und weiter weg.

> Fügt eine KI ein `cast` oder `# type: ignore` ein: nachfragen, welcher Typ dort wirklich ankommt.

## Praktikum A: den Modul-Code annotieren

### Vom Skript zur Funktion

| | Skript | Funktion mit Parametern |
|---|---|---|
| Aufbau | Anweisungen laufen beim Start von oben nach unten | `def zelle_bauen(p: ModulParam) -> cf.Shape:` |
| Maße | als Zahlen im Code | aus den Parametern |
| Variante | Datei kopieren und ändern | Funktion mit anderen Parametern aufrufen |
| Prüfen | im Viewer ansehen | ein Test ruft die Funktion auf und prüft das Ergebnis |
| Anzeigen | bei jedem Start | nur unter `if __name__ == "__main__":` |

**Ab heute entsteht jedes Teil in einer Funktion mit Parametern.** Skripte und Tests importieren diese Funktionen.

### Ein Ort für den Modul-Code

```
w07/modul.py        ModulParam und alle Funktionen des Moduls
tests/test_w07.py   die Tests (Praktikum B)
```

Die Tests importieren Ihre Funktionen. Dabei läuft die ganze Datei, also darf `modul.py` beim Import nichts bauen und nichts anzeigen:

```python
def stapel_bauen(p: ModulParam) -> cf.Shape:
    ...

if __name__ == "__main__":
    from ocp_vscode import show
    p = ModulParam()
    show(stapel_bauen(p), endplatten(p))
```

Starten Sie die Datei direkt, ist `__name__` gleich `"__main__"`, und der Block läuft. Beim Import mit `from w07.modul import stapel_bauen` ist `__name__` gleich `"w07.modul"`, und der Block bleibt aus.

### Aufgabe 1: Die Startdatei übernehmen

Die Datei `w07/modul_start.py` im Repo `referenz` enthält den Modul-Code aus Einheit 3 und 4: `ModulParam` und alle Funktionen, noch ohne Annotationen.

1. Holen Sie sie mit `git pull` im Repo `referenz` und kopieren Sie sie als `w07/modul.py` in Ihr Repo.
2. Führen Sie im Projektordner `uv run python -c "import w07.modul"` aus. Was passiert?
3. Stellen Sie alles, was baut und anzeigt, unter `if __name__ == "__main__":`.

*Prüfen:* Direkt gestartet zeigt die Datei das Modul im Viewer. Der Import aus 2 läuft ohne Ausgabe.

### Aufgabe 2: Annotieren

1. Annotieren Sie alle Funktionen vollständig: Parameter **und** Rückgabetyp.
2. Machen Sie die Zentrierbohrung optional: Mit `zapfen_d=None` entstehen Endplatten ohne Bohrung.
3. Schreiben Sie `zelle_bauen("12")`. Was zeigt Pylance? Was passiert beim Ausführen?

*Hinweise:* `-> cf.Shape` für Geometrie-Funktionen, `float | None` für das Feld

### Aufgabe 3: mypy aufräumen

1. Führen Sie auf der Kommandozeile aus und **beheben Sie jede gemeldete Zeile**, bis mypy `Success` meldet:

```bash
uv run mypy w07/
```

2. Kopieren Sie die Zeilen A–D aus der Abstimmung in eine Datei `probe.py` im Projektordner, mit `from w07.modul import ModulParam` und `from cadquery import func as cf`. Prüfen Sie Ihre Antwort mit `uv run mypy probe.py`.

*Hinweise:* Wo ein `Shape` zu allgemein ist, verengen Sie mit `assert isinstance`.

### Was hat mypy gefunden?

**Welche Meldung hat Sie überrascht? War sie ein echter Fehler oder nur eine Ungenauigkeit im Typ?**

## Theorie B: Unittests

### Regression

```
* 2e9d54a  Stapel auf Flip umgebaut         ← ab hier fehlt das Kompressionspad
* c04f81a  Tab an der Zelle ergänzt
* f3a17bc  Erste Version des Stapels
```

**Regression:** Etwas war korrekt und ist es nach einer Änderung nicht mehr.

Ohne Tests fällt das spät auf, im ungünstigsten Fall erst am gefertigten Teil. Ein Test meldet es beim nächsten Commit.

**Wie hätten Sie diesen Fehler bisher bemerkt?**

### Was ein Unittest ist

Ein **Unittest** ist eine gewöhnliche Python-Funktion. Sie ruft eine Funktion Ihres Codes auf und prüft das Ergebnis mit `assert`:

```python
from w07.modul import ModulParam, zelle_bauen

def test_zelle_ist_ein_koerper():
    zelle = zelle_bauen(ModulParam())
    assert zelle.isValid()
    assert len(zelle.Solids()) == 1
```

`len(Solids()) == 1` kommt aus Einheit 6: `isValid()` ist auch bei einer offenen Fläche `True`.

Ist eine Bedingung falsch, wirft `assert` einen `AssertionError`. Daran erkennt der Testrunner einen fehlgeschlagenen Test.

### pytest: der Testrunner

**pytest** ist ein Programm, das Ihre Tests **findet und ausführt**. Wie mypy liegt es schon in Ihrer Projektumgebung. Man ruft es im Projektordner auf:

```bash
uv run pytest -v
```

```
tests/test_w07.py::test_zelle_ist_ein_koerper PASSED
tests/test_w07.py::test_stapel_hoehe FAILED
```

Gefunden wird nach zwei Konventionen:

- Die Datei heißt `test_*.py`.
- Die Funktion darin heißt `test_*`.

Bei einem Fehlschlag zeigt pytest die gescheiterte Zeile mit Ist- und Sollwert.

### Aufbau: Arrange – Act – Assert

```python
def test_stapel_hoehe():
    p = ModulParam()                                   # Arrange
    stapel = stapel_bauen(p)                           # Act
    soll = 11 * 12.5 + 11                              # 11 Abstände und eine Zelle
    assert stapel.BoundingBox().zlen == pytest.approx(soll, abs=0.01)   # Assert
```

Der Sollwert kommt aus einer **unabhängigen** Rechnung: aus den Maßen des Teils, nicht aus dem Code, der es baut. Sonst steckt derselbe Denkfehler in beiden.

**Warum prüft man ein gefertigtes Teil gegen die Zeichnung und nicht gegen das NC-Programm?**

### `pytest.approx` – Fließkomma

```python
assert zelle.Volume() == 160932.0                           # spröde
assert zelle.Volume() == pytest.approx(160932, rel=1e-6)    # relativ
assert zelle.Volume() == pytest.approx(160932, abs=0.1)     # ± 0,1 mm³
```

Geometrieoperationen sammeln Rundungsfehler ($0.1 + 0.2 \neq 0.3$). Exakte Gleichheit scheitert deshalb zufällig.

### Was lässt sich an einem Shape messen?

Sie ändern `zelle_bauen`.

**Mit welchen Methoden aus den bisherigen Einheiten prüfen Sie ohne Viewer, ob die Zelle noch stimmt?**

### Was am CAD-Code prüfen?

| Prüfung | findet |
|---|---|
| `isValid()`, `len(Solids()) == 1` | kaputte Topologie, Fläche statt Körper |
| `Volume()` gegen eine Formel | falsche Maße, fehlende oder zusätzliche Features |
| `BoundingBox()` | falsche Außenmaße und Lage |
| `(a * b).Volume() == 0` | zwei Teile durchdringen sich |

Zur Erinnerung aus Einheit 6: `*` bildet die geometrische Schnittmenge, `&` die Schnittmenge von Auswahlen.

### Welche Tests werden rot?

```python
def test_zelle_volumen():
    assert zelle_bauen(ModulParam()).Volume() == pytest.approx(160932, rel=1e-6)

def test_stapel_hoehe():
    assert stapel_bauen(ModulParam()).BoundingBox().zlen == pytest.approx(148.5)

def test_stapel_anzahl_koerper():
    p = ModulParam()
    assert len(stapel_bauen(p).Solids()) == p.n_zellen
```

1. In `stapel_bauen` wird aus `pitch = p.zell_t + p.spacer` die Zeile `pitch = p.zell_t`. **Welche Tests werden rot?**
2. In `stapel_bauen` fehlt die Drehung jeder zweiten Zelle. **Welche Tests werden rot?**

### Auflösung

1. **Höhe und Anzahl:** Der Stapel ist 132 mm statt 148,5 mm hoch. Die Zellen berühren sich, und `+` verschmilzt sie zu einem Körper. Das Volumen der Zelle bleibt gleich.
2. **Keiner:** Höhe, Anzahl und Zellvolumen ändern sich nicht. Für die Drehung fehlt ein Test, etwa auf die Breite des Stapels.

### Was stimmt an diesen Tests nicht?

```python
def test_zelle():
    print(zelle_bauen(ModulParam()).Volume())

def test_kollision():
    p = ModulParam()
    stapel = stapel_bauen(p).moved(cf.Location((0, 0, p.platten_t)))
    assert (stapel & endplatten(p)).Volume() == 0

def test_volumen():
    soll = 148 * 98 * 11
    assert zelle_bauen(ModulParam()).Volume() == pytest.approx(soll, rel=0.05)

def test_hoehe():
    p = ModulParam()
    assert stapel_hoehe(p) == (p.n_zellen - 1) * (p.zell_t + p.spacer) + p.zell_t
```

### Auflösung: vier Antipatterns

- **Kein `assert`:** `test_zelle` gibt nur aus. Der Test ist immer grün und beweist nichts.
- **Ein Test, der nie rot wird:** `&` liefert immer eine leere Auswahl. Machen Sie jeden Test einmal absichtlich kaputt, dann muss er rot werden.
- **Zu großzügige Toleranz:** 5 % verdecken den Tab (1,1 %) und die Ecken (0,2 %).
- **Formel gegen Formel:** `test_hoehe` vergleicht die Rechnung mit derselben Rechnung und baut gar keine Geometrie.

Dazu kommt: **Eine Testfunktion prüft ein Verhalten.** Dann sagt schon der Name des roten Tests, was kaputt ist.

**Ein KI-Assistent schreibt Funktion und Test in einem Durchgang. Was beweist der grüne Test?**

### CI: bei jedem Push (GitLab)

**Continuous Integration:** Nach jedem Push checkt ein Rechner auf dem GitLab-Server Ihr Projekt frisch aus und arbeitet die `.gitlab-ci.yml` in Ihrem Repo ab:

```yaml
tests:
  script:
    - uv sync --locked          # exakt die Versionen aus uv.lock
    - uv run pytest tests/ -q
```

Diese Datei liegt seit Woche 1 im Repo, die Pipeline lief bei jedem Push mit. Ab heute enthält sie Ihre Tests. Das Ergebnis steht am Commit: grünes ✓ oder rotes ✗.

Darunter steht auskommentiert ein zweiter Job `typen` mit `uv run mypy .` und `allow_failure: true`. Er meldet Typfehler gelb am Commit, blockiert die Pipeline aber nicht.

## Praktikum B: das Modul testen

### Aufgabe 4: Geometrie-Tests

Schreiben Sie `tests/test_w07.py` mit Tests für:

1. Die Zelle ist ein gültiger Körper.
2. Das Volumen der Zelle gegen einen **selbst gerechneten** Sollwert: Quader, Ecken, Tab.
3. Die Höhe des Stapels, und der Grenzfall `ModulParam(n_zellen=1)`.
4. *(Zusatz)* Ein Test, der den vergessenen Flip bemerkt.

*Prüfen:* Ihr Sollwert in 2 liegt bei etwa 160 900 mm³.

*Hinweise:* Wie viel Fläche nimmt eine Rundung mit Radius $r$ an einer Ecke weg? `approx` braucht `import pytest`. Ausführen mit `uv run pytest -v`.

### Aufgabe 5: Kollision

1. Testen Sie, dass Stapel und Endplatten sich nicht durchdringen.
2. Machen Sie den Test absichtlich kaputt: `unten + bohrung`. Wird er rot? Machen Sie die Änderung danach rückgängig.
3. *(Zusatz)* Testen Sie, dass sich die Zellen im Stapel nicht berühren. Wird der Test mit `spacer=0` rot?

*Hinweise:* Im Modul liegt der Stapel um `platten_t` höher als die untere Endplatte. `pytest.approx(0, abs=1e-6)`

### Aufgabe 6: CI und die Regression selbst auslösen

1. Committen und pushen Sie `w07/` und `tests/test_w07.py`. Läuft die Pipeline grün?
2. Lassen Sie in `zelle_bauen` das Fillet weg. Sagen Sie voraus, ob einer Ihrer Tests rot wird. Pushen Sie und prüfen Sie es an der Pipeline. Machen Sie die Änderung danach rückgängig.

### Aufgabe 7 *(Zusatz)*: Ein Test, viele Parametersätze

```python
import pytest

@pytest.mark.parametrize("n", [1, 2, 5, 12])
def test_stapel_ueber_n(n):
    p = ModulParam(n_zellen=n)
    ...
```

pytest führt den Test einmal für jedes `n` aus und meldet jeden Lauf einzeln.

1. Prüfen Sie für jedes `n` die Anzahl der Solids und die Höhe.
2. Nehmen Sie `0` in die Liste auf. Was meldet pytest? Was sollte `stapel_bauen` stattdessen tun?

### mypy für das ganze Repo einstellen

`uv run mypy .` prüft alle Wochen auf einmal. Liegt in zwei Wochen eine Datei mit demselben Namen, bricht mypy ab, ohne etwas zu prüfen:

```
w07/modul.py: error: Duplicate module named "modul" (also at "./w03/modul.py")
```

Ihre Wochenordner enthalten keine `__init__.py`. Deshalb nimmt mypy jeden Ordner als eigenen Startpunkt, und beide Dateien heißen schlicht `modul`.

Ergänzen Sie in Ihrer `pyproject.toml`:

```toml
[tool.mypy]
explicit_package_bases = true
```

Dann gehört der Ordner zum Namen: `w03.modul` und `w07.modul`.

### Aufgabe 8 *(Zusatz)*: Typen in der CI

1. Führen Sie mit dieser Einstellung `uv run mypy .` aus. Welche Meldungen aus früheren Wochen folgen den Regeln aus Theorie A?
2. Aktivieren Sie den Job `typen` in der `.gitlab-ci.yml`: Entfernen Sie die `#` vor seinen Zeilen und pushen Sie. Welche Farbe hat der Job, und warum?

## Abschluss

### Lohnt sich das?

**Typen, Tests, CI: Ab welcher Größe lohnt sich der Aufwand? Für Ihr Modul, für eine Abschlussarbeit, für ein Produkt?**


### Leseauftrag & Ausblick

- **Leseauftrag:** Buch Kapitel 8, Abschnitte „Testing Geometry“, „Types as Contracts“ und „Verification on Every Change“
- **KI-Werkzeuge:** Mit Typen und Tests arbeiten KI-Assistenten zuverlässiger. Material zum Setup liegt auf der Kursseite (Selbststudium).
- **Wer mehr will:** einen Test *zuerst* schreiben (Red → Green), dann die Funktion dazu
- **Nächste Woche:** Datenaustausch: Assembly, BOM und STEP-Export des ganzen Moduls
- Bis dahin: `w07/` und `tests/test_w07.py` committet und gepusht, Pipeline grün
