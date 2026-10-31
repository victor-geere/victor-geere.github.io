import Mathlib

/-!
# Rational shadows of the Gram matrices

This file formalises the *finite algebraic shadows* of the two Gram matrices
used in `notes/38-rescue.md` and `notes/39-broad-test-discrepancy.md`.

It does **not** formalise the analytic Gram matrices.  A shadow is a
rational matrix that approximates the computed matrix and for which the
relevant property is proved exactly:

* `G4` is the rational Gram matrix `L4 * L4ᵀ`, with `L4` the Cholesky factor
  of the certified narrow-Gaussian Weil Gram rounded to four decimals.  Its
  entries agree with the computed matrix to about `1.6e-5`, and `G4_psd`
  proves that it is positive semidefinite.  `G4_close` makes the agreement
  quantitative: every entry is within `2e-5` of the published rationalised
  Gram `W4`.
* `N4` is the recorded Gaussian Gram rounded to five decimals; `N4_not_psd`
  proves that it is not positive semidefinite, with the explicit rational
  vector `v4` giving a negative value (about `-0.0408`).

The analytic matrices themselves, and their eigenvalues, remain unformalised.
-/

namespace AbsoluteHodgeShadow

open scoped BigOperators

/-- The quadratic form of a rational matrix on a rational vector. -/
def quadForm {ι : Type*} [Fintype ι] (G : ι → ι → ℚ) (v : ι → ℚ) : ℚ :=
  ∑ i, ∑ j, v i * G i j * v j

/-- A negative direction refutes positive semidefiniteness. -/
theorem not_psd_of_neg {ι : Type*} [Fintype ι]
    {G : ι → ι → ℚ} {v : ι → ℚ} (h : quadForm G v < 0) :
    ¬ (∀ w, 0 ≤ quadForm G w) := by
  intro hpos
  exact (not_le_of_gt h) (hpos v)

/-- Cholesky factor of the certified Gaussian Gram, rounded to four decimals. -/
def L4 : Fin 4 → Fin 4 → ℚ
  | 0, 0 => 2077 / 10000
  | 0, 1 => 0
  | 0, 2 => 0
  | 0, 3 => 0
  | 1, 0 => -794 / 10000
  | 1, 1 => 1919 / 10000
  | 1, 2 => 0
  | 1, 3 => 0
  | 2, 0 => 386 / 10000
  | 2, 1 => -699 / 10000
  | 2, 2 => 1917 / 10000
  | 2, 3 => 0
  | 3, 0 => -107 / 10000
  | 3, 1 => 374 / 10000
  | 3, 2 => -702 / 10000
  | 3, 3 => 1916 / 10000

/-- The rational Gram shadow `G4 = L4 * L4ᵀ`. -/
def G4 (i j : Fin 4) : ℚ := ∑ k, L4 i k * L4 j k

/-- The rational Cholesky shadow is positive semidefinite. -/
theorem G4_psd (v : Fin 4 → ℚ) : 0 ≤ quadForm G4 v := by
  have h : quadForm G4 v = ∑ k, (∑ i, L4 i k * v i) ^ 2 := by
    simp only [quadForm, G4, pow_two, Fin.sum_univ_four]
    ring
  rw [h]
  exact Finset.sum_nonneg (fun k _ => sq_nonneg _)

/-- The recorded Gaussian Gram, rounded to five decimals. -/
def N4 : Fin 4 → Fin 4 → ℚ
  | 0, 0 => -19 / 5000
  | 0, 1 => 2631 / 100000
  | 0, 2 => 1461 / 100000
  | 0, 3 => 2423 / 100000
  | 1, 0 => 2631 / 100000
  | 1, 1 => -19 / 5000
  | 1, 2 => 2631 / 100000
  | 1, 3 => 1461 / 100000
  | 2, 0 => 1461 / 100000
  | 2, 1 => 2631 / 100000
  | 2, 2 => -19 / 5000
  | 2, 3 => 2631 / 100000
  | 3, 0 => 2423 / 100000
  | 3, 1 => 1461 / 100000
  | 3, 2 => 2631 / 100000
  | 3, 3 => -19 / 5000

/-- A rational negative direction for the recorded Gram. -/
def v4 : Fin 4 → ℚ
  | 0 => 169 / 354
  | 1 => -326 / 625
  | 2 => 326 / 625
  | 3 => -169 / 354

/-- The recorded rational shadow is not positive semidefinite. -/
theorem N4_not_psd : ¬ (∀ w : Fin 4 → ℚ, 0 ≤ quadForm N4 w) := by
  apply not_psd_of_neg (v := v4)
  simp only [quadForm, N4, v4, Fin.sum_univ_four]
  norm_num

def W4 : Fin 4 → Fin 4 → ℚ
  | 0, 0 => 4313596 / 100000000
  | 0, 1 => -1648926 / 100000000
  | 0, 2 => 802313 / 100000000
  | 0, 3 => -222044 / 100000000
  | 1, 0 => -1648926 / 100000000
  | 1, 1 => 4313596 / 100000000
  | 1, 2 => -1648926 / 100000000
  | 1, 3 => 802313 / 100000000
  | 2, 0 => 802313 / 100000000
  | 2, 1 => -1648926 / 100000000
  | 2, 2 => 4313596 / 100000000
  | 2, 3 => -1648926 / 100000000
  | 3, 0 => -222044 / 100000000
  | 3, 1 => 802313 / 100000000
  | 3, 2 => -1648926 / 100000000
  | 3, 3 => 4313596 / 100000000

theorem G4_close : ∀ i j : Fin 4, |G4 i j - W4 i j| ≤ 1 / 50000 := by
  intro i j
  fin_cases i <;> fin_cases j <;> simp only [G4, L4, W4, Fin.sum_univ_four] <;> norm_num


