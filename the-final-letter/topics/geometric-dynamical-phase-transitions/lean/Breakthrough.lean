import Mathlib

/-!
# Geometric DQPT — asymptotic breakthrough

This file proves the first asymptotic form of the last-chord dichotomy:
the critical-line twin tends to `1/2`, and the right-half twin tends to `0`.
The left-half blow-up and the full three-case dichotomy are recorded separately.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace GeoDQPT

/-- The absolute last chord, repeated here to keep this file self-contained. -/
def lastChordAbs (N : ℕ) (σ : ℝ) : ℝ := ((N : ℝ) - 1) / 2 * (N : ℝ) ^ (-2 * σ)

/-- The algebraic rewrite used for the asymptotics:
`L_N(σ) = (1/2)(1 - 1/N) N^(1-2σ)` for `N ≥ 1`. -/
theorem lastChordAbs_eq_half_mul {N : ℕ} (hN : 1 ≤ N) (σ : ℝ) :
    lastChordAbs N σ = (1 / 2 : ℝ) * (1 - 1 / (N : ℝ)) * (N : ℝ) ^ (1 - 2 * σ) := by
  unfold lastChordAbs
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hN)
  have hNne : (N : ℝ) ≠ 0 := ne_of_gt hNpos
  rw [show (1 : ℝ) - 2 * σ = 1 + (-2 * σ) by ring, Real.rpow_add hNpos, Real.rpow_one]
  field_simp

/-- The critical-line last chord tends to `1/2`. -/
theorem lastChordAbs_half_tendsto :
    Tendsto (fun N : ℕ => lastChordAbs N (1 / 2)) atTop (𝓝 (1 / 2)) := by
  have hterm : ∀ᶠ N : ℕ in atTop, lastChordAbs N (1 / 2) =
      (1 / 2 : ℝ) * (1 - 1 / (N : ℝ)) := by
    filter_upwards [eventually_ge_atTop (1 : ℕ)] with N hN
    rw [lastChordAbs_eq_half_mul hN (1 / 2)]
    norm_num
  have hlim : Tendsto (fun N : ℕ => (1 / 2 : ℝ) * (1 - 1 / (N : ℝ))) atTop (𝓝 (1 / 2)) := by
    have hone : Tendsto (fun N : ℕ => (1 : ℝ) / (N : ℝ)) atTop (𝓝 0) :=
      tendsto_one_div_atTop_nhds_zero_nat
    have hsub : Tendsto (fun N : ℕ => 1 - (1 : ℝ) / (N : ℝ)) atTop (𝓝 (1 - 0)) :=
      tendsto_const_nhds.sub hone
    simpa using hsub.const_mul (1 / 2 : ℝ)
  exact hlim.congr' (hterm.mono fun N h => h.symm)



/-- For `σ > 1/2`, the right-half last chord tends to `0`. -/
theorem lastChordAbs_tendsto_zero_of_half_lt {σ : ℝ} (hσ : 1 / 2 < σ) :
    Tendsto (fun N : ℕ => lastChordAbs N σ) atTop (𝓝 0) := by
  have ha : 0 < 2 * σ - 1 := by linarith
  have hpow : Tendsto (fun N : ℕ => (N : ℝ) ^ (-(2 * σ - 1))) atTop (𝓝 0) := by
    have hreal : Tendsto (fun x : ℝ => x ^ (-(2 * σ - 1))) atTop (𝓝 0) :=
      tendsto_rpow_neg_atTop ha
    exact hreal.comp tendsto_natCast_atTop_atTop
  have hupper : Tendsto (fun N : ℕ => (1 / 2 : ℝ) * (N : ℝ) ^ (1 - 2 * σ)) atTop (𝓝 0) := by
    have hcongr : (fun N : ℕ => (N : ℝ) ^ (1 - 2 * σ)) =
        fun N : ℕ => (N : ℝ) ^ (-(2 * σ - 1)) := by
      funext N
      congr 1
      ring
    simpa [hcongr] using hpow.const_mul (1 / 2 : ℝ)
  have hbound : ∀ᶠ N : ℕ in atTop,
      0 ≤ lastChordAbs N σ ∧ lastChordAbs N σ ≤ (1 / 2 : ℝ) * (N : ℝ) ^ (1 - 2 * σ) := by
    filter_upwards [eventually_ge_atTop (1 : ℕ)] with N hN
    have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hN)
    constructor
    · unfold lastChordAbs
      have hcoef_nonneg : 0 ≤ ((N : ℝ) - 1) / 2 := by
        have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
        linarith
      exact mul_nonneg hcoef_nonneg (Real.rpow_nonneg (by positivity) _)
    · unfold lastChordAbs
      have hpow_nonneg : 0 ≤ (N : ℝ) ^ (-2 * σ) := Real.rpow_nonneg (by positivity) _
      have hcoef : ((N : ℝ) - 1) / 2 ≤ (N : ℝ) / 2 := by
        have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
        linarith
      calc
        ((N : ℝ) - 1) / 2 * (N : ℝ) ^ (-2 * σ)
            ≤ ((N : ℝ) / 2) * (N : ℝ) ^ (-2 * σ) :=
              mul_le_mul_of_nonneg_right hcoef hpow_nonneg
        _ = (1 / 2 : ℝ) * ((N : ℝ) * (N : ℝ) ^ (-2 * σ)) := by ring
        _ = (1 / 2 : ℝ) * (N : ℝ) ^ (1 - 2 * σ) := by
          rw [show (1 : ℝ) - 2 * σ = 1 + (-2 * σ) by ring, Real.rpow_add hNpos, Real.rpow_one]
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hupper
    (hbound.mono fun N h => h.1) (hbound.mono fun N h => h.2)



