#!/bin/bash

# Convert Marp Markdown lecture slides to a linear PDF document via Pandoc + Typst.
# Typst renders SVG natively; image downloading uses the same cache/retry/integrity
# logic as the old xelatex pipeline.

set -euo pipefail

command -v pandoc >/dev/null 2>&1 || { echo "Error: pandoc is required but not installed."; exit 1; }
command -v typst  >/dev/null 2>&1 || { echo "Error: typst is required but not installed."; exit 1; }

INPUT_FILE="${1:-programmieren/Programmieren - Folien.md}"
OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
INPUT_DIR=$(dirname "$INPUT_FILE")
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Fira Sans/Mono and Libertinus Math OTFs: locally they live in the texlive
# tree; in CI they are downloaded to a dir given via TYPST_FONT_PATHS (which
# typst picks up on its own). Only pass --font-path for dirs that exist.
FONT_ARGS=()
for d in "/usr/share/texlive/texmf-dist/fonts/opentype/public/fira" \
         "/usr/share/texlive/texmf-dist/fonts/opentype/public/libertinus-fonts"; do
    [[ -d "$d" ]] && FONT_ARGS+=("--pdf-engine-opt=--font-path=$d")
done

echo "Converting: $INPUT_FILE -> $OUTPUT_FILE"

# Footer from Marp frontmatter becomes the page header text
FOOTER=$(grep -m1 '^footer:' "$INPUT_FILE" | sed 's/^footer: *//' || true)

# Marp bg directives stay in the alt text; the Lua filter turns their size
# hints (bg right:30% etc.) into image widths
TEMP_MD="$TEMP_DIR/doc.md"
cp "$INPUT_FILE" "$TEMP_MD"

# Annotate each heading with its GitHub-style anchor ID so that internal links
# (e.g. Marp Gliederung slide) resolve correctly in the PDF. Also extract the
# subtitle (bold paragraph right after the H1 title) and print it to stdout.
SUBTITLE=$(python3 - "$TEMP_MD" << 'PYEOF'
import re, sys

def sanitize(anchor):
    # typst labels choke on non-XID chars like superscripts (², ³, °)
    return ''.join(c for c in anchor
                   if c.isalpha() or c.isdecimal() or c in '-_')

def github_anchor(text):
    text = re.sub(r'\*+|`|_+', '', text)   # strip inline markdown
    text = text.lower()
    text = re.sub(r'[^\w\s-]', '', text)   # remove &, ,, . etc.  (\w = letters/digits/_)
    text = re.sub(r'\s', '-', text.strip()) # each space → hyphen (preserves double-space → --)
    return sanitize(text)

def annotate(line):
    m = re.match(r'^(#{1,6}) (.+?)\s*(\r?\n?)$', line)
    if not m:
        return line
    hashes, title, eol = m.group(1), m.group(2), m.group(3)
    if re.search(r'\{[^}]*#[^}]*\}$', title):  # already has explicit {#id}
        return line
    return f'{hashes} {title} {{#{github_anchor(title)}}}{eol}'

path = sys.argv[1]
out, in_fence = [], None
seen_h1 = False
subtitle_pending = False
for line in open(path).read().splitlines(keepends=True):
    fence = re.match(r'^(```+|~~~+)', line)
    if in_fence:
        if fence and fence.group(1)[0] == in_fence[0] and len(fence.group(1)) >= len(in_fence):
            in_fence = None
    elif fence:
        in_fence = fence.group(1)
    else:
        if subtitle_pending and line.strip():
            subtitle_pending = False
            m = re.match(r'^\*\*(.+)\*\*\s*$', line.strip())
            if m:
                print(m.group(1))  # captured by the shell as SUBTITLE
                continue           # drop the line from the body
        if not seen_h1 and re.match(r'^# \S', line):
            seen_h1 = True
            subtitle_pending = True
        line = annotate(line)
        # sanitize internal link targets with the same rule as heading ids
        line = re.sub(r'\]\(#([^)]+)\)', lambda m: f'](#{sanitize(m.group(1))})', line)
    out.append(line)
open(path, 'w').write(''.join(out))
PYEOF
)

