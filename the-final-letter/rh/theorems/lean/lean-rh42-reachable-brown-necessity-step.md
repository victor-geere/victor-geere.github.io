# Brown's criterion, necessity step: if `S ⊆ [0,T]` and `a > T` then `(T,a)` is a gap of `S ∪ (a + S)`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `gap_of_subset_Icc` (lines 52–58)

## Statement

> **Necessity step.** If `S ⊆ [0,T]` and `a > T`, then the open interval `(T,a)` meets neither `S` nor its shift by `a`: it is a gap of `S ∪ (a + S)`. (In `reachable.py` this is the gap `(T`<sub>`2`</sub>`, a`<sub>`1`</sub>`)` that opens as soon as `p > p*`.)
>
> Lean statement (`gap_of_subset_Icc`):
>
> `{S : Set ℝ} {a T : ℝ} (hS : S ⊆ Set.Icc 0 T) (ha : T < a) : ∀ x ∈ S ∪ (fun x => a + x) '' S, x ∉ Set.Ioo T a`

## Hypotheses and notation

- `S ⊆ ℝ` is a set of reals; `a, T ∈ ℝ`; `Set.Ioo T a` is the open interval `(T,a)`.
- Hypotheses: `S ⊆ [0,T]` (`hS`) and `T < a` (`ha`).
- `p*` is the rh42 threshold appearing in the source's application note; `reachable.py` is the numerical ground-truth script of the round.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` as the `theorem` `gap_of_subset_Icc`. A point of `S` inside `(T,a)` would violate `S ⊆ [0,T]`; a point `a + y` with `y ∈ S` inside `(T,a)` satisfies `y ≥ 0` by `hS`, contradicting `a + y < a`. The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Companion of [`lean-rh42-reachable-brown-sufficiency-step.md`](lean-rh42-reachable-brown-sufficiency-step.md); the interval identity behind both is [`lean-rh42-reachable-interval-merge.md`](lean-rh42-reachable-interval-merge.md).
- The rh42 Lean README lists this row as "Theorem 6, necessity step" ↔ `gap_of_subset_Icc`.

## Notes

- The source's own docstring says: "The hypothesis `T < a` records the geometric situation; the disjointness itself only needs `S ⊆ [0,T]` and `0 ≤ a`." The Lean statement nevertheless carries `T < a` as its hypothesis, and `T < a` is not used by the proof term (the file disables the unused-variable linter). The statement is quoted here exactly as the source states it.
