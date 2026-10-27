import Mathlib
import IBox

/-!
# Transcendental interval enclosures

This file ports the explicit series bounds of `rativ.py` to Lean.  It proves
sound rational enclosures for `π`, `exp`, `log`, `sin` and `cos`, so that the
transcendental leaves of a partial-sum-plus-tail certificate need no longer be
taken on trust.

The design is deliberately elementary:

* `π` is the 20-digit rational interval of Mathlib's `Real.pi_gt_d20` /
  `Real.pi_lt_d20`;
* `exp` is the reduced Taylor polynomial plus `Real.exp_bound`;
* `log` is `Real.hasSum_log_one_add` (the positive-term series in
  `a/(a+2)`) plus a geometric tail bound;
* `sin`/`cos` are the real/imaginary parts of `Complex.exp (t * I)` after a
  `2π` reduction, using `Complex.exp_bound`.

The series bounds are not merely numerical: every enclosure carries a Lean
theorem that it contains the true value.
-/

noncomputable section

open scoped BigOperators
open Polynomial

namespace PartialTail

namespace Iv

/-- Integer power of a rational interval, by repeated multiplication. -/
def powNat (A : Iv) : ℕ → Iv
  | 0 => ⟨1, 1⟩
  | n + 1 => (powNat A n).mul A

theorem memR_powNat {x : ℝ} {A : Iv} (hx : A.memR x) (n : ℕ) :
    (A.powNat n).memR (x ^ n) := by
  induction n with
  | zero => simpa [powNat] using (show (⟨1, 1⟩ : Iv).memR (1 : ℝ) from by
      constructor <;> norm_num [memR])
  | succ n ih =>
      simpa [powNat, pow_succ] using memR_mul ih hx

end Iv

/-! ## `π` -/

/-- The 20-digit rational enclosure of `π`. -/
def piIv : Iv :=
  ⟨314159265358979323846 / 10 ^ 20, 314159265358979323847 / 10 ^ 20⟩

theorem piIv_memR : piIv.memR Real.pi := by
  constructor
  · unfold piIv
    have h := Real.pi_gt_d20
    norm_num at h ⊢
    exact le_of_lt h
  · unfold piIv
    have h := Real.pi_lt_d20
    norm_num at h ⊢
    exact le_of_lt h

/-! ## `exp` -/

/-- Taylor polynomial of `exp` to order `n`, evaluated on an interval. -/
def expTaylor (n : ℕ) (A : Iv) : Iv :=
  match n with
  | 0 => ⟨0, 0⟩
  | n + 1 => (expTaylor n A).add ((A.powNat n).scale (1 / (n.factorial : ℚ)))

theorem expTaylor_memR {x : ℝ} {A : Iv} (hx : A.memR x) (n : ℕ) :
    (expTaylor n A).memR
      (∑ k ∈ Finset.range n, x ^ k / (k.factorial : ℝ)) := by
  induction n with
  | zero => simp [expTaylor, Iv.memR]
  | succ n ih =>
      have hbox : expTaylor (n + 1) A =
          (expTaylor n A).add ((A.powNat n).scale (1 / (n.factorial : ℚ))) := rfl
      rw [hbox, Finset.sum_range_succ]
      have hpow := Iv.memR_powNat hx n
      have hscale := Iv.memR_scale (q := (1 / (n.factorial : ℚ))) hpow
      have hscale' : Iv.memR (x ^ n / (n.factorial : ℝ))
          (Iv.scale (1 / (n.factorial : ℚ)) (A.powNat n)) := by
        convert hscale using 1
        push_cast
        rw [div_eq_mul_inv]
        ring
      have h := Iv.memR_add ih hscale'
      convert h using 1

/-- The explicit Taylor remainder for `exp` on `[-1,1]`. -/
def expRem (n : ℕ) : ℚ :=
  (n + 1 : ℚ) / ((n.factorial : ℚ) * n)

theorem expRem_nonneg (n : ℕ) : 0 ≤ expRem n := by
  unfold expRem
  positivity

