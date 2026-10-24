# Two integers with u² = v² = 1 cannot differ (refuted)

**Kind:** Theorem
**Status:** REFUTED (counterexample u = 1, v = −1: u² = v² = 1 and u − v = 2 ≠ 0; the asserting declaration fails to elaborate)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Check5.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check5.lean) — lines 31–41; declaration `Rh46.two_sq_one_ne`. The same assertion appears as an `example` in [`Check4.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check4.lean) lines 33–40 (docstring at line 32).

## Statement

`Check5.lean`, lines 31–41, verbatim:

> `theorem two_sq_one_ne {u v : ℤ} (h1 : u ^ 2 = 1) (h2 : v ^ 2 = 1) (h : u - v ≠ 0) : False := by`
> `  have h3 : (u - v) * (u + v) = 0 := by nlinarith`
> `  rcases mul_eq_zero.mp h3 with h4 | h4`
> `  · exact h (by linarith)`
> `  · have huv : u = -v := by linarith`
> `    have hv : v ≠ 0 := by`
> `      intro hv0`
> `      rw [hv0] at h2`
> `      norm_num at h2`
> `    rw [huv] at h`
> `    exact h (by ring_nf; omega)`

Equivalently: any two integers whose squares are both `1` are equal (`u² = v² = 1` forces `u = v`).

`Check4.lean` lines 33–40 carry the same assertion as an `example`, under the docstring (line 32)

> `-- Square cancellation: two ±1 integers differing by a nonzero integer differ.`

## Hypotheses and notation

- `u, v : ℤ`; `h1 : u ^ 2 = 1`, `h2 : v ^ 2 = 1`, i.e. `u, v ∈ {1, −1}` (the two integer solutions of `x² = 1`); `h : u - v ≠ 0`.
- The conclusion is `False`, i.e. the three hypotheses are claimed to be jointly contradictory.
- `Check4.lean` states the same fact with the same hypotheses `(u v : ℤ) (h1 : u ^ 2 = 1) (h2 : v ^ 2 = 1) (h : u - v ≠ 0) : False`.

## Proof / evidence

- **The statement is false.** Take `u = 1`, `v = -1`. Then `u ^ 2 = 1 ^ 2 = 1`, `v ^ 2 = (-1) ^ 2 = 1` and `u - v = 1 - (-1) = 2 ≠ 0`, so all three hypotheses hold, while the claimed conclusion `False` does not. Thus `u² = v² = 1` does **not** force `u = v` in `ℤ` (there are two solutions, `1` and `-1`). The sources supply no proof, no citation and no witness for the claim.
- **The asserting proof is not complete.** `Check5.lean` was re-elaborated with the round's own toolchain (`leanprover/lean4:v4.35.0-rc2` + Mathlib4, `LEAN_PATH` reconstructed from `lake env` in `$HOME/lean/mathlib4`, exactly as `lean/check.sh` does); it exits 1, with `omega could not prove the goal` at 41:25 — inside `two_sq_one_ne` (further errors at 14:27 and 24:2 lie in the file's `example` blocks). No `sorry` occurs in the declaration, but the proof does not go through and the file produces no `.olean`. The `example` in `Check4.lean` fails too (`linarith failed to find a contradiction` at 40:4).
- No Lean witness of the negation exists in these files; the refutation is the integer counterexample above.

## Dependencies and related results

- The attempted proof uses Mathlib's `mul_eq_zero`, `nlinarith`, `linarith`, `omega`; none of it is needed once the statement is seen to be false.
- The same failure underlies the sibling claim [The sum of two ±1 values is nonzero (refuted)](lean-rh46-check-sign-add-ne-zero-refuted.md): both are refuted by the pair `(1, −1)`. That file folds the twelve `Check*` files carrying the "sum of two signs" form.
- Correct harvested facts about the `{±1}` values of the round: [λ n is 1 or −1 for every n ≥ 1](lean-rh46-chowla-liouville-takes-sign-values.md), [λ n ^ 2 = 1 at every n (λ is a sign)](lean-rh46-scratch-liouville-square-is-one.md).

## Notes

- **Status honesty.** The source labels this as a `theorem`, so it is recorded — but with status REFUTED, never PROVED. The harvest must not be read as asserting that two integers with `u² = v² = 1` are equal.
- The docstring above the `Check4.lean` copy ("two ±1 integers differing by a nonzero integer differ") does not match the statement it annotates (which concludes `False` from their differing), so the source's own gloss of the claim is not reliable.
- Deliberately not harvested from `Check5.lean`: `theorem sum_ite_indicator2` (lines 6–9), the indicator-sum bookkeeping identity `(∑ n ∈ s, if n = a then g else 0) = g` for `a ∈ s`. The same identity is carried by `Check4.lean` (`sum_ite_indicator` lines 7–10 and `sum_ite_indicator2` lines 12–15), `Check8.lean` (`sum_ite_indicator2` lines 6–9) and, as an `example`, `Check11.lean` (lines 17–20); it is list-index bookkeeping of the correlation layer rather than a result of the round, so it is skipped.
