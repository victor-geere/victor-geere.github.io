# T8 — the positive half is the classical Egyptian greedy at `2^p x`

**Kind:** Claim
**Status:** PROVED (paper argument, index substitution) + VERIFIED (numerical, support correspondence at `p = 1, 2`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T8; §5.6.2

## Statement

> **The positive half is the classical Egyptian greedy in disguise (**VERIFIED**).** Term
> index `n = 2(k−1)` has value `(2k)^{−p} = 2^{−p} k^{−p}`, so for `x > 0` the signed rule
> is exactly the greedy on `{1/k^p : k ≥ 1}` at target `2^p x`.

The ledger row states it as: "the positive half is the classical Egyptian greedy at `2^p x`".

## Hypotheses and notation

- `x > 0` (the positive target).
- Term index `n = 2(k−1)` for `k ≥ 1` gives the even denominators `(2k)^{−p}`.
- `{1/k^p : k ≥ 1}` with target `2^p x`; at `p = 1` this is the classical Egyptian (unit-fraction) greedy.

## Proof / evidence

> | T8 | the positive half is the classical Egyptian greedy at `2^p x` | **PROVED** + **VERIFIED** | support correspondence at `p = 1, 2` |

The source's §5.6.2 gives the check: "Checked at `p = 1` for `x = 1/2, 1/3, 2/5, 1, 7/9` (supports `{0}`, `{2,10}`, `{2,6,38}`, `{0,2,4,10}`, `{0,2,34}` versus the Egyptian supports `{1}`, `{2,6}`, `{2,4,20}`, `{1,2,3,6}`, `{1,2,18}`) and at `p = 2`. So rh41's Theorem 8 (rational termination) and the Sylvester/Fibonacci theory transfer to the *positive half at `p = 1`*, and the negative half is the same statement for the odd unit fractions `1/3, 1/5, …`."

## Dependencies and related results

- Uses the definition of the signed alphabet and rule (§2) and the budgets T2/T3.
- Transfers rh41's Theorem 8 (rational termination) and the Sylvester/Fibonacci theory to the positive half at `p = 1`.
- Consequence recorded in §5.6.1: ""Every rational target terminates" is a `p = 1` statement" — at `p = 2` the rational target `x = 1/5` is not writable.

## Notes

- The row's own status text is `PROVED` + `VERIFIED`; §5.6.2 heads the item "**VERIFIED**" only. Both statuses are the source's.
- All support sets and the target list are quoted exactly as printed.
- The correspondence is stated for the positive half; the negative half is described as "the same statement for the odd unit fractions `1/3, 1/5, …`".
