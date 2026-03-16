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

1. **Einführung in Matlab**
2. **Arbeiten mit Arrays**
3. **Funktionen und Kontrollstrukturen**
4. **Analysis** (Polynome, Ableitung, Integration, ...)
5. **Lineare Algebra** (Gleichungssysteme, Eigenwerte, ...)
6. **Differentialgleichungen**
7. **Einführung in Simulink**

## 2. Arbeiten mit Arrays

### Felder – Arrays

Eine **n×m-Matrix** (2D-Array) ist der zentrale Datentyp in MATLAB.

| | Sp. 1 | Sp. 2 | Sp. 3 | Sp. 4 |
|---|---|---|---|---|
| **Zeile 1** | 1 | 2 | -3 | 4 |
| **Zeile 2** | 8 | 9 | 5 | 6 |
| **Zeile 3** | 11 | 12 | 0 | 9 |

- Alle Elemente besitzen den gleichen Datentyp (`double`)
- Zugriff: `A(zeile, spalte)`, z. B. `A(2,3) = 5`
- **Linear Indexing:** spaltenweise Nummerierung ab 1 – `A(2,3)` ≡ `A(8)`

### Begriffe: Array – Matrix – Vektor – Skalar

| Begriff | Dimension | Indexzugriff |
|---------|-----------|--------------|
| **Array / Feld** | n-dimensional | `A(k1, k2, ..., kn)` |
| **Matrix** | 2D (n×m) | `A(zeile, spalte)` |
| **Zeilenvektor** | 1×n | `A(1,k)` ≡ `A(k)` |
| **Spaltenvektor** | n×1 | `A(k,1)` ≡ `A(k)` |
| **Skalar** | 1×1 | `A(1,1)` ≡ `A(1)` ≡ `A` |

### Zwei Bedeutungen von „Matrix"

**1. Mathematisches/physikalisches Objekt:**
- Drehmatrix (2×2, 3×3), Trägheitsmatrix (3×3)
- Koeffizientenmatrix (n×m) für n Gleichungen mit m Unbekannten
- Eigenschaften wie Rang, Determinante, Eigenwerte sind physikalisch bedeutsam

**2. Datenspeicher:**
- Zusammenfassung zusammengehöriger Daten (z. B. Messwerte)
- Rang, Determinante etc. haben hier keine sinnvolle Bedeutung

### Beispiel: Drehmatrix (mathematisch/physikalisch)

Drehung eines 3D-Punktes $(x, y, z)$ um die z-Achse mit Winkel $\theta$ (z. B. CAD):

$$\begin{pmatrix} x' \\ y' \\ z' \end{pmatrix} = \begin{pmatrix} \cos\theta & -\sin\theta & 0 \\ \sin\theta & \cos\theta & 0 \\ 0 & 0 & 1 \end{pmatrix} \begin{pmatrix} x \\ y \\ z \end{pmatrix}$$

Für $\theta = 30°$:

$$R_z = \begin{pmatrix} 0.866 & -0.5 & 0 \\ 0.5 & 0.866 & 0 \\ 0 & 0 & 1 \end{pmatrix}$$

- Mathematische Eigenschaften relevant: $\det(R) = 1$, $R^{-1} = R^T$ (orthogonale Matrix)
- Physikalische Bedeutung: Koordinatentransformation in CAD, Robotik, ...

-> Kapitel Lineare Algebra

### Beispiel: Batterie-Messreihe als Matrix

Messungen einer Batterie-Entladung zu n Zeitpunkten:

| t [s] | I(t) [A] | U(t) [V] | T(t) [°C] |
|---|------|------|------|
| 0 | 5.0 | 12.6 | 25.0 |
| 10 | 5.2 | 12.3 | 26.5 |
| 20 | 4.8 | 12.0 | 27.8 |
| … | … | … | … |

→ n×4-Matrix oder 4×n-Matrix. Alternativ: 4 einzelne Vektoren – aber unpraktisch bei Funktionsübergabe.

### Arrays erzeugen – Syntax

**Grundelemente:**
- `[ ]` – Array-Konstruktor
- `;` – trennt Zeilen (neue Zeile)
- `,` (oder Leerzeichen) – trennt Elemente in einer Zeile

