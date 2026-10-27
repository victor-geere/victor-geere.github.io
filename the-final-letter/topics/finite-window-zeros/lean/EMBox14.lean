import EMCritical
import BoxNorm
import Krawczyk

/-!
# A rational box for `ζ(1/2 + 14i)`

Step 3 of the handoff.  `zetaEMGen 1 N s` is enclosed in a fold of `CpowBox`
atoms, and the Euler–Maclaurin tail is added as a ball via the certified
remainder bound `norm_zetaEMRemainder_le_of_re_pos` (T305).

The parameters are **not** those of `Cert.lean`, which are admissible only at
height 5 (see `python/emit_em.py` and the calibration table in `HANDOFF.md`):

* the `[-1,1]` side condition forces `kI >= |Im s| log b = 14 log 21 ~ 43`, so
  `kI = 64` rather than 32;
* `expIBox` forms `exp(i t/kI)^kI` by sequential interval multiplication, so the
  width is amplified by roughly `2^(kI/2)`; the Taylor order must be 20, not 12
  (at `n = 12` the corner norm came out as `50.5`).

Chosen: `(N_log, k, kI, n) = (14, 16, 64, 20)`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-! ## Point boxes -/

/-- The degenerate box containing the single point `q + r i`. -/
def ptBox (q r : ℚ) : Cx := ⟨⟨q, q⟩, ⟨r, r⟩⟩

theorem mem_ptBox {q r : ℚ} {z : ℂ} (hq : z.re = (q : ℝ)) (hr : z.im = (r : ℝ)) :
    (ptBox q r).mem z := by
  simp only [Cx.mem, Iv.memR, ptBox]
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩⟩ <;> simp [hq, hr]

/-- The point box at `s - 1`, for the pole term `(N+1)^(1-s)/(s-1)`. -/
def S2box : Cx := ptBox (-1 / 2) 14

/-- The point box at `s + 3`, for the `B₄` boundary term. -/
def S17box : Cx := ptBox (1 / 2) 17

/-- At a point box the pole factor is exactly Gaussian rational:
`1/(s-1) = (-2 - 56i)/785` because `|s-1|² = 785/4`. -/
theorem inv_s14_sub_one :
    (1 : ℂ) / (s14 - 1) = ((-2 / 785 : ℝ) : ℂ) + ((-56 / 785 : ℝ) : ℂ) * Complex.I := by
  have hne : s14 - 1 ≠ 0 := by
    intro h
    have him := congrArg Complex.im h
    simp [s14, Complex.sub_im, Complex.one_im] at him
  rw [div_eq_iff hne]
  apply Complex.ext <;>
    simp [s14, Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
      Complex.sub_re, Complex.sub_im, Complex.one_re, Complex.one_im,
      Complex.I_re, Complex.I_im] <;>
    norm_num

theorem mem_S2box : Cx.mem (s14 - 1) S2box := by
  apply mem_ptBox
  · simp [s14, Complex.sub_re, Complex.add_re, Complex.I_re]
    norm_num
  · simp [s14, Complex.sub_im, Complex.add_im, Complex.I_im]

/-! ## The base sum `Σ_{n=1}^{20} n^{-s}` -/

/-- The folded box for `Σ_{n<M} (n+1)^{-s}`. -/
def csPow : ℕ → Cx
  | 0 => ⟨⟨0, 0⟩, ⟨0, 0⟩⟩
  | (M + 1) => (csPow M).add (cpowBox 20 16 48 24 (M + 1) S14)

/-- **Fold soundness** for the base sum. -/
theorem csPow_mem (M : ℕ)
    (h : ∀ n, n < M → CpowConditions 20 16 48 24 (n + 1) S14) :
    (csPow M).mem (∑ n ∈ Finset.range M, ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14))) := by
  induction M with
  | zero => simp [csPow, Cx.mem, Iv.memR]
  | succ M ih =>
      rw [csPow, Finset.sum_range_succ]
      apply Cx.mem_add
      · exact ih (fun n hn => h n (by omega))
      · obtain ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩ := h M (by omega)
        exact cpowBox_mem hb mem_S14 hk hkI hn he1 he2 hI1 hI2

