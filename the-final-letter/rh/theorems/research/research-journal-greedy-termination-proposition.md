# A's corrected proposition on the termination/sampling dilemma

**Kind:** Proposition
**Status:** PROVED (paper argument; the "never both" half corrected by measurement)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 5 final adjudication, line 393; Round 5 signed answer, line 462

## Statement

> **A's corrected proposition on the termination/sampling dilemma, which supersedes mine.** General statement: greedy on a positive decreasing alphabet with Σα_n = L < ∞ terminates for every rational target in (0, L) and for no target > L; if Σα_n = ∞ it terminates for no target at all. **The threshold is p = 1 exactly** — the harmonic case where Σ1/(n+2) diverges.

And the "never both" clause as corrected:

> And the "never both" half has a simpler reason than A gave: for any non-integer p, α_n = (n+2)^{−p} is **irrational**, so a rational target can never be hit exactly by a finite number of them, and the positive tail excludes the possibility. Termination requires a rational, telescoping alphabet. A's own counterexample to the dilemma as originally stated (α_n = c·2^{−n} terminates *and* has bounded gap ratios) is correct and he volunteered it against himself. **So the dilemma is not general; it is a property of the power-law family, and the sharp threshold is p = 1.**

## Hypotheses and notation

- α_n > 0 decreasing, n ≥ 0; L = Σ_n α_n the total mass; target value in (0, L).
- Greedy rule: take α_n iff the running residual is at least α_n; "terminates" means the residual reaches exactly 0 after finitely many terms.
- "Power-law family": α_n = (n+2)^{−p}.

## Proof / evidence

The source gives the general statement without proof, as Agent A's signed proposition. The mediator's independent measurement refines the power-law case: greedy index gaps are [1, 4, 66, 8945] at p = 1 (ratios 4.0, 16.5, 135.5, growing without bound), [1, 2, 109, 11007] at p = 1.05, [1,1,3,346,62904] at p = 1.2, [1,1,1,1,1,1,1,3] at p = 1.5 — so bounded gaps iff p > 1, with the transition exactly at p = 1, not at p = 3/2 as A first proposed.

## Dependencies and related results

- [Bounded gaps iff p > 1 for α_n = (n+2)^{−p}](research-journal-bounded-gaps-threshold.md) — the measured refinement.
- [B's reachability threshold for the power family: ζ(p) ≥ 2](research-journal-reachability-criterion.md) — the second, independent threshold of the same family.
- [A's certification theorem for the greedy residual](research-journal-certification-theorem.md) — the residual monotonicity and tail bound used throughout.
- [Termination of the greedy Egyptian expansion for rational θ/π](research-journal-rational-termination.md) — the harmonic instance p = 1.

## Notes

- The source is explicit that the proposition supersedes the mediator's own version and that one half of the original dilemma is false in general. The counterexample (α_n = c·2^{−n} terminates *and* has bounded gap ratios) was volunteered by Agent A against himself.
- The journal records that the general statement is A's, that the mediator accepted it, and that the sharp p = 1 threshold is confirmed by the mediator's measurements rather than by a proof of the general proposition.
