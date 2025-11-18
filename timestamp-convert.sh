#!/bin/bash
# Timestamp Converter
# Usage: ./timestamp-convert.sh [timestamp]
# If no argument, reads from stdin

if [ $# -eq 0 ]; then
    while read -r ts; do
        date -d @"$ts"
    done
else
    for ts in "$@"; do
        date -d @"$ts"
    done
fi