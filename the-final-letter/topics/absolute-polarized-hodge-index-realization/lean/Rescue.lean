import Mathlib

/-!
# Absolute polarized Hodge-index realization — formal rescue core

This file formalises the algebraic statements that the rescue note
(`notes/38-rescue.md`) relies on.  It deliberately contains **no** analytic
claims: the digamma identity, the symbol identity
`A_arch + Q = -Z'/Z(-iξ)`, the explicit formula, and the numerical Gram
matrices are *not* formalised here.  They remain text proofs or computations.

What is checked:

* `kmsForm_nonneg` — the finite KMS Hodge-index positivity of note 03:
  for a faithful diagonal state with weights `p i > 0` and a self-adjoint
  matrix `a`, the form
  `(1/2) ∑ᵢ ∑ⱼ (pᵢ - pⱼ) log(pᵢ/pⱼ) (aᵢⱼ)²`
  is non-negative.
* `compatible_well_defined` — compatibility of a chain of forms makes the
  limit form well defined (Lemma 2.1 of the rescue note).
* `compatible_nonneg` — non-negativity passes to the union under
  compatibility and level-wise non-negativity.
* `badB_not_compatible` — a concrete level-dependent form for which
  compatibility fails, so the hypothesis is not vacuous.
* `hodge_sign_iff` — the sign convention `s = -W` turns the geometric
  Hodge-index inequality `s ≤ 0` into Weil positivity `0 ≤ W`.
-/

namespace AbsoluteHodgeRescue

open scoped BigOperators

/-! ## 1. The finite KMS form -/

/-- The finite KMS form of note 03 for a faithful diagonal state with weights
`p i > 0` and a self-adjoint matrix `a`. -/
noncomputable def kmsForm {ι : Type*} [Fintype ι] (p : ι → ℝ) (a : ι → ι → ℝ) : ℝ :=
  (1 / 2) * ∑ i, ∑ j, (p i - p j) * Real.log (p i / p j) * (a i j) ^ 2

