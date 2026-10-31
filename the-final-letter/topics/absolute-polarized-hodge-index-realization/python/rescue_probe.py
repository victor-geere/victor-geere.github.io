"""Rescue probes for the absolute polarized Hodge-index programme.

Four independent checks support note 38:

1. ``arch_identity``:  Re A_arch(xi) = -Omega(xi + i/2)/2, where
   Omega(z) = Re psi(1/4 + i z/2) - log pi.  This is the exact relation
   between the CCM archimedean symbol and the Weil archimedean factor.

2. ``symbol_identity``:  A_arch(xi) + sum_n Lambda(n) n^{i xi}
   = -Z'/Z(-i xi) in the half-plane Im xi > 1, where
   Z(s) = pi^{-s/2} Gamma(s/2) zeta(s).  The identity is between analytic
   continuations; it is *not* a statement about the boundary value on the
   real axis.

3. ``gram_eigenvalues``: the CCM functional evaluated exactly on a
   finite-dimensional space of compactly supported mean-zero test
   functions.  No operator truncation is involved.  The form is
   sign-indefinite, so the dossier's normalisation is not the Weil
   functional.

4. ``tensor_factor_example``: a sequence of finite-dimensional KMS forms
   with unbounded modular Hamiltonians that nevertheless satisfies the
   compatibility condition and preserves positivity.  This disproves the
   claim that growing ``||H_N||`` obstructs the inductive limit.

Run ``python3 rescue_probe.py`` for a demo.

Truncation policy: ``weil_compact_gram_exact`` uses closed-form Fourier
transforms, ``mp.quad`` on ``[0, ∞)`` and the exact finite prime sum
``n = 2..7``.  The fixed-grid functions ``weil_compact_gram`` /
``weil_compact_gram_corrected`` and the truncated Gaussian functions
``multiplicative_gaussian_gram`` / ``gaussian_comparison`` are retained as
the round-47 record; they are not used for the corrected conclusions.
"""

from __future__ import annotations

import numpy as np
from numpy.polynomial.legendre import leggauss

import mpmath as mp

__all__ = [
    "arch_identity",
    "symbol_identity",
    "tent_value",
    "gram_eigenvalues",
    "weil_compact_gram_exact",
    "tensor_factor_example",
    "noncompatible_example",
]

mp.mp.dps = 30


# --------------------------------------------------------------------------
# 1. Archimedean identities
# --------------------------------------------------------------------------

def _ccm_arch(xi: float) -> float:
    """Re A_arch(xi) = (1/2)[log pi - Re psi(-i xi/2)]."""
    z = mp.mpc(0, -mp.mpf(xi) / 2)
    return float(mp.re(mp.mpf(1) / 2 * (mp.log(mp.pi) - mp.digamma(z))))


def _weil_omega(z) -> float:
    """Harmonic extension of Omega(z) = Re psi(1/4 + i z/2) - log pi."""
    return float(mp.re(mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * z / 2)) - mp.log(mp.pi))


def arch_identity(xi: float) -> dict:
    """Return Re A_arch and the Weil factor on the shifted contour."""
    a = _ccm_arch(xi)
    b = -_weil_omega(mp.mpf(xi) + mp.mpc(0, 0.5)) / 2
    return {"ccm": a, "weil_shifted": b, "diff": a - b}


def _completed(s):
    """Z(s) = pi^{-s/2} Gamma(s/2) zeta(s) (polynomial factor omitted)."""
    return mp.power(mp.pi, -s / 2) * mp.gamma(s / 2) * mp.zeta(s)


def _logderiv_completed(s):
    h = mp.mpf("1e-14")
    return -( _completed(s + h) - _completed(s - h) ) / (2 * h) / _completed(s)


def _logderiv_zeta(s):
    h = mp.mpf("1e-14")
    return -(mp.zeta(s + h) - mp.zeta(s - h)) / (2 * h) / mp.zeta(s)


def symbol_identity(xi: float) -> dict:
    """Compare the recorded CCM symbol with -Z'/Z(-i xi).

    The comparison uses the meromorphic continuations, so it is meaningful
    for every real ``xi`` except the pole at ``xi = 0``; the series
    definition of the prime symbol converges only for ``Im xi > 1``.
    """
    s = mp.mpc(0, -mp.mpf(xi))
    arch = mp.mpf(1) / 2 * (mp.log(mp.pi) - mp.digamma(s / 2))
    ccm = arch + _logderiv_zeta(s)
    completed = _logderiv_completed(s)
    return {
        "ccm": complex(ccm),
        "completed": complex(completed),
        "diff": complex(ccm - completed),
    }


# --------------------------------------------------------------------------
# 2. The CCM functional on exact compact-support tests
# --------------------------------------------------------------------------

def _lam(n: int) -> float:
    """von Mangoldt Lambda(n) for small n."""
    if n < 2:
        return 0.0
    p = 2
    while p * p <= n:
        if n % p == 0:
            m = n
            while m % p == 0:
                m //= p
            return float(np.log(p)) if m == 1 else 0.0
        p += 1
    return float(np.log(n))


def _leggauss_pair(nq: int):
    x, w = leggauss(nq)
    return x, w


def _quad(f, a, b, x, w):
    return 0.5 * (b - a) * float(np.sum(w * f(0.5 * (b - a) * x + 0.5 * (b + a))))


def _basis(k):
    """Even compactly supported test: (1 - x^2)_+ x^{2k} on [-1, 1]."""
    return lambda x: np.maximum(0.0, 1.0 - x ** 2) * x ** (2 * k)


def _autocorr(F, G, x, nq, gx, gw):
    """h(x) = int F(y) G(y - x) dy, the log-coordinate convolution."""
    lo = max(-1.0, x - 1.0)
    hi = min(1.0, x + 1.0)
    if hi <= lo:
        return 0.0
    return _quad(lambda y: F(y) * G(y - x), lo, hi, gx, gw)