/-- Sound enclosure of `Real.exp x` for `x ∈ A ⊆ [-1,1]`. -/
theorem expIv_memR {x : ℝ} {A : Iv} (hx : A.memR x)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    ((expTaylor n A).inflate (expRem n)).memR (Real.exp x) := by
  have hxlo : (-1 : ℝ) ≤ x := by
    have := hx.1
    have : ((-1 : ℚ) : ℝ) ≤ (A.lo : ℝ) := by exact_mod_cast hlo
    norm_num at this
    linarith
  have hxhi : x ≤ 1 := by
    have := hx.2
    have : (A.hi : ℝ) ≤ (1 : ℚ) := by exact_mod_cast hhi
    norm_num at this
    linarith
  have hxabs : |x| ≤ 1 := abs_le.mpr ⟨hxlo, hxhi⟩
  have hb := Real.exp_bound hxabs hn
  have hT := expTaylor_memR hx n
  have hle : |x| ^ n ≤ (1 : ℝ) := pow_le_one₀ (abs_nonneg x) hxabs
  have hfac : (0 : ℝ) < (n.factorial : ℝ) := by exact_mod_cast n.factorial_pos
  have hrem_cast : ((expRem n : ℚ) : ℝ) =
      (n.succ : ℝ) / ((n.factorial : ℝ) * n) := by
    unfold expRem
    push_cast
    ring
  have hdiff : |Real.exp x -
      ∑ k ∈ Finset.range n, x ^ k / (k.factorial : ℝ)| ≤ (expRem n : ℝ) := by
    calc
      |Real.exp x - ∑ k ∈ Finset.range n, x ^ k / (k.factorial : ℝ)|
          ≤ |x| ^ n * (n.succ / ((n.factorial : ℝ) * n)) := hb
      _ ≤ 1 * (n.succ / ((n.factorial : ℝ) * n)) := by
            gcongr
      _ = (expRem n : ℝ) := by
            rw [hrem_cast]
            ring
  have hd := abs_le.mp hdiff
  obtain ⟨hTlo, hThi⟩ := hT
  constructor
  · have h : ((expTaylor n A).lo : ℝ) - (expRem n : ℝ) ≤ Real.exp x := by
      linarith [hd.1, hTlo]
    simpa [Iv.inflate, Iv.memR] using h
  · have h : Real.exp x ≤ ((expTaylor n A).hi : ℝ) + (expRem n : ℝ) := by
      linarith [hd.2, hThi]
    simpa [Iv.inflate, Iv.memR] using h



/-! ## `log` -/

/-- One term of the positive `log(1+a)` series, over `ℚ`. -/
def logTermQ (a : ℚ) (k : ℕ) : ℚ :=
  (2 : ℚ) * (1 / (2 * (k : ℚ) + 1)) * (a / (a + 2)) ^ (2 * k + 1)

/-- The finite partial sum of the `log(1+a)` series, over `ℚ`. -/
def logPartialQ (N : ℕ) (a : ℚ) : ℚ :=
  ∑ k ∈ Finset.range N, logTermQ a k

/-- The geometric tail bound for the `log(1+a)` series. -/
def logRemQ (N : ℕ) (a : ℚ) : ℚ :=
  (2 : ℚ) * (a / (a + 2)) ^ (2 * N + 1) /
    ((2 * (N : ℚ) + 1) * (1 - (a / (a + 2)) ^ 2))

theorem logPartialQ_cast (a : ℚ) (N : ℕ) :
    ((logPartialQ N a : ℚ) : ℝ) =
      ∑ k ∈ Finset.range N,
        (2 : ℝ) * (1 / (2 * (k : ℝ) + 1)) *
          ((a : ℝ) / ((a : ℝ) + 2)) ^ (2 * k + 1) := by
  unfold logPartialQ logTermQ
  push_cast
  refine Finset.sum_congr rfl fun k _ => ?_
  push_cast
  ring

theorem logRemQ_cast (a : ℚ) (N : ℕ) :
    ((logRemQ N a : ℚ) : ℝ) =
      (2 : ℝ) * ((a : ℝ) / ((a : ℝ) + 2)) ^ (2 * N + 1) /
        ((2 * (N : ℝ) + 1) * (1 - ((a : ℝ) / ((a : ℝ) + 2)) ^ 2)) := by
  unfold logRemQ
  push_cast
  ring

