#!/bin/bash

# Script to convert Markdown lecture notes to PDF via Pandoc
# Handles SVG images by downloading and converting them to PDF

set -e

# Clear Pandoc's cache to avoid stale references
rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/pandoc" 2>/dev/null || true

# Clear any stale tex2pdf directories
rm -rf /tmp/tex2pdf.* 2>/dev/null || true

# Check if required tools are installed
command -v pandoc >/dev/null 2>&1 || { echo "Error: pandoc is required but not installed."; exit 1; }
command -v inkscape >/dev/null 2>&1 || command -v rsvg-convert >/dev/null 2>&1 || { echo "Error: inkscape or rsvg-convert is required but not installed."; exit 1; }
command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1 || { echo "Error: curl or wget is required but not installed."; exit 1; }

# Show tool versions
echo "Pandoc version:"
pandoc --version | head -n 3
echo "Inkscape version:"
inkscape --version 2>/dev/null || echo "Not found"
echo "RSVG version:"
rsvg-convert --version 2>/dev/null || echo "Not found"

# Get input file (default: Programmieren - Folien.md)
INPUT_FILE="${1:-Programmieren - Folien.md}"
OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
TEMP_DIR=$(mktemp -d)
TEMP_MD="$TEMP_DIR/temp.md"

# Use cache directory for images if available, otherwise temp
CACHE_DIR="${HOME}/.cache/public-slides-images"
if mkdir -p "$CACHE_DIR" 2>/dev/null && [[ -w "$CACHE_DIR" ]]; then
    IMAGES_DIR="$CACHE_DIR"
    cache_file_count=$(ls -1 "$CACHE_DIR" 2>/dev/null | wc -l)
    echo "Using cache directory: $CACHE_DIR ($cache_file_count files cached)"
else
    IMAGES_DIR="$TEMP_DIR/images"
    mkdir -p "$IMAGES_DIR"
    echo "Using temporary directory: $IMAGES_DIR (cache not available)"
fi

# Get the directory of the input file for resolving relative paths
INPUT_DIR=$(dirname "$INPUT_FILE")
INPUT_FILENAME=$(basename "$INPUT_FILE")

echo "Converting: $INPUT_FILE -> $OUTPUT_FILE"
echo "Temporary directory: $TEMP_DIR"

# Create a placeholder image for missing/failed downloads
MISSING_IMAGE="$TEMP_DIR/missing.svg"
cat > "$MISSING_IMAGE" << 'EOF'
<svg width="200" height="50" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="50" fill="#ffcccc" stroke="red" stroke-width="2"/>
  <text x="100" y="30" font-family="Arial" font-size="14" fill="red" text-anchor="middle">Image Missing</text>
</svg>
EOF

# Copy input file to temp location
cp "$INPUT_FILE" "$TEMP_MD"

# Find all image URLs in the markdown file (SVG, PNG, JPG, etc.)
echo "Searching for images..."

# Create Lua filter to extract URLs
EXTRACT_LUA="$TEMP_DIR/extract_urls.lua"
cat > "$EXTRACT_LUA" << 'EOF'
function Image(el)
  if string.match(el.src, "^http") then
    io.stderr:write("URL: " .. el.src .. "\n")
  end
end
EOF

# Extract all image URLs using Pandoc (more reliable than grep)
echo "Extracting URLs with Pandoc..."
# Capture stderr, filter for our URL prefix
pandoc --lua-filter="$EXTRACT_LUA" "$INPUT_FILE" -o /dev/null 2> "$TEMP_DIR/urls.txt" || true
IMAGE_URLS=$(grep "^URL: " "$TEMP_DIR/urls.txt" | sed 's/^URL: //' || true)

counter=1
declare -A url_map
failed_images=()

