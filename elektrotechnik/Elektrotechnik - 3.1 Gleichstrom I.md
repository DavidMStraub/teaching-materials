---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 3. Gleichstrom I

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 3. Gleichstrom

1. Stromstärke und Stromdichte
2. Stromleitung in Metallen
3. Ohm’sches Gesetz und Widerstand
4. Temperaturabhängigkeit des Widerstands
5. Die Kirchhoff’schen Gesetze
6. Reihen- und Parallelschaltung, Teilerregeln
7. Zweipoltheorie
8. Arbeit und Leistung
9. Reale Messungen im Gleichstromkreis

### Elektrischer Strom (*electric current*)

Strom ist der gerichtete Fluss von elektrischer Ladung

- Stromdichte $\vec{J} = \rho_Q \cdot \vec{v}$
    - $\rho_Q$: Ladungsdichte in $\frac{\text{C}}{\text{m}^3}$, $\vec{v}$: Geschwindigkeit der Ladungsträger
- Stromstärke $I = \int_A \vec{J} \cdot d\vec{A} = \dfrac{dQ}{dt}$
- $[I] = \text{A} = \dfrac{\text{C}}{\text{s}}$
- $[\vec{J}] = \dfrac{\text{A}}{\text{m}^2}$

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/f/f0/Stromdichte.svg)

### Stromrichtung & Ladungsträger

- $\vec{J} = \rho_Q \cdot \vec{v}$ zeigt in die Richtung, in die sich *positive* Ladung bewegt – egal ob die tatsächlichen Ladungsträger positiv oder negativ sind!
- In Metallen ist $\rho_Q < 0$: die Elektronen bewegen sich *entgegen* $\vec{J}$
- Das ist auch die *Zählrichtung* der Stromstärke $I$ („technische Stromrichtung“)

![bg 92% right:42%](img/stromrichtung.svg)

### Stromleitung in Metallen

- In Metallen gibt jedes Atom Elektronen ab, die sich frei im Gitter der positiv geladenen Atomrümpfe bewegen können („Elektronengas“)
- Die Ladungsdichte der Elektronen ist jederzeit konstant, da eine Ansammlung ein elektrisches Feld erzeugen würde, das durch Abstoßung der Elektronen wieder ausgeglichen wird → der Leiter ist überall elektrisch neutral

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/4/41/Nuvola_di_elettroni.svg)

### Metalle im elektrischen Feld

Klassisches Bild: erfährt das Elektronengas ein elektrisches Feld, werden die Elektronen beschleunigt, nach kurzer Zeit aber durch Stöße mit dem Metallgitter wieder abgebremst. Im Mittel ergibt sich eine konstante **Driftgeschwindigkeit** $\vec{v}_d$, *entgegen* der Feldrichtung: $\vec{v}_d = \vec{J}/\rho_Q$ mit $\rho_Q = -ne$.

![bg right:35% 80%](https://physikbuch.schule/media/drude-model.svg)

### 🗳️ Wie schnell sind die Elektronen?

Durch einen Kupferdraht mit $1 \, \text{mm}^2$ Querschnitt fließt ein Strom von $1 \, \text{A}$.

Wie schnell bewegen sich die Elektronen im Mittel entlang des Drahts?

A) fast mit Lichtgeschwindigkeit

B) einige km/s

C) einige m/s

D) einige mm pro Minute

### Zahlenbeispiel: Driftgeschwindigkeit im Kupferdraht

Kupfer, $A=1 \, \text{mm}^2$, $I=1 \, \text{A}$:

- Dichte freier Elektronen: $n \approx 8{,}5 \cdot 10^{28} \, \frac{1}{\text{m}^3}$
- Ladungsdichte: $\rho_Q = -n \cdot e \approx -1{,}36 \cdot 10^{10} \, \frac{\text{C}}{\text{m}^3}$
- Stromdichte: $|\vec{J}| = \frac{I}{A} = 1 \cdot 10^{6} \, \frac{\text{A}}{\text{m}^2}$
- Driftgeschwindigkeit: $|\vec{v}_d| = \frac{|\vec{J}|}{|\rho_Q|} \approx 7{,}35 \cdot 10^{-5} \, \frac{\text{m}}{\text{s}} \approx 0{,}26 \, \frac{\text{m}}{\text{h}}$ 🐌