/-- For `σ < 1/2`, the left-half last chord blows up. -/
theorem lastChordAbs_tendsto_atTop_of_lt_half {σ : ℝ} (hσ : σ < 1 / 2) :
    Tendsto (fun N : ℕ => lastChordAbs N σ) atTop atTop := by
  have ha : 0 < 1 - 2 * σ := by linarith
  have hlower : Tendsto (fun N : ℕ => (1 / 4 : ℝ) * (N : ℝ) ^ (1 - 2 * σ)) atTop atTop := by
    have hpow : Tendsto (fun N : ℕ => (N : ℝ) ^ (1 - 2 * σ)) atTop atTop :=
      (tendsto_rpow_atTop ha).comp tendsto_natCast_atTop_atTop
    exact hpow.const_mul_atTop (by norm_num : (0 : ℝ) < 1 / 4)
  refine tendsto_atTop_mono' atTop ?_ hlower
  filter_upwards [eventually_ge_atTop (2 : ℕ)] with N hN
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_of_lt_of_le (by norm_num) hN)
  have hpow_nonneg : 0 ≤ (N : ℝ) ^ (-2 * σ) := Real.rpow_nonneg (by positivity) _
  have hcoef : (N : ℝ) / 4 ≤ ((N : ℝ) - 1) / 2 := by
    have hN2 : (2 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
    linarith
  calc
    (1 / 4 : ℝ) * (N : ℝ) ^ (1 - 2 * σ)
        = ((N : ℝ) / 4) * (N : ℝ) ^ (-2 * σ) := by
          rw [show (1 : ℝ) - 2 * σ = 1 + (-2 * σ) by ring, Real.rpow_add hNpos, Real.rpow_one]
          ring
    _ ≤ (((N : ℝ) - 1) / 2) * (N : ℝ) ^ (-2 * σ) :=
          mul_le_mul_of_nonneg_right hcoef hpow_nonneg
    _ = lastChordAbs N σ := rfl



/-- The full two-sided last-chord dichotomy away from `σ = 1/2`: one twin
blows up and the other tends to zero. -/
theorem lastChordAbs_dichotomy {σ : ℝ} (hσ : σ ≠ 1 / 2) :
    (σ < 1 / 2 ∧
        Tendsto (fun N : ℕ => lastChordAbs N σ) atTop atTop ∧
        Tendsto (fun N : ℕ => lastChordAbs N (1 - σ)) atTop (𝓝 0)) ∨
      (1 / 2 < σ ∧
        Tendsto (fun N : ℕ => lastChordAbs N σ) atTop (𝓝 0) ∧
        Tendsto (fun N : ℕ => lastChordAbs N (1 - σ)) atTop atTop) := by
  rcases lt_or_gt_of_ne hσ with hlt | hgt
  · left
    refine ⟨hlt, lastChordAbs_tendsto_atTop_of_lt_half hlt, ?_⟩
    have h1 : 1 / 2 < 1 - σ := by linarith
    exact lastChordAbs_tendsto_zero_of_half_lt h1
  · right
    refine ⟨hgt, lastChordAbs_tendsto_zero_of_half_lt hgt, ?_⟩
    have h1 : 1 - σ < 1 / 2 := by linarith
    exact lastChordAbs_tendsto_atTop_of_lt_half h1



/-- Quantitative ratio form: `L_N(σ) / N^(1-2σ) = 1/2 - 1/(2N)` for `N ≥ 1`.
This gives the exact rate of the asymptotic dichotomy, not merely its class. -/
theorem lastChordAbs_ratio {N : ℕ} (hN : 1 ≤ N) (σ : ℝ) :
    lastChordAbs N σ / (N : ℝ) ^ (1 - 2 * σ) = 1 / 2 - 1 / (2 * (N : ℝ)) := by
  rw [lastChordAbs_eq_half_mul hN σ]
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hN)
  have hpow_pos : 0 < (N : ℝ) ^ (1 - 2 * σ) := Real.rpow_pos_of_pos hNpos _
  field_simp [ne_of_gt hpow_pos]

end GeoDQPT
