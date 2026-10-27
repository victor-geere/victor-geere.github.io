import Mathlib

/-! First bricks toward a Lean Euler--Maclaurin remainder.

Mathlib has Bernoulli numbers and Bernoulli polynomials, but no
Euler--Maclaurin summation formula.  This file proves the vanishing of the
integral of `B_n` over `[0,1]` for `n ≥ 1`, the first ingredient.
-/

noncomputable section

namespace FiniteWindowZeros

open Polynomial
open Filter
open MeasureTheory
open scoped Topology

/-- The Bernoulli polynomial `B_n` over `ℝ`. -/
def BR (n : ℕ) : ℝ[X] := (Polynomial.bernoulli n).map (algebraMap ℚ ℝ)

theorem BR_derivative (n : ℕ) : (BR (n + 1)).derivative = (n + 1) • BR n := by
  unfold BR
  rw [Polynomial.derivative_map, Polynomial.derivative_bernoulli_add_one]
  simp [Polynomial.map_mul, Polynomial.map_natCast]

theorem BR_eval_one_eq_zero {n : ℕ} (hn : 1 ≤ n) :
    (BR (n + 1)).eval 1 = (BR (n + 1)).eval 0 := by
  unfold BR
  have h1 : (1 : ℝ) = algebraMap ℚ ℝ (1 : ℚ) := by norm_num
  have h0 : (0 : ℝ) = algebraMap ℚ ℝ (0 : ℚ) := by norm_num
  rw [h1, h0, Polynomial.eval_map_algebraMap, Polynomial.eval_map_algebraMap]
  rw [Polynomial.aeval_algebraMap_apply_eq_algebraMap_eval,
    Polynomial.aeval_algebraMap_apply_eq_algebraMap_eval]
  rw [Polynomial.bernoulli_eval_one, Polynomial.bernoulli_eval_zero]
  have hne : n + 1 ≠ 1 := by omega
  rw [bernoulli_eq_bernoulli'_of_ne_one hne]

theorem integral_bernoulli {n : ℕ} (hn : 1 ≤ n) :
    ∫ x in (0:ℝ)..1, (BR n).eval x = 0 := by
  have hderiv : ∀ x : ℝ,
      HasDerivAt (fun y : ℝ => (BR (n + 1)).eval y / (n + 1)) ((BR n).eval x) x := by
    intro x
    have h := (BR (n + 1)).hasDerivAt x
    have hdiv := h.div_const ((n + 1 : ℕ) : ℝ)
    rw [BR_derivative] at hdiv
    have hcast : ((n + 1 : ℕ) : ℝ) ≠ 0 := by positivity
    have hdiv' : HasDerivAt (fun y : ℝ => (BR (n + 1)).eval y / (n + 1))
        (((n + 1 : ℝ) * (BR n).eval x) / (n + 1)) x := by
      simpa [Polynomial.eval_smul, smul_eq_mul] using hdiv
    convert hdiv' using 1
    field_simp
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ => hderiv x)
    ((by fun_prop : Continuous fun x : ℝ => (BR n).eval x).intervalIntegrable 0 1)]
  rw [BR_eval_one_eq_zero hn]
  ring

theorem integral_bernoulli_one :
    ∫ x in (0:ℝ)..1, (BR 1).eval x = 0 :=
  integral_bernoulli (n := 1) (by norm_num)

/-- Periodic Bernoulli function `B_n({x})`. -/
def periodicBernoulli (n : ℕ) (x : ℝ) : ℝ := (BR n).eval (Int.fract x)

theorem periodicBernoulli_add_int (n : ℕ) (x : ℝ) (k : ℤ) :
    periodicBernoulli n (x + k) = periodicBernoulli n x := by
  unfold periodicBernoulli
  simpa using Int.fract_add_intCast x k

theorem integral_periodicBernoulli {n : ℕ} (hn : 1 ≤ n) (k : ℤ) :
    ∫ x in (k : ℝ)..(k + 1), periodicBernoulli n x = 0 := by
  calc
    ∫ x in (k : ℝ)..(k + 1), periodicBernoulli n x
        = ∫ t in (0 : ℝ)..1, periodicBernoulli n (t + k) := by
          rw [intervalIntegral.integral_comp_add_right
            (f := periodicBernoulli n) (a := (0 : ℝ)) (b := 1) (d := (k : ℝ))]
          norm_num
          rw [add_comm (1 : ℝ) (k : ℝ)]
    _ = ∫ t in (0 : ℝ)..1, periodicBernoulli n t := by
          apply intervalIntegral.integral_congr
          intro t _
          exact periodicBernoulli_add_int n t k
    _ = ∫ t in (0 : ℝ)..1, (BR n).eval t := by
          apply intervalIntegral.integral_congr_Ioo_of_le (by norm_num : (0:ℝ) ≤ 1)
          intro t ht
          unfold periodicBernoulli
          rw [Int.fract_eq_self.2 ⟨le_of_lt ht.1, ht.2⟩]
    _ = 0 := integral_bernoulli hn

theorem continuousAt_periodicBernoulli_of_not_int (n : ℕ) {x : ℝ}
    (hx : x ≠ ⌊x⌋) : ContinuousAt (periodicBernoulli n) x := by
  unfold periodicBernoulli
  exact (BR n).continuous.continuousAt.comp (continuousAt_fract hx)

