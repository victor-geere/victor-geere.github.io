# T11 — at `p = 2` the reachable set is `[0, P−1/4] ∪ [1/4, P]` (one gap)

**Kind:** Claim
**Status:** PROOF-SKETCH (exactly predicted) + VERIFIED (numerical, exact stall residuals)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T11; §5.5 "`p = 2` (VERIFIED, exactly predicted)"

## Statement

> **`p = 2` (VERIFIED, exactly predicted).** `P(2) = 0.411233516712`, `a_1 = 1/4`, so the
> positive reachable set is
>
> ```
> [0, 0.161233516712]  ∪  [0.25, 0.411233516712],   the gap is (0.161233516712, 0.25).
> ```

The ledger row states it as: "at `p = 2` the reachable set is `[0, P−1/4] ∪ [1/4, P]` (one gap)".

## Hypotheses and notation

- `p = 2`; `P(2) = 0.411233516712` (row T2, closed form `π²/24`), `a_1 = 1/4 = 2^{−2}` is the first (largest) term of the positive half-series.
- "positive reachable set" = the subset sums of the positive half-series, attained by the greedy.

## Proof / evidence

> | T11 | at `p = 2` the reachable set is `[0, P−1/4] ∪ [1/4, P]` (one gap) | **PROOF-SKETCH** + **VERIFIED** | predicted intervals and exact stall residuals |

The §5.5 verification: "The greedy confirms the exact stall residuals `x − 0.16123352` for `x = 0.18, 0.2, 0.24` and `x − P(2)` for `x = 0.42`, and convergence to `0` at `x = 0.15, 0.25, 0.28, 0.3` (and `1.3e−14` at `x = 0.15`)." The gap is produced by the recursion of §5.5 (`S = S(tail) ∪ (a_1 + S(tail))` with `a_1 = 1/4 > total − a_1 = 0.161233516712`).

## Dependencies and related results

- Uses the subset-sum recursion and the incompleteness mechanism (§5.5), and `P(2)` (row T2 / `π²/24`).
- The same gap is the reason the rational target `1/5` is **not** writable at `p = 2` (§5.6.1): `1/5` "lies inside the budget `P(2) = 0.41123` and inside the sine range, yet inside the gap `(0.16123, 0.25)`".
- Restates `rh42/truths.md` Theorem 12 (`p = 2`).

## Notes

- Status `PROOF-SKETCH` + `VERIFIED`; the interval endpoints are exact predictions confirmed by the greedy's stall residuals, not a completed written proof.
- All decimals are quoted exactly: `0.411233516712`, `[0, 0.161233516712]`, `[0.25, 0.411233516712]`, gap `(0.161233516712, 0.25)`.
- This is the source's first explicit counterexample to "inside the budget ⟹ writable".
