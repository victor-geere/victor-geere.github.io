/-
  Archimedean.lean — the archimedean term of the validated Weil explicit formula.

  Round `010` (Route C) certifies the identity

      Σ_ρ Φ(ρ) = Φ(1) + Φ(0) − Σ_{n≥2} (Λ n/√n)[g(log n) + g(−log n)]
                 + (1/2π) ∫_ℝ φ(t) Ψ(t) dt ,

      Ψ(t) = −log π + Re ψ(1/4 + i t/2) ,   φ(t) = ∫_ℝ g(u) e^{itu} du ,

  with `ψ` the digamma function and `g` an even test function.  The *algebraic*
  layer of the formula is in `Rh45/Explicit.lean`; this file begins the formal
  treatment of the archimedean piece, which until now existed only on paper
  (`../truths.md` §1, `../index.html` §3, `../notes/routes-a-b-c-status.md` §4).

  What is proved here:

  * the archimedean kernel `t ↦ Ψ(t)` as the restriction of `Complex.digamma`
    to the vertical line `Re z = 1/4` (`digammaLine`), together with
    continuity and measurability (`continuous_Psi`, `continuous_PsiBar`,
    `measurable_PsiBar`) — the line misses the poles of `Γ`, so Mathlib's
    analyticity of `Γ` on `Re z > 0` applies;
  * the structural facts about `ψ` that Mathlib *does* supply, read on the
    line: the recurrence `ψ(z+n) = ψ(z) + Σ_{k<n} (z+k)⁻¹`
    (`digammaLine_add_nat`) and Euler's reflection formula
    (`digammaLine_reflection`);
  * the chain rule that produces the `2^{−k}` of the round's derivative budget:
    `(d/dt)^k Ψ(t) = (i/2)^k ψ^{(k)}(1/4 + i t/2)`
    (`iteratedDeriv_Psi_eq`), hence the reduction
    `‖Ψ^{(k)}(t)‖ ≤ 2^{−k} ‖ψ^{(k)}(1/4 + i t/2)‖` and the conditional
    derivative bound `archimedean_deriv_bound_of_digamma_series`;
  * the product rule for the fourth derivative of `t ↦ φ(t)Ψ(t)` with
    independent budgets on `φ` and `Ψ` (`abs_iteratedDeriv_mul_le`,
    `abs_iteratedDeriv_four_mul_le`), i.e. the `Σ_k binom(4,k) M_k P_{4−k}`
    of the round;
  * the composite-Simpson assembly (`simpsonSum_mul_error_le`): from the
    single-panel Simpson estimate — *proved* in `Rh45/SimpsonPanel.lean` as
    `simpsonPanelEstimate` — plus the product budget, the composite error obeys
    the round's `(b−a) h⁴/180 · Σ_k binom(4,k) M_k P_{4−k}`.

  What is *not* available in Mathlib and is therefore flagged, not faked:
  any series, asymptotic expansion or growth estimate for `ψ` or its
  derivatives (Hurwitz-zeta sums `Σ_j (1/4+j)^{−k−1}`).  See the docstring of
  `archimedean_deriv_bound_of_digamma_series`.  The series has since been
  *proved* for `k ≥ 1` in `Rh45/PolygammaSeries.lean`
  (`Rh45RouteBAnalytic.digamma_polygamma_series`), making
  `Rh45.archimedean_deriv_bound` unconditional for `k ≥ 1`; the `k = 0` series
  diverges (`Rh45.psiSeriesBound_zero`).  Simpson's rule used to be on
  this list; it is now proved, see `Rh45/SimpsonPanel.lean` and `SIMPSON.md`.

  There is no `sorry`, no `axiom` and no computation by reflection.
-/
import Mathlib
import SimpsonPanel

namespace Rh45

noncomputable section

open scoped BigOperators
open MeasureTheory

/-! ## 1. The digamma line, `Ψ`, and the archimedean term -/

/-- The vertical line `Re z = 1/4` parametrised by `t ↦ 1/4 + i t/2`, written in
the form `t ↦ t · (i/2) + 1/4` so that the chain rule below is an instance of the
affine composition rule. -/
def digammaLine (t : ℝ) : ℂ := (t : ℂ) * (Complex.I / 2) + 1 / 4

/-- The defining equation of `digammaLine`. -/
theorem digammaLine_def (t : ℝ) : digammaLine t = (t : ℂ) * (Complex.I / 2) + 1 / 4 := rfl

