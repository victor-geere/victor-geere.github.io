# Theorem 11 (dichotomy false)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §4 "Alphabets `α_n = (n+2)^{−p}` and the inverse problem"

## Statement

> **Theorem 11 (dichotomy false).** `α_n = 2^{−(n+1)}`, `x = 1` selects **every** index (max gap 1) and terminates exactly. Hence "bounded gaps OR exact termination, never both" is false.

## Hypotheses and notation

- `α_n = 2^{−(n+1)}` is the geometric alphabet `1/2, 1/4, 1/8, …`; target `x = 1`; `Σ_n α_n = 1`.
- "Selects every index" means the taken set is all of `ℕ`, so its gaps are all `1`.
- "Terminates exactly" is the source's phrase; per the round's Lean README it is formalised as the residual tending to `0` (`residual = (1/2)^n`), **not** as finite termination.
- The refuted dichotomy is the §5 row "bounded gaps OR termination, never both".

## Proof / evidence

The source states the theorem; the round's Lean development proves it in `Rh41/Alphabet.lean`: `expAlpha_residual`, `expAlpha_taken`, `expAlpha_support_univ`, `expAlpha_residual_tendsto_zero`, `expAlpha_bounded_gaps_and_termination` — every index is taken and `residual = (1/2)^n`.

## Dependencies and related results

- [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md) — this alphabet (`Σ α_n = 1 = x`) is one of the counterexamples to the printed criterion.
- [Refuted — "bounded gaps OR termination, never both"](tpp-rh41-truths-refuted-bounded-gaps-or-termination.md) — the §5 ledger row of the same content.
- [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md) — the contrasting `(n+2)^{−p}` structure.

## Notes

- The round's Lean README is explicit that Theorem 11's "terminates exactly" is formalised as `residual = (1/2)^n → 0`, **not** as finite termination; this is the same two-senses-of-termination issue raised for Theorem 9.
- The statement of this theorem is the source's exact wording, including its quotation of the refuted dichotomy.
