#!/usr/bin/env python3
"""
Geometric DQPT numerical illustration
=====================================

Coherent polygonal partial sums with quadratic truncation,
residual-determinant certificate, and finite-rank Hilbert-Polya
operator.

Scientific Python stack required: numpy, scipy, mpmath
  pip install numpy scipy mpmath

This script does NOT prove the Riemann Hypothesis; it only supplies
computational illustrations at practical truncation sizes (N <= 100).
"""

import sys, time
import numpy as np
from mpmath import mp, power, mpc, fabs
from scipy.linalg import eigh, det

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

def residual_certificate(N, heights):
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
    import numpy, scipy, mpmath
    print(f"numpy  {numpy.__version__}")
    print(f"scipy  {scipy.__version__}")
    print(f"mpmath {mpmath.__version__}")
    print()

    heights = known_zero_heights(5)
    print("Reference zero ordinates:")
    print(np.array2string(heights, precision=5))
    print()

    N_values = [20, 30, 40, 50, 60, 70, 80, 90, 100]

    print("-" * 78)
    print(f"{'N':>4}  {'M=N2':>7}  {'Delta_N':>11}  {'||R||_F':>10}  {'max|eta|':>10}  {'mean|eta|':>10}  {'time':>7}")
    print("-" * 78)

    t_global = time.time()
    for N in N_values:
        t0 = time.time()
        delta, fro, maxmod, meanmod, lam = residual_certificate(N, heights)
        dt = time.time() - t0
        print(f"{N:4d}  {N*N:7d}  {delta:11.5e}  {fro:10.4e}  {maxmod:10.4e}  "
              f"{meanmod:10.4e}  {dt:6.1f}s")
        sys.stdout.flush()

    print("-" * 78)
    print(f"Total wall time: {time.time()-t_global:.1f} s")
    print()
    print("These are finite-N illustrations only.")
    print("A mathematical proof requires the analytic arguments in the paper.")

if __name__ == "__main__":
    main()
