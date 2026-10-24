# [O'S] Corollary 3.8 — J hyperbolic implies P hyperbolic

**Kind:** Corollary
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §H2 "Implement P_{d,n} and measure its `max width` against J's"

## Statement

> [O'S] (1.4)'s second family, Hermite from the start:
>
> ```text
> P_{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X)
> ```
>
> carries the same equivalence to RH (**Theorem 1.2**) under a strictly weaker
> condition (**Corollary 3.8**: J hyperbolic ⟹ P hyperbolic).

## Hypotheses and notation

- J is the [GOR⁺] family J^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j; P is the Hermite family above; H the Hermite polynomials.
- The implication is one-way — P is "a strictly weaker condition carrying the *same* equivalence" to RH ([O'S] Theorem 1.2, named but not restated in this source).
- The source's own note on strictness: "At d = 2 the sign survives every coefficient being wrong by a factor of two" and the implication is confirmed on all 35 cells, not that the converse fails.

## Proof / evidence

The source quotes the implication without proof and records the numerical confirmation: "every P certifies wherever J does — Corollary 3.8, confirmed on all 35", the 35 being d = 2…6, n = 0…30 certified by the same interval LDLᵀ on the same Hermite–Hankel form.

## Dependencies and related results

- [H2 — P^{d,n} and what it is worth to a certificate](xihorn-h-track-h2-p-jensen-max-width.md) — the measurement of what the weakening is worth (175× to 6.0e9×; P's tolerance flat in n where J's falls).
- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the same asymmetry in the criteria's currency (57×).
- [[O'S] Corollary 3.8 from H_track.md](xihorn-h-track-os-corollary-3-8.md).
- Harvested from the same family elsewhere in the workspace as [[O'S] Corollary 3.8](xihorn-uniformity-osullivan-corollary-38.md).

## Notes

- The source names [O'S] Theorem 1.2 as the equivalence P carries but does **not** restate it; only Corollary 3.8's one-line implication is set out here.

- **Primary-source correction (2025-10-06, session 003 citation audit).** This document added a strictness claim to the paper's Corollary 3.8 — "never the converse", with the converse said to fail. The paper's Corollary 3.8 is the one-way implication "If `J^{d,n}(x)` is hyperbolic then `P^{d,n}(x)` is hyperbolic" and nothing more: neither "never" nor "strict" appears in it, and it does not assert that the converse fails. The implication and its numbering (3.8) are faithful. The added clause is removed below.
