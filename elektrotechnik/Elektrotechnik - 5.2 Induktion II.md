---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 5. Elektromagnetische Induktion II

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 5. Elektromagnetische Induktion

1. Induktionsgesetz
2. Selbstinduktion
3. Energie des magnetischen Feldes
4. Kräfte an Grenzflächen

### Von der Induktion zur Selbstinduktion

**Bisher:** Externes Magnetfeld induziert Spannung: $U_\text{ind} = -N \cdot \frac{d\Phi}{dt}$

**Jetzt:** Stromfluss durch Spule → eigenes Magnetfeld $\Phi \propto I$

Bei Stromänderung ändert sich auch $\Phi$ → Induktion **in derselben Spule**!

**Selbstinduktion:** Die Spule induziert eine Spannung in sich selbst.

![bg right:35% 80%](https://upload.wikimedia.org/wikipedia/commons/5/5b/Coil_right-hand_rule3.svg)

### Herleitung der Selbstinduktivität

**Ohmsches Gesetz des magnetischen Kreises:**

$$\Phi = \frac{\Theta}{R_m} = \frac{N \cdot I}{R_m}$$

Mit $U_\text{ind} = -N \cdot \frac{d\Phi}{dt}$ folgt:

$$U_\text{ind} = -\frac{N^2}{R_m} \cdot \frac{dI}{dt} = -L \cdot \frac{dI}{dt}$$

Proportionalitätskonstante $L$: **Induktivität** (Selbstinduktivität)

![bg right:35% 90%](https://upload.wikimedia.org/wikipedia/commons/d/d1/EisenkernOhneLuftspalt.svg)

### Vorzeichen: Klemmenspannung vs. induzierte Spannung

- **Induzierte Spannung** $U_\text{ind} = \oint \vec{E}_\text{ind} \cdot d\vec{r} = -\frac{d\Phi}{dt}$ (Umlaufintegral des Wirbelfelds)
- **Klemmenspannung** $U$: messbare Spannung zwischen den Anschlüssen

Das Ringintegral wird entgegen der Pfeilrichtung der Klemmenspannung durchlaufen → **Vorzeichenwechsel!**

**Vorzeichenkonvention (Verbraucherzählpfeilsystem):**

$$U = -U_\text{ind} = +L \cdot \frac{dI}{dt}$$

![bg right:25% 80%](https://upload.wikimedia.org/wikipedia/commons/3/30/Integration_Coil_modified.svg)

### Induktivität (*inductance*) einer Spule

$$L = \frac{N^2}{R_m} = N^2 \cdot \frac{\mu_0 \mu_r A}{\ell_E}$$

Einheit: $[L] = \frac{\text{Wb}}{\text{A}} = \text{H}$ (Henry)

**Zusammenhang zwischen Strom und Klemmenspannung:**

$$U = L \cdot \frac{dI}{dt}$$

Merkregel: $L$ verbindet den magnetischen Kreis ($R_m$) mit der Schaltung — **eine** Zahl fasst Geometrie, Material und Windungszahl zusammen.

### Induktivität bei ferromagnetischen Materialien

$$L = \frac{N^2}{R_m} = N^2 \cdot \frac{\mu_0 \mu_r A}{\ell_E}$$

- $\mu_r$ ist abhängig von $I$ (Hysterese, Sättigung!) → $L$ ist nicht konstant
- Effekt wird reduziert durch eine Spule mit **Luftspalt**:

$$L = N^2 \cdot \frac{\mu_0 A}{\frac{\ell_E}{\mu_r} + \delta} \approx N^2 \cdot \frac{\mu_0 A}{\delta}$$

→ $\mu_r$ hat kaum Einfluss auf $L$ bei kleinem Luftspalt $\delta$

**Klausurfrage (WiSe 2018/19):** „Warum wird $L$ auch für $\delta \to 0$ nicht beliebig groß?" → weil der Eisenweg mit endlichem $\mu_r$ bleibt (und das Eisen sättigt).

### Reihenschaltung von Induktivitäten

$$L_{\text{ges}} = L_1 + L_2 + \dots + L_n = \sum_i L_i$$

Die induzierten Spannungen addieren sich, der Strom ist überall gleich.

Intuition: Spulen verhalten sich wie eine einzige große Spule.

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/f/ff/Inductors_in_series.svg)

### Parallelschaltung von Induktivitäten

$$\frac{1}{L_{\text{ges}}} = \frac{1}{L_1} + \frac{1}{L_2} + \dots + \frac{1}{L_n}$$

Die Spannung ist überall gleich, die Ströme teilen sich auf.

Herleitung wie bei der Parallelschaltung von Widerständen: $\frac{U}{L_\text{ges}} = \frac{dI_\text{ges}}{dt} = \sum_i \frac{dI_i}{dt} = \sum_i \frac{U}{L_i}$

**Gleiche Regeln wie bei Widerständen** (und *umgekehrt* zu Kondensatoren!)

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/e/e8/Inductors_in_parallel.svg)

### 📝 Jetzt sind Sie dran: Drosselspule (zu zweit)

**Aufgabe 15** *(= Palme B4, Aufgabe 2 — die komplette Kette!)*

Eine Drosselspule besteht aus einem Ringkern ($\mu_r = 4000$, $\ell_\text{Fe} = 20 \, \text{cm}$, $A = 4 \, \text{cm}^2$) mit Luftspalt $\ell_L = 0{,}5 \, \text{mm}$. Wicklung: $N = 50$, $I = 2 \, \text{A}$.

a) Berechnen Sie $R_{m,\text{Fe}}$ und $R_{m,L}$. Wer dominiert?
b) Wie groß ist der magnetische Fluss $\Phi$?
c) Wie groß sind $B$ (überall gleich!) sowie $H$ im Eisen und im Luftspalt?
d) Wie groß ist die Induktivität $L$ der Spule?

