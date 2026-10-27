# The counting formula (T2/T3, the robust core)

**Kind:** Theorem
**Status:** VERIFIED (numerical, twice; exact form to `1e−20`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §4 "The counting formula (T2/T3, the robust core)"

## Statement

> ```
> N(T) = θ(T)/π + 1 + S(T)                          (exact, θ = Riemann–Siegel theta)
>      = (T/2π) log(T/2πe) + 7/8 + S(T) + O(1/T)    (asymptotic)
> S(T) = (1/π) arg ζ(1/2 + iT)                      (continuous branch)
> ```

The source calls this "the robust core" and "the clean unconditional core".

## Hypotheses and notation

- `N(T)` counts the nontrivial zeros; `θ` is the Riemann–Siegel theta function; `S(T) = (1/π) arg ζ(1/2 + iT)` uses the continuous branch of the argument.
- The asymptotic form carries the constant `7/8` and error `O(1/T)`.

## Proof / evidence

- **VERIFIED twice**:
  - the exact form to `1e−20` for `T = 20, 50, 100` (auditor, independent `S(T)` along `2 → 2+iT → 1/2+iT`);
  - the asymptotic residuals `3.32e−4, 1.33e−4, 6.63e−5, 3.32e−5, 2.21e−5` at `T = 20, 50, 100, 200, 300` (main agent).
- The count itself is independently confirmed by an argument-principle integration of `ζ'/ζ` (auditor C3: **29** zeros below `T = 100`).
- The source states the formula without a proof; it is the classical Riemann–von Mangoldt counting formula used as the round's instrument.

## Dependencies and related results

- [The per-zero count (Riemann–von Mangoldt)](tpp-rh45-handoff-riemann-von-mangoldt-count.md) — the same instrument as stated in the round's HANDOFF.
- [The smoothed zero count](tpp-rh45-handoff-smoothed-zero-count.md).
- [The zeros (T2)](tpp-rh45-truths-first-zeros-32-digits.md) — the zeros located from `ζ` evaluations alone.
- [The counting formula (the clean unconditional core)](tpp-rh45-readme-counting-formula.md) — the README's statement of the same result.

## Notes

- §3 of the source records that the check `C3.rvm.asymptotic` was scored as a failure only because its relative-`1e−6` criterion was **too crude**: "the exact form `N(T) = θ(T)/π + 1 + S(T)` holds to 1e−20; the asymptotic residual is `≈ 1/(48πT)` with a further `−7/(120T²)` correction, which the check's relative-`1e−6` criterion mis-scored". The criterion correction is not a separate harvested theorem; the residual asymptotics are quoted here as the source records them.
- The source's ledger lists this formula under T2/T3 and reports the count as confirmed by the independent `ζ'/ζ` argument-principle route.
