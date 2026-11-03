import EMCritical
import Hadamard

/-!
# Bounds for `ζ` in the critical strip

Uses the exact Euler--Maclaurin expansion from the `finite-window-zeros` topic
(`zetaEM`, `zetaEMGen`, `zetaEMRemainder` and the `B_{2K}` remainder bound
`norm_zetaEMRemainder_le_of_re_pos`) to bound `ζ` on the pole-free part of the
critical strip — an exact-analytic alternative to the approximate functional
equation.

Strategy (A): extend the exact Euler--Maclaurin identity `ζ = zetaEM N` from
`1 < Re s` to the punctured half-plane `0 < Re s ∧ Im s ≠ 0` by applying the
identity theorem on a small horizontal strip, then use the `K = 1`
Euler--Maclaurin expansion and the `B₂` remainder bound.

**No RH proof yet.**
-/

namespace AbsoluteHodgeZetaStrip

open Filter Topology
open FiniteWindowZeros
open AbsoluteHodgeHadamard
open AbsoluteHodgeSymbol
open Complex

/-- The Euler--Maclaurin identity extends to the half-plane `Re s > 0` away from
the real axis, by the identity theorem on a horizontal strip. -/
theorem strip_zeta_eq_zetaEM_of_re_pos_of_im_ne_zero {s : ℂ} (hre : 0 < s.re)
    (him : s.im ≠ 0) (N : ℕ) : riemannZeta s = zetaEM N s := by
  set V : Set ℂ :=
    {z : ℂ | 0 < z.re} ∩ {z : ℂ | s.im - |s.im| / 2 < z.im} ∩
      {z : ℂ | z.im < s.im + |s.im| / 2} with hV
  have hmem : ∀ z : ℂ, z ∈ V ↔
      0 < z.re ∧ (s.im - |s.im| / 2 < z.im ∧ z.im < s.im + |s.im| / 2) := by
    intro z
    simp [hV, and_assoc]
  have hVopen : IsOpen V := by
    rw [hV]
    exact ((isOpen_lt continuous_const Complex.continuous_re).inter
      (isOpen_lt continuous_const Complex.continuous_im)).inter
      (isOpen_lt Complex.continuous_im continuous_const)
  have hVconv : Convex ℝ V := by
    rw [hV]
    exact ((convex_halfSpace_re_gt 0).inter (convex_halfSpace_im_gt _)).inter
      (convex_halfSpace_im_lt _)
  -- no point of the strip lies on the real axis
  have hsign : ∀ z : ℂ, s.im - |s.im| / 2 < z.im →
      z.im < s.im + |s.im| / 2 → z.im ≠ 0 := by
    intro z h1 h2 h0
    rcases lt_or_gt_of_ne him with hneg | hpos
    · have hc : |s.im| = -s.im := abs_of_neg hneg
      rw [hc, h0] at h2
      linarith
    · have hc : |s.im| = s.im := abs_of_pos hpos
      rw [hc, h0] at h1
      linarith
  have hsV : s ∈ V := by
    rw [hmem]
    refine ⟨hre, ?_, ?_⟩ <;> (have h : (0 : ℝ) < |s.im| := abs_pos.mpr him; linarith)
  have hζdiff : DifferentiableOn ℂ riemannZeta V := by
    intro z hz
    obtain ⟨hzre, hz1, hz2⟩ := (hmem z).1 hz
    have hzne : z ≠ 1 := by
      intro h
      subst h
      exact hsign 1 hz1 hz2 (by simp)
    exact (differentiableAt_riemannZeta hzne).differentiableWithinAt
  have hzdiff : DifferentiableOn ℂ (zetaEM N) V := by
    apply (differentiableOn_zetaEM N).mono
    intro z hz
    obtain ⟨hzre, hz1, hz2⟩ := (hmem z).1 hz
    refine ⟨hzre, ?_⟩
    intro h
    subst h
    exact hsign 1 hz1 hz2 (by simp)
  -- a point of the strip with `Re > 1`, where both sides are known to agree
  let p : ℂ := ⟨2, s.im⟩
  have hpV : p ∈ V := by
    rw [hmem]
    change 0 < (2 : ℝ) ∧
      (s.im - |s.im| / 2 < s.im ∧ s.im < s.im + |s.im| / 2)
    refine ⟨by norm_num, ?_, ?_⟩ <;> (have h : (0 : ℝ) < |s.im| := abs_pos.mpr him; linarith)
  have hpre : 1 < p.re := by
    change 1 < (2 : ℝ)
    norm_num
  have hevent : riemannZeta =ᶠ[𝓝 p] zetaEM N := by
    filter_upwards [(isOpen_lt continuous_const Complex.continuous_re).mem_nhds hpre]
      with z hz
    exact zeta_eq_zetaEM_of_one_lt hz N
  have hζan : AnalyticOnNhd ℂ riemannZeta V := hζdiff.analyticOnNhd hVopen
  have hzan : AnalyticOnNhd ℂ (zetaEM N) V := hzdiff.analyticOnNhd hVopen
  exact (hζan.eqOn_of_preconnected_of_eventuallyEq hzan hVconv.isPreconnected hpV
    hevent) hsV