# Page geometry and fonts must go through template variables: pandoc's conf()
# runs after header-includes and would override #set page/#set text from there.
DEFAULTS_YAML="$TEMP_DIR/defaults.yaml"
cat > "$DEFAULTS_YAML" << 'EOF'
variables:
  papersize: a4
  margin:
    x: 2.5cm
    y: 2.5cm
  mainfont: Libertinus Serif
  fontsize: 11pt
  lang: de
  page-numbering: "1"
EOF

# Typst styling (header-includes: everything conf() does not itself set)
HEADER_TYP="$TEMP_DIR/header.typ"
cat > "$HEADER_TYP" << 'EOF'
// Compat shim: typst 0.15 dropped angle.l/angle.r, pandoc still emits them
// for \langle/\rangle
#let angle = symbol("∠", ("l", "⟨"), ("r", "⟩"))

// Generous spacing between blocks; relaxed line height
#set par(leading: 0.8em, spacing: 1.8em)
#set list(indent: 0.5em, spacing: 1.1em)
#set enum(indent: 0.5em, spacing: 1.1em)

// Heading hierarchy: bold Fira Sans, clear sizes, air above/below
#show heading: set text(font: "Fira Sans", weight: "semibold")
#show heading: set block(above: 2.4em, below: 1.2em)
#show heading.where(level: 1): set text(size: 18pt)
#show heading.where(level: 2): set text(size: 14pt)
#show heading.where(level: 3): set text(size: 12pt)

// Math in the matching Libertinus face instead of typst's default
#show math.equation: set text(font: "Libertinus Math")

// Inline code: Fira Mono on a gray pill like Marp renders it — the background
// gives the code its own visual frame, so exact size match matters less
#show raw: set text(font: "Fira Mono", size: 0.9em)
#show raw.where(block: false): it => box(
  fill: luma(245),
  inset: (x: 3pt),
  outset: (y: 3pt),
  radius: 2pt,
  it,
)

// Code blocks: Fira Mono on a light tinted card
#show raw.where(block: true): set text(font: "Fira Mono", size: 0.85em)

// Inline code in headings: Fira Mono Bold to match the semibold Fira Sans.
// Must come after the rules above — the later show-set rule wins.
#show heading: it => {
  show raw: set text(font: "Fira Mono", size: 1em, weight: "bold")
  it
}
#show raw.where(block: true): it => block(
  fill: luma(247),
  stroke: 0.5pt + luma(225),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  it,
)

// Images: natural size, capped at text width (explicit sizes come from the
// Lua filter, which translates Marp w:/width: hints into width percentages)

// Running header: course footer text left, current section right
#set page(
  header: context {
    if counter(page).get().first() > 1 {
      let hs = query(selector(heading.where(level: 1)).before(here()))
      set text(size: 9pt, font: "Fira Sans")
      grid(
        columns: (1fr, auto),
        [FOOTERPLACEHOLDER],
        if hs.len() > 0 { emph(hs.last().body) },
      )
      v(-0.6em)
      line(length: 100%, stroke: 0.4pt)
    }
  },
)
EOF
# Escape sed replacement metacharacters (&, \) in the footer text
ESCAPED_FOOTER=$(printf '%s' "$FOOTER" | sed 's/[&\\|]/\\&/g')
sed -i "s|FOOTERPLACEHOLDER|$ESCAPED_FOOTER|" "$HEADER_TYP"

# Custom template partial replacing pandoc's default conf(): left-aligned
# Fira Sans title block (no inset), ragged-right body
CONF_TYP="$TEMP_DIR/conf.typ"
cat > "$CONF_TYP" << 'EOF'
#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 2.5cm, y: 2.5cm),
  paper: "a4",
  lang: "de",
  region: "DE",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  pagenumbering: "1",
  doc,
) = {
  set document(title: title)
  set page(paper: paper, margin: margin, numbering: pagenumbering, columns: cols)
  set par(justify: false)
  set text(lang: lang, region: region, font: font, size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    block(below: 18pt, text(font: "Fira Sans", weight: "semibold", size: 26pt, title))
  }
  if subtitle != none {
    block(below: 1.5em, text(font: "Fira Sans", size: 15pt, subtitle))
  }
  doc
}
EOF

