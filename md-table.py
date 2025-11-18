#!/usr/bin/env python3
"""
Markdown Table Formatter
Usage: python md-table.py input.csv [--tsv]
"""
import csv
import sys

if len(sys.argv) < 2:
    print("Usage: python md-table.py input.csv [--tsv]")
    sys.exit(1)

delimiter = '\t' if (len(sys.argv) > 2 and sys.argv[2] == '--tsv') else ','
with open(sys.argv[1], newline='') as csvfile:
    reader = list(csv.reader(csvfile, delimiter=delimiter))
    widths = [max(map(len, col)) for col in zip(*reader)]
    def fmt(row):
        return "| " + " | ".join(cell.ljust(width) for cell, width in zip(row, widths)) + " |"
    print(fmt(reader[0]))
    print("|" + "|".join('-' * (w+2) for w in widths) + "|")
    for row in reader[1:]:
        print(fmt(row))