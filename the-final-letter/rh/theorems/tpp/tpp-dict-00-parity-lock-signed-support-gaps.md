# parity lock: the signed support has all gaps even `≥ 2`

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. B — the greedy harmonic sine", row B6, line 55

## Statement

The ledger row, verbatim:

> | B6 | parity lock: the signed support has all gaps even `≥ 2` | THEOREM (Lean) | rh42 `Tau.lean` |

## Hypotheses and notation

- "The signed support" is the support of the signed *Tau* alphabet `α_n = (−1)^n/(n+2)^p` under the sign-matched, no-overshoot, never-reuse rule (ledger rows B3 and B4, both **DEFINITION**, not harvested).
- "Gaps even `≥ 2`" means consecutive elements of the support differ by an even integer at least `2`.
- The Lean source is named as rh42 `Tau.lean`.

## Proof / evidence

The ledger records `THEOREM (Lean)` and names `rh42 Tau.lean`. The dictionary gives no proof text. The round's own statement is harvested as [Theorem 14 (parity lock)](tpp-rh42-truths-theorem-14-parity-lock.md), and the capstone chapter records it as [the signed support is parity-locked](tpp-dict-05-parity-locked-signed-support.md).

## Dependencies and related results

- The signed alphabet and the sign-matched rule that produce the support (ledger rows B3, B4 — definitions, not harvested).
- [The helix `(cos 2πθ, sin 2πθ, θ)`; the word cannot see turns](tpp-dict-00-helix-word-cannot-see-turns.md) (B8) and [the word factors through the height](tpp-dict-00-word-factors-through-height.md) (B5) describe the same word geometrically.

## Notes

- Ledger entry restating round **rh42**; the status is quoted exactly (`THEOREM (Lean)`, Lean file `Tau.lean`).
- The dictionary's three-line summary lists this as part of "its structure — budgets, completeness, parity lock — is a structure of *indices*, not of factorisations (C1–C8, F7)".
