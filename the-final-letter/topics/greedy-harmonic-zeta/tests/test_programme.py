"""Tests for the greedy harmonic zeta computation layer.

Every ``Computation`` row of the programme ledger is covered here.  The
tests use exact sympy arithmetic for the finite eta--zeta identities and
high-precision mpmath only for the complex greedy scan.
"""

import sys
from functools import lru_cache
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    abel_eta_zero,
    abel_eta_zero_limit,
    alternating_sign,
    eta_partial,
    eta_zeta_residual,
    eta_zero_finite,
    first_greedy_violation,
    greedy_correlation,
    greedy_sign,
    term,
    zeta_partial,
)


@lru_cache(maxsize=1)
def first_zero_ordinate():
    """Imaginary part of the first non-trivial zeta zero, 40-digit input."""
    with mp.workdps(40):
        return mp.im(mp.zetazero(1))


def test_partial_sums_and_edge_cases():
    assert zeta_partial(1, 0) == 0
    assert eta_partial(1, 0) == 0
    assert eta_partial(1, 1) == 1
    assert eta_partial(1, 2) == sp.Rational(1, 2)
    assert eta_partial(2, 1) == 1
    assert eta_partial(2, 2) == sp.Rational(3, 4)
    with pytest.raises(ValueError):
        zeta_partial(1, -1)
    with pytest.raises(ValueError):
        term(1, 0)


def test_finite_eta_zeta_identity_exact():
    s = sp.Symbol("s", positive=True)
    for sigma in (sp.Rational(1, 2), sp.Rational(3, 5), sp.Integer(2), s):
        for N in range(13):
            assert eta_zeta_residual(sigma, N) == 0


def test_eta_zero_finite_even_odd():
    for N in range(22):
        assert eta_zero_finite(N) == (0 if N % 2 == 0 else 1)


def test_abel_eta_zero_value_and_limit():
    assert abel_eta_zero(sp.Rational(1, 2)) == sp.Rational(1, 3)
    assert abel_eta_zero_limit() == sp.Rational(1, 2)
    # Exact remainder after N Abel terms: (-1)^N r^(N+1) / (1+r).
    r = sp.symbols("r", positive=True)
    for N in range(1, 8):
        partial = sum((-1) ** (n - 1) * r**n for n in range(1, N + 1))
        remainder = (-1) ** N * r ** (N + 1) / (1 + r)
        assert sp.simplify(partial + remainder - abel_eta_zero(r)) == 0


def test_raw_greedy_condition_fails_at_first_zero():
    t = first_zero_ordinate()
    # At N = 2 the raw correlation is already negative, so the source's
    # condition initially holds ...
    assert greedy_correlation(0.5, t, 2) < 0
    # ... but it fails at N = 4 for the first critical-line zero.
    found = first_greedy_violation(0.5, t, 500)
    assert found is not None
    n, corr = found
    assert n == 4
    assert corr > 0


def test_alternating_sign_is_not_greedy_at_first_zero():
    t = first_zero_ordinate()
    # The alternating choice at N = 2 is -w_2, but the greedy sign is +1.
    assert alternating_sign(2) == -1
    assert greedy_sign(0.5, t, 2) == 1
    found = first_greedy_violation(0.5, t, 500, signed=True)
    assert found is not None
    assert found[0] == 2
    assert found[1] < 0


def test_off_critical_line_points_also_fail_finite_scan():
    t = first_zero_ordinate()
    for sigma in (0.4, 0.6, 0.7):
        found = first_greedy_violation(sigma, t, 500)
        assert found is not None
        assert found[0] <= 10


def test_greedy_correlation_matches_sympy():
    t_mp = first_zero_ordinate()
    t = sp.Float(mp.nstr(t_mp, 40), 40)
    s = sp.Rational(1, 2) + sp.I * t
    for N in range(2, 9):
        S = sum((-1) ** (n - 1) * sp.Integer(n) ** (-s) for n in range(1, N))
        w = sp.Integer(N) ** (-s)
        exact = sp.re(sp.conjugate(S) * w).evalf(40)
        numeric = greedy_correlation(0.5, t_mp, N, dps=50)
        # Both sides consume the same 40-digit ordinate; agreement to 1e-30
        # absorbs only the independent rounding of the two evaluation paths.
        with mp.workdps(60):
            assert abs(mp.mpf(str(exact)) - numeric) < mp.mpf("1e-30")


def test_greedy_scan_argument_validation():
    with pytest.raises(ValueError):
        first_greedy_violation(0.5, 1.0, N_max=1)
    with pytest.raises(ValueError):
        first_greedy_violation(0.5, 1.0, N_max=10, dps=10)