theorem logPartialQ_le_log {x : ℚ} (hx : 1 ≤ x) (N : ℕ) :
    (logPartialQ N (x - 1) : ℝ) ≤ Real.log (x : ℝ) := by
  have hx1 : (0 : ℝ) ≤ (x : ℝ) - 1 := by
    have : (1 : ℝ) ≤ (x : ℝ) := by exact_mod_cast hx
    linarith
  have h := Real.hasSum_log_one_add (a := (x : ℝ) - 1) hx1
  have hxlog : Real.log (1 + ((x : ℝ) - 1)) = Real.log (x : ℝ) := by ring_nf
  rw [hxlog] at h
  have hxsub : ((x - 1 : ℚ) : ℝ) = (x : ℝ) - 1 := by
    push_cast
    ring
  rw [logPartialQ_cast, hxsub]
  exact sum_le_hasSum (Finset.range N) (fun k _ => by positivity) h

theorem log_le_logPartialQ_add_rem {x : ℚ} (hx : 1 ≤ x) (N : ℕ) :
    Real.log (x : ℝ) ≤ (logPartialQ N (x - 1) : ℝ) + (logRemQ N (x - 1) : ℝ) := by
  have hx1 : (0 : ℝ) ≤ (x : ℝ) - 1 := by
    have : (1 : ℝ) ≤ (x : ℝ) := by exact_mod_cast hx
    linarith
  set a : ℝ := (x : ℝ) - 1 with ha
  have ha0 : 0 ≤ a := by simpa [ha] using hx1
  have hxsub : ((x - 1 : ℚ) : ℝ) = a := by
    rw [ha]
    push_cast
    ring
  set t : ℝ := a / (a + 2) with ht
  have ht0 : 0 ≤ t := by rw [ht]; positivity
  have ht1 : t < 1 := by
    rw [ht, div_lt_one]
    · linarith
    · linarith
  have h := Real.hasSum_log_one_add (a := a) ha0
  have hxlog : Real.log (1 + a) = Real.log (x : ℝ) := by rw [ha]; ring_nf
  rw [hxlog] at h
  have hsplit := h.summable.sum_add_tsum_nat_add N
  rw [h.tsum_eq] at hsplit
  have htail_summable : Summable (fun k : ℕ =>
      (2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) * t ^ (2 * (k + N) + 1)) :=
    (summable_nat_add_iff N).2 h.summable
  set C : ℝ := (2 : ℝ) * t ^ (2 * N + 1) / (2 * (N : ℝ) + 1) with hC
  have hgeom_summable : Summable (fun k : ℕ => C * (t ^ 2) ^ k) :=
    (summable_geometric_of_lt_one (by positivity) (by nlinarith [ht1])).mul_left C
  have hterm_le : ∀ k : ℕ,
      (2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) * t ^ (2 * (k + N) + 1) ≤
        C * (t ^ 2) ^ k := by
    intro k
    have hden : (2 * (N : ℝ) + 1) ≤ (2 * ((k + N : ℕ) : ℝ) + 1) := by
      have : (0 : ℝ) ≤ k := by positivity
      push_cast
      linarith
    have hpos : 0 < (2 * ((k + N : ℕ) : ℝ) + 1) := by positivity
    have hp : 0 < (2 * (N : ℝ) + 1) := by positivity
    have hpow : t ^ (2 * (k + N) + 1) =
        t ^ (2 * N + 1) * (t ^ 2) ^ k := by
      rw [show 2 * (k + N) + 1 = (2 * N + 1) + 2 * k by omega]
      rw [pow_add, pow_mul]
    rw [hpow]
    have hcoef : (2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) ≤
        (2 : ℝ) * (1 / (2 * (N : ℝ) + 1)) := by
      gcongr
    calc
      (2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) *
          (t ^ (2 * N + 1) * (t ^ 2) ^ k)
          = ((2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) * t ^ (2 * N + 1)) *
              (t ^ 2) ^ k := by ring
      _ ≤ ((2 : ℝ) * (1 / (2 * (N : ℝ) + 1)) * t ^ (2 * N + 1)) * (t ^ 2) ^ k := by
            gcongr
      _ = C * (t ^ 2) ^ k := by rw [hC]; ring
  have htail_le : (∑' k, (2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) *
      t ^ (2 * (k + N) + 1)) ≤ ∑' k, C * (t ^ 2) ^ k :=
    htail_summable.tsum_le_tsum hterm_le hgeom_summable
  have hgeom_tsum : (∑' k, C * (t ^ 2) ^ k) = C / (1 - t ^ 2) := by
    have hg := hasSum_geometric_of_lt_one (by positivity : (0 : ℝ) ≤ t ^ 2)
      (by nlinarith [ht1])
    simpa [hC, div_eq_mul_inv] using (hg.mul_left C).tsum_eq
  have hrem_cast : ((logRemQ N (x - 1) : ℚ) : ℝ) = C / (1 - t ^ 2) := by
    rw [logRemQ_cast, hxsub, hC, ht]
    field_simp
  rw [← hsplit]
  have htail_le' : (∑' k, (2 : ℝ) * (1 / (2 * ((k + N : ℕ) : ℝ) + 1)) *
      t ^ (2 * (k + N) + 1)) ≤ C / (1 - t ^ 2) := by
    rw [← hgeom_tsum]; exact htail_le
  have hpartial_eq : (∑ k ∈ Finset.range N,
      (2 : ℝ) * (1 / (2 * (k : ℝ) + 1)) * t ^ (2 * k + 1)) =
      (logPartialQ N (x - 1) : ℝ) := by
    rw [logPartialQ_cast]
    apply Finset.sum_congr rfl
    intro k _
    congr 1
    rw [hxsub]
  rw [hpartial_eq, hrem_cast]
  linarith