def _ccm_pair(i, j, nq=160, n_terms=7):
    """N(F_i * F_{j,-}) for the recorded CCM functional.

    N(h) = sum_n Lambda(n) h(log n)
           + int_0^inf (e^{2x} h(x) - h(0))/(e^{2x} - 1) dx
           + c h(0),   c = (log pi + gamma)/2.
    """
    gx, gw = _leggauss_pair(nq)
    F, G = _basis(i), _basis(j)
    h = lambda x: _autocorr(F, G, x, nq, gx, gw)
    h0 = h(0.0)
    prime = sum(_lam(n) * h(float(np.log(n))) for n in range(2, n_terms + 1))
    xs = gx + 1.0  # map [-1, 1] to [0, 2]
    vals = np.array([h(float(t)) for t in xs])
    ar = float(np.sum(gw * (np.exp(2 * xs) * vals - h0) / (np.exp(2 * xs) - 1)))
    ar += (np.log(np.pi) + np.euler_gamma) / 2 * h0
    return prime + ar


def tent_value(nq: int = 160) -> float:
    """N for the tent F = (1 - |x|)_+; note 29 records 1.3708035."""
    gx, gw = _leggauss_pair(nq)
    F = lambda x: np.maximum(0.0, 1.0 - np.abs(x))
    h = lambda x: _autocorr(F, F, x, nq, gx, gw)
    h0 = h(0.0)
    prime = sum(_lam(n) * h(float(np.log(n))) for n in range(2, 8))
    xs = gx + 1.0
    vals = np.array([h(float(t)) for t in xs])
    ar = float(np.sum(gw * (np.exp(2 * xs) * vals - h0) / (np.exp(2 * xs) - 1)))
    ar += (np.log(np.pi) + np.euler_gamma) / 2 * h0
    return prime + ar


def gram_eigenvalues(nb: int = 5, nq: int = 120) -> dict:
    """Eigenvalues of the CCM form on the mean-zero compact-support subspace.

    The basis is ``F_k = (1 - x^2)_+ x^{2k}``, k = 0..nb-1.  The degree-zero
    condition is read as ``int F dx = 0``; the constrained basis is
    ``F_k - (m_k/m_0) F_0`` for k >= 1.
    """
    gx, gw = _leggauss_pair(nq)
    G = np.zeros((nb, nb))
    for i in range(nb):
        for j in range(i, nb):
            G[i, j] = G[j, i] = _ccm_pair(i, j, nq=nq)
    m = np.array([4.0 / ((2 * k + 1) * (2 * k + 3)) for k in range(nb)])
    C = np.zeros((nb, nb - 1))
    for k in range(1, nb):
        C[k, k - 1] = 1.0
        C[0, k - 1] = -m[k] / m[0]
    Gc = C.T @ G @ C
    return {
        "gram": G,
        "constrained": Gc,
        "eigenvalues": np.linalg.eigvalsh(G),
        "constrained_eigenvalues": np.linalg.eigvalsh(Gc),
    }


# --------------------------------------------------------------------------
# 3. Finite-dimensional inductive-limit examples
# --------------------------------------------------------------------------

def _density(H):
    H = 0.5 * (H + H.conj().T)
    w, U = np.linalg.eigh(H)
    w = w - w.max()
    rho = (U * np.exp(w)) @ U.conj().T
    return rho / np.trace(rho)


def _kms_form(a, H, rho):
    """The finite KMS form of note 03, in its positive orientation.

    With ``H = -log rho`` the trace ``Re Tr(rho a* [H,a])`` is *negative*
    semidefinite; note 03's positive form is its negative,
    ``(1/2) sum (p_i - p_j) log(p_i/p_j) |a_ij|^2``.  We return that
    orientation so that the theorem reads ``B >= 0``.
    """
    return -float(np.real(np.trace(rho @ (a.conj().T @ (H @ a - a @ H)))))


def tensor_factor_example(n_levels: int = 4, seed: int = 0) -> dict:
    """Unbounded modular Hamiltonians, compatible forms, preserved positivity.

    A_N = M_2 (x) M_{k_N}, H_N = H_0 (x) 1 + 1 (x) N*K.  The embedding
    a -> a (x) 1 keeps the form fixed while ||H_N|| grows without bound.
    """
    rng = np.random.default_rng(seed)
    H0 = rng.normal(size=(2, 2))
    H0 = 0.5 * (H0 + H0.T)
    a0 = rng.normal(size=(2, 2))
    a0 = 0.5 * (a0 + a0.T)
    rho0 = _density(H0)
    base = _kms_form(a0, H0, rho0)
    values, norms = [], []
    for level in range(n_levels):
        k = 2 + level
        K = rng.normal(size=(k, k))
        K = 0.5 * (K + K.T)
        H = np.kron(H0, np.eye(k)) + np.kron(np.eye(2), (level + 1) * K)
        rho = _density(H)
        a = np.kron(a0, np.eye(k))
        values.append(_kms_form(a, H, rho))
        norms.append(float(np.linalg.norm(H, 2)))
    return {
        "base": base,
        "values": values,
        "norms": norms,
        "max_deviation": float(np.max(np.abs(np.array(values) - base))),
        "min_value": float(np.min(values)),
        "norm_growth": norms[-1] > norms[0] * 2,
    }


def noncompatible_example(n_levels: int = 4, seed: int = 0) -> dict:
    """Same algebra, level-dependent Hamiltonian: no compatible limit."""
    rng = np.random.default_rng(seed)
    H0 = rng.normal(size=(2, 2))
    H0 = 0.5 * (H0 + H0.T)
    a0 = rng.normal(size=(2, 2))
    a0 = 0.5 * (a0 + a0.T)
    D = np.diag([1.0, -0.5])
    values = []
    for level in range(n_levels):
        H = H0 + (level + 1) * D
        values.append(_kms_form(a0, H, _density(H0)))
    return {
        "values": values,
        "spread": float(np.ptp(values)),
    }


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    print("archimedean identity")
    for x in (0.5, 2.0, 6.22885, 10.0):
        print(" ", x, arch_identity(x))
    print("symbol identity (meromorphic continuation)")
    for x in (0.5, 2.0, 10.0):
        print(" ", x, symbol_identity(x)["diff"])
    print("tent N =", tent_value(), " (note 29: 1.3708035)")
    g = gram_eigenvalues()
    print("unconstrained eigenvalues:", np.round(g["eigenvalues"], 8))
    print("constrained eigenvalues:  ", np.round(g["constrained_eigenvalues"], 8))
    t = tensor_factor_example()
    print("tensor factor: deviation", t["max_deviation"], "norms", np.round(t["norms"], 3))
    n = noncompatible_example()
    print("non-compatible spread", n["spread"])


# --------------------------------------------------------------------------
# 4. Same-basis comparison: recorded N versus the correct Weil functional
# --------------------------------------------------------------------------

