import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    GAMMA_1,
    PI,
    atomic_kernel,
    fhat0,
    g0,
    gram_form,
    mode_sq_sum,
    phi_series,
    phi_term,
    pole_weight,
    prime_current,
    prime_weight,
    von_mangoldt,
)


def test_von_mangoldt_exact_and_edge_cases():
    assert von_mangoldt(0) == 0
    assert von_mangoldt(1) == 0
    assert sp.simplify(von_mangoldt(2) - sp.log(2)) == 0
    assert sp.simplify(von_mangoldt(8) - sp.log(2)) == 0
    assert sp.simplify(von_mangoldt(9) - sp.log(3)) == 0
    assert von_mangoldt(6) == 0
    assert von_mangoldt(12) == 0
    with pytest.raises(ValueError):
        von_mangoldt(-1)


def test_prime_weights_are_nonnegative():
    for n in range(2, 60):
        assert sp.N(prime_weight(n), 30) >= 0
    # The finite prime current is non-negative on the constant test function.
    value = sp.N(prime_current(lambda x: sp.Integer(1), 40), 30)
    assert value > 0
    # Empty truncations contribute nothing.
    assert prime_current(lambda x: sp.Integer(1), 1) == 0


def test_pole_weight_identity_is_exact():
    gamma = sp.symbols("gamma", real=True)
    lhs = sp.Abs(fhat0(sp.I / 2, gamma)) ** 2
    target = pole_weight(gamma)
    difference = sp.simplify(sp.expand((lhs - target).rewrite(sp.exp)))
    assert difference == 0


def test_witness_convolution_matches_closed_form():
    mp.mp.dps = 30
    gamma = mp.mpf("14.1347251417346937904572519836")

    def f0(u):
        return (2 / mp.sqrt(mp.pi)) * mp.exp(-(u**2)) * mp.cos(gamma * u)

    for v in (mp.mpf("0.3"), mp.mpf("0.7"), mp.mpf("1.1")):
        direct = mp.quad(lambda u: f0(u) * f0(v - u), [-8, v / 2, 8])
        closed = mp.sqrt(2 / mp.pi) * mp.exp(-(v**2) / 2) * (
            mp.cos(gamma * v) + mp.exp(-(gamma**2) / 2))
        assert abs(direct - closed) < mp.mpf("1e-20")


def test_theorem_b_witness_is_negative():
    """Theorem B's strict negativity, computed directly from primes and Phi."""
    mp.mp.dps = 25
    gamma = mp.mpf("14.1347251417346937904572519836")
    X = 20000

    def g(v):
        return mp.sqrt(2 / mp.pi) * mp.exp(-(v**2) / 2) * (
            mp.cos(gamma * v) + mp.exp(-(gamma**2) / 2))

    def phi(u):
        u = abs(u)
        total = mp.mpf(0)
        e2u = mp.exp(2 * u)
        for n in range(1, 14):
            total += (
                2 * mp.pi**2 * n**4 * mp.exp(mp.mpf(9) * u / 2)
                - 3 * mp.pi * n**2 * mp.exp(mp.mpf(5) * u / 2)
            ) * mp.exp(-mp.pi * n**2 * e2u)
        return total

    sieve = bytearray([1]) * (X + 1)
    sieve[0] = sieve[1] = 0
    for p in range(2, int(X**0.5) + 1):
        if sieve[p]:
            for multiple in range(p * p, X + 1, p):
                sieve[multiple] = 0

    pi_g = mp.mpf(0)
    for p in range(2, X + 1):
        if sieve[p]:
            log_p = mp.log(p)
            power = p
            while power <= X:
                pi_g += log_p * g(mp.log(power)) / mp.sqrt(power)
                power *= p

    theta_g = 2 * mp.quad(
        lambda u: phi(u) * g(u),
        [0, mp.mpf("0.5"), 1, mp.mpf("1.5"), 2, mp.mpf("2.6"), mp.mpf("3.8")],
    )
    # tensor.md Theorem B: Pi = -0.6776451473..., Theta = +0.0003426692...,
    # total = -0.6773024781... < 0.
    assert abs(pi_g + mp.mpf("0.6776451473")) < mp.mpf("1e-6")
    assert theta_g > 0
    assert pi_g + theta_g < mp.mpf("-0.6")
    assert abs(pi_g + theta_g + mp.mpf("0.6773024781")) < mp.mpf("1e-8")