/-- Crude bound for the `K = 1` main term on `1/2 ≤ Re s ≤ 1`. -/
theorem strip_norm_zetaEMGen_one_le (N : ℕ) (s : ℂ) (hσ1 : (1 / 2 : ℝ) ≤ s.re)
    (hσ2 : s.re ≤ 1) (hx : 2 ≤ ‖s‖) (hN : 1 ≤ N) :
    ‖zetaEMGen 1 N s‖ ≤ 3 * ((N : ℝ) + 1) + ‖s‖ / 12 := by
  rw [zetaEMGen_one]
  have hsum : ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))‖ ≤
      (N : ℝ) := by
    calc ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))‖
        ≤ ∑ n ∈ Finset.range N, ‖((((n + 1 : ℝ) : ℂ) ^ (-s)))‖ := norm_sum_le _ _
      _ ≤ ∑ n ∈ Finset.range N, (1 : ℝ) := by
          apply Finset.sum_le_sum
          intro n _
          have hx1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
          rw [norm_cpow_neg_ofReal hx1]
          exact Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
      _ = (N : ℝ) := by simp
  have hpole : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1)‖ ≤ (N : ℝ) + 1 := by
    have hxpos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
    have hden : (1 : ℝ) ≤ ‖s - 1‖ := by
      have h := norm_sub_norm_le s (1 : ℂ)
      have h1 : ‖(1 : ℂ)‖ = 1 := by simp
      rw [h1] at h
      linarith
    have hdenpos : (0 : ℝ) < ‖s - 1‖ := lt_of_lt_of_le zero_lt_one hden
    rw [norm_div]
    have hnum : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s))‖ =
        ((N : ℝ) + 1) ^ (1 - s.re) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
      have h1 : (1 - s).re = 1 - s.re := by simp
      rw [h1]
    rw [hnum, div_le_iff₀ hdenpos]
    have hle : ((N : ℝ) + 1) ^ (1 - s.re) ≤ (N : ℝ) + 1 :=
      Real.rpow_le_self_of_one_le (by linarith) (by linarith)
    calc ((N : ℝ) + 1) ^ (1 - s.re) ≤ (N : ℝ) + 1 := hle
      _ = ((N : ℝ) + 1) * 1 := by ring
      _ ≤ ((N : ℝ) + 1) * ‖s - 1‖ := mul_le_mul_of_nonneg_left hden (by positivity)
  have hshift : ‖emGShift s N 0 0 / 2‖ ≤ 1 / 2 := by
    have hval : emGShift s N 0 0 = ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-s) := by
      simp [emGShift, descPochhammer]
    rw [hval, norm_div]
    have hxpos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
    have hnorm : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-s))‖ = ((N : ℝ) + 1) ^ (-s.re) :=
      norm_cpow_neg_ofReal hxpos
    rw [hnorm]
    have hle : ((N : ℝ) + 1) ^ (-s.re) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
    have h2 : ‖(2 : ℂ)‖ = 2 := by norm_num
    rw [h2]
    linarith
  have hbase : ‖zetaBase N s‖ ≤ (N : ℝ) + ((N : ℝ) + 1) + 1 / 2 := by
    rw [zetaBase]
    calc ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))) +
          (((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1) + emGShift s N 0 0 / 2‖
        ≤ ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))) +
            (((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1)‖ +
            ‖emGShift s N 0 0 / 2‖ := norm_add_le _ _
      _ ≤ (‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))‖ +
            ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1)‖) +
            ‖emGShift s N 0 0 / 2‖ := by
          have h := norm_add_le
            (Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))))
            ((((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1))
          linarith
      _ ≤ (N : ℝ) + ((N : ℝ) + 1) + 1 / 2 := by linarith
  have hextra : ‖(1 / 12 : ℂ) * s * ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1))‖ ≤
      ‖s‖ / 12 := by
    have hxpos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
    have hnorm : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1)))‖ =
        ((N : ℝ) + 1) ^ (-(s + 1)).re :=
      Complex.norm_cpow_eq_rpow_re_of_pos hxpos (-(s + 1))
    have hexp : (-(s + 1)).re = -s.re - 1 := by
      simp
      ring
    rw [norm_mul, norm_mul, hnorm, hexp]
    have hnorm12 : ‖(1 / 12 : ℂ)‖ = 1 / 12 := by norm_num
    rw [hnorm12]
    have hle : ((N : ℝ) + 1) ^ (-s.re - 1) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
    have h2 : ((N : ℝ) + 1) ^ (-s.re - 1) * ‖s‖ ≤ 1 * ‖s‖ :=
      mul_le_mul_of_nonneg_right hle (norm_nonneg s)
    nlinarith
  calc ‖zetaBase N s + (1 / 12 : ℂ) * s * ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1))‖
      ≤ ‖zetaBase N s‖ +
        ‖(1 / 12 : ℂ) * s * ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1))‖ := norm_add_le _ _
    _ ≤ ((N : ℝ) + ((N : ℝ) + 1) + 1 / 2) + ‖s‖ / 12 := add_le_add hbase hextra
    _ ≤ 3 * ((N : ℝ) + 1) + ‖s‖ / 12 := by
        have hN0 : (0 : ℝ) ≤ (N : ℝ) := by positivity
        linarith

