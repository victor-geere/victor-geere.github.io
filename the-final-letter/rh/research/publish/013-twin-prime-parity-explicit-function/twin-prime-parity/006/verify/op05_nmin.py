#!/usr/bin/env python3
"""
OP-5 RESOLVED (up to an explicit remainder): the asymptotic of n_min(p).

OBJECT.  rh42 proves h_p(n) = sum_{k>n} k^-p - n^-p has a single sign change.  Hence
    n_min(p) = min{ n : sum_{k>n} k^-p >= n^-p } = min{ n : zeta(p, n+1) >= n^-p },
and dividing by n^-p the boundary condition is exactly

    Phi_p(n) := sum_{j>=1} (1 + j/n)^{-p}  >=  1 ,        Phi_p increasing in n.

The thresholds  P_n := the unique p with Phi_p(n) = 1  give  n_min(p) = n  <=>  P_{n-1} < p <= P_n.

RESULT (refutes the recorded guess "n_min(p) ~ p + O(1)", rh42/truths.md:453).

    n_min(p) = p/ln2 - 3/2 + O(1)   (error corrected from O(1/p); see notes/OP-05)
    P_n      = (n + 3/2) ln 2 + c/n + O(1/n^2),
    c        = 3 (ln 2)^2 - (25/12) ln 2 = -0.002697584411948454...

DERIVATION (Euler-Maclaurin / dual side; PERMISSION 114's license, nothing more).
Put p = a n + g and expand p*log(1+j/n) in powers of 1/n:
    p log(1+j/n) = a j + C1/n + C2/n^2 + ...,
    C1 = g j - a j^2/2 ,        C2 = a j^3/3 - g j^2/2 .
With x = e^{-a}, S_m := sum_{j>=1} j^m x^j (S1=2, S2=6, S3=26):
    Phi - 1 = (1/n) sum x^j C1 + (1/n^2) sum x^j (C2 + C1^2/2) + O(1/n^3)
            = (1/n)(a S2/2 - g S1) + O(1/n^2) .
Leading sum = 1 forces a = ln 2; the 1/n coefficient 3a - 2g vanishes iff g = (3/2)ln 2.
The 1/n^2 coefficient at g = 3a/2 is  D0 = -(-a S3/3 + g S2/2) + (1/2)sum x^j C1^2 = -25a/6 + 6a^2,
so the threshold shift satisfies  eps = D0/(2n)  (using Phi' = -S1/n = -2/n), i.e.
    c = D0/2 = 3a^2 - (25/12)a .

NOTE.  An earlier draft of the goal claimed the naive expansion gives the wrong constant 3(ln2)/2.
That was a UNITS ERROR (comparing a p-unit constant with an n-unit constant -- the same number).
The naive expansion is correct; the only genuine trap is the dropped  g j^2/2  term in C2.

EXCEPTIONAL SET.  n_min(p) = ceil(p/ln2 - 3/2) fails exactly on  p in (P_n, (n+3/2)ln2),
each component of width (n+3/2)ln2 - P_n = -c/n + O(1/n^2) -> 0.

Run:  /opt/homebrew/Caskroom/miniforge/base/bin/python3 op05_nmin.py
"""
import mpmath as mp
import numpy as np

mp.mp.dps = 50
a = mp.log(2)
c = 3 * a ** 2 - mp.mpf(25) / 12 * a


def tail(n, p, M=400):
    """sum_{k>n} k^-p.  For p large the ratio is 2^-1 per step and M=400 is ample; for
    small p the direct sum converges slowly, so use the exact Hurwitz zeta instead."""
    if p < 50:
        return mp.zeta(p, n + 1)
    return mp.fsum([mp.power(n + k, -p) for k in range(1, M + 1)])


def h(n, p):
    return tail(n, p) - mp.power(n, -p)


def P(n, halfwidth=None):
    """threshold by bisection on h (h decreasing in p)."""
    P0 = (mp.mpf(n) + mp.mpf(3) / 2) * a + c / mp.mpf(n)
    w = halfwidth if halfwidth is not None else mp.mpf(1) / mp.mpf(n)
    lo, hi = P0 - w, P0 + w
    for _ in range(200):
        mid = (lo + hi) / 2
        if h(n, mid) < 0:
            hi = mid
        else:
            lo = mid
    return (lo + hi) / 2


