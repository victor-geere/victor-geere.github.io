# 4. Partial sums at `Re S = 0` and the equal split — `rh43`

> Source: [`research/truths.md`](../rh/research/truths.md), §4. Status language is the ledger’s own.

Lean: [`Rh43/Balance.lean`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)
(37 theorems). Prose ledger: [`rounds/rh43/truths.md`](../rh/research/twin-prime-parity/rounds/rh43/truths.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| balance ⟺ zero | `balanced N t ↔ Re S_N(t) = 0` | PROVED (Lean) | [`balanced_iff_realPartial_eq_zero`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L187) |
| equal split | `balanced ↔` equal four-part split of the two halves | PROVED (Lean) | [`balanced_iff_equal_split`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L230) |
| existence `N = 3` | `Re S_3(5/2) < 0 < Re S_3(0)`, so a root exists | PROVED (Lean) | [`exists_realPartial_three_eq_zero`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L350), [`realPartial_three_five_halves_neg`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L330) |
| existence, general | a balanced `(N,t)` exists | PROVED (Lean) | [`exists_balanced_partial_sum`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L359) |
| `N = 2` exact | `Re S_2(π/log 2) = 0` | PROVED (Lean) | [`balanced_two`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L392) |
| `N = 3` no complex zero | `S_3(t) ≠ 0` for all `t` | PROVED (Lean) | [`zetaPartial_three_ne_zero`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L489) |
| not-all-nonzero | `¬ ∀ N t, S_N(t) ≠ 0` | PROVED (Lean) | [`not_forall_zetaPartial_ne_zero`](../rh/research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L458) |

Certification: 64/64, audit 102/102; roots certified for `N = 3…50` (auditor C3).

---
