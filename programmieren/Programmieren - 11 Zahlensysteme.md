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

# Programmieren – 11. Zahlensysteme

**Ingenieurinformatik Teil 1, Wintersemester 2026/27**

David Straub

### Warm-up: Was gibt der Code aus?

Aufschreiben, dann ausführen:

```python
x = [0, 1, 2]
y = []
for wert in x:
    y.append(wert ** 2)
print(y)
```

### Heute lernen Sie

- Wie Computer Zahlen speichern: **Bits, Bytes, Binärsystem**
- Umrechnen: **binär, dezimal, hexadezimal**, mit nachvollziehbaren Zwischenschritten
- Warum `0.1 + 0.2 == 0.3` den Wert `False` hat, und wie Sie Kommazahlen richtig vergleichen

## Bits und Bytes

### Alles ist 0 oder 1

- Ein **Bit**: die kleinste Speichereinheit, `0` oder `1`
- Ein **Byte**: 8 Bit
- Mit $n$ Bit lassen sich $2^n$ verschiedene Werte darstellen, z. B. die Zahlen $0$ bis $2^n - 1$
- 1 Byte: $2^8 = 256$ Werte, also 0 bis 255

Kurze Frage: Eine Ganzzahl wird mit 8 Byte gespeichert. Wie viele unterschiedliche Werte lassen sich damit darstellen?

### Das Stellenwertsystem

Dezimal (Basis 10), so lesen Sie Zahlen seit der Grundschule:

$$257 = 2 \cdot 100 + 5 \cdot 10 + 7 \cdot 1$$

Binär (Basis 2), dasselbe Prinzip mit anderen Stellenwerten:

$$1101_2 = 1 \cdot 8 + 1 \cdot 4 + 0 \cdot 2 + 1 \cdot 1 = 13$$

Stellenwerte von rechts: 1, 2, 4, 8, 16, 32, 64, 128, …

### Binär → Dezimal

$$110011_2 = ?$$

| Stellenwert | 32 | 16 | 8 | 4 | 2 | 1 |
|---|---|---|---|---|---|---|
| Ziffer | 1 | 1 | 0 | 0 | 1 | 1 |

$$32 + 16 + 2 + 1 = 51$$

Addiert werden die Stellenwerte, an denen eine `1` steht.

### Dezimal → Binär

$45 = \;?_2$: fortgesetzt durch 2 teilen, **Reste notieren**

| | | Rest |
|---|---|---|
| 45 : 2 | = 22 | **1** |
| 22 : 2 | = 11 | **0** |
| 11 : 2 | = 5 | **1** |
| 5 : 2 | = 2 | **1** |
| 2 : 2 | = 1 | **0** |
| 1 : 2 | = 0 | **1** |

Reste **von unten nach oben** lesen: $101101_2$. Probe: $32+8+4+1 = 45$ ✓

### Mini-Aufgabe (4 min, auf Papier)

Rechnen Sie um, **mit allen Zwischenschritten**:

$$123_{10} = \;?_2$$

Machen Sie dann die Probe: Rechnen Sie Ihr Ergebnis zurück ins Dezimalsystem.

### Hexadezimal: Basis 16

- Ziffern: `0` bis `9`, dann `A` (10) bis `F` (15)
- Stellenwerte: 1, 16, 256, …
- **4 Bit ergeben genau eine Hex-Ziffer**: Hex ist die kompakte Schreibweise für Bitmuster

$$2A_{16} = 2 \cdot 16 + 10 = 42$$

Rückwärts: $123_{10} = 7 \cdot 16 + 11 \rightarrow 7B_{16}$

Über die Bits: $7 = 0111_2$, $B = 1011_2$, also $7B_{16} = 0111\,1011_2$. Vergleichen Sie mit Ihrer Mini-Aufgabe

### Mini-Aufgabe (3 min, auf Papier)

$$AAA_{16} = \;?_{10}$$

Zur Übersetzung der Ziffern:

| Hex | 0…9 | A | B | C | D | E | F |
|---|---|---|---|---|---|---|---|
| Dezimal | 0…9 | 10 | 11 | 12 | 13 | 14 | 15 |

Zusatz: $255_{10} = \;?_{16}$

## Kommazahlen im Binärsystem

### Stellen hinter dem Komma

Vor dem Komma: 1, 2, 4, 8, … **Hinter** dem Komma geht es genauso weiter:

$$\tfrac{1}{2}, \tfrac{1}{4}, \tfrac{1}{8}, \tfrac{1}{16}, \ldots$$