def test_jacobi_terms_and_series_are_positive():
    for n in range(1, 6):
        for u in (sp.Integer(0), sp.Rational(1, 2), sp.Integer(2)):
            assert sp.N(phi_term(n, u), 30) > 0
    # The truncated density is positive as well (each term is positive).
    assert sp.N(phi_series(sp.Rational(1, 3), 8), 30) > 0
    assert phi_series(sp.Integer(1), 0) == 0
    with pytest.raises(ValueError):
        phi_term(0, sp.Integer(0))


def test_finite_gram_form_is_nonnegative_and_matches_modes():
    weights = [sp.Rational(1, 2), sp.Rational(3, 2), sp.Integer(1)]
    freqs = [sp.Integer(1), sp.Integer(2), sp.Rational(5, 2)]
    points = [sp.Rational(0), sp.Rational(1, 3), sp.Rational(2, 3)]
    coeffs = [sp.Integer(1), sp.I, sp.Rational(1, 2) - sp.I]

    form = gram_form(weights, freqs, points, coeffs)
    modal = mode_sq_sum(weights, freqs, points, coeffs)
    assert abs(complex(sp.N(form, 30)) - complex(sp.N(modal, 30))) < 1e-20
    assert sp.N(sp.re(form), 30) >= -sp.Float("1e-25")

    # Edge case: no test points gives the zero form.
    assert gram_form(weights, freqs, [], []) == 0
    with pytest.raises(ValueError):
        atomic_kernel([sp.Integer(1)], [sp.Integer(1), sp.Integer(2)], sp.Integer(0))


# ---------------------------------------------------------------------------
# Finite Weil Gram matrix on a Gaussian basis (numerical, not certified)
# ---------------------------------------------------------------------------

from programme import (  # noqa: E402
    gaussian_convolution,
    gram_eigenvalues,
    weil_gaussian_W,
    weil_gaussian_density,
    weil_gaussian_gram,
    weil_gaussian_prime,
)


def test_gaussian_weil_gram_is_positive_and_prime_active():
    """A 4x4 smooth-basis Gram matrix is numerically positive definite.

    This is a finite probe, not a certificate: ``Omega`` is evaluated by
    quadrature, not enclosed.  The prime side is genuinely active at
    separation 0.6, where ``-2 Pi(h)`` is about ``-0.0365``.
    """
    mp.mp.dps = 30
    for fn in (weil_gaussian_density, weil_gaussian_prime, weil_gaussian_W):
        fn.cache_clear()

    # Closed-form reflected convolution: the amplitude is sqrt(pi) sigma.
    value = gaussian_convolution("0.2", "-0.1", "0.05", "0.3")
    target = mp.sqrt(mp.pi) * mp.mpf("0.05")
    assert abs(value - target) < mp.mpf("1e-30")

    centers = [-0.3, -0.1, 0.1, 0.3]
    G = weil_gaussian_gram(centers, 0.05)
    # Symmetry and the known diagonal W(sigma) at sigma = 0.05.
    assert max(abs(G[i, j] - G[j, i]) for i in range(4) for j in range(4)) < mp.mpf("1e-13")
    assert abs(G[0, 0] - mp.mpf("0.043135958394838")) < mp.mpf("1e-10")

    # The prime term is not a rounding artefact at c = 0.6.
    assert weil_gaussian_prime(0.6, 0.05) < mp.mpf("-0.03")

    # Numerical Cholesky mirrors T10: positive pivots and reconstruction.
    ev = gram_eigenvalues(G)
    assert ev[0] > mp.mpf("0.02")
    L = mp.cholesky(G)
    assert all(L[i, i] > 0 for i in range(4))
    err = max(abs((L * L.T)[i, j] - G[i, j]) for i in range(4) for j in range(4))
    assert err < mp.mpf("1e-24")

    # Rational shadow: a nearby M = L_rat L_rat^T is PSD exactly (T10).
    Lr = sp.Matrix(4, 4, lambda i, j: sp.Rational(
        mp.nstr(L[i, j], 20)).limit_denominator(10**6))
    shadow = Lr * Lr.T
    shadow_err = max(
        abs(float(shadow[i, j]) - float(G[i, j]))
        for i in range(4) for j in range(4)
    )
    assert shadow_err < 1e-10
    assert all(Lr[i, i] > 0 for i in range(4))
    assert all(sp.simplify(shadow[i, i]) > 0 for i in range(4))


# ---------------------------------------------------------------------------
# Rigorous interval enclosure of Omega (first layer)
# ---------------------------------------------------------------------------

from programme import omega_interval  # noqa: E402


