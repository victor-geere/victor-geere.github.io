/-
Convergence of the zero sum for the Gaussian explicit formula.

This is direction 2 of the two repairs identified as O4 in
`archimedean-prime-evaluation`: the explicit formula needs the `HasSum` of
`(H_c ρ).re` over the nontrivial zeros of `ζ`.

What is proved here: the trivial zeros are infinite, the trivial-zero Gaussian
series is summable (hence has a `HasSum`), and `ζ` has no zeros on `Re s > 1`.
The nontrivial-zero counting bound is recorded as the named input
`ZeroCountingBound`; the reduction from it to the summability of the zero sum is
the open target.
-/
import Mathlib
import FunctionalEquation

noncomputable section

open Complex Filter MeasureTheory
open scoped Topology BigOperators

namespace ZeroSumConvergence

/-! ## The trivial zeros -/

/-- **T1. The trivial zeros are infinite.** -/
theorem trivialZeros_infinite :
    Set.Infinite {s : ℂ | ∃ n : ℕ, s = -2 * ((n : ℂ) + 1)} := by
  apply Set.infinite_of_injective_forall_mem (f := fun n : ℕ => -2 * ((n : ℂ) + 1))
  · intro m n hmn
    have h : ((m : ℂ) + 1) = ((n : ℂ) + 1) := by
      linear_combination (-1 / 2 : ℂ) * hmn
    have h2 : (m : ℂ) = (n : ℂ) := by linear_combination h
    exact_mod_cast h2
  · intro n
    exact ⟨n, rfl⟩

/-- **T2. The Gaussian sum over the trivial zeros is summable.** -/
theorem summable_trivialZero_gaussian (σ : ℝ) (hσ : 0 < σ) :
    Summable (fun n : ℕ => Real.exp (-(σ * (2 * ((n : ℝ) + 1))) ^ 2)) := by
  set r : ℝ := Real.exp (-4 * σ ^ 2) with hr
  have hr0 : 0 ≤ r := (Real.exp_pos _).le
  have hr1 : r < 1 := by
    rw [hr, Real.exp_lt_one_iff]
    nlinarith [sq_nonneg σ]
  have hgeom : Summable (fun n : ℕ => r ^ (n + 1)) := by
    have := (summable_geometric_of_lt_one hr0 hr1).mul_left r
    simpa [pow_succ, mul_comm] using this
  refine Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) ?_ hgeom
  intro n
  have hn : (1 : ℝ) ≤ (n : ℝ) + 1 := by
    have : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    linarith
  have hsq : 4 * ((n : ℝ) + 1) ≤ (2 * ((n : ℝ) + 1)) ^ 2 := by nlinarith
  have hle : -(σ * (2 * ((n : ℝ) + 1))) ^ 2 ≤ -4 * σ ^ 2 * ((n : ℝ) + 1) := by
    nlinarith [sq_nonneg σ, hn, hsq]
  calc Real.exp (-(σ * (2 * ((n : ℝ) + 1))) ^ 2)
      ≤ Real.exp (-4 * σ ^ 2 * ((n : ℝ) + 1)) := Real.exp_le_exp.mpr hle
    _ = r ^ (n + 1) := by
        rw [hr, ← Real.exp_nat_mul]
        congr 1
        push_cast
        ring

/-- **T3. The trivial-zero Gaussian series has a `HasSum`.** -/
theorem hasSum_trivialZero_gaussian (σ : ℝ) (hσ : 0 < σ) :
    HasSum (fun n : ℕ => Real.exp (-(σ * (2 * ((n : ℝ) + 1))) ^ 2))
      (∑' n : ℕ, Real.exp (-(σ * (2 * ((n : ℝ) + 1))) ^ 2)) :=
  (summable_trivialZero_gaussian σ hσ).hasSum

/-! ## The counting bound (named input) -/

/-- The zeros of `Λ` in the critical strip with `|Im ρ| ≤ T`. -/
def zeroStrip (T : ℝ) : Set ℂ :=
  {ρ : ℂ | completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1 ∧ |ρ.im| ≤ T}

/-- **The Riemann–von Mangoldt counting bound**, as a named input.  It includes
the finiteness of the zero set in each horizontal strip, so it is not vacuous. -/
def ZeroCountingBound : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 1 ≤ T →
    (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T

/-- **T4. `ζ` has no zeros on `Re s > 1`** (re-export). -/
theorem zeta_ne_zero_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    riemannZeta s ≠ 0 :=
  riemannZeta_ne_zero_of_one_lt_re hs

/-- **T5. The zero correspondence `ζ ↔ Λ`** (re-exported from
`zeta-functional-equation`), the bridge between the zero sum and `ζ`. -/
theorem zeta_zero_iff_completed_zero {s : ℂ} (hs : s ≠ 0) (hs' : s ≠ 1)
    (htriv : ∀ n : ℕ, s ≠ -2 * (n : ℂ)) :
    riemannZeta s = 0 ↔ completedRiemannZeta s = 0 :=
  ZetaFunctionalEquation.zeta_zero_iff_completed_zero hs hs' htriv



/-- **T6. The zero strip is monotone in `T`.** -/
theorem zeroStrip_mono {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) : zeroStrip T₁ ⊆ zeroStrip T₂ := by
  intro z hz
  obtain ⟨h1, h2, h3, h4⟩ := hz
  exact ⟨h1, h2, h3, le_trans h4 h⟩

/-- **T7. The counting bound, as a function.** -/
theorem ncard_zeroStrip_le (hc : ZeroCountingBound) :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).ncard ≤ C * T * Real.log T := by
  obtain ⟨C, hC, h⟩ := hc
  exact ⟨C, hC, fun T hT => (h T hT).2⟩

/-- **T8. Dyadic annulus bound.**  The zeros with `2^k ≤ |Im z| ≤ 2^(k+1)` are at
most `C·2^(k+1)·log(2^(k+1))` in number. -/
theorem annulus_bound (hc : ZeroCountingBound) (k : ℕ) :
    ∃ C : ℝ, 0 < C ∧
      ((zeroStrip (2 ^ (k + 1))).ncard : ℝ) ≤ C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) := by
  obtain ⟨C, hC, h⟩ := hc
  refine ⟨C, hC, ?_⟩
  have hT : (1 : ℝ) ≤ (2 : ℝ) ^ (k + 1) :=
    one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2)
  exact (h ((2:ℝ) ^ (k+1)) hT).2



