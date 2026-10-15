---
marp: true
theme: hm
paginate: true
language: de
footer: CAx-Programmierung – D. Straub
headingDivider: 3
---

# Programmierung von CAx-Systemen

David Straub

### Gliederung

1. Einführung
2. Topologie
3. **Grundformen**
4. Kurven
5. Freiformgeometrie
6. Profile
7. Codequalität
8. Datenaustausch
9. Robustheit
10. Simulation
11. Optimierung

## Grundformen

- **Feature-basiert:** Reihenfolge der Konstruktion
- **Extrude & Revolve:** Profil → Körper
- **Muster als Schleifen:** Raster, linearer Stapel
- **Konstruktionsebenen:** aus Flächen ableiten
- **Spiegeln & Drehen:** Symmetrie und Lage
- **Parametersätze:** als Dataclass

*Durchgängiges Beispiel:* die Pouch-Zelle, der Zellstapel und die Endplatten

### Ihr Zentrierzapfen aus Einheit 2

```python
from cadquery import func as cf

platte = cf.box(170, 110, 6)
zapfen = cf.cylinder(d=16, h=8).moved(cf.Location((0, 0, 6)))   # sitzt auf z = 6
teil = platte + zapfen
```

Wird die Platte 10 mm dick, bleibt der Zapfen bei z = 6 stehen und steckt 4 mm tief in der Platte.

**Ihre Idee:** Woher kann der Code die Höhe nehmen, statt `6` einzutippen? Eine Zeile Code oder Pseudocode genügt.

## Feature-basiertes Modellieren

### Zwei Varianten derselben Platte

Ein Modell ist eine Abfolge von **Features** (`extrude`, `+`, `-`, `fillet`, …). Hier: Der Rand einer Tasche für eine Rundzelle bekommt eine Einführrundung; daneben sitzt ein Befestigungsloch.

```python
platte = cf.box(40, 30, 6)
tasche = cf.cylinder(d=18.6, h=3).moved(cf.Location((0, 0, 3)))
loch   = cf.cylinder(d=3.4, h=6).moved(cf.Location((16, 11, 0)))

basis = platte - tasche
rand  = basis.edges(">Z and %CIRCLE")
a = cf.fillet(basis, rand, 1.0) - loch

basis = platte - tasche - loch
rand  = basis.edges(">Z and %CIRCLE")
b = cf.fillet(basis, rand, 1.0)
```

**Beide laufen fehlerfrei. Worin unterscheiden sich `a` und `b` – und warum?**

### Selektoren fragen den aktuellen Stand

Ein Selektor beantwortet seine Frage **an dem Modell, wie es in seiner Zeile steht**:

- `a` – erst runden, dann bohren: Nur die Tasche existiert – `"%CIRCLE"` findet **einen** Rand.
- `b` – erst bohren, dann runden: Das Loch existiert schon – `"%CIRCLE"` findet **zwei** Ränder. Der Lochrand, auf dem der Schraubenkopf plan aufliegen soll, wird mit verrundet.

Beide Ergebnisse sind `isValid()`; nur die Volumendifferenz von 2,6 mm³ verrät den Fehler.

**Bewährte Reihenfolge:** Grundform → hinzufügen (Zapfen, Rippen) → abziehen (Bohrungen, Taschen) → Finishing (Verrundungen, Fasen). Entscheidend ist aber, wovon jede Operation abhängt. Hier gibt es zwei saubere Lösungen: runden, solange der Taschenrand der einzige Kreis ist – oder präziser fragen und den Rand über seinen Radius wählen.

## Vom Profil zum Körper

### Von der Kurve zur Fläche

`extrude()` und `revolve()` erwarten eine **Fläche** als Eingang:

![w:24cm](assets/kurve_flaeche_koerper.svg)

Der Wire muss **geschlossen und eben** sein – sonst bricht `cf.face()` ab oder liefert eine ungültige Fläche.

### Zwei Wege vom Profil zum Körper

![w:26cm](assets/grundformen_extrude_revolve.svg)

### extrude() – Profil zu Körper

```python
profil = cf.face(cf.rect(20, 10))   # Rechteck, zentriert im Ursprung
block = cf.extrude(profil, (0, 0, 5))
```

