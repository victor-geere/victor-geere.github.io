import GaussianZeroSide
import ZeroTail

open Filter Topology Complex AbsoluteHodgeRectangle

/-!
# Weil positivity — formal core

Weil positivity (objective O2) is the statement that the zero-side Gram
matrices of the Gaussian test family are positive semidefinite.  The
unconditional version is RH-equivalent, so nothing here claims it.

What is proved:

* `WeilPositivity` — the finite critical-line positivity statement, harvested
  from `zeroSideWeilPositivity`;
* `OffLineBlock` and `OffLineBlockPSD` — the isolated 2×2 block of an off-line
  quadruple at separation `c`;
* `not_offLineBlockPSD_of_offLine` — an off-line zero always produces a
  non-PSD block, harvested from `offLineQuad_obstruction_all`;
* `no_offLine_of_all_blocks_psd` — **if every one of these blocks were PSD,
  there would be no off-line zero**, i.e. the Riemann hypothesis.  This is the
  `Weil positivity ⇒ RH` direction, formalised for the isolated block family.

The converse direction (constructing positivity from the three upstream
programmes) is the assembly plan in [`HANDOFF.md`](../HANDOFF.md).  It is not
claimed as a theorem.
-/

noncomputable section
open Complex Matrix

namespace WeilPositivity
open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeHadamard

/-- The finite critical-line zero-side positivity statement: every finite
family of critical-line frequencies gives a PSD Gram matrix. -/
def WeilPositivity : Prop := ZeroSideWeilPositivity

/-- The harvested finite on-line positivity theorem. -/
theorem weilPositivity : WeilPositivity := zeroSideWeilPositivity

