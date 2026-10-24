import Mathlib

/-!
# Yakaboylu notes — formal core

The archived notes study the Dirichlet eta function
`η(s) = Σ (-1)^(n-1) n^(-s)` through its truncated real and imaginary
parts `U_N` and `V_N`, the amplitude bound `S_N(σ) = Σ_{n=2}^N n^(-σ)`,
and Yakaboylu's weight function `ω(t) = t e^t / (1 + e^t)^2`.

This file formalises the elementary part of that picture:

* the amplitude bound `|R_N(σ,t)| ≤ S_N(σ)` and its consequence that the
  truncated equation `R_N = 1` has no solution when `S_N(σ) < 1`;
* strict antitonicity and positivity of `S_N`;
* oddness and positivity of the weight `ω`.

The analytic continuation, the functional equation, the threshold
`σ_0` with `ζ(σ_0) = 2`, and every Riemann-hypothesis statement in the
source are recorded as source claims or open items in the dossier; they
are not proved here.
-/

noncomputable section

open Finset
open scoped BigOperators

namespace Yakaboylu

/-- The amplitude bound `S_N(σ) = Σ_{n=2}^N n^(-σ)`. -/
def S (σ : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.Icc 2 N, Real.rpow (n : ℝ) (-σ)

/-- The truncated alternating cosine sum `R_N(σ,t)` whose equation
`R_N = 1` is the real-zero condition `U_N(σ,t) = 0`. -/
def R (σ t : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.Icc 2 N,
    (-1 : ℝ) ^ n * Real.rpow (n : ℝ) (-σ) * Real.cos (t * Real.log n)

/-- Yakaboylu's weight function `ω(t) = t e^t / (1 + e^t)^2`. -/
def weight (t : ℝ) : ℝ := t * Real.exp t / (1 + Real.exp t) ^ 2

/-- **Amplitude bound.** The alternating cosine sum is dominated by the
sum of the absolute amplitudes. This is the elementary estimate behind
the notes' truncation argument. -/
theorem abs_R_le_S (σ t : ℝ) (N : ℕ) : |R σ t N| ≤ S σ N := by
  unfold R S
  calc
    |∑ n ∈ Finset.Icc 2 N,
        (-1 : ℝ) ^ n * Real.rpow (n : ℝ) (-σ) * Real.cos (t * Real.log n)|
        ≤ ∑ n ∈ Finset.Icc 2 N,
            |(-1 : ℝ) ^ n * Real.rpow (n : ℝ) (-σ) * Real.cos (t * Real.log n)|
          := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ n ∈ Finset.Icc 2 N, Real.rpow (n : ℝ) (-σ) := by
        apply Finset.sum_le_sum
        intro n _
        rw [abs_mul, abs_mul, abs_pow]
        have hsign : |(-1 : ℝ)| = 1 := by norm_num
        rw [hsign, one_pow, one_mul]
        have hamp : 0 ≤ Real.rpow (n : ℝ) (-σ) := Real.rpow_nonneg (by positivity) _
        rw [abs_of_nonneg hamp]
        exact mul_le_of_le_one_right hamp (Real.abs_cos_le_one _)

/-- **No real zero below the threshold.** If `S_N(σ) < 1`, the truncated
equation `U_N(σ,t) = 0`, written as `R_N(σ,t) = 1`, has no solution. -/
theorem R_ne_one_of_S_lt_one {σ t : ℝ} {N : ℕ} (h : S σ N < 1) :
    R σ t N ≠ 1 := by
  intro hR
  have hbound := abs_R_le_S σ t N
  rw [hR, abs_one] at hbound
  linarith

/-- **Strict antitonicity of the amplitude bound.** For `N ≥ 2` the sum
`S_N(σ)` is strictly decreasing in `σ`: every term `n^(-σ)` decreases. -/
theorem S_lt_S {σ₁ σ₂ : ℝ} (h : σ₁ < σ₂) {N : ℕ} (hN : 2 ≤ N) :
    S σ₂ N < S σ₁ N := by
  unfold S
  apply Finset.sum_lt_sum
  · intro n hn
    have hn2 : (2 : ℝ) ≤ (n : ℝ) := by
      exact_mod_cast (Finset.mem_Icc.mp hn).1
    have hbase : (1 : ℝ) < (n : ℝ) := by linarith
    exact le_of_lt (Real.rpow_lt_rpow_of_exponent_lt hbase (by linarith))
  · refine ⟨2, by simp [hN], ?_⟩
    have hbase : (1 : ℝ) < (2 : ℝ) := by norm_num
    exact Real.rpow_lt_rpow_of_exponent_lt hbase (by linarith)

/-- **Positivity of the amplitude bound.** Every term is a positive
power, and the index set is non-empty for `N ≥ 2`. -/
theorem S_pos {N : ℕ} (hN : 2 ≤ N) (σ : ℝ) : 0 < S σ N := by
  unfold S
  apply Finset.sum_pos
  · intro n hn
    have h2n : 2 ≤ n := (Finset.mem_Icc.mp hn).1
    have hn0 : (0 : ℝ) < (n : ℝ) := by
      exact_mod_cast (by omega : 0 < n)
    exact Real.rpow_pos_of_pos hn0 _
  · exact ⟨2, by simp [hN]⟩

/-- **Finite value at the boundary `σ = 0`.** At `σ = 0` every amplitude
is `1`, so `S_N(0) = N - 1`; in particular `S_N(0) ≥ 1` for `N ≥ 2`,
which is why the threshold `σ_N` exists. -/
theorem S_zero {N : ℕ} (hN : 1 ≤ N) : S 0 N = (N : ℝ) - 1 := by
  unfold S
  have hterm : ∀ n ∈ Finset.Icc 2 N, Real.rpow (n : ℝ) (-(0 : ℝ)) = 1 := by
    intro n _
    simp
  rw [Finset.sum_congr rfl hterm, Finset.sum_const, Nat.card_Icc]
  norm_num
  rw [Nat.cast_sub hN]
  norm_num

/-- **Oddness of the weight.** `ω(-t) = -ω(t)`. -/
theorem weight_odd (t : ℝ) : weight (-t) = -weight t := by
  unfold weight
  rw [Real.exp_neg]
  have he : Real.exp t ≠ 0 := Real.exp_ne_zero t
  field_simp
  ring

/-- **Positivity of the weight on the positive axis.** -/
theorem weight_pos {t : ℝ} (ht : 0 < t) : 0 < weight t := by
  unfold weight
  apply div_pos
  · exact mul_pos ht (Real.exp_pos t)
  · positivity

end Yakaboylu
