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


# ---------------------------------------------------------------------------
# Finite Weil Gram matrix on a Gaussian test basis
# ---------------------------------------------------------------------------
# The smooth basis is
#
#   phi_a(u) = exp(-(u-a)^2 / (2 sigma^2)),       a in R.
#
# Its reflected convolution is again a Gaussian:
#
#   (phi_a * phi_check_b)(v) = sqrt(pi) sigma
#       * exp(-(v - (a-b))^2 / (4 sigma^2)).
#
# The quadratic form is Q(f) = W(f * f_check).  For a real basis the Gram
# matrix is the polarisation
#
#   G_{ab} = (W(h_{ab}) + W(h_{ba})) / 2,   h_{ab} = phi_a * phi_check_b,
#
# which is symmetric.  When the support is narrow, the prime term is tiny;
# when it is wider, the primes enter and the matrix is a finite test of the
# arithmetic side.  The computation is numerical (mpmath); it is not a
# certified enclosure of Omega and therefore not a ledger theorem.

import functools

import mpmath as mp


def omega_density(t):
    """The archimedean density ``Omega(t) = Re psi(1/4 + i t/2) - log pi``."""
    return mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * t / 2).real - mp.log(mp.pi)


def gaussian_convolution(a, b, sigma, v):
    """``(phi_a * phi_check_b)(v)``, with ``phi_a(u)=exp(-(u-a)^2/2sigma^2)``."""
    a, b, sigma, v = map(mp.mpf, (a, b, sigma, v))
    return mp.sqrt(mp.pi) * sigma * mp.exp(-((v - (a - b)) ** 2) / (4 * sigma**2))


def weil_gaussian_pole(c, sigma):
    """The pole/archimedean ``2∫ h cosh(u/2)`` term for a centred Gaussian."""
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    return 4 * mp.pi * sigma**2 * mp.exp(sigma**2 / 4) * mp.cosh(c / 2)


@functools.lru_cache(maxsize=128)
def weil_gaussian_density(c, sigma):
    """``(1/2π)∫ ĝ Ω`` for the Gaussian ``h`` centred at ``c``.

    ``ĝ(t) = 2 π σ^2 exp(-σ^2 t^2) exp(-i c t)`` and ``Ω`` is even, so the
    integral is ``σ^2 ∫ exp(-σ^2 t^2) cos(c t) Ω(t) dt``.  The Gaussian
    tail beyond ``|t| = 10/σ`` is below ``exp(-100)``; the finite range
    keeps the quadrature fast and is far beyond the test tolerances.
    """
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    integrand = lambda t: (mp.exp(-(sigma * t) ** 2) * mp.cos(c * t)
                           * omega_density(t))
    points = [-200, -100, -50, -25, -10, 0, 10, 25, 50, 100, 200]
    return sigma**2 * mp.quad(integrand, points, maxdegree=4)


@functools.lru_cache(maxsize=8)
def _prime_power_data(X):
    """Cached ``(log p / sqrt(p^m), log(p^m))`` for ``p^m <= X``."""
    if X < 2:
        return ()
    sieve = bytearray([1]) * (X + 1)
    sieve[0] = sieve[1] = 0
    for p in range(2, int(X**0.5) + 1):
        if sieve[p]:
            for multiple in range(p * p, X + 1, p):
                sieve[multiple] = 0
    data = []
    for p in range(2, X + 1):
        if sieve[p]:
            log_p = mp.log(p)
            power = p
            while power <= X:
                data.append((log_p / mp.sqrt(power), mp.log(power)))
                power *= p
    return tuple(data)


@functools.lru_cache(maxsize=128)
def weil_gaussian_prime(c, sigma, X=20000):
    """``-2 Π(h)`` for the Gaussian ``h`` centred at ``c``."""
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    total = mp.mpf(0)
    for weight, v in _prime_power_data(X):
        total += weight * gaussian_convolution(c, 0, sigma, v)
    return -2 * total


