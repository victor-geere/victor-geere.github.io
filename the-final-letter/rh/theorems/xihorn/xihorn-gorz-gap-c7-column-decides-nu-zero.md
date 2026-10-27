# Corollary 7 (the column decides ν = 0 — classical, recovered)

**Kind:** Corollary
**Status:** CITED (literature — the Jensen–Pólya criterion at shift 0, "a century old"; the source also recovers it from its ladders)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §4 "Four corollaries", Corollary 7

## Statement

> **Corollary 7 (the column decides ν = 0 — classical, recovered).** ν = 0 ⟺ J_{d,0} is hyperbolic for every d ≥ 1.

## Hypotheses and notation

- ν := min{ n ≥ 0 : F^{(n)} ∈ LP } (equation (8)); F(z) = Ξ(√−z).
- J_{d,0}(X) = Σ_{j=0}^{d} C(d,j)·a(j)·X^j, the shift-0 column of the Jensen family (equation (4)).
- LP is the Laguerre–Pólya class; by (5), RH ⟺ F ∈ LP ⟺ J_{d,n} hyperbolic for all d ≥ 1, n ≥ 0.

## Proof / evidence

The source's proof, verbatim: "ν = 0 means F ∈ LP, and [O'S] Corollary 3.2 at n = 0 says exactly F ∈ LP ⟺ J_{d,0} hyperbolic for all d ≥ 1. The ladders give the same thing without re-invoking Pólya–Schur: if some J_{d,n} is not hyperbolic, n applications of L3(i)'s contrapositive make J_{d+n,0} not hyperbolic — this is Corollary 5 read at D = ∞ — and conversely ν = 0 makes every J_{d,n} hyperbolic by (5). ∎"

The source's own provenance statement, verbatim: "Unlike Corollaries 4–6 this statement is not new: it is the Jensen–Pólya criterion at shift 0, a century old. It is stated because of what it makes explicit next to Theorem 3: RH — ν = 0, by (5) — is a statement about the **single column n = 0**, of which Corollary 5 is the finite-degree shadow (D checks on the column certify the triangle d + n ≤ D) and [GOR⁺] Corollary 1.3 is the column verified through d ≤ 9 × 10²⁴. The column reads the alternative 'ν = 0 versus ν ≥ 1' and nothing finer: no finite prefix of it computes the value of ν."

## Dependencies and related results

- Cited [O'S] Corollary 3.2 ([harvested](xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md)); [Lemma L3](xihorn-gorz-gap-l3-propagation.md); [Corollary 5](xihorn-gorz-gap-c5-column-reduction.md) at D = ∞; equation (5) = [O'S] Theorem 1.1 as quoted in the source.
- [GOR⁺] Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)) is the same column verified through d ≤ 9 × 10²⁴.

## Notes

- Status is CITED because the source explicitly disclaims novelty: "this statement is not new: it is the Jensen–Pólya criterion at shift 0, a century old." The file records the source's own proof of it as well as the citation.
- The source's §11 dictionary entry "the column decides ν = 0" restates this row; the round that restates it is §11 of the same source file.
