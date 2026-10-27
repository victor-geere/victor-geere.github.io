# `realPartial_continuous` — continuity of the real partial sum

**Kind:** Lemma
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table row)

## Statement

> | theorem | statement |
> |---|---|
> | `realPartial_continuous` | `Continuous (fun t => realPartial N t)` |

## Hypotheses and notation

- `realPartial N t = ∑ k ∈ Finset.range N, Real.cos (t * Real.log (k + 1))`.
- The statement is `Continuous (fun t : ℝ => realPartial N t)` for arbitrary `N : ℕ`.

## Proof / evidence

- **PROVED** in Lean: `realPartial_continuous (N : ℕ) : Continuous (fun t : ℝ => realPartial N t)` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean); the file also contains the helper `continuous_cos_mul_log`.

## Dependencies and related results

- This is the continuity input for the intermediate value theorem inside [Existence of a balanced partial sum](tpp-rh43-lean-readme-exists-balanced-partial-sum.md) and for the `N ≥ 3` existence argument in the truths harvest ([Theorem 7](tpp-rh43-truths-existence-every-n.md)).

## Notes

- The source gives this statement inside the Lean README's item-by-item table; it is a lemma of the development rather than a headline result of the round.