/-- Boolean check of the base-sum side conditions. -/
def sumOK (M : ℕ) : Bool := (List.range M).all (fun n => CpowOK 20 16 48 24 (n + 1) S14)

theorem sumOK_conditions {M : ℕ} (h : sumOK M = true) :
    ∀ n, n < M → CpowConditions 20 16 48 24 (n + 1) S14 := fun n hn =>
  CpowConditions_of_OK (List.all_eq_true.mp h n (List.mem_range.mpr hn))

/-! ## The full box -/

/-- The enclosure of `zetaEMGen 1 20 s14`, using a **single** `21^{-s}` atom.

Every `(N+1)`-term is a rational multiple of `21^{-s}`:
`21^{1-s}/(s-1) = 21^{-s}·(21/(s-1))` and `(1/12)s·21^{-(s+1)} = 21^{-s}·(s/252)`,
so the scalar collapses to `1/2 + s/252 + 21/(s-1)`, whose value at `s0` is
`177437/395640 - (20383/14130)i`.  This keeps every atom at `Im = 14`: the
separate `Im = 15` and `Im = 17` atoms were the wide ones (round-5 diagnosis). -/
def Bzeta : Cx :=
  (csPow 20).add
    ((cpowBox 20 16 48 24 21 S14).mul (ptBox (177437 / 395640) (-20383 / 14130)))

/-! ## Evaluation of the certificate -/

example : sumOK 20 = true := by native_decide

example : CpowOK 20 16 48 24 21 S14 = true := by native_decide

/-- **The corner test** (T308): the folded box has corner norm at most `11/100`. -/
theorem corner_Bzeta :
    (maxAbsIv Bzeta.re) ^ 2 + (maxAbsIv Bzeta.im) ^ 2 ≤ ((11 / 100 : ℚ)) ^ 2 := by
  native_decide


/-! ## The tail bounds -/

theorem norm_s14_le : ‖s14‖ ≤ (14.5 : ℝ) := by
  have h := Complex.norm_le_abs_re_add_abs_im s14
  have h2 : ‖s14‖ ≤ 2⁻¹ + 14 := by
    simpa [s14, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.I_re, Complex.I_im] using h
  linarith

theorem norm_s14_add_one_le : ‖s14 + 1‖ ≤ (15.5 : ℝ) := by
  have h := Complex.norm_le_abs_re_add_abs_im (s14 + 1)
  have h2 : ‖s14 + 1‖ ≤ |2⁻¹ + 1| + 14 := by
    simpa [s14, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.I_re, Complex.I_im] using h
  have h3 : |(2⁻¹ : ℝ) + 1| = 2⁻¹ + 1 := abs_of_pos (by norm_num)
  rw [h3] at h2
  linarith

theorem norm_s14_add_two_le : ‖s14 + 2‖ ≤ (16.5 : ℝ) := by
  have h := Complex.norm_le_abs_re_add_abs_im (s14 + 2)
  have h2 : ‖s14 + 2‖ ≤ |2⁻¹ + 2| + 14 := by
    simpa [s14, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.I_re, Complex.I_im] using h
  have h3 : |(2⁻¹ : ℝ) + 2| = 2⁻¹ + 2 := abs_of_pos (by norm_num)
  rw [h3] at h2
  linarith

theorem norm_s14_add_three_le : ‖s14 + 3‖ ≤ (17.5 : ℝ) := by
  have h := Complex.norm_le_abs_re_add_abs_im (s14 + 3)
  have h2 : ‖s14 + 3‖ ≤ |2⁻¹ + 3| + 14 := by
    simpa [s14, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.I_re, Complex.I_im] using h
  have h3 : |(2⁻¹ : ℝ) + 3| = 2⁻¹ + 3 := abs_of_pos (by norm_num)
  rw [h3] at h2
  linarith

