"""Reference emitter: a rational `Cx` enclosure of `ζ(1/2 + 14i)`.

This is the step-3 companion to `EMCritical.lean`.  It mirrors, in exact
rational arithmetic, the Lean expression

    B = sum_{n=1..N} cpowBox(n, S14)
      + cpowBox(N+1, S14) * <1/2 + s/(12(N+1))>
      + cpowBox(N+1, S2 ) * <1/(s-1)>

which encloses `zetaEMGen 1 N s` at `s = 1/2 + 14i`, where

    zetaEMGen 1 N s = zetaBase N s + (1/12) * s * (N+1)^(-(s+1))     (T346 / `zetaEMGen_one`)
    zetaBase   N s = sum_{n<N} (n+1)^(-s) + (N+1)^(1-s)/(s-1) + (N+1)^(-s)/2

and `S14` is the point box at `s`, `S2` the point box at `s - 1`.

Combined with the certified remainder bound (T300)

    ||zetaEMRemainder 1 N s|| <= (1/12) * ||(s)_2|| * ((N+1)^(-sigma-2) + (N+1)^(1-sigma-2)/(sigma+1))

this yields `|zeta(s)| <= |corner(B)| + remainder`, which is what the Lean
`native_decide` target checks.

Run from this directory:

    python3 emit_em.py            # N = 40
    python3 emit_em.py 20         # other term counts

Parameters
----------
The `CpowBox` layer needs the scaled exponent inside `[-1, 1]`:

    |Im s * log b| / kI <= 1,   |Re s * log b| / k <= 1.

At `Im s = 14` and `b = 41` this forces `kI >= 52`, so `kI = 64` (not the
`kI = 32` used by `Cert.lean` at height 5).  The price is that `expIBox`
computes `exp(i t / kI)^kI` by *sequential* interval multiplication, whose
width is amplified by roughly `2^(kI/2)`; the Taylor order must therefore be
large enough to compensate.  Measured (see `HANDOFF.md`):

    params                 corner of B
    (10, 10, 64, 12)       50.5     <- useless
    (14, 16, 64, 20)        0.10570  <- tight, correct

so `n = 20` is required, not the `n = 12` of `paramsFast`.
"""

from __future__ import annotations

import math
import sys

import emit_blocks as eb
from fractions import Fraction as F

SRE = F(1, 2)
SIM = F(14)

#: (log series length, real exp split, imaginary exp split, Taylor order)
PARAMS = (14, 16, 64, 20)


def point_box(re: F, im: F):
    """The degenerate `Cx` box containing the single point `re + im*i`."""
    return ((F(re), F(re)), (F(im), F(im)))


def zeta_box(n_terms: int, params=PARAMS):
    """The rational box `B` enclosing `zetaEMGen 1 n_terms (1/2 + 14i)`."""
    n_log, k, k_i, taylor = params
    s = point_box(SRE, SIM)
    s_minus_one = point_box(SRE - 1, SIM)

    total = point_box(F(0), F(0))
    for n in range(1, n_terms + 1):
        total = eb.cx_add(total, eb.cpow_box(n_log, k, k_i, taylor, n, s))

    b = n_terms + 1
    # (N+1)^(-s) * (1/2 + s/(12 (N+1)))
    scalar_neg = point_box(F(1, 2) + SRE / (12 * b), SIM / (12 * b))
    total = eb.cx_add(total, eb.cx_mul(eb.cpow_box(n_log, k, k_i, taylor, b, s), scalar_neg))

    # (N+1)^(1-s) / (s-1); at s = 1/2 + 14i we have 1/(s-1) = (-2 - 56i)/785 exactly.
    scalar_pole = point_box(F(-2, 785), F(-56, 785))
    total = eb.cx_add(total, eb.cx_mul(eb.cpow_box(n_log, k, k_i, taylor, b, s_minus_one), scalar_pole))
    return total


def corner(box) -> float:
    """`sqrt(maxAbs(re)^2 + maxAbs(im)^2)`: the norm bound the box certifies."""
    def max_abs(iv):
        return max(abs(iv[0]), abs(iv[1]))

    return math.sqrt(float(max_abs(box[0]) ** 2 + max_abs(box[1]) ** 2))


def remainder_bound(n_terms: int) -> float:
    """T300 at `K = 1`, with `||(s)_2|| <= 225` (`||s|| <= 14.5`, `||s+1|| <= 15.5`)."""
    b = F(n_terms + 1)
    bf = float(b)
    return (225.0 / 12.0) * (bf ** -2.5 + bf ** -2.0 / 1.5)


def main(argv: list[str]) -> int:
    n_terms = int(argv[1]) if len(argv) > 1 else 40
    box = zeta_box(n_terms)
    c = corner(box)
    r = remainder_bound(n_terms)
    print(f"parameters        : {PARAMS}  (N_log, k, kI, n)")
    print(f"terms N           : {n_terms}")
    print(f"re                : [{float(box[0][0]):.10f}, {float(box[0][1]):.10f}]")
    print(f"im                : [{float(box[1][0]):.10f}, {float(box[1][1]):.10f}]")
    print(f"corner  |B|       : {c:.10f}")
    print(f"remainder (T300)  : {r:.3e}")
    print(f"corner + remainder: {c + r:.10f}   (target 0.125)")
    ok = c + r <= 0.125
    print(f"certificate       : {'PASS' if ok else 'FAIL'}")
    if ok:
        print(f"\nnative_decide target radius: 1/8 - {r:.3e} = {0.125 - r:.10f}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))


# ---------------------------------------------------------------- remainder

def tail_bounds(n_terms: int = 20, k_order: int = 2) -> None:
    """The two rational bounds the Lean assembly needs (T306, T307).

    * `zetaEMRemainder 2 20` (T305) with
      `2 Re zeta(4)/(2 pi)^4 = |B_4|/4! = 1/720`,
      `||(s)_4|| <= 14.5*15.5*16.5*17.5 = 64896.6 <= 65000`,
      `21^(-9/2) <= 21^(-4)`, `21^(-7/2)/(7/2) <= 21^(-3)/3`.
    * the `B_4` boundary term with `||P_3|| <= 4320` and `21^(-7/2) <= 21^(-3)`.
    """
    b = n_terms + 1
    bf = F(b)
    # T306: (1/720) * 65000 * (b^-4 + b^-3 / 3)
    bound_rem = F(65000, 720) * (bf ** -4 + bf ** -3 / 3)
    # T307: (1/720) * 4320 * b^-3
    bound_b4 = F(4320, 720) * bf ** -3
    print(f"T306  ||zetaEMRemainder 2 {n_terms} s14|| <= {bound_rem} = {float(bound_rem):.3e}"
          f"   (budget 1/200 = {float(F(1,200)):.3e})  {'PASS' if bound_rem <= F(1,200) else 'FAIL'}")
    print(f"T307  ||B4 boundary term||       <= {bound_b4} = {float(bound_b4):.3e}"
          f"   (budget 1/1000 = {float(F(1,1000)):.3e})  {'PASS' if bound_b4 <= F(1,1000) else 'FAIL'}")
    print(f"total with box corner 11/100: {float(F(11,100) + bound_rem + bound_b4):.6f}  (target 0.125)")


if __name__ == "__main__" and "--tail" in sys.argv:
    tail_bounds()
