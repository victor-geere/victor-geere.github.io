"""Harmonic–Geometric Unified Theory — exact computation layer.

The archived source is a seven-phase research programme, not a proof.  It
does not define its central analytic objects (the transfer operator, the
Fredholm determinant, the monotonicity functional) well enough to compute
with.  What it does presuppose is elementary harmonic/Egyptian arithmetic:

* Egyptian unit weights ``1/(n+1)``;
* finite harmonic sums ``H_N = sum_{n<N} 1/(n+1)``;
* the greedy (Fibonacci–Sylvester) Egyptian expansion of a rational in
  ``(0, 1)``;
* the phase/duration table and the nominal three-year timeline.

This module makes those exact so that the programme's arithmetic can be
checked rather than asserted.  It uses sympy rationals throughout; no
floating-point value is used except where a test states a tolerance.
"""

from __future__ import annotations

from dataclasses import dataclass, asdict
from typing import Union

import sympy as sp

RationalLike = Union[int, sp.Integer, sp.Rational]


def egyptian_weight(n: int) -> sp.Rational:
    """The Egyptian unit weight ``1/(n+1)``.

    Raises ``ValueError`` for negative ``n``.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.Rational(1, n + 1)


def harmonic_sum(n_terms: int) -> sp.Rational:
    """The finite harmonic sum ``H_N = sum_{n=0}^{N-1} 1/(n+1)`` exactly.

    ``harmonic_sum(0)`` is the empty sum ``0``.
    """
    if n_terms < 0:
        raise ValueError("n_terms must be non-negative")
    return sum(egyptian_weight(n) for n in range(n_terms))


def egyptian_total(denominators: list[int]) -> sp.Rational:
    """Exact sum of the unit fractions ``1/d`` for ``d`` in ``denominators``."""
    total = sp.Integer(0)
    for d in denominators:
        if d <= 0:
            raise ValueError("denominators must be positive")
        total += sp.Rational(1, d)
    return sp.simplify(total)


def greedy_egyptian(r: Union[int, sp.Rational]) -> list[int]:
    """Greedy Egyptian expansion of a rational in the open interval ``(0, 1)``.

    At each step the next denominator is ``ceil(1/remainder)``, the largest
    unit fraction not exceeding the remainder.  The expansion produced is
    exact and the denominators are strictly increasing, hence distinct.

    Raises ``ValueError`` unless ``0 < r < 1``.
    """
    x = sp.Rational(r)
    if not (0 < x < 1):
        raise ValueError("r must be a rational strictly between 0 and 1")
    denominators: list[int] = []
    remaining = x
    while remaining != 0:
        if len(denominators) > 128:
            raise RuntimeError("greedy Egyptian expansion did not terminate")
        q = int(sp.ceiling(1 / remaining))
        denominators.append(q)
        remaining = sp.simplify(remaining - sp.Rational(1, q))
    return denominators


@dataclass(frozen=True)
class Phase:
    """One phase of the archived research plan."""

    number: int
    title: str
    min_months: int
    max_months: int
    status: str


_PHASES: tuple[Phase, ...] = (
    Phase(1, "Foundational strengthening", 6, 9, "Proposed"),
    Phase(2, "Operator-theoretic completion", 9, 12, "Proposed"),
    Phase(3, "Spectral equivalence", 12, 18, "Proposed"),
    Phase(4, "Dirichlet L-functions", 12, 15, "Proposed"),
    Phase(5, "Categorical and topological lift", 15, 24, "Proposed"),
    Phase(6, "Numerical verification and heuristics", 0, 0, "In Progress"),
    Phase(7, "Final synthesis and publication", 18, 30, "Proposed"),
)


def phase_table() -> list[Phase]:
    """The seven phases exactly as stated in the archived plan."""
    return list(_PHASES)


def phase_duration_totals() -> tuple[int, int]:
    """Sum of the stated minimum and maximum phase durations, in months.

    Phase 6 is stated as "ongoing" and contributes zero.  The totals are
    ``(72, 108)``.
    """
    return (
        sum(p.min_months for p in _PHASES),
        sum(p.max_months for p in _PHASES),
    )


def timeline_months() -> int:
    """The plan's nominal horizon: three years."""
    return 3 * 12


def overlap_required() -> bool:
    """Whether the stated phase durations exceed the nominal horizon.

    ``True`` means the phases cannot be run sequentially inside three years;
    the timeline only works if phases overlap.
    """
    _, maximum = phase_duration_totals()
    return maximum > timeline_months()


def milestones() -> dict[int, list[int]]:
    """Year-to-phase mapping stated in the plan's milestone section."""
    return {1: [1, 2], 2: [3, 4], 3: [5, 6]}


def open_problems() -> list[str]:
    """The plan's four key open problems, in its stated difficulty ranking."""
    return [
        "Zero-free property of e^{P(s)} in the critical strip",
        "Monotonicity inequality for twisted operators",
        "Full spectral equivalence on the critical line",
        "Rigorous construction of Greedy-Egyptian MTCs",
    ]


def phase_dicts() -> list[dict[str, object]]:
    """Serialisable view of the phase table."""
    return [asdict(p) for p in _PHASES]
