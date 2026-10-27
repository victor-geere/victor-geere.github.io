# Theorem 16 (T16)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED at 200 dps)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §8 "The helix: the word sees the height, never the turn count"

## Statement

> The rule reads exactly one real number, the height
> `x = sin(2πθ)`. Hence the word is a function of `x` alone:
>
> ```
> θ,  θ+1,  θ+2,  1/2 − θ      give the SAME word,
> 1 − θ                        gives the sign-flipped height, hence the other word,
> the lift (cos 2πθ, sin 2πθ, θ) is not periodic — the word simply cannot see it.
> ```

## Hypotheses and notation

- `θ` is measured in **turns** (helix coordinate), so the target height is `x = sin(2πθ)`; `450°` is not folded back to `90°`.
- The digit word is `w(x) = δ_0δ_1…` produced by the signed/Tau rule of §0.
- "The lift" is the curve `(cos 2πθ, sin 2πθ, θ)` in `ℝ³`, which is not periodic in `θ`.
- "dps" = decimal digits per second (Arb working precision) in the verification.

## Proof / evidence

> **PROVED** (the rule's input is the target; `sin(2π(θ+1)) = sin(2πθ)` and
> `sin(2π(1/2 − θ)) = sin(2πθ)`, while `sin(2π(1 − θ)) = −sin(2πθ)`), **VERIFIED** at
> 200 dps for `θ = 0.1, 0.3, 0.42, 0.77`, comparing only the prefixes whose residuals
> stay above the `10⁻¹⁰⁰` precision floor.

## Dependencies and related results

- The signed rule of §0 (definition T1) — the rule's input is the target height.
- Handoff ledger row T16 (§11): "`w` factors through `sin(2πθ)`", PROVED+VERIFIED before and after.
- §0's remark that "the digit word depends only on the height — §8 makes this precise — so the conventions only change which `θ` writes which number" is this theorem's context; the rh41 *bench* coordinate is `θ_bench = πx` while the *helix* coordinate is `θ` in turns.

## Notes

- The consequences the source draws, quoted verbatim: "(a) `cos` spends the same two budgets, and at 45° (`θ = 1/8`) `sin = cos` so the two words coincide; at 270° `sin = −1`, `cos = 0` (the empty word). (b) No rule that reads a *periodic* function of `θ` — in particular not `θ mod 1` — can see the turn count; to see it the rule must be fed a non-periodic function of `θ`, which is the honest statement of the handoff's §5.7."
- The fixtures the source records: "`sin(π/4) = 1/2 + 1/5 + 1/141 + 1/68575` (tail `3.1·10⁻¹¹`, support `{0, 3, 139, 68573}`), `x = 1 ↔ {0,1,4}`, and the `p = 2` unreachable rational `1/5` of Theorem 12 are the fixed test points; all three reproduce."
- The verification compares "only the prefixes whose residuals stay above the `10⁻¹⁰⁰` precision floor" — a genuine limitation of the numerical check, recorded here as the source states it.
