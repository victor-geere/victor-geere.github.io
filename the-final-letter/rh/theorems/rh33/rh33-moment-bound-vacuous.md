# The elementary bound in the moments, and why it says nothing

**Kind:** Lemma
**Status:** PROVED (paper argument; vacuous on the living material)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §5 "What the loss is made of", lines 695–709

## Statement

> The honest replacement is immediate and almost tautological: T<sub>n</sub> is built from the moments E(0)…E(n − 1) and nothing else, so ρ is a function of the moments. For the modulated crystal that function is one line — ρ = 1 − max|E|/mass, verified to machine zero — because only one moment is on.
>
> It is worth saying plainly why this does not immediately give a theorem. The elementary bound in the moments is
>
> ρ ≥ 1 − 2∑<sub>k≥1</sub>|E(k)|/mass, and on the living material at mesh Δ = 0.12, n = 61 that sum is 1.87 — the bound reads ρ ≥ −2.7 and says nothing, while the measured ρ is 0.514. The moments are large and they cancel. Any true statement about the loss has to know their signs, not just their sizes. That is the real difficulty, and it was never the difficulty rh32 named.

## Hypotheses and notation

- T<sub>n</sub> is the Toeplitz matrix with entries E(j−k); ρ is [rh33-loss-constant-identification](rh33-loss-constant-identification.md)'s loss constant.
- "the living material" is the arc's wrapped-ordinate measure at mesh Δ = 0.12, n = 61.
- The modulated crystal's one-line form ρ = 1 − max|E|/mass holds "because only one moment is on".

## Proof / evidence

The elementary bound is a paper argument (sum the off-diagonal moments against the diagonal); its vacuity is numerical: the sum is 1.87 at Δ = 0.12, n = 61, so the bound reads ρ ≥ −2.7 against a measured ρ = 0.514. The modulated-crystal form is verified to machine zero.

## Dependencies and related results

- [rh33-loss-constant-identification](rh33-loss-constant-identification.md) — the quantity bounded.
- [rh33-modulated-crystal-loss-exact](rh33-modulated-crystal-loss-exact.md) — the case where only one moment is on.
- [rh33-moments-are-a-prime-sum](rh33-moments-are-a-prime-sum.md) — §6 identifies those moments.
- [rh33-prime-comb-cancellation](rh33-prime-comb-cancellation.md) — the same cancellation seen from the prime side.

## Notes

- The source states the honest replacement is "almost tautological"; the content is the failure of the elementary bound, which is the reason §5 does not give a theorem.
- §8(a) turns this into a target ("bound λ<sub>min</sub> of the Toeplitz matrix whose row is the signed prime comb, using the cancellation and not the triangle inequality"), which is an open direction and is not harvested.
