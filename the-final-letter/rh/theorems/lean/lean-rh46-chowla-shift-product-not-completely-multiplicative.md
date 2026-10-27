# The Chowla summand n ↦ λ(n)λ(n+2) is not completely multiplicative

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `shiftProd_not_completely_multiplicative`, lines 297–300 (witness `shiftProd_two_five`, lines 281–295)

## Statement

> `theorem shiftProd_not_completely_multiplicative :`
> `    ∃ m n, shiftProd 2 (m * n) ≠ shiftProd 2 m * shiftProd 2 n`

where `shiftProd h n = liouville n * liouville (n + h)` (line 258). The file's docstring
on the concrete witness: "**The summand of Chowla is not multiplicative.** For `f =
shiftProd 2` we have `f 25 = λ 25 λ 27 = -1` while `f 5 * f 5 = (λ 5 λ 7)² = 1`."

## Hypotheses and notation

- `shiftProd h n = λ(n) λ(n + h)`; the theorem is stated for the shift `h = 2`.
- The existential is witnessed by `m = n = 5`.

## Proof / evidence

Lean declaration `shiftProd_not_completely_multiplicative` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 298–300), which is `⟨5, 5, shiftProd_two_five⟩`; the concrete declaration `shiftProd_two_five` (lines 283–295) evaluates `shiftProd 2 (5*5) = λ 25 · λ 27 = 1 · (-1) = -1` against `(shiftProd 2 5)^2 = (λ 5 λ 7)^2 = 1`, using `liouville_twentyfive` (`λ 25 = 1`, line 264) and `liouville_twentyseven` (`λ 27 = -1`, line 273). Both proofs are complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §5 row: "`n ↦ λ(n)λ(n+2)` is not multiplicative | **PROVED** (Lean: `shiftProd_not_completely_multiplicative`)").

## Dependencies and related results

- Uses the sign facts `liouville_sq`, `liouville_twentyfive`, `liouville_twentyseven`.
- The file's companion packaging `arithLiouville_multiplicative` (lines 302–310) contrasts this with Mathlib's completely multiplicative `liouville`; it is skipped here because its content is the conjunction of [The bridge to Mathlib](lean-rh46-chowla-liouville-agrees-with-mathlib.md) and Mathlib's `liouville_apply_mul`.
- README §1.5 records the round's withdrawn claim: an earlier draft asserted a conditional proof via the Dirichlet series `Σ λ(n)λ(n+2)n^{−s}` and Perron's formula; the shifted product's non-multiplicativity removes the Euler product and the claim was withdrawn.
- The README harvest of the same point is [§1.5 — `n ↦ λ(n)λ(n+2)` is not multiplicative (no Euler product)](../tpp/tpp-rh46-readme-shift-product-not-multiplicative.md).

## Notes

- The concrete witness `shiftProd_two_five` and the value lemmas `liouville_twentyfive`/`liouville_twentyseven` are not harvested separately (concrete evaluations); they are quoted here as the evidence.
- The declaration is `theorem`, hence Kind Theorem.
