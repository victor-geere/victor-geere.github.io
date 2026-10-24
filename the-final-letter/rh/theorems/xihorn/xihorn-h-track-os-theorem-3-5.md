# [O'S] Theorem 3.5 — the Ω-family criterion

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H6 "searching Ω for the criterion with the earliest onset"

## Statement

> **Theorem 3.5.** For Φ real entire of genus 1\* and **any** Ω in the
> Laguerre–Pólya class, Φ is hyperbolic ⟺ every g\*_d(Φ·Ω; x) is hyperbolic.
>
> With Φ = Θ^{(n)} (coefficients γ(n+j)): **Ω = 1 gives J^{d,n}** and
> **Ω = e^{−z²} gives P^{d,n}(x/2)**, because g\*_d(e^{−z²}; x) = H_d(x/2). So Ω
> is a free parameter: every choice is equivalent to RH, and H3 measured that
> those two are worth d ≤ 7 against d ≤ 400. **The free parameter in this
> criterion is not the degree and not w — it is Ω, and H3 supplies the cost
> function.**

## Hypotheses and notation

- Φ is a real entire function of genus 1\*; Ω ranges over the Laguerre–Pólya class LP.
- g*_d is the reciprocal Jensen polynomial of [O'S] Lemma 3.4 (3.3).
- Hyperbolic = all zeros real; the quantifier is every d (the source in H6 uses d ≥ 1).
- Ω = 1 gives J^{d,n}; Ω = e^{−z²} gives P^{d,n}(x/2) since g*_d(e^{−z²}; x) = H_d(x/2).

## Proof / evidence

The source quotes the theorem without proof ("This is the most interesting thing in either paper"), and uses it as the rung of the H6 search: a second application of Lemma 3.4 gives one formula containing both papers' published criteria, validated to 6.05e−77 against (8.2) and 8.39e−69 against (2.9).

## Dependencies and related results

- [[O'S] Lemma 3.4 (3.3)](xihorn-h-track-os-lemma-3-4-product-rule.md) — the product rule the criterion is stated with.
- [H6 — searching Ω for the criterion with the earliest onset](xihorn-h-track-h6-omega-search.md) — the measured cost of each Ω.
- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the cost function for Ω = 1 and Ω = e^{−z²} (7 against 400).
- Harvested from the same family elsewhere in the workspace as [[O'S] Theorem 3.5](xihorn-uniformity-osullivan-theorem-35.md).

## Notes

- The source's caveat, attached to the H6 verdict: the shifted criterion Ω = e^{−z²−μz} is a *legal* choice for this theorem — it is in LP and fixed across d, as the theorem requires; μ depends on n only.
