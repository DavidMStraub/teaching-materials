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

**Einheit 1**
→ Motivation, Begriffe, Euler-Verfahren

**Einheit 2**
→ Standardform, Runge-Kutta, `ode45`

**Einheit 3 – Heute**
→ Matlab-Plots mit mehreren Subplots
→ Anwendungsbeispiele: verschiedene Ordnungen, nichtlinear, gekoppelt


## Rückblick


### Rückblick: Standardform

Jedes Anfangswertproblem in **Standardform**:

$$\boxed{\dot{\boldsymbol{y}} = f(t,\,\boldsymbol{y}), \qquad \boldsymbol{y}(t_0) = \boldsymbol{y}_0}$$

**DGL $n$-ter Ordnung umschreiben** (Beispiel: $\ddot x = \ldots$):

| Schritt | Ergebnis |
|---------|---------|
| 1. Nach höchster Ableitung auflösen | $\ddot x = g(t, x, \dot x)$ |
| 2. Neue Variablen einführen | $y_1 := x, \quad y_2 := \dot x$ |
| 3. System aufschreiben | $\dot y_1 = y_2, \quad \dot y_2 = g(t, y_1, y_2)$ |
| 4. Anfangswerte als Vektor | $\boldsymbol{y}_0 = (x_0,\; \dot x_0)^\top$ |

Ordnung $n$ → Zustandsvektor hat $n$ Komponenten → $n$ Anfangsbedingungen nötig.


### Rückblick: `ode45`

```matlab
[t, y] = ode45(f, tspan, y0)
```

| Argument | Bedeutung | Beispiel |
|----------|-----------|---------|
| `f` | Rechte Seite: `@(t,y) [...]` | `@(t,y) [y(2); -y(1)]` |
| `tspan` | Zeitbereich `[t0, tend]` | `[0, 20]` |
| `y0` | Anfangszustand (Spaltenvektor) | `[1; 0]` |
| `t` | Zeitpunkte (Spaltenvektor) | |
| `y` | Lösungsmatrix: eine Zeile pro Zeitpunkt | |

`y(:,1)` = erste Zustandsgröße, `y(:,2)` = zweite, usw.


### Federschwinger: Standardform aufstellen

$$m\ddot{x} + kx = 0, \qquad x(0)=1,\quad \dot{x}(0)=0, \qquad m=1,\; k=4$$

| Schritt | |
|---------|---|
| 1. Nach $\ddot{x}$ auflösen | $\ddot{x} = -\dfrac{k}{m}\,x$ |
| 2. Neue Variablen | $y_1 := x, \quad y_2 := \dot{x}$ |
| 3. System 1. Ordnung | $\dot{y}_1 = y_2, \quad \dot{y}_2 = -\dfrac{k}{m}\,y_1$ |
| 4. Anfangswerte | $\boldsymbol{y}_0 = (1,\; 0)^\top$ |


### Federschwinger: ode45-Aufruf

```matlab
m = 1;  k = 4;

f = @(t, y) [y(2);  -(k/m)*y(1)];

[t, y] = ode45(f, [0, 10], [1; 0]);

% y(:,1) = x(t)   Auslenkung
% y(:,2) = v(t)   Geschwindigkeit
```


## Einschub: Matlab-Plots


### Zwei Subplots übereinander

![width:20cm](assets/subplot_demo.png)


### Mehrere Subplots

Häufig sollen mehrere Größen untereinander dargestellt werden.

```matlab
subplot(m, n, k)   % m Zeilen, n Spalten, k-ter Subplot
```

| Aufruf | Wirkung |
|--------|---------|
| `subplot(2,1,1)` | oberer von zwei Subplots |
| `subplot(2,1,2)` | unterer von zwei Subplots |
| `subplot(1,2,1)` | linker von zwei Subplots |
| `subplot(2,2,3)` | unten links im 2×2-Raster |

Jeder `plot`-Befehl nach `subplot(...)` zeichnet in den aktiven Subplot.
`xlabel` kommt nur in den untersten Subplot, `ylabel` in jeden.


### `subplot`: Vollständiges Beispiel

```matlab
t = 0:0.01:20;
x = cos(t);
v = -sin(t);

subplot(2,1,1)
plot(t, x, 'b')
title('Federschwinger'),  ylabel('x [m]'),  grid on

subplot(2,1,2)
plot(t, v, 'r')
xlabel('t [s]'),  ylabel('v [m/s]'),  grid on
```

Jeder Subplot hat eigene Achsenbeschriftungen.
`title` und `legend` können in jedem Subplot gesetzt werden.


### ✍️ Aufgabe: Subplot

