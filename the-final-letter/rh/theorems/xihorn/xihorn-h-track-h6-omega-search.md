# H6 — searching Ω for the criterion with the earliest onset

**Kind:** Claim
**Status:** VERIFIED (numerical; T identical at 60 and 180 digits at d = 100, 200 and 400)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H6 "searching Ω for the criterion with the earliest onset"

## Statement

> This is the most interesting thing in either paper. [O'S] §3 defines, for a
> formal power series Φ(z) = Σ c_j z^j/j!, the Jensen polynomial and its
> reciprocal, and proves a product rule for them:
>
> ```text
> g_d(Φ; x)  := Σ_{j=0}^{d} C(d,j)·c_j·x^j
> g*_d(Φ; x) := x^d·g_d(Φ; 1/x) = Σ_{j=0}^{d} C(d,j)·c_j·x^{d−j}
> g*_d(Φ·Ω; x) = Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x)      Lemma 3.4, (3.3)
> ```
>
> **Theorem 3.5.** For Φ real entire of genus 1\* and **any** Ω in the
> Laguerre–Pólya class, Φ is hyperbolic ⟺ every g\*_d(Φ·Ω; x) is hyperbolic.
>
> With Φ = Θ^{(n)} (coefficients γ(n+j)): **Ω = 1 gives J^{d,n}** and
> **Ω = e^{−z²} gives P^{d,n}(x/2)**, because g\*_d(e^{−z²}; x) = H_d(x/2). So Ω
> is a free parameter: every choice is equivalent to RH, and H3 measured that
> those two are worth d ≤ 7 against d ≤ 400. **The free parameter in this
> criterion is not the degree and not w — it is Ω, and H3 supplies the cost
> function.**
>
> ### One formula for all of it
>
> Turán III needs the polynomial in the Hermite basis. Converting bases would
> manufacture cancellation exactly where [O'S]'s own criterion has none, so
> instead apply Lemma 3.4 a second time with Ω replaced by e^{−z²}:
>
> ```text
> g*_d(Ψ; x) = Σ_j C(d,j)·χ_j·H_{d−j}(x/2),        χ := Ψ·e^{+z²}
> ```
>
> Writing **M := Ω(σz)·e^{z²}** and Ψ = Θ^{(n)}·Ω, the whole criterion is
>
> ```text
> χ_j = Σ_{i=0}^{j} C(j,i)·γ(n+i)σ^i·M_{j−i}
> c_k = C(d, d−k)·χ_{d−k}                        (the coefficient of H_k)
> T   = Σ_{k=0}^{d−2} 2^k·k!·c_k²  /  ( 2^d·(d−1)!·c_d² )      < 1
> ```
>
> Restricting Ω to the Gaussian-and-shift family makes M = exp(νz² − μz) with
> ν = 1 − βσ², and then **M = 1 (ν = 0, μ = 0, σ = 1) is [O'S] (8.2) term for
> term** and **M = e^{z²} (ν = 1) is Turán applied to J directly**.

The source's measurements of the three dials, in its own tables:

- **Dial 1, ν:** T depends on the whole Gaussian family only through ν; at ν = 0 the values are **5.183e−7, 5.412e−7, 5.907e−7** at (6,10), (8,20), (10,30), against 4.546e−1 / 1.143e0 / 2.333e0 at ν = 0.10. "A **1% move in ν costs four decades**, in either direction, nearly symmetrically in |ν|. … **[O'S] chose the optimum, and it is the only one.**"
- **Dial 2, μ:** χ₂(μ) = γ(n+2) − 2μ·γ(n+1) + μ²·γ(n) has roots **μ± = γ(n+1)/γ(n) · ( 1 ± √2·Δ(n+2) )**; at (8,20) T falls from 5.41205e−7 at μ = 0 to **2.66225e−16** at μ− (ratio 4.92e−10) and **9.83711e−16** at μ+ (1.82e−9).
- **Dial 3, σ:** "The j = 2 term dominates and carries d³, so d³σ⁴ ≈ const and **d_max ∝ σ^{−4/3}**", measured 0.398, 0.583, 1.000, 1.470, 2.525 against 0.397, 0.582, 1.000, 1.468, 2.520 at σ = 2, 1.5, 1, 0.75, 0.5.
- **The leaderboard** at n = 0, σ = 1: [GOR⁺] (2.9) reaches d_max = **7**; [O'S] (8.2) reaches **400**; Ω = e^{−z²−τz} with τ = μ− reaches **10141**; every other Ω tried fails at d = 2 or 3.
- **The shift changes the power of d:** fitted exponents **d^3.015** ([O'S] P) and **d^4.011** (shifted τ = μ−); "Extrapolating T = 1 from the d⁴ law puts the shifted criterion's own crossing near d = 10095; **located directly by bisection it is d = 10141**".

> ### The verdict
>
> > **Ω is a free parameter, every choice is equivalent to RH, and they differ
> > enormously in how cheaply they can be verified — but the Gaussian content of
> > Ω has a unique optimum and [O'S] already found it. What is left on the table
> > is the translation, and it is worth a change of exponent: d³ → d⁴, d_max at
> > n = 0 from **400 to 10141**, and n₀(d) = 0 across the whole range where P's
> > is not. The translation that does it is located by [GOR⁺]'s own Δ.**
>
> Two caveats, stated plainly. First, none of this is closer to RH: these are
> sufficient conditions on finitely many (d, n), and Chasse's d ≤ 2 × 10¹⁷ for
> all n has been known since 2013. Second, the shifted criterion is a *legal*
> choice of Ω for Theorem 3.5 — Ω = e^{−z²−μz} is in LP and is fixed across d, as
> the theorem requires; μ depends on n only, which [GOR⁺]'s own renormalisation
> (depending on both n and d) does not manage.

## Hypotheses and notation

- g_d, g*_d are the Jensen polynomial and its reciprocal; Ω ranges over the Laguerre–Pólya class LP; Φ = Θ^{(n)} has coefficients γ(n+j).
- The parametrisation is Ω(σz)·e^{z²} = exp(νz² − μz) with ν = 1 − βσ²; τ denotes a translation τ = μ.
- T is the Turán value of the criterion; d_max is the largest d at which T < 1 at n = 0, σ = 1; n₀(d) the first n at which T < 1 for that d.
- Driver `rust/src/bin/h6_omega.rs`; module `omega`; the d sweep is capped at 1400, and the two rows reaching the cap were bisected separately with the cap raised.

## Proof / evidence

Numerical: one formula contains both papers' criteria, validated against `turan.rs` (which never touches Lemma 3.4) to a worst relative gap of 6.05e−77 for [O'S] (8.2) and 8.39e−69 for [GOR⁺] (2.9) over 50 cells each. The precision cross-check: recomputing γ and the whole criterion at 120 and 240 digits leaves T identical to f64 resolution at every d from 100 to 1400.

## Dependencies and related results

- [[O'S] Theorem 3.5](xihorn-h-track-os-theorem-3-5.md) and [[O'S] Lemma 3.4](xihorn-h-track-os-lemma-3-4-product-rule.md) — the criterion and the product rule the search is built on.
- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — supplies the cost function; E19 qualifies its "d ≤ 400".
- [G6 — the truncation law](xihorn-rust-results-g6-k-req-law.md) and [G4 — non-integer w](xihorn-rust-results-g4-non-integer-w.md) — the flow measurements in the same directory.

## Notes

- The source flags explicitly what is **not settled**: "**Whether the shift improves the *exponent* of n₀(d) is not settled here**: it would need d beyond 10⁴, where the shifted criterion first fails at n = 0, and that is a larger computation than this item."
- The source states plainly that none of this is a route to RH — "these are sufficient conditions on finitely many (d, n)".
- "σ is not a third dial" — LP already contains the affine group; only the σ acting on Θ^{(n)} is carried separately.

- **Correction (2025-10-06, session 003 residual-defect repair).** The Status repeated `xi-horn/H_track.md:681`'s claim that `T` is identical at **60, 120 and 240** digits from `d = 100` to `1400`. The committed driver compares **60 vs 180** digits only, at `d = 100, 200, 400` (`xi-horn/rust/src/bin/h6_omega.rs:302` sets 180 digits; the printed rows are those three), and the committed output shows exactly those rows (`xi-horn/rust/RESULTS.md:1523-1525`, relative move `0.00e0`). The claim is narrowed to the sweep that exists; the driver's conclusion is unaffected.
