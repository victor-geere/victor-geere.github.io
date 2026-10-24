#!/usr/bin/env python3
"""parity_diagnostic.py — deliverable (c3) of goal 3.

Finite-range diagnostic for pretentious or periodic structure in the correlation sequence
f(n) = lambda(n) lambda(n+2).  A "conspiracy" that could see Omega-parity would have to show up as
either (i) a spike in the power spectrum at a rational frequency (periodicity), or (ii) a spike at a
real frequency in the Mellin/pretentious scan sum_{n<=N} f(n) n^{-it} (a Dirichlet character or n^{it}
component), or (iii) a large single-shift correlation C(h) at small h.

The cyclic autocorrelation used here is exactly the object formalised in ConeLean.SpectralStructure
(deliverable (b1)), and the script also checks Wiener-Khinchin numerically:
    |F(k)|^2 = sum_h C(h) omega^{kh},        sum_k |F(k)|^4 = N * sum_h |C(h)|^2 .

HARD CAVEAT: this is FINITE-RANGE EVIDENCE ONLY.  No finite computation can decide the asymptotic
statement o(x) — the archive's F4 records that finite prefixes cannot distinguish the truth of
Chowla.  A clean diagnostic is consistent with the conjecture and with many alternatives; it is
reported as HEURISTIC, never as evidence about the limit.
"""
import numpy as np

def liouville_sieve(N: int) -> np.ndarray:
    """lambda(n) for 0 <= n <= N, vectorised: lambda(n) = (-1)^Omega(n)."""
    omega = np.zeros(N + 1, dtype=np.int32)
    sieve = np.ones(N + 1, dtype=bool)
    sieve[:2] = False
    for p in range(2, N + 1):
        if sieve[p]:
            sieve[p * p :: p] = False
            pk = p
            while pk <= N:
                omega[pk::pk] += 1
                pk *= p
    lam = np.where(omega % 2 == 0, 1, -1).astype(np.int8)
    lam[0] = 0
    return lam

def main(N: int = 2 ** 22, tmax: float = 60.0, nts: int = 241, seed: int = 0):
    lam = liouville_sieve(N)
    f = (lam[: N - 1].astype(np.float64) * lam[2 : N + 1].astype(np.float64))  # n = 1..N-2 -> f(n)
    M = f.size
    print(f"[c3] N = {N}, window length M = {M}, mean f = {f.mean():+.6f}")

    # ---- (1) cyclic autocorrelation via FFT  (the object of deliverable (b1)) ----
    F = np.fft.rfft(f)
    spec = np.abs(F) ** 2                      # |F(k)|^2 = sum_h C(h) omega^{kh}
    C = np.fft.irfft(spec, n=M)                # cyclic autocorrelation C(h) = sum_n f(n)f(n+h)
    energy_lhs = float(np.sum(C ** 2))
    # rfft is one-sided: double the interior frequencies to get the full-k sum
    full = 2.0 * np.sum(spec ** 2) - spec[0] ** 2 - spec[-1] ** 2
    energy_rhs = float(full) / M
    print(f"[c3] Wiener-Khinchin numeric check (b1): sum_h C(h)^2 = {energy_lhs:.6e} vs "
          f"(1/M) sum_k |F(k)|^4 = {energy_rhs:.6e}   rel.diff = "
          f"{abs(energy_lhs - energy_rhs) / max(energy_lhs, 1e-30):.3e}")
    rms = float(np.sqrt(np.mean(f ** 2)))
    scale = rms * M ** 0.5                     # random-fluctuation scale for C(h)
    # for a random +-1 sequence, max_{h != 0} |C(h)| is ~ sqrt(2 log M) * rms * sqrt(M)
    expmax = (2 * np.log(M)) ** 0.5 * scale
    print(f"[c3] random-fluctuation scale for |C(h)| is ~ {scale:.3e}; expected max over "
          f"{M} lags ~ {expmax:.3e}; observed max_{{h != 0}} = {np.max(np.abs(C[1:])):.3e} "
          f"({np.max(np.abs(C[1:])) / expmax:.3f} of expected max)")
    print("[c3] small-lag correlations (the Chowla shift is h = 2):")
    for h in range(1, 9):
        print(f"[c3]   C({h}) = {C[h]:+.4e}   C(h)/scale = {C[h] / scale:+.4f}")
    idx = np.argsort(-np.abs(C[1:]))[:6] + 1
    for h in sorted(idx.tolist()):
        print(f"[c3]   C({h}) = {C[h]:+.3e}   (C(h)/scale = {C[h] / scale:+.3f})")

    # ---- (2) periodic conspiracy: spikes in the power spectrum at k != 0 ----
    k = np.arange(1, spec.size)
    # for a random sequence the periodogram is exponential: mean 1, expected max ~ log M
    print(f"[c3] periodogram: mean |F(k)|^2/(M*rms^2) = {spec[1:].mean() / (M * rms ** 2):.4f} "
          f"(1.0 = white); max/(M*rms^2) = {spec[1:].max() / (M * rms ** 2):.4f} at k = "
          f"{int(k[np.argmax(spec[1:])])} (expected max for white noise ~ log M = {np.log(M):.2f})")

    # ---- (3) Mellin / pretentious scan:  sum_{n<=N0} f(n) n^{-it} ----
    N0 = min(M, 2 ** 20)
    logn = np.log(np.arange(1, N0 + 1, dtype=np.float64))
    fn = f[:N0]
    ts = np.linspace(0.0, tmax, nts)
    vals = np.empty(nts)
    for i, t in enumerate(ts):
        vals[i] = np.abs(np.sum(fn * np.exp(-1j * t * logn)))
    nscale = np.sqrt(N0)
    print(f"[c3] Mellin scan over t in [0,{tmax}] ({nts} points), n <= {N0}: "
          f"max|M(t)|/sqrt(N0) = {vals.max() / nscale:.3f} at t = {ts[int(np.argmax(vals))]:.3f}; "
          f"median = {np.median(vals) / nscale:.3f}")
    # control: what does a random +-1 sequence look like on the same statistic?
    rng = np.random.default_rng(seed)
    ctrl = np.empty(nts)
    r = rng.choice([-1.0, 1.0], size=N0)
    for i, t in enumerate(ts):
        ctrl[i] = np.abs(np.sum(r * np.exp(-1j * t * logn)))
    print(f"[c3] control (random +-1, same N): max/sqrt(N0) = {ctrl.max() / nscale:.3f}; "
          f"median = {np.median(ctrl) / nscale:.3f}")
    print("[c3] HEURISTIC ONLY: finite-range diagnostic; no finite computation decides o(x).")

if __name__ == "__main__":
    main()
