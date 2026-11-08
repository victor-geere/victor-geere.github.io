"""Toy 2x2 Weil-block computations.

The block is [[S(0), S(c)], [S(c), S(0)]].  A symmetric 2x2 matrix of this
form is PSD exactly when |S(c)| <= S(0).  These are finite checks of the
closed form used by the Lean `OffLineBlock`.
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


def offline_block(c: float, sigma: float, delta: float, gamma: float) -> tuple[tuple[float, float], tuple[float, float]]:
    """The 2x2 block [[S(0), S(c)], [S(c), S(0)]]. -"""
    s0 = offline_quad(0.0, sigma, delta, gamma)
    sc = offline_quad(c, sigma, delta, gamma)
    return ((s0, sc), (sc, s0))


def is_psd_2x2(block: tuple[tuple[float, float], tuple[float, float]]) -> bool:
    """PSD test for a symmetric 2x2 matrix [[a,b],[b,d]]."""
    (a, b), (_, d) = block
    return a >= 0 and d >= 0 and a * d - b * b >= 0


def eigenvalues_2x2(block: tuple[tuple[float, float], tuple[float, float]]) -> tuple[float, float]:
    """Eigenvalues of a symmetric 2x2 matrix."""
    (a, b), (_, d) = block
    mid = (a + d) / 2
    rad = math.sqrt(((a - d) / 2) ** 2 + b * b)
    return (mid - rad, mid + rad)


def find_obstruction(sigma: float, delta: float, gamma: float,
                     c_values: list[float]) -> float | None:
    """First separation whose block is not PSD, or None."""
    if delta == 0:
        return None
    for c in c_values:
        if not is_psd_2x2(offline_block(c, sigma, delta, gamma)):
            return c
    return None


def obstruction_margin(c: float, sigma: float, delta: float, gamma: float) -> float:
    """S(0) - |S(c)|.  The block is PSD exactly when this is nonnegative."""
    return offline_quad(0.0, sigma, delta, gamma) - abs(offline_quad(c, sigma, delta, gamma))


def block_psd_criterion(c: float, sigma: float, delta: float, gamma: float) -> bool:
    """Finite check of the scalar criterion `|S(c)| <= S(0)`."""
    return is_psd_2x2(offline_block(c, sigma, delta, gamma)) == (obstruction_margin(
        c, sigma, delta, gamma) >= 0.0)


def perturbed_block_psd(a: float, b: float, B: float) -> bool:
    """Worst-case PSD test for `!![a, b; b, a]` perturbed by entries of size `B`.

    The diagonal can drop by `B` and the off-diagonal can grow by `B`, so the
    worst case is `!![a - B, |b| + B; |b| + B, a - B]`.
    """
    if B < 0:
        raise ValueError("B must be nonnegative")
    return abs(b) + B <= a - B
