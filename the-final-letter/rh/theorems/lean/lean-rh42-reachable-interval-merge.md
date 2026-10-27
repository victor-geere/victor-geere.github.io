# The interval merge behind Brown's criterion: `[0,T] ∪ [a, a+T] = [0, a+T]` for `0 ≤ a ≤ T`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `Icc_union_Icc_shift` (lines 62–73)

## Statement

> The interval merge behind both lemmas: `[0,T] ∪ [a, a+T] = [0, a+T]` when `0 ≤ a ≤ T`.
>
> Lean statement (`Icc_union_Icc_shift`):
>
> `{a T : ℝ} (ha : 0 ≤ a) (haT : a ≤ T) : Set.Icc 0 T ∪ Set.Icc a (a + T) = Set.Icc 0 (a + T)`

## Hypotheses and notation

- `a, T ∈ ℝ`; `Set.Icc x y` is the closed interval `[x,y]`.
- Hypotheses: `0 ≤ a` (`ha`) and `a ≤ T` (`haT`), i.e. the shifted interval `[a, a+T]` overlaps or meets `[0,T]`.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` as the `theorem` `Icc_union_Icc_shift`, by extensionality and a case split on `x ≤ T`. The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Called "the interval merge behind both lemmas" by the source; the two lemmas are [`lean-rh42-reachable-brown-sufficiency-step.md`](lean-rh42-reachable-brown-sufficiency-step.md) and [`lean-rh42-reachable-brown-necessity-step.md`](lean-rh42-reachable-brown-necessity-step.md).
- The rh42 Lean README lists this row as "the interval merge" ↔ `Icc_union_Icc_shift`.

## Notes

- The source states this as a supporting identity for the two one-step lemmas of Brown's criterion; it is recorded separately because it is a separate `theorem`.
