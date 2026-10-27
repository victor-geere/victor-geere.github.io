#!/usr/bin/env python3
"""
Geometric DQPT numerical illustration
=====================================

Coherent polygonal partial sums with quadratic truncation,
residual-determinant certificate, and finite-rank Hilbert-Polya
operator.

Scientific Python stack: numpy, mpmath; scipy only for the residual certificate
  pip install numpy scipy mpmath

This script does NOT prove the Riemann Hypothesis; it only supplies
computational illustrations at practical truncation sizes (N <= 100).
"""

import sys, time
import numpy as np
from mpmath import mp, power, mpc, fabs
try:
    from scipy.linalg import eigh, det
    HAVE_SCIPY = True
except ImportError:
    HAVE_SCIPY = False

mp.dps = 18

def coherent_sum(N, t, sigma=0.5):
    M = N * N
    s = mpc(sigma, t)
    total = mpc(0)
    for m in range(1, M + 1):
        c = (1 - N) if (m % N == 0) else 1
        total += c * power(m, -s)
    return total

def known_zero_heights(num=5):
    return np.array([
        14.1347251417, 21.0220396388, 25.0108575801,
        30.4248761259, 32.9350615877, 37.5861781588
    ][:num])

def main_term_scale(N, sigma, t):
    """P_N(s) = |1 - N^{1-s}| at s = sigma + it."""
    return float(fabs(1 - power(N, mpc(1 - sigma, -t))))


def floor_scale(N, sigma, t):
    """Euler–Maclaurin floor size (1+|t|) N^{1-2σ}."""
    return (1.0 + abs(t)) * (N ** (1 - 2 * sigma))


def dqpt_depth(N, eps=1.0 / 8.0):
    """Uniform DQPT depth N^{1/2-ε}."""
    return N ** (0.5 - eps)


def half_term(N, sigma):
    """Explicit half-term size ½(N-1) N^{-2σ} at a zero."""
    return 0.5 * (N - 1) * (N ** (-2 * sigma))


def speed_cap(N, eps=1.0 / 8.0):
    """Slow-passage cap N^{1/2+ε}."""
    return N ** (0.5 + eps)


def eta_speed(N, t, sigma=0.5, h=1e-3):
    """Symmetric finite-difference |∂_t η|."""
    zp = coherent_sum(N, t + h, sigma=sigma)
    zm = coherent_sum(N, t - h, sigma=sigma)
    return float(fabs((zp - zm) / (2 * h)))


def off_line_scan(N_values, sigmas, t, eps=1.0 / 8.0):
    """Three-scale comparison on a vertical line through height t.

    This is not a test of Identity L at zeros of zeta: no off-line
    zero of zeta is used. Identity L is a lower bound on |∂_t η|
    at simple off-line zeros. This scan checks that |η| tracks
    P_N |ζ| away from the line and the floor N^{1-2σ} on it.
    """
    rows = []
    zeta_t = {}
    for sigma in sigmas:
        zeta_t[sigma] = complex(mp.zeta(mpc(sigma, t)))
    for N in N_values:
        for sigma in sigmas:
            z = coherent_sum(N, t, sigma=sigma)
            mod = float(fabs(z))
            P = main_term_scale(N, sigma, t)
            F = floor_scale(N, sigma, t)
            D = dqpt_depth(N, eps)
            V = speed_cap(N, eps)
            spd = eta_speed(N, t, sigma=sigma)
            zt = abs(zeta_t[sigma])
            rows.append({
                "N": N,
                "sigma": sigma,
                "abs_eta": mod,
                "P": P,
                "F": F,
                "D": D,
                "V": V,
                "speed": spd,
                "half": half_term(N, sigma),
                "abs_zeta": zt,
                "eta_over_F": mod / F if F else float("nan"),
                "eta_over_D": mod / D if D else float("nan"),
                "speed_over_V": spd / V if V else float("nan"),
                "eta_over_Pzeta": mod / (P * zt) if P * zt > 1e-12 else float("nan"),
            })
    return rows


