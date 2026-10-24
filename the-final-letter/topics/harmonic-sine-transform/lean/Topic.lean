import Mathlib

/-!
# Harmonic Sine Transform — formal core

The HST programme of the archived corpus rests on two elementary layers:

* the greedy harmonic expansion of `θ ∈ [0, π]` in the harmonic angles
  `α n = π / (n + 2)`, and
* the Haar wavelets attached to the split nodes of the resulting binary tree.

This file formalises the finite, checkable part of those layers.  The
far-reaching analytic claims of the source (the Fredholm determinant
identity `det(I − ℒ_s) = ζ(s)/ζ(2s) · exp(P(s))`, the meromorphic
continuation of `Φ(θ,s)`, the Weil-type explicit formula, and the
Hilbert–Pólya/GRH route) are *not* formalised here and are recorded as
source claims or open items in the programme dossier.

The Haar coefficients below differ from the source's displayed formula
by a normalisation factor: the source's `1/√|child|` coefficients give
squared norm `2` and are not orthogonal to constants unless the two
children have equal length.  We use the correctly normalised, zero-mean
coefficients `√(b/(aL))` on the left child and `−√(a/(bL))` on the right
child, where `a`, `b` are the child lengths and `L = a + b`.  The two
lemmas `haar_normSq` and `haar_mean_zero` record exactly this repair.
-/

noncomputable section

open Filter Topology

namespace HST

/-- The `n`-th harmonic angle `α_n = π / (n + 2)`. -/
def alpha (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- Accumulated angle before digit `n`: the sum of the selected `α_k`, `k < n`. -/
def accum : ℕ → ℝ → ℝ
  | 0, _ => 0
  | n + 1, θ => accum n θ + if alpha n ≤ θ - accum n θ then alpha n else 0

/-- The `n`-th greedy harmonic digit of `θ` (the source's `δ_n(θ)`). -/
def digit (n : ℕ) (θ : ℝ) : ℕ :=
  if alpha n ≤ θ - accum n θ then 1 else 0

/-- The harmonic angles are positive. -/
theorem alpha_pos (n : ℕ) : 0 < alpha n := by
  unfold alpha
  positivity

/-- The harmonic angles are strictly decreasing in `n`. -/
theorem alpha_strictAnti : StrictAnti alpha := by
  intro a b hab
  unfold alpha
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left Real.pi_pos (by positivity) h

/-- The accumulated angle never exceeds the target angle: partial sums of the
greedy expansion stay below `θ`. -/
theorem accum_le_self (n : ℕ) {θ : ℝ} (hθ : 0 ≤ θ) : accum n θ ≤ θ := by
  induction n with
  | zero => simpa [accum] using hθ
  | succ n ih =>
      rw [accum]
      split_ifs with h
      · linarith
      · simpa using ih

/-- Below the threshold `α_n` no earlier digit is selected, so the accumulated
angle is still zero. -/
theorem accum_eq_zero_of_lt (n : ℕ) {θ : ℝ} (h : θ < alpha n) : accum n θ = 0 := by
  induction n with
  | zero => simp [accum]
  | succ n ih =>
      have hn : θ < alpha n := lt_trans h (alpha_strictAnti (Nat.lt_succ_self n))
      rw [accum, ih hn]
      simp [not_le.mpr hn]

/-- **Threshold theorem.**  For the residual-subtraction convention of the
source's equation (1), `α_n` is the *least* angle whose `n`-th digit is `1`.
This is the precise finite statement behind the source's threshold angles. -/
theorem threshold_isLeast (n : ℕ) : IsLeast {θ : ℝ | digit n θ = 1} (alpha n) := by
  constructor
  · show digit n (alpha n) = 1
    unfold digit
    have h0 : accum n (alpha n) = 0 := by
      induction n with
      | zero => simp [accum]
      | succ n _ =>
          have hlt : alpha (n + 1) < alpha n := alpha_strictAnti (Nat.lt_succ_self n)
          have hz : accum n (alpha (n + 1)) = 0 := accum_eq_zero_of_lt n hlt
          rw [accum, hz]
          simp [not_le.mpr hlt]
    rw [h0]
    simp
  · intro θ hθ
    by_contra hle
    have hlt : θ < alpha n := not_le.mp hle
    have hz : digit n θ = 0 := by
      unfold digit
      rw [accum_eq_zero_of_lt n hlt]
      simp [not_le.mpr hlt]
    have hθ' : digit n θ = 1 := hθ
    rw [hz] at hθ'
    exact Nat.zero_ne_one hθ'

/-- Left-child Haar coefficient `√(b / (aL))`. -/
def haarL (a b L : ℝ) : ℝ := Real.sqrt (b / (a * L))

/-- Right-child Haar coefficient `−√(a / (bL))`, up to the displayed sign. -/
def haarR (a b L : ℝ) : ℝ := Real.sqrt (a / (b * L))

/-- The Haar wavelet of a split node has squared norm `1` in the
`θ`-normalised (`L²[0,1]`) picture.  The coefficients multiply the child
lengths `a` and `b`, and `L = a + b`. -/
theorem haar_normSq {a b L : ℝ} (ha : 0 < a) (hb : 0 < b) (hL : L = a + b) :
    a * haarL a b L ^ 2 + b * haarR a b L ^ 2 = 1 := by
  have hLpos : 0 < L := by rw [hL]; positivity
  have ha0 : a ≠ 0 := ne_of_gt ha
  have hb0 : b ≠ 0 := ne_of_gt hb
  have hL0 : L ≠ 0 := ne_of_gt hLpos
  unfold haarL haarR
  rw [Real.sq_sqrt (by positivity), Real.sq_sqrt (by positivity)]
  field_simp [ha0, hb0, hL0]
  rw [hL]
  ring

/-- The Haar wavelet has zero mean over its node: the signed child masses
cancel.  This is the orthogonality to the constant function. -/
theorem haar_mean_zero {a b L : ℝ} (ha : 0 < a) (hb : 0 < b) (hL : L = a + b) :
    haarL a b L * a - haarR a b L * b = 0 := by
  have hLpos : 0 < L := by rw [hL]; positivity
  have hL0 : L ≠ 0 := ne_of_gt hLpos
  have hleft : haarL a b L * a = Real.sqrt (a * b / L) := by
    unfold haarL
    calc
      Real.sqrt (b / (a * L)) * a
          = Real.sqrt (b / (a * L)) * Real.sqrt (a ^ 2) := by
            rw [Real.sqrt_sq (le_of_lt ha)]
      _ = Real.sqrt ((b / (a * L)) * a ^ 2) := by
            rw [Real.sqrt_mul (by positivity)]
      _ = Real.sqrt (a * b / L) := by
            congr 1
            field_simp [ne_of_gt ha, hL0]
  have hright : haarR a b L * b = Real.sqrt (a * b / L) := by
    unfold haarR
    calc
      Real.sqrt (a / (b * L)) * b
          = Real.sqrt (a / (b * L)) * Real.sqrt (b ^ 2) := by
            rw [Real.sqrt_sq (le_of_lt hb)]
      _ = Real.sqrt ((a / (b * L)) * b ^ 2) := by
            rw [Real.sqrt_mul (by positivity)]
      _ = Real.sqrt (a * b / L) := by
            congr 1
            field_simp [ne_of_gt hb, hL0]
  rw [hleft, hright]
  ring

end HST
