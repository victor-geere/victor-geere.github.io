/-
# The completed zeta function as the Mellin transform of the theta kernel

Stage 4: identification of the Dirichlet series produced by the Mellin transform
with `Λ(s) = π^{-s/2} Γ(s/2) ζ(s)`.
-/
import Mathlib
import Theta
import Mellin

noncomputable section
open Real Set MeasureTheory
open Complex Filter Asymptotics
open scoped BigOperators Topology

namespace ZetaTheta

/-- **V7a. `((n:ℝ)²)^{s/2} = (n)^{s}` for positive integers `n`.** -/
theorem cpow_sq_half (n : ℕ+) (s : ℂ) :
    ((((n : ℝ)) ^ 2 : ℝ) : ℂ) ^ (s / 2) = ((((n : ℝ)) : ℂ)) ^ s := by
  have hnpos : (0 : ℝ) < ((n : ℕ) : ℝ) := by exact_mod_cast n.pos
  have hx : (((n : ℝ)) : ℂ) ≠ 0 := by
    simp only [ne_eq, Complex.ofReal_eq_zero]
    exact ne_of_gt hnpos
  have hx2 : ((((n : ℝ)) ^ 2 : ℝ) : ℂ) ≠ 0 := by
    rw [show ((((n : ℝ)) ^ 2 : ℝ) : ℂ) = (((n : ℝ)) : ℂ) ^ 2 by push_cast; ring]
    exact pow_ne_zero 2 hx
  rw [Complex.cpow_def_of_ne_zero hx2, Complex.cpow_def_of_ne_zero hx]
  congr 1
  have hlog : Complex.log ((((n : ℝ)) ^ 2 : ℝ) : ℂ) = 2 * Complex.log (((n : ℝ)) : ℂ) := by
    have h1 : Complex.log ((((n : ℝ)) ^ 2 : ℝ) : ℂ) = ↑(Real.log (((n : ℝ)) ^ 2)) :=
      (Complex.ofReal_log (by positivity)).symm
    rw [h1, Real.log_pow]
    push_cast
    ring
  rw [hlog]
  ring

end ZetaTheta

namespace ZetaTheta

/-- **V7b. The Dirichlet-series form of the Mellin transform:**
`HasSum (fun n : ℕ+ => π^{-s/2} Γ(s/2) / n^s) (mellin ψ (s/2))` for `Re s > 1`. -/
theorem hasSum_mellin_psi_dirichlet (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun n : ℕ+ => (Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2) /
      (((n : ℝ)) : ℂ) ^ s) (mellin psi (s / 2)) := by
  have hs' : 0 < (s / 2).re := by
    have h : 0 < s.re := lt_trans zero_lt_one hs
    simpa using h
  have hmain := hasSum_mellin_pi_mul (a := fun _ : ℕ+ => (1 : ℂ))
    (q := fun n : ℕ+ => (((n : ℕ) : ℝ)) ^ 2) (F := psi) (s := s / 2) ?_ hs' ?_ ?_
  · -- rewrite `q n ^ (s/2)` as `n^s` and match
    convert hmain using 1
    · funext n
      rw [cpow_sq_half n s]
      ring
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
      exact h.comp_injective hinj
    have hnorm : Summable (fun n : ℕ+ =>
        ‖(1 : ℂ) * (Real.exp ((-Real.pi * (((n : ℕ) : ℝ)) ^ 2 * t)) : ℂ)‖) := by
      refine hreal.congr (fun n => ?_)
      rw [norm_mul, norm_one, one_mul, Complex.norm_real, Real.norm_eq_abs, Real.abs_exp]
      congr 1
      ring
    have hsum : Summable (fun n : ℕ+ =>
        (1 : ℂ) * (Real.exp ((-Real.pi * (((n : ℕ) : ℝ)) ^ 2 * t)) : ℂ)) :=
      Summable.of_norm hnorm
    have hval : (∑' n : ℕ+, (1 : ℂ) *
        (Real.exp ((-Real.pi * (((n : ℕ) : ℝ)) ^ 2 * t)) : ℂ)) = psi t := by
      rw [psi_eq_tsum ht, Complex.ofReal_tsum]
      congr 1
      funext n
      congr 2
      ring
    rw [← hval]
    exact hsum.hasSum
  · -- summability of `Σ 1/(n²)^{σ/2}`
    have hbase : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ (s.re)) :=
      Real.summable_one_div_nat_rpow.mpr hs
    have hbase' : Summable (fun n : ℕ+ => (1 : ℝ) / (((n : ℕ) : ℝ)) ^ (s.re)) :=
      summable_pnat_iff_summable_nat.mpr hbase
    have hτ : (s / 2).re = s.re / 2 := by
      rw [Complex.div_re]
      simp
      ring
    have hnum : ∀ n : ℕ+, ‖(1 : ℂ)‖ = (1 : ℝ) := by
      intro n
      rw [norm_one]
    refine hbase'.congr (fun n => ?_)
    rw [hnum n, hτ]
    rw [show ((((n : ℕ) : ℝ)) ^ 2) ^ (s.re / 2) = (((n : ℕ) : ℝ)) ^ (s.re) by
      rw [← Real.rpow_natCast (((n : ℕ) : ℝ)) 2,
        ← Real.rpow_mul (by positivity : (0 : ℝ) ≤ ((n : ℕ) : ℝ))]
      ring_nf]

end ZetaTheta

namespace ZetaTheta

