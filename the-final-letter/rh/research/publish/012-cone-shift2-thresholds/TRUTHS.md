## 12. Cone, shift-2 core and the three thresholds (workspace `lean/`)

These proof files live **outside** `research/`, at the workspace root `lean/`.

| result | statement | status | Lean proof |
|---|---|---|---|
| shift-2 split (finite) | `chowlaSum` shift-2 decomposition | PROVED (Lean) | [`ShiftTwoCore.lean#L63`](ConeLean/ShiftTwoCore.lean#L63) |
| shift-2 ⟺ shift-1 + core | `shift_two_of_shift_one_and_core` | PROVED (Lean) | [`ShiftTwoCore.lean#L155`](ConeLean/ShiftTwoCore.lean#L155) |
| core not multiplicative | with witnesses | PROVED (Lean) | [`ShiftTwoCore.lean#L120`](ConeLean/ShiftTwoCore.lean#L120) |
| Chowla core identity | `chowlaSum_eq`, `chowlaSum_tendsto_iff_patCount_tendsto` | PROVED (Lean) | [`ChowlaEquiv.lean#L77`](ConeLean/ChowlaEquiv.lean#L77) |
| cone residue | `shift_two_of_...` / cone radius, critical weight summability | PROVED (Lean) | [`Cone.lean`](ConeLean/Cone.lean) |
| parity obstruction | `chowlaAF_not_multiplicative`, `chowlaAF_not_conv` | PROVED (Lean) | [`ParityObstruction.lean`](ConeLean/ParityObstruction.lean) |
| Abel/log-averaging barrier | `abelMean_tendsto_zero`, `log_abel` | PROVED (Lean) | [`ResidueReduction.lean#L443`](ConeLean/ResidueReduction.lean#L443) |
| shift-average barrier | `shift_average_does_not_control_single` | PROVED (Lean) | [`ShiftBarrier.lean#L94`](ConeLean/ShiftBarrier.lean#L94) |
| spectral structure | `dft_autocorr`, `corr_eq_zero_of_dft_mul_star_dft_eq` | PROVED (Lean) | [`SpectralStructure.lean`](ConeLean/SpectralStructure.lean) |
| **three thresholds** | `pN < pP < p*` for the rh42 budget (ledger row T14) | PROVED (Lean) | [`tpp_rh42_three_thresholds`](TppLean/ThreeThresholds.lean#L734) |

The three-thresholds theorem is an **internal programme result** — it is *not* a
twin-prime/parity result ([`theorems/tpp-rh42-three-thresholds-paper.html`](three-thresholds-paper.html)).
