#!/bin/bash
# Code Statistics: Count lines of code, comments, and blanks per language.
# Usage: ./code-statistics.sh [directory]
DIR="${1:-.}"
echo "Language,Files,Lines,Blanks,Comments,Code"
find "$DIR" -type f | while read -r file; do
    ext="${file##*.}"
    case "$ext" in
        py) lang="Python"; comm="#" ;;
        sh) lang="Shell"; comm="#" ;;
        js) lang="JavaScript"; comm="//" ;;
        c|h) lang="C"; comm="//" ;;
        cpp|hpp|cc|cxx) lang="C++"; comm="//" ;;
        java) lang="Java"; comm="//" ;;
        go) lang="Go"; comm="//" ;;
        rb) lang="Ruby"; comm="#" ;;
        php) lang="PHP"; comm="//" ;;
        *) continue ;;
    esac
    [ -f "$file" ] || continue
    lines=$(wc -l < "$file")
    blanks=$(grep -c '^\s*$' "$file")
    comments=$(grep -c "^\s*${comm}" "$file")
    code=$((lines - blanks - comments))
    echo "$lang,1,$lines,$blanks,$comments,$code"
done | awk -F, '
{
  count[$1]++; lines[$1]+=$3; blanks[$1]+=$4; comments[$1]+=$5; code[$1]+=$6;
}
END {
  for (l in count) printf "%s,%d,%d,%d,%d,%d\n", l, count[l], lines[l], blanks[l], comments[l], code[l];
}'