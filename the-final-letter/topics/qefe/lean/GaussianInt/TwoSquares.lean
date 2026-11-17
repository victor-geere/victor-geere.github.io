import Mathlib
import GaussianInt.IdealCount

/-!
# Two squares from ideal counts in `ℤ[i]`

Standalone, Mathlib-only extraction of declarations T129, T136, T137, T199 of
`Topic.lean`.  This file holds the only QEFE-specific material in the extracted
library: the representation count `r2 n` and the named statement
`TwoSquaresFormula`.

The capstone is `twoSquaresFormula`:
`r₂(n) = 4 * Σ_{d ∣ n} χ₄(d)` for every `n ≥ 1`, derived from
`idealCountFormula` (T198) in the previous module rather than assumed.
-/

noncomputable section

open scoped BigOperators

namespace GaussianInt

/-- The number of ordered integer pairs `(x,y)` with `x² + y² = n`. -/
def r2 (n : ℕ) : ℕ :=
  (((Finset.Icc (-(n:ℤ)) (n:ℤ)).product (Finset.Icc (-(n:ℤ)) (n:ℤ))).filter
    (fun p : ℤ × ℤ => p.1^2 + p.2^2 = (n:ℤ))).card

/-- Named arithmetic input: the two-squares representation count. -/
def TwoSquaresFormula : Prop :=
  ∀ n : ℕ, 1 ≤ n → (r2 n : ℤ) = 4 * divisorSumChi4 n


lemma r2_eq_natCard_pairs (n : ℕ) :
    r2 n = Nat.card {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := by
  let S : Finset (ℤ × ℤ) :=
    (Finset.Icc (-(n:ℤ)) (n:ℤ)).product (Finset.Icc (-(n:ℤ)) (n:ℤ))
  have hfin : ∀ p : ℤ × ℤ, p.1^2 + p.2^2 = (n:ℤ) → p ∈ S := by
    intro p hp
    dsimp only [S]
    refine Finset.mem_product.mpr ⟨?_, ?_⟩
    · rw [Finset.mem_Icc]
      constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
    · rw [Finset.mem_Icc]
      constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
  have hSfin : ({p : ℤ × ℤ | p ∈ S} : Set (ℤ × ℤ)).Finite := S.finite_toSet
  have hfinS : ({p : ℤ × ℤ | p.1^2 + p.2^2 = (n:ℤ)} : Set (ℤ × ℤ)).Finite :=
    hSfin.subset (fun p hp => hfin p hp)
  letI : Fintype {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := hfinS.fintype
  rw [Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype (S.filter (fun p => p.1^2 + p.2^2 = (n:ℤ))) (by
    intro p
    rw [Finset.mem_filter]
    constructor
    · intro hp; exact hp.2
    · intro hp; exact ⟨hfin p hp, hp⟩)]
  unfold r2
  dsimp [S]

/-- **T129:** `r2 n` is the number of Gaussian integers of norm `n`. -/
lemma r2_eq_natCard_gaussian (n : ℕ) :
    r2 n = Nat.card {z : GaussianInt // z.norm.natAbs = n} := by
  rw [r2_eq_natCard_pairs, Nat.card_congr (pairGaussianEquiv n)]

/-- **T136:** `r2 n` is four times the number of ideals of norm `n`. -/
theorem r2_eq_four_mul_idealCount (n : ℕ) (hn : 0 < n) :
    r2 n = 4 * Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} := by
  rw [r2_eq_natCard_gaussian, normElements_card_eq_four_mul_idealCount n hn]

/-- **T137:** the two-squares formula follows from the ideal-count formula. -/
theorem twoSquaresFormula_of_idealCount (h : IdealCountFormula) : TwoSquaresFormula := by
  intro n hn
  have h4 := r2_eq_four_mul_idealCount n (Nat.pos_of_ne_zero (by omega))
  rw [h4]
  push_cast
  have hc := h n hn
  rw [hc]

/-- **T199:** the two-squares formula, unconditional. -/
theorem twoSquaresFormula : TwoSquaresFormula :=
  twoSquaresFormula_of_idealCount idealCountFormula

end GaussianInt