/-- `k + 1 ≤ 4^k`. -/
theorem succ_le_four_pow (k : ℕ) : (k : ℝ) + 1 ≤ (4 : ℝ) ^ k := by
  induction k with
  | zero => norm_num
  | succ n ih =>
      have hnn : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
      have h4n : (0:ℝ) ≤ (4:ℝ)^n := pow_nonneg (by norm_num) n
      rw [pow_succ]
      push_cast
      nlinarith [ih, h4n, hnn]

/-- `4^k·e^{−c·4^k} → 0` along the naturals. -/
theorem tendsto_four_pow_mul_exp (c : ℝ) (hc : 0 < c) :
    Tendsto (fun k : ℕ => (4 : ℝ) ^ k * Real.exp (-(c * (4 : ℝ) ^ k)))
      atTop (nhds 0) := by
  have h4 : Tendsto (fun k : ℕ => (4 : ℝ) ^ k) atTop atTop :=
    tendsto_pow_atTop_atTop_of_one_lt (by norm_num)
  have hcx : Tendsto (fun k : ℕ => c * (4 : ℝ) ^ k) atTop atTop :=
    Tendsto.const_mul_atTop hc h4
  have hx : Tendsto (fun x : ℝ => x * Real.exp (-x)) atTop (nhds 0) := by
    simpa using Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero 1
  have hcomp : Tendsto (fun k : ℕ => (c * (4 : ℝ) ^ k) * Real.exp (-(c * (4 : ℝ) ^ k)))
      atTop (nhds 0) := hx.comp hcx
  have hmul : Tendsto (fun k : ℕ => (1 / c) *
      ((c * (4 : ℝ) ^ k) * Real.exp (-(c * (4 : ℝ) ^ k)))) atTop (nhds 0) := by
    simpa using hcomp.const_mul (1 / c)
  refine hmul.congr' ?_
  filter_upwards with k
  field_simp

end ZeroSumConvergence

namespace ZeroSumConvergence

