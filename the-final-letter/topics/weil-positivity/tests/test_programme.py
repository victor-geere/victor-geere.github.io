"""Tests for the 2x2 Weil-block computations (C1–C3)."""

import math
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    eigenvalues_2x2,
    find_obstruction,
    is_psd_2x2,
    offline_block,
    offline_quad,
)


def test_online_block_is_psd():
    sigma, gamma = 0.05, 14.1347
    block = offline_block(1.0, sigma, 0.0, gamma)
    assert is_psd_2x2(block)
    lo, hi = eigenvalues_2x2(block)
    assert lo >= -1e-12 and hi >= lo


def test_offline_block_eventually_fails_psd():
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    cs = [0.0, 1.0, 2.0, 4.0, 8.0, 12.0, 16.0]
    hit = find_obstruction(sigma, delta, gamma, cs)
    assert hit is not None
    block = offline_block(hit, sigma, delta, gamma)
    assert not is_psd_2x2(block)
    lo, _ = eigenvalues_2x2(block)
    assert lo < 0


def test_offline_quad_is_even_and_block_is_symmetric():
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    assert math.isclose(offline_quad(2.0, sigma, delta, gamma),
                        offline_quad(-2.0, sigma, delta, gamma), abs_tol=1e-12)
    block = offline_block(2.0, sigma, delta, gamma)
    assert block[0][1] == block[1][0]
    with pytest.raises(ValueError):
        offline_quad(0.0, 1.0, 0.0, 0.0)
        offline_quad(0.0, 0.0, 0.0, 0.0)


def test_scalar_criterion_matches_block_psd():
    from programme import block_psd_criterion, obstruction_margin

    for delta in (0.0, 0.05, 0.1):
        for c in (0.0, 0.5, 1.0, 2.0, 4.0, 8.0, 12.0, 16.0):
            assert block_psd_criterion(c, 0.05, delta, 14.1347)
    # on the critical line (delta = 0) the margin is nonnegative at every separation
    assert all(obstruction_margin(c, 0.05, 0.0, 14.1347) >= -1e-12 for c in (0.0, 2.0, 8.0))
    assert find_obstruction(0.05, 0.0, 14.1347, [0.0, 2.0, 8.0]) is None
    # an obstruction is exactly a negative margin
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    hit = find_obstruction(sigma, delta, gamma, [0.0, 2.0, 4.0, 8.0, 16.0])
    assert hit is not None
    assert obstruction_margin(hit, sigma, delta, gamma) < 0


def test_perturbed_block_psd_fails_past_the_tail_margin():
    from programme import perturbed_block_psd

    # a + 4B < |b| is the T19 margin; the worst-case block then fails PSD.
    assert not perturbed_block_psd(1.0, 2.0, 0.2)
    assert perturbed_block_psd(2.0, 1.0, 0.1)
    with pytest.raises(ValueError):
        perturbed_block_psd(1.0, 2.0, -0.1)
