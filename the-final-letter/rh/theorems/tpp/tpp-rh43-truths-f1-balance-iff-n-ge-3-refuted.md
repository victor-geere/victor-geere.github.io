# F1 — "the split can be balanced iff N >= 3"

**Kind:** Claim
**Status:** REFUTED (smallest witness `N = 2`, `t = pi/log 2`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F1 | "the split can be balanced **iff** `N >= 3`" | `N = 2`, `t = pi/log 2`: `Re S_2 = 0` exactly, `P = 1 = |M|`. The zero is tangential, so a sign-change scan misses it. |

## Hypotheses and notation

- The falsified claim is the biconditional: balance holds exactly when `N >= 3`.
- Witness: `N = 2`, `t = pi/log 2`, where `Re S_2(t) = 1 + cos(t log 2) = 0` and `P = 1 = |M|` (the terms are `+1` and `−1`).

## Proof / evidence

- Ledger row F1: status "**REFUTED**", evidence "§5, with witnesses".
- The witness is proved in Lean (`balanced_two`, `realPartial_two_pi_div_log_two`) — see [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md).
- HANDOFF.md §5 banks the correction: "the split can be balanced iff `N ≥ 3`" — false; `N = 2` balances at `π/log 2`.

## Dependencies and related results

- Contradicts [Theorem 3 (N = 2 is balanced)](tpp-rh43-truths-n2-balanced-tangential.md) only in the sense of being its negation; the corrected statement is that theorem.
- Related: [F2 (N = 2 has no root)](tpp-rh43-truths-f2-n2-no-root-refuted.md).

## Notes

- The source records that this was the round's first error and that the corrections are recorded rather than deleted (truths.md §5 closing paragraph).
