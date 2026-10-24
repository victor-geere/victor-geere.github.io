# Isabelle / AFP corpus — research-programme dossier

**Status:** reconstructed formal core of one AFP entry, plus an exact computation layer.  
**Source:** [`archive/rh-proof/afp-2026-05-08/thys/ROOT`](../../archive/rh-proof/afp-2026-05-08/thys/ROOT), entry [`Isabelle_Marries_Dirac`](../../archive/rh-proof/afp-2026-05-08/thys/Isabelle_Marries_Dirac/ROOT).  
**Inventory:** [Scraps](../../scraps.html) item 37 · [Topic index](../README.md).  
**Nature of the source:** formal-verification corpus, not a paper, and not a Riemann-hypothesis proof.

## What the source is

The inventory entry points at the top-level AFP `ROOT`:

```
chapter_definition AFP (AFP)
  description "
    Archive of Formal Proofs
  "
```

That file is four lines long and names the archive, not a result. The corpus
around it is large:

| Measurement | Value |
|---|---|
| AFP entries (directories under `thys/`) | 976 |
| Files under `afp-2026-05-08/` | 15,424 |
| Isabelle theory files (`.thy`) | 10,068 |
| Size on disk | about 396 MB |

The inventory text says “15,416-file”; the tree as checked contains 15,424
files. That small discrepancy is recorded as an open item rather than
silently corrected.

The entry relevant to the inventory description is
`thys/Isabelle_Marries_Dirac`, the “Isabelle marries Dirac” library. It is a
quantum-information formalisation in Isabelle/HOL, not an RH or GRH proof. Its
`ROOT` declares one session with 13 theories (abridged below; the archived file
also sets `timeout = 1200`):

```
session "Isabelle_Marries_Dirac" = "Jordan_Normal_Form" +
  sessions Matrix_Tensor VectorSpace
  theories Basics Binary_Nat Quantum Complex_Vectors Tensor More_Tensor
           Measurement Entanglement Quantum_Teleportation Deutsch
           Deutsch_Jozsa No_Cloning Quantum_Prisoners_Dilemma
```

The 13 files total 8,512 lines. The entry `README.md` says the development
uses Isabelle2020 and depends on the AFP entries `Jordan_Normal_Form`,
`Matrix_Tensor`, and `VectorSpace`. The headers credit Anthony Bordg and
Yijun He, with contributions by Hanna Lachnitt.

**Honest scope statement.** This dossier does not survey the AFP. It reads the
top-level `ROOT`, the entry `ROOT` and `README.md`, `Basics.thy` in full, and
the gate, Bell-state, and no-cloning sections of `Quantum.thy`,
`Entanglement.thy`, and `No_Cloning.thy`. No claim is made about the other 975
entries.

## What was reconstructed

The archived development defines its gates as concrete `2 × 2` complex
matrices. The reconstruction isolates that finite algebra so it can be checked
independently in Lean and sympy.

| Object | Archived definition | Reconstruction |
|---|---|---|
| `X` | `[[0,1],[1,0]]` (`Quantum.thy:1096`) | Lean `AFP.X`; sympy `X` |
| `Z` | `[[1,0],[0,-1]]` (`Quantum.thy:1138`) | Lean `AFP.Z`; sympy `Z` |
| `H` | `(1/sqrt 2) • [[1,1],[1,-1]]` (`Quantum.thy:1158`) | Lean `AFP.H = c • H2`; sympy `H` |
| `H2`, `c` | normalisation split used here | Lean `AFP.H2`, `AFP.c = sqrt 2 / 2` |
| `Y` | `[[0,-i],[i,0]]` | sympy `Y` only |
| `CNOT` | the two-qubit controlled-NOT matrix (`Quantum.thy:1201`) | sympy `CNOT` only |
| `S`, `T` | phase gate and `pi/8` gate (`Quantum.thy:1225`, `1230`) | sympy `S`, `T` only |
| Bell states | `bell00`, `bell01`, `bell10`, `bell11` (`Quantum.thy:1261`) | sympy `bell_state("00")`, … |
| Product obstruction | determinant-type condition used in `Entanglement.thy` | sympy `product_obstruction` |

