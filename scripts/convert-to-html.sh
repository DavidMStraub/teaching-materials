#!/bin/bash

# Script to convert all markdown files in the repo root to HTML using Marp CLI
# Uses the HM theme from https://raw.githubusercontent.com/DavidMStraub/hm-marp/refs/heads/main/hm.css

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the repo root (parent directory of scripts)
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# HM theme URL
HM_THEME_URL="https://raw.githubusercontent.com/DavidMStraub/hm-marp/refs/heads/main/hm.css"

# Create a temporary directory for the theme
TEMP_DIR=$(mktemp -d)
THEME_FILE="$TEMP_DIR/hm.css"

echo "Downloading HM theme..."
curl -s -o "$THEME_FILE" "$HM_THEME_URL"

if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Failed to download HM theme from $HM_THEME_URL"
    exit 1
fi

echo "Theme downloaded successfully to $THEME_FILE"

# Change to repo root
cd "$REPO_ROOT"

# Find all markdown files recursively (including subdirectories)
MARKDOWN_FILES=()
while IFS= read -r -d '' file; do
    MARKDOWN_FILES+=("$file")
done < <(find . -name "*.md" -type f -print0)

# Check if any markdown files exist
if [ ${#MARKDOWN_FILES[@]} -eq 0 ]; then
    echo "No markdown files found in the repository."
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo "Found ${#MARKDOWN_FILES[@]} markdown file(s) in the repository:"
printf '  %s\n' "${MARKDOWN_FILES[@]}"

# Convert each markdown file to HTML
for md_file in "${MARKDOWN_FILES[@]}"; do
    if [ -f "$md_file" ]; then
        # Skip README.md files
        if [[ "$(basename "$md_file")" == "README.md" ]]; then
            echo "Skipping $md_file (README file)"
            continue
        fi
        
        # Create output directory if it doesn't exist
        output_dir=$(dirname "$md_file")
        mkdir -p "$output_dir"
        
        # Skip files without marp: true in frontmatter
        if ! awk 'BEGIN{fm=0;found=0} /^---$/{fm++; next} fm==1 && /^marp:[[:space:]]*true/{found=1; exit} fm>=2{exit} END{exit !found}' "$md_file"; then
            echo "Skipping $md_file (no marp: true in frontmatter)"
            continue
        fi

        html_file="${md_file%.md}.html"
        echo "Converting $md_file to $html_file..."
        
        # Use marp CLI to convert with the HM theme
        marp "$md_file" --html --theme "$THEME_FILE" --output "$html_file"
        
        if [ $? -eq 0 ]; then
            echo "  ✓ Successfully converted $md_file to $html_file"
        else
            echo "  ✗ Failed to convert $md_file"
        fi
    fi
done

# Clean up temporary directory
rm -rf "$TEMP_DIR"

echo "Conversion complete!"