"""Tests for the rescue probes (note 38)."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import rescue_probe as R  # noqa: E402


def test_archimedean_identity():
    for xi in (0.5, 2.0, 6.22885, 10.0):
        d = R.arch_identity(xi)
        assert abs(d["diff"]) < 1e-12


def test_archimedean_constant_term():
    # Re A_arch(0+) = (log pi + gamma)/2 = c
    d = R.arch_identity(1e-9)
    assert abs(d["ccm"] - (np.log(np.pi) + np.euler_gamma) / 2) < 1e-6


def test_symbol_identity():
    for xi in (0.5, 2.0, 10.0):
        d = R.symbol_identity(xi)
        assert abs(d["diff"]) < 1e-12


def test_tent_value_matches_note_29():
    assert abs(R.tent_value() - 1.3708035) < 5e-4


def test_gram_matrix_is_indefinite():
    g = R.gram_eigenvalues(nb=5, nq=120)
    ev = g["constrained_eigenvalues"]
    assert ev[0] < -1e-4, ev
    assert ev[-1] > 1e-5, ev
    # the leading positive eigenvalue is stable
    assert abs(g["eigenvalues"][-1] - 2.6877) < 1e-3


def test_gram_matrix_quadrature_stable():
    a = R.gram_eigenvalues(nb=4, nq=60)["constrained_eigenvalues"]
    b = R.gram_eigenvalues(nb=4, nq=240)["constrained_eigenvalues"]
    assert np.max(np.abs(a - b)) < 1e-7


def test_tensor_factor_unbounded_but_compatible():
    t = R.tensor_factor_example()
    assert t["max_deviation"] < 1e-10
    assert t["min_value"] > -1e-12
    assert t["norm_growth"]
    assert t["norms"][-1] > 5.0


def test_noncompatible_example_varies():
    n = R.noncompatible_example()
    assert n["spread"] > 0.1


def test_gaussian_comparison_recorded_vs_correct():
    d = R.gaussian_comparison()
    ne, we = d["N_eigenvalues"], d["W_eigenvalues"]
    # recorded functional is indefinite
    assert ne[0] < -0.01, ne
    assert ne[-1] > 0, ne
    # correct Weil functional is positive definite, and reproduces the
    # certified matrix of ../prime-spectrum-tensor/WEIL-GRAM.md
    assert we[0] > 0.02, we
    assert abs(we[-1] - 0.0780203381) < 1e-7, we
    assert abs(d["W"][0, 0] - 0.0431359584) < 1e-7


def test_exact_cosh_plus_omega_psd():
    """With correct quadrature weights, the sibling's cosh +Ω form is PSD."""
    d = R.weil_compact_gram_exact(3, pole="cosh", arch_sign=1)
    ev = d["eigenvalues"]
    assert ev[0] > -1e-5, ev
    assert ev[-1] > 1e-4


def test_exact_cosh_minus_omega_negative():
    d = R.weil_compact_gram_exact(3, pole="cosh", arch_sign=-1)
    assert d["eigenvalues"][0] < -1e-4, d["eigenvalues"]


def test_exact_additive_plus_omega_indefinite():
    d = R.weil_compact_gram_exact(3, pole="additive", arch_sign=1)
    assert d["eigenvalues"][0] < -0.1, d["eigenvalues"]


def test_smooth_bump_residual_is_small():
    d = R.weil_compact_gram_corrected(nb=4, bump=True)
    ev = d["eigenvalues"]
    assert ev[0] > -1e-3, ev   # small residual, still not positive
    assert ev[0] < 0, ev


def test_width_crossover_no_single_sign():
    """+Omega passes narrow Gaussians, -Omega passes wider ones; neither is uniform."""
    a = R.multiplicative_gaussian_gram(0.05, arch_sign=+1)["eigenvalues"]
    b = R.multiplicative_gaussian_gram(0.2, arch_sign=+1)["eigenvalues"]
    c = R.multiplicative_gaussian_gram(0.05, arch_sign=-1)["eigenvalues"]
    d = R.multiplicative_gaussian_gram(0.2, arch_sign=-1)["eigenvalues"]
    assert a[0] > 1e-2, a
    assert b[0] < -5e-2, b
    assert c[0] < -5e-2, c
    assert d[0] > -1e-2, d


def test_psi_prime_bound_dominates_numerical():
    import mpmath as mp
    for t in (0.5, 1.0, 2.0, 5.0, 10.0):
        z = mp.mpc(mp.mpf(1) / 4, mp.mpf(t) / 2)
        num = float(abs(mp.polygamma(1, z)))
        assert R.psi_prime_abs_bound(t) >= num - 1e-12, (t, num)


def test_omega_panel_contains_samples():
    import mpmath as mp
    for (a, b) in ((0.0, 0.1), (0.4, 0.6), (1.0, 1.2)):
        d = R.omega_panel_interval(a, b)
        for t in (a, (a + b) / 2, b):
            val = float(mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * mp.mpf(t) / 2))
                        - mp.log(mp.pi))
            assert d["lo"] <= val <= d["hi"], (a, b, t, val, d)


def test_gaussian_W0_interval_certificate():
    """First interval-certified analytic Gram entry (Gaussian diagonal)."""
    d = R.gaussian_W0_interval(sigma=0.05, h=0.02, T=80.0)
    assert d["lo"] < 0.0431359584 < d["hi"], d
    assert d["width"] < 1e-2, d


def test_gaussian_gram_4x4_interval_certified():
    d = R.gaussian_gram_intervals([-0.3, -0.1, 0.1, 0.3], h=0.02, T=80.0)
    c = R.interval_psd_check(d["G"])
    assert c["ok"], c
    assert c["t"] > 0


def test_compact_W00_interval_contains():
    d = R.compact_W00_interval(hstep=0.004, T=30.0)
    assert d["lo"] <= 2.1468806878830666e-4 <= d["hi"], d
    assert d["width"] < 5e-2, d


def test_zero_sum_naive_diverges():
    import mpmath as mp
    from zero_sum_probe import tent_Fhat
    mp.mp.dps = 20
    a = abs(tent_Fhat(mp.mpf('0.5') + 10j, 1))
    b = abs(tent_Fhat(mp.mpf('0.5') + 20j, 1))
    assert b > 100 * a


def test_finite_bc_quotient_hodge_index():
    import finite_crossed_product as F
    assert len(F.hermitian_basis()) == 6
    assert F.hodge_index_holds(F.nontracial_state())
    assert F.hodge_index_holds(F.tracial_state())


def test_finite_bc_quotient_family():
    import finite_crossed_product as F
    for n in (3, 4, 5):
        assert len(F.hermitian_basis(n)) == 2 * n
        assert F.hodge_index_holds(F.tracial_state(n), n)
        assert F.hodge_index_holds(F.nontracial_state(n), n)


def test_von_mangoldt_tail_bound():
    """Partial von Mangoldt sum at s=2 with an explicit L-series tail bound.

    For decreasing f, sum_{n>N} f(n) <= int_N^inf f(x) dx, so
    sum_{n>N} Lambda(n) n^-2 <= sum_{n>N} log(n) n^-2
                            <= (log N + 1) / N.
    """
    import math

    import mpmath as mp

    N = 20_000
    spf = list(range(N + 1))
    for p in range(2, N + 1):
        if spf[p] == p:
            for k in range(p, N + 1, p):
                if spf[k] == k:
                    spf[k] = p
    lam = [0.0] * (N + 1)
    for n in range(2, N + 1):
        p = spf[n]
        m = n
        while m % p == 0:
            m //= p
        if m == 1:
            lam[n] = math.log(p)

    partial = sum(lam[n] / n**2 for n in range(1, N + 1))
    target = float(-mp.zeta(2, derivative=1) / mp.zeta(2))
    tail = (math.log(N) + 1.0) / N
    assert abs(partial - target) <= tail


def test_completed_zeta_functional_equation():
    """Z(s) = Z(1-s) for the completed zeta, at high precision.

    This is an exact identity (no truncation); the tolerance is far above
    the working precision.
    """
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.mpf(1) / 2 * s * (s - 1) * mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    pts = [mp.mpc("0.3", "2"), mp.mpc("0.7", "-3"), mp.mpc("1.4", "0.5"), mp.mpc("2", "7")]
    for s in pts:
        assert abs(Z(s) - Z(1 - s)) < mp.mpf("1e-20")


def test_von_mangoldt_tail_complex():
    """Partial von Mangoldt sum at complex s with Re s > 1, with a tail bound.

    |sum_{n>N} Lambda(n) n^-s| <= sum_{n>N} log(n) n^-sigma
      <= int_N^inf log(x) x^-sigma dx
       = N^(1-sigma) (log N/(sigma-1) + 1/(sigma-1)^2).
    """
    import math

    import mpmath as mp

    N = 20_000
    spf = list(range(N + 1))
    for p in range(2, N + 1):
        if spf[p] == p:
            for k in range(p, N + 1, p):
                if spf[k] == k:
                    spf[k] = p
    lam = [0.0] * (N + 1)
    for n in range(2, N + 1):
        p = spf[n]
        m = n
        while m % p == 0:
            m //= p
        if m == 1:
            lam[n] = math.log(p)

    logs = [mp.log(n) for n in range(N + 1)]
    for sigma, t in [(2.0, 3.0), (1.5, -2.0)]:
        s = mp.mpc(sigma, t)
        partial = mp.mpc(0)
        for n in range(2, N + 1):
            if lam[n] != 0.0:
                partial += lam[n] * mp.e ** (-s * logs[n])
        target = -mp.zeta(s, derivative=1) / mp.zeta(s)
        tail = N ** (1 - sigma) * (math.log(N) / (sigma - 1) + 1 / (sigma - 1) ** 2)
        assert abs(partial - target) <= tail


