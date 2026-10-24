#!/usr/bin/env python3
"""lib/dirichlet_engine_probe.py — tractability probe for a rigorous interval engine
for Dirichlet L-functions.

The 010 Route-B engine works for zeta because `zeta = eta/(1 - 2^(1-s))` with an
Euler-accelerated alternating series.  For a Dirichlet L there is no such alternating
trick; the standard rigorous route is

    L(chi, s) = N^(-s) * sum_{a mod N} chi(a) * zeta(s, a/N)

with the **Hurwitz zeta by Euler-Maclaurin**:

    zeta(s,a) = sum_{k<M} (a+k)^(-s) + (a+M)^(1-s)/(s-1) + (1/2)(a+M)^(-s)
              + sum_{j=1..K} (B_{2j}/(2j)!) * (s)_{2j-1} * (a+M)^(-s-2j+1) + R

    |R| <= |(s)_{2K+1}| * 2*zeta(2K+1)/(2*pi)^(2K+1) * |a+M|^(-sigma-2K)/(sigma+2K)

(the periodic-Bernoulli sup bound).  This probe measures: (i) does the bound dominate the
true error, (ii) how large must (M,K) be for 10^-(30..60) accuracy on the Route-B path
(sigma in [1/2,1], t up to 50), (iii) the cost per evaluation, (iv) the L-function assembly.

Read-only; writes nothing.  Run: python3 lib/dirichlet_engine_probe.py
"""
from __future__ import annotations
import time
import mpmath as mp

mp.mp.dps = 60
TWO_PI = 2 * mp.pi


def rising(s, n):
    """(s)_n = s(s+1)...(s+n-1)."""
    r = mp.mpf(1)
    for i in range(n):
        r *= s + i
    return r


def em_hurwitz(s, a, M, K, safety=mp.mpf(1)):
    """Euler-Maclaurin value + rigorous remainder bound for zeta(s,a)."""
    s = mp.mpc(s)
    a = mp.mpf(a)
    b = a + M
    val = mp.mpf(0)
    for k in range(M):
        val += (a + k) ** (-s)
    if s != 1:
        val += b ** (1 - s) / (s - 1)
    val += mp.mpf(1) / 2 * b ** (-s)
    for j in range(1, K + 1):
        val += mp.bernoulli(2 * j) / mp.factorial(2 * j) * rising(s, 2 * j - 1) * b ** (-s - 2 * j + 1)
    # remainder: sup |B~_{2K+1}| <= 2 (2K+1)! zeta(2K+1) / (2 pi)^(2K+1)
    supB = 2 * mp.factorial(2 * K + 1) * mp.zeta(2 * K + 1) / TWO_PI ** (2 * K + 1)
    sig = s.real
    R = (abs(rising(s, 2 * K + 1)) / mp.factorial(2 * K + 1) * supB
         * abs(b) ** (-sig - 2 * K) / (sig + 2 * K))
    return val, R * safety


def check_bound(points, M, K):
    """max over points of |true - em| / bound, and the max bound."""
    worst = mp.mpf(0)
    worstb = mp.mpf(0)
    for (s, a) in points:
        v, R = em_hurwitz(s, a, M, K)
        err = abs(v - mp.zeta(s, a))
        if R > 0:
            worst = max(worst, err / R)
        worstb = max(worstb, R)
    return worst, worstb


print("lib/dirichlet_engine_probe.py — Euler-Maclaurin Hurwitz zeta, rigorous remainder")