/-- The `K = 1` remainder is bounded by a quadratic polynomial. -/
theorem strip_norm_zetaEMRemainder_one_le (N : ℕ) (s : ℂ) (hσ : 0 < s.re) :
    ‖zetaEMRemainder 1 N s‖ ≤ (1 / 6) * ‖s‖ * (‖s‖ + 1) := by
  have h := norm_zetaEMRemainder_le_of_re_pos 1 N (by norm_num) s hσ
  have hp : (descPochhammer ℂ (2 * 1)).eval (-s) = s * (s + 1) := by
    simp [descPochhammer]
    ring
  have hζ2 : (riemannZeta (((2 * 1 : ℕ) : ℂ))).re = Real.pi ^ 2 / 6 := by
    have h1 : (((2 * 1 : ℕ) : ℂ)) = (2 : ℂ) := by norm_num
    have hcast : ((Real.pi : ℂ) ^ 2 / 6) = ((Real.pi ^ 2 / 6 : ℝ) : ℂ) := by
      push_cast
      ring
    rw [h1, riemannZeta_two, hcast, Complex.ofReal_re]
  have hC : 2 * (riemannZeta (((2 * 1 : ℕ) : ℂ))).re / (2 * Real.pi) ^ (2 * 1) = 1 / 12 := by
    rw [hζ2]
    have hpne : Real.pi ≠ 0 := Real.pi_ne_zero
    have hsq : (2 * Real.pi) ^ (2 * 1) = 4 * Real.pi ^ 2 := by
      rw [show (2 * 1 : ℕ) = 2 from rfl]
      ring
    rw [hsq]
    field_simp
    ring
  have hbracket : ((N : ℝ) + 1) ^ (-s.re - ((2 * 1 : ℕ) : ℝ)) +
      ((N : ℝ) + 1) ^ (1 - s.re - ((2 * 1 : ℕ) : ℝ)) / (s.re + ((2 * 1 : ℕ) : ℝ) - 1) ≤ 2 := by
    have h2 : (((2 * 1 : ℕ) : ℝ)) = 2 := by norm_num
    rw [h2]
    have hbase : (1 : ℝ) ≤ (N : ℝ) + 1 := by
      have hN0 : (0 : ℝ) ≤ (N : ℝ) := by positivity
      linarith
    have ht1 : ((N : ℝ) + 1) ^ (-s.re - 2) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos hbase (by linarith)
    have ht2 : ((N : ℝ) + 1) ^ (1 - s.re - 2) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos hbase (by linarith)
    have hden : (1 : ℝ) ≤ s.re + 2 - 1 := by linarith
    have ht2' : ((N : ℝ) + 1) ^ (1 - s.re - 2) / (s.re + 2 - 1) ≤ 1 := by
      rw [div_le_iff₀ (by linarith : (0 : ℝ) < s.re + 2 - 1)]
      calc ((N : ℝ) + 1) ^ (1 - s.re - 2) ≤ 1 := ht2
        _ ≤ 1 * (s.re + 2 - 1) := by linarith
    linarith
  have hnormp : ‖(descPochhammer ℂ (2 * 1)).eval (-s)‖ ≤ ‖s‖ * (‖s‖ + 1) := by
    rw [hp, norm_mul]
    have h1 : ‖s + 1‖ ≤ ‖s‖ + 1 := by
      calc ‖s + 1‖ ≤ ‖s‖ + ‖(1 : ℂ)‖ := norm_add_le _ _
        _ = ‖s‖ + 1 := by norm_num
    have h2 : ‖s‖ * ‖s + 1‖ ≤ ‖s‖ * (‖s‖ + 1) :=
      mul_le_mul_of_nonneg_left h1 (norm_nonneg s)
    linarith
  have hnormp' : ‖Polynomial.eval (-s) (descPochhammer ℂ (2 * 1))‖ ≤ ‖s‖ * (‖s‖ + 1) :=
    hnormp
  calc ‖zetaEMRemainder 1 N s‖
      ≤ (2 * (riemannZeta (((2 * 1 : ℕ) : ℂ))).re / (2 * Real.pi) ^ (2 * 1)) *
          ‖Polynomial.eval (-s) (descPochhammer ℂ (2 * 1))‖ *
          (((N : ℝ) + 1) ^ (-s.re - ((2 * 1 : ℕ) : ℝ)) +
            ((N : ℝ) + 1) ^ (1 - s.re - ((2 * 1 : ℕ) : ℝ)) /
              (s.re + ((2 * 1 : ℕ) : ℝ) - 1)) := h
    _ ≤ (1 / 12) * (‖s‖ * (‖s‖ + 1)) * 2 := by
        rw [hC]
        have hB : (0 : ℝ) ≤ ((N : ℝ) + 1) ^ (-s.re - ((2 * 1 : ℕ) : ℝ)) +
            ((N : ℝ) + 1) ^ (1 - s.re - ((2 * 1 : ℕ) : ℝ)) /
              (s.re + ((2 * 1 : ℕ) : ℝ) - 1) := by
          have h1 : (0 : ℝ) ≤ ((N : ℝ) + 1) ^ (-s.re - ((2 * 1 : ℕ) : ℝ)) :=
            Real.rpow_nonneg (by positivity) _
          have h2 : (0 : ℝ) ≤ ((N : ℝ) + 1) ^ (1 - s.re - ((2 * 1 : ℕ) : ℝ)) :=
            Real.rpow_nonneg (by positivity) _
          have h3 : (0 : ℝ) ≤ s.re + ((2 * 1 : ℕ) : ℝ) - 1 := by
            have h2' : (((2 * 1 : ℕ) : ℝ)) = 2 := by norm_num
            linarith
          exact add_nonneg h1 (div_nonneg h2 h3)
        have hX : (0 : ℝ) ≤ ‖s‖ * (‖s‖ + 1) := by positivity
        have hmul : ‖Polynomial.eval (-s) (descPochhammer ℂ (2 * 1))‖ *
            (((N : ℝ) + 1) ^ (-s.re - ((2 * 1 : ℕ) : ℝ)) +
              ((N : ℝ) + 1) ^ (1 - s.re - ((2 * 1 : ℕ) : ℝ)) /
                (s.re + ((2 * 1 : ℕ) : ℝ) - 1)) ≤
            (‖s‖ * (‖s‖ + 1)) * 2 := mul_le_mul hnormp' hbracket hB hX
        nlinarith [hmul]
    _ = (1 / 6) * ‖s‖ * (‖s‖ + 1) := by ring

