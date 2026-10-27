import numpy as np
from scipy.linalg import sqrtm, logm

def build_Ak(k, t):
    d = dimension(k)
    A = np.zeros((d,d), dtype=complex)
    # fill matrix entries using convergent sum over j
    for m in range(d):
        for n in range(d):
            A[m,n] = sum( weight(j, m, n, t) for j in range(1, Jmax) )
    return A

def compute_Hk(k, epsilon=1e-6):
    A0 = build_Ak(k, 0)
    Aeps = build_Ak(k, epsilon)
    # polar decomposition at epsilon
    U0, _ = polar(A0)
    Ueps, _ = polar(Aeps)
    # logarithm branch continuity: ensure det(U) = 1
    H = 1j/epsilon * logm( Ueps @ U0.conj().T )  # or logm(Ueps) - logm(U0)
    # make Hermitian
    return (H + H.conj().T)/2

def compute_eigenvalues(k):
    Hk = compute_Hk(k)
    return np.linalg.eigvalsh(Hk)

# Main loop
zeros_ref = load_riemann_zeros(100)
for k in [10, 20, 40, 80, 160, 320]:
    evals = compute_eigenvalues(k)
    errors = match_and_evaluate(evals, zeros_ref)
    spacings = unfold_and_spacings(evals)
    ks_stat = kolmogorov_smirnov_test(spacings, gue_cdf)
    print(f"d={len(evals)}, max_err={errors.max():.2e}, rms={errors.rms:.2e}, KS={ks_stat:.3f}")