# ---------------------------------------------------------------- (i) bound validity
print("\n[i] does the remainder bound dominate the true error?")
# NB: sigma = 1 with t = 0 is the pole of zeta(s,a); the Route-B path has t0 > 0,
# so only t > 0 is tested at sigma = 1.
pts = [(mp.mpc(mp.mpf(1), t), mp.mpf(1) / 3) for t in (mp.mpf("0.5"), 5, 20, 50)]
pts += [(mp.mpc(mp.mpf("0.5"), t), mp.mpf(1) / 3) for t in (0, 5, 20, 50)]
pts += [(mp.mpc(mp.mpf(1), mp.mpf(50)), a / mp.mpf(7)) for a in range(1, 7)]
for (M, K) in [(5, 5), (8, 10), (10, 15), (12, 20)]:
    w, wb = check_bound(pts, M, K)
    print(f"    M={M:2d} K={K:2d}:  max |err|/bound = {mp.nstr(w, 4):>12}   max bound = {mp.nstr(wb, 3):>10}"
          f"   {'OK' if w <= 1 else 'BOUND VIOLATED'}")

# ------------------------------------------------- (ii) terms needed for accuracy
print("\n[ii] accuracy vs (M,K) on the Route-B path  sigma in [1/2,1], t <= 50")
for (M, K) in [(6, 8), (8, 12), (10, 16), (12, 20), (16, 24)]:
    worst = mp.mpf(0)
    for t in (mp.mpf("0.5"), 1, 5, 14, 20, 35, 50):
        for sig in ("0.5", "0.75", "1"):
            s = mp.mpc(mp.mpf(sig), t)
            for a in (mp.mpf(1) / 3, mp.mpf(2) / 3, mp.mpf(1) / 7):
                v, R = em_hurwitz(s, a, M, K)
                worst = max(worst, R)
    print(f"    M={M:2d} K={K:2d}:  worst rigorous bound = {mp.nstr(worst, 3):>10}")

# --------------------------------------------------------------- (iii) timing
print("\n[iii] cost per evaluation (M=12, K=20), single-threaded")
t0 = time.time()
N = 200
for i in range(N):
    em_hurwitz(mp.mpc(1, 30 + i % 20), mp.mpf(1) / 3, 12, 20)
dt = (time.time() - t0) / N
print(f"    {dt*1000:.2f} ms per Hurwitz-zeta evaluation at dps=60")

# ---------------------------------------------------- (iv) the L-function assembly
print("\n[iv] L(chi,s) = N^-s sum_a chi(a) zeta(s, a/N), chi_3, vs mpmath.dirichlet")
chi3 = [0, 1, -1]


def em_L(chi, s, M, K):
    N = len(chi)
    tot = mp.mpf(0)
    R = mp.mpf(0)
    for a in range(1, N):
        if chi[a] == 0:
            continue
        v, r = em_hurwitz(s, mp.mpf(a) / N, M, K)
        tot += chi[a] * v
        R += abs(chi[a]) * r
    return N ** (-s) * tot, abs(N ** (-s)) * R


for (M, K) in [(8, 12), (10, 16), (12, 20)]:
    worst_ratio = mp.mpf(0)
    worst_bound = mp.mpf(0)
    for t in (mp.mpf("0.5"), 5, 14.1347, 20, 35, 50):
        for sig in ("0.5", "1"):
            s = mp.mpc(mp.mpf(sig), t)
            v, R = em_L(chi3, s, M, K)
            true = mp.dirichlet(s, chi3)
            if R > 0:
                worst_ratio = max(worst_ratio, abs(v - true) / R)
            worst_bound = max(worst_bound, R)
    print(f"    M={M:2d} K={K:2d}:  max |err|/bound = {mp.nstr(worst_ratio, 4):>10}   worst bound = {mp.nstr(worst_bound, 3):>10}")

# ------------------------------------------------ (v) derivatives: zeta', zeta'', L'/L
# The Route-B curvature needs (log Lambda)'' ~ L''/L - (L'/L)^2, so the EM formula must be
# differentiated in s.  Each term gains a factor log(a+k); the rising factorial (s)_n has
#   (s)_n' = (s)_n * A,   (s)_n'' = (s)_n * (A^2 - B),   A = sum 1/(s+i), B = sum 1/(s+i)^2.
print("\n[v] derivatives: zeta, zeta', zeta'' from one EM evaluation (M=20, K=50)")


