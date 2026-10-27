import EMTaylorCert

/-!
# Assembling `h2` from a Taylor remainder

`h2` asks for `‖ζ′(z) − ζ′(s14)‖ ≤ 47/250` on the closed `1/5`-ball.  This file
supplies the *algebraic* half of the estimate, leaving only the analytic Taylor
remainder to be proved:

* `taylorCoef k = ζ^{(k)}(s14)/k!`, and the Taylor polynomial of `ζ′` at `s14`,
  `taylorPoly w = Σ_{j<6} (j+1)·c_{j+1}·w^j` (degree 5 in `w = z − s14`);
* the coefficient sum `‖taylorPoly w − ζ′(s14)‖ ≤ 0.154` for `‖w‖ ≤ 1/5`,
  from the five certified bounds `|c_k| ≤ 0.351, 0.103, 0.025, 0.007, 0.006`;
* the reduction `h2` ⇐ remainder, with remainder budget `0.014`:
  `0.154 + 0.014 = 0.168 ≤ 47/250 = 0.188`.

The analytic input still needed is
`‖ζ′(z) − taylorPoly (z − s14)‖ ≤ 0.014`, i.e. Taylor's theorem with the
Lagrange remainder (`taylor_mean_remainder_bound`, journal I.313 route A) plus
`sup|ζ^{(7)}| ≤ 25000` on the ball.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open Filter Topology

/-- The Taylor coefficient `c_k = ζ^{(k)}(s14)/k!`. -/
def taylorCoef (k : ℕ) : ℂ :=
  iteratedDeriv k riemannZeta s14 / (((k.factorial : ℕ)) : ℂ)

/-- Certified bounds for `|c_k|`, `k = 2..6`. -/
def cBound : ℕ → ℝ
  | 2 => 351 / 1000
  | 3 => 103 / 1000
  | 4 => 25 / 1000
  | 5 => 7 / 1000
  | 6 => 6 / 1000
  | _ => 0

/-- The Taylor polynomial of `ζ′` at `s14`, of degree `5` in `w = z − s14`:
`Σ_{j<6} (j+1)·c_{j+1}·w^j`.  It is the derivative of the degree-`6` Taylor
polynomial of `ζ`. -/
def taylorPoly (w : ℂ) : ℂ :=
  ∑ j ∈ Finset.range 6, (((j + 1 : ℕ)) : ℂ) * taylorCoef (j + 1) * w ^ j

theorem taylorCoef_one : taylorCoef 1 = deriv riemannZeta s14 := by
  simp [taylorCoef, iteratedDeriv_one]

theorem cBound_nonneg (k : ℕ) (h2 : 2 ≤ k) (h6 : k ≤ 6) : (0 : ℝ) ≤ cBound k := by
  interval_cases k <;> norm_num [cBound]

