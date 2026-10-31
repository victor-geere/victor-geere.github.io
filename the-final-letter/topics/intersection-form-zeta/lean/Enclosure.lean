import Mathlib

/-!
# The analytic enclosure layer — first leaf

This file starts the formalisation of the rational enclosure certificate that
puts the true Weil Gram matrix in the recorded box.  The rational arithmetic
and the box argument are in `Topic.lean`; what is missing there is the
analytic enclosure of `Ω(t) = Re ψ(1/4 + i t/2) - log π` and of the density
integral.

The first prerequisite is the value at `t = 0`.  Mathlib has `ψ(1)` and
`ψ(1/2)` but not `ψ(1/4)`.  The classical value

`ψ(1/4) = -γ - π/2 - 3 log 2`

follows from the duplication formula at `s = 1/4` and the reflection formula:

* duplication: `ψ(1/2) = (ψ(1/4) + ψ(3/4))/2 + log 2`;
* reflection: `ψ(3/4) = ψ(1/4) + π cot(π/4) = ψ(1/4) + π`;
* so `ψ(1/2) = ψ(1/4) + π/2 + log 2`.

This is not yet an enclosure: it is the exact value at one point, and the
rational bounds for `γ`, `π` and `log 2` are still required.
-/

open Complex
open scoped ComplexConjugate
open Filter
open scoped Topology

namespace IntersectionForm

/-- `ψ(1/4) = -γ - π/2 - 3 log 2`. -/
theorem digamma_quarter :
    Complex.digamma (1 / 4 : ℂ) =
      -(Real.eulerMascheroniConstant : ℂ) - (Real.pi : ℂ) / 2
        - 3 * Complex.log 2 := by
  have hdup := Complex.digamma_two_mul (s := (1 / 4 : ℂ)) (by
    intro m hm
    have h := congrArg Complex.re hm
    norm_num at h
    nlinarith [show (0 : ℝ) ≤ (m : ℝ) by positivity])
  have hrefl := Complex.digamma_one_sub (s := (1 / 4 : ℂ)) (by
    intro n hn
    have h := congrArg Complex.re hn
    norm_num at h
    have h' : (n * 4 : ℤ) = 1 := by
      have : (n : ℝ) * 4 = 1 := by linarith
      exact_mod_cast this
    omega)
  have hcot : Complex.cot (Real.pi * (1 / 4 : ℂ)) = 1 := by
    rw [Complex.cot_eq_cos_div_sin]
    rw [show (Real.pi : ℂ) * (1 / 4 : ℂ) = ((Real.pi / 4 : ℝ) : ℂ) by
      push_cast
      ring]
    rw [← Complex.ofReal_cos, ← Complex.ofReal_sin,
      Real.cos_pi_div_four, Real.sin_pi_div_four]
    norm_num
  rw [hcot, mul_one] at hrefl
  have harg : (1 : ℂ) - 1 / 4 = 1 / 4 + 1 / 2 := by norm_num
  rw [harg] at hrefl
  rw [hrefl] at hdup
  have harg2 : (2 * (1 / 4) : ℂ) = 1 / 2 := by norm_num
  rw [harg2, Complex.digamma_one_half] at hdup
  linear_combination -hdup

lemma hasDerivAt_log_one_add (x : ℝ) (hx : 0 ≤ x) :
    HasDerivAt (fun t : ℝ => Real.log (1 + t)) (1 / (1 + x)) x := by
  have h1 : HasDerivAt (fun t : ℝ => (1 + t)) 1 x := by
    exact (hasDerivAt_id x).const_add 1
  exact h1.log (by linarith : (1 + x : ℝ) ≠ 0)

lemma hasDerivAt_quad (x : ℝ) :
    HasDerivAt (fun t : ℝ => t - t ^ 2 / 2) (1 - x) x := by
  have h1 : HasDerivAt (fun t : ℝ => t) 1 x := hasDerivAt_id x
  have h2 : HasDerivAt (fun t : ℝ => t ^ 2 / 2) x x := by
    have h := (hasDerivAt_pow 2 x).div_const 2
    convert h using 1
    norm_num
  exact h1.sub h2

