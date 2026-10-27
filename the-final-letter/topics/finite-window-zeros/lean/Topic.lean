import Mathlib

set_option maxHeartbeats 800000

/-!
# Finite-window zeros — formal core (P3)

This dossier attacks P3 of `status.html` §7: a genuine theorem whose numerical
premise is discharged by a Lean certificate.  The chosen finite-window object
is the critical-line segment of `ζ`, reached through the grouped alternating
(eta) series

`η(s) = Σ_{m≥0} ((2m+1)^{-s} - (2m+2)^{-s})`.

For `Re s > 0` this grouping is absolutely convergent, and
`(1 - 2^{1-s}) ζ(s) = η(s)`.  The analytic-continuation step and the certified
enclosure are the programme of this dossier; this file proves the finite
algebra and the pair estimate that the enclosure consumes.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open scoped BigOperators
open scoped Topology
open Filter
open MeasureTheory

namespace FiniteWindowZeros

/-! ## The finite alternating sum and its pairing -/

/-- The alternating (eta) partial sum over `n = 1, …, N`. -/
def altPartial (s : ℂ) (N : ℕ) : ℂ :=
  ∑ n ∈ Finset.range N, (-1 : ℂ) ^ n / ((n + 1 : ℕ) : ℂ) ^ s

/-- The grouped pair sum over `m = 0, …, M-1`. -/
def pairPartial (s : ℂ) (M : ℕ) : ℂ :=
  ∑ m ∈ Finset.range M,
    ((((2 * m + 1 : ℕ) : ℂ) ^ (-s)) - (((2 * m + 2 : ℕ) : ℂ) ^ (-s)))

/-- The `m`-th pair `(2m+1)^{-s} - (2m+2)^{-s}`. -/
def pairTerm (s : ℂ) (m : ℕ) : ℂ :=
  (((2 * m + 1 : ℕ) : ℂ) ^ (-s)) - (((2 * m + 2 : ℕ) : ℂ) ^ (-s))

lemma pairPartial_eq_sum_pairTerm (s : ℂ) (M : ℕ) :
    pairPartial s M = ∑ m ∈ Finset.range M, pairTerm s m := rfl

/-- **Finite regrouping.**  The alternating partial sum over `2M` terms is the
sum of the `M` adjacent odd/even pairs. -/
theorem altPartial_two_mul (s : ℂ) (M : ℕ) :
    altPartial s (2 * M) = pairPartial s M := by
  induction M with
  | zero => simp [altPartial, pairPartial]
  | succ M ih =>
      have h2 : 2 * (M + 1) = 2 * M + 2 := by omega
      rw [h2, altPartial, Finset.sum_range_succ, Finset.sum_range_succ]
      have hih : (∑ x ∈ Finset.range (2 * M),
          (-1 : ℂ) ^ x / ((x + 1 : ℕ) : ℂ) ^ s) = pairPartial s M := ih
      rw [hih]
      simp only [pairPartial, Finset.sum_range_succ]
      -- the two new terms are `(-1)^{2M}/(2M+1)^s` and `(-1)^{2M+1}/(2M+2)^s`
      have hsign0 : (-1 : ℂ) ^ (2 * M) = 1 := by
        rw [pow_mul]
        norm_num
      have hsign1 : (-1 : ℂ) ^ (2 * M + 1) = -1 := by
        rw [pow_succ, hsign0]
        ring
      rw [hsign0, hsign1]
      simp only [one_div]
      rw [Complex.cpow_neg, Complex.cpow_neg]
      ring

/-! ## The pair estimate -/

/-- Derivative of the real-base complex power `x ↦ x^{-s}` along the real axis. -/
lemma hasDerivAt_cpow_ofReal (s : ℂ) {x : ℝ} (hx : 0 < x) :
    HasDerivAt (fun y : ℝ => (((y : ℝ)) : ℂ) ^ (-s))
      (-s * (((x : ℝ)) : ℂ) ^ (-s - 1)) x := by
  have hslit : ((x : ℂ)) ∈ Complex.slitPlane := by
    rw [Complex.ofReal_mem_slitPlane]
    exact hx
  have hbase : HasDerivAt (fun z : ℂ => z) 1 (x : ℂ) := hasDerivAt_id (x : ℂ)
  have h := hbase.cpow_const (c := -s) hslit
  simpa using h.comp_ofReal

/-- **Pair estimate.**  For `Re s ≥ σ > 0`, the adjacent odd/even pair is
bounded by the derivative bound on the interval `[2m+1, 2m+2]`:

`‖(2m+1)^{-s} - (2m+2)^{-s}‖ ≤ ‖s‖ · (2m+1)^{-σ-1}`.