set_option maxHeartbeats 2000000 in
/-- Polynomial growth of `ζ` on the pole-free part of the critical strip. -/
theorem exists_bound_norm_zeta_strip_polefree :
    ∃ A : ℝ, 0 ≤ A ∧ ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re → s.re ≤ 1 →
      2 ≤ ‖s‖ → ‖riemannZeta s‖ ≤ A * (‖s‖ + 2) ^ 2 := by
  refine ⟨5, by norm_num, ?_⟩
  intro s hσ1 hσ2 hx
  have hσpos : 0 < s.re := by linarith
  have him : s.im ≠ 0 := by
    intro h0
    have hsq : ‖s‖ ^ 2 = s.re ^ 2 + s.im ^ 2 := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      ring
    rw [h0] at hsq
    nlinarith [norm_nonneg s]
  set N : ℕ := ⌈‖s‖⌉₊ with hNdef
  have hNpos : 0 < N := by
    rw [hNdef]
    exact Nat.ceil_pos.mpr (by linarith)
  have hN1 : 1 ≤ N := by omega
  have hNlt : (N : ℝ) < ‖s‖ + 1 := by
    rw [hNdef]
    exact Nat.ceil_lt_add_one (norm_nonneg s)
  have hNle : (N : ℝ) + 1 ≤ ‖s‖ + 2 := by linarith
  have hid : riemannZeta s = zetaEM N s :=
    strip_zeta_eq_zetaEM_of_re_pos_of_im_ne_zero hσpos him N
  have hgen := strip_norm_zetaEMGen_one_le N s hσ1 hσ2 hx hN1
  have hrem := strip_norm_zetaEMRemainder_one_le N s hσpos
  have hdecomp : zetaEM N s = zetaEMGen 1 N s + zetaEMRemainder 1 N s := by
    rw [zetaEMRemainder]
    ring
  calc ‖riemannZeta s‖ = ‖zetaEM N s‖ := by rw [hid]
    _ = ‖zetaEMGen 1 N s + zetaEMRemainder 1 N s‖ := by rw [hdecomp]
    _ ≤ ‖zetaEMGen 1 N s‖ + ‖zetaEMRemainder 1 N s‖ := norm_add_le _ _
    _ ≤ (3 * ((N : ℝ) + 1) + ‖s‖ / 12) + ((1 / 6) * ‖s‖ * (‖s‖ + 1)) :=
        add_le_add hgen hrem
    _ ≤ 5 * (‖s‖ + 2) ^ 2 := by nlinarith [hNle, hx, norm_nonneg s]

/-- The functional equation of `ξ₀`, in the strongest pointwise form. -/
theorem xi₀_one_sub (z : ℂ) : xi₀ (1 - z) = xi₀ z := by
  unfold xi₀
  rw [completedRiemannZeta₀_one_sub]
  ring

set_option maxHeartbeats 2000000 in
/-- Crude bound for the `K = 1` main term for `1/2 ≤ Re s` (no upper bound on
`Re s`: for `Re s > 1` the pole term only gets smaller). -/
theorem xigrowth_norm_zetaEMGen_one_le_gen (N : ℕ) (s : ℂ) (hσ1 : (1 / 2 : ℝ) ≤ s.re)
    (hx : 2 ≤ ‖s‖) (hN : 1 ≤ N) :
    ‖zetaEMGen 1 N s‖ ≤ 3 * ((N : ℝ) + 1) + ‖s‖ / 12 := by
  rw [zetaEMGen_one]
  have hsum : ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))‖ ≤
      (N : ℝ) := by
    calc ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))‖
        ≤ ∑ n ∈ Finset.range N, ‖((((n + 1 : ℝ) : ℂ) ^ (-s)))‖ := norm_sum_le _ _
      _ ≤ ∑ n ∈ Finset.range N, (1 : ℝ) := by
          apply Finset.sum_le_sum
          intro n _
          have hx1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
          rw [norm_cpow_neg_ofReal hx1]
          exact Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
      _ = (N : ℝ) := by simp
  have hpole : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1)‖ ≤ (N : ℝ) + 1 := by
    have hxpos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
    have hden : (1 : ℝ) ≤ ‖s - 1‖ := by
      have h := norm_sub_norm_le s (1 : ℂ)
      have h1 : ‖(1 : ℂ)‖ = 1 := by simp
      rw [h1] at h
      linarith
    have hdenpos : (0 : ℝ) < ‖s - 1‖ := lt_of_lt_of_le zero_lt_one hden
    rw [norm_div]
    have hnum : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s))‖ =
        ((N : ℝ) + 1) ^ (1 - s.re) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
      have h1 : (1 - s).re = 1 - s.re := by simp
      rw [h1]
    rw [hnum, div_le_iff₀ hdenpos]
    have hle : ((N : ℝ) + 1) ^ (1 - s.re) ≤ (N : ℝ) + 1 :=
      Real.rpow_le_self_of_one_le (by linarith) (by linarith)
    calc ((N : ℝ) + 1) ^ (1 - s.re) ≤ (N : ℝ) + 1 := hle
      _ = ((N : ℝ) + 1) * 1 := by ring
      _ ≤ ((N : ℝ) + 1) * ‖s - 1‖ := mul_le_mul_of_nonneg_left hden (by positivity)
  have hshift : ‖emGShift s N 0 0 / 2‖ ≤ 1 / 2 := by
    have hval : emGShift s N 0 0 = ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-s) := by
      simp [emGShift, descPochhammer]
    rw [hval, norm_div]
    have hxpos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
    have hnorm : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-s))‖ = ((N : ℝ) + 1) ^ (-s.re) :=
      norm_cpow_neg_ofReal hxpos
    rw [hnorm]
    have hle : ((N : ℝ) + 1) ^ (-s.re) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
    have h2 : ‖(2 : ℂ)‖ = 2 := by norm_num
    rw [h2]
    linarith
  have hbase : ‖zetaBase N s‖ ≤ (N : ℝ) + ((N : ℝ) + 1) + 1 / 2 := by
    rw [zetaBase]
    calc ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))) +
          (((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1) + emGShift s N 0 0 / 2‖
        ≤ ‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))) +
            (((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1)‖ +
            ‖emGShift s N 0 0 / 2‖ := norm_add_le _ _
      _ ≤ (‖Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))‖ +
            ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1)‖) +
            ‖emGShift s N 0 0 / 2‖ := by
          have h := norm_add_le
            (Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))))
            ((((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (1 - s)) / (s - 1))
          linarith
      _ ≤ (N : ℝ) + ((N : ℝ) + 1) + 1 / 2 := by linarith
  have hextra : ‖(1 / 12 : ℂ) * s * ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1))‖ ≤
      ‖s‖ / 12 := by
    have hxpos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
    have hnorm : ‖(((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1)))‖ =
        ((N : ℝ) + 1) ^ (-(s + 1)).re :=
      Complex.norm_cpow_eq_rpow_re_of_pos hxpos (-(s + 1))
    have hexp : (-(s + 1)).re = -s.re - 1 := by
      simp
      ring
    rw [norm_mul, norm_mul, hnorm, hexp]
    have hnorm12 : ‖(1 / 12 : ℂ)‖ = 1 / 12 := by norm_num
    rw [hnorm12]
    have hle : ((N : ℝ) + 1) ^ (-s.re - 1) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
    have h2 : ((N : ℝ) + 1) ^ (-s.re - 1) * ‖s‖ ≤ 1 * ‖s‖ :=
      mul_le_mul_of_nonneg_right hle (norm_nonneg s)
    nlinarith
  calc ‖zetaBase N s + (1 / 12 : ℂ) * s * ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1))‖
      ≤ ‖zetaBase N s‖ +
        ‖(1 / 12 : ℂ) * s * ((((N : ℝ) + 1 : ℝ)) : ℂ) ^ (-(s + 1))‖ := norm_add_le _ _
    _ ≤ ((N : ℝ) + ((N : ℝ) + 1) + 1 / 2) + ‖s‖ / 12 := add_le_add hbase hextra
    _ ≤ 3 * ((N : ℝ) + 1) + ‖s‖ / 12 := by
        have hN0 : (0 : ℝ) ≤ (N : ℝ) := by positivity
        linarith