Warum geht das Licht trotzdem sofort an? → Das *Feld* breitet sich (fast) mit Lichtgeschwindigkeit aus, nicht die Elektronen.

### Ohm’sches Gesetz (*Ohm’s law*)

- Für ein gegebenes Material ist die Stromdichte umso höher, je höher das elektrische Feld ist
- Der Proportionalitätsfaktor ist die elektrische **Leitfähigkeit** $\sigma$:

$$\vec{J} = \sigma \cdot \vec{E}$$

Achtung: die proportionale Beziehung gilt nur für *lineare Leiter* (z.B. Metalle bei konstanter Temperatur)

### Ohm’sches Gesetz im linearen Leiter

$$\vec{J} = \sigma \cdot \vec{E}$$

Leiter der Länge $l$, Querschnitt $A$, homogenes Feld wie im Kondensator ($U = E \cdot l$):

$$I = J \cdot A = \sigma \cdot E \cdot A = \sigma \cdot \frac{U}{l} \cdot A = \frac{U}{R}$$

**Elektrischer Widerstand** (*electric resistance*):

$$R = \frac{l}{\sigma \cdot A} = \rho \cdot \frac{l}{A}$$

mit dem **spezifischen Widerstand** $\rho = 1/\sigma$ (ab hier ist $\rho$ *immer* der spezifische Widerstand, nicht mehr die Ladungsdichte!)

![bg right:30% 90%](https://physikbuch.schule/media/resistivity-geometry.svg)

### Widerstand und Leitwert

Für jedes Bauteil ist der elektrische Widerstand $R$ das Verhältnis von Spannung zu Strom:

$$R = \frac{U}{I}, \qquad [R] = \frac{\text{V}}{\text{A}} = \Omega \ \text{(Ohm)}$$

Der elektrische Leitwert $G$ ist der Kehrwert des Widerstands:

$$G = \frac{1}{R} = \frac{I}{U}, \qquad [G] = \frac{\text{A}}{\text{V}} = \text{S} \ \text{(Siemens)}$$

![bg 90% right:38%](img/ohm-kennlinie.svg)

### Materialeigenschaften vs. Bauteilgrößen

**Materialeigenschaften** (unabhängig von der Geometrie):
- **Spezifischer Widerstand** $\rho$
- **Leitfähigkeit** $\sigma = \frac{1}{\rho}$

**Bauteilgrößen** (abhängig von der Geometrie):
- **Widerstand** $R = \rho \frac{l}{A}$
- **Leitwert** $G = \frac{1}{R} = \sigma \frac{A}{l}$

**Beispiel:** Kupfer hat immer die gleiche Leitfähigkeit $\sigma_{\text{Cu}} = 58 \, \text{MS/m}$, aber ein dickeres Kabel hat einen kleineren Widerstand $R$.

Wie beim Kondensator $C = \varepsilon A/d$: Material mal Geometrie.

![bg right:20% 100%](https://physikbuch.schule/media/resistivity-geometry.svg)

### 🗳️ Länger und dünner

Ein Draht hat den Widerstand $R$. Ein zweiter Draht aus demselben Material ist **doppelt so lang** und hat den **halben Durchmesser**.

Welchen Widerstand hat der zweite Draht?

A) $R$

B) $2R$

C) $4R$

D) $8R$

### Übersicht der Größen im linearen Leiter

Größe | Definition | Einheit | Name
--- | --- | --- | ---
Spannung (*voltage*) | $U = \Delta \varphi$ | $[U] = \text{V}$ | Volt
Stromstärke (*current*) | $I = \frac{\Delta Q}{\Delta t}$ | $[I] = \text{A}$ | Ampere
Widerstand (*resistance*) | $R = \frac{U}{I}$ | $[R] = \Omega$ | Ohm
Leitwert (*conductance*) | $G = \frac{1}{R}$ | $[G] = \text{S} = \frac{1}{\Omega}$ | Siemens
spezifischer Widerstand (*resistivity*) | $\rho = R \frac{A}{l}$ | $[\rho] = \Omega \cdot \text{m}$ | Ohm-Meter
Leitfähigkeit (*conductivity*) | $\sigma = \frac{1}{\rho}$ | $[\sigma] = \text{S/m}$ | Siemens pro Meter