/-- `(k+1)·4^k·e^{−σ²4^k} → 0`. -/
theorem tendsto_ratio (σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun k : ℕ => ((k : ℝ) + 1) * (4 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)))
      atTop (nhds 0) := by
  have h4 : Tendsto (fun k : ℕ => (4 : ℝ) ^ k) atTop atTop :=
    tendsto_pow_atTop_atTop_of_one_lt (by norm_num)
  have hσ2 : 0 < σ ^ 2 := by positivity
  have hcx : Tendsto (fun k : ℕ => σ ^ 2 * (4 : ℝ) ^ k) atTop atTop :=
    Tendsto.const_mul_atTop hσ2 h4
  have hx2 : Tendsto (fun x : ℝ => x ^ 2 * Real.exp (-x)) atTop (nhds 0) :=
    Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero 2
  have hcomp : Tendsto (fun k : ℕ =>
      (σ ^ 2 * (4 : ℝ) ^ k) ^ 2 * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) atTop (nhds 0) :=
    hx2.comp hcx
  have hmul : Tendsto (fun k : ℕ => (σ ^ 4)⁻¹ *
      ((σ ^ 2 * (4 : ℝ) ^ k) ^ 2 * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)))) atTop (nhds 0) := by
    simpa using hcomp.const_mul ((σ ^ 4)⁻¹)
  refine squeeze_zero (fun k => by positivity) (fun k => ?_) hmul
  have hk : ((k : ℝ) + 1) ≤ (4 : ℝ) ^ k := succ_le_four_pow k
  have hpos : (0 : ℝ) < (4 : ℝ) ^ k := pow_pos (by norm_num) k
  have he : (0 : ℝ) < Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := Real.exp_pos _
  calc ((k : ℝ) + 1) * (4 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))
      ≤ (4 : ℝ) ^ k * (4 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by
        apply mul_le_mul_of_nonneg_right _ he.le
        exact mul_le_mul_of_nonneg_right hk (le_of_lt hpos)
    _ = (σ ^ 4)⁻¹ *
        ((σ ^ 2 * (4 : ℝ) ^ k) ^ 2 * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) := by
        field_simp

/-- **T9. The dyadic majorant is summable:** `Σ_k (k+1)·2^k·e^{−σ²·4^k} < ∞`. -/
theorem summable_pow_mul_exp_neg_pow (σ : ℝ) (hσ : 0 < σ) :
    Summable (fun k : ℕ => ((k : ℝ) + 1) * (2 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) := by
  have hev : ∀ᶠ k : ℕ in atTop,
      ((k : ℝ) + 1) * (4 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) ≤ 1 :=
    (tendsto_ratio σ hσ).eventually (eventually_le_nhds (by norm_num : (0 : ℝ) < 1))
  have hgeom : Summable (fun k : ℕ => (1 / (2 : ℝ)) ^ k) :=
    summable_geometric_of_lt_one (by norm_num) (by norm_num)
  refine Summable.of_norm_bounded_eventually hgeom ?_
  rw [Nat.cofinite_eq_atTop]
  filter_upwards [hev] with k hk
  have hpow : (2:ℝ)^k = (4:ℝ)^k * (1/(2:ℝ))^k := by
    rw [show (4:ℝ) = 2 * 2 by norm_num, mul_pow]
    rw [show (2:ℝ)^k * (2:ℝ)^k * (1/(2:ℝ))^k = (2:ℝ)^k * ((2:ℝ)^k * (1/(2:ℝ))^k) by ring]
    rw [show (2:ℝ)^k * (1/(2:ℝ))^k = 1 by rw [← mul_pow]; norm_num]
    ring
  have hsplit : ((k : ℝ) + 1) * (2 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) =
      (((k : ℝ) + 1) * (4 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) * (1 / 2) ^ k := by
    rw [hpow]
    ring
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity), hsplit]
  calc (((k : ℝ) + 1) * (4 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) * (1 / 2) ^ k
      ≤ 1 * (1 / 2) ^ k := by
        apply mul_le_mul_of_nonneg_right hk (by positivity)
    _ = (1 / 2) ^ k := by ring



/-- **T13 (O4b, sequence form). The summability criterion from a counting
(no-clustering) bound.**  If the moduli `t k ≥ 1` satisfy `k ≤ C·t_k·log t_k`,
then the Gaussian series `Σ_k e^{−σ²t_k²}` is summable.  The proof uses
`log t ≤ t`, giving `t_k² ≥ k/C`, hence geometric decay. -/
theorem summable_gaussian_of_no_clustering (t : ℕ → ℝ) (C σ : ℝ)
    (hC : 0 < C) (hσ : 0 < σ) (ht1 : ∀ k, 1 ≤ t k)
    (hclust : ∀ k : ℕ, ((k : ℕ) : ℝ) ≤ C * t k * Real.log (t k)) :
    Summable (fun k : ℕ => Real.exp (-(σ ^ 2 * t k ^ 2))) := by
  have hr0 : (0 : ℝ) ≤ Real.exp (-(σ ^ 2 / C)) := (Real.exp_pos _).le
  have hr1 : Real.exp (-(σ ^ 2 / C)) < 1 := by
    rw [Real.exp_lt_one_iff]
    have hpos : (0 : ℝ) < σ ^ 2 / C := by positivity
    linarith
  have hgeom : Summable (fun k : ℕ => Real.exp (-(σ ^ 2 / C)) ^ k) :=
    summable_geometric_of_lt_one hr0 hr1
  refine Summable.of_nonneg_of_le (fun k => (Real.exp_pos _).le) (fun k => ?_) hgeom
  rw [← Real.exp_nat_mul]
  apply Real.exp_le_exp.mpr
  have htpos : (0 : ℝ) < t k := by linarith [ht1 k]
  have hlog : Real.log (t k) ≤ t k := Real.log_le_self (by linarith [ht1 k])
  have hk : ((k : ℕ) : ℝ) ≤ C * t k ^ 2 := by
    have hCt : (0 : ℝ) < C * t k := mul_pos hC htpos
    have hstep : C * t k * Real.log (t k) ≤ C * t k * t k :=
      mul_le_mul_of_nonneg_left hlog hCt.le
    calc ((k : ℕ) : ℝ) ≤ C * t k * Real.log (t k) := hclust k
      _ ≤ C * t k * t k := hstep
      _ = C * t k ^ 2 := by ring
  have hkC : ((k : ℕ) : ℝ) / C ≤ t k ^ 2 := by
    rw [div_le_iff₀ hC]
    linarith [hk]
  have hσ2 : (0 : ℝ) < σ ^ 2 := by positivity
  have : σ ^ 2 * (((k : ℕ) : ℝ) / C) ≤ σ ^ 2 * t k ^ 2 := by
    exact mul_le_mul_of_nonneg_left hkC hσ2.le
  have harg : -(σ ^ 2 * t k ^ 2) ≤ -((σ ^ 2 / C) * ((k : ℕ) : ℝ)) := by
    have heq : σ ^ 2 * (((k : ℕ) : ℝ) / C) = (σ ^ 2 / C) * ((k : ℕ) : ℝ) := by ring
    linarith [this, heq]
  convert harg using 2
  push_cast
  ring



/-- **T14 (O4c). The counting bound gives the no-clustering inequality.**  For a
monotone enumeration `t` of the moduli with `t k → ∞`, the count of indices with
`t k ≤ T` bounds the index itself:
`k ≤ C·t_k·log t_k`. -/
theorem no_clustering_of_counting (t : ℕ → ℝ) (C : ℝ) (hC : 0 < C)
    (ht : Monotone t) (ht1 : ∀ k, 1 ≤ t k) (htend : Tendsto t atTop atTop)
    (hcount : ∀ T : ℝ, 1 ≤ T → (({k : ℕ | t k ≤ T}).ncard : ℝ) ≤ C * T * Real.log T) :
    ∀ k : ℕ, ((k : ℕ) : ℝ) ≤ C * t k * Real.log (t k) := by
  have hfin : ∀ T : ℝ, {k : ℕ | t k ≤ T}.Finite := by
    intro T
    have h : ∀ᶠ k : ℕ in atTop, T < t k :=
      htend.eventually (Ioi_mem_atTop T)
    obtain ⟨N, hN⟩ := eventually_atTop.mp h
    refine Set.Finite.subset (Set.finite_Iio N) ?_
    intro j hj
    rw [Set.mem_setOf_eq] at hj
    by_contra hlt
    have hNj : T < t j := hN j (Nat.le_of_not_lt hlt)
    linarith
  have hcard : ∀ k : ℕ, k + 1 ≤ ({j : ℕ | t j ≤ t k}).ncard := by
    intro k
    have hsub : (↑(Finset.range (k + 1)) : Set ℕ) ⊆ {j : ℕ | t j ≤ t k} := by
      intro j hj
      rw [Finset.mem_coe, Finset.mem_range] at hj
      exact ht (Nat.le_of_lt_succ hj)
    have hle := Set.ncard_le_ncard hsub (hfin (t k))
    rwa [Set.ncard_coe_finset, Finset.card_range] at hle
  intro k
  have h1 : ((k + 1 : ℕ) : ℝ) ≤ C * t k * Real.log (t k) := by
    have hbound := hcount (t k) (ht1 k)
    have hcast : ((k + 1 : ℕ) : ℝ) ≤ (({j : ℕ | t j ≤ t k}).ncard : ℝ) := by
      exact_mod_cast hcard k
    linarith
  have h2 : ((k : ℕ) : ℝ) ≤ ((k + 1 : ℕ) : ℝ) := by
    push_cast
    linarith
  linarith

/-- **T15. The summability criterion from the counting bound.** -/
theorem summable_gaussian_of_counting (t : ℕ → ℝ) (C σ : ℝ) (hC : 0 < C) (hσ : 0 < σ)
    (ht : Monotone t) (ht1 : ∀ k, 1 ≤ t k) (htend : Tendsto t atTop atTop)
    (hcount : ∀ T : ℝ, 1 ≤ T → (({k : ℕ | t k ≤ T}).ncard : ℝ) ≤ C * T * Real.log T) :
    Summable (fun k : ℕ => Real.exp (-(σ ^ 2 * t k ^ 2))) :=
  summable_gaussian_of_no_clustering t C σ hC hσ ht1
    (no_clustering_of_counting t C hC ht ht1 htend hcount)



/-- **T16. The annulus sum bound.**  If every point of a finite set has
`|Im ρ| ≥ T`, the Gaussian sum is at most `card · e^{−σ²T²}`. -/
theorem sum_le_card_mul_exp (F : Finset ℂ) (σ T : ℝ) (hσ : 0 < σ) (hT : 0 ≤ T)
    (hF : ∀ ρ ∈ F, T ≤ |ρ.im|) :
    ∑ ρ ∈ F, Real.exp (-(σ ^ 2 * ρ.im ^ 2)) ≤
      (F.card : ℝ) * Real.exp (-(σ ^ 2 * T ^ 2)) := by
  have hterm : ∀ ρ ∈ F, Real.exp (-(σ ^ 2 * ρ.im ^ 2)) ≤ Real.exp (-(σ ^ 2 * T ^ 2)) := by
    intro ρ hρ
    apply Real.exp_le_exp.mpr
    have him : T ≤ |ρ.im| := hF ρ hρ
    have hsq : T ^ 2 ≤ ρ.im ^ 2 := by
      have habs : |ρ.im| ^ 2 = ρ.im ^ 2 := sq_abs ρ.im
      nlinarith [hT, him, abs_nonneg ρ.im, habs]
    have hσ2 : (0:ℝ) < σ ^ 2 := by positivity
    nlinarith [hsq, hσ2]
  calc ∑ ρ ∈ F, Real.exp (-(σ ^ 2 * ρ.im ^ 2))
      ≤ ∑ _ρ ∈ F, Real.exp (-(σ ^ 2 * T ^ 2)) :=
        Finset.sum_le_sum hterm
    _ = (F.card : ℝ) * Real.exp (-(σ ^ 2 * T ^ 2)) := by
        rw [Finset.sum_const, nsmul_eq_mul]



/-- **T17. Dyadic annulus covering:** every `t ≥ 1` lies in a unique half-open
dyadic annulus `[2^k, 2^(k+1))`. -/
theorem exists_dyadic_annulus {t : ℝ} (ht : 1 ≤ t) :
    ∃ k : ℕ, (2 : ℝ) ^ k ≤ t ∧ t < (2 : ℝ) ^ (k + 1) := by
  have h2 : Tendsto (fun n : ℕ => (2 : ℝ) ^ n) atTop atTop :=
    tendsto_pow_atTop_atTop_of_one_lt (by norm_num)
  have hex : ∃ n : ℕ, t < (2 : ℝ) ^ (n + 1) := by
    obtain ⟨n, hn⟩ := (h2.eventually (Ioi_mem_atTop t)).exists
    refine ⟨n, lt_of_lt_of_le hn ?_⟩
    rw [pow_succ]
    nlinarith [pow_pos (by norm_num : (0:ℝ) < 2) n]
  refine ⟨Nat.find hex, ?_, Nat.find_spec hex⟩
  by_contra hcon
  have htk : t < (2 : ℝ) ^ Nat.find hex := lt_of_not_ge hcon
  rcases Nat.eq_zero_or_pos (Nat.find hex) with hk | hk
  · rw [hk] at htk
    norm_num at htk
    linarith
  · have hprev : t < (2 : ℝ) ^ (Nat.find hex - 1 + 1) := by
      rw [Nat.sub_add_cancel hk]
      exact htk
    exact Nat.find_min hex (Nat.sub_one_lt (Nat.pos_iff_ne_zero.mp hk)) hprev



/-- **T18. The annulus counting bound.** -/
theorem annulus_ncard_le (C : ℝ) (hC : 0 < C)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T)
    (k : ℕ) :
    ((zeroStrip ((2 : ℝ) ^ (k + 1)) \ zeroStrip ((2 : ℝ) ^ k)).ncard : ℝ) ≤
      C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) := by
  have hT : (1 : ℝ) ≤ (2 : ℝ) ^ (k + 1) := one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2)
  have hfin := (hcount ((2 : ℝ) ^ (k + 1)) hT).1
  have hle := Set.ncard_le_ncard
    (s := zeroStrip ((2 : ℝ) ^ (k + 1)) \ zeroStrip ((2 : ℝ) ^ k))
    (t := zeroStrip ((2 : ℝ) ^ (k + 1))) Set.sdiff_subset hfin
  have hcast : ((zeroStrip ((2 : ℝ) ^ (k + 1)) \ zeroStrip ((2 : ℝ) ^ k)).ncard : ℝ)
      ≤ ((zeroStrip ((2 : ℝ) ^ (k + 1))).ncard : ℝ) := by
    exact_mod_cast hle
  exact hcast.trans (hcount ((2 : ℝ) ^ (k + 1)) hT).2