### Energiebilanz einer RL-Schaltung

**Maschengleichung:**

$$U_0 = U_R + U_L = I \cdot R + L \cdot \frac{dI}{dt}$$

**Energie:** $dW = U_0 \cdot I \cdot dt = \underbrace{I^2 R \, dt}_{\text{Wärme}} + \underbrace{L \, I \, dI}_{\text{Magnetfeld}}$

**Gespeicherte Energie in einer Induktivität:**

$$W_m = \int_0^I L \, I' \, dI' = \frac{1}{2} L I^2$$

![bg right:30% 90%](https://upload.wikimedia.org/wikipedia/commons/0/0e/RLCircuitWithSwitch.svg)

### Energiedichte des Magnetfeldes

Falls $L$ nicht bekannt oder nicht konstant ist:

$$W_m = \frac{1}{2} H B \cdot V = \frac{1}{2} \frac{B^2}{\mu_0 \mu_r} \cdot V$$

**Energiedichte** (Energie pro Volumen):

$$w_m = \frac{1}{2} H B$$

Vergleiche Kondensator: $W = \frac{1}{2} C U^2$, $w_e = \frac{1}{2} E D$ — die Struktur ist identisch!

### Kräfte an Grenzflächen: Herleitung

Eisenjoch mit Luftspalt (Fläche $A$): Vergrößert man den Spalt um $d\ell$, entsteht neues Feldvolumen $A \cdot d\ell$ mit Energiedichte $\frac{B^2}{2\mu_0}$:

$$dW = \frac{B^2}{2 \mu_0} \cdot A \cdot d\ell$$

Mit $dW = F \cdot d\ell$ folgt die Kraft am einzelnen Luftspalt:

$$\boxed{F = \frac{B^2 A}{2 \mu_0}}$$

Damit ist die Formel aus Kapitel 4 (Elektromagnet!) hergeleitet. ✓

### Maxwell’sche Zugspannung

**Mechanische Spannung** (Kraft pro Fläche) an der Grenzfläche:

$$\sigma = \frac{F}{A} = \frac{B^2}{2 \mu_0}$$

**Anwendungen:**

- Hubmagnete (Kräne, Bestückungsautomaten)
- Elektromagnetische Relais und Schütze
- Magnetische Verriegelungen

Zahlengefühl: bei $B = 1 \, \text{T}$ ist $\sigma \approx 40 \, \frac{\text{N}}{\text{cm}^2}$ — 1 cm² trägt 4 kg!

### 📝 Jetzt sind Sie dran: Induktivität & Schalten (zu zweit)

**Aufgabe 16** *(Fortsetzung des Bestückungsautomaten aus Kapitel 4)*

Der Elektromagnet hat $N = 1000$ Windungen und $R_{m,\text{ges}} = 10^6 \, \text{H}^{-1}$; Betriebsstrom $I = 0{,}4 \, \text{A}$.

a) Welche Induktivität $L$ hat die Spule?
b) Beim Einschalten steigt der Strom konstant mit $0{,}5 \, \frac{\text{A}}{\text{ms}}$. Welche Spannung liegt dabei an der Induktivität?
c) Welche Energie ist im Magnetfeld gespeichert, wenn der Betriebsstrom erreicht ist?
d) An der Spule wird ein rechteckförmiger Spannungsverlauf angelegt ($+U_1$ für $t_1$, dann $0$). Skizzieren Sie den Stromverlauf $i(t)$!

### Unsere Basiseinheiten-Tabelle wächst

| Elektrische Größe | Formelzeichen | Einheit | Basiseinheiten |
|---|---|---|---|
| Ladung | $Q$ | C | $\text{A} \cdot \text{s}$ |
| Spannung | $U$ | V | $\frac{\text{kg} \cdot \text{m}^2}{\text{A} \cdot \text{s}^3}$ |
| Kapazität | $C$ | F | $\frac{\text{A}^2 \cdot \text{s}^4}{\text{kg} \cdot \text{m}^2}$ |
| Widerstand | $R$ | Ω | $\frac{\text{kg} \cdot \text{m}^2}{\text{A}^2 \cdot \text{s}^3}$ |
| Magn. Flussdichte | $B$ | T | $\frac{\text{kg}}{\text{A} \cdot \text{s}^2}$ |
| **Induktivität** | $L$ | H | $\frac{\text{kg} \cdot \text{m}^2}{\text{A}^2 \cdot \text{s}^2}$ |

Herleitung an der Tafel: $[L] = \frac{[U] \cdot [t]}{[I]}$ — **damit ist die Klausur-Tabelle komplett!**

### Zusammenfassung: Elektromagnetische Induktion

- Induktionsgesetz: $U = -N \frac{d\Phi}{dt}$ — Bewegungs- und Ruheinduktion
- Lenz: induzierter Strom wirkt seiner Ursache entgegen (Energieerhaltung)
- $u(t)$-Skizzen: $u$ ist die (negative) **Steigung** von $\Phi(t)$
- Selbstinduktion: $L = \frac{N^2}{R_m}$; $U = L \frac{dI}{dt}$; Reihe/parallel wie Widerstände
- Energie: $W_m = \frac{1}{2} L I^2$; Energiedichte $w_m = \frac{1}{2} H B$
- Kraft am Luftspalt: $F = \frac{B^2 A}{2\mu_0}$ (jetzt hergeleitet!)

**Nächstes Kapitel:** Wechselstrom – die komplexe Rechnung, das wichtigste Werkzeug des Semesters ⚡
