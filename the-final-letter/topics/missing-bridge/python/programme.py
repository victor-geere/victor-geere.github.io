"""Computation layer for the missing-bridge programme.

The module records the three candidate bridge statements of
``README.md`` at the level where they can be checked exactly or to
high precision:

* ``on_line_quad`` / ``on_line_quad_sos`` — the on-line rank-one
  factorization as a manifest sum of squares (C1);
* ``rank_one_factor`` — the same factorization pointwise, including its
  failure off the critical line (C2);
* ``prime_side`` — the von Mangoldt contribution, which is a sum of
  nonnegative terms, and ``archimedean_omega``, which is signed: the
  competition between them is the arithmetic of the bridge (C3);
* ``offline_quad`` and ``diag_block_eigenvalues`` — the off-line block
  obstruction (C4);
* ``admissible_epsilon`` — the entrywise margin of the finite
  certificate, and its decay with dimension (C5);
* ``convex_combination`` — PSD convexity, the elementary deformation
  step (C6).

Numerical work uses ``mpmath``; no side effects on import.
"""

from __future__ import annotations

import math

import mpmath

PI = math.pi


# ---------------------------------------------------------------------------
# 1. The on-line rank-one factorization and its sum-of-squares form
# ---------------------------------------------------------------------------

def gaussian_mode(a: float, sigma: float, t: float) -> complex:
    """``φ_a(t) = σ√(2π) exp(−σ²t²/2) exp(−iat)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return sigma * math.sqrt(2 * PI) * math.exp(-(sigma ** 2) * t ** 2 / 2) * complex(
        math.cos(-a * t), math.sin(-a * t)
    )


def gaussian_test(c: float, sigma: float, s: complex) -> complex:
    """``H_c(s) = 2πσ² exp(σ²(s−1/2)²) exp(−c(s−1/2))``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    u = s - 0.5
    return 2 * PI * sigma ** 2 * mpmath.exp(sigma ** 2 * u ** 2) * mpmath.exp(-c * u)


def rank_one_factor(a: float, b: float, sigma: float, t: float) -> complex:
    """``H_{a−b}(1/2+it)`` as a product ``φ_a(t) · conj φ_b(t)``."""
    return gaussian_mode(a, sigma, t) * gaussian_mode(b, sigma, t).conjugate()


def gaussian_cos_mode(a: float, sigma: float, gamma: float) -> float:
    """The real cosine mode ``√(2π) σ exp(−σ²γ²/2) cos(aγ)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return math.sqrt(2 * PI) * sigma * math.exp(-(sigma ** 2) * gamma ** 2 / 2) * math.cos(a * gamma)


def gaussian_sin_mode(a: float, sigma: float, gamma: float) -> float:
    """The real sine mode ``√(2π) σ exp(−σ²γ²/2) sin(aγ)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return math.sqrt(2 * PI) * sigma * math.exp(-(sigma ** 2) * gamma ** 2 / 2) * math.sin(a * gamma)


def on_line_quad(a: list[float], sigma: float, gamma: float, c: list[float]) -> float:
    """The on-line quadratic form ``Σ_ij c_i c_j K(a_i − a_j)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if len(a) != len(c):
        raise ValueError("a and c must have the same length")
    weight = 2 * PI * sigma ** 2 * math.exp(-(sigma ** 2) * gamma ** 2)
    return sum(
        c[i] * c[j] * weight * math.cos((a[i] - a[j]) * gamma)
        for i in range(len(a))
        for j in range(len(a))
    )


def on_line_quad_sos(a: list[float], sigma: float, gamma: float, c: list[float]) -> float:
    """The same form as a cosine-square plus a sine-square."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if len(a) != len(c):
        raise ValueError("a and c must have the same length")
    cos_part = sum(c[i] * gaussian_cos_mode(a[i], sigma, gamma) for i in range(len(a)))
    sin_part = sum(c[i] * gaussian_sin_mode(a[i], sigma, gamma) for i in range(len(a)))
    return cos_part ** 2 + sin_part ** 2


# ---------------------------------------------------------------------------
# 2. The prime side and the archimedean density
# ---------------------------------------------------------------------------

