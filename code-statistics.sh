#!/bin/bash
# Code Statistics: Count lines of code, comments, and blanks per language.
# Usage: ./code-statistics.sh [directory]
DIR="${1:-.}"
echo "Language,Files,Lines,Blanks,Comments,Code"
find "$DIR" -type f | while read -r file; do
    ext="${file##*.}"
    lang=""
    comm_start=""
    comm_end=""
    single_line_comm=""

    case "$ext" in
        py) lang="Python"; single_line_comm="#" ;;
        sh) lang="Shell"; single_line_comm="#" ;;
        js) lang="JavaScript"; single_line_comm="//"; comm_start="/\\*"; comm_end="\\*/" ;;
        c|h) lang="C"; single_line_comm="//"; comm_start="/\\*"; comm_end="\\*/" ;;
        cpp|hpp|cc|cxx) lang="C++"; single_line_comm="//"; comm_start="/\\*"; comm_end="\\*/" ;;
        java) lang="Java"; single_line_comm="//"; comm_start="/\\*"; comm_end="\\*/" ;;
        go) lang="Go"; single_line_comm="//"; comm_start="/\\*"; comm_end="\\*/" ;;
        rb) lang="Ruby"; single_line_comm="#" ;;
        php) lang="PHP"; single_line_comm="//"; comm_start="/\\*"; comm_end="\\*/" ;;
        *) continue ;;
    esac

    [ -f "$file" ] || continue

    lines=$(wc -l < "$file")
    blanks=$(grep -c '^\s*$' "$file")

    comments=0
    # Count single-line comments
    if [ -n "$single_line_comm" ]; then
        comments=$(grep -c "^\s*${single_line_comm}" "$file")
    fi

    # Handle block comments for languages that have them
    if [ -n "$comm_start" ] && [ -n "$comm_end" ]; then
        # Use a here-document to safely pass the awk script
        block_comments=$(awk -v start_re="${comm_start}" -v end_re="${comm_end}" '
            BEGIN {
                in_comment = 0;
                comment_lines = 0;
            }
            {
                # Check for single-line block comments (e.g., /* comment */)
                if ($0 ~ start_re && $0 ~ end_re) {
                    # Only count if the comment starts at the beginning of the line (after optional whitespace)
                    # This avoids counting /* inside a line of code as a full comment line
                    if ($0 ~ "^[[:space:]]*" start_re) {
                         comment_lines++;
                    }
                } else if ($0 ~ start_re) {
                    in_comment = 1;
                    comment_lines++; # Count the line where the comment starts
                } else if ($0 ~ end_re) {
                    in_comment = 0;
                    comment_lines++; # Count the line where the comment ends
                } else if (in_comment == 1) {
                    comment_lines++;
                }
            }
            END {
                print comment_lines;
            }
        ' "$file")
        comments=$((comments + block_comments))
    fi

    code=$((lines - blanks - comments))
    echo "$lang,1,$lines,$blanks,$comments,$code"
done | awk -F, '
{
  count[$1]++; lines[$1]+=$3; blanks[$1]+=$4; comments[$1]+=$5; code[$1]+=$6;
}
END {
  for (l in count) printf "%s,%d,%d,%d,%d,%d\n", l, count[l], lines[l], blanks[l], comments[l], code[l];
}' | column -t -s ','