/-- **V7c. `ζ(s)` as a series over the positive integers.** -/
theorem hasSum_pnat_one_div_cpow (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun n : ℕ+ => (1 : ℂ) / ((n : ℕ) : ℂ) ^ s) (riemannZeta s) := by
  have hsum : Summable (fun n : ℕ => (1 : ℂ) / ((n : ℕ) : ℂ) ^ s) := by
    rw [← summable_norm_iff]
    have hbase : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ (s.re)) :=
      Real.summable_one_div_nat_rpow.mpr hs
    refine hbase.congr (fun n => ?_)
    rcases Nat.eq_zero_or_pos n with h | h
    · subst h
      have hsne : s ≠ 0 := by
        intro h; rw [h] at hs; norm_num at hs
      simp [Real.zero_rpow (ne_of_gt (lt_trans zero_lt_one hs)), Complex.zero_cpow hsne]
    · have hn : (0 : ℝ) < (n : ℝ) := by exact_mod_cast h
      have harg : ((n : ℂ)) = ((n : ℝ) : ℂ) := by push_cast; ring
      rw [harg, norm_div, norm_one, Complex.norm_cpow_eq_rpow_re_of_pos hn]
  have htsum : (∑' n : ℕ+, (1 : ℂ) / ((n : ℕ) : ℂ) ^ s) = riemannZeta s := by
    rw [tsum_pnat_eq_tsum_succ (f := fun k : ℕ => (1 : ℂ) / ((k : ℂ)) ^ s)]
    have hsne : s ≠ 0 := by
      intro h; rw [h] at hs; norm_num at hs
    have h0 : (1 : ℂ) / ((0 : ℕ) : ℂ) ^ s = 0 := by
      simp [Complex.zero_cpow hsne]
    have h := Summable.tsum_eq_zero_add hsum
    rw [h0, zero_add] at h
    rw [← h, zeta_eq_tsum_one_div_nat_cpow hs]
  rw [← htsum]
  exact (summable_pnat_iff_summable_nat.mpr hsum).hasSum

/-- **V7d. The Mellin transform of the theta kernel is `Γℝ(s)·ζ(s)`.** -/
theorem mellin_psi_eq (s : ℂ) (hs : 1 < s.re) :
    mellin psi (s / 2) = (Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2) * riemannZeta s := by
  have hdir := hasSum_mellin_psi_dirichlet s hs
  have hzeta := hasSum_pnat_one_div_cpow s hs
  have hmul : HasSum (fun n : ℕ+ => (Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2) *
      ((1 : ℂ) / ((n : ℕ) : ℂ) ^ s))
      ((Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2) * riemannZeta s) := by
    have := hzeta.mul_left ((Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2))
    simpa [mul_assoc] using this
  have hsame : (fun n : ℕ+ => (Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2) /
      (((n : ℝ)) : ℂ) ^ s) = fun n : ℕ+ =>
      (Real.pi : ℂ) ^ (-(s / 2)) * Complex.Gamma (s / 2) * ((1 : ℂ) / ((n : ℕ) : ℂ) ^ s) := by
    funext n
    push_cast
    ring
  rw [hsame] at hdir
  exact hdir.unique hmul

end ZetaTheta

namespace ZetaTheta

/-- **V8. The completed zeta function is the Mellin transform of the theta
kernel:** `Λ(s) = ∫_0^∞ t^{s/2−1}ψ(t)dt` for `Re s > 1`. -/
theorem mellin_psi_eq_completed (s : ℂ) (hs : 1 < s.re) :
    mellin psi (s / 2) = completedRiemannZeta s := by
  have hsne : s ≠ 0 := by
    intro h; rw [h] at hs; norm_num at hs
  have hgam : s.Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    refine mul_ne_zero (Complex.cpow_ne_zero_iff.mpr ?_) ?_
    · left
      norm_num
    · exact Complex.Gamma_ne_zero_of_re_pos (by
        have : (0:ℝ) < (s/2).re := by
          have h : (0:ℝ) < s.re := lt_trans zero_lt_one hs
          simpa using h
        simpa using this)
  have hG : Complex.Gamma (s / 2) ≠ 0 := by
    refine Complex.Gamma_ne_zero_of_re_pos ?_
    simpa using (show (0:ℝ) < s.re / 2 from by
      have h : (0:ℝ) < s.re := lt_trans zero_lt_one hs
      linarith)
  rw [mellin_psi_eq s hs, riemannZeta_def_of_ne_zero hsne, Complex.Gammaℝ_def]
  field_simp [hG]

end ZetaTheta

namespace ZetaTheta

/-- **V9. The theta functional equation for the kernel `ψ`:**
`ψ(1/t) = √t·ψ(t) + (√t − 1)/2`. -/
theorem psi_one_div {t : ℝ} (ht : 0 < t) :
    psi (1 / t) = ((Real.sqrt t : ℝ) : ℂ) * psi t + (((Real.sqrt t - 1) / 2 : ℝ) : ℂ) := by
  have h := theta_one_div ht
  simp only [psi]
  rw [h]
  push_cast
  ring

/-- **V10. The elementary tail integral:** `∫_1^∞ t^{−a−1} dt = 1/a` for `Re a > 0`. -/
theorem integral_Ioi_cpow_neg_sub_one {a : ℂ} (ha : 0 < a.re) :
    ∫ (t : ℝ) in Set.Ioi 1, (t : ℂ) ^ (-a - 1) = 1 / a := by
  have hlt : (-a - 1).re < -1 := by
    simp only [Complex.neg_re, Complex.sub_re, Complex.one_re]
    linarith
  have h := integral_Ioi_cpow_of_lt (a := -a - 1) hlt (c := 1) one_pos
  rw [h]
  have h1 : -a - 1 + 1 = -a := by ring
  rw [h1]
  simp only [Complex.ofReal_one, one_cpow]
  field_simp

end ZetaTheta

namespace ZetaTheta

/-- **V11a. The image of `(1,∞)` under `t ↦ 1/t` is `(0,1)`.** -/
theorem image_inv_Ioi_one : (fun u : ℝ => 1 / u) '' Set.Ioi 1 = Set.Ioo 0 1 := by
  ext x
  constructor
  · rintro ⟨u, hu, rfl⟩
    simp only [Set.mem_Ioi] at hu
    have hu0 : (0:ℝ) < u := by linarith
    refine ⟨by positivity, ?_⟩
    rw [div_lt_one hu0]
    linarith
  · intro hx
    simp only [Set.mem_Ioo] at hx
    refine ⟨1 / x, ?_, ?_⟩
    · simp only [Set.mem_Ioi]
      rw [one_lt_div hx.1]
      exact hx.2
    · field_simp

/-- `((1/u) : ℂ)^a = (u : ℂ)^{-a}` for `u > 0`. -/
theorem inv_cpow_eq {u : ℝ} (hu : 0 < u) (a : ℂ) :
    (((1 / u : ℝ)) : ℂ) ^ a = ((u : ℝ) : ℂ) ^ (-a) := by
  have harg : ((u : ℝ) : ℂ).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg hu.le]
    exact ne_of_lt Real.pi_pos
  have h1 : (((1 / u : ℝ)) : ℂ) = (((u : ℝ)) : ℂ)⁻¹ := by
    push_cast
    rw [one_div]
  rw [h1, Complex.inv_cpow (x := ((u : ℝ) : ℂ)) (n := a) harg, Complex.cpow_neg]

/-- **V11. Change of variables `t ↦ 1/t` on `(1,∞)`:**
`∫_{(0,1)} ψ(t)t^{s/2−1}dt = ∫_{(1,∞)} ψ(1/u)u^{−s/2−1}du`. -/
theorem integral_Ioc_psi_eq (s : ℂ) :
    ∫ t in Set.Ioo 0 1, psi t * (t : ℂ) ^ (s / 2 - 1)
      = ∫ u in Set.Ioi 1, psi (1 / u) * (u : ℂ) ^ (-(s / 2) - 1) := by
  have hderiv : ∀ u ∈ Set.Ioi 1, HasDerivWithinAt (fun u : ℝ => 1 / u) (-(1 / u ^ 2)) (Set.Ioi 1) u := by
    intro u hu
    simp only [Set.mem_Ioi] at hu
    have hu0 : u ≠ 0 := by linarith
    have h := HasDerivAt.hasDerivWithinAt (hasDerivAt_inv hu0) (s := Set.Ioi 1)
    convert h using 1
    · funext y
      rw [one_div]
    · rw [one_div]
  have hinj : Set.InjOn (fun u : ℝ => 1 / u) (Set.Ioi 1) := by
    intro a ha b hb hab
    simp only [Set.mem_Ioi] at ha hb
    have ha0 : a ≠ 0 := by linarith
    have hb0 : b ≠ 0 := by linarith
    field_simp at hab
    linarith
  have hmain := integral_image_eq_integral_abs_deriv_smul (f := fun u : ℝ => 1 / u)
    (f' := fun u : ℝ => -(1 / u ^ 2)) (s := Set.Ioi 1)
    (g := fun t : ℝ => psi t * (t : ℂ) ^ (s / 2 - 1)) measurableSet_Ioi hderiv hinj
  rw [image_inv_Ioi_one] at hmain
  rw [hmain]
  refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
  have hu1 : (1:ℝ) < u := hu
  have hu0 : (0:ℝ) < u := by linarith
  have habs : |-(1 / u ^ 2)| = 1 / u ^ 2 := by
    rw [abs_neg, abs_of_pos (by positivity)]
  rw [habs, Complex.real_smul]
  push_cast
  have huC : ((u : ℝ) : ℂ) ≠ 0 := by
    exact_mod_cast (ne_of_gt hu0)
  have harg : ((u : ℝ) : ℂ).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg hu0.le]
    exact ne_of_lt Real.pi_pos
  -- rewrite `(1/u)^{s/2-1}` as `u^{1-s/2}` and `1/u^2` as `u^{-2}`
  rw [show (1 / ((u : ℝ) : ℂ)) = (((u : ℝ) : ℂ))⁻¹ by rw [one_div]]
  rw [Complex.inv_cpow (x := ((u : ℝ) : ℂ)) (n := (s / 2 - 1)) harg, ← Complex.cpow_neg]
  rw [show -((s / 2 - 1)) = 1 - s / 2 by ring]
  have hsq : (1 / ((u : ℝ) : ℂ) ^ 2) = ((u : ℝ) : ℂ) ^ (-(2 : ℂ)) := by
    rw [show (1 / ((u : ℝ) : ℂ) ^ 2) = (((u : ℝ) : ℂ) ^ 2)⁻¹ by rw [one_div]]
    rw [← Complex.cpow_natCast]
    rw [← Complex.cpow_neg]
    norm_num
  rw [hsq]
  have hsplit : ((u : ℝ) : ℂ) ^ (-(2 : ℂ)) * ((u : ℝ) : ℂ) ^ (1 - s / 2)
      = ((u : ℝ) : ℂ) ^ (-(s / 2) - 1) := by
    rw [← Complex.cpow_add]
    · congr 1
      ring
    · exact huC
  calc ((u : ℝ) : ℂ) ^ (-(2 : ℂ)) * (psi (1 / u) * ((u : ℝ) : ℂ) ^ (1 - s / 2))
      = psi (1 / u) * (((u : ℝ) : ℂ) ^ (-(2 : ℂ)) * ((u : ℝ) : ℂ) ^ (1 - s / 2)) := by ring
    _ = psi (1 / u) * ((u : ℝ) : ℂ) ^ (-(s / 2) - 1) := by rw [hsplit]

end ZetaTheta

namespace ZetaTheta

/-- **V12. The positive theta tail is positive.** -/
theorem tsum_theta_pos {t : ℝ} (ht : 0 < t) :
    0 < ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2) := by
  have hsum : Summable (fun n : ℕ+ => Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2)) := by
    have h := summable_theta ht
    have hinj : Function.Injective (fun n : ℕ+ => (n : ℤ)) := by
      intro a b hab
      exact PNat.coe_injective (Int.ofNat.inj hab)
    exact h.comp_injective hinj
  refine Summable.tsum_pos hsum (fun n => (Real.exp_pos _).le) 1 ?_
  simpa using Real.exp_pos (-(Real.pi * t))

