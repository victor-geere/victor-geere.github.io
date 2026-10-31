import Rectangle
import Archimedean
import Mathlib.Analysis.Fourier.Inversion

/-!
# Toward the explicit formula: the prime side

The zero side of the explicit formula is Lean-checked in `Rectangle.lean`
(`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`).  This file starts the
**prime side**: the von Mangoldt series `L_Λ(s) = ∑ Λ(n) n^{-s}`, which equals
`-ζ'/ζ(s)` for `Re s > 1`, is to be integrated term-by-term over a vertical
segment `Re s = c` with `c > 1`.

The lemmas here establish the prerequisites: the exact modulus of each term on
a vertical line, its continuity in the imaginary part, and the summability of
the majorant.  No RH proof yet.
-/

namespace AbsoluteHodgeExplicitFormula

open Complex Filter TopologicalSpace Set MeasureTheory AbsoluteHodgeSymbol AbsoluteHodgeRectangle
open scoped Topology Interval FourierTransform RealInnerProductSpace

/-- **Modulus of a vertical L-series term**: on the line `Re s = c`, the term
`n^{-(c+iy)}` has modulus `n^{-c}`. -/
theorem norm_natCast_cpow_vertical {n : ℕ} (hn : 1 ≤ n) (c y : ℝ) :
    ‖((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ)‖ = (n : ℝ) ^ (-c) := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos (by exact_mod_cast (show 0 < n by omega))]
  congr 1
  simp

/-- **Continuity of a vertical power** in the imaginary part. -/
theorem continuous_natCast_cpow_vertical (n : ℕ) (hn : 1 ≤ n) (c : ℝ) :
    Continuous (fun y : ℝ => ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ)) := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hane : ((n : ℝ) : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hnpos.ne'
  rw [continuous_iff_continuousAt]
  intro y
  have hpath : ContinuousAt (fun y : ℝ => (-(c + y * I) : ℂ)) y := by fun_prop
  exact ContinuousAt.comp (continuousAt_const_cpow (a := ((n : ℝ) : ℂ))
    (b := (-(c + y * I) : ℂ)) hane) hpath

/-- **Continuity of an L-series term on a vertical line.** -/
theorem continuous_lseriesTerm (f : ℕ → ℂ) (c : ℝ) (n : ℕ) :
    Continuous (fun y : ℝ => LSeries.term f (c + y * I) n) := by
  by_cases hn : n = 0
  · have hzero : (fun y : ℝ => LSeries.term f (c + y * I) n) = fun _ => 0 := by
      funext y
      rw [LSeries.term_def, if_pos hn]
    rw [hzero]
    exact continuous_const
  · have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn
    have hfun : (fun y : ℝ => LSeries.term f (c + y * I) n)
        = (fun y : ℝ => f n * ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ)) := by
      funext y
      rw [LSeries.term_def, if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg,
        ← Complex.ofReal_natCast n]
    rw [hfun]
    exact continuous_const.mul (continuous_natCast_cpow_vertical n hn1 c)

/-- The von Mangoldt coefficients are nonnegative. -/
theorem vonMangoldt_nonneg (n : ℕ) : 0 ≤ (ArithmeticFunction.vonMangoldt n : ℝ) :=
  ArithmeticFunction.vonMangoldt_nonneg

/-- **Summability of the majorant** `Λ(n)·n^{-c}` for `c > 1`. -/
theorem summable_vonMangoldt_majorant {c : ℝ} (hc : 1 < c) :
    Summable (fun n : ℕ => ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (c : ℂ) n‖) := by
  have h := ArithmeticFunction.LSeriesSummable_vonMangoldt (s := (c : ℂ)) (by simpa using hc)
  exact h.norm


/-- **Term-by-term integration of the von Mangoldt series on a vertical
segment.**  For `c > 1` and any real `y₁, y₂`,
`∫_{y₁}^{y₂} L_Λ(c+iy) dy = ∑' n, ∫_{y₁}^{y₂} Λ(n) n^{-(c+iy)} dy`.
This is the interchange of sum and integral that the prime side of the
explicit formula needs. -/
theorem integral_lseries_vonMangoldt (c y1 y2 : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y1..y2,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I))
      = ∑' n : ℕ, ∫ y : ℝ in y1..y2,
          LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n := by
  let F : ℕ → C(ℝ, ℂ) := fun n =>
    ⟨fun y : ℝ => LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n,
      continuous_lseriesTerm _ c n⟩
  have hnorm : ∀ n : ℕ, ‖(F n).restrict (⟨uIcc y1 y2, isCompact_uIcc⟩ : Compacts ℝ)‖
      ≤ ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n‖ := by
    intro n
    rw [ContinuousMap.norm_le (f := (F n).restrict (⟨uIcc y1 y2, isCompact_uIcc⟩ : Compacts ℝ)) (norm_nonneg _)]
    intro x
    rw [ContinuousMap.restrict_apply]
    by_cases hn : n = 0
    · simp [F, LSeries.term_def, hn]
    · have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn
      have h1 : LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
            (c + (x : ℝ) * I) n
          = (ArithmeticFunction.vonMangoldt n : ℂ) * ((n : ℝ) : ℂ) ^ (-(c + (x : ℝ) * I) : ℂ) := by
        rw [LSeries.term_def, if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg,
          ← Complex.ofReal_natCast n]
      have h2 : LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n
          = (ArithmeticFunction.vonMangoldt n : ℂ) * ((n : ℝ) : ℂ) ^ (-(c : ℂ)) := by
        rw [LSeries.term_def, if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg,
          ← Complex.ofReal_natCast n]
      show ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (c + (x : ℝ) * I) n‖
        ≤ ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n‖
      rw [h1, h2, norm_mul, norm_mul,
        norm_natCast_cpow_vertical hn1 c (x : ℝ)]
      have h2norm : ‖((n : ℝ) : ℂ) ^ (-(c : ℂ))‖ = (n : ℝ) ^ (-c) := by
        simpa using norm_natCast_cpow_vertical hn1 c 0
      rw [h2norm]
  have hsum : Summable fun n : ℕ =>
      ‖(F n).restrict (⟨uIcc y1 y2, isCompact_uIcc⟩ : Compacts ℝ)‖ :=
    Summable.of_nonneg_of_le (fun n => norm_nonneg _) hnorm (summable_vonMangoldt_majorant hc)
  have h := intervalIntegral.tsum_intervalIntegral_eq_of_summable_norm
    (a := y1) (b := y2) (f := F) hsum
  change (∫ y : ℝ in y1..y2, ∑' n : ℕ, LSeries.term
      (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n)
    = ∑' n : ℕ, ∫ y : ℝ in y1..y2, LSeries.term
      (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n
  simpa only [F, ContinuousMap.coe_mk] using h.symm




/-- The vertical von Mangoldt term is bounded by its value at the real point. -/
theorem norm_lseriesTerm_vonMangoldt_le (c y : ℝ) (n : ℕ) :
    ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n‖
      ≤ ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n‖ := by
  by_cases hn : n = 0
  · simp [LSeries.term_def, hn]
  · have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn
    have h1 : LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (c + (y : ℝ) * I) n
        = (ArithmeticFunction.vonMangoldt n : ℂ) * ((n : ℝ) : ℂ) ^ (-(c + (y : ℝ) * I) : ℂ) := by
      rw [LSeries.term_def, if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg,
        ← Complex.ofReal_natCast n]
    have h2 : LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n
        = (ArithmeticFunction.vonMangoldt n : ℂ) * ((n : ℝ) : ℂ) ^ (-(c : ℂ)) := by
      rw [LSeries.term_def, if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg,
        ← Complex.ofReal_natCast n]
    rw [h1, h2, norm_mul, norm_mul, norm_natCast_cpow_vertical hn1 c y]
    have h2norm : ‖((n : ℝ) : ℂ) ^ (-(c : ℂ))‖ = (n : ℝ) ^ (-c) := by
      simpa using norm_natCast_cpow_vertical hn1 c 0
    rw [h2norm]

/-- **Termwise integration of the von Mangoldt series against a continuous
factor.**  For `h : ℝ → ℂ` continuous and `c > 1`,
`∫ L_Λ(c+iy)·h(y) dy = ∑_n ∫ term_n(c+iy)·h(y) dy`.  This is the prime side
of the test-function explicit formula (with `h(y) = H(c+iy)` for entire `H`). -/
theorem integral_lseries_vonMangoldt_mul (h : ℝ → ℂ) (c y1 y2 : ℝ) (hc : 1 < c)
    (hh : Continuous h) :
    (∫ y : ℝ in y1..y2,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) * h y)
      = ∑' n : ℕ, ∫ y : ℝ in y1..y2,
          LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n * h y := by
  let H : C(ℝ, ℂ) := ⟨h, hh⟩
  let K : Compacts ℝ := ⟨uIcc y1 y2, isCompact_uIcc⟩
  let M : ℝ := ‖H.restrict K‖
  have hMbound : ∀ y ∈ uIcc y1 y2, ‖h y‖ ≤ M := by
    have h := (ContinuousMap.norm_le (f := H.restrict K) (norm_nonneg _)).mp le_rfl
    intro y hy
    have := h ⟨y, hy⟩
    rw [ContinuousMap.restrict_apply] at this
    exact this
  let F : ℕ → C(ℝ, ℂ) := fun n =>
    ⟨fun y : ℝ => LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
        (c + y * I) n * h y, (continuous_lseriesTerm _ c n).mul hh⟩
  have hnorm : ∀ n : ℕ, ‖(F n).restrict K‖
      ≤ ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n‖ * M := by
    intro n
    rw [ContinuousMap.norm_le (f := (F n).restrict K)
      (mul_nonneg (norm_nonneg _) (norm_nonneg _))]
    intro x
    rw [ContinuousMap.restrict_apply]
    show ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + (x : ℝ) * I) n * h x‖
      ≤ ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n‖ * M
    rw [norm_mul]
    exact mul_le_mul (norm_lseriesTerm_vonMangoldt_le c (x : ℝ) n) (hMbound x x.2)
      (norm_nonneg _) (norm_nonneg _)
  have hsum0 : Summable fun n : ℕ =>
      ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c : ℂ) n‖ := by
    obtain ⟨a, ha⟩ := summable_vonMangoldt_majorant hc
    exact ha.summable
  have hsum : Summable fun n : ℕ => ‖(F n).restrict K‖ :=
    Summable.of_nonneg_of_le (fun n => norm_nonneg _) hnorm (hsum0.mul_right M)
  have hterm := intervalIntegral.tsum_intervalIntegral_eq_of_summable_norm
    (a := y1) (b := y2) (f := F) hsum
  have hpoint : ∀ y : ℝ, LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) * h y
      = ∑' n : ℕ, LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (c + y * I) n * h y := by
    intro y
    show (∑' n : ℕ, LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
        (c + y * I) n) * h y = _
    exact (tsum_mul_right (f := fun n => LSeries.term
      (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n) (a := h y)).symm
  rw [show (∫ y : ℝ in y1..y2, LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
        (c + y * I) * h y)
      = ∫ y : ℝ in y1..y2, ∑' n : ℕ, LSeries.term
          (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n * h y from by
    apply intervalIntegral.integral_congr
    intro y hy
    exact hpoint y]
  simpa only [F, ContinuousMap.coe_mk] using hterm.symm

/-- Derivative of a vertical power of a positive integer. -/
theorem hasDerivAt_natCast_cpow_vertical {n : ℕ} (hn : 2 ≤ n) (c : ℝ) (y : ℝ) :
    HasDerivAt (fun t : ℝ => ((n : ℝ) : ℂ) ^ (-(c + t * I) : ℂ))
      (((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ) * (Real.log n : ℂ) * (-I)) y := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hane : ((n : ℝ) : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hnpos.ne'
  have hpath : HasDerivAt (fun t : ℝ => (-(c + t * I) : ℂ)) (-I) y := by
    have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
      (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
    have h2 : HasDerivAt (fun t : ℝ => (c : ℂ) + (t : ℂ) * I) (1 * I) y :=
      h1.const_add ((c : ℂ))
    have h3 : HasDerivAt (fun t : ℝ => -((c : ℂ) + (t : ℂ) * I)) (-(1 * I)) y := h2.neg
    simpa using h3
  have hcp := (hasStrictDerivAt_const_cpow (x := ((n : ℝ) : ℂ))
    (y := (-(c + y * I) : ℂ)) (Or.inl hane)).hasDerivAt.scomp y hpath
  have hlog : Complex.log ((n : ℝ) : ℂ) = (Real.log n : ℂ) := by
    rw [Complex.ofReal_log hnpos.le]
  convert hcp using 1
  · rfl
  · rw [hlog, smul_eq_mul]
    ring

/-- **The vertical term integral in closed form**: for `n ≥ 2`,
`∫_{y₁}^{y₂} n^{-(c+iy)} dy = i(n^{-(c+iy₂)} - n^{-(c+iy₁)})/log n`. -/
theorem integral_natCast_cpow_vertical {n : ℕ} (hn : 2 ≤ n) (c y1 y2 : ℝ) :
    (∫ y : ℝ in y1..y2, ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ))
      = (I / (Real.log n : ℂ))
          * (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
              - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ)) := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hn1 : n ≠ 1 := by omega
  have hlogne : (Real.log n : ℂ) ≠ 0 := by
    have : Real.log (n : ℝ) ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hnpos (by exact_mod_cast hn1)
    exact_mod_cast this
  have hderiv : ∀ y ∈ uIcc y1 y2,
      HasDerivAt (fun t : ℝ => (I / (Real.log n : ℂ)) * ((n : ℝ) : ℂ) ^ (-(c + t * I) : ℂ))
        (((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ)) y := by
    intro y hy
    have h := (hasDerivAt_natCast_cpow_vertical hn c y).const_mul (I / (Real.log n : ℂ))
    convert h using 1
    · -- derivative equality
      have hII : I * (-I) = (1 : ℂ) := by
        rw [mul_neg, Complex.I_mul_I]
        norm_num
      rw [div_eq_mul_inv]
      symm
      calc I * (Real.log n : ℂ)⁻¹
            * (((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ) * (Real.log n : ℂ) * (-I))
          = (I * (-I)) * ((Real.log n : ℂ)⁻¹ * (Real.log n : ℂ))
              * ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ) := by ring
        _ = (1 : ℂ) * (1 : ℂ) * ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ) := by
              rw [hII, inv_mul_cancel₀ hlogne]
        _ = ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ) := by ring
  have hcont : ContinuousOn (fun y : ℝ => ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ)) (uIcc y1 y2) :=
    (continuous_natCast_cpow_vertical n (by omega) c).continuousOn
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable
  rw [h]
  ring


/-- **The integral of one von Mangoldt L-series term** on a vertical segment:
it vanishes for `n ≤ 1` and is `Λ(n)·i(n^{-(c+iy₂)} - n^{-(c+iy₁)})/log n`
otherwise. -/
theorem integral_lseriesTerm_vonMangoldt (n : ℕ) (c y1 y2 : ℝ) :
    (∫ y : ℝ in y1..y2,
        LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n)
      = if n ≤ 1 then 0 else
          (ArithmeticFunction.vonMangoldt n : ℂ) *
            ((I / (Real.log n : ℂ)) *
              (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
                - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ))) := by
  by_cases hn : n ≤ 1
  · have hzero : (fun y : ℝ =>
        LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n)
        = fun _ => 0 := by
      funext y
      interval_cases n
      · rw [LSeries.term_def, if_pos rfl]
      · rw [LSeries.term_def, if_neg (by norm_num : (1 : ℕ) ≠ 0),
          ArithmeticFunction.vonMangoldt_apply_one]
        simp
    rw [hzero, if_pos hn]
    simp
  · have hn2 : 2 ≤ n := by omega
    have hterm : (fun y : ℝ =>
        LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n)
        = fun y : ℝ => (ArithmeticFunction.vonMangoldt n : ℂ) * ((n : ℝ) : ℂ) ^ (-(c + y * I) : ℂ) := by
      funext y
      rw [LSeries.term_def, if_neg (by omega : n ≠ 0), div_eq_mul_inv, ← Complex.cpow_neg,
        ← Complex.ofReal_natCast n]
    rw [hterm, if_neg hn, intervalIntegral.integral_const_mul,
      integral_natCast_cpow_vertical hn2 c y1 y2]

/-- **Prime side, closed form.**  For `c > 1`, the vertical integral of the von
Mangoldt series is the sum of the closed-form term integrals. -/
theorem integral_lseries_vonMangoldt_closed (c y1 y2 : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y1..y2,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I))
      = ∑' n : ℕ, if n ≤ 1 then 0 else
          (ArithmeticFunction.vonMangoldt n : ℂ) *
            ((I / (Real.log n : ℂ)) *
              (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
                - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ))) := by
  rw [integral_lseries_vonMangoldt c y1 y2 hc]
  exact tsum_congr fun n => integral_lseriesTerm_vonMangoldt n c y1 y2


/-! ### The right vertical side of the contour

On `Re s = c > 1` the symbol identity rewrites the archimedean symbol as
`Z'/Z + L_Λ`.  Integrating over a vertical segment and using the closed-form
prime side gives the right-side contribution, conditional on the interval
integrability of the two pieces. -/

/-- **The right vertical side of the explicit formula.**  For `c > 1`, if the
log-derivative and the von Mangoldt series are interval-integrable on the
segment, then
`∫_{y₁}^{y₂} (Z'/Z)(c+iy)·i dy = i·(∫_{y₁}^{y₂} arch(c+iy) dy − Σ' term_n)`,
where `arch(s) = (1/2)ψ(s/2) − (1/2)log π`. -/
theorem integral_logDeriv_completedZeta_right_side (c y1 y2 : ℝ) (hc : 1 < c)
    (hLD : IntervalIntegrable (fun y : ℝ => logDeriv completedZeta (c + y * I)) volume y1 y2)
    (hL : IntervalIntegrable
      (fun y : ℝ => LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I))
      volume y1 y2) :
    (∫ y : ℝ in y1..y2, logDeriv completedZeta (c + y * I) * I)
      = ((∫ y : ℝ in y1..y2,
            ((1 / 2) * Complex.digamma ((c + y * I) / 2) - (1 / 2) * log (Real.pi : ℂ)))
          - (∑' n : ℕ, if n ≤ 1 then 0 else
              (ArithmeticFunction.vonMangoldt n : ℂ) *
                ((I / (Real.log n : ℂ)) *
                  (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
                    - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ))))) * I := by
  -- pointwise: arch = logDeriv Z + L on Re s > 1
  have hcongr : ∀ y ∈ uIcc y1 y2,
      ((1 / 2) * Complex.digamma ((c + y * I) / 2) - (1 / 2) * log (Real.pi : ℂ))
        = logDeriv completedZeta (c + y * I)
          + LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) := by
    intro y hy
    have hs : 1 < (c + y * I).re := by simp; linarith
    have hsym := AbsoluteHodgeSymbol.symbol_identity hs
    linear_combination -hsym
  have harch_int : (∫ y : ℝ in y1..y2,
      ((1 / 2) * Complex.digamma ((c + y * I) / 2) - (1 / 2) * log (Real.pi : ℂ)))
      = (∫ y : ℝ in y1..y2, logDeriv completedZeta (c + y * I))
        + (∑' n : ℕ, if n ≤ 1 then 0 else
            (ArithmeticFunction.vonMangoldt n : ℂ) *
              ((I / (Real.log n : ℂ)) *
                (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
                  - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ)))) := by
    rw [intervalIntegral.integral_congr hcongr]
    have hsplit : (∫ y : ℝ in y1..y2,
        (fun z : ℝ => logDeriv completedZeta (c + z * I)
          + LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + z * I)) y)
        = (∫ y : ℝ in y1..y2, logDeriv completedZeta (c + y * I))
          + (∫ y : ℝ in y1..y2,
              LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)) :=
      intervalIntegral.integral_add hLD hL
    rw [hsplit]
    rw [integral_lseries_vonMangoldt_closed c y1 y2 hc]
  rw [intervalIntegral.integral_mul_const, harch_int]
  ring


/-! ### Discharging the integrability hypotheses -/

/-- Continuity of the von Mangoldt series on a vertical line with `Re s > 1`. -/
theorem continuousOn_lseries_vonMangoldt (c y1 y2 : ℝ) (hc : 1 < c) :
    ContinuousOn (fun y : ℝ =>
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)) (uIcc y1 y2) := by
  have hc' : 1 < (1 + c) / 2 := by linarith
  have habs : LSeries.abscissaOfAbsConv (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      ≤ (((1 + c) / 2 : ℝ) : EReal) :=
    (ArithmeticFunction.LSeriesSummable_vonMangoldt
      (s := (((1 + c) / 2 : ℝ) : ℂ)) (by simpa using hc')).abscissaOfAbsConv_le
  intro y hy
  have hre : ((1 + c) / 2 : ℝ) < (c + y * I).re := by
    simp
    linarith
  have hlt : LSeries.abscissaOfAbsConv (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      < (((c + y * I).re : ℝ) : EReal) :=
    lt_of_le_of_lt habs (by exact_mod_cast hre)
  have hd : DifferentiableAt ℂ
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))) (c + y * I) :=
    (LSeries_differentiableOn (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))).differentiableAt
      (isOpen_re_gt_EReal _ |>.mem_nhds hlt)
  have hpath : ContinuousAt (fun y : ℝ => c + y * I) y :=
    (continuous_const.add (continuous_ofReal.mul continuous_const)).continuousAt
  have hcomp : ContinuousAt
      ((fun s : ℂ => LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s)
        ∘ fun y : ℝ => c + y * I) y :=
    ContinuousAt.comp hd.continuousAt hpath
  simpa [Function.comp_def] using hcomp.continuousWithinAt

/-- **Continuity of `Z'/Z` on a vertical line with `Re s > 1`.** -/
theorem continuousOn_logDeriv_completedZeta (c y1 y2 : ℝ) (hc : 1 < c) :
    ContinuousOn (fun y : ℝ => logDeriv completedZeta (c + y * I)) (uIcc y1 y2) := by
  intro y hy
  set s : ℂ := c + y * I with hs
  have hre : 1 < s.re := by
    rw [hs]
    simp
    linarith
  have hradius : 0 < s.re - 1 := by linarith
  -- on the ball of radius re s - 1, Z is differentiable and avoids the poles
  have hball : ∀ w ∈ Metric.ball s (s.re - 1),
      w ≠ 1 ∧ (∀ m : ℕ, w / 2 ≠ -(m : ℂ)) := by
    intro w hw
    have hdist : dist w s < s.re - 1 := Metric.mem_ball.mp hw
    have hre_le : s.re - w.re ≤ dist w s := by
      calc s.re - w.re = (s - w).re := by simp
        _ ≤ ‖s - w‖ := Complex.re_le_norm _
        _ = dist w s := by rw [dist_eq_norm, norm_sub_rev]
    have hwre : 1 < w.re := by linarith
    constructor
    · intro h1
      rw [h1] at hwre
      norm_num at hwre
    · intro m hm
      have h1 : (w / 2).re = -(m : ℝ) := by rw [hm]; simp
      have h2 : (w / 2).re = w.re / 2 := by simp
      have h3 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      rw [h2] at h1
      linarith
  have hdiffOn : DifferentiableOn ℂ completedZeta (Metric.ball s (s.re - 1)) := by
    intro w hw
    obtain ⟨h1, h2⟩ := hball w hw
    exact (differentiableAt_completedZeta_explicit h1 h2).differentiableWithinAt
  have hcontDeriv : ContinuousAt (deriv completedZeta) s :=
    (hdiffOn.deriv Metric.isOpen_ball).continuousOn.continuousAt
      (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hradius))
  have hcontZ : ContinuousAt completedZeta s :=
    (hdiffOn.differentiableAt (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hradius))).continuousAt
  have hne : completedZeta s ≠ 0 := completedZeta_ne_zero_of_one_lt_re hre
  have hd : ContinuousAt (logDeriv completedZeta) s := by
    have hfun : logDeriv completedZeta = fun x : ℂ => deriv completedZeta x / completedZeta x := by
      funext x
      rw [logDeriv_apply]
    rw [hfun]
    exact hcontDeriv.div hcontZ hne
  have hpath : ContinuousAt (fun y : ℝ => c + y * I) y :=
    (continuous_const.add (continuous_ofReal.mul continuous_const)).continuousAt
  have hcomp : ContinuousAt ((fun s : ℂ => logDeriv completedZeta s) ∘ fun y : ℝ => c + y * I) y :=
    ContinuousAt.comp hd hpath
  simpa [Function.comp_def] using hcomp.continuousWithinAt

/-- **The right vertical side, unconditional.** -/
theorem integral_logDeriv_completedZeta_right_side' (c y1 y2 : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y1..y2, logDeriv completedZeta (c + y * I) * I)
      = ((∫ y : ℝ in y1..y2,
            ((1 / 2) * Complex.digamma ((c + y * I) / 2) - (1 / 2) * log (Real.pi : ℂ)))
          - (∑' n : ℕ, if n ≤ 1 then 0 else
              (ArithmeticFunction.vonMangoldt n : ℂ) *
                ((I / (Real.log n : ℂ)) *
                  (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
                    - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ))))) * I :=
  integral_logDeriv_completedZeta_right_side c y1 y2 hc
    (continuousOn_logDeriv_completedZeta c y1 y2 hc).intervalIntegrable
    (continuousOn_lseries_vonMangoldt c y1 y2 hc).intervalIntegrable


/-- **The left vertical side by the functional equation.**  For a rectangle with
`1 < x₂ < 3` (so the left side `Re s = 1 - x₂` avoids `0` and the trivial
zero `-2`), the left-side contour integral is minus the right-side integral
over the reflected interval:
`∫_{y₁}^{y₂} (Z'/Z)((1-x₂)+iy)·i dy = -∫_{-y₂}^{-y₁} (Z'/Z)(x₂+it)·i dt`. -/
theorem integral_logDeriv_completedZeta_left_side (x₂ y1 y2 : ℝ)
    (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) :
    (∫ y : ℝ in y1..y2, logDeriv completedZeta ((1 - x₂) + y * I) * I)
      = - (∫ t : ℝ in (-y2)..(-y1), logDeriv completedZeta (x₂ + t * I) * I) := by
  have hsub : (∫ x : ℝ in -y2..-y1,
      (fun y : ℝ => logDeriv completedZeta ((1 - x₂) + y * I) * I) (-x))
      = (∫ y : ℝ in y1..y2, logDeriv completedZeta ((1 - x₂) + y * I) * I) := by
    simpa using intervalIntegral.integral_comp_neg
      (f := fun y : ℝ => logDeriv completedZeta ((1 - x₂) + y * I) * I) (a := -y2) (b := -y1)
  rw [← hsub]
  have hcongr : ∀ t ∈ uIcc (-y2) (-y1),
      (fun y : ℝ => logDeriv completedZeta ((1 - x₂) + y * I) * I) (-t)
        = - (logDeriv completedZeta (x₂ + t * I) * I) := by
    intro t ht
    change logDeriv completedZeta (1 - (x₂ : ℂ) + ((-t : ℝ) : ℂ) * I) * I
      = - (logDeriv completedZeta ((x₂ : ℂ) + (t : ℂ) * I) * I)
    have harg : (1 - x₂) + (-t) * I = 1 - (x₂ + t * I) := by ring
    have hfe : logDeriv completedZeta (1 - (x₂ + t * I))
        = - logDeriv completedZeta (x₂ + t * I) := by
      apply logDeriv_completedZeta_one_sub
      · -- s ≠ 0
        intro h
        have := congrArg Complex.re h
        simp at this
        linarith
      · -- s ≠ 1
        intro h
        have := congrArg Complex.re h
        simp at this
        linarith
      · -- Gammaℝ s ≠ 0
        intro h
        obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
        have hre : (x₂ + t * I).re = -(2 * (n : ℝ)) := by rw [hn]; simp
        simp at hre
        have : (0 : ℝ) ≤ 2 * n := by positivity
        linarith
      · -- Gammaℝ (1 - s) ≠ 0
        intro h
        obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
        have hre : (1 - (x₂ + t * I)).re = -(2 * (n : ℝ)) := by rw [hn]; simp
        simp at hre
        have hn0 : (0 : ℝ) < n := by linarith
        have hn1 : (n : ℝ) < 1 := by linarith
        have hn0' : 0 < n := by exact_mod_cast hn0
        have hn1' : n < 1 := by exact_mod_cast hn1
        omega
      · -- pole condition for s
        intro m hm
        have := congrArg Complex.re hm
        simp at this
        have : (0 : ℝ) ≤ m := Nat.cast_nonneg m
        linarith
      · -- pole condition for 1 - s
        intro m hm
        have hre : (1 - x₂) / 2 = -(m : ℝ) := by
          have := congrArg Complex.re hm
          simpa using this
        have hx : x₂ = 1 + 2 * (m : ℝ) := by linarith
        have hm0 : (0 : ℝ) < m := by linarith
        have hm1 : (m : ℝ) < 1 := by linarith
        have hm0' : 0 < m := by exact_mod_cast hm0
        have hm1' : m < 1 := by exact_mod_cast hm1
        omega
    have hleft : (1 - (x₂ : ℂ)) + ((-t : ℝ) : ℂ) * I = 1 - ((x₂ : ℂ) + (t : ℂ) * I) := by
      push_cast
      ring
    rw [hleft, hfe]
    ring
  rw [intervalIntegral.integral_congr hcongr, intervalIntegral.integral_neg]


/-- **The two vertical sides of a symmetric rectangle.** -/
theorem integral_logDeriv_completedZeta_left_eq_neg_right (x₂ T : ℝ)
    (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) :
    (∫ y : ℝ in (-T)..T, logDeriv completedZeta ((1 - x₂) + y * I) * I)
      = - (∫ y : ℝ in (-T)..T, logDeriv completedZeta (x₂ + y * I) * I) := by
  simpa using integral_logDeriv_completedZeta_left_side x₂ (-T) T hx₂ hx₃


/-- The archimedean symbol on a vertical line: `(1/2)ψ(s/2) - (1/2)log π`. -/
noncomputable def archSymbol (c y : ℝ) : ℂ :=
  (1 / 2) * Complex.digamma ((c + y * I) / 2) - (1 / 2) * log (Real.pi : ℂ)

/-- The closed-form prime side on the vertical segment `[y₁,y₂]`. -/
noncomputable def primeSide (c y1 y2 : ℝ) : ℂ :=
  ∑' n : ℕ, if n ≤ 1 then 0 else
    (ArithmeticFunction.vonMangoldt n : ℂ) *
      ((I / (Real.log n : ℂ)) *
        (((n : ℝ) : ℂ) ^ (-(c + y2 * I) : ℂ)
          - ((n : ℝ) : ℂ) ^ (-(c + y1 * I) : ℂ)))

