# The minimiser suppresses rather than annihilates: centroid exactly (n − 1)/2, 232 times below its own mean

**Kind:** Claim
**Status:** VERIFIED (numerical, three representative points; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh39.html`](../../html/rh39.html) — §4 "The minimiser"

## Statement

> Write the problem as it really is. With M = G/E(0) = ∑<sub>j</sub> p<sub>j</sub> v(x<sub>j</sub>)v(x<sub>j</sub>)*, p<sub>j</sub> = w<sub>j</sub>/‖μ‖ summing to one, the trace is n and the eigenvalues average to 1, so
>
> y = min over unit c of ⟨|p<sub>c</sub>|²⟩<sub>w</sub> / ⟨1⟩<sub>w</sub>,  deg p<sub>c</sub> = n − 1.

> The minimiser is the unit-norm trigonometric polynomial with the smallest weighted mean square over the atoms. Two facts about it, measured at three representative points.

> Its coefficient centroid is **exactly (n − 1)/2** — to nine decimals at every point tested — and it spreads over about half the lattice, participation 15.10, 12.22 and 28.88 out of 31, 31 and 61. There is no shallow-end concentration of the kind rh36 found on the integer ladder; on an equispaced lattice the minimiser is symmetric, as the symmetry of the problem requires.

> The second fact is the useful one. Evaluate |p|² at the eight heaviest atoms of the measure: it sits **232 times** below the polynomial's own weighted mean at the deepest point tested, and below it at every point tested. The minimiser is not spreading its mass evenly and paying the average. It is *hunting the heavy atoms and suppressing them*, and it suppresses far more of them than it has roots to annihilate.

## Hypotheses and notation

- M = G/E(0) = ∑<sub>j</sub> p<sub>j</sub> v(x<sub>j</sub>)v(x<sub>j</sub>)* with p<sub>j</sub> = w<sub>j</sub>/‖μ‖ summing to one; trace n, eigenvalues averaging 1.
- y is the minimised weighted mean square ⟨|p<sub>c</sub>|²⟩<sub>w</sub>/⟨1⟩<sub>w</sub> over unit vectors c whose polynomial has degree n − 1.
- Three representative points; participation ratio out of 31, 31 and 61.

## Proof / evidence

Numerical: coefficient centroid exactly (n − 1)/2 to nine decimals at every point tested; participation 15.10, 12.22, 28.88; |p|² at the eight heaviest atoms sits 232 times below the polynomial's own weighted mean at the deepest point tested and below it at every point tested.

## Dependencies and related results

- [rh36-the-vector-is-the-zeta-partial-sum](../rh36/rh36-the-vector-is-the-zeta-partial-sum.md) — the vector method rh36 ran on the integer ladder, whose shallow-end concentration does not recur here.
- [rh39-annihilator-is-a-genuine-bound](rh39-annihilator-is-a-genuine-bound.md) — the annihilation model this fact refutes as a description.
- [rh37-autocorrelation-decays-where-bounds-assume](../rh37/rh37-autocorrelation-decays-where-bounds-assume.md) — the missing joint-across-lags inequality; §9 (b) says this is the same missing lemma from the other direction.

## Notes


- The source's conclusion is that annihilation is the wrong model and suppression is the mechanism; the vector is named on the arc's own lattice for the first time here.
- The measurements are at three representative points; the source states the facts "measured at three representative points" rather than as general theorems.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
