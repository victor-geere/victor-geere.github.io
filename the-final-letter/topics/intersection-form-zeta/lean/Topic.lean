import Mathlib

/-!
# An intersection form on `E × E` and the Hodge index inequality

This file formalises the finite linear-algebraic core of the function-field
proof of the Riemann hypothesis for curves over a finite field.

For an elliptic curve `E` the Néron–Severi space of `E × E` contains the
classes `H = {pt} × E`, `V = E × {pt}` and the diagonal `Δ`, with the
intersection numbers

`H² = V² = Δ² = 0`,  `H·V = H·Δ = V·Δ = 1`.

The resulting Gram matrix is `!![0, 1, 1; 1, 0, 1; 1, 1, 0]`, of signature
`(1, 2)`.  The ample class is `A = H + V + Δ`, with `A² = 6`, and the Hodge
index inequality takes the explicit form `6 D² ≤ (A · D)²`, with defect
`2((a-b)² + (b-c)² + (c-a)²)`.  On `A^⊥` the form is negative definite: the
Hodge index theorem in this rank-three model.

Nothing here asserts the Riemann hypothesis or constructs an intersection
form for `ζ`.  The dossier records both as open; see the README.
-/

namespace IntersectionForm

/-- The intersection form on the rank-three lattice spanned by `H`, `V`, `Δ`,
with Gram matrix `!![0, 1, 1; 1, 0, 1; 1, 1, 0]`. -/
def B (a b c a' b' c' : ℚ) : ℚ :=
  a * b' + a' * b + a * c' + a' * c + b * c' + b' * c

/-- The form is symmetric. -/
theorem B_comm (a b c a' b' c' : ℚ) :
    B a b c a' b' c' = B a' b' c' a b c := by
  unfold B
  ring

/-- The self-intersection `D²` of `D = aH + bV + cΔ`. -/
theorem B_self (a b c : ℚ) :
    B a b c a b c = 2 * (a * b + a * c + b * c) := by
  unfold B
  ring

/-- The ample class `A = H + V + Δ` has square `6`. -/
theorem A_sq : B 1 1 1 1 1 1 = 6 := by
  norm_num [B]

/-- The pairing `A · D = 2(a + b + c)`. -/
theorem A_dot (a b c : ℚ) :
    B a b c 1 1 1 = 2 * (a + b + c) := by
  unfold B
  ring

/-- The Hodge index inequality `6 D² ≤ (A · D)²`. -/
theorem hodge_inequality (a b c : ℚ) :
    6 * B a b c a b c ≤ (B a b c 1 1 1) ^ 2 := by
  rw [B_self, A_dot]
  nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (c - a)]

/-- The exact defect in the Hodge index inequality. -/
theorem hodge_defect (a b c : ℚ) :
    (B a b c 1 1 1) ^ 2 - 6 * B a b c a b c
      = 2 * ((a - b) ^ 2 + (b - c) ^ 2 + (c - a) ^ 2) := by
  unfold B
  ring

/-- On the orthogonal complement of the ample class the form is negative
definite, in the explicit form `D² = -(a² + b² + c²)`. -/
theorem hodge_index (a b c : ℚ) (h : a + b + c = 0) :
    B a b c a b c = - (a ^ 2 + b ^ 2 + c ^ 2) := by
  rw [B_self]
  have h1 : (a + b + c) ^ 2 = 0 := by
    rw [h]
    ring
  linear_combination h1

/-- On the orthogonal complement of the ample class the form is negative
definite: `D · A = 0` implies `D² ≤ 0`. -/
theorem hodge_index_nonpos (a b c : ℚ) (h : a + b + c = 0) :
    B a b c a b c ≤ 0 := by
  rw [hodge_index a b c h]
  nlinarith [sq_nonneg a, sq_nonneg b, sq_nonneg c]

/-- Equality on `A^⊥` holds only at the origin. -/
theorem hodge_index_eq_zero (a b c : ℚ) (h : a + b + c = 0) :
    B a b c a b c = 0 ↔ a = 0 ∧ b = 0 ∧ c = 0 := by
  constructor
  · intro hB
    rw [hodge_index a b c h] at hB
    constructor
    · nlinarith [sq_nonneg a, sq_nonneg b, sq_nonneg c]
    · constructor
      · nlinarith [sq_nonneg a, sq_nonneg b, sq_nonneg c]
      · nlinarith [sq_nonneg a, sq_nonneg b, sq_nonneg c]
  · rintro ⟨rfl, rfl, rfl⟩
    simp [B]

/-- The form is indefinite: positive on `H + V`, negative on `H - V`. -/
theorem indefinite :
    0 < B 1 1 0 1 1 0 ∧ B 1 (-1) 0 1 (-1) 0 < 0 := by
  constructor <;> norm_num [B]

/-- The ample class is positive. -/
theorem A_pos : 0 < B 1 1 1 1 1 1 := by
  rw [A_sq]
  norm_num

/-! ## The finite shadow

The finite Weil Gram matrix of the dossier is a `4 × 4` positive definite
matrix.  A rational shadow `L * Lᴴ` is positive semidefinite by the general
finite algebra below; the transcendental matrix itself is certified by the
interval centre/error computation, not by this theorem. -/

section FiniteShadow

open Matrix
open scoped BigOperators

/-- A rational shadow `L * Lᴴ` is positive semidefinite. -/
theorem shadow_posSemidef (L : Matrix (Fin 4) (Fin 4) ℝ) :
    Matrix.PosSemidef (L * Lᴴ) :=
  Matrix.posSemidef_self_mul_conjTranspose L

/-- The quadratic form of the shadow is non-negative on every real vector. -/
theorem shadow_quadratic_nonneg (L : Matrix (Fin 4) (Fin 4) ℝ)
    (x : Fin 4 → ℝ) :
    0 ≤ x ⬝ᵥ ((L * Lᴴ) *ᵥ x) :=
  (shadow_posSemidef L).dotProduct_mulVec_nonneg x

/-- An exact rational LDL^T factorisation certifies positive definiteness:
if `L` is invertible and `d` is a positive diagonal, then
`L * diagonal d * Lᴴ` is positive definite. -/
theorem ldl_posDef {L : Matrix (Fin 4) (Fin 4) ℝ} {d : Fin 4 → ℝ}
    (hd : ∀ i, 0 < d i) (hL : IsUnit L) :
    Matrix.PosDef (L * Matrix.diagonal d * Lᴴ) := by
  have hD : Matrix.PosDef (Matrix.diagonal d) :=
    Matrix.posDef_diagonal_iff.mpr hd
  have h := (Matrix.IsUnit.posDef_star_right_conjugate_iff
    (x := Matrix.diagonal d) hL).mpr hD
  simpa [Matrix.star_eq_conjTranspose] using h

theorem ldl_posDef_rat {L : Matrix (Fin 4) (Fin 4) ℚ} {d : Fin 4 → ℚ}
    (hd : ∀ i, 0 < d i) (hL : IsUnit L) :
    Matrix.PosDef (L * Matrix.diagonal d * Lᴴ) := by
  have hD : Matrix.PosDef (Matrix.diagonal d) :=
    Matrix.posDef_diagonal_iff.mpr hd
  have h := (Matrix.IsUnit.posDef_star_right_conjugate_iff
    (x := Matrix.diagonal d) hL).mpr hD
  simpa [Matrix.star_eq_conjTranspose] using h

def shadowL : Matrix (Fin 4) (Fin 4) ℚ
  | 0, 0 => 1
  | 1, 0 => -165987448143298525/220072179340363212
  | 1, 1 => 1
  | 2, 0 => 39120050468628961/110036089670181606
  | 2, 1 => -23542344758991689995249263476697250/20879931178492771594042144815781319
  | 2, 2 => 1
  | 3, 0 => -6227376396140185/55018044835090803
  | 3, 1 => 13083804258579864399423017989456964/20879931178492771594042144815781319
  | 3, 2 => -376250007440383174992929075970158761751369394163823/299168325153236087751613714965004107126829001445164
  | 3, 3 => 1
  | _, _ => 0

def shadowD : Fin 4 → ℚ
  | 0 => 55018044835090803/2500000000000000000
  | 1 => 20879931178492771594042144815781319/2200721793403632120000000000000000000
  | 2 => 74792081288309021937903428741251026781707250361291/10439965589246385797021072407890659500000000000000000
  | 3 => 3990067827270654354184522916405187682805155051951340304019453778553/598336650306472175503227429930008214253658002890328000000000000000000

def shadowP : Matrix (Fin 4) (Fin 4) ℚ
  | 0, 0 => 55018044835090803/2500000000000000000
  | 0, 1 => -6639497925731941/400000000000000000
  | 0, 2 => 39120050468628961/5000000000000000000
  | 0, 3 => -1245475279228037/500000000000000000
  | 1, 0 => -6639497925731941/400000000000000000
  | 1, 1 => 55018044835090803/2500000000000000000
  | 1, 2 => -6639497925731941/400000000000000000
  | 1, 3 => 39120050468628961/5000000000000000000
  | 2, 0 => 39120050468628961/5000000000000000000
  | 2, 1 => -6639497925731941/400000000000000000
  | 2, 2 => 55018044835090803/2500000000000000000
  | 2, 3 => -6639497925731941/400000000000000000
  | 3, 0 => -1245475279228037/500000000000000000
  | 3, 1 => 39120050468628961/5000000000000000000
  | 3, 2 => -6639497925731941/400000000000000000
  | 3, 3 => 55018044835090803/2500000000000000000
  | _, _ => 0

theorem shadowD_pos : ∀ i, 0 < shadowD i := by
  intro i
  fin_cases i <;> norm_num [shadowD]

theorem shadowL_lower : shadowL.IsLowerTriangular := by
  decide

theorem shadowL_det : shadowL.det = 1 := by
  rw [Matrix.det_of_isLowerTriangular shadowL shadowL_lower, Fin.prod_univ_four]
  norm_num [shadowL]

theorem shadowL_unit : IsUnit shadowL := by
  rw [Matrix.isUnit_iff_isUnit_det, shadowL_det]
  exact isUnit_one

theorem shadow_factor : shadowL * diagonal shadowD * shadowLᴴ = shadowP := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [shadowL, shadowD, shadowP, Matrix.mul_apply,
      Matrix.diagonal, Matrix.conjTranspose, Matrix.transpose,
      Fin.sum_univ_four]

theorem shadowP_posDef : shadowP.PosDef := by
  have h := ldl_posDef_rat (L := shadowL) (d := shadowD)
    shadowD_pos shadowL_unit
  rwa [shadow_factor] at h

end FiniteShadow

open Matrix

theorem abs_quad_le_row_sum
    (D : Matrix (Fin 4) (Fin 4) ℝ) (t : ℝ)
    (hD : ∀ i j, D j i = D i j)
    (hrow : ∀ i, ∑ j, |D i j| ≤ t)
    (x : Fin 4 → ℝ) :
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

theorem abs_quad_le_row_sum_rat
    (D : Matrix (Fin 4) (Fin 4) ℚ) (t : ℚ)
    (hD : ∀ i j, D j i = D i j)
    (hrow : ∀ i, ∑ j, |D i j| ≤ t)
    (x : Fin 4 → ℚ) :
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

theorem box_ge
    {A P E : Matrix (Fin 4) (Fin 4) ℝ} {t : ℝ}
    (hA : A.IsHermitian) (hP : P.IsHermitian)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix (Fin 4) (Fin 4) ℝ)) i j| ≤ E i j) :
    ∀ x, x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) := by
  intro x
  set D : Matrix (Fin 4) (Fin 4) ℝ := A - (P + t • 1) with hD
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

