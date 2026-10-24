/-
  Generic.lean — how far Routes A / B / C of the 010 development generalise.

  This is a *research artifact*: it separates, for every headline statement, what is
  **proved here** from what is **assumed** as a named hypothesis.  There is no
  `sorry`, no `axiom`, no `admit`, no `native_decide` and no `set_option maxHeartbeats`.

  ## Contents

  * **Part 1 — Route B interface.**  `SelfDualReal F` records exactly the structural data
    Route B consumes (`F(1-s)=F s`, `F(conj s)=conj(F s)`), and `routeB_of_selfDualReal`
    is a thin wrapper around the 010 theorem `Rh45RouteBAnalytic.routeB_reduction_general`:
    Route B is *already* general in the analytic function.  The refinement
    `SelfDualRealUpToSign` records the observation that the proof only uses self-duality
    through `logDeriv F (1-s) = -logDeriv F s`, which survives a sign `ε = ±1` (the
    Dirichlet root number!).  This is the form Route B takes for L-functions with ε = -1.

  * **Part 2 — Routes A and C are already general.**
    `CertifiedZero` packages the enclosure hypotheses of
    `Rh45Routes.certified_root_of_enclosures` for an arbitrary continuous `f` on an
    arbitrary `[a,b]`.  `validated_truncation_bound_finset` generalises the 3-tail
    `Rh45Routes.validated_truncation_bound` to an arbitrary `Finset` of tails (new, proved
    here by induction), with the 3-tail statement recovered as the instance
    `validated_truncation_bound_three`.

  * **Part 3 — Dirichlet L-functions, functional equation (PROVED).**
    `dirichletL_normalised_one_sub` proves the normalised self-duality of
    `dirichletCompleted χ s = N^(s/2) · Λ_χ(s)`, up to the root number, from Mathlib's
    primitive functional equation `IsPrimitive.completedLFunction_one_sub`.

  * **Part 4 — the remaining gap, NAMED.**  The two missing Mathlib ingredients are the
    `Prop`-valued definitions `RootNumberSign χ` and `CompletedLFunctionConj χ`; the
    theorem `routeB_for_dirichletL` concludes Route B for `dirichletCompleted χ`
    *conditionally on exactly those two hypotheses* (and nothing else beyond the same
    zero data / integrability Route B always needs).
-/
import Rh45.Routes
import Rh45.RouteBGeneral
import Mathlib.NumberTheory.LSeries.DirichletContinuation

open MeasureTheory intervalIntegral
open scoped Topology ComplexConjugate
open DirichletCharacter
open Rh45RouteBAnalytic

namespace RouteABC

noncomputable section

/-! ## Part 1 — the Route B verification interface -/

/-- **Route B interface.**  The two structural identities that Route B needs of the
meromorphic function `F` whose zeros it counts: the functional equation
`s ↦ 1 - s` and reality (`s ↦ conj s`).  Both are stated for *all* of `ℂ`. -/
structure SelfDualReal (F : ℂ → ℂ) : Prop where
  /-- Functional equation `F(1 - s) = F s`. -/
  selfDual : ∀ s, F (1 - s) = F s
  /-- Reality on the real axis: `F(conj s) = conj (F s)`. -/
  conjSymm : ∀ s, F (conj s) = conj (F s)

/-- **Route B is already general.**  Given the same remaining hypotheses as
`Rh45RouteBAnalytic.routeB_reduction_general` — analyticity on the closed rectangle, the
zero set `Z` with orders `m`, zero-freeness elsewhere, and interval integrability on the
two horizontal edges — together with `SelfDualReal F`, the imaginary part of the
three-segment integral is `π · ∑ m z`.

