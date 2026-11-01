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

# Programmieren – 4. Eingabe und Ausgabe

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, bevor wir es ausführen:

```python
wert = 120

if wert < 1 and wert > 100:
    print("A")
elif wert > 100:
    print("B")
else:
    print("C")
```

### Heute lernen Sie

- Programme, die **Eingaben** entgegennehmen: `input()`
- Werte in einen anderen Typ **umwandeln**: `int()`, `float()`
- Ausgaben **formatieren**: f-Strings
- Das Muster, nach dem fast jedes Programm aufgebaut ist: **Eingabe → Verarbeitung → Ausgabe**

## Eingabe

### Eingaben lesen mit `input()`

```python
name = input("Wie heißen Sie? ")
print("Hallo, " + name + "!")
```

- `input(...)` zeigt den Text an und **wartet**, bis Sie etwas eintippen und Enter drücken
- Die Eingabe landet in der Variable
- Wieder eine Funktion: Aufforderungstext rein, Eingabe raus

### Vorhersage-Aufgabe (2 min)

Was passiert, wenn Sie hier `5` eintippen? Aufschreiben, dann ausführen:

```python
zahl = input("Zahl: ")
print(zahl + zahl)
```

### Warum kommt da 55 heraus?

`input()` liefert **immer** Text (`str`) – egal, was eingetippt wird:

```python
zahl = input("Zahl: ")   # Eingabe: 5 → zahl ist "5"
print(zahl + zahl)       # "5" + "5" → "55"
```

- Kennen Sie aus Woche 2: `+` **verkettet** Text
- Wer rechnen will, muss erst **umwandeln**

### Typumwandlung: `int()` und `float()`

```python
text = input("Zahl: ")    # Eingabe: 5
print(type(text))

zahl = int(text)
print(type(zahl))
print(zahl + zahl)
```

- `int(...)` wandelt einen Wert in eine ganze Zahl, `float(...)` in eine Kommazahl
- Der Typ ändert sich – und damit, was `+` tut: jetzt wird gerechnet
- Funktioniert mit jedem passenden Wert, nicht nur mit Eingaben

### Kurzform: Funktionen verschachteln

```python
alter = int(input("Alter: "))
groesse = float(input("Größe in m: "))

print(alter + 1)
print(groesse * 100)
```

- Von **innen nach außen** lesen: erst `input(...)` liefert Text, dann macht `int(...)` daraus eine Zahl
- Das Ergebnis der inneren Funktion ist der Wert für die äußere – wie bei `print(type(x))` aus Woche 2

### Vorhersage-Aufgabe (2 min)

Zahl oder Fehler? Aufschreiben, dann ausführen:

```python
print(int("42"))
print(float("3.5"))
print(float(7))
print(int(13.7))
print(int("13.7"))
```

### Was `int()` und `float()` annehmen

```
----> 5 print(int("13.7"))

ValueError: invalid literal for int() with base 10: '13.7'
```

- `float(7)` ergibt `7.0` – aus der ganzen Zahl wird eine Kommazahl
- `int(13.7)` ergibt `13` – es schneidet ab, statt zu runden
- `int("13.7")` scheitert: Text für `int(...)` muss wie eine **ganze** Zahl aussehen
- Ebenso `ValueError`: `int("abc")` und `float("3,5")` – Kommazahlen mit **Punkt** eintippen

### Mini-Aufgabe (3 min)

Schreiben Sie einen Reichweiten-Rechner für ein Elektrofahrzeug:

1. Nutzbaren Energieinhalt der Batterie in kWh einlesen (`float`)
2. Verbrauch in kWh/100 km einlesen (`float`)
3. Reichweite berechnen: Energieinhalt geteilt durch Verbrauch, mal 100
4. Ergebnis ausgeben (`print`)

Testen Sie mit 60 kWh und 15 kWh/100 km – das sollte 400 km ergeben.

### Achtung typischer Fehler

```python
energie = input("Energieinhalt in kWh: ")
haelfte = energie / 2
```

```
Cell In[1], line 2
      1 energie = input("Energieinhalt in kWh: ")
----> 2 haelfte = energie / 2

TypeError: unsupported operand type(s) for /: 'str' and 'int'
```

- Umwandlung vergessen: `energie` ist Text, und Text lässt sich nicht dividieren
- `TypeError` mit `str` in der Meldung nach einem `input()`: fast immer ein fehlendes `int(...)` oder `float(...)`

## Ausgabe

### Schöner ausgeben: f-Strings