/-- The 2×2 leading-minor PSD criterion: `a > 0` and `a c - b² > 0` imply the
quadratic form is non-negative.  This is the algebraic core of the interval
PSD certificates used on the Gram matrices. -/
theorem two_by_two_pos (a b c : ℝ) (ha : 0 < a) (hdet : 0 < a * c - b ^ 2) :
    ∀ x y : ℝ, 0 ≤ a * x ^ 2 + 2 * b * x * y + c * y ^ 2 := by
  intro x y
  have hsum : 0 ≤ (a * x + b * y) ^ 2 + (a * c - b ^ 2) * y ^ 2 := by
    have h1 : 0 ≤ (a * x + b * y) ^ 2 := sq_nonneg _
    have h2 : 0 ≤ (a * c - b ^ 2) * y ^ 2 := mul_nonneg hdet.le (sq_nonneg y)
    linarith
  have hid : a * (a * x ^ 2 + 2 * b * x * y + c * y ^ 2)
      = (a * x + b * y) ^ 2 + (a * c - b ^ 2) * y ^ 2 := by ring
  nlinarith

noncomputable def quadFormR {ι : Type*} [Fintype ι]
    (G : ι → ι → ℝ) (v : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, v i * G i j * v j

theorem quadFormR_add {ι : Type*} [Fintype ι] (G E : ι → ι → ℝ) (v : ι → ℝ) :
    quadFormR (fun i j => G i j + E i j) v = quadFormR G v + quadFormR E v := by
  simp only [quadFormR, mul_add, add_mul, Finset.sum_add_distrib]

theorem quadFormR_perturb {ι : Type*} [Fintype ι] (G E : ι → ι → ℝ) (v : ι → ℝ) (t : ℝ)
    (h0 : t * (∑ i, v i ^ 2) ≤ quadFormR G v)
    (hE : -(t * (∑ i, v i ^ 2)) ≤ quadFormR E v) :
    0 ≤ quadFormR (fun i j => G i j + E i j) v := by
  rw [quadFormR_add]
  linarith


/-- A rounded rational shadow of the certified 2×2 Gaussian Gram centre
minus the operator-norm slack: `a = 355/10000`, `b = 802/100000`. -/
theorem gauss2_shadow_psd (x y : ℝ) :
    0 ≤ (355 / 10000 : ℝ) * x ^ 2 + 2 * (802 / 100000 : ℝ) * x * y
      + (355 / 10000 : ℝ) * y ^ 2 := by
  apply two_by_two_pos (a := 355 / 10000) (b := 802 / 100000)
    (c := 355 / 10000)
  · norm_num
  · norm_num


/-- **Finite Hodge-index inequality.**  If the quadratic
`a + 2 b t + c t²` is non-negative for every real `t` and `c > 0`, then
`b² ≤ a c`.  This is the Cauchy–Schwarz/Hodge-index inequality for a
positive semidefinite form, obtained from the discriminant. -/
theorem hodge_index_inequality (a b c : ℝ) (hc : 0 < c)
    (h : ∀ t : ℝ, 0 ≤ a + 2 * b * t + c * t ^ 2) :
    b ^ 2 ≤ a * c := by
  have hc0 : c ≠ 0 := ne_of_gt hc
  have h1 := h (-b / c)
  have h2 : 0 ≤ a - b ^ 2 / c := by
    convert h1 using 1
    field_simp
    ring
  have h3 : b ^ 2 / c ≤ a := by linarith
  have h4 : b ^ 2 ≤ a * c := by
    rw [div_le_iff₀ hc] at h3
    linarith
  exact h4


/-- The Hodge-index inequality for a symmetric `2 × 2` Gram form:
`G 0 1 ^ 2 ≤ G 0 0 * G 1 1` when the form is non-negative. -/
theorem hodge_index_quadForm_two {G : Fin 2 → Fin 2 → ℝ}
    (hsym : G 0 1 = G 1 0)
    (hG : ∀ v : Fin 2 → ℝ, 0 ≤ quadFormR G v)
    (_h00 : 0 < G 0 0) (h11 : 0 < G 1 1) :
    G 0 1 ^ 2 ≤ G 0 0 * G 1 1 := by
  have h : ∀ t : ℝ, 0 ≤ G 0 0 + 2 * G 0 1 * t + G 1 1 * t ^ 2 := by
    intro t
    have := hG ![1, t]
    have hq : quadFormR G ![1, t]
        = G 0 0 + 2 * G 0 1 * t + G 1 1 * t ^ 2 := by
      simp [quadFormR, Fin.sum_univ_two, hsym]
      ring
    rwa [hq] at this
  exact hodge_index_inequality _ _ _ h11 h


/-- **The equality case of the Hodge-index inequality.**  If the
discriminant vanishes, the quadratic attains zero at `t = -b/c`: a kernel
direction.  This is the finite algebra behind the margin collapse. -/
theorem hodge_index_equality_kernel (a b c : ℝ) (hc : 0 < c)
    (heq : b ^ 2 = a * c) :
    a + 2 * b * (-b / c) + c * (-b / c) ^ 2 = 0 := by
  have hc0 : c ≠ 0 := ne_of_gt hc
  field_simp
  nlinarith [heq]


/-- The equality case for the `2 × 2` Gram form: when `G 0 1² = G 0 0 G 1 1`,
the vector `(1, -G 0 1 / G 1 1)` is a kernel direction. -/
theorem hodge_index_quadForm_two_kernel {G : Fin 2 → Fin 2 → ℝ}
    (hsym : G 0 1 = G 1 0)
    (heq : G 0 1 ^ 2 = G 0 0 * G 1 1) (h11 : 0 < G 1 1) :
    quadFormR G ![1, - G 0 1 / G 1 1] = 0 := by
  have hq : quadFormR G ![1, - G 0 1 / G 1 1]
      = G 0 0 + 2 * G 0 1 * (- G 0 1 / G 1 1)
        + G 1 1 * (- G 0 1 / G 1 1) ^ 2 := by
    simp [quadFormR, Fin.sum_univ_two, hsym]
    ring
  rw [hq]
  exact hodge_index_equality_kernel _ _ _ h11 heq


/-- **The margin cannot increase under nested test sets.**  If `V ⊆ W` and
`Q '' W` is bounded below, then `inf_{W} Q ≤ inf_{V} Q`.  This is the
order-theoretic reason for the finite-rung margin collapse. -/
theorem margin_nonincrease {E : Type*} (Q : E → ℝ) {V W : Set E}
    (hVW : V ⊆ W) (hVne : V.Nonempty) (hWbd : BddBelow (Q '' W)) :
    sInf (Q '' W) ≤ sInf (Q '' V) :=
  csInf_le_csInf hWbd (hVne.image Q) (Set.image_mono hVW)




open Matrix

/-- **Row-sum bound for a quadratic form.**  If `D` is symmetric and the row
sums of `|D|` are at most `t`, then `|xᵀDx| ≤ t‖x‖²`.  (Ported from the
`intersection-form-zeta` finite Hodge-index core.) -/
theorem abs_quad_le_row_sum {ι : Type*} [Fintype ι]
    (D : Matrix ι ι ℝ) (t : ℝ)
    (hD : ∀ i j, D j i = D i j)
    (hrow : ∀ i, ∑ j, |D i j| ≤ t)
    (x : ι → ℝ) :
    |∑ i, x i * (∑ j, D i j * x j)| ≤ t * ∑ i, x i ^ 2 := by
  have h_abs : |∑ i, x i * (∑ j, D i j * x j)|
      ≤ ∑ i, ∑ j, |D i j| * |x i| * |x j| := by
    calc
      |∑ i, x i * (∑ j, D i j * x j)|
          = |∑ i, ∑ j, D i j * (x i * x j)| := by
            congr 1
            apply Finset.sum_congr rfl
            intro i _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro j _
            ring
      _ ≤ ∑ i, |∑ j, D i j * (x i * x j)| := Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ i, ∑ j, |D i j * (x i * x j)| := by
            apply Finset.sum_le_sum
            intro i _
            exact Finset.abs_sum_le_sum_abs _ _
      _ = ∑ i, ∑ j, |D i j| * |x i| * |x j| := by
            simp [abs_mul, mul_assoc]
  have h_term : ∀ i j, |D i j| * |x i| * |x j|
      ≤ |D i j| * (x i ^ 2 + x j ^ 2) / 2 := by
    intro i j
    have hx : 2 * |x i| * |x j| ≤ x i ^ 2 + x j ^ 2 := by
      nlinarith [sq_nonneg (|x i| - |x j|), sq_abs (x i), sq_abs (x j)]
    have hb : 0 ≤ |D i j| := abs_nonneg _
    nlinarith
  have h_split : ∑ i, ∑ j, |D i j| * |x i| * |x j|
      ≤ ∑ i, ∑ j, |D i j| * (x i ^ 2 + x j ^ 2) / 2 := by
    apply Finset.sum_le_sum
    intro i _
    apply Finset.sum_le_sum
    intro j _
    exact h_term i j
  have h1 : ∑ i, ∑ j, |D i j| * x i ^ 2 / 2 ≤ (t / 2) * ∑ i, x i ^ 2 := by
    have h_eq : ∑ i, ∑ j, |D i j| * x i ^ 2 / 2
        = ∑ i, (x i ^ 2 / 2) * (∑ j, |D i j|) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    rw [h_eq]
    calc
      ∑ i, (x i ^ 2 / 2) * (∑ j, |D i j|)
          ≤ ∑ i, (x i ^ 2 / 2) * t := by
            apply Finset.sum_le_sum
            intro i _
            exact mul_le_mul_of_nonneg_left (hrow i) (by positivity)
      _ = (t / 2) * ∑ i, x i ^ 2 := by
            rw [← Finset.sum_mul, ← Finset.sum_div]
            ring
  have h2 : ∑ i, ∑ j, |D i j| * x j ^ 2 / 2 ≤ (t / 2) * ∑ i, x i ^ 2 := by
    rw [Finset.sum_comm]
    have h_eq : ∑ j, ∑ i, |D i j| * x j ^ 2 / 2
        = ∑ j, (x j ^ 2 / 2) * (∑ i, |D i j|) := by
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring
    rw [h_eq]
    calc
      ∑ j, (x j ^ 2 / 2) * (∑ i, |D i j|)
          ≤ ∑ j, (x j ^ 2 / 2) * t := by
            apply Finset.sum_le_sum
            intro j _
            apply mul_le_mul_of_nonneg_left _ (by positivity)
            have hsym : ∑ i, |D i j| = ∑ i, |D j i| := by
              apply Finset.sum_congr rfl
              intro i _
              rw [hD j i]
            rw [hsym]
            exact hrow j
      _ = (t / 2) * ∑ j, x j ^ 2 := by
            rw [← Finset.sum_mul, ← Finset.sum_div]
            ring
  have h_split2 : ∑ i, ∑ j, |D i j| * (x i ^ 2 + x j ^ 2) / 2
      = (∑ i, ∑ j, |D i j| * x i ^ 2 / 2)
        + (∑ i, ∑ j, |D i j| * x j ^ 2 / 2) := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro j _
    ring
  calc
    |∑ i, x i * (∑ j, D i j * x j)|
        ≤ ∑ i, ∑ j, |D i j| * |x i| * |x j| := h_abs
    _ ≤ ∑ i, ∑ j, |D i j| * (x i ^ 2 + x j ^ 2) / 2 := h_split
    _ = (∑ i, ∑ j, |D i j| * x i ^ 2 / 2)
        + (∑ i, ∑ j, |D i j| * x j ^ 2 / 2) := h_split2
    _ ≤ (t / 2) * ∑ i, x i ^ 2 + (t / 2) * ∑ i, x i ^ 2 := add_le_add h1 h2
    _ = t * ∑ i, x i ^ 2 := by ring

/-- **Box inequality.**  If `A` is Hermitian and lies in the box
`(P + tI) ± E` with row sums of `E` at most `t`, then `A ⪰ P`. -/
theorem box_ge {ι : Type*} [Fintype ι] [DecidableEq ι]
    {A P E : Matrix ι ι ℝ} {t : ℝ}
    (hA : A.IsHermitian) (hP : P.IsHermitian)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix ι ι ℝ)) i j| ≤ E i j) :
    ∀ x, x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) := by
  intro x
  set D : Matrix ι ι ℝ := A - (P + t • 1) with hD
  have hDsym : ∀ i j, D j i = D i j := by
    intro i j
    have hAij : A j i = A i j := by simpa using (hA.apply j i).symm
    have hPij : P j i = P i j := by simpa using (hP.apply j i).symm
    simp only [hD, Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply,
      smul_eq_mul, Matrix.one_apply, hAij, hPij.symm]
    by_cases h : i = j <;> simp [h, eq_comm]
  have hrowD : ∀ i, ∑ j, |D i j| ≤ t := by
    intro i
    calc
      ∑ j, |D i j| ≤ ∑ j, E i j := by
        apply Finset.sum_le_sum
        intro j _
        simpa [hD] using hbox i j
      _ ≤ t := hrow i
  have hDq : |x ⬝ᵥ (D *ᵥ x)| ≤ t * (x ⬝ᵥ x) := by
    simpa [dotProduct, Matrix.mulVec, pow_two] using
      abs_quad_le_row_sum D t hDsym hrowD x
  have hAq : x ⬝ᵥ (A *ᵥ x)
      = x ⬝ᵥ (P *ᵥ x) + t * (x ⬝ᵥ x) + x ⬝ᵥ (D *ᵥ x) := by
    simp [hD, Matrix.sub_mulVec, Matrix.add_mulVec, Matrix.smul_mulVec,
      Matrix.one_mulVec, dotProduct_add, dotProduct_sub, dotProduct_smul]
  have hDlow : -(t * (x ⬝ᵥ x)) ≤ x ⬝ᵥ (D *ᵥ x) := (abs_le.mp hDq).1
  rw [hAq]
  nlinarith