/-- The isolated 2×2 zero-side block of an off-line quadruple at separation
`c`, with diagonal `S(0)` and off-diagonal `S(c)`. -/
def OffLineBlock (c σ δ γ : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![(offLineQuad 0 σ δ γ).re, (offLineQuad c σ δ γ).re;
     (offLineQuad c σ δ γ).re, (offLineQuad 0 σ δ γ).re]

/-- The isolated off-line block is positive semidefinite. -/
def OffLineBlockPSD (c σ δ γ : ℝ) : Prop := (OffLineBlock c σ δ γ).PosSemidef

/-- **The symmetric diagonal 2×2 block is PSD iff the diagonal dominates the
off-diagonal.**  This is the scalar form of the isolated-block criterion. -/
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

/-- **Scalar form of the isolated-block criterion.**  The off-line block is PSD
exactly when the on-line diagonal dominates the absolute off-diagonal. -/
theorem offLineBlockPSD_iff (c σ δ γ : ℝ) :
    OffLineBlockPSD c σ δ γ ↔
      |(offLineQuad c σ δ γ).re| ≤ (offLineQuad 0 σ δ γ).re := by
  unfold OffLineBlockPSD OffLineBlock
  exact twoByTwo_diag_posSemidef_iff

/-- The obstruction in scalar form: a diagonal smaller than the absolute
off-diagonal breaks the block. -/
theorem not_offLineBlockPSD_of_abs_lt (c σ δ γ : ℝ)
    (h : (offLineQuad 0 σ δ γ).re < |(offLineQuad c σ δ γ).re|) :
    ¬ OffLineBlockPSD c σ δ γ := by
  rw [offLineBlockPSD_iff]
  exact not_le.mpr h

/-- The negation of block positivity is the scalar inequality. -/
theorem not_offLineBlockPSD_iff (c σ δ γ : ℝ) :
    ¬ OffLineBlockPSD c σ δ γ ↔
      (offLineQuad 0 σ δ γ).re < |(offLineQuad c σ δ γ).re| := by
  rw [offLineBlockPSD_iff, not_le]

/-- Every off-line zero produces a separation whose isolated block is not PSD. -/
theorem not_offLineBlockPSD_of_offLine (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ, ¬ OffLineBlockPSD c σ δ γ := by
  obtain ⟨c, hc⟩ := offLineQuad_obstruction_all σ δ γ hσ hδ
  exact ⟨c, hc⟩

/-- **The off-line obstruction as a separation inequality**: an off-line zero
produces a separation at which the absolute off-diagonal exceeds the on-line
diagonal. -/
theorem exists_abs_offLineQuad_gt_of_offLine (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ, (offLineQuad 0 σ δ γ).re < |(offLineQuad c σ δ γ).re| := by
  obtain ⟨c, hc⟩ := not_offLineBlockPSD_of_offLine σ δ γ hσ hδ
  exact ⟨c, (not_offLineBlockPSD_iff c σ δ γ).1 hc⟩

/-- **The off-line contribution is unbounded in modulus**: for every `K` there
is a separation with `K < |S(c)|`. -/
theorem exists_abs_offLineQuad_gt_any (σ δ γ K : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ, K < |(offLineQuad c σ δ γ).re| := by
  obtain ⟨c, hc⟩ := exists_offLineQuad_gt_all σ δ γ hσ hδ K
  exact ⟨c, lt_of_lt_of_le hc (le_abs_self _)⟩

/-- **Universal block positivity in scalar form.** -/
theorem all_blocks_psd_iff_scalar :
    (∀ c σ δ γ : ℝ, OffLineBlockPSD c σ δ γ) ↔
      ∀ c σ δ γ : ℝ,
        |(offLineQuad c σ δ γ).re| ≤ (offLineQuad 0 σ δ γ).re := by
  constructor
  · intro h c σ δ γ
    exact (offLineBlockPSD_iff c σ δ γ).1 (h c σ δ γ)
  · intro h c σ δ γ
    exact (offLineBlockPSD_iff c σ δ γ).2 (h c σ δ γ)

/-- **Failure of RH produces a scalar obstruction.**  If RH fails, there are
`c, σ, δ, γ` with `δ ≠ 0` and `S(0) < |S(c)|`; this is the contrapositive of
the scalar positivity statement, in the exact form consumed by the off-line
block criterion. -/
theorem exists_abs_offLineQuad_gt_of_not_RH
    (h : ¬ AbsoluteHodgeSymbol.RiemannHypothesis) :
    ∃ c σ δ γ : ℝ, 0 < σ ∧ δ ≠ 0 ∧
      (offLineQuad 0 σ δ γ).re < |(offLineQuad c σ δ γ).re| := by
  unfold AbsoluteHodgeSymbol.RiemannHypothesis at h
  push_neg at h
  obtain ⟨ρ, hz, hre0, hre1, hne⟩ := h
  have hδ : ρ.re - 1 / 2 ≠ 0 := by
    intro hzero
    exact hne (by linarith)
  obtain ⟨c, hc⟩ := exists_abs_offLineQuad_gt_of_offLine (1 / 20)
    (ρ.re - 1 / 2) ρ.im (by norm_num) hδ
  exact ⟨c, 1 / 20, ρ.re - 1 / 2, ρ.im, by norm_num, hδ, hc⟩

/-- **Weil positivity for the off-line blocks implies RH.**  If every
isolated off-line block were PSD, every zero in the critical strip would lie
on the critical line. -/
theorem no_offLine_of_all_blocks_psd
    (h : ∀ c σ δ γ : ℝ, δ ≠ 0 → OffLineBlockPSD c σ δ γ) :
    AbsoluteHodgeSymbol.RiemannHypothesis := by
  intro ρ hZ hre0 hre1
  by_contra hne
  have hδ : ρ.re - 1 / 2 ≠ 0 := sub_ne_zero.mpr hne
  obtain ⟨c, hc⟩ := not_offLineBlockPSD_of_offLine (1 / 20) (ρ.re - 1 / 2) ρ.im
    (by norm_num) hδ
  exact hc (h c (1 / 20) (ρ.re - 1 / 2) ρ.im hδ)

/-- **Scalar universal positivity implies RH.** -/
theorem no_offLine_of_all_abs_le
    (h : ∀ c σ δ γ : ℝ,
      |(offLineQuad c σ δ γ).re| ≤ (offLineQuad 0 σ δ γ).re) :
    AbsoluteHodgeSymbol.RiemannHypothesis :=
  no_offLine_of_all_blocks_psd
    (fun c σ δ γ _ => (offLineBlockPSD_iff c σ δ γ).2 (h c σ δ γ))

/-- The isolated off-line block is even in the separation. -/
theorem offLineBlock_neg (c σ δ γ : ℝ) :
    OffLineBlock (-c) σ δ γ = OffLineBlock c σ δ γ := by
  unfold OffLineBlock
  rw [offLineQuad_neg_c]

/-- The isolated off-line PSD predicate is even in the separation. -/
theorem offLineBlockPSD_neg (c σ δ γ : ℝ) :
    OffLineBlockPSD (-c) σ δ γ ↔ OffLineBlockPSD c σ δ γ := by
  unfold OffLineBlockPSD
  rw [offLineBlock_neg]

/-- The isolated off-line block is a symmetric matrix. -/
theorem offLineBlock_isSymm (c σ δ γ : ℝ) :
    (OffLineBlock c σ δ γ).IsSymm := by
  apply Matrix.IsSymm.ext
  intro i j
  fin_cases i <;> fin_cases j <;> simp [OffLineBlock]

/-- The isolated off-line block is PSD exactly when the diagonal dominates the
off-diagonal scalar. -/
theorem offLineBlockPSD_iff_abs_le (c σ δ γ : ℝ) :
    OffLineBlockPSD c σ δ γ ↔
      |(offLineQuad c σ δ γ).re| ≤ (offLineQuad 0 σ δ γ).re := by
  unfold OffLineBlockPSD OffLineBlock
  exact twoByTwo_diag_posSemidef_iff

/-- **An off-line block eventually fails PSD.**  For `σ > 0` and `δ ≠ 0`, some
separation `c` makes the isolated off-line block not positive semidefinite. -/
theorem exists_offLineBlock_not_psd (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ, ¬ OffLineBlockPSD c σ δ γ := by
  obtain ⟨c, hc⟩ :=
    exists_abs_offLineQuad_gt_any σ δ γ ((offLineQuad 0 σ δ γ).re) hσ hδ
  exact ⟨c, fun hM => by
    have hle := (offLineBlockPSD_iff_abs_le c σ δ γ).mp hM
    linarith⟩

def TailEntryBound (E : Matrix (Fin 2) (Fin 2) ℝ) (B : ℝ) : Prop :=
  0 ≤ B ∧ ∀ i j, |E i j| ≤ B

theorem not_posSemidef_add_of_abs_gt (a b B : ℝ)
    {E : Matrix (Fin 2) (Fin 2) ℝ} (hB : 0 ≤ B) (hE : ∀ i j, |E i j| ≤ B)
    (h : a + 4 * B < |b|) :
    ¬ (!![a, b; b, a] + E).PosSemidef := by
  intro hM
  have h00 := abs_le.mp (hE 0 0)
  have h01 := abs_le.mp (hE 0 1)
  have h10 := abs_le.mp (hE 1 0)
  have h11 := abs_le.mp (hE 1 1)
  rcases le_or_gt 0 b with hb | hb
  · have hx := hM.dotProduct_mulVec_nonneg (![1, -1] : Fin 2 → ℝ)
    have hx' : 0 ≤ (![1, -1] : Fin 2 → ℝ) ⬝ᵥ ((!![a, b; b, a] + E) *ᵥ ![1, -1]) := by
      simpa using hx
    have hcalc : (![1, -1] : Fin 2 → ℝ) ⬝ᵥ ((!![a, b; b, a] + E) *ᵥ ![1, -1])
        = 2 * (a - b) + (E 0 0 - E 0 1 - E 1 0 + E 1 1) := by
      simp [dotProduct, mulVec, Fin.sum_univ_two, Matrix.add_apply]
      ring
    rw [hcalc] at hx'
    have hbabs : |b| = b := abs_of_nonneg hb
    linarith
  · have hx := hM.dotProduct_mulVec_nonneg (![1, 1] : Fin 2 → ℝ)
    have hx' : 0 ≤ (![1, 1] : Fin 2 → ℝ) ⬝ᵥ ((!![a, b; b, a] + E) *ᵥ ![1, 1]) := by
      simpa using hx
    have hcalc : (![1, 1] : Fin 2 → ℝ) ⬝ᵥ ((!![a, b; b, a] + E) *ᵥ ![1, 1])
        = 2 * (a + b) + (E 0 0 + E 0 1 + E 1 0 + E 1 1) := by
      simp [dotProduct, mulVec, Fin.sum_univ_two, Matrix.add_apply]
      ring
    rw [hcalc] at hx'
    have hbabs : |b| = -b := abs_of_neg hb
    linarith

/-- **A bounded tail cannot rescue an off-line block.**  If the isolated block's
off-diagonal dominates its diagonal by more than `4B`, then adding any tail
with entries bounded by `B` still gives a non-PSD block. -/
theorem exists_offLineBlock_add_tail_not_psd (σ δ γ B : ℝ) (hσ : 0 < σ)
    (hδ : δ ≠ 0) (hB : 0 ≤ B) {E : Matrix (Fin 2) (Fin 2) ℝ}
    (hE : ∀ i j, |E i j| ≤ B) :
    ∃ c : ℝ, ¬ (OffLineBlock c σ δ γ + E).PosSemidef := by
  obtain ⟨c, hc⟩ := exists_abs_offLineQuad_gt_any σ δ γ
    ((offLineQuad 0 σ δ γ).re + 4 * B) hσ hδ
  exact ⟨c, not_posSemidef_add_of_abs_gt _ _ B hB hE (by simpa using hc)⟩

def gaussianTailEntry (zeros : Finset ℝ) (σ : ℝ) (a b : ℝ) : ℝ :=
  ∑ γ ∈ zeros, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * Real.cos ((a - b) * γ)

def gaussianTailBound (zeros : Finset ℝ) (σ : ℝ) : ℝ :=
  ∑ γ ∈ zeros, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2))

theorem abs_gaussianTailEntry_le (zeros : Finset ℝ) (σ a b : ℝ) :
    |gaussianTailEntry zeros σ a b| ≤ gaussianTailBound zeros σ := by
  unfold gaussianTailEntry gaussianTailBound
  calc |∑ γ ∈ zeros, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * Real.cos ((a - b) * γ)|
      ≤ ∑ γ ∈ zeros, |2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * Real.cos ((a - b) * γ)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ γ ∈ zeros, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) := by
        apply Finset.sum_le_sum
        intro γ _
        rw [abs_mul, abs_of_nonneg (by positivity)]
        calc 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * |Real.cos ((a - b) * γ)|
            ≤ 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * 1 := by
              gcongr
              exact Real.abs_cos_le_one _
          _ = 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) := by ring


/-- A finite Gaussian model of the other-zero tail on a 2×2 block. -/
noncomputable def modelTail (zeros : Finset ℝ) (σ a0 a1 : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![gaussianTailEntry zeros σ a0 a0, gaussianTailEntry zeros σ a0 a1;
     gaussianTailEntry zeros σ a1 a0, gaussianTailEntry zeros σ a1 a1]

/-- **A finite Gaussian tail cannot rescue an off-line block.** -/
theorem exists_offLineBlock_add_modelTail_not_psd (zeros : Finset ℝ)
    (σ δ γ a0 a1 : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ, ¬ (OffLineBlock c σ δ γ + modelTail zeros σ a0 a1).PosSemidef := by
  refine exists_offLineBlock_add_tail_not_psd σ δ γ (gaussianTailBound zeros σ)
    hσ hδ ?_ (fun i j => ?_)
  · unfold gaussianTailBound
    exact Finset.sum_nonneg (fun γ _ => by positivity)
  · fin_cases i <;> fin_cases j <;>
      simp [modelTail] <;> exact abs_gaussianTailEntry_le zeros σ _ _

/-- The Gaussian model tail mass is nonnegative. -/
theorem gaussianTailBound_nonneg (zeros : Finset ℝ) (σ : ℝ) :
    0 ≤ gaussianTailBound zeros σ := by
  unfold gaussianTailBound
  exact Finset.sum_nonneg (fun γ _ => by positivity)

/-- The Gaussian model tail mass is monotone in the zero set. -/
theorem gaussianTailBound_mono {zeros₁ zeros₂ : Finset ℝ} (h : zeros₁ ⊆ zeros₂)
    (σ : ℝ) : gaussianTailBound zeros₁ σ ≤ gaussianTailBound zeros₂ σ := by
  unfold gaussianTailBound
  exact Finset.sum_le_sum_of_subset_of_nonneg h (fun γ _ _ => by positivity)

/-- A finite weighted cosine sum is bounded by the total weight. -/
theorem abs_sum_mul_cos_le {s : Finset ℕ} {w γ : ℕ → ℝ} {a b : ℝ}
    (hw : ∀ n ∈ s, 0 ≤ w n) :
    |∑ n ∈ s, w n * Real.cos ((a - b) * γ n)| ≤ ∑ n ∈ s, w n := by
  calc |∑ n ∈ s, w n * Real.cos ((a - b) * γ n)|
      ≤ ∑ n ∈ s, |w n * Real.cos ((a - b) * γ n)| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ n ∈ s, w n := by
        apply Finset.sum_le_sum
        intro n hn
        rw [abs_mul, abs_of_nonneg (hw n hn)]
        calc w n * |Real.cos ((a - b) * γ n)| ≤ w n * 1 :=
              mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _) (hw n hn)
          _ = w n := by ring

/-- A summable weighted cosine series is bounded by the total weight. -/
theorem abs_tsum_mul_cos_le {w : ℕ → ℝ} {γ : ℕ → ℝ} {a b : ℝ}
    (hw : ∀ n, 0 ≤ w n) (h : Summable w) :
    |∑' n : ℕ, w n * Real.cos ((a - b) * γ n)| ≤ ∑' n : ℕ, w n := by
  have hf : Summable (fun n : ℕ => w n * Real.cos ((a - b) * γ n)) := by
    apply Summable.of_norm_bounded h
    intro n
    rw [Real.norm_eq_abs, abs_mul, abs_of_nonneg (hw n)]
    calc w n * |Real.cos ((a - b) * γ n)| ≤ w n * 1 :=
          mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _) (hw n)
      _ = w n := by ring
  have hle : Summable (fun n : ℕ => |w n * Real.cos ((a - b) * γ n)|) := by
    apply Summable.of_nonneg_of_le (fun n => abs_nonneg _) (fun n => ?_) h
    rw [abs_mul, abs_of_nonneg (hw n)]
    calc w n * |Real.cos ((a - b) * γ n)| ≤ w n * 1 :=
          mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _) (hw n)
      _ = w n := by ring
  have htri : |∑' n : ℕ, w n * Real.cos ((a - b) * γ n)|
      ≤ ∑' n : ℕ, |w n * Real.cos ((a - b) * γ n)| := by
    have h1 : ∑' n : ℕ, w n * Real.cos ((a - b) * γ n)
        ≤ ∑' n : ℕ, |w n * Real.cos ((a - b) * γ n)| :=
      hf.tsum_le_tsum (fun n => le_abs_self _) hle
    have h2 : -(∑' n : ℕ, w n * Real.cos ((a - b) * γ n))
        ≤ ∑' n : ℕ, |w n * Real.cos ((a - b) * γ n)| := by
      have := hf.neg.tsum_le_tsum (fun n => neg_le_abs _) hle
      simpa [tsum_neg] using this
    exact abs_le.mpr ⟨by linarith, h1⟩
  calc |∑' n : ℕ, w n * Real.cos ((a - b) * γ n)|
      ≤ ∑' n : ℕ, |w n * Real.cos ((a - b) * γ n)| := htri
    _ ≤ ∑' n : ℕ, w n := by
        apply hle.tsum_le_tsum _ h
        intro n
        rw [abs_mul, abs_of_nonneg (hw n)]
        calc w n * |Real.cos ((a - b) * γ n)| ≤ w n * 1 :=
              mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _) (hw n)
          _ = w n := by ring


