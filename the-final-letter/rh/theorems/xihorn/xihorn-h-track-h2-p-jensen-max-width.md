# H2 — P^{d,n}, and what it is worth to a certificate

**Kind:** Claim
**Status:** VERIFIED (numerical; interval LDLᵀ certificates, 60 digits)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H2 "P^{d,n}, and what it is worth to a certificate"

## Statement

> Both families are certified by *identical* arithmetic — the discriminant is
> lc^{2d−2}·det H for the Hankel matrix of power sums, H positive definite ⟺ all
> d roots real and simple, decided by an interval LDLᵀ — so their tolerances are
> directly comparable. The measure is **`max width`**: the largest relative
> enclosure *half*-width on each γ(n) at which the sign is still decided, found
> by bisection with a ceiling of 1.

| d | J `max width`, n = 0 → 30 | P `max width`, n = 0 → 30 | P/J at n = 30 |
|---|---|---|---|
| 2 | 5.035e−3 → 9.443e−4 | 8.790e−1 → 9.281e−1 | 9.8e2 |
| 3 | 7.909e−6 → 3.729e−7 | 5.042e−2 → 5.060e−2 | 1.4e5 |
| 4 | 7.569e−9 → 1.105e−10 | 3.078e−3 → 3.093e−3 | 2.8e7 |
| 5 | 4.421e−12 → 2.323e−14 | 1.395e−4 → 1.403e−4 | 6.0e9 |
| 6 | 1.709e−15 | 5.383e−6 | — |

> - Every P certifies wherever J does — Corollary 3.8, confirmed on all 35 cells.
> - **The smallest advantage anywhere is 175×**, at (2, 0). At d = 2, P's sign
>   survives every coefficient being wrong by a factor of two: `max width` 0.93
>   against the scale's end at 1.0, where the leading coefficient reaches zero
>   and the polynomial loses its degree.
> - **P's cost of degree is ~1.3 decades per unit of d, against J's ~3.5.**
> - **P's tolerance is flat in n — it even rises slightly — where J's falls by
>   one to three decades over the same range.** This is the property that
>   matters and it was not predicted: a bound on γ(n) good enough for P at n = 0
>   is good enough for P at *every* n, whereas J's requirement keeps tightening.
> - The d = 2 identities check exactly against [O'S] (1.5)/(1.6): at n = 30 the
>   J margin is 1.33e−118 and the P margin 1.95e−112 — the 2γ(n)² term is six
>   decades of free slack.
>
> **This moved item G1's target by twelve orders of magnitude**, from 3.6e−18 at
> (6, 30) to 5.4e−6 at d = 6, flat in n.

## Hypotheses and notation

- J^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j ([GOR⁺] (1.2)); P^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X) ([O'S] (1.4)), H the Hermite polynomials.
- `max width` is a relative enclosure **half**-width (cf. **E16**); 1.0 is the scale's end, where the leading coefficient reaches zero and the polynomial loses its degree.
- Certified for d = 2…6, n = 0…30 (35 cells); driver `rust/src/bin/h2_pjensen.rs`, modules `hermite`, `jensen`; 60 digits.

## Proof / evidence

Numerical, by interval arithmetic: the discriminant is lc^{2d−2}·det H for the Hankel matrix of Newton power sums, and H is positive definite ⟺ all d roots are real and simple, decided by an interval LDLᵀ with no square roots and no division by a sign-unknown quantity. One factorisation yields both the verdict and det H, since the pivots multiply to it. Both families are certified by identical arithmetic, so the `max width` columns are directly comparable.

## Dependencies and related results

- [O'S] Corollary 3.8 — [harvested](xihorn-h-track-os-corollary-3-8.md) — J hyperbolic ⟹ P hyperbolic; confirmed on all 35 cells.
- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — the certificate H2 said was missing.
- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the same asymmetry read in the criteria's own currency (57×).
- [B1 — certified discriminant signs](xihorn-rust-results-b1-certified-discriminant-signs.md) — the conditional version at d ≤ 6, n ≤ 30.

## Notes

- The source's reading is explicitly about *cost of certification*, not about hyperbolicity; it stresses "**This moved item G1's target by twelve orders of magnitude**".
- **E16** (half-width compared against full width) affects reported slack figures, not verdicts; G1's slack at the tightest demand is 33×, not the 16.5× first published.