/-- Each summand of the KMS form is non-negative.  This is the inequality
`(x - y) log (x / y) ≥ 0` for `x, y > 0`. -/
theorem term_nonneg {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    0 ≤ (x - y) * Real.log (x / y) := by
  rcases le_total y x with h | h
  · have h1 : 0 ≤ x - y := sub_nonneg.mpr h
    have h2 : 0 ≤ Real.log (x / y) := by
      apply Real.log_nonneg
      rw [le_div_iff₀ hy]
      simpa using h
    exact mul_nonneg h1 h2
  · have h1 : x - y ≤ 0 := sub_nonpos.mpr h
    have h2 : Real.log (x / y) ≤ 0 := by
      apply Real.log_nonpos (le_of_lt (div_pos hx hy))
      exact (div_le_one hy).mpr h
    exact mul_nonneg_of_nonpos_of_nonpos h1 h2

/-- Finite KMS Hodge-index positivity (note 03). -/
theorem kmsForm_nonneg {ι : Type*} [Fintype ι] (p : ι → ℝ) (hp : ∀ i, 0 < p i)
    (a : ι → ι → ℝ) :
    0 ≤ kmsForm p a := by
  unfold kmsForm
  apply mul_nonneg
  · norm_num
  · apply Finset.sum_nonneg
    intro i _
    apply Finset.sum_nonneg
    intro j _
    exact mul_nonneg (term_nonneg (hp i) (hp j)) (sq_nonneg _)

/-- The two-point instance, stated without sums, for readability. -/
theorem kmsForm_two_nonneg {p₀ p₁ : ℝ} (h₀ : 0 < p₀) (h₁ : 0 < p₁)
    (a₀₀ a₀₁ a₁₀ a₁₁ : ℝ) :
    0 ≤ (1 / 2) * ((p₀ - p₀) * Real.log (p₀ / p₀) * a₀₀ ^ 2
      + (p₀ - p₁) * Real.log (p₀ / p₁) * a₀₁ ^ 2
      + (p₁ - p₀) * Real.log (p₁ / p₀) * a₁₀ ^ 2
      + (p₁ - p₁) * Real.log (p₁ / p₁) * a₁₁ ^ 2) := by
  have h01 : 0 ≤ (p₀ - p₁) * Real.log (p₀ / p₁) := term_nonneg h₀ h₁
  have h10 : 0 ≤ (p₁ - p₀) * Real.log (p₁ / p₀) := term_nonneg h₁ h₀
  have hz0 : p₀ - p₀ = 0 := by ring
  have hz1 : p₁ - p₁ = 0 := by ring
  rw [hz0, hz1]
  norm_num
  nlinarith [mul_nonneg h01 (sq_nonneg a₀₁), mul_nonneg h10 (sq_nonneg a₁₀)]

/-! ## 2. Compatible positivity on an inductive union -/

/-- Monotonicity of a chain of subsets. -/
theorem S_mono {α : Type*} {S : ℕ → Set α} (hmono : ∀ n, S n ⊆ S (n + 1)) :
    ∀ {n m : ℕ}, n ≤ m → S n ⊆ S m := by
  intro n m h
  induction m, h using Nat.le_induction with
  | base => exact subset_rfl
  | succ k _ ih => exact ih.trans (hmono k)

/-- Compatibility makes the level-wise form independent of the level. -/
theorem compatible_well_defined {α : Type*} {S : ℕ → Set α} {B : ℕ → α → ℝ}
    (_hmono : ∀ n, S n ⊆ S (n + 1))
    (hcompat : ∀ n m, n ≤ m → ∀ a, a ∈ S n → B m a = B n a)
    {n m : ℕ} {a : α} (hn : a ∈ S n) (hm : a ∈ S m) :
    B n a = B m a := by
  rcases le_total n m with h | h
  · exact (hcompat n m h a hn).symm
  · exact hcompat m n h a hm

/-- Non-negativity passes to the union, and the value is independent of the
level. -/
theorem compatible_nonneg {α : Type*} {S : ℕ → Set α} {B : ℕ → α → ℝ}
    (hmono : ∀ n, S n ⊆ S (n + 1))
    (hcompat : ∀ n m, n ≤ m → ∀ a, a ∈ S n → B m a = B n a)
    (hnonneg : ∀ n a, a ∈ S n → 0 ≤ B n a)
    {n m : ℕ} {a : α} (hn : a ∈ S n) (hm : a ∈ S m) :
    0 ≤ B n a ∧ B n a = B m a :=
  ⟨hnonneg n a hn, compatible_well_defined hmono hcompat hn hm⟩

/-- A level-dependent form on a one-point carrier violates compatibility, so
the compatibility hypothesis of Lemma 2.1 is not automatic. -/
theorem badB_not_compatible :
    ¬ (∀ n m : ℕ, n ≤ m → ∀ _a : Unit,
        (fun n _ => (n : ℝ)) m () = (fun n _ => (n : ℝ)) n ()) := by
  intro h
  have h01 := h 0 1 (Nat.zero_le 1) ()
  norm_num at h01

/-! ## 3. The sign convention -/

/-- With the geometric self-intersection `s = -W`, the geometric Hodge-index
inequality is Weil positivity. -/
theorem hodge_sign_iff (s W : ℝ) (h : s = -W) :
    s ≤ 0 ↔ 0 ≤ W := by
  rw [h]
  constructor <;> intro h' <;> linarith

/-! ## 4. The finite quadratic-form criterion used by the Gram tests -/

/-- The quadratic form of a symmetric matrix `G` on a vector `v`. -/
noncomputable def quadForm {ι : Type*} [Fintype ι] (G : ι → ι → ℝ) (v : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, v i * G i j * v j

/-- A negative direction refutes positive semidefiniteness.  This is the finite
algebra behind the numerical Gram-matrix rejects. -/
theorem not_nonneg_of_quadForm_neg {ι : Type*} [Fintype ι]
    {G : ι → ι → ℝ} {v : ι → ℝ} (h : quadForm G v < 0) :
    ¬ (∀ w, 0 ≤ quadForm G w) := by
  intro hpos
  exact (not_le_of_gt h) (hpos v)

/-- The 2×2 matrix `!![1, 2; 2, 1]` is not positive semidefinite: the vector
`(1, -1)` gives value `-2`. -/
def G2 : Fin 2 → Fin 2 → ℝ
  | 0, 0 => 1
  | 0, 1 => 2
  | 1, 0 => 2
  | 1, 1 => 1

def v2 : Fin 2 → ℝ
  | 0 => 1
  | 1 => -1

theorem G2_not_psd : ¬ (∀ w : Fin 2 → ℝ, 0 ≤ quadForm G2 w) := by
  apply not_nonneg_of_quadForm_neg (v := v2)
  simp [quadForm, G2, v2, Fin.sum_univ_two]
  norm_num


/-! ## 5. The tensor-factor reduction

The reduced form first collapses the Kronecker delta of the embedding
`a ↦ a ⊗ 1`; `kmsFormTensorDelta_eq` then proves the full matrix-level
identity with the delta present, and `kmsFormTensorDelta_eq_kmsForm` gives
`B(a ⊗ 1, a ⊗ 1) = B(a, a)` for a normalised fibre state.
-/

/-- The KMS form after summing over a fibre index with weights `ω`. -/
noncomputable def kmsFormTensor {ι κ : Type*} [Fintype ι] [Fintype κ]
    (p : ι → ℝ) (ω : κ → ℝ) (a : ι → ι → ℝ) : ℝ :=
  (1 / 2) * ∑ i, ∑ j, ∑ α, (p i - p j) * Real.log (p i / p j) * (a i j) ^ 2 * ω α

/-- The fibre sum factorises: `kmsFormTensor p ω a = kmsForm p a * ∑ α, ω α`. -/
theorem kmsFormTensor_eq {ι κ : Type*} [Fintype ι] [Fintype κ]
    (p : ι → ℝ) (ω : κ → ℝ) (a : ι → ι → ℝ) :
    kmsFormTensor p ω a = kmsForm p a * (∑ α, ω α) := by
  set c : ι → ι → ℝ := fun i j => (p i - p j) * Real.log (p i / p j) * (a i j) ^ 2
  unfold kmsFormTensor kmsForm
  change (1 / 2) * ∑ i, ∑ j, ∑ α, c i j * ω α
      = (1 / 2) * (∑ i, ∑ j, c i j) * ∑ α, ω α
  have h1 : (∑ i, ∑ j, ∑ α, c i j * ω α)
      = ∑ i, ∑ j, c i j * (∑ α, ω α) := by
    apply Finset.sum_congr rfl; intro i _
    apply Finset.sum_congr rfl; intro j _
    rw [Finset.mul_sum]
  rw [h1]
  have h2 : (∑ i, ∑ j, c i j * (∑ α, ω α))
      = ∑ i, (∑ j, c i j) * (∑ α, ω α) := by
    apply Finset.sum_congr rfl; intro i _
    rw [Finset.sum_mul]
  rw [h2]
  have h3 : (∑ i, (∑ j, c i j) * (∑ α, ω α))
      = (∑ i, ∑ j, c i j) * (∑ α, ω α) := by
    rw [Finset.sum_mul]
  rw [h3]
  ring

/-- With a normalised fibre state, the tensor form equals the base form. -/
theorem kmsFormTensor_eq_of_sum_one {ι κ : Type*} [Fintype ι] [Fintype κ]
    (p : ι → ℝ) (ω : κ → ℝ) (a : ι → ι → ℝ) (hω : ∑ α, ω α = 1) :
    kmsFormTensor p ω a = kmsForm p a := by
  rw [kmsFormTensor_eq, hω, mul_one]

/-- Full tensor form with the Kronecker delta of `a ↦ a ⊗ 1`. -/
noncomputable def kmsFormTensorDelta {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq κ]
    (p : ι → ℝ) (ω : κ → ℝ) (a : ι → ι → ℝ) : ℝ :=
  (1 / 2) * ∑ i, ∑ j, ∑ α, ∑ β,
    (p i * ω α - p j * ω β) *
      Real.log ((p i * ω α) / (p j * ω β)) *
      (a i j * (if α = β then (1 : ℝ) else 0)) ^ 2

theorem kmsFormTensorDelta_eq {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq κ]
    (p : ι → ℝ) (ω : κ → ℝ) (hω : ∀ α, 0 < ω α) (a : ι → ι → ℝ) :
    kmsFormTensorDelta p ω a = kmsFormTensor p ω a := by
  unfold kmsFormTensorDelta kmsFormTensor
  congr 1
  apply Finset.sum_congr rfl; intro i _
  apply Finset.sum_congr rfl; intro j _
  apply Finset.sum_congr rfl; intro α _
  rw [Finset.sum_eq_single α]
  · have hw : ω α ≠ 0 := ne_of_gt (hω α)
    rw [mul_div_mul_right _ _ hw]
    have hsub : p i * ω α - p j * ω α = (p i - p j) * ω α := by ring
    rw [hsub]
    have hif : (if α = α then (1 : ℝ) else 0) = 1 := by simp
    rw [hif]
    ring
  · intro β _ hne
    have hif : (if α = β then (1 : ℝ) else 0) = 0 := by simp [Ne.symm hne]
    rw [hif]
    ring
  · intro h
    exact absurd (Finset.mem_univ α) h

theorem kmsFormTensorDelta_eq_kmsForm {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq κ]
    (p : ι → ℝ) (ω : κ → ℝ) (hω : ∀ α, 0 < ω α) (a : ι → ι → ℝ)
    (hsum : ∑ α, ω α = 1) :
    kmsFormTensorDelta p ω a = kmsForm p a := by
  rw [kmsFormTensorDelta_eq p ω hω a, kmsFormTensor_eq, hsum, mul_one]

end AbsoluteHodgeRescue