while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    
    echo "Processing: $url"
    
    # Get file extension from URL path only (strip query string/fragment first)
    _url_no_query="${url%%\?*}"
    _url_no_query="${_url_no_query%%\#*}"
    _url_file="${_url_no_query##*/}"
    ext="${_url_file##*.}"
    # If no dot in basename or basename was empty, use generic extension
    [[ "$ext" == "$_url_file" || -z "$_url_file" ]] && ext="bin"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    unset _url_no_query _url_file
    
    if [[ $url == http* ]]; then
        # Create a hash of the URL for cache filename
        # NOTE: Cache is keyed by URL, so if URL changes, new file is downloaded.
        # If URL stays same but content changes, cached version is used (this is intentional).
        url_hash=$(echo -n "$url" | md5sum | cut -d' ' -f1)
        cached_file="$IMAGES_DIR/${url_hash}.${ext}"
        
        # Check if file already exists in cache and is valid
        is_valid_cache=false
        if [[ -f "$cached_file" ]] && [[ -s "$cached_file" ]]; then
             file_size=$(stat -f%z "$cached_file" 2>/dev/null || stat -c%s "$cached_file" 2>/dev/null)
             if [[ $file_size -gt 100 ]]; then
                 # Check mime type to ensure it's not an error page or empty file
                 mime_type=$(file --mime-type -b "$cached_file" 2>/dev/null || echo "application/octet-stream")
                 if [[ "$mime_type" != "text/html" ]]; then
                    is_valid_cache=true
                 else
                    echo "  -> Found cached text/html (likely error page), invalidating: $cached_file"
                 fi
             fi
        fi

        if [[ "$is_valid_cache" == "true" ]]; then
            downloaded_file="$cached_file"
            download_success=true
            echo "  -> Using cached file: $cached_file"
        else
            # Download remote image with retries


            downloaded_file="$cached_file"
            max_retries=3
            retry=0
            download_success=false
            
            while [[ $retry -lt $max_retries ]] && [[ $download_success == false ]]; do
                if command -v curl >/dev/null 2>&1; then
                    curl -s -L --max-time 60 --connect-timeout 10 --retry 2 \
                        -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
                        -H "Accept: image/png,image/jpeg,image/webp,image/svg+xml,image/*,*/*;q=0.8" \
                        -H "Accept-Language: en-US,en;q=0.5" \
                        -H "Referer: https://github.com/" \
                        "$url" -o "$downloaded_file" || true
                    sleep 0.5  # Be more respectful to servers
                    file_size=0
                    if [[ -f "$downloaded_file" ]]; then
                        file_size=$(wc -c < "$downloaded_file" 2>/dev/null || echo 0)
                    fi
                    if [[ -s "$downloaded_file" ]] && [[ $file_size -gt 100 ]]; then
                        mime_type=$(file --mime-type -b "$downloaded_file" 2>/dev/null || echo "application/octet-stream")
                        if [[ "$mime_type" == "text/html" ]]; then
                             echo "  -> Error: Downloaded content is HTML (likely 403/404 page), not image. Mime: $mime_type"
                             echo "  -> Head of content:"
                             head -n 5 "$downloaded_file" | sed 's/^/     /'
                             rm -f "$downloaded_file" 2>/dev/null || true
                        else
                             download_success=true
                        fi
                    else
                        echo "  -> Retry $((retry + 1))/$max_retries (file_size=$file_size)"
                        rm -f "$downloaded_file" 2>/dev/null || true
                    fi
                else
                    wget -q --timeout=60 --tries=3 \
                        --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
                        --header="Accept: image/png,image/jpeg,image/webp,image/svg+xml,image/*,*/*;q=0.8" \
                        --header="Accept-Language: en-US,en;q=0.5" \
                        --header="Referer: https://github.com/" \
                        -O "$downloaded_file" "$url" || true
                    sleep 0.5  # Be more respectful to servers
                    file_size=0
                    if [[ -f "$downloaded_file" ]]; then
                        file_size=$(wc -c < "$downloaded_file" 2>/dev/null || echo 0)
                    fi
                    if [[ -s "$downloaded_file" ]] && [[ $file_size -gt 100 ]]; then
                        mime_type=$(file --mime-type -b "$downloaded_file" 2>/dev/null || echo "application/octet-stream")
                        if [[ "$mime_type" == "text/html" ]]; then
                             echo "  -> Error: Downloaded content is HTML (likely 403/404 page), not image"
                             rm -f "$downloaded_file" 2>/dev/null || true
                        else
                             download_success=true
                        fi
                    else
                        echo "  -> Retry $((retry + 1))/$max_retries (file_size=$file_size)"
                        rm -f "$downloaded_file" 2>/dev/null || true
                    fi
                fi
                retry=$((retry + 1))
            done
        fi
        
        if [[ $download_success == false ]]; then
            echo "  -> ERROR: Failed to download after $max_retries attempts"
            failed_images+=("$url")
            # Use missing image placeholder
            url_map["$url"]="$MISSING_IMAGE"
            continue
        fi

        # Re-detect actual format from file content (handles URLs with no/wrong extension)
        actual_mime=$(file --mime-type -b "$downloaded_file" 2>/dev/null || echo "")
        detected_ext=""
        case "$actual_mime" in
            image/svg+xml) detected_ext="svg" ;;
            image/png)     detected_ext="png" ;;
            image/jpeg)    detected_ext="jpg" ;;
            image/gif)     detected_ext="gif" ;;
        esac
        if [[ -n "$detected_ext" && "$ext_lower" != "$detected_ext" ]]; then
            echo "  -> Detected actual format: $detected_ext (URL extension was: ${ext_lower})"
            new_cached_file="${downloaded_file%.*}.${detected_ext}"
            if [[ "$downloaded_file" != "$new_cached_file" ]]; then
                mv "$downloaded_file" "$new_cached_file"
                downloaded_file="$new_cached_file"
            fi
            ext_lower="$detected_ext"
        fi

        # Convert SVG to PDF
        if [[ $ext_lower == "svg" ]]; then
            pdf_file="$IMAGES_DIR/image_$counter.pdf"
            
            if command -v inkscape >/dev/null 2>&1; then
                inkscape "$downloaded_file" --export-filename="$pdf_file" --export-type=pdf >/dev/null 2>&1
                if [[ $? -ne 0 || ! -f "$pdf_file" ]]; then
                    echo "  -> Failed to convert SVG with inkscape, trying rsvg-convert"
                    if command -v rsvg-convert >/dev/null 2>&1; then
                        if rsvg-convert -f pdf -o "$pdf_file" "$downloaded_file" && [[ -f "$pdf_file" ]]; then
                            url_map["$url"]="$pdf_file"
                            echo "  -> Downloaded and converted to: $pdf_file"
                        else
                            echo "  -> Failed to convert SVG"
                            continue
                        fi
                    else
                        echo "  -> Failed to convert SVG"
                        continue
                    fi
                else
                    url_map["$url"]="$pdf_file"
                    echo "  -> Downloaded and converted to: $pdf_file"
                fi
            else
                if rsvg-convert -f pdf -o "$pdf_file" "$downloaded_file" && [[ -f "$pdf_file" ]]; then
                    url_map["$url"]="$pdf_file"
                    echo "  -> Downloaded and converted to: $pdf_file"
                else
                    echo "  -> Failed to convert SVG"
                    continue
                fi
            fi
            
            counter=$((counter + 1))
        # Convert GIF to PNG
        elif [[ $ext_lower == "gif" ]]; then
            png_file="$IMAGES_DIR/image_$counter.png"
            
            if command -v convert >/dev/null 2>&1; then
                convert "$downloaded_file" "$png_file" || true
            elif command -v ffmpeg >/dev/null 2>&1; then
                ffmpeg -i "$downloaded_file" -y "$png_file" >/dev/null 2>&1 || true
            fi
            
            if [[ -f "$png_file" ]]; then
                url_map["$url"]="$png_file"
                echo "  -> Downloaded and converted to: $png_file"
                counter=$((counter + 1))
            else
                echo "  -> Failed to convert GIF to PNG. Using original."
                url_map["$url"]="$downloaded_file"
                echo "  -> Downloaded to: $downloaded_file"
                counter=$((counter + 1))
            fi
        else
            # Keep non-SVG/GIF images as-is
            url_map["$url"]="$downloaded_file"
            echo "  -> Downloaded to: $downloaded_file"
            counter=$((counter + 1))
        fi
    else
        # Local image file
        # Try both as absolute and relative to input file
        local_path=""
        if [[ -f "$url" ]]; then
            local_path="$url"
        elif [[ -f "$INPUT_DIR/$url" ]]; then
            local_path="$INPUT_DIR/$url"
        fi
        
        if [[ -n "$local_path" ]]; then
            # Convert SVG to PDF
            if [[ $ext_lower == "svg" ]]; then
                pdf_file="$IMAGES_DIR/image_$counter.pdf"
                
                if command -v inkscape >/dev/null 2>&1; then
                    if inkscape "$local_path" --export-filename="$pdf_file" --export-type=pdf 2>/dev/null && [[ -f "$pdf_file" ]]; then
                        url_map["$url"]="$pdf_file"
                        echo "  -> Converted to: $pdf_file"
                    else
                        echo "  -> Failed to convert SVG"
                        continue
                    fi
                else
                    if rsvg-convert -f pdf -o "$pdf_file" "$local_path" && [[ -f "$pdf_file" ]]; then
                        url_map["$url"]="$pdf_file"
                        echo "  -> Converted to: $pdf_file"
                    else
                        echo "  -> Failed to convert SVG"
                        continue
                    fi
                fi
                
                counter=$((counter + 1))
            else
                # Copy non-SVG images
                copied_file="$IMAGES_DIR/image_$counter.$ext"
                cp "$local_path" "$copied_file"
                url_map["$url"]="$copied_file"
                echo "  -> Copied to: $copied_file"
                counter=$((counter + 1))
            fi
        else
            echo "  -> Warning: Local file not found: $url (tried $INPUT_DIR/$url)"
        fi
    fi
