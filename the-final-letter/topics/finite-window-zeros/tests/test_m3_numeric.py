"""Numerical census for the M3-finite window."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from python.m3_numeric import zero_count_T, zeta_winding  # noqa: E402


def test_T1_strip_is_zero_free_numerically() -> None:
    """C15: the T=1 contour strip has no ζ-zeros numerically (winding −1 = pole)."""
    assert zeta_winding(-1.0, 2.0, -1.0, 1.0, 2000) == -1
    assert zero_count_T(1.0, 2000) == 0


def test_tent_arch_prime_values_T1() -> None:
    """C16/C17: numerical reference values for tentArch 1 and tentPrime 1."""
    from python.m3_numeric import tent_arch_numeric, tent_prime_numeric

    a = complex(tent_arch_numeric(1.0))
    p = complex(tent_prime_numeric(1.0))
    assert abs(a - 0.776099545775) < 1e-6
    assert abs(p - 0.337387954055) < 1e-6
    assert abs(a.imag) < 1e-9 and abs(p.imag) < 1e-9