/-- **Positive definiteness from a box.**  A Hermitian matrix in the box
`(P + tI) ± E`, with `P` positive definite and row sums of `E` at most `t`,
is positive definite. -/
theorem posDef_of_box {ι : Type*} [Fintype ι] [DecidableEq ι]
    {A P E : Matrix ι ι ℝ} {t : ℝ}
    (hA : A.IsHermitian) (hP : P.PosDef)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix ι ι ℝ)) i j| ≤ E i j) :
    A.PosDef := by
  refine Matrix.PosDef.of_dotProduct_mulVec_pos hA ?_
  intro x hx
  have hge : x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) := box_ge hA hP.isHermitian hrow hbox x
  have hPq : 0 < x ⬝ᵥ (P *ᵥ x) := by
    simpa using hP.dotProduct_mulVec_pos hx
  have hstar : star x = x := by
    funext i
    simp
  rw [hstar]
  linarith


/-- An exact rational `L d Lᵀ` with `d > 0` and `L` invertible is positive
definite.  (Ported from the `intersection-form-zeta` finite core.) -/
theorem ldl_posDef_rat {ι : Type*} [Fintype ι] [DecidableEq ι]
    {L : Matrix ι ι ℚ} {d : ι → ℚ}
    (hd : ∀ i, 0 < d i) (hL : IsUnit L) :
    Matrix.PosDef (L * Matrix.diagonal d * Lᴴ) := by
  have hD : Matrix.PosDef (Matrix.diagonal d) :=
    Matrix.posDef_diagonal_iff.mpr hd
  have h := (Matrix.IsUnit.posDef_star_right_conjugate_iff
    (x := Matrix.diagonal d) hL).mpr hD
  simpa [Matrix.star_eq_conjTranspose] using h