def von_mangoldt(n: int) -> float:
    """``Λ(n)``: ``log p`` if ``n = p^m``, else ``0``."""
    if n < 1:
        raise ValueError("n must be a positive integer")
    if n == 1:
        return 0.0
    m = n
    p = None
    d = 2
    while d * d <= m:
        if m % d == 0:
            p = d
            while m % d == 0:
                m //= d
            break
        d += 1
    if p is None:
        return math.log(n)  # n is prime
    if m != 1:
        return 0.0
    return math.log(p)


def gaussian_bump(c: float, sigma: float, v: float) -> float:
    """``h_c(v) = √π σ exp(−(v−c)²/(4σ²))``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return math.sqrt(PI) * sigma * math.exp(-((v - c) ** 2) / (4 * sigma ** 2))


def prime_side(c: float, sigma: float, n_max: int) -> float:
    """The von Mangoldt contribution ``Σ_{n≤N} Λ(n) n^{-1/2} h_c(log n)``.

    Every term is nonnegative: ``Λ(n) ≥ 0``, ``n^{-1/2} > 0`` and
    ``h_c > 0``.  This is the part of the explicit formula that *is*
    already a manifest sum of nonnegative terms.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if n_max < 2:
        return 0.0
    return sum(
        von_mangoldt(n) / math.sqrt(n) * gaussian_bump(c, sigma, math.log(n))
        for n in range(2, n_max + 1)
    )


def archimedean_omega(t: float) -> float:
    """``Ω(t) = Re ψ(1/4 + it/2) − log π``, the archimedean density.

    Unlike the prime term this is signed; at ``t = 0`` it is negative.
    """
    s = mpmath.mpf(1) / 4 + mpmath.mpc(0, 1) * mpmath.mpf(t) / 2
    return float(mpmath.re(mpmath.digamma(s)) - mpmath.log(mpmath.pi))


def archimedean_term(c: float, sigma: float) -> float:
    """The density term ``σ² ∫ exp(−σ²t²) cos(ct) Ω(t) dt`` over ``(−T, T)``.

    The integral is truncated at ``T = 12/σ``, where the Gaussian factor is
    below ``exp(−144)``.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    T = 12.0 / sigma
    f = lambda t: math.exp(-(sigma ** 2) * t ** 2) * math.cos(c * t) * archimedean_omega(t)
    return sigma ** 2 * float(mpmath.quad(f, [-T, 0, T]))


def pole_term(c: float, sigma: float) -> float:
    """The pole contribution ``4πσ² exp(σ²/4) cosh(c/2)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return 4 * PI * sigma ** 2 * math.exp(sigma ** 2 / 4) * math.cosh(c / 2)


def weil_entry(c: float, sigma: float, n_max: int = 4000) -> float:
    """The assembled Gaussian Weil entry ``pole + prime + density``.

    The prime part enters with a minus sign (see ``primeTerm`` in the
    O2 dossier), so this is a signed sum of a positive pole term, a
    nonnegative prime sum and a signed archimedean density.  For ``c ≠ 0``
    it is an off-diagonal entry and may be negative without violating
    positivity; only the assembled quadratic form is constrained.
    """
    return (
        pole_term(c, sigma)
        - 2 * prime_side(c, sigma, n_max)
        + archimedean_term(c, sigma)
    )


