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

# Programmieren – 3. Verzweigungen

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, bevor wir es ausführen:

```python
x = 10
x = x + 5
print(x % 4)
print(type(x / 5))
```

### Heute lernen Sie

- Programme, die **Entscheidungen treffen**: `if`, `elif`, `else`
- **Bedingungen** formulieren mit Vergleichen: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Bedingungen **kombinieren** mit `and`, `or`, `not`

## Bedingungen

### Wahr oder falsch: der Typ `bool`

Vergleiche liefern einen Wahrheitswert – `True` oder `False`:

```python
temperatur = 35
print(temperatur > 30)
print(temperatur == 35)
print(temperatur != 35)
print(type(temperatur > 30))
```

- `==` gleich, `!=` ungleich
- `<`, `<=`, `>`, `>=` wie in der Mathematik

### `=` speichert, `==` vergleicht

```python
spannung = 12          # speichert 12 in spannung
print(spannung == 12)  # vergleicht: True
print(spannung == 13)  # vergleicht: False
```

Ein Zeichen Unterschied, zwei völlig verschiedene Bedeutungen – die häufigste Verwechslung in diesem Semester.

## Verzweigungen

### Entscheidungen mit `if`

```python
temperatur = 35

if temperatur > 30:
    print("Warnung: zu heiß!")

print("Messung beendet.")
```

- Nach `if` steht eine **Bedingung**, dann ein Doppelpunkt
- Der **eingerückte** Block läuft nur, wenn die Bedingung `True` ist
- Die letzte Zeile ist nicht eingerückt – sie läuft **immer**
- Einrückung: 4 Leerzeichen (Tab-Taste) – fehlt sie, meldet Python einen `IndentationError`

### Zwei Wege: `if` / `else`

```python
messwert = 87

if messwert > 100:
    print("Grenzwert überschritten")
else:
    print("Alles im Bereich")
```

### Mini-Aufgabe (3 min)

```python
messwert = 87

if messwert > 100:
    print("Grenzwert überschritten")
else:
    print("Alles im Bereich")
```

1. Führen Sie den Code aus
2. Ändern Sie **genau einen Operator**, sodass der `else`-Zweig beim Wert `87` **nicht** läuft
3. Zurück zum Original: Bei welchem Messwert laufen beide Zweige? Probieren Sie es aus

### Achtung typischer Fehler

```python
alter = 20

if alter = 18:
    print("genau 18")
```

```
  Cell In[1], line 3
    if alter = 18:
       ^
SyntaxError: invalid syntax. Maybe you meant '==' or ':=' instead of '='?
```

- In einer Bedingung wird **verglichen**, nie gespeichert
- Python sagt es Ihnen sogar – Fehlermeldungen lesen lohnt sich
- Den Vorschlag `:=` brauchen Sie in diesem Kurs nicht

### Mehr als zwei Wege: `elif`

```python
ladezustand = 25    # in Prozent

if ladezustand < 10:
    print("Kritisch: sofort laden")
elif ladezustand < 30:
    print("Niedrig")
else:
    print("OK")
```

- Bedingungen werden **von oben nach unten** geprüft
- Nur der **erste wahre** Zweig läuft – danach ist Schluss
- Darum reicht `ladezustand < 30` im zweiten Zweig: wer dort ankommt, hat schon mindestens 10

### Vorhersage-Aufgabe (2 min)

Was gibt der Code aus – bei diesen Werten? Aufschreiben!

```python
ladezustand = 5

if ladezustand < 10:
    print("Kritisch: sofort laden")
elif ladezustand < 30:
    print("Niedrig")
else:
    print("OK")
```

Und was passiert bei `ladezustand = 10`? Bei `ladezustand = 30`? Bei `ladezustand = 100`?

## Bedingungen kombinieren

### `and`, `or`, `not`

```python
druck = 95
temperatur = 25

print(druck > 90 and temperatur > 30)
print(druck > 90 or temperatur > 30)
print(not druck > 90)
```

- `and`: **beide** Bedingungen müssen wahr sein
- `or`: **mindestens eine** muss wahr sein
- `not`: kehrt den Wahrheitswert um

### Warum ist hier `or` richtig – und nicht `and`?

Ein Messwert ist gültig zwischen 1 und 100. Wann ist er **ungültig**?

```python
wert = 0

if wert < 1 or wert > 100:
    print("Ungültiger Messwert!")
```

- Sprachgefühl sagt: „kleiner als 1 **und** größer als 100 ist verboten“
- Logik sagt: keine Zahl ist *gleichzeitig* kleiner als 1 und größer als 100 – mit `and` wäre die Bedingung **immer falsch**
- Faustregel: „ungültig“ ist fast immer ein `or` aus mehreren Verstößen

### Vorhersage-Aufgabe (3 min)

Aufschreiben, dann ausführen:

```python
druck = 95
temperatur = 25

if druck > 90 and temperatur > 30:
    print("A")
elif druck > 90 or temperatur > 30:
    print("B")
else:
    print("C")
```

Und: Welche Werte für `druck` und `temperatur` führen zu `A`? Welche zu `C`?

### Debug-Aufgabe (3 min)

Dieses Programm soll bei Spannungen unter 3,0 V **oder** über 4,2 V warnen. Es warnt aber nie. Finden Sie den Fehler:

```python
spannung = 4.8

if spannung < 3.0 and spannung > 4.2:
    print("Warnung: Spannung außerhalb des Bereichs!")
else:
    print("Spannung ok")
```

## Transfer

### Aufgabe: Ticketpreis (Denkphase: 5 min, auf Papier)

Ein Museum hat folgende Preise:

- unter 6 Jahren: **frei**
- unter 18 **oder** ab 65: **ermäßigt, 5 Euro**
- alle anderen: **12 Euro**

Schreiben Sie ein Programm: Alter in einer Variable, Ausgabe (`print`) des Preises.

Notieren Sie zuerst: Welche Bedingungen? In welcher **Reihenfolge**?

Zusatz für Schnelle: Fangen Sie unsinnige Alter ab (negativ oder über 130) – mit welcher Ausgabe?

### Gemeinsam live

Wir entwickeln die Lösung jetzt zusammen.

### Mini-Check

Ohne Computer – was kommt heraus?

1. `print(5 != 3)`
2. Was ist falsch an `if x = 10:` – und wie heißt es richtig?
3. `alter = 70` – was liefert `alter < 18 or alter >= 65`?
4. `print(3 > 5 and 7 > 5)`

### Bis nächste Woche!

Nächste Woche: **Eingabe und Ausgabe** – Programme, die mit Ihnen reden

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
