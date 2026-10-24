import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    CNOT,
    H,
    S,
    T,
    X,
    Y,
    Z,
    bell_state,
    dagger,
    gate,
    gate_sequence,
    is_normalised,
    is_product_state,
    is_unitary,
    kron,
    matrix_equal,
    measurement_probabilities,
    norm_squared,
    product_obstruction,
    product_state,
)


def test_hadamard_is_involution_and_self_adjoint():
    eye = sp.eye(2)
    assert matrix_equal(H * H, eye)
    assert matrix_equal(dagger(H), H)
    assert is_unitary(H)


def test_pauli_involutions_and_hadamard_conjugation():
    eye = sp.eye(2)
    assert matrix_equal(X * X, eye)
    assert matrix_equal(Y * Y, eye)
    assert matrix_equal(Z * Z, eye)
    assert matrix_equal(H * X * H, Z)
    assert matrix_equal(H * Y * H, -Y)
    assert matrix_equal(H * Z * H, X)


def test_cnot_is_involution_and_unitary():
    eye4 = sp.eye(4)
    assert matrix_equal(CNOT * CNOT, eye4)
    assert matrix_equal(dagger(CNOT), CNOT)
    assert is_unitary(CNOT)


def test_phase_gates_have_the_expected_orders():
    assert matrix_equal(S * S, Z)
    assert matrix_equal(T ** 2, S)
    assert matrix_equal(T ** 4, Z)
    assert matrix_equal(T ** 8, sp.eye(2))
    assert is_unitary(T)
    # Composition is exact and order-sensitive: S then S is Z.
    assert matrix_equal(gate_sequence(["S", "S"]), Z)
    assert matrix_equal(gate_sequence(["H", "X", "H"]), Z)


def test_bell_states_are_normalised_with_half_probabilities():
    for index in ("00", "01", "10", "11"):
        psi = bell_state(index)
        assert is_normalised(psi)
        assert sp.simplify(norm_squared(psi) - 1) == 0
        probs = measurement_probabilities(psi)
        assert sorted(sp.simplify(p) for p in probs) == [0, 0, sp.Rational(1, 2), sp.Rational(1, 2)]
    assert matrix_equal(
        bell_state("00"),
        sp.Matrix([1 / sp.sqrt(2), 0, 0, 1 / sp.sqrt(2)]),
    )


def test_product_obstruction_separates_bell_states_from_products():
    for index in ("00", "01", "10", "11"):
        obstruction = product_obstruction(bell_state(index))
        assert sp.simplify(obstruction) != 0
        assert not is_product_state(bell_state(index))
    # A genuine product state has zero obstruction, including the edge
    # case where one factor is the zero vector.
    for a, b in (
        ([1, 0], [0, 1]),
        ([1 / sp.sqrt(2), 1 / sp.sqrt(2)], [1 / sp.sqrt(2), -1 / sp.sqrt(2)]),
        ([1, 1], [0, 0]),
    ):
        psi = product_state(a, b)
        assert sp.simplify(product_obstruction(psi)) == 0
        assert is_product_state(psi)


def test_invalid_inputs_raise_value_error():
    with pytest.raises(ValueError):
        bell_state("02")
    with pytest.raises(ValueError):
        gate("Q")
    with pytest.raises(ValueError):
        is_unitary(sp.Matrix([[1, 0, 0], [0, 1, 0]]))
    with pytest.raises(ValueError):
        product_obstruction(sp.Matrix([1, 0, 0]))
    with pytest.raises(ValueError):
        product_state([1, 0, 0], [1, 0])
