import Mathlib

/-!
# Periodic orbits on Bruhat–Tits trees — formal core

This file records the finite, elementary part of the *periodic-orbits*
programme: the modular data of `SU(2)_{p-2}`, the positivity and symmetry
of the quantum dimensions, the relation between the `S`-matrix and the
quantum dimensions, positivity of the local Reshetikhin–Turaev weight
`p^{-n}`, its finite geometric (local Euler-factor) identity, and the
positivity of the writhe of a full twist.

The source's main local identity `RT_{C_p}(β) = p^{-n}` is **not** proved
here: the archived source itself retracts it in `3_2.tex` and the later
repair sections are circular.  The global adelic/spectral claim is open.
See `lean/README.md` and the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace PeriodicOrbits

/-- Quantum dimension of the label `r = 2j + 1` in `SU(2)_{p-2}`:
`d_r = sin(π r / p) / sin(π / p)`. -/
def qdim (p r : ℕ) : ℝ :=
  Real.sin (Real.pi * (r : ℝ) / (p : ℝ)) / Real.sin (Real.pi / (p : ℝ))

/-- The `(r, r')` entry of the modular `S`-matrix:
`S_{r r'} = sqrt(2/p) * sin(π r r' / p)`. -/
def Smat (p r r' : ℕ) : ℝ :=
  Real.sqrt (2 / (p : ℝ)) * Real.sin (Real.pi * (r : ℝ) * (r' : ℝ) / (p : ℝ))

/-- The squared total quantum dimension `D_p^2 = p / (2 sin^2(π/p))`. -/
def Dsq (p : ℕ) : ℝ :=
  (p : ℝ) / (2 * Real.sin (Real.pi / (p : ℝ)) ^ 2)

/-- The local Reshetikhin–Turaev weight `p^{-n}`. -/
def rtWeight (p n : ℕ) : ℝ := ((p : ℝ))⁻¹ ^ n

/-- Writhe of a braid word, encoded as its list of signed exponents. -/
def writhe (w : List ℤ) : ℤ := w.sum

/-- The quantum dimensions are strictly positive for every admissible label
`0 < r < p`. -/
theorem qdim_pos {p r : ℕ} (hp : 0 < p) (hr : 0 < r) (hrp : r < p) :
    0 < qdim p r := by
  unfold qdim
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hp_gt1 : (1 : ℝ) < (p : ℝ) := by
    have h1 : 1 < p := by omega
    exact_mod_cast h1
  have hrpR : (r : ℝ) < (p : ℝ) := by exact_mod_cast hrp
  have hden : 0 < Real.sin (Real.pi / (p : ℝ)) := by
    apply Real.sin_pos_of_pos_of_lt_pi
    · positivity
    · rw [div_lt_iff₀ hpR]
      nlinarith [Real.pi_pos, hp_gt1]
  have hnum : 0 < Real.sin (Real.pi * (r : ℝ) / (p : ℝ)) := by
    apply Real.sin_pos_of_pos_of_lt_pi
    · positivity
    · rw [div_lt_iff₀ hpR]
      nlinarith [Real.pi_pos, hrpR]
  exact div_pos hnum hden

/-- The quantum dimensions are symmetric under `r ↦ p - r`. -/
theorem qdim_symm {p r : ℕ} (hp : 0 < p) (hr : r ≤ p) :
    qdim p r = qdim p (p - r) := by
  unfold qdim
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hpne : (p : ℝ) ≠ 0 := ne_of_gt hpR
  have hcast : ((p - r : ℕ) : ℝ) = (p : ℝ) - (r : ℝ) := by
    rw [Nat.cast_sub hr]
  have harg :
      Real.pi * ((p - r : ℕ) : ℝ) / (p : ℝ)
        = Real.pi - Real.pi * (r : ℝ) / (p : ℝ) := by
    rw [hcast]
    field_simp [hpne]
  rw [harg, Real.sin_pi_sub]

/-- The `S`-matrix entry `S_{1 r}` is the quantum dimension `d_r` times the
normalising constant `sqrt(2/p) * sin(π/p)`. -/
theorem smat_one {p r : ℕ} (hp : 1 < p) :
    Smat p 1 r
      = Real.sqrt (2 / (p : ℝ)) * Real.sin (Real.pi / (p : ℝ)) * qdim p r := by
  unfold Smat qdim
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast (by omega : 0 < p)
  have hp1 : (1 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hsin : Real.sin (Real.pi / (p : ℝ)) ≠ 0 := by
    apply ne_of_gt
    apply Real.sin_pos_of_pos_of_lt_pi
    · positivity
    · rw [div_lt_iff₀ hpR]
      nlinarith [Real.pi_pos, hp1]
  simp only [Nat.cast_one]
  field_simp [hsin]

/-- The squared total quantum dimension is strictly positive. -/
theorem Dsq_pos {p : ℕ} (hp : 1 < p) : 0 < Dsq p := by
  unfold Dsq
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast (by omega : 0 < p)
  have hp1 : (1 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hden : 0 < 2 * Real.sin (Real.pi / (p : ℝ)) ^ 2 := by
    have hsin : 0 < Real.sin (Real.pi / (p : ℝ)) := by
      apply Real.sin_pos_of_pos_of_lt_pi
      · positivity
      · rw [div_lt_iff₀ hpR]
        nlinarith [Real.pi_pos, hp1]
    positivity
  exact div_pos hpR hden

/-- The local RT weight `p^{-n}` is strictly positive. -/
theorem rtWeight_pos {p : ℕ} (hp : 0 < p) (n : ℕ) : 0 < rtWeight p n := by
  unfold rtWeight
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  exact pow_pos (inv_pos.mpr hpR) n

/-- Finite geometric identity: the truncated local Euler factor is
`(1 - p^{-N}) / (1 - p^{-1})`. -/
theorem geom_rtWeight {p : ℕ} (hp : 1 < p) (N : ℕ) :
    ∑ n ∈ Finset.range N, rtWeight p n
      = (1 - rtWeight p N) / (1 - ((p : ℝ))⁻¹) := by
  have hpR : (1 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hpne : (p : ℝ) ≠ 1 := by linarith
  have hq : ((p : ℝ))⁻¹ ≠ 1 := by
    simpa [inv_eq_one] using hpne
  unfold rtWeight
  rw [geom_sum_eq hq N]
  field_simp [hq]
  try ring

/-- A full twist on `n ≥ 2` strands has positive writhe `n(n-1)`. -/
theorem fullTwist_writhe_pos {n : ℕ} (hn : 2 ≤ n) :
    0 < writhe (List.replicate (n * (n - 1)) (1 : ℤ)) := by
  unfold writhe
  rw [List.sum_replicate]
  have hpos : 0 < n * (n - 1) := Nat.mul_pos (by omega) (by omega)
  have hcast : (0 : ℤ) < ((n * (n - 1) : ℕ) : ℤ) := by exact_mod_cast hpos
  simpa using hcast

end PeriodicOrbits
