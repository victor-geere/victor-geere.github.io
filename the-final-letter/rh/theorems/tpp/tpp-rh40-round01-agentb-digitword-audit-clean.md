# digitword.py is computationally clean (audit of the ground-truth layer)

**Kind:** Claim
**Status:** CHECKED (exhaustive finite; p_offset == p_bruteforce on 43 342 cases, right_special_factors == an independent bit-string enumeration on 22 088 cases; two documentation defects)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[TESTED]" (d), lines 67–75

## Statement

> (d) digitword.py is computationally clean: p_offset==p_bruteforce on 43342 exhaustive cases (N<=12, <=4 ones, all L), on all 701 decay-regime L of 1/pi, and on 400 random words; right_special_factors==my own independent bit-string enumeration on 22088 cases and on all L<1400 for 1/pi; slopes()==hand computation for (0,2), N=6 (p=[2,3,4,3,2,1], runs [(1,2,1),(3,5,-1)]). Two defects, both documentation: slopes()'s docstring repeats §3.1's false runs ((11,592,2),(593,604,3)) although the function returns [(1,10,1),(11,13,2),(14,604,1),(605,791,0),(792,1399,-1)]; and factor_set(L>N) returns set() where p_offset raises. Scripts: rh40/verify/agentB_sweep.py, rh40/verify/agentB_audit.py.

## Hypotheses and notation

- `digitword.py` (`rh40/code/digitword.py`) is the programme's definition of record; its entry points named here are `p_offset` (the offset-tuple count), `p_bruteforce` (the bit-string count), `factor_set`, `right_special_factors` and `slopes`.
- The two live definitions of `p(L)` are `p(L) = #{{{a − t : a in ones, t <= a <= t + L − 1}} : 0 <= t <= N − L}` (offset-tuple) and the number of distinct bit-string factors; the audit checks they agree.
- "701 decay-regime L of 1/pi" are the `L` values in the decay regime of the word `1/pi (2,13,607)`, `N = 1400`.
- The two defects are documentation-level: a stale docstring listing the false §3.1 runs `((11,592,2),(593,604,3))`, and `factor_set(L>N)` returning `set()` where `p_offset` raises.

## Proof / evidence

The source states this as its own executed audit, with the case counts as the certificate ("a clean audit of the ground-truth layer is a real result" — round-1 brief, task (d)). The README independently records the same definitional agreement: "the offset-tuple count equals the bit-string factor count on every sampled L, including deep in the decay regime (L = 800, 1000, 1200, 1390, 1398, 1399) — so §3.2 is safe as the definition of record". The brief's M4 states the same agreement (harvested as [tpp-rh40-round01-brief-m4-offset-tuple-equals-bit-string-count.md](tpp-rh40-round01-brief-m4-offset-tuple-equals-bit-string-count.md)).

## Dependencies and related results

- [round01-brief M4 — the offset-tuple count and the bit-string factor count agree everywhere compared](tpp-rh40-round01-brief-m4-offset-tuple-equals-bit-string-count.md) — the mediator's version of the same agreement.
- [The exact structural characterisation of the greedy digit word](../handoff/handoff-offset-tuple-characterisation.md) — the definition being audited.
- [Agent A (b) — the slope structure](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md) — the `slopes` output `[(1,10,1),(11,13,2),(14,604,1),(605,791,0),(792,1399,-1)]` that the docstring contradicts.

## Notes

- Status CHECKED (exhaustive finite): the claim is an exhaustive/random agreement check between two implementations, not a mathematical theorem; the source itself labels the outcome "computationally clean" and treats the clean audit as the result.
- The two defects are recorded because the source records them; they are documentation-only and do not affect the computed values.
