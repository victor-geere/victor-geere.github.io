"""Certified finite shadow of the Weil Gram form on four Gaussians.

The shadow is the ``4 x 4`` Gram matrix of the Weil quadratic form on the
Gaussian test basis ``phi_a(u) = exp(-(u-a)^2/(2 sigma^2))`` with
``sigma = 0.05`` and centres ``-0.3, -0.1, 0.1, 0.3``.  Each entry is a
one-dimensional density integral plus a finite prime sum:

    G_ab = pole(a-b) + density(a-b) + (prime(a-b) + prime(b-a))/2.

``python/certify_shadow.py`` encloses the density integral with the certified
``Omega``-jet layer of ``prime-spectrum-tensor`` and records the interval
matrix in ``weil_certificate.json``.  This module verifies that certificate
with exact rational arithmetic and supplies the analytic pieces that can be
checked quickly:

* a self-contained interval enclosure of
  ``Omega(t) = Re psi(1/4 + i t/2) - log pi`` (vendored from
  ``../prime-spectrum-tensor/python/programme.py`` with the same constants);
* numerical evaluations of the Gaussian ``W``, used only as cross-checks.

The finite shadow is not a proof of RH and not a statement about the infinite
Weil cone.  It certifies that the four-dimensional Gram matrix is positive
definite, which is the finite positivity of the intersection form on this
subspace.
"""

from __future__ import annotations

import json
from decimal import Decimal
from fractions import Fraction
from pathlib import Path

import mpmath as mp
import sympy as sp

HERE = Path(__file__).resolve().parent
CERT_PATH = HERE / "weil_certificate.json"

__all__ = [
    "CERT_PATH",
    "load_certificate",
    "interval_matrix",
    "centre_and_slack",
    "leading_minors",
    "ldl_pivots",
    "ldl_factorization",
    "rational_factorization_ok",
    "box_data",
    "numerical_matrix",
    "box_contains",
    "box_hypotheses_ok",
    "certificate_ok",
    "contains",
    "omega_enclosure",
    "omega_density",
    "gaussian_convolution",
    "weil_gaussian_pole",
    "weil_gaussian_density",
    "weil_gaussian_prime",
    "weil_gaussian_W",
    "weil_gaussian_cross",
    "numerical_gram",
]


# ---------------------------------------------------------------------------
# Certificate verification (exact rational arithmetic)
# ---------------------------------------------------------------------------

def load_certificate(path: Path | str = CERT_PATH) -> dict:
    """Load the recorded JSON certificate."""
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    required = {"gram", "sigma", "centres", "margin", "operator_slack"}
    missing = required - set(data)
    if missing:
        raise ValueError(f"certificate is missing keys: {sorted(missing)}")
    if len(data["gram"]) != 4 or any(len(row) != 4 for row in data["gram"]):
        raise ValueError("the recorded Gram matrix is not 4 x 4")
    return data


def interval_matrix(cert: dict) -> list[list[tuple[Fraction, Fraction]]]:
    """Exact rational endpoints of the recorded interval Gram matrix."""
    return [[(Fraction(lo), Fraction(hi)) for lo, hi in row]
            for row in cert["gram"]]


def centre_and_slack(
        G: list[list[tuple[Fraction, Fraction]]],
        conversion_slack: Fraction = Fraction(1, 10**9),
) -> tuple[sp.Matrix, Fraction]:
    """Centre matrix and the operator-norm slack ``t``.

    For any symmetric matrix ``A`` with entries in the intervals ``G``,
    ``||A - G0||_2 <= max_i sum_j (hi_ij - lo_ij)/2``.  The conversion slack
    covers decimal-to-rational endpoint rounding.
    """
    n = len(G)
    centres = [[(G[i][j][0] + G[i][j][1]) / 2 for j in range(n)]
               for i in range(n)]
    half = [[(G[i][j][1] - G[i][j][0]) / 2 for j in range(n)]
            for i in range(n)]
    t = max(sum(half[i][j] for j in range(n)) for i in range(n))
    t += conversion_slack
    M = sp.Matrix(n, n, lambda i, j: sp.Rational(centres[i][j].numerator,
                                                 centres[i][j].denominator))
    return M, t


def leading_minors(M: sp.Matrix) -> list:
    """Leading principal minors of a square sympy matrix, exactly."""
    return [sp.Matrix(M[:k, :k]).det() for k in range(1, M.rows + 1)]


def ldl_factorization(M: sp.Matrix) -> tuple[sp.Matrix, list]:
    """Exact rational LDL^T factorisation, with no square roots.

    Returns a unit lower-triangular ``L`` and a diagonal ``d`` with
    ``M = L * diag(d) * L^T``.  A zero pivot is returned as a zero entry of
    ``d``; the caller checks positivity.
    """
    n = M.rows
    A = [[sp.Rational(M[i, j]) for j in range(n)] for i in range(n)]
    L = [[sp.Integer(0)] * n for _ in range(n)]
    for i in range(n):
        L[i][i] = sp.Integer(1)
    d = []
    for k in range(n):
        pivot = A[k][k]
        d.append(pivot)
        if pivot == 0:
            continue
        for i in range(k + 1, n):
            lik = A[i][k] / pivot
            L[i][k] = lik
            for j in range(k + 1, n):
                A[i][j] -= lik * A[k][j]
    return sp.Matrix(n, n, lambda i, j: L[i][j]), d


