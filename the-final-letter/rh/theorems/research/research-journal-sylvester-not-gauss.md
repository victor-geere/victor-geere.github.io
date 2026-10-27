# The greedy map is Engel/Sylvester, not Gauss: no Gauss–Kuzmin, no a.c.i.m.

**Kind:** Proposition
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 9 §2, line 582; "The corrected results about the digit word itself", line 630; Round 10 table, line 685

## Statement

> **The greedy map is the Sylvester-type squaring map, not the Gauss map.** I verified the Gauss map reproduces Gauss–Kuzmin 1/((1+x)log 2) to three decimals over 200 000 iterations (empirical [1.374, 1.244, 1.155, 1.065, 0.993, 0.936, 0.885, 0.817, 0.780, 0.750] against GK [1.374, 1.255, 1.154, 1.069, 0.995, 0.931, 0.874, 0.824, 0.780, 0.740]), while the Sylvester orbit reaches 0 in 8–12 steps and exhibits no a.c.i.m. So **A's Round 2 [RECALL] invoking Gauss–Kuzmin, and my own Round 1 Gauss–Kuzmin guess, were both wrong.** Sylvester/Engel expansions are the right framework, and they have no absolutely continuous invariant measure.

Round 10 certification:

> The greedy map is Engel/Sylvester, not Gauss; no Gauss–Kuzmin; no a.c.i.m. — A: max|S(r) − {1/r}| = 0.998334; GK pushed forward has KS distance 0.4875; orbit dies in 5–7 steps.

## Hypotheses and notation

- The greedy residual map r ↦ r − 1/⌈1/r⌉ (equivalently the "Sylvester-type squaring map"), versus the Gauss continued-fraction map x ↦ {1/x}.
- Gauss–Kuzmin density 1/((1+x) log 2) on (0,1); a.c.i.m. = absolutely continuous invariant measure.
- KS distance: Kolmogorov–Smirnov distance between the Gauss–Kuzmin distribution and the pushforward under the actual map.

## Proof / evidence

Numerical: the Gauss map reproduces Gauss–Kuzmin to three decimals over 200 000 iterations (the ten decile values above); the Sylvester orbit reaches 0 in 8–12 steps and has no a.c.i.m. Round 10 supplies the sharper numbers max|S(r) − {1/r}| = 0.998334 and KS distance 0.4875 for the pushed-forward Gauss–Kuzmin measure, with the orbit dying in 5–7 steps.

## Dependencies and related results

- [The orbit average of log c_k is bounded, negative and target-dependent](research-journal-orbit-average-log-c.md) — the orbit statistics; the journal notes "no a.c.i.m." is vacuous for rational targets.
- [The squaring law: r' = (1−f)r²/(1 + (1−f)r)](research-journal-squaring-law.md) — the exact form of the Sylvester-type step.
- [Bounded gaps iff p > 1 for α_n = (n+2)^{−p}](research-journal-bounded-gaps-threshold.md) — the alphabet thresholds.

## Notes

- The source is careful about the strength of the "no a.c.i.m." claim: Round 10 Correction 3 says B "is right that 'no a.c.i.m.' is *vacuous* for the rational targets where the orbit dies in 7–12 steps, and that my 7–9-step orbit averages are **transients, not limits**." The framework statement stands; the orbit-average limit is not established.
- The Gauss–Kuzmin attribution was wrong twice in this dialogue — once by Agent A's [RECALL] and once by the mediator's own Round 1 guess — and the journal records both as errors.
