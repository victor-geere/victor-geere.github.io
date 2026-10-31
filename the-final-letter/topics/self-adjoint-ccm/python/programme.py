"""Self-adjoint / CCM operator — exact computation layer.

The archived source is a *blueprint*, not a proof: it constructs the
generalised Riemann helix, states a Frenet--Serret torsion formula, and
then asserts (without proof here) that a Dirac operator with point
interactions is self-adjoint and that its band-limited projection is the
CCM Weil form.  This module implements only the exact, checkable layer:

* the helix ``C(t) = (cos φ(t), sin φ(t), t)`` and its Frenet torsion;
* the source's closed torsion formula (equation (1) of the paper);
* the constant-phase torsion ``ω / (1 + ω²)``;
* the CCM half-integer Fourier frequencies ``μ_k``;
* the point-interaction matching coefficient and its unit modulus;
* the logarithmic dictionary ``x = m log p`` and the cutoff ``p^m ≤ λ²``;
* the von Mangoldt coefficients of the zeta explicit formula.

Everything is sympy-exact.  Numerical evaluation is used only where a
transcendental comparison has no closed form, and the tolerance is
stated at the point of use.
"""

from __future__ import annotations

import mpmath as mp
import sympy as sp

PI = sp.pi
I = sp.I


def helix(phi: sp.Expr, t: sp.Symbol) -> sp.Matrix:
    """The generalised Riemann helix ``C(t) = (cos φ(t), sin φ(t), t)``."""
    return sp.Matrix([sp.cos(phi), sp.sin(phi), t])


def helix_projection_norm_sq(phi: sp.Expr) -> sp.Expr:
    """Squared distance of ``C(t)`` from the z-axis: ``cos²φ + sin²φ``."""
    return sp.simplify(sp.cos(phi) ** 2 + sp.sin(phi) ** 2)


def frenet_torsion(phi: sp.Expr, t: sp.Symbol) -> sp.Expr:
    """Frenet--Serret torsion of ``C(t)``, from derivatives of ``φ``.

    ``τ = (C' × C'') · C''' / |C' × C''|²``.  Raises ``ValueError`` when
    the curve is not regular (the cross product vanishes), which happens
    only for a degenerate phase.
    """
    C = helix(phi, t)
    d1 = sp.diff(C, t)
    d2 = sp.diff(d1, t)
    d3 = sp.diff(d2, t)
    cross = d1.cross(d2)
    den = sp.simplify(cross.dot(cross))
    if den == 0:
        raise ValueError("curve is not regular: C' x C'' vanishes")
    return sp.simplify(sp.trigsimp(sp.expand(cross.dot(d3) / den)))


def source_torsion(phi: sp.Expr, t: sp.Symbol) -> sp.Expr:
    """The archived source's closed torsion formula, equation (1).

    With ``p = φ'``, ``q = φ''``, ``r = φ'''``:

        τ = p (p⁴ − p r + 3 q²) / (p⁶ + p⁴ + q²).
    """
    p = sp.diff(phi, t)
    q = sp.diff(p, t)
    r = sp.diff(q, t)
    return sp.simplify(p * (p**4 - p * r + 3 * q**2) / (p**6 + p**4 + q**2))


def torsion_denominator(pp: sp.Expr, qq: sp.Expr) -> sp.Expr:
    """The positive denominator ``p⁶ + p⁴ + q²`` of the source formula."""
    return pp**6 + pp**4 + qq**2


def const_phase_torsion(omega: sp.Expr) -> sp.Expr:
    """Torsion of the constant-phase helix ``φ(t) = ω t``.

    The source formula collapses to ``ω / (1 + ω²)``.  The phase must be
    strictly increasing, so ``omega`` must be positive; ``omega = 0`` is
    the degenerate case in which the helix is the straight z-axis and the
    Frenet frame is undefined.
    """
    omega = sp.sympify(omega)
    if bool(omega <= 0):
        raise ValueError("the phase must be strictly increasing: omega > 0")
    return sp.simplify(omega / (1 + omega**2))


