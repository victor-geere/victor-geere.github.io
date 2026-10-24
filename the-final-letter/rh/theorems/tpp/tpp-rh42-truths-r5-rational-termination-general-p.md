# R5 (refuted) — "every rational target terminates" at general p

**Kind:** Claim
**Status:** REFUTED (smallest witness below)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R5

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R5 | "every rational target terminates" as a signed statement at general `p` | `p = 2`, `x = 1/5` (R2); it is a `p = 1` theorem |

## Hypotheses and notation

- Refuted general statement: for the signed rule, every rational target terminates (residual reaches `0` in finitely many takes) at every exponent `p`.
- Witness: `p = 2`, `x = 1/5` — the same witness as [R2](tpp-rh42-truths-r2-inside-budget-not-writable.md).
- The valid scope is `p = 1` (Corollary 15's transfer of rh41's Theorem 8).

## Proof / evidence

The §5 exact verification of Theorem 12: at `p = 2` the rational `1/5` is not writable, and the exact `Fraction` run takes every even index `2, 4, …, 2K` and nothing else, with deficit from the stall value rigorously in `(0, 1/(4K))` — so it does not terminate.

## Dependencies and related results

- [Corollary 15 (T8)](tpp-rh42-truths-corollary-15-egyptian-greedy.md) — the `p = 1` transfer: "rh41's Theorem 8 (*every rational target terminates*) transfers to the positive half at `p = 1` and **only** there".
- [Theorem 12 (p = 2)](tpp-rh42-truths-theorem-12-p-equals-2.md) and [R2](tpp-rh42-truths-r2-inside-budget-not-writable.md).

## Notes

- The source's witness cell refers to "(R2)" and states "it is a `p = 1` theorem" — i.e. termination of rational targets is a `p = 1` phenomenon, not a general one.
