#!/usr/bin/env python3
"""018/round 4, step 3 — lifting the separation to a curve.

On a curve C with a map π: C → P¹, the "twin" pair statistic is

    P_π(n) = #{ ℘ : deg ℘ = n,  π(℘) and π(℘)+2 both prime } .

The curve's zeta determines Z_C(n) (the degree counts of its primes), but the
map π is extra structure.  We show on a *single* curve that varying π changes
P_π while Z_C is fixed.

Witness: C = P¹ over F_5, degree 2.  For a ∈ F_5^*, π_a(x) = a x.  Since
a f + 2 = a (f + 2/a) and irreducibility is unit-invariant,

    P_{π_a}(n) = #{ f monic deg n : f and f + 2/a both irreducible }
               = T_{2/a}(n) ,

the twin count with shift δ = 2/a.  Over F_5 at n = 2 this is 0 for a = 1, 4
and 5 for a = 2, 3.  Same curve, same zeta, different pair count.

[A] direct enumeration of all shifts δ
[B] interpretation as maps π_a
[C] sympy cross-check
[D] the zeta datum is the same for every map
"""
import sys

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
import qrime as Q

q = 5
n = 2


def pair_count(delta):
    return len(Q.twin_qrimes_shift(q, n, delta))


def check_A():
    log("=" * 74)
    print(f"[A] F_{q}[x], degree {n}: pair counts for every shift delta")
    log("=" * 74)
    print(f"  {'delta':>5} {'#pairs':>7}")
    for d in range(q):
        print(f"  {d:>5} {pair_count(d):>7}")
    return {d: pair_count(d) for d in range(q)}


def check_B(counts):
    print("\n" + "=" * 74)
    log("[B] maps pi_a(x) = a x on the *same* curve P^1 induce delta = 2/a")
    log("=" * 74)
    print(f"  {'a':>3} {'delta=2/a':>10} {'P_pi_a(2)':>10}")
    rows = []
    for a in range(1, q):
        delta = (2 * pow(a, -1, q)) % q
        c = counts[delta]
        rows.append((a, delta, c))
        print(f"  {a:>3} {delta:>10} {c:>10}")
    assert {c for (_, _, c) in rows} == {0, 5}, rows
    print("  => the same curve and the same zeta give pair counts 0 and 5.")
    print("     (a = 1: pi_1(x)=x, delta=2;  a = 2: pi_2(x)=2x, delta=1.)")


def check_C():
    print("\n" + "=" * 74)
    log("[C] sympy cross-check (independent irreducibility test over GF(5))")
    log("=" * 74)
    import sympy as sp
    x = sp.symbols('x')

    def irr(b, c):
        return sp.Poly(x ** 2 + b * x + c, x, modulus=q).is_irreducible

    ok = True
    print(f"  {'delta':>5} {'our count':>10} {'sympy':>8}")
    for d in range(q):
        sy = sum(1 for b in range(q) for c in range(q) if irr(b, c) and irr(b, c + d))
        print(f"  {d:>5} {pair_count(d):>10} {sy:>8}")
        ok &= (sy == pair_count(d))
    print("  all shifts agree:", ok)
    assert ok


def check_D():
    print("\n" + "=" * 74)
    log("[D] the zeta datum Z_C is the same for every map")
    log("=" * 74)
    I2 = Q.qrime_count_mobius(q, n)
    print(f"  zeta of P^1/F_{q}:  zeta(T) = 1/((1-T)(1-{q}T)), numerator 1 (no zeros)")
    print(f"  degree-{n} qrime count I({n}) = {I2}  (independent of pi)")
    print("  => Z_C is fixed; only the map pi changes.")
    assert I2 == 10


def log(*a, **k):
    """Diagnostics go to stderr; results go to stdout."""
    print(*a, file=sys.stderr, **k)


def main():
    counts = check_A()
    check_B(counts)
    check_C()
    check_D()
    print("\nEXIT=0")


if __name__ == "__main__":
    main()