/-- **T19. The per-annulus Gaussian sum bound.** -/
theorem annulus_sum_le (C σ : ℝ) (hC : 0 < C) (hσ : 0 < σ)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T)
    (k : ℕ) (F : Finset ℂ) (hF : ∀ ρ ∈ F, (2 : ℝ) ^ k ≤ |ρ.im|)
    (hsub : ∀ ρ ∈ F, ρ ∈ zeroStrip ((2 : ℝ) ^ (k + 1))) :
    ∑ ρ ∈ F, Real.exp (-(σ ^ 2 * ρ.im ^ 2)) ≤
      C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) *
        Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by
  have hT : (1 : ℝ) ≤ (2 : ℝ) ^ (k + 1) := one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2)
  have h16 : ∑ ρ ∈ F, Real.exp (-(σ ^ 2 * ρ.im ^ 2)) ≤
      (F.card : ℝ) * Real.exp (-(σ ^ 2 * ((2 : ℝ) ^ k) ^ 2)) :=
    sum_le_card_mul_exp F σ ((2 : ℝ) ^ k) hσ (by positivity) hF
  have hcard : (F.card : ℝ) ≤
      C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) := by
    have hfin := (hcount ((2 : ℝ) ^ (k + 1)) hT).1
    have hsub' : (↑F : Set ℂ) ⊆ zeroStrip ((2 : ℝ) ^ (k + 1)) := by
      intro ρ hρ
      exact hsub ρ (by simpa using hρ)
    have hle := Set.ncard_le_ncard hsub' hfin
    have hcard : F.card ≤ (zeroStrip ((2 : ℝ) ^ (k + 1))).ncard := by
      simpa [Set.ncard_coe_finset] using hle
    have hcast : (F.card : ℝ) ≤ ((zeroStrip ((2 : ℝ) ^ (k + 1))).ncard : ℝ) := by
      exact_mod_cast hcard
    exact hcast.trans (hcount ((2 : ℝ) ^ (k + 1)) hT).2
  have hpow : ((2 : ℝ) ^ k) ^ 2 = (4 : ℝ) ^ k := by
    rw [← pow_mul, show (4:ℝ) = 2 ^ 2 by norm_num, ← pow_mul]
    ring_nf
  calc ∑ ρ ∈ F, Real.exp (-(σ ^ 2 * ρ.im ^ 2))
      ≤ (F.card : ℝ) * Real.exp (-(σ ^ 2 * ((2 : ℝ) ^ k) ^ 2)) := h16
    _ = (F.card : ℝ) * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by rw [hpow]
    _ ≤ (C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1))) *
          Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by
        apply mul_le_mul_of_nonneg_right hcard (Real.exp_pos _).le
    _ = C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) *
          Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by ring



