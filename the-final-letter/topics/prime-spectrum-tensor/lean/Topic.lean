import Mathlib

/-!
# Prime-spectrum tensor — formal core

The archived note `tensor.html` defines the prime current `Π` and the
archimedean current `Θ`, and asks whether the completed current
`P = Π + Θ` is of positive type on the Weil cone.  The companion
resolution `tensor.md` shows that the answer is no and that the correct
current is Weil's `W`, whose finite spectral model is a positive
combination of Fourier atoms at the zero ordinates.

This file formalises the elementary, unconditional part of that story:

* the prime weights `Λ(n)/√n` are non-negative, so finite truncations of
  `Π` are positive on non-negative test functions;
* each term of Riemann's Jacobi density is positive for `u ≥ 0` (the
  positivity of `Φ` used in `tensor.html` §5);
* the Fourier atom `exp (i γ x)` is Hermitian, and a positive combination
  of atoms has a non-negative finite Gram form — the finite Bochner step
  behind `tensor.md` Theorem C(2).

Nothing here asserts the Riemann hypothesis, the positivity of `P`, or
the positivity of Weil's current on the infinite cone; those remain
source claims or open items in the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The prime-current weight `Λ(n) / √n` of Definition 3.1. -/
def primeWeight (n : ℕ) : ℝ :=
  ArithmeticFunction.vonMangoldt n / Real.sqrt n

