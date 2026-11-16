---
marp: true
theme: hm
paginate: true
language: de
footer: Programmieren/Praktikum – D. Straub
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

# Programmieren – Praktikum 5

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Advent of Code

Ein Adventskalender mit Programmierrätseln: seit 2015 jedes Jahr im Dezember, ein Rätsel pro Tag. Heute lösen Sie Rätsel des aktuellen Jahrgangs, mit allem, was Sie bisher gelernt haben.

1. https://adventofcode.com öffnen und einloggen
2. Das Rätsel des angesagten Tages öffnen
3. Unter dem Rätsel: Ihren persönlichen Input öffnen (`get your puzzle input`)

Jedes Rätsel hat zwei Teile. Teil 2 erscheint, sobald Teil 1 gelöst ist.

### Den Input ins Programm holen

Der Input ist ein Textblock. Kopieren Sie ihn in einen String mit **drei** Anführungszeichen, der darf über mehrere Zeilen gehen:

```python
eingabe = """3   4
4   3
2   5"""

zeilen = eingabe.split("\n")
print(zeilen)
```

- `split("\n")` zerlegt den Text an jedem Zeilenumbruch (`"\n"`) und liefert eine **Liste** von Zeilen
- Den Input direkt hinter die öffnenden Anführungszeichen setzen, die schließenden direkt ans Ende der letzten Zeile. Sonst entstehen leere Zeilen

### Eine Zeile zerlegen

```python
zeile = "3   4"
teile = zeile.split()
print(teile)

links = int(teile[0])
rechts = int(teile[1])
print(links + rechts)
```

- `split()` ohne Angabe zerlegt an Leerzeichen, egal wie viele es sind
- Die Teile sind Strings. Zum Rechnen umwandeln: `int()` oder `float()`

### So gehen Sie vor

1. **Rätsel lesen**, auf Papier: Was ist gegeben, was ist gesucht? Welche Bausteine brauchen Sie?
2. **Beispiel zuerst**: Jedes Rätsel zeigt ein kleines Beispiel mit Ergebnis. Schreiben Sie eine Funktion, die die Eingabe als Parameter bekommt und das Ergebnis zurückgibt (`return`):

```python
beispiel = """..."""     # Beispiel aus dem Rätseltext

def teil1(eingabe):
    zeilen = eingabe.split("\n")
    ergebnis = 0
    # ...
    return ergebnis

print(teil1(beispiel))   # muss das Ergebnis aus dem Rätseltext liefern
```

3. Erst wenn das Beispiel stimmt: `teil1(eingabe)` mit Ihrem Input, Antwort eintragen

### Wenn es nicht stimmt

Die Antwort ist falsch, aber das Beispiel stimmt? Der Reihe nach:

1. Was **soll** das Programm tun? Lesen Sie den Rätseltext noch einmal genau
2. Was tut es **stattdessen**? Geben Sie Zwischenergebnisse aus (`print`), zuerst für die ersten Zeilen
3. Welche Stelle ist **verdächtig**? Häufig: Zeilen, die im Beispiel nicht vorkommen
4. Welcher **kleinste Test** entscheidet? Bauen Sie ein eigenes kleines Beispiel, dessen Ergebnis Sie von Hand kennen

### Zusatz für Schnelle

- Lösen Sie Teil 2 und weitere Tage
- Räumen Sie Ihre Lösung auf: Funktionen mit sprechenden Namen, keine unnötigen Kopien von Code
- Zu Hause können Sie mit weiteren Tagen weitermachen. Dort dürfen Sie gern KI-Werkzeuge nutzen, das ist keine Prüfungssituation
