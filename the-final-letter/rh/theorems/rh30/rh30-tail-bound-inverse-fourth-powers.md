# The count alone bounds the tail

**Kind:** Lemma
**Status:** PROVED (paper argument, using Backlund's explicit bound on N(t); checked numerically at six heights)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §6 "The conspiracy bound, which closes", subsection "the count alone bounds the tail", lines 1293–1310

## Statement

> ∑<sub>γ>T</sub> γ<sup>−4</sup> needs no zero-density theorem. Writing it as 4∫<sub>T</sub><sup>∞</sup>(N(t)−N(T)) t<sup>−5</sup>dt and feeding in Backlund's explicit bound on N(t)−θ(t)/π−1 at both ends, the smooth parts reproduce exactly the integral of the Riemann–von Mangoldt density against t<sup>−4</sup>, and Backlund's error survives one order down:
>
> ∑<sub>γ>T</sub> γ<sup>−4</sup> ≤ [ln(T/2π)/3 + 1/9] / (2πT<sup>3</sup>) + (0.56 ln T + 4.07)/T<sup>4</sup>.
>
> At T = 4800 that is 3.36×10<sup>−12</sup>. It is checked against the table at six heights from 300 to 10 000, and it is not slack — the real ordinates fill between 86% and 99% of it. The Backlund term is not decoration either: the smooth density alone is *exceeded* by the real table at T = 500, because N(t) carries a +1 that the density does not.

## Hypotheses and notation

- γ runs over the ordinates of the non-trivial zeros; N(t) is the zero-counting function; θ(t) is the Riemann–Siegel theta function.
- The bound uses no hypothesis on where the zeros are: only the counting function. "needs no zero-density theorem."
- The source notes in §6 that Ingham's N(α,T) would improve the tail from T<sup>−3</sup> to T<sup>−3.727</sup> at σ = 0.4 and buy a further 1.3×10<sup>3</sup> at T = 20 000, "but it is not needed and its constant is not explicit".

## Proof / evidence

Paper argument: write the tail as 4∫<sub>T</sub><sup>∞</sup>(N(t)−N(T))t<sup>−5</sup>dt and insert Backlund's explicit bound at both ends. The right-hand side is checked against the zero table at six heights from 300 to 10 000; the real ordinates fill between 86% and 99% of it. The source records that a bug in the first draft — the smooth density alone being exceeded by the real table at T = 500 — was caught by that check.

## Dependencies and related results

- [rh30-conspiracy-bound](rh30-conspiracy-bound.md) — the immunity result this lemma feeds, together with Gershgorin.
- The companion fact in the same §6 list — "the window's decay is r<sup>−4</sup>, on the whole strip" — is recorded in the statement's Notes below.
- Backlund's explicit bound and the Riemann–von Mangoldt count are cited, not reproved.

## Notes

- The companion fact stated in the same §6 list: ĥ is entire and its envelope falls like r<sup>−2</sup>, so |ĥ|<sup>2</sup> falls like r<sup>−4</sup>; over the entire strip |σ| ≤ ½ the constant sup γ<sup>4</sup>|ĥ(γ+iσ)|<sup>2</sup> is within 0.6% of its value on the line, so "the bound costs essentially nothing for going off the line".
