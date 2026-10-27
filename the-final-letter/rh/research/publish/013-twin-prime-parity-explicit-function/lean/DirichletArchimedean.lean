/-
  DirichletArchimedean.lean — the **archimedean tail bound, proved**, for the
  Dirichlet explicit formula.

  `DirichletExplicit.lean` defines the archimedean kernel
  `dirichletPsi q a t = log(q/π) + Re ψ((1+2a)/4 + i t/2)` (with `a` the parity),
  but leaves its analytic bounds numeric.  This file proves them, by adapting the
  ζ chain-rule argument of `Rh45/Archimedean.lean` to the general parity line and
  reusing the digamma-series norm bound of `Rh45/PolygammaSeries.lean`:

    * `analyticAt_digamma_dirichletLine` — `ψ` is analytic on the line;
    * `iteratedDeriv_dirichletPsiC_eq` — the chain rule
      `(d/dt)^k ψ(w(t)) = (i/2)^k ψ^{(k)}(w(t))` for `w(t) = (1+2a)/4 + i t/2`;
    * `dirichlet_digamma_series_bound` — `‖ψ^{(k)}(w)‖ ≤ k! ∑_j (Re w + j)^{-k-1}`
      (`k ≥ 1`), from `Rh45RouteBAnalytic.norm_deriv_digamma_le`;
    * `dirichletPsiSeriesBound` and `dirichletPsi_deriv_bound` — the unconditional
      budget `‖(Ψ_χ)^{(k)}(t)‖ ≤ 2^{-k} k! ∑_j ((1+2a)/4 + j)^{-k-1}`, the exact
      expression the numerical assembly `011/rigorous/dirichlet_explicit.py` uses in
      its fourth-derivative Simpson bound.

  No `sorry`, no extra axiom.
-/
import DirichletExplicit
import Rh45.Archimedean
import Rh45.PolygammaSeries

namespace RouteABC

noncomputable section

open scoped BigOperators

/-- The complex archimedean kernel `ψ(w(t))`, `w(t) = (1+2a)/4 + i t/2`. -/
def dirichletPsiC (a t : ℝ) : ℂ := Complex.digamma (dirichletDigammaLine a t)

theorem dirichletPsiC_def (a t : ℝ) :
    dirichletPsiC a t = Complex.digamma (dirichletDigammaLine a t) := rfl

/-- `Re ((1+2a)/4 + i t/2) = (1+2a)/4`, positive for `a ≥ 0`. -/
theorem dirichletDigammaLine_re_eq (a t : ℝ) :
    (dirichletDigammaLine a t).re = (1 + 2 * a) / 4 :=
  dirichletDigammaLine_re a t

/-- **`ψ` is analytic at every point of the parity line.**  Same argument as
`Rh45.analyticAt_digamma_line`, with `Re z = (1+2a)/4 > 0`. -/
theorem analyticAt_digamma_dirichletLine (a t : ℝ) (ha : 0 ≤ a) :
    AnalyticAt ℂ Complex.digamma (dirichletDigammaLine a t) := by
  have hs : 0 < (dirichletDigammaLine a t).re := by
    rw [dirichletDigammaLine_re_eq]; nlinarith
  have hΓ : AnalyticAt ℂ Complex.Gamma (dirichletDigammaLine a t) :=
    Rh45.analyticAt_Gamma_of_re_pos hs
  have hquot : AnalyticAt ℂ (fun z => deriv Complex.Gamma z / Complex.Gamma z)
      (dirichletDigammaLine a t) :=
    hΓ.deriv.div hΓ (Complex.Gamma_ne_zero_of_re_pos hs)
  have hfun : Complex.digamma = fun z => deriv Complex.Gamma z / Complex.Gamma z := by
    funext z
    rw [Complex.digamma_def, logDeriv_apply]
  rw [hfun]
  exact hquot

/-- The parity line has derivative `i/2`. -/
theorem hasDerivAt_dirichletDigammaLine (a t : ℝ) :
    HasDerivAt (dirichletDigammaLine a) (Complex.I / 2) t := by
  have h1 : HasDerivAt (fun u : ℝ => (u : ℂ)) 1 t := Complex.ofRealCLM.hasDerivAt (x := t)
  have h2 : HasDerivAt (fun u : ℝ => (u : ℂ) * (Complex.I / 2) + (1 + 2 * a) / 4)
      (1 * (Complex.I / 2)) t := (h1.mul_const _).add_const _
  have h3 : (1 * (Complex.I / 2)) = (Complex.I / 2) := by ring
  rw [h3] at h2
  exact h2

/-- The derivative of the parity line. -/
theorem deriv_dirichletDigammaLine (a t : ℝ) :
    deriv (dirichletDigammaLine a) t = Complex.I / 2 :=
  (hasDerivAt_dirichletDigammaLine a t).deriv

