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
→ Motivation und Herleitung am Ingenieurbeispiel
→ Begriffe: Ordnung, Anfangswertproblem
→ Analytische vs. numerische Lösung
→ Euler'sches Polygonzugverfahren in Matlab

**Einheit 2 – Heute**
→ Standardform für numerische Verfahren
→ Numerische Lösungsverfahren
→ Lösung in Matlab

**Einheit 3**
→ Anwendungen


## Standardform


### Rückblick: Was kann das Euler-Verfahren?

Aus Einheit 1: Das Euler-Verfahren löst DGLn der Form

$$\dot{z} = f(t,\, z), \qquad z(t_0) = z_0$$

Schrittweise Approximation mit Schrittweite $h$:

$$z_{i+1} = z_i + h \cdot f(t_i,\, z_i)$$

Konkret – die Batterie-DGL: $\quad f(t, T) = \dfrac{P - \lambda\,(T - T_\infty)}{C_\text{th}}$

**Frage:** Was passiert, wenn wir **mehrere gekoppelte** DGLn haben – oder eine DGL **höherer Ordnung**?


### Erweiterung 1: Gekoppelte DGLn 1. Ordnung

**Zwei Zellen** in einem Modul, thermisch gekoppelt ($\mu$ = Kopplung zwischen den Zellen):

$$C_\text{th}\,\dot{T}_1 = P_1 - \lambda(T_1 - T_\infty) - \mu(T_1 - T_2)$$
$$C_\text{th}\,\dot{T}_2 = P_2 - \lambda(T_2 - T_\infty) - \mu(T_2 - T_1)$$

Beide DGLn sind 1. Ordnung, aber **gekoppelt** – $\dot{T}_1$ hängt von $T_2$ ab und umgekehrt.

Als Vektor geschrieben hat das genau die gleiche Form wie vorher:

$$\dot{\boldsymbol{z}} = f(t,\, \boldsymbol{z}), \qquad \boldsymbol{z} = \begin{pmatrix}T_1\\T_2\end{pmatrix}$$

Das Euler-Verfahren funktioniert **unverändert** – nur mit Vektoren statt Skalaren.


### Die Standardform

Das Euler-Verfahren (und alle anderen Löser) arbeiten mit der **Standardform**:

$$\boxed{\dot{\boldsymbol{z}} = f(t,\, \boldsymbol{z}), \qquad \boldsymbol{z}(t_0) = \boldsymbol{z}_0}$$

- $\boldsymbol{z}(t) \in \mathbb{R}^n$: Zustandsvektor
- $f$: vektorwertige Funktion der Zeit und des Zustands
- Skalarer Fall ($n=1$): die bekannte Form aus Einheit 1

**Offene Frage:** Was ist mit DGLn *höherer Ordnung* – z. B. Schwingungsgleichungen?


### Erweiterung 2: DGL 2. Ordnung → Standardform

Eine DGL 2. Ordnung enthält $\ddot{x}$ – das passt nicht direkt in die Standardform.

Beispiel – Schwingungsgleichung: $\quad m\ddot{x} + kx = 0$

**Idee:** Neue Variable $v := \dot{x}$ einführen, dann gilt $\dot{v} = \ddot{x}$.

Die eine DGL 2. Ordnung wird zu **zwei** DGLn 1. Ordnung:

$$\dot{x} = v, \qquad \dot{v} = -\frac{k}{m}\,x$$

In Vektorschreibweise – jetzt wieder Standardform!

$$\dot{\boldsymbol{z}} = \underbrace{\begin{pmatrix}v\\-\dfrac{k}{m}\,x\end{pmatrix}}_{=f(t,\,\boldsymbol{z})}, \qquad \boldsymbol{z} = \begin{pmatrix}x\\v\end{pmatrix}$$


### Standardform: Vorgehensweise

**Wie viele Komponenten hat $\boldsymbol{z}$?**
→ Gleich der **Ordnung** der DGL.

**Vorgehen:**

1. DGL nach der **höchsten Ableitung** auflösen: $\ddot{x} = \ldots$
2. Neue Variablen einführen:
   $z_1 := x, \quad z_2 := \dot{x}$
