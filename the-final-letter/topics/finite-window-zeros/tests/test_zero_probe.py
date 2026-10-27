import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from python.zero_probe import winding

def test_winding_first_zero():
    w, m = winding()
    assert abs(w - 1) < 1e-6
    assert m > 0.1


def test_first_zero_ordinate():
    from python.zero_probe import first_zero_ordinate
    import mpmath as mp
    t = first_zero_ordinate()
    assert abs(t - mp.mpf("14.134725141734693790457251983562470270784257115699")) < mp.mpf("1e-20")
