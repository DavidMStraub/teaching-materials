"""Modul-Code für die Notebooks in Binder: Stand der Referenzlösung Einheit 8.

Die Folien importieren daraus wie die Studierenden aus ihrem Repo, z.B.
`from w08.modul import ModulParam, zelle_bauen`.
"""

from dataclasses import dataclass

from cadquery import func as cf


@dataclass
class ModulParam:
    zell_b: float = 148.0  # mm, Zellbreite
    zell_h: float = 98.0  # mm, Zellhöhe
    zell_t: float = 11.0  # mm, Zelldicke
    zell_r: float = 6.0  # mm, Eckradius der Zelle
    n_zellen: int = 12  # Anzahl Zellen im Stapel
    spacer: float = 1.5  # mm, Kompressionspad zwischen den Zellen
    tab_l: float = 12.0  # mm, Überstand des Tabs über die kurze Seite
    tab_b: float = 24.0  # mm, Tabbreite
    tab_t: float = 6.0  # mm, Tabdicke, mittig in der Zelldicke
    platten_rand: float = 12.0  # mm, Endplatte größer als Zellquerschnitt
    platten_t: float = 8.0  # mm, Endplattendicke
    zapfen_d: float | None = 16.0  # mm, Zentrierbohrung; None = ohne Bohrung


def pruefe(p: ModulParam) -> None:
    """Lehnt Parameter ab, die kein sinnvolles Modul beschreiben."""
    if p.zell_b <= 0 or p.zell_h <= 0 or p.zell_t <= 0:
        raise ValueError(
            f"Zellmaße müssen positiv sein, waren {p.zell_b}, {p.zell_h}, {p.zell_t}"
        )
    if p.zell_r <= 0:
        raise ValueError(f"zell_r muss positiv sein, war {p.zell_r}")
    if p.platten_t <= 0:
        raise ValueError(f"platten_t muss positiv sein, war {p.platten_t}")
    if p.n_zellen < 1:
        raise ValueError(f"n_zellen muss mindestens 1 sein, war {p.n_zellen}")
    if p.spacer < 0:
        raise ValueError(f"spacer darf nicht negativ sein, war {p.spacer}")
    # Aufgabe 4: Die Bohrung muss in die schmale Seite der Endplatte passen.
    if p.zapfen_d is not None and not 0 < p.zapfen_d < p.zell_h + p.platten_rand:
        raise ValueError(
            f"zapfen_d muss zwischen 0 und {p.zell_h + p.platten_rand} liegen,"
            f" war {p.zapfen_d}"
        )


def ein_solid(s: cf.Shape) -> cf.Solid:
    """Guard: Das Ergebnis muss genau ein Volumenkörper sein."""
    solids = s.Solids()
    assert len(solids) == 1, f"erwartet 1 Solid, erhalten {len(solids)}"
    return solids[0]


def zelle_bauen(p: ModulParam) -> cf.Solid:
    """Zelle ab z = 0 mit einem Tab an der kurzen Seite +x."""
    pruefe(p)
    # Gestaltungsvorgabe: Radius knapp unter der halben schmalen Seite kappen
    r = min(p.zell_r, min(p.zell_b, p.zell_h) / 2 - 0.1)
    profil = cf.face(cf.rect(p.zell_b, p.zell_h))
    roh = cf.extrude(profil, (0, 0, p.zell_t))
    rund = cf.fillet(roh, roh.edges("|Z"), r)
    tab = cf.box(p.tab_l, p.tab_b, p.tab_t)
    x = p.zell_b / 2 + p.tab_l / 2
    z = (p.zell_t - p.tab_t) / 2
    return ein_solid(rund + tab.moved(cf.Location((x, 0, z))))


def stapel_hoehe(p: ModulParam) -> float:
    pitch = p.zell_t + p.spacer
    return (p.n_zellen - 1) * pitch + p.zell_t


def stapel_bauen(p: ModulParam) -> cf.Shape:
    """Zellstapel ab z = 0, jede zweite Zelle 180° um Z gedreht."""
    pruefe(p)
    zelle = zelle_bauen(p)
    pitch = p.zell_t + p.spacer
    stapel: cf.Shape = zelle
    for i in range(1, p.n_zellen):
        rz = 180 if i % 2 else 0
        stapel = stapel + zelle.moved(rz=rz).moved(cf.Location((0, 0, i * pitch)))
    return stapel


def endplatten(p: ModulParam) -> cf.Shape:
    """Beide Endplatten; die untere beginnt bei z = 0, der Stapel bei z = platten_t."""
    pruefe(p)
    unten: cf.Shape = cf.box(
        p.zell_b + p.platten_rand, p.zell_h + p.platten_rand, p.platten_t
    )
    if p.zapfen_d is not None:
        # Werkzeug ragt oben und unten 1 mm über die Platte (h + ε)
        bohrung = cf.cylinder(d=p.zapfen_d, h=p.platten_t + 2).moved(
            cf.Location((0, 0, -1))
        )
        unten = ein_solid(unten - bohrung)
    z_mitte = p.platten_t + stapel_hoehe(p) / 2
    oben = unten.mirror("XY", basePointVector=(0, 0, z_mitte))
    return unten + oben