/-- Rational row-sum bound. -/
theorem abs_quad_le_row_sum_rat {ι : Type*} [Fintype ι]
    (D : Matrix ι ι ℚ) (t : ℚ)
    (hD : ∀ i j, D j i = D i j)
    (hrow : ∀ i, ∑ j, |D i j| ≤ t)
    (x : ι → ℚ) :
    |∑ i, x i * (∑ j, D i j * x j)| ≤ t * ∑ i, x i ^ 2 := by
  have h_abs : |∑ i, x i * (∑ j, D i j * x j)|
      ≤ ∑ i, ∑ j, |D i j| * |x i| * |x j| := by
    calc
      |∑ i, x i * (∑ j, D i j * x j)|
          = |∑ i, ∑ j, D i j * (x i * x j)| := by
            congr 1
            apply Finset.sum_congr rfl
            intro i _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro j _
            ring
      _ ≤ ∑ i, |∑ j, D i j * (x i * x j)| := Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ i, ∑ j, |D i j * (x i * x j)| := by
            apply Finset.sum_le_sum
            intro i _
            exact Finset.abs_sum_le_sum_abs _ _
      _ = ∑ i, ∑ j, |D i j| * |x i| * |x j| := by
            simp [abs_mul, mul_assoc]
  have h_term : ∀ i j, |D i j| * |x i| * |x j|
      ≤ |D i j| * (x i ^ 2 + x j ^ 2) / 2 := by
    intro i j
    have hx : 2 * |x i| * |x j| ≤ x i ^ 2 + x j ^ 2 := by
      nlinarith [sq_nonneg (|x i| - |x j|), sq_abs (x i), sq_abs (x j)]
    have hb : 0 ≤ |D i j| := abs_nonneg _
    nlinarith
  have h_split : ∑ i, ∑ j, |D i j| * |x i| * |x j|
      ≤ ∑ i, ∑ j, |D i j| * (x i ^ 2 + x j ^ 2) / 2 := by
    apply Finset.sum_le_sum
    intro i _
    apply Finset.sum_le_sum
    intro j _
    exact h_term i j
  have h1 : ∑ i, ∑ j, |D i j| * x i ^ 2 / 2 ≤ (t / 2) * ∑ i, x i ^ 2 := by
    have h_eq : ∑ i, ∑ j, |D i j| * x i ^ 2 / 2
        = ∑ i, (x i ^ 2 / 2) * (∑ j, |D i j|) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    rw [h_eq]
    calc
      ∑ i, (x i ^ 2 / 2) * (∑ j, |D i j|)
          ≤ ∑ i, (x i ^ 2 / 2) * t := by
            apply Finset.sum_le_sum
            intro i _
            exact mul_le_mul_of_nonneg_left (hrow i) (by positivity)
      _ = (t / 2) * ∑ i, x i ^ 2 := by
            rw [← Finset.sum_mul, ← Finset.sum_div]
            ring
  have h2 : ∑ i, ∑ j, |D i j| * x j ^ 2 / 2 ≤ (t / 2) * ∑ i, x i ^ 2 := by
    rw [Finset.sum_comm]
    have h_eq : ∑ j, ∑ i, |D i j| * x j ^ 2 / 2
        = ∑ j, (x j ^ 2 / 2) * (∑ i, |D i j|) := by
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring
    rw [h_eq]
    calc
      ∑ j, (x j ^ 2 / 2) * (∑ i, |D i j|)
          ≤ ∑ j, (x j ^ 2 / 2) * t := by
            apply Finset.sum_le_sum
            intro j _
            apply mul_le_mul_of_nonneg_left _ (by positivity)
            have hsym : ∑ i, |D i j| = ∑ i, |D j i| := by
              apply Finset.sum_congr rfl
              intro i _
              rw [hD j i]
            rw [hsym]
            exact hrow j
      _ = (t / 2) * ∑ j, x j ^ 2 := by
            rw [← Finset.sum_mul, ← Finset.sum_div]
            ring
  have h_split2 : ∑ i, ∑ j, |D i j| * (x i ^ 2 + x j ^ 2) / 2
      = (∑ i, ∑ j, |D i j| * x i ^ 2 / 2)
        + (∑ i, ∑ j, |D i j| * x j ^ 2 / 2) := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro j _
    ring
  calc
    |∑ i, x i * (∑ j, D i j * x j)|
        ≤ ∑ i, ∑ j, |D i j| * |x i| * |x j| := h_abs
    _ ≤ ∑ i, ∑ j, |D i j| * (x i ^ 2 + x j ^ 2) / 2 := h_split
    _ = (∑ i, ∑ j, |D i j| * x i ^ 2 / 2)
        + (∑ i, ∑ j, |D i j| * x j ^ 2 / 2) := h_split2
    _ ≤ (t / 2) * ∑ i, x i ^ 2 + (t / 2) * ∑ i, x i ^ 2 := add_le_add h1 h2
    _ = t * ∑ i, x i ^ 2 := by ring