**Profil-Bausteine:** `cf.rect(b, h)` · `cf.circle(r)` (Bohrungen!) · `cf.ellipse(r1, r2)` · `cf.polygon(*pts)` · `cf.spline(*pts)` (Freiformkurven → Einheit 5)

`cf.polygon` schließt die Kontur selbst; `cf.polyline` bleibt offen – dort wiederholt der letzte Punkt den ersten:

```python
pts = [(0, 0, 0), (20, 0, 0), (20, 10, 0), (0, 10, 0), (0, 0, 0)]
profil = cf.face(cf.polyline(*pts))
```

### revolve() – Rotationskörper *(zum Kennenlernen)*

Statt ein Profil geradlinig zu schieben, dreht `revolve` es um eine Achse – aus einem **Halbprofil** (x = Radius, z = Höhe) wird ein Rotationskörper:

```python
# Halbprofil in der XZ-Ebene: x = Radius, z = Höhe
halbprofil = cf.face(cf.polyline((0, 0, 0), (15, 0, 0), (15, 0, 8), (0, 0, 8), (0, 0, 0)))
scheibe = cf.revolve(halbprofil, (0, 0, 0), (0, 0, 1), 360)   # volle Umdrehung um Z
```

*Das Batteriemodul hat kein Rotationsteil – Revolve zeigen wir diese Woche einmal; die Technik bleibt für später im Werkzeugkasten.*

## Muster: Wiederholung durch Schleifen

### Rechteckraster als Schleife

```python
platte = cf.box(60, 60, 8)
for ix in range(3):
    for iy in range(3):
        x, y = (ix - 1) * 16, (iy - 1) * 16
        loch = cf.cylinder(d=4, h=10).moved(cf.Location((x, y, 0)))
        platte = platte - loch
```

Kein spezielles „Pattern“-Objekt nötig – eine Schleife über `Location`-Werte reicht und bleibt lesbar. Ein linearer Stapel entlang einer Achse ist dasselbe Muster mit nur einer Schleife.

## Konstruktionsebenen

### Konstruktionsebenen aus Flächen ableiten

Eine `Plane` ist ein **lokales Koordinatensystem** – Ursprung plus Ausrichtung. Aus einer Fläche abgeleitet sitzt sie genau auf dieser Fläche – eine Antwort auf die Frage zum Zentrierzapfen:

```python
platte = cf.box(170, 110, 6)
oben   = platte.faces(">Z")
ebene  = cf.Plane(origin=oben.Center())
zapfen = cf.cylinder(d=16, h=8).moved(cf.Location(ebene))
```

> **Wird die Platte dicker, wandert der Zapfen mit** – ein fest eingetipptes `z = 6` bliebe stehen.
> Die Ebene ist so treffsicher wie der Selektor, der die Fläche findet – mehr dazu in Aufgabe 2.

### Auf der Ebene platzieren: Wo landet der Zapfen?

```python
platte = cf.box(170, 110, 6)
oben   = platte.faces(">Z")
ebene  = cf.Plane(origin=oben.Center())

a = cf.cylinder(d=16, h=8).moved(cf.Location(ebene) * cf.Location((40, 0, 0)))
b = cf.cylinder(d=16, h=8).moved(cf.Location(ebene, (40, 0, 0)))
```

**Sagen Sie zuerst voraus:** Beide Zeilen laufen fehlerfrei durch. Wo sitzen `a` und `b`?

A) beide auf der Platte &nbsp;&nbsp; B) `a` auf, `b` in der Platte
C) `a` in, `b` auf der Platte &nbsp;&nbsp; D) beide in der Platte

### Locations verketten mit `*`

![bg right:40% 85%](assets/cax03_location.png)

- `a`: Mittelpunkt (40, 0, 10) – sitzt **auf** der Platte
- `b`: Mittelpunkt (40, 0, 4) – steckt **in** der Platte

`cf.Location(ebene)` ist die Lage der Ebene; die **Multiplikation** hängt einen lokal in dieser Ebene gemessenen Versatz an.

`cf.Location(ebene, (40, 0, 0))` ersetzt dagegen den Ursprung der Ebene durch den angegebenen Punkt – in globalen Koordinaten. Das Ergebnis liegt um die volle Plattendicke daneben.

## Praktikum A: Zelle und Zellstapel

### Aufgabe 1: Pouch-Zelle extrudieren

Bauen Sie eine Pouch-Zelle – im Kern ein flacher Block mit gerundeten Ecken:

