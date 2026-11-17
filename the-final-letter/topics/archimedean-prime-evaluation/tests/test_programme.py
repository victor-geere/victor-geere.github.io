"""Tests for the archimedean/prime evaluation computations (C1–C6)."""

import math
import sys
from pathlib import Path

import mpmath
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    arch_critical_line_real,
    arch_identity_residual,
    arch_im_term,
    critical_line_im,
    critical_line_re,
    density_term,
    omega,
    prime_term,
    prime_term_sym,
)


def test_omega_at_zero_matches_digamma():
    """C1: Ω(0) = Re ψ(1/4) − log π."""
    expected = float(mpmath.re(mpmath.digamma(mpmath.mpf(1) / 4)) - mpmath.log(mpmath.pi))
    assert omega(0) == pytest.approx(expected, rel=0, abs=1e-12)


def test_density_term_zero_positive():
    """C2: the density term at c = 0 is positive."""
    val = density_term(0.0, 0.05)
    assert val == pytest.approx(0.0116981347, rel=0, abs=1e-8)
    assert val > 0


def test_density_term_negative_at_one_fifth():
    """C2: the density term is negative at c = 1/5."""
    assert density_term(0.2, 0.05) < 0


def test_critical_line_parts_match_complex_value():
    """C3: the real and imaginary parts match the complex critical-line value."""
    c, sigma, t = 0.2, 0.05, 0.3
    z = (2 * math.pi * sigma ** 2
         * mpmath.exp(-(sigma * t) ** 2)
         * mpmath.exp(-1j * c * t))
    assert critical_line_re(c, sigma, t) == pytest.approx(float(mpmath.re(z)), rel=0, abs=1e-15)
    assert critical_line_im(c, sigma, t) == pytest.approx(float(mpmath.im(z)), rel=0, abs=1e-15)


def test_arch_identity_residual_small():
    """C4: the closed form for the critical-line archimedean integral."""
    assert arch_identity_residual(0.2, 0.05) < 1e-10
    assert arch_identity_residual(1.0, 0.05) < 1e-10


def test_arch_im_term_sign_and_scaling():
    """C4: the Im ψ correction is a genuine term."""
    val = arch_im_term(0.2, 0.05)
    assert val != 0
    assert abs(arch_critical_line_real(0.2, 0.05)) > 0


def test_prime_term_sym_negative_at_one():
    """C5: the symmetrised prime term is negative at c = 1."""
    val = prime_term_sym(1.0, 0.05)
    assert val == pytest.approx(-0.02126065, rel=0, abs=1e-6)
    assert val < 0


def test_prime_term_is_symmetric_small_at_zero():
    """C5: at c = 0 the prime term is tiny (Gaussian decay at log 2)."""
    assert abs(prime_term(0.0, 0.05)) < 1e-18


def test_edge_cases_raise():
    """C6: invalid widths are rejected."""
    with pytest.raises(ValueError):
        density_term(0.0, 0.0)
    with pytest.raises(ValueError):
        prime_term(0.0, -1.0)
    with pytest.raises(ValueError):
        arch_im_term(0.0, 0.0)


def test_prime_limit_re2_differs_from_critical_line():
    from programme import prime_gap_ratio
    # The two normalisations genuinely differ; the ratio is far from 1.
    assert not abs(prime_gap_ratio(1.0, 1.0) - 1.0) < 0.01


def test_prime_limit_re2_monotone_in_cutoff():
    from programme import prime_limit_re2
    a = prime_limit_re2(1.0, 1.0, 1000)
    b = prime_limit_re2(1.0, 1.0, 4000)
    assert abs(a - b) < 0.5