/-- **Explicit formula for `h ≡ 1` on a symmetric rectangle.**  The zero count
`Σ m - 2` equals the horizontal difference plus twice the right-side symbol
contribution (the left side being its negative by the functional equation). -/
theorem explicit_formula_h1_symmetric
    {U : Set ℂ} (x₂ T : ℝ) (hx₂ : 1 < x₂) (hx₃ : x₂ < 3)
    (S : Finset ℂ) (m : ℂ → ℕ)
    (hU : IsOpen U) (hsub : ([[1 - x₂, x₂]] ×ℂ [[-T, T]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (h0 : 1 - x₂ < 0 ∧ 0 < x₂ ∧ -T < 0 ∧ 0 < T)
    (h1 : 1 - x₂ < 1 ∧ 1 < x₂ ∧ -T < 0 ∧ 0 < T)
    (hS_in : ∀ w ∈ S, 1 - x₂ < w.re ∧ w.re < x₂ ∧ -T < w.im ∧ w.im < T)
    (hg : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hm : ∀ w ∈ S, 0 < m w)
    (hord : ∀ w ∈ S,
      analyticOrderNatAt (fun s : ℂ => s * (s - 1) * completedZeta s) w = m w)
    (hno : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0) :
    ((∑ w ∈ S, (m w : ℂ)) - 2) * (2 * (Real.pi : ℂ) * I)
      = ((∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta (x + (-T) * I))
          - (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta (x + T * I)))
        + 2 * (((∫ y : ℝ in (-T)..T, archSymbol x₂ y) - primeSide x₂ (-T) T) * I) := by
  have hzero := rectIntegral_logDeriv_completedZeta_eq_divisor_sum
    (x₁ := 1 - x₂) (x₂ := x₂) (y₁ := -T) (y₂ := T) S m hU hsub hZ h0 h1 hS_in hg hm hord hno
  have hright := integral_logDeriv_completedZeta_right_side' x₂ (-T) T hx₂
  have hleft := integral_logDeriv_completedZeta_left_side x₂ (-T) T hx₂ hx₃
  rw [rectIntegral] at hzero
  have hWright : (∫ y : ℝ in (-T)..T, logDeriv completedZeta (x₂ + y * I) * I)
      = ((∫ y : ℝ in (-T)..T, archSymbol x₂ y) - primeSide x₂ (-T) T) * I := by
    simpa [archSymbol, primeSide] using hright
  have hWleft : (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((((1 - x₂ : ℝ)) : ℂ) + y * I) * I)
      = -(((∫ y : ℝ in (-T)..T, archSymbol x₂ y) - primeSide x₂ (-T) T) * I) := by
    have hleft' : (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((((1 - x₂ : ℝ)) : ℂ) + y * I) * I)
        = - (∫ t : ℝ in (-T)..T, logDeriv completedZeta (x₂ + t * I) * I) := by
      simpa using hleft
    rw [hleft', hWright]
  set W : ℂ := ((∫ y : ℝ in (-T)..T, archSymbol x₂ y) - primeSide x₂ (-T) T) * I with hW
  have hIr : I * (∫ y : ℝ in (-T)..T, logDeriv completedZeta (x₂ + y * I)) = W := by
    rw [hW, mul_comm, ← intervalIntegral.integral_mul_const, hWright]
  have hIl : I * (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((((1 - x₂ : ℝ)) : ℂ) + y * I)) = -W := by
    rw [hW, mul_comm, ← intervalIntegral.integral_mul_const, hWleft]
  rw [hIr, hIl] at hzero
  simp only [Complex.ofReal_neg] at hzero ⊢
  linear_combination -hzero


/-! ### Exact horizontal difference via the functional equation

The horizontal difference in the assembly can be computed exactly, without any
Stirling-type decay estimate: on the symmetric rectangle `[1-x₂, x₂]`, the
bottom horizontal integral equals minus the top one (functional equation), so
the horizontal difference `bottom - top` is `-2·top`. -/

/-- **Exact horizontal reflection**: on the symmetric rectangle the bottom
horizontal integral is minus the top one. -/
theorem integral_logDeriv_completedZeta_bottom_eq_neg_top (x₂ T : ℝ)
    (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) (hT : 0 < T) :
    (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I))
      = - (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)) := by
  have hsubst : (∫ x : ℝ in (1 - x₂)..x₂,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I))
      = ∫ w : ℝ in (1 - x₂)..x₂,
          logDeriv completedZeta ((((1 : ℝ) - w : ℝ) : ℂ) + (-T : ℝ) * I) := by
    have h := intervalIntegral.integral_comp_sub_left
      (f := fun w : ℝ => logDeriv completedZeta ((((1 : ℝ) - w : ℝ) : ℂ) + (-T : ℝ) * I))
      (a := 1 - x₂) (b := x₂) (d := 1)
    simpa using h
  rw [hsubst]
  have hcongr : ∀ w ∈ uIcc (1 - x₂) x₂,
      logDeriv completedZeta ((((1 : ℝ) - w : ℝ) : ℂ) + (-T : ℝ) * I)
        = - logDeriv completedZeta ((w : ℂ) + (T : ℝ) * I) := by
    intro w hw
    have harg : ((((1 : ℝ) - w : ℝ) : ℂ) + (-T : ℝ) * I)
        = 1 - ((w : ℂ) + (T : ℝ) * I) := by
      push_cast
      ring
    rw [harg]
    apply logDeriv_completedZeta_one_sub
    · -- s ≠ 0
      intro h
      have him : ((w : ℂ) + (T : ℝ) * I).im = T := by simp
      rw [h] at him
      simp at him
      linarith
    · -- s ≠ 1
      intro h
      have him : ((w : ℂ) + (T : ℝ) * I).im = T := by simp
      rw [h] at him
      simp at him
      linarith
    · -- Gammaℝ s ≠ 0
      intro h
      obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
      have him : ((w : ℂ) + (T : ℝ) * I).im = T := by simp
      have hzero : ((w : ℂ) + (T : ℝ) * I).im = 0 := by rw [hn]; simp
      linarith
    · -- Gammaℝ (1 - s) ≠ 0
      intro h
      obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
      have him : (1 - ((w : ℂ) + (T : ℝ) * I)).im = -T := by simp
      have hzero : (1 - ((w : ℂ) + (T : ℝ) * I)).im = 0 := by rw [hn]; simp
      linarith
    · -- pole condition for s
      intro m hm
      have him : (((w : ℂ) + (T : ℝ) * I) / 2).im = T / 2 := by simp
      have hzero : (((w : ℂ) + (T : ℝ) * I) / 2).im = 0 := by rw [hm]; simp
      linarith
    · -- pole condition for 1 - s
      intro m hm
      have him : ((1 - ((w : ℂ) + (T : ℝ) * I)) / 2).im = -(T / 2) := by
        simp
        ring
      have hzero : ((1 - ((w : ℂ) + (T : ℝ) * I)) / 2).im = 0 := by rw [hm]; simp
      linarith
  rw [intervalIntegral.integral_congr hcongr, intervalIntegral.integral_neg]

/-- **Assembly with the exact horizontal difference.**  The horizontal
difference is `-2·top`, so the zero count is
`2·bottom + 2·(∫ arch − primeSide)·i`. -/
theorem explicit_formula_h1_symmetric_exact
    {U : Set ℂ} (x₂ T : ℝ) (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) (hT : 0 < T)
    (S : Finset ℂ) (m : ℂ → ℕ)
    (hU : IsOpen U) (hsub : ([[1 - x₂, x₂]] ×ℂ [[-T, T]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (h0 : 1 - x₂ < 0 ∧ 0 < x₂ ∧ -T < 0 ∧ 0 < T)
    (h1 : 1 - x₂ < 1 ∧ 1 < x₂ ∧ -T < 0 ∧ 0 < T)
    (hS_in : ∀ w ∈ S, 1 - x₂ < w.re ∧ w.re < x₂ ∧ -T < w.im ∧ w.im < T)
    (hg : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hm : ∀ w ∈ S, 0 < m w)
    (hord : ∀ w ∈ S,
      analyticOrderNatAt (fun s : ℂ => s * (s - 1) * completedZeta s) w = m w)
    (hno : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0) :
    ((∑ w ∈ S, (m w : ℂ)) - 2) * (2 * (Real.pi : ℂ) * I)
      = 2 * (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I))
        + 2 * (((∫ y : ℝ in (-T)..T, archSymbol x₂ y) - primeSide x₂ (-T) T) * I) := by
  have h := explicit_formula_h1_symmetric (U := U) x₂ T hx₂ hx₃ S m hU hsub hZ h0 h1 hS_in hg hm hord hno
  have hb := integral_logDeriv_completedZeta_bottom_eq_neg_top x₂ T hx₂ hx₃ hT
  have hb' : (∫ x : ℝ in (1 - x₂)..x₂,
      logDeriv completedZeta ((x : ℂ) + (-(T : ℂ)) * I))
      = - (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (T : ℂ) * I)) := by
    simpa only [Complex.ofReal_neg] using hb
  simp only [Complex.ofReal_neg] at h ⊢
  rw [hb'] at h ⊢
  linear_combination h



/-- Conjugation commutes with the interval integral. -/
theorem integral_conj_interval {f : ℝ → ℂ} {a b : ℝ}
    (hf : IntervalIntegrable f volume a b) :
    (∫ x : ℝ in a..b, (starRingEnd ℂ) (f x)) = (starRingEnd ℂ) (∫ x : ℝ in a..b, f x) := by
  unfold intervalIntegral
  rw [integral_conj, integral_conj, map_sub]

/-- **Conjugation symmetry of the bottom side**: the bottom horizontal integral
is the conjugate of the top one. -/
theorem integral_logDeriv_completedZeta_bottom_eq_conj_top (x₂ T : ℝ)
    (hx₂ : 1 < x₂) (hT : 0 < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
      volume (1 - x₂) x₂) :
    (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I))
      = (starRingEnd ℂ) (∫ x : ℝ in (1 - x₂)..x₂,
          logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)) := by
  rw [← integral_conj_interval hint]
  apply intervalIntegral.integral_congr
  intro x hx
  show logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I)
    = (starRingEnd ℂ) (logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
  have hsl : (starRingEnd ℂ) ((x : ℂ) + (T : ℝ) * I) = (x : ℂ) + (-T : ℝ) * I := by
    simp [map_add, map_mul]
  rw [← hsl]
  apply logDeriv_completedZeta_conj
  · intro h
    have him : ((x : ℂ) + (T : ℝ) * I).im = T := by simp
    rw [h] at him
    simp at him
    linarith
  · intro h
    have him : ((x : ℂ) + (T : ℝ) * I).im = T := by simp
    rw [h] at him
    simp at him
    linarith
  · intro m hm
    have him : (((x : ℂ) + (T : ℝ) * I) / 2).im = T / 2 := by simp
    have hzero : (((x : ℂ) + (T : ℝ) * I) / 2).im = 0 := by rw [hm]; simp
    linarith

/-- **The top horizontal integral is purely imaginary** (it equals minus its
conjugate).  This is the exact replacement for a decay estimate. -/
theorem integral_logDeriv_completedZeta_top_pure_imaginary (x₂ T : ℝ)
    (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) (hT : 0 < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
      volume (1 - x₂) x₂) :
    (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
      = - (starRingEnd ℂ) (∫ x : ℝ in (1 - x₂)..x₂,
          logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)) := by
  have hb := integral_logDeriv_completedZeta_bottom_eq_neg_top x₂ T hx₂ hx₃ hT
  have hc := integral_logDeriv_completedZeta_bottom_eq_conj_top x₂ T hx₂ hT hint
  rw [hb] at hc
  linear_combination -hc


/-- **Zero side of the explicit formula from the divisor.**  For
`g = s(s-1)Z`, if `g` is analytic on an open `U` containing the closed
rectangle, has finite analytic order everywhere on `U`, and all zeros of `g`
in `U` lie in the open rectangle, then the zero side
`∮ Z'/Z = 2πi·(∑ div - 2)` holds, with the zeros counted by the divisor on the
open rectangle.  No zero set is assumed. -/
theorem rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived
    {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ < x₂) (hy : y₁ < y₂)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (h0 : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1 : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hfinite : ∀ z ∈ U,
      analyticOrderAt (fun s : ℂ => s * (s - 1) * completedZeta s) z ≠ ⊤)
    (hno_out : ∀ z ∈ U, z * (z - 1) * completedZeta z = 0 →
      z ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) :
    ∃ S : Finset ℂ,
      (∀ w, w ∈ S ↔ w ∈ (MeromorphicOn.divisor
        (fun s : ℂ => s * (s - 1) * completedZeta s) (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).support)
      ∧ rectIntegral (fun s => logDeriv completedZeta s) x₁ x₂ y₁ y₂
          = ((S.sum (fun w => (((MeromorphicOn.divisor
              (fun s : ℂ => s * (s - 1) * completedZeta s)
              (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) w).toNat : ℂ))) - 2)
            * (2 * (Real.pi : ℂ) * I) := by
  set g : ℂ → ℂ := fun s => s * (s - 1) * completedZeta s with hg_def
  have hg : DifferentiableOn ℂ g U := by
    have h1' : DifferentiableOn ℂ (fun s : ℂ => s) U := differentiable_id.differentiableOn
    have h2' : DifferentiableOn ℂ (fun s : ℂ => s - 1) U :=
      (differentiable_id.sub_const 1).differentiableOn
    rw [hg_def]
    exact (h1'.mul h2').mul hZ
  have hVsub : (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) ⊆ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt hz.1.1),
        le_trans (le_of_lt hz.1.2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt hz.2.1),
        le_trans (le_of_lt hz.2.2) (le_max_right _ _)⟩⟩
  have hOV : AnalyticOnNhd ℂ g (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
    (hg.analyticOnNhd hU).mono (fun z hz => hsub (hVsub hz))
  have hfin := divisor_openRect_support_finite x₁ x₂ y₁ y₂ hU hsub hg
  obtain ⟨S, hS_mem⟩ := hfin.exists_finset
  let m : ℂ → ℕ := fun w => ((MeromorphicOn.divisor g (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) w).toNat
  have hm : ∀ w ∈ S, 0 < m w := by
    intro w hw
    have hwV : w ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
      divisor_openRect_support_subset x₁ x₂ y₁ y₂ ((hS_mem w).mp hw)
    have hordw := analyticOrderNatAt_eq_divisor_toNat x₁ x₂ y₁ y₂ hU hsub hg
      ((hS_mem w).mp hw)
    have hb := divisor_apply_eq_analyticOrderNatAt hOV hwV (hfinite w (hsub (hVsub hwV)))
    have hne : analyticOrderNatAt g w ≠ 0 := by
      intro h0'
      apply (Function.mem_support.mp ((hS_mem w).mp hw))
      rw [hb, h0']
      simp
    rw [show m w = analyticOrderNatAt g w from hordw.symm]
    exact Nat.pos_iff_ne_zero.mpr hne
  have hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂ := by
    intro w hw
    have hwV : w ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
      divisor_openRect_support_subset x₁ x₂ y₁ y₂ ((hS_mem w).mp hw)
    rw [Complex.mem_reProdIm] at hwV
    exact ⟨hwV.1.1, hwV.1.2, hwV.2.1, hwV.2.2⟩
  have hord : ∀ w ∈ S, analyticOrderNatAt g w = m w := by
    intro w hw
    exact analyticOrderNatAt_eq_divisor_toNat x₁ x₂ y₁ y₂ hU hsub hg ((hS_mem w).mp hw)
  have hno : ∀ z ∈ U, z ∉ S → g z ≠ 0 := by
    intro z hzU hzS hgz
    have hzV : z ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) := by
      have := hno_out z hzU
      exact this hgz
    have hAnalytic : AnalyticAt ℂ g z := (hg.analyticOnNhd hU) z hzU
    have hord_ne : analyticOrderAt g z ≠ 0 := hAnalytic.analyticOrderAt_ne_zero.mpr hgz
    have hnat : analyticOrderNatAt g z ≠ 0 := by
      intro h0'
      have hcast := Nat.cast_analyticOrderNatAt (z₀ := z) (hfinite z hzU)
      rw [h0'] at hcast
      simp at hcast
      exact hord_ne hcast.symm
    have hb := divisor_apply_eq_analyticOrderNatAt hOV hzV (hfinite z hzU)
    have hdiv : (MeromorphicOn.divisor g (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) z ≠ 0 := by
      rw [hb]
      intro h0'
      have : analyticOrderNatAt g z = 0 := by omega
      exact hnat this
    exact hzS ((hS_mem z).mpr (Function.mem_support.mpr hdiv))
  have hq := differentiableOn_quotientExtensionPow hU hg hm hord
  have hq_ne := quotientExtensionPow_ne_zero hU hg hm hord hno
  have hfac : ∀ z ∈ U, z ∉ S →
      z * (z - 1) * completedZeta z
        = (∏ w ∈ S, (z - w) ^ m w) * quotientExtensionPow g S m z := by
    intro z hzU hzS
    rw [quotientExtensionPow_of_not_mem hzS]
    field_simp [polyProdPow_ne_zero_of_not_mem hzS]
    rw [hg_def]
    simp only [polyProdPow]
    ring
  refine ⟨S, hS_mem, ?_⟩
  exact rectIntegral_logDeriv_completedZeta_eq_sum x₁ x₂ y₁ y₂ S m hU hsub hZ h0 h1
    hS_in hg hq hq_ne hfac


/-- **The `h ≡ 1` explicit formula on a symmetric rectangle, with the zero
side derived from the divisor.**  Under analyticity, finite order and the
condition that all zeros in `U` lie in the open rectangle, the divisor sum
minus the two poles equals the exact horizontal contribution plus twice the
right-side symbol contribution. -/
theorem explicit_formula_h1_symmetric_divisor
    {U : Set ℂ} (x₂ T : ℝ) (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) (hT : 0 < T)
    (hU : IsOpen U) (hsub : ([[1 - x₂, x₂]] ×ℂ [[-T, T]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (hfinite : ∀ z ∈ U,
      analyticOrderAt (fun s : ℂ => s * (s - 1) * completedZeta s) z ≠ ⊤)
    (hno_out : ∀ z ∈ U, z * (z - 1) * completedZeta z = 0 →
      z ∈ (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T)) :
    ∃ S : Finset ℂ,
      (∀ w, w ∈ S ↔ w ∈ (MeromorphicOn.divisor
        (fun s : ℂ => s * (s - 1) * completedZeta s)
        (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T)).support)
      ∧ ((S.sum (fun w => (((MeromorphicOn.divisor
            (fun s : ℂ => s * (s - 1) * completedZeta s)
            (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T)) w).toNat : ℂ))) - 2)
          * (2 * (Real.pi : ℂ) * I)
        = 2 * (∫ x : ℝ in (1 - x₂)..x₂,
              logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I))
          + 2 * (((∫ y : ℝ in (-T)..T, archSymbol x₂ y) - primeSide x₂ (-T) T) * I) := by
  set g : ℂ → ℂ := fun s => s * (s - 1) * completedZeta s with hg_def
  have hg : DifferentiableOn ℂ g U := by
    have h1' : DifferentiableOn ℂ (fun s : ℂ => s) U := differentiable_id.differentiableOn
    have h2' : DifferentiableOn ℂ (fun s : ℂ => s - 1) U :=
      (differentiable_id.sub_const 1).differentiableOn
    rw [hg_def]
    exact (h1'.mul h2').mul hZ
  have hVsub : (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T) ⊆ ([[1 - x₂, x₂]] ×ℂ [[-T, T]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt hz.1.1),
        le_trans (le_of_lt hz.1.2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt hz.2.1),
        le_trans (le_of_lt hz.2.2) (le_max_right _ _)⟩⟩
  have hOV : AnalyticOnNhd ℂ g (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T) :=
    (hg.analyticOnNhd hU).mono (fun z hz => hsub (hVsub hz))
  have hfin := divisor_openRect_support_finite (1 - x₂) x₂ (-T) T hU hsub hg
  obtain ⟨S, hS_mem⟩ := hfin.exists_finset
  let m : ℂ → ℕ := fun w =>
    ((MeromorphicOn.divisor g (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T)) w).toNat
  have hm : ∀ w ∈ S, 0 < m w := by
    intro w hw
    have hwV : w ∈ (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T) :=
      divisor_openRect_support_subset (1 - x₂) x₂ (-T) T ((hS_mem w).mp hw)
    have hordw := analyticOrderNatAt_eq_divisor_toNat (1 - x₂) x₂ (-T) T hU hsub hg
      ((hS_mem w).mp hw)
    have hb := divisor_apply_eq_analyticOrderNatAt hOV hwV (hfinite w (hsub (hVsub hwV)))
    have hne : analyticOrderNatAt g w ≠ 0 := by
      intro h0'
      apply (Function.mem_support.mp ((hS_mem w).mp hw))
      rw [hb, h0']
      simp
    rw [show m w = analyticOrderNatAt g w from hordw.symm]
    exact Nat.pos_iff_ne_zero.mpr hne
  have hS_in : ∀ w ∈ S, 1 - x₂ < w.re ∧ w.re < x₂ ∧ -T < w.im ∧ w.im < T := by
    intro w hw
    have hwV : w ∈ (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T) :=
      divisor_openRect_support_subset (1 - x₂) x₂ (-T) T ((hS_mem w).mp hw)
    rw [Complex.mem_reProdIm] at hwV
    exact ⟨hwV.1.1, hwV.1.2, hwV.2.1, hwV.2.2⟩
  have hord : ∀ w ∈ S,
      analyticOrderNatAt g w = m w := by
    intro w hw
    exact analyticOrderNatAt_eq_divisor_toNat (1 - x₂) x₂ (-T) T hU hsub hg ((hS_mem w).mp hw)
  have hno : ∀ z ∈ U, z ∉ S → g z ≠ 0 := by
    intro z hzU hzS hgz
    have hzV : z ∈ (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T) := hno_out z hzU hgz
    have hAnalytic : AnalyticAt ℂ g z := (hg.analyticOnNhd hU) z hzU
    have hord_ne : analyticOrderAt g z ≠ 0 := hAnalytic.analyticOrderAt_ne_zero.mpr hgz
    have hnat : analyticOrderNatAt g z ≠ 0 := by
      intro h0'
      have hcast := Nat.cast_analyticOrderNatAt (z₀ := z) (hfinite z hzU)
      rw [h0'] at hcast
      simp at hcast
      exact hord_ne hcast.symm
    have hb := divisor_apply_eq_analyticOrderNatAt hOV hzV (hfinite z hzU)
    have hdiv : (MeromorphicOn.divisor g (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T)) z ≠ 0 := by
      rw [hb]
      intro h0'
      have : analyticOrderNatAt g z = 0 := by omega
      exact hnat this
    exact hzS ((hS_mem z).mpr (Function.mem_support.mpr hdiv))
  have h0 : 1 - x₂ < 0 ∧ 0 < x₂ ∧ -T < 0 ∧ 0 < T := by
    exact ⟨by linarith, by linarith, by linarith, hT⟩
  have h1 : 1 - x₂ < 1 ∧ 1 < x₂ ∧ -T < 0 ∧ 0 < T := by
    exact ⟨by linarith, hx₂, by linarith, hT⟩
  have hmain := explicit_formula_h1_symmetric_exact x₂ T hx₂ hx₃ hT S m hU hsub hZ h0 h1
    hS_in hg hm hord hno
  refine ⟨S, hS_mem, ?_⟩
  have hsum_eq : (S.sum (fun w => (m w : ℂ)))
      = S.sum (fun w => (((MeromorphicOn.divisor g
          (Ioo (1 - x₂) x₂ ×ℂ Ioo (-T) T)) w).toNat : ℂ)) := by
    apply Finset.sum_congr rfl
    intro w hw
    rfl
  rw [← hsum_eq]
  exact hmain


/-- **The bottom horizontal side is purely imaginary** as well. -/
theorem integral_logDeriv_completedZeta_bottom_pure_imaginary (x₂ T : ℝ)
    (hx₂ : 1 < x₂) (hx₃ : x₂ < 3) (hT : 0 < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
      volume (1 - x₂) x₂) :
    (∫ x : ℝ in (1 - x₂)..x₂, logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I))
      = - (starRingEnd ℂ) (∫ x : ℝ in (1 - x₂)..x₂,
          logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I)) := by
  have hb := integral_logDeriv_completedZeta_bottom_eq_neg_top x₂ T hx₂ hx₃ hT
  have hc := integral_logDeriv_completedZeta_bottom_eq_conj_top x₂ T hx₂ hT hint
  have htop : (∫ x : ℝ in (1 - x₂)..x₂,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
      = - (∫ x : ℝ in (1 - x₂)..x₂,
          logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I)) := by
    have h := congrArg Neg.neg hb
    simpa using h.symm
  have htop' : (starRingEnd ℂ) (∫ x : ℝ in (1 - x₂)..x₂,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I))
      = - (starRingEnd ℂ) (∫ x : ℝ in (1 - x₂)..x₂,
          logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I)) := by
    rw [htop, map_neg]
  exact hc.trans htop'


/-- **Residue of `f'/f` at a simple zero**: `(s-ρ)·f'/f → 1`.  This is the
local residue input for the test-function explicit formula. -/
theorem tendsto_sub_mul_logDeriv_of_simple_zero {f : ℂ → ℂ} {ρ : ℂ}
    (hf : AnalyticAt ℂ f ρ) (h0 : f ρ = 0) (h1 : deriv f ρ ≠ 0) :
    Tendsto (fun s : ℂ => (s - ρ) * logDeriv f s) (𝓝[≠] ρ) (𝓝 1) := by
  obtain ⟨g, hg, hg0, hfg⟩ :=
    AbsoluteHodgeRectangle.AnalyticAt.exists_eventuallyEq_sub_mul hf h0 h1
  have hg_cont : ContinuousAt (logDeriv g) ρ := by
    have hfun : logDeriv g = fun s : ℂ => deriv g s / g s := by
      funext s
      rw [logDeriv_apply]
    rw [hfun]
    exact (hg.deriv.div hg hg0).continuousAt
  have hev : (fun s : ℂ => (s - ρ) * logDeriv f s) =ᶠ[𝓝[≠] ρ]
      (fun s : ℂ => 1 + (s - ρ) * logDeriv g s) := by
    rw [Filter.eventuallyEq_iff_exists_mem] at hfg
    obtain ⟨V, hV, hVeq⟩ := hfg
    obtain ⟨ε, hε, hball⟩ := Metric.mem_nhds_iff.mp hV
    have hgan : ∀ᶠ s : ℂ in 𝓝 ρ, AnalyticAt ℂ g s := hg.eventually_analyticAt
    have hgne : ∀ᶠ s : ℂ in 𝓝 ρ, g s ≠ 0 := hg.continuousAt.eventually_ne hg0
    rw [Filter.eventuallyEq_iff_exists_mem]
    refine ⟨(Metric.ball ρ ε ∩ {s | AnalyticAt ℂ g s} ∩ {s | g s ≠ 0}) ∩ {s | s ≠ ρ}, ?_, ?_⟩
    · have hmem : (Metric.ball ρ ε ∩ {s | AnalyticAt ℂ g s} ∩ {s | g s ≠ 0}) ∈ 𝓝 ρ :=
        Filter.inter_mem (Filter.inter_mem
          (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hε)) hgan) hgne
      exact Filter.inter_mem (nhdsWithin_le_nhds hmem) self_mem_nhdsWithin
    · intro s hs
      obtain ⟨⟨⟨hsball, hgs_an⟩, hgs_ne⟩, hsne⟩ := hs
      show (s - ρ) * logDeriv f s = 1 + (s - ρ) * logDeriv g s
      have hVs : V ∈ 𝓝 s := Filter.mem_of_superset (Metric.isOpen_ball.mem_nhds hsball) hball
      have hev_s : f =ᶠ[𝓝 s] fun y => (y - ρ) * g y := Filter.eventually_of_mem hVs hVeq
      have hlog := AbsoluteHodgeSymbol.logDeriv_eq_inv_add hev_s hsne hgs_ne hgs_an.differentiableAt
      rw [hlog]
      field_simp [sub_ne_zero.mpr hsne]
  have hlim : Tendsto (fun s : ℂ => 1 + (s - ρ) * logDeriv g s) (𝓝[≠] ρ) (𝓝 1) := by
    have hsub : Tendsto (fun s : ℂ => s - ρ) (𝓝[≠] ρ) (𝓝 0) := by
      have h : Tendsto (fun s : ℂ => s - ρ) (𝓝 ρ) (𝓝 (ρ - ρ)) :=
        tendsto_id.sub tendsto_const_nhds
      simpa using h.mono_left nhdsWithin_le_nhds
    have hlog : Tendsto (logDeriv g) (𝓝[≠] ρ) (𝓝 (logDeriv g ρ)) :=
      hg_cont.tendsto.mono_left nhdsWithin_le_nhds
    have hprod : Tendsto (fun s : ℂ => (s - ρ) * logDeriv g s) (𝓝[≠] ρ)
        (𝓝 (0 * logDeriv g ρ)) := hsub.mul hlog
    simpa using tendsto_const_nhds.add hprod
  exact hlim.congr' hev.symm


/-- **Residue of `Z'/Z` at a simple zero of `Z`** is `1`. -/
theorem tendsto_sub_mul_logDeriv_completedZeta_zero {ρ : ℂ}
    (hA : AnalyticAt ℂ completedZeta ρ) (h0 : completedZeta ρ = 0)
    (h1 : deriv completedZeta ρ ≠ 0) :
    Tendsto (fun s : ℂ => (s - ρ) * logDeriv completedZeta s) (𝓝[≠] ρ) (𝓝 1) :=
  tendsto_sub_mul_logDeriv_of_simple_zero hA h0 h1


/-- **Residue of `f'/f` at a simple pole**: if `f = F/(s-p)` off `p` with `F`
analytic at `p` and `F p = c ≠ 0`, then `(s-p)·f'/f → -1`. -/
theorem tendsto_sub_mul_logDeriv_of_simple_pole {f F : ℂ → ℂ} {p c : ℂ}
    (hF : AnalyticAt ℂ F p) (hFc : F p = c) (hc : c ≠ 0)
    (hf : ∀ s : ℂ, s ≠ p → f s = F s / (s - p)) :
    Tendsto (fun s : ℂ => (s - p) * logDeriv f s) (𝓝[≠] p) (𝓝 (-1)) := by
  have hFp_ne : F p ≠ 0 := by rw [hFc]; exact hc
  have hFcont : ContinuousAt (logDeriv F) p := by
    have hfun : logDeriv F = fun s : ℂ => deriv F s / F s := by
      funext s
      rw [logDeriv_apply]
    rw [hfun]
    exact (hF.deriv.div hF hFp_ne).continuousAt
  have hev : (fun s : ℂ => (s - p) * logDeriv f s) =ᶠ[𝓝[≠] p]
      (fun s : ℂ => (s - p) * logDeriv F s - 1) := by
    have hFne : ∀ᶠ s : ℂ in 𝓝 p, F s ≠ 0 := hF.continuousAt.eventually_ne hFp_ne
    have hFan : ∀ᶠ s : ℂ in 𝓝 p, AnalyticAt ℂ F s := hF.eventually_analyticAt
    filter_upwards [self_mem_nhdsWithin, nhdsWithin_le_nhds hFne, nhdsWithin_le_nhds hFan]
      with s hsne hFs hFs_an
    show (s - p) * logDeriv f s = (s - p) * logDeriv F s - 1
    have hfs : f =ᶠ[𝓝 s] fun y => F y / (y - p) := by
      filter_upwards [isOpen_compl_singleton.mem_nhds (by simpa using hsne)] with y hy
      exact hf y hy
    have hsne' : s ≠ p := by simpa using hsne
    have hfun : (fun y : ℂ => F y / (y - p)) = F / (fun y : ℂ => y - p) := by
      funext y
      rfl
    rw [(logDeriv_congr_nhds hfs).eq_of_nhds, hfun]
    rw [logDeriv_div (𝕜 := ℂ) (f := F) (g := fun y : ℂ => y - p) s hFs
      (sub_ne_zero.mpr hsne') hFs_an.differentiableAt (differentiableAt_id.sub_const p)]
    rw [logDeriv_sub_const p s hsne']
    field_simp [sub_ne_zero.mpr hsne']
  have hlim : Tendsto (fun s : ℂ => (s - p) * logDeriv F s - 1) (𝓝[≠] p) (𝓝 (-1)) := by
    have hsub : Tendsto (fun s : ℂ => s - p) (𝓝[≠] p) (𝓝 0) := by
      have h : Tendsto (fun s : ℂ => s - p) (𝓝 p) (𝓝 (p - p)) :=
        tendsto_id.sub tendsto_const_nhds
      simpa using h.mono_left nhdsWithin_le_nhds
    have hprod : Tendsto (fun s : ℂ => (s - p) * logDeriv F s) (𝓝[≠] p)
        (𝓝 (0 * logDeriv F p)) :=
      hsub.mul (hFcont.tendsto.mono_left nhdsWithin_le_nhds)
    have hzero : (0 * logDeriv F p) = 0 := zero_mul _
    rw [hzero] at hprod
    simpa using hprod.sub tendsto_const_nhds
  exact hlim.congr' hev.symm


/-! ### Extending `Z` across its poles and the pole residues of `Z'/Z` -/

/-- `(s-1)Z(s)`, extended by its residue `1` at `s = 1`. -/
noncomputable def poleExtensionOne : ℂ → ℂ :=
  Function.update (fun s : ℂ => (s - 1) * completedZeta s) 1 1

theorem poleExtensionOne_apply_ne {s : ℂ} (hs : s ≠ 1) :
    poleExtensionOne s = (s - 1) * completedZeta s :=
  Function.update_of_ne hs _ _

theorem poleExtensionOne_one : poleExtensionOne 1 = 1 :=
  Function.update_self ..

/-- `s·Z(s)`, extended by its residue `-1` at `s = 0`. -/
noncomputable def poleExtensionZero : ℂ → ℂ :=
  Function.update (fun s : ℂ => s * completedZeta s) 0 (-1)

theorem poleExtensionZero_apply_ne {s : ℂ} (hs : s ≠ 0) :
    poleExtensionZero s = s * completedZeta s :=
  Function.update_of_ne hs _ _

theorem poleExtensionZero_zero : poleExtensionZero 0 = -1 :=
  Function.update_self ..

/-- The extension at `1` is analytic there. -/
theorem analyticAt_poleExtensionOne {U : Set ℂ} (hU : IsOpen U)
    (hZ : DifferentiableOn ℂ completedZeta U) (h1U : (1 : ℂ) ∈ U) :
    AnalyticAt ℂ poleExtensionOne 1 := by
  apply Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
  · filter_upwards [nhdsWithin_le_nhds (hU.mem_nhds h1U), self_mem_nhdsWithin]
      with s hsU hsne
    have hfe : poleExtensionOne =ᶠ[𝓝 s] fun y : ℂ => (y - 1) * completedZeta y := by
      filter_upwards [isOpen_compl_singleton.mem_nhds (by simpa using hsne)] with y hy
      exact poleExtensionOne_apply_ne hy
    exact ((differentiableAt_id.sub_const 1).mul (hZ.differentiableAt (hU.mem_nhds hsU))).congr_of_eventuallyEq hfe
  · rw [continuousAt_iff_punctured_nhds]
    have hev : poleExtensionOne =ᶠ[𝓝[≠] 1] fun s : ℂ => (s - 1) * completedZeta s := by
      filter_upwards [self_mem_nhdsWithin] with s hsne
      exact poleExtensionOne_apply_ne (by simpa using hsne)
    rw [poleExtensionOne_one]
    exact completedZeta_residue_one.congr' hev.symm

/-- The extension at `0` is analytic there. -/
theorem analyticAt_poleExtensionZero {U : Set ℂ} (hU : IsOpen U)
    (hZ : DifferentiableOn ℂ completedZeta U) (h0U : (0 : ℂ) ∈ U) :
    AnalyticAt ℂ poleExtensionZero 0 := by
  apply Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
  · filter_upwards [nhdsWithin_le_nhds (hU.mem_nhds h0U), self_mem_nhdsWithin]
      with s hsU hsne
    have hfe : poleExtensionZero =ᶠ[𝓝 s] fun y : ℂ => y * completedZeta y := by
      filter_upwards [isOpen_compl_singleton.mem_nhds (by simpa using hsne)] with y hy
      exact poleExtensionZero_apply_ne hy
    exact (differentiableAt_id.mul (hZ.differentiableAt (hU.mem_nhds hsU))).congr_of_eventuallyEq hfe
  · rw [continuousAt_iff_punctured_nhds]
    have hev : poleExtensionZero =ᶠ[𝓝[≠] 0] fun s : ℂ => s * completedZeta s := by
      filter_upwards [self_mem_nhdsWithin] with s hsne
      exact poleExtensionZero_apply_ne (by simpa using hsne)
    rw [poleExtensionZero_zero]
    exact completedZeta_residue_zero.congr' hev.symm

/-- **Residue of `Z'/Z` at the pole `1`** is `-1`. -/
theorem tendsto_sub_mul_logDeriv_completedZeta_pole_one {U : Set ℂ} (hU : IsOpen U)
    (hZ : DifferentiableOn ℂ completedZeta U) (h1U : (1 : ℂ) ∈ U) :
    Tendsto (fun s : ℂ => (s - 1) * logDeriv completedZeta s) (𝓝[≠] 1) (𝓝 (-1)) := by
  apply tendsto_sub_mul_logDeriv_of_simple_pole (f := completedZeta) (F := poleExtensionOne) (p := 1) (c := 1)
  · exact analyticAt_poleExtensionOne hU hZ h1U
  · exact poleExtensionOne_one
  · norm_num
  · intro s hs
    rw [poleExtensionOne_apply_ne hs]
    field_simp [sub_ne_zero.mpr hs]

/-- **Residue of `Z'/Z` at the pole `0`** is `-1`. -/
theorem tendsto_mul_logDeriv_completedZeta_pole_zero {U : Set ℂ} (hU : IsOpen U)
    (hZ : DifferentiableOn ℂ completedZeta U) (h0U : (0 : ℂ) ∈ U) :
    Tendsto (fun s : ℂ => s * logDeriv completedZeta s) (𝓝[≠] 0) (𝓝 (-1)) := by
  have h := tendsto_sub_mul_logDeriv_of_simple_pole (f := completedZeta) (F := poleExtensionZero)
    (p := 0) (c := -1) (analyticAt_poleExtensionZero hU hZ h0U) poleExtensionZero_zero (by norm_num)
    (fun s hs => by
      rw [poleExtensionZero_apply_ne hs]
      field_simp [hs]
      ring)
  simpa using h



/-- **Subtracting the residue at a simple zero (closed form).**  If `f` has a
simple zero at `ρ` and `h` is analytic there, then there is an analytic germ
`ψ` at `ρ` which agrees off `ρ` with `(f'/f)·h - h(ρ)/(s-ρ)`.  The witness is
the explicit closed expression `dslope h ρ + h·(logDeriv g)`, where `f = (s-ρ)g`
is the local factorisation.  This is the local step of the residue decomposition
for the test-function explicit formula. -/
theorem exists_analyticAt_logDeriv_mul_sub_residue {f h : ℂ → ℂ} {ρ : ℂ}
    (hf : AnalyticAt ℂ f ρ) (h0 : f ρ = 0) (h1 : deriv f ρ ≠ 0)
    (hh : AnalyticAt ℂ h ρ) :
    ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ ρ ∧
      ψ =ᶠ[𝓝[≠] ρ] fun s : ℂ => logDeriv f s * h s - h ρ * (s - ρ)⁻¹ := by
  obtain ⟨g, hg, hg0, hfg⟩ :=
    AbsoluteHodgeRectangle.AnalyticAt.exists_eventuallyEq_sub_mul hf h0 h1
  have hk : AnalyticAt ℂ (dslope h ρ) ρ := by
    obtain ⟨p, hp⟩ := hh
    exact ⟨p.fslope, HasFPowerSeriesAt.has_fpower_series_dslope_fslope hp⟩
  have hg_an : AnalyticAt ℂ (logDeriv g) ρ := by
    have hfun : logDeriv g = fun s : ℂ => deriv g s / g s := by
      funext s
      rw [logDeriv_apply]
    rw [hfun]
    exact hg.deriv.div hg hg0
  refine ⟨fun s : ℂ => dslope h ρ s + h s * logDeriv g s, hk.add (hh.mul hg_an), ?_⟩
  rw [Filter.eventuallyEq_iff_exists_mem] at hfg
  obtain ⟨V, hV, hVeq⟩ := hfg
  obtain ⟨ε, hε, hball⟩ := Metric.mem_nhds_iff.mp hV
  have hgne : ∀ᶠ s : ℂ in 𝓝 ρ, g s ≠ 0 := hg.continuousAt.eventually_ne hg0
  have hgan : ∀ᶠ s : ℂ in 𝓝 ρ, AnalyticAt ℂ g s := hg.eventually_analyticAt
  rw [Filter.eventuallyEq_iff_exists_mem]
  refine ⟨(Metric.ball ρ ε ∩ {s | AnalyticAt ℂ g s} ∩ {s | g s ≠ 0}) ∩ {s | s ≠ ρ}, ?_, ?_⟩
  · have hmem : (Metric.ball ρ ε ∩ {s | AnalyticAt ℂ g s} ∩ {s | g s ≠ 0}) ∈ 𝓝 ρ :=
      Filter.inter_mem (Filter.inter_mem
        (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hε)) hgan) hgne
    exact Filter.inter_mem (nhdsWithin_le_nhds hmem) self_mem_nhdsWithin
  · intro s hs
    obtain ⟨⟨⟨hsball, hgs_an⟩, hgs_ne⟩, hsne⟩ := hs
    have hsne' : s ≠ ρ := by simpa using hsne
    have hVs : V ∈ 𝓝 s := Filter.mem_of_superset (Metric.isOpen_ball.mem_nhds hsball) hball
    have hev_s : f =ᶠ[𝓝 s] fun y => (y - ρ) * g y := Filter.eventually_of_mem hVs hVeq
    have hlog := AbsoluteHodgeSymbol.logDeriv_eq_inv_add hev_s hsne' hgs_ne hgs_an.differentiableAt
    have hh_decomp : h s = h ρ + (s - ρ) * dslope h ρ s := by
      have hsub := sub_smul_dslope h ρ s
      simp only [smul_eq_mul] at hsub
      rw [show (s - ρ) * dslope h ρ s = h s - h ρ from hsub]
      ring
    show dslope h ρ s + h s * logDeriv g s
      = logDeriv f s * h s - h ρ * (s - ρ)⁻¹
    rw [hlog, hh_decomp]
    field_simp [sub_ne_zero.mpr hsne']
    ring


/-- **Subtracting the residue at a simple pole (closed form).**  If `f = F/(s-p)`
off `p` with `F` analytic and `F p = c ≠ 0`, and `h` is analytic at `p`, then
the germ `h·logDeriv F - dslope h p` is analytic at `p` and agrees off `p` with
`(f'/f)·h + h(p)/(s-p)`. -/
theorem exists_analyticAt_logDeriv_mul_add_residue_pole {f F h : ℂ → ℂ} {p c : ℂ}
    (hF : AnalyticAt ℂ F p) (hFc : F p = c) (hc : c ≠ 0)
    (hf : ∀ s : ℂ, s ≠ p → f s = F s / (s - p))
    (hh : AnalyticAt ℂ h p) :
    ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ p ∧
      ψ =ᶠ[𝓝[≠] p] fun s : ℂ => logDeriv f s * h s + h p * (s - p)⁻¹ := by
  have hFp_ne : F p ≠ 0 := by rw [hFc]; exact hc
  have hF_an : AnalyticAt ℂ (logDeriv F) p := by
    have hfun : logDeriv F = fun s : ℂ => deriv F s / F s := by
      funext s
      rw [logDeriv_apply]
    rw [hfun]
    exact hF.deriv.div hF hFp_ne
  have hk : AnalyticAt ℂ (dslope h p) p := by
    obtain ⟨q, hq⟩ := hh
    exact ⟨q.fslope, HasFPowerSeriesAt.has_fpower_series_dslope_fslope hq⟩
  refine ⟨fun s : ℂ => h s * logDeriv F s - dslope h p s, hh.mul hF_an |>.sub hk, ?_⟩
  have hFne : ∀ᶠ s : ℂ in 𝓝 p, F s ≠ 0 := hF.continuousAt.eventually_ne hFp_ne
  have hFan : ∀ᶠ s : ℂ in 𝓝 p, AnalyticAt ℂ F s := hF.eventually_analyticAt
  rw [Filter.eventuallyEq_iff_exists_mem]
  refine ⟨{s | AnalyticAt ℂ F s} ∩ {s | F s ≠ 0} ∩ {s | s ≠ p}, ?_, ?_⟩
  · have hmem : ({s | AnalyticAt ℂ F s} ∩ {s | F s ≠ 0}) ∈ 𝓝 p :=
      Filter.inter_mem hFan hFne
    exact Filter.inter_mem (nhdsWithin_le_nhds hmem) self_mem_nhdsWithin
  · intro s hs
    obtain ⟨⟨hFs_an, hFs_ne⟩, hsne⟩ := hs
    have hsne' : s ≠ p := by simpa using hsne
    have hfs : f =ᶠ[𝓝 s] fun y => F y / (y - p) := by
      filter_upwards [isOpen_compl_singleton.mem_nhds hsne'] with y hy
      exact hf y hy
    have hfun : (fun y : ℂ => F y / (y - p)) = F / (fun y : ℂ => y - p) := by
      funext y
      rfl
    have hlog : logDeriv f s = logDeriv F s - (s - p)⁻¹ := by
      rw [(logDeriv_congr_nhds hfs).eq_of_nhds, hfun]
      rw [logDeriv_div (𝕜 := ℂ) (f := F) (g := fun y : ℂ => y - p) s hFs_ne
        (sub_ne_zero.mpr hsne') hFs_an.differentiableAt (differentiableAt_id.sub_const p)]
      rw [logDeriv_sub_const p s hsne']
    have hh_decomp : h s = h p + (s - p) * dslope h p s := by
      have hsub := sub_smul_dslope h p s
      simp only [smul_eq_mul] at hsub
      rw [show (s - p) * dslope h p s = h s - h p from hsub]
      ring
    show h s * logDeriv F s - dslope h p s
      = logDeriv f s * h s + h p * (s - p)⁻¹
    rw [hlog, hh_decomp]
    field_simp [sub_ne_zero.mpr hsne']
    ring

/-- Zeta instance at the pole `1`, for any test function analytic at `1`. -/
theorem exists_analyticAt_logDeriv_completedZeta_add_residue_pole_one {U : Set ℂ}
    {h : ℂ → ℂ} (hU : IsOpen U) (hZ : DifferentiableOn ℂ completedZeta U)
    (h1U : (1 : ℂ) ∈ U) (hh : AnalyticAt ℂ h 1) :
    ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ 1 ∧
      ψ =ᶠ[𝓝[≠] 1] fun s : ℂ => logDeriv completedZeta s * h s + h 1 * (s - 1)⁻¹ := by
  refine exists_analyticAt_logDeriv_mul_add_residue_pole (f := completedZeta)
    (F := poleExtensionOne) (p := 1) (c := 1) (analyticAt_poleExtensionOne hU hZ h1U)
    poleExtensionOne_one (by norm_num) ?_ hh
  intro s hs
  rw [poleExtensionOne_apply_ne hs]
  field_simp [sub_ne_zero.mpr hs]

/-- Zeta instance at the pole `0`, for any test function analytic at `0`. -/
theorem exists_analyticAt_logDeriv_completedZeta_add_residue_pole_zero {U : Set ℂ}
    {h : ℂ → ℂ} (hU : IsOpen U) (hZ : DifferentiableOn ℂ completedZeta U)
    (h0U : (0 : ℂ) ∈ U) (hh : AnalyticAt ℂ h 0) :
    ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ 0 ∧
      ψ =ᶠ[𝓝[≠] 0] fun s : ℂ => logDeriv completedZeta s * h s + h 0 * (s - 0)⁻¹ := by
  refine exists_analyticAt_logDeriv_mul_add_residue_pole (f := completedZeta)
    (F := poleExtensionZero) (p := 0) (c := -1) (analyticAt_poleExtensionZero hU hZ h0U)
    poleExtensionZero_zero (by norm_num) ?_ hh
  intro s hs
  rw [poleExtensionZero_apply_ne hs]
  field_simp [hs]
  ring


/-- **Pole-free form of `Z'/Z`.**  For `F(s) = s(s-1)Z(s)` and `s ≠ 0,1` with
`Z(s) ≠ 0`, `Z'/Z = F'/F - 1/s - 1/(s-1)`.  This turns the pole terms of the
global remainder into the analytic divided slopes `dslope h 0`, `dslope h 1`. -/
theorem logDeriv_completedZeta_eq_logDeriv_poleExtension {s : ℂ}
    (hs0 : s ≠ 0) (hs1 : s ≠ 1) (hZ : completedZeta s ≠ 0)
    (hZdiff : DifferentiableAt ℂ completedZeta s) :
    logDeriv completedZeta s
      = logDeriv (fun z : ℂ => z * (z - 1) * completedZeta z) s - s⁻¹ - (s - 1)⁻¹ := by
  have hfun : (fun z : ℂ => z * (z - 1) * completedZeta z)
      = (fun z : ℂ => z) * (fun z : ℂ => z - 1) * completedZeta := rfl
  rw [hfun]
  rw [logDeriv_mul (𝕜 := ℂ) (f := (fun z : ℂ => z) * (fun z : ℂ => z - 1))
    (g := completedZeta) s (mul_ne_zero hs0 (sub_ne_zero.mpr hs1)) hZ
    (differentiableAt_id.mul (differentiableAt_id.sub_const 1)) hZdiff]
  rw [logDeriv_mul (𝕜 := ℂ) (f := fun z : ℂ => z) (g := fun z : ℂ => z - 1) s hs0
    (sub_ne_zero.mpr hs1) differentiableAt_id (differentiableAt_id.sub_const 1)]
  have hid : logDeriv (fun z : ℂ => z) s = s⁻¹ := by
    simpa [one_div] using logDeriv_id s
  have hsub : logDeriv (fun z : ℂ => z - 1) s = (s - 1)⁻¹ :=
    logDeriv_sub_const 1 s hs1
  rw [hid, hsub]
  ring


/-- The divided slope of an analytic function is differentiable everywhere. -/
theorem differentiableAt_dslope_of_analyticAt {h : ℂ → ℂ} {a z : ℂ}
    (hh : AnalyticAt ℂ h z) : DifferentiableAt ℂ (dslope h a) z := by
  rcases eq_or_ne z a with rfl | hne
  · obtain ⟨p, hp⟩ := hh
    exact (show AnalyticAt ℂ (dslope h z) z from
      ⟨p.fslope, HasFPowerSeriesAt.has_fpower_series_dslope_fslope hp⟩).differentiableAt
  · exact (differentiableAt_dslope_of_ne hne).mpr hh.differentiableAt

/-- The logarithmic derivative of a nonzero analytic function is
differentiable. -/
theorem differentiableAt_logDeriv_of_analyticAt {F : ℂ → ℂ} {z : ℂ}
    (hF : AnalyticAt ℂ F z) (hFz : F z ≠ 0) :
    DifferentiableAt ℂ (logDeriv F) z := by
  have hfun : logDeriv F =ᶠ[𝓝 z] fun s : ℂ => deriv F s / F s := by
    filter_upwards [hF.eventually_analyticAt, hF.continuousAt.eventually_ne hFz]
      with s hs hsne
    rw [logDeriv_apply]
  have hd : DifferentiableAt ℂ (fun s : ℂ => deriv F s / F s) z :=
    (hF.deriv.differentiableAt).div hF.differentiableAt hFz
  exact hd.congr_of_eventuallyEq hfun.symm


/-- **Differentiability of the global remainder off the zero set.**  For
`F(s) = s(s-1)Z(s)`, the function
`h·F'/F - ∑_{ρ∈S} h(ρ)/(s-ρ) - dslope h 0 - dslope h 1`
is differentiable on `U ∖ S`. -/
theorem differentiableOn_globalRemainder {U : Set ℂ} (h : ℂ → ℂ) (S : Finset ℂ)
    (hU : IsOpen U) (hh : DifferentiableOn ℂ h U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0) :
    DifferentiableOn ℂ (fun z : ℂ =>
        h z * logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
          - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z) (U \ ↑S) := by
  intro z hz
  have hzU : z ∈ U := hz.1
  have hz_notS : z ∉ S := by simpa using hz.2
  have h_an : AnalyticAt ℂ h z := (hh.analyticOnNhd hU) z hzU
  have hF_an : AnalyticAt ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) z :=
    (hF.analyticOnNhd hU) z hzU
  have hFz_ne : z * (z - 1) * completedZeta z ≠ 0 := hF_ne z hzU hz_notS
  have hlog : DifferentiableAt ℂ
      (logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s)) z :=
    differentiableAt_logDeriv_of_analyticAt hF_an hFz_ne
  have hsum_fun : DifferentiableAt ℂ (∑ ρ ∈ S, fun z : ℂ => h ρ * (z - ρ)⁻¹) z := by
    apply DifferentiableAt.sum
    intro ρ hρ
    exact ((differentiableAt_id.sub_const ρ).inv
      (sub_ne_zero.mpr (by
        intro h
        simp only [id_eq] at h
        exact hz_notS (h ▸ hρ)))).const_mul (h ρ)
  have hsum : DifferentiableAt ℂ (fun z : ℂ => ∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) z := by
    convert hsum_fun using 1
    funext z
    simp [Finset.sum_apply]
  have hd0 := differentiableAt_dslope_of_analyticAt (a := 0) h_an
  have hd1 := differentiableAt_dslope_of_analyticAt (a := 1) h_an
  have hmain : DifferentiableAt ℂ (fun z : ℂ =>
      h z * logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
        - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z) z := by
    convert (((h_an.differentiableAt.mul hlog).sub hsum).sub hd0).sub hd1 using 1
  exact hmain.differentiableWithinAt


/-- The divided slope of an analytic function is analytic everywhere. -/
theorem analyticAt_dslope_of_analyticAt {h : ℂ → ℂ} {a z : ℂ}
    (hh : AnalyticAt ℂ h z) : AnalyticAt ℂ (dslope h a) z := by
  rcases eq_or_ne z a with rfl | hne
  · obtain ⟨p, hp⟩ := hh
    exact ⟨p.fslope, HasFPowerSeriesAt.has_fpower_series_dslope_fslope hp⟩
  · have hfun : dslope h a =ᶠ[𝓝 z] fun y : ℂ => (h y - h a) * (y - a)⁻¹ := by
      filter_upwards [isOpen_compl_singleton.mem_nhds hne] with y hy
      have hya : y ≠ a := by simpa using hy
      rw [dslope_of_ne (f := h) (a := a) (b := y) hya]
      rw [slope_def_field, div_eq_mul_inv]
    refine AnalyticAt.congr ?_ hfun.symm
    exact (hh.sub analyticAt_const).mul
      ((analyticAt_id.sub analyticAt_const).inv (sub_ne_zero.mpr hne))



/-- A finite sum of analytic functions is analytic. -/
theorem analyticAt_finset_sum {ι : Type*} (s : Finset ι) (A : ι → ℂ → ℂ) {z : ℂ}
    (h : ∀ i ∈ s, AnalyticAt ℂ (A i) z) :
    AnalyticAt ℂ (fun w : ℂ => ∑ i ∈ s, A i w) z := by
  classical
  induction s using Finset.induction_on with
  | empty =>
    simpa using (analyticAt_const : AnalyticAt ℂ (fun _ : ℂ => (0 : ℂ)) z)
  | insert a s ha ih =>
    simp only [Finset.sum_insert ha]
    have h1 := h a (Finset.mem_insert_self a s)
    have h2 := ih (fun i hi => h i (Finset.mem_insert_of_mem hi))
    have hsum' := h1.add h2
    convert hsum' using 1

/-- **The global remainder is analytic.**  For `F(s) = s(s-1)Z(s)`, if `F` is
differentiable on an open `U`, vanishes simply at the finite set `S`, and is
nonzero off `S`, and `h` is differentiable on `U`, then the remainder
`h·F'/F - ∑_{ρ∈S} h(ρ)/(s-ρ) - dslope h 0 - dslope h 1` has an analytic
extension on `U` agreeing with it off `S`. -/
theorem exists_analyticOnNhd_globalRemainder {U : Set ℂ} (h : ℂ → ℂ) (S : Finset ℂ)
    (hU : IsOpen U) (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0) :
    ∃ Ψ : ℂ → ℂ, AnalyticOnNhd ℂ Ψ U ∧ ∀ z ∈ U, z ∉ S →
      Ψ z = h z * logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
        - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z := by
  classical
  have hdiff := differentiableOn_globalRemainder h S hU hh hF hF_ne
  have hgerm : ∀ ρ ∈ S, ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ ρ ∧
      ψ =ᶠ[𝓝[≠] ρ] (fun z : ℂ =>
        h z * logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
          - (∑ ρ' ∈ S, h ρ' * (z - ρ')⁻¹) - dslope h 0 z - dslope h 1 z) := by
    intro ρ hρ
    have hρU : ρ ∈ U := hSU ρ hρ
    have h_an : AnalyticAt ℂ h ρ := (hh.analyticOnNhd hU) ρ hρU
    have hF_an : AnalyticAt ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) ρ :=
      (hF.analyticOnNhd hU) ρ hρU
    have hρ0 : ρ ≠ 0 := by
      intro h
      exact h0_notS (h ▸ hρ)
    have hρ1 : ρ ≠ 1 := by
      intro h
      exact h1_notS (h ▸ hρ)
    have hF_zero : (fun s : ℂ => s * (s - 1) * completedZeta s) ρ = 0 := by
      show ρ * (ρ - 1) * completedZeta ρ = 0
      rw [hZ_zero ρ hρ]
      ring
    have hF_simple' := hF_simple ρ hρ
    obtain ⟨ψ, hψ_an, hψ_eq⟩ :=
      exists_analyticAt_logDeriv_mul_sub_residue hF_an hF_zero hF_simple' h_an
    refine ⟨fun z : ℂ => ψ z - (∑ ρ' ∈ S.erase ρ, h ρ' * (z - ρ')⁻¹)
      - dslope h 0 z - dslope h 1 z, ?_, ?_⟩
    · refine ((hψ_an.sub ?_).sub (analyticAt_dslope_of_analyticAt (a := 0) h_an)).sub
        (analyticAt_dslope_of_analyticAt (a := 1) h_an)
      apply analyticAt_finset_sum
      intro ρ' hρ'
      obtain ⟨hρ'ne, hρ'S⟩ := Finset.mem_erase.mp hρ'
      have hinv : AnalyticAt ℂ (fun x : ℂ => (x - ρ')⁻¹) ρ :=
        (analyticAt_id.sub analyticAt_const).inv (sub_ne_zero.mpr (Ne.symm hρ'ne))
      have hconst : AnalyticAt ℂ (fun _ : ℂ => h ρ') ρ := analyticAt_const
      have hmul : AnalyticAt ℂ (fun x : ℂ => h ρ' * (x - ρ')⁻¹) ρ := hconst.mul hinv
      simpa [Pi.mul_apply] using hmul
    · filter_upwards [hψ_eq] with z hz
      have hsum_split : (∑ ρ' ∈ S, h ρ' * (z - ρ')⁻¹)
          = h ρ * (z - ρ)⁻¹ + ∑ ρ' ∈ S.erase ρ, h ρ' * (z - ρ')⁻¹ := by
        rw [← Finset.insert_erase hρ, Finset.sum_insert (Finset.notMem_erase ρ S),
          Finset.erase_insert (Finset.notMem_erase ρ S)]
      rw [hz, hsum_split]
      ring
  exact exists_analyticOnNhd_of_differentiableOn_compl_finset hU S hSU hdiff hgerm


/-- **Boundary decomposition of the test-function integrand.**  For `z ≠ 0,1` off
the zero set, the meromorphic integrand equals the analytic remainder plus the
residue fractions. -/
theorem logDeriv_mul_eq_remainder_plus_residues {h : ℂ → ℂ} {S : Finset ℂ} {z : ℂ}
    (hz0 : z ≠ 0) (hz1 : z ≠ 1) (hzS : z ∉ S)
    (hZ : DifferentiableAt ℂ completedZeta z) (hZne : completedZeta z ≠ 0) :
    logDeriv completedZeta z * h z
      = (h z * logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
          - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z)
        + (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - h 0 * z⁻¹ - h 1 * (z - 1)⁻¹ := by
  have hfun : (fun s : ℂ => s * (s - 1) * completedZeta s)
      = (fun s : ℂ => s) * (fun s : ℂ => s - 1) * completedZeta := rfl
  have hlog : logDeriv completedZeta z
      = logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z - z⁻¹ - (z - 1)⁻¹ := by
    rw [hfun]
    rw [logDeriv_mul (𝕜 := ℂ) (f := (fun s : ℂ => s) * (fun s : ℂ => s - 1))
      (g := completedZeta) z (mul_ne_zero hz0 (sub_ne_zero.mpr hz1)) hZne
      (differentiableAt_id.mul (differentiableAt_id.sub_const 1)) hZ]
    rw [logDeriv_mul (𝕜 := ℂ) (f := fun s : ℂ => s) (g := fun s : ℂ => s - 1) z hz0
      (sub_ne_zero.mpr hz1) differentiableAt_id (differentiableAt_id.sub_const 1)]
    have hid : logDeriv (fun s : ℂ => s) z = z⁻¹ := by
      simpa [one_div] using logDeriv_id z
    have hsub : logDeriv (fun s : ℂ => s - 1) z = (z - 1)⁻¹ :=
      logDeriv_sub_const 1 z hz1
    rw [hid, hsub]
    ring
  -- the two divided-slope decompositions
  have hdec0 : h z = h 0 + z * dslope h 0 z := by
    have hsub := sub_smul_dslope h 0 z
    simp only [smul_eq_mul, sub_zero] at hsub
    rw [show z * dslope h 0 z = h z - h 0 from hsub]
    ring
  have hdec1 : h z = h 1 + (z - 1) * dslope h 1 z := by
    have hsub := sub_smul_dslope h 1 z
    simp only [smul_eq_mul] at hsub
    rw [show (z - 1) * dslope h 1 z = h z - h 1 from hsub]
    ring
  have e0 : h z * z⁻¹ = h 0 * z⁻¹ + dslope h 0 z := by
    rw [hdec0, add_mul]
    congr 1
    field_simp [hz0]
  have e1 : h z * (z - 1)⁻¹ = h 1 * (z - 1)⁻¹ + dslope h 1 z := by
    rw [hdec1, add_mul]
    congr 1
    field_simp [sub_ne_zero.mpr hz1]
  rw [hlog]
  linear_combination -e0 - e1


/-- **Test-function explicit formula.**  For `h` differentiable on an open `U`
containing the closed rectangle, with `F = s(s-1)Z` differentiable on `U` and its
zeros in the rectangle exactly the finite set `S` (simple, not containing
`0,1`), and `Z` differentiable off `0,1`,

`∮ (Z'/Z)(z)·h(z) dz = 2πi·(∑_{ρ∈S} h(ρ) - h(0) - h(1))`.

This is the classical explicit formula with a test function, for the zero side. -/
theorem test_function_explicit_formula {U : Set ℂ} (h : ℂ → ℂ) (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I) := by
  classical
  obtain ⟨Ψ, hΨ_an, hΨ_eq⟩ :=
    exists_analyticOnNhd_globalRemainder h S hU hSU h0_notS h1_notS hh hF hZ_zero
      hF_simple hF_ne
  -- the combined index set and coefficients
  let S' : Finset ℂ := insert 0 (insert 1 S)
  let c : ℂ → ℂ := fun w => if w = 0 then -h 0 else if w = 1 then -h 1 else h w
  have hS'_in : ∀ w ∈ S', x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂ := by
    intro w hw
    simp only [S', Finset.mem_insert] at hw
    rcases hw with rfl | rfl | hw
    · exact h0_in
    · exact h1_in
    · exact hS_in w hw
  have hΨ_cont : ContinuousOn Ψ (rectBoundarySet x₁ x₂ y₁ y₂) :=
    hΨ_an.continuousOn.mono (fun z hz => hsub hz.1)
  have hfr_cont : ∀ w ∈ S', ContinuousOn (fun z : ℂ => c w * (z - w)⁻¹)
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    intro w hw
    apply ContinuousOn.const_mul
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz h
      have hzw : z = w := sub_eq_zero.mp h
      rw [hzw] at hz
      rcases hz.2 with h' | h' | h' | h'
      · linarith [(hS'_in w hw).1, h']
      · linarith [(hS'_in w hw).2.1, h']
      · linarith [(hS'_in w hw).2.2.1, h']
      · linarith [(hS'_in w hw).2.2.2, h']
  have hΨ_int : rectIntegral Ψ x₁ x₂ y₁ y₂ = 0 :=
    rectIntegral_eq_zero_of_differentiableOn Ψ x₁ x₂ y₁ y₂
      (hΨ_an.continuousOn.mono hsub)
      (hΨ_an.differentiableOn.mono (fun z hz =>
        hsub ⟨Ioo_subset_Icc_self hz.1, Ioo_subset_Icc_self hz.2⟩))
  -- the sum over S' equals the poles plus the zero residues
  have hsum_eq : ∀ z : ℂ, (∑ w ∈ S', c w * (z - w)⁻¹)
      = (-h 0) * z⁻¹ + (-h 1) * (z - 1)⁻¹ + ∑ ρ ∈ S, h ρ * (z - ρ)⁻¹ := by
    intro z
    have hc0 : c 0 = -h 0 := by simp [c]
    have hc1 : c 1 = -h 1 := by simp [c]
    have hcS : ∀ ρ ∈ S, c ρ = h ρ := by
      intro ρ hρ
      simp only [c]
      rw [if_neg (by intro h; exact h0_notS (h ▸ hρ)),
        if_neg (by intro h; exact h1_notS (h ▸ hρ))]
    have hsum_c : (∑ x ∈ S, c x * (z - x)⁻¹) = ∑ x ∈ S, h x * (z - x)⁻¹ := by
      apply Finset.sum_congr rfl
      intro x hx
      rw [hcS x hx]
    rw [show S' = insert 0 (insert 1 S) from rfl]
    rw [Finset.sum_insert (by simp [h0_notS]), Finset.sum_insert (by simp [h1_notS]),
      hc0, hc1, hsum_c]
    simp only [sub_zero]
    ring
  have hdecomp : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv completedZeta z * h z = Ψ z + ∑ w ∈ S', c w * (z - w)⁻¹ := by
    intro z hz
    have hzU : z ∈ U := hsub hz.1
    have hzS : z ∉ S := by
      intro hzS
      obtain ⟨h1', h2', h3', h4'⟩ := hS_in z hzS
      rcases hz.2 with h' | h' | h' | h'
      · linarith
      · linarith
      · linarith
      · linarith
    have hz0 : z ≠ 0 := by
      intro h
      rcases hz.2 with h' | h' | h' | h'
      · have : (0 : ℂ).re = x₁ := by rw [← h]; exact h'
        simp at this
        linarith [h0_in.1]
      · have : (0 : ℂ).re = x₂ := by rw [← h]; exact h'
        simp at this
        linarith [h0_in.2.1]
      · have : (0 : ℂ).im = y₁ := by rw [← h]; exact h'
        simp at this
        linarith [h0_in.2.2.1]
      · have : (0 : ℂ).im = y₂ := by rw [← h]; exact h'
        simp at this
        linarith [h0_in.2.2.2]
    have hz1 : z ≠ 1 := by
      intro h
      rcases hz.2 with h' | h' | h' | h'
      · have : (1 : ℂ).re = x₁ := by rw [← h]; exact h'
        simp at this
        linarith [h1_in.1]
      · have : (1 : ℂ).re = x₂ := by rw [← h]; exact h'
        simp at this
        linarith [h1_in.2.1]
      · have : (1 : ℂ).im = y₁ := by rw [← h]; exact h'
        simp at this
        linarith [h1_in.2.2.1]
      · have : (1 : ℂ).im = y₂ := by rw [← h]; exact h'
        simp at this
        linarith [h1_in.2.2.2]
    have hZ_at : DifferentiableAt ℂ completedZeta z := by
      have hclosed : IsClosed ({0, 1} : Set ℂ) :=
        (Set.finite_singleton 0 |>.union (Set.finite_singleton 1)).isClosed
      exact (hZ.differentiableAt ((hU.sdiff hclosed).mem_nhds ⟨hzU, by simp [hz0, hz1]⟩))
    have hZ_ne : completedZeta z ≠ 0 := by
      intro h
      apply hF_ne z hzU hzS
      rw [h]
      ring
    have hbase := logDeriv_mul_eq_remainder_plus_residues (h := h) (S := S)
      hz0 hz1 hzS hZ_at hZ_ne
    rw [← hΨ_eq z hzU hzS] at hbase
    rw [hbase, hsum_eq z]
    ring
  have hmain := rectIntegral_logDeriv_mul_eq_residue_sum (Z := completedZeta) (h := h)
    S' c x₁ x₂ y₁ y₂ hS'_in hΨ_cont hfr_cont hdecomp hΨ_int
  rw [hmain]
  have hc_sum : (∑ w ∈ S', c w) = -h 0 - h 1 + ∑ ρ ∈ S, h ρ := by
    have hc0 : c 0 = -h 0 := by simp [c]
    have hc1 : c 1 = -h 1 := by simp [c]
    have hcS : ∀ ρ ∈ S, c ρ = h ρ := by
      intro ρ hρ
      simp only [c]
      rw [if_neg (by intro h; exact h0_notS (h ▸ hρ)),
        if_neg (by intro h; exact h1_notS (h ▸ hρ))]
    have hsum_c : (∑ x ∈ S, c x) = ∑ x ∈ S, h x := by
      apply Finset.sum_congr rfl
      intro x hx
      rw [hcS x hx]
    rw [show S' = insert 0 (insert 1 S) from rfl]
    rw [Finset.sum_insert (by simp [h0_notS]), Finset.sum_insert (by simp [h1_notS]),
      hc0, hc1, hsum_c]
    ring
  rw [hc_sum]
  ring


/-- **Test-function formula for `h(s) = s`**: the sum of the zeros minus the
pole contribution `h(1) = 1` (the `h(0) = 0` term vanishes). -/
theorem test_function_explicit_formula_linear {U : Set ℂ} (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, ρ) - 0 - 1) * (2 * (Real.pi : ℂ) * I) := by
  have h := test_function_explicit_formula (h := fun s : ℂ => s) S x₁ x₂ y₁ y₂ hU hsub
    hSU h0_notS h1_notS differentiable_id.differentiableOn hF hZ hZ_zero hF_simple
    hF_ne h0_in h1_in hS_in
  simpa using h


/-- **Pointwise prime-side identity with a test function.**  On `Re s > 1`,
multiplying the symbol identity by `h(s)·i` gives
`Z'/Z·h·i = -(arch·h·i + L_Λ·h·i)`.  This is the pointwise input for the
prime/archimedean side of the explicit formula with a test function. -/
theorem logDeriv_mul_I_eq_neg_arch_add_prime {h : ℂ → ℂ} {s : ℂ} (hs : 1 < s.re) :
    logDeriv completedZeta s * h s * I
      = - (((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma (s / 2)) * h s * I
          + LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s * h s * I) := by
  have hid := symbol_identity hs
  linear_combination (h s * I) * hid


/-- **Integrated prime-side identity with a test function.**  For `c > 1` and
`h : ℂ → ℂ`, integrating the pointwise symbol identity along the vertical line
gives
`∫ Z'/Z·h·i = -(∫ arch·h·i) - (∫ L_Λ·h·i)`.
Continuity of the archimedean factor is assumed (digamma continuity on the
line), as is that of the prime factor. -/
theorem integral_logDeriv_mul_I_eq_neg_arch_prime (h : ℂ → ℂ) (c y₁ y₂ : ℝ) (hc : 1 < c)
    (harch : ContinuousOn (fun y : ℝ =>
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
        * h (c + y * I) * I) (uIcc y₁ y₂))
    (hL : ContinuousOn (fun y : ℝ =>
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
        * h (c + y * I) * I) (uIcc y₁ y₂)) :
    (∫ y : ℝ in y₁..y₂, logDeriv completedZeta (c + y * I) * h (c + y * I) * I)
      = - (∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
              * h (c + y * I) * I)
        - (∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
              * h (c + y * I) * I) := by
  have hcongr : (∫ y : ℝ in y₁..y₂,
        logDeriv completedZeta (c + y * I) * h (c + y * I) * I)
      = ∫ y : ℝ in y₁..y₂,
          - (((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
              * h (c + y * I) * I
            + LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
              * h (c + y * I) * I) := by
    apply intervalIntegral.integral_congr
    intro y hy
    have hs : 1 < (c + y * I).re := by simpa using hc
    exact logDeriv_mul_I_eq_neg_arch_add_prime (h := h) hs
  rw [hcongr, intervalIntegral.integral_neg]
  have hsplit : (∫ y : ℝ in y₁..y₂,
        (((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
            * h (c + y * I) * I
          + LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
            * h (c + y * I) * I))
      = (∫ y : ℝ in y₁..y₂,
          ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
            * h (c + y * I) * I)
        + ∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
              * h (c + y * I) * I := by
    rw [intervalIntegral.integral_add harch.intervalIntegrable hL.intervalIntegrable]
  rw [hsplit]
  ring


/-- Continuity of the archimedean factor along a vertical line `Re = c > 1`. -/
theorem continuousOn_arch_mul (h : ℂ → ℂ) (c y₁ y₂ : ℝ) (hc : 1 < c)
    (hh : ContinuousOn (fun y : ℝ => h (c + y * I)) (uIcc y₁ y₂)) :
    ContinuousOn (fun y : ℝ =>
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
        * h (c + y * I)) (uIcc y₁ y₂) := by
  have harch : ContinuousOn (fun y : ℝ =>
      (1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2)) (uIcc y₁ y₂) := by
    intro y hy
    have hcomp : ContinuousAt (fun y : ℝ => Complex.digamma ((c + y * I) / 2)) y := by
      apply ContinuousAt.comp (x := y)
      · apply AbsoluteHodgeArchimedean.continuousAt_digamma_of_re_pos
        have hre : ((c + (y : ℂ) * I) / 2).re = c / 2 := by simp [Complex.div_re]
        linarith [hre]
      · exact (((continuous_const.add (Complex.continuous_ofReal.mul continuous_const)).div_const 2)).continuousAt
    exact (continuousAt_const.sub (hcomp.const_mul (1 / 2))).continuousWithinAt
  exact harch.mul hh

/-- The integrated prime-side identity with the archimedean continuity
discharged (only continuity of `h` along the line and of the prime factor is
assumed). -/
theorem integral_logDeriv_mul_I_eq_neg_arch_prime' (h : ℂ → ℂ) (c y₁ y₂ : ℝ) (hc : 1 < c)
    (hh : ContinuousOn (fun y : ℝ => h (c + y * I)) (uIcc y₁ y₂))
    (hL : ContinuousOn (fun y : ℝ =>
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
        * h (c + y * I) * I) (uIcc y₁ y₂)) :
    (∫ y : ℝ in y₁..y₂, logDeriv completedZeta (c + y * I) * h (c + y * I) * I)
      = - (∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
              * h (c + y * I) * I)
        - (∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
              * h (c + y * I) * I) := by
  apply integral_logDeriv_mul_I_eq_neg_arch_prime h c y₁ y₂ hc
  · simpa [mul_assoc] using (continuousOn_arch_mul h c y₁ y₂ hc hh).mul_const I
  · exact hL


/-- **The integrated prime-side identity for the constant test function.** -/
theorem integral_logDeriv_mul_I_eq_neg_arch_prime_const (c y₁ y₂ : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y₁..y₂, logDeriv completedZeta (c + y * I) * I)
      = - (∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2)) * I)
        - (∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) * I) := by
  have h := integral_logDeriv_mul_I_eq_neg_arch_prime' (h := fun _ => 1) c y₁ y₂ hc
    continuousOn_const (by
      exact (continuousOn_lseries_vonMangoldt c y₁ y₂ hc).mul continuousOn_const |>.mul_const I)
  simpa using h


/-- **Pointwise left reflection with a test function**: if `h(1-s) = h(s)`, then
`Z'/Z(1-s)·h(1-s) = -(Z'/Z(s)·h(s))`. -/
theorem logDeriv_mul_one_sub {h : ℂ → ℂ} {s : ℂ}
    (hs0 : s ≠ 0) (hs1 : s ≠ 1) (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) (hg' : ∀ m : ℕ, (1 - s) / 2 ≠ -(m : ℂ))
    (hsym : h (1 - s) = h s) :
    logDeriv completedZeta (1 - s) * h (1 - s)
      = - (logDeriv completedZeta s * h s) := by
  rw [logDeriv_completedZeta_one_sub hs0 hs1 hΓ hΓ' hg hg', hsym]
  ring

/-- **Pointwise conjugation with a test function**: if `h(conj s) = conj(h(s))`,
then `Z'/Z(conj s)·h(conj s) = conj(Z'/Z(s)·h(s))`. -/
theorem logDeriv_mul_conj {h : ℂ → ℂ} {s : ℂ}
    (hs0 : s ≠ 0) (hs1 : s ≠ 1) (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ))
    (hsym : h ((starRingEnd ℂ) s) = (starRingEnd ℂ) (h s)) :
    logDeriv completedZeta ((starRingEnd ℂ) s) * h ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (logDeriv completedZeta s * h s) := by
  rw [AbsoluteHodgeSymbol.logDeriv_completedZeta_conj hs0 hs1 hg, hsym, map_mul]


/-- **Integral left reflection with a symmetric test function**, at `c = 2`:
for `h(1-w) = h(w)` off `0,1`,
`∫ Φ((1-2)+iy)·i dy = -∫ Φ(2+iy)·i dy` with `Φ = (Z'/Z)·h`.  The choice
`c = 2` avoids the `Gammaℝ` edge case at `y = 0`. -/
theorem integral_logDeriv_mul_left_eq_neg_right_two (h : ℂ → ℂ) (T : ℝ)
    (hsym : ∀ w : ℂ, w ≠ 0 → w ≠ 1 → h (1 - w) = h w) :
    (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((-1 : ℂ) + y * I) * h ((-1 : ℂ) + y * I) * I)
      = - (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I) * I) := by
  have hneg : (∫ x : ℝ in (-T)..T,
        logDeriv completedZeta ((-1 : ℂ) + (-x) * I) * h ((-1 : ℂ) + (-x) * I) * I)
      = ∫ x : ℝ in (-T)..T,
          logDeriv completedZeta ((-1 : ℂ) + x * I) * h ((-1 : ℂ) + x * I) * I := by
    have := intervalIntegral.integral_comp_neg
      (f := fun y : ℝ => logDeriv completedZeta ((-1 : ℂ) + y * I)
        * h ((-1 : ℂ) + y * I) * I) (a := -T) (b := T)
    simpa using this
  rw [← hneg]
  rw [← intervalIntegral.integral_neg]
  apply intervalIntegral.integral_congr
  intro y hy
  show logDeriv completedZeta ((-1 : ℂ) + -(y : ℂ) * I)
      * h ((-1 : ℂ) + -(y : ℂ) * I) * I
    = -(logDeriv completedZeta (2 + (y : ℂ) * I) * h (2 + (y : ℂ) * I) * I)
  have harg : ((-1 : ℂ)) + (-(y : ℂ)) * I = 1 - (2 + (y : ℂ) * I) := by ring
  rw [harg]
  have hs0 : (2 + (y : ℂ) * I) ≠ 0 := by
    intro h0
    have hre : (2 + (y : ℂ) * I).re = 2 := by simp
    rw [h0] at hre
    simp at hre
  have hs1 : (2 + (y : ℂ) * I) ≠ 1 := by
    intro h0
    have hre : (2 + (y : ℂ) * I).re = 2 := by simp
    rw [h0] at hre
    simp at hre
  have hΓ : (2 + (y : ℂ) * I).Gammaℝ ≠ 0 := by
    intro h0
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h0
    have hre : (2 + (y : ℂ) * I).re = 2 := by simp
    rw [hn] at hre
    simp at hre
    linarith [show (0:ℝ) ≤ (n:ℝ) from Nat.cast_nonneg n]
  have hΓ' : (1 - (2 + (y : ℂ) * I)).Gammaℝ ≠ 0 := by
    intro h0
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h0
    have hre : (1 - (2 + (y : ℂ) * I)).re = (-1 : ℝ) := by
      have h1 : (1 - (2 + (y : ℂ) * I)) = (-1 : ℂ) - (y : ℂ) * I := by ring
      rw [h1]
      simp
    rw [hn] at hre
    simp at hre
    have h2' : ((2 * n : ℕ) : ℝ) = 1 := by
      push_cast
      linarith
    have h2 : (2 * n : ℕ) = 1 := by exact_mod_cast h2'
    omega
  have hg : ∀ m : ℕ, (2 + (y : ℂ) * I) / 2 ≠ -(m : ℂ) := by
    intro m h0
    have hre : ((2 + (y : ℂ) * I) / 2).re = 1 := by simp
    rw [h0] at hre
    simp at hre
    linarith [show (0:ℝ) ≤ (m:ℝ) from Nat.cast_nonneg m]
  have hg' : ∀ m : ℕ, (1 - (2 + (y : ℂ) * I)) / 2 ≠ -(m : ℂ) := by
    intro m h0
    have hre : ((1 - (2 + (y : ℂ) * I)) / 2).re = (-(1 / 2) : ℝ) := by
      have h1 : (1 - (2 + (y : ℂ) * I)) / 2 = (-(1 / 2) : ℂ) - ((y : ℂ) / 2) * I := by ring
      rw [h1]
      simp
    rw [h0] at hre
    simp at hre
    have h2' : ((2 * m : ℕ) : ℝ) = 1 := by
      push_cast
      linarith
    have h2 : (2 * m : ℕ) = 1 := by exact_mod_cast h2'
    omega
  rw [logDeriv_mul_one_sub hs0 hs1 hΓ hΓ' hg hg' (hsym (2 + (y : ℂ) * I) hs0 hs1)]
  ring


/-- **Integrated horizontal reflection for a conjugation-symmetric test
function**: for `h(conj s) = conj(h(s))` and `T > 0`,
`Bottom = conj(Top)`, where `Bottom = ∫ Φ(x-iT) dx` and `Top = ∫ Φ(x+iT) dx`
with `Φ = (Z'/Z)·h` on `[-1,2]`. -/
theorem integral_horizontal_bottom_eq_conj_top_two (h : ℂ → ℂ) (T : ℝ) (hT : 0 < T)
    (hsym : ∀ s : ℂ, h ((starRingEnd ℂ) s) = (starRingEnd ℂ) (h s))
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
        * h ((x : ℂ) + (T : ℝ) * I)) volume (-1) 2) :
    (∫ x : ℝ in (-1)..2,
        logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * h ((x : ℂ) + (-T : ℝ) * I))
      = (starRingEnd ℂ) (∫ x : ℝ in (-1)..2,
          logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * h ((x : ℂ) + (T : ℝ) * I)) := by
  have hpoint : ∀ x : ℝ,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * h ((x : ℂ) + (-T : ℝ) * I)
        = (starRingEnd ℂ) (logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
            * h ((x : ℂ) + (T : ℝ) * I)) := by
    intro x
    have harg : ((x : ℂ) + (-T : ℝ) * I) = (starRingEnd ℂ) ((x : ℂ) + (T : ℝ) * I) := by
      apply Complex.ext <;> simp
    rw [harg]
    have hs0 : ((x : ℂ) + (T : ℝ) * I) ≠ 0 := by
      intro h0
      have him : ((x : ℂ) + (T : ℝ) * I).im = T := by simp
      rw [h0] at him
      simp at him
      linarith
    have hs1 : ((x : ℂ) + (T : ℝ) * I) ≠ 1 := by
      intro h0
      have him : ((x : ℂ) + (T : ℝ) * I).im = T := by simp
      rw [h0] at him
      simp at him
      linarith
    have hg : ∀ m : ℕ, ((x : ℂ) + (T : ℝ) * I) / 2 ≠ -(m : ℂ) := by
      intro m h0
      have him : (((x : ℂ) + (T : ℝ) * I) / 2).im = T / 2 := by simp
      rw [h0] at him
      simp at him
      linarith
    exact logDeriv_mul_conj hs0 hs1 hg (hsym ((x : ℂ) + (T : ℝ) * I))
  rw [show (∫ x : ℝ in (-1)..2,
        logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * h ((x : ℂ) + (-T : ℝ) * I))
      = ∫ x : ℝ in (-1)..2,
          (starRingEnd ℂ) (logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
            * h ((x : ℂ) + (T : ℝ) * I)) from by
    apply intervalIntegral.integral_congr
    intro x hx
    exact hpoint x]
  rw [integral_conj_interval hint]



/-- `conj z - z = -2i·Im z`. -/
theorem conj_sub_self_eq (z : ℂ) :
    (starRingEnd ℂ) z - z = -2 * I * ((z.im : ℝ) : ℂ) := by
  apply Complex.ext
  · simp [Complex.sub_re, Complex.mul_re, Complex.I_re, Complex.I_im, Complex.ofReal_re]
  · simp [Complex.sub_im, Complex.mul_im, Complex.I_re, Complex.I_im, Complex.ofReal_im]
    ring


/-- **The contour-shift identity for symmetric test functions** (given the two
reflection relations), in multiplied form:
`(∑_ρ h(ρ) - h(0) - h(1))·2πi = 2i·Right - 2i·Im(Top)`. -/
theorem contour_shift_symmetric (h : ℂ → ℂ) (S : Finset ℂ) (T : ℝ) (hT : 0 < T)
    {U : Set ℂ} (hU : IsOpen U)
    (hsub : ([[-1, 2]] ×ℂ [[-T, T]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hleft : I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * I) * h (((-1 : ℝ) : ℂ) + y * I))
      = - I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I)))
    (hbottom : (∫ x : ℝ in (-1)..2,
        logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * h ((x : ℂ) + (-T : ℝ) * I))
      = (starRingEnd ℂ) (∫ x : ℝ in (-1)..2,
          logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * h ((x : ℂ) + (T : ℝ) * I))) :
    ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I)
      = 2 * I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I))
        - 2 * I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * h ((x : ℂ) + (T : ℝ) * I)).im : ℝ) : ℂ)) := by
  have hzero := test_function_explicit_formula (h := h) S (-1) 2 (-T) T hU hsub hSU h0_notS
    h1_notS hh hF hZ hZ_zero hF_simple hF_ne
    ⟨by norm_num, by norm_num, by linarith, hT⟩
    ⟨by norm_num, by norm_num, by linarith, hT⟩ hS_in
  rw [rectIntegral] at hzero
  rw [hbottom, hleft] at hzero
  rw [conj_sub_self_eq] at hzero
  linear_combination -hzero


/-- **The contour-shift identity for symmetric test functions, with the
reflection relations discharged.** -/
theorem contour_shift_symmetric' (h : ℂ → ℂ) (S : Finset ℂ) (T : ℝ) (hT : 0 < T)
    {U : Set ℂ} (hU : IsOpen U)
    (hsub : ([[-1, 2]] ×ℂ [[-T, T]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hsym1 : ∀ w : ℂ, w ≠ 0 → w ≠ 1 → h (1 - w) = h w)
    (hsymc : ∀ s : ℂ, h ((starRingEnd ℂ) s) = (starRingEnd ℂ) (h s))
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
        * h ((x : ℂ) + (T : ℝ) * I)) volume (-1) 2) :
    ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I)
      = 2 * I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I))
        - 2 * I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * h ((x : ℂ) + (T : ℝ) * I)).im : ℝ) : ℂ)) := by
  have hleft : I * (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * I) * h (((-1 : ℝ) : ℂ) + y * I))
      = - I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I)) := by
    have h1 : I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * I) * h (((-1 : ℝ) : ℂ) + y * I))
        = ∫ y : ℝ in (-T)..T,
            (logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * I) * h (((-1 : ℝ) : ℂ) + y * I)) * I := by
      rw [mul_comm I, intervalIntegral.integral_mul_const]
    have h2 : I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I))
        = ∫ y : ℝ in (-T)..T,
            (logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I)) * I := by
      rw [mul_comm I, intervalIntegral.integral_mul_const]
    have hneg : - I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I))
        = - (I * (∫ y : ℝ in (-T)..T,
            logDeriv completedZeta ((2 : ℝ) + y * I) * h ((2 : ℝ) + y * I))) := by ring
    rw [h1, hneg, h2]
    simpa using integral_logDeriv_mul_left_eq_neg_right_two h T hsym1
  have hbottom := integral_horizontal_bottom_eq_conj_top_two h T hT hsymc hint
  exact contour_shift_symmetric h S T hT hU hsub hSU h0_notS h1_notS hh hF hZ hZ_zero
    hF_simple hF_ne hS_in hleft hbottom


/-- A concrete symmetric test function: `exp(-(s-1/2)²/1000)`. -/
noncomputable def gaussianTest (s : ℂ) : ℂ :=
  Complex.exp (-((s - 1 / 2) ^ 2) / 1000)

theorem differentiable_gaussianTest : Differentiable ℂ gaussianTest := by
  unfold gaussianTest
  exact Complex.differentiable_exp.comp
    (((differentiable_id.sub_const (1 / 2)).pow 2).neg.div_const 1000)

theorem gaussianTest_one_sub (w : ℂ) : gaussianTest (1 - w) = gaussianTest w := by
  unfold gaussianTest
  congr 1
  ring

theorem gaussianTest_conj (s : ℂ) :
    gaussianTest ((starRingEnd ℂ) s) = (starRingEnd ℂ) (gaussianTest s) := by
  unfold gaussianTest
  rw [← Complex.exp_conj]
  congr 1
  simp [map_div₀, map_pow, map_sub, map_neg, map_ofNat]

/-- **The contour-shift identity for the concrete symmetric test function
`exp(-(s-1/2)²/1000)`.** -/
theorem contour_shift_gaussian (S : Finset ℂ) (T : ℝ) (hT : 0 < T)
    {U : Set ℂ} (hU : IsOpen U)
    (hsub : ([[-1, 2]] ×ℂ [[-T, T]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
        * gaussianTest ((x : ℂ) + (T : ℝ) * I)) volume (-1) 2) :
    ((∑ ρ ∈ S, gaussianTest ρ) - gaussianTest 0 - gaussianTest 1)
        * (2 * (Real.pi : ℂ) * I)
      = 2 * I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * gaussianTest ((2 : ℝ) + y * I))
        - 2 * I * ((((∫ x : ℝ in (-1)..2, logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
              * gaussianTest ((x : ℂ) + (T : ℝ) * I)).im : ℝ) : ℂ)) :=
  contour_shift_symmetric' gaussianTest S T hT hU hsub hSU h0_notS h1_notS
    differentiable_gaussianTest.differentiableOn hF hZ hZ_zero hF_simple hF_ne hS_in
    (fun w _ _ => gaussianTest_one_sub w) gaussianTest_conj hint


/-- The Fourier transform of a function supported on `[-1,1]`:
`ĝ(x) = ∫_{−1}^{1} g(u)e^{−ixu}du`. -/
noncomputable def fourierG (g : ℝ → ℂ) (x : ℝ) : ℂ :=
  ∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))

/-- **Fourier transform of an even function is even.** -/
theorem fourierG_even (g : ℝ → ℂ) (heven : ∀ u : ℝ, g (-u) = g u) (x : ℝ) :
    fourierG g (-x) = fourierG g x := by
  unfold fourierG
  rw [show (∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * ((-x : ℝ) : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1,
          g (-u) * Complex.exp (-(Complex.I * ((-x : ℝ) : ℂ) * ((-u : ℝ) : ℂ))) from by
    have hcomp := intervalIntegral.integral_comp_neg
      (f := fun u : ℝ => g u * Complex.exp (-(Complex.I * ((-x : ℝ) : ℂ) * (u : ℂ))))
      (a := -1) (b := 1)
    simpa using hcomp.symm]
  simp only [heven]
  apply intervalIntegral.integral_congr
  intro u hu
  congr 1
  push_cast
  ring

/-- **Fourier transform of a real even function is real.** -/
theorem fourierG_conj (g : ℝ → ℂ) (hg : Continuous g)
    (hreal : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u)
    (heven : ∀ u : ℝ, g (-u) = g u) (x : ℝ) :
    (starRingEnd ℂ) (fourierG g x) = fourierG g x := by
  unfold fourierG
  have hcont : Continuous (fun u : ℝ => g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) :=
    hg.mul (Complex.continuous_exp.comp (by continuity))
  have h1 : (starRingEnd ℂ)
        (∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1, g u * Complex.exp (Complex.I * (x : ℂ) * (u : ℂ)) := by
    rw [← integral_conj_interval (hcont.intervalIntegrable (-1) 1)]
    apply intervalIntegral.integral_congr
    intro u hu
    beta_reduce
    have hexp : (starRingEnd ℂ) (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
        = Complex.exp (Complex.I * (x : ℂ) * (u : ℂ)) := by
      rw [← Complex.exp_conj]
      congr 1
      simp [map_neg, map_mul, Complex.conj_I]
    rw [map_mul, hreal u, hexp]
  rw [h1]
  have h2 : (∫ u : ℝ in (-1)..1, g u * Complex.exp (Complex.I * (x : ℂ) * (u : ℂ)))
      = ∫ u : ℝ in (-1)..1, g (-u) * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) := by
    have hcomp := intervalIntegral.integral_comp_neg
      (f := fun u : ℝ => g u * Complex.exp (Complex.I * (x : ℂ) * (u : ℂ))) (a := -1) (b := 1)
    simp only [neg_neg] at hcomp
    rw [← hcomp]
    apply intervalIntegral.integral_congr
    intro u hu
    congr 1
    push_cast
    ring
  rw [h2]
  simp only [heven]


/-- **The Fourier transform `fourierG` is continuous.** -/
theorem continuous_fourierG (g : ℝ → ℂ) (hg : Continuous g) :
    Continuous (fourierG g) := by
  unfold fourierG
  exact intervalIntegral.continuous_parametric_intervalIntegral_of_continuous'
    (by fun_prop) (-1) 1

/-- **The Fourier transform `fourierG` is bounded** by the `L¹` norm of `g` on
`[-1,1]`. -/
theorem norm_fourierG_le (g : ℝ → ℂ) (hg : Continuous g) (x : ℝ) :
    ‖fourierG g x‖ ≤ ∫ u : ℝ in (-1)..1, ‖g u‖ := by
  unfold fourierG
  calc ‖∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))‖
      ≤ ∫ u : ℝ in (-1)..1, ‖g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))‖ :=
        intervalIntegral.norm_integral_le_integral_norm (by norm_num)
    _ = ∫ u : ℝ in (-1)..1, ‖g u‖ := by
        apply intervalIntegral.integral_congr
        intro u hu
        beta_reduce
        rw [norm_mul, Complex.norm_exp]
        simp


/-- **Fourier form of the prime-measure identity on a finite interval.**  For
`c > 1` and real `u`,
`∫_{y₁}^{y₂} L_Λ(c+iy)·e^{iuy} dy = ∑_n ∫_{y₁}^{y₂} term_n(c+iy)·e^{iuy} dy`.
This is the prime side paired with the Fourier kernel `e^{iuy}` used in the
critical-line route. -/
theorem integral_lseries_vonMangoldt_fourier (c y₁ y₂ u : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y₁..y₂,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
      = ∑' n : ℕ, ∫ y : ℝ in y₁..y₂,
          LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n
            * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) := by
  exact integral_lseries_vonMangoldt_mul
    (fun y : ℝ => Complex.exp (Complex.I * (u : ℂ) * (y : ℂ))) c y₁ y₂ hc
    (Complex.continuous_exp.comp (by continuity))


/-- **Closed Fourier coefficient of a vertical power**: for `n ≥ 2` and
`u ≠ log n`,
`∫_{y₁}^{y₂} n^{-(c+iy)}·e^{iuy} dy
 = n^{-(c+iy₂)}e^{iuy₂}/(i(u−log n)) − n^{-(c+iy₁)}e^{iuy₁}/(i(u−log n))`. -/
theorem integral_natCast_cpow_vertical_fourier {n : ℕ} (hn : 2 ≤ n)
    (c u y₁ y₂ : ℝ) (hu : u ≠ Real.log n) :
    (∫ y : ℝ in y₁..y₂,
        ((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ)
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
      = ((n : ℝ) : ℂ) ^ (-(c + (y₂ : ℂ) * I) : ℂ)
          * Complex.exp (Complex.I * (u : ℂ) * (y₂ : ℂ))
            / (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))
        - ((n : ℝ) : ℂ) ^ (-(c + (y₁ : ℂ) * I) : ℂ)
          * Complex.exp (Complex.I * (u : ℂ) * (y₁ : ℂ))
            / (Complex.I * ((u : ℂ) - (Real.log n : ℂ))) := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hulog : (u : ℂ) ≠ (Real.log n : ℂ) := by
    intro h
    apply hu
    exact_mod_cast h
  have hlam : Complex.I * ((u : ℂ) - (Real.log n : ℂ)) ≠ 0 := by
    exact mul_ne_zero Complex.I_ne_zero (sub_ne_zero.mpr hulog)
  have hflu : ∀ y : ℝ, HasDerivAt (fun t : ℝ => ((n : ℝ) : ℂ) ^ (-(c + (t : ℂ) * I) : ℂ)
        * Complex.exp (Complex.I * (u : ℂ) * (t : ℂ)))
      ((((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ)
        * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
        * (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))) y := by
    intro y
    have hcp := hasDerivAt_natCast_cpow_vertical hn c y
    have hlin : HasDerivAt (fun y : ℝ => Complex.I * (u : ℂ) * (y : ℂ))
        (Complex.I * (u : ℂ)) y := by
      have h1 : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 y := Complex.ofRealCLM.hasDerivAt
      have h2 := h1.const_mul (Complex.I * (u : ℂ))
      simpa [mul_comm, mul_assoc] using h2
    have hexp : HasDerivAt (fun y : ℝ => Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
        (Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * (Complex.I * (u : ℂ))) y := by
      have h := (Complex.hasDerivAt_exp (Complex.I * (u : ℂ) * (y : ℂ))).comp y hlin
      simpa [Function.comp_def, mul_comm, mul_assoc] using h
    have hG := hcp.mul hexp
    convert hG using 1
    ring
  have hderiv : ∀ y ∈ uIcc y₁ y₂,
      HasDerivAt (fun t : ℝ => ((n : ℝ) : ℂ) ^ (-(c + (t : ℂ) * I) : ℂ)
          * Complex.exp (Complex.I * (u : ℂ) * (t : ℂ))
            / (Complex.I * ((u : ℂ) - (Real.log n : ℂ))))
        ((((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ)
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))) y := by
    intro y hy
    have h := (hflu y).div_const (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))
    convert h using 1
    field_simp [hlam]
  have hcont : ContinuousOn (fun y : ℝ => ((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ)
      * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ))) (uIcc y₁ y₂) := by
    apply Continuous.continuousOn
    exact (continuous_natCast_cpow_vertical n (by omega) c).mul
      (Complex.continuous_exp.comp (by continuity))
  have hint := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable
  rw [hint]


/-- **Closed Fourier term of the von Mangoldt series** (`n ≥ 2`). -/
theorem integral_lseriesTerm_vonMangoldt_fourier {n : ℕ} (hn : 2 ≤ n)
    (c u y₁ y₂ : ℝ) (hu : u ≠ Real.log n) :
    (∫ y : ℝ in y₁..y₂,
        LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
      = (ArithmeticFunction.vonMangoldt n : ℂ)
          * ((((n : ℝ) : ℂ) ^ (-(c + (y₂ : ℂ) * I) : ℂ)
              * Complex.exp (Complex.I * (u : ℂ) * (y₂ : ℂ))
                / (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))
            - ((n : ℝ) : ℂ) ^ (-(c + (y₁ : ℂ) * I) : ℂ)
              * Complex.exp (Complex.I * (u : ℂ) * (y₁ : ℂ))
                / (Complex.I * ((u : ℂ) - (Real.log n : ℂ))))) := by
  have hn1 : 1 ≤ n := by omega
  have hn0 : n ≠ 0 := by omega
  have hterm : ∀ y : ℝ,
      LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (c + (y : ℂ) * I) n
        = (ArithmeticFunction.vonMangoldt n : ℂ) * ((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ) := by
    intro y
    rw [LSeries.term_def, if_neg hn0, div_eq_mul_inv, ← Complex.cpow_neg,
      ← Complex.ofReal_natCast n]
  rw [show (∫ y : ℝ in y₁..y₂,
        LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
      = ∫ y : ℝ in y₁..y₂,
          (ArithmeticFunction.vonMangoldt n : ℂ)
            * (((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ)
              * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ))) from by
    apply intervalIntegral.integral_congr
    intro y hy
    beta_reduce
    rw [hterm y]
    ring]
  rw [intervalIntegral.integral_const_mul]
  rw [integral_natCast_cpow_vertical_fourier hn c u y₁ y₂ hu]


/-- **Full closed Fourier form of the prime measure on an interval.** -/
theorem integral_lseries_vonMangoldt_fourier_closed (c y₁ y₂ u : ℝ) (hc : 1 < c)
    (hu : ∀ n : ℕ, 2 ≤ n → u ≠ Real.log n) :
    (∫ y : ℝ in y₁..y₂,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
      = ∑' n : ℕ, if n ≤ 1 then 0 else
          (ArithmeticFunction.vonMangoldt n : ℂ)
            * ((((n : ℝ) : ℂ) ^ (-(c + (y₂ : ℂ) * I) : ℂ)
                * Complex.exp (Complex.I * (u : ℂ) * (y₂ : ℂ))
                  / (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))
              - ((n : ℝ) : ℂ) ^ (-(c + (y₁ : ℂ) * I) : ℂ)
                * Complex.exp (Complex.I * (u : ℂ) * (y₁ : ℂ))
                  / (Complex.I * ((u : ℂ) - (Real.log n : ℂ))))) := by
  rw [integral_lseries_vonMangoldt_fourier c y₁ y₂ u hc]
  apply tsum_congr
  intro n
  by_cases hn : n ≤ 1
  · rw [if_pos hn]
    have hzero : ∀ y : ℝ,
        LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (c + (y : ℂ) * I) n = 0 := by
      intro y
      interval_cases n
      · rw [LSeries.term_def]
        simp
      · rw [LSeries.term_def]
        simp
    rw [show (∫ y : ℝ in y₁..y₂,
          LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
            (c + y * I) n * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
        = ∫ y : ℝ in y₁..y₂, (0 : ℂ) from by
      apply intervalIntegral.integral_congr
      intro y hy
      beta_reduce
      rw [hzero y]
      ring]
    simp
  · rw [if_neg hn]
    have hn2 : 2 ≤ n := by omega
    exact integral_lseriesTerm_vonMangoldt_fourier hn2 c u y₁ y₂ (hu n hn2)


/-- **Integrated prime-side identity with the Fourier kernel** `e^{iuy}`. -/
theorem integral_logDeriv_mul_I_eq_neg_arch_prime_fourier (c u y₁ y₂ : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y₁..y₂, logDeriv completedZeta (c + y * I)
        * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * I)
      = - (∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
              * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * I)
        - (∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
              * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * I) := by
  have h := integral_logDeriv_mul_I_eq_neg_arch_prime'
    (h := fun s : ℂ => Complex.exp (Complex.I * (u : ℂ) * (s.im : ℂ))) c y₁ y₂ hc ?_ ?_
  · simpa using h
  · exact (by continuity : Continuous fun y : ℝ =>
      Complex.exp (Complex.I * (u : ℂ) * (((c + (y : ℂ) * I).im : ℝ) : ℂ))).continuousOn
  · exact (((continuousOn_lseries_vonMangoldt c y₁ y₂ hc).mul
      (Complex.continuous_exp.comp (by continuity)).continuousOn)).mul_const I


/-- The closed Fourier coefficient of the prime measure, as a named function. -/
noncomputable def fourierCoeffClosed (n : ℕ) (c u y₁ y₂ : ℝ) : ℂ :=
  (ArithmeticFunction.vonMangoldt n : ℂ)
    * ((((n : ℝ) : ℂ) ^ (-(c + (y₂ : ℂ) * I) : ℂ)
        * Complex.exp (Complex.I * (u : ℂ) * (y₂ : ℂ))
          / (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))
      - ((n : ℝ) : ℂ) ^ (-(c + (y₁ : ℂ) * I) : ℂ)
        * Complex.exp (Complex.I * (u : ℂ) * (y₁ : ℂ))
          / (Complex.I * ((u : ℂ) - (Real.log n : ℂ)))))

theorem integral_lseries_vonMangoldt_fourier_closed' (c y₁ y₂ u : ℝ) (hc : 1 < c)
    (hu : ∀ n : ℕ, 2 ≤ n → u ≠ Real.log n) :
    (∫ y : ℝ in y₁..y₂,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)))
      = ∑' n : ℕ, if n ≤ 1 then 0 else fourierCoeffClosed n c u y₁ y₂ := by
  simpa [fourierCoeffClosed] using
    integral_lseries_vonMangoldt_fourier_closed c y₁ y₂ u hc hu

/-- **Fourier form of the right-vertical integrated `Z'/Z`, with the prime side
in closed form.** -/
theorem integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed (c u y₁ y₂ : ℝ)
    (hc : 1 < c) (hu : ∀ n : ℕ, 2 ≤ n → u ≠ Real.log n) :
    (∫ y : ℝ in y₁..y₂, logDeriv completedZeta (c + y * I)
        * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * I)
      = - (∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
              * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * I)
        - (∑' n : ℕ, if n ≤ 1 then 0 else fourierCoeffClosed n c u y₁ y₂) * I := by
  rw [integral_logDeriv_mul_I_eq_neg_arch_prime_fourier c u y₁ y₂ hc]
  have hmul : (∫ y : ℝ in y₁..y₂,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
          * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ)) * I)
      = (∫ y : ℝ in y₁..y₂,
          LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
            * Complex.exp (Complex.I * (u : ℂ) * (y : ℂ))) * I := by
    rw [intervalIntegral.integral_mul_const]
  rw [hmul, integral_lseries_vonMangoldt_fourier_closed' c y₁ y₂ u hc hu]


/-- **The critical-line archimedean integral is real** when the test function is
real-valued. -/
theorem integral_archimedean_term_real (h : ℝ → ℂ)
    (hreal : ∀ t : ℝ, (starRingEnd ℂ) (h t) = h t) (t₁ t₂ : ℝ)
    (hint : IntervalIntegrable (fun t : ℝ =>
      ((1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
          + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2))) * h t) volume t₁ t₂) :
    (starRingEnd ℂ) (∫ t : ℝ in t₁..t₂,
        ((1 / 2) * Complex.log (Real.pi : ℂ)
          - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
            + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2))) * h t)
      = ∫ t : ℝ in t₁..t₂,
          ((1 / 2) * Complex.log (Real.pi : ℂ)
            - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
              + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2))) * h t := by
  rw [← integral_conj_interval hint]
  apply intervalIntegral.integral_congr
  intro t ht
  beta_reduce
  rw [map_mul, hreal t]
  congr 1
  obtain ⟨x, hx⟩ := AbsoluteHodgeArchimedean.archimedeanTerm_critical_line_real t
  rw [hx]
  simp


