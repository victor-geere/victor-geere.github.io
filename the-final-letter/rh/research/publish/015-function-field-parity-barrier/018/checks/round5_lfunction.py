#!/usr/bin/env python3
"""018/round 5 — the twin count as a Frobenius trace, not a sieve quantity.

The barrier in the 018 dictionary: the twin indicator is *not multiplicative*
(no Euler product), so the twin count is not a zeta coefficient.  In F_q[x] the
count is instead a Chebotarev / Frobenius-trace quantity.  This script makes the
trace interpretation concrete in degree 3, where Bary-Soker–Stix show that the
geometry involves the elliptic curve

    E : Y^2 - Y = X^3        (j = 0) .

[A] E: point count by direct enumeration vs the character sum, sympy-checked.
[B] T(3) vs the "clean" formula  q(q-2)(q+1)/9  and the elliptic-curve trace
    c_q = q + 1 - #E(F_q).  Observation: for every prime q >= 5,
        T(3) = q(q-2)(q+1)/9   <=>   c_q = 0   <=>   q = 2 (mod 3)
    i.e. the clean formula holds exactly in the *supersingular* case.
[C] The ordinary case q = 1 (mod 3): the deviation is a nonzero arithmetic
    quantity, not a smooth function of q.
[D] What this says about the barrier, and the round-5 wild guess.
"""
import os
import sys
from fractions import Fraction

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
import fast_twin as F


def primes_upto(N):
    return [p for p in range(3, N + 1) if all(p % d for d in range(2, int(p ** 0.5) + 1))]


def chi(a, q):
    a %= q
    if a == 0:
        return 0
    return 1 if pow(a, (q - 1) // 2, q) == 1 else -1


def E_char_count(q):
    """#E(F_q) for E: Y^2 - Y = X^3, via #E = q+1+sum_X chi(1+4X^3)."""
    return q + 1 + sum(chi(1 + 4 * pow(X, 3, q), q) for X in range(q))


def E_brute_count(q):
    """#E(F_q) by enumerating (X,Y) and adding the point at infinity."""
    n = 1
    for X in range(q):
        rhs = pow(X, 3, q)
        for Y in range(q):
            if (Y * Y - Y - rhs) % q == 0:
                n += 1
    return n


def check_A():
    log("=" * 76)
    log("[A] E: Y^2 - Y = X^3  over F_q:  character sum vs direct enumeration")
    log("=" * 76)
    print(f"  {'q':>3} {'sum_X chi(1+4X^3)':>18} {'#E (char)':>10} {'#E (brute)':>11} {'same':>5}")
    ok = True
    for q in (5, 7, 11, 13, 17, 19, 23, 29, 31):
        s = sum(chi(1 + 4 * pow(X, 3, q), q) for X in range(q))
        a, b = q + 1 + s, E_brute_count(q)
        ok &= (a == b)
        print(f"  {q:>3} {s:>18} {a:>10} {b:>11} {str(a == b):>5}")
    print("  all agree:", ok)
    assert ok


def check_B():
    print("\n" + "=" * 76)
    log("[B] T(3), the clean formula, and the elliptic-curve trace")
    log("=" * 76)
    print(f"  {'q':>3} {'q%3':>4} {'T(3)':>7} {'clean':>10} {'dev':>10} {'c_q':>5} {'dev=0':>6} {'c=0':>5}")
    ok_pattern = True
    for q in primes_upto(120):
        T = F.twin_count_fast(q, 3)
        clean = Fraction(q * (q - 2) * (q + 1), 9)
        dev = T - clean
        c = q + 1 - E_char_count(q)
        if q >= 5:
            same = (dev == 0) == (c == 0)
            ok_pattern &= same
        else:
            same = None
        if q <= 61:
            print(f"  {q:>3} {q % 3:>4} {T:>7} {float(clean):>10.3f} {float(dev):>+10.3f} "
                  f"{c:>5} {str(dev == 0):>6} {str(c == 0):>5}")
    print(f"\n  for every prime 5 <= q <= 120: (dev == 0) <=> (c_q == 0): {ok_pattern}")
    assert ok_pattern


def check_C():
    print("\n" + "=" * 76)
    log("[C] supersingularity: for prime q != 3,  c_q = 0  <=>  q = 2 (mod 3)")
    log("=" * 76)
    ok = True
    for q in primes_upto(200):
        if q == 3:
            continue
        c = q + 1 - E_char_count(q)
        ok &= ((c == 0) == (q % 3 == 2))
    print("  holds for all primes 5 <= q <= 200:", ok)
    assert ok
    print("  (j = 0; the curve is supersingular exactly for p = 2 mod 3.)")
    print("\n  Consequence: the 'clean' formula T(3) = q(q-2)(q+1)/9 holds exactly")
    print("  in the supersingular case.  In the ordinary case the deviation is a")
    print("  nonzero arithmetic quantity, governed by the elliptic curve's")
    print("  Frobenius / L-function — not by the zeta of P^1.")


def log(*a, **k):
    """Diagnostics go to stderr; results go to stdout."""
    print(*a, file=sys.stderr, **k)


def main():
    check_A()
    check_B()
    check_C()
    print("\n" + "=" * 76)
    log("[D] reading")
    log("=" * 76)
    print("  The zeta of P^1 has no zeros, yet T(3) is governed by E: Y^2-Y=X^3.")
    print("  So the twin count is a Frobenius trace on a *different* motive, not a")
    print("  zeta coefficient.  This is the function-field form of the parity")
    print("  barrier: the relevant L-function is not zeta, and over Q it is the")
    print("  missing object.")
    print("\nEXIT=0")


if __name__ == "__main__":
    main()
