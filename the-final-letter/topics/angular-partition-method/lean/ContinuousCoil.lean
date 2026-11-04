import Mathlib

/-!
# The Hurwitz-zeta integral representation and the continuous coil

For `x > 0` and `Re s > 1`, the shifted zeta tail

`ζ(s,x) = ∑ n, (x+n)^(-s)`

has the Mellin/Laplace representation

`Γ(s) ζ(s,x) = ∫_0^∞ t^(s-1) e^(-x t) / (1 - e^(-t)) dt`.

This is the continuous version of the annular tail coil: replacing the integer
depth `n` by a real parameter `x` turns the sequence of annuli into a continuous
radial field, and the complex tail into a continuous spiral.

The file formalises the integral identity for the shifted tail.  It does not
claim analytic continuation beyond `Re s > 1`.
-/

open Real Set MeasureTheory
open Complex

noncomputable section

namespace AngularPartition

/-- The shifted zeta kernel `e^(-x t)/(1-e^(-t))` on `(0,∞)`. -/
def shiftedZetaKernel (x : ℝ) (t : ℝ) : ℂ :=
  (((Real.exp (-x * t)) / (1 - Real.exp (-t)) : ℝ) : ℂ)

/-- The continuous shifted tail `∑ n, (x+n)^(-s)`. -/
noncomputable def shiftedTail (x : ℝ) (s : ℂ) : ℂ :=
  ∑' n : ℕ, 1 / (((x + n : ℝ) : ℂ) ^ s)

/-- The continuous coil: the shifted tail as a function of the radial
parameter `x`. -/
noncomputable def continuousCoil (s : ℂ) (x : ℝ) : ℂ :=
  shiftedTail x s

/-- The geometric series for the shifted kernel. -/
theorem hasSum_shiftedZetaKernel {x t : ℝ} (_hx : 0 < x) (ht : 0 < t) :
    HasSum (fun n : ℕ => (1 : ℂ) * (Real.exp (-(x + n) * t) : ℂ))
      (shiftedZetaKernel x t) := by
  have hrpos : 0 < Real.exp (-t) := Real.exp_pos _
  have hrlt : Real.exp (-t) < 1 := by
    rw [Real.exp_lt_one_iff]
    linarith
  have hgeom : HasSum (fun n : ℕ => (Real.exp (-t)) ^ n)
      (1 - Real.exp (-t))⁻¹ :=
    hasSum_geometric_of_lt_one hrpos.le hrlt
  have hshift : HasSum (fun n : ℕ => Real.exp (-(x * t)) * (Real.exp (-t)) ^ n)
      (Real.exp (-(x * t)) * (1 - Real.exp (-t))⁻¹) :=
    hgeom.mul_left (Real.exp (-(x * t)))
  have hfun : (fun n : ℕ => Real.exp (-(x * t)) * (Real.exp (-t)) ^ n)
      = fun n : ℕ => Real.exp (-(x + n) * t) := by
    funext n
    calc
      Real.exp (-(x * t)) * (Real.exp (-t)) ^ n
          = Real.exp (-(x * t)) * Real.exp (n * (-t)) := by rw [Real.exp_nat_mul]
      _ = Real.exp (-(x * t) + n * (-t)) := by rw [← Real.exp_add]
      _ = Real.exp (-(x + n) * t) := by
            rw [show -(x * t) + n * (-t) = -(x + n) * t by ring]
  have hsum_eq : Real.exp (-(x * t)) * (1 - Real.exp (-t))⁻¹
      = Real.exp (-(x * t)) / (1 - Real.exp (-t)) := by
    rw [div_eq_mul_inv]
  have hreal : HasSum (fun n : ℕ => Real.exp (-(x + n) * t))
      (Real.exp (-(x * t)) / (1 - Real.exp (-t))) := by
    simpa [hfun, hsum_eq] using hshift
  have hcomplex : HasSum
      (fun n : ℕ => ((Real.exp (-(x + n) * t) : ℝ) : ℂ))
      ((Real.exp (-(x * t)) / (1 - Real.exp (-t)) : ℝ) : ℂ) :=
    (Complex.hasSum_ofReal).2 hreal
  simpa [shiftedZetaKernel, one_mul] using hcomplex

