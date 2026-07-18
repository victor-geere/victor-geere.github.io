import numpy as np
from mpmath import mp

# Set high precision
mp.dps = 50

def compute_false_kernel(N):
    """Closed-form kernel from the false global indicator identity."""
    K = np.zeros((N, N), dtype=np.float64)
    pi = np.pi
    for n in range(N):
        for m in range(N):
            if n == m:
                K[n,n] = (pi/3.0) * (1.0 + (n+1)**3) / (n+2)**3
            elif n < m:
                K[n,m] = (pi/6.0) * (
                    (n+2)**(-3) + (m+2)**(-3)
                    - 2.0 * (n+2)**(-1) * (m+2)**(-1)
                    + 6.0 * (n+2)**(-2) * (m+2)**(-1)
                    + 6.0 * (n+2)**(-1) * (m+2)**(-2)
                )
            else:
                K[n,m] = K[m,n]
    return K

def compute_determinant_and_eigenvalues(s, N):
    K = compute_false_kernel(N)
    n_array = np.arange(N) + 2
    w = n_array ** (-s)
    M = K * np.outer(w, w)
    I_minus_M = np.eye(N, dtype=complex) - M
    det = np.linalg.det(I_minus_M)
    eigvals_M = np.linalg.eigvals(M)
    eigvals_IminusM = np.linalg.eigvals(I_minus_M)
    idx_min = np.argmin(np.abs(eigvals_IminusM))
    lam_crit = eigvals_M[idx_min]
    return det, lam_crit, eigvals_M

# Known zeta zeros (first 10)
zeta_zeros = [
    14.134725141734693,
    21.022039638771554,
    25.010857580145688,
    30.424876125859513,
    32.935061587739189,
    37.586178158825671,
    40.918719012147495,
    43.327073280915921,
    48.005150881167159,
    49.773832477672302
]

# Non-zero reference points
non_zero_points = [5.0, 8.0, 11.0, 16.0, 19.0]

print("=" * 95)
print("HYPOTHESIS: |det(I - M(s))| ≈ c / |ζ(2s)|  at s = 1/2 + it")
print("=" * 95)

N = 80

print(f"\nUsing N = {N}\n")
print(f"{'t':>12s}  {'|det|':>12s}  {'|1/ζ(2s)|':>14s}  {'ratio':>10s}  {'|1-λ_c|':>10s}  {'type':>10s}")
print("-" * 78)

results_zero = []
results_nonzero = []

for t in zeta_zeros:
    s = 0.5 + 1j * t
    det, lam, _ = compute_determinant_and_eigenvalues(s, N)
    s2 = 1.0 + 2j * t
    zeta_2s = mp.zeta(s2)
    inv_zeta = float(1.0 / abs(zeta_2s))
    ratio = abs(det) / inv_zeta if inv_zeta > 1e-15 else float('inf')
    dist = abs(1.0 - lam)
    results_zero.append((t, abs(det), inv_zeta, ratio, dist))
    print(f"{t:12.6f}  {abs(det):12.6f}  {inv_zeta:14.6f}  {ratio:10.6f}  {dist:10.6f}  {'zero':>10s}")

print()

for t in non_zero_points:
    s = 0.5 + 1j * t
    det, lam, _ = compute_determinant_and_eigenvalues(s, N)
    s2 = 1.0 + 2j * t
    zeta_2s = mp.zeta(s2)
    inv_zeta = float(1.0 / abs(zeta_2s))
    ratio = abs(det) / inv_zeta if inv_zeta > 1e-15 else float('inf')
    dist = abs(1.0 - lam)
    results_nonzero.append((t, abs(det), inv_zeta, ratio, dist))
    print(f"{t:12.6f}  {abs(det):12.6f}  {inv_zeta:14.6f}  {ratio:10.6f}  {dist:10.6f}  {'non-zero':>10s}")

# Summary statistics
ratios_zero = [r[3] for r in results_zero]
ratios_nz = [r[3] for r in results_nonzero]

print("\n" + "=" * 95)
print("SUMMARY")
print("=" * 95)
print(f"Ratio |det| / |1/ζ(2s)| at zeros:    mean = {np.mean(ratios_zero):.6f}, std = {np.std(ratios_zero):.6f}")
print(f"Ratio |det| / |1/ζ(2s)| at non-zeros: mean = {np.mean(ratios_nz):.6f}, std = {np.std(ratios_nz):.6f}")
print(f"|1 - λ_c| at zeros:                  mean = {np.mean([r[4] for r in results_zero]):.6f}")
print(f"|1 - λ_c| at non-zeros:              mean = {np.mean([r[4] for r in results_nz]):.6f}")

# Check if |det| itself differentiates
det_zero = [r[1] for r in results_zero]
det_nz = [r[1] for r in results_nonzero]
print(f"\n|det| at zeros:    mean = {np.mean(det_zero):.6f}, std = {np.std(det_zero):.6f}")
print(f"|det| at non-zeros: mean = {np.mean(det_nz):.6f}, std = {np.std(det_nz):.6f}")
print(f"Separation: |mean_diff| / pooled_std = {abs(np.mean(det_zero)-np.mean(det_nz)) / np.sqrt(np.std(det_zero)**2 + np.std(det_nz)**2):.4f}")