noncomputable def actualGaussianTailEntry (σ : ℝ) (γ : ℕ → ℝ) (a b : ℝ) : ℝ :=
  ∑' n : ℕ, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2))
    * Real.cos ((a - b) * γ n)

theorem abs_actualGaussianTailEntry_le (σ : ℝ) (γ : ℕ → ℝ) (a b : ℝ)
    (h : ZeroTailSummable γ σ) :
    |actualGaussianTailEntry σ γ a b|
      ≤ 2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := by
  have hw : ∀ n : ℕ, 0 ≤ 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) :=
    fun n => by positivity
  have hsum : Summable (fun n : ℕ => 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2))) :=
    h.mul_left _
  have hb := abs_tsum_mul_cos_le (w := fun n : ℕ => 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2)))
    (γ := γ) (a := a) (b := b) hw hsum
  calc |actualGaussianTailEntry σ γ a b|
      = |∑' n : ℕ, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2))
          * Real.cos ((a - b) * γ n)| := rfl
    _ ≤ ∑' n : ℕ, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := hb
    _ = 2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γ n) ^ 2)) := by
        rw [tsum_mul_left]

/-- The actual Gaussian tail block on a 2×2 set of positions. -/
noncomputable def actualTail (σ : ℝ) (γ : ℕ → ℝ) (a0 a1 : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![actualGaussianTailEntry σ γ a0 a0, actualGaussianTailEntry σ γ a0 a1;
     actualGaussianTailEntry σ γ a1 a0, actualGaussianTailEntry σ γ a1 a1]

/-- **The actual Gaussian tail cannot rescue an off-line block.** -/
theorem exists_offLineBlock_add_actualTail_not_psd (σ δ γ₀ : ℝ) (γs : ℕ → ℝ)
    (a0 a1 : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0)
    (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ) :
    ∃ c : ℝ, ¬ (OffLineBlock c σ δ γ₀ + actualTail σ γs a0 a1).PosSemidef := by
  refine exists_offLineBlock_add_tail_not_psd σ δ γ₀
    (2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γs n) ^ 2)))
    hσ hδ ?_ (fun i j => ?_)
  · positivity
  · fin_cases i <;> fin_cases j <;>
      simp [actualTail] <;> exact abs_actualGaussianTailEntry_le σ γs _ _ h