The Lean core works with `Matrix (Fin 2) (Fin 2) ℂ`. It does not reproduce the
source's dimension-indexed `complex mat`, its `state`/`unitary`/`gate`
predicates, or its `Jordan_Normal_Form` matrix representation.

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no
`sorry`, `axiom`, or `admit`. T1–T2 and T5–T7 are the source's own gate lemmas, re-proved here for the
concrete `2 × 2` matrices; T3–T4 are the normalisation steps those proofs use.
Their warrant is the Lean proof, not the archive. Every **Computation** row is checked by
[`tests/test_programme.py`](tests/test_programme.py). **Source claim** and
**Open / conjecture** rows are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test / status |
|---|---|---|---|
| T1 | Theorem | `X * X = 1` | `AFP.X_mul_self` |
| T2 | Theorem | `Z * Z = 1` | `AFP.Z_mul_self` |
| T3 | Theorem | `H2 * H2 = 2 • 1` | `AFP.H2_mul_self` |
| T4 | Theorem | `c * c = 1/2` | `AFP.c_sq` |
| T5 | Theorem | `H * H = 1` | `AFP.H_mul_self` |
| T6 | Theorem | `Hᴴ = H` | `AFP.H_conjTranspose` |
| T7 | Theorem | `H * X * H = Z` | `AFP.HXH_eq_Z` |
| C1 | Computation | `H² = 1`, `Hᴴ = H`, and `H` is unitary exactly. | `test_hadamard_is_involution_and_self_adjoint` |
| C2 | Computation | `X² = Y² = Z² = 1`, `HXH = Z`, `HYH = −Y`, `HZH = X`. | `test_pauli_involutions_and_hadamard_conjugation` |
| C3 | Computation | `CNOT² = 1`, `CNOTᴴ = CNOT`, and `CNOT` is unitary. | `test_cnot_is_involution_and_unitary` |
| C4 | Computation | `S² = Z`, `T² = S`, `T⁴ = Z`, `T⁸ = 1`; gate composition is order-sensitive. | `test_phase_gates_have_the_expected_orders` |
| C5 | Computation | Each Bell vector has norm one and flat probabilities `(1/2,0,0,1/2)` up to permutation. | `test_bell_states_are_normalised_with_half_probabilities` |
| C6 | Computation | `v0 v3 − v1 v2 ≠ 0` for every Bell vector and `= 0` for product vectors, including a zero factor. | `test_product_obstruction_separates_bell_states_from_products` |
| C7 | Computation | Invalid Bell labels, gate names, non-square unitarity tests, and malformed vectors raise `ValueError`. | `test_invalid_inputs_raise_value_error` |

### Why the split `H = c • H2` is genuine

The source writes `H = 1/sqrt 2 • H2`. The Lean proof separates the two
ingredients: `H2 * H2 = 2 • 1` (T3) and `c * c = 1/2` (T4), so
`(c • H2) * (c • H2) = (1/2) • (2 • 1) = 1` (T5). These are exact rational and
quadratic-surd identities, not `rfl` padding; they are the normalisation
argument the source itself performs in `H_inv`.

## Source claims not promoted to theorems

| # | Claim | Archived status | Reconstruction note |
|---|---|---|---|
| S1 | `H * Y * H = −Y` (`HYH_is_minusY`, `Quantum.thy:1241`) | Source lemma, `[simp]` | Checked exactly in sympy (C2); not a Lean theorem here. |
| S2 | `H * Z * H = X` (`HZH_is_X`, `Quantum.thy:1247`) | Source lemma, `[simp]` | Checked exactly in sympy (C2); not a Lean theorem here. |
| S3 | `CNOT * CNOT = 1`, `CNOT` is a gate (`CNOT_inv`, `CNOT_is_gate`) | Source lemmas, `[simp]` | Checked in sympy (C3); the Lean file does not define the `4 × 4` gate. |
| S4 | The four Bell states are entangled (`entangled2`, `Entanglement.thy:31–105`) | Source lemmas | The finite obstruction is computed (C6); the source's `entangled2` predicate and its state/tensor definitions are not formalised. |
| S5 | No-cloning theorem (`no_cloning`, `No_Cloning.thy:195`) | Source theorem | Not formalised. It needs the source's inner-product, tensor, and unitary evolution infrastructure. |
| S6 | Quantum teleportation correctness (`Quantum_Teleportation.thy`) | Source theorem | Not surveyed beyond the file header; not formalised. |
| S7 | Deutsch–Jozsa correctness (`Deutsch_Jozsa.thy`) | Source theorem | Not surveyed beyond the entry `ROOT`; not formalised. |
| S8 | Measurement, quantum prisoners' dilemma, universal gate sets | Source definitions and theorems | Not surveyed; recorded only as corpus contents. |