theorem norm_descPochhammer_three_le :
    ‖(descPochhammer ℂ 3).eval (-s14)‖ ≤ (4320 : ℝ) := by
  have h3 : (descPochhammer ℂ 3).eval (-s14) = (-s14) * (-s14 - 1) * (-s14 - 2) := by
    simp [descPochhammer]
    ring
  rw [h3, norm_mul, norm_mul]
  have hA : ‖-s14‖ = ‖s14‖ := norm_neg s14
  have hB : ‖-s14 - 1‖ = ‖s14 + 1‖ := by rw [show -s14 - 1 = -(s14 + 1) by ring, norm_neg]
  have hC : ‖-s14 - 2‖ = ‖s14 + 2‖ := by rw [show -s14 - 2 = -(s14 + 2) by ring, norm_neg]
  rw [hA, hB, hC]
  have p1 := norm_s14_le
  have p2 := norm_s14_add_one_le
  have p3 := norm_s14_add_two_le
  have m1 : ‖s14‖ * ‖s14 + 1‖ ≤ 14.5 * 15.5 :=
    mul_le_mul p1 p2 (norm_nonneg _) (by norm_num)
  have m2 : ‖s14‖ * ‖s14 + 1‖ * ‖s14 + 2‖ ≤ 14.5 * 15.5 * 16.5 :=
    mul_le_mul m1 p3 (norm_nonneg _) (by norm_num)
  exact m2.trans (by norm_num)

theorem norm_descPochhammer_four_le :
    ‖(descPochhammer ℂ 4).eval (-s14)‖ ≤ (65000 : ℝ) := by
  have h4 : (descPochhammer ℂ 4).eval (-s14) =
      (-s14) * (-s14 - 1) * (-s14 - 2) * (-s14 - 3) := by
    simp [descPochhammer]
    ring
  rw [h4, norm_mul, norm_mul, norm_mul]
  have hA : ‖-s14‖ = ‖s14‖ := norm_neg s14
  have hB : ‖-s14 - 1‖ = ‖s14 + 1‖ := by rw [show -s14 - 1 = -(s14 + 1) by ring, norm_neg]
  have hC : ‖-s14 - 2‖ = ‖s14 + 2‖ := by rw [show -s14 - 2 = -(s14 + 2) by ring, norm_neg]
  have hD : ‖-s14 - 3‖ = ‖s14 + 3‖ := by rw [show -s14 - 3 = -(s14 + 3) by ring, norm_neg]
  rw [hA, hB, hC, hD]
  have p1 := norm_s14_le
  have p2 := norm_s14_add_one_le
  have p3 := norm_s14_add_two_le
  have p4 := norm_s14_add_three_le
  have m1 : ‖s14‖ * ‖s14 + 1‖ ≤ 14.5 * 15.5 :=
    mul_le_mul p1 p2 (norm_nonneg _) (by norm_num)
  have m2 : ‖s14‖ * ‖s14 + 1‖ * ‖s14 + 2‖ ≤ 14.5 * 15.5 * 16.5 :=
    mul_le_mul m1 p3 (norm_nonneg _) (by norm_num)
  have m3 : ‖s14‖ * ‖s14 + 1‖ * ‖s14 + 2‖ * ‖s14 + 3‖ ≤ 14.5 * 15.5 * 16.5 * 17.5 :=
    mul_le_mul m2 p4 (norm_nonneg _) (by norm_num)
  exact m3.trans (by norm_num)

/-! ## The `B₄` boundary term -/

theorem emConst_four : 2 * (riemannZeta (4 : ℂ)).re / (2 * Real.pi) ^ 4 = (1 / 720 : ℝ) := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have h4 : (riemannZeta (4 : ℂ)).re = Real.pi ^ 4 / 90 := by
    rw [riemannZeta_four]
    have h : ((Real.pi : ℂ) ^ 4 / 90) = ((Real.pi ^ 4 / 90 : ℝ) : ℂ) := by
      push_cast
      ring
    rw [h, Complex.ofReal_re]
  rw [h4]
  field_simp
  ring

theorem pow21_neg_four : (21 : ℝ) ^ (-(4 : ℝ)) = 1 / 194481 := by
  rw [show (-(4 : ℝ)) = ((-4 : ℤ) : ℝ) by norm_num, Real.rpow_intCast]
  norm_num

theorem pow21_neg_three : (21 : ℝ) ^ (-(3 : ℝ)) = 1 / 9261 := by
  rw [show (-(3 : ℝ)) = ((-3 : ℤ) : ℝ) by norm_num, Real.rpow_intCast]
  norm_num

