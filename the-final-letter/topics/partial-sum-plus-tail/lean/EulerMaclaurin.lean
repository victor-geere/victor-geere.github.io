import Mathlib
import Mathlib.NumberTheory.LSeries.HurwitzZeta

/-!
# Euler–Maclaurin layer — S1–S2

This file formalises the written proof in
`notes/euler-maclaurin-proof.md` for the non-periodic Hurwitz zeta.

It contains:

* `periodicBernoulli`, the periodic Bernoulli function on `ℝ`, and its
  elementary laws;
* `hurwitzZetaNP`, a non-periodic Hurwitz zeta built from Mathlib's periodic
  `HurwitzZeta.hurwitzZeta`, with its series representation for `Re s > 1`,
  differentiability and iterated derivatives;
* the general finite Euler–Maclaurin identity for smooth functions
  (`finite_eulerMaclaurin`) and for the Hurwitz term
  (`finite_eulerMaclaurin_hurwitz`);
* Fourier inversion and the Bernoulli supremum bound
  (`hasSum_periodicBernoulli_fourier`,
  `iSup_norm_periodicBernoulli_odd_le_zeta`);
* the S1 decomposition (`hurwitzZetaNP_eq_eulerMaclaurin`) and the combined
  S1/S2 theorem with the explicit tail bound for `K ≥ 1`
  (`hurwitzZetaNP_eulerMaclaurin_with_bound`).

No `sorry`, `axiom` or `admit` is used.
-/

noncomputable section

set_option maxHeartbeats 1000000

open scoped BigOperators
open MeasureTheory
open Filter
open Real
open Polynomial

namespace PartialTail

/-! ## Periodic Bernoulli functions -/

/-- The periodic Bernoulli function `B̃_n(x) = B_n({x})`, with the Bernoulli
polynomial evaluated over `ℝ`. -/
noncomputable def periodicBernoulli (n : ℕ) (x : ℝ) : ℝ :=
  Polynomial.eval₂ (algebraMap ℚ ℝ) (Int.fract x) (Polynomial.bernoulli n)

@[simp]
theorem periodicBernoulli_add_one (n : ℕ) (x : ℝ) :
    periodicBernoulli n (x + 1) = periodicBernoulli n x := by
  simp [periodicBernoulli, Int.fract_add_one]

@[simp]
theorem periodicBernoulli_zero (x : ℝ) : periodicBernoulli 0 x = 1 := by
  simp [periodicBernoulli, Polynomial.bernoulli_zero]

/-- At integers the periodic Bernoulli function is the Bernoulli number. -/
theorem periodicBernoulli_intCast (n : ℕ) (m : ℤ) :
    periodicBernoulli n (m : ℝ) = (_root_.bernoulli n : ℝ) := by
  rw [periodicBernoulli, Int.fract_intCast, Polynomial.eval₂_eq_eval_map]
  rw [Polynomial.eval_map]
  rw [show (0 : ℝ) = algebraMap ℚ ℝ 0 by simp]
  rw [Polynomial.eval₂_at_apply, Polynomial.bernoulli_eval_zero]
  simp

/-! ## A non-periodic Hurwitz zeta -/

/-- The non-periodic Hurwitz zeta, for `a > 0`, obtained from the periodic
Mathlib `HurwitzZeta.hurwitzZeta` by subtracting the integer part:
`ζ(s,a) = ζ(s,{a}) − Σ_{k<⌊a⌋} ({a}+k)^{-s}`. -/
noncomputable def hurwitzZetaNP (a : ℝ) (s : ℂ) : ℂ :=
  HurwitzZeta.hurwitzZeta (↑(Int.fract a) : UnitAddCircle) s -
    ∑ k ∈ Finset.range (Int.floor a).toNat,
      ((((Int.fract a + k : ℝ) : ℂ))) ^ (-s)

/-- For `0 ≤ a < 1` the non-periodic definition is exactly Mathlib's periodic
one. -/
theorem hurwitzZetaNP_eq_hurwitzZeta_of_mem_Ico {a : ℝ} (ha0 : 0 ≤ a) (ha1 : a < 1)
    (s : ℂ) :
    hurwitzZetaNP a s = HurwitzZeta.hurwitzZeta a s := by
  have hfloor : Int.floor a = 0 := by
    rw [Int.floor_eq_zero_iff]
    exact ⟨ha0, ha1⟩
  rw [hurwitzZetaNP, hfloor, Int.fract_eq_self.mpr ⟨ha0, ha1⟩]
  simp

/-- For `a > 0` and `Re s > 1`, the non-periodic definition is the ordinary
Hurwitz series `∑ (n + a)^{-s}`. -/
theorem hurwitzZetaNP_eq_tsum {a : ℝ} (ha : 0 < a) {s : ℂ} (hs : 1 < s.re) :
    hurwitzZetaNP a s = tsum (fun n : ℕ => 1 / ((n : ℂ) + (a : ℂ)) ^ s) := by
  let r : ℝ := Int.fract a
  let m : ℕ := (Int.floor a).toNat
  have hm : (m : ℤ) = Int.floor a := Int.toNat_of_nonneg (Int.floor_nonneg.mpr ha.le)
  have hmR : (m : ℝ) = (Int.floor a : ℝ) := by exact_mod_cast hm
  have hma : (m : ℝ) + r = a := by
    rw [hmR]
    exact Int.floor_add_fract a
  have hr : r ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨Int.fract_nonneg a, (Int.fract_lt_one a).le⟩
  let f : ℕ → ℂ := fun n => 1 / ((n : ℂ) + (r : ℂ)) ^ s
  have hsum : HasSum f (HurwitzZeta.hurwitzZeta (↑r : UnitAddCircle) s) :=
    HurwitzZeta.hasSum_hurwitzZeta_of_one_lt_re hr hs
  have hf : Summable f := hsum.summable
  have hsplit := hf.sum_add_tsum_nat_add m
  have hterm (k : ℕ) : (((r + k : ℝ) : ℂ)) ^ (-s) = f k := by
    rw [show (((r + k : ℝ) : ℂ)) = ((k : ℂ) + (r : ℂ)) by push_cast; ring]
    rw [Complex.cpow_neg]
    simp [f]
  have hfinite : (∑ k ∈ Finset.range m, (((r + k : ℝ) : ℂ)) ^ (-s)) =
      ∑ k ∈ Finset.range m, f k := by
    apply Finset.sum_congr rfl
    intro k hk
    exact hterm k
  have hzeta : HurwitzZeta.hurwitzZeta (↑r : UnitAddCircle) s = ∑' n, f n :=
    hsum.tsum_eq.symm
  have hshift : ∑' n, f (n + m) = tsum (fun n : ℕ => 1 / ((n : ℂ) + (a : ℂ)) ^ s) := by
    apply tsum_congr (f := fun n : ℕ => f (n + m))
      (g := fun n : ℕ => 1 / ((n : ℂ) + (a : ℂ)) ^ s)
    intro n
    change 1 / ((((n + m : ℕ) : ℂ) + (r : ℂ)) ^ s) =
      1 / ((n : ℂ) + (a : ℂ)) ^ s
    have hden : (((n + m : ℕ) : ℂ) + (r : ℂ)) = ((n : ℂ) + (a : ℂ)) := by
      rw [← hma]
      push_cast
      ring
    rw [hden]
  calc
    hurwitzZetaNP a s = HurwitzZeta.hurwitzZeta (↑r : UnitAddCircle) s -
        ∑ k ∈ Finset.range m, (((r + k : ℝ) : ℂ)) ^ (-s) := by
      simp [hurwitzZetaNP, r, m]
    _ = ∑' n, f n - ∑ k ∈ Finset.range m, f k := by rw [hzeta, hfinite]
    _ = ∑' n, f (n + m) := by
      rw [← hsplit]
      abel
    _ = tsum (fun n : ℕ => 1 / ((n : ℂ) + (a : ℂ)) ^ s) := hshift


