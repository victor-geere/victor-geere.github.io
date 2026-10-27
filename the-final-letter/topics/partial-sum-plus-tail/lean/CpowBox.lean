import Transcend

/-!
# Complex power atoms: a verified box for `b^{-s}`

`Transcend.lean` encloses `log`, `exp`, `cos` and `sin` on rational intervals.
This file combines them into a box for `b^{-s}`, with `b ≥ 1` rational and `s`
in a rational rectangle `S`.

The imaginary part is handled by `expIBox`: split `Im P` into `kI` equal parts,
Taylor-expand `exp (i t / kI)` with the remainder `expRem`, and raise the box to
the `kI`-th power.  This works for arbitrary `Im P`, without a `2π` reduction.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open scoped BigOperators

namespace PartialTail

/-- A scaled `log` enclosure for a natural base: write `b = (b/2^L)·2^L`
with `L = Nat.log2 b`, so the `logIv` series is evaluated near `1`. -/
def logIvRat (N : ℕ) (b : ℕ) : Iv :=
  let L := Nat.log2 b
  (logIv N ⟨(b : ℚ) / ((2 ^ L : ℕ) : ℚ), (b : ℚ) / ((2 ^ L : ℕ) : ℚ)⟩).add
    ((logIv N ⟨2, 2⟩).scale (L : ℚ))

theorem logIvRat_mem {N b : ℕ} (hb : 1 ≤ b) :
    (logIvRat N b).memR (Real.log (b : ℝ)) := by
  let L := Nat.log2 b
  have hb0 : b ≠ 0 := by omega
  have hpow : 2 ^ L ≤ b := by
    have h := Nat.pow_log_le_self 2 hb0
    simpa [L, Nat.log2_eq_log_two] using h
  have hpow0 : (0 : ℕ) < 2 ^ L := pow_pos (by norm_num) _
  have hq : (1 : ℚ) ≤ (b : ℚ) / ((2 ^ L : ℕ) : ℚ) := by
    rw [le_div_iff₀ (by exact_mod_cast hpow0)]
    have hp : ((2 ^ L : ℕ) : ℚ) ≤ (b : ℚ) := by exact_mod_cast hpow
    simpa using hp
  have hlog1 : (logIv N ⟨(b : ℚ) / ((2 ^ L : ℕ) : ℚ), (b : ℚ) / ((2 ^ L : ℕ) : ℚ)⟩).memR
      (Real.log ((b : ℝ) / (2 : ℝ) ^ L)) := by
    apply logIv_memR (N := N) (A := ⟨_, _⟩) hq
    simp [Iv.memR]
  have hlog2 : (logIv N ⟨2, 2⟩).memR (Real.log 2) :=
    logIv_memR (N := N) (A := ⟨2, 2⟩) (by norm_num) (by simp [Iv.memR])
  have hscale := Iv.memR_scale (q := (L : ℚ)) hlog2
  have hsum := Iv.memR_add hlog1 hscale
  have hlogeq : Real.log ((b : ℝ) / (2 : ℝ) ^ L) + ((L : ℚ) : ℝ) * Real.log 2 =
      Real.log (b : ℝ) := by
    have hbpos : (0 : ℝ) < (b : ℝ) := by positivity
    have h2pos : (0 : ℝ) < (2 : ℝ) ^ L := by positivity
    rw [Real.log_div hbpos.ne' h2pos.ne', Real.log_pow]
    push_cast
    ring
  rw [hlogeq] at hsum
  simpa [logIvRat] using hsum

/-- The exponent box `-s · log b` as a complex rectangle. -/
def cpowExponent (N : ℕ) (b : ℕ) (S : Cx) : Cx :=
  S.neg.mul ⟨logIvRat N b, ⟨0, 0⟩⟩

/-- A box for `exp (i t)` on `t ∈ A`, by splitting into `k` parts. -/
def expIBox (k n : ℕ) (A : Iv) : Cx :=
  ((expITaylor n (A.scale (1 / (k : ℚ)))).inflate (expRem n)).powNat k

