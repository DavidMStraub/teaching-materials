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
- Endlosschleifen erkennen und stoppen
- Entscheiden: `while` oder `for`?

## `while`: wiederholen, solange …

### Ohne Schleife wäre es so

Ein Kondensator verliert pro Zeitschritt die Hälfte seiner Spannung. Nach wie vielen Schritten liegt er unter 1 V?

```python
spannung = 12.0
spannung = spannung / 2   # 6.0
spannung = spannung / 2   # 3.0
spannung = spannung / 2   # 1.5
spannung = spannung / 2   # 0.75 – jetzt unter 1 V
```

Bei 230 V bräuchten Sie mehr Zeilen – wie viele, steht vorher nicht fest. Die Wiederholung muss sich nach einer **Bedingung** richten.

### Die `while`-Schleife

```python
spannung = 12.0
schritte = 0
while spannung >= 1.0:
    spannung = spannung / 2
    schritte = schritte + 1
print(f"Unter 1 V nach {schritte} Schritten")
```

- Solange die Bedingung `True` ist, läuft der eingerückte Block **wiederholt**
- Die Anzahl der Durchläufe ergibt sich aus der Bedingung: bei 230 V sind es mehr, der Code bleibt gleich
- Das `print` ist nicht eingerückt – es läuft einmal, nach der Schleife

### Von Hand verfolgen: die Trace-Tabelle

So prüft man Schleifen – eine Zeile pro Durchlauf:

| Durchlauf | `spannung >= 1.0`? | `spannung` danach | `schritte` danach |
|---|---|---|---|
| 1 | True | 6.0 | 1 |
| 2 | True | 3.0 | 2 |
| 3 | True | 1.5 | 3 |
| 4 | True | 0.75 | 4 |
| – | False | *(Ende)* | |

Ausgabe: `Unter 1 V nach 4 Schritten`

### Vorhersage-Aufgabe (3 min)

Neu darin: `n += 2` ist die Kurzform für `n = n + 2`. Die Kurzform ist in Python üblich.

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

### Mini-Aufgabe (4 min)

Übernehmen Sie die Kondensator-Schleife und ändern Sie sie:

1. Start bei 230 V – nach wie vielen Schritten liegt die Spannung unter 1 V?
2. Geben Sie in jedem Durchlauf Schritt und Spannung aus (`print`), die Spannung mit zwei Nachkommastellen
3. Pro Schritt sinkt die Spannung nur um 10 % – wie viele Schritte sind es jetzt?

### Vorhersage-Aufgabe (2 min)

Eine Batteriezelle wird in 0,1-Schritten geladen, bis der Ladezustand 1,0 erreicht:

```python
ladezustand = 0.0
while ladezustand != 1.0:
    ladezustand = ladezustand + 0.1
print("Voll!")
```

Wie oft läuft die Schleife? Aufschreiben – dann führen wir es gemeinsam aus.

### Die Endlosschleife

- Die Bedingung wird nie `False` – das Programm läuft **endlos**, ohne Fehlermeldung
- Stoppen in Jupyter: das **Stopp-Symbol** (Kernel unterbrechen)
- Ein `print(ladezustand)` in der Schleife zeigt die Ursache: `0.9999999999999999`, dann `1.0999999999999999`
- Kommazahlen werden intern nicht exakt gespeichert – warum, klären wir in Woche 11

Zählen Sie deshalb mit ganzen Zahlen – die sind exakt:

```python
prozent = 0
while prozent < 100:
    prozent = prozent + 10
```

### Robuste Programme: Eingabe wiederholen, bis sie gültig ist

```python
zahl = int(input("Zahl (1-100): "))
while zahl < 1 or zahl > 100:
    zahl = int(input("Ungültig! Bitte nochmal: "))
print(f"Ihre Zahl: {zahl}")
```

- Die Schleife läuft, **solange die Eingabe ungültig ist**
- Das `or` kennen Sie aus Woche 3 – ungültig ist die Eingabe, wenn eine der Grenzen verletzt ist
- Ungültige Eingaben kommen vor – ein robustes Programm fragt dann erneut nach

