import Mathlib

/-!
# Certified-zero logic (harvested Route A/B)

This file ports the Route A/B certification logic from `~/workspace/rh`
(`Rh45/Routes.lean`) into the geometric-DQPT programme:

* a sign change plus a strictly positive derivative gives a unique simple zero;
* if certified zeros are a subset of the zeros in a window and the window has
  at most as many zeros as certificates, then the two sets agree.

The second theorem is the finite isolation/counting step needed by O4.
-/

noncomputable section

open Set

namespace GeoDQPT

/-- Route A: a continuous function with a sign change and strictly positive
derivative on the interior has a unique simple zero. -/
theorem exists_unique_root_of_sign_change
    {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Icc a b))
    (hf' : ∀ x ∈ Ioo a b, 0 < deriv f x)
    (ha : f a < 0) (hb : 0 < f b) :
    ∃ x, x ∈ Ioo a b ∧ f x = 0 ∧ 0 < deriv f x ∧
      ∀ y, y ∈ Ioo a b → f y = 0 → y = x := by
  have hmem : (0 : ℝ) ∈ Icc (f a) (f b) := ⟨ha.le, hb.le⟩
  obtain ⟨x, hx, hfx⟩ := intermediate_value_Icc hab.le hf hmem
  have hxIoo : x ∈ Ioo a b := by
    rcases hx with ⟨hax, hxb⟩
    refine ⟨lt_of_le_of_ne hax ?_, lt_of_le_of_ne hxb ?_⟩
    · rintro rfl; exact absurd hfx (ne_of_lt ha)
    · rintro rfl; exact absurd hfx (ne_of_gt hb)
  have hmono : StrictMonoOn f (Icc a b) := by
    refine strictMonoOn_of_deriv_pos (convex_Icc a b) hf ?_
    intro z hz
    exact hf' z (by simpa [interior_Icc] using hz)
  refine ⟨x, hxIoo, hfx, hf' x hxIoo, ?_⟩
  intro y hy hy0
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · have h := hmono (Ioo_subset_Icc_self hy) (Ioo_subset_Icc_self hxIoo) hlt
    rw [hy0, hfx] at h
    exact lt_irrefl (0 : ℝ) h
  · have h := hmono (Ioo_subset_Icc_self hxIoo) (Ioo_subset_Icc_self hy) hgt
    rw [hy0, hfx] at h
    exact lt_irrefl (0 : ℝ) h

/-- Route B: if certified zeros are contained in the window zeros and the
window has at most as many zeros as certificates, the sets agree. -/
theorem turing_reduction {α : Type*} [DecidableEq α] {zeros certified : Finset α}
    (hsub : certified ⊆ zeros) (hcard : zeros.card ≤ certified.card) :
    zeros = certified :=
  (Finset.eq_of_subset_of_card_le hsub hcard).symm

/-- Route B, packaged: every zero in the window is certified. -/
theorem all_zeros_are_certified {α : Type*} [DecidableEq α]
    {zeros certified : Finset α}
    (hsub : certified ⊆ zeros) (hcard : zeros.card ≤ certified.card) :
    ∀ z ∈ zeros, z ∈ certified := by
  intro z hz
  rw [turing_reduction hsub hcard] at hz
  exact hz

/-- O4 isolation wrapper: a certified set that meets the window count exhausts
the window. This is the finite logical content of the isolation clause. -/
structure IsolationCertificate (α : Type*) [DecidableEq α] where
  zeros : Finset α
  certified : Finset α
  subset : certified ⊆ zeros
  card_le : zeros.card ≤ certified.card

theorem IsolationCertificate.exhausts {α : Type*} [DecidableEq α]
    (C : IsolationCertificate α) : ∀ z ∈ C.zeros, z ∈ C.certified :=
  all_zeros_are_certified C.subset C.card_le

end GeoDQPT
