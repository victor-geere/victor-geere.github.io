"""sin-x-over-x — the greedy harmonic sine inside the sinc kernel.

The archived ``harmonic-sine`` programme reconstructs ``sin(pi*x)`` from
the harmonic angle steps ``eps_n = 1/(n + 2)`` (measured in units of
``pi``), selected greedily and fused by the angle-addition rule.  This
module asks what happens to the normalised sinc kernel

    sinc(x) = sin(pi*x) / (pi*x),    sinc(0) = 1,

when the ordinary sine is replaced by the finite greedy reconstruction
``S_N(x) = sin(pi * theta_N(x))``:

    sinc_N(x) = S_N(x) / (pi*x)  (x != 0),
    sinc_N(0) = 0               (the continuous extension at the origin).

All arguments are exact rationals.  The greedy selection is computed in
``Fraction`` arithmetic, so comparisons never round; only the final sine
and logarithm evaluations are numerical (mpmath).  The extension to
``R`` is the source's period-two, odd extension: reduce ``x`` modulo 2,
and reflect the branch ``1 < x < 2`` by ``S(2 - u) = -S(u)``.

The implementation deliberately does not assume the source's
reconstruction theorem ``S_N -> sin(pi*x)``.  That statement is a source
claim (it is tested numerically here, and recorded as open in the
programme dossier).  The finite-stage statements are unconditional.
"""

from __future__ import annotations

from fractions import Fraction
import mpmath as mp

__all__ = [
    "harmonic_step",
    "greedy_word",
    "greedy_theta",
    "theta_ext",
    "recon_sine",
    "recon_sinc",
    "sinc",
    "vanishing_radius",
    "error_bound",
    "greedy_breakpoints",
    "period_pieces",
    "integral_recon_sinc",
    "integral_sinc",
    "first_exact_steps",
    "euler_product_truncated",
]


def _frac(x: object) -> Fraction:
    """Coerce a rational input to ``Fraction`` without float rounding."""
    if isinstance(x, Fraction):
        return x
    if isinstance(x, int):
        return Fraction(x)
    if isinstance(x, str):
        return Fraction(x)
    raise TypeError(f"expected a rational (Fraction, int or str), got {type(x)!r}")


def harmonic_step(n: int) -> Fraction:
    """The harmonic step ``eps_n = 1 / (n + 2)`` in units of ``pi``."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return Fraction(1, n + 2)


def greedy_word(target: object, n_max: int) -> list[int]:
    """Greedy selection word of length ``n_max`` for ``target``.

    ``delta_n = 1`` exactly when ``eps_n`` is no larger than the current
    residual.  The target may be any non-negative rational; for the
    sinc programme it is used on ``[0, 1]``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    r = _frac(target)
    if r < 0:
        raise ValueError("target must be non-negative")
    word: list[int] = []
    for n in range(n_max):
        e = harmonic_step(n)
        take = e <= r
        word.append(1 if take else 0)
        if take:
            r -= e
    return word


def greedy_theta(target: object, n_max: int) -> Fraction:
    """The accumulated greedy angle ``theta_N`` in units of ``pi``."""
    r = _frac(target)
    if r < 0:
        raise ValueError("target must be non-negative")
    theta = Fraction(0)
    for n, delta in enumerate(greedy_word(r, n_max)):
        if delta:
            theta += harmonic_step(n)
    return theta


def theta_ext(target: object, n_max: int) -> Fraction:
    """``theta_N`` for the period-two odd extension of the reconstruction.

    On ``[0, 1]`` this is :func:`greedy_theta`.  On ``(1, 2)`` the branch
    is reflected using ``sin(pi*(2 - u)) = -sin(pi*u)``, so that the
    reconstructed sine is odd and 2-periodic in its argument.
    """
    x = _frac(target)
    t = x % 2  # Fraction modulo; result in [0, 2)
    if t <= 1:
        return greedy_theta(t, n_max)
    return 2 - greedy_theta(2 - t, n_max)


def recon_sine(target: object, n_max: int, dps: int = 40) -> mp.mpf:
    """The finite greedy harmonic sine ``S_N(x) = sin(pi * theta_N(x))``."""
    with mp.workdps(dps):
        th = theta_ext(target, n_max)
        if th.denominator == 1:
            # sin(pi * integer) = 0 exactly; avoid rounding noise.
            return mp.mpf(0)
        a = mp.mpf(th.numerator) / th.denominator
        return mp.sin(mp.pi * a)


def recon_sinc(target: object, n_max: int, dps: int = 40) -> mp.mpf:
    """``sinc_N(x) = S_N(x) / (pi*x)`` with the continuous value ``0`` at ``x=0``.

    ``S_N`` vanishes identically on ``|x| < 1/(N+1)``, so the continuous
    extension at the origin is ``0`` and not the sinc value ``1``.
    """
    x = _frac(target)
    if x == 0:
        return mp.mpf(0)
    with mp.workdps(dps):
        xr = mp.mpf(x.numerator) / x.denominator
        return recon_sine(x, n_max, dps) / (mp.pi * xr)


def sinc(target: object, dps: int = 40) -> mp.mpf:
    """The normalised sinc ``sin(pi*x)/(pi*x)`` with ``sinc(0) = 1``."""
    x = _frac(target)
    if x == 0:
        return mp.mpf(1)
    with mp.workdps(dps):
        xr = mp.mpf(x.numerator) / x.denominator
        return mp.sin(mp.pi * xr) / (mp.pi * xr)


