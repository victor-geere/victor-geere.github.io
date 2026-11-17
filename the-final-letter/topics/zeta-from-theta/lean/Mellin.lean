/-
# The Mellin representation of the completed zeta function

Stage 3 of the theta-based proof of the Riemann zeta functional equation: the
Mellin transform of the theta kernel `ψ(t) = (θ(t)−1)/2` is the completed zeta
function `Λ(s) = π^{-s/2} Γ(s/2) ζ(s)` for `Re s > 1`.
-/
import Mathlib
import Theta

noncomputable section
open Real Set MeasureTheory
open Complex
open scoped BigOperators

namespace ZetaTheta

/-- **V6a. Summability of the p-series majorant `Σ 1/(π n²)^{σ/2}`** for `σ > 1`. -/
theorem summable_pi_mul_sq_rpow (s : ℂ) (hs : 1 < s.re) :
    Summable (fun n : ℕ+ => (1 : ℝ) / (Real.pi * (((n : ℕ) : ℝ)) ^ 2) ^ (s / 2).re) := by
  have hbase : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ (s.re)) :=
    Real.summable_one_div_nat_rpow.mpr hs
  have hbase' : Summable (fun n : ℕ+ => (1 : ℝ) / (((n : ℕ) : ℝ)) ^ (s.re)) :=
    summable_pnat_iff_summable_nat.mpr hbase
  have hconst : Summable (fun n : ℕ+ =>
      (1 / Real.pi ^ (s.re / 2)) * ((1 : ℝ) / (((n : ℕ) : ℝ)) ^ (s.re))) :=
    hbase'.mul_left _
  refine hconst.congr (fun n => ?_)
  have hn : (0 : ℝ) < ((n : ℕ) : ℝ) := by exact_mod_cast n.pos
  have hτ : (s / 2).re = s.re / 2 := by
    rw [Complex.div_re]
    simp
    ring
  rw [hτ]
  rw [Real.mul_rpow Real.pi_pos.le (by positivity : (0 : ℝ) ≤ ((n : ℕ) : ℝ) ^ 2)]
  rw [show ((((n : ℕ) : ℝ)) ^ 2) ^ (s.re / 2) = (((n : ℕ) : ℝ)) ^ (s.re) by
    rw [← Real.rpow_natCast (((n : ℕ) : ℝ)) 2, ← Real.rpow_mul (by positivity : (0 : ℝ) ≤ ((n : ℕ) : ℝ))]
    ring_nf]
  field_simp

/-- **V6. Mellin transform of the theta kernel (as a HasSum).** -/
theorem hasSum_mellin_psi (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun n : ℕ+ => Complex.Gamma (s / 2) * (1 : ℂ) /
      ((Real.pi * (((n : ℕ) : ℝ)) ^ 2 : ℝ) : ℂ) ^ (s / 2)) (mellin psi (s / 2)) := by
  have hs' : 0 < (s / 2).re := by
    have h : 0 < s.re := lt_trans zero_lt_one hs
    simpa using h
  refine hasSum_mellin (a := fun _ : ℕ+ => (1 : ℂ))
    (p := fun n : ℕ+ => Real.pi * (((n : ℕ) : ℝ)) ^ 2) (F := psi) (s := s / 2) ?_ hs' ?_ ?_
  · intro n
    right
    have hn : (0 : ℝ) < ((n : ℕ) : ℝ) := by exact_mod_cast n.pos
    positivity
  · intro t ht
    rw [Set.mem_Ioi] at ht
    have hreal : Summable (fun n : ℕ+ => Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2)) := by
      have h := summable_theta ht
      have hinj : Function.Injective (fun n : ℕ+ => (n : ℤ)) := by
        intro a b hab
        exact PNat.coe_injective (Int.ofNat.inj hab)
      have hcomp : Summable (fun n : ℕ+ => Real.exp (-Real.pi * t * (((n : ℤ) : ℝ)) ^ 2)) :=
        h.comp_injective hinj
      exact hcomp
    have hnorm : Summable (fun n : ℕ+ =>
        ‖(1 : ℂ) * (Real.exp (-(Real.pi * (((n : ℕ) : ℝ)) ^ 2) * t) : ℂ)‖) := by
      refine hreal.congr (fun n => ?_)
      rw [norm_mul, norm_one, one_mul, Complex.norm_real, Real.norm_eq_abs, Real.abs_exp]
      congr 1
      ring
    have hsum : Summable (fun n : ℕ+ =>
        (1 : ℂ) * (Real.exp (-(Real.pi * (((n : ℕ) : ℝ)) ^ 2) * t) : ℂ)) :=
      Summable.of_norm hnorm
    have hval : (∑' n : ℕ+, (1 : ℂ) *
        (Real.exp (-(Real.pi * (((n : ℕ) : ℝ)) ^ 2) * t) : ℂ)) = psi t := by
      rw [psi_eq_tsum ht, Complex.ofReal_tsum]
      congr 1
      funext n
      congr 2
      ring
    rw [← hval]
    exact hsum.hasSum
  · simpa using summable_pi_mul_sq_rpow s hs

end ZetaTheta
