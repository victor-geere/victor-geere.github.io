# T13 — the split convention changes the answer (imaginary split roots differ)

**Kind:** Theorem
**Status:** VERIFIED (numerical; auditor check C7)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T13 (prose in §6 "Open", "The imaginary-split convention")

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T13 | the split convention changes the answer (imaginary split roots differ) | **VERIFIED** | §6, auditor C7 |

The prose form of the statement, from §6:

> **The imaginary-split convention.** If the terms are split by the sign of their *imaginary* part `-sin(t log n)` instead of the real part, the balance condition becomes `Im S_N(t) = 0`, which also has roots (the auditor's C7: smallest positive roots for every `N >= 2`, e.g. `N = 3` at `3.5067124885275899… = 2 pi/log 6`, different from the real case's `2.4266520516296892…`). The answer to the round's question therefore depends on the split convention, and the real-part convention is the one this folder answers.

## Hypotheses and notation

- Alternative convention: split each term by the sign of its imaginary part `-sin(t log n)`; the balance condition becomes `Im S_N(t) = 0`.
- `N = 3` root in this convention: `3.5067124885275899… = 2 pi/log 6`; the real-part convention's `N = 3` root is `2.4266520516296892…`.

## Proof / evidence

- Ledger row T13: status "**VERIFIED**", evidence "§6, auditor C7".
- The auditor's check C7 establishes smallest positive roots for every `N >= 2` in this convention ([`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py)).
- HANDOFF.md §6 restates it: "with the split by `-sin(t log n)` the balance condition is `Im S_N(t) = 0`, which also has roots for every `N ≥ 2` (`N = 3` at `2π/log 6`). The convention must be stated whenever the question is posed."

## Dependencies and related results

- Related: [Theorem 6 (certified root table)](tpp-rh43-truths-certified-root-table.md) for the real-part roots; [README.md](../../research/twin-prime-parity/rounds/rh43/README.md) "What this folder does *not* claim".

## Notes

- This is a statement about the dependence of the round's answer on the split convention; the source answers only the real-part convention.
