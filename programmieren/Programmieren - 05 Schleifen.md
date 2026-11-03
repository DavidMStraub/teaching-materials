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

# Programmieren – 5. Schleifen

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, Zeichen für Zeichen, bevor wir es ausführen:

```python
zellen = int(13.9)
spannung = float("3.7")
print(f"{zellen} Zellen:{zellen * spannung:>7.1f} V")
```

### Heute lernen Sie

- Code **wiederholen**, ohne ihn zu kopieren: `while` und `for`
- Robuste Programme: **Eingabe wiederholen, bis sie gültig ist**
- Werte in einer Schleife **aufsummieren**
- Schleifen **vorzeitig abbrechen**: `break`
- Endlosschleifen erkennen – und stoppen

## `while`: wiederholen, solange …

### Ohne Schleife wäre es so

```python
print("Messung 1")
print("Messung 2")
print("Messung 3")
# ... und bei 1000 Messungen?
```

Kopierter Code muss bei jeder Änderung an vielen Stellen angepasst werden. Eine Schleife wiederholt ihn stattdessen:

### Die `while`-Schleife

```python
i = 1
while i <= 3:
    print(f"Messung {i}")
    i = i + 1
```

- Solange die Bedingung `True` ist, läuft der eingerückte Block – **immer wieder**
- Gleiche Ausgabe wie eben – aber der Code wächst nicht mit der Anzahl: für 1000 Messungen ändert sich nur die `3`
- Von Hand verfolgen (so prüft man Schleifen!):

| Durchlauf | `i` | `i <= 3`? | Ausgabe |
|---|---|---|---|
| 1 | 1 | True | Messung 1 |
| 2 | 2 | True | Messung 2 |
| 3 | 3 | True | Messung 3 |
| – | 4 | False | *(Ende)* |

### Vorhersage-Aufgabe (3 min)

Neu darin: `n += 2` ist die Kurzform für `n = n + 2` – diese Kurzform sehen Sie überall in echtem Code.

Legen Sie eine Tabelle wie eben an: eine Zeile pro Durchlauf, eine Spalte pro Variable. Dann ausführen:

```python
n = 1
summe = 0
while summe < 10:
    summe += n
    n += 2
print(n, summe)
```

Wie oft läuft die Schleife? Was wird ausgegeben?

### Die Endlosschleife

```python
i = 0
while i < 3:
    print(i)
```

- `i` ändert sich nie – die Bedingung bleibt für immer `True`
- Kein Fehler, keine Meldung: das Programm läuft einfach **endlos**
- Stoppen in Jupyter: das **Stopp-Symbol** (Kernel unterbrechen)

### Mini-Aufgabe (4 min)

```python
i = 0
while i < 5:
    print(i)
    i += 1
```

1. Führen Sie den Code aus
2. Ändern Sie ihn so, dass nur bis `3` gezählt wird (letzte Ausgabe: `3`)
3. Ändern Sie ihn so, dass er bei `1` startet
4. Jetzt nur die geraden Zahlen von `0` bis `8` – finden Sie **zwei** Wege (Tipp: einer davon nutzt `%` aus Woche 2)

### Robuste Programme: Eingabe wiederholen, bis sie gültig ist

```python
zahl = int(input("Zahl (1-100): "))
while zahl < 1 or zahl > 100:
    zahl = int(input("Ungültig! Bitte nochmal: "))
print(f"Ihre Zahl: {zahl}")
```

- Die Schleife läuft, **solange die Eingabe ungültig ist**
- Das `or` kennen Sie aus Woche 3 – „ungültig“ ist ein `or` aus Verstößen
- Ungültige Eingaben kommen vor – ein robustes Programm fragt dann erneut nach. Dieses Muster gehört zum Handwerk

### Mini-Aufgabe (5 min)

Machen Sie Ihren Reichweiten-Rechner aus Woche 4 robust:

1. Der Energieinhalt wird so lange neu abgefragt, bis er über 0 liegt
2. Der Verbrauch wird so lange neu abgefragt, bis er zwischen 5 und 50 kWh/100 km liegt
3. Testen Sie mit `-60`, `0`, `60` und mit `3`, `80`, `15`
4. Was passiert, wenn jemand `abc` eintippt? Warum hilft Ihre Schleife da nicht?

### Debug-Aufgabe (4 min)

Dieser Countdown soll von `5` bis `1` herunterzählen und dann einmal `Start!` ausgeben. Stattdessen läuft er endlos. Finden Sie beide Fehler:

```python
countdown = 5
while countdown > 0:
    print(countdown)
    print("Start!")
```

## `for`: wiederholen mit Zähler

### Die `for`-Schleife mit `range()`

```python
for i in range(5):
    print(i)
```

- `range(5)` erzeugt die Zahlen `0, 1, 2, 3, 4` – **die 5 ist nicht dabei!**
- Start bei 0, wie beim Zählen in Python üblich
- Auch `range(...)` ist ein Funktionsaufruf

### `range` mit Start und Stopp

```python
for i in range(1, 6):
    print(i)
```

