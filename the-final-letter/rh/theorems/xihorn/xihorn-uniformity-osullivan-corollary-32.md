# [O'S] Corollary 3.2 — the all-d direction at a fixed shift is Θ^(n)-hyperbolicity

**Kind:** Corollary
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §1 "The problem, stated exactly"

## Statement

> **Fixed n, all d.** [O'S] Corollary 3.2: Θ^(n) is hyperbolic ⟺ J_{d,n} is hyperbolic for every d ≥ 1.

## Hypotheses and notation

- Θ(z) = ξ(½ + √z), so that Ξ(z) = Θ(z²) is the paper's order-½ entire function; Θ^(n) is its n-th derivative. (The paper's symbol is `Θ`; the archive's `Ξ` is the same object in the other variable.) J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j ([O'S] (1.3)). J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j ([O'S] (1.3)).
- n is fixed and the quantifier is over all d ≥ 1; hyperbolic = all zeros real.
- The source's reading of the right-hand side: "the statement [GOR⁺] call RH_n, with RH = RH₀ implying every RH_m."

## Proof / evidence

The source states it as a cited rung, without proof: "So the d-direction at a single shift is the hyperbolicity of the n-th derivative — the statement [GOR⁺] call RH_n, with RH = RH₀ implying every RH_m. The all-d limit at fixed n **is** the theorem being sought, one derivative at a time."

## Dependencies and related results

- [O'S] Theorem 1.1 ([harvested](xihorn-uniformity-osullivan-theorem-11.md)) is the two-axis criterion this localizes.
- The Ω-dial invariance ([harvested](xihorn-uniformity-omega-dial-invariance.md)) is this statement transported to every Ω ∈ LP.
- In the companion source the same corollary is quoted in the F^{(n)} form (there `F` is the order-½ function of the other variable, `F(z) = Σ a(n)z^n/n! = Ξ(√−z)`): [xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md](xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md).

## Notes

- The source uses it for the file's asymmetry thesis: "the first axis is the problem and the second is the progress, and no amount of the second sums to the first"; the second axis is the fixed-d, all-n direction covered by [GOR⁺] Corollary 1.3 ([harvested](xihorn-uniformity-gorplus-corollary-13.md)).

- **Primary-source correction (2025-10-06, session 003 citation audit).** The statement was given as "`ξ^(n)` is hyperbolic" with "`ξ` is the Riemann xi function". The paper's Corollary 3.2 is about **`Θ^(n)`**, the `n`-th derivative of `Θ(z) = ξ(½ + √z)` — its proof says so: "We know that `Θ(z)` is real and entire of order 1/2. All of its derivatives … implies that `Θ^(n)(z)` is real and entire of genus 1\* for all `n ≥ 0`." The distinction is not cosmetic: `ξ` is complex on the real axis, so "`ξ^(n)` is hyperbolic" is not the statement the criterion needs or the paper makes. The companion document (`xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md`) writes the same corollary with the other variable's function `F(z) = Ξ(√−z)`, which *is* real on the line and is the correct object; this document now uses `Θ` and defines it.
