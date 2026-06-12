---
marp: true
theme: hm
paginate: true
language: de
footer: Numerik – D. Straub
headingDivider: 3
math: katex
jupyter:
  jupytext:
    cell_metadata_filter: -all
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.17.3
  kernelspec:
    display_name: Matlab Kernel
    language: matlab
    name: jupyter_matlab_kernel
---

# Numerik

**Ingenieurinformatik Teil 2, Sommersemester 2026**

David Straub


### Gliederung

1. Einführung in Matlab
2. Arbeiten mit Arrays
3. Funktionen und Kontrollstrukturen
4. Analysis
5. Lineare Algebra
6. **Differentialgleichungen** 👈
7. Einführung in Simulink


### Fahrplan: Differentialgleichungen

**Einheit 1 – Heute**
→ Motivation und Herleitung am Ingenieurbeispiel
→ Begriffe: Ordnung, Anfangswertproblem
→ Analytische vs. numerische Lösung
→ Euler'sches Polygonzugverfahren in Matlab

**Einheit 2**
→ Standardform für numerische Verfahren
→ Numerische Lösungsverfahren
→ Lösung in Matlab

**Einheit 3**
→ Anwendungen


## Motivation


### Schnellladen einer Batteriezelle

Beim Schnellladen steigt die Temperatur – aber wie schnell, und wie hoch?

Wärmeleistung durch Innenwiderstand:

$$P_\text{Verlust} = I^2 \cdot R_\text{innen}$$

| Größe | Wert |
|-------|------|
| $C_\text{th}$ (Wärmekapazität) | $100\,\text{J/K}$ |
| $R_\text{innen}$ | $0{,}05\,\Omega$ |
| $I$ | $50\,\text{A}$ → $P = 125\,\text{W}$ |
| $T_0$ | $25\,°\text{C}$ |


### Fall 1: Konstanter Strom, keine Wärmeabgabe

Die gesamte Verlustleistung heizt die Zelle auf:

$$C_\text{th}\,\dot{T} = P_\text{Verlust} = \text{const}$$

$\dot{T}$ ist konstant → direktes Integral:

$$T(t) = T_0 + \frac{P_\text{Verlust}}{C_\text{th}}\,t$$

Mit den Zahlenwerten: $T$ steigt um $1{,}25\,\text{K/s}$ – nach 60 s bereits $+75\,\text{K}$.

Realistisch?


### Fall 2: Variabler Strom $I(t)$

Ein reales Ladeprofil: $I(t)$ ist nicht konstant.

$$C_\text{th}\,\dot{T} = P(t) = I(t)^2 \cdot R$$

$P(t)$ ist nun eine gemessene Kurve → $T(t) = T_0 + \dfrac{1}{C_\text{th}} \int_0^t P(\tau)\,d\tau$

Das kennen wir: **numerisch mit `trapz`**.

```matlab
T_end = T0 + trapz(t, P) / C_th
```

Aber: wir erhalten nur den Endwert oder müssen $T(t)$ mühsam schrittweise berechnen.

Und noch etwas fehlt…


### Fall 3: Wärmeabgabe dazu

Die Zelle gibt Wärme an die Umgebung ab:

$$P_\text{ab} = \lambda\,(T - T_\infty)$$

Energiebilanz: ein $-$ aus:

$$C_\text{th}\,\dot{T} = P_\text{Verlust} - \lambda\,(T - T_\infty)$$

**Problem:** $P_\text{ab}$ hängt von $T(t)$ selbst ab – der Wert den wir suchen!

$$\int \ldots\,dt \quad \text{geht nicht mehr}$$

Wir brauchen etwas Neues: eine **Differentialgleichung**.


### Die Differentialgleichung der Batteriezelle

$$\boxed{C_\text{th}\,\dot{T} = P - \lambda\,(T - T_\infty)}$$

