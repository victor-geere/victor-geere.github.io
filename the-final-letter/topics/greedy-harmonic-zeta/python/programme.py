"""Greedy harmonic zeta — exact computation layer.

The archived source studies the alternating partial sums of the Dirichlet
eta function

    S_N(s) = sum_{n=1}^N (-1)^(n-1) n^(-s),      w_N(s) = N^(-s),

and its "greedy condition" Re(conj(S_{N-1}) w_N) <= 0 for all N.

This module provides:

* exact sympy partial sums and the finite eta--zeta identity
  ``eta_N = Z_N - 2 * 2^(-sigma) * Z_{floor(N/2)}``;
* the exact value of the alternating partial sums at sigma = 0;
* high-precision (mpmath) checks of the source's greedy inequality,
  both in its raw form and with the alternating sign included.

The mpmath layer is only used because the greedy scan needs complex
powers at many indices; every identity used by the tests is checked in
sympy first.
"""

from __future__ import annotations

from typing import Optional

import mpmath as mp
import sympy as sp


def _nat(n: int, name: str = "n") -> int:
    if not isinstance(n, int) or isinstance(n, bool):
        raise TypeError(f"{name} must be an integer")
    if n < 0:
        raise ValueError(f"{name} must be non-negative")
    return n


def _positive_index(n: int) -> int:
    if not isinstance(n, int) or isinstance(n, bool):
        raise TypeError("n must be an integer")
    if n < 1:
        raise ValueError("n must be at least 1")
    return n


def term(sigma: sp.Expr, n: int) -> sp.Expr:
    """The magnitude ``n^(-sigma)`` (indexed from ``n = 1``)."""
    _positive_index(n)
    return sp.Integer(n) ** (-sp.sympify(sigma))


def zeta_partial(sigma: sp.Expr, N: int) -> sp.Expr:
    """Exact finite Dirichlet sum ``sum_{n=1}^N n^(-sigma)``."""
    _nat(N, "N")
    return sum((term(sigma, n) for n in range(1, N + 1)), sp.Integer(0))


def eta_partial(sigma: sp.Expr, N: int) -> sp.Expr:
    """Exact finite eta sum ``sum_{n=1}^N (-1)^(n-1) n^(-sigma)``."""
    _nat(N, "N")
    return sum(
        ((-1) ** (n - 1) * term(sigma, n) for n in range(1, N + 1)),
        sp.Integer(0),
    )


def eta_zeta_residual(sigma: sp.Expr, N: int) -> sp.Expr:
    """The exact residual of the finite eta--zeta identity.

    The identity is

        eta_N(sigma) = Z_N(sigma) - 2 * 2^(-sigma) * Z_{floor(N/2)}(sigma),

    the finite counterpart of ``eta(s) = (1 - 2^(1-s)) zeta(s)``.
    ``simplify`` returns ``0`` when the identity holds.
    """
    _nat(N, "N")
    s = sp.sympify(sigma)
    return sp.simplify(
        eta_partial(s, N)
        - (zeta_partial(s, N) - 2 * sp.Integer(2) ** (-s) * zeta_partial(s, N // 2))
    )


def eta_zero_finite(N: int) -> sp.Expr:
    """Exact alternating partial sum at ``sigma = 0``.

    This is ``0`` for even ``N`` and ``1`` for odd ``N``; the ordinary
    partial sums do not converge, so this is *not* a computation of
    ``eta(0) = 1/2``.
    """
    return eta_partial(sp.Integer(0), N)


def abel_eta_zero(r: sp.Expr) -> sp.Expr:
    """Abel-summed eta at ``sigma = 0``: ``sum_{n>=1} (-1)^(n-1) r^n``.

    The closed form is ``r / (1 + r)`` for ``|r| < 1``.  Its limit as
    ``r -> 1`` is the classical value ``eta(0) = 1/2``.
    """
    r = sp.sympify(r)
    return sp.simplify(r / (1 + r))


def abel_eta_zero_limit() -> sp.Expr:
    """The classical Abel value ``eta(0) = 1/2``."""
    r = sp.symbols("r", positive=True)
    return sp.limit(abel_eta_zero(r), r, 1, dir="-")


def _partial_complex(sigma: float, t: float, N: int, dps: int = 30) -> mp.mpc:
    """High-precision ``S_N(sigma + i t)`` with the alternating signs."""
    with mp.workdps(dps):
        s = mp.mpc(sigma, t)
        total = mp.mpc(0)
        for n in range(1, N + 1):
            total += (-1) ** (n - 1) * mp.e ** (-s * mp.log(n))
        return total


def greedy_correlation(sigma: float, t: float, N: int, dps: int = 30) -> mp.mpf:
    """``Re(conj(S_{N-1}) w_N)`` at ``s = sigma + i t``, ``N >= 1``."""
    if N < 1:
        raise ValueError("N must be at least 1")
    with mp.workdps(dps):
        S = _partial_complex(sigma, t, N - 1, dps)
        w = mp.e ** (-mp.mpc(sigma, t) * mp.log(N))
        return (mp.conj(S) * w).real


def first_greedy_violation(
    sigma: float,
    t: float,
    N_max: int = 500,
    dps: int = 30,
    signed: bool = False,
) -> Optional[tuple[int, mp.mpf]]:
    """First ``N`` in ``2..N_max`` violating the source's greedy condition.

    With ``signed=False`` the tested condition is the source's raw
    ``Re(conj(S_{N-1}) w_N) <= 0``.  With ``signed=True`` the alternating
    sign is included, i.e. the condition tested is
    ``(-1)^(N-1) * Re(conj(S_{N-1}) w_N) <= 0``, which is the condition
    for the alternating sign itself to be the greedy choice.

    Returns ``(N, correlation)`` for the first violation, or ``None``.
    """
    if N_max < 2:
        raise ValueError("N_max must be at least 2")
    if dps < 15:
        raise ValueError("dps must be at least 15")
    with mp.workdps(dps):
        s = mp.mpc(sigma, t)
        S = mp.mpc(0)
        for n in range(1, N_max + 1):
            w = mp.e ** (-s * mp.log(n))
            if n >= 2:
                c = (mp.conj(S) * w).real
                tested = ((-1) ** (n - 1)) * c if signed else c
                if tested > 0:
                    return n, c
            S += (-1) ** (n - 1) * w
    return None


def greedy_sign(sigma: float, t: float, N: int, dps: int = 30) -> int:
    """The sign ``+/-1`` that is greedy at step ``N`` (``+1`` on ties)."""
    c = greedy_correlation(sigma, t, N, dps)
    return 1 if c <= 0 else -1


def alternating_sign(N: int) -> int:
    """The sign of the ``N``-th eta term, ``(-1)^(N-1)``."""
    if N < 1:
        raise ValueError("N must be at least 1")
    return (-1) ** (N - 1)
