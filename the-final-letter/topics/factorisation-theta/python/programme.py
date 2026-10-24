"""Factorisation and theta — exact computation layer.

The archived essay defines the divisor detector

    f_k(x) = cos(2πk/x) + cos(2πx) - 2

and the (signed) divisor theta sum

    s_k(t) = Σ_{d | k, d ∈ ℤ} exp(-π d² t).

This module works with both objects exactly in sympy.  It does **not**
claim the infinite theta functional equation or any zeta/RH statement:
those are source claims recorded in the programme dossier.
"""

from __future__ import annotations


import sympy as sp

PI = sp.pi


def _check_positive_integer(name: str, value: int) -> int:
    if isinstance(value, bool) or not isinstance(value, int):
        raise TypeError(f"{name} must be an integer")
    if value <= 0:
        raise ValueError(f"{name} must be positive")
    return value


def divisor_detector(k: int, x: sp.Expr | int | sp.Rational) -> sp.Expr:
    """Return the exact expression `cos(2πk/x) + cos(2πx) - 2`.

    `x = 0` is outside the source's domain and raises ``ValueError``.
    """
    _check_positive_integer("k", k)
    xs = sp.sympify(x)
    if xs == 0:
        raise ValueError("x = 0 is outside the domain of the divisor detector")
    return sp.cos(2 * PI * sp.Integer(k) / xs) + sp.cos(2 * PI * xs) - 2


def positive_divisors(k: int) -> list[int]:
    """The positive divisors of `k`, in increasing order."""
    _check_positive_integer("k", k)
    return [int(d) for d in sp.divisors(k)]


def integer_divisors(k: int) -> list[int]:
    """All integer divisors of `k`, negative and positive, in increasing order."""
    pos = positive_divisors(k)
    return sorted([-d for d in pos] + pos)


def _detector_derivative(k: int, x: sp.Expr | int, order: int) -> sp.Expr:
    xs = sp.sympify(x)
    if xs.is_number:
        var = sp.Symbol("x", real=True)
        expr = sp.diff(divisor_detector(k, var), var, order)
        return sp.simplify(expr.subs(var, xs))
    return sp.diff(divisor_detector(k, xs), xs, order)


def detector_derivative(k: int, x: sp.Expr | int) -> sp.Expr:
    """The exact first derivative of `f_k` with respect to `x`."""
    return _detector_derivative(k, x, 1)


def detector_second_derivative(k: int, x: sp.Expr | int) -> sp.Expr:
    """The exact second derivative of `f_k` with respect to `x`."""
    return _detector_derivative(k, x, 2)


def double_zero_certificate(k: int, d: int) -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    """Return `(f(d), f'(d), f''(d))` for a divisor `d` of `k`.

    The essay claims that every divisor is a double zero.  The third entry
    is the certificate that the multiplicity is exactly two (it is non-zero
    for every divisor `d ≠ 0`).
    """
    _check_positive_integer("k", k)
    if d == 0 or k % d != 0:
        raise ValueError("d must be a non-zero divisor of k")
    return (
        sp.simplify(divisor_detector(k, d)),
        sp.simplify(detector_derivative(k, d)),
        sp.simplify(detector_second_derivative(k, d)),
    )


def expected_second_derivative(k: int, d: int) -> sp.Expr:
    """The closed form `-4π² ((k/d)² / d² + 1)` of `f''(d)`."""
    _check_positive_integer("k", k)
    if d == 0 or k % d != 0:
        raise ValueError("d must be a non-zero divisor of k")
    m = sp.Integer(k) / sp.Integer(d)
    return -4 * PI**2 * (m**2 / sp.Integer(d) ** 2 + 1)


def divisor_theta(k: int, t: sp.Expr | int | sp.Rational) -> sp.Expr:
    """The signed divisor theta sum `Σ_{d|k, d ∈ ℤ} exp(-π d² t)`."""
    _check_positive_integer("k", k)
    ts = sp.sympify(t)
    return sp.simplify(sum(sp.exp(-PI * sp.Integer(d) ** 2 * ts) for d in integer_divisors(k)))


def divisor_theta_positive_side(k: int, t: sp.Expr | int | sp.Rational) -> sp.Expr:
    """Twice the sum over positive divisors, the essay's simplified form `s(t)`."""
    _check_positive_integer("k", k)
    ts = sp.sympify(t)
    return sp.simplify(
        2 * sum(sp.exp(-PI * sp.Integer(d) ** 2 * ts) for d in positive_divisors(k))
    )


def finite_theta(N: int, t: sp.Expr | int | sp.Rational) -> sp.Expr:
    """The symmetric finite theta sum `Σ_{n=-N}^{N} exp(-π n² t)`."""
    if isinstance(N, bool) or not isinstance(N, int):
        raise TypeError("N must be an integer")
    if N < 0:
        raise ValueError("N must be non-negative")
    ts = sp.sympify(t)
    return sp.simplify(sum(sp.exp(-PI * sp.Integer(n) ** 2 * ts) for n in range(-N, N + 1)))


def functional_equation_residual(
    t: sp.Expr | int | sp.Rational, N: int, dps: int = 50
) -> sp.Expr:
    """Numerical residual of `θ(1/t) = sqrt(t) θ(t)` for the truncation `N`.

    The infinite identity is a classical theorem and a source claim here;
    this routine only reports the truncation error at the stated precision.
    """
    ts = sp.sympify(t)
    if not (ts.is_positive is True or (ts.is_number and float(ts) > 0)):
        raise ValueError("t must be positive")
    lhs = finite_theta(N, 1 / ts)
    rhs = sp.sqrt(ts) * finite_theta(N, ts)
    return sp.N(lhs - rhs, dps)


def detector_sign_on_integers(k: int, x_max: int) -> dict[int, bool]:
    """Classify integer inputs `1 ≤ x ≤ x_max` by whether the detector vanishes."""
    _check_positive_integer("k", k)
    if x_max < 1:
        raise ValueError("x_max must be at least 1")
    out: dict[int, bool] = {}
    for x in range(1, x_max + 1):
        out[x] = sp.simplify(divisor_detector(k, x)) == 0
    return out