def test_omega_interval_encloses_digamma():
    """The interval layer contains Re psi(1/4+it/2) - log pi.

    The layer is rigorous by construction (outward-rounded mpmath.iv,
    midpoint/derivative bounds, series remainder, exponential tail).  This
    test checks containment and width on representative t; it does not yet
    integrate the density term.
    """
    mp.mp.dps = 30
    for t in (0, mp.mpf("0.5"), 1, 10):
        iv = omega_interval(t)
        true = (mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * mp.mpf(t) / 2).real
                - mp.log(mp.pi))
        assert iv.a <= true <= iv.b
        assert iv.b - iv.a < mp.mpf("0.05")


# ---------------------------------------------------------------------------
# Prime-tail bound for the Gaussian window
# ---------------------------------------------------------------------------

from programme import gaussian_prime_tail_bound  # noqa: E402


def test_gaussian_prime_tail_bound_is_negligible():
    """The crude Gaussian prime-tail bound is far below the matrix margin."""
    mp.mp.dps = 30
    for c in (0, mp.mpf("0.6"), mp.mpf("-0.6")):
        bound = gaussian_prime_tail_bound(c, mp.mpf("0.05"))
        assert bound < mp.mpf("1e-100")
    # The numerical difference between two truncations is below the bound.
    tail = abs(weil_gaussian_prime(0.6, 0.05, 40000)
               - weil_gaussian_prime(0.6, 0.05, 20000))
    assert tail < gaussian_prime_tail_bound(0.6, 0.05)


# ---------------------------------------------------------------------------
# Deterministic density quadrature prototype
# ---------------------------------------------------------------------------

from programme import weil_gaussian_density_simpson  # noqa: E402


def test_gaussian_density_simpson_matches_quadrature():
    """The rational-node Simpson rule reproduces the adaptive quadrature.

    This is the rule intended for a future derivative-bound certificate; the
    test checks the numerical rule, not a rigorous error bound.
    """
    mp.mp.dps = 30
    for c in (0, mp.mpf("0.6")):
        approx = weil_gaussian_density_simpson(c, 0.05, n=4000, T=200)
        reference = weil_gaussian_density(c, 0.05)
        assert abs(approx - reference) < mp.mpf("1e-8")


# ---------------------------------------------------------------------------
# Numerical fourth-derivative diagnostic
# ---------------------------------------------------------------------------

from programme import gaussian_density_fourth_derivative  # noqa: E402


def test_gaussian_density_fourth_derivative_is_bounded():
    """The numerical fourth derivative is O(10^3), setting the Simpson target."""
    mp.mp.dps = 30
    values = [gaussian_density_fourth_derivative(0.6, 0.05, t)
              for t in (0, 1, 10)]
    assert all(v < mp.mpf("1e4") for v in values)
    assert values[0] > 100


# ---------------------------------------------------------------------------
# Interval t-jet layer
# ---------------------------------------------------------------------------

from jet import Jet  # noqa: E402
from programme import omega_t_jet  # noqa: E402


def test_interval_jet_derivatives_match_elementary_functions():
    """The derivative representation is checked against analytic values."""
    mp.mp.dps = 30
    t = Jet.variable(mp.mpf("0.3"), 5)
    e = t.exp()
    for n in range(6):
        assert abs(mp.mpf(e[n].a) - mp.e**mp.mpf("0.3")) < mp.mpf("1e-13")
    l = (t + 1).log()
    assert abs(mp.mpf(l[1].a) - 1 / mp.mpf("1.3")) < mp.mpf("1e-13")
    c, s = t.cos_sin()
    assert abs(mp.mpf(c[1].a) + mp.sin(mp.mpf("0.3"))) < mp.mpf("1e-13")
    assert abs(mp.mpf(s[1].a) - mp.cos(mp.mpf("0.3"))) < mp.mpf("1e-13")


def test_omega_t_jet_contains_numeric_derivatives():
    """The jet encloses Omega and its first four t-derivatives at t=0.5."""
    mp.mp.dps = 30
    jet = omega_t_jet(mp.mpf("0.5"), order=4, h=0.01, U=5)
    f = lambda u: mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * u / 2).real - mp.log(mp.pi)
    for n in range(5):
        true = mp.diff(f, mp.mpf("0.5"), n)
        assert jet[n].a <= true <= jet[n].b


# ---------------------------------------------------------------------------
# Certified Taylor density panels
# ---------------------------------------------------------------------------

from programme import gaussian_density_panel_taylor, omega_density  # noqa: E402