def frequency(L: sp.Expr, k) -> sp.Expr:
    """CCM Fourier frequency ``μ_k = (2π/L)(k + ½)``, ``k ∈ ℤ``."""
    if sp.simplify(L) == 0:
        raise ValueError("L must be non-zero")
    return sp.simplify(2 * PI / L * (sp.Integer(k) + sp.Rational(1, 2)))


def frequency_gap(L: sp.Expr) -> sp.Expr:
    """Gap ``μ_{k+1} − μ_k = 2π/L``, independent of ``k``."""
    return sp.simplify(frequency(L, 1) - frequency(L, 0))


def matching_coefficient(coupling: sp.Expr) -> sp.Expr:
    """Point-interaction matching phase ``exp(i c)`` at a scatterer."""
    return sp.exp(I * coupling)


def matching_modulus_sq(coupling: sp.Expr) -> sp.Expr:
    """``|exp(i c)|²`` evaluated through real and imaginary parts."""
    z = sp.expand_complex(matching_coefficient(coupling))
    return sp.simplify(sp.re(z) ** 2 + sp.im(z) ** 2)


def log_prime_power(p: sp.Expr, m: int) -> sp.Expr:
    """Logarithmic coordinate ``log(p^m) = m log p`` of a prime power."""
    if m < 1:
        raise ValueError("m must be a positive integer")
    if p <= 1:
        raise ValueError("p must exceed 1")
    return sp.simplify(sp.log(p**m) - m * sp.log(p))


def prime_power_cutoff(p: int, m: int, lam: sp.Expr) -> tuple[bool, bool]:
    """The dictionary pair ``(p^m ≤ λ², m log p ≤ 2 log λ)``.

    The first member is decided exactly in integer arithmetic.  The
    second is decided numerically from the exact logarithmic difference;
    logs of distinct integers are compared with a 50-digit evaluation,
    which is far beyond the separation of the small cases used in tests.
    """
    if p < 2 or m < 1 or lam <= 1:
        raise ValueError("require p >= 2, m >= 1, lambda > 1")
    arithmetic = bool(p**m <= sp.Integer(lam) ** 2)
    difference = sp.N(m * sp.log(p) - 2 * sp.log(lam), 50)
    logarithmic = bool(difference <= 0)
    return arithmetic, logarithmic


def zeta_coefficient(p: int, m: int) -> sp.Expr:
    """Coefficient ``c(p^m)`` of ``−ζ'/ζ``: ``log p`` for every ``m ≥ 1``."""
    if p < 2:
        raise ValueError("p must be a prime integer >= 2")
    if m < 1:
        raise ValueError("m must be a positive integer")
    return sp.log(p)


def von_mangoldt(n: int) -> sp.Expr:
    """``Λ(n) = log p`` if ``n = p^m``, else 0 (exact factorisation)."""
    if n < 1:
        raise ValueError("n must be positive")
    if n == 1:
        return sp.Integer(0)
    factors = sp.factorint(n)
    if len(factors) != 1:
        return sp.Integer(0)
    p = next(iter(factors))
    return sp.log(p)


# ---------------------------------------------------------------------------
# Finite CCM compression and the bridge obstruction
# ---------------------------------------------------------------------------
# The source's finite matrix is Q_{k l} = <e_k, D_lambda e_l>, with
# e_k(x) = exp(i mu_k x), mu_k = (2 pi / L)(k + 1/2), L = 2 log lambda.
# With the free convention D_free = -i d/dx this gives
#
#   Q_{k l} = mu_k delta_{k l}
#             + (1/L) sum_j alpha_j exp(i (mu_l - mu_k) x_j),
#   alpha_j = c(p^m) p^{-m/2}, x_j = m log p mod L.
#
# The scalar `sign` below keeps the opposite convention (D_free = i d/dx)
# visible; it flips the free diagonal and swaps the two corners.  The
# properties tested here do not depend on that convention.


