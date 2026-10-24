import Mathlib

/-!
# Harmonic sine — formal core

The archived source proposes a greedy reconstruction of `sin (π x)` from
harmonic angle steps `ε n = π / (n + 2)`.  The geometric content is the
Pythagorean rotation: a point `(s, c)` on the unit circle is rotated by
the pair `(sin ε, cos ε)` using the angle-addition formula, which
preserves `s² + c² = 1`.  The theorems below formalise that rotation, the
elementary order facts about `ε n`, and the one-step greedy residual
invariant.

The source's Riemann-hypothesis claims (harmonic-sheaf acyclicity and the
claimed Matomäki–Radziwiłł extension) are **not** formalised here.  They
are recorded as archived claims in the programme dossier; nothing in
this file asserts them.
-/

noncomputable section

open Filter Topology

namespace HarmonicSine

/-- The harmonic angle `ε n = π / (n + 2)`. -/
def eps (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- A rotation pair, written as `(s, c)` with `s = sin θ`, `c = cos θ`. -/
abbrev Point := ℝ × ℝ

/-- Rotate `(s, c)` by the angle whose sine and cosine are `(h, ch)`.

This is the source's geometric fusion rule: the new sine is
`s * ch + c * h` and the new cosine is `c * ch - s * h`. -/
def rotate (p : Point) (h ch : ℝ) : Point :=
  (p.1 * ch + p.2 * h, p.2 * ch - p.1 * h)

/-- The residual after one greedy step, in units where the target is
fixed: the step `eps n` is taken exactly when `eps n ≤ r`. -/
def residStep (r : ℝ) (n : ℕ) : ℝ :=
  r - if eps n ≤ r then eps n else 0

theorem eps_pos (n : ℕ) : 0 < eps n := by
  unfold eps
  positivity

theorem eps_strictAnti : StrictAnti eps := by
  intro a b hab
  unfold eps
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left Real.pi_pos (by positivity) h

theorem eps_tendsto_zero : Tendsto eps atTop (𝓝 0) := by
  have h := tendsto_const_div_atTop_nhds_zero_nat (𝕜 := ℝ) Real.pi
  have h2 : Tendsto (fun n : ℕ => Real.pi / (((n + 2 : ℕ) : ℝ))) atTop (𝓝 0) :=
    h.comp (tendsto_add_atTop_nat 2)
  change Tendsto (fun n : ℕ => Real.pi / ((n : ℝ) + 2)) atTop (𝓝 0)
  simpa [Nat.cast_add] using h2

theorem scaled_eps (n : ℕ) : ((n : ℝ) + 2) * eps n = Real.pi := by
  unfold eps
  have h : ((n : ℝ) + 2) ≠ 0 := by positivity
  field_simp [h]

/-- The geometric rotation preserves the unit circle.  If `(s, c)` and
`(h, ch)` are both unit vectors, so is the rotated pair.  This is the
Pythagorean content of the source's construction. -/
theorem rotate_unit (p : Point) (h ch : ℝ)
    (hp : p.1 ^ 2 + p.2 ^ 2 = 1) (hh : h ^ 2 + ch ^ 2 = 1) :
    (rotate p h ch).1 ^ 2 + (rotate p h ch).2 ^ 2 = 1 := by
  unfold rotate
  nlinarith [hp, hh]

/-- The rotated pair is exactly the angle-addition update:
`(sin θ, cos θ)` rotated by `(sin ε, cos ε)` is `(sin (θ + ε), cos (θ + ε))`. -/
theorem rotate_trig (θ ε : ℝ) :
    rotate (Real.sin θ, Real.cos θ) (Real.sin ε) (Real.cos ε) =
      (Real.sin (θ + ε), Real.cos (θ + ε)) := by
  unfold rotate
  simp only [Real.sin_add, Real.cos_add]

/-- One step of the greedy residual invariant.  If the residual is
non-negative and at most `ε n`, the next residual is non-negative and
still at most `ε n`; this is the induction step behind the source's
claim `r n ≤ π / (n + 1)`. -/
theorem residStep_bounds (r : ℝ) (n : ℕ) (h0 : 0 ≤ r) (hr : r ≤ eps n) :
    0 ≤ residStep r n ∧ residStep r n ≤ eps n := by
  unfold residStep
  split_ifs with htake
  · constructor <;> linarith [eps_pos n]
  · exact ⟨by simpa using h0, by simpa using hr⟩

end HarmonicSine