/-- **The chain rule for the Dirichlet archimedean kernel.**
`(d/dt)^k ψ(w(t)) = (i/2)^k ψ^{(k)}(w(t))`. -/
theorem iteratedDeriv_dirichletPsiC_eq (k : ℕ) (a t : ℝ) (ha : 0 ≤ a) :
    iteratedDeriv k (dirichletPsiC a) t
      = (Complex.I / 2) ^ k
        * iteratedDeriv k Complex.digamma (dirichletDigammaLine a t) := by
  induction k generalizing t with
  | zero => simp [dirichletPsiC]
  | succ k ih =>
    have hfun : iteratedDeriv k (dirichletPsiC a) =
        fun t => (Complex.I / 2) ^ k
          * iteratedDeriv k Complex.digamma (dirichletDigammaLine a t) :=
      funext ih
    have hF : DifferentiableAt ℂ (iteratedDeriv k Complex.digamma)
        (dirichletDigammaLine a t) := by
      have h := (analyticAt_digamma_dirichletLine a t ha).iterated_deriv k
      rw [← iteratedDeriv_eq_iterate] at h
      exact h.differentiableAt
    have hline : DifferentiableAt ℝ (dirichletDigammaLine a) t :=
      (hasDerivAt_dirichletDigammaLine a t).differentiableAt
    have hcomp : deriv
          (fun y : ℝ => iteratedDeriv k Complex.digamma (dirichletDigammaLine a y)) t
        = deriv (iteratedDeriv k Complex.digamma) (dirichletDigammaLine a t)
          * deriv (dirichletDigammaLine a) t :=
      deriv_comp (𝕜 := ℝ) (𝕜' := ℂ) t hF hline
    rw [iteratedDeriv_succ, hfun,
      deriv_const_mul (d := fun y : ℝ =>
        iteratedDeriv k Complex.digamma (dirichletDigammaLine a y)) _
        ((hF.restrictScalars ℝ).comp t hline), hcomp,
      deriv_dirichletDigammaLine, ← iteratedDeriv_succ]
    ring

/-- **The digamma-series norm bound on the parity line**, `k ≥ 1`:
`‖ψ^{(k)}(w)‖ ≤ k! ∑_j (Re w + j)^{-k-1}`.  Directly
`Rh45RouteBAnalytic.norm_deriv_digamma_le`. -/
theorem dirichlet_digamma_series_bound (k : ℕ) (hk : 1 ≤ k) (a t : ℝ) (ha : 0 ≤ a) :
    ‖iteratedDeriv k Complex.digamma (dirichletDigammaLine a t)‖
      ≤ (k.factorial : ℝ)
        * ∑' j : ℕ, (((1 + 2 * a) / 4 + (j : ℝ)) ^ (k + 1))⁻¹ := by
  have hs : 0 < (dirichletDigammaLine a t).re := by
    rw [dirichletDigammaLine_re_eq]; nlinarith
  have h := Rh45RouteBAnalytic.norm_deriv_digamma_le k hk hs
  rw [dirichletDigammaLine_re_eq] at h
  simpa only [Complex.digamma_def, iteratedDeriv_eq_iterate] using h

/-- The **Dirichlet derivative budget**: `2^{-k} k! ∑_j ((1+2a)/4 + j)^{-k-1}`. -/
noncomputable def dirichletPsiSeriesBound (a : ℝ) (k : ℕ) : ℝ :=
  (2 : ℝ) ^ (-(k : ℤ))
    * ((k.factorial : ℝ) * ∑' j : ℕ, (((1 + 2 * a) / 4 + (j : ℝ)) ^ (k + 1))⁻¹)

/-- **The unconditional derivative bound for the Dirichlet archimedean kernel.**
For `k ≥ 1` and parity `a ≥ 0`,

    ‖(Ψ_χ)^{(k)}(t)‖ ≤ 2^{-k} k! ∑_j ((1+2a)/4 + j)^{-k-1}  =  dirichletPsiSeriesBound a k.

For `a = 0` this is exactly `Rh45.psiSeriesBound`; for `a = 1` it is the analogue
used by the numerical Δ⁴ Simpson bound on `Ψ_χ` in
`011/rigorous/dirichlet_explicit.py`. -/
theorem dirichletPsi_deriv_bound (k : ℕ) (hk : 1 ≤ k) (a t : ℝ) (ha : 0 ≤ a) :
    ‖iteratedDeriv k (dirichletPsiC a) t‖ ≤ dirichletPsiSeriesBound a k := by
  rw [iteratedDeriv_dirichletPsiC_eq k a t ha, norm_mul, norm_pow, Rh45.norm_half_I,
    Rh45.half_pow_eq_two_zpow_neg, dirichletPsiSeriesBound]
  exact mul_le_mul_of_nonneg_left (dirichlet_digamma_series_bound k hk a t ha)
    (zpow_nonneg (by norm_num) _)

end

end RouteABC
