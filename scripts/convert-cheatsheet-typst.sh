#!/bin/bash

# Render a Markdown cheat sheet as a compact two-column A4 PDF via Pandoc + Typst.

set -euo pipefail

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

FONT_ARGS=()
for d in "/usr/share/texlive/texmf-dist/fonts/opentype/public/fira"; do
    [[ -d "$d" ]] && FONT_ARGS+=("--font-path" "$d")
done

cat > "$TEMP_DIR/header.typ" << 'EOF'
#set par(justify: false, leading: 0.5em, spacing: 0.7em)
#set table(inset: (x: 3pt, y: 2.5pt), stroke: none, fill: (_, y) => if calc.odd(y) { luma(245) })
#show table: set align(left)
#show table: set block(spacing: 0.6em)
#show heading.where(level: 1): set text(size: 14pt)
#show heading.where(level: 1): set block(above: 0pt, below: 0.6em)
#show heading.where(level: 2): set text(size: 10pt, fill: rgb("#1a4f8b"))
#show heading.where(level: 2): set block(above: 1em, below: 0.5em)
#show raw: set text(size: 7.5pt)
#show raw.where(block: true): set block(fill: luma(245), inset: 4pt, radius: 2pt, width: 100%)

EOF

pandoc "$INPUT_FILE" -t typst --standalone \
    -V columns=2 -V fontsize=8pt -V papersize=a4 \
    -V margin.x=1.2cm -V margin.y=1.2cm \
    -V mainfont="Fira Sans" -V codefont="Fira Mono" \
    --include-in-header="$TEMP_DIR/header.typ" \
    -o "$TEMP_DIR/doc.typ"

# Pandoc keeps the escaped pipe of pipe tables inside code spans
sed -i 's/\\|/|/g' "$TEMP_DIR/doc.typ"
# Left-aligned text; wider first table column for the code
sed -i -e 's/set par(justify: true)/set par(justify: false)/' \
       -e 's/^    columns: (50%, 50%),$/    columns: (60%, 40%),/' \
       -e 's/^    columns: 2,$/    columns: (60%, 40%),/' "$TEMP_DIR/doc.typ"

typst compile "${FONT_ARGS[@]}" "$TEMP_DIR/doc.typ" "$OUTPUT_FILE"
echo "PDF created: $OUTPUT_FILE"
