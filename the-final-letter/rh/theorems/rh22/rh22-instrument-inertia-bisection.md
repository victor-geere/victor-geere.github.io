# The instrument — inertia bisection for every λ<sub>min</sub>, cross-checked in 60-digit arithmetic

**Kind:** Claim
**Status:** VERIFIED (numerical; cross-checked in exact 60-digit decimal arithmetic and by an independent dense exact Cholesky. The method's correctness rests on Sylvester's law of inertia, CITED (literature); evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §3 "Two traps, and the instrument", paragraph "The instrument"

## Statement

> Every λ<sub>min</sub> in this document is computed by bisection on the *inertia*. By Sylvester's law the number of non-positive Durbin pivots of T − σI is the number of eigenvalues at or below σ, whatever their signs; bisecting on that count has no breakdown mode. It costs O(n²) per test and about seventy tests, which is cheaper than the inverse iteration it replaces. Each reported value is then re-derived in exact 60-digit decimal arithmetic — the two agree to 10<sup>−8</sup> relative at every section size, including the one whose λ<sub>min</sub> is 1.558×10<sup>-10</sup> — and positive-definiteness is confirmed independently by a dense exact Cholesky that shares no code with the Durbin recursion. The bottom eigenvector, which the search needs, is found by inverse iteration on T − σI with σ just *below* λ<sub>min</sub>, which makes the shifted matrix positive definite so that a plain Cholesky applies and nothing is ever divided by an indefinite pivot.

## Hypotheses and notation

- T is a Toeplitz section; σ is the bisection shift; T − σI is shifted.
- "Durbin pivots" are the Levinson–Durbin pivots β<sub>k</sub> = det<sub>k</sub>/det<sub>k−1</sub>.
- The classical input is **Sylvester's law of inertia** (source reference: J. J. Sylvester (1852)), used here as a rung of the argument: the count of non-positive Durbin pivots of T − σI equals the count of eigenvalues at or below σ.

## Proof / evidence

The source gives the method and its two independent checks:

- each reported λ<sub>min</sub> is re-derived in exact 60-digit decimal arithmetic, agreeing to 10<sup>−8</sup> relative at every section size;
- positive-definiteness is confirmed by a dense exact Cholesky sharing no code with the Durbin recursion.

Regression anchors, quoted verbatim:

> rh19's certified floor at n = 18 is 2.2962×10<sup>-6</sup> and the exact λ<sub>min</sub> recomputed here is 2.3190×10<sup>-6</sup>; at n = 51 the pair is 4.9371×10<sup>-9</sup> and 4.9897×10<sup>-9</sup>. Both floors sit below their eigenvalue, as a certified lower bound must, and within 2% of it — which is the arc's strongest statement so far that backend α's error accounting is not merely valid but tight.

## Dependencies and related results

- Sylvester's law of inertia (1852) — CITED here as a labelled rung of the argument, not reproved.
- Levinson (1947) / Durbin (1960) — the recursion whose breakdown [Trap 2](rh22-trap-levinson-lie.md) exhibits.
- Replaces the inverse-iteration route of rh19–rh21 for every λ<sub>min</sub> in rh22.

## Notes


- The method is a means, not a mathematical result; it is harvested here because the source states it as the instrument that repairs the two traps and gives it explicit error anchors. Status is stated from the source's own accounting; no stronger claim is made.
- The relative agreement 10<sup>−8</sup> and the O(n²)/seventy-tests cost are quoted exactly.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