/-- **Explicit margin for the full block.**  If the isolated obstruction exceeds
the total Gaussian tail mass `B = 2πσ² ∑ exp(−σ²γₙ²)` by the T19 margin, the
block `OffLineBlock + actualTail` is not PSD. -/
theorem not_posSemidef_fullBlock_of_margin (c σ δ γ₀ : ℝ) (γs : ℕ → ℝ)
    (a0 a1 : ℝ) (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ)
    (hmargin : (offLineQuad 0 σ δ γ₀).re
        + 4 * (2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γs n) ^ 2)))
      < |(offLineQuad c σ δ γ₀).re|) :
    ¬ (OffLineBlock c σ δ γ₀ + actualTail σ γs a0 a1).PosSemidef := by
  have hB : 0 ≤ 2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γs n) ^ 2)) := by
    positivity
  have hE : ∀ i j, |actualTail σ γs a0 a1 i j|
      ≤ 2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γs n) ^ 2)) := by
    intro i j
    fin_cases i <;> fin_cases j <;>
      simp [actualTail] <;> exact abs_actualGaussianTailEntry_le σ γs _ _ h
  exact not_posSemidef_add_of_abs_gt _ _ _ hB hE hmargin

/-- The full zero-side block in the `OffLineBlock + actualTail` decomposition. -/
noncomputable def fullBlock (c σ δ γ₀ : ℝ) (γs : ℕ → ℝ) (a0 a1 : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  OffLineBlock c σ δ γ₀ + actualTail σ γs a0 a1

/-- The decomposed full block fails PSD for some separation. -/
theorem exists_fullBlock_not_psd (σ δ γ₀ : ℝ) (γs : ℕ → ℝ) (a0 a1 : ℝ)
    (hσ : 0 < σ) (hδ : δ ≠ 0)
    (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ) :
    ∃ c : ℝ, ¬ (fullBlock c σ δ γ₀ γs a0 a1).PosSemidef := by
  obtain ⟨c, hc⟩ := exists_offLineBlock_add_actualTail_not_psd σ δ γ₀ γs a0 a1 hσ hδ h
  exact ⟨c, by simpa [fullBlock] using hc⟩

/-- **Decomposition interface.**  Any block that decomposes as
`OffLineBlock + actualTail` fails PSD for some separation. -/
theorem not_posSemidef_of_eq_fullBlock (σ δ γ₀ : ℝ) (γs : ℕ → ℝ) (a0 a1 : ℝ)
    (hσ : 0 < σ) (hδ : δ ≠ 0)
    (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ)
    {Full : ℝ → Matrix (Fin 2) (Fin 2) ℝ}
    (hdec : ∀ c, Full c = fullBlock c σ δ γ₀ γs a0 a1) :
    ∃ c : ℝ, ¬ (Full c).PosSemidef := by
  obtain ⟨c, hc⟩ := exists_fullBlock_not_psd σ δ γ₀ γs a0 a1 hσ hδ h
  exact ⟨c, by rwa [hdec]⟩

/-- The zero-side sum over a finite set of zeros. -/
noncomputable def zeroSideSum (s : Finset ℂ) (c σ : ℝ) : ℂ :=
  ∑ z ∈ s, gaussianZeroTest c σ z

/-- **Finite decomposition of the zero-side sum.**  Splitting a finite zero set
into an isolated part and its complement. -/
theorem zeroSideSum_eq_isolated_add_tail (s q : Finset ℂ) (hq : q ⊆ s) (c σ : ℝ) :
    zeroSideSum s c σ = zeroSideSum q c σ + zeroSideSum (s \ q) c σ := by
  unfold zeroSideSum
  rw [← Finset.sum_sdiff hq]
  ring

noncomputable def offLineQuadruple (δ γ : ℝ) : Multiset ℂ :=
  {1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I),
   1 / 2 - ((δ : ℂ) + (γ : ℂ) * Complex.I),
   1 / 2 + ((δ : ℂ) - (γ : ℂ) * Complex.I),
   1 / 2 - ((δ : ℂ) - (γ : ℂ) * Complex.I)}

noncomputable def zeroSideSumM (s : Multiset ℂ) (c σ : ℝ) : ℂ :=
  (s.map (gaussianZeroTest c σ)).sum

theorem zeroSideSumM_add (q t : Multiset ℂ) (c σ : ℝ) :
    zeroSideSumM (q + t) c σ = zeroSideSumM q c σ + zeroSideSumM t c σ := by
  simp [zeroSideSumM, Multiset.map_add, Multiset.sum_add]

theorem zeroSideSumM_offLineQuadruple (c σ δ γ : ℝ) :
    zeroSideSumM (offLineQuadruple δ γ) c σ = offLineQuad c σ δ γ := by
  simp [zeroSideSumM, offLineQuadruple, offLineQuad]
  ring