@functools.lru_cache(maxsize=128)
def weil_gaussian_W(c, sigma, X=20000):
    """``W(h_c)`` for the Gaussian ``h_c`` centred at ``c``."""
    return (weil_gaussian_pole(c, sigma)
            + weil_gaussian_density(c, sigma)
            + weil_gaussian_prime(c, sigma, X))


def weil_gaussian_cross(a, b, sigma, X=20000):
    """One Gram entry ``G_{ab}``, symmetrised over ``c = a-b`` and ``-c``."""
    c = mp.mpf(a) - mp.mpf(b)
    return (weil_gaussian_W(c, sigma, X) + weil_gaussian_W(-c, sigma, X)) / 2


def weil_gaussian_gram(centers, sigma, X=20000):
    """The finite Weil Gram matrix on ``phi_a``, ``a`` in ``centers``."""
    centers = [mp.mpf(a) for a in centers]
    n = len(centers)
    G = mp.matrix(n, n)
    for i, a in enumerate(centers):
        for j, b in enumerate(centers):
            G[i, j] = weil_gaussian_cross(a, b, sigma, X)
    return G


def gram_eigenvalues(G):
    """Eigenvalues of a Hermitian ``mpmath`` matrix, sorted increasingly."""
    return sorted(x.real for x in mp.eig(G, left=False, right=False))


# ---------------------------------------------------------------------------
# Rigorous interval enclosure of Omega(t)
# ---------------------------------------------------------------------------
# From the digamma integral representation, for z = 1/4 + i t/2,
#
#   Re psi(z) = log|z| - Re(1/(2z))
#               - 2 ∫_0^∞ u (u² + Re z²) / ((u²+Re z²)² + (Im z²)²)
#                   / (e^{2πu}-1) du.
#
# The implementation below encloses this integral with outward-rounded
# interval arithmetic (mpmath.iv), a midpoint rule with an interval bound
# on the derivative, a Taylor series near u=0, and an explicit exponential
# tail bound.  It is a first interval layer, not yet a full density
# quadrature.  All constants and tails are chosen conservatively.

def _iv_const(x):
    x = mp.mpf(x)
    return (mp.iv.mpf([x, x]), mp.iv.mpf([0, 0]))


def _iv_add(x, y):
    return (x[0] + y[0], x[1] + y[1])


def _iv_sub(x, y):
    return (x[0] - y[0], x[1] - y[1])


def _iv_mul(x, y):
    return (x[0] * y[0], x[0] * y[1] + x[1] * y[0])


def _iv_inv(x):
    return (1 / x[0], -x[1] / (x[0] * x[0]))


def _iv_exp(x):
    e = mp.iv.exp(x[0])
    return (e, e * x[1])


def _omega_J_dual(a, b, t):
    """Dual interval for ``J(u)=A/(A²+B²)`` and ``dJ/du``."""
    u = (mp.iv.mpf([a, b]), mp.iv.mpf([1, 1]))
    tt = mp.mpf(t)
    B = tt / 4
    A = _iv_add(_iv_mul(u, u), _iv_const(mp.mpf(1) / 16 - tt * tt / 4))
    den = _iv_add(_iv_mul(A, A), _iv_const(B * B))
    return _iv_mul(A, _iv_inv(den))


def _omega_K_dual(a, b, t):
    """Dual interval for ``K(u)=u A/((A²+B²)(e^{2πu}-1))``, ``u>0``."""
    u = (mp.iv.mpf([a, b]), mp.iv.mpf([1, 1]))
    tt = mp.mpf(t)
    B = tt / 4
    A = _iv_add(_iv_mul(u, u), _iv_const(mp.mpf(1) / 16 - tt * tt / 4))
    den = _iv_add(_iv_mul(A, A), _iv_const(B * B))
    q = _iv_inv(den)
    e = _iv_exp(_iv_mul(_iv_const(2 * mp.pi), u))
    r = _iv_inv(_iv_sub(e, _iv_const(1)))
    return _iv_mul(_iv_mul(u, A), _iv_mul(q, r))