Die Lösung des Federschwingers liegt bereits vor (`t`, `y` aus dem vorherigen Code).

Stellen Sie $x(t)$ und $v(t)$ in **zwei Subplots übereinander** dar:
- Oberer Subplot: `y(:,1)` mit `ylabel('x [m]')`
- Unterer Subplot: `y(:,2)` mit `ylabel('v [m/s]')` und `xlabel('t [s]')`
- Beide mit `grid on`


## Fallschirm


### Fallschirm: Kräftebilanz

Ein Fallschirmspringer (Masse $m$) fällt vertikal. Kräftebilanz:

$$m\,\dot{v} = mg - c_w\,v^2$$

| Größe | Bedeutung | Wert |
|-------|-----------|------|
| $m$ | Masse | $80\,\text{kg}$ |
| $g$ | Erdbeschleunigung | $9{,}81\,\text{m/s}^2$ |
| $c_w$ | Luftwiderstandskoeffizient | $0{,}5\,\text{kg/m}$ |

**DGL 1. Ordnung** – Schritte 1–3 entfallen, sie ist bereits in Standardform:

$$\dot{v} = \underbrace{g - \frac{c_w}{m}\,v^2}_{f(t,\,v)}, \qquad \text{Schritt 4: } v_0 = 0$$


### Fallschirm: Grenzgeschwindigkeit

Im Gleichgewicht gilt $\dot{v} = 0$:

$$0 = mg - c_w\,{v^*}^2 \quad \Rightarrow \quad v^* = \sqrt{\frac{mg}{c_w}}$$

Mit den Zahlenwerten:

$$v^* = \sqrt{\frac{80 \cdot 9{,}81}{0{,}5}} \approx 39{,}6\,\text{m/s} \approx 143\,\text{km/h}$$

Diese Grenzgeschwindigkeit lässt sich analytisch berechnen –
die vollständige Lösung $v(t)$ ist ebenfalls analytisch möglich, aber aufwändig.


### Fallschirm: ode45-Aufruf

```matlab
m = 80;  g = 9.81;  cw = 0.5;

f = @(t, v) g - (cw/m)*v.^2;

[t, v] = ode45(f, [0, 30], 0);

v_star = sqrt(m*g/cw);
% v = v(t)   (skalares System, eine Spalte)
```


### ✍️ Aufgabe: Fallschirm

Stellen Sie $v(t)$ in einem Plot dar und zeichnen Sie $v^*$ als gestrichelte Linie ein.

**Variation:** Der Fallschirm öffnet bei $t = 10\,\text{s}$: $c_w$ springt auf $20\,\text{kg/m}$.
Passen Sie `f` an und beobachten Sie die neue Grenzgeschwindigkeit.


## Nichtlineares Pendel


### Pendel: Standardform aufstellen

Mathematisches Pendel ($l = 1\,\text{m}$), ohne Dämpfung:

$$\ddot\varphi = -\frac{g}{l}\,\sin\varphi, \qquad \varphi(0) = \varphi_0,\quad \dot\varphi(0) = 0$$

Stellen Sie das System in Standardform $\dot{\boldsymbol{y}} = f(t,\boldsymbol{y})$ auf (Schritte 2–4).

*Wie ändert sich $f$, wenn man $\sin\varphi \approx \varphi$ linearisiert?*


### Pendel: Lösung – Standardform

| Schritt | |
|---------|---|
| 1. Nach $\ddot\varphi$ auflösen | bereits gelöst: $\ddot\varphi = -\dfrac{g}{l}\sin\varphi$ |
| 2. Neue Variablen | $y_1 := \varphi,\quad y_2 := \dot\varphi$ |
| 3. System 1. Ordnung | $\dot{y}_1 = y_2,\quad \dot{y}_2 = -\dfrac{g}{l}\sin(y_1)$ |
| 4. Anfangswerte | $\boldsymbol{y}_0 = (\varphi_0,\; 0)^\top$ |

**Linearisiert** ($\sin\varphi \approx \varphi$): Schritt 3 wird $\dot{y}_2 = -\dfrac{g}{l}\,y_1$

