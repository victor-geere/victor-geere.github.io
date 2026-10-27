import Mathlib

/-!
# The eml universal operator — formal core

The archived source defines the binary operator
`eml x y = exp x - log y` and states the base identities that make it a
candidate universal gate: `exp z = eml z 1`, a three-gate expression for
`log z`, and `sqrt u = eml (log u / 2) 1`.

This file formalises those elementary identities and the order structure
of the operator in its first argument.  The source's functional-completeness
claim, its harmonic fusion step, and its Riemann-hypothesis sketch are not
formalised here; they are recorded as source claims / open items in the
programme dossier.
-/

noncomputable section

namespace EML

/-- The eml binary operator `eml x y = exp x - log y`, defined for `y > 0`. -/
def eml (x y : ℝ) : ℝ := Real.exp x - Real.log y

/-- Source identity: the exponential is one eml gate applied to `1`. -/
theorem exp_identity (z : ℝ) : eml z 1 = Real.exp z := by
  unfold eml
  rw [Real.log_one, sub_zero]

/-- The constant `1` is the value of eml at `(0, 1)`. -/
theorem unit_identity : eml 0 1 = 1 := by
  simp [eml]

/-- The operator separates into its exponential part and its logarithmic part. -/
theorem eml_eq_exp_sub_log (x y : ℝ) : eml x y = eml x 1 - Real.log y := by
  unfold eml
  rw [Real.log_one, sub_zero]

/-- On the non-negative axis the operator is bounded below by `1`. -/
theorem one_le_eml {x : ℝ} (hx : 0 ≤ x) : 1 ≤ eml x 1 := by
  rw [exp_identity]
  exact Real.one_le_exp hx

/-- `eml · 1` is strictly increasing: the gate inherits the order of `exp`. -/
theorem strictMono_first : StrictMono (fun x : ℝ => eml x 1) := by
  intro a b hab
  show eml a 1 < eml b 1
  rw [exp_identity, exp_identity]
  exact Real.exp_lt_exp.mpr hab

/-- Source identity: `log z` is the three-gate expression
`eml 1 (eml (eml 1 z) 1)`. -/
theorem log_identity (z : ℝ) (hz : 0 < z) :
    eml 1 (eml (eml 1 z) 1) = Real.log z := by
  have hz0 : z ≠ 0 := ne_of_gt hz
  have hexp : 0 < Real.exp (Real.exp 1) := Real.exp_pos _
  unfold eml
  simp only [Real.log_one, sub_zero]
  rw [Real.exp_sub, Real.exp_log hz]
  rw [Real.log_div (ne_of_gt hexp) hz0, Real.log_exp]
  ring

/-- Source identity: the square root is one eml gate applied to half the log. -/
theorem sqrt_identity (u : ℝ) (hu : 0 < u) :
    eml (Real.log u / 2) 1 = Real.sqrt u := by
  unfold eml
  rw [Real.log_one, sub_zero, Real.exp_half, Real.exp_log hu]

end EML
