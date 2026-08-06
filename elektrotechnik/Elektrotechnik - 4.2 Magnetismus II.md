---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 4. Magnetismus II

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 4. Magnetismus

1. Magnetisches Feld
2. Kräfte im magnetischen Feld
3. Magnetische Feldgrößen und Durchflutungsgesetz
4. Materie im Magnetfeld
5. Der magnetische Kreis
6. Kraft am Luftspalt

### Der magnetische Kreis

**Definition:** geschlossener Pfad aus ferromagnetischem Material, durch den magnetischer Fluss geführt wird.

**Relevant in vielen Anwendungen:**

- Elektromotoren, Generatoren
- Transformatoren
- Induktives Laden
- Sensoren, Aktuatoren, Relais

**Problem:** Wie dimensioniert man diese Systeme effizient?

![bg right:35% 100%](https://upload.wikimedia.org/wikipedia/commons/d/d0/Electromagnet_with_gap.svg)

### Herausforderung: Komplexe Magnetfelder

**Direkter Ansatz wäre kompliziert:** 3D-Feldberechnung, numerische Simulation (FEM)

**Eindimensionale Lösung: der magnetische Kreis** – eine *mathematische Analogie* zum elektrischen Stromkreis:

- Einfache Berechnungen wie bei Widerstandsnetzwerken
- Gute Näherung für viele praktische Fälle

**Voraussetzung:** magnetischer Fluss „fließt" hauptsächlich durch ferromagnetisches Material

![bg right:35% 100%](https://upload.wikimedia.org/wikipedia/commons/d/d0/Electromagnet_with_gap.svg)

### Grundidee

**Elektrischer Kreis:** Spannung treibt Strom durch Widerstand: $U = R \cdot I$

**Magnetischer Kreis:** Durchflutung treibt magnetischen Fluss durch magnetischen Widerstand:

$$\Theta = R_m \cdot \Phi$$

**Wichtig:** Diese Analogie ist *mathematisch*, nicht physikalisch – es „fließt" nichts. Aber sie macht Magnetkreise so einfach berechenbar wie Widerstandsnetzwerke.

### Herleitung des magnetischen Widerstands

Homogener Kreis (konstantes $A$, ein Material, Feld folgt dem Materialweg):

$$\Theta = \oint \vec{H} \cdot d\vec{s} = H \cdot \ell$$

Mit $\Phi = B \cdot A$ und $B = \mu_0 \mu_r H$ folgt $H = \frac{\Phi}{\mu_0 \mu_r A}$, also:

$$\Theta = \frac{\ell}{\mu_0 \mu_r A} \cdot \Phi \qquad\Rightarrow\qquad \boxed{\Theta = R_m \cdot \Phi, \quad R_m = \frac{\ell}{\mu_0 \mu_r A}}$$

Das ist das **„Ohmsche Gesetz" des magnetischen Kreises**!

$[R_m] = \frac{\text{A}}{\text{Wb}} = \frac{1}{\text{H}}$ — analog zu $R = \frac{\ell}{\sigma A}$

### Magnetischer Leitwert (Permeanz)

Analog zum elektrischen Leitwert $G = \frac{1}{R}$:

$$\Lambda = \frac{1}{R_m} = \frac{\mu_0 \mu_r A}{\ell}, \qquad [\Lambda] = \frac{\text{Wb}}{\text{A}} = \text{H} \ \text{(Henry)}$$

Alternative Formulierung: $\Phi = \Lambda \cdot \Theta$

Große Permeabilität $\mu_r$ → großer Leitwert → viel Fluss.

### Zusammenfassung: Die Analogie

| Elektrischer Kreis | Magnetischer Kreis |
|---|---|
| Spannung $U=\int \vec{E} \cdot d\vec{s}$ | Durchflutung $\Theta = \oint \vec{H} \cdot d\vec{s}$ |
| Stromstärke $I=\int \vec{J} \cdot d\vec{A}$ | Magnetischer Fluss $\Phi = \int \vec{B} \cdot d\vec{A}$ |
| Widerstand $R = \frac{\ell}{\sigma A}$ | Mag. Widerstand $R_m = \frac{\ell}{\mu_0 \mu_r A}$ |
| Leitwert $G = \frac{1}{R}$ | Mag. Leitwert $\Lambda = \frac{1}{R_m}$ |
| $U = R \cdot I$ | $\Theta = R_m \cdot \Phi$ |

### Reihen- und Parallelschaltung magnetischer Widerstände

**Reihenschaltung** (verschiedene Abschnitte im selben Flusspfad — Eisen, Luftspalt, …):

$$R_{m,\text{ges}} = R_{m,1} + R_{m,2} + \ldots$$

Der gleiche Fluss $\Phi$ durchfließt alle Abschnitte (wie der Strom in der Reihenschaltung).

**Parallelschaltung** (der Fluss verzweigt sich auf mehrere Schenkel):

$$\frac{1}{R_{m,\text{ges}}} = \frac{1}{R_{m,1}} + \frac{1}{R_{m,2}} + \ldots$$

Am Verzweigungspunkt gilt die „Knotenregel": $\sum_k \Phi_k = 0$ — auch **magnetische Ersatzschaltbilder** zeichnet man wie Stromkreise! *(Klausuraufgabe WS 2000/01: Kern mit drei Schenkeln)*

### Praxisbeispiel: Elektromagnet mit Luftspalt

**Typische Anwendung:** Schaltschütz, Relais, Hubmagnet

**Aufbau:**

- Eisenkern mit Spule ($N$ Windungen, Strom $I$)
- Luftspalt der Länge $\delta$, Eisenweg $\ell_E$, Querschnitt $A$

$$R_{m,\text{ges}} = \underbrace{\frac{\ell_E}{\mu_0 \mu_r A}}_{\text{Eisen}} + \underbrace{\frac{\delta}{\mu_0 A}}_{\text{Luftspalt}}, \qquad \Phi = \frac{N \cdot I}{R_{m,\text{ges}}}$$

![bg right:38% 100%](https://upload.wikimedia.org/wikipedia/commons/d/d0/Electromagnet_with_gap.svg)

### Die überraschende Dominanz des Luftspalts

**Zahlenwerte (typisch):** Eisenweg $\ell_E = 30$ cm, $\mu_r = 2000$; Luftspalt $\delta = 1$ mm

$$\frac{R_{m,L}}{R_{m,E}} = \frac{\delta \cdot \mu_r}{\ell_E} = \frac{0{,}001 \cdot 2000}{0{,}3} \approx 6{,}7$$

**Der Luftspalt ist 7× wichtiger, obwohl er 300× kürzer ist!**

**Praktische Näherung** für $\mu_r \gg 1$ und $\delta \mu_r \gg \ell_E$: Eisenwiderstand vernachlässigen, $R_{m,\text{ges}} \approx R_{m,L}$. In Klausuraufgaben oft als „$\mu_r \to \infty$" formuliert!

### Kraft am Luftspalt

Ein Elektromagnet zieht ferromagnetisches Material an. Die Kraft pro Polfläche:

$$\boxed{F = \frac{B^2 \cdot A}{2 \mu_0}}$$

- $B$: Flussdichte im Luftspalt, $A$: Polfläche
- Herleitung über die Energie des Magnetfelds → Kapitel 5
- ⚠️ Bei einem U-Kern gibt es **zwei** Polflächen → zwei Luftspalte, doppelte Kraft (bzw. halbe Kraft pro Fläche nötig)

**Typische Klausuraufgabe:** Hubmagnet/Bestückungsautomat dimensionieren – von der geforderten Kraft rückwärts zu $B$, $\Phi$ und $I$.

### 📝 Jetzt sind Sie dran: Elektromagnet dimensionieren (zu zweit)

**Aufgabe 13** *(= Klausuraufgabe WiSe 2018/19!)*

Ein Elektromagnet am Roboterarm soll Eisenblechtafeln ($F_g = 160 \, \text{N}$) anheben. U-förmiger Kern, Querschnitt $A = 8 \, \text{cm}^2$ pro Pol, Luftspalt $d = 0{,}5 \, \text{mm}$ pro Pol (Verschmutzung), $\mu_r \to \infty$, $N = 1000$ Windungen. Hinweis: normierter Luftspalt (1 mm, 1 cm²) hat $R_{m} = 8 \cdot 10^6 \, \text{H}^{-1}$; $F = \frac{B^2 A}{2\mu_0}$ mit $\mu_0 = 1{,}25 \cdot 10^{-6} \, \frac{\text{Vs}}{\text{Am}}$.

a) Skizzieren Sie das magnetische Ersatzschaltbild. Wie groß ist $R_{m,\text{ges}}$ (zwei Luftspalte!)?
b) Welche Kraft muss **pro Luftspalt** wirken? Welche Flussdichte $B_\text{min}$ ist dafür nötig?
c) Welcher Strom $I$ stellt die notwendige Kraft sicher?
d) Kann der Magnet auch Aluminiumplatten anheben? (Begründung!)

