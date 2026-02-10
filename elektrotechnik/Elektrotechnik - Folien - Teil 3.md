---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik (Teil 3/3)

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

### Gliederung des Kurses

1. [Einführung](#einführung) (Physikalische Größen, Einheiten)
2. [Das elektrische Feld](#das-elektrische-feld) (Ladungen, Kräfte, Felder, Potential, Spannung, Kapazität, Kondensatoren)
3. [Gleichstrom](#gleichstrom) (Stromstärke, Widerstand, Stromkreisberechnungen, Energie, Leistung)
4. [Magnetismus](#magnetismus) (Feld in Vakuum und Materie, Kräfte, magnetischer Kreis)
5. [Elektromagnetische Induktion](#elektromagnetische-induktion) (Induktion, Selbstinduktion, Energie)
6. [Wechselstrom](#wechselstrom) (Komplexe Wechselstromrechnung, Schaltungen, Leistung)
7. [Drehstrom](#drehstrom) (Dreiphasensystem)
8. [Schaltvorgänge an Kapazitäten und Induktivitäten](#schaltvorgänge-an-kapazitäten-und-induktivitäten)


## Wechselstrom

- Grundlegende Begriffe und Definitionen
- [Komplexe Wechselstromrechnung](#komplexe-darstellung)
- [Wechselstromwiderstände](#wechselstromwiderstände)
- [Grundschaltungen linearer Wechselstromwiderstände](#grundschaltungen-linearer-wechselstromwiderstände)
- [Leistung im Wechselstromkreis](#leistung-bei-wechselstromverbrauchern) (Blindleistung, Wirkleistung, Scheinleistung)

### Wechselstrom: Grundlagen

**Periodische Größen:**

- Sich zeitlich wiederholende physikalische Größen
- Periodendauer $T$ -> $u(t) = u(t + T)$
- Frequenz: $f = \frac{1}{T}$, Kreisfrequenz: $\omega = 2\pi f$

**Wechselgrößen:**

Periodische elektrische Größen mit verschwindendem arithmetischem Mittelwert 


![bg right:30% fit](https://upload.wikimedia.org/wikipedia/commons/5/54/Wechselspannungsformen.svg)


### Wechselgrößen: Eigenschaften

**Fourier-Analyse:** Jede Wechselgröße kann als Überlagerung von Sinusvorgängen dargestellt werden


$$a(t) = \sum_{n=1}^{\infty} \hat{A}_n \cdot \sin(n \cdot \omega t + \varphi_n)$$

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/6/6f/Fourier_d%27un_carr%C3%A9.svg)

### Arithmetischer Mittelwert

**Definition:**
$$\overline{a} = \frac{1}{T} \cdot \int_{t_0}^{t_0 + T} a(t) \, dt$$

**Für sinusförmige Wechselgrößen:**
$$a(t) = \hat{A} \cdot \sin(\omega \cdot t + \varphi_a)$$

**Gilt:**
$$\overline{a} = 0$$

Der arithmetische Mittelwert einer sinusförmigen Wechselgröße ist immer null.

### Gleichrichtwert

**Definition:**
$$\overline{|a|} = \frac{1}{T} \cdot \int_{t_0}^{t_0+T} |a(t)| \, dt$$

**Für sinusförmige Wechselgrößen:**

$$\overline{|a|} = \frac{2}{\pi} \cdot \hat{A} \approx 0{,}637 \cdot \hat{A}$$

Der Gleichrichtwert entspricht dem Mittelwert des Betrags der Wechselgröße.

### Effektivwert: Definition

**Physikalischer Hintergrund:**

- Derjenige Wert einer Wechselgröße, der in seiner Wirkung bei Energieumformung einem Gleichstrom entspricht

**Beispiel:**
$$W_\text{el} = I^2 \cdot R \cdot T \stackrel{!}{=} \int_{0}^{T} i^2(t) \cdot R \, dt$$

$$\Rightarrow I \equiv I_\text{eff} = \sqrt{\frac{1}{T} \cdot \int_{0}^{T} i^2(t) \, dt}$$

**Allgemeine Definition:**
$$A_\text{eff} = \sqrt{\frac{1}{T} \cdot \int_{t_0}^{t_0 + T} a^2(t) \, dt}$$

### Effektivwert für Sinusschwingungen

**Für sinusförmige Wechselgrößen:**
$$a(t) = \hat{A} \cdot \sin(\omega \cdot t + \varphi_a)$$

**Herleitung:**
$$A_\text{eff} = \sqrt{\frac{1}{T} \cdot \int_{0}^{T} \hat{A}^{2} \cdot \sin^{2}(\omega \cdot t) \, dt}$$

**Ergebnis:**
$$A_\text{eff} = \frac{\hat{A}}{\sqrt{2}} \approx 0{,}707 \cdot \hat{A}$$

### Effektivwert: Beispiele

**Netzspannung:**

- $U_\text{eff} = 230\text{ V}$ ③
- $\hat{U} = \sqrt{2} \cdot U_\text{eff} = 325\text{ V}$ ①

**Haushaltssicherung:**

- $I_\text{eff} = 16\text{ A}$ ③
- $\hat{I} = \sqrt{2} \cdot I_\text{eff} = 22{,}6\text{ A}$ ①

Der Effektivwert wird von Messgeräten angezeigt!

![bg right:35% 90%](https://upload.wikimedia.org/wikipedia/commons/8/83/Sinusspannung.svg)


### Zusammenfassung: Kennwerte von Wechselgrößen
| Kennwert | Definition | Formel | Für Sinusfunktion |
|----------|------------|--------|-------------------|
| **Arithmetischer Mittelwert** | Zeitlicher Mittelwert über eine Periode | $\overline{a} = \frac{1}{T} \cdot \int_{t_0}^{t_0 + T} a(t) \, dt$ | $\overline{a} = 0$ |
| **Gleichrichtwert** | Mittelwert des Betrags | $\overline{\|a\|} = \frac{1}{T} \cdot \int_{t_0}^{t_0+T} \|a(t)\| \, dt$ | $\overline{\|a\|} = \frac{2}{\pi} \cdot \hat{A} \approx 0{,}637 \cdot \hat{A}$ |
| **Effektivwert** | Quadratischer Mittelwert | $A_\text{eff} = \sqrt{\frac{1}{T} \cdot \int_{t_0}^{t_0 + T} a^2(t) \, dt}$ | $A_\text{eff} = \frac{\hat{A}}{\sqrt{2}} \approx 0{,}707 \cdot \hat{A}$ |



### Notationskonvention

In diesem Kapitel werden die zeitabhängigen Wechselgrößen mit Kleinbuchstaben bezeichnet:

- $u(t)$: Spannung
- $i(t)$: Strom

Großbuchstaben stehen für die zugehörigen Amplituden:

- $\hat{U}$: Spannungsamplitude
- $\hat{I}$: Stromamplitude

### Zeigerdarstellung

**Sinusförmige Wechselgrößen** können als rotierende Zeiger in der komplexen Ebene dargestellt werden.

**Zeigereigenschaften:**

- Winkelgeschwindigkeit: $\omega = 2\pi f$
- Länge: $\hat{U}=U_\text{max}$ (Amplitude)
- zum Zeitpunkt $t=0$: $\varphi_u$

![bg right:50% 100%](https://physikbuch.schule/media/ac-inductor-phasor-diagram.svg)


### Komplexe Darstellung

Um Berechnungen zu vereinfachen, können Wechselgrößen als komplexe Größen dargestellt werden. Anstatt mit trigonometischen Funktionen zu rechnen, kann dann die Exponentialfunktion verwendet werden.

**Zeitabhängige komplexe Spannung:**
$$\underline{u}(t) = \hat{U} \cdot e^{j(\omega t + \varphi_u)}=\hat{U} \cdot e^{j\omega t} \cdot e^{j\varphi_u}= \underbrace{\underbrace{\hat{U} \, e^{j\varphi_u}}_{\text{Festzeiger } \underline{U}} \;e^{j\omega t}}_{\text{Drehzeiger}}=\underline{U} \;e^{j\omega t}$$


**Reale Zeitfunktion:**
$$u(t) = \text{Re}\,\underline{u}(t) = \hat{U} \cdot \cos(\omega t + \varphi_u)$$

### Komplexe Zahlen: Grundlagen


**Imaginäre Einheit** (in der Elektrotechnik zur Unterscheidung von Strom $i(t)$ als $j$ notiert):
$$j = \sqrt{-1}, \quad j^2 = -1$$

**Komplexe Zahl:**
$$\underline{z} = a + jb$$

mit Realteil $a = \text{Re}\, \underline{z}$ und Imaginärteil $b = \text{Im}\,\underline{z}$

![bg right:50% 90%](https://upload.wikimedia.org/wikipedia/commons/c/c6/Komplexe_zahlenebene.svg)

### Euler’sche Formel

**Euler’scher Satz:**
$$e^{j\varphi} = \cos(\varphi) + j\sin(\varphi)$$

**Wichtige Spezialfälle:**

- $e^{j0} = 1$
- $e^{j\pi/2} = j$
- $e^{j\pi} = -1$
- $e^{j3\pi/2} = -j$
- $e^{j2\pi} = 1$

![bg right:45% 80%](https://upload.wikimedia.org/wikipedia/commons/7/71/Euler%27s_formula.svg)

### Darstellungsformen

**Komponentenform (kartesisch):**
$$\underline{Z} = R + j X$$

**Polarform (Exponentialform):**
$$\underline{Z} = |\underline{Z}| \cdot e^{j\varphi} = Z \cdot e^{j\varphi}$$

**Umrechnung:**

- Betrag: $Z = |\underline{Z}| = \sqrt{R^2 + X^2}$
- Phase: $\varphi = \arctan\left(\frac{X}{R}\right)$
- Realteil: $R = Z \cdot \cos(\varphi)$
- Imaginärteil: $X = Z \cdot \sin(\varphi)$

### Konjugiert komplexe Zahl

**Konjugiert komplexe Zahl** $\underline{Z}^*$:

$$\underline{Z} = R + jX \quad \Rightarrow \quad \underline{Z}^* = R - jX$$

$$\underline{Z} = Z \cdot e^{j\varphi} \quad \Rightarrow \quad \underline{Z}^* = Z \cdot e^{-j\varphi}$$

**Eigenschaften:**

- $\underline{Z} \cdot \underline{Z}^* = |\underline{Z}|^2 = Z^2$
- $\text{Re}\,\underline{Z} = \dfrac{\underline{Z} + \underline{Z}^*}{2}$

### Addition und Subtraktion

**In Komponentenform:**
$$\underline{Z} = \underline{Z}_1 \pm \underline{Z}_2 = (R_1 \pm R_2) + j(X_1 \pm X_2)$$

**In Polarform:** Umrechnung in Komponentenform notwendig
$$\underline{Z} = Z_1 \cdot e^{j\varphi_1} \pm Z_2 \cdot e^{j\varphi_2}=(Z_1 \cos\varphi_1 \pm Z_2 \cos\varphi_2) + j(Z_1 \sin\varphi_1 \pm Z_2 \sin\varphi_2)$$

Addition und Subtraktion erfolgen am einfachsten in Komponentenform!

### Multiplikation

**In Polarform:**
$$\underline{Z} = \underline{Z}_1 \cdot \underline{Z}_2 = Z_1 \cdot e^{j\varphi_1} \cdot Z_2 \cdot e^{j\varphi_2} = Z_1 \cdot Z_2 \cdot e^{j(\varphi_1 + \varphi_2)}$$

Beträge multiplizieren, Phasen addieren!

**In Komponentenform:**
$$\underline{Z} = (R_1 + jX_1) \cdot (R_2 + jX_2)$$
$$= (R_1 R_2 - X_1 X_2) + j(R_1 X_2 + R_2 X_1)$$

### Division

**In Polarform:**
$$\underline{Z} = \frac{\underline{Z}_1}{\underline{Z}_2} = \frac{Z_1 \cdot e^{j\varphi_1}}{Z_2 \cdot e^{j\varphi_2}} =
 \frac{Z_1}{Z_2} \cdot e^{j(\varphi_1 - \varphi_2)}$$

Beträge dividieren, Phasen subtrahieren!

**In Komponentenform:** Erweitern mit konjugiert komplexem Nenner
$$\frac{\underline{Z}_1}{\underline{Z}_2} = \frac{R_1 + jX_1}{R_2 + jX_2} \cdot \frac{R_2 - jX_2}{R_2 - jX_2} = \frac{(R_1 R_2 + X_1 X_2) + j(R_2 X_1 - R_1 X_2)}{R_2^2 + X_2^2}$$


## 📝 Gruppenarbeit: Spannung × Strom

**Gegeben:**

- Spannung: $u(t) = 325\,\text{V} \cdot \cos(\omega t)$
- Strom: $i(t) = 10\,\text{A} \cdot \sin(\omega t)$

**Aufgaben:**
1. Zeichnen Sie beide Größen als **Zeiger** im Zeigerdiagramm
2. Stellen Sie $\underline{U}$ und $\underline{I}$ in **kartesischer Form** ($a + jb$) dar
3. Wandeln Sie beide um in **Polarform** ($Z \cdot e^{j\varphi}$)
4. Berechnen Sie das Produkt $\underline{U} \cdot \underline{I}^*$ in **beiden Darstellungen**
5. Vergleichen Sie die Ergebnisse und diskutieren Sie: Was fällt auf?

**Hinweis:** $\sin(\omega t) = \cos(\omega t - 90°)$



## Wechselstromwiderstände

### Grundelemente im Wechselstromkreis

Die drei Grundelemente im Wechselstromkreis sind:

- Ohmscher Widerstand R ![](https://upload.wikimedia.org/wikipedia/commons/c/c3/Resistor_symbol_IEC.svg)
- Kapazität C ![](https://upload.wikimedia.org/wikipedia/commons/6/6d/Capacitor_Symbol_alternative.svg)
- Induktivität L ![](https://upload.wikimedia.org/wikipedia/commons/4/4b/Inductor.svg)

### Ohmscher Widerstand

**Grundgleichung:**
$$u = R \cdot i$$

**Spannungs- und Stromverlauf:**
$$u = \hat{U} \cdot \sin(\omega \cdot t + \varphi_u)$$
$$i = \hat{I} \cdot \sin(\omega \cdot t + \varphi_i)$$

Mit $u = R \cdot i$ folgt:
$$\hat{U} \cdot \sin(\omega \cdot t + \varphi_u) = R \cdot \hat{I} \cdot \sin(\omega \cdot t + \varphi_i)$$


$$ \Rightarrow \hat{U} = R \cdot \hat{I} \,, \qquad \varphi_u = \varphi_i$$

**Bei ohmschen Widerständen sind Strom und Spannung in Phase.**

![bg right:50% 90%](https://physikbuch.schule/media/ac-resistor-phasor-diagram.svg)

### Leistung am ohmschen Widerstand

Momentanleistung (für $\varphi_u = \varphi_i = 0$):

$$p(t) = u(t) \cdot i(t)= \hat{U} \cdot \sin(\omega t) \cdot \hat{I} \cdot \sin(\omega t)$$
$$= \hat{U} \cdot \hat{I} \cdot \sin^{2}(\omega t)= \hat{U} \cdot \hat{I} \cdot \frac{1}{2} \cdot (1 - \cos(2\omega t)) \geq 0$$

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-resistor.svg)

### Mittlere Leistung am ohmschen Widerstand

Berechnung:
$$\overline{p} = \frac{1}{T} \cdot \int_{0}^{T} p(t) \, dt$$
$$= \frac{1}{T} \cdot \frac{1}{2} \cdot \hat{U} \cdot \hat{I} \cdot \int_{0}^{T} (1 - \cos(2\omega t)) \, dt$$
$$= \frac{\hat{U} \cdot \hat{I}}{2 \cdot T} \cdot \left[ t - \frac{1}{2 \cdot \omega} \cdot \sin(2\omega t) \right]_{0}^{T}$$
$$= \frac{\hat{U} \cdot \hat{I}}{2} = \frac{\hat{U}}{\sqrt{2}} \cdot \frac{\hat{I}}{\sqrt{2}} = U_\text{eff} \cdot I_\text{eff}$$


**Leistung wird ständig verbraucht → Wirkwiderstand**

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-resistor.svg)

### Wirkleistung und Effektivwerte

**Beispiel einphasiges Laden von E-Autos**

Ein Elektrofahrzeug wird mit (einphasigem) Wechselstrom bei $U_\text{eff}=230\,\text{V}$ und $I_\text{eff}=16\,\text{A}$ geladen.

**Berechnung der Wirkleistung:**
$$P = U_\text{eff} \cdot I_\text{eff} = 230\,\text{V} \cdot 16\,\text{A} = 3680\,\text{W} = 3{,}7\,\text{kW}$$


- Ladedauer für 40-kWh-Akku: ca. 11 Stunden
- Falls $I_\text{eff}=32\,\text{A}$ -> $P \approx 7{,}4\,\text{kW}$

![bg right:40% cover](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Home_charging_110v_BMW_i3_CRI_04_2021_8162.jpg/960px-Home_charging_110v_BMW_i3_CRI_04_2021_8162.jpg)

### Kondensator

**Wiederholung**

Kapazität $C$ definiert als:

$$C = \frac{Q}{U}$$

**Kondensator als Bauteil im Wechselstromkreis**

Die Änderung der Ladung $Q$ ist gegeben durch den Strom $i$:
$$i = \frac{dQ}{dt} = C \cdot \frac{du}{dt}$$

![bg right:30% 90%](https://upload.wikimedia.org/wikipedia/commons/6/6d/Ac-capacitor-circuit.svg)

### Kapazität

**Grundgleichung:**
$$i = C \cdot \frac{du}{dt}$$

**Spannungs- und Stromverlauf:**
$$u = \hat{U} \cdot \sin(\omega \cdot t + \varphi_u)$$
$$i = \hat{I} \cdot \sin(\omega \cdot t + \varphi_i)$$


Mit $i = C \cdot \frac{du}{dt}$ folgt:
$$\hat{I} \cdot \sin(\omega \cdot t + \varphi_i) = C \cdot \frac{d(\hat{U} \cdot \sin(\omega \cdot t + \varphi_u))}{dt}$$
$$= C \cdot \omega \cdot \hat{U} \cdot \cos(\omega \cdot t + \varphi_u)$$
$$= C \cdot \omega \cdot \hat{U} \cdot \sin\left(\omega \cdot t + \frac{\pi}{2} + \varphi_u\right)$$

### Kapazität - Eigenschaften

$$u = \hat{U} \cdot \sin(\omega \cdot t + \varphi_u)$$
$$i = \hat{I} \cdot \sin(\omega \cdot t + \varphi_i)$$
$$= C \cdot \omega \cdot \hat{U} \cdot \sin\left(\omega \cdot t + \frac{\pi}{2} + \varphi_u\right)$$

**Bedingungen für die Gleichheit:**

- Amplituden: $\hat{I} = C \cdot \omega \cdot \hat{U}$ bzw. $\frac{\hat{U}}{\hat{I}} = \frac{1}{\omega \cdot C}$

- Phasen: $\varphi_i = \frac{\pi}{2} + \varphi_u$ bzw. $\varphi_u - \varphi_i = -\frac{\pi}{2}$

**→ Am Kondensator eilt der Strom der Spannung um $\frac{\pi}{2}$ voraus.**

![bg right:50% 90%](https://physikbuch.schule/media/ac-capacitor-phasor-diagram.svg)

### Leistung am Kondensator

**Momentanleistung** (mit $\varphi_u = 0$ und $\varphi_i = \frac{\pi}{2}$):
$$p(t) = u(t) \cdot i(t) = \hat{U} \cdot \sin(\omega t) \cdot \hat{I} \cdot \sin\left(\omega t + \frac{\pi}{2}\right)$$
$$= \hat{U} \cdot \hat{I} \cdot \sin(\omega t) \cdot \cos(\omega t) = \frac{\hat{U} \cdot \hat{I}}{2} \cdot \sin(2\omega t)$$
$$= U_\text{eff} \cdot I_\text{eff} \cdot \sin(2\omega t)$$

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-capacitor.svg)


### Leistung am Kondensator - Interpretation

**Energiefluss:**

- Positive Leistung: Aufladen des Kondensators
- Negative Leistung: Entladung des Kondensators

**Mittlere Leistung:**
$$\overline{p} = \frac{1}{T} \cdot \int_{0}^{T} p(t) \, dt = 0$$

→ **Blindwiderstand** mit kapazitiver **Blindleistung**:
$$Q_C = U_\text{eff} \cdot I_\text{eff}$$


![bg right:40% 90%](https://physikbuch.schule/media/ac-power-capacitor.svg)


### Induktivität

**Grundgleichung** (Selbstinduktion!):
$$u = L \cdot \frac{di}{dt}$$

**Spannungs- und Stromverlauf:**
$$u = \hat{U} \cdot \sin(\omega \cdot t + \varphi_u)$$
$$i = \hat{I} \cdot \sin(\omega \cdot t + \varphi_i)$$


Mit $u = L \cdot \frac{di}{dt}$ folgt:
$$\hat{U} \cdot \sin(\omega \cdot t + \varphi_u) = L \cdot \omega \cdot \hat{I} \cdot \cos(\omega \cdot t + \varphi_i)$$
$$= L \cdot \omega \cdot \hat{I} \cdot \sin\left(\omega \cdot t + \frac{\pi}{2} + \varphi_i\right)$$

### Induktivität - Eigenschaften

$$u = \hat{U} \cdot \sin(\omega \cdot t + \varphi_u)$$
$$i = \hat{I} \cdot \sin(\omega \cdot t + \varphi_i)$$
$$= L \cdot \omega \cdot \hat{I} \cdot \sin\left(\omega \cdot t + \frac{\pi}{2} + \varphi_i\right)$$

**Bedingungen für Gleichheit:**

- Amplituden: $\hat{U} = L \cdot \omega \cdot \hat{I}$ bzw. $\frac{\hat{U}}{\hat{I}} = \omega \cdot L$
- Phasen: $\varphi_u = \frac{\pi}{2} + \varphi_i$ bzw. $\varphi_u - \varphi_i = \frac{\pi}{2}$

**→ An der Induktivität eilt die Spannung dem Strom um $\frac{\pi}{2}$ voraus.**
![bg right:50% 90%](https://physikbuch.schule/media/ac-inductor-phasor-diagram.svg)

### Leistung an der Induktivität

**Momentanleistung** (mit $\varphi_u = \frac{\pi}{2}$ und $\varphi_i = 0$):
$$p(t) = u(t) \cdot i(t) = \hat{U} \cdot \sin\left(\omega t + \frac{\pi}{2}\right) \cdot \hat{I} \cdot \sin(\omega t)$$
$$= \hat{U} \cdot \hat{I} \cdot \cos(\omega t) \cdot \sin(\omega t) = \frac{\hat{U} \cdot \hat{I}}{2} \cdot \sin(2\omega t)$$
$$= U_\text{eff} \cdot I_\text{eff} \cdot \sin(2\omega t)$$

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-inductance.svg)


### Leistung an der Induktivität – Interpretation

**Energiefluss:**

- Positive Leistung: Energie zum Aufbau des magnetischen Feldes
- Negative Leistung: Energie durch Abbau des magnetischen Feldes

**Mittlere Leistung:**
$$\overline{p} = \frac{1}{T} \cdot \int_{0}^{T} p(t) \, dt = 0$$

→ **Blindwiderstand** mit induktiver **Blindleistung:**
$$Q_L = U_\text{eff} \cdot I_\text{eff}$$

![bg right:40% 90%](https://physikbuch.schule/media/ac-power-inductance.svg)


## Komplexe Darstellung der Wechselstromwiderstände

### Impedanz & Admittanz

**Impedanz** (komplexer Widerstand):
$$\underline{Z} = \frac{\underline{U}}{\underline{I}} = \frac{U}{I} \cdot e^{j \cdot (\varphi_u - \varphi_i)}$$

**Admittanz** (komplexer Leitwert):
$$\underline{Y} = \frac{\underline{I}}{\underline{U}} = \frac{I}{U} \cdot e^{-j \cdot (\varphi_u - \varphi_i)} = \frac{1}{\underline{Z}}$$

![bg right:40% fit](https://upload.wikimedia.org/wikipedia/commons/c/c2/Widerstand_Zeiger.svg)

### Impedanz des ohmschen Widerstands

$$\underline{U}= \hat{U} \cdot e^{j\omega t}$$
$$\underline{I}= \hat{I} \cdot e^{j\omega t}$$

$$\underline{Z}_R = \frac{\hat{U}}{\hat{I}} =R$$

### Impedanz der Kapazität

Strom eilt der Spannung um $\frac{\pi}{2}$ voraus:

$$\underline{U}= \hat{U} \cdot e^{j\omega t}$$
$$\underline{I}= \hat{I} \cdot e^{j\left(\omega t + \frac{\pi}{2}\right)} = \hat{I} \cdot e^{j\omega t} \cdot e^{j \frac{\pi}{2}}$$
$$\hat I = \omega \cdot C \cdot \hat U$$

$$\underline{Z}_{C} = \frac{\underline{U}}{\underline{I}}  =\frac{1}{\omega \cdot C} \cdot e^{-j \frac{\pi}{2}} = -j \frac{1}{\omega \cdot C} = j X_{C}$$

$X_C$: kapazitiver Blindwiderstand

$$\underline{Y}_C = \omega \cdot C \cdot e^{j \frac{\pi}{2}} = j \omega \cdot C = j B_C$$

$B_C$: kapazitiver Blindleitwert


### Impedanz der Induktivität

Spannung eilt dem Strom um $\frac{\pi}{2}$ voraus:

$$\underline{U}= \hat{U} \cdot e^{j\left(\omega t + \frac{\pi}{2}\right)} = \hat{U} \cdot e^{j\omega t} \cdot e^{j \frac{\pi}{2}}$$
$$\underline{I}= \hat{I} \cdot e^{j\omega t}$$
$$\hat U = \omega \cdot L \cdot \hat I$$

$$\underline{Z}_{L} = \frac{\underline{U}}{\underline{I}}  =\omega \cdot L \cdot e^{j \frac{\pi}{2}} = j \omega \cdot L = j X_{L}$$

$X_L$: induktiver Blindwiderstand

$$\underline{Y}_L = \frac{1}{\omega \cdot L} \cdot e^{-j \frac{\pi}{2}} = -j \frac{1}{\omega \cdot L} = j B_L$$

$B_L$: induktiver Blindleitwert

### Zusammenfassung: Impedanzen und Admittanzen der Grundelemente

|   | o. Widerstand R | Kapazität C | Induktivität L |
|---|---|---|---|
| **Impedanz Z** | $R$ | $\frac{1}{j\omega C} = j X_C$ | $j\omega L = j X_L$ |
| **Admittanz Y** | $\frac{1}{R} = G$ | $j\omega C = j B_C$ | $\frac{1}{j\omega L} = j B_L$ |

## Grundschaltungen linearer Wechselstromwiderstände

### Serienschaltung R und L

**Komplexe Maschenregel:**
$$\underline{U} = \underline{U}_R + \underline{U}_L = R \cdot \underline{I} + j  \omega L \cdot \underline{I}=\underline{Z} \cdot \underline{I}$$

**Impedanz:**
$$\underline{Z} = R + j \omega L$$

**Admittanz:**
$$\underline{Y} = \frac{1}{\underline{Z}}  = \frac{R - j\omega L}{R^2 + \omega^2 L^2}$$

**Betrag und Phase:**
$$Z = \sqrt{R^2 + (\omega L)^2}$$
$$\varphi = \arctan \frac{\omega L}{R}$$

![bg right:30% 80%](https://upload.wikimedia.org/wikipedia/commons/c/c0/Ac-inductor-circuit.svg)

### Parallelschaltung R und L

**Komplexe Knotenregel:**

$$\underline{I} = \underline{I}_R + \underline{I}_L = \left(\frac{1}{R} + \frac{1}{j \cdot \omega \cdot L}\right) \cdot \underline{U} = \underline{Y} \cdot \underline{U}$$

**Admittanz:**
$$\underline{Y} = \frac{1}{R} + \frac{1}{j \cdot \omega \cdot L} = \frac{1}{R} - j \cdot \frac{1}{\omega \cdot L}$$

**Impedanz:**
$$\underline{Z} = \frac{1}{\underline{Y}} = \frac{\omega \cdot L \cdot R \cdot (\omega \cdot L + j \cdot R)}{R^2 + \omega^2 \cdot L^2}$$


**Betrag und Phase:**
$$Z = \frac{1}{\sqrt{\frac{1}{R^2} + \frac{1}{(\omega \cdot L)^2}}} \,,\qquad \varphi = \arctan\left(\frac{R}{\omega \cdot L}\right)$$

### Serienschaltung R und C

$$\underline{U} = \underline{U}_R + \underline{U}_C = R \cdot \underline{I} + \frac{1}{j \cdot \omega \cdot C} \cdot \underline{I}=\underline{Z} \cdot \underline{I}$$

**Impedanz:**
$$\underline{Z} = R - j \frac{1}{\omega C}$$

**Admittanz:**
$$\underline{Y} = \frac{\omega C (\omega C R + j)}{1 + \omega^2 C^2 R^2}$$

**Betrag und Phase:**
$$Z = \sqrt{R^2 + \left(\frac{1}{\omega C}\right)^2}\,,\qquad \varphi = -\arctan\frac{1}{\omega CR}$$

### Parallelschaltung R und C

$$\underline{I} = \underline{I}_R + \underline{I}_C = \left(\frac{1}{R} + j \cdot \omega \cdot C\right) \cdot \underline{U}$$

**Admittanz:**
$$\underline{Y} = \frac{1}{R} + j \cdot \omega \cdot C$$


**Impedanz:**
$$\underline{Z} = \frac{1}{\underline{Y}} = \frac{R \cdot (1 - j \cdot \omega \cdot C \cdot R)}{1 + \omega^2 \cdot C^2 \cdot R^2}$$

**Betrag und Phase:**
$$Z = \frac{1}{\sqrt{\frac{1}{R^2} + (\omega \cdot C)^2}}\,,\qquad\varphi = -\arctan(\omega \cdot C \cdot R)$$

### Übersichtstabelle Grundschaltungen

| Schaltung | $\underline{Z}$ | $\underline{Y}$ | $\|Z\|$ | $\varphi$ |
|----------------------|-------------------|--------------------|-------------------|----------------|
| R-L Serie | $\underline{Z} = R + j\omega L$ | $\underline{Y} = \frac{R - j\omega L}{R^2 + \omega^2 L^2}$ | $Z = \sqrt{R^2 + (\omega L)^2}$ | $\varphi = \arctan \frac{\omega L}{R}$ |
| R-L Parallel | $\underline{Z} = \frac{\omega LR(\omega L + jR)}{R^2 + \omega^2 L^2}$ | $\underline{Y} = \frac{1}{R} - j \frac{1}{\omega L}$ | $Z = \frac{1}{\sqrt{\frac{1}{R^2} + \frac{1}{(\omega L)^2}}}$ | $\varphi = \arctan \frac{R}{\omega L}$ |
| R-C Serie | $\underline{Z} = R - j \frac{1}{\omega C}$ | $\underline{Y} = \frac{\omega C (\omega CR + j)}{1 + \omega^2 C^2 R^2}$ | $Z = \sqrt{R^2 + \left(\frac{1}{\omega C}\right)^2}$ | $\varphi = -\arctan\frac{1}{\omega CR}$ |
| R-C Parallel | $\underline{Z} = \frac{R(1 - j\omega CR)}{1 + \omega^2 C^2 R^2}$ | $\underline{Y} = \frac{1}{R} + j\omega C$ | $Z = \frac{1}{\sqrt{\frac{1}{R^2} + (\omega C)^2}}$ | $\varphi = -\arctan\omega CR$ |


## Leistung bei Wechselstromverbrauchern

### Rückblick: Leistung an R, L und C

**Wir haben bereits gesehen:**

**Am Widerstand R:**

- $\overline{p} = U_\text{eff} \cdot I_\text{eff}$ (Wirkleistung)
- Energie wird ständig verbraucht
- Keine Phasenverschiebung: $\varphi = 0°$

**Am Kondensator C und an der Induktivität L:**

- $\overline{p} = 0$ (Blindleistung)
- Energie pendelt zwischen Quelle und Feld
- Maximale Phasenverschiebung: $\varphi = \pm 90°$

### Vom Spezialfall zum Allgemeinfall

**Bisher betrachtet:**

- Rein ohmsche Verbraucher ($\varphi = 0°$)
- Rein reaktive Verbraucher ($\varphi = \pm 90°$)

**In der Praxis:**

- Kombinationen aus R, L und C
- **Beliebige Phasenverschiebung** $0° < |\varphi| < 90°$

**Beispiele:**

- Motor: R-L-Kombination mit $\varphi \approx 30°{-}60°$
- Netzteil: R-C-Kombination

### Der allgemeine Fall

**Bisher:** Ideale Bauteile (nur R, nur L, nur C)

**In der Praxis:** Kombinationen mit Phasenverschiebung $\varphi$

Spannung und Strom:

- $u(t) = \hat{U} \cdot \cos(\omega t)$
- $i(t) = \hat{I} \cdot \cos(\omega t - \varphi)$

Mit $\varphi = \varphi_u - \varphi_i$

**Frage:** Wie berechnet man die Leistung bei *beliebiger* Phasenverschiebung?

**Ziel:** Vom Spezialfall (R, L, C einzeln) zum Allgemeinfall (beliebige Kombinationen)

### Momentanleistung mit Phasenverschiebung

Die **Momentanleistung** bei beliebiger Phasenverschiebung:
$$p(t) = u(t) \cdot i(t) = \hat{U} \cdot \hat{I} \cdot \cos(\omega t) \cdot \cos(\omega t - \varphi)$$

**Mit trigonometrischer Umformung** ($\cos(a) \cdot \cos(b) = \frac{1}{2}[\cos(a-b) + \cos(a+b)]$):
$$p(t) = \frac{\hat{U} \cdot \hat{I}}{2} \cdot [\cos(\varphi) + \cos(2\omega t - \varphi)]$$

Die Leistung hat einen **konstanten** und einen **oszillierenden** Anteil!

### Zerlegung der Momentanleistung

Mit der Umformung $\cos(2\omega t - \varphi) = \cos(2\omega t)\cos(\varphi) + \sin(2\omega t)\sin(\varphi)$:

$$p(t) = \frac{\hat{U} \cdot \hat{I}}{2} \cdot \cos(\varphi) \cdot [1 + \cos(2\omega t)] + \frac{\hat{U} \cdot \hat{I}}{2} \cdot \sin(\varphi) \cdot \sin(2\omega t)$$

Mit Effektivwerten $U = \frac{\hat{U}}{\sqrt{2}}$, $I = \frac{\hat{I}}{\sqrt{2}}$:

$$p(t) = \underbrace{U \cdot I \cdot \cos(\varphi)}_{P} \cdot [1 + \cos(2\omega t)] + \underbrace{U \cdot I \cdot \sin(\varphi)}_{Q} \cdot \sin(2\omega t)$$

Die Leistung oszilliert mit **doppelter Frequenz** $2\omega$!

### Allgemeine Definitionen

**Aus der Zerlegung der Momentanleistung folgen die allgemeinen Definitionen:**

**Wirkleistung:**
$$P = U \cdot I \cdot \cos(\varphi)$$

**Blindleistung:**
$$Q = U \cdot I \cdot \sin(\varphi)$$

**Spezialfälle (Wiederholung):**

- $\varphi = 0°$ (nur R): $P = U \cdot I$, $Q = 0$
- $\varphi = 90°$ (nur L): $P = 0$, $Q = U \cdot I$
- $\varphi = -90°$ (nur C): $P = 0$, $Q = -U \cdot I$

### Wirkleistung P

Die **Wirkleistung** ist der zeitliche Mittelwert der Momentanleistung:

$$P = \langle p(t) \rangle = \frac{1}{T} \int_0^T u(t) \cdot i(t) \, dt$$

**Allgemeine Formel:**
$$\boxed{P = U \cdot I \cdot \cos \varphi}$$

wobei $U$ und $I$ die **Effektivwerte** sind.

**Einheit:** Watt [W]

**Grenzfälle:**

- $\varphi = 0°$ (nur R): $P = U \cdot I$ (maximal)
- $\varphi = \pm 90°$ (nur L oder C): $P = 0$

### Wirkleistung: Bedeutung

**Was ist Wirkleistung?**
- Die tatsächlich in Arbeit, Wärme oder Licht umgesetzte Leistung
- Nur der **in Phase** mit der Spannung schwingende Stromanteil trägt bei

**An ohmschen Widerständen:**
$$P = R \cdot I^2$$

**Praxisbeispiele:**

- Elektromotor: leistet mechanische Arbeit
- Heizung: erzeugt Wärme
- Glühbirne: erzeugt Licht

### Blindleistung Q

Die **Blindleistung** beschreibt den oszillierenden Energiefluss:

$$\boxed{Q = U \cdot I \cdot \sin \varphi}$$

**Einheit:** Voltampere reactive [var]

**Physikalische Bedeutung:**

**Bei induktiven Verbrauchern** (Motoren, Transformatoren):
- $\varphi > 0$: $Q_L > 0$ (positiv)
- Energie wird im **Magnetfeld** gespeichert und wieder abgegeben

**Bei kapazitiven Verbrauchern** (Kondensatoren):
- $\varphi < 0$: $Q_C < 0$ (negativ)
- Energie wird im **elektrischen Feld** gespeichert und wieder abgegeben

### Blindleistung: Praktische Bedeutung

**Problem:**
Blindleistung trägt **nicht** zur nutzbaren Leistung bei, belastet aber das Netz:

- **Höhere Ströme** in Leitungen und Transformatoren
- **Erhöhte Verluste:** $P_\text{Verlust} = R \cdot I^2$
- **Spannungsabfälle** im Netz

**Beispiel:** Motor ohne Last
- Benötigt hauptsächlich $Q_L$ zur Magnetisierung
- Hohe Ströme → Netzbelastung

**Konsequenz:** Industriekunden zahlen oft Strafgebühren bei hoher Blindleistung

### Scheinleistung S

Die **Scheinleistung** ist das Produkt der Effektivwerte:
$$S = U \cdot I$$

Sie beschreibt die **Gesamtbelastung** des Netzes.

**Zusammenhang mit Wirk- und Blindleistung:**
$$\boxed{S = \sqrt{P^2 + Q^2}}$$

**Einheit:** Voltampere [VA]

**Warum wichtig?**
- Generatoren, Transformatoren, Leitungen müssen für $S$ dimensioniert sein
- Nicht für $P$!

### Scheinleistung: Praxisbeispiel

**Transformator mit $S_\text{max} = 10\,\text{kVA}$**

**Szenario 1:** Idealer Verbraucher ($\cos \varphi = 1$)
- $P = S = 10\,\text{kW}$ nutzbare Leistung

**Szenario 2:** Schlechter Leistungsfaktor ($\cos \varphi = 0{,}7$)
- $P = S \cdot \cos \varphi = 10 \cdot 0{,}7 = 7\,\text{kW}$
- $Q = S \cdot \sin \varphi \approx 7{,}1\,\text{kvar}$

**Verlust:** 3 kW Wirkleistung durch Blindleistung!

Der Transformator ist voll ausgelastet ($S = 10\,\text{kVA}$), liefert aber nur 70% nutzbare Leistung.

## Komplexe Scheinleistung

### Motivation

**Frage:** Wie kann man Wirk- und Blindleistung *gemeinsam* darstellen?

**Idee:** Nutze die komplexe Darstellung!

Wir haben:

- Komplexe Spannung: $\underline{U} = U \cdot e^{j\varphi_u}$
- Komplexer Strom: $\underline{I} = I \cdot e^{j\varphi_i}$

**Naiver Ansatz:** $\underline{U} \cdot \underline{I} = U \cdot I \cdot e^{j(\varphi_u + \varphi_i)}$

**Problem:** Die Phasen *addieren* sich → **falsch**!

Wir brauchen die *Differenz* $\varphi = \varphi_u - \varphi_i$

**Lösung:** Konjugiert komplexer Strom $\underline{I}^*$

### Warum $\underline{U} \cdot \underline{I}^*$?

**Konjugiert komplexer Strom:**
$$\underline{I}^* = I \cdot e^{-j\varphi_i}$$

**Produkt:**
$$\underline{U} \cdot \underline{I}^* = U \cdot e^{j\varphi_u} \cdot I \cdot e^{-j\varphi_i}$$
$$= U \cdot I \cdot e^{j(\varphi_u - \varphi_i)}$$
$$= U \cdot I \cdot e^{j\varphi}$$

**Jetzt stimmt's!** Die Phase ist $\varphi = \varphi_u - \varphi_i$

In kartesischer Form:
$$\underline{U} \cdot \underline{I}^* = U \cdot I \cdot (\cos \varphi + j \sin \varphi)$$
$$= U \cdot I \cdot \cos \varphi + j \cdot U \cdot I \cdot \sin \varphi$$
$$= P + jQ$$

### Beispiel: RL-Reihenschaltung

**Gegeben:** RL-Reihenschaltung
$$\underline{Z} = R + j\omega L$$

**Spannung:**
$$\underline{U} = \underline{Z} \cdot \underline{I} = (R + j\omega L) \cdot \underline{I}$$

**Komplexe Scheinleistung:**
$$\underline{S} = \underline{U} \cdot \underline{I}^* = (R + j\omega L) \cdot \underline{I} \cdot \underline{I}^*$$

**Wichtig:** $\underline{I} \cdot \underline{I}^* = |\underline{I}|^2 = I^2$ ist **reell**!

$$\underline{S} = I^2 \cdot (R + j\omega L) = \underbrace{R \cdot I^2}_{P} + j \cdot \underbrace{\omega L \cdot I^2}_{Q}$$

**Realteil** = Wirkleistung am Widerstand R

**Imaginärteil** = Blindleistung an der Induktivität L


### Definition der komplexen Scheinleistung

Die **komplexe Scheinleistung** ist definiert als:

$$\boxed{\underline{S} = \underline{U} \cdot \underline{I}^* = P + jQ}$$

**In Polarform:**
$$\underline{S} = S \cdot e^{j\varphi}$$

mit:

- **Betrag:** $S = |\underline{S}| = \sqrt{P^2 + Q^2}$ (Scheinleistung)
- **Phase:** $\varphi = \varphi_u - \varphi_i$ (Phasenwinkel)

**Alternative Darstellungen:**
$$\underline{S} = \underline{Z} \cdot I^2 = \frac{U^2}{\underline{Z}^*}$$

## Leistungsdreieck und Leistungsfaktor

### Leistungsdreieck

Das **Leistungsdreieck** visualisiert den Zusammenhang

- Wirkleistung: $P = S \cdot \cos \varphi$
- Blindleistung: $Q = S \cdot \sin \varphi$
- Scheinleistung: $S = \sqrt{P^2 + Q^2}$
- Phasenwinkel: $\tan \varphi = \frac{Q}{P}$

![bg right:40% 80%](https://upload.wikimedia.org/wikipedia/commons/2/28/Leistungsdreieck.svg)

### Leistungsdreieck: Praxisbeispiel

**Industriebetrieb:**

- Wirkleistung: $P = 800\,\text{kW}$ (Maschinen)
- Blindleistung: $Q = 600\,\text{kvar}$ (Motoren)

**Berechnung der Scheinleistung:**
$$S = \sqrt{P^2 + Q^2} = \sqrt{800^2 + 600^2} = 1000\,\text{kVA}$$

**Phasenwinkel:**
$$\varphi = \arctan\frac{Q}{P} = \arctan\frac{600}{800} \approx 37°$$

**Konsequenz:**
Der Transformator muss für $S = 1000\,\text{kVA}$ ausgelegt sein, obwohl nur $P = 800\,\text{kW}$ genutzt werden!

### Leistungsfaktor cos φ

Der **Leistungsfaktor** gibt an, wie effizient die Scheinleistung genutzt wird:

$$\lambda = \cos \varphi = \frac{P}{S}$$

**Wertebereich:**

- $\cos \varphi = 1$: Ideal (rein ohmsch)
- $0 < \cos \varphi < 1$: Phasenverschiebung
- $\cos \varphi = 0$: Rein reaktiv

**Je höher, desto besser:** weniger Strom, weniger Verluste

### Leistungsfaktor: Typische Werte

**Verschiedene Verbraucher:**

| Verbraucher | cos φ | Bemerkung |
|-------------|-------|-----------|
| Glühbirne | ≈ 1,0 | Rein ohmsch |
| Heizung | ≈ 1,0 | Rein ohmsch |
| Motor ohne Last | ≈ 0,3 | Viel Magnetisierung |
| Motor Volllast | ≈ 0,85 | Besser, aber nicht ideal |
| Transformator | ≈ 0,8–0,9 | Streuinduktivität |
| Modernes Netzteil (PFC) | > 0,95 | Mit Kompensation |

**PFC** = Power Factor Correction

### Kostenaspekt: Warum cos φ wichtig ist

**Industriekunden** zahlen oft Strafgebühren bei $\cos \varphi < 0{,}9$

**Gründe:**
1. **Höhere Ströme** → höhere Verluste im Netz ($P_\text{Verlust} = R \cdot I^2$)
2. **Größere Anlagen** nötig (Transformatoren, Generatoren)
3. **Spannungsabfälle** im Netz

**Beispiel:**

- Bei $\cos \varphi = 0{,}7$ muss $I = \frac{P}{U \cdot 0{,}7}$ fließen
- Bei $\cos \varphi = 0{,}95$ nur $I = \frac{P}{U \cdot 0{,}95}$
- **Stromreduktion um 26%!**

**Energieversorger fordern:** $\cos \varphi > 0{,}9$

## Blindleistungskompensation

### Blindfaktor sin φ

Der **Blindfaktor** gibt den Anteil der Blindleistung an:

$$\beta = \sin \varphi = \frac{Q}{S}$$

**Zusammenhang mit Leistungsfaktor:**
$$\lambda^2 + \beta^2 = \cos^2 \varphi + \sin^2 \varphi = 1$$

**Bedeutung:**

- Hoher Blindfaktor → viel Blindleistung
- Niedriger Blindfaktor → wenig Blindleistung

**Ziel:** Blindfaktor minimieren durch Kompensation

### Blindleistungskompensation: Das Problem

**Problem bei induktiven Verbrauchern** (Motoren, Transformatoren):
- Hohe Blindleistung $Q_L > 0$
- Niedriger Leistungsfaktor $\cos \varphi$
- Hohe Ströme belasten das Netz
- Strafzahlungen drohen

**Lösung: Blindleistungskompensation**

**Idee:** Kondensatoren parallel schalten
- Kondensatoren: $Q_C < 0$ (kapazitive Blindleistung)
- Induktivität: $Q_L > 0$ (induktive Blindleistung)
- $Q_\text{gesamt} = Q_L + Q_C \approx 0$

### Blindleistungskompensation: Berechnung

**Gegeben:**

- Wirkleistung: $P$
- Ursprünglicher Leistungsfaktor: $\cos \varphi_1$
- Ziel-Leistungsfaktor: $\cos \varphi_2$

**Ursprüngliche Blindleistung:**
$$Q_1 = P \cdot \tan \varphi_1$$

**Ziel-Blindleistung:**
$$Q_2 = P \cdot \tan \varphi_2$$

**Benötigte kapazitive Blindleistung:**
$$Q_C = Q_1 - Q_2 = P \cdot (\tan \varphi_1 - \tan \varphi_2)$$

### Blindleistungskompensation: Praxisbeispiel

**Betrieb mit:**

- $P = 100\,\text{kW}$ (Wirkleistung)
- $\cos \varphi_1 = 0{,}8$ → $\varphi_1 \approx 37°$

**Ursprüngliche Werte:**

- $Q_L = P \cdot \tan(37°) = 100 \cdot 0{,}75 = 75\,\text{kvar}$
- $S_1 = \frac{P}{\cos \varphi_1} = \frac{100}{0{,}8} = 125\,\text{kVA}$
- $I_1 = \frac{S_1}{U} = \frac{125000}{400} = 312\,\text{A}$ (bei 400 V)

**Ziel:** $\cos \varphi_2 = 1$ (vollständige Kompensation)

**Benötigte Kondensatoren:**
$$Q_C = -75\,\text{kvar}$$

### Blindleistungskompensation: Ergebnis

**Nach Kompensation** ($\cos \varphi = 1$):
- $Q_\text{gesamt} = Q_L + Q_C = 75 - 75 = 0\,\text{kvar}$
- $S_2 = P = 100\,\text{kVA}$
- $I_2 = \frac{100000}{400} = 250\,\text{A}$

**Verbesserungen:**

- **Stromreduktion:** von 312 A auf 250 A → **20% weniger**
- **Scheinleistung:** von 125 kVA auf 100 kVA → **20% weniger**
- **Verluste:** $\propto I^2$ → **36% weniger** Leitungsverluste!
- **Keine Strafzahlungen** mehr

**Investition** in Kondensatoren amortisiert sich schnell!


### Zusammenfassung: Wirk-, Blind- und Scheinleistung

| Leistungsart | Symbol | Einheit | Bedeutung |
|--------------|--------|---------|-----------|
| **Wirkleistung** | $P$ | W (Watt) | Tatsächlich umgesetzte/nutzbare Leistung |
| **Blindleistung** | $Q$ | var | Pendelnde Leistung (Auf-/Abbau von Feldern) |
| **Scheinleistung** | $S$ | VA (Voltampere) | Rechengröße ($U \cdot I$), für Dimensionierung |

**Zusammenhang:**
$$S = \sqrt{P^2 + Q^2}$$

**Leistungsfaktor:**
$$\cos \varphi = \frac{P}{S}$$

- **Ziel:** $\cos \varphi$ möglichst nahe bei 1 (idealerweise > 0,9)
- **Maßnahme:** Kompensation mit Kondensatoren


### Wechselstrom: Niederspannung weltweit

![](https://upload.wikimedia.org/wikipedia/commons/7/70/World_Map_of_Mains_Voltages_and_Frequencies%2C_Detailed.svg)

### 👥 Gruppenarbeit: Westinghouse vs. Edison reloaded

Mit Ihrem jetzigen Wissen über Wechselstrom und Gleichstrom, Wirkleistung und Blindleistung, diskutieren Sie in Ihrer Gruppe die Vor- und Nachteile der beiden Stromsysteme.

- Edison 💡: Gleichstrom mit 110 V
- Westinghouse 〜: Wechselstrom mit 110 V, auf längere Strecken transformiert auf > 1000 V

**Hinweise:**

- Leitungsverluste (inklusive möglicher Blindleistung)
- Sicherheit (Spannungshöhe, Isolation)
- Wirtschaftlichkeit (Infrastruktur, Transformatoren)

**Zusatzfrage:** würde die Entscheidung heute anders ausfallen?


## Drehstrom

- [Grundlagen des Drehstromsystems](#grundlagen-des-drehstromsystems)
- [Stern- und Dreieckspannung](#stern--und-dreieckspannung)
- [Symmetrische Verbraucher](#symmetrische-verbraucher)
- [Leistung im Drehstromsystem](#leistung-im-drehstromsystem)

### Drehstrom: Motivation

**Warum Drehstrom?**

- **Effizientere Energieübertragung** über große Entfernungen
- **Höhere Leistung** bei gleicher Leitermasse
- **Einfache Erzeugung rotierender Magnetfelder** für Motoren

### Anwendungen von Drehstrom

**Energieversorgung:**

- Hochspannungsübertragung (110 kV, 380 kV)
- Verteilnetze (10 kV, 20 kV)
- Niederspannungsnetze (400 V)

**Antriebstechnik:**

- Asynchronmotoren in der Industrie
- Bahnantriebe
- Windkraftanlagen

**Elektromobilität:**

- Schnellladestationen (bis 350 kW)

### Grundlagen des Drehstromsystems

**Dreiphasensystem:**

Ein Drehstromsystem besteht aus **drei sinusförmigen Wechselspannungen** gleicher Amplitude und Frequenz, die um **120°** phasenverschieben sind.

**Zeitfunktionen:**
$$u_1(t) = \hat{U} \cdot \sin(\omega t)$$
$$u_2(t) = \hat{U} \cdot \sin(\omega t - 120°)$$
$$u_3(t) = \hat{U} \cdot \sin(\omega t - 240°)$$

**Komplexe Darstellung:**
$$\underline{U}_1 = U \cdot e^{j \cdot 0°}$$
$$\underline{U}_2 = U \cdot e^{j \cdot (-120°)}$$
$$\underline{U}_3 = U \cdot e^{j \cdot (-240°)}$$


### Rotierende Leiterschleife im Magnetfeld

**Prinzip der Wechselspannungserzeugung:**

Eine rechteckige Leiterschleife (Fläche $A$) rotiert mit konstanter Winkelgeschwindigkeit $\omega$ in einem homogenen Magnetfeld $\vec{B}$.

**Magnetischer Fluss durch die Schleife:**
$$\Phi(t) = B \cdot A \cdot \cos(\omega t)$$

**Induzierte Spannung (Faraday'sches Induktionsgesetz):**
$$u(t) = -\frac{d\Phi}{dt} = B \cdot A \cdot \omega \cdot \sin(\omega t) = \hat{U} \cdot \sin(\omega t)$$

**Amplitude:** $\hat{U} = B \cdot A \cdot \omega$


### Vom Wechselstrom zum Drehstrom

**Eine Leiterschleife:** Sinusförmige Wechselspannung
$$u_1(t) = \hat{U} \cdot \sin(\omega t)$$

**Drei Leiterschleifen um 120° versetzt:**

Drei identische Wicklungen sind räumlich um jeweils **120°** versetzt auf dem Rotor angeordnet.

$$u_1(t) = \hat{U} \cdot \sin(\omega t)$$
$$u_2(t) = \hat{U} \cdot \sin(\omega t - 120°)$$
$$u_3(t) = \hat{U} \cdot \sin(\omega t - 240°)$$

**Ergebnis:** Dreiphasiges Drehstromsystem



### Erzeugung von Drehstrom

**Drehstromgenerator:**

Ein Drehstromgenerator hat **drei um 120° versetzte Wicklungen**, die sich in einem rotierenden Magnetfeld befinden.

**Funktionsprinzip:**

- Rotor dreht sich mit konstanter Winkelgeschwindigkeit
- In jeder Wicklung wird eine Spannung induziert
- Die drei Spannungen sind zeitlich um 120° versetzt

![bg right:40% 80%](https://upload.wikimedia.org/wikipedia/commons/7/78/Simpel-3-faset-generator.gif)

### Symmetrisches Dreiphasensystem

**Aufbau:**

- Drei **Außenleiter** (L1, L2, L3) – oft als **Phasen** bezeichnet
- Ein **Neutralleiter** (N) – auf Erdpotential

**Bezeichnungen:**

- $\underline{U}_{1}, \underline{U}_{2}, \underline{U}_{3}, U_{Y}$: Sternspannung
- $U_Y=|\underline{U}_1| = |\underline{U}_2| = |\underline{U}_3|$
- $\underline{U}_{12}, \underline{U}_{23}, \underline{U}_{31}, U_{\Delta}$: Dreieckspannung
- $U_{\Delta}=|\underline{U}_{12}| = |\underline{U}_{23}| = |\underline{U}_{31}|$
- $\underline{I}_{1}, \underline{I}_{2}, \underline{I}_{3}, I$: Außenleiterstrom
- $\underline{I}_{N}$: Strom im Neutralleiter


### Maschengleichungen

Die Dreieckspannungen (Außenleiterspannungen) ergeben sich aus den Differenzen der Sternspannungen:

$$\underline{U}_{12} = \underline{U}_{1} - \underline{U}_{2}$$
$$\underline{U}_{23} = \underline{U}_{2} - \underline{U}_{3}$$
$$\underline{U}_{31} = \underline{U}_{3} - \underline{U}_{1}$$

Außerdem:

$$\underline{U}_{12} + \underline{U}_{23} + \underline{U}_{31} = 0$$

### Zeigerdiagramm

Die Sternspannungen $\underline{U}_1, \underline{U}_2, \underline{U}_3$ sind um 120° versetzt.

Die Dreieckspannungen $\underline{U}_{12}, \underline{U}_{23}, \underline{U}_{31}$ ergeben sich als Differenzen.


**Zusammenhang zwischen Stern- und Dreieckspannung:**
$$\boxed{U_{\Delta} = \sqrt{3} \cdot U_{Y}}$$

(Grafische Herleitung)

**Wichtig:**

- Dreieckspannungen sind um **30°** gegenüber den Sternspannungen gedreht
- $U_{\Delta} \approx 1{,}73 \cdot U_Y$


### Herleitung der Beziehung

**Gegeben:** $\underline{U}_1 = U_Y \cdot e^{j0°}$, $\underline{U}_2 = U_Y \cdot e^{-j120°}$

**Berechnung:**
$$\underline{U}_{12} = \underline{U}_{1} - \underline{U}_{2} = U_Y \cdot (e^{j0°} - e^{-j120°})$$
$$= U_Y \cdot (1 - (-\frac{1}{2} - j\frac{\sqrt{3}}{2}))$$
$$= U_Y \cdot (\frac{3}{2} + j\frac{\sqrt{3}}{2})$$

**Betrag:**
$$U_{\Delta} = |\underline{U}_{12}| = U_Y \cdot \sqrt{(\frac{3}{2})^2 + (\frac{\sqrt{3}}{2})^2} = U_Y \cdot \sqrt{3}$$

### Beispiel: Öffentliches Stromnetz

**Niederspannungsnetz in Deutschland:**

- **Sternspannung** (Phase gegen Neutralleiter):
  $$U_Y = 230\,\text{V}$$

- **Dreieckspannung** (zwischen zwei Außenleitern):
  $$U_{\Delta} = \sqrt{3} \cdot 230\,\text{V} \approx 400\,\text{V}$$

**Haushalte:**

- Einphasige Verbraucher: 230 V (L1-N, L2-N oder L3-N)
- Drehstromverbraucher: 400 V (L1-L2-L3)

## Symmetrische Verbraucher

**Definition:** 

Alle drei Verbraucherstränge sind mit dem gleichen Widerstand $\underline{Z}$ belastet:

$$\underline{Z}_1 = \underline{Z}_2 = \underline{Z}_3 = \underline{Z}$$

**Konsequenzen:**

- Alle Ströme haben den gleichen Betrag
- Phasenverschiebung zwischen den Strömen: 120°
- Neutralleiterstrom ist null: $\underline{I}_N = 0$

### Verbraucher in Sternschaltung

**Eigenschaften:**

- Strangströme = Außenleiterströme
- Strom durch Neutralleiter = 0 (bei symmetrischer Last)

$$I_\text{Str} = I = \frac{U_Y}{Z}$$
$$U_\text{Str} = U_Y = \frac{U_{\Delta}}{\sqrt{3}}$$

![bg right:32% 95%](https://upload.wikimedia.org/wikipedia/commons/8/86/Sternschaltung.svg)


### Verbraucher in Dreieckschaltung

**Eigenschaften:**

- Strangspannungen = Dreieckspannungen
- Zusammenhang zwischen Außenleiter- und Strangströmen:

$$U_\text{Str} = U_{\Delta} = \sqrt{3} \cdot U_{Y}$$
$$I_\text{Str} = \frac{U_{\Delta}}{Z}, \quad I = \sqrt{3} \cdot I_\text{Str}$$

![bg right:40% 95%](https://upload.wikimedia.org/wikipedia/commons/e/e2/Dreieckschaltung.svg)


### Vergleich Stern- und Dreieckschaltung

**Übersichtstabelle:**

| Größe | Sternschaltung | Dreieckschaltung |
|-------|----------------|------------------|
| **Strangspannung** | $U_\text{Str} = U_Y = \frac{U_{\Delta}}{\sqrt{3}}$ | $U_\text{Str} = U_{\Delta} = \sqrt{3} \cdot U_Y$ |
| **Strangstrom** | $I_\text{Str} = \frac{U_Y}{Z}$ | $I_\text{Str} = \frac{U_{\Delta}}{Z}$ |
| **Außenleiterstrom** | $I = I_\text{Str}$ | $I = \sqrt{3} \cdot I_\text{Str}$ |
| **Neutralleiter** | Vorhanden (kann entfallen bei symmetrischer Last) | Nicht vorhanden |

## Leistung im Drehstromsystem

### Leistung pro Strang

**Für symmetrische Verbraucher:**

Jeder der drei Stränge nimmt die gleiche Leistung auf.

**Scheinleistung pro Strang:**
$$S_\text{Str} = U_\text{Str} \cdot I_\text{Str}$$

**Wirkleistung pro Strang:**
$$P_\text{Str} = U_\text{Str} \cdot I_\text{Str} \cdot \cos(\varphi)$$

**Blindleistung pro Strang:**
$$Q_\text{Str} = U_\text{Str} \cdot I_\text{Str} \cdot \sin(\varphi)$$

wobei $\varphi$ die Phasenverschiebung zwischen Strang-Spannung und Strang-Strom ist.

### Gesamtleistung

**Die Gesamtleistung ist die Summe der Leistungen aller drei Stränge:**

**Scheinleistung:**
$$S_{ges} = 3 \cdot S_\text{Str} = 3 \cdot U_\text{Str} \cdot I_\text{Str}$$

**Wirkleistung:**
$$P_{ges} = 3 \cdot P_\text{Str} = 3 \cdot U_\text{Str} \cdot I_\text{Str} \cdot \cos(\varphi)$$

**Blindleistung:**
$$Q_{ges} = 3 \cdot Q_\text{Str} = 3 \cdot U_\text{Str} \cdot I_\text{Str} \cdot \sin(\varphi)$$

**Gilt für Stern- UND Dreieckschaltung!**

### Leistung in Sternschaltung

**Gegeben:**

- Sternspannung: $U_Y$
- Strangstrom = Außenleiterstrom: $I_\text{Str} = I$

**Gesamtleistung:**
$$S = 3 \cdot U_Y \cdot I$$

**Mit $U_Y = \frac{U_{\Delta}}{\sqrt{3}}$ folgt:**

$$S = 3 \cdot \frac{U_{\Delta}}{\sqrt{3}} \cdot I = \sqrt{3} \cdot U_{\Delta} \cdot I$$


### Leistung in Dreieckschaltung

**Gegeben:**

- Dreieckspannung: $U_{\Delta}$
- Strangstrom: $I_\text{Str} = \frac{I}{\sqrt{3}}$

**Gesamtleistung:**
$$S = 3 \cdot U_{\Delta} \cdot I_\text{Str} = 3 \cdot U_{\Delta} \cdot \frac{I}{\sqrt{3}} = \sqrt{3} \cdot U_{\Delta} \cdot I$$


### Allgemeine Leistungsformel

**Für symmetrische Drehstromverbraucher gilt unabhängig von der Schaltungsart:**

$$\boxed{S = \sqrt{3} \cdot U_{\Delta} \cdot I}$$

$$\boxed{P = \sqrt{3} \cdot U_{\Delta} \cdot I \cdot \cos(\varphi)}$$

$$\boxed{Q = \sqrt{3} \cdot U_{\Delta} \cdot I \cdot \sin(\varphi)}$$

wobei:

- $U_{\Delta}$: Dreieckspannung (Außenleiterspannung)
- $I$: Außenleiterstrom
- $\varphi$: Phasenverschiebung zwischen Strang-Spannung und Strang-Strom

**Hinweis:** Oft wird $U_{\Delta}$ einfach als $U$ geschrieben.

### Drehstrom-Blindleistungskompensation

**Problem:**
Drehstrommotoren haben oft einen niedrigen Leistungsfaktor ($\cos \varphi < 0{,}9$).

**Lösung:**
Kompensationskondensatoren in **Stern-** oder **Dreieckschaltung**


### Kapazität bei Sternschaltung

**Sternschaltung der Kondensatoren:**

Am Kondensator liegt die **Sternspannung** $U_Y$ an.

**Blindleistung pro Kondensator:**
$$Q_{C,\text{Str}} = U_Y^2 \cdot \omega \cdot C_Y$$

**Gesamte Blindleistung:**
$$Q_C = 3 \cdot U_Y^2 \cdot \omega \cdot C_Y$$

**Benötigte Kapazität pro Kondensator:**
$$\boxed{C_Y = \frac{Q_C}{3 \cdot U_Y^2 \cdot \omega}}$$


### Kapazität bei Dreieckschaltung

**Dreieckschaltung der Kondensatoren:**

Am Kondensator liegt die **Dreieckspannung** $U_{\Delta}$ an.

**Blindleistung pro Kondensator:**
$$Q_{C,\text{Str}} = U_{\Delta}^2 \cdot \omega \cdot C_{\Delta}$$

**Gesamte Blindleistung:**
$$Q_C = 3 \cdot U_{\Delta}^2 \cdot \omega \cdot C_{\Delta}$$

**Benötigte Kapazität pro Kondensator:**
$$\boxed{C_{\Delta} = \frac{Q_C}{3 \cdot U_{\Delta}^2 \cdot \omega}}$$

### Vergleich Stern- und Dreieckschaltung der Kondensatoren

In der Sternschaltung gilt $U_Y = \frac{U_{\Delta}}{\sqrt{3}}$, also:

$$C_Y = \frac{Q_C}{U_{\Delta}^2 \cdot \omega}, \qquad C_{\Delta} = \frac{Q_C}{3 \cdot U_{\Delta}^2 \cdot \omega}$$

$$\Rightarrow C_Y = 3 \cdot C_{\Delta}$$

**Interpretation:**

- Bei **Sternschaltung:** höhere Kapazität erforderlich
- Bei **Dreieckschaltung:** niedrigere Kapazität, aber höhere Spannungsbelastung

**Praxis:**

- Sternschaltung bei höheren Spannungen (Spannungsbelastung nur $U_Y$)
- Dreieckschaltung bei niedrigeren Spannungen

### Vorteile des Drehstromsystems

**Gegenüber einphasigem Wechselstrom:**

1. **Effizientere Energieübertragung**
   - Bei gleicher Leistung geringere Leiterverluste
   - Materialeinsparung bei Leitungen

2. **Konstante Leistungsabgabe**
   - Summe der Momentanleistungen ist konstant
   - Gleichmäßigerer Lauf von Motoren

3. **Einfache Erzeugung von Drehfeldern**
   - Drehstrommotoren ohne Anlaufhilfe
   - Robuster Aufbau




## Schaltvorgänge an Kapazitäten und Induktivitäten

- Einschaltvorgang und Ausschaltvorgang von Kapazitäten
- Einschaltvorgang und Ausschaltvorgang von Induktivitäten

### Einschaltvorgang: Kondensator


**Schalterstellung:**
$$u = \begin{cases} 0 & \text{für } t \le 0 \\ U_0 & \text{für } t > 0 \end{cases}$$

**Für t > 0 gilt (Maschengleichung):**
$$U_0 = u_R + u_C = i \cdot R + u_C = C \cdot \frac{du_C}{dt} \cdot R + u_C$$

**Gesucht:** $u_C(t)$

### Aufladevorgang: Lösung

**Lösung der Differentialgleichung:**

$$u_{C}(t) = U_{0} \cdot \left(1 - e^{-\frac{t}{\tau}}\right) \text{ mit } \tau = R \cdot C \quad (7.1)$$
$$i_{C}(t) = \frac{U_{0}}{R} \cdot e^{-\frac{t}{\tau}}$$

**Anfangs- und Endwerte:**

- $u_C(t=0) = 0$, $u_C(t \to \infty) = U_0$
- $i_C(t=0) = \frac{U_0}{R}$, $i_C(t \to \infty) = 0$

**Zeitkonstante:** $\tau = R \cdot C$

### Ausschaltvorgang: Kondensator


**Schalterstellung:**
$$u = \begin{cases} U_0 & \text{für } t \le 0 \\ 0 & \text{für } t > 0 \end{cases}$$

**Für t > 0 gilt (Maschengleichung):**
$$0 = u_R + u_C = i \cdot R + u_C = C \cdot \frac{du_C}{dt} \cdot R + u_C$$

### Entladevorgang: Lösung

**Lösung der Differentialgleichung:**

$$u_C(t) = U_0 \cdot e^{-\frac{t}{\tau}} \text{ mit } \tau = R \cdot C \quad (7.2)$$
$$i_C(t) = -\frac{U_0}{R} \cdot e^{-\frac{t}{\tau}}$$

**Anfangs- und Endwerte:**

- $u_C(t=0) = U_0$, $u_C(t \to \infty) = 0$
- $i_C(t=0) = -\frac{U_0}{R}$, $i_C(t \to \infty) = 0$

**Zeitkonstante:** $\tau = R \cdot C$

### Einschaltvorgang: Induktivität


**Schalterstellung:**
$$u = \begin{cases} 0 & \text{für } t \le 0 \\ U_0 & \text{für } t > 0 \end{cases}$$

**Für t > 0 gilt (Maschengleichung):**
$$U_0 = u_R + u_L = i_L \cdot R + L \cdot \frac{di_L}{dt}$$

**Gesucht:** $i_L(t)$

### Aufbau des Magnetfeldes: Lösung

**Lösung der Differentialgleichung:**

$$i_{L}(t) = \frac{U_{0}}{R} \cdot \left(1 - e^{-\frac{t}{\tau}}\right) \text{ mit } \tau = \frac{L}{R} \quad (7.3)$$
$$u_{L}(t) = U_{0} \cdot e^{-\frac{t}{\tau}}$$

**Anfangs- und Endwerte:**

- $i_L(t=0) = 0$, $i_L(t \to \infty) = \frac{U_0}{R}$
- $u_L(t=0) = U_0$, $u_L(t \to \infty) = 0$

**Zeitkonstante:** $\tau = \frac{L}{R}$

### Ausschaltvorgang: Induktivität


**Schalterstellung:**
$$u = \begin{cases} U_0 & \text{für } t \le 0 \\ 0 & \text{für } t > 0 \end{cases}$$

**Für t > 0 gilt (Maschengleichung):**
$$0 = u_R + u_L = i_L \cdot R + L \cdot \frac{di_L}{dt}$$

### Abbau des Magnetfeldes: Lösung

**Lösung der Differentialgleichung:**
$$i_{L}(t) = \frac{U_{0}}{R} \cdot e^{-\frac{t}{\tau}} \text{ mit } \tau = \frac{L}{R} \quad (7.4)$$
$$u_{L}(t) = -U_{0} \cdot e^{-\frac{t}{\tau}}$$

**Anfangs- und Endwerte:**

- $i_L(t=0) = \frac{U_0}{R}$, $i_L(t \to \infty) = 0$
- $u_L(t=0) = -U_0$, $u_L(t \to \infty) = 0$

**Zeitkonstante:** $\tau = \frac{L}{R}$

### Beispiel 1: Kondensator-Entladung

**Aufgabe:** 

Ein Kondensator $C = 0{,}1\,\mu\text{F}$ wird über einen Widerstand $R = 5\,\Omega$ entladen. 

In welcher Zeit $t_x$ ist die Spannung am Kondensator auf 10% des ursprünglichen Wertes gesunken?

### Beispiel 2: Pufferkondensator

**Aufgabe:** 

Der Datenspeicher eines Taschenrechners (Lastwiderstand $R = 2{,}2\,\text{M}\Omega$) soll während des Batteriewechsels aus einem Kondensator $C$ gespeist werden.

**Gegeben:**

- Batteriespannung: $U_B = 3\,\text{V}$
- Batteriewechselzeit: $t_W = 30\,\text{s}$
- Minimale Versorgungsspannung: $U_{\text{min}} = 0{,}8\,\text{V}$

**Gesucht:** Dimensionierung von $C$



### Freilaufdioden

**Problem bei Induktivitäten:**

Beim Abschalten einer Spule mit Strom $I$ entsteht eine hohe Induktionsspannung $u_\text{ind} = -u_L = -L \cdot \frac{di}{dt}$

- Bei schnellem Abschalten können sehr hohe Spannungen entstehen
- Diese können Schaltkreise beschädigen (z.B. Transistoren, Relais)

**Lösung: Freilaufdiode**

- Parallel zur Induktivität wird eine Diode geschaltet
- Beim Abschalten kann der Strom durch die Diode weiterfließen
- Gespeicherte Energie wird kontrolliert abgebaut

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/9/90/Catchdiode.png)
