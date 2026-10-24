# How the explicit formula bypasses the rh43/rh044 obstruction (T4)

**Kind:** Claim
**Status:** PROVED (paper argument, structural; numerical cost witness from auditor C4.1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §2 "How the explicit formula bypasses the rh43/rh044 obstruction (T4)"

## Statement

| | partial-sum route (rh43/rh044) | explicit formula (rh45) |
|---|---|---|
| instrument | `S_N(1/2+it)`, sharp or smoothed | test function `g`, transform `φ` |
| error | `√N/\|s−1\|` (sharp) or `√N·\|M_φ(s)\|` (smoothed) — **grows** | `e^{−πX}`-type (Gaussian), **decays** |
| where the zeros sit | in the cancellation `ζ − S_N` | in the **poles** `s = 1, 0` (and the archimedean term) |
| primes enter as | nothing (the series is blind to `Λ`) | `Σ Λ(n)/√n [g(log n)+g(−log n)]` |
| cost to resolve `γ₁` | `N ≳ 10^6` and still no sign change within `10^{−3}` (auditor C4.1: `Re S_N(t₁)` = `0.644, 6.986, 12.539, 36.052` at `N = 10^3…10^6`, growing like `0.04√N`) | `O(T)` `ζ`-evaluations; 5 zeros to 32–33 digits (auditor C2) |

> This is the sense in which the explicit formula is the instrument rh43/rh044 were
> missing: it replaces the truncation by a test function and reads the zeros off the
> pole/archimedean structure instead of off a tail.

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum; smoothed variants are `S_N^φ`.
- `M_φ` is the smoothing kernel's `s`-dependent factor, so that `|S_N^φ − ζ|/√N → |M_φ(s)|` (rh044).
- `g` is the test function, `φ` its transform, `Λ` the von Mangoldt function, and `t₁` the imaginary part of the first zero (`γ₁ = 14.134725141734693790457251983562`).
- The cost row is on the auditor's route: `N = 10^3, 10^4, 10^5, 10^6` give `Re S_N(t₁) = 0.644, 6.986, 12.539, 36.052`.

## Proof / evidence

- The comparison is the round's paper argument (T4): the sharp/smoothed partial sum keeps a `√N` error while the explicit-formula test-function route has Gaussian decay and moves the zero information into the poles `s = 1, 0` and the archimedean term.
- The cost column is the auditor's numerical witness C4.1, which also refutes the main agent's estimate (`N ≳ T²` suffices) — see [C4.1 (`N ≳ T²` suffices) is refuted](tpp-rh45-truths-sqrt-n-cost-criterion-refuted.md).
- The `O(T)` cost and the five 32–33-digit zeros are reported by the auditor C2, see [The zeros (T2)](tpp-rh45-truths-first-zeros-32-digits.md).

## Dependencies and related results

- [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md).
- [C4.1 (`N ≳ T²` suffices) is refuted](tpp-rh45-truths-sqrt-n-cost-criterion-refuted.md).
- The rh43/rh044 obstruction is the finite-`N` balance condition at `Re(S) = 1/2`; the source cites `../rh43/truths.md` §7.6 and `../rh044/truths.md`.
- The same contrast is stated in [`README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) (harvested as [Three structural advantages over the partial-sum route](tpp-rh45-readme-three-structural-advantages.md)).

## Notes

- This is a structural comparison, not a new identity: the source explicitly disclaims "no new explicit formula, no improvement of the Riemann–Siegel formula, no new zero-free region, no RH progress."
- The cost figures refute the round's own optimistic estimate; the explicit formula's own cost is `O(T)` `ζ`-evaluations.
- No parity-problem advance follows from the bypass — see [Parity problem (T4, negative)](tpp-rh45-truths-no-parity-advance.md).
