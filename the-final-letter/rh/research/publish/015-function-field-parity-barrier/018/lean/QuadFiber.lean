/-
  QuadFiber.lean — round 21 of the new programme (Target A)

  The `p = 0` quadratic-factor image `q ↦ q(a2 − q)` has fibers of size at
  most 2: two distinct `q, r` with the same value satisfy `q + r = a2`.
-/
import Mathlib

namespace QuadFiber

/-- Fibers of `q ↦ q(a₂−q)` have size at most two. -/
theorem quad_fiber {K : Type*} [Field K] (a2 q r : K)
    (h : q * (a2 - q) = r * (a2 - r)) (hqr : q ≠ r) : q + r = a2 := by
  have h1 : (q - r) * (a2 - (q + r)) = 0 := by linear_combination h
  have h2 : q - r ≠ 0 := sub_ne_zero.mpr hqr
  rcases mul_eq_zero.mp h1 with h3 | h3
  · exact absurd h3 h2
  · exact (sub_eq_zero.mp h3).symm

end QuadFiber
