# The annihilator bound: violated at zero of the 75 points, but loose (rms log residual 0.2484)

**Kind:** Claim
**Status:** VERIFIED (numerical, a genuine bound at all 75 points; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh39.html`](../../html/rh39.html) — §5 "The annihilator"

## Statement

> That suggests a mechanism with the right variable in it, and it is worth building because it half works.

> A degree-(n − 1) polynomial has n − 1 roots, and the measure is symmetric under x → −x, so p<sub>c</sub> can annihilate at most ⌊(n − 1)/2⌋ **γ-pairs**. Kill the heaviest greedily — put double roots there — and the mass that survives is an explicit upper bound on y. Crucially, the heaviest pair carries exactly 1/N<sub>eff</sub> of the mass *by the definition of N<sub>eff</sub>*, so the bound is a function of x up to the shape of the weight profile.

> Built explicitly and evaluated at all 75 points, it is a genuine bound: **violated at zero of them**. And the mass it kills is x/2 times a shape factor running from 0.500 at the sparsest up to **0.965** at the densest — so N<sub>eff</sub> really is the right normalisation for annihilable mass, and that is where the collapse variable comes from.

> But as a profile it is loose, rms log residual **0.2484**, worse than every candidate in §6 including the trivial ones. §4 says why: annihilation is the wrong model. A polynomial that puts thirty double roots on the thirty heaviest pairs has spent all its freedom on thirty atoms; the true minimiser instead pushes hundreds of atoms two orders of magnitude down without zeroing any of them, and pays less. **The variable is explained; the curve is not.**

## Hypotheses and notation

- A degree-(n − 1) polynomial has n − 1 roots; symmetry under x → −x leaves at most ⌊(n − 1)/2⌋ γ-pairs annihilable.
- The greedy choice puts double roots on the heaviest pairs; the surviving mass is an explicit upper bound on y.
- The heaviest pair carries exactly 1/N<sub>eff</sub> of the mass by the definition of N<sub>eff</sub>; x = n/N<sub>eff</sub>.

## Proof / evidence

Numerical: the bound is violated at none of the 75 points; the mass killed is x/2 times a shape factor from 0.500 (sparsest) to 0.965 (densest); as a profile its rms log residual is 0.2484, worse than every candidate in §6 including the trivial ones (as the source states; the random-matrix candidate in that table scores worse still).

## Dependencies and related results

- [rh39-the-minimiser-suppresses-atoms](rh39-the-minimiser-suppresses-atoms.md) — why annihilation is the wrong model.
- [rh39-profile-one-minus-x](rh39-profile-one-minus-x.md) — the profile comparison in which this scores worst.
- [rh37-autocorrelation-decays-where-bounds-assume](../rh37/rh37-autocorrelation-decays-where-bounds-assume.md) — the same missing lemma reached from two directions (rh39 §9 (b)).

## Notes


- The bound is genuine but loose; the source's summary is "the variable is explained; the curve is not."
- The source's own framing is that it is "worth building because it half works" — the point is the origin of N<sub>eff</sub>, not the bound.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
