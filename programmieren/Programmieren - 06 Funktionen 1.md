---
marp: true
theme: hm
paginate: true
language: de
footer: Programmieren – D. Straub
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

# Programmieren – 6. Funktionen 1

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben (von Hand verfolgen!), dann ausführen:

```python
spannung = 100.0
schritte = 0
while spannung > 10:
    spannung = spannung / 4
    schritte += 1
print(schritte, spannung)
```

### Heute lernen Sie

- **Eigene Funktionen** definieren: `def`
- Werte **zurückgeben**: `return` – und der Unterschied zu `print`
- Fertige Funktionen aus Modulen holen: `import math`

### Sie benutzen längst Funktionen

```python
print("Hallo")        # tut etwas: gibt aus
len("Hallo")          # liefert etwas: 5
input("Name: ")       # liefert die Eingabe
int("42")             # liefert die Zahl 42
range(5)              # liefert die Zahlen 0 bis 4
```

Seit Woche 2 rufen Sie Funktionen auf: Werte in die Klammern, Ergebnis zurück – oder eine Wirkung wie die Ausgabe.

Heute bauen Sie zum ersten Mal **eigene**.

## Die erste eigene Funktion

### Was stört an diesem Skript?

```python
c1 = 23.5
f1 = c1 * 9 / 5 + 32
print(f"{c1} °C = {f1} °F")

c2 = -10.0
f2 = c2 * 9 / 5 + 32
print(f"{c2} °C = {f2} °F")

c3 = 100.0
f3 = c3 * 9 / 5 + 32
print(f"{c3} °C = {f3} °F")
```

### Dieselbe Rechnung – einmal aufgeschrieben

```python
def fahrenheit(celsius):
    return celsius * 9 / 5 + 32

print(fahrenheit(23.5))
print(fahrenheit(-10.0))
print(fahrenheit(100.0))
```

- `def` **definiert** die Funktion: Name, ein **Parameter** in Klammern, Doppelpunkt, eingerückter Block
- `return` **gibt das Ergebnis zurück** – es landet an der Stelle des Aufrufs
- Die Rechnung steht **genau einmal** – eine Korrektur wirkt überall

### Wichtig: Definieren führt nichts aus

```python
def fahrenheit(celsius):
    return celsius * 9 / 5 + 32
```

Diese Zelle erzeugt **keine Ausgabe**.

- `def` legt die Funktion nur unter ihrem Namen ab
- Ausgeführt wird der Block erst beim **Aufruf**: `fahrenheit(20)`
- Jeder Aufruf führt den Block neu aus – mit dem übergebenen Wert als `celsius`
- Python liest von oben nach unten: Die Definition muss **vor** dem ersten Aufruf ausgeführt sein

### Mini-Aufgabe (4 min)

1. Schreiben Sie eine Funktion `quadrat(x)`, die x² zurückgibt (`return`). Testen Sie mit `5` und `1.5`
2. Schreiben Sie `reichweite(energie)`: gibt die Reichweite in km zurück, bei einem festen Verbrauch von 15 kWh/100 km. Test: 60 kWh → 400.0 km
3. Rechnen Sie mit den Rückgaben: Wie viele km mehr schafft ein 75-kWh-Akku als ein 60-kWh-Akku?

### Achtung typischer Fehler

```python
def begruessung():
    print("Willkommen zur Messung!")
```

- Die Funktion wurde **definiert**, aber nie **aufgerufen**
- Es fehlt die Zeile: `begruessung()`
- Ohne Parameter bleiben die Klammern leer – bei der Definition und beim Aufruf

### Vorhersage-Aufgabe (2 min)

Welche Aufrufe funktionieren – und was wird ausgegeben? Aufschreiben, dann ausführen:

```python
def fahrenheit(celsius):
    return celsius * 9 / 5 + 32

celsius = 100
temperatur = 20
print(fahrenheit(temperatur))
print(fahrenheit(celsius))
print(fahrenheit(5))
```

### Was in die Funktion hineingeht – und was herauskommt

```python
def netto(brutto):
    ergebnis = brutto / 1.19
    return ergebnis

brutto = 119
preis = 238
print(netto(brutto))   # 100.0 – gleicher Name
print(netto(preis))    # 200.0 – anderer Name
print(ergebnis)        # NameError
```

- Beim Aufruf bekommt der Parameter den **Wert**, der übergeben wird. Wie dieser Wert draußen heißt, spielt keine Rolle: gleich, anders oder gar kein Name
- Variablen, die **in** der Funktion entstehen, gibt es draußen nicht
- Anders als bei `if` und `for`: Variablen aus diesen Blöcken bleiben sichtbar. Aus einer Funktion kommt ein Wert nur über `return` heraus

