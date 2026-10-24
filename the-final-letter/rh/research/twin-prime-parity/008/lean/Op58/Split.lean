/-
  Op58/Split.lean — the sum-level reduction R1 and R2.

      S_2(x) = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋) ,            (R1)
      C(K)   = Σ_{k≤K} λ(4k² − 1) ,                     (R2)

  where (as in the shift-2 audit) `S_1` is the shift-ONE correlation
  `Σ λ(m)λ(m+1)`, not the one-point sum.

  Together with `Op58.Defs` this exhibits the open core of the twin-prime
  correlation as a sum of λ over a quadratic polynomial — the object an
  automorphic/spectral input must control.
-/

import Op58.Defs

namespace Op58

noncomputable section

open scoped BigOperators

open Finset ArithmeticFunction

/-- `S_h(x) = Σ_{n≤x} λ(n)λ(n+h)` (the `n = 0` term vanishes). -/
def Sh (h x : ℕ) : ℤ := ∑ n ∈ Finset.range (x + 1), liouville n * liouville (n + h)

/-- `C(K) = Σ_{k≤K} λ(2k−1)λ(2k+1)` (the `k = 0` term vanishes). -/
def Ccore (K : ℕ) : ℤ :=
  ∑ k ∈ Finset.range (K + 1), liouville (2 * k - 1) * liouville (2 * k + 1)

/-- Splitting a range sum into its even and odd indices. -/
theorem sum_range_even_odd (f : ℕ → ℤ) (N : ℕ) :
    (∑ n ∈ Finset.range N, f n)
      = (∑ m ∈ Finset.range ((N + 1) / 2), f (2 * m))
        + (∑ m ∈ Finset.range (N / 2), f (2 * m + 1)) := by
  induction N with
  | zero => simp
  | succ N ih =>
    rw [Finset.sum_range_succ, ih]
    rcases Nat.even_or_odd N with ⟨j, hj⟩ | ⟨j, hj⟩
    · have hj' : N = 2 * j := by omega
      rw [hj']
      rw [show (2 * j + 1) / 2 = j by omega, show (2 * j) / 2 = j by omega,
        show (2 * j + 1 + 1) / 2 = j + 1 by omega]
      simp only [Finset.sum_range_succ]
      ring
    · have hj' : N = 2 * j + 1 := by omega
      rw [hj']
      rw [show (2 * j + 1) / 2 = j by omega, show (2 * j + 1 + 1) / 2 = j + 1 by omega,
        show (2 * j + 1 + 1 + 1) / 2 = j + 1 by omega]
      simp only [Finset.sum_range_succ]
      ring

/-- **(R2)** the odd core is a sum of λ over the quadratic polynomial `4k²−1`. -/
theorem Ccore_eq_poly (K : ℕ) :
    Ccore K = ∑ k ∈ Finset.range (K + 1), liouville (4 * k * k - 1) := by
  unfold Ccore
  refine Finset.sum_congr rfl ?_
  intro k _
  rw [← liouville_pair k, poly_identity k]

/-- **(R1)** the shift-2 correlation splits into the shift-1 correlation and the
odd (quadratic-polynomial) core. -/
theorem Sh2_split (x : ℕ) : Sh 2 x = Sh 1 (x / 2) + Ccore ((x + 1) / 2) := by
  unfold Sh Ccore
  rw [sum_range_even_odd (fun n => liouville n * liouville (n + 2)) (x + 1)]
  congr 1
  · rw [show (x + 1 + 1) / 2 = x / 2 + 1 by omega]
    refine Finset.sum_congr rfl ?_
    intro m _
    exact even_shift m
  · rw [Finset.sum_range_succ' (fun k => liouville (2 * k - 1) * liouville (2 * k + 1))
      ((x + 1) / 2)]
    have h0 : liouville (0 : ℕ) = 0 := by simp
    rw [h0, zero_mul, add_zero]
    refine Finset.sum_congr rfl ?_
    intro k _
    have h1 : 2 * (k + 1) - 1 = 2 * k + 1 := by omega
    have h2 : 2 * (k + 1) + 1 = 2 * k + 1 + 2 := by omega
    rw [h1, h2]

end

end Op58
