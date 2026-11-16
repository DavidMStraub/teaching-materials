---
marp: true
theme: hm
paginate: true
language: de
footer: Programmieren – D. Straub
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

# Programmieren – 10. Diagramme mit matplotlib

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, dann ausführen:

```python
def spanne(werte):
    return werte[0], werte[-1]

a, b = spanne([3, 8, 5])
print(a, b)
```

### Heute lernen Sie

- Daten als **Diagramm** darstellen: `matplotlib`
- Diagramme **beschriften**: Titel, Achsen, Gitter
- **Mehrere Datenreihen** und **markierte Punkte**
- Den Titel **vom Ergebnis abhängig** machen

## Der erste Plot

### Kennen Sie schon: die Demo aus Woche 1

Heute bauen Sie sie selbst.

```python
import matplotlib.pyplot as plt

stunden = [8, 9, 10, 11, 12, 13, 14, 15]
temperaturen = [18.2, 19.1, 21.4, 24.0, 26.3, 27.1, 25.8, 22.5]

plt.plot(stunden, temperaturen)
plt.show()
```

- `import matplotlib.pyplot as plt`: Der Kurzname `plt` ist überall üblich
- `plt.plot(x, y)`: erste Liste auf die x-Achse, zweite Liste auf die y-Achse
- `plt.show()` zeigt das Bild an

### Beschriftung

```python
plt.plot(stunden, temperaturen)
plt.xlabel("Uhrzeit")
plt.ylabel("Temperatur in °C")
plt.title("Tagesverlauf")
plt.grid(True)
plt.show()
```

- `xlabel`, `ylabel`: Größe und Einheit an jede Achse
- `title`: Überschrift über dem Diagramm
- `grid(True)`: Gitterlinien zum Ablesen
- Alles zwischen `plot` und `show`

### Mini-Aufgabe (3 min)

Eine Zelle wird mit 1 A entladen:

```python
zeit_h = [0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0]
spannung_V = [4.17, 3.80, 3.63, 3.55, 3.50, 3.44, 3.28]
```

1. Zeichnen Sie den Spannungsverlauf
2. Beschriften Sie beide Achsen mit Größe und Einheit, ergänzen Sie Titel und Gitter
3. In welchem Abschnitt fällt die Spannung am stärksten?

### Achtung typischer Fehler

```python
plt.plot(stunden, temperaturen)
plt.show
```

Keine Fehlermeldung, aber auch **kein Bild**.

- `plt.show` ohne Klammern **ruft die Funktion nicht auf** (Woche 6: erst die Klammern führen aus)

## Stil und mehrere Datenreihen

### Stil-Strings: die Referenz

```python
plt.plot(x, y, "b-")    # blau, durchgezogene Linie
plt.plot(x, y, "r--")   # rot, gestrichelt
plt.plot(x, y, "g:")    # grün, gepunktet
plt.plot(x, y, "ko")    # schwarz, nur Punkte
plt.plot(x, y, "b-o")   # blau, Linie mit Punkten
```

| Farbe | | Linie | | Marker | |
|---|---|---|---|---|---|
| `b` | blau | `-` | durchgezogen | `o` | Punkt |
| `r` | rot | `--` | gestrichelt | `+` | Plus |
| `g` | grün | `:` | gepunktet | `s` | Quadrat |
| `k` | schwarz | | | | |

### Zweite Datenreihe und markierte Punkte

```python
prognose = [17.5, 19.0, 21.0, 23.5, 25.5, 26.5, 26.0, 23.0]

plt.plot(stunden, temperaturen, "b-")
plt.plot(stunden, prognose, "r--")
plt.plot([13], [27.1], "ro")
plt.show()
```

- Jeder weitere `plot`-Aufruf **vor** `show()` zeichnet ins selbe Diagramm
- Ein **einzelner Punkt**: Listen mit nur einem Element plus Marker-Stil. So heben Sie ein Maximum oder eine Nullstelle hervor

