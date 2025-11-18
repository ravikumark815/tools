#!/bin/bash
# Tail logs matching a regex (e.g., abc*)
# Usage: ./log-tail-regex.sh 'regex' [directory]

REGEX="$1"
DIR="${2:-.}"

if [ -z "$REGEX" ]; then
    echo "Usage: $0 regex [directory]"
    exit 1
fi

shopt -s nullglob
FILES=("$DIR"/$REGEX*)

if [ ${#FILES[@]} -eq 0 ]; then
    echo "No files match."
    exit 0
fi

echo "Tailing: ${FILES[*]}"
tail -f "${FILES[@]}"