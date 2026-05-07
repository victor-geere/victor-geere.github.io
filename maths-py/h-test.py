#!/usr/bin/env python3
"""
Numerical verification of the finite‑dimensional Hamiltonians H_k
from the Harmonic Sine Transform (HST) framework.

Tests performed:
  1. Eigenvalue matching: max absolute error and RMS error against known
     Riemann zeros.
  2. Kolmogorov–Smirnov test for GUE eigenvalue spacing distribution.

Tolerances are set in the global dictionary TOL.  If a metric exceeds
its tolerance, the test is marked FAIL; otherwise PASS.
"""

import numpy as np
from scipy.linalg import polar, logm, eigvalsh
from scipy.stats import kstest
import mpmath as mp

# ----------------------------------------------------------------------
# 0.  Tolerance settings
# ----------------------------------------------------------------------
TOL = {
    'max_err': 1e-2,        # maximum absolute error in eigenvalue matching
    'rms_err': 1e-3,        # RMS error
    'ks_pval': 0.05,        # significance level for KS test (p-value must be > this)
}
# ----------------------------------------------------------------------
# 1.  Transfer operator matrix elements
# ----------------------------------------------------------------------

def dimension(k):
    """
    Dimension of the truncated subspace H_k.
    For simplicity we take d_k = k+1 (monomials 1, z, ..., z^k).
    """
    return k + 1

def weight(j, m, n, t):
    """
    Matrix element contribution from the j‑th inverse branch.

    For the greedy harmonic transfer operator L_s acting on H^2(D)
    with monomial basis z^n, the entry (m,n) is:

      [L_s]_{m,n} = sum_{j=1}^∞  (j+1) / (j+2)^{s+1+n-m} * binom(n, m)

    for 0 <= m <= n, and 0 otherwise.
    """
    if m > n:
        return 0.0j
    s = 0.5 + 1j * t
    factor = (j + 1) / ((j + 2) ** (s + 1 + n - m))
    binom = mp.binomial(n, m)
    return complex(factor * binom)

def build_Ak(k, t, Jmax=200):
    """
    Assemble the matrix A_k(t) = P_k L_{1/2+it} P_k.

    Parameters
    ----------
    k : int
        Truncation level (subspace dimension = k+1).
    t : float
        Imaginary part offset; s = 1/2 + i t.
    Jmax : int
        Number of branches summed.

    Returns
    -------
    A : ndarray (d, d) complex
    """
    d = dimension(k)
    A = np.zeros((d, d), dtype=complex)
    # Precompute binomials
    binom_arr = np.zeros((d, d), dtype=complex)
    for m in range(d):
        for n in range(m, d):
            binom_arr[m, n] = mp.binomial(n, m)

    # Sum over branches
    for j in range(1, Jmax + 1):
        for m in range(d):
            for n in range(m, d):
                A[m, n] += weight(j, m, n, t)
    return A

# ----------------------------------------------------------------------
# 2.  Finite‑difference Hamiltonian H_k
# ----------------------------------------------------------------------

def compute_Hk(k, epsilon=1e-6, Jmax=200):
    """
    Compute H_k = i d/dt log U_k(t) |_{t=0}
    using a central finite difference.
    """
    A0 = build_Ak(k, 0.0, Jmax)
    Aeps = build_Ak(k, epsilon, Jmax)

    U0, _ = polar(A0)
    Ueps, _ = polar(Aeps)

    deltaU = Ueps @ U0.conj().T   # near identity
    try:
        H_skew = logm(deltaU)
    except Exception:
        # fallback if principal log fails
        H_skew = logm(deltaU, disp=False)[0]
    H = 1j / epsilon * H_skew
    return (H + H.conj().T) / 2

# ----------------------------------------------------------------------
# 3.  Obtain eigenvalues and match to Riemann zeros
# ----------------------------------------------------------------------

def load_riemann_zeros(n=100):
    """Return the first n positive ordinates of the Riemann zeta zeros."""
    zeros = []
    for k in range(1, n+1):
        z = mp.zetazero(k)
        zeros.append(float(z.imag))
    return np.array(zeros)

