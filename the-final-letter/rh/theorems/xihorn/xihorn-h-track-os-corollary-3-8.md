# [O'S] Corollary 3.8 — J hyperbolic implies P hyperbolic

**Kind:** Corollary
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §"What every H item shares: γ(n)" and §H2

## Statement

> [O'S] Corollary 3.8: J^{d,n} hyperbolic ⟹ P^{d,n} hyperbolic, so P is a
> *strictly weaker* condition carrying the *same* equivalence.

## Hypotheses and notation

- J^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j ([GOR⁺] (1.2)).
- P^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X) ([O'S] (1.4)), H the Hermite polynomials.
- Hyperbolic = all zeros real.
- The source notes at H2 that the implication is "strictly weaker", not an equivalence: the converse does not hold.

## Proof / evidence

The source quotes the implication without proof. It records the numerical confirmation: "Every P certifies wherever J does — Corollary 3.8, confirmed on all 35 cells" (d = 2…6, n = 0…30, interval LDLᵀ certificates).

## Dependencies and related results

- [H2 — P^{d,n}, and what it is worth to a certificate](xihorn-h-track-h2-p-jensen-max-width.md) — measures what the weakening is worth (175× to 6.0e9× in tolerable enclosure width, 57× in reachable degree).
- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the same asymmetry in the criteria's own currency.
- [[GOR⁺] Lemma 2.3](xihorn-h-track-gor-lemma-2-3.md), [[O'S] Theorem 3.5](xihorn-h-track-os-theorem-3-5.md) — the rest of the criterion apparatus.
- Harvested from the same family elsewhere in the workspace as [[O'S] Corollary 3.8](xihorn-uniformity-osullivan-corollary-38.md).

## Notes

- "Strictly weaker" is the source's own wording; the strictness is not established in this file's source beyond that statement.
