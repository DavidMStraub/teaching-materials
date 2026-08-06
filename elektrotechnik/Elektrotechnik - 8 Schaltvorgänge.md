---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik – 8. Schaltvorgänge

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub

## 8. Schaltvorgänge

1. Grundidee: Energiespeicher und Stetigkeit
2. Schalten von Kapazitäten (RC-Kreis)
3. Schalten von Induktivitäten (RL-Kreis)
4. Das allgemeine Lösungsrezept

### Motivation: Zwischen den Welten

Bisher haben wir zwei „eingeschwungene" Zustände betrachtet:

- **Gleichstrom** (Kapitel 3–5): alles konstant
- **Wechselstrom** (Kapitel 6–7): alles sinusförmig

**Was passiert dazwischen — im Moment des Schaltens?**

- Kamerablitz: Kondensator lädt sekundenlang, entlädt in Millisekunden
- Zündspule im Auto: Abschalten einer Spule erzeugt den Zündfunken
- Abschaltfunke an Schaltern und Relais (gleich verstehen Sie, warum!)

### Grundidee: Energiespeicher können nicht springen

C und L speichern Energie — und Energie kann sich nicht sprunghaft ändern:

| Element | Energie | Stetige Größe | Folge |
|---|---|---|---|
| Kondensator | $W = \frac{1}{2} C u_C^2$ | **Spannung $u_C$** | $i_C$ darf springen |
| Spule | $W = \frac{1}{2} L i_L^2$ | **Strom $i_L$** | $u_L$ darf springen |

**Merksatz:** Kondensatorspannung und Spulenstrom sind **stetig** — sie behalten im Schaltmoment ihren Wert.

Der Übergang zum neuen Zustand erfolgt **exponentiell** mit der Zeitkonstante $\tau$.

### Einschalten: Aufladen eines Kondensators

Quelle $U_0$, Widerstand $R$, Kondensator $C$; Schalter schließt bei $t = 0$, Kondensator ungeladen.

**Maschengleichung** für $t > 0$:

$$U_0 = u_R + u_C = R\,C \cdot \frac{du_C}{dt} + u_C$$

Lösung dieser Differentialgleichung (Herleitung → Tafel):

$$\boxed{u_C(t) = U_0 \cdot \left(1 - e^{-t/\tau}\right), \qquad i_C(t) = \frac{U_0}{R} \cdot e^{-t/\tau}, \qquad \tau = R \cdot C}$$

- $u_C$ startet stetig bei $0$ und strebt gegen $U_0$
- $i_C$ **springt** auf $\frac{U_0}{R}$ (ungeladener Kondensator wirkt anfangs wie ein Kurzschluss!) und klingt auf $0$ ab

### Die Zeitkonstante τ

$$\tau = R \cdot C \qquad \left([\tau] = \Omega \cdot \text{F} = \text{s}\right)$$

- Anfangstangente trifft den Endwert genau bei $t = \tau$
- Nach $t = \tau$: 63 % des Endwerts erreicht
- Nach $t = 3\tau$: 95 % — nach $t = 5\tau$: über 99 % → **praktisch abgeschlossen**

Ablesen/Skizzieren in der Klausur: Anfangswert, Endwert, Tangente durch $\tau$!

![bg right:42% 95%](https://upload.wikimedia.org/wikipedia/commons/6/6d/Series_RC_capacitor_voltage_DE.svg)

### Ausschalten: Entladen eines Kondensators

Kondensator (geladen auf $U_0$) wird bei $t = 0$ über $R$ kurzgeschlossen:

$$0 = u_R + u_C \qquad\Rightarrow\qquad \boxed{u_C(t) = U_0 \cdot e^{-t/\tau}, \qquad i_C(t) = -\frac{U_0}{R} \cdot e^{-t/\tau}}$$

- $u_C$ startet stetig bei $U_0$, klingt auf $0$ ab
- Strom fließt **rückwärts** (negativ): der Kondensator gibt seine Energie ab
- Gleiche Zeitkonstante $\tau = RC$ — aber Achtung: beim Auf- und Entladen über **verschiedene Widerstände** ergeben sich verschiedene $\tau$!

### 📝 Jetzt sind Sie dran: Kondensator (zu zweit)

**Aufgabe 24**

a) Ein Kondensator $C = 0{,}1\,\mu\text{F}$ wird über $R = 5\,\Omega$ entladen. Nach welcher Zeit $t_x$ ist die Spannung auf 10 % des Anfangswerts gesunken? *(Tipp: nach $t_x$ auflösen — Logarithmus!)*

b) Der Datenspeicher eines Taschenrechners (ersatzweise: Lastwiderstand $R = 2{,}2\,\text{M}\Omega$) soll beim Batteriewechsel aus einem Kondensator gespeist werden. Batteriespannung $U_B = 3\,\text{V}$; die Spannung darf in $t_W = 30\,\text{s}$ nicht unter $U_\text{min} = 0{,}8\,\text{V}$ sinken. Dimensionieren Sie $C$.