def _omega_K_series_dual(a, b, t):
    """Dual interval for ``K`` on ``[0, 0.01]`` using the series for ``s``.

    ``s(u)=u/(e^{2πu}-1)=1/(2π)-u/2+πu²/6+O(u⁴)``.  On the interval the
    omitted terms are bounded by ``10 u⁴``; the caller adds the integrated
    remainder.  This avoids the removable singularity at ``u=0``.
    """
    u = (mp.iv.mpf([a, b]), mp.iv.mpf([1, 1]))
    c0 = _iv_const(1 / (2 * mp.pi))
    c1 = _iv_const(-mp.mpf(1) / 2)
    c2 = _iv_const(mp.pi / 6)
    s = _iv_add(c0, _iv_add(_iv_mul(c1, u), _iv_mul(c2, _iv_mul(u, u))))
    return _iv_mul(_omega_J_dual(a, b, t), s)


def omega_interval(t, h=0.005, delta=0.01, U=10):
    """Rigorous enclosure of ``Ω(t)=Re ψ(1/4+it/2)-log π``.

    Parameters are conservative defaults.  ``h`` is the midpoint-rule step
    on ``[δ,U]``, ``δ`` the series/midpoint switch, and ``U`` the exponential
    tail cutoff.  The return value is an ``mpmath.iv.mpf`` interval.
    """
    tt = mp.mpf(t)
    h = mp.mpf(h)
    delta = mp.mpf(delta)
    U = mp.mpf(U)
    total = mp.iv.mpf([0, 0])

    # [0, delta]: series for s(u), midpoint with a derivative bound.
    n0 = 100
    h0 = delta / n0
    for i in range(n0):
        a = i * h0
        b = (i + 1) * h0
        mid = (a + b) / 2
        hh = b - a
        kmid = _omega_K_series_dual(mid, mid, tt)[0]
        ku = _omega_K_series_dual(a, b, tt)[1]
        total += mp.iv.mpf([hh, hh]) * kmid
        total += mp.iv.mpf([-hh * hh / 4, hh * hh / 4]) * ku
    # Series remainder: |s - polynomial| <= 10 u^4 and |J| <= 16.
    remainder = 16 * 10 * delta**5 / 5
    total += mp.iv.mpf([-remainder, remainder])

    # [delta, U]: exact K, midpoint with a derivative bound.
    n = int(mp.ceil((U - delta) / h))
    for i in range(n):
        a = delta + i * h
        b = min(a + h, U)
        mid = (a + b) / 2
        hh = b - a
        kmid = _omega_K_dual(mid, mid, tt)[0]
        ku = _omega_K_dual(a, b, tt)[1]
        total += mp.iv.mpf([hh, hh]) * kmid
        total += mp.iv.mpf([-hh * hh / 4, hh * hh / 4]) * ku

    # Tail: |K| <= 16 u/(e^{2πu}-1), and
    # ∫_U^∞ u e^{-2πu} du = e^{-2πU}(U/(2π)+1/(2π)²).
    tail = 32 * mp.e**(-2 * mp.pi * U) * (U / (2 * mp.pi)
                                          + 1 / (2 * mp.pi) ** 2)
    total += mp.iv.mpf([-tail, tail])

    c = mp.mpf(1) / 16 + tt * tt / 4
    base = mp.log(mp.sqrt(c)) - 1 / (8 * c) - mp.log(mp.pi)
    return mp.iv.mpf([base, base]) - 2 * total


def omega_interval_width(t, **kwargs):
    """Width of the interval enclosure returned by ``omega_interval``."""
    value = omega_interval(t, **kwargs)
    return value.b.b - value.a.a