/-- Finite truncation `Σ_{n=2}^{N} Λ(n)/√n · f(log n)` of the prime current. -/
def primeCurrent (f : ℝ → ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.range (N + 1), primeWeight n * f (Real.log n)

/-- One term of Riemann's Jacobi density `Φ`, in the form displayed in
`tensor.md` §2 (with the substitution `x = e^{2u}`). -/
def jacobiTerm (n : ℕ) (u : ℝ) : ℝ :=
  (2 * Real.pi ^ 2 * (n : ℝ) ^ 4 * Real.exp (9 * u / 2)
      - 3 * Real.pi * (n : ℝ) ^ 2 * Real.exp (5 * u / 2))
    * Real.exp (-Real.pi * (n : ℝ) ^ 2 * Real.exp (2 * u))

/-- The Fourier atom at frequency `γ`, with weight `w`. -/
def atom (w γ x : ℝ) : ℂ :=
  (w : ℂ) * Complex.exp (Complex.I * (γ : ℂ) * (x : ℂ))

/-- A finite positive combination of Fourier atoms — the finite spectral
model of the repaired current `W` in `tensor.md` Theorem C. -/
def atomicKernel {N : ℕ} (w γ : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ k, atom (w k) (γ k) x

/-- The mode sum `Σ_j a_j e^{i γ u_j}` appearing in the Gram form. -/
def modeSum {M : ℕ} (a : Fin M → ℂ) (γ : ℝ) (u : Fin M → ℝ) : ℂ :=
  ∑ j, a j * Complex.exp (Complex.I * (γ : ℂ) * (u j : ℂ))

/-! ## The prime current -/

theorem primeWeight_nonneg (n : ℕ) : 0 ≤ primeWeight n := by
  unfold primeWeight
  exact div_nonneg ArithmeticFunction.vonMangoldt_nonneg (Real.sqrt_nonneg _)

/-- Finite truncations of `Π` are non-negative on non-negative test functions. -/
theorem primeCurrent_nonneg {f : ℝ → ℝ} (hf : ∀ x, 0 ≤ f x) (N : ℕ) :
    0 ≤ primeCurrent f N := by
  unfold primeCurrent
  exact Finset.sum_nonneg fun n _ => mul_nonneg (primeWeight_nonneg n) (hf _)

/-! ## The Jacobi density -/

/-- Each term of the Jacobi density is positive for `n ≥ 1` and `u ≥ 0`. -/
theorem jacobiTerm_pos {n : ℕ} (hn : 1 ≤ n) {u : ℝ} (hu : 0 ≤ u) :
    0 < jacobiTerm n u := by
  have hfac : jacobiTerm n u =
      Real.pi * (n : ℝ) ^ 2 * Real.exp (5 * u / 2)
        * (2 * Real.pi * (n : ℝ) ^ 2 * Real.exp (2 * u) - 3)
        * Real.exp (-Real.pi * (n : ℝ) ^ 2 * Real.exp (2 * u)) := by
    unfold jacobiTerm
    have h9 : Real.exp (9 * u / 2) = Real.exp (5 * u / 2) * Real.exp (2 * u) := by
      rw [← Real.exp_add]
      congr 1
      ring
    rw [h9]
    ring
  rw [hfac]
  have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hn2 : (1 : ℝ) ≤ (n : ℝ) ^ 2 := by
    nlinarith [sq_nonneg ((n : ℝ) - 1), hn1]
  have hexp : (1 : ℝ) ≤ Real.exp (2 * u) := by
    rw [← Real.exp_zero]
    exact Real.exp_le_exp.mpr (by linarith)
  have hprod : (1 : ℝ) ≤ (n : ℝ) ^ 2 * Real.exp (2 * u) := by
    calc (1 : ℝ) = 1 * 1 := by norm_num
      _ ≤ (n : ℝ) ^ 2 * Real.exp (2 * u) :=
        mul_le_mul hn2 hexp (by norm_num) (by positivity)
  have hbracket : 0 < 2 * Real.pi * (n : ℝ) ^ 2 * Real.exp (2 * u) - 3 := by
    nlinarith [Real.pi_gt_three, hprod]
  have hnpos : (0 : ℝ) < (n : ℝ) ^ 2 := by linarith
  exact mul_pos
    (mul_pos (mul_pos (mul_pos Real.pi_pos hnpos) (Real.exp_pos _)) hbracket)
    (Real.exp_pos _)

/-! ## Fourier atoms and the finite Gram form -/

/-- The Fourier atom is Hermitian: `atom w γ (-x) = conj (atom w γ x)`. -/
theorem atom_neg (w γ x : ℝ) : atom w γ (-x) = starRingEnd ℂ (atom w γ x) := by
  unfold atom
  rw [map_mul]
  have hw : starRingEnd ℂ (w : ℂ) = (w : ℂ) := by simp
  rw [hw]
  congr 1
  rw [← Complex.exp_conj]
  congr 1
  apply Complex.ext <;> simp


/-- The finite Gram form of a positive combination of Fourier atoms. -/
def gramForm {N M : ℕ} (w γ : Fin N → ℝ) (a : Fin M → ℂ) (u : Fin M → ℝ) : ℂ :=
  ∑ j, ∑ l, a j * starRingEnd ℂ (a l) * atomicKernel w γ (u j - u l)

/-- The one-frequency Gram form factors as the weight times `Z * conj Z`. -/
theorem atomForm_eq {M : ℕ} (w γ : ℝ) (a : Fin M → ℂ) (u : Fin M → ℝ) :
    (∑ j, ∑ l, a j * starRingEnd ℂ (a l) * atom w γ (u j - u l)) =
      (w : ℂ) * (modeSum a γ u * starRingEnd ℂ (modeSum a γ u)) := by
  unfold atom modeSum
  conv_rhs =>
    rw [map_sum]
    rw [Finset.sum_mul_sum]
  simp only [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro l _
  rw [map_mul]
  rw [← Complex.exp_conj]
  have hexp : Complex.exp (Complex.I * (γ : ℂ) * (u j : ℂ)) *
      Complex.exp (starRingEnd ℂ (Complex.I * (γ : ℂ) * (u l : ℂ))) =
      Complex.exp (Complex.I * (γ : ℂ) * ((u j : ℂ) - (u l : ℂ))) := by
    rw [← Complex.exp_add]
    congr 1
    apply Complex.ext <;> simp
    ring
  have hrearr : (↑w : ℂ) *
      (a j * Complex.exp (Complex.I * (γ : ℂ) * (u j : ℂ)) *
        (starRingEnd ℂ (a l) *
          Complex.exp (starRingEnd ℂ (Complex.I * (γ : ℂ) * (u l : ℂ))))) =
      a j * starRingEnd ℂ (a l) *
        (↑w * (Complex.exp (Complex.I * (γ : ℂ) * (u j : ℂ)) *
          Complex.exp (starRingEnd ℂ (Complex.I * (γ : ℂ) * (u l : ℂ))))) := by
    ring
  rw [hrearr, hexp]
  push_cast
  ring

/-- The Gram form factors through the Fourier modes: it is the sum over
frequencies of the weight times the squared modulus of the mode sum. -/
theorem gramForm_eq {N M : ℕ} (w γ : Fin N → ℝ) (a : Fin M → ℂ) (u : Fin M → ℝ) :
    gramForm w γ a u =
      ∑ k, (w k : ℂ) * (modeSum a (γ k) u * starRingEnd ℂ (modeSum a (γ k) u)) := by
  unfold gramForm atomicKernel
  simp only [Finset.mul_sum]
  conv_lhs =>
    arg 2
    ext j
    rw [Finset.sum_comm]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro k _
  exact atomForm_eq (w k) (γ k) a u

/-- The finite Gram form is non-negative on the diagonal when the atomic
weights are non-negative — the finite Bochner step of Theorem C(2). -/
theorem gramForm_re_nonneg {N M : ℕ} (w γ : Fin N → ℝ) (a : Fin M → ℂ) (u : Fin M → ℝ)
    (hw : ∀ k, 0 ≤ w k) : 0 ≤ (gramForm w γ a u).re := by
  rw [gramForm_eq]
  have hsum :
      Complex.reCLM (∑ k, (w k : ℂ) *
          (modeSum a (γ k) u * starRingEnd ℂ (modeSum a (γ k) u)))
        = ∑ k, Complex.reCLM ((w k : ℂ) *
          (modeSum a (γ k) u * starRingEnd ℂ (modeSum a (γ k) u))) :=
    map_sum _ _ _
  simp only [Complex.reCLM_apply] at hsum
  rw [hsum]
  apply Finset.sum_nonneg
  intro k _
  have hk : ((w k : ℂ) *
      (modeSum a (γ k) u * starRingEnd ℂ (modeSum a (γ k) u))).re
        = w k * Complex.normSq (modeSum a (γ k) u) := by
    rw [Complex.mul_conj]
    simp
  rw [hk]
  exact mul_nonneg (hw k) (Complex.normSq_nonneg _)

/-! ## Finite Gram positivity and a DH-shaped negative witness (P5)

A rational Cholesky certificate is the finite form of a positive Gram matrix:
if `G = Lᴴ L`, then `G` is positive semidefinite. The second matrix flips one
off-diagonal sign, the finite analogue of the DH twist; an explicit rational
vector makes its form negative. These are finite linear-algebra certificates for
the P5 shadow, not the infinite Weil form.
-/

open Matrix

/-- A rational lower-triangular factor. -/
def L3 : Matrix (Fin 3) (Fin 3) ℚ := !![1, 0, 0; 1, 1, 0; 1, 1, 1]

/-- The Gram matrix `L3ᴴ * L3`. -/
def G3 : Matrix (Fin 3) (Fin 3) ℚ := !![3, 2, 1; 2, 2, 1; 1, 1, 1]

theorem G3_eq : G3 = L3ᴴ * L3 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [G3, L3, Matrix.mul_apply, Matrix.conjTranspose_apply, Fin.sum_univ_three] <;> norm_num

/-- **Finite positivity certificate.**  The Gram matrix with a rational Cholesky
factor is positive semidefinite. -/
theorem G3_posSemidef : G3.PosSemidef := by
  rw [G3_eq]
  exact Matrix.posSemidef_conjTranspose_mul_self L3

/-- A DH-shaped finite twist: flip the sign of the off-diagonal entry. -/
def GDH : Matrix (Fin 2) (Fin 2) ℚ := !![1, 2; 2, 1]

/-- The rational witness vector `(1, -1)`. -/
def vDH : Fin 2 → ℚ := ![1, -1]

/-- **Negative witness.**  The DH-shaped Gram matrix is not positive semidefinite;
the form at `(1,-1)` is `-2`. -/
theorem GDH_not_posSemidef : ¬ GDH.PosSemidef := by
  intro h
  have hv := h.dotProduct_mulVec_nonneg vDH
  norm_num [GDH, vDH, dotProduct, mulVec, Fin.sum_univ_two] at hv

/-- **Generic finite P5 certificate.**  Any matrix of the form `Lᴴ L` with a
rational factor is positive semidefinite. -/
theorem posSemidef_of_cholesky {n : Type*} [Fintype n] [DecidableEq n]
    (L : Matrix n n ℚ) : (Lᴴ * L).PosSemidef :=
  Matrix.posSemidef_conjTranspose_mul_self L

/-- **Generic negative witness.**  A rational vector with negative form value
refutes positive semidefiniteness. -/
theorem not_posSemidef_of_neg {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℚ} {v : n → ℚ}
    (h : star v ⬝ᵥ (M *ᵥ v) < 0) : ¬ M.PosSemidef := by
  intro hM
  exact (not_le_of_gt h) (hM.dotProduct_mulVec_nonneg v)

end PrimeSpectrumTensor
