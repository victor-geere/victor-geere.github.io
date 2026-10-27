# The first draft's explicit formula is wrong twice

**Kind:** Claim
**Status:** REFUTED (numerical witnesses; auditor's decomposition C1d)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §1 "The correct explicit formula", the draft-error table (auditor's decomposition, C1d)

## Statement

> The round's first draft used `F(s) = ∫_ℝ g(u)e^{−su}du` with pole terms `F(1)+F(0)`.
> **That is wrong twice**, and the auditor isolated both errors numerically.

**What the draft got wrong** (auditor's decomposition, C1d):

| error | size (`σ = 1` Gaussian) |
|---|---|
| pole arguments: `F(1)+F(0)` instead of `2φ(i/2)` | `−0.659766246421` |
| the **missing archimedean integral** `(1/2π)∫φΨ` | `−1.196346718078` |
| net effect on the residual (must be 0) | `+0.536580471657` |

## Hypotheses and notation

- `F(s) = ∫_ℝ g(u)e^{−su}du` is the draft's transform of the test function `g`; `φ(t) = ∫_ℝ g(u)e^{itu}du` is the corrected Fourier transform and `Φ(s) = φ((s−1/2)/i)` the shifted Laplace transform.
- `Ψ(t) = −log π + Re ψ(1/4 + it/2)` is the archimedean weight; `2φ(i/2)` are the correct pole terms for even `g`.
- The sizes are measured on the `σ = 1` Gaussian kernel; the residual is the difference between the two sides of the identity and must be `0`.

## Proof / evidence

- The refutation is numerical: the auditor's decomposition C1d isolates the two error terms and their net effect on the residual (the table above).
- The corrected form that replaces the draft is stated and verified in [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md).

## Dependencies and related results

- [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md) — the corrected Weil form with the archimedean term restored.
- [C1e (Cauchy a = 1/2 to 20 digits) is refuted as stated](tpp-rh45-truths-cauchy-boundary-case-refuted.md) — the separate failure of the draft's Cauchy-based test.
- The same error table is stated in [`README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) (harvested as [What my first draft got wrong](tpp-rh45-readme-draft-errors-refuted.md)).

## Notes

- The source presents this as a correction of the round's own first draft; it does not attribute the draft's form to any external source.
- The ledger (§3) records that the auditor's four failures are "over-strong criteria, not false claims"; this row is the auditor's own numerical decomposition of the draft's errors.
- The sizes are quoted exactly as printed, with unicode minus signs.
