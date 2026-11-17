"""Tests for the zero-side bridge probes (C1–C2)."""

import sys
from pathlib import Path

import mpmath as mp
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (SEPARATIONS, ZEROS, gram_entry, pole, prime, table,  # noqa: E402
                       zero_side)

mp.mp.dps = 30


def test_c1_zero_side_matches_the_arithmetic_side():
    """C1: the truncated zero sum reproduces the Gram entry at `3.7·10⁻¹⁸`."""
    for c, zs, ar, diff in table():
        assert abs(diff) < mp.mpf("1e-15"), (float(c), mp.nstr(diff, 5))


def test_c1_is_not_an_artefact_of_a_single_separation():
    """The five separations are not all equal — so a constant kernel would fail."""
    entries = [gram_entry(c) for c in SEPARATIONS]
    assert len(set(mp.nstr(e, 12) for e in entries)) == 5


def test_zero_side_stabilises_as_more_zeros_are_added():
    """Adding zeros beyond the recorded cut changes the sum by less than `10⁻²⁰`."""
    c = mp.mpf(0)
    a = zero_side(c, ZEROS)
    b = zero_side(c, ZEROS + 5)
    assert abs(a - b) < mp.mpf("1e-15")


def test_c2_pole_sum_matches_the_closed_form():
    """C2: `4πσ²e^{σ²/4}cosh(c/2)` is the pole term of `W` to `10⁻²⁰`."""
    sig = mp.mpf(1) / 20
    for c in SEPARATIONS:
        closed = 4 * mp.pi * sig ** 2 * mp.exp(sig ** 2 / 4) * mp.cosh(c / 2)
        assert abs(pole(c) - closed) < mp.mpf("1e-20")


def test_prime_term_is_negligible_below_the_first_prime_power():
    """For `|c| < log 2` no prime power contributes, so `prime(c)` is tiny."""
    assert abs(prime(mp.mpf(0))) < mp.mpf("1e-20")
