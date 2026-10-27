import mpmath as mp
mp.mp.dps = 100  # Ultra-high precision for t > 1000

def poisson_dual_ft(f, xi, Kmax=8):
    """Numerical Fourier transform ˆf(ξ + k) for k = -Kmax..Kmax."""
    def integrand(x, k):
        return f(x) * mp.exp(-2j * mp.pi * (xi + k) * x)
    dual = mp.mpc(0)
    for k in range(-Kmax, Kmax + 1):
        # Oscillatory quadrature with Levin or direct quad
        ft_k = mp.quad(lambda x: integrand(x, k), [0, mp.inf], error=True)
        dual += ft_k[0]  # real/imag part handled automatically
    return dual

def accelerated_trace_poisson(t: float, N: int = 500, Kmax: int = 6, hybrid=True) -> mp.mpc:
    """Poisson-accelerated critical-line trace (Dodds branch sum)."""
    z = mp.exp(1j * t)
    beta = mp.mpc(0.5, t)
    def f(x):  # slow amplitude
        n_tail = mp.mpf(x)
        denom = 1 + (n_tail ** (2 * beta))
        return (2 ** (2 * beta)) * (n_tail ** (2 * beta)) / denom
    
    # Finite sum + EM (reuse previous)
    finite_em = mp.mpc(0)
    for n in range(1, N + 1):
        finite_em += (2 ** (2*beta)) * (z**n) * (mp.mpf(n)**(2*beta)) / (1 + mp.mpf(n)**(2*beta))
    # Poisson dual on tail (absorb oscillation into FT)
    xi = t / (2 * mp.pi)
    tail_poisson = poisson_dual_ft(f, xi, Kmax)  # FT already includes e^{i t x}
    if hybrid:
        # Optional EM corrections on top of Poisson for extra precision
        tail_poisson += em_tail_trace(t, N)  # from previous EM function
    return finite_em + tail_poisson

def accelerated_mismatch_poisson(t: float, N: int = 200, Kmax: int = 5) -> float:
    """Poisson-accelerated Δ(t) tail (dominant λ_- Lorentzian)."""
    def h_minus(x):
        lam_m = 1 / x**2 - 3 / x**3  # asymptotic
        denom_m = ((mp.mpf('0.5') + lam_m)**2 + (t + lam_m)**2)**2
        return (t + lam_m) / denom_m
    # Poisson dual sum (no external frequency → ˆh(k))
    dual = mp.mpf(0)
    for k in range(-Kmax, Kmax + 1):
        # FT of h_minus at frequency k
        ft_k = mp.quad(lambda x: h_minus(x) * mp.exp(-2j * mp.pi * k * x), [0, mp.inf])
        dual += ft_k
    tail_delta = float(dual / mp.pi)
    # Add finite Galerkin + EM (previous functions)
    return mismatch_delta_approx(t, N) + tail_delta  # hybrid

# ====================== Usage & Zero-Hunting Example ======================
if __name__ == "__main__":
    t_test = 1000.0  # ultra-high example
    trace_p = accelerated_trace_poisson(t_test, N=300, Kmax=8)
    delta_p = accelerated_mismatch_poisson(t_test, N=100, Kmax=6)
    print(f"Poisson-accelerated trace at t={t_test}: {trace_p}")
    print(f"Poisson-accelerated Δ(t) at t={t_test}: {delta_p}")