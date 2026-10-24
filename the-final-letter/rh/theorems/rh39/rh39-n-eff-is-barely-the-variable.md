# Inside the regime where the collapse holds, the variable buys only 5.4% over plotting against n

**Kind:** Claim
**Status:** VERIFIED (numerical, equal-count bins over the 75 points; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh39.html`](../../html/rh39.html) — §3 "Is N<sub>eff</sub> the variable?"

## Statement

> rh30 bins in x at fixed edges. Comparing a second variable at the *same* edges is not a comparison, because the two differ by a factor and the bins then hold different points. Score every candidate on the same partition instead: equal-count bins over the 75 points that carry the collapse.

> Three results, and none of them is what the headline suggests.

> n/N<sub>eff</sub> gives a geometric-mean spread of **1.6123**. n/PART gives **exactly the same number**, to twelve decimals: PART/N<sub>eff</sub> never varies enough to reorder the 75 points, so the two are one variable as far as the data can tell. Whatever the collapse establishes, it does not single out N<sub>eff</sub> over the participation ratio.

> And n **by itself** gives **1.6993**. Five per cent worse — 5.40%, to be exact. A deliberately wrong scale, n times the total mass, gives 1.6426, which is *better* than n alone. Inside the regime where the collapse holds, the variable that makes it a collapse is doing almost no work.

> The reason is visible once looked for. x &lt; 0.3 at the widest window would need n &lt; 2.1, and the family starts at n = 4, so the widest window contributes **no points at all** to the collapsed regime. Across the windows that survive, N<sub>eff</sub> spans 4.88×, not 66×. rh30's comparison — against a spread of 1.5×10<sup>7</sup> at fixed n — is computed over the whole family, where most of the range is x &gt; 1 and the curve has already died. What the collapse mainly establishes is the *regime*: there is a threshold, and N<sub>eff</sub> locates it. What happens below the threshold is ordered by n almost as well.

## Hypotheses and notation

- Candidates scored on one equal-count partition of the same 75 points: n/N<sub>eff</sub>, n/PART, n alone, and n times the total mass.
- PART is the participation ratio (∑w)²/∑w²; rh30 records it topping out at 2.363 times N<sub>eff</sub> and running down to 1.989.
- The collapse regime is x &lt; 0.3; the family starts at n = 4.

## Proof / evidence

Numerical, equal-count bins on the 75 points: geometric-mean spread 1.6123 for n/N<sub>eff</sub>, exactly the same figure (to twelve decimals) for n/PART, 1.6993 for n alone (5.40% worse), 1.6426 for n times the total mass. N<sub>eff</sub> spans 4.88× across the surviving windows; the widest window contributes no points to x &lt; 0.3.

## Dependencies and related results

- [rh30-effective-count-set-by-window](../rh30/rh30-effective-count-set-by-window.md) — N<sub>eff</sub>, the variable in question, and rh30's fixed-edge binning.
- [rh39-profile-one-minus-x](rh39-profile-one-minus-x.md) and [rh39-collapse-second-variable](rh39-collapse-second-variable.md) — what the collapse does establish.
- rh30 §10 (a) — "prove the collapse", the direction this deflates.

## Notes


- The source calls this "one honest deflation": a proof of the collapse would be a proof of something weaker than the phrase "collapses onto a single curve" suggests.
- §2's regression is the ground of the section: the five effective counts come back exactly (7.04, 17.30, 95.73, 206.97, 467.27, a range of 66.34×) and all two hundred λ<sub>min</sub>/E(0) agree with rh30's published values to 10<sup>−9</sup> relative.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
