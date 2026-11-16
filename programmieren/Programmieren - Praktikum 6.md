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

# Programmieren – Praktikum 6

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Das simulierte Pack als Diagramm

Heute stellen Sie das simulierte Pack als Diagramm dar und bauen die Zelle als eigenen Datentyp.

```python
from zelle import lese_spannung

u = lese_spannung(3, 0.5, 1.0)   # Zelle 3, Ladezustand 50 %, 1.0 A
```

- `lese_spannung(nummer, ladezustand, strom_A)`: Zelle 1 bis 8, Ladezustand 1.0 (voll) bis 0.0 (leer), Entladestrom in A
- Falls Sie `zelle.py` nicht mehr haben: https://raw.githubusercontent.com/DavidMStraub/teaching-materials/main/programmieren/zelle.py herunterladen und im selben Ordner wie Ihr Skript speichern
- Jede Zelle hat `kapazitaet_Ah = 3.5`. Pro Zeitschritt `zeitschritt_h = 0.1` sinkt der Ladezustand um `strom_A * zeitschritt_h / kapazitaet_Ah`

### Aufgabe 1: Eine Entladekurve

1. Simulieren Sie die Entladung von Zelle 1 bei 3,0 A, von `ladezustand = 1.0`, solange der Ladezustand mindestens 0,2 beträgt. Sammeln Sie Zeit in h und Spannung in zwei Listen
2. Zeichnen Sie die Spannung über der Zeit, mit Achsenbeschriftung und Gitter
3. Zeichnen Sie die Grenze 3,0 V als rot gestrichelte Linie über die ganze Dauer ein

### Aufgabe 2: Die Grenze finden

1. Bestimmen Sie den ersten Zeitpunkt, an dem die Spannung unter 3,0 V liegt, und markieren Sie ihn als roten Punkt
2. Titel per `if`: Wird die Grenze unterschritten, nennt der Titel den Zeitpunkt, im Format `Zelle …: unter 3,0 V nach … h`. Sonst: `Zelle …: bleibt über 3,0 V`
3. Testen Sie beide Fälle: Zelle 1 und Zelle 6 bei 3,0 A

### Aufgabe 3: Mehrere Kurven

1. Packen Sie die Simulation aus Aufgabe 1 in eine Funktion `entladekurve(nummer, strom_A)`, die beide Listen zurückgibt (`return`)
2. Zeichnen Sie Zelle 6 bei 1,0 A, 3,0 A und 5,0 A in ein Diagramm, jede Kurve in einem anderen Stil
3. Was ändert sich mit dem Strom am Verlauf, was an der Dauer?

### Aufgabe 4: Die Zelle als eigener Datentyp

1. Schreiben Sie eine Klasse `Batteriezelle`. `__init__(self, nummer)` speichert die Zellnummer und die Kapazität 3,5 Ah
2. Ergänzen Sie eine Methode `spannung(self, ladezustand, strom_A)`, die `lese_spannung` für diese Zelle aufruft und das Ergebnis zurückgibt (`return`)
3. Ergänzen Sie eine Methode `bewertung(self, ladezustand, strom_A)`: unter 3,0 V `kritisch`, sonst `ok`
4. Erzeugen Sie eine Zelle und testen Sie beide Methoden bei zwei Ladezuständen

### Aufgabe 5: Das Pack als Liste von Zellen

1. Legen Sie eine Liste mit acht `Batteriezelle`-Exemplaren an, für die Nummern 1 bis 8 (`append`)
2. Geben Sie für jede Zelle Nummer, Spannung und Bewertung aus (`print`), bei 20 % Ladezustand und 3,0 A
3. Was hat sich gegenüber Ihrer Lösung aus Praktikum 3 verändert, was ist gleich geblieben?

### Zusatz

- Machen Sie aus `entladekurve` eine Methode von `Batteriezelle`, die beide Listen zurückgibt. Zeichnen Sie damit alle acht Zellen bei 3,0 A in ein Diagramm
- Mit `plt.plot(zeiten, spannungen, label="Zelle 1")` bekommt jede Kurve einen Namen. `plt.legend()` vor `plt.show()` zeigt die Namen als Legende an
- Ergänzen Sie eine Methode `laufzeit_h(self, strom_A)`: Sie gibt zurück, wie viele Stunden die Zelle bis zur Grenze 3,0 V durchhält. Vergleichen Sie Zelle 1 und Zelle 6 bei 1,0 A, 3,0 A und 5,0 A
