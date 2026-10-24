# The sum of two ±1 values is nonzero (refuted)

**Kind:** Theorem
**Status:** REFUTED (counterexample x = 1, y = −1: 1 + (−1) = 0; every asserting declaration fails to elaborate)
**Area:** twin-prime-parity
**Source:** folded across twelve `Check*` files — [`Check18.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check18.lean) lines 6–9 · [`Check19.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check19.lean) lines 5–12 · [`Check20.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check20.lean) lines 5–8 · [`Check21.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check21.lean) lines 5–7 · [`Check23.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check23.lean) lines 5–11 · [`Check25.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check25.lean) lines 5–18 · [`Check26.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check26.lean) lines 5–8 · [`Check27.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check27.lean) lines 5–20 · [`Check28.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check28.lean) lines 5–12 · [`Check29.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check29.lean) lines 5–14 · [`Check33.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check33.lean) lines 10–16 · [`Check35.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check35.lean) lines 5–8 — declarations `Rh46.sign_add_ne_zero`, `Rh46.sign_add_ne_zero2`, `Rh46.sign_add_ne_zero_test`

## Statement

Canonical form (`Check19.lean`, lines 5–6):

> `theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :`
> `    x + y ≠ 0`

The variants carrying the same assertion are

> `theorem sign_add_ne_zero_test {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :`
> `    x + y ≠ 0` — `Check18.lean` lines 6–7

> `theorem sign_add_ne_zero2 {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :`
> `    x + y ≠ 0` — `Check23.lean` lines 9–10, `Check25.lean` lines 14–15

> `theorem sign_add_ne_zero {u v : ℤ} (hu : u ^ 2 = 1) (hv : v ^ 2 = 1) : u + v ≠ 0` — `Check35.lean` lines 5–6 (square form of the same hypothesis).

Claim: any two integer signs — two integers each equal to `1` or `-1`, equivalently two solutions of `x² = 1` — have nonzero sum.

## Hypotheses and notation

- `x, y : ℤ`; hypotheses `hx : x = 1 ∨ x = -1`, `hy : y = 1 ∨ y = -1`, i.e. `x, y ∈ {1, −1}`.
- `Check35.lean` states the same hypothesis class in square form: `hu : u ^ 2 = 1`, `hv : v ^ 2 = 1`, and concludes `u + v ≠ 0`.
- Conclusion: `x + y ≠ 0` (respectively `u + v ≠ 0`).

## Proof / evidence

- **The statement is false.** Take `x = 1`, `y = -1`: then `hx : x = 1` and `hy : y = -1` both hold, yet `x + y = 1 + (-1) = 0`. In the square form, `u = 1`, `v = -1` gives `u ^ 2 = v ^ 2 = 1` and `u + v = 0`. The sources supply no proof, no citation and no witness for the claim.
- **No asserting declaration yields a complete proof.** All twelve files were re-elaborated with the round's own toolchain (`leanprover/lean4:v4.35.0-rc2` + Mathlib4, `LEAN_PATH` reconstructed from `lake env` in `$HOME/lean/mathlib4`, exactly as `lean/check.sh` does); each exits 1, and each fails on its sign declaration, at the positions below (the few further errors in the same files lie in their `example` blocks and are not listed):
  - `Check18.lean` — `unsolved goals` at 7:17 (`sign_add_ne_zero_test`)
  - `Check19.lean` — `unsolved goals` at 10:2 and 11:2
  - `Check20.lean` — `unsolved goals` at 6:17
  - `Check21.lean` — `unsolved goals` at 6:17
  - `Check23.lean` — `unsolved goals` at 6:17 and at 11:56 (`sign_add_ne_zero2`)
  - `Check25.lean` — `unsolved goals` at 10:20, 11:20 and 18:20 (`sign_add_ne_zero2`)
  - `Check26.lean` — `omega could not prove the goal` at 8:77
  - `Check27.lean` — errors at 17:28, 18:41, 19:34 and 20:8
  - `Check28.lean` — `omega could not prove the goal` at 10:22 and 11:22
  - `Check29.lean` — `unsolved goals` at 11:42 and 13:42
  - `Check33.lean` — `unsolved goals` at 15:2 and 16:2
  - `Check35.lean` — `linarith failed to find a contradiction` at 8:2
  None of the declarations contains a `sorry`, but the proofs are **not** complete: the files do not elaborate and none of them produces a `.olean` (contrast the three `Check*` files that do elaborate: `Check7.olean`, `Check11.olean`, `Check32.olean`).

## Dependencies and related results

- The refutation is the elementary counterexample above; it uses no result of the round.
- The correct sign algebra of the round is certified elsewhere: λ takes the values `±1` ([λ n is 1 or −1 for every n ≥ 1](lean-rh46-chowla-liouville-takes-sign-values.md)) and the product `2λ(a)λ(a+h)` is a nonzero sign ([The logical core, second half: 2λ(a)λ(a+h) is nonzero](lean-rh46-chowla-corrslice-sign-statistic-nonzero.md)). The claim refuted here would be a "two signs cannot cancel" lemma; it is false precisely because they can.
- Related false scratch assertion in the same family: [Two integers with u² = v² = 1 cannot differ (refuted)](lean-rh46-check-two-sq-one-ne-refuted.md) — also refuted by the pair `(1, −1)`.
- House precedent for a false scratch assertion of this round harvested as REFUTED: [Complete multiplicativity of λ, asserted without nonzero hypotheses (refuted)](lean-rh46-scratch-liouville-multiplicativity-refuted.md).

## Notes

- **Folding.** The assertion is iterated across the near-duplicate tactic-probe files `Check18`, `Check19`, `Check20`, `Check21`, `Check23`, `Check25`, `Check26`, `Check27`, `Check28`, `Check29`, `Check33`, `Check35` (all under the prefix `lean-rh46-check`), under the declaration names `sign_add_ne_zero_test` (`Check18`), `sign_add_ne_zero` (all the others) and `sign_add_ne_zero2` (`Check23`, `Check25`). It is harvested **once** here.
- **Status honesty.** The sources label these as `theorem` declarations, so they are recorded — but with status REFUTED, never PROVED: the claim is false and the attempted proofs fail. The harvest must not be read as asserting that two `±1` integers cannot sum to zero.
- No prose title is given in the source; the title above states the content and its falsity, and the Lean names are those listed in the Source line.
- Related unassigned scratch files probe the same error with `example` blocks only (`Check22.lean`, `Check24.lean`, `Check30.lean`, `Check31.lean`, `Check34.lean` assert instances of `(1 : ℤ) + (-1) ≠ 0`); those are `example`s and are outside the harvest.
