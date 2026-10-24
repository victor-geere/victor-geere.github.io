# m₀ certified — (4): the certified floor of the searched window at three section sizes

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — certified Cholesky at 40 digits with a residual norm at 90 digits)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §6 "The certificate, and what the gain buys", equation (4)

## Statement

> (4) m₀ = 1.3894×10<sup>-1</sup> at v = 4.08, 1.3290×10<sup>-2</sup> at v = 12, 3.4696×10<sup>-3</sup> at v = 18 — certified, for a window the arc has never used.
>
> Against the hat on the same route: 6.05×10<sup>4</sup>× at n = 18 and 2.70×10<sup>6</sup>× at n = 51. At n = 76 the comparison cannot be made, and the reason is worth stating rather than hiding. Recombining twenty-nine certified δ-rows into each Δ-row costs radius — 4.6× more than rh19's direct Δ = 0.24 rows, 2.54×10<sup>-10</sup> against its 5.47×10<sup>-11</sup> — and the hat's own λ<sub>min</sub> there is only 1.558×10<sup>-10</sup>, a margin of 0.61× against that radius. So this route certifies nothing for the hat at v = 18. rh19 certified that same section directly at Δ = 0.24, where no recombination is needed; this is a limit of the δ-basis route, not a retraction of rh19. The optimised window on the identical route has a margin of 1.5×10<sup>7</sup>×.

## Hypotheses and notation

- The window is the searched optimum of §5 in the eight-parameter family of equation (1); n = 18, 51, 76 are the three section sizes rh19 certified, at v = 4.08, 12, 18.
- The floor is s − ‖residual‖ − ρ<sub>round</sub> − ρ<sub>D</sub>, with a certified Cholesky at 40 digits with a shift s and a residual norm at 90 digits.
- λ<sub>min</sub> is computed by bisection on the inertia; the section is positive definite in exact arithmetic.
- The trap of §3 is the reason the source says "A float eigenvalue is not a theorem, and §3 is the reason to say so twice."

## Proof / evidence

The certificate lane, quoted verbatim:

> The optimised window therefore goes through rh19's backend α unchanged: a certified Cholesky at 40 digits with a shift s, a residual norm at 90 digits, and a floor s − ‖residual‖ − ρ<sub>round</sub> − ρ<sub>D</sub>. What is new is only where the rows come from. Certified interval rows for E<sub>δ</sub> at δ = 0.03 are built out to v = 18.48 — 617 rows of rigorous archimedean integral and pole, each entry of width below 5.69×10<sup>-13</sup>, minus a comb interval whose radius is rh19's proven certified-float bound applied to the gear mass this document's own stream recorded. Identity (2) then carries them to the composite window, with the entry radius and the aliasing radius both scaling by Σ<sub>d</sub>|w<sub>d</sub>|. The trapezoid aliasing radius at this mesh and this horizon is 5.53×10<sup>-17</sup>.

## Dependencies and related results

- [Identity (2)](rh22-exact-kernel-linear-form.md) carries the certified δ-rows to the composite window.
- [Lemma L1](rh22-lemma-l1-any-window.md) lets the truncation carry over with no re-derivation.
- rh19's backend α, rh19's Δ = 0.24 certified rows, rh21's barrier.
- Related: [The escape radius (5)](rh22-escape-radius.md); [Trap 1](rh22-trap-comb-outran-sieve.md).

## Notes

- The three figures are quoted exactly as the source writes them; the source's own summary card rounds them as "1.389×10⁻¹ at n = 18, 1.329×10⁻² at n = 51, 3.470×10⁻³ at n = 76", the last differing in the final digit from the (4) block.
- The source states plainly that this does **not** move the audit: "It does not move the verdict of §2 by one inch."
