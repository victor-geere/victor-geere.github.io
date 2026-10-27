# The imaginary-split convention: the answer depends on the split convention

**Kind:** Proposition
**Status:** VERIFIED (numerical; auditor check C7)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §6 "Open, and the next round"

## Statement

> * **The imaginary-split convention** (auditor's C7): with the split by `-sin(t log n)` the balance condition is `Im S_N(t) = 0`, which also has roots for every `N ≥ 2` (`N = 3` at `2π/log 6`). The convention must be stated whenever the question is posed.

## Hypotheses and notation

- Alternative convention: split each term by the sign of its imaginary part `-sin(t log n)`, so that the balance condition becomes `Im S_N(t) = 0`.
- Roots exist for every `N ≥ 2`; the instance quoted is `N = 3` at `2π/log 6`.
- The source's own convention, answered by the round, is the real-part split.

## Proof / evidence

- **VERIFIED** by the auditor's check C7 ([`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py)); the round's ledger records this as **T13**.
- truths.md §6 adds the comparison: `N = 3` at `3.5067124885275899… = 2 pi/log 6`, "different from the real case's `2.4266520516296892…`".

## Dependencies and related results

- Harvested truths counterpart: [T13 — the split convention changes the answer](tpp-rh43-truths-split-convention-changes-answer.md); [README.md](../../research/twin-prime-parity/rounds/rh43/README.md) "What this folder does *not* claim".
- Related: [The reduction: `P_N + M_N = Re S_N`](tpp-rh43-handoff-reduction-to-real-equation.md).

## Notes

- HANDOFF.md files this under "Open, and the next round", but it is a *result* (the root exists and differs by convention), not a target; it is harvested with the source's status.
- The source insists the convention "must be stated whenever the question is posed".