This is the term bound that makes the grouped eta series absolutely convergent
for `Re s > 0` and gives the rational tail radius. -/
theorem norm_pairTerm_le {s : ℂ} {σ : ℝ} (hσ : 0 < σ) (hσs : σ ≤ s.re) (m : ℕ) :
    ‖pairTerm s m‖ ≤ ‖s‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-σ - 1)) := by
  let a : ℝ := ((2 * m + 1 : ℕ) : ℝ)
  let b : ℝ := ((2 * m + 2 : ℕ) : ℝ)
  have ha : 0 < a := by
    dsimp [a]
    positivity
  have ha1 : (1 : ℝ) ≤ a := by
    dsimp [a]
    exact_mod_cast (by omega : 1 ≤ 2 * m + 1)
  have hab : a ≤ b := by
    dsimp [a, b]
    push_cast
    linarith
  have hderiv : ∀ x ∈ Set.Ico a b,
      ‖(-s) * (((x : ℝ)) : ℂ) ^ (-s - 1)‖ ≤ ‖s‖ * a ^ (-σ - 1) := by
    intro x hx
    have hxpos : 0 < x := lt_of_lt_of_le ha hx.1
    rw [norm_mul, norm_neg, Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
    have hre : (-s - 1).re = -s.re - 1 := by
      simp
    rw [hre]
    have hmono1 : x ^ (-s.re - 1) ≤ a ^ (-s.re - 1) :=
      Real.rpow_le_rpow_of_nonpos ha hx.1 (by linarith)
    have hexp : -s.re - 1 ≤ -σ - 1 := by linarith
    have hmono2 : a ^ (-s.re - 1) ≤ a ^ (-σ - 1) :=
      Real.rpow_le_rpow_of_exponent_le ha1 hexp
    exact mul_le_mul_of_nonneg_left (hmono1.trans hmono2) (norm_nonneg s)
  have hMVT := norm_image_sub_le_of_norm_deriv_le_segment'
    (a := a) (b := b)
    (f := fun y : ℝ => (((y : ℝ)) : ℂ) ^ (-s))
    (f' := fun x : ℝ => (-s) * (((x : ℝ)) : ℂ) ^ (-s - 1))
    (C := ‖s‖ * a ^ (-σ - 1))
    (fun x hx => (hasDerivAt_cpow_ofReal s (lt_of_lt_of_le ha hx.1)).hasDerivWithinAt)
    hderiv b (Set.right_mem_Icc.mpr hab)
  have hba : b - a = 1 := by
    dsimp [a, b]
    push_cast
    ring
  rw [hba, mul_one] at hMVT
  have hpair : pairTerm s m = -((((b : ℝ)) : ℂ) ^ (-s) - (((a : ℝ)) : ℂ) ^ (-s)) := by
    unfold pairTerm
    dsimp [a, b]
    ring
  rw [hpair, norm_neg]
  simpa [a, b] using hMVT

/-- The majorant sequence `m ↦ (2m+1)^{-p}` is summable for `p > 1`. -/
theorem summable_pairMajorant {p : ℝ} (hp : 1 < p) :
    Summable (fun m : ℕ => (((2 * m + 1 : ℕ) : ℝ) ^ (-p))) := by
  have hbase : Summable (fun n : ℕ => ((n : ℝ) ^ (-p))) :=
    Real.summable_nat_rpow.mpr (by linarith)
  have hshift : Summable (fun m : ℕ => (((m + 1 : ℕ) : ℝ) ^ (-p))) := by
    simpa using (summable_nat_add_iff 1).2 hbase
  refine hshift.of_nonneg_of_le (fun m => ?_) (fun m => ?_)
  · exact Real.rpow_nonneg (by positivity) _
  · have hm : (0 : ℝ) < ((m + 1 : ℕ) : ℝ) := by positivity
    have hle : ((m + 1 : ℕ) : ℝ) ≤ ((2 * m + 1 : ℕ) : ℝ) := by
      push_cast
      linarith
    have h := Real.rpow_le_rpow_of_nonpos hm hle (by linarith : -p ≤ 0)
    simpa [neg_mul] using h

/-- The majorant in the exponent form used by the enclosure. -/
theorem summable_pairMajorant' {σ : ℝ} (hσ : 0 < σ) :
    Summable (fun m : ℕ => (((2 * m + 1 : ℕ) : ℝ) ^ (-σ - 1))) := by
  have h := summable_pairMajorant (p := σ + 1) (by linarith)
  convert h using 1
  ext m
  congr 1
  ring

/-- The grouped eta series is summable for `Re s > 0`. -/
theorem summable_pairTerm {s : ℂ} (hs : 0 < s.re) :
    Summable (fun m : ℕ => pairTerm s m) := by
  obtain ⟨σ, hσ, hσs⟩ : ∃ σ : ℝ, 0 < σ ∧ σ ≤ s.re :=
    ⟨s.re / 2, by linarith, by linarith⟩
  have hbase : Summable (fun m : ℕ => (((2 * m + 1 : ℕ) : ℝ) ^ (-σ - 1))) :=
    summable_pairMajorant' hσ
  have hmaj : Summable (fun m : ℕ => ‖s‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-σ - 1))) :=
    hbase.mul_left ‖s‖
  exact hmaj.of_norm_bounded (f := fun m : ℕ => pairTerm s m)
    (fun m => norm_pairTerm_le hσ hσs m)

/-! ## Analyticity of the grouped eta series on `Re s > 0` -/

/-- The grouped eta series. -/
def etaGrouped (s : ℂ) : ℂ := ∑' m : ℕ, pairTerm s m

/-- A bounded open rectangle in the complex plane, written as a product of real
intervals: `σ0 < Re w < σ1` and `-T < Im w < T`. -/
def stripBox (σ0 σ1 T : ℝ) : Set ℂ := Set.Ioo σ0 σ1 ×ℂ Set.Ioo (-T) T

lemma mem_stripBox {σ0 σ1 T : ℝ} {w : ℂ} :
    w ∈ stripBox σ0 σ1 T ↔ σ0 < w.re ∧ w.re < σ1 ∧ -T < w.im ∧ w.im < T := by
  simp only [stripBox, Complex.mem_reProdIm, Set.mem_Ioo]
  tauto

