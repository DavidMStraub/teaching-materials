---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 5. Elektromagnetische Induktion I

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 5. Elektromagnetische Induktion

1. Induktionsgesetz
2. Selbstinduktion
3. Energie des magnetischen Feldes
4. Kräfte an Grenzflächen

### Grundprinzip

- Bisher: elektrisches Feld ruhender Ladungen (Elektrostatik) und magnetisches Feld konstanter Ströme (Magnetostatik)
- Sobald zeitliche Änderungen auftreten → Wechselwirkung zwischen elektrischen und magnetischen Feldern

**Induktion: ein zeitlich veränderliches Magnetfeld erzeugt („induziert") ein elektrisches Feld**

### Induktion: technische Anwendungen

- Generatoren (Energieerzeugung)
- Transformatoren (Spannungswandlung)
- Elektromotoren, Rekuperation bei E-Fahrzeugen
- Induktive Ladesysteme (Smartphones, E-Autos)
- Sensoren (z.B. induktive Näherungsschalter)
- Induktionsherd
- Wirbelstrombremsen

### Bewegung eines Leiterstücks im Magnetfeld

Lorentzkraft: $\vec{F}_m = q \cdot (\vec{v} \times \vec{B})$

Kraft durch elektrische Feldstärke: $\vec{F}_e = q \cdot \vec{E}$

Kräftegleichgewicht: $\vec{F}_e + \vec{F}_m = 0 \Longrightarrow \vec{E} = -\,\vec{v} \times \vec{B}$

Spannung an den Leiterenden: mit $U = \vec{E} \cdot \vec{\ell}$ folgt:

$$U_\text{ind} = -\,(\vec{v} \times \vec{B}) \cdot \vec{\ell}$$

**Induzierte Spannung durch Bewegung im Magnetfeld**

![bg right:40% 100%](https://upload.wikimedia.org/wikipedia/commons/8/8f/Induction-by-motion-voltage.svg)

### Das Induktionsgesetz in allgemeiner Form

**Bewegtes Leiterstück** ($\vec{v}$, $\vec{B}$, $\vec{\ell}$ senkrecht zueinander):

$$U_\text{ind} = -B \cdot \ell \cdot v = -B \cdot \frac{dA}{dt}$$

**Allgemein gilt:**

$$U = -\frac{d\Phi}{dt}$$

Übergang auf $N$ Windungen:

$$U = -N \cdot \frac{d\Phi}{dt}$$

### Zwei Möglichkeiten der Induktion

1. **Bewegungsinduktion:** Leiter und Magnetfeld bewegen sich relativ zueinander
2. **Ruheinduktion:** Magnetischer Fluss ändert sich bei ruhendem Leiter

$$U = -\frac{d\Phi}{dt} = -\frac{d(A \cdot B)}{dt} = -\frac{dB}{dt} \cdot A - \frac{dA}{dt} \cdot B$$

### Induzierter Strom

Verbindet man die Enden des Leiterstücks über einen Widerstand $R$ (der sich nicht mitbewegt), so fließt ein **induzierter Strom**:

$$I = \frac{U}{R} = -\frac{1}{R} \cdot \frac{d\Phi}{dt}$$

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/3/3d/Induction-by-motion-current.svg)

### Die Lenz’sche Regel

Die induzierte Spannung ist stets so gerichtet, dass ein durch sie hervorgerufener Strom **der Ursache seiner Entstehung entgegenwirkt**.

**Erklärung:** die Energie, die am Widerstand in Wärme umgesetzt wird, stammt aus der mechanischen Arbeit, die aufgewendet werden muss, um die Flussänderung zu erzeugen – die Lenz’sche Regel ist Ausdruck der **Energieerhaltung**.

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/4/42/Induction-by-motion-lenzs-law.svg)

### Das induzierte elektrische Wirbelfeld

**Wichtige Erkenntnis:** Bei Induktion ist die Spannung $U_\text{ind}$ **keine Potentialdifferenz**!