def prime_kernel(a: list[float], sigma: float, n_max: int = 4000) -> list[list[float]]:
    """The symmetrised prime-side Gram kernel.

    ``K_ij = (P(a_i−a_j) + P(a_j−a_i)) / 2`` with
    ``P(c) = Σ_{n≤N} Λ(n) n^{-1/2} h_c(log n)``.  The symmetrisation is the
    one used by ``gaussianGramEntry``; it makes the matrix symmetric.

    Each scalar term of ``P`` is nonnegative, but the matrix need not be PSD:
    the Gaussian bump is not a positive-definite function of
    ``(a_i − a_j)`` once the shift ``log n`` is present.  This is the
    computation behind the scouting note on objective 1.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if n_max < 2:
        return [[0.0 for _ in a] for _ in a]

    def shifted(c: float) -> float:
        return sum(
            von_mangoldt(n) / math.sqrt(n) * gaussian_bump(c, sigma, math.log(n))
            for n in range(2, n_max + 1)
        )

    n = len(a)
    return [
        [
            0.5 * (shifted(a[i] - a[j]) + shifted(a[j] - a[i]))
            for j in range(n)
        ]
        for i in range(n)
    ]


def symmetric_eigenvalues(matrix: list[list[float]]) -> list[float]:
    """Eigenvalues of a real symmetric matrix, via ``mpmath.eigsy``."""
    m = mpmath.matrix(matrix)
    E, _ = mpmath.eigsy(m)
    return [float(E[i]) for i in range(E.rows)]


# ---------------------------------------------------------------------------
# 3. The off-line block
# ---------------------------------------------------------------------------

def offline_quad(c: float, sigma: float, delta: float, gamma: float) -> float:
    """The closed form of the Lean ``offLineQuad`` real part ``S(c)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    a = 2 * PI * sigma ** 2 * math.exp(sigma ** 2 * (delta ** 2 - gamma ** 2))
    theta = 2 * sigma ** 2 * delta * gamma
    return 2 * a * (
        math.exp(c * delta) * math.cos(c * gamma + theta)
        + math.exp(-c * delta) * math.cos(c * gamma - theta)
    )


def diag_block_eigenvalues(a: float, b: float) -> tuple[float, float]:
    """Eigenvalues of ``[[a, b], [b, a]]``: ``a − |b|`` and ``a + |b|``."""
    return (a - abs(b), a + abs(b))


def diag_block_psd(a: float, b: float) -> bool:
    """PSD test ``|b| ≤ a`` for the symmetric diagonal block."""
    return abs(b) <= a


# ---------------------------------------------------------------------------
# 4. Margin transfer and deformation
# ---------------------------------------------------------------------------

def admissible_epsilon(margin: float, n: int) -> float:
    """The entrywise margin allowed by ``ε · n < margin``.

    For the 4×4 certificate ``margin = 227/10000``.  The admissible
    ``ε`` decays like ``margin / n``; this is why the finite certificate
    does not scale to the infinite form.
    """
    if margin <= 0:
        raise ValueError("margin must be positive")
    if n < 1:
        raise ValueError("n must be positive")
    return margin / n


def convex_combination(a1: float, b1: float, a2: float, b2: float, t: float) -> tuple[float, float]:
    """Eigenvalues of ``t·A + (1−t)·B`` for two symmetric diagonal blocks.

    ``A = [[a1, b1], [b1, a1]]`` and ``B = [[a2, b2], [b2, a2]]``.
    """
    if not 0 <= t <= 1:
        raise ValueError("t must lie in [0, 1]")
    a = t * a1 + (1 - t) * a2
    b = t * b1 + (1 - t) * b2
    return diag_block_eigenvalues(a, b)


def convex_combination_psd(a1: float, b1: float, a2: float, b2: float, t: float) -> bool:
    """PSD test for the convex combination of two PSD blocks."""
    lo, hi = convex_combination(a1, b1, a2, b2, t)
    return lo >= 0 and hi >= 0


# ---------------------------------------------------------------------------
# 5. O2 first round: linear paths, congruences, no-crossing
# ---------------------------------------------------------------------------

def diag_block(a: float, b: float) -> tuple[tuple[float, float], tuple[float, float]]:
    """The symmetric diagonal block ``[[a, b], [b, a]]``."""
    return ((a, b), (b, a))


def lambda_min_diag_block(a: float, b: float) -> float:
    """The least eigenvalue of ``[[a, b], [b, a]]``: ``a − |b|``."""
    return a - abs(b)


def diag_block_linear(a: float, b: float, p: float, q: float, t: float) -> tuple[tuple[float, float], tuple[float, float]]:
    """The linear path ``[[a, b], [b, a]] + t·[[p, q], [q, p]]``."""
    return ((a + t * p, b + t * q), (b + t * q, a + t * p))


def linear_path_criterion(a: float, b: float, p: float, q: float) -> bool:
    """``|b| ≤ a`` and ``|q| ≤ p``: the criterion of `linear_path_posSemidef_iff`."""
    return abs(b) <= a and abs(q) <= p


