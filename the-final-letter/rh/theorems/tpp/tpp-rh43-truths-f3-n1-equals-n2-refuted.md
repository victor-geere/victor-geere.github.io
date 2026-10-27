# F3 — "N = 1 is the same as N = 2"

**Kind:** Claim
**Status:** REFUTED (witness: `N = 1` is the only case with no negative part)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F3 | "`N = 1` is the same as `N = 2`" | `N = 1` is the *only* case with no negative part (`Re S_1 ≡ 1`); `N = 2` has both parts non-degenerate. |

## Hypotheses and notation

- `N = 1`: `Re S_1 ≡ 1`, one positive part `P_1 = 1` and no negative part.
- `N = 2`: both parts are non-degenerate — at `t = pi/log 2`, `P_2 = 1` and `M_2 = -1`.

## Proof / evidence

- Ledger row F3: status "**REFUTED**", evidence "§5, with witnesses".
- The positive halves of the witness are [N = 1 is degenerate](tpp-rh43-truths-n1-degenerate.md) (T3) and [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md) (T4), with Lean declarations `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two`.

## Dependencies and related results

- Related: [Theorem 10 (balance needs only the real equation)](tpp-rh43-truths-balance-needs-only-real-equation.md), which cites `N = 1` as having no negative part.

## Notes

- Ledger row F3 is recorded in the source's refutation table; it is a claim the source explicitly falsifies, not a result of the round.
