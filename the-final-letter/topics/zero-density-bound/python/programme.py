"""Toy zero-density and off-line block computations.

The closed form `offline_quad` is the Lean `offLineQuad` real part.  The
tail bound sums the on-line zero weights over a finite list of ordinates
and multiplies by the Gram weight, giving a finite model for `B`.
"""

from __future__ import annotations

import math

PI = math.pi


def offline_quad(c: float, sigma: float, delta: float, gamma: float) -> float:
    """S(c) = 2A(e^{cδ}cos(cγ+θ) + e^{-cδ}cos(cγ-θ))."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    a = 2 * PI * sigma ** 2 * math.exp(sigma ** 2 * (delta ** 2 - gamma ** 2))
    theta = 2 * sigma ** 2 * delta * gamma
    return 2 * a * (math.exp(c * delta) * math.cos(c * gamma + theta)
                    + math.exp(-c * delta) * math.cos(c * gamma - theta))


def tail_entry_bound(sigma: float, zeros: list[float]) -> float:
    """B = Σ_γ 2πσ² exp(-σ²γ²) over a finite on-line zero list."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return sum(2 * PI * sigma ** 2 * math.exp(-(sigma ** 2) * g * g) for g in zeros)


def domination_gap(c: float, sigma: float, delta: float, gamma: float, B: float) -> float:
    """S(0) - S(c) + 2B; negative means the domination hypothesis holds."""
    return offline_quad(0.0, sigma, delta, gamma) - offline_quad(c, sigma, delta, gamma) + 2 * B


def full_block_within(t: tuple[float, float, float, float], s0: float, sc: float, B: float) -> bool:
    """The finite check of `FullBlockWithin t00 t01 t10 t11 s0 sc B`."""
    if B < 0:
        raise ValueError("B must be non-negative")
    t00, t01, t10, t11 = t
    return (abs(t00 - s0) <= B and abs(t01 - sc) <= B
            and abs(t10 - sc) <= B and abs(t11 - s0) <= B)


def gram_weight(sigma: float, gamma: float) -> float:
    """The on-line Gram weight 2πσ² exp(-σ²γ²)."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return 2 * PI * sigma ** 2 * math.exp(-(sigma ** 2) * gamma ** 2)


def tail_entry_bound_holds(u00: float, u01: float, u10: float, u11: float, B: float) -> bool:
    """The finite check of `TailEntryBound u00 u01 u10 u11 B`."""
    if B < 0:
        raise ValueError("B must be non-negative")
    return all(abs(u) <= B for u in (u00, u01, u10, u11))


def diag_block(a: float, b: float) -> tuple[tuple[float, float], tuple[float, float]]:
    """The symmetric diagonal block [[a, b], [b, a]]."""
    return ((a, b), (b, a))


def diag_block_psd_by_eigenvalues(a: float, b: float) -> bool:
    """PSD for [[a, b], [b, a]]: both eigenvalues a - |b| and a + |b| nonnegative."""
    lo = a - abs(b)
    hi = a + abs(b)
    return lo >= 0 and hi >= 0


def diag_block_psd_criterion(a: float, b: float) -> bool:
    """The scalar criterion |b| <= a of `twoByTwo_diag_posSemidef_iff`."""
    return abs(b) <= a


def gaussian_zero_mass_outside(sigma: float, zeros: list[float], R: float) -> float:
    """The Gaussian mass of zeros with |gamma| >= R.

    This is the finite model for
    `tendsto_gaussian_zero_mass_outside_radius`: as R grows, the mass falls to 0.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if R < 0:
        raise ValueError("R must be non-negative")
    return sum(2 * PI * sigma ** 2 * math.exp(-(sigma ** 2) * g * g)
               for g in zeros if abs(g) >= R)


def online_gram_matrix(
    a: list[float], weights: list[float], gammas: list[float]
) -> list[list[float]]:
    """Finite on-line Gram matrix `sum_n w_n cos((a_i - a_j) gamma_n)`."""
    if len(weights) != len(gammas):
        raise ValueError("weights and gammas must have equal length")
    if any(w < 0 for w in weights):
        raise ValueError("weights must be nonnegative")
    n = len(a)
    return [
        [sum(w * math.cos((a[i] - a[j]) * g) for w, g in zip(weights, gammas)) for j in range(n)]
        for i in range(n)
    ]


def online_gram_quadratic_form(
    a: list[float], weights: list[float], gammas: list[float], x: list[float]
) -> float:
    """Quadratic form `x^T M x` of the finite on-line Gram matrix."""
    if len(x) != len(a):
        raise ValueError("x and a must have equal length")
    M = online_gram_matrix(a, weights, gammas)
    return sum(x[i] * x[j] * M[i][j] for i in range(len(a)) for j in range(len(a)))
