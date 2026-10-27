import sys
from fractions import Fraction
from pathlib import Path

import mpmath as mp
from mpmath import iv

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from python.programme import prime_side, tent, tent_autocorr, von_mangoldt


def test_tent_values():
    assert tent(Fraction(0)) == 1
    assert tent(Fraction(1, 2)) == Fraction(1, 2)
    assert tent(Fraction(1)) == 0
    assert tent(Fraction(-3, 4)) == Fraction(1, 4)


def test_autocorr_samples():
    assert tent_autocorr(Fraction(0)) == Fraction(2, 3)
    assert tent_autocorr(Fraction(1, 2)) == Fraction(23, 48)
    assert tent_autocorr(Fraction(1)) == Fraction(1, 6)
    assert tent_autocorr(Fraction(3, 2)) == Fraction(1, 48)
    assert tent_autocorr(Fraction(2)) == 0
    assert tent_autocorr(Fraction(5, 2)) == 0


def test_autocorr_even():
    for x in [Fraction(1, 3), Fraction(4, 3), Fraction(7, 4)]:
        assert tent_autocorr(x) == tent_autocorr(-x)


def test_autocorr_nonnegative_samples():
    for k in range(0, 41):
        x = Fraction(k, 20)
        assert tent_autocorr(x) >= 0


def test_autocorr_strict_positive_inside():
    for k in range(1, 40):
        x = Fraction(k, 20)
        assert tent_autocorr(x) > 0


def test_prime_side_is_a_tight_interval():
    total, terms = prime_side(2)
    assert set(terms) == {2, 3, 4, 5, 7}
    lo, hi = total.a, total.b
    assert lo <= hi
    assert hi - lo < mp.mpf("1e-30")
    # The prime side is negative for this normalization.
    assert hi < 0


def test_prime_side_contains_float_evaluation():
    mp.mp.dps = 80
    iv.dps = 50
    total, _ = prime_side(2)
    approx = mp.mpf(0)
    for n in [2, 3, 4, 5, 7]:
        lam = mp.log(n) if n in (2, 3, 5, 7) else mp.log(2)
        ln = mp.log(n)
        g = (ln**3 / 2 - ln**2 + mp.mpf(2) / 3) if n <= 3 else (
            -ln**3 / 6 + ln**2 - 2 * ln + mp.mpf(4) / 3
        )
        approx += -lam / mp.sqrt(n) * 2 * g
    assert total.a <= approx <= total.b


def test_von_mangoldt():
    assert von_mangoldt(6) is None
    assert von_mangoldt(8) is not None


def test_interval_width_scales():
    total, terms = prime_side(2)
    assert all(t.a <= t.b for t in terms.values())
    assert total.a <= sum(t.a for t in terms.values())
    assert sum(t.b for t in terms.values()) <= total.b


def test_integral_tent_numeric():
    mp.mp.dps = 40
    val = mp.quad(lambda x: max(mp.mpf(0), 1 - abs(x)), [-1, 0, 1])
    assert abs(val - 1) < mp.mpf("1e-25")


def test_integral_tent_sq_numeric():
    mp.mp.dps = 40
    val = mp.quad(lambda x: max(mp.mpf(0), 1 - abs(x)) ** 2, [-1, 0, 1])
    assert abs(val - mp.mpf(2) / 3) < mp.mpf("1e-25")


def _g_mp(x):
    ax = abs(x)
    if ax <= 1:
        return ax ** 3 / 2 - ax ** 2 + mp.mpf(2) / 3
    if ax <= 2:
        return -ax ** 3 / 6 + ax ** 2 - 2 * ax + mp.mpf(4) / 3
    return mp.mpf(0)


def test_autocorr_matches_convolution_numeric():
    mp.mp.dps = 40
    for x in [mp.mpf(0), mp.mpf("0.5"), mp.mpf(1), mp.mpf("1.5")]:
        pts = [-1, 0, 1] if x <= 0 or x >= 1 else [-1, 0, float(x), 1]
        val = mp.quad(
            lambda t: max(mp.mpf(0), 1 - abs(t)) * max(mp.mpf(0), 1 - abs(t - x)),
            [mp.mpf(p) for p in pts],
        )
        assert abs(val - _g_mp(x)) < mp.mpf("1e-5")


def test_integral_autocorr_numeric():
    mp.mp.dps = 40
    val = mp.quad(_g_mp, [-2, -1, 0, 1, 2])
    assert abs(val - 1) < mp.mpf("1e-5")


def test_convolution_identity_grid():
    mp.mp.dps = 40
    for k in range(-9, 10):
        x = mp.mpf(k) / 10
        pts = [-1, min(0, float(x)), max(0, float(x)), 1]
        pts = sorted(set(pts))
        val = mp.quad(
            lambda t: max(mp.mpf(0), 1 - abs(t)) * max(mp.mpf(0), 1 - abs(t - x)),
            [mp.mpf(p) for p in pts],
        )
        assert abs(val - _g_mp(x)) < mp.mpf("1e-5")
