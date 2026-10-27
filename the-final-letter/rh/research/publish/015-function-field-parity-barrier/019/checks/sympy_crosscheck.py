#!/usr/bin/env python3
"""Independent cross-check of the F4 machinery, via sympy and mpmath.

Three things are re-derived by a different route than lib/twisted_parseval.py:

  1. chi2, via sympy's Legendre symbol;
  2. the reduction modulo Phi_q, via sympy's polynomial remainder;
  3. the identity itself, at 50 decimal digits, via mpmath.

Usage:  python3 checks/sympy_crosscheck.py [--primes 13,17,29,...]
"""

from __future__ import annotations

import argparse
import os
import sys

import mpmath as mp
import numpy as np
import sympy as sp

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

import twisted_parseval as tp  # noqa: E402

mp.mp.dps = 50


def chi2_sympy(q, a):
    a %= q
    return 0 if a == 0 else int(sp.functions.combinatorial.numbers.legendre_symbol(a, q))


def chi4_table(q):
    """chi4(h) = i^{ind(h)} as exact mpmath complex numbers."""
    g = next(t for t in range(2, q) if len({pow(t, k, q) for k in range(q - 1)}) == q - 1)
    ind, x = {}, 1
    for k in range(q - 1):
        ind[x] = k
        x = x * g % q
    i = mp.mpc(0, 1)
    return {h: i ** ind[h] for h in range(1, q)}


def jacobi_sum_mp(q):
    chi4 = chi4_table(q)
    chi4[0] = mp.mpc(0)
    return sum(chi4[x] * chi4[(1 - x) % q] for x in range(1, q))


def k_mp(q, A, c, zeta):
    inv4 = pow(4, -1, q)
    return sum(chi2_sympy(q, A * A - w * w) * zeta ** ((-c * w * inv4) % q)
               for w in range(q))


def log(*a, **k):
    """Diagnostics go to stderr; results go to stdout."""
    print(*a, file=sys.stderr, **k)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--primes", default="13,17,29,37,41,53,61,73,89,97,101,109,113")
    args = ap.parse_args()
    primes = [int(x) for x in args.primes.split(",") if x]

    ok = True
    log("=" * 78)
    log("sympy / mpmath cross-check")
    log("=" * 78)

    for q in primes:
        x = sp.Symbol("x")
        phi = sp.Poly(sp.cyclotomic_poly(q, x), x, domain=sp.ZZ)
        zeta = mp.expj(2 * mp.pi / q)
        a, b = tp.two_square_rep(q)
        c = 1

        # (1) character tables agree
        chi = tp.legendre_table(q)
        char_ok = all(int(chi[h]) == chi2_sympy(q, h) for h in range(q))

        # (2) Jacobi sum
        J = jacobi_sum_mp(q)
        jac_ok = (abs(abs(J.real) - a) < mp.mpf("1e-40")
                  and abs(abs(J.imag) - b) < mp.mpf("1e-40"))

        # (3) the identity, numerically at 50 digits
        lhs = sum(chi2_sympy(q, A) * k_mp(q, A, c, zeta) ** 2 for A in range(q))
        rhs = 2 * chi2_sympy(q, 2 * c) * (a * a - b * b) * mp.sqrt(q)
        num_ok = abs(lhs - rhs) < mp.mpf("1e-35") * max(1, abs(rhs))

        # (4) the reduction, via sympy's remainder
        signed, _ = tp.k_sum_vectors(q, c)
        mine = sp.Poly(tp.reduce_mod_cyclotomic(signed, q)[::-1], x, domain=sp.ZZ)
        direct = sp.Poly([int(v) for v in signed][::-1], x, domain=sp.ZZ).rem(phi)
        red_ok = sp.expand(mine.as_expr() - direct.as_expr()) == 0

        good = char_ok and jac_ok and num_ok and red_ok
        ok &= good
        print(f"  q={q:>3}  chi2={char_ok}  J=+-(a+bi)={jac_ok}  "
              f"identity(50 dps)={num_ok}  reduction={red_ok}  -> {'OK' if good else 'FAIL'}")
        if not good:
            print(f"        a,b=({a},{b})  lhs={mp.nstr(lhs, 20)}  rhs={mp.nstr(rhs, 20)}")

    print("\n" + "=" * 78)
    print(f"  all ok: {ok}")
    print(f"\nEXIT={0 if ok else 1}")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
