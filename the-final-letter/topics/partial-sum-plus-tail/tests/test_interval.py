import sys
from fractions import Fraction as F
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

from rativ import Cx, Iv  # noqa: E402


def test_complex_box_arithmetic():
    Z = Cx(Iv(F(1), F(2)), Iv(F(0), F(1)))
    W = Cx(Iv(F(3), F(5)), Iv(F(-1), F(0)))
    S = Z.add(W)
    assert S.re.lo == 4 and S.re.hi == 7
    assert S.im.lo == -1 and S.im.hi == 1
    M = Z.mul(W)
    assert M.re.lo <= M.re.hi and M.im.lo <= M.im.hi


def test_inflate_is_sound():
    A = Iv(F(1), F(2)).inflate(F(1, 10))
    assert A.lo == F(9, 10) and A.hi == F(21, 10)
