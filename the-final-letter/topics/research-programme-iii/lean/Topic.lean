import Mathlib

/-!
# Research Programme III — formal core

The archived proposal defines the quantum dimensions of `SU(2)_k`, the
Egyptian denominators `m_{j,k}`, finite categorical Dirichlet polynomials
`Psi_k(s)`, and a proposed limit to `zeta(2s)`.  This file formalises the
elementary finite facts about those definitions.  The convergence to
`zeta(2s)`, the Quantum–Egyptian functional equation, the explicit formula,
and the Riemann-hypothesis goal are **not** formalised here; they remain
source claims or open items in the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace RPIII

/-- Quantum dimension `d_n = sin(pi n / N) / sin(pi / N)` for `N = k + 2`. -/
def qdim (N n : ℝ) : ℝ :=
  Real.sin (Real.pi * n / N) / Real.sin (Real.pi / N)

/-- The total quantum dimension squared, in the proposal's normalisation. -/
def D2 (N : ℝ) : ℝ :=
  N / (4 * Real.sin (Real.pi / N) ^ 2)

/-- Egyptian denominator `m_n = N / (4 sin^2(pi n / N))`. -/
def egyptianDenom (N n : ℝ) : ℝ :=
  N / (4 * Real.sin (Real.pi * n / N) ^ 2)

/-- A finite categorical Dirichlet polynomial with supplied signs. -/
def psi {ι : Type*} (S : Finset ι) (s : ℝ) (m χ : ι → ℝ) : ℝ :=
  ∑ i ∈ S, χ i * (m i) ^ (-s)

/-- Reflection symmetry of the quantum dimensions: `d_{N-n} = d_n`. -/
theorem qdim_symm {N n : ℝ} (hN : N ≠ 0) :
    qdim N (N - n) = qdim N n := by
  unfold qdim
  have h : Real.pi * (N - n) / N = Real.pi - Real.pi * n / N := by
    field_simp [hN]
  rw [h, Real.sin_pi_sub]

/-- Reflection symmetry of the Egyptian denominators: `m_{N-n} = m_n`. -/
theorem egyptianDenom_symm {N n : ℝ} (hN : N ≠ 0) :
    egyptianDenom N (N - n) = egyptianDenom N n := by
  unfold egyptianDenom
  have h : Real.pi * (N - n) / N = Real.pi - Real.pi * n / N := by
    field_simp [hN]
  rw [h, Real.sin_pi_sub]

/-- Every Egyptian denominator in the open range `0 < n < N` is positive. -/
theorem egyptianDenom_pos {N n : ℝ} (hN : 0 < N) (hn0 : 0 < n) (hnN : n < N) :
    0 < egyptianDenom N n := by
  unfold egyptianDenom
  have hx0 : 0 < Real.pi * n / N := by positivity
  have hxpi : Real.pi * n / N < Real.pi := by
    have h : Real.pi * n < Real.pi * N := by nlinarith [Real.pi_pos]
    exact (div_lt_iff₀ hN).mpr h
  have hsin : 0 < Real.sin (Real.pi * n / N) :=
    Real.sin_pos_of_pos_of_lt_pi hx0 hxpi
  exact div_pos hN (by positivity)

/-- At the reflection fixed point `n = N/2`, the denominator is exactly `N/4`. -/
theorem egyptianDenom_mid (N : ℝ) (hN : N ≠ 0) :
    egyptianDenom N (N / 2) = N / 4 := by
  unfold egyptianDenom
  have h : Real.pi * (N / 2) / N = Real.pi / 2 := by
    field_simp [hN]
  rw [h, Real.sin_pi_div_two]
  norm_num

/-- The trivial triangle-inequality bound for a finite Dirichlet polynomial:
`|sum chi_i m_i^{-s}| <= sum m_i^{-s}` when the signs have modulus one. -/
theorem psi_abs_le {ι : Type*} (S : Finset ι) (s : ℝ) (m χ : ι → ℝ)
    (hm : ∀ i ∈ S, 0 < m i) (hχ : ∀ i ∈ S, |χ i| = 1) :
    |psi S s m χ| ≤ ∑ i ∈ S, (m i) ^ (-s) := by
  unfold psi
  calc
    |∑ i ∈ S, χ i * (m i) ^ (-s)| ≤ ∑ i ∈ S, |χ i * (m i) ^ (-s)| :=
      Finset.abs_sum_le_sum_abs _ _
    _ = ∑ i ∈ S, (m i) ^ (-s) := by
      refine Finset.sum_congr rfl ?_
      intro i hi
      rw [abs_mul, hχ i hi, one_mul]
      exact abs_of_pos (Real.rpow_pos_of_pos (hm i hi) _)

/-- Zero reflection under the QEFE-type symmetry: if `Lambda` satisfies
`Lambda s = eps * star (Lambda (1 - s))` with `eps = ±1`, and has real
coefficients (`Lambda (star s) = star (Lambda s)`), then a zero at `rho`
forces a zero at `1 - star rho`.  This is the elementary symmetry behind the
proposal's statement that the zeros are symmetric about `Re s = 1/2`; the
proposal does not prove that `Lambda_k` itself has these two properties. -/
theorem zero_reflection {Λ : ℂ → ℂ} {ε : ℂ}
    (hε : ε = 1 ∨ ε = -1)
    (hFE : ∀ s : ℂ, Λ s = ε * star (Λ (1 - s)))
    (hreal : ∀ s : ℂ, Λ (star s) = star (Λ s))
    {ρ : ℂ} (hρ : Λ ρ = 0) : Λ (1 - star ρ) = 0 := by
  have hconj : Λ (star ρ) = 0 := by
    rw [hreal, hρ]
    simp
  have h := hFE (star ρ)
  rw [hconj] at h
  have hε0 : ε ≠ 0 := by
    rcases hε with h | h <;> rw [h] <;> norm_num
  have hz : star (Λ (1 - star ρ)) = 0 :=
    (mul_eq_zero.mp h.symm).resolve_left hε0
  simpa using congrArg star hz

/-- The coefficient weight `log m / sqrt m` appearing in the proposal's
explicit formula is positive for `m > 1`. -/
theorem log_weight_pos {m : ℝ} (hm : 1 < m) :
    0 < Real.log m / Real.sqrt m := by
  have hm0 : 0 < m := by linarith
  exact div_pos (Real.log_pos hm) (Real.sqrt_pos.mpr hm0)

end RPIII
