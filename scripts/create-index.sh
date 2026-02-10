#!/bin/bash

# Script to create index.html files for main directory and course subfolders
# Supports course metadata extraction and sub-index generation

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the repo root (parent directory of scripts)
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to repo root
cd "$REPO_ROOT"

echo "Creating table of contents and sub-indexes..."

# Function to extract course title from metadata
get_course_title() {
    local course_dir="$1"
    
    # Try course.yaml first
    if [[ -f "$course_dir/course.yaml" ]]; then
        # Convert YAML to JSON and extract title with jq
        python3 -c "import yaml, json; print(json.dumps(yaml.safe_load(open('$course_dir/course.yaml'))))" 2>/dev/null | jq -r '.title // ""' 2>/dev/null
    else
        # Extract from first markdown file's footer using awk
        local first_md=$(find "$course_dir" -name "*.md" -type f | head -n 1)
        if [[ -n "$first_md" ]]; then
            local footer=$(awk '/^---$/ {in_fm=1; next} in_fm && /^---$/ {exit} in_fm && /^footer:/ {gsub(/^footer:[ \t]*/, ""); print}' "$first_md" 2>/dev/null)
            # Extract course name before " – " separator
            echo "$footer" | sed 's/ – .*//'
        else
            # Fallback to title-case folder name
            echo "$course_dir" | sed 's/-/ /g; s/\b\w/\U&/g'
        fi
    fi
}

# Function to create HTML header
create_html_header() {
    local title="$1"
    local is_subindex="$2"
    
    cat << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
EOF
    echo "    <title>$title</title>"
    cat << 'EOF'
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            background: white;
            max-width: 600px;
            margin: 3rem auto;
            padding: 0 2rem;
        }
        
        h1 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 2rem;
            color: #1a1a1a;
        }
        
        ul {
            list-style: none;
            padding: 0;
        }
        
        li {
            margin-bottom: 1.5rem;
        }
        
        .course-link {
            display: inline-block;
            text-decoration: none;
            color: #0066cc;
            transition: all 0.2s ease;
            font-weight: 500;
            padding: 0.4rem 0.8rem;
            border: 1px solid #e3f2fd;
            border-radius: 4px;
            background: #f8fbff;
        }
        
        .course-link:hover {
            background: #e3f2fd;
            border-color: #bbdefb;
        }
        
        a {
            text-decoration: none;
            color: inherit;
            transition: color 0.2s ease;
        }
        
        a:hover .format-badge {
            opacity: 0.8;
        }
        
        .format-badge {
            display: inline-block;
            font-size: 0.75rem;
            padding: 0.2rem 0.5rem;
            border-radius: 3px;
            margin-left: 0.5rem;
            font-weight: 500;
        }
        
        .format-html {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .format-pdf {
            background: #ffebee;
            color: #c62828;
        }
        
        .back-nav {
            margin-bottom: 2rem;
            font-size: 0.9rem;
        }
        
        .back-nav a {
            color: #0066cc;
            text-decoration: none;
        }
        
        .back-nav a:hover {
            text-decoration: underline;
        }
        
        .binder-button {
            display: inline-block;
            background: #f8f9fa;
            color: #6c757d;
            text-decoration: none;
            padding: 0.4rem 0.8rem;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            font-weight: 400;
            font-size: 0.85rem;
            margin-bottom: 1.2rem;
            transition: all 0.2s ease;
        }
        
        .binder-button:hover {
            background: #e9ecef;
            color: #495057;
            border-color: #adb5bd;
        }
        
        .no-presentations {
            text-align: center;
            color: #666;
            font-style: italic;
            margin: 3rem 0;
        }
    </style>
</head>
<body>
EOF
    
    if [[ "$is_subindex" == "true" ]]; then
        echo "    <div class=\"back-nav\">← <a href=\"../index.html\">Back to All Courses</a></div>"
    fi
    
    echo "    <h1>$title</h1>"
}

