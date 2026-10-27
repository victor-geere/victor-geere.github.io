import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    alpha,
    centred,
    destructive_height,
    greedy_digits,
    greedy_intervals,
    interference_modulus,
    is_positive_semidefinite,
    kernel,
    kernel_matrix,
    kernel_scaled,
    phase,
    weighted,
)


def test_alpha_and_support_edge_cases():
    assert sp.simplify(alpha(0) - PI / 2) == 0
    assert sp.simplify(alpha(3) - PI / 5) == 0
    with pytest.raises(ValueError):
        alpha(-1)
    with pytest.raises(ValueError):
        greedy_intervals(-1)

    # Section 3 of the source, rescaled by π: supports are fragmented.
    expected = [
        [(sp.Rational(1, 2), sp.Integer(1))],
        [(sp.Rational(1, 3), sp.Rational(1, 2)), (sp.Rational(5, 6), sp.Integer(1))],
        [(sp.Rational(1, 4), sp.Rational(1, 3)), (sp.Rational(3, 4), sp.Rational(5, 6))],
    ]
    supports = greedy_intervals(2)
    for n, want in enumerate(expected):
        got = [
            (sp.simplify(a / PI), sp.simplify(b / PI)) for a, b in supports[n]
        ]
        assert got == want


def test_centred_function_and_greedy_digits():
    # φ_0(θ) = 1 - θ/π on [π/2, π] and -θ/π below π/2.
    assert sp.simplify(centred(0, sp.Rational(3, 4) * PI) - sp.Rational(1, 4)) == 0
    assert sp.simplify(centred(0, sp.Rational(1, 4) * PI) + sp.Rational(1, 4)) == 0
    assert greedy_digits(sp.Rational(1, 2) * PI, 2) == [1, 0, 0]
    # Edge: θ = π does not select every level — after α_0 + α_1 = 5π/6 the
    # residual π/6 is below α_2 = π/4 and α_3 = π/5, but equals α_4 = π/6.
    assert greedy_digits(PI, 4) == [1, 1, 0, 0, 1]
    assert greedy_digits(sp.Integer(0), 4) == [0, 0, 0, 0, 0]


def test_source_kernel_values_exact():
    # Section 4 of the source, verified against the true recursive supports.
    wanted = {
        (0, 0): sp.Rational(1, 12),
        (1, 1): sp.Rational(2, 9),
        (0, 1): sp.Rational(-7, 72),
        (2, 2): sp.Rational(23, 72),
        (1, 2): sp.Rational(1, 48),
    }
    for (n, m), value in wanted.items():
        assert sp.simplify(kernel_scaled(n, m) - value) == 0
        # Symmetry of the correlation kernel.
        assert sp.simplify(kernel(n, m) - kernel(m, n)) == 0


def test_kernel_matrix_symmetric_and_psd():
    matrix = kernel_matrix(3)
    assert sp.simplify(matrix - matrix.T) == sp.zeros(4, 4)
    assert is_positive_semidefinite(matrix)
    # The quadratic form is a Gram form, hence non-negative exactly.
    c = sp.Matrix([1, -2, 3, -1])
    form = sp.simplify((c.T * matrix * c)[0])
    assert form.is_nonnegative is True
    with pytest.raises(ValueError):
        is_positive_semidefinite(sp.Matrix([[1, 2]]))
    # Leading principal minors are not enough for semidefiniteness.
    assert is_positive_semidefinite(sp.Matrix([[0, 0], [0, -1]])) is False


def test_phase_unit_modulus_and_trivial_phase():
    t = sp.symbols("t", real=True)
    for n in (0, 1, 5):
        assert sp.simplify(phase(n, 0) - 1) == 0
        assert sp.simplify(phase(n, t) * sp.conjugate(phase(n, t)) - 1) == 0
    with pytest.raises(ValueError):
        phase(-2, 0)


def test_weighted_complex_symmetry_and_time_reversal():
    t = sp.symbols("t", real=True)
    K = sp.Rational(-7, 72)
    # Symmetric kernel, both phases the same sign: the entry is complex symmetric.
    assert sp.simplify(weighted(K, 0, 1, t) - weighted(K, 1, 0, t)) == 0
    # Time reversal conjugates the entry.
    assert sp.simplify(sp.conjugate(weighted(K, 0, 1, t)) - weighted(K, 0, 1, -t)) == 0


def test_destructive_and_constructive_interference():
    # At t = π/log(3/2) the phases w_0 and w_1 are opposite: exact cancellation.
    t0 = destructive_height(0, 1)
    # Exact exponent identity: log 3 − log 2 = log(3/2), hence
    # exp(−i t0 log(3/2)) = exp(−iπ) = −1.
    L = sp.log(sp.Rational(3, 2))
    assert sp.simplify(sp.logcombine(sp.log(3) - sp.log(2), force=True) - L) == 0
    assert sp.simplify(sp.exp(-sp.I * t0 * L)) == -1
    # Numerical corroboration on the actual phase sum at 30 digits, tol 1e-25.
    amplitude = sp.N(interference_modulus(0, 1, t0), 30)
    assert abs(complex(amplitude)) < sp.Float("1e-25")
    # At t = 0 the phases align: constructive interference with amplitude 2.
    assert sp.simplify(interference_modulus(0, 1, 0) - 2) == 0
    # The general triangle bound never exceeds 2.
    for t in (sp.Rational(1, 3), sp.Integer(1), sp.Rational(17, 5)):
        assert abs(complex(sp.N(interference_modulus(0, 1, t), 30))) <= 2
    with pytest.raises(ValueError):
        destructive_height(2, 2)
