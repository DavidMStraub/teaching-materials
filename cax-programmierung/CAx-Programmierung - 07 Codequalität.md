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

**Heute:** Der Code kommt an einen Ort. Dann melden zwei Werkzeuge Fehler, ohne dass Sie hinschauen müssen.

Die Folien verwenden die Namen aus der Referenzlösung, etwa `platten_t` oder `stapel_hoehe`.

## Theorie A: Type Hints

### Was meldet Python?

```python
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

Python prüft Typen **zur Laufzeit** und nur in Zeilen, die tatsächlich laufen. Dabei zählt allein, ob ein Objekt die verlangte Operation beherrscht (**Duck Typing**). `None` beherrscht fast nichts.

### Dynamisch und statisch typisiert

| | **dynamisch** | **statisch** |
|---|---|---|
| Typ steht fest | zur Laufzeit, pro Objekt | im Quelltext, pro Variable |
| geprüft wird | beim Ausführen | vor dem Ausführen |
| Fehler sichtbar | wenn die Zeile dran ist | sofort im Editor / Compiler |
| Sprachen | Python, JavaScript | C, Java, Rust |

In C weist der Compiler `int x = "hallo";` ab, bevor das Programm existiert. Python nimmt jede Zuweisung an und stolpert erst beim Benutzen.

### Annotationen: den Typ hinschreiben

In Einheit 3 standen schon Typ-Hinweise, in der Dataclass und an einer Funktion:

```python
zell_t: float = 11.0
def zell_volumen(p: ModulParam) -> float:
```

`: float`, `p: ModulParam` und `-> float` sind **Type Hints** (Annotationen), seit Python 3.5 (2015). Python selbst ignoriert sie und führt den Code genauso aus, auch bei falscher Annotation:

```python
def verdopple(x: str) -> int:
    return x * 2

verdopple(5)      # läuft durch, ohne Warnung
```

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

Pylance kommt mit der Python-Erweiterung von VS Code, mypy steht seit Woche 1 in Ihrer `pyproject.toml`. Eingestellt sind beide dort.

### Syntax: Parameter, Rückgabe, `| None`

```python
def stapel_hoehe(p: ModulParam) -> float: ...
def zelle_bauen(p: ModulParam) -> cf.Shape: ...
def bericht(p: ModulParam) -> None: ...          # gibt nichts zurück

@dataclass
class ModulParam:
    n_zellen: int = 12
    zapfen_d: float | None = 16.0                 # None: ohne Zentrierbohrung

punkte: list[tuple[float, float, float]] = []     # Liste von Punkten
```

- `-> None`: Die Funktion gibt nichts zurück. Trotzdem hinschreiben: **Funktionen ganz ohne Annotation prüft mypy nicht.**
- `float | None`: Der senkrechte Strich heißt **„oder“**. Wer den Wert benutzt, muss mit beidem rechnen.

### CadQuery-Typen

| Typ | Bedeutung |
|---|---|
| `cf.Shape` | Oberbegriff für alle Formen |
| `cf.Solid`, `cf.Face`, `cf.Wire`, `cf.Edge` | die konkreten Topologie-Elemente aus Einheit 2 |

- Grundkörper wie `cf.box` und `cf.cylinder` liefern `cf.Solid`.
- Boolean, Fillet, Extrude, Loft und Selektoren liefern `cf.Shape`, weil der genaue Typ des Ergebnisses von der Geometrie abhängt.

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

### Auflösung: A, B und C

- **A:** `cf.box` liefert `Solid`, `cf.fillet` ein `Shape`. Eine Variable behält für mypy den Typ ihrer ersten Zuweisung. Abhilfe: ein neuer Name (`platte_rund`) oder der Typ bei der ersten Zuweisung (`platte: cf.Shape = cf.box(...)`).
- **B:** `faces(...)` liefert `Shape`. Trifft der Selektor eine Fläche, ist es ein `Face`, bei mehreren ein `Compound`. `outerWire` gibt es nur am `Face`.
- **C:** `zapfen_d` kann `None` sein. Erst nach `if p.zapfen_d is not None:` weiß der Type-Checker, dass es ein `float` ist.

Pylance meldet nur B und C. mypy ist bei Zuweisungen strenger, deshalb läuft in der CI mypy.

### Den Typ verengen: `assert isinstance`

Für B gibt es drei Wege, aber nur einer ist gut:

```python
boden = platte.faces("<Z")              # Typ: Shape

cast(cf.Face, boden)                    # aus typing: behauptet es, prüft nichts
boden.outerWire()  # type: ignore       # blendet die Meldung nur aus