This is a *thin* wrapper: the analysis is entirely the 010 theorem. -/
theorem routeB_of_selfDualReal (F : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (h : SelfDualReal F)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt F z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → F u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  Rh45RouteBAnalytic.routeB_reduction_general F t0 t1 Z m ht han hmem hm hno
    h.selfDual h.conjSymm hint₀ hint₁

/-- **A key observation used by the L-function instance.**  If `f(1 - s) = ε · f s` for a
*nonzero constant* `ε`, then `logDeriv f` still changes sign under `s ↦ 1 - s`:
`logDeriv f (1 - s) = -logDeriv f s`.

The sign cancels because differentiating `f(1-t) = ε f(t)` gives `f'(1-t) = -ε f'(t)`,
so `f'(1-t)/f(1-t) = (-ε f'(t))/(ε f(t)) = -f'(t)/f(t)`.  This is why a root number
`ε = ±1` is *not* an obstruction for Route B, even though it is one for the bare identity
`F(1-s) = F s`. -/
theorem logDeriv_one_sub_of_const_mul (f : ℂ → ℂ) (ε : ℂ) (hε : ε ≠ 0)
    (h : ∀ s, f (1 - s) = ε * f s) (s : ℂ) :
    logDeriv f (1 - s) = -logDeriv f s := by
  have hg : (fun t : ℂ => f (1 - t)) = fun t : ℂ => ε * f t := funext h
  have h1 : logDeriv (fun t : ℂ => f (1 - t)) s = -logDeriv f (1 - s) := by
    rw [logDeriv_apply, logDeriv_apply, deriv_comp_const_sub]
    ring
  have h2 : logDeriv (fun t : ℂ => ε * f t) s = logDeriv f s :=
    logDeriv_const_mul (f := f) s ε hε
  rw [hg, h2] at h1
  rw [h1, neg_neg]

/-- **Route B at the level of the logarithmic derivative.**  The 010 reduction
`Rh45RouteBAnalytic.routeB_reduction` only ever asks for
`g (1 - conj s) = -conj (g s)` with `g = logDeriv F`.  Feeding the argument principle
`Rh45RouteBAnalytic.argument_principle_general` into it gives Route B from that single
pointwise symmetry of `logDeriv F`, without requiring exact self-duality of `F`. -/
theorem routeB_general_of_logDeriv (F : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt F z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → F u ≠ 0)
    (hrefl : ∀ s, logDeriv F (1 - conj s) = -conj (logDeriv F s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  have hAP : rectBoundary (logDeriv F) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (((∑ z ∈ Z, (m z : ℝ)) : ℝ) : ℂ) := by
    have hcast : (((∑ z ∈ Z, (m z : ℝ)) : ℝ) : ℂ) = ∑ z ∈ Z, (m z : ℂ) := by
      rw [Complex.ofReal_sum]
      exact Finset.sum_congr rfl fun z _ => by simp
    rw [hcast]
    exact Rh45RouteBAnalytic.argument_principle_general F t0 t1 Z m ht han hmem hm hno
  exact Rh45RouteBAnalytic.routeB_reduction (logDeriv F) t0 t1 hrefl hint₀ hint₁ _ hAP

/-- **Route B interface up to a sign.**  The data Route B actually consumes: `F` is
self-dual up to a sign `ε = ±1` (the Dirichlet root number), and real on the real axis. -/
structure SelfDualRealUpToSign (F : ℂ → ℂ) (ε : ℂ) : Prop where
  /-- The sign is a genuine sign: `ε = 1` or `ε = -1`; in particular `ε ≠ 0`. -/
  unit : ε = 1 ∨ ε = -1
  /-- The functional equation up to the sign: `F(1 - s) = ε · F s`. -/
  selfDual : ∀ s, F (1 - s) = ε * F s
  /-- Reality on the real axis: `F(conj s) = conj (F s)`. -/
  conjSymm : ∀ s, F (conj s) = conj (F s)

/-- **Route B is general, even when the functional equation carries a sign.**  For
`ε = 1` this is literally `routeB_of_selfDualReal`; for `ε = -1` the sign still cancels in
`logDeriv` (`logDeriv_one_sub_of_const_mul`), so `routeB_general_of_logDeriv` applies. -/
theorem routeB_of_selfDualRealUpToSign (F : ℂ → ℂ) (ε : ℂ) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (h : SelfDualRealUpToSign F ε)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt F z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → F u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  rcases h.unit with h1 | h1
  · -- ε = 1: this is exactly the `SelfDualReal` case (Part 1).
    refine routeB_of_selfDualReal F t0 t1 Z m
      ⟨fun s => ?_, h.conjSymm⟩ ht han hmem hm hno hint₀ hint₁
    rw [h.selfDual s, h1, one_mul]
  · -- ε = -1: the sign is invisible to `logDeriv`.
    have hε : ε ≠ 0 := by rw [h1]; norm_num
    have hrefl : ∀ s, logDeriv F (1 - conj s) = -conj (logDeriv F s) := by
      intro s
      rw [logDeriv_one_sub_of_const_mul F ε hε h.selfDual (conj s),
        Rh45RouteBAnalytic.logDeriv_conj F h.conjSymm s]
    exact routeB_general_of_logDeriv F t0 t1 Z m ht han hmem hm hno hrefl hint₀ hint₁

/-! ## Part 2a — Route A is already general -/

/-- **Route A certificate packaging.**  The exact numeric data an interval-arithmetic
`Z(t)` certificate supplies: `f` is continuous on `[a,b]`, the enclosures for `f a` and
`f b` have the correct signs, and `deriv f` is bounded below by a positive `m` on `(a,b)`.

Nothing here is special to `Z`: `f` is an arbitrary `ℝ → ℝ`. -/
structure CertifiedZero (f : ℝ → ℝ) (a b la ha lb hb m : ℝ) : Prop where
  /-- The interval is nondegenerate. -/
  hab : a < b
  /-- Continuity on the closed interval. -/
  cont : ContinuousOn f (Set.Icc a b)
  /-- Lower enclosure for `f a`. -/
  hfa_lo : la ≤ f a
  /-- Upper enclosure for `f a` is negative. -/
  ha_neg : ha < 0
  /-- Upper enclosure for `f a`. -/
  hfa_hi : f a ≤ ha
  /-- Lower enclosure for `f b`. -/
  hfb_lo : lb ≤ f b
  /-- Lower enclosure for `f b` is positive. -/
  lb_pos : 0 < lb
  /-- Upper enclosure for `f b`. -/
  hfb_hi : f b ≤ hb
  /-- Lower enclosure for `deriv f` on the interior. -/
  hderiv : ∀ x ∈ Set.Ioo a b, m ≤ deriv f x
  /-- The derivative lower bound is positive. -/
  hm_pos : 0 < m

/-- **Route A, generality made explicit.**  A `CertifiedZero` certificate yields a unique
simple zero in `(a,b)`.  The proof is a direct call to the 010 theorem
`Rh45Routes.certified_root_of_enclosures`, which was already stated for an arbitrary
`f : ℝ → ℝ`. -/
theorem CertifiedZero.exists_unique_root {f : ℝ → ℝ} {a b la ha lb hb m : ℝ}
    (h : CertifiedZero f a b la ha lb hb m) :
    ∃ x, x ∈ Set.Ioo a b ∧ f x = 0 ∧ 0 < deriv f x ∧
      ∀ y, y ∈ Set.Ioo a b → f y = 0 → y = x :=
  Rh45Routes.certified_root_of_enclosures h.hab h.cont h.hfa_lo h.ha_neg h.hfa_hi
    h.hfb_lo h.lb_pos h.hfb_hi h.hderiv h.hm_pos

/-! ## Part 2b — Route C is generalised to an arbitrary finite family of tails -/

/-- **Route C, `n`-tail form (new).**  If the exact right-hand side splits as the computed
partial sum plus the sum of an arbitrary finite family of tails, then the residual is
bounded by the sum of the absolute values of the tails.  Proved by induction on the
`Finset` (triangle inequality).

The 010 `Rh45Routes.validated_truncation_bound` is the special case of three tails; see
`validated_truncation_bound_three` below. -/
theorem validated_truncation_bound_finset {ι : Type*} [DecidableEq ι] (s : Finset ι)
    (tail : ι → ℝ) {lhs rhsComputed : ℝ}
    (hsplit : lhs = rhsComputed + ∑ i ∈ s, tail i) :
    |lhs - rhsComputed| ≤ ∑ i ∈ s, |tail i| := by
  have h : lhs - rhsComputed = ∑ i ∈ s, tail i := by
    rw [hsplit]; ring
  rw [h]
  clear hsplit h
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
      rw [Finset.sum_insert ha]
      calc |tail a + ∑ i ∈ s, tail i| ≤ |tail a| + |∑ i ∈ s, tail i| := abs_add_le _ _
        _ ≤ |tail a| + ∑ i ∈ s, |tail i| := by linarith [ih]
        _ = ∑ i ∈ insert a s, |tail i| := by rw [Finset.sum_insert ha]

/-- **Route C, three-tail form: the 010 instance.**  This is exactly
`Rh45Routes.validated_truncation_bound`, recovered here as the `Finset (Fin 3)` instance of
`validated_truncation_bound_finset` (the zero tail, the prime tail and the archimedean
tail). -/
theorem validated_truncation_bound_three
    {lhs rhsTrue rhsComputed zeroTail primeTail archTail : ℝ}
    (hlhs : lhs = rhsTrue)
    (hsplit : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)) :
    |lhs - rhsComputed| ≤ |zeroTail| + |primeTail| + |archTail| := by
  have h := validated_truncation_bound_finset (Finset.univ : Finset (Fin 3))
    (fun i => ![zeroTail, primeTail, archTail] i) (lhs := lhs) (rhsComputed := rhsComputed) ?_
  · simpa [Fin.sum_univ_three] using h
  · rw [hlhs, hsplit]
    congr 1
    simp [Fin.sum_univ_three]

section Dirichlet

variable {N : ℕ} [NeZero N]

/-! ## Part 3 — Dirichlet L-functions: the normalised functional equation (PROVED) -/

/-- The normalised completed L-function `h(s) = N^(s/2) · Λ_χ(s)`, where `Λ_χ` is
Mathlib's `completedLFunction χ`.  Route B is run on this `h`. -/
noncomputable def dirichletCompleted (χ : DirichletCharacter ℂ N) (s : ℂ) : ℂ :=
  (N : ℂ) ^ (s / 2) * completedLFunction χ s

/-- **Normalised self-duality of a real primitive Dirichlet L-function (PROVED).**  For a
primitive character `χ` with `χ⁻¹ = χ` (i.e. a real / quadratic character; `χ⁻¹ = χ` forces
`χ² = 1`), the normalised completed L-function satisfies

`h(1 - s) = rootNumber χ · h(s)`,  `h(s) = N^(s/2) · Λ_χ(s)`,

which is the rearrangement of Mathlib's
`IsPrimitive.completedLFunction_one_sub`
(`Λ_χ(1-s) = N^(s-1/2) · rootNumber χ · Λ_χ(s)`), using `cpow_add` to combine the powers
`N^((1-s)/2) · N^(s-1/2) = N^(s/2)`. -/
theorem dirichletL_normalised_one_sub (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (s : ℂ) :
    (N : ℂ) ^ ((1 - s) / 2) * completedLFunction χ (1 - s)
      = rootNumber χ * ((N : ℂ) ^ (s / 2) * completedLFunction χ s) := by
  have hN : (N : ℂ) ≠ 0 := by
    exact_mod_cast (NeZero.ne N : N ≠ 0)
  have hpow : (N : ℂ) ^ ((1 - s) / 2) * (N : ℂ) ^ (s - 1 / 2) = (N : ℂ) ^ (s / 2) := by
    rw [← Complex.cpow_add _ _ hN]
    congr 1
    ring
  rw [hχ.completedLFunction_one_sub s, hχinv]
  calc (N : ℂ) ^ ((1 - s) / 2)
        * ((N : ℂ) ^ (s - 1 / 2) * rootNumber χ * completedLFunction χ s)
      = ((N : ℂ) ^ ((1 - s) / 2) * (N : ℂ) ^ (s - 1 / 2))
          * (rootNumber χ * completedLFunction χ s) := by ring
    _ = (N : ℂ) ^ (s / 2) * (rootNumber χ * completedLFunction χ s) := by rw [hpow]
    _ = rootNumber χ * ((N : ℂ) ^ (s / 2) * completedLFunction χ s) := by ring

/-- The self-duality of Part 3 in `SelfDualRealUpToSign` form, with sign
`ε = rootNumber χ`.  This is the bridge from the functional equation to Part 1. -/
theorem dirichletCompleted_selfDual (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (s : ℂ) :
    dirichletCompleted χ (1 - s) = rootNumber χ * dirichletCompleted χ s :=
  dirichletL_normalised_one_sub χ hχ hχinv s

/-- **Reality of the normalised completed L-function**, conditional on reality of `Λ_χ`
(`CompletedLFunctionConj`, the named gap below).  The factor `N^(s/2)` is real, hence
conjugation-equivariant for the real base `N` (`Complex.cpow_conj`). -/
theorem dirichletCompleted_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ s, completedLFunction χ (conj s) = conj (completedLFunction χ s)) (s : ℂ) :
    dirichletCompleted χ (conj s) = conj (dirichletCompleted χ s) := by
  unfold dirichletCompleted
  have harg : ((N : ℂ)).arg ≠ Real.pi := by
    have hcast : (N : ℂ) = ((N : ℝ) : ℂ) := by simp
    rw [hcast, Complex.arg_ofReal_of_nonneg (Nat.cast_nonneg N)]
    exact Real.pi_ne_zero.symm
  rw [hreal s, map_mul]
  rw [show conj s / 2 = conj (s / 2) by rw [map_div₀, map_ofNat]]
  rw [Complex.cpow_conj _ _ harg]
  simp

/-! ## Part 4 — the remaining gap, named rather than hidden -/

/-- **Named gap 1.**  The root number of a real primitive character is `±1`.

Mathlib has `rootNumber` (defined via a Gauss sum) and proves the functional equation with
it, but does not prove this sign statement.  It is stated here as a `Prop`, never as an
axiom, and is a hypothesis of `routeB_for_dirichletL`. -/
def RootNumberSign (χ : DirichletCharacter ℂ N) : Prop :=
  rootNumber χ = 1 ∨ rootNumber χ = -1

/-- **Named gap 2.**  The completed L-function of a real character is conjugation-
equivariant: `Λ_χ(conj s) = conj (Λ_χ s)` (equivalently, it is real on the real axis).

Mathlib does not yet provide `completedLFunction_conj`.  Stated here as a `Prop`, never as
an axiom, and a hypothesis of `routeB_for_dirichletL`. -/
def CompletedLFunctionConj (χ : DirichletCharacter ℂ N) : Prop :=
  ∀ s, completedLFunction χ (conj s) = conj (completedLFunction χ s)

/-- **Route B for Dirichlet L-functions, conditional on exactly the two named gaps.**

Given a primitive real character `χ` (`χ⁻¹ = χ`), the two missing Mathlib lemmas
`RootNumberSign χ` and `CompletedLFunctionConj χ`, and the *same* remaining analytic
hypotheses as `Rh45RouteBAnalytic.routeB_reduction_general` (analyticity on the closed
rectangle, the zero set `Z` with orders `m`, zero-freeness elsewhere, interval
integrability on the two horizontal edges) for the normalised completed L-function
`h(s) = N^(s/2) · Λ_χ(s)`, Route B holds for `h`:

`(rightPath (logDeriv h) t₀ t₁).im = π · ∑_{z∈Z} m z`.

The self-duality input comes from Part 3 (`dirichletCompleted_selfDual`, so `h(1-s) =
rootNumber χ · h(s)`) and the reality input from `dirichletCompleted_conj`; these feed the
sign-aware Route B interface of Part 1. -/
theorem routeB_for_dirichletL (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hε : RootNumberSign χ) (hreal : CompletedLFunctionConj χ)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  routeB_of_selfDualRealUpToSign (dirichletCompleted χ) (rootNumber χ) t0 t1 Z m
    ⟨hε, dirichletCompleted_selfDual χ hχ hχinv, dirichletCompleted_conj χ hreal⟩
    ht han hmem hm hno hint₀ hint₁

end Dirichlet

end

end RouteABC