- **148 × 98 × 11 mm**, Ecken mit **r = 6 mm** gerundet

*Hinweise:* `cf.rect`, `cf.face`, `cf.extrude`, `cf.fillet(form, kanten, r)`

*Prüfen:* `zelle.isValid()`; Volumen ungefähr 148 · 98 · 11

### Aufgabe 2: Stapeln und auf der Grundplatte platzieren

1. Stapeln Sie **12 Zellen** mit einer Schleife, Abstand **12,5 mm** (Zelldicke + 1,5 mm Kompressionspad). Beginnen Sie mit `stapel = zelle` und addieren Sie in der Schleife verschobene Kopien.
2. Leiten Sie aus Ihrer Grundplatte – **mit** Zentrierzapfen – eine Ebene auf der **Plattenoberseite** ab. **Sagen Sie zuerst voraus:** Welche Fläche liefert `grundplatte.faces(">Z")`? Prüfen Sie mit `.Center()`.
3. Setzen Sie den Stapel **8 mm** über diese Ebene – dazwischen liegt in Teil B die untere Endplatte.

*Hinweise:* `.moved(cf.Location(...))`, `cf.Plane(origin=...)`, `cf.Location(ebene) * cf.Location(...)`, Selektortabelle aus Einheit 2

*Prüfen:* Unterseite des Stapels bei z = 14 (`stapel.BoundingBox().zmin`)

## Spiegeln und Drehen

### Spiegeln statt zweimal bauen

Zwei symmetrische Features sind eine Entscheidung plus ihr Spiegelbild:

```python
loch = cf.cylinder(d=4, h=10).moved(cf.Location((30, 0, 0)))
loecher = loch + loch.mirror("YZ", basePointVector=(0, 0, 0))
```

`mirror` spiegelt an einer Ebene (hier „YZ“ durch den Ursprung) und gibt die gespiegelte Kopie zurück – Original und Kopie zusammen ergeben beide Löcher aus einer einzigen Platzierung. Gleich bei den Endplatten angewendet.

### Spiegeln: Wie viele Löcher?

```python
loch = cf.cylinder(d=4, h=10).moved(cf.Location((30, 0, 0)))
loecher = loch + loch.mirror("XZ", basePointVector=(0, 0, 0))
```

**Wie viele Löcher beschreibt `loecher`?** &nbsp; A) keins &nbsp;&nbsp; B) eins &nbsp;&nbsp; C) zwei &nbsp;&nbsp; D) Fehlermeldung

### Rotation: Drehen mit `moved`

```python
gedreht = cf.box(20, 5, 5).moved(rz=45)
```

`moved` nimmt Verschiebung (`x`, `y`, `z`) und Drehung (`rx`, `ry`, `rz`, in Grad) gemeinsam entgegen. Eine Drehung erfolgt **immer um den Ursprung** – nicht um den Mittelpunkt des Bauteils, außer der liegt zufällig dort.

Was daraus für die Reihenfolge von Drehen und Verschieben folgt, zeigt nächste Woche der Zell-Flip im Stapel.

## Parameter als Dataclass

### Welche Zahlen stecken in Ihrem Code?

Öffnen Sie Ihren Code aus Praktikum A und sammeln Sie **alle Zahlen** darin.

1. Welche sind **Grundmaße**, die Sie frei wählen?
2. Welche **ergeben sich** aus anderen – und aus welchen?
3. Welche Zahl müssten Sie ändern, wenn die Zellen 14 mm dick werden? An wie vielen Stellen?

### Warum die Maße bündeln?

Mit Namen statt Zahlen wird der Code lesbar – aber die Werte liegen lose herum:

```python
zell_b, zell_h, zell_t = 148.0, 98.0, 11.0
n_zellen, spacer, plattenstaerke = 12, 1.5, 8.0

pitch  = zell_t + spacer                                    # im Stapel
aussen = cf.box(zell_b + 12, zell_h + 12, plattenstaerke)   # in der Endplatte
```

Gleich bauen Sie Zelle, Stapel und Endplatten als **Funktionen**. Reicht man jeder davon ihre Werte einzeln durch, gerät leicht einer in Vergessenheit oder zwei passen nicht zusammen.

Besser: alle Maße des Moduls in **einem** Objekt.

### `@dataclass`: Maße in einem Objekt

