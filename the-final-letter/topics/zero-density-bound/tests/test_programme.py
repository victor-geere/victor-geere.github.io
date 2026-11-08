"""Tests for the off-line quadruple and tail-bound computations (C1–C3)."""

import math
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    domination_gap,
    full_block_within,
    gram_weight,
    offline_quad,
    tail_entry_bound,
)


def test_offline_quad_is_even_in_c_and_gamma():
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    for c in (0.0, 0.5, 1.0, 2.0):
        assert math.isclose(offline_quad(c, sigma, delta, gamma),
                            offline_quad(-c, sigma, delta, gamma), rel_tol=0, abs_tol=1e-12)
    assert math.isclose(offline_quad(1.0, sigma, delta, gamma),
                        offline_quad(1.0, sigma, delta, -gamma), rel_tol=0, abs_tol=1e-12)


def test_tail_bound_is_positive_and_decreasing_in_sigma():
    zeros = [14.1347, 21.0220, 25.0109, 30.4249, 32.9351]
    bounds = [tail_entry_bound(s, zeros) for s in (0.02, 0.05, 0.1, 0.2)]
    assert all(b > 0 for b in bounds)
    # the σ² prefactor dominates at first; beyond σ = 0.05 the Gaussian decay wins
    assert bounds[1] > bounds[2] > bounds[3]
    with pytest.raises(ValueError):
        tail_entry_bound(0.0, zeros)


def test_domination_gap_becomes_negative_for_large_separation():
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    B = 0.01
    gaps = [domination_gap(c, sigma, delta, gamma, B) for c in (0.0, 1.0, 2.0, 4.0, 8.0, 12.0)]
    assert gaps[0] == 2 * B
    assert gaps[-1] < 0


def test_full_block_within_checks_all_four_entries():
    s0, sc, B = 1.0, 0.5, 0.1
    assert full_block_within((1.05, 0.55, 0.45, 0.95), s0, sc, B)
    assert not full_block_within((1.2, 0.5, 0.5, 1.0), s0, sc, B)
    with pytest.raises(ValueError):
        full_block_within((1, 1, 1, 1), s0, sc, -0.1)


def test_gram_weight_is_positive():
    assert gram_weight(0.05, 14.1347) > 0
    with pytest.raises(ValueError):
        gram_weight(-1, 1.0)


def test_tail_predicate_agrees_with_full_block_within():
    from programme import tail_entry_bound_holds

    s0, sc, B = 1.0, 0.3, 0.2
    total = (1.1, 0.4, 0.2, 0.85)
    tail = (total[0] - s0, total[1] - sc, total[2] - sc, total[3] - s0)
    assert tail_entry_bound_holds(*tail, B) == full_block_within(total, s0, sc, B)
    assert tail_entry_bound_holds(0.1, -0.2, 0.2, 0.1, B)
    assert not tail_entry_bound_holds(0.3, 0.0, 0.0, 0.0, B)
    with pytest.raises(ValueError):
        tail_entry_bound_holds(0.0, 0.0, 0.0, 0.0, -1.0)


def test_diag_block_eigenvalues_agree_with_scalar_criterion():
    from programme import diag_block_psd_by_eigenvalues, diag_block_psd_criterion

    for a in (-1.0, 0.0, 0.5, 1.0, 2.0):
        for b in (-2.0, -1.0, -0.5, 0.0, 0.5, 1.0, 2.0):
            assert diag_block_psd_by_eigenvalues(a, b) == diag_block_psd_criterion(a, b)
    # explicit cases of the criterion
    assert diag_block_psd_criterion(1.0, 0.9)
    assert not diag_block_psd_criterion(1.0, 1.1)
    assert diag_block_psd_criterion(0.0, 0.0)


def test_gaussian_zero_mass_outside_radius_decreases_to_zero():
    from programme import gaussian_zero_mass_outside

    zeros = [14.1347, 21.0220, 25.0109, 30.4249, 32.9351]
    radii = [0.0, 10.0, 15.0, 22.0, 40.0]
    masses = [gaussian_zero_mass_outside(0.05, zeros, R) for R in radii]
    assert all(m >= 0 for m in masses)
    assert all(a >= b for a, b in zip(masses, masses[1:]))
    assert masses[-1] == 0.0
    with pytest.raises(ValueError):
        gaussian_zero_mass_outside(0.0, zeros, 1.0)
    with pytest.raises(ValueError):
        gaussian_zero_mass_outside(0.05, zeros, -1.0)


def test_online_gram_quadratic_form_nonnegative():
    from programme import online_gram_quadratic_form

    a = [0.0, 0.7, 1.9, 3.1]
    weights = [1.0, 0.5, 0.25]
    gammas = [14.1347, 21.0220, 25.0109]
    xs = [
        [1.0, 0.0, 0.0, 0.0],
        [0.0, 1.0, -1.0, 0.5],
        [-1.0, 2.0, 0.3, -0.7],
        [0.5, 0.5, 0.5, 0.5],
    ]
    for x in xs:
        assert online_gram_quadratic_form(a, weights, gammas, x) >= -1e-12
    with pytest.raises(ValueError):
        online_gram_quadratic_form(a, [1.0, -1.0, 0.0], gammas, xs[0])
    with pytest.raises(ValueError):
        online_gram_quadratic_form(a, weights, gammas, [1.0, 0.0])
