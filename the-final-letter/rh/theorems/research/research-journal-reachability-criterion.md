# B's reachability threshold for the power family: ζ(p) ≥ 2, p* = 1.728647239

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Synthesis §11, line 432; "What is worth keeping as live and open" §4, line 453; Round 5 final adjudication, line 468; "The ten things that stand" (corrected results), line 629; Round 10, line 689

## Statement

> **B's reachability threshold, which supersedes A's and mine.** For the power family α_n = (n+2)^{−p}, the total available mass is Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1, so a target of 1 is reachable iff **ζ(p) ≥ 2**, i.e. p ≤ **p\* = 1.728647239** (verified: ζ(1.7) − 1 = 1.054288757 reachable; ζ(1.8) − 1 = 0.8822296181 unreachable; ζ(2) − 1 = 0.6449340668). A's 3/2 was wrong; my confirmation of it was wrong. And the reason is *not* a termination failure for p > p\* — it is an **insufficient-mass** failure. B also confirmed A's index lists exactly at 60 dps and supplied the missing statement that the last index blows up like 1/(ζ(p) − 1) as p → p\*⁺.

Later summary:

> **The reachability criterion ζ(p) ≥ 2 (B's correction of A's and my threshold).** For the power family α_n = (n+2)^{−p} the available mass is ζ(p) − 1, so a unit target is reachable iff p ≤ p\* = 1.728647239. This is a small, true, complete theorem about greedy expansions with a sharp constant, and it is the most finished mathematical statement the dialogue produced.

## Hypotheses and notation

- Greedy alphabet α_n = (n+2)^{−p}, n ≥ 0, p real > 1; target value 1 (no renormalisation).
- Total available mass Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1.
- p\* = 1.728647239 is the root of ζ(p) = 2 ("where ζ(p) = 2", Round 5).

## Proof / evidence

The mass computation Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1 is exact; reachability of the target 1 is then equivalent to ζ(p) − 1 ≥ 1, i.e. ζ(p) ≥ 2, and ζ is decreasing on (1, ∞), giving the threshold p\*. Numerical certificates: ζ(1.7) − 1 = 1.054288757 (reachable), ζ(1.8) − 1 = 0.8822296181 (unreachable), ζ(2) − 1 = 0.6449340668 (unreachable). Agent B confirmed A's index lists exactly at 60 dps and supplied that the last needed index blows up like 1/(ζ(p) − 1) as p → p\*⁺.

## Dependencies and related results

- [A's corrected proposition on the termination/sampling dilemma](research-journal-greedy-termination-proposition.md) — the general mass-versus-target context of which this is the sharp power-family instance.
- [Bounded gaps iff p > 1 for α_n = (n+2)^{−p}](research-journal-bounded-gaps-threshold.md) — the other threshold of the same family.
- [Greedy harmonic sine: |sin θ − s_N| ≤ π/(N+1) on [0,π]](research-journal-greedy-harmonic-sine-error-bound.md) — the p = 1 harmonic case.

## Notes

- The source states the correct diagnosis plainly: for p > p\* the failure is not non-termination but **insufficient mass** — "a sharper diagnosis than either A's or mine."
- The journal flags the earlier thresholds as errors: Agent A's p = 3/2 and the mediator's confirmation of it were both wrong; "neither is 3/2".
- Round 10 records this under the certified STANDING list ("amplitudes log p unreachable by a finite alphabet" sits beside it, but the reachability criterion itself is the sharp constant statement).
