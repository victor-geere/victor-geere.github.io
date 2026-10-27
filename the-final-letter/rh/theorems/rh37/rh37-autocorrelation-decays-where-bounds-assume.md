# The loss is one step: the worst case charges 6.27 where the true minimiser is charged 1.34

**Kind:** Claim
**Status:** VERIFIED (numerical, exact minimiser at n = 96 on the 0.12 window; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh37.html`](../../html/rh37.html) — §7 "Where the decades go"

## Statement

> Four routes now, all with the same shape of failure, which is a reason to stop looking for a fifth and ask what they share. They share one step. Each controls
>
> ∑<sub>|k|&lt;n</sub> q̂(k) E(kΔ)  by  |q̂(k)| ≤ 1,
>
> the worst case, one sign flip per lag. The true minimiser does not look like that.

> Take the exact minimiser at n = 96 on the 0.12 window and read off its autocorrelation. q̂(0) = 1 by normalisation, and the mean of |q̂(k)| over the 95 nonzero lags is **0.220**, not 1. The worst case charges 2∑|E(kΔ)|/E(0) = 6.27 against a budget of 1, which is why Gershgorin dies at 24; the true minimiser is charged 1.34, a factor **4.7** less, because its autocorrelation decays where the worst case does not.

> So the loss is not in any constant, and no sharpening of one closes it — rh30 §5 said as much and this is the mechanism. It is not in the discrepancy either, and not in where q concentrates. It is in assuming a polynomial can be adversarial at every lag at once, when a *nonnegative* one cannot. The missing inequality rh30 named is a joint bound on the autocorrelation of a nonnegative polynomial across lags. Beurling–Selberg does not supply one. Neither does Fejér.

## Hypotheses and notation

- q is the nonnegative trigonometric polynomial of degree n − 1 with q̂(0) = 1; q̂(k) its Fourier coefficients; E the kernel row at lag kΔ.
- The "budget" is 1; the four routes (Gershgorin, and the three others of rh30 §5, plus Fejér's ∞-norm bound here) all control ∑q̂(k)E(kΔ) by |q̂(k)| ≤ 1.
- n = 96, 0.12 window, exact minimiser.

## Proof / evidence

Numerical on the exact minimiser: mean |q̂(k)| over the 95 nonzero lags is 0.220; the worst-case charge is 2∑|E(kΔ)|/E(0) = 6.27 against a budget of 1 (Gershgorin dies at n = 24); the true minimiser is charged 1.34, a factor 4.7 less.

## Dependencies and related results

- [rh37-worst-case-bounds-all-fail](rh37-worst-case-bounds-all-fail.md) — the gap idea and Fejér's bound, the four routes this section unifies.
- rh30 §5 (the loss is not in any constant) and rh30 §10 (b) (the inequality the majorants were meant to supply).
- [rh39-the-minimiser-suppresses-atoms](../rh39/rh39-the-minimiser-suppresses-atoms.md) — rh39 arrives at a joint across-atoms lemma from the other direction.

## Notes


- The source states the missing lemma explicitly and does not claim to have one; the measured mean 0.220 is called one data point on whatever the truth is.
- The section is conditional on RH through rh29's zero table from §4 onward.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