/-! ## Complex exponential and `sin`/`cos` -/

namespace Cx

/-- Integer power of a complex box. -/
def powNat (Z : Cx) : ℕ → Cx
  | 0 => ⟨⟨1, 1⟩, ⟨0, 0⟩⟩
  | n + 1 => (powNat Z n).mul Z

theorem mem_powNat {z : ℂ} {Z : Cx} (hz : Z.mem z) (n : ℕ) :
    (Z.powNat n).mem (z ^ n) := by
  induction n with
  | zero =>
      refine ⟨?_, ?_⟩ <;> simp [powNat, Iv.memR]
  | succ n ih =>
      simpa [powNat, pow_succ] using mem_mul ih hz

/-- If `z` is within `r` of a point of `Z`, then `z` lies in `Z` inflated by `r`. -/
theorem mem_inflate_of_norm_sub_le {z w : ℂ} {Z : Cx} {r : ℚ}
    (hw : Z.mem w) (hr : 0 ≤ r) (h : ‖z - w‖ ≤ (r : ℝ)) :
    (Z.inflate r).mem z := by
  have hre : |z.re - w.re| ≤ (r : ℝ) :=
    (Complex.abs_re_le_norm (z - w)).trans h
  have him : |z.im - w.im| ≤ (r : ℝ) :=
    (Complex.abs_im_le_norm (z - w)).trans h
  rcases hw with ⟨⟨hwrlo, hwrhi⟩, ⟨hwilo, hwihi⟩⟩
  simp only [Cx.mem, Cx.inflate, Iv.memR, Iv.inflate]
  push_cast
  constructor
  · constructor
    · have := (abs_le.mp hre).1; linarith
    · have := (abs_le.mp hre).2; linarith
  · constructor
    · have := (abs_le.mp him).1; linarith
    · have := (abs_le.mp him).2; linarith

end Cx

/-- Taylor polynomial of `exp (t * I)` to order `n`. -/
def expITaylor (n : ℕ) (A : Iv) : Cx :=
  match n with
  | 0 => ⟨⟨0, 0⟩, ⟨0, 0⟩⟩
  | n + 1 =>
      (expITaylor n A).add
        ((Cx.powNat ⟨⟨0, 0⟩, A⟩ n).scale (1 / (n.factorial : ℚ)))