/-- **V13. Positivity of the theta kernel.** -/
theorem psi_pos {t : ℝ} (ht : 0 < t) : 0 < (psi t).re := by
  have hS := tsum_theta_pos ht
  have hθ := theta_eq_one_add_two_tsum ht
  have hre : (psi t).re = (theta t - 1) / 2 := by
    simp [psi]
  rw [hre, hθ]
  linarith

end ZetaTheta

namespace ZetaTheta


theorem tsum_geometric_pnat {t : ℝ} (ht : 0 < t) :
    ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)))
      = Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi * t)) := by
  have hr : Real.exp (-Real.pi * t) < 1 := by
    rw [Real.exp_lt_one_iff]
    nlinarith [Real.pi_pos, ht]
  have hr0 : 0 ≤ Real.exp (-Real.pi * t) := (Real.exp_pos _).le
  rw [tsum_pnat_eq_tsum_succ (f := fun k : ℕ => Real.exp (-Real.pi * t * (k : ℝ)))]
  have h : ∀ n : ℕ, Real.exp (-Real.pi * t * (((n + 1 : ℕ)) : ℝ))
      = Real.exp (-Real.pi * t) * Real.exp (-Real.pi * t) ^ n := by
    intro n
    rw [show -Real.pi * t * (((n + 1 : ℕ)) : ℝ) = (n : ℝ) * (-Real.pi * t) + (-Real.pi * t) by
      push_cast; ring]
    rw [Real.exp_add, Real.exp_nat_mul]
    ring
  simp only [h]
  rw [tsum_mul_left, tsum_geometric_of_lt_one hr0 hr]
  rw [div_eq_mul_inv]

end ZetaTheta

namespace ZetaTheta

theorem tsum_theta_le_geometric {t : ℝ} (ht : 0 < t) :
    ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2)
      ≤ ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ))) := by
  have hsum1 : Summable (fun n : ℕ+ => Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2)) := by
    have h := summable_theta ht
    have hinj : Function.Injective (fun n : ℕ+ => (n : ℤ)) := by
      intro a b hab
      exact PNat.coe_injective (Int.ofNat.inj hab)
    exact h.comp_injective hinj
  have hsum2 : Summable (fun n : ℕ+ => Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)))) := by
    have hgeo : Summable (fun n : ℕ => Real.exp (-Real.pi * t) ^ n) :=
      summable_geometric_of_lt_one (Real.exp_pos _).le (by
        rw [Real.exp_lt_one_iff]
        nlinarith [Real.pi_pos, ht])
    have hgeo' : Summable (fun n : ℕ+ => Real.exp (-Real.pi * t) ^ (n : ℕ)) :=
      hgeo.comp_injective (fun a b hab => PNat.coe_injective hab)
    refine hgeo'.congr (fun n => ?_)
    rw [← Real.exp_nat_mul]
    congr 1
    push_cast
    ring
  refine Summable.tsum_le_tsum (fun n => ?_) hsum1 hsum2
  apply Real.exp_le_exp.mpr
  have hn : (1 : ℝ) ≤ ((n : ℕ) : ℝ) := by exact_mod_cast n.pos
  have hnn : ((n : ℕ) : ℝ) ≤ (((n : ℕ) : ℝ)) ^ 2 := by nlinarith
  have hpt : (0 : ℝ) < Real.pi * t := mul_pos Real.pi_pos ht
  nlinarith [mul_le_mul_of_nonneg_left hnn hpt.le]

end ZetaTheta

namespace ZetaTheta

theorem norm_psi_le {t : ℝ} (ht : 0 < t) :
    ‖psi t‖ ≤ Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi * t)) := by
  rw [psi_eq_tsum ht]
  have hnn : 0 ≤ ∑' n : ℕ+,
      Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2) :=
    tsum_nonneg (fun n => (Real.exp_pos _).le)
  rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hnn]
  calc ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2)
      ≤ ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ))) := tsum_theta_le_geometric ht
    _ = Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi * t)) := tsum_geometric_pnat ht


theorem measurable_theta : Measurable theta := by
  unfold theta
  exact Measurable.tsum (fun n : ℤ => by fun_prop)

theorem measurable_psi : Measurable psi := by
  unfold psi
  exact Complex.measurable_ofReal.comp ((measurable_theta.sub measurable_const).div_const 2)

theorem norm_psi_le_Ioi {t : ℝ} (ht : 1 ≤ t) :
    ‖psi t‖ ≤ Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi)) := by
  have he : Real.exp (-Real.pi) < 1 := by
    rw [Real.exp_lt_one_iff]
    linarith [Real.pi_pos]
  refine (norm_psi_le (by linarith)).trans ?_
  refine div_le_div_of_nonneg_left (Real.exp_pos _).le (by linarith) ?_
  have h : Real.exp (-Real.pi * t) ≤ Real.exp (-Real.pi) := by
    apply Real.exp_le_exp.mpr
    nlinarith [Real.pi_pos]
  linarith

theorem integrableOn_psi_cpow_Ioi (s : ℂ) (hs : 1 < s.re) :
    IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ (s / 2 - 1)) (Set.Ioi (1 : ℝ)) := by
  set c : ℂ := s / 2 - 1 with hc
  have hcre : -1 < c.re := by
    rw [hc]
    simp only [Complex.sub_re, Complex.div_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.one_re, Complex.one_im, mul_zero, zero_div, sub_zero]
    norm_num
    linarith
  have hmeas : AEStronglyMeasurable (fun t : ℝ => psi t * (t : ℂ) ^ c)
      (volume.restrict (Set.Ioi (1 : ℝ))) :=
    (measurable_psi.mul (by fun_prop)).aestronglyMeasurable
  have hbase : IntegrableOn (fun t : ℝ => t ^ c.re * Real.exp (-Real.pi * t)) (Set.Ioi (1 : ℝ)) := by
    have h := integrableOn_rpow_mul_exp_neg_mul_rpow (p := (1 : ℝ)) (s := c.re) (b := Real.pi)
      hcre one_pos Real.pi_pos
    simpa using h.mono_set (Set.Ioi_subset_Ioi zero_le_one)
  have hconst : IntegrableOn (fun t : ℝ =>
      (1 / (1 - Real.exp (-Real.pi))) * (t ^ c.re * Real.exp (-Real.pi * t))) (Set.Ioi (1 : ℝ)) :=
    hbase.const_mul _
  refine MeasureTheory.Integrable.mono' hconst hmeas ?_
  filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
  have ht1 : (1 : ℝ) ≤ t := by simpa using ht.le
  have ht0 : (0 : ℝ) < t := by linarith
  rw [norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos ht0]
  have hb : ‖psi t‖ ≤ Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi)) := norm_psi_le_Ioi ht1
  have hpos : (0 : ℝ) ≤ t ^ c.re := by positivity
  calc ‖psi t‖ * t ^ c.re
      ≤ (Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi))) * t ^ c.re := by
        apply mul_le_mul_of_nonneg_right hb hpos
    _ = (1 / (1 - Real.exp (-Real.pi))) * (t ^ c.re * Real.exp (-Real.pi * t)) := by ring


theorem norm_psi_le_inv_sqrt {t : ℝ} (ht : 0 < t) (ht1 : t ≤ 1) :
    ‖psi t‖ ≤ (Real.exp (-Real.pi * (1 / t)) / (1 - Real.exp (-Real.pi)) + 1) / Real.sqrt t := by
  have hkey : psi t = Real.sqrt (1 / t) * psi (1 / t) + (((Real.sqrt (1 / t) - 1) / 2 : ℝ) : ℂ) := by
    have h := psi_one_div (t := 1 / t) (by positivity)
    rw [one_div_one_div] at h
    exact h
  have hC : ‖psi (1 / t)‖ ≤ Real.exp (-Real.pi * (1 / t)) / (1 - Real.exp (-Real.pi)) := by
    refine norm_psi_le_Ioi ?_
    rw [one_le_div ht]
    exact ht1
  have hs : (0:ℝ) < Real.sqrt t := Real.sqrt_pos.mpr ht
  have hsq : Real.sqrt (1 / t) = 1 / Real.sqrt t := by
    rw [Real.sqrt_div (by norm_num : (0:ℝ) ≤ 1), Real.sqrt_one, one_div]
  rw [hkey, hsq]
  have hb2 : |(1 / Real.sqrt t - 1) / 2| ≤ (1 / Real.sqrt t + 1) / 2 := by
    rw [abs_div, abs_of_pos (by norm_num : (0:ℝ) < 2)]
    have h : |1 / Real.sqrt t - 1| ≤ 1 / Real.sqrt t + 1 := by
      rw [abs_le]
      constructor <;> linarith [one_div_pos.mpr hs]
    linarith
  calc ‖(1 / Real.sqrt t) • psi (1 / t) + (((1 / Real.sqrt t - 1) / 2 : ℝ) : ℂ)‖
      ≤ ‖(1 / Real.sqrt t) • psi (1 / t)‖ + ‖(((1 / Real.sqrt t - 1) / 2 : ℝ) : ℂ)‖ :=
        norm_add_le _ _
    _ = (1 / Real.sqrt t) * ‖psi (1 / t)‖ + |(1 / Real.sqrt t - 1) / 2| := by
        rw [norm_smul, Real.norm_eq_abs, abs_of_pos (one_div_pos.mpr hs), Complex.norm_real,
          Real.norm_eq_abs]
    _ ≤ (1 / Real.sqrt t) * (Real.exp (-Real.pi * (1 / t)) / (1 - Real.exp (-Real.pi)))
          + (1 / Real.sqrt t + 1) / 2 :=
        add_le_add (mul_le_mul_of_nonneg_left hC (le_of_lt (one_div_pos.mpr hs))) hb2
    _ ≤ (Real.exp (-Real.pi * (1 / t)) / (1 - Real.exp (-Real.pi)) + 1) / Real.sqrt t := by
        have hsq1 : Real.sqrt t ≤ 1 := Real.sqrt_le_one.mpr ht1
        have hfin : ∀ A : ℝ, (1 / Real.sqrt t) * A + (1 / Real.sqrt t + 1) / 2
            ≤ (A + 1) / Real.sqrt t := by
          intro A
          rw [le_div_iff₀ hs]
          field_simp [ne_of_gt hs]
          nlinarith [hsq1]
        exact hfin _

