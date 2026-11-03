import Mathlib

/-!
# Mellin/Laplace representation of the zeta function

This file formalises the exact Mellin representation
`Γ(s) ζ(s) = ∫_0^∞ t^(s-1)/(e^t - 1) dt` for `re s > 1`, using Mathlib's
`hasSum_mellin` lemma. It also records the completed functional equation and
the relation between the completed zeta and the Mellin transform.
-/

open Real Set MeasureTheory
open Complex

noncomputable section

namespace AngularPartition

/-- The zeta Mellin kernel `1/(e^t - 1)` on the positive real line. -/
def zetaKernel (t : ℝ) : ℂ := ((1 / (rexp t - 1) : ℝ) : ℂ)

/-- For `t > 0`, the geometric exponential series sums to the zeta kernel. -/
theorem hasSum_zetaKernel_real {t : ℝ} (ht : 0 < t) :
    HasSum (fun n : ℕ => rexp (-(((n + 1 : ℕ) : ℝ)) * t)) (1 / (rexp t - 1)) := by
  have hrpos : 0 < rexp (-t) := Real.exp_pos _
  have hrlt : rexp (-t) < 1 := by
    rw [Real.exp_lt_one_iff]
    linarith
  have hgeom : HasSum (fun n : ℕ => (rexp (-t)) ^ n) (1 - rexp (-t))⁻¹ :=
    hasSum_geometric_of_lt_one hrpos.le hrlt
  have hshift : HasSum (fun n : ℕ => (rexp (-t)) ^ (n + 1))
      (rexp (-t) * (1 - rexp (-t))⁻¹) := by
    simpa [pow_succ'] using hgeom.mul_left (rexp (-t))
  have hexp : rexp t - 1 ≠ 0 := by
    have h1 : 1 < rexp t := by
      rw [Real.one_lt_exp_iff]
      exact ht
    linarith
  convert hshift using 1
  · ext n
    have harg : -(((n + 1 : ℕ) : ℝ)) * t = ((n + 1 : ℕ) : ℝ) * (-t) := by ring
    rw [harg, Real.exp_nat_mul]
  · rw [Real.exp_neg]
    field_simp [hexp]

/-- The complex form of the geometric exponential sum. -/
theorem hasSum_zetaKernel {t : ℝ} (ht : 0 < t) :
    HasSum (fun n : ℕ => (1 : ℂ) * rexp (-(((n + 1 : ℕ) : ℝ)) * t)) (zetaKernel t) := by
  have hreal := hasSum_zetaKernel_real ht
  have hcomplex : HasSum (fun n : ℕ => ((rexp (-(((n + 1 : ℕ) : ℝ)) * t) : ℝ) : ℂ))
      ((1 / (rexp t - 1) : ℝ) : ℂ) :=
    (Complex.hasSum_ofReal).2 hreal
  simpa [zetaKernel, one_mul] using hcomplex

/-- The Mellin sum for the zeta kernel, before identifying the Dirichlet sum
with `ζ`. -/
theorem hasSum_mellin_zetaKernel {s : ℂ} (hs : 1 < s.re) :
    HasSum (fun n : ℕ => Gamma s * 1 / (((n + 1 : ℕ) : ℂ) ^ s))
      (mellin zetaKernel s) := by
  have hs0 : 0 < s.re := lt_trans zero_lt_one hs
  have hp : ∀ n : ℕ, (1 : ℂ) = 0 ∨ 0 < (((n + 1 : ℕ) : ℝ)) := by
    intro n
    exact Or.inr (by positivity)
  have hF : ∀ t ∈ Ioi (0 : ℝ),
      HasSum (fun n : ℕ => (1 : ℂ) * rexp (-(((n + 1 : ℕ) : ℝ)) * t)) (zetaKernel t) := by
    intro t ht
    exact hasSum_zetaKernel ht
  have hbase : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ s.re) :=
    (Real.summable_one_div_nat_rpow).2 hs
  have hshift : Summable (fun n : ℕ => (1 : ℝ) / (((n + 1 : ℕ) : ℝ) ^ s.re)) := by
    simpa using (summable_nat_add_iff 1).2 hbase
  have hshift' : Summable (fun n : ℕ => ‖(1 : ℂ)‖ / (((n + 1 : ℕ) : ℝ) ^ s.re)) := by
    simpa using hshift
  exact hasSum_mellin (a := fun _ : ℕ => (1 : ℂ))
    (p := fun n : ℕ => (((n + 1 : ℕ) : ℝ))) (F := zetaKernel) hp hs0 hF hshift'

