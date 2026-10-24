# The logical core, second half: 2λ(a)λ(a+h) is nonzero

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `corrSlice_ne_corr_self_statement`, lines 421–432

## Statement

> `theorem corrSlice_ne_corr_self_statement (h a : ℕ) (hh : 0 < h) (ha : 1 ≤ a) :`
> `    (0 : ℤ) < 2 * (liouville a * liouville (a + h)) ∨`
> `      (2 * (liouville a * liouville (a + h)) < 0)`

i.e. the two-point statistic `2 λ(a) λ(a+h)` is nonzero (it is `< 0` or `> 0`).

## Hypotheses and notation

- `λ(a) = (-1)^{Ω(a)}`; the statistic `2 λ(a) λ(a+h)` is the one appearing in the perturbed-correlation identity quoted in the file's comment block (lines 407–419).
- Hypotheses `hh : 0 < h`, `ha : 1 ≤ a`.

## Proof / evidence

Lean declaration `corrSlice_ne_corr_self_statement` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 427–432): `liouville_mem` gives `λ(a), λ(a+h) ∈ {1, −1}`, and the four sign cases are closed by `norm_num`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`).

## Dependencies and related results

- Uses [λ n is 1 or −1 for every n ≥ 1](lean-rh46-chowla-liouville-takes-sign-values.md).
- Related: [The exact perturbation of the correlation by one sign flip](lean-rh46-chowla-corrslice-perturbation-identity.md) (comment-only, `CONJECTURED`), whose right-hand side this statistic belongs to; and [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md).

## Notes

- Fidelity caveat: the declaration's docstring labels it "**The logical core, second half** *(recorded, not proved here)*" and explains that it is meant to supply `corrSlice h a a ≠ corr h a`. The elaborated statement, however, mentions neither `corrSlice` nor `corr`: it asserts only that `2 λ(a) λ(a+h)` is a nonzero sign. No declaration in the file proves `corrSlice h a a ≠ corr h a`; the corresponding conjunct of `corrAsymptotic_reading` (lines 454–455) is the vacuous `corrSlice h a a ≠ corr h a → True`, which is skipped in this harvest.
- The declaration is `theorem`, hence Kind Theorem.