assert isinstance(boden, cf.Face)       # prüft es wirklich und verengt den Typ
kontur = boden.outerWire()
```

`isinstance(x, Typ)` ist `True`, wenn `x` von diesem Typ ist. `assert bedingung` bricht mit Fehler ab, wenn die Bedingung falsch ist. Trifft der Selektor einmal zwei Flächen, scheitert diese Zeile **an Ort und Stelle**. Die anderen zwei Wege schweigen.

> Führt eine KI ein `# type: ignore` ein, das Sie nicht verstehen: nachfragen.

## Praktikum A: den Modul-Code annotieren

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

### Aufgabe 1: Den Modul-Code sammeln

1. Legen Sie `w07/modul.py` an. Darin stehen `ModulParam`, `zelle_bauen` mit dem Tab aus Einheit 4 (Aufgabe 1), `stapel_bauen` mit Flip und `endplatten`.
2. Stapel und untere Endplatte beginnen bei z = 0, ohne Grundplatte. Die Lage im Modul kommt erst beim Zusammenbau.
3. Stellen Sie alles, was baut und anzeigt, unter `if __name__ == "__main__":`.

*Prüfen:* Die Datei startet wie bisher mit dem Viewer. Im Projektordner läuft `uv run python -c "import w07.modul"` ohne Ausgabe und ohne Viewer.

*Hinweise:* Fehlt Ihnen etwas aus Einheit 3 oder 4, nehmen Sie die Referenzlösung.

### Aufgabe 2: Annotieren

1. Annotieren Sie alle Funktionen vollständig: Parameter **und** Rückgabetyp.
2. Machen Sie die Zentrierbohrung optional: Mit `zapfen_d=None` entstehen Endplatten ohne Bohrung.
3. Schreiben Sie `zelle_bauen("12")`. Was zeigt Pylance? Was passiert beim Ausführen?

*Hinweise:* `-> cf.Shape` für Geometrie-Funktionen, `float | None` für das Feld

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

### Aufgabe 3: mypy aufräumen

1. Führen Sie auf der Kommandozeile aus und **beheben Sie jede gemeldete Zeile**, bis mypy `Success` meldet:

```bash
uv run mypy w07/
```

2. Kopieren Sie die Zeilen A–D aus der Abstimmung in eine Datei `probe.py` im Projektordner, mit `from w07.modul import ModulParam` und `from cadquery import func as cf`. Prüfen Sie Ihre Antwort mit `uv run mypy probe.py`.
3. Führen Sie `uv run mypy .` für das ganze Repo aus. Welche Meldungen aus früheren Wochen entsprechen A, B oder C?

*Hinweise:* Wo ein `Shape` zu allgemein ist, verengen Sie mit `assert isinstance`. Die früheren Wochen müssen Sie nicht aufräumen.

## Theorie B: Unittests

### Regression

```
* 2e9d54a  Stapel auf Flip umgebaut         ← ab hier fehlt das Kompressionspad
* c04f81a  Tab an der Zelle ergänzt
* f3a17bc  Erste Version des Stapels
```

**Regression:** Etwas war korrekt und ist es nach einer Änderung nicht mehr.

Ohne Tests fällt das irgendwann am falschen Bauteil auf. Ein Test meldet es beim nächsten Commit.

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

### `pytest.approx` – Fließkomma

```python
assert zelle.Volume() == 160932.0                           # spröde
assert zelle.Volume() == pytest.approx(160932, rel=1e-6)    # relativ
assert zelle.Volume() == pytest.approx(160932, abs=0.1)     # ± 0,1 mm³
```

Geometrieoperationen sammeln Rundungsfehler ($0.1 + 0.2 \neq 0.3$). Exakte Gleichheit scheitert deshalb zufällig.

`approx` braucht `import pytest` am Anfang der Testdatei.

### Was am CAD-Code prüfen?

| Prüfung | findet |
|---|---|
| `isValid()`, `len(Solids()) == 1` | kaputte Topologie, Fläche statt Körper |
| `Volume()` gegen eine Formel | falsche Maße, fehlende oder zusätzliche Features |
| `BoundingBox()` | falsche Außenmaße und Lage |
| `(a * b).Volume() == 0` | zwei Teile durchdringen sich |

Zur Erinnerung aus Einheit 6: `*` bildet die geometrische Schnittmenge, `&` die Schnittmenge von Auswahlen.

### Welcher Test findet welchen Fehler?

| Test | prüft |
|---|---|
| **1** | Volumen der Zelle, `rel=1e-6` |
| **2** | Höhe des Stapels |
| **3** | Anzahl der Solids im Stapel = `n_zellen` |
| **4** | Stapel `*` Endplatten hat Volumen 0 |

| Fehler im Code | |
|---|---|
| **A** | Fillet vergessen: `return roh + tab` |
| **B** | Kompressionspad vergessen: `pitch = p.zell_t` |
| **C** | Bohrung addiert: `unten + bohrung` statt `unten - bohrung` |
| **D** | Flip vergessen, alle Tabs auf derselben Seite |