### Einschalten einer Spule

Quelle $U_0$, Widerstand $R$, Spule $L$; Schalter schließt bei $t = 0$:

$$U_0 = u_R + u_L = R \cdot i_L + L \cdot \frac{di_L}{dt}$$

$$\boxed{i_L(t) = \frac{U_0}{R} \cdot \left(1 - e^{-t/\tau}\right), \qquad u_L(t) = U_0 \cdot e^{-t/\tau}, \qquad \tau = \frac{L}{R}}$$

- $i_L$ startet stetig bei $0$ und strebt gegen $\frac{U_0}{R}$ (Spule wirkt am Ende wie ein Kurzschluss — vgl. $\omega \to 0$ in Kapitel 6!)
- $u_L$ springt auf $U_0$ und klingt auf $0$ ab

**Spiegelbild zum Kondensator:** Rollen von $u$ und $i$ vertauscht.

### Ausschalten einer Spule

Stromdurchflossene Spule ($i_L = \frac{U_0}{R_S}$) wird bei $t = 0$ auf einen Widerstand $R$ geschaltet:

$$i_L(t) = i_L(0) \cdot e^{-t/\tau}, \qquad u_L(t) = -R \cdot i_L(0) \cdot e^{-t/\tau}, \qquad \tau = \frac{L}{R}$$

**⚡ Die entscheidende Konsequenz:** Der Spulenstrom *muss* stetig weiterfließen — die Spule erzwingt ihn mit jeder nötigen Spannung:

$$|u_L(0)| = R \cdot i_L(0)$$

Großes $R$ (oder offener Schalter, $R \to \infty$) → **Überspannung**, Lichtbogen am Schaltkontakt!

**Praxis:** Zündspule nutzt den Effekt; Freilaufdiode schützt Transistoren davor.

### Das allgemeine Lösungsrezept

**Jede** Schaltung mit einem Energiespeicher (ein C *oder* ein L) führt auf:

$$\boxed{x(t) = x_\infty + \left(x_0 - x_\infty\right) \cdot e^{-t/\tau}}$$

| Schritt | Wie? |
|---|---|
| Anfangswert $x_0$ | Stetigkeit: $u_C$ bzw. $i_L$ aus dem Zustand **vor** dem Schalten |
| Endwert $x_\infty$ | Gleichstrombild: C = Unterbrechung, L = Kurzschluss |
| Zeitkonstante $\tau$ | $\tau = R_\text{ers} C$ bzw. $\tau = L / R_\text{ers}$ — $R_\text{ers}$ von den Klemmen des Speichers aus gesehen (Quellen deaktiviert) |

Damit lassen sich alle Verläufe **ohne Differentialgleichung** hinschreiben und skizzieren.

### 📝 Jetzt sind Sie dran: Spule abschalten (zu zweit)

**Aufgabe 25** *(= Palme B7, Aufgabe 2)*

Eine Spule $L = 250\,\text{mH}$ mit Wicklungswiderstand $R_S = 5\,\Omega$ liegt an einer idealen Spannungsquelle $U_0 = 100\,\text{V}$. Zum Zeitpunkt $t = 0$ wird sie von der Quelle getrennt und auf einen Entladewiderstand $R = 50\,\Omega$ geschaltet.

a) Zeichnen Sie das Ersatzschaltbild (vor und nach dem Schalten).

b) Wie groß ist die in der Spule gespeicherte magnetische Energie $W_m$?

c) Berechnen Sie die maximal auftretende induzierte Spannung $U_\text{max}$. *(Überrascht vom Ergebnis? Vergleichen Sie mit $U_0$!)*

d) Skizzieren Sie Strom- und Spannungsverlauf an der Spule (Anfangswert, Endwert, $\tau$).

### Zusammenfassung: Schaltvorgänge

| | Kondensator (RC) | Spule (RL) |
|---|---|---|
| Stetige Größe | $u_C$ | $i_L$ |
| Zeitkonstante | $\tau = R\,C$ | $\tau = L/R$ |
| Einschalten | $u_C = U_0(1 - e^{-t/\tau})$ | $i_L = \frac{U_0}{R}(1 - e^{-t/\tau})$ |
| Ausschalten | $u_C = U_0 \, e^{-t/\tau}$ | $i_L = i_L(0) \, e^{-t/\tau}$ |
| Verhalten $t \to \infty$ | Unterbrechung | Kurzschluss |
| Gefahr | Einschaltstromstoß | Abschalt-Überspannung |

Universalformel: $x(t) = x_\infty + (x_0 - x_\infty) \cdot e^{-t/\tau}$ — nach $5\tau$ ist alles vorbei.
