import Mathlib
open scoped BigOperators ArithmeticFunction.Omega
namespace Rh46
noncomputable section

theorem sum_ite_indicator2 {s : Finset ℕ} {a : ℕ} {g : ℤ} (h : a ∈ s) :
    (∑ n ∈ s, if n = a then g else 0) = g := by
  rw [Finset.sum_ite_eq' s a (fun _ => g)]
  exact ite_eq_left h

example (a : ℕ) (ha : 2 ≤ a) (g : ℤ) :
    (∑ n ∈ Finset.Icc 1 a, if n + 2 = a then g else 0) = g := by
  have hmem : a - 2 ∈ Finset.Icc 1 a :=
    Finset.mem_Icc.mpr ⟨by omega, by omega⟩
  refine (Finset.sum_eq_single (a - 2) ?_ ?_).trans ?_
  · intro b hb hne
    rw [ite_eq_right]
    exact fun hcon => hne (by omega)
  · intro hnot
    exact absurd hmem hnot
  · rw [ite_eq_left]
    show (a - 2) + 2 = a
    omega
  · exact mul_one g

/-- The single-index indicator. -/
example (a : ℕ) (ha : 1 ≤ a) (g : ℤ) :
    (∑ n ∈ Finset.Icc 1 a, if n = a then g else 0) = g :=
  sum_ite_indicator2 (Finset.mem_Icc.mpr ⟨ha, le_rfl⟩)

theorem two_sq_one_ne {u v : ℤ} (h1 : u ^ 2 = 1) (h2 : v ^ 2 = 1) (h : u - v ≠ 0) : False := by
  have h3 : (u - v) * (u + v) = 0 := by nlinarith
  rcases mul_eq_zero.mp h3 with h4 | h4
  · exact h (by linarith)
  · have huv : u = -v := by linarith
    have hv : v ≠ 0 := by
      intro hv0
      rw [hv0] at h2
      norm_num at h2
    rw [huv] at h
    exact h (by ring_nf; omega)

end
end Rh46