lemma pb1_ae (f : ℝ → ℂ) (k : ℕ) :
    (fun x : ℝ => (periodicBernoulli 1 x : ℂ) * deriv f x) =ᵐ[
      volume.restrict (Set.uIoc (k : ℝ) ((k : ℝ) + 1))]
      (fun x : ℝ => ((x - k - 1 / 2 : ℝ) : ℂ) * deriv f x) := by
  rw [Filter.EventuallyEq, MeasureTheory.ae_restrict_iff' measurableSet_uIoc]
  filter_upwards [(Set.countable_singleton ((k : ℝ) + 1)).ae_notMem volume] with x hx hmem
  rw [Set.uIoc_of_le (by linarith : (k : ℝ) ≤ (k : ℝ) + 1)] at hmem
  have hxne : x ≠ (k : ℝ) + 1 := by simpa using hx
  have hxI : x ∈ Set.Ioo (k : ℝ) ((k : ℝ) + 1) := ⟨hmem.1, lt_of_le_of_ne hmem.2 hxne⟩
  have hfrac : Int.fract x = x - k := by
    have h0 : 0 ≤ x - k := by linarith [hxI.1]
    have h1 : x - k < 1 := by linarith [hxI.2]
    rw [← Int.fract_sub_natCast x k, Int.fract_eq_self.mpr ⟨h0, h1⟩]
  simp [periodicBernoulli, Polynomial.bernoulli_one, hfrac]

lemma local_ibp (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f) (k : ℕ) :
    ∫ x in (k : ℝ)..((k : ℝ) + 1), ((x - k - 1 / 2 : ℝ) : ℂ) * deriv f x =
      (f (k : ℝ) + f ((k : ℝ) + 1)) / 2 - ∫ x in (k : ℝ)..((k : ℝ) + 1), f x := by
  have hfd : Differentiable ℝ f := hf.differentiable (by simp)
  have hcd : Continuous (deriv f) := hf.continuous_deriv (by simp)
  have hu : ∀ x ∈ Set.uIcc (k : ℝ) ((k : ℝ) + 1),
      HasDerivAt (fun y : ℝ => ((y - k - 1 / 2 : ℝ) : ℂ)) 1 x := by
    intro x hx
    have hreal : HasDerivAt (fun y : ℝ => y - (k : ℝ) - 1 / 2) 1 x := by
      simpa using ((hasDerivAt_id x).sub_const (k : ℝ)).sub_const (1 / 2)
    simpa using hreal.ofReal_comp
  have hv : ∀ x ∈ Set.uIcc (k : ℝ) ((k : ℝ) + 1), HasDerivAt f (deriv f x) x := by
    intro x hx
    exact (hfd x).hasDerivAt
  have hu' : IntervalIntegrable (fun _ : ℝ => (1 : ℂ)) volume (k : ℝ) ((k : ℝ) + 1) :=
    intervalIntegrable_const
  have hv' : IntervalIntegrable (deriv f) volume (k : ℝ) ((k : ℝ) + 1) :=
    hcd.intervalIntegrable _ _
  have h := intervalIntegral.integral_mul_deriv_eq_deriv_mul (a := (k : ℝ)) (b := (k : ℝ) + 1)
    (u := fun y : ℝ => ((y - k - 1 / 2 : ℝ) : ℂ)) (v := f)
    (u' := fun _ => 1) (v' := deriv f) hu hv hu' hv'
  rw [h]
  norm_num
  ring

lemma integral_pb1 (f : ℝ → ℂ) (k : ℕ) :
    ∫ x in (k : ℝ)..((k : ℝ) + 1), (periodicBernoulli 1 x : ℂ) * deriv f x =
      ∫ x in (k : ℝ)..((k : ℝ) + 1), ((x - k - 1 / 2 : ℝ) : ℂ) * deriv f x := by
  apply intervalIntegral.integral_congr_ae
  filter_upwards [(Set.countable_singleton ((k : ℝ) + 1)).ae_notMem volume] with x hx hmem
  rw [Set.uIoc_of_le (by linarith : (k : ℝ) ≤ (k : ℝ) + 1)] at hmem
  have hxne : x ≠ (k : ℝ) + 1 := by simpa using hx
  have hxI : x ∈ Set.Ioo (k : ℝ) ((k : ℝ) + 1) := ⟨hmem.1, lt_of_le_of_ne hmem.2 hxne⟩
  have hfrac : Int.fract x = x - k := by
    have h0 : 0 ≤ x - k := by linarith [hxI.1]
    have h1 : x - k < 1 := by linarith [hxI.2]
    rw [← Int.fract_sub_natCast x k, Int.fract_eq_self.mpr ⟨h0, h1⟩]
  simp [periodicBernoulli, Polynomial.bernoulli_one, hfrac]

lemma int_pb1 (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f) (k : ℕ) :
    IntervalIntegrable (fun x : ℝ => (periodicBernoulli 1 x : ℂ) * deriv f x)
      volume (k : ℝ) ((k : ℝ) + 1) := by
  have hcd : Continuous (deriv f) := hf.continuous_deriv (by simp)
  have hcont : Continuous (fun x : ℝ => ((x - k - 1 / 2 : ℝ) : ℂ) * deriv f x) := by
    fun_prop
  exact IntervalIntegrable.congr_ae (hcont.intervalIntegrable _ _) (pb1_ae f k).symm

lemma sum_Ico_pair (g : ℕ → ℂ) {M N : ℕ} (hMN : M ≤ N) :
    ∑ k ∈ Finset.Ico M N, (g k + g (k + 1)) / 2 =
      (∑ k ∈ Finset.Icc M N, g k) - (g M + g N) / 2 := by
  induction N, hMN using Nat.le_induction with
  | base => simp
  | succ N hMN ih =>
      rw [Finset.sum_Ico_succ_top hMN, ih, Finset.sum_Icc_succ_top (by omega)]
      ring


theorem finite_eulerMaclaurin_zero (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f)
    (M N : ℕ) (hMN : M ≤ N) :
    ∑ k ∈ Finset.Icc M N, f k =
      (∫ x in (M : ℝ)..(N : ℝ), f x) + (f M + f N) / 2 +
        (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli 1 x : ℂ) * deriv f x) := by
  let g : ℝ → ℂ := fun x => (periodicBernoulli 1 x : ℂ) * deriv f x
  have hgint : ∀ k ∈ Set.Ico M N, IntervalIntegrable g volume (k : ℝ) ((k : ℝ) + 1) := by
    intro k hk
    simpa [g] using int_pb1 f hf k
  have hfint : ∀ k ∈ Set.Ico M N, IntervalIntegrable f volume (k : ℝ) ((k : ℝ) + 1) := by
    intro k hk
    exact hf.continuous.intervalIntegrable _ _
  have hgint' : ∀ k ∈ Set.Ico M N, IntervalIntegrable g volume (k : ℝ) ((k + 1 : ℕ) : ℝ) := by
    intro k hk
    simpa [Nat.cast_add, Nat.cast_one] using hgint k hk
  have hfint' : ∀ k ∈ Set.Ico M N, IntervalIntegrable f volume (k : ℝ) ((k + 1 : ℕ) : ℝ) := by
    intro k hk
    simpa [Nat.cast_add, Nat.cast_one] using hfint k hk
  have hsumg : ∑ k ∈ Finset.Ico M N, (∫ x in (k : ℝ)..((k : ℝ) + 1), g x) =
      ∫ x in (M : ℝ)..(N : ℝ), g x := by
    simpa [Nat.cast_add, Nat.cast_one] using
      (intervalIntegral.sum_integral_adjacent_intervals_Ico
        (a := fun k : ℕ => (k : ℝ)) hMN hgint')
  have hsumf : ∑ k ∈ Finset.Ico M N, (∫ x in (k : ℝ)..((k : ℝ) + 1), f x) =
      ∫ x in (M : ℝ)..(N : ℝ), f x := by
    simpa [Nat.cast_add, Nat.cast_one] using
      (intervalIntegral.sum_integral_adjacent_intervals_Ico
        (a := fun k : ℕ => (k : ℝ)) hMN hfint')
  have hlocal : ∀ k ∈ Finset.Ico M N,
      (∫ x in (k : ℝ)..((k : ℝ) + 1), g x) =
        (f (k : ℝ) + f ((k : ℝ) + 1)) / 2 -
          (∫ x in (k : ℝ)..((k : ℝ) + 1), f x) := by
    intro k hk
    rw [show g = fun x : ℝ => (periodicBernoulli 1 x : ℂ) * deriv f x from rfl]
    rw [integral_pb1 f k, local_ibp f hf k]
  calc
    ∑ k ∈ Finset.Icc M N, f k =
        (∑ k ∈ Finset.Ico M N,
          (f (k : ℝ) + f ((k + 1 : ℕ) : ℝ)) / 2) + (f M + f N) / 2 := by
      rw [sum_Ico_pair (fun k : ℕ => f (k : ℝ)) hMN]
      abel
    _ = (∑ k ∈ Finset.Ico M N, (f (k : ℝ) + f ((k : ℝ) + 1)) / 2) +
          (f M + f N) / 2 := by
      congr 1
      apply Finset.sum_congr rfl
      intro k hk
      norm_num
    _ = (∑ k ∈ Finset.Ico M N,
          ((∫ x in (k : ℝ)..((k : ℝ) + 1), g x) +
            (∫ x in (k : ℝ)..((k : ℝ) + 1), f x))) + (f M + f N) / 2 := by
      congr 1
      apply Finset.sum_congr rfl
      intro k hk
      calc
        (f (k : ℝ) + f ((k : ℝ) + 1)) / 2 =
            ((f (k : ℝ) + f ((k : ℝ) + 1)) / 2 -
              (∫ x in (k : ℝ)..((k : ℝ) + 1), f x)) +
              (∫ x in (k : ℝ)..((k : ℝ) + 1), f x) := by abel
        _ = (∫ x in (k : ℝ)..((k : ℝ) + 1), g x) +
              (∫ x in (k : ℝ)..((k : ℝ) + 1), f x) := by
          rw [← hlocal k hk]
    _ = ((∑ k ∈ Finset.Ico M N, (∫ x in (k : ℝ)..((k : ℝ) + 1), g x)) +
          (∑ k ∈ Finset.Ico M N, (∫ x in (k : ℝ)..((k : ℝ) + 1), f x))) +
          (f M + f N) / 2 := by
      rw [Finset.sum_add_distrib (s := Finset.Ico M N)
        (f := fun k => ∫ x in (k : ℝ)..((k : ℝ) + 1), g x)
        (g := fun k => ∫ x in (k : ℝ)..((k : ℝ) + 1), f x)]
    _ = ((∫ x in (M : ℝ)..(N : ℝ), g x) +
          (∫ x in (M : ℝ)..(N : ℝ), f x)) + (f M + f N) / 2 := by
      rw [hsumg, hsumf]
    _ = (∫ x in (M : ℝ)..(N : ℝ), f x) + (f M + f N) / 2 +
          (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli 1 x : ℂ) * deriv f x) := by
      change (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli 1 x : ℂ) * deriv f x) +
          (∫ x in (M : ℝ)..(N : ℝ), f x) + (f M + f N) / 2 =
        (∫ x in (M : ℝ)..(N : ℝ), f x) + (f M + f N) / 2 +
          (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli 1 x : ℂ) * deriv f x)
      abel

lemma hasDerivAt_periodicBernoulli {n : ℕ} {k : ℕ} {x : ℝ}
    (hx : x ∈ Set.Ioo (k : ℝ) ((k : ℝ) + 1)) :
    HasDerivAt (periodicBernoulli n) (n * periodicBernoulli (n - 1) x) x := by
  have hfrac : (fun y : ℝ => Int.fract y) =ᶠ[nhds x] (fun y : ℝ => y - k) := by
    filter_upwards [Ioo_mem_nhds hx.1 hx.2] with y hy
    have h0 : 0 ≤ y - k := by linarith [hy.1]
    have h1 : y - k < 1 := by linarith [hy.2]
    rw [← Int.fract_sub_natCast y k, Int.fract_eq_self.mpr ⟨h0, h1⟩]
  have hfract : HasDerivAt (fun y : ℝ => Int.fract y) 1 x :=
    ((hasDerivAt_id x).sub_const (k : ℝ)).congr_of_eventuallyEq hfrac
  let p : Polynomial ℝ := (Polynomial.bernoulli n).map (algebraMap ℚ ℝ)
  have hp : HasDerivAt (fun y : ℝ => p.eval (Int.fract y))
      (Polynomial.eval (Int.fract x) (Polynomial.derivative p)) x := by
    simpa [Function.comp_def, mul_one] using
      (Polynomial.hasDerivAt p (Int.fract x)).comp x hfract
  convert hp using 1
  · ext y
    simp [periodicBernoulli, p, Polynomial.eval₂_eq_eval_map]
  · simp [p, periodicBernoulli, Polynomial.eval₂_eq_eval_map, Polynomial.derivative_map,
      Polynomial.derivative_bernoulli]


lemma periodicBernoulli_eq_polynomial {n : ℕ} {k : ℕ} {x : ℝ}
    (hx : x ∈ Set.Ioo (k : ℝ) ((k : ℝ) + 1)) :
    periodicBernoulli n x =
      Polynomial.eval (x - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) := by
  have h0 : 0 ≤ x - k := by linarith [hx.1]
  have h1 : x - k < 1 := by linarith [hx.2]
  have hfrac : Int.fract x = x - k := by
    rw [← Int.fract_sub_natCast x k, Int.fract_eq_self.mpr ⟨h0, h1⟩]
  simp [periodicBernoulli, hfrac, Polynomial.eval₂_eq_eval_map]

lemma periodicBernoulli_ae_polynomial (n k : ℕ) :
    (fun x : ℝ => periodicBernoulli n x) =ᵐ[
      volume.restrict (Set.uIoc (k : ℝ) ((k : ℝ) + 1))]
      (fun x : ℝ => Polynomial.eval (x - k)
        ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ))) := by
  rw [Filter.EventuallyEq, MeasureTheory.ae_restrict_iff' measurableSet_uIoc]
  filter_upwards [(Set.countable_singleton ((k : ℝ) + 1)).ae_notMem volume] with x hx hmem
  rw [Set.uIoc_of_le (by linarith : (k : ℝ) ≤ (k : ℝ) + 1)] at hmem
  have hxne : x ≠ (k : ℝ) + 1 := by simpa using hx
  exact periodicBernoulli_eq_polynomial ⟨hmem.1, lt_of_le_of_ne hmem.2 hxne⟩


lemma periodicBernoulli_natCast {n : ℕ} (k : ℕ) :
    periodicBernoulli n (k : ℝ) = (_root_.bernoulli n : ℝ) := by
  simpa using periodicBernoulli_intCast n (k : ℤ)

lemma periodicBernoulli_natCast_add_one {n : ℕ} (k : ℕ) :
    periodicBernoulli n ((k : ℝ) + 1) = (_root_.bernoulli n : ℝ) := by
  simpa using periodicBernoulli_intCast n ((k : ℤ) + 1)

lemma hasDerivAt_bernoulliPolynomial (n : ℕ) (k : ℕ) (x : ℝ) :
    HasDerivAt (fun y : ℝ =>
        Polynomial.eval (y - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)))
      (Polynomial.eval (x - k)
        (((Polynomial.derivative (Polynomial.bernoulli n)).map (algebraMap ℚ ℝ)))) x := by
  have hbase : HasDerivAt (fun y : ℝ => y - k) 1 x := by
    simpa using (hasDerivAt_id x).sub_const (k : ℝ)
  have hp := (Polynomial.hasDerivAt
    ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) (x - k)).comp x hbase
  simpa [Function.comp_def, mul_one] using hp


lemma integral_periodicBernoulli_mul_eq_polynomial (n k : ℕ) (g : ℝ → ℂ) :
    (∫ x in (k : ℝ)..((k : ℝ) + 1), (periodicBernoulli n x : ℂ) * g x) =
      ∫ x in (k : ℝ)..((k : ℝ) + 1),
        ((Polynomial.eval (x - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) : ℝ) : ℂ) * g x := by
  apply intervalIntegral.integral_congr_ae
  filter_upwards [(Set.countable_singleton ((k : ℝ) + 1)).ae_notMem volume] with x hx hmem
  rw [Set.uIoc_of_le (by linarith : (k : ℝ) ≤ (k : ℝ) + 1)] at hmem
  have hxne : x ≠ (k : ℝ) + 1 := by simpa using hx
  have hxI : x ∈ Set.Ioo (k : ℝ) ((k : ℝ) + 1) := ⟨hmem.1, lt_of_le_of_ne hmem.2 hxne⟩
  rw [periodicBernoulli_eq_polynomial hxI]


lemma eval_bernoulliPolynomial_zero (n : ℕ) :
    Polynomial.eval 0 ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) =
      (_root_.bernoulli n : ℝ) := by
  rw [← Polynomial.eval₂_eq_eval_map]
  rw [show (0 : ℝ) = algebraMap ℚ ℝ 0 by simp]
  rw [Polynomial.eval₂_at_apply, Polynomial.bernoulli_eval_zero]
  simp

lemma eval_bernoulliPolynomial_one {n : ℕ} (hn : n ≠ 1) :
    Polynomial.eval 1 ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) =
      (_root_.bernoulli n : ℝ) := by
  rw [← Polynomial.eval₂_eq_eval_map]
  rw [show (1 : ℝ) = algebraMap ℚ ℝ 1 by simp]
  rw [Polynomial.eval₂_at_apply, Polynomial.bernoulli_eval_one]
  simp [bernoulli_eq_bernoulli'_of_ne_one hn]



lemma eval_map_derivative_bernoulliPolynomial (n : ℕ) (x : ℝ) :
    Polynomial.eval x ((Polynomial.derivative (Polynomial.bernoulli (n + 1))).map (algebraMap ℚ ℝ)) =
      (((n + 1 : ℕ) : ℝ) * Polynomial.eval x ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ))) := by
  rw [← Polynomial.eval₂_eq_eval_map, ← Polynomial.eval₂_eq_eval_map]
  rw [Polynomial.derivative_bernoulli]
  simp only [Polynomial.eval₂_mul, Polynomial.eval₂_natCast]
  push_cast
  ring

