#!/usr/bin/env python3
"""check_footprints.py -- robust axiom-footprint check for a check.sh build log.

Why this exists: the ad-hoc one-liner
    nonclean = grep -c 'depends on axioms' log  minus  grep -c 'propext, Classical.choice, Quot.sound' log
is NOT robust to line wrapping.  Lean wraps long declaration names, so a perfectly clean
footprint can be printed as

    'RouteABC.some_long_name' depends on axioms: [propext,
     Classical.choice,
     Quot.sound]

and the naive count reports a false NON-CLEAN.  That happened (journal 277).  This script
rejoins the wrapped output first and then counts.

Usage:  python3 check_footprints.py /tmp/all.log [--expect N]
Exit 0 iff every footprint equals the allowed set.
"""
import re, sys
from collections import Counter

ALLOWED = "propext, Classical.choice, Quot.sound"

def main(argv):
    if len(argv) < 2:
        print(__doc__); return 2
    log = argv[1]
    expect = None
    if "--expect" in argv:
        expect = int(argv[argv.index("--expect") + 1])
    txt = open(log).read()
    txt = re.sub(r"'\s*\n\s*", "' ", txt)          # rejoin wrapped names
    pats = re.findall(r"depends on axioms: \[(.*?)\]", txt, flags=re.S)
    pats = [re.sub(r"\s+", " ", p).strip() for p in pats]
    c = Counter(pats)
    bad = [(k, v) for k, v in c.items() if k != ALLOWED]
    print("footprints found: %d" % len(pats))
    for k, v in c.most_common():
        mark = "OK   " if k == ALLOWED else "BAD  "
        print("  %s %4d  [%s]" % (mark, v, k))
    if expect is not None and len(pats) != expect:
        print("EXPECTED %d footprints, found %d" % (expect, len(pats)))
        return 1
    if bad:
        print("RESULT: %d NON-CLEAN footprint classes" % len(bad)); return 1
    print("RESULT: all clean");  return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv))
