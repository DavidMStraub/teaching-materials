---
marp: true
theme: hm
paginate: true
language: de
footer: Numerik – D. Straub
headingDivider: 3
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


### Ingenieurinformatik, Teilmodul 2: Numerik für Ingenieure (L1172)

- 2 SWS Seminaristischer Unterricht, wöchentlich
- 2 SWS Übung, 14-tägig (2 Gruppen, Einteilung am Ende), Start 24.3.
- Prüfung: schriftlich, 60 Minuten, 40% der Gesamtnote für Modul Ingenieurinformatik

### Ziel dieser Lehrveranstaltung

- Verständnis grundlegender numerischer Methoden zur Lösung technisch-wissenschaftlicher Probleme
- Anwendung und praktische Umsetzung dieser Methoden in einer wissenschaftlichen Entwicklungsumgebung (Matlab)


### Verhältnis zur Ingenierinformatik 1

Wir bauen auf den in Teil 1 erworbenen Kompetenzen im wissenschaftlichen Programmieren auf, insbesondere:

- Variablen, Schleifen, Funktionen
- Arbeiten mit Datenstrukturen
- Visualisierung von Funktionen


Die Konzepte in beiden Lehrveranstaltungen sind unabhängig von der verwendeten Programmiersprache/Entwicklungsumgebung (Python, Matlab) übertragbar!


### Was ist Numerik?

**Numerik** = Mathematische Methoden zur **Lösung von Problemen mit dem Computer**

- Keine analytische Lösung existiert
- Problem zu komplex für exakte Rechnung
- Nur Näherungen sind praktisch möglich
- **Überall im Ingenieuralltag: FEM, CFD, Regelung, Optimierung, ...**


### Numerische Methoden in dieser Lehrveranstaltung

- Lineare Algebra
- Interpolation
- Nullstellenbestimmung
- Integration
- Ableitung
- Differentialgleichungen


### Was ist Matlab?

> Matlab ist eine proprietäre Programmiersprache und Entwicklungsumgebung des Unternehmens MathWorks zur Lösung mathematischer Probleme und zur grafischen Darstellung der Ergebnisse.

Wikipedia



### Matlab: grobe Analogie zu den Python-Tools aus Teil 1


| Funktionalität | Matlab | Python |
|----------------|--------|--------|
| Numerische Berechnungen | Matlab (Sprache) | NumPy |
| Interaktive Eingabe | Matlab Command Window | Python-Terminal |
| Plotten | Matlab Plot | Matplotlib |
| Entwicklungsumgebung | Matlab Desktop | z.B. VS Code |
| Interaktive Notebooks | Matlab Live Editor | Jupyter Notebooks |
| Erweiterungen | Toolboxes | externe Pakete |
| Skript-Dateien | .m-Dateien | .py-Dateien |


### Hausaufgaben

- Matlab installieren (Studentenversion, siehe Moodle)
    - alternativ: Zugang zu Matlab Online beantragen

## Organisatorisches

### Einteilung der Übungsgruppen

Jetzt in Moodle!


| Gruppe | Tag | Uhrzeit | Raum | Start |
|--------|-----|---------|------|-------|
| A1 | Di | 11:45 | B355 | 24.3. |
| A2 | Di | 11:45 | B355 | 31.3. |
| B1 | Do | 15:15 | B350a | 26.3. |
| B2 | Do | 15:15 | B350a | 1.3. |
| C1 | Di | 13:30 | B355 | 24.3. |
| C2 | Di | 13:30 | B355 | 31.3. |

Bitte Gruppeneinteilung strikt einhalten

### Matrix-Chat

Chatgruppe für Fragen, Diskussionen, Ankündigungen, ...

https://matrix.hm.edu -> FK03 LRB Numerik

**Bitte beitreten!**



