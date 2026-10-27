/-
  AxiomsConj.lean — axiom audit and smoke tests for `DirichletConj.lean`.

  Every headline lemma of `DirichletConj` must rest on exactly the three standard axioms
  `propext`, `Classical.choice`, `Quot.sound` — in particular no `sorryAx` and no bespoke
  `axiom`.  The `example`s below are type-checking smoke tests of each statement.
-/
import DirichletConj
import DirichletRouteB
import GaussSumComposite
import DirichletAnalytic

open MeasureTheory intervalIntegral
open scoped ComplexConjugate Topology
open DirichletCharacter
open Rh45RouteBAnalytic

/-! ## Axiom audit -/

#print axioms LSeries_conj
#print axioms Complex.Gammaℝ_conj
#print axioms Complex.Gammaℝ_ne_zero_of_pos_re
#print axioms Complex.conj_cpow_ofReal
#print axioms DirichletCharacter.LFunction_conj_of_one_lt_re
#print axioms DirichletCharacter.gammaFactor_conj
#print axioms DirichletCharacter.gammaFactor_ne_zero_of_one_lt_re
#print axioms DirichletCharacter.completedLFunction_conj_of_one_lt_re
#print axioms DirichletCharacter.completedLFunction₀_conj
#print axioms DirichletCharacter.completedLFunction_conj
#print axioms completedRiemannZeta_conj

/-! ## Smoke tests -/

/-- The trivial Dirichlet character (of any level) is real. -/
private lemma isReal_one (N : ℕ) :
    ∀ n : ℕ, conj ((1 : DirichletCharacter ℂ N) n) = (1 : DirichletCharacter ℂ N) n := by
  intro n
  by_cases h : IsUnit (n : ZMod N)
  · rw [MulChar.one_apply h]; simp
  · rw [MulChar.map_nonunit _ h]; simp

