# The finite gap lemma: if `a` exceeds the sum of the rest, `(t.sum, a)` is a gap of `subSums (a :: t)`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `gap_lemma` (lines 147–155)

## Statement

> **The gap lemma for a finite list.** If `a` exceeds the sum of the remaining terms, then every sub-sum below `a` already avoids `a` and the earlier terms, so it is at most the sum of the rest: the interval `(t.sum, a)` is a gap.
>
> Lean statement (`gap_lemma`):
>
> `{a : ℚ} {t : List ℚ} (h : ∀ b ∈ t, 0 ≤ b) (ha : t.sum < a) : ∀ x ∈ subSums (a :: t), x < a → x ≤ t.sum`

## Hypotheses and notation

- The list is `a :: t` with `a ∈ ℚ` the head and `t : List ℚ` the tail; `subSums` is the sub-sum set (see [`lean-rh42-reachable-sub-sums-endpoints-and-bounds.md`](lean-rh42-reachable-sub-sums-endpoints-and-bounds.md)).
- Hypotheses: every entry of `t` is non-negative (`h`), and the sum of `t` is strictly less than `a` (`ha`, i.e. `t.sum < a`).
- Conclusion: any sub-sum of the whole list that is `< a` is already `≤ t.sum`; equivalently the open interval `(t.sum, a)` contains no sub-sum.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` as the `theorem` `gap_lemma`. A sub-sum of `a :: t` is either a sub-sum of `t` (then `subSums_le_sum` bounds it by `t.sum`) or `a + y` with `y ∈ subSums t` (then `a ≤ a + y` by `subSums_nonneg`, contradicting `< a`). The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Uses [`lean-rh42-reachable-sub-sums-endpoints-and-bounds.md`](lean-rh42-reachable-sub-sums-endpoints-and-bounds.md) (`subSums_nonneg`, `subSums_le_sum`).
- Used in the refutation [`lean-rh42-reachable-single-condition-not-sufficient.md`](lean-rh42-reachable-single-condition-not-sufficient.md).
- The rh42 Lean README lists this row as "the finite gap lemma" ↔ `gap_lemma`.

## Notes

- The declaration is a Lean `theorem`; the source's own name for it is "the finite gap lemma" (Kind is given here by the declaration keyword, not by the title).
- The two helper facts `nonneg_twentieths` and `nonneg_counterexample` in the same file are arithmetic non-negativity checks for the concrete counterexample and are not harvested separately.
