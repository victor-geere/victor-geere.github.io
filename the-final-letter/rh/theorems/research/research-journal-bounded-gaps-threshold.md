# Bounded gaps iff p > 1 for α_n = (n+2)^{−p}

**Kind:** Proposition
**Status:** VERIFIED (numerical; gap measurements at 60 dps)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 5 final adjudication, line 393; Round 9 §3, line 583; "The corrected results about the digit word itself", line 629

## Statement

> My independent measurement confirms him and refines him: for α_n = (n+2)^{−p}, the greedy index **gaps** are [1, 4, 66, 8945] at p = 1 (ratios 4.0, 16.5, 135.5, growing without bound), [1, 2, 109, 11007] at p = 1.05, [1,1,3,346,62904] at p = 1.2, [1,1,1,1,1,1,1,3] at p = 1.5 — so **bounded gaps iff p > 1**, with the transition exactly at p = 1, not at p = 3/2 as A first proposed.

Restated in Round 9:

> And separately, bounded gaps ⟺ p > 1 (measured gaps [1, 4, 66, 8945] at p = 1, [1,1,1,1,1,1,1,3] at p = 1.5). So the two thresholds in A's programme are p = 1 (bounded gaps) and p\* = 1.728647239 (reachable target), and neither is 3/2.

## Hypotheses and notation

- Greedy alphabet α_n = (n+2)^{−p}, n ≥ 0, target value 1; "gaps" are the differences between consecutive selected indices.
- p = 1 is the harmonic case Σ 1/(n+2) = ∞; p\* = 1.728647239 is the reachability threshold.

## Proof / evidence

Measured greedy index gaps: [1, 4, 66, 8945] at p = 1 (ratios 4.0, 16.5, 135.5, growing without bound); [1, 2, 109, 11007] at p = 1.05; [1,1,3,346,62904] at p = 1.2; [1,1,1,1,1,1,1,3] at p = 1.5. Agent B confirmed A's index lists exactly at 60 dps. The source supplies the reason for the "never both" half: for non-integer p the alphabet elements (n+2)^{−p} are irrational, so a rational target cannot be hit exactly by finitely many of them and the positive tail excludes the possibility.

## Dependencies and related results

- [A's corrected proposition on the termination/sampling dilemma](research-journal-greedy-termination-proposition.md) — the general proposition this refines.
- [B's reachability threshold for the power family: ζ(p) ≥ 2](research-journal-reachability-criterion.md) — the other threshold of the family.
- [The greedy map is Engel/Sylvester, not Gauss](research-journal-sylvester-not-gauss.md) — the framework for the digit orbit.

## Notes

- The journal's verdict: "the dilemma is not general; it is a property of the power-law family, and the sharp threshold is p = 1." Agent A first proposed p = 3/2 and accepted the correction.
- The source also notes that A's own counterexample to the dilemma as originally stated (α_n = c·2^{−n} terminates *and* has bounded gap ratios) is correct.
