# The explicit formula as a Lefschetz ledger

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh12.html`](../../html/rh12.html) — §6 "What would render a base: the three constructions"

## Statement

> <b>The ledger.</b> Deninger's proposal reads the explicit formula as a transversal Lefschetz fixed-point formula for a flow: closed orbits at the primes with period log p, the archimedean place as the fixed point at infinity, the zeros as the spectrum of the infinitesimal generator on an H¹ that does not yet exist. The formula itself, of course, exists — it is the arc's equation (1) of rh10 — and re-organized in orbit form it balances on our table to 2×10<sup>−5</sup> … the pole term (+50.5, the H⁰/H² poles at 0 and 1), the archimedean term (−20.4, the place at infinity), and one closed orbit per prime (−29.9 total, period log p, k-fold traversals weighted p<sup>(−k/2)</sup>) balance the spectral side (0.17) to 2×10<sup>−5</sup>.

## Hypotheses and notation

- Orbits are indexed by the primes with period log p, and k-fold traversals weighted p<sup>(−k/2)</sup>.
- The terms: pole +50.5, archimedean −20.4, orbits −29.9 (total), spectral side +0.17.
- The computation is done "for one window"; the closing audit gives the balance as "to 6×10<sup>−4</sup> of h(0)" in one place and "2×10<sup>−5</sup>" in another.

## Proof / evidence

The source states that the re-organised explicit formula "balances on our table to 2×10<sup>−5</sup>" and reports the term-by-term numbers in the figure caption. Its reading: "Every line of the would-be Lefschetz formula is verified arithmetic; only the cohomology it would be *about* is missing."

## Dependencies and related results

- [The Riemann–Weil explicit formula](../rh10/rh10-riemann-weil-explicit-formula.md) — the equation being re-organised.
- [The counting function of the missing curve](rh12-counting-function-of-missing-curve.md) — the other computed shadow of the base.
- rh13 §4 runs the same shape as a Castelnuovo ledger with three window classes.

## Notes


- The source reports two balance figures for the same ledger (2×10<sup>−5</sup> in §6 and the figure caption, 6×10<sup>−4</sup> of h(0) in the closing audit); both are quoted here rather than reconciled.
- The H¹ the ledger would be about does not exist; the source presents the balance as a verification of "every computable consequence" of Deninger's proposal, not of the proposal.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
