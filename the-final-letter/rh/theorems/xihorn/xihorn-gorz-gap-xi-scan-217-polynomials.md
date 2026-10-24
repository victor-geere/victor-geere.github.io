# ξ scan: all 217 polynomials with 2 ≤ d ≤ 8 and 0 ≤ n ≤ 30 are hyperbolic

**Kind:** Claim
**Status:** VERIFIED (numerical, 60 decimal digits; max |Im root| = 0 exactly at 60 dps; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §7.5 "ξ itself, and one thing Theorem 2 does not say"

## Statement

> For ξ's own sequence a(n), all 217 polynomials with 2 ≤ d ≤ 8 and 0 ≤ n ≤ 30 are hyperbolic — **max |Im root| = 0 exactly at 60 decimal digits** — so E(d) ∩ [0, 30] = ∅ across the scanned band and the nesting of Theorem 1 is vacuously satisfied there.

## Hypotheses and notation

- a(n) = γ(n)·n!/(2n)!, γ(n) = 4∫₀^∞ u^{2n}·Φ(u) du — ξ's own Jensen sequence (equations (2)–(3)); numerically a(0) = 0.49712077819, a(1) = 0.011485972158, a(2) = 2.4690403614e−4, a(3) = 4.9941328883e−6.
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic }.
- The scan covers 2 ≤ d ≤ 8, 0 ≤ n ≤ 30: 217 polynomials; mpmath at 50–60 decimal digits for the ξ moments (§8).

## Proof / evidence

The source reports the scan and immediately bounds what it proves, verbatim: "This is consistent with [GOR⁺] Corollary 1.3 and proves nothing beyond it."

The source's §8 table records "ξ scan: 2 ≤ d ≤ 8, 0 ≤ n ≤ 30 (217 polynomials) | max \|Im root\| = 0 exactly at 60 dps; E(d) ∩ [0,30] = ∅".

## Dependencies and related results

- [GOR⁺] Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)) already covers d ≤ 9 × 10²⁴ at every shift.
- [Theorem 1 (nesting)](xihorn-gorz-gap-t1-nesting.md): the nesting is vacuous on the scanned band, since no exception appears.
- The same section records the open question this scan does not settle: whether ξ's own E(d) are initial segments.

## Notes


- The source's own hedge is part of the record: the scan "proves nothing beyond" [GOR⁺] Corollary 1.3.
- §7.5 also records the boundary of [Theorem 2](xihorn-gorz-gap-t2-initial-segment.md): "Theorem 2 says the *union* E_∞ is an initial segment. It does **not** say each E(d) is… Whether ξ's own E(d) are initial segments is open and is not needed for anything above." The companion file `initial-segments.md`, cited by the source, answers the question for the ambient class, not for ξ.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
