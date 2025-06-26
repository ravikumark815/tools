#!/bin/bash
# Batch File Renamer: Rename files in a directory using a regex pattern
# Usage: ./batch-file-rename.sh 's/old/new/g' [path] [file-glob]
# Example: ./batch-file-rename.sh 's/foo/bar/g' . '*.txt'

PATTERN="$1"
DIR="${2:-.}"
GLOB="${3:-*}"

if [ -z "$PATTERN" ]; then
    echo "Usage: $0 'sed-pattern' [directory] [glob]"
    exit 1
fi

cd "$DIR" || exit 1

for f in $GLOB; do
    if [ -f "$f" ]; then
        new=$(echo "$f" | sed "$PATTERN")
        if [ "$f" != "$new" ]; then
            mv -v -- "$f" "$new"
        fi
    fi
done