def vanishing_radius(n_max: int) -> Fraction:
    """The radius ``1/(N+1)`` of the zero interval of ``sinc_N``."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return Fraction(1, n_max + 1)


def error_bound(target: object, n_max: int) -> mp.mpf:
    """The conditional pointwise bound ``1 / ((N+1) |x|)`` for ``x != 0``.

    It follows from the source's tested residual invariant
    ``|theta_N(x) - x| <= 1/(N+1)`` and the sine Lipschitz estimate.
    """
    x = abs(_frac(target))
    if x == 0:
        raise ValueError("the bound is stated for x != 0")
    return 1 / ((n_max + 1) * (mp.mpf(x.numerator) / x.denominator))


def greedy_breakpoints(n_max: int) -> list[Fraction]:
    """All breakpoints of ``theta_N`` on ``[0, 1]``, in increasing order."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    points: set[Fraction] = {Fraction(0), Fraction(1)}

    def rec(lo: Fraction, hi: Fraction, prefix: Fraction, n: int) -> None:
        if n == n_max:
            return
        e = harmonic_step(n)
        cut = prefix + e
        if cut <= lo:
            rec(lo, hi, prefix + e, n + 1)
        elif cut >= hi:
            rec(lo, hi, prefix, n + 1)
        else:
            points.add(cut)
            rec(lo, cut, prefix, n + 1)
            rec(cut, hi, prefix + e, n + 1)

    rec(Fraction(0), Fraction(1), Fraction(0), 0)
    return sorted(points)


def period_pieces(n_max: int, dps: int = 40) -> list[tuple[Fraction, Fraction, mp.mpf]]:
    """Pieces ``(a, b, S_N)`` of the reconstructed sine on one full period.

    The period in ``x`` is ``2``; the returned pieces cover ``[0, 2]``
    and omit the intervals where ``S_N`` is zero.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    points = greedy_breakpoints(n_max)
    pieces: list[tuple[Fraction, Fraction, mp.mpf]] = []
    with mp.workdps(dps):
        for a, b in zip(points, points[1:]):
            mid = (a + b) / 2
            value = recon_sine(mid, n_max, dps)
            if value != 0:
                pieces.append((a, b, value))
                pieces.append((2 - b, 2 - a, -value))
    pieces.sort()
    return pieces


def integral_recon_sinc(
    n_max: int, periods: int = 40, moment_order: int = 8, dps: int = 40
) -> mp.mpf:
    """Numerical ``integral_0^infinity sinc_N(x) dx``.

    The reconstructed sinc is ``S_N(x)/(pi*x)``, so the period integral
    below is divided by ``pi``.

    On each period ``S_N`` is a finite step function, so the integral over
    ``[2m, 2m+2]`` is a finite sum of logarithms.  The tail is summed
    from the moment expansion

        ``1/(y + 2m) = sum_k (-y)^k / (2m)^(k+1)``,

    using ``sum_{m>=M} m^(-p) = zeta(p) - sum_{m<M} m^(-p)``.  The first
    ``periods`` periods are integrated exactly (up to the logarithm
    evaluation); the remainder is the truncated moment expansion.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    if periods < 1:
        raise ValueError("periods must be at least 1")
    if moment_order < 1:
        raise ValueError("moment_order must be at least 1")
    pieces = period_pieces(n_max, dps)
    with mp.workdps(dps):
        total = mp.mpf(0)
        for m in range(periods):
            for a, b, value in pieces:
                aa = mp.mpf(a.numerator) / a.denominator
                bb = mp.mpf(b.numerator) / b.denominator
                total += value * mp.log((bb + 2 * m) / (aa + 2 * m))
        for k in range(1, moment_order + 1):
            moment = mp.mpf(0)
            for a, b, value in pieces:
                aa = mp.mpf(a.numerator) / a.denominator
                bb = mp.mpf(b.numerator) / b.denominator
                moment += value * (bb ** (k + 1) - aa ** (k + 1)) / (k + 1)
            p = k + 1
            tail = mp.zeta(p) - mp.nsum(lambda j: mp.mpf(j) ** (-p), [1, periods - 1])
            total += (-1) ** k * moment * tail / (2 ** p)
        return total / mp.pi


def integral_sinc(dps: int = 40) -> mp.mpf:
    """The classical value ``integral_0^infinity sinc(x) dx = 1/2``."""
    with mp.workdps(dps):
        return mp.mpf(1) / 2


def euler_product_truncated(target: object, n_max: int) -> Fraction:
    """The finite Euler product ``prod_{n=1}^{n_max} (1 - x^2/n^2)``.

    This is the standard truncation of Euler's product for
    ``sin(pi*x)/(pi*x)``.  It is returned exactly as a ``Fraction``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    x = _frac(target)
    product = Fraction(1)
    for n in range(1, n_max + 1):
        product *= 1 - Fraction(x * x, n * n)
    return product


def first_exact_steps(target: object, limit: int = 100_000) -> int:
    """The first ``N`` with ``theta_N(y) = y`` on the reduced branch.

    The greedy Egyptian expansion of a rational terminates, so this is
    finite for every rational input; the function is a search, not a
    proof, and raises ``ValueError`` if ``limit`` is exceeded.
    """
    if limit < 1:
        raise ValueError("limit must be positive")
    x = _frac(target)
    t = x % 2
    goal = t if t <= 1 else 2 - t
    for n_max in range(1, limit + 1):
        if greedy_theta(goal, n_max) == goal:
            return n_max
    raise ValueError(f"no exact stage within {limit} steps")
