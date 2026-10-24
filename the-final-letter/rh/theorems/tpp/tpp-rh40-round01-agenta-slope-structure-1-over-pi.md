# (b) Slope structure for 1/π, N = 1400

**Kind:** Claim
**Status:** VERIFIED (numerical; exact slopes output at N = 1400)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[COMPUTABLE]", item (b), lines 57–60

## Statement

> **(b)** Slope: for 1/π, `slopes((2,13,607),1400)` returns
> `[(1,10,1),(11,13,2),(14,604,1),(605,791,0),(792,1399,−1)]` — the 1→2 at `L=13`
> is the pair class switching on (`13 = d_1+2`); the 2→**1** at `L=14` is the
> deficit. The crossover `L=N−a_m=792`: verified `p(792)=609=N−792+1`.

## Hypotheses and notation

- The word is the greedy harmonic digit word at `x = 1/π`, `N = 1400`, support `(2, 13, 607)`, so `a_m = 607` and `d_1 = 13 − 2 = 11`.
- `slopes(ones, N)` returns runs `(L_start, L_end, p(L+1) − p(L))` — the source reads it as the first-difference (slope) sequence.
- Agent A's label "the crossover `L=N−a_m=792`" is arithmetically inconsistent with the same word (`N − a_m = 1400 − 607 = 793`); the verified value in the same sentence is `p(792) = 609 = N − 792 + 1`. The corrected boundary is recorded by the README and Agent B as `L = N − a_m − 1 = 792` (see Notes).

## Proof / evidence

The source states this as a computation from `rh40/code/digitword.py`; the printed run list is the certificate. The README's M2/M3 records the same five-piece structure independently (harvested as [tpp-rh40-readme-m2-m3-five-piece-slope-structure.md](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md)), and Agent B's audit reports that `slopes()` "== hand computation for (0,2), N=6 (p=[2,3,4,3,2,1], runs [(1,2,1),(3,5,-1)])" while its docstring wrongly "repeats §3.1's false runs ((11,592,2),(593,604,3))" (harvested as [tpp-rh40-round01-agentb-digitword-audit-clean.md](tpp-rh40-round01-agentb-digitword-audit-clean.md)).

## Dependencies and related results

- [M2/M3 — the true five-piece slope structure](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) — the README's independent record of the same slopes.
- [Agent B (b) — the plateau and the decay crossover](tpp-rh40-round01-agentb-plateau-decay-boundary.md) — the off-by-one correction of the boundary label.
- [M1 — HANDOFF.md §3.1's closed forms are false](tpp-rh40-readme-m1-piecewise-closed-forms-refuted.md) — the false law whose runs (`(11,592,2)`, `(593,604,3)`) the docstring still repeated.
- [Agent A (c) — the decay law and the plateau value](tpp-rh40-round01-agenta-decay-law-and-plateau-value.md) — the companion verification `p(792) = 609`.

## Notes

- The claim originally posed for this round was `1 → 2 → 3`; the source's own `[COMPUTABLE]` output establishes instead `1 → 2 → 1 → 0 → −1`, with "no range with slope 3" (README M2/M3).
- The `L = N − a_m = 792` label is the source's own wording and is preserved verbatim; the mathematically consistent boundary is `N − a_m − 1 = 792`, as Agent B's audit records.