set_option maxHeartbeats 2000000 in
/-- A quadratic bound for `ζ` on the whole half-plane `1/2 ≤ Re s`, away from
`‖s‖ < 2`. -/
theorem xigrowth_norm_riemannZeta_le_quadratic {s : ℂ} (hσ : (1 / 2 : ℝ) ≤ s.re)
    (hx : 2 ≤ ‖s‖) : ‖riemannZeta s‖ ≤ 5 * (‖s‖ + 2) ^ 2 := by
  rcases eq_or_ne s.im 0 with him | him
  · have hsq : ‖s‖ ^ 2 = s.re ^ 2 + s.im ^ 2 := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      ring
    rw [him] at hsq
    have hσ2 : 2 ≤ s.re := by
      nlinarith [hx, hsq, hσ, norm_nonneg s, sq_nonneg (s.re - 1)]
    have h1 : ‖riemannZeta s‖ ≤ 1 + 1 / (s.re - 1) :=
      norm_riemannZeta_le_one_add_inv_sub_one (by linarith)
    have h2 : 1 + 1 / (s.re - 1) ≤ 2 := by
      have h3 : (0:ℝ) < s.re - 1 := by linarith
      have h4 : 1 / (s.re - 1) ≤ 1 := by
        rw [div_le_one h3]
        linarith
      linarith
    have h3 : (2:ℝ) ≤ 5 * (‖s‖ + 2) ^ 2 := by
      have h4 : (4:ℝ) ≤ ‖s‖ + 2 := by linarith
      nlinarith [sq_nonneg (‖s‖ + 2)]
    linarith
  · have hσpos : 0 < s.re := by linarith
    set N : ℕ := ⌈‖s‖⌉₊ with hNdef
    have hNpos : 0 < N := by
      rw [hNdef]
      exact Nat.ceil_pos.mpr (by linarith)
    have hN1 : 1 ≤ N := by omega
    have hNle : (N : ℝ) + 1 ≤ ‖s‖ + 2 := by
      rw [hNdef]
      have := Nat.ceil_lt_add_one (norm_nonneg s)
      linarith
    have hid : riemannZeta s = zetaEM N s :=
      strip_zeta_eq_zetaEM_of_re_pos_of_im_ne_zero hσpos him N
    have hgen := xigrowth_norm_zetaEMGen_one_le_gen N s hσ hx hN1
    have hrem := strip_norm_zetaEMRemainder_one_le N s hσpos
    have hdecomp : zetaEM N s = zetaEMGen 1 N s + zetaEMRemainder 1 N s := by
      rw [zetaEMRemainder]
      ring
    calc ‖riemannZeta s‖ = ‖zetaEM N s‖ := by rw [hid]
      _ = ‖zetaEMGen 1 N s + zetaEMRemainder 1 N s‖ := by rw [hdecomp]
      _ ≤ ‖zetaEMGen 1 N s‖ + ‖zetaEMRemainder 1 N s‖ := norm_add_le _ _
      _ ≤ (3 * ((N : ℝ) + 1) + ‖s‖ / 12) + ((1 / 6) * ‖s‖ * (‖s‖ + 1)) :=
          add_le_add hgen hrem
      _ ≤ 5 * (‖s‖ + 2) ^ 2 := by nlinarith [hNle, hx, norm_nonneg s]

