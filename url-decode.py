import sys
from urllib.parse import unquote

if len(sys.argv) > 1:
    sys.stdout.write(unquote(sys.argv[1]))
else:
    sys.stdout.write(unquote(sys.stdin.read()))