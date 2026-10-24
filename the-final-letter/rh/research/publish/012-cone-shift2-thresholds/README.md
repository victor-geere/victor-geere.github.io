# publish/012 — Cone, shift-2 core, and the three thresholds

Twelfth published edition. This folder packages **item §12 of `research/truths.md`**: the
workspace-level Lean developments `ConeLean` (the cone residue, the shift-2 core, and the
programme's parity and averaging barriers) and `TppLean` (the three-thresholds theorem).

> **Provenance note.** These proof files live **outside** `research/`, at the workspace
> root `lean/`. They are the only item of the ledger whose sources are not under
> `research/twin-prime-parity/`. They are copied here so that the item is packageable
> like the others; the workspace originals are untouched.

## What the item is

**The shift-2 core.** Writing `chowlaSum` for the correlation sum, the round proves the
finite shift-2 split and reduces the shift-2 problem to shift-1 plus a core term.

| Result | Statement | Status |
|---|---|---|
| shift-2 split (finite) | `chowlaSum` shift-2 decomposition | **PROVED** (Lean) |
| shift-2 ⟺ shift-1 + core | `shift_two_of_shift_one_and_core` | **PROVED** (Lean) |
| core not multiplicative | with witnesses | **PROVED** (Lean) |
| Chowla core identity | `chowlaSum_eq`, `chowlaSum_tendsto_iff_patCount_tendsto` | **PROVED** (Lean) |
| cone residue | cone radius, critical-weight summability | **PROVED** (Lean) |
| parity obstruction | `chowlaAF_not_multiplicative`, `chowlaAF_not_conv` | **PROVED** (Lean) |
| Abel / log-averaging barrier | `abelMean_tendsto_zero`, `log_abel` | **PROVED** (Lean) |
| shift-average barrier | `shift_average_does_not_control_single` | **PROVED** (Lean) |
| spectral structure | `dft_autocorr`, `corr_eq_zero_of_dft_mul_star_dft_eq` | **PROVED** (Lean) |
| **the three thresholds** | `pN < pP < p*` for the `rh42` budget (ledger row T14) | **PROVED** (Lean) |

**The three thresholds.** `pN < pP < p*` locates the negative-budget threshold, the
positive-budget threshold, and the point where the budget interval first contains `0`, in
that order. This is an **internal programme result** — it is *not* a twin-prime or parity
result. Its own paper is included as
[`three-thresholds-paper.html`](three-thresholds-paper.html).

**The barriers.** The `ConeLean` development formalises three obstructions the programme
collided with: the parity obstruction for the correlation, the Abel / log-averaging
barrier (log-averaging does not control a single scale), and the shift-average barrier
(averaging over shifts does not control a single shift). Together with the spectral
structure lemmas these are the machine-checked half of the programme's negative results.

## Contents

| Path | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §12 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`LEAN-README.md`](LEAN-README.md) | The workspace `lean/` development's own guide. |
| [`ConeLean/ShiftTwoCore.lean`](ConeLean/ShiftTwoCore.lean) | The shift-2 decomposition, the shift-2 ⟺ shift-1 + core reduction, and the core's non-multiplicativity. |
| [`ConeLean/ChowlaEquiv.lean`](ConeLean/ChowlaEquiv.lean) | The Chowla core identity and the equivalence with the pattern count. |
| [`ConeLean/Cone.lean`](ConeLean/Cone.lean) | The cone residue: radius and critical-weight summability. |
| [`ConeLean/ParityObstruction.lean`](ConeLean/ParityObstruction.lean) | The parity obstruction. |
| [`ConeLean/ResidueReduction.lean`](ConeLean/ResidueReduction.lean) | The Abel / log-averaging barrier. |
| [`ConeLean/ShiftBarrier.lean`](ConeLean/ShiftBarrier.lean) | The shift-average barrier. |
| [`ConeLean/SpectralStructure.lean`](ConeLean/SpectralStructure.lean) | The DFT autocorrelation identity and the vanishing criterion. |
| [`ConeLean/PairThreshold.lean`](ConeLean/PairThreshold.lean), [`ConeLean/PairCensus.lean`](ConeLean/PairCensus.lean) | The pair threshold and census. |
| [`ConeLean/LogAverageBarrier.lean`](ConeLean/LogAverageBarrier.lean) | The log-average barrier companion. |
| [`ConeLean.lean`](ConeLean.lean) | Root module for the cone development. |
| [`TppLean/Core.lean`](TppLean/Core.lean), [`TppLean/Budget.lean`](TppLean/Budget.lean), [`TppLean/ThreeThresholds.lean`](TppLean/ThreeThresholds.lean), [`TppLean.lean`](TppLean.lean) | The `TppLean` development and the three-thresholds theorem. |
| [`check.sh`](check.sh) | Builds both developments, 15 files in dependency order. |
| [`notes/residue-verdict.md`](notes/residue-verdict.md) | The cone residue ledger, referenced by `ConeLean/ChowlaEquiv.lean`. |
| [`three-thresholds-paper.html`](three-thresholds-paper.html) | The paper for the three-thresholds theorem. |

## What is proved, and what is not

* **Proved in Lean** — everything in the two tables above. Both developments are
  axiom-clean and contain no `sorry`.
* **Not claimed** — the three-thresholds theorem is an internal programme result and is
  explicitly **not** a twin-prime/parity theorem. The barriers recorded here are
  obstructions, not positive results.

## Running the checks

```sh
./check.sh --all          # Lean 4 + Mathlib, 15 files, exits 0 (~2 min)
```

The `--all` list is in dependency order: `TppLean` first (`TppLean.ThreeThresholds`
imports `TppLean.Budget`), then `ConeLean` (`ShiftTwoCore` imports `ChowlaEquiv`;
`Cone` imports `TppLean.Budget`; `PairThreshold` imports `Cone` and
`TppLean.ThreeThresholds`).

See `publish/002-greedy-digit-word/README.md` for the `LEAN_PREFIX` convention.

## Dependencies

Everything needed is in this folder. The only external dependency is **Mathlib**. There
are no Python scripts in this item.

## Provenance

The proof files live at the workspace root `lean/`; see `research/truths.md` §12. They
are reproduced here unmodified except that one docstring reference in
`ConeLean/ChowlaEquiv.lean` has been re-pointed to the local copy of the cone residue
ledger. The workspace originals remain the canonical copies for the programme.
