import Mathlib

/-!
# Greedy-harmonic Hilbert–Pólya — formal core

This file records the part of the archived greedy-harmonic Hilbert–Pólya
framework that is genuinely elementary and checkable: the local quadratic
factors `Q₀` and `Qₙ`, their discriminants, their explicit roots, and the
Vieta bookkeeping used by the trace formula.

The transfer operator, the self-adjoint operator `H`, the Fredholm
determinant identity, the spectral shift function and the Mellin
bijectivity are **not** formalised here.  They are recorded as source
claims / open items in the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace GHHP

/-- The local quadratic factor at the base cylinder,
`Q₀(s) = s² - (3/2)s + 1/4`. -/
def Q0 (s : ℝ) : ℝ := s ^ 2 - (3 / 2) * s + 1 / 4

/-- The local quadratic factor at cylinder `n ≥ 1`,
`Qₙ(s) = s² - (2n+3)/(n+2) s + (2n+3)/((n+1)(n+2)²)`. -/
def Q (n : ℕ) (s : ℝ) : ℝ :=
  s ^ 2 - ((2 * (n : ℝ) + 3) / ((n : ℝ) + 2)) * s
    + (2 * (n : ℝ) + 3) / (((n : ℝ) + 1) * ((n : ℝ) + 2) ^ 2)

/-- The discriminant of `Q₀`. -/
def disc0 : ℝ := (3 / 2) ^ 2 - 4 * (1 / 4)

/-- The discriminant of `Qₙ`, as it arises from the coefficients. -/
def disc (n : ℕ) : ℝ :=
  ((2 * (n : ℝ) + 3) / ((n : ℝ) + 2)) ^ 2
    - 4 * ((2 * (n : ℝ) + 3) / (((n : ℝ) + 1) * ((n : ℝ) + 2) ^ 2))

/-- The larger closed-form root of `Qₙ`, `n ≥ 1`. -/
def lamPlus (n : ℕ) : ℝ :=
  ((2 * (n : ℝ) + 3)
      + Real.sqrt ((2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1)
          / ((n : ℝ) + 1)))
    / (2 * ((n : ℝ) + 2))

/-- The smaller closed-form root of `Qₙ`, `n ≥ 1`. -/
def lamMinus (n : ℕ) : ℝ :=
  ((2 * (n : ℝ) + 3)
      - Real.sqrt ((2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1)
          / ((n : ℝ) + 1)))
    / (2 * ((n : ℝ) + 2))

/-- The base quadratic has positive discriminant (`5/4`), so its two roots are real. -/
theorem disc0_pos : 0 < disc0 := by
  unfold disc0
  norm_num

/-- The two explicit base roots `(3 ± √5)/4` really are roots of `Q₀`. -/
theorem Q0_roots :
    Q0 ((3 + Real.sqrt 5) / 4) = 0 ∧ Q0 ((3 - Real.sqrt 5) / 4) = 0 := by
  have h5 : (Real.sqrt 5) ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  constructor <;> unfold Q0 <;> nlinarith

/-- The constant term of every `Qₙ` is strictly positive. -/
theorem Q_const_pos (n : ℕ) :
    0 < (2 * (n : ℝ) + 3) / (((n : ℝ) + 1) * ((n : ℝ) + 2) ^ 2) := by
  positivity

/-- The discriminant of `Qₙ` equals the source's closed form. -/
theorem Q_discriminant (n : ℕ) :
    disc n = ((2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1))
      / (((n : ℝ) + 1) * ((n : ℝ) + 2) ^ 2) := by
  unfold disc
  have h1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have h2 : ((n : ℝ) + 2) ≠ 0 := by positivity
  field_simp [h1, h2]
  ring

/-- For `n ≥ 1` the discriminant of `Qₙ` is strictly positive. -/
theorem Q_discriminant_pos {n : ℕ} (hn : 1 ≤ n) : 0 < disc n := by
  rw [Q_discriminant]
  have hn' : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have h2 : (0 : ℝ) < (n : ℝ) + 2 := by positivity
  have hquad : (0 : ℝ) < 2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1 := by
    nlinarith [sq_nonneg ((n : ℝ) - 1)]
  have hnum : (0 : ℝ) < (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) := by
    have : (0 : ℝ) < 2 * (n : ℝ) + 3 := by positivity
    exact mul_pos this hquad
  exact div_pos hnum (mul_pos h1 (pow_pos h2 2))

/-- The explicit roots `λₙ,±` satisfy the local quadratic `Qₙ` for `n ≥ 1`. -/
theorem Q_roots {n : ℕ} (hn : 1 ≤ n) :
    Q n (lamPlus n) = 0 ∧ Q n (lamMinus n) = 0 := by
  have hD : 0 < (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1)
      / ((n : ℝ) + 1) := by
    have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
    have h2 : (0 : ℝ) < (n : ℝ) + 2 := by positivity
    have hn' : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hquad : (0 : ℝ) < 2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1 := by
      nlinarith [sq_nonneg ((n : ℝ) - 1)]
    have hnum : (0 : ℝ) < (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) := by
      have : (0 : ℝ) < 2 * (n : ℝ) + 3 := by positivity
      exact mul_pos this hquad
    exact div_pos hnum h1
  have h1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have h2 : ((n : ℝ) + 2) ≠ 0 := by positivity
  simp only [Q, lamPlus, lamMinus]
  set s : ℝ := Real.sqrt ((2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1)
      / ((n : ℝ) + 1)) with hs
  have hsq : s ^ 2
      = (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) / ((n : ℝ) + 1) := by
    rw [hs]
    exact Real.sq_sqrt (le_of_lt hD)
  have hsq' : s ^ 2 * ((n : ℝ) + 1)
      = (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) := by
    field_simp [h1] at hsq ⊢
    linarith [hsq]
  constructor <;> field_simp [h1, h2] <;> nlinarith [hsq']

/-- Vieta bookkeeping: the trace and determinant of each `2 × 2` block are the
source's coefficient expressions. -/
theorem Q_vieta {n : ℕ} (hn : 1 ≤ n) :
    lamPlus n + lamMinus n = (2 * (n : ℝ) + 3) / ((n : ℝ) + 2) ∧
      lamPlus n * lamMinus n
        = (2 * (n : ℝ) + 3) / (((n : ℝ) + 1) * ((n : ℝ) + 2) ^ 2) := by
  have hD : 0 < (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1)
      / ((n : ℝ) + 1) := by
    have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
    have hn' : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hquad : (0 : ℝ) < 2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1 := by
      nlinarith [sq_nonneg ((n : ℝ) - 1)]
    have hnum : (0 : ℝ) < (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) := by
      have : (0 : ℝ) < 2 * (n : ℝ) + 3 := by positivity
      exact mul_pos this hquad
    exact div_pos hnum h1
  have h1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have h2 : ((n : ℝ) + 2) ≠ 0 := by positivity
  simp only [lamPlus, lamMinus]
  set s : ℝ := Real.sqrt ((2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1)
      / ((n : ℝ) + 1)) with hs
  have hsq : s ^ 2
      = (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) / ((n : ℝ) + 1) := by
    rw [hs]
    exact Real.sq_sqrt (le_of_lt hD)
  have hsq' : s ^ 2 * ((n : ℝ) + 1)
      = (2 * (n : ℝ) + 3) * (2 * (n : ℝ) ^ 2 + 5 * (n : ℝ) - 1) := by
    field_simp [h1] at hsq ⊢
    linarith [hsq]
  constructor
  · field_simp [h2]
    ring
  · field_simp [h1, h2]
    nlinarith [hsq']

end GHHP