/-- The Taylor polynomial minus its constant term `ζ′(s14)`. -/
theorem taylorPoly_sub_eq (w : ℂ) :
    taylorPoly w - deriv riemannZeta s14
      = ∑ j ∈ Finset.range 5,
          (((j + 2 : ℕ)) : ℂ) * taylorCoef (j + 2) * w ^ (j + 1) := by
  rw [taylorPoly, Finset.sum_range_succ']
  have hconst : (((((0 + 1 : ℕ)) : ℂ)) * taylorCoef (0 + 1) * w ^ 0) = deriv riemannZeta s14 := by
    simp [taylorCoef_one]
  rw [hconst]
  rw [show (∑ x ∈ Finset.range 5,
        (((x + 1 + 1 : ℕ)) : ℂ) * taylorCoef (x + 1 + 1) * w ^ (x + 1))
      = ∑ j ∈ Finset.range 5, (((j + 2 : ℕ)) : ℂ) * taylorCoef (j + 2) * w ^ (j + 1) from by
    apply Finset.sum_congr rfl
    intro x hx
    norm_num [Nat.add_assoc]]
  ring

theorem norm_taylorCoef_le (k : ℕ) (h2 : 2 ≤ k) (h6 : k ≤ 6) :
    ‖taylorCoef k‖ ≤ cBound k := by
  interval_cases k
  · simpa [taylorCoef, cBound] using norm_c_two
  · simpa [taylorCoef, cBound] using norm_c_three
  · simpa [taylorCoef, cBound] using norm_c_four
  · simpa [taylorCoef, cBound] using norm_c_five
  · simpa [taylorCoef, cBound] using norm_c_six

/-- **The coefficient sum.**  For `‖w‖ ≤ 1/5`, the Taylor polynomial differs
from `ζ′(s14)` by at most `0.154` (true value `0.13928`). -/
theorem norm_taylorPoly_sub_le {w : ℂ} (hw : ‖w‖ ≤ (1 / 5 : ℝ)) :
    ‖taylorPoly w - deriv riemannZeta s14‖ ≤ (154 / 1000 : ℝ) := by
  rw [taylorPoly_sub_eq]
  have hterm : ∀ j ∈ Finset.range 5,
      ‖(((j + 2 : ℕ)) : ℂ) * taylorCoef (j + 2) * w ^ (j + 1)‖
        ≤ (((j + 2 : ℕ)) : ℝ) * cBound (j + 2) * (1 / 5 : ℝ) ^ (j + 1) := by
    intro j hj
    have hj5 : j < 5 := Finset.mem_range.mp hj
    have hcb : ‖taylorCoef (j + 2)‖ ≤ cBound (j + 2) :=
      norm_taylorCoef_le (j + 2) (by omega) (by omega)
    have hw1 : ‖w‖ ^ (j + 1) ≤ (1 / 5 : ℝ) ^ (j + 1) :=
      pow_le_pow_left₀ (norm_nonneg _) hw (j + 1)
    have hnat : ‖(((j + 2 : ℕ)) : ℂ)‖ = (((j + 2 : ℕ)) : ℝ) := Complex.norm_natCast _
    have hnonneg : (0 : ℝ) ≤ (((j + 2 : ℕ)) : ℝ) := by positivity
    have hcb0 : (0 : ℝ) ≤ cBound (j + 2) := cBound_nonneg (j + 2) (by omega) (by omega)
    calc ‖(((j + 2 : ℕ)) : ℂ) * taylorCoef (j + 2) * w ^ (j + 1)‖
        = ‖(((j + 2 : ℕ)) : ℂ)‖ * ‖taylorCoef (j + 2)‖ * ‖w‖ ^ (j + 1) := by
          rw [norm_mul, norm_mul, norm_pow]
      _ = (((j + 2 : ℕ)) : ℝ) * ‖taylorCoef (j + 2)‖ * ‖w‖ ^ (j + 1) := by rw [hnat]
      _ ≤ (((j + 2 : ℕ)) : ℝ) * cBound (j + 2) * (1 / 5 : ℝ) ^ (j + 1) := by
          apply mul_le_mul
          · exact mul_le_mul_of_nonneg_left hcb hnonneg
          · exact hw1
          · positivity
          · exact mul_nonneg hnonneg hcb0
  refine (norm_sum_le _ _).trans ((Finset.sum_le_sum hterm).trans ?_)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, cBound, Nat.reduceAdd,
    Nat.cast_ofNat]
  norm_num

/-- **`h2` from the Taylor remainder.**  If the degree-`5` Taylor polynomial of
`ζ′` approximates `ζ′` to `0.014` on the closed `1/5`-ball, then `h2` holds:
`0.154 + 0.014 = 0.168 ≤ 47/250`. -/
theorem norm_deriv_sub_le_of_taylor_remainder {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ))
    (hrem : ‖deriv riemannZeta z - taylorPoly (z - s14)‖ ≤ (14 / 1000 : ℝ)) :
    ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ (47 / 250 : ℝ) := by
  have hsum := norm_taylorPoly_sub_le (w := z - s14) hz
  have hsplit : deriv riemannZeta z - deriv riemannZeta s14
      = (deriv riemannZeta z - taylorPoly (z - s14))
        + (taylorPoly (z - s14) - deriv riemannZeta s14) := by ring
  rw [hsplit]
  have h := norm_add_le (deriv riemannZeta z - taylorPoly (z - s14))
    (taylorPoly (z - s14) - deriv riemannZeta s14)
  linarith

/-- The `h2` hypothesis of `zeta_zero_14_of_bounds`, reduced to the Taylor
remainder. -/
theorem h2_of_taylor_remainder
    (hrem : ∀ z ∈ Metric.closedBall s14 (1 / 5),
      ‖deriv riemannZeta z - taylorPoly (z - s14)‖ ≤ (14 / 1000 : ℝ)) :
    ∀ z ∈ Metric.closedBall s14 (1 / 5),
      ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ (47 / 250 : ℝ) := by
  intro z hz
  have hz' : ‖z - s14‖ ≤ (1 / 5 : ℝ) := by
    simpa [Metric.mem_closedBall, dist_eq_norm] using hz
  exact norm_deriv_sub_le_of_taylor_remainder hz' (hrem z hz)

end FiniteWindowZeros
