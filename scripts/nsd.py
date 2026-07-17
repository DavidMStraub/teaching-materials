#!/usr/bin/env python3
"""Generate Nassi-Shneiderman (Struktogramm) SVGs from YAML sources.

Replaces the manual Structorizer workflow. Sources live next to the course
(e.g. programmieren/nsd-src/*.yaml), output goes to the course assets.

Usage:
    python3 scripts/nsd.py programmieren/nsd-src -o programmieren/assets/nsd
    python3 scripts/nsd.py programmieren/nsd-src/maximum.yaml -o programmieren/assets/nsd

Source format (YAML):
    title: finde_maximum(werte)      # optional bold caption above the diagram
    body:
      - "maximum = werte[0]"         # plain string -> instruction box
      - if: "wert > maximum"         # branching (Ja links, Nein rechts)
        then: ["maximum = wert"]
        else: []                     # empty branch renders the empty-set sign
      - while: "solange i < 3"       # loop, inverted-L shape
        body: [...]
      - for: "für jedes wert in werte"   # same shape as while, foreach wording
        body: [...]

House notation (Küpper exam style / course conventions):
    assignments with "=" (never the arrow), German keywords ("solange",
    "für ... in ..."), "Eingabe:"/"Ausgabe:", "Rückgabe (return) von ...",
    prose statements allowed.
"""

from __future__ import annotations

import argparse
import html
from pathlib import Path

import yaml

# Geometry / style
FONT = "Fira Sans, sans-serif"
FONT_SIZE = 15
CH_W = 8.1          # rough average character width for Fira Sans @ 15px
PAD = 9             # horizontal text padding inside boxes
ROW_H = 32          # height of an instruction / loop header row
IF_HEAD_H = 46      # height of the branching header (condition + Ja/Nein)
INDENT = 26         # width of the loop's left strip (the inverted L)
EMPTY_W = 44        # minimum width of an empty branch column
STROKE = "#1f2328"
MARGIN = 4
TITLE_H = 28


def text_width(s: str) -> float:
    return len(s) * CH_W + 2 * PAD


class Node:
    def measure(self) -> tuple[float, float]:
        raise NotImplementedError

    def render(self, out: list[str], x: float, y: float, w: float, h: float) -> None:
        raise NotImplementedError


def box(out: list[str], x: float, y: float, w: float, h: float) -> None:
    out.append(
        f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" '
        f'fill="white" stroke="{STROKE}" stroke-width="1.3"/>'
    )


def label(out: list[str], cx: float, cy: float, s: str, size: float = FONT_SIZE) -> None:
    out.append(
        f'<text x="{cx:.1f}" y="{cy:.1f}" font-family="{FONT}" font-size="{size}" '
        f'fill="{STROKE}" text-anchor="middle" dominant-baseline="middle">{html.escape(s)}</text>'
    )


class Instruction(Node):
    def __init__(self, text: str):
        self.text = text

    def measure(self):
        return (text_width(self.text), ROW_H)

    def render(self, out, x, y, w, h):
        box(out, x, y, w, h)
        label(out, x + w / 2, y + h / 2 + 1, self.text)


class Sequence(Node):
    def __init__(self, children: list[Node]):
        self.children = children or [Instruction("∅")]

    def measure(self):
        sizes = [c.measure() for c in self.children]
        return (max(s[0] for s in sizes), sum(s[1] for s in sizes))

    def render(self, out, x, y, w, h):
        sizes = [c.measure() for c in self.children]
        natural = sum(s[1] for s in sizes)
        extra = h - natural  # stretch the last child to fill equalized branches
        cy = y
        for i, (child, (_, ch)) in enumerate(zip(self.children, sizes)):
            if i == len(self.children) - 1:
                ch += extra
            child.render(out, x, cy, w, ch)
            cy += ch


class Loop(Node):
    """while and for share the inverted-L shape; only the header text differs."""

    def __init__(self, header: str, body: Sequence):
        self.header = header
        self.body = body

    def measure(self):
        bw, bh = self.body.measure()
        return (max(text_width(self.header), INDENT + bw), ROW_H + bh)

    def render(self, out, x, y, w, h):
        # One outer rectangle; the inset body's borders carve out the inner
        # edge, leaving the header + left strip as a single connected white
        # inverted L (no internal border, as in proper NSD notation).
        bh = h - ROW_H
        box(out, x, y, w, h)
        label(out, x + w / 2, y + ROW_H / 2 + 1, self.header)
        self.body.render(out, x + INDENT, y + ROW_H, w - INDENT, bh)