def residual_certificate(N, heights):
    if not HAVE_SCIPY:
        raise RuntimeError("scipy is required for the residual certificate")

    vals, mods = [], []
    for t in heights:
        z = coherent_sum(N, float(t))
        vals.append(complex(z.real, z.imag))
        mods.append(float(fabs(z)))
    mods = np.array(mods)
    k = len(heights)
    G = np.zeros((k, k))
    for j in range(k):
        for l in range(k):
            G[j, l] = (vals[j] * np.conj(vals[l])).real
    eigvals, eigvecs = eigh(G)
    idx = np.argmax(eigvals)
    v = eigvecs[:, idx]
    rank1 = eigvals[idx] * np.outer(v, v)
    R = 0.5 * ((G - rank1) + (G - rank1).T)
    scale = max(np.trace(G), 1.0)
    try:
        delta = float(np.real(det(np.eye(k) + R / scale)))
    except Exception:
        delta = float("nan")
    return delta, float(np.linalg.norm(R)), float(np.max(mods)), float(np.mean(mods)), float(eigvals[idx])

def main():
    print("=" * 78)
    print("Geometric DQPT numerical illustration")
    print("Scientific stack: numpy + scipy + mpmath")
    print("=" * 78)
    print()
    import numpy, mpmath
    print(f"numpy  {numpy.__version__}")
    if HAVE_SCIPY:
        import scipy
        print(f"scipy  {scipy.__version__}")
    else:
        print("scipy  not installed (on-line certificate skipped)")
    print(f"mpmath {mpmath.__version__}")
    print()

    heights = known_zero_heights(5)
    print("Reference zero ordinates:")
    print(np.array2string(heights, precision=5))
    print()

    t_global = time.time()
    if HAVE_SCIPY:
        N_values = [20, 30, 40, 50, 60, 70, 80, 90, 100]
        print("-" * 78)
        print(f"{'N':>4}  {'M=N2':>7}  {'Delta_N':>11}  {'||R||_F':>10}  {'max|eta|':>10}  {'mean|eta|':>10}  {'time':>7}")
        print("-" * 78)
        for N in N_values:
            t0 = time.time()
            delta, fro, maxmod, meanmod, lam = residual_certificate(N, heights)
            dt = time.time() - t0
            print(f"{N:4d}  {N*N:7d}  {delta:11.5e}  {fro:10.4e}  {maxmod:10.4e}  "
                  f"{meanmod:10.4e}  {dt:6.1f}s")
            sys.stdout.flush()
        print("-" * 78)
        print(f"On-line wall time: {time.time()-t_global:.1f} s")
        print()
    else:
        print("Skipping residual-determinant table (scipy not installed).")
        print()

    print("=" * 78)
    print("Off-line three-scale scan at the first ordinate")
    print("t = 14.13472...  (a critical-line zero; not an off-line zero of zeta)")
    print("P = |1-N^{1-s}|,  F = (1+|t|) N^{1-2σ},  D = N^{1/2-1/8},  V = N^{1/2+1/8}")
    print("|∂_t η| is a symmetric difference of step 10^{-3}.")
    print("Identity L is a speed bound at off-line zeros of zeta; none are used here.")
    print("=" * 78)
    t_off = float(heights[0])
    sigmas = [0.35, 0.40, 0.50, 0.60, 0.65]
    N_off = [20, 40, 60]
    t1 = time.time()
    rows = off_line_scan(N_off, sigmas, t_off)
    print()
    print(f"{'N':>4}  {'sigma':>5}  {'|eta|':>10}  {'|∂t η|':>10}  {'V':>10}  "
          f"{'|eta|/D':>9}  {'|∂t η|/V':>9}  {'|eta|/(P|z|)':>12}")
    print("-" * 108)
    for r in rows:
        pz = r["eta_over_Pzeta"]
        pz_s = f"{pz:12.3f}" if pz == pz else f"{'—':>12}"
        print(f"{r['N']:4d}  {r['sigma']:5.2f}  {r['abs_eta']:10.4e}  {r['speed']:10.4e}  "
              f"{r['V']:10.4e}  {r['eta_over_D']:9.3f}  {r['speed_over_V']:9.3f}  {pz_s}")
    print("-" * 108)
    print(f"Off-line wall time: {time.time()-t1:.1f} s")
    print()
    print("On σ=1/2, |η| should be O(F) (zeta vanishes; floor remains).")
    print("Off the line, |η| / (P |ζ|) should be near 1 (main term dominates).")
    print("|∂_t η|/V is the slow-passage ratio; at a critical-line zero it should")
    print("stay O(1) or smaller as N grows, up to |ζ'| / N^ε.")
    print("These are finite-N illustrations only.")
    print("A mathematical proof requires the analytic arguments in the paper.")

if __name__ == "__main__":
    main()
