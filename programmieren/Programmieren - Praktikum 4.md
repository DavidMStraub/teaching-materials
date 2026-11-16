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

# Programmieren – Praktikum 4

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Das Protokoll des Batteriemanagements

Ein Pack aus acht Zellen wurde mit 2,5 A entladen. Das Batteriemanagement hat in jedem Zeitschritt jede Zelle bewertet: `o` ok, `w` Warnung, `k` kritisch. Pro Zelle ein String, ein Zeichen pro Zeitschritt:

```python
protokoll = [
    "oooooooooooowwk",   # Zelle 1
    "oooooooooooowwk",   # Zelle 2
    "oooooooooooowkk",   # Zelle 3
    "oooooooooooowwk",   # Zelle 4
    "oooooooooooowkk",   # Zelle 5
    "oooowwwwwwwwkkk",   # Zelle 6
    "oooooooooooowkk",   # Zelle 7
    "oooooooooooowwk",   # Zelle 8
]
```

Kopieren Sie die Liste in Ihre Dateien. Legen Sie für jede Aufgabe eine eigene Datei an.

### Aufgabe 1: Eine Zelle im Detail

```python
verlauf = protokoll[5]
```

1. Welche Zelle ist das? Geben Sie die Anzahl der Zeitschritte sowie den ersten und den letzten Status aus (`print`)
2. Prüfen Sie mit `in`, ob der Verlauf überhaupt ein `k` enthält
3. Zählen Sie mit einer Schleife über die Zeichen, in wie vielen Zeitschritten der Status `w` ist
4. Schreiben Sie eine Funktion `erster_kritischer(verlauf)`. Sie gibt den Index des ersten `k` zurück (`return`), oder `-1`, wenn kein `k` vorkommt. Laufen Sie dazu mit `range` über die Indizes. Testen Sie auch mit `"ooooo"`

### Aufgabe 2: Eine Anzeige bauen

Auf der Laboranzeige sollen Probleme sofort auffallen: `ok` als Punkt, Warnungen und kritische Schritte als Großbuchstaben. Aus `oooowwwwwwwwkkk` wird `....WWWWWWWWKKK`.

1. Bauen Sie die Anzeige für `verlauf` Zeichen für Zeichen in einer neuen Variable auf (`+=`). Für die Großbuchstaben nutzen Sie `upper()`
2. Warum lässt sich die Anzeige nicht einfacher mit `verlauf[4] = "W"` usw. erzeugen? Probieren Sie es aus
3. Geben Sie nur die letzten fünf Zeitschritte der Anzeige aus (`print`), per Slicing
4. Packen Sie Schritt 1 in eine Funktion `anzeige(verlauf)`, die die Anzeige zurückgibt (`return`)

### Aufgabe 3: Alle acht Zellen

1. Geben Sie für jede Zelle Nummer und Anzeige aus (`print`): `Zelle 1: ............WWK`. Die Nummer ist nicht der Index
2. Zählen Sie für jede Zelle die Warnungen und die kritischen Zeitschritte. Dafür brauchen Sie eine Schleife in der Schleife. Geben Sie eine Tabelle aus, die Zahlen rechtsbündig
3. Welche Zelle hat die meisten Warnungen? Merken Sie sich dazu in zwei Variablen die bisher höchste Anzahl und die Nummer dieser Zelle

### Aufgabe 4: Die Spannungen als Liste

Bei 50 % Ladezustand hat das Batteriemanagement die Zellspannungen in mV gemessen:

```python
spannungen_mV = [3473, 3483, 3465, 3478, 3450, 3178, 3470, 3480]
```

1. Berechnen Sie den Mittelwert, ohne `sum()`
2. Bestimmen Sie die niedrigste Spannung und die Nummer der Zelle, ohne `min()`
3. Geben Sie ein Balkendiagramm aus (`print`): pro Zelle Nummer und Spannung rechtsbündig, dahinter ein `#` für je 25 mV über 3000 mV
4. Welche Zellen liegen mehr als 100 mV unter dem Mittelwert? Sammeln Sie ihre Nummern in einer Liste (`append`) und geben Sie die Liste aus (`print`)

### Aufgabe 5 (falls Sie Funktionen 2 schon hatten): Funktionen mit mehr Möglichkeiten

1. Schreiben Sie eine Funktion `zaehle(verlauf)`, die die Anzahl der Warnungen **und** die Anzahl der kritischen Zeitschritte zurückgibt (`return`). Verwenden Sie sie in Aufgabe 3
2. Verallgemeinern Sie `erster_kritischer`: `erster(verlauf, zeichen)` gibt den Index des ersten Vorkommens eines beliebigen Zeichens zurück. Wann gibt Zelle 6 die erste Warnung aus?

### Zusatz 1: Wann muss das Pack abschalten?

Das Pack schaltet ab, sobald **eine** Zelle kritisch ist.

1. Bestimmen Sie den ersten Zeitschritt, in dem irgendeine Zelle `k` meldet, und die Nummer dieser Zelle
2. Hier läuft die äußere Schleife über die Zeitschritte, die innere über die Zellen. Was beendet ein `break` in der inneren Schleife, was nicht?
3. Wie viele Zeitschritte vorher hätte eine Warnung kommen können?

### Zusatz 2: Häufigkeiten zählen

Ein Temperatursensor liefert ganzzahlige Werte von 20 bis 30 °C.

1. Erzeugen Sie 1000 Zufallswerte (`randint`)
2. Zählen Sie, wie oft jeder Wert vorkommt. Nutzen Sie dafür eine Liste mit elf Zählern: Zähler 0 gehört zu 20 °C, Zähler 1 zu 21 °C usw.
3. Geben Sie für jede Temperatur die Anzahl rechtsbündig aus, dahinter ein `#` je 10 Vorkommen
4. Ist die Verteilung gleichmäßig? Wie sieht es bei 100 Werten aus, wie bei 100 000?

### Zusatz 3: Seriennummern prüfen

Seriennummern haben das Format `LB240815-06-A`: Hersteller (2 Zeichen), Jahr, Monat, Tag (je 2), `-`, Zellnummer (2), `-`, Charge (1).

1. Schneiden Sie alle sechs Felder per Slicing aus
2. Schreiben Sie `pruefe_seriennummer(sn)`: gibt `True` zurück (`return`), wenn die Länge stimmt, die Striche an der richtigen Stelle stehen und Datum und Zellnummer nur Ziffern enthalten (`in "0123456789"`)
3. Lesen Sie Seriennummern ein (`input`), bis eine gültige kommt. Kleinbuchstaben wie in `lb240815-06-a` sollen auch akzeptiert werden