/-- **T20. The counting bound forces the strip `|Im ρ| ≤ 1` to be empty.** -/
theorem zeroStrip_one_eq_empty (C : ℝ) (hcount : ∀ T : ℝ, 1 ≤ T →
    (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T) :
    zeroStrip 1 = ∅ := by
  have h := hcount 1 le_rfl
  have hlog : Real.log (1 : ℝ) = 0 := Real.log_one
  have hle : ((zeroStrip 1).ncard : ℝ) ≤ 0 := by
    have hz : C * (1 : ℝ) * Real.log 1 = 0 := by rw [hlog]; ring
    linarith [h.2]
  have h0 : (zeroStrip 1).ncard = 0 := by
    have hnonneg : (0 : ℝ) ≤ ((zeroStrip 1).ncard : ℝ) := Nat.cast_nonneg _
    have : ((zeroStrip 1).ncard : ℝ) = 0 := le_antisymm hle hnonneg
    exact_mod_cast this
  exact (Set.ncard_eq_zero h.1).mp h0



/-- The dyadic annulus index of a point with `1 ≤ |Im|`. -/
noncomputable def annulusIndex (ρ : ℂ) (h : 1 ≤ |ρ.im|) : ℕ :=
  Nat.find (exists_dyadic_annulus h)

/-- **T21. The index specifies the annulus.** -/
theorem annulusIndex_spec (ρ : ℂ) (h : 1 ≤ |ρ.im|) :
    (2 : ℝ) ^ annulusIndex ρ h ≤ |ρ.im| ∧
      |ρ.im| < (2 : ℝ) ^ (annulusIndex ρ h + 1) :=
  Nat.find_spec (exists_dyadic_annulus h)

/-- **T22. The annulus index is unique.** -/
theorem annulusIndex_unique {ρ : ℂ} {h : 1 ≤ |ρ.im|} {j : ℕ}
    (hj : (2 : ℝ) ^ j ≤ |ρ.im| ∧ |ρ.im| < (2 : ℝ) ^ (j + 1)) :
    j = annulusIndex ρ h := by
  have hspec := annulusIndex_spec ρ h
  rcases lt_trichotomy j (annulusIndex ρ h) with hlt | heq | hgt
  · -- j < k: then 2^(j+1) ≤ 2^k ≤ |im|, contradicting |im| < 2^(j+1)
    have hle : (2 : ℝ) ^ (j + 1) ≤ (2 : ℝ) ^ annulusIndex ρ h := by
      apply pow_le_pow_right₀ (by norm_num : (1:ℝ) ≤ 2)
      omega
    linarith [hj.2, hspec.1, hle]
  · exact heq
  · -- k < j: then 2^(k+1) ≤ 2^j ≤ |im|, contradicting |im| < 2^(k+1)
    have hle : (2 : ℝ) ^ (annulusIndex ρ h + 1) ≤ (2 : ℝ) ^ j := by
      apply pow_le_pow_right₀ (by norm_num : (1:ℝ) ≤ 2)
      omega
    linarith [hj.1, hspec.2, hle]

/-- **T23. The zeros in an annulus form a finite set.** -/
theorem annulus_zeros_finite (C : ℝ)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T)
    (k : ℕ) :
    {ρ : ℂ | completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1 ∧
      (2 : ℝ) ^ k ≤ |ρ.im| ∧ |ρ.im| < (2 : ℝ) ^ (k + 1)}.Finite := by
  have hT : (1 : ℝ) ≤ (2 : ℝ) ^ (k + 1) := one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2)
  refine Set.Finite.subset (hcount ((2 : ℝ) ^ (k + 1)) hT).1 ?_
  intro ρ hρ
  exact ⟨hρ.1, hρ.2.1, hρ.2.2.1, le_of_lt hρ.2.2.2.2⟩



