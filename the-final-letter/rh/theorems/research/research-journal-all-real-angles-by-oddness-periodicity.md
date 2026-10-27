# All real angles by oddness and 2π-periodicity, error unchanged

**Kind:** Proposition
**Status:** PROVED (paper argument, exact reduction)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — "Status of the starting claims", line 18; Synthesis §1, line 412

## Statement

> All real angles by oddness + 2π-periodicity, error unchanged.

The source's basis column and its later restatement:

> All real angles by oddness + 2π-periodicity, error unchanged | stands | reduction is exact, not a new series

> Angles α_n = π/(n+2), greedy bits δ_n ∈ {0,1}, invariant s_n = sin θ_n exact, residual bound |sin θ − s_N| ≤ π/(N+1), **all real angles reached by oddness and 2π-periodicity**.

## Hypotheses and notation

- The greedy harmonic sine is constructed on [0,π] (θ ∈ [0,π]).
- Oddness: sin(−θ) = −sin θ; 2π-periodicity: sin(θ + 2πk) = sin θ.
- "Error unchanged" means the bound |sin θ − s_N| ≤ π/(N+1) is not altered by the reduction.

## Proof / evidence

The source states the reduction and its basis in one line: "reduction is exact, not a new series". The journal gives this as a standing starting claim, and lists it among the properties of the construction in the Synthesis ("all real angles reached by oddness and 2π-periodicity"). It supplies no separate proof beyond the observation that oddness and 2π-periodicity transport the [0,π] construction verbatim.

## Dependencies and related results

- [Greedy harmonic sine: |sin θ − s_N| ≤ π/(N+1) on [0,π]](research-journal-greedy-harmonic-sine-error-bound.md) — the bound that the reduction preserves.
- [Termination of the greedy Egyptian expansion for rational θ/π](research-journal-rational-termination.md) — the same reduction applies to termination for rational θ/π outside [0,1].

## Notes

- The status is PROVED (paper argument) on the strength of the exactness of the symmetry reduction; the underlying [0,π] bound itself has the status recorded in the error-bound file.
- This is one of the two rows of the starting-claims table that "stand" and are not merely a handoff restatement (the other being the angle-addition dichotomy).
