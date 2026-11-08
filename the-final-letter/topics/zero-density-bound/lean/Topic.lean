import GaussianZeroSide
import ZetaStrip

/-!
# The W4 zero-density entrywise bound — formal core

The W4 off-line obstruction is unconditional for an isolated quadruple.
What is missing for a full Gaussian Gram matrix is an entrywise bound `B`
on the contribution of all *other* zeros.

This file harvests `FullBlockWithin`,
`offLineQuad_fullBlock_not_posSemidef_of_within` and the unconditional
`offLineQuad_obstruction_all`, and adds a named tail-input predicate:

`TailEntryBound u00 u01 u10 u11 B` records `|u_ij| ≤ B` for the tail block.
`fullBlockWithin_of_tailBound` turns it into `FullBlockWithin` for the total
block, and `not_posSemidef_of_tailBound` is the conditional obstruction.
-/

noncomputable section
open Complex Matrix
open scoped BigOperators

namespace ZeroDensityBound
open AbsoluteHodgeExplicitFormula AbsoluteHodgeHadamard
open Filter Topology

/-- Entrywise bound on the tail block (the other zeros). -/
def TailEntryBound (u00 u01 u10 u11 B : ℝ) : Prop :=
  |u00| ≤ B ∧ |u01| ≤ B ∧ |u10| ≤ B ∧ |u11| ≤ B

