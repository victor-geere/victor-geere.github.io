# Which half binds

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh26.html`](../../html/rh26.html) — §2 "Which half binds"

## Statement

> This is the part worth having. For the triangle hat the even block binds at all nine section sizes tested, from n = 9 to n = 76, and never narrowly: the odd block is between 2.65× and 34.9× above it. For every one of the four searched windows the two blocks are within 26%, they agree to 0.14% at the deepest section, and *which* one binds alternates with n — the sign pattern over the nine sizes is O O O E E O E O O for the searched M = 16 spline and O E O E E O O O O for the notch-free one.
>
> The practical one is negative and should be said plainly: neither channel can be certified on its own. A certificate that establishes positivity of the cosine block at every n proves nothing, because at some n the sine block is the smaller. The split is a factor, not a reduction.
>
> The other is that the window search — which is told only to maximise λ<sub>min</sub>, and knows nothing about J — drives the two channels together. That is what a minimax optimum looks like when a symmetry splits the space: raising the smaller block is free until it meets the larger one, and after that any further gain must lift both. The hat, which was never optimised, sits where an unoptimised window sits: one channel 2.65× to 34.9× slacker than the other. The searched windows sit at the balance point.

## Hypotheses and notation

- Five windows are carried: the triangle hat, rh25's searched spline optima at M = 8 and M = 16, and rh25's searched notch-free optima at the same two meshes.
- Nine section sizes, n = 9, 18, 40, 76 and the rest of the ladder; "which binds" is recorded as E (even) or O (odd) at each size.
- The channels are the +1 (cosine) and −1 (sine) eigenspaces of J from the Cantoni–Butler split.
- "Binding" means the smaller of λ<sub>min</sub>(P + Q) and λ<sub>min</sub>(P − Q).

## Proof / evidence

The source states these as measurements, not proofs: the block minima are computed at each section size and window, both block minimisers are checked to be genuine Rayleigh minimisers of the whole section, and at one section the split is checked in exact 60-digit arithmetic. The 45-section centrosymmetry check is |JTJ − T| = 0 exactly in floating point.

## Dependencies and related results

- [rh26-half-turn-splits-every-section](rh26-half-turn-splits-every-section.md) — the block-diagonalisation this claim is measured against.
- rh25's searched notch-free and spline optima, and the triangle hat, are the windows compared.

## Notes


- The source draws two consequences and labels only one of them "practical"; both are recorded above verbatim.
- The even block binding "every time" for the hat is over the nine tested sizes only, not all n.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
