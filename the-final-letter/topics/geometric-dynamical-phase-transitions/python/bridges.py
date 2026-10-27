"""Exact gap-bridge computations for the geometric DQPT programme.

These functions mirror the new Lean file ``lean/Bridges.lean``:

* the last-chord size and its twin product;
* the self-dual abscissa;
* the clock zeros of ``1 - N^(1-s)``;
* the prefactor lower bound;
* the corrected local diagonal of Lemma 6.3.

Everything is exact sympy where possible; the prefactor inequality is checked
with high-precision mpmath because it is an inequality between moduli.
"""

from __future__ import annotations

import mpmath as mp
import sympy as sp

PI = sp.pi


def _check_N(N: int) -> None:
    if not isinstance(N, int) or isinstance(N, bool):
        raise TypeError("N must be an integer")
    if N < 2:
        raise ValueError("N must satisfy N >= 2")


def last_chord_abs(N: int, sigma: sp.Expr) -> sp.Expr:
    """The absolute last-chord size ``(N-1)/2 * N^(-2 sigma)``."""
    _check_N(N)
    s = sp.sympify(sigma)
    return sp.Rational(N - 1, 2) * sp.Integer(N) ** (-2 * s)


def last_chord_product(N: int) -> sp.Expr:
    """The exact twin product ``(N-1)^2 / (4 N^2)``."""
    _check_N(N)
    return sp.Rational((N - 1) ** 2, 4 * N**2)


def last_chord_twin_difference(N: int, sigma: sp.Expr) -> sp.Expr:
    """``L(sigma) - L(1-sigma)`` for the absolute last chord."""
    _check_N(N)
    s = sp.sympify(sigma)
    return sp.simplify(last_chord_abs(N, s) - last_chord_abs(N, 1 - s))


def self_dual_abscissa(N: int) -> list[sp.Expr]:
    """Solve ``L(sigma) = L(1-sigma)`` exactly.

    For ``N >= 2`` the unique solution is ``sigma = 1/2``.
    """
    _check_N(N)
    sigma = sp.symbols("sigma", real=True)
    return sp.solve(sp.Eq(last_chord_abs(N, sigma), last_chord_abs(N, 1 - sigma)), sigma)


def clock_zero(N: int, k: int) -> sp.Expr:
    """The clock zero ``s_k = 1 - 2 pi i k / log N``."""
    _check_N(N)
    if not isinstance(k, int) or isinstance(k, bool):
        raise TypeError("k must be an integer")
    return sp.Integer(1) - 2 * sp.I * sp.Integer(k) * PI / sp.log(N)


def clock_zero_residual(N: int, k: int) -> sp.Expr:
    """Evaluate ``N^(1-s_k) - 1`` exactly for a clock zero."""
    s = clock_zero(N, k)
    return sp.simplify(sp.exp((1 - s) * sp.log(N)) - 1)


def clock_zero_is_zero(N: int, k: int) -> bool:
    """Exact test of the clock-zero identity."""
    return sp.simplify(clock_zero_residual(N, k)) == 0


def prefactor(N: int, sigma: float, t: float) -> float:
    """High-precision ``|1 - N^(1-sigma-it)|``."""
    _check_N(N)
    s = mp.mpc(sigma, -t)
    return float(abs(1 - mp.power(N, 1 - s)))


def prefactor_lower_bound_holds(N: int, sigma: float, t: float, tol: float = 1e-10) -> bool:
    """Check ``N^(1-sigma) - 1 <= |1 - N^(1-sigma-it)|``."""
    _check_N(N)
    rhs = prefactor(N, sigma, t)
    lhs = float(mp.power(N, 1 - sigma) - 1)
    return lhs <= rhs + tol


def local_diagonal_integral(f: sp.Expr, R: sp.Expr) -> sp.Expr:
    """Compute ``∫_{-1}^{1} (1 - R f(u))(-f(u)) du`` exactly.

    ``f`` must be a sympy expression in the single symbol ``u``.
    """
    u = sp.symbols("u", real=True)
    expr = sp.sympify(f)
    if expr.free_symbols - {u}:
        raise ValueError("f must depend only on u")
    return sp.integrate((1 - R * expr) * (-expr), (u, -1, 1))


def local_diagonal_normalized(f: sp.Expr, R: sp.Expr) -> sp.Expr:
    """The normalized form ``-1 + R ∫ f^2`` when ``∫ f = 1``."""
    u = sp.symbols("u", real=True)
    expr = sp.sympify(f)
    norm = sp.integrate(expr, (u, -1, 1))
    if sp.simplify(norm - 1) != 0:
        raise ValueError("f must be normalized: ∫_{-1}^{1} f = 1")
    return sp.simplify(-1 + R * sp.integrate(expr**2, (u, -1, 1)))