/-- **The line is `1/4 + i t/2`**, the argument of `ψ` in the round's `Ψ`. -/
theorem digammaLine_eq (t : ℝ) : digammaLine t = (1 / 4 : ℂ) + ((t / 2 : ℝ) : ℂ) * Complex.I := by
  rw [digammaLine_def]
  push_cast
  ring

/-- **Real part of the line.**  The line never leaves `Re z = 1/4`, which is where
the archimedean factor of the explicit formula lives. -/
theorem digammaLine_re (t : ℝ) : (digammaLine t).re = 1 / 4 := by
  rw [digammaLine_eq]; simp

/-- **Imaginary part of the line:** `Im (1/4 + i t/2) = t/2`. -/
theorem digammaLine_im (t : ℝ) : (digammaLine t).im = t / 2 := by
  rw [digammaLine_eq]; simp

/-- **The line misses the poles of `Γ`.**  A non-positive integer `-m` is real,
while `digammaLine t` has imaginary part `t/2` and real part `1/4`; equality would
force `t = 0` and then `1/4 = -m`, impossible. -/
theorem digammaLine_ne_neg_nat (t : ℝ) (m : ℕ) : digammaLine t ≠ -(m : ℂ) := by
  intro h
  have him : (digammaLine t).im = (-(m : ℂ)).im := congrArg Complex.im h
  rw [digammaLine_im] at him
  simp at him
  have hre : (digammaLine t).re = (-(m : ℂ)).re := congrArg Complex.re h
  rw [digammaLine_re] at hre
  have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  simp at hre
  linarith

/-- **The archimedean kernel**: `Ψ(t) = −log π + Re ψ(1/4 + i t/2)`, as a
complex-valued function before taking real parts. -/
def Psi (t : ℝ) : ℂ := Complex.digamma (digammaLine t)

/-- The defining equation of `Psi`. -/
theorem Psi_def (t : ℝ) : Psi t = Complex.digamma (digammaLine t) := rfl

/-- **The real archimedean factor `Ψ` of the explicit formula.** -/
noncomputable def PsiBar (t : ℝ) : ℝ := -Real.log Real.pi + (Psi t).re

/-- The defining equation of `PsiBar`, for rewriting. -/
theorem PsiBar_def (t : ℝ) : PsiBar t = -Real.log Real.pi + (Psi t).re := rfl

/-- **The archimedean term** `(1/2π) ∫_ℝ φ(t) Ψ(t) dt` of the Weil explicit
formula, for a transform `φ` (the Fourier transform of the test function `g`).
The integral is the Lebesgue integral over `ℝ`; for a Gaussian-type `φ` it
converges, and the file records the continuity of the integrand below. -/
noncomputable def archimedeanTerm (φ : ℝ → ℝ) : ℝ :=
  (1 / (2 * Real.pi)) * ∫ t : ℝ, φ t * PsiBar t

/-- The defining equation of `archimedeanTerm`, for rewriting. -/
theorem archimedeanTerm_def (φ : ℝ → ℝ) :
    archimedeanTerm φ = (1 / (2 * Real.pi)) * ∫ t : ℝ, φ t * PsiBar t := rfl

/-! ## 2. `Γ` and `ψ` are analytic on `Re z > 0`, hence along the line -/

/-- **`Γ` is analytic on `Re z > 0`.**  This is the integral-representation half
space; on it Mathlib gives `Complex.hasDerivAt_Gamma_of_re_pos`, and the region is
open, so `Complex.analyticAt_iff_eventually_differentiableAt` applies. -/
theorem analyticAt_Gamma_of_re_pos {s : ℂ} (hs : 0 < s.re) : AnalyticAt ℂ Complex.Gamma s := by
  rw [Complex.analyticAt_iff_eventually_differentiableAt]
  filter_upwards [(Complex.isOpen_re_gt 0).mem_nhds hs] with z hz
  exact (Complex.hasDerivAt_Gamma_of_re_pos hz).differentiableAt

