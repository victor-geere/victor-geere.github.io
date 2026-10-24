import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    alpha,
    alpha_scaled,
    fusion_step,
    greedy_accumulated,
    greedy_word,
    harmonic_sum,
    harmonic_sum_scaled,
    reconstruct_sine,
    residual,
    residual_bound,
    source_residual_bound,
    subsum,
)


def test_alpha_values_and_edge():
    assert sp.simplify(alpha(0) - PI / 2) == 0
    assert sp.simplify(alpha(3) - PI / 5) == 0
    assert alpha_scaled(0) == sp.Rational(1, 2)
    assert alpha_scaled(10) == sp.Rational(1, 12)
    with pytest.raises(ValueError):
        alpha(-1)
    with pytest.raises(ValueError):
        alpha_scaled(-1)
    # Targets outside θ ∈ [0, π] are rejected rather than silently wrapped.
    with pytest.raises(ValueError):
        greedy_word(sp.Rational(5, 4), 3)
    with pytest.raises(ValueError):
        greedy_word(sp.Rational(-1, 4), 3)


def test_harmonic_sum_identity_exact():
    # Definition 2.1: ∑_{n=0}^{N} α_n = π (H_{N+2} - 1).
    for N in range(0, 61):
        exact = harmonic_sum_scaled(N)
        assert exact == sp.harmonic(N + 2) - 1
        assert sp.simplify(harmonic_sum(N) - PI * exact) == 0


def test_residual_bound_correct_form():
    # Correct finite bound: 0 ≤ r_N/π ≤ 1/(N+1), checked on a rational grid.
    for N in (1, 2, 5, 20, 100, 300):
        for k in range(0, 98):
            assert residual_bound(sp.Rational(k, 97), N)
    # Edge case θ = π: the reconstruction terminates exactly.
    assert residual(1, 0) == 1
    assert residual(1, 47) == 0
    # The source's stated bound π/(N+2) is one index too strong.
    assert residual(sp.Rational(2, 5), 1) == sp.Rational(2, 5)
    assert not source_residual_bound(sp.Rational(2, 5), 1)


def test_own_angle_selected():
    # At θ = α_n every earlier index is skipped and index n is selected.
    for n in range(0, 13):
        x = alpha_scaled(n)
        word = greedy_word(x, n)
        assert word[n] == 1
        assert sum(word[:n]) == 0
        # Exactly θ = α_n has been accumulated by the time index n is reached.
        assert greedy_accumulated(x, n) == x


def test_fusion_preserves_unit_circle():
    theta, a = sp.symbols("theta a", real=True)
    s, c = sp.sin(theta), sp.cos(theta)
    s1, c1 = fusion_step(s, c, a)
    assert sp.simplify(s1**2 + c1**2 - 1) == 0
    assert sp.simplify(s1 - sp.sin(theta + a)) == 0
    assert sp.simplify(c1 - sp.cos(theta + a)) == 0
    # A zero rotation is the identity.
    assert sp.simplify(fusion_step(s, c, 0)[0] - s) == 0
    assert sp.simplify(fusion_step(s, c, 0)[1] - c) == 0


def test_reconstruction_convergence():
    # Greedy-word reconstruction of sin(π x); stated tolerance 1e-12.
    for x in (sp.Rational(0), sp.Rational(1, 7), sp.Rational(1, 2),
              sp.Rational(9, 10), sp.Rational(1)):
        approx = reconstruct_sine(x, 300, dps=50)
        target = mp.sin(mp.pi * mp.mpf(x.p) / mp.mpf(x.q))
        assert abs(approx - target) <= float(PI / 301) + 1e-12


def test_pi_target_sparse_erratum():
    # Proposition 4.4 claims θ = π selects every index. It does not:
    # the finite word is 1,1,0,0,1,0,… and terminates with residual 0.
    word = greedy_word(1, 47)
    selected = [n for n, d in enumerate(word) if d]
    assert selected == [0, 1, 4]
    assert greedy_accumulated(1, 47) == 1
    # Hence Φ(s, π) is the sparse sum 2^{-s} + 3^{-s} + 6^{-s},
    # not ζ(s) - 1. At s = 2 it equals 7/18.
    phi2 = subsum(1, 2, 47)
    assert phi2 == sp.Rational(7, 18)
    assert sp.simplify(phi2 - (sp.zeta(2) - 1)) != 0
    # Erratum 3: x = 5/6 = 1/2 + 1/3 also terminates, so the selection
    # count stays 2 and cannot be x log(N+2) + O(1).
    word_56 = greedy_word(sp.Rational(5, 6), 200)
    assert [n for n, d in enumerate(word_56) if d] == [0, 1]
    assert sum(word_56) == 2


def test_accumulated_never_overshoots():
    for k in range(0, 41):
        x = sp.Rational(k, 40)
        for n_max in (0, 1, 7, 50, 400):
            acc = greedy_accumulated(x, n_max)
            assert 0 <= acc <= x