### Auflösung

- **A → 1:** Ohne Fillet ist die Zelle nur 340 mm³ größer, das sind 0,2 %. Mit `rel=0.01` bliebe Test 1 grün.
- **B → 2 und 3:** Ohne Kompressionspad berühren sich die Zellen, und `+` verschmilzt sie zu einem einzigen Körper.
- **C → 4:** Aus der Bohrung wird ein Zylinder, der 1 mm aus der Platte in den Stapel ragt.
- **D → keiner.** Ein Test prüft nur, was er prüft. Hier fehlt einer für die Tab-Seiten, etwa die Breite des Stapels: Mit Flip ist `xlen` 172 mm, ohne 160 mm.

### Was ist an diesen Tests faul?

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

### CI: bei jedem Push (GitLab)

**Continuous Integration:** Nach jedem Push checkt ein Rechner auf dem GitLab-Server Ihr Projekt frisch aus und arbeitet die `.gitlab-ci.yml` in Ihrem Repo ab:

```yaml
tests:
  script:
    - uv sync --locked          # exakt die Versionen aus uv.lock
    - uv run pytest tests/ -q
```

Diese Datei liegt seit Woche 1 im Repo, und die Pipeline lief still mit. Ab heute ist sie Ihr Werkzeug: grünes ✓ oder rotes ✗ direkt am Commit.

Darunter steht auskommentiert ein zweiter Job `typen` mit `uv run mypy .` und `allow_failure: true`. Er meldet Typfehler gelb am Commit, blockiert die Pipeline aber nicht.

## Praktikum B: das Modul testen

### Aufgabe 4: Geometrie-Tests

Schreiben Sie `tests/test_w07.py` mit Tests für:

1. Die Zelle ist ein gültiger Körper.
2. Das Volumen der Zelle gegen einen **selbst gerechneten** Sollwert: Quader, Ecken, Tab.
3. Die Höhe des Stapels, und der Grenzfall `ModulParam(n_zellen=1)`.
4. Ein Test, der den vergessenen Flip bemerkt.

*Prüfen:* Ihr Sollwert in 2 liegt bei etwa 160 900 mm³.

*Hinweise:* Wie viel Fläche nimmt eine Rundung mit Radius $r$ an einer Ecke weg? `uv run pytest -v`

### Aufgabe 5: Kollision

1. Testen Sie, dass sich die Zellen im Stapel nicht berühren.
2. Testen Sie, dass Stapel und Endplatten sich nicht durchdringen.
3. Machen Sie beide Tests einmal absichtlich kaputt: `spacer=0` und `unten + bohrung`. Werden sie rot? Machen Sie die Änderung danach rückgängig.

*Hinweise:* Im Modul liegt der Stapel um `platten_t` höher als die untere Endplatte. `pytest.approx(0, abs=1e-6)`

### Aufgabe 6: CI und die Regression selbst auslösen

1. Committen und pushen Sie `w07/` und `tests/test_w07.py`. Läuft die Pipeline grün?
2. Aktivieren Sie den Job `typen` in der `.gitlab-ci.yml`: Entfernen Sie die `#` vor seinen Zeilen und pushen Sie. Welche Farbe hat der Job, und warum?
3. Bauen Sie den Fehler B ein: `pitch = p.zell_t`. Sagen Sie voraus, welche Ihrer Tests rot werden. Pushen Sie und prüfen Sie es an der Pipeline. Machen Sie die Änderung danach rückgängig.

### Aufgabe 7 *(Zusatz)*: Ein Test, viele Parametersätze

```python
@pytest.mark.parametrize("n", [1, 2, 5, 12])
def test_stapel_ueber_n(n):
    p = ModulParam(n_zellen=n)
    ...
```

pytest führt den Test einmal für jedes `n` aus und meldet jeden Lauf einzeln.

1. Prüfen Sie für jedes `n` die Anzahl der Solids und die Höhe.
2. Nehmen Sie `0` in die Liste auf. Was meldet pytest? Was sollte `stapel_bauen` stattdessen tun?

## Abschluss

### Leseauftrag & Ausblick

- **Leseauftrag:** Buch Kapitel 8, Abschnitte „Testing Geometry“, „Types as Contracts“ und „Verification on Every Change“
- **KI-Werkzeuge:** Mit Typen und Tests arbeiten KI-Assistenten zuverlässiger. Material zum Setup liegt auf der Kursseite (Selbststudium).
- **Wer mehr will:** einen Test *zuerst* schreiben (Red → Green), dann die Funktion dazu
- **Nächste Woche:** Datenaustausch: Assembly, BOM und STEP-Export des ganzen Moduls
- Bis dahin: `w07/` und `tests/test_w07.py` committet und gepusht, Pipeline grün
