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

# Programmieren – 7. Listen

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, dann ausführen:

```python
def halbiere(x):
    return x / 2

def zeige(x):
    print(x)

a = halbiere(10)
print(a + 1)

b = zeige(10)
print(b)
```

### Heute lernen Sie

- Viele Werte in **einer** Variable: Listen
- Elemente lesen, anhängen, durchlaufen
- Listen von Hand auswerten: **Summe, Mittelwert, Maximum, Zählen**

## Listen

### Warum Listen?

```python
messung_1 = 15.2
messung_2 = 16.1
messung_3 = 14.8
messung_4 = 17.3
# ... und bei 1000 Messwerten?
```

Jeder Messwert braucht einen eigenen Namen, und jede Rechnung muss alle Namen einzeln aufzählen.

### Eine Liste erstellen

```python
messungen = [15.2, 16.1, 14.8, 17.3]

print(messungen)
print(len(messungen))
```

- Eckige Klammern, Werte durch Kommas getrennt
- `len(...)` liefert die Anzahl der Elemente, so wie bei Strings die Anzahl der Zeichen

### Zugriff über den Index

```python
messungen = [15.2, 16.1, 14.8, 17.3]

print(messungen[0])    # erstes Element
print(messungen[2])
print(messungen[-1])   # letztes Element
```

- Die Zählung beginnt bei **0** – wie bei `range`!
- Negative Indizes zählen vom Ende: `[-1]` ist das letzte Element

### Ein Element ersetzen

```python
messungen = [15.2, 16.1, 14.8, 17.3]

messungen[1] = 16.0     # zweites Element ersetzen
print(messungen)
```

- Links vom `=` steht der Index: Python schreibt den neuen Wert an diese Stelle
- Die Länge der Liste bleibt gleich

### Elemente anhängen: `append`

```python
messungen = []                # leere Liste
messungen.append(15.2)
messungen.append(16.1)
print(messungen)
```

- `[]` ist eine leere Liste
- Schreibweise mit Punkt: `append` gehört zur Liste, eine **Methode**. Sie hängt das Element hinten an die Liste an
- `append` verändert die Liste selbst und gibt `None` zurück. Darum **nicht** `messungen = messungen.append(1.0)`: danach ist `messungen` gleich `None`

### Ist ein Wert enthalten? `in`

```python
messungen = [15.2, 16.1, 14.8]

print(16.1 in messungen)
print(99.0 not in messungen)
```

- `in` und `not in` liefern `True` oder `False`
- Damit passen sie direkt in eine `if`-Bedingung

### Mini-Aufgabe (4 min)

```python
temperaturen = [18.5, 21.0, 19.8, 23.4, 20.1]
```

1. Geben Sie das **letzte** Element aus (`print`) – mit negativem Index
2. Der dritte Messwert war falsch: Ersetzen Sie ihn durch `19.5`
3. Hängen Sie den Messwert `22.7` an (`append`) und geben Sie die Liste aus (`print`)
4. Prüfen Sie mit `in`, ob `20.1` in der Liste ist

### Achtung typischer Fehler

```python
werte = [10, 20, 30]
print(werte[3])
```

```
IndexError: list index out of range
```

- Drei Elemente: Indizes `0`, `1`, `2`. Der letzte Index ist `len(werte) - 1`
- Das letzte Element direkt: `werte[-1]`

## Listen durchlaufen

### `for` über eine Liste

```python
messungen = [15.2, 16.1, 14.8, 17.3]

for messung in messungen:
    print(messung)
```

- Die Schleife besucht **jedes Element** der Reihe nach
- `messung` ist in jedem Durchlauf ein Element: erst `15.2`, dann `16.1`, …

### Testdaten per Zufall: `randint`

```python
from random import randint

werte = []
for i in range(10):
    werte.append(randint(1, 100))

print(werte)
```

- `randint(1, 100)`: ganze Zufallszahl von 1 bis 100, beide Grenzen eingeschlossen
- `i` wird nicht gebraucht: `range(10)` sorgt nur für zehn Durchläufe
- *Leere Liste, Schleife, `append`*: Mit diesem Muster füllen Sie Listen für Testdaten, Simulationen und Messreihen

### Kernmuster 1: Summe und Mittelwert von Hand