# ---------------------------------------------------------------------------
# Image handling (ported from old xelatex script)
# ---------------------------------------------------------------------------

# Placeholder shown in PDF when an image cannot be downloaded
MISSING_IMAGE="$TEMP_DIR/missing.svg"
cat > "$MISSING_IMAGE" << 'SVGEOF'
<svg width="200" height="50" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="50" fill="#ffcccc" stroke="red" stroke-width="2"/>
  <text x="100" y="30" font-family="Arial" font-size="14" fill="red" text-anchor="middle">Image Missing</text>
</svg>
SVGEOF

# Persistent cache so re-runs don't re-download everything
CACHE_DIR="${HOME}/.cache/public-slides-images"
if mkdir -p "$CACHE_DIR" 2>/dev/null && [[ -w "$CACHE_DIR" ]]; then
    IMAGES_DIR="$CACHE_DIR"
    echo "Using image cache: $CACHE_DIR ($(ls -1 "$CACHE_DIR" 2>/dev/null | wc -l) files cached)"
else
    IMAGES_DIR="$TEMP_DIR/images"
    mkdir -p "$IMAGES_DIR"
fi

# Verify a downloaded file is actually an image (not an HTML error page)
check_image_integrity() {
    local f="$1"
    local mime
    mime=$(file --mime-type -b "$f" 2>/dev/null || echo "")
    case "$mime" in
        image/png)              tail -c 12 "$f" | grep -aq "IEND" ;;
        image/jpeg)             [ "$(tail -c 2 "$f" | od -An -tx1 | tr -d ' \n')" = "ffd9" ] ;;
        image/svg+xml|text/xml) grep -aq "</svg>" "$f" ;;
        image/*)                return 0 ;;
        *)                      return 1 ;;  # text/html, text/plain error pages, ...
    esac
}

# Use a Lua filter to extract only image src URLs (not hyperlinks)
EXTRACT_LUA="$TEMP_DIR/extract_urls.lua"
cat > "$EXTRACT_LUA" << 'EOF'
function Image(el)
  io.stderr:write("URL: " .. el.src .. "\n")
end
EOF

echo "Extracting image URLs..."
pandoc --lua-filter="$EXTRACT_LUA" "$TEMP_MD" -o /dev/null 2>"$TEMP_DIR/urls.txt" || true
IMAGE_URLS=$(grep "^URL: " "$TEMP_DIR/urls.txt" | sed 's/^URL: //' | grep '^https\?://' | sort -u || true)

declare -A url_map
failed_images=()

while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    echo "Processing: $url"

    # Determine extension from URL (strip query/fragment)
    _base="${url%%\?*}"; _base="${_base%%\#*}"
    ext="${_base##*.}"
    [[ ${#ext} -gt 5 || "$ext" == "$_base" ]] && ext="bin"
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    unset _base

    url_hash=$(echo -n "$url" | md5sum | cut -d' ' -f1)
    cached_file="$IMAGES_DIR/${url_hash}.${ext}"
    # A previous run may have stored it under its detected (true) extension
    for candidate in "$IMAGES_DIR/${url_hash}".*; do
        [[ -f "$candidate" ]] && cached_file="$candidate" && break
    done

    # Check cache validity
    download_success=false
    if [[ -f "$cached_file" ]] && [[ -s "$cached_file" ]]; then
        mime=$(file --mime-type -b "$cached_file" 2>/dev/null || echo "")
        if [[ "$mime" != "text/html" ]] && check_image_integrity "$cached_file"; then
            echo "  -> Cache hit: $cached_file"
            download_success=true
        else
            echo "  -> Cache invalid (HTML or corrupt), re-downloading"
            rm -f "$cached_file"
        fi
    fi

    # Download with retries
    if [[ $download_success == false ]]; then
        max_retries=3; retry=0
        while [[ $retry -lt $max_retries ]] && [[ $download_success == false ]]; do
            # No curl-internal --retry: on 429 curl would honor Retry-After
            # and sleep for minutes; the outer loop already retries
            curl -s -L --max-time 60 --connect-timeout 10 \
                -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
                -H "Accept: image/png,image/jpeg,image/webp,image/svg+xml,image/*,*/*;q=0.8" \
                -H "Referer: https://github.com/" \
                "$url" -o "$cached_file" 2>/dev/null || true
            sleep 0.3
            if [[ -s "$cached_file" ]]; then
                mime=$(file --mime-type -b "$cached_file" 2>/dev/null || echo "")
                if [[ "$mime" == "text/html" ]]; then
                    echo "  -> Got HTML (not an image), skipping"
                    rm -f "$cached_file"; break
                elif check_image_integrity "$cached_file"; then
                    download_success=true
                else
                    echo "  -> Integrity check failed, retry $((retry+1))/$max_retries"
                    rm -f "$cached_file"
                fi
            fi
            retry=$((retry + 1))
        done
    fi

    if [[ $download_success == true ]]; then
        # Rename to the true format if the URL extension lied (typst picks
        # its decoder by extension, e.g. .png that is actually WebP)
        mime=$(file --mime-type -b "$cached_file" 2>/dev/null || echo "")
        case "$mime" in
            image/png)     true_ext="png" ;;
            image/jpeg)    true_ext="jpg" ;;
            image/gif)     true_ext="gif" ;;
            image/webp)    true_ext="webp" ;;
            image/svg+xml) true_ext="svg" ;;
            *)             true_ext="" ;;
        esac
        if [[ -n "$true_ext" && "${cached_file##*.}" != "$true_ext" ]]; then
            echo "  -> True format is $true_ext (URL said ${cached_file##*.}), renaming"
            mv "$cached_file" "${cached_file%.*}.${true_ext}"
            cached_file="${cached_file%.*}.${true_ext}"
        fi
        echo "  -> OK: $cached_file"
        url_map["$url"]="$cached_file"
    else
        echo "  -> FAILED, using placeholder"
        failed_images+=("$url")
        url_map["$url"]="$MISSING_IMAGE"
    fi
