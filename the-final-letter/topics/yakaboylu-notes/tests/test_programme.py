import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    amplitude_sum,
    cosine_sum,
    eta_real_part,
    eta_truncation_at_one,
    euler_product,
    max_abs_cosine,
    sigma_threshold,
    sigma_zero,
    weight,
    weight_closed,
)


def test_amplitude_sum_exact_identity():
    # C1: S_N(0) = N - 1 and S_5(2) is the exact harmonic tail.
    assert amplitude_sum(2, 0) == 1
    assert amplitude_sum(7, 0) == 6
    assert amplitude_sum(5, 2) == sp.Rational(1, 4) + sp.Rational(1, 9) + sp.Rational(1, 16) + sp.Rational(1, 25)
    # S_N is strictly decreasing in σ, as proved in Lean.
    assert amplitude_sum(10, 1) > amplitude_sum(10, 2) > amplitude_sum(10, 3)


def test_amplitude_bound_numeric():
    # C2: |R_N(σ,t)| ≤ S_N(σ) on a t-grid (Lean: Yakaboylu.abs_R_le_S).
    for N in (2, 5, 20):
        for sigma in (sp.Rational(1, 2), sp.Integer(1), sp.Rational(3, 2)):
            bound = float(sp.N(amplitude_sum(N, sigma), 30))
            grid_max = max_abs_cosine(N, sigma, t_max=25.0, samples=250)
            assert grid_max <= bound + 1e-12


def test_no_real_zero_below_threshold():
    # C3: if S_N(σ) < 1 then R_N ≠ 1, so U_N = 1 - R_N > 0.
    N, sigma = 40, 3
    assert float(sp.N(amplitude_sum(N, sigma), 30)) < 1
    assert max_abs_cosine(N, sigma, t_max=30.0, samples=300) < 1
    for t in (sp.Rational(1, 3), sp.Rational(7, 2), sp.Rational(11, 1)):
        value = complex(sp.N(eta_real_part(N, sigma, t), 30))
        assert value.real > 0


def test_thresholds_increase_to_sigma_zero():
    # C4: σ_N is increasing and bounded above by σ_0, with ζ(σ_0)=2.
    s0 = sigma_zero()
    values = [sigma_threshold(N) for N in (2, 3, 4, 5, 10, 20, 50, 100, 200)]
    assert values[0] == 0
    assert all(values[i] < values[i + 1] for i in range(len(values) - 1))
    assert all(v < s0 for v in values)
    assert abs(s0 - values[-1]) < 0.02


def test_sigma_zero_is_zeta_two_root():
    # C5: the source value σ_0 ≈ 1.72865 satisfies ζ(σ_0) = 2.
    s0 = sigma_zero()
    assert abs(s0 - mp.mpf("1.7286472389981835")) < mp.mpf("1e-12")
    assert abs(mp.zeta(s0) - 2) < mp.mpf("1e-25")


def test_euler_product_approaches_zeta_at_sigma_zero():
    # C6: the prime product at σ_0 approaches 2 (source §6).
    s0 = sigma_zero()
    product = euler_product(s0, prime_bound=2000)
    assert abs(product - 2) < 1e-2
    # At σ = 2 the same product approaches the exact ζ(2) = π²/6.
    product2 = euler_product(2, prime_bound=2000)
    assert abs(product2 - float(sp.pi**2 / 6)) < 1e-3


def test_weight_identity_and_symmetry_exact():
    # C7: ω(t) = t e^t/(1+e^t)² = t/(4 cosh²(t/2)) and ω(-t) = -ω(t).
    t = sp.symbols("t", real=True)
    assert sp.simplify(weight(t) - weight_closed(t).rewrite(sp.exp)) == 0
    assert sp.simplify((weight(-t) + weight(t)).rewrite(sp.exp)) == 0
    assert sp.simplify(weight(t).subs(t, 0)) == 0


def test_edge_cases():
    # C8: edge cases of the truncation and the smallest threshold.
    with pytest.raises(ValueError):
        amplitude_sum(1, 2)
    with pytest.raises(ValueError):
        cosine_sum(1, 2, 0)
    with pytest.raises(ValueError):
        sigma_threshold(1)
    # N = 2 is the exact boundary case: 2^(-σ) = 1 at σ = 0.
    assert sigma_threshold(2) == 0
    # η_N(1) is the alternating harmonic number.
    assert eta_truncation_at_one(1) == 1
    assert eta_truncation_at_one(2) == sp.Rational(1, 2)
    assert eta_truncation_at_one(10) == sp.Rational(1627, 2520)
    # At σ = 0 and t = 0, R_N is an alternating sum, not the full sum.
    assert cosine_sum(4, 0, 0) == 1