class Branch(Node):
    def __init__(self, cond: str, then: Sequence, other: Sequence):
        self.cond = cond
        self.then = then
        self.other = other

    # The condition text lives in the band above TEXT_BAND; the free width
    # there is limited by the two diagonals, so the header must be wide
    # enough that the text fits between them.
    TEXT_BAND = 24

    def measure(self):
        tw, th = self.then.measure()
        ew, eh = self.other.measure()
        tw, ew = max(tw, EMPTY_W), max(ew, EMPTY_W)
        free = 1 - self.TEXT_BAND / IF_HEAD_H
        w = max(tw + ew, (text_width(self.cond) + 12) / free)
        return (w, IF_HEAD_H + max(th, eh))

    def render(self, out, x, y, w, h):
        tw, _ = self.then.measure()
        ew, _ = self.other.measure()
        tw, ew = max(tw, EMPTY_W), max(ew, EMPTY_W)
        split = w * tw / (tw + ew)
        bh = h - IF_HEAD_H

        box(out, x, y, w, IF_HEAD_H)
        out.append(
            f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{x + split:.1f}" y2="{y + IF_HEAD_H:.1f}" '
            f'stroke="{STROKE}" stroke-width="1.3"/>'
        )
        out.append(
            f'<line x1="{x + w:.1f}" y1="{y:.1f}" x2="{x + split:.1f}" y2="{y + IF_HEAD_H:.1f}" '
            f'stroke="{STROKE}" stroke-width="1.3"/>'
        )
        # Condition sits above the apex, clamped between the diagonals at
        # text height so they never cross the text, however asymmetric the
        # branches are.
        half = text_width(self.cond) / 2 - PAD + 5
        frac = self.TEXT_BAND / IF_HEAD_H
        lo = x + split * frac + half
        hi = x + w - (w - split) * frac - half
        cx = min(max(x + split, lo), hi)
        label(out, cx, y + 13, self.cond)
        label(out, x + split / 2 - 6, y + IF_HEAD_H - 10, "Ja", size=13)
        label(out, x + split + (w - split) / 2 + 6, y + IF_HEAD_H - 10, "Nein", size=13)

        self.then.render(out, x, y + IF_HEAD_H, split, bh)
        self.other.render(out, x + split, y + IF_HEAD_H, w - split, bh)


def parse(spec) -> Node:
    if isinstance(spec, str):
        return Instruction(spec)
    if isinstance(spec, dict):
        if "if" in spec:
            return Branch(
                spec["if"],
                Sequence([parse(c) for c in spec.get("then", [])]),
                Sequence([parse(c) for c in spec.get("else", [])]),
            )
        if "while" in spec:
            return Loop(spec["while"], Sequence([parse(c) for c in spec.get("body", [])]))
        if "for" in spec:
            return Loop(spec["for"], Sequence([parse(c) for c in spec.get("body", [])]))
    raise ValueError(f"Unknown element: {spec!r}")


def build_svg(doc: dict) -> str:
    root = Sequence([parse(c) for c in doc["body"]])
    w, h = root.measure()
    title = doc.get("title")
    title_h = TITLE_H if title else 0

    out: list[str] = []
    if title:
        out.append(
            f'<text x="{MARGIN}" y="{MARGIN + 15}" font-family="{FONT}" font-size="{FONT_SIZE + 1}" '
            f'font-weight="bold" fill="{STROKE}">{html.escape(title)}</text>'
        )
    root.render(out, MARGIN, MARGIN + title_h, w, h)

    total_w, total_h = w + 2 * MARGIN, h + title_h + 2 * MARGIN
    body = "\n".join(out)
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{total_w:.0f}" height="{total_h:.0f}" '
        f'viewBox="0 0 {total_w:.0f} {total_h:.0f}">\n{body}\n</svg>\n'
    )


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("source", help="YAML file or directory of YAML files")
    ap.add_argument("-o", "--output", required=True, help="output directory for SVGs")
    args = ap.parse_args()

    src = Path(args.source)
    out_dir = Path(args.output)
    out_dir.mkdir(parents=True, exist_ok=True)

    files = sorted(src.glob("*.yaml")) if src.is_dir() else [src]
    for f in files:
        doc = yaml.safe_load(f.read_text(encoding="utf-8"))
        svg = build_svg(doc)
        target = out_dir / (f.stem + ".svg")
        target.write_text(svg, encoding="utf-8")
        print(f"✓ {target}")


if __name__ == "__main__":
    main()