def ldl_pivots(M: sp.Matrix) -> list:
    """Exact LDL^T pivots (no square roots)."""
    return ldl_factorization(M)[1]


def certificate_ok(
        G: list[list[tuple[Fraction, Fraction]]],
        conversion_slack: Fraction = Fraction(1, 10**9),
) -> tuple[bool, Fraction, list, list]:
    """Centre/error PSD certificate.

    If ``G0`` is the centre, ``t`` the row-sum slack, and ``G0 - t I`` has
    positive leading principal minors, then every symmetric matrix in the
    interval box is positive definite.  Returns
    ``(ok, t, minors, pivots)``.
    """
    M, t = centre_and_slack(G, conversion_slack)
    P = M - sp.Rational(t.numerator, t.denominator) * sp.eye(M.rows)
    minors = leading_minors(P)
    pivots = ldl_pivots(P)
    ok = all(m > 0 for m in minors) and all(p > 0 for p in pivots)
    return ok, t, minors, pivots


def rational_factorization_ok(
        G: list[list[tuple[Fraction, Fraction]]],
        L, d,
        conversion_slack: Fraction = Fraction(1, 10**9),
) -> bool:
    """Verify an exact rational LDL^T certificate.

    ``L`` must be unit lower triangular, ``d`` positive, and
    ``L * diag(d) * L^T`` must equal the centre matrix ``G0`` minus the
    operator slack ``t I``.  Then ``G0 - tI`` is positive definite by the
    Lean theorem `IntersectionForm.ldl_posDef`.
    """
    n = len(G)
    M, t = centre_and_slack(G, conversion_slack)
    P = M - sp.Rational(t.numerator, t.denominator) * sp.eye(n)
    Lm = sp.Matrix(L)
    if Lm.rows != n or Lm.cols != n or len(d) != n:
        return False
    if Lm * sp.diag(*d) * Lm.T != P:
        return False
    for i in range(n):
        if Lm[i, i] != 1:
            return False
        for j in range(i + 1, n):
            if Lm[i, j] != 0:
                return False
    if Lm.det() != 1:
        return False
    return all(x > 0 for x in d)


def box_data(cert: dict):
    """Exact centre ``G0``, half-widths ``E`` and operator slack ``t``.

    The box is ``G0 ± E``; ``t`` is the maximum row sum of ``E`` plus the
    ``10⁻⁹`` conversion slack, matching ``centre_and_slack``.
    """
    G = interval_matrix(cert)
    n = len(G)
    G0 = [[(G[i][j][0] + G[i][j][1]) / 2 for j in range(n)]
          for i in range(n)]
    E = [[(G[i][j][1] - G[i][j][0]) / 2 for j in range(n)]
         for i in range(n)]
    t = max(sum(E[i][j] for j in range(n)) for i in range(n))
    t += Fraction(1, 10**9)
    return G0, E, t


def numerical_matrix(cert: dict):
    """The recorded 30-digit numerical Gram matrix, as exact rationals."""
    return [[Fraction(Decimal(s)) for s in row]
            for row in cert["numerical"]["gram"]]


def box_contains(G0, E, A) -> bool:
    """Whether ``|A_ij - G0_ij| <= E_ij`` holds entrywise."""
    n = len(G0)
    return all(abs(A[i][j] - G0[i][j]) <= E[i][j]
               for i in range(n) for j in range(n))


def box_hypotheses_ok(cert: dict) -> dict:
    """Check the hypotheses of the Lean interval theorem on the certificate.

    Returns a dict with the entrywise containment, the row-sum bound, the
    centre/factorisation identity ``G0 = P + t I``, and symmetry of ``A``.
    """
    import sympy as sp

    G0, E, t = box_data(cert)
    A = numerical_matrix(cert)
    n = len(G0)
    row_ok = all(sum(E[i][j] for j in range(n)) <= t for i in range(n))
    sym_ok = all(A[i][j] == A[j][i] for i in range(n) for j in range(n))
    P = sp.Matrix([[sp.Rational(s) for s in row] for row in cert["ldl"]["P"]])
    centre_ok = all(
        sp.Rational(G0[i][j].numerator, G0[i][j].denominator)
        == P[i, j] + (sp.Rational(t.numerator, t.denominator) if i == j else 0)
        for i in range(n) for j in range(n))
    return {
        "box_contains": box_contains(G0, E, A),
        "row_sums": row_ok,
        "symmetric": sym_ok,
        "centre_is_P_plus_tI": centre_ok,
        "t": t,
        "E": E,
        "G0": G0,
    }


