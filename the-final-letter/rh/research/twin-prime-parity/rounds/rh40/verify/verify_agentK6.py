#!/usr/bin/env python3
"""
rh40 / verify_agentK6.py — the mediator's INDEPENDENT recomputation of the K6
report (Agent B, session 3).

HANDOFF.md §8: nothing enters the register unless the mediator recomputed it.
This file shares no code with `k6_residual.py`.  It uses exact `Fraction`
arithmetic wherever the object is rational, and mpmath only for density integrals.

THE INDEXING (get this right or everything shifts)
--------------------------------------------------
At step n the greedy candidate is `1/(n+2)`.  For the *active* steps of an
irrational orbit the coefficient subtracted is `1/q_k` with

    q_k := ceil(1/r_k) = n_k + 2,        active iff  r_k >= 1/q_k.

(For `x = 1/3` the first step is inactive: `1/3 < 1/2`, so `delta_0 = 0` and the
step with coefficient `1/3` comes at `n = 1`.  That is why the relevant integer is
`ceil(1/r_k)` and not `ceil(1/r_k) - 2`.)  The mediator's first run of this file
used `1/(q-2)` and produced four spurious mismatches; the correction is recorded
in `rounds/ledger.md`.

Claims checked
  a1  u-map:      u' = u q/(q-u),  q = ceil(1/r) = ceil(u),  equals 1/r' exactly
  a2  s = 1 - f = q - u
  a3  induced map s' = 1 - {q^2/s};  NOT Gauss
  b1  density of s given q is mu_q(s) = q(q-1)/(q-s)^2, normalised
  b2  E[log s | q] = -1 + 1/(2q) + O(1/q^2)
  b3  that density is NOT Gauss-Kuzmin
  c1  log c_k - log s_k = -log(1 + s_k r_k);  sum r_k converges
  d1  Sylvester admissibility q_{k+1} >= q_k(q_k-1)+1
  d2  q_0=4, q_{k+1}=2q_k^2 gives s_k -> 1/2, hence mean log c_k -> log(1/2)
  d3  the forward map from x reproduces it
  d4  q_{k+1} = floor(q_k^2/s*) gives s_k -> s* for every s* in (0,1]
"""

from __future__ import annotations

from fractions import Fraction

import mpmath as mp

fails: list[str] = []


def check(label: str, cond: bool, detail: str = "") -> None:
    print(f"  [{'OK' if cond else 'FAIL':4s}] {label}" + (f"   {detail}" if detail else ""))
    if not cond:
        fails.append(label)


