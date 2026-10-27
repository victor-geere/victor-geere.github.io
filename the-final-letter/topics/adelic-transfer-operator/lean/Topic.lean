import Mathlib

/-!
# Adelic transfer operator — formal core

The archived source is a thesis *outline*.  It specifies the local
modular tensor category `C_p = SU(2)_{p-2}`, the local quantum
dimensions and `S`-matrix, the local RT weight `p^{-n}`, and the local
Fredholm factor `(1 - p^{-s})⁻¹`.  The global adelic operator, the
global determinant identity, the functional equation, the Ruelle
exclusion argument, and the Riemann-hypothesis conclusion are
archived claims and are *not* formalised here.

This file formalises the elementary local bookkeeping that the outline
actually defines:

* positivity and normalisation of the quantum dimensions;
* symmetry of the `S`-matrix and its relation to the quantum
  dimensions;
* the finite geometric identity behind the truncated local Euler
  factor;
* positivity and the geometric-series expansion of the local
  Fredholm/Euler factor.

Every declaration below is proved, with no unfinished proofs.
-/

noncomputable section

open scoped BigOperators

namespace Adelic

/-- Quantum dimension of the object labelled by `a` in
`C_p = SU(2)_{p-2}`, in the `1 … p - 1` labelling: `d_a = sin (π a / p) / sin (π / p)`.
The identity object is `a = 1`. -/
def qdim (p a : ℕ) : ℝ :=
  Real.sin (Real.pi * a / p) / Real.sin (Real.pi / p)

/-- The `(a, b)` entry of the `S`-matrix,
`S_{ab} = sqrt (2 / p) * sin (π a b / p)`. -/
def sEntry (p a b : ℕ) : ℝ :=
  Real.sqrt (2 / p) * Real.sin (Real.pi * a * b / p)

/-- The local RT weight of a length-`n` orbit: `p^{-n}`. -/
def rtWeight (p n : ℕ) : ℝ :=
  ((p : ℝ)⁻¹) ^ n

/-- The local Fredholm/Euler factor `(1 - x)⁻¹`. -/
def localDet (x : ℝ) : ℝ :=
  (1 - x)⁻¹

/-- The quantum dimension of the identity object is `1`. -/
theorem qdim_one {p : ℕ} (h : Real.sin (Real.pi / p) ≠ 0) :
    qdim p 1 = 1 := by
  unfold qdim
  simp only [Nat.cast_one, mul_one]
  field_simp [h]

/-- Quantum dimensions of non-identity objects are positive when the
label lies in the admissible range `1 ≤ a < p`. -/
theorem qdim_pos {p a : ℕ} (hp : 0 < p) (ha0 : 0 < a) (hap : a < p) :
    0 < qdim p a := by
  have hp1 : 1 < p := by omega
  have hp1R : (1 : ℝ) < (p : ℝ) := by exact_mod_cast hp1
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hapR : (a : ℝ) < (p : ℝ) := by exact_mod_cast hap
  have hpi : 0 < Real.pi := Real.pi_pos
  have hsinp : 0 < Real.sin (Real.pi / p) := by
    apply Real.sin_pos_of_pos_of_lt_pi
    · positivity
    · rw [div_lt_iff₀ hpR]
      nlinarith [hpi, hp1R]
  have hnum : 0 < Real.sin (Real.pi * a / p) := by
    apply Real.sin_pos_of_pos_of_lt_pi
    · positivity
    · rw [div_lt_iff₀ hpR]
      nlinarith [hpi, hapR]
  exact div_pos hnum hsinp

/-- The `S`-matrix is symmetric. -/
theorem sEntry_symm (p a b : ℕ) : sEntry p a b = sEntry p b a := by
  unfold sEntry
  have harg : Real.pi * a * b / p = Real.pi * b * a / p := by ring
  rw [harg]

/-- The identity row of the `S`-matrix is determined by the quantum
dimensions: `S_{1 b} = S_{1 1} * d_b`.  This is the finite identity that
the source uses when reducing the Verlinde sum to quantum dimensions. -/
theorem sEntry_one_eq_mul_qdim {p b : ℕ} (h : Real.sin (Real.pi / p) ≠ 0) :
    sEntry p 1 b = sEntry p 1 1 * qdim p b := by
  unfold sEntry qdim
  field_simp [h]
  ring_nf

/-- Finite geometric identity for the truncated local Euler factor:
`∑_{k<N} p^{-k} = (p^{-N} - 1) / (p^{-1} - 1)` for `p ≠ 1`. -/
theorem rtWeight_geom (p N : ℕ) (hp : p ≠ 1) :
    (∑ k ∈ Finset.range N, rtWeight p k) =
      (rtWeight p N - 1) / (rtWeight p 1 - 1) := by
  have hx : ((p : ℝ)⁻¹) ≠ 1 := by
    intro h
    have hp1 : ((p : ℝ)) = 1 := by
      simpa using congrArg Inv.inv h
    have hp1nat : p = 1 := by exact_mod_cast hp1
    exact hp hp1nat
  unfold rtWeight
  rw [geom_sum_eq hx]
  simp

/-- The local Fredholm factor is strictly larger than `1` when
`0 < x < 1`.  This is the positivity of the local Euler factor. -/
theorem localDet_gt_one {x : ℝ} (h0 : 0 < x) (h1 : x < 1) :
    1 < localDet x := by
  unfold localDet
  rw [one_lt_inv₀ (by linarith : (0 : ℝ) < 1 - x)]
  linarith

/-- The local Fredholm factor is the sum of the geometric series:
`(1 - x)⁻¹ = ∑_{n≥0} x^n` for `‖x‖ < 1`.  This is the formal content
of the source's periodic-orbit expansion of the local determinant. -/
theorem localDet_eq_tsum {x : ℝ} (h : ‖x‖ < 1) :
    localDet x = ∑' n : ℕ, x ^ n := by
  unfold localDet
  exact (hasSum_geometric_of_norm_lt_one h).tsum_eq.symm

end Adelic
