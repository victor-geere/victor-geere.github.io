# Theorem 8 (second half) — the support for x = 1 is exactly {0, 1, 4}

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry; the finite cases use `norm_num`/`interval_cases`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 458–460, declaration `Rh41.Harmonic.taken_one_iff`

## Statement

> **Theorem 8 (second half).** The support for `x = 1` (the `θ = π` case) is exactly `{0,1,4}`.

Formally (Lean 4 / Mathlib):

```lean
theorem taken_one_iff (n : ℕ) : taken n ↔ n = 0 ∨ n = 1 ∨ n = 4
```

where `taken (n : ℕ) : Prop := (1 : ℚ) / (n + 2) ≤ residual 0 1 n` (line 433).

The section header adds: "`1/2 + 1/3 + 1/6 = 1`, so the ones are at steps `0`, `1`, `4`. Note: the support is `{0,1,4}`, and the residual first vanishes only at index `5` (`residual 0 1 4 = 1/6`, `residual 0 1 5 = 0`); the parenthetical 'residual 0 1 3 = 0' in the task statement is off by two."

## Hypotheses and notation

- `x = 1` — the target (the `θ = π` case of the digit word).
- `residual 0 1 n` — the residual after `n` steps starting at index `0` with residual `1`, alphabet `1/(n+2)`.
- `taken n` — the digit at step `n` is `1`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.Harmonic.taken_one_iff` in `Rh41/GreedyResidual.lean` (lines 460–475). The finite cases `n < 5` are closed by `interval_cases` using the explicitly evaluated residuals `residual_one_0 … residual_one_5` (`norm_num` facts: `1, 1/2, 1/6, 1/6, 1/6, 0`) and the lemmas `taken_zero`, `taken_one`, `taken_four`, `not_taken_two`, `not_taken_three`; for `n ≥ 5` the residual is `0` by `residual_eq_zero_of_le`, so no step is taken.

## Dependencies and related results

- [Theorem 8 (first half) — rational termination](lean-rh41-greedyresidual-rational-termination.md) — the general termination statement; `x = 1` is the boundary case that terminates at step `5`.
- [Theorem 10 row 3 (power alphabet)](lean-rh41-alphabet-theorem-10-row-3-power-alphabet.md) — the `p = 1` case requires the hypothesis "no finite sub-sum equals `1`", which fails precisely because `1/2 + 1/3 + 1/6 = 1`.

## Notes

- The explicit rational facts `residual 0 1 0 … residual 0 1 5` and the five Boolean lemmas are the finite evidence for this theorem; they are `norm_num`/`rfl` computations and are not harvested separately.
- This is a correction of the task statement's parenthetical, as the source records: the residual first vanishes at index `5`, not index `3`.
