# (4) The sinh window — a notch-free window outside the family, with an explicit floor

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) against quadrature to 5.3×10<sup>-10</sup>)
**Area:** rh-html
**Source:** [`rh24.html`](../../html/rh24.html) — §4 "(c) The notch ladder", equation (4)

## Statement

> **Outside the family it is elementary.** Take h(t) = sinh(Δ − |t|) on [−Δ, Δ]. Its transform is
>
> (4) ĥ(r) = 2(cosh Δ − cos rΔ)/(1 + r²) ≥ 2(cosh Δ − 1)/(1 + r²) = 0.0578770/(1 + r²) > 0 for every real r,
>
> verified against quadrature to 5.3×10<sup>-10</sup>. The bound is attained exactly at r = 2πq/Δ, where the triangle hat has its own notches — so the window that is worst for the hat is where this one is merely at its floor. It is admissible for the same reason every window is: the Weil test function is C<sub>h</sub> = h⋆ȟ with Ĉ<sub>h</sub> = |ĥ|² ≥ 0, and h need only be square-integrable with support in [−Δ, Δ]. Over all 1517 zeros not one falls below 10⁻² on the scale-free statistic, where the hat has 50 and the M = 8 optimum 37; its typical weight, 1.723×10<sup>2</sup>, still beats the hat's 1.059×10<sup>2</sup>.

## Hypotheses and notation

- h(t) = sinh(Δ − |t|) on [−Δ, Δ]; Δ = 0.24.
- The transform is ĥ(r) = 2(cosh Δ − cos rΔ)/(1 + r²); the floor is 2(cosh Δ − 1)/(1 + r²) = 0.0578770/(1 + r²).
- Admissibility: the Weil test function C<sub>h</sub> = h⋆ȟ with Ĉ<sub>h</sub> = |ĥ|² ≥ 0; h need only be square-integrable with support in [−Δ, Δ].
- The scale-free statistic is γ⁴|ĥ(γ)|²/C<sub>h</sub>(0).

## Proof / evidence

The inequality cos rΔ ≤ 1 gives the floor, attained exactly at r = 2πq/Δ. The transform is verified against quadrature to 5.3×10<sup>-10</sup>; over all 1517 cached zeros no value falls below 10⁻² on the scale-free statistic.

The source also reports the price, quoted verbatim:

> **The price.** Scored on λ<sub>min</sub> through rh21's zeros-side kernel — validated against the primes side here to 1.2% before use, and conditional on RH as that instrument must be — the sinh window gives 1.939×10<sup>-8</sup> at v = 18 against the hat's 1.577×10<sup>-10</sup> and the M = 8 optimum's 3.787×10<sup>-3</sup>. It beats the triangle hat by 123× and loses to the searched window by 2.0×10<sup>5</sup>×. Uniformly positive and five orders below: removing the notches costs the peaks, which is rh21's barrier trade-off made concrete. Its uniform weight on [0, 2000] is 2.25×10<sup>-14</sup> against rh21's barrier πC(0)/T = 1.57×10<sup>-3</sup> there — notch-free and large are very different goals, and no window in this document is both.

## Dependencies and related results

- M. Krein (1940s) and the Fejér–Riesz lemma — "the factorisation h = g⋆ǧ behind (4)"; Paley–Wiener (1934) for the class of windows; both cited in the source's references.
- rh21's zeros-side kernel and its barrier πC(0)/T.
- The M-family obstruction it sidesteps: [the notch ladder belongs to the basis](rh24-notch-ladder-basis.md).
- This window is the rate-1 member of rh25's hyperbolic-hat family, and its λ<sub>min</sub> loss is re-read in rh25 as "the price of not searching" ([rh25-notch-free-family-searched.md](../rh25/rh25-notch-free-family-searched.md)).

## Notes

- The λ<sub>min</sub> figure 1.939×10<sup>-8</sup> "assumes RH, as rh21's instrument must be"; the transform identity and the floor do not.
- The source's reading of the price — "removing the notches costs the peaks, which is rh21's barrier trade-off made concrete" — is explicitly reinterpreted (corrected) in rh25.
