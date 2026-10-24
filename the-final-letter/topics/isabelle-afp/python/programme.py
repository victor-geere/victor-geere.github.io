"""Isabelle/AFP corpus — exact computation layer.

The archived corpus is the AFP entry ``Isabelle_Marries_Dirac``, a
formalisation of quantum information in Isabelle/HOL.  This module is a
small, independent sympy model of the finite gate algebra in
``Quantum.thy``: the Pauli matrices, the Hadamard and CNOT gates, the
phase gates, and the four Bell states.

Everything is exact.  Hadamard entries are kept as ``1/sqrt(2)`` and the
phase gate uses ``exp(I*pi/4)``; sympy simplifies the resulting
trigonometric and quadratic surd expressions rather than evaluating them
in floating point.  No claim in the archived corpus (in particular no
Riemann-hypothesis claim) is asserted or discharged here.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

I = sp.I

X: sp.Matrix = sp.Matrix([[0, 1], [1, 0]])
Y: sp.Matrix = sp.Matrix([[0, -I], [I, 0]])
Z: sp.Matrix = sp.Matrix([[1, 0], [0, -1]])
H: sp.Matrix = sp.Matrix(
    [
        [1 / sp.sqrt(2), 1 / sp.sqrt(2)],
        [1 / sp.sqrt(2), -1 / sp.sqrt(2)],
    ]
)
CNOT: sp.Matrix = sp.Matrix(
    [
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1],
        [0, 0, 1, 0],
    ]
)
S: sp.Matrix = sp.diag(1, I)
T: sp.Matrix = sp.diag(1, sp.exp(I * sp.pi / 4))

GATES: dict[str, sp.Matrix] = {
    "X": X,
    "Y": Y,
    "Z": Z,
    "H": H,
    "CNOT": CNOT,
    "S": S,
    "T": T,
}

BELL_INDICES = ("00", "01", "10", "11")


def gate(name: str) -> sp.Matrix:
    """Return a named gate matrix.

    Raises ``ValueError`` for an unknown gate name rather than silently
    returning a default.
    """
    key = name.upper()
    if key not in GATES:
        raise ValueError(f"unknown gate {name!r}; expected one of {sorted(GATES)}")
    return GATES[key].copy()


def dagger(matrix: sp.Matrix) -> sp.Matrix:
    """Conjugate transpose of a square or rectangular matrix."""
    M = sp.Matrix(matrix)
    return M.H


def _zero(matrix: sp.Matrix) -> bool:
    """True when every entry of ``matrix`` simplifies to zero."""
    M = sp.Matrix(matrix)
    return all(sp.simplify(entry) == 0 for entry in M)


def matrix_equal(left: sp.Matrix, right: sp.Matrix) -> bool:
    """Exact equality of two matrices after sympy simplification."""
    A = sp.Matrix(left)
    B = sp.Matrix(right)
    if A.shape != B.shape:
        return False
    return _zero(A - B)


def is_square(matrix: sp.Matrix) -> bool:
    M = sp.Matrix(matrix)
    return M.rows == M.cols


def is_unitary(matrix: sp.Matrix) -> bool:
    """Exact unitarity test: ``M† M = M M† = I``.

    Raises ``ValueError`` when the input is not square, because the
    notion of unitarity in the source is only defined for square
    matrices.
    """
    M = sp.Matrix(matrix)
    if not is_square(M):
        raise ValueError("unitarity is only defined for square matrices")
    n = M.rows
    eye = sp.eye(n)
    return _zero(M.H * M - eye) and _zero(M * M.H - eye)


def kron(left: sp.Matrix, right: sp.Matrix) -> sp.Matrix:
    """Kronecker (tensor) product of two matrices."""
    A = sp.Matrix(left)
    B = sp.Matrix(right)
    rows = A.rows * B.rows
    cols = A.cols * B.cols

    def entry(i: int, j: int) -> sp.Expr:
        return A[i // B.rows, j // B.cols] * B[i % B.rows, j % B.cols]

    return sp.Matrix(rows, cols, entry)


def bell_state(index: str) -> sp.Matrix:
    """One of the four Bell states of ``Quantum.thy`` as a 4-vector.

    The labels follow the archived source: ``00`` and ``01`` have
    positive amplitudes, ``10`` and ``11`` have one negative amplitude.
    """
    if index not in BELL_INDICES:
        raise ValueError(f"unknown Bell index {index!r}; expected one of {BELL_INDICES}")
    a = 1 / sp.sqrt(2)
    vectors = {
        "00": [a, 0, 0, a],
        "01": [0, a, a, 0],
        "10": [a, 0, 0, -a],
        "11": [0, a, -a, 0],
    }
    return sp.Matrix(vectors[index])


def norm_squared(vector: sp.Matrix) -> sp.Expr:
    """Squared Euclidean norm ``sum |z_i|^2`` of a complex vector."""
    v = sp.Matrix(vector)
    return sp.simplify(sum(sp.Abs(entry) ** 2 for entry in v))


def is_normalised(vector: sp.Matrix) -> bool:
    """True when the vector has squared norm exactly one."""
    return sp.simplify(norm_squared(vector) - 1) == 0


def product_obstruction(vector: sp.Matrix) -> sp.Expr:
    """The determinant-type obstruction ``v0 v3 - v1 v2`` for a 4-vector.

    If ``v = a ⊗ b`` for two 2-vectors then this expression is
    identically zero.  A non-zero value therefore certifies that ``v``
    is not a product state.  This is the finite algebraic core of the
    archived entanglement argument for the Bell states.
    """
    v = sp.Matrix(vector)
    if v.shape != (4, 1):
        raise ValueError("product obstruction expects a 4-vector")
    return sp.simplify(v[0] * v[3] - v[1] * v[2])


def is_product_state(vector: sp.Matrix) -> bool:
    """Exact test for being a tensor product of two 2-vectors."""
    return product_obstruction(vector) == 0


def measurement_probabilities(vector: sp.Matrix) -> list[sp.Expr]:
    """Computational-basis probabilities ``|v_i|^2`` of a state vector."""
    v = sp.Matrix(vector)
    return [sp.simplify(sp.Abs(entry) ** 2) for entry in v]


def product_state(left: Sequence[sp.Expr], right: Sequence[sp.Expr]) -> sp.Matrix:
    """Tensor product of two explicit 2-vectors, as a 4-vector."""
    a = sp.Matrix(list(left))
    b = sp.Matrix(list(right))
    if a.shape != (2, 1) or b.shape != (2, 1):
        raise ValueError("product_state expects two 2-vectors")
    return kron(a, b)


def gate_sequence(names: Iterable[str]) -> sp.Matrix:
    """Compose named gates left to right, starting from the identity.

    The matrix for ``[g1, g2]`` is ``g2 * g1``, matching the usual
    convention that the rightmost gate acts first.
    """
    keys = list(names)
    if not keys:
        return sp.eye(2)
    result = gate(keys[0])
    for name in keys[1:]:
        nxt = gate(name)
        if nxt.shape != result.shape:
            raise ValueError("gate dimensions do not compose")
        result = nxt * result
    return result
