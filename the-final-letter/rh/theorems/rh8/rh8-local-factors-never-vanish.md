# Local factors never vanish

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED over 30 000 sample heights for each of six gears)
**Area:** rh-html
**Source:** [`rh8.html`](../../html/rh8.html) — §3 "Each prime is a circle — and its closures are silent", theorem box at lines 358–361

## Statement

> The Euler factor (1 − <i>p</i><sup>−<i>s</i></sup>)<sup>−1</sup> has <i>poles</i>, never zeros: |1 − <i>p</i><sup>−<i>s</i></sup>| ≥ 1 − <i>p</i><sup>−σ</sup> &gt; 0 on σ = ½, verified over 30 000 sample heights for each of six gears. Hence **no prime, and no finite set of primes, can produce a zero of ζ**. Zeros are irreducibly infinite objects — which is rh5 §3's zero-free smooth limb seen locally instead of asymptotically.

## Hypotheses and notation

- <i>p</i> is a prime; <i>s</i> = σ + <i>it</i>; the Euler factor is (1 − <i>p</i><sup>−<i>s</i></sup>)<sup>−1</sup>, with pole at <i>s</i> = 0 in the exponent's terms (the factor vanishes nowhere).
- The inequality is asserted on the critical line σ = ½: |1 − <i>p</i><sup>−<i>s</i></sup>| ≥ 1 − <i>p</i><sup>−σ</sup> &gt; 0.
- ζ is the Riemann zeta function; "gear <i>p</i>" is the factor <i>p</i><sup>−<i>s</i></sup> of the train.
- "Six gears" are the six prime gears used in the document's computations (2, 3, 5, 7, 11 and one further; the closure combs of §3 are drawn for gears 2, 3, 5, 7, 11).

## Proof / evidence

The source gives the inequality as the argument and reports the numerical verification: "verified over 30 000 sample heights for each of six gears". The section supplies the surrounding computations:

- gear <i>p</i> is periodic in <i>t</i> with period 2π/log <i>p</i>, "verified here to 10<sup>−12</sup>", with closure lattice <i>t</i> ∈ (2π/log <i>p</i>)ℤ: 9.0647 for <i>p</i> = 2, 5.7192 for 3, 3.9044 for 5, 3.2287 for 7;
- over all 138 ordinates and all six gears, the nearest any zero comes to any gear's closure lattice is 0.0117 (the near-miss γ₁₀ = 49.7738 against gear 11);
- at the gauge closure <i>t</i>₁ = 2π/log 2 = 9.0647, |ζ(1 + <i>it</i>₁)| = 1.351055, with the nearest actual zero 5.07 away: "The gear closes; the arithmetic does not."

## Dependencies and related results

- rh5 §3's zero-free smooth limb (the bare cone never closes), here seen locally.
- rh4 §3's gauge closures, at which the presentation degenerates but ζ does not vanish.
- The section's companion computations on the closure combs and the zero ordinates.

## Notes

- The box gives a one-line inequality as proof and a stated numerical verification; the result is a local (single-prime) zero-free statement, not a zero-free region for ζ.
- The claim covers every finite set of primes: a finite Euler product has no zeros, so "zeros are irreducibly infinite objects".
- The figures 30 000, 138, 0.0117, 9.0647 and 1.351055 are quoted exactly as the source writes them.