def contains(interval: tuple[Fraction, Fraction], value) -> bool:
    """Whether the exact rational interval contains ``value``."""
    if isinstance(value, str):
        value = Fraction(Decimal(value))
    elif isinstance(value, float):
        value = Fraction(value)
    return interval[0] <= value <= interval[1]


# ---------------------------------------------------------------------------
# Rigorous interval enclosure of Omega(t)
# ---------------------------------------------------------------------------
# Vendored from ../prime-spectrum-tensor/python/programme.py (C9).  The
# constants match the recorded certificate; the enclosure uses mpmath's
# directed-rounding interval arithmetic.

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
    u = (mp.iv.mpf([a, b]), mp.iv.mpf([1, 1]))
    tt = mp.mpf(t)
    B = tt / 4
    A = _iv_add(_iv_mul(u, u), _iv_const(mp.mpf(1) / 16 - tt * tt / 4))
    den = _iv_add(_iv_mul(A, A), _iv_const(B * B))
    return _iv_mul(A, _iv_inv(den))


def _omega_K_dual(a, b, t):
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
    u = (mp.iv.mpf([a, b]), mp.iv.mpf([1, 1]))
    c0 = _iv_const(1 / (2 * mp.pi))
    c1 = _iv_const(-mp.mpf(1) / 2)
    c2 = _iv_const(mp.pi / 6)
    s = _iv_add(c0, _iv_add(_iv_mul(c1, u), _iv_mul(c2, _iv_mul(u, u))))
    return _iv_mul(_omega_J_dual(a, b, t), s)


def omega_enclosure(t, h=0.005, delta=0.01, U=10):
    """Rigorous enclosure of ``Omega(t) = Re psi(1/4 + i t/2) - log pi``.

    ``h`` is the midpoint step on ``[delta, U]``, ``delta`` the switch to the
    series for ``u/(e^{2 pi u}-1)``, and ``U`` the exponential tail cutoff.
    Returns an ``mpmath.iv.mpf`` interval.
    """
    tt = mp.mpf(t)
    h = mp.mpf(h)
    delta = mp.mpf(delta)
    U = mp.mpf(U)
    total = mp.iv.mpf([0, 0])

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
    remainder = 16 * 10 * delta**5 / 5
    total += mp.iv.mpf([-remainder, remainder])

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

    tail = 32 * mp.e**(-2 * mp.pi * U) * (U / (2 * mp.pi)
                                          + 1 / (2 * mp.pi) ** 2)
    total += mp.iv.mpf([-tail, tail])

    c = mp.mpf(1) / 16 + tt * tt / 4
    base = mp.log(mp.sqrt(c)) - 1 / (8 * c) - mp.log(mp.pi)
    return mp.iv.mpf([base, base]) - 2 * total


def omega_density(t):
    """Numerical ``Omega(t)`` by the digamma representation (cross-check)."""
    return mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * mp.mpf(t) / 2).real - mp.log(mp.pi)


# ---------------------------------------------------------------------------
# Numerical Gaussian W (cross-checks; not the certificate)
# ---------------------------------------------------------------------------

def gaussian_convolution(a, b, sigma, v):
    a, b, sigma, v = map(mp.mpf, (a, b, sigma, v))
    return mp.sqrt(mp.pi) * sigma * mp.exp(-((v - (a - b)) ** 2) / (4 * sigma**2))


def weil_gaussian_pole(c, sigma):
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    return 4 * mp.pi * sigma**2 * mp.exp(sigma**2 / 4) * mp.cosh(c / 2)


def weil_gaussian_density(c, sigma):
    c, sigma = mp.mpf(c), mp.mpf(sigma)
    integrand = lambda t: (mp.exp(-(sigma * t) ** 2) * mp.cos(c * t)
                           * omega_density(t))
    points = [-200, -100, -50, -25, -10, 0, 10, 25, 50, 100, 200]
    return sigma**2 * mp.quad(integrand, points, maxdegree=4)


_PRIME_DATA = None


def _prime_power_data(X=20000):
    global _PRIME_DATA
    if _PRIME_DATA is not None:
        return _PRIME_DATA
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
    _PRIME_DATA = tuple(data)
    return _PRIME_DATA


def weil_gaussian_prime(c, sigma, X=20000):
    c = mp.mpf(c)
    total = mp.mpf(0)
    for weight, v in _prime_power_data(X):
        total += weight * gaussian_convolution(c, 0, sigma, v)
    return -2 * total


def weil_gaussian_W(c, sigma, X=20000):
    return (weil_gaussian_pole(c, sigma)
            + weil_gaussian_density(c, sigma)
            + weil_gaussian_prime(c, sigma, X))


def weil_gaussian_cross(a, b, sigma, X=20000):
    c = mp.mpf(a) - mp.mpf(b)
    return (weil_gaussian_W(c, sigma, X) + weil_gaussian_W(-c, sigma, X)) / 2


def numerical_gram(centres, sigma, X=20000):
    """Numerical Gram matrix (mpmath); a cross-check, not a certificate."""
    return [[weil_gaussian_cross(a, b, sigma, X) for b in centres]
            for a in centres]
