import Mathlib

/-!
# Register transfer matrix for the geometric DQPT polygon

This file constructs the natural bond-dimension-2 register transfer matrix
and proves the product identity. It then proves the sign obstruction for the
register-only ferromagnetic/Lee–Yang representation: the coupling at `m = N`
is negative for every real `s > 0`.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

/-- The integer filter coefficient, as a real number. -/
def regCoeff (N m : ℕ) : ℝ := if N ∣ m then 1 - (N : ℝ) else 1

/-- The bond-dimension-2 register transfer matrix at position `m`. -/
def regMat (N : ℕ) (s : ℝ) (m : ℕ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![1, regCoeff N m * (m : ℝ) ^ (-s); 0, 1]

/-- Product of the first `M` register transfer matrices, defined recursively
so that the noncommutative matrix product is unambiguous. -/
def regProd (N : ℕ) (s : ℝ) : ℕ → Matrix (Fin 2) (Fin 2) ℝ
  | 0 => 1
  | M + 1 => regProd N s M * regMat N s (M + 1)

/-- The top-left entry of every register product is `1`. -/
theorem regProd_diag (N M : ℕ) (s : ℝ) : (regProd N s M) 0 0 = 1 := by
  induction M with
  | zero => simp [regProd]
  | succ M ih =>
      rw [regProd, Matrix.mul_apply]
      simp [regMat, ih, Fin.sum_univ_two]

/-- The top-right entry of the product is the polygon sum. -/
theorem regProd_topright (N M : ℕ) (s : ℝ) :
    (regProd N s M) 0 1 =
      ∑ k ∈ Finset.range M, regCoeff N (k + 1) * ((k + 1 : ℕ) : ℝ) ^ (-s) := by
  induction M with
  | zero => simp [regProd]
  | succ M ih =>
      rw [regProd, Matrix.mul_apply]
      simp [regProd_diag, regMat, ih, Finset.sum_range_succ, Fin.sum_univ_two]
      ring



/-- At `m = N` the register coefficient is `1 - N`. -/
theorem regCoeff_at_period (N : ℕ) : regCoeff N N = 1 - (N : ℝ) := by
  unfold regCoeff
  simp

/-- At `m = N` the register coefficient is negative for `N > 1`. -/
theorem regCoeff_at_period_neg {N : ℕ} (hN : 1 < N) : regCoeff N N < 0 := by
  rw [regCoeff_at_period]
  have hN1 : (1 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  linarith

/-- The register coupling at `m = N` is negative for every real `s > 0`. -/
theorem regMat_coupling_neg {N : ℕ} (hN : 1 < N) (s : ℝ) :
    (regMat N s N) 0 1 < 0 := by
  have hcoef : regCoeff N N < 0 := regCoeff_at_period_neg hN
  have hpow : 0 < (N : ℝ) ^ (-s) :=
    Real.rpow_pos_of_pos (by exact_mod_cast (lt_trans Nat.zero_lt_one hN)) _
  have hmul : regCoeff N N * (N : ℝ) ^ (-s) < 0 := mul_neg_of_neg_of_pos hcoef hpow
  simpa [regMat] using hmul

/-- No positive-temperature register chain can have all couplings nonnegative:
the coupling at `m = N` is negative. This is the exact no-go for the
register-only ferromagnetic/Lee–Yang representation. -/
theorem register_not_ferromagnetic {N : ℕ} (hN : 1 < N) (s : ℝ) :
    ¬ (∀ m : ℕ, 0 ≤ (regMat N s m) 0 1) := by
  intro h
  have hneg : (regMat N s N) 0 1 < 0 := regMat_coupling_neg hN s
  have hnonneg : 0 ≤ (regMat N s N) 0 1 := h N
  linarith

/-- The top-right entry at the quadratic link `M = N^2` is the polygon sum. -/
theorem regProd_topright_polygon (N : ℕ) (s : ℝ) :
    (regProd N s (N * N)) 0 1 =
      ∑ k ∈ Finset.range (N * N), regCoeff N (k + 1) * ((k + 1 : ℕ) : ℝ) ^ (-s) :=
  regProd_topright N (N * N) s



/-- An upper-triangular transfer factor with nonnegative entries. -/
structure UpperTriNN where
  a : ℝ
  b : ℝ
  d : ℝ
  ha : 0 ≤ a
  hb : 0 ≤ b
  hd : 0 ≤ d

namespace UpperTriNN

/-- The identity factor. -/
def one : UpperTriNN := ⟨1, 0, 1, by norm_num, by norm_num, by norm_num⟩

/-- Multiplication of upper-triangular nonnegative factors. -/
def mul (x y : UpperTriNN) : UpperTriNN :=
  ⟨x.a * y.a, x.a * y.b + x.b * y.d, x.d * y.d,
    mul_nonneg x.ha y.ha,
    add_nonneg (mul_nonneg x.ha y.hb) (mul_nonneg x.hb y.hd),
    mul_nonneg x.hd y.hd⟩

/-- Product of a list of upper-triangular nonnegative factors. -/
def prod : List UpperTriNN → UpperTriNN
  | [] => one
  | x :: xs => x.mul (prod xs)

/-- Every product of upper-triangular nonnegative factors has nonnegative
top-right entry. -/
theorem prod_b_nonneg (xs : List UpperTriNN) : 0 ≤ (prod xs).b :=
  (prod xs).hb

end UpperTriNN

/-- The polygon at `s = -1`, as a finite real sum. -/
def etaAtNegOne (N : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (N * N), regCoeff N (k + 1) * ((k + 1 : ℕ) : ℝ)

/-- For `N = 2`, the polygon at `s = -1` is exactly `-2`. -/
theorem etaAtNegOne_two : etaAtNegOne 2 = -2 := by
  unfold etaAtNegOne regCoeff
  norm_num [Finset.sum_range_succ]

/-- No product of upper-triangular nonnegative factors can represent a
negative value. -/
theorem no_upperTriNN_rep_of_neg {v : ℝ} (hv : v < 0) :
    ¬ ∃ xs : List UpperTriNN, (UpperTriNN.prod xs).b = v := by
  rintro ⟨xs, hxs⟩
  have hb : 0 ≤ (UpperTriNN.prod xs).b := UpperTriNN.prod_b_nonneg xs
  linarith

/-- The upper-triangular nonnegative transfer class cannot represent the
`N = 2` polygon at `s = -1`, where the value is `-2`. -/
theorem upperTriNN_cannot_represent_eta_two :
    ¬ ∃ xs : List UpperTriNN, (UpperTriNN.prod xs).b = etaAtNegOne 2 := by
  rw [etaAtNegOne_two]
  exact no_upperTriNN_rep_of_neg (by norm_num)

end GeoDQPT
