"""Finite checks for the Riemann-Roch-square note.

The note ``notes/07-riemann-roch-square.md`` reduces Weil positivity to a
Hirzebruch-Riemann-Roch formula on the square of the complex lift of the
Scaling Site.  This module checks the three finite shadows:

* the curve-level dimension formula of Connes-Consani (2023);
* the local HRR formula on a complex torus (Proposition 1 of the note);
* the periodic-orbit local term of the explicit formula.
"""

from __future__ import annotations

import math

__all__ = [
    "odd_ceil",
    "rr_chi",
    "rr_dimension",
    "indicator_L",
    "torus_hrr",
    "periodic_local_term",
    "dimension_subadditive",
]


def odd_ceil(x: float) -> int:
    """The ceiling function extended oddly to the negative reals."""
    if x >= 0:
        return math.ceil(x)
    return -math.ceil(-x)


def indicator_L(a: float) -> int:
    """Characteristic function of the exceptional set L of the 2023 theorem.

    ``a ∈ L`` iff ``a + log 2 ∈ ⋃_k (k log 3, k log 3 + log(1+3^-k))``,
    equivalently ``a ∈ (log(3^k/2), log((3^k+1)/2))`` for some k ≥ 0.
    """
    if a < -math.log(2):
        return 0
    # Only k with 3^k/2 < e^a matter.  For large a the intervals are sparse;
    # check up to the first k with 3^k/2 >= e^a.
    k = 0
    while True:
        left = math.log(3 ** k / 2)
        right = math.log((3 ** k + 1) / 2)
        if left >= a:
            break
        if left < a < right:
            return 1
        k += 1
        if k > 200:
            break
    return 0


def rr_chi(a: float) -> int:
    """Riemann-Roch Euler characteristic of D = a{∞} (2023 theorem)."""
    return odd_ceil((a + math.log(2)) / math.log(3)) - indicator_L(a)


def rr_dimension(a: float) -> int:
    """dim H^0(D) for D = a{∞}: ceil(log(2 floor(e^a)+1)/log 3)."""
    if a < 0:
        return 0
    n = int(math.floor(math.exp(a)))
    return math.ceil(math.log(2 * n + 1) / math.log(3))


def dimension_subadditive(a: float, b: float) -> bool:
    """Check the castelnuovo-type subadditivity h0(D+E) <= h0(D)+h0(E)."""
    return rr_dimension(a + b) <= rr_dimension(a) + rr_dimension(b)


def torus_hrr(d_square: float) -> float:
    """Local HRR on a complex torus: χ = D²/2."""
    return d_square / 2.0


def periodic_local_term(f, p: int, order: int = 40) -> float:
    """Local p-term of the explicit formula.

    ``sum_{k>=1} (log p / p^{k/2}) (f(p^k) + f(p^-k))``.
    """
    total = 0.0
    log_p = math.log(p)
    for k in range(1, order + 1):
        weight = log_p / (p ** (k / 2.0))
        total += weight * (f(p ** k) + f(p ** (-k)))
    return total


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for a in (0.0, 1.0, 2.0, 3.0):
        print(f"a={a}: dim H0={rr_dimension(a)}, chi={rr_chi(a)}")
    for d2 in (0.0, 2.0, 4.0):
        print(f"D^2={d2}: chi={torus_hrr(d2)}")
    f = lambda x: math.exp(-x * x)
    for p in (2, 3, 5, 7):
        print(f"p={p}: local term={periodic_local_term(f, p):.12f}")