/-- A tail entry bound is monotone in its bound. -/
theorem tailEntryBound_mono {u00 u01 u10 u11 B B' : ℝ}
    (h : TailEntryBound u00 u01 u10 u11 B) (hB : B ≤ B') :
    TailEntryBound u00 u01 u10 u11 B' :=
  ⟨le_trans h.1 hB, le_trans h.2.1 hB, le_trans h.2.2.1 hB, le_trans h.2.2.2 hB⟩

/-- A tail entry bound forces the bound itself to be nonnegative. -/
theorem tailEntryBound_nonneg {u00 u01 u10 u11 B : ℝ}
    (h : TailEntryBound u00 u01 u10 u11 B) : 0 ≤ B :=
  le_trans (abs_nonneg _) h.1

/-- The tail predicate is exactly the harvested `FullBlockWithin` of the total
block, with the isolated block on the diagonal. -/
theorem tailEntryBound_iff_fullBlockWithin {t00 t01 t10 t11 a b B : ℝ} :
    TailEntryBound (t00 - a) (t01 - b) (t10 - b) (t11 - a) B ↔
      FullBlockWithin t00 t01 t10 t11 a b B :=
  Iff.rfl

/-- **The symmetric diagonal 2×2 block is PSD iff the diagonal dominates the
off-diagonal.**  For `!![a, b; b, a]`, the quadratic form is
`a(x₀²+x₁²) + 2b x₀x₁`, which is nonnegative exactly when `|b| ≤ a`. -/
theorem twoByTwo_diag_posSemidef_iff {a b : ℝ} :
    (!![a, b; b, a]).PosSemidef ↔ |b| ≤ a := by
  constructor
  · intro hM
    have hplus := hM.dotProduct_mulVec_nonneg (![1, 1] : Fin 2 → ℝ)
    have hminus := hM.dotProduct_mulVec_nonneg (![1, -1] : Fin 2 → ℝ)
    simp [dotProduct, mulVec, Fin.sum_univ_two] at hplus hminus
    rw [abs_le]
    constructor <;> linarith
  · intro h
    refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
    · ext i j
      fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose_apply]
    · intro x
      simp [dotProduct, mulVec, Fin.sum_univ_two]
      have hb1 : b ≤ a := le_trans (le_abs_self b) h
      have hb2 : -(a : ℝ) ≤ b := by
        have := neg_abs_le b
        linarith
      have hQ : x 0 * (a * x 0 + b * x 1) + x 1 * (b * x 0 + a * x 1)
          = ((a - b) / 2) * (x 0 - x 1) ^ 2
            + ((a + b) / 2) * (x 0 + x 1) ^ 2 := by ring
      rw [hQ]
      apply add_nonneg
      · exact mul_nonneg (by linarith) (sq_nonneg _)
      · exact mul_nonneg (by linarith) (sq_nonneg _)

/-- The non-PSD direction: an off-diagonal larger than the diagonal breaks the
symmetric diagonal block. -/
theorem twoByTwo_diag_not_posSemidef {a b : ℝ} (h : b > a) :
    ¬ (!![a, b; b, a]).PosSemidef := by
  intro hM
  have hpos := hM.dotProduct_mulVec_nonneg (![1, -1] : Fin 2 → ℝ)
  simp [dotProduct, mulVec, Fin.sum_univ_two] at hpos
  linarith

/-- A tail entry bound gives the harvested `FullBlockWithin` for the total
block. -/
theorem fullBlockWithin_of_tailBound {a b B t00 t01 t10 t11 : ℝ}
    (h : TailEntryBound (t00 - a) (t01 - b) (t10 - b) (t11 - a) B) :
    FullBlockWithin t00 t01 t10 t11 a b B := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa [abs_sub_comm] using h.1
  · exact h.2.1
  · exact h.2.2.1
  · simpa [abs_sub_comm] using h.2.2.2

/-- Conditional full-block obstruction from a tail entry bound. -/
theorem not_posSemidef_of_tailBound (c σ δ γ B t00 t01 t10 t11 : ℝ) (hB : 0 ≤ B)
    (hdom : (offLineQuad 0 σ δ γ).re - (offLineQuad c σ δ γ).re + 2 * B < 0)
    (h : TailEntryBound (t00 - (offLineQuad 0 σ δ γ).re)
      (t01 - (offLineQuad c σ δ γ).re) (t10 - (offLineQuad c σ δ γ).re)
      (t11 - (offLineQuad 0 σ δ γ).re) B) :
    ¬ (!![t00, t01; t10, t11]).PosSemidef :=
  offLineQuad_fullBlock_not_posSemidef_of_within c σ δ γ B t00 t01 t10 t11 hB
    (fullBlockWithin_of_tailBound h) hdom

/-- **Normal form of the tail predicate**: the entrywise bound is equivalent
to a single bound on the maximum absolute entry. -/
theorem tailEntryBound_iff_max_le {u00 u01 u10 u11 B : ℝ} :
    TailEntryBound u00 u01 u10 u11 B ↔
      max (max |u00| |u01|) (max |u10| |u11|) ≤ B := by
  constructor
  · rintro ⟨h1, h2, h3, h4⟩
    exact max_le (max_le h1 h2) (max_le h3 h4)
  · intro h
    have h1 : |u00| ≤ B := le_trans (le_max_left _ _ |>.trans (le_max_left _ _)) h
    have h2 : |u01| ≤ B := le_trans (le_max_right _ _ |>.trans (le_max_left _ _)) h
    have h3 : |u10| ≤ B := le_trans (le_max_left _ _ |>.trans (le_max_right _ _)) h
    have h4 : |u11| ≤ B := le_trans (le_max_right _ _ |>.trans (le_max_right _ _)) h
    exact ⟨h1, h2, h3, h4⟩

/-- **Perturbed 2×2 obstruction with the exact absolute off-diagonal.**  The
harvested version uses `a - b + 2B < 0`; because the exact criterion is
`|b| ≤ a`, the correct symmetric hypothesis is `a - |b| + 2B < 0`.  For
`b ≥ 0` this is the harvested theorem; for `b < 0` the vector `(1,1)` gives
the sign. -/
theorem twoByTwo_perturbed_not_posSemidef_abs {a b B t00 t01 t10 t11 : ℝ}
    (h00 : |t00 - a| ≤ B) (h01 : |t01 - b| ≤ B)
    (h10 : |t10 - b| ≤ B) (h11 : |t11 - a| ≤ B)
    (hB : 0 ≤ B) (h : a - |b| + 2 * B < 0) :
    ¬ (!![t00, t01; t10, t11]).PosSemidef := by
  rcases le_or_gt 0 b with hb | hb
  · rw [abs_of_nonneg hb] at h
    exact twoByTwo_perturbed_not_posSemidef h00 h01 h10 h11 hB h
  · have hbabs : |b| = -b := abs_of_neg hb
    have hdom : a + b + 2 * B < 0 := by
      rw [hbabs] at h
      linarith
    intro hM
    have hpos := hM.dotProduct_mulVec_nonneg (![1, 1] : Fin 2 → ℝ)
    simp [dotProduct, mulVec, Fin.sum_univ_two] at hpos
    have e00 : t00 ≤ a + B := by
      have := (abs_le.mp h00).2; linarith
    have e11 : t11 ≤ a + B := by
      have := (abs_le.mp h11).2; linarith
    have e01 : t01 ≤ b + B := by
      have := (abs_le.mp h01).2; linarith
    have e10 : t10 ≤ b + B := by
      have := (abs_le.mp h10).2; linarith
    linarith

/-- **Tail-bound obstruction with the exact absolute off-diagonal**: if the
tail is within `B` and `S(0) - |S(c)| + 2B < 0`, the total 2×2 block is not
PSD. -/
theorem not_posSemidef_of_tailBound_abs (c σ δ γ B t00 t01 t10 t11 : ℝ)
    (hB : 0 ≤ B)
    (hdom : (offLineQuad 0 σ δ γ).re - |(offLineQuad c σ δ γ).re| + 2 * B < 0)
    (h : TailEntryBound (t00 - (offLineQuad 0 σ δ γ).re)
      (t01 - (offLineQuad c σ δ γ).re) (t10 - (offLineQuad c σ δ γ).re)
      (t11 - (offLineQuad 0 σ δ γ).re) B) :
    ¬ (!![t00, t01; t10, t11]).PosSemidef := by
  refine twoByTwo_perturbed_not_posSemidef_abs
    (a := (offLineQuad 0 σ δ γ).re) (b := (offLineQuad c σ δ γ).re)
    ?_ ?_ ?_ ?_ hB hdom
  · simpa [abs_sub_comm] using h.1
  · exact h.2.1
  · exact h.2.2.1
  · simpa [abs_sub_comm] using h.2.2.2

/-- **Domination is available for every tail bound.**  The off-line
contribution is unbounded, so for every `B ≥ 0` there is a separation at which
`S(0) − |S(c)| + 2B < 0`.  This isolates the W4 hypothesis: the only remaining
input is the entrywise bound itself, not the existence of a separation. -/
theorem exists_domination_abs (σ δ γ B : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) (hB : 0 ≤ B) :
    ∃ c : ℝ, (offLineQuad 0 σ δ γ).re - |(offLineQuad c σ δ γ).re| + 2 * B < 0 := by
  obtain ⟨c, hc⟩ := exists_offLineQuad_gt_all σ δ γ hσ hδ
    ((offLineQuad 0 σ δ γ).re + 2 * B)
  refine ⟨c, ?_⟩
  have hle : (offLineQuad c σ δ γ).re ≤ |(offLineQuad c σ δ γ).re| := le_abs_self _
  linarith

/-- **A uniform bound for the Gaussian test function on the critical strip.**
For `0 < Re z < 1`, `‖H_c(z)‖ ≤ C exp(−σ²(Im z)²)` with
`C = 2πσ² exp(σ²/4 + |c|/2)`.  The dependence on the real part is absorbed by
the compact interval. -/
theorem exists_gaussianZeroTest_bound_strip (c σ : ℝ) (hσ : 0 < σ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ x : ℝ, 0 < x → x < 1 → ∀ y : ℝ,
      ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖
        ≤ C * Real.exp (-(σ ^ 2 * y ^ 2)) := by
  refine ⟨2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4 + |c| / 2), by positivity, ?_⟩
  intro x hx0 hx1 y
  rw [gaussianZeroTest_norm c σ x y hσ]
  have habs : |x - 1 / 2| ≤ 1 / 2 := by
    rw [abs_le]
    constructor <;> linarith
  have hsq : (x - 1 / 2) ^ 2 ≤ 1 / 4 := by
    have h1 : (x - 1 / 2) ^ 2 = |x - 1 / 2| ^ 2 := (sq_abs _).symm
    rw [h1]
    nlinarith [abs_nonneg (x - 1 / 2)]
  have hexp1 : Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2))
      = Real.exp (σ ^ 2 * (x - 1 / 2) ^ 2) * Real.exp (-(σ ^ 2 * y ^ 2)) := by
    rw [← Real.exp_add]
    congr 1
    ring
  have hexp2 : Real.exp (-(c * (x - 1 / 2))) ≤ Real.exp (|c| / 2) := by
    apply Real.exp_le_exp.mpr
    have h : |c * (x - 1 / 2)| ≤ |c| / 2 := by
      rw [abs_mul]
      have hcm : |c| * |x - 1 / 2| ≤ |c| * (1 / 2) :=
        mul_le_mul_of_nonneg_left habs (abs_nonneg c)
      linarith
    have h2 : -(c * (x - 1 / 2)) ≤ |c * (x - 1 / 2)| := neg_le_abs _
    linarith
  have hexp3 : Real.exp (σ ^ 2 * (x - 1 / 2) ^ 2) ≤ Real.exp (σ ^ 2 / 4) := by
    apply Real.exp_le_exp.mpr
    have h : σ ^ 2 * (x - 1 / 2) ^ 2 ≤ σ ^ 2 * (1 / 4) :=
      mul_le_mul_of_nonneg_left hsq (sq_nonneg σ)
    linarith
  calc 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2))
        * Real.exp (-(c * (x - 1 / 2)))
      = 2 * Real.pi * σ ^ 2
          * (Real.exp (σ ^ 2 * (x - 1 / 2) ^ 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
          * Real.exp (-(c * (x - 1 / 2))) := by rw [hexp1]
    _ ≤ 2 * Real.pi * σ ^ 2
          * (Real.exp (σ ^ 2 / 4) * Real.exp (-(σ ^ 2 * y ^ 2)))
          * Real.exp (|c| / 2) := by
        gcongr
    _ = (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4 + |c| / 2))
          * Real.exp (-(σ ^ 2 * y ^ 2)) := by
        rw [Real.exp_add]
        ring

/-- **The Gaussian zero-side sum is summable on the critical strip.** -/
theorem summable_gaussianZeroTest_of_strip (c σ : ℝ) (a : ℕ → ℂ) (hσ : 0 < σ)
    (hre : ∀ n, 0 < (a n).re ∧ (a n).re < 1)
    (h : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (a n).im ^ 2)))) :
    Summable (fun n : ℕ => gaussianZeroTest c σ (a n)) := by
  obtain ⟨C, hC0, hC⟩ := exists_gaussianZeroTest_bound_strip c σ hσ
  apply (h.mul_left C).of_norm_bounded
  intro n
  have hx := hre n
  have harg : ((a n).re : ℂ) + ((a n).im : ℂ) * I = a n := Complex.re_add_im (a n)
  simpa [harg] using hC (a n).re hx.1 hx.2 (a n).im

