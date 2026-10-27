# Brown's criterion, sufficiency step: if `S ⊇ [0,T]` and `0 ≤ a ≤ T` then `S ∪ (a + S) ⊇ [0, a+T]`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `Icc_subset_union_shift` (lines 38–45) and the identical restatement `greedy_step_optimal` (lines 248–251)

## Statement

> **Sufficiency step.** If a set `S` already contains `[0,T]`, and `0 ≤ a ≤ T`, then `S ∪ (a + S)` contains `[0, a+T]`: the lower piece is there by hypothesis and the upper piece is its shift. This is the induction step of the completeness half of Brown's criterion (in `reachable.py` the set `S` is the sub-sum set of the tail, `T = T`<sub>`n+1`</sub> and `a = a`<sub>`n`</sub>).
>
> Lean statement (`Icc_subset_union_shift`):
>
> `{S : Set ℝ} {a T : ℝ} (hS : Set.Icc 0 T ⊆ S) (ha : 0 ≤ a) (haT : a ≤ T) : Set.Icc 0 (a + T) ⊆ S ∪ (fun x => a + x) '' S`
>
> The source repeats the same statement under the name `greedy_step_optimal`, with the reading: if the tail's sub-sums already fill `[0,T]` and `0 ≤ a ≤ T`, then on a target `x ≤ a + T` the greedy's choice between "take `a`" and "skip `a`" loses nothing: every `x ∈ [0, a+T]` lies in `S` or in `a + S`. This is the reason the greedy is optimal for the `p`-series, where every tail from `n_min` on is complete.

## Hypotheses and notation

- `S ⊆ ℝ` is a set of reals; `a, T ∈ ℝ`.
- `Set.Icc 0 T` is the closed interval `[0,T]`, and `(fun x => a + x) '' S` is the shift `a + S`.
- Hypotheses: `S ⊇ [0,T]` (`hS`), `0 ≤ a` (`ha`), `a ≤ T` (`haT`).
- `n_min` is the rh42 rounding index; `reachable.py` is the numerical ground-truth script of the round.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean`. `Icc_subset_union_shift` splits a point `x ∈ [0, a+T]` on `x ≤ T` or `x > T`; in the first case `x` is in `S` by `hS`, in the second `x - a ∈ [0,T] ⊆ S` and `x = a + (x - a)`. `greedy_step_optimal` has the same type and its proof is exactly `Icc_subset_union_shift hS ha haT`, so it adds no statement of its own.

The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Brown's completeness criterion as quoted in the file header: for `a`<sub>`1`</sub>` ≥ a`<sub>`2`</sub>` ≥ … > 0`, `T`<sub>`n`</sub>` = Σ`<sub>`k ≥ n`</sub>` a`<sub>`k`</sub>, `A = T`<sub>`1`</sub>, the sub-sums fill `[0, A]` iff `a`<sub>`n`</sub>` ≤ T`<sub>`n+1`</sub> for every `n`; this declaration is the induction step of the sufficiency half.
- The necessity step is [`lean-rh42-reachable-brown-necessity-step.md`](lean-rh42-reachable-brown-necessity-step.md); the interval identity behind both is [`lean-rh42-reachable-interval-merge.md`](lean-rh42-reachable-interval-merge.md).
- The rh42 Lean README lists this row as "Theorem 6, sufficiency step" ↔ `Icc_subset_union_shift`, `greedy_step_optimal`.

## Notes

- `Icc_subset_union_shift` and `greedy_step_optimal` have literally the same type; the second is a named restatement, so both are folded into this one file.
- The statement is about an abstract set `S`; its application to the `p`-series is through the sub-sum sets built later in the same file.