def register_coefficient_at_multiple(N: int) -> int:
    """The filter coefficient at ``m = N``: ``1 - N``, negative for ``N >= 2``.

    This is the coefficient-level obstruction to a register-only ferromagnetic
    representation (Remark F.12): the register weights themselves change sign.
    """
    _check_N(N)
    return 1 - N


def eta_coefficients(N: int) -> list[int]:
    """The coefficient word ``c_1, ..., c_{N^2}`` of ``eta_N^(N^2)``."""
    _check_N(N)
    return [1 - N if m % N == 0 else 1 for m in range(1, N * N + 1)]


def heat_flowed_polygon(N: int, tau: sp.Expr, s: sp.Expr) -> sp.Expr:
    """The heat-flowed register polynomial of Remark F.13(c).

    ``sum_{m <= N^2} c_m exp(tau (log m)^2) m^(-s)``.
    At ``tau = 0`` this is exactly ``eta_N^(N^2)(s)``.
    """
    _check_N(N)
    tau = sp.sympify(tau)
    s = sp.sympify(s)
    total = sp.Integer(0)
    for m, c in enumerate(eta_coefficients(N), start=1):
        total += c * sp.exp(tau * sp.log(m) ** 2) * sp.Pow(m, -s)
    return sp.simplify(total)


def heat_flow_reduces_to_polygon(N: int, s: sp.Expr) -> bool:
    """Exact check that the ``tau = 0`` heat flow is the polygon."""
    _check_N(N)
    s = sp.sympify(s)
    poly = sum(c * sp.Pow(m, -s) for m, c in enumerate(eta_coefficients(N), start=1))
    return sp.simplify(heat_flowed_polygon(N, 0, s) - poly) == 0


def dh_xi() -> sp.Expr:
    """The Davenport–Heilbronn constant
    ``xi = (sqrt(10 + 2 sqrt 5) - 1 - sqrt 5)/2``.
    """
    return (sp.sqrt(10 + 2 * sp.sqrt(5)) - 1 - sp.sqrt(5)) / 2


def dh_coeffs() -> list[sp.Expr]:
    """The period-five Davenport–Heilbronn word ``(1, xi, -xi, -1, 0)``."""
    xi = dh_xi()
    return [sp.Integer(1), xi, -xi, sp.Integer(-1), sp.Integer(0)]


def dh_is_odd() -> bool:
    """Check ``a_{5-r} = -a_r`` for the one-based word."""
    a = dh_coeffs()
    return all(sp.simplify(a[5 - r - 1] + a[r - 1]) == 0 for r in range(1, 5)) and a[4] == 0


def dh_mean_zero() -> bool:
    return sp.simplify(sum(dh_coeffs(), sp.Integer(0))) == 0


def last_chord_complex(N: int, s: sp.Expr) -> sp.Expr:
    """The complex last chord ``H_N(s) = (1-N)/2 * N^(-2s)``."""
    _check_N(N)
    ss = sp.sympify(s)
    return sp.Rational(1 - N, 2) * sp.Integer(N) ** (-2 * ss)


def last_chord_complex_product(N: int, s: sp.Expr) -> sp.Expr:
    """Check ``H_N(s) H_N(1-s) = (N-1)^2/(4N^2)`` symbolically."""
    _check_N(N)
    ss = sp.sympify(s)
    lhs = last_chord_complex(N, ss) * last_chord_complex(N, 1 - ss)
    return sp.simplify(lhs - last_chord_product(N))


def last_chord_ratio(N: int, sigma: sp.Expr) -> sp.Expr:
    """The exact ratio ``L_N(σ) / N^(1-2σ)``."""
    _check_N(N)
    s = sp.sympify(sigma)
    return sp.simplify(last_chord_abs(N, s) / sp.Integer(N) ** (1 - 2 * s))


def heat_flow_derivative(N: int, s: sp.Expr) -> sp.Expr:
    """The first heat-flow derivative at `τ = 0`:
    ``Σ c_m (log m)^2 m^(-s)``.
    """
    _check_N(N)
    ss = sp.sympify(s)
    return sp.simplify(
        sum(c * sp.log(m) ** 2 * sp.Pow(m, -ss) for m, c in enumerate(eta_coefficients(N), start=1))
    )