/-- **Mellin/Laplace representation of zeta.**
For `re s > 1`,
`mellin (fun t => 1/(e^t - 1)) s = Γ(s) ζ(s)`.
-/
theorem mellin_zetaKernel_eq_Gamma_mul_zeta {s : ℂ} (hs : 1 < s.re) :
    mellin zetaKernel s = Gamma s * riemannZeta s := by
  have hmain := hasSum_mellin_zetaKernel hs
  have hzeta := zeta_eq_tsum_one_div_nat_add_one_cpow hs
  rw [← hmain.tsum_eq, hzeta]
  simpa [div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, Nat.cast_add, Nat.cast_one]
    using (tsum_mul_left (a := Gamma s) (f := fun n : ℕ => (1 : ℂ) / (((n + 1 : ℕ) : ℂ) ^ s)))


/-- For `re s > 1`, the completed zeta is the Gamma-factor times zeta. This is
the bridge between the Mellin representation of `Γ(s) ζ(s)` and the completed
functional equation. -/
theorem completedRiemannZeta_eq_GammaR_mul_zeta {s : ℂ} (hs : 1 < s.re) :
    completedRiemannZeta s = Gammaℝ s * riemannZeta s := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hG : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos (lt_trans zero_lt_one hs)
  have hζ : riemannZeta s = completedRiemannZeta s / Gammaℝ s :=
    riemannZeta_def_of_ne_zero hs0
  rw [hζ]
  field_simp [hG]

/-- The completed zeta satisfies the functional equation `Λ(1-s) = Λ(s)`. -/
theorem completedRiemannZeta_functional_equation (s : ℂ) :
    completedRiemannZeta (1 - s) = completedRiemannZeta s :=
  completedRiemannZeta_one_sub s

end AngularPartition

namespace AngularPartition

/-- **Growth bound for the Mellin transform.**
For `re s > 1`, the Mellin transform is bounded by `‖Γ(s)‖` times the
convergent `p`-series at `re s`. This is the vertical-strip growth estimate
used for the analytic continuation; it is exact and requires no truncation. -/
theorem mellin_zetaKernel_norm_le {s : ℂ} (hs : 1 < s.re) :
    ‖mellin zetaKernel s‖ ≤
      ‖Gamma s‖ * (∑' n : ℕ, (1 : ℝ) / ((((n + 1 : ℕ) : ℝ) ^ s.re))) := by
  have hmain := hasSum_mellin_zetaKernel hs
  have hbase : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ s.re) :=
    (Real.summable_one_div_nat_rpow).2 hs
  have hshift : Summable (fun n : ℕ => (1 : ℝ) / (((n + 1 : ℕ) : ℝ) ^ s.re)) := by
    simpa using (summable_nat_add_iff 1).2 hbase
  have hnorm_term (n : ℕ) :
      ‖Gamma s * 1 / (((n + 1 : ℕ) : ℂ) ^ s)‖ =
        ‖Gamma s‖ * (1 / ((((n + 1 : ℕ) : ℝ) ^ s.re))) := by
    have hcast : (((n + 1 : ℕ) : ℂ)) = ((((n + 1 : ℕ) : ℝ)) : ℂ) := by norm_num
    rw [norm_div, norm_mul, norm_one, hcast,
      Complex.norm_cpow_eq_rpow_re_of_pos (by positivity : (0 : ℝ) < ((n + 1 : ℕ) : ℝ))]
    ring
  have hnorm : Summable (fun n : ℕ =>
      ‖Gamma s * 1 / (((n + 1 : ℕ) : ℂ) ^ s)‖) := by
    have hmul := hshift.mul_left ‖Gamma s‖
    convert hmul using 1
    ext n
    exact hnorm_term n
  calc
    ‖mellin zetaKernel s‖
        = ‖∑' n : ℕ, Gamma s * 1 / (((n + 1 : ℕ) : ℂ) ^ s)‖ := by
          rw [hmain.tsum_eq]
    _ ≤ ∑' n : ℕ, ‖Gamma s * 1 / (((n + 1 : ℕ) : ℂ) ^ s)‖ :=
          norm_tsum_le_tsum_norm hnorm
    _ = ∑' n : ℕ, ‖Gamma s‖ * (1 / ((((n + 1 : ℕ) : ℝ) ^ s.re))) := by
          congr 1
          ext n
          exact hnorm_term n
    _ = ‖Gamma s‖ *
          (∑' n : ℕ, (1 : ℝ) / ((((n + 1 : ℕ) : ℝ) ^ s.re))) := by
          rw [tsum_mul_left]

end AngularPartition
