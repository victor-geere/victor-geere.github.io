# Split into `zetaSum`-type pieces

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §5 "The quadratic weight `φ u = u (1 - u)`", lines 315–326

## Statement

> **Split into `zetaSum`-type pieces.** The quadratic weight splits as `u (1 - u) = u - u²`, so `smoothedSum N quadWeight s = ∑ (n/N) zetaTerm s n - ∑ (n/N)² zetaTerm s n`.

```lean
theorem smoothedSum_quadWeight_split (N : ℕ) (s : ℂ) :
    smoothedSum N quadWeight s
      = (∑ n ∈ Finset.Icc 1 N, ((((n : ℝ) / N) : ℝ) : ℂ) * zetaTerm s n)
        - ∑ n ∈ Finset.Icc 1 N, (((((n : ℝ) / N) ^ 2 : ℝ)) : ℂ) * zetaTerm s n
```

with the quadratic weight defined in the same file (line 283) by

```lean
def quadWeight (u : ℝ) : ℝ := u * (1 - u)
```

## Hypotheses and notation

- `N : ℕ` — cutoff, index range `Finset.Icc 1 N`.
- `s : ℂ` — arbitrary complex argument.
- `quadWeight u = u (1 - u)`, and `smoothedSum N quadWeight s = ∑_{n ≤ N} quadWeight (n/N) · zetaTerm s n`.
- The two pieces on the right are `zetaSum`-type sums: the same finite range with the weights `u` and `u²` (sampled at `n/N`) in place of the general weight `φ`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `smoothedSum_quadWeight_split` in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) (lines 318–326). The proof unfolds `smoothedSum`, applies `Finset.sum_sub_distrib` in reverse, and closes each summand under `Finset.sum_congr rfl` by unfolding `quadWeight` and using `push_cast` and `ring_nf`.
- No extra axiom and no computation by reflection (file header).

## Dependencies and related results

- [The weight defect of the quadratic weight in closed form](lean-rh044-smoothing-quadratic-weight-defect.md) — the companion computation for the same weight.
- [Key exact identity (weight defect)](lean-rh044-smoothing-weighted-decomposition.md) — the general decomposition whose quadratic-weight instance is `zetaSum_sub_smoothedSum_quadWeight` (lines 364–368) and `weighted_decomposition_quadWeight_defect` (lines 370–379).

## Notes

- The split is the algebraic rewriting `u (1 - u) = u - u²` applied inside the finite sum; the source uses it to express the quadratic-weight smoothed sum through two `zetaSum`-type pieces.
- The source also records the unwound coefficient form `smoothedSum_quadWeight` (`smoothedSum N quadWeight s = ∑ ((n/N)(1 - n/N)) · zetaTerm s n`, line 309, by `rfl`) and the instance `zetaSum_sub_smoothedSum_quadWeight` of the weighted decomposition; neither is harvested separately, the first because it is a definitional unfolding and the second because it is the general identity specialised.
