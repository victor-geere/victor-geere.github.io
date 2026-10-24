import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from polygon_zero import (  # noqa: E402
    all_certified,
    real_part_interval,
    two_distinct_real_parts,
)


def test_krawczyk_certificates():
    assert all_certified()


def test_certified_zeros_are_off_the_critical_line():
    for centre in [(0.578020715100285, 18.645458136506736),
                   (0.8001391446430497, 26.741599404537162)]:
        lo, hi = real_part_interval(centre)
        assert hi < 0.5 or 0.5 < lo
        assert 0.0 < lo < hi < 1.0


def test_two_certified_zeros_have_distinct_real_parts():
    assert two_distinct_real_parts()
