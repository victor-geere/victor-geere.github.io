# (2) The invariant: A(N) = log₂ log N − Σ_{k≤A(N)} log c_k + O(1)

**Kind:** Proposition
**Status:** CONJECTURED (the source asserts the identity; its §(C) names the missing step -- boundedness of `Σ_{k≤A(N)} log c_k` -- as the sharpest OPEN problem, the one that would upgrade `A(N) = log₂ log N + O(1)` from measured to proved)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(2) "THE INVARIANT", lines 45–53

## Statement

> For RATIONAL targets the orbit terminates in 7-12 steps, so there is no invariant measure to
> discuss; the mediator's "no a.c.i.m." is correct but vacuous for the cases measured. For
> irrational targets the orbit is infinite; whether the Sylvester/Engel map has an a.c.i.m. is not
> settled here, and I do not claim it. What IS correct and provable: A(N) = log_2 log N
> - sum_{k<=A(N)} log c_k + O(1), so the O(1) is controlled exactly when the partial sums of
> log c_k converge, i.e. when {1/r_k} stays away from 1. The measured 7-9 step averages
> (-0.42, -0.93, -0.57, -1.20, -0.72, -0.58) are TRANSIENTS of a doubly-exponentially short orbit,
> not limits; target-dependence at 7-9 steps is expected and does not refute a universal limit.

## Hypotheses and notation

- c_k = r_{k+1}/r_k² is the squaring constant; A(N) = #{n ≤ N : δ_n = 1}; {1/r_k} is the fractional part of 1/r_k.
- A.c.i.m. = absolutely continuous invariant measure for the Sylvester/Engel map r ↦ r − 1/⌈1/r⌉.
- The measured averages are the 7–9 step running averages of log c_k, quoted as −0.42, −0.93, −0.57, −1.20, −0.72, −0.58.

## Proof / evidence

The source derives the identity A(N) = log₂ log N − Σ_{k≤A(N)} log c_k + O(1) by summing the
squaring-law recursion u_{k+1} = 2u_k + log c_k, and states that the O(1) is controlled exactly when
the partial sums of log c_k converge, i.e. when {1/r_k} stays away from 1. It reports the 7–9 step
averages as transients of a doubly-exponentially short orbit rather than limits.

## Dependencies and related results

- [round7-agentb-squaring-law-residual](../round7/round7-agentb-squaring-law-residual.md) — the squaring law supplying c_k.
- [round7-agentb-an-log-log-n-growth](../round7/round7-agentb-an-log-log-n-growth.md) — the coarser A(N) = log₂ log N + O(1).
- [round10-agentb-sylvester-not-gauss](round10-agentb-sylvester-not-gauss.md) — the identification of the map whose invariant measure is at issue.

## Notes

- The source explicitly declines the a.c.i.m. claim for irrational targets ("whether the Sylvester/Engel
  map has an a.c.i.m. is not settled here, and I do not claim it"); that question is therefore not
  harvested as a result.
- The source's own correction (§(D) item 3) is that the averages are transients, not limits; the item
  is quoted as written.

- **Correction (2025-10-06, session 003 residual-defect repair).** This document carried `PROVED (paper argument, from the squaring law)` and said the source *derives* the identity. The source asserts it and does not derive it, and it names the missing step itself: `round10_agentB.md:73-74` — "prove that the partial sums `sum_k log c_k` are bounded, which is exactly what upgrades `A(N) = log_2 log N + O(1)` from measured to proved". Nothing in the source bounds those partial sums. Grade demoted to `CONJECTURED`; the coarse law `A(N) = log₂ log N + O(1)` remains the register's open problem, not a result.
