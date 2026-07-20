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

Ein Adventskalender für Programmierer: seit 2015 jedes Jahr im Dezember, ein Rätsel pro Tag. Heute bearbeiten Sie die ersten Rätsel des aktuellen Jahrgangs – mit allem, was Sie bisher gelernt haben.

1. https://adventofcode.com – einloggen (GitHub, Google, … reicht)
2. Aufgabe öffnen, Ihren persönlichen Input darunter kopieren

### Der Input

Ihr Input ist ein Textblock. Da Dateien einlesen nicht Ihr Stoff ist, kopieren Sie ihn direkt in Ihr Programm:

```python
eingabe = """
... hier Ihren Input einfügen ...
"""

zeilen = eingabe.split("\n")
```

Damit haben Sie Ihren Input als Liste von Zeilen – ab hier verarbeiten Sie ihn mit dem, was Sie kennen.

### So gehen Sie vor

- Jede Aufgabe zeigt ein **Beispiel** mit bekanntem Ergebnis. Testen Sie zuerst damit – nicht mit Ihrem echten Input. Erst wenn das stimmt: mit dem eigenen Input ausführen
- Teil 2 der Aufgabe erscheint erst, wenn Teil 1 gelöst ist

### Zusatz für Schnelle

- Advent of Code hat 25 Tage – wer möchte, kann zu Hause weitermachen. Die Tage werden von Tag zu Tag schwerer
- Außerhalb des Praktikums dürfen Sie dabei gern KI-Tools zur Unterstützung nutzen – das ist keine Prüfungssituation