- `range(1, 6)` → `1, 2, 3, 4, 5` – Start dabei, Stopp nicht
- Es gibt auch eine Schrittweite: `range(0, 10, 2)` zählt in Zweierschritten

### Vorhersage-Aufgabe (2 min)

Welche Zahlen durchläuft `i` jeweils? Aufschreiben, dann mit einer `for`-Schleife prüfen:

```python
range(2, 6)
range(0, 10, 3)
range(5, 0, -1)
range(5, 1)
```

### Was `range()` liefert

- `range(0, 10, 3)` → `0, 3, 6, 9` – die Schrittweite bestimmt den Abstand, der Stopp ist nie dabei
- `range(5, 0, -1)` → `5, 4, 3, 2, 1` – mit negativer Schrittweite zählt `range` **rückwärts**
- `range(5, 1)` → leer: der Start liegt bereits hinter dem Stopp
- Bei leerer `range` läuft die Schleife **null Mal** – ohne Fehlermeldung

### Aufsummieren in der Schleife

```python
summe = 0
for i in range(1, 5):
    summe += i
print(summe)
```

- **Vor** der Schleife mit 0 starten, **in** der Schleife in jedem Durchlauf dazuzählen
- Das `print` steht **nach** der Schleife (nicht eingerückt) – es gibt nur das Endergebnis aus: `10`
- Dasselbe Muster steckt in der Vorhersage-Aufgabe mit `summe` und `n`

### Mini-Aufgabe (5 min)

Ein Fahrtenbuch für Ihr Elektrofahrzeug:

1. Anzahl der Fahrten einlesen
2. Mit einer `for`-Schleife für jede Fahrt die Strecke in km einlesen – die Aufforderung zeigt die Nummer: `Fahrt 1 in km: `, `Fahrt 2 in km: `, …
3. Gesamtstrecke und Durchschnitt pro Fahrt mit einer Nachkommastelle ausgeben (`print`)

Testen Sie mit 3 Fahrten: 12.5, 40 und 7.5 km – das sollte 60.0 km und 20.0 km ergeben. Was passiert bei 0 Fahrten?

### `while` oder `for`?

- **`for`**: die Anzahl der Wiederholungen steht vorher fest („10-mal“, „für jede Zahl von 1 bis 100“)
- **`while`**: wiederholen, solange eine Bedingung gilt („bis die Eingabe gültig ist“)
- Jede `for`-Schleife lässt sich als `while`-Schleife schreiben – das üben wir in Woche 8

### Abbrechen mit `break`

```python
for i in range(10):
    if i == 4:
        break
    print(i)
```

- `break` beendet die Schleife **sofort** – der Rest der Durchläufe entfällt

### Ausgabe ohne Zeilenumbruch

```python
for i in range(5):
    print("#", end="")
```

- Normal macht `print` nach jeder Ausgabe einen Zeilenumbruch
- `end=""` unterdrückt ihn – die Ausgaben landen in **einer Zeile**: `#####`

### Vorhersage-Aufgabe (2 min)

Aufschreiben, dann ausführen:

```python
for i in range(1, 8):
    if i == 5:
        break
    print(i, end=" ")
```

## Transfer

### Aufgabe: Ladeanzeige (Denkphase: 5 min, auf Papier)

Ihr Fahrzeug zeigt den Ladestand als Balken aus 10 Segmenten. Schreiben Sie das Programm:

1. **Einlesen:** Ladestand in % als ganze Zahl – ungültige Eingaben wiederholen
2. **Ausgeben** (`print`): pro volle 10 % ein `#`, den Rest mit `-` auffüllen, dahinter den Ladestand rechtsbündig:

```
######----  67 %
########## 100 %
```

Testwerte: 67, 100, 0, 5 – für die Eingabeprüfung 120 und −3

### Ladeanzeige: Denkphase

Notieren Sie auf Papier:

- Welche Schleife für die Eingabe, welche für den Balken – warum?
- Wie viele `#` bei 67 %, wie viele `-`? Wie rechnet Ihr Programm das aus?
- Wie landen Balken und Zahl in **einer** Zeile?

Zusatz für Schnelle:

- Unter 20 % erscheint unter dem Balken zusätzlich `Bitte laden!`
- Die Anzahl der Segmente wird ebenfalls eingelesen, z. B. 20 – was ändert sich an Ihrer Rechnung?

### Gemeinsam live

Wir entwickeln die Lösung jetzt zusammen.

### Mini-Check

Ohne Computer – was kommt heraus?

1. Welche Zahlen liefert `range(2, 8, 2)`?
2. Warum läuft `while i < 3: print(i)` endlos?
3. Eingabe validieren, bis sie passt – `for` oder `while`? Warum?
4. Beim Aufsummieren: Was passiert, wenn `summe = 0` **in** der Schleife steht?

### 🗳️ Zum Schluss: Was gibt das aus?

```python
summe = 0
for i in range(1, 4):
    summe += i
    print(summe, end=" ")
```

A) `6`

B) `1 3 6`

C) `0 1 3`

D) `1 2 3`

### Bis nächste Woche!

Nächste Woche: **Funktionen** – eigene Bausteine bauen

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
