# A's claimed explicit-formula closure — REFUTED (the formula closes only up to S(T))

**Kind:** Claim
**Status:** REFUTED (A's signed closure claim downgraded; the journal records no closure)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 5 signed answer, line 395; mediator's check, lines 397–406; Round 5 final adjudication, line 464; Synthesis "What failed to close", line 458

## Statement

The claim as signed (Round 5):

> He additionally asserts a closure of the explicit formula: (γ_k/2π)log(γ_k/2πe) + 7/8 + (1/π)arg ζ(½+iγ_k) − k = −2.80392e−5 (k=100), −4.67084e−6 (k=1000), −1.0 (k=5000).

The refutation:

> **Mediator's independent check of that closure claim.** I reproduce the exact form and get, for k = 10, 100, 1000, 5000, 10000, with the completed zero-counting function N(T) = θ(T)/π + 1 + (1/π)arg ζ(½+iT) and θ(T) = Im logΓ(¼+iT/2) − (T/2)log π:

| k | γ_k | N(T) computed | S = k − N(T) |
|---|---|---|---|
| 100 | 236.524229666 | 99.684995378 | **0.31500462** |
| 1000 | 1419.42248095 | 999.292808676 | **0.70719132** |
| 5000 | 5447.8619983 | 4999.40523299 | **0.59476701** |
| 10000 | 9877.78265401 | 9999.55426967 | **0.44573033** |

> So the Riemann–von Mangoldt formula holds to **within one unit**, and the residual is **S(T) ≈ (1/π)arg ζ(½+iT)**, which is *not* zero but wanders in [0.3, 0.8] over this range. A's "closure" values are therefore either a different convention or an error: the honest statement is that the formula closes **up to the S(T) term**, which is exactly the term carrying the zeros' individual positions. And A's −1.0 at k=5000 is, as he suspected, a half-integer/at-the-zero convention effect — I verified that moving 10⁻⁶ off the zero changes the smooth part by only 1e−9, so the −1 is an indexing artefact at the zero itself. **Verdict: the closure claim is DOWNGRADED from "it closes" to "it closes up to S(T), which is the term that matters, and I will not call that a closure."**

## Hypotheses and notation

- γ_k is the k-th zeta zero ordinate; the claimed identity is (γ_k/2π)log(γ_k/2πe) + 7/8 + (1/π)arg ζ(½+iγ_k) − k.
- The completed zero-counting function N(T) = θ(T)/π + 1 + (1/π)arg ζ(½+iT), θ(T) = Im logΓ(¼+iT/2) − (T/2)log π; the residual is S = k − N(T).
- "At-the-zero indexing artefact" refers to evaluating the arg at the zero rather than infinitesimally off it.

## Proof / evidence

Independent mediator computation of the same completed formula: S(T) = 0.31500462 (k=100), 0.70719132 (k=1000), 0.59476701 (k=5000), 0.44573033 (k=10000) — not the small values A claimed. Moving 10⁻⁶ off the zero changes the smooth part by only 1e−9, so the −1.0 at k=5000 is an indexing artefact.

## Dependencies and related results

- [Riemann–von Mangoldt: N(T) = (T/2π)log(T/2π) − T/2π + 7/8](research-journal-riemann-von-mangoldt.md) — the formula being "closed".
- [Certification requires zero information](research-journal-certification-zero-information.md) — the corrected statement about ζ truncation.
- [The two sides of the explicit formula are dual but exponentially non-equi-truncatable](research-journal-non-equi-truncatability.md) — the replacement diagnosis of every failed truncation.

## Notes

- The journal's own summary: "So the last word is: the formula closes only up to the term that carries the zeros, which is not a closure." Earlier, the mediator's own attempt is also recorded as OPEN with a diagnosed cause ("I record the closure as OPEN with a diagnosed cause and a fixed sub-error"), and B's attempt gave a ratio 0.3214 against a required −1 or −2.
- The status is REFUTED for A's signed claim; the journal does not record any successful numerical closure of the explicit formula by either agent or the mediator.
