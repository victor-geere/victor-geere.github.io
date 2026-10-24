#!/usr/bin/env python3
"""
PHASE 1 - the N^{-1/2} barrier for monotone/alternating selections at a zeta zero.

Theorem.  Let s0 = 1/2 + i*gamma be a simple zero of zeta, so eta(s0) = 0 with
eta = (1-2^{1-s}) zeta.

  (i)  UNIQUENESS.  If sum_{n>=1} a(n) n^{-s} = eta(s) as a Dirichlet series on Re s > 0,
       then a(n) = (-1)^{n-1} for every n.  So there is no freedom in the selection:
       the "monotone" (alternating, thermometer) coefficient sequence is forced.
  (ii) RATE.  For the forced selection the length-N truncation error is
       Theta(N^{-1/2}); indeed Abel summation with A(N) = sum_{n<=N} (-1)^{n-1} in {0,1}
       gives  |eta(s0) - eta_N(s0)| = |sum_{n>N} (-1)^{n-1} n^{-s0}| >= c N^{-1/2},
       while the alternating-series bound gives O(N^{-1/2}).
  (iii) Hence no selection (no choice of coefficients whose Dirichlet series is eta) can
       beat N^{-1/2}.  Beating it requires a summation method that consumes the infinite
       tail (e.g. the Euler transform), which is not a length-N selection.

Run with the bundled runtime python.  Prints the rate table and the constant.
"""
import numpy as np, math

G1 = 14.134725141734693790457251983562470270784257115699
S0 = complex(0.5, G1)


def eta(s, N=160):
    """eta(s) by the Euler transform of the alternating series (machine accurate)."""
    a = np.array([(n + 1) ** (-s) for n in range(N + 1)], dtype=complex)
    tot = 0j; row = a.copy()
    for k in range(N):
        tot += row[0] * 2.0 ** (-(k + 1))
        row = row[:-1] - row[1:]
    return tot


print("eta(s0) by Euler transform = %.3e %+.3ej   (s0 = 0.5 + %.12fi)"
      % (eta(S0).real, eta(S0).imag, G1))
print()
print("  N        |eta(s0) - eta_N(s0)|     N^-1/2        ratio to (1/2)N^-1/2")
rows = []
for N in [10, 30, 100, 300, 1000, 3000, 10000, 30000, 100000]:
    n = np.arange(1, N + 1, dtype=float)
    e = abs(eta(S0) - np.sum(((-1.0) ** (n - 1)) * n ** (-S0)))
    rows.append((N, e))
    print("  %-8d %.6e              %.6e      %.4f" % (N, e, N ** -0.5, e / (0.5 * N ** -0.5)))
Ns = np.array([r[0] for r in rows], dtype=float)
Es = np.array([r[1] for r in rows])
sl = np.polyfit(np.log(Ns), np.log(Es), 1)[0]
print()
print("  fitted slope of log|error| vs log N = %+.5f   (N^-1/2 => -0.5)" % sl)
print("  constant: |error| * N^1/2 -> %.5f   (predicted 0.5)" % (Es[-1] * Ns[-1] ** 0.5))

print()
print("UNIQUENESS CHECK (changing the coefficients destroys the identity):")
n = np.arange(1, 20001, dtype=float)
base = np.sum(((-1.0) ** (n - 1)) * n ** (-S0))
for perturb in [0.0, 1e-3, 1e-2, 1e-1]:
    a = ((-1.0) ** (n - 1)).copy()
    a[0] += perturb * (-1) ** 0      # change only the n=1 coefficient
    val = np.sum(a * n ** (-S0))
    print("   perturbation of a(1) by %-6g ->  |sum - eta(s0)| = %.3e" % (perturb, abs(val - eta(S0))))
print("   (the Dirichlet coefficients of eta are unique, so any other selection is a")
print("    different function, not a better approximation to the same one)")