| Größe | Bedeutung | Wert |
|-------|-----------|------|
| $C_\text{th}$ | Wärmekapazität | $100\,\text{J/K}$ |
| $\lambda$ | Wärmeübergangskoeffizient | $2\,\text{W/K}$ |
| $P = I^2 R$ | Verlustleistung | $125\,\text{W}$ |
| $T_\infty$ | Umgebungstemperatur | $25\,°\text{C}$ |
| $T_0$ | Starttemperatur | $25\,°\text{C}$ |


### Gleichung vs. Differentialgleichung

**Algebraische Gleichung** – Lösung ist eine **Zahl**:

$$2x^2 - 3 = 0 \quad \Rightarrow \quad x = \pm\sqrt{1{,}5}$$

**Differentialgleichung** – Lösung ist eine **Funktion**:

$$C_\text{th}\,\dot{T} = P - \lambda\,(T - T_\infty) \quad \Rightarrow \quad T(t) = \,?$$

Die gesuchte Funktion $T(t)$ muss die Gleichung für **alle** $t$ erfüllen.


## Analytische Lösung


### Analytische Lösung: Ansatz

Die Batterie-DGL lässt sich umschreiben:

$$\dot{T} = -\frac{\lambda}{C_\text{th}}\,T + \frac{P + \lambda T_\infty}{C_\text{th}}$$

Ansatz: $\quad T(t) = A + B\,e^{\alpha t}$

Einsetzen liefert $\alpha = -\dfrac{\lambda}{C_\text{th}}$ und die Konstante $A$ aus dem Gleichgewicht.

Mit Anfangsbedingung $T(0) = T_0$:

$$T(t) = T_\infty + \frac{P}{\lambda} + \left(T_0 - T_\infty - \frac{P}{\lambda}\right) e^{-\frac{\lambda}{C_\text{th}}\,t}$$


### Gleichgewichtstemperatur

Für $t \to \infty$ ändert sich $T$ nicht mehr: $\quad \dot{T} = 0$

$$0 = P - \lambda\,(T^* - T_\infty) \quad \Rightarrow \quad T^* = T_\infty + \frac{P}{\lambda}$$

Mit den Tabellenwerten:

$$T^* = 25 + \frac{125}{2} = 87{,}5\,°\text{C}$$

Knapp unter der typischen Grenztemperatur – bei doppeltem Strom wäre $T^* = 150\,°\text{C}$.


### ✍️ Aufgabe: Analytische Lösung plotten

Plotten Sie die analytische Lösung der Batterie-DGL:

$$T(t) = T_\infty + \frac{P}{\lambda} + \left(T_0 - T_\infty - \frac{P}{\lambda}\right) e^{-\frac{\lambda}{C_\text{th}}\,t}$$

Verwenden Sie die Parameterwerte aus der Tabelle. Plotten Sie außerdem:

- die Gleichgewichtstemperatur $T^*$ als horizontale Linie
- die Lösung für $C_\text{th} = 50$ und $C_\text{th} = 200$ (sonst gleiche Parameter)

Was beobachten Sie?


## Begriffe


### Ordnung einer Differentialgleichung

Die **Ordnung** ist die höchste vorkommende Ableitung.

