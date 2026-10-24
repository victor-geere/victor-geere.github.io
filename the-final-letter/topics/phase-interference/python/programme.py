"""Phase interference — exact finite kernel and phase computation layer.

The module reconstructs the finite part of the archived phase-interference
note: the true recursive greedy harmonic decomposition (Definition 2.1), the
centred functions (Definition 2.4), the correlation kernel (Definition 2.5),
and the phase-weighted kernel entries on the critical line (Definition 2.6).

Everything is exact (``sympy``); no floating-point value enters the kernel
computations.  The GRH conclusion of the source is *not* implemented: it is
an archived claim, recorded in the dossier and not a computation.
"""

from __future__ import annotations

from functools import lru_cache

import sympy as sp

PI = sp.pi
THETA = sp.symbols("theta", real=True)
X = sp.symbols("x", real=True)


def _check_index(n: int, name: str = "n") -> int:
    """Validate an index and return it as a plain Python ``int``."""
    try:
        n_int = int(n)
    except (TypeError, ValueError) as exc:
        raise TypeError(f"{name} must be an integer") from exc
    if n_int != n:
        raise TypeError(f"{name} must be an integer")
    if n_int < 0:
        raise ValueError(f"{name} must be non-negative")
    return n_int


def alpha(n: int) -> sp.Expr:
    """Harmonic step ``α_n = π / (n + 2)`` (Definition 2.1)."""
    n = _check_index(n)
    return PI / (n + 2)


@lru_cache(maxsize=None)
def _intervals_cached(n_max: int) -> tuple[tuple[tuple[sp.Expr, sp.Expr], ...], ...]:
    """Cached support computation in units of π (rational endpoints)."""
    # Partition of [0, 1] with the accumulated angle before the current index.
    parts: list[tuple[sp.Expr, sp.Expr, sp.Expr]] = [
        (sp.Integer(0), sp.Integer(1), sp.Integer(0))
    ]
    supports: list[tuple[tuple[sp.Expr, sp.Expr], ...]] = []
    for n in range(n_max + 1):
        step = sp.Rational(1, n + 2)
        new_parts: list[tuple[sp.Expr, sp.Expr, sp.Expr]] = []
        on: list[tuple[sp.Expr, sp.Expr]] = []
        for a, b, acc in parts:
            cut = acc + step
            if cut <= a:
                new_parts.append((a, b, acc + step))
                on.append((a, b))
            elif cut >= b:
                new_parts.append((a, b, acc))
            else:
                new_parts.append((a, cut, acc))
                new_parts.append((cut, b, acc + step))
                on.append((cut, b))
        supports.append(tuple(on))
        parts = new_parts
    return tuple(supports)


def greedy_intervals(n_max: int) -> list[list[tuple[sp.Expr, sp.Expr]]]:
    """Exact supports of ``δ_0, …, δ_{n_max}`` on ``[0, π]``.

    Returns, for each index ``n``, the finite union of intervals on which the
    true recursive greedy rule selects ``α_n``.  The recursion tracks the
    accumulated angle on every subinterval, so the result is the genuinely
    fragmented support of Definition 2.1 rather than the false global
    indicator ``1_{[α_n, π]}`` that the source explicitly retracts.
    """
    n_max = _check_index(n_max, "n_max")
    return [
        [(a * PI, b * PI) for a, b in support]
        for support in _intervals_cached(n_max)
    ]


def _digit(n: int, theta: sp.Expr) -> int:
    """The true recursive selector ``δ_n(θ)`` (Definition 2.1)."""
    theta = sp.sympify(theta)
    remainder = theta
    for k in range(n + 1):
        step = alpha(k)
        decision = sp.simplify(remainder - step)
        take = decision.is_nonnegative
        if take is None:
            take = bool(sp.N(decision, 60) >= 0)
        if k == n:
            return 1 if take else 0
        if take:
            remainder = sp.simplify(remainder - step)
    raise AssertionError("unreachable")


def greedy_digits(theta: sp.Expr, n_max: int) -> list[int]:
    """The selection word ``δ_0(θ), …, δ_{n_max}(θ)`` with exact decisions."""
    n_max = _check_index(n_max, "n_max")
    return [_digit(n, theta) for n in range(n_max + 1)]


