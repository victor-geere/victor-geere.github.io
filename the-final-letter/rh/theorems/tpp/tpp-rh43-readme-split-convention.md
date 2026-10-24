# The answer depends on the split convention

**Kind:** Proposition
**Status:** VERIFIED (numerical; the imaginary-split roots differ)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/README.md`](../../research/twin-prime-parity/rounds/rh43/README.md) — "What this folder does *not* claim"

## Statement

> * The answer depends on the split convention: splitting by the **imaginary** part instead gives the condition `Im S_N(t) = 0`, which also has roots, at different heights (`N = 3` at `2π/log 6`). The real-part convention is the one answered here, and it is stated explicitly everywhere.

## Hypotheses and notation

- Alternative split convention: by the **imaginary** part, giving the balance condition `Im S_N(t) = 0`.
- The imaginary-convention roots exist and sit at different heights; the instance quoted is `N = 3` at `2π/log 6`.
- The real-part convention is the one the README answers.

## Proof / evidence

- The README states the convention dependence and quotes the `N = 3` height `2π/log 6`; the round's ledger records the result as **T13** with evidence "§6, auditor C7" (**VERIFIED**).
- truths.md §6 gives the decimal `3.5067124885275899…` for the same root.

## Dependencies and related results

- Harvested truths counterpart: [T13 — the split convention changes the answer](tpp-rh43-truths-split-convention-changes-answer.md).
- Harvested handoff counterpart: [The imaginary-split convention](tpp-rh43-handoff-imaginary-split-convention.md).

## Notes

- The README files this under "What this folder does *not* claim"; it is nevertheless a verified statement about the convention's effect, harvested with the source's status.