def test_symbol_pure_imaginary_critical_line():
    """Numerical confirmation that M(1/2+it) is purely imaginary.

    M(s) = (1/2) log pi - (1/2) digamma(s/2) - zeta'(s)/zeta(s).
    """
    import mpmath as mp

    mp.mp.dps = 30
    for t in (0.5, 2.0, 10.0, 20.0):
        s = mp.mpc(0.5, t)
        M = (
            mp.mpf(1) / 2 * mp.log(mp.pi)
            - mp.mpf(1) / 2 * mp.digamma(s / 2)
            - mp.zeta(s, derivative=1) / mp.zeta(s)
        )
        assert abs(M.real) < mp.mpf("1e-25")



def test_logDeriv_completedZeta_conj():
    """(Z'/Z)(conj s) = conj((Z'/Z)(s)) at 30 dps."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.mpf(1) / 2 * s * (s - 1) * mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for s in [mp.mpc("0.3", "2"), mp.mpc("1.4", "-0.5"), mp.mpc("2", "3")]:
        lhs = mp.diff(Z, mp.conj(s)) / Z(mp.conj(s))
        rhs = mp.conj(mp.diff(Z, s) / Z(s))
        assert abs(lhs - rhs) < mp.mpf("1e-20")


def test_logDeriv_completedZeta_critical_line():
    """Re((Z'/Z)(1/2+it)) = 0 at 30 dps."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.mpf(1) / 2 * s * (s - 1) * mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for t in (2.0, 10.0, 20.0):
        s = mp.mpc(0.5, t)
        L = mp.diff(Z, s) / Z(s)
        assert abs(L.real) < mp.mpf("1e-20")


def test_symbol_critical_line_eq_neg_logDeriv():
    """M(1/2+it) = -(Z'/Z)(1/2+it) at 30 dps."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for t in (2.0, 10.0, 20.0):
        s = mp.mpc(0.5, t)
        M = (
            mp.mpf(1) / 2 * mp.log(mp.pi)
            - mp.mpf(1) / 2 * mp.digamma(s / 2)
            - mp.zeta(s, derivative=1) / mp.zeta(s)
        )
        assert abs(M + mp.diff(Z, s) / Z(s)) < mp.mpf("1e-20")


def test_logDeriv_completedZeta_one_sub():
    """(Z'/Z)(1-s) = -(Z'/Z)(s) at 30 dps."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for s in [mp.mpc("0.3", "2"), mp.mpc("1.4", "-0.5"), mp.mpc("2", "3")]:
        lhs = mp.diff(Z, 1 - s) / Z(1 - s)
        rhs = -(mp.diff(Z, s) / Z(s))
        assert abs(lhs - rhs) < mp.mpf("1e-20")


def test_completedZeta_zero_quadruple():
    """The first zeta zero and its reflections are zeros of the completed zeta."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    rho = mp.zetazero(1)
    for z in (rho, 1 - rho, mp.conj(rho), 1 - mp.conj(rho)):
        assert abs(Z(z)) < mp.mpf("1e-15")


def test_completedZeta_critical_line_real():
    """The completed zeta is real on the critical line at 30 dps."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for t in (1.0, 5.0, 10.0, 20.0):
        assert abs(Z(mp.mpc(0.5, t)).imag) < mp.mpf("1e-20")


def test_completedZeta_residue_one():
    """(s-1) Z(s) -> 1 as s -> 1."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for eps in (mp.mpf("1e-3"), mp.mpf("1e-4")):
        s = mp.mpc(1 + eps, 0)
        assert abs((s - 1) * Z(s) - 1) < 10 * eps


def test_cone_positivity_ldl_constants():
    """The embedded LDL^T constants reproduce G4 - I/12500 exactly."""
    from fractions import Fraction as F

    L4 = [
        [F(2077, 10000), 0, 0, 0],
        [F(-794, 10000), F(1919, 10000), 0, 0],
        [F(386, 10000), F(-699, 10000), F(1917, 10000), 0],
        [F(-107, 10000), F(374, 10000), F(-702, 10000), F(1916, 10000)],
    ]
    n = 4
    G = [[sum(L4[i][k] * L4[j][k] for k in range(n)) for j in range(n)] for i in range(n)]
    t = F(1, 12500)
    A = [[G[i][j] - (t if i == j else 0) for j in range(n)] for i in range(n)]
    Ld = [
        [F(1), 0, 0, 0],
        [F(-1649138, 4305929), F(1), 0, 0],
        [F(801722, 4305929), F(-5773439475949, 15817355284169), F(1), 0],
        [F(-222239, 4305929), F(3089711414874, 15817355284169),
         F(-21277086120608205046, 57983388627512676241), F(1)],
    ]
    dd = [F(4305929, 100000000), F(15817355284169, 430592900000000),
          F(57983388627512676241, 1581735528416900000000),
          F(13270722984083681998948281, 362396178921954226506250000)]
    for i in range(n):
        for j in range(n):
            val = sum(Ld[i][k] * dd[k] * Ld[j][k] for k in range(n))
            assert val == A[i][j], (i, j, val, A[i][j])
    assert all(d > 0 for d in dd)


def test_cone_positivity_2x2_ldl_constants():
    """The embedded 2x2 LDL^T constants reproduce G2 - I/5000 exactly."""
    from fractions import Fraction as F

    G2 = [[F(355, 10000), F(802, 100000)], [F(802, 100000), F(355, 10000)]]
    t = F(2, 10000)
    P2 = [[G2[i][j] - (t if i == j else 0) for j in range(2)] for i in range(2)]
    L2 = [[F(1), 0], [F(401, 1765), F(1)]]
    d2 = [F(353, 10000), F(369303, 11031250)]
    for i in range(2):
        for j in range(2):
            val = sum(L2[i][k] * d2[k] * L2[j][k] for k in range(2))
            assert val == P2[i][j], (i, j, val, P2[i][j])
    assert all(d > 0 for d in d2)


def test_gram6_certificate_recorded():
    """The saved 6x6 interval data reproduces the box certificate."""
    import json
    import mpmath as mp

    d = json.load(open("python/gram6_certificate.json"))
    n = 6
    G = [[mp.iv.mpf([d["centre"][i][j] - d["half"][i][j],
                     d["centre"][i][j] + d["half"][i][j]])
          for j in range(n)] for i in range(n)]
    c = R.interval_psd_check(G)
    assert c["ok"], c
    assert abs(c["t"] - d["t"]) < 1e-8


def test_completedZeta_residue_zero():
    """s Z(s) -> -1 as s -> 0."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for eps in (mp.mpf("1e-3"), mp.mpf("1e-4")):
        s = mp.mpc(eps, 0)
        assert abs(s * Z(s) + 1) < 10 * eps


def test_completedZeta_ofReal_pos():
    """The completed zeta is positive on (1, infinity)."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for x in (2.0, 3.0, 10.0):
        v = Z(x)
        assert v.real > 0
        assert abs(v.imag) < mp.mpf("1e-20")


def test_deriv_completedZeta_critical_line():
    """Re Z'(1/2+it) = 0 at 30 dps."""
    import mpmath as mp

    mp.mp.dps = 30

    def Z(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

    for t in (2.0, 10.0, 20.0):
        s = mp.mpc(0.5, t)
        assert abs(mp.diff(Z, s).real) < mp.mpf("1e-18")


def test_circleIntegral_sub_inv_linear():
    """(2 pi i)^-1 * contour integral of 1/(z-w) around |z|=1 is 1."""
    import mpmath as mp

    mp.mp.dps = 30
    R = mp.mpf(1)
    w = mp.mpc(0.5, 0)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return 1 / (z - w) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) - 1) < mp.mpf("1e-20")


def test_circleIntegral_sub_inv_outside():
    """Contour integral of 1/(z-w) around |z|=1 is 0 for w outside."""
    import mpmath as mp

    mp.mp.dps = 30
    R = mp.mpf(1)
    w = mp.mpc(2, 0)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return 1 / (z - w) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_prod():
    """For f=(z-a)(z-b) with both roots inside, the log-deriv integral is 2(2 pi i)."""
    import mpmath as mp

    mp.mp.dps = 30
    a, b = mp.mpc(0.5, 0), mp.mpc(-0.3, 0)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (1 / (z - a) + 1 / (z - b)) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) - 2) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_prod_mixed():
    """For f=(z-a)(z-b) with one root inside and one outside, the count is 1."""
    import mpmath as mp

    mp.mp.dps = 30
    a, b = mp.mpc(0.5, 0), mp.mpc(2, 0)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (1 / (z - a) + 1 / (z - b)) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) - 1) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_simple_zero():
    """For f=(z-a)exp(z) with a inside |z|=1, the log-deriv integral is 2 pi i."""
    import mpmath as mp

    mp.mp.dps = 30
    a = mp.mpc(0.5, 0)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (1 / (z - a) + 1) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) - 1) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_zero_free():
    """For h=exp(z) (zero-free), the log-deriv integral around |z|=1 is 0."""
    import mpmath as mp

    mp.mp.dps = 30
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return 1 * dz  # h'/h = 1 for exp

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_mul_prod():
    """f=(z-a)(z-b)exp(z) with both roots inside gives count 2."""
    import mpmath as mp

    mp.mp.dps = 30
    a, b = mp.mpc(0.5, 0), mp.mpc(-0.3, 0)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (1 / (z - a) + 1 / (z - b) + 1) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) - 2) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_simple_pole():
    """For f = 1/((z-a)exp(z)) with a inside |z|=1, the log-deriv integral is -2 pi i."""
    import mpmath as mp

    mp.mp.dps = 30
    a = mp.mpc(0.5, 0)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (-1 / (z - a) - 1) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) + 1) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_div_prod():
    """f = (z-a)(z-b) / ((z-p) (z-q)) exp(z): count 2 - 2 = 0, with all roots inside."""
    import mpmath as mp

    mp.mp.dps = 30
    a, b = mp.mpc(0.5, 0), mp.mpc(-0.3, 0)
    p, q = mp.mpc(0.2, 0.1), mp.mpc(-0.4, -0.2)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (1 / (z - a) + 1 / (z - b) - 1 / (z - p) - 1 / (z - q) + 1) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j)) < mp.mpf("1e-20")