def prime_power_terms(lam: float) -> list[tuple[int, int, sp.Expr, sp.Expr]]:
    """Return ``(p, m, alpha, x)`` for every prime power ``p^m <= lam^2``.

    ``alpha = log(p) / sqrt(p^m)`` is the source's real coupling and
    ``x = m log p`` is its position before reduction modulo ``L``.
    Both are exact sympy expressions; the caller decides where it needs
    a numerical reduction.
    """
    if float(lam) <= 1:
        raise ValueError("lambda must exceed 1")
    limit = int(float(lam) ** 2)
    terms: list[tuple[int, int, sp.Expr, sp.Expr]] = []
    for p in sp.primerange(2, limit + 1):
        p = int(p)
        m = 1
        while p**m <= limit:
            alpha = sp.log(p) / sp.sqrt(p**m)
            x = m * sp.log(p)
            terms.append((p, m, alpha, x))
            m += 1
    return terms


def prime_power_weight_sum(lam: float) -> sp.Expr:
    """The total coupling ``S = sum alpha_j``, exactly in sympy."""
    return sp.Add(*[term[2] for term in prime_power_terms(lam)])


def ccm_frequencies(L: float, N: int) -> list:
    """The band-limit frequencies ``mu_k = (2 pi / L)(k + 1/2)``, ``|k| <= N``."""
    if N < 0:
        raise ValueError("N must be non-negative")
    L = mp.mpf(L)
    return [2 * mp.pi / L * (k + mp.mpf("0.5")) for k in range(-N, N + 1)]


def ccm_compression_matrix(lam: float, N: int, sign: int = 1, dps: int = 40):
    """The explicit Hermitian compression ``Q_{k l}`` of the CCM operator.

    Returns an ``mpmath`` matrix of dimension ``2N + 1``.  The entries are
    evaluated at ``dps`` decimal digits; the matrix is Hermitian by the
    conjugate-symmetry of ``exp(i(mu_l - mu_k)x_j)``.
    """
    if sign not in (-1, 1):
        raise ValueError("sign must be +1 or -1")
    if N < 0:
        raise ValueError("N must be non-negative")
    if float(lam) <= 1:
        raise ValueError("lambda must exceed 1")
    with mp.workdps(dps):
        L = 2 * mp.log(lam)
        mu = ccm_frequencies(L, N)
        dim = 2 * N + 1
        Q = mp.matrix(dim, dim)
        for i in range(dim):
            for j in range(dim):
                Q[i, j] = sign * mu[i] if i == j else mp.mpc(0)
        for p, m, alpha_exact, _ in prime_power_terms(lam):
            alpha = mp.log(p) / mp.sqrt(p**m)
            x = mp.fmod(m * mp.log(p), L)
            for i in range(dim):
                for j in range(dim):
                    Q[i, j] += alpha * mp.exp(mp.mpc(0, 1) * (mu[j] - mu[i]) * x) / L
    return Q


def ccm_compression_diagonal(lam: float, N: int, k: int, sign: int = 1) -> sp.Expr:
    """The exact diagonal formula ``Q_{k k} = sign*mu_k + S/L``."""
    if k < -N or k > N:
        raise ValueError("k must lie in [-N, N]")
    L = 2 * sp.log(lam)
    mu = 2 * sp.pi / L * (sp.Integer(k) + sp.Rational(1, 2))
    return sign * mu + prime_power_weight_sum(lam) / L


def uniform_matching_spectrum(L: float, theta: float, n: int, antiperiodic: bool = True):
    """Spectrum of the constant-matching first-order operator on a circle.

    ``theta = sum alpha_j`` is the total matching phase.  With periodic
    boundary conditions the condition is ``E L = theta + 2 pi n``; with
    antiperiodic conditions (the source's half-integer modes) it is
    ``E L = theta + (2n + 1) pi``.
    """
    L = mp.mpf(L)
    phase = theta + (2 * n + 1) * mp.pi if antiperiodic else theta + 2 * mp.pi * n
    return phase / L
