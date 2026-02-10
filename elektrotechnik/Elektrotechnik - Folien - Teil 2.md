---
marp: true
theme: hm
paginate: true
language: de
footer: Elektrotechnik – Straub
headingDivider: 3
---
# Elektrotechnik (Teil 2/3)

**Luft- und Raumfahrttechnik Bachelor, 1. Semester**

David Straub


### Gliederung des Kurses

1. [Einführung](#einführung) (Physikalische Größen, Einheiten)
2. [Das elektrische Feld](#das-elektrische-feld) (Ladungen, Kräfte, Felder, Potential, Spannung, Kapazität, Kondensatoren)
3. [Gleichstrom](#gleichstrom) (Stromstärke, Widerstand, Stromkreisberechnungen, Energie, Leistung)
4. [Magnetismus](#magnetismus) (Feld in Vakuum und Materie, Kräfte, magnetischer Kreis)
5. [Elektromagnetische Induktion](#elektromagnetische-induktion) (Induktion, Selbstinduktion, Energie)
6. [Wechselstrom](#wechselstrom) (Komplexe Wechselstromrechnung, Schaltungen, Leistung)
7. [Drehstrom](#drehstrom) (Dreiphasensystem)
8. [Schaltvorgänge an Kapazitäten und Induktivitäten](#schaltvorgänge-an-kapazitäten-und-induktivitäten)




## Magnetismus

1. Magnetisches Feld
2. Magnetisches Feld in Materie
3. Kräfte im magnetischen Feld
4. [Magnetischer Kreis](#der-magnetische-kreis)

### Elektrizität & Magnetismus

... sind untrennbar verbunden. Eine Konsistente Naturbeschreibung erfordert beide

Grenzfälle:

- Ruhende Ladungen -> **Elektrostatik**
- Konstante Stromverteilungen -> **Magnetostatik**
- Langsam bewegte Ladungen & langsam veränderliche Ströme -> **Quasistatik**
- Allgemeiner Fall -> **Elektrodynamik**

### Magnetpole

- Magnete besitzen immer zwei Pole: Nordpol (N) und Südpol (S)
    - Nordpol = Pol, der auf der Erde nach Norden zeigt
- Gleichnamige Pole stoßen sich ab, ungleichnamige Pole ziehen sich an

![bg right:40% 70%](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Geomagnetic_field_and_magnet_analogy.png/640px-Geomagnetic_field_and_magnet_analogy.png)

### Kräfte zwischen elektrischen Leitern

Zwei parallele, stromdurchflossene Leiter üben eine Kraft aufeinander aus

$$\frac{|\vec{F_{12}}|}{l} = 2k_A \cdot \frac{I_1 I_2}{d}$$


Magnetfelder entstehen durch bewegte elektrische Ladungen (Ströme)

Im SI-System gilt $k_A = \frac{\mu_0}{4\pi}$ mit $\mu_0 \approx 4\pi \cdot 10^{-7} \frac{\text{N}}{\text{A}^2}$

![bg right:30% 80%](https://upload.wikimedia.org/wikipedia/commons/b/bc/MagneticWireAttraction.svg)


### Wichtiger Unterschied zur Elektrostatik

- In der Elektrostatik haben wir die Feldstärke über die Kraft definiert: $\vec{E} = \frac{\vec{F}}{Q}$
- In der Magnetostatik geht das nicht so einfach, da die Kraft senkrecht zur Bewegungsrichtung der Ladung wirkt
- Wir können experimentell die Feldlinien durch die Ausrichtung eines Permanentmagneten (Kompassnadeln) sichtbar machen

### Magnetische Feldlinien


![width:20cm](https://upload.wikimedia.org/wikipedia/commons/a/af/VFPt_cylindermagnet_field-representations.svg)

- Magnetische Feldlinien zeigen in die Richtung, in die sich der Nordpol eines kleinen Testmagneten ausrichten würde: N -> S außerhalb des Magneten
- Magnetische Feldlinien sind immer geschlossen (keine magnetischen Monopole) oder unendlich lang
- Die Dichte der Feldlinien ist ein Maß für die Stärke des Magnetfeldes

### Magnetische Flussdichte $\vec{B}$

Die magnetische Flussdichte $\vec{B}$ zeigt entlang der magnetischen Feldlinien. Ihr Betrag ist proportional zur Dichte der Feldlinien.

![bg right:33% 70%](https://upload.wikimedia.org/wikipedia/commons/0/0c/VFPt_cylindrical_magnet_thumb.svg)

### Rechte-Faust-Regel

- Ein gerader, stromdurchflossener Leiter erzeugt ein ringförmiges Magnetfeld. Wenn der Daumen der Faust in Stromrichtung zeigt, zeigen die gekrümmten Finger in Feldrichtung
- Alternativ: eindrehen einer Schraube in Stromrichtung -> Drehrichtung der Schraube entspricht der Feldlinienrichtung

![bg right:40% 70%](https://upload.wikimedia.org/wikipedia/commons/3/3e/Manoderecha.svg)



### Magnetische Flussdichte eines stromdurchflossenen Leiters

Im Abstand $r$ von einem geraden, unendlich langen Leiter:

$$|\vec{B}| = \frac{\mu_0}{2\pi} \cdot \frac{I}{r}$$

Einheit: das Tesla

$$[\vec{B}] = [\mu_0] \cdot \frac{[I]}{[r]} = \frac{\text{N}}{\text{A}^2} \cdot \frac{\text{A}}{\text{m}} = \frac{\text{N}}{\text{A}\cdot\text{m}}  = \frac{\text{N}}{\text{C} \cdot \frac{\text{m}}{\text{s}}} = \text{T} $$


### Einheit Tesla: numerisches Beispiel

Historische Definition des Amperes: Zwei parallele, unendlich lange Leiter im Abstand von 1 m, durch die jeweils 1 A fließen, üben eine Kraft von $2 \cdot 10^{-7} \frac{\text{N}}{\text{m}}$ aufeinander aus -> $\mu_0 = 4\pi \cdot 10^{-7} \frac{\text{N}}{\text{A}^2}$

Wieviel Ampere müssen durch einen Leiter fließen, um ein Magnetfeld von 1 T in 1 m Abstand zu erzeugen?


### Größenordnung der Magnetischen Flussdichte

| Magnet                | Magnetische Flussdichte *B* |
|-----------------------------------|------------------------------------------|
| Erdmagnetfeld                     | 30 µT – 60 µT                            |
| Kühlschrankmagnet                 | 1 mT – 10 mT                             |
| Magnetstreifen (Kreditkarte)      | 10 mT – 100 mT                           |
| Lautsprechermagnet                | 100 mT – 1 T                             |
| MRT-Gerät            | 1 T – 3 T                             |
| Large Hadron Collider (LHC)  | 8 T                                      |
| Fusionskraftwerk  | 5–15 T


### Permanenter Magnetismus: Ursprung im Elektronenspin

**Elektronenspin** (intrinsische Eigenschaft):

- Das Elektron besitzt einen **Spin** – eine quantenmechanische Eigenschaft ähnlich einem Drehimpuls
- Man kann sich (vereinfacht) vorstellen: Elektron verhält sich *als ob* es um die eigene Achse rotiert

**Konsequenz:**

- Jedes Elektron ist ein winziger **Permanentmagnet**
- Makroskopische Magnete entstehen durch **Ausrichtung** vieler Elektronenspins

![bg right:35% 90%](https://upload.wikimedia.org/wikipedia/commons/7/7f/Electron-spin-classical-model-symbols-simplified.svg)


### Kräfte im magnetischen Feld

**Lorentzkraft auf bewegte Ladung:**

$$\vec{F} = Q \cdot (\vec{v} \times \vec{B})$$

**Kraft auf stromdurchflossenen Leiter:**

$$\vec{F} = I \cdot (\vec{\ell} \times \vec{B})$$

- Skalar (wenn $\vec{\ell} \perp \vec{B}$): $F = I \cdot \ell \cdot B$
- **Rechte-Hand-Regel:** Daumen = Stromrichtung, Zeigefinger = Feldrichtung, Mittelfinger = Kraftrichtung

![bg right:30% 90%](https://upload.wikimedia.org/wikipedia/commons/2/23/UVW-regel-strom-und-positive-ladung.svg)



### Bewegte Ladung im Magnetfeld


**Kreisbewegung:**

- Lorentzkraft wirkt als Zentripetalkraft: $Q \cdot v \cdot B = \frac{m \cdot v^2}{r}$
- Bahnradius: $r = \frac{m \cdot v}{Q \cdot B}$
- Umlauffrequenz: $f = \frac{Q \cdot B}{2\pi m}$ (unabhängig von $v$!)

**Anwendungen:**

- Teilchenbeschleuniger (Zyklotron)
- Massenspektrometer


![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/3/3a/Circular-path-of-a-proton-in-a-homogeneous-magnetic-field.svg)




### Vergleich: Elektrisches und Magnetisches Feld

| Eigenschaft | Elektrisches Feld | Magnetisches Feld |
|-------------|-------------------|-------------------|
| **Feldlinien** | Beginnen/enden auf Ladungen | Enden nie |
| **Quellen** | Ladungen | Keine (keine Monopole) |
| **Wirbel** | Keine (wirbelfrei) | Ströme erzeugen Wirbel |
| **Potential** | Darstellbar als Gradient | Nicht darstellbar |
| **Arbeit** | Wegunabhängig | keine (Magnetostatik) |

**Elektrostatisches Feld** = Quellenfeld, wirbelfrei
**Magnetostatisches Feld** = Quellenfrei, Wirbelfeld


### Magnetischer Fluss $\Phi$

Der magnetische Fluss $\Phi$ durch eine Fläche $A$ ist definiert als:

$$\Phi = \int_A \vec{B} \cdot d\vec{A}$$

- Einheit: $[\Phi] = \text{Vs}$ (Weber)

Da das magnetische Feld *quellenfrei* ist, gilt für jede geschlossene Fläche:

$$\Phi_\text{geschl. Fl.} = \oint_A \vec{B} \cdot d\vec{A} = 0$$

(Vergleiche: Satz von Gauß, $\oint_A \vec{D} \cdot d\vec{A} = Q_{\text{innen}}$)




### Magnetische Feldstärke $\vec{H}$

Die magnetische Feldstärke $\vec{H}$ beschreibt die Fähigkeit eines elektrischen Stroms, ein Magnetfeld zu erzeugen.

**Zusammenhang mit der magnetischen Flussdichte** (im Vakuum):

$$\vec{B} = \mu_0 \vec{H}$$

- Einheit: $[H] = \frac{[B]}{[\mu_0]} = \frac{\text{T}}{\frac{\text{N}}{\text{A}^2}} = \frac{\frac{\text{N}\cdot\text{s}}{\text{A}\cdot\text{m}}}{\frac{\text{N}}{\text{A}^2}}=\frac{\text{A}}{\text{m}}$

**Beispiel:**

- Gerader stromdurchflossener Leiter (Abstand $r$): $H = \frac{I}{2\pi r}$

### Durchflutungsgesetz (Ampèresches Gesetz)

Die Summe der magnetischen Feldstärke längs eines geschlossenen Weges ist gleich der Gesamtstromdurchflutung:

$$\Theta = N \cdot I = \oint \vec{H}(s) \cdot d\vec{s}$$

Erinnerung: in der Elektrostatik gilt aufgrund der Wegunabhängigkeit des Potentials:

$$U =\int \vec{E}(s) \cdot d\vec{s} ~~\Rightarrow~~ \oint \vec{E}(s) \cdot d\vec{s} = 0$$


### Vergleich: Gaußsches Gesetz und Ampèresches Gesetz

**Berechnung von Feldern mit hoher Symmetrie:**

| Elektrostatik | Magnetostatik |
|---------------|---------------|
| **Gaußsches Gesetz** | **Ampèresches Gesetz** |
| $\oint_A \vec{D} \cdot d\vec{A} = Q_{\text{innen}}$ | $\oint_s \vec{H} \cdot d\vec{s} = I_{\text{umschlossen}}$ |
| Quellenfeld | Wirbelfeld |
| **Quellenfreiheit:** | **Wirbelfreiheit:** |
| $\oint_s \vec{E} \cdot d\vec{s} = 0$ | $\oint_A \vec{B} \cdot d\vec{A} = 0$ |
| (Elektrostatische Felder sind wirbelfrei) | (Magnetische Felder sind quellenfrei) |

**Anwendung bei Symmetrie:**

- Gaußsches Gesetz → Kugel-, Zylinder-, Plattensymmetrie für Ladungen
- Ampèresches Gesetz → Zylinder-, Ebenen-, Toroidsymmetrie für Ströme

### Magnetfeld einer langen Spule

**Aufbau:** Lange Spule mit $N$ Windungen, Länge $\ell$, Strom $I$

**Durchflutungsgesetz:**

$$\oint \vec{H} \cdot d\vec{s} = N \cdot I$$

**Im Inneren der Spule:**

$$H = \frac{N \cdot I}{\ell} = n \cdot I \quad \text{mit } n = \frac{N}{\ell}$$

$$B = \mu_0 \mu_r H = \mu_0 \mu_r n I$$

**Außerhalb:** $B \approx 0$

![bg right:40% 80%](https://upload.wikimedia.org/wikipedia/commons/0/05/Cylindrical_long_tightly-wound_coil2.svg)


### Beispiel: Magnetfeld in einem Tokamak

![](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Schematic-of-a-tokamak-chamber-and-magnetic-profile.jpg/640px-Schematic-of-a-tokamak-chamber-and-magnetic-profile.jpg)

### Beispiel: Magnetfeld in einem Tokamak

Ringförmiges Fusionsreaktor-Design mit toroidalem Magnetfeld zum Plasmaeinschluss

**Toroidale Feldspulen (TF):**

- $N$ Spulen gleichmäßig um den Torus verteilt, $M$ Windungen, Strom $I$ pro Windung
- Ampèresches Gesetz auf kreisförmigem Weg (Radius $r$):

$$\oint \vec{H} \cdot d\vec{s} = H \cdot 2\pi r = N M \cdot I \Rightarrow H(r) = \frac{N M I}{2\pi r}$$

**Eigenschaften:**

- Feld nimmt mit $\frac{1}{r}$ ab (inhomogen)
- Typische Werte: $B \approx 5{-}15 \, \text{T}$

**Beispiel ITER:** 18 TF-Spulen, 134 Windungen  68 kA, B = 5,3 T bei 6,2 m Radius


### Magnetisches Verhalten von Materie

Ähnlich wie bei Dielektrika im elektrischen Feld reagiert Materie im Magnetfeld durch **Magnetisierung**.

**Magnetische Dipole in Atomen:**

- Elektronen haben einen intrinsischen **Spin** (magnetischer Dipol)
- Bahnbewegung der Elektronen erzeugt **Bahnmagnetismus**
- Atomrümpfe können ebenfalls magnetische Momente besitzen

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/c/c8/Elementary-magnets.png)


### Magnetische Suszeptibilität und Permeabilität

Die Magnetisierung $\vec{M}$ ist proportional zur magnetischen Feldstärke $\vec{H}$:

**Magnetische Suszeptibilität** $\chi_m$:

$$\vec{M} = \chi_m \vec{H} \quad \text{bzw.} \quad \mu_r = 1 + \chi_m$$

**Reaktion auf äußeres Feld:**

- Diamagnetismus: Dipole richten sich **gegen** das äußere Feld ($\mu_r < 1$, $\chi_m < 0$)
- Paramagnetismus: Dipole richten sich **mit** dem äußeren Feld ($\mu_r > 1$, $\chi_m > 0$)
- Ferromagnetismus: Starke Ausrichtung der Dipole ($\mu_r \gg 1$, $\chi_m \gg 1$)


### Magnetische Eigenschaften der Elemente

![width:23cm](https://www.e-magnetica.pl/lib/exe/fetch.php/magnetic_elements_magnetica.png)

(S. Zurek, Encyclopedia Magnetica, CC-BY-4.0)


### Diamagnetismus

**Eigenschaften:**

- Tritt in allen Materialien auf
- Magnetische Suszeptibilität: $\chi_m < 0$ (sehr klein)
- Relative Permeabilität: $\mu_r < 1$ (knapp unter 1)

**Physikalischer Mechanismus:**

- Externes Magnetfeld induziert Änderung der Elektronenbahnen
- Erzeugt magnetisches Moment **entgegen** dem äußeren Feld
- Effekt verschwindet, wenn Feld abgeschaltet wird

**Beispiele:** Kupfer, Silber, Gold, Wasser, organische Materialien


### Levitation

Diamagnetische Materialien können in starken Magnetfeldern schweben

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/7/7b/Frog_diamagnetic_levitation.jpg)

### Paramagnetismus

**Eigenschaften:**

- Atome besitzen permanente magnetische Dipole
- Magnetische Suszeptibilität: $\chi_m > 0$ (klein)
- Relative Permeabilität: $\mu_r > 1$ (knapp über 1)
- Paramagnete werden **schwach von Magneten angezogen**

**Physikalischer Mechanismus:**

- Ohne externes Feld: zufällige Ausrichtung der Dipole (thermische Bewegung)
- Mit externem Feld: partielle Ausrichtung **parallel** zum Feld
- Stärker bei tiefen Temperaturen (Curie-Gesetz: $\chi_m \propto 1/T$)

**Beispiele:** Aluminium, Platin, Sauerstoff



### Ferromagnetismus

**Eigenschaften:**

- Sehr starke Magnetisierung
- Magnetische Suszeptibilität: $\chi_m \gg 1$
- Relative Permeabilität: $\mu_r \gg 1$ (bis zu $10^5$), viel größer als bei Paramagneten!
- **Spontane Magnetisierung** auch ohne externes Feld möglich

**Physikalischer Mechanismus:**

- Starke Wechselwirkung zwischen benachbarten Atomen (**Austauschwechselwirkung**)
- Bildung von **Weiss'schen Bezirken** (Domänen)
- Externes Feld richtet Domänen aus

**Beispiele:** Eisen, Kobalt, Nickel

### Weiß’sche Bezirke
- Bereiche mit **gleich orientierten magnetischen Dipolen**
- Spontane Magnetisierung innerhalb der Bezirke

**Ohne äußeres Feld:**

- Bezirke sind zufällig orientiert → keine Gesamtmagnetisierung

**Mit äußerem Feld:**

- Bezirke richten sich aus
- Bei Sättigung: einheitliche Ausrichtung

![bg right:50% 100%](https://upload.wikimedia.org/wikipedia/commons/0/0a/Growing-magnetic-domains.svg)

### Ferromagnetismus: Hysterese


**Kenngrößen:**

- **Sättigungsmagnetisierung** (1): maximale Magnetisierung
- **Remanenz** (2): verbleibende Flussdichte bei verschwindendem äußeren Feld
- **Koerzitivfeldstärke** (3): Feldstärke zum Entmagnetisieren

![bg right:40% 85%](https://upload.wikimedia.org/wikipedia/commons/e/ee/Hysteresis-from-unmagnetised-state.svg)


### Harte/weiche Magnete

- **Weiche Magnetmaterialien:**
    - Leicht magnetisier- und entmagnetisierbar
    - Anwendung: Transformatoren, Elektromagnete

- **Harte Magnetmaterialien:**
    - Behalten Magnetisierung
    - Anwendung: Permanentmagnete, Motoren, Lautsprecher


![bg right:60% 100%](https://upload.wikimedia.org/wikipedia/commons/4/4b/Hysteresis-comparison.svg)



### Magnetisches Feld und Magnetisierung

**Magnetisierung** $\vec{M}$: magnetisches Dipolmoment pro Volumeneinheit

$$\vec{B} = \mu_0(\vec{H} + \vec{M}) = \mu_0 \mu_r \vec{H}$$

**Zusammenhang der Feldgrößen:**

$$\vec{H} = \frac{\vec{B}}{\mu_0 \mu_r}$$

**Konvention**: Die magnetische Feldstärke $\vec{H}$ beschreibt das durch freie Ströme erzeugte Magnetfeld – ohne Beiträge der Magnetisierung des Materials.

**Vorteil:** Das Durchflutungsgesetz gilt unverändert für freie Ströme:

$$\oint \vec{H} \cdot d\vec{s} = I_{\text{frei}}$$


### Analogie Elektrostatik <-> Magnetostatik

**Elektrostatik:**

- Elektrische Flussdichte: $\vec{D} = \varepsilon_0 \vec{E} + \vec{P}$ (bezieht sich auf freie Ladungen)
- Vorteil: Das Gaußsche Gesetz gilt unverändert für freie Ladungen:
  
  $$\oint \vec{D} \cdot d\vec{A} = Q_{\text{frei}}$$

**Magnetostatik:**

- Magnetische Feldstärke: $\vec{H} = \frac{\vec{B}}{\mu_0} - \vec{M}$ (bezieht sich auf freie Ströme)
- Vorteil: Das Durchflutungsgesetz gilt unverändert für freie Ströme:
  
  $$\oint \vec{H} \cdot d\vec{s} = I_{\text{frei}}$$

### Analogie der Feldgrößen

![width:18cm](https://upload.wikimedia.org/wikipedia/commons/d/d2/Gr%C3%B6%C3%9Fen_im_elektrischen_und_magnetischen_Feld.svg)

### Übersicht: Größen in der Magnetostatik

Größe | Definition | Einheit
--- | --- | ---
Magnetische Flussdichte (*magnetic flux density*) | $\vec{B}$ | $[\vec{B}] = \text{T} = \frac{\text{N}}{\text{A} \cdot \text{m}}$
Magnetische Feldstärke (*magnetic field [strength]*) | $\vec{H} = \frac{\vec{B}}{\mu_0 \mu_r}$ | $[\vec{H}] = \frac{\text{A}}{\text{m}}$
Magnetischer Fluss (*magnetic flux*) | $\Phi = \int_A \vec{B} \cdot d\vec{A}$ | $[\Phi] = \text{Vs} = \text{Wb}$
Durchflutung (*magnetomotive force*) | $\Theta = N \cdot I = \oint \vec{H} \cdot d\vec{s}$ | $[\Theta] = \text{A}$
Magnetische Feldkonstante (*magnetic constant*) = ~~Permeabilität des Vakuums (*vacuum permeability*)~~ | $\mu_0$ | $[\mu_0] = \frac{\text{N}}{\text{A}^2}$
[Absolute] Permeabilität (*[absolute] permeability*) | $\mu$ | $[\mu] = \frac{\text{N}}{\text{A}^2}$
Relative Permeabilität (*relative permeability*) | $\mu_r = \frac{\mu}{\mu_0}$ | dimensionslos


### Der magnetische Kreis

**Definition:** geschlossener Pfad aus ferromagnetischem Material, durch den magnetischer Fluss geführt wird

**Relevant in vielen Anwendungen:**

- Elektromotoren (E-Autos, Industrie)
- Transformatoren (Energieversorgung)
- Induktives Laden (Smartphones, E-Autos)
- Sensoren und Aktuatoren
- Generatoren (Windkraftanlagen)

**Problem:** Wie dimensioniert man diese Systeme effizient?

![bg right:35% 100%](https://upload.wikimedia.org/wikipedia/commons/d/d0/Electromagnet_with_gap.svg)

### Herausforderung: Komplexe Magnetfelder

**Direkter Ansatz wäre kompliziert:**

- Berechnung von $\vec{B}$-Feldern in 3D
- Numerische Simulation (FEM) zeitaufwendig


**Eindimensionale Lösung: Der magnetische Kreis**

Eine *mathematische Analogie* zum elektrischen Stromkreis:

- Einfache Berechnungen wie bei Widerstandsnetzwerken
- Gute Näherung für viele praktische Fälle

**Voraussetzung:** Magnetischer Fluss „fließt“ hauptsächlich durch ferromagnetisches Material

![bg right:35% 100%](https://upload.wikimedia.org/wikipedia/commons/d/d0/Electromagnet_with_gap.svg)


### Grundidee

**Elektrischer Kreis:**

- Spannung treibt Strom durch Widerstand
- Strom „fließt“ durch Leiter
- $U = R \cdot I$ (Ohmsches Gesetz)

**Magnetischer Kreis:**

- Durchflutung treibt magnetischen Fluss durch magnetischen Widerstand
- Magnetischer Fluss „fließt“ durch ferromagnetisches Material
- $\Theta = R_m \cdot \Phi$ (analoges „Ohmsches Gesetz“)

**Wichtig:** Diese Analogie ist *mathematisch*, nicht physikalisch!
- Kein echter „Fluss“ von etwas
- Aber sehr nützlich für Berechnungen

### Das Durchflutungsgesetz: Unser Ausgangspunkt

**Erinnerung:** Durchflutungsgesetz (Ampèresches Gesetz) entlang eines geschlossenen Weges:

$$\Theta = N \cdot I = \oint \vec{H} \cdot d\vec{s}$$

- $\Theta$: magnetische **Durchflutung**
- $N \cdot I$: Windungszahl mal Strom in der Spule
- $\vec{H}$: magnetische Feldstärke

**Interpretation:**

- Die Durchflutung $\Theta$ ist wie eine „treibende Kraft“ für das Magnetfeld
- Entspricht der Spannung im elektrischen Kreis: $U = \int \vec{E} \cdot d\vec{s}$ (wichtiger Unterschied: $\int \vec{H} \cdot d\vec{s}$ ist nicht wegunabhängig!)

### Vereinfachung für homogene Kreise

**Annahme:** Homogener magnetischer Kreis

- Konstante Querschnittsfläche $A$
- Ein Material mit konstanter Permeabilität $\mu_r$
- Magnetfeld folgt dem Materialweg

**Dann wird das Linienintegral einfach:**

$$\Theta = \oint \vec{H} \cdot d\vec{s} = H \cdot \ell$$

- $H$: konstante magnetische Feldstärke im Material
- $\ell$: mittlere Weglänge des magnetischen Pfades

**Nächster Schritt:** Was hat das mit dem magnetischen Fluss zu tun?

### Der magnetische Fluss $\Phi$

**Definition:** Integral der magnetischen Flussdichte über eine Fläche

$$\Phi = \int_A \vec{B} \cdot d\vec{A}$$

**Für homogene Felder und Querschnitte:**

$$\Phi = B \cdot A$$

**Einheit:** Weber ($\text{Wb} = \text{Vs}$)

**Physikalische Bedeutung:**

- Maß für die Gesamtzahl der magnetischen Feldlinien durch eine Fläche


### Verbindung

**Materialgleichung:** Zusammenhang zwischen $B$ und $H$

$$B = \mu_0 \mu_r H$$

- $\mu_0 \approx 4\pi \times 10^{-7} \text{H/m}$
- $\mu_r$: relative Permeabilität (Eisen: $\mu_r \approx 1000$–$10000$)

**Einsetzen in den magnetischen Fluss:**

$$\Phi = B \cdot A = \mu_0 \mu_r H \cdot A$$

**Umstellen nach $H$:**

$$H = \frac{\Phi}{\mu_0 \mu_r A}$$

### Herleitung des magnetischen Widerstands

Kombinieren wir unsere Gleichungen:

$$\Theta = H \cdot \ell = \frac{\Phi}{\mu_0 \mu_r A} \cdot \ell = \frac{\ell}{\mu_0 \mu_r A} \cdot \Phi$$

Umschreiben in der Form $\Theta = R_m \cdot \Phi$:

$$\boxed{\Theta = R_m \cdot \Phi}$$

mit dem **magnetischen Widerstand**:

$$\boxed{R_m = \frac{\ell}{\mu_0 \mu_r A}}$$

Das ist das **„Ohmsche Gesetz“ des magnetischen Kreises**!

### Der magnetische Widerstand: Interpretation

$$R_m = \frac{\ell}{\mu_0 \mu_r A}$$

**Einheit:** $[R_m] = \frac{\text{A}}{\text{Wb}}$ (Ampere pro Weber)

**Der magnetische Widerstand wird größer, wenn:**

- ✓ Der Weg $\ell$ länger wird (mehr „Strecke“ für den Fluss)
- ✓ Die Querschnittsfläche $A$ kleiner wird (weniger „Platz“)
- ✓ Die Permeabilität $\mu_r$ kleiner wird (Material „leitet“ schlechter)

**Analog zum elektrischen Widerstand:** $R = \frac{\ell}{\sigma A}$

### Magnetischer Leitwert (Permeanz)

**Alternative Beschreibung:** Analog zum elektrischen Leitwert $G = \frac{1}{R}$

$$\Lambda = \frac{1}{R_m} = \frac{\mu_0 \mu_r A}{\ell}$$

**Einheit:** $[\Lambda] = \frac{\text{Wb}}{\text{A}} = \text{H}$ (Henry)

**Alternative Formulierung des "Ohmschen Gesetzes":**

$$\Phi = \Lambda \cdot \Theta$$

**Interpretation:**

- Der Leitwert gibt an, wie *leicht* magnetischer Fluss durch ein Material fließt
- Große Permeabilität $\mu_r$ → großer Leitwert → viel Fluss

### Zusammenfassung: Die Analogie

| Elektrischer Kreis | Magnetischer Kreis |
|---|---|
| Spannung $U=\int \vec{E} \cdot d\vec{s}$ | Durchflutung $\Theta = \oint \vec{H} \cdot d\vec{s}$ |
| Stromstärke $I=\int \vec{j} \cdot d\vec{A}$ | Magnetischer Fluss $\Phi = \int \vec{B} \cdot d\vec{A}$ |
| Widerstand $R = \frac{\ell}{\sigma A}$ | Mag. Widerstand $R_m = \frac{\ell}{\mu_0 \mu_r A}$ |
| Leitwert $G = \frac{1}{R}$ | Mag. Leitwert $\Lambda = \frac{1}{R_m}$ |
| $U = R \cdot I$ | $\Theta = R_m \cdot \Phi$ |

**Wichtig:** Rein mathematische Analogie, aber sehr nützlich für Berechnungen!

### Komplexere Kreise: Reihenschaltung

**Reale Situation:** Verschiedene Materialien im magnetischen Pfad

- Eisenkern verschiedener Querschnitte
- Luftspalte
- Verschiedene Materialien (Eisen, Ferrit, ...)

**Verhalten wie elektrische Widerstände in Reihe:**

$$R_{m,\text{ges}} = R_{m,1} + R_{m,2} + \ldots + R_{m,n}$$

**Durchflutungsgesetz:**

$$\Theta = \Phi \cdot R_{m,\text{ges}}$$

**Wichtig:** Der gleiche magnetische Fluss $\Phi$ durchfließt alle Abschnitte!
(Wie Strom in elektrischer Reihenschaltung)

### Praxisbeispiel: Elektromagnet mit Luftspalt

**Typische Anwendung:** Schaltschütz, Relais, Hubmagnet

**Aufbau:**

- Eisenkern mit Spule ($N$ Windungen, Strom $I$)
- Einstellbarer Luftspalt der Länge $\delta$
- Eisenweg: Länge $\ell_E$, Querschnitt $A$
- Luftspalt: Länge $\delta$, gleicher Querschnitt $A$

**Frage:** Wie groß ist der magnetische Fluss $\Phi$?

![bg right:40% 100%](https://upload.wikimedia.org/wikipedia/commons/d/d0/Electromagnet_with_gap.svg)

### Berechnung: Luftspalt und Eisenkern

**Eisenkern:**
$$R_{m,E} = \frac{\ell_E}{\mu_0 \mu_r A}$$

**Luftspalt:** ($\mu_r = 1$ für Luft)
$$R_{m,L} = \frac{\delta}{\mu_0 A}$$

**Gesamtwiderstand:**
$$R_{m,\text{ges}} = R_{m,E} + R_{m,L} = \frac{\ell_E}{\mu_0 \mu_r A} + \frac{\delta}{\mu_0 A}$$

**Magnetischer Fluss:**
$$\Phi = \frac{\Theta}{R_{m,\text{ges}}} = \frac{N \cdot I}{\frac{\ell_E}{\mu_0 \mu_r A} + \frac{\delta}{\mu_0 A}}$$

### Die überraschende Dominanz des Luftspalts

**Zahlenwerte (typisch):**

- Eisenweg: $\ell_E = 30$ cm, $\mu_r = 2000$
- Luftspalt: $\delta = 1$ mm

**Vergleich der Widerstände:**

$$\frac{R_{m,L}}{R_{m,E}} = \frac{\delta/(\mu_0 A)}{\ell_E/(\mu_0 \mu_r A)} = \frac{\delta \cdot \mu_r}{\ell_E} = \frac{0.001 \cdot 2000}{0.3} \approx 6.7$$

**Der Luftspalt ist 7× wichtiger, obwohl er 300× kürzer ist!**

**Grund:** Die sehr hohe Permeabilität von Eisen

### Praktische Näherung für kleine Luftspalte

Wenn $\mu_r \gg 1$ und $\delta \cdot \mu_r \gg \ell_E$, dann:

$$R_{m,L} \gg R_{m,E}$$

**Näherung:** Eisenwiderstand vernachlässigbar

$$\Phi \approx \frac{N \cdot I}{R_{m,L}} = \frac{N \cdot I \cdot \mu_0 \cdot A}{\delta}$$

Der Luftspalt bestimmt die magnetischen Eigenschaften!


## Elektromagnetische Induktion

1. Induktionsgesetz
2. [Selbstinduktion](#selbstinduktion)
3. [Energie des magnetischen Feldes](#energie-des-magnetischen-feldes)
4. [Kräfte an Grenzflächen](#kräfte-an-grenzflächen)


## Elektromagnetische Induktion: Grundprinzipien


- Bisher: el. Feld ruhender Ladungen (Elektrostatik) und mag. Feld konstanter Ströme (Magnetostatik)
- Sobald zeitliche Änderungen auftreten → Wechselwirkung zwischen elektrischen und magnetischen Feldern

**Induktion: ein zeitlich veränderliches Magnetfeld erzeugt („induziert“) ein elektrisches Feld**

### Induktion: technische Anwendungen

- Generatoren (Energieerzeugung)
- Transformatoren (Spannungswandlung)
- Elektromotoren (Antriebssysteme)
- Rekuperation bei Elektrofahrzeugen
- Induktive Ladesysteme (Smartphones, E-Autos)
- Sensoren (z.B. induktive Näherungsschalter)
- Induktionsherd
- Wirbelstrombremsen (Eisenbahn)
- ...


### Bewegung eines Leiterstücks im Magnetfeld
Lorentzkraft: $\vec{F}_m = q \cdot (\vec{v} \times \vec{B})$

Kraft durch elektrische Feldstärke: $\vec{F}_e = q \cdot \vec{E}$

Kräftegleichgewicht: $\vec{F}_e + \vec{F}_m = 0 \Longrightarrow \vec{E} = -\,\vec{v} \times \vec{B}$

Spannung an den Leiterenden: Mit $U = \vec{E} \cdot \vec{\ell}$ folgt:

$$U_\text{ind} = -\,(\vec{v} \times \vec{B}) \cdot \vec{\ell}$$

**Induzierte Spannung durch Bewegung im Magnetfeld**

![bg right:40% 100%](https://upload.wikimedia.org/wikipedia/commons/8/8f/Induction-by-motion-voltage.svg)

### Das Induktionsgesetz in allgemeiner Form

**Bewegtes Leiterstück:** $\vec{v}$, $\vec{B}$ und $\vec{\ell}$ jeweils senkrecht zueinander:

$$U_\text{ind} = -\left(\vec{v} \times \vec{B}\right) \cdot \vec{\ell} = -B \cdot \ell \cdot v = -B \cdot \ell \cdot \frac{ds}{dt} = -B \cdot \frac{dA}{dt}$$

**Allgemein gilt:**
$$U = -\frac{d\Phi}{dt}$$

### Zwei Möglichkeiten der Induktion

1. **Bewegungsinduktion:** Leiter und Magnetfeld bewegen sich relativ zueinander
2. **Ruheinduktion:** Magnetischer Fluss ändert sich bei ruhendem Leiter:

$$U = -\frac{d\Phi}{dt} = -\frac{d(A \cdot B)}{dt} = -\frac{dB}{dt} \cdot A - \frac{dA}{dt} \cdot B$$

Übergang auf N Windungen:
$$U = -N \cdot \frac{d\Phi}{dt} \tag{4.15}$$


### Induzierter Strom

Verbindet man die Enden des Leiterstücks über einen Widerstand $R$ (der sich nicht mitbewegt), so fließt ein **induzierter Strom**:

$$I = \frac{U}{R} = -\frac{1}{R} \cdot \frac{d\Phi}{dt}$$


![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/3/3d/Induction-by-motion-current.svg)

### Die Lenz’sche Regel

**Polarität der induzierten Spannung:**

Die induzierte Spannung ist stets so gerichtet, dass ein durch sie hervorgerufener Strom der Ursache ihrer Entstehung entgegenwirkt.


Für $\frac{d\Phi}{dt} > 0$ wirkt der induzierte Strom der Flussänderung entgegen

**Erklärung:** die Energie, die am Widerstand in Wärme umgesetzt wird, stammt aus der mechanischen Arbeit, die aufgewendet werden muss, um die Flussänderung zu erzeugen – die Lenz’sche Regel ist Ausdruck der **Energieerhaltung**.

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/4/42/Induction-by-motion-lenzs-law.svg)

### Das induzierte elektrische Wirbelfeld

**Wichtige Erkenntnis:** Bei Induktion ist die Spannung $U_\text{ind}$ **keine Potentialdifferenz**!

**Grund:**

- Das zeitlich veränderliche Magnetfeld erzeugt ein elektrisches **Wirbelfeld**
- Dieses Wirbelfeld ist **nicht konservativ** (im Gegensatz zum elektrostatischen Feld)
- Es existiert kein Potential $\varphi$ mit $U = \varphi_1 - \varphi_2$

**Die induzierte „Spannung“ ist vielmehr:**
$$U_\text{ind} = \oint \vec{E}_\text{ind} \cdot d\vec{s}$$

Ein Umlaufintegral entlang der Leiterschleife – das Integral über einen geschlossenen Weg ist **nicht Null**!

### Vergleich: Elektrostatik vs. Induktion

**Elektrostatik (statische Ladungen):**

Wirbelfreiheit des elektrischen Felds:
$$\oint \vec{E}_\text{stat} \cdot d\vec{s} = 0$$

Das elektrostatische Feld ist konservativ → es existiert ein Potential $\varphi$


**Elektromagnetische Induktion (zeitlich veränderliches Magnetfeld):**

Das induzierte elektrische Feld ist **nicht wirbelfrei**:
$$\oint \vec{E}_\text{ind} \cdot d\vec{s} = -\frac{d\Phi}{dt} = -\frac{d}{dt} \int \vec{B} \cdot d\vec{A}$$

Dies ist das **Faraday’sche Induktionsgesetz**

### Die fundamentalen Integralgleichungen der Elektrodynamik
| **Größe** | **Elektro-/Magnetostatik** | **Elektrodynamik** |
|-----------|-------------------|-------------------|
| **Elektrische Flussdichte $\vec{D}$** | $\oint_A \vec{D} \cdot d\vec{A} = Q$ | $\oint_A \vec{D} \cdot d\vec{A} = Q$ |
| | Gauß’sches Gesetz | Gauß’sches Gesetz |
| **Elektrische Feldstärke $\vec{E}$** | $\oint_s \vec{E} \cdot d\vec{s} = 0$ | $\oint_s \vec{E} \cdot d\vec{s} = -\frac{d\Phi}{dt}$ |
| | Wirbelfreiheit | **Induktionsgesetz** |
| **Magnetische Flussdichte $\vec{B}$** | $\oint_A \vec{B} \cdot d\vec{A} = 0$ | $\oint_A \vec{B} \cdot d\vec{A} = 0$ |
| | Keine magn. Monopole | Keine magn. Monopole |
| **Magnetische Feldstärke $\vec{H}$** | $\oint_s \vec{H} \cdot d\vec{s} = I$ | (noch nicht behandelt) |
| | Durchflutungsgesetz |  |

**Fazit:** Zeitlich veränderliche Felder koppeln elektrische und magnetische Phänomene!


### Beispiel: Bewegte Leiterschleife im Magnetfeld

**Situation:** Rechteckige Leiterschleife (Breite $b$, Höhe $h$) bewegt sich mit Geschwindigkeit $\vec{v}$ durch homogenes Magnetfeld $\vec{B}$

**Induktionsmechanismus:**

- Beim Eintreten: zunehmender magnetischer Fluss durch die Schleife
- Vollständig im Feld: konstanter Fluss → keine Induktion
- Beim Austreten: abnehmender Fluss durch die Schleife


## Selbstinduktion

### Wiederholung: Elektromagnetische Induktion

**Faraday'sches Induktionsgesetz:**
$$U_\text{ind} = -N \cdot \frac{d\Phi}{dt}$$

Magnetischer Fluss $\Phi=\int \vec{B} \cdot d\vec{A}$ durch eine Leiterschleife mit $N$ Windungen (Spule)

**Zwei Mechanismen der Induktion:**

1. **Bewegungsinduktion:** Leiter bewegt sich relativ zum Magnetfeld
   - $U_\text{ind} = -(\vec{v} \times \vec{B}) \cdot \vec{\ell} = -B \cdot \frac{dA}{dt}$

2. **Ruheinduktion:** Magnetfeld ändert sich bei ruhendem Leiter
   - $U_\text{ind} = -A \cdot \frac{dB}{dt}$

**Lenz'sche Regel:** Die induzierte Spannung wirkt ihrer Ursache entgegen (Energieerhaltung)

### Von der Induktion zur Selbstinduktion

**Bisher:** Externes Magnetfeld induziert Spannung: $U_\text{ind} = -N \cdot \frac{d\Phi}{dt}$

**Jetzt:** Stromfluss durch Spule → eigenes Magnetfeld $\Phi \propto I$

Bei Stromänderung ändert sich auch $\Phi$ → Induktion **in derselben Spule**!


**Selbstinduktion:** Die Spule induziert eine Spannung in sich selbst

![bg right:35% 80%](https://upload.wikimedia.org/wikipedia/commons/5/5b/Coil_right-hand_rule3.svg)

### Herleitung der Selbstinduktivität

**Ohmsches Gesetz des magnetischen Kreises:**
$$\Phi = \frac{\Theta}{R_m} = \frac{I \cdot N}{\frac{\ell_E}{\mu_0 \cdot \mu_r \cdot A}} = I \cdot N \cdot \frac{\mu_0 \cdot \mu_r \cdot A}{\ell_E}$$

Mit  $U_\text{ind} = -N \cdot \frac{d\Phi}{dt}$ folgt:

$$U_\text{ind} = -N \cdot \frac{d}{dt} \left( I \cdot N \cdot \frac{\mu_0 \cdot \mu_r \cdot A}{\ell_E} \right) $$

$$= -N^2 \cdot \frac{\mu_0 \cdot \mu_r \cdot A}{\ell_E} \cdot \frac{dI}{dt} = -L \cdot \frac{dI}{dt}$$

Proportionalitätskonstante $L$: **Induktivität** (Selbstinduktivität)

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/d/d1/EisenkernOhneLuftspalt.svg)

### Vorzeichen: Klemmenspannung vs. induzierte Spannung

**Wichtige Unterscheidung:**

- **Induzierte Spannung** $U_\text{ind}$: Umlaufintegral des elektrischen Wirbelfelds
    $$U_\text{ind} = \oint \vec{E}_\text{ind} \cdot d\vec{r} = -\frac{d\Phi}{dt}$$

- **Klemmenspannung** $U$: Messbare Spannung zwischen den Anschlüssen

Das Ringintegral wird entgegen der Pfeilrichtung der Klemmenspannung durchlaufen → **Vorzeichenwechsel!**

**Vorzeichenkonvention:** $U = -U_\text{ind} = +L \cdot \frac{dI}{dt}$

![bg right:25% 80%](https://upload.wikimedia.org/wikipedia/commons/3/30/Integration_Coil_modified.svg)


### Induktivität (*inductance*) einer Spule

$$L = \frac{N^2}{R_m} = N^2 \cdot \frac{\mu_0 \cdot \mu_r \cdot A}{\ell_E}$$

Einheit: $[L] =[\Lambda] = \frac{\text{Wb}}{\text{A}} = \text{H}$ (Henry)


**Zusammenhang zwischen Strom und induzierter Spannung:**
$$U = L \cdot \frac{dI}{dt}$$


### Induktivität bei ferromagnetischen Materialien

$$L = \frac{N^2}{R_m} = N^2 \cdot \frac{\mu_0 \cdot \mu_r \cdot A}{\ell_E}$$

- $\mu_r$ ist abhängig von $I$ → $L$ ist nicht konstant
- Effekt wird reduziert durch Spule mit **Luftspalt**

$$L = N^2 \cdot \frac{\mu_0 \cdot A}{\frac{\ell_E}{\mu_r} + \delta} \approx  N^2 \cdot  \frac{\mu_0 \cdot A}{\delta}$$

-> $\mu_r$ hat kaum einen Einfluss auf $L$ bei kleinem Luftspalt $\delta$



### Reihenschaltung von Induktivitäten

$$L_{\text{ges}} = L_1 + L_2 + \dots + L_n = \sum_i L_i$$

Die induzierten Spannungen addieren sich, der Strom ist überall  gleich

Intuition: Spulen verhalten sich wie eine einzige große Spule

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/f/ff/Inductors_in_series.svg)



### Parallelschaltung von Induktivitäten

$$\frac{1}{L_{\text{ges}}} = \frac{1}{L_1} + \frac{1}{L_2} + \dots + \frac{1}{L_n} = \sum_i \frac{1}{L_i}$$
Die Spannung ist überall gleich, die Ströme teilen sich auf

![bg right:40% 90%](https://upload.wikimedia.org/wikipedia/commons/e/e8/Inductors_in_parallel.svg)


### Herleitung: Parallelschaltung von Induktivitäten
$$U_\mathrm{ges} = L_\mathrm{ges} \cdot \frac{\Delta I_\mathrm{ges}}{\Delta t}$$

$$\frac{U_\mathrm{ges}}{L_\mathrm{ges}} = \frac{\Delta (I_1 + I_2 + \ldots + I_n)}{\Delta t}$$

$$= \frac{\Delta I_1}{\Delta t} + \frac{\Delta I_2}{\Delta t} + \ldots + \frac{\Delta I_n}{\Delta t}$$

$$= \frac{U_\mathrm{ges}}{L_1} + \frac{U_\mathrm{ges}}{L_2} + \ldots + \frac{U_\mathrm{ges}}{L_n}$$

$$= U_\mathrm{ges} \cdot \left(\frac{1}{L_1} + \frac{1}{L_2} + \ldots + \frac{1}{L_n}\right)$$

$$\frac{1}{L_\mathrm{ges}} = \frac{1}{L_1} + \frac{1}{L_2} + \ldots + \frac{1}{L_n}$$

## Energie des magnetischen Feldes

### Energiebilanz einer RL-Schaltung


**Maschengleichung:** 
$$U_0 = U_R + U_L = I \cdot R + L \cdot \frac{dI}{dt}$$

**Energie:** $dW = U \cdot I \cdot dt$

$$dW = U_0 \cdot I \cdot dt = I^2 \cdot R \cdot dt + L \cdot I \cdot \frac{dI}{dt} \cdot dt$$

**Interpretation:** Energie wird teils am Widerstand $R$ in Wärme umgesetzt, teils im Magnetfeld der Spule gespeichert

**Gespeicherte Energie in einer Induktivität:**
$$W_m = \int_0^I L \cdot I \, dI = \frac{1}{2} \cdot L \cdot I^2$$

![bg right:30% 90%](https://upload.wikimedia.org/wikipedia/commons/0/0e/RLCircuitWithSwitch.svg)


### Alternative Berechnung der magnetischen Energie

Falls die Induktivität $L$ nicht bekannt oder nicht konstant ist:

**Gespeicherte Energie des Magnetfeldes:**
$$W_m = \frac{1}{2} \cdot H \cdot B \cdot V = \frac{1}{2} \cdot \frac{B^2}{\mu_0 \cdot \mu_r} \cdot V$$

**Interpretation:** Die Energiedichte $w_m = \frac{W_m}{V} = \frac{1}{2} \cdot H \cdot B$ beschreibt die im Magnetfeld gespeicherte Energie pro Volumeneinheit

**Anwendung:** Bei ferromagnetischen Materialien mit nichtlinearer Kennlinie

### Hinweis: Energieerhaltung bei zwei Permanentmagneten

**Situation:** Zwei Permanentmagnete mit gleicher Magnetisierung $M$ nähern sich an

Bei unendlicher Entfernung:

$$W_{\text{tot},\infty} = 2 \cdot W_m$$

Bei Annäherung auf Abstand $d$:

$$W_{\text{tot},d} = 2 \cdot W_m + W_{\text{Wechselwirkung}}$$

**Zusammenhang zwischen Arbeit und Kraft**

$$W_{\text{Wechselwirkung}} = -\int_\infty^d F \, ds$$

### Hinweis: Energieerhaltung bei zwei Permanentmagneten

Die Änderung der Feldenergie kann als Potential interpretiert werden.

Dies gilt aber nur unter folgenden Bedingungen:

- Magnetisierung der Magnete bleibt konstant
- Keine Wirbelströme oder sonstige Verluste
- Keine elektromagnetischen Wellen werden abgestrahlt

## Kräfte an Grenzflächen

### Herleitung der Maxwell'schen Zugspannung

**Situation:** Eisenjoch mit Luftspalt der Länge $\ell$ und Querschnittsfläche $A$

**Energieänderung bei Spaltvergrößerung:**
$$dW = \frac{B^2}{2 \cdot \mu_0} \cdot dV = \frac{B^2}{2 \cdot \mu_0} \cdot 2 \cdot A \cdot d\ell$$

(Faktor 2: Energie in beiden Luftspalten)

**Mit $dW = F' \cdot d\ell$ folgt:**
$$F' = \frac{dW}{d\ell} = \frac{B^2}{\mu_0} \cdot A$$


### Maxwell'sche Zugspannung

**Kraft am einzelnen Luftspalt:**
$$F = \frac{B^2}{2 \cdot \mu_0} \cdot A$$

**Mechanische Spannung (Kraft pro Fläche):**
$$\sigma = \frac{F}{A} = \frac{B^2}{2 \cdot \mu_0}$$

**Anwendungen:**

- Hubmagnete (Kräne, Magnetventile)
- Elektromagnetische Relais
- Magnetische Verriegelungen
