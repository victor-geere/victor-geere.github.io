"""Exact intersection-form arithmetic for the function-field template.

This module is the computation layer of the `intersection-form-zeta` dossier.
It models the rank-three lattice spanned by the classes `H = {pt} x E`,
`V = E x {pt}` and the diagonal `D` on the surface `E x E`, with the
intersection numbers

    H^2 = V^2 = D^2 = 0,   H.V = H.D = V.D = 1.

Everything in the linear algebra is exact rational arithmetic.  The elliptic
curve layer counts points over a prime field with a Legendre symbol, so the
Frobenius trace and the Hasse bound are exact integers.

Nothing here constructs an intersection form for `zeta`.  See the README for
the obstruction: the arithmetic intersection form exists (Arakelov,
Faltings-Hriljac) but has no Frobenius correspondence whose spectrum is the
zero set of `zeta`.
"""

from __future__ import annotations

from fractions import Fraction as F
from typing import Sequence

import sympy as sp

__all__ = [
    "GRAM",
    "dot",
    "self_sq",
    "ample",
    "hodge_defect",
    "hodge_inequality",
    "signature",
    "elliptic_point_count",
    "frobenius_trace",
    "hasse_bound_ok",
    "reciprocal_root_data",
    "diagonal_self_intersection",
]

# Gram matrix in the basis (H, V, D).
GRAM: tuple[tuple[int, int, int], ...] = (
    (0, 1, 1),
    (1, 0, 1),
    (1, 1, 0),
)


def _vec(v: Sequence[F | int]) -> tuple[F, F, F]:
    if len(v) != 3:
        raise ValueError("a class is a triple (a, b, c) in the basis (H, V, D)")
    return (F(v[0]), F(v[1]), F(v[2]))


def dot(v: Sequence[F | int], w: Sequence[F | int]) -> F:
    """Exact intersection number `v . w`."""
    a, b, c = _vec(v)
    a2, b2, c2 = _vec(w)
    return (
        a * b2 + a2 * b
        + a * c2 + a2 * c
        + b * c2 + b2 * c
    )


def self_sq(v: Sequence[F | int]) -> F:
    """Exact self-intersection `v . v`."""
    return dot(v, v)


def ample() -> tuple[int, int, int]:
    """The ample class `A = H + V + D`, with `A^2 = 6`."""
    return (1, 1, 1)


def hodge_defect(v: Sequence[F | int]) -> F:
    """The Hodge defect `(A . v)^2 - 6 v^2`, non-negative by the identity."""
    return dot(v, ample()) ** 2 - 6 * self_sq(v)


def hodge_inequality(v: Sequence[F | int]) -> bool:
    """Whether `6 v^2 <= (A . v)^2` holds for the class `v`."""
    return 6 * self_sq(v) <= dot(v, ample()) ** 2


def signature() -> tuple[int, int]:
    """Signature `(positive, negative)` of the Gram matrix, exactly."""
    eigenvalues = sp.Matrix(GRAM).eigenvals()
    positive = sum(m for e, m in eigenvalues.items() if e > 0)
    negative = sum(m for e, m in eigenvalues.items() if e < 0)
    zero = sum(m for e, m in eigenvalues.items() if e == 0)
    if zero:
        raise AssertionError("the intersection form should be non-degenerate")
    return int(positive), int(negative)


def _is_prime(p: int) -> bool:
    return sp.isprime(p)


def elliptic_point_count(p: int, a: int, b: int) -> int:
    """Number of points of `y^2 = x^3 + a x + b` over `F_p`, including infinity.

    Requires `p` an odd prime and `4a^3 + 27b^2 != 0 (mod p)`.
    """
    if p <= 2 or not _is_prime(p):
        raise ValueError("p must be an odd prime")
    if (4 * a**3 + 27 * b**2) % p == 0:
        raise ValueError("the curve is singular over F_p")
    count = 1  # the point at infinity
    for x in range(p):
        rhs = (x**3 + a * x + b) % p
        if rhs == 0:
            count += 1
        elif pow(rhs, (p - 1) // 2, p) == 1:
            count += 2
    return count


def frobenius_trace(p: int, a: int, b: int) -> int:
    """The trace of Frobenius, `a_p = p + 1 - #E(F_p)`."""
    return p + 1 - elliptic_point_count(p, a, b)


def hasse_bound_ok(p: int, a: int, b: int) -> bool:
    """Exact Hasse check `a_p^2 <= 4p`, without floating point."""
    return frobenius_trace(p, a, b) ** 2 <= 4 * p


def reciprocal_root_data(p: int, a: int, b: int) -> dict:
    """Data on the reciprocal roots of `1 - a_p T + p T^2`.

    Returns the discriminant `a_p^2 - 4p` and the exact product of the
    reciprocal roots (equal to `p`).  RH for the curve is the statement
    `a_p^2 - 4p <= 0`, in which case the roots are complex conjugates of
    modulus `sqrt(p)`.
    """
    trace = frobenius_trace(p, a, b)
    discriminant = trace**2 - 4 * p
    return {
        "p": p,
        "a_p": trace,
        "discriminant": discriminant,
        "reciprocal_root_product": p,
        "roots_are_conjugate": discriminant <= 0,
    }


def diagonal_self_intersection() -> F:
    """The self-intersection of the diagonal `D` on `E x E` (genus one)."""
    return self_sq((0, 0, 1))
