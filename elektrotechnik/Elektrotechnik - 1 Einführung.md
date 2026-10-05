---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 1. Einführung

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

### EduVote

https://www.vote.ac/ oder EduVote-App

ID: david.straub@hm.edu

### Organisatorisches

- 🎓 Moodle-Kurs: https://moodle.hm.edu/course/view.php?id=25470
- Lehrmaterialien: https://davidstraub.de/teaching-materials/elektrotechnik/
- 💬 Matrix-Raum: https://matrix.hm.edu/#/room/%23fk03-lrb1b-elektrotechnik-ws26%3Ahm.edu
- 🕥 Sprechstunde: nach Vereinbarung per Zoom oder in Präsenz in B 374
- 📖 Literatur
    - Pregla – [OPAC](https://link.hm.edu/2c6h)
    - Hagmann – [OPAC](https://link.hm.edu/fvqd)
    - Hering u.a. – [online](https://link.springer.com/book/10.1007/978-3-662-67538-0)
    - Fischer – [online](https://link.springer.com/book/10.1007/978-3-658-25644-9)
- 🗒️ Skript Prof. Palme u.a.: https://palme.userweb.mwn.de/
    - ⚠️ Kapitelnummerierung weicht von diesem Kurs ab (Reihenfolge ist aber gleich!)

### Was Sie am Ende können

- Kräfte, Felder und Spannungen von Ladungen und Strömen berechnen
- Gleichstromschaltungen analysieren: Ströme, Spannungen, Leistung
- Wechsel- und Drehstromschaltungen komplex berechnen
- Induktion und Schaltvorgänge an Spulen und Kondensatoren beschreiben und berechnen

### Gliederung des Kurses

1. **Einführung** (Physikalische Größen, Einheiten)
2. **Das elektrische Feld** (Ladungen, Kräfte, Felder, Potential, Spannung, Kondensatoren)
3. **Gleichstrom** (Stromstärke, Widerstand, Stromkreisberechnungen, Energie, Leistung)
4. **Magnetismus** (Feld in Vakuum und Materie, Kräfte, magnetischer Kreis)
5. **Elektromagnetische Induktion** (Induktion, Selbstinduktion, Energie)
6. **Wechselstrom** (Komplexe Wechselstromrechnung, Schaltungen, Leistung, Resonanz)
7. **Drehstrom** (Dreiphasensystem)
8. **Schaltvorgänge** an Kapazitäten und Induktivitäten

### Prüfung

- Schriftlich, 60 Minuten
- **Keine Hilfsmittel** – auch keine Formelsammlung
- Aufgaben vom Typ der 📝-Aufgaben aus dem Unterricht
- **Probeklausur** zur Semestermitte unter Prüfungsbedingungen
- Altklausuren: https://palme.userweb.mwn.de/

### So läuft jede Einheit ab

- **Montagsaufgabe** (10 min, ab Woche 2): kleine Aufgabe zur Vorwoche
- Theorie-Blöcke von max. 40 Minuten
- Nach jedem Theorie-Block: **📝 Sie rechnen selbst**
- ☕ Pause: immer 11:30–11:45

### Was ich von Ihnen erwarte

- **Mitrechnen:** die 📝-Aufgaben im Unterricht selbst lösen – gerade dann, wenn es hakt
- **Mitreden:** mit der Person neben Ihnen diskutieren, Fragen stellen – jederzeit
- **Mitschreiben:** Tafelanschriebe ergänzen die Folien und sind prüfungsrelevant

### So bestehen Sie die Prüfung

- **Jetzt schreiben:** im 1. Semester ist der Stoff frisch – jedes Semester danach bringt neue Fächer dazu
- **Jede Woche** die 📝-Aufgaben nachrechnen, bis sie ohne Vorlage klappen
- **Herleiten statt auswendig lernen:** wenige Grundgleichungen tragen weit
- **Probeklausur mitschreiben:** sie zeigt Ihnen, wo Sie stehen – mit Zeit zum Nachsteuern

## 1. Einführung

### Mars Climate Orbiter (1999)

Was passiert, wenn man Einheiten verwechselt:

- NASA-Sonde, soll am 23. September 1999 in die Mars-Umlaufbahn einschwenken
- Bodensoftware eines Zulieferers liefert Kraftstöße in **lbf·s**, die Navigation erwartet **N·s** → Faktor 4,45
- Sonde fliegt in ca. 57 km Höhe statt 140–150 km durch die Atmosphäre → verloren

Video: https://www.youtube.com/watch?v=MfavzjbZzl8

![bg 90% right:35%](https://upload.wikimedia.org/wikipedia/commons/1/19/Mars_Climate_Orbiter_2.jpg)

### Heute

1. Physikalische Größen
2. Internationales Einheitensystem (SI)
3. Rechnen mit Einheiten und Dimensionen

### Physikalische Größen

... sind messbare Eigenschaften eines Systems.

**Skalare Größen**: werden durch einen *Zahlenwert* und eine *Einheit* beschrieben.

$$x = \underbrace{\lbrace x \rbrace}_{\text{Zahlenwert}} \cdot \underbrace{[x]}_{\text{Einheit}}$$

Beispiele:

- $t = 10 \, \text{s}$ (Zeit)
- $m = 5 \, \text{kg}$ (Masse)
- $\Delta T = -20 \, \text{K}$ (Temperaturdifferenz)

### Rechnen mit Einheiten

- Nur Größen mit gleichen Einheiten können addiert oder subtrahiert werden

$$x = 2 \, \text{m} + 3 \, \text{m} = 5 \, \text{m}$$

- Bei Multiplikation/Division von Größen werden die Einheiten multipliziert/dividiert

$$v = \frac{s}{t} = \frac{10 \, \text{m}}{5 \, \text{s}} = 2 \, \frac{\text{m}}{\text{s}} = 7{,}2 \, \text{km/h}$$

Hinweis: im Textsatz werden Einheiten immer aufrecht geschrieben, Variablen *kursiv*.

### Vektorielle physikalische Größen

... sind physikalische Größen, die durch einen *Betrag* und eine *Richtung* beschrieben werden. Der Betrag wird durch einen *Zahlenwert* und eine *Einheit* beschrieben.

$$\vec{v}\equiv \mathbf{v} = \underbrace{|\vec{v}|}_{\text{Betrag}} \cdot \underbrace{\vec{e}_v}_{\text{Richtung}}$$

$$ |\vec{v}| \equiv v = \underbrace{\lbrace v \rbrace}_{\text{Zahlenwert}} \cdot \underbrace{[v]}_{\text{Einheit}}$$

Der Zahlenwert des Betrags ist immer positiv.

Beispiele:

- $\vec{v} = 10 \, \frac{\text{m}}{\text{s}} \cdot \vec{e}_x$ (Geschwindigkeit)
- $\vec{a} = 9{,}81 \, \frac{\text{m}}{\text{s}^2} \cdot (-\vec{e}_{z})$ (Beschleunigung)

![bg 90% right:30%](img/vektor.svg)

### Das Internationale Einheitensystem (SI)

| Basisgröße                    | Größensymbol      | Dimensionssymbol         | Einheit   | Einheitenzeichen |
| ----------------------------- | ----------------- | ------------------------ | --------- | ---------------- |
| Zeit                          | $t$               | $\text{T}$               | Sekunde   | s                |
| Länge                         | $l$               | $\text{L}$               | Meter     | m                |
| Masse                         | $m$               | $\text{M}$               | Kilogramm | kg               |
| **Elektrische Stromstärke**   | $I$               | $\text{I}$               | Ampere    | A                |
| Thermodynamische Temperatur   | $T$               | $\Theta$                 | Kelvin    | K                |
| Stoffmenge                    | $n$               | $\text{N}$               | Mol       | mol              |
| Lichtstärke                   | $I_v$             | $\text{J}$               | Candela   | cd               |

Für die Elektrotechnik zentral: das **Ampere** – alle elektrischen Einheiten bauen darauf auf.

### Was *ist* eigentlich eine Basiseinheit?

Seit 2019 ist jede Basiseinheit über **exakt festgelegte Naturkonstanten** definiert – kein Urmeter, kein Urkilogramm mehr:

| Konstante    | Beschreibung                                         | Exakter Wert         | Einheit |
|--------------|------------------------------------------------------|----------------------|---------|
| $\Delta\nu_\mathrm{Cs}$ | Strahlung des Caesium-Atoms                       | 9 192 631 770        | Hz      |
| $c$            | Lichtgeschwindigkeit                                 | 299 792 458          | m/s     |
| $h$            | Planck-Konstante                                     | 6,62607015 × 10<sup>−34</sup>   | J·s     |
| $e$            | **Elementarladung**                                  | 1,602176634 × 10<sup>−19</sup>  | C       |
| $k_\mathrm{B}$ | Boltzmann-Konstante                                 | 1,380649 × 10<sup>−23</sup>     | J/K     |
| $N_\mathrm{A}$ | Avogadro-Konstante                                  | 6,02214076 × 10<sup>23</sup>    | mol⁻¹   |
| $K_\mathrm{cd}$ | Photometrisches Strahlungsäquivalent               | 683                  | lm/W    |

![bg 85% right:28%](https://upload.wikimedia.org/wikipedia/commons/3/3c/SI_Illustration_Base_Units_and_Constants_Colour_Full.svg)


### Abgeleitete Einheiten

Von den Basisgrößen lassen sich durch mathematische Operationen abgeleitete Einheiten bilden.
Beispiele für abgeleitete Einheiten:

- **Kraft**: $\vec{F} = m \cdot \vec{a}$
    $[F] = [m] \cdot [\vec{a}]= \text{kg} \cdot \frac{\text{m}}{\text{s}^2} = \text{N}$ (Newton)

- **Energie/Arbeit**: $W = F \cdot s$
    $[W]  = \text{N} \cdot \text{m} = \frac{\text{kg} \cdot \text{m}^2}{\text{s}^2}= \text{J}$ (Joule)

- **Leistung**: $P = \frac{\Delta W}{\Delta t}$
$[P]  = \frac{[W]}{[t]} = \frac{\text{J}}{\text{s}} = \frac{\text{kg} \cdot \text{m}^2}{\text{s}^3}= \text{W}$ (Watt)

### Basiseinheiten: herleiten statt auswendig lernen

Jede elektrische Einheit lässt sich auf die sieben Basiseinheiten zurückführen:

| Elektrische Größe | Formelzeichen | Einheit | Basiseinheiten |
|---|---|---|---|
| Kraft | $F$ | N | $\text{kg} \cdot \text{m} \cdot \text{s}^{-2}$ |
| Kapazität | $C$ | F | ❓ |
| Induktivität | $L$ | H | ❓ |
| Magn. Flussdichte | $B$ | T | ❓ |

**Strategie:** nicht auswendig lernen, sondern aus einer bekannten Formel herleiten
(z.B. $[F] = [m] \cdot [a]$).

Diese Tabelle füllt sich im Laufe des Semesters – am Ende jedes Kapitels ergänzen wir sie.

### SI-Präfixe

|    Faktor      | Name   | Präfix | Faktor      | Name   | Präfix             |
| ----------- | -------- | ---------------- | ----------- | -------- | ---------------- |
| $10^{-1}$   | Dezi     | d                | $10^{1}$    | Deka     | da               |
| $10^{-2}$   | Zenti    | c                | $10^{2}$    | Hekto    | h                |
| $10^{-3}$   | Milli    | m                | $10^{3}$    | Kilo     | k                |
| $10^{-6}$   | Mikro    | µ                | $10^{6}$    | Mega     | M                |
| $10^{-9}$   | Nano     | n                | $10^{9}$    | Giga     | G                |
| $10^{-12}$  | Piko     | p                | $10^{12}$   | Tera     | T                |

In der Elektrotechnik alltäglich: µF, nF, pF (Kondensatoren), mH (Spulen), kΩ, MΩ (Widerstände), mA, kV, MW ...

### 📝 Aufgabe 1: Einheiten

a) Rechnen Sie um: $v = 108 \, \text{km/h}$ in m/s.

b) Der Impuls ist $p = m \cdot v$. Drücken Sie die Einheit von $p$ in Basiseinheiten aus und zeigen Sie: das ist dasselbe wie N·s (die Einheit aus dem Mars Climate Orbiter).

c) Ein Triebwerk leistet $P = 30 \, \text{MW}$ für $t = 2$ Minuten. Wie viel Energie in Joule?

### Dimensionsanalyse

Die **Dimension** (dritte Spalte der SI-Tabelle) beschreibt, wie eine Größe aus den Grundgrößen zusammengesetzt ist – unabhängig von Einheit und Zahlenwert.

Beispiele:

- Geschwindigkeit: $\text{dim}[v] = \frac{\text{L}}{\text{T}}$
- Kraft: $\text{dim}[F] = \text{M} \cdot \frac{\text{L}}{\text{T}^2}$
- Winkel: $\text{dim}[\varphi] = \frac{\text{L}}{\text{L}} = 1$ (dimensionslos)

**Beide Seiten einer Gleichung müssen dieselbe Dimension haben!**

→ Der schnellste Fehler-Check überhaupt: am Ende jeder Rechnung die Einheiten prüfen.

### 🗳️ Welche Gleichung kann *nicht* stimmen?

A) $E = m \cdot g \cdot h$

B) $P = F \cdot v$

C) $F = \dfrac{m \cdot v^2}{r}$

