# Lean layer — what is and is not formalised

[`Topic.lean`](Topic.lean) is the formal core. It imports Mathlib, uses the
namespace `AFP`, and contains seven proved facts with no `sorry`, `axiom`, or
`admit`.

## What is formalised

The archived entry defines its gates as `2 × 2` matrices over `complex`
(`Quantum.thy`). The Lean file translates exactly that finite algebra:

| Lean name | Statement | Archived counterpart |
|---|---|---|
| `AFP.X_mul_self` | `X * X = 1` | `X_inv`, `Quantum.thy:1109` |
| `AFP.Z_mul_self` | `Z * Z = 1` | `Z_inv`, `Quantum.thy:1145` |
| `AFP.H2_mul_self` | `H2 * H2 = 2 • 1` | auxiliary normalisation step |
| `AFP.c_sq` | `c * c = 1/2` | auxiliary normalisation step |
| `AFP.H_mul_self` | `H * H = 1` | `H_inv`, `Quantum.thy:1169` |
| `AFP.H_conjTranspose` | `Hᴴ = H` | `dagger_of_H`, `Quantum.thy:1165` |
| `AFP.HXH_eq_Z` | `H * X * H = Z` | `HXH_is_Z`, `Quantum.thy:1235` |

The matrices are

```
X  = [[0, 1], [1, 0]]
Z  = [[1, 0], [0, -1]]
H2 = [[1, 1], [1, -1]]
H  = c • H2,  c = sqrt 2 / 2
```

`H2_mul_self` and `c_sq` are not padding: together they are the reason
`H * H = 1`, because `(c • H2) * (c • H2) = (c * c) • (H2 * H2) = (1/2) • (2 • 1)`.
This is a genuine source-relevant proof decomposition, not a file of `rfl`.

## What is not formalised

The source is much larger than the seven lemmas above. In particular this file
does **not** define or prove:

1. **The source's predicates.** `state`, `state_qbit`, `unitary`, `gate`,
   `square_mat`, and the Hermitian conjugation type are not translated. The
   Lean core works with concrete `Matrix (Fin 2) (Fin 2) ℂ` values, not the
   source's dimension-indexed `complex mat` with `2^n` rows and columns.
2. **The full matrix API.** `cpx_vec_length`, `inner_prod`, `dagger`, `bra`,
   `ket`, matrix multiplication lemmas, and the `Jordan_Normal_Form` matrix
   representation are not reconstructed.
3. **The Pauli `Y` conjugation.** `HYH_is_minusY` (`Quantum.thy:1241`) is
   checked exactly in the Python layer (`test_pauli_involutions_and_hadamard_conjugation`)
   but is not a Lean theorem here. The same applies to `HZH_is_X`.
4. **CNOT.** The `4 × 4` gate, its involution, and its unitarity are checked by
   sympy in `tests/test_programme.py`, not by Lean.
5. **Phase gates.** `S`, `T`, their orders, and the relation `T^2 = S` are
   sympy computations only.
6. **Bell states and entanglement.** The archived `entangled2` lemmas
   (`Entanglement.thy`) use the source's state and tensor-product definitions.
   The Python layer only checks the determinant-type obstruction for the four
   Bell vectors; the Lean file does not define `entangled2`.
7. **The no-cloning theorem, teleportation, Deutsch–Jozsa, measurement, and the
   quantum prisoners' dilemma.** These are source theorems in the archived
   entry and are recorded as source claims, not as theorems of this
   reconstruction.
8. **The AFP corpus as a whole.** The corpus has 976 entries and 10,068 theory
   files; this dossier inspects one entry (`Isabelle_Marries_Dirac`) and only a
   small part of it. Nothing outside that entry was surveyed.

## Build

```bash
./lean/check.sh
```

The wrapper calls `../../tools/check-lean.sh`, which uses the local Mathlib
installation (`$HOME/lean/mathlib4` by default, override with `LEAN_PREFIX`).
The last successful build is recorded in [`BUILD.log`](BUILD.log). On a cold
filesystem cache the first Mathlib import can take several minutes; subsequent
builds of this file take a few seconds.
