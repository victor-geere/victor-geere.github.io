# [O'S] Theorem 1.3 — the exponential made polynomial

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §H3 "Find where the Turán criteria actually start to hold"

## Statement

> Both papers certify through Turán's Theorem III and **both bound the onset
> only asymptotically** — n ≥ c·e^d for J ([GOR⁺] Theorem 1.1, with **c never
> given**) and n/log²n ≥ d^{3/4}/2 for P ([O'S] Theorem 1.3, "d large").

The source's own account of what the theorem changed, in §C1 of the same file:

> [GOR⁺] Theorem 1.1 makes the d-uniformity *effective* — J_{d,n} is hyperbolic
> once n ≥ c·e^d, with 0.9634 the exponent their proof yields. [O'S] Theorem 1.3
> then replaces the exponential with a **polynomial**: P_{d,n} is hyperbolic once
> n/log²n ≥ d^(3/4)/2, for d large.

## Hypotheses and notation

- The condition is n/log²n ≥ d^{3/4}/2, for **d large** — the source quotes the paper's qualifier "d large".
- It concerns P_{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X) ([O'S] (1.4)).
- Λognormalisation: the exponent 0.9634 quoted in §C1 belongs to [GOR⁺] Theorem 1.1, not to this theorem.

## Proof / evidence

The source states the bound without proof. It records the comparison against the measured onset: "Where both are defined, [O'S] Theorem 1.3's sufficient bound overshoots the true onset by **296× to 1602×**."

## Dependencies and related results

- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the measured table and crossing ((8.2) = 0.993195 at d = 400, 1.000691 at d = 401).
- [[GOR⁺] Theorem 1.1](xihorn-todo-gor-theorem-1-1.md) — the bound this one replaces.
- [[O'S] Theorem 1.3 from H_track.md](xihorn-h-track-os-theorem-1-3.md).

## Notes

- The source's caution about the state of the art: "That is not RH — both still leave n small relative to d — but it is a real change in the state of the art, and it happened by changing the criterion (**H6**), not by improving the estimates."
