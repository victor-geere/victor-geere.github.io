# Sub-sums of a non-negative list: the endpoints `0` and `l.sum` are attained and every sub-sum lies in `[0, l.sum]`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `zero_mem_subSums` (lines 98–101), `sum_mem_subSums` (lines 103–106), `subSums_nonneg` (lines 108–122), `subSums_le_sum` (lines 124–142)

## Statement

> For a list `l` of rationals with all entries `≥ 0`:
>
> - `0 ∈ subSums l` and `l.sum ∈ subSums l` (the empty and the full sub-sum are attained);
> - every `x ∈ subSums l` satisfies `0 ≤ x ≤ l.sum`.
>
> Lean statements:
>
> `zero_mem_subSums (l : List ℚ) : 0 ∈ subSums l`
>
> `sum_mem_subSums (l : List ℚ) : l.sum ∈ subSums l`
>
> `subSums_nonneg {l : List ℚ} (h : ∀ a ∈ l, 0 ≤ a) : ∀ x ∈ subSums l, 0 ≤ x`
>
> `subSums_le_sum {l : List ℚ} (h : ∀ a ∈ l, 0 ≤ a) : ∀ x ∈ subSums l, x ≤ l.sum`

## Hypotheses and notation

- `subSums : List ℚ → Finset ℚ` is the set of sub-sums of a list of rationals, defined by `subSums [] = {0}` and `subSums (a :: t) = subSums t ∪ (subSums t).image (fun x => a + x)`.
- The non-negativity hypothesis `∀ a ∈ l, 0 ≤ a` is needed for `subSums_nonneg` and `subSums_le_sum`; the two membership statements hold for any list of rationals.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` by the four `theorem`s named above, all by induction on the list using the recursion `subSums (a :: t) = subSums t ∪ (a + subSums t)`. The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Definitional companion: `subSums_cons` and `mem_subSums_cons` (the recursion `S = S' ∪ (a + S')`), which are definitional unfoldings and are not harvested separately.
- Used by the finite gap lemma [`lean-rh42-reachable-finite-gap-lemma.md`](lean-rh42-reachable-finite-gap-lemma.md) and by the doubling step [`lean-rh42-reachable-doubling-step-disjoint.md`](lean-rh42-reachable-doubling-step-disjoint.md).
- The rh42 Lean README lists the rows "`0` and the total are sub-sums" ↔ `zero_mem_subSums`, `sum_mem_subSums` and "sub-sums lie in `[0, sum]`" ↔ `subSums_nonneg`, `subSums_le_sum`.

## Notes

- The two README rows describe one coherent statement — the sub-sum set of a non-negative list is contained in `[0, l.sum]` with both endpoints attained — and are folded into this one file.