/-- The closed Fourier coefficient vanishes on a degenerate interval. -/
theorem fourierCoeffClosed_self (n : ℕ) (c u y : ℝ) :
    fourierCoeffClosed n c u y y = 0 := by
  unfold fourierCoeffClosed
  ring

/-- The closed Fourier coefficient telescopes: it is the boundary difference of
an antiderivative, hence additive over adjacent intervals. -/
theorem fourierCoeffClosed_add (n : ℕ) (c u y₁ y₂ y₃ : ℝ) :
    fourierCoeffClosed n c u y₁ y₃
      = fourierCoeffClosed n c u y₁ y₂ + fourierCoeffClosed n c u y₂ y₃ := by
  unfold fourierCoeffClosed
  ring


/-- **Conjugate symmetry of the archimedean Fourier integral** on the critical
line: `conj ∫ arch·e^{iut} = ∫ arch·e^{−iut}`. -/
theorem conj_integral_archimedean_fourier (u t₁ t₂ : ℝ)
    (hint : IntervalIntegrable (fun t : ℝ =>
      ((1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
          + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)))
        * Complex.exp (Complex.I * (u : ℂ) * (t : ℂ))) volume t₁ t₂) :
    (starRingEnd ℂ) (∫ t : ℝ in t₁..t₂,
        ((1 / 2) * Complex.log (Real.pi : ℂ)
          - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
            + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)))
          * Complex.exp (Complex.I * (u : ℂ) * (t : ℂ)))
      = ∫ t : ℝ in t₁..t₂,
          ((1 / 2) * Complex.log (Real.pi : ℂ)
            - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
              + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)))
            * Complex.exp (Complex.I * ((-u : ℝ) : ℂ) * (t : ℂ)) := by
  rw [← integral_conj_interval hint]
  apply intervalIntegral.integral_congr
  intro t ht
  beta_reduce
  rw [map_mul]
  have harch : (starRingEnd ℂ)
      ((1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
          + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)))
      = (1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
          + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)) := by
    obtain ⟨x, hx⟩ := AbsoluteHodgeArchimedean.archimedeanTerm_critical_line_real t
    rw [hx]
    simp
  rw [harch]
  congr 1
  rw [← Complex.exp_conj]
  congr 1
  simp [map_mul, Complex.conj_I]