Hinweis: In manchen Büchern heißt die Stromdichte $S$ statt $J$ – gemeint ist dasselbe.

### 📝 Aufgabe 6: Stromdichte & Widerstand

In einer Glühlampe (12 V, Kfz-Blinker) fließt ein Strom $I = 0{,}5 \, \text{A}$.

a) Wie groß ist die Stromdichte $J_1$ im Glühfaden ($d_1 = 100 \, \mu\text{m}$)?

b) Wie groß ist die Stromdichte $J_2$ in der Zuleitung ($d_2 = 1{,}5 \, \text{mm}$)?

c) Ein Kupferdraht hat die Länge $l = 5 \, \text{m}$ und den Querschnitt $A = 3 \, \text{mm}^2$ ($\rho_\text{Cu} = 1{,}79 \cdot 10^{-8} \, \Omega\text{m}$). Wie groß ist sein Widerstand $R$?

d) Welchen Widerstand hat ein Draht gleicher Abmessungen aus Aluminium ($\rho_\text{Al} = 2{,}6 \cdot 10^{-8} \, \Omega\text{m}$)?

### Temperaturabhängigkeit des Widerstands

Bei den meisten Materialien ändert sich der Widerstand mit der Temperatur.

Lineare Näherung:

$$R(T) = R(T_0) \cdot [1 + \alpha \cdot (T - T_0)]$$

- $\alpha$: Temperaturkoeffizient, $[\alpha] = \frac{1}{\text{K}}$
- $T_0$: Bezugstemperatur (üblicherweise 20 °C oder 0 °C)

![bg 90% right:38%](img/widerstand-temperatur.svg)

### Leitfähigkeit verschiedener Materialien

Bei Leitern nimmt der Widerstand mit steigender Temperatur zu ($\alpha > 0$).

Typische Werte bei 20 °C:

| Leitermaterial | $\rho$ (µΩ·m) | $\sigma$ (MS/m) | $\alpha$ (1/K) |
|----------------|---------------|-----------------|----------------|
| Silber         | 0,016         | 63              | 3,8 · 10⁻³     |
| Kupfer         | 0,017         | 58              | 3,9 · 10⁻³     |
| Aluminium      | 0,027         | 38              | 4,3 · 10⁻³     |
| Messing        | 0,062         | 16              | 2,0 · 10⁻³     |

### 🗳️ Warme Leitung

Eine Kupferleitung hat bei 20 °C den Widerstand $R$. Im Betrieb erwärmt sie sich auf 70 °C.

Um wie viel steigt ihr Widerstand?

A) etwa 0,2 %

B) etwa 2 %

C) etwa 20 %

D) etwa 200 %

### Metalle als Temperatursensoren

Die Temperaturabhängigkeit macht Metalle zu präzisen Temperatursensoren.

**Platin-Widerstandsthermometer (Pt100):**
- $R(0 \, °\text{C}) = 100 \, \Omega$
- $\alpha_{\text{Pt}} = 3{,}85 \cdot 10^{-3} \, \text{K}^{-1}$

**Vorteile:** hohe Langzeitstabilität, Messbereich −200 °C bis +850 °C, gute Linearität

Anwendung: aus gemessenem $R$ (oder $U$ bei bekanntem Strom) die Temperatur bestimmen (→ Woche 5).

![bg right:35% 90%](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Pt100_Resistors.jpg/1280px-Pt100_Resistors.jpg)

### Zwischenstand & Ausblick

- Strom = Ladungstransport; $I = dQ/dt$, Stromdichte $J = I/A$
- Die Elektronen kriechen, das Feld breitet sich fast mit Lichtgeschwindigkeit aus
- Ohm: $R = U/I = \rho \, l/A$ – Material ($\rho$) × Geometrie ($l/A$)
- $R(T)$: linear mit Temperaturkoeffizient $\alpha$ → Pt100-Sensor

**Nächste Woche:** Kirchhoff’sche Gesetze, Netzwerke und reale Quellen.
