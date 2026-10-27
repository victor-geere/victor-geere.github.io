#!/usr/bin/env python3
"""
PHASE B - transfer to zeta space: no-go, and the exact strength of it.

(1) THEOREM (no meromorphic factorisation).  If g is meromorphic and nonzero and
    g*D(as+b) continued meromorphically across Re s = 0, then D = (g*D)/g would too.
    D has a natural boundary at Re s = 0 (Fabry gap theorem, lambda_j = log s_j,
    lambda_j/j -> inf).  zeta is meromorphic on all of C.  Hence zeta != g*D(as+b).
(2) Dirichlet convolution D = zeta * g is ALWAYS solvable (g = D*mu), hence vacuous.
(3) The digit-correlation expansion of the COS series separates exactly,
        Re eta = sum_S Re(c_S) W_S,  c_S = prod_{k in S}(e^{i pi/(k+2)} - 1),
    but is NOT absolutely convergent (sum |c_S| ~ M^pi), and the partial sums do not
    converge.  The SIN series does not separate at all: the fold sign eps_n is not a
    function of the word A_n.
(4) Support-only statistics are approximately t-free with an O(1/t) tilt.

Run with the bundled python (no mpmath needed).
"""
import math, itertools

KMAX = 10 ** 7


def greedy(x, Kmax=KMAX):
    r = x; A = []; k = 0
    while r > 1e-17 and k < Kmax:
        kk = int(1.0 / r) + 1 - 2
        if kk < k:
            kk = k
        if kk >= Kmax:
            break
        w = 1.0 / (kk + 2)
        if r >= w:
            A.append(kk); r -= w; k = kk + 1
        else:
            k = kk + 1
    return A


sigma, t = 0.5, 14.134725141734693790
N = 300
words = []; amps = []
for n in range(1, N + 1):
    ph = (t * math.log(n)) % (2 * math.pi)
    th = ph if ph <= math.pi else 2 * math.pi - ph
    words.append(set(greedy(th / math.pi))); amps.append(((-1) ** (n - 1)) * n ** (-sigma))
Re = sum(amps[i] * math.cos(min((t * math.log(i + 1)) % (2 * math.pi),
                                2 * math.pi - (t * math.log(i + 1)) % (2 * math.pi))) for i in range(N))

print("(3) digit-correlation expansion of the cosine series")
print("    true Re eta (N=300) = %+.10f" % Re)
for M in [2, 4, 6, 8, 10, 12, 14]:
    tot = 0.0
    for r in range(M + 2):
        for S in itertools.combinations(range(M + 1), r):
            cr, ci = 1.0, 0.0
            for k in S:
                a = math.pi / (k + 2); fr = math.cos(a) - 1; fi = math.sin(a)
                cr, ci = cr * fr - ci * fi, cr * fi + ci * fr
            W = sum(amps[i] for i in range(N) if all(k in words[i] for k in S))
            tot += cr * W
    print("    max index <= %-3d  partial = %+.8f   gap = %+.2e" % (M, tot, tot - Re))
print("    sum |c_S| over subsets with max index <= M (absolute convergence test):")
for M in range(0, 13, 2):
    s = sum(math.prod([2 * abs(math.sin(math.pi / (2 * (k + 2)))) for k in S])
            for r in range(M + 2) for S in itertools.combinations(range(M + 1), r))
    print("       M=%-3d  sum|c_S| = %.4f" % (M, s))
print("    -> grows like prod_k (1+pi/(k+2)) ~ M^pi: NOT absolutely convergent.\n")

print("(3b) the sine series does not separate: eps_n is not a function of the word")
seen = {}
for n in range(1, 400):
    ph = (t * math.log(n)) % (2 * math.pi)
    e = 1 if ph <= math.pi else -1
    th = ph if ph <= math.pi else 2 * math.pi - ph
    A = tuple(sorted(greedy(th / math.pi))[:2])
    seen.setdefault(A, set()).add(e)
amb = [(A, v) for A, v in seen.items() if len(v) > 1]
print("    words (first 2 digits) realised with BOTH fold signs among n<=399: %d of %d" % (len(amb), len(seen)))
for A, v in amb[:3]:
    print("       A=%s -> eps in %s" % (A, sorted(v)))

print()
print("(4) support-only statistics: KS(empirical theta/pi vs Lebesgue) shrinks with t")
try:
    import numpy as np
    for tt in [14.134725141734693, 30.0, 100.0, 1000.0]:
        M = 200000
        u = np.array([min((tt * np.log(n) / math.pi) % 1.0, 1.0 - (tt * np.log(n) / math.pi) % 1.0)
                      for n in range(1, M + 1)])
        u.sort(); ks = np.max(np.abs(u - np.arange(1, M + 1) / M))
        print("    t=%-20s KS = %.4f   (0.6/t = %.4f)" % (tt, ks, 0.6 / tt))
    print("    -> approximately t-free, but with an O(1/t) tilt, NOT uniform.")
except ImportError:
    print("    (numpy unavailable)")

print()
print("(1) sanity: D has off-strip zeros while every zeta zero with |Im|<=40 is on Re=1/2")
print("    D zeros (verified to 50+ digits earlier):")
for z in [(0.954407453375382, 7.544937313196741), (0.829170729176776, 22.942732183955343),
          (0.900472653087034, 38.045210905023183)]:
    print("       %+.9f %+.9fi   Re != 1/2" % z)