set_option maxHeartbeats 2000000 in
/-- Growth bound for `log ‖ξ₀‖` on the half-plane `Re z ≥ 1/2`, away from a
small ball. -/
theorem xigrowth_xi₀_growth_right (AΓ BΓ : ℝ) (hAΓ : 0 ≤ AΓ)
    (hΓb : ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re →
      Real.log ‖Complex.Gammaℝ s‖ ≤ AΓ * ‖s‖ * Real.log (‖s‖ + 2) + BΓ)
    {z : ℂ} (hz : 2 ≤ ‖z‖) (hre : (1 / 2 : ℝ) ≤ z.re) :
    Real.log ‖xi₀ z‖
      ≤ (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) + max (BΓ + Real.log 5) 0 := by
  have hz0 : z ≠ 0 := by
    intro h
    rw [h] at hz
    norm_num at hz
  have hz1 : z ≠ 1 := by
    intro h
    rw [h] at hz
    norm_num at hz
  have hΓne : Complex.Gammaℝ z ≠ 0 :=
    Complex.Gammaℝ_ne_zero_of_re_pos (by linarith)
  have hxi : xi₀ z = z * (z - 1) * (Complex.Gammaℝ z * riemannZeta z) := by
    rw [xi₀_eq_weighted z hz0 hz1]
    congr 1
    have h := completedZeta_eq_completedRiemannZeta (s := z) hz0 hz1 hΓne
    rw [← h]
    have hπ : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
    have hc : cexp (-(z / 2) * log (Real.pi : ℂ)) = (Real.pi : ℂ) ^ (-z / 2) := by
      rw [Complex.cpow_def, ite_eq_right hπ]
      congr 1
      ring
    unfold completedZeta
    rw [hc, Complex.Gammaℝ_def]
  have hnorm : ‖xi₀ z‖ = ‖z‖ * ‖z - 1‖ * ‖Complex.Gammaℝ z‖ * ‖riemannZeta z‖ := by
    rw [hxi, norm_mul, norm_mul, norm_mul]
    ring
  have hL : 0 ≤ Real.log (‖z‖ + 2) := Real.log_nonneg (by linarith [norm_nonneg z])
  have hzL : (1:ℝ) ≤ ‖z‖ := by linarith
  have hlogz : Real.log ‖z‖ ≤ ‖z‖ * Real.log (‖z‖ + 2) := by
    have h1 : Real.log ‖z‖ ≤ Real.log (‖z‖ + 2) :=
      Real.log_le_log (by linarith) (by linarith)
    have h2 : Real.log (‖z‖ + 2) ≤ ‖z‖ * Real.log (‖z‖ + 2) := by
      have h3 := mul_le_mul_of_nonneg_right hzL hL
      simpa using h3
    linarith
  have hlogz1 : Real.log ‖z - 1‖ ≤ ‖z‖ * Real.log (‖z‖ + 2) := by
    have hle : ‖z - 1‖ ≤ ‖z‖ + 2 := by
      have h := norm_sub_le z 1
      have h1 : ‖(1:ℂ)‖ = 1 := by simp
      rw [h1] at h
      linarith
    have h1 : Real.log ‖z - 1‖ ≤ Real.log (‖z‖ + 2) := by
      rcases eq_or_lt_of_le (norm_nonneg (z - 1)) with h0 | h0
      · rw [← h0, Real.log_zero]
        exact Real.log_nonneg (by linarith [norm_nonneg z])
      · exact Real.log_le_log h0 hle
    have h2 : Real.log (‖z‖ + 2) ≤ ‖z‖ * Real.log (‖z‖ + 2) := by
      have h3 := mul_le_mul_of_nonneg_right hzL hL
      simpa using h3
    linarith
  have hζb : ‖riemannZeta z‖ ≤ 5 * (‖z‖ + 2) ^ 2 :=
    xigrowth_norm_riemannZeta_le_quadratic hre hz
  rcases eq_or_ne (riemannZeta z) 0 with hζ0 | hζne
  · have hxi0 : xi₀ z = 0 := by
      rw [hxi, hζ0, mul_zero, mul_zero]
    rw [hxi0, norm_zero, Real.log_zero]
    have hA : (0:ℝ) ≤ AΓ + 4 := by linarith
    have hterm : 0 ≤ (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) :=
      mul_nonneg (mul_nonneg hA (norm_nonneg z)) hL
    have hmax : 0 ≤ max (BΓ + Real.log 5) 0 := le_max_right _ _
    linarith
  · have hz0n : ‖z‖ ≠ 0 := norm_ne_zero_iff.mpr hz0
    have hz1n : ‖z - 1‖ ≠ 0 := norm_ne_zero_iff.mpr (sub_ne_zero.mpr hz1)
    have hΓn : ‖Complex.Gammaℝ z‖ ≠ 0 := norm_ne_zero_iff.mpr hΓne
    have hζn : ‖riemannZeta z‖ ≠ 0 := norm_ne_zero_iff.mpr hζne
    have hlogeq : Real.log ‖xi₀ z‖
        = Real.log ‖z‖ + Real.log ‖z - 1‖ + Real.log ‖Complex.Gammaℝ z‖
          + Real.log ‖riemannZeta z‖ := by
      rw [hnorm, Real.log_mul (mul_ne_zero (mul_ne_zero hz0n hz1n) hΓn) hζn,
        Real.log_mul (mul_ne_zero hz0n hz1n) hΓn, Real.log_mul hz0n hz1n]
    have hζpos : 0 < ‖riemannZeta z‖ :=
      lt_of_le_of_ne (norm_nonneg _) (Ne.symm hζn)
    have hlogζ1 : Real.log ‖riemannZeta z‖ ≤ Real.log (5 * (‖z‖ + 2) ^ 2) :=
      Real.log_le_log hζpos hζb
    have hlogζ2 : Real.log (5 * (‖z‖ + 2) ^ 2)
        = Real.log 5 + 2 * Real.log (‖z‖ + 2) := by
      rw [Real.log_mul (by norm_num) (by positivity), Real.log_pow]
      push_cast
      ring
    have hlogζ3 : Real.log ‖riemannZeta z‖
        ≤ Real.log 5 + 2 * (‖z‖ * Real.log (‖z‖ + 2)) := by
      have h3 : Real.log (‖z‖ + 2) ≤ ‖z‖ * Real.log (‖z‖ + 2) := by
        have h4 := mul_le_mul_of_nonneg_right hzL hL
        simpa using h4
      linarith
    have hΓ := hΓb z hre
    have hA : (0:ℝ) ≤ AΓ + 4 := by linarith
    calc Real.log ‖xi₀ z‖
        = Real.log ‖z‖ + Real.log ‖z - 1‖ + Real.log ‖Complex.Gammaℝ z‖
          + Real.log ‖riemannZeta z‖ := hlogeq
      _ ≤ (AΓ * ‖z‖ * Real.log (‖z‖ + 2) + BΓ)
            + ‖z‖ * Real.log (‖z‖ + 2) + ‖z‖ * Real.log (‖z‖ + 2)
            + (Real.log 5 + 2 * (‖z‖ * Real.log (‖z‖ + 2))) := by linarith
      _ = (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) + (BΓ + Real.log 5) := by ring
      _ ≤ (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) + max (BΓ + Real.log 5) 0 := by
          linarith [le_max_left (BΓ + Real.log 5) 0]

