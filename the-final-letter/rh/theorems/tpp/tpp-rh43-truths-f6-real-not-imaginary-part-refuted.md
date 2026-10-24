# F6 — "the sum of positive parts minus the absolute sum of negative parts is the imaginary part"

**Kind:** Claim
**Status:** REFUTED (it is the **real** part: `P + M = Re S_N`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F6 | "the sum of positive parts minus the absolute sum of negative parts is the imaginary part" | it is the **real** part: `P + M = Re S_N`. A sign/convention slip to keep out of the ledger. |

## Hypotheses and notation

- The falsified claim identifies `P_N - |M_N|` (equivalently `P_N + M_N`) with `Im S_N`.
- The corrected identity is `P_N + M_N = Re S_N(t) = 1 + sum_{n=2}^{N} cos(t log n)`.

## Proof / evidence

- Ledger row F6: status "**REFUTED**", evidence "§5, with witnesses".
- The corrected identity is [T2 / Theorem 1](tpp-rh43-truths-split-identity-and-balance-equation.md), proved in Lean (`realPartial_eq_posRe_add_negRe`).
- HANDOFF.md §5 banks the correction: "'`P - |M|` is the imaginary part" — false; it is the real part (F6).

## Dependencies and related results

- Related: [The split is an identity](tpp-rh43-truths-split-is-an-identity.md) (Theorem 1).

## Notes

- The source calls this "a sign/convention slip to keep out of the ledger".