def centred(n: int, theta: sp.Expr) -> sp.Expr:
    """The centred function ``φ_n(θ) = δ_n(θ) − θ/π`` (Definition 2.4)."""
    n = _check_index(n)
    return _digit(n, theta) - sp.sympify(theta) / PI


@lru_cache(maxsize=None)
def _kernel_scaled(n: int, m: int) -> sp.Expr:
    """``K(n,m)/π`` computed on ``x = θ/π`` with rational endpoints."""
    top = max(n, m)
    supports = _intervals_cached(top)

    def on(support: tuple[tuple[sp.Expr, sp.Expr], ...], x: sp.Expr) -> bool:
        return any(
            bool(sp.simplify(x - a).is_nonnegative)
            and bool(sp.simplify(b - x).is_nonnegative)
            for a, b in support
        )

    endpoints = {sp.Integer(0), sp.Integer(1)}
    for k in (n, m):
        for a, b in supports[k]:
            endpoints.add(a)
            endpoints.add(b)
    ordered = sorted(endpoints)
    total = sp.Integer(0)
    for a, b in zip(ordered, ordered[1:]):
        mid = (a + b) / 2
        dn = 1 if on(supports[n], mid) else 0
        dm = 1 if on(supports[m], mid) else 0
        total += sp.integrate((dn - X) * (dm - X), (X, a, b))
    return sp.simplify(total)


def kernel(n: int, m: int) -> sp.Expr:
    """The exact correlation kernel ``K(n,m) = ∫_0^π φ_n φ_m dθ``."""
    n = _check_index(n)
    m = _check_index(m)
    return sp.simplify(PI * _kernel_scaled(n, m))


def kernel_scaled(n: int, m: int) -> sp.Expr:
    """``K(n,m)/π``, an exact rational for the finite greedy supports."""
    n = _check_index(n)
    m = _check_index(m)
    return _kernel_scaled(n, m)


def kernel_matrix(n_max: int) -> sp.Matrix:
    """The exact ``(n_max+1) × (n_max+1)`` correlation matrix."""
    n_max = _check_index(n_max, "n_max")
    return sp.Matrix(n_max + 1, n_max + 1, lambda i, j: kernel(i, j))


def is_positive_semidefinite(matrix: sp.Matrix) -> bool:
    """Exact PSD test by the leading-minor (Sylvester) criterion.

    The finite correlation matrix is a Gram matrix, so every principal minor
    is non-negative; the test returns ``True`` only if all leading principal
    minors are exactly non-negative.
    """
    if matrix.rows != matrix.cols:
        raise ValueError("matrix must be square")
    for k in range(1, matrix.rows + 1):
        minor = matrix[:k, :k].det()
        if sp.simplify(minor).is_nonnegative is not True:
            return False
    return True


def phase(n: int, t: sp.Expr) -> sp.Expr:
    """The critical-line phase factor ``w_n(t) = (n+2)^{-it}``."""
    n = _check_index(n)
    return sp.exp(-sp.I * sp.sympify(t) * sp.log(n + 2))


def weighted(K: sp.Expr, n: int, m: int, t: sp.Expr) -> sp.Expr:
    """Phase-weighted kernel entry of Definition 2.6 at ``s = 1/2 + it``."""
    return sp.sympify(K) * phase(n, t) * phase(m, t)


def destructive_height(n: int, m: int) -> sp.Expr:
    """The height ``t`` at which ``w_n(t) + w_m(t)`` cancels exactly.

    Since ``w_m/w_n = (m+2)^{-it}(n+2)^{it} = exp(-it log((m+2)/(n+2)))``,
    the two unit phases are opposite exactly when
    ``t log((m+2)/(n+2)) = π``.  The indices must differ.
    """
    n = _check_index(n)
    m = _check_index(m)
    if n == m:
        raise ValueError("n and m must differ")
    return PI / sp.log(sp.Rational(m + 2, n + 2))


def interference_modulus(n: int, m: int, t: sp.Expr) -> sp.Expr:
    """``|w_n(t) + w_m(t)|`` — the finite two-term interference amplitude."""
    return sp.Abs(phase(n, t) + phase(m, t))
