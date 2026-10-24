# Refuted — the main formula for all L

**Kind:** Claim
**Status:** REFUTED (counterexample: support `{0,1}`, `N=2`, `L=1`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for **all** `L`
>
> counterexample: `{0,1}`, `N=2`, `L=1`: formula 2, truth 1.

## Hypotheses and notation

- In the same notation as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `{0,1}` (so `a_0 = 0`, `a_m = 1`, `span = 1`), truncation length `N = 2`, factor length `L = 1`.
- The refuted claim is Theorem 1's formula asserted without its hypothesis `L ≥ max(span, a_m + 1)`.

## Proof / evidence

The counterexample is displayed in the source's own table: `{0,1}`, `N=2`, `L=1` gives formula value `2` but true value `p = 1`. The same counterexample appears in §1 as the proof that the bound `L ≥ max(span, a_m+1)` is necessary.

Machine-checked as `DigitWord.refuted_main_formula_all_L`.

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the corrected statement, with the necessary hypothesis.
- Restates the necessity remark of [Theorem 1](tpp-rh41-truths-theorem-1-complexity-main.md) in the §5 ledger (same round).

## Notes

- This row refutes only the **unrestricted** formula; Theorem 1 with `L ≥ max(span, a_m+1)` is not affected.