set_option maxHeartbeats 2000000 in
/-- Growth bound for `log ‖ξ₀‖` on the half-plane `Re z < 1/2`, away from a
small ball: transport the right-half bound across `z ↦ 1 - z`. -/
theorem xigrowth_xi₀_growth_left (AΓ BΓ : ℝ) (hAΓ : 0 ≤ AΓ)
    (hΓb : ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re →
      Real.log ‖Complex.Gammaℝ s‖ ≤ AΓ * ‖s‖ * Real.log (‖s‖ + 2) + BΓ)
    {z : ℂ} (hz : 2 ≤ ‖z‖) (hre : z.re < 1 / 2) :
    Real.log ‖xi₀ z‖
      ≤ 4 * (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) + max (BΓ + Real.log 5) 0 := by
  have hwsq : ‖1 - z‖ ^ 2 = (1 - z.re) ^ 2 + z.im ^ 2 := by
    rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
    simp only [Complex.sub_re, Complex.sub_im, Complex.one_re, Complex.one_im]
    ring
  have hzsq : ‖z‖ ^ 2 = z.re ^ 2 + z.im ^ 2 := by
    rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
    ring
  have hkey : (4:ℝ) ≤ ‖1 - z‖ ^ 2 := by
    nlinarith [hz, norm_nonneg z, hwsq, hzsq, hre]
  have hw2 : 2 ≤ ‖1 - z‖ := by
    nlinarith [hkey, norm_nonneg (1 - z)]
  have hre1 : (1 / 2 : ℝ) ≤ (1 - z).re := by
    simp
    linarith
  have hright := xigrowth_xi₀_growth_right AΓ BΓ hAΓ hΓb hw2 hre1
  rw [xi₀_one_sub z] at hright
  refine hright.trans ?_
  have hwle : ‖1 - z‖ ≤ ‖z‖ + 1 := by
    have h := norm_sub_le 1 z
    have h1 : ‖(1:ℂ)‖ = 1 := by simp
    rw [h1] at h
    linarith
  have hLz : 0 ≤ Real.log (‖z‖ + 2) := Real.log_nonneg (by linarith [norm_nonneg z])
  have hL1 : Real.log (‖1 - z‖ + 2) ≤ Real.log (‖z‖ + 2) + 1 := by
    have h1 : Real.log (‖1 - z‖ + 2) ≤ Real.log (‖z‖ + 3) := by
      apply Real.log_le_log (by positivity)
      linarith
    have h2 : Real.log (‖z‖ + 3) ≤ Real.log (‖z‖ + 2) + 1 := by
      have h3 : ‖z‖ + 3 ≤ 2 * (‖z‖ + 2) := by linarith [norm_nonneg z]
      have h4 : Real.log (‖z‖ + 3) ≤ Real.log (2 * (‖z‖ + 2)) :=
        Real.log_le_log (by positivity) h3
      have h5 : Real.log (2 * (‖z‖ + 2)) = Real.log 2 + Real.log (‖z‖ + 2) :=
        Real.log_mul (by norm_num) (by positivity)
      have h6 : Real.log 2 ≤ 1 := by
        have h7 := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 2)
        linarith
      linarith
    linarith
  have hL1z : 0 ≤ Real.log (‖1 - z‖ + 2) :=
    Real.log_nonneg (by linarith [norm_nonneg (1 - z)])
  have hLz1 : (1:ℝ) ≤ Real.log (‖z‖ + 2) := by
    have h1 : Real.log 4 ≤ Real.log (‖z‖ + 2) :=
      Real.log_le_log (by norm_num) (by linarith [norm_nonneg z])
    have h2 : (1:ℝ) < Real.log 4 := by
      have h3 : Real.log 4 = 2 * Real.log 2 := by
        rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
        norm_num
      have h4 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
      linarith
    linarith
  have hprod : ‖1 - z‖ * Real.log (‖1 - z‖ + 2)
      ≤ 4 * (‖z‖ * Real.log (‖z‖ + 2)) := by
    have hbase : (‖z‖ + 1) * (Real.log (‖z‖ + 2) + 1)
        ≤ 4 * (‖z‖ * Real.log (‖z‖ + 2)) := by
      have h1 : ‖z‖ * 1 ≤ ‖z‖ * Real.log (‖z‖ + 2) :=
        mul_le_mul_of_nonneg_left hLz1 (norm_nonneg z)
      have h2 : (1:ℝ) * 1 ≤ ‖z‖ * Real.log (‖z‖ + 2) := by nlinarith [h1, hz]
      have h3 : (1:ℝ) * Real.log (‖z‖ + 2) ≤ ‖z‖ * Real.log (‖z‖ + 2) :=
        mul_le_mul_of_nonneg_right (by linarith : (1:ℝ) ≤ ‖z‖) hLz
      nlinarith [h1, h2, h3, hLz, norm_nonneg z]
    calc ‖1 - z‖ * Real.log (‖1 - z‖ + 2)
        ≤ (‖z‖ + 1) * (Real.log (‖z‖ + 2) + 1) := by
          apply mul_le_mul hwle hL1 hL1z (by linarith [norm_nonneg z])
      _ ≤ 4 * (‖z‖ * Real.log (‖z‖ + 2)) := hbase
  have hA : 0 ≤ AΓ + 4 := by linarith
  have hfin := mul_le_mul_of_nonneg_left hprod hA
  have hmax := le_max_left (BΓ + Real.log 5) 0
  nlinarith [hfin, hmax]

