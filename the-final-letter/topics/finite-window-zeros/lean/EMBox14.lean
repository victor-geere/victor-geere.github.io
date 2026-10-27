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
  | (M + 1) => (csPow M).add (cpowBox 14 16 64 20 (M + 1) S14)

/-- **Fold soundness** for the base sum. -/
theorem csPow_mem (M : ℕ)
    (h : ∀ n, n < M → CpowConditions 14 16 64 20 (n + 1) S14) :
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
def sumOK (M : ℕ) : Bool := (List.range M).all (fun n => CpowOK 14 16 64 20 (n + 1) S14)

theorem sumOK_conditions {M : ℕ} (h : sumOK M = true) :
    ∀ n, n < M → CpowConditions 14 16 64 20 (n + 1) S14 := fun n hn =>
  CpowConditions_of_OK (List.all_eq_true.mp h n (List.mem_range.mpr hn))

/-! ## The full box -/

/-- The enclosure of `zetaEMGen 1 20 s14` plus the `B₄` boundary ball.

* `csPow 20` — `Σ_{n=1}^{20} n^{-s}`;
* `cpowBox 21 S14 · 1/2` — the `(N+1)^{-s}/2` half-step;
* `cpowBox 21 S2box · 1/(s-1)` — the pole term;
* `cpowBox 21 S17box · ball 6` — the `B₄` boundary term, `|P₃/720| <= 6`. -/
def Bzeta : Cx :=
  ((csPow 20).add ((cpowBox 14 16 64 20 21 S14).mul (ptBox (1 / 2) 0))).add
    (((cpowBox 14 16 64 20 21 S2box).mul (ptBox (-2 / 785) (-56 / 785))).add
      ((cpowBox 14 16 64 20 21 S17box).mul (ball 6)))

/-! ## Evaluation of the certificate

These are the `native_decide` steps.  Together they say that all twenty-three
atoms satisfy the `CpowBox` side conditions and that the folded box has corner
norm at most `3/25 = 0.12`, leaving `1/8 - 3/25 = 1/200` for the certified
Euler–Maclaurin remainder. -/

example : sumOK 20 = true := by native_decide

example : CpowOK 14 16 64 20 21 S14 = true := by native_decide

example : CpowOK 14 16 64 20 21 S2box = true := by native_decide

example : CpowOK 14 16 64 20 21 S17box = true := by native_decide

/-! ## Open: the corner test does not yet hold

`native_decide` *does* evaluate the box (the three checks above pass), but

```
(maxAbsIv Bzeta.re) ^ 2 + (maxAbsIv Bzeta.im) ^ 2 <= (1/2)^2
```

comes out **false**, and so does every radius up to `1`; radius `3` passes.
The exact rational mirror `python/emit_em.py` predicts a corner of `0.10570`
for the same atoms and the same parameters, so the two differ by a factor of
ten somewhere.

The likely suspects, in order:

1. `expIvGeneral`/`expIBox` in `PST/Transcend.lean` and `PST/CpowBox.lean` may
   not match the mirror's `exp_iv_general`/`exp_i_box` (the mirror's `exp_rem`
   is `(n+1)/(n!·n)`; check the Lean definition).
2. `logIvRat 14 21` may differ from the mirror's `log_iv_rat`.
3. `Iv.mul`'s `min4`/`max4` corner selection, if either mirror mis-models it.

**Localised (round 5).**  Bisecting the four components separately at radius
`1/2`: `csPow 20`, `cpowBox 21 S14 · 1/2` and `cpowBox 21 S2box · 1/(s-1)` all
pass, but `cpowBox 21 S17box · ball 6` **fails**.  So the wide atom is the one
with `Im = 17`; the `Im = 14` atoms are fine.  The box width therefore grows
with `|Im|` much faster than the mirror predicts — consistent with the
`powNat kI` width amplification being worse in Lean than in
`emit_blocks.cx_pow`, which is where the mirror and Lean diverge.

**The fix does not need that atom at all.**  The `B₄` boundary term is
`P₃ · 21^(-(s0+3))` with `|P₃/720| <= 6` and `|21^(-(s0+3))| = 21^(-7/2)`, so
`|B₄ term| <= 6 · 21^(-3) < 1/1000`.  Replacing the atom by that rational bound
needs one `Real.rpow` inequality (`21^(-(7/2)) <= 21^(-3)`) and the norm bound
on `P₃`, and removes the wide atom entirely.

Until this is resolved the box cannot certify anything: a corner of `>1` is
compatible with `ζ(s0) ≠ 0` but not with `|ζ(s0)| <= 1/8`.  The infrastructure
above (`ptBox`, `mem_ptBox`, `inv_s14_sub_one`, `mem_S2box`, `csPow_mem`,
`sumOK_conditions`) is independent of the discrepancy and is reused as-is.
-/

end FiniteWindowZeros
