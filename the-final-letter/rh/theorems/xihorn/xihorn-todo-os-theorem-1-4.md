# [O'S] Theorem 1.4 — the Lambert-W asymptotic for γ(n)

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §H5 "Check the Lambert-W asymptotic for γ(n)"

## Statement

> `bin/h5_asymptotic`, `rust/src/lambert.rs`. [O'S] Theorem 1.4, with
> w := W(2n/π):
>
> ```text
> γ(n) = 4π²e^{7w/4}·√(w/(w+1))·( e·w²/(16·n·e^{2/w}) )^n·(1 + Σ_{k<K} c_k(w)/n^k + …)
> ```
>
> The paper describes **every** c_k, through a chain of five formulas — (2.6)
> ℓ_i, (7.4) a_r, (7.7) μ_r, (7.11) κ_m, (7.13) κ*_k and c_k, all built on the
> partial ordinary Bell polynomials B̂_{i,j} of (2.1). The whole chain is
> implemented, and Lambert W by Newton on w + log w = log x.

## Hypotheses and notation

- w := W(2n/π), W the Lambert function; K is the truncation order.
- The c_k(w) chain: B̂_{i,j} (2.1), ℓ_i (2.6), a_r (7.4), μ_r (7.7), κ_m (7.11), κ*_k and c_k (7.13).
- The theorem's own table value at n = 1000 is used as the answer key: γ(1000) = 4.8450426112725879772 × 10⁻²⁵⁶⁸.
- The paper prints c₁ and c₂ in closed form; everything else is described through the chain.

## Proof / evidence

The source quotes the theorem without proof and implements it. Evidence recorded: μ₁(w) under (7.6); c₁(w) = (1.8) to 5.0e−76 relative; c₂(w)'s eight-degree rational function; κ_m = 1, 1/12, 1/288, −139/51840, −571/2488320 from (7.11) alone; (7.14) against the crate's exact n!/(2n)!; W(1) = the omega constant; and **[O'S] Table 1, all four rows** (K = 1, 3, 5, 7 at n = 1000), every one to all twenty digits printed.

## Dependencies and related results

- [H5 — the Lambert-W asymptotic](xihorn-h-track-h5-lambert-w-asymptotic.md) — the fuller account, including where the series turns around and the timing comparison.
- [H1 — a(n) at n = 1000](xihorn-h-track-h1-a1000-vs-os-table-1.md) and [H4 — three representations](xihorn-h-track-h4-three-representations.md) — the same value from other directions.
- [[O'S] Theorem 1.4 from H_track.md](xihorn-h-track-os-theorem-1-4.md).

## Notes

- The source's economy verdict: "**it is not a cheaper route to γ(n).** At K = 24 the Bell chain costs **four times more** than 25 700 trapezoid nodes and delivers fewer digits; at K = 7 it is five times cheaper but stops at 21 digits … The quadrature stays."
- Its turnaround is measured, not assumed: "it saturates at **7 digits at n = 3** and **11 at n = 10**, and has not turned by K = 24 for n ≥ 200".