/-- **T306: the `K = 2` Euler–Maclaurin remainder at `1/2+14i`.** -/
theorem norm_remainder_two_le : ‖zetaEMRemainder 2 20 s14‖ ≤ (1 / 250 : ℝ) := by
  have hre : s14.re = (1 / 2 : ℝ) := by norm_num [s14]
  have h := norm_zetaEMRemainder_le_of_re_pos 2 20 (by norm_num) s14 (by rw [hre]; norm_num)
  have key : ‖zetaEMRemainder 2 20 s14‖ ≤
      (2 * (riemannZeta (4 : ℂ)).re / (2 * Real.pi) ^ 4) *
        ‖(descPochhammer ℂ 4).eval (-s14)‖ *
        ((21 : ℝ) ^ (-(1 / 2 : ℝ) - 4) + (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) / (7 / 2)) := by
    convert h using 2 <;> norm_num [s14]
  have hc := emConst_four
  have hA : (21 : ℝ) ^ (-(1 / 2 : ℝ) - 4) ≤ (21 : ℝ) ^ (-(4 : ℝ)) := by
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
    norm_num
  have hB : (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) / (7 / 2) ≤ (21 : ℝ) ^ (-(3 : ℝ)) / 3 := by
    have h1 : (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) ≤ (21 : ℝ) ^ (-(3 : ℝ)) := by
      apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
      norm_num
    have hp : (0 : ℝ) ≤ (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) := by positivity
    calc (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) / (7 / 2)
        = (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) * (2 / 7) := by ring
      _ ≤ (21 : ℝ) ^ (-(3 : ℝ)) * (1 / 3) := by
          apply mul_le_mul h1 (by norm_num) (by norm_num)
          positivity
      _ = (21 : ℝ) ^ (-(3 : ℝ)) / 3 := by ring
  have hP := norm_descPochhammer_four_le
  calc ‖zetaEMRemainder 2 20 s14‖
      ≤ (2 * (riemannZeta (4 : ℂ)).re / (2 * Real.pi) ^ 4) *
          ‖(descPochhammer ℂ 4).eval (-s14)‖ *
          ((21 : ℝ) ^ (-(1 / 2 : ℝ) - 4) + (21 : ℝ) ^ (1 - (1 / 2 : ℝ) - 4) / (7 / 2)) := key
    _ ≤ (1 / 720) * 65000 * ((21 : ℝ) ^ (-(4 : ℝ)) + (21 : ℝ) ^ (-(3 : ℝ)) / 3) := by
        rw [hc]
        exact mul_le_mul (mul_le_mul_of_nonneg_left hP (by norm_num)) (add_le_add hA hB)
          (by positivity) (by norm_num)
    _ = (1 / 720) * 65000 * (1 / 194481 + (1 / 9261) / 3) := by
        rw [pow21_neg_four, pow21_neg_three]
    _ ≤ (1 / 250 : ℝ) := by norm_num

/-- **T307: the `B₄` boundary term at `1/2+14i`.** -/
theorem norm_b4term_le :
    ‖(-(emCoef 2) : ℂ) * emGShift s14 20 3 0‖ ≤ (1 / 1000 : ℝ) := by
  rw [norm_mul]
  have he : ‖(-(emCoef 2) : ℂ)‖ = (1 / 720 : ℝ) := by
    rw [emCoef_two]
    norm_num
  rw [he]
  have hg : ‖emGShift s14 20 3 0‖ =
      ‖(descPochhammer ℂ 3).eval (-s14)‖ * ((0 + (20:ℝ) + 1) ^ (-s14.re - (3:ℝ))) :=
    norm_emGShift s14 20 3 (le_refl 0)
  rw [hg]
  have hre : s14.re = (1 / 2 : ℝ) := by norm_num [s14]
  rw [hre]
  have h21r : ((0 : ℝ) + 20 + 1) = 21 := by norm_num
  rw [h21r]
  have hpow : (21 : ℝ) ^ (-(1 / 2 : ℝ) - 3) ≤ (21 : ℝ) ^ (-(3 : ℝ)) := by
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
    norm_num
  have hP := norm_descPochhammer_three_le
  calc (1 / 720) * (‖(descPochhammer ℂ 3).eval (-s14)‖ * (21 : ℝ) ^ (-(1 / 2 : ℝ) - 3))
      ≤ (1 / 720) * (4320 * (21 : ℝ) ^ (-(3 : ℝ))) := by
        apply mul_le_mul_of_nonneg_left _ (by norm_num)
        exact mul_le_mul hP hpow (by positivity) (by norm_num)
    _ = (1 / 720) * (4320 * (1 / 9261)) := by rw [pow21_neg_three]
    _ ≤ (1 / 1000 : ℝ) := by norm_num

