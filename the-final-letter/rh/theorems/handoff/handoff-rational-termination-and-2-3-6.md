# Rational termination and the uniqueness of (2, 3, 6)

**Kind:** Theorem
**Status:** CHECKED (exhaustive finite; exact rational arithmetic)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §2 "Two rigorously known regimes", lines 33–35; §8.2 item 8; §8.3 Tier 2

## Statement

> **Rational x = p/q:** the process terminates. Indices for θ = π are exactly {0, 1, 4} (1/2 + 1/3 + 1/6 = 1). Verified with exact rational arithmetic.
>
> §8.2 item 8: `test_rational_termination` — exact rationals: 268 of 277 reduced p/q with q ≤ 30 terminate; θ = π gives exactly {0,1,4}; 4/17, 14/19, 17/19, 7/23, 21/23, 4/25, 9/29, 12/29, 27/29 are the slow ones.
>
> §8.3 Tier 2: the uniqueness of the 3-term unit-fraction decomposition of 1 — 1 = 1/a + 1/b + 1/c with 2 ≤ a < b < c forces a = 2. "**Note this is a theorem with a two-line proof and needs no bound on c** (B's argument: `3/a ≥ 1` so `a ≤ 3`; `a = 3` gives `1/b + 1/c = 2/3 ≤ 1/2`, contradiction; `a = 2` gives `c = 2b/(b−2) > b` forcing `b < 4`, so `b = 3`, `c = 6`)."

## Hypotheses and notation

- The greedy harmonic sine / greedy digit word of §2: r₀ = x = θ/π with θ ∈ (0, π), and for n = 0, 1, 2, …: if r<sub>n</sub> ≥ 1/(n+2) then δ<sub>n</sub> = 1 and r<sub>n+1</sub> = r<sub>n</sub> − 1/(n+2), else δ<sub>n</sub> = 0 and r<sub>n+1</sub> = r<sub>n</sub>.
- "The process terminates" means the residual reaches 0, so only finitely many δ<sub>n</sub> equal 1.
- For rational x = p/q the terminating support is a set of unit fractions summing to x; for θ = π (x = 1) that set is {0, 1, 4}, i.e. 1/2 + 1/3 + 1/6 = 1.
- In the unit-fraction statement a, b, c are positive integers with 2 ≤ a < b < c.

## Proof / evidence

- The θ = π case is verified with exact rational arithmetic; §8.1 records why this matters: a float run "produced the spurious support [0,1,5,41,1805] for θ = π because the residual after 1/2 + 1/3 was 1e−16 instead of 0; exact rationals give [0,1,4]."
- The q ≤ 30 census is by exact enumeration (268 of 277 reduced p/q terminate), with the nine slow cases listed.
- The (2, 3, 6) uniqueness carries the two-line proof sketch quoted above (attributed by the source to Agent B); the source calls it "a theorem with a two-line proof" and "the single cleanest Mathlib target in the whole subject".

## Dependencies and related results

- [handoff-greedy-squaring-law](handoff-greedy-squaring-law.md) — the parallel irrational regime: there the process never terminates and the residual obeys r' = (1−f)r²/(1+(1−f)r).
- The source lists the enumerator in §9 as `verify/round9_fixed.py` (uniqueness of (2,3,6), Gauss vs Sylvester map, Mertens = γ + prime sum).

## Notes

- The status is CHECKED (exhaustive finite; exact rational arithmetic): the general claim "for rational x the process terminates" is asserted by the source as rigorously known, but the evidence recorded in the document is the exact-rational census (268/277 for q ≤ 30) plus the θ = π computation, and the uniqueness proof covers only the 3-term decomposition. The nine "slow ones" are recorded as terminating cases too.
- The source records the θ = π support as a correction of a float artefact, not as a revision of the mathematics.
- The unit-fraction uniqueness is presented as background for a formalisation target (Tier 2, Mathlib), not as a result of this workspace.