/-- **Consistency of the closed Fourier coefficient at `u = 0`**: it recovers
the closed vertical term integral `integral_natCast_cpow_vertical`. -/
theorem fourierCoeffClosed_zero {n : ℕ} (hn : 2 ≤ n) (c y₁ y₂ : ℝ) :
    fourierCoeffClosed n c 0 y₁ y₂
      = (ArithmeticFunction.vonMangoldt n : ℂ)
          * ((I / (Real.log n : ℂ))
              * (((n : ℝ) : ℂ) ^ (-(c + (y₂ : ℂ) * I) : ℂ)
                - ((n : ℝ) : ℂ) ^ (-(c + (y₁ : ℂ) * I) : ℂ))) := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hnne : (n : ℝ) ≠ 1 := by
    have : (1 : ℝ) < n := by exact_mod_cast (show 1 < n by omega)
    linarith
  have hlog : (Real.log n : ℂ) ≠ 0 := by
    have : Real.log (n : ℝ) ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hnpos hnne
    exact_mod_cast this
  have hsingle : ∀ X : ℂ,
      X / (Complex.I * (0 - (Real.log n : ℂ))) = (Complex.I / (Real.log n : ℂ)) * X := by
    intro X
    field_simp [hlog]
    ring_nf
    simp only [pow_two, Complex.I_mul_I]
    ring
  unfold fourierCoeffClosed
  simp only [Complex.ofReal_zero, zero_mul, mul_zero, Complex.exp_zero, mul_one]
  rw [hsingle, hsingle]
  ring


