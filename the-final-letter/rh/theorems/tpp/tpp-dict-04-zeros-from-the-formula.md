# Theorem 5.3 (zeros from the formula, not from the partial sum)

**Kind:** Theorem
**Status:** VERIFIED (numerical; "auditor, independent route")
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §5 "The explicit formula (rh45)", "Theorem 5.3 (zeros from the formula, not from the partial sum)", line 171

## Statement

> **Theorem 5.3 (zeros from the formula, not from the partial sum).**  With `ζ`
> evaluations alone (sign changes of `Z(t)`) the first five zeros are located to
> **32–33 digits**; the sharp partial sum cannot do this at any feasible `N`
> (`|Re S_N(γ₁)| = 0.644, 6.986, 12.539, 36.052` at `N = 10³…10⁶`, growing).

## Hypotheses and notation

- `Z(t)` is the real-valued function whose sign changes locate the zeros (the source uses it without further definition in this chapter).
- `γ₁` denotes the first zero ordinate; `S_N` is the partial sum of §3.
- The sharp-partial-sum values `|Re S_N(γ₁)| = 0.644, 6.986, 12.539, 36.052` are reported at `N = 10³…10⁶` and are described as growing.

## Proof / evidence

The source's status line, verbatim:

> *Status:* NUMERICAL (auditor, independent route).

This is a finite computation only: the first five zeros located to 32–33 digits from `ζ` evaluations, against the failure of the sharp partial sum. No proof is given.

## Dependencies and related results

- [Theorem 4.1 (sharp error at a zero)](tpp-dict-04-sharp-error-at-a-zero.md) — the growth `|S_N| ≈ 0.07070354·√N` that underlies the partial sum's failure here.
- [Theorem 5.1 (Weil form)](tpp-dict-04-weil-form-archimedean-term.md) and [Theorem 5.2 (counting)](tpp-dict-04-zero-counting.md) — the rest of §5.

## Notes

- Ledger entry for the **rh45** round (section headed "(rh45)").
- Numerical-only; the source's parenthetical "(auditor, independent route)" is a note on provenance, reproduced verbatim.
