# C3 / C5 — `S_2` vanishes exactly at `t = (2k+1)π/log 2` (two round claims refuted)

**Kind:** Claim
**Status:** REFUTED (the round's claims "`N=2` has no root" and "no exact complex vanishing for `N ≤ 6`", by the exact witness `S_2(π/log2) = 1 + e^{−iπ} = 0`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh43, "What it establishes" (lines 217–228); *Corrections and discrepancies*, item 8 (lines 805–808)

## Statement

> * **C3 `N=2` "no root" — REFUTED.** `Re S_2(t) = 1 + cos(t log 2) ≥ 0` with tangential zeros, and `S_2` vanishes **exactly** at `t=(2k+1)π/log 2`.
> * **C5 "no exact complex vanishing for `N ≤ 6`" — REFUTED** by `N=2` (`S_2(π/log2) = 1 + e^{−iπ} = 0` exactly).

The register's *Corrections* item 8 restates it:

> **rh43's three refuted round claims.** "`N=2` has no root" and "no exact complex vanishing for `N ≤ 6`" are both refuted by `N=2` (`Re S_2` has tangential zeros; `S_2(π/log 2) = 0` exactly).

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it} = Σ_n e^{−it log n}`; `S_N = i t` in the round's convention, so `Re S_N = Σ cos(t log n)`.
- At `N=2`: `Re S_2(t) = 1 + cos(t log 2) ≥ 0`, with zeros of even (tangential) order at `t = (2k+1)π/log 2`.
- The complex vanishing is exact: `S_2(π/log2) = 1 + e^{−iπ} = 0`.

## Proof / evidence

- Stated in the register's "What it establishes" for rh43 as two of "Three **refutations** of the round's own stated claims, with certificates".
- `rh43/zeta_split.py` → `rh43/verify/zeta_split.log` (**`64 checks pass, 0 fail`**); auditor `rh43/verify/independent_check.py` → `independent_check.log` (**`102/102 checks pass`**, `EXIT=0`); `rh43/verify/positive_only_split.py` → `positive_only_split.log` (**`15 checks pass, 0 fail`**).
- For `N=3` the register records the companion *proof*: "For `N=3` the non-vanishing of `S_3` for **all** `t` is a genuine proof (irrationality of `log 3/log 2`)."

## Dependencies and related results

- The third refutation of the same round ("`|S_N|` grows like `N^{1/2}`", refuted with the Euler-summation lower bound) is a separate entry of this harvest: `tpp-checks-06-c6-linear-growth-lower-bound.md`.
- The register's *Corrections* item 8 collects the three refutations.

## Notes

- The two claims refuted here share the single witness `N=2`; they are kept in one file because the source states them as one pair of refutations with one certificate.
- The register's own warning on the companion `N = 4, 5, 6` situation: "**C5 for `N = 4, 5, 6` is PARTIAL**, and says so. Only certified *lower bounds* on the window `[0,15]` are offered (`|S_4| > 3.0779e-1`, `|S_5| > 2.1911e-3`, `|S_6| > 7.7536e-4`); the grid minima on `[0,60]` are explicitly labelled "NOT a lower bound", and no non-vanishing proof over all `t` exists."