## `print` vs. `return`

### Vorhersage-Aufgabe (3 min)

Zwei fast gleiche Funktionen – was gibt der Code aus? Aufschreiben!

```python
def f1(x):
    print(x * 2)

def f2(x):
    return x * 2

a = f1(3)
b = f2(3)
print(a)
print(b)
```

### Ausgabe oder Rückgabe?

- `print` = **Ausgabe**: zeigt einen Wert dem *Menschen*
- `return` = **Rückgabe**: übergibt einen Wert dem *Programm* – zum Weiterrechnen
- Eine Funktion ohne `return` gibt automatisch `None` zurück („nichts“)

```python
print(f2(3) + 1)   # 7 – mit Rückgabe kann man rechnen
print(f1(3) + 1)   # TypeError – mit None kann man nicht rechnen
```

### Mini-Aufgabe (4 min)

Nutzen Sie `fahrenheit` in einer Schleife:

1. Geben Sie eine Umrechnungstabelle von −20 °C bis 40 °C in 10er-Schritten aus (`print`), Zahlen rechtsbündig:

```
 -20 °C    -4.0 °F
 -10 °C    14.0 °F
 ...
  40 °C   104.0 °F
```

2. Ändern Sie `fahrenheit` so, dass die Funktion das Ergebnis ausgibt (`print`), statt es zurückzugeben. Lassen Sie dafür die Formatangabe `:>7.1f` weg. Was passiert mit Ihrer Tabelle – und warum?

### Debug-Aufgabe (4 min)

Dieses Programm soll ausgeben (`print`), wie lange das Laden von 55 kWh an einer 11-kW-Wallbox dauert. Finden Sie beide Fehler:

```python
dauer = ladezeit(55)
print(f"Ladedauer: {dauer} h")

def ladezeit(energie):
    stunden = energie / 11
```

## Funktionen aus Modulen

### `import math`

Viele Funktionen sind fertig eingebaut – man muss sie nur holen:

```python
import math

print(math.sqrt(2))
print(math.pi)
```

Oder gezielt einzelne Namen importieren:

```python
from math import sin

print(sin(0.5))
```

Beide Formen sind üblich.

### Mini-Aufgabe (3 min)

Der Sinus von 30° ist 0,5.

1. Berechnen Sie `math.sin(30)` – was kommt heraus?
2. Rechnen Sie den Winkel vorher ins Bogenmaß um (180° entsprechen π) – was kommt jetzt heraus?
3. Schreiben Sie dafür eine Funktion `sinus_grad(winkel)`, die den Sinus eines Winkels in Grad zurückgibt (`return`)

## Transfer

### Aufgabe: Pendel (Denkphase: 5 min, auf Papier)

Die Schwingungsdauer eines Pendels: $T = 2\pi\sqrt{L/g}$ mit $g = 9{,}81\ \mathrm{m/s^2}$

Schreiben Sie ein Programm:

1. Eine Funktion `schwingungsdauer(laenge)`, die T zurückgibt (`return`) – mit `math.pi` und `math.sqrt`
2. Pendellänge in m **einlesen** – nur Werte über 0 annehmen
3. Funktion **aufrufen**
4. Ergebnis **ausgeben** (`print`) mit zwei Nachkommastellen

Probe: 1 m → 2.01 s

### Pendel: Denkphase

Notieren Sie auf Papier:

- Was gehört in die Funktion, was ins Hauptprogramm? Warum steht das `input` nicht in der Funktion?
- Was ist der Parameter, was die Rückgabe?
- Wie schreiben Sie $2\pi\sqrt{L/g}$ in Python?

Zusatz für Schnelle:

- Umgekehrt: `pendellaenge(dauer)` gibt die Länge für eine gewünschte Schwingungsdauer zurück. Wie lang ist ein Pendel mit T = 1 s?
- Ergibt `pendellaenge(schwingungsdauer(2.0))` wieder `2.0`?

### Gemeinsam live

Wir entwickeln die Lösung jetzt zusammen.

### Mini-Check

Ohne Computer:

1. Ausgabe vs. Rückgabe – der Unterschied in einem Satz?
2. Eine Funktion `verdreifache(x)` gibt `3 * x` zurück – was gibt `print(verdreifache(4))` aus?
3. Eine Zelle mit nur einer Funktionsdefinition wird ausgeführt – warum ist keine Ausgabe zu sehen?

### 🗳️ Zum Schluss: Was gibt das aus?

```python
def f(x):
    print(x + 1)
    return x * 2

y = f(3)
print(y + 1)
```

A) `4` und `7`

B) `7`

C) `4` und `6`

D) `6` und `7`

### Bis nächste Woche!

Nächste Woche: **Listen** – viele Werte, eine Variable

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
