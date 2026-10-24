# Greedy harmonic transfer operator — reconstruction placeholder

**Status:** source directory empty; reconstructed formal core and exact computation layer only. No archived mathematics recovered.  
**Source:** `archive/maths/rh/research/greedy-harmonic-transfer-operator/` — verified empty (no paper, note, prompt, or definition).  
**Inventory:** [Scraps](../../scraps.html) item 12 · [Topic index](../README.md).

## Provenance and source status

The scraps inventory lists item 12 as **“Greedy harmonic transfer operator”** and describes the source as “an empty placeholder directory. No paper, note, or prompt.” That description is accurate: the directory contains no files, so there is no archived definition, theorem, conjecture, computation, or proof to reconstruct.

This folder therefore does **not** reconstruct an archived argument. It is an honest placeholder programme:

- the **source claims** are limited to the inventory label itself;
- the **objects** below are an explicit reconstruction choice made for this folder, not a recovery of a lost source definition;
- the **formal core** proves only elementary facts about those chosen objects;
- no Riemann-hypothesis, GRH, twin-prime, Chowla, Sarnak, or Elliott claim is present in the source or asserted here.

The adjacent [greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) programme is the nearest genuine mathematical context in the repository. Its terminology (the normalised harmonic angle `α_n/π = 1/(n+2)`) motivates the weight used here, but none of its theorems is imported or claimed as a result of this topic.

## What this programme is, and is not

Because no source operator exists, the reconstruction fixes the simplest positive transfer step compatible with the normalised greedy harmonic weights. It is deliberately small enough to be checked completely, and it is labelled as a reconstruction throughout.

**Is:** a weighted-shift model on real sequences, with exact positivity, monotonicity, bound, iteration, and finite-mass facts; a Python layer that computes these objects exactly; a Lean layer that proves the corresponding elementary theorems.

**Is not:** a recovery of an archived transfer-operator construction; a spectral theorem; a Hilbert–Pólya operator; a route to the Riemann hypothesis. The name of the inventory item is not evidence that any such construction was ever written down.

## Reconstructed objects and notation

| Object | Definition | Lean name | Python name |
|---|---|---|---|
| Normalised harmonic weight | `w n = 1 / (n + 2) = α_n / π` | `weight` | `weight(n)` |
| Transfer step | `(T a) n = w n * a (n + 1)` (weighted shift) | `transfer` | `transfer(seq, n)`, `transfer_sequence(seq)` |
| Iterated transfer | `T^k a`, the `k`-fold iterate | `transferIter k a` | `transfer_iterate(seq, k)` |
| Greedy remainder | `R θ n = θ − w n` | `remainder` | `remainder(theta, n)` |
| Finite transferred mass | `W N = Σ_{n<N} w n` | `totalWeight N` | `total_weight(N)` |

The selection predicate used by the Python layer is `selects(theta, n)`, meaning `w n ≤ θ`; equality counts as a selection. It is the boundary case of the one-step greedy rule, not a new source definition.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). Rows marked **Source claim** and **Open / conjecture** are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `0 < w n` for every `n`. | `GreedyHarmonicTransfer.weight_pos` |
| T2 | Theorem | `w n ≤ 1/2` for every `n`. | `GreedyHarmonicTransfer.weight_le_half` |
| T3 | Theorem | `n ↦ w n` is strictly antitone. | `GreedyHarmonicTransfer.weight_strictAnti` |
| T4 | Theorem | `T` preserves pointwise non-negativity. | `GreedyHarmonicTransfer.transfer_nonneg` |
| T5 | Theorem | `T` is pointwise monotone. | `GreedyHarmonicTransfer.transfer_mono` |
| T6 | Theorem | Every iterate `T^k` preserves pointwise non-negativity. | `GreedyHarmonicTransfer.transferIter_nonneg` |
| T7 | Theorem | `W 2 = 5/6` exactly. | `GreedyHarmonicTransfer.totalWeight_two` |
| C1 | Computation | Weights are exact rationals; a negative index is rejected. | `test_weight_exact_and_domain` |
| C2 | Computation | `0 < w n < w(n−1) ≤ 1/2` exactly for `1 ≤ n ≤ 39`. | `test_weight_strictly_decreasing_and_bounded` |
| C3 | Computation | One transfer step preserves non-negativity; empty and singleton sequences have empty image. | `test_transfer_positivity` |
| C4 | Computation | One transfer step preserves pointwise order, including a strict comparison. | `test_transfer_monotonicity` |
| C5 | Computation | All iterates preserve non-negativity; over-iteration yields the empty sequence. | `test_transfer_iterate_positivity_and_edge` |
| C6 | Computation | `W N = H_{N+1} − 1` exactly for `N ≤ 24`, with `W 2 = 5/6`. | `test_total_weight_exact_and_closed_form` |
| C7 | Computation | At `θ = w n` the step is selected and the remainder is zero; just below, neither holds. | `test_remainder_and_selection_edge` |
| S1 | Source claim | The scraps inventory labels item 12 “Greedy harmonic transfer operator” and records the directory as an empty placeholder. | Inventory item 12; no mathematical content. |
| O1 | Open / conjecture | There is a canonical GHD transfer operator whose matrix coefficients are the GHD correlation kernel `K(n,m)`. | Not in the source; no construction exists here. |
| O2 | Open / conjecture | The weighted shift `T` above is the correct finite-depth truncation of the operator in O1. | Reconstruction choice; unvalidated. |
| O3 | Open / conjecture | A self-adjoint Hilbert–Pólya realisation of such an operator has spectrum matching the nontrivial zeta zeros. | Wider programme hope; not asserted or evidenced by this source. |