**Beispiel:**
```matlab
A = [1, 2, 3; 4, 5, 6]    % 2×3-Matrix
```

$$A = \begin{pmatrix} 1 & 2 & 3 \\ 4 & 5 & 6 \end{pmatrix}$$

### Vektoren erzeugen

**Zeilenvektor (1×n):**
```matlab
x = [1 4 8]
```
$$x = \begin{pmatrix} 1 & 4 & 8 \end{pmatrix}$$

**Spaltenvektor (n×1):**
```matlab
y = [2; 5; 9]
```
$$y = \begin{pmatrix} 2 \\ 5 \\ 9 \end{pmatrix}$$

### Arrays initialisieren

| Befehl | Bedeutung | Python (NumPy) |
|--------|-----------|----------------|
| `zeros(m, n)` | m×n-Nullmatrix | `np.zeros((m, n))` |
| `ones(m, n)` | m×n-Einsmatrix | `np.ones((m, n))` |
| `eye(n)` | n×n-Einheitsmatrix | `np.eye(n)` |
| `rand(m, n)` | m×n-Zufallsmatrix (gleichverteilt) | `np.random.rand(m, n)` |

```matlab
A = zeros(3, 4)     % 3×4-Nullmatrix
I = eye(3)          % 3×3-Einheitsmatrix
```

> Häufiges Muster: Matrix vorallokieren mit `zeros`, dann befüllen – effizienter als schrittweises Erweitern.

### Array-Zugriff und -Manipulation

**Zugriff:**
```matlab
A(2,3)                            % Element Zeile 2, Spalte 3
A(2,:)                            % komplette Zeile 2
A(:,3)                            % komplette Spalte 3
A(1:2, 2:4)                       % Teilmatrix (Zeilen 1-2, Spalten 2-4)
A(end)                            % letztes Element (linear indexing)
```

**Manipulation:**
```matlab
A(3,2) = 11                       % schreibender Zugriff → erweitert Array bei Bedarf
x(3:7) = 0                        % mehrere Elemente auf 0 setzen
x(3:8) = []                       % Elemente löschen
A'                                % transponieren (bei komplexen: konjugiert!)
A.'                               % nur transponieren (ohne Konjugation)
```

### Arrays höherer Dimension

In MATLAB werden höherdimensionale Arrays mit `cat` entlang einer Dimension verkettet:

```matlab
A = [1, 2; 3, 4];          % 2×2-Matrix
B = [5, 6; 7, 8];          % 2×2-Matrix
T = cat(3, A, B);          % 2×2×2-Array (3D)
% T(:,:,1) = A, T(:,:,2) = B
```

**Alternativen:**
```matlab
T(:,:,1) = A;              % direkte Zuweisung
T(:,:,2) = B;
```

```matlab
T = zeros(2, 3, 4);        % 2×3×4-Array mit Nullen initialisieren
```

**Unterschied zu NumPy:** keine verschachtelten Klammern erlaubt

### Operatoren und Arrays

- Die meisten Operatoren und Funktionen wirken **elementweise** auf Arrays
- Ausnahme: Matrizenmultiplikation `*`, Division `/`, Potenz `^`

```matlab
>> A = [1,2; 3,4]
>> sin(A)          % Sinus aller Elemente (Bogenmaß)
ans =
  0.8415   0.9093
  0.1411  -0.7568
>> B = 5*A + 2    % B(i,j) = 5*A(i,j) + 2
>> y = sin([0, pi/6, pi/4, pi/3])
```

### Operatoren – Dimensionsregeln

- Elementweise Operationen nur für Arrays **gleicher Dimension** oder mit Skalar

```matlab
>> A = [1,2; 3,4]
>> B = A + 2      % Skalar: erlaubt
B =
    3   4
    5   6
>> x = [2, 7]
>> A + x          % Fehler: Dimensionen stimmen nicht überein
Error using +
Matrix dimensions must agree.
```

### Multiplikation von Vektoren und Matrizen

| Ausdruck | Art | Bedeutung |
|----------|-----|-----------|
| `c * A` | Skalarmultiplikation | alle Elemente × c |
| `A * B` | Matrizenmultiplikation | aus der linearen Algebra |
| `A .* B` | elementweise Multiplikation | A(i,j) × B(i,j) |
| `A ^ n` | Matrizenpotenz | A\*A\*...\*A |
| `A .^ n` | elementweise Potenz | A(i,j)^n |
| `A / B` | Matrizendivision | A × B⁻¹ |
| `A ./ B` | elementweise Division | A(i,j) / B(i,j) |

