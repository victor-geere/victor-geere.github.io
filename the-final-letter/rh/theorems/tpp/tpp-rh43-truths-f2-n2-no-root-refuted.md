# F2 — "N = 2 has no root of Re S_2"

**Kind:** Claim
**Status:** REFUTED (smallest witness: the roots themselves, `t = (2k+1) pi/log 2`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F2 | "`N = 2` has no root of `Re S_2`" | false: the roots are `t = (2k+1) pi/log 2`, the smallest `pi/log 2 = 4.5323601418271938096276829457166668` (74-digit certified). |

## Hypotheses and notation

- The falsified claim: `Re S_2(t) = 1 + cos(t log 2)` has no zero.
- The actual zero set is `t = (2k+1) pi/log 2` for integer `k`; the smallest positive root is `pi/log 2 = 4.5323601418271938096276829457166668` (74-digit certified).

## Proof / evidence

- Ledger row F2: status "**REFUTED**", evidence "§5, with witnesses".
- The corrected statement is proved in Lean (`realPartial_two_pi_div_log_two`, `balanced_two`) and verified in the script §2 with 74-digit certified enclosures by the auditor — see [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md).
- HANDOFF.md §2.4/§5 banks the correction: "The first draft of both the script and the Lean file said '`N = 2` has no root'; the auditor's certified enclosure killed it."

## Dependencies and related results

- Corrected by [Theorem 3 (N = 2 is balanced)](tpp-rh43-truths-n2-balanced-tangential.md).
- Related: [F1](tpp-rh43-truths-f1-balance-iff-n-ge-3-refuted.md).

## Notes

- The root is **tangential** (`Re S_2 >= 0` everywhere), which is why a sign-change scan misses it.
