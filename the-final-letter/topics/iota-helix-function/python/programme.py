"""The iota helix — exact computation layer.

The archived framework defines the eta terms

    v_n(s) = (-1)^(n-1) n^(-s),   s = σ + it,

and reads them as planar steps.  The companion iota-function note gives the
same steps a helix parametrisation with radius and unwrapped phase

    r_n = n^(-σ),   Φ_n = π(n-1) - t log n,

so that ``r_n * exp(i Φ_n) = v_n(s)``.  This module implements both sides
with sympy and keeps every identity exact where sympy can decide it.

Conventions.  ``t`` is the imaginary part of ``s = σ + it``, and the
alternating sign is carried by ``(-1)^(n-1)``.  The archived
``iota-framework.html`` writes the imaginary part with ``+sin(t log n)``;
that is the conjugate convention and is recorded as an erratum in the
programme README.  The functions below use the convention that agrees with
the eta series and with the companion ``iota-function.tex``.
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi
I = sp.I


def _index(n: int) -> int:
    """Validate the 1-based iota index."""
    if not isinstance(n, int):
        raise TypeError("n must be an integer")
    if n < 1:
        raise ValueError("n must be a positive integer")
    return n


def radius(sigma: sp.Expr, n: int) -> sp.Expr:
    """Step radius ``r_n = n^(-σ)``."""
    _index(n)
    return sp.Integer(n) ** (-sp.sympify(sigma))


def phase(t: sp.Expr, n: int) -> sp.Expr:
    """Unwrapped helix phase ``Φ_n = π(n-1) - t log n``."""
    _index(n)
    return PI * (n - 1) - sp.sympify(t) * sp.log(n)


def helix_x(sigma: sp.Expr, t: sp.Expr, n: int) -> sp.Expr:
    """Real coordinate of the helix step, ``r_n cos Φ_n``."""
    return radius(sigma, n) * sp.cos(phase(t, n))


def helix_y(sigma: sp.Expr, t: sp.Expr, n: int) -> sp.Expr:
    """Imaginary coordinate of the helix step, ``r_n sin Φ_n``."""
    return radius(sigma, n) * sp.sin(phase(t, n))


def eta_x(sigma: sp.Expr, t: sp.Expr, n: int) -> sp.Expr:
    """Real part of the eta term, with the alternating sign made explicit."""
    _index(n)
    return (-1) ** (n - 1) * radius(sigma, n) * sp.cos(sp.sympify(t) * sp.log(n))


def eta_y(sigma: sp.Expr, t: sp.Expr, n: int) -> sp.Expr:
    """Imaginary part of ``(-1)^(n-1) n^(-σ-it)``.

    The sign is negative because ``n^(-it) = exp(-it log n)``.
    """
    _index(n)
    return -(-1) ** (n - 1) * radius(sigma, n) * sp.sin(sp.sympify(t) * sp.log(n))


def eta_term(sigma: sp.Expr, t: sp.Expr, n: int) -> sp.Expr:
    """The complex eta term ``(-1)^(n-1) n^(-σ-it)`` as an exact expression."""
    return sp.simplify(eta_x(sigma, t, n) + I * eta_y(sigma, t, n))


def eta_partial(sigma: sp.Expr, N: int) -> sp.Expr:
    """Real-axis eta partial sum ``Σ_{n=1}^N (-1)^(n-1) n^(-σ)``."""
    if N < 0:
        raise ValueError("N must be non-negative")
    return sp.simplify(sum((-1) ** (n - 1) * radius(sigma, n) for n in range(1, N + 1)))


def paired_partial(sigma: sp.Expr, M: int) -> sp.Expr:
    """Paired finite eta sum ``Σ_{k=1}^M ((2k-1)^(-σ) - (2k)^(-σ))``."""
    if M < 0:
        raise ValueError("M must be non-negative")
    return sp.simplify(
        sum(radius(sigma, 2 * k - 1) - radius(sigma, 2 * k) for k in range(1, M + 1))
    )


def _partial_complex(sigma: sp.Expr, t: sp.Expr, N: int) -> sp.Expr:
    """Complex partial sum of the eta terms through index ``N``."""
    return sp.simplify(
        sum(eta_x(sigma, t, n) + I * eta_y(sigma, t, n) for n in range(1, N + 1))
    )


def greedy_dot(sigma: sp.Expr, t: sp.Expr, N: int) -> sp.Expr:
    """The greedy-condition pairing ``Re(conj(S_{N-1}) v_N)``.

    This is the Euclidean dot product of the accumulated position
    ``S_{N-1}`` with the next step ``v_N``.  At ``N = 1`` the accumulated
    position is zero, so the pairing is zero.
    """
    _index(N)
    S = _partial_complex(sigma, t, N - 1)
    v = eta_x(sigma, t, N) + I * eta_y(sigma, t, N)
    return sp.simplify(sp.re(sp.conjugate(S) * v))


def source_greedy_dot(sigma: sp.Expr, t: sp.Expr, N: int) -> sp.Expr:
    """The companion note's pairing ``Re(conj(S_{N-1}) w_N)`` without the sign.

    The note sets ``w_N = N^(-s)`` but the actual step is
    ``v_N = (-1)^(N-1) N^(-s)``.  This function records the expression as
    written in the source; :func:`greedy_dot` is the geometrically correct
    dot product with the step.
    """
    _index(N)
    S = _partial_complex(sigma, t, N - 1)
    w = radius(sigma, N) * sp.exp(-I * sp.sympify(t) * sp.log(N))
    return sp.simplify(sp.re(sp.conjugate(S) * w))