/-- The shifted Mellin series, before identifying its sum with `Γ(s) ζ(s,x)`. -/
theorem hasSum_mellin_shiftedZetaKernel {x : ℝ} (hx : 0 < x) {s : ℂ}
    (hs : 1 < s.re) :
    HasSum (fun n : ℕ => Gamma s * 1 / (((x + n : ℝ) : ℂ) ^ s))
      (mellin (shiftedZetaKernel x) s) := by
  have hs0 : 0 < s.re := lt_trans zero_lt_one hs
  have hp : ∀ n : ℕ, (1 : ℂ) = 0 ∨ 0 < x + (n : ℝ) := by
    intro n
    exact Or.inr (by positivity)
  have hF : ∀ t ∈ Ioi (0 : ℝ),
      HasSum (fun n : ℕ => (1 : ℂ) * (Real.exp (-(x + n) * t) : ℂ))
        (shiftedZetaKernel x t) := by
    intro t ht
    exact hasSum_shiftedZetaKernel hx ht
  have hsum_real : Summable (fun n : ℕ => (1 : ℝ) / ((x + n : ℝ) ^ s.re)) := by
    have h := (Real.summable_one_div_nat_add_rpow x s.re).2 hs
    convert h using 1
    ext n
    rw [abs_of_pos (by positivity : 0 < (n : ℝ) + x), add_comm]
  have hsum : Summable (fun n : ℕ => ‖(1 : ℂ)‖ / ((x + n : ℝ) ^ s.re)) := by
    simpa using hsum_real
  exact hasSum_mellin (a := fun _ : ℕ => (1 : ℂ))
    (p := fun n : ℕ => x + n) hp hs0 hF hsum

/-- **Hurwitz-zeta integral representation.**
For `x > 0` and `Re s > 1`,
`mellin (e^(-x t)/(1-e^(-t))) s = Γ(s) ∑ n, (x+n)^(-s)`.
-/
theorem mellin_shiftedZetaKernel_eq {x : ℝ} (hx : 0 < x) {s : ℂ}
    (hs : 1 < s.re) :
    mellin (shiftedZetaKernel x) s = Gamma s * shiftedTail x s := by
  have hmain := hasSum_mellin_shiftedZetaKernel hx hs
  calc
    mellin (shiftedZetaKernel x) s
        = ∑' n : ℕ, Gamma s * 1 / (((x + n : ℝ) : ℂ) ^ s) :=
          hmain.tsum_eq.symm
    _ = Gamma s * ∑' n : ℕ, 1 / (((x + n : ℝ) : ℂ) ^ s) := by
          have hfactor : (fun n : ℕ => Gamma s * 1 / (((x + n : ℝ) : ℂ) ^ s))
              = fun n : ℕ => Gamma s * (1 / (((x + n : ℝ) : ℂ) ^ s)) := by
            funext n
            simp [div_eq_mul_inv]
          rw [hfactor, tsum_mul_left]
    _ = Gamma s * shiftedTail x s := by
          rw [shiftedTail]

/-- The continuous coil as the normalized integral. -/
theorem continuousCoil_eq_integral {x : ℝ} (hx : 0 < x) {s : ℂ}
    (hs : 1 < s.re) :
    continuousCoil s x =
      (Gamma s)⁻¹ * mellin (shiftedZetaKernel x) s := by
  rw [continuousCoil, mellin_shiftedZetaKernel_eq hx hs]
  have hG : Gamma s ≠ 0 :=
    Complex.Gamma_ne_zero_of_re_pos (lt_trans zero_lt_one hs)
  field_simp [hG]

