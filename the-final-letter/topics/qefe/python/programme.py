"""Quantum–Egyptian functional equation — exact computation layer.

The archived v8 source defines, for an integral modular tensor category,

    m_i = D^2 / d_i^2            (the Egyptian denominators),
    Psi(s) = sum_i chi(m_i) m_i^{-s},

and claims a Riemann-zeta-type functional equation for ``Psi``.  This module
reconstructs the finite data of the two worked examples (Ising and SU(2)_4),
the Egyptian-fraction identity of Lemma 2.2, and the gamma/prefactor data of
the claimed functional equation.  All calculations are exact ``sympy``
computations; numerical evaluation is only used in tests that explicitly
state a tolerance.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi


# ---------------------------------------------------------------------------
# Egyptian denominators
# ---------------------------------------------------------------------------

def egyptian_denominators(D2: int, dsq: Sequence[int]) -> list[sp.Rational]:
    """Return the Egyptian denominators ``m_i = D2 / dsq_i`` exactly.

    Parameters
    ----------
    D2 : total quantum dimension squared (a positive integer)
    dsq : squared quantum dimensions ``d_i^2`` (positive integers summing to D2)

    Raises
    ------
    ValueError
        If ``D2`` is not positive, ``dsq`` is empty or non-positive, or the
        squared dimensions do not sum to ``D2``.  The last check is the
        integrality hypothesis ``sum_i d_i^2 = D^2``.
    """
    D2 = sp.Integer(D2)
    dsq = [sp.Integer(d) for d in dsq]
    if D2 <= 0:
        raise ValueError("D^2 must be positive")
    if not dsq:
        raise ValueError("at least one squared quantum dimension is required")
    if any(d <= 0 for d in dsq):
        raise ValueError("squared quantum dimensions must be positive")
    if sum(dsq) != D2:
        raise ValueError("squared quantum dimensions must sum to D^2")
    return [sp.Rational(D2, d) for d in dsq]


def egyptian_reciprocal_sums(D2: int, dsq: Sequence[int]) -> tuple[sp.Rational, sp.Rational]:
    """Return ``(sum_i 1/m_i, sum_{i != 0} 1/m_i)`` exactly.

    The second entry is Lemma 2.2 of the source:
    ``1 - 1/D^2`` when the unit object has ``d_0^2 = 1``.
    """
    m = egyptian_denominators(D2, dsq)
    total = sp.Add(*[sp.Rational(1, 1) / mi for mi in m])
    non_unit = total - 1 / m[0]
    return sp.simplify(total), sp.simplify(non_unit)


# ---------------------------------------------------------------------------
# The two worked examples of the source
# ---------------------------------------------------------------------------

def ising() -> dict:
    """The Ising MTC data of §6.1: objects 1, sigma, psi.

    ``d^2 = (1, 2, 1)``, ``D^2 = 4``, hence ``m = (4, 2, 4)``.
    The Galois signs are ``chi(4) = 1``, ``chi(2) = -1``.
    """
    D2 = sp.Integer(4)
    dsq = [sp.Integer(1), sp.Integer(2), sp.Integer(1)]
    chi = [sp.Integer(1), sp.Integer(-1), sp.Integer(1)]
    m = egyptian_denominators(D2, dsq)
    return {
        "name": "Ising",
        "D2": D2,
        "dsq": dsq,
        "m": m,
        "chi": chi,
        "a": sp.Integer(0),
        "epsilon": sp.Integer(1),
    }


def su2_4() -> dict:
    """The SU(2)_4 data of §6.2: objects labelled ``a = 1, ..., 5``.

    ``d^2 = (1, 3, 4, 3, 1)``, ``D^2 = 12``, hence ``m = (12, 4, 3, 4, 12)``.
    The Galois signs are ``chi = (1, -1, 1, -1, 1)``; the source takes
    parity ``a = 1`` and root number ``epsilon = 1``.
    """
    D2 = sp.Integer(12)
    dsq = [sp.Integer(1), sp.Integer(3), sp.Integer(4), sp.Integer(3), sp.Integer(1)]
    chi = [sp.Integer(1), sp.Integer(-1), sp.Integer(1), sp.Integer(-1), sp.Integer(1)]
    m = egyptian_denominators(D2, dsq)
    return {
        "name": "SU(2)_4",
        "D2": D2,
        "dsq": dsq,
        "m": m,
        "chi": chi,
        "a": sp.Integer(1),
        "epsilon": sp.Integer(1),
    }


# ---------------------------------------------------------------------------
# Categorical Dirichlet series
# ---------------------------------------------------------------------------

def categorical_psi(m: Iterable, chi: Iterable, s) -> sp.Expr:
    """The categorical Dirichlet series ``Psi(s) = sum_i chi_i m_i^{-s}``."""
    m = [sp.Integer(x) for x in m]
    chi = [sp.Integer(c) for c in chi]
    if len(m) != len(chi):
        raise ValueError("m and chi must have the same length")
    if not m:
        raise ValueError("at least one term is required")
    s = sp.sympify(s)
    return sp.simplify(sum(c * sp.Pow(mi, -s) for mi, c in zip(m, chi)))


def psi_of(data: dict, s) -> sp.Expr:
    """Categorical Dirichlet series of one of the example dictionaries."""
    return categorical_psi(data["m"], data["chi"], s)


# ---------------------------------------------------------------------------
# Gamma factor and the claimed functional equation
# ---------------------------------------------------------------------------

def gamma_ratio(a, s) -> sp.Expr:
    """The gamma-factor ratio ``Gamma((1-s+a)/2) / Gamma((s+a)/2)``."""
    a = sp.sympify(a)
    s = sp.sympify(s)
    return sp.gamma((1 - s + a) / 2) / sp.gamma((s + a) / 2)


def qefe_prefactor(D2, a, s) -> sp.Expr:
    """The full prefactor ``(D^2/pi)^(s-1/2) * gamma_ratio(a, s)``."""
    D2 = sp.sympify(D2)
    s = sp.sympify(s)
    return (D2 / PI) ** (s - sp.Rational(1, 2)) * gamma_ratio(a, s)


def qefe_rhs(data: dict, s, epsilon=None) -> sp.Expr:
    """Right-hand side of the claimed functional equation for real data.

    ``epsilon (D^2/pi)^(s-1/2) Gamma((1-s+a)/2)/Gamma((s+a)/2)
    * conjugate(Psi_sigma(1-s))``.
    The examples are self-conjugate under the displayed Galois action, so
    ``Psi_sigma = Psi``; for real ``s`` the conjugation acts trivially.
    """
    s = sp.sympify(s)
    if epsilon is None:
        epsilon = data["epsilon"]
    epsilon = sp.sympify(epsilon)
    return sp.simplify(
        epsilon
        * qefe_prefactor(data["D2"], data["a"], s)
        * sp.conjugate(psi_of(data, 1 - s))
    )


def functional_equation_residual(data: dict, s, epsilon=None) -> sp.Expr:
    """The exact residual ``Psi(s) - RHS(s)`` of the claimed equation."""
    return sp.simplify(psi_of(data, s) - qefe_rhs(data, s, epsilon))


def sign_product(data: dict) -> sp.Integer:
    """Product of the Galois signs, the source's Appendix A root number."""
    return sp.prod(data["chi"])