def linear_path_psd_by_sampling(a: float, b: float, p: float, q: float,
                                t_max: float = 100.0, steps: int = 2000) -> bool:
    """Sample ``λ_min`` on ``[0, t_max]`` and check it is nonnegative."""
    if t_max <= 0 or steps < 2:
        raise ValueError("t_max must be positive and steps at least 2")
    for k in range(steps + 1):
        t = t_max * k / steps
        if lambda_min_diag_block(a + t * p, b + t * q) < -1e-12:
            return False
    return True


def sandwich_2x2(a: float, b: float, d: float, s1: float, s2: float) -> list[list[float]]:
    """``S A Sᵀ`` for ``A = [[a, b], [b, d]]`` and ``S = diag(s1, s2)``."""
    return [[s1 * s1 * a, s1 * s2 * b], [s1 * s2 * b, s2 * s2 * d]]


# ---------------------------------------------------------------------------
# 6. O2/O3 second round: the sigma derivative and the uniform-gap test
# ---------------------------------------------------------------------------

def dpole_term(c: float, sigma: float) -> float:
    """``d/dσ`` of ``pole_term``: ``4π e^{σ²/4}(2σ + σ³/2) cosh(c/2)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return 4 * PI * math.exp(sigma ** 2 / 4) * (2 * sigma + sigma ** 3 / 2) * math.cosh(c / 2)


def dprime_side(c: float, sigma: float, n_max: int = 4000) -> float:
    """``d/dσ`` of the von Mangoldt contribution."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if n_max < 2:
        return 0.0
    total = 0.0
    for n in range(2, n_max + 1):
        lam = von_mangoldt(n)
        if lam == 0.0:
            continue
        v = math.log(n)
        e = math.exp(-((v - c) ** 2) / (4 * sigma ** 2))
        total += lam / math.sqrt(n) * math.sqrt(PI) * e * (1 + (v - c) ** 2 / (2 * sigma ** 2))
    return total


def darchimedean_term(c: float, sigma: float) -> float:
    """``d/dσ`` of the archimedean density term.

    ``arch(σ) = σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt``, so
    ``arch′(σ) = 2σ ∫ (1 − σ²t²) e^{−σ²t²} cos(ct) Ω(t) dt``.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    T = 12.0 / sigma
    f = lambda t: (1 - (sigma * t) ** 2) * math.exp(-(sigma ** 2) * t ** 2) * math.cos(c * t) * archimedean_omega(t)
    return 2 * sigma * float(mpmath.quad(f, [-T, 0, T]))


def dweil_entry(c: float, sigma: float, n_max: int = 4000) -> float:
    """``d/dσ`` of ``weil_entry``."""
    return dpole_term(c, sigma) - 2 * dprime_side(c, sigma, n_max) + darchimedean_term(c, sigma)


def weil_kernel(c: float, sigma: float, n_max: int = 4000) -> float:
    """The symmetrised arithmetic kernel ``(W(c)+W(−c))/2``.

    Uses the evenness of the pole and archimedean terms:
    ``pole(c) − prime(c) − prime(−c) + arch(c)``.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return (pole_term(c, sigma) - prime_side(c, sigma, n_max)
            - prime_side(-c, sigma, n_max) + archimedean_term(c, sigma))


