# The Castelnuovo ledger, and every minor

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh13.html`](../../html/rh13.html) — §4 "The Castelnuovo ledger, and every minor"

## Statement

> Weil's actual inequality on C × C is Castelnuovo–Severi's: for a correspondence, σ(D∘D′) ≤ 2·d(D)d′(D) — degree terms dominate the self-pairing, with the defect controlled by the Hodge index. … the **pole terms** h(±i/2) are the degree terms … the **archimedean integral** is the fiber at infinity … the **gear sum** is the intersection with the Frobenius graphs … and the **spectral side** — forced nonnegative if RH — is the defect.

computed as: Fejér (pole +50.48, archimedean −20.42, orbits −29.89, defect +0.172), a Gaussian at the dip (defect +2.6×10<sup>−2</sup>), and rh12's optimal window (defect +9.6×10<sup>−6</sup>); "each ledger balances against the independently computed spectral side to 6×10<sup>−4</sup>". And:

> all 300 Cauchy–Schwarz ratios |G<sub>jk</sub>|/√(G<sub>jj</sub>G<sub>kk</sub>) of the crossing form, by node distance: everything inside the bound with margin (worst 0.705; worst normalized 2×2 minor +0.50). A single point above 1 would be a negative 2×2 minor — a refutation of RH computable in one line.

## Hypotheses and notation

- The two-ruling dictionary matches the explicit formula term by term to the Castelnuovo–Severi shape on C × C.
- The three window classes are a Fejér window (a = 1.6, t₀ = 0), a Gaussian at the dip, and rh12's optimal window.
- Positivity of a form is equivalent to nonnegativity of all its principal minors, so each of the 300 pairs is an independent micro-instance of the index theorem, testable without an eigensolver.

## Proof / evidence

The source reports the three defect ledgers and their balance against the independently computed spectral side to 6×10<sup>−4</sup>, with nonnegative defects (+0.172, +2.6×10<sup>−2</sup>, +9.6×10<sup>−6</sup>), and all 300 normalized 2×2 minors positive with worst ratio 0.705 (worst normalized minor +0.50). It comments: "The knife edge of the arc lives in the bottom eigenvalue, not in the pairwise structure."

## Dependencies and related results

- [The crossing form: signature (25, 0, 0)](rh13-crossing-form-signature.md) — the matrix whose minors and ledger are computed.
- [The optimal-window frontier D*(a) = 1/(b₀ᵀM⁻¹b₀)](../rh12/rh12-optimal-window-frontier.md) — the extremal window riding the Hodge-index boundary.
- [The explicit formula as a Lefschetz ledger](../rh12/rh12-lefschetz-ledger-balance.md) — rh12's single-instance version of the same ledger.

## Notes


- The ledger shape is Castelnuovo–Severi's (cited; Weil 1948), read through the two-ruling dictionary; the numbers are finite computations on the 25-dimensional slice.
- The source's own summary of §6: "the surface's finite shadows — every one the arc could construct — pass the index test."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