The ledger has exactly one **Source claim**: the inventory label, which is not a mathematical assertion. The absence of further source claims is a finding about the archive, not an omission.

## Python layer

[`python/programme.py`](python/programme.py) implements the reconstructed objects with exact `sympy` rationals. It uses no floating point except a 60-digit fallback in `selects` when a symbolic sign cannot be decided; the tests exercise exact comparisons.

```python
from programme import weight, transfer_sequence, total_weight, selects, remainder

weight(0)                    # 1/2
weight(3)                    # 1/5
transfer_sequence([1, 0, 2, 0])   # [0, 2/9, 0]
total_weight(2)              # 5/6
selects(weight(4), 4)        # True (equality selects)
remainder(weight(4), 4)      # 0
```

Run the tests from this folder:

```bash
cd the-final-letter/topics/greedy-harmonic-transfer-operator
python3 -m pytest -q tests
```

Recorded result: **7 passed** in under one second. The suite covers every Computation row and the boundary cases of negative indices, empty sequences, exact threshold equality, and over-iteration.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and defines the objects in namespace `GreedyHarmonicTransfer`. It proves T1–T7 using only elementary order, field, and induction facts. There is no `sorry`, no `axiom`, and no `admit`.

```bash
cd the-final-letter/topics/greedy-harmonic-transfer-operator
./lean/check.sh
```

The wrapper calls the shared [`check-lean.sh`](../tools/check-lean.sh) against the local Mathlib installation. Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean (11s)`.

## What is not formalised, and why

The formal core is intentionally minimal because the source is empty. The following are **not** Lean theorems here:

1. **Existence of a canonical source operator.** No source definition exists to formalise. O1 is a proposed reconstruction target, not a recovered object.
2. **Spectral theory of `T`.** The weighted shift is not shown to be bounded, compact, self-adjoint, or to have any prescribed spectrum. None of those properties is needed for T1–T7.
3. **A Hilbert–Pólya realisation.** O3 is a wider programme hope and is not stated by this source. It is recorded as open, never as a theorem.
4. **Connection to the GHD threshold recursion.** The adjacent greedy-harmonic programme has its own threshold results; this placeholder does not import, prove, or depend on them.
5. **Recovery of lost content.** If a document for this programme exists outside the repository, it has not been found here; the reconstruction should be replaced rather than extended if such a document surfaces.

## Open items and known gaps

- **O1/O2 (definitional):** decide whether a canonical transfer operator for greedy harmonic selection can be defined independently of this reconstruction, and whether the weighted shift is its correct finite truncation.
- **O3 (spectral):** any Hilbert–Pólya or zeta-spectral interpretation remains open and is not supported by the source.
- **Provenance gap:** the directory is empty. The honest next step is to recover a source document, or to leave this folder as a documented placeholder rather than present the reconstruction as archived mathematics.
- **Scope of the formal core:** T1–T7 are elementary facts about the chosen definitions. They do not validate the choice of definition.

## Provenance

- Source directory `archive/maths/rh/research/greedy-harmonic-transfer-operator/` — empty; inventory item 12.
- [Scraps inventory](../../scraps.html) — item 12, status `empty`.
- [Topic index](../README.md) — all topic folders.
- [Greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) — adjacent programme supplying the normalised-angle terminology.
- [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