/-! ## The membership proof -/

/-- Expansion of `zetaEMGen 1 20 s14` into its four explicit pieces. -/
theorem zetaEMGen_one_expand :
    zetaEMGen 1 20 s14 =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ) : ℂ) ^ (-s14))))
        + (21 : ℂ) ^ (1 - s14) / (s14 - 1)
        + (21 : ℂ) ^ (-s14) / 2
        + (1 / 12 : ℂ) * s14 * (21 : ℂ) ^ (-(s14 + 1)) := by
  rw [zetaEMGen_one, zetaBase]
  simp only [emGShift, descPochhammer, Polynomial.eval_one, one_mul, Nat.cast_ofNat,
    mul_one, add_zero, sub_zero]
  norm_num

theorem cpow_21_one_sub : (21 : ℂ) ^ (1 - s14) = (21 : ℂ) ^ (-s14) * 21 := by
  rw [show (1 : ℂ) - s14 = -s14 + 1 by ring]
  rw [Complex.cpow_add]
  · rw [Complex.cpow_one]
  · norm_num

theorem cpow_21_neg_succ :
    (21 : ℂ) ^ (-(s14 + 1)) = (21 : ℂ) ^ (-s14) * (21 : ℂ)⁻¹ := by
  rw [show -(s14 + 1) = -s14 + (-1) by ring]
  rw [Complex.cpow_add]
  · rw [Complex.cpow_neg_one]
  · norm_num

/-- The rational scalar `1/2 + s/252 + 21/(s-1)` at `s14`. -/
theorem scalar_eq :
    (21 : ℂ) / (s14 - 1) + 1 / 2 + (1 / 12 : ℂ) * s14 * (21 : ℂ)⁻¹
      = ((177437 / 395640 : ℝ) : ℂ) + ((-20383 / 14130 : ℝ) : ℂ) * Complex.I := by
  have hdiv : (21 : ℂ) / (s14 - 1) =
      21 * (((-2 / 785 : ℝ) : ℂ) + ((-56 / 785 : ℝ) : ℂ) * Complex.I) := by
    rw [show (21 : ℂ) / (s14 - 1) = 21 * (1 / (s14 - 1)) by ring, inv_s14_sub_one]
  have h21i : (21 : ℂ)⁻¹ = ((1 / 21 : ℝ) : ℂ) := by norm_num
  rw [hdiv, h21i]
  have hs64 : (s14 : ℂ) = ((1 / 2 : ℝ) : ℂ) + ((14 : ℝ) : ℂ) * Complex.I := by
    simp [s14]
  rw [hs64]
  apply Complex.ext <;>
    simp [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im,
      Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
      Complex.inv_re, Complex.inv_im, Complex.one_re, Complex.one_im,
      Complex.I_re, Complex.I_im, Complex.ofReal_re, Complex.ofReal_im] <;>
    norm_num