def test_circleIntegral_logDeriv_div_prod_asymmetric():
    """f = (z-a)(z-b)(z-c) / ((z-p) exp(z)): count 3 - 1 = 2."""
    import mpmath as mp

    mp.mp.dps = 30
    a, b, c = mp.mpc(0.5, 0), mp.mpc(-0.3, 0), mp.mpc(0.1, 0.4)
    p = mp.mpc(-0.4, -0.2)
    R = mp.mpf(1)

    def integrand(t):
        z = R * mp.e ** (1j * t)
        dz = 1j * R * mp.e ** (1j * t)
        return (1 / (z - a) + 1 / (z - b) + 1 / (z - c) - 1 / (z - p) + 1) * dz

    val = mp.quad(integrand, [0, 2 * mp.pi])
    assert abs(val / (2 * mp.pi * 1j) - 2) < mp.mpf("1e-20")


def test_logDeriv_reciprocal_local_expansion():
    """The reciprocal factorisation at a simple pole: 1/f = (z-p) k, k nonzero, so
    logDeriv(1/f) = -logDeriv(f) pointwise (numerical spot check on f=1/((z-a)e^z))."""
    import mpmath as mp

    mp.mp.dps = 30
    a = mp.mpc(0.5, 0)
    for z in (mp.mpc(1.3, 0.2), mp.mpc(0.1, -0.7)):
        f = 1 / ((z - a) * mp.e ** z)
        logderiv_f = mp.diff(lambda y: 1 / ((y - a) * mp.e ** y), z) / f
        logderiv_rec = mp.diff(lambda y: (y - a) * mp.e ** y, z) / ((z - a) * mp.e ** z)
        assert abs(logderiv_rec + logderiv_f) < mp.mpf("1e-18")


def test_rectIntegral_inv_inside():
    """Rectangle winding integral of 1/(z-w): 2 pi i for w strictly inside."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    w = mp.mpc("0.3", "0.2")

    bottom = mp.quad(lambda x: 1 / (mp.mpc(x, y1) - w), [x1, x2])
    top = mp.quad(lambda x: 1 / (mp.mpc(x, y2) - w), [x1, x2])
    right = mp.quad(lambda y: 1j / (mp.mpc(x2, y) - w), [y1, y2])
    left = mp.quad(lambda y: 1j / (mp.mpc(x1, y) - w), [y1, y2])
    val = bottom - top + right - left
    assert abs(val - 2 * mp.pi * 1j) < mp.mpf("1e-18")


def test_rectIntegral_inv_outside():
    """Rectangle winding integral of 1/(z-w): 0 for w outside the closed rectangle."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    w = mp.mpc("3.0", "0.2")

    bottom = mp.quad(lambda x: 1 / (mp.mpc(x, y1) - w), [x1, x2])
    top = mp.quad(lambda x: 1 / (mp.mpc(x, y2) - w), [x1, x2])
    right = mp.quad(lambda y: 1j / (mp.mpc(x2, y) - w), [y1, y2])
    left = mp.quad(lambda y: 1j / (mp.mpc(x1, y) - w), [y1, y2])
    val = bottom - top + right - left
    assert abs(val) < mp.mpf("1e-18")


def test_rectIntegral_logDeriv_div_prod():
    """Rectangle divisor count for f=(z-a)(z-b)/(z-p) exp(z): 3 roots/poles inside,
    two zeros and one pole, so the count is 2 - 1 = 1."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    a, b = mp.mpc("0.5", "0"), mp.mpc("-0.3", "0.2")
    p = mp.mpc("0.2", "0.1")

    def integrand(z):
        return 1 / (z - a) + 1 / (z - b) - 1 / (z - p) + 1

    def side(f, lo, hi):
        return mp.quad(lambda t: f(t), [lo, hi])

    bottom = side(lambda x: integrand(mp.mpc(x, y1)), x1, x2)
    top = side(lambda x: integrand(mp.mpc(x, y2)), x1, x2)
    right = side(lambda y: 1j * integrand(mp.mpc(x2, y)), y1, y2)
    left = side(lambda y: 1j * integrand(mp.mpc(x1, y)), y1, y2)
    val = bottom - top + right - left
    assert abs(val / (2 * mp.pi * 1j) - 1) < mp.mpf("1e-18")


def test_rectIntegral_logDeriv_div_prod_zero_count():
    """Rectangle divisor count with two zeros and two poles gives 0."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    a, b = mp.mpc("0.5", "0"), mp.mpc("-0.3", "0.2")
    p, q = mp.mpc("0.2", "0.1"), mp.mpc("-0.7", "-0.2")

    def integrand(z):
        return 1 / (z - a) + 1 / (z - b) - 1 / (z - p) - 1 / (z - q) + 1

    def side(f, lo, hi):
        return mp.quad(lambda t: f(t), [lo, hi])

    bottom = side(lambda x: integrand(mp.mpc(x, y1)), x1, x2)
    top = side(lambda x: integrand(mp.mpc(x, y2)), x1, x2)
    right = side(lambda y: 1j * integrand(mp.mpc(x2, y)), y1, y2)
    left = side(lambda y: 1j * integrand(mp.mpc(x1, y)), y1, y2)
    val = bottom - top + right - left
    assert abs(val / (2 * mp.pi * 1j)) < mp.mpf("1e-18")


def test_rectIntegral_logDeriv_eq_card_of_simple_zeros():
    """Zero-count theorem for a given analytic f: three simple zeros inside the
    rectangle and no others, so the contour integral is 3*(2 pi i)."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    roots = [mp.mpc("0.5", "0"), mp.mpc("-0.3", "0.2"), mp.mpc("0.1", "-0.4")]

    def logderiv(z):
        # f = prod (z - r), f'/f = sum 1/(z-r)
        return sum(1 / (z - r) for r in roots)

    def side(f, lo, hi):
        return mp.quad(lambda t: f(t), [lo, hi])

    bottom = side(lambda x: logderiv(mp.mpc(x, y1)), x1, x2)
    top = side(lambda x: logderiv(mp.mpc(x, y2)), x1, x2)
    right = side(lambda y: 1j * logderiv(mp.mpc(x2, y)), y1, y2)
    left = side(lambda y: 1j * logderiv(mp.mpc(x1, y)), y1, y2)
    val = bottom - top + right - left
    assert abs(val / (2 * mp.pi * 1j) - 3) < mp.mpf("1e-14")


def test_rectIntegral_logDeriv_completedZeta_eq_card():
    """Zero side of the explicit formula numerically: for the rectangle
    [-1,2] x [-30,30], Z'/Z has contour integral 2 pi i (N - 2) with N = 6
    nontrivial zeros inside (three with positive imaginary part and their
    conjugates)."""
    import mpmath as mp

    mp.mp.dps = 25
    x1, x2, y1, y2 = mp.mpf(-1), mp.mpf(2), mp.mpf(-30), mp.mpf(30)

    def logderivZ(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    bottom = mp.quad(lambda x: logderivZ(mp.mpc(x, y1)), [x1, x2])
    top = mp.quad(lambda x: logderivZ(mp.mpc(x, y2)), [x1, x2])
    right = mp.quad(lambda y: 1j * logderivZ(mp.mpc(x2, y)), [y1, y2])
    left = mp.quad(lambda y: 1j * logderivZ(mp.mpc(x1, y)), [y1, y2])
    val = bottom - top + right - left
    zeros_inside = 6
    assert abs(val / (2 * mp.pi * 1j) - (zeros_inside - 2)) < mp.mpf("1e-6")


def test_rectIntegral_logDeriv_eq_sum_multiplicity():
    """Multiplicity form: f = (z-a)^2 (z-b), so the zero count is 2+1 = 3."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    a, b = mp.mpc("0.5", "0"), mp.mpc("-0.3", "0.2")
    m = {a: 2, b: 1}

    def logderiv(z):
        return sum(m[r] / (z - r) for r in m)

    def side(f, lo, hi):
        return mp.quad(lambda t: f(t), [lo, hi])

    bottom = side(lambda x: logderiv(mp.mpc(x, y1)), x1, x2)
    top = side(lambda x: logderiv(mp.mpc(x, y2)), x1, x2)
    right = side(lambda y: 1j * logderiv(mp.mpc(x2, y)), y1, y2)
    left = side(lambda y: 1j * logderiv(mp.mpc(x1, y)), y1, y2)
    val = bottom - top + right - left
    assert abs(val / (2 * mp.pi * 1j) - 3) < mp.mpf("1e-14")