noncomputable def zeroSideBlockM (s : Multiset ℂ) (σ : ℝ) (a : Fin 2 → ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  fun i j => (zeroSideSumM s (a i - a j) σ).re

theorem zeroSideBlockM_add (q t : Multiset ℂ) (σ : ℝ) (a : Fin 2 → ℝ) :
    zeroSideBlockM (q + t) σ a = zeroSideBlockM q σ a + zeroSideBlockM t σ a := by
  ext i j
  simp [zeroSideBlockM, zeroSideSumM_add, Complex.add_re]

theorem zeroSideBlockM_offLineQuadruple (σ δ γ c : ℝ) :
    zeroSideBlockM (offLineQuadruple δ γ) σ ![0, c] = OffLineBlock c σ δ γ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [zeroSideBlockM, OffLineBlock, zeroSideSumM_offLineQuadruple, offLineQuad_neg_c]

/-- **Multiset full-block failure.**  If the remaining-zero block is uniformly
bounded by `B` at every separation, the decomposed full block fails PSD. -/
theorem exists_multiset_fullBlock_not_psd (t : Multiset ℂ) (σ δ γ B : ℝ)
    (hσ : 0 < σ) (hδ : δ ≠ 0) (hB : 0 ≤ B)
    (ht : ∀ (c : ℝ) (i j : Fin 2), |zeroSideBlockM t σ ![0, c] i j| ≤ B) :
    ∃ c : ℝ, ¬ (zeroSideBlockM (offLineQuadruple δ γ + t) σ ![0, c]).PosSemidef := by
  obtain ⟨c, hc⟩ := exists_abs_offLineQuad_gt_any σ δ γ
    ((offLineQuad 0 σ δ γ).re + 4 * B) hσ hδ
  refine ⟨c, ?_⟩
  rw [zeroSideBlockM_add, zeroSideBlockM_offLineQuadruple]
  exact not_posSemidef_add_of_abs_gt _ _ B hB (fun i j => ht c i j) hc

lemma exp_add_real_mul_I (x y : ℝ) :
    Complex.exp ((x : ℂ) + (y : ℂ) * Complex.I)
      = (Real.exp x : ℂ) * (Real.cos y + Real.sin y * Complex.I) := by
  rw [Complex.exp_add, ← Complex.ofReal_exp, Complex.exp_ofReal_mul_I]

theorem gaussianZeroTest_onLine_re (c σ γ : ℝ) :
    (gaussianZeroTest c σ (1 / 2 + (γ : ℂ) * Complex.I)).re
      = 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * Real.cos (c * γ) := by
  unfold gaussianZeroTest
  have harg : (1 / 2 + (γ : ℂ) * Complex.I - 1 / 2) = (γ : ℂ) * Complex.I := by ring
  rw [harg, mul_assoc]
  rw [← Complex.exp_add]
  have hsq : ((γ : ℂ) * Complex.I) ^ 2 = (((-(γ ^ 2)) : ℝ) : ℂ) := by
    rw [mul_pow, Complex.I_sq]
    push_cast
    ring
  have hz : ((↑(σ ^ 2) : ℂ) * ((γ : ℂ) * Complex.I) ^ 2
        + (-(c : ℂ)) * ((γ : ℂ) * Complex.I))
      = (((-(σ ^ 2 * γ ^ 2)) : ℝ) : ℂ) + (((-(c * γ)) : ℝ) : ℂ) * Complex.I := by
    rw [hsq]
    push_cast
    ring
  rw [hz, exp_add_real_mul_I]
  simp only [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
    Complex.exp_ofReal_re, Complex.exp_ofReal_im,
    Complex.cos_ofReal_re, Complex.cos_ofReal_im,
    Complex.sin_ofReal_re, Complex.sin_ofReal_im,
    mul_zero, mul_one, add_zero, zero_add, sub_zero, neg_zero, Real.cos_neg]
  ring

theorem gaussianZeroTest_onLine_im (c σ γ : ℝ) :
    (gaussianZeroTest c σ (1 / 2 + (γ : ℂ) * Complex.I)).im
      = -(2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * Real.sin (c * γ)) := by
  unfold gaussianZeroTest
  have harg : (1 / 2 + (γ : ℂ) * Complex.I - 1 / 2) = (γ : ℂ) * Complex.I := by ring
  rw [harg, mul_assoc]
  rw [← Complex.exp_add]
  have hsq : ((γ : ℂ) * Complex.I) ^ 2 = (((-(γ ^ 2)) : ℝ) : ℂ) := by
    rw [mul_pow, Complex.I_sq]
    push_cast
    ring
  have hz : ((↑(σ ^ 2) : ℂ) * ((γ : ℂ) * Complex.I) ^ 2
        + (-(c : ℂ)) * ((γ : ℂ) * Complex.I))
      = (((-(σ ^ 2 * γ ^ 2)) : ℝ) : ℂ) + (((-(c * γ)) : ℝ) : ℂ) * Complex.I := by
    rw [hsq]
    push_cast
    ring
  rw [hz, exp_add_real_mul_I]
  simp only [Complex.mul_im, Complex.mul_re, Complex.add_re, Complex.add_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
    Complex.exp_ofReal_re, Complex.exp_ofReal_im,
    Complex.cos_ofReal_re, Complex.cos_ofReal_im,
    Complex.sin_ofReal_re, Complex.sin_ofReal_im,
    mul_zero, mul_one, add_zero, zero_add, sub_zero, neg_zero, Real.sin_neg]
  ring

noncomputable def onLineOrds (γs : ℕ → ℝ) (N : ℕ) : Multiset ℂ :=
  (Finset.range N).val.map (fun n => 1 / 2 + (γs n : ℂ) * Complex.I)

theorem zeroSideSumM_onLineOrds (γs : ℕ → ℝ) (N : ℕ) (c σ : ℝ) :
    (zeroSideSumM (onLineOrds γs N) c σ).re
      = ∑ n ∈ Finset.range N,
          2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γs n) ^ 2)) * Real.cos (c * γs n) := by
  unfold zeroSideSumM onLineOrds
  rw [Multiset.map_map]
  simp only [Function.comp_apply]
  rw [Finset.sum_map_val, Complex.re_sum]
  apply Finset.sum_congr rfl
  intro n _
  exact gaussianZeroTest_onLine_re c σ (γs n)

theorem abs_zeroSideBlockM_onLineOrds_le (γs : ℕ → ℝ) (N : ℕ) (σ c : ℝ) :
    ∀ i j : Fin 2,
      |zeroSideBlockM (onLineOrds γs N) σ ![0, c] i j|
        ≤ ∑ n ∈ Finset.range N,
            2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γs n) ^ 2)) := by
  intro i j
  rw [zeroSideBlockM]
  rw [zeroSideSumM_onLineOrds]
  exact abs_sum_mul_cos_le (fun n _ => by positivity)

/-- **Finite on-line tail plus one off-line quadruple fails PSD.**  For any
finite on-line ordinate multiset, the decomposed full block is not positive
semidefinite. -/
theorem exists_onLineMultiset_fullBlock_not_psd (γs : ℕ → ℝ) (N : ℕ)
    (σ δ γ₀ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ,
      ¬ (zeroSideBlockM (offLineQuadruple δ γ₀ + onLineOrds γs N) σ ![0, c]).PosSemidef := by
  refine exists_multiset_fullBlock_not_psd (onLineOrds γs N) σ δ γ₀
    (∑ n ∈ Finset.range N,
      2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γs n) ^ 2)))
    hσ hδ ?_ (fun c i j => abs_zeroSideBlockM_onLineOrds_le γs N σ c i j)
  exact Finset.sum_nonneg (fun n _ => by positivity)

theorem norm_gaussianZeroTest_onLine (c σ γ : ℝ) :
    ‖gaussianZeroTest c σ (1 / 2 + (γ : ℂ) * Complex.I)‖
      = 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) := by
  have hre := gaussianZeroTest_onLine_re c σ γ
  have him := gaussianZeroTest_onLine_im c σ γ
  have hsq : Complex.normSq (gaussianZeroTest c σ (1 / 2 + (γ : ℂ) * Complex.I))
      = (2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2))) ^ 2 := by
    rw [Complex.normSq_apply, hre, him]
    have htrig : Real.cos (c * γ) ^ 2 + Real.sin (c * γ) ^ 2 = 1 := Real.cos_sq_add_sin_sq _
    nlinarith [htrig]
  have hnonneg : 0 ≤ 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) := by positivity
  have hnorm := Complex.sq_norm (gaussianZeroTest c σ (1 / 2 + (γ : ℂ) * Complex.I))
  rw [hsq] at hnorm
  exact (sq_eq_sq₀ (norm_nonneg _) hnonneg).mp hnorm





open AbsoluteHodgeExplicitFormula WeilPositivity

theorem summable_gaussianZeroTest_onLine (γs : ℕ → ℝ) (c σ : ℝ)
    (h : ZeroTailSummable γs σ) :
    Summable (fun n : ℕ => gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I)) := by
  apply Summable.of_norm_bounded (h.mul_left (2 * Real.pi * σ ^ 2))
  intro n
  rw [norm_gaussianZeroTest_onLine]