/-- The conjugation identity for an arbitrary real character (the `χ ≠ 1` application case). -/
example (χ : DirichletCharacter ℂ 5) (h : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    completedLFunction χ (conj s) = conj (completedLFunction χ s) :=
  completedLFunction_conj χ h s

/-- The conjugation identity in the equivalent "conjugate the value" orientation. -/
example (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N)
    (h : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    conj (completedLFunction χ (conj s)) = completedLFunction χ s :=
  by simpa using congrArg conj (completedLFunction_conj χ h s)

/-- The trivial character modulo `N > 1` — the case with a genuine pole at `s = 1`. -/
example (N : ℕ) [NeZero N] (s : ℂ) :
    completedLFunction (1 : DirichletCharacter ℂ N) (conj s)
      = conj (completedLFunction (1 : DirichletCharacter ℂ N) s) :=
  completedLFunction_conj 1 (isReal_one N) s

/-- A concrete numerical instance (trivial character mod `3`, at `s = 2 + 3i`). -/
example :
    completedLFunction (1 : DirichletCharacter ℂ 3) (conj (2 + 3 * Complex.I))
      = conj (completedLFunction (1 : DirichletCharacter ℂ 3) (2 + 3 * Complex.I)) :=
  completedLFunction_conj 1 (isReal_one 3) _

/-- The entire normalisation is conjugation-equivariant as well. -/
example (χ : DirichletCharacter ℂ 4) (h : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    ZMod.completedLFunction₀ (⇑χ) (conj s) = conj (ZMod.completedLFunction₀ (⇑χ) s) :=
  completedLFunction₀_conj χ h s

/-- `N = 1`: the completed Riemann zeta function is conjugation-equivariant. -/
example (s : ℂ) : completedRiemannZeta (conj s) = conj (completedRiemannZeta s) :=
  completedRiemannZeta_conj s

example : completedRiemannZeta (conj 2) = conj (completedRiemannZeta 2) :=
  completedRiemannZeta_conj 2

/-- The half-plane form of the identity for the L-function. -/
example (χ : DirichletCharacter ℂ 7) (h : ∀ n : ℕ, conj (χ n) = χ n) :
    LFunction χ (conj 2) = conj (LFunction χ 2) :=
  LFunction_conj_of_one_lt_re χ h (by norm_num : (1 : ℝ) < (2 : ℂ).re)

/-- Conjugation of the archimedean factor. -/
example (χ : DirichletCharacter ℂ 4) (s : ℂ) :
    gammaFactor χ (conj s) = conj (gammaFactor χ s) :=
  gammaFactor_conj χ s

example (s : ℂ) : Complex.Gammaℝ (conj s) = conj (Complex.Gammaℝ s) :=
  Complex.Gammaℝ_conj s

/-- Conjugation of an abstract L-series. -/
example (f : ℕ → ℂ) (s : ℂ) :
    conj (LSeries f (conj s)) = LSeries (fun n => conj (f n)) s :=
  LSeries_conj f s

/-- A complex power with nonnegative real base commutes with conjugation. -/
example (r : ℝ) (hr : 0 ≤ r) (z : ℂ) :
    conj ((r : ℂ) ^ z) = (r : ℂ) ^ conj z :=
  Complex.conj_cpow_ofReal r hr z

/-- The gamma factor does not vanish on `1 < re s`. -/
example (χ : DirichletCharacter ℂ 4) {s : ℂ} (hs : 1 < s.re) : gammaFactor χ s ≠ 0 :=
  gammaFactor_ne_zero_of_one_lt_re χ hs

/-! ## The conjugation gap discharged inside Route B (`DirichletRouteB.lean`) -/

#print axioms RouteABC.completedLFunctionConj_of_real
#print axioms RouteABC.routeB_for_dirichletL_of_real

/-- Smoke test: the conjugation `Prop` of `Generic.lean` is now a theorem. -/
example (χ : DirichletCharacter ℂ 3) (h : ∀ n : ℕ, conj (χ n) = χ n) :
    RouteABC.CompletedLFunctionConj χ :=
  RouteABC.completedLFunctionConj_of_real χ h

/-! ## The root-number gap discharged inside Route B (`RootNumber.lean`) -/

#print axioms RouteABC.rootNumber_sq_eq_one_of_inv_eq_self
#print axioms RouteABC.rootNumber_eq_one_or_neg_one
#print axioms RouteABC.rootNumberSign_of_isQuadratic
#print axioms RouteABC.conj_eq_self_of_isQuadratic
#print axioms RouteABC.isQuadratic_of_conj_eq_self
#print axioms RouteABC.rootNumberSign_of_conj_eq_self
#print axioms RouteABC.routeB_for_dirichletL_unconditional

#check @RouteABC.rootNumber_eq_one_or_neg_one
#check @RouteABC.rootNumberSign_of_isQuadratic
#check @RouteABC.isQuadratic_of_conj_eq_self
#check @RouteABC.routeB_for_dirichletL_unconditional

/-- Smoke test: the root-number `Prop` of `Generic.lean` is now a theorem. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : IsPrimitive χ)
    (h1 : χ ≠ 1) (h2 : χ.IsQuadratic) : RouteABC.RootNumberSign χ :=
  RouteABC.rootNumberSign_of_isQuadratic χ hχ h1 h2

/-- Smoke test: the disjunction form. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : IsPrimitive χ)
    (h1 : χ ≠ 1) (h2 : χ.IsQuadratic) : rootNumber χ = 1 ∨ rootNumber χ = -1 :=
  RouteABC.rootNumber_eq_one_or_neg_one χ hχ h1 h2

/-- Smoke test: the `hreal`-shaped bridge recovering `IsQuadratic`. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (h : ∀ n : ℕ, conj (χ n) = χ n) : χ.IsQuadratic :=
  RouteABC.isQuadratic_of_conj_eq_self χ h

/-- Smoke test: a quadratic character is real-valued. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (h : χ.IsQuadratic) (n : ℕ) :
    conj (χ n) = χ n :=
  RouteABC.conj_eq_self_of_isQuadratic χ h n

/-- Smoke test: Route B with both gaps discharged, applied to assumed analytic data. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      AnalyticAt ℂ (RouteABC.dirichletCompleted χ) s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (RouteABC.dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z →
      RouteABC.dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (RouteABC.dirichletCompleted χ)
      (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (RouteABC.dirichletCompleted χ)
      (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv (RouteABC.dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  RouteABC.routeB_for_dirichletL_unconditional χ t0 t1 Z m hχ hχinv hχ1 hχ2 ht
    han hmem hm hno hint₀ hint₁

/-! ## The composite-modulus Gauss-sum square (`GaussSumComposite.lean`) -/

#print axioms DirichletCharacter.IsPrimitive.inv
#print axioms RouteABC.gaussSum_mul_gaussSum_inv_eq_card
#print axioms RouteABC.gaussSum_sq_of_isPrimitive
#print axioms RouteABC.gaussSum_sq_of_isPrimitive_prime
#print axioms RouteABC.rootNumber_eq_one_or_neg_one'

#check @DirichletCharacter.IsPrimitive.inv
#check @RouteABC.gaussSum_mul_gaussSum_inv_eq_card
#check @RouteABC.gaussSum_sq_of_isPrimitive
#check @RouteABC.gaussSum_sq_of_isPrimitive_prime
#check @RouteABC.rootNumber_eq_one_or_neg_one'

/-- Smoke test: twice the same statement — the new composite-modulus square. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : IsPrimitive χ)
    (h1 : χ ≠ 1) (h2 : χ.IsQuadratic) :
    gaussSum χ ZMod.stdAddChar ^ 2 = χ (-1) * (N : ℂ) :=
  RouteABC.gaussSum_sq_of_isPrimitive hχ h1 h2

/-- Smoke test: the product form it comes from. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : IsPrimitive χ) :
    gaussSum χ ZMod.stdAddChar * gaussSum χ⁻¹ ZMod.stdAddChar = χ (-1) * (N : ℂ) :=
  RouteABC.gaussSum_mul_gaussSum_inv_eq_card hχ

/-- Smoke test: the inverse of a primitive character is primitive (new `IsPrimitive.inv`). -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : IsPrimitive χ) :
    IsPrimitive χ⁻¹ :=
  hχ.inv

/-- Smoke test: the root-number sign re-derived by the Gauss-sum route.  This is a second,
independent proof of the same proposition as `RouteABC.rootNumber_eq_one_or_neg_one`
(`RootNumber.lean`, functional-equation route). -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : IsPrimitive χ)
    (h1 : χ ≠ 1) (h2 : χ.IsQuadratic) : rootNumber χ = 1 ∨ rootNumber χ = -1 :=
  RouteABC.rootNumber_eq_one_or_neg_one' χ hχ h1 h2

/-! ## The analytic hypotheses discharged (`DirichletAnalytic.lean`)

`RouteABC.routeB_for_dirichletL_unconditional` still asks for analyticity of `dirichletCompleted χ`
on the rectangle and interval integrability of its log-derivative on the two horizontal edges.
`DirichletAnalytic.lean` proves all three for every nontrivial `χ`, and repackages Route B with
only the numerical zero data left. -/

#print axioms RouteABC.analyticAt_dirichletCompleted
#print axioms RouteABC.analyticAt_dirichletCompleted_of_mem
#print axioms RouteABC.differentiable_dirichletCompleted
#print axioms RouteABC.continuousOn_logDeriv_dirichletCompleted
#print axioms RouteABC.intervalIntegrable_logDeriv_dirichletCompleted
#print axioms RouteABC.routeB_for_dirichletL_of_zeros

#check @RouteABC.analyticAt_dirichletCompleted
#check @RouteABC.analyticAt_dirichletCompleted_of_mem
#check @RouteABC.differentiable_dirichletCompleted
#check @RouteABC.continuousOn_logDeriv_dirichletCompleted
#check @RouteABC.intervalIntegrable_logDeriv_dirichletCompleted
#check @RouteABC.routeB_for_dirichletL_of_zeros

/-- Smoke test: `dirichletCompleted χ` is entire for `χ ≠ 1`. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (s : ℂ) :
    AnalyticAt ℂ (RouteABC.dirichletCompleted χ) s :=
  RouteABC.analyticAt_dirichletCompleted χ hχ s

/-- Smoke test: the box form of analyticity consumed by Route B. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {t0 t1 : ℝ} {s : ℂ}
    (hs : s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1)) :
    AnalyticAt ℂ (RouteABC.dirichletCompleted χ) s :=
  RouteABC.analyticAt_dirichletCompleted_of_mem χ hχ hs

/-- Smoke test: interval integrability of `logDeriv` on an edge, from non-vanishing there. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {t0 t1 : ℝ} (t : ℝ)
    (ht : t ∈ Set.uIcc t0 t1)
    (hne : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      RouteABC.dirichletCompleted χ (x + t * Complex.I) ≠ 0) :
    IntervalIntegrable (fun x : ℝ => logDeriv (RouteABC.dirichletCompleted χ)
      (x + t * Complex.I)) volume 0 1 :=
  RouteABC.intervalIntegrable_logDeriv_dirichletCompleted χ hχ t ht hne

/-- Smoke test: Route B for the completed L-function with **every** analytic hypothesis
discharged — only the numerical zero set `Z`, its multiplicities `m`, and zero-freeness off `Z`
remain. -/
example {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1)
    (hχ2 : χ.IsQuadratic) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (RouteABC.dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z →
      RouteABC.dirichletCompleted χ u ≠ 0) :
    (rightPath (logDeriv (RouteABC.dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  RouteABC.routeB_for_dirichletL_of_zeros χ t0 t1 Z m hχ hχinv hχ1 hχ2 ht hmem hm hno