### Matrizenmultiplikation

- A (n×k) × B (k×m) = C (n×m)
- Element C(p,q) = Skalarprodukt des p-ten Zeilenvektors von A mit dem q-ten Spaltenvektor von B

$$C(p,q) = \sum_{i=1}^{k} A(p,i) \cdot B(i,q)$$

- MATLAB führt die Matrizenmultiplikation automatisch durch – keine Schleifen nötig
- **Achtung:** Im Allgemeinen gilt A\*B ≠ B\*A (nicht kommutativ)

### Matrizenmultiplikation – Beispiel

```matlab
>> A = [1,2; 3,4; 5,6]              % 3×2
>> B = [10,11,12,13; 20,21,22,23]   % 2×4
>> C = A * B                         % 3×4
C =
    50    53    56    59
   110   117   124   131
   170   181   192   203
```

C(1,1) = 1·10 + 2·20 = 50,  C(2,3) = 3·12 + 4·22 = 124

### Elementweise Multiplikation

```matlab
>> A = [1,2; 3,4]
>> B = [10,11; 20,21]
>> C = A .* B       % C(i,j) = A(i,j) * B(i,j)
C =
    10    22
    60    84
>> D = 5 .* A       % = 5 * A (Skalarmultiplikation)
D =
     5    10
    15    20
```

Elementweise Operatoren: `.*`  `./`  `.^`

### Colon-Operator – Sequenzen erzeugen

```
start:step:end    % von start bis end mit Schrittweite step
start:end         % Schrittweite = 1 (Default)
```

```matlab
x = 1:5           % [1, 2, 3, 4, 5]
x = 1:2:10        % [1, 3, 5, 7, 9]
x = 10:-1:1       % [10, 9, ..., 1]
x = 0:pi/4:pi     % [0, 0.785, 1.571, 2.356, 3.142]
```

**Äquidistante Werte mit bekannter Anzahl:** `linspace`
```matlab
x = linspace(0, pi, 100)   % 100 Werte von 0 bis π
```
→ In Python: `np.linspace(0, np.pi, 100)` – gleiche Semantik!

### Vektoren für die Funktion `plot` erzeugen

```matlab
plot(x, y)
```

- `x` und `y` sind Vektoren mit je n Elementen
- `plot` zeichnet eine Kurve durch die Punkte (x(k), y(k))

**Vorgehen:**
1. Vektor `x` mit äquidistanten Elementen erzeugen (Colon-Operator oder `linspace`)
2. Funktionswerte `y` elementweise berechnen

```matlab
x = 2.0:0.02:4.7;    % Vektor mit Schrittweite 0.02
y = sin(x) ./ x;     % elementweise berechnen
plot(x, y)
```

### Vektoren erzeugen – Aufgaben

Erzeuge einen Vektor `x` mit äquidistanten Elementen von 2.0 bis 4.7, Abstand 0.02. Wie viele Elemente besitzt der Vektor?

Berechne für diesen Vektor folgende Funktionswerte (elementweise) und zeichne die Funktion mit `plot(x, y)`:

- $f(x) = \sin(x) / x$
- $f(x) = e^{-x} \cdot \cos(x)$

```matlab
x = 2.0:0.02:4.7;
length(x)             % Anzahl der Elemente
```


### Häufige Fehler

| Fehler | Problem | Lösung |
|--------|---------|--------|
| `A * B` statt `A .* B` | Matrizenmultiplikation statt elementweise | Punkt vor Operator |
| `A(0, 1)` | Indizes beginnen bei 1, nicht 0 | `A(1, 1)` |
| `A(3,2)` lesen, obwohl nicht existent | Index außerhalb der Matrix | `size(A)` prüfen |
| `A(3,2) = 5` schreiben | Matrix wächst still – neue Elemente = 0 | Bewusst einsetzen oder vermeiden |
| `x = [1,2,3]` statt `x = [1;2;3]` | Zeilen- statt Spaltenvektor | `;` für Spaltenvektor |