end ZetaTheta

namespace ZetaTheta

theorem integrableOn_rpow_Ioo (a : ℝ) (ha : -1 < a) :
    IntegrableOn (fun t : ℝ => t ^ a) (Set.Ioo (0:ℝ) 1) := by
  have hbase : IntegrableOn (fun t : ℝ => t ^ a * Real.exp (-Real.pi * t)) (Set.Ioi (0:ℝ)) := by
    have h := integrableOn_rpow_mul_exp_neg_mul_rpow (p := (1:ℝ)) (s := a) (b := Real.pi)
      ha one_pos Real.pi_pos
    simpa using h
  have hsub : IntegrableOn (fun t : ℝ => t ^ a * Real.exp (-Real.pi * t)) (Set.Ioo (0:ℝ) 1) :=
    hbase.mono_set Set.Ioo_subset_Ioi_self
  have hdom : IntegrableOn (fun t : ℝ => Real.exp Real.pi * (t ^ a * Real.exp (-Real.pi * t)))
      (Set.Ioo (0:ℝ) 1) :=
    hsub.const_mul _
  refine MeasureTheory.Integrable.mono' hdom
    (by fun_prop : Measurable fun t : ℝ => t ^ a).aestronglyMeasurable ?_
  filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioo] with t ht
  have ht0 : (0:ℝ) < t := ht.1
  have ht1 : t < 1 := ht.2
  rw [Real.norm_eq_abs, abs_of_nonneg (Real.rpow_nonneg ht0.le a)]
  have hexp : Real.exp Real.pi * Real.exp (-Real.pi * t) = Real.exp (Real.pi * (1 - t)) := by
    rw [← Real.exp_add]
    congr 1
    ring
  calc t ^ a = t ^ a * 1 := by ring
    _ ≤ t ^ a * (Real.exp Real.pi * Real.exp (-Real.pi * t)) := by
        apply mul_le_mul_of_nonneg_left _ (Real.rpow_nonneg ht0.le a)
        rw [hexp]
        apply Real.one_le_exp
        nlinarith [Real.pi_pos]
    _ = Real.exp Real.pi * (t ^ a * Real.exp (-Real.pi * t)) := by ring

end ZetaTheta

namespace ZetaTheta

theorem integrableOn_psi_cpow_Ioo (s : ℂ) (hs : 1 < s.re) :
    IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ (s / 2 - 1)) (Set.Ioo (0:ℝ) 1) := by
  set c : ℂ := s / 2 - 1 with hc
  have hcre : -1 < c.re - 1 / 2 := by
    rw [hc]
    simp only [Complex.sub_re, Complex.div_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.one_re, Complex.one_im, mul_zero, zero_div, sub_zero]
    norm_num
    linarith
  have hmeas : AEStronglyMeasurable (fun t : ℝ => psi t * (t : ℂ) ^ c)
      (volume.restrict (Set.Ioo (0:ℝ) 1)) :=
    (measurable_psi.mul (by fun_prop)).aestronglyMeasurable
  have hK : IntegrableOn (fun t : ℝ => (1 / (1 - Real.exp (-Real.pi)) + 1) * t ^ (c.re - 1 / 2))
      (Set.Ioo (0:ℝ) 1) :=
    (integrableOn_rpow_Ioo (c.re - 1 / 2) hcre).const_mul _
  refine MeasureTheory.Integrable.mono' hK hmeas ?_
  filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioo] with t ht
  have ht0 : (0:ℝ) < t := ht.1
  have ht1 : t ≤ 1 := le_of_lt ht.2
  rw [norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos ht0]
  have hA : Real.exp (-Real.pi * (1 / t)) / (1 - Real.exp (-Real.pi))
      ≤ 1 / (1 - Real.exp (-Real.pi)) := by
    have he : Real.exp (-Real.pi * (1 / t)) ≤ 1 := by
      rw [Real.exp_le_one_iff]
      have hg : (0:ℝ) < 1 / t := one_div_pos.mpr ht0
      nlinarith [Real.pi_pos]
    have hpos : (0:ℝ) < 1 - Real.exp (-Real.pi) := by
      have h1 : Real.exp (-Real.pi) < 1 := by
        rw [Real.exp_lt_one_iff]
        linarith [Real.pi_pos]
      linarith
    exact div_le_div_of_nonneg_right he hpos.le
  have hb : ‖psi t‖ ≤ (1 / (1 - Real.exp (-Real.pi)) + 1) / t ^ (1 / 2 : ℝ) := by
    refine (norm_psi_le_inv_sqrt ht0 ht1).trans ?_
    rw [Real.sqrt_eq_rpow]
    gcongr
  calc ‖psi t‖ * t ^ c.re
      ≤ ((1 / (1 - Real.exp (-Real.pi)) + 1) / t ^ (1 / 2 : ℝ)) * t ^ c.re := by
        apply mul_le_mul_of_nonneg_right hb (Real.rpow_nonneg ht0.le c.re)
    _ = (1 / (1 - Real.exp (-Real.pi)) + 1) * t ^ (c.re - 1 / 2) := by
        rw [Real.rpow_sub ht0]
        field_simp