/-- The power-law continuous coil `Z_c(x) = x^(1-σ)/(σ-1)`, the tail integral
of `t ↦ t^(-σ)` from `x` to `∞`. -/
noncomputable def continuousIntegralCoil (σ x : ℝ) : ℝ :=
  x ^ (1 - σ) / (σ - 1)

/-- **Continuous integral closed form.** For `σ > 1`,
`∫_1^∞ x^(-σ) dx = 1/(σ-1)`. -/
theorem integral_Ioi_rpow_neg_eq_inv_sub_one {σ : ℝ} (hσ : 1 < σ) :
    ∫ x : ℝ in Ioi (1 : ℝ), x ^ (-σ) = (σ - 1)⁻¹ := by
  have ha : -σ < -1 := by linarith
  rw [integral_Ioi_rpow_of_lt ha zero_lt_one, one_rpow]
  have h1 : -σ + 1 ≠ 0 := by linarith
  have h2 : σ - 1 ≠ 0 := by linarith
  field_simp
  ring

/-- The continuous integral coil is the tail integral: for `σ > 1` and `x > 0`,
`∫_x^∞ t^(-σ) dt = x^(1-σ)/(σ-1)`. -/
theorem integral_Ioi_rpow_neg_eq_continuousIntegralCoil {σ x : ℝ} (hσ : 1 < σ)
    (hx : 0 < x) :
    ∫ t : ℝ in Ioi x, t ^ (-σ) = continuousIntegralCoil σ x := by
  have ha : -σ < -1 := by linarith
  rw [integral_Ioi_rpow_of_lt ha hx, continuousIntegralCoil]
  have hexp : -σ + 1 = 1 - σ := by ring
  rw [hexp]
  have h1 : 1 - σ ≠ 0 := by linarith
  have h2 : σ - 1 ≠ 0 := by linarith
  field_simp
  ring