def dweil_kernel(c: float, sigma: float, n_max: int = 4000) -> float:
    """``d/dσ`` of the symmetrised kernel ``weil_kernel``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return (dpole_term(c, sigma) - dprime_side(c, sigma, n_max)
            - dprime_side(-c, sigma, n_max) + darchimedean_term(c, sigma))


def weil_gram(centres: list[float], sigma: float, n_max: int = 4000) -> list[list[float]]:
    """The symmetrised arithmetic Gram matrix on a family of centres."""
    n = len(centres)
    return [[weil_kernel(centres[i] - centres[j], sigma, n_max) for j in range(n)]
            for i in range(n)]


def dweil_gram(centres: list[float], sigma: float, n_max: int = 4000) -> list[list[float]]:
    """The σ-derivative of ``weil_gram``."""
    n = len(centres)
    return [[dweil_kernel(centres[i] - centres[j], sigma, n_max) for j in range(n)]
            for i in range(n)]


def min_eigenpair(matrix: list[list[float]]) -> tuple[float, list[float]]:
    """Least eigenvalue and a unit eigenvector, via ``mpmath.eigsy``."""
    E, Q = mpmath.eigsy(mpmath.matrix(matrix))
    n = len(matrix)
    vals = [float(E[i]) for i in range(n)]
    k = min(range(n), key=lambda i: vals[i])
    vec = [float(Q[i, k]) for i in range(n)]
    return vals[k], vec


def lambda_min_derivative(centres: list[float], sigma: float, n_max: int = 4000) -> float:
    """``dλ_min/dσ`` along the arithmetic Gram, via the minimising eigenvector."""
    _, v = min_eigenpair(weil_gram(centres, sigma, n_max))
    Kp = dweil_gram(centres, sigma, n_max)
    n = len(centres)
    return sum(v[i] * Kp[i][j] * v[j] for i in range(n) for j in range(n))


def toeplitz_weil_gram(n: int, sigma: float, half_width: float = 0.3,
                       n_max: int = 4000) -> list[list[float]]:
    """The Toeplitz Gram matrix on ``n`` equally spaced centres in ``[−h, h]``."""
    if n < 2:
        raise ValueError("n must be at least 2")
    h = 2 * half_width / (n - 1)
    ker = [weil_kernel(k * h, sigma, n_max) for k in range(n)]
    return [[ker[abs(i - j)] for j in range(n)] for i in range(n)]


def toeplitz_lambda_min(n: int, sigma: float, half_width: float = 0.3,
                        n_max: int = 4000) -> float:
    """Least eigenvalue of the Toeplitz Gram matrix."""
    return min_eigenpair(toeplitz_weil_gram(n, sigma, half_width, n_max))[0]


# ---------------------------------------------------------------------------
# 7. Audit of the angular-partition-method against the tail bound
# ---------------------------------------------------------------------------

def geometric_tail_radius(r: float, n: int) -> float:
    """The annular squared tail radius ``R_n² = r^n/(1−r)`` for ``a_k = r^k``.

    This is the closed-form case of the angular-partition representation.
    """
    if not -1.0 < r < 1.0:
        raise ValueError("|r| must be less than 1")
    if n < 0:
        raise ValueError("n must be non-negative")
    return r ** n / (1.0 - r)


def pseries_tail_radius(sigma: float, n: int) -> float:
    """The annular squared tail radius ``R_n² = ζ(σ, n+1)`` for ``a_k = (k+1)^{−σ}``.

    The radius is a named special function, not an elementary closed form.
    """
    if sigma <= 1.0:
        raise ValueError("sigma must be greater than 1 for convergence")
    if n < 0:
        raise ValueError("n must be non-negative")
    return float(mpmath.zeta(sigma, n + 1))


def on_line_weights(sigma: float, gammas: list[float]) -> list[float]:
    """The positive on-line Gram weights ``2πσ² exp(−σ²γ²)``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return [2 * PI * sigma ** 2 * math.exp(-(sigma ** 2) * g * g) for g in gammas]


def gram_entry_from_weights(weights: list[float], gammas: list[float], c: float) -> float:
    """The signed on-line Gram entry ``Σ w_k cos(cγ_k)``."""
    if len(weights) != len(gammas):
        raise ValueError("weights and gammas must have the same length")
    return sum(w * math.cos(c * g) for w, g in zip(weights, gammas))


# ---------------------------------------------------------------------------
# 8. The maximal-|δ| precondition of the full-block route
# ---------------------------------------------------------------------------

