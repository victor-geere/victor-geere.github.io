# No parity-problem advance

**Kind:** Claim
**Status:** PROVED (paper argument, structural)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) — "What the round does *not* claim"

## Statement

> **No parity-problem advance.**  The explicit formula is *unconditional* and primes
> enter through `Λ(n)` — but that is precisely the object the parity obstruction is
> about: a sieve weight built from `Λ` (or from `μ`, `λ`) cannot separate integers
> with an even number of prime factors from those with an odd number, so the formula
> can locate zeros but cannot manufacture the twin-prime lower bound.  A genuine
> advance there would need a correlation statement such as
> `Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

## Hypotheses and notation

- `Λ` is the von Mangoldt function; `μ` the Möbius function; `λ` the Liouville function.
- The parity obstruction concerns separating integers with an even number of prime factors from those with an odd number by a sieve weight built from `Λ`, `μ` or `λ`.
- A genuine advance would need a correlation statement such as `Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

## Proof / evidence

- The source states this as a paper argument about the parity obstruction; it gives the correlation statement that a genuine advance would require but proves nothing new about it.
- The round's ledger records the same negative conclusion with measured counts; see [Parity problem (T4, negative)](tpp-rh45-truths-no-parity-advance.md).

## Dependencies and related results

- [The instrument — and the correct form of the formula](tpp-rh45-readme-correct-explicit-formula.md).
- [Three structural advantages over the partial-sum route](tpp-rh45-readme-three-structural-advantages.md).
- [Parity problem (T4, negative)](tpp-rh45-truths-no-parity-advance.md) — the ledger's version with the numerical counts (`14688` vs `23835`, `Σ λ(n)λ(n+2) = −940 = −4.7·10^{-4}x`).

## Notes

- The README's first bullet under "What the round does *not* claim" — "No new explicit formula, no improvement of Riemann–Siegel, no zero-free region, no RH progress" — is a scope disclaimer and is not harvested as a theorem; it is quoted here only as context. Only the second bullet (the parity non-advance) is harvested from this section.
- The parity obstruction is stated by the source, not proved in the round; the round records no advance on it.