$$0{,}25_{10} = 0{,}01_2 \qquad 0{,}75_{10} = 0{,}11_2 \qquad 0{,}625_{10} = 0{,}101_2$$

### Mini-Aufgabe (2 min, auf Papier)

$$110{,}011_2 = \;?_{10}$$

Schreiben Sie das Ergebnis als Kommazahl.

### Eine Kommazahl umrechnen

$$257{,}25_{10} = \;?_2$$

**Vorkomma** 257: teilen mit Rest, wie eben → $100000001_2$

**Nachkomma** 0,25: fortgesetzt **verdoppeln**, die Vorkommastelle notieren:

| | | Vorkomma |
|---|---|---|
| 0,25 · 2 | = 0,5 | **0** |
| 0,5 · 2 | = 1,0 | **1**, Rest 0, fertig |

Von oben lesen: $0{,}01_2$. Zusammen: $257{,}25_{10} = 100000001{,}01_2$

### Warum ist 0,1 im Computer nicht exakt 0,1?

Dasselbe Verfahren für $0{,}1_{10}$:

| | | Vorkomma |
|---|---|---|
| 0,1 · 2 | = 0,2 | 0 |
| 0,2 · 2 | = 0,4 | 0 |
| 0,4 · 2 | = 0,8 | 0 |
| 0,8 · 2 | = 1,6 | 1 |
| 0,6 · 2 | = 1,2 | 1 |
| 0,2 · 2 | = … | **wieder 0,2: Zyklus!** |

$$0{,}1_{10} = 0{,}0\overline{0011}_2 \quad \text{(unendlich periodisch)}$$

Der Computer speichert endlich viele Stellen. **0,1 ist im Rechner nie exakt 0,1**

### Die Ladeschleife aus Woche 5

```python
ladezustand = 0.0
while ladezustand != 1.0:
    ladezustand = ladezustand + 0.1
```

- Jeder Schritt addiert nicht genau 0,1, sondern die nächstgelegene speicherbare Zahl
- Nach zehn Schritten steht in `ladezustand` fast 1,0, aber nicht **exakt** 1,0
- Die Bedingung bleibt `True`, die Schleife läuft endlos

### Vorhersage-Aufgabe (1 min)

Aufschreiben, dann ausführen:

```python
print(0.1 + 0.2 == 0.3)
print(0.1 + 0.2)
```

### Erklär-Aufgabe (3 min, auf Papier)

Dieses Skript gibt `10029.999999999996362` aus. Erklären Sie in zwei Sätzen, warum eine „krumme“ Zahl erscheint:

```python
x = 100.3
summe = 0
for i in range(100):
    summe += x
print(f"{summe:.15f}")
```

### Und wie macht man es richtig?

Kommazahlen mit **Toleranz** vergleichen statt mit `==`:

```python
a = 0.1 + 0.2
if abs(a - 0.3) < 1e-9:
    print("praktisch gleich")
```

Schritte mit **ganzen Zahlen** zählen, wie in Woche 5. Ganze Zahlen sind exakt:

```python
prozent = 0
while prozent < 100:
    prozent = prozent + 10
ladezustand = prozent / 100
```

### Achtung typischer Fehler

```python
ladezustand = 0.0
schritte = 0
while ladezustand < 1.0:
    ladezustand = ladezustand + 0.1
    schritte += 1
print(schritte, ladezustand)
```

- `<` statt `!=` beendet die Schleife zwar, aber erst nach **11** Schritten bei `1.0999999999999999`
- Nach zehn Schritten steht dort `0.9999999999999999`, und das ist kleiner als 1,0

### So üben Sie Umrechnungen

- KI-Quizze auf **OneTutor**: https://link.hm.edu/vkej
- Oder mit einem Chatbot: Lassen Sie sich Umrechnungsaufgaben stellen und Ihre Lösungen prüfen

### Mini-Check

Ohne Computer:

1. Wie viele Werte lassen sich mit 10 Bit darstellen?
2. $1010_2$: dezimal?
3. Warum ist 0,1 binär nicht exakt darstellbar? Ein Satz
4. Wie prüft man zwei Kommazahlen auf „gleich“?

### Schöne Ferien! 🎄

Nach den Ferien: **Eigene Datentypen mit Klassen** und der Semesterrückblick

- Üben: KI-Quizze auf OneTutor: https://link.hm.edu/vkej
- Fragen: auch in den Ferien im Matrix-Chat
