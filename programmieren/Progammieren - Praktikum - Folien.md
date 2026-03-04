---
marp: true
theme: hm
paginate: true
language: de
footer: Programmieren/Praktikum – D. Straub
headingDivider: 3
math: katex
---
# Programmieren – Praktikum

**Ingenieurinformatik Teil 1, Wintersemester 2025/26**

David Straub


### Sicherheitsunterweisung für Benutzer der des Verbundlabors KCA

- **Fluchtwege** von jedem Raum links und rechts auf den Flur in das Treppenhaus
- an der Flurdecke sind **grüne beleuchtete Hinweisschilder** als Fluchtwegmarkierung angebracht
- die **Feuerlöscher** befinden sich im Flur und sind mit **roten Hinweisschildern** an den Seitenwänden gekennzeichnet
- die **Feuermelder** befinden sich in beiden Treppenhäusern
- im Brandfall **keinen Aufzug benützen**; Begründung: möglicher Stromausfall
- im Brandfall die **Fenster geschlossen halten**
- wichtige Informationen sind im Raum **ausgehängt**: Raumnutzungsordnung, …
- **Not-Aus-Schalter** sind in allen Räumen vorhanden

![bg 80% opacity:0.15](https://upload.wikimedia.org/wikipedia/commons/2/2f/ISO_Exit_-_Right.svg)


### Gliederung

| Termin | Themen |
|--------|--------|
| [Termin 1](#termin-1) | Variablen, Datentypen, Ein-/Ausgabe, Verzweigungen |
| [Termin 2](#termin-2) | Formatierte Ausgabe, Funktionen |
| [Termin 3](#termin-3) | Schleifen, Listen |
| [Termin 4](#termin-4) | Funktionen vertieft, Module, Fehlerbehandlung |
| [Termin 5](#termin-5) | Listen, verschachtelte Schleifen |
| [Termin 6](#termin-6) | Klausurvorbereitung |


## Termin 1


### Variablen und Datentypen

- `int` (Ganzzahl): `1`, `42`, `-7`
- `float` (Gleitkommazahl): `3.14`, `-0.001`, `2.0`
- `str` (Zeichenkette): `"Hallo"`, `'Welt'`, `"123"`
- `bool` (Wahrheitswert): `True`, `False`

```python
# Variablen zuweisen:
alter = 25              # int
groesse = 1.75          # float
name = "Alice"          # str
student = True          # bool

print(type(alter))      # <class 'int'>
print(type(groesse))    # <class 'float'>
```


### Typumwandlung

```python
# Eingabe ist immer ein String!
eingabe = input("Zahl eingeben: ")   # z.B. "42"
print(type(eingabe))                  # <class 'str'>

# Umwandlung in eine Zahl:
zahl = int(eingabe)        # "42"   → 42
komma = float("3.14")     # "3.14" → 3.14

# Häufiger Fehler:
# print(eingabe + 1)   → Fehler! str + int funktioniert nicht
print(zahl + 1)            # 43 ✓
```


### Operatoren: Arithmetisch

`+`, `-`, `*`, `/`, `//` (ganzzahlig), `%` (Rest), `**` (Potenz)

```python
print(7 / 2)    # 3.5    (normale Division)
print(7 // 2)   # 3      (Ganzzahldivision)
print(7 % 2)    # 1      (Rest)
print(2 ** 8)   # 256    (Potenz)
```

### Operatoren: Vergleich und Logik

**Vergleich** → Ergebnis ist immer `True` oder `False`:

```python
print(5 > 3)    # True
print(5 == 3)   # False   (Achtung: == nicht =)
print(5 != 3)   # True
```

**Logisch**: `and`, `or`, `not`


### Die `input`-Funktion und `print`

```python
name = input("Wie ist dein Name? ")   # Eingabe als str
print("Hallo " + name + "!")          # Ausgabe
```


### f-Strings

```python
name = "Alice"
alter = 30
groesse = 1.75

# Variablen direkt in Strings einbetten:
print(f"Name: {name}, Alter: {alter}")
# → Name: Alice, Alter: 30

# Mit Formatierung (Nachkommastellen):
print(f"Größe: {groesse:.2f} m")
# → Größe: 1.75 m
```


### Verzweigungen: `if` / `elif` / `else`

```python
temperatur = float(input("Temperatur in °C: "))

if temperatur < 0:
    print("Frost – Winterjacke!")
elif temperatur < 15:
    print("Kühl – Pullover empfohlen")
elif temperatur < 25:
    print("Angenehm")
else:
    print("Heiß – T-Shirt-Wetter")
```

- Beliebig viele `elif`-Zweige möglich
- `else` am Ende ist optional
- **Einrückung** (4 Leerzeichen) ist in Python Pflicht!


### Aufgabe: Einheiten umrechnen

In der Luftfahrt werden imperiale Einheiten verwendet. Schreiben Sie ein Programm zur Einheitenumrechnung.

**Umrechnungsfaktoren:**
- 1 ft (Fuß) = 0,3048 m
- 1 NM (Seemeile) = 1852 m

**Teil 1:** Fragen Sie den Benutzer nach einer Höhe in Fuß und geben Sie den Wert in Metern aus.

Beispiel: `Höhe in Fuß: 2000` → `2000 ft = 609.60 m`

**Teil 2:** Fragen Sie zusätzlich nach einer Entfernung in Seemeilen und geben Sie sie in Kilometern aus.

**Teil 3:** Fragen Sie zunächst, was umgerechnet werden soll (`1` = Fuß → Meter, `2` = Seemeilen → km), und führen Sie dann die entsprechende Umrechnung durch. Verwenden Sie `if`/`elif`.


### Zusatzaufgaben: Termin 1

**Zusatz 1: Geschwindigkeit**
1 kn = 1 NM/h ≈ 0,5144 m/s. Erweitern Sie das Programm um die Option Knoten → m/s.

**Zusatz 2: Rückumrechnung**
Ergänzen Sie Optionen zur Rückumrechnung (Meter → Fuß, km → Seemeilen).

### Zusatzaufgabe: Schwebedauer

Ein Multicopter benötigt im Schwebeflug eine Leistung von
$$P = \kappa\frac{T^{3/2}}{\sqrt{2 \rho A}}$$
$\kappa$: Effizienz < 1, $T=mg$: Schubkraft, $\rho$: Luftdichte, $A=n \pi r^2$: Rotorfläche

Akku: 3 Ah bei 11,1 V. Berechnen Sie die Schwebedauer in Abhängigkeit von $m$, $n$, $2r$ (mit $\kappa = 0{,}5$).

![bg right:25%](https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Quadcopter_Drone_in_flight.jpg/1024px-Quadcopter_Drone_in_flight.jpg)


## Termin 2


### Formatierte Ausgabe

Feldbreite und Nachkommastellen in f-Strings:

```python
pi = 3.14159265

print(f"{pi:.2f}")       # 3.14   (2 Nachkommastellen)
print(f"{pi:.5f}")       # 3.14159

# Feldbreite: Mindestanzahl Zeichen (rechts- bzw. linksbündig)
print(f"{pi:10.2f}")     #       3.14  (10 Zeichen breit)
print(f"{'Hallo':>10}")  #      Hallo  (rechtsbündig)
print(f"{'Hallo':<10}")  # Hallo       (linksbündig)
```


### Formatierte Ausgabe: Tabellen

```python
print(f"{'Wind (km/h)':>12}  {'Beaufort':>8}")
print(f"{15.0:>12.1f}  {3:>8}")
#    Wind (km/h)  Beaufort
#           15.0         3
```


### Wozu Funktionen?

Gleicher Code für mehrere Messwerte → Code wiederholt sich. Lösung: einmal schreiben, beliebig oft aufrufen.

```python
def celsius_zu_fahrenheit(c):
    f = c * 9/5 + 32
    return f

t1 = celsius_zu_fahrenheit(0)
t2 = celsius_zu_fahrenheit(20)
t3 = celsius_zu_fahrenheit(37)
```


### Funktionen: Syntax

```python
# Definition:
def funktionsname(parameter):
    # Anweisungen
    return ergebnis

# Aufruf:
ergebnis = funktionsname(wert)
```


### Funktionen: Beispiele

```python
def celsius_in_fahrenheit(c):
    return c * 9/5 + 32

print(celsius_in_fahrenheit(0))    # 32.0
print(celsius_in_fahrenheit(100))  # 212.0

# Mehrere Parameter:
def rechteck_flaeche(breite, hoehe):
    return breite * hoehe

print(rechteck_flaeche(3, 4))  # 12
```


### Aufgabe: Windstärke nach Beaufort

Die Beaufort-Skala klassifiziert Windstärken in 13 Stufen (0–12):

| Bf | Windgeschwindigkeit | Beschreibung |
|----|---------------------|--------------|
| 0  | < 1 km/h            | Windstille   |
| 1  | 1–5 km/h            | Leichter Zug |
| 2  | 6–11 km/h           | Leichte Brise |
| 3  | 12–19 km/h          | Schwache Brise |
| 4  | 20–28 km/h          | Mäßige Brise |
| … | … | … |
| 12 | ≥ 118 km/h          | Orkan |

Vollständige Tabelle: [Wikipedia – Beaufort-Skala](https://de.wikipedia.org/wiki/Beaufort-Skala)


### Aufgabe: Windstärke (Teil 1)

Schreiben Sie eine Funktion `beaufort_zahl(v_kmh)`, die die Beaufort-Zahl (0–12) zurückgibt.

```python
print(beaufort_zahl(0))    # 0
print(beaufort_zahl(10))   # 2
print(beaufort_zahl(120))  # 12
```

### Aufgabe: Windstärke (Teil 2)

Schreiben Sie eine Funktion `beaufort_beschreibung(b)`, die die textuelle Beschreibung zurückgibt.

```python
print(beaufort_beschreibung(0))   # Windstille
print(beaufort_beschreibung(9))   # Sturm
```


### Aufgabe: Windstärke (Teil 2)

**Teil 3: Tabelle ausgeben**

Gegeben sind folgende Windmessungen in km/h:

```python
messungen = [0, 5, 15, 30, 55, 80, 95, 120]
```

Geben Sie mithilfe Ihrer Funktionen eine formatierte Tabelle aus:

```
Wind (km/h)   Beaufort   Beschreibung
        0.0          0   Windstille
        5.0          1   Leichter Zug
       15.0          3   Schwache Brise
       30.0          5   Frische Brise
       55.0          8   Stürmischer Wind
       80.0          9   Sturm
       95.0         10   Schwerer Sturm
      120.0         12   Orkan
```


### Zusatzaufgaben: Termin 2

**Zusatz 1: Interaktiv**
Fragen Sie den Benutzer nach einer Windgeschwindigkeit und geben Sie Beaufort-Zahl und Beschreibung aus. Wiederholen Sie dies, bis der Benutzer eine leere Eingabe macht.

**Zusatz 2: Windchill**
Der Windchill beschreibt die gefühlte Temperatur bei Wind. Die Formel (gültig für $v > 4{,}8$ km/h und $T < 10$°C):

$$T_\text{gefühlt} = 13{,}12 + 0{,}6215 \cdot T - 11{,}37 \cdot v^{0{,}16} + 0{,}3965 \cdot T \cdot v^{0{,}16}$$

Schreiben Sie eine Funktion `windchill(T_celsius, v_kmh)` und drucken Sie eine Tabelle für $T \in \{0, -5, -10\}$ und $v \in \{10, 20, 40, 80\}$ km/h.


## Termin 3


### `while`-Schleife

```python
# Solange Bedingung True: Block ausführen
n = 1
while n <= 5:
    print(n)
    n += 1    # Kurzform für n = n + 1
# Ausgabe: 1 2 3 4 5

# break: Schleife vorzeitig beenden
while True:
    eingabe = input("Zahl (> 0): ")
    zahl = int(eingabe)
    if zahl > 0:
        break          # Schleife beenden
    print("Ungültige Eingabe!")
```

**Achtung:** Vergisst man die Aktualisierung (`n += 1`), läuft die Schleife endlos → mit Strg+C abbrechen!


### `for`-Schleife und `range()`

```python
# range(stop): 0, 1, …, stop-1
for i in range(5):
    print(i)           # 0, 1, 2, 3, 4

# range(start, stop)
for i in range(1, 6):
    print(i)           # 1, 2, 3, 4, 5

# range(start, stop, step)
for i in range(0, 10, 2):
    print(i)           # 0, 2, 4, 6, 8

# Über eine Liste iterieren:
namen = ["Alice", "Bob", "Charlie"]
for name in namen:
    print(f"Hallo {name}!")
```


### Listen

```python
zahlen = [3, 1, 4, 1, 5, 9]
leer = []

leer.append(42)          # [42]

print(zahlen[0])    # 3  (erstes Element)
print(zahlen[-1])   # 9  (letztes Element)
print(len(zahlen))  # 6
```

Liste mit Schleife aufbauen:

```python
quadrate = []
for i in range(1, 6):
    quadrate.append(i**2)
# [1, 4, 9, 16, 25]
```


### Aufgabe: Primzahlbestimmung Teil 1

Schreiben Sie eine Funktion `ist_prim`, die überprüft, ob eine Zahl eine Primzahl ist. Die Funktion soll `True` zurückgeben, wenn die Zahl eine Primzahl ist, und `False`, wenn nicht.

Hinweise:

- Eine Primzahl ist eine natürliche Zahl größer als 1, die nur durch 1 und sich selbst teilbar ist.
- Verwenden Sie eine Schleife, um die Teilbarkeit der Zahl durch alle Zahlen ab 2 zu überprüfen
- Überlegen Sie sich, warum es ausreichen würde, nur bis zur Quadratwurzel der Zahl zu prüfen
- Für die Teilbarkeit kann der Modulo-Operator `%` verwendet werden
- Schreiben Sie eine Testfunktion, die die Korrektheit Ihrer Primzahl-Funktion überprüft (z.B. dass sie `True` für 2, 3, 5, 7 und `False` für 1, 4, 6, 8, 9 zurückgibt).

### Primzahlbestimmung Teil 2

Schreiben Sie eine Funktion, die alle Primzahlen bis zu einer gegebenen Zahl `n` findet und in einer **Liste** zurückgibt.

Hinweise:

- Verwenden Sie Ihre Primzahl-Funktion aus Teil 1, um zu überprüfen, ob jede Zahl bis `n` eine Primzahl ist.
- Geben Sie die Liste formatiert aus (z.B. alle Primzahlen bis 50 in einer Zeile).

### Primzahlbestimmung: Zusatzaufgaben

- **Summe der Primzahlen**: Summe aller Primzahlen bis n. Beispiel: n = 10 → 17.

- **Primzahldifferenzen**: Liste der Abstände zwischen aufeinanderfolgenden Primzahlen.
  Beispiel: 2, 3, 5, 7 → `[1, 2, 2]`.

- **Primzahlzwillinge**: Alle Paare $(p, p+2)$, z.B. (3,5), (5,7), (11,13).


## Termin 4


### Funktionen: Vertiefung

```python
# Standardwerte für Parameter:
def potenz(basis, exponent=2):
    return basis ** exponent

print(potenz(3))      # 9  (exponent=2 als Standard)
print(potenz(3, 3))   # 27

# Mehrere Rückgabewerte (werden als Tupel zurückgegeben):
def min_max(liste):
    return min(liste), max(liste)

kleinster, groesster = min_max([3, 1, 4, 1, 5, 9])
print(kleinster, groesster)   # 1 9
```


### Module importieren

```python
import math
import random

print(math.pi)            # 3.141592653589793
print(math.sqrt(16))      # 4.0
print(math.floor(3.7))    # 3

# Zufallszahlen:
print(random.randint(1, 6))    # Ganzzahl 1–6 (Würfel)
print(random.random())          # Kommazahl 0.0–1.0

# Nur bestimmte Namen importieren:
from math import sqrt, pi
print(sqrt(25))    # 5.0  (ohne "math.")
```


### Fehlerbehandlung: `try` / `except`

```python
try:
    eingabe = input("Ganze Zahl: ")
    zahl = int(eingabe)
    print(f"Das Doppelte ist {zahl * 2}")
except ValueError:
    print("Fehler: Das war keine ganze Zahl!")

# Mehrere Fehlertypen:
try:
    x = int(input("Zähler: "))
    y = int(input("Nenner: "))
    print(x / y)
except ValueError:
    print("Keine gültige Zahl!")
except ZeroDivisionError:
    print("Division durch Null!")
```


### Würfelspiel-Simulator

In dieser Aufgabe programmieren Sie einen Simulator für ein Würfelspiel und analysieren verschiedene Strategien.

**Das Spiel „Pig" oder „Böse Eins"**:
- Ein Spieler würfelt mehrmals hintereinander
- Nach jedem Wurf werden die Augen zur Rundenpunktzahl addiert
- Der Spieler kann jederzeit aufhören und die Punkte "sichern"
- **Aber**: Bei einer 1 verliert man alle Punkte der aktuellen Runde!
- Wer zuerst 100 Punkte erreicht, gewinnt

**Ihre Aufgabe**: Testen Sie verschiedene Strategien durch Simulation!

![bg right:25%](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/6sided_dice.jpg/640px-6sided_dice.jpg)

### Würfelspiel-Simulator (Teil 1)

**Teil 1: Grundfunktionen**

Schreiben Sie folgende Funktionen:

**a)** `wuerfle()`:
- Gibt eine Zufallszahl zwischen 1 und 6 zurück
- Verwenden Sie die passende Funktion aus dem Modul `random`

**b)** `spiele_runde(anzahl_wuerfe)`:
- Würfelt `anzahl_wuerfe` mal und speichert alle Würfe in einer **Liste**
- Wenn eine 1 dabei ist: gibt 0 zurück
- Sonst: gibt die Summe aller Würfe zurück
- Gibt außerdem die Liste der Würfe zurück (Rückgabe eines Tupels aus Zahl und Liste)

**Testen Sie** beide Funktionen mit `random.seed` für reproduzierbare Ergebnisse.

### Würfelspiel-Simulator (Teil 2)
**Teil 2: Strategien implementieren**

Eine Strategie legt fest, wie oft man maximal würfelt, bevor man aufhört.

Schreiben Sie eine Funktion `spiele_strategie(max_wuerfe, ziel_punkte)`:
- `max_wuerfe`: Anzahl Würfe pro Runde (die "Strategie")
- `ziel_punkte`: Punkte, die zum Gewinnen nötig sind (z.B. 100)
- Die Funktion spielt das Spiel bis zum Erreichen der Zielpunkte:
    - Speichert die Gesamtpunktzahl in Variable `gesamt`, zählt Runden in `runden`
    - Ruft in jeder Runde `spiele_runde(max_wuerfe)` auf
    - Addiert die Rundenpunkte zu `gesamt`
- Gibt zurück: Anzahl der benötigten Runden

**Testen Sie** mit `max_wuerfe=3` und `ziel_punkte=100`.

### Würfelspiel-Simulator (Teil 2, Fortsetzung)

Erstellen Sie ein **Struktogramm** für die Funktion `spiele_strategie`.


### Würfelspiel-Simulator (Teil 3)

**Teil 3: Mehrfache Simulation**

Schreiben Sie eine Funktion `simuliere_strategie(max_wuerfe, ziel_punkte, anzahl_spiele)`:
- Spielt das Spiel `anzahl_spiele` mal
- Speichert die Anzahl benötigter Runden in einer **Liste**
- Verwendet `random.seed(i)` vor jedem Spiel (mit `i` als Schleifenvariable)
- Gibt die Liste aller Rundenanzahlen zurück

**Führen Sie durch**:
- Simulieren Sie 1000 Spiele für die Strategien "2 Würfe", "3 Würfe", "4 Würfe" und "5 Würfe"
- Speichern Sie die Ergebnisse in verschiedenen Variablen

### Würfelspiel-Simulator (Teil 4)

**Teil 4: Statistische Auswertung**

Schreiben Sie eine Funktion `analysiere_strategie(runden_liste, strategie_name)`:
- Berechnet aus der Liste die folgenden Werte:
    - Durchschnittliche Anzahl Runden (Mittelwert)
    - Minimale Anzahl Runden
    - Maximale Anzahl Runden
    - Standardabweichung: $\sigma = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})^2}$
- Verwenden Sie `math.sqrt()` für die Wurzel

### Würfelspiel-Simulator (Teil 4, Fortsetzung)

Die Funktion `analysiere_strategie` gibt die Ergebnisse formatiert aus:

```
Strategie: [strategie_name]
Durchschnitt: X.X Runden
Min: X Runden, Max: X Runden
Standardabweichung: X.X
```

**Analysieren Sie** alle vier Strategien. Welche ist am effizientesten?


### Würfelspiel-Simulator: Zusatzaufgaben

**Zusatz 1: Optimale Strategie finden**

Schreiben Sie eine Schleife, die alle Strategien von 1 bis 10 Würfen testet (jeweils 1000 Spiele) und die durchschnittliche Rundenanzahl in einer Liste speichert. Finden Sie die optimale Strategie (kleinste durchschnittliche Rundenanzahl).

**Zusatz 2: Risiko-Analyse**

Berechnen Sie für jede Strategie: Wie oft (in Prozent) wird in einer Runde eine 1 gewürfelt und damit die Runde verloren? Verwenden Sie dafür die Wahrscheinlichkeitsrechnung: $P(\text{keine 1}) = (5/6)^n$

**Zusatz 3: Detaillierte Ausgabe**

Erweitern Sie `spiele_runde()` so, dass bei gesetztem optionalen Parameter `debug=True` jeder einzelne Wurf ausgegeben wird, z.B.: "Wurf 1: 4, Wurf 2: 6, Wurf 3: 1 → Runde verloren!"


## Termin 5


### Verschachtelte Schleifen

```python
# Schleife innerhalb einer Schleife:
for i in range(3):
    for j in range(4):
        print(f"({i},{j})", end="  ")
    print()   # Zeilenumbruch nach jeder Zeile

# Ausgabe:
# (0,0)  (0,1)  (0,2)  (0,3)
# (1,0)  (1,1)  (1,2)  (1,3)
# (2,0)  (2,1)  (2,2)  (2,3)

# Typisch: alle Kombinationen zweier Listen vergleichen
a_werte = [1, 2, 3]
b_werte = [10, 20]
for a in a_werte:
    for b in b_werte:
        print(f"{a} + {b} = {a+b}")
```


### Listen: Suchen und Filtern

```python
zahlen = [3, 7, 2, 8, 5, 7]

# Suchen:
print(7 in zahlen)           # True   (ist enthalten?)
print(zahlen.index(8))       # 3      (Position von 8)
print(zahlen.count(7))       # 2      (wie oft kommt 7 vor?)

# Filtern (manuell mit Schleife):
grosse = []
for z in zahlen:
    if z > 4:
        grosse.append(z)     # [7, 8, 5, 7]

# Sortieren:
zahlen.sort()                # In-Place: [2, 3, 5, 7, 7, 8]
sortiert = sorted(zahlen)    # Neue Liste, Original unverändert
```


### List Comprehensions

Kurzschreibweise zum Erstellen von Listen:

```python
# Allgemeines Muster:
# [Ausdruck for Variable in Sequenz (if Bedingung)]

# Quadratzahlen:
quadrate = [i**2 for i in range(1, 6)]
# [1, 4, 9, 16, 25]

# Mit Bedingung (nur gerade Zahlen):
gerade = [i for i in range(10) if i % 2 == 0]
# [0, 2, 4, 6, 8]

# Auf jedes Element einer Liste anwenden:
temps_c = [0, 20, 37, 100]
temps_f = [c * 9/5 + 32 for c in temps_c]
# [32.0, 68.0, 98.6, 212.0]
```


### Aufgabe: Temperaturmessungen auswerten

Gegeben sind Wochenmessungen (in °C) von drei Wetterstationen:

```python
muenchen  = [12.5, 14.1,  9.8, 11.2, 16.3, 18.9, 15.4]
innsbruck = [ 8.3, 10.2,  6.1,  7.9, 12.4, 14.8, 11.1]
venedig   = [15.8, 17.3, 13.2, 14.7, 19.1, 22.4, 18.6]
```

**Teil 1: Grundfunktionen schreiben**

Implementieren Sie (ohne `min()`/`max()` zu verwenden!):

```python
def mittelwert(werte): ...       # Durchschnitt berechnen
def minimum(werte): ...          # Kleinstes Element finden
def maximum(werte): ...          # Größtes Element finden
def ueber_schwelle(werte, s):    # Liste der Werte > s
    ...
```

Testen Sie jede Funktion mit Beispielwerten.


### Aufgabe: Temperaturmessungen (Teil 2)

**Teil 2: Auswertungstabelle**

Wenden Sie Ihre Funktionen auf alle drei Stationen an und geben Sie eine formatierte Tabelle aus:

```
Station       Mittelwert   Minimum   Maximum
München          14.0°C     9.8°C    18.9°C
Innsbruck        10.1°C     6.1°C    14.8°C
Venedig          17.3°C    13.2°C    22.4°C
```

Achten Sie auf Feldbreite und Nachkommastellen!

### Aufgabe: Temperaturmessungen (Teil 3)

**Teil 3: Tage über Schwelle**

An welchen Tagen (Index 0–6) lag die Temperatur an **mindestens zwei** Stationen über 15°C? Verwenden Sie eine Schleife über die Tage und zählen Sie, wie viele Stationen den Schwellwert überschreiten.


### Aufgabe: Temperaturmessungen (Teil 4)

**Teil 4: Verschachtelte Schleifen**

Finden Sie alle **Tagespaare** $(i, j)$ mit $i \neq j$, an denen die Temperaturdifferenz zwischen München und Venedig mehr als 5°C beträgt:

```python
for i in range(len(muenchen)):
    for j in range(len(venedig)):
        if i != j and ...:
            print(f"Tag {i} vs. Tag {j}: ...")
```

### Aufgabe: Temperaturmessungen (Teil 5)

**Teil 5: Programm strukturieren**

Lagern Sie den gesamten Ablauf in eine Funktion `main()` aus und rufen Sie diese am Ende auf:

```python
def main():
    # Daten definieren
    # Auswertungstabelle ausgeben
    # Tage über Schwelle finden
    # Tagespaare ausgeben

main()
```


### Zusatzaufgaben: Termin 5

**Zusatz 1: List Comprehensions**

Schreiben Sie `ueber_schwelle` als einzeilige List Comprehension um. Schreiben Sie außerdem eine Funktion zur Umrechnung aller Werte in Fahrenheit – ebenfalls als List Comprehension.

**Zusatz 2: Visualisierung**

Stellen Sie die Temperaturen der drei Stationen mit `matplotlib.pyplot` als Linienplot dar (x: Tage 1–7, y: Temperatur in °C, mit Legende und Grid).


## Termin 6


### Was haben wir gelernt?

| Termin | Konzepte |
|--------|----------|
| T1 | Variablen, Datentypen, `input`/`print`, f-Strings, `if`/`elif`/`else` |
| T2 | Formatierte Ausgabe, Funktionen (`def`/`return`) |
| T3 | `while`/`for`, `range()`, Listen, `append` |
| T4 | Funktionen vertieft, Module (`import`), `try`/`except` |
| T5 | Verschachtelte Schleifen, Listen durchsuchen, List Comprehensions |

Heute: **Klausurvorbereitung** – typische Aufgabentypen üben.

Tipp: Versuchen Sie, jede Aufgabe zuerst ohne Hilfe zu lösen. Erst wenn Sie nicht weiterkommen: Mitschriften, Dokumentation, Kommilitonen.


### Übungsaufgabe 1: Zahlen erraten

Schreiben Sie ein Ratespiel:

- Das Programm wählt eine Zufallszahl zwischen 1 und 100 (`random.randint`)
- Der Benutzer rät wiederholt; das Programm gibt Hinweise: `"Zu groß!"` / `"Zu klein!"`
- Bei richtiger Antwort: Glückwunsch und Anzahl der Versuche ausgeben
- Verwenden Sie eine `while`-Schleife

**Zusatz:** Begrenzen Sie die Anzahl der Versuche auf 7. Schafft der Benutzer es nicht, geben Sie die gesuchte Zahl aus.


### Übungsaufgabe 2: Collatz-Folge

Die **Collatz-Folge** startet bei einer positiven ganzen Zahl $n$:

$$n \;\to\; \begin{cases} n/2 & \text{wenn } n \text{ gerade} \\ 3n+1 & \text{wenn } n \text{ ungerade} \end{cases}$$

Die Folge endet, wenn $n = 1$ erreicht wird. Beispiel: $6 \to 3 \to 10 \to 5 \to 16 \to 8 \to 4 \to 2 \to 1$

**Aufgabe:**

- Schreiben Sie eine Funktion `collatz_folge(n)`, die alle Werte als Liste zurückgibt
- Wie lang ist die Folge für $n = 27$?
- Welcher Startwert zwischen 1 und 100 erzeugt die **längste** Folge?


### Übungsaufgabe 3: Schaltjahre

Ein Jahr ist ein **Schaltjahr**, wenn gilt:
- Es ist durch 4 teilbar, **und**
- es ist **nicht** durch 100 teilbar – **außer** es ist durch 400 teilbar

Beispiele: 1900 → kein Schaltjahr, 2000 → Schaltjahr, 2024 → Schaltjahr

**Aufgabe:**

- Schreiben Sie eine Funktion `ist_schaltjahr(jahr)` → `True`/`False`
- Zählen Sie alle Schaltjahre zwischen 1900 und 2100
- Geben Sie alle Schaltjahre aus, die durch 400 teilbar sind
- **Zusatz:** Berechnen Sie, wie viele Tage das 21. Jahrhundert (2001–2100) hat


### Übungsaufgabe 4: Textanalyse

```python
text = "Raketen muessen eine bestimmte Geschwindigkeit erreichen um die Erde zu verlassen"
```

Schreiben Sie Funktionen für folgende Analysen:

- `wort_anzahl(text)`: Anzahl der Wörter
  Hinweis: `text.split()` gibt eine Liste der Wörter zurück
- `laengstes_wort(text)`: das längste Wort (bei Gleichstand: das erste)
- `vokal_anzahl(text)`: Anzahl der Vokale (a, e, i, o, u – Groß-/Kleinschreibung egal)
  Hinweis: `text.lower()` wandelt in Kleinbuchstaben um

Erwartete Ausgabe:
```
Wörter: 11
Längstes Wort: Geschwindigkeit
Vokale: 30
```
