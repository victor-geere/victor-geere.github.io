/-
# Geometric-zeta decompositions

Unconditional identities and structural facts about the geometric zeta functions
`g_a(s) = 1/(a^s − 1)`.  Nothing here uses, or proves, the Riemann hypothesis.

The two exact identities re-exported below are already in Mathlib:

* the Euler product `∏_p (1 − p^{-s})^{-1} = ζ(s)`;
* the Lambert identity `∑_k q^k/(1 − q^k) = ∑_n d(n) q^n`.

The new material is the zero-free-factor structure and the finite-product
impossibility: a geometric factor is zero-free wherever it is defined, a finite
Euler product is zero-free wherever it is defined, and no finite Euler product
can equal `ζ` (at `s = 1` it is finite while `ζ` has a pole).  This is the
analytic form of Euclid's theorem, and the structural reason zeros of `ζ` are a
collective effect of the infinite product, not a property of any finite stage.
-/
import Mathlib

noncomputable section
open Filter Topology MeasureTheory
open scoped BigOperators Topology Real

namespace GeometricZeta

/-- **G1. The Euler product.**  `ζ(s) = ∏_p (1 − p^{-s})^{-1}` for `Re s > 1`,
re-exported from Mathlib. -/
theorem eulerProduct (s : ℂ) (hs : 1 < s.re) :
    ∏' p : Nat.Primes, (1 - ((p : ℕ) : ℂ) ^ (-s))⁻¹ = riemannZeta s :=
  riemannZeta_eulerProduct_tprod hs

