# M1 — HANDOFF.md §3.1's closed forms are false

**Kind:** Claim
**Status:** REFUTED (exact enumeration; the §3.1 piecewise law is false from L = 15 onward)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M1** (lines 66–77)

## Statement

> **M1 — HANDOFF.md §3.1's closed forms are false.** The table of measured values is right; the extrapolated piecewise law beneath it is not.
>
> | L | §3.1's law | exact |
> |---|---|---|
> | 15 | 20 | **19** |
> | 20 | 30 | **24** |
> | 100 | 190 | **104** |
> | 593 | 1176 | **597** |
>
> §5 had already recorded this law as "partly true, over-extrapolated"; §3.1 nevertheless prints it as *the* law. A and B were told not to quote it.

The README introduces §4 as follows: "The mediator recomputed the handoff before launching any agent, and found three defects in it. All are verified by exact enumeration and are now regression-locked in `tests/test_complexity.py`."

## Hypotheses and notation

- `p(L) = #{ distinct factors of length L in w }` is the factor complexity of the greedy harmonic digit word `w(x)` (HANDOFF.md §2), computed at truncation length `N`.
- "§3.1's law" is the extrapolated piecewise closed form printed beneath the table of measured values in `HANDOFF.md` §3.1; the README records it as `p(L) = 2L − 10` in the round-1 brief.
- The four tabulated values are for `x = 1/π`, `N = 1400` (the same word whose full measured table the README reproduces in §5 as `p = 2, 6, 11, 12, 14, 16, 18, 19, 24, 54, 104, 304, 597, 598, 609`).

## Proof / evidence

The source states this without proof: the refutation is the exact enumeration itself. The README records the values as "verified by exact enumeration" and "regression-locked in `tests/test_complexity.py`"; §5 adds that the full §3.1 table is "reproduced exactly in this session by `verify/probes.py` from `code/digitword.py`". No general statement of the true law is offered here — only the four exact countervalues.

## Dependencies and related results

- [round01-brief M1 — HANDOFF.md §3.1's closed forms are false](tpp-rh40-round01-brief-m1-piecewise-closed-forms-false.md) — the same correction, stated independently in the round-1 brief.
- [M2/M3 — the true five-piece slope structure](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) — the structure that replaces §3.1's law.
- The exact word-level record lives in the workspace at `research/twin-prime-parity/rounds/rh40/rounds/truths.md` (the programme's register of ground truths), which this README names as authoritative.

## Notes

- **Restatement.** M1 is repeated, with the same four rows, in `round01_brief.md` §1 (harvested as [tpp-rh40-round01-brief-m1-piecewise-closed-forms-false.md](tpp-rh40-round01-brief-m1-piecewise-closed-forms-false.md)) and referenced in both bootup prompts (not harvested; see the bootup result entries).
- The README is a summary that points to `rounds/truths.md` for the authoritative register; the M-items in §4 are the README's own stated corrections, established before either round-1 agent spoke.