lemma integral_bernoulliPolynomial_mul_iteratedDeriv_succ
    {n : ℕ} (hn : 1 ≤ n) (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f) (k : ℕ) :
    (∫ x in (k : ℝ)..((k : ℝ) + 1),
      ((Polynomial.eval (x - k) ((Polynomial.bernoulli (n + 1)).map (algebraMap ℚ ℝ)) : ℝ) : ℂ) *
        iteratedDeriv (n + 1) f x) =
      ((_root_.bernoulli (n + 1) : ℝ) : ℂ) *
          (iteratedDeriv n f ((k : ℝ) + 1) - iteratedDeriv n f (k : ℝ)) -
        (((n + 1 : ℕ) : ℝ) : ℂ) *
          (∫ x in (k : ℝ)..((k : ℝ) + 1),
            ((Polynomial.eval (x - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) : ℝ) : ℂ) *
              iteratedDeriv n f x) := by
  let u : ℝ → ℂ := fun x =>
    ((Polynomial.eval (x - k) ((Polynomial.bernoulli (n + 1)).map (algebraMap ℚ ℝ)) : ℝ) : ℂ)
  let u' : ℝ → ℂ := fun x =>
    ((((n + 1 : ℕ) : ℝ) * Polynomial.eval (x - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) : ℝ) : ℂ)
  let v : ℝ → ℂ := fun x => iteratedDeriv n f x
  let v' : ℝ → ℂ := fun x => iteratedDeriv (n + 1) f x
  have hu : ContinuousOn u (Set.uIcc (k : ℝ) ((k : ℝ) + 1)) := by
    apply Continuous.continuousOn
    dsimp [u]; fun_prop
  have hv : ContinuousOn v (Set.uIcc (k : ℝ) ((k : ℝ) + 1)) := by
    apply Continuous.continuousOn
    exact hf.continuous_iteratedDeriv n (by simp)
  have hu' : ∀ x ∈ Set.Ioo (min (k : ℝ) ((k : ℝ) + 1)) (max (k : ℝ) ((k : ℝ) + 1)),
      HasDerivAt u (u' x) x := by
    intro x hx
    have hx' : x ∈ Set.Ioo (k : ℝ) ((k : ℝ) + 1) := by
      simpa [min_eq_left (by linarith : (k : ℝ) ≤ (k : ℝ) + 1),
        max_eq_right (by linarith : (k : ℝ) ≤ (k : ℝ) + 1)] using hx
    have h := hasDerivAt_bernoulliPolynomial (n + 1) k x
    rw [show Polynomial.eval (x - k) ((Polynomial.derivative (Polynomial.bernoulli (n + 1))).map (algebraMap ℚ ℝ)) =
        (((n + 1 : ℕ) : ℝ) * Polynomial.eval (x - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ))) from
      eval_map_derivative_bernoulliPolynomial n (x - k)] at h
    have hc := h.ofReal_comp
    convert hc using 1
  have hv' : ∀ x ∈ Set.Ioo (min (k : ℝ) ((k : ℝ) + 1)) (max (k : ℝ) ((k : ℝ) + 1)),
      HasDerivAt v (v' x) x := by
    intro x hx
    have hdiff : Differentiable ℝ (iteratedDeriv n f) :=
      hf.differentiable_iteratedDeriv n (by
        exact WithTop.coe_lt_coe.mpr (by simp))
    simpa [v, v', iteratedDeriv_succ] using (hdiff x).hasDerivAt
  have hu'int : IntervalIntegrable u' volume (k : ℝ) ((k : ℝ) + 1) := by
    apply Continuous.intervalIntegrable
    dsimp [u']; fun_prop
  have hv'int : IntervalIntegrable v' volume (k : ℝ) ((k : ℝ) + 1) := by
    apply Continuous.intervalIntegrable
    exact hf.continuous_iteratedDeriv (n + 1) (by simp)
  have h := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (a := (k : ℝ)) (b := (k : ℝ) + 1) (u := u) (v := v) (u' := u') (v' := v')
    hu hv hu' hv' hu'int hv'int
  have hk0 : (k : ℝ) - k = 0 := by ring
  have hk1 : ((k : ℝ) + 1) - k = 1 := by ring
  rw [h]
  simp only [u, v, u', hk0, hk1, eval_bernoulliPolynomial_zero,
    eval_bernoulliPolynomial_one (by omega : n + 1 ≠ 1)]
  have hInt : (∫ x in (k : ℝ)..((k : ℝ) + 1),
        ((↑(((n + 1 : ℕ) : ℝ) * Polynomial.eval (x - k)
          ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ))) : ℝ) : ℂ) *
          iteratedDeriv n f x) =
      (((n + 1 : ℕ) : ℝ) : ℂ) *
        ∫ x in (k : ℝ)..((k : ℝ) + 1),
          ((Polynomial.eval (x - k) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) : ℝ) : ℂ) *
            iteratedDeriv n f x := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_congr
    intro x hx
    push_cast
    ring
  rw [hInt]
  ring


/-- The unnormalised unit-interval Bernoulli remainder. -/
noncomputable def unitIntegral (f : ℝ → ℂ) (k m : ℕ) : ℂ :=
  ∫ x in (k : ℝ)..((k : ℝ) + 1),
    (periodicBernoulli m x : ℂ) * iteratedDeriv m f x

lemma unit_recursion_raw {n : ℕ} (hn : 1 ≤ n) (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f) (k : ℕ) :
    (((n + 1 : ℕ) : ℂ) * ((n + 2 : ℕ) : ℂ)) * unitIntegral f k n =
      (((n + 2 : ℕ) : ℂ) * ((_root_.bernoulli (n + 1) : ℝ) : ℂ)) *
          (iteratedDeriv n f ((k : ℝ) + 1) - iteratedDeriv n f (k : ℝ)) -
        (((_root_.bernoulli (n + 2) : ℝ) : ℂ) *
          (iteratedDeriv (n + 1) f ((k : ℝ) + 1) - iteratedDeriv (n + 1) f (k : ℝ))) +
        unitIntegral f k (n + 2) := by
  have h1 := integral_bernoulliPolynomial_mul_iteratedDeriv_succ hn f hf k
  have h2 := integral_bernoulliPolynomial_mul_iteratedDeriv_succ (n := n + 1) (by omega) f hf k
  have h1I : unitIntegral f k (n + 1) =
      ((_root_.bernoulli (n + 1) : ℝ) : ℂ) *
          (iteratedDeriv n f ((k : ℝ) + 1) - iteratedDeriv n f (k : ℝ)) -
        (((n + 1 : ℕ) : ℂ) * unitIntegral f k n) := by
    rw [unitIntegral, unitIntegral,
      integral_periodicBernoulli_mul_eq_polynomial (n + 1) k (iteratedDeriv (n + 1) f),
      integral_periodicBernoulli_mul_eq_polynomial n k (iteratedDeriv n f)]
    exact h1
  have h2I : unitIntegral f k (n + 2) =
      ((_root_.bernoulli (n + 2) : ℝ) : ℂ) *
          (iteratedDeriv (n + 1) f ((k : ℝ) + 1) - iteratedDeriv (n + 1) f (k : ℝ)) -
        (((n + 2 : ℕ) : ℂ) * unitIntegral f k (n + 1)) := by
    rw [unitIntegral, unitIntegral,
      integral_periodicBernoulli_mul_eq_polynomial (n + 2) k (iteratedDeriv (n + 2) f),
      integral_periodicBernoulli_mul_eq_polynomial (n + 1) k (iteratedDeriv (n + 1) f)]
    exact h2
  have h2shift : (((n + 2 : ℕ) : ℂ) * unitIntegral f k (n + 1)) =
      ((_root_.bernoulli (n + 2) : ℝ) : ℂ) *
          (iteratedDeriv (n + 1) f ((k : ℝ) + 1) - iteratedDeriv (n + 1) f (k : ℝ)) -
        unitIntegral f k (n + 2) := by
    rw [h2I]; ring
  calc
    (((n + 1 : ℕ) : ℂ) * ((n + 2 : ℕ) : ℂ)) * unitIntegral f k n =
        (((n + 2 : ℕ) : ℂ) *
          ((((n + 1 : ℕ) : ℂ) * unitIntegral f k n))) := by ring
    _ = (((n + 2 : ℕ) : ℂ) *
          (((_root_.bernoulli (n + 1) : ℝ) : ℂ) *
            (iteratedDeriv n f ((k : ℝ) + 1) - iteratedDeriv n f (k : ℝ)) -
          unitIntegral f k (n + 1))) := by rw [h1I]; ring
    _ = (((n + 2 : ℕ) : ℂ) * ((_root_.bernoulli (n + 1) : ℝ) : ℂ)) *
          (iteratedDeriv n f ((k : ℝ) + 1) - iteratedDeriv n f (k : ℝ)) -
        (((n + 2 : ℕ) : ℂ) * unitIntegral f k (n + 1)) := by ring
    _ = (((n + 2 : ℕ) : ℂ) * ((_root_.bernoulli (n + 1) : ℝ) : ℂ)) *
          (iteratedDeriv n f ((k : ℝ) + 1) - iteratedDeriv n f (k : ℝ)) -
        (((_root_.bernoulli (n + 2) : ℝ) : ℂ) *
          (iteratedDeriv (n + 1) f ((k : ℝ) + 1) - iteratedDeriv (n + 1) f (k : ℝ))) +
        unitIntegral f k (n + 2) := by rw [h2shift]; ring

lemma intervalIntegrable_unitIntegral (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f) (m k : ℕ) :
    IntervalIntegrable (fun x : ℝ => (periodicBernoulli m x : ℂ) * iteratedDeriv m f x)
      volume (k : ℝ) ((k : ℝ) + 1) := by
  have hcd : Continuous (iteratedDeriv m f) := hf.continuous_iteratedDeriv m (by simp)
  have hcont : Continuous (fun x : ℝ =>
      ((Polynomial.eval (x - k) ((Polynomial.bernoulli m).map (algebraMap ℚ ℝ)) : ℝ) : ℂ) *
        iteratedDeriv m f x) := by
    fun_prop
  have hae : (fun x : ℝ => (periodicBernoulli m x : ℂ) * iteratedDeriv m f x) =ᵐ[
      volume.restrict (Set.uIoc (k : ℝ) ((k : ℝ) + 1))]
      (fun x : ℝ =>
        ((Polynomial.eval (x - k) ((Polynomial.bernoulli m).map (algebraMap ℚ ℝ)) : ℝ) : ℂ) *
          iteratedDeriv m f x) := by
    filter_upwards [periodicBernoulli_ae_polynomial m k] with x hx
    rw [hx]
  exact IntervalIntegrable.congr_ae (hcont.intervalIntegrable _ _) hae.symm

lemma sum_unitIntegral (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f) (m M N : ℕ) (hMN : M ≤ N) :
    (∑ k ∈ Finset.Ico M N, unitIntegral f k m) =
      ∫ x in (M : ℝ)..(N : ℝ),
        (periodicBernoulli m x : ℂ) * iteratedDeriv m f x := by
  have hint : ∀ k ∈ Set.Ico M N,
      IntervalIntegrable (fun x : ℝ => (periodicBernoulli m x : ℂ) * iteratedDeriv m f x)
        volume (k : ℝ) ((k + 1 : ℕ) : ℝ) := by
    intro k hk
    simpa [Nat.cast_add, Nat.cast_one] using intervalIntegrable_unitIntegral f hf m k
  have h := intervalIntegral.sum_integral_adjacent_intervals_Ico
    (a := fun k : ℕ => (k : ℝ)) hMN hint
  simpa [unitIntegral, Nat.cast_add, Nat.cast_one] using h

lemma global_recursion_raw {n : ℕ} (hn : 1 ≤ n) (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f)
    (M N : ℕ) (hMN : M ≤ N) :
    (((n + 1 : ℕ) : ℂ) * ((n + 2 : ℕ) : ℂ)) *
        (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli n x : ℂ) * iteratedDeriv n f x) =
      (((n + 2 : ℕ) : ℂ) * ((_root_.bernoulli (n + 1) : ℝ) : ℂ)) *
          (iteratedDeriv n f (N : ℝ) - iteratedDeriv n f (M : ℝ)) -
        (((_root_.bernoulli (n + 2) : ℝ) : ℂ) *
          (iteratedDeriv (n + 1) f (N : ℝ) - iteratedDeriv (n + 1) f (M : ℝ))) +
        (∫ x in (M : ℝ)..(N : ℝ),
          (periodicBernoulli (n + 2) x : ℂ) * iteratedDeriv (n + 2) f x) := by
  let A : ℂ := ((n + 2 : ℕ) : ℂ) * ((_root_.bernoulli (n + 1) : ℝ) : ℂ)
  let B : ℂ := ((_root_.bernoulli (n + 2) : ℝ) : ℂ)
  let C : ℂ := ((n + 1 : ℕ) : ℂ) * ((n + 2 : ℕ) : ℂ)
  let g : ℕ → ℂ := fun k => iteratedDeriv n f (k : ℝ)
  let h : ℕ → ℂ := fun k => iteratedDeriv (n + 1) f (k : ℝ)
  have hsum : (∑ k ∈ Finset.Ico M N, C * unitIntegral f k n) =
      ∑ k ∈ Finset.Ico M N,
        (A * (g (k + 1) - g k) - B * (h (k + 1) - h k) + unitIntegral f k (n + 2)) := by
    apply Finset.sum_congr rfl
    intro k hk
    simpa [C, A, B, g, h, mul_comm, mul_left_comm, mul_assoc] using
      unit_recursion_raw hn f hf k
  have htelg : (∑ k ∈ Finset.Ico M N, (g (k + 1) - g k)) = g N - g M :=
    Finset.sum_Ico_sub g hMN
  have htelh : (∑ k ∈ Finset.Ico M N, (h (k + 1) - h k)) = h N - h M :=
    Finset.sum_Ico_sub h hMN
  have hsumI := sum_unitIntegral f hf n M N hMN
  have hsumI2 := sum_unitIntegral f hf (n + 2) M N hMN
  rw [← Finset.mul_sum] at hsum
  rw [hsumI] at hsum
  rw [Finset.sum_add_distrib, Finset.sum_sub_distrib] at hsum
  simp_rw [← Finset.mul_sum] at hsum
  rw [htelg, htelh] at hsum
  rw [hsumI2] at hsum
  simpa [C, A, B, g, h, mul_comm, mul_left_comm, mul_assoc] using hsum