### Unsere Basiseinheiten-Tabelle wächst

| Elektrische Größe | Formelzeichen | Einheit | Basiseinheiten |
|---|---|---|---|
| Ladung | $Q$ | C | $\text{A} \cdot \text{s}$ |
| Spannung | $U$ | V | $\frac{\text{kg} \cdot \text{m}^2}{\text{A} \cdot \text{s}^3}$ |
| Kapazität | $C$ | F | $\frac{\text{A}^2 \cdot \text{s}^4}{\text{kg} \cdot \text{m}^2}$ |
| Widerstand | $R$ | Ω | $\frac{\text{kg} \cdot \text{m}^2}{\text{A}^2 \cdot \text{s}^3}$ |
| **Magn. Flussdichte** | $B$ | T | $\frac{\text{kg}}{\text{A} \cdot \text{s}^2}$ |
| **Magn. Fluss** | $\Phi$ | Wb | $\frac{\text{kg} \cdot \text{m}^2}{\text{A} \cdot \text{s}^2}$ |

Herleitung an der Tafel: $[B] = \frac{[F]}{[I] \cdot [\ell]}$, $[\Phi] = [B] \cdot [A]$

### Zusammenfassung: Magnetismus

- Magnetfelder entstehen durch bewegte Ladungen; Feldlinien sind **immer geschlossen**
- Kräfte: $\vec{F} = Q(\vec{v} \times \vec{B})$ bzw. $F = I \ell B$; Rechte-Hand-Regel
- Durchflutungsgesetz: $\Theta = NI = \oint \vec{H} \cdot d\vec{s}$; lange Spule: $H = NI/\ell$
- Materie: dia- ($\mu_r < 1$), para- ($\mu_r \gtrsim 1$), ferromagnetisch ($\mu_r \gg 1$, Hysterese!)
- **Magnetischer Kreis:** $\Theta = R_m \Phi$ mit $R_m = \frac{\ell}{\mu_0 \mu_r A}$ — rechnen wie im Stromkreis
- Der Luftspalt dominiert; Kraft am Luftspalt: $F = \frac{B^2 A}{2\mu_0}$

**Nächstes Kapitel:** Elektromagnetische Induktion – wie aus Bewegung Spannung wird ⚡
