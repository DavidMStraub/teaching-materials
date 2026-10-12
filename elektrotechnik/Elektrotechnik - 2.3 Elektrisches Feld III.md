---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 2. Das elektrische Feld III

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 2. Das elektrische Feld

1. Elektrische Ladung
2. Coulomb’sches Gesetz
3. Elektrische Feldstärke
4. Feldlinien und Satz von Gauß
5. Elektrisches Feld in Materie
6. Potential, Spannung, Arbeit
7. Homogenes Feld und Kondensatoren

### Homogenes elektrisches Feld

- Konstante Feldstärke $E$ in Betrag und Richtung, parallele Feldlinien
- Äquipotentialflächen senkrecht zu den Feldlinien
- Spannung: $U = E \cdot d$ ($d$: Abstand in Feldrichtung)

![bg 80% right:33%](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Field_lines_equipotentials_parallel_plates.svg/1920px-Field_lines_equipotentials_parallel_plates.svg.png)

### Kondensatoren (*capacitors*)

Kondensatoren sind Bauelemente, die elektrische Ladung speichern.

**Kapazität** (*capacitance*):

$$C := \frac{Q}{U}$$

Einheit: $[C] = \frac{\text{C}}{\text{V}} = \text{F}$ (Farad)

![bg 80% right:40%](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Capacitors_%287189597135%29.jpg/1280px-Capacitors_%287189597135%29.jpg)

### ⚠️ Kapazität ≠ Kapazität

Die Kapazität (*capacity*) einer Batterie ist eine Ladungsmenge!

z.B.: $\text{mAh} = 10^{-3} \, \text{A} \cdot 3600 \, \text{s} = 3{,}6 \, \text{C}$

Nicht zu verwechseln mit der Kapazität (*capacitance*) eines Kondensators in Farad!

### 📝 Aufgabe 5a: Plattenkondensator

Zwei Platten der Fläche $A$ im Abstand $d$ tragen die Ladungen $+Q$ und $-Q$. Dazwischen liegt ein Dielektrikum mit $\varepsilon_r$.

a) Wie groß ist $D$ zwischen den Platten? (Satz von Gauß mit einer Hüllfläche um eine Platte)

b) Wie groß sind $E$ und $U$?

c) Leiten Sie daraus $C$ her. Wovon hängt die Kapazität ab, wovon nicht?

![bg 80% right:33%](https://upload.wikimedia.org/wikipedia/commons/2/20/Plate_CapacitorII.svg)

### Plattenkondensator

Satz von Gauß (Hüllfläche um eine Platte): $D = \frac{Q}{A}$

$$E = \frac{D}{\varepsilon_0 \varepsilon_r} = \frac{Q}{\varepsilon_0 \varepsilon_r A}, \qquad U = E \cdot d = \frac{Q \cdot d}{\varepsilon_0 \varepsilon_r A}$$

$$C = \frac{Q}{U} = \frac{\varepsilon_0 \varepsilon_r A}{d} = \frac{\varepsilon A}{d}$$

Kapazität steigt mit Fläche $A$, Permittivität $\varepsilon_r$ und kleinerem Abstand $d$.

![bg 80% right:33%](https://upload.wikimedia.org/wikipedia/commons/2/20/Plate_CapacitorII.svg)

### 🗳️ Kondensatoren in Reihe

Zwei ungeladene Kondensatoren $C_1$ und $C_2 = 4 \, C_1$ werden **in Reihe** an eine Spannungsquelle angeschlossen.

Was ist nach dem Aufladen für beide gleich?

A) die Ladung $Q$

B) die Spannung $U$

C) beides

D) nichts davon

### Parallelschaltung von Kondensatoren

$$C_{\text{ges}} = C_1 + C_2 + \dots + C_n = \sum_{i=1}^n C_i$$

- Gleiche Spannung an allen Kondensatoren
- Gesamtladung = Summe der Einzelladungen