print("=" * 78)
print("1. the recorded guess is refuted:  n_min(p)/p -> 1/ln2, not 1")
print("=" * 78)
print("   p        n_min     n_min/p    n_min/(p/ln2)")


def nmin(p):
    n = 1
    while mp.zeta(mp.mpf(p), n + 1) < mp.power(n, -mp.mpf(p)):
        n += 1
    return n


for p in [10, 50, 200, 1000, 5000]:
    n = nmin(p)
    print("   %-8s %-9d %-10.4f %.6f" % (p, n, n / mp.mpf(p), n / (mp.mpf(p) / a)))

print()
print("=" * 78)
print("2. the threshold law and the closed-form constant")
print("=" * 78)
print("   predicted  c = 3(ln2)^2 - (25/12)ln2 = %s" % mp.nstr(c, 20))
print()
print("   n        P_n - (n+3/2)ln2        n*(that)")
rows = []
for n in [100, 500, 1000, 2000, 5000, 10000, 20000]:
    pn = P(n)
    d = pn - (mp.mpf(n) + mp.mpf(3) / 2) * a
    rows.append((n, float(d * n)))
    print("   %-8d %-24s %s" % (n, mp.nstr(d, 18), mp.nstr(d * n, 18)))

ns = np.array([r[0] for r in rows], float)
ys = np.array([r[1] for r in rows])
A = np.vstack([np.ones_like(1 / ns), 1 / ns]).T
allc, *_ = np.linalg.lstsq(A, ys, rcond=None)
coef, *_ = np.linalg.lstsq(A[-4:], ys[-4:], rcond=None)   # last four points: cleanest asymptotics
print()
print("   Richardson fit (all points)  c_fit = %.15f   diff = %.3e" % (allc[0], allc[0] - float(c)))
print("   Richardson fit (last 4)      c_fit = %.15f   diff = %.3e" % (coef[0], coef[0] - float(c)))
print("                                c_pred= %.15f" % float(c))

print()
print("=" * 78)
print("3. the remainder really is O(1/n^2):  bracket  (n+3/2)ln2 + c/n +- 1/n^2")
print("=" * 78)
print("   n          |P_n - ((n+3/2)ln2 + c/n)|      (that) * n^2")
for n in [10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6]:
    P0 = (mp.mpf(n) + mp.mpf(3) / 2) * a + c / mp.mpf(n)
    off = abs(P(n) - P0)
    print("   %-10d %-30.3e %.5f" % (n, float(off), float(off * mp.mpf(n) ** 2)))

print()
print("=" * 78)
print("4. exceptional set of the ceiling form:  width -> -c/n")
print("=" * 78)
for n in [100, 1000, 10000]:
    P0 = (mp.mpf(n) + mp.mpf(3) / 2) * a
    lo, hi = P0 - mp.mpf(1) / n, P0
    for _ in range(120):
        mid = (lo + hi) / 2
        if h(n, mid) < 0:
            hi = mid
        else:
            lo = mid
    width = P0 - (lo + hi) / 2
    print("   n=%-7d width=%.9e   -c/n=%.9e   ratio=%.4f" % (n, float(width), float(-c / n), float(width / (-c / n))))

print()
print("=" * 78)
print("5. the n=1 boundary reproduces the programme's own constant p*")
print("=" * 78)
lo, hi = mp.mpf('1.5'), mp.mpf('2')
for _ in range(250):
    mid = (lo + hi) / 2
    if mp.zeta(mid) - 2 > 0:      # zeta decreasing; root is where zeta = 2
        lo = mid
    else:
        hi = mid
print("   root of zeta(p) = 2        : %s" % mp.nstr((lo + hi) / 2, 18))
print("   P_1 (threshold, h(1,p)=0)  : %s" % mp.nstr(P(1, halfwidth=mp.mpf('0.5')), 18))
print("   register's p* (zeta(p*)=2) : 1.7286472389981836")
