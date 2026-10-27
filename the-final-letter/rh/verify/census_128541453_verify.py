#!/usr/bin/env python3
"""
The census figure 128 541 453, reproduced and attributed.

`theorems/handoff-greedy-squaring-law.md` (and its source, top-level `HANDOFF.md:40`)
credits the census "to index 128 541 453" to `x = (π−3)/π`.  That is not what the
archive's own enumerator does: `verify/round7_AN_census.py:38` lists `pi-3` among its
six targets, the journal (`research-journal.md`) prints the row for `π−3`, and no
target anywhere is `(π−3)/π`.  This script:

  1. recomputes the census for every target `round7_AN_census.py` lists, at the same
     200 dps, and reports the last selected index and the count A(N);
  2. recomputes it for `(π−3)/π` as well, so the reader can see what that target
     actually does (it is not the target of the 128 541 453 figure);
  3. prints A(N) against `log2 log N` so the claimed `A(N) = log2 log N + O(1)` can be
     inspected rather than believed.

Independent of `round7_AN_census.py` (no import; the next-index rule is re-derived
here as `n_{k+1} = ceil(1/r_k) - 2`).

Usage: python3 verify/census_128541453_verify.py
"""
from __future__ import annotations

import mpmath as mp

mp.mp.dps = 200


def census(x, nmax: int = 300_000_000) -> tuple[list[int], mp.mpf]:
    """Selected indices and final residual, jumping directly to the next index."""
    r = mp.mpf(x) if not isinstance(x, mp.mpf) else x
    idx: list[int] = []
    n = 0
    while n < nmax:
        a = mp.mpf(1) / (n + 2)
        if r >= a:
            idx.append(n)
            r -= a
            if r == 0:
                break
            n = max(n + 1, int(mp.floor(1 / r)) - 2)
        else:
            n += 1
    return idx, r


TARGETS = [
    ("1/pi", lambda: 1 / mp.pi),
    ("log2", lambda: mp.log(2)),
    ("sqrt2-1", lambda: mp.sqrt(2) - 1),
    ("e-2", lambda: mp.e - 2),
    ("(sqrt5-1)/2", lambda: (mp.sqrt(5) - 1) / 2),
    ("pi-3", lambda: mp.pi - 3),
    ("(pi-3)/pi", lambda: (mp.pi - 3) / mp.pi),
]


def main() -> int:
    print("=" * 78)
    print("the census of A(N) = #{n <= N : delta_n = 1}, 200 dps, next-index jump")
    print("=" * 78)
    print(f"{'target':>12} {'#selections':>12} {'last index':>14} {'log2 log N':>12} "
          f"{'A - log2logN':>13} {'final residual':>16}")
    hit = {}
    for name, f in TARGETS:
        idx, r = census(f())
        N = idx[-1] if idx else 0
        ll = mp.log(mp.log(N)) / mp.log(2) if N > 1 else mp.mpf(0)
        print(f"{name:>12} {len(idx):>12} {N:>14} {mp.nstr(ll, 8):>12} "
              f"{mp.nstr(len(idx) - ll, 6):>13} {mp.nstr(r, 6):>16}")
        hit[name] = (len(idx), N)

    print()
    print("=" * 78)
    print("the figure in HANDOFF.md:40 / theorems/handoff-greedy-squaring-law.md")
    print("=" * 78)
    n_pi3 = hit["pi-3"][1]
    print(f"  census to index 128 541 453 -> the {n_pi3}-th selection of target `pi-3`")
    print(f"  MATCH: {n_pi3 == 128541453}")
    print(f"  target `(pi-3)/pi`, the attribution the document prints: "
          f"last index {hit['(pi-3)/pi'][1]}, {hit['(pi-3)/pi'][0]} selections "
          f"-> {'the figure is NOT this target' if hit['(pi-3)/pi'][1] != 128541453 else 'SAME'}")
    print()
    print("  Note the domain convention: the residual orbit is x = theta/pi in (0, 1), and")
    print("  `pi-3` = 0.14159... is outside it, while `(pi-3)/pi` = 0.04507... is inside it.")
    print("  `round7_AN_census.py` nonetheless lists `pi-3` as its sixth target and the")
    print("  journal prints the row `pi-3`; the 128 541 453 figure is that row's.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
