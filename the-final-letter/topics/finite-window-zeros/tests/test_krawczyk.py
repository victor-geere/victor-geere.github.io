import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from python.accelerated import krawczyk_box


def test_krawczyk_first_zero():
    K, X, ok = krawczyk_box(0.499, 0.501, 14.1345, 14.1349)
    assert ok
    assert K.real.a > X.real.a
    assert K.real.b < X.real.b
    assert K.imag.a > X.imag.a
    assert K.imag.b < X.imag.b


def test_krawczyk_robust_in_parameters():
    for N, K in ((20, 20), (25, 25), (30, 20), (20, 25)):
        _, _, ok = krawczyk_box(0.499, 0.501, 14.1345, 14.1349, N, K)
        assert ok