/-- The three `(N+1)`-terms collapse to `21^{-s14}` times the rational scalar. -/
theorem three_terms_eq :
    (21 : ℂ) ^ (1 - s14) / (s14 - 1) + (21 : ℂ) ^ (-s14) / 2
        + (1 / 12 : ℂ) * s14 * (21 : ℂ) ^ (-(s14 + 1))
      = (21 : ℂ) ^ (-s14) *
        (((177437 / 395640 : ℝ) : ℂ) + ((-20383 / 14130 : ℝ) : ℂ) * Complex.I) := by
  have h1 : (21 : ℂ) ^ (1 - s14) / (s14 - 1) = (21 : ℂ) ^ (-s14) * ((21 : ℂ) / (s14 - 1)) := by
    rw [cpow_21_one_sub]; ring
  have h2 : (21 : ℂ) ^ (-s14) / 2 = (21 : ℂ) ^ (-s14) * (1 / 2) := by ring
  have h3 : (1 / 12 : ℂ) * s14 * (21 : ℂ) ^ (-(s14 + 1)) =
      (21 : ℂ) ^ (-s14) * ((1 / 12 : ℂ) * s14 * (21 : ℂ)⁻¹) := by
    rw [cpow_21_neg_succ]; ring
  rw [h1, h2, h3, ← mul_add, ← mul_add, scalar_eq]

/-- **Membership**: `zetaEMGen 1 20 s14` lies in the folded box `Bzeta`. -/
theorem mem_Bzeta : Cx.mem (zetaEMGen 1 20 s14) Bzeta := by
  have hbridge : (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ) : ℂ) ^ (-s14)))) =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14))) := by
    apply Finset.sum_congr rfl
    intro n _
    congr 1
    push_cast
    ring
  have hsum : (csPow 20).mem (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ) : ℂ) ^ (-s14)))) := by
    rw [hbridge]
    exact csPow_mem 20 (sumOK_conditions (by native_decide : sumOK 20 = true))
  have hthree : Cx.mem ((21 : ℂ) ^ (1 - s14) / (s14 - 1) + (21 : ℂ) ^ (-s14) / 2
      + (1 / 12 : ℂ) * s14 * (21 : ℂ) ^ (-(s14 + 1)))
      ((cpowBox 20 16 48 24 21 S14).mul (ptBox (177437 / 395640) (-20383 / 14130))) := by
    rw [three_terms_eq]
    apply Cx.mem_mul
    · obtain ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩ :=
        CpowConditions_of_OK (by native_decide : CpowOK 20 16 48 24 21 S14 = true)
      exact cpowBox_mem hb mem_S14 hk hkI hn he1 he2 hI1 hI2
    · exact mem_ptBox (by simp) (by simp)
  rw [zetaEMGen_one_expand, Bzeta]
  convert Cx.mem_add hsum hthree using 1 <;> ring

/-- **Step 3, sharp form: `‖ζ(1/2+14i)‖ ≤ 23/200 = 0.115`.** -/
theorem zeta_norm_le_115 : ‖riemannZeta s14‖ ≤ (23 / 200 : ℝ) := by
  have hre : 0 < s14.re := by norm_num [s14]
  have him1 : 1 < s14.im := by norm_num [s14]
  have him2 : s14.im < 20 := by norm_num [s14]
  have hζ : riemannZeta s14 = zetaEM 20 s14 := zeta_eq_zetaEM_of_im 20 hre him1 him2
  have hsplit : zetaEM 20 s14 = zetaEMGen 2 20 s14 + zetaEMRemainder 2 20 s14 := by
    rw [zetaEMRemainder]; ring
  have hgen2 : zetaEMGen 2 20 s14 =
      zetaEMGen 1 20 s14 + (-(emCoef 2) : ℂ) * emGShift s14 20 3 0 := by
    rw [zetaEMGen_succ 1 20 s14]
  have hnorm : ‖zetaEMGen 1 20 s14‖ ≤ (11 / 100 : ℝ) := by
    apply norm_le_of_mem_box mem_Bzeta (by norm_num)
    have hc := corner_Bzeta
    have hcast : ((maxAbsIv Bzeta.re) ^ 2 + (maxAbsIv Bzeta.im) ^ 2 : ℝ) ≤
        (((11 / 100 : ℚ) : ℝ)) ^ 2 := by exact_mod_cast hc
    simpa using hcast
  calc ‖riemannZeta s14‖ = ‖zetaEM 20 s14‖ := by rw [hζ]
    _ = ‖zetaEMGen 2 20 s14 + zetaEMRemainder 2 20 s14‖ := by rw [hsplit]
    _ ≤ ‖zetaEMGen 2 20 s14‖ + ‖zetaEMRemainder 2 20 s14‖ := norm_add_le _ _
    _ = ‖zetaEMGen 1 20 s14 + (-(emCoef 2) : ℂ) * emGShift s14 20 3 0‖
          + ‖zetaEMRemainder 2 20 s14‖ := by rw [hgen2]
    _ ≤ (11 / 100 + 1 / 1000) + 1 / 250 := by
        have h1 := norm_add_le (zetaEMGen 1 20 s14) ((-(emCoef 2) : ℂ) * emGShift s14 20 3 0)
        linarith [hnorm, norm_b4term_le, norm_remainder_two_le]
    _ ≤ (23 / 200 : ℝ) := by norm_num