theorem continuousAt_periodicBernoulli_int {n : ℕ} (hn : 2 ≤ n) (m : ℤ) :
    ContinuousAt (periodicBernoulli n) (m : ℝ) := by
  have hval : (BR n).eval 1 = (BR n).eval 0 := by
    simpa [Nat.sub_add_cancel (by omega : 1 ≤ n)] using
      BR_eval_one_eq_zero (n := n - 1) (by omega)
  have hleft : Tendsto (fun x : ℝ => (BR n).eval (Int.fract x)) (𝓝[<] (m : ℝ))
      (𝓝 ((BR n).eval 0)) := by
    have h := ((BR n).continuous.continuousAt.tendsto).comp (tendsto_fract_left' m)
    simpa [Function.comp_def, hval] using h
  have hright : Tendsto (fun x : ℝ => (BR n).eval (Int.fract x)) (𝓝[≥] (m : ℝ))
      (𝓝 ((BR n).eval 0)) := by
    simpa [Function.comp_def] using
      ((BR n).continuous.continuousAt.tendsto).comp (tendsto_fract_right' m)
  rw [ContinuousAt, ← nhdsLT_sup_nhdsGE]
  change Tendsto (fun x : ℝ => (BR n).eval (Int.fract x))
    (𝓝[<] (m : ℝ) ⊔ 𝓝[≥] (m : ℝ)) (𝓝 ((BR n).eval (Int.fract (m : ℝ))))
  rw [Int.fract_intCast]
  exact hleft.sup hright

theorem hasDerivAt_BR_div (n : ℕ) (x : ℝ) :
    HasDerivAt (fun y : ℝ => (BR (n + 1)).eval y * (1 / (n + 1))) ((BR n).eval x) x := by
  have h := ((BR (n + 1)).hasDerivAt x).mul_const (1 / (n + 1))
  rw [BR_derivative] at h
  convert h using 1
  simp only [Polynomial.eval_smul, smul_eq_mul]
  field_simp
  ring

/-- One-step summation by parts on `[0,1]`. -/
theorem sum_by_parts_zero_one {f f' : ℝ → ℝ} {n : ℕ} (hn : 1 ≤ n)
    (hf : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (0:ℝ) 1))
    (hf' : IntervalIntegrable f' volume 0 1) :
    ∫ x in (0:ℝ)..1, f x * (BR n).eval x =
      (BR (n + 1)).eval 0 * (1 / (n + 1)) * (f 1 - f 0) -
        (1 / (n + 1)) * ∫ x in (0:ℝ)..1, f' x * (BR (n + 1)).eval x := by
  let v : ℝ → ℝ := fun x => (BR (n + 1)).eval x * (1 / (n + 1))
  have hvcont : ContinuousOn v (Set.uIcc (0:ℝ) 1) := by
    apply Continuous.continuousOn
    fun_prop
  have hvv' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1),
      HasDerivAt v ((BR n).eval x) x := by
    intro x _
    exact hasDerivAt_BR_div n x
  have hIBP := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := f) (v := v) (u' := f') (v' := fun x => (BR n).eval x)
    hfc hvcont hf hvv' hf'
    ((BR n).continuous.intervalIntegrable 0 1)
  have hv1 : v 1 = (BR (n + 1)).eval 0 * (1 / (n + 1)) := by
    simp [v, BR_eval_one_eq_zero hn]
  have hv0 : v 0 = (BR (n + 1)).eval 0 * (1 / (n + 1)) := by
    simp [v]
  have hrv : ∫ x in (0:ℝ)..1, f' x * v x =
      (∫ x in (0:ℝ)..1, f' x * (BR (n + 1)).eval x) * (1 / (n + 1)) := by
    calc
      ∫ x in (0:ℝ)..1, f' x * v x
          = ∫ x in (0:ℝ)..1, (f' x * (BR (n + 1)).eval x) * (1 / (n + 1)) := by
            apply intervalIntegral.integral_congr
            intro x _
            simp [v, mul_assoc, mul_comm, mul_left_comm]
      _ = (∫ x in (0:ℝ)..1, f' x * (BR (n + 1)).eval x) * (1 / (n + 1)) := by
            rw [intervalIntegral.integral_mul_const]
  calc
    ∫ x in (0:ℝ)..1, f x * (BR n).eval x
        = f 1 * v 1 - f 0 * v 0 - ∫ x in (0:ℝ)..1, f' x * v x := hIBP
    _ = (BR (n + 1)).eval 0 * (1 / (n + 1)) * (f 1 - f 0) -
          (1 / (n + 1)) * ∫ x in (0:ℝ)..1, f' x * (BR (n + 1)).eval x := by
          rw [hv1, hv0, hrv]
          ring

/-- The base Euler--Maclaurin integration-by-parts identity. -/
theorem integral_B1_mul_deriv {f f' : ℝ → ℝ}
    (hf : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (0:ℝ) 1))
    (hf' : IntervalIntegrable f' volume 0 1) :
    ∫ x in (0:ℝ)..1, (x - 1 / 2) * f' x = (f 1 + f 0) / 2 - ∫ x in (0:ℝ)..1, f x := by
  let u : ℝ → ℝ := fun x => x - 1 / 2
  have hucont : ContinuousOn u (Set.uIcc (0:ℝ) 1) := by
    apply Continuous.continuousOn
    fun_prop
  have hu' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt u 1 x := by
    intro x _
    have h := (hasDerivAt_id x).sub_const (1 / 2)
    simpa [u] using h
  have hIBP := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := u) (v := f) (u' := fun _ => (1:ℝ)) (v' := f')
    hucont hfc hu' hf
    ((continuous_const : Continuous fun _ : ℝ => (1:ℝ)).intervalIntegrable (μ := volume) 0 1)
    hf'
  have hu1 : u 1 = 1 / 2 := by norm_num [u]
  have hu0 : u 0 = -(1 / 2) := by norm_num [u]
  rw [hu1, hu0] at hIBP
  calc
    ∫ x in (0:ℝ)..1, (x - 1 / 2) * f' x
        = (1 / 2) * f 1 - (-(1 / 2)) * f 0 - ∫ x in (0:ℝ)..1, (1:ℝ) * f x := hIBP
    _ = (f 1 + f 0) / 2 - ∫ x in (0:ℝ)..1, f x := by
          simp only [one_mul]
          ring



theorem continuousOn_comp_add_int (k : ℤ) {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.uIcc (k : ℝ) (k + 1))) :
    ContinuousOn (fun t : ℝ => f (t + k)) (Set.uIcc (0 : ℝ) 1) := by
  refine hf.comp (by fun_prop) ?_
  intro t ht
  have ht0 : (0:ℝ) ≤ t := by simpa using ht.1
  have ht1 : t ≤ 1 := by simpa using ht.2
  have hk : (k : ℝ) ≤ k + 1 := by norm_num
  constructor
  · have hmin : min (k : ℝ) (k + 1) = k := min_eq_left hk
    rw [hmin]
    linarith
  · have hmax : max (k : ℝ) (k + 1) = k + 1 := max_eq_right hk
    rw [hmax]
    linarith

theorem intervalIntegrable_comp_add_int (k : ℤ) {f : ℝ → ℝ}
    (hf : IntervalIntegrable f MeasureTheory.volume (k : ℝ) (k + 1)) :
    IntervalIntegrable (fun t : ℝ => f (t + k)) MeasureTheory.volume (0 : ℝ) 1 := by
  have h := IntervalIntegrable.comp_add_right (f := f) (a := (k : ℝ)) (b := (k : ℝ) + 1)
    hf (k : ℝ) (by simp)
  simpa using h

theorem integral_B1_mul_deriv_int (k : ℤ) {f f' : ℝ → ℝ}
    (hf : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hf' : IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    ∫ x in (k:ℝ)..(k+1), (x - k - 1 / 2) * f' x =
      (f (k+1) + f k) / 2 - ∫ x in (k:ℝ)..(k+1), f x := by
  let g : ℝ → ℝ := fun t => f (t + k)
  let g' : ℝ → ℝ := fun t => f' (t + k)
  have hg : ∀ t ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt g (g' t) t := by
    intro t ht
    have hmin : min (0:ℝ) 1 = 0 := min_eq_left (by norm_num)
    have hmax : max (0:ℝ) 1 = 1 := max_eq_right (by norm_num)
    have ht0 : (0:ℝ) < t := by
      have h := ht.1
      rw [hmin] at h
      exact h
    have ht1 : t < 1 := by
      have h := ht.2
      rw [hmax] at h
      exact h
    have hk : (k:ℝ) ≤ k + 1 := by norm_num
    have hmem : t + k ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)) := by
      constructor
      · rw [min_eq_left hk]; linarith
      · rw [max_eq_right hk]; linarith
    have hinner : HasDerivAt (fun t : ℝ => t + (k:ℝ)) 1 t := by
      simpa using (hasDerivAt_id t).add_const (k:ℝ)
    have h := HasDerivAt.scomp (x := t) (hf _ hmem) hinner
    simpa [g, g', Function.comp_def, mul_one] using h
  have hgc : ContinuousOn g (Set.uIcc (0:ℝ) 1) := continuousOn_comp_add_int k hfc
  have hg'int : IntervalIntegrable g' volume 0 1 := by
    simpa [g'] using intervalIntegrable_comp_add_int k hf'
  have hbase := integral_B1_mul_deriv (f := g) (f' := g') hg hgc hg'int
  have hL : ∫ t in (0:ℝ)..1, (t - 1 / 2) * g' t =
      ∫ x in (k:ℝ)..(k+1), (x - k - 1 / 2) * f' x := by
    have h := intervalIntegral.integral_comp_add_right
      (f := fun x : ℝ => (x - k - 1 / 2) * f' x) (a := (0:ℝ)) (b := 1) (d := (k:ℝ))
    rw [show (0:ℝ) + k = (k:ℝ) by ring,
      show (1:ℝ) + k = (k:ℝ) + 1 by ring] at h
    rw [← h]
    apply intervalIntegral.integral_congr
    intro t _
    simp [g']
  have hR : ∫ t in (0:ℝ)..1, g t = ∫ x in (k:ℝ)..(k+1), f x := by
    have h := intervalIntegral.integral_comp_add_right
      (f := f) (a := (0:ℝ)) (b := 1) (d := (k:ℝ))
    rw [show (0:ℝ) + k = (k:ℝ) by ring,
      show (1:ℝ) + k = (k:ℝ) + 1 by ring] at h
    rw [← h]
  rw [hL, hR] at hbase
  have hg1 : g 1 = f (k+1) := by
    simp only [g]
    congr 1
    ring
  have hg0 : g 0 = f k := by
    simp only [g]
    congr 1
    ring
  rw [hg1, hg0] at hbase
  exact hbase





/-- Finite Euler–Maclaurin summation on `[0,n]`. -/
theorem sum_range_euler_maclaurin (f f' : ℝ → ℝ)
    (hf : ∀ x : ℝ, HasDerivAt f (f' x) x)
    (hf' : ∀ x : ℝ, ContinuousAt f' x) :
    ∀ n : ℕ,
      (Finset.sum (Finset.range n) (fun k => f k)) =
        (∫ x in (0:ℝ)..n, f x) +
          (Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), (x - k - 1 / 2) * f' x)) -
          (f n - f 0) / 2 := by
  intro n
  induction n with
  | zero =>
      simpa using Real.rpow_nonneg (by positivity : (0:ℝ) ≤ (N:ℝ) + 1) (-σ)
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have hcont : Continuous f := continuous_iff_continuousAt.mpr (fun x => (hf x).continuousAt)
    have hInt : ∀ a b : ℝ, IntervalIntegrable f MeasureTheory.volume a b := fun a b => hcont.intervalIntegrable a b
    have hsplit := intervalIntegral.integral_add_adjacent_intervals
      (f := f) (a := (0:ℝ)) (b := (n:ℝ)) (c := (n:ℝ) + 1)
      (hInt 0 n) (hInt n (n+1))
    rw [show ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 by norm_num]
    rw [← hsplit]
    have hT := integral_B1_mul_deriv_int (k := (n:ℤ))
      (fun x _ => hf x)
      (hcont.continuousOn)
      ((continuous_iff_continuousAt.mpr hf').intervalIntegrable (n:ℝ) ((n:ℝ)+1))
    rw [show ((n:ℤ):ℝ) = (n:ℝ) by norm_num] at hT
    rw [Finset.sum_range_succ]
    rw [hT]
    norm_num
    ring



/-- Two-step Bernoulli expansion on `[0,1]`. -/
theorem sum_by_parts_two_step {f f' f'' : ℝ → ℝ} {n : ℕ} (hn : 1 ≤ n)
    (hf : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (0:ℝ) 1))
    (hf'int : IntervalIntegrable f' volume 0 1)
    (hf' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f' (f'' x) x)
    (hf'c : ContinuousOn f' (Set.uIcc (0:ℝ) 1))
    (hf''int : IntervalIntegrable f'' volume 0 1) :
    ∫ x in (0:ℝ)..1, f x * (BR n).eval x =
      (BR (n + 1)).eval 0 * (1 / (n + 1)) * (f 1 - f 0) -
        (1 / (n + 1)) *
          ((BR (n + 2)).eval 0 * (1 / (n + 2)) * (f' 1 - f' 0) -
            (1 / (n + 2)) * ∫ x in (0:ℝ)..1, f'' x * (BR (n + 2)).eval x) := by
  have h1 := sum_by_parts_zero_one (n := n) hn hf hfc hf'int
  have h2 := sum_by_parts_zero_one (n := n + 1) (by omega) hf' hf'c hf''int
  rw [h2] at h1
  simpa [Nat.add_assoc, Nat.cast_add, Nat.cast_one,
    show ((n:ℝ) + 1 + 1) = (n:ℝ) + 2 by ring] using h1



/-- Three-step Bernoulli expansion on `[0,1]`. -/
theorem sum_by_parts_three_step {f f' f'' f''' : ℝ → ℝ} {n : ℕ} (hn : 1 ≤ n)
    (hf : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (0:ℝ) 1))
    (hf'int : IntervalIntegrable f' volume 0 1)
    (hf' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f' (f'' x) x)
    (hf'c : ContinuousOn f' (Set.uIcc (0:ℝ) 1))
    (hf''int : IntervalIntegrable f'' volume 0 1)
    (hf'' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f'' (f''' x) x)
    (hf''c : ContinuousOn f'' (Set.uIcc (0:ℝ) 1))
    (hf'''int : IntervalIntegrable f''' volume 0 1) :
    ∫ x in (0:ℝ)..1, f x * (BR n).eval x =
      (BR (n + 1)).eval 0 * (1 / (n + 1)) * (f 1 - f 0) -
        (1 / (n + 1)) *
          ((BR (n + 2)).eval 0 * (1 / (n + 2)) * (f' 1 - f' 0) -
            (1 / (n + 2)) *
              ((BR (n + 3)).eval 0 * (1 / (n + 3)) * (f'' 1 - f'' 0) -
                (1 / (n + 3)) * ∫ x in (0:ℝ)..1, f''' x * (BR (n + 3)).eval x)) := by
  have h1 := sum_by_parts_two_step (n := n) hn hf hfc hf'int hf' hf'c hf''int
  have h2 := sum_by_parts_zero_one (n := n + 2) (by omega) hf'' hf''c hf'''int
  rw [h2] at h1
  simpa [Nat.add_assoc, Nat.cast_add, Nat.cast_one,
    show ((n:ℝ) + 2 + 1) = (n:ℝ) + 3 by ring] using h1



/-- Recursive Euler–Maclaurin expansion with `K` Bernoulli corrections. -/
def emExpansion (n K : ℕ) (g : ℕ → ℝ → ℝ) : ℝ :=
  match K with
  | 0 => ∫ x in (0:ℝ)..1, g 0 x * (BR n).eval x
  | K + 1 =>
      (BR (n + 1)).eval 0 * (1 / (n + 1)) * (g 0 1 - g 0 0) -
        (1 / (n + 1)) * emExpansion (n + 1) K (fun j => g (j + 1))

/-- General Euler–Maclaurin expansion by induction on the number of corrections. -/
theorem integral_eq_emExpansion (n K : ℕ) (g : ℕ → ℝ → ℝ) (hn : 1 ≤ n)
    (hderiv : ∀ j, j ≤ K → ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1),
      HasDerivAt (g j) (g (j + 1) x) x)
    (hcont : ∀ j, j ≤ K → ContinuousOn (g j) (Set.uIcc (0:ℝ) 1))
    (hint : ∀ j, j ≤ K → IntervalIntegrable (g (j + 1)) volume 0 1) :
    ∫ x in (0:ℝ)..1, g 0 x * (BR n).eval x = emExpansion n K g := by
  induction K generalizing n g with
  | zero =>
      simp [emExpansion]
  | succ K ih =>
    have hstep := sum_by_parts_zero_one (n := n) hn
      (hderiv 0 (by omega)) (hcont 0 (by omega)) (hint 0 (by omega))
    rw [hstep]
    have hrec := ih (n + 1) (fun j => g (j + 1)) (by omega)
      (fun j hj x hx => hderiv (j + 1) (by omega) x hx)
      (fun j hj => hcont (j + 1) (by omega))
      (fun j hj => hint (j + 1) (by omega))
    rw [hrec]
    simp only [emExpansion]



/-- Derivative of the shifted power `(x+1)^{-σ}` on `x ≥ 0`. -/
theorem hasDerivAt_one_add_rpow (σ x : ℝ) (hx : 0 ≤ x) :
    HasDerivAt (fun y : ℝ => (y + 1) ^ (-σ)) (-σ * (x + 1) ^ (-σ - 1)) x := by
  have hbase : HasDerivAt (fun y : ℝ => y + 1) 1 x := by
    simpa using (hasDerivAt_id x).add_const 1
  have hpow : HasDerivAt (fun y : ℝ => y ^ (-σ)) (-σ * (x + 1) ^ (-σ - 1)) (x + 1) := by
    have h := Real.hasDerivAt_rpow_const (x := x + 1) (p := -σ) (Or.inl (by positivity))
    simpa using h
  have h := hpow.comp x hbase
  simpa [Function.comp_def, mul_assoc, mul_comm, mul_left_comm] using h



/-- Derivative of the complex power `x^{-s}` for `x > 0`. -/
theorem hasDerivAt_Complex.cpow_neg (s : ℂ) {x : ℝ} (hx : 0 < x) :
    HasDerivAt (fun y : ℝ => (y : ℂ) ^ (-s)) (-s * (x : ℂ) ^ (-s - 1)) x := by
  have hmem : (x : ℂ) ∈ Complex.slitPlane := Complex.ofReal_mem_slitPlane.2 hx
  have hg := (Complex.hasStrictDerivAt_cpow_const (c := -s) hmem).hasDerivAt
  have hh : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 x := Complex.ofRealCLM.hasDerivAt
  have h := HasDerivAt.scomp (x := x) hg hh
  simpa [Function.comp_def, one_smul] using h



/-- Complex-valued one-step summation by parts on `[0,1]`. -/
theorem sum_by_parts_zero_one_complex {f f' : ℝ → ℂ} {n : ℕ} (hn : 1 ≤ n)
    (hf : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (0:ℝ) 1))
    (hf' : IntervalIntegrable f' volume 0 1) :
    ∫ x in (0:ℝ)..1, f x * (((BR n).eval x : ℝ) : ℂ) =
      (((BR (n + 1)).eval 0 : ℝ) : ℂ) * (1 / (n + 1)) * (f 1 - f 0) -
        (1 / (n + 1)) * ∫ x in (0:ℝ)..1, f' x * (((BR (n + 1)).eval x : ℝ) : ℂ) := by
  let v : ℝ → ℂ := fun x => (((BR (n + 1)).eval x : ℝ) : ℂ) * (1 / (n + 1))
  have hvcont : ContinuousOn v (Set.uIcc (0:ℝ) 1) := by
    apply Continuous.continuousOn
    fun_prop
  have hvv' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1),
      HasDerivAt v (((BR n).eval x : ℝ) : ℂ) x := by
    intro x _
    simpa [v] using (hasDerivAt_BR_div n x).ofReal_comp
  have hIBP := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := f) (v := v) (u' := f') (v' := fun x => (((BR n).eval x : ℝ) : ℂ))
    hfc hvcont hf hvv' hf'
    ((Complex.continuous_ofReal.comp (BR n).continuous).intervalIntegrable 0 1)
  have hv1 : v 1 = (((BR (n + 1)).eval 0 : ℝ) : ℂ) * (1 / (n + 1)) := by
    simp [v, BR_eval_one_eq_zero hn]
  have hv0 : v 0 = (((BR (n + 1)).eval 0 : ℝ) : ℂ) * (1 / (n + 1)) := by
    simp [v]
  have hrv : ∫ x in (0:ℝ)..1, f' x * v x =
      (∫ x in (0:ℝ)..1, f' x * (((BR (n + 1)).eval x : ℝ) : ℂ)) * (1 / (n + 1)) := by
    calc
      ∫ x in (0:ℝ)..1, f' x * v x
          = ∫ x in (0:ℝ)..1, (f' x * (((BR (n + 1)).eval x : ℝ) : ℂ)) * (1 / (n + 1)) := by
            apply intervalIntegral.integral_congr
            intro x _
            simp [v, mul_assoc, mul_comm, mul_left_comm]
      _ = (∫ x in (0:ℝ)..1, f' x * (((BR (n + 1)).eval x : ℝ) : ℂ)) * (1 / (n + 1)) := by
            rw [intervalIntegral.integral_mul_const]
  calc
    ∫ x in (0:ℝ)..1, f x * (((BR n).eval x : ℝ) : ℂ)
        = f 1 * v 1 - f 0 * v 0 - ∫ x in (0:ℝ)..1, f' x * v x := hIBP
    _ = (((BR (n + 1)).eval 0 : ℝ) : ℂ) * (1 / (n + 1)) * (f 1 - f 0) -
          (1 / (n + 1)) * ∫ x in (0:ℝ)..1, f' x * (((BR (n + 1)).eval x : ℝ) : ℂ) := by
          rw [hv1, hv0, hrv]
          ring



/-- Recursive Euler–Maclaurin expansion for `ℂ`-valued functions. -/
def emExpansionC (n K : ℕ) (g : ℕ → ℝ → ℂ) : ℂ :=
  match K with
  | 0 => ∫ x in (0:ℝ)..1, g 0 x * (((BR n).eval x : ℝ) : ℂ)
  | K + 1 =>
      (((BR (n + 1)).eval 0 : ℝ) : ℂ) * (1 / (n + 1)) * (g 0 1 - g 0 0) -
        (1 / (n + 1)) * emExpansionC (n + 1) K (fun j => g (j + 1))

/-- General Euler–Maclaurin expansion for `ℂ`-valued functions. -/
theorem integral_eq_emExpansionC (n K : ℕ) (g : ℕ → ℝ → ℂ) (hn : 1 ≤ n)
    (hderiv : ∀ j, j ≤ K → ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1),
      HasDerivAt (g j) (g (j + 1) x) x)
    (hcont : ∀ j, j ≤ K → ContinuousOn (g j) (Set.uIcc (0:ℝ) 1))
    (hint : ∀ j, j ≤ K → IntervalIntegrable (g (j + 1)) volume 0 1) :
    ∫ x in (0:ℝ)..1, g 0 x * (((BR n).eval x : ℝ) : ℂ) = emExpansionC n K g := by
  induction K generalizing n g with
  | zero =>
      simp [emExpansionC]
  | succ K ih =>
    have hstep := sum_by_parts_zero_one_complex (n := n) hn
      (hderiv 0 (by omega)) (hcont 0 (by omega)) (hint 0 (by omega))
    rw [hstep]
    have hrec := ih (n + 1) (fun j => g (j + 1)) (by omega)
      (fun j hj x hx => hderiv (j + 1) (by omega) x hx)
      (fun j hj => hcont (j + 1) (by omega))
      (fun j hj => hint (j + 1) (by omega))
    rw [hrec]
    simp only [emExpansionC]



/-- The `j`-th derivative factor of `(x+1)^{-s}`. -/
def emG (s : ℂ) (j : ℕ) (x : ℝ) : ℂ :=
  (descPochhammer ℂ j).eval (-s) * (((x + 1 : ℝ) : ℂ) ^ (-(s + (j : ℂ))))

theorem emG_succ (s : ℂ) (j : ℕ) :
    (descPochhammer ℂ (j + 1)).eval (-s) =
      (descPochhammer ℂ j).eval (-s) * (-(s + (j : ℂ))) := by
  rw [descPochhammer_succ_right, Polynomial.eval_mul, Polynomial.eval_sub,
    Polynomial.eval_X, Polynomial.eval_natCast]
  ring

theorem hasDerivAt_emG (s : ℂ) (j : ℕ) {x : ℝ} (hx : 0 ≤ x) :
    HasDerivAt (emG s j) (emG s (j + 1) x) x := by
  have hbase : (0:ℝ) < x + 1 := by linarith
  have hmem : (((x + 1 : ℝ) : ℂ)) ∈ Complex.slitPlane :=
    Complex.ofReal_mem_slitPlane.2 hbase
  have hc := (Complex.hasStrictDerivAt_cpow_const (c := -(s + (j : ℂ))) hmem).hasDerivAt
  have hh : HasDerivAt (fun y : ℝ => (((y + 1 : ℝ) : ℂ))) 1 x := by
    simpa [Complex.ofReal_add] using (Complex.ofRealCLM.hasDerivAt.add_const 1)
  have hcomp := HasDerivAt.scomp (x := x) hc hh
  have h := hcomp.const_mul ((descPochhammer ℂ j).eval (-s))
  convert h using 1
  · ext y
    simp [emG, Complex.ofReal_add]
  · simp [emG, emG_succ]
    ring



/-- The complex Euler–Maclaurin expansion for the derivative tower `emG`. -/
theorem integral_emG_eq_emExpansionC (s : ℂ) (n K : ℕ) (hn : 1 ≤ n) :
    ∫ x in (0:ℝ)..1, emG s 0 x * (((BR n).eval x : ℝ) : ℂ) =
      emExpansionC n K (emG s) := by
  apply integral_eq_emExpansionC n K (fun j => emG s j) hn
  · intro j hj x hx
    have hmin : min (0:ℝ) 1 = 0 := min_eq_left (by norm_num)
    have hmax : max (0:ℝ) 1 = 1 := max_eq_right (by norm_num)
    have hx0 : (0:ℝ) < x := by
      have h := hx.1
      rw [hmin] at h
      exact h
    exact hasDerivAt_emG s j (le_of_lt hx0)
  · intro j hj x hx
    have hmin : min (0:ℝ) 1 = 0 := min_eq_left (by norm_num)
    have hmax : max (0:ℝ) 1 = 1 := max_eq_right (by norm_num)
    have hx0 : (0:ℝ) ≤ x := by
      have h := hx.1
      rw [hmin] at h
      exact h
    exact (hasDerivAt_emG s j hx0).continuousAt.continuousWithinAt
  · intro j hj
    exact (by
      have hcont : ContinuousOn (emG s (j + 1)) (Set.Icc (0:ℝ) 1) := by
        intro x hx
        exact (hasDerivAt_emG s (j + 1) hx.1).continuousAt.continuousWithinAt
      exact hcont.intervalIntegrable_of_Icc (by norm_num : (0:ℝ) ≤ 1))



/-- Euler–Maclaurin for the complex power `(x+1)^{-s}` on `[0,1]`. -/
theorem integral_cpow_eq_emExpansionC (s : ℂ) (n K : ℕ) (hn : 1 ≤ n) :
    ∫ x in (0:ℝ)..1, (((x + 1 : ℝ) : ℂ) ^ (-s)) * (((BR n).eval x : ℝ) : ℂ) =
      emExpansionC n K (emG s) := by
  simpa [emG] using integral_emG_eq_emExpansionC s n K hn



theorem continuousOn_comp_add_int_complex (k : ℤ) {f : ℝ → ℂ}
    (hf : ContinuousOn f (Set.uIcc (k : ℝ) (k + 1))) :
    ContinuousOn (fun t : ℝ => f (t + k)) (Set.uIcc (0 : ℝ) 1) := by
  refine hf.comp (by fun_prop) ?_
  intro t ht
  have hmin : min (k : ℝ) (k + 1) = k := min_eq_left (by norm_num)
  have hmax : max (k : ℝ) (k + 1) = k + 1 := max_eq_right (by norm_num)
  have ht0 : (0:ℝ) ≤ t := by
    have h := ht.1
    rw [min_eq_left (by norm_num : (0:ℝ) ≤ 1)] at h
    exact h
  have ht1 : t ≤ 1 := by
    have h := ht.2
    rw [max_eq_right (by norm_num : (0:ℝ) ≤ 1)] at h
    exact h
  constructor
  · rw [hmin]; linarith
  · rw [hmax]; linarith

theorem intervalIntegrable_comp_add_int_complex (k : ℤ) {f : ℝ → ℂ}
    (hf : IntervalIntegrable f MeasureTheory.volume (k : ℝ) (k + 1)) :
    IntervalIntegrable (fun t : ℝ => f (t + k)) MeasureTheory.volume (0 : ℝ) 1 := by
  have h := IntervalIntegrable.comp_add_right (f := f) (a := (k : ℝ)) (b := (k : ℝ) + 1)
    hf (k : ℝ) (by simp)
  simpa using h

/-- Complex base Euler–Maclaurin identity on `[0,1]`. -/
theorem integral_B1_mul_deriv_complex {f f' : ℝ → ℂ}
    (hf : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (0:ℝ) 1))
    (hf' : IntervalIntegrable f' volume 0 1) :
    ∫ x in (0:ℝ)..1, (((x - 1 / 2 : ℝ) : ℂ)) * f' x =
      (f 1 + f 0) / 2 - ∫ x in (0:ℝ)..1, f x := by
  let u : ℝ → ℂ := fun x => ((x - 1 / 2 : ℝ) : ℂ)
  have hucont : ContinuousOn u (Set.uIcc (0:ℝ) 1) := by
    apply Continuous.continuousOn
    fun_prop
  have hu' : ∀ x ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt u 1 x := by
    intro x _
    have h : HasDerivAt (fun y : ℝ => ((y - 1 / 2 : ℝ) : ℂ)) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (1 / 2) |>.ofReal_comp
    simpa [u] using h
  have hIBP := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := u) (v := f) (u' := fun _ => (1:ℂ)) (v' := f')
    hucont hfc hu' hf
    ((continuous_const : Continuous fun _ : ℝ => (1:ℂ)).intervalIntegrable 0 1)
    hf'
  have hu1 : u 1 = 1 / 2 := by norm_num [u]
  have hu0 : u 0 = -(1 / 2) := by norm_num [u]
  rw [hu1, hu0] at hIBP
  calc
    ∫ x in (0:ℝ)..1, (((x - 1 / 2 : ℝ) : ℂ)) * f' x
        = (1 / 2) * f 1 - (-(1 / 2)) * f 0 - ∫ x in (0:ℝ)..1, (1:ℂ) * f x := hIBP
    _ = (f 1 + f 0) / 2 - ∫ x in (0:ℝ)..1, f x := by
          simp only [one_mul]
          ring



/-- Complex interval Euler–Maclaurin identity. -/
theorem integral_B1_mul_deriv_int_complex (k : ℤ) {f f' : ℝ → ℂ}
    (hf : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hf' : IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * f' x =
      (f (k+1) + f k) / 2 - ∫ x in (k:ℝ)..(k+1), f x := by
  let g : ℝ → ℂ := fun t => f (t + k)
  let g' : ℝ → ℂ := fun t => f' (t + k)
  have hg : ∀ t ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt g (g' t) t := by
    intro t ht
    have hmin : min (0:ℝ) 1 = 0 := min_eq_left (by norm_num)
    have hmax : max (0:ℝ) 1 = 1 := max_eq_right (by norm_num)
    have ht0 : (0:ℝ) < t := by
      have h := ht.1; rw [hmin] at h; exact h
    have ht1 : t < 1 := by
      have h := ht.2; rw [hmax] at h; exact h
    have hk : (k:ℝ) ≤ k + 1 := by norm_num
    have hmem : t + k ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)) := by
      constructor
      · rw [min_eq_left hk]; linarith
      · rw [max_eq_right hk]; linarith
    have hinner : HasDerivAt (fun t : ℝ => t + (k:ℝ)) 1 t := by
      simpa using (hasDerivAt_id t).add_const (k:ℝ)
    have h := HasDerivAt.scomp (x := t) (hf _ hmem) hinner
    simpa [g, g', Function.comp_def, mul_one] using h
  have hgc : ContinuousOn g (Set.uIcc (0:ℝ) 1) := continuousOn_comp_add_int_complex k hfc
  have hg'int : IntervalIntegrable g' volume 0 1 := by
    simpa [g'] using intervalIntegrable_comp_add_int_complex k hf'
  have hbase := integral_B1_mul_deriv_complex (f := g) (f' := g') hg hgc hg'int
  have hL : ∫ t in (0:ℝ)..1, (((t - 1 / 2 : ℝ) : ℂ)) * g' t =
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * f' x := by
    have h := intervalIntegral.integral_comp_add_right
      (f := fun x : ℝ => (((x - k - 1 / 2 : ℝ) : ℂ)) * f' x)
      (a := (0:ℝ)) (b := 1) (d := (k:ℝ))
    rw [show (0:ℝ) + k = (k:ℝ) by ring,
      show (1:ℝ) + k = (k:ℝ) + 1 by ring] at h
    rw [← h]
    apply intervalIntegral.integral_congr
    intro t _
    simp [g']
  have hR : ∫ t in (0:ℝ)..1, g t = ∫ x in (k:ℝ)..(k+1), f x := by
    have h := intervalIntegral.integral_comp_add_right
      (f := f) (a := (0:ℝ)) (b := 1) (d := (k:ℝ))
    rw [show (0:ℝ) + k = (k:ℝ) by ring,
      show (1:ℝ) + k = (k:ℝ) + 1 by ring] at h
    rw [← h]
  rw [hL, hR] at hbase
  have hg1 : g 1 = f (k+1) := by simp only [g]; congr 1; ring
  have hg0 : g 0 = f k := by simp only [g]; congr 1; ring
  rw [hg1, hg0] at hbase
  exact hbase



/-- Second-order correction identity on `[k,k+1]`. -/
theorem integral_B1_mul_deriv_int_one (k : ℤ) {f' f'' : ℝ → ℂ}
    (hf' : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f' (f'' x) x)
    (hf'c : ContinuousOn f' (Set.uIcc (k:ℝ) (k+1)))
    (hf'int : IntervalIntegrable f' volume (k:ℝ) (k+1))
    (hf''int : IntervalIntegrable f'' volume (k:ℝ) (k+1)) :
    ∫ x in (k:ℝ)..(k+1), f' x * (((x - k - 1 / 2 : ℝ) : ℂ)) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (f' (k+1) - f' k) -
        (1 / 2) * ∫ x in (k:ℝ)..(k+1), f'' x * (((BR 2).eval (x - k) : ℝ) : ℂ) := by
  let g : ℝ → ℂ := fun t => f' (t + k)
  let g' : ℝ → ℂ := fun t => f'' (t + k)
  have hg : ∀ t ∈ Set.Ioo (min (0:ℝ) 1) (max (0:ℝ) 1), HasDerivAt g (g' t) t := by
    intro t ht
    have hmin : min (0:ℝ) 1 = 0 := min_eq_left (by norm_num)
    have hmax : max (0:ℝ) 1 = 1 := max_eq_right (by norm_num)
    have ht0 : (0:ℝ) < t := by
      have h := ht.1; rw [hmin] at h; exact h
    have ht1 : t < 1 := by
      have h := ht.2; rw [hmax] at h; exact h
    have hk : (k:ℝ) ≤ k + 1 := by norm_num
    have hmem : t + k ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)) := by
      constructor
      · rw [min_eq_left hk]; linarith
      · rw [max_eq_right hk]; linarith
    have hinner : HasDerivAt (fun t : ℝ => t + (k:ℝ)) 1 t := by
      simpa using (hasDerivAt_id t).add_const (k:ℝ)
    have h := HasDerivAt.scomp (x := t) (hf' _ hmem) hinner
    simpa [g, g', Function.comp_def, mul_one] using h
  have hgc : ContinuousOn g (Set.uIcc (0:ℝ) 1) := continuousOn_comp_add_int_complex k hf'c
  have hg'int : IntervalIntegrable g' volume 0 1 := by
    simpa [g'] using intervalIntegrable_comp_add_int_complex k hf''int
  have hstep := sum_by_parts_zero_one_complex (n := 1) (by norm_num) hg hgc hg'int
  have hL : ∫ t in (0:ℝ)..1, g t * (((BR 1).eval t : ℝ) : ℂ) =
      ∫ x in (k:ℝ)..(k+1), f' x * (((x - k - 1 / 2 : ℝ) : ℂ)) := by
    have h := intervalIntegral.integral_comp_add_right
      (f := fun x : ℝ => f' x * (((x - k - 1 / 2 : ℝ) : ℂ)))
      (a := (0:ℝ)) (b := 1) (d := (k:ℝ))
    rw [show (0:ℝ) + k = (k:ℝ) by ring,
      show (1:ℝ) + k = (k:ℝ) + 1 by ring] at h
    simpa [g, BR, Polynomial.bernoulli_one] using h
  have hR : ∫ t in (0:ℝ)..1, g' t * (((BR 2).eval t : ℝ) : ℂ) =
      ∫ x in (k:ℝ)..(k+1), f'' x * (((BR 2).eval (x - k) : ℝ) : ℂ) := by
    have h := intervalIntegral.integral_comp_add_right
      (f := fun x : ℝ => f'' x * (((BR 2).eval (x - k) : ℝ) : ℂ))
      (a := (0:ℝ)) (b := 1) (d := (k:ℝ))
    rw [show (0:ℝ) + k = (k:ℝ) by ring,
      show (1:ℝ) + k = (k:ℝ) + 1 by ring] at h
    simpa [g'] using h
  rw [hL, hR] at hstep
  have hg1 : g 1 = f' (k+1) := by simp only [g]; congr 1; ring
  have hg0 : g 0 = f' k := by simp only [g]; congr 1; ring
  rw [hg1, hg0] at hstep
  convert hstep using 1 <;> norm_num



/-- Telescoping sum over `range`. -/
theorem sum_range_sub_complex (g : ℕ → ℂ) (n : ℕ) :
    Finset.sum (Finset.range n) (fun k => g (k + 1) - g k) = g n - g 0 := by
  rw [Finset.sum_range_sub]

/-- Second-order interval identity indexed by a natural number. -/
theorem integral_B1_mul_deriv_nat (k : ℕ) {f' f'' : ℝ → ℂ}
    (hf' : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f' (f'' x) x)
    (hf'c : ContinuousOn f' (Set.uIcc (k:ℝ) (k+1)))
    (hf'int : IntervalIntegrable f' volume (k:ℝ) (k+1))
    (hf''int : IntervalIntegrable f'' volume (k:ℝ) (k+1)) :
    ∫ x in (k:ℝ)..(k+1), f' x * (((x - k - 1 / 2 : ℝ) : ℂ)) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (f' (k+1) - f' k) -
        (1 / 2) * ∫ x in (k:ℝ)..(k+1), f'' x * (((BR 2).eval (x - k) : ℝ) : ℂ) := by
  have h := integral_B1_mul_deriv_int_one (k := (k:ℤ)) hf' hf'c hf'int hf''int
  simpa [Nat.cast_add, Nat.cast_one] using h



/-- Telescoping for the `emG` first derivative. -/
theorem sum_range_emG_one_sub (s : ℂ) (n : ℕ) :
    Finset.sum (Finset.range n) (fun k => emG s 1 (k + 1) - emG s 1 k) =
      emG s 1 n - emG s 1 0 := by
  simpa using sum_range_sub_complex (fun k => emG s 1 k) n



/-- Summed second-order correction identity. -/
theorem sum_correction_second_order (s : ℂ) (n : ℕ) :
    Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 1 x * (((x - k - 1 / 2 : ℝ) : ℂ))) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have hterm : ∀ k : ℕ,
      (∫ x in (k:ℝ)..(k+1), emG s 1 x * (((x - k - 1 / 2 : ℝ) : ℂ))) =
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 (k+1) - emG s 1 k) -
          (1 / 2) * ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ) := by
    intro k
    have hderiv : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)),
        HasDerivAt (emG s 1) (emG s 2 x) x := by
      intro x hx
      have hmin : min (k:ℝ) (k+1) = (k:ℝ) := min_eq_left (by linarith)
      have h := hx.1
      rw [hmin] at h
      exact hasDerivAt_emG s 1 (by linarith)
    have hcont : ContinuousOn (emG s 1) (Set.uIcc (k:ℝ) (k+1)) := by
      intro x hx
      have hx0 : (0:ℝ) ≤ x := by
        have h : (k:ℝ) ≤ x := by
          simpa [Set.uIcc_of_le (by linarith : (k:ℝ) ≤ (k:ℝ)+1)] using hx.1
        exact le_trans (by positivity) h
      exact (hasDerivAt_emG s 1 hx0).continuousAt.continuousWithinAt
    have hint1 : IntervalIntegrable (emG s 1) volume (k:ℝ) (k+1) := by
      have hc : ContinuousOn (emG s 1) (Set.Icc (k:ℝ) (k+1)) := by
        intro x hx
        exact (hasDerivAt_emG s 1 (le_trans (by positivity) hx.1)).continuousAt.continuousWithinAt
      exact ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume) (by linarith) hc
    have hint2 : IntervalIntegrable (emG s 2) volume (k:ℝ) (k+1) := by
      have hc : ContinuousOn (emG s 2) (Set.Icc (k:ℝ) (k+1)) := by
        intro x hx
        exact (hasDerivAt_emG s 2 (le_trans (by positivity) hx.1)).continuousAt.continuousWithinAt
      exact ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume) (by linarith) hc
    exact integral_B1_mul_deriv_nat k hderiv hcont hint1 hint2
  calc
    Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 1 x * (((x - k - 1 / 2 : ℝ) : ℂ)))
        = Finset.sum (Finset.range n) (fun k =>
            (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 (k+1) - emG s 1 k) -
              (1 / 2) * ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
          apply Finset.sum_congr rfl
          intro k hk
          exact hterm k
    _ = (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
          (1 / 2) * Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
          rw [Finset.sum_sub_distrib]
          rw [← Finset.mul_sum, ← Finset.mul_sum]
          rw [sum_range_emG_one_sub]





/-- Complex finite Euler–Maclaurin summation on `[0,n]`. -/
theorem sum_range_euler_maclaurin_complex (f f' : ℝ → ℂ)
    (hf : ∀ x : ℝ, HasDerivAt f (f' x) x)
    (hf' : ∀ x : ℝ, ContinuousAt f' x) :
    ∀ n : ℕ,
      (Finset.sum (Finset.range n) (fun k => f k)) =
        (∫ x in (0:ℝ)..n, f x) +
          (Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * f' x)) -
          (f n - f 0) / 2 := by
  intro n
  induction n with
  | zero =>
      simpa using Real.rpow_nonneg (by positivity : (0:ℝ) ≤ (N:ℝ) + 1) (-σ)
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have hcont : Continuous f := continuous_iff_continuousAt.mpr (fun x => (hf x).continuousAt)
    have hInt : ∀ a b : ℝ, IntervalIntegrable f MeasureTheory.volume a b := fun a b => hcont.intervalIntegrable a b
    have hsplit := intervalIntegral.integral_add_adjacent_intervals
      (f := f) (a := (0:ℝ)) (b := (n:ℝ)) (c := (n:ℝ) + 1)
      (hInt 0 n) (hInt n (n+1))
    rw [show ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 by norm_num]
    rw [← hsplit]
    have hT := integral_B1_mul_deriv_int_complex (k := (n:ℤ))
      (fun x _ => hf x)
      (hcont.continuousOn)
      ((continuous_iff_continuousAt.mpr hf').intervalIntegrable (n:ℝ) ((n:ℝ)+1))
    rw [show ((n:ℤ):ℝ) = (n:ℝ) by norm_num] at hT
    rw [Finset.sum_range_succ]
    rw [hT]
    norm_num
    ring



/-- Complex finite Euler–Maclaurin summation for functions differentiable on `[0,∞)`. -/
theorem sum_range_euler_maclaurin_complex_nonneg (f f' : ℝ → ℂ)
    (hf : ∀ x : ℝ, 0 ≤ x → HasDerivAt f (f' x) x)
    (hf' : ∀ x : ℝ, 0 ≤ x → ContinuousAt f' x) :
    ∀ n : ℕ,
      (Finset.sum (Finset.range n) (fun k => f k)) =
        (∫ x in (0:ℝ)..n, f x) +
          (Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * f' x)) -
          (f n - f 0) / 2 := by
  intro n
  induction n with
  | zero =>
      simpa using Real.rpow_nonneg (by positivity : (0:ℝ) ≤ (N:ℝ) + 1) (-σ)
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have hcont : ContinuousOn f (Set.Icc (0:ℝ) ((n:ℝ) + 1)) := by
      intro x hx
      exact (hf x hx.1).continuousAt.continuousWithinAt
    have hcont0 : ContinuousOn f (Set.Icc (0:ℝ) (n:ℝ)) :=
      hcont.mono (by intro x hx; exact ⟨hx.1, by linarith [hx.2]⟩)
    have hcontn : ContinuousOn f (Set.Icc (n:ℝ) ((n:ℝ)+1)) :=
      hcont.mono (by intro x hx; exact ⟨by linarith [hx.1], hx.2⟩)
    have hsplit := intervalIntegral.integral_add_adjacent_intervals
      (f := f) (a := (0:ℝ)) (b := (n:ℝ)) (c := (n:ℝ) + 1)
      (ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume)
        (by positivity) hcont0)
      (ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume)
        (by linarith) hcontn)
    rw [show ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 by norm_num]
    rw [← hsplit]
    have hcontn' : ContinuousOn f (Set.uIcc (n:ℝ) ((n:ℝ)+1)) := by
      simpa [Set.uIcc_of_le (by linarith : (n:ℝ) ≤ (n:ℝ)+1)] using hcontn
    have hf'int : IntervalIntegrable f' MeasureTheory.volume (n:ℝ) ((n:ℝ)+1) := by
      have hc : ContinuousOn f' (Set.Icc (n:ℝ) ((n:ℝ)+1)) := by
        intro x hx
        exact (hf' x (by linarith [hx.1])).continuousWithinAt
      exact ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume)
        (by linarith) hc
    have hT := integral_B1_mul_deriv_int_complex (k := (n:ℤ))
      (fun x hx => hf x (by
        have hmin : min (n:ℝ) ((n:ℝ)+1) = (n:ℝ) := min_eq_left (by linarith)
        have hcast : ((n:ℤ):ℝ) = (n:ℝ) := by norm_num
        have h := hx.1
        rw [hcast, hmin] at h
        linarith))
      hcontn' hf'int
    rw [Finset.sum_range_succ]
    rw [show ((n:ℤ):ℝ) = (n:ℝ) by norm_num] at hT
    rw [hT]
    norm_num
    ring



/-- Finite Euler–Maclaurin for the shifted power `(k+1)^{-s}`. -/
theorem sum_shifted_cpow_euler_maclaurin (s : ℂ) :
    ∀ n : ℕ,
      (Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) =
        (∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) +
          (Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1),
              (((x - k - 1 / 2 : ℝ) : ℂ)) *
                (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))) -
          ((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2 := by
  intro n
  have h := sum_range_euler_maclaurin_complex_nonneg (emG s 0) (emG s 1)
    (fun x hx => hasDerivAt_emG s 0 hx)
    (fun x hx => (hasDerivAt_emG s 1 hx).continuousAt) n
  simpa [emG, Finset.sum_neg_distrib, neg_mul,
    show (-1 + -s : ℂ) = -s - 1 by ring] using h



/-- Norm of `x^{-s}` for positive real `x`. -/
theorem norm_Complex.cpow_neg_ofReal {s : ℂ} {x : ℝ} (hx : 0 < x) :
    ‖((x : ℂ) ^ (-s))‖ = x ^ (-s.re) := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hx]
  simp



/-- Pointwise bound for the Euler–Maclaurin correction integrand. -/
theorem norm_correction_integrand_le {s : ℂ} {k : ℕ} {x : ℝ}
    (hs : -1 ≤ s.re) (hx0 : (k:ℝ) ≤ x) (hx1 : x ≤ (k:ℝ) + 1) :
    ‖(((x - k - 1 / 2 : ℝ) : ℂ)) * (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1)))‖
      ≤ ‖s‖ * (1 / 2) * ((k + 1 : ℝ) ^ (-s.re - 1)) := by
  have hbase : (0:ℝ) < (k:ℝ) + 1 := by positivity
  have hxpos : (0:ℝ) < x + 1 := by linarith
  have hk1 : (k:ℝ) + 1 ≤ x + 1 := by linarith
  have hexp : -s.re - 1 ≤ 0 := by linarith
  have hnormpow : ‖(((x + 1 : ℝ) : ℂ) ^ (-s - 1))‖ =
      (x + 1) ^ (-s.re - 1) := by
    have h := norm_Complex.cpow_neg_ofReal (s := s + 1) (x := x + 1) hxpos
    simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc, Complex.add_re] using h
  have hpowle : (x + 1) ^ (-s.re - 1) ≤ ((k:ℝ) + 1) ^ (-s.re - 1) := by
    have h := Real.rpow_le_rpow_of_nonpos hbase hk1 hexp
    simpa [add_comm] using h
  have habs : |x - k - 1 / 2| ≤ 1 / 2 := by
    rw [abs_le]
    constructor <;> linarith
  calc
    ‖(((x - k - 1 / 2 : ℝ) : ℂ)) * (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1)))‖
        = |x - k - 1 / 2| * ‖s‖ * ‖(((x + 1 : ℝ) : ℂ) ^ (-s - 1))‖ := by
          rw [norm_mul, norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs]
          ring_nf
    _ ≤ (1 / 2) * ‖s‖ * ((k:ℝ) + 1) ^ (-s.re - 1) := by
          apply mul_le_mul
          · apply mul_le_mul habs le_rfl (norm_nonneg _) (by norm_num)
          · exact le_trans (by rw [hnormpow]) hpowle
          · positivity
          · positivity
    _ = ‖s‖ * (1 / 2) * ((k + 1 : ℝ) ^ (-s.re - 1)) := by ring



/-- Integral bound for one Euler–Maclaurin correction term. -/
theorem norm_integral_correction_le {s : ℂ} {k : ℕ} (hs : -1 ≤ s.re) :
    ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
      (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1)))‖
      ≤ ‖s‖ * (1 / 2) * ((k + 1 : ℝ) ^ (-s.re - 1)) := by
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (k:ℝ)) (b := (k:ℝ) + 1)
    (C := ‖s‖ * (1 / 2) * ((k + 1 : ℝ) ^ (-s.re - 1)))
    (f := fun x : ℝ => (((x - k - 1 / 2 : ℝ) : ℂ)) *
      (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))
    (by
      intro x hx
      have hmin : min (k:ℝ) ((k:ℝ)+1) = (k:ℝ) := min_eq_left (by linarith)
      have hmax : max (k:ℝ) ((k:ℝ)+1) = (k:ℝ)+1 := max_eq_right (by linarith)
      have hx0 : (k:ℝ) < x := by
        have h := hx.1; rw [hmin] at h; exact h
      have hx1 : x ≤ (k:ℝ)+1 := by
        have h := hx.2; rw [hmax] at h; exact h
      exact norm_correction_integrand_le hs (le_of_lt hx0) hx1)
  simpa using h



/-- Summed correction bound. -/
theorem norm_sum_correction_le {s : ℂ} (hs : -1 ≤ s.re) (n : ℕ) :
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
        (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))‖
      ≤ ‖s‖ * (1 / 2) *
        Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1))) := by
  calc
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
        (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))‖
        ≤ Finset.sum (Finset.range n) (fun k =>
            ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
              (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1)))‖) := by
          exact norm_sum_le _ _
    _ ≤ Finset.sum (Finset.range n) (fun k =>
          ‖s‖ * (1 / 2) * ((k + 1 : ℝ) ^ (-s.re - 1))) := by
          apply Finset.sum_le_sum
          intro k hk
          exact norm_integral_correction_le hs
    _ = ‖s‖ * (1 / 2) *
          Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1))) := by
          rw [Finset.mul_sum]

/-- Crude bound on the correction weights. -/
theorem sum_shifted_rpow_le {s : ℂ} (hs : 0 ≤ s.re) (n : ℕ) :
    Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1))) ≤ n := by
  calc
    Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1)))
        ≤ Finset.sum (Finset.range n) (fun _ => (1:ℝ)) := by
          apply Finset.sum_le_sum
          intro k hk
          have hexp : -s.re - 1 ≤ 0 := by linarith
          have hk : (1:ℝ) ≤ (k:ℝ) + 1 := by
            have hk0 : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
            linarith
          have h := Real.rpow_le_rpow_of_nonpos (x := (1:ℝ)) (y := (k:ℝ) + 1)
            (z := -s.re - 1) (by norm_num) hk hexp
          simpa using h
    _ = n := by simp



/-- Finite value enclosure for `Σ_{k<n} (k+1)^{-s}`. -/
theorem finite_sum_enclosure {s : ℂ} (hs0 : 0 ≤ s.re) (n : ℕ) :
    ‖(Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) -
      ((∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2))‖
      ≤ (n : ℝ) * ‖s‖ / 2 := by
  have h44 := sum_shifted_cpow_euler_maclaurin s n
  have hcorr := norm_sum_correction_le (s := s) (by linarith : -1 ≤ s.re) n
  have hw := sum_shifted_rpow_le hs0 n
  have hbound : ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
        (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))‖ ≤ (n : ℝ) * ‖s‖ / 2 := by
    calc
      ‖Finset.sum (Finset.range n) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
          (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))‖
          ≤ ‖s‖ * (1 / 2) *
              Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1))) := hcorr
      _ ≤ ‖s‖ * (1 / 2) * (n : ℝ) := by
            apply mul_le_mul_of_nonneg_left hw
            positivity
      _ = (n : ℝ) * ‖s‖ / 2 := by ring
  have harg : (Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) -
      ((∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2)) =
      Finset.sum (Finset.range n) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
          (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1)))) := by
    rw [h44]
    ring
  rw [harg]
  exact hbound



/-- Monotonicity of the shifted power weight. -/
theorem antitoneOn_shifted_rpow {σ : ℝ} (hσ : 0 < σ) :
    AntitoneOn (fun x : ℝ => (x + 1) ^ (-σ - 1)) (Set.Ici 0) := by
  intro x hx y hy hxy
  have hx0 : (0:ℝ) ≤ x := hx
  have hx1 : (0:ℝ) < x + 1 := by linarith
  have hxy1 : x + 1 ≤ y + 1 := by linarith
  have hexp : -σ - 1 ≤ 0 := by linarith
  exact Real.rpow_le_rpow_of_nonpos hx1 hxy1 hexp

/-- Integral bound for the tail weight. -/
theorem integral_rpow_neg_le_inv {σ : ℝ} (hσ : 0 < σ) {a b : ℝ}
    (ha : 1 ≤ a) (hab : a ≤ b) :
    ∫ x in a..b, x ^ (-σ - 1) ≤ 1 / σ := by
  have h0 : (0:ℝ) ∉ Set.uIcc a b := by
    rw [Set.uIcc_of_le hab]
    intro h
    linarith [h.1]
  rw [integral_rpow (Or.inr ⟨by linarith, h0⟩)]
  simp only [show (-σ - 1 + 1) = -σ by ring]
  have hb : 0 ≤ b ^ (-σ) := Real.rpow_nonneg (by linarith [ha, hab]) _
  have ha0 : 0 ≤ a ^ (-σ) := Real.rpow_nonneg (by linarith [ha]) _
  have hale : a ^ (-σ) ≤ 1 := by
    have h := Real.rpow_le_rpow_of_nonpos (x := (1:ℝ)) (y := a) (z := -σ)
      (by norm_num) ha (by linarith)
    simpa using h
  have hEq : (b ^ (-σ) - a ^ (-σ)) / (-σ) = (a ^ (-σ) - b ^ (-σ)) / σ := by
    field_simp
    ring
  rw [hEq]
  rw [div_le_iff₀ (by linarith : (0:ℝ) < σ)]
  have hone : (1 / σ) * σ = 1 := by field_simp
  rw [hone]
  nlinarith [hale, hb]



/-- Sharp bound for the correction weights. -/
theorem sum_shifted_rpow_le_inv {σ : ℝ} (hσ : 0 < σ) (n : ℕ) :
    Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-σ - 1))) ≤ 1 + 1 / σ := by
  rcases n with _ | m
  · simp
    positivity
  · let g : ℝ → ℝ := fun x => x ^ (-σ - 1)
    have hanti : AntitoneOn g (Set.Icc (1:ℝ) (1 + m)) := by
      intro x hx y hy hxy
      exact Real.rpow_le_rpow_of_nonpos (by linarith [hx.1]) hxy (by linarith)
    have hcomp := hanti.sum_le_integral (x₀ := (1:ℝ)) (a := m)
    have hsplit : (Finset.sum (Finset.range (m + 1)) (fun k => g (k + 1))) =
        g 1 + Finset.sum (Finset.range m) (fun i => g (1 + i + 1)) := by
      rw [Finset.sum_range_succ']
      simp [add_comm, add_left_comm, add_assoc]
    have hg1 : g 1 = 1 := by simp [g]
    have hint : ∫ x in (1:ℝ)..(1 + m), g x ≤ 1 / σ := by
      exact integral_rpow_neg_le_inv hσ (by norm_num)
        (by exact le_add_of_nonneg_right (by positivity : (0:ℝ) ≤ m))
    calc
      Finset.sum (Finset.range (m + 1)) (fun k => ((k + 1 : ℝ) ^ (-σ - 1)))
          = g 1 + Finset.sum (Finset.range m) (fun i => g (1 + i + 1)) := hsplit
      _ ≤ 1 + ∫ x in (1:ℝ)..(1 + m), g x := by
            rw [hg1]
            simpa [add_comm, add_left_comm, add_assoc] using add_le_add_left hcomp 1
      _ ≤ 1 + 1 / σ := by linarith



/-- Uniform correction bound, independent of `n`. -/
theorem norm_sum_correction_le_uniform {s : ℂ} (hs : 0 < s.re) (n : ℕ) :
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
        (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))‖
      ≤ ‖s‖ * (1 / 2) * (1 + 1 / s.re) := by
  calc
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
        (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))‖
        ≤ ‖s‖ * (1 / 2) *
            Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1))) :=
          norm_sum_correction_le (by linarith : -1 ≤ s.re) n
    _ ≤ ‖s‖ * (1 / 2) * (1 + 1 / s.re) := by
          apply mul_le_mul_of_nonneg_left
          · exact sum_shifted_rpow_le_inv hs n
          · positivity

/-- Uniform finite value enclosure, independent of `n`. -/
theorem finite_sum_enclosure_uniform {s : ℂ} (hs : 0 < s.re) (n : ℕ) :
    ‖(Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) -
      ((∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2))‖
      ≤ ‖s‖ * (1 / 2) * (1 + 1 / s.re) := by
  have h44 := sum_shifted_cpow_euler_maclaurin s n
  have hcorr := norm_sum_correction_le_uniform hs n
  have harg : (Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) -
      ((∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2)) =
      Finset.sum (Finset.range n) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
          (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1)))) := by
    rw [h44]
    ring
  rw [harg]
  exact hcorr



/-- Bound on the second Bernoulli polynomial. -/
theorem abs_BR_two_le {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    |(BR 2).eval x| ≤ 1 / 6 := by
  have hpoly : (BR 2).eval x = x ^ 2 - x + 1 / 6 := by
    norm_num [BR, Polynomial.bernoulli, Finset.sum_range_succ]
    ring
  rw [hpoly, abs_le]
  constructor <;> nlinarith



/-- Second-order finite Euler–Maclaurin formula. -/
theorem sum_second_order (s : ℂ) (n : ℕ) :
    (Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) =
      (∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2) := by
  have h44 := sum_shifted_cpow_euler_maclaurin s n
  have h61 := sum_correction_second_order s n
  have hcorr : (Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) *
        (-s * (((x + 1 : ℝ) : ℂ) ^ (-s - 1))))) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
    convert h61 using 1
    apply Finset.sum_congr rfl
    intro k hk
    apply intervalIntegral.integral_congr
    intro x hx
    simp [emG]
    ring
  rw [h44]
  rw [hcorr]
  ring



/-- Norm of the second `emG` derivative. -/
theorem norm_emG_two (s : ℂ) {x : ℝ} (hx : 0 ≤ x) :
    ‖emG s 2 x‖ = ‖s‖ * ‖s + 1‖ * ((x + 1 : ℝ) ^ (-s.re - 2)) := by
  have hval : emG s 2 x = s * (s + 1) * (((x + 1 : ℝ) : ℂ) ^ (-(s + 2))) := by
    simp [emG, descPochhammer]
    ring
  rw [hval, norm_mul, norm_mul]
  have hpow : ‖(((x + 1 : ℝ) : ℂ) ^ (-(s + 2)))‖ = (x + 1) ^ (-s.re - 2) := by
    have h := norm_Complex.cpow_neg_ofReal (s := s + 2) (x := x + 1) (by linarith)
    simpa [Complex.add_re, add_comm, add_left_comm, add_assoc, sub_eq_add_neg] using h
  rw [hpow]



/-- Pointwise bound for the second-order `B₂` integrand. -/
theorem norm_B2_correction_integrand_le {s : ℂ} {k : ℕ} {x : ℝ}
    (hs : -1 < s.re) (hx0 : (k:ℝ) ≤ x) (hx1 : x ≤ (k:ℝ) + 1) :
    ‖emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)‖
      ≤ ‖s‖ * ‖s + 1‖ * (1 / 6) * ((k + 1 : ℝ) ^ (-s.re - 2)) := by
  have hxpos : (0:ℝ) < x + 1 := by linarith
  have hnorm : ‖emG s 2 x‖ = ‖s‖ * ‖s + 1‖ * ((x + 1 : ℝ) ^ (-s.re - 2)) :=
    norm_emG_two s (by linarith)
  have hB : ‖(((BR 2).eval (x - k) : ℝ) : ℂ)‖ ≤ 1 / 6 := by
    rw [Complex.norm_real, Real.norm_eq_abs]
    exact abs_BR_two_le (by linarith) (by linarith)
  have hexp : -s.re - 2 ≤ 0 := by linarith
  have hk1 : (k:ℝ) + 1 ≤ x + 1 := by linarith
  have hpowle : (x + 1) ^ (-s.re - 2) ≤ ((k:ℝ) + 1) ^ (-s.re - 2) := by
    have h := Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < (k:ℝ)+1) hk1 hexp
    simpa [add_comm] using h
  calc
    ‖emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)‖
        = ‖emG s 2 x‖ * ‖(((BR 2).eval (x - k) : ℝ) : ℂ)‖ := norm_mul _ _
    _ ≤ (‖s‖ * ‖s + 1‖ * ((k + 1 : ℝ) ^ (-s.re - 2))) * (1 / 6) := by
          apply mul_le_mul
          · rw [hnorm]
            apply mul_le_mul_of_nonneg_left hpowle
            positivity
          · exact hB
          · positivity
          · positivity
    _ = ‖s‖ * ‖s + 1‖ * (1 / 6) * ((k + 1 : ℝ) ^ (-s.re - 2)) := by ring



/-- Integral bound for one `B₂` correction term. -/
theorem norm_integral_B2_correction_le {s : ℂ} {k : ℕ} (hs : -1 < s.re) :
    ‖∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)‖
      ≤ ‖s‖ * ‖s + 1‖ * (1 / 6) * ((k + 1 : ℝ) ^ (-s.re - 2)) := by
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (k:ℝ)) (b := (k:ℝ) + 1)
    (C := ‖s‖ * ‖s + 1‖ * (1 / 6) * ((k + 1 : ℝ) ^ (-s.re - 2)))
    (f := fun x : ℝ => emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))
    (by
      intro x hx
      have hmin : min (k:ℝ) ((k:ℝ)+1) = (k:ℝ) := min_eq_left (by linarith)
      have hmax : max (k:ℝ) ((k:ℝ)+1) = (k:ℝ)+1 := max_eq_right (by linarith)
      have hx0 : (k:ℝ) < x := by
        have h := hx.1; rw [hmin] at h; exact h
      have hx1 : x ≤ (k:ℝ)+1 := by
        have h := hx.2; rw [hmax] at h; exact h
      exact norm_B2_correction_integrand_le hs (le_of_lt hx0) hx1)
  simpa using h



/-- Summed `B₂` correction bound. -/
theorem norm_sum_B2_correction_le {s : ℂ} {n : ℕ} (hs : -1 < s.re) :
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))‖
      ≤ ‖s‖ * ‖s + 1‖ * (1 / 6) *
        Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 2))) := by
  calc
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))‖
        ≤ Finset.sum (Finset.range n) (fun k =>
            ‖∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)‖) :=
          norm_sum_le _ _
    _ ≤ Finset.sum (Finset.range n) (fun k =>
          ‖s‖ * ‖s + 1‖ * (1 / 6) * ((k + 1 : ℝ) ^ (-s.re - 2))) := by
          apply Finset.sum_le_sum
          intro k hk
          exact norm_integral_B2_correction_le hs
    _ = ‖s‖ * ‖s + 1‖ * (1 / 6) *
          Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 2))) := by
          rw [Finset.mul_sum]



/-- Sharp bound for the `B₂` correction weights. -/
theorem sum_B2_weights_le {s : ℂ} (hs : -1 < s.re) (n : ℕ) :
    Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 2))) ≤
      1 + 1 / (s.re + 1) := by
  have h := sum_shifted_rpow_le_inv (σ := s.re + 1) (by linarith) n
  simpa [show s.re + 1 + 1 = s.re + 2 by ring,
    show (-s.re + -1 - 1 : ℝ) = -s.re - 2 by ring,
    add_comm, add_left_comm, add_assoc] using h



/-- Second-order finite value enclosure. -/
theorem finite_sum_enclosure_second_order {s : ℂ} (hs : -1 < s.re) (n : ℕ) :
    ‖(Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) -
      ((∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2))‖
      ≤ (1 / 12) * ‖s‖ * ‖s + 1‖ * (1 + 1 / (s.re + 1)) := by
  have h62 := sum_second_order s n
  have h66 := norm_sum_B2_correction_le (s := s) (n := n) hs
  have h67 := sum_B2_weights_le hs n
  have harg : (Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s)))) -
      ((∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
        (((((n + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2)) =
      -(1 / 2) * Finset.sum (Finset.range n) (fun k =>
        ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
    rw [h62]
    ring
  rw [harg, norm_mul, norm_neg]
  have hhalf : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
  rw [hhalf]
  calc
    (1 / 2) * ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))‖
        ≤ (1 / 2) * (‖s‖ * ‖s + 1‖ * (1 / 6) *
            Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 2)))) := by
          apply mul_le_mul_of_nonneg_left h66
          norm_num
    _ ≤ (1 / 2) * (‖s‖ * ‖s + 1‖ * (1 / 6) * (1 + 1 / (s.re + 1))) := by
          apply mul_le_mul_of_nonneg_left
          · apply mul_le_mul_of_nonneg_left h67
            positivity
          · norm_num
    _ = (1 / 12) * ‖s‖ * ‖s + 1‖ * (1 + 1 / (s.re + 1)) := by ring



/-- Exact integral of the shifted complex power. -/
theorem integral_cpow_shift (s : ℂ) (hs : s ≠ 1) (n : ℕ) :
    ∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s)) =
      ((((n + 1 : ℝ) : ℂ) ^ (1 - s)) - 1) / (1 - s) := by
  have hn : (0:ℝ) ≤ n := by positivity
  have h0 : (0:ℝ) ∉ Set.uIcc (1:ℝ) ((n:ℝ) + 1) := by
    rw [Set.uIcc_of_le (by linarith : (1:ℝ) ≤ (n:ℝ) + 1)]
    intro h
    linarith [h.1]
  have hne : (-s : ℂ) ≠ -1 := by
    intro h
    apply hs
    have : s = 1 := by linear_combination -h
    exact this
  have h := integral_cpow (a := (1:ℝ)) (b := ((n:ℝ)+1)) (r := -s)
    (Or.inr ⟨hne, h0⟩)
  have htrans : ∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s)) =
      ∫ y in (1:ℝ)..((n:ℝ)+1), ((y : ℂ) ^ (-s)) := by
    have hc := intervalIntegral.integral_comp_add_right
      (f := fun y : ℝ => ((y : ℂ) ^ (-s))) (a := (0:ℝ)) (b := (n:ℝ)) (d := (1:ℝ))
    simpa [zero_add] using hc
  rw [htrans, h]
  norm_num
  ring



/-- The shifted weight tends to zero for `σ > 1`. -/
theorem tendsto_shifted_rpow_zero {σ : ℝ} (hσ : 1 < σ) :
    Tendsto (fun n : ℕ => ((n:ℝ) + 1) ^ (1 - σ)) atTop (𝓝 0) := by
  have hpos : 0 < σ - 1 := by linarith
  have hbase : Tendsto (fun n : ℕ => ((n:ℝ) + 1)) atTop atTop :=
    tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop
  have hrpow : Tendsto (fun n : ℕ => ((n:ℝ) + 1) ^ (σ - 1)) atTop atTop :=
    (tendsto_rpow_atTop hpos).comp hbase
  have hinv : Tendsto (fun n : ℕ => (((n:ℝ) + 1) ^ (σ - 1))⁻¹) atTop (𝓝 0) :=
    hrpow.inv_tendsto_atTop
  convert hinv using 1
  ext n
  rw [show (1:ℝ) - σ = -(σ - 1) by ring, Real.rpow_neg (by positivity)]



/-- Summability of the shifted `B₂` weights. -/
theorem summable_shifted_rpow {σ : ℝ} (hσ : -1 < σ) :
    Summable (fun n : ℕ => ((n:ℝ) + 1) ^ (-σ - 2)) := by
  have hp : -σ - 2 < -1 := by linarith
  have h := (Real.summable_nat_rpow (p := -σ - 2)).2 hp
  have hshift := (summable_nat_add_iff (f := fun n : ℕ => (n:ℝ) ^ (-σ - 2)) 1).2 h
  simpa [Nat.cast_add, Nat.cast_one] using hshift



/-- Summability of the `B₂` correction series. -/
theorem summable_B2_correction {s : ℂ} (hs : -1 < s.re) :
    Summable (fun k : ℕ =>
      ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have hw : Summable (fun k : ℕ => ((k:ℝ) + 1) ^ (-s.re - 2)) := summable_shifted_rpow hs
  have hmaj : Summable (fun k : ℕ =>
      (‖s‖ * ‖s + 1‖ * (1 / 6)) * ((k:ℝ) + 1) ^ (-s.re - 2)) :=
    hw.mul_left _
  refine hmaj.of_norm_bounded ?_
  intro k
  exact norm_integral_B2_correction_le hs



/-- The `B₂` correction partial sums converge. -/
theorem tendsto_sum_B2_correction {s : ℂ} (hs : -1 < s.re) :
    Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 (∑' k : ℕ,
        ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) :=
  (summable_B2_correction hs).hasSum.tendsto_sum_nat



/-- The complex tail `(n+1)^{1-s}` tends to zero for `Re s > 1`. -/
theorem tendsto_cpow_shift_zero {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun n : ℕ => ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s))) atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hnorm : ∀ n : ℕ, ‖((((n:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s))‖ =
      ((n:ℝ) + 1) ^ (1 - s.re) := by
    intro n
    have hx : (0:ℝ) < (n:ℝ) + 1 := by positivity
    have h := norm_Complex.cpow_neg_ofReal (s := s - 1) (x := (n:ℝ) + 1) hx
    simpa [sub_eq_add_neg, Complex.sub_re, add_comm, add_left_comm, add_assoc] using h
  convert tendsto_shifted_rpow_zero hs using 1
  ext n
  exact hnorm n



/-- Limit of the shifted-power integral. -/
theorem tendsto_integral_cpow_shift {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun n : ℕ => ∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s)))
      atTop (𝓝 (1 / (s - 1))) := by
  have hs1 : s ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have h : Tendsto (fun n : ℕ =>
      (((((n:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) - 1) / (1 - s)) atTop
      (𝓝 (((0:ℂ) - 1) / (1 - s))) :=
    ((tendsto_cpow_shift_zero hs).sub_const 1).div_const (1 - s)
  have hlim : (((0:ℂ) - 1) / (1 - s)) = 1 / (s - 1) := by
    field_simp
    ring
  rw [hlim] at h
  convert h using 1
  ext n
  exact integral_cpow_shift s hs1 n



/-- The inverse square weight tends to zero. -/
theorem tendsto_shifted_rpow_neg_two :
    Tendsto (fun n : ℕ => ((n:ℝ) + 1) ^ (-2:ℝ)) atTop (𝓝 0) := by
  convert tendsto_shifted_rpow_zero (σ := 3) (by norm_num) using 1
  ext n
  rw [show (1:ℝ) - 3 = (-2:ℝ) by norm_num]





/-- Norm of the first `emG` derivative. -/
theorem norm_emG_one (s : ℂ) {x : ℝ} (hx : 0 ≤ x) :
    ‖emG s 1 x‖ = ‖s‖ * ((x + 1 : ℝ) ^ (-s.re - 1)) := by
  have hval : emG s 1 x = -s * ((((x + 1 : ℝ) : ℂ) ^ (-(s + 1)))) := by
    simp [emG, descPochhammer]
  rw [hval, norm_mul, norm_neg]
  have hpow : ‖((((x + 1 : ℝ) : ℂ) ^ (-(s + 1))))‖ =
      (x + 1) ^ (-s.re - 1) := by
    have h := norm_Complex.cpow_neg_ofReal (s := s + 1) (x := x + 1) (by linarith)
    simpa [Complex.add_re, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h
  rw [hpow]



/-- The first `emG` derivative tends to zero for `Re s > 1`. -/
theorem tendsto_emG_one_zero {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun n : ℕ => emG s 1 n) atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hle : ∀ n : ℕ, ‖emG s 1 n‖ ≤ ‖s‖ * ((n:ℝ) + 1) ^ (-2:ℝ) := by
    intro n
    rw [norm_emG_one s (by exact_mod_cast Nat.zero_le n)]
    have hx : (1:ℝ) ≤ (n:ℝ) + 1 := by
      have hn : (0:ℝ) ≤ n := by exact_mod_cast Nat.zero_le n
      linarith
    have hexp : -s.re - 1 ≤ (-2:ℝ) := by linarith
    have h := Real.rpow_le_rpow_of_exponent_le hx hexp
    exact mul_le_mul_of_nonneg_left h (norm_nonneg _)
  have hg : Tendsto (fun n : ℕ => ‖s‖ * ((n:ℝ) + 1) ^ (-2:ℝ)) atTop (𝓝 0) := by
    simpa using tendsto_const_nhds.mul tendsto_shifted_rpow_neg_two
  exact squeeze_zero (fun n => norm_nonneg _) hle hg



/-- The complex weight `(n+1)^{-s}` tends to zero for `Re s > 1`. -/
theorem tendsto_cpow_neg_zero {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun n : ℕ => ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s))) atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hnorm : ∀ n : ℕ, ‖((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s))‖ =
      ((n:ℝ) + 1) ^ (-s.re) := by
    intro n
    exact norm_Complex.cpow_neg_ofReal (by positivity)
  convert tendsto_shifted_rpow_zero (σ := s.re + 1) (by linarith) using 1
  ext n
  rw [hnorm n]
  congr 1
  ring



/-- Limit of the second-order finite expression for `Re s > 1`. -/
theorem tendsto_sum_shifted_cpow {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k => (((k + 1 : ℝ) : ℂ) ^ (-s))))
      atTop (𝓝 (1 / (s - 1) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emG s 1 0) -
        (1 / 2) * (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        ((0 - 1) / 2))) := by
  have hI : Tendsto (fun n : ℕ => ∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s)))
      atTop (𝓝 (1 / (s - 1))) := tendsto_integral_cpow_shift hs
  have hF : Tendsto (fun n : ℕ => emG s 1 n) atTop (𝓝 0) := tendsto_emG_one_zero hs
  have hB : Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 (∑' k : ℕ,
        ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) :=
    tendsto_sum_B2_correction (by linarith : -1 < s.re)
  have hA : Tendsto (fun n : ℕ =>
      (((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2) atTop (𝓝 ((0 - 1) / 2)) :=
    ((tendsto_cpow_neg_zero hs).sub_const 1).div_const 2
  have hR : Tendsto (fun n : ℕ =>
      (∫ x in (0:ℝ)..n, (((x + 1 : ℝ) : ℂ) ^ (-s))) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        (((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s)) - 1) / 2) atTop
      (𝓝 (1 / (s - 1) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emG s 1 0) -
        (1 / 2) * (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        ((0 - 1) / 2))) := by
    have h1 : Tendsto (fun n : ℕ => emG s 1 n - emG s 1 0) atTop (𝓝 (0 - emG s 1 0)) :=
      hF.sub_const _
    have h2 : Tendsto (fun n : ℕ =>
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emG s 1 n - emG s 1 0)) atTop
        (𝓝 ((((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emG s 1 0))) :=
      h1.const_mul _
    have h3 : Tendsto (fun n : ℕ => (1 / 2) * Finset.sum (Finset.range n) (fun k =>
        ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) atTop
        (𝓝 ((1 / 2) * (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)))) :=
      hB.const_mul _
    exact ((hI.add h2).sub h3).sub hA
  refine hR.congr' ?_
  filter_upwards with n
  exact (sum_second_order s n).symm



/-- Second-order Euler–Maclaurin continuation of `ζ` on `Re s > 1`. -/
theorem zeta_eq_second_order {s : ℂ} (hs : 1 < s.re) :
    riemannZeta s =
      1 / (s - 1) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emG s 1 0) -
        (1 / 2) * (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), emG s 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        ((0 - 1) / 2) := by
  have hbase : Summable (fun n : ℕ => 1 / ((n : ℂ) ^ s)) :=
    (Complex.summable_one_div_nat_cpow).2 hs
  have hsum : Summable (fun n : ℕ => ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s))) := by
    have h := (summable_nat_add_iff (f := fun n : ℕ => 1 / ((n : ℂ) ^ s)) 1).2 hbase
    simpa [one_div, Complex.cpow_neg, Nat.cast_add, Nat.cast_one] using h
  have hpart : Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k =>
      (((k + 1 : ℝ) : ℂ) ^ (-s)))) atTop (𝓝 (∑' n : ℕ, ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s)))) :=
    hsum.hasSum.tendsto_sum_nat
  have huniq := tendsto_nhds_unique hpart (tendsto_sum_shifted_cpow hs)
  rw [zeta_eq_tsum_one_div_nat_add_one_cpow hs]
  rw [show (∑' n : ℕ, 1 / (((n : ℂ) + 1) ^ s)) =
      ∑' n : ℕ, ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s)) by
    congr 1
    funext n
    rw [one_div, Complex.cpow_neg]
    norm_num]
  exact huniq



/-- Shifted `emG` tower, for a tail starting at `N+1`. -/
def emGShift (s : ℂ) (N : ℕ) (j : ℕ) (x : ℝ) : ℂ :=
  (descPochhammer ℂ j).eval (-s) *
    ((((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + (j : ℂ)))))

theorem emGShift_succ (s : ℂ) (N j : ℕ) :
    (descPochhammer ℂ (j + 1)).eval (-s) =
      (descPochhammer ℂ j).eval (-s) * (-(s + (j : ℂ))) :=
  emG_succ s j

theorem hasDerivAt_emGShift (s : ℂ) (N j : ℕ) {x : ℝ} (hx : 0 ≤ x) :
    HasDerivAt (emGShift s N j) (emGShift s N (j + 1) x) x := by
  have hbase : (0:ℝ) < x + (N:ℝ) + 1 := by positivity
  have hmem : (((x + (N:ℝ) + 1 : ℝ) : ℂ)) ∈ Complex.slitPlane :=
    Complex.ofReal_mem_slitPlane.2 hbase
  have hc := (Complex.hasStrictDerivAt_cpow_const (c := -(s + (j : ℂ))) hmem).hasDerivAt
  have hh : HasDerivAt (fun y : ℝ => (((y + (N:ℝ) + 1 : ℝ) : ℂ))) 1 x := by
    have h0 : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 x := Complex.ofRealCLM.hasDerivAt
    have h := h0.const_add ((((N:ℝ) + 1 : ℝ) : ℂ))
    simpa [Complex.ofReal_add, add_comm, add_left_comm, add_assoc] using h
  have hcomp := HasDerivAt.scomp (x := x) hc hh
  have h := hcomp.const_mul ((descPochhammer ℂ j).eval (-s))
  convert h using 1
  · ext y
    simp [emGShift]
  · simp [emGShift, emG_succ]
    ring



/-- First-order Euler–Maclaurin for a shifted zeta tail. -/
theorem sum_tail_first_order (s : ℂ) (N : ℕ) :
    ∀ n : ℕ,
      (Finset.sum (Finset.range n) (fun k => emGShift s N 0 k)) =
        (∫ x in (0:ℝ)..n, emGShift s N 0 x) +
          (Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)) -
          (emGShift s N 0 n - emGShift s N 0 0) / 2 := by
  intro n
  exact sum_range_euler_maclaurin_complex_nonneg (emGShift s N 0) (emGShift s N 1)
    (fun x hx => hasDerivAt_emGShift s N 0 hx)
    (fun x hx => (hasDerivAt_emGShift s N 1 hx).continuousAt) n



/-- Norm of `x^{-s}` for positive real `x`. -/
theorem norm_cpow_neg_ofReal {s : ℂ} {x : ℝ} (hx : 0 < x) :
    ‖((x : ℂ) ^ (-s))‖ = x ^ (-s.re) := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hx]
  simp

/-- Norm of the shifted first derivative. -/
theorem norm_emGShift_one (s : ℂ) (N : ℕ) {x : ℝ} (hx : 0 ≤ x) :
    ‖emGShift s N 1 x‖ = ‖s‖ * ((x + (N:ℝ) + 1 : ℝ) ^ (-s.re - 1)) := by
  have hval : emGShift s N 1 x =
      -s * ((((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1)))) := by
    simp [emGShift, descPochhammer]
  rw [hval, norm_mul, norm_neg]
  have hpow : ‖((((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1))))‖ =
      (x + (N:ℝ) + 1) ^ (-s.re - 1) := by
    have h := norm_cpow_neg_ofReal (s := s + 1) (x := x + (N:ℝ) + 1) (by positivity)
    simpa [Complex.add_re, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h
  rw [hpow]

/-- Pointwise bound for the shifted correction integrand. -/
theorem norm_tail_correction_integrand_le {s : ℂ} {N k : ℕ} {x : ℝ}
    (hs : -1 < s.re) (hx0 : (k:ℝ) ≤ x) (hx1 : x ≤ (k:ℝ) + 1) :
    ‖(((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
      ≤ ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := by
  have hk0 : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hN0 : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
  have hxpos : (0:ℝ) < x + (N:ℝ) + 1 := by linarith
  have hnorm : ‖emGShift s N 1 x‖ = ‖s‖ * ((x + (N:ℝ) + 1 : ℝ) ^ (-s.re - 1)) :=
    norm_emGShift_one s N (by linarith)
  have habs : |x - k - 1 / 2| ≤ 1 / 2 := by
    rw [abs_le]
    constructor <;> linarith
  have hexp : -s.re - 1 ≤ 0 := by linarith
  have hk1 : (k:ℝ) + (N:ℝ) + 1 ≤ x + (N:ℝ) + 1 := by linarith
  have hpowle : (x + (N:ℝ) + 1) ^ (-s.re - 1) ≤ ((k:ℝ) + (N:ℝ) + 1) ^ (-s.re - 1) := by
    exact Real.rpow_le_rpow_of_nonpos (by positivity) hk1 hexp
  calc
    ‖(((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
        = |x - k - 1 / 2| * ‖emGShift s N 1 x‖ := by
          rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    _ ≤ (1 / 2) * (‖s‖ * ((k:ℝ) + (N:ℝ) + 1) ^ (-s.re - 1)) := by
          apply mul_le_mul habs
          · rw [hnorm]
            exact mul_le_mul_of_nonneg_left hpowle (norm_nonneg _)
          · positivity
          · norm_num
    _ = ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := by
          push_cast
          ring



/-- Integral bound for one shifted correction term. -/
theorem norm_integral_tail_correction_le {s : ℂ} {N k : ℕ} (hs : -1 < s.re) :
    ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
      ≤ ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := by
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (k:ℝ)) (b := ((k:ℝ) + 1))
    (C := ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)))
    (f := fun x : ℝ => (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
    (by
      intro x hx
      have hmin : min (k:ℝ) ((k:ℝ)+1) = (k:ℝ) := min_eq_left (by linarith)
      have hmax : max (k:ℝ) ((k:ℝ)+1) = (k:ℝ)+1 := max_eq_right (by linarith)
      have hx0 : (k:ℝ) < x := by
        have h := hx.1; rw [hmin] at h; exact h
      have hx1 : x ≤ (k:ℝ)+1 := by
        have h := hx.2; rw [hmax] at h; exact h
      exact norm_tail_correction_integrand_le hs (le_of_lt hx0) hx1)
  simpa using h

/-- Summed shifted correction bound. -/
theorem norm_sum_tail_correction_le {s : ℂ} {N n : ℕ} (hs : -1 < s.re) :
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)‖
      ≤ ‖s‖ * (1 / 2) *
        Finset.sum (Finset.range n) (fun k => (((k + N + 1 : ℝ)) ^ (-s.re - 1))) := by
  calc
    ‖Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)‖
        ≤ Finset.sum (Finset.range n) (fun k =>
            ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖) :=
          norm_sum_le _ _
    _ ≤ Finset.sum (Finset.range n) (fun k =>
          ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1))) := by
          apply Finset.sum_le_sum
          intro k hk
          exact norm_integral_tail_correction_le hs
    _ = ‖s‖ * (1 / 2) *
          Finset.sum (Finset.range n) (fun k => (((k + N + 1 : ℝ)) ^ (-s.re - 1))) := by
          rw [Finset.mul_sum]



/-- Sharp uniform bound for the shifted tail weights. -/
theorem sum_tail_weights_le {s : ℂ} (hs : 0 < s.re) (N n : ℕ) :
    Finset.sum (Finset.range n) (fun k => (((k + N + 1 : ℝ)) ^ (-s.re - 1))) ≤
      1 + 1 / s.re := by
  calc
    Finset.sum (Finset.range n) (fun k => (((k + N + 1 : ℝ)) ^ (-s.re - 1)))
        ≤ Finset.sum (Finset.range n) (fun k => ((k + 1 : ℝ) ^ (-s.re - 1))) := by
          apply Finset.sum_le_sum
          intro k hk
          have hexp : -s.re - 1 ≤ 0 := by linarith
          have hbase : (0:ℝ) < (k:ℝ) + 1 := by positivity
          have hle : (k:ℝ) + 1 ≤ (k:ℝ) + (N:ℝ) + 1 := by
            have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
            linarith
          exact Real.rpow_le_rpow_of_nonpos hbase hle hexp
    _ ≤ 1 + 1 / s.re := sum_shifted_rpow_le_inv hs n



/-- Tail integral of `x^{-s}` for `Re s > 1`. -/
theorem integral_Ioi_cpow_neg {s : ℂ} (hs : 1 < s.re) {c : ℝ} (hc : 0 < c) :
    (∫ t : ℝ in Set.Ioi c, ((t : ℂ) ^ (-s))) = (c : ℂ) ^ (1 - s) / (s - 1) := by
  have ha : (-s).re < -1 := by
    simpa using hs
  have h := integral_Ioi_cpow_of_lt (a := -s) ha hc
  rw [h]
  have h1 : -s + 1 = 1 - s := by ring
  have h2 : (1 - s : ℂ) ≠ 0 := by
    intro hzero
    have : s = 1 := by linear_combination -hzero
    have := congrArg Complex.re this
    simp at this
    linarith
  rw [h1]
  have hs1 : (s - 1 : ℂ) ≠ 0 := by
    intro hzero
    have : s = 1 := by linear_combination hzero
    have := congrArg Complex.re this
    simp at this
    linarith
  field_simp [hs1]
  ring



/-- Limit of the shifted tail integral for `Re s > 1`. -/
theorem tendsto_integral_tail_cpow {s : ℂ} (hs : 1 < s.re) (N : ℕ) :
    Tendsto (fun n : ℕ => ∫ x in (0:ℝ)..n, (((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-s)))
      atTop (𝓝 ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1))) := by
  have ha : (-s).re < -1 := by simpa using hs
  have hc : (0:ℝ) < (N:ℝ) + 1 := by positivity
  have hInt : IntegrableOn (fun y : ℝ => ((y : ℂ) ^ (-s))) (Set.Ioi ((N:ℝ) + 1)) :=
    integrableOn_Ioi_cpow_of_lt (a := -s) ha hc
  have hlim := intervalIntegral_tendsto_integral_Ioi ((N:ℝ) + 1) hInt tendsto_id
  have hnat : Tendsto (fun n : ℕ => (n:ℝ)) atTop atTop := tendsto_natCast_atTop_atTop
  have hshift : Tendsto (fun n : ℕ => (n:ℝ) + ((N:ℝ) + 1)) atTop atTop :=
    tendsto_atTop_add_const_right _ ((N:ℝ) + 1) hnat
  have hcomp := hlim.comp hshift
  have hrewrite : (fun n : ℕ => ∫ y in ((N:ℝ) + 1)..((n:ℝ) + ((N:ℝ) + 1)), ((y : ℂ) ^ (-s))) =
      (fun n : ℕ => ∫ x in (0:ℝ)..n, (((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-s))) := by
    funext n
    have h := intervalIntegral.integral_comp_add_right
      (f := fun y : ℝ => ((y : ℂ) ^ (-s))) (a := (0:ℝ)) (b := (n:ℝ)) (d := ((N:ℝ) + 1))
    simpa [add_comm, add_left_comm, add_assoc] using h.symm
  simp only [Function.comp_def] at hcomp
  have hcomp' : Tendsto (fun n : ℕ => ∫ x in (0:ℝ)..n, (((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-s)))
      atTop (𝓝 (∫ x in Set.Ioi ((N:ℝ) + 1), ((x : ℂ) ^ (-s)))) := by
    simpa [hrewrite] using hcomp
  rw [integral_Ioi_cpow_neg hs (c := (N:ℝ) + 1) hc] at hcomp'
  exact hcomp' 



/-- Summability of the shifted tail weights. -/
theorem summable_tail_rpow {σ : ℝ} (hσ : 0 < σ) (N : ℕ) :
    Summable (fun k : ℕ => (((k + N + 1 : ℝ)) ^ (-σ - 1))) := by
  have hp : -σ - 1 < -1 := by linarith
  have h := (Real.summable_nat_rpow (p := -σ - 1)).2 hp
  have hshift := (summable_nat_add_iff (f := fun n : ℕ => (n:ℝ) ^ (-σ - 1)) (N + 1)).2 h
  simpa [Nat.cast_add, Nat.cast_one, add_comm, add_left_comm, add_assoc] using hshift



/-- Summability of the shifted correction series. -/
theorem summable_tail_correction {s : ℂ} (hs : 0 < s.re) (N : ℕ) :
    Summable (fun k : ℕ =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) := by
  have hw : Summable (fun k : ℕ => (((k + N + 1 : ℝ)) ^ (-s.re - 1))) :=
    summable_tail_rpow hs N
  have hmaj : Summable (fun k : ℕ =>
      (‖s‖ * (1 / 2)) * (((k + N + 1 : ℝ)) ^ (-s.re - 1))) := hw.mul_left _
  refine hmaj.of_norm_bounded ?_
  intro k
  exact norm_integral_tail_correction_le (s := s) (N := N) (k := k)
    (by linarith : -1 < s.re)



/-- The shifted weight tends to zero for `Re s > 1`. -/
theorem tendsto_emGShift_zero {s : ℂ} (hs : 1 < s.re) (N : ℕ) :
    Tendsto (fun n : ℕ => emGShift s N 0 n) atTop (𝓝 0) := by
  have h := (tendsto_cpow_neg_zero hs).comp (tendsto_add_atTop_nat N)
  simpa [emGShift, descPochhammer, Function.comp_def, Nat.cast_add, Nat.cast_one,
    add_comm, add_left_comm, add_assoc] using h



/-- Convergence of the shifted correction partial sums. -/
theorem tendsto_sum_tail_correction {s : ℂ} (hs : 0 < s.re) (N : ℕ) :
    Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x))
      atTop (𝓝 (∑' k : ℕ,
        ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)) :=
  (summable_tail_correction hs N).hasSum.tendsto_sum_nat



/-- Limit of the shifted tail sum for `Re s > 1`. -/
theorem tendsto_sum_tail {s : ℂ} (hs : 1 < s.re) (N : ℕ) :
    Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k => emGShift s N 0 k))
      atTop (𝓝 (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1)) +
        (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) +
        emGShift s N 0 0 / 2)) := by
  have hI := tendsto_integral_tail_cpow hs N
  have hC := tendsto_sum_tail_correction (by linarith : 0 < s.re) N
  have hE := tendsto_emGShift_zero hs N
  have hR : Tendsto (fun n : ℕ =>
      (∫ x in (0:ℝ)..n, (((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-s))) +
        Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) -
        (emGShift s N 0 n - emGShift s N 0 0) / 2) atTop
      (𝓝 (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1)) +
        (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) +
        emGShift s N 0 0 / 2)) := by
    have h1 : Tendsto (fun n : ℕ => (emGShift s N 0 n - emGShift s N 0 0) / 2)
        atTop (𝓝 ((0 - emGShift s N 0 0) / 2)) :=
      (hE.sub_const _).div_const 2
    have h2 : Tendsto (fun n : ℕ =>
        (∫ x in (0:ℝ)..n, (((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-s))) +
          Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) -
          (emGShift s N 0 n - emGShift s N 0 0) / 2) atTop
        (𝓝 (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1)) +
          (∑' k : ℕ,
            ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) -
          ((0 - emGShift s N 0 0) / 2))) :=
      ((hI.add hC).sub h1)
    convert h2 using 1
    ring
  refine hR.congr' ?_
  filter_upwards with n
  rw [sum_tail_first_order s N n]
  simp [emGShift, descPochhammer]



/-- Fixed-`N` Euler–Maclaurin formula for `ζ` on `Re s > 1`. -/
theorem zeta_eq_fixed_N {s : ℂ} (hs : 1 < s.re) (N : ℕ) :
    riemannZeta s =
      (Finset.sum (Finset.range N) (fun n => (((n + 1 : ℝ) : ℂ) ^ (-s)))) +
        ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1)) +
        (∑' k : ℕ,
          ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) +
        emGShift s N 0 0 / 2 := by
  have hsum : Summable (fun n : ℕ => ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s))) := by
    have hbase : Summable (fun n : ℕ => 1 / ((n : ℂ) ^ s)) :=
      (Complex.summable_one_div_nat_cpow).2 hs
    have h := (summable_nat_add_iff (f := fun n : ℕ => 1 / ((n : ℂ) ^ s)) 1).2 hbase
    simpa [one_div, Complex.cpow_neg, Nat.cast_add, Nat.cast_one] using h
  have hsplit := hsum.sum_add_tsum_nat_add N
  have hζ := zeta_eq_tsum_one_div_nat_add_one_cpow hs
  have htail_summable : Summable (fun i : ℕ => (((((i + N : ℕ):ℝ) + 1 : ℝ) : ℂ) ^ (-s))) :=
    hsum.comp_injective (fun a b h => Nat.add_right_cancel h)
  have htail_partial : Tendsto (fun n : ℕ =>
      Finset.sum (Finset.range n) (fun k =>
        (((((k + N : ℕ):ℝ) + 1 : ℝ) : ℂ) ^ (-s)))) atTop
      (𝓝 (∑' i : ℕ, (((((i + N : ℕ):ℝ) + 1 : ℝ) : ℂ) ^ (-s)))) :=
    htail_summable.hasSum.tendsto_sum_nat
  have htail_eq : Tendsto (fun n : ℕ =>
      Finset.sum (Finset.range n) (fun k => emGShift s N 0 k)) atTop
      (𝓝 (∑' i : ℕ, (((((i + N : ℕ):ℝ) + 1 : ℝ) : ℂ) ^ (-s)))) := by
    convert htail_partial using 1
    · ext n
      apply Finset.sum_congr rfl
      intro k hk
      simp [emGShift, descPochhammer, Nat.cast_add, Nat.cast_one, add_comm, add_left_comm, add_assoc]
  have huniq := tendsto_nhds_unique htail_eq (tendsto_sum_tail hs N)
  rw [hζ]
  rw [show (∑' n : ℕ, 1 / (((n : ℂ) + 1) ^ s)) =
      ∑' n : ℕ, ((((n:ℝ) + 1 : ℝ) : ℂ) ^ (-s)) by
    congr 1
    funext n
    rw [one_div, Complex.cpow_neg]
    norm_num]
  rw [← hsplit]
  rw [huniq]
  ring



/-- The finite prefix is entire in `s`. -/
theorem differentiable_fixed_prefix (N : ℕ) :
    Differentiable ℂ (fun s : ℂ =>
      Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))) := by
  have h : Differentiable ℂ (∑ n ∈ Finset.range N,
      fun s : ℂ => ((((n + 1 : ℝ) : ℂ) ^ (-s)))) := by
    apply Differentiable.sum
    intro n hn
    have hc : ((((n + 1 : ℝ) : ℂ))) ≠ 0 := by
      exact Complex.ofReal_ne_zero.mpr (by positivity : ((n:ℝ) + 1) ≠ 0)
    exact (differentiable_id.neg).const_cpow (Or.inl hc)
  convert h using 1
  ext s
  simp



/-- `emGShift(s,N,1,x)` is entire in `s`. -/
theorem differentiable_emGShift_one (N : ℕ) {x : ℝ} (hx : 0 ≤ x) :
    Differentiable ℂ (fun s : ℂ => emGShift s N 1 x) := by
  have hbase : ((((x + (N:ℝ) + 1 : ℝ) : ℂ))) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr (by linarith [show (0:ℝ) ≤ N by exact_mod_cast Nat.zero_le N] : x + (N:ℝ) + 1 ≠ 0)
  have hexp : Differentiable ℂ (fun s : ℂ => -(s + 1)) := by
    fun_prop
  have hcpow : Differentiable ℂ (fun s : ℂ =>
      ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1)))) :=
    hexp.const_cpow (Or.inl hbase)
  have hval : (fun s : ℂ => emGShift s N 1 x) =
      (fun s : ℂ => -s * ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1)))) := by
    funext s
    simp [emGShift, descPochhammer]
  rw [hval]
  exact differentiable_id.neg.mul hcpow



/-- Derivative in `s` of the shifted integrand. -/
theorem hasDerivAt_emGShift_one (N : ℕ) {x : ℝ} (hx : 0 ≤ x) (s : ℂ) :
    HasDerivAt (fun z : ℂ => emGShift z N 1 x)
      (((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
        (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))))) s := by
  have hbase : ((((x + (N:ℝ) + 1 : ℝ) : ℂ))) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr (by linarith [show (0:ℝ) ≤ N by exact_mod_cast Nat.zero_le N] : x + (N:ℝ) + 1 ≠ 0)
  have hf : HasDerivAt (fun z : ℂ => -(z + 1)) (-1) s := by
    have h := ((hasDerivAt_id s).add_const 1).neg
    convert h using 1
    funext z; simp
  have hcpow : HasDerivAt (fun z : ℂ =>
      ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(z + 1))))
      (((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
        Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))) * (-1)) s :=
    hf.const_cpow (Or.inl hbase)
  have hval : (fun z : ℂ => emGShift z N 1 x) =
      (fun z : ℂ => -z * ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(z + 1)))) := by
    funext z
    simp [emGShift, descPochhammer]
  rw [hval]
  have h := (hasDerivAt_id s).neg.mul hcpow
  convert h using 1
  funext z
  simp only [Pi.mul_apply, Pi.neg_apply, id_eq, Pi.sub_apply, Pi.add_apply]
  have hid : (-id : ℂ → ℂ) s = -s := rfl
  rw [hid]
  ring



/-- Analyticity of the pole term away from `s = 1`. -/
theorem differentiableAt_pole_term (N : ℕ) {s : ℂ} (hs : s ≠ 1) :
    DifferentiableAt ℂ (fun z : ℂ =>
      (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - z)) / (z - 1))) s := by
  have hbase : ((((N:ℝ) + 1 : ℝ) : ℂ)) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr (by positivity)
  have hnum : DifferentiableAt ℂ (fun z : ℂ =>
      (((((N:ℝ) + 1 : ℝ) : ℂ)) ^ (1 - z))) s := by
    have hexp : DifferentiableAt ℂ (fun z : ℂ => 1 - z) s := by fun_prop
    exact hexp.const_cpow (Or.inl hbase)
  have hden : DifferentiableAt ℂ (fun z : ℂ => z - 1) s := by fun_prop
  have hne : s - 1 ≠ 0 := sub_ne_zero.mpr hs
  exact hnum.div hden hne



/-- Continuity in `x` of the shifted integrand. -/
theorem continuousOn_emGShift_one (N : ℕ) (s : ℂ) :
    ContinuousOn (fun x : ℝ => emGShift s N 1 x) (Set.Ici 0) := by
  intro x hx
  exact (hasDerivAt_emGShift s N 1 hx).continuousAt.continuousWithinAt



/-- Interval integrability in `x` of the shifted integrand. -/
theorem intervalIntegrable_emGShift_one (N k : ℕ) (s : ℂ) :
    IntervalIntegrable (fun x : ℝ => emGShift s N 1 x) MeasureTheory.volume
      (k:ℝ) ((k:ℝ) + 1) := by
  have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hcont : ContinuousOn (fun x : ℝ => emGShift s N 1 x) (Set.uIcc (k:ℝ) ((k:ℝ)+1)) :=
    (continuousOn_emGShift_one N s).mono (by
      intro x hx
      rcases (Set.mem_uIcc.mp hx) with ⟨hx0, hx1⟩ | ⟨hx0, hx1⟩
      · exact Set.mem_Ici.mpr (le_trans hk hx0)
      · exact Set.mem_Ici.mpr (by linarith))
  exact hcont.intervalIntegrable



/-- Measurability of the correction integrand in `x`. -/
theorem aestronglyMeasurable_correction_integrand (N k : ℕ) (s : ℂ) :
    AEStronglyMeasurable (fun x : ℝ =>
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
      (MeasureTheory.volume.restrict (Set.Ioc (k:ℝ) ((k:ℝ) + 1))) := by
  have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hcont : ContinuousOn (fun x : ℝ =>
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) (Set.Ioc (k:ℝ) ((k:ℝ) + 1)) := by
    apply ContinuousOn.mul
    · fun_prop
    · exact (continuousOn_emGShift_one N s).mono (by
        intro x hx
        exact Set.mem_Ici.mpr (le_trans hk (le_of_lt hx.1)))
  exact hcont.aestronglyMeasurable measurableSet_Ioc



/-- Continuity in `x` of the `s`-derivative integrand. -/
theorem continuousOn_sDeriv_emGShift (N k : ℕ) (s : ℂ) :
    ContinuousOn (fun x : ℝ =>
      ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
        (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ)))))
      (Set.Ioc (k:ℝ) ((k:ℝ) + 1)) := by
  intro x hx
  have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hx0 : (0:ℝ) < x + (N:ℝ) + 1 := by
    have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
    linarith [le_of_lt hx.1]
  have hmem : ((((x + (N:ℝ) + 1 : ℝ) : ℂ))) ∈ Complex.slitPlane :=
    Complex.ofReal_mem_slitPlane.2 hx0
  have hbase : ContinuousAt (fun y : ℝ => ((((y + (N:ℝ) + 1 : ℝ) : ℂ)))) x := by
    fun_prop
  have hcpow : ContinuousAt (fun y : ℝ =>
      ((((y + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1)))) x :=
    hbase.cpow continuousAt_const hmem
  have hlog : ContinuousAt (fun y : ℝ =>
      Complex.log ((((y + (N:ℝ) + 1 : ℝ) : ℂ)))) x :=
    hbase.clog hmem
  have hinner : ContinuousAt (fun y : ℝ =>
      -1 + s * Complex.log ((((y + (N:ℝ) + 1 : ℝ) : ℂ)))) x :=
    continuousAt_const.add (continuousAt_const.mul hlog)
  exact (hcpow.mul hinner).continuousWithinAt



/-- Measurability of the `s`-derivative integrand. -/
theorem aestronglyMeasurable_sDeriv_emGShift (N k : ℕ) (s : ℂ) :
    AEStronglyMeasurable (fun x : ℝ =>
      ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
        (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ)))))
      (MeasureTheory.volume.restrict (Set.Ioc (k:ℝ) ((k:ℝ) + 1))) :=
  (continuousOn_sDeriv_emGShift N k s).aestronglyMeasurable measurableSet_Ioc



/-- Integrability of the logarithmic majorant on one interval. -/
theorem intervalIntegrable_log_bound (N k : ℕ) :
    IntervalIntegrable (fun x : ℝ => 1 + |Real.log (x + (N:ℝ) + 1)|)
      MeasureTheory.volume (k:ℝ) ((k:ℝ) + 1) := by
  have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hlog : ContinuousOn (fun x : ℝ => Real.log (x + (N:ℝ) + 1))
      (Set.uIcc (k:ℝ) ((k:ℝ) + 1)) := by
    have harg : ContinuousOn (fun x : ℝ => x + (N:ℝ) + 1) (Set.uIcc (k:ℝ) ((k:ℝ) + 1)) := by
      fun_prop
    apply ContinuousOn.log
    · exact harg
    · intro x hx
      rcases (Set.mem_uIcc.mp hx) with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
        linarith
      · have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
        linarith
  exact (continuousOn_const.add hlog.abs).intervalIntegrable (μ := MeasureTheory.volume)



/-- Joint continuity of the `s`-derivative integrand. -/
theorem continuousOn_sDeriv_pair (N k : ℕ) (R : ℝ) :
    ContinuousOn (fun p : ℂ × ℝ =>
      ((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(p.1 + 1))) *
        (-1 + p.1 * Complex.log ((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ)))))
      (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))) := by
  have hB : ContinuousOn (fun p : ℂ × ℝ => ((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ))))
      (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))) := by
    fun_prop
  have hE : ContinuousOn (fun p : ℂ × ℝ => (-(p.1 + 1)))
      (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))) := by
    fun_prop
  have hmem : ∀ p ∈ (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))),
      ((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ))) ∈ Complex.slitPlane := by
    intro p hp
    have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
    have hx : (k:ℝ) ≤ p.2 := hp.2.1
    have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
    exact Complex.ofReal_mem_slitPlane.2 (by linarith)
  have hcpow := hB.cpow hE hmem
  have hlog := hB.clog hmem
  have hinner : ContinuousOn (fun p : ℂ × ℝ =>
      -1 + p.1 * Complex.log ((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ))))
      (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))) :=
    continuousOn_const.add ((continuousOn_fst).mul hlog)
  exact hcpow.mul hinner



set_option maxHeartbeats 800000 in
/-- Uniform bound for the `s`-derivative on `‖s‖ ≤ R` and `[k,k+1]`. -/
theorem exists_sDeriv_bound (N k : ℕ) (R : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (s : ℂ) (x : ℝ), ‖s‖ ≤ R →
      (k:ℝ) < x → x ≤ (k:ℝ) + 1 →
      ‖((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
        (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))))‖ ≤ C := by
  have hK : IsCompact (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))) :=
    (isCompact_closedBall (0:ℂ) R).prod isCompact_Icc
  have hcont : ContinuousOn (fun p : ℂ × ℝ =>
      ‖((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(p.1 + 1))) *
        (-1 + p.1 * Complex.log ((((p.2 + (N:ℝ) + 1 : ℝ) : ℂ))))‖)
      (Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1))) :=
    (continuousOn_sDeriv_pair N k R).norm
  obtain ⟨C, hC⟩ := hK.bddAbove_image hcont
  refine ⟨max C 0, le_max_right _ _, ?_⟩
  intro s x hs hx0 hx1
  have hs' : s ∈ Metric.closedBall (0:ℂ) R := by
    simpa [Metric.mem_closedBall, dist_eq_norm] using hs
  have hp : (s, x) ∈ Metric.closedBall (0:ℂ) R ×ˢ (Set.Icc (k:ℝ) ((k:ℝ) + 1)) :=
    ⟨hs', ⟨le_of_lt hx0, hx1⟩⟩
  have hle : ‖((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
        (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))))‖ ≤ C :=
    hC (Set.mem_image_of_mem _ hp)
  exact le_trans hle (le_max_left _ _)



/-- Interval integrability of the correction integrand. -/
theorem intervalIntegrable_correction (N k : ℕ) (s : ℂ) :
    IntervalIntegrable (fun x : ℝ =>
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) MeasureTheory.volume
      (k:ℝ) ((k:ℝ) + 1) := by
  have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hcont : ContinuousOn (fun x : ℝ =>
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
      (Set.Icc (k:ℝ) ((k:ℝ) + 1)) := by
    apply ContinuousOn.mul
    · fun_prop
    · exact (continuousOn_emGShift_one N s).mono (by
        intro x hx
        exact Set.mem_Ici.mpr (le_trans hk hx.1))
  have hcont' : ContinuousOn (fun x : ℝ =>
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
      (Set.uIcc (k:ℝ) ((k:ℝ) + 1)) := by
    rw [Set.uIcc_of_le (by linarith : (k:ℝ) ≤ (k:ℝ) + 1)]
    exact hcont
  exact hcont'.intervalIntegrable (μ := MeasureTheory.volume)



set_option maxHeartbeats 1200000 in
/-- Differentiability in `s` of one correction integral. -/
theorem differentiableAt_correction_integral (N k : ℕ) (s0 : ℂ) :
    DifferentiableAt ℂ (fun s : ℂ => ∫ x in (k:ℝ)..((k:ℝ) + 1),
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) s0 := by
  set μ := MeasureTheory.volume.restrict (Set.Ioc (k:ℝ) ((k:ℝ) + 1))
  set F : ℂ → ℝ → ℂ := fun s x => (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x
  set F' : ℂ → ℝ → ℂ := fun s x => (((x - k - 1 / 2 : ℝ) : ℂ)) *
    (((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
      (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ)))))
  obtain ⟨C, hC0, hC⟩ := exists_sDeriv_bound N k (‖s0‖ + 1)
  have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
  have hmeas : ∀ᶠ s : ℂ in 𝓝 s0, AEStronglyMeasurable (F s) μ :=
    Filter.Eventually.of_forall (fun s => aestronglyMeasurable_correction_integrand N k s)
  have hint : Integrable (F s0) μ := by
    simpa [F, μ, IntegrableOn] using (intervalIntegrable_correction N k s0).1
  have hmeas' : AEStronglyMeasurable (F' s0) μ := by
    have hcont_aff : Continuous (fun x : ℝ => (((x - k - 1 / 2 : ℝ) : ℂ))) := by
      fun_prop
    have hmul : AEStronglyMeasurable (fun x : ℝ =>
        (((x - k - 1 / 2 : ℝ) : ℂ)) *
          (((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s0 + 1))) *
            (-1 + s0 * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ)))))) μ :=
      hcont_aff.aestronglyMeasurable.mul (aestronglyMeasurable_sDeriv_emGShift N k s0)
    simpa [F'] using hmul
  have hbound : ∀ᵐ x ∂μ, ∀ s ∈ Metric.ball s0 1, ‖F' s x‖ ≤ C / 2 := by
    apply ae_restrict_of_forall_mem measurableSet_Ioc
    intro x hx s hs
    have hdist : dist s s0 < 1 := Metric.mem_ball.mp hs
    have hsR : ‖s‖ ≤ ‖s0‖ + 1 := by
      have h1 : ‖s‖ ≤ ‖s0‖ + ‖s - s0‖ := by
        simpa [add_comm] using norm_add_le s0 (s - s0)
      have h2 : ‖s - s0‖ = dist s s0 := by rw [dist_eq_norm]
      linarith
    have hD := hC s x hsR hx.1 hx.2
    have hc : ‖(((x - k - 1 / 2 : ℝ) : ℂ))‖ ≤ (1 / 2 : ℝ) := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_le]
      constructor <;> linarith [hx.1, hx.2]
    have : ‖F' s x‖ = ‖(((x - k - 1 / 2 : ℝ) : ℂ))‖ *
        ‖((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
          (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))))‖ := by
      simp [F', norm_mul]
    rw [this]
    calc ‖(((x - k - 1 / 2 : ℝ) : ℂ))‖ *
        ‖((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-(s + 1))) *
          (-1 + s * Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))))‖
        ≤ (1 / 2) * C := mul_le_mul hc hD (norm_nonneg _) (by norm_num)
      _ = C / 2 := by ring
  have hbound_int : Integrable (fun _ : ℝ => C / 2) μ := by
    simpa [μ] using (intervalIntegrable_const (c := C / 2) (μ := MeasureTheory.volume)
      (a := (k:ℝ)) (b := (k:ℝ)+1)).1
  have hdiff : ∀ᵐ x ∂μ, ∀ s ∈ Metric.ball s0 1, HasDerivAt (fun z : ℂ => F z x) (F' s x) s := by
    apply ae_restrict_of_forall_mem measurableSet_Ioc
    intro x hx s hs
    have hx0 : (0:ℝ) ≤ x := le_trans hk (le_of_lt hx.1)
    have h := (hasDerivAt_emGShift_one N hx0 s).const_mul
      ((((x - k - 1 / 2 : ℝ) : ℂ)))
    simpa [F, F'] using h
  obtain ⟨hF'_int, hderiv⟩ := hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (F := F) (F' := F') (x₀ := s0) (s := Metric.ball s0 1) (μ := μ)
    (Metric.ball_mem_nhds s0 zero_lt_one) hmeas hint hmeas' hbound hbound_int hdiff
  have hEq : (fun s : ℂ => ∫ x in (k:ℝ)..((k:ℝ) + 1),
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) =
      (fun s : ℂ => ∫ x, F s x ∂μ) := by
    funext s
    rw [intervalIntegral.integral_of_le (by linarith : (k:ℝ) ≤ (k:ℝ) + 1)]
  rw [hEq]
  exact hderiv.differentiableAt



/-- Uniform bound for one correction integral on a strip `Re s ≥ ρ`, `‖s‖ ≤ R`. -/
theorem norm_correction_le_on (N k : ℕ) {ρ R : ℝ} (hρ : 0 < ρ) {s : ℂ}
    (hR : ‖s‖ ≤ R) (hre : ρ ≤ s.re) :
    ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
      ≤ (R / 2) * (((k + N + 1 : ℝ)) ^ (-ρ - 1)) := by
  have hs : -1 < s.re := by linarith
  have hR0 : (0:ℝ) ≤ R := le_trans (norm_nonneg s) hR
  have hbase : (1:ℝ) ≤ (k:ℝ) + (N:ℝ) + 1 := by
    have hk : (0:ℝ) ≤ k := by exact_mod_cast Nat.zero_le k
    have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
    linarith
  have hexp : -s.re - 1 ≤ -ρ - 1 := by linarith
  have hpow : (((k + N + 1 : ℝ)) ^ (-s.re - 1)) ≤ (((k + N + 1 : ℝ)) ^ (-ρ - 1)) :=
    Real.rpow_le_rpow_of_exponent_le hbase hexp
  have h1 := norm_integral_tail_correction_le (s := s) (N := N) (k := k) hs
  have h2 : ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) ≤
      R * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-ρ - 1)) := by
    apply mul_le_mul
    · exact mul_le_mul_of_nonneg_right hR (by norm_num)
    · exact hpow
    · exact Real.rpow_nonneg (le_trans zero_le_one hbase) _
    · exact mul_nonneg hR0 (by norm_num)
  calc
    ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
        ≤ ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := h1
    _ ≤ R * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-ρ - 1)) := h2
    _ = (R / 2) * (((k + N + 1 : ℝ)) ^ (-ρ - 1)) := by ring



set_option maxHeartbeats 800000 in
/-- Differentiability of the correction series on a local strip. -/
theorem differentiableOn_tsum_correction (N : ℕ) (s0 : ℂ) (hs0 : 0 < s0.re) :
    DifferentiableOn ℂ (fun s : ℂ => ∑' k : ℕ,
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
      (Metric.ball s0 1 ∩ {s : ℂ | s0.re / 2 < s.re}) := by
  set ρ := s0.re / 2 with hρdef
  have hρ : 0 < ρ := by positivity
  set R := ‖s0‖ + 1 with hRdef
  have hu : Summable (fun k : ℕ => (R / 2) * (((k + N + 1 : ℝ)) ^ (-ρ - 1))) :=
    (summable_tail_rpow hρ N).mul_left _
  have hU : IsOpen (Metric.ball s0 1 ∩ {s : ℂ | ρ < s.re}) :=
    Metric.isOpen_ball.inter (isOpen_lt continuous_const Complex.continuous_re)
  apply Complex.differentiableOn_tsum_of_summable_norm (u := fun k : ℕ =>
    (R / 2) * (((k + N + 1 : ℝ)) ^ (-ρ - 1))) hu
  · intro k s hs
    exact (differentiableAt_correction_integral N k s).differentiableWithinAt
  · exact hU
  · intro k s hs
    have hR : ‖s‖ ≤ R := by
      have hd : dist s s0 < 1 := Metric.mem_ball.mp hs.1
      have h1 : ‖s‖ ≤ ‖s0‖ + ‖s - s0‖ := by
        simpa [add_comm] using norm_add_le s0 (s - s0)
      have h2 : ‖s - s0‖ = dist s s0 := by rw [dist_eq_norm]
      linarith
    exact norm_correction_le_on N k hρ hR (le_of_lt hs.2)



/-- Global differentiability of the correction series on `Re s > 0`. -/
theorem differentiableOn_correction (N : ℕ) :
    DifferentiableOn ℂ (fun s : ℂ => ∑' k : ℕ,
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
      {s : ℂ | 0 < s.re} := by
  apply differentiableOn_of_locally_differentiableOn
  intro s0 hs0
  refine ⟨Metric.ball s0 1 ∩ {s : ℂ | s0.re / 2 < s.re}, ?_, ?_, ?_⟩
  · exact Metric.isOpen_ball.inter (isOpen_lt continuous_const Complex.continuous_re)
  · refine ⟨Metric.mem_ball_self zero_lt_one, ?_⟩
    show s0.re / 2 < s0.re
    have hs0' : (0:ℝ) < s0.re := hs0
    linarith
  · exact (differentiableOn_tsum_correction N s0 hs0).mono Set.inter_subset_right





/-- `emGShift(s,N,0,x)` is entire in `s` for `x ≥ 0`. -/
theorem differentiable_emGShift_zero (N : ℕ) {x : ℝ} (hx : 0 ≤ x) :
    Differentiable ℂ (fun s : ℂ => emGShift s N 0 x) := by
  have hbase : ((((x + (N:ℝ) + 1 : ℝ) : ℂ))) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr (by linarith [show (0:ℝ) ≤ N by exact_mod_cast Nat.zero_le N] : x + (N:ℝ) + 1 ≠ 0)
  have hexp : Differentiable ℂ (fun s : ℂ => -s) := differentiable_id.neg
  have hcpow : Differentiable ℂ (fun s : ℂ =>
      ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-s))) :=
    hexp.const_cpow (Or.inl hbase)
  have hval : (fun s : ℂ => emGShift s N 0 x) =
      (fun s : ℂ => ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-s))) := by
    funext s
    simp [emGShift, descPochhammer]
  rw [hval]
  exact hcpow



/-- The fixed-`N` Euler–Maclaurin expression for `ζ`. -/
noncomputable def zetaEM (N : ℕ) (s : ℂ) : ℂ :=
  (Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))) +
    (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) / (s - 1)) +
    (∑' k : ℕ,
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) +
    emGShift s N 0 0 / 2

/-- Analyticity of the fixed-`N` expression on the punctured half-plane. -/
theorem differentiableOn_zetaEM (N : ℕ) :
    DifferentiableOn ℂ (zetaEM N) {s : ℂ | 0 < s.re ∧ s ≠ 1} := by
  have h1 : DifferentiableOn ℂ (fun s : ℂ =>
      Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))))
      {s : ℂ | 0 < s.re ∧ s ≠ 1} :=
    (differentiable_fixed_prefix N).differentiableOn
  have h2 : DifferentiableOn ℂ (fun s : ℂ =>
      (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) / (s - 1)))
      {s : ℂ | 0 < s.re ∧ s ≠ 1} := by
    intro s hs
    exact (differentiableAt_pole_term N hs.2).differentiableWithinAt
  have h3 : DifferentiableOn ℂ (fun s : ℂ => ∑' k : ℕ,
      ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x)
      {s : ℂ | 0 < s.re ∧ s ≠ 1} :=
    (differentiableOn_correction N).mono (by intro s hs; exact hs.1)
  have h4 : DifferentiableOn ℂ (fun s : ℂ => emGShift s N 0 0 / 2)
      {s : ℂ | 0 < s.re ∧ s ≠ 1} :=
    ((differentiable_emGShift_zero N (le_refl 0)).div_const 2).differentiableOn
  exact ((h1.add h2).add h3).add h4





/-- `zetaEM` agrees with `ζ` on `Re s > 1`. -/
theorem zeta_eq_zetaEM_of_one_lt {s : ℂ} (hs : 1 < s.re) (N : ℕ) :
    riemannZeta s = zetaEM N s := by
  rw [zetaEM, zeta_eq_fixed_N hs N]



set_option maxHeartbeats 800000 in
/-- Continuation of the fixed-`N` formula to a horizontal strip in the critical strip. -/
theorem zeta_eq_zetaEM_of_im (N : ℕ) {s : ℂ}
    (hre : 0 < s.re) (him1 : 1 < s.im) (him2 : s.im < 20) :
    riemannZeta s = zetaEM N s := by
  set V : Set ℂ := {z : ℂ | 0 < z.re} ∩ {z : ℂ | 1 < z.im} ∩ {z : ℂ | z.im < 20} with hVdef
  have hmem : ∀ z : ℂ, z ∈ V ↔ 0 < z.re ∧ 1 < z.im ∧ z.im < 20 := by
    intro z
    simp [hVdef, and_assoc]
  have hVopen : IsOpen V := by
    rw [hVdef]
    exact ((isOpen_lt continuous_const Complex.continuous_re).inter
      (isOpen_lt continuous_const Complex.continuous_im)).inter
      (isOpen_lt Complex.continuous_im continuous_const)
  have hVconv : Convex ℝ V := by
    rw [hVdef]
    exact ((convex_halfSpace_re_gt 0).inter (convex_halfSpace_im_gt 1)).inter
      (convex_halfSpace_im_lt 20)
  have hVpre : IsPreconnected V := hVconv.isPreconnected
  have hζdiff : DifferentiableOn ℂ riemannZeta V := by
    intro z hz
    have hz1 : z ≠ 1 := by
      intro h
      subst h
      have := (hmem 1).1 hz
      norm_num at this
    exact (differentiableAt_riemannZeta hz1).differentiableWithinAt
  have hzdiff : DifferentiableOn ℂ (zetaEM N) V := by
    apply (differentiableOn_zetaEM N).mono
    intro z hz
    obtain ⟨hre, him1, him2⟩ := (hmem z).1 hz
    exact ⟨hre, by intro h1; subst h1; norm_num at him1⟩
  have hζan : AnalyticOnNhd ℂ riemannZeta V := hζdiff.analyticOnNhd hVopen
  have hzan : AnalyticOnNhd ℂ (zetaEM N) V := hzdiff.analyticOnNhd hVopen
  have hz0 : (2 + 14 * Complex.I : ℂ) ∈ V := by
    rw [hmem]
    norm_num
  have hevent : riemannZeta =ᶠ[𝓝 (2 + 14 * Complex.I : ℂ)] zetaEM N := by
    filter_upwards [Metric.ball_mem_nhds (2 + 14 * Complex.I : ℂ) zero_lt_one] with z hz
    apply zeta_eq_zetaEM_of_one_lt
    have hd : ‖z - (2 + 14 * Complex.I : ℂ)‖ < 1 := by
      simpa [dist_eq_norm] using Metric.mem_ball.mp hz
    have hrec : |z.re - 2| < 1 := by
      calc |z.re - 2| = |(z - (2 + 14 * Complex.I : ℂ)).re| := by simp
        _ ≤ ‖z - (2 + 14 * Complex.I : ℂ)‖ := Complex.abs_re_le_norm _
        _ < 1 := hd
    linarith [(abs_lt.mp hrec).1]
  exact hζan.eqOn_of_preconnected_of_eventuallyEq hzan hVpre hz0 hevent
    ((hmem s).2 ⟨hre, him1, him2⟩)







/-- Value at zero of the real Bernoulli polynomial. -/
theorem BR_eval_zero (n : ℕ) : (BR n).eval 0 = (bernoulli n : ℝ) := by
  unfold BR
  rw [Polynomial.eval_map]
  rw [show (0:ℝ) = algebraMap ℚ ℝ (0:ℚ) by norm_num]
  rw [Polynomial.eval₂_at_apply]
  rw [Polynomial.bernoulli_eval_zero]
  norm_num



/-- Our real Bernoulli polynomial is Mathlib's `bernoulliFun`. -/
theorem BR_eval_eq_bernoulliFun (n : ℕ) (x : ℝ) :
    (BR n).eval x = bernoulliFun n x := rfl



set_option maxHeartbeats 800000 in
/-- A uniform bound for the Bernoulli function on `[0,1]`. -/
theorem exists_bernoulliFun_bound (k : ℕ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ x ∈ Set.Icc (0:ℝ) 1, |bernoulliFun k x| ≤ C := by
  have hcont : ContinuousOn (fun x : ℝ => |bernoulliFun k x|) (Set.Icc (0:ℝ) 1) :=
    (continuous_bernoulliFun k).abs.continuousOn
  obtain ⟨C, hC⟩ := isCompact_Icc.bddAbove_image hcont
  refine ⟨max C 0, le_max_right _ _, ?_⟩
  intro x hx
  have hle : |bernoulliFun k x| ≤ C := hC (Set.mem_image_of_mem _ hx)
  exact le_trans hle (le_max_left _ _)



/-- Unit norm of the Fourier character. -/
theorem norm_fourier_unit (n : ℤ) (x : UnitAddCircle) : ‖fourier n x‖ = 1 := by
  simp [fourier, Complex.norm_exp]



/-- Norm of a Fourier coefficient term. -/
theorem norm_fourier_term (k : ℕ) {n : ℤ} (hn : n ≠ 0) (x : UnitAddCircle) :
    ‖(1 / (n : ℂ) ^ k) * fourier n x‖ = 1 / (|n| : ℝ) ^ k := by
  rw [norm_mul, norm_fourier_unit, mul_one, norm_div, norm_one, norm_pow,
    Complex.norm_intCast]



/-- The `ℤ`-sum of inverse absolute powers reduces to twice the positive sum. -/
theorem tsum_int_inv_abs_pow (k : ℕ) (hk : 2 ≤ k) :
    (∑' n : ℤ, (1 : ℝ) / (|n| : ℝ) ^ k) =
      2 * (∑' n : ℕ, (1 : ℝ) / ((n + 1 : ℝ) ^ k)) := by
  have hEven : Function.Even (fun n : ℤ => (1 : ℝ) / (|n| : ℝ) ^ k) := by
    intro n
    simp [abs_neg]
  have hsum : Summable (fun n : ℤ => (1 : ℝ) / (|n| : ℝ) ^ k) := by
    have hbase := (Real.summable_one_div_int_pow (p := k)).2 hk
    simpa [one_div, abs_pow, abs_inv] using hbase.abs
  have h := tsum_int_eq_zero_add_two_mul_tsum_pnat hEven hsum
  have h0 : (1 : ℝ) / (|(0:ℤ)| : ℝ) ^ k = 0 := by
    simp [zero_pow (by linarith : k ≠ 0)]
  rw [h0, zero_add] at h
  rw [h]
  simp only [nsmul_eq_mul]
  congr 1
  have hsucc := tsum_pnat_eq_tsum_succ (f := fun n : ℕ => (1 : ℝ) / ((n : ℝ) ^ k))
  simpa [Nat.cast_add, Nat.cast_one, add_comm] using hsucc





/-- The positive inverse-power sum is the real part of `ζ(k)`. -/
theorem zeta_nat_eq_tsum_inv_pow (k : ℕ) (hk : 2 ≤ k) :
    (riemannZeta (k : ℂ)).re =
      ∑' n : ℕ, (1 : ℝ) / ((n + 1 : ℝ) ^ k) := by
  have hk1 : (1 : ℝ) < (k : ℝ) := by exact_mod_cast hk
  have hζ := zeta_eq_tsum_one_div_nat_add_one_cpow (s := (k : ℂ)) (by simpa using hk1)
  have hcast : (((∑' n : ℕ, (1 : ℝ) / ((n + 1 : ℝ) ^ k)) : ℝ) : ℂ) = riemannZeta (k : ℂ) := by
    rw [hζ, Complex.ofReal_tsum]
    apply tsum_congr
    intro n
    push_cast
    norm_num
  rw [← hcast]
  exact Complex.ofReal_re _



set_option maxHeartbeats 800000 in
/-- Norm bound for the Fourier series of the Bernoulli function. -/
theorem norm_fourier_series_le (k : ℕ) (hk : 2 ≤ k) (x : UnitAddCircle) :
    ‖∑' n : ℤ, (1 / (n : ℂ) ^ k) * fourier n x‖ ≤
      2 * (riemannZeta (k : ℂ)).re := by
  have hbase : Summable (fun n : ℤ => (1 : ℝ) / (|n| : ℝ) ^ k) := by
    have hb := (Real.summable_one_div_int_pow (p := k)).2 hk
    simpa [one_div, abs_pow, abs_inv] using hb.abs
  have hnorm_eq : ∀ n : ℤ, ‖(1 / (n : ℂ) ^ k) * fourier n x‖ = (1 : ℝ) / (|n| : ℝ) ^ k := by
    intro n
    by_cases hn : n = 0
    · subst hn
      simp [zero_pow (by linarith : k ≠ 0)]
    · exact norm_fourier_term k hn x
  have hnorm : Summable (fun n : ℤ => ‖(1 / (n : ℂ) ^ k) * fourier n x‖) :=
    hbase.congr (fun n => (hnorm_eq n).symm)
  calc
    ‖∑' n : ℤ, (1 / (n : ℂ) ^ k) * fourier n x‖
        ≤ ∑' n : ℤ, ‖(1 / (n : ℂ) ^ k) * fourier n x‖ := norm_tsum_le_tsum_norm hnorm
    _ = ∑' n : ℤ, (1 : ℝ) / (|n| : ℝ) ^ k := tsum_congr hnorm_eq
    _ = 2 * (∑' n : ℕ, (1 : ℝ) / ((n + 1 : ℝ) ^ k)) := tsum_int_inv_abs_pow k hk
    _ = 2 * (riemannZeta (k : ℂ)).re := by rw [← zeta_nat_eq_tsum_inv_pow k hk]



set_option maxHeartbeats 1200000 in
/-- Periodic Bernoulli bound from the Fourier expansion. -/
theorem abs_bernoulliFun_le (k : ℕ) (hk : 2 ≤ k) {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) :
    |bernoulliFun k x| ≤
      (Nat.factorial k : ℝ) / (2 * Real.pi) ^ k * (2 * (riemannZeta (k : ℂ)).re) := by
  have hsum := hasSum_one_div_pow_mul_fourier_mul_bernoulliFun (k := k) hk hx
  have htsum : (∑' n : ℤ, (1 / (n : ℂ) ^ k) * fourier n ((x : ℝ) : UnitAddCircle)) =
      -(((2 * (Real.pi : ℂ) * Complex.I) ^ k) / (Nat.factorial k : ℂ)) *
        (bernoulliFun k x : ℂ) := by
    convert hsum.tsum_eq using 1
    ring
  have hc : (((2 * (Real.pi : ℂ) * Complex.I) ^ k) / (Nat.factorial k : ℂ)) ≠ 0 := by
    apply div_ne_zero
    · exact pow_ne_zero _ (mul_ne_zero (mul_ne_zero (by norm_num) (by norm_num)) Complex.I_ne_zero)
    · exact_mod_cast Nat.factorial_ne_zero k
  have hB : (bernoulliFun k x : ℂ) =
      -((Nat.factorial k : ℂ) / ((2 * (Real.pi : ℂ) * Complex.I) ^ k)) *
        (∑' n : ℤ, (1 / (n : ℂ) ^ k) * fourier n ((x : ℝ) : UnitAddCircle)) := by
    rw [htsum]
    field_simp [hc]
    rw [mul_div_cancel_right₀ _ (by exact_mod_cast Nat.factorial_ne_zero k)]
  have hnorm : ‖(bernoulliFun k x : ℂ)‖ =
      ‖(Nat.factorial k : ℂ) / ((2 * (Real.pi : ℂ) * Complex.I) ^ k)‖ *
        ‖∑' n : ℤ, (1 / (n : ℂ) ^ k) * fourier n ((x : ℝ) : UnitAddCircle)‖ := by
    rw [hB, norm_mul, norm_neg]
  have hcoef : ‖(Nat.factorial k : ℂ) / ((2 * (Real.pi : ℂ) * Complex.I) ^ k)‖ =
      (Nat.factorial k : ℝ) / (2 * Real.pi) ^ k := by
    rw [norm_div, norm_pow]
    have hnorm : ‖(2 * (Real.pi : ℂ) * Complex.I)‖ = 2 * Real.pi := by
      rw [norm_mul, norm_mul, Complex.norm_I, mul_one]
      simp [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg Real.pi_pos.le]
    rw [hnorm]
    simp [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by positivity : (0:ℝ) ≤ (k:ℝ)),
      abs_of_nonneg (by positivity : (0:ℝ) ≤ (Nat.factorial k : ℝ))]
  calc
    |bernoulliFun k x| = ‖(bernoulliFun k x : ℂ)‖ := by
      rw [Complex.norm_real, Real.norm_eq_abs]
    _ = (Nat.factorial k : ℝ) / (2 * Real.pi) ^ k *
          ‖∑' n : ℤ, (1 / (n : ℂ) ^ k) * fourier n ((x : ℝ) : UnitAddCircle)‖ := by
      rw [hnorm, hcoef]
    _ ≤ (Nat.factorial k : ℝ) / (2 * Real.pi) ^ k * (2 * (riemannZeta (k : ℂ)).re) := by
      apply mul_le_mul_of_nonneg_left
      · exact norm_fourier_series_le k hk ((x : ℝ) : UnitAddCircle)
      · positivity



/-- Periodic Bernoulli bound at an arbitrary real argument. -/
theorem abs_bernoulliFun_fract_le (k : ℕ) (hk : 2 ≤ k) (x : ℝ) :
    |bernoulliFun k (Int.fract x)| ≤
      (Nat.factorial k : ℝ) / (2 * Real.pi) ^ k *
        (2 * (riemannZeta (k : ℂ)).re) := by
  apply abs_bernoulliFun_le k hk
  exact ⟨Int.fract_nonneg x, le_of_lt (Int.fract_lt_one x)⟩



/-- Norm of the general shifted tower term. -/
theorem norm_emGShift (s : ℂ) (N j : ℕ) {x : ℝ} (hx : 0 ≤ x) :
    ‖emGShift s N j x‖ =
      ‖(descPochhammer ℂ j).eval (-s)‖ *
        ((x + (N:ℝ) + 1 : ℝ) ^ (-s.re - (j : ℝ))) := by
  unfold emGShift
  rw [norm_mul]
  have hpow : ‖((((x + (N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + (j : ℂ)))))‖ =
      (x + (N:ℝ) + 1) ^ (-s.re - (j : ℝ)) := by
    have h := norm_cpow_neg_ofReal (s := s + (j : ℂ)) (x := x + (N:ℝ) + 1) (by linarith)
    simpa [Complex.add_re, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h
  rw [hpow]





/-- Nonnegativity of `Re ζ(n)` for natural `n ≥ 2`. -/
theorem zeta_re_nonneg (n : ℕ) (hn : 2 ≤ n) :
    0 ≤ (riemannZeta (n : ℂ)).re := by
  rw [zeta_nat_eq_tsum_inv_pow n hn]
  exact tsum_nonneg (fun m => by positivity)



/-- Pointwise bound for a general Bernoulli–tower product. -/
theorem norm_bernoulli_mul_emGShift_le (n j N k : ℕ) (hn : 2 ≤ n) (s : ℂ)
    (hs : 0 ≤ s.re) {x : ℝ} (hx0 : (k:ℝ) ≤ x) (hx1 : x ≤ (k:ℝ) + 1) :
    ‖(((BR n).eval (x - k) : ℝ) : ℂ) * emGShift s N j x‖ ≤
      ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
        (2 * (riemannZeta (n : ℂ)).re)) *
      ‖(descPochhammer ℂ j).eval (-s)‖ *
      (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))) := by
  have hx0' : (0:ℝ) ≤ x - k := by linarith
  have hx1' : x - k ≤ 1 := by linarith
  have hB : |(BR n).eval (x - k)| ≤
      (Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
        (2 * (riemannZeta (n : ℂ)).re) := by
    have h := abs_bernoulliFun_le n hn (x := x - k) ⟨hx0', hx1'⟩
    simpa [BR_eval_eq_bernoulliFun] using h
  have hE : ‖emGShift s N j x‖ =
      ‖(descPochhammer ℂ j).eval (-s)‖ *
        ((x + (N:ℝ) + 1 : ℝ) ^ (-s.re - (j : ℝ))) :=
    norm_emGShift s N j (by linarith)
  have hbase : (k:ℝ) + (N:ℝ) + 1 ≤ x + (N:ℝ) + 1 := by linarith
  have hexp : -s.re - (j : ℝ) ≤ 0 := by
    have hj : (0:ℝ) ≤ (j:ℝ) := Nat.cast_nonneg j
    linarith
  have hpow : (x + (N:ℝ) + 1) ^ (-s.re - (j : ℝ)) ≤
      ((k:ℝ) + (N:ℝ) + 1) ^ (-s.re - (j : ℝ)) :=
    Real.rpow_le_rpow_of_nonpos (by positivity) hbase hexp
  have hC : 0 ≤ (Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
      (2 * (riemannZeta (n : ℂ)).re) :=
    mul_nonneg (by positivity) (by linarith [zeta_re_nonneg n hn])
  calc
    ‖(((BR n).eval (x - k) : ℝ) : ℂ) * emGShift s N j x‖
        = |(BR n).eval (x - k)| * ‖emGShift s N j x‖ := by
          rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    _ ≤ ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
          (2 * (riemannZeta (n : ℂ)).re)) * ‖emGShift s N j x‖ :=
      mul_le_mul_of_nonneg_right hB (norm_nonneg _)
    _ = ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
          (2 * (riemannZeta (n : ℂ)).re)) *
        (‖(descPochhammer ℂ j).eval (-s)‖ *
          ((x + (N:ℝ) + 1 : ℝ) ^ (-s.re - (j : ℝ)))) := by rw [hE]
    _ = ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
          (2 * (riemannZeta (n : ℂ)).re)) *
        ‖(descPochhammer ℂ j).eval (-s)‖ *
        ((x + (N:ℝ) + 1 : ℝ) ^ (-s.re - (j : ℝ))) := by ring
    _ ≤ ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
          (2 * (riemannZeta (n : ℂ)).re)) *
        ‖(descPochhammer ℂ j).eval (-s)‖ *
        (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))) := by
      apply mul_le_mul_of_nonneg_left hpow
      exact mul_nonneg hC (norm_nonneg _)



/-- Integral bound for a general Bernoulli–tower product. -/
theorem norm_integral_bernoulli_mul_emGShift_le (n j N k : ℕ) (hn : 2 ≤ n) (s : ℂ)
    (hs : 0 ≤ s.re) :
    ‖∫ x in (k:ℝ)..(k+1),
      ((((BR n).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x‖ ≤
      ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
        (2 * (riemannZeta (n : ℂ)).re)) *
      ‖(descPochhammer ℂ j).eval (-s)‖ *
      (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))) := by
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (k:ℝ)) (b := ((k:ℝ) + 1))
    (C := ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
        (2 * (riemannZeta (n : ℂ)).re)) *
      ‖(descPochhammer ℂ j).eval (-s)‖ *
      (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))))
    (f := fun x : ℝ => ((((BR n).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)
    (by
      intro x hx
      have hmin : min (k:ℝ) ((k:ℝ)+1) = (k:ℝ) := min_eq_left (by linarith)
      have hmax : max (k:ℝ) ((k:ℝ)+1) = (k:ℝ)+1 := max_eq_right (by linarith)
      have hx0 : (k:ℝ) < x := by
        have h := hx.1; rw [hmin] at h; exact h
      have hx1 : x ≤ (k:ℝ)+1 := by
        have h := hx.2; rw [hmax] at h; exact h
      exact norm_bernoulli_mul_emGShift_le n j N k hn s hs (le_of_lt hx0) hx1)
  simpa using h



/-- Summed Bernoulli–tower remainder bound. -/
theorem norm_sum_bernoulli_mul_emGShift_le (n j N : ℕ) (hn : 2 ≤ n) (s : ℂ)
    (hs : 0 ≤ s.re) (m : ℕ) :
    ‖Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)‖ ≤
      ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
        (2 * (riemannZeta (n : ℂ)).re)) *
      ‖(descPochhammer ℂ j).eval (-s)‖ *
      (Finset.sum (Finset.range m) (fun k =>
        (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))))) := by
  calc
    ‖Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)‖
        ≤ Finset.sum (Finset.range m) (fun k =>
            ‖∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x‖) :=
          norm_sum_le _ _
    _ ≤ Finset.sum (Finset.range m) (fun k =>
          ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
            (2 * (riemannZeta (n : ℂ)).re)) *
          ‖(descPochhammer ℂ j).eval (-s)‖ *
          (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ)))) := by
          apply Finset.sum_le_sum
          intro k hk
          exact norm_integral_bernoulli_mul_emGShift_le n j N k hn s hs
    _ = ((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n *
          (2 * (riemannZeta (n : ℂ)).re)) *
        ‖(descPochhammer ℂ j).eval (-s)‖ *
        (Finset.sum (Finset.range m) (fun k =>
          (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))))) := by
      rw [Finset.mul_sum]



/-- Uniform bound for the general tail weight sum. -/
theorem sum_tail_rpow_le_inv_general {σ : ℝ} (hσ : 0 < σ) (j N m : ℕ) (hj : 1 ≤ j) :
    Finset.sum (Finset.range m) (fun k =>
      (((k + N + 1 : ℝ)) ^ (-σ - (j : ℝ)))) ≤
      1 + 1 / (σ + (j : ℝ) - 1) := by
  have hσj : 0 < σ + (j : ℝ) - 1 := by
    have hj' : (1:ℝ) ≤ (j:ℝ) := by exact_mod_cast hj
    linarith
  calc
    Finset.sum (Finset.range m) (fun k =>
      (((k + N + 1 : ℝ)) ^ (-σ - (j : ℝ))))
        ≤ Finset.sum (Finset.range m) (fun k =>
            (((k + 1 : ℝ)) ^ (-σ - (j : ℝ)))) := by
          apply Finset.sum_le_sum
          intro k hk
          have hexp : -σ - (j : ℝ) ≤ 0 := by linarith
          have hbase : (0:ℝ) < (k:ℝ) + 1 := by positivity
          have hle : (k:ℝ) + 1 ≤ (k:ℝ) + (N:ℝ) + 1 := by
            have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
            linarith
          exact Real.rpow_le_rpow_of_nonpos hbase hle hexp
    _ ≤ 1 + 1 / (σ + (j : ℝ) - 1) := by
      have h := sum_shifted_rpow_le_inv (σ := σ + (j : ℝ) - 1) hσj m
      simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h





/-- Coarse uniform bound for the general Bernoulli remainder sum. -/
theorem norm_general_correction_le (j N m : ℕ) (hj : 2 ≤ j) (s : ℂ) (hs : 0 < s.re) :
    ‖Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1),
        ((((BR j).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)‖ ≤
      ((Nat.factorial j : ℝ) / (2 * Real.pi) ^ j *
        (2 * (riemannZeta (j : ℂ)).re)) *
      ‖(descPochhammer ℂ j).eval (-s)‖ *
      (1 + 1 / (s.re + (j : ℝ) - 1)) := by
  have h := norm_sum_bernoulli_mul_emGShift_le j j N hj s (le_of_lt hs) m
  have hw := sum_tail_rpow_le_inv_general (σ := s.re) hs j N m (by omega)
  calc
    ‖Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1),
        ((((BR j).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)‖
        ≤ ((Nat.factorial j : ℝ) / (2 * Real.pi) ^ j *
            (2 * (riemannZeta (j : ℂ)).re)) *
          ‖(descPochhammer ℂ j).eval (-s)‖ *
          (Finset.sum (Finset.range m) (fun k =>
            (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))))) := h
    _ ≤ ((Nat.factorial j : ℝ) / (2 * Real.pi) ^ j *
          (2 * (riemannZeta (j : ℂ)).re)) *
        ‖(descPochhammer ℂ j).eval (-s)‖ *
        (1 + 1 / (s.re + (j : ℝ) - 1)) := by
      apply mul_le_mul_of_nonneg_left hw
      exact mul_nonneg (mul_nonneg (by positivity) (by linarith [zeta_re_nonneg j hj]))
        (norm_nonneg _)







/-- Antitonicity of the shifted inverse power with an extra integer shift. -/
theorem antitoneOn_shifted_rpow_shift (σ : ℝ) (hσ : 0 < σ) (N : ℕ) :
    AntitoneOn (fun x : ℝ => (x + (N:ℝ) + 1) ^ (-σ)) (Set.Ici 0) := by
  intro x hx y hy hxy
  have hbase : (0:ℝ) < x + (N:ℝ) + 1 := by
    have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
    have hx0 : (0:ℝ) ≤ x := hx
    linarith
  have hle : x + (N:ℝ) + 1 ≤ y + (N:ℝ) + 1 := by linarith
  have hexp : -σ ≤ 0 := by linarith
  exact Real.rpow_le_rpow_of_nonpos hbase hle hexp







/-- Continuity of the shifted inverse power on `[0,∞)`. -/
theorem continuousOn_shifted_rpow (σ : ℝ) (N : ℕ) :
    ContinuousOn (fun x : ℝ => (x + (N:ℝ) + 1) ^ (-σ)) (Set.Ici 0) := by
  have hf : ContinuousOn (fun x : ℝ => x + (N:ℝ) + 1) (Set.Ici 0) := by fun_prop
  have h := hf.rpow_const (p := -σ) (by
    intro x hx
    left
    have hx0 : (0:ℝ) ≤ x := hx
    have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
    positivity)
  simpa using h







/-- Real tail integral of `x^{-σ}` for `σ > 1`. -/
theorem integral_Ioi_rpow_neg {σ : ℝ} (hσ : 1 < σ) {c : ℝ} (hc : 0 < c) :
    (∫ t : ℝ in Set.Ioi c, t ^ (-σ)) = c ^ (1 - σ) / (σ - 1) := by
  have h := integral_Ioi_rpow_of_lt (a := -σ) (by linarith) hc
  rw [h, show -σ + 1 = 1 - σ by ring]
  have h1 : (1 - σ : ℝ) ≠ 0 := by linarith
  have h2 : (σ - 1 : ℝ) ≠ 0 := by linarith
  field_simp [h1, h2]
  ring





/-- Integrability of the shifted inverse power on `(0,∞)`. -/
theorem integrableOn_shift_rpow (σ : ℝ) (hσ : 1 < σ) (N : ℕ) :
    IntegrableOn (fun x : ℝ => (x + (N:ℝ) + 1) ^ (-σ)) (Set.Ioi 0) := by
  set c : ℝ := (N:ℝ) + 1 with hcdef
  have hc : 0 < c := by positivity
  have hIntC : IntegrableOn (fun y : ℝ => y ^ (-σ)) (Set.Ioi c) :=
    integrableOn_Ioi_rpow_of_lt (by linarith) hc
  have hpre : (fun x : ℝ => c + x) ⁻¹' Set.Ioi c = Set.Ioi 0 := by
    ext x
    simp [Set.mem_Ioi]
  have hmap : MeasureTheory.volume.restrict (Set.Ioi c) =
      (MeasureTheory.volume.restrict (Set.Ioi 0)).map (fun x : ℝ => c + x) := by
    calc MeasureTheory.volume.restrict (Set.Ioi c)
        = (MeasureTheory.volume.map (fun x : ℝ => c + x)).restrict (Set.Ioi c) := by
          rw [map_add_left_eq_self]
      _ = (MeasureTheory.volume.restrict (Set.Ioi 0)).map (fun x : ℝ => c + x) := by
          rw [Measure.restrict_map (f := fun x : ℝ => c + x) (μ := MeasureTheory.volume) (s := Set.Ioi c) (measurable_const.add measurable_id) measurableSet_Ioi, hpre]
  change Integrable (fun y : ℝ => y ^ (-σ))
    (MeasureTheory.volume.restrict (Set.Ioi c)) at hIntC
  rw [hmap] at hIntC
  have hiff := (measurableEmbedding_addLeft c).integrable_map_iff
    (μ := MeasureTheory.volume.restrict (Set.Ioi 0)) (g := fun y : ℝ => y ^ (-σ))
  simpa [IntegrableOn, Function.comp_def, hcdef, add_comm, add_left_comm, add_assoc]
    using hiff.mp hIntC



/-- Shifted tail integral of the inverse power. -/
theorem integral_Ioi_shift_rpow (σ : ℝ) (hσ : 1 < σ) (N : ℕ) :
    (∫ x : ℝ in Set.Ioi 0, (x + (N:ℝ) + 1) ^ (-σ)) =
      (((N:ℝ) + 1) ^ (1 - σ)) / (σ - 1) := by
  set c : ℝ := (N:ℝ) + 1 with hcdef
  have hc : 0 < c := by positivity
  have hIntC : IntegrableOn (fun y : ℝ => y ^ (-σ)) (Set.Ioi c) :=
    integrableOn_Ioi_rpow_of_lt (by linarith) hc
  have hInt0 : IntegrableOn (fun x : ℝ => (c + x) ^ (-σ)) (Set.Ioi 0) := by
    simpa [hcdef, add_comm, add_left_comm, add_assoc] using integrableOn_shift_rpow σ hσ N
  have hpre : (fun x : ℝ => c + x) ⁻¹' Set.Ioi c = Set.Ioi 0 := by
    ext x
    simp [Set.mem_Ioi]
  have hmap : MeasureTheory.volume.restrict (Set.Ioi c) =
      (MeasureTheory.volume.restrict (Set.Ioi 0)).map (fun x : ℝ => c + x) := by
    calc MeasureTheory.volume.restrict (Set.Ioi c)
        = (MeasureTheory.volume.map (fun x : ℝ => c + x)).restrict (Set.Ioi c) := by
          rw [map_add_left_eq_self]
      _ = (MeasureTheory.volume.restrict (Set.Ioi 0)).map (fun x : ℝ => c + x) := by
          rw [Measure.restrict_map (f := fun x : ℝ => c + x) (μ := MeasureTheory.volume) (s := Set.Ioi c) (measurable_const.add measurable_id) measurableSet_Ioi, hpre]
  have hφ : AEMeasurable (fun x : ℝ => c + x) (MeasureTheory.volume.restrict (Set.Ioi 0)) :=
    (measurable_const.add measurable_id).aemeasurable
  have hfm : AEStronglyMeasurable (fun y : ℝ => y ^ (-σ))
      ((MeasureTheory.volume.restrict (Set.Ioi 0)).map (fun x : ℝ => c + x)) := by
    rw [← hmap]
    exact hIntC.aestronglyMeasurable
  have h := MeasureTheory.integral_map hφ hfm
  calc (∫ x : ℝ in Set.Ioi 0, (x + (N:ℝ) + 1) ^ (-σ))
      = ∫ x, (c + x) ^ (-σ) ∂(MeasureTheory.volume.restrict (Set.Ioi 0)) := by
        simp only [hcdef, add_comm, add_assoc]
    _ = ∫ y, y ^ (-σ) ∂((MeasureTheory.volume.restrict (Set.Ioi 0)).map (fun x : ℝ => c + x)) := h.symm
    _ = ∫ y : ℝ in Set.Ioi c, y ^ (-σ) := by rw [hmap]
    _ = c ^ (1 - σ) / (σ - 1) := integral_Ioi_rpow_neg hσ hc



/-- Sharp tail bound for the shifted inverse power. -/
theorem tsum_shift_rpow_le (σ : ℝ) (hσ : 1 < σ) (N : ℕ) :
    (∑' k : ℕ, ((k + (N:ℝ) + 1) ^ (-σ))) ≤
      ((N:ℝ) + 1) ^ (-σ) + (((N:ℝ) + 1) ^ (1 - σ)) / (σ - 1) := by
  have h := AntitoneOn.tsum_le_integral (f := fun x : ℝ => (x + (N:ℝ) + 1) ^ (-σ))
    (antitoneOn_shifted_rpow_shift σ (by linarith) N)
    (integrableOn_shift_rpow σ hσ N)
    (fun t ht => Real.rpow_nonneg (by
      have ht0 : (0:ℝ) < t := ht
      have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
      linarith) _)
  simpa [integral_Ioi_shift_rpow σ hσ N] using h



/-- Sharp general Bernoulli remainder bound with `N`-decay. -/
theorem norm_general_correction_le_sharp (j N m : ℕ) (hj : 2 ≤ j) (s : ℂ)
    (hs : 0 < s.re) :
    ‖Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1),
        ((((BR j).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)‖ ≤
      ((Nat.factorial j : ℝ) / (2 * Real.pi) ^ j *
        (2 * (riemannZeta (j : ℂ)).re)) *
      ‖(descPochhammer ℂ j).eval (-s)‖ *
      ((((N:ℝ) + 1) ^ (-s.re - (j : ℝ))) +
        ((((N:ℝ) + 1) ^ (1 - s.re - (j : ℝ))) / (s.re + (j : ℝ) - 1))) := by
  have hσ : 1 < s.re + (j : ℝ) := by
    have hj' : (2:ℝ) ≤ (j:ℝ) := by exact_mod_cast hj
    linarith
  have hsummable : Summable (fun k : ℕ => ((k + (N:ℝ) + 1) ^ (-(s.re + (j : ℝ))))) := by
    have hp : -(s.re + (j : ℝ)) < -1 := by linarith
    have hbase : Summable (fun n : ℕ => (n:ℝ) ^ (-(s.re + (j : ℝ)))) :=
      (Real.summable_nat_rpow (p := -(s.re + (j : ℝ)))).2 hp
    have hshift := (summable_nat_add_iff (f := fun n : ℕ => (n:ℝ) ^ (-(s.re + (j : ℝ)))) (N + 1)).2 hbase
    simpa [Nat.cast_add, Nat.cast_one, add_comm, add_left_comm, add_assoc] using hshift
  have hfinite : Finset.sum (Finset.range m) (fun k =>
      ((k + (N:ℝ) + 1) ^ (-s.re - (j : ℝ)))) ≤
      ∑' k : ℕ, ((k + (N:ℝ) + 1) ^ (-s.re - (j : ℝ))) := by
    apply Summable.sum_le_tsum
    · intro k hk
      exact Real.rpow_nonneg (by positivity) _
    · simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using hsummable
  have h := norm_sum_bernoulli_mul_emGShift_le j j N hj s (le_of_lt hs) m
  have hw := tsum_shift_rpow_le (σ := s.re + (j : ℝ)) hσ N
  calc
    ‖Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1),
        ((((BR j).eval (x - k) : ℝ) : ℂ)) * emGShift s N j x)‖
        ≤ ((Nat.factorial j : ℝ) / (2 * Real.pi) ^ j *
            (2 * (riemannZeta (j : ℂ)).re)) *
          ‖(descPochhammer ℂ j).eval (-s)‖ *
          (Finset.sum (Finset.range m) (fun k =>
            (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))))) := h
    _ ≤ ((Nat.factorial j : ℝ) / (2 * Real.pi) ^ j *
          (2 * (riemannZeta (j : ℂ)).re)) *
        ‖(descPochhammer ℂ j).eval (-s)‖ *
        ((((N:ℝ) + 1) ^ (-s.re - (j : ℝ))) +
          ((((N:ℝ) + 1) ^ (1 - s.re - (j : ℝ))) / (s.re + (j : ℝ) - 1))) := by
      have hbound : Finset.sum (Finset.range m) (fun k =>
          (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ)))) ≤
          ((((N:ℝ) + 1) ^ (-s.re - (j : ℝ))) +
            ((((N:ℝ) + 1) ^ (1 - s.re - (j : ℝ))) / (s.re + (j : ℝ) - 1))) := by
        calc Finset.sum (Finset.range m) (fun k =>
            (((k + N + 1 : ℝ)) ^ (-s.re - (j : ℝ))))
            ≤ ∑' k : ℕ, ((k + (N:ℝ) + 1) ^ (-s.re - (j : ℝ))) := hfinite
          _ ≤ ((((N:ℝ) + 1) ^ (-s.re - (j : ℝ))) +
              ((((N:ℝ) + 1) ^ (1 - s.re - (j : ℝ))) / (s.re + (j : ℝ) - 1))) := by
              simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using hw
      exact mul_le_mul_of_nonneg_left hbound
        (mul_nonneg (mul_nonneg (by positivity) (by linarith [zeta_re_nonneg j hj]))
          (norm_nonneg _))







set_option maxHeartbeats 800000 in
/-- Sharp bound for the infinite `B_2` correction series. -/
theorem norm_tsum_correction_le_sharp (N : ℕ) (s : ℂ) (hs : 0 < s.re) :
    ‖∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x‖ ≤
      ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
        (2 * (riemannZeta (2 : ℂ)).re)) *
      ‖(descPochhammer ℂ 2).eval (-s)‖ *
      ((((N:ℝ) + 1) ^ (-s.re - 2)) +
        ((((N:ℝ) + 1) ^ (1 - s.re - 2)) / (s.re + 1))) := by
  have hσ : 1 < s.re + 1 := by linarith
  have hsummable_w : Summable (fun k : ℕ => ((k + (N:ℝ) + 1) ^ (-s.re - 2))) := by
    have h := summable_tail_rpow (σ := s.re + 1) (by linarith : 0 < s.re + 1) N
    convert h using 1
    ext k
    ring
  have hnorm_eq : ∀ k : ℕ,
      ‖∫ x in (k:ℝ)..(k+1), ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x‖ ≤
        ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
          (2 * (riemannZeta (2 : ℂ)).re)) *
        ‖(descPochhammer ℂ 2).eval (-s)‖ *
        (((k + N + 1 : ℝ)) ^ (-s.re - 2)) := by
    intro k
    simpa using norm_integral_bernoulli_mul_emGShift_le 2 2 N k (by norm_num) s (le_of_lt hs)
  have hbound_summable : Summable (fun k : ℕ =>
      ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
        (2 * (riemannZeta (2 : ℂ)).re)) *
      ‖(descPochhammer ℂ 2).eval (-s)‖ *
      (((k + N + 1 : ℝ)) ^ (-s.re - 2))) :=
    hsummable_w.mul_left _
  have hnorm_summable : Summable (fun k : ℕ =>
      ‖∫ x in (k:ℝ)..(k+1), ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x‖) := by
    apply Summable.of_nonneg_of_le (fun k => norm_nonneg _) hnorm_eq hbound_summable
  have hweight : (∑' k : ℕ, (((k + (N:ℝ) + 1)) ^ (-s.re - 2))) ≤
      ((((N:ℝ) + 1) ^ (-s.re - 2)) +
        ((((N:ℝ) + 1) ^ (1 - s.re - 2)) / (s.re + 1))) := by
    have h := tsum_shift_rpow_le (σ := s.re + 2) (by linarith) N
    convert h using 1
    · congr 1
      ext k
      ring
    · ring
  calc
    ‖∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x‖
        ≤ ∑' k : ℕ, ‖∫ x in (k:ℝ)..(k+1),
            ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x‖ :=
          norm_tsum_le_tsum_norm hnorm_summable
    _ ≤ ∑' k : ℕ, ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
          (2 * (riemannZeta (2 : ℂ)).re)) *
        ‖(descPochhammer ℂ 2).eval (-s)‖ *
        (((k + N + 1 : ℝ)) ^ (-s.re - 2)) :=
          Summable.tsum_le_tsum hnorm_eq hnorm_summable hbound_summable
    _ = ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
          (2 * (riemannZeta (2 : ℂ)).re)) *
        ‖(descPochhammer ℂ 2).eval (-s)‖ *
        (∑' k : ℕ, (((k + N + 1 : ℝ)) ^ (-s.re - 2))) := by
          rw [tsum_mul_left]
    _ ≤ ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
          (2 * (riemannZeta (2 : ℂ)).re)) *
        ‖(descPochhammer ℂ 2).eval (-s)‖ *
        ((((N:ℝ) + 1) ^ (-s.re - 2)) +
          ((((N:ℝ) + 1) ^ (1 - s.re - 2)) / (s.re + 1))) := by
          apply mul_le_mul_of_nonneg_left hweight
          exact mul_nonneg (mul_nonneg (by positivity)
            (by
              have hz : 0 ≤ (riemannZeta (2:ℂ)).re := zeta_re_nonneg 2 (by norm_num)
              linarith)) (norm_nonneg _)





set_option maxHeartbeats 800000 in
/-- Sharp bound for the first-order correction series. -/
theorem norm_tsum_correction_first_le (N : ℕ) (s : ℂ) (hs : 0 < s.re) :
    ‖∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖ ≤
      (‖s‖ / 2) *
        ((((N:ℝ) + 1) ^ (-s.re - 1)) +
          ((((N:ℝ) + 1) ^ (-s.re)) / s.re)) := by
  have hσ : 1 < s.re + 1 := by linarith
  have hsummable_w : Summable (fun k : ℕ => ((k + (N:ℝ) + 1) ^ (-s.re - 1))) := by
    have h := summable_tail_rpow (σ := s.re) hs N
    convert h using 1
  have hnorm_eq : ∀ k : ℕ,
      ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖ ≤
        (‖s‖ / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := by
    intro k
    have h := norm_integral_tail_correction_le (s := s) (N := N) (k := k) (by linarith : -1 < s.re)
    calc
      ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
          ≤ ‖s‖ * (1 / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := h
      _ = (‖s‖ / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1)) := by ring
  have hbound_summable : Summable (fun k : ℕ =>
      (‖s‖ / 2) * (((k + N + 1 : ℝ)) ^ (-s.re - 1))) :=
    hsummable_w.mul_left _
  have hnorm_summable : Summable (fun k : ℕ =>
      ‖∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖) := by
    apply Summable.of_nonneg_of_le (fun k => norm_nonneg _) hnorm_eq hbound_summable
  have hweight : (∑' k : ℕ, (((k + (N:ℝ) + 1)) ^ (-s.re - 1))) ≤
      ((((N:ℝ) + 1) ^ (-s.re - 1)) +
        ((((N:ℝ) + 1) ^ (-s.re)) / s.re)) := by
    have h := tsum_shift_rpow_le (σ := s.re + 1) hσ N
    convert h using 1
    · congr 1
      ext k
      ring
    · ring
  calc
    ‖∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖
        ≤ ∑' k : ℕ, ‖∫ x in (k:ℝ)..(k+1),
            (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x‖ :=
          norm_tsum_le_tsum_norm hnorm_summable
    _ ≤ ∑' k : ℕ, (‖s‖ / 2) *
        (((k + N + 1 : ℝ)) ^ (-s.re - 1)) :=
          Summable.tsum_le_tsum hnorm_eq hnorm_summable hbound_summable
    _ = (‖s‖ / 2) * (∑' k : ℕ, (((k + N + 1 : ℝ)) ^ (-s.re - 1))) := by
          rw [tsum_mul_left]
    _ ≤ (‖s‖ / 2) *
        ((((N:ℝ) + 1) ^ (-s.re - 1)) +
          ((((N:ℝ) + 1) ^ (-s.re)) / s.re)) := by
          apply mul_le_mul_of_nonneg_left hweight
          positivity



/-- Certified value enclosure of `ζ` on the first-zero strip. -/
theorem norm_zeta_sub_base_le (N : ℕ) {s : ℂ}
    (hre : 0 < s.re) (him1 : 1 < s.im) (him2 : s.im < 20) :
    ‖riemannZeta s -
      ((Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))) +
        (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) / (s - 1)) +
        emGShift s N 0 0 / 2)‖ ≤
      (‖s‖ / 2) *
        ((((N:ℝ) + 1) ^ (-s.re - 1)) +
          ((((N:ℝ) + 1) ^ (-s.re)) / s.re)) := by
  rw [zeta_eq_zetaEM_of_im N hre him1 him2]
  have hdiff : zetaEM N s -
      ((Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))) +
        (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) / (s - 1)) +
        emGShift s N 0 0 / 2) =
      (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) := by
    simp [zetaEM]
  rw [hdiff]
  exact norm_tsum_correction_first_le N s hre



/-- Derivative in `s` of the zero-level shifted tower. -/
theorem hasDerivAt_emGShift_zero (N : ℕ) {x : ℝ} (hx : 0 ≤ x) (s : ℂ) :
    HasDerivAt (fun z : ℂ => emGShift z N 0 x)
      (emGShift s N 0 x * (-Complex.log ((((x + (N:ℝ) + 1 : ℝ) : ℂ))))) s := by
  have hbase : ((((x + (N:ℝ) + 1 : ℝ) : ℂ))) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr (by linarith [show (0:ℝ) ≤ N by exact_mod_cast Nat.zero_le N] : x + (N:ℝ) + 1 ≠ 0)
  have hexp : HasDerivAt (fun z : ℂ => -z) (-1) s := (hasDerivAt_id s).neg
  have hcp := hexp.const_cpow (Or.inl hbase)
  have hval : (fun z : ℂ => emGShift z N 0 x) =
      (fun z : ℂ => ((((x + (N:ℝ) + 1 : ℝ) : ℂ)) ^ (-z))) := by
    funext z
    simp [emGShift, descPochhammer]
  rw [hval]
  convert hcp using 1
  simp [emGShift, descPochhammer]



/-- The explicit base of the fixed-`N` expression. -/
noncomputable def zetaBase (N : ℕ) (s : ℂ) : ℂ :=
  (Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s))))) +
    (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) / (s - 1)) +
    emGShift s N 0 0 / 2

theorem zetaEM_eq_base_add (N : ℕ) (s : ℂ) :
    zetaEM N s = zetaBase N s +
      (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) := by
  simp [zetaEM, zetaBase]
  ring

/-- Analyticity of the explicit base on the punctured half-plane. -/
theorem differentiableOn_zetaBase (N : ℕ) :
    DifferentiableOn ℂ (zetaBase N) {s : ℂ | 0 < s.re ∧ s ≠ 1} := by
  have h1 : DifferentiableOn ℂ (fun s : ℂ =>
      Finset.sum (Finset.range N) (fun n => ((((n + 1 : ℝ) : ℂ) ^ (-s)))))
      {s : ℂ | 0 < s.re ∧ s ≠ 1} :=
    (differentiable_fixed_prefix N).differentiableOn
  have h2 : DifferentiableOn ℂ (fun s : ℂ =>
      (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s)) / (s - 1)))
      {s : ℂ | 0 < s.re ∧ s ≠ 1} := by
    intro s hs
    exact (differentiableAt_pole_term N hs.2).differentiableWithinAt
  have h3 : DifferentiableOn ℂ (fun s : ℂ => emGShift s N 0 0 / 2)
      {s : ℂ | 0 < s.re ∧ s ≠ 1} :=
    ((differentiable_emGShift_zero N (le_refl 0)).div_const 2).differentiableOn
  exact (h1.add h2).add h3



/-- Certified error bound of `ζ` against `zetaBase`. -/
theorem norm_zeta_sub_zetaBase_le (N : ℕ) {s : ℂ}
    (hre : 0 < s.re) (him1 : 1 < s.im) (him2 : s.im < 20) :
    ‖riemannZeta s - zetaBase N s‖ ≤
      (‖s‖ / 2) *
        ((((N:ℝ) + 1) ^ (-s.re - 1)) +
          ((((N:ℝ) + 1) ^ (-s.re)) / s.re)) := by
  simpa [zetaBase] using norm_zeta_sub_base_le N hre him1 him2



/-- Cauchy derivative estimate from a uniform norm bound on a ball. -/
theorem norm_deriv_le_of_norm_le_on_ball {f : ℂ → ℂ} {c : ℂ} {R M : ℝ}
    (hR : 0 < R) (hd : DifferentiableOn ℂ f (Metric.ball c R))
    (hM : ∀ z ∈ Metric.ball c R, ‖f z‖ ≤ M) :
    ‖deriv f c‖ ≤ 2 * M / R := by
  have hmaps : Set.MapsTo f (Metric.ball c R) (Metric.closedBall (f c) (2 * M)) := by
    intro z hz
    rw [Metric.mem_closedBall, dist_eq_norm]
    calc ‖f z - f c‖ ≤ ‖f z‖ + ‖f c‖ := norm_sub_le _ _
      _ ≤ M + M := add_le_add (hM z hz) (hM c (Metric.mem_ball_self hR))
      _ = 2 * M := by ring
  have h := Complex.norm_deriv_le_div_of_mapsTo_ball hd hmaps hR
  calc ‖deriv f c‖ ≤ (2 * M) / R := h





/-- Conditional derivative enclosure of `ζ` from a uniform error bound on a ball. -/
theorem norm_deriv_zeta_le_of_bound (N : ℕ) {s0 : ℂ} {R M : ℝ}
    (hR : 0 < R)
    (h1 : ∀ z ∈ Metric.ball s0 R, z ≠ 1)
    (hstrip : ∀ z ∈ Metric.ball s0 R, 0 < z.re)
    (hM : ∀ z ∈ Metric.ball s0 R, ‖riemannZeta z - zetaBase N z‖ ≤ M) :
    ‖deriv riemannZeta s0‖ ≤ ‖deriv (zetaBase N) s0‖ + 2 * M / R := by
  have hmem : s0 ∈ Metric.ball s0 R := Metric.mem_ball_self hR
  have hnb : Metric.ball s0 R ∈ 𝓝 s0 := Metric.isOpen_ball.mem_nhds hmem
  have hζdiff : DifferentiableOn ℂ riemannZeta (Metric.ball s0 R) := by
    intro z hz
    exact (differentiableAt_riemannZeta (h1 z hz)).differentiableWithinAt
  have hbasediff : DifferentiableOn ℂ (zetaBase N) (Metric.ball s0 R) := by
    apply (differentiableOn_zetaBase N).mono
    intro z hz
    exact ⟨hstrip z hz, h1 z hz⟩
  have hediff : DifferentiableOn ℂ (fun z => riemannZeta z - zetaBase N z)
      (Metric.ball s0 R) := hζdiff.sub hbasediff
  have hcauchy := norm_deriv_le_of_norm_le_on_ball hR hediff hM
  have hfun : (zetaBase N + fun z => riemannZeta z - zetaBase N z) = riemannZeta := by
    funext z
    simp
  have hbase := (hbasediff.differentiableAt hnb).hasDerivAt
  have herr := (hediff.differentiableAt hnb).hasDerivAt
  have hadd := hbase.add herr
  rw [hfun] at hadd
  have hderiv := hadd.deriv
  calc
    ‖deriv riemannZeta s0‖ =
        ‖deriv (zetaBase N) s0 + deriv (fun z => riemannZeta z - zetaBase N z) s0‖ := by
          rw [hderiv]
    _ ≤ ‖deriv (zetaBase N) s0‖ +
        ‖deriv (fun z => riemannZeta z - zetaBase N z) s0‖ := norm_add_le _ _
    _ ≤ ‖deriv (zetaBase N) s0‖ + 2 * M / R := by
      linarith [hcauchy]



/-- Existence of a uniform error bound on a closed ball inside the strip. -/
theorem exists_error_bound_ball (N : ℕ) {s0 : ℂ} {R : ℝ} (hR : 0 < R)
    (h1 : ∀ z ∈ Metric.ball s0 (R + 1), z ≠ 1)
    (hstrip : ∀ z ∈ Metric.ball s0 (R + 1), 0 < z.re) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ z ∈ Metric.closedBall s0 R,
      ‖riemannZeta z - zetaBase N z‖ ≤ M := by
  have hball_sub : Metric.closedBall s0 R ⊆ Metric.ball s0 (R + 1) := by
    intro z hz
    rw [Metric.mem_closedBall] at hz
    rw [Metric.mem_ball]
    linarith
  have hζdiff : DifferentiableOn ℂ riemannZeta (Metric.ball s0 (R + 1)) := by
    intro z hz
    exact (differentiableAt_riemannZeta (h1 z hz)).differentiableWithinAt
  have hbasediff : DifferentiableOn ℂ (zetaBase N) (Metric.ball s0 (R + 1)) := by
    apply (differentiableOn_zetaBase N).mono
    intro z hz
    exact ⟨hstrip z hz, h1 z hz⟩
  have hdiff : DifferentiableOn ℂ (fun z => riemannZeta z - zetaBase N z)
      (Metric.ball s0 (R + 1)) := hζdiff.sub hbasediff
  have hcont : ContinuousOn (fun z => ‖riemannZeta z - zetaBase N z‖)
      (Metric.closedBall s0 R) :=
    (hdiff.continuousOn.norm).mono hball_sub
  have hK : IsCompact (Metric.closedBall s0 R) := isCompact_closedBall s0 R
  obtain ⟨M, hM⟩ := hK.bddAbove_image hcont
  refine ⟨max M 0, le_max_right _ _, ?_⟩
  intro z hz
  have hle : ‖riemannZeta z - zetaBase N z‖ ≤ M := hM (Set.mem_image_of_mem _ hz)
  exact le_trans hle (le_max_left _ _)



/-- General uniform error bound on a closed ball inside a slightly larger ball. -/
theorem exists_error_bound_ball' (N : ℕ) {s0 : ℂ} {R R1 : ℝ}
    (hR : 0 < R) (hRR : R < R1)
    (h1 : ∀ z ∈ Metric.ball s0 R1, z ≠ 1)
    (hstrip : ∀ z ∈ Metric.ball s0 R1, 0 < z.re) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ z ∈ Metric.closedBall s0 R,
      ‖riemannZeta z - zetaBase N z‖ ≤ M := by
  have hball_sub : Metric.closedBall s0 R ⊆ Metric.ball s0 R1 := by
    intro z hz
    rw [Metric.mem_closedBall] at hz
    rw [Metric.mem_ball]
    linarith
  have hζdiff : DifferentiableOn ℂ riemannZeta (Metric.ball s0 R1) := by
    intro z hz
    exact (differentiableAt_riemannZeta (h1 z hz)).differentiableWithinAt
  have hbasediff : DifferentiableOn ℂ (zetaBase N) (Metric.ball s0 R1) := by
    apply (differentiableOn_zetaBase N).mono
    intro z hz
    exact ⟨hstrip z hz, h1 z hz⟩
  have hdiff : DifferentiableOn ℂ (fun z => riemannZeta z - zetaBase N z)
      (Metric.ball s0 R1) := hζdiff.sub hbasediff
  have hcont : ContinuousOn (fun z => ‖riemannZeta z - zetaBase N z‖)
      (Metric.closedBall s0 R) :=
    (hdiff.continuousOn.norm).mono hball_sub
  have hK : IsCompact (Metric.closedBall s0 R) := isCompact_closedBall s0 R
  obtain ⟨M, hM⟩ := hK.bddAbove_image hcont
  refine ⟨max M 0, le_max_right _ _, ?_⟩
  intro z hz
  have hle : ‖riemannZeta z - zetaBase N z‖ ≤ M := hM (Set.mem_image_of_mem _ hz)
  exact le_trans hle (le_max_left _ _)



/-- Uniform error bound on a ball around the first zero height. -/
theorem exists_error_bound_first_zero (N : ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ z ∈ Metric.closedBall ((1/2 : ℂ) + 14 * Complex.I) (1/8),
      ‖riemannZeta z - zetaBase N z‖ ≤ M := by
  apply exists_error_bound_ball' N (R := (1/8 : ℝ)) (R1 := (3/8 : ℝ))
    (by norm_num) (by norm_num)
  · intro z hz
    have hnorm : ‖z - ((1/2 : ℂ) + 14 * Complex.I)‖ < (3/8 : ℝ) := by
      simpa [dist_eq_norm] using Metric.mem_ball.mp hz
    intro hz1
    subst hz1
    have him : |((1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)).im| < (3/8 : ℝ) := by
      calc |((1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)).im|
          ≤ ‖(1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)‖ := Complex.abs_im_le_norm _
        _ < 3/8 := hnorm
    norm_num at him
  · intro z hz
    have hnorm : ‖z - ((1/2 : ℂ) + 14 * Complex.I)‖ < (3/8 : ℝ) := by
      simpa [dist_eq_norm] using Metric.mem_ball.mp hz
    have hre : |z.re - (1/2 : ℝ)| < (3/8 : ℝ) := by
      calc |z.re - (1/2 : ℝ)| = |(z - ((1/2 : ℂ) + 14 * Complex.I)).re| := by simp
        _ ≤ ‖z - ((1/2 : ℂ) + 14 * Complex.I)‖ := Complex.abs_re_le_norm _
        _ < 3/8 := hnorm
    linarith [(abs_lt.mp hre).1]



/-- Concrete derivative bound of `ζ` at the first-zero height. -/
theorem deriv_zeta_bound_first_zero (N : ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧
      ‖deriv riemannZeta ((1/2 : ℂ) + 14 * Complex.I)‖ ≤
        ‖deriv (zetaBase N) ((1/2 : ℂ) + 14 * Complex.I)‖ + 16 * M := by
  obtain ⟨M, hM0, hM⟩ := exists_error_bound_first_zero N
  refine ⟨M, hM0, ?_⟩
  have h1 : ∀ z ∈ Metric.ball ((1/2 : ℂ) + 14 * Complex.I) (1/8), z ≠ 1 := by
    intro z hz
    have hnorm : ‖z - ((1/2 : ℂ) + 14 * Complex.I)‖ < (1/8 : ℝ) := by
      simpa [dist_eq_norm] using Metric.mem_ball.mp hz
    intro hz1
    subst hz1
    have him : |((1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)).im| < (1/8 : ℝ) := by
      calc |((1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)).im|
          ≤ ‖(1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)‖ := Complex.abs_im_le_norm _
        _ < 1/8 := hnorm
    norm_num at him
  have hstrip : ∀ z ∈ Metric.ball ((1/2 : ℂ) + 14 * Complex.I) (1/8), 0 < z.re := by
    intro z hz
    have hnorm : ‖z - ((1/2 : ℂ) + 14 * Complex.I)‖ < (1/8 : ℝ) := by
      simpa [dist_eq_norm] using Metric.mem_ball.mp hz
    have hre : |z.re - (1/2 : ℝ)| < (1/8 : ℝ) := by
      calc |z.re - (1/2 : ℝ)| = |(z - ((1/2 : ℂ) + 14 * Complex.I)).re| := by simp
        _ ≤ ‖z - ((1/2 : ℂ) + 14 * Complex.I)‖ := Complex.abs_re_le_norm _
        _ < 1/8 := hnorm
    linarith [(abs_lt.mp hre).1]
  have hM' : ∀ z ∈ Metric.ball ((1/2 : ℂ) + 14 * Complex.I) (1/8),
      ‖riemannZeta z - zetaBase N z‖ ≤ M := by
    intro z hz
    apply hM z
    rw [Metric.mem_closedBall]
    rw [Metric.mem_ball] at hz
    linarith
  have h := norm_deriv_zeta_le_of_bound N (s0 := (1/2 : ℂ) + 14 * Complex.I)
    (R := (1/8 : ℝ)) (M := M) (by norm_num) h1 hstrip hM'
  calc
    ‖deriv riemannZeta ((1/2 : ℂ) + 14 * Complex.I)‖
        ≤ ‖deriv (zetaBase N) ((1/2 : ℂ) + 14 * Complex.I)‖ + 2 * M / (1/8 : ℝ) := h
    _ = ‖deriv (zetaBase N) ((1/2 : ℂ) + 14 * Complex.I)‖ + 16 * M := by ring



/-- Bernoulli coefficient `B_{2j}/(2j)!` of the general Euler–Maclaurin expansion. -/
noncomputable def emCoef (j : ℕ) : ℝ := _root_.bernoulli (2 * j) / (Nat.factorial (2 * j) : ℝ)

theorem emCoef_one : emCoef 1 = (1 / 12 : ℝ) := by
  simp [emCoef, _root_.bernoulli_two]
  norm_num



theorem emCoef_two : emCoef 2 = (-1 / 720 : ℝ) := by
  simp [emCoef, show _root_.bernoulli 4 = (-1 / 30 : ℚ) by decide +kernel]
  norm_num



/-- General-`K` Bernoulli part of the fixed-`N` expression. -/
noncomputable def zetaEMGen (K N : ℕ) (s : ℂ) : ℂ :=
  zetaBase N s +
    (Finset.sum (Finset.range K) (fun j =>
      (-(emCoef (j + 1) : ℂ) * emGShift s N (2 * (j + 1) - 1) 0)))

/-- The `K = 1` general expression, with the first Bernoulli term explicit. -/
theorem zetaEMGen_one (N : ℕ) (s : ℂ) :
    zetaEMGen 1 N s =
      zetaBase N s + (1 / 12 : ℂ) * s *
        ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1))) := by
  simp [zetaEMGen, emCoef_one, emGShift, descPochhammer]
  ring_nf



/-- The `K = 0` general expression is the explicit base. -/
theorem zetaEMGen_zero (N : ℕ) (s : ℂ) :
    zetaEMGen 0 N s = zetaBase N s := by
  simp [zetaEMGen]



/-- Recurrence for the general-`K` expression. -/
theorem zetaEMGen_succ (K N : ℕ) (s : ℂ) :
    zetaEMGen (K + 1) N s =
      zetaEMGen K N s +
        (-(emCoef (K + 1) : ℂ) * emGShift s N (2 * (K + 1) - 1) 0) := by
  simp only [zetaEMGen, Finset.sum_range_succ]
  ring





/-- Telescoping of the shifted first-derivative tower. -/
theorem sum_range_emGShift_one_sub (s : ℂ) (N n : ℕ) :
    Finset.sum (Finset.range n) (fun k => emGShift s N 1 (k + 1) - emGShift s N 1 k) =
      emGShift s N 1 n - emGShift s N 1 0 := by
  simpa [Nat.cast_add, Nat.cast_one] using
    sum_range_sub_complex (fun k => emGShift s N 1 (k : ℝ)) n



/-- Shifted second-order correction identity. -/
theorem sum_correction_second_order_shift (s : ℂ) (N n : ℕ) :
    Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emGShift s N 1 x * (((x - k - 1 / 2 : ℝ) : ℂ))) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 n - emGShift s N 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have hterm : ∀ k : ℕ,
      (∫ x in (k:ℝ)..(k+1), emGShift s N 1 x * (((x - k - 1 / 2 : ℝ) : ℂ))) =
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 (k+1) - emGShift s N 1 k) -
          (1 / 2) * ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ) := by
    intro k
    have hderiv : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)),
        HasDerivAt (emGShift s N 1) (emGShift s N 2 x) x := by
      intro x hx
      have hmin : min (k:ℝ) (k+1) = (k:ℝ) := min_eq_left (by linarith)
      have h := hx.1
      rw [hmin] at h
      exact hasDerivAt_emGShift s N 1 (by linarith)
    have hcont : ContinuousOn (emGShift s N 1) (Set.uIcc (k:ℝ) (k+1)) := by
      intro x hx
      have hx0 : (0:ℝ) ≤ x := by
        have h : (k:ℝ) ≤ x := by
          simpa [Set.uIcc_of_le (by linarith : (k:ℝ) ≤ (k:ℝ)+1)] using hx.1
        exact le_trans (by positivity) h
      exact (hasDerivAt_emGShift s N 1 hx0).continuousAt.continuousWithinAt
    have hint1 : IntervalIntegrable (emGShift s N 1) volume (k:ℝ) (k+1) := by
      have hc : ContinuousOn (emGShift s N 1) (Set.Icc (k:ℝ) (k+1)) := by
        intro x hx
        exact (hasDerivAt_emGShift s N 1 (le_trans (by positivity) hx.1)).continuousAt.continuousWithinAt
      exact ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume) (by linarith) hc
    have hint2 : IntervalIntegrable (emGShift s N 2) volume (k:ℝ) (k+1) := by
      have hc : ContinuousOn (emGShift s N 2) (Set.Icc (k:ℝ) (k+1)) := by
        intro x hx
        exact (hasDerivAt_emGShift s N 2 (le_trans (by positivity) hx.1)).continuousAt.continuousWithinAt
      exact ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume) (by linarith) hc
    exact integral_B1_mul_deriv_nat k hderiv hcont hint1 hint2
  calc
    Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emGShift s N 1 x * (((x - k - 1 / 2 : ℝ) : ℂ)))
        = Finset.sum (Finset.range n) (fun k =>
            (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 (k+1) - emGShift s N 1 k) -
              (1 / 2) * ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
          apply Finset.sum_congr rfl
          intro k hk
          exact hterm k
    _ = (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 n - emGShift s N 1 0) -
          (1 / 2) * Finset.sum (Finset.range n) (fun k =>
            ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
          rw [Finset.sum_sub_distrib]
          rw [← Finset.mul_sum, ← Finset.mul_sum]
          rw [sum_range_emGShift_one_sub]



/-- Shifted second-order Euler–Maclaurin finite formula. -/
theorem sum_second_order_shift (s : ℂ) (N n : ℕ) :
    Finset.sum (Finset.range n) (fun k => emGShift s N 0 k) =
      (∫ x in (0:ℝ)..n, emGShift s N 0 x) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 n - emGShift s N 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        (emGShift s N 0 n - emGShift s N 0 0) / 2 := by
  rw [sum_tail_first_order s N n]
  rw [show (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
        (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) =
      (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
        emGShift s N 1 x * (((x - k - 1 / 2 : ℝ) : ℂ))) by
    funext k
    congr 1
    ext x
    ring]
  rw [sum_correction_second_order_shift s N n]
  ring



/-- The shifted first-derivative tower tends to zero for `Re s > 1`. -/
theorem tendsto_emGShift_one_zero {s : ℂ} (hs : 1 < s.re) (N : ℕ) :
    Tendsto (fun n : ℕ => emGShift s N 1 n) atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hle : ∀ n : ℕ, ‖emGShift s N 1 n‖ ≤ ‖s‖ * ((n:ℝ) + 1) ^ (-s.re - 1) := by
    intro n
    rw [norm_emGShift s N 1 (by positivity)]
    norm_num [descPochhammer]
    have hbase : (n:ℝ) + 1 ≤ (n:ℝ) + (N:ℝ) + 1 := by
      have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
      linarith
    have hexp : -s.re - 1 ≤ 0 := by linarith
    have hpow : ((n:ℝ) + (N:ℝ) + 1) ^ (-s.re - 1) ≤ ((n:ℝ) + 1) ^ (-s.re - 1) :=
      Real.rpow_le_rpow_of_nonpos (by positivity) hbase hexp
    exact mul_le_mul_of_nonneg_left hpow (norm_nonneg s)
  have hg : Tendsto (fun n : ℕ => ‖s‖ * ((n:ℝ) + 1) ^ (-s.re - 1)) atTop (𝓝 0) := by
    have h := tendsto_shifted_rpow_zero (σ := s.re + 2) (by linarith)
    simpa [show (1:ℝ) - (s.re + 2) = -s.re - 1 by ring] using h.const_mul ‖s‖
  exact squeeze_zero (fun n => norm_nonneg _) hle hg



/-- The `1/12` boundary term as the first Bernoulli coefficient. -/
theorem c1_emGShift_one_zero (s : ℂ) (N : ℕ) :
    (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emGShift s N 1 0) =
      (1 / 12 : ℂ) * s * ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1))) := by
  have hBR : (BR 2).eval 0 = (1 / 6 : ℝ) := by
    rw [BR_eval_zero]
    norm_num [_root_.bernoulli_two]
  rw [hBR]
  simp [emGShift, descPochhammer]
  ring



/-- Difference form of the `K = 1` general expression. -/
theorem zetaEMGen_one_sub_base (N : ℕ) (s : ℂ) :
    zetaEMGen 1 N s - zetaBase N s =
      (1 / 12 : ℂ) * s * ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1))) := by
  rw [zetaEMGen_one]
  ring





/-- Summability of the shifted `B₂` correction series. -/
theorem summable_B2_shift (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    Summable (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
      emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have hw : Summable (fun k : ℕ => ((k + (N:ℝ) + 1) ^ (-s.re - 2))) := by
    have h := summable_tail_rpow (σ := s.re + 1) (by linarith) N
    convert h using 1
    ext k
    ring
  have hmaj := hw.mul_left
    (((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 * (2 * (riemannZeta (2:ℂ)).re)) *
      ‖(descPochhammer ℂ 2).eval (-s)‖)
  have hbound : ∀ k : ℕ,
      ‖∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)‖ ≤
      (((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 * (2 * (riemannZeta (2:ℂ)).re)) *
        ‖(descPochhammer ℂ 2).eval (-s)‖) * ((k + (N:ℝ) + 1) ^ (-s.re - 2)) := by
    intro k
    simpa [mul_comm] using
      norm_integral_bernoulli_mul_emGShift_le 2 2 N k (by norm_num) s (le_of_lt hs)
  exact hmaj.of_norm_bounded hbound



/-- Convergence of the shifted `B₂` correction partial sums. -/
theorem tendsto_sum_B2_shift (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    Tendsto (fun n : ℕ => Finset.sum (Finset.range n) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) :=
  (summable_B2_shift s N hs).hasSum.tendsto_sum_nat



set_option maxHeartbeats 800000 in
/-- Bridge between the first-order and `B₂` correction series. -/
theorem tsum_correction_first_eq (s : ℂ) (N : ℕ) (hs : 1 < s.re) :
    (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emGShift s N 1 0) -
        (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have hI : Tendsto (fun n : ℕ => ∫ x in (0:ℝ)..n, emGShift s N 0 x) atTop
      (𝓝 ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1))) := by
    simpa [emGShift, descPochhammer] using tendsto_integral_tail_cpow hs N
  have hE1 := tendsto_emGShift_one_zero hs N
  have hE0 := tendsto_emGShift_zero hs N
  have hB := tendsto_sum_B2_shift s N (by linarith : 0 < s.re)
  have h1 := hE1.sub_const (emGShift s N 1 0)
  have h2 := h1.const_mul ((((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2))
  have h3 := hB.const_mul (1 / 2)
  have h4 := (hE0.sub_const (emGShift s N 0 0)).div_const 2
  have hR : Tendsto (fun n : ℕ =>
      (∫ x in (0:ℝ)..n, emGShift s N 0 x) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 n - emGShift s N 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        (emGShift s N 0 n - emGShift s N 0 0) / 2) atTop
      (𝓝 (((((N:ℝ) + 1 : ℝ) : ℂ) ^ (1 - s) / (s - 1)) +
        (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emGShift s N 1 0) -
        (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) -
        (0 - emGShift s N 0 0) / 2)) :=
    ((hI.add h2).sub h3).sub h4
  have hR' := hR.congr' (Filter.Eventually.of_forall (fun n =>
    (sum_second_order_shift s N n).symm))
  have h96 := tendsto_sum_tail hs N
  have huniq := tendsto_nhds_unique h96 hR'
  linear_combination huniq





/-- `zetaEM` equals the `K=1` general expression minus the `B₂` remainder. -/
theorem zetaEM_eq_gen_one (N : ℕ) (s : ℂ) (hs : 1 < s.re) :
    zetaEM N s = zetaEMGen 1 N s -
      (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEM_eq_base_add]
  rw [tsum_correction_first_eq s N hs]
  rw [c1_emGShift_one_zero]
  rw [show zetaBase N s +
        ((1 / 12 : ℂ) * s * ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1))) -
          (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
            emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) =
      (zetaBase N s + (1 / 12 : ℂ) * s * ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1)))) -
        (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) by ring]
  rw [← zetaEMGen_one]



/-- Remainder of the general-`K` expansion. -/
noncomputable def zetaEMRemainder (K N : ℕ) (s : ℂ) : ℂ :=
  zetaEM N s - zetaEMGen K N s

/-- `K = 0` remainder is the first-order correction. -/
theorem zetaEMRemainder_zero (N : ℕ) (s : ℂ) :
    zetaEMRemainder 0 N s =
      (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) := by
  rw [zetaEMRemainder, zetaEMGen_zero, zetaEM_eq_base_add]
  ring

/-- `K = 1` remainder is minus half the `B₂` series. -/
theorem zetaEMRemainder_one (N : ℕ) (s : ℂ) (hs : 1 < s.re) :
    zetaEMRemainder 1 N s =
      - (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEMRemainder]
  rw [zetaEM_eq_gen_one N s hs]
  ring



/-- Algebraic recurrence of the general-`K` remainder. -/
theorem zetaEMRemainder_succ (K N : ℕ) (s : ℂ) :
    zetaEMRemainder (K + 1) N s =
      zetaEMRemainder K N s +
        ((emCoef (K + 1) : ℂ) * emGShift s N (2 * (K + 1) - 1) 0) := by
  rw [zetaEMRemainder]
  rw [zetaEMGen_succ]
  rw [zetaEMRemainder]
  ring



theorem BR_eval_zero_three : (BR 3).eval 0 = (0 : ℝ) := by
  rw [BR_eval_zero]
  norm_num [_root_.bernoulli_eq_zero_of_odd (by decide : Odd 3) (by norm_num : 1 < 3)]

theorem BR_eval_zero_four : (BR 4).eval 0 = (-1 / 30 : ℝ) := by
  rw [BR_eval_zero]
  norm_num [show _root_.bernoulli 4 = (-1 / 30 : ℚ) by decide +kernel]



theorem BR_eval_one_three : (BR 3).eval 1 = (0 : ℝ) := by
  rw [BR_eval_one_eq_zero (n := 2) (by norm_num), BR_eval_zero_three]



theorem hasDerivAt_BR_three (x : ℝ) :
    HasDerivAt (fun y : ℝ => (BR 3).eval y) (3 * (BR 2).eval x) x := by
  have h := Polynomial.hasDerivAt (p := BR 3) (x := x)
  rw [BR_derivative 2] at h
  simpa [Polynomial.eval_smul, smul_eq_mul] using h



theorem hasDerivAt_BR_three_shift (k : ℤ) (x : ℝ) :
    HasDerivAt (fun y : ℝ => (((BR 3).eval (y - k) : ℝ) : ℂ))
      (((3 * (BR 2).eval (x - k) : ℝ)) : ℂ) x := by
  have hinner : HasDerivAt (fun y : ℝ => y - (k:ℝ)) 1 x :=
    (hasDerivAt_id x).sub_const (k:ℝ)
  have houter := (hasDerivAt_BR_three (x - (k:ℝ))).comp x hinner
  simpa [Function.comp_def, mul_one] using houter.ofReal_comp





set_option maxHeartbeats 800000 in
/-- Integration by parts with weight `B₂`. -/
theorem integral_B2_mul_eq (k : ℤ) {f f' : ℝ → ℂ}
    (hf : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hfi : IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    (∫ x in (k:ℝ)..(k+1), ((((BR 2).eval (x - k) : ℝ) : ℂ)) * f x) =
      - (1 / 3) * ∫ x in (k:ℝ)..(k+1),
        ((((BR 3).eval (x - k) : ℝ) : ℂ)) * f' x := by
  have hcont3 : Continuous (fun x : ℝ => ((((BR 3).eval (x - k) : ℝ) : ℂ))) :=
    Complex.continuous_ofReal.comp
      ((Polynomial.continuous (BR 3)).comp (continuous_id.sub continuous_const))
  have hcont2 : Continuous (fun x : ℝ => ((((3 * (BR 2).eval (x - k) : ℝ)) : ℂ))) :=
    Complex.continuous_ofReal.comp
      (((Polynomial.continuous (BR 2)).const_mul 3).comp (continuous_id.sub continuous_const))
  have hu : ContinuousOn (fun x : ℝ => ((((BR 3).eval (x - k) : ℝ) : ℂ)))
      (Set.uIcc (k:ℝ) (k+1)) := hcont3.continuousOn
  have huu' : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)),
      HasDerivAt (fun y : ℝ => ((((BR 3).eval (y - k) : ℝ) : ℂ)))
        ((((3 * (BR 2).eval (x - k) : ℝ)) : ℂ)) x :=
    fun x _ => hasDerivAt_BR_three_shift k x
  have hu'int : IntervalIntegrable (fun x : ℝ => ((((3 * (BR 2).eval (x - k) : ℝ)) : ℂ)))
      volume (k:ℝ) (k+1) := hcont2.intervalIntegrable _ _
  have hip := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := fun x : ℝ => ((((BR 3).eval (x - k) : ℝ) : ℂ)))
    (v := f) (u' := fun x : ℝ => ((((3 * (BR 2).eval (x - k) : ℝ)) : ℂ))) (v' := f')
    (a := (k:ℝ)) (b := ((k:ℝ)+1)) hu hfc huu' hf hu'int hfi
  have hb1 : ((((BR 3).eval (((k:ℝ)+1) - k) : ℝ) : ℂ)) = 0 := by
    rw [show ((k:ℝ)+1) - k = 1 by ring, BR_eval_one_three]
    norm_num
  have hb0 : ((((BR 3).eval ((k:ℝ) - k) : ℝ) : ℂ)) = 0 := by
    rw [show (k:ℝ) - k = 0 by ring, BR_eval_zero_three]
    norm_num
  rw [hb1, hb0] at hip
  simp at hip
  simp only [mul_assoc] at hip
  rw [show (∫ x in (k:ℝ)..(k+1), (3:ℂ) * ((((BR 2).eval (x - k) : ℝ) : ℂ) * f x))
      = (3:ℂ) * ∫ x in (k:ℝ)..(k+1), ((((BR 2).eval (x - k) : ℝ) : ℂ) * f x) by
        rw [intervalIntegral.integral_const_mul]] at hip
  rw [hip]
  ring



theorem hasDerivAt_BR_four_shift (k : ℤ) (x : ℝ) :
    HasDerivAt (fun y : ℝ => (((BR 4).eval (y - k) : ℝ) : ℂ))
      (((4 * (BR 3).eval (x - k) : ℝ)) : ℂ) x := by
  have hpoly : HasDerivAt (fun y : ℝ => (BR 4).eval y) (4 * (BR 3).eval (x - k)) (x - k) := by
    have h := Polynomial.hasDerivAt (p := BR 4) (x := x - (k:ℝ))
    rw [BR_derivative 3] at h
    simpa [Polynomial.eval_smul, smul_eq_mul] using h
  have hinner : HasDerivAt (fun y : ℝ => y - (k:ℝ)) 1 x :=
    (hasDerivAt_id x).sub_const (k:ℝ)
  have houter := hpoly.comp x hinner
  simpa [Function.comp_def, mul_one] using houter.ofReal_comp



theorem BR_eval_one_four : (BR 4).eval 1 = (-1 / 30 : ℝ) := by
  rw [BR_eval_eq_bernoulliFun]
  rw [bernoulliFun_endpoints_eq_of_ne_one (by norm_num : (4:ℕ) ≠ 1)]
  rw [← BR_eval_eq_bernoulliFun]
  exact BR_eval_zero_four



set_option maxHeartbeats 800000 in
/-- Integration by parts with weight `B₃`. -/
theorem integral_B3_mul_deriv_eq (k : ℤ) {f' f'' : ℝ → ℂ}
    (hf' : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f' (f'' x) x)
    (hf'c : ContinuousOn f' (Set.uIcc (k:ℝ) (k+1)))
    (hf''i : IntervalIntegrable f'' volume (k:ℝ) (k+1)) :
    (∫ x in (k:ℝ)..(k+1), ((((BR 3).eval (x - k) : ℝ) : ℂ)) * f' x) =
      ((((BR 4).eval 0 : ℝ) : ℂ) / 4) * (f' ((k:ℝ)+1) - f' (k:ℝ)) -
        (1 / 4) * ∫ x in (k:ℝ)..(k+1),
          ((((BR 4).eval (x - k) : ℝ) : ℂ)) * f'' x := by
  have hcont4 : Continuous (fun x : ℝ => ((((BR 4).eval (x - k) : ℝ) : ℂ))) :=
    Complex.continuous_ofReal.comp
      ((Polynomial.continuous (BR 4)).comp (continuous_id.sub continuous_const))
  have hcont3 : Continuous (fun x : ℝ => ((((4 * (BR 3).eval (x - k) : ℝ)) : ℂ))) :=
    Complex.continuous_ofReal.comp
      (((Polynomial.continuous (BR 3)).const_mul 4).comp (continuous_id.sub continuous_const))
  have hu : ContinuousOn (fun x : ℝ => ((((BR 4).eval (x - k) : ℝ) : ℂ)))
      (Set.uIcc (k:ℝ) (k+1)) := hcont4.continuousOn
  have huu' : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)),
      HasDerivAt (fun y : ℝ => ((((BR 4).eval (y - k) : ℝ) : ℂ)))
        ((((4 * (BR 3).eval (x - k) : ℝ)) : ℂ)) x :=
    fun x _ => hasDerivAt_BR_four_shift k x
  have hu'int : IntervalIntegrable (fun x : ℝ => ((((4 * (BR 3).eval (x - k) : ℝ)) : ℂ)))
      volume (k:ℝ) (k+1) := hcont3.intervalIntegrable _ _
  have hip := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := fun x : ℝ => ((((BR 4).eval (x - k) : ℝ) : ℂ)))
    (v := f') (u' := fun x : ℝ => ((((4 * (BR 3).eval (x - k) : ℝ)) : ℂ))) (v' := f'')
    (a := (k:ℝ)) (b := ((k:ℝ)+1)) hu hf'c huu' hf' hu'int hf''i
  have hb1 : ((((BR 4).eval (((k:ℝ)+1) - k) : ℝ) : ℂ)) = (((BR 4).eval 0 : ℝ) : ℂ) := by
    rw [show ((k:ℝ)+1) - k = 1 by ring, BR_eval_one_four, BR_eval_zero_four]
  have hb0 : ((((BR 4).eval ((k:ℝ) - k) : ℝ) : ℂ)) = (((BR 4).eval 0 : ℝ) : ℂ) := by
    rw [show (k:ℝ) - k = 0 by ring]
  rw [hb1, hb0] at hip
  simp at hip
  have hfac : (fun x : ℝ => (4:ℂ) * ((((BR 3).eval (x - k) : ℝ) : ℂ)) * f' x) =
      (fun x : ℝ => (4:ℂ) * ((((BR 3).eval (x - k) : ℝ) : ℂ) * f' x)) := by
    funext x
    ring
  rw [hfac, intervalIntegral.integral_const_mul] at hip
  rw [hip]
  ring



theorem BR_eval_one_eq_eval_zero_of_ne_one {n : ℕ} (hn : n ≠ 1) :
    (BR n).eval 1 = (BR n).eval 0 := by
  rw [BR_eval_eq_bernoulliFun, bernoulliFun_endpoints_eq_of_ne_one hn,
    ← BR_eval_eq_bernoulliFun]



theorem hasDerivAt_BR_succ_shift (n : ℕ) (k : ℤ) (x : ℝ) :
    HasDerivAt (fun y : ℝ => (((BR (n + 1)).eval (y - k) : ℝ) : ℂ))
      (((((n + 1 : ℕ) : ℝ) * (BR n).eval (x - k) : ℝ)) : ℂ) x := by
  have hpoly : HasDerivAt (fun y : ℝ => (BR (n + 1)).eval y)
      (((n + 1 : ℕ) : ℝ) * (BR n).eval (x - k)) (x - (k:ℝ)) := by
    have h := Polynomial.hasDerivAt (p := BR (n + 1)) (x := x - (k:ℝ))
    rw [BR_derivative n] at h
    simpa [Polynomial.eval_smul, smul_eq_mul] using h
  have hinner : HasDerivAt (fun y : ℝ => y - (k:ℝ)) 1 x :=
    (hasDerivAt_id x).sub_const (k:ℝ)
  have houter := hpoly.comp x hinner
  simpa [Function.comp_def, mul_one] using houter.ofReal_comp

set_option maxHeartbeats 800000 in
theorem integral_BR_mul_eq (n : ℕ) (hn : 1 ≤ n) (k : ℤ) {f f' : ℝ → ℂ}
    (hf : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hfi : IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    (∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x) =
      ((((BR (n+1)).eval 0 : ℝ) : ℂ) / ((n + 1 : ℕ) : ℂ)) *
          (f ((k:ℝ)+1) - f (k:ℝ)) -
        (1 / ((n + 1 : ℕ) : ℂ)) *
          (∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
  have hcont : Continuous (fun x : ℝ => ((((BR (n+1)).eval (x - k) : ℝ) : ℂ))) :=
    Complex.continuous_ofReal.comp
      ((Polynomial.continuous (BR (n+1))).comp (continuous_id.sub continuous_const))
  have hcont' : Continuous (fun x : ℝ =>
      (((((n + 1 : ℕ) : ℝ) * (BR n).eval (x - k) : ℝ)) : ℂ)) :=
    Complex.continuous_ofReal.comp
      (((Polynomial.continuous (BR n)).const_mul ((n + 1 : ℕ) : ℝ)).comp
        (continuous_id.sub continuous_const))
  have hu : ContinuousOn (fun x : ℝ => ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)))
      (Set.uIcc (k:ℝ) (k+1)) := hcont.continuousOn
  have huu' : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)),
      HasDerivAt (fun y : ℝ => ((((BR (n+1)).eval (y - k) : ℝ) : ℂ)))
        (((((n + 1 : ℕ) : ℝ) * (BR n).eval (x - k) : ℝ) : ℂ)) x :=
    fun x _ => hasDerivAt_BR_succ_shift n k x
  have hu'int : IntervalIntegrable (fun x : ℝ =>
      (((((n + 1 : ℕ) : ℝ) * (BR n).eval (x - k) : ℝ) : ℂ)))
      volume (k:ℝ) (k+1) := hcont'.intervalIntegrable _ _
  have hip := intervalIntegral.integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := fun x : ℝ => ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)))
    (v := f) (u' := fun x : ℝ => (((((n + 1 : ℕ) : ℝ) * (BR n).eval (x - k) : ℝ) : ℂ)))
    (v' := f') (a := (k:ℝ)) (b := ((k:ℝ)+1)) hu hfc huu' hf hu'int hfi
  have hne : n + 1 ≠ 1 := by omega
  have hb1 : ((((BR (n+1)).eval (((k:ℝ)+1) - k) : ℝ) : ℂ)) =
      (((BR (n+1)).eval 0 : ℝ) : ℂ) := by
    rw [show ((k:ℝ)+1) - k = 1 by ring]
    congr 1
    exact BR_eval_one_eq_eval_zero_of_ne_one hne
  have hb0 : ((((BR (n+1)).eval ((k:ℝ) - k) : ℝ) : ℂ)) =
      (((BR (n+1)).eval 0 : ℝ) : ℂ) := by
    rw [show (k:ℝ) - k = 0 by ring]
  rw [hb1, hb0] at hip
  simp at hip
  have hfac : (fun x : ℝ => (((n : ℂ) + 1) *
        (((((BR n).eval (x - k) : ℝ) : ℂ))) * f x)) =
      (fun x : ℝ => (((n : ℂ) + 1)) *
        (((((BR n).eval (x - k) : ℝ) : ℂ)) * f x)) := by
    funext x
    ring
  rw [hfac, intervalIntegral.integral_const_mul] at hip
  rw [hip]
  have hn0 : ((n : ℂ) + 1) ≠ 0 := by
    have hcast : (n : ℂ) + 1 = ((n + 1 : ℕ) : ℂ) := by push_cast; ring
    rw [hcast]
    exact_mod_cast Nat.succ_ne_zero n
  field_simp [hn0]
  set I : ℂ := ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x
  push_cast
  ring

set_option maxHeartbeats 800000 in
theorem sum_integral_BR_mul_eq (n : ℕ) (hn : 1 ≤ n) (m : ℕ) {f f' : ℝ → ℂ}
    (hf : ∀ k : ℕ, ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ∀ k : ℕ, ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hfi : ∀ k : ℕ, IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x) =
      ((((BR (n+1)).eval 0 : ℝ) : ℂ) / ((n + 1 : ℕ) : ℂ)) *
          (f (m:ℝ) - f 0) -
        (1 / ((n + 1 : ℕ) : ℂ)) * Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
  have hterm : ∀ k : ℕ,
      (∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x) =
        ((((BR (n+1)).eval 0 : ℝ) : ℂ) / ((n + 1 : ℕ) : ℂ)) *
            (f ((k:ℝ)+1) - f (k:ℝ)) -
          (1 / ((n + 1 : ℕ) : ℂ)) *
            (∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) :=
    fun k => integral_BR_mul_eq n hn k (hf k) (hfc k) (hfi k)
  calc
    Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x)
        = Finset.sum (Finset.range m) (fun k =>
            ((((BR (n+1)).eval 0 : ℝ) : ℂ) / ((n + 1 : ℕ) : ℂ)) *
                (f ((k:ℝ)+1) - f (k:ℝ)) -
              (1 / ((n + 1 : ℕ) : ℂ)) *
                (∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x)) := by
          apply Finset.sum_congr rfl
          intro k hk
          exact hterm k
    _ = ((((BR (n+1)).eval 0 : ℝ) : ℂ) / ((n + 1 : ℕ) : ℂ)) *
          (Finset.sum (Finset.range m) (fun k => (f ((k:ℝ)+1) - f (k:ℝ)))) -
        (1 / ((n + 1 : ℕ) : ℂ)) * Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
          rw [Finset.sum_sub_distrib, Finset.mul_sum, Finset.mul_sum]
    _ = ((((BR (n+1)).eval 0 : ℝ) : ℂ) / ((n + 1 : ℕ) : ℂ)) *
          (f (m:ℝ) - f 0) -
        (1 / ((n + 1 : ℕ) : ℂ)) * Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
          rw [show Finset.sum (Finset.range m) (fun k => (f ((k:ℝ)+1) - f (k:ℝ))) =
              f (m:ℝ) - f 0 by
            simpa [Nat.cast_add, Nat.cast_one] using
              (Finset.sum_range_sub (fun k : ℕ => f (k:ℝ)) m)]

theorem continuousOn_emGShift (s : ℂ) (N j k : ℕ) :
    ContinuousOn (fun x : ℝ => emGShift s N j x) (Set.uIcc (k:ℝ) (k+1)) := by
  intro x hx
  have hx0 : (0:ℝ) ≤ x := by
    have h : (k:ℝ) ≤ x := by
      simpa [Set.uIcc_of_le (by linarith : (k:ℝ) ≤ (k:ℝ)+1)] using hx.1
    exact le_trans (by positivity) h
  exact (hasDerivAt_emGShift s N j hx0).continuousAt.continuousWithinAt

theorem intervalIntegrable_emGShift (s : ℂ) (N j k : ℕ) :
    IntervalIntegrable (fun x : ℝ => emGShift s N j x) volume (k:ℝ) (k+1) := by
  apply ContinuousOn.intervalIntegrable_of_Icc (μ := MeasureTheory.volume) (by linarith)
  intro x hx
  exact (hasDerivAt_emGShift s N j (le_trans (by positivity) hx.1)).continuousAt.continuousWithinAt

set_option maxHeartbeats 800000 in
theorem sum_B2_eq_sum_B4 (s : ℂ) (N m : ℕ) :
    Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) =
      (1 / 360 : ℂ) * (emGShift s N 3 (m:ℝ) - emGShift s N 3 0) +
        (1 / 12 : ℂ) * Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)) := by
  have hderiv : ∀ (j : ℕ) (k : ℕ) (x : ℝ),
      x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)) →
      HasDerivAt (fun y : ℝ => emGShift s N j y) (emGShift s N (j+1) x) x := by
    intro j k x hx
    have hx0 : (0:ℝ) ≤ x := by
      have h : (k:ℝ) ≤ x := by
        have hmin : min (k:ℝ) (k+1) = (k:ℝ) := min_eq_left (by linarith)
        simpa [hmin] using (le_of_lt hx.1)
      exact le_trans (by positivity) h
    exact hasDerivAt_emGShift s N j hx0
  have h1 := sum_integral_BR_mul_eq 2 (by norm_num) m
    (f := fun x => emGShift s N 2 x) (f' := fun x => emGShift s N 3 x)
    (fun k => hderiv 2 k) (fun k => continuousOn_emGShift s N 2 k)
    (fun k => intervalIntegrable_emGShift s N 3 k)
  have h2 := sum_integral_BR_mul_eq 3 (by norm_num) m
    (f := fun x => emGShift s N 3 x) (f' := fun x => emGShift s N 4 x)
    (fun k => hderiv 3 k) (fun k => continuousOn_emGShift s N 3 k)
    (fun k => intervalIntegrable_emGShift s N 4 k)
  rw [BR_eval_zero_three] at h1
  simp at h1
  rw [BR_eval_zero_four] at h2
  rw [show (Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) =
      (Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((BR 2).eval (x - k) : ℝ) : ℂ) * emGShift s N 2 x)) by
    apply Finset.sum_congr rfl
    intro k hk
    congr 1
    ext x
    ring]
  rw [show (Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ))) =
      (Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((BR 4).eval (x - k) : ℝ) : ℂ) * emGShift s N 4 x)) by
    apply Finset.sum_congr rfl
    intro k hk
    congr 1
    ext x
    ring]
  rw [h1, h2]
  norm_num
  ring

theorem tendsto_emGShift_zero_general {s : ℂ} (hs : 1 < s.re) (N j : ℕ) :
    Tendsto (fun n : ℕ => emGShift s N j n) atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hle : ∀ n : ℕ, ‖emGShift s N j n‖ ≤
      ‖(descPochhammer ℂ j).eval (-s)‖ * ((n:ℝ) + 1) ^ (-s.re - j) := by
    intro n
    rw [norm_emGShift s N j (by positivity)]
    have hbase : (n:ℝ) + 1 ≤ (n:ℝ) + (N:ℝ) + 1 := by
      have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
      linarith
    have hexp : -s.re - j ≤ 0 := by
      have : (0:ℝ) ≤ j := by positivity
      linarith
    have hpow : ((n:ℝ) + (N:ℝ) + 1) ^ (-s.re - j) ≤ ((n:ℝ) + 1) ^ (-s.re - j) :=
      Real.rpow_le_rpow_of_nonpos (by positivity) hbase hexp
    exact mul_le_mul_of_nonneg_left hpow (norm_nonneg _)
  have hg : Tendsto (fun n : ℕ =>
      ‖(descPochhammer ℂ j).eval (-s)‖ * ((n:ℝ) + 1) ^ (-s.re - j)) atTop (𝓝 0) := by
    have h := tendsto_shifted_rpow_zero (σ := s.re + j + 1) (by linarith)
    simpa [show (1:ℝ) - (s.re + j + 1) = -s.re - j by ring] using
      h.const_mul ‖(descPochhammer ℂ j).eval (-s)‖
  exact squeeze_zero (fun n => norm_nonneg _) hle hg

theorem summable_B4_shift (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    Summable (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
      emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)) := by
  have hw : Summable (fun k : ℕ => ((k + (N:ℝ) + 1) ^ (-s.re - 4))) := by
    have h := summable_tail_rpow (σ := s.re + 3) (by linarith) N
    convert h using 1
    ext k
    ring
  have hmaj := hw.mul_left
    (((Nat.factorial 4 : ℝ) / (2 * Real.pi) ^ 4 * (2 * (riemannZeta (4:ℂ)).re)) *
      ‖(descPochhammer ℂ 4).eval (-s)‖)
  have hbound : ∀ k : ℕ,
      ‖∫ x in (k:ℝ)..(k+1), emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)‖ ≤
      (((Nat.factorial 4 : ℝ) / (2 * Real.pi) ^ 4 * (2 * (riemannZeta (4:ℂ)).re)) *
        ‖(descPochhammer ℂ 4).eval (-s)‖) * ((k + (N:ℝ) + 1) ^ (-s.re - 4)) := by
    intro k
    simpa [mul_comm] using
      norm_integral_bernoulli_mul_emGShift_le 4 4 N k (by norm_num) s (le_of_lt hs)
  exact hmaj.of_norm_bounded hbound

theorem tendsto_sum_B4_shift (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    Tendsto (fun m : ℕ => Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ))) :=
  (summable_B4_shift s N hs).hasSum.tendsto_sum_nat

set_option maxHeartbeats 800000 in
theorem tsum_B2_eq_B4 (s : ℂ) (N : ℕ) (hs : 1 < s.re) :
    (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) =
      (1 / 360 : ℂ) * (0 - emGShift s N 3 0) +
        (1 / 12 : ℂ) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)) := by
  have h3 := tendsto_emGShift_zero_general (j := 3) hs N
  have h4 := tendsto_sum_B4_shift s N (by linarith)
  have hR : Tendsto (fun m : ℕ =>
      (1 / 360 : ℂ) * (emGShift s N 3 (m:ℝ) - emGShift s N 3 0) +
        (1 / 12 : ℂ) * Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 ((1 / 360 : ℂ) * (0 - emGShift s N 3 0) +
        (1 / 12 : ℂ) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)))) :=
    ((h3.sub_const (emGShift s N 3 0)).const_mul (1 / 360 : ℂ)).add
      (h4.const_mul (1 / 12 : ℂ))
  have hR' := hR.congr' (Filter.Eventually.of_forall (fun m =>
    (sum_B2_eq_sum_B4 s N m).symm))
  have h2 := tendsto_sum_B2_shift s N (by linarith)
  exact tendsto_nhds_unique h2 hR'

/-- Closed form of the `K=1` remainder. -/
theorem zetaEMRemainder_one_eq (N : ℕ) (s : ℂ) (hs : 1 < s.re) :
    zetaEMRemainder 1 N s =
      (1 / 720 : ℂ) * emGShift s N 3 0 -
        (1 / 24 : ℂ) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEMRemainder_one N s hs, tsum_B2_eq_B4 s N hs]
  ring

/-- Closed form of the `K=2` remainder. -/
theorem zetaEMRemainder_two_eq (N : ℕ) (s : ℂ) (hs : 1 < s.re) :
    zetaEMRemainder 2 N s =
      - (1 / 24 : ℂ) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 4 x * (((BR 4).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEMRemainder_succ 1 N s, zetaEMRemainder_one_eq N s hs, emCoef_two]
  norm_num
  ring

theorem BR_eval_zero_odd {n : ℕ} (hn : Odd n) (h1 : 1 < n) :
    (BR n).eval 0 = (0 : ℝ) := by
  rw [BR_eval_zero]
  norm_num [_root_.bernoulli_eq_zero_of_odd hn h1]

theorem emCoef_three : emCoef 3 = (1 / 30240 : ℝ) := by
  simp [emCoef, show _root_.bernoulli 6 = (1 / 42 : ℚ) by decide +kernel]
  norm_num

theorem integral_BR_mul_eq_mul (n : ℕ) (hn : 1 ≤ n) (k : ℤ) {f f' : ℝ → ℂ}
    (hf : ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hfi : IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    ((n + 1 : ℕ) : ℂ) * (∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x) =
      ((((BR (n+1)).eval 0 : ℝ) : ℂ)) * (f ((k:ℝ)+1) - f (k:ℝ)) -
        (∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
  have h := integral_BR_mul_eq n hn k hf hfc hfi
  rw [h]
  have hn0 : ((n + 1 : ℕ) : ℂ) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero n
  field_simp [hn0]

set_option maxHeartbeats 800000 in
theorem sum_integral_BR_mul_eq_mul (n : ℕ) (hn : 1 ≤ n) (m : ℕ) {f f' : ℝ → ℂ}
    (hf : ∀ k : ℕ, ∀ x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)), HasDerivAt f (f' x) x)
    (hfc : ∀ k : ℕ, ContinuousOn f (Set.uIcc (k:ℝ) (k+1)))
    (hfi : ∀ k : ℕ, IntervalIntegrable f' volume (k:ℝ) (k+1)) :
    ((n + 1 : ℕ) : ℂ) * Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x) =
      ((((BR (n+1)).eval 0 : ℝ) : ℂ)) * (f (m:ℝ) - f 0) -
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
  have hterm : ∀ k : ℕ,
      ((n + 1 : ℕ) : ℂ) * (∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x) =
        ((((BR (n+1)).eval 0 : ℝ) : ℂ)) * (f ((k:ℝ)+1) - f (k:ℝ)) -
          (∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) :=
    fun k => integral_BR_mul_eq_mul n hn k (hf k) (hfc k) (hfi k)
  calc
    ((n + 1 : ℕ) : ℂ) * Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x)
        = Finset.sum (Finset.range m) (fun k =>
            ((n + 1 : ℕ) : ℂ) * (∫ x in (k:ℝ)..(k+1), ((((BR n).eval (x - k) : ℝ) : ℂ)) * f x)) := by
          rw [Finset.mul_sum]
    _ = Finset.sum (Finset.range m) (fun k =>
          ((((BR (n+1)).eval 0 : ℝ) : ℂ)) * (f ((k:ℝ)+1) - f (k:ℝ)) -
            (∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x)) := by
          apply Finset.sum_congr rfl
          intro k hk
          exact hterm k
    _ = ((((BR (n+1)).eval 0 : ℝ) : ℂ)) * (f (m:ℝ) - f 0) -
          Finset.sum (Finset.range m) (fun k =>
            ∫ x in (k:ℝ)..(k+1), ((((BR (n+1)).eval (x - k) : ℝ) : ℂ)) * f' x) := by
          rw [Finset.sum_sub_distrib]
          have htel : Finset.sum (Finset.range m) (fun k => f ((k:ℝ)+1) - f (k:ℝ)) =
              f (m:ℝ) - f 0 := by
            simpa [Nat.cast_add, Nat.cast_one] using
              (Finset.sum_range_sub (fun k : ℕ => f (k:ℝ)) m)
          rw [← Finset.mul_sum, htel]

set_option maxHeartbeats 800000 in
theorem sum_B_even_eq_mul (K N m : ℕ) (hK : 1 ≤ K) :
    ((((2*K+1 : ℕ) : ℂ) * ((2*K+2 : ℕ) : ℂ)) *
      Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ))) =
      - (((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (emGShift s N (2*K+1) (m:ℝ) - emGShift s N (2*K+1) 0) +
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N (2*K+2) x * (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ)) := by
  push_cast
  have hderiv : ∀ (j : ℕ) (k : ℕ) (x : ℝ),
      x ∈ Set.Ioo (min (k:ℝ) (k+1)) (max (k:ℝ) (k+1)) →
      HasDerivAt (fun y : ℝ => emGShift s N j y) (emGShift s N (j+1) x) x := by
    intro j k x hx
    have hx0 : (0:ℝ) ≤ x := by
      have h : (k:ℝ) ≤ x := by
        have hmin : min (k:ℝ) (k+1) = (k:ℝ) := min_eq_left (by linarith)
        simpa [hmin] using (le_of_lt hx.1)
      exact le_trans (by positivity) h
    exact hasDerivAt_emGShift s N j hx0
  have h1 := sum_integral_BR_mul_eq_mul (2*K) (by omega) m
    (f := fun x => emGShift s N (2*K) x) (f' := fun x => emGShift s N (2*K+1) x)
    (fun k => hderiv (2*K) k) (fun k => continuousOn_emGShift s N (2*K) k)
    (fun k => intervalIntegrable_emGShift s N (2*K+1) k)
  have h2 := sum_integral_BR_mul_eq_mul (2*K+1) (by omega) m
    (f := fun x => emGShift s N (2*K+1) x) (f' := fun x => emGShift s N (2*K+2) x)
    (fun k => hderiv (2*K+1) k) (fun k => continuousOn_emGShift s N (2*K+1) k)
    (fun k => intervalIntegrable_emGShift s N (2*K+2) k)
  rw [BR_eval_zero_odd (n := 2*K+1) ⟨K, by ring⟩ (by omega)] at h1
  simp at h1
  have hfac : (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
        emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ)) =
      (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
        (((BR (2*K)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K) x) := by
    funext k
    congr 1
    ext x
    ring
  have hfac2 : (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
        emGShift s N (2*K+2) x * (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ)) =
      (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
        (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+2) x) := by
    funext k
    congr 1
    ext x
    ring
  rw [hfac, hfac2]
  have hA : (2*(K:ℂ)+1) * Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((BR (2*K)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K) x) =
      - Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((BR (2*K+1)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+1) x) := by
    rw [h1]
  have hB : (2*(K:ℂ)+2) * Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((BR (2*K+1)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+1) x) =
      (((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (emGShift s N (2*K+1) (m:ℝ) - emGShift s N (2*K+1) 0) -
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+2) x) := by
    convert h2 using 2 <;> push_cast <;> ring
  calc
    ((2*(K:ℂ)+1) * (2*(K:ℂ)+2)) * Finset.sum (Finset.range m) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((BR (2*K)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K) x)
        = (2*(K:ℂ)+2) * ((2*(K:ℂ)+1) * Finset.sum (Finset.range m) (fun k =>
            ∫ x in (k:ℝ)..(k+1), (((BR (2*K)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K) x)) := by ring
    _ = (2*(K:ℂ)+2) * (- Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), (((BR (2*K+1)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+1) x)) := by rw [hA]
    _ = - ((2*(K:ℂ)+2) * Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), (((BR (2*K+1)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+1) x)) := by ring
    _ = - ((((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (emGShift s N (2*K+1) (m:ℝ) - emGShift s N (2*K+1) 0) -
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+2) x)) := by rw [hB]
    _ = - (((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (emGShift s N (2*K+1) (m:ℝ) - emGShift s N (2*K+1) 0) +
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ) * emGShift s N (2*K+2) x) := by ring

theorem summable_Bn_shift (n : ℕ) (hn : 2 ≤ n) (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    Summable (fun k : ℕ => ∫ x in (k:ℝ)..(k+1),
      emGShift s N n x * (((BR n).eval (x - k) : ℝ) : ℂ)) := by
  have hw : Summable (fun k : ℕ => ((k + (N:ℝ) + 1) ^ (-s.re - n))) := by
    have hn2 : (2:ℝ) ≤ n := by exact_mod_cast hn
    have h := summable_tail_rpow (σ := s.re + (n:ℝ) - 1) (by linarith) N
    convert h using 1
    ext k
    ring
  have hmaj := hw.mul_left
    (((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n * (2 * (riemannZeta (n:ℂ)).re)) *
      ‖(descPochhammer ℂ n).eval (-s)‖)
  have hbound : ∀ k : ℕ,
      ‖∫ x in (k:ℝ)..(k+1), emGShift s N n x * (((BR n).eval (x - k) : ℝ) : ℂ)‖ ≤
      (((Nat.factorial n : ℝ) / (2 * Real.pi) ^ n * (2 * (riemannZeta (n:ℂ)).re)) *
        ‖(descPochhammer ℂ n).eval (-s)‖) * ((k + (N:ℝ) + 1) ^ (-s.re - n)) := by
    intro k
    simpa [mul_comm] using
      norm_integral_bernoulli_mul_emGShift_le n n N k hn s (le_of_lt hs)
  exact hmaj.of_norm_bounded hbound

theorem tendsto_sum_Bn_shift (n : ℕ) (hn : 2 ≤ n) (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    Tendsto (fun m : ℕ => Finset.sum (Finset.range m) (fun k =>
      ∫ x in (k:ℝ)..(k+1), emGShift s N n x * (((BR n).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N n x * (((BR n).eval (x - k) : ℝ) : ℂ))) :=
  (summable_Bn_shift n hn s N hs).hasSum.tendsto_sum_nat

set_option maxHeartbeats 800000 in
theorem tsum_B_even_succ (K N : ℕ) (hK : 1 ≤ K) (s : ℂ) (hs : 1 < s.re) :
    (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
      emGShift s N (2*K+2) x * (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ)) =
      (((2*K+1 : ℕ) : ℂ) * ((2*K+2 : ℕ) : ℂ)) *
          (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
            emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ)) -
        (((BR (2*K+2)).eval 0 : ℝ) : ℂ) * emGShift s N (2*K+1) 0 := by
  have h2K := tendsto_sum_Bn_shift (2*K) (by omega) s N (by linarith)
  have h4 := tendsto_sum_Bn_shift (2*K+2) (by omega) s N (by linarith)
  have h3 := tendsto_emGShift_zero_general (j := 2*K+1) hs N
  have hL := h2K.const_mul (((2*K+1 : ℕ) : ℂ) * ((2*K+2 : ℕ) : ℂ))
  have hfun : (fun m : ℕ =>
      - (((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (emGShift s N (2*K+1) (m:ℝ) - emGShift s N (2*K+1) 0) +
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N (2*K+2) x * (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ))) =
      (fun m : ℕ => (((2*K+1 : ℕ) : ℂ) * ((2*K+2 : ℕ) : ℂ)) *
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ))) := by
    funext m
    exact (sum_B_even_eq_mul (s := s) K N m hK).symm
  rw [← hfun] at hL
  have hR : Tendsto (fun m : ℕ =>
      - (((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (emGShift s N (2*K+1) (m:ℝ) - emGShift s N (2*K+1) 0) +
        Finset.sum (Finset.range m) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N (2*K+2) x * (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 (- (((BR (2*K+2)).eval 0 : ℝ) : ℂ) *
          (0 - emGShift s N (2*K+1) 0) +
        (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N (2*K+2) x * (((BR (2*K+2)).eval (x - k) : ℝ) : ℂ)))) :=
    ((h3.sub_const (emGShift s N (2*K+1) 0)).const_mul
      (- (((BR (2*K+2)).eval 0 : ℝ) : ℂ))).add h4
  have huniq := tendsto_nhds_unique hL hR
  linear_combination -huniq

theorem zetaEMRemainder_one_factorial (N : ℕ) (s : ℂ) (hs : 1 < s.re) :
    zetaEMRemainder 1 N s =
      - (1 / ((Nat.factorial 2 : ℝ) : ℂ)) *
        (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEMRemainder_one N s hs]
  norm_num

theorem zetaEMRemainder_succ_even (k N : ℕ) (s : ℂ) :
    zetaEMRemainder (k + 1) N s =
      zetaEMRemainder k N s +
        ((emCoef (k + 1) : ℂ) * emGShift s N (2*k+1) 0) := by
  rw [zetaEMRemainder_succ]
  congr 2

noncomputable def S_even (k N : ℕ) (s : ℂ) : ℂ :=
  ∑' j : ℕ, ∫ x in (j:ℝ)..((j:ℝ)+1),
    emGShift s N (2*k) x * (((BR (2*k)).eval (x - j) : ℝ) : ℂ)

theorem S_even_succ (k N : ℕ) (hk : 1 ≤ k) (s : ℂ) (hs : 1 < s.re) :
    S_even (k+1) N s =
      ((2*(k:ℂ)+1) * (2*(k:ℂ)+2)) * S_even k N s -
        (((BR (2*k+2)).eval 0 : ℝ) : ℂ) * emGShift s N (2*k+1) 0 := by
  simp only [S_even, show 2*(k+1) = 2*k+2 by ring]
  simpa using tsum_B_even_succ k N hk s hs

set_option maxHeartbeats 800000 in
theorem zetaEMRemainder_eq_factorial (K : ℕ) (hK : 1 ≤ K) (N : ℕ) (s : ℂ) (hs : 1 < s.re) :
    zetaEMRemainder K N s =
      - (1 / ((Nat.factorial (2*K) : ℝ) : ℂ)) * S_even K N s := by
  revert N s
  refine Nat.le_induction ?base ?step K hK
  · intro N s hs
    rw [zetaEMRemainder_one_factorial N s hs]
    congr 2
  · intro k hk ih N s hs
    have hem : emCoef (k+1) =
        (((BR (2*k+2)).eval 0 : ℝ) : ℂ) / ((Nat.factorial (2*(k+1)) : ℝ) : ℂ) := by
      simp [emCoef, BR_eval_zero, show 2*(k+1) = 2*k+2 by ring]
    rw [zetaEMRemainder_succ_even k N s, ih N s hs, S_even_succ k N hk s hs, hem]
    have hfac : ((Nat.factorial (2*(k+1)) : ℝ) : ℂ) =
        ((Nat.factorial (2*k) : ℝ) : ℂ) * ((2*k+1 : ℕ) : ℂ) * ((2*k+2 : ℕ) : ℂ) := by
      have h1 : 2*(k+1) = 2*k+2 := by ring
      rw [h1, Nat.factorial_succ, Nat.factorial_succ]
      push_cast
      ring
    rw [hfac]
    have h2k : ((Nat.factorial (2*k) : ℝ) : ℂ) ≠ 0 := by
      exact_mod_cast Nat.factorial_ne_zero (2*k)
    have hD1 : ((2*k+1 : ℕ) : ℂ) ≠ 0 := by exact_mod_cast (by omega : 2*k+1 ≠ 0)
    have hD2 : ((2*k+2 : ℕ) : ℂ) ≠ 0 := by exact_mod_cast (by omega : 2*k+2 ≠ 0)
    field_simp [h2k, hD1, hD2]
    push_cast
    ring

set_option maxHeartbeats 800000 in
theorem norm_S_even_le (K N : ℕ) (hK : 1 ≤ K) (s : ℂ) (hs : 0 < s.re) :
    ‖S_even K N s‖ ≤
      (((Nat.factorial (2*K) : ℝ) / (2 * Real.pi) ^ (2*K) *
          (2 * (riemannZeta ((2*K:ℕ):ℂ)).re)) *
        ‖(descPochhammer ℂ (2*K)).eval (-s)‖) *
        ((((N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) +
          ((((N:ℝ) + 1) ^ (1 - s.re - (2*K:ℕ))) / (s.re + (2*K:ℕ) - 1))) := by
  have hK2 : (2:ℝ) ≤ (2*K:ℕ) := by exact_mod_cast (by omega : 2 ≤ 2*K)
  have hz : 0 ≤ (riemannZeta ((2*K:ℕ):ℂ)).re := zeta_re_nonneg (2*K) (by omega)
  set C : ℝ := ((Nat.factorial (2*K) : ℝ) / (2 * Real.pi) ^ (2*K) *
      (2 * (riemannZeta ((2*K:ℕ):ℂ)).re)) *
      ‖(descPochhammer ℂ (2*K)).eval (-s)‖ with hC
  have hCnonneg : 0 ≤ C := by
    rw [hC]
    positivity
  have hsum := summable_Bn_shift (2*K) (by omega) s N hs
  have hnorm := hsum.norm
  have hterm : ∀ k : ℕ, ‖∫ x in (k:ℝ)..(k+1),
      emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ)‖ ≤
      C * ((k + (N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) := by
    intro k
    have h := norm_integral_bernoulli_mul_emGShift_le (n := 2*K) (j := 2*K) N k (by omega) s (le_of_lt hs)
    simpa [C, hC, mul_comm, mul_assoc, mul_left_comm] using h
  have hCw : Summable (fun k : ℕ => C * ((k + (N:ℝ) + 1) ^ (-s.re - (2*K:ℕ)))) := by
    apply Summable.mul_left
    have hσ0 : 0 < s.re + (2*K:ℕ) - 1 := by linarith
    have h := summable_tail_rpow (σ := s.re + (2*K:ℕ) - 1) hσ0 N
    convert h using 1
    ext k
    ring
  have hσ : 1 < s.re + (2*K:ℕ) := by linarith
  calc
    ‖S_even K N s‖ = ‖∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ)‖ := by rw [S_even]
    _ ≤ ∑' k : ℕ, ‖∫ x in (k:ℝ)..(k+1),
        emGShift s N (2*K) x * (((BR (2*K)).eval (x - k) : ℝ) : ℂ)‖ :=
          norm_tsum_le_tsum_norm hnorm
    _ ≤ ∑' k : ℕ, C * ((k + (N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) :=
          hnorm.tsum_le_tsum hterm hCw
    _ = C * ∑' k : ℕ, ((k + (N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) := tsum_mul_left
    _ ≤ C * ((((N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) +
          ((((N:ℝ) + 1) ^ (1 - s.re - (2*K:ℕ))) / (s.re + (2*K:ℕ) - 1))) := by
          apply mul_le_mul_of_nonneg_left _ hCnonneg
          have h := tsum_shift_rpow_le (σ := s.re + (2*K:ℕ)) hσ N
          convert h using 1
          · congr 1
            ext k
            ring
          · ring

set_option maxHeartbeats 800000 in
theorem norm_zetaEMRemainder_le (K N : ℕ) (hK : 1 ≤ K) (s : ℂ) (hs : 1 < s.re) :
    ‖zetaEMRemainder K N s‖ ≤
      (2 * (riemannZeta ((2*K:ℕ):ℂ)).re / (2 * Real.pi) ^ (2*K)) *
        ‖(descPochhammer ℂ (2*K)).eval (-s)‖ *
        ((((N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) +
          ((((N:ℝ) + 1) ^ (1 - s.re - (2*K:ℕ))) / (s.re + (2*K:ℕ) - 1))) := by
  rw [zetaEMRemainder_eq_factorial K hK N s hs]
  have hcpos : (0:ℝ) < (Nat.factorial (2*K) : ℝ) := by positivity
  have hc : ‖(1 / ((Nat.factorial (2*K) : ℝ) : ℂ))‖ = 1 / (Nat.factorial (2*K) : ℝ) := by
    rw [norm_div, norm_one, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hcpos]
  have h := norm_S_even_le K N hK s (by linarith)
  calc
    ‖- (1 / ((Nat.factorial (2*K) : ℝ) : ℂ)) * S_even K N s‖
        = (1 / (Nat.factorial (2*K) : ℝ)) * ‖S_even K N s‖ := by
          rw [norm_mul, norm_neg, hc]
    _ ≤ (1 / (Nat.factorial (2*K) : ℝ)) *
          (((Nat.factorial (2*K) : ℝ) / (2 * Real.pi) ^ (2*K) *
              (2 * (riemannZeta ((2*K:ℕ):ℂ)).re)) *
            ‖(descPochhammer ℂ (2*K)).eval (-s)‖ *
            ((((N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) +
              ((((N:ℝ) + 1) ^ (1 - s.re - (2*K:ℕ))) / (s.re + (2*K:ℕ) - 1)))) := by
          apply mul_le_mul_of_nonneg_left h
          positivity
    _ = (2 * (riemannZeta ((2*K:ℕ):ℂ)).re / (2 * Real.pi) ^ (2*K)) *
          ‖(descPochhammer ℂ (2*K)).eval (-s)‖ *
          ((((N:ℝ) + 1) ^ (-s.re - (2*K:ℕ))) +
            ((((N:ℝ) + 1) ^ (1 - s.re - (2*K:ℕ))) / (s.re + (2*K:ℕ) - 1))) := by
          field_simp [hcpos.ne']

end FiniteWindowZeros
