"""Geometric reformulation — exact computation layer.

This module reconstructs the finite, checkable parts of the archived paper
*A Geometric Framework for the Riemann Hypothesis: Twin Helices, the
Riemann Helix, and the CCM Spectral Triple*:

* the twin conical helices and their intersection polygon;
* the Frenet torsion of the unit helix and of a constant-radius helix;
* the prime-power weights of the geometric prime distribution;
* a finite Fourier truncation of the source's CCM quadratic form.

Everything is symbolic (sympy).  The module is importable without side
effects and contains no numerical tolerance unless a docstring says so.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi


# ---------------------------------------------------------------------------
# Space curves and torsion
# ---------------------------------------------------------------------------


def helix(omega: sp.Expr, t: sp.Symbol) -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    """The unit Riemann helix ``(cos(ω t), sin(ω t), t)``.

    The source writes the phase as an arbitrary increasing function
    ``φ(t)``; the closed-form torsion below is the constant-pitch case
    ``φ(t) = ω t``, which is the only case formalised in Lean.
    """
    return (sp.cos(omega * t), sp.sin(omega * t), t)


def scaled_helix(
    c: sp.Expr, omega: sp.Expr, t: sp.Symbol
) -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    """The constant-radius helix ``(c cos(ω t), c sin(ω t), t)``."""
    return (c * sp.cos(omega * t), c * sp.sin(omega * t), t)


def _cross(
    a: Sequence[sp.Expr], b: Sequence[sp.Expr]
) -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    return (
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    )


def frenet_torsion(
    curve: Sequence[sp.Expr], t: sp.Symbol
) -> sp.Expr:
    """Frenet–Serret torsion of a parametrised space curve.

    ``τ = ((r' × r'') · r''') / |r' × r''|²``.  Returns a simplified
    expression, or raises ``ValueError`` when the cross product vanishes.
    """
    if len(curve) != 3:
        raise ValueError("a space curve needs three components")
    r1 = [sp.diff(c, t) for c in curve]
    r2 = [sp.diff(c, t, 2) for c in curve]
    r3 = [sp.diff(c, t, 3) for c in curve]
    cross = _cross(r1, r2)
    numerator = sp.expand(
        cross[0] * r3[0] + cross[1] * r3[1] + cross[2] * r3[2]
    )
    denominator = sp.expand(
        cross[0] ** 2 + cross[1] ** 2 + cross[2] ** 2
    )
    if sp.simplify(denominator) == 0:
        raise ValueError("torsion is undefined: r' × r'' vanishes")
    return sp.simplify(numerator / denominator)


def helix_torsion(omega: sp.Expr) -> sp.Expr:
    """Closed-form torsion ``ω / (1 + ω²)`` of the unit helix."""
    return sp.simplify(omega / (1 + omega**2))


def scaled_helix_torsion(c: sp.Expr, omega: sp.Expr) -> sp.Expr:
    """Closed-form torsion ``ω / (1 + c² ω²)`` of the constant-radius helix."""
    return sp.simplify(omega / (1 + c**2 * omega**2))


def source_torsion_linear_phase(omega: sp.Expr) -> sp.Expr:
    """Equation (3.2) of the source evaluated at ``φ(t) = ω t``.

    The archived formula is

    ``φ' [φ'^4 − φ' φ''' + 3 φ''²] /
      ((φ'^2 + 1)(φ'^4 + φ''² + φ'^6))``.

    For linear phase this returns ``ω / (1 + ω²)²``, whereas the actual
    Frenet torsion is ``ω / (1 + ω²)``.  The routine exists so that the
    discrepancy is an explicit, testable computation rather than prose.
    """
    return sp.simplify(omega / (1 + omega**2) ** 2)


def verify_helix_torsion(omega: sp.Expr) -> bool:
    """Symbolically check the unit-helix torsion against its closed form."""
    t = sp.symbols("t", real=True)
    derived = frenet_torsion(helix(omega, t), t)
    return sp.simplify(derived - helix_torsion(omega)) == 0


def verify_scaled_helix_torsion(c: sp.Expr, omega: sp.Expr) -> bool:
    """Symbolically check the constant-radius torsion."""
    t = sp.symbols("t", real=True)
    derived = frenet_torsion(scaled_helix(c, omega, t), t)
    return sp.simplify(derived - scaled_helix_torsion(c, omega)) == 0


# ---------------------------------------------------------------------------
# Twin conical helices and the intersection polygon
# ---------------------------------------------------------------------------


def cone_radius(sigma: sp.Expr, t: sp.Expr, k: int) -> sp.Expr:
    """Radius ``x_k^{-σ}`` of the conical helix at ``x_k = exp(kπ/t)``.

    This is ``exp(−σ k π / t)``.  It is positive and strictly decreasing
    in ``k`` for ``σ, t > 0``, with ``k = 0`` giving radius ``1``.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if t <= 0:
        raise ValueError("t must be positive")
    if k < 0:
        raise ValueError("k must be non-negative")
    return sp.exp(-sigma * k * PI / t)


def intersection_abscissa(t: sp.Expr, k: int) -> sp.Expr:
    """The abscissa ``x_k = exp(kπ/t)`` where the twin helices meet."""
    if t <= 0:
        raise ValueError("t must be positive")
    if k < 0:
        raise ValueError("k must be non-negative")
    return sp.exp(k * PI / t)


def intersection_point(
    sigma: sp.Expr, t: sp.Expr, k: int
) -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    """The intersection point ``P_k = ((−1)^k x_k^{−σ}, 0, x_k)``."""
    x = intersection_abscissa(t, k)
    return ((-1) ** k * cone_radius(sigma, t, k), sp.Integer(0), x)


def cone_radius_ratio(sigma: sp.Expr, t: sp.Expr, k: int) -> sp.Expr:
    """Exact ratio ``r_{k+1} / r_k = exp(−σπ/t)``."""
    if k < 0:
        raise ValueError("k must be non-negative")
    return sp.simplify(cone_radius(sigma, t, k + 1) / cone_radius(sigma, t, k))


# ---------------------------------------------------------------------------
# Prime-power weights and the source's Möbius identity
# ---------------------------------------------------------------------------


def prime_weight(p: int, m: int) -> sp.Expr:
    """Weight ``log p / p^{m/2}`` of the atom ``m log p``.

    ``p`` must exceed ``1`` (the source sums over primes) and ``m ≥ 0``.
    At ``m = 0`` the weight is ``log p``.
    """
    if p <= 1:
        raise ValueError("p must be greater than 1")
    if m < 0:
        raise ValueError("m must be non-negative")
    return sp.log(p) / sp.Integer(p) ** sp.Rational(m, 2)


def prime_power_weights(
    primes: Iterable[int], max_power: int
) -> list[tuple[int, int, sp.Expr]]:
    """All atom weights ``(p, m, log p / p^{m/2})`` with ``0 ≤ m ≤ max_power``."""
    if max_power < 0:
        raise ValueError("max_power must be non-negative")
    out: list[tuple[int, int, sp.Expr]] = []
    for p in primes:
        for m in range(max_power + 1):
            out.append((p, m, prime_weight(p, m)))
    return out


def mobius_log_coefficient(k: int) -> sp.Expr:
    """Coefficient of ``p^{-k s}`` in ``Σ_n μ(n)/n log ζ(ns)``.

    Expanding ``log ζ(ns)`` and collecting ``k = m n`` gives
    ``(1/k) Σ_{d|k} μ(d)``, which is ``1`` for ``k = 1`` and ``0``
    otherwise.
    """
    if k < 1:
        raise ValueError("k must be positive")
    return sp.Rational(sum(int(sp.mobius(d)) for d in sp.divisors(k)), k)


def source_log_coefficient(k: int) -> sp.Expr:
    """Coefficient of ``p^{-k s}`` on the source's right-hand side.

    The source writes ``Σ_p log(1 − p^{-s})``, whose expansion has
    coefficient ``−1/k`` at every order ``k``.  This differs from the
    left-hand coefficient already at ``k = 1``; see the dossier.
    """
    if k < 1:
        raise ValueError("k must be positive")
    return -sp.Rational(1, k)


# ---------------------------------------------------------------------------
# Finite Fourier truncation of the CCM quadratic form
# ---------------------------------------------------------------------------


def ccm_fourier_matrix(
    xs: Sequence[sp.Expr],
    weights: Sequence[sp.Expr],
    L: sp.Expr,
    N: int,
) -> sp.Matrix:
    """Finite matrix ``Q_{kℓ}`` from the source's Fourier truncation.

    On ``L²(𝕋_L)`` the source uses the modes
    ``e_k(x) = exp(i μ_k x)`` with ``μ_k = (2π/L)(k + 1/2)`` and the
    formal operator ``D = i d/dx + Σ_j w_j δ(x − x_j)``.  With this
    normalisation

    ``Q_{kℓ} = −μ_ℓ δ_{kℓ} + (1/L) Σ_j w_j exp(i(μ_ℓ − μ_k) x_j)``.

    The routine builds the finite matrix for ``−N ≤ k, ℓ ≤ N``.  It is a
    model of the source's stated matrix elements, not the full CCM
    spectral triple: the matching phases ``α_{p,m}`` and the self-adjoint
    domain are not encoded here.
    """
    if L <= 0:
        raise ValueError("L must be positive")
    if N < 0:
        raise ValueError("N must be non-negative")
    if len(xs) != len(weights):
        raise ValueError("xs and weights must have the same length")
    modes = [2 * PI / L * (k + sp.Rational(1, 2)) for k in range(-N, N + 1)]
    size = 2 * N + 1
    Q = sp.zeros(size, size)
    for a, mu_k in enumerate(modes):
        for b, mu_l in enumerate(modes):
            derivative = -mu_l if a == b else sp.Integer(0)
            potential = sp.Integer(0)
            for x, w in zip(xs, weights):
                theta = (mu_l - mu_k) * x
                potential += w * (sp.cos(theta) + sp.I * sp.sin(theta))
            Q[a, b] = sp.simplify(derivative + potential / L)
    return Q