/-- **Partial sums of the on-line `gaussianZeroTest` converge.**  This is the
`hsum` ingredient for the library's explicit-formula assembly. -/
theorem tendsto_sum_gaussianZeroTest_onLine (γs : ℕ → ℝ) (c σ : ℝ)
    (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ) :
    Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N,
        gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I)) atTop
      (nhds (∑' n : ℕ, gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I))) :=
  (summable_gaussianZeroTest_onLine γs c σ h).hasSum.tendsto_sum_nat

/-- **The `hsum` hypothesis from an enumeration prefix.**  The image of the
first `⌊T⌋₊` ordinates converges to the full zero-side `tsum`. -/
theorem tendsto_image_range_gaussianZeroTest (γs : ℕ → ℝ) (hinj : Function.Injective γs)
    (c σ : ℝ) (h : ZeroTailSummable γs σ) :
    Tendsto (fun T : ℝ => ∑ ρ ∈ (Finset.range ⌊T⌋₊).image
        (fun n => 1 / 2 + (γs n : ℂ) * Complex.I), gaussianZeroTest c σ ρ) atTop
      (nhds (∑' n : ℕ, gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I))) := by
  have hsum := tendsto_sum_gaussianZeroTest_onLine γs c σ h
  have himage : ∀ T : ℝ,
      (∑ ρ ∈ (Finset.range ⌊T⌋₊).image (fun n => 1 / 2 + (γs n : ℂ) * Complex.I),
        gaussianZeroTest c σ ρ)
        = ∑ n ∈ Finset.range ⌊T⌋₊,
            gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I) := by
    intro T
    rw [Finset.sum_image]
    intro x _ y _ hxy
    apply hinj
    have him := congrArg Complex.im hxy
    simpa using him
  simp_rw [himage]
  exact hsum.comp tendsto_nat_floor_atTop

/-- The same convergence with the pole terms subtracted. -/
theorem tendsto_sum_image_range_sub (γs : ℕ → ℝ) (hinj : Function.Injective γs)
    (c σ : ℝ) (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ) (g0 g1 : ℂ) :
    Tendsto (fun T : ℝ => (∑ ρ ∈ (Finset.range ⌊T⌋₊).image
        (fun n => 1 / 2 + (γs n : ℂ) * Complex.I), gaussianZeroTest c σ ρ) - g0 - g1) atTop
      (nhds ((∑' n : ℕ, gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I)) - g0 - g1)) := by
  exact (tendsto_image_range_gaussianZeroTest γs hinj c σ h).sub tendsto_const_nhds |>.sub
    tendsto_const_nhds

/-- The total on-line norm mass is `2πσ²` times the Gaussian zero mass. -/
theorem tsum_norm_gaussianZeroTest_onLine (γs : ℕ → ℝ) (c σ : ℝ)
    (h : AbsoluteHodgeExplicitFormula.ZeroTailSummable γs σ) :
    ∑' n : ℕ, ‖gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I)‖
      = 2 * Real.pi * σ ^ 2 * ∑' n : ℕ, Real.exp (-(σ ^ 2 * (γs n) ^ 2)) := by
  rw [show (∑' n : ℕ, ‖gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I)‖)
      = ∑' n : ℕ, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * (γs n) ^ 2)) from
    tsum_congr (fun n => norm_gaussianZeroTest_onLine c σ (γs n))]
  rw [tsum_mul_left]

/-- **Gaussian explicit formula from the zero enumeration.**  Instantiating the
library assembly with the enumeration prefix and the T43 `hsum`. -/
theorem explicit_formula_gaussianZeroTest_of_enumeration
    (c σ : ℝ) (hσ : 0 < σ) (γs : ℕ → ℝ) (hinj : Function.Injective γs)
    (h : ZeroTailSummable γs σ) (ArchR PrimeR ArchL PrimeL : ℂ)
    (hcontour : ∀ T : ℝ,
      rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) (-1) 2 (-T) T =
        ((∑ ρ ∈ (Finset.range ⌊T⌋₊).image (fun n => 1 / 2 + (γs n : ℂ) * Complex.I),
            gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
          (2 * (Real.pi : ℂ) * Complex.I))
    (hbottom : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (-T : ℝ) * I))
      atTop (nhds 0))
    (htop : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (T : ℝ) * I))
      atTop (nhds 0))
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) * gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds (- ArchR - PrimeR)))
    (hleft : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + (y : ℂ) * I) * gaussianZeroTest c σ (((-1 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds (ArchL + PrimeL))) :
    ((∑' n : ℕ, gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I))
        - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) * (2 * (Real.pi : ℂ) * Complex.I)
      = Complex.I * (- ArchR - PrimeR) - Complex.I * (ArchL + PrimeL) := by
  simpa using explicit_formula_gaussianZeroTest_arch_prime c σ hσ
    (fun T => (Finset.range ⌊T⌋₊).image (fun n => 1 / 2 + (γs n : ℂ) * Complex.I))
    (∑' n : ℕ, gaussianZeroTest c σ (1 / 2 + (γs n : ℂ) * Complex.I))
    ArchR PrimeR ArchL PrimeL hcontour
    (by simpa using hbottom) (by simpa using htop)
    (by simpa using hright) (by simpa using hleft)
    (tendsto_sum_image_range_sub γs hinj c σ h _ _)

/-- **Bottom-line square identity.**  The square of `(x − iT) − 1/2`, expanded
into real and imaginary parts. -/
theorem bottomLine_sq (x T : ℝ) :
    (((x : ℂ) - (T : ℂ) * Complex.I - 1 / 2) ^ 2)
      = ((((x - 1 / 2) ^ 2 - T ^ 2) : ℝ) : ℂ)
        + ((-(2 * (x - 1 / 2) * T)) : ℝ) * Complex.I := by
  push_cast
  ring_nf
  rw [Complex.I_sq]
  ring

/-- **Bottom-line Gaussian norm.**  On the line `x − iT` the test function has
norm `2πσ² e^{σ²((x−1/2)²−T²)} e^{−c(x−1/2)}`. -/
theorem norm_gaussianZeroTest_bottom (c σ x T : ℝ) :
    ‖gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I)‖
      = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2))
          * Real.exp (-c * (x - 1 / 2)) := by
  unfold gaussianZeroTest
  rw [norm_mul, norm_mul]
  have h1 : ‖(((2 * Real.pi * σ ^ 2 : ℝ)) : ℂ)‖ = 2 * Real.pi * σ ^ 2 := by
    rw [Complex.norm_real, Real.norm_of_nonneg (by positivity)]
  have h2 : ‖Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (((x : ℂ) - (T : ℂ) * Complex.I) - 1 / 2) ^ 2)‖
      = Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) := by
    rw [Complex.norm_exp]
    rw [show (((x : ℂ) - (T : ℂ) * Complex.I) - 1 / 2) = ((x : ℂ) - (T : ℂ) * Complex.I - 1 / 2) by ring]
    rw [bottomLine_sq, Complex.re_ofReal_mul]
    simp only [Complex.add_re, Complex.ofReal_re, Complex.ofReal_im, Complex.mul_re,
      Complex.I_re, Complex.I_im, mul_zero, add_zero, sub_zero]
    ring
  have h3 : ‖Complex.exp ((-(c : ℂ)) * (((x : ℂ) - (T : ℂ) * Complex.I) - 1 / 2))‖
      = Real.exp (-c * (x - 1 / 2)) := by
    rw [Complex.norm_exp]
    congr 1
    simp [Complex.mul_re, Complex.mul_im, Complex.sub_re, Complex.sub_im]
  rw [h1, h2, h3]

