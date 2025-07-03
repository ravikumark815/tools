#!/bin/bash
# Code Statistics: Count lines of code, comments, and blanks per language.
# Usage: ./code-statistics.sh [directory]
DIR="${1:-.}"
echo "Language,Files,Lines,Blanks,Comments,Code"
find "$DIR" -type f | while read -r file; do
    ext="${file##*.}"
    lang=""
    single_line_comm=""
    has_block_comments=0 # Flag to indicate if language uses /* */

    case "$ext" in
        py) lang="Python"; single_line_comm="#" ;;
        sh) lang="Shell"; single_line_comm="#" ;;
        js) lang="JavaScript"; single_line_comm="//"; has_block_comments=1 ;;
        c|h) lang="C"; single_line_comm="//"; has_block_comments=1 ;;
        cpp|hpp|cc|cxx) lang="C++"; single_line_comm="//"; has_block_comments=1 ;;
        java) lang="Java"; single_line_comm="//"; has_block_comments=1 ;;
        go) lang="Go"; single_line_comm="//"; has_block_comments=1 ;;
        rb) lang="Ruby"; single_line_comm="#" ;;
        php) lang="PHP"; single_line_comm="//"; has_block_comments=1 ;;
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
    if [ "$has_block_comments" -eq 1 ]; then
        # Hardcode the /* and */ patterns directly in awk
        block_comments=$(awk '
            BEGIN {
                in_comment = 0;
                comment_lines = 0;
            }
            {
                # Pattern for /*
                start_re = "/\\*";
                # Pattern for */
                end_re = "\\*/";

                # Check for single-line block comments (e.g., /* comment */)
                # Ensure the /* is at the beginning of the line after optional whitespace
                if ($0 ~ "^[[:space:]]*" start_re && $0 ~ end_re) {
                    comment_lines++;
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