# T7 — reachable ⊆ `[−N(p), P(p)]`; above the budget the residual tends to `x − P(p)`

**Kind:** Claim
**Status:** PROVED (paper argument, necessity) + VERIFIED (numerical, exact stall values at `p = 2`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T7; §5.4 "The budget is necessary"

## Statement

> **Proposition (PROVED).** If the signed rule ever reaches residual `0` on target `x`, then
> `0 < x ≤ P(p)` (for `x > 0`) or `x < 0` and `−x ≤ N(p)` (for `x < 0`); and the sum of the
> taken terms always satisfies the same bound.

The ledger row states it as: "reachable ⊆ `[−N(p), P(p)]`; above the budget the residual tends to `x − P(p)`". The source's §5.4 sharpening adds: "**Sharpening (VERIFIED).** "Cannot be met" means the residual has a *non-zero limit*, not that the process stops taking terms: above the budget the rule keeps taking the smaller and smaller terms of that sign forever, and `r_n → x − P(p)` (for `x > P(p)`), from above and with the gap halving when the cap doubles — measured `0.188891452 → 0.1887977313` (caps 4k → 16k) against `x − P(2) = 0.1887664833`."

## Hypotheses and notation

- `P(p)`, `N(p)`: the positive/negative budgets (row T2).
- `r_n` is the residual after `n` steps of the signed rule.
- The proposition is stated for the signed rule; at `p ≤ 1` the budget is infinite and the bound is vacuous.

## Proof / evidence

> *Proof.* The taken terms with the sign of `x` are distinct terms of one half-series, whose
> total is that half's budget; the residual is `x` minus their sum, so `|x|` can only be met if
> `|x|` does not exceed the budget. At `p ≤ 1` the budget is infinite (5.2) and the bound is
> vacuous. ∎

Verified at `p = 2`: "`x = 3/5` takes terms summing to `0.411108547957 ≤ P(2) = 0.4112335`, `x = −1/2` to `0.233575612608 ≤ N(2) = 0.2337006`." Below the budget the residual falls to `0`: "measured to `e−10` or exactly `0` when the target is a finite sub-sum, e.g. `x = 1/4` at `p = 2` terminates in one take".

## Dependencies and related results

- Uses the definition of the budgets (T2) and the pole behaviour (T5) for the `p ≤ 1` remark.
- The necessity direction only; the source stresses that the budget is **not** sufficient — see T10/T11/T12 and the gap construction.
- Restates `rh42/truths.md` T7 ("reachable subset of budget"); the lean README lists Budget/Reachable modules but no declaration for this row.

## Notes

- The proposition has a written proof (quoted above); the stall-limit sharpening is `VERIFIED` only.
- Measured figures `0.188891452`, `0.1887977313`, caps `4k → 16k`, `x − P(2) = 0.1887664833`, `0.411108547957`, `0.233575612608` are quoted exactly.
- The source explicitly separates the two statuses: `PROVED` for reachability inside the budget, `VERIFIED` for the limit `r_n → x − P(p)`.
