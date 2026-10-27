# [O'S] Theorem 3.9 — the Bessel/Laguerre dial and RH

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §5 "The criterion is the free parameter — and what it cannot buy", quoted theorem box

## Statement

> **[O'S] Theorem 3.9.** *The Riemann hypothesis is true if and only if the polynomials Q_{d,n,ν}(x) := Σ_{j=0}^{d} C(d+ν, j)·γ(n+j)·x^j·L^(ν)_{d−j}(x) are hyperbolic for all d ≥ 1, all n ≥ 0 and all real ν ≥ −2.*

## Hypotheses and notation

- Q_{d,n,ν}(x) := Σ_{j=0}^{d} C(d+ν, j)·γ(n+j)·x^j·L^(ν)_{d−j}(x), where L^(ν)_k are the Laguerre polynomials with parameter ν and C(d+ν, j) is the binomial coefficient with real upper parameter.
- γ is the papers' γ(n) = the directory's a(n) (no rescaling, source §1).
- The quantifier is over all d ≥ 1, all n ≥ 0 and all real ν ≥ −2 (the paper writes the parameter as `α` and the endpoint as closed); hyperbolic = all zeros real.
- The source identifies the setting: "Ω = 𝒥_ν (Bessel) returns a Laguerre family with a *continuous* parameter".

## Proof / evidence

The source quotes it without proof, as the third setting of the Ω dial of [O'S] Theorem 3.5. Its role in the source's `[ ]` item "Optimise the dial": "Search Ω over e^{−αz²}, the Bessel/Laguerre line ν ≥ −2 (Theorem 3.9), and products, scoring each by H3's measured onset."

## Dependencies and related results

- [O'S] Theorem 3.5 ([harvested](xihorn-uniformity-osullivan-theorem-35.md)) is the general criterion whose dial this is; [O'S] Lemma 3.4 ([harvested](xihorn-uniformity-osullivan-lemma-34.md)) identifies the family as g*_d(Φ·Ω; x).
- The invariance that bounds this dial is [the Ω-dial invariance](xihorn-uniformity-omega-dial-invariance.md).

## Notes

- The source's ceiling statement: "§5's invariance is the ceiling and it is strict"; and "No Ω closes the corner. Ω chooses how cheaply the wedge is certified, and that is all it chooses."

- **Primary-source correction (2025-10-06, session 003 citation audit).** The parameter range was quoted as `ν > −2` (open). The paper's Theorem 3.9 reads **`all real α ≥ −2`** — closed — in both v1 and v2, and the paper's own `d = 2` discriminant computation confirms the endpoint is included. A boundary that the paper admits was being excluded. The range is now `ν ≥ −2`; the parameter is the paper's `α` under the archive's `ν` notation.