done <<< "$IMAGE_URLS"

# Check if any images failed to download
if [ ${#failed_images[@]} -gt 0 ]; then
    echo ""
    echo "=========================================="
    echo "WARNING: Failed to download ${#failed_images[@]} image(s):"
    for failed_url in "${failed_images[@]}"; do
        echo "  - $failed_url"
    done
    echo "=========================================="
    echo "Proceeding with missing images (will use placeholders)..."
    # Do not exit, try to continue
    # exit 1 
fi

echo "Copying images to Pandoc working directory..."
# Copy all images to temp directory for Pandoc
PANDOC_IMAGES_DIR="$TEMP_DIR/images"
mkdir -p "$PANDOC_IMAGES_DIR"
declare -A final_url_map
image_count=0
for url in "${!url_map[@]}"; do
    source_file="${url_map[$url]}"
    filename=$(basename "$source_file")
    # Sanitize: strip query string chars that LaTeX/pandoc cannot handle in filenames
    filename="${filename%%\?*}"
    dest_file="$PANDOC_IMAGES_DIR/$filename"
    if [[ -f "$source_file" ]]; then
        cp "$source_file" "$dest_file"
        # Use absolute path because Pandoc's xelatex changes directory during processing
        final_url_map["$url"]="$dest_file"
        image_count=$((image_count + 1))
        echo "  Copied: $filename ($(stat -c%s "$dest_file" 2>/dev/null || stat -f%z "$dest_file" 2>/dev/null) bytes)"
    else
        echo "  WARNING: Source file not found: $source_file"
        # Track missing files
        failed_images+=("$url (copy failed)")
    fi
done
echo "Copied $image_count images to $PANDOC_IMAGES_DIR"

# Check if any files failed to copy
if [ ${#failed_images[@]} -gt 0 ]; then
    echo ""
    echo "=========================================="
    echo "WARNING: Failed to prepare ${#failed_images[@]} image(s):"
    for failed_url in "${failed_images[@]}"; do
        echo "  - $failed_url"
    done
    echo "=========================================="
    echo "Proceeding with missing images..."
    # echo "Cannot create PDF with missing images. Skipping this file."
    # rm -rf "$TEMP_DIR"
    # exit 1
fi

# Create Lua replacement filter
REPLACE_LUA="$TEMP_DIR/replace_images.lua"
echo "Creating Lua replacement filter..."

cat > "$REPLACE_LUA" << 'EOF'
local url_map = {
EOF

for url in "${!final_url_map[@]}"; do
    pdf_path="${final_url_map[$url]}"
    # Escape quotes and backslashes for Lua string
    safe_url=$(echo -n "$url" | sed 's/\\/\\\\/g; s/"/\\"/g')
    safe_path=$(echo -n "$pdf_path" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "  [\"$safe_url\"] = \"$safe_path\"," >> "$REPLACE_LUA"
done

cat >> "$REPLACE_LUA" << 'EOF'
}

local filename_map = {
EOF

for url in "${!final_url_map[@]}"; do
    pdf_path="${final_url_map[$url]}"
    # Extract filename from URL (ignoring query params)
    filename=$(echo "$url" | sed 's/[?#].*//' | awk -F/ '{print $NF}')
    safe_filename=$(echo -n "$filename" | sed 's/\\/\\\\/g; s/"/\\"/g')
    safe_path=$(echo -n "$pdf_path" | sed 's/\\/\\\\/g; s/"/\\"/g')
    
    # Only add if not empty
    if [[ -n "$safe_filename" ]]; then
        echo "  [\"$safe_filename\"] = \"$safe_path\"," >> "$REPLACE_LUA"
    fi
done

cat >> "$REPLACE_LUA" << 'EOF'
}

-- DEBUG: Dump the map keys to stderr to verify they exist
for k,v in pairs(url_map) do
    if string.find(k, "Geomagnetic") or string.find(k, "Quadcopter") then
        io.stderr:write("DEBUG_MAP_KEY_FOUND_URL: " .. k .. "\n")
    end
end
for k,v in pairs(filename_map) do
    if string.find(k, "Geomagnetic") or string.find(k, "Quadcopter") then
        io.stderr:write("DEBUG_MAP_KEY_FOUND_FILE: " .. k .. "\n")
    end
end

function Image(el)
  -- Debug every image seen
  if string.find(el.src, "Geomagnetic") or string.find(el.src, "Quadcopter") then
      io.stderr:write("DEBUG_LUA_SEEN: " .. el.src .. "\n")
  end

  -- Try exact match
  if url_map[el.src] then
    el.src = url_map[el.src]
    return el
  end
  
  -- Try filename match
  -- Get filename from el.src
  local src_filename = el.src:match("^.+/(.+)$") or el.src
  -- Remove query params if any
  src_filename = src_filename:match("([^?#]+)")
  
  if filename_map[src_filename] then
     -- io.stderr:write("Fallback match: " .. el.src .. " -> " .. filename_map[src_filename] .. "\n")
     el.src = filename_map[src_filename]
     return el
  end

  io.stderr:write("MOO LUA WARNING: No replacement found for: " .. el.src .. "\n")
end
EOF

echo "Converting Markdown to PDF with Pandoc..."

# Extract footer from YAML frontmatter before stripping
FOOTER=$(grep "^footer:" "$TEMP_MD" | sed 's/^footer: *//')

# Strip Marp-specific syntax from markdown but keep structure
sed -i '1,/^---$/d; /^---$/,/^---$/d' "$TEMP_MD"  # Remove YAML frontmatter more carefully
sed -i 's/!\[bg [^]]*\]/![]/g' "$TEMP_MD"  # Remove bg positioning directives

# Replace -> ligatures with Unicode arrow for LaTeX compatibility
sed -i 's/->/→/g' "$TEMP_MD"
# Remove HTML comments (multiline safe)
perl -0777 -i -pe 's/<!--.*?-->//gs' "$TEMP_MD"

# Fix common LaTeX equation issues
# Remove $$ around align environments (align already creates math mode)
sed -i 's/\$\$\\begin{align}/\\begin{align}/g' "$TEMP_MD"
sed -i 's/\\end{align}\$\$/\\end{align}/g' "$TEMP_MD"

# Create custom LaTeX header for image sizing and larger headings
LATEX_HEADER="$TEMP_DIR/header.tex"
cat > "$LATEX_HEADER" << 'HEREDOC'
% Make all images max 0.5\textwidth
\usepackage{graphicx}
\setkeys{Gin}{width=0.5\textwidth,keepaspectratio}

% Modern fonts: Fira Sans headings, Fira Mono code
% Note: fontspec is already loaded by Pandoc, so we just set fonts
\setsansfont{FiraSans}[
    Path=/usr/share/texlive/texmf-dist/fonts/opentype/public/fira/,
    Extension=.otf,
    UprightFont=*-Regular,
    BoldFont=*-Bold,
    ItalicFont=*-Italic,
    BoldItalicFont=*-BoldItalic
]
\setmonofont{FiraMono}[
    Path=/usr/share/texlive/texmf-dist/fonts/opentype/public/fira/,
    Extension=.otf,
    Scale=0.90,
    UprightFont=*-Regular,
    BoldFont=*-Bold
]

% Make headings much larger with more spacing and sans-serif
\usepackage{titlesec}
\newcommand{\sectionbreak}{\clearpage}
\titleformat{\section}{\sffamily\LARGE\bfseries}{\thesection}{1em}{}
\titlespacing*{\section}{0pt}{24pt}{12pt}
\titleformat{\subsection}{\sffamily\Large\bfseries}{\thesubsection}{1em}{}
\titlespacing*{\subsection}{0pt}{20pt}{10pt}
\titleformat{\subsubsection}{\sffamily\large\bfseries}{\thesubsubsection}{1em}{}
\titlespacing*{\subsubsection}{0pt}{16pt}{8pt}

% Make document title Fira Sans Bold and left-aligned
\usepackage{titling}
\pretitle{\begin{flushleft}\sffamily\bfseries\huge}
\posttitle{\end{flushleft}}
\preauthor{\begin{flushleft}}
\postauthor{\end{flushleft}}
\predate{\begin{flushleft}}
\postdate{\end{flushleft}}

% Page header with footer content
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small FOOTERPLACEHOLDER}
\fancyhead[R]{\small\itshape\nouppercase{\leftmark}}
\fancyfoot[C]{\small\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
% Empty style for title page
\fancypagestyle{plain}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

% Increase paragraph spacing and line spacing
\usepackage{setspace}
\setstretch{1.3}
\setlength{\parskip}{0.8em}

% Use ragged right (left-aligned) instead of justified text
\raggedright

% More spacing around lists
\usepackage{enumitem}
\setlist{itemsep=0.5em,parsep=0.3em}

% Add moderate padding to code blocks
\usepackage{xcolor}
\definecolor{shadecolor}{RGB}{248,248,248}
\usepackage{fancyvrb}
\usepackage{framed}
\RecustomVerbatimEnvironment{Verbatim}{Verbatim}{fontsize=\small}
HEREDOC

# Replace placeholder with actual footer content (escape special sed characters)
ESCAPED_FOOTER=$(echo "$FOOTER" | sed 's/[\/&]/\\&/g')
sed -i "s/FOOTERPLACEHOLDER/$ESCAPED_FOOTER/g" "$LATEX_HEADER"

# DEBUG: Generate TeX file to debug image issues
pandoc "$TEMP_MD" \
    -o "${OUTPUT_FILE%.pdf}.tex" \
    --lua-filter="$REPLACE_LUA" \
    --shift-heading-level-by=-1 \
    -V geometry:margin=1in \
    -V documentclass=article \
    -V fontsize=11pt \
    --include-in-header="$LATEX_HEADER" \
    --highlight-style=tango

TEX_FILE="${OUTPUT_FILE%.pdf}.tex"
echo "DEBUGGING TEX FILE: $TEX_FILE"
if [[ -f "$TEX_FILE" ]]; then
    echo "--- START TEX INCLUDGRAPHICS ---"
    grep -n "includegraphics" "$TEX_FILE" | head -n 100
    echo "--- END TEX INCLUDGRAPHICS ---"
    
    echo "--- START TEX UNMAPPED URLS ---"
    # Look for http links that weren't replaced by local paths
    grep "http" "$TEX_FILE" | grep "includegraphics" || echo "No raw http URLs found."
    echo "--- END TEX UNMAPPED URLS ---"

    echo "--- START TEX HASHED FILENAMES ---"
    # Look for long hex strings in includegraphics (Pandoc autogenerated names)
    grep -E "includegraphics.*[a-f0-9]{32}" "$TEX_FILE" || echo "No hashed filenames found."
    echo "--- END TEX HASHED FILENAMES ---"
fi

# Convert to PDF using Pandoc with LaTeX
pandoc "$TEMP_MD" \
    -o "$OUTPUT_FILE" \
    --lua-filter="$REPLACE_LUA" \
    --pdf-engine=xelatex \
    --shift-heading-level-by=-1 \
    -V geometry:margin=1in \
    -V documentclass=article \
    -V fontsize=11pt \
    --include-in-header="$LATEX_HEADER" \
    --highlight-style=tango \
    2>&1 | tee /tmp/pandoc_output.log

# Check if PDF was actually created
if [[ -f "$OUTPUT_FILE" ]]; then
    echo "Success! PDF created: $OUTPUT_FILE"
else
    echo "ERROR: PDF creation failed. See /tmp/pandoc_output.log for details"
    # Clean up temporary directory
    # rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up temporary directory (but not the cache)
 rm -rf "$TEMP_DIR"
echo "Cleaned up temporary files"