# Function to create sub-index for a course folder
create_sub_index() {
    local course_dir="$1"
    local course_title="$2"
    local index_file="$course_dir/index.html"
    
    echo "Creating sub-index: $index_file"
    
    # Find presentations in this course
    declare -A course_presentations
    
    # Find HTML files in course directory
    while IFS= read -r -d '' file; do
        if [[ "$(basename "$file")" != "index.html" ]]; then
            basename="${file%.html}"
            basename="${basename#$course_dir/}"
            course_presentations["$basename"]="${course_presentations[$basename]:-}|html"
        fi
    done < <(find "$course_dir" -maxdepth 1 -name "*.html" -print0 2>/dev/null)
    
    # Find PDF files in course directory
    while IFS= read -r -d '' file; do
        basename="${file%.pdf}"
        basename="${basename#$course_dir/}"
        course_presentations["$basename"]="${course_presentations[$basename]:-}|pdf"
    done < <(find "$course_dir" -maxdepth 1 -name "*.pdf" -print0 2>/dev/null)
    
    # Create the HTML file
    create_html_header "$course_title" "true" > "$index_file"
    
    # Add Binder button conditionally based on course.yaml
    if [[ -f "$course_dir/course.yaml" ]]; then
        binder_enabled=$(python3 -c "import yaml, json; print(json.dumps(yaml.safe_load(open('$course_dir/course.yaml'))))" 2>/dev/null | jq -r '.binder // false' 2>/dev/null)
        if [[ "$binder_enabled" == "true" ]]; then
            echo "    <a href=\"https://mybinder.org/v2/gh/DavidMStraub/teaching-materials/HEAD?filepath=$course_dir\" class=\"binder-button\">🚀 Open in Binder</a>" >> "$index_file"
            echo "" >> "$index_file"
        fi
    fi
    
    if [ ${#course_presentations[@]} -eq 0 ]; then
        echo "    <div class=\"no-presentations\">No presentations found in this course.</div>" >> "$index_file"
    else
        echo "    <ul>" >> "$index_file"
        
        # Sort and output presentations
        while IFS= read -r basename; do
            formats="${course_presentations[$basename]}"
            # Convert underscores to spaces for display
            title=$(echo "$basename" | sed 's/_/ /g')
            
            echo "        <li>" >> "$index_file"
            echo "            <span>$title</span>" >> "$index_file"
            
            # Add HTML badge/link if available
            if [[ "$formats" == *"html"* ]]; then
                echo "            <a href=\"./$basename.html\"><span class=\"format-badge format-html\">HTML</span></a>" >> "$index_file"
            fi
            
            # Add PDF badge/link if available
            if [[ "$formats" == *"pdf"* ]]; then
                echo "            <a href=\"./$basename.pdf\"><span class=\"format-badge format-pdf\">PDF</span></a>" >> "$index_file"
            fi
            
            echo "        </li>" >> "$index_file"
        done < <(printf '%s\n' "${!course_presentations[@]}" | sort)
        
        echo "    </ul>" >> "$index_file"
    fi
    
    # Add footer
    cat >> "$index_file" << 'EOF'
    
    <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid #eee; text-align: center;">
        <p style="font-size: 0.9rem; color: #666;">
            <a href="https://github.com/DavidMStraub/teaching-materials" style="color: #0066cc; text-decoration: none;">
                View source on GitHub
            </a>
        </p>
    </div>

</body>
</html>
EOF
}

# Main index generation
INDEX_FILE="index.html"
echo "Creating main index: $INDEX_FILE"

# Find all presentations and course folders
declare -A presentations
declare -A course_folders

# Find HTML files in root
while IFS= read -r -d '' file; do
    if [[ "$(basename "$file")" != "index.html" ]]; then
        basename="${file%.html}"
        basename="${basename#./}"
        presentations["$basename"]="${presentations[$basename]:-}|html"
    fi
done < <(find . -maxdepth 1 -name "*.html" -print0 2>/dev/null)

# Find PDF files in root
while IFS= read -r -d '' file; do
    basename="${file%.pdf}"
    basename="${basename#./}"
    presentations["$basename"]="${presentations[$basename]:-}|pdf"
done < <(find . -maxdepth 1 -name "*.pdf" -print0 2>/dev/null)

# Find course subdirectories
while IFS= read -r -d '' dir; do
    dir_name="${dir#./}"
    if [[ -d "$dir" ]] && [[ "$dir_name" != "." ]] && [[ "$dir_name" != "scripts" ]] && [[ "$dir_name" != "assets" ]] && [[ "$dir_name" != ".git" ]] && [[ "$dir_name" != ".github" ]] && [[ "$dir_name" != "__pycache__" ]] && [[ "$dir_name" != ".ipynb_checkpoints" ]]; then
        # Check if directory contains markdown files
        if find "$dir" -name "*.md" -type f | grep -q .; then
            course_title=$(get_course_title "$dir_name")
            course_folders["$dir_name"]="$course_title"
            # Create sub-index for this course
            create_sub_index "$dir_name" "$course_title"
        fi
    fi
done < <(find . -maxdepth 1 -type d -print0 2>/dev/null)

# Create main index HTML
create_html_header "David Straub – Teaching Material" "false" > "$INDEX_FILE"

# Check if we have any content
total_items=$((${#presentations[@]} + ${#course_folders[@]}))

if [ $total_items -eq 0 ]; then
    echo "    <div class=\"no-presentations\">No presentations found.</div>" >> "$INDEX_FILE"
else
    echo "    <ul>" >> "$INDEX_FILE"
    
    # Output course folders first
    if [ ${#course_folders[@]} -gt 0 ]; then
        while IFS= read -r folder_name; do
            course_title="${course_folders[$folder_name]}"
            echo "        <li>" >> "$INDEX_FILE"
            echo "            <a href=\"./$folder_name/index.html\" class=\"course-link\">$course_title</a>" >> "$INDEX_FILE"
            echo "        </li>" >> "$INDEX_FILE"
        done < <(printf '%s\n' "${!course_folders[@]}" | sort)
    fi
    
    # Output individual presentations from root
    if [ ${#presentations[@]} -gt 0 ]; then
        while IFS= read -r basename; do
            formats="${presentations[$basename]}"
            # Convert underscores to spaces for display
            title=$(echo "$basename" | sed 's/_/ /g')
            
            echo "        <li>" >> "$INDEX_FILE"
            echo "            <span>$title</span>" >> "$INDEX_FILE"
            
            # Add HTML badge/link if available
            if [[ "$formats" == *"html"* ]]; then
                echo "            <a href=\"./$basename.html\"><span class=\"format-badge format-html\">HTML</span></a>" >> "$INDEX_FILE"
            fi
            
            # Add PDF badge/link if available
            if [[ "$formats" == *"pdf"* ]]; then
                echo "            <a href=\"./$basename.pdf\"><span class=\"format-badge format-pdf\">PDF</span></a>" >> "$INDEX_FILE"
            fi
            
            echo "        </li>" >> "$INDEX_FILE"
        done < <(printf '%s\n' "${!presentations[@]}" | sort)
    fi
    
    echo "    </ul>" >> "$INDEX_FILE"
fi

# Add footer to main index
cat >> "$INDEX_FILE" << 'EOF'
    
    <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid #eee; text-align: center;">
        <p style="font-size: 0.9rem; color: #666;">
            <a href="https://github.com/DavidMStraub/teaching-materials" style="color: #0066cc; text-decoration: none;">
                View source on GitHub
            </a>
        </p>
    </div>

</body>
</html>
EOF

echo "✓ Main index created: $INDEX_FILE"
if [ ${#course_folders[@]} -gt 0 ]; then
    echo "✓ Created ${#course_folders[@]} sub-index(es) for course folders"
fi

echo "✓ Table of contents generated successfully!"