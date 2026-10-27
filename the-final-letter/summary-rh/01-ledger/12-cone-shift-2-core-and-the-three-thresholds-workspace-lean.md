# 12. Cone, shift-2 core and the three thresholds (workspace `lean/`)

> Source: [`research/truths.md`](../../rh/research/truths.md), §12. Status language is the ledger’s own.

These proof files live **outside** `research/`, at the workspace root `lean/`.

| result | statement | status | Lean proof |
|---|---|---|---|
| shift-2 split (finite) | `chowlaSum` shift-2 decomposition | PROVED (Lean) | [`ShiftTwoCore.lean#L63`](../../rh/lean/ConeLean/ShiftTwoCore.lean#L63) |
| shift-2 ⟺ shift-1 + core | `shift_two_of_shift_one_and_core` | PROVED (Lean) | [`ShiftTwoCore.lean#L155`](../../rh/lean/ConeLean/ShiftTwoCore.lean#L155) |
| core not multiplicative | with witnesses | PROVED (Lean) | [`ShiftTwoCore.lean#L120`](../../rh/lean/ConeLean/ShiftTwoCore.lean#L120) |
| Chowla core identity | `chowlaSum_eq`, `chowlaSum_tendsto_iff_patCount_tendsto` | PROVED (Lean) | [`ChowlaEquiv.lean#L77`](../../rh/lean/ConeLean/ChowlaEquiv.lean#L77) |
| cone residue | `shift_two_of_...` / cone radius, critical weight summability | PROVED (Lean) | [`Cone.lean`](../../rh/lean/ConeLean/Cone.lean) |
| parity obstruction | `chowlaAF_not_multiplicative`, `chowlaAF_not_conv` | PROVED (Lean) | [`ParityObstruction.lean`](../../rh/lean/ConeLean/ParityObstruction.lean) |
| Abel/log-averaging barrier | `abelMean_tendsto_zero`, `log_abel` | PROVED (Lean) | [`ResidueReduction.lean#L443`](../../rh/lean/ConeLean/ResidueReduction.lean#L443) |
| shift-average barrier | `shift_average_does_not_control_single` | PROVED (Lean) | [`ShiftBarrier.lean#L94`](../../rh/lean/ConeLean/ShiftBarrier.lean#L94) |
| spectral structure | `dft_autocorr`, `corr_eq_zero_of_dft_mul_star_dft_eq` | PROVED (Lean) | [`SpectralStructure.lean`](../../rh/lean/ConeLean/SpectralStructure.lean) |
| **three thresholds** | `pN < pP < p*` for the rh42 budget (ledger row T14) | PROVED (Lean) | [`tpp_rh42_three_thresholds`](../../rh/lean/TppLean/ThreeThresholds.lean#L734) |

The three-thresholds theorem is an **internal programme result** — it is *not* a
twin-prime/parity result ([`theorems/tpp-rh42-three-thresholds-paper.html`](../../rh/research/twin-prime-parity/theorems/tpp-rh42-three-thresholds-paper.html)).

---
