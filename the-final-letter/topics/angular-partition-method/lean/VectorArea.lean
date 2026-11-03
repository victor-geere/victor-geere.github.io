import Mathlib
import Topic

/-!
# Vector-valued area field

For an absolutely summable complex sequence `c`, define the complex-valued
vector measure on `ℕ` (with counting measure) by
`vectorArea c A = ∑' n : A, c n`.  This is the vector-valued area field: the
area carried by `n` is `‖c n‖` and its direction is `arg (c n)`.  The file
proves the absolutely convergent case: countable additivity, the total value,
the area bound, and the radius/phase decomposition.
-/

namespace AngularPartition

open MeasureTheory
open scoped Function

/-- The vector-valued area field of a complex sequence, as a vector measure on
`ℕ` with counting measure. -/
noncomputable def vectorArea (c : ℕ → ℂ) : VectorMeasure ℕ ℂ :=
  (Measure.count : Measure ℕ).withDensityᵥ c

/-- The area weight of the `n`-th annulus. -/
noncomputable def areaWeight (c : ℕ → ℂ) (n : ℕ) : ℝ :=
  ‖c n‖

/-- The phase vector of the `n`-th annulus. -/
noncomputable def phaseWeight (c : ℕ → ℂ) (n : ℕ) : ℂ :=
  (areaWeight c n : ℂ) * Complex.exp (Complex.arg (c n) * Complex.I)

/-- The phase vector reconstructs the original complex term. -/
theorem phaseWeight_eq (c : ℕ → ℂ) (n : ℕ) : phaseWeight c n = c n := by
  unfold phaseWeight areaWeight
  exact Complex.norm_mul_exp_arg_mul_I (c n)

/-- Evaluation of the vector area field on a measurable set. -/
theorem vectorArea_apply {c : ℕ → ℂ} (hsum : Summable c) {A : Set ℕ}
    (hA : MeasurableSet A) :
    vectorArea c A = ∑' n : A, c n := by
  have hf : Integrable c (Measure.count : Measure ℕ) :=
    integrable_count_iff.mpr hsum.norm
  rw [vectorArea, MeasureTheory.withDensityᵥ_apply hf hA]
  rw [MeasureTheory.setIntegral_countable c
    (Set.countable_univ.mono (Set.subset_univ A)) hf.integrableOn]
  simp

/-- Countable additivity of the vector area field. -/
theorem vectorArea_iUnion {c : ℕ → ℂ} {A : ℕ → Set ℕ}
    (hA : ∀ i, MeasurableSet (A i)) (hdisj : Pairwise (Disjoint on A)) :
    HasSum (fun i => vectorArea c (A i)) (vectorArea c (⋃ i, A i)) :=
  (vectorArea c).m_iUnion hA hdisj

/-- The total vector area is the complex sum. -/
theorem vectorArea_univ {c : ℕ → ℂ} (hsum : Summable c) :
    vectorArea c Set.univ = ∑' n, c n := by
  rw [vectorArea_apply hsum MeasurableSet.univ]
  simp

/-- The total vector area is the initial point of the phase-carrying coil. -/
theorem vectorArea_univ_eq_ctail {c : ℕ → ℂ} (hsum : Summable c) :
    vectorArea c Set.univ = ctail c 0 := by
  rw [vectorArea_univ hsum]
  simp [ctail]

/-- The total area of the vector field is bounded by the sum of the annulus
areas. -/
theorem norm_vectorArea_univ_le {c : ℕ → ℂ} (hsum : Summable c) :
    ‖vectorArea c Set.univ‖ ≤ ∑' n, ‖c n‖ := by
  rw [vectorArea_univ hsum]
  exact norm_tsum_le_tsum_norm hsum.norm

/-- The vector area field is the sum of the phase vectors of its annuli. -/
theorem vectorArea_eq_phase_sum {c : ℕ → ℂ} (hsum : Summable c) {A : Set ℕ}
    (hA : MeasurableSet A) :
    vectorArea c A = ∑' n : A, phaseWeight c n := by
  rw [vectorArea_apply hsum hA]
  exact tsum_congr (fun n => (phaseWeight_eq c n).symm)

end AngularPartition