/-- **Uniform bottom-line bound on the contour.**  For `x ∈ [−1, 2]`, the
bottom-line test function is bounded by `2πσ² e^{σ²(25/4−T²)} e^{(3/2)|c|}`. -/
theorem norm_gaussianZeroTest_bottom_le (c σ x T : ℝ) (hx1 : -1 ≤ x) (hx2 : x ≤ 2) :
    ‖gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I)‖
      ≤ 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2))
          * Real.exp (|c| * (3 / 2)) := by
  rw [norm_gaussianZeroTest_bottom]
  have hsq : (x - 1 / 2) ^ 2 ≤ (5 / 2) ^ 2 := by nlinarith
  have habs : |x - 1 / 2| ≤ 3 / 2 := by
    rw [abs_le]
    constructor <;> linarith
  have hσ2 : 0 ≤ σ ^ 2 := sq_nonneg σ
  have hexp1 : Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2))
      ≤ Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2)) := by
    apply Real.exp_le_exp.mpr
    nlinarith
  have hexp2 : Real.exp (-c * (x - 1 / 2)) ≤ Real.exp (|c| * (3 / 2)) := by
    apply Real.exp_le_exp.mpr
    calc -c * (x - 1 / 2) = -(c * (x - 1 / 2)) := by ring
      _ ≤ |c * (x - 1 / 2)| := neg_le_abs _
      _ = |c| * |x - 1 / 2| := by rw [abs_mul]
      _ ≤ |c| * (3 / 2) := by
          apply mul_le_mul_of_nonneg_left habs (abs_nonneg c)
  have hC : 0 ≤ 2 * Real.pi * σ ^ 2 := by positivity
  calc 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2))
        * Real.exp (-c * (x - 1 / 2))
      ≤ 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2))
        * Real.exp (|c| * (3 / 2)) := by
        gcongr

/-- The named **horizontal-line `logDeriv` growth input** on the contour
`x ∈ [−1, 2]`. -/
def HorizontalLogDerivBound (C : ℝ) (k : ℕ) : Prop :=
  ∀ (x T : ℝ), -1 ≤ x → x ≤ 2 →
    ‖logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)‖ ≤ C * (1 + |T|) ^ k

/-- The defining property of `HorizontalLogDerivBound`. -/
theorem horizontalLogDerivBound_apply {C : ℝ} {k : ℕ}
    (h : HorizontalLogDerivBound C k) {x T : ℝ} (hx1 : -1 ≤ x) (hx2 : x ≤ 2) :
    ‖logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)‖ ≤ C * (1 + |T|) ^ k :=
  h x T hx1 hx2

/-- **Polynomial times Gaussian decay.**  `|T|^k e^{−σ²T²} → 0`. -/
theorem tendsto_abs_pow_mul_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) (k : ℕ) :
    Tendsto (fun T : ℝ => |T| ^ (k : ℝ) * Real.exp (-(σ ^ 2) * T ^ 2)) atTop (nhds 0) := by
  have h := tendsto_rpow_abs_mul_exp_neg_mul_sq_cocompact (a := σ ^ 2) (by positivity) (k : ℝ)
  exact h.mono_left atTop_le_cocompact





open Filter Topology

theorem tendsto_one_add_abs_pow_mul_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) (k : ℕ) :
    Tendsto (fun T : ℝ => (1 + |T|) ^ k * Real.exp (-(σ ^ 2) * T ^ 2)) atTop (nhds 0) := by
  have hk := tendsto_abs_pow_mul_exp_neg_sq σ hσ k
  have h0 : Tendsto (fun T : ℝ => Real.exp (-(σ ^ 2) * T ^ 2)) atTop (nhds 0) := by
    simpa using tendsto_abs_pow_mul_exp_neg_sq σ hσ 0
  have hsum : Tendsto (fun T : ℝ =>
      Real.exp (-(σ ^ 2) * T ^ 2) + |T| ^ (k : ℝ) * Real.exp (-(σ ^ 2) * T ^ 2)) atTop (nhds 0) := by
    simpa using h0.add hk
  have hbig : Tendsto (fun T : ℝ =>
      2 ^ k * (Real.exp (-(σ ^ 2) * T ^ 2) + |T| ^ (k : ℝ) * Real.exp (-(σ ^ 2) * T ^ 2))) atTop (nhds 0) := by
    simpa using hsum.const_mul (2 ^ k : ℝ)
  apply squeeze_zero (fun T => by positivity) _ hbig
  intro T
  have hT : 0 ≤ |T| := abs_nonneg T
  have h1 : (1 + |T|) ^ k ≤ 2 ^ k * (1 + |T| ^ k) := by
    rcases Nat.eq_zero_or_pos k with hk0 | hkpos
    · subst hk0; norm_num
    · have h := add_pow_le (show (0:ℝ) ≤ 1 by norm_num) hT (n := k)
      have hstep : (1 + |T|) ^ k ≤ 2 ^ (k - 1) * (1 + |T| ^ k) := by
        simpa [one_pow] using h
      have hpow : (2 : ℝ) ^ (k - 1) ≤ 2 ^ k := pow_le_pow_right₀ (by norm_num) (Nat.sub_le k 1)
      exact hstep.trans (mul_le_mul_of_nonneg_right hpow (by positivity))
  calc (1 + |T|) ^ k * Real.exp (-(σ ^ 2) * T ^ 2)
      ≤ (2 ^ k * (1 + |T| ^ k)) * Real.exp (-(σ ^ 2) * T ^ 2) :=
        mul_le_mul_of_nonneg_right h1 (by positivity)
    _ = 2 ^ k * (Real.exp (-(σ ^ 2) * T ^ 2) + |T| ^ (k : ℝ) * Real.exp (-(σ ^ 2) * T ^ 2)) := by
        rw [Real.rpow_natCast]
        ring

/-- **The bottom contour integral vanishes.**  Under the named horizontal
`logDeriv` growth bound, the bottom edge of the Gaussian explicit formula tends
to zero. -/
theorem tendsto_bottom_integral_zero (c σ C : ℝ) (k : ℕ) (hσ : 0 < σ) (hC : 0 ≤ C)
    (hbound : HorizontalLogDerivBound C k) :
    Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
        logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I))
      atTop (nhds 0) := by
  set K : ℝ → ℝ := fun T => C * (1 + |T|) ^ k
      * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (|c| * (3 / 2)))
      * Real.exp (-(σ ^ 2) * T ^ 2) with hK
  have hKtend : Tendsto K atTop (nhds 0) := by
    have := (tendsto_one_add_abs_pow_mul_exp_neg_sq σ hσ k).const_mul
      (C * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (|c| * (3 / 2))))
    simpa [K, mul_assoc, mul_comm, mul_left_comm] using this
  have hnorm : ∀ᶠ T : ℝ in atTop, ∀ x ∈ Set.uIoc (-1 : ℝ) 2,
      ‖logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I)‖ ≤ K T := by
    filter_upwards with T
    intro x hx
    have hx1 : -1 ≤ x := by
      rw [Set.uIoc_of_le (by norm_num : (-1:ℝ) ≤ 2)] at hx; exact le_of_lt hx.1
    have hx2 : x ≤ 2 := by
      rw [Set.uIoc_of_le (by norm_num : (-1:ℝ) ≤ 2)] at hx; exact hx.2
    have h1 := hbound x T hx1 hx2
    have h2 := norm_gaussianZeroTest_bottom_le c σ x T hx1 hx2
    rw [norm_mul]
    have hexp : Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2))
        = Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (-(σ ^ 2) * T ^ 2) := by
      rw [← Real.exp_add]
      congr 1
      ring
    rw [hexp] at h2
    calc ‖logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)‖
          * ‖gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I)‖
        ≤ (C * (1 + |T|) ^ k)
          * (2 * Real.pi * σ ^ 2 * (Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (-(σ ^ 2) * T ^ 2))
              * Real.exp (|c| * (3 / 2))) := by
          exact mul_le_mul h1 h2 (norm_nonneg _) (by positivity)
      _ = K T := by ring
  have hbound_int : ∀ᶠ T : ℝ in atTop,
      ‖∫ x : ℝ in (-1)..2, logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I)‖ ≤ K T * 3 := by
    filter_upwards [hnorm] with T hT
    calc ‖∫ x : ℝ in (-1)..2, logDeriv completedZeta ((x : ℂ) - (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) - (T : ℂ) * Complex.I)‖
        ≤ K T * |2 - (-1)| := intervalIntegral.norm_integral_le_of_norm_le_const hT
      _ = K T * 3 := by norm_num
  exact squeeze_zero_norm' hbound_int (by simpa [mul_comm] using hKtend.const_mul 3)

