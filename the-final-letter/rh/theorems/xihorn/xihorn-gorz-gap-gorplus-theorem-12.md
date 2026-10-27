# [GOR⁺] Theorem 1.2 — verified zeros give coverage in d

**Kind:** Theorem
**Status:** CITED (literature — Griffin, Ono, Rolen, Thorner, Tripp, Wagner, Adv. Math. **397** (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §1.3 "The exception sets, and the gap", quoted theorem box; also quoted in [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) §4

## Statement

> **[GOR⁺] Theorem 1.2.** *If RH_m(T) is true and d ≤ ⌊T⌋², then J_{d,n}(X) is hyperbolic for all n ≥ m.*

## Hypotheses and notation

- RH_m(T) is the statement that the Riemann hypothesis holds for the zeros with imaginary part up to height T and, per the companion source's reading, that no zero above m violates RH_n for n < m; the companion writes the same statement with the floor removed: "If RH_m(T) is true and d ≤ T², then J_{d,n}(X) is hyperbolic for all n ≥ m."
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); hyperbolic = all zeros real.
- The source calls this "the finite-d band"; the companion source calls it "the only mechanism in either paper that converts knowledge *about zeros* into coverage *in d*, and its exchange rate is d ≤ T²".

## Proof / evidence

The source quotes it without proof. Its use in the source is via the corollary: "(Corollary 1.3 is Theorem 1.2 fed with Platt–Trudgian's verification of RH₀(3 000 175 332 800); 3 000 175 332 800² = 9.001 × 10²⁴. …)"

The companion source §4 amplifies: "Covering all d at that rate needs T = ∞ — i.e. the input is RH itself. That is the precise sense in which C1 is the whole difficulty and not a technical gap."

## Dependencies and related results

- Feeds [GOR⁺] Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)); Platt–Trudgian's verification of RH₀(3 000 175 332 800) is the input.
- Referenced by [Corollary 6](xihorn-gorz-gap-c6-hardest-shift-nearly-easiest.md) through Corollary 1.3's bound D\* > 9 × 10²⁴.
- Companion harvest: [xihorn-uniformity-gorplus-theorem-12.md](xihorn-uniformity-gorplus-theorem-12.md).

## Notes

- The source records [GOR⁺] Remark (3) about the converse being unlikely: a converse to Theorem 1.2 is "highly unlikely … unless one has hyperbolicity for all n ≥ m and all d ≥ 1", with Jensen polynomials "ultimately quite inefficient at detecting zeros that violate RH_n".
- The small discrepancy in the two quoted forms (⌊T⌋² here, T² in the companion file) is present in the sources as quoted and is reproduced, not reconciled.
