# The vector is ∑<sub>n≤N</sub> n<sup>−1/2+iγ</sup>, the zeta partial sum on the critical line

**Kind:** Claim
**Status:** VERIFIED (numerical; overlap 0.99495, fitted exponent walks to 0.500; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh36.html`](../../html/rh36.html) — §4 "The vector", boxed

## Statement

> Every coefficient has the same sign, the mass sits at the shallow end of the ladder — gears 1 to 4 carry 0.517 of it where an even spread would give 0.167 — and the overlap with n<sup>−1/2</sup> is **0.99495**. Fitting the exponent instead of assuming it gives 0.455 at twenty-four gears and 0.500 at sixty-four; the overlap never leaves 0.9921 anywhere from four gears to eighty. The truncated zeta scores 0.29899 against a floor of 0.29390 — the exact minimiser beats it by 1.7% and never by more than 6.4% at any length tried.

> The vector is **∑<sub>n≤N</sub> n<sup>−1/2+iγ</sup>**, the zeta partial sum on the critical line. Every floor rh32 through rh35 measured is its weighted mean square over the zeros, divided by the harmonic number H<sub>N</sub>.

## Hypotheses and notation

- G's quadratic form is ∑<sub>γ</sub> ĥ(γ)² ∣∑<sub>n</sub> c<sub>n</sub> n<sup>iγ</sup>∣², so a unit vector c is a Dirichlet polynomial's coefficient list and its Rayleigh quotient is that polynomial's weighted mean square over the zeros.
- H<sub>N</sub> is the harmonic number; n<sup>−1/2</sup> is the reference profile.
- The fit is over gears 4 to 80; the exponent is fitted, not assumed.

## Proof / evidence

Numerical: overlap with n<sup>−1/2</sup> is 0.99495; fitted exponents 0.455 at N = 24 and 0.500 at N = 64; overlap never below 0.9921 from four to eighty gears; the truncated zeta scores 0.29899 against the floor 0.29390 (1.7% above, never more than 6.4% at any length tried). All coefficients share one sign and gears 1–4 carry 0.517 of the mass.

## Dependencies and related results

- [rh35-quadrature-lemma-refuted-on-g](../rh35/rh35-quadrature-lemma-refuted-on-g.md) — the search whose optimum this vector explains (the whole budget went to log 2).
- [rh36-mean-square-via-reweighting](rh36-mean-square-via-reweighting.md) — the instrument used to sweep.
- [rh36-collapse-forced-suppression](rh36-collapse-forced-suppression.md) — the consequence of the naming.
- [rh39-the-minimiser-suppresses-atoms](../rh39/rh39-the-minimiser-suppresses-atoms.md) — rh39 runs the same vector method on the arc's own lattice and finds the opposite structure.

## Notes


- The naming is stated in a box as the section's result; the source calls it the first document in the line that explains rather than measures.
- The zeta partial sum is truncated at the ladder length N and read at the zeros of zeta; the statement is numerical, not a proof about ζ.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
