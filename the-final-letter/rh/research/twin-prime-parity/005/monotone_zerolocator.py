#!/usr/bin/env python3
"""
005 (annex 4) - the monotone analogue of zeta is a zero-locator; the raw partial sums
are not.

The "monotone" selection in the eta/zeta setting is the alternating (period-2,
thermometer) coefficient sequence (-1)^{n-1}.  Its partial sums

    eta_N(s) = sum_{n<=N} (-1)^{n-1} n^{-s}

converge to eta(s) on Re s > 0 (Dirichlet's test), and eta = (1 - 2^{1-s}) zeta, whose
factor never vanishes on the critical line.  Hence Hurwitz's theorem gives:

    zeros of eta_N  ->  the nontrivial zeros of zeta,

and the rate is the tail size, O(N^{-1/2}) at a critical-line zero.

The RAW partial sums zeta_N(s) = sum_{n<=N} n^{-s} do NOT do this: on the critical line
the series diverges, zeta_N(s0) = -sum_{n>N} n^{-s0} = N^{1-s0}/(1-s0) + O(N^{-s0}) by
Euler-Maclaurin, so |zeta_N(s0)| ~ N^{1/2} -> infinity and there is no zero near s0.
Numerically their nearest zeros drift to Re ~ 0.84.

Run with the bundled runtime python.  Prints both tables; no files written.
"""
import numpy as np, math

G1 = 14.134725141734693790457251983562470270784257115699
S0 = complex(0.5, G1)


def zetaN(s, N):
    n = np.arange(1, N + 1, dtype=float)
    return np.sum(n ** (-s))


def etaN(s, N):
    n = np.arange(1, N + 1, dtype=float)
    return np.sum(((-1.0) ** (n - 1)) * n ** (-s))


def find_zero(f, seed, it=60, h=1e-6):
    s = seed
    for _ in range(it):
        v = f(s)
        d = (f(s + h) - f(s - h)) / (2 * h)
        if d == 0:
            break
        s = s - v / d
        if abs(v) < 1e-15:
            break
    return s


def nearest(f, N, win=1.2, ns=9, nt=41, lo=0.20, hi=0.95):
    best = None
    for sig in np.linspace(lo, hi, ns):
        for tt in np.linspace(G1 - win, G1 + win, nt):
            v = abs(f(complex(sig, tt), N))
            if best is None or v < best[0]:
                best = (v, sig, tt)
    return find_zero(lambda s: f(s, N), complex(best[1], best[2]))


print("true first zero  s0 = 0.5 + %.12fi" % G1)
print()
print("A. alternating (monotone) partial sums  eta_N")
print("     N        Re s_N         Im s_N        |s_N - s0|")
Ns = [10, 100, 1000, 10000, 100000, 1000000]
errs = []
for N in Ns:
    z = nearest(etaN, N)
    errs.append(abs(z - S0))
    print("  %-8d %13.9f %14.9f   %.3e" % (N, z.real, z.imag, errs[-1]))
sl = np.polyfit(np.log(Ns[-4:]), np.log(errs[-4:]), 1)[0]
print("  fitted slope of log|s_N-s0| vs log N = %.4f   (N^-1/2 would be -0.5)" % sl)

print()
print("B. raw partial sums  zeta_N  (nearest zero to s0, if any)")
print("     N        Re s_N         Im s_N        Re - 0.5")
for N in [100, 1000, 10000, 100000, 1000000]:
    z = nearest(zetaN, N)
    print("  %-8d %13.9f %14.9f   %+.4f" % (N, z.real, z.imag, z.real - 0.5))
print("  -> the alternating selection converges to the zero; the raw one does not.")
