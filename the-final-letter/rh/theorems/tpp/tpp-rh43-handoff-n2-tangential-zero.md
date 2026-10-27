# N = 2 is balanced exactly at `t = π/log 2` (the tangential zero)

**Kind:** Proposition
**Status:** PROVED (Lean, `balanced_two`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.3 "The reduction, and the answer", §2.4 "The three traps"

## Statement

> * `N = 2`: `t = π/log 2` gives `1 + cos π = 0` **exactly**. The zero is tangential (`1 + cos(t log 2) ≥ 0` everywhere), so a sign-change search misses it — this was the round's first error and is now proved in Lean (`balanced_two`).

From §2.4, the first of the three traps:

> 1. **The `N = 2` tangential zero.** `Re S_2 ≥ 0` with zeros at `(2k+1)π/log 2`. The first draft of both the script and the Lean file said "`N = 2` has no root"; the auditor's certified enclosure killed it. The corrected Lean now contains `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`.

## Hypotheses and notation

- `S_2(t) = 1 + 2^{-it} = 1 + exp(-i t log 2)`; `Re S_2(t) = 1 + cos(t log 2) ≥ 0`.
- Zeros at `t = (2k+1)π/log 2`, `k` integral; the zero at `t = π/log 2` is *tangential*.
- Lean declarations: `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`.

## Proof / evidence

- **PROVED** in Lean ([`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)), declaration `balanced_two`; also `exists_balanced_two`.
- The source records the correction: the first draft of both the script and the Lean file said "`N = 2` has no root"; the auditor's certified enclosure killed it.

## Dependencies and related results

- Harvested truths counterpart: [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md), [T4](tpp-rh43-truths-n2-balanced-ledger.md), [T11 (the exact complex vanishing)](tpp-rh43-truths-s2-exact-vanishing.md).
- Related: [The complex sum is a different question](tpp-rh43-handoff-complex-sum-different-question.md).

## Notes

- The source flags this explicitly as "the round's first error" that has been corrected; the corrected statement is what is harvested here, with the tangential character preserved.