/-- **T24. The Gaussian `tsum` over a finite set with `|Im| ≥ T`.** -/
theorem tsum_le_card_mul_exp {S : Set ℂ} (hS : S.Finite) (σ T : ℝ) (hσ : 0 < σ) (hT : 0 ≤ T)
    (h : ∀ ρ ∈ S, T ≤ |ρ.im|) :
    ∑' ρ : S, Real.exp (-(σ ^ 2 * ρ.1.im ^ 2)) ≤
      (S.ncard : ℝ) * Real.exp (-(σ ^ 2 * T ^ 2)) := by
  have hMnn : (0 : ℝ) ≤ Real.exp (-(σ ^ 2 * T ^ 2)) := (Real.exp_pos _).le
  have hterm : ∀ ρ : S, Real.exp (-(σ ^ 2 * ρ.1.im ^ 2)) ≤ Real.exp (-(σ ^ 2 * T ^ 2)) := by
    intro ρ
    apply Real.exp_le_exp.mpr
    have him : T ≤ |ρ.1.im| := h ρ.1 ρ.2
    have hsq : T ^ 2 ≤ ρ.1.im ^ 2 := by
      have habs : |ρ.1.im| ^ 2 = ρ.1.im ^ 2 := sq_abs ρ.1.im
      nlinarith [hT, him, abs_nonneg ρ.1.im, habs]
    have hσ2 : (0:ℝ) < σ ^ 2 := by positivity
    nlinarith [hsq, hσ2]
  have hsum : Summable (fun ρ : S => Real.exp (-(σ ^ 2 * ρ.1.im ^ 2))) :=
    hS.summable (fun ρ : ℂ => Real.exp (-(σ ^ 2 * ρ.im ^ 2)))
  have hconst : Summable (fun _ : S => Real.exp (-(σ ^ 2 * T ^ 2))) :=
    hS.summable (fun _ : ℂ => Real.exp (-(σ ^ 2 * T ^ 2)))
  calc ∑' ρ : S, Real.exp (-(σ ^ 2 * ρ.1.im ^ 2))
      ≤ ∑' _ρ : S, Real.exp (-(σ ^ 2 * T ^ 2)) :=
        hsum.tsum_le_tsum hterm hconst
    _ = (S.ncard : ℝ) * Real.exp (-(σ ^ 2 * T ^ 2)) := by
        rw [tsum_const, Nat.card_coe_set_eq, nsmul_eq_mul]



/-- **T25. Under the counting bound, every nontrivial zero has `1 ≤ |Im ρ|`.** -/
theorem zeros_im_ge_one (C : ℝ)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T) :
    ∀ ρ : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}, 1 ≤ |ρ.1.im| := by
  intro ρ
  by_contra h
  have hle : |ρ.1.im| ≤ 1 := le_of_lt (lt_of_not_ge h)
  have hmem : ρ.1 ∈ zeroStrip 1 := ⟨ρ.2.1, ρ.2.2.1, ρ.2.2.2, hle⟩
  rw [zeroStrip_one_eq_empty C hcount] at hmem
  exact absurd hmem (by simp)

