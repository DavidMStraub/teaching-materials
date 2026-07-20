"""Simuliertes Batteriepack für das Batterielabor (Praktikum 3+).

Acht Zellen (Nummer 1 bis 8) sind an das Pack angeschlossen. Die
Zellspannung hängt vom Ladezustand ab (Spannungskennlinie, dieselbe Form
wie die Entladekurve aus Praktikum 1) und vom Strom: je höher der Strom,
desto stärker sackt die Spannung durch den Innenwiderstand der Zelle ein.

Verwendung:

    from zelle import lese_spannung

    u = lese_spannung(3, 0.5, 1.0)   # Zelle 3, Ladezustand 50 %, 1.0 A
    print(u)

lese_spannung(nummer, ladezustand, strom_A):
    nummer       1 bis 8
    ladezustand  1.0 (voll) bis 0.0 (leer)
    strom_A      Entladestrom in A

Gleiche Eingaben ergeben immer dieselbe Ausgabe (kein Zufall). Ein
ValueError wird ausgelöst, wenn:

  – ladezustand außerhalb von 0.0 bis 1.0 liegt (meistens ein Zeichen,
    dass die Abbruchbedingung der eigenen Schleife nicht ganz stimmt)
  – der gewählte Strom für diese Zelle bei diesem Ladezustand
    unrealistisch hoch ist (die Zelle könnte diesen Strom nicht liefern)

Sie dürfen diese Datei gern öffnen und lesen – verstehen müssen Sie sie
noch nicht.
"""

import math

_ANZAHL_ZELLEN = 8

# Innenwiderstand je Zelle in Ohm. Zelle 6 ist bewusst deutlich höher
# (schwache Zelle) – bei hohem Strom bricht ihre Spannung zuerst ein.
_R_INNEN = [0.032, 0.028, 0.035, 0.030, 0.041, 0.150, 0.033, 0.029]

# Toleranz für ladezustand-Grenzen: kleine Überschreitungen durch
# Fließkomma-Rundung (z. B. -1e-16 nach vielen Subtraktionen) sollen
# nicht fälschlich als Fehler gemeldet werden – ein echter Logikfehler
# in der Abbruchbedingung liegt deutlich außerhalb dieser Toleranz.
_TOLERANZ = 1e-6


def _pruefe_nummer(nummer):
    if nummer < 1 or nummer > _ANZAHL_ZELLEN:
        raise ValueError(
            f"Es gibt nur die Zellen 1 bis {_ANZAHL_ZELLEN}, nicht {nummer}"
        )


def _pruefe_ladezustand(ladezustand):
    if ladezustand < -_TOLERANZ or ladezustand > 1 + _TOLERANZ:
        raise ValueError(
            f"ladezustand muss zwischen 0.0 und 1.0 liegen, war {ladezustand} "
            "- prüfen Sie die Abbruchbedingung Ihrer Schleife"
        )


def _ocv(ladezustand):
    """Ruhespannung (ohne Stromfluss) in Abhängigkeit vom Ladezustand."""
    ladezustand = min(1.0, max(0.0, ladezustand))  # Toleranzbereich einfangen
    entnommen = 1 - ladezustand
    return (
        3.6
        + 0.6 * math.exp(-6 * entnommen)
        - 0.15 * entnommen
        - 0.9 * math.exp(-12 * (1 - entnommen))
    )


def lese_spannung(nummer, ladezustand, strom_A):
    """Gibt die Klemmenspannung der Zelle in V zurück."""
    _pruefe_nummer(nummer)
    _pruefe_ladezustand(ladezustand)
    u = _ocv(ladezustand) - strom_A * _R_INNEN[nummer - 1]
    if u < 0:
        raise ValueError(
            f"Bei strom_A={strom_A} wird die Spannung von Zelle {nummer} "
            "rechnerisch negativ – dieser Strom ist für die Zelle in diesem "
            "Ladezustand unrealistisch hoch"
        )
    return round(u, 3)
