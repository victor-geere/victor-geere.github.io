/-
  RootNumber.lean — the root number of a quadratic Dirichlet character is `±1`.

  `Generic.lean` names `RootNumberSign χ` (`rootNumber χ = 1 ∨ rootNumber χ = -1`) as one of
  the two gaps of the Dirichlet Route B statement.  This file proves it.

  ## What is actually true

  Mathlib defines `rootNumber χ = gaussSum χ stdAddChar / I^a / N^(1/2)` and documents it as
  "for `χ` primitive; junk otherwise".  For an **imprimitive** character the Gauss sum need not
  be `±N^(1/2)`, and then `rootNumber χ ≠ ±1`: for example the nontrivial quadratic character
  modulo `3`, extended (`changeLevel`) to modulus `6`, takes the values
  `0, 1, 0, 0, 0, -1` and has `gaussSum = ω - ω⁵ = I√3` (`ω = exp (2πI/6)`), so it is odd and
  `rootNumber = I√3 / I / √6 = 1/√2`.  So the implication genuinely needs `IsPrimitive χ`,
  which every application supplies anyway (Route B is stated for primitive characters).

  The proof below does **not** use `gaussSum_sq` (which Mathlib only proves for characters on a
  finite *field*, hence only for prime modulus) but the functional equation itself:

  for `χ` primitive with `χ⁻¹ = χ`, `Λ_χ(1-s) = N^(s-1/2) · ε · Λ_χ(s)` with `ε = rootNumber χ`.
  Applying it at `1 - s` and substituting gives `Λ_χ(s) = ε² Λ_χ(s)`; evaluating at `s = 1`
  (where `Λ_χ(1) ≠ 0`, from nonvanishing of `L(χ,1)` and the Gamma factor) gives `ε² = 1`,
  hence `ε = ±1`.  This works for every modulus `N`.
-/
import Mathlib.NumberTheory.LSeries.DirichletContinuation
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Mathlib.NumberTheory.MulChar.Lemmas
import Generic

open scoped ComplexConjugate
open DirichletCharacter
open Complex

namespace RouteABC

noncomputable section

/-! ## The functional-equation computation -/

/-- **The square of the root number of a primitive self-inverse character is `1`.**

`χ⁻¹ = χ` is exactly the self-duality needed for the functional equation to relate `Λ_χ` to
itself; `χ ≠ 1` is only used to know that `Λ_χ(1) ≠ 0` (via nonvanishing of `L(χ,1)` and the
Gamma factor).  The modulus is arbitrary. -/
theorem rootNumber_sq_eq_one_of_inv_eq_self {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχinv : χ⁻¹ = χ) : rootNumber χ ^ 2 = 1 := by
  by_cases hN : N = 1
  · subst hN
    rw [rootNumber_modOne]
    norm_num
  · -- functional equation, in self-dual form
    have hfe : ∀ s : ℂ, completedLFunction χ (1 - s)
        = (N : ℂ) ^ (s - 1 / 2) * rootNumber χ * completedLFunction χ s := by
      intro s
      rw [hχ.completedLFunction_one_sub s, hχinv]
    -- `Λ_χ(1) ≠ 0`
    have hgamma : gammaFactor χ 1 ≠ 0 := by
      rcases χ.even_or_odd with hE | hO
      · rw [hE.gammaFactor_def]
        exact Gammaℝ_ne_zero_of_re_pos (by norm_num)
      · rw [hO.gammaFactor_def]
        exact Gammaℝ_ne_zero_of_re_pos (by norm_num)
    have hΛ1 : completedLFunction χ 1 ≠ 0 := by
      intro hz
      have hL := LFunction_apply_one_ne_zero (χ := χ) hχ1
      rw [LFunction_eq_completed_div_gammaFactor χ 1 (Or.inr hN), hz, zero_div] at hL
      exact hL rfl
    -- the two instances of the functional equation at `s = 0` and `s = 1`
    have h0 : completedLFunction χ 0
        = (N : ℂ) ^ (1 / 2 : ℂ) * rootNumber χ * completedLFunction χ 1 := by
      have h := hfe 1
      rw [sub_self, show (1 : ℂ) - 1 / 2 = (1 / 2 : ℂ) by norm_num] at h
      exact h
    have h1 : completedLFunction χ 1
        = (N : ℂ) ^ (-(1 / 2 : ℂ)) * rootNumber χ * completedLFunction χ 0 := by
      have := hfe 0
      simpa using this
    have hN0 : (N : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (NeZero.ne N)
    have hA : (N : ℂ) ^ (-(1 / 2 : ℂ)) * (N : ℂ) ^ (1 / 2 : ℂ) = 1 := by
      rw [← Complex.cpow_add (-(1 / 2 : ℂ)) (1 / 2 : ℂ) hN0]
      norm_num
    have key : rootNumber χ ^ 2 * completedLFunction χ 1 = completedLFunction χ 1 := by
      conv_rhs => rw [h1, h0]
      have hreassoc : (N : ℂ) ^ (-(1 / 2 : ℂ)) * rootNumber χ *
          ((N : ℂ) ^ (1 / 2 : ℂ) * rootNumber χ * completedLFunction χ 1)
          = ((N : ℂ) ^ (-(1 / 2 : ℂ)) * (N : ℂ) ^ (1 / 2 : ℂ))
            * (rootNumber χ * rootNumber χ) * completedLFunction χ 1 := by ring
      rw [hreassoc, hA, one_mul, sq]
    have : (rootNumber χ ^ 2 - 1) * completedLFunction χ 1 = 0 := by
      rw [sub_mul, one_mul, key, sub_self]
    rcases mul_eq_zero.mp this with h | h
    · exact sub_eq_zero.mp h
    · exact absurd h hΛ1

/-- **`RootNumberSign` is not an independent hypothesis.**  For a primitive real character with
`χ ≠ 1`, `rootNumber χ ^ 2 = 1` (§45), hence `rootNumber χ = ±1` over `ℂ` — so the named interface
`RootNumberSign χ` is **derivable** from `IsPrimitive χ`, `χ ≠ 1` and `χ⁻¹ = χ`. -/
theorem rootNumberSign_of_inv_eq_self {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχinv : χ⁻¹ = χ) : RootNumberSign χ :=
  sq_eq_one_iff.mp (rootNumber_sq_eq_one_of_inv_eq_self χ hχ hχ1 hχinv)

/-! ## The named hypothesis, discharged -/

/-- **`RootNumberSign` for nontrivial quadratic characters (PROVED).**

This is the exact statement requested of `rootNumber_eq_one_or_neg_one`, with the necessary
hypothesis `IsPrimitive χ` made explicit: without it the statement is false, because
`rootNumber` is junk for imprimitive characters (e.g. it is `1/√2` for the `changeLevel` image
of the mod-3 quadratic character at modulus `6`).  Every use of `RootNumberSign` in this
development already assumes `IsPrimitive χ`. -/
theorem rootNumber_eq_one_or_neg_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) :
    rootNumber χ = 1 ∨ rootNumber χ = -1 :=
  sq_eq_one_iff.mp (rootNumber_sq_eq_one_of_inv_eq_self χ hχ hχ1 hχ2.inv)