```python
name = "Ada"
reichweite = 397.43589743589746

print(f"Hallo {name}!")
print(f"Reichweite: {reichweite} km")
```

- `f` **vor** dem Anführungszeichen
- Alles in `{...}` wird durch den Wert ersetzt – auch Ausdrücke: `f"Halbe Reichweite: {reichweite / 2} km"`
- Beliebig viele `{...}` in einem f-String: `f"{name} fährt {reichweite} km"`

### Formatieren: Nachkommastellen und Feldbreite

```python
reichweite = 397.43589743589746
messwert = 42

print(f"Reichweite: {reichweite:.1f} km")
print(f"|{messwert:>6}|")
print(f"|{reichweite:>8.1f}|")
```

- `:.1f` – eine Nachkommastelle (`.3f` – drei, …)
- `:>6` – rechtsbündig in 6 Zeichen Breite (praktisch für Tabellen); die `|` sind nur Text und machen die Breite sichtbar
- Beides kombinierbar – und beides begegnet Ihnen ab jetzt jede Woche: Sie kennen es bald auswendig, ohne es zu merken

### Vorhersage-Aufgabe (2 min)

Wie sieht die Ausgabe aus – Zeichen für Zeichen? Aufschreiben, dann ausführen:

```python
print(f"|{3.14159:>8.2f}|")
print(f"|{42:>5}|")
print(f"|{12345:>3}|")
```

Zählen Sie die Leerzeichen!

### Mini-Aufgabe (4 min)

Zurück zu Ihrem Reichweiten-Rechner:

1. Geben Sie die Reichweite mit **genau einer Nachkommastelle** aus: `Reichweite: 400.0 km`
2. Ergänzen Sie eine kleine Tabelle für zwei Verbrauchswerte, `15` und `20` kWh/100 km – Zahlen rechtsbündig unter den Überschriften:

```
Verbrauch  Reichweite
     15.0       400.0
     20.0       300.0
```

### Debug-Aufgabe (3 min)

Dieses Programm soll ausgeben, wie alt Sie nächstes Jahr sind. Finden Sie beide Fehler:

```python
alter = input("Alter: ")
naechstes_jahr = alter + 1
print("Nächstes Jahr sind Sie {naechstes_jahr}")
```

### Das Muster: Eingabe → Verarbeitung → Ausgabe

```python
# 1. Eingabe
spannung = float(input("Spannung in V: "))
strom = float(input("Strom in A: "))

# 2. Verarbeitung
widerstand = spannung / strom

# 3. Ausgabe
print(f"Widerstand: {widerstand:.2f} Ohm")
```

Fast jedes Programm folgt diesem Muster – vom Mini-Skript bis zur Messdaten-Auswertung.

## Transfer

### Aufgabe: Akkulaufzeit 2.0 (Denkphase: 5 min, auf Papier)

Unser Programm aus Woche 2 – jetzt mit echter Eingabe:

1. Kapazität in mAh **einlesen** (`float`)
2. Stromaufnahme in mA **einlesen** (`float`)
3. Laufzeit in Stunden **berechnen**
4. **Ausgeben** (`print`) – mit einer Nachkommastelle **und** in Stunden und Minuten:
   `Laufzeit: 13.7 Stunden (13 h 42 min)`

Notieren Sie zuerst die drei Phasen: Was wird eingelesen? Was berechnet? Was ausgegeben?

Und: Wie kommen Sie von 13.714… Stunden auf 13 h und 42 min?

Zusatz für Schnelle: Geben Sie eine Warnung aus (`print`), wenn die Laufzeit unter 8 Stunden liegt – Woche 3 lässt grüßen.

### Gemeinsam live

Wir entwickeln die Lösung jetzt zusammen.

### Mini-Check

Ohne Computer – was kommt heraus?

1. Welchen Datentyp liefert `input()` – immer?
2. `print(f"{2.5:.2f}")`
3. `eingabe = input(...)` – eingetippt wird `12`. Was gibt `print(eingabe + 1)`?
4. Wie breit ist die Ausgabe von `f"{7:>4}"` – und wo steht die 7?

### 🗳️ Zum Schluss: Was gibt das aus?

Eingetippt wird zuerst `3`, dann `4`:

```python
a = input("a: ")
b = input("b: ")
print(a * 2 + b)
```

A) `10`

B) `334`

C) `64`

D) `TypeError`

### Bis nächste Woche!

Nächste Woche: **Schleifen** – Programme, die Dinge wiederholen

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
