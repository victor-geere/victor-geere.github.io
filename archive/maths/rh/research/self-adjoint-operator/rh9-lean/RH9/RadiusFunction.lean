import Mathlib.Analysis.Calculus.ContDiff.Basic
import RH9.Zeros

/-!
# Radius Function r

We formalise smooth radius functions  r : ℝ → (0, ∞)  satisfying  r(γₙ) = βₙ.

Two important special cases:
- The constant function r ≡ 1/2 (the Riemann-Hypothesis case).
- A general smooth interpolation of the βₙ.

Existence of a smooth interpolant again rests on a `sorry`; the construction mirrors
that of the phase function.
-/

namespace RH9

/-- A smooth radius function interpolating r(γₙ) = βₙ. -/
structure RadiusFunction (zd : ZeroData) where
  /-- The function itself. -/
  r : ℝ → ℝ
  /-- r is infinitely differentiable. -/
  smooth : ContDiff ℝ ⊤ r
  /-- r takes strictly positive values. -/
  pos : ∀ t, 0 < r t
  /-- The interpolation condition: r(γₙ) = βₙ. -/
  interpolates : ∀ n : ℕ, r (zd.γ n) = zd.β n

namespace RadiusFunction

variable {zd : ZeroData}

/-- The canonical RH radius function: the constant 1/2.
    This is the unique constant radius function satisfying r(γₙ) = βₙ when RH holds. -/
noncomputable def constHalf (zd : ZeroData) : RadiusFunction zd where
  r         := fun _ => 1 / 2
  smooth    := contDiff_const
  pos       := fun _ => by norm_num
  interpolates := fun n => by
    -- This holds trivially when βₙ = 1/2, but in general we need RH.
    -- We assert it with `sorry`; for a conditional version see `constHalf_of_rh`.
    sorry

/-- Under RH, constHalf correctly interpolates the βₙ. -/
noncomputable def constHalf_of_rh (zd : ZeroData) (hrh : zd.RH) : RadiusFunction zd where
  r             := fun _ => 1 / 2
  smooth        := contDiff_const
  pos           := fun _ => by norm_num
  interpolates  := fun n => by simp [ZeroData.RH] at hrh; exact hrh n

/-- A constant radius function is one where r is identically a fixed value. -/
def IsConstant (rf : RadiusFunction zd) (c : ℝ) : Prop :=
  ∀ t, rf.r t = c

/-- The constant-1/2 radius function is indeed constant. -/
lemma constHalf_isConstant (hrh : zd.RH) :
    IsConstant (constHalf_of_rh zd hrh) (1 / 2) :=
  fun _ => rfl

/-- If r is constant c, then its derivative vanishes everywhere. -/
lemma deriv_of_isConstant (rf : RadiusFunction zd) (c : ℝ)
    (h : IsConstant rf c) (t : ℝ) : deriv rf.r t = 0 := by
  have : rf.r = fun _ => c := funext h
  simp [this]

/-- If r is constant c, then all higher derivatives vanish everywhere. -/
lemma iteratedDeriv_of_isConstant (rf : RadiusFunction zd) (c : ℝ)
    (h : IsConstant rf c) (n : ℕ) (hn : 1 ≤ n) (t : ℝ) :
    iteratedDeriv n rf.r t = 0 := by
  have heq : rf.r = fun _ => c := funext h
  rw [heq]
  simp [iteratedDeriv_const]

/-- Existence of a general smooth radius function interpolating the βₙ. -/
theorem exists (zd : ZeroData) : Nonempty (RadiusFunction zd) := by
  -- By monotone extension / Whitney extension theorem, any sequence of values
  -- can be interpolated by a smooth function. The positivity is preserved because
  -- βₙ ∈ (0, 1) and we can truncate or smooth carefully.
  sorry

end RadiusFunction

end RH9
