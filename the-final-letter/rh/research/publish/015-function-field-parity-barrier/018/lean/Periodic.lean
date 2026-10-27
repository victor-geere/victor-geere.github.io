/-
  Periodic.lean — new goal round 3 (Target C)

  A divisor sum with bounded support is periodic: if `d ∣ L` for every `d` in a
  finite set `S`, then

      Σ_{d ∈ S, d ∣ n} g d  =  Σ_{d ∈ S, d ∣ n + L} g d .

  This is the algebraic core of the parity barrier: every Selberg-type sieve
  weight is such a periodic sum.
-/
import Mathlib

namespace Periodic

/-- Bounded-support divisor sums are periodic with a common multiple period. -/
theorem divisor_sum_periodic {S : Finset ℕ} {L : ℕ} (hL : ∀ d ∈ S, d ∣ L)
    (g : ℕ → ℝ) (n : ℕ) :
    (S.filter (fun d => d ∣ n)).sum g = (S.filter (fun d => d ∣ n + L)).sum g := by
  apply Finset.sum_congr _ (fun d _ => rfl)
  ext d
  simp only [Finset.mem_filter]
  constructor
  · rintro ⟨hd, hdn⟩
    exact ⟨hd, dvd_add hdn (hL d hd)⟩
  · rintro ⟨hd, hdnL⟩
    exact ⟨hd, by rw [← Nat.add_sub_cancel n L]; exact Nat.dvd_sub hdnL (hL d hd)⟩

end Periodic
