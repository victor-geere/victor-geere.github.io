# Two-weight triangle bound

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §3 "The triangle-inequality error bound", lines 157–208

## Statement

> **Two-weight triangle bound.** The difference of two smoothed sums is bounded by the sum of the pointwise weight differences times the term moduli: `‖smoothedSum N φ s - smoothedSum N ψ s‖ ≤ ∑_{n≤N} ‖φ (n/N) - ψ (n/N)‖ · ‖zetaTerm s n‖`.

```lean
theorem norm_smoothedSum_sub_smoothedSum_le (N : ℕ) (φ ψ : ℝ → ℝ) (s : ℂ) :
    ‖smoothedSum N φ s - smoothedSum N ψ s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖φ ((n : ℝ) / N) - ψ ((n : ℝ) / N)‖ * ‖zetaTerm s n‖
```

The same bound is carried by three further declarations in the same file, folded into this file (their names and lines are given in Proof / evidence):

```lean
theorem norm_smoothedSum_sub_zetaSum_le (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    ‖smoothedSum N φ s - zetaSum N s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖φ ((n : ℝ) / N) - 1‖ * ‖zetaTerm s n‖

theorem norm_zetaSum_sub_smoothedSum_le (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    ‖zetaSum N s - smoothedSum N φ s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖1 - φ ((n : ℝ) / N)‖ * ‖zetaTerm s n‖

theorem norm_smoothedSum_sub_zetaSum_le' (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    ‖smoothedSum N φ s - zetaSum N s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖1 - φ ((n : ℝ) / N)‖ * ‖zetaTerm s n‖
```

## Hypotheses and notation

- `N : ℕ` — cutoff, index range `Finset.Icc 1 N`.
- `φ ψ : ℝ → ℝ` — two arbitrary weights, sampled at `n/N`.
- `s : ℂ` — arbitrary complex argument.
- `‖·‖` is the norm on `ℂ` for `zetaTerm`, and the real norm for the weight differences `φ (n/N) - ψ (n/N)` (coerced through `Complex.norm_real`).
- `zetaSum N s` is the sharp sum; taking `ψ ≡ 1` (`smoothedSum_one`) specialises the two-weight bound to the sharp sum.

## Proof / evidence

- **PROVED** in Lean, no `sorry`, all four declarations in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) §3; no extra axiom and no computation by reflection.
  - `norm_smoothedSum_sub_smoothedSum_le` (lines 166–179): rewrites the difference of the two smoothed sums as `∑ (φ(n/N) - ψ(n/N)) · zetaTerm s n`, then applies `norm_sum_le`, `norm_mul` and `Complex.norm_real`.
  - `norm_smoothedSum_sub_zetaSum_le` (lines 184–188): the specialisation `ψ ≡ 1`, using `smoothedSum_one` to replace `smoothedSum N (fun _ => 1) s` by `zetaSum N s`.
  - `norm_zetaSum_sub_smoothedSum_le` (lines 193–200): the reverse difference, obtained from the exact decomposition `weighted_decomposition` plus `norm_sum_le`, `norm_mul`, `Complex.norm_real`.
  - `norm_smoothedSum_sub_zetaSum_le'` (lines 204–208): `norm_zetaSum_sub_smoothedSum_le` with the two sides of the difference exchanged (`norm_sub_rev`) and the defect written as `1 - φ (n/N)`.

## Dependencies and related results

- Mathlib facts used: `norm_sum_le`, `norm_mul`, `Complex.norm_real`, `norm_sub_rev`.
- [Key exact identity (weight defect)](lean-rh044-smoothing-weighted-decomposition.md) — used by `norm_zetaSum_sub_smoothedSum_le`.
- [The error bound with the radial decay substituted](lean-rh044-smoothing-error-bound-rpow.md) — sharpens this bound by inserting the exact term moduli `n^{-σ}`.

## Notes

- The source explains why the two-weight form is the primary statement: "The brief wrote the left-hand side as `smoothedSum N φ s - zetaSum N ψ s`; since `zetaSum` carries no weight, the meaningful two-weight statement is this one (the right-hand side is the one displayed in the brief). Taking `ψ ≡ 1` (`norm_smoothedSum_sub_zetaSum_le`) and `φ ≡ 1` (`norm_zetaSum_sub_smoothedSum_le`) specialises it back to `zetaSum`."
- The source calls this family "the elementary rigorous error bound obtained from the triangle inequality for the norm on `ℂ`" and "the estimate that the numerical round refines into the error laws `O(√N)` (sharp) versus `O(N^{-σ})` (smooth)".
- The three specialisations/rewritings are folded into this single file as near-duplicates of the same inequality (the range is literally the same, `Finset.Icc 1 N`).