done <<< "$IMAGE_URLS"

if [[ ${#failed_images[@]} -gt 0 ]]; then
    printf '\nWARNING: %d image(s) could not be downloaded:\n' "${#failed_images[@]}"
    printf '  %s\n' "${failed_images[@]}"
fi

# Build a Lua filter that rewrites image src to local paths at AST level
REPLACE_LUA="$TEMP_DIR/replace_images.lua"
cat > "$REPLACE_LUA" << 'EOF'
local url_map = {
EOF
for url in "${!url_map[@]}"; do
    safe_url=$(printf '%s' "$url"              | sed 's/\\/\\\\/g; s/"/\\"/g')
    safe_path=$(printf '%s' "${url_map[$url]}" | sed 's/\\/\\\\/g; s/"/\\"/g')
    printf '  ["%s"] = "%s",\n' "$safe_url" "$safe_path" >> "$REPLACE_LUA"
done
printf '}\nlocal input_dir = "%s"\nlocal work_dir = "%s"\nlocal missing_image = "%s"\n' \
    "$(realpath "$INPUT_DIR")" "$(pwd)" "$MISSING_IMAGE" >> "$REPLACE_LUA"
cat >> "$REPLACE_LUA" << 'EOF'

-- Marp slide canvas: 1280px / ~33.87cm wide. Size hints are relative to the
-- slide, so translate them into percentages of the text width to keep the
-- author's relative sizing intent.
local SLIDE_W_PX = 1280
local SLIDE_W_CM = 33.87

function Image(el)
  if url_map[el.src] then
    el.src = url_map[el.src]
  elseif not el.src:match("^https?://") and not el.src:match("^/") then
    -- Local image: make the path absolute so typst finds it from its temp
    -- dir; paths may be relative to the deck dir or to the repo root
    local function exists(p)
      local f = io.open(p, "r")
      if f then f:close(); return true end
      return false
    end
    if exists(input_dir .. "/" .. el.src) then
      el.src = input_dir .. "/" .. el.src
    elseif exists(work_dir .. "/" .. el.src) then
      el.src = work_dir .. "/" .. el.src
    else
      io.stderr:write("MARKDOWN ISSUE: local image not found: " .. el.src .. "\n")
      el.src = missing_image
    end
  end

  local alt = pandoc.utils.stringify(el.caption)
  local width_pct = nil
  local has_directive = false
  local is_bg, bg_panel, bg_zoom = false, nil, nil
  for tok in alt:gmatch("%S+") do
    local val, unit = tok:match("^w:(%d+%.?%d*)(%a*)$")
    if not val then val, unit = tok:match("^width:(%d+%.?%d*)(%a*)$") end
    local pct = tok:match("^w:(%d+%.?%d*)%%$") or tok:match("^width:(%d+%.?%d*)%%$")
    if pct then
      has_directive = true
      width_pct = tonumber(pct)
    elseif val then
      has_directive = true
      local n = tonumber(val)
      if unit == "cm" then
        width_pct = n / SLIDE_W_CM * 100
      elseif unit == "mm" then
        width_pct = n / (SLIDE_W_CM * 10) * 100
      else -- Marp default unit: px
        width_pct = n / SLIDE_W_PX * 100
      end
    elseif tok == "bg" then
      has_directive, is_bg = true, true
    elseif tok:match("^left:(%d+%.?%d*)%%$") or tok:match("^right:(%d+%.?%d*)%%$") then
      bg_panel = tonumber(tok:match(":(%d+%.?%d*)%%$"))
    elseif tok:match("^(%d+%.?%d*)%%$") then
      bg_zoom = tonumber(tok:match("^(%d+%.?%d*)%%$"))
    elseif tok:match("^h:") or tok:match("^height:") then
      has_directive = true -- height hints: drop, width/natural size decides
    elseif tok:match("^%a+:") then
      has_directive = true -- other Marp directives (opacity:, blur:, ...): drop
    end
  end
  if is_bg then
    -- bg right:X% means an X%-wide side panel; the bare Y% is zoom within it
    width_pct = (bg_panel or 60) * (bg_zoom or 100) / 100
  end

  if width_pct then
    if width_pct > 100 then width_pct = 100 end
    el.attributes.width = string.format("%.0f%%", width_pct)
  end
  if has_directive then
    el.caption = {} -- directives are not a real caption
  end
  return el
end

-- Standalone images become Figures whose caption copies the alt text; drop
-- captions that are only Marp directives (bg, w:410, right:30%, ...)
local function is_directive_caption(s)
  if s == "" then return false end
  for tok in s:gmatch("%S+") do
    if tok ~= "bg" and not tok:match("^%a+:%S+$") and not tok:match("^%d+%.?%d*%%$") then
      return false
    end
  end
  return true
end

function Figure(el)
  if is_directive_caption(pandoc.utils.stringify(el.caption)) then
    return el.content -- unwrap: no caption, no "Abbildung N" numbering
  end
end

-- Internal links whose target heading is not in this document (e.g. a
-- Gliederung entry pointing into another deck part) would make typst abort
-- with "label does not exist"; unlink them instead and flag it.
function Pandoc(doc)
  local ids = {}
  doc.blocks:walk({ Header = function(h)
    if h.identifier ~= "" then ids[h.identifier] = true end
  end })
  doc.blocks = doc.blocks:walk({ Link = function(l)
    local target = l.target
    if target:sub(1, 1) == "#" and not ids[target:sub(2)] then
      io.stderr:write("MARKDOWN ISSUE: internal link target not found: " .. target .. "\n")
      return l.content
    end
  end })
  return doc
end
EOF

# ---------------------------------------------------------------------------

SUBTITLE_ARGS=()
[[ -n "$SUBTITLE" ]] && SUBTITLE_ARGS+=(-M "subtitle=$SUBTITLE")

pandoc "$TEMP_MD" \
    -o "$OUTPUT_FILE" \
    --defaults="$DEFAULTS_YAML" \
    --pdf-engine=typst \
    "${FONT_ARGS[@]}" \
    --pdf-engine-opt=--root=/ \
    --resource-path="$INPUT_DIR" \
    --lua-filter="$REPLACE_LUA" \
    --shift-heading-level-by=-1 \
    -V template="$CONF_TYP" \
    "${SUBTITLE_ARGS[@]}" \
    --include-in-header="$HEADER_TYP" \
    --highlight-style=tango

echo "Success! PDF created: $OUTPUT_FILE"
