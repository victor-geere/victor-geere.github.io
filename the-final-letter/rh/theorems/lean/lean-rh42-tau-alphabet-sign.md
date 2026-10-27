# The Tau alphabet term `α`<sub>`n`</sub>` = (−1)`<sup>`n`</sup>`/(n+2)`<sup>`p`</sup> is nonnegative exactly at even indices

**Kind:** Lemma
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `tauTerm_pos_of_even` (lines 60–63), `tauTerm_neg_of_odd` (lines 66–69), `tauTerm_nonneg_iff_even` (lines 98–104)

## Statement

> The Tau alphabet term at index `n` and exponent `p` is `α`<sub>`n`</sub>` = tauTerm p n = (−1)`<sup>`n`</sup>` / ((n : ℚ) + 2)`<sup>`p`</sup>. Then:
>
> - at an even index the term is positive: `Even n → 0 < tauTerm p n`;
> - at an odd index the term is negative: `Odd n → tauTerm p n < 0`;
> - the alphabet term is nonnegative exactly at even indices: `0 ≤ tauTerm p n ↔ Even n`.
>
> Lean statements:
>
> `tauTerm_pos_of_even {p n : ℕ} (hn : Even n) : 0 < tauTerm p n`
>
> `tauTerm_neg_of_odd {p n : ℕ} (hn : Odd n) : tauTerm p n < 0`
>
> `tauTerm_nonneg_iff_even (p n : ℕ) : 0 ≤ tauTerm p n ↔ Even n`

## Hypotheses and notation

- `p, n : ℕ` are the exponent (weight) and the index; the alphabet is a signed alphabet on `ℚ`: positive letters sit at the even denominators `2k`, negative letters at the odd denominators `2k + 1`, with `k ≥ 1` (module docstring).
- `tauTerm (p n : ℕ) : ℚ := (-1 : ℚ) ^ n / ((n : ℚ) + 2) ^ p` (definition, not harvested separately).
- No hypothesis on `p` is needed; the statements hold for every `p : ℕ`, including `p = 0`.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` by the three `lemma`s named above. `tauTerm_pos_of_even` rewrites `(-1)^n = 1` by `Even.neg_one_pow` and applies `div_pos`; `tauTerm_neg_of_odd` rewrites `(-1)^n = -1` by `Odd.neg_one_pow` and applies `div_neg_of_neg_of_pos`; `tauTerm_nonneg_iff_even` combines the two with `Nat.not_even_iff_odd`. No `sorry`/`admit`/`axiom`/`native_decide` occurs anywhere in the file (the header says "the signed greedy on `ℚ`: parity lock and even gaps").

## Dependencies and related results

- Uses `Even.neg_one_pow`, `Odd.neg_one_pow`.
- The sign characterisation is the input to the sign invariance [`lean-rh42-tau-sign-invariance.md`](lean-rh42-tau-sign-invariance.md) and the parity lock [`lean-rh42-tau-parity-lock.md`](lean-rh42-tau-parity-lock.md).
- The rh42 Lean README lists this row as "even terms are positive, odd terms negative" ↔ `tauTerm_pos_of_even`, `tauTerm_neg_of_odd`, `tauTerm_nonneg_iff_even`.

## Notes

- The term is nonnegative at even indices (indeed positive there) and negative at odd indices; the source proves the `iff` form as well as the two one-sided statements, and all three are folded into this file.
- The size bounds `tauTerm_le_one_of_even`, `tauTerm_le_one_of_odd` and `tauTerm_le_one` (`tauTerm p n ≤ 1`, with the docstring noting `|α`<sub>`n`</sub>`| ≤ 1/2` since `n + 2 ≥ 2`) are stated in the same file but are elementary arithmetic bounds on the alphabet term and are not harvested separately; they are not needed to state the sign characterisation above.
