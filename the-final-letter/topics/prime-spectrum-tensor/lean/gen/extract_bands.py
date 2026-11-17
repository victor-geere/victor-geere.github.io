#!/usr/bin/env python3
"""Read the certified bands back out of the generated chains and check the
6×6 entry budget.

For each separation the last chunk of `DensityE<i>_*` states

    IntersectionForm.density (1/20) c ∈ Set.Icc LO HI

This script parses `LO, HI`, doubles them (`densityTerm = 2 * density`), rounds
outward to 6 decimals, and then evaluates the entry deviation

    max |pole + densityTerm + prime/2 − gramCentre6| 

against the pole and prime enclosures, for the `6×6` transfer's `ε = 2·10⁻³`.

Usage: python3 extract_bands.py [--last 11]
"""

import argparse
import math
import os
import re
from fractions import Fraction as F

POLE = {
    0: (F(31434, 10 ** 6), F(31436, 10 ** 6)),
    1: (F(31591, 10 ** 6), F(31593, 10 ** 6)),
    2: (F(32065, 10 ** 6), F(32067, 10 ** 6)),
    3: (F(32859, 10 ** 6), F(32861, 10 ** 6)),
    4: (F(33982, 10 ** 6), F(33985, 10 ** 6)),
    5: (F(35446, 10 ** 6), F(35448, 10 ** 6)),
}
PRIME = {
    0: (F(-22, 10 ** 6), F(0)),
    1: (F(-22, 10 ** 6), F(0)),
    2: (F(-22, 10 ** 6), F(0)),
    3: (F(-36490, 10 ** 6), F(-3646, 10 ** 5)),
    4: (F(-2811, 10 ** 5), F(-27726, 10 ** 6)),
    5: (F(-42660, 10 ** 6), F(-42460, 10 ** 6)),
}
PRIME_NEG = (F(-22, 10 ** 6), F(0))
CENTRE = [F(431337, 10 ** 7), F(-1649119, 10 ** 8), F(32087, 4 * 10 ** 6),
          F(-222131, 10 ** 8), F(341931, 5 * 10 ** 7), F(312957, 10 ** 8)]


def floor_at(q, d):
    s = 10 ** d
    return F(math.floor(q * s), s)


def ceil_at(q, d):
    s = 10 ** d
    return F(math.ceil(q * s), s)


def parse_band(path):
    if not os.path.exists(path):
        return None
    src = open(path).read()
    m = re.search(r"theorem density_mem_c\d+ :.*?Set\.Icc "
                  r"\(\((-?\d+)\)/\((\d+)\) : ℝ\) "
                  r"\(\((-?\d+)\)/\((\d+)\) : ℝ\)", src, re.S)
    if not m:
        return None
    return F(int(m.group(1)), int(m.group(2))), F(int(m.group(3)), int(m.group(4)))


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--last", type=int, default=11)
    ap.add_argument("--dec", type=int, default=6)
    ap.add_argument("--eps", default="15/10000")
    ap.add_argument("--tag", default="F", help="chain tag: E (lip 6) or F (lip 5/2)")
    a = ap.parse_args()
    eps = F(a.eps)
    worst = F(0)
    print("k  densityTerm band           densityTerm                   entry dev")
    for k in range(6):
        path = f"Density{a.tag}{k}_{a.last}.lean"
        b = parse_band(path)
        if b is None:
            print(f"{k}  MISSING {path}")
            continue
        lo, hi = 2 * b[0], 2 * b[1]
        blo, bhi = floor_at(lo, a.dec), ceil_at(hi, a.dec)
        plo, phi = POLE[k]
        qlo = (PRIME[k][0] + PRIME_NEG[0]) / 2
        qhi = (PRIME[k][1] + PRIME_NEG[1]) / 2
        dev = max(abs(blo + plo + qlo - CENTRE[k]), abs(bhi + phi + qhi - CENTRE[k]))
        worst = max(worst, dev)
        print(f"{k}  [{str(blo):>12},{str(bhi):>12}]  "
              f"[{float(blo):+.9f},{float(bhi):+.9f}]  {float(dev):.6e}")
    print(f"worst entry deviation {float(worst):.6e}, ε = {float(eps):.6e}, "
          f"ok = {worst <= eps}, 6ε < 1/70 = {6 * eps < F(1, 70)}")
