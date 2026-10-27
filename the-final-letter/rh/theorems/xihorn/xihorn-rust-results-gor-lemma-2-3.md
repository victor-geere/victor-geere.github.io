# [GOR⁺] Lemma 2.3 — an exact test, and it settles an ambiguity

**Kind:** Lemma
**Status:** CITED (literature — Griffin–Ono–Rolen–Thorner–Tripp–Wagner, Adv. Math. 397 (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, H3, third bullet

## Statement

> * **[GOR⁺] Lemma 2.3 is an exact test, and it settles an ambiguity.** A_{d,0} = 1,
>   A_{d,1} = 0, A_{d,2} = −d(d−1), and J̃^{2,n} = H₂(X/2) identically — all four
>   hold to 40 digits across d = 2…12, n = 0…40. They are also what decides that
>   the Δ^d of (2.6) belongs in the **denominator**, which the paper's typography
>   leaves open and which the wrong choice gets wrong by Δ^{2d};

## Hypotheses and notation

- A_{d,k}(n) := [X^{d−k}] J̃ (2.7) for the renormalised family J̃ of (2.6), renormalised by the uniformizer Δ(n+d), Δ(M) := √( ½·(1 − γ(M−2)γ(M)/γ(M−1)²) ).
- The four statements: A_{d,0} = 1, A_{d,1} = 0, A_{d,2} = −d(d−1), and J̃^{2,n} = H₂(X/2) identically.
- H₂ is the second Hermite polynomial; "identically" means as a polynomial identity in X, for all n.

## Proof / evidence

The source quotes the lemma and records the check: all four hold to 40 digits across d = 2…12, n = 0…40. It gives no proof.

## Dependencies and related results

- [H3 — a table neither paper has](xihorn-rust-results-h3-turan-onset.md) — the computation this lemma validates.
- [[GOR⁺] Lemma 2.3 from H_track.md](xihorn-h-track-gor-lemma-2-3.md) and [from TODO.md](xihorn-todo-gor-lemma-2-3.md).
- Harvested from the same family elsewhere in the workspace as [[GOR⁺] Lemma 2.3](xihorn-uniformity-gorplus-lemma-23.md).

## Notes

- Its role here is as much disambiguation as verification: the Δ^d of (2.6) belongs in the denominator, and the other reading is wrong by Δ^{2d}.
