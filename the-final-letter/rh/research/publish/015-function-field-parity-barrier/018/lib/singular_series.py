"""018/lib/singular_series.py — the twin-qrime singular series, computed stably.

    S(q) = prod_P (1 - 2/N(P)) / (1 - 1/N(P))^2
         = prod_P (1 - 1/(N(P)-1)^2)
         = prod_{d>=1} (1 - 1/(q^d - 1)^2)^{I(d)} .

The two expressions are algebraically identical, but the first one is
numerically catastrophic: for large `d`, `(1-2/Q)/(1-1/Q)^2` rounds to
`1 + eps` with `eps ~ 1e-16`, and `log` turns that into a spurious term of
sign either way; multiplied by `I(d) ~ q^d/d ~ 1e17` it corrupts the product.
(That is exactly what happened in round 2: `S(3)` came out as 0.461350 instead
of 0.396107.)

Here we use `1 - 1/(Q-1)^2` with `log1p`, or exact rationals, so the terms
vanish correctly as `d -> oo`.
"""
from fractions import Fraction

try:
    import mpmath as mp
except ImportError:  # pragma: no cover
    mp = None

import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from qrime import qrime_count_mobius  # noqa: E402


def local_factor(Q):
    """(1-2/Q)/(1-1/Q)^2 = 1 - 1/(Q-1)^2, evaluated stably for Q > 1."""
    return 1.0 - 1.0 / ((Q - 1.0) * (Q - 1.0))


def S_log(q, D=60):
    """log S(q) to double precision, using log1p for stability."""
    import math
    s = 0.0
    for d in range(1, D + 1):
        I = qrime_count_mobius(q, d)
        if not I:
            continue
        Q = float(q ** d) if d <= 60 else float('inf')
        if Q == float('inf'):
            break
        lf = 1.0 - 1.0 / ((Q - 1.0) * (Q - 1.0))
        if lf <= 0.0:          # Q = 2 only; not reached for odd q >= 3
            raise ValueError
        # log(1 - x) with x = 1/(Q-1)^2
        x = 1.0 / ((Q - 1.0) * (Q - 1.0))
        s += I * math.log1p(-x)
    return s


def S(q, D=60):
    """S(q) to double precision."""
    import math
    return math.exp(S_log(q, D))


def S_mp(q, D=80, dps=60):
    """S(q) at `dps` decimal digits with mpmath."""
    if mp is None:  # pragma: no cover
        raise RuntimeError("mpmath not available")
    with mp.workdps(dps):
        s = mp.mpf(0)
        for d in range(1, D + 1):
            I = qrime_count_mobius(q, d)
            if not I:
                continue
            Q = mp.mpf(q) ** d
            s += I * mp.log1p(-1 / ((Q - 1) ** 2))
        return mp.e ** s


def S_exact(q, D=6):
    """Exact rational truncation `prod_{d<=D} (1 - 1/(q^d-1)^2)^{I(d)}`.

    Only usable for small `D`: the exponent `I(d)` is already ~q^d/d, so the
    integers involved grow like `q^{d^2}`.  For larger `D` use `S_sym`, which
    keeps the logarithm symbolic and evaluates at high precision.
    """
    prod = Fraction(1)
    for d in range(1, D + 1):
        I = qrime_count_mobius(q, d)
        if not I:
            continue
        Q = q ** d
        lf = Fraction((Q - 1) ** 2 - 1, (Q - 1) ** 2)
        prod *= lf ** I
    return prod


def S_sym(q, D=40, digits=40):
    """Truncated product as `exp(sum I log(lf))`, evaluated to `digits` digits.

    `log` is kept symbolic so no astronomically large `Fraction` powers arise.
    """
    import sympy as sp
    expr = sp.Integer(0)
    for d in range(1, D + 1):
        I = qrime_count_mobius(q, d)
        if not I:
            continue
        Q = q ** d
        lf = sp.Rational((Q - 1) ** 2 - 1, (Q - 1) ** 2)
        expr += I * sp.log(lf)
    return sp.exp(expr).evalf(digits)


def tail_log_bound(q, D):
    """Upper bound for |log(tail)| = sum_{d>D} I(d)/(q^d-1)^2 (crude)."""
    # I(d) <= q^d/d, and (q^d-1)^2 >= (q^d/2)^2 = q^{2d}/4 for q^d >= 2
    # so sum <= 4 * sum_{d>D} 1/(d q^d) <= 4/(D q^D) * 1/(1-1/q)
    return 4.0 / (D * q ** D) / (1.0 - 1.0 / q)


def S_bounds(q, D=40):
    """(lower, upper) bounds for S(q) from the high-precision truncation."""
    up = float(S_mp(q, D))
    # small extra margin for double-precision round-off
    lo = up * (1.0 - tail_log_bound(q, D) - 1e-12)
    return lo, up
