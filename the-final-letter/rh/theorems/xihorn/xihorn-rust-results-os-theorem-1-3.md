# [O'S] Theorem 1.3 — the exponential made polynomial

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, H3

## Statement

> Both certify through Turán's Theorem III and both bound the onset only
> asymptotically — … and n/log²n ≥ d^{3/4}/2 for P ([O'S] Thm 1.3, "d large").

## Hypotheses and notation

- The condition is n/log²n ≥ d^{3/4}/2, for **d large** — the source keeps the paper's qualifier.
- It concerns P^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X).
- Comparison recorded: "[O'S] Thm 1.3 overshoots the true onset by **296× to 1602×** where both are defined."

## Proof / evidence

The source states the bound without proof, and records the comparison against the measured onsets; the P crossing is sharp at (8.2) = 0.993195 (d = 400) and 1.000691 (d = 401).

## Dependencies and related results

- [H3 — a table neither paper has](xihorn-rust-results-h3-turan-onset.md) — the measured onsets.
- [[GOR⁺] Theorem 1.1](xihorn-rust-results-gor-theorem-1-1.md) — the bound this one replaces.
- [[O'S] Theorem 1.3 from H_track.md](xihorn-h-track-os-theorem-1-3.md) and [from TODO.md](xihorn-todo-os-theorem-1-3.md).

## Notes

- TODO.md §C1 states its significance: "[O'S] Theorem 1.3 then replaces the exponential with a **polynomial** … That is not RH — both still leave n small relative to d — but it is a real change in the state of the art, and it happened by changing the criterion (**H6**), not by improving the estimates."
