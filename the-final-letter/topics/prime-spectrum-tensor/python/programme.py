"""Prime-spectrum tensor — exact and high-precision computation layer.

The module reconstructs the finite objects of ``tensor.html`` and the
companion resolution ``tensor.md``:

* the von Mangoldt weights and finite truncations of the prime current
  ``Pi(f) = sum_n Lambda(n) / sqrt(n) f(log n)`` (Definition 3.1);
* Riemann's Jacobi density ``Phi`` as the term-by-term series of
  ``tensor.md`` §2, and its positivity;
* the Gaussian witness ``f0`` of Theorem B, its Fourier transform and the
  closed-form convolution ``g0 = f0 * f0``;
* the finite Fourier-atom kernel of the repaired current ``W`` and its
  Gram form, whose non-negativity is the finite Bochner step of
  Theorem C(2).

Symbolic work is done with sympy.  The few numerical checks use mpmath at
30 significant digits and state their tolerance.  Importing the module has
no side effects.
"""

from __future__ import annotations

from typing import Callable, Sequence

import sympy as sp

PI = sp.pi
I = sp.I


# ---------------------------------------------------------------------------
# Prime current (Definition 3.1)
# ---------------------------------------------------------------------------

def von_mangoldt(n: int) -> sp.Expr:
    """The von Mangoldt function ``Lambda(n)``, exactly as ``log p``.

    ``Lambda(n) = log p`` when ``n = p^k`` for a prime ``p`` and ``k >= 1``,
    and ``0`` otherwise.  The value is returned as a sympy expression, so
    ``von_mangoldt(8) == log(2)`` is an exact identity.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    if n < 2:
        return sp.Integer(0)
    p = _smallest_prime_factor(n)
    m = n
    while m % p == 0:
        m //= p
    if m != 1:
        return sp.Integer(0)
    return sp.log(p)


def _smallest_prime_factor(n: int) -> int:
    if n % 2 == 0:
        return 2
    d = 3
    while d * d <= n:
        if n % d == 0:
            return d
        d += 2
    return n


def prime_weight(n: int) -> sp.Expr:
    """The prime-current weight ``Lambda(n) / sqrt(n)``."""
    if n < 0:
        raise ValueError("n must be non-negative")
    if n < 2:
        return sp.Integer(0)
    return von_mangoldt(n) / sp.sqrt(n)


def prime_current(f: Callable[[sp.Expr], sp.Expr], N: int) -> sp.Expr:
    """Finite truncation ``sum_{2 <= n <= N} Lambda(n)/sqrt(n) f(log n)``."""
    if N < 0:
        raise ValueError("N must be non-negative")
    return sp.Add(*[prime_weight(n) * f(sp.log(n)) for n in range(2, N + 1)])


# ---------------------------------------------------------------------------
# Jacobi density (tensor.md §2)
# ---------------------------------------------------------------------------

def phi_term(n: int, u: sp.Expr) -> sp.Expr:
    """The ``n``-th term of Riemann's even Jacobi density ``Phi(u)``."""
    if n < 1:
        raise ValueError("the Jacobi series starts at n = 1")
    n = sp.Integer(n)
    return (
        2 * PI**2 * n**4 * sp.exp(sp.Rational(9, 2) * u)
        - 3 * PI * n**2 * sp.exp(sp.Rational(5, 2) * u)
    ) * sp.exp(-PI * n**2 * sp.exp(2 * u))


def phi_series(u: sp.Expr, terms: int) -> sp.Expr:
    """Finite truncation ``sum_{n=1}^{terms} phi_term(n, u)`` of ``Phi(u)``."""
    if terms < 0:
        raise ValueError("terms must be non-negative")
    return sp.Add(*[phi_term(n, u) for n in range(1, terms + 1)])


# ---------------------------------------------------------------------------
# The Gaussian witness of Theorem B
# ---------------------------------------------------------------------------

GAMMA_1 = sp.Float("14.1347251417346937904572519836", 30)


def fhat0(t: sp.Expr, gamma: sp.Expr = GAMMA_1) -> sp.Expr:
    """Fourier transform of ``f0(u) = 2/sqrt(pi) exp(-u^2) cos(gamma u)``."""
    return sp.exp(-((t - gamma) ** 2) / 4) + sp.exp(-((t + gamma) ** 2) / 4)


def g0(v: sp.Expr, gamma: sp.Expr = GAMMA_1) -> sp.Expr:
    """Closed form of ``g0 = f0 * f0`` from tensor.md Theorem B."""
    return (
        sp.sqrt(2 / PI)
        * sp.exp(-(v**2) / 2)
        * (sp.cos(gamma * v) + sp.exp(-(gamma**2) / 2))
    )


def pole_weight(gamma: sp.Expr = GAMMA_1) -> sp.Expr:
    """The pole term ``|fhat0(i/2)|^2`` in closed form.

    For real ``gamma`` this equals
    ``4 cos(gamma/4)^2 exp(-(gamma^2 - 1/4)/2)``.
    """
    return 4 * sp.cos(gamma / 4) ** 2 * sp.exp(-(gamma**2 - sp.Rational(1, 4)) / 2)


# ---------------------------------------------------------------------------
# Finite Fourier-atom kernel (tensor.md Theorem C, finite model)
# ---------------------------------------------------------------------------

def atomic_kernel(weights: Sequence[sp.Expr], freqs: Sequence[sp.Expr],
                  x: sp.Expr) -> sp.Expr:
    """``sum_k w_k exp(i gamma_k x)``, the finite spectral current."""
    if len(weights) != len(freqs):
        raise ValueError("weights and freqs must have the same length")
    return sp.Add(*[
        w * sp.exp(I * g * x) for w, g in zip(weights, freqs)
    ])


def mode_sum(coeffs: Sequence[sp.Expr], freqs: Sequence[sp.Expr],
             points: Sequence[sp.Expr]) -> list[sp.Expr]:
    """``Z_k = sum_j a_j exp(i gamma_k u_j)`` for each frequency ``k``."""
    if len(coeffs) != len(points):
        raise ValueError("coeffs and points must have the same length")
    return [
        sp.Add(*[a * sp.exp(I * g * u) for a, u in zip(coeffs, points)])
        for g in freqs
    ]


def gram_form(weights: Sequence[sp.Expr], freqs: Sequence[sp.Expr],
              points: Sequence[sp.Expr], coeffs: Sequence[sp.Expr]) -> sp.Expr:
    """The finite Gram form ``sum_{j,l} a_j conj(a_l) K(u_j - u_l)``."""
    if len(weights) != len(freqs):
        raise ValueError("weights and freqs must have the same length")
    if len(points) != len(coeffs):
        raise ValueError("points and coeffs must have the same length")
    total = sp.Integer(0)
    for j, aj in enumerate(coeffs):
        for l, al in enumerate(coeffs):
            total += aj * sp.conjugate(al) * atomic_kernel(
                weights, freqs, points[j] - points[l])
    return total


def mode_sq_sum(weights: Sequence[sp.Expr], freqs: Sequence[sp.Expr],
                points: Sequence[sp.Expr], coeffs: Sequence[sp.Expr]) -> sp.Expr:
    """``sum_k w_k |Z_k|^2``, the modal form of the Gram form."""
    zs = mode_sum(coeffs, freqs, points)
    return sp.Add(*[w * sp.Abs(z) ** 2 for w, z in zip(weights, zs)])