lemma log_one_add_ge (x : ℝ) (hx : 0 ≤ x) :
    x - x ^ 2 / 2 ≤ Real.log (1 + x) := by
  let f : ℝ → ℝ := fun t => Real.log (1 + t) - (t - t ^ 2 / 2)
  have hmono : MonotoneOn f (Set.Ici 0) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0)
    · apply ContinuousOn.sub
      · exact (continuousOn_const.add continuousOn_id).log
          (fun t ht => by
            have ht' : (0 : ℝ) ≤ t := ht
            change (1 + t : ℝ) ≠ 0
            linarith)
      · fun_prop
    · intro t ht
      have ht0 : 0 < t := by simpa using ht
      have h1 : DifferentiableAt ℝ (fun t : ℝ => Real.log (1 + t)) t :=
        (Real.differentiableAt_log (by linarith : (1 + t : ℝ) ≠ 0)).comp t
          ((differentiableAt_const 1).add differentiableAt_id)
      have h2 : DifferentiableAt ℝ (fun t : ℝ => t - t ^ 2 / 2) t := by
        fun_prop
      exact (h1.sub h2).differentiableWithinAt
    · intro t ht
      have ht0 : 0 ≤ t := by
        have : 0 < t := by simpa using ht
        linarith
      have hderiv : deriv f t = t ^ 2 / (1 + t) := by
        have h := (hasDerivAt_log_one_add t ht0).sub (hasDerivAt_quad t)
        change deriv ((fun t : ℝ => Real.log (1 + t)) -
          (fun t : ℝ => t - t ^ 2 / 2)) t = t ^ 2 / (1 + t)
        rw [h.deriv]
        field_simp
        ring
      rw [hderiv]
      positivity
  have h := hmono (Set.mem_Ici.mpr le_rfl) (Set.mem_Ici.mpr hx) hx
  simpa [f] using h


lemma hasDerivAt_cubic (x : ℝ) :
    HasDerivAt (fun t : ℝ => t - t ^ 2 / 2 + t ^ 3 / 3) (1 - x + x ^ 2) x := by
  have h1 := hasDerivAt_quad x
  have h2 : HasDerivAt (fun t : ℝ => t ^ 3 / 3) (x ^ 2) x := by
    have h := (hasDerivAt_pow 3 x).div_const 3
    convert h using 1
    ring
  exact h1.add h2

lemma log_one_add_le (x : ℝ) (hx : 0 ≤ x) :
    Real.log (1 + x) ≤ x - x ^ 2 / 2 + x ^ 3 / 3 := by
  let g : ℝ → ℝ := fun t => t - t ^ 2 / 2 + t ^ 3 / 3 - Real.log (1 + t)
  have hmono : MonotoneOn g (Set.Ici 0) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0)
    · apply ContinuousOn.sub
      · fun_prop
      · exact (continuousOn_const.add continuousOn_id).log
          (fun t ht => by
            have ht' : (0 : ℝ) ≤ t := ht
            change (1 + t : ℝ) ≠ 0
            linarith)
    · intro t ht
      have ht0 : 0 < t := by simpa using ht
      have h1 : DifferentiableAt ℝ (fun t : ℝ => t - t ^ 2 / 2 + t ^ 3 / 3) t := by
        fun_prop
      have h2 : DifferentiableAt ℝ (fun t : ℝ => Real.log (1 + t)) t :=
        (Real.differentiableAt_log (by linarith : (1 + t : ℝ) ≠ 0)).comp t
          ((differentiableAt_const 1).add differentiableAt_id)
      exact (h1.sub h2).differentiableWithinAt
    · intro t ht
      have ht0 : 0 ≤ t := by
        have : 0 < t := by simpa using ht
        linarith
      have hderiv : deriv g t = t ^ 3 / (1 + t) := by
        have h := (hasDerivAt_cubic t).sub (hasDerivAt_log_one_add t ht0)
        change deriv ((fun t : ℝ => t - t ^ 2 / 2 + t ^ 3 / 3) -
          (fun t : ℝ => Real.log (1 + t))) t = t ^ 3 / (1 + t)
        rw [h.deriv]
        field_simp
        ring
      rw [hderiv]
      positivity
  have h := hmono (Set.mem_Ici.mpr le_rfl) (Set.mem_Ici.mpr hx) hx
  simpa [g] using h

noncomputable def gammaLower (n : ℕ) : ℝ :=
  (harmonic n : ℝ) - Real.log n - 1 / (2 * n)