/-- **`ψ` is analytic at every point of the line.**  `ψ` is the logarithmic
derivative `Γ'/Γ`, and `Γ` does not vanish on `Re z > 0`. -/
theorem analyticAt_digamma_line (t : ℝ) : AnalyticAt ℂ Complex.digamma (digammaLine t) := by
  have hs : 0 < (digammaLine t).re := by rw [digammaLine_re]; norm_num
  have hΓ : AnalyticAt ℂ Complex.Gamma (digammaLine t) := analyticAt_Gamma_of_re_pos hs
  have hquot : AnalyticAt ℂ (fun z => deriv Complex.Gamma z / Complex.Gamma z) (digammaLine t) :=
    hΓ.deriv.div hΓ (Complex.Gamma_ne_zero_of_re_pos hs)
  have hfun : Complex.digamma = fun z => deriv Complex.Gamma z / Complex.Gamma z := by
    funext z
    rw [Complex.digamma_def, logDeriv_apply]
  rwa [hfun]

/-- Analyticity of the affine parametrisation of the line. -/
theorem analyticAt_digammaLine (t : ℝ) :
    AnalyticAt ℝ (fun u : ℝ => (u : ℂ) * (Complex.I / 2) + 1 / 4) t :=
  ((Complex.ofRealCLM.analyticAt t).mul analyticAt_const).add analyticAt_const

/-- The line is continuous. -/
theorem continuous_digammaLine : Continuous digammaLine := by
  have h : Continuous fun t : ℝ => (t : ℂ) * (Complex.I / 2) + 1 / 4 :=
    (Complex.continuous_ofReal.mul_const _).add_const _
  exact h

/-- **`ψ` is differentiable at every point of the line.** -/
theorem differentiableAt_digamma_line (t : ℝ) :
    DifferentiableAt ℂ Complex.digamma (digammaLine t) :=
  (analyticAt_digamma_line t).differentiableAt

/-- `ψ ∘ line` is continuous at each `t`; the line avoids the poles of `Γ`. -/
theorem continuousAt_Psi (t : ℝ) : ContinuousAt Psi t :=
  ContinuousAt.comp (analyticAt_digamma_line t).continuousAt continuous_digammaLine.continuousAt

/-- **The archimedean kernel `t ↦ ψ(1/4 + i t/2)` is continuous on `ℝ`.**  This is
the analytic input the archimedean integral needs. -/
theorem continuous_Psi : Continuous Psi := continuous_iff_continuousAt.mpr continuousAt_Psi

/-- **Continuity of the real archimedean factor `Ψ`.** -/
theorem continuous_PsiBar : Continuous PsiBar := by
  have h : Continuous fun t : ℝ => -Real.log Real.pi + (Psi t).re :=
    continuous_const.add (Complex.continuous_re.comp continuous_Psi)
  exact h

/-- **Measurability of `Ψ`**, so that `∫ φ · Ψ` is a bona fide integral. -/
theorem measurable_PsiBar : Measurable PsiBar := continuous_PsiBar.measurable

/-! ## 3. The digamma structure Mathlib provides, on the line -/

/-- **The recurrence for `ψ` along the line**, in the real direction:
`ψ(1/4 + i t/2 + n) = ψ(1/4 + i t/2) + Σ_{k<n} (1/4 + i t/2 + k)⁻¹`.  This is
Mathlib's `Complex.digamma_apply_add_nat`, with the non-pole condition discharged
by `digammaLine_ne_neg_nat`. -/
theorem digammaLine_add_nat (t : ℝ) (n : ℕ) :
    Complex.digamma (digammaLine t + n) =
      Complex.digamma (digammaLine t) + ∑ k ∈ Finset.range n, (digammaLine t + k)⁻¹ :=
  Complex.digamma_apply_add_nat (fun m => digammaLine_ne_neg_nat t m) n

/-- The point `1 - digammaLine t = 3/4 - i t/2` is never an integer: its
imaginary part is `-t/2` and its real part is `3/4`. -/
theorem one_sub_digammaLine_ne_int (t : ℝ) (n : ℤ) : 1 - digammaLine t ≠ (n : ℂ) := by
  intro h
  have him : (1 - digammaLine t).im = ((n : ℂ)).im := congrArg Complex.im h
  have hlt : (1 - digammaLine t : ℂ).im = -(t / 2) := by
    rw [digammaLine_eq]
    simp
  rw [hlt] at him
  simp at him
  have hre : (1 - digammaLine t).re = ((n : ℂ)).re := congrArg Complex.re h
  have hrt : (1 - digammaLine t : ℂ).re = 3 / 4 := by
    rw [digammaLine_eq]
    simp
    norm_num
  rw [hrt] at hre
  simp at hre
  have hmul : (n : ℝ) * 4 = 3 := by linarith
  have hmulZ : n * 4 = 3 := by exact_mod_cast hmul
  omega