def test_gaussian_density_panel_taylor_encloses_true_integral():
    """The Taylor panel interval plus remainder contains the true integral."""
    mp.mp.dps = 30
    sigma = mp.mpf("0.05")
    c = mp.mpf("0.6")
    for a, b in [(mp.mpf("0.4"), mp.mpf("0.6")),
                 (mp.mpf(10), mp.mpf("10.2")),
                 (mp.mpf(0), mp.mpf("0.2")),
                 (mp.mpf("0.2"), mp.mpf("0.4"))]:
        value, error = gaussian_density_panel_taylor(a, b, c, sigma)
        f = lambda t: (mp.exp(-(sigma * t) ** 2) * mp.cos(c * t)
                       * omega_density(t))
        true = sigma**2 * mp.quad(f, [a, (a + b) / 2, b], maxdegree=8)
        assert value.a - error <= true <= value.b + error


# ---------------------------------------------------------------------------
# Assembled certified density interval
# ---------------------------------------------------------------------------

from programme import gaussian_density_certified  # noqa: E402


def test_gaussian_density_certified_short_range():
    """Ten certified panels enclose the density integral on [-1,1]."""
    mp.mp.dps = 30
    sigma = mp.mpf("0.05")
    c = mp.mpf("0.6")
    interval, error, panels = gaussian_density_certified(
        c, sigma, H=mp.mpf("0.2"), T=mp.mpf(1), order=4)
    assert panels == 10
    f = lambda t: (mp.exp(-(sigma * t) ** 2) * mp.cos(c * t)
                   * omega_density(t))
    true = sigma**2 * mp.quad(f, [-1, -0.5, 0, 0.5, 1], maxdegree=8)
    assert interval.a - error <= true <= interval.b + error


# ---------------------------------------------------------------------------
# Multi-c certified density intervals
# ---------------------------------------------------------------------------

from programme import gaussian_density_certified_multi  # noqa: E402


def test_gaussian_density_certified_multi_short_range():
    """Two c-values share the Ω jets and both enclosures contain the truth."""
    mp.mp.dps = 30
    sigma = mp.mpf("0.05")
    results, panels = gaussian_density_certified_multi(
        [0, mp.mpf("0.6")], sigma, H=mp.mpf("0.2"), T=1)
    assert panels == 10
    for (interval, error), c in zip(results, [0, mp.mpf("0.6")]):
        f = lambda t: (mp.exp(-(sigma * t) ** 2) * mp.cos(c * t)
                       * omega_density(t))
        true = sigma**2 * mp.quad(f, [-1, -0.5, 0, 0.5, 1], maxdegree=8)
        assert interval.a - error <= true <= interval.b + error


# ---------------------------------------------------------------------------
# Exact PSD certificate for the recorded H=0.08 interval Gram matrix
# ---------------------------------------------------------------------------

from certify_gram import interval_psd_certificate  # noqa: E402


def test_h008_interval_gram_center_error_certificate():
    """Center-plus-operator-norm certificate for the H=0.08 matrix.

    The intervals are the output of the full H=0.08, T=100 certified density
    run recorded in the note.  The check is exact rational linear algebra on
    the center, with a 1e-9 slack for endpoint conversion.
    """
    mp.mp.dps = 30
    iv = mp.iv.mpf
    margin = mp.mpf("1e-4")
    D = iv([mp.mpf("0.03756591458571154063") - margin,
            mp.mpf("0.04863992698909350848") + margin])
    A = iv([mp.mpf("-0.021730257299852711456") - margin,
            mp.mpf("-0.011467176737519733584") + margin])
    B = iv([mp.mpf("0.0030489355840971131377") - margin,
            mp.mpf("0.012599132634140924533") + margin])
    C = iv([mp.mpf("-0.0070228382921267611463") - margin,
            mp.mpf("0.0020409790047855869144") + margin])
    G = [[D, A, B, C], [A, D, A, B], [B, A, D, A], [C, B, A, D]]
    ok, t, minors = interval_psd_certificate(G)
    assert ok
    assert all(float(d) > 0 for d in minors)


# ---------------------------------------------------------------------------
# Comparison: direct interval minors vs center/error certificate
# ---------------------------------------------------------------------------

from certify_gram import interval_leading_minors  # noqa: E402


def test_interval_minors_vs_center_error_certificate():
    """Direct interval minors are too wide; the center/error check succeeds."""
    mp.mp.dps = 30
    margin = mp.mpf("1e-4")
    iv = mp.iv.mpf
    D = iv([mp.mpf("0.03756591458571154063") - margin,
            mp.mpf("0.04863992698909350848") + margin])
    A = iv([mp.mpf("-0.021730257299852711456") - margin,
            mp.mpf("-0.011467176737519733584") + margin])
    B = iv([mp.mpf("0.0030489355840971131377") - margin,
            mp.mpf("0.012599132634140924533") + margin])
    C = iv([mp.mpf("-0.0070228382921267611463") - margin,
            mp.mpf("0.0020409790047855869144") + margin])
    G = [[D, A, B, C], [A, D, A, B], [B, A, D, A], [C, B, A, D]]

    minors = interval_leading_minors(G)
    assert minors[3].a <= 0 <= minors[3].b  # direct interval minor is inconclusive
    ok, t, shifted = interval_psd_certificate(G)
    assert ok
    assert all(float(d) > 0 for d in shifted)


