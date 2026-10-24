# Trap 2 — the Levinson lie: inverse iteration calls an indefinite section positive

**Kind:** Claim
**Status:** VERIFIED (numerical) — the failure of the method is exhibited, not a theorem (evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §3 "Two traps, and the instrument", paragraph "Trap 2 · the Levinson lie"

## Statement

> That would have been caught immediately if λ<sub>min</sub> had been computed honestly. rh19–rh21 computed it by inverse iteration through the Levinson–Durbin recursion, which is fast and exact-enough on a positive-definite Toeplitz row. On an *indefinite* one it divides by β<sub>k</sub> = det<sub>k</sub>/det<sub>k−1</sub>, which has changed sign, and what comes out has no relation to the spectrum. Here it comes out **positive**, at 7.114×10<sup>-9</sup> — for a matrix whose smallest eigenvalue is -1.8681. And it is worse than a wrong number: 7.114×10<sup>-9</sup> is within 43% of the *correct* section's 4.990×10<sup>-9</sup>, so it survives every order-of-magnitude sanity check a reader would apply. It is not the first time in this arc that a float lane has been caught lying about an indefinite section. It is the first time the lie was plausible.

## Hypotheses and notation

- The Levinson–Durbin recursion computes λ<sub>min</sub> by inverse iteration; it divides by β<sub>k</sub> = det<sub>k</sub>/det<sub>k−1</sub>.
- The section in question is n = 51 of the first draft, whose true smallest eigenvalue is -1.8681.
- "The correct section's 4.990×10<sup>-9</sup>" is the corresponding value on the corrected section.

## Proof / evidence

The source states the mechanism — on an indefinite Toeplitz row the β<sub>k</sub> changes sign "and what comes out has no relation to the spectrum" — and exhibits the numbers above. It also records the detection route: the inertia bisection of the same section ([the instrument](rh22-instrument-inertia-bisection.md)) and the independent dense exact Cholesky. The source's own dictionary gloss names it "the Levinson lie — inverse iteration reporting an indefinite section positive (standard name: breakdown of the Levinson recursion)".

## Dependencies and related results

- [Trap 1 — the comb outran the sieve](rh22-trap-comb-outran-sieve.md) produced the indefinite section this method then mislabelled.
- [The instrument — inertia bisection](rh22-instrument-inertia-bisection.md) replaces this method in rh22.
- rh19–rh21 used the Levinson–Durbin route; the source's references cite N. Levinson (1947) and J. Durbin (1960).

## Notes


- The source presents this as one of two *traps*: instrument errors of the first draft, reported alongside the result, not as a mathematical theorem. Its status here is the status of an exhibited numerical failure.
- "It is not the first time in this arc that a float lane has been caught lying about an indefinite section. It is the first time the lie was plausible."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
