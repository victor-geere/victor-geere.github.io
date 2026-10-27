# [GORZ19] Theorem 1 — hyperbolicity for all sufficiently large shifts

**Kind:** Theorem
**Status:** CITED (literature — Griffin, Ono, Rolen, Zagier, PNAS **116** (2019) 11103–11110, quoted through [O'S] p. 1)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §1.3 "The exception sets, and the gap", quoted theorem box

## Statement

> **[GORZ19] Theorem 1** (as quoted by [O'S] p. 1). *For every fixed d, J_{d,n}(X) is hyperbolic for all sufficiently large n.*

## Hypotheses and notation

- d is fixed; the statement is per-degree, not uniform in d.
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); hyperbolic = all zeros real.
- Equivalent form given by the source: "i.e. N(d) < ∞ and #E(d) < ∞ for each d", where E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic } and N(d) := 1 + max E(d) (:= 0 if E(d) = ∅).

## Proof / evidence

The source quotes it without proof (it is the literature input that defines the GORZ gap): "The residue — call it the **GORZ gap** — is that nobody controls the exceptions *uniformly in d*: for each *d* finitely many *n* may fail, and no bound on how many, or on where they sit, survives as *d* → ∞."

## Dependencies and related results

- Effective form, quoted in the same section: [GOR⁺] Theorem 1.1 ([harvested](xihorn-gorz-gap-gorplus-theorem-11.md)); finite-d band: [GOR⁺] Theorem 1.2 and Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)).
- The source's uniform strengthening is [Theorem 3 (the uniformity constant)](xihorn-gorz-gap-t3-uniformity-constant.md).

## Notes

- The source's status table records "N(d) < ∞ for each d | [GORZ19] Theorem 1".
- The quote is second-hand: the source says it is "[as quoted by [O'S] p. 1]", and the file's closing bibliography notes "Quotes above were re-extracted from the two local PDFs for this file, not copied from elsewhere in the directory."