def _lam_mp(n: int):
    """von Mangoldt Lambda(n) as an mpf."""
    if n < 2:
        return mp.mpf(0)
    for q in range(2, n + 1):
        if n % q == 0:
            m = n
            while m % q == 0:
                m //= q
            return mp.log(q) if m == 1 else mp.mpf(0)
    return mp.mpf(0)


def _gaussian_h(shift, v, sigma):
    """h(v) = sqrt(pi) sigma exp(-(v - shift)^2 / (4 sigma^2))."""
    return mp.sqrt(mp.pi) * sigma * mp.exp(-((mp.mpf(v) - mp.mpf(shift)) ** 2) / (4 * sigma ** 2))


def _omega_mp(t):
    return mp.re(mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * mp.mpf(t) / 2)) - mp.log(mp.pi)


def _recorded_N(shift, sigma):
    """The recorded CCM functional on the Gaussian h_shift."""
    h0 = _gaussian_h(shift, 0, sigma)
    prime = sum(_lam_mp(n) * _gaussian_h(shift, mp.log(n), sigma) for n in range(2, 60))
    f = lambda x: (mp.exp(2 * x) * _gaussian_h(shift, x, sigma) - h0) / (mp.exp(2 * x) - 1)
    arch = mp.quad(f, [0, 0.5, 1, 1.5, 2, 3, 4, 6])
    c0 = (mp.log(mp.pi) + mp.euler) / 2
    return prime + arch + c0 * h0


def _weil_W(shift, sigma):
    """The correct Weil functional on the Gaussian h_shift (sibling dossier)."""
    pole = 4 * mp.pi * sigma ** 2 * mp.exp(sigma ** 2 / 4) * mp.cosh(mp.mpf(shift) / 2)
    prime = -2 * sum(_lam_mp(n) / mp.sqrt(n) * _gaussian_h(shift, mp.log(n), sigma)
                     for n in range(2, 60))
    integrand = lambda t: (mp.exp(-(sigma * t) ** 2) * mp.cos(mp.mpf(shift) * t)
                           * _omega_mp(t))
    density = sigma ** 2 * mp.quad(integrand, [-200, -100, -50, -25, -10, 0, 10, 25, 50, 100, 200],
                                   maxdegree=4)
    return pole + density + prime


def gaussian_comparison(sigma: float = 0.05, centres=(-0.3, -0.1, 0.1, 0.3)) -> dict:
    """Recorded N versus correct W on the same narrow Gaussian basis.

    The W matrix reproduces the certified matrix of
    ``../prime-spectrum-tensor/WEIL-GRAM.md`` to its published digits.
    

    Fixed-grid / truncated record.  Use
    ``weil_compact_gram_exact`` for the polynomial compact-support basis.
    """
    sigma = mp.mpf(sigma)
    centres = [mp.mpf(c) for c in centres]
    n = len(centres)
    GN = mp.matrix(n, n)
    GW = mp.matrix(n, n)
    for i, a in enumerate(centres):
        for j, b in enumerate(centres):
            shift = a - b
            GN[i, j] = (_recorded_N(shift, sigma) + _recorded_N(-shift, sigma)) / 2
            GW[i, j] = (_weil_W(shift, sigma) + _weil_W(-shift, sigma)) / 2
    return {
        "N": np.array(GN.tolist(), dtype=float),
        "W": np.array(GW.tolist(), dtype=float),
        "N_eigenvalues": np.array(sorted(float(x.real) for x in mp.eig(GN, left=False, right=False))),
        "W_eigenvalues": np.array(sorted(float(x.real) for x in mp.eig(GW, left=False, right=False))),
    }


# --------------------------------------------------------------------------
# 5. Broad compact-support evaluation of W (open discrepancy, note 39)
# --------------------------------------------------------------------------

def weil_compact_gram(nb: int = 3, weighted: bool = False, nq: int = 1200,
                      n_t: int = 2000, t_max: float = 250.0) -> dict:
    """The Weil functional of §4 on the broad compact-support basis.

    ``weighted=True`` uses the multiplicative weight ``F(x) -> e^{x/2}F(x)``,
    which turns the zero sum into a sum of squares but changes the pole term.
    Both variants are strongly indefinite on this broad basis; the result is
    recorded as an open discrepancy in note 39, not as a disproof of RH.
    

    Fixed-grid / truncated record.  Use
    ``weil_compact_gram_exact`` for the polynomial compact-support basis.
    """
    gx, gw = _leggauss_pair(nq)

    def F(k, z):
        z = np.clip(z, -1.0, 1.0)
        core = np.maximum(0.0, 1.0 - z ** 2) * z ** (2 * k)
        return core * (np.exp(z / 2) if weighted else 1.0)

    def hfun(i, j, x):
        lo, hi = max(-1.0, x - 1.0), min(1.0, x + 1.0)
        if hi <= lo:
            return 0.0
        node = 0.5 * (hi - lo) * gx + 0.5 * (hi + lo)
        return 0.5 * (hi - lo) * float(np.sum(gw * F(i, node) * F(j, node - x)))

    P = np.zeros((nb, nb))
    Q = np.zeros((nb, nb))
    node = 2.0 * gx  # [-2, 2]
    for i in range(nb):
        for j in range(i, nb):
            vals = np.array([hfun(i, j, t) for t in node])
            if weighted:
                # 2 int h e^{x/2} cosh(x/2) = int h (e^x + 1)
                P[i, j] = P[j, i] = 2.0 * float(np.sum(gw * vals * (np.exp(node) + 1.0)))
            else:
                P[i, j] = P[j, i] = 4.0 * float(np.sum(gw * vals * np.cosh(node / 2)))
            if weighted:
                Q[i, j] = Q[j, i] = -2 * sum(
                    _lam(n) * hfun(i, j, float(np.log(n))) for n in range(2, 8))
            else:
                Q[i, j] = Q[j, i] = -2 * sum(
                    _lam(n) / np.sqrt(n) * hfun(i, j, float(np.log(n))) for n in range(2, 8))

    ts = np.linspace(0.0, t_max, n_t + 1)
    ws = np.full(n_t + 1, t_max / n_t)
    ws[0] /= 2
    ws[-1] /= 2
    FH = np.empty((nb, len(ts)), dtype=complex)
    for k in range(nb):
        re = np.sum(gw[:, None] * F(k, gx)[:, None] * np.cos(np.outer(gx, ts)), axis=0)
        im = -np.sum(gw[:, None] * F(k, gx)[:, None] * np.sin(np.outer(gx, ts)), axis=0)
        FH[k] = re + 1j * im
    Om = np.array([float(_omega_mp(t)) for t in ts])
    A = (1.0 / np.pi) * ((np.conj(FH) * ws * Om) @ FH.T).real
    W = P + Q + A
    return {
        "W": W,
        "P": P,
        "Q": Q,
        "A": A,
        "eigenvalues": np.linalg.eigvalsh(W),
    }


