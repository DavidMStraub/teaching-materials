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


### Termin 6: Simulink

**Thema:** Das Mountainbike-Modell in Simulink

**Lernziele:**
- Ein bekanntes Modell (Termin 5) als Signalflussplan in Simulink umsetzen
- Gekoppelte Zustände mit mehreren Integratoren verbinden
- Zeitabhängige Eingangssignale mit dem **Pulse Generator**-Block modellieren


## Aufgabe: Bremsanlage in Simulink


### Modell (Wiederholung aus Termin 5)

$$m\,\ddot{x} = mg\sin\alpha - F_\text{Brems} - c_w\,\dot{x}^2$$

$$C_\text{th}\,\dot{T} = F_\text{Brems}\cdot\dot{x} - (\lambda_0 + \lambda_1\,\dot{x})\,(T - T_\infty)$$

| Größe | Wert | Größe | Wert |
|-------|------|-------|------|
| $m$ | $90\,\text{kg}$ | $C_\text{th}$ | $150\,\text{J/K}$ |
| $\alpha$ | $10°$ | $\lambda_0$ | $2\,\text{W/K}$ |
| $c_w$ | $0{,}5\,\text{kg/m}$ | $\lambda_1$ | $0{,}5\,\text{Ws/(Km)}$ |
| $T_\infty$ | $20\,°\text{C}$ | $T_\text{max}$ | $300\,°\text{C}$ |


### Aufgabe 1 – Signalflussplan

Das System hat zwei Zustände: $\dot{x}$ und $T$.

**a)** Wie viele Integratoren braucht das Simulink-Modell? Benennen Sie Eingang und Ausgang jedes Integrators.

**b)** Zeichnen Sie den Signalflussplan auf Papier. Welche Signale müssen rückgekoppelt werden? Woher bezieht der Block, der $\ddot{x}$ und $\dot{T}$ berechnet, seine Eingänge?

**c)** $F_\text{Brems}$ soll als externer Eingangsblock modelliert werden (nicht im Funktionsblock fest eingebaut). Warum ist das sinnvoll?


### Aufgabe 2 – Modell aufbauen

Bauen Sie das Modell in Simulink auf:

1. Definieren Sie alle Parameter ($m$, $\alpha$, $c_w$, $C_\text{th}$, $\lambda_0$, $\lambda_1$, $T_\infty$) im MATLAB-Workspace.
2. **Matlab Function**-Block mit Signatur `function [x_ddot, T_dot] = f(x_dot, T, F_brems)` — liest Parameter aus dem Workspace.
3. **Constant**-Block für $F_\text{Brems} = 70\,\text{N}$, verbunden mit dem dritten Eingang.
4. Zwei **Integrator**-Blöcke: Anfangswerte $\dot{x}_0 = 10\,\text{m/s}$, $T_0 = 20\,°\text{C}$.
5. **Scope** mit zwei Eingängen für $\dot{x}(t)$ und $T(t)$; $T_\text{max}$ als horizontale Linie im Scope konfigurieren.
6. Simulationsdauer $120\,\text{s}$.


### Aufgabe 3 – Intervallbremsen

Ersetzen Sie den **Constant**-Block durch einen **Pulse Generator**-Block.

**a)** Welche Amplitude $A$ muss der Pulse Generator haben, damit die mittlere Bremskraft $70\,\text{N}$ beträgt (10 s bremsen, 10 s frei)?

**b)** Konfigurieren Sie den Pulse Generator: Periode $20\,\text{s}$, Pulsbreite $50\,\%$, Amplitude aus a). Simulieren Sie.

**c)** Stellen Sie $T(t)$ für konstantes und intervallartiges Bremsen in einem gemeinsamen Plot dar. Welche Strategie ist für die Bremsscheibe schonender – und warum?
