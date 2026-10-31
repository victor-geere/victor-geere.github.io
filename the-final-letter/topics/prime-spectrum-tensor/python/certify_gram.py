"""Compute interval enclosures of the 4x4 Gaussian Weil Gram matrix.

Run from the topic directory.  This is a long computation: it certifies the
density integral with narrow Taylor panels and then checks diagonal dominance
of the resulting interval Gram matrix.  It prints a textual certificate and
returns nonzero if the dominance test fails.
"""

from __future__ import annotations

import os

import mpmath as mp
import sympy as sp

import programme as p

mp.mp.dps = 30
SIGMA = mp.mpf("0.05")
CENTRES = [mp.mpf("-0.3"), mp.mpf("-0.1"), mp.mpf("0.1"), mp.mpf("0.3")]
CS = [mp.mpf("0"), mp.mpf("0.2"), mp.mpf("0.4"), mp.mpf("0.6")]
H = mp.mpf(os.environ.get("CERT_H", "0.1"))
T = mp.mpf(os.environ.get("CERT_T", "100"))
X_PRIME = 20000
JET_MARGIN = mp.mpf("1e-4")


def pole_interval(c):
    c = mp.mpf(c)
    two_pi = mp.iv.mpf([2 * mp.pi, 2 * mp.pi])
    half_c = mp.iv.mpf([c, c]) / 2
    cosh_c = (mp.iv.exp(half_c) + mp.iv.exp(-half_c)) / 2
    pref = 4 * mp.pi * SIGMA**2 * mp.exp(SIGMA**2 / 4)
    value = mp.iv.mpf([pref, pref]) * cosh_c
    return value


def prime_interval(c):
    c = mp.mpf(c)
    c_iv = mp.iv.mpf([c, c])
    sig_iv = mp.iv.mpf([SIGMA, SIGMA])
    total = mp.iv.mpf([0, 0])
    pref = mp.iv.mpf([mp.sqrt(mp.pi) * SIGMA, mp.sqrt(mp.pi) * SIGMA])
    four_s2 = mp.iv.mpf([4 * SIGMA * SIGMA, 4 * SIGMA * SIGMA])
    for weight, v in p._prime_power_data(X_PRIME):
        w_iv = mp.iv.mpf([weight, weight])
        v_iv = mp.iv.mpf([v, v])
        total += w_iv * pref * mp.iv.exp(-((v_iv - c_iv) ** 2) / four_s2)
    return -2 * total



def interval_psd_certificate(G, slack=1e-9):
    """Certify a symmetric interval matrix by center plus operator-norm slack.

    If ``G0`` is the center and ``||G-G0||_2 <= t``, positivity of
    ``G0 - tI`` (checked by exact rational leading minors) implies ``G`` is
    positive definite.  The float conversion of the interval endpoints is
    covered by ``slack``.
    """
    n = len(G)
    centers = [[None] * n for _ in range(n)]
    half = [[0.0] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            a = float(G[i][j].a)
            b = float(G[i][j].b)
            centers[i][j] = (a + b) / 2
            half[i][j] = (b - a) / 2
    t = max(sum(half[i][j] for j in range(n)) for i in range(n)) + slack
    M = sp.Matrix(n, n, lambda i, j: sp.Rational(str(centers[i][j])))
    P = M - sp.Rational(str(t)) * sp.eye(n)
    minors = [sp.Matrix(P[:k, :k]).det().evalf() for k in range(1, n + 1)]
    ok = all(float(d) > 0 for d in minors)
    return ok, t, minors


def interval_leading_minors(G):
    """Interval enclosures of the leading principal minors (determinants)."""
    n = len(G)

    def det(M):
        k = len(M)
        if k == 0:
            return mp.iv.mpf([1, 1])
        total = mp.iv.mpf([0, 0])
        for j in range(k):
            sub = [[M[i][l] for l in range(k) if l != j]
                   for i in range(1, k)]
            total += M[0][j] * det(sub) * (-1 if j % 2 else 1)
        return total

    return [det([row[:k] for row in G[:k]]) for k in range(1, n + 1)]


def exact_ldl_pivots(M):
    """Exact rational LDL^T pivots of a symmetric rational matrix.

    Positive pivots are equivalent to positive leading principal minors and
    are the rational-free finite PSD check (no square roots).
    """
    A = [[sp.Rational(M[i, j]) for j in range(M.cols)] for i in range(M.rows)]
    pivots = []
    for k in range(len(A)):
        p = A[k][k]
        pivots.append(p)
        if p == 0:
            continue
        for i in range(k + 1, len(A)):
            lik = A[i][k] / p
            for j in range(k + 1, len(A)):
                A[i][j] -= lik * A[k][j]
    return pivots

def main():
    density, panels = p.gaussian_density_certified_multi(
        [0, mp.mpf("0.2"), mp.mpf("0.4"), mp.mpf("0.6")],
        SIGMA, H=H, T=T, order=4, h=mp.mpf("0.05"), U=6)
    print(f"panels={panels}", flush=True)
    dens = {c: density[k] for k, c in enumerate(CS)}

    def W_of(c):
        c = mp.mpf(c)
        key = min(CS, key=lambda x: abs(x - abs(c)))
        d, de = dens[key]
        dens_iv = mp.iv.mpf([d.a - de, d.b + de])
        return pole_interval(c) + dens_iv + prime_interval(c)

    for c in CS:
        print(f"W({mp.nstr(c, 3)}) = {W_of(c)}", flush=True)

    # Gram matrix entries, symmetrised in c.
    n = len(CENTRES)
    G = [[None] * n for _ in range(n)]
    for i in range(n):
        for j in range(i, n):
            c = CENTRES[i] - CENTRES[j]
            a = W_of(c)
            b = W_of(-c)
            entry = (a + b) / 2
            # Conservative margin for the provisional jet series/tail remainders.
            entry = mp.iv.mpf([entry.a - JET_MARGIN, entry.b + JET_MARGIN])
            G[i][j] = entry
            G[j][i] = entry

    print("Gram intervals:", flush=True)
    for row in G:
        print("  " + "  ".join(str(x) for x in row), flush=True)

    ok, t, minors = interval_psd_certificate(G)
    print(f"operator-norm slack t = {t}", flush=True)
    for k, d in enumerate(minors, 1):
        print(f"leading minor {k} of center - tI: {d}", flush=True)
    print("CERTIFIED" if ok else "NOT CERTIFIED", flush=True)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
