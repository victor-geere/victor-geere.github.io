# R6 (refuted) — "the word sees the turns"

**Kind:** Claim
**Status:** REFUTED (smallest witness below)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R6

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R6 | "the word sees the turns" | the word factors through `sin(2πθ)`; the height-preserving reflection is `θ ↦ 1/2 − θ`, **not** `θ ↦ 1 − θ` (which flips the sign) |

## Hypotheses and notation

- "The word" is the signed digit word `w(x) = δ_0δ_1…` produced by the rule of §0; "the turns" is the helix coordinate `θ` in turns.
- The word factors through the height `x = sin(2πθ)`: `sin(2π(θ+1)) = sin(2πθ)` and `sin(2π(1/2 − θ)) = sin(2πθ)`, whereas `sin(2π(1 − θ)) = −sin(2πθ)`.
- The lift `(cos 2πθ, sin 2πθ, θ)` is not periodic; the rule cannot see it.

## Proof / evidence

[Theorem 16 (T16)](tpp-rh42-truths-theorem-16-helix-height.md) is the proof: the rule's input is the target height, so `θ`, `θ+1`, `θ+2`, `1/2 − θ` give the same word while `1 − θ` gives the sign-flipped height (hence the other word). The source marks that theorem PROVED + VERIFIED at 200 dps.

## Dependencies and related results

- [Theorem 16 (T16)](tpp-rh42-truths-theorem-16-helix-height.md) — the positive statement whose consequence this row negates.
- §8(b): "No rule that reads a *periodic* function of `θ` — in particular not `θ mod 1` — can see the turn count."

## Notes

- The witness cell is a correction of a detail as well as a refutation: the height-preserving reflection is `θ ↦ 1/2 − θ`, **not** `θ ↦ 1 − θ`; the latter flips the sign of the height (and hence of the word).