theorem mellin_psi_split (s : ℂ) (hs : 1 < s.re) :
    mellin psi (s / 2)
      = (∫ t in Set.Ioo (0:ℝ) 1, psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
        + ∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume := by
  have hint1 := integrableOn_psi_cpow_Ioo s hs
  have hint2 := integrableOn_psi_cpow_Ioi s hs
  have hint2' : IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ (s / 2 - 1)) (Set.Ici (1:ℝ)) :=
    (integrableOn_Ici_iff_integrableOn_Ioi).mpr hint2
  have hdisj : Disjoint (Set.Ioo (0:ℝ) 1) (Set.Ici (1:ℝ)) := by
    rw [Set.disjoint_left]
    intro x hx hx'
    simp only [Set.mem_Ioo] at hx
    simp only [Set.mem_Ici] at hx'
    exact absurd hx.2 (not_lt.mpr hx')
  have h1 : mellin psi (s / 2) = ∫ t in Set.Ioi (0:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume := by
    simp only [mellin, smul_eq_mul, mul_comm]
  have h2 : (∫ t in Set.Ioi (0:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
      = (∫ t in Set.Ioo (0:ℝ) 1 ∪ Set.Ici (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume) := by
    rw [Set.Ioo_union_Ici_eq_Ioi zero_lt_one]
  have h3 : (∫ t in Set.Ioo (0:ℝ) 1 ∪ Set.Ici (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
      = (∫ t in Set.Ioo (0:ℝ) 1, psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
        + ∫ t in Set.Ici (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume :=
    MeasureTheory.setIntegral_union hdisj measurableSet_Ici hint1 hint2'
  have h4 : (∫ t in Set.Ici (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
      = ∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume :=
    MeasureTheory.integral_Ici_eq_integral_Ioi
  calc mellin psi (s / 2)
      = ∫ t in Set.Ioi (0:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume := h1
    _ = ∫ t in Set.Ioo (0:ℝ) 1 ∪ Set.Ici (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume := h2
    _ = (∫ t in Set.Ioo (0:ℝ) 1, psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
          + ∫ t in Set.Ici (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume := h3
    _ = (∫ t in Set.Ioo (0:ℝ) 1, psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
          + ∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume := by
        rw [h4]


theorem psi_one_div_mul_cpow {u : ℝ} (hu : 1 < u) (s : ℂ) :
    psi (1 / u) * (u : ℂ) ^ (-(s / 2) - 1)
      = psi u * (u : ℂ) ^ ((1 - s) / 2 - 1)
        + (1 / 2 : ℂ) * ((u : ℂ) ^ ((1 - s) / 2 - 1) - (u : ℂ) ^ (-(s / 2) - 1)) := by
  have hu0 : (0:ℝ) < u := by linarith
  have huC : (u : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hu0
  have hsqrt : ((Real.sqrt u : ℝ) : ℂ) = (u : ℂ) ^ (1 / 2 : ℂ) := by
    have h1 : Real.sqrt u = (u:ℝ) ^ (1/2:ℝ) := Real.sqrt_eq_rpow u
    rw [h1, Complex.ofReal_cpow hu0.le]
    push_cast
    ring_nf
  have hB : ((Real.sqrt u : ℝ) : ℂ) * (u : ℂ) ^ (-(s / 2) - 1) = (u : ℂ) ^ ((1 - s) / 2 - 1) := by
    rw [hsqrt, ← Complex.cpow_add]
    · congr 1
      ring
    · exact huC
  have h1 : ((Real.sqrt u : ℝ) : ℂ) * psi u * (u : ℂ) ^ (-(s / 2) - 1)
      = psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) := by
    calc ((Real.sqrt u : ℝ) : ℂ) * psi u * (u : ℂ) ^ (-(s / 2) - 1)
        = psi u * (((Real.sqrt u : ℝ) : ℂ) * (u : ℂ) ^ (-(s / 2) - 1)) := by ring
      _ = psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) := by rw [hB]
  have h2 : (((Real.sqrt u - 1) / 2 : ℝ) : ℂ) * (u : ℂ) ^ (-(s / 2) - 1)
      = (1 / 2 : ℂ) * ((u : ℂ) ^ ((1 - s) / 2 - 1) - (u : ℂ) ^ (-(s / 2) - 1)) := by
    rw [← hB]
    push_cast
    ring
  rw [psi_one_div hu0, add_mul, h1, h2]


theorem integrableOn_psi_cpow_Ioi' (c : ℂ) :
    IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ c) (Set.Ioi (1:ℝ)) := by
  have hmeas : AEStronglyMeasurable (fun t : ℝ => psi t * (t : ℂ) ^ c)
      (volume.restrict (Set.Ioi (1:ℝ))) :=
    (measurable_psi.mul (by fun_prop)).aestronglyMeasurable
  have hπ : (0:ℝ) < Real.pi := Real.pi_pos
  have he : Real.exp (-Real.pi) < 1 := by
    rw [Real.exp_lt_one_iff]
    linarith
  have hden : (0:ℝ) < 1 - Real.exp (-Real.pi) := by linarith
  have hbound : ∀ t ∈ Set.Ioi (1:ℝ),
      ‖psi t * (t : ℂ) ^ c‖ ≤ (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t) * t ^ c.re := by
    intro t ht
    have ht1 : (1:ℝ) ≤ t := le_of_lt ht
    have ht0 : (0:ℝ) < t := by linarith
    rw [norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos ht0]
    have hb : ‖psi t‖ ≤ Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi)) := norm_psi_le_Ioi ht1
    have hpos : (0:ℝ) ≤ t ^ c.re := Real.rpow_nonneg ht0.le c.re
    calc ‖psi t‖ * t ^ c.re
        ≤ (Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi))) * t ^ c.re :=
          mul_le_mul_of_nonneg_right hb hpos
      _ = (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t) * t ^ c.re := by ring
  by_cases hc : -1 < c.re
  · have hbase : IntegrableOn (fun t : ℝ => t ^ c.re * Real.exp (-Real.pi * t)) (Set.Ioi (1:ℝ)) := by
      have h := integrableOn_rpow_mul_exp_neg_mul_rpow (p := (1:ℝ)) (s := c.re) (b := Real.pi)
        hc one_pos hπ
      simpa using h.mono_set (Set.Ioi_subset_Ioi zero_le_one)
    have hdom : IntegrableOn (fun t : ℝ =>
        (1 / (1 - Real.exp (-Real.pi))) * (t ^ c.re * Real.exp (-Real.pi * t))) (Set.Ioi (1:ℝ)) :=
      hbase.const_mul _
    refine MeasureTheory.Integrable.mono' hdom hmeas ?_
    filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
    refine (hbound t ht).trans (le_of_eq ?_)
    ring
  · push_neg at hc
    have hbase : IntegrableOn (fun t : ℝ => Real.exp (-Real.pi * t)) (Set.Ioi (1:ℝ)) := by
      have h := integrableOn_rpow_mul_exp_neg_mul_rpow (p := (1:ℝ)) (s := (0:ℝ)) (b := Real.pi)
        (by norm_num) one_pos hπ
      simpa using h.mono_set (Set.Ioi_subset_Ioi zero_le_one)
    have hdom : IntegrableOn (fun t : ℝ =>
        (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t)) (Set.Ioi (1:ℝ)) :=
      hbase.const_mul _
    refine MeasureTheory.Integrable.mono' hdom hmeas ?_
    filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
    have ht1 : (1:ℝ) ≤ t := le_of_lt ht
    have ht0 : (0:ℝ) < t := by linarith
    have hle : t ^ c.re ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos ht1 (by linarith)
    calc ‖psi t * (t : ℂ) ^ c‖
        ≤ (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t) * t ^ c.re := hbound t ht
      _ ≤ (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t) * 1 := by
          apply mul_le_mul_of_nonneg_left hle
          apply mul_nonneg
          · positivity
          · positivity
      _ = (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t) := by ring


theorem integral_Ioi_psi_one_div (s : ℂ) (hs : 1 < s.re) :
    (∫ u in Set.Ioi (1:ℝ), psi (1 / u) * (u : ℂ) ^ (-(s / 2) - 1) ∂volume)
      = (∫ u in Set.Ioi (1:ℝ), psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
        + (1 / (s - 1) - 1 / s) := by
  have hs0 : (0:ℝ) < s.re := lt_trans zero_lt_one hs
  have hAre : (0:ℝ) < ((s - 1) / 2).re := by
    simp only [Complex.sub_re, Complex.div_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.one_re, Complex.one_im, mul_zero, zero_div]
    norm_num
    linarith
  have hBre : (0:ℝ) < (s / 2).re := by
    simp only [Complex.div_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero, zero_div]
    norm_num
    linarith
  have hBint : IntegrableOn (fun u : ℝ => psi u * (u : ℂ) ^ ((1 - s) / 2 - 1)) (Set.Ioi (1:ℝ)) :=
    integrableOn_psi_cpow_Ioi' _
  have hB2int : IntegrableOn (fun u : ℝ => (u : ℂ) ^ ((1 - s) / 2 - 1)) (Set.Ioi (1:ℝ)) := by
    have hlt : (((1 - s) / 2 - 1)).re < -1 := by
      rw [show (1 - s) / 2 - 1 = -((s - 1) / 2) - 1 by ring]
      simp only [Complex.neg_re, Complex.sub_re, Complex.one_re]
      linarith
    exact integrableOn_Ioi_cpow_of_lt hlt one_pos
  have hCint : IntegrableOn (fun u : ℝ => (u : ℂ) ^ (-(s / 2) - 1)) (Set.Ioi (1:ℝ)) := by
    have hlt : ((-(s / 2) - 1)).re < -1 := by
      simp only [Complex.neg_re, Complex.sub_re, Complex.one_re]
      linarith
    exact integrableOn_Ioi_cpow_of_lt hlt one_pos
  have hcongr : ∀ u ∈ Set.Ioi (1:ℝ), psi (1 / u) * (u : ℂ) ^ (-(s / 2) - 1)
      = psi u * (u : ℂ) ^ ((1 - s) / 2 - 1)
        + (1 / 2 : ℂ) * ((u : ℂ) ^ ((1 - s) / 2 - 1) - (u : ℂ) ^ (-(s / 2) - 1)) :=
    fun u hu => psi_one_div_mul_cpow hu s
  have hVB : (∫ u in Set.Ioi (1:ℝ), (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume) = 1 / ((s - 1) / 2) := by
    rw [show ((1 - s) / 2 - 1 : ℂ) = -((s - 1) / 2) - 1 by ring]
    exact integral_Ioi_cpow_neg_sub_one (a := (s - 1) / 2) hAre
  have hVC : (∫ u in Set.Ioi (1:ℝ), (u : ℂ) ^ (-(s / 2) - 1) ∂volume) = 1 / (s / 2) :=
    integral_Ioi_cpow_neg_sub_one (a := s / 2) hBre
  calc (∫ u in Set.Ioi (1:ℝ), psi (1 / u) * (u : ℂ) ^ (-(s / 2) - 1) ∂volume)
      = ∫ u in Set.Ioi (1:ℝ), (psi u * (u : ℂ) ^ ((1 - s) / 2 - 1)
          + (1 / 2 : ℂ) * ((u : ℂ) ^ ((1 - s) / 2 - 1) - (u : ℂ) ^ (-(s / 2) - 1))) ∂volume :=
        MeasureTheory.setIntegral_congr_fun measurableSet_Ioi hcongr
    _ = (∫ u in Set.Ioi (1:ℝ), psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
          + (∫ u in Set.Ioi (1:ℝ),
              (1 / 2 : ℂ) * ((u : ℂ) ^ ((1 - s) / 2 - 1) - (u : ℂ) ^ (-(s / 2) - 1)) ∂volume) :=
        MeasureTheory.integral_add hBint ((hB2int.sub hCint).const_mul (1 / 2 : ℂ))
    _ = (∫ u in Set.Ioi (1:ℝ), psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
          + (1 / 2 : ℂ) * ((∫ u in Set.Ioi (1:ℝ), (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
            - (∫ u in Set.Ioi (1:ℝ), (u : ℂ) ^ (-(s / 2) - 1) ∂volume)) := by
        rw [MeasureTheory.integral_const_mul, MeasureTheory.integral_sub hB2int hCint]
    _ = (∫ u in Set.Ioi (1:ℝ), psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
          + (1 / (s - 1) - 1 / s) := by
        rw [hVB, hVC]
        field_simp


theorem completedRiemannZeta_eq_symmetric_integral (s : ℂ) (hs : 1 < s.re) :
    completedRiemannZeta s
      = (∫ t in Set.Ioi (1:ℝ), psi t * ((t : ℂ) ^ (s / 2 - 1) + (t : ℂ) ^ ((1 - s) / 2 - 1)) ∂volume)
        + (1 / (s - 1) - 1 / s) := by
  have hA : IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ (s / 2 - 1)) (Set.Ioi (1:ℝ)) :=
    integrableOn_psi_cpow_Ioi' _
  have hB : IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ ((1 - s) / 2 - 1)) (Set.Ioi (1:ℝ)) :=
    integrableOn_psi_cpow_Ioi' _
  calc completedRiemannZeta s
      = mellin psi (s / 2) := (mellin_psi_eq_completed s hs).symm
    _ = (∫ t in Set.Ioo (0:ℝ) 1, psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
          + (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume) := mellin_psi_split s hs
    _ = (∫ u in Set.Ioi (1:ℝ), psi (1 / u) * (u : ℂ) ^ (-(s / 2) - 1) ∂volume)
          + (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume) := by
        rw [integral_Ioc_psi_eq s]
    _ = ((∫ u in Set.Ioi (1:ℝ), psi u * (u : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
          + (1 / (s - 1) - 1 / s))
          + (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume) := by
        rw [integral_Ioi_psi_one_div s hs]
    _ = ((∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
          + (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ ((1 - s) / 2 - 1) ∂volume))
          + (1 / (s - 1) - 1 / s) := by ring
    _ = ((∫ t in Set.Ioi (1:ℝ),
            (psi t * (t : ℂ) ^ (s / 2 - 1) + psi t * (t : ℂ) ^ ((1 - s) / 2 - 1)) ∂volume))
          + (1 / (s - 1) - 1 / s) := by
        rw [MeasureTheory.integral_add hA hB]
    _ = (∫ t in Set.Ioi (1:ℝ), psi t * ((t : ℂ) ^ (s / 2 - 1) + (t : ℂ) ^ ((1 - s) / 2 - 1)) ∂volume)
          + (1 / (s - 1) - 1 / s) := by
        congr 2
        funext t
        ring


noncomputable def LambdaTilde (s : ℂ) : ℂ :=
  (∫ t in Set.Ioi (1:ℝ), psi t * ((t : ℂ) ^ (s / 2 - 1) + (t : ℂ) ^ ((1 - s) / 2 - 1)) ∂volume)
    + (1 / (s - 1) - 1 / s)

theorem completedRiemannZeta_eq_LambdaTilde (s : ℂ) (hs : 1 < s.re) :
    completedRiemannZeta s = LambdaTilde s :=
  completedRiemannZeta_eq_symmetric_integral s hs

theorem LambdaTilde_one_sub (s : ℂ) :
    LambdaTilde (1 - s) = LambdaTilde s := by
  unfold LambdaTilde
  have h1 : (∫ t in Set.Ioi (1:ℝ),
        psi t * ((t : ℂ) ^ ((1 - s) / 2 - 1) + (t : ℂ) ^ ((1 - (1 - s)) / 2 - 1)) ∂volume)
      = (∫ t in Set.Ioi (1:ℝ),
        psi t * ((t : ℂ) ^ (s / 2 - 1) + (t : ℂ) ^ ((1 - s) / 2 - 1)) ∂volume) := by
    congr 1
    funext t
    rw [show (1 - (1 - s)) / 2 - 1 = s / 2 - 1 by ring]
    ring
  have h2 : ((1 / ((1 - s) - 1) - 1 / (1 - s) : ℂ) = 1 / (s - 1) - 1 / s) := by
    have ha : (1 - s) - 1 = -s := by ring
    have hb : s - 1 = -(1 - s) := by ring
    rw [ha, hb, one_div, one_div, one_div, one_div, inv_neg, inv_neg]
    ring
  rw [h1, h2]


theorem hasDerivAt_cpow_affine {t : ℝ} (ht : 1 < t) (c d : ℂ) (s : ℂ) :
    HasDerivAt (fun s : ℂ => (t : ℂ) ^ (c * s + d)) (((t : ℂ) ^ (c * s + d)) * (c * Complex.log (t : ℂ))) s := by
  have ht0 : (0:ℝ) < t := by linarith
  have hf : HasDerivAt (fun _ : ℂ => (t : ℂ)) 0 s := hasDerivAt_const s _
  have hg : HasDerivAt (fun s : ℂ => c * s + d) c s := by
    simpa using ((hasDerivAt_id s).const_mul c).add_const d
  have hmem : (t : ℂ) ∈ Complex.slitPlane := by
    rw [Complex.ofReal_mem_slitPlane]
    linarith
  have h := hf.cpow hg hmem
  convert h using 1
  ring


theorem integrableOn_log_mul_rpow_mul_exp (a : ℝ) :
    IntegrableOn (fun t : ℝ => Real.log t * t ^ a * Real.exp (-Real.pi * t)) (Set.Ioi (1:ℝ)) := by
  obtain ⟨ε, hε0, hε⟩ : ∃ ε : ℝ, 0 < ε ∧ -1 < a + ε := by
    refine ⟨max 1 (-a), lt_of_lt_of_le one_pos (le_max_left _ _), ?_⟩
    have : a + max 1 (-a) ≥ a + (-a) := by
      have : max 1 (-a) ≥ -a := le_max_right _ _
      linarith
    linarith
  have hbase : IntegrableOn (fun t : ℝ => t ^ (a + ε) * Real.exp (-Real.pi * t)) (Set.Ioi (0:ℝ)) := by
    have h := integrableOn_rpow_mul_exp_neg_mul_rpow (p := (1:ℝ)) (s := a + ε) (b := Real.pi)
      hε one_pos Real.pi_pos
    simpa using h
  have hsub : IntegrableOn (fun t : ℝ => t ^ (a + ε) * Real.exp (-Real.pi * t)) (Set.Ioi (1:ℝ)) :=
    hbase.mono_set (Set.Ioi_subset_Ioi zero_le_one)
  have hdom : IntegrableOn (fun t : ℝ => (1 / ε) * (t ^ (a + ε) * Real.exp (-Real.pi * t)))
      (Set.Ioi (1:ℝ)) :=
    hsub.const_mul _
  refine MeasureTheory.Integrable.mono' hdom (by fun_prop : Measurable fun t : ℝ =>
    Real.log t * t ^ a * Real.exp (-Real.pi * t)).aestronglyMeasurable ?_
  filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
  have ht1 : (1:ℝ) ≤ t := le_of_lt ht
  have ht0 : (0:ℝ) < t := by linarith
  have hlog : Real.log t ≤ t ^ ε / ε := Real.log_le_rpow_div ht0.le hε0
  have hlog0 : 0 ≤ Real.log t := Real.log_nonneg ht1
  have hpow : t ^ (a + ε) = t ^ a * t ^ ε := Real.rpow_add ht0 a ε
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  calc Real.log t * t ^ a * Real.exp (-Real.pi * t)
      ≤ (t ^ ε / ε) * t ^ a * Real.exp (-Real.pi * t) := by
        apply mul_le_mul_of_nonneg_right _ (Real.exp_pos _).le
        apply mul_le_mul_of_nonneg_right hlog (Real.rpow_nonneg ht0.le a)
    _ = (1 / ε) * (t ^ (a + ε) * Real.exp (-Real.pi * t)) := by
        rw [hpow]
        field_simp


theorem mellin_indicator_Ioi_psi (c : ℂ) :
    mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) c
      = ∫ t in Set.Ioi (1:ℝ), (t : ℂ) ^ (c - 1) • psi t ∂volume := by
  rw [mellin]
  have h : (fun t : ℝ => (t : ℂ) ^ (c - 1) • Set.indicator (Set.Ioi (1:ℝ)) psi t)
      = Set.indicator (Set.Ioi (1:ℝ)) (fun t : ℝ => (t : ℂ) ^ (c - 1) • psi t) := by
    funext t
    by_cases ht : t ∈ Set.Ioi (1:ℝ)
    · rw [Set.indicator_of_mem ht, Set.indicator_of_mem ht]
    · rw [Set.indicator_of_notMem ht, Set.indicator_of_notMem ht, smul_zero]
  rw [h, MeasureTheory.setIntegral_indicator measurableSet_Ioi]
  rw [Set.inter_eq_right.mpr (Set.Ioi_subset_Ioi zero_le_one)]


theorem isBigO_indicator_psi_top :
    (Set.indicator (Set.Ioi (1:ℝ)) psi) =O[atTop] (fun t : ℝ => Real.exp (-Real.pi * t)) := by
  have he : Real.exp (-Real.pi) < 1 := by
    rw [Real.exp_lt_one_iff]
    linarith [Real.pi_pos]
  have hden : (0:ℝ) < 1 - Real.exp (-Real.pi) := by linarith
  refine Asymptotics.IsBigO.of_bound (1 / (1 - Real.exp (-Real.pi))) ?_
  filter_upwards [eventually_ge_atTop (1:ℝ)] with t ht
  by_cases hmem : t ∈ Set.Ioi (1:ℝ)
  · rw [Set.indicator_of_mem hmem]
    have hb := norm_psi_le_Ioi (le_of_lt hmem)
    have hexp : Real.exp (-Real.pi * t) ≤ 1 := by
      rw [Real.exp_le_one_iff]; nlinarith [Real.pi_pos]
    have hpos : (0:ℝ) ≤ Real.exp (-Real.pi * t) := (Real.exp_pos _).le
    calc ‖psi t‖ ≤ Real.exp (-Real.pi * t) / (1 - Real.exp (-Real.pi)) := hb
      _ = (1 / (1 - Real.exp (-Real.pi))) * Real.exp (-Real.pi * t) := by
          rw [div_eq_mul_inv]; ring
      _ = (1 / (1 - Real.exp (-Real.pi))) * ‖Real.exp (-Real.pi * t)‖ := by
          rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  · rw [Set.indicator_of_notMem hmem, norm_zero]
    have hpos : (0:ℝ) ≤ Real.exp (-Real.pi * t) := (Real.exp_pos _).le
    have : (0:ℝ) ≤ 1 / (1 - Real.exp (-Real.pi)) := by positivity
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    exact mul_nonneg this hpos

theorem isBigO_indicator_psi_zero (b : ℝ) :
    (Set.indicator (Set.Ioi (1:ℝ)) psi) =O[𝓝[>] (0:ℝ)] (fun t : ℝ => t ^ (-b)) := by
  refine Asymptotics.IsBigO.of_bound 0 ?_
  have hev : ∀ᶠ t : ℝ in 𝓝[>] (0:ℝ), t < 1 :=
    (eventually_lt_nhds (by norm_num : (0:ℝ) < 1)).filter_mono nhdsWithin_le_nhds
  filter_upwards [hev] with t ht1
  have htmem : t ∉ Set.Ioi (1:ℝ) := by simp; linarith
  rw [Set.indicator_of_notMem htmem, norm_zero, zero_mul]


theorem locallyIntegrableOn_indicator_psi :
    LocallyIntegrableOn (Set.indicator (Set.Ioi (1:ℝ)) psi) (Set.Ioi (0:ℝ)) := by
  have he : Real.exp (-Real.pi) < 1 := by
    rw [Real.exp_lt_one_iff]
    linarith [Real.pi_pos]
  have hden : (0:ℝ) < 1 - Real.exp (-Real.pi) := by linarith
  have hcont : ContinuousOn (fun t : ℝ => t ^ (-(1/2) : ℝ) + 1) (Set.Ioi (0:ℝ)) :=
    (continuousOn_id.rpow_const (fun x hx => Or.inl (ne_of_gt hx))).add continuousOn_const
  have hcont2 : ContinuousOn
      (fun t : ℝ => (1 / (1 - Real.exp (-Real.pi)) + 1) * (t ^ (-(1/2) : ℝ) + 1))
      (Set.Ioi (0:ℝ)) :=
    continuousOn_const.mul hcont
  have hmaj : LocallyIntegrableOn
      (fun t : ℝ => (1 / (1 - Real.exp (-Real.pi)) + 1) * (t ^ (-(1/2) : ℝ) + 1))
      (Set.Ioi (0:ℝ)) :=
    hcont2.locallyIntegrableOn measurableSet_Ioi
  refine MeasureTheory.LocallyIntegrableOn.mono hmaj
    (measurable_psi.indicator measurableSet_Ioi).aestronglyMeasurable ?_
  refine Filter.Eventually.of_forall (fun t => ?_)
  by_cases ht0 : (0:ℝ) < t
  · have hnorm : ‖(1 / (1 - Real.exp (-Real.pi)) + 1) * (t ^ (-(1/2) : ℝ) + 1)‖
        = (1 / (1 - Real.exp (-Real.pi)) + 1) * (t ^ (-(1/2) : ℝ) + 1) := by
      rw [Real.norm_eq_abs, abs_of_pos (by positivity)]
    rw [hnorm]
    by_cases hmem : t ∈ Set.Ioi (1:ℝ)
    · rw [Set.indicator_of_mem hmem]
      have hb := norm_psi_le_Ioi (le_of_lt hmem)
      have hexp : Real.exp (-Real.pi * t) ≤ 1 := by
        rw [Real.exp_le_one_iff]; nlinarith [Real.pi_pos]
      have h1 : ‖psi t‖ ≤ 1 / (1 - Real.exp (-Real.pi)) := by
        refine hb.trans ?_
        rw [div_le_div_iff₀ hden hden]
        nlinarith
      have h3 : (1:ℝ) ≤ t ^ (-(1/2) : ℝ) + 1 := by
        have := Real.rpow_nonneg ht0.le (-(1/2) : ℝ)
        linarith
      have h2 : (1 / (1 - Real.exp (-Real.pi))) ≤ (1 / (1 - Real.exp (-Real.pi)) + 1) *
          (t ^ (-(1/2) : ℝ) + 1) := by
        calc (1 / (1 - Real.exp (-Real.pi)))
            = (1 / (1 - Real.exp (-Real.pi))) * 1 := by ring
          _ ≤ (1 / (1 - Real.exp (-Real.pi)) + 1) * (t ^ (-(1/2) : ℝ) + 1) := by
              apply mul_le_mul (by linarith) h3 (by norm_num) (by positivity)
      exact h1.trans h2
    · rw [Set.indicator_of_notMem hmem, norm_zero]
      positivity
  · push_neg at ht0
    have hmem : t ∉ Set.Ioi (1:ℝ) := by simp; linarith
    rw [Set.indicator_of_notMem hmem, norm_zero]
    positivity


theorem differentiableAt_mellin_indicator (c : ℂ) :
    DifferentiableAt ℂ (mellin (Set.indicator (Set.Ioi (1:ℝ)) psi)) c := by
  refine mellin_differentiableAt_of_isBigO_rpow_exp (a := Real.pi) Real.pi_pos
    locallyIntegrableOn_indicator_psi isBigO_indicator_psi_top
    (isBigO_indicator_psi_zero (c.re - 1)) ?_
  linarith

theorem LambdaTilde_eq_mellin (s : ℂ) :
    LambdaTilde s
      = mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) (s / 2)
        + mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) ((1 - s) / 2) + (1 / (s - 1) - 1 / s) := by
  unfold LambdaTilde
  have hA : IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ (s / 2 - 1)) (Set.Ioi (1:ℝ)) :=
    integrableOn_psi_cpow_Ioi' _
  have hB : IntegrableOn (fun t : ℝ => psi t * (t : ℂ) ^ ((1 - s) / 2 - 1)) (Set.Ioi (1:ℝ)) :=
    integrableOn_psi_cpow_Ioi' _
  have hsplit : (∫ t in Set.Ioi (1:ℝ),
        psi t * ((t : ℂ) ^ (s / 2 - 1) + (t : ℂ) ^ ((1 - s) / 2 - 1)) ∂volume)
      = (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
        + (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ ((1 - s) / 2 - 1) ∂volume) := by
    rw [← MeasureTheory.integral_add hA hB]
    congr 1
    funext t
    ring
  have h1 : (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ (s / 2 - 1) ∂volume)
      = mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) (s / 2) := by
    rw [mellin_indicator_Ioi_psi]
    congr 1
    funext t
    rw [smul_eq_mul, mul_comm]
  have h2 : (∫ t in Set.Ioi (1:ℝ), psi t * (t : ℂ) ^ ((1 - s) / 2 - 1) ∂volume)
      = mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) ((1 - s) / 2) := by
    rw [mellin_indicator_Ioi_psi]
    congr 1
    funext t
    rw [smul_eq_mul, mul_comm]
  rw [hsplit, h1, h2]

theorem differentiableAt_LambdaTilde (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ LambdaTilde s := by
  have h1 : DifferentiableAt ℂ (fun s : ℂ => mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) (s / 2)) s := by
    have hg : DifferentiableAt ℂ (mellin (Set.indicator (Set.Ioi (1:ℝ)) psi)) (s / 2) :=
      differentiableAt_mellin_indicator (s / 2)
    have hf : DifferentiableAt ℂ (fun s : ℂ => s / 2) s := differentiableAt_id.div_const 2
    simpa [Function.comp_def] using hg.comp s hf
  have h2 : DifferentiableAt ℂ
      (fun s : ℂ => mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) ((1 - s) / 2)) s := by
    have hg : DifferentiableAt ℂ (mellin (Set.indicator (Set.Ioi (1:ℝ)) psi)) ((1 - s) / 2) :=
      differentiableAt_mellin_indicator ((1 - s) / 2)
    have hf : DifferentiableAt ℂ (fun s : ℂ => (1 - s) / 2) s :=
      ((differentiableAt_const 1).sub differentiableAt_id).div_const 2
    simpa [Function.comp_def] using hg.comp s hf
  have h3 : DifferentiableAt ℂ (fun s : ℂ => 1 / (s - 1)) s := by
    refine DifferentiableAt.div ?_ ?_ ?_
    · exact differentiableAt_const 1
    · exact differentiableAt_id.sub_const 1
    · simpa using sub_ne_zero.mpr hs1
  have h4 : DifferentiableAt ℂ (fun s : ℂ => 1 / s) s := by
    exact DifferentiableAt.div (differentiableAt_const 1) differentiableAt_id hs0
  have hconv : LambdaTilde = fun s : ℂ => mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) (s / 2)
      + mellin (Set.indicator (Set.Ioi (1:ℝ)) psi) ((1 - s) / 2) + (1 / (s - 1) - 1 / s) := by
    funext w
    exact LambdaTilde_eq_mellin w
  rw [hconv]
  exact ((h1.add h2).add (h3.sub h4))


theorem completedRiemannZeta_eq_LambdaTilde_all (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    completedRiemannZeta s = LambdaTilde s := by
  have hpair : ({0, 1} : Set ℂ) = {0} ∪ {1} := by
    ext x
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff, Set.mem_union]
  have hU : IsPreconnected (({0, 1} : Set ℂ)ᶜ) := by
    have hc : ({0, 1} : Set ℂ).Countable :=
      (Set.countable_singleton 0).union (Set.countable_singleton 1)
    exact (Set.Countable.isConnected_compl_of_one_lt_rank (E := ℂ)
      (by rw [Complex.rank_real_complex]; norm_num) hc).isPreconnected
  have hUopen : IsOpen (({0, 1} : Set ℂ)ᶜ) := by
    rw [hpair, Set.compl_union]
    exact isOpen_compl_singleton.inter isOpen_compl_singleton
  have hΛ : AnalyticOnNhd ℂ completedRiemannZeta (({0, 1} : Set ℂ)ᶜ) := by
    refine DifferentiableOn.analyticOnNhd ?_ hUopen
    intro z hz
    simp only [Set.mem_compl_iff, Set.mem_insert_iff, Set.mem_singleton_iff] at hz
    exact (differentiableAt_completedZeta (by tauto) (by tauto)).differentiableWithinAt
  have hΛt : AnalyticOnNhd ℂ LambdaTilde (({0, 1} : Set ℂ)ᶜ) := by
    refine DifferentiableOn.analyticOnNhd ?_ hUopen
    intro z hz
    simp only [Set.mem_compl_iff, Set.mem_insert_iff, Set.mem_singleton_iff] at hz
    exact (differentiableAt_LambdaTilde z (by tauto) (by tauto)).differentiableWithinAt
  have h2mem : (2 : ℂ) ∈ (({0, 1} : Set ℂ)ᶜ) := by
    simp
  have hfg : completedRiemannZeta =ᶠ[𝓝 (2:ℂ)] LambdaTilde := by
    have hopen : IsOpen {z : ℂ | 1 < z.re} := isOpen_lt continuous_const continuous_re
    filter_upwards [hopen.mem_nhds (by norm_num : (1:ℝ) < (2:ℂ).re)] with z hz
    exact completedRiemannZeta_eq_LambdaTilde z hz
  have heq := AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hΛ hΛt hU h2mem hfg
  have hmem : s ∈ (({0, 1} : Set ℂ)ᶜ) := by
    simp only [Set.mem_compl_iff, Set.mem_insert_iff, Set.mem_singleton_iff]
    tauto
  exact heq hmem

theorem completedRiemannZeta_one_sub_theta (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    completedRiemannZeta (1 - s) = completedRiemannZeta s := by
  have h1 : (1 - s) ≠ 0 := by
    intro h
    exact hs1 (by linear_combination -h)
  have h2 : (1 - s) ≠ 1 := by
    intro h
    exact hs0 (by linear_combination -h)
  rw [completedRiemannZeta_eq_LambdaTilde_all (1 - s) h1 h2,
      completedRiemannZeta_eq_LambdaTilde_all s hs0 hs1, LambdaTilde_one_sub]


theorem riemannZeta_one_sub_theta {s : ℂ} (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1)
    (hG : Complex.Gammaℝ (1 - s) ≠ 0) :
    riemannZeta (1 - s)
      = 2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s * Complex.cos (Real.pi * s / 2)
        * riemannZeta s := by
  have hs0 : s ≠ 0 := by
    intro h
    exact hs 0 (by simpa using h)
  have h1s : (1 - s) ≠ 0 := by
    intro h
    exact hs' (by linear_combination -h)
  have hodd : ∀ n : ℕ, s ≠ -(2 * (n : ℂ) + 1) := by
    intro n h
    exact hs (2 * n + 1) (by push_cast; linear_combination h)
  have hFE : completedRiemannZeta (1 - s) = completedRiemannZeta s :=
    completedRiemannZeta_one_sub_theta s hs0 hs'
  have hζ1 : riemannZeta (1 - s) = completedRiemannZeta (1 - s) / Complex.Gammaℝ (1 - s) :=
    riemannZeta_def_of_ne_zero h1s
  have hζ : riemannZeta s = completedRiemannZeta s / Complex.Gammaℝ s :=
    riemannZeta_def_of_ne_zero hs0
  have hrat : Complex.Gammaℝ s / Complex.Gammaℝ (1 - s) = Complex.Gammaℂ s * Complex.cos (Real.pi * s / 2) :=
    Complex.Gammaℝ_div_Gammaℝ_one_sub hodd
  have hGs : Complex.Gammaℝ s ≠ 0 := by
    intro h
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
    exact hs (2 * n) (by push_cast; linear_combination hn)
  have hGC : (2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s : ℂ) = Complex.Gammaℂ s := by
    rw [Complex.Gammaℂ_def]
  rw [hζ1, hFE, hζ, hGC, ← hrat]
  field_simp


theorem riemannZeta_one_sub_theta' {s : ℂ} (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1) :
    riemannZeta (1 - s)
      = 2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s * Complex.cos (Real.pi * s / 2)
        * riemannZeta s := by
  by_cases hG : Complex.Gammaℝ (1 - s) ≠ 0
  · exact riemannZeta_one_sub_theta hs hs' hG
  · push_neg at hG
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp hG
    have hs1 : s = 1 + 2 * (n : ℂ) := by linear_combination -hn
    rcases n with _ | m
    · rw [Nat.cast_zero] at hs1
      simp only [mul_zero, add_zero] at hs1
      exact absurd hs1 hs'
    · have hL : riemannZeta (1 - s) = 0 := by
        rw [hs1]
        have harg : (1 : ℂ) - (1 + 2 * (((m + 1 : ℕ)) : ℂ)) = -2 * (((m + 1 : ℕ)) : ℂ) := by ring
        rw [harg]
        have h := riemannZeta_neg_two_mul_nat_add_one m
        convert h using 2
        push_cast
        ring
      have hcos : Complex.cos ((Real.pi : ℂ) * s / 2) = 0 := by
        have harg : (Real.pi : ℂ) * s / 2
            = ((Real.pi / 2 + ((m : ℕ) + 1 : ℕ) * Real.pi : ℝ) : ℂ) := by
          rw [hs1]
          push_cast
          ring
        rw [harg, ← Complex.ofReal_cos, Real.cos_add_nat_mul_pi, Real.cos_pi_div_two, mul_zero]
        norm_cast
      rw [hL, hcos]
      ring

end ZetaTheta