# --------------------------------------------------------------------------
# 6. The corrected archimedean sign (round 1 of the continued programme)
# --------------------------------------------------------------------------

def weil_compact_gram_corrected(nb: int = 4, nq: int = 1600, n_t: int = 3000,
                                t_max: float = 250.0, bump: bool = False) -> dict:
    """Compact-support Weil Gram with the standard additive explicit-formula signs.

    Additive formula:  sum_rho ghat(rho) = ghat(0) + ghat(1)
        - sum Lambda(n) n^{-1/2} (g(log n) + g(-log n))
        - (1/2pi) int ghat(t) Omega(t) dt.

    For g = F * F_- :  ghat(0) = (int F)^2 and ghat(1) = |Fhat(1)|^2.
    The archimedean density carries the standard minus sign; the sibling
    dossier's +Omega convention is the sign error isolated in note 39.
    ``bump=True`` uses the C-infinity compact support exp(-1/(1-x^2)).
    

    Fixed-grid / truncated record.  Use
    ``weil_compact_gram_exact`` for the polynomial compact-support basis.
    """
    gx, gw = _leggauss_pair(nq)

    def core(z):
        z = np.clip(z, -1.0, 1.0)
        if bump:
            return np.exp(-1.0 / np.maximum(1e-15, 1.0 - z ** 2))
        return np.maximum(0.0, 1.0 - z ** 2)

    def F(k, z):
        return core(z) * z ** (2 * k)

    def hfun(i, j, x):
        lo, hi = max(-1.0, x - 1.0), min(1.0, x + 1.0)
        if hi <= lo:
            return 0.0
        node = 0.5 * (hi - lo) * gx + 0.5 * (hi + lo)
        return 0.5 * (hi - lo) * float(np.sum(gw * F(i, node) * F(j, node - x)))

    a = np.array([np.sum(gw * F(k, gx)) for k in range(nb)])
    phi = np.array([np.sum(gw * F(k, gx) * np.cos(gx)) for k in range(nb)])
    P = np.outer(a, a) + np.outer(phi, phi)
    Q = np.zeros((nb, nb))
    for i in range(nb):
        for j in range(i, nb):
            Q[i, j] = Q[j, i] = -2 * sum(
                _lam(n) / np.sqrt(n) * hfun(i, j, float(np.log(n)))
                for n in range(2, 8))
    ts = np.linspace(0.0, t_max, n_t + 1)
    ws = np.full(n_t + 1, t_max / n_t)
    ws[0] /= 2
    ws[-1] /= 2
    FH = np.empty((nb, len(ts)))
    for k in range(nb):
        FH[k] = np.sum(gw[:, None] * F(k, gx)[:, None]
                       * np.cos(np.outer(gx, ts)), axis=0)
    Om = np.array([float(_omega_mp(t)) for t in ts])
    A = (1.0 / np.pi) * ((FH * ws * Om) @ FH.T)
    W = P + Q - A
    return {"W": W, "P": P, "Q": Q, "A": A, "eigenvalues": np.linalg.eigvalsh(W)}


# --------------------------------------------------------------------------
# 7. The width crossover (round 3): no single archimedean sign works
# --------------------------------------------------------------------------

def multiplicative_gaussian_gram(sigma: float = 0.05,
                                 centres=(-0.3, -0.1, 0.1, 0.3),
                                 arch_sign: int = -1,
                                 pole: str = "01",
                                 n_t: int = 3000, t_max: float = 150.0) -> dict:
    """Weil Gram on multiplicative Gaussians f_a(u)=exp(-(log u - a)^2/2sigma^2).

    ``pole="01"`` uses ghat(0)+ghat(1)=2 pi sigma^2 (1+e^{-sigma^2});
    ``pole="cosh"`` uses the sibling's 2 pi sigma^2 e^{sigma^2/4} cosh(c/2).
    ``arch_sign=+1`` uses +Omega, ``-1`` uses -Omega.
    Neither sign is positive definite across all widths (note 39).
    

    Fixed-grid / truncated record.  Use
    ``weil_compact_gram_exact`` for the polynomial compact-support basis.
    """
    sigma = float(sigma)
    n = len(centres)
    ts = np.linspace(0.0, t_max, n_t + 1)
    ws = np.full(n_t + 1, t_max / n_t)
    ws[0] /= 2
    ws[-1] /= 2
    Om = np.array([float(_omega_mp(t)) for t in ts])
    G = np.zeros((n, n))
    for i, a in enumerate(centres):
        for j, b in enumerate(centres):
            c = a - b
            h = lambda v: np.sqrt(np.pi) * sigma * np.exp(-((v - c) ** 2) / (4 * sigma ** 2))
            prime = -sum(_lam(k) / np.sqrt(k) * (h(np.log(k)) + h(-np.log(k)))
                         for k in range(2, 200))
            arch = 2 * sigma ** 2 * np.sum(ws * np.exp(-(sigma * ts) ** 2)
                                           * np.cos(c * ts) * Om)
            if pole == "01":
                p = 2 * np.pi * sigma ** 2 * (1 + np.exp(-sigma ** 2))
            else:
                p = 2 * np.pi * sigma ** 2 * np.exp(sigma ** 2 / 4) * np.cosh(c / 2)
            G[i, j] = p + prime + arch_sign * arch
    H = 0.5 * (G + G.T)
    return {"G": H, "eigenvalues": np.linalg.eigvalsh(H)}


# --------------------------------------------------------------------------
# 8. Exact compact-support Gram (no grid truncation, no missing weights)
# --------------------------------------------------------------------------