# ---------------------------------------------------------------------------
# Exact rational LDL pivots vs leading minors
# ---------------------------------------------------------------------------

from certify_gram import exact_ldl_pivots  # noqa: E402
import sympy as sp  # noqa: E402


def test_exact_ldl_pivots_match_leading_minors():
    """The rational LDL pivots agree with the Sylvester minor ratios."""
    mp.mp.dps = 30
    margin = mp.mpf("1e-4")
    iv = mp.iv.mpf
    D = iv([mp.mpf("0.03756591458571154063") - margin,
            mp.mpf("0.04863992698909350848") + margin])
    A = iv([mp.mpf("-0.021730257299852711456") - margin,
            mp.mpf("-0.011467176737519733584") + margin])
    B = iv([mp.mpf("0.0030489355840971131377") - margin,
            mp.mpf("0.012599132634140924533") + margin])
    C = iv([mp.mpf("-0.0070228382921267611463") - margin,
            mp.mpf("0.0020409790047855869144") + margin])
    G = [[D, A, B, C], [A, D, A, B], [B, A, D, A], [C, B, A, D]]
    ok, t, shifted = interval_psd_certificate(G)
    assert ok
    centers = [[sp.Rational(str((float(G[i][j].a) + float(G[i][j].b)) / 2))
                for j in range(4)] for i in range(4)]
    M = sp.Matrix(centers) - sp.Rational(str(t)) * sp.eye(4)
    pivots = exact_ldl_pivots(M)
    assert all(p > 0 for p in pivots)
    minors = [sp.Matrix(M[:k, :k]).det() for k in range(1, 5)]
    prev = sp.Integer(1)
    for piv, minor in zip(pivots, minors):
        assert sp.simplify(piv - minor / prev) == 0
        prev = minor


# ---------------------------------------------------------------------------
# End-to-end audited certificate (H=0.1, U=4)
# ---------------------------------------------------------------------------

def test_audited_h01_interval_gram_certificate():
    """End-to-end run with the audited jet and 1e-4 margin is CERTIFIED."""
    mp.mp.dps = 30
    margin = mp.mpf("1e-4")
    iv = mp.iv.mpf
    D = iv([mp.mpf("0.037436204008367855722"),
            mp.mpf("0.048769575661494667107")])
    A = iv([mp.mpf("-0.021860546170889675471"),
            mp.mpf("-0.011336943457770025379")])
    B = iv([mp.mpf("0.0029186277325139128348"),
            mp.mpf("0.012729392454937669965")])
    C = iv([mp.mpf("-0.0071532808308344877218"),
            mp.mpf("0.0021713797139223398394")])
    G = [[D, A, B, C], [A, D, A, B], [B, A, D, A], [C, B, A, D]]
    ok, t, minors = interval_psd_certificate(G)
    assert ok
    assert all(float(d) > 0 for d in minors)
    assert abs(float(t) - 0.021095671900894935) < 1e-12


# ---------------------------------------------------------------------------
# Term-by-term-tail-backed certificate (U=6)
# ---------------------------------------------------------------------------

def test_tailproof_u6_interval_gram_certificate():
    """U=6 audited run with the proven 1e-5 tail allowance is CERTIFIED."""
    mp.mp.dps = 30
    iv = mp.iv.mpf
    D = iv([mp.mpf("0.03743460879663488422"),
            mp.mpf("0.048771170873178358585")])
    A = iv([mp.mpf("-0.021861561710435951228"),
            mp.mpf("-0.011335927918316883456")])
    B = iv([mp.mpf("0.0029176121066580768849"),
            mp.mpf("0.012730408080807234517")])
    C = iv([mp.mpf("-0.0071542965221716454255"),
            mp.mpf("0.0021723954053322830707")])
    G = [[D, A, B, C], [A, D, A, B], [B, A, D, A], [C, B, A, D]]
    ok, t, minors = interval_psd_certificate(G)
    assert ok
    assert all(float(d) > 0 for d in minors)
    assert abs(float(t) - 0.021100313817465383) < 1e-12
