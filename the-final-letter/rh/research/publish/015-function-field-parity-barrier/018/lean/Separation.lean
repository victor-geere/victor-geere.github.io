/-
  Separation.lean — 018 round 3

  The "2-D Chebotarev vs 1-D zeros" separation, finite core.

  A *world* is an abstract finite set `S` of qrimes, together with a degree
  function `deg` and a shift `τ` (the map `f ↦ f + 2`).  The *zeta datum* of
  `S` is the sequence `Z(S)(n) = #{f ∈ S : deg f = n}`; by the Euler product
  and Möbius inversion (see `Mobius.lean`) this is exactly what `ζ` sees.  The
  *twin count* is `B(S) = #{f ∈ S : τ f ∈ S}`.

  `no_zeta_observable` is the separation: if two worlds share a zeta datum but
  have different twin counts, then no function `Φ` computes `B` from `Z`.

  The witness is over `𝔽₇`, degree 2.  The four quadratics
      x²+1, x²+3x+1, x²+4x+1, x²+3x+6      (twin count 1)
      x²+1, x²+3x+1, x²+4x+1, x²+2         (twin count 0)
  are all monic irreducibles of degree 2, so `Z(S) = Z(T) = (0,4,0,…)`; the
  two worlds differ only by swapping `x²+3x+6` for `x²+2`, and the twin count
  changes.  Hence the pair statistic is not a zeta statistic.
-/
import Mathlib

namespace Separation

instance : Fact (Nat.Prime 7) := ⟨by norm_num⟩

/-! ## Abstract worlds -/

variable {α : Type*}

/-- The zeta datum: the number of world-members of each degree.  For the true
world (`S` = all monic irreducibles) this is `I(n)`, and the Euler product of
`ζ` determines exactly this sequence. -/
def zetaDatum (deg : α → ℕ) (S : Finset α) : ℕ → ℕ :=
  fun n => (S.filter (fun a => deg a = n)).card

/-- The twin count: `f` contributes when `f + 2` is also in the world. -/
def twinCount [DecidableEq α] (τ : α → α) (S : Finset α) : ℕ :=
  (S.filter (fun a => τ a ∈ S)).card

/-- **The separation theorem.**  If two worlds have the same zeta datum and
different twin counts, then the twin count is not a function of the zeta datum:
no `Φ : (ℕ → ℕ) → ℕ` computes `B` from `Z` for all worlds. -/
theorem no_zeta_observable [DecidableEq α] (deg : α → ℕ) (τ : α → α) (S T : Finset α)
    (hZ : zetaDatum deg S = zetaDatum deg T)
    (hB : twinCount τ S ≠ twinCount τ T) :
    ¬ ∃ Φ : (ℕ → ℕ) → ℕ, ∀ U : Finset α, twinCount τ U = Φ (zetaDatum deg U) := by
  rintro ⟨Φ, hΦ⟩
  exact hB (by rw [hΦ S, hΦ T, hZ])

/-! ## The concrete witness over `𝔽₇` -/

open Polynomial

/-- A monic quadratic `x² + b x + c` over `ZMod 7`, from its two free coefficients. -/
noncomputable def quad (p : ZMod 7 × ZMod 7) : (ZMod 7)[X] :=
  X ^ 2 + C p.1 * X + C p.2

/-- The map `f ↦ f + 2` on monic quadratics: shift the constant coefficient. -/
def twin (p : ZMod 7 × ZMod 7) : ZMod 7 × ZMod 7 := (p.1, p.2 + 2)

/-- A monic quadratic over a field with no root is irreducible. -/
theorem irreducible_quad_of_noRoot {K : Type*} [Field K] (b c : K)
    (h : ∀ x : K, x ^ 2 + b * x + c ≠ 0) :
    Irreducible (X ^ 2 + C b * X + C c : K[X]) := by
  apply Polynomial.irreducible_of_degree_le_three_of_not_isRoot
  · have hdeg : natDegree (X ^ 2 + C b * X + C c : K[X]) = 2 := by compute_degree!
    rw [Finset.mem_Icc, hdeg]
    norm_num
  · intro x hx
    exact h x (by simpa [Polynomial.IsRoot] using hx)

/-- The first world: four genuine monic irreducible quadratics over `𝔽₇`. -/
def S : Finset (ZMod 7 × ZMod 7) := {(0, 1), (3, 1), (4, 1), (3, 6)}

/-- The second world: four genuine monic irreducible quadratics over `𝔽₇`. -/
def T : Finset (ZMod 7 × ZMod 7) := {(0, 1), (3, 1), (4, 1), (0, 2)}

/-- `S ∪ T` written out (the two worlds share three quadratics). -/
def ST : Finset (ZMod 7 × ZMod 7) := {(0, 1), (3, 1), (4, 1), (3, 6), (0, 2)}

theorem ST_eq : S ∪ T = ST := by decide

/-- Every element of `S ∪ T` has no root (finite check). -/
theorem witness_noRoot :
    ∀ p : ZMod 7 × ZMod 7, p ∈ ST → ∀ x : ZMod 7, x ^ 2 + p.1 * x + p.2 ≠ 0 := by
  decide

/-- Every element of `S ∪ T` is irreducible: all eight witness polynomials are
genuine qrimes. -/
theorem witness_irreducible : ∀ p : ZMod 7 × ZMod 7, p ∈ ST → Irreducible (quad p) := by
  intro p hp
  exact irreducible_quad_of_noRoot p.1 p.2 (witness_noRoot p hp)

/-- `S` and `T` have the same zeta datum: four qrimes, all of degree 2. -/
theorem witness_zeta_equal :
    zetaDatum (fun _ : ZMod 7 × ZMod 7 => 2) S
      = zetaDatum (fun _ : ZMod 7 × ZMod 7 => 2) T := by
  funext n
  by_cases h : n = 2
  · subst h; decide
  · simp [zetaDatum, Ne.symm h]

/-- `S` and `T` have different twin counts: `1` versus `0`. -/
theorem witness_twin_diff : twinCount twin S ≠ twinCount twin T := by
  decide

/-- **The separation, over `𝔽₇`.**  No function of the zeta datum computes the
twin count, even when every world consists of genuine monic irreducibles. -/
theorem separation_F7 :
    ¬ ∃ Φ : (ℕ → ℕ) → ℕ, ∀ U : Finset (ZMod 7 × ZMod 7),
      twinCount twin U = Φ (zetaDatum (fun _ => 2) U) :=
  no_zeta_observable (fun _ => 2) twin S T witness_zeta_equal witness_twin_diff

end Separation