/-- **The `u = 0` case of the full closed Fourier prime sum.** -/
theorem integral_lseries_vonMangoldt_fourier_closed_zero (c y₁ y₂ : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y₁..y₂,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I))
      = ∑' n : ℕ, if n ≤ 1 then 0 else fourierCoeffClosed n c 0 y₁ y₂ := by
  have h := integral_lseries_vonMangoldt_fourier_closed' c y₁ y₂ 0 hc (by
    intro n hn h0
    have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
    have hnne : (n : ℝ) ≠ 1 := by
      have : (1 : ℝ) < n := by exact_mod_cast (show 1 < n by omega)
      linarith
    have : Real.log (n : ℝ) ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hnpos hnne
    exact this h0.symm)
  simpa only [Complex.ofReal_zero, zero_mul, mul_zero, Complex.exp_zero, mul_one] using h


/-- **The `u = 0` Fourier sum equals the established closed prime sum.** -/
theorem integral_lseries_vonMangoldt_closed_eq_fourier_zero (c y₁ y₂ : ℝ) (hc : 1 < c) :
    (∑' n : ℕ, if n ≤ 1 then 0 else fourierCoeffClosed n c 0 y₁ y₂)
      = ∑' n : ℕ, if n ≤ 1 then 0 else
          (ArithmeticFunction.vonMangoldt n : ℂ)
            * ((I / (Real.log n : ℂ))
                * (((n : ℝ) : ℂ) ^ (-(c + (y₂ : ℂ) * I) : ℂ)
                  - ((n : ℝ) : ℂ) ^ (-(c + (y₁ : ℂ) * I) : ℂ))) := by
  apply tsum_congr
  intro n
  by_cases hn : n ≤ 1
  · rw [if_pos hn, if_pos hn]
  · rw [if_neg hn, if_neg hn]
    have hn2 : 2 ≤ n := by omega
    rw [fourierCoeffClosed_zero hn2 c y₁ y₂]


/-- **Test-function formula for `h(s) = (s−1/2)²`** (quadratic instance). -/
theorem test_function_explicit_formula_quadratic {U : Set ℂ} (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * (z - 1 / 2) ^ 2) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, (ρ - 1 / 2) ^ 2) - ((0 : ℂ) - 1 / 2) ^ 2 - ((1 : ℂ) - 1 / 2) ^ 2)
          * (2 * (Real.pi : ℂ) * I) := by
  have h := test_function_explicit_formula (h := fun s : ℂ => (s - 1 / 2) ^ 2) S x₁ x₂
    y₁ y₂ hU hsub hSU h0_notS h1_notS
    ((differentiable_id.sub_const (1 / 2)).pow 2).differentiableOn hF hZ hZ_zero
    hF_simple hF_ne h0_in h1_in hS_in
  simpa using h

/-- **Contour-shift identity for the quadratic symmetric test function.** -/
theorem contour_shift_quadratic (S : Finset ℂ) (T : ℝ) (hT : 0 < T)
    {U : Set ℂ} (hU : IsOpen U)
    (hsub : ([[-1, 2]] ×ℂ [[-T, T]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
        * ((x : ℂ) + (T : ℝ) * I - 1 / 2) ^ 2) volume (-1) 2) :
    ((∑ ρ ∈ S, (ρ - 1 / 2) ^ 2) - ((0 : ℂ) - 1 / 2) ^ 2 - ((1 : ℂ) - 1 / 2) ^ 2)
        * (2 * (Real.pi : ℂ) * I)
      = 2 * I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * ((2 : ℝ) + y * I - 1 / 2) ^ 2)
        - 2 * I * ((((∫ x : ℝ in (-1)..2, logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
              * ((x : ℂ) + (T : ℝ) * I - 1 / 2) ^ 2).im : ℝ) : ℂ)) := by
  have hsym1 : ∀ w : ℂ, w ≠ 0 → w ≠ 1 → ((1 - w - 1 / 2 : ℂ) ^ 2) = (w - 1 / 2) ^ 2 := by
    intro w _ _
    ring
  have hsymc : ∀ s : ℂ, (((starRingEnd ℂ) s - 1 / 2 : ℂ) ^ 2)
      = (starRingEnd ℂ) ((s - 1 / 2) ^ 2) := by
    intro s
    simp [map_pow, map_sub, map_ofNat]
  exact contour_shift_symmetric' (h := fun s : ℂ => (s - 1 / 2) ^ 2) S T hT hU hsub hSU
    h0_notS h1_notS ((differentiable_id.sub_const (1/2)).pow 2).differentiableOn hF hZ hZ_zero
    hF_simple hF_ne hS_in hsym1 hsymc hint


/-- **Constant test function `h ≡ 1`**: the general test-function formula
specialises to the `h ≡ 1` zero side
`∮ Z'/Z = 2πi·(∑_{ρ∈S} 1 − 2)`. -/
theorem test_function_explicit_formula_const {U : Set ℂ} (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, (1 : ℂ)) - 1 - 1) * (2 * (Real.pi : ℂ) * I) := by
  have h := test_function_explicit_formula (h := fun _ : ℂ => (1 : ℂ)) S x₁ x₂ y₁ y₂ hU
    hsub hSU h0_notS h1_notS (differentiable_const (1 : ℂ)).differentiableOn hF hZ hZ_zero
    hF_simple hF_ne h0_in h1_in hS_in
  simpa using h


/-- **The `u = 0` case of the closed Fourier `Z'/Z` identity.** -/
theorem integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed_zero (c y₁ y₂ : ℝ)
    (hc : 1 < c) :
    (∫ y : ℝ in y₁..y₂, logDeriv completedZeta (c + y * I) * I)
      = - (∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2)) * I)
        - (∑' n : ℕ, if n ≤ 1 then 0 else fourierCoeffClosed n c 0 y₁ y₂) * I := by
  have h := integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed c 0 y₁ y₂ hc (by
    intro n hn h0
    have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
    have hnne : (n : ℝ) ≠ 1 := by
      have : (1 : ℝ) < n := by exact_mod_cast (show 1 < n by omega)
      linarith
    have : Real.log (n : ℝ) ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hnpos hnne
    exact this h0.symm)
  simpa only [Complex.ofReal_zero, zero_mul, mul_zero, Complex.exp_zero, mul_one] using h


/-- **The `h ≡ 1` prime side equals the `u = 0` Fourier sum**: the Fourier layer
specialises to the `primeSide` used in the `h ≡ 1` assembly. -/
theorem primeSide_eq_fourier_zero (c y₁ y₂ : ℝ) (hc : 1 < c) :
    primeSide c y₁ y₂ = ∑' n : ℕ, if n ≤ 1 then 0 else fourierCoeffClosed n c 0 y₁ y₂ := by
  unfold primeSide
  apply tsum_congr
  intro n
  by_cases hn : n ≤ 1
  · rw [if_pos hn, if_pos hn]
  · rw [if_neg hn, if_neg hn]
    have hn2 : 2 ≤ n := by omega
    rw [fourierCoeffClosed_zero hn2 c y₁ y₂]


/-- **Cauchy formula for the completed zeta**: the order-0 rectangle Cauchy
formula specialised to `completedZeta`. -/
theorem rectIntegral_completedZeta_mul_inv_sub_eq {U : Set ℂ} {a : ℂ}
    (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ < x₂) (hy : y₁ < y₂)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (ha : a ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) :
    rectIntegral (fun z => completedZeta z * (z - a)⁻¹) x₁ x₂ y₁ y₂
      = completedZeta a * (2 * (Real.pi : ℂ) * I) :=
  rectIntegral_mul_inv_sub_eq completedZeta x₁ x₂ y₁ y₂ hx hy hU hsub hZ ha

/-- **Derivative Cauchy formula for the completed zeta**: `∮ Z/(z−a)² dz =
2πi·Z′(a)` for `a` strictly inside and `Z` holomorphic on a neighbourhood of
the closed rectangle. -/
theorem rectIntegral_completedZeta_mul_inv_sq_eq {U : Set ℂ} {a : ℂ}
    (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ < x₂) (hy : y₁ < y₂)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (ha : a ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) :
    rectIntegral (fun z => completedZeta z * ((z - a) ^ 2)⁻¹) x₁ x₂ y₁ y₂
      = deriv completedZeta a * (2 * (Real.pi : ℂ) * I) :=
  rectIntegral_mul_inv_sq_eq completedZeta x₁ x₂ y₁ y₂ hx hy hU hsub hZ ha


/-- **The Fourier transform of the constant `1` on `[-1,1]`**:
`∫_{−1}^{1} e^{−ixu} du = 2 sin x / x`. -/
theorem fourierG_one_eq (x : ℝ) (hx : x ≠ 0) :
    fourierG (fun _ : ℝ => 1) x = 2 * (Real.sin x : ℂ) / (x : ℂ) := by
  unfold fourierG
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hden : -(Complex.I * (x : ℂ)) ≠ 0 := by
    simp [hcx, Complex.I_ne_zero]
  have hderiv : ∀ u : ℝ, HasDerivAt (fun u : ℝ =>
      Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))
      (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) u := by
    intro u
    have hlin : HasDerivAt (fun u : ℝ => -(Complex.I * (x : ℂ) * (u : ℂ)))
        (-(Complex.I * (x : ℂ))) u := by
      have h1 : HasDerivAt (fun u : ℝ => Complex.I * (x : ℂ) * (u : ℂ))
          (Complex.I * (x : ℂ)) u := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (x : ℂ))
      exact h1.neg
    have hexp : HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
        (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))) u :=
      (Complex.hasDerivAt_exp _).comp u hlin
    have hdiv := hexp.div_const (-(Complex.I * (x : ℂ)))
    convert hdiv using 1
    field_simp [hden]
  have hmain : (∫ u : ℝ in (-1)..1, Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = Complex.exp (-(Complex.I * (x : ℂ) * (((1 : ℝ)) : ℂ))) / (-(Complex.I * (x : ℂ)))
        - Complex.exp (-(Complex.I * (x : ℂ) * (((-1 : ℝ)) : ℂ))) / (-(Complex.I * (x : ℂ))) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun u _ => hderiv u)
      ((Complex.continuous_exp.comp (by continuity)).intervalIntegrable (-1) 1)
  rw [show (∫ u : ℝ in (-1)..1,
        (fun _ : ℝ => 1) u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1, Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) from by
    apply intervalIntegral.integral_congr
    intro u hu
    simp]
  rw [hmain]
  have h1 : Complex.exp (-(Complex.I * (x : ℂ))) = (Real.cos x : ℂ) - (Real.sin x : ℂ) * Complex.I := by
    rw [show -(Complex.I * (x : ℂ)) = ((-x : ℝ) : ℂ) * Complex.I from by push_cast; ring]
    rw [← Complex.cos_add_sin_I]
    simp [Complex.ofReal_cos, Complex.ofReal_sin, Real.cos_neg, Real.sin_neg]
    ring
  have h2 : Complex.exp (Complex.I * (x : ℂ)) = (Real.cos x : ℂ) + (Real.sin x : ℂ) * Complex.I := by
    rw [show Complex.I * (x : ℂ) = ((x : ℝ) : ℂ) * Complex.I from by ring]
    rw [← Complex.cos_add_sin_I]
    simp
  have hval : Complex.exp (-(Complex.I * (x : ℂ) * (((1 : ℝ)) : ℂ))) / (-(Complex.I * (x : ℂ)))
      - Complex.exp (-(Complex.I * (x : ℂ) * ((((-1 : ℝ))) : ℂ))) / (-(Complex.I * (x : ℂ)))
      = 2 * (Real.sin x : ℂ) / (x : ℂ) := by
    push_cast
    rw [show -(Complex.I * (x : ℂ) * 1) = -(Complex.I * (x : ℂ)) from by ring]
    rw [show -(Complex.I * (x : ℂ) * -1) = Complex.I * (x : ℂ) from by ring]
    rw [h1, h2]
    field_simp [hcx, Complex.I_ne_zero]
    simp [Complex.I_mul_I]
    ring
  rw [hval]


