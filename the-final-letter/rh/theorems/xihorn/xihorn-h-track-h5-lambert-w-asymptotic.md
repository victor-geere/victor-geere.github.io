# H5 — the Lambert-W asymptotic

**Kind:** Claim
**Status:** VERIFIED (numerical; all four rows of [O'S] Table 1 reproduced to every digit printed)
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
> chain of five formulas. That chain is implemented here in full:
>
> ```text
> B̂_{i,j}(p₁,p₂,…)  : (p₁x + p₂x² + ⋯)^j = Σ_{i≥j} B̂_{i,j}·x^i           (2.1)
> ℓ_i(u)   = Σ_{j=1}^{i} B̂_{i,j}(1,−½,⅓,…)·(−1)^{j+1}/(j·u^j)            (2.6)
> a_r(β;v) = Σ_{j=0}^{2r} (2j+2r−1)!!/j! · (v²/(v+1))^{j+r}
>              · Σ_{i=j}^{2r} B̂_{i,j}(ℓ₃(v),ℓ₄(v),…)·C(β, 2r−i)           (7.4)
> μ_r(w)   = 2^{−r−1}·( 2·a_r(5/4;w) − 3w·a_{r−1}(1/4;w) )               (7.7)
> κ_m      = (2m−1)!!·Σ_{j=0}^{2m} C(−m−½,j)·B̂_{2m,j}(−⅔,½,−⅖,…)         (7.11)
> κ*_k     = Σ_{j=0}^{k} (−2)^{−j}·κ_j·κ_{k−j}                           (7.13)
> c_k(w)   = Σ_{j=0}^{k} μ_j(w)·κ*_{k−j}                                 (7.13)
> ```
>
> with a_{−1} := 0 so μ₀ = 1. The κ_m are Stirling's own coefficients and κ*_k
> those of n!/(2n)! = 2^{−½}(e/4n)^n(1 + Σκ*_k/n^k), [O'S] (7.14).
>
> ### [O'S] Table 1, all four rows
>
> At n = 1000, w = W(2000/π) = 4.87255428106479306986486:

| K | Theorem 1.4 | [O'S] Table 1 |
|---|---|---|
| 1 | 4.8460204243211378239e−2568 | 4.8460204243211378239e−2568 |
| 3 | 4.8450426111532216799e−2568 | 4.8450426111532216799e−2568 |
| 5 | 4.8450426112725884216e−2568 | 4.8450426112725884216e−2568 |
| 7 | 4.8450426112725879772e−2568 | 4.8450426112725879772e−2568 |
| | 4.8450426112725879772e−2568 | γ(1000), this crate (H1) |

> Every row to all twenty digits printed. This is a single check on the whole
> Bell chain **and** on H1's quadrature at once, from a direction that shares no
> arithmetic with it.
>
> ### Where the asymptotic series turns around
>
> An asymptotic series improves to a point and then diverges. Agreeing decimal
> digits, as a function of the truncation K: [the source's table] So the
> expansion saturates at **7 digits at n = 3** and **11 at n = 10**, and has not
> turned around by K = 24 for n ≥ 200. The bare leading factor (K = 1) is worth
> 2.4e−2 at n = 1 falling to 2.0e−4 at n = 1000.
>
> **It is not a cheaper route to γ(n).** … The Bell chain at K = 24 costs **four
> times more** than 25 700 trapezoid nodes and delivers fewer digits. At K = 7 it
> is five times cheaper but stops at 21 digits … The quadrature stays.
>
> ### [GOR⁺]'s L_M parametrisation, and (3.2)
>
> [GOR⁺] expand the same γ in a different parameter: **L_M**, the unique positive
> root of M = L_M·(π·e^{L_M} + ¾), with K_M := (L_M^{−1} + L_M^{−2})M − ¾. It is
> close to but not equal to [O'S]'s w, and the gap is predictable — eliminating n
> between n = (π/2)we^w and 2n−2 = L(πe^L + ¾) gives w − L ≈ (3L/8 + 1)/((π/2)e^L(1+L)) …
>
> (A) tends to **4/π = 1.273239545**, which is not a normalisation anyone would
> write. (B) tends to **8** — the same factor H4 measures in (3.1), from the same
> source [GORZ19]. √(2π/K) is also the factor a Laplace saddle produces, which
> 1/√(2πK) is not. So (B) is the reading, and **both formulas [GOR⁺] quote from
> [11] carry [11]'s normalisation** (E18). The residual falls like the
> O_ε(M^{−1+ε}) they claim, at 1.5 to 2.2 times [O'S]'s own K = 1 error.

## Hypotheses and notation

- w := W(2n/π), W the Lambert function, computed by Newton on w + log w = log x; a_{−1} := 0.
- B̂_{i,j} are the partial ordinary Bell polynomials of (2.1); ℓ_i, a_r, μ_r, κ_m, κ*_k, c_k as displayed.
- Driver `rust/src/bin/h5_asymptotic.rs`; module `lambert`.
- In (3.2)'s ambiguous radical the two readings evaluated are (A) ⟨root⟩ = 1/√(2π·K) and (B) ⟨root⟩ = √(2π/K).

## Proof / evidence

Numerical: the whole five-formula Bell chain is implemented and reproduces μ₁(w) under (7.6), c₁(w) = (1.8) to 5.0e−76 relative, c₂(w)'s eight-degree rational function, κ_m = 1, 1/12, 1/288, −139/51840, −571/2488320 from (7.11) alone, (7.14) against the crate's exact n!/(2n)!, and W(1) = the omega constant 0.5671432904097838730 (with W(x)e^{W(x)} = x to 50 digits). It then reproduces all four rows of [O'S] Table 1 at n = 1000 to every digit printed. The turnaround and the timing tables are the series' own measurements.

## Dependencies and related results

- [[O'S] Theorem 1.4](xihorn-h-track-os-theorem-1-4.md) — the quoted asymptotic.
- [H1 — a(n) at n = 1000](xihorn-h-track-h1-a1000-vs-os-table-1.md) — the value the K = 7 row also reproduces.
- [H4 — three representations](xihorn-h-track-h4-three-representations.md) — the same [GORZ19] factor of 8, in (3.2)'s radical (E18).
- [G5 — the C3 constant](xihorn-rust-results-g5-watson-constant-4.md) — later uses Lambert's W from this module.

## Notes

- The source's conclusion is negative about economy: "**It is not a cheaper route to γ(n).** … The quadrature stays."
- The nesting of (3.2)'s factors is not fixed by the extracted text; the source evaluates **both** readings rather than choosing, and settles it by the limit (A) → 4/π versus (B) → 8.
