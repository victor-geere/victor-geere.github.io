# The error bound with the radial decay substituted

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §4 "The radial decay of the term", lines 264–276

## Statement

> **The error bound with the radial decay substituted.** Combining the triangle bound with `abs_zetaTerm`, the sharp-versus-smoothed error at `s = σ + t·I` is bounded by `∑_{n≤N} ‖1 - φ (n/N)‖ · n^{-σ}` — the form in which the round reads off the `O(√N)` (sharp, `φ ≡ 1` has defect `0`) versus `O(N^{-σ})` (smooth) laws.

```lean
theorem norm_zetaSum_sub_smoothedSum_le_rpow (N : ℕ) (φ : ℝ → ℝ) (σ t : ℝ) :
    ‖zetaSum N ((σ : ℂ) + (t : ℂ) * Complex.I)
        - smoothedSum N φ ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖1 - φ ((n : ℝ) / N)‖ * (n : ℝ) ^ (-σ)
```

## Hypotheses and notation

- `N : ℕ` — cutoff, index range `Finset.Icc 1 N`.
- `φ : ℝ → ℝ` — arbitrary weight, sampled at the normalised abscissae `n/N`.
- `σ t : ℝ` with `s = σ + t·I`, written `(σ : ℂ) + (t : ℂ) * Complex.I`.
- The right-hand side replaces each `‖zetaTerm s n‖` by its exact value `(n : ℝ) ^ (-σ)` (real `rpow`).
- `1 - φ (n/N)` is the weight defect of the sharp sum (`φ ≡ 1`) relative to the weight `φ`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `norm_zetaSum_sub_smoothedSum_le_rpow` in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) (lines 269–276). It is `norm_zetaSum_sub_smoothedSum_le N φ _` followed by `Finset.sum_le_sum`, bounding each summand with `mul_le_mul_of_nonneg_left` applied to `le_of_eq (abs_zetaTerm σ t hn1)`, where `hn1 : 1 ≤ n` comes from `Finset.mem_Icc.mp hn`.
- No extra axiom and no computation by reflection (file header).

## Dependencies and related results

- [Two-weight triangle bound](lean-rh044-smoothing-two-weight-triangle-bound.md) — the triangle bound (`norm_zetaSum_sub_smoothedSum_le`) that this theorem specialises termwise.
- [Radial decay `‖zetaTerm (σ + t·I) n‖ = n^{-σ}`](lean-rh044-smoothing-radial-decay.md) — supplies the exact term moduli.
- [`tpp-rh044-truths-theorem-2-weight-law.md`](../tpp/tpp-rh044-truths-theorem-2-weight-law.md) — the round's main (numerical) weight law `|S_N^φ − ζ|/√N → |M_φ(s)|` that this rigorous estimate underlies.

## Notes

- The doc comment of the declaration is the source of the last clause of the statement: the bound is written "in the form in which the round reads off the `O(√N)` (sharp, `φ ≡ 1` has defect `0`) versus `O(N^{-σ})` (smooth) laws". Those `O(·)` laws are the numerical round's statements (see the round's truths file); they are not part of this Lean theorem.
- The substitution of the term moduli is exact — `‖zetaTerm s n‖` is replaced by its exact value `n^{-σ}`, so no loss occurs at this step beyond the triangle step of the parent bound.
