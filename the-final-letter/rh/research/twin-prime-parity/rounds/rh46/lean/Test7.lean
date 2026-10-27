import Mathlib
namespace Rh46
noncomputable section
open scoped BigOperators ArithmeticFunction.Omega

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n
def liouville (n : ℕ) : ℤ := (-1) ^ Omega n
def liouvilleSlice (a n : ℕ) : ℤ := if n = a then -liouville a else liouville n

@[simp] theorem slice_self (a : ℕ) : liouvilleSlice a a = -liouville a := by
  rw [liouvilleSlice, ite_eq_left rfl]

theorem slice_agree {a n : ℕ} (hn : n < a) : liouvilleSlice a n = liouville n := by
  rw [liouvilleSlice, ite_eq_right (Nat.ne_of_lt hn)]

/-- Pointwise perturbation identity (correct signs). -/
theorem corrSlice_sub_corr_pointwise (h a n : ℕ) (hh : h ≠ 0) :
    liouvilleSlice a n * liouvilleSlice a (n + h) - liouville n * liouville (n + h) =
      (if n = a + h then -2 * (liouville a * liouville (a + h)) else 0) +
      (if n + h = a then liouville a * liouville (a - h) else 0) := by
  have hpos : 0 < h := Nat.pos_of_ne_zero hh
  have hlt : a < a + h := Nat.lt_add_of_pos_right hpos
  by_cases H1 : n = a
  · subst H1
    have hne : ¬ (a + h = a) := Nat.ne_of_gt hlt
    have e2 : liouvilleSlice a (a + h) = liouville (a + h) := slice_agree hlt
    rw [slice_self, e2, ite_eq_right hne, ite_eq_right hne]
    ring
  · by_cases H2 : n + h = a
    · have hlt2 : n < a := by omega
      have hsub : a - h = n := by omega
      have e1 : liouvilleSlice a n = liouville n := slice_agree hlt2
      have e2 : liouvilleSlice a (n + h) = liouville a := by rw [H2, slice_self]
      rw [e1, e2, ite_eq_right (by omega : ¬ n = a + h), ite_eq_left H2]
      rw [hsub]
      ring
    · by_cases H3 : n = a + h
      · have hne : ¬ (a + h + h = a) := by omega
        have e1 : liouvilleSlice a (a + h) = liouville (a + h) := slice_agree hlt
        rw [H3, slice_self, e1, hne, ite_eq_left rfl, ite_eq_right hne]
        ring
      · have h1' : n < a := by omega
        have h2' : a < n + h := by omega
        rw [slice_agree h1', slice_agree h2', ite_eq_right H3, ite_eq_right H2, add_zero,
          sub_self]

end
end Rh46
