import json
import os
import sys
import tempfile
from fractions import Fraction as F
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import programme as P  # noqa: E402
from rativ import Cx, Iv, log_point, pi_iv, q, sin_cos_iv  # noqa: E402


def test_interval_arithmetic_is_exact():
    A = Iv(F(1), F(2))
    B = Iv(F(3), F(5))
    assert A.add(B).lo == 4 and A.add(B).hi == 7
    assert A.neg().lo == -2 and A.neg().hi == -1
    assert A.mul(B).lo == 3 and A.mul(B).hi == 10
    assert A.sub(B).lo == -4 and A.sub(B).hi == -1
    assert A.scale(F(-2)).lo == -4 and A.scale(F(-2)).hi == -2


def test_pi_bounds():
    I = pi_iv(64)
    assert I.contains(q("3.14159265358979323846264338327"))


def test_log_and_exp_bounds():
    assert log_point(2, 64).contains(q("0.69314718055994530941"))
    assert P.exp_iv(Iv.pt(1), 64).contains(q("2.71828182845904523536"))


def test_sin_cos_bounds():
    s, c = sin_cos_iv(Iv.pt(q("0.3")), 64)
    assert c.contains(q("0.9553364891256060196419"))
    assert s.contains(q("0.295520206661339575105314"))


def test_bernoulli_numbers():
    assert P.bernoulli(2) == F(1, 6)
    assert P.bernoulli(4) == F(-1, 30)
    assert P.bernoulli(6) == F(1, 42)


def test_tail_radius_positive_and_decreasing():
    s_re, s_im = Iv.pt(F(2)), Iv.pt(F(0))
    r4 = P.tail_radius(s_re, s_im, F(1), 8, 4, 64)
    r8 = P.tail_radius(s_re, s_im, F(1), 8, 8, 64)
    assert r4 > 0 and r8 > 0 and r8 < r4


def test_zeta2_enclosure_contains_pi_squared_over_six():
    box = P.zeta_enclosure(2, 2, 0, 0, M=20, K=8, bits=64)
    assert box.contains_pt(q("1.6449340668482264364724151666460251892"), 0)


def test_L2_chi4_enclosure_contains_catalan():
    box = P.L_enclosure([0, 1, 0, -1], 2, 2, 0, 0, M=20, K=8, bits=64)
    assert box.contains_pt(q("0.9159655941772190150546035149323841107"), 0)


def test_eta_enclosure_at_first_zero_contains_zero():
    t = "14.134725141734693790457251983562470270784257115699"
    box = P.eta_enclosure("1/2", "1/2", t, t, M=20, K=8, bits=64)
    assert box.re.contains(q(0)) and box.im.contains(q(0))


def test_eta_cos_sin_enclosure_widths_are_finite():
    c, s = P.eta_cos_sin_enclosure("1/2", "1/2", "14.1", "14.1", M=10, bits=64)
    assert c.lo <= c.hi and s.lo <= s.hi
    assert c.width >= 0 and s.width >= 0


def test_certificate_roundtrip():
    cert = P.certificate_for("zeta", 2, 2, 0, 0, M=8, K=4, bits=64)
    assert cert["function"] == "zeta"
    assert cert["atoms"] and cert["ops"]
    fd, path = tempfile.mkstemp(suffix=".json")
    os.close(fd)
    try:
        with open(path, "w") as fh:
            json.dump(cert, fh)
        assert P.verify_certificate_file(path)
    finally:
        os.unlink(path)


def test_invalid_domain_is_rejected():
    with pytest.raises(ValueError):
        P.tail_radius(Iv.pt(F(0)), Iv.pt(F(0)), F(1), 8, 4, 64)
    with pytest.raises(ValueError):
        P.L_enclosure([1, 0], 2, 2, 0, 0)
