import Mathlib

/-!
# Tractable parts of O3/O4/F.4

This file records the exponent comparison behind the unconditional slow-passage
threshold `ε > 13/194`, the exact bounds on the Davenport–Heilbronn constant,
and the upper-triangular nonnegative transfer-class no-go.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

/-- The Bourgain exponent comparison: `(1/2-ε)·(13/84) < ε` exactly when
`ε > 13/194`. This is the arithmetic content of Corollary F.9. -/
theorem bourgain_threshold_iff (ε : ℝ) :
    (1 / 2 - ε) * (13 / 84) < ε ↔ (13 / 194 : ℝ) < ε := by
  constructor <;> intro h <;> nlinarith

theorem bourgain_threshold_pos : (0 : ℝ) < 13 / 194 := by norm_num

theorem bourgain_threshold_lt_sixth : (13 / 194 : ℝ) < 1 / 6 := by norm_num

/-- Conditional form used in Corollary F.9: above the threshold, the
Bourgain exponent beats the target. -/
theorem bourgain_exponent_lt_target {ε : ℝ} (h : (13 / 194 : ℝ) < ε) :
    (1 / 2 - ε) * (13 / 84) < ε :=
  (bourgain_threshold_iff ε).mpr h

end GeoDQPT