theorem box_ge_rat
    {A P E : Matrix (Fin 4) (Fin 4) ℚ} {t : ℚ}
    (hA : A.IsHermitian) (hP : P.IsHermitian)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix (Fin 4) (Fin 4) ℚ)) i j| ≤ E i j) :
    ∀ x, x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) := by
  intro x
  set D : Matrix (Fin 4) (Fin 4) ℚ := A - (P + t • 1) with hD
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

theorem posDef_of_box
    {A P E : Matrix (Fin 4) (Fin 4) ℝ} {t : ℝ}
    (hA : A.IsHermitian) (hP : P.PosDef)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix (Fin 4) (Fin 4) ℝ)) i j| ≤ E i j) :
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


theorem posDef_of_box_rat
    {A P E : Matrix (Fin 4) (Fin 4) ℚ} {t : ℚ}
    (hA : A.IsHermitian) (hP : P.PosDef)
    (hrow : ∀ i, ∑ j, E i j ≤ t)
    (hbox : ∀ i j,
      |A i j - (P + t • (1 : Matrix (Fin 4) (Fin 4) ℚ)) i j| ≤ E i j) :
    A.PosDef := by
  refine Matrix.PosDef.of_dotProduct_mulVec_pos hA ?_
  intro x hx
  have hge : x ⬝ᵥ (P *ᵥ x) ≤ x ⬝ᵥ (A *ᵥ x) :=
    box_ge_rat hA hP.isHermitian hrow hbox x
  have hPq : 0 < x ⬝ᵥ (P *ᵥ x) := by
    simpa using hP.dotProduct_mulVec_pos hx
  have hstar : star x = x := by
    funext i
    simp
  rw [hstar]
  linarith

