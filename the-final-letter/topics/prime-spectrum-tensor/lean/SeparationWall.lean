import Mathlib

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The five certified separations `0, 1/5, 2/5, 3/5, 4/5`. -/
def certifiedSeparations : Finset ℝ := {0, 1 / 5, 2 / 5, 3 / 5, 4 / 5}

/-- **The separation wall.**  Six distinct real centres cannot have all their
pairwise distances among the five certified separations `0, 1/5, …, 4/5`.
Hence a 6×6 Gaussian Gram certificate at this spacing necessarily needs a *new*
separation certificate. -/
theorem six_centres_separation_wall (c : Fin 6 → ℝ) (hinj : Function.Injective c)
    (h : ∀ i j, |c i - c j| ∈ certifiedSeparations) : False := by
  classical
  obtain ⟨i0, -, hmin⟩ := Finset.exists_min_image (Finset.univ : Finset (Fin 6)) c
    Finset.univ_nonempty
  have hmem : ∀ i, c i - c i0 ∈ certifiedSeparations := by
    intro i
    have h1 := h i i0
    have h2 : 0 ≤ c i - c i0 := sub_nonneg.mpr (hmin i (Finset.mem_univ i))
    rwa [abs_of_nonneg h2] at h1
  have hinj' : Function.Injective
      (fun i : Fin 6 => (⟨c i - c i0, hmem i⟩ : {x // x ∈ certifiedSeparations})) := by
    intro i j hij
    have h2 : c i - c i0 = c j - c i0 := Subtype.ext_iff.mp hij
    exact hinj (by linarith)
  have hcard : Fintype.card (Fin 6) ≤ certifiedSeparations.card := by
    have := Fintype.card_le_of_injective _ hinj'
    simpa using this
  norm_num [certifiedSeparations] at hcard

end PrimeSpectrumTensor