### Mini-Aufgabe (4 min)

Machen Sie Ihren Reichweiten-Rechner aus Woche 4 robust:

1. Der Verbrauch wird so lange neu abgefragt, bis er zwischen 5 und 50 kWh/100 km liegt
2. Testen Sie mit `3`, `80`, `15`
3. Was passiert, wenn jemand `abc` eintippt? Warum hilft Ihre Schleife da nicht?

### Debug-Aufgabe (4 min)

Dieser Countdown soll von `5` bis `1` herunterzählen und dann einmal `Start!` ausgeben. Stattdessen läuft er endlos. Finden Sie beide Fehler:

```python
countdown = 5
while countdown > 0:
    print(countdown)
    print("Start!")
```

## `for`: wiederholen mit Zähler

### Wenn die Anzahl feststeht

```python
print("Messung 1")
print("Messung 2")
print("Messung 3")
# ... und bei 1000 Messungen?
```

Hier steht vorher fest, wie oft wiederholt wird. Dafür gibt es die `for`-Schleife.

### Die `for`-Schleife mit `range()`

```python
for i in range(5):
    print(i)
```

- `range(5)` erzeugt die Zahlen `0, 1, 2, 3, 4` – Start bei 0, **ohne die 5**
- Mit Start und Stopp: `range(1, 6)` → `1, 2, 3, 4, 5` – Start dabei, Stopp nicht
- Mit Schrittweite: `range(0, 10, 2)` zählt in Zweierschritten
- Auch `range(...)` ist ein Funktionsaufruf

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
- Dasselbe Muster verwendet die Vorhersage-Aufgabe mit `summe` und `n`

### Mini-Aufgabe (5 min)

Ein Fahrtenbuch für Ihr Elektrofahrzeug:

1. Anzahl der Fahrten einlesen
2. Mit einer `for`-Schleife für jede Fahrt die Strecke in km einlesen – die Aufforderung zeigt die Nummer: `Fahrt 1 in km: `, `Fahrt 2 in km: `, …
3. Gesamtstrecke und Durchschnitt pro Fahrt mit einer Nachkommastelle ausgeben (`print`)

Testen Sie mit 3 Fahrten: 12.5, 40 und 7.5 km – das sollte 60.0 km und 20.0 km ergeben.

### Zählen mit `while` und mit `for`

Zweimal dieselbe Ausgabe, `1` bis `5`:

```python
i = 1               # 1. Startwert
while i <= 5:       # 2. Bedingung
    print(i)
    i += 1          # 3. Erhöhung
```

```python
for i in range(1, 6):
    print(i)
```

- Bei `while` verteilt sich das Zählen auf drei Stellen – jede ist eine Fehlerquelle. Fehlt die Erhöhung, läuft die Schleife endlos
- Zum Zählen nehmen Sie deshalb `for` – eine Zeile statt drei Stellen
- Jede `for`-Schleife lässt sich als `while`-Schleife schreiben – das üben wir in Woche 8

### Mini-Aufgabe (2 min): `while` oder `for`?

- **`for`**: die Anzahl der Wiederholungen steht vorher fest
- **`while`**: wiederholen, solange eine Bedingung gilt

Entscheiden Sie für jeden Fall und begründen Sie in einem Halbsatz:

1. Eine Eingabe wiederholen, bis sie gültig ist
2. Die Spannung von 8 Zellen nacheinander auslesen
3. Halbieren, bis die Spannung unter 1 V liegt
4. 100 Messwerte einlesen

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

- Standardmäßig endet jede `print`-Ausgabe mit einem Zeilenumbruch
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

1. Wie oft läuft die Kondensator-Schleife, wenn die Spannung schon bei 0.5 V startet?
2. `for i in range(3):` – im Block erst `print(i)`, dann `i += 5`. Was wird ausgegeben?

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
