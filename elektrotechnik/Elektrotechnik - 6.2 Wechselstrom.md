---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 6. Wechselstrom II

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 6. Wechselstrom

1. Grundlegende Begriffe und Kennwerte
2. Komplexe Wechselstromrechnung
3. Wechselstromwiderstände (Impedanz, Admittanz)
4. Grundschaltungen
5. Leistung (Wirk-, Blind-, Scheinleistung)
6. Blindleistungskompensation
7. Resonanz und Frequenzverhalten

### Grundelemente im Wechselstromkreis

Die drei Grundelemente im Wechselstromkreis sind:

- Ohmscher Widerstand R ![](https://upload.wikimedia.org/wikipedia/commons/c/c3/Resistor_symbol_IEC.svg)
- Kapazität C ![](https://upload.wikimedia.org/wikipedia/commons/6/6d/Capacitor_Symbol_alternative.svg)
- Induktivität L ![](https://upload.wikimedia.org/wikipedia/commons/4/4b/Inductor.svg)

### Ohmscher Widerstand

Mit $u = R \cdot i$ und sinusförmigen Verläufen folgt:

$$\hat{U} = R \cdot \hat{I}, \qquad \varphi_u = \varphi_i$$

**Bei ohmschen Widerständen sind Strom und Spannung in Phase.**

![bg right:50% 90%](https://physikbuch.schule/media/ac-resistor-phasor-diagram.svg)

### Leistung am ohmschen Widerstand

Momentanleistung (für $\varphi_u = \varphi_i = 0$):

$$p(t) = u(t) \cdot i(t) = \hat{U} \hat{I} \sin^2(\omega t) = \frac{\hat{U} \hat{I}}{2} (1 - \cos(2\omega t)) \geq 0$$

Mittlere Leistung:

$$\overline{p} = \frac{\hat{U} \hat{I}}{2} = U_\text{eff} \cdot I_\text{eff}$$

**Leistung wird ständig verbraucht → Wirkwiderstand**

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-resistor.svg)

### Beispiel: Einphasiges Laden von E-Autos

Ein Elektrofahrzeug wird mit Wechselstrom bei $U_\text{eff} = 230 \, \text{V}$ und $I_\text{eff} = 16 \, \text{A}$ geladen:

$$P = U_\text{eff} \cdot I_\text{eff} = 3680 \, \text{W} \approx 3{,}7 \, \text{kW}$$

- Ladedauer für 40-kWh-Akku: ca. 11 Stunden
- Bei $I_\text{eff} = 32 \, \text{A}$: $P \approx 7{,}4 \, \text{kW}$

![bg right:40% cover](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Home_charging_110v_BMW_i3_CRI_04_2021_8162.jpg/960px-Home_charging_110v_BMW_i3_CRI_04_2021_8162.jpg)

### Kondensator im Wechselstromkreis

Die Änderung der Ladung ist der Strom:

$$i = \frac{dQ}{dt} = C \cdot \frac{du}{dt}$$

Einsetzen der Sinusverläufe (→ Tafel) liefert:

- Amplituden: $\frac{\hat{U}}{\hat{I}} = \frac{1}{\omega C}$
- Phasen: $\varphi_u - \varphi_i = -\frac{\pi}{2}$

**Am Kondensator eilt der Strom der Spannung um $\frac{\pi}{2}$ voraus.**

![bg right:45% 90%](https://physikbuch.schule/media/ac-capacitor-phasor-diagram.svg)

### Leistung am Kondensator

$$p(t) = u(t) \cdot i(t) = U_\text{eff} \, I_\text{eff} \cdot \sin(2\omega t)$$

- Positive Leistung: Aufladen; negative: Entladen
- **Mittlere Leistung:** $\overline{p} = 0$

→ **Blindwiderstand**: Energie pendelt zwischen Quelle und elektrischem Feld

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-capacitor.svg)

### Induktivität im Wechselstromkreis

Grundgleichung (Selbstinduktion, Kapitel 5!):

$$u = L \cdot \frac{di}{dt}$$

Einsetzen der Sinusverläufe liefert:

- Amplituden: $\frac{\hat{U}}{\hat{I}} = \omega L$
- Phasen: $\varphi_u - \varphi_i = +\frac{\pi}{2}$

**An der Induktivität eilt die Spannung dem Strom um $\frac{\pi}{2}$ voraus.**

Merkspruch: „Bei Induktivitäten die Ströme sich verspäten; im Kondensator eilt der Strom vor."

![bg right:45% 90%](https://physikbuch.schule/media/ac-inductor-phasor-diagram.svg)

### Leistung an der Induktivität

$$p(t) = U_\text{eff} \, I_\text{eff} \cdot \sin(2\omega t)$$

- Positive Leistung: Aufbau des Magnetfelds; negative: Abbau
- **Mittlere Leistung:** $\overline{p} = 0$

→ **Blindwiderstand**: Energie pendelt zwischen Quelle und Magnetfeld

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-inductance.svg)

### Impedanz & Admittanz

**Impedanz** (komplexer Widerstand):
$$\underline{Z} = \frac{\underline{U}}{\underline{I}} = \frac{U}{I} \cdot e^{j(\varphi_u - \varphi_i)}$$

**Admittanz** (komplexer Leitwert):
$$\underline{Y} = \frac{1}{\underline{Z}}$$

**Ohm’sches Gesetz, Kirchhoff, Reihen-/Parallelschaltung, Teiler, Zweipoltheorie — alles gilt weiter, nur mit komplexen Größen!**

![bg right:40% fit](https://upload.wikimedia.org/wikipedia/commons/c/c2/Widerstand_Zeiger.svg)

### Impedanzen der Grundelemente

**Ohmscher Widerstand:** $\underline{Z}_R = R$

**Kapazität** (Strom eilt vor): 
$$\underline{Z}_C = \frac{1}{j\omega C} = -j\,\frac{1}{\omega C}, \qquad \underline{Y}_C = j\omega C$$

**Induktivität** (Spannung eilt vor):
$$\underline{Z}_L = j\omega L, \qquad \underline{Y}_L = \frac{1}{j\omega L} = -j\,\frac{1}{\omega L}$$

| | R | C | L |
|---|---|---|---|
| $\underline{Z}$ | $R$ | $\frac{1}{j\omega C}$ | $j\omega L$ |
| $\underline{Y}$ | $\frac{1}{R}$ | $j\omega C$ | $\frac{1}{j\omega L}$ |

### Serienschaltung R und L

**Komplexe Maschenregel:**
$$\underline{U} = \underline{U}_R + \underline{U}_L = (R + j\omega L) \cdot \underline{I}$$

**Impedanz:**
$$\underline{Z} = R + j\omega L$$

**Betrag und Phase:**
$$Z = \sqrt{R^2 + (\omega L)^2}, \qquad \varphi = \arctan\frac{\omega L}{R}$$

![bg right:30% 80%](https://upload.wikimedia.org/wikipedia/commons/c/c0/Ac-inductor-circuit.svg)

### Parallelschaltung R und L

**Komplexe Knotenregel:**
$$\underline{I} = \underline{I}_R + \underline{I}_L = \underline{Y} \cdot \underline{U}$$

**Admittanz** (parallel → Admittanzen addieren!):
$$\underline{Y} = \frac{1}{R} - j\,\frac{1}{\omega L}$$

**Betrag und Phase:**
$$Z = \frac{1}{\sqrt{\frac{1}{R^2} + \frac{1}{(\omega L)^2}}}, \qquad \varphi = \arctan\frac{R}{\omega L}$$

### Serienschaltung / Parallelschaltung R und C

**Serie:**
$$\underline{Z} = R - j\,\frac{1}{\omega C}, \qquad Z = \sqrt{R^2 + \left(\tfrac{1}{\omega C}\right)^2}, \qquad \varphi = -\arctan\frac{1}{\omega C R}$$

**Parallel:**
$$\underline{Y} = \frac{1}{R} + j\omega C, \qquad Z = \frac{1}{\sqrt{\frac{1}{R^2} + (\omega C)^2}}, \qquad \varphi = -\arctan(\omega C R)$$

Vorzeichen von $\varphi$: **kapazitiv → negativ, induktiv → positiv**

### Übersichtstabelle Grundschaltungen

| Schaltung | $\underline{Z}$ | $\underline{Y}$ | $\|Z\|$ | $\varphi$ |
|----------------------|-------------------|--------------------|-------------------|----------------|
| R-L Serie | $R + j\omega L$ | $\frac{R - j\omega L}{R^2 + \omega^2 L^2}$ | $\sqrt{R^2 + (\omega L)^2}$ | $\arctan \frac{\omega L}{R}$ |
| R-L Parallel | $\frac{\omega LR(\omega L + jR)}{R^2 + \omega^2 L^2}$ | $\frac{1}{R} - j \frac{1}{\omega L}$ | $\frac{1}{\sqrt{\frac{1}{R^2} + \frac{1}{(\omega L)^2}}}$ | $\arctan \frac{R}{\omega L}$ |
| R-C Serie | $R - j \frac{1}{\omega C}$ | $\frac{\omega C (\omega CR + j)}{1 + \omega^2 C^2 R^2}$ | $\sqrt{R^2 + \left(\frac{1}{\omega C}\right)^2}$ | $-\arctan\frac{1}{\omega CR}$ |
| R-C Parallel | $\frac{R(1 - j\omega CR)}{1 + \omega^2 C^2 R^2}$ | $\frac{1}{R} + j\omega C$ | $\frac{1}{\sqrt{\frac{1}{R^2} + (\omega C)^2}}$ | $-\arctan\omega CR$ |

### 📝 Jetzt sind Sie dran: RL-Schaltung komplett (zu zweit)

**Aufgabe 19** *(Klausur-Grundmuster — mit Zeigerdiagramm!)*

Eine Reihenschaltung aus $R = 40 \, \Omega$ und einer Spule mit $\omega L = 30 \, \Omega$ liegt an $\underline{U} = 10 \, \text{V} \cdot e^{j0}$ (komplexer Effektivwert).

a) Berechnen Sie $\underline{Z}$ in Komponenten- und Polarform.
b) Berechnen Sie den Strom $\underline{I}$ sowie $\underline{U}_R$ und $\underline{U}_L$.
c) **Zeichnen Sie das Zeigerdiagramm** mit $\underline{U}$, $\underline{I}$, $\underline{U}_R$, $\underline{U}_L$ (Achsen skalieren!).
d) Geben Sie für den Strom an: Effektivwert $I$, Amplitude $\hat{I}$ und Phase $\varphi_i$.
