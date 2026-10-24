import Mathlib

/-!
# The iota helix — formal core

The archived iota framework encodes the Dirichlet eta series as a planar
(and, in the companion note, spatial) walk.  This file formalises the
elementary finite objects that the encoding actually defines:

* the step radius `r n = n ^ (-σ)`;
* the unwrapped helix phase `Φ n = π (n - 1) - t log n`;
* the planar coordinates `(r cos Φ, r sin Φ)`.

It proves positivity and monotonicity of the radius, the unit-length
identity for a step, the phase increment, the initial step `v₁ = 1`, the
real-axis reduction to the alternating eta terms, and positivity of the
finite alternating eta partial sums.  The RH/GRH route through the greedy
condition is *not* formalised here; it is recorded as a source claim in
the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace Iota

/-- The iota step radius `r_n = n ^ (-σ)`. -/
def radius (σ : ℝ) (n : ℕ) : ℝ := (n : ℝ) ^ (-σ)

/-- The unwrapped helix phase `Φ_n = π (n - 1) - t log n`. -/
def phase (t : ℝ) (n : ℕ) : ℝ := Real.pi * ((n : ℝ) - 1) - t * Real.log n

/-- The real coordinate of the planar iota step. -/
def xcoord (σ t : ℝ) (n : ℕ) : ℝ := radius σ n * Real.cos (phase t n)

/-- The imaginary coordinate of the planar iota step. -/
def ycoord (σ t : ℝ) (n : ℕ) : ℝ := radius σ n * Real.sin (phase t n)

/-- The iota point in `ℝ × ℝ × ℝ`, with the index as third coordinate. -/
def point (σ t : ℝ) (n : ℕ) : ℝ × ℝ × ℝ :=
  (xcoord σ t n, ycoord σ t n, (n : ℝ))

/-- Finite alternating eta partial sum on the real axis. -/
def etaPartial (σ : ℝ) (N : ℕ) : ℝ :=
  ∑ k ∈ Finset.range N, (-1 : ℝ) ^ k * radius σ (k + 1)

theorem radius_pos {σ : ℝ} {n : ℕ} (hn : 0 < n) : 0 < radius σ n := by
  unfold radius
  exact Real.rpow_pos_of_pos (by exact_mod_cast hn) _

theorem radius_lt_radius {σ : ℝ} (hσ : 0 < σ) {m n : ℕ}
    (hm : 0 < m) (hmn : m < n) : radius σ n < radius σ m := by
  unfold radius
  exact Real.rpow_lt_rpow_of_neg (by exact_mod_cast hm) (by exact_mod_cast hmn) (by linarith)

theorem step_length (σ t : ℝ) (n : ℕ) :
    xcoord σ t n ^ 2 + ycoord σ t n ^ 2 = radius σ n ^ 2 := by
  unfold xcoord ycoord
  calc
    (radius σ n * Real.cos (phase t n)) ^ 2 +
        (radius σ n * Real.sin (phase t n)) ^ 2
        = radius σ n ^ 2 *
            (Real.sin (phase t n) ^ 2 + Real.cos (phase t n) ^ 2) := by ring
    _ = radius σ n ^ 2 := by rw [Real.sin_sq_add_cos_sq, mul_one]

theorem phase_succ_sub (t : ℝ) {n : ℕ} (hn : 0 < n) :
    phase t (n + 1) - phase t n =
      Real.pi - t * Real.log (((n : ℝ) + 1) / (n : ℝ)) := by
  unfold phase
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hn
  have h1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have hlog : Real.log (((n : ℝ) + 1) / (n : ℝ)) =
      Real.log ((n : ℝ) + 1) - Real.log (n : ℝ) := Real.log_div h1 hn'
  rw [hlog]
  norm_num
  ring

theorem point_one (σ t : ℝ) : point σ t 1 = (1, 0, 1) := by
  unfold point xcoord ycoord phase radius
  norm_num [Real.log_one]

theorem real_axis_term (σ : ℝ) (n : ℕ) :
    xcoord σ 0 (n + 1) = (-1 : ℝ) ^ n * radius σ (n + 1) ∧
      ycoord σ 0 (n + 1) = 0 := by
  constructor
  · unfold xcoord phase
    have harg : Real.pi * (((n + 1 : ℕ) : ℝ) - 1) = (n : ℝ) * Real.pi := by
      push_cast
      ring
    have hcos : Real.cos (Real.pi * (((n + 1 : ℕ) : ℝ) - 1)) = (-1 : ℝ) ^ n := by
      rw [harg, Real.cos_nat_mul_pi]
    simp only [zero_mul, sub_zero]
    rw [hcos]
    ring
  · unfold ycoord phase
    have harg : Real.pi * (((n + 1 : ℕ) : ℝ) - 1) = (n : ℝ) * Real.pi := by
      push_cast
      ring
    have hsin : Real.sin (Real.pi * (((n + 1 : ℕ) : ℝ) - 1)) = 0 := by
      rw [harg, Real.sin_nat_mul_pi]
    simp only [zero_mul, sub_zero]
    rw [hsin]
    ring

private lemma altSum_even (a : ℕ → ℝ) (M : ℕ) :
    (∑ k ∈ Finset.range (2 * M), (-1 : ℝ) ^ k * a k) =
      ∑ k ∈ Finset.range M, (a (2 * k) - a (2 * k + 1)) := by
  induction M with
  | zero => simp
  | succ M ih =>
      rw [Nat.mul_succ]
      simp only [Finset.sum_range_succ, ih]
      have h1 : (-1 : ℝ) ^ (2 * M) = 1 := Even.neg_one_pow ⟨M, by ring⟩
      have h2 : (-1 : ℝ) ^ (2 * M + 1) = -1 := Odd.neg_one_pow ⟨M, by ring⟩
      rw [h1, h2]
      ring

private lemma altSum_pos {a : ℕ → ℝ}
    (hpos : ∀ k, 0 < a k) (hanti : ∀ k, a (k + 1) < a k)
    {N : ℕ} (hN : 0 < N) :
    0 < ∑ k ∈ Finset.range N, (-1 : ℝ) ^ k * a k := by
  rcases N.even_or_odd with ⟨M, rfl⟩ | ⟨M, rfl⟩
  · have hM : 0 < M := by omega
    have hMM : M + M = 2 * M := by ring
    rw [hMM, altSum_even]
    refine Finset.sum_pos (fun k _ => ?_) ⟨0, Finset.mem_range.mpr hM⟩
    exact sub_pos.mpr (hanti (2 * k))
  · rw [Finset.sum_range_succ, altSum_even]
    have h1 : (-1 : ℝ) ^ (2 * M) = 1 := Even.neg_one_pow ⟨M, by ring⟩
    rw [h1, one_mul]
    have hnonneg : 0 ≤ ∑ k ∈ Finset.range M, (a (2 * k) - a (2 * k + 1)) := by
      refine Finset.sum_nonneg (fun k _ => ?_)
      exact sub_nonneg.mpr (le_of_lt (hanti (2 * k)))
    have ha : 0 < a (2 * M) := hpos _
    linarith

theorem etaPartial_pos {σ : ℝ} (hσ : 0 < σ) {N : ℕ} (hN : 0 < N) :
    0 < etaPartial σ N := by
  unfold etaPartial
  refine altSum_pos (fun k => ?_) (fun k => ?_) hN
  · exact radius_pos (Nat.succ_pos k)
  · exact radius_lt_radius hσ (Nat.succ_pos k) (by omega)

end Iota
