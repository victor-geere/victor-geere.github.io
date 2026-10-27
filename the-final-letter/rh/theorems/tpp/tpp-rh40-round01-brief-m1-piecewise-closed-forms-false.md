# M1 — HANDOFF.md §3.1's closed forms are false

**Kind:** Claim
**Status:** REFUTED (numerical; `p(L) = 2L − 10` is false from L = 15 onward)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md) — §1 "Mediator's own findings from this session (recomputed, standing)", item **M1** (lines 38–51)

## Statement

> **M1 — HANDOFF.md §3.1's closed forms are false.** The table of *measured* values in §3.1 is correct (p = 16, 18, 19 at L = 13, 14, 15). The extrapolated piecewise law printed beneath it is not:
>
> | L | §3.1 says | exact |
> |---|---|---|
> | 15 | `2L−10 = 20` | 19 |
> | 20 | `2L−10 = 30` | 24 |
> | 100 | `2L−10 = 190` | 104 |
> | 593 | `2L−10 = 1176` | 597 |
>
> `p(L) = 2L − 10` is false from L = 15 onward. §5 already lists this law as "partly true, over-extrapolated"; §3.1 nevertheless states it as the law. **A and B must not quote §3.1's formula. Quote the table only.**

## Hypotheses and notation

- `p(L)` is the factor complexity of the greedy harmonic digit word at truncation length `N`; the four exact values are for `x = 1/π`, `N = 1400`.
- "§3.1's formula" is the piecewise closed form `p(L) = 2L − 10` printed beneath the table of measured values in `HANDOFF.md` §3.1.
- The brief's §1 preamble states that everything in it "was recomputed by the mediator in this session with exact integer arithmetic (`rh40/code/digitword.py`, `rh40/verify/probes.py`); nothing in it is inherited on trust from the previous dialogue".

## Proof / evidence

The source states this **without proof**: it is a record of exact recomputation, and the numbers themselves are the counterexamples. The brief adds the instruction to the two agents: "**A and B must not quote §3.1's formula. Quote the table only.**"

## Dependencies and related results

- [README M1 — HANDOFF.md §3.1's closed forms are false](tpp-rh40-readme-m1-piecewise-closed-forms-refuted.md) — the README's independent statement of the same correction.
- [M2 — the true five-piece slope structure](tpp-rh40-round01-brief-m2-five-piece-slope-structure.md) — the structure that replaces the law.
- [Cassaigne's first-difference theorem](tpp-rh40-round01-agenta-cassaigne-first-difference-theorem.md) — the tool used once the formula is abandoned.

## Notes

- **Restatement.** M1 is restated by the README §4 (harvested as [tpp-rh40-readme-m1-piecewise-closed-forms-refuted.md](tpp-rh40-readme-m1-piecewise-closed-forms-refuted.md)) and referenced in both bootup prompts (round-1 brief, lines 41–43 of the README's item; bootup prompts not harvested). The round it restates is round 1 of `rh40`.
- The brief's M1 is the version that names the formula explicitly as `2L − 10`; the README's version tabulates the same four rows from HANDOFF §3.1's own wording.