lemma odd_recursion_mul {K : ℕ} (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f)
    (M N : ℕ) (hMN : M ≤ N) :
    ((((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ))) *
        (∫ x in (M : ℝ)..(N : ℝ),
          (periodicBernoulli (2 * K + 1) x : ℂ) * iteratedDeriv (2 * K + 1) f x) =
      (((2 * K + 3 : ℕ) : ℂ) * ((_root_.bernoulli (2 * K + 2) : ℝ) : ℂ)) *
          (iteratedDeriv (2 * K + 1) f (N : ℝ) - iteratedDeriv (2 * K + 1) f (M : ℝ)) +
        (∫ x in (M : ℝ)..(N : ℝ),
          (periodicBernoulli (2 * K + 3) x : ℂ) * iteratedDeriv (2 * K + 3) f x) := by
  have h := global_recursion_raw (n := 2 * K + 1) (by omega) f hf M N hMN
  have hB : ((_root_.bernoulli (2 * K + 3) : ℝ) : ℂ) = 0 := by
    have : _root_.bernoulli (2 * K + 3) = 0 := by
      apply bernoulli_eq_zero_of_odd
      · exact ⟨K + 1, by ring⟩
      · omega
    rw [this]; norm_num
  rw [hB] at h
  ring_nf at h ⊢
  exact h

lemma odd_recursion_div {K : ℕ} (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f)
    (M N : ℕ) (hMN : M ≤ N) :
    (∫ x in (M : ℝ)..(N : ℝ),
        (periodicBernoulli (2 * K + 1) x : ℂ) * iteratedDeriv (2 * K + 1) f x) =
      (((_root_.bernoulli (2 * K + 2) : ℝ) : ℂ) / ((2 * K + 2 : ℕ) : ℂ)) *
          (iteratedDeriv (2 * K + 1) f (N : ℝ) - iteratedDeriv (2 * K + 1) f (M : ℝ)) +
        (1 / (((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ))) *
          (∫ x in (M : ℝ)..(N : ℝ),
            (periodicBernoulli (2 * K + 3) x : ℂ) * iteratedDeriv (2 * K + 3) f x) := by
  have h := odd_recursion_mul (K := K) f hf M N hMN
  have h2 : ((2 * K + 2 : ℕ) : ℂ) ≠ 0 := by
    exact_mod_cast (by omega : (2 * K + 2 : ℕ) ≠ 0)
  have h3 : ((2 * K + 3 : ℕ) : ℂ) ≠ 0 := by
    exact_mod_cast (by omega : (2 * K + 3 : ℕ) ≠ 0)
  have hC : ((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ) ≠ 0 := mul_ne_zero h2 h3
  calc
    (∫ x in (M : ℝ)..(N : ℝ),
        (periodicBernoulli (2 * K + 1) x : ℂ) * iteratedDeriv (2 * K + 1) f x) =
        (1 / (((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ))) *
          ((((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ)) *
            (∫ x in (M : ℝ)..(N : ℝ),
              (periodicBernoulli (2 * K + 1) x : ℂ) * iteratedDeriv (2 * K + 1) f x)) := by
      field_simp [hC]
    _ = (1 / (((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ))) *
          ((((2 * K + 3 : ℕ) : ℂ) * ((_root_.bernoulli (2 * K + 2) : ℝ) : ℂ)) *
            (iteratedDeriv (2 * K + 1) f (N : ℝ) - iteratedDeriv (2 * K + 1) f (M : ℝ)) +
          (∫ x in (M : ℝ)..(N : ℝ),
            (periodicBernoulli (2 * K + 3) x : ℂ) * iteratedDeriv (2 * K + 3) f x)) := by
      rw [h]
    _ = (((_root_.bernoulli (2 * K + 2) : ℝ) : ℂ) / ((2 * K + 2 : ℕ) : ℂ)) *
          (iteratedDeriv (2 * K + 1) f (N : ℝ) - iteratedDeriv (2 * K + 1) f (M : ℝ)) +
        (1 / (((2 * K + 2 : ℕ) : ℂ) * ((2 * K + 3 : ℕ) : ℂ))) *
          (∫ x in (M : ℝ)..(N : ℝ),
            (periodicBernoulli (2 * K + 3) x : ℂ) * iteratedDeriv (2 * K + 3) f x) := by
      field_simp [hC, h2, h3]

lemma normalized_odd_recursion {K : ℕ} (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f)
    (M N : ℕ) (hMN : M ≤ N) :
    (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
        (∫ x in (M : ℝ)..(N : ℝ),
          (periodicBernoulli (2 * K + 1) x : ℂ) * iteratedDeriv (2 * K + 1) f x) =
      (((_root_.bernoulli (2 * K + 2) : ℝ) : ℂ) / (((2 * K + 2).factorial : ℕ) : ℂ)) *
          (iteratedDeriv (2 * K + 1) f (N : ℝ) - iteratedDeriv (2 * K + 1) f (M : ℝ)) +
        (1 / (((2 * K + 3).factorial : ℕ) : ℂ)) *
          (∫ x in (M : ℝ)..(N : ℝ),
            (periodicBernoulli (2 * K + 3) x : ℂ) * iteratedDeriv (2 * K + 3) f x) := by
  have hdiv := odd_recursion_div (K := K) f hf M N hMN
  have hF2 : (((2 * K + 2).factorial : ℕ) : ℂ) =
      ((2 * K + 2 : ℕ) : ℂ) * (((2 * K + 1).factorial : ℕ) : ℂ) := by
    rw [show 2 * K + 2 = (2 * K + 1) + 1 by omega, Nat.factorial_succ]
    norm_num
  have hF3 : (((2 * K + 3).factorial : ℕ) : ℂ) =
      ((2 * K + 3 : ℕ) : ℂ) * (((2 * K + 2).factorial : ℕ) : ℂ) := by
    rw [show 2 * K + 3 = (2 * K + 2) + 1 by omega, Nat.factorial_succ]
    norm_num
  have h2 : ((2 * K + 2 : ℕ) : ℂ) ≠ 0 := by
    exact_mod_cast (by omega : (2 * K + 2 : ℕ) ≠ 0)
  have h3 : ((2 * K + 3 : ℕ) : ℂ) ≠ 0 := by
    exact_mod_cast (by omega : (2 * K + 3 : ℕ) ≠ 0)
  have hF1 : (((2 * K + 1).factorial : ℕ) : ℂ) ≠ 0 := by
    exact_mod_cast (Nat.factorial_ne_zero (2 * K + 1))
  rw [hdiv]
  rw [hF2, hF3]
  field_simp [h2, h3, hF1, hF2, hF3]
  rw [hF2]
  field_simp [h2, hF1]

theorem finite_eulerMaclaurin (K : ℕ) (f : ℝ → ℂ) (hf : ContDiff ℝ (↑(⊤ : ℕ∞)) f)
    (M N : ℕ) (hMN : M ≤ N) :
    (∑ k ∈ Finset.Icc M N, f k) =
      (∫ x in (M : ℝ)..(N : ℝ), f x) + (f M + f N) / 2 +
        (∑ j ∈ Finset.range K,
          (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
              (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
            (iteratedDeriv (2 * j + 1) f (N : ℝ) -
              iteratedDeriv (2 * j + 1) f (M : ℝ))) +
        (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
          (∫ x in (M : ℝ)..(N : ℝ),
            (periodicBernoulli (2 * K + 1) x : ℂ) *
              iteratedDeriv (2 * K + 1) f x) := by
  induction K with
  | zero =>
      simpa using finite_eulerMaclaurin_zero f hf M N hMN
  | succ K ih =>
      rw [ih, Finset.sum_range_succ]
      rw [normalized_odd_recursion (K := K) f hf M N hMN]
      simp only [Nat.mul_add, Nat.mul_one, Nat.add_assoc]
      ring

lemma periodicBernoulli_eq_bernoulliFun (n : ℕ) (x : ℝ) :
    periodicBernoulli n x = bernoulliFun n (Int.fract x) := by
  simp [periodicBernoulli, bernoulliFun, Polynomial.eval₂_eq_eval_map]

lemma hasSum_periodicBernoulli_fourier {n : ℕ} (hn : 2 ≤ n) (x : ℝ) :
    HasSum (fun k : ℤ => (1 : ℂ) / (k : ℂ) ^ n * fourier k ((Int.fract x : ℝ) : AddCircle (1 : ℝ)))
      (-(2 * (Real.pi : ℂ) * Complex.I) ^ n / (n.factorial : ℂ) * (periodicBernoulli n x : ℂ)) := by
  have hx : Int.fract x ∈ Set.Icc (0 : ℝ) 1 := ⟨Int.fract_nonneg x, (Int.fract_lt_one x).le⟩
  have h := hasSum_one_div_pow_mul_fourier_mul_bernoulliFun hn hx
  simpa [periodicBernoulli_eq_bernoulliFun] using h

lemma norm_fourier_unit (n : ℤ) (x : UnitAddCircle) : ‖fourier n x‖ = 1 := by
  rw [fourier_apply]
  exact Circle.norm_coe _

lemma norm_periodicBernoulli_le_tsum {n : ℕ} (hn : 2 ≤ n) (x : ℝ) :
    ‖(periodicBernoulli n x : ℂ)‖ ≤
      ((n.factorial : ℝ) / (2 * Real.pi) ^ n) *
        (∑' k : ℤ, 1 / |(k : ℝ)| ^ n) := by
  let c : ℂ := -(2 * (Real.pi : ℂ) * Complex.I) ^ n / (n.factorial : ℂ)
  have h := hasSum_periodicBernoulli_fourier hn x
  have hc_norm : ‖c‖ = (2 * Real.pi) ^ n / (n.factorial : ℝ) := by
    dsimp [c]
    simp [norm_pow, Complex.norm_I, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos Real.pi_pos]
  have hnorm : ‖c * (periodicBernoulli n x : ℂ)‖ ≤
      ∑' k : ℤ, 1 / |(k : ℝ)| ^ n := by
    calc
      ‖c * (periodicBernoulli n x : ℂ)‖ = ‖∑' k : ℤ, (1 : ℂ) / (k : ℂ) ^ n *
          fourier k ((Int.fract x : ℝ) : AddCircle (1 : ℝ))‖ := by rw [h.tsum_eq]
      _ ≤ ∑' k : ℤ, ‖(1 : ℂ) / (k : ℂ) ^ n *
          fourier k ((Int.fract x : ℝ) : AddCircle (1 : ℝ))‖ := by
        apply norm_tsum_le_tsum_norm
        exact h.summable.norm
      _ = ∑' k : ℤ, 1 / |(k : ℝ)| ^ n := by
        apply tsum_congr
        intro k
        rw [norm_mul, norm_div, norm_one, norm_pow, Complex.norm_intCast, norm_fourier_unit]
        norm_num
  rw [norm_mul, hc_norm] at hnorm
  have hpi : (0 : ℝ) < (2 * Real.pi) ^ n := by positivity
  have hfac : (0 : ℝ) < (n.factorial : ℝ) := by positivity
  have hnorm' : (2 * Real.pi) ^ n * ‖(periodicBernoulli n x : ℂ)‖ ≤
      (∑' k : ℤ, 1 / |(k : ℝ)| ^ n) * (n.factorial : ℝ) := by
    have := hnorm
    field_simp [hfac.ne'] at this
    linarith
  have hmain : ‖(periodicBernoulli n x : ℂ)‖ ≤
      ((n.factorial : ℝ) * (∑' k : ℤ, 1 / |(k : ℝ)| ^ n)) /
        (2 * Real.pi) ^ n := by
    rw [le_div_iff₀ hpi]
    nlinarith [hnorm']
  calc
    ‖(periodicBernoulli n x : ℂ)‖ ≤
        ((n.factorial : ℝ) * (∑' k : ℤ, 1 / |(k : ℝ)| ^ n)) /
          (2 * Real.pi) ^ n := hmain
    _ = ((n.factorial : ℝ) / (2 * Real.pi) ^ n) *
        (∑' k : ℤ, 1 / |(k : ℝ)| ^ n) := by ring

lemma summable_int_abs_inv_pow {n : ℕ} (hn : 2 ≤ n) :
    Summable (fun k : ℤ => (1 : ℝ) / |(k : ℝ)| ^ n) := by
  have hn1 : 1 < n := by omega
  have hsigned : Summable (fun k : ℤ => (1 : ℝ) / (k : ℝ) ^ n) :=
    (Real.summable_one_div_int_pow).mpr hn1
  convert hsigned.norm using 1
  ext k
  simp [one_div]

lemma tsum_int_abs_inv_pow_eq_two_tsum_nat {n : ℕ} (hn : 2 ≤ n) :
    (∑' k : ℤ, (1 : ℝ) / |(k : ℝ)| ^ n) =
      2 * (∑' m : ℕ, (1 : ℝ) / (m : ℝ) ^ n) := by
  let f : ℤ → ℝ := fun k => (1 : ℝ) / |(k : ℝ)| ^ n
  have hsum : Summable f := summable_int_abs_inv_pow hn
  have heven : Function.Even f := by
    intro k
    simp [f, abs_neg]
  have hsplit := tsum_int_eq_zero_add_two_mul_tsum_pnat heven hsum
  have h0 : f 0 = 0 := by
    simp [f, zero_pow (by omega : n ≠ 0)]
  rw [hsplit, h0, zero_add]
  have hs_nat : Summable (fun m : ℕ => f (m : ℤ)) :=
    hsum.comp_injective Int.ofNat_injective
  have hzero_add := hs_nat.tsum_eq_zero_add
  have hpnat : (∑' (k : ℕ+), f ((k : ℕ) : ℤ)) = ∑' m : ℕ, f (m : ℤ) := by
    simp only [tsum_pnat_eq_tsum_succ (f := fun m : ℕ => f (m : ℤ))]
    rw [hzero_add]
    simp [h0]
  simpa [f] using hpnat

end PartialTail

namespace PartialTail

lemma norm_periodicBernoulli_le_two_tsum_nat {n : ℕ} (hn : 2 ≤ n) (x : ℝ) :
    ‖(periodicBernoulli n x : ℂ)‖ ≤
      ((n.factorial : ℝ) / (2 * Real.pi) ^ n) *
        (2 * (∑' m : ℕ, 1 / (m : ℝ) ^ n)) := by
  rw [← tsum_int_abs_inv_pow_eq_two_tsum_nat hn]
  exact norm_periodicBernoulli_le_tsum hn x

lemma tsum_nat_abs_inv_pow_eq_zeta_re {n : ℕ} (hn : 2 ≤ n) :
    (∑' m : ℕ, (1 : ℝ) / (m : ℝ) ^ n) = (riemannZeta (n : ℂ)).re := by
  have hn1 : 1 < n := by omega
  have hsumC : Summable (fun m : ℕ => (1 : ℂ) / (m : ℂ) ^ n) := by
    simpa [Complex.cpow_natCast] using
      (Complex.summable_one_div_nat_cpow (p := (n : ℂ))).mpr (by simpa using hn1)
  have hzeta := zeta_nat_eq_tsum_of_gt_one hn1
  have hre := congrArg Complex.re hzeta
  rw [Complex.re_tsum hsumC] at hre
  rw [hre]
  apply tsum_congr
  intro m
  rw [show (1 : ℂ) / (m : ℂ) ^ n = (((1 : ℝ) / (m : ℝ) ^ n : ℝ) : ℂ) by
    push_cast
    ring]
  exact Complex.ofReal_re _

lemma norm_periodicBernoulli_le_zeta {n : ℕ} (hn : 2 ≤ n) (x : ℝ) :
    ‖(periodicBernoulli n x : ℂ)‖ ≤
      ((n.factorial : ℝ) / (2 * Real.pi) ^ n) *
        (2 * (riemannZeta (n : ℂ)).re) := by
  rw [← tsum_nat_abs_inv_pow_eq_zeta_re hn]
  exact norm_periodicBernoulli_le_two_tsum_nat hn x

lemma iSup_norm_periodicBernoulli_le_zeta {n : ℕ} (hn : 2 ≤ n) :
    (⨆ x : ℝ, ‖(periodicBernoulli n x : ℂ)‖) ≤
      ((n.factorial : ℝ) / (2 * Real.pi) ^ n) * (2 * (riemannZeta (n : ℂ)).re) := by
  apply ciSup_le
  intro x
  exact norm_periodicBernoulli_le_zeta hn x

lemma iSup_norm_periodicBernoulli_odd_le_zeta {K : ℕ} (hK : 1 ≤ K) :
    (⨆ x : ℝ, ‖(periodicBernoulli (2 * K + 1) x : ℂ)‖) ≤
      2 * ((2 * K + 1).factorial : ℝ) * (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re /
        (2 * Real.pi) ^ (2 * K + 1) := by
  have hn : 2 ≤ 2 * K + 1 := by omega
  have h := iSup_norm_periodicBernoulli_le_zeta (n := 2 * K + 1) hn
  calc
    (⨆ x : ℝ, ‖(periodicBernoulli (2 * K + 1) x : ℂ)‖) ≤
        ((2 * K + 1).factorial : ℝ) / (2 * Real.pi) ^ (2 * K + 1) *
          (2 * (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re) := h
    _ = 2 * ((2 * K + 1).factorial : ℝ) * (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re /
          (2 * Real.pi) ^ (2 * K + 1) := by ring

lemma differentiableAt_hurwitzZetaNP {a : ℝ} {s : ℂ} (hs1 : s ≠ 1) (hs0 : s ≠ 0) :
    DifferentiableAt ℂ (hurwitzZetaNP a) s := by
  unfold hurwitzZetaNP
  apply DifferentiableAt.sub
  · exact HurwitzZeta.differentiableAt_hurwitzZeta _ hs1
  · apply DifferentiableAt.fun_sum
    intro k hk
    have harg : DifferentiableAt ℂ (fun t : ℂ => -t) s := differentiableAt_id.neg
    have hc : (((Int.fract a + k : ℝ) : ℂ) ≠ 0) ∨ (-s ≠ 0) := Or.inr (by simpa using hs0)
    simpa using
      (DifferentiableAt.const_cpow (c := ((Int.fract a + k : ℝ) : ℂ)) harg hc)

lemma differentiableAt_hurwitzZetaNP_of_re_pos {a : ℝ} {s : ℂ}
    (hs1 : s ≠ 1) (hs : 0 < s.re) :
    DifferentiableAt ℂ (hurwitzZetaNP a) s := by
  apply differentiableAt_hurwitzZetaNP hs1
  intro h
  rw [h] at hs
  simp at hs

lemma continuousAt_hurwitzZetaNP_of_re_pos {a : ℝ} {s : ℂ}
    (hs1 : s ≠ 1) (hs : 0 < s.re) :
    ContinuousAt (hurwitzZetaNP a) s :=
  (differentiableAt_hurwitzZetaNP_of_re_pos hs1 hs).continuousAt

lemma summable_hurwitzZetaNP {a : ℝ} (ha : 0 < a) {s : ℂ} (hs : 1 < s.re) :
    Summable (fun n : ℕ => 1 / ((n : ℂ) + (a : ℂ)) ^ s) := by
  let r : ℝ := Int.fract a
  let m : ℕ := (Int.floor a).toNat
  have hm : (m : ℤ) = Int.floor a := Int.toNat_of_nonneg (Int.floor_nonneg.mpr ha.le)
  have hmR : (m : ℝ) = (Int.floor a : ℝ) := by exact_mod_cast hm
  have hma : (m : ℝ) + r = a := by
    rw [hmR]
    exact Int.floor_add_fract a
  have hr : r ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨Int.fract_nonneg a, (Int.fract_lt_one a).le⟩
  have hsum : HasSum (fun n : ℕ => 1 / ((n : ℂ) + (r : ℂ)) ^ s)
      (HurwitzZeta.hurwitzZeta (↑r : UnitAddCircle) s) :=
    HurwitzZeta.hasSum_hurwitzZeta_of_one_lt_re hr hs
  have hf : Summable (fun n : ℕ => 1 / ((n : ℂ) + (r : ℂ)) ^ s) := hsum.summable
  have hshift : Summable (fun n : ℕ => 1 / (((n + m : ℕ) : ℂ) + (r : ℂ)) ^ s) :=
    (summable_nat_add_iff m).mpr hf
  convert hshift using 1
  ext n
  congr 2
  rw [← hma]
  push_cast
  ring

lemma hasSum_hurwitzZetaNP {a : ℝ} (ha : 0 < a) {s : ℂ} (hs : 1 < s.re) :
    HasSum (fun n : ℕ => 1 / ((n : ℂ) + (a : ℂ)) ^ s) (hurwitzZetaNP a s) := by
  rw [hurwitzZetaNP_eq_tsum ha hs]
  exact (summable_hurwitzZetaNP ha hs).hasSum

lemma integrableOn_Ioi_comp_add_left {E : Type*} [NormedAddCommGroup E] {f : ℝ → E} {a M : ℝ}
    (h : IntegrableOn f (Set.Ioi (a + M))) :
    IntegrableOn (fun x : ℝ => f (a + x)) (Set.Ioi M) := by
  rw [IntegrableOn] at h ⊢
  have hmap : Measure.map (fun x : ℝ => a + x) volume = volume :=
    MeasureTheory.map_add_left_eq_self volume a
  have hpre : (fun x : ℝ => a + x) ⁻¹' Set.Ioi (a + M) = Set.Ioi M := by
    ext x
    simp
  rw [← hmap] at h
  rw [(measurableEmbedding_addLeft a).restrict_map volume (Set.Ioi (a + M)), hpre] at h
  exact (measurableEmbedding_addLeft a).integrable_map_iff.mp h

lemma integrableOn_hurwitzTerm {a M : ℝ} (hM : 0 < a + M) {s : ℂ} (hs : 1 < s.re) :
    IntegrableOn (fun x : ℝ => (((a + x : ℝ) : ℂ) ^ (-s))) (Set.Ioi M) := by
  have hσ : (-s.re) < -1 := by linarith
  have hreal : IntegrableOn (fun t : ℝ => t ^ (-s.re)) (Set.Ioi (a + M)) :=
    integrableOn_Ioi_rpow_of_lt hσ (by linarith)
  have hshift : IntegrableOn (fun x : ℝ => (a + x : ℝ) ^ (-s.re)) (Set.Ioi M) :=
    integrableOn_Ioi_comp_add_left (f := fun t : ℝ => t ^ (-s.re)) (a := a) (M := M) hreal
  apply Integrable.mono' hshift
  · apply ContinuousOn.aestronglyMeasurable
    · apply ContinuousOn.cpow
      · fun_prop
      · exact continuousOn_const
      · intro x hx
        rw [Set.mem_Ioi] at hx
        rw [Complex.ofReal_mem_slitPlane]
        linarith
    · exact measurableSet_Ioi
  · filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
    rw [Set.mem_Ioi] at hx
    have hxpos : 0 < a + x := by linarith
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
    simp

lemma tendsto_hurwitzTerm_atTop_zero {a : ℝ} {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun x : ℝ => (((a + x : ℝ) : ℂ) ^ (1 - s))) atTop (nhds 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hσ : 0 < s.re - 1 := by linarith
  have hshift : Tendsto (fun x : ℝ => a + x) atTop atTop := by
    rw [Filter.tendsto_atTop]
    intro b
    filter_upwards [eventually_ge_atTop (b - a)] with x hx
    linarith
  have hrpow : Tendsto (fun x : ℝ => (a + x) ^ (-(s.re - 1))) atTop (nhds 0) :=
    (tendsto_rpow_neg_atTop hσ).comp hshift
  refine hrpow.congr' ?_
  filter_upwards [eventually_gt_atTop (-a)] with x hx
  have hxpos : 0 < a + x := by linarith
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
  norm_num

lemma hasDerivAt_hurwitzAnti {a M : ℝ} (hM : 0 < a + M) {s : ℂ} (hs : 1 < s.re) :
    ∀ x ∈ Set.Ioi M,
      HasDerivAt (fun y : ℝ => -((((a + y : ℝ) : ℂ) ^ (1 - s)) / (s - 1)))
        ((((a + x : ℝ) : ℂ) ^ (-s))) x := by
  intro x hx
  rw [Set.mem_Ioi] at hx
  have hxpos : 0 < a + x := by linarith
  have hbase : HasDerivAt (fun z : ℂ => (a : ℂ) + z) 1 (x : ℂ) := by
    simpa using (hasDerivAt_id (x : ℂ)).const_add (a : ℂ)
  have hslit : (a : ℂ) + (x : ℂ) ∈ Complex.slitPlane := by
    rw [← Complex.ofReal_add, Complex.ofReal_mem_slitPlane]
    exact hxpos
  have hG : HasDerivAt (fun z : ℂ => ((a : ℂ) + z) ^ (1 - s))
      ((1 - s) * ((a : ℂ) + (x : ℂ)) ^ ((1 - s) - 1)) (x : ℂ) := by
    simpa using hbase.cpow_const (c := 1 - s) hslit
  have hGreal : HasDerivAt (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (1 - s)))
      ((1 - s) * (((a + x : ℝ) : ℂ) ^ ((1 - s) - 1))) x := by
    simpa [Complex.ofReal_add] using hG.comp_ofReal
  have hF : HasDerivAt (fun y : ℝ => -((((a + y : ℝ) : ℂ) ^ (1 - s)) / (s - 1)))
      (-(((1 - s) * (((a + x : ℝ) : ℂ) ^ ((1 - s) - 1))) / (s - 1))) x :=
    (hGreal.div_const (s - 1)).neg
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hpow : ((1 - s) * (((a + x : ℝ) : ℂ) ^ ((1 - s) - 1))) / (s - 1) =
      -((((a + x : ℝ) : ℂ) ^ (-s))) := by
    rw [show (1 - s) - 1 = -s by ring]
    field_simp [hs1]
    ring
  rw [hpow] at hF
  simpa using hF

lemma integral_Ioi_hurwitzTerm {a M : ℝ} (hM : 0 < a + M) {s : ℂ} (hs : 1 < s.re) :
    (∫ x : ℝ in Set.Ioi M, (((a + x : ℝ) : ℂ) ^ (-s))) =
      (((a + M : ℝ) : ℂ) ^ (1 - s)) / (s - 1) := by
  let F : ℝ → ℂ := fun y => -((((a + y : ℝ) : ℂ) ^ (1 - s)) / (s - 1))
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hcont : ContinuousWithinAt F (Set.Ici M) M := by
    apply ContinuousOn.continuousWithinAt
    · apply ContinuousOn.neg
      apply ContinuousOn.div_const
      apply ContinuousOn.cpow
      · fun_prop
      · exact continuousOn_const
      · intro x hx
        rw [Set.mem_Ici] at hx
        rw [Complex.ofReal_mem_slitPlane]
        linarith
    · exact Set.mem_Ici.mpr le_rfl
  have hderiv : ∀ x ∈ Set.Ioi M, HasDerivAt F ((((a + x : ℝ) : ℂ) ^ (-s))) x :=
    hasDerivAt_hurwitzAnti hM hs
  have hint : IntegrableOn (fun x : ℝ => (((a + x : ℝ) : ℂ) ^ (-s))) (Set.Ioi M) :=
    integrableOn_hurwitzTerm hM hs
  have hlim : Tendsto F atTop (nhds 0) := by
    have h := tendsto_hurwitzTerm_atTop_zero (a := a) hs
    have h' : Tendsto (fun x : ℝ => -((((a + x : ℝ) : ℂ) ^ (1 - s)) / (s - 1))) atTop (nhds 0) := by
      have := h.const_mul (-((s - 1)⁻¹))
      simpa [div_eq_mul_inv, mul_comm, mul_left_comm, mul_assoc] using this
    exact h'
  have h := integral_Ioi_of_hasDerivAt_of_tendsto (a := M) (f := F)
    (f' := fun x : ℝ => (((a + x : ℝ) : ℂ) ^ (-s))) (m := 0) hcont hderiv hint hlim
  rw [h]
  simp [F]

noncomputable def rising (s : ℂ) (n : ℕ) : ℂ :=
  ∏ i ∈ Finset.range n, (s + (i : ℂ))

@[simp] lemma rising_zero (s : ℂ) : rising s 0 = 1 := by simp [rising]

lemma rising_succ (s : ℂ) (n : ℕ) :
    rising s (n + 1) = rising s n * (s + n) := by
  simp [rising, Finset.prod_range_succ]

lemma hasDerivAt_hurwitzTerm {a : ℝ} {s : ℂ} {x : ℝ} (hx : 0 < a + x) :
    HasDerivAt (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s)))
      (-s * (((a + x : ℝ) : ℂ) ^ (-s - 1))) x := by
  have hbase : HasDerivAt (fun z : ℂ => (a : ℂ) + z) 1 (x : ℂ) := by
    simpa using (hasDerivAt_id (x : ℂ)).const_add (a : ℂ)
  have hslit : (a : ℂ) + (x : ℂ) ∈ Complex.slitPlane := by
    rw [← Complex.ofReal_add, Complex.ofReal_mem_slitPlane]
    exact hx
  have hG : HasDerivAt (fun z : ℂ => ((a : ℂ) + z) ^ (-s))
      ((-s) * ((a : ℂ) + (x : ℂ)) ^ (-s - 1)) (x : ℂ) := by
    simpa using hbase.cpow_const (c := -s) hslit
  simpa [Complex.ofReal_add] using hG.comp_ofReal

lemma iteratedDeriv_hurwitzTerm_eqOn {a : ℝ} {s : ℂ} (n : ℕ) :
    Set.EqOn (iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))))
      (fun y : ℝ => (-1 : ℂ) ^ n * rising s n * (((a + y : ℝ) : ℂ) ^ (-s - n)))
      (Set.Ioi (-a)) := by
  induction n with
  | zero => intro x hx; simp
  | succ n ih =>
      intro x hx
      rw [iteratedDeriv_succ]
      have hxpos : 0 < a + x := by rw [Set.mem_Ioi] at hx; linarith
      have heq : (fun y : ℝ => (-1 : ℂ) ^ n * rising s n * (((a + y : ℝ) : ℂ) ^ (-s - n)))
          =ᶠ[nhds x] iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) := by
        filter_upwards [Ioi_mem_nhds hx] with y hy
        exact (ih hy).symm
      rw [← heq.deriv_eq]
      have hbase := hasDerivAt_hurwitzTerm (a := a) (s := s + n) hxpos
      have hderiv : HasDerivAt
          (fun y : ℝ => (-1 : ℂ) ^ n * rising s n * (((a + y : ℝ) : ℂ) ^ (-s - n)))
          ((-1 : ℂ) ^ n * rising s n *
            (-(s + n) * (((a + x : ℝ) : ℂ) ^ (-(s + n) - 1)))) x := by
        simpa [mul_assoc, add_comm, add_left_comm, sub_eq_add_neg] using hbase.const_mul ((-1 : ℂ) ^ n * rising s n)
      rw [hderiv.deriv]
      rw [rising_succ]
      have hexp : -(s + n) - 1 = -s - (n + 1) := by ring
      rw [hexp]
      push_cast
      ring_nf

lemma integrableOn_iteratedDeriv_hurwitzTerm {a M : ℝ} (hM : 0 < a + M) {s : ℂ}
    (hs : 1 < s.re) (n : ℕ) :
    IntegrableOn (iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s)))) (Set.Ioi M) := by
  have hs' : 1 < (s + (n : ℂ)).re := by
    rw [Complex.add_re, Complex.natCast_re]
    have : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
    linarith
  have h : IntegrableOn (fun x : ℝ => (((a + x : ℝ) : ℂ) ^ (-(s + (n : ℂ))))) (Set.Ioi M) :=
    integrableOn_hurwitzTerm hM hs'
  have hc : IntegrableOn
      (fun x : ℝ => (-1 : ℂ) ^ n * rising s n * (((a + x : ℝ) : ℂ) ^ (-(s + (n : ℂ)))))
      (Set.Ioi M) :=
    h.const_mul ((-1 : ℂ) ^ n * rising s n)
  apply MeasureTheory.IntegrableOn.congr_fun_ae hc
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
  rw [Set.mem_Ioi] at hx
  have hxpos : 0 < a + x := by linarith
  rw [iteratedDeriv_hurwitzTerm_eqOn n (by rw [Set.mem_Ioi]; linarith)]
  congr 2
  ring

lemma aestronglyMeasurable_periodicBernoulli (n : ℕ) (M : ℝ) :
    AEStronglyMeasurable (fun x : ℝ => (periodicBernoulli n x : ℂ))
      (volume.restrict (Set.Ioi M)) := by
  have h : Measurable (fun x : ℝ =>
      ((Polynomial.eval (Int.fract x) ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ)) : ℝ) : ℂ)) :=
    Complex.continuous_ofReal.measurable.comp
      ((Polynomial.continuous ((Polynomial.bernoulli n).map (algebraMap ℚ ℝ))).measurable.comp
        measurable_fract)
  simpa [periodicBernoulli, Polynomial.eval₂_eq_eval_map] using h.aestronglyMeasurable

lemma integrableOn_periodicBernoulli_mul_iteratedDeriv {a M : ℝ} (hM : 0 < a + M)
    {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 2 ≤ n) :
    IntegrableOn (fun x : ℝ =>
      (periodicBernoulli n x : ℂ) * iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x)
      (Set.Ioi M) := by
  let C : ℝ := ((n.factorial : ℝ) / (2 * Real.pi) ^ n) * (2 * (riemannZeta (n : ℂ)).re)
  have hg : IntegrableOn (iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))))
      (Set.Ioi M) :=
    integrableOn_iteratedDeriv_hurwitzTerm hM hs n
  have hB : AEStronglyMeasurable (fun x : ℝ => (periodicBernoulli n x : ℂ))
      (volume.restrict (Set.Ioi M)) :=
    aestronglyMeasurable_periodicBernoulli n M
  have hbound : ∀ᵐ x ∂(volume.restrict (Set.Ioi M)),
      ‖(periodicBernoulli n x : ℂ)‖ ≤ C :=
    Filter.Eventually.of_forall (fun x => norm_periodicBernoulli_le_zeta hn x)
  simpa [IntegrableOn, mul_comm] using hg.bdd_mul hB hbound

lemma norm_integral_periodicBernoulli_mul_le {a M : ℝ} (hM : 0 < a + M)
    {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 2 ≤ n) :
    ‖∫ x : ℝ in Set.Ioi M,
        (periodicBernoulli n x : ℂ) * iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖ ≤
      (((n.factorial : ℝ) / (2 * Real.pi) ^ n) * (2 * (riemannZeta (n : ℂ)).re)) *
        (∫ x : ℝ in Set.Ioi M,
          ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) := by
  let C : ℝ := ((n.factorial : ℝ) / (2 * Real.pi) ^ n) * (2 * (riemannZeta (n : ℂ)).re)
  let f : ℝ → ℂ := fun x => (periodicBernoulli n x : ℂ) *
    iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x
  have hf : IntegrableOn f (Set.Ioi M) :=
    integrableOn_periodicBernoulli_mul_iteratedDeriv hM hs hn
  have hfg : IntegrableOn (fun x : ℝ => ‖f x‖) (Set.Ioi M) := hf.norm
  have hg : IntegrableOn (fun x : ℝ =>
      ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) (Set.Ioi M) :=
    (integrableOn_iteratedDeriv_hurwitzTerm hM hs n).norm
  have hCg : IntegrableOn (fun x : ℝ =>
      C * ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) (Set.Ioi M) :=
    hg.const_mul C
  calc
    ‖∫ x : ℝ in Set.Ioi M, f x‖ ≤ ∫ x : ℝ in Set.Ioi M, ‖f x‖ :=
      MeasureTheory.norm_integral_le_integral_norm _
    _ ≤ ∫ x : ℝ in Set.Ioi M,
          C * ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖ := by
      apply MeasureTheory.integral_mono_ae hfg hCg
      filter_upwards with x
      dsimp [f]
      rw [norm_mul]
      exact mul_le_mul_of_nonneg_right (norm_periodicBernoulli_le_zeta hn x) (norm_nonneg _)
    _ = C * (∫ x : ℝ in Set.Ioi M,
          ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) := by
      rw [MeasureTheory.integral_const_mul]
    _ = (((n.factorial : ℝ) / (2 * Real.pi) ^ n) * (2 * (riemannZeta (n : ℂ)).re)) *
        (∫ x : ℝ in Set.Ioi M,
          ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) := by
      rfl

lemma integral_Ioi_rpow_shift {a M σ : ℝ} (hM : 0 < a + M) (hσ : 1 < σ) :
    (∫ x : ℝ in Set.Ioi M, (a + x) ^ (-σ)) =
      (a + M) ^ (1 - σ) / (σ - 1) := by
  have h := integral_Ioi_hurwitzTerm (a := a) (M := M) hM (s := (σ : ℂ)) (by simpa using hσ)
  have hcongr : (∫ x : ℝ in Set.Ioi M, (((a + x : ℝ) : ℂ) ^ (-(σ : ℂ)))) =
      ∫ x : ℝ in Set.Ioi M, (((a + x) ^ (-σ) : ℝ) : ℂ) := by
    apply MeasureTheory.setIntegral_congr_fun measurableSet_Ioi
    intro x hx
    rw [Set.mem_Ioi] at hx
    simpa using (Complex.ofReal_cpow (by linarith : 0 ≤ a + x) (-σ)).symm
  rw [hcongr] at h
  change (∫ x : ℝ, (((a + x) ^ (-σ) : ℝ) : ℂ) ∂(volume.restrict (Set.Ioi M))) =
    (((a + M : ℝ) : ℂ) ^ (1 - (σ : ℂ)) / ((σ : ℂ) - 1)) at h
  rw [show (∫ x : ℝ, (((a + x) ^ (-σ) : ℝ) : ℂ) ∂(volume.restrict (Set.Ioi M))) =
      (((∫ x : ℝ, (a + x) ^ (-σ) ∂(volume.restrict (Set.Ioi M))) : ℝ) : ℂ) from
    integral_ofReal] at h
  have hrhs : (((a + M : ℝ) : ℂ) ^ (1 - (σ : ℂ)) / ((σ : ℂ) - 1)) =
      (((a + M) ^ (1 - σ) / (σ - 1) : ℝ) : ℂ) := by
    rw [Complex.ofReal_div, Complex.ofReal_sub, Complex.ofReal_one]
    rw [Complex.ofReal_cpow (by linarith : 0 ≤ a + M)]
    norm_num
  rw [hrhs] at h
  exact Complex.ofReal_injective h

lemma integral_Ioi_norm_iteratedDeriv_hurwitzTerm {a M : ℝ} (hM : 0 < a + M)
    {s : ℂ} (hs : 1 < s.re) (n : ℕ) :
    (∫ x : ℝ in Set.Ioi M,
        ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) =
      ‖rising s n‖ * ((a + M) ^ (1 - (s.re + n)) / (s.re + n - 1)) := by
  calc
    (∫ x : ℝ in Set.Ioi M,
        ‖iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖) =
        ∫ x : ℝ in Set.Ioi M, ‖rising s n‖ * (a + x) ^ (-s.re - n) := by
      apply MeasureTheory.setIntegral_congr_fun measurableSet_Ioi
      intro x hx
      rw [Set.mem_Ioi] at hx
      dsimp only
      have hxpos : 0 < a + x := by linarith
      rw [iteratedDeriv_hurwitzTerm_eqOn n (by rw [Set.mem_Ioi]; linarith)]
      rw [norm_mul, norm_mul, norm_pow, norm_neg, norm_one, one_pow, one_mul]
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
      rw [show (-s - (n : ℂ)).re = -s.re - (n : ℝ) by simp]
    _ = ‖rising s n‖ * (∫ x : ℝ in Set.Ioi M, (a + x) ^ (-s.re - n)) := by
      rw [MeasureTheory.integral_const_mul]
    _ = ‖rising s n‖ * ((a + M) ^ (1 - (s.re + n)) / (s.re + n - 1)) := by
      rw [show -s.re - (n : ℝ) = -(s.re + n) by ring]
      rw [integral_Ioi_rpow_shift hM (by linarith : 1 < s.re + n)]

lemma norm_integral_periodicBernoulli_mul_le_zeta {a M : ℝ} (hM : 0 < a + M)
    {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 2 ≤ n) :
    ‖∫ x : ℝ in Set.Ioi M,
        (periodicBernoulli n x : ℂ) *
          iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖ ≤
      ‖rising s n‖ * (2 * (n.factorial : ℝ) * (riemannZeta (n : ℂ)).re /
        (2 * Real.pi) ^ n) *
        ((a + M) ^ (1 - s.re - n) / (s.re + n - 1)) := by
  have h1 := norm_integral_periodicBernoulli_mul_le hM hs hn
  have h2 := integral_Ioi_norm_iteratedDeriv_hurwitzTerm hM hs n
  rw [h2] at h1
  calc
    ‖∫ x : ℝ in Set.Ioi M, (periodicBernoulli n x : ℂ) *
        iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖ ≤
        ((n.factorial : ℝ) / (2 * Real.pi) ^ n) * (2 * (riemannZeta (n : ℂ)).re) *
          (‖rising s n‖ * ((a + M) ^ (1 - (s.re + n)) / (s.re + n - 1))) := h1
    _ = ‖rising s n‖ * (2 * (n.factorial : ℝ) * (riemannZeta (n : ℂ)).re /
        (2 * Real.pi) ^ n) *
        ((a + M) ^ (1 - s.re - n) / (s.re + n - 1)) := by
      rw [show 1 - (s.re + n) = 1 - s.re - n by ring]
      ring

lemma norm_integral_periodicBernoulli_mul_odd_le {a M : ℝ} (hM : 0 < a + M)
    {s : ℂ} (hs : 1 < s.re) {K : ℕ} (hK : 1 ≤ K) :
    ‖∫ x : ℝ in Set.Ioi M,
        (periodicBernoulli (2 * K + 1) x : ℂ) *
          iteratedDeriv (2 * K + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x‖ ≤
      ‖rising s (2 * K + 1)‖ *
        (2 * ((2 * K + 1).factorial : ℝ) * (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re /
          (2 * Real.pi) ^ (2 * K + 1)) *
        ((a + M) ^ (-s.re - 2 * K) / (s.re + 2 * K)) := by
  have hn : 2 ≤ 2 * K + 1 := by omega
  have h := norm_integral_periodicBernoulli_mul_le_zeta hM hs hn
  convert h using 2
  · push_cast
    ring_nf

noncomputable def hurwitzBase (a x : ℝ) : ℝ :=
  a + (x * Real.smoothTransition (4 * x / a + 1) +
    (-a / 2) * (1 - Real.smoothTransition (4 * x / a + 1)))

lemma hurwitzBase_pos {a : ℝ} (ha : 0 < a) (x : ℝ) : 0 < hurwitzBase a x := by
  let t := Real.smoothTransition (4 * x / a + 1)
  have ht0 : 0 ≤ t := Real.smoothTransition.nonneg _
  have ht1 : t ≤ 1 := Real.smoothTransition.le_one _
  rcases le_or_gt x (-a / 4) with hx | hx
  · have hz : t = 0 := by
      apply Real.smoothTransition.zero_of_nonpos
      have hx' : 4 * x / a ≤ -1 := by
        rw [div_le_iff₀ ha]
        nlinarith
      linarith
    simp [hurwitzBase, t, hz]
    linarith
  · have hxt : (-a / 4) * t ≤ x * t := by
      exact mul_le_mul_of_nonneg_right (le_of_lt hx) ht0
    have h1t : 0 ≤ 1 - t := by linarith
    have hneg : -(a / 2) * (1 - t) ≤ 0 := by nlinarith
    have : (-a / 4) * t + (-(a / 2) * (1 - t)) ≤
        x * t + (-(a / 2) * (1 - t)) := by linarith
    have hlower : -(a / 2) ≤ (-a / 4) * t + (-(a / 2) * (1 - t)) := by
      nlinarith
    simp only [hurwitzBase, t] at *
    nlinarith

lemma hurwitzBase_eq_add {a x : ℝ} (hx : 0 ≤ x) (ha : 0 < a) :
    hurwitzBase a x = a + x := by
  have h1 : Real.smoothTransition (4 * x / a + 1) = 1 := by
    apply Real.smoothTransition.one_of_one_le
    have h4 : 0 ≤ 4 * x / a := div_nonneg (by positivity) (le_of_lt ha)
    linarith
  simp [hurwitzBase, h1]

noncomputable def hurwitzSmooth (a : ℝ) (s : ℂ) (x : ℝ) : ℂ :=
  Complex.exp (-s * ((Real.log (hurwitzBase a x) : ℝ) : ℂ))

lemma hurwitzSmooth_eq_cpow {a : ℝ} (ha : 0 < a) (s : ℂ) (x : ℝ) :
    hurwitzSmooth a s x = (((hurwitzBase a x : ℝ) : ℂ) ^ (-s)) := by
  rw [Complex.cpow_def_of_ne_zero]
  · rw [hurwitzSmooth]
    rw [show -s * ((Real.log (hurwitzBase a x) : ℝ) : ℂ) =
        Complex.log (((hurwitzBase a x : ℝ) : ℂ)) * (-s) by
      rw [Complex.ofReal_log (le_of_lt (hurwitzBase_pos ha x))]
      ring]
  · exact_mod_cast (ne_of_gt (hurwitzBase_pos ha x))

lemma hurwitzSmooth_eq {a : ℝ} (ha : 0 < a) {s : ℂ} {x : ℝ} (hx : 0 ≤ x) :
    hurwitzSmooth a s x = (((a + x : ℝ) : ℂ) ^ (-s)) := by
  rw [hurwitzSmooth_eq_cpow ha, hurwitzBase_eq_add hx ha]

lemma contDiff_hurwitzBase (a : ℝ) : ContDiff ℝ (↑(⊤ : ℕ∞)) (hurwitzBase a) := by
  have hlin : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => 4 * x / a + 1) := by
    fun_prop
  have ht : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => Real.smoothTransition (4 * x / a + 1)) :=
    Real.smoothTransition.contDiff.comp hlin
  have hx : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => x) := contDiff_id
  have h1 : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => 1 - Real.smoothTransition (4 * x / a + 1)) :=
    contDiff_const.sub ht
  have h2 : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => x * Real.smoothTransition (4 * x / a + 1)) :=
    hx.mul ht
  have h3 : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => (-a / 2) * (1 - Real.smoothTransition (4 * x / a + 1))) :=
    contDiff_const.mul h1
  unfold hurwitzBase
  exact contDiff_const.add (h2.add h3)

lemma contDiff_hurwitzSmooth {a : ℝ} (ha : 0 < a) (s : ℂ) :
    ContDiff ℝ (↑(⊤ : ℕ∞)) (hurwitzSmooth a s) := by
  have hb : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => hurwitzBase a x) := contDiff_hurwitzBase a
  have hlog : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => Real.log (hurwitzBase a x)) :=
    hb.log (fun x => ne_of_gt (hurwitzBase_pos ha x))
  have hcast : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => ((Real.log (hurwitzBase a x) : ℝ) : ℂ)) :=
    Complex.ofRealCLM.contDiff.comp hlog
  have hmul : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => -s * ((Real.log (hurwitzBase a x) : ℝ) : ℂ)) :=
    contDiff_const.mul hcast
  exact Complex.contDiff_exp.comp hmul

lemma iteratedDeriv_hurwitzSmooth_eq {a : ℝ} (ha : 0 < a) {s : ℂ} (n : ℕ) {x : ℝ}
    (hx : 0 < x) :
    iteratedDeriv n (hurwitzSmooth a s) x =
      iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x := by
  apply Filter.EventuallyEq.iteratedDeriv_eq
  filter_upwards [Ici_mem_nhds hx] with y hy
  rw [Set.mem_Ici] at hy
  exact hurwitzSmooth_eq ha hy

lemma intervalIntegral_hurwitzSmooth_eq {a : ℝ} (ha : 0 < a) {s : ℂ} {M N : ℝ}
    (hM : 0 ≤ M) (hMN : M ≤ N) :
    (∫ x in M..N, hurwitzSmooth a s x) =
      ∫ x in M..N, (((a + x : ℝ) : ℂ) ^ (-s)) := by
  apply intervalIntegral.integral_congr
  intro x hx
  rw [Set.uIcc_of_le hMN] at hx
  have hx0 : 0 ≤ x := by linarith [hx.1]
  exact hurwitzSmooth_eq ha hx0

lemma finite_eulerMaclaurin_hurwitz (K : ℕ) {a : ℝ} (ha : 0 < a) (s : ℂ)
    (M N : ℕ) (hM : 1 ≤ M) (hMN : M ≤ N) :
    (∑ k ∈ Finset.Icc M N, (((a + k : ℝ) : ℂ) ^ (-s))) =
      (∫ x in (M : ℝ)..(N : ℝ), (((a + x : ℝ) : ℂ) ^ (-s))) +
        ((((a + M : ℝ) : ℂ) ^ (-s) + (((a + N : ℝ) : ℂ) ^ (-s))) / 2) +
        (∑ j ∈ Finset.range K,
          (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
              (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
            (iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (N : ℝ) -
              iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ))) +
        (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
          (∫ x in (M : ℝ)..(N : ℝ),
            (periodicBernoulli (2 * K + 1) x : ℂ) *
              iteratedDeriv (2 * K + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x) := by
  have h := finite_eulerMaclaurin K (hurwitzSmooth a s) (contDiff_hurwitzSmooth ha s) M N hMN
  have hsum : (∑ k ∈ Finset.Icc M N, hurwitzSmooth a s (k : ℝ)) =
      ∑ k ∈ Finset.Icc M N, (((a + k : ℝ) : ℂ) ^ (-s)) := by
    apply Finset.sum_congr rfl
    intro k hk
    rw [Finset.mem_Icc] at hk
    exact hurwitzSmooth_eq ha (by exact_mod_cast (le_trans (Nat.zero_le M) hk.1))
  rw [hsum] at h
  rw [intervalIntegral_hurwitzSmooth_eq (a := a) (s := s) (M := (M : ℝ)) (N := (N : ℝ)) ha
    (by positivity) (by exact_mod_cast hMN)] at h
  rw [hurwitzSmooth_eq ha (by positivity), hurwitzSmooth_eq ha (by positivity)] at h
  have hderiv : (∑ j ∈ Finset.range K,
        (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (iteratedDeriv (2 * j + 1) (hurwitzSmooth a s) (N : ℝ) -
            iteratedDeriv (2 * j + 1) (hurwitzSmooth a s) (M : ℝ))) =
      ∑ j ∈ Finset.range K,
        (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (N : ℝ) -
            iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ)) := by
    apply Finset.sum_congr rfl
    intro j hj
    congr 1
    exact congrArg₂ (fun x y => x - y)
      (iteratedDeriv_hurwitzSmooth_eq ha _ (by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one (le_trans hM hMN))))
      (iteratedDeriv_hurwitzSmooth_eq ha _ (by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hM)))
  rw [hderiv] at h
  have hrem : (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli (2 * K + 1) x : ℂ) *
        iteratedDeriv (2 * K + 1) (hurwitzSmooth a s) x) =
      ∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli (2 * K + 1) x : ℂ) *
        iteratedDeriv (2 * K + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x := by
    apply intervalIntegral.integral_congr
    intro x hx
    rw [Set.uIcc_of_le (by exact_mod_cast hMN)] at hx
    dsimp only
    rw [iteratedDeriv_hurwitzSmooth_eq ha _ (by
      have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hM
      linarith [hx.1])]
  rw [hrem] at h
  exact h

lemma tendsto_hurwitzTerm_neg_atTop_zero {a : ℝ} {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun x : ℝ => (((a + x : ℝ) : ℂ) ^ (-s))) atTop (nhds 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hshift : Tendsto (fun x : ℝ => a + x) atTop atTop := by
    rw [Filter.tendsto_atTop]
    intro b
    filter_upwards [eventually_ge_atTop (b - a)] with x hx
    linarith
  have hrpow : Tendsto (fun x : ℝ => (a + x) ^ (-s.re)) atTop (nhds 0) :=
    (tendsto_rpow_neg_atTop hs).comp hshift
  refine hrpow.congr' ?_
  filter_upwards [eventually_gt_atTop (-a)] with x hx
  have hxpos : 0 < a + x := by linarith
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
  simp

lemma tendsto_sum_Icc_hurwitz {a : ℝ} (ha : 0 < a) {s : ℂ} (hs : 1 < s.re) (M : ℕ) :
    Tendsto (fun N : ℕ => ∑ k ∈ Finset.Icc M N, (((a + k : ℝ) : ℂ) ^ (-s)))
      atTop (nhds (hurwitzZetaNP a s - ∑ k ∈ Finset.range M, (((a + k : ℝ) : ℂ) ^ (-s)))) := by
  let f : ℕ → ℂ := fun k => 1 / ((k : ℂ) + (a : ℂ)) ^ s
  let T : ℕ → ℂ := fun N => ∑ k ∈ Finset.range N, f k
  have hT : Tendsto T atTop (nhds (hurwitzZetaNP a s)) :=
    (hasSum_hurwitzZetaNP ha hs).tendsto_sum_nat
  have hT1 : Tendsto (fun N => T (N + 1)) atTop (nhds (hurwitzZetaNP a s)) :=
    (Filter.tendsto_add_atTop_iff_nat 1).mpr hT
  have hsub : Tendsto (fun N => T (N + 1) - T M) atTop
      (nhds (hurwitzZetaNP a s - T M)) := hT1.sub_const (T M)
  have hterm : ∀ k : ℕ, (((a + k : ℝ) : ℂ) ^ (-s)) = f k := by
    intro k
    rw [show (((a + k : ℝ) : ℂ)) = ((k : ℂ) + (a : ℂ)) by push_cast; ring]
    rw [Complex.cpow_neg]
    simp [f]
  have hinit : (∑ k ∈ Finset.range M, (((a + k : ℝ) : ℂ) ^ (-s))) = T M := by
    apply Finset.sum_congr rfl
    intro k hk
    exact hterm k
  rw [hinit]
  refine hsub.congr' ?_
  filter_upwards [eventually_ge_atTop M] with N hN
  have hNM : M ≤ N + 1 := by omega
  rw [Finset.sum_range_sub_sum_range hNM]
  have hfilter : (Finset.range (N + 1)).filter (fun k => M ≤ k) = Finset.Icc M N := by
    ext k
    simp [Finset.mem_Icc, Finset.mem_range]
    omega
  rw [hfilter]
  apply Finset.sum_congr rfl
  intro k hk
  exact (hterm k).symm

lemma tendsto_intervalIntegral_hurwitz {a M : ℝ} (hM : 0 < a + M) {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun N : ℕ => ∫ x in M..(N : ℝ), (((a + x : ℝ) : ℂ) ^ (-s)))
      atTop (nhds (∫ x : ℝ in Set.Ioi M, (((a + x : ℝ) : ℂ) ^ (-s)))) := by
  have h := intervalIntegral_tendsto_integral_Ioi M (integrableOn_hurwitzTerm hM hs) tendsto_id
  exact h.comp tendsto_natCast_atTop_atTop

lemma tendsto_intervalIntegral_remainder {a M : ℝ} (hM : 0 < a + M) {s : ℂ}
    (hs : 1 < s.re) {n : ℕ} (hn : 2 ≤ n) :
    Tendsto (fun N : ℕ => ∫ x in M..(N : ℝ),
        (periodicBernoulli n x : ℂ) * iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x)
      atTop (nhds (∫ x : ℝ in Set.Ioi M,
        (periodicBernoulli n x : ℂ) * iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x)) := by
  have hint := integrableOn_periodicBernoulli_mul_iteratedDeriv hM hs hn
  have h := intervalIntegral_tendsto_integral_Ioi M hint tendsto_id
  exact h.comp tendsto_natCast_atTop_atTop

lemma tendsto_iteratedDeriv_hurwitzTerm_atTop_zero {a : ℝ} (ha : 0 < a) {s : ℂ}
    (hs : 1 < s.re) (n : ℕ) :
    Tendsto (fun N : ℕ => iteratedDeriv n (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (N : ℝ))
      atTop (nhds 0) := by
  have hpos : 0 < (s + (n : ℂ)).re := by
    rw [Complex.add_re, Complex.natCast_re]
    linarith
  have h := tendsto_hurwitzTerm_neg_atTop_zero (a := a) (s := s + (n : ℂ)) hpos
  have hcomp : Tendsto (fun N : ℕ => (((a + (N : ℝ) : ℝ) : ℂ) ^ (-(s + (n : ℂ)))))
      atTop (nhds 0) := h.comp tendsto_natCast_atTop_atTop
  have hmul := hcomp.const_mul ((-1 : ℂ) ^ n * rising s n)
  have hfinal : Tendsto (fun N : ℕ =>
      ((-1 : ℂ) ^ n * rising s n) * (((a + (N : ℝ) : ℝ) : ℂ) ^ (-(s + (n : ℂ)))))
      atTop (nhds 0) := by
    simpa using hmul
  refine hfinal.congr' ?_
  filter_upwards [eventually_ge_atTop 1] with N hN
  have hNpos : (0 : ℝ) < N := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hN)
  rw [iteratedDeriv_hurwitzTerm_eqOn n (by
    rw [Set.mem_Ioi]
    linarith)]
  congr 2
  ring

lemma tendsto_deriv_sum_hurwitz {a : ℝ} (ha : 0 < a) {s : ℂ} (hs : 1 < s.re)
    (M : ℕ) (K : ℕ) :
    Tendsto (fun N : ℕ => ∑ j ∈ Finset.range K,
        (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (N : ℝ) -
            iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ)))
      atTop (nhds (∑ j ∈ Finset.range K,
        (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (0 - iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ)))) := by
  apply tendsto_finsetSum
  intro j hj
  have h := (tendsto_iteratedDeriv_hurwitzTerm_atTop_zero ha hs (2 * j + 1)).sub_const
    (iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ))
  simpa [sub_eq_add_neg, mul_comm, mul_left_comm, mul_assoc] using
    h.const_mul (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
      (((2 * (j + 1)).factorial : ℕ) : ℂ))

theorem hurwitzZetaNP_eq_eulerMaclaurin {K : ℕ} (hK : 1 ≤ K) {a : ℝ} (ha : 0 < a)
    {s : ℂ} (hs : 1 < s.re) (M : ℕ) (hM : 1 ≤ M) :
    hurwitzZetaNP a s =
      (∑ k ∈ Finset.range M, (((a + k : ℝ) : ℂ) ^ (-s))) +
      (∫ x : ℝ in Set.Ioi (M : ℝ), (((a + x : ℝ) : ℂ) ^ (-s))) +
      ((((a + M : ℝ) : ℂ) ^ (-s)) / 2) +
      (∑ j ∈ Finset.range K,
        (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (0 - iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ))) +
      (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
        (∫ x : ℝ in Set.Ioi (M : ℝ),
          (periodicBernoulli (2 * K + 1) x : ℂ) *
            iteratedDeriv (2 * K + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x) := by
  let f : ℝ → ℂ := fun x => (((a + x : ℝ) : ℂ) ^ (-s))
  let hMpos : (0 : ℝ) < a + M := by
    have : (0 : ℝ) ≤ M := by exact_mod_cast (le_trans (Nat.zero_le 1) hM)
    linarith
  have hS := tendsto_sum_Icc_hurwitz ha hs M
  have hInt := tendsto_intervalIntegral_hurwitz (a := a) (M := (M : ℝ)) hMpos hs
  have hBoundary := (tendsto_hurwitzTerm_neg_atTop_zero (a := a) (s := s) (by linarith)).comp
    tendsto_natCast_atTop_atTop
  have hConst : Tendsto (fun N : ℕ => (((a + M : ℝ) : ℂ) ^ (-s) + (((a + (N : ℝ) : ℝ) : ℂ) ^ (-s))) / 2)
      atTop (nhds ((((a + M : ℝ) : ℂ) ^ (-s) + 0) / 2)) :=
    ((tendsto_const_nhds.add hBoundary).div_const 2)
  have hDeriv := tendsto_deriv_sum_hurwitz ha hs M K
  have hn : 2 ≤ 2 * K + 1 := by omega
  have hRem := tendsto_intervalIntegral_remainder (a := a) (M := (M : ℝ)) hMpos hs hn
  have hR : Tendsto (fun N : ℕ =>
      (∫ x in (M : ℝ)..(N : ℝ), f x) +
        ((f (M : ℝ) + f (N : ℝ)) / 2) +
        (∑ j ∈ Finset.range K,
          (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
              (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
            (iteratedDeriv (2 * j + 1) f (N : ℝ) - iteratedDeriv (2 * j + 1) f (M : ℝ))) +
        (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
          (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli (2 * K + 1) x : ℂ) *
            iteratedDeriv (2 * K + 1) f x))
      atTop (nhds (
        (∫ x : ℝ in Set.Ioi (M : ℝ), f x) +
          ((((a + M : ℝ) : ℂ) ^ (-s) + 0) / 2) +
          (∑ j ∈ Finset.range K,
            (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
                (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
              (0 - iteratedDeriv (2 * j + 1) f (M : ℝ))) +
          (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
            (∫ x : ℝ in Set.Ioi (M : ℝ), (periodicBernoulli (2 * K + 1) x : ℂ) *
              iteratedDeriv (2 * K + 1) f x))) := by
    simpa [f] using ((hInt.add hConst).add hDeriv).add (hRem.const_mul _)
  have hFinite : ∀ᶠ N : ℕ in atTop,
      (∑ k ∈ Finset.Icc M N, f (k : ℝ)) =
      (∫ x in (M : ℝ)..(N : ℝ), f x) +
        ((f (M : ℝ) + f (N : ℝ)) / 2) +
        (∑ j ∈ Finset.range K,
          (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
              (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
            (iteratedDeriv (2 * j + 1) f (N : ℝ) - iteratedDeriv (2 * j + 1) f (M : ℝ))) +
        (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
          (∫ x in (M : ℝ)..(N : ℝ), (periodicBernoulli (2 * K + 1) x : ℂ) *
            iteratedDeriv (2 * K + 1) f x) := by
    filter_upwards [eventually_ge_atTop M] with N hN
    have h := finite_eulerMaclaurin_hurwitz K ha s M N hM hN
    simpa [f] using h
  have hR' : Tendsto (fun N : ℕ => ∑ k ∈ Finset.Icc M N, f (k : ℝ)) atTop
      (nhds ((∫ x : ℝ in Set.Ioi (M : ℝ), f x) +
          ((((a + M : ℝ) : ℂ) ^ (-s) + 0) / 2) +
          (∑ j ∈ Finset.range K,
            (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
                (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
              (0 - iteratedDeriv (2 * j + 1) f (M : ℝ))) +
          (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
            (∫ x : ℝ in Set.Ioi (M : ℝ), (periodicBernoulli (2 * K + 1) x : ℂ) *
              iteratedDeriv (2 * K + 1) f x))) :=
    hR.congr' (by filter_upwards [hFinite] with N hN; exact hN.symm)
  have heq := tendsto_nhds_unique hS hR'
  simp only [f] at heq
  rw [sub_eq_iff_eq_add] at heq
  rw [heq]
  ring_nf

theorem hurwitzZetaNP_eulerMaclaurin_with_bound {K : ℕ} (hK : 1 ≤ K) {a : ℝ} (ha : 0 < a)
    {s : ℂ} (hs : 1 < s.re) (M : ℕ) (hM : 1 ≤ M) :
    let F : ℂ := (((2 * K + 1).factorial : ℕ) : ℂ)
    let J : ℂ := ∫ x : ℝ in Set.Ioi (M : ℝ),
      (periodicBernoulli (2 * K + 1) x : ℂ) *
        iteratedDeriv (2 * K + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) x
    hurwitzZetaNP a s =
      (∑ k ∈ Finset.range M, (((a + k : ℝ) : ℂ) ^ (-s))) +
      (∫ x : ℝ in Set.Ioi (M : ℝ), (((a + x : ℝ) : ℂ) ^ (-s))) +
      ((((a + M : ℝ) : ℂ) ^ (-s)) / 2) +
      (∑ j ∈ Finset.range K,
        (((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (0 - iteratedDeriv (2 * j + 1) (fun y : ℝ => (((a + y : ℝ) : ℂ) ^ (-s))) (M : ℝ))) +
      (1 / F) * J ∧
    ‖(1 / F) * J‖ ≤
      ‖rising s (2 * K + 1)‖ *
        (2 * (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)) *
        ((a + M) ^ (-s.re - 2 * K) / (s.re + 2 * K)) := by
  intro F J
  have hS1 := hurwitzZetaNP_eq_eulerMaclaurin hK ha hs M hM
  have hJ := norm_integral_periodicBernoulli_mul_odd_le (a := a) (M := (M : ℝ)) (by
    have hM0 : (0 : ℝ) ≤ M := by exact_mod_cast (le_trans (Nat.zero_le 1) hM)
    linarith) hs hK
  constructor
  · simpa [F, J] using hS1
  · have hFpos : (0 : ℝ) < ((2 * K + 1).factorial : ℝ) := by positivity
    have hFne : ((2 * K + 1).factorial : ℂ) ≠ 0 := by
      exact_mod_cast (ne_of_gt hFpos)
    have hnormF : ‖(1 / F)‖ = 1 / ((2 * K + 1).factorial : ℝ) := by
      rw [norm_div, norm_one, Complex.norm_natCast]
    rw [norm_mul, hnormF]
    calc
      (1 / ((2 * K + 1).factorial : ℝ)) * ‖J‖ ≤
          (1 / ((2 * K + 1).factorial : ℝ)) *
            (‖rising s (2 * K + 1)‖ *
              (2 * ((2 * K + 1).factorial : ℝ) *
                (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)) *
              ((a + M) ^ (-s.re - 2 * K) / (s.re + 2 * K))) := by
        apply mul_le_mul_of_nonneg_left hJ
        positivity
      _ = ‖rising s (2 * K + 1)‖ *
            (2 * (riemannZeta ((2 * K + 1 : ℕ) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)) *
            ((a + M) ^ (-s.re - 2 * K) / (s.re + 2 * K)) := by
        field_simp [ne_of_gt hFpos]

end PartialTail
