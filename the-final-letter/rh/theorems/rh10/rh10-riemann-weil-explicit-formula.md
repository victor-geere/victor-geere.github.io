# The Riemann–Weil explicit formula

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §1 "The pairing: Axiom 8 as an instrument", equation (1)

## Statement

> For an even test function *h* with Fourier partner *g*, the Riemann–Weil explicit formula reads
>
> ∑<sub>ρ</sub> *h*(γ<sub>ρ</sub>) = *h*(*i*/2) + *h*(−*i*/2)
> + (1/2π) ∫<sub>−∞</sub><sup>∞</sup> *h*(*r*)[Re&#8202;ψ(¼+*ir*/2) − ln π] d*r*
> − 2 ∑<sub>*n*≥2</sub> (Λ(*n*)/√*n*) *g*(log *n*),
>
> and RH is equivalent to the right-hand side being ≥ 0 whenever *h* = |*f̂*|² — positivity of the arithmetic pairing on all test functions.

## Hypotheses and notation

- *h* is an even test function, *g* its Fourier partner.
- γ<sub>ρ</sub> runs over the imaginary parts of the non-trivial zeros ρ of ζ.
- Λ is the von Mangoldt function, ψ the digamma function, π the circle constant; the prime sum runs over *n* ≥ 2.
- W(*t*₀) denotes the positivity functional read from the arithmetic side alone (primes, prime powers and the Γ-factor).

## Proof / evidence

The source states the formula without proof, as the classical identity behind Axiom 8 (rh4 §15): "Weil's criterion says exactly which pairing." It is not merely quoted: both sides are implemented, and for Gaussian *h* centred at *t*₀ = 20, 35 and γ₁ itself the two sides agree to 3×10<sup>−6</sup> — "the formula is not quoted but *running*".

## Dependencies and related results

- [Weil positivity criterion](rh10-weil-positivity-criterion.md) — the consequence the source extracts from this formula.
- [Beurling–Nyman criterion](rh10-beurling-nyman-criterion.md) and [de Bruijn–Newman threshold](rh10-de-bruijn-newman-threshold.md) — the other criteria read as instruments in the same document.
- The source records that the same arithmetic side is the equation reused in rh13's crossing form and rh14's merged kernel.

## Notes

- Classical literature (Riemann–Weil); the source gives no proof and does not claim one. Status CITED (literature) is used accordingly.
- The source's own numerical certificate (3×10<sup>−6</sup>) is a floating-point agreement of the two sides, not a proof of the identity.
