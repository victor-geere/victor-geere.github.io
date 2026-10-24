# Theorem 4

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §5 "The floor"

## Statement

> **Theorem 4.** If ν ≤ μ as measures then λ_min(T_n(ν)) ≤ λ_min(T_n(μ)).

## Hypotheses and notation

- ν ≤ μ as measures (ν is dominated by μ); `T_n` the Toeplitz moment matrix of
  a finite positive measure on 𝕋 as in [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md).
- `λ_min` the smallest eigenvalue of that matrix.

## Proof / evidence

The source's proof, verbatim: "T_n(μ) − T_n(ν) = T_n(μ−ν), the Toeplitz moment
matrix of a positive measure, hence PSD. ∎"

## Dependencies and related results

- [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md): this monotonicity is the licence for evaluating the floor
  (9) on a sub-measure.
- The source's reading: "So (9) evaluated on **any finite sub-table of
  ordinates is valid for the whole measure**, with no tail estimate: truncating
  the zero table can only lower A, and lowering A can only lower the floor.
  That is not true of λ_min itself, where the cut at r = 4800 leaves rh29's
  residue of 1.38e−7 to be accounted for. It is also the licence for the
  retention sweep — discarding light atoms is a legal choice of ν, so (9) may be
  maximised over retention thresholds exactly as rh30 §5 does for route two."

## Notes

- The theorem itself is stated before the explanatory paragraph; the source
  introduces the pair as "the two facts about q ⪰ 0" of §4 and then "the floor"
  of §5, with this one-line dominance result as the second of the section's two
  numbered theorems.
- The "retention sweep" it licenses is used in §6's comparison, where both
  bounds are "swept over retention thresholds".
