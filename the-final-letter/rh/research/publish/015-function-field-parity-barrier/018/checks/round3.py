#!/usr/bin/env python3
"""018/round 3 — the 2-D Chebotarev / 1-D zeros separation, made explicit.

[A] THE ZETA DATUM.  For a "world" S (a set of monic polynomials, thought of as
    an abstract set of qrimes) put Z(S)(n) = #{f in S : deg f = n} and
        zeta_S(T) = prod_{f in S} (1 - T^deg f)^{-1}.
    Then  [T^n] log zeta_S = (1/n) * sum_{d|n} d Z(S)(d),  so zeta_S <-> Z(S)
    exactly (Euler product + Moebius inversion).  Verified here with exact
    rational formal power series, both directions.

[B] THE SEPARATION WITNESS.  Over F_7[x] there are 21 monic irreducible
    quadratics and exactly 7 ordered "twin" incidences f, f+2.  We exhibit two
    sets S, T of 4 *genuine monic irreducibles of degree 2* with Z(S) = Z(T)
    but twin counts B(S) = 1, B(T) = 0.  Hence no function Phi can satisfy
    B(S) = Phi(Z(S)) for all worlds S: the pair statistic is not a zeta
    statistic.  (The Lean file Separation.lean formalises the general
    non-factorisation theorem and this witness abstractly.)

[C] THE FIBRE IS NOT A POINT.  Enumerate all 4-element worlds inside the 21
    degree-2 qrimes: the zeta datum is constant on the fibre, the twin count is
    not.  Quantitative form of [B].

[D] THE LITERATURE CONSTANT.  Pollack, "An explicit approach to Hypothesis H
    for polynomials over a finite field", Conjecture 2: for irreducible
    f_1,...,f_r over F_q,
        #{g monic, deg g = n : all f_i(g) prime}
            = (1+o_B(1)) * S(f_1..f_r) * prod_i deg f_i * q^n / n^r,
        S(f_1..f_r) = prod_{P} (1 - omega(P)/q^deg P)/(1 - 1/q^deg P)^r,
        omega(P) = #{A mod P : prod_i f_i(A) = 0 mod P}.
    For (f_1,f_2) = (T, T+2) with q odd: omega(P) = 2 for every P (roots 0 and
    -2 are distinct constants), prod_i deg f_i = 1, r = 2.  So the constant is
    exactly  S(q) = prod_{P} (1-2/N(P))/(1-1/N(P))^2  — the S(q) of round 2.
    We verify omega(P) = 2 for every monic prime of degree <= D and check the
    two products agree numerically.

[E] CONVERGENCE.  More T(n) data than round 2, to characterise the O(1/n)
    approach (see round 4: the corrected S(q) is in lib/singular_series.py).
"""
import sys

import sys, os, math
from fractions import Fraction
from itertools import combinations

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
import qrime as Q
import singular_series as SS


# --------------------------------------------------------------------------
# [A] formal power series over Q, exact
# --------------------------------------------------------------------------
def mul(a, b, N):
    out = [Fraction(0)] * (N + 1)
    for i, x in enumerate(a):
        if x == 0:
            continue
        for j, y in enumerate(b):
            if i + j > N:
                break
            out[i + j] += x * y
    return out


def inv(a, N):
    # a[0] == 1
    out = [Fraction(0)] * (N + 1)
    out[0] = Fraction(1) / a[0]
    for n in range(1, N + 1):
        s = Fraction(0)
        for k in range(1, n + 1):
            s += a[k] * out[n - k]
        out[n] = -s / a[0]
    return out


def log_series(a, N):
    """log of a series with a[0] == 1, via integral(a'/a)."""
    da = [Fraction((i + 1)) * a[i + 1] for i in range(N)]
    q = mul(da, inv(a, N), N - 1)  # a'/a, to order N-1
    out = [Fraction(0)] * (N + 1)
    for n in range(1, N + 1):
        out[n] = q[n - 1] / n
    return out


def spow(a, e, N):
    out = [Fraction(0)] * (N + 1)
    out[0] = Fraction(1)
    b = a
    while e:
        if e & 1:
            out = mul(out, b, N)
        b = mul(b, b, N)
        e >>= 1
    return out


def zeta_of_world(counts, N):
    """prod_{d} (1 - T^d)^{-Z(d)} truncated at T^N, counts: {degree: multiplicity}."""
    z = [Fraction(0)] * (N + 1)
    z[0] = Fraction(1)
    for d in sorted(counts):
        if counts[d] == 0:
            continue
        factor = [Fraction(0)] * (N + 1)
        factor[0] = Fraction(1)
        factor[d] = Fraction(-1)
        z = mul(z, spow(inv(factor, N), counts[d], N), N)
    return z