/-- Rational box inequality. -/
theorem box_ge_rat {ι : Type*} [Fintype ι] [DecidableEq ι]
    {A P E : Matrix ι ι ℚ} {t : ℚ}
    (hA : A.IsHermitian) (hP : P.IsHermitian)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix ι ι ℚ)) i j| ≤ E i j) :
    ∀ x, x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) := by
  intro x
  set D : Matrix ι ι ℚ := A - (P + t • 1) with hD
  have hDsym : ∀ i j, D j i = D i j := by
    intro i j
    have hAij : A j i = A i j := by simpa using (hA.apply j i).symm
    have hPij : P j i = P i j := by simpa using (hP.apply j i).symm
    simp only [hD, Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply,
      smul_eq_mul, Matrix.one_apply, hAij, hPij.symm]
    by_cases h : i = j <;> simp [h, eq_comm]
  have hrowD : ∀ i, ∑ j, |D i j| ≤ t := by
    intro i
    calc
      ∑ j, |D i j| ≤ ∑ j, E i j := by
        apply Finset.sum_le_sum
        intro j _
        simpa [hD] using hbox i j
      _ ≤ t := hrow i
  have hDq : |x ⬝ᵥ (D *ᵥ x)| ≤ t * (x ⬝ᵥ x) := by
    simpa [dotProduct, Matrix.mulVec, pow_two] using
      abs_quad_le_row_sum_rat D t hDsym hrowD x
  have hAq : x ⬝ᵥ (A *ᵥ x)
      = x ⬝ᵥ (P *ᵥ x) + t * (x ⬝ᵥ x) + x ⬝ᵥ (D *ᵥ x) := by
    simp [hD, Matrix.sub_mulVec, Matrix.add_mulVec, Matrix.smul_mulVec,
      Matrix.one_mulVec, dotProduct_add, dotProduct_sub, dotProduct_smul]
  have hDlow : -(t * (x ⬝ᵥ x)) ≤ x ⬝ᵥ (D *ᵥ x) := (abs_le.mp hDq).1
  rw [hAq]
  nlinarith