/-- **G3. The Lambert identity** at `k = 0`:
`Σ_{k≥1} q^k/(1 − q^k) = Σ_{n≥1} σ_0(n) q^n` for `‖q‖ < 1`, where
`σ_0(n)` is the number of divisors of `n`.  Re-exported from Mathlib's
`tsum_pow_div_one_sub_eq_tsum_sigma`. -/
theorem lambert_identity {q : ℂ} (hq : ‖q‖ < 1) :
    (∑' n : ℕ+, q ^ (n : ℕ) / (1 - q ^ (n : ℕ)))
      = ∑' n : ℕ+, (ArithmeticFunction.sigma 0 (n : ℕ) : ℂ) * q ^ (n : ℕ) := by
  simpa using tsum_pow_div_one_sub_eq_tsum_sigma (𝕜 := ℂ) hq 0

/-- **G3 (divisor-count form).**  The same identity with `d(n) = #(n.divisors)`. -/
theorem lambert_identity_divisors {q : ℂ} (hq : ‖q‖ < 1) :
    (∑' n : ℕ+, q ^ (n : ℕ) / (1 - q ^ (n : ℕ)))
      = ∑' n : ℕ+, (((n : ℕ).divisors.card : ℕ) : ℂ) * q ^ (n : ℕ) := by
  rw [lambert_identity hq]
  congr 1
  funext n
  rw [ArithmeticFunction.sigma_zero_apply]

/-- **G5. A geometric factor is zero-free wherever it is defined.**  The only
possible zero of the totalised function `(1 − a^{-s})^{-1}` is at a pole
`a^{-s} = 1`; away from those points the inverse is nonzero. -/
theorem geomFactor_ne_zero {a : ℕ} (_ha : 2 ≤ a) {s : ℂ}
    (h : (a : ℂ) ^ (-s) ≠ 1) : (1 - (a : ℂ) ^ (-s))⁻¹ ≠ 0 := by
  exact inv_ne_zero (sub_ne_zero.mpr (Ne.symm h))

/-- **G6. A finite Euler product is zero-free wherever it is defined.**  This is
the precise structural statement behind "zeros are a collective effect": no
finite stage of the Euler product can vanish. -/
theorem finiteEulerProduct_ne_zero (S : Finset ℕ) (hS : ∀ p ∈ S, 2 ≤ p)
    (s : ℂ) (h : ∀ p ∈ S, (p : ℂ) ^ (-s) ≠ 1) :
    (∏ p ∈ S, (1 - (p : ℂ) ^ (-s))⁻¹) ≠ 0 := by
  refine Finset.prod_ne_zero_iff.mpr ?_
  intro p hp
  exact geomFactor_ne_zero (hS p hp) (h p hp)


/-- **C3. No finite Euler product equals `ζ` on `Re s > 1`.**

A finite product `∏_{p∈S} (1 − p^{−s})^{−1}` is continuous at `s = 1` and takes a
finite value there, while `ζ` has a pole with residue `1`.  Along `s → 1⁺` the
product therefore stays finite, so the equality cannot hold.  This is the
analytic form of Euclid's theorem: the Euler product of `ζ` has infinitely many
factors. -/
theorem no_finite_euler_product (S : Finset ℕ) (hS : ∀ p ∈ S, p.Prime) :
    ¬ ∀ s : ℂ, 1 < s.re → riemannZeta s = ∏ p ∈ S, ((1 - (p : ℂ) ^ (-s))⁻¹) := by
  intro h
  let factor : ℕ → ℂ → ℂ := fun p s => (1 - (p : ℂ) ^ (-s))⁻¹
  let F : ℂ → ℂ := fun s => ∏ p ∈ S, factor p s
  have hval (p : ℕ) (hp : p ∈ S) : 1 - (p : ℂ) ^ (-(1 : ℂ)) ≠ 0 := by
    have hp1 : (p : ℂ) ≠ 1 := Nat.cast_ne_one.mpr (hS p hp).ne_one
    rw [Complex.cpow_neg_one]
    have hpne : (p : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (hS p hp).ne_zero
    intro hzero
    have hinv : (p : ℂ)⁻¹ = 1 := by linear_combination -hzero
    have : (p : ℂ) = 1 := by simpa [inv_eq_one] using hinv
    exact hp1 this
  have hFcont : ContinuousAt F 1 := by
    have hprod : Tendsto (fun s : ℂ => ∏ p ∈ S, factor p s)
        (𝓝 1) (𝓝 (∏ p ∈ S, factor p 1)) := by
      refine tendsto_finsetProd S ?_
      intro p hp
      have hpne : (p : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (hS p hp).ne_zero
      show Tendsto (factor p) (𝓝 1) (𝓝 (factor p 1))
      have hcp : ContinuousAt (fun s : ℂ => (p : ℂ) ^ (-s)) 1 := by
        have hbase : ContinuousAt (fun x : ℂ => (p : ℂ) ^ x) (-(1 : ℂ)) :=
          continuousAt_const_cpow (a := (p : ℂ)) hpne
        exact hbase.comp continuousAt_neg
      have hsub : ContinuousAt (fun s : ℂ => 1 - (p : ℂ) ^ (-s)) 1 :=
        continuousAt_const.sub hcp
      exact hsub.inv₀ (hval p hp)
    show ContinuousAt F 1
    change Tendsto (fun s : ℂ => ∏ p ∈ S, factor p s) (𝓝 1) (𝓝 (∏ p ∈ S, factor p 1))
    exact hprod
  have hζeq : (fun s : ℝ => riemannZeta (s : ℂ)) =ᶠ[𝓝[>] (1 : ℝ)]
      (fun s : ℝ => F (s : ℂ)) := by
    filter_upwards [self_mem_nhdsWithin] with s hs
    exact h (s : ℂ) (by simpa using hs)
  have hζlim : Tendsto (fun s : ℝ => riemannZeta (s : ℂ)) (𝓝[>] (1 : ℝ)) (𝓝 (F 1)) := by
    have hcomp : Tendsto (fun s : ℝ => F (s : ℂ)) (𝓝 (1 : ℝ)) (𝓝 (F 1)) :=
      hFcont.tendsto.comp (Complex.continuous_ofReal.tendsto 1)
    have hcomp' : Tendsto (fun s : ℝ => F (s : ℂ)) (𝓝[>] (1 : ℝ)) (𝓝 (F 1)) :=
      hcomp.mono_left nhdsWithin_le_nhds
    exact hcomp'.congr' hζeq.symm
  have hsubC : Tendsto (fun s : ℝ => ((s : ℂ) - 1)) (𝓝[>] (1 : ℝ)) (𝓝 0) := by
    have h1 : Tendsto (fun s : ℝ => (s : ℂ)) (𝓝[>] (1 : ℝ)) (𝓝 (1 : ℂ)) :=
      (Complex.continuous_ofReal.tendsto 1).mono_left nhdsWithin_le_nhds
    have hconst : Tendsto (fun _ : ℝ => (1 : ℂ)) (𝓝[>] (1 : ℝ)) (𝓝 1) :=
      tendsto_const_nhds
    simpa using h1.sub hconst
  have hzero : Tendsto (fun s : ℝ => ((s : ℂ) - 1) * riemannZeta (s : ℂ))
      (𝓝[>] (1 : ℝ)) (𝓝 (0 * F 1)) :=
    hsubC.mul hζlim
  have hmap : Tendsto (fun s : ℝ => (s : ℂ)) (𝓝[>] (1 : ℝ)) (𝓝[≠] (1 : ℂ)) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · exact (Complex.continuous_ofReal.tendsto 1).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with s hs
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      exact_mod_cast ne_of_gt hs
  have hpole : Tendsto (fun s : ℝ => ((s : ℂ) - 1) * riemannZeta (s : ℂ))
      (𝓝[>] (1 : ℝ)) (𝓝 1) :=
    riemannZeta_residue_one.comp hmap
  have hcontra : (1 : ℂ) = 0 * F 1 := tendsto_nhds_unique hpole hzero
  norm_num at hcontra

/-- **G7. The all-bases geometric sum at `s = 2`.**
`Σ_{a≥1} 1/(a(a+2)) = 3/4`; equivalently
`1 + Σ_{a≥1} 1/((a+1)^2 − 1) = 7/4`.  This is the *all-bases* sum, not `ζ(2)`:
it telescopes, and it is rational, whereas `ζ(2) = π²/6`.  The contrast is the
numerical form of the statement that the non-perfect-power index set is
essential. -/
theorem all_bases_sum :
    (∑' a : ℕ+, (1 : ℝ) / ((a : ℝ) * ((a : ℝ) + 2))) = 3 / 4 := by
  let f : ℕ → ℝ := fun n => (1 : ℝ) / ((n : ℝ) * ((n : ℝ) + 2))
  let g : ℕ → ℝ := fun n => (1 : ℝ) / ((n : ℝ) + 1) - 1 / ((n : ℝ) + 3)
  have hg_nonneg : ∀ n : ℕ, 0 ≤ g n := by
    intro n
    have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
    have h3 : (0 : ℝ) < (n : ℝ) + 3 := by positivity
    have hle : (1 : ℝ) / ((n : ℝ) + 3) ≤ 1 / ((n : ℝ) + 1) := by
      apply div_le_div_of_nonneg_left <;> linarith
    linarith
  have hpart : ∀ N : ℕ,
      ∑ n ∈ Finset.range N, g n =
        (1 : ℝ) + 1 / 2 - 1 / ((N : ℝ) + 1) - 1 / ((N : ℝ) + 2) := by
    intro N
    induction N with
    | zero => norm_num
    | succ N ih =>
      rw [Finset.sum_range_succ, ih]
      simp only [g]
      push_cast
      field_simp
      ring
  have hg_tendsto : Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, g n) atTop (𝓝 (3 / 2)) := by
    have h1 : Tendsto (fun N : ℕ => (1 : ℝ) / ((N : ℝ) + 1)) atTop (𝓝 0) :=
      tendsto_one_div_add_atTop_nhds_zero_nat
    have h2 : Tendsto (fun N : ℕ => (1 : ℝ) / ((N : ℝ) + 2)) atTop (𝓝 0) := by
      have h := (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).comp
        (tendsto_add_atTop_nat 1)
      have h' : Tendsto (fun N : ℕ => (1 : ℝ) / (((N + 1 : ℕ) : ℝ) + 1)) atTop (𝓝 0) := h
      have hfun : (fun N : ℕ => (1 : ℝ) / (((N + 1 : ℕ) : ℝ) + 1)) =
          fun N : ℕ => (1 : ℝ) / ((N : ℝ) + 2) := by
        funext N
        push_cast
        ring
      rw [hfun] at h'
      exact h' 
    have hc : Tendsto (fun _ : ℕ => (1 : ℝ) + 1 / 2) atTop (𝓝 ((1 : ℝ) + 1 / 2)) :=
      tendsto_const_nhds
    have hlim := (hc.sub h1).sub h2
    have hlim' : Tendsto (fun N : ℕ =>
        (1 : ℝ) + 1 / 2 - 1 / ((N : ℝ) + 1) - 1 / ((N : ℝ) + 2)) atTop (𝓝 (3 / 2)) := by
      convert hlim using 1
      norm_num
    simpa [hpart] using hlim'
  have hg_hasSum : HasSum g (3 / 2) := by
    rw [hasSum_iff_tendsto_nat_of_nonneg hg_nonneg]
    exact hg_tendsto
  have hf_eq : (fun n : ℕ => f (n + 1)) = fun n => (1 / 2 : ℝ) * g n := by
    funext n
    simp only [f, g]
    push_cast
    field_simp
    ring
  have hf_hasSum : HasSum (fun n : ℕ => f (n + 1)) (3 / 4) := by
    rw [hf_eq]
    have := hg_hasSum.mul_left (1 / 2 : ℝ)
    convert this using 1
    norm_num
  rw [tsum_pnat_eq_tsum_succ (f := f)]
  exact hf_hasSum.tsum_eq

/-- **G7 (geometric form).**  `1 + Σ_{a≥1} 1/((a+1)^2 − 1) = 7/4`. -/
theorem all_bases_geometric_sum :
    (1 : ℝ) + (∑' a : ℕ+, (1 : ℝ) / ((((a : ℝ) + 1) ^ 2) - 1)) = 7 / 4 := by
  have h : (∑' a : ℕ+, (1 : ℝ) / ((((a : ℝ) + 1) ^ 2) - 1))
      = ∑' a : ℕ+, (1 : ℝ) / ((a : ℝ) * ((a : ℝ) + 2)) := by
    apply tsum_congr
    intro a
    congr 1
    ring
  rw [h, all_bases_sum]
  norm_num


theorem divisor_hasSum (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun n : ℕ => (ArithmeticFunction.sigma 0 n : ℂ) / (n : ℂ) ^ s)
      (riemannZeta s * riemannZeta s) := by
  let ζC : ArithmeticFunction ℂ := ArithmeticFunction.zeta
  have hζ : LSeriesHasSum (ζC : ℕ → ℂ) s (riemannZeta s) :=
    ArithmeticFunction.LSeriesHasSum_zeta hs
  have hmul := ArithmeticFunction.LSeriesHasSum_mul (f := ζC) (g := ζC) hζ hζ
  have hσnat : ArithmeticFunction.zeta * ArithmeticFunction.zeta =
      ArithmeticFunction.sigma 0 := by
    calc ArithmeticFunction.zeta * ArithmeticFunction.zeta
        = ArithmeticFunction.zeta * ArithmeticFunction.pow 0 := by
          rw [ArithmeticFunction.pow_zero_eq_zeta]
      _ = ArithmeticFunction.sigma 0 := ArithmeticFunction.zeta_mul_pow_eq_sigma
  have hσC : (ζC * ζC : ArithmeticFunction ℂ) = (ArithmeticFunction.sigma 0 : ArithmeticFunction ℂ) := by
    rw [← ArithmeticFunction.natCoe_mul, hσnat]
  rw [hσC] at hmul
  change HasSum (fun n : ℕ => (ArithmeticFunction.sigma 0 n : ℂ) / (n : ℂ) ^ s)
    (riemannZeta s * riemannZeta s)
  rw [show (fun n : ℕ => (ArithmeticFunction.sigma 0 n : ℂ) / (n : ℂ) ^ s)
      = LSeries.term (fun n => (ArithmeticFunction.sigma 0 n : ℂ)) s from by
    funext n
    rw [LSeries.term]
    split_ifs with hn
    · simp [hn]
    · rfl]
  exact hmul

theorem divisor_summable (s : ℂ) (hs : 1 < s.re) :
    Summable (fun n : ℕ => ‖(ArithmeticFunction.sigma 0 n : ℂ) / (n : ℂ) ^ s‖) := by
  let ζC : ArithmeticFunction ℂ := ArithmeticFunction.zeta
  have hζ : LSeriesHasSum (ζC : ℕ → ℂ) s (riemannZeta s) :=
    ArithmeticFunction.LSeriesHasSum_zeta hs
  have hmul := ArithmeticFunction.LSeriesHasSum_mul (f := ζC) (g := ζC) hζ hζ
  have hσnat : ArithmeticFunction.zeta * ArithmeticFunction.zeta =
      ArithmeticFunction.sigma 0 := by
    calc ArithmeticFunction.zeta * ArithmeticFunction.zeta
        = ArithmeticFunction.zeta * ArithmeticFunction.pow 0 := by
          rw [ArithmeticFunction.pow_zero_eq_zeta]
      _ = ArithmeticFunction.sigma 0 := ArithmeticFunction.zeta_mul_pow_eq_sigma
  have hσC : (ζC * ζC : ArithmeticFunction ℂ) = (ArithmeticFunction.sigma 0 : ArithmeticFunction ℂ) := by
    rw [← ArithmeticFunction.natCoe_mul, hσnat]
  rw [hσC] at hmul
  have h := hmul.LSeriesSummable.norm
  change Summable (fun n : ℕ => ‖(ArithmeticFunction.sigma 0 n : ℂ) / (n : ℂ) ^ s‖)
  rw [show (fun n : ℕ => ‖(ArithmeticFunction.sigma 0 n : ℂ) / (n : ℂ) ^ s‖)
      = fun n : ℕ => ‖LSeries.term (fun n => (ArithmeticFunction.sigma 0 n : ℂ)) s n‖ from by
    funext n
    rw [LSeries.term]
    split_ifs with hn
    · simp [hn]
    · rfl]
  exact h

theorem lambert_mellin (s : ℂ) (hs : 1 < s.re) :
    mellin (fun t : ℝ => ∑' n : ℕ,
      (ArithmeticFunction.sigma 0 n : ℂ) * (Real.exp (-(n : ℝ) * t) : ℂ)) s
      = Complex.Gamma s * (riemannZeta s * riemannZeta s) := by
  let d : ℕ → ℂ := fun n => (ArithmeticFunction.sigma 0 n : ℂ)
  let F : ℝ → ℂ := fun t => ∑' n : ℕ, d n * (Real.exp (-(n : ℝ) * t) : ℂ)
  have hs0 : s ≠ 0 := by intro h; rw [h] at hs; norm_num at hs
  have hdiv := divisor_hasSum s hs
  have hsum_div := divisor_summable s hs
  have h_sum : Summable (fun n : ℕ => ‖d n‖ / (n : ℝ) ^ s.re) := by
    refine hsum_div.congr (fun n => ?_)
    rcases Nat.eq_zero_or_pos n with hn | hn
    · subst hn; simp [d]
    · have hnR : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
      rw [norm_div]
      have hd : ‖d n‖ = (ArithmeticFunction.sigma 0 n : ℝ) := by simp [d]
      rw [hd]
      congr 1
      have hcast : (n : ℂ) = ((n : ℝ) : ℂ) := by push_cast; rfl
      rw [hcast, Complex.norm_cpow_eq_rpow_re_of_pos hnR]
  have hFsum : ∀ t : ℝ, 0 < t → Summable (fun n : ℕ => d n * (Real.exp (-(n : ℝ) * t) : ℂ)) := by
    intro t ht
    have hr : ‖(Real.exp (-t) : ℝ)‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      linarith
    have hgeom : Summable (fun n : ℕ => (n : ℝ) * (Real.exp (-t)) ^ n) := by
      have h := summable_norm_pow_mul_geometric_of_norm_lt_one (k := 1) (r := (Real.exp (-t) : ℝ)) hr
      simpa [Real.norm_eq_abs, abs_of_nonneg, Nat.cast_nonneg, Real.exp_nonneg] using h
    have hbound : ∀ n : ℕ, ‖d n * (Real.exp (-(n : ℝ) * t) : ℂ)‖ ≤
        (n : ℝ) * (Real.exp (-t)) ^ n := by
      intro n
      have hd : ‖d n‖ ≤ (n : ℝ) := by
        simp only [d, Complex.norm_natCast]
        have hd' : ArithmeticFunction.sigma 0 n ≤ n := by
          rw [ArithmeticFunction.sigma_zero_apply]
          exact Nat.card_divisors_le_self n
        exact_mod_cast hd' 
      have hpow : Real.exp (-(n : ℝ) * t) = (Real.exp (-t)) ^ n := by
        rw [← Real.exp_nat_mul]
        congr 1
        ring
      rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, Real.abs_exp, hpow]
      exact mul_le_mul_of_nonneg_right hd (by positivity)
    exact Summable.of_norm_bounded hgeom hbound
  have hF : ∀ t ∈ Set.Ioi (0:ℝ), HasSum (fun n : ℕ => d n * (Real.exp (-(n : ℝ) * t) : ℂ)) (F t) := by
    intro t ht
    exact (hFsum t ht).hasSum
  have hp : ∀ n : ℕ, d n = 0 ∨ 0 < (n : ℝ) := by
    intro n
    rcases Nat.eq_zero_or_pos n with hn | hn
    · left; subst hn; simp [d]
    · right; exact_mod_cast hn
  have hs' : 0 < s.re := by linarith
  have hmellin := hasSum_mellin (a := d) (p := fun n : ℕ => (n : ℝ)) (F := F) (s := s)
    hp hs' hF h_sum
  have hdivΓ := hdiv.mul_left (Complex.Gamma s)
  have hfun : (fun n : ℕ => Complex.Gamma s * d n / ((n : ℝ) : ℂ) ^ s)
      = fun n : ℕ => Complex.Gamma s * (d n / (n : ℂ) ^ s) := by
    funext n
    rcases Nat.eq_zero_or_pos n with hn | hn
    · subst hn
      simp [d, Complex.zero_cpow hs0]
    · have hnC : ((n : ℝ) : ℂ) = (n : ℂ) := by push_cast; rfl
      rw [hnC, mul_div_assoc]
  rw [hfun] at hmellin
  exact hmellin.unique hdivΓ

/-- **G5 (divisor-count form).**  The same Mellin identity written with the divisor
count `d(n) = #(n.divisors)` instead of `σ_0(n)`. -/
theorem lambert_mellin_divisors (s : ℂ) (hs : 1 < s.re) :
    mellin (fun t : ℝ => ∑' n : ℕ,
      (((n.divisors.card : ℕ) : ℂ)) * (Real.exp (-(n : ℝ) * t) : ℂ)) s
      = Complex.Gamma s * (riemannZeta s * riemannZeta s) := by
  have hfun : (fun t : ℝ => ∑' n : ℕ,
        (((n.divisors.card : ℕ) : ℂ)) * (Real.exp (-(n : ℝ) * t) : ℂ))
      = fun t : ℝ => ∑' n : ℕ,
        (ArithmeticFunction.sigma 0 n : ℂ) * (Real.exp (-(n : ℝ) * t) : ℂ) := by
    funext t
    congr 1
    funext n
    rw [ArithmeticFunction.sigma_zero_apply]
  rw [hfun]
  exact lambert_mellin s hs


/-- The pointwise AM–GM majorant for the Lambert series:
`Σ_{k,m≥1} e^{-km u²} ≥ (Σ_{k≥1} e^{-k²u²/2})²`. -/
theorem lambert_majorant (u : ℝ) (hu : 0 < u) :
    (∑' p : ℕ+ × ℕ+, Real.exp (-(((p.1 : ℝ) * (p.2 : ℝ)) * u ^ 2)))
      ≥ (∑' k : ℕ+, Real.exp (-(((k : ℝ) ^ 2) * u ^ 2 / 2))) ^ 2 := by
  set r : ℝ := Real.exp (-(u ^ 2 / 2)) with hr_def
  have hr0 : 0 ≤ r := (Real.exp_pos _).le
  have hr1 : r < 1 := by
    rw [hr_def, Real.exp_lt_one_iff]
    nlinarith [sq_pos_of_pos hu]
  have hrn : ‖r‖ < 1 := by simpa [Real.norm_eq_abs, abs_of_nonneg hr0] using hr1
  have hS_nat : Summable (fun n : ℕ => r ^ n) := summable_geometric_of_norm_lt_one hrn
  have hS : Summable (fun k : ℕ+ => r ^ (k : ℕ)) := by
    rw [summable_pnat_iff_summable_succ (f := fun n : ℕ => r ^ n)]
    simpa [pow_succ] using hS_nat.mul_right r
  have hS2 : Summable (fun k : ℕ+ => r ^ ((k : ℕ) ^ 2)) := by
    refine Summable.of_nonneg_of_le (fun k => pow_nonneg hr0 _) ?_ hS
    intro k
    have hk : (1 : ℕ) ≤ (k : ℕ) := k.pos
    have hle : (k : ℕ) ≤ (k : ℕ) ^ 2 := by nlinarith
    exact pow_le_pow_of_le_one hr0 (le_of_lt hr1) hle
  have hexp2 : ∀ k : ℕ+, Real.exp (-(((k : ℝ) ^ 2) * u ^ 2 / 2)) = r ^ ((k : ℕ) ^ 2) := by
    intro k
    rw [hr_def, ← Real.exp_nat_mul]
    congr 1
    push_cast
    ring
  have hdom : Summable (fun p : ℕ+ × ℕ+ => r ^ ((p.1 : ℕ) + (p.2 : ℕ))) := by
    rw [summable_prod_of_nonneg (f := fun p : ℕ+ × ℕ+ => r ^ ((p.1 : ℕ) + (p.2 : ℕ)))
      (fun p => pow_nonneg hr0 _)]
    constructor
    · intro k
      have hfun : (fun m : ℕ+ => r ^ ((k : ℕ) + (m : ℕ))) = fun m : ℕ+ =>
          r ^ (k : ℕ) * r ^ (m : ℕ) := by
        funext m; rw [pow_add]
      rw [hfun]
      exact hS.mul_left (r ^ (k : ℕ))
    · have hfun : (fun k : ℕ+ => ∑' m : ℕ+, r ^ ((k : ℕ) + (m : ℕ))) =
          fun k : ℕ+ => r ^ (k : ℕ) * (∑' m : ℕ+, r ^ (m : ℕ)) := by
        funext k
        rw [← tsum_mul_left]
        congr 1; funext m; rw [pow_add]
      rw [hfun]
      exact hS.mul_right _
  have hL : Summable (fun p : ℕ+ × ℕ+ => r ^ (2 * (p.1 : ℕ) * (p.2 : ℕ))) := by
    refine Summable.of_nonneg_of_le (fun p => pow_nonneg hr0 _) ?_ hdom
    intro p
    apply pow_le_pow_of_le_one hr0 (le_of_lt hr1)
    have h1 : (1 : ℕ) ≤ (p.1 : ℕ) := p.1.pos
    have h2 : (1 : ℕ) ≤ (p.2 : ℕ) := p.2.pos
    nlinarith
  have hB : Summable (fun p : ℕ+ × ℕ+ => r ^ (((p.1 : ℕ) ^ 2) + ((p.2 : ℕ) ^ 2))) := by
    refine Summable.of_nonneg_of_le (fun p => pow_nonneg hr0 _) ?_ hdom
    intro p
    apply pow_le_pow_of_le_one hr0 (le_of_lt hr1)
    have h1 : (1 : ℕ) ≤ (p.1 : ℕ) := p.1.pos
    have h2 : (1 : ℕ) ≤ (p.2 : ℕ) := p.2.pos
    nlinarith
  have hprod : Summable (fun p : ℕ+ × ℕ+ => r ^ ((p.1 : ℕ) ^ 2) * r ^ ((p.2 : ℕ) ^ 2)) := by
    convert hB using 1
    funext p
    rw [← pow_add]
  have hmain : (∑' p : ℕ+ × ℕ+, Real.exp (-(((p.1 : ℝ) * (p.2 : ℝ)) * u ^ 2)))
      ≥ ∑' p : ℕ+ × ℕ+, Real.exp (-((((p.1 : ℝ) ^ 2) + ((p.2 : ℝ) ^ 2)) * u ^ 2 / 2)) := by
    refine Summable.tsum_le_tsum ?_ ?_ ?_
    · intro p
      apply Real.exp_le_exp.mpr
      have h1 : (0:ℝ) ≤ ((p.1 : ℝ) - (p.2 : ℝ)) ^ 2 := sq_nonneg _
      nlinarith
    · convert hB using 1
      funext p
      rw [hr_def, ← Real.exp_nat_mul]
      congr 1
      push_cast
      ring_nf
    · convert hL using 1
      funext p
      rw [hr_def, ← Real.exp_nat_mul]
      congr 1
      push_cast
      ring_nf
  have hsquare : (∑' p : ℕ+ × ℕ+, Real.exp (-((((p.1 : ℝ) ^ 2) + ((p.2 : ℝ) ^ 2)) * u ^ 2 / 2)))
      = (∑' k : ℕ+, Real.exp (-(((k : ℝ) ^ 2) * u ^ 2 / 2))) ^ 2 := by
    have hfac : (fun p : ℕ+ × ℕ+ => Real.exp (-((((p.1 : ℝ) ^ 2) + ((p.2 : ℝ) ^ 2)) * u ^ 2 / 2)))
        = fun p : ℕ+ × ℕ+ =>
          Real.exp (-(((p.1 : ℝ) ^ 2) * u ^ 2 / 2)) * Real.exp (-(((p.2 : ℝ) ^ 2) * u ^ 2 / 2)) := by
      funext p
      rw [← Real.exp_add]
      congr 1
      ring
    rw [hfac]
    have hSexp : Summable (fun k : ℕ+ => Real.exp (-(((k : ℝ) ^ 2) * u ^ 2 / 2))) :=
      hS2.congr (fun k => (hexp2 k).symm)
    have hprod2 : Summable (fun p : ℕ+ × ℕ+ =>
        Real.exp (-(((p.1 : ℝ) ^ 2) * u ^ 2 / 2)) * Real.exp (-(((p.2 : ℝ) ^ 2) * u ^ 2 / 2))) :=
      hprod.congr (fun p => by rw [hexp2 p.1, hexp2 p.2])
    rw [← hSexp.tsum_mul_tsum hSexp hprod2]
    ring
  rw [← hsquare]
  exact hmain

theorem gaussian_moment {σ a : ℝ} (hσ : 0 < σ) (ha : 0 < a) :
    ∫ u : ℝ in Set.Ioi 0, u ^ (2 * σ - 1) * Real.exp (-(a * u ^ (2:ℝ)))
      = (1 / 2) * Real.Gamma σ * a ^ (-σ) := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have h0 := MeasureTheory.integral_comp_rpow_Ioi_of_pos
    (g := fun y : ℝ => (1 / 2) * y ^ (σ - 1) * Real.exp (-(a * y))) (p := 2) h2
  have h : (∫ x : ℝ in Set.Ioi 0,
      2 * x ^ ((2:ℝ) - 1) * ((1 / 2) * (x ^ (2:ℝ)) ^ (σ - 1) * Real.exp (-(a * x ^ (2:ℝ)))))
      = ∫ y : ℝ in Set.Ioi 0, (1 / 2) * y ^ (σ - 1) * Real.exp (-(a * y)) := by
    simpa only [smul_eq_mul] using h0
  have hL : (∫ x : ℝ in Set.Ioi 0,
      2 * x ^ ((2:ℝ) - 1) * ((1 / 2) * (x ^ (2:ℝ)) ^ (σ - 1) * Real.exp (-(a * x ^ (2:ℝ)))))
      = ∫ x : ℝ in Set.Ioi 0, x ^ (2 * σ - 1) * Real.exp (-(a * x ^ (2:ℝ))) := by
    apply setIntegral_congr_fun measurableSet_Ioi
    intro x hx
    change 2 * x ^ ((2:ℝ) - 1) * ((1 / 2) * (x ^ (2:ℝ)) ^ (σ - 1) * Real.exp (-(a * x ^ (2:ℝ)))) =
      x ^ (2 * σ - 1) * Real.exp (-(a * x ^ (2:ℝ)))
    have hx0 : 0 < x := hx
    have hpow : (x ^ (2:ℝ)) ^ (σ - 1) = x ^ (2 * (σ - 1)) := by
      rw [← Real.rpow_mul hx0.le]
    rw [show x ^ ((2:ℝ) - 1) = x by rw [show (2:ℝ) - 1 = 1 by norm_num, Real.rpow_one]]
    rw [hpow]
    have hxpow : x * x ^ (2 * (σ - 1)) = x ^ (2 * σ - 1) := by
      nth_rewrite 1 [show x = x ^ (1:ℝ) by rw [Real.rpow_one]]
      rw [← Real.rpow_add hx0]
      congr 1
      ring
    calc 2 * x * ((1 / 2) * x ^ (2 * (σ - 1)) * Real.exp (-(a * x ^ (2:ℝ))))
        = (x * x ^ (2 * (σ - 1))) * Real.exp (-(a * x ^ (2:ℝ))) := by ring
      _ = x ^ (2 * σ - 1) * Real.exp (-(a * x ^ (2:ℝ))) := by rw [hxpow]
  have hR : (∫ y : ℝ in Set.Ioi 0, (1 / 2) * y ^ (σ - 1) * Real.exp (-(a * y)))
      = (1 / 2) * Real.Gamma σ * a ^ (-σ) := by
    rw [show (∫ y : ℝ in Set.Ioi 0, (1 / 2) * y ^ (σ - 1) * Real.exp (-(a * y)))
        = (1 / 2) * ∫ y : ℝ in Set.Ioi 0, y ^ (σ - 1) * Real.exp (-(a * y)) by
          rw [← integral_const_mul]
          congr 1; funext y; ring]
    rw [Real.integral_rpow_mul_exp_neg_mul_Ioi hσ ha]
    have hdiv : (1 / a) ^ σ = a ^ (-σ) := by
      rw [Real.div_rpow (by norm_num : (0:ℝ) ≤ 1) ha.le, Real.one_rpow, Real.rpow_neg ha.le]
      exact one_div _
    rw [hdiv]
    ring
  calc ∫ u : ℝ in Set.Ioi 0, u ^ (2 * σ - 1) * Real.exp (-(a * u ^ (2:ℝ)))
      = ∫ x : ℝ in Set.Ioi 0,
          2 * x ^ ((2:ℝ) - 1) * ((1 / 2) * (x ^ (2:ℝ)) ^ (σ - 1) * Real.exp (-(a * x ^ (2:ℝ)))) := hL.symm
    _ = ∫ y : ℝ in Set.Ioi 0, (1 / 2) * y ^ (σ - 1) * Real.exp (-(a * y)) := h
    _ = (1 / 2) * Real.Gamma σ * a ^ (-σ) := hR

theorem lambert_eq_double {q : ℂ} (hq : ‖q‖ < 1) :
    (∑' n : ℕ+, (ArithmeticFunction.sigma 0 (n : ℕ) : ℂ) * q ^ (n : ℕ))
      = ∑' p : ℕ+ × ℕ+, q ^ ((p.1 : ℕ) * (p.2 : ℕ)) := by
  have h := tsum_prod_pow_eq_tsum_sigma (𝕜 := ℂ) (k := 0) hq
  rw [← h]
  rw [← Summable.tsum_prod (summable_prod_mul_pow (𝕜 := ℂ) 0 hq)]
  simp


/-- **Gaussian/Mellin power identity.**  For `x > 0` and complex `s`,
`((x : ℂ)^2)^(s−1) = (x : ℂ)^(2(s−1))`.  This is the complex-power identity
needed to rewrite `(u²)^{s−1}` in the Mellin substitution `t = u²`. -/
lemma cpow_sq (x : ℝ) (hx : 0 < x) (s : ℂ) :
    (((x : ℂ) ^ 2) ^ (s - 1)) = (x : ℂ) ^ (2 * (s - 1)) := by
  have harg : (x : ℂ).arg = 0 := Complex.arg_ofReal_of_nonneg hx.le
  rw [← Complex.cpow_nat_mul' (x := (x : ℂ)) (n := 2) (y := s - 1) ?hlt ?hle]
  · ring_nf
  · rw [harg]; linarith [Real.pi_pos]
  · rw [harg]; linarith [Real.pi_pos]

end GeometricZeta
