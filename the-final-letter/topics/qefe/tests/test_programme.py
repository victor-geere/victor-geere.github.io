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
    functional_equation_residual,
    gamma_ratio,
    ising,
    psi_of,
    qefe_prefactor,
    qefe_rhs,
    sign_product,
    su2_4,
)


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
