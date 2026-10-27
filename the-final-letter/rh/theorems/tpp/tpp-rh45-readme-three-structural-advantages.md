# Three structural advantages over the partial-sum route

**Kind:** Claim
**Status:** PROVED (paper argument; cost figures numerical, auditor C4.1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) — "Three structural advantages over the partial-sum route" and "The contrast with rh43/rh044 (T4)"

## Statement

> Three structural advantages over the partial-sum route:
>
> 1. **The zero information sits in the singularities**, not in a tail: the pole at
>    `s = 1` (whose image ruined the sharp partial sum) is *used*, not fought.
> 2. **Both sides converge rapidly**: the zero sum decays like `e^{−γ²/2}` for Gaussian
>    families, and the prime side carries `g(log n)`.
> 3. **It is unconditional and knows about the primes** through `Λ`.

The source's contrast table (`T4`):

| | partial sum (rh43/rh044) | explicit formula (rh45) |
|---|---|---|
| instrument | `S_N(1/2+it)`, sharp or smoothed | test function `g`, transform `φ` |
| error | `√N/\|s−1\|` or `√N·\|M_φ(s)\|` — **grows** | Gaussian-type, **decays** |
| zeros sit in | the cancellation `ζ − S_N` | the poles `s = 1, 0` (and archimedean term) |
| primes | invisible | `Σ Λ(n)/√n[g(log n)+g(−log n)]` |
| cost for `γ₁` | `N = 10^6` gives `\|Re S_N(γ₁)\| = 36.05`, still no sign change within `10^{−3}` | `O(T)` evaluations; 5 zeros to 32–33 digits |

## Hypotheses and notation

- `S_N(1/2+it)` is the sharp partial sum; `g` the test function and `φ` its transform; `γ₁` the first zero's height.
- The zero sum's Gaussian decay is written `e^{−γ²/2}`; the prime side carries `g(log n)`; primes enter through `Λ`.
- The cost row uses `N = 10^6`, `|Re S_N(γ₁)| = 36.05`, tolerance `10^{−3}`, and `O(T)` `ζ`-evaluations giving 5 zeros to 32–33 digits.

## Proof / evidence

- The three advantages and the contrast table are the README's paper argument (its T4 discussion), supported by the auditor's C4.1 cost figures.
- The rounding of zeros and their precision are reported in [The zeros (T2)](tpp-rh45-truths-first-zeros-32-digits.md).

## Dependencies and related results

- [The instrument — and the correct form of the formula](tpp-rh45-readme-correct-explicit-formula.md).
- [How the explicit formula bypasses the rh43/rh044 obstruction (T4)](tpp-rh45-truths-bypasses-sqrt-n-obstruction.md) — the ledger's statement of the same comparison.
- [The smoothed zero count](tpp-rh45-handoff-smoothed-zero-count.md) — the window count computable without prior knowledge of the zeros.
- [The counting formula (the clean unconditional core)](tpp-rh45-readme-counting-formula.md).

## Notes

- This is a structural comparison, not a new identity; the README's "What the round does *not* claim" section disclaims any new explicit formula, improvement of Riemann–Siegel, zero-free region or RH progress.
- The cost figures refute the round's optimistic estimate `N ≳ T²`; see [C4.1 (`N ≳ T²` suffices) is refuted](tpp-rh45-truths-sqrt-n-cost-criterion-refuted.md).
- The README notes there is **no parity-problem advance** from these advantages; see [No parity-problem advance](tpp-rh45-readme-no-parity-advance.md).
