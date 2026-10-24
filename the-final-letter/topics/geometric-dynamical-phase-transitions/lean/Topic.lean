import Mathlib

/-!
# Geometric dynamical phase transitions — formal core

The source (the-final-letter/geometric-dynamical-phase-transitions/publication.html)
builds finite path sums `eta_N^(N^2)` from the integer filter
`c_m^(N) = 1` if `N ∤ m` and `1 - N` if `N ∣ m`, then passes to finite
tempered measures on the truncated strip.

This file proves only the elementary finite bookkeeping that the construction
actually uses: the quadratic link of Definition 3.1, the two coefficient cases
of Lemma 2.2, mean-zero of the filter over one complete block (Lemma 3.2), the
tempering weight bounds of Definition 2.4, and the trivial finite atomic-mass
bound of Definition 8.1.  The Euler–Maclaurin remainder (Theorem 4.1), tightness
(Theorem 9.1), the conversion theorem (Corollary 12.3) and the Riemann
hypothesis are *not* formalised here; they are source claims/open items in the
programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

/-- The integer mean-zero filter coefficient of Lemma 2.2:
`c_m^(N) = 1` when `N ∤ m`, and `c_m^(N) = 1 - N` when `N ∣ m`. -/
def filterCoeff (N m : ℕ) : ℤ := if N ∣ m then 1 - (N : ℤ) else 1

/-- Definition 3.1 uses the quadratic link `M = N^2`; then the inner length is
`⌊N^2 / N⌋ = N`. -/
theorem quadratic_link {N : ℕ} (hN : 1 ≤ N) : N ^ 2 / N = N := by
  rw [pow_two, Nat.mul_div_left _ hN]

/-- A non-multiple of `N` receives coefficient `1`. -/
theorem filterCoeff_of_not_dvd {N m : ℕ} (h : ¬ N ∣ m) :
    filterCoeff N m = 1 := by
  simp [filterCoeff, h]

/-- A multiple of `N` receives coefficient `1 - N` (the negative weight that
creates the path-closure mechanism). -/
theorem filterCoeff_of_dvd {N m : ℕ} (h : N ∣ m) :
    filterCoeff N m = 1 - (N : ℤ) := by
  simp [filterCoeff, h]

/-- The filter has mean zero over a complete block `1, …, N`: this is the
coefficient-level content of the mean-zero assertion in Lemma 3.2. -/
theorem filterCoeff_block_sum_zero {N : ℕ} (hN : 1 ≤ N) :
    ∑ k ∈ Finset.range N, filterCoeff N (k + 1) = 0 := by
  have hterm : ∀ k ∈ Finset.range N,
      filterCoeff N (k + 1) = 1 + (if k = N - 1 then -(N : ℤ) else 0) := by
    intro k hk
    have hklt : k < N := Finset.mem_range.mp hk
    by_cases hlast : k + 1 = N
    · have hk_eq : k = N - 1 := by omega
      have hpred : N - 1 + 1 = N := Nat.sub_add_cancel hN
      have hdiv : N ∣ N - 1 + 1 := by
        simp [hpred]
      simp [filterCoeff, hk_eq, hdiv]
      ring
    · have hlt : k + 1 < N := by omega
      have hpos : 0 < k + 1 := by omega
      have hnd : ¬ N ∣ k + 1 := Nat.not_dvd_of_pos_of_lt hpos hlt
      have hk_ne : k ≠ N - 1 := by omega
      simp [filterCoeff, hnd, hk_ne]
  calc
    ∑ k ∈ Finset.range N, filterCoeff N (k + 1)
        = ∑ k ∈ Finset.range N, (1 + (if k = N - 1 then -(N : ℤ) else 0)) :=
          Finset.sum_congr rfl hterm
    _ = (∑ _k ∈ Finset.range N, (1 : ℤ))
          + ∑ k ∈ Finset.range N, (if k = N - 1 then -(N : ℤ) else 0) := by
          rw [Finset.sum_add_distrib]
    _ = (N : ℤ) + (-(N : ℤ)) := by
          have hmem : N - 1 ∈ Finset.range N := by
            rw [Finset.mem_range]
            exact Nat.sub_lt (by omega) (by norm_num)
          rw [Finset.sum_ite_eq' (Finset.range N) (N - 1) (fun _ => -(N : ℤ))]
          simp [hmem]
    _ = 0 := by ring

/-- The tempering weight `(1 + t^2)^{-1}` of Definition 2.4 is strictly
positive. -/
theorem temperedWeight_pos (t : ℝ) : 0 < (1 + t ^ 2)⁻¹ := by
  positivity

/-- The tempering weight is bounded above by `1`; this is what makes a finite
atomic measure finite. -/
theorem temperedWeight_le_one (t : ℝ) : (1 + t ^ 2)⁻¹ ≤ 1 := by
  have h : (1 : ℝ) ≤ 1 + t ^ 2 := by nlinarith [sq_nonneg t]
  exact inv_le_one_of_one_le₀ h

/-- The atomic weight `(1 + |z|^2)^{-1}` used in Definition 8.1. -/
def atomWeight (z : ℂ) : ℝ := (1 + Complex.normSq z)⁻¹

/-- Total mass of a finite atomic measure with one tempered atom at each point
of a finite set. -/
def atomicMass (S : Finset ℂ) : ℝ := ∑ z ∈ S, atomWeight z

/-- The finite atomic mass is at most the number of atoms: the elementary
finite-measure bound behind the finite-`N` clause of Theorem 9.1. -/
theorem atomicMass_le_card (S : Finset ℂ) : atomicMass S ≤ (S.card : ℝ) := by
  calc
    atomicMass S = ∑ z ∈ S, atomWeight z := rfl
    _ ≤ ∑ _z ∈ S, (1 : ℝ) := by
          exact Finset.sum_le_sum fun z _h => by
            unfold atomWeight
            have h : (1 : ℝ) ≤ 1 + Complex.normSq z := by
              nlinarith [Complex.normSq_nonneg z]
            exact inv_le_one_of_one_le₀ h
    _ = (S.card : ℝ) := by simp

end GeoDQPT