def weil_compact_gram_exact(nb: int = 4, pole: str = "cosh",
                            arch_sign: int = 1, dps: int = 30) -> dict:
    """Weil Gram on the compact-support basis with exact transforms and
    adaptive quadrature to infinity.

    ``pole="cosh"`` is the sibling dossier convention
    `2 ∫ h cosh(u/2)`; ``pole="additive"`` is `(∫F)^2 + Fhat(1)^2`.
    ``arch_sign=+1`` is `+Ω`, ``-1`` is `-Ω`.

    The archimedean integral is evaluated with `mp.quad` on `[0, ∞)` and the
    Fourier transforms are exact (sympy derivatives of the closed form), so
    there is no `t_max` cutoff and no missing quadrature weight.  The prime
    sum is the exact finite sum `n = 2..7`, because `h = F*F_-` is supported
    in `[-2,2]`.
    """
    import sympy as sp

    mp.mp.dps = dps
    t = sp.symbols('t')
    F0 = 4 * (sp.sin(t) - t * sp.cos(t)) / t ** 3
    FB = [sp.lambdify(t, (-1) ** k * sp.diff(F0, t, 2 * k), 'mpmath')
          for k in range(nb)]

    def Fhat(k, x):
        x = mp.mpf(x)
        if abs(x) < mp.mpf('0.1'):
            s = mp.mpf(0)
            for m in range(80):
                term = ((-1) ** m * x ** (2 * m) / mp.factorial(2 * m)
                        * 4 / ((2 * k + 2 * m + 1) * (2 * k + 2 * m + 3)))
                s += term
                if abs(term) < mp.mpf('1e-45'):
                    break
            return s
        return FB[k](x)

    def Fk(k, y):
        return (1 - y ** 2) * y ** (2 * k) if abs(y) <= 1 else mp.mpf(0)

    def h(i, j, x):
        lo, hi = max(-1, x - 1), min(1, x + 1)
        if hi <= lo:
            return mp.mpf(0)
        return mp.quad(lambda y: Fk(i, y) * Fk(j, y - x), [lo, hi])

    def lam(n):
        if n < 2:
            return mp.mpf(0)
        for q in range(2, n + 1):
            if n % q == 0:
                m = n
                while m % q == 0:
                    m //= q
                return mp.log(q) if m == 1 else mp.mpf(0)
        return mp.mpf(0)

    a = [4 / ((2 * k + 1) * (2 * k + 3)) for k in range(nb)]
    phi = [mp.quad(lambda y: Fk(k, y) * mp.cos(y), [-1, 1]) for k in range(nb)]
    if pole == "additive":
        P = [[a[i] * a[j] + phi[i] * phi[j] for j in range(nb)] for i in range(nb)]
    else:
        P = [[2 * mp.quad(lambda x: h(i, j, x) * mp.cosh(x / 2), [-2, 2])
              for j in range(nb)] for i in range(nb)]
    Q = [[-2 * sum(lam(n) / mp.sqrt(n) * h(i, j, mp.log(n))
                   for n in range(2, 8)) for j in range(nb)] for i in range(nb)]
    A = [[(1 / mp.pi) * mp.quad(
            lambda x: Fhat(i, x) * Fhat(j, x) * _omega_mp(x), [0, mp.inf])
          for j in range(nb)] for i in range(nb)]
    W = np.array([[float(P[i][j] + Q[i][j] + arch_sign * A[i][j])
                   for j in range(nb)] for i in range(nb)])
    return {"W": W, "P": P, "Q": Q, "A": A,
            "eigenvalues": np.linalg.eigvalsh(W)}


# --------------------------------------------------------------------------
# 9. Certified inputs for interval quadrature (round 10)
# --------------------------------------------------------------------------

def psi_prime_abs_bound(t: float) -> float:
    """A rigorous upper bound for ``|ψ'(1/4 + i t/2)|``.

    Uses ``ψ'(z) = Σ_{k≥0} 1/(z+k)²`` and the integral comparison:
    for ``b = |t|/2`` and ``a = 1/4``,
    ``Σ 1/((k+a)²+b²) ≤ 1/(a²+b²) + (1/b)(π/2 - atan(a/b))``.
    For ``|t| < 1`` the crude bound ``20`` is used (the series is bounded by
    ``1/a² + 1/a``).
    """
    t = abs(float(t))
    a = 0.25
    if t < 1.0:
        return 20.0
    b = t / 2.0
    first = 1.0 / (a * a + b * b)
    integral = (1.0 / b) * (np.pi / 2.0 - np.arctan(a / b))
    return first + integral


def _sibling_omega_interval(t, **kwargs):
    """The sibling dossier's certified enclosure of Ω(t)."""
    import sys
    from pathlib import Path
    here = Path(__file__).resolve()
    sib = here.parents[2] / "prime-spectrum-tensor" / "python"
    if str(sib) not in sys.path:
        sys.path.insert(0, str(sib))
    import programme
    return programme.omega_interval(t, **kwargs)


def omega_panel_interval(a: float, b: float, **kwargs) -> dict:
    """Certified enclosure of Ω on a panel ``[a,b]``, ``0 ≤ a < b``.

    Evaluates the sibling's point enclosure at the midpoint and inflates it by
    the Lipschitz bound ``|Ω'| ≤ (1/2)|ψ'|`` from `psi_prime_abs_bound` on the
    smaller endpoint.
    """
    import mpmath as mp
    a = float(a)
    b = float(b)
    mid = (a + b) / 2.0
    point = _sibling_omega_interval(mid, **kwargs)
    lip = 0.5 * psi_prime_abs_bound(min(abs(a), abs(b)))
    radius = lip * (b - a) / 2.0
    lo = float(point.a) - radius
    hi = float(point.b) + radius
    return {"lo": lo, "hi": hi, "point": point, "radius": radius,
            "lipschitz": lip}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    import mpmath as mp
    print("|psi'| bound vs numerical")
    for t in (0.5, 1.0, 2.0, 5.0, 10.0):
        z = mp.mpc(mp.mpf(1) / 4, mp.mpf(t) / 2)
        num = abs(mp.polygamma(1, z))
        print(t, "bound", psi_prime_abs_bound(t), "numeric", float(num))
    for (a, b) in ((0.0, 0.1), (0.4, 0.6), (1.0, 1.2)):
        d = omega_panel_interval(a, b)
        print("panel", a, b, d["lo"], d["hi"], "radius", d["radius"])


# --------------------------------------------------------------------------
# 10. Fast certified Omega enclosure (round 13)
# --------------------------------------------------------------------------

