"""Numerical probes for the linear Z'/Z growth programme.

Uses mpmath's complex zeta with a first derivative.  The samples are finite
sanity checks of the size of |Z'/Z| against 1 + |t|; they are not a proof of
a uniform bound.
"""

from __future__ import annotations

import mpmath as mp

mp.mp.dps = 30


def zeta_log_derivative(s: complex) -> complex:
    """(ζ'/ζ)(s) for s away from the pole and the zeros."""
    z = mp.mpc(s.real, s.imag)
    return mp.zeta(z, derivative=1) / mp.zeta(z)


def linear_ratio(sigma: float, t: float) -> float:
    """|Z'/Z(σ+it)| / (1+|t|).  (Z and ζ share the same log derivative up to
    the archimedean factor; this probe uses ζ'/ζ.)"""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    value = zeta_log_derivative(complex(sigma, t))
    return abs(value) / (1.0 + abs(t))


def max_ratio(sigma: float, ts: list[float]) -> float:
    """Maximum of `linear_ratio` over a finite list of heights."""
    if not ts:
        raise ValueError("need at least one height")
    return max(linear_ratio(sigma, t) for t in ts)


def sample_heights(start: float = 10.0, stop: float = 60.0, step: float = 5.0) -> list[float]:
    """A small grid of heights, avoiding the first tabulated zero ordinates."""
    out = []
    t = start
    while t <= stop:
        if all(abs(t - z) > 0.5 for z in (14.1347, 21.0220, 25.0109, 30.4249, 32.9351,
                                          37.5862, 40.9187, 43.3271, 48.0052, 49.7738)):
            out.append(t)
        t += step
    return out


def polynomial_majorant_ratio(k: int, y: float) -> float:
    """The ratio (1+|y|)^k / (2^(k-1) (1 + |y|^k)).

    The formal majorant uses `(1+|y|)^k ≤ 2^(k-1) (1 + |y|^k)`; this ratio is
    at most one for every `y` and every `k ≥ 1`.
    """
    if k < 0:
        raise ValueError("k must be non-negative")
    if k == 0:
        return 1.0
    numerator = (1.0 + abs(y)) ** k
    denominator = 2 ** (k - 1) * (1.0 + abs(y) ** k)
    return numerator / denominator


def gaussian_polynomial_moment(k: int, sigma: float) -> mp.mpf:
    """∫ |y|^k exp(-sigma^2 y^2 / 2) dy over the real line, by quadrature."""
    if k < 0:
        raise ValueError("k must be non-negative")
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    b = sigma ** 2 / 2
    f = lambda y: abs(y) ** k * mp.exp(-b * y * y)  # noqa: E731
    return mp.quad(f, [-mp.inf, 0, mp.inf])


def polynomial_bound_holding(sigma: float, t: float, k: int, M: float) -> bool:
    """Finite check that `|Z'/Z| ≤ M (1+|t|)^k` at one sampled height."""
    if M < 0:
        raise ValueError("M must be non-negative")
    return abs(zeta_log_derivative(complex(sigma, t))) <= M * (1.0 + abs(t)) ** k
