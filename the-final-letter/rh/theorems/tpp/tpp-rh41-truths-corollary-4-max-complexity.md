# Corollary 4

**Kind:** Corollary
**Status:** PROVED (paper argument; Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §1 "The complexity function"

## Statement

> **Corollary 4.** If `N ≥ 2a_m + 2` then `max_L p(L) = a_m + 2`.
>
> (If `N < 2a_m + 2` the plateau is empty and the maximum is smaller: e.g. support `{0,…,199}`, `N = 259` has `max p = 60`.)

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, `span = a_m − a_0`, truncation length `N`, `p(L)` the number of distinct length-`L` factors; `max_L p(L)` is the maximum over `L`.
- The condition `N ≥ 2a_m + 2` is what makes the plateau range of [Corollary 2](tpp-rh41-truths-corollary-2-plateau.md) non-empty.

## Proof / evidence

The source states the corollary without a separate proof; the plateau value `a_m + 2` of Corollary 2 is attained once the plateau range is non-empty.

Machine-checked as `DigitWord.max_complexity`, with the auxiliary general bound `complexity_le_max_add_two` (`p(L) ≤ a_m + 2` for *every* `L`, which is what makes the maximum exactly `a_m + 2`), in `Rh41/DigitWord.lean` (no `sorry`). The exceptional example is `DigitWord.plateau_empty_example`, proved by `native_decide`.

## Dependencies and related results

- [Corollary 2 (plateau)](tpp-rh41-truths-corollary-2-plateau.md) — supplies the attained value `a_m + 2`.
- [The auxiliary general bound `p(L) ≤ a_m + 2`](tpp-rh41-lean-readme-auxiliary-general-bound.md) — the one-sided bound behind the maximum.

## Notes

- The source explicitly warns that for `N < 2a_m + 2` the maximum is **smaller**, and gives support `{0,…,199}`, `N = 259` with `max p = 60` as the example. The maximum is not claimed to be `a_m + 2` in that regime.
