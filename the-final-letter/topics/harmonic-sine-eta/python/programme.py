"""Harmonic sine and the eta function — exact computation layer.

The archived fragment defines the non-greedy harmonic sine and cosine series

    S_α(θ) = Σ (-1)^(n-1) n^(-α) sin(θ log n),
    C_α(θ) = Σ (-1)^(n-1) n^(-α) cos(θ log n),

and identifies them with the imaginary and real parts of the Dirichlet eta
function ``η(α + iθ)``.  This module implements the finite objects exactly
with sympy and adds mpmath only for the high-precision checks (the eta/zeta
factorisation and the critical-line zeros).

Nothing here proves convergence, analytic continuation, or the source's
uniqueness claim for ``α = 1/2``; those remain source claims / open items.
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi


def _check_alpha(alpha: sp.Expr) -> None:
    if alpha.is_positive is not True:
        raise ValueError("alpha must be positive")


def _check_index(n: int, minimum: int = 1) -> None:
    if not isinstance(n, int) or n < minimum:
        raise ValueError(f"index must be an integer >= {minimum}")


def weight(alpha: sp.Expr, n: int) -> sp.Expr:
    """The decaying weight ``n^(-alpha)`` for a series index ``n >= 1``."""
    _check_alpha(alpha)
    _check_index(n)
    return sp.Integer(n) ** (-alpha)


def eta_term(alpha: sp.Expr, n: int) -> sp.Expr:
    """The ``n``-th alternating eta/sine term ``(-1)^(n-1) n^(-alpha)``."""
    return (-1) ** (n - 1) * weight(alpha, n)


def eta_partial(alpha: sp.Expr, N: int) -> sp.Expr:
    """The finite alternating sum ``Σ_{n=1}^N (-1)^(n-1) n^(-alpha)``."""
    _check_alpha(alpha)
    _check_index(N)
    return sum(((-1) ** (n - 1)) * sp.Integer(n) ** (-alpha) for n in range(1, N + 1))


def harmonic_partial(alpha: sp.Expr, N: int) -> sp.Expr:
    """The positive sum ``H_N(alpha) = Σ_{n=1}^N n^(-alpha)``."""
    _check_alpha(alpha)
    _check_index(N)
    return sum(sp.Integer(n) ** (-alpha) for n in range(1, N + 1))


def eta_partial_even_exact(alpha: sp.Expr, N: int) -> sp.Expr:
    """The even truncation ``A_{2N}(alpha)``."""
    return eta_partial(alpha, 2 * N)


def even_factorisation_rhs(alpha: sp.Expr, N: int) -> sp.Expr:
    """The right-hand side ``H_{2N}(alpha) - 2^(1-alpha) H_N(alpha)``."""
    _check_alpha(alpha)
    _check_index(N)
    return (
        harmonic_partial(alpha, 2 * N)
        - 2 ** (1 - alpha) * harmonic_partial(alpha, N)
    )


def even_factorisation_holds(alpha: sp.Expr, N: int) -> bool:
    """Exact check of ``A_{2N} = H_{2N} - 2^(1-alpha) H_N``."""
    return sp.simplify(eta_partial_even_exact(alpha, N) - even_factorisation_rhs(alpha, N)) == 0


def complex_partial(alpha: sp.Expr, theta: sp.Expr, N: int) -> sp.Expr:
    """The finite complex eta sum ``Σ_{n=1}^N (-1)^(n-1) n^(-alpha+i theta)``."""
    _check_alpha(alpha)
    _check_index(N)
    return sum((-1) ** (n - 1) * sp.Integer(n) ** (-alpha + sp.I * theta) for n in range(1, N + 1))


def sine_partial(alpha: sp.Expr, theta: sp.Expr, N: int) -> sp.Expr:
    """The finite sine series ``S_α(θ)`` truncated at ``N``."""
    _check_alpha(alpha)
    _check_index(N)
    return sum(
        (-1) ** (n - 1) * sp.Integer(n) ** (-alpha) * sp.sin(theta * sp.log(n))
        for n in range(1, N + 1)
    )


def cosine_partial(alpha: sp.Expr, theta: sp.Expr, N: int) -> sp.Expr:
    """The finite cosine series ``C_α(θ)`` truncated at ``N``."""
    _check_alpha(alpha)
    _check_index(N)
    return sum(
        (-1) ** (n - 1) * sp.Integer(n) ** (-alpha) * sp.cos(theta * sp.log(n))
        for n in range(1, N + 1)
    )


def eta_via_zeta(s: sp.Expr) -> sp.Expr:
    """The classical factorisation ``η(s) = (1 - 2^(1-s)) ζ(s)``.

    This is the *analytic-continuation* identity.  It is used only as a
    numerical cross-check for ``Re(s) > 1`` and on the critical line, never
    as a proved theorem of this reconstruction.
    """
    return sp.simplify((1 - 2 ** (1 - s)) * sp.zeta(s))


def greedy_condition_values(alpha: sp.Expr, theta: sp.Expr, N_max: int) -> list[float]:
    """The source's greedy condition ``Re(conj(S_{N-1}) w_N) <= 0`` for ``N = 1..N_max``.

    The values are evaluated numerically to 40 digits.  The condition holds
    for a given ``N`` exactly when the corresponding value is non-positive.
    """
    _check_alpha(alpha)
    _check_index(N_max)
    S = sp.Integer(0)
    out: list[float] = []
    for n in range(1, N_max + 1):
        w = sp.Integer(n) ** (-alpha) * sp.exp(sp.I * theta * sp.log(n))
        val = sp.re(sp.conjugate(S) * w)
        out.append(float(sp.N(val, 40)))
        S = S + w
    return out


def greedy_condition_holds(alpha: sp.Expr, theta: sp.Expr, N_max: int, tol: float = 1e-25) -> bool:
    """Whether the greedy condition holds for every ``N <= N_max``."""
    return all(v <= tol for v in greedy_condition_values(alpha, theta, N_max))


def eta_zero_residual(gamma) -> float:
    """``|η(1/2 + i gamma)|`` at high precision (numerical check only)."""
    import mpmath as mp

    mp.mp.dps = 50
    s = mp.mpc(mp.mpf(1) / 2, gamma)
    return float(abs(mp.altzeta(s)))


def first_critical_zero():
    """The imaginary part of the first non-trivial zeta zero, at 50 digits."""
    import mpmath as mp

    mp.mp.dps = 50
    return mp.zetazero(1).imag


def alternating_harmonic_partial(N: int) -> float:
    """The partial sum ``Σ_{n=1}^N (-1)^(n-1)/n`` as a float."""
    _check_index(N)
    return float(sp.N(sp.simplify(sum((-1) ** (n - 1) * sp.Rational(1, n) for n in range(1, N + 1))), 30))
