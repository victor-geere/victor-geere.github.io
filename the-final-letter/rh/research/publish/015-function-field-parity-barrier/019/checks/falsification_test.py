#!/usr/bin/env python3
"""The F4 falsification test, completed.

Output rule: results go to stdout; banners and timing go to stderr.

Tests, exactly and at every prime q = 1 (mod 4) up to a bound:

    strict   :  sum_A chi2(A) |K(A,c)|^2 = 2 chi2(c)  sqrt(q) Re J(chi4,chi4)^2
    general  :  sum_A chi2(A) |K(A,c)|^2 = 2 chi2(2c) sqrt(q) Re J(chi4,chi4)^2
    untwisted:  sum_A |K(A,c)|^2         = q^2 - 2q

"Exactly" = both sides are integer vectors in Z[zeta_q] and agree after
reduction modulo Phi_q; no floating point tolerance is involved in the verdict.

Usage:
    python3 checks/falsification_test.py [--max Q] [--json PATH]
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from math import isqrt

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

import twisted_parseval as tp  # noqa: E402


def primes_1_mod_4(limit: int) -> list[int]:
    def is_prime(n: int) -> bool:
        if n < 2:
            return False
        if n % 2 == 0:
            return n == 2
        for d in range(3, isqrt(n) + 1, 2):
            if n % d == 0:
                return False
        return True

    return [p for p in range(5, limit + 1, 4) if is_prime(p)]


def log(*a, **k):
    """Diagnostics go to stderr; results go to stdout."""
    print(*a, file=sys.stderr, **k)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--max", type=int, default=1000, help="largest prime to test")
    ap.add_argument("--json", default=os.path.join(os.path.dirname(__file__), "..", "results.json"))
    args = ap.parse_args()

    primes = primes_1_mod_4(args.max)
    log("=" * 78)
    log(f"F4 falsification test — primes q = 1 (mod 4) up to {args.max}: {len(primes)} primes")
    log("=" * 78)

    rows = []
    failures = []
    t_start = time.time()

    for q in primes:
        t0 = time.time()
        row = {"q": q, "q_mod_8": q % 8, "checks": {}}
        ok_all = True
        for c in (1, 2, 3):
            r = tp.identity_report(q, c)
            row["checks"][f"c={c}"] = {
                "strict": r["strict_ok"],
                "general": r["general_ok"],
                "untwisted": r["untwisted_ok"],
            }
            ok_all &= r["general_ok"] and r["untwisted_ok"]
        r1 = tp.identity_report(q, 1)
        row.update({
            "a": r1["a"], "b": r1["b"],
            "predicted_over_sqrtq": 2 * r1["chi2_2"] * r1["a2_minus_b2"],
            "strict_ok": r1["strict_ok"],
            "general_ok": r1["general_ok"],
            "untwisted_ok": r1["untwisted_ok"],
        })
        rows.append(row)
        if not ok_all:
            failures.append(q)

    elapsed = time.time() - t_start

    # ---- table -----------------------------------------------------------
    def fmt(r):
        return (f"  q={r['q']:>5}  q%8={r['q_mod_8']}  a={r['a']:>3} b={r['b']:>3}  "
                f"2chi2(2)(a^2-b^2)={r['predicted_over_sqrtq']:>6}  "
                f"strict={'yes' if r['strict_ok'] else 'NO ':>3}  "
                f"general={'yes' if r['general_ok'] else 'NO':>3}")

    log("\nfirst five:")
    for r in rows[:5]:
        print(fmt(r))
    log("...")
    log("\nlast five:")
    for r in rows[-5:]:
        print(fmt(r))

    n_strict = sum(1 for r in rows if r["strict_ok"])
    n_general = sum(1 for r in rows if r["general_ok"])
    n_untw = sum(1 for r in rows if r["untwisted_ok"])
    n_1mod8 = sum(1 for r in rows if r["q_mod_8"] == 1)

    log("\n" + "=" * 78)
    log("summary")
    log("=" * 78)
    print(f"  primes tested                     : {len(rows)}")
    print(f"  q = 1 (mod 8)                     : {n_1mod8}")
    print(f"  q = 5 (mod 8)                     : {len(rows) - n_1mod8}")
    print(f"  strict form  (2 chi2(c))   holds  : {n_strict}   "
          f"(all q=1 mod 8: {all(r['strict_ok'] for r in rows if r['q_mod_8'] == 1)})")
    print(f"  general form (2 chi2(2c))  holds  : {n_general} / {len(rows)}")
    print(f"  untwisted    (q^2-2q)      holds  : {n_untw} / {len(rows)}")
    print(f"  failures of the general form      : {failures if failures else 'none'}")
    log(f"  elapsed                           : {elapsed:.2f} s")

    out = {
        "max_q": args.max,
        "n_primes": len(rows),
        "n_q_1_mod_8": n_1mod8,
        "strict_holds": n_strict,
        "general_holds": n_general,
        "untwisted_holds": n_untw,
        "general_failures": failures,
        "rows": rows,
    }
    print(json.dumps(out, indent=1))

    ok = (n_general == len(rows) and n_untw == len(rows) and n_strict == n_1mod8)
    print(f"\nEXIT={0 if ok else 1}  all_ok: {ok}")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
