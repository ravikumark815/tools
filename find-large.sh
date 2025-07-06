#!/bin/bash
# Find Large Files/Directories
# Usage: ./find-large.sh [path] [count]
# Default path: current dir, default count: 10

DIR="${1:-.}"
COUNT="${2:-10}"

echo "Largest $COUNT files:"
find "$DIR" -type f -printf '%s %p\n' 2>/dev/null | sort -nr | head -n "$COUNT" | awk '{printf "%10d KB  %s\n", $1/1024, $2}'

echo
echo "Largest $COUNT directories:"
du -h "$DIR" 2>/dev/null | sort -hr | head -n "$COUNT"