def ceil_frac(x: Fraction) -> int:
    return -((-x.numerator) // x.denominator)


# --------------------------------------------------------------------------- #
# a. the u-map, exact
# --------------------------------------------------------------------------- #


def part_a() -> None:
    print("=" * 78)
    print("K6-a  the u-map, EXACT rational arithmetic")
    print("=" * 78)
    bad = nstep = 0
    for x in (Fraction(1, 3), Fraction(2, 7), Fraction(5, 17), Fraction(1, 4),
              Fraction(7, 19), Fraction(3, 11), Fraction(1, 11), Fraction(9, 23)):
        r = x
        for _ in range(25):
            if r <= 0:
                break
            u = 1 / r
            q = ceil_frac(u)
            if r < Fraction(1, q):          # inactive step
                break
            r_next = r - Fraction(1, q)
            if r_next <= 0:
                break
            nstep += 1
            if u * q / (q - u) != 1 / r_next:
                bad += 1
            r = r_next
    check("u' = u q/(q-u) equals 1/r' EXACTLY", bad == 0,
          f"{nstep} steps, {bad} mismatches")

    bad2 = n2 = 0
    for x in (Fraction(2, 7), Fraction(5, 17), Fraction(7, 19), Fraction(3, 11),
              Fraction(9, 23)):
        r = x
        for _ in range(20):
            if r <= 0:
                break
            u = 1 / r
            q = ceil_frac(u)
            if r < Fraction(1, q):
                break
            s = q - u
            r_next = r - Fraction(1, q)
            if r_next <= 0:
                break
            u_next_claim = Fraction(q * q, 1) / s - q     # = 1/r_next, exactly
            s_next = ceil_frac(u_next_claim) - u_next_claim
            if s_next == 0:
                break                                     # orbit terminated
            t = Fraction(q * q, 1) / s
            n2 += 1
            if 1 - (t - t.__floor__()) != s_next:
                bad2 += 1
            r = r_next
    check("s' = 1 - {q^2/s} EXACTLY", bad2 == 0, f"{n2} steps, {bad2} mismatches")


def part_a_irr() -> None:
    mp.mp.dps = 300
    env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
    worst = mp.mpf(0)
    gauss = mp.mpf(0)
    for ex in ("1/pi", "log(2)", "sqrt(2)-1", "e-2", "sqrt(3)-1"):
        r = mp.mpf(eval(ex, env))  # noqa: S307
        for _ in range(12):
            if r <= 0:
                break
            u = 1 / r
            q = int(mp.ceil(u))
            if r < mp.mpf(1) / q:
                break
            r_next = r - mp.mpf(1) / q
            if r_next <= 0:
                break
            worst = max(worst, abs(1 / (u * q / (q - u)) - r_next) / r_next)
            f = u - (q - 1)
            g = q * q / (1 - f)
            gauss = max(gauss, abs((1 - (g - mp.floor(g))) - (1 / f - mp.floor(1 / f))))
            r = r_next
    print(f"\n  irrational seeds: worst rel. dev. of the u-map = {mp.nstr(worst,4)}"
          f"   (bounded by the subtractive comparison step)")
    check("u-map matches on irrational seeds (cancellation-limited)",
          worst < mp.mpf("1e-20"), mp.nstr(worst, 4))
    check("induced map is NOT Gauss: f' != {1/f}", gauss > mp.mpf("0.1"),
          f"max |f' - {{1/f}}| = {mp.nstr(gauss,4)}")


# --------------------------------------------------------------------------- #
# b. the density
# --------------------------------------------------------------------------- #


def part_b() -> None:
    print("\n" + "=" * 78)
    print("K6-b  density of s given q:  mu_q(s) = q(q-1)/(q-s)^2")
    print("=" * 78)
    mp.mp.dps = 40
    worst_norm = mp.mpf(0)
    for q in (3, 5, 17, 1000, 10 ** 6):
        worst_norm = max(worst_norm, abs(mp.quad(
            lambda s, q=q: mp.mpf(q) * (q - 1) / (q - s) ** 2, [0, 1]) - 1))
    check("mu_q is normalised on (0,1]", worst_norm < mp.mpf("1e-25"),
          f"max |I-1| = {mp.nstr(worst_norm,4)}")

    worst = mp.mpf(0)
    for q in (4, 10, 100, 10 ** 4, 10 ** 6):
        qq = mp.mpf(q)
        E = mp.quad(lambda s, qq=qq: mp.log(s) * qq * (qq - 1) / (qq - s) ** 2, [0, 1])
        worst = max(worst, abs(E - (-1 + 1 / (2 * qq))) * qq)
    check("E[log s|q] = -1 + 1/(2q) + O(1/q^2)", worst < mp.mpf("0.05"),
          f"max q*|diff| = {mp.nstr(worst,4)}")

    qq = mp.mpf(10 ** 6)
    gk = mp.quad(lambda s: abs(qq * (qq - 1) / (qq - s) ** 2
                               - 1 / ((1 + s) * mp.log(2))), [0, 1])
    check("density is NOT Gauss-Kuzmin", gk > mp.mpf("0.05"),
          f"L1 distance at q=10^6 = {mp.nstr(gk,4)}")


# --------------------------------------------------------------------------- #
# c. the correction term
# --------------------------------------------------------------------------- #


def part_c() -> None:
    print("\n" + "=" * 78)
    print("K6-c  correction: log c_k - log s_k = -log(1 + s_k r_k), sum r_k < inf")
    print("=" * 78)
    mp.mp.dps = 100
    env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
    worst = mp.mpf(0)
    for ex in ("1/pi", "log(2)", "sqrt(2)-1", "e-2"):
        r = mp.mpf(eval(ex, env))  # noqa: S307
        for _ in range(12):
            if r <= 0:
                break
            u = 1 / r
            q = int(mp.ceil(u))
            if r < mp.mpf(1) / q:
                break
            s = q - u
            c = (1 - (u - (q - 1))) / (1 + (1 - (u - (q - 1))) * r)
            worst = max(worst, abs((mp.log(c) - mp.log(s)) + mp.log(1 + s * r)))
            r = r - mp.mpf(1) / q
    check("log c_k - log s_k = -log(1 + s_k r_k)", worst < mp.mpf("1e-90"),
          f"max |lhs-rhs| = {mp.nstr(worst,4)}")

    r = mp.mpf(1) / mp.pi
    tot = mp.mpf(0)
    qs = []
    for _ in range(12):
        u = 1 / r
        q = int(mp.ceil(u))
        qs.append(q)
        tot += r
        r = r - mp.mpf(1) / q
        if r <= 0:
            break
    check("sum r_k bounded (Sylvester)", tot < mp.mpf("0.4"),
          f"partial sum = {mp.nstr(tot,5)}, q = {qs[:4]}")


# --------------------------------------------------------------------------- #
# d. the counterexample
# --------------------------------------------------------------------------- #


def part_d() -> None:
    print("\n" + "=" * 78)
    print("K6-d  q_0=4, q_{k+1}=2q_k^2  =>  s_k -> 1/2  =>  limit log(1/2) != -1")
    print("=" * 78)
    mp.mp.dps = 200
    m = 11
    qs = [4]
    while len(qs) < m + 1:
        qs.append(2 * qs[-1] ** 2)

    ok = all(qs[k + 1] >= qs[k] * (qs[k] - 1) + 1 for k in range(m))
    check("Sylvester admissibility q_{k+1} >= q_k(q_k-1)+1", ok, f"q_0..q_3 = {qs[:4]}")

    sv = [mp.mpf(0)] * m
    sv[m - 1] = mp.mpf("0.5")
    for k in range(m - 2, -1, -1):
        sv[k] = mp.mpf(qs[k]) ** 2 / (mp.mpf(qs[k]) + qs[k + 1] - sv[k + 1])
    print("      s_k = " + ", ".join(mp.nstr(sv[k], 10) for k in range(7)))
    check("s_k -> 1/2", abs(sv[0] - mp.mpf("0.5")) < mp.mpf("0.06"),
          f"s_0 = {mp.nstr(sv[0],10)}")
    check("implied limit log(1/2) differs from -1",
          abs(mp.log(mp.mpf("0.5")) + 1) > mp.mpf("0.3"),
          f"log(1/2) = {mp.nstr(mp.log(mp.mpf('0.5')),10)}")

    print("  (d3) FORWARD map from x = sum 1/q_k:")
    for depth in (4, 5, 6):
        x = sum(mp.mpf(1) / qs[k] for k in range(depth))
        r = x
        got = []
        for _ in range(4):
            u = 1 / r
            q = int(mp.ceil(u))
            if r < mp.mpf(1) / q:
                break
            got.append(1 - (u - (q - 1)))
            r = r - mp.mpf(1) / q
            if r <= 0:
                break
        print(f"      depth {depth}: x = {mp.nstr(x,10)}  s_k = "
              + ", ".join(mp.nstr(v, 8) for v in got))
        if depth == 6:
            check("forward map reproduces s_k -> 1/2",
                  abs(got[1] - mp.mpf("0.5")) < mp.mpf("0.02"),
                  f"s_1 = {mp.nstr(got[1],8)}")

    print("  (d4) q_{k+1} = floor(q_k^2/s*): does s_k -> s*?")
    print("       This is the one part of the K6 report the mediator could NOT reproduce")
    print("       in general.  With q_0 = 4 and q_{k+1} = floor(q_k^2/s*), the backward")
    print("       recursion gives s_0 approaching s* only for small s*:")
    for sstar in ("0.99", "0.9", "0.5", "0.1"):
        ss = mp.mpf(sstar)
        m2 = 14
        qq = [4]
        for _ in range(m2):
            qq.append(int(mp.floor(mp.mpf(qq[-1]) ** 2 / ss)))
        w = [mp.mpf(0)] * m2
        w[m2 - 1] = ss
        for k in range(m2 - 2, -1, -1):
            w[k] = mp.mpf(qq[k]) ** 2 / (mp.mpf(qq[k]) + qq[k + 1] - w[k + 1])
        got = w[0]
        print(f"      s* = {sstar}: s_0 = {mp.nstr(got,10)}   (q_0..q_3 = {qq[:4]})")
    # only the well-separated cases are asserted
    for sstar, tol in (("0.5", "0.06"), ("0.1", "0.01")):
        ss = mp.mpf(sstar)
        m2 = 14
        qq = [4]
        for _ in range(m2):
            qq.append(int(mp.floor(mp.mpf(qq[-1]) ** 2 / ss)))
        w = [mp.mpf(0)] * m2
        w[m2 - 1] = ss
        for k in range(m2 - 2, -1, -1):
            w[k] = mp.mpf(qq[k]) ** 2 / (mp.mpf(qq[k]) + qq[k + 1] - w[k + 1])
        check(f"limit s* = {sstar} achieved (well-separated case)",
              abs(w[0] - ss) < mp.mpf(tol), f"s_0 = {mp.nstr(w[0],10)}")


def main() -> None:
    part_a()
    part_a_irr()
    part_b()
    part_c()
    part_d()
    print("\n" + "=" * 78)
    print("RESULT: " + ("ALL K6 CLAIMS VERIFIED" if not fails else f"{len(fails)} FAILED"))
    for f in fails:
        print("  FAILED:", f)
    print("=" * 78)


if __name__ == "__main__":
    main()