/-- Rational positive definiteness from a box. -/
theorem posDef_of_box_rat {ι : Type*} [Fintype ι] [DecidableEq ι]
    {A P E : Matrix ι ι ℚ} {t : ℚ}
    (hA : A.IsHermitian) (hP : P.PosDef)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix ι ι ℚ)) i j| ≤ E i j) :
    A.PosDef := by
  refine Matrix.PosDef.of_dotProduct_mulVec_pos hA ?_
  intro x hx
  have hge : x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) := box_ge_rat hA hP.isHermitian hrow hbox x
  have hPq : 0 < x ⬝ᵥ (P *ᵥ x) := by
    simpa using hP.dotProduct_mulVec_pos hx
  have hstar : star x = x := by
    funext i
    simp
  rw [hstar]
  linarith


/-- The unit lower-triangular factor of the exact LDLᵀ decomposition of
`G4 - (1/12500)·1`. -/
def Ld : Matrix (Fin 4) (Fin 4) ℚ
  | 0, 0 => 1
  | 1, 0 => -1649138 / 4305929
  | 1, 1 => 1
  | 2, 0 => 801722 / 4305929
  | 2, 1 => -5773439475949 / 15817355284169
  | 2, 2 => 1
  | 3, 0 => -222239 / 4305929
  | 3, 1 => 3089711414874 / 15817355284169
  | 3, 2 => -21277086120608205046 / 57983388627512676241
  | 3, 3 => 1
  | _, _ => 0

/-- The positive diagonal of the LDLᵀ decomposition. -/
def dd : Fin 4 → ℚ
  | 0 => 4305929 / 100000000
  | 1 => 15817355284169 / 430592900000000
  | 2 => 57983388627512676241 / 1581735528416900000000
  | 3 => 13270722984083681998948281 / 362396178921954226506250000

/-- The rational centre minus the operator slack, `G4 - (1/12500)·1`. -/
def Pqm : Matrix (Fin 4) (Fin 4) ℚ :=
  fun i j => G4 i j - if i = j then 1 / 12500 else 0

/-- The explicit inverse of `Ld`. -/
def LdInv : Matrix (Fin 4) (Fin 4) ℚ
  | 0, 0 => 1
  | 1, 0 => 1649138 / 4305929
  | 1, 1 => 1
  | 2, 0 => -733854014464 / 15817355284169
  | 2, 1 => 5773439475949 / 15817355284169
  | 2, 2 => 1
  | 3, 0 => -2332385925014251837 / 57983388627512676241
  | 3, 1 => -3560011630387651420 / 57983388627512676241
  | 3, 2 => 21277086120608205046 / 57983388627512676241
  | 3, 3 => 1
  | _, _ => 0

theorem Ld_mul_inv : Ld * LdInv = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Ld, LdInv, Matrix.mul_apply, Matrix.one_apply, Fin.sum_univ_four] <;>
    norm_num

theorem Ld_isUnit : IsUnit Ld := IsUnit.of_mul_eq_one LdInv Ld_mul_inv

theorem dd_pos : ∀ i, 0 < dd i := by
  intro i
  fin_cases i <;> norm_num [dd]

/-- The exact LDLᵀ identity: `Ld · diag(dd) · Ldᵀ = G4 - (1/12500)·1`. -/
theorem Pq_factor : Ld * Matrix.diagonal dd * Ldᴴ = Pqm := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Ld, dd, Pqm, G4, L4, Matrix.mul_apply, Matrix.diagonal, Fin.sum_univ_four] <;>
    norm_num

/-- The rational centre minus slack is positive definite. -/
theorem Pqm_posDef : Matrix.PosDef Pqm := by
  have h := ldl_posDef_rat (L := Ld) (d := dd) dd_pos Ld_isUnit
  rwa [Pq_factor] at h

/-- The recorded numerical Gaussian shadow as a matrix. -/
def W4m : Matrix (Fin 4) (Fin 4) ℚ := fun i j => W4 i j

/-- The recorded numerical Gaussian shadow is Hermitian. -/
theorem W4m_herm : Matrix.IsHermitian W4m := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [W4m, W4]

/-- The half-width matrix `E = 1/50000`. -/
def E4m : Matrix (Fin 4) (Fin 4) ℚ := fun _ _ => 1 / 50000

theorem E4m_row : ∀ i, ∑ j, E4m i j ≤ (1 / 12500 : ℚ) := by
  intro i
  simp [E4m, Fin.sum_univ_four]
  norm_num

/-- The numerical shadow lies in the centre box. -/
theorem W4m_mem_box : ∀ i j,
    |W4m i j - (Pqm + (1 / 12500 : ℚ) • (1 : Matrix (Fin 4) (Fin 4) ℚ)) i j|
      ≤ E4m i j := by
  intro i j
  have h := G4_close i j
  have h' : |W4 i j - G4 i j| ≤ 1 / 50000 := by
    rw [abs_sub_comm]
    exact h
  simpa [E4m, W4m, Pqm, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply,
    sub_add_cancel] using h'