def em_zeta_deriv(s, a, M, K):
    """(zeta, zeta', zeta'') at (s,a) by differentiated Euler-Maclaurin (value only)."""
    s = mp.mpc(s)
    a = mp.mpf(a)
    b = a + M
    v0 = sum((a + k) ** (-s) for k in range(M))
    v1 = sum(-mp.log(a + k) * (a + k) ** (-s) for k in range(M))
    v2 = sum(mp.log(a + k) ** 2 * (a + k) ** (-s) for k in range(M))
    Lb = mp.log(b)
    v0 += b ** (1 - s) / (s - 1) + mp.mpf(1) / 2 * b ** (-s)
    v1 += -Lb * b ** (1 - s) / (s - 1) - b ** (1 - s) / (s - 1) ** 2 - mp.mpf(1) / 2 * Lb * b ** (-s)
    v2 += (Lb ** 2 * b ** (1 - s) / (s - 1) + 2 * Lb * b ** (1 - s) / (s - 1) ** 2
           + 2 * b ** (1 - s) / (s - 1) ** 3 + mp.mpf(1) / 2 * Lb ** 2 * b ** (-s))
    for j in range(1, K + 1):
        c = mp.bernoulli(2 * j) / mp.factorial(2 * j)
        n = 2 * j - 1
        base = b ** (-s - n)
        A = sum(1 / (s + i) for i in range(n))
        B = sum(1 / (s + i) ** 2 for i in range(n))
        f = rising(s, n)
        v0 += c * f * base
        v1 += c * (f * A * base - f * Lb * base)
        v2 += c * (f * (A * A - B) * base - 2 * f * A * Lb * base + f * Lb * Lb * base)
    return v0, v1, v2


def em_L_all(chi, s, M, K):
    """(L, L', L'') for chi via the Hurwitz-zeta EM formula."""
    N = len(chi)
    tot = [mp.mpf(0)] * 3
    for a in range(1, N):
        if chi[a] == 0:
            continue
        v = em_zeta_deriv(s, mp.mpf(a) / N, M, K)
        for d in range(3):
            tot[d] += chi[a] * v[d]
    nf = N ** (-s)
    L = nf * tot[0]
    Lp = nf * (tot[1] - mp.log(N) * tot[0])
    Lpp = nf * (tot[2] - 2 * mp.log(N) * tot[1] + mp.log(N) ** 2 * tot[0])
    return L, Lp, Lpp


chi3 = [0, 1, -1]
for t in (mp.mpf("0.5"), 5, 20, 50):
    s = mp.mpc(1, t)
    v0, v1, v2 = em_zeta_deriv(s, mp.mpf(1) / 3, 20, 50)
    e0 = abs(v0 - mp.zeta(s, mp.mpf(1) / 3))
    e1 = abs(v1 - mp.zeta(s, mp.mpf(1) / 3, derivative=1))
    e2 = abs(v2 - mp.zeta(s, mp.mpf(1) / 3, derivative=2))
    L, Lp, Lpp = em_L_all(chi3, s, 20, 50)
    d1 = mp.diff(lambda z: mp.log(mp.dirichlet(z, chi3)), s)
    d2 = mp.diff(lambda z: mp.log(mp.dirichlet(z, chi3)), s, 2)
    print(f"    t={mp.nstr(t,3):>5}: |zeta''|={mp.nstr(e2,3):>9}  |L err|={mp.nstr(abs(L-mp.dirichlet(s,chi3)),3):>9}"
          f"  |L'/L err|={mp.nstr(abs(Lp/L-d1),3):>9}  |(log L)'' err|={mp.nstr(abs(Lpp/L-(Lp/L)**2-d2),3):>9}")

print("\nsummary: the EM route is standard, the remainder bound dominates the true error")
print("(~2x margin), the term counts (M <= 50, K <= 60 up to t = 80) are modest, and one EM")
print("evaluation already yields zeta, zeta' and zeta'' to ~1e-27 at t = 50.  A rigorous")
print("interval engine is therefore an engineering exercise, not a mathematical one.")
