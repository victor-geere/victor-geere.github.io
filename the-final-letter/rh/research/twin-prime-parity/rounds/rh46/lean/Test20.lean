import Mathlib
namespace Rh46
noncomputable section
open scoped BigOperators ArithmeticFunction.Omega

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n
def liouville (n : ℕ) : ℤ := (-1) ^ Omega n
def liouvilleSlice (a n : ℕ) : ℤ := if n = a then -liouville n else liouville n

@[simp] theorem slice_self (a : ℕ) : liouvilleSlice a a = -liouville a := by
  rw [liouvilleSlice, ite_eq_left rfl]

theorem slice_agree {a n : ℕ} (hn : n < a) : liouvilleSlice a n = liouville n := by
  rw [liouvilleSlice, ite_eq_right (Nat.ne_of_lt hn)]

theorem corrSlice_sub_corr_pointwise (h a n : ℕ) (hh : h ≠ 0) :
    liouvilleSlice a n * liouvilleSlice a (n + h) - liouville n * liouville (n + h) =
      (if n = a then -2 * (liouville a * liouville (a + h)) else 0) +
      (if n + h = a then liouville a * liouville (a - h) else 0) := by
  have hsub : ∀ x, x ≠ a → liouvilleSlice a x = liouville x := by
    intro x hx; rw [liouvilleSlice, ite_eq_right hx]
  by_cases H1 : n = a
  · have hne : ¬ (a + h = a) := by omega
    have hs : liouvilleSlice a a = -liouville a := slice_self a
    have hg : liouvilleSlice a (a + h) = liouville (a + h) := hsub (a + h) hne
    rw [H1, hs, hg, ite_eq_left rfl, ite_eq_right hne]
    ring
  · by_cases H2 : n + h = a
    · have hsub' : a - h = n := by omega
      have h2 : liouvilleSlice a (n + h) = -liouville a := by rw [H2, slice_self]
      rw [hsub n H1, h2, ite_eq_right H1, ite_eq_left H2, hsub']
      ring
    · rw [hsub n H1, hsub (n + h) H2, ite_eq_right H1, ite_eq_right H2, add_zero, sub_self]

end
end Rh46