/-- **Fourier transform of a complex exponential**:
`∫_{−1}^{1} e^{bu}·e^{−ixu} du = (e^{b−ix} − e^{−b+ix})/(b − ix)`. -/
theorem fourierG_exp_eq (b : ℂ) (x : ℝ) (hbx : b - Complex.I * (x : ℂ) ≠ 0) :
    fourierG (fun u : ℝ => Complex.exp (b * (u : ℂ))) x
      = (Complex.exp (b - Complex.I * (x : ℂ)) - Complex.exp (-b + Complex.I * (x : ℂ)))
          / (b - Complex.I * (x : ℂ)) := by
  unfold fourierG
  have hderiv : ∀ u : ℝ, HasDerivAt (fun u : ℝ =>
      Complex.exp ((b - Complex.I * (x : ℂ)) * (u : ℂ)) / (b - Complex.I * (x : ℂ)))
      (Complex.exp ((b - Complex.I * (x : ℂ)) * (u : ℂ))) u := by
    intro u
    have hlin : HasDerivAt (fun u : ℝ => (b - Complex.I * (x : ℂ)) * (u : ℂ))
        (b - Complex.I * (x : ℂ)) u := by
      simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (b - Complex.I * (x : ℂ))
    have hexp : HasDerivAt (fun u : ℝ => Complex.exp ((b - Complex.I * (x : ℂ)) * (u : ℂ)))
        (Complex.exp ((b - Complex.I * (x : ℂ)) * (u : ℂ)) * (b - Complex.I * (x : ℂ))) u :=
      (Complex.hasDerivAt_exp _).comp u hlin
    have hdiv := hexp.div_const (b - Complex.I * (x : ℂ))
    convert hdiv using 1
    field_simp [hbx]
  have hmain : (∫ u : ℝ in (-1)..1, Complex.exp ((b - Complex.I * (x : ℂ)) * (u : ℂ)))
      = Complex.exp ((b - Complex.I * (x : ℂ)) * (((1 : ℝ)) : ℂ)) / (b - Complex.I * (x : ℂ))
        - Complex.exp ((b - Complex.I * (x : ℂ)) * (((-1 : ℝ)) : ℂ)) / (b - Complex.I * (x : ℂ)) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun u _ => hderiv u)
      ((Complex.continuous_exp.comp (by continuity)).intervalIntegrable (-1) 1)
  rw [show (∫ u : ℝ in (-1)..1,
        (fun u : ℝ => Complex.exp (b * (u : ℂ))) u
          * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1, Complex.exp ((b - Complex.I * (x : ℂ)) * (u : ℂ)) from by
    apply intervalIntegral.integral_congr
    intro u hu
    beta_reduce
    rw [← Complex.exp_add]
    congr 1
    ring]
  rw [hmain]
  push_cast
  rw [show (b - Complex.I * (x : ℂ)) * 1 = b - Complex.I * (x : ℂ) from by ring]
  rw [show (b - Complex.I * (x : ℂ)) * -1 = -(b - Complex.I * (x : ℂ)) from by ring]
  rw [Complex.exp_neg]
  field_simp [hbx]
  have hprod : Complex.exp (b - Complex.I * (x : ℂ)) * Complex.exp (-b + Complex.I * (x : ℂ)) = 1 := by
    rw [← Complex.exp_add,
      show (b - Complex.I * (x : ℂ)) + (-b + Complex.I * (x : ℂ)) = 0 by ring, Complex.exp_zero]
  rw [mul_sub, hprod, ← pow_two]



/-- **Fourier transform of a pure exponential** `e^{iau}`:
`∫_{−1}^{1} e^{iau}e^{−ixu} du = 2 sin(a−x)/(a−x)`. -/
theorem fourierG_exp_I_eq (a x : ℝ) (hax : a ≠ x) :
    fourierG (fun u : ℝ => Complex.exp (Complex.I * (a : ℂ) * (u : ℂ))) x
      = 2 * (Real.sin (a - x) : ℂ) / ((a : ℂ) - (x : ℂ)) := by
  have hne : Complex.I * (a : ℂ) - Complex.I * (x : ℂ) ≠ 0 := by
    rw [← mul_sub]
    exact mul_ne_zero Complex.I_ne_zero (sub_ne_zero.mpr (by exact_mod_cast hax))
  have h := fourierG_exp_eq (b := Complex.I * (a : ℂ)) (x := x) hne
  rw [h]
  have e1 : Complex.I * (a : ℂ) - Complex.I * (x : ℂ) = ((a - x : ℝ) : ℂ) * Complex.I := by
    push_cast; ring
  have e2 : -(Complex.I * (a : ℂ)) + Complex.I * (x : ℂ)
      = -(((a - x : ℝ) : ℂ) * Complex.I) := by push_cast; ring
  rw [e1, e2]
  have hnum : Complex.exp (((a - x : ℝ) : ℂ) * Complex.I)
      - Complex.exp (-(((a - x : ℝ) : ℂ) * Complex.I))
      = 2 * Complex.I * Complex.sin ((a - x : ℝ) : ℂ) := by
    rw [Complex.sin]
    have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
    ring_nf
    rw [hI2]
    ring
  rw [hnum]
  rw [Complex.ofReal_sin]
  have hxC : ((a - x : ℝ) : ℂ) ≠ 0 := by
    exact_mod_cast (sub_ne_zero.mpr hax)
  have hI : (Complex.I : ℂ) ≠ 0 := Complex.I_ne_zero
  have hab : ((a : ℂ) - (x : ℂ)) = ((a - x : ℝ) : ℂ) := by push_cast; ring
  rw [hab]
  field_simp


/-- **Linearity of the Fourier transform** (addition) for continuous functions. -/
theorem fourierG_add (g h : ℝ → ℂ) (hg : Continuous g) (hh : Continuous h) (x : ℝ) :
    fourierG (fun u => g u + h u) x = fourierG g x + fourierG h x := by
  unfold fourierG
  have hexp : Continuous (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) :=
    Complex.continuous_exp.comp (by continuity)
  have h1 : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) volume (-1) 1 :=
    (hg.mul hexp).intervalIntegrable _ _
  have h2 : IntervalIntegrable
      (fun u : ℝ => h u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) volume (-1) 1 :=
    (hh.mul hexp).intervalIntegrable _ _
  rw [show (∫ u : ℝ in (-1)..1,
        (fun u => g u + h u) u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1,
          (g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
            + h u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) from by
    apply intervalIntegral.integral_congr
    intro u hu
    beta_reduce
    ring]
  rw [intervalIntegral.integral_add h1 h2]

/-- **Linearity of the Fourier transform** (scalar multiplication) for continuous
functions. -/
theorem fourierG_const_mul (c : ℂ) (g : ℝ → ℂ) (hg : Continuous g) (x : ℝ) :
    fourierG (fun u => c * g u) x = c * fourierG g x := by
  unfold fourierG
  rw [show (∫ u : ℝ in (-1)..1,
        (fun u => c * g u) u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1, c * (g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) from by
    apply intervalIntegral.integral_congr
    intro u hu
    beta_reduce
    ring]
  rw [intervalIntegral.integral_const_mul]


/-- **Fourier transform of a constant**. -/
theorem fourierG_const_eq (c : ℂ) (x : ℝ) (hx : x ≠ 0) :
    fourierG (fun _ : ℝ => c) x = c * (2 * (Real.sin x : ℂ) / (x : ℂ)) := by
  have h := fourierG_const_mul c (fun _ : ℝ => (1 : ℂ)) continuous_const x
  rw [fourierG_one_eq x hx] at h
  simpa [mul_one] using h

/-- **Fourier transform of a scaled pure exponential**. -/
theorem fourierG_const_mul_exp_I_eq (c : ℂ) (a x : ℝ) (hax : a ≠ x) :
    fourierG (fun u : ℝ => c * Complex.exp (Complex.I * (a : ℂ) * (u : ℂ))) x
      = c * (2 * (Real.sin (a - x) : ℂ) / ((a : ℂ) - (x : ℂ))) := by
  rw [fourierG_const_mul c (fun u : ℝ => Complex.exp (Complex.I * (a : ℂ) * (u : ℂ)))
    (Complex.continuous_exp.comp (by continuity)) x]
  rw [fourierG_exp_I_eq a x hax]


/-- **Fourier transform of a cosine**: for real `a ≠ ±x`,
`∫_{−1}^{1} cos(au)·e^{−ixu} du = sin(a−x)/(a−x) + sin(a+x)/(a+x)`. -/
theorem fourierG_cos_eq (a x : ℝ) (hax : a ≠ x) (hax2 : a ≠ -x) :
    fourierG (fun u : ℝ => Complex.cos (a * (u : ℂ))) x
      = (Real.sin (a - x) : ℂ) / ((a : ℂ) - (x : ℂ))
        + (Real.sin (a + x) : ℂ) / ((a : ℂ) + (x : ℂ)) := by
  have hg : (fun u : ℝ => Complex.cos (a * (u : ℂ)))
      = fun u : ℝ => (1 / 2 : ℂ) * (Complex.exp (Complex.I * (a : ℂ) * (u : ℂ))
          + Complex.exp (Complex.I * ((-a : ℝ) : ℂ) * (u : ℂ))) := by
    funext u
    rw [Complex.cos]
    have h1 : ((a * (u : ℂ) : ℂ) * Complex.I) = Complex.I * (a : ℂ) * (u : ℂ) := by
      push_cast
      ring
    have h2 : (-(a * (u : ℂ)) : ℂ) * Complex.I = Complex.I * ((-a : ℝ) : ℂ) * (u : ℂ) := by
      push_cast
      ring
    rw [h1, h2]
    ring
  rw [hg]
  rw [fourierG_const_mul (c := (1 / 2 : ℂ)) _
    (by continuity)]
  rw [fourierG_add _ _ (by continuity) (by continuity)]
  rw [fourierG_exp_I_eq a x hax]
  have hax2' : (-a) ≠ x := by
    intro h
    exact hax2 (by linarith)
  have hexp2 : fourierG (fun u : ℝ => Complex.exp (Complex.I * ((-a : ℝ) : ℂ) * (u : ℂ))) x
      = 2 * (Real.sin ((-a) - x) : ℂ) / (((-a : ℝ) : ℂ) - (x : ℂ)) :=
    fourierG_exp_I_eq (-a) x hax2'
  rw [hexp2]
  have hden1 : ((a : ℂ) - (x : ℂ)) ≠ 0 := by
    intro h
    exact hax (by exact_mod_cast (sub_eq_zero.mp h))
  have hden2 : (-(a : ℂ) - (x : ℂ)) ≠ 0 := by
    intro h
    have hsum : ((a : ℂ) + (x : ℂ)) = 0 := by linear_combination -h
    have hreal : (a : ℝ) + x = 0 := by exact_mod_cast hsum
    exact hax2 (by linarith)
  rw [show ((-a : ℝ) : ℂ) - (x : ℂ) = -(((a : ℂ) + (x : ℂ))) from by push_cast; ring]
  have hsin : Real.sin (-a - x) = -Real.sin (a + x) := by
    rw [show -a - x = -(a + x) by ring, Real.sin_neg]
  rw [hsin]
  field_simp
  push_cast
  ring


/-- **Linearity of the Fourier transform** (subtraction) for continuous functions. -/
theorem fourierG_sub (g h : ℝ → ℂ) (hg : Continuous g) (hh : Continuous h) (x : ℝ) :
    fourierG (fun u => g u - h u) x = fourierG g x - fourierG h x := by
  have hadd := fourierG_add g (fun u => -h u) hg hh.neg x
  rw [show (fun u => g u + (-h u)) = (fun u => g u - h u) from by funext u; ring] at hadd
  have hneg : fourierG (fun u : ℝ => -h u) x = -fourierG h x := by
    have hc := fourierG_const_mul (-1 : ℂ) h hh x
    simpa using hc
  rw [hneg] at hadd
  simpa [sub_eq_add_neg] using hadd


/-- **Fourier transform of a sine**: for real `a ≠ ±x`,
`∫_{−1}^{1} sin(au)·e^{−ixu} du = i·(sin(a+x)/(a+x) − sin(a−x)/(a−x))`. -/
theorem fourierG_sin_eq (a x : ℝ) (hax : a ≠ x) (hax2 : a ≠ -x) :
    fourierG (fun u : ℝ => Complex.sin (a * (u : ℂ))) x
      = Complex.I * ((Real.sin (a + x) : ℂ) / ((a : ℂ) + (x : ℂ))
        - (Real.sin (a - x) : ℂ) / ((a : ℂ) - (x : ℂ))) := by
  have hax2' : (-a) ≠ x := by
    intro h
    exact hax2 (by linarith)
  have hg : (fun u : ℝ => Complex.sin (a * (u : ℂ)))
      = fun u : ℝ => (Complex.I / 2) * (Complex.exp (Complex.I * ((-a : ℝ) : ℂ) * (u : ℂ))
          - Complex.exp (Complex.I * (a : ℂ) * (u : ℂ))) := by
    funext u
    rw [Complex.sin]
    have h1 : (-(a * (u : ℂ)) : ℂ) * Complex.I = Complex.I * ((-a : ℝ) : ℂ) * (u : ℂ) := by
      push_cast
      ring
    have h2 : ((a * (u : ℂ) : ℂ) * Complex.I) = Complex.I * (a : ℂ) * (u : ℂ) := by
      push_cast
      ring
    rw [h1, h2]
    ring
  rw [hg]
  rw [fourierG_const_mul (c := (Complex.I / 2)) _ (by continuity)]
  rw [fourierG_sub _ _ (by continuity) (by continuity)]
  have hexp_neg : fourierG (fun u : ℝ => Complex.exp (Complex.I * ((-a : ℝ) : ℂ) * (u : ℂ))) x
      = 2 * (Real.sin ((-a) - x) : ℂ) / (((-a : ℝ) : ℂ) - (x : ℂ)) :=
    fourierG_exp_I_eq (-a) x hax2'
  rw [hexp_neg, fourierG_exp_I_eq a x hax]
  have hden1 : ((a : ℂ) - (x : ℂ)) ≠ 0 := by
    intro h
    exact hax (by exact_mod_cast (sub_eq_zero.mp h))
  have hden2 : (-(a : ℂ) - (x : ℂ)) ≠ 0 := by
    intro h
    have hsum : ((a : ℂ) + (x : ℂ)) = 0 := by linear_combination -h
    have hreal : (a : ℝ) + x = 0 := by exact_mod_cast hsum
    exact hax2 (by linarith)
  rw [show ((-a : ℝ) : ℂ) - (x : ℂ) = -(((a : ℂ) + (x : ℂ))) from by push_cast; ring]
  have hsin : Real.sin (-a - x) = -Real.sin (a + x) := by
    rw [show -a - x = -(a + x) by ring, Real.sin_neg]
  rw [hsin]
  field_simp
  push_cast
  ring



/-- The Fourier transform of the zero function vanishes. -/
theorem fourierG_zero (x : ℝ) : fourierG (fun _ : ℝ => (0 : ℂ)) x = 0 := by
  unfold fourierG
  simp

/-- The Fourier transform of a negated continuous function. -/
theorem fourierG_neg (g : ℝ → ℂ) (hg : Continuous g) (x : ℝ) :
    fourierG (fun u => -g u) x = -fourierG g x := by
  have hc := fourierG_const_mul (-1 : ℂ) g hg x
  simpa using hc


/-- **Finite-sum linearity of the Fourier transform**. -/
theorem fourierG_finset_sum {ι : Type*} (s : Finset ι) (g : ι → ℝ → ℂ)
    (hg : ∀ i ∈ s, Continuous (g i)) (x : ℝ) :
    fourierG (fun u => ∑ i ∈ s, g i u) x = ∑ i ∈ s, fourierG (g i) x := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [fourierG_zero]
  | insert i s hi ih =>
    have hgi : Continuous (g i) := hg i (by simp)
    have hgs : ∀ j ∈ s, Continuous (g j) := fun j hj => hg j (by simp [hj])
    have hsum : (fun u => ∑ i ∈ insert i s, g i u) = (fun u => g i u + ∑ j ∈ s, g j u) := by
      funext u
      rw [Finset.sum_insert hi]
    rw [hsum, Finset.sum_insert hi,
      fourierG_add (g i) (fun u => ∑ j ∈ s, g j u) hgi (continuous_finset_sum s hgs)]
    rw [ih hgs]


/-- **Congruence of the Fourier transform**: functions agreeing on `[-1,1]` have
the same transform. -/
theorem fourierG_congr {g h : ℝ → ℂ} (hgh : ∀ u ∈ [[(-1 : ℝ), 1]], g u = h u) (x : ℝ) :
    fourierG g x = fourierG h x := by
  unfold fourierG
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  rw [hgh u hu]


/-- **`b = 0` consistency of the exponential transform**: the exponential
family at `b = 0` reduces to the constant transform `2 sin x / x`. -/
theorem fourierG_exp_zero_eq (x : ℝ) (hx : x ≠ 0) :
    fourierG (fun u : ℝ => Complex.exp ((0 : ℂ) * (u : ℂ))) x
      = 2 * (Real.sin x : ℂ) / (x : ℂ) := by
  have hcongr : fourierG (fun u : ℝ => Complex.exp ((0 : ℂ) * (u : ℂ))) x
      = fourierG (fun _ : ℝ => (1 : ℂ)) x :=
    fourierG_congr (g := fun u : ℝ => Complex.exp ((0 : ℂ) * (u : ℂ)))
      (h := fun _ : ℝ => (1 : ℂ)) (by intro u hu; simp) x
  rw [hcongr, fourierG_one_eq x hx]


/-- **The constant transform at `x = 0`**: `fourierG (fun _ => c) 0 = 2c`,
the value at the removable singularity of `2 sin x / x`. -/
theorem fourierG_const_zero (c : ℂ) : fourierG (fun _ : ℝ => c) 0 = 2 * c := by
  unfold fourierG
  simp only [Complex.ofReal_zero, mul_zero, zero_mul, neg_zero, Complex.exp_zero, mul_one]
  rw [intervalIntegral.integral_const]
  norm_num


/-- The antiderivative of `u·e^{−ixu}`: derivative of
`e^{−ixu}(i/x·u + 1/x²)` is `u·e^{−ixu}`. -/
theorem hasDerivAt_antideriv_id_mul_cexp (x : ℝ) (u : ℝ) (hx : x ≠ 0) :
    HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
        * (Complex.I / (x : ℂ) * (u : ℂ) + 1 / (x : ℂ) ^ 2))
      ((u : ℂ) * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) u := by
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
  have hexp : HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))) u := by
    have hlin : HasDerivAt (fun u : ℝ => -(Complex.I * (x : ℂ) * (u : ℂ)))
        (-(Complex.I * (x : ℂ))) u := by
      have h0 : HasDerivAt (fun u : ℝ => Complex.I * (x : ℂ) * (u : ℂ))
          (Complex.I * (x : ℂ)) u := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (x : ℂ))
      exact h0.neg
    exact (Complex.hasDerivAt_exp _).comp u hlin
  have hpoly : HasDerivAt (fun u : ℝ => Complex.I / (x : ℂ) * (u : ℂ) + 1 / (x : ℂ) ^ 2)
      (Complex.I / (x : ℂ)) u := by
    have h0 : HasDerivAt (fun u : ℝ => (u : ℂ)) 1 u := Complex.ofRealCLM.hasDerivAt
    have := (h0.const_mul (Complex.I / (x : ℂ))).add_const (1 / (x : ℂ) ^ 2)
    simpa using this
  have h := hexp.mul hpoly
  have hA : -(Complex.I * (x : ℂ))
      * (Complex.I / (x : ℂ) * (u : ℂ) + 1 / (x : ℂ) ^ 2) + Complex.I / (x : ℂ) = (u : ℂ) := by
    field_simp [hcx]
    ring_nf
    rw [hI2]
    ring
  convert h using 1
  calc (u : ℂ) * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
      = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (u : ℂ) := by ring
    _ = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
          * (-(Complex.I * (x : ℂ)) * (Complex.I / (x : ℂ) * (u : ℂ) + 1 / (x : ℂ) ^ 2)
            + Complex.I / (x : ℂ)) := by rw [hA]
    _ = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))
          * (Complex.I / (x : ℂ) * (u : ℂ) + 1 / (x : ℂ) ^ 2)
        + Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (Complex.I / (x : ℂ)) := by ring


/-- **Fourier transform of the identity**: for real `x ≠ 0`,
`∫_{−1}^{1} u·e^{−ixu} du = e^{−ix}(i/x + 1/x²) − e^{ix}(−i/x + 1/x²)`. -/
theorem fourierG_id_eq (x : ℝ) (hx : x ≠ 0) :
    fourierG (fun u : ℝ => (u : ℂ)) x
      = Complex.exp (-(Complex.I * (x : ℂ))) * (Complex.I / (x : ℂ) + 1 / (x : ℂ) ^ 2)
        - Complex.exp (Complex.I * (x : ℂ)) * (-(Complex.I / (x : ℂ)) + 1 / (x : ℂ) ^ 2) := by
  unfold fourierG
  have hmain : (∫ u : ℝ in (-1)..1, (u : ℂ) * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = Complex.exp (-(Complex.I * (x : ℂ) * (((1 : ℝ)) : ℂ)))
          * (Complex.I / (x : ℂ) * (((1 : ℝ)) : ℂ) + 1 / (x : ℂ) ^ 2)
        - Complex.exp (-(Complex.I * (x : ℂ) * (((-1 : ℝ)) : ℂ)))
          * (Complex.I / (x : ℂ) * (((-1 : ℝ)) : ℂ) + 1 / (x : ℂ) ^ 2) := by
    refine intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
        * (Complex.I / (x : ℂ) * (u : ℂ) + 1 / (x : ℂ) ^ 2))
      (f' := fun u : ℝ => (u : ℂ) * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) ?_ ?_
    · intro u hu
      exact hasDerivAt_antideriv_id_mul_cexp x u hx
    · apply Continuous.intervalIntegrable
      fun_prop
  rw [show (∫ u : ℝ in (-1)..1,
        (fun u : ℝ => (u : ℂ)) u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1, (u : ℂ) * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) from by
    apply intervalIntegral.integral_congr
    intro u hu
    simp]
  rw [hmain]
  push_cast
  rw [show -(Complex.I * (x : ℂ) * 1) = -(Complex.I * (x : ℂ)) from by ring]
  rw [show -(Complex.I * (x : ℂ) * -1) = Complex.I * (x : ℂ) from by ring]
  ring


/-- The antiderivative of `u²·e^{−ixu}`: derivative of
`e^{−ixu}(i/x·u² + 2/x²·u − 2i/x³)` is `u²·e^{−ixu}`. -/
theorem hasDerivAt_antideriv_sq_mul_cexp (x : ℝ) (u : ℝ) (hx : x ≠ 0) :
    HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
        * (Complex.I / (x : ℂ) * (u : ℂ) ^ 2 + 2 / (x : ℂ) ^ 2 * (u : ℂ)
          - 2 * Complex.I / (x : ℂ) ^ 3))
      ((u : ℂ) ^ 2 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) u := by
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
  have hexp : HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))) u := by
    have hlin : HasDerivAt (fun u : ℝ => -(Complex.I * (x : ℂ) * (u : ℂ)))
        (-(Complex.I * (x : ℂ))) u := by
      have h0 : HasDerivAt (fun u : ℝ => Complex.I * (x : ℂ) * (u : ℂ))
          (Complex.I * (x : ℂ)) u := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (x : ℂ))
      exact h0.neg
    exact (Complex.hasDerivAt_exp _).comp u hlin
  have hpoly : HasDerivAt (fun u : ℝ => Complex.I / (x : ℂ) * (u : ℂ) ^ 2
      + 2 / (x : ℂ) ^ 2 * (u : ℂ) - 2 * Complex.I / (x : ℂ) ^ 3)
      (Complex.I / (x : ℂ) * (2 * (u : ℂ)) + 2 / (x : ℂ) ^ 2) u := by
    have h0 : HasDerivAt (fun u : ℝ => (u : ℂ)) 1 u := Complex.ofRealCLM.hasDerivAt
    have hsq : HasDerivAt (fun u : ℝ => (u : ℂ) ^ 2) (2 * (u : ℂ)) u := by
      have := h0.pow 2
      simpa [Pi.pow_def] using this
    have hq := ((hsq.const_mul (Complex.I / (x : ℂ))).add (h0.const_mul (2 / (x : ℂ) ^ 2))).sub_const
      (2 * Complex.I / (x : ℂ) ^ 3)
    convert hq using 1
    ring
  have h := hexp.mul hpoly
  have hA : -(Complex.I * (x : ℂ)) * (Complex.I / (x : ℂ) * (u : ℂ) ^ 2
        + 2 / (x : ℂ) ^ 2 * (u : ℂ) - 2 * Complex.I / (x : ℂ) ^ 3)
      + (Complex.I / (x : ℂ) * (2 * (u : ℂ)) + 2 / (x : ℂ) ^ 2) = (u : ℂ) ^ 2 := by
    field_simp [hcx]
    ring_nf
    rw [hI2]
    ring
  convert h using 1
  calc (u : ℂ) ^ 2 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
      = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (u : ℂ) ^ 2 := by ring
    _ = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
          * (-(Complex.I * (x : ℂ)) * (Complex.I / (x : ℂ) * (u : ℂ) ^ 2
              + 2 / (x : ℂ) ^ 2 * (u : ℂ) - 2 * Complex.I / (x : ℂ) ^ 3)
            + (Complex.I / (x : ℂ) * (2 * (u : ℂ)) + 2 / (x : ℂ) ^ 2)) := by rw [hA]
    _ = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))
          * (Complex.I / (x : ℂ) * (u : ℂ) ^ 2 + 2 / (x : ℂ) ^ 2 * (u : ℂ)
            - 2 * Complex.I / (x : ℂ) ^ 3)
        + Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
          * (Complex.I / (x : ℂ) * (2 * (u : ℂ)) + 2 / (x : ℂ) ^ 2) := by ring


/-- **Fourier transform of the square**: for real `x ≠ 0`,
`∫_{−1}^{1} u²·e^{−ixu} du = e^{−ix}(i/x + 2/x² − 2i/x³) − e^{ix}(i/x − 2/x² − 2i/x³)`. -/
theorem fourierG_sq_eq (x : ℝ) (hx : x ≠ 0) :
    fourierG (fun u : ℝ => (u : ℂ) ^ 2) x
      = Complex.exp (-(Complex.I * (x : ℂ)))
          * (Complex.I / (x : ℂ) + 2 / (x : ℂ) ^ 2 - 2 * Complex.I / (x : ℂ) ^ 3)
        - Complex.exp (Complex.I * (x : ℂ))
          * (Complex.I / (x : ℂ) - 2 / (x : ℂ) ^ 2 - 2 * Complex.I / (x : ℂ) ^ 3) := by
  unfold fourierG
  have hmain : (∫ u : ℝ in (-1)..1,
      (u : ℂ) ^ 2 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = Complex.exp (-(Complex.I * (x : ℂ) * (((1 : ℝ)) : ℂ)))
          * (Complex.I / (x : ℂ) * (((1 : ℝ)) : ℂ) ^ 2 + 2 / (x : ℂ) ^ 2 * (((1 : ℝ)) : ℂ)
            - 2 * Complex.I / (x : ℂ) ^ 3)
        - Complex.exp (-(Complex.I * (x : ℂ) * (((-1 : ℝ)) : ℂ)))
          * (Complex.I / (x : ℂ) * (((-1 : ℝ)) : ℂ) ^ 2 + 2 / (x : ℂ) ^ 2 * (((-1 : ℝ)) : ℂ)
            - 2 * Complex.I / (x : ℂ) ^ 3) := by
    refine intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
        * (Complex.I / (x : ℂ) * (u : ℂ) ^ 2 + 2 / (x : ℂ) ^ 2 * (u : ℂ)
          - 2 * Complex.I / (x : ℂ) ^ 3))
      (f' := fun u : ℝ => (u : ℂ) ^ 2 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) ?_ ?_
    · intro u hu
      exact hasDerivAt_antideriv_sq_mul_cexp x u hx
    · apply Continuous.intervalIntegrable
      fun_prop
  rw [show (∫ u : ℝ in (-1)..1,
        (fun u : ℝ => (u : ℂ) ^ 2) u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1,
          (u : ℂ) ^ 2 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) from by
    apply intervalIntegral.integral_congr
    intro u hu
    simp]
  rw [hmain]
  push_cast
  rw [show -(Complex.I * (x : ℂ) * 1) = -(Complex.I * (x : ℂ)) from by ring]
  rw [show -(Complex.I * (x : ℂ) * -1) = Complex.I * (x : ℂ) from by ring]
  ring


/-- The identity transform at `x = 0`: `∫_{−1}^{1} u du = 0`. -/
theorem fourierG_id_zero : fourierG (fun u : ℝ => (u : ℂ)) 0 = 0 := by
  unfold fourierG
  simp only [Complex.ofReal_zero, zero_mul, mul_zero, neg_zero, Complex.exp_zero, mul_one]
  rw [intervalIntegral.integral_ofReal]
  norm_num [integral_id]

/-- The square transform at `x = 0`: `∫_{−1}^{1} u² du = 2/3`. -/
theorem fourierG_sq_zero : fourierG (fun u : ℝ => (u : ℂ) ^ 2) 0 = 2 / 3 := by
  unfold fourierG
  simp only [Complex.ofReal_zero, zero_mul, mul_zero, neg_zero, Complex.exp_zero, mul_one]
  have hfun : (fun u : ℝ => (u : ℂ) ^ 2) = fun u : ℝ => ((u ^ 2 : ℝ) : ℂ) := by
    funext u
    push_cast
    ring
  rw [hfun, intervalIntegral.integral_ofReal, integral_pow]
  norm_num


/-- **Modulation property of the Fourier transform**:
`fourierG (fun u => e^{iau}·g(u)) x = fourierG g (x − a)`. -/
theorem fourierG_modulation (a : ℝ) (g : ℝ → ℂ) (x : ℝ) :
    fourierG (fun u => Complex.exp (Complex.I * (a : ℂ) * (u : ℂ)) * g u) x
      = fourierG g (x - a) := by
  unfold fourierG
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  have hpoint : Complex.exp (Complex.I * (a : ℂ) * (u : ℂ)) * g u
        * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
      = g u * Complex.exp (-(Complex.I * ((x - a : ℝ) : ℂ) * (u : ℂ))) := by
    rw [show Complex.exp (Complex.I * (a : ℂ) * (u : ℂ)) * g u
        = g u * Complex.exp (Complex.I * (a : ℂ) * (u : ℂ)) from by ring]
    rw [mul_assoc, ← Complex.exp_add]
    congr 2
    · congr 1
      push_cast
      ring
  exact hpoint


/-- **Conjugation under the Fourier transform**:
`conj(fourierG g x) = fourierG (fun u => conj(g u)) (−x)`. -/
theorem fourierG_conj_shift (g : ℝ → ℂ) (x : ℝ)
    (hg : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) volume (-1) 1) :
    (starRingEnd ℂ) (fourierG g x)
      = fourierG (fun u : ℝ => (starRingEnd ℂ) (g u)) (-x) := by
  unfold fourierG
  rw [← integral_conj_interval hg]
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  rw [map_mul, ← Complex.exp_conj]
  congr 2
  · congr 1
    simp [map_mul, Complex.conj_I]


/-- The antiderivative of `u³·e^{−ixu}`. -/
theorem hasDerivAt_antideriv_cube_mul_cexp (x : ℝ) (u : ℝ) (hx : x ≠ 0) :
    HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
        * (Complex.I / (x : ℂ) * (u : ℂ) ^ 3 + 3 / (x : ℂ) ^ 2 * (u : ℂ) ^ 2
          - 6 * Complex.I / (x : ℂ) ^ 3 * (u : ℂ) - 6 / (x : ℂ) ^ 4))
      ((u : ℂ) ^ 3 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) u := by
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
  have hexp : HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))) u := by
    have hlin : HasDerivAt (fun u : ℝ => -(Complex.I * (x : ℂ) * (u : ℂ)))
        (-(Complex.I * (x : ℂ))) u := by
      have h0 : HasDerivAt (fun u : ℝ => Complex.I * (x : ℂ) * (u : ℂ))
          (Complex.I * (x : ℂ)) u := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (x : ℂ))
      exact h0.neg
    exact (Complex.hasDerivAt_exp _).comp u hlin
  have hpoly : HasDerivAt (fun u : ℝ => Complex.I / (x : ℂ) * (u : ℂ) ^ 3
      + 3 / (x : ℂ) ^ 2 * (u : ℂ) ^ 2 - 6 * Complex.I / (x : ℂ) ^ 3 * (u : ℂ)
      - 6 / (x : ℂ) ^ 4)
      (Complex.I / (x : ℂ) * (3 * (u : ℂ) ^ 2) + 3 / (x : ℂ) ^ 2 * (2 * (u : ℂ))
        - 6 * Complex.I / (x : ℂ) ^ 3) u := by
    have h0 : HasDerivAt (fun u : ℝ => (u : ℂ)) 1 u := Complex.ofRealCLM.hasDerivAt
    have hcube : HasDerivAt (fun u : ℝ => (u : ℂ) ^ 3) (3 * (u : ℂ) ^ 2) u := by
      have := h0.pow 3
      simpa [Pi.pow_def] using this
    have hsq : HasDerivAt (fun u : ℝ => (u : ℂ) ^ 2) (2 * (u : ℂ)) u := by
      have := h0.pow 2
      simpa [Pi.pow_def] using this
    have hq := (((hcube.const_mul (Complex.I / (x : ℂ))).add (hsq.const_mul (3 / (x : ℂ) ^ 2))).sub
      (h0.const_mul (6 * Complex.I / (x : ℂ) ^ 3))).sub_const (6 / (x : ℂ) ^ 4)
    convert hq using 1
    ring
  have h := hexp.mul hpoly
  have hA : -(Complex.I * (x : ℂ)) * (Complex.I / (x : ℂ) * (u : ℂ) ^ 3
        + 3 / (x : ℂ) ^ 2 * (u : ℂ) ^ 2 - 6 * Complex.I / (x : ℂ) ^ 3 * (u : ℂ)
        - 6 / (x : ℂ) ^ 4)
      + (Complex.I / (x : ℂ) * (3 * (u : ℂ) ^ 2) + 3 / (x : ℂ) ^ 2 * (2 * (u : ℂ))
        - 6 * Complex.I / (x : ℂ) ^ 3) = (u : ℂ) ^ 3 := by
    field_simp [hcx]
    ring_nf
    rw [hI2]
    ring
  convert h using 1
  calc (u : ℂ) ^ 3 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
      = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (u : ℂ) ^ 3 := by ring
    _ = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
          * (-(Complex.I * (x : ℂ)) * (Complex.I / (x : ℂ) * (u : ℂ) ^ 3
              + 3 / (x : ℂ) ^ 2 * (u : ℂ) ^ 2 - 6 * Complex.I / (x : ℂ) ^ 3 * (u : ℂ)
              - 6 / (x : ℂ) ^ 4)
            + (Complex.I / (x : ℂ) * (3 * (u : ℂ) ^ 2) + 3 / (x : ℂ) ^ 2 * (2 * (u : ℂ))
              - 6 * Complex.I / (x : ℂ) ^ 3)) := by rw [hA]
    _ = Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))
          * (Complex.I / (x : ℂ) * (u : ℂ) ^ 3 + 3 / (x : ℂ) ^ 2 * (u : ℂ) ^ 2
            - 6 * Complex.I / (x : ℂ) ^ 3 * (u : ℂ) - 6 / (x : ℂ) ^ 4)
        + Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
          * (Complex.I / (x : ℂ) * (3 * (u : ℂ) ^ 2) + 3 / (x : ℂ) ^ 2 * (2 * (u : ℂ))
            - 6 * Complex.I / (x : ℂ) ^ 3) := by ring