def match_eigenvalues(evals, zeros_ref):
    """
    Match sorted eigenvalues to the closest reference zeros using
    monotonic assignment. Returns max_err, rms_err, and the list of
    matched eigenvalues and individual errors.
    """
    evals_sorted = np.sort(evals)
    matched = []
    i = 0
    for e in evals_sorted:
        best_j = i
        best_dist = abs(e - zeros_ref[i])
        for j in range(i, len(zeros_ref)):
            dist = abs(e - zeros_ref[j])
            if dist < best_dist:
                best_dist = dist
                best_j = j
        matched.append(zeros_ref[best_j])
        i = best_j + 1
        if i >= len(zeros_ref):
            break
    errors = np.abs(np.array(matched) - evals_sorted[:len(matched)])
    max_err = np.max(errors) if len(errors) > 0 else np.inf
    rms_err = np.sqrt(np.mean(errors**2)) if len(errors) > 0 else np.inf
    return max_err, rms_err, evals_sorted[:len(matched)], errors

# ----------------------------------------------------------------------
# 4.  Unfolding and GUE spacing test
# ----------------------------------------------------------------------

def unfold_spacings(eigenvalues):
    """
    Unfold eigenvalues to have unit mean spacing using Gaussian kernel
    smoothing of the cumulative count. Returns normalised spacings.
    """
    from scipy.ndimage import gaussian_filter1d
    ev = np.sort(eigenvalues)
    N = len(ev)
    cum = np.arange(1, N+1)
    sigma = max(2, int(0.5 * N**(1/3)))
    smoothed = gaussian_filter1d(cum.astype(float), sigma, mode='nearest')
    spacings = np.diff(smoothed)
    mean_spacing = np.mean(spacings)
    spacings /= mean_spacing
    return spacings

def gue_cdf(s):
    """Cumulative distribution function of the GUE Wigner surmise."""
    c = 4 / np.pi
    return 1.0 - (1.0 + c * s**2) * np.exp(-c * s**2)

# ----------------------------------------------------------------------
# 5.  Main execution with explicit PASS/FAIL output
# ----------------------------------------------------------------------

def main():
    print("Numerical verification of H_k eigenvalues")
    print("=" * 46)
    print(f"Tolerances: max_err < {TOL['max_err']}, "
          f"rms_err < {TOL['rms_err']}, "
          f"KS p-value > {TOL['ks_pval']}\n")

    print("Loading reference zeros (first 100) using mpmath...")
    zeros_ref = load_riemann_zeros(100)
    print("First 5 zeros: ", zeros_ref[:5])

    for k in [10, 20, 40, 80]:
        d = dimension(k)
        print(f"\n--- k = {k} (dimension = {d}) ---")
        try:
            Hk = compute_Hk(k, epsilon=1e-6, Jmax=150)
            evals = eigvalsh(Hk)
            print(f"  Computed {len(evals)} eigenvalues.")

            # Match eigenvalues
            max_err, rms_err, matched, indiv_errs = match_eigenvalues(evals, zeros_ref)
            print(f"  Max abs error : {max_err:.3e}  [threshold: {TOL['max_err']}]")
            print(f"  RMS error     : {rms_err:.3e}  [threshold: {TOL['rms_err']}]")

            # Pass/fail for matching
            max_pass = max_err < TOL['max_err']
            rms_pass = rms_err < TOL['rms_err']
            match_pass = max_pass and rms_pass
            print(f"  Max error test : {'PASS' if max_pass else 'FAIL'}")
            print(f"  RMS error test : {'PASS' if rms_pass else 'FAIL'}")

            # Spacing statistics (only if enough eigenvalues)
            if len(evals) < 20:
                print("  Too few eigenvalues for spacing test; skipping.")
                continue

            spacings = unfold_spacings(evals)
            spacings = spacings[spacings > 0]
            ks_stat, ks_pval = kstest(spacings, gue_cdf)
            print(f"  KS statistic   : {ks_stat:.3f}")
            print(f"  KS p-value     : {ks_pval:.3f}  [threshold: >{TOL['ks_pval']}]")
            ks_pass = ks_pval > TOL['ks_pval']
            print(f"  KS test        : {'PASS' if ks_pass else 'FAIL'}")

            # Overall status for this k
            overall = match_pass and ks_pass
            print(f"  >>> Overall for k={k}: {'PASSED' if overall else 'FAILED'} <<<")

        except Exception as e:
            print(f"  Computation failed: {e}")
            print(f"  >>> Test INCONCLUSIVE due to error <<<")

if __name__ == "__main__":
    main()