None of S1–S8 is used as a theorem of this reconstruction. In particular, no
Riemann-hypothesis, GRH, twin-prime, Chowla, Sarnak, or Elliott claim appears
in the entry inspected, and none is asserted here.

## Open items and gaps

1. **The AFP is not surveyed.** 976 entries and 10,068 theory files remain
   outside this dossier. The inventory item is a corpus, not a single result.
2. **The source predicates are not in Lean.** A faithful translation would
   define `state`, `unitary`, `gate`, and the dimension-indexed matrix type,
   then prove the gate lemmas at the source's level of generality. The present
   Lean core is deliberately the concrete `2 × 2` shadow.
3. **Bell entanglement is not a Lean theorem.** Only the determinant-type
   obstruction is computed. A Lean proof would need a vector-space definition
   of product state and a proof that no pair of unit vectors tensors to a Bell
   vector.
4. **No-cloning is not formalised.** This is the most substantial theorem in
   the entry and would require the Cauchy–Schwarz and inner-product development
   of `No_Cloning.thy`.
5. **CNOT and phase-gate algebra is computational only.** C3 and C4 are exact
   sympy checks, not Lean theorems.
6. **No connection to the RH programme was found.** The entry is a
   quantum-computing library. The inventory's placement under
   `archive/rh-proof/` is a filing fact, not evidence of an RH proof. This is
   recorded as a negative finding.
7. **File-count discrepancy.** The inventory says 15,416 files; the checked
   tree has 15,424. The difference is unexplained and immaterial to the
   mathematics, but it is not hidden.
8. **Cold-cache build cost.** The first Mathlib import on a cold filesystem
   cache can take several minutes; the Lean build itself is 5–7 seconds once
   the oleans are warm.

## Python layer

[`python/programme.py`](python/programme.py) is an exact sympy model. It
contains:

- gate matrices `X`, `Y`, `Z`, `H`, `CNOT`, `S`, `T`;
- `gate(name)`, `gate_sequence(names)`;
- `dagger`, `matrix_equal`, `is_unitary`, `kron`;
- `bell_state(index)`, `norm_squared`, `is_normalised`,
  `measurement_probabilities`;
- `product_obstruction`, `is_product_state`, `product_state`.

The module has no import-time side effects and raises `ValueError` on invalid
shapes or labels. It uses exact surds and `exp(I*pi/4)`, not floating point.

Run the suite from this directory:

```bash
python3 -m pytest -q tests
```

Current result: **7 passed** in about 0.2 s.

Example:

```python
from python.programme import H, X, Z, matrix_equal, bell_state, product_obstruction
assert matrix_equal(H * X * H, Z)
assert product_obstruction(bell_state("00")) != 0
```

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `AFP`
namespace, and proves T1–T7. It uses only `Matrix (Fin 2) (Fin 2) ℂ`, `Fin`
case analysis, `ring`, `norm_num`, and the exact identity `Real.sq_sqrt`.

```bash
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

The Lean file does **not** contain `sorry`, `axiom`, or `admit`. What it does
not formalise is listed in [`lean/README.md`](lean/README.md): the source's
state/unitary/gate predicates, the dimension-indexed matrix type, CNOT, the
phase gates, Bell entanglement, no-cloning, teleportation, Deutsch–Jozsa, and
the rest of the AFP.

## Provenance and links

- Inventory item 37: [`scraps.html`](../../scraps.html).
- All topic folders: [`topics/README.md`](../README.md).
- Top-level AFP chapter: [`thys/ROOT`](../../archive/rh-proof/afp-2026-05-08/thys/ROOT).
- Entry session: [`Isabelle_Marries_Dirac/ROOT`](../../archive/rh-proof/afp-2026-05-08/thys/Isabelle_Marries_Dirac/ROOT).
- Entry notes: [`Isabelle_Marries_Dirac/README.md`](../../archive/rh-proof/afp-2026-05-08/thys/Isabelle_Marries_Dirac/README.md).
- Gate definitions and lemmas: [`Quantum.thy`](../../archive/rh-proof/afp-2026-05-08/thys/Isabelle_Marries_Dirac/Quantum.thy).
- Entanglement argument: [`Entanglement.thy`](../../archive/rh-proof/afp-2026-05-08/thys/Isabelle_Marries_Dirac/Entanglement.thy).
- No-cloning: [`No_Cloning.thy`](../../archive/rh-proof/afp-2026-05-08/thys/Isabelle_Marries_Dirac/No_Cloning.thy).
- Programme standard: [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