def gaussian_prime_tail_bound(c, sigma, X=20000):
    """A conservative bound for the Gaussian prime tail beyond ``X``.

    For ``n > X`` and ``v = log n``,
    ``Λ(n)/√n ≤ v e^{-v/2}`` and the Gaussian factor is bounded via
    ``v e^{v/2} ≤ e^v``.  With ``a = 1/(4σ²)``, ``v0 = log X`` and
    ``d = v0 - c``, the resulting tail is at most
    ``2√π σ (e^{v0-a d²} + e^{v0-a d²}/(2ad-1))``.
    The bound is intended for the narrow windows used in the Gaussian
    Gram computation; it is deliberately very crude.
    """
    c, sigma, X = mp.mpf(c), mp.mpf(sigma), mp.mpf(X)
    if X <= 1 or sigma <= 0:
        raise ValueError("require X > 1 and sigma > 0")
    v0 = mp.log(X)
    a = 1 / (4 * sigma**2)
    d = v0 - c
    if d <= 0:
        raise ValueError("the crude tail bound requires log(X) > c")
    denom = 2 * a * d - 1
    if denom <= 0:
        raise ValueError("the crude tail bound requires 2 a d > 1")
    core = mp.e**(v0 - a * d * d)
    return 2 * mp.sqrt(mp.pi) * sigma * (core + core / denom)


def weil_gaussian_density_simpson(c, sigma, n=4000, T=None):
    """Deterministic Simpson quadrature for the Gaussian density term.

    This is the numerical rule intended for the eventual interval error
    bound: rational nodes, no adaptive quadrature.  It is not certified by
    itself; the missing ingredient is a rigorous bound on the fourth
    ``t``-derivative of the integrand.
    """
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    if n % 2:
        raise ValueError("n must be even")
    if T is None:
        T = 10 / sigma
    T = mp.mpf(T)
    h = 2 * T / n
    f = lambda t: mp.exp(-(sigma * t) ** 2) * mp.cos(c * t) * omega_density(t)
    total = f(-T) + f(T)
    for i in range(1, n):
        total += (4 if i % 2 else 2) * f(-T + i * h)
    return sigma**2 * h * total / 3


def gaussian_density_fourth_derivative(c, sigma, t):
    """Numerical ``|d⁴/dt⁴|`` of the Gaussian density integrand.

    This is a diagnostic for the size of the Simpson error bound, not a
    rigorous enclosure.  It evaluates the fourth derivative with mpmath's
    finite-difference `diff`.
    """
    c, sigma, t = mp.mpf(c), mp.mpf(sigma), mp.mpf(t)
    f = lambda u: mp.exp(-(sigma * u) ** 2) * mp.cos(c * u) * omega_density(u)
    return abs(mp.diff(f, t, 4))


# ---------------------------------------------------------------------------
# Univariate t-jet for Omega(t)
# ---------------------------------------------------------------------------
# The u-integral is evaluated with the same midpoint/derivative bound as
# `omega_interval`, but every quantity is now a `Jet` in t.  This supplies
# interval enclosures of Omega and its first `order` t-derivatives on a
# point or on a t-interval.

from jet import Jet  # noqa: E402


