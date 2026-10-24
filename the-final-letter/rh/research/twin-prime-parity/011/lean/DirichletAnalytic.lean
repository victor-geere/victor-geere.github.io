/-
  DirichletAnalytic.lean — the *analytic* hypotheses of the Dirichlet Route B theorem.

  `DirichletRouteB.routeB_for_dirichletL_unconditional` concludes Route B for the normalised
  completed L-function `h = dirichletCompleted χ` from three groups of hypotheses:

  * the arithmetic ones (`IsPrimitive χ`, `χ⁻¹ = χ`, `χ ≠ 1`, `χ.IsQuadratic`);
  * three *analytic* ones on the closed rectangle `[0,1] × [t₀,t₁]`:
    `han` (analyticity on the rectangle) and `hint₀`, `hint₁` (interval integrability of
    `logDeriv h` on the two horizontal edges);
  * the zero data (`hmem`, `hm`, `hno`).

  This file discharges all three analytic hypotheses, unconditionally, for every nontrivial
  Dirichlet character (no primitivity, no reality, no quadraticity is needed for them):

  * `analyticAt_dirichletCompleted` — `h` is entire, because `completedLFunction χ` is entire
    for `χ ≠ 1` (`differentiable_completedLFunction`) and `s ↦ N^(s/2)` is entire
    (`AnalyticAt.cpow` at the real base `N`, which lies in the slit plane since `N ≥ 1`);
  * `continuousOn_logDeriv_dirichletCompleted` — on the segment `x ↦ x + t·I` the log-derivative
    `logDeriv h = deriv h / h` is continuous wherever `h` does not vanish: `deriv h` is
    continuous (`ContDiff ℂ 1 h` from analyticity, `ContDiff.continuous_deriv_one`), `h` is
    continuous, and the denominator is nonzero on the segment by the hypothesis `hne`;
  * `intervalIntegrable_logDeriv_dirichletCompleted` — immediate from the previous item and
    `ContinuousOn.intervalIntegrable` on the compact interval `[0,1]`.

  The packaging theorem `routeB_for_dirichletL_of_zeros` then has **no** analytic hypothesis
  left: `hne₀` and `hne₁` (non-vanishing on the two horizontal edges) are themselves derived
  from the zero data, because `hmem` puts every `z ∈ Z` strictly between the two edges
  (`t₀ < z.im < t₁`), so a point of the edge `im = t₀` or `im = t₁` is never in `Z`, and `hno`
  applies.  What remains is exactly the (numerical) zero data `Z`, `m` and `hno`.

  There is no `sorry`, no `axiom`, no `admit`, no `native_decide` and no
  `set_option maxHeartbeats` in this file.
-/
import Generic
import DirichletRouteB
import Mathlib.NumberTheory.LSeries.DirichletContinuation

open MeasureTheory intervalIntegral
open scoped Topology ComplexConjugate
open DirichletCharacter
open Rh45RouteBAnalytic

namespace RouteABC

noncomputable section

variable {N : ℕ} [NeZero N]

/-! ## Lemma 1 — analyticity of `dirichletCompleted χ` on the rectangle -/