![bg 100% right:45%](https://upload.wikimedia.org/wikipedia/commons/e/ee/Kondensator_C1_plus_C2.svg)

### Reihenschaltung von Kondensatoren

$$\frac{1}{C_{\text{ges}}} = \frac{1}{C_1} + \frac{1}{C_2} + \dots + \frac{1}{C_n} = \sum_{i=1}^n \frac{1}{C_i}$$

- Gleiche Ladung auf allen Kondensatoren: $Q_1 = Q_2 = \dots = Q_\text{ges}$
- Gesamtspannung = Summe der Einzelspannungen

Herleitung: $C_{\text{ges}} = \frac{Q}{U_1 + U_2 + \dots} = \frac{Q}{Q \cdot \left(\frac{1}{C_1} + \frac{1}{C_2} + \dots\right)}$

![bg 100% right:45%](https://upload.wikimedia.org/wikipedia/commons/0/01/Kondensator_C1_C2_Reihe.svg)

### Energie im Kondensator

Beim Aufladen nimmt die Spannung mit der Ladung zu: $U(q) = \frac{q}{C}$

$$W = \int_0^Q U(q) \, dq = \int_0^Q \frac{q}{C} \, dq = \frac{Q^2}{2C} = \frac{1}{2} Q U = \frac{1}{2} C U^2$$

$$[W] = \text{V} \cdot \text{C} = \text{W} \cdot \text{s} = \text{J}$$

![bg 90% right:35%](img/kondensator-energie.svg)

### 🗳️ Platten auseinanderziehen

Ein Plattenkondensator wird an einer Spannungsquelle aufgeladen und dann von ihr **getrennt**.

Anschließend werden die Platten auf den **doppelten Abstand** auseinandergezogen. Was passiert mit der Spannung $U$?

A) $U$ halbiert sich

B) $U$ bleibt gleich

C) $U$ verdoppelt sich

D) $U$ vervierfacht sich

### 📝 Aufgabe 5b: Kondensatoren

Zwei Kondensatoren $C_1 = 1 \, \mu\text{F}$ und $C_2 = 4 \, \mu\text{F}$ werden **in Reihe** geschaltet und an eine Spannung $U = 5000 \, \text{V}$ gelegt.

a) Schätzen Sie zuerst ohne Rechnung: An welchem Kondensator liegt die größere Spannung?

b) Wie groß ist die Gesamtkapazität $C_g$?

c) Wie groß sind die Teilspannungen $U_1$ und $U_2$?

d) Wie viel Energie ist insgesamt gespeichert?

### Unsere Basiseinheiten-Tabelle wächst

| Elektrische Größe | Formelzeichen | Einheit | Basiseinheiten |
|---|---|---|---|
| Ladung | $Q$ | C | $\text{A} \cdot \text{s}$ |
| Spannung | $U$ | V | ❓ |
| **Kapazität** | $C$ | F | ❓ |

Leiten Sie die Basiseinheiten von Spannung und Kapazität her – Ansatz: $[U] = \frac{[W]}{[Q]}$, $[C] = \frac{[Q]}{[U]}$

### 🗳️ Basiseinheiten des Farad

Welche Basiseinheiten hat die Kapazität $[C] = \text{F}$?

A) $\dfrac{\text{A}^2 \cdot \text{s}^4}{\text{kg} \cdot \text{m}^2}$

B) $\dfrac{\text{kg} \cdot \text{m}^2}{\text{A} \cdot \text{s}^3}$

C) $\dfrac{\text{A} \cdot \text{s}^2}{\text{kg} \cdot \text{m}^2}$

D) $\dfrac{\text{A}^2 \cdot \text{s}^3}{\text{kg} \cdot \text{m}}$

### Zusammenfassung: Das elektrische Feld

