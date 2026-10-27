#!/usr/bin/env python3
"""
rh43/plot_partition.py — draw a *balanced partition* of a partial sum of zeta at
Re(S) = 0.

The point plotted is the certified root of `Re S_N` at `N = 20` from
`verify/zeta_split.log`:

    t in [0.724615699099028, 0.724615699099144]      (width 1.16e-13, §4 of the log)

so `S = i t`, and the terms `n^{-it}` split by the sign of `cos(t log n)` into

    positive indices  {1, 2, ..., 8}      P = 3.99924880886696001...
    negative indices  {9, 10, ..., 20}    M = -3.999248808867014...

with `P + M = -5.4e-14 ... +4.7e-13` — the certified enclosure of `Re S_20`
contains 0.

The script writes `partition_N20.json` (data) and prints the numbers; the companion
`verify/plot_partition_png.py` renders the PNG (Pillow, no matplotlib needed).

Run:  python3 rh43/plot_partition.py
"""
from __future__ import annotations

import json
import sys
from fractions import Fraction as Fraction
from pathlib import Path

import mpmath as mp

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

import ivmath as iv  # noqa: E402
import zeta_split as z  # noqa: E402

mp.mp.dps = 60
N = 20
# the bracket printed in verify/zeta_split.log §4
BRACKET = (Fraction(724615699099028, 10 ** 15), Fraction(724615699099144, 10 ** 15))


def main() -> int:
    cert = z.certified_root(N, BRACKET[0], BRACKET[1], iters=60)
    if cert is None:
        print("no certified root bracket")
        return 1
    mid = (cert[0] + cert[1]) / 2
    t_lo = mp.mpf(cert[0].numerator) / cert[0].denominator
    t_hi = mp.mpf(cert[1].numerator) / cert[1].denominator
    t = (t_lo + t_hi) / 2

    rows = []
    P = iv.Num(0)
    M = iv.Num(0)
    for n in range(1, N + 1):
        c = iv.cos_num(iv.rat(mid) * iv.log_n(n))
        rows.append((n, c))
        if c.v > 0:
            P = P + c
        else:
            M = M + c
    total = P + M

    # cumulative sums, in index order and sorted by magnitude
    cum = 0.0
    by_index = []
    for n, c in rows:
        cum += float(c.v)
        by_index.append({"n": n, "term": float(c.v), "cum_total": cum,
                         "sign": 1 if c.v > 0 else -1})
    cum_pos = 0.0
    cum_neg = 0.0
    for n, c in rows:
        if c.v > 0:
            cum_pos += float(c.v)
        else:
            cum_neg += float(c.v)
        item = next(x for x in by_index if x["n"] == n)
        item["cum_pos"] = cum_pos
        item["cum_neg"] = cum_neg
        item["neg_magnitude"] = -cum_neg

    pos_sorted = sorted([(-float(c.v), n) for n, c in rows if c.v > 0])
    neg_sorted = sorted([(-float(c.v), n) for n, c in rows if c.v < 0])

    data = {
        "N": N,
        "t_bracket": [float(t_lo), float(t_hi)],
        "t_used": float(t),
        "P": float(P.v), "P_lo": float(P.lo), "P_hi": float(P.hi),
        "M": float(M.v), "M_lo": float(M.lo), "M_hi": float(M.hi),
        "total_lo": float(total.lo), "total_hi": float(total.hi),
        "pos_indices": [n for n, c in rows if c.v > 0],
        "neg_indices": [n for n, c in rows if c.v < 0],
        "rows": by_index,
        "pos_sorted": [{"n": n, "mag": m} for m, n in pos_sorted],
        "neg_sorted": [{"n": n, "mag": m} for m, n in neg_sorted],
    }
    (HERE / "partition_N20.json").write_text(json.dumps(data, indent=1))

    print(f"N = {N},  S = i*t,  t certified in [{float(t_lo):.15f}, {float(t_hi):.15f}]")
    print(f"  positive indices {data['pos_indices']}")
    print(f"  negative indices {data['neg_indices']}")
    print(f"  P = {float(P.v):.12f}  (rigorous [{float(P.lo):.12f}, {float(P.hi):.12f}])")
    print(f"  M = {float(M.v):.12f}  (rigorous [{float(M.lo):.12f}, {float(M.hi):.12f}])")
    print(f"  Re S_20(t) = P + M in [{float(total.lo):.3e}, {float(total.hi):.3e}]  (contains 0)")
    print(f"  |P - |M|| <= {max(abs(float(total.lo)), abs(float(total.hi))):.3e}")
    print("wrote partition_N20.json")
    return 0


if __name__ == "__main__":
    sys.exit(main())
