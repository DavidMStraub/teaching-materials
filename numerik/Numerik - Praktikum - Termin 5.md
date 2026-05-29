---
marp: true
theme: hm
paginate: true
language: de
footer: Numerik/Praktikum – D. Straub
headingDivider: 3
math: katex
---

# Numerik – Praktikum

**Ingenieurinformatik Teil 2, Sommersemester 2026**

David Straub


### Termin 5: Differentialgleichungen

**Thema:** Numerische Lösung von DGLn mit `ode45`

**Lernziele:**
- Ein physikalisches System als DGL in Standardform aufstellen
- `ode45` in MATLAB aufrufen und Ergebnisse interpretieren
- Verschiedene Szenarien durch Änderung der rechten Seite $f(t, \boldsymbol{z})$ untersuchen


## Aufgabe: Bremsanlage eines Mountainbikes


### Szenario

Ein Mountainbiker fährt eine lange Abfahrt hinunter.

- Konstante Hangneigung: $\alpha = 10°$
- Er bremst mit der Scheibenbremse, um die Geschwindigkeit zu kontrollieren
- Die Bremsscheibe erwärmt sich durch Reibung
- Kühlung durch den Fahrtwind – je schneller, desto besser

**Frage:** Wann überhitzt die Bremse – bei konstantem Bremsen oder bei intervallartiger Bremsung?

![bg right:35% 90%](assets/mountainbike_bremse.png)


### Physikalisches Modell: Bewegungsgleichung

Newton entlang der Hangrichtung ($x$ = zurückgelegte Strecke):

$$m\,\ddot{x} = mg\sin\alpha - F_\text{Brems} - c_w\,\dot{x}^2$$

| Größe | Bedeutung | Wert |
|-------|-----------|------|
| $m$ | Masse Fahrer + Rad | $90\,\text{kg}$ |
| $\alpha$ | Hangneigung | $10°$ |
| $c_w$ | Luftwiderstandskoeffizient | $0{,}5\,\text{kg/m}$ |
| $F_\text{Brems}$ | Bremskraft | variabel |


### Physikalisches Modell: Wärmebilanz

Wärme in der Bremsscheibe ($T$ = Scheibentemperatur):

$$C_\text{th}\,\dot{T} = \underbrace{F_\text{Brems} \cdot \dot{x}}_{\text{Reibungsleistung}} - \underbrace{(\lambda_0 + \lambda_1\,\dot{x})\,(T - T_\infty)}_{\text{Kühlung durch Fahrtwind}}$$

| Größe | Bedeutung | Wert |
|-------|-----------|------|
| $C_\text{th}$ | Wärmekapazität Bremsscheibe | $150\,\text{J/K}$ |
| $\lambda_0$ | Grundkühlung (Stillstand) | $2\,\text{W/K}$ |
| $\lambda_1$ | Fahrtwindkühlung | $0{,}5\,\text{W\,s/(K\,m)}$ |
| $T_\infty$ | Umgebungstemperatur | $20\,°\text{C}$ |
| $T_\text{max}$ | Grenztemperatur Bremsscheibe | $300\,°\text{C}$ |


### Aufgabe 1 – Standardform

Schreiben Sie das Gleichungssystem in die Standardform

$$\dot{\boldsymbol{z}} = f(t,\, \boldsymbol{z}), \qquad \boldsymbol{z}(t_0) = \boldsymbol{z}_0$$

**a)** Welche Größen enthält der Zustandsvektor $\boldsymbol{z}$? Wie viele Komponenten hat er?
*Hinweis: Die Bewegungsgleichung ist 2. Ordnung.*

**b)** Geben Sie $f(t, \boldsymbol{z})$ explizit an. Drücken Sie alles durch die Komponenten von $\boldsymbol{z}$ aus.

**c)** Geben Sie den Anfangszustandsvektor $\boldsymbol{z}_0$ an. Der Fahrer startet aus dem Stillstand bei Umgebungstemperatur.


### Aufgabe 2 – Konstantes Bremsen

Bremskraft: $F_\text{Brems} = 150\,\text{N}$ (konstant)

**a)** Lösen Sie das System mit `ode45` für $t \in [0,\, 120\,\text{s}]$.

**b)** Plotten Sie $\dot{x}(t)$ und $T(t)$ in zwei Subplots. Zeichnen Sie $T_\text{max}$ als horizontale Linie ein.

**c)** Welche Gleichgewichtsgeschwindigkeit stellt sich ein?
Überprüfen Sie das Ergebnis rechnerisch: Was gilt im eingeschwungenen Zustand für $\ddot{x}$?


### Aufgabe 3 – Intervallartiges Bremsen

Nun bremst der Fahrer abwechselnd: 10 Sekunden bremsen, 10 Sekunden frei.
Die mittlere Bremskraft soll dieselbe sein wie in Aufgabe 2.

**a)** Wie groß muss $F_\text{Brems}$ während der Bremsintervalle sein?

**b)** Passen Sie $f(t, \boldsymbol{z})$ an – $F_\text{Brems}$ wird jetzt zeitabhängig.

**c)** Lösen Sie erneut mit `ode45` und stellen Sie beide $T(t)$-Kurven in einem gemeinsamen Plot dar.

**d)** Wann überhitzt die Bremse schneller – und warum?