- Feldlinien: von + nach −, Dichte = Feldstärke; Äquipotentialflächen ⊥ Feldlinien
- Satz von Gauß: $\oint \vec{D} \cdot d\vec{A} = Q_\text{innen}$ – mächtig bei Symmetrie
- Dielektrika schwächen das Feld: $E \to E/\varepsilon_r$
- Potential $\varphi$, Spannung $U = \varphi_1 - \varphi_2$, Arbeit $W = Q \cdot U$ (wegunabhängig!)
- Homogenes Feld: $U = E \cdot d$
- Kondensator: $C = Q/U$; Platte: $C = \varepsilon A/d$; parallel: $C$ addieren, in Reihe: $1/C$ addieren
- Energie: $W = \frac{1}{2} C U^2$

**Nächstes Kapitel:** Gleichstrom – jetzt bewegen sich die Ladungen! 🔌

### Übersicht: Größen im elektrischen Feld

Größe | Definition | Einheit
--- | --- | ---
Elektrische Ladung (*electric charge*) | $Q$ | $[Q] = \text{C}$
Spannung (*voltage*) | $U = \Delta \varphi$ | $[U] = \text{V}$
Kapazität (*capacitance*) | $C = \frac{Q}{U}$ | $[C] = \text{F} = \frac{\text{C}}{\text{V}}$
Elektrische Feldstärke (*electric field [strength]*) | $\vec{E} = \frac{\vec{F}}{Q}$ | $[\vec{E}] = \frac{\text{V}}{\text{m}}=\frac{\text{N}}{\text{C}}$
Elektrische Flussdichte (*electric flux density*) | $\vec{D} = \varepsilon_0 \varepsilon_r \vec{E}$ | $[\vec{D}] = \frac{\text{C}}{\text{m}^2}$
Elektrische Feldkonstante (*electric constant*) | $\varepsilon_0$ | $[\varepsilon_0] = \frac{\text{C}^2}{\text{N} \cdot \text{m}^2}$
Relative Permittivität (*relative permittivity*) | $\varepsilon_r = \frac{\varepsilon}{\varepsilon_0}$ | dimensionslos

## Vertiefung

Für alle, die es genauer wissen wollen

### Vertiefung: Kondensatoren mit geschichteten Dielektrika

Der Raum zwischen den Platten ist mit zwei verschiedenen Dielektrika gefüllt:

a) **nebeneinander** (Flächen $A_1$, $A_2$)

b) **hintereinander** (Dicken $d_1$, $d_2$)

Welcher Kondensatorschaltung entspricht jeweils die Anordnung?

![bg 90% right:30%](img/dielektrika-geschichtet.svg)

### Vertiefung: Kondensatoren mit geschichteten Dielektrika

**Nebeneinander** (= Parallelschaltung):

$$C = \frac{\varepsilon_0}{d} \left(\varepsilon_{r1} A_1 + \varepsilon_{r2} A_2\right)$$

**Hintereinander** (= Reihenschaltung):

$$C = \frac{\varepsilon_0 \, \varepsilon_{r1} \varepsilon_{r2} \, A}{\varepsilon_{r2} d_1 + \varepsilon_{r1} d_2}$$

Anwendung: kapazitiver Ölstandsensor

![bg 90% right:30%](img/dielektrika-geschichtet.svg)

### Vertiefung: Kugel- und Zylinderkondensator

| | Kugel | Zylinder |
|---|---|---|
| | $C = 4\pi \varepsilon \dfrac{R_1 R_2}{R_2 - R_1}$ | $C = 2 \pi \varepsilon \dfrac{l}{\ln(R_2/R_1)}$ |

Herleitung: Satz von Gauß + $U = \int E \, dr$ (gleiche Methode wie beim Punktladungs-Beispiel)

![bg 90% right:33% vertical](https://upload.wikimedia.org/wikipedia/commons/3/3f/Spherical_Capacitor.svg)
![bg 90%](https://upload.wikimedia.org/wikipedia/commons/b/b8/Cylindrical_CapacitorII.svg)
