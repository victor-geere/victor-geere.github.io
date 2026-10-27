/-
  NonPeriodic.lean — new goal round 3 (Target C)

  The twin indicator is **not** periodic with any period `L ≥ 1`: iterating a
  period would give `twinInd 3 = twinInd (3 + 3L)`, but `3` is a twin and
  `3 + 3L = 3(1+L)` is composite.

  Combined with `Periodic.divisor_sum_periodic`, this proves unconditionally
  that the twin indicator is not a bounded-support divisor sum — the algebraic
  content of the parity barrier.
-/
import Mathlib
import Barrier
import Periodic

namespace NonPeriodic

/-- The twin indicator is not periodic with period `L ≥ 1`. -/
theorem twinInd_not_periodic (L : ℕ) (hL : 1 ≤ L) :
    ¬ (∀ n, Barrier.twinInd n = Barrier.twinInd (n + L)) := by
  intro h
  have hk : ∀ k : ℕ, Barrier.twinInd 3 = Barrier.twinInd (3 + k * L) := by
    intro k
    induction k with
    | zero => simp
    | succ k ih =>
        rw [ih, h]
        congr 1
        ring
  have h3 := hk 3
  have h1 : Barrier.twinInd 3 = 1 := by decide
  have h2 : Barrier.twinInd (3 + 3 * L) = 0 := by
    have hdiv : 3 ∣ 3 + 3 * L := ⟨1 + L, by ring⟩
    have hgt : 3 < 3 + 3 * L := by nlinarith
    have hnp : ¬ (3 + 3 * L).Prime := by
      intro hp
      have heq : 3 + 3 * L = 3 :=
        (hp.dvd_iff_eq (by norm_num : (3 : ℕ) ≠ 1)).mp hdiv
      omega
    simp [Barrier.twinInd, hnp]
  rw [h1, h2] at h3
  simp at h3

/-- **The twin indicator is not a bounded-support divisor sum.**

If `S` is a finite set of divisors with common multiple `L ≥ 1`, then no
coefficient function `g` satisfies `twinInd n = Σ_{d ∈ S, d ∣ n} g d` for all
`n`.  (The sum is `L`-periodic; the twin indicator is not.) -/
theorem twinInd_not_divisor_sum {S : Finset ℕ} {L : ℕ} (hL : ∀ d ∈ S, d ∣ L) (hpos : 1 ≤ L)
    (g : ℕ → ℝ) :
    ¬ ∀ n, (Barrier.twinInd n : ℝ) = (S.filter (fun d => d ∣ n)).sum g := by
  intro h
  apply twinInd_not_periodic L hpos
  intro n
  have h1 : (Barrier.twinInd n : ℝ) = (Barrier.twinInd (n + L) : ℝ) := by
    calc (Barrier.twinInd n : ℝ) = (S.filter (fun d => d ∣ n)).sum g := h n
      _ = (S.filter (fun d => d ∣ n + L)).sum g := Periodic.divisor_sum_periodic hL g n
      _ = (Barrier.twinInd (n + L) : ℝ) := (h (n + L)).symm
  exact_mod_cast h1

end NonPeriodic