```python
summe = 0
for wert in werte:
    summe += wert

mittel = summe / len(werte)
print(f"Mittelwert: {mittel:.1f}")
```

- Das Aufsummieren aus Woche 5, jetzt über die Elemente einer Liste
- **Akkumulator-Muster**: vor der Schleife mit 0 starten, in der Schleife dazuzählen
- Für Summe und Maximum gibt es fertige Funktionen: `sum()`, `max()`. Das Muster brauchen Sie für jede Auswertung, für die es keine fertige Funktion gibt

### Kernmuster 2: Maximum von Hand

```python
werte = [4, 12, 7, 15, 9]

maximum = werte[0]
for wert in werte:
    if wert > maximum:
        maximum = wert

print(maximum)
```

- Der **Merker** `maximum` startet mit dem ersten Element
- Ist ein Element größer, wird es zum neuen Merker. Am Ende steht im Merker das größte Element

### Trace-Aufgabe (2 min, auf Papier)

`werte = [4, 12, 7, 15, 9]` – bei welchen Werten ändert sich `maximum`?

```python
maximum = werte[0]
for wert in werte:
    if wert > maximum:
        maximum = wert
```

| `wert` | `wert > maximum`? | `maximum` danach |
|---|---|---|
| 4 | nein | 4 |
| 12 | ? | ? |
| 7 | ? | ? |
| 15 | ? | ? |
| 9 | ? | ? |

### Debug-Aufgabe (3 min)

Dieses Programm soll das Maximum finden. Für `[8, 14, 22]` stimmt das Ergebnis, für `[-5, -2, -9]` liefert es `0`. Warum? Beheben Sie den Fehler:

```python
werte = [-5, -2, -9]

maximum = 0
for wert in werte:
    if wert > maximum:
        maximum = wert

print(maximum)
```

### Mini-Aufgabe (3 min)

```python
werte = [8, 14, 3, 22, 11, 6]
```

Zählen Sie mit einer Schleife, wie viele Werte **über 10** liegen, und geben Sie die Anzahl aus (`print`).

Zusatz: Bestimmen Sie auch den **kleinsten** Wert.

## Transfer

### Aufgabe: Messreihe auswerten (Denkphase: 5 min, auf Papier)

Schreiben Sie ein Programm:

1. Eine Funktion `mittelwert(werte)`, die den Mittelwert einer Liste zurückgibt (`return`)
2. Hauptprogramm: eine Liste mit **20 Zufallszahlen** von 1 bis 100 füllen (`randint`)
3. Funktion aufrufen, Ergebnis mit einer Nachkommastelle ausgeben (`print`)
4. Zählen und ausgeben, wie viele Werte **über dem Mittelwert** liegen

Probe: `mittelwert([2, 4, 9])` → `5.0`

### Messreihe: Denkphase

Notieren Sie auf Papier:

- Was gehört in die Funktion, was ins Hauptprogramm?
- Was ist der Parameter, was die Rückgabe?
- Wie prüfen Sie, ob `mittelwert` richtig rechnet, obwohl die Liste zufällig ist?

Zusatz für Schnelle:

- Eine Funktion `maximum(werte)`, die den größten Wert zurückgibt, ohne `max()`
- Ein Programm, das das **zweitgrößte** Element ausgibt

### Gemeinsam live

Wir entwickeln die Lösung jetzt zusammen.

### Mini-Check

Ohne Computer:

1. `werte = [5, 8, 2]`: Was ist `werte[-1]`, was ist `len(werte)`?
2. Maximum-Suche: Womit startet der Merker, und warum nicht mit `0`?
3. Was steht in `werte` nach `werte = [5, 8, 2]` und `werte.append(7)`?

### 🗳️ Zum Schluss: Was gibt das aus?

```python
werte = [4, 9, 2, 7]
m = werte[0]
for wert in werte:
    if wert < m:
        m = wert
print(m)
```

A) `9`

B) `2`

C) `4`

D) `7`

### Bis nächste Woche!

Nächste Woche: **Strings**, außerdem eine kurze **Mini-Probeklausur** (15 min, zählt nicht, zeigt Ihnen, wo Sie stehen)

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: jederzeit im Matrix-Chat
