# Theorem 4 (T5, H4)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED numerically at p = 1.001)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §2 "The budgets and their algebra"

## Statement

> `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1`: the pole of `ζ` appears **once on each side, halved**.

## Hypotheses and notation

- `p ↓ 1` (approach from above).
- `P(p) = Σ_{k≥1} (2k)^{−p}` (positive budget), `N(p) = Σ_{k≥1} (2k+1)^{−p}` (negative budget).
- `ζ` has a simple pole at `p = 1`; the asymptotic constant is `1/2` on each side.

## Proof / evidence

> **PROVED** (`2^{−p} → 1/2`, `1 − 2^{−p} → 1/2`) and **VERIFIED**: `P(1.001) = 499.942…`,
> `N(1.001) = 499.635…`.

## Dependencies and related results

- Uses the even/odd splitting of `ζ` of Theorem 2.
- Handoff ledger row T5 (§11): "`P ~ N ~ 1/(2(p−1))` at the pole", PROVED+VERIFIED before and after.
- Related ledger row T6 (§11): "at `p = 1` every target passes the budget test" — the source's comment below; harvested separately as [T6 — at p = 1 every target passes the budget test](tpp-rh42-truths-t6-budget-test-at-p-1.md).

## Notes

- The source immediately draws the consequence, quoted verbatim: "Since both budgets are infinite at `p = 1`, no target fails the budget test there — this is the page's reason that every sine is writable at `p = 1`."
- The numerical values `P(1.001) = 499.942…` and `N(1.001) = 499.635…` are quoted exactly as printed.
