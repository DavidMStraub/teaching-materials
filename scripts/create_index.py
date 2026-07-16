#!/usr/bin/env python3
"""Generate index.html for the repo root and each course subfolder.

Replaces the former create-index.sh. Discovers presentations (HTML files with
a matching .md source, plus PDFs), reads course metadata from course.yaml
(fallback: footer of the first .md file, then the folder name), and renders
the Jinja2 templates in scripts/templates/.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader

REPO_ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_DIR = Path(__file__).resolve().parent / "templates"
REPO_URL = "https://github.com/DavidMStraub/teaching-materials"
EXCLUDED_DIRS = {"scripts", "assets", "__pycache__", "slprj"}


@dataclass
class Deck:
    basename: str  # filename without extension, relative to its directory
    number: str | None
    title: str
    html: bool = False
    pdf: bool = False

    @property
    def sort_key(self):
        if self.number and self.number.isdigit():
            return (0, int(self.number), self.title.lower())
        if self.number:  # extra material numbered X1, X2, ...
            return (1, int(self.number[1:]), self.title.lower())
        return (2, 0, self.title.lower())


@dataclass
class Course:
    dir: str
    title: str
    binder: bool = False
    decks: list[Deck] = field(default_factory=list)


def parse_deck_name(basename: str) -> tuple[str | None, str]:
    """Split a filename into (lecture number, display title).

    "Elektrotechnik - 02 Elektrisches Feld" -> ("02", "Elektrisches Feld")
    "CAx-Programmierung - X1 Versionsverwaltung" -> ("X1", "Versionsverwaltung")
    "build123d Cheat Sheet" -> (None, "build123d Cheat Sheet")
    """
    title = basename.replace("_", " ")
    if " - " in title:
        title = title.split(" - ", 1)[1]
    match = re.match(r"^(X?\d+)\s+(.+)$", title)
    if match:
        return match.group(1), match.group(2)
    return None, title


def find_decks(directory: Path) -> list[Deck]:
    decks: dict[str, Deck] = {}

    def deck_for(basename: str) -> Deck:
        if basename not in decks:
            number, title = parse_deck_name(basename)
            decks[basename] = Deck(basename=basename, number=number, title=title)
        return decks[basename]

    for html_file in directory.glob("*.html"):
        # Only list HTML with a .md source (skips index.html and iframe-only files)
        if html_file.name != "index.html" and html_file.with_suffix(".md").is_file():
            deck_for(html_file.stem).html = True
    for pdf_file in directory.glob("*.pdf"):
        deck_for(pdf_file.stem).pdf = True

    return sorted(decks.values(), key=lambda d: d.sort_key)


def title_from_md_footer(directory: Path) -> str | None:
    """Course name from the footer of the first .md file's frontmatter,
    e.g. "footer: Elektrotechnik – 01 Einführung" -> "Elektrotechnik"."""
    for md_file in sorted(directory.glob("*.md")):
        parts = md_file.read_text(encoding="utf-8").split("---")
        if len(parts) < 3:
            continue
        frontmatter = yaml.safe_load(parts[1])
        footer = (frontmatter or {}).get("footer")
        if footer:
            return str(footer).split(" – ")[0]
    return None


def read_course(directory: Path) -> Course:
    title = None
    binder = False
    course_yaml = directory / "course.yaml"
    if course_yaml.is_file():
        meta = yaml.safe_load(course_yaml.read_text(encoding="utf-8")) or {}
        title = meta.get("title")
        binder = bool(meta.get("binder", False))
    if not title:
        title = title_from_md_footer(directory)
    if not title:
        title = directory.name.replace("-", " ").title()
    return Course(dir=directory.name, title=title, binder=binder, decks=find_decks(directory))


def main() -> None:
    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR), autoescape=True)

    courses = []
    for directory in sorted(REPO_ROOT.iterdir()):
        if not directory.is_dir() or directory.name.startswith(".") or directory.name in EXCLUDED_DIRS:
            continue
        if not any(directory.glob("*.md")):
            continue
        course = read_course(directory)
        courses.append(course)
        (directory / "index.html").write_text(
            env.get_template("course.html.j2").render(
                page_title=f"{course.title} – Teaching Materials",
                course=course,
                repo_url=REPO_URL,
            ),
            encoding="utf-8",
        )
        print(f"✓ {directory.name}/index.html ({len(course.decks)} documents)")

    root_decks = find_decks(REPO_ROOT)
    (REPO_ROOT / "index.html").write_text(
        env.get_template("index.html.j2").render(
            page_title="David Straub – Teaching Materials",
            courses=courses,
            decks=root_decks,
            repo_url=REPO_URL,
        ),
        encoding="utf-8",
    )
    print(f"✓ index.html ({len(courses)} courses, {len(root_decks)} root documents)")


if __name__ == "__main__":
    main()