```python
from dataclasses import dataclass

@dataclass
class ModulParam:
    zell_b: float = 148.0   # mm, Zellbreite
    zell_h: float = 98.0    # mm, Zellhöhe
    zell_t: float = 11.0    # mm, Zelldicke
```

- `@dataclass` ist ein **Dekorator** – er macht aus den Feldern automatisch eine Klasse, von der Sie mit `ModulParam()` einen Parametersatz erzeugen.
- `: float` ist ein **Typ-Hinweis** (für eine Dataclass nötig): `float` für Maße, `int` für Anzahlen.
- `= 148.0` ist der **Standardwert**.

### Ihr `ModulParam`

Ergänzen Sie die Klasse um die **übrigen Maße** aus Ihrer Zahlenliste von vorhin.

1. Welche Felder kommen dazu? Welcher Typ, welcher Standardwert?
2. Welche Zahlen gehören **nicht** hinein, weil sie sich aus anderen ergeben? Wo werden sie stattdessen berechnet?

### Den Parametersatz benutzen

```python
p = ModulParam()                # alle Standardwerte
duenn = ModulParam(zell_t=8.0)  # einen Wert überschreiben
print(p.zell_t, duenn.zell_t)   # 11.0 8.0

def zell_volumen(p: ModulParam) -> float:   # -> float: gibt eine Zahl zurück
    return p.zell_b * p.zell_h * p.zell_t
```

Eine Funktion bekommt den **ganzen** Parametersatz `p` und holt sich mit `p.name`, was sie braucht.

### Varianten mit `replace()`

```python
from dataclasses import replace

p_standard = ModulParam()
p_dick     = replace(p_standard, zell_t=14.0)
```

**Sagen Sie voraus:** Welchen Wert hat danach `p_standard.zell_t`? Und `p_dick.zell_b`?

## Praktikum B: Endplatten und Zusammenführung

### Aufgabe 3: Zelle und Stapel parametrisch

Überführen Sie Ihren Code aus Praktikum A in die Funktionen `zelle_bauen(p: ModulParam)` und `stapel_bauen(p: ModulParam)`. Beide geben eine Shape zurück.

*Hinweise:* Ihr erweitertes `ModulParam` von vorhin; abgeleitete Werte wie den Zellabstand berechnen Sie in der Funktion aus `p`. `stapel_bauen` darf `zelle_bauen` aufrufen.

*Prüfen:* `stapel_bauen(ModulParam())` liefert denselben Stapel wie in Aufgabe 2 – gleiches Volumen. Und eine Variante mit 8 Zellen (`replace`) baut ohne weitere Änderung.

### Aufgabe 4: Endplatten mit Mirror

![bg right:30% 90%](assets/cax03_modul.png)

Schreiben Sie `endplatten(p: ModulParam)`. Zwei **gleiche** Platten verspannen den Stapel – eine bauen, die andere spiegeln:

- **12 mm größer** als der Zellquerschnitt (Breite und Höhe), **8 mm** dick (= Zapfenhöhe)
- Die untere liegt **auf der Grundplatte**, mit einer **Zentrierbohrung** (⌀ 16 mm) für den Zapfen
- Die obere entsteht durch **Spiegelung** an der Ebene auf halber Stapelhöhe

*Hinweise:* `cf.box`, `.moved(...)`, `.mirror("XY", basePointVector=(0, 0, ...))`

Ergänzen Sie die nötigen Felder in `ModulParam`. *Prüfen:* obere Platte endet bei z = 170,5 mm.

### Aufgabe 5 *(Zusatz)*: alles an einem Parametersatz

Erweitern Sie `ModulParam` um die Maße aus Einheit 1 (Grundplatte) und dieser Einheit (Zellstapel, Endplatten). Ziel: ein einziger `ModulParam()`-Aufruf parametrisiert das bisherige Modul – Grundplatte, Stapel, Endplatten.

## Abschluss

### Leseauftrag & Ausblick

- **Leseauftrag:** Buch Kapitel 3 und 4
- **Wer mehr will:** ein gekerbtes Profil extrudieren (statt Rechteck) oder ein Revolve-Teil (Buchse, Rundstab) frei bauen
- **Nächste Woche:** Kurven – die Mathematik hinter den `Location`-, Plane- und Rotations-Aufrufen von heute
- Bis dahin: `w03/` committet und gepusht
