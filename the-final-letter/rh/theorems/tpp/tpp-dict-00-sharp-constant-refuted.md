# the sharp constant is `1/|s−1| = 1/√(1/4+t²)`, not `1/√(2t)`

**Kind:** Claim
**Status:** REFUTED (first draft; the corrected constant `1/|s−1|` is asserted instead)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)", row E2, line 92

## Statement

The ledger row, verbatim:

> | E2 | the sharp constant is `1/\|s−1\| = 1/√(1/4+t²)`, **not** `1/√(2t)` | REFUTED (first draft) | [`../../../rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) §0 R1 |

## Hypotheses and notation

- `s = σ + it`; at `σ = 1/2` the two forms coincide: `1/|s−1| = 1/√(1/4+t²)`.
- The refuted first-draft constant is `1/√(2t)`; the correction identifies the sharp constant as `1/|s−1|`.
- The source of the correction is `rh044/truths.md` §0 R1 (`../rounds/rh044/truths.md` from the dictionary).

## Proof / evidence

The ledger records the status `REFUTED (first draft)`. The row's own statement has two halves: the **refutation** of the first-draft constant `1/√(2t)`, and the **corrected** constant `1/|s−1|`. The corrected constant is stated as a result elsewhere in the ledger: [D9](tpp-dict-00-half-abscissa-parts-asymptotic.md), [P3 of the preliminaries](tpp-dict-01-critical-line-truncation-error.md), and [the sharp error at a zero](tpp-dict-05-sharp-error-at-a-zero.md).

## Dependencies and related results

- [The `σ = 1/2` parts and sharp error](tpp-dict-00-half-abscissa-parts-asymptotic.md) (D9) and [(P3) the critical-line truncation error](tpp-dict-01-critical-line-truncation-error.md).
- [The term-level split fails](tpp-dict-00-term-level-split-fails.md) is a different, numerical failure recorded in this same ledger.

## Notes

- **Read the status carefully:** the ledger's `REFUTED (first draft)` attaches to the first draft's claim that the constant is `1/√(2t)`. The file is harvested as a refutation (that is the honest content of the row's label); the *positive* corrected constant `1/|s−1|` is recorded in [D9](tpp-dict-00-half-abscissa-parts-asymptotic.md) and [P3](tpp-dict-01-critical-line-truncation-error.md).
- The source explicitly marks this as a **correction of an earlier draft**, the recurring "§0 R1" pattern of the round `rh044`.
