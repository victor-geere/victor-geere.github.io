# [GOR⁺] Lemma 2.3 — the renormalised family against Hermite

**Kind:** Lemma
**Status:** CITED (literature — Griffin–Ono–Rolen–Thorner–Tripp–Wagner, Adv. Math. 397 (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §H3 "Find where the Turán criteria actually start to hold"

## Statement

> **the implementation is checked against the papers' own lemma.** [GOR⁺]
> Lemma 2.3 says A_{d,0} = 1, A_{d,1} = 0, A_{d,2} = −d(d−1), and that
> J̃^{2,n} = H₂(X/2) identically. `A_{d,0}`, `A_{d,1}`, `A_{d,2}` are asserted to 40 digits at `d = 2…12` for
> `n ∈ {0, 1, 5, 20, 40}`, and `J̃^{2,n} = H₂(X/2)` at `d = 2` for `n ∈ {0, 3, 11, 30}` — and they are what settles that the Δ^d of (2.6) belongs in the
> **denominator**, which the paper's typography leaves ambiguous and which the
> wrong choice gets wrong by a factor of Δ^{2d}.

## Hypotheses and notation

- A_{d,k}(n) := [X^{d−k}] J̃ (2.7), where J̃ is the renormalisation (2.6) of J^{d,n} by the uniformizer Δ(n+d), Δ(M) := √( ½·(1 − γ(M−2)γ(M)/γ(M−1)²) ).
- The four statements: A_{d,0} = 1, A_{d,1} = 0, A_{d,2} = −d(d−1), and J̃^{2,n} = H₂(X/2) identically.
- H₂ is the second Hermite polynomial; "identically" means as a polynomial identity in X, for all n.

## Proof / evidence

The source quotes the lemma and records the check: all four hold to 40 digits across d = 2…12, n = 0…40. It gives no proof of the lemma.

## Dependencies and related results

- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the computation this lemma validates and the Δ^d ambiguity it settles.
- [Turán's Theorem III (via (2.9))](xihorn-h-track-turan-theorem-iii.md), [[GOR⁺] Theorem 1.1](xihorn-todo-gor-theorem-1-1.md).
- [[GOR⁺] Lemma 2.3 from H_track.md](xihorn-h-track-gor-lemma-2-3.md); harvested from the same family elsewhere as [[GOR⁺] Lemma 2.3](xihorn-uniformity-gorplus-lemma-23.md).

## Notes

- The source's purpose in quoting it is twofold: an exact test of the implementation, and a decision on the typography of (2.6) — the Δ^d belongs in the denominator.

- **Correction (2025-10-06, session 003 residual-defect repair).** The **label is correct** — this is a `CITED` document and the lemma it restates is the paper's. What was wrong is the sweep quoted inside it: the source says "All four hold to 40 digits across `d = 2…12` and `n = 0…40`" (`xi-horn/TODO.md:876`), which reads as a 396-cell grid, while the committed tests assert the properties at `d = 2…12` for `n ∈ {0, 1, 5, 20, 40}` (`xi-horn/rust/src/turan.rs:288-289`) and `J̃^{2,n} = H₂(X/2)` at `d = 2` for `n ∈ {0, 3, 11, 30}` (`:311`), with `xi-horn/rust/src/bin/h3_onset.rs:52` printing five sampled pairs. The quotation is now given at the coverage that exists. The session-003 audit flagged this document's *label*; that part of the flag was wrong, and the correction is recorded rather than the label.
