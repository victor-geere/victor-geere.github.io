# Correction 3 — Theorem 10 row 3 needs an extra hypothesis

**Kind:** Claim
**Status:** PROVED (Lean, with the added hypothesis)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — "Corrections found while formalising", item 3

## Statement

> **Theorem 10 row 3 needs an extra hypothesis.** "The residual never reaches `0`" is not automatic: it needs "no finite sub-sum of the alphabet equals `x`". `Alphabet.never_halts_of_tendsto_zero` states the theorem with this hypothesis made explicit; for `α_n = (n+2)^{-p}`, `x = 1` it holds by irrationality of the sub-sums (not formalised).

## Hypotheses and notation

- Theorem 10 row 3 is the case `S > 1` (`1 < p ≤ p*`) of [Theorem 10](tpp-rh41-truths-theorem-10-alphabet-structure.md): word `1^{N−1} 0… 1 0… 1 …`, never halts, unbounded gaps.
- The added hypothesis: **no finite sub-sum of the alphabet equals `x`**.
- `α_n = (n+2)^{-p}`, `x = 1`: the README records that the hypothesis holds by irrationality of the sub-sums, and that this fact is not formalised.

## Proof / evidence

The README states the correction and names `Alphabet.never_halts_of_tendsto_zero` as the formalised version with the hypothesis made explicit (in `Rh41/Alphabet.lean`, no `native_decide`).

## Dependencies and related results

- [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md) — the theorem whose third row needs the hypothesis.
- [Correction 2 — Theorem 9 as printed is false](tpp-rh41-lean-readme-correction-2-halting-criterion.md) — the same family of termination issues.

## Notes

- The source's own title for Theorem 10 already says "(structure, corrected)"; this correction records the extra hypothesis that the printed proof of row 3 suppresses.
- The irrationality of the sub-sums for `α_n = (n+2)^{-p}`, `x = 1` is explicitly flagged as not formalised.
