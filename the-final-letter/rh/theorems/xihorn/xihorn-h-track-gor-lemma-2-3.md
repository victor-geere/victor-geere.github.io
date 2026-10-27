# [GOR⁺] Lemma 2.3 — the renormalised family against Hermite

**Kind:** Lemma
**Status:** CITED (literature — Griffin–Ono–Rolen–Thorner–Tripp–Wagner, Adv. Math. 397 (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H3 "where the Turán criteria actually start to hold"

## Statement

> **The implementation is checked against the papers' own lemma.** [GOR⁺]
> Lemma 2.3 says A_{d,0} = 1, A_{d,1} = 0, A_{d,2} = −d(d−1), and that
> J̃^{2,n} = H₂(X/2) identically. All four hold to 40 digits across d = 2…12 and
> n = 0…40 — and they are what settles that the Δ^d of (2.6) belongs in the
> **denominator**, which the paper's typography leaves ambiguous and which the
> wrong choice gets wrong by a factor of Δ^{2d}.

## Hypotheses and notation

- J̃ is the renormalised family (2.6): J̃^{d,n}(X) := γ(n+d)^{d−1}/(γ(n+d−1)^d·Δ(n+d)^d) · J^{d,n}( γ(n+d−1)/γ(n+d)·(Δ(n+d)X − 1) ), with Δ(M) := √( ½·(1 − γ(M−2)γ(M)/γ(M−1)²) ) the uniformizer.
- A_{d,k}(n) := [X^{d−k}] J̃ (2.7); H₂ is the second Hermite polynomial.
- "Identically" means as a polynomial identity in X, for all n.

## Proof / evidence

The source quotes the lemma and records the check: all four statements hold to 40 digits across d = 2…12, n = 0…40. It gives no proof of the lemma.

## Dependencies and related results

- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the computation the lemma validates.
- [Turán's Theorem III](xihorn-h-track-turan-theorem-iii.md) — the criterion the renormalisation feeds.
- Harvested from the same family elsewhere in the workspace as [[GOR⁺] Lemma 2.3](xihorn-uniformity-gorplus-lemma-23.md).

## Notes

- Its practical role in the source is disambiguation: the Δ^d of (2.6) belongs in the denominator, a reading the paper's typography leaves open and the wrong choice gets wrong by Δ^{2d}.
