import Mathlib
import LipSmall3
import DensityPanel
import OmegaPanel

/-!
# The second derivative of `Ω`

[`DensityPanel.lean`](DensityPanel.lean) bounds `|Ω′|` through the polygamma
series `ψ′(z) = Σ_j (z+j)⁻²`.  The second-order panel rule needs the same for
`ψ″`:

```
ψ″(z) = -2 Σ_j (z+j)⁻³,      |Ω″(t)| ≤ 5/t²   (t ≥ 1).
```

## The estimate

The Gauss/Hurwitz series `Rh45RouteBAnalytic.digamma_polygamma_series` is
general in `k`, so at `k = 2` it gives

```
Σ_j (z+j)⁻³ = -(1/2) ψ″(z),
```

hence `‖ψ″(z)‖ ≤ 2 Σ_j ‖(z+j)⁻³‖`.  Since `‖z+j‖² = (j+1/4)² + (t/2)²` and
`‖z+j‖ ≥ t/2`, each term is at most `(2/t)·((j+1/4)²+(t/2)²)⁻¹`, so

```
‖ψ″(z)‖ ≤ (2/t) · 2 · Σ_j ((j+1/4)²+(t/2)²)⁻¹ ≤ (2/t) · 2 · (5/t) = 20/t²
```

by the `5/(2a)` bound of [`LipSmall3.lean`](LipSmall3.lean) at `a = t/2`.
Finally `Ω = -log π + Re Ψ` with `Ψ(t) = ψ(1/4+it/2)`, and
`(d/dt)² Ψ = (i/2)² ψ″ = -(1/4) ψ″`, so `|Ω″| ≤ (1/4)·20/t² = 5/t²`.