def max_abs_offline_quad(c_min: float, c_max: float, steps: int,
                         sigma: float, delta: float, gamma: float) -> float:
    """Max of ``|S(c)|`` for the off-line quadruple over a grid in ``c``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if steps < 1 or c_max <= c_min:
        raise ValueError("need steps ≥ 1 and c_max > c_min")
    return max(
        abs(offline_quad(c_min + (c_max - c_min) * k / steps, sigma, delta, gamma))
        for k in range(steps + 1)
    )


# ---------------------------------------------------------------------------
# 9. The arithmetic side: the smooth PNT main term of the prime sum
# ---------------------------------------------------------------------------

def prime_main_term(c: float, sigma: float) -> float:
    """The smooth-weight PNT main term ``2πσ² exp(σ²/4) exp(c/2)``.

    This is ``∫ e^{u/2} h_c(u) du`` for ``h_c(u) = √π σ exp(−(u−c)²/(4σ²))``,
    the main term of ``Σ Λ(n) n^{-1/2} h_c(log n)`` under ``dψ ≈ dx``.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return 2 * PI * sigma ** 2 * math.exp(sigma ** 2 / 4) * math.exp(c / 2)


def prime_main_ratio(c: float, sigma: float, n_max: int) -> float:
    """The ratio of the actual prime sum to its smooth main term."""
    main = prime_main_term(c, sigma)
    return prime_side(c, sigma, n_max) / main


def pole_minus_prime_main(c: float, sigma: float) -> float:
    """``pole(c) − prime_main(c)``: the residual half-pole ``2πσ² e^{σ²/4} e^{−c/2}``."""
    return pole_term(c, sigma) - prime_main_term(c, sigma)


# ---------------------------------------------------------------------------
# 10. The exact Gram-entry identity: pole = P_main(c) + P_main(−c)
# ---------------------------------------------------------------------------

def pole_main_identity_error(c: float, sigma: float) -> float:
    """The exact identity ``pole(c) = P_main(c) + P_main(−c)`` (should be zero)."""
    return pole_term(c, sigma) - prime_main_term(c, sigma) - prime_main_term(-c, sigma)


def prime_error(c: float, sigma: float, n_max: int = 4000) -> float:
    """The PNT error ``P(c) − P_main(c)`` of the Gaussian-window prime sum."""
    return prime_side(c, sigma, n_max) - prime_main_term(c, sigma)


def arithmetic_gram_entry(c: float, sigma: float, n_max: int = 4000) -> float:
    """The symmetrised arithmetic Gram entry as two PNT errors plus the archimedean term.

    Uses the exact identity ``pole(c) = P_main(c) + P_main(−c)``:
    ``K(c) = [P_main(c) − P(c)] + [P_main(−c) − P(−c)] + arch(c)``
    (written with the sign of ``prime_error`` made explicit).
    """
    return (-prime_error(c, sigma, n_max) - prime_error(-c, sigma, n_max)
            + archimedean_term(c, sigma))


# ---------------------------------------------------------------------------
# 11. The cancellation: PNT error and archimedean term are jointly positive
# ---------------------------------------------------------------------------

def prime_error_kernel(c: float, sigma: float, n_max: int = 4000) -> float:
    """The PNT-error part of the arithmetic Gram entry, ``−[err(c) + err(−c)]``."""
    return -prime_error(c, sigma, n_max) - prime_error(-c, sigma, n_max)


def arch_kernel(c: float, sigma: float) -> float:
    """The archimedean part of the arithmetic Gram entry."""
    return archimedean_term(c, sigma)


def kernel_gram(kernel, centres: list[float], sigma: float) -> list[list[float]]:
    """Build a Gram matrix from a scalar kernel ``kernel(c, sigma)``."""
    n = len(centres)
    return [[kernel(centres[i] - centres[j], sigma) for j in range(n)] for i in range(n)]


def toeplitz_kernel_gram(n: int, sigma: float, kernel, half_width: float = 0.3) -> list[list[float]]:
    """The Toeplitz Gram matrix of a scalar kernel on ``n`` equally spaced centres."""
    if n < 2:
        raise ValueError("n must be at least 2")
    h = 2 * half_width / (n - 1)
    ker = [kernel(k * h, sigma) for k in range(n)]
    return [[ker[abs(i - j)] for j in range(n)] for i in range(n)]


def prime_side_mass_bound(c: float, sigma: float, n_max: int) -> float:
    """The T41 bound `sqrt(pi) * sigma * sum_{n<n_max} Lambda(n+1)`."""
    if sigma < 0:
        raise ValueError("sigma must be nonnegative")
    mass = sum(von_mangoldt(k + 1) for k in range(n_max))
    return math.sqrt(math.pi) * sigma * mass
