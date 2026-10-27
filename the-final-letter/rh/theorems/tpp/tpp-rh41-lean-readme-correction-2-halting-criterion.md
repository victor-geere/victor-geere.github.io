# Correction 2 — Theorem 9 as printed is false

**Kind:** Claim
**Status:** REFUTED (Lean counterexamples; the surviving direction and its converse form are PROVED (Lean))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — "Corrections found while formalising", item 2

## Statement

> **Theorem 9 ("halts finitely iff `Σ α_n ≥ x`").** As printed this is false: Theorem 10 row 3 has `Σ α_n = ∞ ≥ x = 1` and never halts, and for `α_n = 2^{-(n+1)}` we have `Σ α_n = 1 = x` while the residual is `2^{-n} > 0` at every finite step. The sound statements, both formalised in `Rh41/Alphabet.lean`, are:
> * if every finite partial sum is `< x` then every index is taken and the residual is never `0` (the process never halts);
> * if the residual reaches `0` at step `N` then `x ≤ Σ_{k<N} α_k`.
> "Termination" is used in `TRUTHS.md` in two different senses (the residual hits `0`; the residual tends to `0`), which is the source of the inconsistency. Concretely, Theorem 11's "terminates exactly" is formalised as `residual = (1/2)^n → 0`, not as finite termination.

## Hypotheses and notation

- `α_n` is a positive alphabet; `x` the target; "the residual reaches `0` at step `N`" is finite termination.
- The two counterexamples:
  - Theorem 10 row 3: `α_n = (n+2)^{−p}` with `1 < p ≤ p*` and `x = 1`, where `Σ α_n = ∞ ≥ x`;
  - `α_n = 2^{-(n+1)}`, `x = 1`, where `Σ α_n = 1 = x` but the residual is `2^{-n} > 0` at every finite step.
- `Σ_{k<N} α_k` is a finite partial sum of the alphabet.

## Proof / evidence

Both counterexamples are computed in the README and both sound statements are formalised in `Rh41/Alphabet.lean`: `taken_all_of_bounded_partial_sums`, `never_halts_of_partial_sums_lt`, `residual_ge_sub_sum` (first bullet) and `le_sum_of_residual_eq_zero` (second bullet), the latter described as "the only true direction of the printed `iff`".

## Dependencies and related results

- [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md) — the refuted printed statement.
- [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md) — supplies the first counterexample.
- [Theorem 11 (dichotomy false)](tpp-rh41-truths-theorem-11-dichotomy-false.md) — supplies the second counterexample and the two-senses-of-termination warning.
- [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md) — cites the printed Theorem 9 in its first sentence.

## Notes

- This correction is the reason [Theorem 9](tpp-rh41-truths-theorem-9-halting-criterion.md) is harvested with status REFUTED although `TRUTHS.md` presents it as PROVED.
- Quoted from the README exactly, including the two senses of "termination".