set_option maxHeartbeats 2000000 in
/-- **Logarithmic growth bound for `ξ₀`**: `log ‖ξ₀ z‖` is at most
`A‖z‖ log(‖z‖+2) + B`. -/
theorem exists_bound_log_norm_xi₀ :
    ∃ A B : ℝ, 0 ≤ A ∧ ∀ z : ℂ,
      Real.log ‖xi₀ z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + B := by
  obtain ⟨AΓ, BΓ, hAΓ, hΓb⟩ := gammaR_growth_exists_bound_log_norm_half_le
  obtain ⟨M, hM⟩ := (isCompact_closedBall (0 : ℂ) 2).exists_bound_of_continuousOn
    (differentiable_xi₀.continuous.continuousOn)
  refine ⟨4 * (AΓ + 4), max (max (BΓ + Real.log 5) 0) (Real.log M), ?_, ?_⟩
  · have hA4 : (0 : ℝ) ≤ AΓ + 4 := by linarith
    nlinarith
  · intro z
    have hA4 : (0 : ℝ) ≤ AΓ + 4 := by linarith
    have hB1 : max (BΓ + Real.log 5) 0
        ≤ max (max (BΓ + Real.log 5) 0) (Real.log M) := le_max_left _ _
    have hB0 : (0 : ℝ) ≤ max (max (BΓ + Real.log 5) 0) (Real.log M) :=
      le_trans (le_max_right _ _) (le_max_left _ _)
    rcases le_or_gt ‖z‖ 2 with hsmall | hbig
    · have hmem : z ∈ Metric.closedBall (0 : ℂ) 2 := by
        simpa [Metric.mem_closedBall] using hsmall
      have h1 : ‖xi₀ z‖ ≤ M := hM z hmem
      have hL : 0 ≤ Real.log (‖z‖ + 2) := Real.log_nonneg (by linarith [norm_nonneg z])
      have hterm : 0 ≤ 4 * (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) :=
        mul_nonneg (mul_nonneg (mul_nonneg (by norm_num) hA4) (norm_nonneg z)) hL
      rcases eq_or_ne (xi₀ z) 0 with h0 | hne
      · rw [h0, norm_zero, Real.log_zero]
        linarith
      · have hpos : 0 < ‖xi₀ z‖ := norm_pos_iff.mpr hne
        have h2 : Real.log ‖xi₀ z‖ ≤ Real.log M := Real.log_le_log hpos h1
        have h3 : Real.log M ≤ max (max (BΓ + Real.log 5) 0) (Real.log M) :=
          le_max_right _ _
        linarith
    · have hz2 : 2 ≤ ‖z‖ := le_of_lt hbig
      have hL : 0 ≤ Real.log (‖z‖ + 2) := Real.log_nonneg (by linarith [norm_nonneg z])
      rcases le_or_gt (1 / 2 : ℝ) z.re with hre | hre
      · have hr := xigrowth_xi₀_growth_right AΓ BΓ hAΓ hΓb hz2 hre
        have hAle : (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2)
            ≤ 4 * (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) := by
          have hnn : 0 ≤ ‖z‖ * Real.log (‖z‖ + 2) := mul_nonneg (norm_nonneg z) hL
          have h1 : (AΓ + 4) ≤ 4 * (AΓ + 4) := by linarith
          have h2 : (AΓ + 4) * (‖z‖ * Real.log (‖z‖ + 2))
              ≤ (4 * (AΓ + 4)) * (‖z‖ * Real.log (‖z‖ + 2)) :=
            mul_le_mul_of_nonneg_right h1 hnn
          calc (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2)
              = (AΓ + 4) * (‖z‖ * Real.log (‖z‖ + 2)) := by ring
            _ ≤ (4 * (AΓ + 4)) * (‖z‖ * Real.log (‖z‖ + 2)) := h2
            _ = 4 * (AΓ + 4) * ‖z‖ * Real.log (‖z‖ + 2) := by ring
        linarith
      · have hl := xigrowth_xi₀_growth_left AΓ BΓ hAΓ hΓb hz2 hre
        linarith

end AbsoluteHodgeZetaStrip