/-- The Gaussian zero-side entry `∑ H_c(aₙ)`. -/
noncomputable def gaussianZeroTailEntry (c σ : ℝ) (a : ℕ → ℂ) : ℂ :=
  ∑' n : ℕ, gaussianZeroTest c σ (a n)

/-- **The Gaussian zero-side sum is bounded by the zero mass.** -/
theorem norm_gaussianZeroTailEntry_le (c σ : ℝ) (a : ℕ → ℂ) (hσ : 0 < σ)
    (hre : ∀ n, 0 < (a n).re ∧ (a n).re < 1)
    (h : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (a n).im ^ 2)))) :
    ∃ C : ℝ, 0 ≤ C ∧
      ‖gaussianZeroTailEntry c σ a‖
        ≤ C * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := by
  obtain ⟨C, hC0, hC⟩ := exists_gaussianZeroTest_bound_strip c σ hσ
  refine ⟨C, hC0, ?_⟩
  have hf : Summable (fun n : ℕ => gaussianZeroTest c σ (a n)) :=
    summable_gaussianZeroTest_of_strip c σ a hσ hre h
  have hnorm : Summable (fun n : ℕ => ‖gaussianZeroTest c σ (a n)‖) := hf.norm
  have hmajor : Summable (fun n : ℕ => C * Real.exp (-(σ ^ 2 * (a n).im ^ 2))) :=
    h.mul_left C
  have hle : ∀ n : ℕ, ‖gaussianZeroTest c σ (a n)‖
      ≤ C * Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := by
    intro n
    have hx := hre n
    have harg : ((a n).re : ℂ) + ((a n).im : ℂ) * I = a n := Complex.re_add_im (a n)
    simpa [harg] using hC (a n).re hx.1 hx.2 (a n).im
  calc ‖gaussianZeroTailEntry c σ a‖
      ≤ ∑' n : ℕ, ‖gaussianZeroTest c σ (a n)‖ :=
        norm_tsum_le_tsum_norm hnorm
    _ ≤ ∑' n : ℕ, C * Real.exp (-(σ ^ 2 * (a n).im ^ 2)) :=
        hnorm.tsum_le_tsum hle hmajor
    _ = C * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := tsum_mul_left

/-- **A termwise Gaussian bound gives a bound on the whole sum.**  This is the
elementary entrywise step of W4: if every zero contribution is bounded by
`C w n`, the total contribution is bounded by `C` times the total mass. -/
theorem abs_tsum_le_mul_tsum {f : ℕ → ℂ} {w : ℕ → ℝ} {C : ℝ}
    (hw : Summable w) (hC : 0 ≤ C)
    (h : ∀ n, ‖f n‖ ≤ C * w n) :
    ‖∑' n : ℕ, f n‖ ≤ C * ∑' n : ℕ, w n := by
  have hf : Summable f :=
    (hw.mul_left C).of_norm_bounded h
  calc ‖∑' n : ℕ, f n‖ ≤ ∑' n : ℕ, ‖f n‖ := norm_tsum_le_tsum_norm hf.norm
    _ ≤ ∑' n : ℕ, C * w n := hf.norm.tsum_le_tsum h (hw.mul_left C)
    _ = C * ∑' n : ℕ, w n := tsum_mul_left

