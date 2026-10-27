# T12 — at `p = 3` the reachable set is the four intervals listed in §5.5

**Kind:** Claim
**Status:** VERIFIED (numerical, exact stall residuals)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T12; §5.5 "`p = 3` (VERIFIED)"

## Statement

> **`p = 3` (VERIFIED).** The recursion runs twice more; the reachable set is the four
> intervals
>
> ```
> [0, 0.00963211] ∪ [0.015625, 0.0252571] ∪ [0.125, 0.134632] ∪ [0.140625, 0.1502571],
> ```

## Hypotheses and notation

- `p = 3`; `P(3) = 0.150257` (§5.1 table).
- "the recursion" is `S(subset sums) = S(tail) ∪ (a_1 + S(tail))` of §5.5, applied from the positive half-series.

## Proof / evidence

> | T12 | at `p = 3` the reachable set is the four intervals listed in §5.5 | **VERIFIED** | same method, exact stall residuals |

The §5.5 verification: "and every tested target lands where predicted: `0.02` and `0.15` reach `0`; `0.05`, `0.1` stall at `x − 0.0252571`; `0.14` stalls at `x − 0.134632`; `0.2` at `x − P(3)`."

## Dependencies and related results

- Uses the subset-sum recursion and `P(3)` (row T2 / §5.1).
- The interval count sequence for `p` is tabulated in §5.5: `#intervals` = 1 at `p ≤ p*`, 2 at `p = 1.8, 2, 2.2`, 4 at `p = 2.5, 3`, 16 at `p = 4`, 128 at `p = 6`; `measure/P` falls from `1.000` to `0.001`.
- Restates `rh42/truths.md` Theorem 13 (`p = 3`).

## Notes

- Status `VERIFIED` only (same method as T11, exact stall residuals).
- The four intervals are quoted exactly, as is `P(3) = 0.150257`.
- The source's §7 R4 lists "the behaviour of the interval count (`1, 1, 2, 2, 4, 4, 16, 128` at `p = 1.5, 1.7, 1.8, 2, 2.5, 3, 4, 6`)" as a target, i.e. that pattern is not claimed as proved here.
