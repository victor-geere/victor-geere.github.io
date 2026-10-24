import Mathlib
open scoped BigOperators ArithmeticFunction.Omega
namespace Rh46
noncomputable section

/-- Helper: indicator sum over a range. -/
theorem sum_ite_indicator {s : Finset ℕ} {a : ℕ} {f : ℕ → ℤ} (h : a ∈ s) :
    (∑ n ∈ s, if n = a then f n else 0) = f a := by
  rw [Finset.sum_ite_eq' s a f]
  exact if_pos h

theorem sum_ite_indicator2 {s : Finset ℕ} {a : ℕ} {g : ℤ} (h : a ∈ s) :
    (∑ n ∈ s, if n = a then g else 0) = g := by
  rw [Finset.sum_ite_eq' s a (fun _ => g)]
  exact if_pos h

example (a : ℕ) (ha : 1 ≤ a) (f : ℕ → ℤ) :
    (∑ n ∈ Finset.Icc 1 a, if n = a then f n else 0) = f a :=
  sum_ite_indicator (Finset.mem_Icc.mpr ⟨ha, le_rfl⟩)

example (a : ℕ) (ha : 2 ≤ a) (g : ℤ) :
    (∑ n ∈ Finset.Icc 1 a, if n + 2 = a then g else 0) = g := by
  rw [show (∑ n ∈ Finset.Icc 1 a, if n + 2 = a then g else 0) =
      ∑ n ∈ Finset.Icc 1 a, if n = a - 2 then g else 0 from by
    refine Finset.sum_congr rfl fun n hn => ?_
    have hn1 : 1 ≤ n := (Finset.mem_Icc.mp hn).1
    by_cases hc : n + 2 = a
    · rw [if_pos hc, if_pos (by omega)]
    · rw [if_neg hc, if_neg (by omega)]]
  exact sum_ite_indicator2 (Finset.mem_Icc.mpr ⟨by omega, by omega⟩)

/-- Square cancellation: two ±1 integers differing by a nonzero integer differ. -/
example (u v : ℤ) (h1 : u ^ 2 = 1) (h2 : v ^ 2 = 1) (h : u - v ≠ 0) : False := by
  have h3 : (u - v) * (u + v) = 0 := by nlinarith
  rcases mul_eq_zero.mp h3 with h4 | h4
  · exact h (by linarith)
  · have : u = -v := by linarith
    rw [this] at h1
    have : v ^ 2 = 1 := by linarith
    linarith

end
end Rh46
