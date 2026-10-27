# T6 — at `p = 1` every target passes the budget test and the residual falls to `0`

**Kind:** Claim
**Status:** VERIFIED (numerical, max residual `2.29e−6` over six sines, 200k terms, 80 dps)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T6; §5.2

## Statement

> | T6 | at `p = 1` every target passes the budget test and the residual falls to `0` | **VERIFIED** | max residual `2.29e−6` over six sines (200k terms, 80 dps) |

## Hypotheses and notation

- `p = 1`, i.e. the alphabet `α_n = (−1)^n/(n+2)`, `n ≥ 0`, which is `+1/2, −1/3, +1/4, −1/5, …`.
- "the budget test" is the necessary condition of row T7 / §5.4 (`reachable ⊆ [−N(p), P(p)]`); at `p = 1` both budgets are infinite by T5 and the bound is vacuous.
- "residual": `r_{n+1} = r_n − α_n` under the signed rule (take `α_n` iff it has the same sign as the residual and `|α_n| ≤ |r_n|`, otherwise skip it, forever).

## Proof / evidence

> | T6 | at `p = 1` every target passes the budget test and the residual falls to `0` | **VERIFIED** | max residual `2.29e−6` over six sines (200k terms, 80 dps) |

The source's §5.2 gives the reason: "Since both budgets are infinite at `p = 1`, **no** target fails the budget test, which is exactly the page's reason that a sine anywhere in `[−1,1]` can be written. This is the one place where the pole of `ζ` is *used* rather than avoided."

## Dependencies and related results

- Depends on T5 (`P(p), N(p) ~ 1/(2(p−1))`; both budgets are infinite at `p = 1`).
- The companion H4 row in §4 records "at `p = 1` both series diverge" as **PROVED** + **VERIFIED**.
- Restates `rh42/truths.md` T6 ("budget test at p = 1"); the `Rh42/Budget.lean` closed forms and the Lean development do not cover `p = 1` itself.

## Notes

- This is a **numerical** verification (six sines, 200k terms, 80 dps); the source does not claim a proof of convergence at `p = 1` in this row.
- The residual bound `2.29e−6` is finite-precision evidence, not an exact vanishing statement.