/-- A norm bound on the rectangle. -/
lemma norm_le_stripRadius {σ0 σ1 T : ℝ} {w : ℂ} (hw : w ∈ stripBox σ0 σ1 T) :
    ‖w‖ ≤ max |σ0| |σ1| + T := by
  rw [mem_stripBox] at hw
  obtain ⟨h0, h1, h2, h3⟩ := hw
  have hre : |w.re| ≤ max |σ0| |σ1| := by
    rw [abs_le]
    constructor
    · have : -|σ0| ≤ σ0 := neg_abs_le σ0
      linarith [neg_le_abs σ1, le_max_left |σ0| |σ1|]
    · have : σ1 ≤ |σ1| := le_abs_self σ1
      linarith [le_max_right |σ0| |σ1|]
  have him : |w.im| ≤ T := by
    rw [abs_le]
    constructor <;> linarith
  calc
    ‖w‖ ≤ |w.re| + |w.im| := Complex.norm_le_abs_re_add_abs_im w
    _ ≤ max |σ0| |σ1| + T := add_le_add hre him

/-- **Analyticity on a bounded strip.**  On any bounded rectangle contained in
`Re s > 0`, the grouped eta series is a locally uniform limit of entire
functions with a summable norm bound, hence differentiable. -/
theorem differentiableOn_etaGrouped {σ0 σ1 T : ℝ} (hσ0 : 0 < σ0) (hT : 0 < T) :
    DifferentiableOn ℂ etaGrouped (stripBox σ0 σ1 T) := by
  let R : ℝ := max |σ0| |σ1| + T
  have hR0 : 0 ≤ R :=
    add_nonneg (le_trans (abs_nonneg σ0) (le_max_left _ _)) (le_of_lt hT)
  have hu : Summable (fun m : ℕ => R * (((2 * m + 1 : ℕ) : ℝ) ^ (-σ0 - 1))) :=
    (summable_pairMajorant' hσ0).mul_left R
  have hU : IsOpen (stripBox σ0 σ1 T) := isOpen_Ioo.reProdIm isOpen_Ioo
  have hF : ∀ m : ℕ, DifferentiableOn ℂ (fun w : ℂ => pairTerm w m)
      (stripBox σ0 σ1 T) := by
    intro m
    have ha : ((2 * m + 1 : ℕ) : ℂ) ≠ 0 := by
      exact_mod_cast (by omega : (2 * m + 1 : ℕ) ≠ 0)
    have hb : ((2 * m + 2 : ℕ) : ℂ) ≠ 0 := by
      exact_mod_cast (by omega : (2 * m + 2 : ℕ) ≠ 0)
    have h1 : DifferentiableOn ℂ
        (fun w : ℂ => (((2 * m + 1 : ℕ) : ℂ)) ^ (-w)) (stripBox σ0 σ1 T) := by
      intro w _
      exact (((differentiableAt_id (x := w)).neg.const_cpow (Or.inl ha))).differentiableWithinAt
    have h2 : DifferentiableOn ℂ
        (fun w : ℂ => (((2 * m + 2 : ℕ) : ℂ)) ^ (-w)) (stripBox σ0 σ1 T) := by
      intro w _
      exact (((differentiableAt_id (x := w)).neg.const_cpow (Or.inl hb))).differentiableWithinAt
    exact h1.sub h2
  have hbound : ∀ (m : ℕ) (w : ℂ), w ∈ stripBox σ0 σ1 T →
      ‖pairTerm w m‖ ≤ R * (((2 * m + 1 : ℕ) : ℝ) ^ (-σ0 - 1)) := by
    intro m w hw
    have hw' := mem_stripBox.mp hw
    have hre : σ0 ≤ w.re := le_of_lt hw'.1
    have hwR : ‖w‖ ≤ R := norm_le_stripRadius hw
    exact (norm_pairTerm_le hσ0 hre m).trans
      (mul_le_mul_of_nonneg_right hwR (Real.rpow_nonneg (by positivity) _))
  convert Complex.differentiableOn_tsum_of_summable_norm
    (F := fun m w => pairTerm w m) hu hF hU hbound using 1
  ext w
  rfl

/-- Every point of `Re s > 0` lies in a bounded strip on which the grouped eta
series is differentiable. -/
theorem differentiableAt_etaGrouped {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ etaGrouped s := by
  let σ0 : ℝ := s.re / 2
  let σ1 : ℝ := s.re + 1
  let T : ℝ := |s.im| + 1
  have hσ0 : 0 < σ0 := by positivity
  have hT : 0 < T := by positivity
  have hs_mem : s ∈ stripBox σ0 σ1 T := by
    rw [mem_stripBox]
    dsimp [σ0, σ1, T]
    constructor
    · linarith
    constructor
    · linarith
    constructor <;> linarith [neg_abs_le s.im, le_abs_self s.im]
  exact (differentiableOn_etaGrouped (σ0 := σ0) (σ1 := σ1) (T := T) hσ0 hT).differentiableAt
    ((isOpen_Ioo.reProdIm isOpen_Ioo).mem_nhds hs_mem)

/-- **The eta identity in the convergence range.**  For `Re s > 1` the grouped
eta series equals `(1 - 2^{1-s}) ζ(s)`.  The proof uses absolute convergence:
split `ζ` into odd and even terms and subtract twice the even part. -/
theorem etaGrouped_eq_one_sub_two_cpow_mul_zeta {s : ℂ} (hs : 1 < s.re) :
    etaGrouped s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
  let f : ℕ → ℂ := fun n => 1 / (((n + 1 : ℕ) : ℂ) ^ s)
  have hf : Summable f := by
    have h := (Complex.summable_one_div_nat_cpow (p := s)).mpr hs
    have hshift : Summable (fun n : ℕ => 1 / ((n : ℂ) + 1) ^ s) := by
      simpa using (summable_nat_add_iff 1).2 h
    simpa [f] using hshift
  have hzeta : ∑' n, f n = riemannZeta s := by
    rw [zeta_eq_tsum_one_div_nat_add_one_cpow hs]
    simp [f, Nat.cast_add]
  have heven : Summable fun k : ℕ => f (2 * k) := by
    exact hf.comp_injective (by intro a b hab; omega)
  have hodd : Summable fun k : ℕ => f (2 * k + 1) := by
    exact hf.comp_injective (by
      intro a b hab
      exact Nat.eq_of_mul_eq_mul_left (by decide : 0 < 2) (Nat.add_right_cancel hab))
  have hsplit : ∑' k, f (2 * k) + ∑' k, f (2 * k + 1) = ∑' n, f n :=
    tsum_even_add_odd heven hodd
  have hterm (k : ℕ) : f (2 * k + 1) = (2 : ℂ) ^ (-s) * f k := by
    have hnat : 2 * k + 1 + 1 = 2 * (k + 1) := by ring
    simp only [f, hnat]
    rw [show (((2 * (k + 1) : ℕ) : ℂ)) = ((2 : ℂ) * ((k + 1 : ℕ) : ℂ)) by push_cast; ring]
    change 1 / (((2 : ℂ) * ((k + 1 : ℕ) : ℂ)) ^ s) =
      (2 : ℂ) ^ (-s) * (1 / ((k + 1 : ℕ) : ℂ) ^ s)
    rw [show (2 : ℂ) = ((2 : ℕ) : ℂ) by norm_num]
    rw [Complex.natCast_mul_natCast_cpow, Complex.cpow_neg]
    rw [one_div, one_div, mul_inv]
  have hodd_tsum : ∑' k, f (2 * k + 1) = (2 : ℂ) ^ (-s) * ∑' k, f k := by
    rw [show (fun k => f (2 * k + 1)) = (fun k => (2 : ℂ) ^ (-s) * f k) from funext hterm]
    rw [tsum_mul_left]
  have htwo : (2 : ℂ) ^ (1 - s) = 2 * (2 : ℂ) ^ (-s) := by
    rw [show 1 - s = 1 + (-s) by ring,
      Complex.cpow_add (x := (2 : ℂ)) 1 (-s) (by norm_num), Complex.cpow_one]
  have hpairs : etaGrouped s = ∑' k, (f (2 * k) - f (2 * k + 1)) := by
    rw [etaGrouped]
    apply tsum_congr
    intro k
    simp only [pairTerm, f]
    rw [Complex.cpow_neg, Complex.cpow_neg]
    simp only [one_div]
  calc
    etaGrouped s = ∑' k, (f (2 * k) - f (2 * k + 1)) := hpairs
    _ = (∑' k, f (2 * k)) - ∑' k, f (2 * k + 1) := heven.tsum_sub hodd
    _ = (∑' n, f n) - 2 * ∑' k, f (2 * k + 1) := by
      rw [← hsplit]
      ring
    _ = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
      rw [hodd_tsum, hzeta, htwo]
      ring

/-- **The eta identity in the upper critical half-plane.**  On the convex
quadrant `Re z > 0`, `Im z > 0`, both sides are analytic and they agree on the
sub-quadrant `Re z > 1` by `etaGrouped_eq_one_sub_two_cpow_mul_zeta`.  The
identity theorem extends the agreement to the whole quadrant. -/
theorem etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_pos {s : ℂ}
    (hre : 0 < s.re) (him : 0 < s.im) :
    etaGrouped s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
  let U : Set ℂ := {z : ℂ | 0 < z.re ∧ 0 < z.im}
  have hUopen : IsOpen U :=
    (isOpen_lt continuous_const Complex.continuous_re).inter
      (isOpen_lt continuous_const Complex.continuous_im)
  have hUconn : IsPreconnected U :=
    ((convex_halfSpace_re_gt (0 : ℝ)).inter
      (convex_halfSpace_im_gt (0 : ℝ))).isPreconnected
  have hF : AnalyticOnNhd ℂ etaGrouped U := by
    apply DifferentiableOn.analyticOnNhd
    · intro z hz
      exact (differentiableAt_etaGrouped hz.1).differentiableWithinAt
    · exact hUopen
  have hG : AnalyticOnNhd ℂ
      (fun z : ℂ => (1 - (2 : ℂ) ^ (1 - z)) * riemannZeta z) U := by
    apply DifferentiableOn.analyticOnNhd
    · intro z hz
      have hz1 : z ≠ 1 := by
        intro h
        rw [h] at hz
        simp [U] at hz
      have harg : DifferentiableAt ℂ (fun y : ℂ => (1 : ℂ) - y) z := by fun_prop
      have hpow : DifferentiableAt ℂ (fun y : ℂ => (2 : ℂ) ^ (1 - y)) z :=
        harg.const_cpow (Or.inl (by norm_num : (2 : ℂ) ≠ 0))
      have hbase : DifferentiableAt ℂ (fun y : ℂ => (1 : ℂ) - (2 : ℂ) ^ (1 - y)) z :=
        (differentiableAt_const (c := (1 : ℂ))).sub hpow
      exact (hbase.mul (differentiableAt_riemannZeta hz1)).differentiableWithinAt
    · exact hUopen
  have hfg : etaGrouped =ᶠ[𝓝 (2 + Complex.I)]
      (fun z : ℂ => (1 - (2 : ℂ) ^ (1 - z)) * riemannZeta z) := by
    have hVopen : IsOpen {z : ℂ | 1 < z.re} :=
      isOpen_lt continuous_const Complex.continuous_re
    have hmem : ({z : ℂ | 1 < z.re} ∩ U) ∈ 𝓝 (2 + Complex.I) :=
      (hVopen.inter hUopen).mem_nhds (by
        refine ⟨?_, ?_⟩
        · simp
        · simp [U])
    filter_upwards [hmem] with z hz
    exact etaGrouped_eq_one_sub_two_cpow_mul_zeta hz.1
  have hEq := AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hF hG hUconn
    (show (2 + Complex.I) ∈ U by simp [U]) hfg
  exact hEq ⟨hre, him⟩

/-- **The eta identity in the lower critical half-plane.**  On the convex
quadrant `Re z > 0`, `Im z < 0`, both sides are analytic and they agree on the
sub-quadrant `Re z > 1` by `etaGrouped_eq_one_sub_two_cpow_mul_zeta`.  The
identity theorem extends the agreement to the whole quadrant. -/
theorem etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_neg {s : ℂ}
    (hre : 0 < s.re) (him : s.im < 0) :
    etaGrouped s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
  let U : Set ℂ := {z : ℂ | 0 < z.re ∧ z.im < 0}
  have hUopen : IsOpen U :=
    (isOpen_lt continuous_const Complex.continuous_re).inter
      (isOpen_lt Complex.continuous_im continuous_const)
  have hUconn : IsPreconnected U :=
    ((convex_halfSpace_re_gt (0 : ℝ)).inter
      (convex_halfSpace_im_lt (0 : ℝ))).isPreconnected
  have hF : AnalyticOnNhd ℂ etaGrouped U := by
    apply DifferentiableOn.analyticOnNhd
    · intro z hz
      exact (differentiableAt_etaGrouped hz.1).differentiableWithinAt
    · exact hUopen
  have hG : AnalyticOnNhd ℂ
      (fun z : ℂ => (1 - (2 : ℂ) ^ (1 - z)) * riemannZeta z) U := by
    apply DifferentiableOn.analyticOnNhd
    · intro z hz
      have hz1 : z ≠ 1 := by
        intro h
        rw [h] at hz
        simp [U] at hz
      have harg : DifferentiableAt ℂ (fun y : ℂ => (1 : ℂ) - y) z := by fun_prop
      have hpow : DifferentiableAt ℂ (fun y : ℂ => (2 : ℂ) ^ (1 - y)) z :=
        harg.const_cpow (Or.inl (by norm_num : (2 : ℂ) ≠ 0))
      have hbase : DifferentiableAt ℂ (fun y : ℂ => (1 : ℂ) - (2 : ℂ) ^ (1 - y)) z :=
        (differentiableAt_const (c := (1 : ℂ))).sub hpow
      exact (hbase.mul (differentiableAt_riemannZeta hz1)).differentiableWithinAt
    · exact hUopen
  have hfg : etaGrouped =ᶠ[𝓝 (2 - Complex.I)]
      (fun z : ℂ => (1 - (2 : ℂ) ^ (1 - z)) * riemannZeta z) := by
    have hVopen : IsOpen {z : ℂ | 1 < z.re} :=
      isOpen_lt continuous_const Complex.continuous_re
    have hmem : ({z : ℂ | 1 < z.re} ∩ U) ∈ 𝓝 (2 - Complex.I) :=
      (hVopen.inter hUopen).mem_nhds (by
        refine ⟨?_, ?_⟩
        · simp
        · simp [U])
    filter_upwards [hmem] with z hz
    exact etaGrouped_eq_one_sub_two_cpow_mul_zeta hz.1
  have hEq := AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hF hG hUconn
    (show (2 - Complex.I) ∈ U by simp [U]) hfg
  exact hEq ⟨hre, him⟩

/-- **The eta identity for `Re s > 0`, `s ≠ 1`.**  The two open half-planes are
handled by the identity theorem; the real axis is obtained by continuity from
`Im s = 1/(n+1) → 0`.  The point `s = 1` is excluded because `ζ` has a pole
there and the product has the removable value `log 2`, not `0`. -/
theorem etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos {s : ℂ}
    (hre : 0 < s.re) (hs1 : s ≠ 1) :
    etaGrouped s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
  rcases lt_trichotomy s.im 0 with hneg | hzero | hpos
  · exact etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_neg hre hneg
  · -- real axis: continuity from above
    let seq : ℕ → ℂ := fun n => s + (((1 : ℝ) / (n + 1) : ℝ) : ℂ) * Complex.I
    have hseq : Tendsto seq atTop (𝓝 s) := by
      have h0 : Tendsto (fun n : ℕ => ((1 : ℝ) / (n + 1) : ℝ)) atTop (𝓝 0) :=
        tendsto_one_div_add_atTop_nhds_zero_nat
      have h1 : Tendsto (fun n : ℕ => (((1 : ℝ) / (n + 1) : ℝ) : ℂ) * Complex.I)
          atTop (𝓝 (0 * Complex.I)) :=
        h0.ofReal.mul tendsto_const_nhds
      simpa [seq] using tendsto_const_nhds.add h1
    have hleft : Tendsto (fun n => etaGrouped (seq n)) atTop (𝓝 (etaGrouped s)) :=
      (differentiableAt_etaGrouped hre).continuousAt.tendsto.comp hseq
    have hcont : ContinuousAt (fun z : ℂ => (1 - (2 : ℂ) ^ (1 - z)) * riemannZeta z) s := by
      have harg : ContinuousAt (fun z : ℂ => (1 : ℂ) - z) s := by fun_prop
      have hpow : ContinuousAt (fun z : ℂ => (2 : ℂ) ^ (1 - z)) s :=
        (continuousAt_const_cpow (by norm_num : (2 : ℂ) ≠ 0)).comp harg
      have hbase : ContinuousAt (fun z : ℂ => (1 : ℂ) - (2 : ℂ) ^ (1 - z)) s :=
        continuousAt_const.sub hpow
      exact hbase.mul (differentiableAt_riemannZeta hs1).continuousAt
    have hright : Tendsto (fun n => (1 - (2 : ℂ) ^ (1 - seq n)) * riemannZeta (seq n))
        atTop (𝓝 ((1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s)) :=
      hcont.tendsto.comp hseq
    have heq_seq : (fun n => etaGrouped (seq n)) =
        (fun n => (1 - (2 : ℂ) ^ (1 - seq n)) * riemannZeta (seq n)) := by
      funext n
      apply etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_pos
      · show 0 < (seq n).re
        dsimp [seq]
        simp [Complex.add_re]
        exact hre
      · have hpos : (0 : ℝ) < (1 : ℝ) / (n + 1) := by positivity
        have him : (seq n).im = (1 : ℝ) / (n + 1) := by
          dsimp [seq]
          simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
            Complex.I_re, Complex.I_im, hzero, mul_zero, zero_mul, add_zero]
          ring
        rw [him]
        exact hpos
    rw [heq_seq] at hleft
    exact tendsto_nhds_unique hleft hright
  · exact etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_im_pos hre hpos

/-- **Transfer to `ζ`.**  On `0 < Re s`, `s ≠ 1`, nonvanishing of the grouped
eta series implies nonvanishing of `ζ`.  This is the logical step P3 needs; the
numerical premise is still `etaGrouped s ≠ 0`, to be discharged by a Lean
enclosure certificate. -/
theorem zeta_ne_zero_of_eta_ne_zero {s : ℂ} (hre : 0 < s.re) (hs1 : s ≠ 1)
    (heta : etaGrouped s ≠ 0) : riemannZeta s ≠ 0 := by
  intro hz
  apply heta
  rw [etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos hre hs1, hz, mul_zero]

/-- The same transfer, phrased for a set that contains `etaGrouped s` and
excludes zero (the shape of an enclosure certificate). -/
theorem zeta_ne_zero_of_eta_mem {s : ℂ} (hre : 0 < s.re) (hs1 : s ≠ 1)
    {U : Set ℂ} (hU : etaGrouped s ∈ U) (h0 : (0 : ℂ) ∉ U) :
    riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_eta_ne_zero hre hs1 fun h => h0 (h ▸ hU)

/-! ## Tail bound for the pair majorant -/

/-- Shift integrability from `Ioi (a+M)` to `Ioi M`. -/
lemma integrableOn_Ioi_comp_add_left' {E : Type*} [NormedAddCommGroup E] {f : ℝ → E} {a M : ℝ}
    (h : IntegrableOn f (Set.Ioi (a + M))) :
    IntegrableOn (fun x : ℝ => f (a + x)) (Set.Ioi M) := by
  rw [IntegrableOn] at h ⊢
  have hmap : Measure.map (fun x : ℝ => a + x) volume = volume :=
    MeasureTheory.map_add_left_eq_self volume a
  have hpre : (fun x : ℝ => a + x) ⁻¹' Set.Ioi (a + M) = Set.Ioi M := by
    ext x; simp
  rw [← hmap] at h
  rw [(measurableEmbedding_addLeft a).restrict_map volume (Set.Ioi (a + M)), hpre] at h
  exact (measurableEmbedding_addLeft a).integrable_map_iff.mp h

/-- The majorant `x ↦ (2x+c)^{-p}` is integrable on `Ioi 0` for `p > 1`, `c > 0`. -/
lemma integrableOn_pairMajorant {p c : ℝ} (hp : 1 < p) (hc : 0 < c) :
    IntegrableOn (fun x : ℝ => (2 * x + c) ^ (-p)) (Set.Ioi 0) := by
  have hg : IntegrableOn (fun y : ℝ => (2 * y) ^ (-p)) (Set.Ioi (c / 2)) := by
    have hy : IntegrableOn (fun y : ℝ => y ^ (-p)) (Set.Ioi (c / 2)) :=
      integrableOn_Ioi_rpow_of_lt (by linarith) (by positivity)
    have hc' : IntegrableOn (fun y : ℝ => (2 : ℝ) ^ (-p) * y ^ (-p)) (Set.Ioi (c / 2)) :=
      hy.const_mul _
    refine hc'.congr ?_
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
    have hy0 : 0 ≤ y := le_of_lt (lt_trans (by positivity : (0:ℝ) < c/2) hy)
    rw [Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) hy0]
  have hshift := integrableOn_Ioi_comp_add_left' (f := fun y : ℝ => (2 * y) ^ (-p))
    (a := c / 2) (M := 0) (by simpa using hg)
  refine hshift.congr ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
  congr 2
  ring

/-- The antiderivative of `x ↦ (2x+c)^{-p}`. -/
def pairMajorantAnti (p c x : ℝ) : ℝ :=
  -((2 * x + c) ^ (1 - p)) / (2 * (p - 1))

lemma hasDerivAt_pairMajorantAnti {p c x : ℝ} (hp : 1 < p) (hx : 0 < 2 * x + c) :
    HasDerivAt (pairMajorantAnti p c) ((2 * x + c) ^ (-p)) x := by
  have hbase : HasDerivAt (fun y : ℝ => 2 * y + c) 2 x := by
    simpa using ((hasDerivAt_id x).const_mul (2 : ℝ)).const_add c
  have hpow : HasDerivAt (fun y : ℝ => (2 * y + c) ^ (1 - p))
      ((1 - p) * (2 * x + c) ^ ((1 - p) - 1) * 2) x := by
    simpa [show (1 - p) - 1 = -p by ring, mul_comm, mul_left_comm, mul_assoc]
      using hbase.rpow_const (p := 1 - p) (Or.inl (ne_of_gt hx))
  have hp1 : p - 1 ≠ 0 := by linarith
  have h := hpow.const_mul (-(1 / (2 * (p - 1))))
  have hderiv : (-(1 / (2 * (p - 1)))) *
      ((1 - p) * (2 * x + c) ^ ((1 - p) - 1) * 2) = (2 * x + c) ^ (-p) := by
    rw [show (1 - p) - 1 = -p by ring]
    field_simp [hp1]
    ring
  rw [hderiv] at h
  convert h using 1
  · ext y
    simp only [pairMajorantAnti]
    field_simp [hp1]

lemma tendsto_pairMajorantAnti_atTop {p c : ℝ} (hp : 1 < p) (hc : 0 < c) :
    Tendsto (pairMajorantAnti p c) atTop (𝓝 0) := by
  have hshift : Tendsto (fun x : ℝ => 2 * x + c) atTop atTop := by
    apply tendsto_atTop_add_const_right
    exact tendsto_id.const_mul_atTop (by norm_num : (0:ℝ) < 2)
  have hr : Tendsto (fun x : ℝ => (2 * x + c) ^ (1 - p)) atTop (𝓝 0) := by
    have h := (tendsto_rpow_neg_atTop (by linarith : (0:ℝ) < p - 1)).comp hshift
    refine h.congr' ?_
    filter_upwards [eventually_gt_atTop (0:ℝ)] with x hx
    rw [show 1 - p = -(p - 1) by ring]
    rfl
  have hconst : Tendsto (fun x : ℝ => -((2 * x + c) ^ (1 - p)) / (2 * (p - 1))) atTop (𝓝 0) := by
    simpa using hr.neg.div_const (2 * (p - 1))
  change Tendsto (fun x : ℝ => -((2 * x + c) ^ (1 - p)) / (2 * (p - 1))) atTop (𝓝 0)
  exact hconst

/-- The integral of the majorant. -/
lemma integral_Ioi_pairMajorant {p c : ℝ} (hp : 1 < p) (hc : 0 < c) :
    ∫ x : ℝ in Set.Ioi 0, (2 * x + c) ^ (-p) = c ^ (1 - p) / (2 * (p - 1)) := by
  have hcont : ContinuousWithinAt (pairMajorantAnti p c) (Set.Ici 0) 0 := by
    have hbase : ContinuousWithinAt (fun x : ℝ => 2 * x + c) (Set.Ici 0) 0 := by fun_prop
    have hpow : ContinuousWithinAt (fun x : ℝ => (2 * x + c) ^ (1 - p)) (Set.Ici 0) 0 :=
      hbase.rpow_const (Or.inl (ne_of_gt (by positivity : (0:ℝ) < 2 * 0 + c)))
    change ContinuousWithinAt (fun x : ℝ => -((2 * x + c) ^ (1 - p)) / (2 * (p - 1)))
      (Set.Ici 0) 0
    exact hpow.neg.div_const (2 * (p - 1))
  have hderiv : ∀ x ∈ Set.Ioi (0:ℝ),
      HasDerivAt (pairMajorantAnti p c) ((2 * x + c) ^ (-p)) x := by
    intro x hx
    apply hasDerivAt_pairMajorantAnti hp
    rw [Set.mem_Ioi] at hx
    positivity
  have hint : IntegrableOn (fun x : ℝ => (2 * x + c) ^ (-p)) (Set.Ioi 0) :=
    integrableOn_pairMajorant hp hc
  have hlim : Tendsto (pairMajorantAnti p c) atTop (𝓝 0) :=
    tendsto_pairMajorantAnti_atTop hp hc
  have h := integral_Ioi_of_hasDerivAt_of_tendsto (a := (0:ℝ))
    (f := pairMajorantAnti p c) (f' := fun x : ℝ => (2 * x + c) ^ (-p))
    (m := 0) hcont hderiv hint hlim
  rw [h]
  simp [pairMajorantAnti]
  field_simp

/-- **Tail bound for the pair majorant.**  For `p > 1` and `M ≥ 0`,

`Σ_{m≥0} (2(m+M)+1)^{-p} ≤ (2M+1)^{-p} + (2M+1)^{1-p}/(2(p-1))`.

This is the decreasing-sum/integral comparison used by the enclosure certificate. -/
theorem tsum_pairMajorant_add_le {p : ℝ} (hp : 1 < p) (M : ℕ) :
    ∑' m : ℕ, (((2 * (m + M) + 1 : ℕ) : ℝ) ^ (-p)) ≤
      (((2 * M + 1 : ℕ) : ℝ) ^ (-p)) +
        (((2 * M + 1 : ℕ) : ℝ) ^ (1 - p)) / (2 * (p - 1)) := by
  let c : ℝ := ((2 * M + 1 : ℕ) : ℝ)
  have hc : 0 < c := by positivity
  let f : ℝ → ℝ := fun x => (2 * x + c) ^ (-p)
  have hanti : AntitoneOn f (Set.Ici (0 : ℝ)) := by
    intro x hx y hy hxy
    have hbx : 0 < 2 * x + c := by
      have : (0 : ℝ) ≤ x := hx
      positivity
    have hle : 2 * x + c ≤ 2 * y + c := by linarith
    exact Real.rpow_le_rpow_of_nonpos hbx hle (by linarith : -p ≤ 0)
  have hint : IntegrableOn f (Set.Ioi (0 : ℝ)) := integrableOn_pairMajorant hp hc
  have hnonneg : ∀ t ∈ Set.Ioi (0 : ℝ), 0 ≤ f t := by
    intro t ht
    have ht0 : (0 : ℝ) ≤ t := le_of_lt ht
    exact Real.rpow_nonneg (by positivity) _
  have h := AntitoneOn.tsum_le_integral hanti hint hnonneg
  have hf0 : f 0 = c ^ (-p) := by simp [f]
  have hintval : ∫ x : ℝ in Set.Ioi 0, f x = c ^ (1 - p) / (2 * (p - 1)) :=
    integral_Ioi_pairMajorant hp hc
  rw [hintval, hf0] at h
  convert h using 1
  · apply tsum_congr
    intro m
    simp only [f, c]
    push_cast
    ring

/-- **Norm tail bound for the grouped eta series.**  After `M` pairs, the
remaining tail is bounded by `‖s‖` times the rational majorant
`(2M+1)^{-σ-1} + (2M+1)^{-σ}/(2σ)`, `σ = Re s`. -/
theorem norm_tsum_pairTerm_tail_le {s : ℂ} (hσ : 0 < s.re) (M : ℕ) :
    ‖∑' m : ℕ, pairTerm s (m + M)‖ ≤
      ‖s‖ * ((((2 * M + 1 : ℕ) : ℝ) ^ (-s.re - 1)) +
        ((((2 * M + 1 : ℕ) : ℝ) ^ (-s.re)) / (2 * s.re))) := by
  have hs : Summable (fun m : ℕ => pairTerm s (m + M)) :=
    (summable_nat_add_iff M).2 (summable_pairTerm hσ)
  have hmaj : Summable (fun m : ℕ =>
      ‖s‖ * ((((2 * (m + M) + 1 : ℕ) : ℝ) ^ (-s.re - 1)))) :=
    (summable_pairMajorant' hσ).comp_injective (by
      intro a b hab
      exact Nat.add_right_cancel hab) |>.mul_left ‖s‖
  have hnorm : ‖∑' m : ℕ, pairTerm s (m + M)‖ ≤
      ∑' m : ℕ, ‖pairTerm s (m + M)‖ :=
    norm_tsum_le_tsum_norm hs.norm
  have hle : ∑' m : ℕ, ‖pairTerm s (m + M)‖ ≤
      ∑' m : ℕ, ‖s‖ * ((((2 * (m + M) + 1 : ℕ) : ℝ) ^ (-s.re - 1))) :=
    hs.norm.tsum_le_tsum (fun m => norm_pairTerm_le hσ le_rfl (m + M)) hmaj
  have htail := tsum_pairMajorant_add_le (p := s.re + 1) (by linarith) M
  have hcast : (∑' m : ℕ, ‖s‖ * ((((2 * (m + M) + 1 : ℕ) : ℝ) ^ (-s.re - 1)))) =
      ‖s‖ * ∑' m : ℕ, ((((2 * (m + M) + 1 : ℕ) : ℝ) ^ (-s.re - 1))) :=
    tsum_mul_left
  rw [hcast] at hle
  refine hnorm.trans (hle.trans ?_)
  have hσpos : (0 : ℝ) < s.re := hσ
  have htail' : ∑' m : ℕ, ((((2 * (m + M) + 1 : ℕ) : ℝ) ^ (-s.re - 1))) ≤
      ((((2 * M + 1 : ℕ) : ℝ) ^ (-s.re - 1)) +
        ((((2 * M + 1 : ℕ) : ℝ) ^ (1 - (s.re + 1))) / (2 * (s.re + 1 - 1)))) := by
    simpa [show -(s.re + 1) = -s.re - 1 by ring] using
      tsum_pairMajorant_add_le (p := s.re + 1) (by linarith) M
  have hsimp : (1 - (s.re + 1)) = -s.re := by ring
  have hden : (2 * (s.re + 1 - 1)) = 2 * s.re := by ring
  rw [hsimp, hden] at htail'
  exact mul_le_mul_of_nonneg_left htail' (norm_nonneg s)

end FiniteWindowZeros