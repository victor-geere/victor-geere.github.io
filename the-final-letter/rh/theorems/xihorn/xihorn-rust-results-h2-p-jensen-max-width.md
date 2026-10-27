# H2 — P^{d,n} tolerates enclosures 175× to 6.0e9× wider than J^{d,n}

**Kind:** Claim
**Status:** VERIFIED (numerical; interval LDLᵀ certificates, 60 digits)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "H2 — P^{d,n} tolerates enclosures between 175× and 6.0e9× wider than J^{d,n}"

## Statement

> **H2 — P^{d,n} tolerates enclosures between 175× and 6.0e9× wider than
> J^{d,n}, and unlike J its tolerance does not decay in n.** [O'S] (1.4)'s
> family carries the same equivalence to RH ([O'S] Theorem 1.2) under a strictly
> weaker condition ([O'S] Corollary 3.8), and this measures what the weakening
> is worth to a certificate. Same interval LDLᵀ, same Hermite–Hankel form, same
> enclosures — only the coefficients differ.

| d | J `max width` at n = 0 → 30 | P `max width` at n = 0 → 30 | P/J at n = 30 |
|---|---|---|---|
| 2 | 5.035e−3 → 9.443e−4 | 8.790e−1 → 9.281e−1 | 9.8e2 |
| 3 | 7.909e−6 → 3.729e−7 | 5.042e−2 → 5.060e−2 | 1.4e5 |
| 4 | 7.569e−9 → 1.105e−10 | 3.078e−3 → 3.093e−3 | 2.8e7 |
| 5 | 4.421e−12 → 2.323e−14 | 1.395e−4 → 1.403e−4 | 6.0e9 |
| 6 | 1.709e−15 | 5.383e−6 | — |

> Three readings, in rising order of importance:
>
> * **the smallest advantage anywhere is 175×**, at (2, 0). At d = 2, P is
>   decided even when every coefficient is known only to within a factor of
>   two — which is what a `max width` of 0.93 means, 1.0 being the point where
>   the leading coefficient reaches zero and the polynomial loses its degree;
> * **P's cost of degree is ~1.3 decades per unit of d against J's ~3.5**;
> * **P's tolerance is flat in n — it even rises slightly — where J's falls by
>   one to three decades over the same range.** That is the property that
>   matters for G1: a bound on γ(n) good enough for P at n = 0 is good enough
>   for P at every n, while for J the requirement keeps tightening.
>
> The d = 2 case is checked against [O'S] (1.5)/(1.6) exactly: J²ⁿ is hyperbolic
> iff a(n+1)² ≥ a(n)a(n+2), P²ⁿ iff a(n+1)² + 2a(n)² ≥ a(n)a(n+2), and at
> n = 30 the two margins are 1.33e−118 and 1.95e−112 — the 2a(n)² term is six
> decades of free slack.

## Hypotheses and notation

- J^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j; P^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X), H the Hermite polynomials.
- `max width` is a relative enclosure width; P/J compares the two at fixed (d, n).
- Certified for d = 2…6, n = 0…30; driver `bin/h2_pjensen`, modules `hermite`, `jensen`.

## Proof / evidence

Numerical, by the same interval LDLᵀ on the same Hermite–Hankel form with the same enclosures — only the coefficients differ. The d = 2 identities are checked exactly against [O'S] (1.5)/(1.6), with margins 1.33e−118 (J) and 1.95e−112 (P) at n = 30.

## Dependencies and related results

- [[H2 from H_track.md](xihorn-h-track-h2-p-jensen-max-width.md) — the track's account, with the same table.
- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — the certificate this measurement made affordable.
- [H3 — a table neither paper has](xihorn-rust-results-h3-turan-onset.md) — the same asymmetry in the criteria's currency.
- [[O'S] Corollary 3.8](xihorn-todo-os-corollary-3-8.md) — the implication used.

## Notes

- The source's framing: "this measures what the weakening is worth to a certificate" — a cost-of-verification statement, not a statement about hyperbolicity.
- **E16** affects reported slack figures (half compared against full widths); it changes no verdict.
