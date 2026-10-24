# |λ n| ≤ 1 for every n

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `liouville_abs_le_one`, lines 189–193

## Statement

> `theorem liouville_abs_le_one (n : ℕ) : |liouville n| ≤ 1`

The file's docstring states it as: "`|λ n| ≤ 1` for every `n`."

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ`, `Omega n = ArithmeticFunction.cardFactors n`; `|·|` is the integer absolute value.
- No hypothesis on `n`.

## Proof / evidence

Lean declaration `liouville_abs_le_one` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 190–193), proved by splitting on `Nat.even_or_odd (Omega n)` and evaluating both cases by `norm_num`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4 lists `liouville_abs_le_one` among the certified results).

## Dependencies and related results

- Uses only Mathlib (`Nat.even_or_odd`).
- It is the per-summand input to [The trivial bound: |corr h N| ≤ N](lean-rh46-chowla-corr-trivial-bound.md) and, via the slice, to the `ℓ²`-computation `corrSliceSqSub`'s companion `slice_abs_le_one` (line 336, not harvested separately).
- The same statement appears in the scratch draft: [|λ n| ≤ 1 for every n](lean-rh46-scratch-liouville-abs-le-one.md).

## Notes

- The declaration is `theorem`, hence Kind Theorem.
- `liouville_ne_zero` (lines 180–181) and `slice_abs_le_one` (lines 336–341) are skipped: the first is an immediate corollary of `liouville_mem`, the second is the slice instance of this same bound.