def omega_fast(t: float, N: int = 1000, dps: int = 40):
    """Certified enclosure of ``Ω(t)`` by recurrence plus Binet's integral.

    For ``z = 1/4 + i t/2`` and ``w = z + N``,

    ``ψ(z) = log w - 1/(2w) - 2∫_0^∞ u/((u²+w²)(e^{2πu}-1)) du - Σ_{k<N} 1/(z+k)``.

    With ``a = Re w = 1/4 + N`` the integral is bounded by ``1/(9 a²)``
    (using ``|u²+w²| ≥ 3a²/4``).  Only the real part is needed for ``Ω``, so
    every operation is real interval arithmetic.
    """
    import mpmath as mp
    mp.mp.dps = dps
    mp.iv.dps = dps
    t = float(t)
    b = mp.iv.mpf([t, t]) / 2
    b2 = b * b
    a = mp.mpf(1) / 4 + N
    aiv = mp.iv.mpf([a, a])
    D = aiv * aiv + b2
    term1 = mp.iv.log(D) / 2
    term2 = aiv / (2 * D)
    S = mp.iv.mpf([0, 0])
    for k in range(N):
        ak = mp.mpf(1) / 4 + k
        akiv = mp.iv.mpf([ak, ak])
        Dk = akiv * akiv + b2
        S += akiv / Dk
    rem = mp.mpf(1) / (9 * a * a)
    # log π with a declared tiny interval around the working-precision value
    lp = mp.log(mp.pi)
    logpi = mp.iv.mpf([lp - mp.mpf('1e-30'), lp + mp.mpf('1e-30')])
    return term1 - term2 - S - logpi + mp.iv.mpf([-rem, rem])


if __name__ == "__main__":  # pragma: no cover
    import mpmath as mp
    print("fast Omega vs digamma")
    for t in (0.5, 1.0, 2.0, 5.0, 10.0):
        iv = omega_fast(t)
        val = float(mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * mp.mpf(t) / 2)) - mp.log(mp.pi))
        print(t, iv, "value", val, "width", float(iv.b - iv.a),
              "contains", iv.a <= val <= iv.b)


# --------------------------------------------------------------------------
# 11. First certified interval for a Gaussian Gram entry (round 13)
# --------------------------------------------------------------------------

def _iv_const(x):
    import mpmath as mp
    return mp.iv.mpf([x, x])


def gaussian_W0_interval(sigma: float = 0.05, h: float = 0.01,
                         T: float = 100.0, N_omega: int = 1000) -> dict:
    """Certified interval for the Gaussian diagonal ``W(0)`` (cosh +Ω).

    Pole, prime and density are enclosed separately.  The density uses the
    midpoint rule with the first-derivative bound
    ``|f'| ≤ σ²[(2σ²t+|c|)M + L]``, where ``M`` bounds ``|Ω|`` and ``L``
    bounds ``|Ω'|`` on ``[0,T]``; the quadrature error is ``T h Mf/2``.
    """
    import mpmath as mp
    mp.mp.dps = 40
    mp.iv.dps = 40
    s = mp.mpf(sigma)
    pii = mp.iv.mpf([mp.pi - mp.mpf('1e-30'), mp.pi + mp.mpf('1e-30')])
    # pole
    pole = _iv_const(4 * s * s) * pii * mp.iv.exp(_iv_const(s * s / 4))
    # prime, n = 2..7; tail below 1e-100 (Gaussian exponent at log 8 is -432)
    prime = mp.iv.mpf([0, 0])
    for n in range(2, 8):
        L = mp.mpf(_lam(n))
        logn = mp.iv.log(n)
        hh = _iv_const(s) * mp.iv.sqrt(pii) * mp.iv.exp(
            _iv_const(-1) * (logn ** 2) / _iv_const(4 * s * s))
        prime += _iv_const(-2 * L) / mp.iv.sqrt(_iv_const(mp.mpf(n))) * hh
    tail = mp.mpf('1e-100')
    # global bounds on [0,T].  From the digamma series,
    # |ψ(1/4+it/2)| ≤ γ + 14.60(3/4 + t/2), so on [0,100] |Ω| ≤ 800;
    # |Ω'| ≤ 10 (0.5 * psi' bound 20).
    M = mp.mpf(800)
    L = mp.mpf(10)
    # density midpoint rule
    density = mp.iv.mpf([0, 0])
    npan = int(mp.ceil(T / h))
    hh = mp.mpf(T) / npan
    for k in range(npan):
        mid = (k + mp.mpf('1') / 2) * hh
        om = omega_fast(float(mid), N=N_omega)
        g = _iv_const(s * s) * mp.iv.exp(_iv_const(-(s * s) * mid * mid))
        density += g * om * hh
    # the Gaussian density is an integral over R; the integrand is even
    density = 2 * density
    # midpoint error: sum h * sup|f'| ~ ∫|f'|; per panel h²/2
    # ∫_0^∞ |f'| ≤ σ² [M + L √π/(2σ)] for the c = 0 diagonal
    Iabs = s * s * (M + L * mp.sqrt(mp.pi) / (2 * s))
    err = 2 * (hh * hh / 2) * Iabs
    # Gaussian tail beyond T, with the crude Ω bound at T
    tail_gauss = s * s * mp.e ** (-(s * T) ** 2) / (2 * s * s * T)  # rough
    dens = density + mp.iv.mpf([-err, err]) + mp.iv.mpf([-tail_gauss, tail_gauss])
    W = pole + prime + dens + mp.iv.mpf([-tail, tail])
    return {"lo": float(W.a), "hi": float(W.b), "width": float(W.b - W.a),
            "pole": pole, "prime": prime, "density_error": float(err),
            "M": float(M), "L": float(L)}


if __name__ == "__main__":  # pragma: no cover
    d = gaussian_W0_interval()
    print({k: d[k] for k in ("lo", "hi", "width", "density_error", "M", "L")})


# --------------------------------------------------------------------------
# 12. Interval PSD certificate for the Gaussian Gram (round 14)
# --------------------------------------------------------------------------

def _gauss_pole_interval(c, sigma):
    import mpmath as mp
    s = mp.mpf(sigma)
    pii = mp.iv.mpf([mp.pi - mp.mpf('1e-30'), mp.pi + mp.mpf('1e-30')])
    ch = (mp.iv.exp(_iv_const(mp.mpf(c) / 2))
          + mp.iv.exp(_iv_const(-mp.mpf(c) / 2))) / 2
    return _iv_const(4 * s * s) * pii * mp.iv.exp(_iv_const(s * s / 4)) * ch