def test_rectIntegral_logDeriv_eq_divisor_sum():
    """Divisor-sum form: f = (z-a)^3 (z-b)^2, so the multiplicity count is 5."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    a, b = mp.mpc("0.5", "0"), mp.mpc("-0.3", "0.2")
    m = {a: 3, b: 2}

    def logderiv(z):
        return sum(m[r] / (z - r) for r in m)

    def side(f, lo, hi):
        return mp.quad(lambda t: f(t), [lo, hi])

    bottom = side(lambda x: logderiv(mp.mpc(x, y1)), x1, x2)
    top = side(lambda x: logderiv(mp.mpc(x, y2)), x1, x2)
    right = side(lambda y: 1j * logderiv(mp.mpc(x2, y)), y1, y2)
    left = side(lambda y: 1j * logderiv(mp.mpc(x1, y)), y1, y2)
    val = bottom - top + right - left
    assert abs(val / (2 * mp.pi * 1j) - 5) < mp.mpf("1e-14")


def test_vertical_term_integral():
    """The term integral behind the prime side: for c > 1 and n >= 2,
    int_{y1}^{y2} n^{-c-iy} dy = i (n^{-iy2} - n^{-iy1}) / log n."""
    import mpmath as mp

    mp.mp.dps = 30
    c, y1, y2 = mp.mpf("1.5"), mp.mpf("-2"), mp.mpf("3")
    for n in (2, 3, 5, 97):
        N = mp.mpf(n)
        lhs = mp.quad(lambda y: N ** (-c - 1j * y), [y1, y2])
        rhs = 1j * (N ** (-1j * y2) - N ** (-1j * y1)) * N ** (-c) / mp.log(N)
        assert abs(lhs - rhs) < mp.mpf("1e-20")


def test_lseries_termwise_integration_consistency():
    """Consistency of the term-by-term interchange: integrating the von Mangoldt
    series on Re s = c equals the sum of the term integrals, checked on a
    truncated range with the tail estimate sum_{n>N} Lambda(n) n^{-c}(y2-y1)."""
    import mpmath as mp

    mp.mp.dps = 25
    c, y1, y2 = mp.mpf(2), mp.mpf(-1), mp.mpf(1)
    N = 2000

    def lam(n):
        # von Mangoldt: log p if n is a prime power p^k, else 0
        if n <= 1:
            return mp.mpf(0)
        m, p, k = n, None, 0
        d = 2
        while d * d <= m:
            if m % d == 0:
                p = d
                while m % d == 0:
                    m //= d
                    k += 1
                break
            d += 1
        if p is None:
            return mp.log(n)
        if m == 1:
            return mp.log(p)
        return mp.mpf(0)

    term_sum = mp.mpf(0)
    for n in range(1, N + 1):
        L = lam(n)
        if L != 0:
            Nn = mp.mpf(n)
            term_sum += 1j * L * Nn ** (-c) * (Nn ** (-1j * y2) - Nn ** (-1j * y1)) / mp.log(Nn)

    def partial(y):
        s = mp.mpc(0)
        for n in range(1, N + 1):
            L = lam(n)
            if L != 0:
                s += L * mp.mpf(n) ** (-c - 1j * y)
        return s

    integral = mp.quad(partial, [y1, y2])
    assert abs(integral - term_sum) < mp.mpf("1e-10")


def test_horizontal_reflection():
    """Exact horizontal reflection on a symmetric rectangle: for the completed
    zeta log-derivative, the bottom horizontal integral equals minus the top
    one, and the top integral is purely imaginary (conjugation symmetry).
    No Stirling-type estimate is involved."""
    import mpmath as mp

    mp.mp.dps = 25
    x2, T = mp.mpf(2), mp.mpf(30)

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    bottom = mp.quad(lambda x: g(mp.mpc(x, -T)), [1 - x2, x2])
    top = mp.quad(lambda x: g(mp.mpc(x, T)), [1 - x2, x2])
    assert abs(bottom + top) < mp.mpf("1e-20")
    assert abs(top + mp.conj(top)) < mp.mpf("1e-20")


def test_rectIntegral_cauchy_formula():
    """Cauchy integral formula on a rectangle: for h = exp and a strictly inside
    [-1,2] x [-0.5,1.5], the boundary integral of h(z)/(z-a) is 2 pi i h(a)."""
    import mpmath as mp

    mp.mp.dps = 30
    x1, x2, y1, y2 = mp.mpf("-1"), mp.mpf("2"), mp.mpf("-0.5"), mp.mpf("1.5")
    a = mp.mpc("0.3", "0.2")

    def f(z):
        return mp.e ** z / (z - a)

    bottom = mp.quad(lambda x: f(mp.mpc(x, y1)), [x1, x2])
    top = mp.quad(lambda x: f(mp.mpc(x, y2)), [x1, x2])
    right = mp.quad(lambda y: 1j * f(mp.mpc(x2, y)), [y1, y2])
    left = mp.quad(lambda y: 1j * f(mp.mpc(x1, y)), [y1, y2])
    val = bottom - top + right - left
    assert abs(val - 2 * mp.pi * 1j * mp.e ** a) < mp.mpf("1e-18")


def test_residues_of_logDeriv_completedZeta():
    """Numerical limits of the residues: at a simple zero rho of Z,
    (s-rho) Z'/Z -> 1; at the poles 1 and 0, (s-p) Z'/Z -> -1.  The error is
    O(eps); we check the measured convergence and a Richardson extrapolation."""
    import mpmath as mp

    mp.mp.dps = 25

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    eps_list = [mp.mpf(10) ** (-k) for k in range(2, 7)]

    def check(p, target, tol_richardson):
        vals = [eps * g(p + eps) for eps in eps_list]
        errs = [abs(v - target) for v in vals]
        # linear convergence: each decade reduces the error by roughly a decade
        for a, b in zip(errs, errs[1:]):
            assert b < a
        assert errs[-1] < mp.mpf("1e-5")
        # Richardson extrapolation of the last two values
        rich = 2 * vals[-1] - vals[-2]
        assert abs(rich - target) < tol_richardson

    check(mp.zetazero(1), mp.mpf(1), mp.mpf("1e-4"))
    check(mp.mpc(1, 0), mp.mpf(-1), mp.mpf("1e-4"))
    check(mp.mpc(0, 0), mp.mpf(-1), mp.mpf("1e-4"))


def test_pole_residue_subtraction_bounded():
    """The subtracted expressions (Z'/Z)*h + h(p)/(s-p) stay bounded as s -> p:
    numerically they converge (consecutive values get closer), confirming the
    removable singularity of the closed-form germ."""
    import mpmath as mp

    mp.mp.dps = 25

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    # h(s) = s; at p = 1 the expression tends to a finite limit
    vals = []
    for eps in (mp.mpf("1e-2"), mp.mpf("1e-3"), mp.mpf("1e-4")):
        s = mp.mpc(1, 0) + eps
        vals.append(g(s) * s + 1 / eps)
    assert abs(vals[-1] - vals[-2]) < abs(vals[-2] - vals[-3])
    assert abs(vals[-1]) < mp.mpf(10)

    # h(s) = s; at p = 0 the expression is s*Z'/Z -> -1
    vals = []
    for eps in (mp.mpf("1e-3"), mp.mpf("1e-4")):
        s = mp.mpc(0, 0) + eps
        vals.append(g(s) * s)
    assert abs(vals[-1] + 1) < mp.mpf("2e-3")


def test_test_function_formula_h_eq_s():
    """Numerical check of the test-function explicit formula for h(s) = s on
    [-1,2] x [-30,30]: only the three zero pairs 0.5 +- i*14.13, 21.02, 25.01
    lie inside, so the contour integral of (Z'/Z)*s should be
    2*pi*i*(sum of the six zeros - h(0) - h(1)) = 2*pi*i*(3 - 0 - 1) = 4*pi*i."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    h = lambda s: s

    bottom = mp.quad(lambda x: g(mp.mpc(x, -T)) * h(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: g(mp.mpc(x, T)) * h(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * g(mp.mpc(x2, y)) * h(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * g(mp.mpc(x1, y)) * h(mp.mpc(x1, y)), [-T, T])
    val = bottom - top + right - left

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    assert all(0 < z.imag < 30 for z in zeros)
    zero_sum = 2 * sum(z.real for z in zeros)  # include the conjugates
    expected = 2 * mp.pi * 1j * (zero_sum - 1)
    assert abs(val - expected) < mp.mpf("1e-3")


def test_test_function_formula_h_eq_s_squared():
    """Same contour as for h(s) = s, but with h(s) = s^2: the formula gives
    2*pi*i*(sum of rho^2 over the six zeros - h(0) - h(1)); using conjugate
    pairs this is 2*pi*i*(2*sum Re(rho^2) - 1)."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    h = lambda s: s ** 2

    bottom = mp.quad(lambda x: g(mp.mpc(x, -T)) * h(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: g(mp.mpc(x, T)) * h(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * g(mp.mpc(x2, y)) * h(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * g(mp.mpc(x1, y)) * h(mp.mpc(x1, y)), [-T, T])
    val = bottom - top + right - left

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    zsum = 2 * sum(mp.re(z ** 2) for z in zeros)
    expected = 2 * mp.pi * 1j * (zsum - 1)
    assert abs(val - expected) < mp.mpf("1e-2")


def test_global_remainder_bounded_near_zero():
    """For h(s) = s, the global remainder
    h*F'/F - h(rho)/(s-rho) - dslope h 0 - dslope h 1  (F = s(s-1)Z)
    is bounded near a simple zero rho: the values converge as eps shrinks."""
    import mpmath as mp

    mp.mp.dps = 25

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    def F_over_F(s):
        return g(s) + 1 / s + 1 / (s - 1)

    rho = mp.zetazero(1)
    vals = []
    for eps in (mp.mpf("1e-2"), mp.mpf("1e-3"), mp.mpf("1e-4")):
        s = rho + eps
        vals.append(s * F_over_F(s) - rho / (s - rho) - 1 - 1)
    assert abs(vals[-1] - vals[-2]) < abs(vals[-2] - vals[-3])
    assert abs(vals[-1]) < mp.mpf(100)


def test_test_function_formula_h_eq_exp():
    """Numerically check the test-function formula for h(s) = exp on
    [-1,2] x [-30,30]: the contour integral equals
    2*pi*i*(sum over the six zeros of exp(rho) - exp(0) - exp(1))."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    h = lambda s: mp.e ** s

    bottom = mp.quad(lambda x: g(mp.mpc(x, -T)) * h(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: g(mp.mpc(x, T)) * h(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * g(mp.mpc(x2, y)) * h(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * g(mp.mpc(x1, y)) * h(mp.mpc(x1, y)), [-T, T])
    val = bottom - top + right - left

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    zsum = 2 * sum(mp.re(mp.e ** z) for z in zeros)
    expected = 2 * mp.pi * 1j * (zsum - mp.e ** 0 - mp.e ** 1)
    assert abs(val - expected) < mp.mpf("1e-3")


def test_prime_side_identity():
    """Numerical check of the integrated prime-side identity on Re = 2:
    integral of (Z'/Z)*i = -(integral of arch*i) - (integral of L_Λ*i),
    where arch = (1/2)log pi - (1/2)digamma(s/2) and L_Λ = -zeta'/zeta."""
    import mpmath as mp

    mp.mp.dps = 20
    c, y1, y2 = mp.mpf(2), mp.mpf(-5), mp.mpf(5)

    def arch(s):
        return mp.mpf(1) / 2 * mp.log(mp.pi) - mp.mpf(1) / 2 * mp.digamma(s / 2)

    I = mp.mpc(0, 1)
    A = mp.quad(lambda y: arch(mp.mpc(c, y)) * I, [y1, y2])
    B = mp.quad(lambda y: (-mp.zeta(mp.mpc(c, y), derivative=1) / mp.zeta(mp.mpc(c, y))) * I,
                [y1, y2])
    Z = mp.quad(lambda y: -(arch(mp.mpc(c, y)) + (-mp.zeta(mp.mpc(c, y), derivative=1)
                                                  / mp.zeta(mp.mpc(c, y)))) * I, [y1, y2])
    assert abs(-(A + B) - Z) < mp.mpf("1e-15")


def test_prime_side_termwise():
    """The prime integral equals the von Mangoldt term sum:
    ∫ L_Λ(c+iy)i dy = Σ_n -Λ(n)(n^{-(c+iy2)} - n^{-(c+iy1)})/log n."""
    import mpmath as mp

    mp.mp.dps = 20
    c, y1, y2 = mp.mpf(2), mp.mpf(-5), mp.mpf(5)
    I = mp.mpc(0, 1)
    B = mp.quad(lambda y: (-mp.zeta(mp.mpc(c, y), derivative=1) / mp.zeta(mp.mpc(c, y))) * I,
                [y1, y2])

    N = 200000
    lam = [mp.mpf(0)] * (N + 1)
    is_comp = [False] * (N + 1)
    for p in range(2, N + 1):
        if not is_comp[p]:
            lp = mp.log(p)
            pk = p
            while pk <= N:
                lam[pk] = lp
                pk *= p
            for m in range(p * p, N + 1, p):
                is_comp[m] = True
    S = mp.mpc(0)
    for n in range(2, N + 1):
        if lam[n] != 0:
            S += -lam[n] * (mp.power(n, -(c + I * y2)) - mp.power(n, -(c + I * y1))) / mp.log(n)
    assert abs(B - S) < mp.mpf("1e-6")


def test_test_function_formula_other_rectangle():
    """The h(s) = s formula on [-1.5, 2.5] x [-20, 20]: only the first zero
    pair 0.5 +- 14.13i lies inside, so sum rho = 1 and the contour integral
    should vanish exactly (sum rho - h(0) - h(1) = 1 - 0 - 1 = 0)."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    x1, x2, T = mp.mpf("-1.5"), mp.mpf("2.5"), mp.mpf(20)
    h = lambda s: s

    bottom = mp.quad(lambda x: g(mp.mpc(x, -T)) * h(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: g(mp.mpc(x, T)) * h(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * g(mp.mpc(x2, y)) * h(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * g(mp.mpc(x1, y)) * h(mp.mpc(x1, y)), [-T, T])
    val = bottom - top + right - left
    assert abs(val) < mp.mpf("1e-9")


def test_contour_shift_symmetric():
    """Numerical check of the contour-shift identity for the symmetric test
    function h(s) = exp(-(s-1/2)^2/1000) on [-1,2] x [-30,30]:
      contour integral = 2i*Right - 2i*Im(Top)
                      = (sum h(rho) - h(0) - h(1)) * 2*pi*i."""
    import mpmath as mp

    mp.mp.dps = 30

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    h = lambda s: mp.e ** (-((s - mp.mpf(1) / 2) ** 2) / 1000)
    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    Phi = lambda s: g(s) * h(s)

    bottom = mp.quad(lambda x: Phi(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: Phi(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * Phi(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * Phi(mp.mpc(x1, y)), [-T, T])
    contour = bottom - top + right - left

    right_dy = mp.quad(lambda y: Phi(mp.mpc(2, y)), [-T, T])
    rhs = 2j * right_dy - 2j * mp.im(top)
    assert abs(contour - rhs) < mp.mpf("1e-10")

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    sumh = 2 * sum(h(z) for z in zeros)
    lhs = (sumh - h(mp.mpc(0)) - h(mp.mpc(1))) * 2 * mp.pi * 1j
    assert abs(contour - lhs) < mp.mpf("1e-5")


def test_contour_shift_paley_wiener():
    """Contour-shift identity for a Paley-Wiener test function:
    h(s) = integral_{-1}^{1} exp(i(s-1/2)u) du = 2 sin(s-1/2)/(s-1/2),
    which is entire, even-symmetric (h(1-s)=h(s)), real-symmetric
    (h(conj s)=conj h(s)) and decays like 1/|Im s|.  On [-1,2]x[-30,30]:
      contour = 2i*Right - 2i*Im(Top) = (sum h(rho) - h(0) - h(1))*2*pi*i."""
    import mpmath as mp

    mp.mp.dps = 30

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    def h(s):
        z = s - mp.mpf(1) / 2
        if z == 0:
            return mp.mpc(2)
        return 2 * mp.sin(z) / z

    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    Phi = lambda s: g(s) * h(s)

    bottom = mp.quad(lambda x: Phi(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: Phi(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * Phi(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * Phi(mp.mpc(x1, y)), [-T, T])
    contour = bottom - top + right - left

    right_dy = mp.quad(lambda y: Phi(mp.mpc(2, y)), [-T, T])
    rhs = 2j * right_dy - 2j * mp.im(top)
    assert abs(contour - rhs) < mp.mpf("1e-3")

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    sumh = 2 * sum(h(z) for z in zeros)
    lhs = (sumh - h(mp.mpc(0)) - h(mp.mpc(1))) * 2 * mp.pi * 1j
    assert abs(contour - lhs) < mp.mpf("1e-3")


def test_archimedean_integral_real():
    """Numerically check that the critical-line archimedean integral is real:
    for h(t) = exp(-t^2) on [-5,5], the integral of
    (1/2 log pi - 1/2(psi(1/4+it/2) + psi(1/4-it/2))) h(t)
    has zero imaginary part, and equals the integral of
    (1/2 log pi - Re psi(1/4+it/2)) h(t)."""
    import mpmath as mp

    mp.mp.dps = 25
    arch = lambda t: (mp.mpf(1) / 2 * mp.log(mp.pi)
                      - mp.mpf(1) / 2 * (mp.digamma(mp.mpc(mp.mpf(1) / 4, t / 2))
                                         + mp.digamma(mp.mpc(mp.mpf(1) / 4, -t / 2))))
    h = lambda t: mp.e ** (-t * t)
    val = mp.quad(lambda t: arch(t) * h(t), [-5, 5])
    val2 = mp.quad(lambda t: (mp.mpf(1) / 2 * mp.log(mp.pi)
                              - mp.re(mp.digamma(mp.mpc(mp.mpf(1) / 4, t / 2)))) * h(t),
                   [-5, 5])
    assert abs(mp.im(val)) < mp.mpf("1e-15")
    assert abs(val - val2) < mp.mpf("1e-15")


def test_prime_measure_fourier_closed():
    """Numerically verify the closed Fourier prime-measure identity at nonzero
    u: for c = 2, y in [-5,5], u = 0.7,
    ∫ L_Λ(c+iy) e^{iuy} dy = Σ_n Λ(n)(n^{-(c+iy2)}e^{iuy2} - n^{-(c+iy1)}e^{iuy1})
      / (i(u - log n))."""
    import mpmath as mp

    mp.mp.dps = 20
    c, y1, y2, u = mp.mpf(2), mp.mpf(-5), mp.mpf(5), mp.mpf("0.7")
    I = mp.mpc(0, 1)
    direct = mp.quad(lambda y: (-mp.zeta(mp.mpc(c, y), derivative=1) / mp.zeta(mp.mpc(c, y)))
                     * mp.e ** (I * u * y), [y1, y2])

    N = 200000
    lam = [mp.mpf(0)] * (N + 1)
    is_comp = [False] * (N + 1)
    for p in range(2, N + 1):
        if not is_comp[p]:
            lp = mp.log(p)
            pk = p
            while pk <= N:
                lam[pk] = lp
                pk *= p
            for m in range(p * p, N + 1, p):
                is_comp[m] = True
    S = mp.mpc(0)
    for n in range(2, N + 1):
        if lam[n] != 0:
            A = mp.power(n, -(c + I * y2)) * mp.e ** (I * u * y2)
            B = mp.power(n, -(c + I * y1)) * mp.e ** (I * u * y1)
            S += lam[n] * (A - B) / (I * (u - mp.log(n)))
    assert abs(S - direct) < mp.mpf("1e-5")


def test_prime_side_fourier_closed_identity():
    """Numerically verify the assembled closed Fourier identity on Re = 2,
    y in [-5,5], u = 0.7:
      ∫ Z'/Z(c+iy)e^{iuy}·i dy = -∫ arch·e^{iuy}·i dy - (Σ_n closed coefficient)·i,
    with Z'/Z = -arch - L_Λ."""
    import mpmath as mp

    mp.mp.dps = 20
    c, y1, y2, u = mp.mpf(2), mp.mpf(-5), mp.mpf(5), mp.mpf("0.7")
    I = mp.mpc(0, 1)
    arch = lambda s: mp.mpf(1) / 2 * mp.log(mp.pi) - mp.mpf(1) / 2 * mp.digamma(s / 2)
    L = lambda s: -mp.zeta(s, derivative=1) / mp.zeta(s)
    zpz = lambda s: -arch(s) - L(s)

    lhs = mp.quad(lambda y: zpz(mp.mpc(c, y)) * mp.e ** (I * u * y) * I, [y1, y2])
    archint = mp.quad(lambda y: arch(mp.mpc(c, y)) * mp.e ** (I * u * y) * I, [y1, y2])

    N = 200000
    lam = [mp.mpf(0)] * (N + 1)
    is_comp = [False] * (N + 1)
    for p in range(2, N + 1):
        if not is_comp[p]:
            lp = mp.log(p)
            pk = p
            while pk <= N:
                lam[pk] = lp
                pk *= p
            for m in range(p * p, N + 1, p):
                is_comp[m] = True
    S = mp.mpc(0)
    for n in range(2, N + 1):
        if lam[n] != 0:
            A = mp.power(n, -(c + I * y2)) * mp.e ** (I * u * y2)
            B = mp.power(n, -(c + I * y1)) * mp.e ** (I * u * y1)
            S += lam[n] * (A - B) / (I * (u - mp.log(n)))
    rhs = -archint - S * I
    assert abs(lhs - rhs) < mp.mpf("1e-5")


def test_test_function_formula_rational():
    """The zero-side formula for a rational test function analytic on the
    rectangle with real coefficients: h(s) = 1/((s-5)^2+1), poles at 5 +- i
    (outside [-1,2]x[-30,30]).  Because h has real coefficients, the contour
    integral is purely imaginary and the zero sum pairs conjugates:
    sum over the six zeros = 2*sum Re h(rho) over the three upper zeros."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    h = lambda s: 1 / ((s - 5) ** 2 + 1)
    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    Phi = lambda s: g(s) * h(s)

    bottom = mp.quad(lambda x: Phi(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: Phi(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * Phi(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * Phi(mp.mpc(x1, y)), [-T, T])
    val = bottom - top + right - left

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    sumh = 2 * sum(mp.re(h(z)) for z in zeros)
    expected = (sumh - mp.re(h(mp.mpc(0))) - mp.re(h(mp.mpc(1)))) * 2 * mp.pi * 1j
    assert abs(val - expected) < mp.mpf("1e-6")


def test_contour_shift_quadratic():
    """Contour-shift identity for the symmetric quadratic test function
    h(s) = (s-1/2)^2 on [-1,2]x[-30,30]:
      contour = 2i*Right - 2i*Im(Top) = (sum h(rho) - h(0) - h(1))*2*pi*i.
    h is symmetric (h(1-s)=h(s)), real on the real axis, and does not decay;
    the identity is a finite-T contour identity."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    h = lambda s: (s - mp.mpf(1) / 2) ** 2
    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(30)
    Phi = lambda s: g(s) * h(s)

    bottom = mp.quad(lambda x: Phi(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: Phi(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * Phi(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * Phi(mp.mpc(x1, y)), [-T, T])
    contour = bottom - top + right - left

    rhs = 2j * mp.quad(lambda y: Phi(mp.mpc(2, y)), [-T, T]) - 2j * mp.im(top)
    assert abs(contour - rhs) < mp.mpf("1e-3")

    zeros = [mp.zetazero(k) for k in (1, 2, 3)]
    sumh = 2 * sum(mp.re(h(z)) for z in zeros)
    lhs = (sumh - mp.re(h(mp.mpc(0))) - mp.re(h(mp.mpc(1)))) * 2 * mp.pi * 1j
    assert abs(contour - lhs) < mp.mpf("1e-3")


def test_rectIntegral_inv_sq_eq_zero():
    """The inverse-square winding integral vanishes: for a = 0.3+0.2i strictly
    inside [-1,2]x[-0.5,1.5], the boundary integral of (z-a)^{-2} is 0 (while
    the winding integral of 1/(z-a) is 2*pi*i)."""
    import mpmath as mp

    mp.mp.dps = 25
    a = mp.mpc("0.3", "0.2")
    x1, x2, y1, y2 = mp.mpf(-1), mp.mpf(2), mp.mpf("-0.5"), mp.mpf("1.5")

    def contour(f):
        bottom = mp.quad(lambda x: f(mp.mpc(x, y1)), [x1, x2])
        top = mp.quad(lambda x: f(mp.mpc(x, y2)), [x1, x2])
        right = mp.quad(lambda y: 1j * f(mp.mpc(x2, y)), [y1, y2])
        left = mp.quad(lambda y: 1j * f(mp.mpc(x1, y)), [y1, y2])
        return bottom - top + right - left

    assert abs(contour(lambda z: 1 / (z - a) ** 2)) < mp.mpf("1e-18")
    assert abs(contour(lambda z: 1 / (z - a)) - 2j * mp.pi) < mp.mpf("1e-18")


def test_rectIntegral_derivative_cauchy():
    """Numerically verify the rectangle derivative Cauchy formula
    ∮ h(z)/(z-a)^2 dz = 2*pi*i*h'(a) for h = z^2 and z^3, with
    a = 0.3+0.2i strictly inside [-1,2]x[-0.5,1.5].  (The general Lean proof
    is deferred; this confirms the mathematical statement.)"""
    import mpmath as mp

    mp.mp.dps = 25
    a = mp.mpc("0.3", "0.2")
    x1, x2, y1, y2 = mp.mpf(-1), mp.mpf(2), mp.mpf("-0.5"), mp.mpf("1.5")

    def contour(f):
        bottom = mp.quad(lambda x: f(mp.mpc(x, y1)), [x1, x2])
        top = mp.quad(lambda x: f(mp.mpc(x, y2)), [x1, x2])
        right = mp.quad(lambda y: 1j * f(mp.mpc(x2, y)), [y1, y2])
        left = mp.quad(lambda y: 1j * f(mp.mpc(x1, y)), [y1, y2])
        return bottom - top + right - left

    for h, hp in [(lambda z: z ** 2, lambda z: 2 * z), (lambda z: z ** 3, lambda z: 3 * z ** 2)]:
        val = contour(lambda z: h(z) / (z - a) ** 2)
        expected = 2j * mp.pi * hp(a)
        assert abs(val - expected) < mp.mpf("1e-18")


def test_rectIntegral_inv_cube_eq_zero():
    """The inverse-cube winding integral vanishes: for a = 0.3+0.2i strictly
    inside [-1,2]x[-0.5,1.5], the boundary integral of (z-a)^{-3} is 0."""
    import mpmath as mp

    mp.mp.dps = 25
    a = mp.mpc("0.3", "0.2")
    x1, x2, y1, y2 = mp.mpf(-1), mp.mpf(2), mp.mpf("-0.5"), mp.mpf("1.5")

    def contour(f):
        return (mp.quad(lambda x: f(mp.mpc(x, y1)), [x1, x2])
                - mp.quad(lambda x: f(mp.mpc(x, y2)), [x1, x2])
                + mp.quad(lambda y: 1j * f(mp.mpc(x2, y)), [y1, y2])
                - mp.quad(lambda y: 1j * f(mp.mpc(x1, y)), [y1, y2]))

    assert abs(contour(lambda z: 1 / (z - a) ** 3)) < mp.mpf("1e-18")


def test_rectIntegral_second_derivative_cauchy():
    """Numerically verify ∮ h(z)/(z-a)^3 dz = pi*i*h''(a) for h = z^3, z^4,
    with a = 0.3+0.2i strictly inside [-1,2]x[-0.5,1.5].  (The Lean proof is
    deferred; the inverse-cube winding lemma is Lean-checked.)"""
    import mpmath as mp

    mp.mp.dps = 25
    a = mp.mpc("0.3", "0.2")
    x1, x2, y1, y2 = mp.mpf(-1), mp.mpf(2), mp.mpf("-0.5"), mp.mpf("1.5")

    def contour(f):
        return (mp.quad(lambda x: f(mp.mpc(x, y1)), [x1, x2])
                - mp.quad(lambda x: f(mp.mpc(x, y2)), [x1, x2])
                + mp.quad(lambda y: 1j * f(mp.mpc(x2, y)), [y1, y2])
                - mp.quad(lambda y: 1j * f(mp.mpc(x1, y)), [y1, y2]))

    for h, hpp in [(lambda z: z ** 3, lambda z: 6 * z), (lambda z: z ** 4, lambda z: 12 * z ** 2)]:
        val = contour(lambda z: h(z) / (z - a) ** 3)
        expected = 1j * mp.pi * hpp(a)
        assert abs(val - expected) < mp.mpf("1e-18")


def test_completed_zeta_cauchy_instances():
    """Numerically verify the completed-zeta Cauchy instances on
    [0.25,0.4]x[-2,2] (avoiding the poles 0, 1), a = 0.3+0.2i inside:
      contour Z/(z-a)   = 2*pi*i*Z(a),
      contour Z/(z-a)^2 = 2*pi*i*Z'(a).
    The intervals are split at a to keep quadrature accurate."""
    import mpmath as mp

    mp.mp.dps = 30
    Z = lambda s: mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)
    a = mp.mpc("0.3", "0.2")
    x1, x2, y1, y2 = mp.mpf("0.25"), mp.mpf("0.4"), mp.mpf(-2), mp.mpf(2)

    def contour(f):
        return (mp.quad(lambda x: f(mp.mpc(x, y1)), [x1, mp.re(a), x2], maxdegree=12)
                - mp.quad(lambda x: f(mp.mpc(x, y2)), [x1, mp.re(a), x2], maxdegree=12)
                + mp.quad(lambda y: 1j * f(mp.mpc(x2, y)), [y1, mp.im(a), y2], maxdegree=12)
                - mp.quad(lambda y: 1j * f(mp.mpc(x1, y)), [y1, mp.im(a), y2], maxdegree=12))

    assert abs(contour(lambda z: Z(z) / (z - a)) - 2j * mp.pi * Z(a)) < mp.mpf("1e-18")
    assert abs(contour(lambda z: Z(z) / (z - a) ** 2) - 2j * mp.pi * mp.diff(Z, a)) < mp.mpf("1e-18")


def test_prime_measure_fourier_closed_u15():
    """The closed Fourier prime-measure identity at a second frequency,
    u = 1.5: on Re = 2, y in [-5,5], the direct integral and the closed sum
    agree (truncated at n = 3*10^5)."""
    import mpmath as mp

    mp.mp.dps = 20
    c, y1, y2, u = mp.mpf(2), mp.mpf(-5), mp.mpf(5), mp.mpf("1.5")
    I = mp.mpc(0, 1)
    direct = mp.quad(lambda y: (-mp.zeta(mp.mpc(c, y), derivative=1) / mp.zeta(mp.mpc(c, y)))
                     * mp.e ** (I * u * y), [y1, y2])

    N = 300000
    lam = [mp.mpf(0)] * (N + 1)
    is_comp = [False] * (N + 1)
    for p in range(2, N + 1):
        if not is_comp[p]:
            lp = mp.log(p)
            pk = p
            while pk <= N:
                lam[pk] = lp
                pk *= p
            for m in range(p * p, N + 1, p):
                is_comp[m] = True
    S = mp.mpc(0)
    for n in range(2, N + 1):
        if lam[n] != 0:
            A = mp.power(n, -(c + I * y2)) * mp.e ** (I * u * y2)
            B = mp.power(n, -(c + I * y1)) * mp.e ** (I * u * y1)
            S += lam[n] * (A - B) / (I * (u - mp.log(n)))
    assert abs(S - direct) < mp.mpf("1e-5")


def test_fourierG_one_eq():
    """The Fourier transform of the constant 1 on [-1,1] is 2 sin(x)/x:
    numerically check ∫_{-1}^{1} e^{-ixu} du = 2 sin(x)/x for several x."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for x in (mp.mpf("0.5"), mp.mpf(1.3), mp.mpf(2.7), mp.mpf(-1.7)):
        val = mp.quad(lambda u: mp.e ** (-I * x * u), [-1, 1])
        assert abs(val - 2 * mp.sin(x) / x) < mp.mpf("1e-20")


def test_fourierG_exp_eq():
    """The Fourier transform of a complex exponential:
    ∫_{-1}^{1} e^{bu} e^{-ixu} du = (e^{b-ix} - e^{-b+ix})/(b-ix), checked
    numerically for b = 0.5+0.3i at several real x."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    b = mp.mpc("0.5", "0.3")
    for x in (mp.mpf("0.4"), mp.mpf("1.7"), mp.mpf("-2.1")):
        val = mp.quad(lambda u: mp.e ** (b * u) * mp.e ** (-I * x * u), [-1, 1])
        expected = (mp.e ** (b - I * x) - mp.e ** (-b + I * x)) / (b - I * x)
        assert abs(val - expected) < mp.mpf("1e-20")


def test_fourierG_exp_I_eq():
    """The pure-exponential Fourier transform:
    ∫_{-1}^{1} e^{iau} e^{-ixu} du = 2 sin(a-x)/(a-x), checked numerically."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for a, x in [(mp.mpf("1.3"), mp.mpf("2.7")), (mp.mpf("-0.8"), mp.mpf("1.9"))]:
        val = mp.quad(lambda u: mp.e ** (I * a * u) * mp.e ** (-I * x * u), [-1, 1])
        expected = 2 * mp.sin(a - x) / (a - x)
        assert abs(val - expected) < mp.mpf("1e-20")


def test_fourierG_trig_eq():
    """The trigonometric Fourier transforms:
    ∫_{-1}^{1} cos(au) e^{-ixu} du = sin(a-x)/(a-x) + sin(a+x)/(a+x),
    ∫_{-1}^{1} sin(au) e^{-ixu} du = i(sin(a+x)/(a+x) - sin(a-x)/(a-x)),
    checked numerically for a = 1.3, x = 2.7 and a = -0.8, x = 1.9."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for a, x in [(mp.mpf("1.3"), mp.mpf("2.7")), (mp.mpf("-0.8"), mp.mpf("1.9"))]:
        vc = mp.quad(lambda u: mp.cos(a * u) * mp.e ** (-I * x * u), [-1, 1])
        ec = mp.sin(a - x) / (a - x) + mp.sin(a + x) / (a + x)
        assert abs(vc - ec) < mp.mpf("1e-20")
        vs = mp.quad(lambda u: mp.sin(a * u) * mp.e ** (-I * x * u), [-1, 1])
        es = 1j * (mp.sin(a + x) / (a + x) - mp.sin(a - x) / (a - x))
        assert abs(vs - es) < mp.mpf("1e-20")


def test_fourierG_id_eq():
    """The Fourier transform of the identity:
    ∫_{-1}^{1} u e^{-ixu} du = e^{-ix}(i/x + 1/x^2) - e^{ix}(-i/x + 1/x^2)."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for x in (mp.mpf("1.3"), mp.mpf("2.7")):
        val = mp.quad(lambda u: u * mp.e ** (-I * x * u), [-1, 1])
        expected = (mp.e ** (-I * x) * (I / x + 1 / x ** 2)
                    - mp.e ** (I * x) * (-I / x + 1 / x ** 2))
        assert abs(val - expected) < mp.mpf("1e-20")


def test_fourierG_sq_eq():
    """The Fourier transform of the square:
    ∫_{-1}^{1} u^2 e^{-ixu} du = e^{-ix}(i/x + 2/x^2 - 2i/x^3)
                               - e^{ix}(i/x - 2/x^2 - 2i/x^3)."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for x in (mp.mpf("1.3"), mp.mpf("2.7")):
        val = mp.quad(lambda u: u ** 2 * mp.e ** (-I * x * u), [-1, 1])
        expected = (mp.e ** (-I * x) * (I / x + 2 / x ** 2 - 2 * I / x ** 3)
                    - mp.e ** (I * x) * (I / x - 2 / x ** 2 - 2 * I / x ** 3))
        assert abs(val - expected) < mp.mpf("1e-20")


def test_fourierG_poly_zero_values():
    """The polynomial transforms at x = 0: ∫_{-1}^{1} 1 du = 2,
    ∫ u du = 0, ∫ u² du = 2/3, checked numerically."""
    import mpmath as mp

    mp.mp.dps = 25
    assert abs(mp.quad(lambda u: mp.mpf(1), [-1, 1]) - 2) < mp.mpf("1e-20")
    assert abs(mp.quad(lambda u: u, [-1, 1])) < mp.mpf("1e-20")
    assert abs(mp.quad(lambda u: u ** 2, [-1, 1]) - mp.mpf(2) / 3) < mp.mpf("1e-20")


def test_fourierG_cube_eq():
    """The Fourier transform of the cube:
    ∫_{-1}^{1} u^3 e^{-ixu} du = e^{-ix}(i/x + 3/x^2 - 6i/x^3 - 6/x^4)
                               - e^{ix}(-i/x + 3/x^2 + 6i/x^3 - 6/x^4)."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for x in (mp.mpf("1.3"), mp.mpf("2.7")):
        val = mp.quad(lambda u: u ** 3 * mp.e ** (-I * x * u), [-1, 1])
        expected = (mp.e ** (-I * x) * (I / x + 3 / x ** 2 - 6 * I / x ** 3 - 6 / x ** 4)
                    - mp.e ** (I * x) * (-I / x + 3 / x ** 2 + 6 * I / x ** 3 - 6 / x ** 4))
        assert abs(val - expected) < mp.mpf("1e-20")


def test_fourierG_trig_polynomial_composed():
    """End-to-end check of the composed Fourier calculus: for
    g(u) = 2 + cos(1.3u) + sin(0.7u),
    fourierG g x = 2*(2 sin x/x) + [sin(a-x)/(a-x) + sin(a+x)/(a+x)]
                  + i[sin(b+x)/(b+x) - sin(b-x)/(b-x)]
    with a = 1.3, b = 0.7, built from linearity and the closed cos/sin
    transforms."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    a, b = mp.mpf("1.3"), mp.mpf("0.7")
    g = lambda u: 2 + mp.cos(a * u) + mp.sin(b * u)
    for x in (mp.mpf("0.5"), mp.mpf("2.1")):
        direct = mp.quad(lambda u: g(u) * mp.e ** (-I * x * u), [-1, 1])
        closed = (2 * (2 * mp.sin(x) / x)
                  + (mp.sin(a - x) / (a - x) + mp.sin(a + x) / (a + x))
                  + 1j * (mp.sin(b + x) / (b + x) - mp.sin(b - x) / (b - x)))
        assert abs(direct - closed) < mp.mpf("1e-20")


def test_fourier_derivative_correspondence():
    """Numerically check the Fourier derivative correspondence
    d/dx ĝ(x) = fourierG (fun u => -i u g(u)) x for g = 1:
    ĝ(x) = 2 sin x/x, ĝ'(x) = 2(x cos x - sin x)/x^2, and
    fourierG (fun u => -i u) x = ∫_{-1}^{1} -iu e^{-ixu} du.
    (The general Lean proof via differentiation under the integral is
    deferred; this confirms the mathematical statement.)"""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    for x in (mp.mpf("1.3"), mp.mpf("2.7")):
        gp = 2 * (x * mp.cos(x) - mp.sin(x)) / x ** 2
        direct = mp.quad(lambda u: (-I * u) * mp.e ** (-I * x * u), [-1, 1])
        assert abs(gp - direct) < mp.mpf("1e-20")


def test_test_function_formula_h_eq_s_squared_small_rect():
    """The zero-side formula on a smaller rectangle [-1,2]x[-20,20] with
    h(s) = s^2: only the first zero pair (0.5 +- 14.13i) is inside, so the
    zero sum is 2*Re(rho^2); contour = (sum - h(0) - h(1))*2*pi*i."""
    import mpmath as mp

    mp.mp.dps = 20

    def g(s):
        return (-mp.mpf(1) / 2 * mp.log(mp.pi) + mp.mpf(1) / 2 * mp.digamma(s / 2)
                + mp.zeta(s, derivative=1) / mp.zeta(s))

    h = lambda s: s ** 2
    x1, x2, T = mp.mpf(-1), mp.mpf(2), mp.mpf(20)
    Phi = lambda s: g(s) * h(s)

    bottom = mp.quad(lambda x: Phi(mp.mpc(x, -T)), [x1, x2])
    top = mp.quad(lambda x: Phi(mp.mpc(x, T)), [x1, x2])
    right = mp.quad(lambda y: 1j * Phi(mp.mpc(x2, y)), [-T, T])
    left = mp.quad(lambda y: 1j * Phi(mp.mpc(x1, y)), [-T, T])
    val = bottom - top + right - left

    zeros = [mp.zetazero(1)]
    sumh = 2 * sum(mp.re(h(z)) for z in zeros)
    expected = (sumh - h(mp.mpc(0)) - h(mp.mpc(1))) * 2 * mp.pi * 1j
    assert abs(val - expected) < mp.mpf("1e-8")


def test_prime_measure_fourier_closed_u25():
    """The closed Fourier prime-measure identity at a third frequency,
    u = 2.5: on Re = 2, y in [-5,5], the direct integral and the closed sum
    agree (truncated at n = 3*10^5)."""
    import mpmath as mp

    mp.mp.dps = 20
    c, y1, y2, u = mp.mpf(2), mp.mpf(-5), mp.mpf(5), mp.mpf("2.5")
    I = mp.mpc(0, 1)
    direct = mp.quad(lambda y: (-mp.zeta(mp.mpc(c, y), derivative=1) / mp.zeta(mp.mpc(c, y)))
                     * mp.e ** (I * u * y), [y1, y2])

    N = 300000
    lam = [mp.mpf(0)] * (N + 1)
    is_comp = [False] * (N + 1)
    for p in range(2, N + 1):
        if not is_comp[p]:
            lp = mp.log(p)
            pk = p
            while pk <= N:
                lam[pk] = lp
                pk *= p
            for m in range(p * p, N + 1, p):
                is_comp[m] = True
    S = mp.mpc(0)
    for n in range(2, N + 1):
        if lam[n] != 0:
            A = mp.power(n, -(c + I * y2)) * mp.e ** (I * u * y2)
            B = mp.power(n, -(c + I * y1)) * mp.e ** (I * u * y1)
            S += lam[n] * (A - B) / (I * (u - mp.log(n)))
    assert abs(S - direct) < mp.mpf("1e-5")


def test_fourierG_derivative_general():
    """The Fourier derivative correspondence for a composed test function
    g(u) = cos(1.3u) + 2: d/dx ĝ(x) at x = 0.7 (computed from the closed
    form by a central difference) matches fourierG (fun u => -iu g(u)) x,
    i.e. ∫_{-1}^{1} -iu g(u) e^{-ixu} du."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    a = mp.mpf("1.3")
    x = mp.mpf("0.7")
    g = lambda u: mp.cos(a * u) + 2

    def G(x):
        return 2 * (2 * mp.sin(x) / x) + mp.sin(a - x) / (a - x) + mp.sin(a + x) / (a + x)

    h = mp.mpf("1e-7")
    numer = (G(x + h) - G(x - h)) / (2 * h)
    direct = mp.quad(lambda u: -I * u * g(u) * mp.e ** (-I * x * u), [-1, 1])
    assert abs(numer - direct) < mp.mpf("1e-8")


def test_riemann_lebesgue_bound():
    """The quantitative Riemann-Lebesgue bound for g(u) = cos(2u) + 1:
    |ĝ(x)| <= (|g(1)| + |g(-1)| + ∫_{-1}^{1}|g'|)/|x| for x = 10, 50."""
    import mpmath as mp

    mp.mp.dps = 20
    I = mp.mpc(0, 1)
    g = lambda u: mp.cos(2 * u) + 1
    gp = lambda u: -2 * mp.sin(2 * u)
    for x in (mp.mpf(10), mp.mpf(50)):
        val = abs(mp.quad(lambda u: g(u) * mp.e ** (-I * x * u), [-1, 1]))
        bound = (abs(g(mp.mpf(1))) + abs(g(mp.mpf(-1)))
                 + mp.quad(lambda u: abs(gp(u)), [-1, 1])) / abs(x)
        assert val <= bound * mp.mpf("1.0001")


def test_riemann_lebesgue_bound_sq():
    """The second-order Riemann-Lebesgue bound for g(u) = (1-u^2)^2:
    |ĝ(x)| <= A/|x| + B/|x|^2 with A = |g(1)|+|g(-1)|,
    B = |g'(1)|+|g'(-1)| + ∫|g''|, for x = 5, 10."""
    import mpmath as mp

    mp.mp.dps = 25
    I = mp.mpc(0, 1)
    g = lambda u: (1 - u * u) ** 2
    gp = lambda u: -4 * u * (1 - u * u)
    gpp = lambda u: -4 + 12 * u * u
    A = abs(g(mp.mpf(1))) + abs(g(mp.mpf(-1)))
    B = (abs(gp(mp.mpf(1))) + abs(gp(mp.mpf(-1)))
         + mp.quad(lambda u: abs(gpp(u)), [-1, 1]))
    for x in (mp.mpf(5), mp.mpf(10)):
        val = abs(mp.quad(lambda u: g(u) * mp.e ** (-I * x * u), [-1, 1]))
        bound = A / abs(x) + B / abs(x) ** 2
        assert val <= bound * mp.mpf("1.0001")


def test_fourier_inversion_bump():
    """Numerically validate Fourier inversion for g(u) = (1-u^2)^2 on [-1,1]
    (zero extension): g(u) = ∫_ℝ ĝ(v) e^{2πiuv} dv with
    ĝ(v) = ∫_{-1}^{1} g(w) e^{-2πivw} dw, at u = 0.3, -0.55."""
    import mpmath as mp

    mp.mp.dps = 25
    g = lambda u: (1 - u * u) ** 2 if abs(u) <= 1 else 0

    def ghat(v):
        return mp.quad(lambda w: g(w) * mp.e ** (-2j * mp.pi * v * w), [-1, 1])

    for u0 in (mp.mpf("0.3"), mp.mpf("-0.55")):
        val = mp.quad(lambda v: ghat(v) * mp.e ** (2j * mp.pi * u0 * v),
                      [-40, -1, 0, 1, 40], maxdegree=8)
        assert abs(val - g(u0)) < mp.mpf("1e-5")


def test_paleyWiener_critical_line_real():
    """The Paley–Wiener test function is real on the critical line for real g:
    for g(u) = (1-u^2)^2, h(1/2 + it) should be real for t = 0, 2.3, -5.1."""
    import mpmath as mp

    mp.mp.dps = 20
    I = mp.mpc(0, 1)
    g = lambda u: (1 - u * u) ** 2

    def h(s):
        return mp.quad(lambda u: g(u) * mp.e ** (I * (s - mp.mpf(1) / 2) * u), [-1, 1])

    for t in (mp.mpf("0.0"), mp.mpf("2.3"), mp.mpf("-5.1")):
        val = h(mp.mpf(1) / 2 + t * I)
        assert abs(mp.conj(val) - val) < mp.mpf("1e-18")