/-- **Step 3: `‖ζ(1/2+14i)‖ ≤ 1/8`.** -/
theorem zeta_norm_le_eighth : ‖riemannZeta s14‖ ≤ (1 / 8 : ℝ) :=
  zeta_norm_le_115.trans (by norm_num)

/-- **The Krawczyk map condition for `Yk` at `1/2+14i`** (step 3 payoff):
`‖Yk·ζ(s0)‖ + (1/4)·(1/4) ≤ 1/4`. -/
theorem hmap_zeta :
    ‖Yk * riemannZeta s14‖ + (1/4 : ℝ) * (1/4 : ℝ) ≤ (1/4 : ℝ) :=
  hmap_of_zeta_bound zeta_norm_le_eighth

/-! ## The `r = 1/5` Krawczyk data -/

/-- `‖Yk‖ ≤ 1.29` (the 10-digit rational is accurate to `3·10⁻⁵`). -/
theorem norm_Yk_le : ‖Yk‖ ≤ (1.29 : ℝ) := by
  have hsq : Complex.normSq Yk ≤ ((1.29 : ℝ) ^ 2) := by
    rw [Yk]
    norm_num [Complex.normSq_apply, Complex.add_re, Complex.add_im,
      Complex.mul_re, Complex.mul_im]
  calc ‖Yk‖ = Real.sqrt (Complex.normSq Yk) := by
        rw [← Real.sqrt_sq (norm_nonneg _), Complex.normSq_eq_norm_sq]
    _ ≤ Real.sqrt ((1.29 : ℝ) ^ 2) := Real.sqrt_le_sqrt hsq
    _ = (1.29 : ℝ) := by rw [Real.sqrt_sq (by norm_num)]

/-- **The map condition at radius `1/5`.**  `‖Yk·ζ(s0)‖ + (1/4)·(1/5) ≤ 1/5`,
using the sharp `‖ζ(s0)‖ ≤ 23/200`.  A zero in the `1/5`-ball is *stronger* than
one in the `1/4`-ball, so this is not a weakening of the target. -/
theorem hmap_zeta_fifth :
    ‖Yk * riemannZeta s14‖ + (1/4 : ℝ) * (1/5 : ℝ) ≤ (1/5 : ℝ) := by
  have hmul : ‖Yk * riemannZeta s14‖ ≤ (1.29 : ℝ) * (23 / 200 : ℝ) := by
    rw [norm_mul]
    exact mul_le_mul norm_Yk_le zeta_norm_le_115 (norm_nonneg _) (by norm_num)
  linarith

/-- The `1/5`-ball around `1/2+14i` avoids `1`. -/
theorem fifth_ball_ne_one : ∀ z ∈ Metric.closedBall s14 (1/5), z ≠ 1 := by
  intro z hz hz1
  subst hz1
  rw [Metric.mem_closedBall, dist_eq_norm] at hz
  have him := Complex.abs_im_le_norm ((1 : ℂ) - s14)
  have hval : ((1 : ℂ) - s14).im = -14 := by norm_num [s14]
  rw [hval] at him
  rw [show ((1 : ℂ) - s14) = -((s14) - 1) by ring, norm_neg] at him
  have hnorm : ‖s14 - 1‖ ≤ (1/5 : ℝ) := by rw [norm_sub_rev]; exact hz
  norm_num at him
  linarith