/-- **T26. The zeros of a dyadic annulus, as a subset of the nontrivial zeros,
form a finite set.** -/
theorem annulus_zeros_finite' (C : ℝ)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T)
    (σ : ℝ) (k : ℕ) :
    {ρ : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} |
      (2 : ℝ) ^ k ≤ |ρ.1.im| ∧ |ρ.1.im| < (2 : ℝ) ^ (k + 1)}.Finite := by
  have hT : (1 : ℝ) ≤ (2 : ℝ) ^ (k + 1) := one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2)
  have hinj : Set.InjOn (Subtype.val : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} → ℂ)
      (Subtype.val ⁻¹' zeroStrip ((2 : ℝ) ^ (k + 1))) :=
    fun a _ b _ h => Subtype.ext h
  exact ((hcount ((2 : ℝ) ^ (k + 1)) hT).1.preimage hinj).subset
    (fun ρ hρ => ⟨ρ.2.1, ρ.2.2.1, ρ.2.2.2, le_of_lt hρ.2⟩)



/-- **T27. Finite-set `tsum` bound (general type).** -/
theorem tsum_le_card_mul_of_bound {α : Type*} {S : Set α} (hS : S.Finite) (f : α → ℝ) (M : ℝ)
    (h : ∀ x ∈ S, f x ≤ M) :
    ∑' x : S, f x.1 ≤ (S.ncard : ℝ) * M := by
  have hsum : Summable (fun x : S => f x.1) := hS.summable f
  have hconst : Summable (fun _ : S => M) := hS.summable (fun _ => M)
  calc ∑' x : S, f x.1 ≤ ∑' _x : S, M := hsum.tsum_le_tsum (fun x => h x.1 x.2) hconst
    _ = (S.ncard : ℝ) * M := by rw [tsum_const, Nat.card_coe_set_eq, nsmul_eq_mul]

/-- The annulus set of nontrivial zeros. -/
def annulusZeros (k : ℕ) : Set {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} :=
  {ρ | (2 : ℝ) ^ k ≤ |ρ.1.im| ∧ |ρ.1.im| < (2 : ℝ) ^ (k + 1)}

/-- **T28. The annulus Gaussian `tsum` bound.** -/
theorem annulus_zeros_tsum_le (C : ℝ)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T)
    (σ : ℝ) (hσ : 0 < σ) (k : ℕ) :
    ∑' ρ : annulusZeros k, Real.exp (-(σ ^ 2 * ρ.1.1.im ^ 2)) ≤
      C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) *
        Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by
  have hT : (1 : ℝ) ≤ (2 : ℝ) ^ (k + 1) := one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2)
  have hfin : (annulusZeros k).Finite := by
    have hinj : Set.InjOn
      (Subtype.val : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} → ℂ)
      (Subtype.val ⁻¹' zeroStrip ((2 : ℝ) ^ (k + 1))) :=
      fun a _ b _ h => Subtype.ext h
    exact ((hcount ((2 : ℝ) ^ (k + 1)) hT).1.preimage hinj).subset
      (fun ρ hρ => ⟨ρ.2.1, ρ.2.2.1, ρ.2.2.2, le_of_lt hρ.2⟩)
  have hle := tsum_le_card_mul_of_bound hfin
    (fun ρ => Real.exp (-(σ ^ 2 * ρ.1.im ^ 2)))
    (Real.exp (-(σ ^ 2 * ((2 : ℝ) ^ k) ^ 2)))
    (fun ρ hρ => by
      apply Real.exp_le_exp.mpr
      have hsq : ((2 : ℝ) ^ k) ^ 2 ≤ ρ.1.im ^ 2 := by
        have habs : |ρ.1.im| ^ 2 = ρ.1.im ^ 2 := sq_abs ρ.1.im
        have h1 : (0:ℝ) ≤ (2 : ℝ) ^ k := by positivity
        nlinarith [hρ.1, habs, h1, abs_nonneg ρ.1.im]
      have hσ2 : (0:ℝ) < σ ^ 2 := by positivity
      nlinarith [hsq, hσ2])
  have hcard : ((annulusZeros k).ncard : ℝ) ≤
      C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) := by
    have hle2 := Set.ncard_le_ncard_of_injOn
      (fun ρ : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} => ρ.1)
      (s := annulusZeros k) (t := zeroStrip ((2 : ℝ) ^ (k + 1)))
      (fun ρ hρ => ⟨ρ.2.1, ρ.2.2.1, ρ.2.2.2, le_of_lt hρ.2⟩)
      (fun a _ b _ h => Subtype.ext h)
      ((hcount ((2 : ℝ) ^ (k + 1)) hT).1)
    have hcast : ((annulusZeros k).ncard : ℝ)
        ≤ ((zeroStrip ((2 : ℝ) ^ (k + 1))).ncard : ℝ) := by
      exact_mod_cast hle2
    exact hcast.trans (hcount ((2 : ℝ) ^ (k + 1)) hT).2
  have hpow : ((2 : ℝ) ^ k) ^ 2 = (4 : ℝ) ^ k := by
    rw [← pow_mul, show (4:ℝ) = 2 ^ 2 by norm_num, ← pow_mul]
    ring_nf
  calc ∑' ρ : annulusZeros k, Real.exp (-(σ ^ 2 * ρ.1.1.im ^ 2))
      ≤ ((annulusZeros k).ncard : ℝ) * Real.exp (-(σ ^ 2 * ((2 : ℝ) ^ k) ^ 2)) := hle
    _ = ((annulusZeros k).ncard : ℝ) * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by rw [hpow]
    _ ≤ (C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1))) *
          Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) :=
        mul_le_mul_of_nonneg_right hcard (Real.exp_pos _).le
    _ = C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) *
          Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by ring



