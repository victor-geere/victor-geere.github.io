# K6i — for x uniform on (0,1): E[(1/K)Σ log c_k] = −1 + O(1/K) (L¹)

**Kind:** Claim
**Status:** PROVED (paper argument, Agent B; mediator verified the density input K6c/K6d)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6i

## Statement

> For `x` uniform on `(0,1)`: `E[(1/K)Σ log c_k] = −1 + O(1/K)` (`L¹`)

## Hypotheses and notation

- `x` is uniform on `(0,1)`; `c_k` is the greedy coefficient averaged over the first `K` steps.
- The expectation is in the `L¹` sense, as the source's parenthetical records.

## Proof / evidence

Register row K6i's state cell reads: "**`PROVED`** (Agent B; mediator verified the density input K6c/K6d)"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register rows K6c, K6d (the verified inputs), K6e, K6f (why the statement is an average, not a universal limit), K6j, I4.
- [L¹ convergence of the orbit average to −1 for uniform `x`](tpp-rh40-k-remaining-conjecture-l1-convergence-uniform-x.md).

## Notes

- The `O(1/K)` term is proved in the `L¹` sense only; the source does not claim a.e. convergence here (that is row K6j).