/-- **Soundness of `expIBox`.**  If `t ∈ A` and `A/k ⊆ [-1,1]`, then
`exp (i t)` lies in the box. -/
theorem expIBox_mem {t : ℝ} {A : Iv} {k n : ℕ} (ht : A.memR t) (hk : 0 < k)
    (hlo : (-1 : ℚ) ≤ (A.scale (1 / (k : ℚ))).lo)
    (hhi : (A.scale (1 / (k : ℚ))).hi ≤ 1) (hn : 0 < n) :
    (expIBox k n A).mem (Complex.exp ((t : ℂ) * Complex.I)) := by
  have hkne : (k : ℂ) ≠ 0 := by exact_mod_cast (ne_of_gt hk)
  have ht' : (A.scale (1 / (k : ℚ))).memR (t * (1 / (k : ℝ))) := by
    have h := Iv.memR_scale (q := (1 / (k : ℚ))) ht
    convert h using 1 <;> push_cast <;> ring
  have hexp := expI_mem_inflate ht' hlo hhi hn
  have hpow := Cx.mem_powNat hexp k
  have harg : (k : ℂ) * (((t / k : ℝ) : ℂ) * Complex.I) = (t : ℂ) * Complex.I := by
    push_cast
    field_simp
  have ht'eq : t * (1 / (k : ℝ)) = t / k := by ring
  rw [ht'eq] at hpow
  rw [← Complex.exp_nat_mul, harg] at hpow
  simpa [expIBox] using hpow

/-- A verified box for `b^{-s}` on `s ∈ S`. -/
def cpowBox (N k kI n : ℕ) (b : ℕ) (S : Cx) : Cx :=
  let P : Cx := cpowExponent N b S
  let er : Iv := expIvGeneral k P.re
  let tr : Cx := expIBox kI n P.im
  ⟨er.mul tr.re, er.mul tr.im⟩

/-- **Soundness of `cpowBox`.**  If `b ≥ 1`, `s ∈ S`, and the side conditions
on the log/exp/trig enclosures hold, then `b^{-s}` lies in the box. -/
theorem cpowBox_mem {N k kI n : ℕ} {b : ℕ} (hb : 1 ≤ b)
    {S : Cx} {s : ℂ} (hs : Cx.mem s S) (hk : 0 < k) (hkI : 0 < kI) (hn : 0 < n)
    (hexplo : (-1 : ℚ) ≤ ((cpowExponent N b S).re.scale (1 / (k : ℚ))).lo)
    (hexphi : ((cpowExponent N b S).re.scale (1 / (k : ℚ))).hi ≤ 1)
    (hIlo : (-1 : ℚ) ≤ ((cpowExponent N b S).im.scale (1 / (kI : ℚ))).lo)
    (hIhi : ((cpowExponent N b S).im.scale (1 / (kI : ℚ))).hi ≤ 1) :
    Cx.mem (((b : ℝ) : ℂ) ^ (-s)) (cpowBox N k kI n b S) := by
  let L : Iv := logIvRat N b
  let P : Cx := cpowExponent N b S
  have hb0 : (0 : ℝ) < (b : ℝ) := lt_of_lt_of_le zero_lt_one (by exact_mod_cast hb)
  have hL : L.memR (Real.log (b : ℝ)) := logIvRat_mem hb
  have hP : Cx.mem ((-s) * ((Real.log (b : ℝ) : ℂ))) P := by
    have hneg : Cx.mem (-s) S.neg := Cx.mem_neg hs
    have hlogc : Cx.mem ((Real.log (b : ℝ) : ℂ)) (⟨L, ⟨0, 0⟩⟩ : Cx) := by
      refine ⟨hL, ?_⟩
      rw [Complex.ofReal_im]
      simp [Iv.memR]
    simpa [P, cpowExponent, L] using Cx.mem_mul hneg hlogc
  have hbne : ((b : ℝ) : ℂ) ≠ 0 := by
    exact_mod_cast (ne_of_gt hb0)
  rw [Complex.cpow_def_of_ne_zero hbne]
  rw [show Complex.log ((b : ℝ) : ℂ) * (-s) = (-s) * ((Real.log (b : ℝ) : ℂ)) by
    rw [Complex.ofReal_log (le_of_lt hb0)]
    ring]
  have hExp : (expIvGeneral k P.re).memR
      (Real.exp ((-s * ((Real.log (b : ℝ) : ℂ))).re)) :=
    expIvGeneral_memR hk hP.1 hexplo hexphi
  have hI : (expIBox kI n P.im).mem
      (Complex.exp (((-s * ((Real.log (b : ℝ)) : ℂ)).im : ℝ) * Complex.I)) :=
    expIBox_mem hP.2 hkI hIlo hIhi hn
  have hre : Cx.mem ((Real.exp ((-s * ((Real.log (b : ℝ)) : ℂ))).re) : ℂ)
      (⟨expIvGeneral k P.re, ⟨0, 0⟩⟩ : Cx) := by
    refine ⟨hExp, ?_⟩
    rw [Complex.ofReal_im]
    simp [Iv.memR]
  have hmul := Cx.mem_mul hre hI
  have hexp_eq : Complex.exp ((-s) * ((Real.log (b : ℝ)) : ℂ)) =
      (Real.exp ((-s * ((Real.log (b : ℝ)) : ℂ)).re) : ℂ) *
        Complex.exp ((((-s * ((Real.log (b : ℝ)) : ℂ)).im : ℝ) : ℂ) * Complex.I) := by
    rw [Complex.exp_eq_exp_re_mul_sin_add_cos, Complex.exp_mul_I, ← Complex.ofReal_exp]
  rw [← hexp_eq] at hmul
  simpa [cpowBox, P, Cx.mul, Iv.sub, Iv.add, Iv.neg, expIBox] using hmul

/-! ## A concrete check -/

/-- A one-term check: the verified box for `3^{-(1/2+5i)}` accepts the point
box and its four side conditions are discharged by evaluation. -/
example :
    Cx.mem (((3 : ℝ) : ℂ) ^ (-((1 / 2 : ℂ) + 5 * Complex.I)))
      (cpowBox 20 2 8 8 3 ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (5 : ℚ)⟩⟩) := by
  apply cpowBox_mem (N := 20) (k := 2) (kI := 8) (n := 8) (b := 3) (hb := by norm_num)
    (s := (1 / 2 : ℂ) + 5 * Complex.I) (S := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (5 : ℚ)⟩⟩)
    (hk := by norm_num) (hkI := by norm_num) (hn := by norm_num)
  · refine ⟨?_, ?_⟩ <;> norm_num [Iv.memR]
  all_goals native_decide

end PartialTail