This is the analytic input of the second-order panel rule: with a second
derivative bound the midpoint rule costs `h³` per panel instead of `h²`, and the
panel count of a rung falls accordingly.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- `‖s + j‖²` for `s = 1/4 + it/2`. -/
lemma norm_sPointR_add_sq (t : ℝ) (j : ℕ) :
    ‖IntersectionForm.sPointR t + (j : ℂ)‖ ^ 2
      = ((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
  rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
  simp [IntersectionForm.sPointR]
  ring


/-- `iteratedDeriv 1 Ψ` is differentiable. -/
lemma differentiableAt_iteratedDeriv_one (t : ℝ) :
    DifferentiableAt ℝ (iteratedDeriv 1 Rh45.Psi) t := by
  have hF : DifferentiableAt ℂ (iteratedDeriv 1 Complex.digamma) (Rh45.digammaLine t) := by
    have h := (Rh45.analyticAt_digamma_line t).iterated_deriv 1
    have h' : AnalyticAt ℂ (iteratedDeriv 1 Complex.digamma) (Rh45.digammaLine t) := by
      rwa [← iteratedDeriv_eq_iterate] at h
    exact h'.differentiableAt
  have hline : DifferentiableAt ℝ Rh45.digammaLine t := by
    unfold Rh45.digammaLine
    fun_prop
  have hcomp : DifferentiableAt ℝ
      (fun u : ℝ => iteratedDeriv 1 Complex.digamma (Rh45.digammaLine u)) t :=
    (hF.restrictScalars (𝕜 := ℝ) (𝕜' := ℂ)).comp t hline
  have hfun : iteratedDeriv 1 Rh45.Psi =
      fun u => (Complex.I / 2) ^ 1 * iteratedDeriv 1 Complex.digamma (Rh45.digammaLine u) :=
    funext (Rh45.iteratedDeriv_Psi_eq 1)
  rw [hfun]
  exact hcomp.const_mul _

/-- The cube-term estimate: `‖(z+j)⁻³‖ ≤ (2/t)·((j+1/4)²+(t/2)²)⁻¹`. -/
lemma norm_polygamma_term_cube_le (t : ℝ) (ht : 0 < t) (j : ℕ) :
    ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
      ≤ (2 / t) * ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ := by
  have hDpos : (0 : ℝ) < ((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by positivity
  have hsq := norm_sPointR_add_sq t j
  have hne : IntersectionForm.sPointR t + (j : ℂ) ≠ 0 := by
    intro h
    rw [h] at hsq
    simp at hsq
    linarith [hDpos]
  have hnormpos : (0 : ℝ) < ‖IntersectionForm.sPointR t + (j : ℂ)‖ :=
    lt_of_le_of_ne (norm_nonneg _) (Ne.symm (norm_ne_zero_iff.mpr hne))
  have hnorm_ge : t / 2 ≤ ‖IntersectionForm.sPointR t + (j : ℂ)‖ := by
    have h2 : (t / 2) ^ 2 ≤ ‖IntersectionForm.sPointR t + (j : ℂ)‖ ^ 2 := by
      rw [hsq]
      nlinarith [sq_nonneg ((j : ℝ) + 1 / 4)]
    have := sq_le_sq.mp h2
    rwa [abs_of_nonneg (by linarith), abs_of_nonneg (norm_nonneg _)] at this
  have hpt : IntersectionForm.sPointR t + (j : ℂ)
      = (1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ) := by
    simp [IntersectionForm.sPointR]
  have hkey : ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
      = ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹
          * (‖IntersectionForm.sPointR t + (j : ℂ)‖)⁻¹ := by
    rw [show (-3 : ℤ) = -2 + -1 by norm_num, zpow_add₀ hne, norm_mul, hpt,
      IntersectionForm.norm_polygamma_term_sq t j, zpow_neg_one, norm_inv]
  rw [hkey]
  have hinv : (‖IntersectionForm.sPointR t + (j : ℂ)‖)⁻¹ ≤ 2 / t := by
    rw [inv_eq_one_div, div_le_div_iff₀ hnormpos ht]
    nlinarith
  calc ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹
        * (‖IntersectionForm.sPointR t + (j : ℂ)‖)⁻¹
      ≤ ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ * (2 / t) :=
        mul_le_mul_of_nonneg_left hinv (le_of_lt (inv_pos.mpr hDpos))
    _ = (2 / t) * ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ := by ring

/-- **The cube series.**  `Σ_j (z+j)⁻³ = -(1/2) ψ″(z)`. -/
lemma hasSum_polygamma_cube (t : ℝ) :
    HasSum (fun j : ℕ => (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ))
      (-(1 / 2) * deriv (deriv Complex.digamma) (IntersectionForm.sPointR t)) := by
  have hs : 0 < (Rh45.digammaLine t).re := by
    rw [Rh45.digammaLine_re]
    norm_num
  have h := Rh45RouteBAnalytic.digamma_polygamma_series 2 (by norm_num)
    (s := Rh45.digammaLine t) hs
  rw [← IntersectionForm.sPointR_eq_digammaLine] at h
  have h' : HasSum (fun j : ℕ => (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ))
      (((-1 : ℂ) ^ (2 + 1) * ((Nat.factorial 2 : ℕ) : ℂ))⁻¹
        * deriv^[2] (logDeriv Complex.Gamma) (IntersectionForm.sPointR t)) := by
    refine h.congr ?_
    intro j
    norm_num
  convert h' using 1
  -- the series value: ((-1)^3 * 2!)⁻¹ * ψ″  =  -(1/2) ψ″
  have hid2 : deriv^[2] (logDeriv Complex.Gamma)
      = deriv (deriv (logDeriv Complex.Gamma)) := by
    rw [← iteratedDeriv_eq_iterate, iteratedDeriv_succ, iteratedDeriv_succ, iteratedDeriv_zero]
  have hiter : deriv^[2] (logDeriv Complex.Gamma) (IntersectionForm.sPointR t)
      = deriv (deriv Complex.digamma) (IntersectionForm.sPointR t) := by
    rw [hid2]
    rfl
  rw [hiter]
  norm_num

/-- **`‖ψ″‖ ≤ 20/t²`.** -/
lemma norm_deriv2_digamma_le (t : ℝ) (ht : 1 ≤ t) :
    ‖deriv (deriv Complex.digamma) (IntersectionForm.sPointR t)‖ ≤ 20 / t ^ 2 := by
  have ht0 : (0 : ℝ) < t := by linarith
  have ha : (1 / 2 : ℝ) ≤ t / 2 := by linarith
  have h := hasSum_polygamma_cube t
  have hpsi : deriv (deriv Complex.digamma) (IntersectionForm.sPointR t)
      = -2 * ∑' j : ℕ, (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ) := by
    rw [h.tsum_eq]
    ring
  rw [hpsi, norm_mul, show ‖(-2 : ℂ)‖ = 2 by norm_num]
  have hnorm : ‖∑' j : ℕ, (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
      ≤ ∑' j : ℕ, ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖ :=
    norm_tsum_le_tsum_norm h.summable.norm
  have hb : ∑' j : ℕ, ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖ ≤ 10 / t ^ 2 := by
    refine Real.tsum_le_of_sum_range_le (fun j => norm_nonneg _) (fun N => ?_)
    have hstep : ∀ j : ℕ, ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
        ≤ (2 / t) * ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ :=
      fun j => norm_polygamma_term_cube_le t ht0 j
    calc ∑ j ∈ Finset.range N, ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
        ≤ ∑ j ∈ Finset.range N, (2 / t) * ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ :=
          Finset.sum_le_sum fun j _ => hstep j
      _ = (2 / t) * ∑ j ∈ Finset.range N, ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ := by
          rw [Finset.mul_sum]
      _ ≤ (2 / t) * (5 / (2 * (t / 2))) := by
          have := sum_range_shifted_inv_le_five_halves ha N
          exact mul_le_mul_of_nonneg_left this (by positivity)
      _ = 10 / t ^ 2 := by
          field_simp
          ring
  have h2 : 2 * ‖∑' j : ℕ, (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖ ≤ 2 * (10 / t ^ 2) := by
    linarith
  have h3 : (2 : ℝ) * (10 / t ^ 2) = 20 / t ^ 2 := by
    field_simp
    ring
  linarith

/-- **The second derivative of `Ω`.** -/
theorem deriv2_Omega_eq (t : ℝ) :
    deriv (deriv IntersectionForm.Omega) t = (iteratedDeriv 2 Rh45.Psi t).re := by
  have hfun : deriv IntersectionForm.Omega =
      fun u => (iteratedDeriv 1 Rh45.Psi u).re := funext IntersectionForm.deriv_Omega_eq
  rw [hfun]
  have hd : HasDerivAt (fun u : ℝ => (iteratedDeriv 1 Rh45.Psi u).re)
      ((deriv (iteratedDeriv 1 Rh45.Psi) t).re) t := by
    have hf : HasFDerivAt (iteratedDeriv 1 Rh45.Psi)
        (fderiv ℝ (iteratedDeriv 1 Rh45.Psi) t) t :=
      (differentiableAt_iteratedDeriv_one t).hasFDerivAt
    exact (Complex.reCLM.hasFDerivAt.comp t hf).hasDerivAt
  rw [hd.deriv, ← iteratedDeriv_succ]

/-- `‖(d/dt)² Ψ‖ = (1/4)‖ψ″‖`. -/
lemma norm_iteratedDeriv_two_Psi (t : ℝ) :
    ‖iteratedDeriv 2 Rh45.Psi t‖
      = (1 / 4) * ‖deriv (deriv Complex.digamma) (Rh45.digammaLine t)‖ := by
  have hid : iteratedDeriv 2 Complex.digamma = deriv (deriv Complex.digamma) := by
    rw [iteratedDeriv_succ, iteratedDeriv_succ, iteratedDeriv_zero]
  rw [Rh45.iteratedDeriv_Psi_eq 2, hid, norm_mul, norm_pow, Rh45.norm_half_I]
  norm_num

/-- **`|Ω″(t)| ≤ 5/t²`.** -/
theorem abs_deriv2_Omega_le (t : ℝ) (ht : 1 ≤ t) :
    |deriv (deriv IntersectionForm.Omega) t| ≤ 5 / t ^ 2 := by
  rw [deriv2_Omega_eq]
  have h1 : |(iteratedDeriv 2 Rh45.Psi t).re| ≤ ‖iteratedDeriv 2 Rh45.Psi t‖ :=
    Complex.abs_re_le_norm _
  have h2 : ‖iteratedDeriv 2 Rh45.Psi t‖
      = (1 / 4) * ‖deriv (deriv Complex.digamma) (Rh45.digammaLine t)‖ :=
    norm_iteratedDeriv_two_Psi t
  have h3 : ‖deriv (deriv Complex.digamma) (Rh45.digammaLine t)‖ ≤ 20 / t ^ 2 := by
    rw [← IntersectionForm.sPointR_eq_digammaLine]
    exact norm_deriv2_digamma_le t ht
  have h4 : (1 / 4) * (20 / t ^ 2) = 5 / t ^ 2 := by ring
  linarith

/-- **The quarter-cube partial sums.**  `Σ_{j<N} ((j+1/4)³)⁻¹ ≤ 66`: the first
term is `64`, the rest telescopes against `2/((j+1)(j+2))`. -/
theorem sum_range_quarter_cube_le (N : ℕ) :
    ∑ j ∈ Finset.range N, ((((j : ℝ) + 1 / 4) ^ 3))⁻¹ ≤ 66 := by
  match N with
  | 0 => simp
  | M + 1 =>
    rw [Finset.sum_range_succ']
    have h0 : ((((0 : ℕ) : ℝ) + 1 / 4) ^ 3)⁻¹ = 64 := by norm_num
    have hstep : ∀ j : ℕ, ((((j : ℝ) + 1 + 1 / 4) ^ 3))⁻¹ ≤
        2 * (1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2)) := by
      intro j
      have hX : (0 : ℝ) < ((j : ℝ) + 1 + 1 / 4) ^ 3 := by positivity
      have hY : (0 : ℝ) < ((j : ℝ) + 1) * ((j : ℝ) + 2) := by positivity
      have hprod : 2 * (1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2))
          = 2 / (((j : ℝ) + 1) * ((j : ℝ) + 2)) := by
        field_simp
        ring
      rw [hprod]
      have hY2 : (0 : ℝ) < 2 / (((j : ℝ) + 1) * ((j : ℝ) + 2)) := by positivity
      rw [inv_le_comm₀ hX hY2, inv_div]
      rw [div_le_iff₀ (by norm_num : (0 : ℝ) < 2)]
      nlinarith [Nat.cast_nonneg (α := ℝ) j]
    have hsum : ∑ i ∈ Finset.range M, 2 * (1 / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) ≤ 2 := by
      rw [← Finset.mul_sum, sum_telescope_inv]
      have hm : (0 : ℝ) ≤ 1 / ((M : ℝ) + 1) := by positivity
      nlinarith
    have hmono : ∑ i ∈ Finset.range M, ((((i : ℝ) + 1 + 1 / 4) ^ 3))⁻¹ ≤
        ∑ i ∈ Finset.range M, 2 * (1 / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) :=
      Finset.sum_le_sum fun i _ => hstep i
    rw [h0]
    simp only [Nat.cast_add, Nat.cast_one] at *
    linarith

/-- `Σ_j ((j+1/4)³)⁻¹ ≤ 66`. -/
theorem tsum_quarter_cube_le : ∑' j : ℕ, ((((j : ℝ) + 1 / 4) ^ 3))⁻¹ ≤ 66 :=
  Real.tsum_le_of_sum_range_le (fun j => by positivity) sum_range_quarter_cube_le

/-- `‖(z+j)⁻³‖ ≤ ((j+1/4)³)⁻¹`, from `‖z+j‖² = (j+1/4)²+(t/2)²`. -/
lemma norm_term_cube_le_quarter (t : ℝ) (j : ℕ) :
    ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖ ≤ ((((j : ℝ) + 1 / 4) ^ 3))⁻¹ := by
  have hDpos : (0 : ℝ) < ((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by positivity
  have hsq := norm_sPointR_add_sq t j
  have hne : IntersectionForm.sPointR t + (j : ℂ) ≠ 0 := by
    intro h
    rw [h] at hsq
    simp at hsq
    linarith [hDpos]
  have hpt : IntersectionForm.sPointR t + (j : ℂ)
      = (1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ) := by
    simp [IntersectionForm.sPointR]
  have hkey : ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
      = ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹
          * (‖IntersectionForm.sPointR t + (j : ℂ)‖)⁻¹ := by
    rw [show (-3 : ℤ) = -2 + -1 by norm_num, zpow_add₀ hne, norm_mul, hpt,
      IntersectionForm.norm_polygamma_term_sq t j, zpow_neg_one, norm_inv]
  have hc : (0 : ℝ) < (j : ℝ) + 1 / 4 := by positivity
  have hnormpos : (0 : ℝ) < ‖IntersectionForm.sPointR t + (j : ℂ)‖ :=
    lt_of_le_of_ne (norm_nonneg _) (Ne.symm (norm_ne_zero_iff.mpr hne))
  have hge : (j : ℝ) + 1 / 4 ≤ ‖IntersectionForm.sPointR t + (j : ℂ)‖ := by
    have h2 : ((j : ℝ) + 1 / 4) ^ 2 ≤ ‖IntersectionForm.sPointR t + (j : ℂ)‖ ^ 2 := by
      rw [hsq]; nlinarith [sq_nonneg (t / 2)]
    have := sq_le_sq.mp h2
    rwa [abs_of_nonneg (by linarith), abs_of_nonneg (norm_nonneg _)] at this
  have hinv : (‖IntersectionForm.sPointR t + (j : ℂ)‖)⁻¹ ≤ (((j : ℝ) + 1 / 4))⁻¹ := by
    rw [inv_le_inv₀ hnormpos hc]
    exact hge
  have hDinv : ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ ≤ (((j : ℝ) + 1 / 4) ^ 2)⁻¹ := by
    rw [inv_le_inv₀ hDpos (by positivity)]
    nlinarith [sq_nonneg (t / 2)]
  rw [hkey]
  calc ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ * (‖IntersectionForm.sPointR t + (j : ℂ)‖)⁻¹
      ≤ (((j : ℝ) + 1 / 4) ^ 2)⁻¹ * (((j : ℝ) + 1 / 4))⁻¹ :=
        mul_le_mul hDinv hinv (inv_nonneg.mpr (norm_nonneg _)) (by positivity)
    _ = ((((j : ℝ) + 1 / 4) ^ 3))⁻¹ := by
        have hc : ((j : ℝ) + 1 / 4) ≠ 0 := by positivity
        field_simp

/-- **`‖ψ″‖ ≤ 132` everywhere.** -/
theorem norm_deriv2_digamma_le_global (t : ℝ) :
    ‖deriv (deriv Complex.digamma) (IntersectionForm.sPointR t)‖ ≤ 132 := by
  have h := hasSum_polygamma_cube t
  have hpsi : deriv (deriv Complex.digamma) (IntersectionForm.sPointR t)
      = -2 * ∑' j : ℕ, (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ) := by
    rw [h.tsum_eq]
    ring
  rw [hpsi, norm_mul, show ‖(-2 : ℂ)‖ = 2 by norm_num]
  have hnorm : ‖∑' j : ℕ, (IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖
      ≤ ∑' j : ℕ, ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖ :=
    norm_tsum_le_tsum_norm h.summable.norm
  have hb : ∑' j : ℕ, ‖(IntersectionForm.sPointR t + (j : ℂ)) ^ (-3 : ℤ)‖ ≤ 66 := by
    refine Real.tsum_le_of_sum_range_le (fun j => norm_nonneg _) (fun N => ?_)
    exact le_trans (Finset.sum_le_sum fun j _ => norm_term_cube_le_quarter t j)
      (sum_range_quarter_cube_le N)
  linarith

/-- **`|Ω″(t)| ≤ 33` everywhere.**  For `t ≥ 1` the sharp bound is
`abs_deriv2_Omega_le` (`5/t²`); this global version covers `[0,1]`. -/
theorem abs_deriv2_Omega_le_global (t : ℝ) :
    |deriv (deriv IntersectionForm.Omega) t| ≤ 33 := by
  rw [deriv2_Omega_eq]
  have h1 : |(iteratedDeriv 2 Rh45.Psi t).re| ≤ ‖iteratedDeriv 2 Rh45.Psi t‖ :=
    Complex.abs_re_le_norm _
  have h2 : ‖iteratedDeriv 2 Rh45.Psi t‖
      = (1 / 4) * ‖deriv (deriv Complex.digamma) (Rh45.digammaLine t)‖ :=
    norm_iteratedDeriv_two_Psi t
  have h3 : ‖deriv (deriv Complex.digamma) (Rh45.digammaLine t)‖ ≤ 132 := by
    rw [← IntersectionForm.sPointR_eq_digammaLine]
    exact norm_deriv2_digamma_le_global t
  linarith

end PrimeSpectrumTensor
