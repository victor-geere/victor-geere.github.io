import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    corr,
    corr_slice,
    liouville,
    liouville_slice,
    omega,
    prefix_agreement,
    shift_prod,
    slice_l2_mass,
    slice_perturbation,
)


def test_liouville_is_a_sign_and_multiplicative():
    for n in range(0, 200):
        assert liouville(n) in (1, -1)
        assert liouville(n) ** 2 == 1
    # Ω(4) = 2, Ω(6) = 2, Ω(30) = 3, Ω(25) = 2.
    assert (omega(4), omega(6), omega(30), omega(25)) == (2, 2, 3, 2)
    assert (liouville(4), liouville(6), liouville(30), liouville(25)) == (1, 1, -1, 1)
    for m in range(1, 21):
        for n in range(1, 21):
            assert liouville(m * n) == liouville(m) * liouville(n)


def test_trivial_bound_and_sharpness():
    for h in range(0, 6):
        for N in range(0, 61):
            assert abs(corr(h, N)) <= N
            assert corr(0, N) == N
    assert corr(0, 0) == 0


def test_prefix_agreement_of_the_slice():
    # N + h < a: the prefix cannot see the value flip at index a.
    for h in range(1, 5):
        for a in range(6, 21):
            for N in range(0, a - h):
                assert prefix_agreement(h, a, N)
                assert corr_slice(h, a, N) == corr(h, N)
    # The explicit finite-prefix witness: agree below 5, differ at 5.
    assert corr_slice(2, 5, 2) == corr(2, 2)
    assert corr_slice(2, 5, 5) != corr(2, 5)


def test_slice_perturbation_closed_form():
    for h in range(1, 5):
        for a in range(h + 1, 16):
            assert corr_slice(h, a, a) - corr(h, a) == slice_perturbation(h, a)
    # λ(5)λ(7) = 1 and λ(3)λ(5) = 1, so the witness perturbation is −4.
    assert slice_perturbation(2, 5) == -4
    assert corr_slice(2, 5, 5) - corr(2, 5) == -4


def test_slice_l2_mass_is_exactly_four():
    for a in range(1, 21):
        for N in range(a, a + 11):
            assert slice_l2_mass(a, N) == 4
    # Edge case: the sum starts at n = 1, so a flip at index 0 has mass 0.
    assert slice_l2_mass(0, 10) == 0


def test_shifted_product_is_not_completely_multiplicative():
    assert shift_prod(2, 25) == -1
    assert shift_prod(2, 5) ** 2 == 1
    assert shift_prod(2, 5 * 5) != shift_prod(2, 5) * shift_prod(2, 5)


def test_edge_and_invalid_inputs():
    assert liouville(0) == 1
    assert liouville_slice(0, 0) == -1
    assert liouville_slice(0, 1) == liouville(1)
    with pytest.raises(ValueError):
        omega(-1)
    with pytest.raises(ValueError):
        corr(-1, 10)
    with pytest.raises(ValueError):
        corr(2, -1)
    with pytest.raises(ValueError):
        slice_perturbation(0, 5)  # the closed form needs h > 0
    with pytest.raises(ValueError):
        slice_perturbation(5, 5)  # and h < a
    with pytest.raises(ValueError):
        prefix_agreement(2, 5, 4)  # N + h < a fails
