"""Reusable relative-link checker for the rh workspace markdown corpus.

Usage:  python3 lib/linkcheck.py [root ...]
Reports, per root: total links, broken links grouped by (prefix pattern, depth).
"""
from __future__ import annotations
import os, re, sys, collections

LINK = re.compile(r'\]\(([^)\s]+)\)')

def is_external(t: str) -> bool:
    return t.startswith(('http://','https://','mailto:','#')) or t.startswith('//')

def strip_anchor(t: str) -> str:
    return t.split('#',1)[0]

def links_in(path: str):
    try:
        txt = open(path, encoding='utf-8', errors='replace').read()
    except OSError:
        return
    for m in LINK.finditer(txt):
        yield m.group(1)

def scan(root: str):
    broken = collections.Counter()
    examples = {}
    total = 0
    nbroken = 0
    for dirpath, _dirs, files in os.walk(root):
        for f in files:
            if not f.endswith('.md'):
                continue
            p = os.path.join(dirpath, f)
            rel0 = os.path.relpath(p, root)
            for t in links_in(p):
                if is_external(t):
                    continue
                total += 1
                tgt = strip_anchor(t)
                if not tgt:
                    continue
                resolved = os.path.normpath(os.path.join(os.path.dirname(p), tgt))
                if not os.path.exists(resolved):
                    nbroken += 1
                    key = (t[:3] if t.startswith('..') else 'local', t.count('../'))
                    broken[key] += 1
                    examples.setdefault(key, (rel0, t))
    return total, nbroken, broken, examples

if __name__ == '__main__':
    roots = sys.argv[1:] or ['.']
    for root in roots:
        total, nbroken, broken, ex = scan(root)
        print(f'== {root}: {total} relative links, {nbroken} broken')
        for k, c in broken.most_common():
            print(f'   {k}: {c}   e.g. {ex[k][0]} -> {ex[k][1]}')
