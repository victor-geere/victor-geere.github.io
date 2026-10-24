# The offset-tuple count equals the bit-string factor count

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, 59 267 cases; Lean-proved for all supports)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §2 "Auxiliary structure"

## Statement

> **Checked.** The offset-tuple count equals the bit-string factor count (59 267 cases, all words of length ≤ 14).

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, truncation length `N`, factor length `L`.
- The offset-tuple count is `p(L)` as defined in the source's Object paragraph: `p(L) = #{ distinct length-L factors of w } = #{ {a − t : t ≤ a ≤ t+L−1} : 0 ≤ t ≤ N−L }`.
- The bit-string factor count is the number of distinct length-`L` factors of the 0/1 word `w(x) = δ_0δ_1…`.

## Proof / evidence

The source's evidence is an exhaustive check over 59 267 cases, covering all words of length ≤ 14.

The round's Lean development proves it for all supports via the explicit bijection `toBit`/`bitFactor`: `DigitWord.complexity_eq_bitComplexity` in `Rh41/DigitWord.lean` (no `native_decide`).

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the law stated for this complexity function.
- [Refuted — `Σ_j |intervals|` counts the factors](tpp-rh41-truths-refuted-interval-count-equals-factors.md) — the overlapping-intervals failure this bijection avoids.

## Notes

- The source labels this only **Checked**; the round's Lean README records the proof for all supports, which is why the status line carries both.
- The count `59 267` and the bound "length ≤ 14" are quoted exactly as printed.