/-- **The named gap `RootNumberSign χ` is a theorem for nontrivial quadratic characters.** -/
theorem rootNumberSign_of_isQuadratic {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) : RootNumberSign χ :=
  rootNumber_eq_one_or_neg_one χ hχ hχ1 hχ2

/-! ## The `hreal` ⇄ `IsQuadratic` bridge -/

/-- **A quadratic Dirichlet character is real-valued.**  The values `0`, `1`, `-1` are fixed by
conjugation; this is the easy direction of the `hreal` ⇄ `IsQuadratic` bridge, and the one the
Route B application needs (it feeds `CompletedLFunctionConj`). -/
theorem conj_eq_self_of_isQuadratic {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ2 : χ.IsQuadratic) : ∀ n : ℕ, conj (χ n) = χ n :=
  fun n => by rcases hχ2 n with h | h | h <;> simp [h]

/-- **A real-valued Dirichlet character is quadratic (PROVED).**

For a unit `a` the value `χ a` is a root of unity (its `#(ZMod N)ˣ`-th power is `1`, Mathlib's
`MulChar.apply_mem_rootsOfUnity`), so `star (χ a) = χ⁻¹ a` (`MulChar.star_apply'`).  Reality
`conj (χ a) = χ a` therefore forces `χ⁻¹ a = χ a` on every unit, and `χ a = 0` on non-units;
hence `χ² = 1` and `χ` is quadratic.  (`hreal` is stated on `ℕ`; every `a : ZMod N` is
`(a.val : ZMod N)`.) -/
theorem isQuadratic_of_conj_eq_self {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) : χ.IsQuadratic := by
  have hinv : χ⁻¹ = χ := by
    ext a
    have h : conj (χ (a : ZMod N)) = χ (a : ZMod N) := by
      have := hreal ((a : ZMod N)).val
      simpa [ZMod.natCast_zmod_val] using this
    rw [← MulChar.star_apply' χ (a : ZMod N)]
    simpa [RCLike.star_def] using h
  rw [MulChar.isQuadratic_iff_sq_eq_one]
  simpa [pow_two, hinv] using inv_mul_cancel χ

/-- **`RootNumberSign` for real primitive characters, from the `hreal` form.** -/
theorem rootNumberSign_of_conj_eq_self {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hreal : ∀ n : ℕ, conj (χ n) = χ n) :
    RootNumberSign χ :=
  rootNumberSign_of_isQuadratic χ hχ hχ1 (isQuadratic_of_conj_eq_self χ hreal)

end

end RouteABC