D) $W = \dfrac{P}{t}$

### ⚠️ Nicht-SI-Einheiten in der Luftfahrt ✈️

Immer noch weit verbreitet:

- Flughöhe in **Fuß** 🦶
    - 1 ft = 0,3048 m
- Entfernung in **Seemeilen** 🚢
    - 1 NM = 1852 m
- Geschwindigkeit in **Knoten** 🪢
    - 1 kt = 1 NM/h = 1,852 km/h

![bg 80% right:33%](https://upload.wikimedia.org/wikipedia/commons/5/57/3-Pointer_Altimeter.svg)

### Zusammenfassung: Einführung

- Physikalische Größe = Zahlenwert × Einheit; Vektoren zusätzlich mit Richtung
- 7 SI-Basiseinheiten – für uns zentral: das **Ampere**
- Abgeleitete Einheiten aus Formeln herleiten können ($\text{N}, \text{J}, \text{W}, \dots$)
- Dimensionsanalyse: beide Seiten einer Gleichung müssen dieselbe Dimension haben → Fehler-Check
- SI-Präfixe von p bis T sicher beherrschen
- Luftfahrt: ft, NM, kt – Umrechnung in SI

**Nächstes Kapitel:** Das elektrische Feld – Ladungen, Kräfte und warum der Blitz einschlägt ⚡
