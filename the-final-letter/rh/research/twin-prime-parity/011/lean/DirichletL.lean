/-
  DirichletL.lean — a **concrete** real primitive Dirichlet character, its completed
  L-function, and the Route B instantiation.

  `DirichletRouteB.lean` proves Route B for an *arbitrary* real primitive quadratic
  character χ.  This file supplies a concrete instance of the object the 011 numerics
  certify — the character χ₃ mod 3,

      χ₃ = (· / 3) : (ZMod 3)ˣ → {±1} ⊂ ℂ,

  as `MulChar (ZMod 3) ℂ`, and discharges every character-theoretic hypothesis of the
  Route B theorem for it:

    * `chi3_isQuadratic`   — χ₃ is quadratic (so χ₃⁻¹ = χ₃ and it is real);
    * `chi3_ne_one`        — χ₃ ≠ 1 (it is −1 at 2);
    * `chi3_isPrimitive`   — χ₃ is primitive (the conductor divides 3 and is not 1).

  `routeB_for_chi3_of_zeros` is then the Route B conclusion for the completed
  L-function `dirichletCompleted chi3`, conditional **only** on the numerical zero
  data `Z`, `m`, `hno` of a Turing window — exactly the data produced by
  `../rigorous/certify_dirichlet_routeB.py`.

  Mathlib libraries required (the only non-local imports):

    * `Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic` — `quadraticChar`,
      `quadraticChar_isQuadratic`, `MulChar.ringHomComp`, `MulChar.IsQuadratic.comp`;
    * `Mathlib.NumberTheory.LSeries.DirichletContinuation` — the completed L-function
      and its functional equation (through `Generic.lean`);
    * the local `Generic`, `DirichletRouteB`, `DirichletAnalytic` modules.
-/
import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic
import Mathlib.NumberTheory.LSeries.DirichletContinuation
import Generic
import DirichletRouteB
import DirichletAnalytic

open MeasureTheory intervalIntegral
open scoped Topology ComplexConjugate
open DirichletCharacter
open Rh45RouteBAnalytic

namespace RouteABC

/-- The real primitive character χ₃ mod 3: the Legendre symbol `(· / 3)`, valued in ℂ. -/
noncomputable def chi3 : DirichletCharacter ℂ 3 :=
  (quadraticChar (ZMod 3)).ringHomComp (Int.castRingHom ℂ)

/-- `χ₃` is a quadratic (equivalently, real) character. -/
lemma chi3_isQuadratic : chi3.IsQuadratic :=
  (quadraticChar_isQuadratic (ZMod 3)).comp (Int.castRingHom ℂ)

/-- `χ₃(2) = -1`: 2 is a nonsquare mod 3. -/
lemma chi3_apply_two : chi3 (2 : ZMod 3) = -1 := by
  have h : quadraticChar (ZMod 3) (2 : ZMod 3) = -1 := by decide
  simp only [chi3, MulChar.ringHomComp_apply, h, map_neg, map_one]

/-- `χ₃ ≠ 1`, because `χ₃(2) = -1`. -/
lemma chi3_ne_one : chi3 ≠ 1 := by
  intro h
  have h2 := congrFun (congrArg DFunLike.coe h) (2 : ZMod 3)
  rw [chi3_apply_two] at h2
  have hu : IsUnit (2 : ZMod 3) := ⟨⟨2, 2, by decide, by decide⟩, rfl⟩
  rw [MulChar.one_apply hu] at h2
  norm_num at h2

/-- `χ₃` is primitive: its conductor divides 3 and is not 1. -/
lemma chi3_isPrimitive : IsPrimitive chi3 := by
  rw [isPrimitive_def]
  have hdvd : conductor chi3 ∣ 3 := conductor_dvd_level chi3
  have hne0 : conductor chi3 ≠ 0 := conductor_ne_zero chi3
  rcases (Nat.dvd_prime (by norm_num : Nat.Prime 3)).mp hdvd with h | h
  · exact absurd ((eq_one_iff_conductor_eq_one (χ := chi3)).mpr h) chi3_ne_one
  · exact h

/-- **Route B for the completed Dirichlet L-function of χ₃.**

All character-theoretic hypotheses of `routeB_for_dirichletL_of_zeros` are discharged
for the concrete real primitive character `chi3`; the only remaining inputs are the
numerical zero data `Z`, its orders `m`, and zero-freeness off `Z` on the rectangle
`[0,1] × [t0,t1]`. -/
theorem routeB_for_chi3_of_zeros (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted chi3) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      u ∉ Z → dirichletCompleted chi3 u ≠ 0) :
    (rightPath (logDeriv (dirichletCompleted chi3)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  routeB_for_dirichletL_of_zeros chi3 t0 t1 Z m
    chi3_isPrimitive chi3_isQuadratic.inv chi3_ne_one chi3_isQuadratic
    ht hmem hm hno

end RouteABC