/-- **The Krawczyk target at radius `1/5`.**  The *only* remaining hypothesis is
the derivative enclosure `hC`; the map condition is `hmap_zeta_fifth` (proved)
and the ball avoids `1` (`fifth_ball_ne_one`, proved). -/
theorem zeta_zero_fifth_ball {Y : ℂ} (hY : Y ≠ 0)
    (hC : ∀ z ∈ Metric.closedBall s14 (1/5), ‖1 - Y * deriv riemannZeta z‖ ≤ (1/4 : ℝ))
    (hmap : ‖Y * riemannZeta s14‖ + (1/4 : ℝ) * (1/5 : ℝ) ≤ (1/5 : ℝ)) :
    ∃ z ∈ Metric.closedBall s14 (1/5), riemannZeta z = 0 :=
  FiniteWindowZeros.zeta_zero_of_krawczyk (x0 := s14) (r := 1/5) (q := 1/4)
    (by norm_num) (by norm_num) (by norm_num) hY fifth_ball_ne_one hC hmap

/-- `Yk ≠ 0`: its real part is `1.24`, so the modulus is at least `1`. -/
theorem Yk_ne_zero : Yk ≠ 0 := by
  intro h
  have h0 : Complex.normSq Yk = 0 := by rw [h]; simp
  rw [Yk] at h0
  norm_num [Complex.normSq_apply, Complex.add_re, Complex.add_im,
    Complex.mul_re, Complex.mul_im] at h0

/-- **`hC` from two numerical inputs.**  If `ζ′` is pinned at `s14` to `10⁻³`
and is `47/250`-Lipschitz on the `1/5`-ball, then the Krawczyk derivative
condition holds:

`‖1 - Yk ζ′(z)‖ ≤ 10⁻³ + 1.29·(47/250) = 0.24352 ≤ 1/4`.

The true Lipschitz constant is `0.1517`, so the second hypothesis has 24%
slack. -/
theorem hC_of_bounds
    (h1 : ‖1 - Yk * deriv riemannZeta s14‖ ≤ (1 / 1000 : ℝ))
    (h2 : ∀ z ∈ Metric.closedBall s14 (1/5),
      ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ (47 / 250 : ℝ)) :
    ∀ z ∈ Metric.closedBall s14 (1/5), ‖1 - Yk * deriv riemannZeta z‖ ≤ (1/4 : ℝ) := by
  intro z hz
  have hvar := h2 z hz
  have hY := norm_Yk_le
  calc ‖1 - Yk * deriv riemannZeta z‖
      = ‖(1 - Yk * deriv riemannZeta s14)
          - Yk * (deriv riemannZeta z - deriv riemannZeta s14)‖ := by
        congr 1
        ring
    _ ≤ ‖1 - Yk * deriv riemannZeta s14‖
          + ‖Yk * (deriv riemannZeta z - deriv riemannZeta s14)‖ := norm_sub_le _ _
    _ ≤ (1 / 1000 : ℝ) + 1.29 * (47 / 250 : ℝ) := by
        have hm : ‖Yk * (deriv riemannZeta z - deriv riemannZeta s14)‖ ≤
            1.29 * (47 / 250 : ℝ) := by
          rw [norm_mul]
          exact mul_le_mul hY hvar (norm_nonneg _) (by norm_num)
        linarith
    _ ≤ (1 / 4 : ℝ) := by norm_num

/-- **A certified zero at `1/2 + 14i`, conditional on two explicit numerical
inputs.**  These are the only remaining obligations:

1. `‖1 - Yk·ζ′(1/2+14i)‖ ≤ 10⁻³` — a *point* enclosure of `ζ′`;
2. `ζ′` is `47/250`-Lipschitz on the `1/5`-ball — true constant `0.1517`.

No RH, twin-prime, Chowla or infinite Weil-positivity claim is made. -/
theorem zeta_zero_14_of_bounds
    (h1 : ‖1 - Yk * deriv riemannZeta s14‖ ≤ (1 / 1000 : ℝ))
    (h2 : ∀ z ∈ Metric.closedBall s14 (1/5),
      ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ (47 / 250 : ℝ)) :
    ∃ z ∈ Metric.closedBall s14 (1/5), riemannZeta z = 0 :=
  zeta_zero_fifth_ball (Y := Yk) Yk_ne_zero (hC_of_bounds h1 h2) hmap_zeta_fifth

end FiniteWindowZeros
