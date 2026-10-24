# (2) versus (3) — the obvious closed form is the wrong one; the regrouped form is right to 1.0×10<sup>-17</sup>

**Kind:** Proposition
**Status:** PROVED (paper argument) with VERIFIED (numerical) error measurements against the 40-digit interval kit
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §2 "(b) The certified comb for a smooth window", equations (2)–(3)

## Statement

> **The obvious closed form is the wrong one.** Integrating U<sub>c</sub> ⋆ U<sub>c</sub> directly gives, on 0 ≤ x ≤ δ,
>
> (2) V<sub>c</sub>(x) = [ (x−δ)cosh cx − sinh(cx)/c + sinh(c(2δ−x))/(2c) + x cosh(c(2δ−x))/2 ] / sinh²(cδ),
>
> and every term in that bracket is O(δ) while the bracket itself is O(c²δ³). The identity is exact, so the answer is right and the *evaluation* is not: the four terms cancel by a factor (cδ)⁻² — 1111 at θ = 0.03 — and the division by sinh²(cδ) does not give it back. Measured against the same function in the 40-digit interval kit, (2) is wrong by up to 9.0×10<sup>-15</sup> where the regrouped form
>
> (3) V<sub>c</sub>(x) = [ 2(x−δ)sinh²(cx/2) − T(x) + T(2δ−x)/2 + x sinh²(c(2δ−x)/2) ] / sinh²(cδ), T(u) = (sinh cu − cu)/c,
>
> in which nothing cancels because every surviving term is already O(c²), is right to 1.0×10<sup>-17</sup>. The ratio is 865× at the worst θ, and it is worst at *small* θ — exactly where the family sits closest to the spline family it generalises. This is a trap of the same kind as rh22's two, and it is reported here for the same reason: the wrong version returns a plausible number.

## Hypotheses and notation

- V<sub>c</sub> = U<sub>c</sub> ⋆ U<sub>c</sub> is the generator of C<sub>h</sub> ([equation (1)](rh25-hyperbolic-hat-transform.md)); the formula is on 0 ≤ x ≤ δ.
- θ = cδ; the cancellation factor is (cδ)⁻² = 1111 at θ = 0.03.
- T(u) = (sinh cu − cu)/c.
- The reference is "the same function in the 40-digit interval kit".

## Proof / evidence

The source gives the asymptotic-order argument (all four bracket terms are O(δ) while the bracket is O(c²δ³), so the four terms cancel by (cδ)⁻²), and measures both forms against the 40-digit interval kit: (2) is wrong by up to 9.0×10<sup>-15</sup>, (3) is right to 1.0×10<sup>-17</sup>; the worst-case ratio is 865×.

## Dependencies and related results

- [The hyperbolic hat (7)](rh25-hyperbolic-hat-transform.md) defines the object.
- [The certified table (5)](rh25-certified-table-cost.md) is the alternative evaluation route, and the source prefers it for the two reasons "It touches no library function at all, and it is right."
- Compare rh22's two traps ([Trap 1](../rh22/rh22-trap-comb-outran-sieve.md), [Trap 2](../rh22/rh22-trap-levinson-lie.md)): the source explicitly reports this as "a trap of the same kind as rh22's two".

## Notes

- The two closed forms are **algebraically identical**; the difference is purely numerical. The source is explicit: "The identity is exact, so the answer is right and the *evaluation* is not."
- The figures 1111, 9.0×10<sup>-15</sup>, 1.0×10<sup>-17</sup>, 865× are quoted exactly.