/-- **`dirichletCompleted χ` is entire for `χ ≠ 1`.**  It is the product of the entire factor
`s ↦ N^(s/2)` (`AnalyticAt.cpow`, at the base `N ≥ 1` which lies in the slit plane) with
Mathlib's entire `completedLFunction χ` (`differentiable_completedLFunction`). -/
theorem analyticAt_dirichletCompleted (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (s : ℂ) :
    AnalyticAt ℂ (dirichletCompleted χ) s := by
  rw [show dirichletCompleted χ
      = fun w : ℂ => (N : ℂ) ^ (w / 2) * completedLFunction χ w from rfl]
  apply AnalyticAt.mul
  · apply AnalyticAt.cpow analyticAt_const ((analyticAt_id (z := s)).div_const (c := (2 : ℂ)))
    left
    have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
    simpa [Complex.ofReal_re] using hNpos
  · exact (differentiable_completedLFunction hχ).analyticAt s

/-- **Box form of Lemma 1.**  `dirichletCompleted χ` is analytic at every point of the closed
rectangle `[0,1] ×ℂ [t₀,t₁]`; this is exactly the hypothesis `han` of
`routeB_for_dirichletL_unconditional`. -/
theorem analyticAt_dirichletCompleted_of_mem (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {t0 t1 : ℝ} {s : ℂ} (_hs : s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1)) :
    AnalyticAt ℂ (dirichletCompleted χ) s :=
  analyticAt_dirichletCompleted χ hχ s

/-- Consequence in `Differentiable` form: `dirichletCompleted χ` is entire for `χ ≠ 1`. -/
theorem differentiable_dirichletCompleted (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    Differentiable ℂ (dirichletCompleted χ) :=
  fun s => (analyticAt_dirichletCompleted χ hχ s).differentiableAt

/-! ## Lemma 2 — the log-derivative is continuous, hence interval integrable, on each edge -/

/-- **`logDeriv (dirichletCompleted χ)` is continuous on the horizontal segment
`x ↦ x + t·I`, `x ∈ [0,1]`, away from the zeros of `h`.**

Writing `logDeriv h = deriv h / h`, the numerator is continuous because `deriv h` is continuous
(`ContDiff.continuous_deriv_one`, from analyticity of `h`), the denominator is continuous by
entireness, and `hne` keeps the denominator away from `0`. -/
theorem continuousOn_logDeriv_dirichletCompleted (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    (t : ℝ) (hne : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      dirichletCompleted χ (x + t * Complex.I) ≠ 0) :
    ContinuousOn (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t * Complex.I))
      (Set.uIcc 0 1) := by
  have hdiff : Differentiable ℂ (dirichletCompleted χ) := differentiable_dirichletCompleted χ hχ
  have hderiv_cont : Continuous (deriv (dirichletCompleted χ)) := by
    have hcd : ContDiff ℂ 1 (dirichletCompleted χ) :=
      (Complex.analyticOn_univ_iff_differentiable.mpr hdiff).contDiff
    exact hcd.continuous_deriv_one
  have hγ : Continuous (fun x : ℝ => (x : ℂ) + t * Complex.I) := by fun_prop
  have h1 : ContinuousOn (fun x : ℝ => deriv (dirichletCompleted χ) (x + t * Complex.I))
      (Set.uIcc 0 1) :=
    (hderiv_cont.comp hγ).continuousOn
  have h2 : ContinuousOn (fun x : ℝ => dirichletCompleted χ (x + t * Complex.I))
      (Set.uIcc 0 1) :=
    (hdiff.continuous.comp hγ).continuousOn
  exact (h1.div h2 hne).congr (fun x _ => logDeriv_apply _ _)

/-- **The second analytic hypothesis.**  On the horizontal edge `im = t`, the logarithmic
derivative of `dirichletCompleted χ` is interval integrable over `x ∈ [0,1]`, provided `h` does
not vanish on the segment.  The content is continuity of the integrand on the compact interval
(`ContinuousOn.intervalIntegrable`); the non-vanishing hypothesis is genuinely needed because a
zero of `h` on the edge would produce a non-integrable pole of `logDeriv h`.

The hypothesis `ht : t ∈ Set.uIcc t0 t1` records that `t` is one of the two edge heights; it is
not used by the proof (which only sees the single segment `x ↦ x + t·I`). -/
theorem intervalIntegrable_logDeriv_dirichletCompleted (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {t0 t1 : ℝ} (t : ℝ) (_ht : t ∈ Set.uIcc t0 t1)
    (hne : ∀ x ∈ Set.uIcc (0 : ℝ) 1, dirichletCompleted χ (x + t * Complex.I) ≠ 0) :
    IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t * Complex.I))
      volume 0 1 :=
  (continuousOn_logDeriv_dirichletCompleted χ hχ t hne).intervalIntegrable

/-! ## Packaging — only the zero data remains -/

/-- **Route B for Dirichlet L-functions, with every analytic hypothesis discharged.**  This is
`routeB_for_dirichletL_unconditional` with `han`, `hint₀` and `hint₁` supplied by the lemmas
above.  The hypotheses `hne₀`, `hne₁` of the intermediate statement are not needed either: the
zero data `hmem` places every `z ∈ Z` strictly between the two edges, so no point of an edge can
lie in `Z`, and `hno` applies there.

What is left is exactly the numerical zero data: the finite zero set `Z`, its multiplicities
`m`, and zero-freeness `hno` on the rectangle away from `Z`. -/
theorem routeB_for_dirichletL_of_zeros (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z →
      dirichletCompleted χ u ≠ 0) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  -- No point of the edge `im = t` for `t = t0` or `t = t1` lies in `Z`, so `hno` gives
  -- non-vanishing there.
  have hne_edge : ∀ t ∈ Set.uIcc t0 t1, (∀ z ∈ Z, t ≠ z.im) →
      ∀ x ∈ Set.uIcc (0 : ℝ) 1, dirichletCompleted χ (x + t * Complex.I) ≠ 0 := by
    intro t ht' hz x hx
    apply hno _ _ _
    · rw [Complex.mem_reProdIm]
      constructor
      · simpa using hx
      · simpa using ht'
    · intro hmemZ
      have hz' := hz _ hmemZ
      have him : ((x : ℂ) + t * Complex.I).im = t := by simp
      exact hz' him.symm
  have hlow : ∀ z ∈ Z, t0 ≠ z.im := fun z hz => ne_of_lt (hmem z hz).2.2.1
  have hhigh : ∀ z ∈ Z, t1 ≠ z.im := fun z hz => ne_of_gt (hmem z hz).2.2.2
  exact routeB_for_dirichletL_unconditional χ t0 t1 Z m hχ hχinv hχ1 hχ2 ht
    (fun s _ => analyticAt_dirichletCompleted χ hχ1 s) hmem hm hno
    (intervalIntegrable_logDeriv_dirichletCompleted χ hχ1 t0
      (show t0 ∈ Set.uIcc t0 t1 from Set.left_mem_uIcc)
      (hne_edge t0 Set.left_mem_uIcc hlow))
    (intervalIntegrable_logDeriv_dirichletCompleted χ hχ1 t1
      (show t1 ∈ Set.uIcc t0 t1 from Set.right_mem_uIcc)
      (hne_edge t1 Set.right_mem_uIcc hhigh))

end

end RouteABC
