# the helix `(cos 2πθ, sin 2πθ, θ)`; the word cannot see turns

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. B — the greedy harmonic sine", row B8, line 57

## Statement

The ledger row, verbatim:

> | B8 | the helix `(cos 2πθ, sin 2πθ, θ)`; the word cannot see turns | THEOREM | rh42 §5.7 |

## Hypotheses and notation

- The **helix** is the curve `θ ↦ (cos 2πθ, sin 2πθ, θ)`.
- "The word" is the greedy word (ledger row B1, a **DEFINITION**, not harvested).
- "Cannot see turns" means the rule's output does not depend on the turn count of the helix; it depends on the **height** `sin(2πθ)` (ledger row B5).

## Proof / evidence

The ledger records `THEOREM` with source `rh42 §5.7` and gives no proof. The round's companion statement is harvested as [Theorem 16 (T16)](tpp-rh42-truths-theorem-16-helix-height.md) (PROVED (paper argument; VERIFIED at 200 dps)); the refuted opposite claim is [R6 (refuted) — "the word sees the turns"](tpp-rh42-truths-r6-word-sees-turns.md).

## Dependencies and related results

- [The word factors through the height `sin(2πθ)`](tpp-dict-00-word-factors-through-height.md) (B5) — the same fact stated as a functional dependence.
- [The support is Sylvester-sparse](tpp-dict-00-sylvester-sparse-support.md) (B7).

## Notes

- Ledger entry restating round **rh42** (§5.7; the round's §8 is headed "the word sees the height, never the turn count").
- The source records the height-preserving reflection as `θ ↦ 1/2 − θ`, **not** `θ ↦ 1 − θ` (which flips the sign).
