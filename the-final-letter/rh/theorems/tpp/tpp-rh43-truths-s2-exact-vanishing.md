# T11 — S_2(pi/log 2) = 0 exactly

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`) + VERIFIED (numerical, 74-digit certified)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T11 (§2 "The complex picture")

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T11 | `S_2(pi/log 2) = 0` exactly | **PROVED**+**VERIFIED** | §2, Lean `zetaPartial_two_pi_div_log_two` |

The §2 prose states this as part of Theorem 8's contrast: at `N = 2`, `2^{-it} = -1` is exactly `t = (2k+1) pi/log 2`; `S_2(pi/log 2) = 1 + e^{-i pi} = 0` exactly (truths.md §5, F4).

## Hypotheses and notation

- `S_2(t) = 1 + 2^{-it} = 1 + exp(-i t log 2)`; at `t = pi/log 2`, `S_2 = 1 + exp(-i pi) = 0` exactly.
- `t = (2k+1) pi/log 2` is the full zero set for `N = 2`, `k` integral.

## Proof / evidence

- Lean declaration: `zetaPartial_two_pi_div_log_two` in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (`zetaPartial_two_pi_div_log_two : zetaPartial 2 (Real.pi / Real.log 2) = 0`).
- **VERIFIED** in the script with 74-digit certified enclosures by the auditor (smallest root `pi/log 2 = 4.5323601418271938096276829457166668`).
- Related Lean declarations: `zetaPartial_two`, `realPartial_two_pi_div_log_two`, `balanced_two`.

## Dependencies and related results

- Related: [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md) (T4); [S_3(t) != 0](tpp-rh43-truths-s3-nonvanishing.md) (Theorem 8 / T10).
- Refuted statement [F4](tpp-rh43-truths-f4-complex-never-vanishes-refuted.md) uses this exact vanishing as its witness.

## Notes

- This ledger row states the *complex* exact vanishing at `N = 2`; it is distinct from the real-part balance of T4, though both happen at the same `t`.