/-- **Finite cone positivity certificate.**  The 4×4 Gaussian Weil Gram
shadow `W4` is positive definite, Lean-checked from the rational centre `G4`
minus the operator slack and the exact LDLᵀ factorisation. -/
theorem W4m_posDef : Matrix.PosDef W4m :=
  posDef_of_box_rat W4m_herm Pqm_posDef E4m_row W4m_mem_box


/-! ## A 2×2 box rung of the general certificate -/

/-- The 2×2 Gaussian rational centre. -/
def G2q : Matrix (Fin 2) (Fin 2) ℚ
  | 0, 0 => 355 / 10000
  | 0, 1 => 802 / 100000
  | 1, 0 => 802 / 100000
  | 1, 1 => 355 / 10000
  | _, _ => 0

/-- The 2×2 unit lower-triangular factor of `G2q - (2/10000)·1`. -/
def L2 : Matrix (Fin 2) (Fin 2) ℚ
  | 0, 0 => 1
  | 1, 0 => 401 / 1765
  | 1, 1 => 1
  | _, _ => 0

/-- The 2×2 positive diagonal. -/
def d2 : Fin 2 → ℚ
  | 0 => 353 / 10000
  | 1 => 369303 / 11031250

/-- The 2×2 centre minus slack. -/
def P2m : Matrix (Fin 2) (Fin 2) ℚ
  | 0, 0 => 353 / 10000
  | 0, 1 => 802 / 100000
  | 1, 0 => 802 / 100000
  | 1, 1 => 353 / 10000
  | _, _ => 0

/-- A numerical 2×2 shadow in the box. -/
def W2m : Matrix (Fin 2) (Fin 2) ℚ
  | 0, 0 => 354 / 10000
  | 0, 1 => 801 / 100000
  | 1, 0 => 801 / 100000
  | 1, 1 => 354 / 10000
  | _, _ => 0

/-- The 2×2 half-width matrix. -/
def E2m : Matrix (Fin 2) (Fin 2) ℚ
  | 0, 0 => 1 / 10000
  | 0, 1 => 1 / 100000
  | 1, 0 => 1 / 100000
  | 1, 1 => 1 / 10000
  | _, _ => 0

/-- The explicit inverse of `L2`. -/
def L2Inv : Matrix (Fin 2) (Fin 2) ℚ
  | 0, 0 => 1
  | 1, 0 => -401 / 1765
  | 1, 1 => 1
  | _, _ => 0

theorem L2_mul_inv : L2 * L2Inv = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [L2, L2Inv, Matrix.mul_apply, Matrix.one_apply, Fin.sum_univ_two] <;>
    norm_num

theorem L2_isUnit : IsUnit L2 := IsUnit.of_mul_eq_one L2Inv L2_mul_inv

theorem d2_pos : ∀ i, 0 < d2 i := by
  intro i
  fin_cases i <;> norm_num [d2]

theorem P2_factor : L2 * Matrix.diagonal d2 * L2ᴴ = P2m := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [L2, d2, P2m, Matrix.mul_apply, Matrix.diagonal, Fin.sum_univ_two] <;>
    norm_num

theorem P2m_posDef : Matrix.PosDef P2m := by
  have h := ldl_posDef_rat (L := L2) (d := d2) d2_pos L2_isUnit
  rwa [P2_factor] at h

theorem W2m_herm : Matrix.IsHermitian W2m := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [W2m]

theorem E2m_row : ∀ i, ∑ j, E2m i j ≤ (2 / 10000 : ℚ) := by
  intro i
  fin_cases i <;> simp [E2m, Fin.sum_univ_two] <;> norm_num

theorem W2m_mem_box : ∀ i j,
    |W2m i j - (P2m + (2 / 10000 : ℚ) • (1 : Matrix (Fin 2) (Fin 2) ℚ)) i j|
      ≤ E2m i j := by
  intro i j
  fin_cases i <;> fin_cases j <;>
    simp [W2m, P2m, E2m, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply] <;>
    norm_num

/-- **A 2×2 box rung**: the numerical shadow `W2m` is positive definite. -/
theorem W2m_posDef : Matrix.PosDef W2m :=
  posDef_of_box_rat W2m_herm P2m_posDef E2m_row W2m_mem_box


open scoped RealInnerProductSpace

/-! ## Finite Gram positivity of an inner product -/

/-- **Every finite Gram matrix of an inner product is positive semidefinite**:
`∑ᵢⱼ cᵢ cⱼ ⟪vᵢ, vⱼ⟫ = ‖∑ᵢ cᵢ • vᵢ‖² ≥ 0`. -/
theorem gram_quadFormR_nonneg {E : Type*} [SeminormedAddCommGroup E]
    [InnerProductSpace ℝ E] {ι : Type*} [Fintype ι] (v : ι → E) (c : ι → ℝ) :
    0 ≤ quadFormR (fun i j => inner ℝ (v i) (v j)) c := by
  have hpsd := Matrix.posSemidef_gram ℝ v
  have h := (Matrix.posSemidef_iff_dotProduct_mulVec.mp hpsd).2 c
  simpa [quadFormR, Matrix.gram, dotProduct, Matrix.mulVec, star_trivial,
    Finset.mul_sum, mul_assoc, mul_comm, mul_left_comm] using h