/-- **Top-line square identity and norm.**  The top line `x+iT` has the same
Gaussian norm as the bottom line. -/
theorem topLine_sq (x T : ℝ) :
    (((x : ℂ) + (T : ℂ) * Complex.I - 1 / 2) ^ 2)
      = ((((x - 1 / 2) ^ 2 - T ^ 2) : ℝ) : ℂ)
        + ((2 * (x - 1 / 2) * T : ℝ) : ℂ) * Complex.I := by
  push_cast
  ring_nf
  rw [Complex.I_sq]
  ring

theorem norm_gaussianZeroTest_top (c σ x T : ℝ) :
    ‖gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I)‖
      = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2))
          * Real.exp (-c * (x - 1 / 2)) := by
  have hsq := topLine_sq x T
  unfold gaussianZeroTest
  rw [norm_mul, norm_mul]
  have h1 : ‖(((2 * Real.pi * σ ^ 2 : ℝ)) : ℂ)‖ = 2 * Real.pi * σ ^ 2 := by
    rw [Complex.norm_real, Real.norm_of_nonneg (by positivity)]
  have h2 : ‖Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (((x : ℂ) + (T : ℂ) * Complex.I) - 1 / 2) ^ 2)‖
      = Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) := by
    rw [Complex.norm_exp]
    rw [show (((x : ℂ) + (T : ℂ) * Complex.I) - 1 / 2) = ((x : ℂ) + (T : ℂ) * Complex.I - 1 / 2) by ring]
    rw [hsq, Complex.re_ofReal_mul]
    simp only [Complex.add_re, Complex.ofReal_re, Complex.ofReal_im, Complex.mul_re,
      Complex.I_re, Complex.I_im, mul_zero, add_zero, sub_zero]
    ring
  have h3 : ‖Complex.exp ((-(c : ℂ)) * (((x : ℂ) + (T : ℂ) * Complex.I) - 1 / 2))‖
      = Real.exp (-c * (x - 1 / 2)) := by
    rw [Complex.norm_exp]
    congr 1
    simp [Complex.mul_re, Complex.mul_im, Complex.sub_re, Complex.sub_im]
  rw [h1, h2, h3]

/-- **Uniform top-line bound on the contour.** -/
theorem norm_gaussianZeroTest_top_le (c σ x T : ℝ) (hx1 : -1 ≤ x) (hx2 : x ≤ 2) :
    ‖gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I)‖
      ≤ 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2))
          * Real.exp (|c| * (3 / 2)) := by
  rw [norm_gaussianZeroTest_top]
  have hsq : (x - 1 / 2) ^ 2 ≤ (5 / 2) ^ 2 := by nlinarith
  have habs : |x - 1 / 2| ≤ 3 / 2 := by
    rw [abs_le]; constructor <;> linarith
  have hexp1 : Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2))
      ≤ Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2)) := by
    apply Real.exp_le_exp.mpr
    nlinarith
  have hexp2 : Real.exp (-c * (x - 1 / 2)) ≤ Real.exp (|c| * (3 / 2)) := by
    apply Real.exp_le_exp.mpr
    calc -c * (x - 1 / 2) = -(c * (x - 1 / 2)) := by ring
      _ ≤ |c * (x - 1 / 2)| := neg_le_abs _
      _ = |c| * |x - 1 / 2| := by rw [abs_mul]
      _ ≤ |c| * (3 / 2) := mul_le_mul_of_nonneg_left habs (abs_nonneg c)
  have hC : 0 ≤ 2 * Real.pi * σ ^ 2 := by positivity
  calc 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2))
        * Real.exp (-c * (x - 1 / 2))
      ≤ 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2))
        * Real.exp (|c| * (3 / 2)) := by gcongr

/-- The named **top-line `logDeriv` growth input** on the contour. -/
def HorizontalLogDerivBoundTop (C : ℝ) (k : ℕ) : Prop :=
  ∀ (x T : ℝ), -1 ≤ x → x ≤ 2 →
    ‖logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)‖ ≤ C * (1 + |T|) ^ k

/-- **The top contour integral vanishes.**  Under the named horizontal
`logDeriv` growth bound, the top edge of the Gaussian explicit formula tends to
zero. -/
theorem tendsto_top_integral_zero (c σ C : ℝ) (k : ℕ) (hσ : 0 < σ) (hC : 0 ≤ C)
    (hbound : HorizontalLogDerivBoundTop C k) :
    Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
        logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I))
      atTop (nhds 0) := by
  set K : ℝ → ℝ := fun T => C * (1 + |T|) ^ k
      * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (|c| * (3 / 2)))
      * Real.exp (-(σ ^ 2) * T ^ 2) with hK
  have hKtend : Tendsto K atTop (nhds 0) := by
    have := (tendsto_one_add_abs_pow_mul_exp_neg_sq σ hσ k).const_mul
      (C * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (|c| * (3 / 2))))
    simpa [K, mul_assoc, mul_comm, mul_left_comm] using this
  have hnorm : ∀ᶠ T : ℝ in atTop, ∀ x ∈ Set.uIoc (-1 : ℝ) 2,
      ‖logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I)‖ ≤ K T := by
    filter_upwards with T
    intro x hx
    have hx1 : -1 ≤ x := by
      rw [Set.uIoc_of_le (by norm_num : (-1:ℝ) ≤ 2)] at hx; exact le_of_lt hx.1
    have hx2 : x ≤ 2 := by
      rw [Set.uIoc_of_le (by norm_num : (-1:ℝ) ≤ 2)] at hx; exact hx.2
    have h1 := hbound x T hx1 hx2
    have h2 := norm_gaussianZeroTest_top_le c σ x T hx1 hx2
    rw [norm_mul]
    have hexp : Real.exp (σ ^ 2 * ((5 / 2) ^ 2 - T ^ 2))
        = Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (-(σ ^ 2) * T ^ 2) := by
      rw [← Real.exp_add]
      congr 1
      ring
    rw [hexp] at h2
    calc ‖logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)‖
          * ‖gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I)‖
        ≤ (C * (1 + |T|) ^ k)
          * (2 * Real.pi * σ ^ 2 * (Real.exp (σ ^ 2 * (25 / 4)) * Real.exp (-(σ ^ 2) * T ^ 2))
              * Real.exp (|c| * (3 / 2))) := by
          exact mul_le_mul h1 h2 (norm_nonneg _) (by positivity)
      _ = K T := by ring
  have hbound_int : ∀ᶠ T : ℝ in atTop,
      ‖∫ x : ℝ in (-1)..2, logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I)‖ ≤ K T * 3 := by
    filter_upwards [hnorm] with T hT
    calc ‖∫ x : ℝ in (-1)..2, logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
          * gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * Complex.I)‖
        ≤ K T * |2 - (-1)| := intervalIntegral.norm_integral_le_of_norm_le_const hT
      _ = K T * 3 := by norm_num
  exact squeeze_zero_norm' hbound_int (by simpa [mul_comm] using hKtend.const_mul 3)

end WeilPositivity
