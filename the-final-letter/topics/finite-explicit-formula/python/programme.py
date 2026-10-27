"""Fixed test function and the finite prime side of the explicit formula.

All arithmetic on the prime side uses ``mpmath.iv``; the test-function values
are exact rationals before the interval logarithm is applied.
"""

from fractions import Fraction

import mpmath as mp
from mpmath import iv

DPS = 40
iv.dps = DPS


def tent(x):
    """The tent function ``max(0, 1 - |x|)``."""
    ax = abs(x)
    return max(Fraction(0), Fraction(1) - ax)


def tent_autocorr(x):
    """The autocorrelation of the tent function, as a rational function of |x|."""
    ax = abs(x)
    if ax <= 1:
        return Fraction(1, 2) * ax**3 - ax**2 + Fraction(2, 3)
    if ax <= 2:
        return -Fraction(1, 6) * ax**3 + ax**2 - 2 * ax + Fraction(4, 3)
    return Fraction(0)


def is_prime_power(n):
    """Return ``(p, k)`` if ``n = p^k`` with ``k >= 1``, else ``None``."""
    for p in range(2, n + 1):
        if all(p % d for d in range(2, int(p**0.5) + 1)):
            k = 0
            m = n
            while m % p == 0:
                m //= p
                k += 1
            if m == 1:
                return p, k
    return None


def von_mangoldt(n):
    """``Lambda(n)`` as an exact ``mpf`` of ``log p`` when ``n`` is a prime power."""
    pp = is_prime_power(n)
    if pp is None:
        return None
    p, _ = pp
    return iv.log(mp.mpf(p))


def prime_side(T=2):
    """Certified interval enclosure of the finite prime side of the explicit formula.

    ``g`` is supported on ``[-2, 2]``, so with ``T = 2`` only prime powers
    ``n <= e^2`` contribute.  The value is

        - sum_n Lambda(n)/sqrt(n) * (g(log n) + g(-log n))

    for the standard normalization; ``g`` is even, so the two terms coincide.
    """
    if T != 2:
        raise ValueError("this dossier certifies the fixed support T = 2")
    ip = iv.mpf
    total = ip(0)
    terms = {}
    for n in range(2, 8):  # n <= e^2 < 8
        lam = von_mangoldt(n)
        if lam is None:
            continue
        ln = iv.log(mp.mpf(n))
        # g is a polynomial in |x| on [0, 2]; log n is positive, so |x| = x.
        g = (ln**3 / 2 - ln**2 + mp.mpf(2) / 3) if n <= 3 else (
            -ln**3 / 6 + ln**2 - 2 * ln + mp.mpf(4) / 3
        )
        term = -lam / iv.sqrt(mp.mpf(n)) * 2 * g
        terms[n] = term
        total += term
    return total, terms
