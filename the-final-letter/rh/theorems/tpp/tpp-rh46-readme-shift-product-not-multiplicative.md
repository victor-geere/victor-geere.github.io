# §1.5 — `n ↦ λ(n)λ(n+2)` is not multiplicative (no Euler product)

**Kind:** Theorem
**Status:** PROVED (Lean, `Rh46/Chowla.lean`: `shiftProd_not_completely_multiplicative`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) — §1.5 and §5 claim table

## Statement

> An earlier draft of this round asserted an elementary conditional proof via the
> Dirichlet series `Σ λ(n)λ(n+2)n^{−s}` and Perron's formula.  That is **wrong**: the
> shifted product `n ↦ λ(n)λ(n+2)` is **not multiplicative**, so the series has no Euler
> product and the standard `ζ`-based analysis does not apply.  The Lean layer proves a
> concrete non-multiplicativity witness.

The §5 claim table states it as: "`n ↦ λ(n)λ(n+2)` is not multiplicative | **PROVED** (Lean: `shiftProd_not_completely_multiplicative`)".

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` is completely multiplicative; the shifted product `n ↦ λ(n)λ(n+2)` is the object of the round.
- The failed route was an elementary conditional proof of (★) via the Dirichlet series `Σ λ(n)λ(n+2)n^{−s}` and Perron's formula, which requires multiplicativity for an Euler product.

## Proof / evidence

The evidence is the Lean declaration `shiftProd_not_completely_multiplicative` in `lean/Rh46/Chowla.lean` (listed in §4 among the file's contents, and in the §5 claim table). The source describes it as "a concrete non-multiplicativity witness"; no explicit witness pair is printed in this README.

## Dependencies and related results

- Companion of the multiplicativity lemmas `liouville_mul` and `liouville_mul_zero_false` of the same file.
- §1.5 is the round's "recorded correction": "The claim was withdrawn; it is recorded here so it is not re-proposed."
- The same non-multiplicativity is recorded in the dictionary as "F3 no Euler product" and, for the correlation, in the dictionary's "correlation not multiplicative" entry.

## Notes

- The subtraction of the failed Euler-product route is the source's own correction; the statement harvested is the non-multiplicativity itself.
- The source's §4 file row for `chowla_two_point.py` mentions "the no-Euler-product verification" among the script's checks.