/-- **Continuous coil derivative.** For `σ > 1` and `x > 0`,
`d/dx [x^(1-σ)/(σ-1)] = -x^(-σ)`: the term is the negative derivative of the
tail. -/
theorem hasDerivAt_continuousIntegralCoil {σ : ℝ} (hσ : 1 < σ) {x : ℝ}
    (hx : 0 < x) :
    HasDerivAt (continuousIntegralCoil σ) (-(x ^ (-σ))) x := by
  have h : HasDerivAt (fun y : ℝ => y ^ (1 - σ))
      ((1 - σ) * x ^ ((1 - σ) - 1)) x :=
    hasDerivAt_rpow_const (Or.inl hx.ne')
  have hdiv : HasDerivAt (fun y : ℝ => y ^ (1 - σ) / (σ - 1))
      (((1 - σ) * x ^ ((1 - σ) - 1)) / (σ - 1)) x :=
    h.div_const (σ - 1)
  have hfun : continuousIntegralCoil σ
      = fun y : ℝ => y ^ (1 - σ) / (σ - 1) := rfl
  rw [hfun]
  convert hdiv using 1
  have hexp : (1 - σ) - 1 = -σ := by ring
  rw [hexp]
  have h2 : σ - 1 ≠ 0 := by linarith
  field_simp
  ring

/-- The complex power-law coil `Z_c(x) = x^(1-s)/(s-1)`, the analytic
continuation of `continuousIntegralCoil` to complex `s`. -/
noncomputable def continuousComplexCoil (s : ℂ) (x : ℝ) : ℂ :=
  (x : ℂ) ^ (1 - s) / (s - 1)

/-- The per-turn factor of the complex coil: for `s = σ + it` with `t ≠ 0`,
`(e^(2π/|t|))^(1-s) = e^(-2π(σ-1)/|t|)`. The imaginary part of the exponent is
an integer multiple of `2π`, so it contributes `1`. -/
theorem cpow_selfSimilar_factor {s : ℂ} (ht : s.im ≠ 0) :
    ((Real.exp (2 * Real.pi / |s.im|) : ℝ) : ℂ) ^ (1 - s) =
      (Real.exp (-(2 * Real.pi * (s.re - 1) / |s.im|)) : ℂ) := by
  set a : ℝ := 2 * Real.pi / |s.im| with ha
  have ht_abs : 0 < |s.im| := abs_pos.mpr ht
  have ha_pos : 0 < a := by
    rw [ha]
    positivity
  have hexpne : ((Real.exp a : ℝ) : ℂ) ≠ 0 := by
    exact_mod_cast (Real.exp_pos a).ne'
  rw [Complex.cpow_def_of_ne_zero hexpne]
  have hlog : Complex.log ((Real.exp a : ℝ) : ℂ) = (a : ℂ) := by
    have h := Complex.log_mul_ofReal (Real.exp a) (Real.exp_pos a) (1 : ℂ) one_ne_zero
    simpa [Real.log_exp] using h
  rw [hlog]
  have harg : (a : ℂ) * (1 - s) =
      ((a * (1 - s.re) : ℝ) : ℂ) + ((-(a * s.im)) : ℝ) * Complex.I := by
    apply Complex.ext
    · simp [Complex.mul_re, Complex.sub_re]
    · simp [Complex.mul_im, Complex.sub_im]
  rw [harg, Complex.exp_add, ← Complex.ofReal_exp]
  have hphase : Complex.exp ((↑(-(a * s.im)) : ℂ) * Complex.I) = 1 := by
    have hratio : s.im / |s.im| = 1 ∨ s.im / |s.im| = -1 := by
      rcases lt_or_gt_of_ne ht with hneg | hpos
      · right
        rw [abs_of_neg hneg]
        field_simp
      · left
        rw [abs_of_pos hpos]
        field_simp
    have hkey : -(a * s.im) = (-(2 * Real.pi)) * (s.im / |s.im|) := by
      rw [ha]
      field_simp
    rw [hkey]
    rcases hratio with h | h
    · rw [h, mul_one, Complex.exp_mul_I]
      simp
    · rw [h]
      rw [show (-(2 * Real.pi)) * (-1) = 2 * Real.pi by ring, Complex.exp_mul_I]
      simp
  rw [hphase, mul_one]
  congr 1
  rw [ha]
  congr 1
  field_simp
  ring

/-- **T82 — complex coil self-similarity.** For `s = σ + it` with `σ > 1` and
`t ≠ 0`, the complex coil `Z_c(x) = x^(1-s)/(s-1)` satisfies
`Z_c(e^(2π/|t|) x) = e^(-2π(σ-1)/|t|) Z_c(x)` for `x > 0`: one turn of phase
contracts the radius by the same factor `ρ = e^(-2π(σ-1)/|t|)`. -/
theorem continuousComplexCoil_selfSimilar {s : ℂ} (hs : 1 < s.re)
    (ht : s.im ≠ 0) {x : ℝ} (hx : 0 < x) :
    continuousComplexCoil s (Real.exp (2 * Real.pi / |s.im|) * x)
      = (Real.exp (-(2 * Real.pi * (s.re - 1) / |s.im|)) : ℂ) *
        continuousComplexCoil s x := by
  have hexppos : 0 < Real.exp (2 * Real.pi / |s.im|) := Real.exp_pos _
  have hs1 : s - 1 ≠ 0 := by
    intro h
    have hre : s.re - 1 = 0 := by
      simpa using congrArg Complex.re h
    linarith
  unfold continuousComplexCoil
  have hcast : ((Real.exp (2 * Real.pi / |s.im|) * x : ℝ) : ℂ)
      = ((Real.exp (2 * Real.pi / |s.im|) : ℝ) : ℂ) * (x : ℂ) := by
    push_cast
    ring
  rw [hcast, Complex.mul_cpow_ofReal_nonneg hexppos.le (le_of_lt hx) (1 - s),
    cpow_selfSimilar_factor ht, mul_div_assoc]

end AngularPartition