/-- **Entrywise tail bound from a Gaussian zero mass.**  If each of the four
tail entries is the real part of a zero sum whose terms are bounded by
`C w n`, then the four entries satisfy `TailEntryBound` with
`B = C * ∑ w`.  This is the clean interface between the zero mass and W4. -/
theorem tailEntryBound_of_complex_tail {f00 f01 f10 f11 : ℕ → ℂ}
    {w : ℕ → ℝ} {C : ℝ} (hw : Summable w) (hC : 0 ≤ C)
    (h00 : ∀ n, ‖f00 n‖ ≤ C * w n) (h01 : ∀ n, ‖f01 n‖ ≤ C * w n)
    (h10 : ∀ n, ‖f10 n‖ ≤ C * w n) (h11 : ∀ n, ‖f11 n‖ ≤ C * w n) :
    TailEntryBound (∑' n : ℕ, f00 n).re (∑' n : ℕ, f01 n).re
      (∑' n : ℕ, f10 n).re (∑' n : ℕ, f11 n).re (C * ∑' n : ℕ, w n) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · calc |(∑' n : ℕ, f00 n).re| ≤ ‖∑' n : ℕ, f00 n‖ := Complex.abs_re_le_norm _
      _ ≤ C * ∑' n : ℕ, w n := abs_tsum_le_mul_tsum hw hC h00
  · calc |(∑' n : ℕ, f01 n).re| ≤ ‖∑' n : ℕ, f01 n‖ := Complex.abs_re_le_norm _
      _ ≤ C * ∑' n : ℕ, w n := abs_tsum_le_mul_tsum hw hC h01
  · calc |(∑' n : ℕ, f10 n).re| ≤ ‖∑' n : ℕ, f10 n‖ := Complex.abs_re_le_norm _
      _ ≤ C * ∑' n : ℕ, w n := abs_tsum_le_mul_tsum hw hC h10
  · calc |(∑' n : ℕ, f11 n).re| ≤ ‖∑' n : ℕ, f11 n‖ := Complex.abs_re_le_norm _
      _ ≤ C * ∑' n : ℕ, w n := abs_tsum_le_mul_tsum hw hC h11

/-- **The Gaussian mass of zeros above height `R` tends to zero.**  For any
summable Gaussian zero tail, the total weight of the zeros with `|γ n| ≥ R`
tends to `0` as `R → ∞`.  This is the height-tail half of the W4 estimate: it
shows that the contribution of zeros above a sufficiently large height can be
made uniformly small. -/
theorem tendsto_gaussian_zero_mass_outside_radius (γ : ℕ → ℝ) (σ : ℝ)
    (h : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (γ n) ^ 2)))) :
    Tendsto (fun R : ℝ => ∑' n : ℕ,
      if R ≤ |γ n| then Real.exp (-(σ ^ 2 * (γ n) ^ 2)) else 0)
      atTop (𝓝 0) := by
  set w : ℕ → ℝ := fun n => Real.exp (-(σ ^ 2 * (γ n) ^ 2)) with hwdef
  have hw0 : ∀ n, 0 ≤ w n := fun n => (Real.exp_pos _).le
  have hw : Summable w := h
  have htail : Tendsto (fun N : ℕ => ∑' k : ℕ, w (k + N)) atTop (𝓝 0) := by
    have hsum := hw.hasSum.tendsto_sum_nat
    have hconst : Tendsto (fun _ : ℕ => (∑' i : ℕ, w i)) atTop (𝓝 (∑' i : ℕ, w i)) :=
      tendsto_const_nhds
    have hsub := hconst.sub hsum
    have hEq : (fun N : ℕ => (∑' i : ℕ, w i) - ∑ i ∈ Finset.range N, w i)
        = fun N : ℕ => ∑' k : ℕ, w (k + N) := by
      funext N
      have hsplit := hw.sum_add_tsum_nat_add N
      linarith
    rw [← hEq]
    simpa using hsub
  rw [Metric.tendsto_atTop]
  intro ε hε
  obtain ⟨N, hN⟩ := (htail.eventually (eventually_lt_nhds hε)).exists
  set M : ℝ := ∑ n ∈ Finset.range N, |γ n| with hMdef
  have hM0 : 0 ≤ M := by
    rw [hMdef]
    exact Finset.sum_nonneg (fun n _ => abs_nonneg _)
  refine ⟨M + 1, fun R hR => ?_⟩
  have hg : Summable (fun n : ℕ => if R ≤ |γ n| then w n else 0) := by
    apply Summable.of_nonneg_of_le (fun n => ?_) (fun n => ?_) hw
    · split_ifs <;> simp [hw0]
    · split_ifs <;> simp [hw0]
  have hg_tail : Summable (fun k : ℕ => if R ≤ |γ (k + N)| then w (k + N) else 0) :=
    hg.comp_injective (fun a b h => Nat.add_right_cancel h)
  have hw_tail : Summable (fun k : ℕ => w (k + N)) :=
    (summable_nat_add_iff N).mpr hw
  have hle_tail : ∀ k : ℕ,
      (if R ≤ |γ (k + N)| then w (k + N) else 0) ≤ w (k + N) := by
    intro k
    split_ifs <;> simp [hw0]
  have hsum_split := hg.sum_add_tsum_nat_add N
  have hfirst_zero : (∑ n ∈ Finset.range N, (if R ≤ |γ n| then w n else 0)) = 0 := by
    apply Finset.sum_eq_zero
    intro n hn
    have hγle : |γ n| ≤ M := by
      rw [hMdef]
      exact Finset.single_le_sum (fun i _ => abs_nonneg (γ i)) hn
    have : ¬ R ≤ |γ n| := by linarith
    simp [this]
  have htail_le : (∑' k : ℕ, (if R ≤ |γ (k + N)| then w (k + N) else 0))
      ≤ ∑' k : ℕ, w (k + N) :=
    hg_tail.tsum_le_tsum hle_tail hw_tail
  have hsum_le : (∑' n : ℕ, (if R ≤ |γ n| then w n else 0)) ≤ ∑' k : ℕ, w (k + N) := by
    rw [← hsum_split, hfirst_zero]
    simpa using htail_le
  have hsum_nonneg : 0 ≤ ∑' n : ℕ, (if R ≤ |γ n| then w n else 0) :=
    tsum_nonneg (fun n => by split_ifs <;> simp [hw0])
  have hsum_lt : (∑' n : ℕ, (if R ≤ |γ n| then w n else 0)) < ε := by
    have : (∑' k : ℕ, w (k + N)) < ε := hN
    linarith
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hsum_nonneg]
  exact hsum_lt

/-- **Zero-counting input in `r log r` form.**  The unconditional order-one
growth bound `exists_bound_log_norm_xi₀` gives a Riemann–von Mangoldt-type
count `N(r) ≤ C r log(r+2) + D`.  This supplies the counting side of the W4
estimate; the entrywise zero-density bound `B` itself is still open. -/
theorem zero_count_le_rlog (r : ℝ) (hr : 0 < r) :
    ∃ C D : ℝ, 0 ≤ C ∧
      ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 r}.ncard : ℝ)
        ≤ C * r * Real.log (r + 2) + D := by
  obtain ⟨A, B, hA, hgrowth⟩ := AbsoluteHodgeZetaStrip.exists_bound_log_norm_xi₀
  set B' : ℝ := max B 0 with hB'
  have hB'0 : 0 ≤ B' := le_max_right B 0
  have hlog2pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  set L : ℝ := A * (2 * r) * Real.log (2 * r + 2) + B' with hL
  have hL0 : 0 ≤ L := by
    have h1 : 0 ≤ A * (2 * r) := mul_nonneg hA (by positivity)
    have h2 : 0 ≤ Real.log (2 * r + 2) := Real.log_nonneg (by linarith)
    exact add_nonneg (mul_nonneg h1 h2) hB'0
  have hbound : ∀ z ∈ Metric.sphere (0 : ℂ) (2 * r), Real.log ‖xi₀ z‖ ≤ L := by
    intro z hz
    have hz2 : ‖z‖ = 2 * r := by
      simpa [dist_eq_norm] using hz
    have h := hgrowth z
    rw [hz2] at h
    have hBle : B ≤ B' := le_max_left B 0
    linarith
  have hcount := AbsoluteHodgeHadamard.xi₀_zero_count_bound_of_log_le r hr hL0 hbound
  refine ⟨4 * A / Real.log 2, B' / Real.log 2, ?_, ?_⟩
  · positivity
  · have hlogcmp : Real.log (2 * r + 2) ≤ 2 * Real.log (r + 2) := by
      have hle : 2 * r + 2 ≤ 2 * (r + 2) := by nlinarith
      have hmono : Real.log (2 * r + 2) ≤ Real.log (2 * (r + 2)) :=
        Real.log_le_log (by linarith) hle
      have hsplit : Real.log (2 * (r + 2)) = Real.log 2 + Real.log (r + 2) :=
        Real.log_mul (by norm_num) (by linarith)
      have hlogr : Real.log 2 ≤ Real.log (r + 2) :=
        Real.log_le_log (by norm_num) (by linarith)
      rw [hsplit] at hmono
      linarith
    have hLle : L ≤ 4 * A * r * Real.log (r + 2) + B' := by
      have hmul : A * (2 * r) * Real.log (2 * r + 2)
          ≤ A * (2 * r) * (2 * Real.log (r + 2)) := by
        apply mul_le_mul_of_nonneg_left hlogcmp
        exact mul_nonneg hA (by positivity)
      nlinarith
    calc ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 r}.ncard : ℝ)
        ≤ L / Real.log 2 := hcount
      _ ≤ (4 * A * r * Real.log (r + 2) + B') / Real.log 2 :=
          div_le_div_of_nonneg_right hLle hlog2pos.le
      _ = (4 * A / Real.log 2) * r * Real.log (r + 2) + B' / Real.log 2 := by
          ring

/-- **The high-zero Gaussian tail satisfies W4 at any accuracy.**  For the
Gaussian zero-side sums restricted to `|Im aₙ| ≥ R`, the four entries satisfy
`TailEntryBound` with `B = C ε`, where `R` can be chosen as large as needed.
This is the quantitative W4 use of the vanishing height tail: only the finitely
many low zeros require separate treatment. -/
theorem exists_tailEntryBound_gaussian_high (c σ : ℝ) (a : ℕ → ℂ) (hσ : 0 < σ)
    (hre : ∀ n, 0 < (a n).re ∧ (a n).re < 1)
    (h : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (a n).im ^ 2)))) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ ε : ℝ, 0 < ε → ∃ R : ℝ,
      TailEntryBound
        (∑' n : ℕ, (if R ≤ |(a n).im| then gaussianZeroTest c σ (a n) else 0)).re
        (∑' n : ℕ, (if R ≤ |(a n).im| then gaussianZeroTest c σ (a n) else 0)).re
        (∑' n : ℕ, (if R ≤ |(a n).im| then gaussianZeroTest c σ (a n) else 0)).re
        (∑' n : ℕ, (if R ≤ |(a n).im| then gaussianZeroTest c σ (a n) else 0)).re
        (C * ε) := by
  obtain ⟨C, hC0, hC⟩ := exists_gaussianZeroTest_bound_strip c σ hσ
  refine ⟨C, hC0, fun ε hε => ?_⟩
  have htail := tendsto_gaussian_zero_mass_outside_radius (fun n => (a n).im) σ h
  rw [Metric.tendsto_atTop] at htail
  obtain ⟨R, hR⟩ := htail ε hε
  refine ⟨R, ?_⟩
  set w : ℕ → ℝ := fun n =>
    if R ≤ |(a n).im| then Real.exp (-(σ ^ 2 * (a n).im ^ 2)) else 0 with hwdef
  set f : ℕ → ℂ := fun n =>
    if R ≤ |(a n).im| then gaussianZeroTest c σ (a n) else 0 with hfdef
  have hw0 : ∀ n, 0 ≤ w n := by
    intro n
    by_cases hRle : R ≤ |(a n).im|
    · have hwn : w n = Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := by simp [hwdef, hRle]
      rw [hwn]
      positivity
    · have hwn : w n = 0 := by simp [hwdef, hRle]
      rw [hwn]
  have hw : Summable w := by
    apply Summable.of_nonneg_of_le hw0 (fun n => ?_) h
    by_cases hRle : R ≤ |(a n).im|
    · have hwn : w n = Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := by simp [hwdef, hRle]
      rw [hwn]
    · have hwn : w n = 0 := by simp [hwdef, hRle]
      rw [hwn]
      positivity
  have hf_bound : ∀ n, ‖f n‖ ≤ C * w n := by
    intro n
    rw [hfdef, hwdef]
    by_cases hRle : R ≤ |(a n).im|
    · simp [hRle]
      have hx := hre n
      have harg : ((a n).re : ℂ) + ((a n).im : ℂ) * I = a n := Complex.re_add_im (a n)
      simpa [harg] using hC (a n).re hx.1 hx.2 (a n).im
    · simp [hRle, Real.exp_pos _ |>.le, hC0]
  have hB := tailEntryBound_of_complex_tail (f00 := f) (f01 := f) (f10 := f) (f11 := f)
    (w := w) (C := C) hw hC0 hf_bound hf_bound hf_bound hf_bound
  have hmass_nonneg : 0 ≤ ∑' n : ℕ, w n := tsum_nonneg hw0
  have hmass_lt : (∑' n : ℕ, w n) < ε := by
    have hdist := hR R le_rfl
    rw [Real.dist_eq, sub_zero, abs_of_nonneg hmass_nonneg] at hdist
    exact hdist
  exact tailEntryBound_mono hB (mul_le_mul_of_nonneg_left hmass_lt.le hC0)

/-- **A product of two Gaussian test functions has a uniform strip bound.**
`‖H_{c₁}(z) H_{c₂}(z)‖ ≤ C exp(−2σ²(Im z)²)` for `0 < Re z < 1`. -/
theorem exists_gaussianZeroTest_mul_bound_strip (c₁ c₂ σ : ℝ) (hσ : 0 < σ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ x : ℝ, 0 < x → x < 1 → ∀ y : ℝ,
      ‖gaussianZeroTest c₁ σ ((x : ℂ) + (y : ℂ) * I)
        * gaussianZeroTest c₂ σ ((x : ℂ) + (y : ℂ) * I)‖
        ≤ C * Real.exp (-(2 * σ ^ 2) * y ^ 2) := by
  obtain ⟨C₁, hC₁0, hb₁⟩ := exists_gaussianZeroTest_bound_strip c₁ σ hσ
  obtain ⟨C₂, hC₂0, hb₂⟩ := exists_gaussianZeroTest_bound_strip c₂ σ hσ
  refine ⟨C₁ * C₂, by positivity, ?_⟩
  intro x hx0 hx1 y
  have h1 := hb₁ x hx0 hx1 y
  have h2 := hb₂ x hx0 hx1 y
  calc ‖gaussianZeroTest c₁ σ ((x : ℂ) + (y : ℂ) * I)
        * gaussianZeroTest c₂ σ ((x : ℂ) + (y : ℂ) * I)‖
      = ‖gaussianZeroTest c₁ σ ((x : ℂ) + (y : ℂ) * I)‖
        * ‖gaussianZeroTest c₂ σ ((x : ℂ) + (y : ℂ) * I)‖ := norm_mul _ _
    _ ≤ (C₁ * Real.exp (-(σ ^ 2 * y ^ 2))) * (C₂ * Real.exp (-(σ ^ 2 * y ^ 2))) :=
        mul_le_mul h1 h2 (norm_nonneg _) (mul_nonneg hC₁0 (Real.exp_pos _).le)
    _ = (C₁ * C₂) * Real.exp (-(2 * σ ^ 2) * y ^ 2) := by
        have hexp : Real.exp (-(σ ^ 2 * y ^ 2)) * Real.exp (-(σ ^ 2 * y ^ 2))
            = Real.exp (-(2 * σ ^ 2) * y ^ 2) := by
          rw [← Real.exp_add]
          congr 1
          ring
        calc (C₁ * Real.exp (-(σ ^ 2 * y ^ 2))) * (C₂ * Real.exp (-(σ ^ 2 * y ^ 2)))
            = (C₁ * C₂) * (Real.exp (-(σ ^ 2 * y ^ 2)) * Real.exp (-(σ ^ 2 * y ^ 2))) := by ring
          _ = (C₁ * C₂) * Real.exp (-(2 * σ ^ 2) * y ^ 2) := by rw [hexp]

/-- The Gaussian zero-side **Gram entry model** `∑ H_{c₁}(aₙ) H_{c₂}(aₙ)`. -/
noncomputable def gaussianZeroGramEntry (c₁ c₂ σ : ℝ) (a : ℕ → ℂ) : ℝ :=
  (∑' n : ℕ, gaussianZeroTest c₁ σ (a n) * gaussianZeroTest c₂ σ (a n)).re

/-- **The product Gaussian zero-side block satisfies W4.**  For four pairs of
test parameters, the four product sums obey `TailEntryBound` with a single
finite `B`, provided `∑ exp(−2σ²(Im aₙ)²)` converges.  This is closer to the
actual Gram entries, which are sums of products of two test functions. -/
theorem exists_tailEntryBound_gaussian_gram_all
    (c00₁ c00₂ c01₁ c01₂ c10₁ c10₂ c11₁ c11₂ σ : ℝ) (a : ℕ → ℂ)
    (hσ : 0 < σ) (hre : ∀ n, 0 < (a n).re ∧ (a n).re < 1)
    (h : Summable (fun n : ℕ => Real.exp (-(2 * σ ^ 2) * (a n).im ^ 2))) :
    ∃ B : ℝ, 0 ≤ B ∧
      TailEntryBound
        (gaussianZeroGramEntry c00₁ c00₂ σ a)
        (gaussianZeroGramEntry c01₁ c01₂ σ a)
        (gaussianZeroGramEntry c10₁ c10₂ σ a)
        (gaussianZeroGramEntry c11₁ c11₂ σ a) B := by
  obtain ⟨C00, hC00, hb00⟩ := exists_gaussianZeroTest_mul_bound_strip c00₁ c00₂ σ hσ
  obtain ⟨C01, hC01, hb01⟩ := exists_gaussianZeroTest_mul_bound_strip c01₁ c01₂ σ hσ
  obtain ⟨C10, hC10, hb10⟩ := exists_gaussianZeroTest_mul_bound_strip c10₁ c10₂ σ hσ
  obtain ⟨C11, hC11, hb11⟩ := exists_gaussianZeroTest_mul_bound_strip c11₁ c11₂ σ hσ
  set C : ℝ := max (max C00 C01) (max C10 C11) with hCdef
  have hC0 : 0 ≤ C := by rw [hCdef]; positivity
  have hC00' : C00 ≤ C := by rw [hCdef]; exact le_trans (le_max_left _ _) (le_max_left _ _)
  have hC01' : C01 ≤ C := by rw [hCdef]; exact le_trans (le_max_right _ _) (le_max_left _ _)
  have hC10' : C10 ≤ C := by rw [hCdef]; exact le_trans (le_max_left _ _) (le_max_right _ _)
  have hC11' : C11 ≤ C := by rw [hCdef]; exact le_trans (le_max_right _ _) (le_max_right _ _)
  have hterm : ∀ (c₁ c₂ C' : ℝ), C' ≤ C →
      (∀ x y : ℝ, 0 < x → x < 1 →
        ‖gaussianZeroTest c₁ σ ((x : ℂ) + (y : ℂ) * I)
          * gaussianZeroTest c₂ σ ((x : ℂ) + (y : ℂ) * I)‖
          ≤ C' * Real.exp (-(2 * σ ^ 2) * y ^ 2)) →
      ∀ n, ‖gaussianZeroTest c₁ σ (a n) * gaussianZeroTest c₂ σ (a n)‖
        ≤ C * Real.exp (-(2 * σ ^ 2) * (a n).im ^ 2) := by
    intro c₁ c₂ C' hC' hb n
    have hx := hre n
    have harg : ((a n).re : ℂ) + ((a n).im : ℂ) * I = a n := Complex.re_add_im (a n)
    calc ‖gaussianZeroTest c₁ σ (a n) * gaussianZeroTest c₂ σ (a n)‖
        = ‖gaussianZeroTest c₁ σ (((a n).re : ℂ) + ((a n).im : ℂ) * I)
            * gaussianZeroTest c₂ σ (((a n).re : ℂ) + ((a n).im : ℂ) * I)‖ := by rw [harg]
      _ ≤ C' * Real.exp (-(2 * σ ^ 2) * (a n).im ^ 2) := hb (a n).re (a n).im hx.1 hx.2
      _ ≤ C * Real.exp (-(2 * σ ^ 2) * (a n).im ^ 2) := by
          apply mul_le_mul_of_nonneg_right hC' (Real.exp_pos _).le
  refine ⟨C * ∑' n : ℕ, Real.exp (-(2 * σ ^ 2) * (a n).im ^ 2), by positivity, ?_⟩
  have hB := tailEntryBound_of_complex_tail
    (f00 := fun n => gaussianZeroTest c00₁ σ (a n) * gaussianZeroTest c00₂ σ (a n))
    (f01 := fun n => gaussianZeroTest c01₁ σ (a n) * gaussianZeroTest c01₂ σ (a n))
    (f10 := fun n => gaussianZeroTest c10₁ σ (a n) * gaussianZeroTest c10₂ σ (a n))
    (f11 := fun n => gaussianZeroTest c11₁ σ (a n) * gaussianZeroTest c11₂ σ (a n))
    (w := fun n => Real.exp (-(2 * σ ^ 2) * (a n).im ^ 2)) (C := C)
    h hC0
    (hterm c00₁ c00₂ C00 hC00' (fun x y hx0 hx1 => hb00 x hx0 hx1 y))
    (hterm c01₁ c01₂ C01 hC01' (fun x y hx0 hx1 => hb01 x hx0 hx1 y))
    (hterm c10₁ c10₂ C10 hC10' (fun x y hx0 hx1 => hb10 x hx0 hx1 y))
    (hterm c11₁ c11₂ C11 hC11' (fun x y hx0 hx1 => hb11 x hx0 hx1 y))
  simpa [gaussianZeroGramEntry] using hB

/-- **The full Gaussian zero-side block satisfies W4.**  For four test
parameters `c₀₀, c₀₁, c₁₀, c₁₁`, the four zero-side sums `∑ H_{cᵢⱼ}(aₙ)` obey
`TailEntryBound` with a single finite `B = C ∑ exp(−σ²(Im aₙ)²)`, provided the
Gaussian zero tail is summable and the arguments lie in the critical strip.
This is the entrywise W4 bound in the Gaussian model, with no height
truncation. -/
theorem exists_tailEntryBound_gaussian_all (c00 c01 c10 c11 σ : ℝ) (a : ℕ → ℂ)
    (hσ : 0 < σ) (hre : ∀ n, 0 < (a n).re ∧ (a n).re < 1)
    (h : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (a n).im ^ 2)))) :
    ∃ B : ℝ, 0 ≤ B ∧
      TailEntryBound
        (gaussianZeroTailEntry c00 σ a).re
        (gaussianZeroTailEntry c01 σ a).re
        (gaussianZeroTailEntry c10 σ a).re
        (gaussianZeroTailEntry c11 σ a).re B := by
  obtain ⟨C00, hC00, hb00⟩ := exists_gaussianZeroTest_bound_strip c00 σ hσ
  obtain ⟨C01, hC01, hb01⟩ := exists_gaussianZeroTest_bound_strip c01 σ hσ
  obtain ⟨C10, hC10, hb10⟩ := exists_gaussianZeroTest_bound_strip c10 σ hσ
  obtain ⟨C11, hC11, hb11⟩ := exists_gaussianZeroTest_bound_strip c11 σ hσ
  set C : ℝ := max (max C00 C01) (max C10 C11) with hCdef
  have hC0 : 0 ≤ C := by
    rw [hCdef]
    positivity
  have hC00' : C00 ≤ C := by
    rw [hCdef]; exact le_trans (le_max_left _ _) (le_max_left _ _)
  have hC01' : C01 ≤ C := by
    rw [hCdef]; exact le_trans (le_max_right _ _) (le_max_left _ _)
  have hC10' : C10 ≤ C := by
    rw [hCdef]; exact le_trans (le_max_left _ _) (le_max_right _ _)
  have hC11' : C11 ≤ C := by
    rw [hCdef]; exact le_trans (le_max_right _ _) (le_max_right _ _)
  have hterm : ∀ (c C' : ℝ), C' ≤ C →
      (∀ x y : ℝ, 0 < x → x < 1 →
        ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖
          ≤ C' * Real.exp (-(σ ^ 2 * y ^ 2))) →
      ∀ n, ‖gaussianZeroTest c σ (a n)‖
        ≤ C * Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := by
    intro c C' hC' hb n
    have hx := hre n
    have harg : ((a n).re : ℂ) + ((a n).im : ℂ) * I = a n := Complex.re_add_im (a n)
    calc ‖gaussianZeroTest c σ (a n)‖
        = ‖gaussianZeroTest c σ (((a n).re : ℂ) + ((a n).im : ℂ) * I)‖ := by rw [harg]
      _ ≤ C' * Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := hb (a n).re (a n).im hx.1 hx.2
      _ ≤ C * Real.exp (-(σ ^ 2 * (a n).im ^ 2)) := by
          apply mul_le_mul_of_nonneg_right hC' (Real.exp_pos _).le
  refine ⟨C * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (a n).im ^ 2)), by positivity, ?_⟩
  have hB := tailEntryBound_of_complex_tail
    (f00 := fun n => gaussianZeroTest c00 σ (a n))
    (f01 := fun n => gaussianZeroTest c01 σ (a n))
    (f10 := fun n => gaussianZeroTest c10 σ (a n))
    (f11 := fun n => gaussianZeroTest c11 σ (a n))
    (w := fun n => Real.exp (-(σ ^ 2 * (a n).im ^ 2))) (C := C)
    h hC0
    (hterm c00 C00 hC00' (fun x y hx0 hx1 => hb00 x hx0 hx1 y))
    (hterm c01 C01 hC01' (fun x y hx0 hx1 => hb01 x hx0 hx1 y))
    (hterm c10 C10 hC10' (fun x y hx0 hx1 => hb10 x hx0 hx1 y))
    (hterm c11 C11 hC11' (fun x y hx0 hx1 => hb11 x hx0 hx1 y))
  simpa [gaussianZeroTailEntry] using hB

/-- The **actual on-line zero-side Gram entry** over an enumeration of
ordinates: `∑ 2πσ² exp(−σ²γₙ²) cos((a−b)γₙ)`.  This is the entry from
`zeroSideGramReal_posSemidef`. -/
noncomputable def onLineGramEntry (a b σ : ℝ) (γ : ℕ → ℝ) : ℝ :=
  ∑' n : ℕ, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2))
    * Real.cos ((a - b) * γ n)

/-- **The actual on-line Gram entries satisfy W4 with a finite `B`.**  The
four on-line entries are bounded by `2πσ²` times the Gaussian zero mass, so
they satisfy `TailEntryBound` whenever that mass is finite.  This uses the
genuine cosine Gram entries, not a model. -/
theorem exists_tailEntryBound_onLineGram
    (a00 b00 a01 b01 a10 b10 a11 b11 σ : ℝ) (γ : ℕ → ℝ)
    (hσ : 0 < σ) (h : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (γ n) ^ 2)))) :
    ∃ B : ℝ, 0 ≤ B ∧
      TailEntryBound
        (onLineGramEntry a00 b00 σ γ)
        (onLineGramEntry a01 b01 σ γ)
        (onLineGramEntry a10 b10 σ γ)
        (onLineGramEntry a11 b11 σ γ) B := by
  set C : ℝ := 2 * Real.pi * σ ^ 2 with hCdef
  have hC0 : 0 ≤ C := by rw [hCdef]; positivity
  have hterm : ∀ (a b : ℝ) (n : ℕ),
      |C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a - b) * γ n)|
        ≤ C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := by
    intro a b n
    have hCpos : 0 ≤ C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) :=
      mul_nonneg hC0 (Real.exp_pos _).le
    rw [abs_mul, abs_of_nonneg hCpos]
    exact mul_le_of_le_one_right hCpos (Real.abs_cos_le_one _)
  have hentry : ∀ (a b : ℝ), |onLineGramEntry a b σ γ|
      ≤ C * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := by
    intro a b
    have hg : Summable (fun n : ℕ =>
        C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a - b) * γ n)) := by
      apply (h.mul_left C).of_norm_bounded
      intro n
      rw [Real.norm_eq_abs]
      exact hterm a b n
    have hw : Summable (fun n : ℕ => C * Real.exp (-(σ ^ 2 * (γ n) ^ 2))) :=
      h.mul_left C
    calc |onLineGramEntry a b σ γ|
        = ‖∑' n : ℕ, C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a - b) * γ n)‖ := by
            rw [onLineGramEntry, Real.norm_eq_abs]
      _ ≤ ∑' n : ℕ, ‖C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a - b) * γ n)‖ :=
            norm_tsum_le_tsum_norm hg.norm
      _ = ∑' n : ℕ, |C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a - b) * γ n)| := by
            simp [Real.norm_eq_abs]
      _ ≤ ∑' n : ℕ, C * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) :=
            hg.norm.tsum_le_tsum (fun n => hterm a b n) hw
      _ = C * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := tsum_mul_left
  refine ⟨C * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γ n) ^ 2)), by positivity, ?_⟩
  exact ⟨hentry a00 b00, hentry a01 b01, hentry a10 b10, hentry a11 b11⟩

/-- The actual on-line Gram kernel is symmetric in the two centres. -/
theorem onLineGramEntry_comm (a b σ : ℝ) (γ : ℕ → ℝ) :
    onLineGramEntry a b σ γ = onLineGramEntry b a σ γ := by
  unfold onLineGramEntry
  congr 1
  ext n
  rw [show a - b = -(b - a) by ring, neg_mul, Real.cos_neg]

/-- The actual on-line Gram matrix over a finite family of centres. -/
def onLineGramMatrix {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ) (γ : ℕ → ℝ) :
    Matrix ι ι ℝ :=
  fun i j => onLineGramEntry (a i) (a j) σ γ

/-- The actual on-line Gram matrix is symmetric. -/
theorem onLineGramMatrix_isSymm {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (γ : ℕ → ℝ) : (onLineGramMatrix a σ γ).IsSymm := by
  apply Matrix.IsSymm.ext
  intro i j
  exact (onLineGramEntry_comm (a i) (a j) σ γ).symm

/-- A single-frequency on-line Gram matrix is positive semidefinite. -/
theorem onLineGramMatrix_single_posSemidef {ι : Type*} [Fintype ι]
    (a : ι → ℝ) {w γ : ℝ} (hw : 0 ≤ w) :
    (Matrix.of (fun i j => w * Real.cos ((a i - a j) * γ))).PosSemidef := by
  have h1 := Matrix.posSemidef_vecMulVec_self_star
    (fun i : ι => Real.cos (a i * γ)) (R := ℝ)
  have h2 := Matrix.posSemidef_vecMulVec_self_star
    (fun i : ι => Real.sin (a i * γ)) (R := ℝ)
  have hsum := h1.add h2
  have hw' : (0 : ℝ) ≤ w := hw
  have hmul := hsum.smul hw'
  convert hmul using 1
  ext i j
  simp only [Matrix.smul_apply, Matrix.add_apply, Matrix.vecMulVec, Matrix.of_apply,
    smul_eq_mul, star_trivial, sub_mul, Real.cos_sub]

/-- A finite weighted sum of single-frequency on-line Gram matrices is positive
semidefinite. -/
theorem onLineGramMatrix_finset_posSemidef {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (s : Finset ℕ) (w γ : ℕ → ℝ) (hw : ∀ n ∈ s, 0 ≤ w n) :
    (Matrix.of (fun i j => ∑ n ∈ s, w n * Real.cos ((a i - a j) * γ n))).PosSemidef := by
  have hterm : ∀ n ∈ s,
      (Matrix.of (fun i j => w n * Real.cos ((a i - a j) * γ n))).PosSemidef :=
    fun n hn => onLineGramMatrix_single_posSemidef a (hw n hn)
  have hsum := Matrix.posSemidef_sum s hterm
  convert hsum using 1
  ext i j
  simp [Matrix.sum_apply]

/-- The on-line Gaussian weights are nonnegative. -/
theorem onLineWeight_nonneg (σ γ : ℝ) :
    0 ≤ 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) := by
  positivity

/-- The quadratic form of a finite weighted on-line Gram matrix is nonnegative. -/
theorem onLineGramMatrix_finset_quadraticForm_nonneg {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (s : Finset ℕ) (w γ : ℕ → ℝ) (hw : ∀ n ∈ s, 0 ≤ w n)
    (x : ι → ℝ) :
    0 ≤ x ⬝ᵥ ((Matrix.of
      (fun i j => ∑ n ∈ s, w n * Real.cos ((a i - a j) * γ n))) *ᵥ x) :=
  (onLineGramMatrix_finset_posSemidef a s w γ hw).dotProduct_mulVec_nonneg x

/-- A pointwise `tsum` of positive semidefinite matrices is positive
semidefinite, provided every entry series is summable. -/
theorem posSemidef_tsum {ι : Type*} [Fintype ι] [DecidableEq ι]
    {M : ℕ → Matrix ι ι ℝ}
    (hM : ∀ n, (M n).PosSemidef)
    (h : ∀ i j, Summable (fun n => M n i j)) :
    (Matrix.of (fun i j => ∑' n, M n i j)).PosSemidef := by
  have hsymn : ∀ i j, (∑' n, M n j i) = ∑' n, M n i j := by
    intro i j
    exact tsum_congr (fun n => by
      have := (hM n).1.apply j i
      simpa [star_trivial] using this.symm)
  rw [Matrix.posSemidef_iff_dotProduct_mulVec]
  refine ⟨?_, ?_⟩
  · ext i j
    simp only [Matrix.conjTranspose_apply, star_trivial]
    exact hsymn i j
  · intro x
    simp only [star_trivial]
    have hsum_mulvec : ∀ i, Summable (fun n => (M n *ᵥ x) i) := by
      intro i
      have : ∀ s : Finset ι, Summable (fun n => ∑ j ∈ s, M n i j * x j) := by
        intro s
        induction s using Finset.induction_on with
        | empty => simp
        | insert a s ha ih =>
            have hsplit : (fun n => ∑ j ∈ insert a s, M n i j * x j)
                = fun n => M n i a * x a + ∑ j ∈ s, M n i j * x j := by
              ext n
              rw [Finset.sum_insert ha]
            rw [hsplit]
            exact ((h i a).mul_right (x a)).add ih
      simpa [mulVec, dotProduct] using this Finset.univ
    have hmulvec : (Matrix.of (fun i j => ∑' n, M n i j)) *ᵥ x
        = fun i => ∑' n, (M n *ᵥ x) i := by
      ext i
      simp only [mulVec, Matrix.of_apply]
      calc ∑ j, (∑' n, M n i j) * x j
          = ∑ j, ∑' n, M n i j * x j := by
            exact Finset.sum_congr rfl (fun j _ => (tsum_mul_right).symm)
        _ = ∑' n, ∑ j, M n i j * x j := by
            exact (Summable.tsum_finsetSum (fun j _ => (h i j).mul_right (x j))).symm
        _ = ∑' n, (M n *ᵥ x) i := by
            simp [mulVec, dotProduct]
    have hdot : x ⬝ᵥ ((Matrix.of (fun i j => ∑' n, M n i j)) *ᵥ x)
        = ∑' n, x ⬝ᵥ (M n *ᵥ x) := by
      rw [hmulvec]
      simp only [dotProduct]
      calc ∑ i, x i * (∑' n, (M n *ᵥ x) i)
          = ∑ i, ∑' n, x i * (M n *ᵥ x) i := by
            exact Finset.sum_congr rfl (fun i _ => (tsum_mul_left).symm)
        _ = ∑' n, ∑ i, x i * (M n *ᵥ x) i := by
            exact (Summable.tsum_finsetSum
              (fun i _ => (hsum_mulvec i).mul_left (x i))).symm
    rw [hdot]
    exact tsum_nonneg (fun n => (hM n).dotProduct_mulVec_nonneg x)

/-- **The actual on-line Gram matrix is positive semidefinite**, assuming the
Gaussian-weighted cosine entries are summable. -/
theorem onLineGramMatrix_posSemidef {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → ℝ) (σ : ℝ) (γ : ℕ → ℝ)
    (h : ∀ i j, Summable (fun n => 2 * Real.pi * σ ^ 2
      * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a i - a j) * γ n))) :
    (onLineGramMatrix a σ γ).PosSemidef := by
  have hterm : ∀ n, (Matrix.of (fun i j => 2 * Real.pi * σ ^ 2
      * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) * Real.cos ((a i - a j) * γ n))).PosSemidef :=
    fun n => onLineGramMatrix_single_posSemidef a (onLineWeight_nonneg σ (γ n))
  have hsum := posSemidef_tsum hterm h
  convert hsum using 1
  ext i j
  simp [onLineGramMatrix, onLineGramEntry, Matrix.of_apply]

/-- The on-line Gram matrix is positive semidefinite whenever the Gaussian
zero-weight series is summable. -/
theorem onLineGramMatrix_posSemidef_of_exp_summable {ι : Type*} [Fintype ι]
    [DecidableEq ι] (a : ι → ℝ) (σ : ℝ) (γ : ℕ → ℝ)
    (h : Summable (fun n => Real.exp (-(σ ^ 2 * (γ n) ^ 2)))) :
    (onLineGramMatrix a σ γ).PosSemidef := by
  apply onLineGramMatrix_posSemidef
  intro i j
  have hw : 0 ≤ 2 * Real.pi * σ ^ 2 := by positivity
  refine Summable.of_norm_bounded (h.mul_left (2 * Real.pi * σ ^ 2)) (fun n => ?_)
  calc ‖2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2))
        * Real.cos ((a i - a j) * γ n)‖
      = (2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2)))
        * ‖Real.cos ((a i - a j) * γ n)‖ := by
        rw [norm_mul, Real.norm_of_nonneg (by positivity)]
    _ ≤ (2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2))) * 1 := by
        gcongr
        rw [Real.norm_eq_abs]
        exact Real.abs_cos_le_one _
    _ = 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := by ring

/-- **The on-line Gram matrix is PSD under the named `ZeroTailSummable`
input.** -/
theorem onLineGramMatrix_posSemidef_of_zeroTailSummable {ι : Type*} [Fintype ι]
    [DecidableEq ι] (a : ι → ℝ) (σ : ℝ) (γ : ℕ → ℝ)
    (h : ZeroTailSummable γ σ) :
    (onLineGramMatrix a σ γ).PosSemidef :=
  onLineGramMatrix_posSemidef_of_exp_summable a σ γ h

/-- The quadratic form of the actual on-line Gram matrix is nonnegative under
`ZeroTailSummable`. -/
theorem onLineGramMatrix_quadraticForm_nonneg {ι : Type*} [Fintype ι]
    [DecidableEq ι] (a : ι → ℝ) (σ : ℝ) (γ : ℕ → ℝ)
    (h : ZeroTailSummable γ σ) (x : ι → ℝ) :
    0 ≤ x ⬝ᵥ (onLineGramMatrix a σ γ *ᵥ x) :=
  (onLineGramMatrix_posSemidef_of_zeroTailSummable a σ γ h).dotProduct_mulVec_nonneg x

end ZeroDensityBound

