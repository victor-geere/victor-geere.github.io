# [O'S] Theorem 1.4 — the Lambert-W asymptotic for γ(n)

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H5 "the Lambert-W asymptotic"

## Statement

> [O'S] Theorem 1.4. With **w := W(2n/π)**, W the Lambert function,
>
> ```text
> γ(n) = 4π²·e^{7w/4}·√(w/(w+1))·( e·w²/(16·n·e^{2/w}) )^n
>        · ( 1 + Σ_{k=1}^{K−1} c_k(w)/n^k + O(log^K n / n^K) )
> ```
>
> The paper prints c₁ and c₂ in closed form and describes **every** c_k through a
> chain of five formulas.

The source reproduces that chain in full — (2.1) B̂_{i,j}, (2.6) ℓ_i, (7.4) a_r, (7.7) μ_r, (7.11) κ_m, (7.13) κ*_k and c_k — with a_{−1} := 0 so μ₀ = 1, and notes that the κ_m are Stirling's own coefficients and κ*_k those of n!/(2n)! = 2^{−½}(e/4n)^n(1 + Σκ*_k/n^k), [O'S] (7.14). It also records the theorem's table value

> γ(1000) = 4.8450426112725879772 × 10⁻²⁵⁶⁸

at n = 1000, where w = W(2000/π) = 4.87255428106479306986486.

## Hypotheses and notation

- w := W(2n/π), W the Lambert function; K is the truncation order of the asymptotic series.
- The c_k(w) are described through the five-formula chain resting on partial ordinary Bell polynomials B̂_{i,j}.
- The error term is O(log^K n / n^K).

## Proof / evidence

The source quotes the theorem without proof and implements the whole chain (`rust/src/bin/h5_asymptotic.rs`, `rust/src/lambert.rs`). Evidence recorded there: μ₁(w) under (7.6); c₁(w) = (1.8) to 5.0e−76 relative; c₂(w)'s eight-degree rational function; κ_m = 1, 1/12, 1/288, −139/51840, −571/2488320 from (7.11) alone; (7.14) against the crate's exact n!/(2n)!; and all four rows of [O'S] Table 1 (K = 1, 3, 5, 7) to every digit printed.

## Dependencies and related results

- [H5 — the Lambert-W asymptotic](xihorn-h-track-h5-lambert-w-asymptotic.md) — the implementation and the turnaround measurements.
- [H1 — a(n) at n = 1000](xihorn-h-track-h1-a1000-vs-os-table-1.md) — whose value the K = 7 row reproduces from an independent direction.
- [G5 — the C3 constant](xihorn-rust-results-g5-watson-constant-4.md) — later uses Lambert's W from this module.

## Notes

- The theorem is asymptotic, not exact for finite K: the source measures that it "saturates at **7 digits at n = 3** and **11 at n = 10**, and has not turned around by K = 24 for n ≥ 200", and that it "is not a cheaper route to γ(n)".