def _gauss_prime_interval(c, sigma, cmax):
    import mpmath as mp
    s = mp.mpf(sigma)
    pii = mp.iv.mpf([mp.pi - mp.mpf('1e-30'), mp.pi + mp.mpf('1e-30')])
    total = mp.iv.mpf([0, 0])
    for n in range(2, 8):
        L = mp.mpf(_lam(n))
        logn = mp.iv.log(n)
        hh = _iv_const(s) * mp.iv.sqrt(pii) * mp.iv.exp(
            _iv_const(-1) * (logn - _iv_const(mp.mpf(c))) ** 2
            / _iv_const(4 * s * s))
        total += _iv_const(-2 * L) / mp.iv.sqrt(_iv_const(mp.mpf(n))) * hh
    return total


def gaussian_W_intervals(cs, sigma: float = 0.05, h: float = 0.01,
                         T: float = 100.0, N_omega: int = 1000,
                         M: float = 800.0, L: float = 10.0) -> dict:
    """Certified intervals for ``W(c)`` (cosh +Ω) for all ``c`` in ``cs``.

    The density is evaluated once on a shared midpoint grid; each ``c`` only
    changes the cosine factor.  Error per entry is
    ``h² σ²[M + (|c| M + L)√π/(2σ)]`` plus the Gaussian tail.
    """
    import mpmath as mp
    mp.mp.dps = 40
    mp.iv.dps = 40
    s = mp.mpf(sigma)
    cs = [mp.mpf(c) for c in cs]
    npan = int(mp.ceil(mp.mpf(T) / h))
    hh = mp.mpf(T) / npan
    dens = {c: mp.iv.mpf([0, 0]) for c in cs}
    for k in range(npan):
        mid = (k + mp.mpf('0.5')) * hh
        om = omega_fast(float(mid), N=N_omega)
        base = _iv_const(s * s * mp.e ** (-(s * s) * mid * mid))
        for c in cs:
            dens[c] += base * mp.iv.cos(_iv_const(c * mid)) * om * hh
    out = {}
    for c in cs:
        density = 2 * dens[c]
        Iabs = s * s * (mp.mpf(M) + (abs(c) * mp.mpf(M) + mp.mpf(L))
                        * mp.sqrt(mp.pi) / (2 * s))
        err = hh * hh * Iabs
        tg = s * s * mp.e ** (-(s * T) ** 2) / (2 * s * s * T)
        W = (_gauss_pole_interval(c, s) + _gauss_prime_interval(c, s, abs(c))
             + density + mp.iv.mpf([-err - tg, err + tg]))
        out[c] = W
    return out


def gaussian_gram_intervals(centres, **kwargs) -> dict:
    import mpmath as mp
    centres = [mp.mpf(c) for c in centres]
    cs = sorted({a - b for a in centres for b in centres})
    W = gaussian_W_intervals(cs, **kwargs)
    n = len(centres)
    G = [[None] * n for _ in range(n)]
    for i in range(n):
        for j in range(i, n):
            c = centres[i] - centres[j]
            e = (W[c] + W[-c]) / 2   # symmetrise the interval entry
            G[i][j] = e
            G[j][i] = e
    return {"G": G, "W": W, "centres": centres}


def interval_psd_check(G, slack: float = 1e-9) -> dict:
    """Centre plus operator-norm slack, with an exact rational minor check."""
    import sympy as sp
    n = len(G)
    centers = [[0.0] * n for _ in range(n)]
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
    minors = [sp.Matrix(P[:k, :k]).det() for k in range(1, n + 1)]
    ok = all(m > 0 for m in minors)
    return {"ok": ok, "t": t, "minors": minors,
            "centers": centers, "half": half}


if __name__ == "__main__":  # pragma: no cover
    d = gaussian_gram_intervals([0.0, 0.4], h=0.02, T=80.0)
    print(interval_psd_check(d["G"]))


# --------------------------------------------------------------------------
# 13. First compact-support interval entry (round 27)
# --------------------------------------------------------------------------

def compact_W00_interval(hstep: float = 0.002, T: float = 40.0,
                         N_omega: int = 1000) -> dict:
    """Certified (wide) interval for the compact-support diagonal `W_00`.

    Pole and prime terms are exact intervals; the archimedean integral uses
    the midpoint rule with the majorant
    `|f'| ≤ 2 B0 B1 M + B0² L`, where
    `B0 = min(4/3, 4(1+t)/t³)`, `B1 = 4(t²+3t+3)/t⁴` (and `2` for `t < 1`),
    `M` bounds `|Ω|` on `[0,T]` and `L = 10` bounds `|Ω'|`.
    """
    import mpmath as mp
    mp.mp.dps = 40
    mp.iv.dps = 40
    # h(x) = -x^5/30 + 2x^3/3 - 4x^2/3 + 16/15  (powers 5..0)
    coef = [mp.mpf(-1) / 30, 0, mp.mpf(2) / 3, mp.mpf(-4) / 3, 0, mp.mpf(16) / 15]

    def hpoly(xiv):
        acc = mp.iv.mpf([0, 0])
        for c in coef:
            acc = acc * xiv + _iv_const(mp.mpf(c))
        return acc

    pii = mp.iv.mpf([mp.pi - mp.mpf('1e-30'), mp.pi + mp.mpf('1e-30')])
    # pole: 1280 cosh 1 - 1024 sinh 1 - 768, via exp
    e1 = mp.iv.exp(_iv_const(mp.mpf(1)))
    em1 = mp.iv.exp(_iv_const(mp.mpf(-1)))
    ch = (e1 + em1) / 2
    sh = (e1 - em1) / 2
    pole = _iv_const(mp.mpf(1280)) * ch - _iv_const(mp.mpf(1024)) * sh \
        - _iv_const(mp.mpf(768))
    # prime, n = 2..7; tail beyond 7 below 1e-100
    prime = mp.iv.mpf([0, 0])
    for n in range(2, 8):
        L = mp.mpf(_lam(n))
        logn = mp.iv.log(n)
        prime += _iv_const(-2 * L) / mp.iv.sqrt(_iv_const(mp.mpf(n))) * hpoly(logn)
    tail = mp.mpf('1e-100')
    # certified bound M on |Omega| over [0,T]
    M = mp.mpf(0)
    L1 = mp.mpf(10)
    step = mp.mpf('0.1')
    tt = mp.mpf(0)
    while tt <= T:
        iv = omega_fast(float(tt), N=N_omega)
        M = max(M, max(abs(float(iv.a)), abs(float(iv.b))) + L1 * float(step) / 2)
        tt += step
    # arch midpoint rule
    npan = int(mp.ceil(mp.mpf(T) / hstep))
    hh = mp.mpf(T) / npan
    arch = mp.iv.mpf([0, 0])
    for k in range(npan):
        mid = (k + mp.mpf('0.5')) * hh
        om = omega_fast(float(mid), N=N_omega)
        # Fhat(t) = 4 (sin t - t cos t)/t^3
        t = _iv_const(mid)
        fhat = _iv_const(mp.mpf(4)) * (mp.iv.sin(t) - t * mp.iv.cos(t)) / (t ** 3)
        arch += fhat * fhat * om * hh
    arch = arch / pii
    # error bound
    def B0(t):
        t = mp.mpf(t)
        if t <= 1:
            return mp.mpf(4) / 3
        return min(mp.mpf(4) / 3, 4 * (1 + t) / t ** 3)

    def B1(t):
        t = mp.mpf(t)
        if t <= 1:
            return mp.mpf(2)
        return 4 * (t * t + 3 * t + 3) / t ** 4

    I = mp.quad(lambda t: 2 * B0(t) * B1(t) * M + B0(t) ** 2 * L1, [0, 1, T])
    err = hh * hh / 2 * I
    tailI = mp.quad(lambda t: 2 * B0(t) * B1(t) * M + B0(t) ** 2 * L1,
                    [T, T + 10, T + 100, mp.inf])
    W = pole + prime + arch + mp.iv.mpf([-err - tailI, err + tailI])
    lo = float(W.a); hi = float(W.b)
    return {"lo": lo, "hi": hi, "width": hi - lo,
            "err": float(err), "tail": float(tailI), "M": float(M),
            "pole": float(pole.a), "prime": float(prime.a),
            "arch_center": (float(arch.a) + float(arch.b)) / 2}


