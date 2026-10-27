# What my first draft got wrong

**Kind:** Claim
**Status:** REFUTED (numerical; isolated by the round's auditor)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) — "What my first draft got wrong"

## Statement

> **What my first draft got wrong** (isolated numerically by the round's auditor, see
> [`truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) §1):
>
> | error | size (`σ=1` Gaussian) |
> |---|---|
> | pole arguments `F(1)+F(0)` instead of `2φ(i/2)` | `−0.659766246421` |
> | **missing archimedean integral** `(1/2π)∫φΨ` | `−1.196346718078` |
> | residual the draft left (must be 0) | `+0.536580471657` |

The source adds:

> The Cauchy kernel at `a = 1/2` is the boundary case — both its pole term and its
> prime sum diverge — which is exactly why my first Cauchy-based test could never have
> worked.

## Hypotheses and notation

- The draft used pole arguments `F(1)+F(0)`; the correct pole terms are `2φ(i/2)` for even `g`.
- The draft omitted the archimedean integral `(1/2π)∫φΨ`; `Ψ(t) = −log π + Re ψ(1/4 + it/2)`.
- The sizes are on the `σ = 1` Gaussian kernel; the residual must be `0`.

## Proof / evidence

- Refutation by the auditor's numerical isolation of the two errors and their net residual (table above), recorded in [`truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) §1 (auditor's decomposition, C1d).
- The corrected form that replaces the draft is [The instrument — and the correct form of the formula](tpp-rh45-readme-correct-explicit-formula.md).

## Dependencies and related results

- [The instrument — and the correct form of the formula](tpp-rh45-readme-correct-explicit-formula.md).
- [The first draft's explicit formula is wrong twice](tpp-rh45-truths-draft-formula-refuted.md) — the ledger's statement of the same refutation.
- [C1e (Cauchy a = 1/2 to 20 digits) is refuted as stated](tpp-rh45-truths-cauchy-boundary-case-refuted.md) — the separate Cauchy boundary failure.

## Notes

- This is the README's own correction of the round's first draft; the source does not attribute the draft's form to any external work.
- The source gives no analytic proof of the divergence of the Cauchy `a = 1/2` pole term and prime sum; it states them as the reason the test could not work.