3. System aufschreiben:
   $\dot{z}_1 = z_2, \quad \dot{z}_2 = \ldots$
4. Anfangsbedingungen als Vektor:
   $\boldsymbol{z}_0 = \begin{pmatrix}x(0)\\\dot{x}(0)\end{pmatrix}$


### ✍️ Aufgabe: Standardform

Schreiben Sie die folgende DGL in ein System von DGLn 1. Ordnung um.
Geben Sie auch die Anfangsbedingungen als Vektor $\boldsymbol{z}_0$ an.

**Gedämpfte Schwingung mit äußerer Anregung:**

$$m\ddot{x} + d\,\dot{x} + k\,x = F_0\cos(\omega t), \qquad x(0) = 0,\quad \dot{x}(0) = v_0$$

*Wie viele Komponenten hat $\boldsymbol{z}$?*


## Numerische Lösungsverfahren


### Euler-Verfahren: Einfluss der Schrittweite

Wir haben das Euler-Verfahren bereits kennengelernt – aber wie gut funktioniert es wirklich?

**Testfall:** Federschwinger ohne Dämpfung

$$\ddot{x} + x = 0 \quad \Rightarrow \quad \dot{\boldsymbol{z}} = \begin{pmatrix}v \\ -x\end{pmatrix}, \quad \boldsymbol{z}_0 = \begin{pmatrix}1\\0\end{pmatrix}$$

Exakte Lösung: $x(t) = \cos(t)$ – eine gleichmäßige Schwingung, **keine wachsende Amplitude**.

**Frage:** Was passiert, wenn wir die Schrittweite $h$ variieren?


### Euler-Verfahren: Grenzen – Live-Demo

```matlab
f = @(t, z) [z(2); -z(1)];   % Federschwinger: z = [x; v]
dt = 0.001;
t = 0:dt:30;
z = zeros(2, length(t));
z(:,1) = [1; 0];              % x(0)=1, v(0)=0
for i = 1:length(t)-1
    z(:,i+1) = z(:,i) + dt * f(t(i), z(:,i));
end
plot(t, z(1,:), t, cos(t), '--')
legend('Euler', 'Exakt'),  grid on
```


### Euler-Verfahren: Fazit

- Kleine Schrittweite → genaue Lösung, aber **langsam**
- Große Schrittweite → Lösung wächst oder **explodiert**
- Beim Federschwinger wird Energie künstlich erzeugt – physikalisch falsch

→ Wir brauchen ein Verfahren, das **genauer** ist bei gleicher Schrittweite.


### Von Euler zu Runge-Kutta

**Euler** nutzt nur die Steigung am **Anfang** des Intervalls:

$$k_1 = f(t_i, z_i), \qquad z_{i+1} = z_i + dt \cdot k_1$$

→ Analogie: **Rechteckregel** aus der Numerischen Integration.

**Modifiziertes Euler-Verfahren:** Erst einen halben Schritt, Steigung dort auswerten, dann ganzen Schritt:

$$k_1 = f(t_i, z_i), \quad k_2 = f\!\left(t_i+\tfrac{dt}{2},\; z_i + \tfrac{dt}{2}\,k_1\right)$$
$$z_{i+1} = z_i + dt \cdot k_2$$

→ Analogie: **Mittelpunktregel**. Genauer als Euler, weil die Steigung in der Mitte repräsentativer ist.


### RK3 und die Simpsonregel

**RK3:** Steigung am Anfang, in der Mitte und am Ende:

$$k_1 = f(t_i, z_i), \quad k_2 = f\!\left(t_i+\tfrac{dt}{2},\; z_i+\tfrac{dt}{2}k_1\right), \quad k_3 = f(t_i+dt,\; z_i+dt\,k_2)$$

$$z_{i+1} = z_i + \frac{dt}{6}(k_1 + 4k_2 + k_3)$$

→ Gewichte $\frac{1}{6}, \frac{4}{6}, \frac{1}{6}$ – das ist die **Simpsonregel** (Analysis II / Keplersche Fassregel), angewendet auf die Steigungsfunktion $f$.