![bg right:25% 90%](https://upload.wikimedia.org/wikipedia/commons/3/3a/Kraefte_am_Fadenpendel_gro%C3%9F.svg)

### Pendel: ode45-Aufruf

```matlab
g = 9.81;  l = 1;  phi0 = 2.5;

f_nl  = @(t, y) [y(2); -(g/l)*sin(y(1))];   % nichtlinear
f_lin = @(t, y) [y(2); -(g/l)*y(1)];         % linearisiert

[t1, y1] = ode45(f_nl,  [0, 10], [phi0; 0]);
[t2, y2] = ode45(f_lin, [0, 10], [phi0; 0]);
% y1(:,1) = phi(t) nichtlinear
% y2(:,1) = phi(t) linearisiert
```


### ✍️ Aufgabe: Pendel

Stellen Sie beide Lösungen $\varphi(t)$ in einem Plot dar (`legend` nicht vergessen).

**Variation:** Testen Sie $\varphi_0 = 0{,}3$ / $1{,}0$ / $2{,}5\,\text{rad}$.
Ab welcher Auslenkung weicht die linearisierte Lösung spürbar ab?


## Fußball


### Fußball: Kräftebilanz

Ein Freistoß mit Luftwiderstand $F_D = c_w v^2$ – aufgeteilt nach Richtungen:

$$m\ddot{x} = -c_w\,v\,\dot{x}, \qquad m\ddot{y} = -mg - c_w\,v\,\dot{y}, \qquad v = \sqrt{\dot{x}^2+\dot{y}^2}$$

Ohne Luftwiderstand ($c_w = 0$): $x$ und $y$ **entkoppelt**, analytisch lösbar.
Mit Luftwiderstand: $v$ koppelt beide Richtungen – **numerische Lösung nötig**.

$m = 0{,}43\,\text{kg}$, $\quad c_w = 0{,}01\,\text{kg/m}$, $\quad v_0 = 25\,\text{m/s}$, $\quad \alpha = 30^\circ$

Stellen Sie die Standardform auf. Wie viele Zustände hat $\boldsymbol{z}$?


### Fußball: Lösung – Standardform

Zwei DGLn 2. Ordnung → vier Zustände, wobei $v = \sqrt{z_2^2+z_4^2}$:

| Schritt | |
|---------|---|
| 1. Auflösen | $\ddot{x} = -\tfrac{c_w}{m}v\dot{x}$, $\quad\ddot{y} = -g - \tfrac{c_w}{m}v\dot{y}$ |
| 2. Variablen | $z_1 = x,\; z_2 = \dot{x},\; z_3 = y,\; z_4 = \dot{y}$ |
| 3. System | $\dot{z}_1 = z_2,\;\dot{z}_2 = -\tfrac{c_w}{m}v\,z_2,\;\dot{z}_3 = z_4,\;\dot{z}_4 = -g - \tfrac{c_w}{m}v\,z_4$ |
| 4. Anfangswerte | $\boldsymbol{z}_0 = (0,\; v_0\cos\alpha,\; 0,\; v_0\sin\alpha)^\top$ |


### Fußball: ode45-Aufruf

```matlab
m = 0.43;  g = 9.81;  cw = 0.01;
v0 = 25;   alpha = 30*pi/180;

f = @(t, z) [z(2);
             -cw/m * sqrt(z(2)^2+z(4)^2) * z(2);
             z(4);
             -g - cw/m * sqrt(z(2)^2+z(4)^2) * z(4)];

zinit = [0; v0*cos(alpha); 0; v0*sin(alpha)];
[~, z]  = ode45(f,                       [0, 2.5], zinit);
[~, z0] = ode45(@(t,z)[z(2);0;z(4);-g], [0, 2.5], zinit);
% z(:,1) = x,  z(:,3) = y
```


### ✍️ Aufgabe: Fußball

Stellen Sie beide Bahnkurven ($y$ über $x$) in einem Plot dar.

**Variation:** Testen Sie $\alpha =$ 15°, 30°, 45°, 60°.
Bei welchem Winkel fliegt der Ball am weitesten – und warum liegt das Optimum nicht bei 45°?


## Thermische Kette


### Thermische Kette: Energiebilanz

Drei Körper in Reihe – Erweiterung des Batterie-Modells aus Einheit 1:

$$C\,\dot T_1 = P - \lambda_{12}(T_1 - T_2)$$
$$C\,\dot T_2 = \lambda_{12}(T_1 - T_2) - \lambda_{23}(T_2 - T_3)$$
$$C\,\dot T_3 = \lambda_{23}(T_2 - T_3) - \lambda_3(T_3 - T_\infty)$$

Alle drei Gleichungen sind bereits 1. Ordnung → Schritte 1–3 entfallen.

$C = 100\,\text{J/K}$, $\;\lambda_{12}=\lambda_{23}=5\,\text{W/K}$, $\;\lambda_3=2\,\text{W/K}$, $\;P=50\,\text{W}$, $\;T_\infty=20\,^\circ\text{C}$, $\;T_0 = 20\,^\circ\text{C}$

Wie lautet der Zustandsvektor $\boldsymbol{y}$? Wie lauten die Anfangsbedingungen?


### Thermische Kette: Lösung – Standardform

Alle Gleichungen sind 1. Ordnung → Schritte 1–3 entfallen:

| Schritt | |
|---------|---|
| 2. Variablen | $y_1 = T_1,\quad y_2 = T_2,\quad y_3 = T_3$ |
| 4. Anfangswerte | $\boldsymbol{y}_0 = (20,\; 20,\; 20)^\top$ °C |


### Thermische Kette: ode45-Aufruf

```matlab
C=100; L12=5; L23=5; L3=2; P=50; Tinf=20;

f = @(t, T) [
    (P   - L12*(T(1)-T(2))) / C;
    (L12*(T(1)-T(2)) - L23*(T(2)-T(3))) / C;
    (L23*(T(2)-T(3)) - L3*(T(3)-Tinf))  / C
];

[t, T] = ode45(f, [0, 500], [20; 20; 20]);
% T(:,1) = T1(t),  T(:,2) = T2(t),  T(:,3) = T3(t)
```


### ✍️ Aufgabe: Thermische Kette

Stellen Sie $T_1(t)$, $T_2(t)$, $T_3(t)$ in einem Plot dar.

**Beobachtung:** In welcher Reihenfolge erwärmen sich die Körper?
Welche Gleichgewichtstemperaturen stellen sich ein?

**Variation:** Ersetzen Sie $P$ durch $300\,\text{W}$ für $t \le 50\,\text{s}$, danach $0$.
Was beobachten Sie?


## Biegelinie


### Biegelinie: Ort als unabhängige Variable

Euler-Bernoulli-Kragarm: Streckenlast $q$, eingespannt bei $x = 0$, frei bei $x = L$.

$$EI\,y''(x) = -\frac{q}{2}(L-x)^2$$

Die **unabhängige Variable** ist der Ort $x$ – nicht die Zeit.
`ode45` funktioniert identisch, die Variable heißt nur `x` statt `t`.

Stellen Sie die Standardform auf. Welche Anfangsbedingungen gelten bei $x = 0$?


### Biegelinie: Lösung – Standardform

| Schritt | |
|---------|---|
| 1. Nach $y''$ auflösen | $y'' = -\dfrac{q}{2EI}(L-x)^2$ |
| 2. Neue Variablen | $z_1 := y,\quad z_2 := y'$ |
| 3. System | $z_1' = z_2,\quad z_2' = -\dfrac{q}{2EI}(L-x)^2$ |
| 4. Anfangswerte | $\boldsymbol{z}_0 = (0,\; 0)^\top$ (Einspannung: keine Verschiebung, kein Winkel) |


### Biegelinie: ode45-Aufruf

```matlab
E = 210e9;  I = 1e-6;  L = 2;  q = 1000;
EI = E * I;

f = @(x, z) [z(2);  -q*(L-x)^2 / (2*EI)];

[x, z] = ode45(f, [0, L], [0; 0]);

plot(x, -z(:,1)*1e3)
xlabel('x [m]'),  ylabel('Durchbiegung [mm]'),  grid on

y_analytisch = q*L^4 / (8*EI) * 1e3;
fprintf('Analytisch:  %.3f mm\n', y_analytisch)
fprintf('Numerisch:   %.3f mm\n', -z(end,1)*1e3)
```

Analytische Kontrolle: $y(L) = \dfrac{qL^4}{8EI}$


### ✍️ Aufgabe: Biegelinie

Führen Sie den Code aus und vergleichen Sie den numerischen Endwert mit der analytischen Formel.

**Variation:** Verdoppeln Sie die Balkenlänge auf $L = 4\,\text{m}$.
Um welchen Faktor ändert sich die maximale Durchbiegung?


## Zusammenfassung


### Zusammenfassung

| Beispiel | Ordnung | Zustand | Besonderheit |
|----------|---------|---------|--------------|
| Fallschirm | 1 | $v$ | nichtlinear ($v^2$) |
| Pendel | 2 | $(\varphi,\dot\varphi)$ | nichtlinear ($\sin\varphi$) |
| Fußball | 4 | $(x, v_x, y, v_y)$ | gekoppelt, nichtlinear |
| Thermische Kette | 3 | $(T_1, T_2, T_3)$ | gekoppelt, linear |
| Biegelinie | 2 | $(y, y')$ | Variable $x$ statt $t$ |

**Immer dasselbe Schema:**
1. Standardform: $\dot{\boldsymbol{y}} = f(t,\boldsymbol{y})$, Anfangswert $\boldsymbol{y}_0$
2. Function-Handle `f` schreiben
3. `[t, y] = ode45(f, tspan, y0)` aufrufen
4. `y(:,k)` extrahieren und plotten
