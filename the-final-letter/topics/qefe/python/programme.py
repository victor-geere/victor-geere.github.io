"""Quantum–Egyptian functional equation — exact computation layer.

The archived v8 source defines, for an integral modular tensor category,

    m_i = D^2 / d_i^2            (the Egyptian denominators),
    Psi(s) = sum_i chi(m_i) m_i^{-s},

and claims a Riemann-zeta-type functional equation for ``Psi``.  That claim is
refuted in the dossier at the gamma poles of its right-hand side.  This module
reconstructs the finite data of the two worked examples (Ising and SU(2)_4),
the Egyptian-fraction identity of Lemma 2.2, the gamma/prefactor data of the
claimed equation, and the theta-normalisation and pole checks that establish
the failure.  All calculations are exact ``sympy`` computations; numerical
evaluation is only used in tests that explicitly state a tolerance.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi


# ---------------------------------------------------------------------------
# Egyptian denominators
# ---------------------------------------------------------------------------

def validate_quantum_dimension_data(
    D2: int,
    dsq: Sequence[int],
    unit: int | None = 0,
    require_integer_m: bool = False,
) -> tuple[sp.Integer, list[sp.Integer], list[sp.Rational]]:
    """Validate a finite quantum-dimension datum.

    This is the software check behind C1.  It verifies the hypotheses used by
    Lemma 2.2, not the axioms of a modular tensor category.

    Parameters
    ----------
    D2 : total quantum dimension squared (a positive integer)
    dsq : squared quantum dimensions ``d_i^2`` (positive integers summing to D2)
    unit : index of the unit object, whose squared dimension must be 1.
        Pass ``None`` only if the datum is not claiming a unit object.
    require_integer_m : if true, also require every ``D2 / dsq_i`` to be an
        integer.  This is an extra "integral Egyptian denominator" hypothesis,
        not a consequence of MTC integrality in general.

    Returns
    -------
    ``(D2, dsq, m)`` with ``m_i = D2 / dsq_i``.
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
    if unit is not None:
        if not (0 <= unit < len(dsq)):
            raise ValueError("unit index is out of range")
        if dsq[unit] != 1:
            raise ValueError("the unit object must have d_unit^2 = 1")
    m = [sp.Rational(D2, d) for d in dsq]
    if require_integer_m and any(mi.q != 1 for mi in m):
        raise ValueError("the Egyptian denominators must be integers")
    return D2, dsq, m


def egyptian_denominators(
    D2: int,
    dsq: Sequence[int],
    unit: int | None = 0,
    require_integer_m: bool = False,
) -> list[sp.Rational]:
    """Return the Egyptian denominators ``m_i = D2 / dsq_i`` exactly."""
    return validate_quantum_dimension_data(
        D2, dsq, unit=unit, require_integer_m=require_integer_m
    )[2]


def egyptian_reciprocal_sums(
    D2: int, dsq: Sequence[int], unit: int = 0
) -> tuple[sp.Rational, sp.Rational]:
    """Return ``(sum_i 1/m_i, sum_{i != unit} 1/m_i)`` exactly.

    The second entry is Lemma 2.2 of the source:
    ``1 - 1/D^2`` when the unit object has ``d_unit^2 = 1``.
    """
    m = egyptian_denominators(D2, dsq, unit=unit)
    total = sp.Add(*[sp.Rational(1, 1) / mi for mi in m])
    non_unit = total - 1 / m[unit]
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
    if any(mi <= 0 for mi in m):
        raise ValueError("Egyptian denominators must be positive")
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


# ---------------------------------------------------------------------------
# Theta normalisation and the gamma-pole obstruction
# ---------------------------------------------------------------------------

def theta_finite(data: dict, tau) -> sp.Expr:
    """The source's finite twisted theta, with the *corrected* exponent.

    The archived text prints ``exp(-pi (m_i/D)^2 tau)``, but its own Mellin
    formula requires the exponent ``m_i/D^2``.  This function uses the latter,
    which is the only choice consistent with
    ``I(s) = Gamma(s) pi^{-s} D^{2s} Psi(s)``.
    """
    tau = sp.sympify(tau)
    D2 = data["D2"]
    return sp.simplify(
        sum(c * sp.exp(-sp.pi * (mi / D2) * tau)
            for mi, c in zip(data["m"], data["chi"]))
    )


