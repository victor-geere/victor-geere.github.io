# The counting formula (the clean unconditional core)

**Kind:** Theorem
**Status:** VERIFIED (numerical, twice; exact form to `1e−20`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) — "The instrument — and the correct form of the formula"

## Statement

> The clean unconditional core, verified twice in this round, is the **counting
> formula** `N(T) = θ(T)/π + 1 + S(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)` with
> `S(T) = (1/π)arg ζ(1/2+iT)`; residuals fall like `1/T` (main agent:
> `3.32·10⁻⁴, 1.33·10⁻⁴, 6.63·10⁻⁵, 3.32·10⁻⁵, 2.21·10⁻⁵` at `T = 20…300`; auditor:
> exact form to `1e−20`, plus an independent `ζ'/ζ` argument-principle count).

## Hypotheses and notation

- `N(T)` is the zero count; `θ` is the Riemann–Siegel theta function; `S(T) = (1/π)arg ζ(1/2+iT)` on the continuous branch.
- Residuals are measured at `T = 20, 50, 100, 200, 300`; the source says they "fall like `1/T`".
- The independent count is by argument-principle integration of `ζ'/ζ`.

## Proof / evidence

- **VERIFIED twice** in the round: the main agent's residuals `3.32·10⁻⁴, 1.33·10⁻⁴, 6.63·10⁻⁵, 3.32·10⁻⁵, 2.21·10⁻⁵` at `T = 20…300`, and the auditor's exact form to `1e−20` plus an independent `ζ'/ζ` argument-principle count.
- The source gives no proof; the identity is the classical Riemann–von Mangoldt count used as the round's instrument.

## Dependencies and related results

- [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md) — the ledger's statement of the same result.
- [The per-zero count (Riemann–von Mangoldt)](tpp-rh45-handoff-riemann-von-mangoldt-count.md).
- [The zeros (T2)](tpp-rh45-truths-first-zeros-32-digits.md).

## Notes

- The README states this as the round's "clean unconditional core", in contrast to the draft's wrong normalization of the explicit formula.
- The source's numeric residuals are quoted exactly as printed (middle-dot form), unlike the ledger's `e`-notation for the same sequence; the values agree.
