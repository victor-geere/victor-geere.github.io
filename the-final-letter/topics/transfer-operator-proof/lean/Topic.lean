import Mathlib

/-!
# Transfer-operator proof — finite formal bookkeeping

The archived source `archive/maths/rh.html` is an exploratory
Hilbert–Pólya programme, not a proof.  It explicitly leaves open the
trace-class determinant, positivity of the metric, and the analytic
continuation of the operator family into the strip.

This file formalises only the finite algebra that the source actually
uses:

* the eigenvalues `p^{-s}` of the diagonal model operator;
* the finite Fredholm determinant `∏ (1 - p^{-s})`, which vanishes exactly
  when an eigenvalue equals one;
* the Euclidean self-adjointness of a real diagonal operator;
* the indefinite (Krein) pairing of Definition 3.1, whose symmetry does
  **not** imply positivity.

No statement about the Riemann Hypothesis, the zeros of zeta, or the
completion of `ξ` is asserted here.
-/

noncomputable section

open scoped BigOperators

namespace TransferOperator

/-- The transfer-operator eigenvalue `p^{-s}` of Definition 2.2. -/
def primeWeight (p : ℕ) (s : ℝ) : ℝ := (p : ℝ) ^ (-s)

/-- The finite Fredholm determinant `∏_i (1 - λ_i)`. -/
def fredholmDet {n : ℕ} (eigenvalues : Fin n → ℝ) : ℝ :=
  ∏ i, (1 - eigenvalues i)

/-- The real diagonal pairing `Σ_i w_i x_i y_i`. -/
def diagForm {n : ℕ} (w x y : Fin n → ℝ) : ℝ :=
  ∑ i, w i * x i * y i

/-- The quadratic energy `Σ_i w_i x_i²` of a real diagonal operator. -/
def diagEnergy {n : ℕ} (w x : Fin n → ℝ) : ℝ :=
  ∑ i, w i * (x i) ^ 2

/-- The finite model of the source's Petersson pairing: an indefinite
(Krein) form with signs `sign i`. -/
def kreinForm {n : ℕ} (sign x y : Fin n → ℝ) : ℝ :=
  ∑ i, sign i * x i * y i

/-- Eigenvalues `p^{-s}` are positive for a positive prime and any `s`. -/
theorem primeWeight_pos {p : ℕ} (hp : 0 < p) (s : ℝ) : 0 < primeWeight p s := by
  unfold primeWeight
  exact Real.rpow_pos_of_pos (by exact_mod_cast hp) (-s)

/-- For a prime `p ≥ 2` and `s > 0`, the eigenvalue `p^{-s}` lies strictly
inside the unit disc.  This is the source's reason that `1` is not an
eigenvalue of the Euler-product operator. -/
theorem primeWeight_lt_one {p : ℕ} (hp : 2 ≤ p) {s : ℝ} (hs : 0 < s) :
    primeWeight p s < 1 := by
  unfold primeWeight
  have hp1 : (1 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  exact Real.rpow_lt_one_of_one_lt_of_neg hp1 (by linarith)

/-- A finite determinant whose eigenvalues are all `< 1` has positive
determinant: in particular it is nonzero. -/
theorem fredholmDet_pos {n : ℕ} (eigenvalues : Fin n → ℝ)
    (h : ∀ i, eigenvalues i < 1) : 0 < fredholmDet eigenvalues := by
  unfold fredholmDet
  exact Finset.prod_pos (fun i _ => by linarith [h i])

/-- The finite determinant vanishes exactly when some eigenvalue is `1`.
This is the exact finite content of the source's corrected determinant
orientation. -/
theorem fredholmDet_eq_zero_iff {n : ℕ} (eigenvalues : Fin n → ℝ) :
    fredholmDet eigenvalues = 0 ↔ ∃ i, eigenvalues i = 1 := by
  unfold fredholmDet
  rw [Finset.prod_eq_zero_iff]
  constructor
  · rintro ⟨a, _, ha⟩
    exact ⟨a, by linarith⟩
  · rintro ⟨i, hi⟩
    exact ⟨i, Finset.mem_univ i, by simp [hi]⟩

/-- A real diagonal operator is symmetric for the Euclidean pairing. -/
theorem diagForm_symm {n : ℕ} (w x y : Fin n → ℝ) :
    diagForm w x y = diagForm w y x := by
  unfold diagForm
  exact Finset.sum_congr rfl (fun i _ => by ring)

/-- A positive diagonal weight gives a nonnegative quadratic energy. -/
theorem diagEnergy_nonneg {n : ℕ} {w x : Fin n → ℝ} (h : ∀ i, 0 ≤ w i) :
    0 ≤ diagEnergy w x := by
  unfold diagEnergy
  exact Finset.sum_nonneg (fun i _ => mul_nonneg (h i) (sq_nonneg (x i)))

/-- If a sign is negative, the Krein form has a negative direction.  Hence
symmetry of the form does not supply positivity, which is exactly the
source's Caveat 2. -/
theorem kreinForm_negative_direction {n : ℕ} {sign : Fin n → ℝ} {j : Fin n}
    (h : sign j < 0) : kreinForm sign (Pi.single j 1) (Pi.single j 1) < 0 := by
  unfold kreinForm
  rw [Finset.sum_eq_single j]
  · simp [h]
  · intro b _ hbj
    simp [Pi.single_eq_of_ne hbj]
  · intro hj
    exact absurd (Finset.mem_univ j) hj

end TransferOperator
