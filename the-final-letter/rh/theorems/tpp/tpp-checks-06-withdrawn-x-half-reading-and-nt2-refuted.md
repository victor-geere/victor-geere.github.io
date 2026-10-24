# The withdrawn `x^{1/2+ε}` reading and the `N ≳ T²` cost claim

**Kind:** Claim
**Status:** REFUTED (the `N ≳ T² = 200` resolution cost, by four-point non-detection with growing values; the `x^{1/2+ε}` reading is **WITHDRAWN** as unverified)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh45, "Headline numbers" (lines 431–434) and "What it establishes" / "What it does not" (lines 446–471); *Corrections and discrepancies*, items 8 and 11

## Statement

> Cost of the partial-sum route (C4.1, **REFUTED**): `Re S_N(1/2+it_1)` has **no** sign change within `±10^{−3}` of `t_1` for `N ∈ {10^3,10^4,10^5,10^6}`; the values `0.644382, 6.986419, 12.538622, 36.051590` **grow** like `≈0.04√N`. The suggested `N ≳ T² = 200` is far too optimistic.

> * `N ≳ T²` for resolving `γ₁` is refuted: the sharp Dirichlet partial sum gets *worse* as `N` grows on `Re s = ½`.

And, from the register's other sentences:

> * C4.1's refutation is a non-detection at four values of `N`; it refutes the specific cost estimate, and shows the quantity diverges, but is not a theorem about all `N`.
> * The "RH-conditional `x^{1/2+ε}`" reading is **WITHDRAWN** (auditor check B4): since `n ↦ λ(n)λ(n+2)` is not multiplicative, no Euler product exists, and no standard theorem derives the bound from RH.

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}`; `t_1 = γ₁ = 14.134725141734693790457251983562` (the first zero ordinate), `T = |t_1|`.
- The tested `N` values are `10^3, 10^4, 10^5, 10^6`; the tolerance around `t_1` is `±10^{−3}`.
- The withdrawn reading is `max|S| = O(x^{1/2+ε})` for `S(x) = Σ_{n≤x} λ(n)λ(n+2)` (auditor check B4).

## Proof / evidence

- C4.1: the register's "Headline numbers" for rh45 gives the four values `0.644382, 6.986419, 12.538622, 36.051590`, growing like `≈0.04√N`, with no sign change within `±10^{−3}` of `t_1`.
- Sources: `rh45/verify/independent_check.py` → `rh45/verify/independent_check.log` (**`FINAL: 19/21 checks pass (t=307.2s)`**); the two FAILs in that log are `C1e` and `C4.1`.
- The withdrawal is auditor check B4, recorded in the register's *Corrections* item 11 and in the "What it does not" list of § rh46.

## Dependencies and related results

- The rh45 corrected-convention entry of this harvest; the non-multiplicativity / no-Euler-product entry (the reason the `x^{1/2+ε}` reading has no standard derivation).
- *Corrections* items 4, 11, 13 of the same register.

## Notes

- The register's own limit on the refutation: "C4.1's refutation is a non-detection at four values of `N`; it refutes the specific cost estimate, and shows the quantity diverges, but is not a theorem about all `N`."
- *Corrections* item 11, quoted exactly: "The 'RH-conditional `x^{1/2+ε}`' reading of `max|S|` is recorded as **WITHDRAWN / unverified** (auditor B4)".
- The two items are harvested together because the register states them as the two verdicts of the same partial-sum route (§ rh45, "What it does not").
