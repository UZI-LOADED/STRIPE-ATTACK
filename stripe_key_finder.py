#!/usr/bin/env python3
import os, re, requests

def find_keys(path):
    regex = re.compile(r"sk_live_[0-9a-zA-Z]{24,}")
    keys = set()
    for root, _, files in os.walk(path):
        for f in files:
            if f.endswith(('.js','.env','.py','.php','.txt','.md')):
                for i,line in enumerate(open(os.path.join(root,f), errors='ignore')):
                    for m in regex.findall(line):
                        keys.add((m, f"{root}/{f}", i+1))
    return keys

def validate_key(key):
    resp = requests.get("https://api.stripe.com/v1/account", auth=(key, ""))
    return resp.status_code == 200

if __name__ == "__main__":
    import sys
    base = sys.argv[1] if len(sys.argv)>1 else "."
    for key, file, line in find_keys(base):
        valid = validate_key(key)
        print(f"{'[VALID]' if valid else '[INVALID]'} {key} in {file}:{line}")
