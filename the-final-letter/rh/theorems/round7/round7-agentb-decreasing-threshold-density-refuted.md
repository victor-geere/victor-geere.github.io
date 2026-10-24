# Refuted: the decreasing-threshold density (θ/π) log N

**Kind:** Claim
**Status:** REFUTED (numerical comparison at N = 20000; matches neither the Sturmian law nor the truth)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(4) "THE REFUTED DENSITY — POST-MORTEM, WITH A CORRECTION TO THE POST-MORTEM", lines 40–48

## Statement

> So the retracted claim was NOT the Sturmian prediction either; it
> was off in the wrong direction. The truth for the decreasing-threshold word is O(1) ones
> (rational targets terminate; irrationals have O(log log N) ones). Correct post-mortem:
> constant threshold -> Theta(N) ones; harmonic threshold -> Theta(log log N) ones; the retracted
> (theta/pi)log N matches NEITHER. The "constant vs harmonic threshold" reading is right in
> spirit; the identification with the Sturmian value is not.

## Hypotheses and notation

- The retracted formula is #ones(N) = (θ/π) log N for the greedy digit word.
- "constant threshold" and "harmonic threshold" refer to the two threshold regimes of the construction; the greedy harmonic-sine word is the harmonic case.
- The comparison values at N = 20000 are given in the linked Sturmian file.

## Proof / evidence

The source refutes the retracted formula by comparison: at N = 20000 the Sturmian prediction is
bN + O(1) = 2026, 4413, 2637 for the three targets, while (θ/π) log N gives 1.00, 2.19, 1.31, so the
retracted formula matches neither the Sturmian value nor the truth (O(1) ones for rational targets,
O(log log N) for irrational ones). It states the correct regime reading: constant threshold → Θ(N)
ones, harmonic threshold → Θ(log log N) ones.

## Dependencies and related results

- [round7-agentb-sturmian-word-count](round7-agentb-sturmian-word-count.md) — the Sturmian count used as the comparison standard.
- [round7-agentb-an-log-log-n-growth](round7-agentb-an-log-log-n-growth.md) — the Θ(log log N) law for the harmonic threshold.

## Notes

- Status REFUTED records the source's own verdict word ("the retracted claim"), and the correction is
  explicitly a correction of the earlier post-mortem, not of the original retraction.
- The source notes the "constant vs harmonic threshold" reading is right in spirit; only the
  identification with the Sturmian value is wrong.
