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

# Programmieren – 8. Strings

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, dann ausführen:

```python
werte = [3, 8, 5]
werte.append(2)
print(werte[-1])
print(len(werte))
```

### Heute lernen Sie

- Strings Zeichen für Zeichen: **Index, Schleife, Slicing**
- Groß- und Kleinschreibung, Teilstrings finden, Text aufbauen
- **Schleifen in Schleifen** und `for` als `while` schreiben
- Zum Abschluss: **Mini-Probeklausur** (15 min, zählt nicht, zeigt Ihnen, wo Sie stehen)

## Strings als Zeichenketten

### Index und Länge wie bei Listen

```python
wort = "Messwert"

print(wort[0])
print(wort[-1])
print(len(wort))
```

- Ein String ist eine Kette von Zeichen
- Index ab `0`, `-1` ist das letzte Zeichen
- `len` liefert die Anzahl der Zeichen

### Über Zeichen iterieren

```python
for zeichen in "NASA":
    print(zeichen)
```

Damit funktioniert das Zählen aus Woche 7 auch für Text:

```python
text = "Programmieren"
anzahl = 0
for zeichen in text:
    if zeichen == "e":
        anzahl += 1
print(anzahl)
```

### Mini-Aufgabe (3 min)

Schreiben Sie eine Funktion `zaehle_e(text)`, die zurückgibt (`return`), wie oft der Buchstabe `e` in `text` vorkommt.

Testen Sie:

```python
print(zaehle_e("Programmieren"))
print(zaehle_e("Elektrotechnik"))
```

Zählen Sie beide Wörter auch von Hand: Stimmen die Ergebnisse?

### Groß und klein: `upper()` und `lower()`

```python
name = "Elektrotechnik"

print(name.upper())
print(name.lower())
print(name)
```

- `upper()` und `lower()` geben einen **neuen** String zurück. `name` selbst bleibt unverändert
- Damit zählt `zaehle_e(name.lower())` auch das große `E`
- `in` findet auch Teilstrings: `"tech" in name` ergibt `True`

### Slicing: Teilstücke ausschneiden

```python
txt = "ABCDEFGHIJ"

print(txt[2:5])    # CDE
print(txt[:3])     # ABC
print(txt[6:])     # GHIJ
print(txt[-3:])    # HIJ
print(txt[3:-1])   # DEFGHI
```

- `[start:stopp]`: Start ist dabei, Stopp **nicht**, wie bei `range`
- Ohne Start: ab dem Anfang. Ohne Stopp: bis zum Ende
- Negative Werte zählen vom Ende
- Funktioniert genauso für Listen: `werte[1:3]`

### Vorhersage-Aufgabe (3 min)

Aufschreiben, dann ausführen:

```python
txt = "ABCDEFGHIJKLMNOP"

print(txt[0:5])
print(txt[11:-1])
print(txt[-3:-1])
print(txt[-3:])
print(txt[-3])
```

### Mini-Aufgabe (3 min)

```python
datum = "2026-11-16"
```

1. Schneiden Sie Jahr, Monat und Tag per Slicing aus
2. Geben Sie das Datum in deutscher Schreibweise aus (`print`): `16.11.2026`
3. Wie viele Jahre sind es noch bis 2030? Rechnen Sie mit dem ausgeschnittenen Jahr

### Achtung typischer Fehler

```python
wort = "Messwert"
wort[0] = "m"
```

```
TypeError: 'str' object does not support item assignment
```

- Bei Listen ersetzt `werte[0] = ...` ein Element. Einen String kann man nicht verändern
- Stattdessen einen neuen String bauen und zuweisen: `wort = "m" + wort[1:]`

### Text aufbauen: `+=` und `"#" * n`

```python
balken = "#" * 5
print(balken)

zeile = ""
for i in range(4):
    zeile += "ab"
print(zeile)
```

- `"#" * 5` wiederholt den String fünfmal
- `zeile += ...` hängt Text an: leer starten, in der Schleife anhängen, wie beim Aufsummieren

## Verschachtelte Schleifen

### Schleife in der Schleife

```python
for i in range(1, 4):
    for j in range(1, 3):
        print(i, j)
```

- Die **innere** Schleife läuft bei jedem Durchlauf der äußeren **komplett** durch
- Von Hand verfolgen: Wie viele Zeilen Ausgabe? In welcher Reihenfolge?

### Vorhersage-Aufgabe (3 min)

Aufschreiben (Trace-Tabelle!), dann ausführen:

```python
for i in range(3):
    for j in range(i):
        print("*", end="")
    print("!")
```

### `for` als `while` schreiben

Jede `for`-Schleife lässt sich als `while`-Schleife schreiben:

```python
for i in range(5):
    print(i)
```

```python
i = 0
while i < 5:
    print(i)
    i += 1
```

Vorgehen: **Startwert** vor die Schleife, **Bedingung** `i < stopp`, **Erhöhung** ans Ende des Blocks

### Mini-Aufgabe (3 min)

Schreiben Sie als `while`-Schleife, mit gleicher Ausgabe:

```python
for i in range(2, 8):
    print(i, end=" ")
```

Zusatz: Dasselbe für `for i in range(10, 0, -3):`. Passt die Bedingung `i < stopp` noch?

## Mini-Probeklausur

### So läuft es

- Sie bekommen ein **Aufgabenblatt**: drei kurze Aufgaben zum Stoff der Wochen 2 bis 7
- **15 Minuten**, alleine, auf Papier, ohne Ausführen, wie in der Klausur
- Danach korrigieren wir **gemeinsam**
- Die Mini-Probeklausur zählt nicht. Sie zeigt Ihnen, wo Sie nach 8 Wochen stehen und was Sie gezielt üben sollten

### Bis nächste Woche!

Nehmen Sie aus der Mini-Probeklausur mit: **Welche Aufgabenart braucht bei Ihnen noch Übung?**

Nächste Woche: **Funktionen 2 und Struktogramme**, Funktionen mit mehreren Parametern und Rückgabewerten, und Programme auf Papier entwerfen

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