| Gleichung | Ordnung |
|-----------|---------|
| $\dot{T} = P - \lambda(T-T_\infty)$ | 1 |
| $m\ddot{x} + kx = 0$ | 2 |
| $EI\, x'''' = q(x)$ | 4 |

Bei einer DGL $n$-ter Ordnung sind **$n$ Anfangsbedingungen** nötig, um die Lösung eindeutig festzulegen.


### Anfangswertproblem

**Anfangswertproblem (AWP):** Alle Bedingungen sind zum selben Zeitpunkt $t_0$ gegeben.

$$C_\text{th}\,\dot{T} = P - \lambda(T-T_\infty), \qquad T(0) = T_0$$

$$m\ddot{x} + kx = 0, \qquad x(0) = x_0,\quad \dot{x}(0) = v_0$$

**Randwertproblem:** Bedingungen an verschiedenen Stellen (z.B. Balken mit festen Enden) – kommt hier nicht vor.


### Gewöhnliche vs. partielle DGL

**Gewöhnliche DGL (ODE):** eine unabhängige Variable

$$C_\text{th}\,\dot{T}(t) = \ldots$$

**Partielle DGL (PDE):** mehrere unabhängige Variablen

$$\rho c\,\frac{\partial T}{\partial t}(x,y,z,t) = \lambda\,\nabla^2 T$$

→ Wärmeleitung *innerhalb* eines Körpers: Temperatur hängt von Ort **und** Zeit ab.

In dieser Vorlesung behandeln wir ausschließlich **ODEs**.


## Numerische Lösung


### Wann versagt die analytische Lösung?

Die Batterie-DGL mit konstantem Strom ist analytisch lösbar.

Was aber, wenn der **Ladestrom zeitveränderlich** ist – z.B. ein gemessenes Ladeprofil $I(t)$?

$$C_\text{th}\,\dot{T} = I(t)^2 \cdot R - \lambda\,(T - T_\infty)$$

→ Keine geschlossene analytische Lösung mehr möglich.

**Numerische Methoden** liefern stattdessen eine Näherungslösung als Zahlenfolge:

$$t_0,\, t_1,\, t_2,\, \ldots \quad \longrightarrow \quad T_0,\, T_1,\, T_2,\, \ldots$$


### Euler'sches Polygonzugverfahren

**Idee:** Die Ableitung $\dot{T}$ ist bekannt – sie steht auf der rechten Seite der DGL.

Ersetze die Ableitung durch einen Differenzenquotienten:

$$\dot{T} \approx \frac{T(t + \Delta t) - T(t)}{\Delta t}$$

Umgestellt: der nächste Wert ergibt sich aus dem aktuellen:

$$T(t + \Delta t) = T(t) + \underbrace{\dot{T}(t)}_{\text{rechte Seite}} \cdot \Delta t$$

In Matlab: `T(n+1) = T(n) + dT_dt * dt`


### Euler'sches Polygonzugverfahren in Matlab: Schema

Anfangswertproblem: $\quad \dot{y} = f(t, y), \quad y(t_0) = y_0$

$$y_{n+1} = y_n + f(t_n,\, y_n) \cdot \Delta t$$

```
t = t0 : dt : tend
y = zeros(size(t))
y(1) = y0

for n = 1 : length(t)-1
    dy_dt  = f( t(n), y(n) )      % rechte Seite auswerten
    y(n+1) = y(n) + dy_dt * dt   % Euler-Schritt
end
```


### ✍️ Aufgabe: Euler-Verfahren

Implementieren Sie das Euler-Verfahren für die Batterie-DGL. Wie lautet $f(t, y)$ in diesem Fall?

**(a)** Vergleichen Sie die numerische Lösung mit der analytischen in einem Plot.

**(b)** Variieren Sie die Schrittweite `dt`: $10\,\text{s}$, $100\,\text{s}$, $500\,\text{s}$.
Was passiert mit der Genauigkeit?

**(c)** Ersetzen Sie $P$ durch ein abklingendes Ladeprofil:
$$I(t) = I_0\,e^{-t/\tau}, \quad P(t) = R\cdot I(t)^2$$
mit $I_0 = 50\,\text{A}$, $\tau = 1800\,\text{s}$, $R = 0{,}05\,\Omega$.
Vergleichen Sie mit der Lösung bei konstantem $P = R I_0^2$.


### Zusammenfassung

- Eine **Differentialgleichung** beschreibt die zeitliche Änderung einer Größe
- Die Lösung ist eine **Funktion**, keine Zahl
- Analytische Lösungen existieren nur für einfache Sonderfälle
- Für den allgemeinen Fall: **numerische Lösungsverfahren**
- Das Euler'sche Polygonzugverfahren ist die einfachste numerische Methode