/-- **Euler's reflection formula for `ψ` on the line.**  With `z = 1/4 + i t/2`,
`1 - z = 3/4 - i t/2`, so
`ψ(z) = ψ(3/4 - i t/2) + π cot(π(3/4 - i t/2))`.  This relates the archimedean
factor to the reflected digamma; it is Mathlib's `Complex.digamma_one_sub`. -/
theorem digammaLine_reflection (t : ℝ) :
    Complex.digamma (digammaLine t) =
      Complex.digamma (1 - digammaLine t) + (Real.pi : ℂ) * Complex.cot (Real.pi * (1 - digammaLine t)) := by
  have h := Complex.digamma_one_sub (s := 1 - digammaLine t) (one_sub_digammaLine_ne_int t)
  simpa using h

/-- The value of `ψ` at `1/2` is known to Mathlib
(`Complex.digamma_one_half`): `ψ(1/2) = −2 log 2 − γ`. -/
theorem Psi_via_digamma_one_half :
    Complex.digamma (1 / 2) = -2 * Complex.log 2 - (Real.eulerMascheroniConstant : ℂ) :=
  Complex.digamma_one_half

/-! ## 4. The chain rule and the `2^{−k}` of the derivative budget -/

/-- The affine line has derivative `i/2`. -/
theorem hasDerivAt_digammaLine (t : ℝ) : HasDerivAt digammaLine (Complex.I / 2) t := by
  have h1 : HasDerivAt (fun u : ℝ => (u : ℂ)) 1 t := Complex.ofRealCLM.hasDerivAt (x := t)
  have h2 : HasDerivAt (fun u : ℝ => (u : ℂ) * (Complex.I / 2) + 1 / 4)
      (1 * (Complex.I / 2)) t := (h1.mul_const _).add_const _
  have h3 : (1 * (Complex.I / 2)) = (Complex.I / 2) := by ring
  rw [h3] at h2
  exact h2

/-- The derivative of the line, in `deriv` form. -/
theorem deriv_digammaLine (t : ℝ) : deriv digammaLine t = Complex.I / 2 :=
  (hasDerivAt_digammaLine t).deriv

/-- **The chain rule for the archimedean kernel.**
`(d/dt)^k Ψ(t) = (i/2)^k · ψ^{(k)}(1/4 + i t/2)`.

