# (8) The notch-free family searched — 4.6755×10<sup>-2</sup> against the spline family's 4.4676×10<sup>-2</sup>

**Kind:** Theorem
**Status:** PROVED (paper argument — the notch margin is a certificate over every real r) with VERIFIED (numerical) search values
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §3 "(a) The notch-free family, searched", equation (8)

## Statement

> **The answer.** At every section size the best provably notch-free window matches or beats the best window of the family rh22–rh24 searched, run through the same two search methods at the same budget:
>
> (8) n = 76 (v = 18): notch-free 4.6755×10<sup>-2</sup> against spline family 4.4676×10<sup>-2</sup> — 1.047×.
>
> rh24 measured the plain sinh window losing a factor 1.95×10⁵ to the searched spline window and read that as the price of removing the notches — "rh21's barrier trade-off made concrete". It was not the price of notch-freeness. It was the price of not searching: the sinh window is a single point of a family with 16 free parameters, and searching that family lands above the best window of the spline family — on the primes side, which is the side the certificates actually spend. The trade rh24 posited is not a trade at all at these support widths.

## Hypotheses and notation

- The notch-free family is [the hyperbolic-hat family](rh25-hyperbolic-hat-transform.md) searched under the constraint a = β⋆β (Fejér–Riesz), so A(r) = |B(e<sup>−irδ</sup>)|² ≥ 0 structurally.
- The notch margin is min<sub>r</sub>A(r) over one period 2π/δ with a Lipschitz gap, "which settles it for every real r. Positive exactly when ĥ = Û<sub>c</sub>A has no real zero."
- Both families are run through both search methods at the same budget; the spline family includes rh24's published optimum.
- The compared values are λ<sub>min</sub> at n = 76 (v = 18).

## Proof / evidence

- The constrained search runs in β and reports certified notch margins (a Lipschitz grid on one period of A, refined until the gap is a fifth of the minimum), so positivity is "structural rather than checked" and "the reported margins are certificates, not grid minima".
- The comparison is guarded, quoted verbatim:

> A comparison between two families is only worth as much as the weaker of the two searches, and this one very nearly went wrong twice. Both families are therefore run through *both* methods at the same budget, and rh24's own published optimum is included in the spline family's corner. It matters: the β-space bundle search beats rh24's cutting plane on the **spline** family too, by 2.443×, taking it from 1.8289×10<sup>-2</sup> to 4.4676×10<sup>-2</sup> at v = 18. So the improvement over rh24 is the parameterisation, not the generator — a second correction to that machinery … What (8) then says is the narrow thing it should say: at the same search, the notch-free constraint costs nothing.

- The census: "Over all 1517 zeros the searched notch-free window starves 0 against the triangle hat's 50 and rh24's searched window's 84, and its typical weight, 8.48×10<sup>5</sup>, beats rh24's searched window's 8.02×10<sup>3</sup>."

## Dependencies and related results

- [The hyperbolic hat (7)](rh25-hyperbolic-hat-transform.md); Fejér–Riesz supplies the constraint; the dictionaries gloss "notch margin".
- [rh24's sinh window](../rh24/rh24-sinh-window.md) and its 1.95×10⁵ loss, re-read here.
- [The power-iteration correction](../rh24/rh24-power-iteration-correction.md) is the first correction to that machinery; this is the second.
- Certified floors of the searched window: [equation (11)](rh25-certified-floors-v18.md).

## Notes

- The source reports a *correction* to rh24's interpretation: "It was not the price of notch-freeness. It was the price of not searching."
- All figures (4.6755×10<sup>-2</sup>, 4.4676×10<sup>-2</sup>, 1.047×, 2.443×, 1.8289×10<sup>-2</sup>) are quoted exactly.