def shadowA : Matrix (Fin 4) (Fin 4) ℚ
  | 0, 0 => 4313595839483805966177471/100000000000000000000000000
  | 0, 1 => -51528933198967183974681/3125000000000000000000000
  | 0, 2 => 8023129201154164689956681/1000000000000000000000000000
  | 0, 3 => -1110219212509502929818633/500000000000000000000000000
  | 1, 0 => -51528933198967183974681/3125000000000000000000000
  | 1, 1 => 4313595839483805966177471/100000000000000000000000000
  | 1, 2 => -51528933198967183974681/3125000000000000000000000
  | 1, 3 => 8023129201154164689956681/1000000000000000000000000000
  | 2, 0 => 8023129201154164689956681/1000000000000000000000000000
  | 2, 1 => -51528933198967183974681/3125000000000000000000000
  | 2, 2 => 4313595839483805966177471/100000000000000000000000000
  | 2, 3 => -51528933198967183974681/3125000000000000000000000
  | 3, 0 => -1110219212509502929818633/500000000000000000000000000
  | 3, 1 => 8023129201154164689956681/1000000000000000000000000000
  | 3, 2 => -51528933198967183974681/3125000000000000000000000
  | 3, 3 => 4313595839483805966177471/100000000000000000000000000
  | _, _ => 0

