import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    categorical_psi,
    egyptian_denominators,
    egyptian_reciprocal_sums,
    finite_theta_modular_residual,
    first_gamma_pole,
    functional_equation_residual,
    half_spectrum_su2k,
    gamma_ratio,
    ising,
    lattice_z2_lambda,
    mellin_finite,
    psi_of,
    qefe_prefactor,
    qefe_rhs,
    root_number,
    sign_product,
    source_mellin_rhs,
    su2_4,
    psi_su2k,
    su2k_data,
)


from rational_certificates import (  # noqa: E402
    beta_enclosure,
    gamma_enclosure,
    lambda_z2_half,
    lambda_z2_integer,
    lambda_z2_rational,
    phase_psi_enclosure,
)

PST_PY = Path(__file__).resolve().parents[2] / "partial-sum-plus-tail" / "python"


def _load_pst():
    """Load the partial-sum-plus-tail programme under a non-conflicting name."""
    import importlib.util
    if str(PST_PY) not in sys.path:
        sys.path.insert(0, str(PST_PY))
    spec = importlib.util.spec_from_file_location("pst_programme", PST_PY / "programme.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


EXAMPLES = (ising(), su2_4())


def test_egyptian_identity_examples():
    """Lemma 2.2: sum 1/m_i = 1 and sum_{i != 0} 1/m_i = 1 - 1/D^2."""
    for data in EXAMPLES:
        total, non_unit = egyptian_reciprocal_sums(data["D2"], data["dsq"])
        assert total == 1
        assert non_unit == 1 - sp.Rational(1, data["D2"])
        assert sum(1 / mi for mi in data["m"]) == 1


def test_egyptian_denominator_validation():
    """Malformed MTC data is rejected rather than silently accepted."""
    with pytest.raises(ValueError):
        egyptian_denominators(4, [1, 2])  # does not sum to D^2
    with pytest.raises(ValueError):
        egyptian_denominators(4, [1, 0, 3])  # zero quantum dimension
    with pytest.raises(ValueError):
        egyptian_denominators(-4, [1, 3])  # negative total dimension
    with pytest.raises(ValueError):
        egyptian_denominators(4, [])  # empty datum
    with pytest.raises(ValueError):
        egyptian_denominators(4, [2, 1, 1])  # unit object has d^2 != 1
    with pytest.raises(ValueError):
        egyptian_denominators(4, [1, 2, 1], unit=1)  # wrong unit index value


def test_integer_egyptian_denominators_are_optional():
    """The integral-m condition is an explicit extra hypothesis, not automatic."""
    assert egyptian_denominators(5, [1, 4]) == [5, sp.Rational(5, 4)]
    with pytest.raises(ValueError):
        egyptian_denominators(5, [1, 4], require_integer_m=True)


def test_dirichlet_series_exact_values():
    """Psi(0) = sum chi_i = 1 and Psi(1) = sum chi_i / m_i = 0 in both examples."""
    for data in EXAMPLES:
        assert psi_of(data, 0) == 1
        assert psi_of(data, 1) == 0
    # Explicit series displayed in the source.
    assert sp.simplify(psi_of(ising(), sp.Symbol("s", real=True)) - (
        2 * 4 ** (-sp.Symbol("s", real=True)) - 2 ** (-sp.Symbol("s", real=True))
    )) == 0


def test_gamma_ratio_and_prefactor_at_centre():
    """At s = 1/2 the gamma ratio and the full QEFE prefactor are both 1."""
    half = sp.Rational(1, 2)
    for data in EXAMPLES:
        assert gamma_ratio(data["a"], half) == 1
        assert qefe_prefactor(data["D2"], data["a"], half) == 1


def test_claimed_functional_equation_at_centre():
    """The archived equation holds at s = 1/2 for both worked examples."""
    half = sp.Rational(1, 2)
    for data in EXAMPLES:
        lhs = psi_of(data, half)
        rhs = qefe_rhs(data, half)
        assert sp.simplify(lhs - rhs) == 0
        assert functional_equation_residual(data, half) == 0


def test_claimed_functional_equation_fails_off_centre():
    """Honesty check: the displayed v8 identity fails away from s = 1/2.

    The source claims (§6.1, §6.2) that the equation holds identically for
    Ising and SU(2)_4.  Using the data tabulated there, the two sides agree
    only at the central point, where the prefactor happens to be 1.  Values
    are evaluated to 25 significant digits; agreement is not claimed.
    """
    for data in EXAMPLES:
        for s in (sp.Rational(3, 10), sp.Rational(7, 10), sp.Rational(13, 10)):
            residual = sp.N(functional_equation_residual(data, s), 25)
            assert abs(complex(residual)) > 0.1


def test_ising_sign_product_inconsistency():
    """Appendix A defines epsilon as the sign product; Ising gives -1, not +1.

    SU(2)_4 gives +1, so only the Ising example exposes the discrepancy.
    """
    assert sign_product(ising()) == -1
    assert sign_product(su2_4()) == 1


def test_categorical_psi_rejects_mismatched_lengths():
    with pytest.raises(ValueError):
        categorical_psi([4, 2], [1], 0)
    with pytest.raises(ValueError):
        categorical_psi([], [], 0)
    with pytest.raises(ValueError):
        categorical_psi([4, 0], [1, -1], 0)  # non-positive denominator


def test_source_mellin_normalisation():
    """The printed theta exponent contradicts the source's own Mellin formula.

    Section 2.4 prints ``exp(-pi (m_i/D)^2 tau)`` but asserts the Mellin
    transform ``Gamma(s) pi^{-s} D^{2s} Psi(s)``.  The two are consistent only
    with the exponent ``m_i/D^2``; the printed form disagrees by an explicit
    rational multiple of ``1/pi^2`` at ``s = 2``.
    """
    expected = {ising()["name"]: 9 / (8 * sp.pi ** 2),
                su2_4()["name"]: 2 / (3 * sp.pi ** 2)}
    for data in EXAMPLES:
        printed = sp.simplify(
            mellin_finite(data, 2, printed_exponent=True) - source_mellin_rhs(data, 2)
        )
        corrected = sp.simplify(
            mellin_finite(data, 2, printed_exponent=False) - source_mellin_rhs(data, 2)
        )
        assert printed == expected[data["name"]]
        assert corrected == 0


def test_gamma_pole_obstruction():
    """At the first pole ``s = 1 + a`` the numerator ``Psi(-a)`` is non-zero.

    The right-hand side of the claimed equation therefore has a pole that the
    entire left-hand side cannot match.  This is the structural reason the v8
    identity fails, independently of the numerical residuals.
    """
    for data in EXAMPLES:
        s0 = first_gamma_pole(data)
        assert (1 - s0 + data["a"]) / 2 == 0
        assert psi_of(data, -data["a"]) != 0


def test_pole_point_values():
    """Exact values at the pole points used by the Lean refutations T8/T9."""
    assert psi_of(ising(), 3) == sp.Rational(-3, 32)
    assert psi_of(su2_4(), 4) == sp.Rational(1, 216)


def test_finite_theta_is_not_modular():
    """The finite theta does not satisfy the weight-1/2 relation of Lemma 4.2."""
    for data in EXAMPLES:
        residual = sp.N(finite_theta_modular_residual(data, 10), 20)
        assert abs(complex(residual)) > 0.1


def test_finite_theta_mellin_identity():
    """The finite theta is the Mellin partner of Psi.

    With ``Theta(tau) = sum chi_i exp(-pi tau / d_i^2)`` and ``Re s > 0``,
    ``integral tau^(s-1) Theta dtau = Gamma(s) pi^(-s) D^(2s) Psi(s)``.
    """
    for data in EXAMPLES:
        for s in (2, 3, sp.Rational(3, 2)):
            assert sp.simplify(
                mellin_finite(data, s) - source_mellin_rhs(data, s)
            ) == 0


def test_su2k_integer_zeros():
    """The alternating SU(2)_k polynomial vanishes at integer s when k is large enough."""
    for k in (4, 8, 16):
        assert abs(psi_su2k(k, 1)) < 1e-12
        assert abs(psi_su2k(k, 2)) < 1e-12
    assert abs(psi_su2k(8, 3)) < 1e-12


def test_su2k_half_spectrum_zeta():
    """The corrected zeta/eta limit is the half-spectrum sum of d_j^{-2s}."""
    import mpmath as mp
    k = 2048
    for s in (1, 2):
        zeta_val = mp.zeta(2 * s)
        eta_val = (1 - 2 ** (1 - 2 * s)) * zeta_val
        assert abs(half_spectrum_su2k(k, s) - zeta_val) < 1e-3
        assert abs(half_spectrum_su2k(k, s, signed=True) - eta_val) < 1e-3


def test_ising_galois_signs():
    """Ising: sigma(sqrt2)=-sqrt2 acts with signs (1,-1,1) and identity permutation."""
    r = sp.sqrt(2)
    S = sp.Matrix([[1, r, 1], [r, 0, -r], [1, -r, 1]]) / 2
    eps = (1, -1, 1)
    for i in range(3):
        for j in range(3):
            lhs = sp.simplify(S[i, j].subs(r, -r, simultaneous=True))
            rhs = eps[i] * eps[j] * S[i, j]
            assert sp.simplify(lhs - rhs) == 0


def test_su2_4_sqrt3_obstruction():
    """No sign/permutation datum exists for the nontrivial sqrt3 conjugation.

    With ``S~ = (A + sqrt3 B)/12``, equivariance under ``sqrt3 -> -sqrt3``
    requires ``A_ij = eps_i eps_j A_{p(i)p(j)}`` and
    ``-B_ij = eps_i eps_j B_{p(i)p(j)}``.  An exhaustive integer check finds
    no solution, the diagonal entries at 1 and 3 forcing ``eps_1^2 = -1``.
    """
    import itertools
    A = sp.Matrix([[1, 0, 2, 0, 1],
                   [0, 0, 0, 0, 0],
                   [2, 0, -2, 0, 2],
                   [0, 0, 0, 0, 0],
                   [1, 0, 2, 0, 1]])
    B = sp.Matrix([[0, 1, 0, 1, 0],
                   [1, 1, 0, -1, -1],
                   [0, 0, 0, 0, 0],
                   [1, -1, 0, 1, -1],
                   [0, -1, 0, -1, 0]])
    solutions = []
    for perm in itertools.permutations(range(5)):
        for tail in itertools.product((1, -1), repeat=4):
            eps = (1,) + tail
            ok = all(
                A[i, j] == eps[i] * eps[j] * A[perm[i], perm[j]]
                and -B[i, j] == eps[i] * eps[j] * B[perm[i], perm[j]]
                for i in range(5) for j in range(5)
            )
            if ok:
                solutions.append((perm, eps))
    assert solutions == []
    assert A[1, 1] == 0 and B[1, 1] == 1
    assert A[3, 3] == 0 and B[3, 3] == 1


def test_root_numbers():
    """Normalized Gauss root numbers from the standard T data."""
    z16 = sp.exp(sp.I * sp.pi / 8)
    z8 = sp.exp(sp.I * sp.pi / 4)
    w = sp.exp(2 * sp.I * sp.pi / 3)
    W_ising = (1 * 1 + 2 * z16 + 1 * (-1)) / 2
    assert sp.simplify(W_ising - z16) == 0
    W_su2 = (1 * 1 + 3 * z8 + 4 * w + 3 * z8 ** 5 + 1 * 1) / sp.sqrt(12)
    assert abs(complex(sp.N(W_su2)) - 1j) < 1e-12


def test_z2_epstein_functional_equation():
    """The completed square-lattice L-series is self-dual: Lambda(s)=Lambda(1-s)."""
    for s in (1.5, 2.5, 0.7):
        ratio = lattice_z2_lambda(s) / lattice_z2_lambda(1 - s)
        assert abs(complex(ratio) - 1) < 1e-12


def test_beta_rational_enclosure():
    """Rational enclosure of beta(2) via the reusable wrapper."""
    from fractions import Fraction as F
    import mpmath as mp

    beta = beta_enclosure(2, 2)
    assert beta.width < F(1, 10 ** 20)
    assert float(beta.lo) <= float(mp.catalan) <= float(beta.hi)


def test_z2_lambda_rational_enclosure():
    """Rational enclosure of Lambda_Z2(2) = (2/3) Catalan."""
    from fractions import Fraction as F
    import mpmath as mp

    lam = lambda_z2_integer(2)
    ref = 2 * mp.catalan / 3
    assert lam.width < F(1, 10 ** 20)
    assert float(lam.lo) <= float(ref) <= float(lam.hi)


def test_lambda_z2_half_integer_enclosure():
    """Rational enclosure of Lambda_Z2(3/2), with Gamma(3/2) = sqrt(pi)/2."""
    from fractions import Fraction as F
    import mpmath as mp

    lam = lambda_z2_half(1)
    s = mp.mpf(3) / 2
    beta = mp.nsum(lambda n: (-1) ** n / (2 * n + 1) ** s, [0, mp.inf])
    ref = 4 * mp.pi ** (-s) * mp.gamma(s) * mp.zeta(s) * beta
    assert lam.width < F(1, 10 ** 20)
    assert float(lam.lo) <= float(ref) <= float(lam.hi)


def test_psi_phase_rational_enclosure():
    """Rational enclosure of the SU(2)_4 phase-corrected value at s = 1/2, t = 0."""
    from fractions import Fraction as F
    import mpmath as mp

    mp.mp.dps = 80
    real, imag = phase_psi_enclosure(
        [12, 4, 3, 4, 12], [1, -1, 1, -1, 1], F(1, 2), F(1, 2), 0, 0
    )
    ref = mp.mpf(2) / mp.sqrt(12) - 2 / mp.sqrt(4) + 1 / mp.sqrt(3)
    assert real.width < F(1, 10 ** 30)
    assert float(real.lo) <= float(ref) <= float(real.hi)
    assert float(imag.lo) <= 0 <= float(imag.hi)


def test_phase_psi_nonzero_t_enclosure():
    """Rational enclosure at t = 1, where both real and imaginary parts matter."""
    from fractions import Fraction as F
    import mpmath as mp

    mp.mp.dps = 60
    ms = [12, 4, 3, 4, 12]
    chi = [1, -1, 1, -1, 1]
    real, imag = phase_psi_enclosure(ms, chi, 1, 1, 1, 1)
    ref = sum(c * mp.mpf(m) ** (-1) * mp.e ** (-1j * mp.log(m))
              for m, c in zip(ms, chi))
    assert real.width < F(1, 10 ** 30)
    assert imag.width < F(1, 10 ** 30)
    assert float(real.lo) <= float(ref.real) <= float(real.hi)
    assert float(imag.lo) <= float(ref.imag) <= float(imag.hi)


def test_gamma_rational_enclosure():
    """General rational Gamma enclosure, including a negative non-integer."""
    from fractions import Fraction as F
    import mpmath as mp

    mp.mp.dps = 60
    for x in (F(1, 3), F(1, 2), F(7, 3), F(-1, 2)):
        g = gamma_enclosure(x, bits=80)
        ref = mp.gamma(mp.mpf(x.numerator) / x.denominator)
        assert g.width < F(1, 10 ** 15)
        assert float(g.lo) <= float(ref) <= float(g.hi)


def test_lambda_z2_rational_enclosure():
    """Quarter-integer Lambda_Z2(7/4), using the general Gamma enclosure."""
    from fractions import Fraction as F
    import mpmath as mp

    mp.mp.dps = 60
    s = F(7, 4)
    lam = lambda_z2_rational(s, bits=80)
    ss = mp.mpf(s.numerator) / s.denominator
    beta = mp.nsum(lambda n: (-1) ** n / (2 * n + 1) ** ss, [0, mp.inf])
    ref = 4 * mp.pi ** (-ss) * mp.gamma(ss) * mp.zeta(ss) * beta
    assert lam.width < F(1, 10 ** 15)
    assert float(lam.lo) <= float(ref) <= float(lam.hi)


def test_lambda_z2_critical_strip():
    """Rational enclosures inside the critical strip, 0 < s < 1."""
    from fractions import Fraction as F
    import mpmath as mp

    mp.mp.dps = 60
    for s in (F(1, 2), F(3, 4)):
        lam = lambda_z2_rational(s, bits=96)
        ss = mp.mpf(s.numerator) / s.denominator
        beta = mp.nsum(lambda n: (-1) ** n / (2 * n + 1) ** ss, [0, mp.inf])
        ref = 4 * mp.pi ** (-ss) * mp.gamma(ss) * mp.zeta(ss) * beta
        assert lam.width < F(1, 10 ** 15)
        assert float(lam.lo) <= float(ref) <= float(lam.hi)


def test_lambda_z2_pole_rejected():
    """The evaluator rejects the pole at s = 1."""
    from fractions import Fraction as F
    import pytest

    with pytest.raises(ValueError):
        lambda_z2_rational(F(1), bits=96)