theorem expITaylor_mem {t : ℝ} {A : Iv} (ht : A.memR t) (n : ℕ) :
    (expITaylor n A).mem
      (∑ k ∈ Finset.range n, ((t : ℂ) * Complex.I) ^ k / (k.factorial : ℂ)) := by
  induction n with
  | zero => simp [expITaylor, Cx.mem, Iv.memR]
  | succ n ih =>
      have hbox : expITaylor (n + 1) A =
          (expITaylor n A).add
            ((Cx.powNat ⟨⟨0, 0⟩, A⟩ n).scale (1 / (n.factorial : ℚ))) := rfl
      rw [hbox, Finset.sum_range_succ]
      have hz : (⟨⟨0, 0⟩, A⟩ : Cx).mem ((t : ℂ) * Complex.I) := by
        refine ⟨?_, ?_⟩
        · simp [Iv.memR]
        · simpa [Complex.mul_I_im] using ht
      have hpow := Cx.mem_powNat hz n
      have hscale := Cx.mem_scale (q := (1 / (n.factorial : ℚ))) hpow
      have h := Cx.mem_add ih hscale
      convert h using 1
      push_cast
      ring

theorem expI_mem_inflate {t : ℝ} {A : Iv} (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    ((expITaylor n A).inflate (expRem n)).mem
      (Complex.exp ((t : ℂ) * Complex.I)) := by
  have hxlo : (-1 : ℝ) ≤ t := by
    have := ht.1
    have : ((-1 : ℚ) : ℝ) ≤ (A.lo : ℝ) := by exact_mod_cast hlo
    norm_num at this
    linarith
  have hxhi : t ≤ 1 := by
    have := ht.2
    have : (A.hi : ℝ) ≤ (1 : ℚ) := by exact_mod_cast hhi
    norm_num at this
    linarith
  have htabs : |t| ≤ 1 := abs_le.mpr ⟨hxlo, hxhi⟩
  have hnorm : ‖(t : ℂ) * Complex.I‖ ≤ 1 := by
    simpa [Complex.norm_mul] using htabs
  have hb := Complex.exp_bound (x := (t : ℂ) * Complex.I) hnorm hn
  have hT := expITaylor_mem ht n
  have hle : ‖(t : ℂ) * Complex.I‖ ^ n ≤ (1 : ℝ) :=
    pow_le_one₀ (norm_nonneg _) hnorm
  have hfac : (0 : ℝ) < (n.factorial : ℝ) := by exact_mod_cast n.factorial_pos
  have hrem_cast : ((expRem n : ℚ) : ℝ) =
      (n.succ : ℝ) * ((n.factorial : ℝ) * n)⁻¹ := by
    unfold expRem
    push_cast
    ring
  have hdiff : ‖Complex.exp ((t : ℂ) * Complex.I) -
      ∑ k ∈ Finset.range n, ((t : ℂ) * Complex.I) ^ k / (k.factorial : ℂ)‖ ≤
      (expRem n : ℝ) := by
    calc
      ‖Complex.exp ((t : ℂ) * Complex.I) -
          ∑ k ∈ Finset.range n, ((t : ℂ) * Complex.I) ^ k / (k.factorial : ℂ)‖
          ≤ ‖(t : ℂ) * Complex.I‖ ^ n *
              ((n.succ : ℝ) * ((n.factorial : ℝ) * n)⁻¹) := hb
      _ ≤ 1 * ((n.succ : ℝ) * ((n.factorial : ℝ) * n)⁻¹) := by gcongr
      _ = (expRem n : ℝ) := by rw [hrem_cast]; ring
  exact Cx.mem_inflate_of_norm_sub_le hT (expRem_nonneg n) hdiff

/-- Sound `cos` enclosure for `t ∈ A ⊆ [-1,1]`. -/
theorem cosIv_memR {t : ℝ} {A : Iv} (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    ((expITaylor n A).inflate (expRem n)).re.memR (Real.cos t) := by
  have h := expI_mem_inflate ht hlo hhi hn
  have hre := h.1
  simpa [Complex.exp_ofReal_mul_I_re] using hre

/-- Sound `sin` enclosure for `t ∈ A ⊆ [-1,1]`. -/
theorem sinIv_memR {t : ℝ} {A : Iv} (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    ((expITaylor n A).inflate (expRem n)).im.memR (Real.sin t) := by
  have h := expI_mem_inflate ht hlo hhi hn
  have him := h.2
  simpa [Complex.exp_ofReal_mul_I_im] using him



/-! ## Interval wrappers -/

/-- The `exp` box for `A ⊆ [-1,1]`. -/
def expBox (n : ℕ) (A : Iv) : Iv :=
  (expTaylor n A).inflate (expRem n)

theorem expBox_memR {x : ℝ} {A : Iv} (hx : A.memR x)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    (expBox n A).memR (Real.exp x) :=
  expIv_memR hx hlo hhi hn

/-- General `exp`: split `x` into `k` equal parts, each inside `[-1,1]`. -/
def expIvGeneral (k : ℕ) (A : Iv) : Iv :=
  (expBox k (A.scale (1 / (k : ℚ)))).powNat k

theorem expIvGeneral_memR {x : ℝ} {A : Iv} {k : ℕ} (hk : 0 < k) (hx : A.memR x)
    (hlo : (-1 : ℚ) ≤ (A.scale (1 / (k : ℚ))).lo)
    (hhi : (A.scale (1 / (k : ℚ))).hi ≤ 1) :
    (expIvGeneral k A).memR (Real.exp x) := by
  have hxs : (A.scale (1 / (k : ℚ))).memR (x * (1 / (k : ℝ))) := by
    have h := Iv.memR_scale (q := (1 / (k : ℚ))) hx
    convert h using 1
    push_cast
    ring
  have hexp := expBox_memR hxs hlo hhi hk
  have hpow := Iv.memR_powNat hexp k
  have hxsplit : x = (k : ℝ) * (x * (1 / (k : ℝ))) := by
    field_simp
  have hxexp : Real.exp x = (Real.exp (x * (1 / (k : ℝ)))) ^ k := by
    nth_rw 1 [hxsplit]
    rw [Real.exp_nat_mul]
  rw [hxexp]
  exact hpow

/-- The interval `log` box for `A ⊆ [1, ∞)`. -/
def logIv (N : ℕ) (A : Iv) : Iv :=
  ⟨logPartialQ N (A.lo - 1), logPartialQ N (A.hi - 1) + logRemQ N (A.hi - 1)⟩

theorem logIv_memR {x : ℝ} {A : Iv} (hlo : (1 : ℚ) ≤ A.lo) (hx : A.memR x) :
    (logIv N A).memR (Real.log x) := by
  have hlopos : (0 : ℝ) < (A.lo : ℝ) := by
    have : (1 : ℚ) ≤ A.lo := hlo
    exact_mod_cast (lt_of_lt_of_le zero_lt_one this)
  have hxpos : 0 < x := lt_of_lt_of_le hlopos hx.1
  have hmono_lo : Real.log (A.lo : ℝ) ≤ Real.log x :=
    Real.log_le_log hlopos hx.1
  have hmono_hi : Real.log x ≤ Real.log (A.hi : ℝ) :=
    Real.log_le_log hxpos hx.2
  have hle : A.lo ≤ A.hi := by exact_mod_cast (le_trans hx.1 hx.2)
  have hhi1 : (1 : ℚ) ≤ A.hi := le_trans hlo hle
  have hlow := logPartialQ_le_log (x := A.lo) hlo N
  have hhi := log_le_logPartialQ_add_rem (x := A.hi) hhi1 N
  change ((logPartialQ N (A.lo - 1) : ℚ) : ℝ) ≤ Real.log x ∧
      Real.log x ≤ ((logPartialQ N (A.hi - 1) + logRemQ N (A.hi - 1) : ℚ) : ℝ)
  constructor
  · exact hlow.trans hmono_lo
  · have hcast : ((logPartialQ N (A.hi - 1) + logRemQ N (A.hi - 1) : ℚ) : ℝ) =
        (logPartialQ N (A.hi - 1) : ℝ) + (logRemQ N (A.hi - 1) : ℝ) := by
      push_cast
      ring
    rw [hcast]
    exact hmono_hi.trans hhi

/-! ## Periodic reduction for `sin`/`cos` -/

/-- Subtract `m · 2π` from an interval. -/
def reduce2pi (A : Iv) (m : ℤ) : Iv :=
  A.sub (piIv.scale (2 * (m : ℚ)))

theorem reduce2pi_memR {t : ℝ} {A : Iv} (ht : A.memR t) (m : ℤ) :
    (reduce2pi A m).memR (t - (m : ℝ) * (2 * Real.pi)) := by
  have hp := piIv_memR
  have hscale := Iv.memR_scale (q := (2 * (m : ℚ))) hp
  have hsub := Iv.memR_sub ht hscale
  have hval : t - (m : ℝ) * (2 * Real.pi) =
      t - (((2 * (m : ℚ) : ℚ) : ℝ)) * Real.pi := by
    push_cast
    ring
  rw [hval]
  simpa [reduce2pi] using hsub

/-- The `cos` box for `A ⊆ [-1,1]`. -/
def cosBox (n : ℕ) (A : Iv) : Iv :=
  ((expITaylor n A).inflate (expRem n)).re

/-- The `sin` box for `A ⊆ [-1,1]`. -/
def sinBox (n : ℕ) (A : Iv) : Iv :=
  ((expITaylor n A).inflate (expRem n)).im

theorem cosBox_memR {t : ℝ} {A : Iv} (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    (cosBox n A).memR (Real.cos t) :=
  cosIv_memR ht hlo hhi hn

theorem sinBox_memR {t : ℝ} {A : Iv} (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ A.lo) (hhi : A.hi ≤ 1) (hn : 0 < n) :
    (sinBox n A).memR (Real.sin t) :=
  sinIv_memR ht hlo hhi hn

/-- General `cos`: reduce by `m · 2π` into `[-1,1]`. -/
theorem cosReduce_memR {t : ℝ} {A : Iv} (m : ℤ) (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ (reduce2pi A m).lo) (hhi : (reduce2pi A m).hi ≤ 1) (hn : 0 < n) :
    (cosBox n (reduce2pi A m)).memR (Real.cos t) := by
  have ht' := reduce2pi_memR ht m
  have h := cosBox_memR ht' hlo hhi hn
  simpa [Real.cos_sub_int_mul_two_pi] using h

/-- General `sin`: reduce by `m · 2π` into `[-1,1]`. -/
theorem sinReduce_memR {t : ℝ} {A : Iv} (m : ℤ) (ht : A.memR t)
    (hlo : (-1 : ℚ) ≤ (reduce2pi A m).lo) (hhi : (reduce2pi A m).hi ≤ 1) (hn : 0 < n) :
    (sinBox n (reduce2pi A m)).memR (Real.sin t) := by
  have ht' := reduce2pi_memR ht m
  have h := sinBox_memR ht' hlo hhi hn
  simpa [Real.sin_sub_int_mul_two_pi] using h



/-! ## Concrete checks -/

theorem piIv_check : piIv.memR Real.pi := piIv_memR

theorem log_two_check : (logIv 8 ⟨2, 2⟩).memR (Real.log 2) :=
  logIv_memR (by norm_num) (by norm_num [Iv.memR])

theorem exp_one_check : (expIvGeneral 4 ⟨1, 1⟩).memR (Real.exp 1) := by
  apply expIvGeneral_memR (k := 4) (by norm_num) (by norm_num [Iv.memR])
  · norm_num [Iv.scale]
  · norm_num [Iv.scale]

theorem cos_one_check : (cosBox 8 ⟨1, 1⟩).memR (Real.cos 1) := by
  apply cosBox_memR (n := 8) (by norm_num [Iv.memR])
  · norm_num
  · norm_num
  · norm_num

theorem sin_one_check : (sinBox 8 ⟨1, 1⟩).memR (Real.sin 1) := by
  apply sinBox_memR (n := 8) (by norm_num [Iv.memR])
  · norm_num
  · norm_num
  · norm_num

end PartialTail
