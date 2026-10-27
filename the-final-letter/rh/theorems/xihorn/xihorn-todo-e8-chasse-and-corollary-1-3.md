# Chasse 2013 and [GOR⁺] Corollary 1.3 — hyperbolicity up to d ≤ 9 × 10²⁴

**Kind:** Theorem
**Status:** CITED (literature — Chasse 2013, via Borcea–Brändén and Obreschkoff; and [GOR⁺] Corollary 1.3 using Platt–Trudgian)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §E "Corrections already applied", entry E8

## Statement

> **E8. B1's statement is not new — it is Chasse 2013.** Chasse proved
> J_{d,n} hyperbolic for **all n ≥ 0 and d ≤ 2 × 10¹⁷** ([Cha13], via
> Borcea–Brändén and Obreschkoff); [GOR⁺] Corollary 1.3 extends that to
> **d ≤ 9 × 10²⁴** using Platt–Trudgian's verification of RH₀ to 3 × 10¹².

## Hypotheses and notation

- J_{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j is the Jensen polynomial of ξ; hyperbolic = all zeros real.
- Chasse's range: all n ≥ 0 and d ≤ 2 × 10¹⁷, proved via Borcea–Brändén and Obreschkoff.
- [GOR⁺] Corollary 1.3 extends the range to d ≤ 9 × 10²⁴, using Platt–Trudgian's verification of RH₀ to 3 × 10¹².
- B1's 35 polynomials sit at d ≤ 6, n ≤ 30 — inside the known range by twenty-four orders of magnitude.

## Proof / evidence

The source quotes both results without proof and gives the citations ([Cha13] for the first; [GOR⁺] Corollary 1.3 for the second). No argument is reproduced.

## Dependencies and related results

- [B1 — certified discriminant signs](xihorn-rust-results-b1-certified-discriminant-signs.md) and [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — the results this entry says are not new; "What B1 actually contributes is a **pipeline** … not a theorem, and **G1 and G2 must be read that way**".
- [G2 — the frontier as a staircase](xihorn-rust-results-g2-frontier-staircase.md) — "The gap between d ≈ 8 and 2 × 10¹⁷ is the honest measure of what this pipeline is".
- Harvested from the same family elsewhere in the workspace as [[GOR⁺] Corollary 1.3](xihorn-uniformity-gorplus-corollary-13.md).

## Notes

- The source states the consequence plainly: extending B1's range "proves nothing new"; only G1 (making *this* route rigorous) and H3 (where the Turán criteria actually switch on) "have anything left to find".
