"""QEFE research notes — exact finite computation layer.

This module adapts the finite Egyptian/fractional core of the QEFE
working notes, `archive/quantum-egyptian-functional-equation/
research-deepseek-8.md`.  It deliberately does **not** reconstruct the
general Quantum–Egyptian functional equation: the primary
reconstruction of Theorem 3.1 lives in the duplicate topic
`the-final-letter/topics/qefe/`.  What is implemented here is the part
the notes actually pin down exactly:

* Egyptian denominators ``m_i = D²/d_i²`` for a finite integral datum;
* the exact Egyptian sums of Lemma 2.2;
* the finite Dirichlet polynomial ``Ψ(s) = Σ χ(m_i) m_i^{-s}`` for the
  two worked examples (Ising and SU(2)₄);
* the two Mellin normalisations used in §2.4 and §5.3 of the source,
  so that their disagreement can be measured rather than asserted.

Everything is exact ``sympy`` arithmetic; ``mpmath`` is not needed.
"""

from __future__ import annotations

from dataclasses import dataclass

import sympy as sp

PI = sp.pi


@dataclass(frozen=True)
class Datum:
    """A finite integral MTC datum: squared dimensions and Galois signs."""

    name: str
    squared_dimensions: tuple[sp.Expr, ...]
    signs: tuple[int, ...]

    def __post_init__(self) -> None:
        if len(self.squared_dimensions) != len(self.signs):
            raise ValueError("squared_dimensions and signs must have equal length")
        if not self.squared_dimensions:
            raise ValueError("a category datum needs at least the unit object")
        for d in self.squared_dimensions:
            if sp.simplify(d) <= 0:
                raise ValueError("squared dimensions must be positive")
        if sp.simplify(self.squared_dimensions[0]) != 1:
            raise ValueError("the first object must be the unit, with d² = 1")
        if any(s not in (-1, 1) for s in self.signs):
            raise ValueError("Galois signs must be ±1")
        if self.signs[0] != 1:
            raise ValueError("the unit object has sign +1")

    @property
    def D2(self) -> sp.Expr:
        """Total squared quantum dimension ``D² = Σ d_i²``."""
        return sp.simplify(sum(self.squared_dimensions))

    @property
    def denominators(self) -> tuple[sp.Expr, ...]:
        """Egyptian denominators ``m_i = D²/d_i²``."""
        return tuple(sp.simplify(self.D2 / d) for d in self.squared_dimensions)

    @property
    def reciprocals(self) -> tuple[sp.Expr, ...]:
        """Unit-fraction masses ``1/m_i = d_i²/D²``."""
        return tuple(sp.simplify(1 / m) for m in self.denominators)

    @property
    def total_mass(self) -> sp.Expr:
        """``Σ_i 1/m_i``; Lemma 2.2 says this is exactly ``1``."""
        return sp.simplify(sum(self.reciprocals))

    @property
    def nonunit_mass(self) -> sp.Expr:
        """``Σ_{i≠0} 1/m_i``, which Lemma 2.2 identifies with ``1 - 1/D²``."""
        return sp.simplify(self.total_mass - self.reciprocals[0])


def nonunit_mass(D2: sp.Expr) -> sp.Expr:
    """The closed form ``1 - 1/D²`` for the non-unit Egyptian mass."""
    D2 = sp.sympify(D2)
    if sp.simplify(D2) <= 0:
        raise ValueError("D² must be positive")
    return sp.simplify(1 - 1 / D2)


def categorical_psi(datum: Datum, s: sp.Expr) -> sp.Expr:
    """The finite categorical Dirichlet polynomial ``Σ χ(m_i) m_i^{-s}``."""
    s = sp.sympify(s)
    terms = [sign * m ** (-s) for sign, m in zip(datum.signs, datum.denominators)]
    return sp.simplify(sum(terms))


def mellin_factor_section_2_4(D2: sp.Expr, s: sp.Expr) -> sp.Expr:
    """§2.4 Mellin factor: ``Γ(s) π^{-s} D^{2s}``."""
    s = sp.sympify(s)
    return sp.gamma(s) * PI ** (-s) * sp.sympify(D2) ** s


def mellin_factor_section_5_3(D2: sp.Expr, a: int, s: sp.Expr) -> sp.Expr:
    """§5.3 replacement: ``Γ((s+a)/2) π^{-(s+a)/2} D^{s}``.

    Note that ``D = sqrt(D²)``, so ``D^s = (D²)^{s/2}``.
    """
    s = sp.sympify(s)
    return (
        sp.gamma((s + a) / 2)
        * PI ** (-(s + a) / 2)
        * sp.sympify(D2) ** (s / 2)
    )


def normalisation_ratio(D2: sp.Expr, a: int, s: sp.Expr) -> sp.Expr:
    """The ratio of the §5.3 factor to the §2.4 factor."""
    return sp.simplify(
        mellin_factor_section_5_3(D2, a, s) / mellin_factor_section_2_4(D2, s)
    )


def qefe_prefactor(D2: sp.Expr, a: int, s: sp.Expr) -> sp.Expr:
    """The prefactor of the claimed QEFE (Theorem 3.1)."""
    s = sp.sympify(s)
    return sp.simplify(
        (sp.sympify(D2) / PI) ** (s - sp.Rational(1, 2))
        * sp.gamma((1 - s + a) / 2)
        / sp.gamma((s + a) / 2)
    )


ISING = Datum("Ising", (sp.Integer(1), sp.Integer(2), sp.Integer(1)), (1, -1, 1))
SU2_4 = Datum(
    "SU(2)_4",
    (sp.Integer(1), sp.Integer(3), sp.Integer(4), sp.Integer(3), sp.Integer(1)),
    (1, -1, 1, -1, 1),
)
EXAMPLES = (ISING, SU2_4)


def example(name: str) -> Datum:
    """Look up one of the two worked examples by name."""
    for datum in EXAMPLES:
        if datum.name == name:
            return datum
    raise KeyError(f"unknown example {name!r}")