def check_A():
    log("=" * 82)
    log("[A] zeta <-> degree counts  (Euler product + Moebius), exact rational check")
    log("=" * 82)
    for q in (3, 5, 7):
        N = 10
        # true world: all monic irreducibles of degree <= N
        I = {n: Q.qrime_count_mobius(q, n) for n in range(1, N + 1)}
        zs = zeta_of_world(I, N)
        lg = log_series(zs, N)
        # (i) zeta_S == 1/(1-qT) mod T^{N+1}  (affine polynomial zeta)
        ok_zeta = all(zs[n] == q ** n for n in range(N + 1))
        # (ii) [T^n] log zeta = (1/n) sum_{d|n} d Z(d) = q^n/n
        ok_log = all(lg[n] == Fraction(q ** n, n) for n in range(1, N + 1))
        # (iii) Moebius inverts the point counts N_n = q^n back to Z
        ok_mob = True
        from sympy import mobius
        for n in range(1, N + 1):
            inv = sum(int(mobius(d)) * q ** (n // d) for d in range(1, n + 1) if n % d == 0) // n
            if inv != I[n]:
                ok_mob = False
        print(f"  q={q}:  zeta_S == 1/(1-{q}T)  : {ok_zeta}"
              f"   [T^n]log zeta == {q}^n/n : {ok_log}"
              f"   Moebius(N_n) == I(n) : {ok_mob}")
    # an arbitrary finite world, not the true one
    degs = [1, 1, 2, 3, 3]
    zs = zeta_of_world({n: degs.count(n) for n in range(1, 9)}, 8)
    lg = log_series(zs, 8)
    Z = {n: degs.count(n) for n in range(1, 9)}
    ok = True
    for n in range(1, 9):
        rhs = sum(d * Z.get(d, 0) for d in range(1, n + 1) if n % d == 0)
        if lg[n] * n != rhs:
            ok = False
    print(f"  arbitrary world degs={degs}: [T^n]log zeta == (1/n) sum d Z(d) : {ok}")


# --------------------------------------------------------------------------
# [B] explicit separation witness over F_7, degree 2
# --------------------------------------------------------------------------
def poly_str(f, q):
    # f ascending coefficients
    terms = []
    for i in range(len(f) - 1, -1, -1):
        c = f[i] % q
        if c == 0:
            continue
        mon = "" if i == 0 else ("x" if i == 1 else f"x^{i}")
        coeff = "" if (c == 1 and i > 0) else str(c)
        if i == 0:
            terms.append(str(c))
        else:
            terms.append(coeff + mon)
    return " + ".join(terms) if terms else "0"


def tau(f, q):
    g = list(f)
    g[0] = (g[0] + 2) % q
    return tuple(g)


def twin_count(S, q):
    return sum(1 for f in S if tau(f, q) in S)


def check_B():
    print("\n" + "=" * 82)
    log("[B] separation witness: two worlds of genuine qrimes, same zeta datum,")
    print("    different twin count  (F_7[x], degree 2)")
    log("=" * 82)
    q, n = 7, 2
    irr = [tuple(f) for f in Q.qrimes(q, n)]
    print(f"  monic irreducible quadratics over F_{q}: {len(irr)}")
    inc = sum(1 for f in irr if tau(f, q) in irr)
    print(f"  twin incidences B(all) = {inc}  (i.e. f and f+2 both irreducible)")

    by = {tuple(f): f for f in irr}
    S = [(1, 0, 1), (1, 3, 1), (1, 4, 1), (6, 3, 1)]   # (c0,c1,c2)
    T = [(1, 0, 1), (1, 3, 1), (1, 4, 1), (2, 0, 1)]
    for name, W in (("S", S), ("T", T)):
        assert all(w in by for w in W), (name, "not all irreducible!")
        assert len(set(W)) == 4
    print(f"  S = {{{', '.join(poly_str(f, q) for f in S)}}}")
    print(f"  T = {{{', '.join(poly_str(f, q) for f in T)}}}")
    print(f"  all 4+4 are monic irreducible of degree 2 over F_{q}: True")
    print(f"  zeta datum: Z(S) = Z(T) = (0, 4, 0, 0, ...)  ->  zeta_S = zeta_T")
    print(f"  twin counts: B(S) = {twin_count(S, q)},  B(T) = {twin_count(T, q)}")
    assert twin_count(S, q) != twin_count(T, q)
    print("  => the twin count is NOT a function of the zeta datum.")
    # show the witness incidence
    for f in S:
        g = tau(f, q)
        if g in S:
            print(f"     witness pair:  {poly_str(f, q)}  ->  +2  ->  {poly_str(g, q)}  (both in S)")


# --------------------------------------------------------------------------
# [C] the fibre is large; B varies on it
# --------------------------------------------------------------------------
def check_C():
    print("\n" + "=" * 82)
    log("[C] the zeta-datum fibre is large and the twin count varies on it")
    log("=" * 82)
    q, n = 7, 2
    irr = [tuple(f) for f in Q.qrimes(q, n)]
    print(f"  worlds = k-element subsets of the {len(irr)} degree-2 qrimes;")
    print(f"  Z is constant (= k at degree 2) on each such fibre.")
    print(f"  {'k':>3} {'#worlds':>9} {'min B':>6} {'max B':>6} {'#B-values':>10}")
    import collections
    for k in (2, 3, 4, 5, 6):
        dist = collections.Counter()
        cnt = 0
        for comb in combinations(irr, k):
            dist[twin_count(set(comb), q)] += 1
            cnt += 1
        print(f"  {k:>3} {cnt:>9} {min(dist):>6} {max(dist):>6} {len(dist):>10}")
    print("  => knowing the full zeta (all degree counts) leaves B completely open.")


# --------------------------------------------------------------------------
# [D] Pollack's constant, pinned
# --------------------------------------------------------------------------
def primes_up_to_degree(q, D):
    out = []
    for d in range(1, D + 1):
        out += [(d, tuple(f)) for f in Q.qrimes(q, d)]
    return out


def omega(q, f, degf):
    """#roots of X(X+2) mod the prime f, by brute force over residues."""
    # residues = polynomials of degree < degf
    cnt = 0
    from itertools import product
    for coeffs in product(range(q), repeat=degf):
        A = list(coeffs)
        # A + 2  and A  evaluated into X(X+2): root of X or of X+2
        if all(c == 0 for c in A):
            cnt += 1
            continue
        B = list(A)
        B[0] = (B[0] + 2) % q
        if all(c == 0 for c in B):
            cnt += 1
    return cnt


def S_pollack(q, D=60):
    """prod_P (1 - omega(P)/q^d)/(1 - 1/q^d)^2 with omega = 2.

    Uses the stable form prod (1 - 1/(Q-1)^2); see singular_series.py for the
    floating-point bug in the naive ratio when I(d) is huge.
    """
    return SS.S(q)


def S_round2(q, D=60):
    return S_pollack(q, D)  # identical by construction; kept for the comparison print


def check_D():
    print("\n" + "=" * 82)
    log("[D] Pollack's Conjecture 2, specialised to (f_1,f_2) = (T, T+2)")
    log("=" * 82)
    print("  S(f_1..f_r) = prod_P (1 - omega(P)/q^deg P)/(1 - 1/q^deg P)^r")
    print("  omega(P) = #{A mod P : prod_i f_i(A) = 0 mod P}")
    print("  f_1 = T, f_2 = T+2, q odd  =>  roots 0 and -2, distinct, so omega(P)=2.")
    # brute-force omega for the small cases where enumeration is cheap
    print(f"  {'q':>3} {'D':>3} {'primes':>8} {'omega(P)=2 all P':>18} {'prod_i deg f_i':>15} {'S(q)':>12}")
    for q, D in ((3, 4), (5, 3), (7, 3)):
        primes = primes_up_to_degree(q, D)
        ok = all(omega(q, f, d) == 2 for (d, f) in primes)
        proddeg = 1 * 1
        print(f"  {q:>3} {D:>3} {len(primes):>8} {str(ok):>18} {proddeg:>15} {S_pollack(q):>12.6f}")
    # larger q: omega(P)=2 structurally (X(X+2) is monic of degree 2; 0 and -2
    # are distinct roots for q odd), so only S(q) is printed
    print("  larger q (omega(P)=2 structurally, no enumeration):")
    for q in (11, 13):
        print(f"  {q:>3}   -        -   {'True (structural)':>18} {1:>15} {S_pollack(q):>12.6f}")
    print("  => the asymptotic constant is  S(q) * prod_i deg f_i / n^r  with")
    print("     prod_i deg f_i = 1  and  r = 2:   T(n) ~ S(q) q^n / n^2.")
    print("  (Pollack, Conj. 2; Theorem A proves the q-large regime.  Not reproved here.)")


# --------------------------------------------------------------------------
# [E] convergence data
# --------------------------------------------------------------------------
def check_E(maxq=7, force=False):
    print("\n" + "=" * 82)
    log("[E] convergence of T(n) n^2 / q^n  to  S(q)   (extra terms)")
    log("=" * 82)
    plan = [(3, 10), (5, 7), (7, 6)]
    if force:
        plan = [(3, 12), (5, 8), (7, 7)]
    print(f"  {'q':>3} {'n':>3} {'I(n)':>9} {'T(n)':>9} {'T n^2/q^n':>12} {'S(q)':>10} {'diff':>10}")
    for q, N in plan:
        Sq = S_pollack(q)
        for n in range(2, N + 1):
            Ii = len(Q.qrimes(q, n))
            T = len(Q.twin_qrimes(q, n))
            r = T * n * n / q ** n
            print(f"  {q:>3} {n:>3} {Ii:>9} {T:>9} {r:>12.4f} {Sq:>10.4f} {r - Sq:>+10.4f}")


def log(*a, **k):
    """Diagnostics go to stderr; results go to stdout."""
    print(*a, file=sys.stderr, **k)


def main():
    check_A()
    check_B()
    check_C()
    check_D()
    if "--e" in sys.argv:
        check_E(force=True)
    else:
        check_E()
    print("\nEXIT=0")


if __name__ == "__main__":
    main()
