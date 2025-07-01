#!/usr/bin/env python3
"""
Batch File Renamer (Python)
Usage: python batch-rename.py PATTERN REPLACEMENT [GLOB]
Example: python batch-rename.py foo bar "*.txt"
"""
import glob
import os
import sys

if len(sys.argv) < 3:
    print("Usage: python batch-rename.py PATTERN REPLACEMENT [GLOB]")
    sys.exit(1)

pattern = sys.argv[1]
replacement = sys.argv[2]
file_glob = sys.argv[3] if len(sys.argv) > 3 else "*"

for old in glob.glob(file_glob):
    if os.path.isfile(old):
        new = old.replace(pattern, replacement)
        if old != new:
            print(f"{old} -> {new}")
            os.rename(old, new)