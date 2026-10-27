# Squarefree density 1 − 6/π² and the count up to 2×10⁶

**Kind:** Claim
**Status:** VERIFIED (numerical)
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(b) "Moller", line 18

## Statement

> squarefree density 1-6/pi^2 = 0.3920728981 (A correct); count<=2e6 = 1215877.

## Hypotheses and notation

- "squarefree density" is the natural density of squarefree integers, quoted as 1 − 6/π² = 0.3920728981; the complementary density of non-squarefree integers is 6/π² = 0.6079271018…
- "count<=2e6" is #{n ≤ 2×10⁶ : μ²(n) = 1}.

## Proof / evidence

The source reports the density value 0.3920728981 and the exact count 1215877, attributing the
density to "A" as correct. No proof is given in the document; the density 1 − 6/π² is the classical
squarefree density.

## Dependencies and related results

- [round1-verdict-agentb-moller-squarefree-series](round1-verdict-agentb-moller-squarefree-series.md) — the companion value Σ_{n≤2×10⁶} μ²(n)n^{−3} and the residue correction.

## Notes


- The source gives no derivation; the count 1215877 is a finite exact enumeration.
- The source's own arithmetic check is internal: the density quoted as 1 − 6/π² is written as
  0.3920728981, the complement of 6/π² = 0.6079271018…
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `audit3.py`, `verify/round1_corrected.py`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
