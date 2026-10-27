# Log-concavity of γ — [GOR⁺] Theorem 2.1 and [O'S] (1.5) (Csordas–Norfolk–Varga 1986)

**Kind:** Theorem
**Status:** CITED (literature — Csordas–Norfolk–Varga, Trans. Amer. Math. Soc. **296** (1986) 521–541; restated by [GOR⁺] Theorem 2.1 and [O'S] (1.5))
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §A1 "Verify every citation flagged 'from memory'"

## Statement

> `[x]` **Csordas–Norfolk–Varga 1986** — *The Riemann hypothesis and the Turán
> inequalities*, Trans. Amer. Math. Soc. **296** (1986) 521–541. Confirmed by
> both papers. [GOR⁺] Theorem 2.1 restates it in our γ: **γ(n−2)γ(n) ≤ γ(n−1)²
> for n ≥ 3**, i.e. log-concavity — which `rust` already tests
> (`the_laguerre_polya_sequence_is_log_concave`). [O'S] (1.5) gives the same
> thing as "J₂,ₙ hyperbolic ⟺ γ(n+1)² ≥ γ(n)γ(n+2)", first proved for all
> n ≥ 0 in [CNV86].

## Hypotheses and notation

- γ(n) = n!/(2n)!·ξ^{(2n)}(½) is this directory's coefficient (also written a(n)); the classical Turán inequality here is γ(n−2)γ(n) ≤ γ(n−1)² for n ≥ 3.
- The [O'S] (1.5) form is the equivalence: J₂,ₙ hyperbolic ⟺ γ(n+1)² ≥ γ(n)γ(n+2), stated for all n ≥ 0.
- J_{2,n} is the degree-2 Jensen polynomial; "hyperbolic" = all zeros real (for a quadratic, discriminant ≥ 0).

## Proof / evidence

The source states the citation as verified against the papers and records that the crate tests the inequality directly: `the_laguerre_polya_sequence_is_log_concave`. It gives no proof.

## Dependencies and related results

- [H2 — P^{d,n} and what it is worth to a certificate](xihorn-h-track-h2-p-jensen-max-width.md) — the d = 2 cells of its table are where this inequality is checked against [O'S] (1.5)/(1.6).
- [B1 — certified discriminant signs](xihorn-rust-results-b1-certified-discriminant-signs.md) — the certified route through the same polynomials.

## Notes

- The source's framing is that of a citation audit (A1): "Four sat in the text unverified. **The two PDFs settle two of them**"; this is one of the two.
- The source also notes elsewhere (§D, dead ends) that log-concavity of the **raw moments** is forced log-*convex* by Cauchy–Schwarz for any positive weight and "carries no information" — a different sequence from the γ above; do not conflate the two.