def shadowE : Matrix (Fin 4) (Fin 4) ℚ
  | 0, 0 => 5666685826563409/1000000000000000000
  | 0, 1 => 2104720542623931/400000000000000000
  | 0, 2 => 24526911806059399/5000000000000000000
  | 0, 3 => 2331165136189207/500000000000000000
  | 1, 0 => 2104720542623931/400000000000000000
  | 1, 1 => 5666685826563409/1000000000000000000
  | 1, 2 => 2104720542623931/400000000000000000
  | 1, 3 => 24526911806059399/5000000000000000000
  | 2, 0 => 24526911806059399/5000000000000000000
  | 2, 1 => 2104720542623931/400000000000000000
  | 2, 2 => 5666685826563409/1000000000000000000
  | 2, 3 => 2104720542623931/400000000000000000
  | 3, 0 => 2331165136189207/500000000000000000
  | 3, 1 => 24526911806059399/5000000000000000000
  | 3, 2 => 2104720542623931/400000000000000000
  | 3, 3 => 5666685826563409/1000000000000000000
  | _, _ => 0

def shadowT : ℚ := 105478359504474719/5000000000000000000

theorem shadowA_herm : shadowA.IsHermitian := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [shadowA]

theorem shadowA_mem_box :
    ∀ i j, |shadowA i j - (shadowP + shadowT • 1) i j| ≤ shadowE i j := by
  intro i j
  fin_cases i <;> fin_cases j <;>
    norm_num [shadowA, shadowP, shadowE, shadowT]

theorem shadowE_row : ∀ i, ∑ j, shadowE i j ≤ shadowT := by
  intro i
  fin_cases i <;> norm_num [shadowE, shadowT, Fin.sum_univ_four]

theorem shadowA_posDef : shadowA.PosDef :=
  posDef_of_box_rat shadowA_herm shadowP_posDef shadowE_row shadowA_mem_box

end IntersectionForm