### Mini-Aufgabe (3 min)

In Ihrem Entlade-Diagramm:

1. Zeichnen Sie die Messpunkte als schwarze Punkte über die Linie
2. Markieren Sie den letzten Messpunkt als **roten Punkt**, ohne die Werte abzutippen
3. Zeichnen Sie eine rot gestrichelte Linie bei 3,3 V über die ganze Messdauer

### Der dynamische Titel

```python
maximum = temperaturen[0]
for t in temperaturen:
    if t > maximum:
        maximum = t

if maximum > 25:
    titel = f"Warnung: Höchstwert {maximum:.1f} °C"
else:
    titel = "Alles im Normalbereich"

plt.title(titel)
```

- Das Diagramm sagt etwas anderes, je nachdem, was herauskommt
- Den Titel per `if` in einer Variable festlegen, dann an `plt.title` übergeben

### Debug-Aufgabe (3 min)

Zwei Fehler, finden und beheben:

```python
import matplotlib.pyplot as plt

zeiten = [0, 1, 2, 3]
werte = [0, 2, 8, 18]

plt.plot(zeiten werte)
plt.xlabel("Zeit in s")
plt.grid(True)
plt.show
```

### Datenreihen berechnen

Berechnete Kurven entstehen aus **Schleife und Funktion**. Das Pendel aus Woche 6:

```python
import math

def schwingungsdauer(laenge):
    return 2 * math.pi * math.sqrt(laenge / 9.81)
```

Gesucht: die Schwingungsdauer für Pendellängen von 0,1 m bis 2,0 m als Kurve.

### Listen füllen, dann zeichnen

```python
laengen = []
dauern = []
for i in range(1, 21):
    laenge = i * 0.1
    laengen.append(laenge)
    dauern.append(schwingungsdauer(laenge))

plt.plot(laengen, dauern, "b-o")
plt.show()
```

- Leere Listen, Schleife, `append`: x-Wert und Funktionswert gemeinsam anhängen
- `range` liefert nur ganze Zahlen. Für Schritte von 0,1 m: ganzzahlig zählen und umrechnen

## Transfer

### Aufgabe: Batterie-Alterung (Denkphase: 6 min, auf Papier)

Ein Programm aus allen Bausteinen: **Eingabe, Funktion, Schleife, Diagramm**

1. Zyklenzahl `n` **einlesen** (`int`)
2. Funktion `restkapazitaet(zyklen)`, die die Restkapazität in % zurückgibt (`return`): `100 - 0.015 * zyklen`
3. **Schleife**: Von 0 bis `n` in 100er-Schritten zwei Listen füllen, Zyklen und Restkapazität
4. **Diagramm** mit Achsenbeschriftung und Gitter
5. **Titel per `if`**: Liegt die Restkapazität am Ende unter 80 %: `Warnung: Batterie altert!`, sonst `Batterie ok`

Probe: `restkapazitaet(1000)` → `85.0`

### Batterie-Alterung: Denkphase

Notieren Sie auf Papier:

- Welche Bausteine in welcher Reihenfolge?
- Was gehört in die Funktion, was ins Hauptprogramm?
- Woher kommt der Wert, den der Titel bewertet?

Zusatz für Schnelle:

- Den letzten Punkt der Kurve rot markieren
- Die Eingabe prüfen: nur Zyklenzahlen über 0 annehmen

### Gemeinsam live

Wir entwickeln die Lösung jetzt zusammen.

### Mini-Check

Ohne Computer:

1. Was bedeutet der Stil-String `"r--"`?
2. Wie kommt eine zweite Linie ins selbe Diagramm?
3. Wie markiert man einen einzelnen Punkt?

### Bis nächste Woche!

Nächste Woche: **Zahlensysteme**, wie Computer Zahlen speichern, und warum `0.1 + 0.2` nicht `0.3` ergibt

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