/-- **Fourier transform of the cube**: for real `x ≠ 0`,
`∫_{−1}^{1} u³·e^{−ixu} du = e^{−ix}(i/x + 3/x² − 6i/x³ − 6/x⁴)
  − e^{ix}(−i/x + 3/x² + 6i/x³ − 6/x⁴)`. -/
theorem fourierG_cube_eq (x : ℝ) (hx : x ≠ 0) :
    fourierG (fun u : ℝ => (u : ℂ) ^ 3) x
      = Complex.exp (-(Complex.I * (x : ℂ)))
          * (Complex.I / (x : ℂ) + 3 / (x : ℂ) ^ 2 - 6 * Complex.I / (x : ℂ) ^ 3
            - 6 / (x : ℂ) ^ 4)
        - Complex.exp (Complex.I * (x : ℂ))
          * (-(Complex.I / (x : ℂ)) + 3 / (x : ℂ) ^ 2 + 6 * Complex.I / (x : ℂ) ^ 3
            - 6 / (x : ℂ) ^ 4) := by
  unfold fourierG
  have hmain : (∫ u : ℝ in (-1)..1,
      (u : ℂ) ^ 3 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = Complex.exp (-(Complex.I * (x : ℂ) * (((1 : ℝ)) : ℂ)))
          * (Complex.I / (x : ℂ) * (((1 : ℝ)) : ℂ) ^ 3
            + 3 / (x : ℂ) ^ 2 * (((1 : ℝ)) : ℂ) ^ 2
            - 6 * Complex.I / (x : ℂ) ^ 3 * (((1 : ℝ)) : ℂ) - 6 / (x : ℂ) ^ 4)
        - Complex.exp (-(Complex.I * (x : ℂ) * (((-1 : ℝ)) : ℂ)))
          * (Complex.I / (x : ℂ) * (((-1 : ℝ)) : ℂ) ^ 3
            + 3 / (x : ℂ) ^ 2 * (((-1 : ℝ)) : ℂ) ^ 2
            - 6 * Complex.I / (x : ℂ) ^ 3 * (((-1 : ℝ)) : ℂ) - 6 / (x : ℂ) ^ 4) := by
    refine intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
        * (Complex.I / (x : ℂ) * (u : ℂ) ^ 3 + 3 / (x : ℂ) ^ 2 * (u : ℂ) ^ 2
          - 6 * Complex.I / (x : ℂ) ^ 3 * (u : ℂ) - 6 / (x : ℂ) ^ 4))
      (f' := fun u : ℝ => (u : ℂ) ^ 3 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) ?_ ?_
    · intro u hu
      exact hasDerivAt_antideriv_cube_mul_cexp x u hx
    · apply Continuous.intervalIntegrable
      fun_prop
  rw [show (∫ u : ℝ in (-1)..1,
        (fun u : ℝ => (u : ℂ) ^ 3) u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1,
          (u : ℂ) ^ 3 * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) from by
    apply intervalIntegral.integral_congr
    intro u hu
    simp]
  rw [hmain]
  push_cast
  rw [show -(Complex.I * (x : ℂ) * 1) = -(Complex.I * (x : ℂ)) from by ring]
  rw [show -(Complex.I * (x : ℂ) * -1) = Complex.I * (x : ℂ) from by ring]
  ring



/-- The cosine transform at `x = 0`: `∫_{−1}^{1} cos(au) du = 2 sin a / a`. -/
theorem fourierG_cos_zero (a : ℝ) (ha : a ≠ 0) :
    fourierG (fun u : ℝ => Complex.cos (a * (u : ℂ))) 0 = 2 * (Real.sin a : ℂ) / (a : ℂ) := by
  have h := fourierG_cos_eq a 0 ha (by simpa using ha)
  rw [h]
  norm_num
  ring

/-- The sine transform at `x = 0`: `∫_{−1}^{1} sin(au) du = 0` (odd integrand). -/
theorem fourierG_sin_zero (a : ℝ) (ha : a ≠ 0) :
    fourierG (fun u : ℝ => Complex.sin (a * (u : ℂ))) 0 = 0 := by
  have h := fourierG_sin_eq a 0 ha (by simpa using ha)
  rw [h]
  norm_num




/-- The cube transform at `x = 0`: `∫_{−1}^{1} u³ du = 0` (odd integrand). -/
theorem fourierG_cube_zero : fourierG (fun u : ℝ => (u : ℂ) ^ 3) 0 = 0 := by
  unfold fourierG
  simp only [Complex.ofReal_zero, zero_mul, mul_zero, neg_zero, Complex.exp_zero, mul_one]
  have hfun : (fun u : ℝ => (u : ℂ) ^ 3) = fun u : ℝ => ((u ^ 3 : ℝ) : ℂ) := by
    funext u
    push_cast
    ring
  rw [hfun, intervalIntegral.integral_ofReal, integral_pow]
  norm_num



/-- The quartic moment at `x = 0`: `∫_{−1}^{1} u⁴ du = 2/5`. -/
theorem fourierG_quartic_zero : fourierG (fun u : ℝ => (u : ℂ) ^ 4) 0 = 2 / 5 := by
  unfold fourierG
  simp only [Complex.ofReal_zero, zero_mul, mul_zero, neg_zero, Complex.exp_zero, mul_one]
  have hfun : (fun u : ℝ => (u : ℂ) ^ 4) = fun u : ℝ => ((u ^ 4 : ℝ) : ℂ) := by
    funext u
    push_cast
    ring
  rw [hfun, intervalIntegral.integral_ofReal, integral_pow]
  norm_num


/-- **Conjugation symmetry for real-valued test functions**:
`conj(fourierG g x) = fourierG g (−x)` when `g` is real-valued. -/
theorem fourierG_real_conj (g : ℝ → ℂ) (hg : Continuous g)
    (hreal : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u) (x : ℝ) :
    (starRingEnd ℂ) (fourierG g x) = fourierG g (-x) := by
  have hgint : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) volume (-1) 1 :=
    (hg.mul (Complex.continuous_exp.comp (by continuity))).intervalIntegrable _ _
  rw [fourierG_conj_shift g x hgint]
  exact fourierG_congr (g := fun u : ℝ => (starRingEnd ℂ) (g u)) (h := g)
    (by intro u hu; exact hreal u) (-x)


/-- **Differentiation under the integral sign for the Fourier transform**:
`d/dx ĝ(x) = fourierG (fun u => −iu·g(u)) x`. -/
theorem hasDerivAt_fourierG (g : ℝ → ℂ) (hg : Continuous g) (x : ℝ) :
    HasDerivAt (fun x => fourierG g x)
      (fourierG (fun u : ℝ => -(Complex.I * (u : ℂ)) * g u) x) x := by
  unfold fourierG
  have hs : Metric.ball x 1 ∈ 𝓝 x := Metric.ball_mem_nhds x zero_lt_one
  have hF_meas : ∀ᶠ (y : ℝ) in 𝓝 x, AEStronglyMeasurable
      (fun t : ℝ => g t * Complex.exp (-(Complex.I * (y : ℂ) * (t : ℂ))))
      (volume.restrict (Ι (-1) 1)) := by
    filter_upwards with y
    apply Continuous.aestronglyMeasurable
    fun_prop
  have hF_int : IntervalIntegrable
      (fun t : ℝ => g t * Complex.exp (-(Complex.I * (x : ℂ) * (t : ℂ)))) volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    fun_prop
  have hF'_meas : AEStronglyMeasurable
      (fun t : ℝ => g t * (-(Complex.I * (t : ℂ)))
        * Complex.exp (-(Complex.I * (x : ℂ) * (t : ℂ)))) (volume.restrict (Ι (-1) 1)) := by
    apply Continuous.aestronglyMeasurable
    fun_prop
  have h_bound : ∀ᵐ t ∂volume, t ∈ Ι (-1) 1 →
      ∀ y ∈ Metric.ball x 1,
        ‖g t * (-(Complex.I * (t : ℂ)))
          * Complex.exp (-(Complex.I * (y : ℂ) * (t : ℂ)))‖ ≤ ‖g t‖ := by
    filter_upwards with t ht y hy
    have ht_abs : |t| ≤ 1 := by
      rw [abs_le]
      exact ⟨by simpa using le_of_lt ht.1, by simpa using ht.2⟩
    have hexp : ‖Complex.exp (-(Complex.I * ((y : ℝ) : ℂ) * (t : ℂ)))‖ = 1 := by
      rw [Complex.norm_exp]
      have hre : (-(Complex.I * ((y : ℝ) : ℂ) * ((t : ℝ) : ℂ))).re = 0 := by simp
      rw [hre, Real.exp_zero]
    rw [norm_mul, norm_mul]
    have ht_norm : ‖(-(Complex.I * (t : ℂ)))‖ = |t| := by
      rw [norm_neg, norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
    rw [ht_norm, hexp, mul_one]
    exact mul_le_of_le_one_right (norm_nonneg _) ht_abs
  have hbound_int : IntervalIntegrable (fun t : ℝ => ‖g t‖) volume (-1) 1 :=
    hg.norm.intervalIntegrable _ _
  have h_diff : ∀ᵐ t ∂volume, t ∈ Ι (-1) 1 → ∀ y ∈ Metric.ball x 1,
      HasDerivAt (fun (y : ℝ) => g t * Complex.exp (-(Complex.I * (y : ℂ) * (t : ℂ))))
        (g t * (-(Complex.I * (t : ℂ))) * Complex.exp (-(Complex.I * (y : ℂ) * (t : ℂ)))) y := by
    filter_upwards with t ht y hy
    have hlin : HasDerivAt (fun y : ℝ => -(Complex.I * ((y : ℝ) : ℂ) * (t : ℂ)))
        (-(Complex.I * (t : ℂ))) y := by
      have h0 : HasDerivAt (fun y : ℝ => Complex.I * ((y : ℝ) : ℂ) * (t : ℂ))
          (Complex.I * (t : ℂ)) y := by
        have hbase : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 y :=
          Complex.ofRealCLM.hasDerivAt
        have hmul : HasDerivAt (fun y : ℝ => (y : ℂ) * (Complex.I * (t : ℂ)))
            (1 * (Complex.I * (t : ℂ))) y :=
          hbase.mul_const (Complex.I * (t : ℂ))
        convert hmul using 1
        · ext y; ring
        · ring
      exact h0.neg
    have hexp : HasDerivAt (fun y : ℝ => Complex.exp (-(Complex.I * ((y : ℝ) : ℂ) * (t : ℂ))))
        (Complex.exp (-(Complex.I * ((y : ℝ) : ℂ) * (t : ℂ))) * (-(Complex.I * (t : ℂ)))) y :=
      (Complex.hasDerivAt_exp _).comp y hlin
    have h := hexp.const_mul (g t)
    convert h using 1
    ring
  obtain ⟨-, hder⟩ := intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (μ := volume) (a := (-1 : ℝ)) (b := 1)
    (F := fun (x : ℝ) t => g t * Complex.exp (-(Complex.I * (x : ℂ) * (t : ℂ))))
    (F' := fun (x : ℝ) t => g t * (-(Complex.I * (t : ℂ)))
      * Complex.exp (-(Complex.I * (x : ℂ) * (t : ℂ))))
    (x₀ := x) (s := Metric.ball x 1) (bound := fun t : ℝ => ‖g t‖)
    hs hF_meas hF_int hF'_meas h_bound hbound_int h_diff
  convert hder using 1
  apply intervalIntegral.integral_congr
  intro t ht
  ring


/-- **The derivative of the Fourier transform as a `deriv` identity**:
`deriv ĝ x = fourierG (fun u => −iu·g(u)) x`. -/
theorem deriv_fourierG (g : ℝ → ℂ) (hg : Continuous g) (x : ℝ) :
    deriv (fun x => fourierG g x) x = fourierG (fun u : ℝ => -(Complex.I * (u : ℂ)) * g u) x :=
  (hasDerivAt_fourierG g hg x).deriv

/-- **Second-order moment correspondence**: the derivative of
`x ↦ fourierG (−iu·g) x` is `fourierG ((−iu)²·g) x`. -/
theorem hasDerivAt_fourierG_moment (g : ℝ → ℂ) (hg : Continuous g) (x : ℝ) :
    HasDerivAt (fun x => fourierG (fun u : ℝ => -(Complex.I * (u : ℂ)) * g u) x)
      (fourierG (fun u : ℝ => -(Complex.I * (u : ℂ)) * (-(Complex.I * (u : ℂ)) * g u)) x) x :=
  hasDerivAt_fourierG (fun u : ℝ => -(Complex.I * (u : ℂ)) * g u)
    ((continuous_const.mul continuous_ofReal).neg.mul hg) x


/-- **Iterated derivative correspondence**: for continuous `g` and every `n`,
`d^n/dx^n ĝ(x) = fourierG (fun u => (−iu)^n·g(u)) x`. -/
theorem iteratedDeriv_fourierG (g : ℝ → ℂ) (hg : Continuous g) (n : ℕ) :
    iteratedDeriv n (fun x => fourierG g x)
      = fun x => fourierG (fun u : ℝ => (-(Complex.I * (u : ℂ))) ^ n * g u) x := by
  induction n with
  | zero =>
    simp [iteratedDeriv_zero]
  | succ n ih =>
    rw [iteratedDeriv_succ, ih]
    funext x
    rw [deriv_fourierG (fun u : ℝ => (-(Complex.I * (u : ℂ))) ^ n * g u)
      (((continuous_const.mul continuous_ofReal).neg.pow n).mul hg) x]
    congr 1
    funext u
    rw [pow_succ]
    ring


/-- **Quantitative Riemann–Lebesgue decay**: for `C¹` `g`, the Fourier transform
decays like `1/|x|`:
`‖ĝ(x)‖ ≤ (‖g(1)‖ + ‖g(−1)‖ + ∫_{−1}^{1}‖g'‖)/|x|`. -/
theorem norm_fourierG_le_div (g g' : ℝ → ℂ) (hg : Continuous g)
    (hderiv : ∀ u : ℝ, HasDerivAt g (g' u) u) (hg' : Continuous g')
    (x : ℝ) (hx : x ≠ 0) :
    ‖fourierG g x‖
      ≤ (‖g 1‖ + ‖g (-1)‖ + ∫ u : ℝ in (-1)..1, ‖g' u‖) / |x| := by
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hIx : (-(Complex.I * (x : ℂ))) ≠ 0 := by
    simp [hcx, Complex.I_ne_zero]
  have hkern : ∀ u : ℝ, HasDerivAt
      (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))
      (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) u := by
    intro u
    have hlin : HasDerivAt (fun u : ℝ => -(Complex.I * (x : ℂ) * (u : ℂ))) (-(Complex.I * (x : ℂ))) u := by
      have h0 : HasDerivAt (fun u : ℝ => Complex.I * (x : ℂ) * (u : ℂ)) (Complex.I * (x : ℂ)) u := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (x : ℂ))
      exact h0.neg
    have hexp : HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
        (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))) u :=
      (Complex.hasDerivAt_exp _).comp u hlin
    have hdiv := hexp.div_const (-(Complex.I * (x : ℂ)))
    convert hdiv using 1
    field_simp [hIx]
  have hcontv : Continuous (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
      / (-(Complex.I * (x : ℂ)))) :=
    (Complex.continuous_exp.comp (by continuity)).div_const _
  have hIBP := intervalIntegral.integral_deriv_mul_eq_sub_of_hasDerivAt
    (a := (-1 : ℝ)) (b := 1)
    (u := g) (v := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))
    (u' := g') (v' := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
    hg.continuousOn hcontv.continuousOn
    (fun u hu => hderiv u) (fun u hu => hkern u)
    (hg'.intervalIntegrable _ _)
    ((Complex.continuous_exp.comp (by continuity)).intervalIntegrable _ _)
  have hsplit : (∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = g 1 * (Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ))))
        - g (-1) * (Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ))))
        - ∫ u : ℝ in (-1)..1,
            g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))) := by
    have hint1 : IntervalIntegrable
        (fun u : ℝ => g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))))
        volume (-1) 1 :=
      (hg'.mul hcontv).intervalIntegrable _ _
    have hint2 : IntervalIntegrable
        (fun u : ℝ => g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) volume (-1) 1 :=
      (hg.mul (Complex.continuous_exp.comp (by continuity))).intervalIntegrable _ _
    rw [intervalIntegral.integral_add hint1 hint2] at hIBP
    have h1 : (1 : ℂ) • (x : ℂ) = (x : ℂ) := by simp
    have hexp1 : Complex.exp (-(Complex.I * (x : ℂ) * ((1 : ℝ) : ℂ)))
        = Complex.exp (-(Complex.I * (x : ℂ))) := by norm_num
    have hexp2 : Complex.exp (-(Complex.I * (x : ℂ) * (((-1 : ℝ)) : ℂ)))
        = Complex.exp (Complex.I * (x : ℂ)) := by
      rw [show -(Complex.I * (x : ℂ) * ((-1 : ℝ) : ℂ)) = Complex.I * (x : ℂ) from by push_cast; ring]
    rw [hexp1, hexp2] at hIBP
    linear_combination hIBP
  have hv_norm : ∀ u : ℝ,
      ‖Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))‖ = 1 / |x| := by
    intro u
    rw [norm_div, Complex.norm_exp, norm_neg, norm_mul, Complex.norm_I, one_mul,
      Complex.norm_real, Real.norm_eq_abs]
    have hre : (-(Complex.I * (x : ℂ) * (u : ℂ))).re = 0 := by simp
    rw [hre, Real.exp_zero, one_div]
  have hv_norm' : ‖Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ)))‖ = 1 / |x| := by
    rw [norm_div, Complex.norm_exp, norm_neg, norm_mul, Complex.norm_I, one_mul,
      Complex.norm_real, Real.norm_eq_abs]
    have hre : (Complex.I * (x : ℂ)).re = 0 := by simp
    rw [hre, Real.exp_zero, one_div]
  rw [show fourierG g x = ∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) from rfl]
  rw [hsplit]
  have htri : ‖g 1 * (Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ))))
        - g (-1) * (Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ))))
        - ∫ u : ℝ in (-1)..1,
            g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))‖
      ≤ ‖g 1‖ / |x| + ‖g (-1)‖ / |x| + (∫ u : ℝ in (-1)..1, ‖g' u‖) / |x| := by
    have h1 : ‖g 1 * (Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ))))‖
        = ‖g 1‖ / |x| := by
      rw [norm_mul, show ‖Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ)))‖ = 1 / |x| from by
        simpa using hv_norm 1, mul_one_div]
    have h2 : ‖g (-1) * (Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ))))‖
        = ‖g (-1)‖ / |x| := by rw [norm_mul, hv_norm', mul_one_div]
    have h3 : ‖∫ u : ℝ in (-1)..1,
        g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))‖
        ≤ (∫ u : ℝ in (-1)..1, ‖g' u‖) / |x| := by
      calc ‖∫ u : ℝ in (-1)..1,
          g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))‖
          ≤ ∫ u : ℝ in (-1)..1,
              ‖g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))‖ :=
            intervalIntegral.norm_integral_le_integral_norm (by norm_num)
        _ = ∫ u : ℝ in (-1)..1, ‖g' u‖ * (1 / |x|) := by
            apply intervalIntegral.integral_congr
            intro u hu
            beta_reduce
            rw [norm_mul, hv_norm u]
        _ = (∫ u : ℝ in (-1)..1, ‖g' u‖) * (1 / |x|) :=
            intervalIntegral.integral_mul_const _ _
        _ = (∫ u : ℝ in (-1)..1, ‖g' u‖) / |x| := by ring
    calc ‖(g 1 * (Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ))))
          - g (-1) * (Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ)))))
          - ∫ u : ℝ in (-1)..1,
              g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))‖
        ≤ ‖g 1 * (Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ))))
            - g (-1) * (Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ))))‖
          + ‖∫ u : ℝ in (-1)..1,
              g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))‖ :=
          norm_sub_le _ _
      _ ≤ (‖g 1‖ / |x| + ‖g (-1)‖ / |x|) + (∫ u : ℝ in (-1)..1, ‖g' u‖) / |x| := by
          gcongr
          exact (norm_sub_le _ _).trans (add_le_add h1.le h2.le)
      _ = ‖g 1‖ / |x| + ‖g (-1)‖ / |x| + (∫ u : ℝ in (-1)..1, ‖g' u‖) / |x| := by ring
  exact htri.trans (le_of_eq (by ring))


/-- **Riemann–Lebesgue lemma**: the Fourier transform of a `C¹` function tends
to `0` at infinity. -/
theorem tendsto_fourierG_atTop (g g' : ℝ → ℂ) (hg : Continuous g)
    (hderiv : ∀ u : ℝ, HasDerivAt g (g' u) u) (hg' : Continuous g') :
    Tendsto (fun x => fourierG g x) atTop (𝓝 0) := by
  set C : ℝ := ‖g 1‖ + ‖g (-1)‖ + ∫ u : ℝ in (-1)..1, ‖g' u‖ with hC
  have hlim : Tendsto (fun x : ℝ => C / x) atTop (𝓝 0) := by
    have h2 : Tendsto (fun x : ℝ => C * x⁻¹) atTop (𝓝 (C * 0)) :=
      tendsto_inv_atTop_zero.const_mul C
    simpa [div_eq_mul_inv] using h2
  refine squeeze_zero_norm' ?_ hlim
  filter_upwards [Ioi_mem_atTop (0 : ℝ)] with x hx
  have hCx : C / x = C / |x| := by rw [abs_of_pos hx]
  rw [hCx]
  exact norm_fourierG_le_div g g' hg hderiv hg' x (ne_of_gt hx)


/-- **Integration by parts for the Fourier transform**:
`ĝ(x) = (g(1)e^{−ix} − g(−1)e^{ix} − fourierG g' x)/(−ix)`. -/
theorem fourierG_ibp (g g' : ℝ → ℂ) (hg : Continuous g)
    (hderiv : ∀ u : ℝ, HasDerivAt g (g' u) u) (hg' : Continuous g')
    (x : ℝ) (hx : x ≠ 0) :
    fourierG g x = (g 1 * Complex.exp (-(Complex.I * (x : ℂ)))
        - g (-1) * Complex.exp (Complex.I * (x : ℂ)) - fourierG g' x)
        / (-(Complex.I * (x : ℂ))) := by
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hIx : (-(Complex.I * (x : ℂ))) ≠ 0 := by simp [hcx, Complex.I_ne_zero]
  have hkern : ∀ u : ℝ, HasDerivAt
      (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))
      (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) u := by
    intro u
    have hlin : HasDerivAt (fun u : ℝ => -(Complex.I * (x : ℂ) * (u : ℂ))) (-(Complex.I * (x : ℂ))) u := by
      have h0 : HasDerivAt (fun u : ℝ => Complex.I * (x : ℂ) * (u : ℂ)) (Complex.I * (x : ℂ)) u := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (x : ℂ))
      exact h0.neg
    have hexp : HasDerivAt (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
        (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) * (-(Complex.I * (x : ℂ)))) u :=
      (Complex.hasDerivAt_exp _).comp u hlin
    have hdiv := hexp.div_const (-(Complex.I * (x : ℂ)))
    convert hdiv using 1
    field_simp [hIx]
  have hcontv : Continuous (fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))
      / (-(Complex.I * (x : ℂ)))) :=
    (Complex.continuous_exp.comp (by continuity)).div_const _
  have hIBP := intervalIntegral.integral_deriv_mul_eq_sub_of_hasDerivAt
    (a := (-1 : ℝ)) (b := 1)
    (u := g) (v := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ))))
    (u' := g') (v' := fun u : ℝ => Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
    hg.continuousOn hcontv.continuousOn
    (fun u hu => hderiv u) (fun u hu => hkern u)
    (hg'.intervalIntegrable _ _)
    ((Complex.continuous_exp.comp (by continuity)).intervalIntegrable _ _)
  have hint1 : IntervalIntegrable
      (fun u : ℝ => g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))))
      volume (-1) 1 :=
    (hg'.mul hcontv).intervalIntegrable _ _
  have hint2 : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) volume (-1) 1 :=
    (hg.mul (Complex.continuous_exp.comp (by continuity))).intervalIntegrable _ _
  rw [intervalIntegral.integral_add hint1 hint2] at hIBP
  have hexp1 : Complex.exp (-(Complex.I * (x : ℂ) * ((1 : ℝ) : ℂ)))
      = Complex.exp (-(Complex.I * (x : ℂ))) := by norm_num
  have hexp2 : Complex.exp (-(Complex.I * (x : ℂ) * (((-1 : ℝ)) : ℂ)))
      = Complex.exp (Complex.I * (x : ℂ)) := by
    rw [show -(Complex.I * (x : ℂ) * ((-1 : ℝ) : ℂ)) = Complex.I * (x : ℂ) from by push_cast; ring]
  rw [hexp1, hexp2] at hIBP
  have hsplit : (∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))))
      = g 1 * (Complex.exp (-(Complex.I * (x : ℂ))) / (-(Complex.I * (x : ℂ))))
        - g (-1) * (Complex.exp (Complex.I * (x : ℂ)) / (-(Complex.I * (x : ℂ))))
        - ∫ u : ℝ in (-1)..1,
            g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))) := by
    linear_combination hIBP
  rw [show fourierG g x = ∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) from rfl,
    hsplit]
  have hg'int : (∫ u : ℝ in (-1)..1,
      g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))))
      = fourierG g' x / (-(Complex.I * (x : ℂ))) := by
    have h1 : fourierG g' x = ∫ u : ℝ in (-1)..1, g' u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) := rfl
    rw [h1]
    have h2 : (∫ u : ℝ in (-1)..1, g' u * (Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ))) / (-(Complex.I * (x : ℂ)))))
        = ∫ u : ℝ in (-1)..1, (g' u * Complex.exp (-(Complex.I * (x : ℂ) * (u : ℂ)))) / (-(Complex.I * (x : ℂ))) := by
      apply intervalIntegral.integral_congr
      intro u hu
      ring
    rw [h2, intervalIntegral.integral_div]
  rw [hg'int]
  field_simp [hIx]
  ring


/-- **Second-order Riemann–Lebesgue decay**: for `C²` `g`, the Fourier
transform decays like `1/|x|²`. -/
theorem norm_fourierG_le_div_sq (g g' g'' : ℝ → ℂ) (hg : Continuous g)
    (hderiv1 : ∀ u : ℝ, HasDerivAt g (g' u) u)
    (hderiv2 : ∀ u : ℝ, HasDerivAt g' (g'' u) u)
    (hg' : Continuous g') (hg'' : Continuous g'') (x : ℝ) (hx : x ≠ 0) :
    ‖fourierG g x‖ ≤ (‖g 1‖ + ‖g (-1)‖) / |x|
      + (‖g' 1‖ + ‖g' (-1)‖ + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x| ^ 2 := by
  have hcx : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  have hIx : (-(Complex.I * (x : ℂ))) ≠ 0 := by simp [hcx, Complex.I_ne_zero]
  have hxnorm : ‖(-(Complex.I * (x : ℂ)))‖ = |x| := by
    rw [norm_neg, norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
  have hb := norm_fourierG_le_div g' g'' hg' hderiv2 hg'' x hx
  rw [fourierG_ibp g g' hg hderiv1 hg' x hx, norm_div, hxnorm]
  have hexp1 : ‖Complex.exp (-(Complex.I * (x : ℂ)))‖ = 1 := by
    rw [Complex.norm_exp]
    have : (-(Complex.I * (x : ℂ))).re = 0 := by simp
    rw [this, Real.exp_zero]
  have hexp2 : ‖Complex.exp (Complex.I * (x : ℂ))‖ = 1 := by
    rw [Complex.norm_exp]
    have : (Complex.I * (x : ℂ)).re = 0 := by simp
    rw [this, Real.exp_zero]
  have hnum : ‖g 1 * Complex.exp (-(Complex.I * (x : ℂ)))
        - g (-1) * Complex.exp (Complex.I * (x : ℂ)) - fourierG g' x‖
      ≤ ‖g 1‖ + ‖g (-1)‖ + (‖g' 1‖ + ‖g' (-1)‖
        + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x| := by
    have h1 : ‖g 1 * Complex.exp (-(Complex.I * (x : ℂ)))‖ = ‖g 1‖ := by
      rw [norm_mul, hexp1, mul_one]
    have h2 : ‖g (-1) * Complex.exp (Complex.I * (x : ℂ))‖ = ‖g (-1)‖ := by
      rw [norm_mul, hexp2, mul_one]
    calc ‖g 1 * Complex.exp (-(Complex.I * (x : ℂ)))
          - g (-1) * Complex.exp (Complex.I * (x : ℂ)) - fourierG g' x‖
        ≤ ‖g 1 * Complex.exp (-(Complex.I * (x : ℂ)))
            - g (-1) * Complex.exp (Complex.I * (x : ℂ))‖ + ‖fourierG g' x‖ := norm_sub_le _ _
      _ ≤ (‖g 1‖ + ‖g (-1)‖) + (‖g' 1‖ + ‖g' (-1)‖
            + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x| := by
          exact add_le_add ((norm_sub_le _ _).trans (add_le_add h1.le h2.le)) hb
      _ = ‖g 1‖ + ‖g (-1)‖ + (‖g' 1‖ + ‖g' (-1)‖
            + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x| := by ring
  have hpos : 0 ≤ |x| := abs_nonneg x
  have hdiv : (‖g 1‖ + ‖g (-1)‖ + (‖g' 1‖ + ‖g' (-1)‖
        + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x|) / |x|
      = (‖g 1‖ + ‖g (-1)‖) / |x|
        + (‖g' 1‖ + ‖g' (-1)‖ + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x| ^ 2 := by
    have hxne : |x| ≠ 0 := abs_ne_zero.mpr hx
    field_simp
  calc ‖g 1 * Complex.exp (-(Complex.I * (x : ℂ)))
        - g (-1) * Complex.exp (Complex.I * (x : ℂ)) - fourierG g' x‖ / |x|
      ≤ (‖g 1‖ + ‖g (-1)‖ + (‖g' 1‖ + ‖g' (-1)‖
          + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x|) / |x| := by
        exact div_le_div_of_nonneg_right hnum hpos
    _ = (‖g 1‖ + ‖g (-1)‖) / |x|
        + (‖g' 1‖ + ‖g' (-1)‖ + ∫ u : ℝ in (-1)..1, ‖g'' u‖) / |x| ^ 2 := hdiv


/-- The zero extension of a function on `[-1,1]`. -/
noncomputable def fourierGExt (g : ℝ → ℂ) : ℝ → ℂ := Set.indicator (Set.Icc (-1) 1) g

/-- **Identification of the full-line Fourier transform with `fourierG`**:
`𝓕 (g_ext) w = fourierG g (2πw)`. -/
theorem fourier_fourierGExt (g : ℝ → ℂ) (hg : Continuous g) (w : ℝ) :
    𝓕 (fourierGExt g) w = fourierG g (2 * Real.pi * w) := by
  rw [Real.fourier_eq']
  have hind : (fun v : ℝ => Complex.exp ((↑(-2 * Real.pi * ⟪v, w⟫) * Complex.I)) • fourierGExt g v)
      = Set.indicator (Set.Icc (-1) 1)
          (fun v : ℝ => Complex.exp ((↑(-2 * Real.pi * ⟪v, w⟫) * Complex.I)) • g v) := by
    ext v
    by_cases hv : v ∈ Set.Icc (-1 : ℝ) 1
    · simp [fourierGExt, hv]
    · simp [fourierGExt, hv]
  rw [hind, integral_indicator measurableSet_Icc]
  rw [integral_Icc_eq_integral_Ioc]
  rw [← intervalIntegral.integral_of_le (by norm_num : (-1 : ℝ) ≤ 1)]
  unfold fourierG
  apply intervalIntegral.integral_congr
  intro u hu
  simp only [smul_eq_mul]
  rw [show ((↑(-2 * Real.pi * ⟪u, w⟫) * Complex.I)) = -(Complex.I * ((2 * Real.pi * w : ℝ) : ℂ) * (u : ℂ)) from by
    rw [Real.inner_apply]
    push_cast
    ring]
  ring


/-- The zero extension of a continuous function on `[-1,1]` is integrable. -/
theorem integrable_fourierGExt (g : ℝ → ℂ) (hg : Continuous g) :
    Integrable (fourierGExt g) := by
  rw [fourierGExt]
  exact (integrable_indicator_iff measurableSet_Icc).mpr
    (hg.continuousOn.integrableOn_compact isCompact_Icc)


/-- **Fourier inversion for `fourierG`, conditional on the integrability of the
transform.**  For continuous `g` supported on `[-1,1]`, at interior points `u`,
`𝓕⁻ (𝓕 g_ext) u = g u`. -/
theorem fourier_inversion_conditional (g : ℝ → ℂ) (hg : Continuous g)
    (hint : Integrable (𝓕 (fourierGExt g))) {u : ℝ} (hu : u ∈ Set.Ioo (-1 : ℝ) 1) :
    𝓕⁻ (𝓕 (fourierGExt g)) u = g u := by
  have hmem : Set.Ioo (-1 : ℝ) 1 ∈ 𝓝 u := isOpen_Ioo.mem_nhds hu
  have heq : fourierGExt g =ᶠ[𝓝 u] g := by
    filter_upwards [hmem] with v hv
    exact Set.indicator_of_mem (Set.Ioo_subset_Icc_self hv) g
  have hcont : ContinuousAt (fourierGExt g) u := hg.continuousAt.congr heq.symm
  have h := (integrable_fourierGExt g hg).fourierInv_fourier_eq hint hcont
  simpa [fourierGExt, Set.indicator_of_mem (Set.Ioo_subset_Icc_self hu)] using h



/-- **Unconditional integrability of the Fourier transform of a `C²` function
vanishing at the endpoints** — the last hypothesis of the inversion theorem. -/
theorem integrable_fourier_fourierGExt (g g' g'' : ℝ → ℂ) (hg : Continuous g)
    (hderiv1 : ∀ u : ℝ, HasDerivAt g (g' u) u)
    (hderiv2 : ∀ u : ℝ, HasDerivAt g' (g'' u) u)
    (hg' : Continuous g') (hg'' : Continuous g'')
    (h1zero : g 1 = 0) (hneg1zero : g (-1) = 0) :
    Integrable (𝓕 (fourierGExt g)) := by
  rw [show 𝓕 (fourierGExt g) = fun w => fourierG g (2 * Real.pi * w) from by
    funext w
    exact fourier_fourierGExt g hg w]
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  set L : ℝ := ∫ u : ℝ in (-1)..1, ‖g u‖ with hL
  set A : ℝ := ‖g' 1‖ + ‖g' (-1)‖ + ∫ u : ℝ in (-1)..1, ‖g'' u‖ with hA
  set C : ℝ := max (2 * L) (A / (2 * Real.pi ^ 2)) with hC
  have hL0 : 0 ≤ L := hL ▸ intervalIntegral.integral_nonneg_of_forall (by norm_num : (-1:ℝ) ≤ 1)
    (fun u => norm_nonneg (g u))
  have hA0 : 0 ≤ A := hA ▸ add_nonneg (add_nonneg (norm_nonneg _) (norm_nonneg _))
    (intervalIntegral.integral_nonneg_of_forall (by norm_num : (-1:ℝ) ≤ 1)
      (fun u => norm_nonneg (g'' u)))
  have hC0 : 0 ≤ C := by
    rw [hC]
    exact le_trans (by linarith : (0:ℝ) ≤ 2 * L) (le_max_left _ _)
  have hbound : ∀ w : ℝ, ‖fourierG g (2 * Real.pi * w)‖ ≤ C * (1 + w ^ 2)⁻¹ := by
    intro w
    by_cases hw : |w| ≤ 1
    · have h1 : ‖fourierG g (2 * Real.pi * w)‖ ≤ L := hL ▸ norm_fourierG_le g hg (2 * Real.pi * w)
      have h2 : L ≤ C / 2 := by
        have h2L : 2 * L ≤ C := hC ▸ le_max_left _ _
        linarith
      have h3 : C / 2 ≤ C * (1 + w ^ 2)⁻¹ := by
        have hden_eq : (1 + w ^ 2)⁻¹ = 1 / (1 + w ^ 2) := by rw [one_div]
        rw [show C / 2 = C * (1 / 2) from by ring, hden_eq]
        have hw2 : w ^ 2 ≤ 1 := by
          rw [← sq_abs w]
          nlinarith [abs_nonneg w, hw]
        apply mul_le_mul_of_nonneg_left _ hC0
        exact one_div_le_one_div_of_le (by positivity) (by linarith)
      linarith
    · have hw1 : 1 < |w| := not_le.mp hw
      have hx : 2 * Real.pi * w ≠ 0 := by
        intro h
        have hw0 : w = 0 := by
          have := congrArg (fun z => z / (2 * Real.pi)) h
          simpa [hpi.ne'] using this
        rw [hw0, abs_zero] at hw1
        norm_num at hw1
      have hxabs : 1 < |2 * Real.pi * w| := by
        rw [abs_mul, abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 2), abs_of_pos hpi]
        nlinarith [Real.pi_gt_three, hw1]
      have hxpos : 0 < |2 * Real.pi * w| := by linarith
      -- integration by parts gives ĝ = fourierG g' x / (ix) because g(±1) = 0
      have hIBP := fourierG_ibp g g' hg hderiv1 hg' (2 * Real.pi * w) hx
      rw [h1zero, hneg1zero] at hIBP
      have hval : fourierG g (2 * Real.pi * w)
          = fourierG g' (2 * Real.pi * w) / (Complex.I * (2 * Real.pi * w : ℝ)) := by
        rw [hIBP]
        push_cast
        field_simp
        ring
      have hg'_bound := norm_fourierG_le_div g' g'' hg' hderiv2 hg'' (2 * Real.pi * w) hx
      have hx2 : |2 * Real.pi * w| ^ 2 = 4 * Real.pi ^ 2 * w ^ 2 := by
        rw [abs_mul, abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 2), abs_of_pos hpi,
          show (2 * Real.pi * |w|) ^ 2 = 4 * Real.pi ^ 2 * |w| ^ 2 from by ring, sq_abs]
      have hIx : ‖(Complex.I * ((2 * Real.pi * w : ℝ) : ℂ))‖ = |2 * Real.pi * w| := by
        rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
      rw [hval, norm_div, hIx]
      calc ‖fourierG g' (2 * Real.pi * w)‖ / |2 * Real.pi * w|
          ≤ A / |2 * Real.pi * w| / |2 * Real.pi * w| := by
            apply div_le_div_of_nonneg_right _ (by positivity)
            rw [hA]
            exact hg'_bound
        _ = A / |2 * Real.pi * w| ^ 2 := by
            rw [div_div]
            field_simp
        _ = A / (4 * Real.pi ^ 2 * w ^ 2) := by rw [hx2]
        _ ≤ A / (2 * Real.pi ^ 2 * (1 + w ^ 2)) := by
            apply div_le_div_of_nonneg_left hA0 (by positivity)
            have hw2 : 1 < w ^ 2 := by rw [← sq_abs w]; nlinarith [sq_nonneg w, hw1]
            nlinarith [sq_nonneg Real.pi]
        _ = A / (2 * Real.pi ^ 2) * (1 + w ^ 2)⁻¹ := by
            field_simp
        _ ≤ C * (1 + w ^ 2)⁻¹ := by
            apply mul_le_mul_of_nonneg_right _ (by positivity)
            exact hC ▸ le_max_right _ _
  have hmeas : AEStronglyMeasurable (fun w : ℝ => fourierG g (2 * Real.pi * w)) volume := by
    apply Continuous.aestronglyMeasurable
    exact (continuous_fourierG g hg).comp (by continuity)
  have hdom : Integrable (fun w : ℝ => C * (1 + w ^ 2)⁻¹) volume :=
    integrable_inv_one_add_sq.const_mul C
  exact hdom.mono' hmeas (Eventually.of_forall hbound)


/-- **Unconditional Fourier inversion for `fourierG`** for `C²` functions
vanishing at the endpoints: at interior points,
`𝓕⁻ (𝓕 g_ext) u = g u`. -/
theorem fourier_inversion (g g' g'' : ℝ → ℂ) (hg : Continuous g)
    (hderiv1 : ∀ u : ℝ, HasDerivAt g (g' u) u)
    (hderiv2 : ∀ u : ℝ, HasDerivAt g' (g'' u) u)
    (hg' : Continuous g') (hg'' : Continuous g'')
    (h1zero : g 1 = 0) (hneg1zero : g (-1) = 0) {u : ℝ} (hu : u ∈ Set.Ioo (-1 : ℝ) 1) :
    𝓕⁻ (𝓕 (fourierGExt g)) u = g u :=
  fourier_inversion_conditional g hg
    (integrable_fourier_fourierGExt g g' g'' hg hderiv1 hderiv2 hg' hg'' h1zero hneg1zero) hu


/-- The Paley–Wiener test function attached to a function `g` on `[-1,1]`:
`h(s) = ∫_{−1}^{1} g(u)·e^{i(s−1/2)u} du`. -/
noncomputable def paleyWiener (g : ℝ → ℂ) (s : ℂ) : ℂ :=
  ∫ u : ℝ in (-1)..1, g u * Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))

/-- **Symmetry of the Paley–Wiener test function** for even `g`:
`h(1−s) = h(s)`. -/
theorem paleyWiener_one_sub (g : ℝ → ℂ) (hge : ∀ u : ℝ, g (-u) = g u) (s : ℂ) :
    paleyWiener g (1 - s) = paleyWiener g s := by
  unfold paleyWiener
  have hexp : ∀ u : ℝ, Complex.I * (1 - s - 1 / 2) * (u : ℂ)
      = -(Complex.I * (s - 1 / 2) * (u : ℂ)) := by
    intro u
    ring
  simp only [hexp]
  rw [show (∫ u : ℝ in (-1)..1, g u * Complex.exp (-(Complex.I * (s - 1 / 2) * (u : ℂ))))
      = ∫ u : ℝ in (-1)..1,
          g (-u) * Complex.exp (-(Complex.I * (s - 1 / 2) * ((-u : ℝ) : ℂ))) from by
    have h := (intervalIntegral.integral_comp_neg
      (f := fun u : ℝ => g u * Complex.exp (-(Complex.I * (s - 1 / 2) * (u : ℂ))))
      (a := (-1 : ℝ)) (b := 1)).symm
    simpa using h]
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  rw [hge u]
  congr 2
  push_cast
  ring

/-- **Conjugation symmetry of the Paley–Wiener test function** for real `g`:
`conj h(s) = h(1 − conj s)`. -/
theorem paleyWiener_conj (g : ℝ → ℂ) (hg : Continuous g)
    (hgr : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u) (s : ℂ) :
    (starRingEnd ℂ) (paleyWiener g s) = paleyWiener g (1 - (starRingEnd ℂ) s) := by
  unfold paleyWiener
  have hint : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))) volume (-1) 1 :=
    (hg.mul (Complex.continuous_exp.comp (by continuity))).intervalIntegrable _ _
  rw [← integral_conj_interval hint]
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  rw [map_mul, hgr u, ← Complex.exp_conj]
  rw [show (starRingEnd ℂ) (Complex.I * (s - 1 / 2) * (u : ℂ))
      = Complex.I * ((1 - (starRingEnd ℂ) s) - 1 / 2) * (u : ℂ) from by
    simp only [map_mul, map_sub, map_one, map_div₀, map_ofNat, Complex.conj_I, Complex.conj_ofReal]
    ring]


/-- **Differentiability of the Paley–Wiener test function**: `h` is entire. -/
theorem hasDerivAt_paleyWiener (g : ℝ → ℂ) (hg : Continuous g) (s : ℂ) :
    HasDerivAt (paleyWiener g)
      (∫ u : ℝ in (-1)..1,
        g u * (Complex.I * (u : ℂ)) * Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))) s := by
  unfold paleyWiener
  have hs : Metric.ball s 1 ∈ 𝓝 s := Metric.ball_mem_nhds s zero_lt_one
  have hF_meas : ∀ᶠ (z : ℂ) in 𝓝 s, AEStronglyMeasurable
      (fun u : ℝ => g u * Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ)))
      (volume.restrict (Ι (-1) 1)) := by
    filter_upwards with z
    apply Continuous.aestronglyMeasurable
    fun_prop
  have hF_int : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))) volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    fun_prop
  have hF'_meas : AEStronglyMeasurable
      (fun u : ℝ => g u * (Complex.I * (u : ℂ))
        * Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))) (volume.restrict (Ι (-1) 1)) := by
    apply Continuous.aestronglyMeasurable
    fun_prop
  have h_bound : ∀ᵐ u ∂volume, u ∈ Ι (-1) 1 →
      ∀ z ∈ Metric.ball s 1,
        ‖g u * (Complex.I * (u : ℂ)) * Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ))‖
          ≤ ‖g u‖ * Real.exp (‖s‖ + 2) := by
    filter_upwards with u hu z hz
    have hu1 : |u| ≤ 1 := by
      rw [abs_le]
      exact ⟨by simpa using le_of_lt hu.1, by simpa using hu.2⟩
    have him : |(z - 1 / 2).im| ≤ ‖s‖ + 2 := by
      have hzim : (z - 1 / 2).im = z.im := by simp
      rw [hzim]
      have h1 : |z.im| ≤ ‖z‖ := Complex.abs_im_le_norm z
      have hz1 : ‖z - s‖ < 1 := by simpa [Complex.dist_eq] using hz
      have h2 : ‖z‖ ≤ ‖s‖ + 1 := by
        have := norm_sub_norm_le z s
        linarith
      linarith
    have hexp : ‖Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ))‖ ≤ Real.exp (‖s‖ + 2) := by
      rw [Complex.norm_exp]
      apply Real.exp_le_exp.mpr
      have hre : (Complex.I * (z - 1 / 2) * (u : ℂ)).re
          = -((z - 1 / 2).im * u) := by
        simp [Complex.mul_re, Complex.I_re, Complex.I_im]
      rw [hre]
      have h1 : |(z - 1 / 2).im * u| ≤ (‖s‖ + 2) * 1 := by
        rw [abs_mul]
        exact mul_le_mul him hu1 (abs_nonneg u) (by positivity)
      calc -((z - 1 / 2).im * u) ≤ |(z - 1 / 2).im * u| := neg_le_abs _
        _ ≤ (‖s‖ + 2) * 1 := h1
        _ = ‖s‖ + 2 := by ring
    have hIu : ‖Complex.I * (u : ℂ)‖ = |u| := by
      rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
    rw [norm_mul, norm_mul, hIu]
    calc ‖g u‖ * |u| * ‖Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ))‖
        ≤ ‖g u‖ * 1 * Real.exp (‖s‖ + 2) := by
          apply mul_le_mul
          · exact mul_le_mul_of_nonneg_left hu1 (norm_nonneg _)
          · exact hexp
          · exact norm_nonneg _
          · positivity
      _ = ‖g u‖ * Real.exp (‖s‖ + 2) := by ring
  have hbound_int : IntervalIntegrable (fun u : ℝ => ‖g u‖ * Real.exp (‖s‖ + 2))
      volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    fun_prop
  have h_diff : ∀ᵐ u ∂volume, u ∈ Ι (-1) 1 → ∀ z ∈ Metric.ball s 1,
      HasDerivAt (fun z : ℂ => g u * Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ)))
        (g u * (Complex.I * (u : ℂ)) * Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ))) z := by
    filter_upwards with u hu z hz
    have hlin : HasDerivAt (fun z : ℂ => Complex.I * (z - 1 / 2) * (u : ℂ))
        (Complex.I * (u : ℂ)) z := by
      have h1 : HasDerivAt (fun z : ℂ => z - 1 / 2) 1 z := by
        simpa using (hasDerivAt_id z).sub_const (1 / 2)
      have h2 := h1.const_mul (Complex.I * (u : ℂ))
      convert h2 using 1
      · ext z
        ring
      · ring
    have hexp : HasDerivAt (fun z : ℂ => Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ)))
        (Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ)) * (Complex.I * (u : ℂ))) z :=
      (Complex.hasDerivAt_exp _).comp z hlin
    have h := hexp.const_mul (g u)
    convert h using 1
    ring
  obtain ⟨-, hder⟩ := intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (μ := volume) (a := (-1 : ℝ)) (b := 1)
    (F := fun (z : ℂ) (u : ℝ) => g u * Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ)))
    (F' := fun (z : ℂ) (u : ℝ) => g u * (Complex.I * (u : ℂ))
      * Complex.exp (Complex.I * (z - 1 / 2) * (u : ℂ)))
    (x₀ := s) (s := Metric.ball s 1) (bound := fun u : ℝ => ‖g u‖ * Real.exp (‖s‖ + 2))
    hs hF_meas hF_int hF'_meas h_bound hbound_int h_diff
  exact hder


