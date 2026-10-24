# The complex sum is a different question: S_2(π/log 2) = 0 exactly, S_3(t) ≠ 0 for every t

**Kind:** Proposition
**Status:** PROVED (Lean, `zetaPartial_two_pi_div_log_two`, `zetaPartial_three_ne_zero`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.4 "The three traps"

## Statement

> 2. **The complex sum is a different question.** `S_2(π/log 2) = 0` exactly, while `S_3(t) ≠ 0` for *every* real `t` — proved in Lean (`zetaPartial_three_ne_zero`) by reducing to `m log 2 = n log 3`, i.e. `3^|n| = 2^|m|`. A blanket "the complex partial sum never vanishes" is false and was removed.

In the table of §2.2 this is reading **R3**:

> | **R3** the complex partial sum vanishes | `S_N(t) = 0` | different question: `N = 2` yes (exactly), `N = 3` provably no, `N ≥ 4` open (T10–T11) |

## Hypotheses and notation

- `S_2(t) = 1 + exp(-i t log 2)`; at `t = π/log 2`, `S_2 = 1 + exp(-iπ) = 0` exactly.
- `S_3(t) = 1 + 2^{-it} + 3^{-it}`; the proof reduces `S_3(t) = 0` to `m log 2 = n log 3`, i.e. `3^{|n|} = 2^{|m|}`.
- The `N ≥ 4` case is **OPEN**.

## Proof / evidence

- **PROVED** in Lean ([`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)): `zetaPartial_two_pi_div_log_two` (the exact vanishing) and `zetaPartial_three_ne_zero` (non-vanishing for every real `t`).
- The blanket statement "the complex partial sum never vanishes" is refuted at `N = 2` and was removed (Lean: `not_forall_zetaPartial_ne_zero`).

## Dependencies and related results

- Harvested truths counterparts: [S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md) (T11), [S_3(t) != 0](tpp-rh43-truths-s3-nonvanishing.md) (T10), [F4](tpp-rh43-truths-f4-complex-never-vanishes-refuted.md).
- Related: [The reduction: `P_N + M_N = Re S_N`](tpp-rh43-handoff-reduction-to-real-equation.md) — the round's question needs only the real equation.

## Notes

- HANDOFF.md §5 banks two corrections in this area: "the complex partial sum never vanishes for `N ≥ 2`" is false at `N = 2`, and "it vanishes for `N = 3`" is also false, provably.
- The `N ≥ 4` case is open (§6), so this harvested statement must not be read as a general vanishing result.
