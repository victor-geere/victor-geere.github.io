"""Abel regularization probe for the prime symbol.

S_eps(xi) = sum_n Lambda(n) n^{-1/2+i xi} e^{-eps n}.

The sums oscillate as eps -> 0 and do not converge to
-zeta'/zeta(1/2 - i xi).  The Dirichlet series has abscissa 1, so the
critical line is outside its Abel summability domain.
"""

from __future__ import annotations

import numpy as np

__all__ = ["prime_power_data", "abel_sum"]

_CACHE: dict[int, tuple[np.ndarray, np.ndarray]] = {}


def prime_power_data(x_max: int = 2_000_000) -> tuple[np.ndarray, np.ndarray]:
    if x_max in _CACHE:
        return _CACHE[x_max]
    sieve = np.ones(x_max + 1, dtype=bool)
    sieve[:2] = False
    for p in range(2, int(x_max**0.5) + 1):
        if sieve[p]:
            sieve[p * p:x_max + 1:p] = False
    primes = np.nonzero(sieve)[0]
    ns = []
    weights = []
    for p in primes:
        lp = np.log(p)
        n = int(p)
        w = lp / np.sqrt(n)
        while n <= x_max:
            ns.append(n)
            weights.append(w)
            n *= p
            w = lp / np.sqrt(n)
    out = (np.array(ns), np.array(weights))
    _CACHE[x_max] = out
    return out


def abel_sum(eps: float, xi: float, x_max: int = 2_000_000) -> complex:
    ns, weights = prime_power_data(x_max)
    fac = np.exp(-eps * ns)
    phase = np.exp(1j * xi * np.log(ns))
    return complex(np.sum(weights * fac * phase))


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for eps in (0.01, 0.001, 0.0001):
        print(eps, {xi: np.round(abel_sum(eps, xi), 4) for xi in (1.0, 2.0, 5.0)})
