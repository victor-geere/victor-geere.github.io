# (F1) 1 ≤ M ≤ n

**Kind:** Claim
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §4 "The two facts about q ⪰ 0 that no variation bound uses"

## Statement

> **(F1) 1 ≤ M ≤ n.** Mean 1 forces max ≥ 1; Cauchy–Schwarz on n coefficients
> gives |p| ≤ √n·‖c‖₂ = √n.

## Hypotheses and notation

- q is feasible for (5) of [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md): q ≥ 0 a trig polynomial of
  degree ≤ n−1 with `(1/2π)∫q dθ = 1`.
- `D = n − 1`, `M = ‖q‖_∞`, and `q = |p|²` with `p = Σ_{k<n} c_k e^{ikθ}`,
  `‖c‖₂ = 1` (the substitution used in Theorem 1's proof).

## Proof / evidence

The source's proof, verbatim: "Mean 1 forces max ≥ 1; Cauchy–Schwarz on n
coefficients gives |p| ≤ √n·‖c‖₂ = √n."

## Dependencies and related results

- [Theorem 1](xihorn-rh30-10-a-t1-lp-form-of-lambda-min.md) (the feasible set and the q = |p|² substitution).
- Used in the bookkeeping of [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md): "Fix a feasible q and let
  M = ‖q‖_∞, which lies in [1, n] by (F1)."
- The source's §8 (b) records that "the first branch [of (9)] is fixed at
  s = ½, and (F1)'s upper end M ≤ n is used nowhere".

## Notes

- The source labels this "(F1)" and calls §4's items "facts" about q ⪰ 0 rather
  than numbered theorems; it is harvested here as a Claim because it is an
  explicitly labelled assertion with mathematical content that the proof of
  [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md) invokes by name.
- The source's framing of the three facts: "Neither fact is available to a
  variation bound: both are statements that a non-negative normalised polynomial
  *cannot be small everywhere*, and both are false for signed q of the same
  degree."