/-- **A finite Gram matrix is positive definite exactly when the vectors are
linearly independent.** -/
theorem gram_quadFormR_pos_iff {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] {ι : Type*} [Fintype ι] (v : ι → E) :
    (∀ c : ι → ℝ, c ≠ 0 → 0 < quadFormR (fun i j => inner ℝ (v i) (v j)) c)
      ↔ LinearIndependent ℝ v := by
  rw [← Matrix.posDef_gram_iff_linearIndependent]
  constructor
  · intro h
    refine Matrix.PosDef.of_dotProduct_mulVec_pos (Matrix.posSemidef_gram ℝ v).1 ?_
    intro x hx
    have hq := h x hx
    simpa [quadFormR, Matrix.gram, dotProduct, Matrix.mulVec, star_trivial,
      Finset.mul_sum, mul_assoc, mul_comm, mul_left_comm] using hq
  · intro hP c hc
    have hpos := hP.dotProduct_mulVec_pos hc
    simpa [quadFormR, Matrix.gram, dotProduct, Matrix.mulVec, star_trivial,
      Finset.mul_sum, mul_assoc, mul_comm, mul_left_comm] using hpos


/-! ## The explicit Hodge defect of the rank-three model -/

/-- **Hodge defect identity.**  For `D = aH + bV + cΔ`, with `A = H + V + Δ`,
the defect of the Hodge-index inequality is exactly a sum of squares:
`(A·D)² - 6D² = 2((a-b)² + (b-c)² + (c-a)²)`, using `A·D = 2(a+b+c)` and
`D² = 2(ab + bc + ca)`.  (Ported from the `intersection-form-zeta` finite
Hodge-index core.) -/
theorem hodge_defect_identity (a b c : ℝ) :
    (2 * (a + b + c)) ^ 2 - 6 * (2 * (a * b + a * c + b * c))
      = 2 * ((a - b) ^ 2 + (b - c) ^ 2 + (c - a) ^ 2) := by
  ring

/-- **The explicit Hodge-index inequality** in the rank-three model:
`6D² ≤ (A·D)²`, with equality only when `D` is a multiple of `A`. -/
theorem hodge_index_explicit (a b c : ℝ) :
    6 * (2 * (a * b + a * c + b * c)) ≤ (2 * (a + b + c)) ^ 2 := by
  have h := hodge_defect_identity a b c
  nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (c - a)]


/-- **The 2×2 positive-definiteness criterion.**  If `a > 0` and
`a c - b² > 0`, then `a x² + 2 b x y + c y² > 0` for every nonzero `(x, y)`.
This is the finite cone positivity in dimension two, complementing the
non-negative criterion `two_by_two_pos`. -/
theorem two_by_two_posDef (a b c : ℝ) (ha : 0 < a) (hdet : 0 < a * c - b ^ 2)
    (x y : ℝ) (h : x ≠ 0 ∨ y ≠ 0) :
    0 < a * x ^ 2 + 2 * b * x * y + c * y ^ 2 := by
  by_cases hy0 : y = 0
  · subst hy0
    have hx0 : x ≠ 0 := by
      rcases h with hx | hy
      · exact hx
      · exact absurd rfl hy
    nlinarith [sq_pos_of_ne_zero hx0]
  · have hfac : a * x ^ 2 + 2 * b * x * y + c * y ^ 2
        = a * (x + b / a * y) ^ 2 + ((a * c - b ^ 2) / a) * y ^ 2 := by
      field_simp [ne_of_gt ha]
      ring
    rw [hfac]
    have h1 : 0 ≤ a * (x + b / a * y) ^ 2 :=
      mul_nonneg (le_of_lt ha) (sq_nonneg _)
    have h2 : 0 < ((a * c - b ^ 2) / a) * y ^ 2 :=
      mul_pos (div_pos hdet ha) (sq_pos_of_ne_zero hy0)
    linarith


/-- **The Hodge defect vanishes exactly on the ample line.**  The defect
`(A·D)² - 6D²` is zero if and only if `a = b = c`, i.e. `D` is a multiple of
`A = H + V + Δ`. -/
theorem hodge_defect_eq_zero_iff (a b c : ℝ) :
    (2 * (a + b + c)) ^ 2 - 6 * (2 * (a * b + a * c + b * c)) = 0
      ↔ a = b ∧ b = c := by
  constructor
  · intro h
    have hsum : (a - b) ^ 2 + (b - c) ^ 2 + (c - a) ^ 2 = 0 := by
      have h' := hodge_defect_identity a b c
      linarith
    have h1 : (a - b) ^ 2 = 0 := by
      nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (c - a)]
    have h2 : (b - c) ^ 2 = 0 := by
      nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (c - a)]
    exact ⟨by have := sq_eq_zero_iff.mp h1; linarith,
           by have := sq_eq_zero_iff.mp h2; linarith⟩
  · rintro ⟨rfl, rfl⟩
    ring


/-! ## The explicit rank-three intersection form -/

/-- The intersection pairing on the rank-three lattice spanned by
`H = {pt} × E`, `V = E × {pt}` and the diagonal `Δ`, with
`H² = V² = Δ² = 0` and `H·V = H·Δ = V·Δ = 1`. -/
def Bint (a b c a' b' c' : ℚ) : ℚ :=
  a * b' + a' * b + a * c' + a' * c + b * c' + b' * c

theorem Bint_comm (a b c a' b' c' : ℚ) :
    Bint a b c a' b' c' = Bint a' b' c' a b c := by
  simp only [Bint]
  ring

/-- `D² = 2(ab + ac + bc)` for `D = aH + bV + cΔ`. -/
theorem Bint_self (a b c : ℚ) : Bint a b c a b c = 2 * (a * b + a * c + b * c) := by
  simp only [Bint]
  ring

/-- The ample class `A = H + V + Δ` has `A² = 6`. -/
theorem Bint_ample_sq : Bint 1 1 1 1 1 1 = 6 := by
  norm_num [Bint]

/-- `A · D = 2(a + b + c)`. -/
theorem Bint_ample_dot (a b c : ℚ) : Bint 1 1 1 a b c = 2 * (a + b + c) := by
  simp only [Bint]
  ring

end AbsoluteHodgeShadow






