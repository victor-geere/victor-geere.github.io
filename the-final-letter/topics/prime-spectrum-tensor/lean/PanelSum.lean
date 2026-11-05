import Mathlib
import PanelAssembly

/-!
# R2 — the panel-sum error

If each panel integral is approximated by `qmid p · (b−a) · w(mid)` with error at
most `E p`, then the whole integral over `[a 0, a P]` is approximated by the
panel sum with error at most `Σ E p`.  The telescoping is
`intervalIntegral.sum_integral_adjacent_intervals`, so nothing has to be proved
about the partition itself.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- **The panel-sum error.** -/
theorem panel_sum_error {w Ω : ℝ → ℝ} {P : ℕ} {a : ℕ → ℝ}
    (qmid E : ℕ → ℝ)
    (hint : ∀ p < P, IntervalIntegrable (fun x => w x * Ω x) MeasureTheory.volume (a p) (a (p + 1)))
    (hpanel : ∀ p < P,
      |(∫ x in a p..a (p + 1), w x * Ω x) -
        qmid p * ((a (p + 1) - a p) * w ((a p + a (p + 1)) / 2))| ≤ E p) :
    |(∫ x in a 0..a P, w x * Ω x) -
      ∑ p ∈ Finset.range P, qmid p * ((a (p + 1) - a p) * w ((a p + a (p + 1)) / 2))| ≤
      ∑ p ∈ Finset.range P, E p := by
  have htelesc := intervalIntegral.sum_integral_adjacent_intervals
    (f := fun x => w x * Ω x) (a := a) (n := P) hint
  rw [← htelesc, ← Finset.sum_sub_distrib]
  calc |∑ p ∈ Finset.range P,
        ((∫ x in a p..a (p + 1), w x * Ω x) -
          qmid p * ((a (p + 1) - a p) * w ((a p + a (p + 1)) / 2)))|
      ≤ ∑ p ∈ Finset.range P,
        |(∫ x in a p..a (p + 1), w x * Ω x) -
          qmid p * ((a (p + 1) - a p) * w ((a p + a (p + 1)) / 2))| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ p ∈ Finset.range P, E p :=
        Finset.sum_le_sum fun p hp => hpanel p (Finset.mem_range.mp hp)

end PrimeSpectrumTensor

namespace PrimeSpectrumTensor

/-- Splitting an integral over `Ioi 0` at `T ≥ 0`: the finite part is an
interval integral. -/
theorem integral_Ioi_split (f : ℝ → ℝ) {T : ℝ} (hT : 0 ≤ T)
    (hint1 : MeasureTheory.IntegrableOn f (Set.Ioc 0 T))
    (hint2 : MeasureTheory.IntegrableOn f (Set.Ioi T)) :
    ∫ x in Set.Ioi 0, f x = (∫ x in (0)..T, f x) + ∫ x in Set.Ioi T, f x := by
  have hunion : Set.Ioc (0 : ℝ) T ∪ Set.Ioi T = Set.Ioi 0 := by
    ext x
    simp only [Set.mem_union, Set.mem_Ioc, Set.mem_Ioi]
    constructor
    · rintro (⟨h1, h2⟩ | h3)
      · linarith
      · linarith
    · intro h
      by_cases hx : x ≤ T
      · exact Or.inl ⟨h, hx⟩
      · exact Or.inr (by linarith)
  rw [← hunion, MeasureTheory.setIntegral_union (Set.disjoint_left.mpr ?_) measurableSet_Ioi
    hint1 hint2, intervalIntegral.integral_of_le hT]
  intro x h1 h2
  simp only [Set.mem_Ioc] at h1
  simp only [Set.mem_Ioi] at h2
  linarith [h1.2, h2]

end PrimeSpectrumTensor