This identity is where the factor `2^{−k}` of the round's derivative bound comes
from: `‖(i/2)^k‖ = 2^{−k}`.  The proof is by induction on `k`, the induction step
being the usual chain rule for the affine substitution `t ↦ t·(i/2) + 1/4`; the
required differentiability of `ψ^{(k)}` on the line is `AnalyticAt.iterated_deriv`
applied to `analyticAt_digamma_line`. -/
theorem iteratedDeriv_Psi_eq (k : ℕ) (t : ℝ) :
    iteratedDeriv k Psi t = (Complex.I / 2) ^ k * iteratedDeriv k Complex.digamma (digammaLine t) := by
  induction k generalizing t with
  | zero => simp [Psi]
  | succ k ih =>
    have hfun : iteratedDeriv k Psi =
        fun t => (Complex.I / 2) ^ k * iteratedDeriv k Complex.digamma (digammaLine t) :=
      funext ih
    have hF : DifferentiableAt ℂ (iteratedDeriv k Complex.digamma) (digammaLine t) := by
      have h := (analyticAt_digamma_line t).iterated_deriv k
      rw [← iteratedDeriv_eq_iterate] at h
      exact h.differentiableAt
    have hline : DifferentiableAt ℝ digammaLine t := (hasDerivAt_digammaLine t).differentiableAt
    have hcomp : deriv (fun y : ℝ => iteratedDeriv k Complex.digamma (digammaLine y)) t
        = deriv (iteratedDeriv k Complex.digamma) (digammaLine t) * deriv digammaLine t :=
      deriv_comp (𝕜 := ℝ) (𝕜' := ℂ) t hF hline
    rw [iteratedDeriv_succ, hfun,
      deriv_const_mul (d := fun y : ℝ => iteratedDeriv k Complex.digamma (digammaLine y)) _
        ((hF.restrictScalars ℝ).comp t hline), hcomp,
      deriv_digammaLine, ← iteratedDeriv_succ]
    ring

/-- `‖i/2‖ = 1/2`. -/
theorem norm_half_I : ‖(Complex.I / 2 : ℂ)‖ = ((1 : ℝ) / 2) := by
  rw [Complex.norm_div, Complex.norm_I, Complex.norm_ofNat]

/-- `(1/2)^k = 2^{−k}`. -/
theorem half_pow_eq_two_zpow_neg (k : ℕ) : ((1 : ℝ) / 2) ^ k = (2 : ℝ) ^ (-(k : ℤ)) := by
  rw [zpow_neg, zpow_natCast, div_pow, one_pow, one_div]

/-- **The `2^{−k}` reduction.**  Bounding the `k`-th derivative of `ψ` on the line
by `k! · S` bounds the `k`-th derivative of the archimedean kernel by
`2^{−k} · k! · S`. -/
theorem norm_iteratedDeriv_Psi_le (k : ℕ) {S : ℝ} (t : ℝ)
    (h : ‖iteratedDeriv k Complex.digamma (digammaLine t)‖ ≤ (k.factorial : ℝ) * S) :
    ‖iteratedDeriv k Psi t‖ ≤ (2 : ℝ) ^ (-(k : ℤ)) * ((k.factorial : ℝ) * S) := by
  rw [iteratedDeriv_Psi_eq, norm_mul, norm_pow, norm_half_I, half_pow_eq_two_zpow_neg]
  exact mul_le_mul_of_nonneg_left h (zpow_nonneg (by norm_num) _)

/-- The **Hurwitz-zeta budget** of the round: `2^{−k} k! Σ_{j≥0} (1/4+j)^{−k−1}`.
The series is the value of `(−1)^{k+1}ψ^{(k)}(1/4)/k!` for `k ≥ 1`; the series
identity is *proved* in `Rh45/PolygammaSeries.lean`
(`Rh45RouteBAnalytic.digamma_polygamma_series`), and for `k ≥ 1` the whole budget
is unconditional (`Rh45.archimedean_deriv_bound`).  For `k = 0` the series
diverges, so `psiSeriesBound 0 = 0` (`Rh45.psiSeriesBound_zero`). -/
noncomputable def psiSeriesBound (k : ℕ) : ℝ :=
  (2 : ℝ) ^ (-(k : ℤ)) * ((k.factorial : ℝ) * ∑' j : ℕ, ((1 / 4 + (j : ℝ)) ^ (k + 1))⁻¹)

/-- The defining equation of `psiSeriesBound`, for rewriting. -/
theorem psiSeriesBound_def (k : ℕ) :
    psiSeriesBound k =
      (2 : ℝ) ^ (-(k : ℤ)) * ((k.factorial : ℝ) * ∑' j : ℕ, ((1 / 4 + (j : ℝ)) ^ (k + 1))⁻¹) :=
  rfl

/-- **The round's derivative bound for the archimedean kernel, conditional on the
digamma series.**  The hypothesis

`‖ψ^{(k)}(1/4 + i t/2)‖ ≤ k! · Σ_j (1/4+j)^{−k−1}`

is *exactly* the Euler–Maclaurin / Hurwitz-zeta estimate for the `k`-th derivative
of `ψ`, i.e. `ψ^{(k)}(z) = (−1)^{k+1} k! Σ_{j≥0} (z+j)^{−k−1}` evaluated at
`z = 1/4 + i t/2` and bounded by the real-axis value.  Mathlib has no such
series, but it is **now proved** for `k ≥ 1` in `Rh45/PolygammaSeries.lean`
(`Rh45RouteBAnalytic.digamma_polygamma_series`, from the locally uniform Euler
product limit of `Rh45/GammaProduct.lean` and the explicit iterated derivative
`Rh45RouteBAnalytic.iteratedDeriv_logDeriv_GammaSeq`), so the hypothesis of this
theorem is discharged for `k ≥ 1` by `Rh45.digamma_series_bound`; the
unconditional form is `Rh45.archimedean_deriv_bound`.  This conditional theorem is
kept for compatibility.

The theorem below proves the *reduction* from the estimate to the round's bound,
the whole `2^{−k}` factor being the chain rule `iteratedDeriv_Psi_eq`.

For `k = 0` the series `Σ_j (1/4+j)^{−1}` diverges, so the `k = 0` instance
carries no information (`psiSeriesBound 0 = 0`); the meaningful instances are
`k ≥ 1`. -/
theorem archimedean_deriv_bound_of_digamma_series (k : ℕ) (t : ℝ)
    (h : ‖iteratedDeriv k Complex.digamma (digammaLine t)‖ ≤
        (k.factorial : ℝ) * ∑' j : ℕ, ((1 / 4 + (j : ℝ)) ^ (k + 1))⁻¹) :
    ‖iteratedDeriv k Psi t‖ ≤ psiSeriesBound k := by
  rw [psiSeriesBound_def]
  exact norm_iteratedDeriv_Psi_le k t h

/-! ## 5. The product rule for the fourth derivative

The assembly of the round multiplies the transform `φ` and the archimedean factor
`Ψ`; the Simpson budget needs `|(φΨ)^{(4)}|`, whence the binomial sum
`Σ_k binom(4,k) M_k P_{4−k}`.  Everything in this section is unconditional. -/

/-- **The Leibniz rule, with budgets.**  If the `k`-th derivatives of `φ` and `Ψ`
at `x` are bounded by `M k` and `P k` for `k ≤ n`, then the `n`-th derivative of
the product is bounded by `Σ_{k≤n} binom(n,k) M k P (n−k)`.

This is `iteratedDeriv_mul` (the binomial expansion of the product rule) followed
by the triangle inequality, term by term. -/
theorem abs_iteratedDeriv_mul_le {φ Ψ : ℝ → ℝ} {M P : ℕ → ℝ} {x : ℝ} {n : ℕ}
    (hφ : ContDiffAt ℝ n φ x) (hΨ : ContDiffAt ℝ n Ψ x)
    (hM : ∀ k, k ≤ n → |iteratedDeriv k φ x| ≤ M k)
    (hP : ∀ k, k ≤ n → |iteratedDeriv k Ψ x| ≤ P k) :
    |iteratedDeriv n (fun y => φ y * Ψ y) x| ≤
      ∑ k ∈ Finset.range (n + 1), (n.choose k : ℝ) * M k * P (n - k) := by
  rw [show (fun y => φ y * Ψ y) = φ * Ψ from rfl, iteratedDeriv_mul hφ hΨ]
  refine le_trans (Finset.abs_sum_le_sum_abs _ _) (Finset.sum_le_sum ?_)
  intro k hk
  have hkn : k ≤ n := by
    have := Finset.mem_range.mp hk
    omega
  have hMk : 0 ≤ M k := le_trans (abs_nonneg _) (hM k hkn)
  have hPk : 0 ≤ P (n - k) := le_trans (abs_nonneg _) (hP (n - k) (Nat.sub_le n k))
  have hchoose : (0 : ℝ) ≤ (n.choose k : ℝ) := Nat.cast_nonneg _
  calc |(n.choose k : ℝ) * iteratedDeriv k φ x * iteratedDeriv (n - k) Ψ x|
      = (n.choose k : ℝ) * |iteratedDeriv k φ x| * |iteratedDeriv (n - k) Ψ x| := by
        rw [abs_mul, abs_mul, abs_of_nonneg hchoose]
    _ ≤ (n.choose k : ℝ) * M k * P (n - k) :=
        mul_le_mul (mul_le_mul_of_nonneg_left (hM k hkn) hchoose) (hP (n - k) (Nat.sub_le n k))
          (abs_nonneg _) (mul_nonneg hchoose hMk)

/-- **The `Σ_k binom(4,k) M_k P_{4−k}` budget** of the round: the fourth
derivative of the product, in the explicit binomial form
`M₀P₄ + 4M₁P₃ + 6M₂P₂ + 4M₃P₁ + M₄P₀`. -/
theorem abs_iteratedDeriv_four_mul_le {φ Ψ : ℝ → ℝ} {M P : ℕ → ℝ} {x : ℝ}
    (hφ : ContDiffAt ℝ 4 φ x) (hΨ : ContDiffAt ℝ 4 Ψ x)
    (hM : ∀ k, k ≤ 4 → |iteratedDeriv k φ x| ≤ M k)
    (hP : ∀ k, k ≤ 4 → |iteratedDeriv k Ψ x| ≤ P k) :
    |iteratedDeriv 4 (fun y => φ y * Ψ y) x| ≤
      M 0 * P 4 + 4 * M 1 * P 3 + 6 * M 2 * P 2 + 4 * M 3 * P 1 + M 4 * P 0 := by
  refine le_trans (abs_iteratedDeriv_mul_le hφ hΨ hM hP) ?_
  rw [show (∑ k ∈ Finset.range (4 + 1), ((4 : ℕ).choose k : ℝ) * M k * P (4 - k)) =
      M 0 * P 4 + 4 * M 1 * P 3 + 6 * M 2 * P 2 + 4 * M 3 * P 1 + M 4 * P 0 by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add]
    norm_num [Nat.choose]]

/-! ## 6. Composite Simpson and the archimedean assembly

The round evaluates `(1/2π)∫φΨ` by composite Simpson with panels of half-width `h`
and uses the classical error bound `|err| ≤ (b−a)h⁴/180 · sup|f^{(4)}|`.  The
single-panel input is no longer a hypothesis: `Rh45/SimpsonPanel.lean` defines
`simpsonPanel`/`simpsonSum`/`SimpsonPanelEstimate` and proves
`simpsonPanelEstimate`.  The theorems below prove the composite assembly from it,
which is exactly the reduction the round performs. -/

/- `simpsonPanel`, `simpsonSum` and `SimpsonPanelEstimate` now live in
`Rh45/SimpsonPanel.lean`, where the single-panel estimate is *proved* as
`Rh45.simpsonPanelEstimate` (for `0 ≤ H`; see the module docstring there and
`SIMPSON.md` for the two defects of the original statement that are repaired). -/

/-- **The composite integral is the sum of the panel integrals.** -/
theorem integral_eq_sum_panels (F : ℝ → ℝ) (hF : Continuous F) (a H : ℝ) (m : ℕ) :
    ∫ x in a..(a + 2 * (m : ℝ) * H), F x =
      ∑ i ∈ Finset.range m,
        ∫ x in (a + 2 * (i : ℝ) * H)..(a + 2 * ((i : ℝ) + 1) * H), F x := by
  induction m with
  | zero => simp [intervalIntegral.integral_same]
  | succ m ih =>
    rw [Finset.sum_range_succ, ← ih]
    have hup : a + 2 * ((m + 1 : ℕ) : ℝ) * H = a + 2 * (m : ℝ) * H + 2 * H := by
      push_cast; ring
    rw [hup, ← intervalIntegral.integral_add_adjacent_intervals
      (hF.intervalIntegrable _ _) (hF.intervalIntegrable _ _)]
    congr 2
    ring

/-- **Composite Simpson error assembly.**  If every panel obeys the single-panel
estimate with a common bound `B ≥ 0`, then the error of the composite rule on
`[a, a+2mH]` is at most `(b−a) H⁴/180 · B`.  The constant is the sharp one: each
panel contributes `(2H)⁵/2880 · B`, and `m · (2H)⁵/2880 = (2mH)·H⁴/180`. -/
theorem simpsonSum_sub_integral_le (F : ℝ → ℝ) (a H B : ℝ) (m : ℕ)
    (hF : Continuous F)
    (hpanel : ∀ i ∈ Finset.range m,
      |simpsonPanel F (a + 2 * (i : ℝ) * H) H -
          ∫ x in (a + 2 * (i : ℝ) * H)..(a + 2 * ((i : ℝ) + 1) * H), F x|
        ≤ (2 * H) ^ 5 / 2880 * B) :
    |simpsonSum F a H m - ∫ x in a..(a + 2 * (m : ℝ) * H), F x|
      ≤ (a + 2 * (m : ℝ) * H - a) * H ^ 4 / 180 * B := by
  rw [simpsonSum_def, integral_eq_sum_panels F hF a H m, ← Finset.sum_sub_distrib]
  refine le_trans (Finset.abs_sum_le_sum_abs _ _) ?_
  calc ∑ i ∈ Finset.range m,
        |simpsonPanel F (a + 2 * (i : ℝ) * H) H -
          ∫ x in (a + 2 * (i : ℝ) * H)..(a + 2 * ((i : ℝ) + 1) * H), F x|
      ≤ ∑ _i ∈ Finset.range m, (2 * H) ^ 5 / 2880 * B := Finset.sum_le_sum hpanel
    _ = (a + 2 * (m : ℝ) * H - a) * H ^ 4 / 180 * B := by
        rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
        ring

/-- **The archimedean Simpson budget of Route C.**  Let `φ` be the transform and
`Ψ` the archimedean factor, with derivative budgets `|φ^{(k)}| ≤ M k` and
`|Ψ^{(k)}| ≤ P k` for `k ≤ 4` on `[a, a+2mH]`.  Then composite Simpson with `m`
panels of half-width `H` evaluates
`∫_a^b φΨ` with error at most

`(b − a) · H⁴/180 · (M₀P₄ + 4M₁P₃ + 6M₂P₂ + 4M₃P₁ + M₄P₀)`,

`b = a + 2mH` — the composite-Simpson error bound of the round with the
binomial product budget.  Unconditional: the single-panel input is supplied by
`simpsonPanelEstimate`. -/
theorem simpsonSum_mul_error_le (φ Ψ : ℝ → ℝ) (M P : ℕ → ℝ) (a H : ℝ) (m : ℕ)
    (hH : 0 ≤ H) (hMnn : ∀ k, 0 ≤ M k) (hPnn : ∀ k, 0 ≤ P k)
    (hcont : Continuous fun x => φ x * Ψ x)
    (hφc : ∀ x ∈ Set.Icc a (a + 2 * (m : ℝ) * H), ContDiffAt ℝ 4 φ x)
    (hΨc : ∀ x ∈ Set.Icc a (a + 2 * (m : ℝ) * H), ContDiffAt ℝ 4 Ψ x)
    (hM : ∀ k, k ≤ 4 → ∀ x ∈ Set.Icc a (a + 2 * (m : ℝ) * H),
      |iteratedDeriv k φ x| ≤ M k)
    (hP : ∀ k, k ≤ 4 → ∀ x ∈ Set.Icc a (a + 2 * (m : ℝ) * H),
      |iteratedDeriv k Ψ x| ≤ P k) :
    |simpsonSum (fun x => φ x * Ψ x) a H m
        - ∫ x in a..(a + 2 * (m : ℝ) * H), φ x * Ψ x|
      ≤ (a + 2 * (m : ℝ) * H - a) * H ^ 4 / 180 *
          (M 0 * P 4 + 4 * M 1 * P 3 + 6 * M 2 * P 2 + 4 * M 3 * P 1 + M 4 * P 0) := by
  have hB : 0 ≤ M 0 * P 4 + 4 * M 1 * P 3 + 6 * M 2 * P 2 + 4 * M 3 * P 1 + M 4 * P 0 := by
    have := hMnn 0; have := hPnn 4; have := hMnn 1; have := hPnn 3
    have := hMnn 2; have := hPnn 2; have := hMnn 3; have := hPnn 1
    have := hMnn 4; have := hPnn 0
    positivity
  refine simpsonSum_sub_integral_le _ a H _ m hcont ?_
  intro i hi
  have hi' : i < m := Finset.mem_range.mp hi
  have hup : a + 2 * (i : ℝ) * H + 2 * H = a + 2 * ((i : ℝ) + 1) * H := by ring
  rw [← hup]
  have hmem : ∀ x ∈ Set.Icc (a + 2 * (i : ℝ) * H) (a + 2 * (i : ℝ) * H + 2 * H),
      x ∈ Set.Icc a (a + 2 * (m : ℝ) * H) := by
    intro x hx
    constructor
    · have : a ≤ a + 2 * (i : ℝ) * H := by
        have : 0 ≤ 2 * (i : ℝ) * H := by positivity
        linarith
      linarith [hx.1]
    · have hiR : ((i : ℝ) + 1) ≤ (m : ℝ) := by exact_mod_cast hi'
      have : a + 2 * (i : ℝ) * H + 2 * H ≤ a + 2 * (m : ℝ) * H := by nlinarith
      linarith [hx.2]
  have hcd : ContDiffOn ℝ 4 (fun x => φ x * Ψ x)
      (Set.Icc (a + 2 * (i : ℝ) * H) (a + 2 * (i : ℝ) * H + 2 * H)) := by
    intro x hx
    exact ((hφc x (hmem x hx)).contDiffWithinAt).mul
      ((hΨc x (hmem x hx)).contDiffWithinAt)
  refine simpsonPanelEstimate H hH (fun x => φ x * Ψ x) (a + 2 * (i : ℝ) * H) _ hB
    hcd ?_
  intro x hx
  exact abs_iteratedDeriv_four_mul_le (hφc x (hmem x hx)) (hΨc x (hmem x hx))
    (fun k hk => hM k hk x (hmem x hx)) (fun k hk => hP k hk x (hmem x hx))

end

end Rh45
