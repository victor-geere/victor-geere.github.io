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

end AngularPartition
