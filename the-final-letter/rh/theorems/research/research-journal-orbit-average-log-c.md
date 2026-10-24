# The orbit average of log c_k is bounded, negative and target-dependent

**Kind:** Proposition
**Status:** VERIFIED (numerical; the averages are transients, not established limits)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 8, line 576; Round 10 Correction 3, line 711; "The single open problem", lines 713–719

## Statement

> **Mediator's Round 8 results.** The orbit average of log c_k over 7–9 steps: **−0.4220 (1/π), −0.9309 (log 2), −0.5671 (√2−1), −1.2015 (e−2), −0.7155 (π−3), −0.5774 ((√5−1)/2)**. Bounded, negative, and **target-dependent** — so A(N) = log₂ log N + O(1) stands, and the "invariant" A proposed exists empirically but is not universal. Whether its average converges at all is the open question, and it is a question about the orbit.

Round 10 Correction 3 (the status of these numbers):

> **Correction 3: B's refinement accepted.** B is right that "no a.c.i.m." is *vacuous* for the rational targets where the orbit dies in 7–12 steps, and that my 7–9-step orbit averages are **transients, not limits**. The correct framework: A(N) = log₂ log N − Σ_{k ≤ A(N)} log c_k + O(1), so the O(1) is controlled exactly when Σ log c_k converges — equivalently when {1/r_k} stays away from 1.

## Hypotheses and notation

- c_k = r_{k+1}/r_k² is the squaring-law ratio; log c_k is its logarithm; the orbit average is (1/K)Σ_{k≤K} log c_k.
- Targets: 1/π, log 2, √2−1, e−2, π−3, (√5−1)/2; the average is taken over 7–9 steps.
- "Transients" means the finite-step averages are not claimed to be limits.

## Proof / evidence

Numerical, over 7–9 orbit steps per target: −0.4220, −0.9309, −0.5671, −1.2015, −0.7155, −0.5774. The source's own Round 10 correction downgrades their interpretation: because the Sylvester orbit dies in 7–12 steps for these (rational) targets and no a.c.i.m. exists, the averages are transients. Agent A's competing scaling argument gives E[log(1−f)] = −1 if f equidistributes (universal).

## Dependencies and related results

- [The squaring law: r' = (1−f)r²/(1 + (1−f)r)](research-journal-squaring-law.md) — defines c_k.
- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the law whose O(1) these averages were meant to control.
- [The greedy map is Engel/Sylvester, not Gauss: no Gauss–Kuzmin, no a.c.i.m.](research-journal-sylvester-not-gauss.md) — the framework in which the transients are diagnosed.

## Notes

- The single open problem named unanimously by both agents is exactly the convergence of these averages: "Prove or refute: for every irrational x ∈ (0,1), the orbit r ↦ r − 1/⌈1/r⌉ satisfies (1/K)Σ_{k≤K} log c_k → a limit independent of x as K → ∞ — equivalently, Σ_k log c_k is bounded." The journal records that "the evidence is genuinely split" and that "no proof either way was produced by either agent or by the mediator."
- Because the source itself downgrades the 7–9-step averages to transients, this file is harvested with status VERIFIED (numerical) and the caveat stated in the Status line, not as an established limit.