def mellin_finite(data: dict, s, printed_exponent: bool = False) -> sp.Expr:
    """Mellin transform of the finite twisted theta.

    With ``printed_exponent=True`` this uses the archived exponent
    ``(m_i/D)^2 = m_i^2/D^2``; with the default it uses the corrected
    ``m_i/D^2``.  The Mellin integral of ``sum chi_i exp(-pi a_i tau)`` is
    ``Gamma(s) pi^{-s} sum chi_i a_i^{-s}``.
    """
    s = sp.sympify(s)
    D2 = data["D2"]
    if printed_exponent:
        a = [sp.Rational(mi ** 2, D2) for mi in data["m"]]
    else:
        a = [sp.Rational(mi, D2) for mi in data["m"]]
    return sp.simplify(
        sp.gamma(s) * sp.pi ** (-s)
        * sum(c * ai ** (-s) for ai, c in zip(a, data["chi"]))
    )


def source_mellin_rhs(data: dict, s) -> sp.Expr:
    """The source's claimed value ``Gamma(s) pi^{-s} D^{2s} Psi(s)``."""
    s = sp.sympify(s)
    return sp.simplify(
        sp.gamma(s) * sp.pi ** (-s) * data["D2"] ** s * psi_of(data, s)
    )


def first_gamma_pole(data: dict) -> sp.Expr:
    """The first positive pole of ``Gamma((1-s+a)/2)``, namely ``s = 1 + a``."""
    return 1 + data["a"]


def finite_theta_modular_residual(data: dict, tau) -> sp.Expr:
    """Residual of the claimed weight-1/2 modular relation for ``theta_finite``.

    Computes ``Theta(1/tau) - tau^(1/2) Theta(tau)``.  A genuine modular theta
    would make this vanish identically; the finite exponential sum does not.
    """
    tau = sp.sympify(tau)
    return sp.simplify(
        theta_finite(data, 1 / tau) - sp.sqrt(tau) * theta_finite(data, tau)
    )


# ---------------------------------------------------------------------------
# SU(2)_k, Galois sign data, root numbers, and the square-lattice L-series
# ---------------------------------------------------------------------------

def su2k_data(k: int) -> dict:
    """The SU(2)_k quantum-dimension data, numerically.

    ``dsq[j] = d_j^2``, ``m[j] = D^2 / d_j^2``, and
    ``chi[j] = (-1)^j`` for the alternating sign convention.
    """
    import math
    N = k + 2
    den = math.sin(math.pi / N)
    dsq = [(math.sin(math.pi * (j + 1) / N) / den) ** 2 for j in range(k + 1)]
    D2 = sum(dsq)
    m = [D2 / d for d in dsq]
    chi = [(-1) ** j for j in range(k + 1)]
    return {"N": N, "D2": D2, "dsq": dsq, "m": m, "chi": chi}


def psi_su2k(k: int, s):
    """The alternating categorical polynomial ``sum (-1)^j m_j^{-s}``."""
    data = su2k_data(k)
    return sum(c * mi ** (-s) for c, mi in zip(data["chi"], data["m"]))


def half_spectrum_su2k(k: int, s, signed: bool = False):
    """The half-spectrum sum ``sum_{j<=k/2} (+/-1)^j d_j^{-2s}``."""
    data = su2k_data(k)
    return sum(((-1) ** j if signed else 1) * data["dsq"][j] ** (-s)
               for j in range(k // 2 + 1))


def lattice_z2_lambda(s):
    """Completed Epstein zeta of the square lattice.

    ``Lambda(s) = 4 pi^{-s} Gamma(s) zeta(s) beta(s)``, where
    ``beta`` is the Dirichlet beta function; ``sum r_2(n) n^{-s} = 4 zeta(s) beta(s)``.
    """
    import mpmath as mp
    s = mp.mpf(s)
    beta = mp.nsum(lambda n: (-1) ** n / (2 * n + 1) ** s, [0, mp.inf])
    return 4 * mp.pi ** (-s) * mp.gamma(s) * mp.zeta(s) * beta


def root_number(dsq, theta) -> complex:
    """The normalized Gauss root number ``W = D^{-1} sum d_i^2 theta_i``."""
    import cmath
    return sum(d * t for d, t in zip(dsq, theta)) / cmath.sqrt(sum(dsq))
