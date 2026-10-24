# The constant-threshold contrast: Θ(N) ones versus Θ(log log N) ones

**Kind:** Proposition
**Status:** PROVED (paper argument; the Sturmian clause is classical, the log log clause is verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7 Agent B correction, line 570; "The corrected results about the digit word itself", line 628

## Statement

> **B's correction to the post-mortem of the retracted density.** My reading was that (θ/π)log N was the constant-threshold (Sturmian) prediction. B refuted the identification: a Sturmian word of slope b = θ/π has #ones(N) = bN + O(1), which is **linear** (2026, 4413, 2637 at N = 20000 for the three targets), and the retracted (θ/π)log N gives 1.00, 2.19, 1.31 — so the retracted formula matches neither. The correct post-mortem: **constant threshold → Θ(N) ones; harmonic threshold → Θ(log log N) ones; (θ/π)log N matches neither.**

Restated in the corrected results about the digit word:

> **The constant-threshold contrast:** constant threshold → Θ(N) ones (Sturmian, linear); harmonic threshold → Θ(log log N) ones. The retracted (θ/π)log N matches **neither**.

## Hypotheses and notation

- "Constant threshold": a Sturmian coding of slope b = θ/π, for which #ones(N) = bN + O(1).
- "Harmonic threshold": the greedy word in the alphabet 1/(n+2), for which A(N) = log₂ log N + O(1).
- The retracted density (θ/π)log N is compared against both and matches neither; measured bN + O(1) counts at N = 20000: 2026, 4413, 2637; retracted (θ/π)log N values: 1.00, 2.19, 1.31.

## Proof / evidence

The Sturmian linear count #ones(N) = bN + O(1) is the classical characterisation of codings of irrational rotations (cf. Morse–Hedlund). Measured counts at N = 20000 for the three targets: 2026, 4413, 2637 versus the retracted formula's 1.00, 2.19, 1.31. The harmonic-threshold clause is the measured digit-count law A(N) = log₂ log N + O(1).

## Dependencies and related results

- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the harmonic-threshold clause.
- [Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian](research-journal-morse-hedlund.md) — the classical framework for the constant-threshold clause.
- [Termination of the greedy Egyptian expansion for rational θ/π](research-journal-rational-termination.md) — the rational contrast: Θ(1) ones.

## Notes

- The source states this as the "correct post-mortem" after Agent B refuted the mediator's identification of the retracted density with the Sturmian prediction; the refutation of that identification is itself part of Agent B's final verdict ("DISPROVEN … for identifying (θ/π)log N with the Sturmian prediction").
- This file records the contrast between the two thresholds; it is not a claim that the greedy word is Sturmian — it is the opposite.