- Das zeitlich veränderliche Magnetfeld erzeugt ein elektrisches **Wirbelfeld**
- Dieses Feld ist **nicht konservativ** – es existiert kein Potential

$$U_\text{ind} = \oint \vec{E}_\text{ind} \cdot d\vec{s} \neq 0$$

Ein Umlaufintegral entlang der Leiterschleife – über einen **geschlossenen** Weg!

### Vergleich: Elektrostatik vs. Induktion

**Elektrostatik:** wirbelfrei, konservativ, Potential existiert:

$$\oint \vec{E}_\text{stat} \cdot d\vec{s} = 0$$

**Elektromagnetische Induktion:** das induzierte Feld ist nicht wirbelfrei:

$$\oint \vec{E}_\text{ind} \cdot d\vec{s} = -\frac{d\Phi}{dt} = -\frac{d}{dt} \int \vec{B} \cdot d\vec{A}$$

Dies ist das **Faraday’sche Induktionsgesetz**.

### Die fundamentalen Integralgleichungen der Elektrodynamik

| **Größe** | **Elektro-/Magnetostatik** | **Elektrodynamik** |
|-----------|-------------------|-------------------|
| $\vec{D}$ | $\oint_A \vec{D} \cdot d\vec{A} = Q$ | $\oint_A \vec{D} \cdot d\vec{A} = Q$ |
| $\vec{E}$ | $\oint_s \vec{E} \cdot d\vec{s} = 0$ | $\oint_s \vec{E} \cdot d\vec{s} = -\frac{d\Phi}{dt}$ **(Induktionsgesetz)** |
| $\vec{B}$ | $\oint_A \vec{B} \cdot d\vec{A} = 0$ | $\oint_A \vec{B} \cdot d\vec{A} = 0$ |
| $\vec{H}$ | $\oint_s \vec{H} \cdot d\vec{s} = I$ | (hier nicht behandelt) |

**Fazit:** Zeitlich veränderliche Felder koppeln elektrische und magnetische Phänomene!

### Beispiel: Bewegte Leiterschleife im Magnetfeld

Rechteckige Leiterschleife bewegt sich mit $\vec{v}$ durch ein homogenes, räumlich begrenztes Magnetfeld:

- **Eintreten:** zunehmender Fluss → $U_\text{ind} \neq 0$
- **Vollständig im Feld:** konstanter Fluss → keine Induktion!
- **Austreten:** abnehmender Fluss → $U_\text{ind} \neq 0$ (umgekehrtes Vorzeichen)

**Klausur-Klassiker:** Verläufe $\Phi(t)$ und $u(t)$ qualitativ skizzieren — $u(t)$ ist die (negative) *Steigung* von $\Phi(t)$!

### 📝 Jetzt sind Sie dran: Induktion (zu zweit)

**Aufgabe 14** *(= Klausuraufgabe SoSe 2019, Aufgabe 1.2!)*

Im Luftspalt eines Ferritkerns (Querschnitt $A_1 = 4 \, \text{cm}^2$) sitzt eine bewegliche Messspule ($N_2 = 10$ Windungen, Fläche $A_2 = 1 \, \text{cm}^2$). Das Feld erzeugt eine feste Spule mit $N_1 = 2000$ Windungen; $R_{m,\text{ges}} = 10^7 \, \text{H}^{-1}$. Ab $t = 0$ wird die Messspule mit konstanter Geschwindigkeit herausgezogen; nach $0{,}1 \, \text{s}$ ist sie vollständig draußen.

a) Skizzieren Sie qualitativ $\Phi_2(t)$ durch die Messspule und die induzierte Spannung $u(t)$.
b) Welcher Fluss $\Phi_2$ durchsetzt die Spule anfangs, damit $U_\text{ind} = 10 \, \text{mV}$ beträgt?
c) Welche Flussdichte $B$ herrscht dann im Luftspalt, und welcher Gesamtfluss $\Phi_1$ durchsetzt die feste Spule ($A_1$)?
d) Welcher Strom $I$ muss durch die feste Spule fließen?