/-- The Paley–Wiener test function is entire. -/
theorem differentiable_paleyWiener (g : ℝ → ℂ) (hg : Continuous g) :
    Differentiable ℂ (paleyWiener g) := fun s => (hasDerivAt_paleyWiener g hg s).differentiableAt

/-- The Paley–Wiener test function is differentiable on every open set. -/
theorem differentiableOn_paleyWiener (g : ℝ → ℂ) (hg : Continuous g) (U : Set ℂ) :
    DifferentiableOn ℂ (paleyWiener g) U :=
  (differentiable_paleyWiener g hg).differentiableOn


/-- **The contour-shift identity for the Paley–Wiener test function.** -/
theorem contour_shift_paleyWiener (g : ℝ → ℂ) (hg : Continuous g)
    (hge : ∀ u : ℝ, g (-u) = g u)
    (hgr : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u)
    (S : Finset ℂ) (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : ([[-1, 2]] ×ℂ [[-T, T]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
        * paleyWiener g ((x : ℂ) + (T : ℝ) * I)) volume (-1) 2) :
    ((∑ ρ ∈ S, paleyWiener g ρ) - paleyWiener g 0 - paleyWiener g 1)
        * (2 * (Real.pi : ℂ) * I)
      = 2 * I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * paleyWiener g ((2 : ℝ) + y * I))
        - 2 * I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I)
                * paleyWiener g ((x : ℂ) + (T : ℝ) * I)).im : ℝ) : ℂ)) := by
  have hsymc : ∀ s : ℂ,
      paleyWiener g ((starRingEnd ℂ) s) = (starRingEnd ℂ) (paleyWiener g s) := by
    intro s
    have h1 : paleyWiener g ((starRingEnd ℂ) s) = paleyWiener g (1 - (starRingEnd ℂ) s) :=
      (paleyWiener_one_sub g hge ((starRingEnd ℂ) s)).symm
    rw [h1, ← paleyWiener_conj g hg hgr s]
  exact contour_shift_symmetric' (paleyWiener g) S T hT hU hsub hSU h0_notS h1_notS
    (differentiableOn_paleyWiener g hg U) hF hZ hZ_zero hF_simple hF_ne hS_in
    (fun w _ _ => paleyWiener_one_sub g hge w) hsymc hint


/-- **The Paley–Wiener function of the constant `1`** is the classical
`2 sin(s−1/2)/(s−1/2)`. -/
theorem paleyWiener_one (s : ℂ) (hs : s ≠ 1 / 2) :
    paleyWiener (fun _ : ℝ => (1 : ℂ)) s
      = 2 * Complex.sin (s - 1 / 2) / (s - 1 / 2) := by
  unfold paleyWiener
  have hθ : s - 1 / 2 ≠ 0 := sub_ne_zero.mpr hs
  have hIθ : Complex.I * (s - 1 / 2) ≠ 0 :=
    mul_ne_zero Complex.I_ne_zero hθ
  have hderiv : ∀ u : ℝ, HasDerivAt
      (fun u : ℝ => Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))
        / (Complex.I * (s - 1 / 2)))
      (Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ))) u := by
    intro u
    have hlin : HasDerivAt (fun u : ℝ => Complex.I * (s - 1 / 2) * (u : ℂ))
        (Complex.I * (s - 1 / 2)) u := by
      simpa using (Complex.ofRealCLM.hasDerivAt (x := u)).const_mul (Complex.I * (s - 1 / 2))
    have hexp : HasDerivAt (fun u : ℝ => Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ)))
        (Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ)) * (Complex.I * (s - 1 / 2))) u :=
      (Complex.hasDerivAt_exp _).comp u hlin
    have hdiv := hexp.div_const (Complex.I * (s - 1 / 2))
    convert hdiv using 1
    rw [mul_div_cancel_right₀ _ hIθ]
  have hmain : (∫ u : ℝ in (-1)..1, Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ)))
      = Complex.exp (Complex.I * (s - 1 / 2) * (((1 : ℝ)) : ℂ))
          / (Complex.I * (s - 1 / 2))
        - Complex.exp (Complex.I * (s - 1 / 2) * (((-1 : ℝ)) : ℂ))
          / (Complex.I * (s - 1 / 2)) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun u _ => hderiv u)
      ((Complex.continuous_exp.comp (by continuity)).intervalIntegrable (-1) 1)
  rw [show (∫ u : ℝ in (-1)..1,
        (fun _ : ℝ => (1 : ℂ)) u * Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ)))
      = ∫ u : ℝ in (-1)..1, Complex.exp (Complex.I * (s - 1 / 2) * (u : ℂ)) from by
    apply intervalIntegral.integral_congr
    intro u hu
    simp]
  rw [hmain]
  push_cast
  rw [show Complex.I * (s - 1 / 2) * (1 : ℂ) = Complex.I * (s - 1 / 2) from by ring]
  rw [show Complex.I * (s - 1 / 2) * (-1 : ℂ) = -(Complex.I * (s - 1 / 2)) from by ring]
  rw [Complex.sin]
  rw [show -(s - 1 / 2) * Complex.I = -(Complex.I * (s - 1 / 2)) from by ring]
  rw [show (s - 1 / 2) * Complex.I = Complex.I * (s - 1 / 2) from by ring]
  field_simp [hIθ, hθ]
  have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
  rw [hI2]
  ring


/-- **The Paley–Wiener test function is real on the critical line** for real
`g`: `conj h(1/2+it) = h(1/2+it)`. -/
theorem paleyWiener_critical_line_real (g : ℝ → ℂ) (hg : Continuous g)
    (hgr : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u) (t : ℝ) :
    (starRingEnd ℂ) (paleyWiener g (1 / 2 + (t : ℂ) * I))
      = paleyWiener g (1 / 2 + (t : ℂ) * I) := by
  unfold paleyWiener
  have hint : IntervalIntegrable
      (fun u : ℝ => g u * Complex.exp (Complex.I * ((1 / 2 + (t : ℂ) * I) - 1 / 2) * (u : ℂ)))
      volume (-1) 1 :=
    (hg.mul (Complex.continuous_exp.comp (by continuity))).intervalIntegrable _ _
  rw [← integral_conj_interval hint]
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  rw [map_mul, hgr u, ← Complex.exp_conj]
  have hexp : (starRingEnd ℂ) (Complex.I * ((1 / 2 + (t : ℂ) * I) - 1 / 2) * (u : ℂ))
      = Complex.I * ((1 / 2 + (t : ℂ) * I) - 1 / 2) * (u : ℂ) := by
    have hval : Complex.I * ((1 / 2 + (t : ℂ) * I) - 1 / 2) * (u : ℂ)
        = -((t * u : ℝ) : ℂ) := by
      have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
      push_cast
      ring_nf
      rw [hI2]
      ring
    rw [hval]
    simp
  rw [hexp]



/-- **Kernel split for the Paley–Wiener right-vertical integral**:
`e^{i(2+iy−1/2)u} = e^{3iu/2}·e^{−yu}`. -/
theorem paleyWiener_kernel_split (u y : ℝ) :
    Complex.exp (Complex.I * (((2 : ℝ) + (y : ℂ) * I) - 1 / 2) * (u : ℂ))
      = Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))
        * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)) := by
  rw [← Complex.exp_add]
  congr 1
  have hI2 : (Complex.I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
  push_cast
  ring_nf
  rw [hI2]
  ring



/-- **Global continuity of `y ↦ Z'/Z(c+iy)`** for `c > 1`. -/
theorem continuous_logDeriv_completedZeta_line (c : ℝ) (hc : 1 < c) :
    Continuous (fun y : ℝ => logDeriv completedZeta ((c : ℂ) + (y : ℂ) * I)) := by
  rw [continuous_iff_continuousAt]
  intro y
  have hmem : Set.Icc (y - 1) (y + 1) ∈ 𝓝 y := by
    have h1 : Set.Ioo (y - 1) (y + 1) ∈ 𝓝 y :=
      IsOpen.mem_nhds isOpen_Ioo ⟨by linarith, by linarith⟩
    exact Filter.mem_of_superset h1 (fun z hz => ⟨le_of_lt hz.1, le_of_lt hz.2⟩)
  exact (continuousOn_logDeriv_completedZeta c (y - 1) (y + 1) hc).continuousAt
    (Filter.mem_of_superset hmem (by intro z hz; exact Set.Icc_subset_uIcc hz))


/-- **Finite-`T` Fubini swap for the Paley–Wiener right-vertical integral.** -/
theorem integral_logDeriv_paleyWiener_swap (g : ℝ → ℂ) (hg : Continuous g) (T : ℝ) :
    (∫ y : ℝ in (-T)..T, logDeriv completedZeta ((2 : ℝ) + y * I)
        * paleyWiener g ((2 : ℝ) + y * I))
      = ∫ u : ℝ in (-1)..1,
          g u * Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))
            * (∫ y : ℝ in (-T)..T,
                logDeriv completedZeta ((2 : ℝ) + y * I)
                  * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))) := by
  have hZline := continuous_logDeriv_completedZeta_line 2 (by norm_num)
  have hFcont : Continuous (Function.uncurry
      (fun (y : ℝ) (u : ℝ) => logDeriv completedZeta ((2 : ℝ) + y * I)
        * (g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ))))) := by
    apply Continuous.mul
    · exact hZline.comp continuous_fst
    · exact (hg.comp continuous_snd).mul
        (Complex.continuous_exp.comp (by continuity))
  have hint : IntegrableOn (Function.uncurry
      (fun (y : ℝ) (u : ℝ) => logDeriv completedZeta ((2 : ℝ) + y * I)
        * (g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ)))))
      (Set.uIoc (-T) T ×ˢ Set.uIoc (-1) 1) := by
    have hK : IntegrableOn (Function.uncurry
        (fun (y : ℝ) (u : ℝ) => logDeriv completedZeta ((2 : ℝ) + y * I)
          * (g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ)))))
        (Set.uIcc (-T) T ×ˢ Set.uIcc (-1) 1) :=
      hFcont.continuousOn.integrableOn_compact (isCompact_uIcc.prod isCompact_uIcc)
    exact hK.mono_set (by
      intro p hp
      exact ⟨Set.uIoc_subset_uIcc hp.1, Set.uIoc_subset_uIcc hp.2⟩)
  have hswap := intervalIntegral_intervalIntegral_swap (F := fun (y : ℝ) (u : ℝ) =>
      logDeriv completedZeta ((2 : ℝ) + y * I)
        * (g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ))))
    (a := -T) (b := T) (c := -1) (d := 1) hint
  have hstep1 : (∫ y : ℝ in (-T)..T, logDeriv completedZeta ((2 : ℝ) + y * I)
        * ∫ u : ℝ in (-1)..1,
            g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ)))
      = ∫ y : ℝ in (-T)..T, ∫ u : ℝ in (-1)..1,
          logDeriv completedZeta ((2 : ℝ) + y * I)
            * (g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ))) := by
    apply intervalIntegral.integral_congr
    intro y hy
    beta_reduce
    rw [intervalIntegral.integral_const_mul]
  unfold paleyWiener
  rw [hstep1, hswap]
  apply intervalIntegral.integral_congr
  intro u hu
  beta_reduce
  rw [show (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((2 : ℝ) + y * I)
          * (g u * Complex.exp (Complex.I * (((2 : ℝ) + y * I) - 1 / 2) * (u : ℂ))))
      = ∫ y : ℝ in (-T)..T,
          (g u * Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ)))
            * (logDeriv completedZeta ((2 : ℝ) + y * I)
              * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))) from by
    apply intervalIntegral.integral_congr
    intro y hy
    beta_reduce
    rw [paleyWiener_kernel_split u y]
    ring]
  rw [intervalIntegral.integral_const_mul]


/-- **Termwise prime side against a real exponential kernel** `e^{−uy}`. -/
theorem integral_lseries_vonMangoldt_exp (c u y₁ y₂ : ℝ) (hc : 1 < c) :
    (∫ y : ℝ in y₁..y₂,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
          * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)))
      = ∑' n : ℕ, ∫ y : ℝ in y₁..y₂,
          LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I) n
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)) := by
  exact integral_lseries_vonMangoldt_mul
    (fun y : ℝ => Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))) c y₁ y₂ hc
    (Complex.continuous_exp.comp (by continuity))


/-- **Vertical powers as exponentials**: for `n ≥ 2`,
`n^{-(c+iy)} = n^{-c}·e^{−iy log n}`. -/
theorem natCast_cpow_vertical_eq_exp {n : ℕ} (hn : 2 ≤ n) (c y : ℝ) :
    ((n : ℝ) : ℂ) ^ (-(c + (y : ℂ) * I) : ℂ)
      = ((n : ℝ) : ℂ) ^ (-(c : ℂ))
        * Complex.exp (-(Complex.I * (Real.log n : ℂ) * (y : ℂ))) := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hnne : (n : ℝ) ≠ 1 := by
    have : (1 : ℝ) < n := by exact_mod_cast (show 1 < n by omega)
    linarith
  have hn0 : ((n : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hnpos.ne'
  rw [Complex.cpow_def_of_ne_zero hn0, Complex.cpow_def_of_ne_zero hn0]
  rw [← Complex.ofReal_log hnpos.le]
  rw [← Complex.exp_add]
  congr 1
  push_cast
  ring


end AbsoluteHodgeExplicitFormula
