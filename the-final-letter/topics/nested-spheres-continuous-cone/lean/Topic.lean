import Mathlib

/-!
# Nested spheres and the continuous cone — formal core

The two archived working notes behind this topic claim a geometric proof of
the Riemann hypothesis.  The programme dossier does not accept that claim.
This file formalises only the elementary geometry, filtering and regularity
facts that survive the audit:

* the nested fibre radii `r_N = 1/N` are positive, strictly decreasing and
  tend to zero;
* the mean-zero filter `c_m(N)` has zero sum over one period;
* the polygonal edge subtends a chord of length `2 sin (π/N)`, bounded by
  the arc length `2π/N` (the `O(1/N)` sampling estimate);
* the corrected continuous-cone local diagonal is
  `-∫φ + R ∫φ²`, not the withdrawn constant `-1/2`.

Every declaration below is complete.  The RH conclusion, the residual mass
bounds, the differential inequality and the pure-point limit theorem are
recorded as source claims / open items in the dossier, not as theorems.
-/

noncomputable section

open Filter Topology MeasureTheory
open scoped BigOperators Interval

namespace NestedSpheres

/-! ## Nested Hopf fibres -/

/-- Radius of the `N`-th nested three-sphere fibre, scaled by `N⁻¹`. -/
def fibreRadius (N : ℕ) : ℝ := 1 / (N : ℝ)

/-- The nested fibre radius is positive for every `N ≥ 1`. -/
theorem fibreRadius_pos {N : ℕ} (hN : 1 ≤ N) : 0 < fibreRadius N := by
  unfold fibreRadius
  positivity

/-- The nested fibres shrink: `r_{N+1} < r_N` for every `N ≥ 1`. -/
theorem fibreRadius_strictAnti {N : ℕ} (hN : 1 ≤ N) :
    fibreRadius (N + 1) < fibreRadius N := by
  unfold fibreRadius
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hlt : (N : ℝ) < (N : ℝ) + 1 := by linarith
  have h := one_div_lt_one_div_of_lt hNpos hlt
  simpa [Nat.cast_add, Nat.cast_one] using h

/-- The fibre radii tend to zero as the nesting depth grows. -/
theorem fibreRadius_tendsto_zero : Tendsto fibreRadius atTop (𝓝 0) := by
  change Tendsto (fun N : ℕ => 1 / (N : ℝ)) atTop (𝓝 0)
  exact tendsto_one_div_atTop_nhds_zero_nat (𝕜 := ℝ)

/-! ## The mean-zero filter -/

/-- The mean-zero coefficient `c_m(N) = 1 - N` if `N ∣ m`, and `1` otherwise. -/
def meanZeroCoeff (N m : ℕ) : ℤ := if N ∣ m then 1 - (N : ℤ) else 1

/-- The coefficient at the `N`-th place is `1 - N`. -/
theorem meanZeroCoeff_self (N : ℕ) :
    meanZeroCoeff N N = 1 - (N : ℤ) := by
  simp [meanZeroCoeff]

/-- One full period of the mean-zero filter sums to zero. -/
theorem meanZeroCoeff_period_sum (N : ℕ) (hN : 1 ≤ N) :
    (∑ i ∈ Finset.range N, meanZeroCoeff N (i + 1)) = 0 := by
  have hrange : Finset.range N = Finset.range ((N - 1) + 1) := by
    rw [Nat.sub_add_cancel hN]
  rw [hrange, Finset.sum_range_succ]
  have hconst : ∀ i ∈ Finset.range (N - 1), meanZeroCoeff N (i + 1) = (1 : ℤ) := by
    intro i hi
    have hi' : i < N - 1 := Finset.mem_range.mp hi
    have hlt : i + 1 < N := by omega
    have hpos : 0 < i + 1 := Nat.succ_pos i
    have hndvd : ¬ N ∣ i + 1 := by
      intro hd
      have hle : N ≤ i + 1 := Nat.le_of_dvd hpos hd
      omega
    simp [meanZeroCoeff, hndvd]
  rw [Finset.sum_congr rfl hconst]
  simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul, mul_one]
  have hdvd : N ∣ (N - 1) + 1 := by
    rw [Nat.sub_add_cancel hN]
  simp [meanZeroCoeff, hdvd]
  have hcast : ((N - 1 : ℕ) : ℤ) = (N : ℤ) - 1 := by
    rw [Nat.cast_sub hN]
    norm_num
  rw [hcast]
  ring

/-! ## The polygonal sampling error -/

/-- Chord length of one edge of the regular `N`-gon inscribed in the unit circle. -/
def chord (N : ℕ) : ℝ := 2 * Real.sin (Real.pi / (N : ℝ))

/-- The chord is no longer than the circular arc it subtends: the per-edge
`O(1/N)` sampling estimate behind the `O(N⁻¹)` Hausdorff comparison. -/
theorem chord_le_arc {N : ℕ} (hN : 1 ≤ N) :
    chord N ≤ 2 * Real.pi / (N : ℝ) := by
  unfold chord
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hx : 0 ≤ Real.pi / (N : ℝ) := div_nonneg Real.pi_pos.le hNpos.le
  have hsin : Real.sin (Real.pi / (N : ℝ)) ≤ Real.pi / (N : ℝ) := Real.sin_le hx
  have h2 : 2 * Real.sin (Real.pi / (N : ℝ)) ≤ 2 * (Real.pi / (N : ℝ)) := by
    nlinarith
  calc
    2 * Real.sin (Real.pi / (N : ℝ)) ≤ 2 * (Real.pi / (N : ℝ)) := h2
    _ = 2 * Real.pi / (N : ℝ) := by ring

/-! ## The corrected continuous-cone local diagonal -/

/-- The local diagonal integral of the continuous-cone note, with the
`R`-dependence exposed.  The source's withdrawn claim replaced this by
`-1/2`; the correct value is `-∫φ + R ∫φ²`. -/
theorem localDiagonal_integral (R : ℝ) (φ : ℝ → ℝ)
    (hφ : IntervalIntegrable φ volume (-1) 1)
    (hφ2 : IntervalIntegrable (fun u => φ u ^ 2) volume (-1) 1) :
    (∫ u in (-1 : ℝ)..1, (1 - R * φ u) * (-φ u))
      = -(∫ u in (-1 : ℝ)..1, φ u) + R * ∫ u in (-1 : ℝ)..1, φ u ^ 2 := by
  have hcongr :
      (∫ u in (-1 : ℝ)..1, (1 - R * φ u) * (-φ u))
        = ∫ u in (-1 : ℝ)..1, (-φ u + R * (φ u) ^ 2) := by
    apply intervalIntegral.integral_congr
    intro u _hu
    ring
  rw [hcongr]
  calc
    (∫ u in (-1 : ℝ)..1, (-φ u + R * (φ u) ^ 2))
        = (∫ u in (-1 : ℝ)..1, -φ u)
            + ∫ u in (-1 : ℝ)..1, R * (φ u) ^ 2 :=
          intervalIntegral.integral_add hφ.neg (hφ2.const_mul R)
    _ = -(∫ u in (-1 : ℝ)..1, φ u) + R * ∫ u in (-1 : ℝ)..1, φ u ^ 2 := by
          rw [intervalIntegral.integral_neg, intervalIntegral.integral_const_mul]

end NestedSpheres
