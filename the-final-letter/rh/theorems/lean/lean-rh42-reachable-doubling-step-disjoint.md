# Theorem 10's doubling step: the two pieces of the sub-sum recursion are disjoint when `a` exceeds the sum of the rest

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `subSums_cons_disjoint` (lines 193–202)

## Statement

> **The doubling step of the census theorem.** If every term is non-negative and `a` exceeds the sum of the rest, then the two pieces `subSums t` and `a + subSums t` are disjoint: with `r = n_min - 1` of that shape the sub-sum set of the `p`-series has exactly `2^r` components, each a translate of the first.
>
> Lean statement (`subSums_cons_disjoint`):
>
> `{a : ℚ} {t : List ℚ} (h : ∀ b ∈ t, 0 ≤ b) (ha : t.sum < a) : Disjoint (subSums t) ((subSums t).image (fun x => a + x))`

## Hypotheses and notation

- `t : List ℚ` is the tail, `a ∈ ℚ` the head term; `subSums` is the sub-sum set.
- Hypotheses: all entries of `t` are non-negative (`h`), and `a > t.sum` (`ha`).
- `Disjoint` is the `Finset` disjointness of the two pieces `subSums t` and `a + subSums t`.
- `n_min` is the rounding index of the rh42 `p`-series and `r = n_min - 1` the number of "large" leading terms of that shape (source docstring).

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` as the `theorem` `subSums_cons_disjoint`. If `x` lay in both pieces, then `x = a + y` with `y ∈ subSums t`; `subSums_le_sum` gives `a + y ≤ t.sum` while `subSums_nonneg` gives `y ≥ 0`, contradicting `t.sum < a`. The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Uses [`lean-rh42-reachable-sub-sums-endpoints-and-bounds.md`](lean-rh42-reachable-sub-sums-endpoints-and-bounds.md) (`subSums_nonneg`, `subSums_le_sum`).
- The rh42 Lean README lists this row as "Theorem 10, doubling step" ↔ `subSums_cons_disjoint`.

## Notes

- The formal statement proves the disjointness of the two pieces only; the count "exactly `2^r` components, each a translate of the first" is the source docstring's description of its role in the census theorem, not a separately formalised conclusion of this declaration. It is quoted here without strengthening the Lean statement.
