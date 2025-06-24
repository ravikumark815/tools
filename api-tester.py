#!/usr/bin/env python3
"""
Simple API Tester
Usage: python api-tester.py METHOD URL [DATA] [HEADERS]
Example: python api-tester.py GET https://httpbin.org/get
         python api-tester.py POST https://httpbin.org/post '{"foo":"bar"}' 'Content-Type:application/json'
"""
import sys
import requests

if len(sys.argv) < 3:
    print("Usage: python api-tester.py METHOD URL [DATA] [HEADERS]")
    sys.exit(1)

method = sys.argv[1].upper()
url = sys.argv[2]
data = sys.argv[3] if len(sys.argv) > 3 else None
headers = {}
if len(sys.argv) > 4:
    for h in sys.argv[4:]:
        k, v = h.split(':', 1)
        headers[k.strip()] = v.strip()

resp = requests.request(method, url, data=data, headers=headers)
print("Status:", resp.status_code)
print("Headers:", resp.headers)
print("Body:", resp.text)