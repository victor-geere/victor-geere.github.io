# Refuted: candidate model D, p(L) = min(L + span, N − L + 1)

**Kind:** Theorem
**Status:** REFUTED (exact enumeration)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §3.3 "Saturation, measured exactly", line 132, and §5 line 184

## Statement

> **Candidate model D: `p(L) = min(L + span, N − L + 1)`** matched every case tested in the final probe ({2,13,607} at L = 800 gives min(1405, 601) = 601 = truth; {139,151} at L = 13 gives min(25, 160) = 25, truth 15 — **so D fails there too**). I record D as a *tested-and-failing* candidate, not a conjecture, and note that {139,151} with span 12 is a useful smallest counterexample.
>
> §5: | Model D: p(L) = min(L + span, N − L + 1) | **FAILS** | {139,151}, N = 172, span = 12, L = 13: 25 vs truth 15 |

The source states the candidate law and its refutation by exact enumeration.

## Hypotheses and notation

- p(L) := #{ distinct factors of length L occurring in w } (§2), counted in the truncation w_N of length N.
- span is the distance from the first to the last 1 of the word (605 for {2, 13, 607}; 12 for {139, 151}).
- N − L + 1 is the number of length-L windows available in the truncation (the ceiling on p(L)).

## Proof / evidence

Refuted by exact enumeration. D survives the large-word probe ({2,13,607} at N = 1400, L = 800: min(1405, 601) = 601, which equals the measured 601) but fails on the small word {139, 151} with N = 172, span = 12, L = 13: it predicts min(25, 160) = 25 against truth 15. The source records it "as a *tested-and-failing* candidate, not a conjecture", and notes {139,151} with span 12 as "a useful smallest counterexample". §8.2 item 5 makes the failure a required regression test.

## Dependencies and related results

- [handoff-offset-tuple-characterisation](handoff-offset-tuple-characterisation.md) — the exact enumeration used as the truth value.
- §3.3 also records the failure of two simpler models on the same ground: L + span fails ({2,13,607}, L = 606: formula 1211, truth 609; {10,20,40,80}, L = 71: formula 141, truth 82) and N − L + 1 fails ({2,13,607}, L = 606: formula 795, truth 609).
- §4 C2a/C2b state the open problem that model D was an attempt at.

## Notes

- The source explicitly qualifies the refutation's scope: model D "matched every case tested in the final probe" on the large words, and its failure is on the small counterexample {139,151}. This is a refutation of the model as a general law, not a claim about every instance.
- Status REFUTED records the source's own verdict word ("FAILS"), established by the recorded counterexamples.
