# Anti-clockwise at every gear: the discrete reversal threshold

**Kind:** Proposition
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §8, subsection "Anti-clockwise at every gear", lines 1590–1622

## Statement

> A marked point is only defined modulo 2π, so how many times the curve winds between gears is a choice, not a fact. Taking each step to be the representative in (0, 2π] gives the unique lift that never turns clockwise; a monotone cubic (Fritsch–Carlson) through it is C<sup>1</sup> and, because every slope is a weighted harmonic mean of positive secants, monotone as well. Sampled at 2001 points its derivative is everywhere positive — slowest 0.396 radians per unit of depth, fastest 8.03, so it is a helix in the sense of never reversing and not in the sense of constant pitch.
>
> ... The true step is π − t log(1+1/n), which is *negative* while the torsion outruns the half-turn — for the first 4 gears at t = γ<sub>1</sub>. The first is not a near miss: its raw step is −6.656 radians, more than a whole turn backwards, so the lift pays two revolutions there and one at each of gears 2, 3 and 4. Five turns in all, every one of them spent before gear 5, and the helix is exact from there on. The discrete threshold is n < 1/(e<sup>π/t</sup>−1) = 4.018, and rh5's continuous reversal radius x* = t/π = 4.499 is its large-t limit — the same phenomenon counted two ways.

The boxed per-gear table:

> gear 1 → 2   true step −6.656 rad   lifted step 5.911 rad   *reverses*
> gear 2 → 3   true step −2.590 rad   lifted step 3.694 rad   *reverses*
> gear 3 → 4   true step −0.925 rad   lifted step 5.358 rad   *reverses*
> gear 4 → 5   true step −0.012 rad   lifted step 6.271 rad   *reverses*
> gear 5 → 6   true step +0.565 rad   lifted step 0.565 rad   forward already
> gear 6 → 7   true step +0.963 rad   lifted step 0.963 rad   forward already

## Hypotheses and notation

- The true step at gear n is π − t log(1+1/n), the alternation's half-turn minus the torsion t log(1+1/n).
- The lift takes each step's representative in (0, 2π]; the interpolant is a monotone cubic (Fritsch–Carlson).
- r = (z+1)<sup>−½</sup> needs no interpolation: it is already smooth and passes through every gear.
- rh5's continuous reversal radius is x* = t/π.

## Proof / evidence

Paper argument for the threshold formula and the interpolation argument; numerical for the sampled derivative (2001 points, everywhere positive, slowest 0.396 and fastest 8.03 radians per unit of depth) and for the per-gear steps. The source also records the pitch limit: "the mean pitch is 0.958 half-turns per gear at 400 gears and 0.999 at 40 000."

## Dependencies and related results

- [rh30-detrended-helix-closure](rh30-detrended-helix-closure.md) — the detrended picture this lift is drawn in.
- rh5 (the continuous reversal radius x* = t/π), rh4 (the gears).

## Notes

- The source's own framing of the trade-off: "What that lift costs is worth stating rather than hiding, because it is exactly rh5's reversal radius arriving from the discrete side."
- The derivative bounds and per-gear steps are measurements at t = γ<sub>1</sub>, the case drawn.