lemma gammaLower_step (n : ℕ) (hn : 1 ≤ n) :
    gammaLower (n + 1) - gammaLower n =
      1 / (n + 1) + 1 / (2 * n * (n + 1)) - Real.log (1 + 1 / n) := by
  have hlog : Real.log ((n : ℝ) + 1) - Real.log n = Real.log (1 + 1 / n) := by
    rw [← Real.log_div (by positivity) (by positivity)]
    congr 1
    field_simp
  unfold gammaLower
  rw [harmonic_succ]
  push_cast
  have hlog' : Real.log ((n : ℝ) + 1) = Real.log n + Real.log (1 + 1 / n) := by
    linarith
  rw [hlog']
  field_simp
  ring

lemma gammaLower_strictMono_step (n : ℕ) (hn : 3 ≤ n) :
    gammaLower n < gammaLower (n + 1) := by
  have hlog := log_one_add_le (1 / (n : ℝ)) (by positivity)
  have hstep := gammaLower_step n (by omega)
  have hbound : 1 / (n + 1) + 1 / (2 * n * (n + 1)) -
      (1 / n - (1 / n) ^ 2 / 2 + (1 / n) ^ 3 / 3)
      = ((n : ℝ) - 2) / (6 * n ^ 3 * (n + 1)) := by
    field_simp
    ring
  have hpos : 0 < ((n : ℝ) - 2) / (6 * n ^ 3 * (n + 1)) := by
    have hn3 : (3 : ℝ) ≤ n := by exact_mod_cast hn
    apply div_pos
    · linarith
    · positivity
  linarith


noncomputable def gammaUpper (n : ℕ) : ℝ :=
  (harmonic n : ℝ) - Real.log n - 1 / (2 * (n + 1))

lemma gammaUpper_step (n : ℕ) (hn : 1 ≤ n) :
    gammaUpper (n + 1) - gammaUpper n =
      1 / (n + 1) + 1 / (2 * (n + 1)) - 1 / (2 * (n + 2))
        - Real.log (1 + 1 / n) := by
  have hlog' : Real.log ((n : ℝ) + 1) = Real.log n + Real.log (1 + 1 / n) := by
    have hlog : Real.log ((n : ℝ) + 1) - Real.log n = Real.log (1 + 1 / n) := by
      rw [← Real.log_div (by positivity) (by positivity)]
      congr 1
      field_simp
    linarith
  unfold gammaUpper
  rw [harmonic_succ]
  push_cast
  rw [hlog']
  field_simp
  ring

lemma gammaUpper_strictAnti_step (n : ℕ) (hn : 3 ≤ n) :
    gammaUpper (n + 1) < gammaUpper n := by
  have hlog := log_one_add_ge (1 / (n : ℝ)) (by positivity)
  have hstep := gammaUpper_step n (by omega)
  have hbound : 1 / (n + 1) + 1 / (2 * (n + 1)) - 1 / (2 * (n + 2)) -
      (1 / n - (1 / n) ^ 2 / 2)
      = -(((n : ℝ) - 2) / (2 * n ^ 2 * (n + 1) * (n + 2))) := by
    field_simp
    ring
  have hpos : 0 < ((n : ℝ) - 2) / (2 * n ^ 2 * (n + 1) * (n + 2)) := by
    have hn3 : (3 : ℝ) ≤ n := by exact_mod_cast hn
    apply div_pos
    · linarith
    · positivity
  linarith

lemma tendsto_one_div_two_mul_nat :
    Tendsto (fun n : ℕ => (1 : ℝ) / (2 * n)) atTop (𝓝 0) := by
  have h2n : Tendsto (fun n : ℕ => (2 * (n : ℝ))) atTop atTop :=
    tendsto_natCast_atTop_atTop.const_mul_atTop (by norm_num : (0 : ℝ) < 2)
  have hinv : Tendsto (fun n : ℕ => ((2 * (n : ℝ)))⁻¹) atTop (𝓝 0) :=
    tendsto_inv_atTop_zero.comp h2n
  simpa [one_div] using hinv

lemma tendsto_gammaLower :
    Tendsto gammaLower atTop (𝓝 Real.eulerMascheroniConstant) := by
  have h := Real.tendsto_harmonic_sub_log.sub tendsto_one_div_two_mul_nat
  convert h using 1
  · ext n
    simp [gammaLower]
  · simp


lemma monotone_gammaLower_shift : Monotone (fun k : ℕ => gammaLower (k + 3)) := by
  apply monotone_nat_of_le_succ
  intro k
  exact (gammaLower_strictMono_step (k + 3) (by omega)).le

lemma tendsto_gammaLower_shift :
    Tendsto (fun k : ℕ => gammaLower (k + 3)) atTop
      (𝓝 Real.eulerMascheroniConstant) :=
  tendsto_gammaLower.comp (tendsto_add_atTop_nat 3)

lemma gammaLower_le_gamma (k : ℕ) :
    gammaLower (k + 3) ≤ Real.eulerMascheroniConstant := by
  refine ge_of_tendsto tendsto_gammaLower_shift ?_
  filter_upwards [eventually_ge_atTop k] with m hm
  exact monotone_gammaLower_shift hm

lemma gammaLower_lt_gamma (k : ℕ) :
    gammaLower (k + 3) < Real.eulerMascheroniConstant := by
  have h1 := gammaLower_strictMono_step (k + 3) (by omega)
  have h2 := gammaLower_le_gamma (k + 1)
  have hidx : k + 1 + 3 = k + 4 := by omega
  rw [hidx] at h2
  exact lt_of_lt_of_le h1 h2


lemma tendsto_one_div_two_mul_add_one_nat :
    Tendsto (fun n : ℕ => (1 : ℝ) / (2 * (n + 1))) atTop (𝓝 0) := by
  have h1 : Tendsto (fun n : ℕ => ((n + 1 : ℕ) : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop.comp (tendsto_add_atTop_nat 1)
  have h2 : Tendsto (fun n : ℕ => (2 * ((n + 1 : ℕ) : ℝ))) atTop atTop :=
    h1.const_mul_atTop (by norm_num : (0 : ℝ) < 2)
  have hinv : Tendsto (fun n : ℕ => ((2 * ((n + 1 : ℕ) : ℝ)))⁻¹) atTop (𝓝 0) :=
    tendsto_inv_atTop_zero.comp h2
  simpa [one_div] using hinv

lemma tendsto_gammaUpper :
    Tendsto gammaUpper atTop (𝓝 Real.eulerMascheroniConstant) := by
  have h := Real.tendsto_harmonic_sub_log.sub tendsto_one_div_two_mul_add_one_nat
  convert h using 1
  · ext n
    simp [gammaUpper]
  · simp

lemma antitone_gammaUpper_shift : Antitone (fun k : ℕ => gammaUpper (k + 3)) := by
  apply antitone_nat_of_succ_le
  intro k
  exact (gammaUpper_strictAnti_step (k + 3) (by omega)).le

lemma tendsto_gammaUpper_shift :
    Tendsto (fun k : ℕ => gammaUpper (k + 3)) atTop
      (𝓝 Real.eulerMascheroniConstant) :=
  tendsto_gammaUpper.comp (tendsto_add_atTop_nat 3)

lemma gammaUpper_ge_gamma (k : ℕ) :
    Real.eulerMascheroniConstant ≤ gammaUpper (k + 3) := by
  refine le_of_tendsto tendsto_gammaUpper_shift ?_
  filter_upwards [eventually_ge_atTop k] with m hm
  exact antitone_gammaUpper_shift hm

lemma gammaUpper_gt_gamma (k : ℕ) :
    Real.eulerMascheroniConstant < gammaUpper (k + 3) := by
  have h1 := gammaUpper_strictAnti_step (k + 3) (by omega)
  have h2 := gammaUpper_ge_gamma (k + 1)
  have hidx : k + 1 + 3 = k + 4 := by omega
  rw [hidx] at h2
  exact lt_of_le_of_lt h2 h1

/-! ## The rational log enclosure

The following five definitions and two theorems are the self-contained core of
`topics/partial-sum-plus-tail/lean/Transcend.lean` (the `log` section).  They
enclose `Real.log x` for rational `x ≥ 1` by a positive-term series plus a
geometric tail.  Copied here so this dossier does not depend on a sibling
`.olean`. -/

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

def logPointLo (N : ℕ) (x : ℚ) : ℚ := logPartialQ N (x - 1)
def logPointHi (N : ℕ) (x : ℚ) : ℚ := logPartialQ N (x - 1) + logRemQ N (x - 1)

theorem logPoint_mem (N : ℕ) {x : ℚ} (hx : 1 ≤ x) :
    (logPointLo N x : ℝ) ≤ Real.log (x : ℝ) ∧
      Real.log (x : ℝ) ≤ (logPointHi N x : ℝ) := by
  constructor
  · simpa [logPointLo] using logPartialQ_le_log hx N
  · simpa [logPointHi] using log_le_logPartialQ_add_rem hx N

def log200Lo (N : ℕ) : ℚ := logPointLo N 2 + 2 * logPointLo N 10
def log200Hi (N : ℕ) : ℚ := logPointHi N 2 + 2 * logPointHi N 10

theorem log200_mem (N : ℕ) :
    (log200Lo N : ℝ) ≤ Real.log 200 ∧ Real.log 200 ≤ (log200Hi N : ℝ) := by
  have h2 := logPoint_mem N (by norm_num : (1 : ℚ) ≤ 2)
  have h10 := logPoint_mem N (by norm_num : (1 : ℚ) ≤ 10)
  have h200 : Real.log 200 = Real.log 2 + 2 * Real.log 10 := by
    rw [show (200 : ℝ) = 2 * 10 ^ 2 by norm_num]
    rw [Real.log_mul (by norm_num) (by positivity), Real.log_pow]
    norm_num
  rw [h200]
  have h2lo : (logPointLo N 2 : ℝ) ≤ Real.log 2 := by simpa using h2.1
  have h2hi : Real.log 2 ≤ (logPointHi N 2 : ℝ) := by simpa using h2.2
  have h10lo : (logPointLo N 10 : ℝ) ≤ Real.log 10 := by simpa using h10.1
  have h10hi : Real.log 10 ≤ (logPointHi N 10 : ℝ) := by simpa using h10.2
  constructor
  · simp only [log200Lo]
    push_cast
    linarith
  · simp only [log200Hi]
    push_cast
    linarith

def gammaBoundLo (N : ℕ) : ℚ :=
  harmonic 200 - log200Hi N - 1 / 400

def gammaBoundHi (N : ℕ) : ℚ :=
  harmonic 200 - log200Lo N - 1 / 402

theorem gammaBoundLo_lt (N : ℕ) :
    (gammaBoundLo N : ℝ) < Real.eulerMascheroniConstant := by
  have h := gammaLower_lt_gamma 197
  have hl := (log200_mem N).2
  have hcast : (gammaBoundLo N : ℝ) =
      gammaLower 200 + (Real.log 200 - (log200Hi N : ℝ)) := by
    unfold gammaBoundLo gammaLower
    push_cast
    ring
  rw [hcast]
  linarith

theorem gammaBoundHi_gt (N : ℕ) :
    Real.eulerMascheroniConstant < (gammaBoundHi N : ℝ) := by
  have h := gammaUpper_gt_gamma 197
  have hl := (log200_mem N).1
  have hcast : (gammaBoundHi N : ℝ) =
      gammaUpper 200 + (Real.log 200 - (log200Lo N : ℝ)) := by
    unfold gammaBoundHi gammaUpper
    push_cast
    ring
  rw [hcast]
  linarith

/-- The rational `γ` interval obtained from `n = 200`. -/
def gammaLo : ℚ := gammaBoundLo 200
def gammaHi : ℚ := gammaBoundHi 200

theorem gamma_mem :
    (gammaLo : ℝ) < Real.eulerMascheroniConstant ∧
      Real.eulerMascheroniConstant < (gammaHi : ℝ) :=
  ⟨gammaBoundLo_lt 200, gammaBoundHi_gt 200⟩

noncomputable def Omega (t : ℝ) : ℝ :=
  -Real.log Real.pi + (Complex.digamma ((1 / 4 : ℂ) + (t / 2 : ℂ) * Complex.I)).re

theorem Omega_zero :
    Omega 0 = -Real.log Real.pi - Real.eulerMascheroniConstant
      - Real.pi / 2 - 3 * Real.log 2 := by
  unfold Omega
  have harg : ((1 / 4 : ℂ) + ((0 : ℝ) / 2 : ℂ) * Complex.I) = 1 / 4 := by
    norm_num
  rw [harg]
  have hlog2 : (Complex.log 2).re = Real.log 2 := by
    rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) by norm_num]
    exact Complex.log_ofReal_re 2
  have hreal : ((-(Real.eulerMascheroniConstant : ℂ) - (Real.pi : ℂ) / 2
      - 3 * Complex.log 2)).re
      = -Real.eulerMascheroniConstant - Real.pi / 2 - 3 * Real.log 2 := by
    simp only [Complex.sub_re, Complex.neg_re, Complex.ofReal_re,
      Complex.div_re, Complex.ofReal_im, Complex.mul_re, hlog2, zero_mul,
      sub_zero]
    norm_num
    ring
  have h := congrArg Complex.re digamma_quarter
  rw [hreal] at h
  rw [h]
  ring

def piLo : ℚ := 314159265358979323846 / 100000000000000000000
def piHi : ℚ := 314159265358979323847 / 100000000000000000000

theorem pi_mem : (piLo : ℝ) < Real.pi ∧ Real.pi < (piHi : ℝ) := by
  constructor
  · have := Real.pi_gt_d20
    norm_num [piLo]
    linarith
  · have := Real.pi_lt_d20
    norm_num [piHi]
    linarith

theorem log_pi_mem (N : ℕ) :
    (logPointLo N piLo : ℝ) ≤ Real.log Real.pi ∧
      Real.log Real.pi ≤ (logPointHi N piHi : ℝ) := by
  have hpi := pi_mem
  have hlo := (logPoint_mem N (x := piLo) (by norm_num [piLo])).1
  have hhi := (logPoint_mem N (x := piHi) (by norm_num [piHi])).2
  constructor
  · exact hlo.trans (Real.log_le_log (by norm_num [piLo]) hpi.1.le)
  · exact (Real.log_le_log Real.pi_pos hpi.2.le).trans hhi


def omegaZeroLo (N : ℕ) : ℚ :=
  -logPointHi N piHi - gammaHi - piHi / 2 - 3 * logPointHi N 2

def omegaZeroHi (N : ℕ) : ℚ :=
  -logPointLo N piLo - gammaLo - piLo / 2 - 3 * logPointLo N 2

theorem omegaZero_mem (N : ℕ) :
    (omegaZeroLo N : ℝ) ≤ Omega 0 ∧ Omega 0 ≤ (omegaZeroHi N : ℝ) := by
  have hpi := pi_mem
  have hlogpi := log_pi_mem N
  have hlog2 := logPoint_mem N (x := (2 : ℚ)) (by norm_num)
  have hlog2lo : (logPointLo N 2 : ℝ) ≤ Real.log 2 := by simpa using hlog2.1
  have hlog2hi : Real.log 2 ≤ (logPointHi N 2 : ℝ) := by simpa using hlog2.2
  have hg := gamma_mem
  rw [Omega_zero]
  constructor
  · simp only [omegaZeroLo]
    push_cast
    linarith [hlogpi.2, hlog2hi, hg.2.le, hpi.2.le]
  · simp only [omegaZeroHi]
    push_cast
    linarith [hlogpi.1, hlog2lo, hg.1.le, hpi.1.le]

theorem digamma_conj {z : ℂ} (hz : ∀ m : ℕ, z ≠ -(m : ℂ)) :
    Complex.digamma (conj z) = conj (Complex.digamma z) := by
  have hz' : ∀ m : ℕ, conj z ≠ -(m : ℂ) := by
    intro m h
    apply hz m
    have := congrArg conj h
    simpa using this
  unfold Complex.digamma
  rw [logDeriv_apply, logDeriv_apply]
  have hd : deriv Gamma (conj z) = conj (deriv Gamma z) := by
    have hder : HasDerivAt Gamma (deriv Gamma (conj z)) (conj z) :=
      (Complex.differentiableAt_Gamma (conj z) hz').hasDerivAt
    have hcomp : HasDerivAt (star ∘ Gamma ∘ conj) (star (deriv Gamma (conj z)))
        (conj (conj z)) := hder.star_conj
    have hfun : (star ∘ Gamma ∘ conj) = Gamma := by
      funext w
      simp [Function.comp, Complex.Gamma_conj]
    rw [hfun, Complex.conj_conj] at hcomp
    have huniq := hcomp.deriv
    rw [huniq]
    simp
  rw [hd, Complex.Gamma_conj]
  simp only [map_div₀]

theorem Omega_even (t : ℝ) : Omega (-t) = Omega t := by
  unfold Omega
  congr 1
  have hz : ∀ m : ℕ,
      ((1 / 4 : ℂ) + (t / 2 : ℂ) * Complex.I) ≠ -(m : ℂ) := by
    intro m h
    have hre := congrArg Complex.re h
    simp at hre
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have harg : ((1 / 4 : ℂ) + ((-t) / 2 : ℂ) * Complex.I)
      = conj ((1 / 4 : ℂ) + (t / 2 : ℂ) * Complex.I) := by
    have h2 : (starRingEnd ℂ) (2 : ℂ) = 2 := by
      rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) by norm_num]
      exact Complex.conj_ofReal 2
    have h4 : (starRingEnd ℂ) (4 : ℂ) = 4 := by
      rw [show (4 : ℂ) = ((4 : ℝ) : ℂ) by norm_num]
      exact Complex.conj_ofReal 4
    simp only [map_add, map_mul, map_div₀, map_one, h2, h4, Complex.conj_I,
      Complex.conj_ofReal]
    ring
  push_cast
  rw [harg, digamma_conj hz]
  simp

end IntersectionForm
