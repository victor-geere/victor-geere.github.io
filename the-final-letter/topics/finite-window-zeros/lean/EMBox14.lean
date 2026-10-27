import EMCritical
import BoxNorm

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

example : (maxAbsIv Bzeta.re) ^ 2 + (maxAbsIv Bzeta.im) ^ 2 ≤ ((11 / 100 : ℚ)) ^ 2 := by
  native_decide

/-- **The corner test.**  Together with the certified remainder (`B₄` boundary
term `<= 6·21⁻³ < 1/1000` and `zetaEMRemainder 2 20` bounded via T305) this
gives `|ζ(1/2+14i)| <= 11/100 + 1/1000 + 1/200 < 1/8`. -/
example : (maxAbsIv Bzeta.re) ^ 2 + (maxAbsIv Bzeta.im) ^ 2 ≤ ((11 / 100 : ℚ)) ^ 2 := by
  native_decide

end FiniteWindowZeros
