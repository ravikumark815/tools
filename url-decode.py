#!/usr/bin/env python3
import sys
import argparse
from urllib.parse import unquote, quote

try:
    import pyperclip
    CLIP_AVAILABLE = True
except ImportError:
    CLIP_AVAILABLE = False

def decode(text):
    return unquote(text)

def encode(text):
    return quote(text)

def main():
    parser = argparse.ArgumentParser(
        description="URL decode (or encode) strings from arguments, stdin, or clipboard."
    )
    parser.add_argument(
        "strings", nargs="*", help="Strings to decode/encode (if empty, read stdin or clipboard)"
    )
    parser.add_argument(
        "--encode", action="store_true", help="URL encode instead of decode"
    )
    parser.add_argument(
        "--pretty", action="store_true", help="Pretty-print result if possible (e.g. JSON)"
    )
    parser.add_argument(
        "--clipboard", action="store_true", help="Read from clipboard (if available)"
    )
    args = parser.parse_args()

    if args.strings:
        inputs = args.strings
    elif not sys.stdin.isatty():
        inputs = [line.rstrip('\n') for line in sys.stdin]
    elif args.clipboard and CLIP_AVAILABLE:
        inputs = [pyperclip.paste()]
    else:
        parser.print_help()
        if not CLIP_AVAILABLE and args.clipboard:
            print("\npyperclip not installed, can't use --clipboard.")
        sys.exit(1)

    for s in inputs:
        if args.encode:
            out = encode(s)
        else:
            out = decode(s)
        if args.pretty:
            try:
                import json
                parsed = json.loads(out)
                print(json.dumps(parsed, indent=2, ensure_ascii=False))
            except Exception:
                print(out)
        else:
            print(out)

if __name__ == "__main__":
    main()