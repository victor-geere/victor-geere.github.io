import Mathlib

/-!
# Sum approximation

If two families differ by at most `d p` termwise, their sums differ by at most
`Σ d p`.  This is the generic step the density generator uses to replace the
symbolic node values `w(m_p)` by rational brackets.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- **Sum approximation.** -/
theorem sum_abs_sub_le {P : ℕ} {f g d : ℕ → ℝ}
    (h : ∀ p < P, |f p - g p| ≤ d p) :
    |(∑ p ∈ Finset.range P, f p) - (∑ p ∈ Finset.range P, g p)| ≤
      ∑ p ∈ Finset.range P, d p := by
  rw [← Finset.sum_sub_distrib]
  calc |∑ p ∈ Finset.range P, (f p - g p)|
      ≤ ∑ p ∈ Finset.range P, |f p - g p| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ p ∈ Finset.range P, d p :=
        Finset.sum_le_sum fun p hp => h p (Finset.mem_range.mp hp)

end PrimeSpectrumTensor