/-- **T29. The annulus majorant is summable.** -/
theorem summable_annulus_majorant (C σ : ℝ) (hC : 0 < C) (hσ : 0 < σ) :
    Summable (fun k : ℕ => C * (2 : ℝ) ^ (k + 1) * Real.log ((2 : ℝ) ^ (k + 1)) *
      Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) := by
  have hbase := summable_pow_mul_exp_neg_pow σ hσ
  refine Summable.of_nonneg_of_le (fun k => ?_) (fun k => ?_) (hbase.mul_left (2 * C))
  · have hlog : (0:ℝ) ≤ Real.log ((2 : ℝ) ^ (k + 1)) :=
      Real.log_nonneg (one_le_pow₀ (by norm_num : (1:ℝ) ≤ 2))
    positivity
  · have hlog : Real.log ((2 : ℝ) ^ (k + 1)) ≤ ((k : ℝ) + 1) := by
      rw [Real.log_pow]
      have h2 : Real.log 2 ≤ 1 := by
        have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 2)
        linarith
      have hk : (0:ℝ) ≤ ((k : ℝ) + 1) := by positivity
      have hcast : ((k : ℝ) + 1) * Real.log 2 ≤ ((k : ℝ) + 1) * 1 :=
        mul_le_mul_of_nonneg_left h2 hk
      push_cast at hcast ⊢
      linarith
    have h2k : (2 : ℝ) ^ (k + 1) = 2 * (2 : ℝ) ^ k := by rw [pow_succ]; ring
    rw [h2k]
    have he : (0:ℝ) ≤ Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := (Real.exp_pos _).le
    have hlog' : Real.log (2 * (2 : ℝ) ^ k) ≤ ((k : ℝ) + 1) := by
      rw [← h2k]; exact hlog
    calc C * (2 * (2 : ℝ) ^ k) * Real.log (2 * (2 : ℝ) ^ k) *
          Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))
        ≤ C * (2 * (2 : ℝ) ^ k) * ((k : ℝ) + 1) * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k)) := by
          apply mul_le_mul_of_nonneg_right _ he
          apply mul_le_mul_of_nonneg_left hlog'
          positivity
      _ = (2 * C) * (((k : ℝ) + 1) * (2 : ℝ) ^ k * Real.exp (-(σ ^ 2 * (4 : ℝ) ^ k))) := by ring

end ZeroSumConvergence

namespace ZeroSumConvergence

/-- **T30 (O4, main theorem). The counting bound implies summability of the
Gaussian over the nontrivial zeros.** -/
theorem summable_zeros_of_counting (C σ : ℝ) (hC : 0 < C) (hσ : 0 < σ)
    (hcount : ∀ T : ℝ, 1 ≤ T →
      (zeroStrip T).Finite ∧ ((zeroStrip T).ncard : ℝ) ≤ C * T * Real.log T) :
    Summable (fun ρ : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      Real.exp (-(σ ^ 2 * ρ.1.im ^ 2))) := by
  have hS1 := zeros_im_ge_one C hcount
  let s : ℕ → Set {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} :=
    fun k ρ => annulusIndex ρ.1 (hS1 ρ) = k
  have huniq : ∀ b, ∃! i, b ∈ s i := fun b => ⟨_, rfl, fun j hj => hj.symm⟩
  have hseq : s = annulusZeros := by
    funext i ρ
    apply propext
    dsimp only [s, annulusZeros]
    constructor
    · intro hρ
      have hspec := annulusIndex_spec ρ.1 (hS1 ρ)
      rw [hρ] at hspec
      exact hspec
    · intro hρ
      exact (annulusIndex_unique hρ).symm
  let e := Set.sigmaEquiv s huniq
  rw [← Equiv.summable_iff e]
  have hsig : ((fun ρ : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      Real.exp (-(σ ^ 2 * ρ.1.im ^ 2))) ∘ e) =
      (fun p : (Σ i, ↑(s i)) => Real.exp (-(σ ^ 2 * (p.2.1).1.im ^ 2))) := by
    funext p
    obtain ⟨i, y⟩ := p
    rfl
  rw [hsig]
  rw [summable_sigma_of_nonneg
    (f := fun p : (Σ i, ↑(s i)) => Real.exp (-(σ ^ 2 * (p.2.1).1.im ^ 2)))
    (fun p => (Real.exp_pos _).le)]
  constructor
  · intro i
    rw [hseq]
    exact (annulus_zeros_finite' C hcount σ i).summable
      (fun ρ : {ρ : ℂ // completedRiemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
        Real.exp (-(σ ^ 2 * ρ.1.im ^ 2)))
  · have hfun : (fun i => ∑' y : ↑(s i), Real.exp (-(σ ^ 2 * (y.1).1.im ^ 2)))
        = fun i => ∑' y : annulusZeros i, Real.exp (-(σ ^ 2 * (y.1).1.im ^ 2)) := by
      rw [hseq]
    rw [hfun]
    exact Summable.of_nonneg_of_le (fun i => by positivity)
      (fun i => annulus_zeros_tsum_le C hcount σ hσ i) (summable_annulus_majorant C σ hC hσ)

end ZeroSumConvergence