def omega_t_jet(t, order=5, h=0.005, delta=0.01, U=10):
    """Interval jet of ``Ω`` at a point or over a ``t``-interval.

    ``t`` may be an ``mpf``/float (point) or an ``mpmath.iv`` interval.  The
    returned ``Jet`` has ``order + 1`` components: the value and the first
    ``order`` derivatives.  The u-integration uses the same midpoint and
    derivative bounds as ``omega_interval``; the series remainder and tail
    are added conservatively to every component.
    """
    tjet = Jet.variable(t, order)
    total = Jet.const(0, order)
    h = mp.mpf(h)
    delta = mp.mpf(delta)
    U = mp.mpf(U)

    def K_and_Ku(a, b, series=False):
        u = (a + b) / 2 if a != b else a
        u2 = u * u
        Au = 2 * u
        A = tjet * tjet * (mp.mpf(-1) / 4) + (u2 + mp.mpf(1) / 16)
        B = tjet * (mp.mpf(1) / 4)
        den = A * A + B * B
        q = den.inv()
        q_u = A * q * q * (-2 * Au)
        if series:
            # s(u)=u/(e^{2πu}-1) ≈ 1/(2π) - u/2 + πu²/6,
            # s_u ≈ -1/2 + πu/3.
            s = mp.mpf(1) / (2 * mp.pi) - u / 2 + mp.pi * u * u / 6
            s_u = -mp.mpf(1) / 2 + mp.pi * u / 3
            J = A * q
            J_u = q * Au + A * q_u
            K = J * s
            K_u = J_u * s + J * s_u
        else:
            two_pi = mp.iv.mpf([2 * mp.pi, 2 * mp.pi])
            e = mp.iv.exp(two_pi * mp.iv.mpf([a, b]))
            r = 1 / (e - mp.iv.mpf([1, 1]))
            r_u = -two_pi * e * r * r
            uiv = mp.iv.mpf([u, u])
            uAiv = mp.iv.mpf([u * Au, u * Au])
            K = A * q * (uiv * r)
            K_u = (A * q * r + A * q * (uAiv * r)
                   + A * q_u * (uiv * r) + A * q * (uiv * r_u))
        return K, K_u

    # [0, delta]: polynomial s(u)=1/(2π)-u/2+πu²/6 and s_u=-1/2+πu/3,
    # then a separate remainder.  For 0 <= u <= delta, the Bernoulli
    # series gives |s-p| <= 10 u^4 and |s'-p'| <= 40 u^3.
    n0 = 100
    h0 = delta / n0
    for i in range(n0):
        a = i * h0
        b = (i + 1) * h0
        K, K_u = K_and_Ku(a, b, series=True)
        total += K * (b - a) + K_u * mp.iv.mpf([-(b - a) ** 2 / 4, (b - a) ** 2 / 4])

    # Remainder of the s-series, transported through J and J_u.
    u_iv = mp.iv.mpf([0, delta])
    u2 = u_iv * u_iv
    Au = 2 * u_iv
    A0 = tjet * tjet * (mp.mpf(-1) / 4) + (u2 + mp.mpf(1) / 16)
    B0 = tjet * (mp.mpf(1) / 4)
    den0 = A0 * A0 + B0 * B0
    q0 = den0.inv()
    J0 = A0 * q0
    J_u0 = q0 * Au + A0 * (A0 * q0 * q0 * (-2 * Au))
    R0 = 10 * delta**4
    R1 = 40 * delta**3
    absJ = Jet([abs(x) for x in J0.c])
    absJu = Jet([abs(x) for x in J_u0.c])
    errK = absJ * (delta * R0)
    errKu = absJu * (delta * R0) + absJ * (delta * R1)
    total = Jet([total.c[i] + errK.c[i] + errKu.c[i] for i in range(len(total))])

    # [delta, U]
    n = int(mp.ceil((U - delta) / h))
    for i in range(n):
        a = delta + i * h
        b = min(a + h, U)
        K, K_u = K_and_Ku(a, b, series=False)
        total += K * (b - a) + K_u * mp.iv.mpf([-(b - a) ** 2 / 4, (b - a) ** 2 / 4])
    total += Jet.const(mp.iv.mpf([-1e-5, 1e-5]), order)

    c = tjet * tjet * (mp.mpf(1) / 4) + mp.mpf(1) / 16
    base = c.log() * (mp.mpf(1) / 2) - c.inv() * (mp.mpf(1) / 8) - mp.log(mp.pi)
    return base - total * 2


def gaussian_density_panel_taylor(a, b, c, sigma, order=4, h=0.01, U=5):
    """Certified Taylor panel for the Gaussian density integrand.

    Returns ``(value, error)`` where ``value`` is an ``mpmath.iv`` interval
    and ``error`` bounds the Taylor remainder on ``[a,b]``.  The panel must
    be narrow enough that the interval ``1/(A²+B²)`` does not lose the
    ``A/B`` correlation; panels crossing a large range of ``t`` can still
    produce infinite widths.  ``order=4`` uses the degree-3 Taylor
    polynomial and the interval fourth derivative for the remainder.
    """
    a, b, c, sigma = mp.mpf(a), mp.mpf(b), mp.mpf(c), mp.mpf(sigma)
    H = b - a
    mid = (a + b) / 2
    s2 = mp.iv.mpf([sigma * sigma, sigma * sigma])
    tjet = Jet.variable(mid, order)
    omega = omega_t_jet(mid, order=order, h=h, U=U)
    expjet = (tjet * tjet * (-sigma * sigma)).exp()
    cosjet = (tjet * c).cos_sin()[0]
    fj = expjet * cosjet * omega

    tinterval = mp.iv.mpf([a, b])
    tjet_i = Jet.variable(tinterval, order)
    omega_i = omega_t_jet(tinterval, order=order, h=h, U=U)
    expjet_i = (tjet_i * tjet_i * (-sigma * sigma)).exp()
    cosjet_i = (tjet_i * c).cos_sin()[0]
    fj_i = expjet_i * cosjet_i * omega_i

    Hiv = mp.iv.mpf([H, H])
    value = s2 * (fj[0] * Hiv + fj[2] * (Hiv**3) / 24)
    M4 = max(abs(fj_i[order].a.a), abs(fj_i[order].b.b))
    error = sigma * sigma * M4 * H**5 / 1920
    return value, error


