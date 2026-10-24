# T6 — at p = 1 every target passes the budget test

**Kind:** Claim
**Status:** VERIFIED (numerical, `helix_zeta.py` §3)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §11 "The handoff ledger, item by item", row T6

## Statement

> | id | statement | was | now | where |
> |---|---|---|---|---|
> | T6 | at `p = 1` every target passes the budget test | VERIFIED | **VERIFIED** (unchanged) | `helix_zeta.py` §3 |

## Hypotheses and notation

- `p = 1`.
- "Passes the budget test" means the target's magnitude is within the corresponding budget at `p = 1`.
- The two budgets are infinite at `p = 1` (Theorem 4: `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1`).

## Proof / evidence

The ledger row cites `helix_zeta.py` §3 (the round's original budget/criterion investigation, unchanged and re-run: **80/80 checks pass**, `verify/helix_zeta_rerun.log`). The §2 note of Theorem 4 gives the reason: "Since both budgets are infinite at `p = 1`, no target fails the budget test there — this is the page's reason that every sine is writable at `p = 1`."

## Dependencies and related results

- [Theorem 4 (T5, H4)](tpp-rh42-truths-theorem-4-pole-asymptotics.md) — the divergence of both budgets at `p = 1`.
- [T7 — reachable ⊆ budget; above it, residual → x − P(p)](tpp-rh42-truths-t7-reachable-subset-of-budget.md) — the companion row about the budget test in general.

## Notes

- The ledger records the status as unchanged: VERIFIED before and after this round.
- This row is harvested because §11 is a ledger table of results and the row states a mathematical fact not otherwise labelled as a theorem in this file.