### RK4: Noch besser

**RK4:** Die Mitte wird **zweimal** ausgewertet – $k_3$ verbessert die Schätzung von $k_2$:

$$k_1 = f(t_i,\; z_i)$$
$$k_2 = f\!\left(t_i+\tfrac{dt}{2},\; z_i + \tfrac{dt}{2}\,k_1\right)$$
$$k_3 = f\!\left(t_i+\tfrac{dt}{2},\; z_i + \tfrac{dt}{2}\,k_2\right)$$
$$k_4 = f\!\left(t_i+dt,\; z_i + dt\,k_3\right)$$

$$z_{i+1} = z_i + \frac{dt}{6}(\,k_1 + 2k_2 + 2k_3 + k_4\,)$$



### Euler als wiederverwendbare Funktion

Unser Euler-Code:

```matlab
f  = @(t, z) [z(2); -z(1)];
dt = 0.01;
t  = 0:dt:20;
z  = zeros(2, length(t));
z(:,1) = [1; 0];
for i = 1:length(t)-1
    z(:,i+1) = z(:,i) + dt * f(t(i), z(:,i));
end
```

Dieser Code braucht nur drei Dinge: die **DGL** `f`, den **Zeitbereich** und die **Anfangsbedingung**.

→ Das Verfahren selbst lässt sich als Funktion kapseln:


### Euler als Funktion

```matlab
function [t, z] = ode_euler(f, tspan, z0, dt)
    t = tspan(1):dt:tspan(2);
    z = zeros(length(z0), length(t));  % funktioniert für 1D und nD
    z(:,1) = z0;
    for i = 1:length(t)-1
        z(:,i+1) = z(:,i) + dt * f(t(i), z(:,i));
    end
end
```

- `tspan` ist der Zeitbereich `[t0, tend]`
- `f` ist ein Function-Handle


### `ode45` in MATLAB

MATLAB löst DGLn in Standardform mit `ode45` – der Name steht für **Runge-Kutta der Ordnung 4/5**:
- Zwei Verfahren (RK4 und RK5) laufen parallel – die Differenz schätzt den Fehler
- `ode45` passt $dt$ automatisch an

```matlab
[t, y] = ode45(f, tspan, z0)
```

| Argument | Bedeutung | Beispiel |
|----------|-----------|---------|
| `f` | Function-Handle für $f(t, \boldsymbol{z})$ | `@(t,z) [z(2); -z(1)]` |
| `tspan` | Zeitbereich `[t0, tend]` | `[0, 20]` |
| `z0` | Anfangsbedingung (Spaltenvektor) | `[1; 0]` |
| `t` | Zeitpunkte (Spaltenvektor) | |
| `y` | Lösungsmatrix: eine Spalte pro Variable | `y(:,1)` = $x$, `y(:,2)` = $v$ |


### Federschwinger mit `ode45`

```matlab
f = @(t, z) [z(2); -z(1)];   % z = [x; v]

[t, y] = ode45(f, [0, 20], [1; 0]);

plot(t, y(:,1), 'b', t, y(:,2), 'r')
legend('x(t)', 'v(t)')
xlabel('t'),  grid on
```

`y(:,1)` enthält $x(t)$, `y(:,2)` enthält $v(t)$ – eine Zeile pro Zeitpunkt.


### ✍️ Aufgabe: Schwingung mit `ode45`

Lösen Sie die **gedämpfte Schwingung** aus der vorherigen Aufgabe numerisch:

$$m\ddot{x} + d\,\dot{x} + k\,x = F_0\cos(\omega t), \qquad x(0) = 0,\quad \dot{x}(0) = 1$$

mit $m = 1$, $d = 0{,}2$, $k = 4$, $F_0 = 1$, $\omega = 2$.

1. Schreiben Sie die Funktion `f(t, z)` in MATLAB
2. Lösen Sie mit `ode45` für $t \in [0, 30]$
3. Plotten Sie $x(t)$ und $v(t)$

*Was beobachten Sie im Langzeitverhalten?*
