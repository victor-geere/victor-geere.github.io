import sys
from pathlib import Path

import mpmath as mp

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from python.accelerated import zeta_em_iv


def test_em_box_contains_zeta_point():
    mp.mp.dps = 50
    z = zeta_em_iv(0.5, 0.5, 14.0, 14.0)
    true = mp.zeta(mp.mpc(mp.mpf(1) / 2, 14))
    assert float(z.real.a) - 1e-14 <= float(mp.re(true)) <= float(z.real.b) + 1e-14
    assert float(z.imag.a) - 1e-14 <= float(mp.im(true)) <= float(z.imag.b) + 1e-14


def test_em_box_is_tight():
    z = zeta_em_iv(0.5, 0.5, 14.0, 14.0)
    assert float(z.real.b - z.real.a) < mp.mpf("1e-14")
    assert float(z.imag.b - z.imag.a) < mp.mpf("1e-14")


def test_em_box_rectangle_contains_corners():
    mp.mp.dps = 50
    z = zeta_em_iv(0.4, 0.6, 14.0, 14.3)
    for re in (0.4, 0.6):
        for im in (14.0, 14.3):
            true = mp.zeta(mp.mpc(re, im))
            assert float(z.real.a) - 1e-14 <= float(mp.re(true)) <= float(z.real.b) + 1e-14
            assert float(z.imag.a) - 1e-14 <= float(mp.im(true)) <= float(z.imag.b) + 1e-14


def test_em_multiple_heights():
    mp.mp.dps = 50
    for im in (14, 20, 30):
        z = zeta_em_iv(0.5, 0.5, im, im)
        true = mp.zeta(mp.mpc(mp.mpf(1) / 2, im))
        assert float(z.real.a) - 1e-12 <= float(mp.re(true)) <= float(z.real.b) + 1e-12
        assert float(z.imag.a) - 1e-12 <= float(mp.im(true)) <= float(z.imag.b) + 1e-12
        assert float(z.real.b - z.real.a) < mp.mpf("1e-12")


def test_cauchy_deriv_bound():
    from python.accelerated import zeta_deriv_bound
    D, M = zeta_deriv_bound(0.4, 0.6, 14.0, 14.3, pad=0.05)
    assert D > 0 and M > 0
    assert D < 100
