# T16 — `w` factors through `sin(2πθ)`; `θ, θ+1, 1/2−θ` share a word, `1−θ` flips it

**Kind:** Claim
**Status:** PROVED (factorisation) + VERIFIED (numerical, 200-dps prefixes above the `1e−100` floor)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T16; §5.7 "The helix and the turn count"

## Statement

> The rule reads one real number, the height `x = sin(2πθ)`. Therefore the word is a function
> of `x` alone, and the *lift* `(cos 2πθ, sin 2πθ, θ)` carries information the word cannot see:
>
> * `θ`, `θ+1` (one more turn) and `1/2 − θ` (the mirror `sin(π − a) = sin a`) give the **same
>   word** — verified at 200 dps for `θ = 0.1, 0.3, 0.42`, comparing only the prefixes whose
>   residuals stay above the `1e−100` precision floor (the word is numerically unstable past
>   that floor because the greedy residual falls doubly exponentially);
> * `1 − θ` gives the **sign-flipped** height `−sin(2πθ)`, hence a different word (odd-index
>   support);
> * the lift itself is not periodic in `θ`: `(cos, sin, θ) ≠ (cos, sin, θ+1)`.
>
> So "the circle forgets the turns" is a statement about the *rule*, not a theorem about the
> helix: the helix remembers, the digit word projects it away.

The ledger row states it as: "`w` factors through `sin(2πθ)`; `θ, θ+1, 1/2−θ` share a word, `1−θ` flips it" — **PROVED** (factorisation) + **VERIFIED**.

## Hypotheses and notation

- `w` is the digit word (`w(x) = δ_0δ_1…`), here for the signed rule with target the signed height `x = sin(2πθ)`.
- `θ` is in **turns** (the helix coordinate), so one turn is `360°`.
- The mirror identity used is `sin(π − a) = sin a`.

## Proof / evidence

> | T16 | `w` factors through `sin(2πθ)`; `θ, θ+1, 1/2−θ` share a word, `1−θ` flips it | **PROVED** (factorisation) + **VERIFIED** | 200-dps prefixes above the `1e−100` floor |

The corresponding verdict row H8 in §4 records the same with its caveat: "the helix keeps the turn count; the digit word does not | **VERIFIED** with a caveat | `w` factors through `x = sin(2πθ)`; `θ`, `θ+1`, `1/2−θ` give the same word (at 200 dps, prefixes above the `1e−100` precision floor), and `1−θ` flips the sign; the *lift* is not periodic."

## Dependencies and related results

- Restates `rh42/truths.md` Theorem 16 (helix height) / "word sees turns" refutation row R6.
- The same fact is used in §2 to justify that the two `θ` conventions ("bench" `θ_bench = πx` versus helix `θ` in turns) "only change which `θ` writes which number".
- Refuted companion (§9): ""the word sees the turns" (§5.7): the word factors through `sin(2πθ)`; the reflection with the same height is `θ ↦ 1/2 − θ`, **not** `θ ↦ 1 − θ` (which flips the sign)."

## Notes

- The `PROVED` part covers the factorisation; the word-agreement claims are `VERIFIED` numerically with the stated precision-floor caveat, which the source flags explicitly.
- The source's own hedging: "the word is numerically unstable past that floor because the greedy residual falls doubly exponentially".
- The caveat word "with a caveat" is H8's; the ledger row T16 omits it but keeps the same evidence.
