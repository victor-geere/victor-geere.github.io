# The zeros (T2)

**Kind:** Theorem
**Status:** VERIFIED (numerical, 32–33 digits; independent route, no `mp.zetazero`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §5 "The zeros (T2)"

## Statement

> Located from `ζ` evaluations alone (sign changes of the Riemann–Siegel `Z(t)`),
> **without** `mp.zetazero`, to 32–33 digits (auditor C2):
>
> ```
> γ₁ = 14.134725141734693790457251983562
> γ₂ = 21.022039638771554992628479593897
> γ₃ = 25.010857580145688763213790992563
> γ₄ = 30.424876125859513210311897530584
> γ₅ = 32.935061587739189690662368964075
> ```

## Hypotheses and notation

- `γₙ` is the imaginary part of the `n`-th nontrivial zero `ρ = 1/2 + iγₙ`.
- Location proceeds by sign changes of the Riemann–Siegel `Z(t)` (equivalently of `ζ(1/2+it)`) using only `ζ` evaluations; `mp.zetazero` is not used.
- The stated precision is 32–33 digits (auditor C2).

## Proof / evidence

- The source states the table as located by the auditor's independent route, [`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh45/verify/independent_check.py) (auditor C2), from `ζ` evaluations alone.
- The same independent route supplies the `ζ'/ζ` argument-principle count of the counting formula, [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md).
- No proof of the zero values is given beyond the bracketing by sign changes; the digits are the numerical output.

## Dependencies and related results

- [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md).
- [The smoothed zero count](tpp-rh45-handoff-smoothed-zero-count.md) — the window count used to locate zeros without prior knowledge.
- [How the explicit formula bypasses the rh43/rh044 obstruction (T4)](tpp-rh45-truths-bypasses-sqrt-n-obstruction.md) — the cost comparison that cites these five zeros.

## Notes

- The source presents this as the round's T2 target met: zeros located "without prior knowledge" (no `mp.zetazero`), to 32–33 digits.
- The digits are quoted exactly as printed; the source does not give certified interval enclosures for them.