if __name__ == "__main__":  # pragma: no cover
    d = compact_W00_interval()
    print({k: d[k] for k in ("lo", "hi", "width", "err", "tail", "M")})


def compact_W00_interval_hybrid(T1: float = 100.0, T2: float = 400.0,
                                h1: float = 0.001, h2: float = 0.01,
                                N_omega: int = 1000) -> dict:
    """Hybrid-grid compact-support diagonal interval.

    Fine grid on `[0,T1]`, coarse on `[T1,T2]` (the majorant is tiny there),
    and a sharp tail beyond `T2`.  Aim: a positive lower bound.
    """
    import mpmath as mp
    mp.mp.dps = 40
    mp.iv.dps = 40
    coef = [mp.mpf(-1) / 30, 0, mp.mpf(2) / 3, mp.mpf(-4) / 3, 0, mp.mpf(16) / 15]

    def hpoly(xiv):
        acc = mp.iv.mpf([0, 0])
        for c in coef:
            acc = acc * xiv + _iv_const(mp.mpf(c))
        return acc

    pii = mp.iv.mpf([mp.pi - mp.mpf('1e-30'), mp.pi + mp.mpf('1e-30')])
    e1 = mp.iv.exp(_iv_const(mp.mpf(1)))
    em1 = mp.iv.exp(_iv_const(mp.mpf(-1)))
    ch = (e1 + em1) / 2
    sh = (e1 - em1) / 2
    pole = _iv_const(mp.mpf(1280)) * ch - _iv_const(mp.mpf(1024)) * sh \
        - _iv_const(mp.mpf(768))
    prime = mp.iv.mpf([0, 0])
    for n in range(2, 8):
        L = mp.mpf(_lam(n))
        logn = mp.iv.log(n)
        prime += _iv_const(-2 * L) / mp.iv.sqrt(_iv_const(mp.mpf(n))) * hpoly(logn)
    tail = mp.mpf('1e-100')
    M = mp.mpf(0)
    L1 = mp.mpf(10)
    step = mp.mpf('0.5')
    tt = mp.mpf(0)
    while tt <= T2:
        iv = omega_fast(float(tt), N=N_omega)
        M = max(M, max(abs(float(iv.a)), abs(float(iv.b))) + L1 * float(step) / 2)
        tt += step
    def panel_sum(a, b, hs):
        n = int(mp.ceil((b - a) / hs))
        hh = (b - a) / n
        s = mp.iv.mpf([0, 0])
        for k in range(n):
            mid = a + (k + mp.mpf('0.5')) * hh
            om = omega_fast(float(mid), N=N_omega)
            t = _iv_const(mid)
            fhat = _iv_const(mp.mpf(4)) * (mp.iv.sin(t) - t * mp.iv.cos(t)) / (t ** 3)
            s += fhat * fhat * om * hh
        return s, hh
    s1, hh1 = panel_sum(mp.mpf(0), mp.mpf(T1), mp.mpf(h1))
    s2, hh2 = panel_sum(mp.mpf(T1), mp.mpf(T2), mp.mpf(h2))
    arch = (s1 + s2) / pii

    def B0(t):
        t = mp.mpf(t)
        if t <= 1:
            return mp.mpf(4) / 3
        return min(mp.mpf(4) / 3, 4 * (1 + t) / t ** 3)

    def B1(t):
        t = mp.mpf(t)
        if t <= 1:
            return mp.mpf(2)
        return 4 * (t * t + 3 * t + 3) / t ** 4

    major = lambda t: 2 * B0(t) * B1(t) * M + B0(t) ** 2 * L1
    I1 = mp.quad(major, [0, 1, T1])
    I2 = mp.quad(major, [T1, (T1 + T2) / 2, T2])
    err = hh1 * hh1 / 2 * I1 + hh2 * hh2 / 2 * I2
    tailI = mp.quad(major, [T2, T2 + 100, T2 + 1000, mp.inf])
    W = pole + prime + arch + mp.iv.mpf([-err - tailI, err + tailI])
    lo = float(W.a); hi = float(W.b)
    return {"lo": lo, "hi": hi, "width": hi - lo,
            "err": float(err), "tail": float(tailI), "M": float(M),
            "pole": float(pole.a), "prime": float(prime.a),
            "arch_center": (float(arch.a) + float(arch.b)) / 2}