def gaussian_density_certified(c, sigma, H=0.2, T=1.0, order=4, h=0.01, U=5):
    """Assemble certified Taylor panels for the Gaussian density integral.

    Returns ``(interval, total_error, panels)``.  The panel grid is symmetric
    and forced to include ``0``.  ``H`` is the nominal panel width; the actual
    width is adjusted so the grid is uniform.  The caller must choose ``T``
    large enough that the Gaussian tail is below the target tolerance; this
    function does not add a separate t-tail bound.
    """
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    H = mp.mpf(H)
    T = mp.mpf(T)
    if H <= 0 or T <= 0:
        raise ValueError("H and T must be positive")
    n = int(mp.ceil(2 * T / H))
    if n % 2:
        n += 1
    step = 2 * T / n
    total = mp.iv.mpf([0, 0])
    error = mp.mpf(0)
    for i in range(n):
        a = -T + i * step
        b = a + step
        value, err = gaussian_density_panel_taylor(
            a, b, c, sigma, order=order, h=h, U=U)
        total += value
        error += err
    return total, error, n


def gaussian_density_certified_multi(cs, sigma, H=0.1, T=100.0,
                                     order=4, h=0.05, U=3):
    """Certified density intervals for several ``c`` values, sharing Ω jets.

    Returns ``(results, panels)`` where ``results`` is a list of
    ``(interval, total_error)`` pairs in the same order as ``cs``.  The
    Gaussian t-tail beyond ``T`` is not included; choose ``T`` with
    ``exp(-(sigma*T)**2)`` below the target tolerance.
    """
    cs = [mp.mpf(c) for c in cs]
    sigma = mp.mpf(sigma)
    H, T = mp.mpf(H), mp.mpf(T)
    n = int(mp.ceil(2 * T / H))
    if n % 2:
        n += 1
    step = 2 * T / n
    s2 = mp.iv.mpf([sigma * sigma, sigma * sigma])
    totals = [mp.iv.mpf([0, 0]) for _ in cs]
    errors = [mp.mpf(0) for _ in cs]

    for i in range(n):
        a = -T + i * step
        b = a + step
        mid = (a + b) / 2
        Hp = b - a
        Hiv = mp.iv.mpf([Hp, Hp])

        tj = Jet.variable(mid, order)
        om = omega_t_jet(mid, order=order, h=h, U=U)
        expj = (tj * tj * (-sigma * sigma)).exp()

        tiv = mp.iv.mpf([a, b])
        tji = Jet.variable(tiv, order)
        omi = omega_t_jet(tiv, order=order, h=h, U=U)
        expi = (tji * tji * (-sigma * sigma)).exp()

        for k, c in enumerate(cs):
            cosj = (tj * c).cos_sin()[0]
            cosi = (tji * c).cos_sin()[0]
            fj = expj * cosj * om
            fji = expi * cosi * omi
            value = s2 * (fj[0] * Hiv + fj[2] * (Hiv**3) / 24)
            M4 = max(abs(fji[4].a.a), abs(fji[4].b.b))
            totals[k] += value
            errors[k] += sigma * sigma * M4 * Hp**5 / 1920
    return list(zip(totals, errors)), n
