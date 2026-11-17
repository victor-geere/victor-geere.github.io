"""Computation layer for the digamma asymptotics / contour-shift programme.

* ``digamma_expansion_value`` — the Euler–Maclaurin truncation
  ``log w − 1/(2w) − 1/(12w²) + 1/(120w⁴)``;
* ``digamma_remainder`` — the difference from ``ψ(w)``;
* ``remainder_bound`` — the harvested bound ``1/(81 (Re w)^5)``;
* ``remainder_ratio`` — the ratio of the remainder to the bound.

Numerical work uses ``mpmath``; no side effects on import.
"""

from __future__ import annotations

import mpmath


def digamma_expansion_value(w: complex) -> complex:
    """``log w − 1/(2w) − 1/(12w²) + 1/(120w⁴)``."""
    z = mpmath.mpc(w)
    return mpmath.log(z) - 1 / (2 * z) - 1 / (12 * z**2) + 1 / (120 * z**4)


def digamma_remainder(w: complex) -> complex:
    """``ψ(w)`` minus the truncated expansion."""
    z = mpmath.mpc(w)
    return mpmath.digamma(z) - digamma_expansion_value(w)


def remainder_bound(w: complex) -> float:
    """The harvested bound ``1/(81 (Re w)^5)``."""
    re = mpmath.re(mpmath.mpc(w))
    if re <= 0:
        raise ValueError("Re w must be positive")
    return float(1 / (81 * re**5))


def remainder_ratio(w: complex) -> float:
    """``|remainder|`` divided by the bound (should be ≤ 1)."""
    return float(abs(digamma_remainder(w)) / remainder_bound(w))
