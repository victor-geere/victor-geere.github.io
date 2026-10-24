/-
  Op56/Exact.lean — the exact layer of OP-5/OP-6.

  Content (all proved from Mathlib alone, no `axiom`):

  * the half-series is summable for `p ≥ 2`; terms positive and decreasing;
  * the budget splits as `b_0 + T_1`; tails positive and decreasing;
  * `tailSum_ge_first_two`: the tail dominates its first two terms;
  * `log_bound` / `bernoulli`: the Bernoulli-type bound `1 - p·x ≤ (1+x)^{-p}`
    for `x ≥ 0`, `p·x ≤ 1`, via `t ≤ -log(1-t)`;
  * `term_ratio`: `term p (n+2) = term p (n+1)·(1 + 1/(n+2))^{-p}`;
  * `bound_three_halves`: `(1 + 1/(4p+1))^p ≤ 3/2` for `p ≥ 2`, via
    `p·log(1+1/(4p+1)) ≤ p/(4p+1) ≤ 1/4 < log(3/2)`;
  * **`exists_isComplete`: the completeness threshold exists**, with the explicit
    witness `N = 4p`; hence `nmin` is well defined and is the *first* index satisfying
    Brown's criterion (`nmin_spec`, `nmin_minimal`).

  The antitone integral test `tailSum_integral_lower` is a documented *negative* result
  (too lossy, and used nowhere).  It is proved below with the honest hypothesis
  `N + 2 ≤ M`; the as-stated `N + 1 ≤ M` form is false (see the lemma's docstring).

  **Three things worth recording.**
  1. The antitone integral test on `f x = (2x)^{-p}` — all of whose ingredients are in
     Mathlib — is **too lossy** to prove existence: at the threshold its bound is
     `≈ 0.73 b_N < b_N`.  That negative result is documented at
     `tailSum_integral_lower`.  Existence is instead shown discretely, from the first
     two terms of the tail, with the witness `N = 4p`: writing `t₁ = term p (4p+1)`,
     `t₂ = term p (4p+2)`, one has `b_{4p}/t₁ = (1 + 1/(4p+1))^p ≤ 3/2` and
     `t₂/t₁ ≥ 1 - p/(4p+2) ≥ 2/3`, so `b_{4p} ≤ (3/2)t₁ ≤ t₁ + t₂ ≤ T_{4p+1}`.
  2. `nmin` is defined for all `p : ℕ` but is only meaningful for `p ≥ 2`: for `p < 2`
     the half-series diverges, Mathlib's `tsum` is `0`, and `IsComplete p N` is *false*
     for every `N`.  Accordingly `nmin_spec`/`nmin_minimal` both take `2 ≤ p`, and
     `nmin` uses a junk value `0` outside that range.
  3. With the alphabet `b_N = (2(N+1))^{-p}` (0-based, the notes' `a_{N+1}`), the
     completeness condition `b_N ≤ T_{N+1}` is
     `T_{N+1}/b_N = r/(1-r)`, `r = (N/(N+1))^p`; it holds exactly for
     `r ≥ 1/2`, i.e. `N ≥ p/ln 2 + O(1)` — the check `N = 12` at `p = 10` is complete
     (`T/b = 1.0077`) while `N = 11` is not (`0.9017`), matching `n_min = 13`.  This
     also shows directly that the failing set is a finite initial segment.
-/

import Op56.Defs
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

namespace Op56

noncomputable section

set_option maxHeartbeats 2000000

open scoped BigOperators Topology

/-! ### Positivity and monotonicity -/

lemma term_pos (p n : ℕ) : 0 < term p n := by
  unfold term
  positivity

lemma term_nonneg (p n : ℕ) : 0 ≤ term p n := (term_pos p n).le

lemma term_zero (p : ℕ) : term p 0 = (2 : ℝ) ^ (-(p : ℝ)) := by
  unfold term
  norm_num

/-- The terms decrease: `b_{n+1} ≤ b_n`. -/
lemma term_succ_le (p n : ℕ) : term p (n + 1) ≤ term p n := by
  unfold term
  have hbase : (2 * ((n : ℝ) + 1)) ≤ (2 * (((n + 1 : ℕ) : ℝ) + 1)) := by
    push_cast
    linarith
  have hpos : (0 : ℝ) < 2 * ((n : ℝ) + 1) := by positivity
  exact Real.rpow_le_rpow_of_nonpos hpos hbase (neg_nonpos.mpr (Nat.cast_nonneg p))

lemma term_le_term_zero (p n : ℕ) : term p n ≤ term p 0 := by
  induction n with
  | zero => exact le_rfl
  | succ n ih => exact (term_succ_le p n).trans ih

/-! ### Summability for `p ≥ 2` -/

lemma summable_shifted (p : ℕ) (hp : 2 ≤ p) :
    Summable (fun n : ℕ => ((n : ℝ) + 1) ^ (-(p : ℝ))) := by
  have hp1 : (1 : ℝ) < (p : ℝ) := by exact_mod_cast (by omega : 1 < p)
  have h : Summable (fun n : ℕ => (n : ℝ) ^ (-(p : ℝ))) := by
    simpa [one_div, Real.rpow_neg] using
      (Real.summable_one_div_nat_rpow (p := (p : ℝ))).mpr hp1
  simpa [Nat.cast_add, Nat.cast_one] using (summable_nat_add_iff 1).mpr h

lemma summable_term (p : ℕ) (hp : 2 ≤ p) : Summable (term p) := by
  have h := (summable_shifted p hp).mul_left ((2 : ℝ) ^ (-(p : ℝ)))
  refine h.congr fun n => ?_
  unfold term
  rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 2) (by positivity : (0 : ℝ) ≤ (n : ℝ) + 1)]

lemma summable_tail (p : ℕ) (hp : 2 ≤ p) (N : ℕ) : Summable (fun n => term p (N + n)) := by
  refine ((summable_nat_add_iff N).mpr (summable_term p hp)).congr fun n => ?_
  rw [Nat.add_comm]

/-! ### Tails: positivity, monotonicity, and the budget split -/

/-! ### Integral lower bound and existence of the threshold -/

/-- Substitution `u = 2x` together with `integral_Ioi_rpow_of_lt` evaluates the
integral of `x ↦ (2x)^{-p}` over `Ioi M` for `p ≥ 2`, `M > 0`. -/
lemma integral_two_mul_rpow (p M : ℕ) (hp : 2 ≤ p) (hM : 0 < M) :
    ∫ x in Set.Ioi (M : ℝ), (2 * x) ^ (-(p : ℝ))
      = (2 * (M : ℝ)) ^ (-(p : ℝ)) * ((M : ℝ) / ((p : ℝ) - 1)) := by
  have hpR : (2 : ℝ) ≤ (p : ℝ) := by exact_mod_cast hp
  have hMpos : (0 : ℝ) < (M : ℝ) := by exact_mod_cast hM
  have h2M : (0 : ℝ) < 2 * (M : ℝ) := by positivity
  have hp1 : ((p : ℝ) - 1) ≠ 0 := by linarith
  have hsub := MeasureTheory.integral_comp_mul_left_Ioi
    (g := fun y : ℝ => y ^ (-(p : ℝ))) (M : ℝ) (b := (2 : ℝ)) (by norm_num)
  rw [hsub]
  rw [integral_Ioi_rpow_of_lt (a := -(p : ℝ)) (by linarith) h2M]
  rw [smul_eq_mul]
  rw [Real.rpow_add h2M (-(p : ℝ)) 1, Real.rpow_one]
  rw [show -((p : ℝ)) + 1 = -((p : ℝ) - 1) by ring, neg_div_neg_eq]
  field_simp

/-- **The integral test is too lossy here — a negative result, recorded so it is not
retried.**  For the decreasing integrand `f x = (2x)^{-p}` the antitone integral test
(`AntitoneOn.integral_le_tsum_comp_add` + `integral_comp_mul_left_Ioi` +
`integral_Ioi_rpow_of_lt`, all in Mathlib) gives

    tailSum p (N+1) ≥ ∫_{Ioi M} f = (2M)^{-p} · M/(p-1)      (M ≥ N+2).

The correct hypothesis is `N + 2 ≤ M`: the tail `tailSum p (N+1)` starts at index
`N+1` and the integral is taken over `Ioi M`, so `M` must lie at or beyond the second
index `N+2` of that tail.  **The as-written version with `N + 1 ≤ M` is false**: at
`M = N + 1` the sum misses the term at `k = M = N+1` and the inequality can fail —
e.g. `p = 2`, `N = 0`, `M = 1` gives left side `(2)^{-2}·1 = 1/4 = 0.25` while
`tailSum 2 1 = 0.16123… < 0.25`.

At the threshold `n_min ≈ p/ln 2` this bound is **below** `b_N = (2N)^{-p}` from
`p ≈ 10` on (`bound/b_N = 1.33, 1.03, 0.836, 0.748, 0.733` at `p = 2, 5, 10, 50, 100`),
because the integral discards the discrete mass `T_{N+1} ≈ 2 b_{N+1}` that the sum
carries in its first terms.  So this estimate **cannot** prove `IsComplete`, and
existence must be shown discretely (see `exists_isComplete`).  The statement is kept
because the bound is true; it is used nowhere. -/
lemma tailSum_integral_lower (p N M : ℕ) (hp : 2 ≤ p) (hNM : N + 2 ≤ M) :
    (2 * (M : ℝ)) ^ (-(p : ℝ)) * ((M : ℝ) / ((p : ℝ) - 1)) ≤ tailSum p (N + 1) := by
  have hKpos : (0 : ℝ) < ((N + 2 : ℕ) : ℝ) := by positivity
  have hKM : (((N + 2 : ℕ)) : ℝ) ≤ (M : ℝ) := by exact_mod_cast hNM
  have hsumm : Summable (fun n : ℕ => (2 * (n : ℝ)) ^ (-(p : ℝ))) := by
    refine (summable_nat_add_iff 1).mp ?_
    refine (summable_term p hp).congr fun n => ?_
    unfold term
    rw [Nat.cast_add, Nat.cast_one]
  have hsummK : Summable (fun n : ℕ => (2 * ((n + (N + 2) : ℕ) : ℝ)) ^ (-(p : ℝ))) :=
    (summable_nat_add_iff (N + 2)).mpr hsumm
  have hanti : AntitoneOn (fun x : ℝ => (2 * x) ^ (-(p : ℝ))) (Set.Ici (((N + 2 : ℕ)) : ℝ)) := by
    intro a ha b hb hab
    have ha' : (((N + 2 : ℕ)) : ℝ) ≤ a := ha
    have ha0 : (0 : ℝ) < 2 * a := by linarith
    have h2ab : 2 * a ≤ 2 * b := by linarith
    exact Real.rpow_le_rpow_of_nonpos ha0 h2ab (neg_nonpos.mpr (Nat.cast_nonneg p))
  have hnonneg : ∀ t ∈ Set.Ioi (((N + 2 : ℕ)) : ℝ), 0 ≤ (2 * t) ^ (-(p : ℝ)) := by
    intro t ht
    have ht' : (((N + 2 : ℕ)) : ℝ) < t := ht
    exact Real.rpow_nonneg (by linarith : (0 : ℝ) ≤ 2 * t) _
  have hint := AntitoneOn.integral_le_tsum_comp_add
    (f := fun x : ℝ => (2 * x) ^ (-(p : ℝ))) (N + 2) hanti hsumm hnonneg
  have htsum : (∑' n : ℕ, (2 * ((n + (N + 2) : ℕ) : ℝ)) ^ (-(p : ℝ))) = tailSum p (N + 1) := by
    unfold tailSum
    apply tsum_congr
    intro n
    unfold term
    congr 1
    push_cast
    ring
  rw [htsum] at hint
  have hInt := hanti.integrableOn_Ioi_of_summable_comp_add hsummK hnonneg
  have hle_int : ∫ x in Set.Ioi (M : ℝ), (2 * x) ^ (-(p : ℝ))
      ≤ ∫ x in Set.Ioi (((N + 2 : ℕ)) : ℝ), (2 * x) ^ (-(p : ℝ)) := by
    refine MeasureTheory.setIntegral_mono_set hInt ?_ ?_
    · change ∀ᵐ x ∂(MeasureTheory.volume.restrict (Set.Ioi (((N + 2 : ℕ)) : ℝ))),
          (0:ℝ) ≤ (2 * x) ^ (-(p:ℝ))
      rw [MeasureTheory.ae_restrict_iff' measurableSet_Ioi]
      refine Filter.Eventually.of_forall (fun x hx => ?_)
      have hx' : (((N + 2 : ℕ)) : ℝ) < x := hx
      exact Real.rpow_nonneg (by linarith : (0:ℝ) ≤ 2 * x) _
    · exact Filter.Eventually.of_forall (fun x hx => lt_of_le_of_lt hKM hx)
  have heval := integral_two_mul_rpow p M hp (by omega : 0 < M)
  calc (2 * (M : ℝ)) ^ (-(p : ℝ)) * ((M : ℝ) / ((p : ℝ) - 1))
      = ∫ x in Set.Ioi (M : ℝ), (2 * x) ^ (-(p : ℝ)) := heval.symm
    _ ≤ ∫ x in Set.Ioi (((N + 2 : ℕ)) : ℝ), (2 * x) ^ (-(p : ℝ)) := hle_int
    _ ≤ tailSum p (N + 1) := hint

/-- The tail dominates its first two terms. -/
lemma tailSum_ge_first_two (p : ℕ) (hp : 2 ≤ p) (N : ℕ) :
    term p (N + 1) + term p (N + 2) ≤ tailSum p (N + 1) := by
  unfold tailSum
  have h2 := (summable_tail p hp (N + 1)).sum_add_tsum_nat_add 2
  rw [← h2]
  have hfin : (∑ i ∈ Finset.range 2, term p (N + 1 + i))
      = term p (N + 1) + term p (N + 2) := by
    rw [Finset.sum_range_succ, Finset.sum_range_one]
  rw [hfin]
  exact le_add_of_nonneg_right (tsum_nonneg (fun i => term_nonneg p _))

/-- `t ≤ -log(1-t)` for `t < 1`. -/
lemma log_bound (t : ℝ) (h1 : t < 1) : t ≤ - Real.log (1 - t) := by
  have h3 : (0:ℝ) < 1 - t := by linarith
  have h := Real.one_sub_inv_le_log_of_pos (x := (1 - t)⁻¹) (by positivity)
  have hinv : ((1 - t)⁻¹)⁻¹ = 1 - t := by field_simp
  rw [hinv, Real.log_inv] at h
  linarith

/-- **Bernoulli-type bound.**  `1 - p·x ≤ (1+x)^(-p)` for `x ≥ 0`, `p ≥ 0`, `p·x ≤ 1`. -/
lemma bernoulli (x p : ℝ) (hx : 0 ≤ x) (hp : 0 ≤ p) (hpx : p * x ≤ 1) :
    1 - p * x ≤ (1 + x) ^ (-p) := by
  rcases lt_or_eq_of_le hpx with hlt | heq
  · have hx1 : (0:ℝ) < 1 + x := by linarith
    have hpx0 : (0:ℝ) ≤ p * x := mul_nonneg hp hx
    have hlog1 : Real.log (1 + x) ≤ x := by
      have := Real.log_le_sub_one_of_pos hx1; linarith
    have hlog1n : 0 ≤ Real.log (1 + x) := Real.log_nonneg (by linarith)
    have hlog2 : p * x ≤ - Real.log (1 - p * x) := log_bound (p * x) hlt
    have hlog : p * Real.log (1 + x) ≤ - Real.log (1 - p * x) := by
      have h3 : (1 - p * x) * Real.log (1 + x) ≤ x := by
        have h4 : (1 - p*x) * Real.log (1 + x) ≤ 1 * Real.log (1 + x) :=
          mul_le_mul_of_nonneg_right (by linarith : 1 - p*x ≤ 1) hlog1n
        rw [one_mul] at h4
        linarith
      nlinarith [h3, hlog1, hlog2, hpx0, hlog1n]
    have hl : p * Real.log (1 + x) ≤ Real.log ((1 - p*x)⁻¹) := by
      rw [Real.log_inv]; linarith
    have hexp : (1 + x) ^ p ≤ (1 - p*x)⁻¹ := by
      have h := Real.exp_le_exp.mpr hl
      have h1 : Real.exp (p * Real.log (1 + x)) = (1 + x) ^ p := by
        rw [Real.rpow_def_of_pos hx1, mul_comm]
      have h2 : Real.exp (Real.log ((1 - p*x)⁻¹)) = (1 - p*x)⁻¹ :=
        Real.exp_log (by positivity : (0:ℝ) < (1 - p*x)⁻¹)
      rwa [h1, h2] at h
    rw [show (-p) = -(p) by ring, Real.rpow_neg hx1.le]
    exact (le_inv_comm₀ (by positivity : (0:ℝ) < (1+x)^p) (by linarith : (0:ℝ) < 1 - p*x)).mp hexp
  · rw [heq]
    have h0 : (0:ℝ) ≤ (1 + x) ^ (-p) :=
      Real.rpow_nonneg (by linarith : (0:ℝ) ≤ 1 + x) _
    linarith

/-- The term ratio: `term p (n+2) = term p (n+1) · (1 + 1/(n+2))^{-p}`. -/
lemma term_ratio (p : ℕ) (n : ℕ) :
    term p (n + 2) = term p (n + 1) * (1 + 1/((n:ℝ)+2)) ^ (-(p:ℝ)) := by
  unfold term
  have hbase : 2 * (((n+2 : ℕ) : ℝ) + 1) = (2 * (((n+1 : ℕ) : ℝ) + 1)) * (1 + 1/((n:ℝ)+2)) := by
    push_cast
    have h : (1:ℝ) + 1/((n:ℝ)+2) = ((n:ℝ)+3)/((n:ℝ)+2) := by
      have hm : ((n:ℝ)+2) ≠ 0 := by positivity
      field_simp
      ring
    rw [h]
    have hm : ((n:ℝ)+2) ≠ 0 := by positivity
    field_simp
    ring
  rw [hbase, Real.mul_rpow (by positivity : (0:ℝ) ≤ 2 * (((n+1:ℕ):ℝ) + 1))
        (by positivity : (0:ℝ) ≤ 1 + 1/((n:ℝ)+2))]

/-- `(1 + 1/(4p+1))^p ≤ 3/2` for `p ≥ 2`: `p·log(1+1/(4p+1)) ≤ p/(4p+1) ≤ 1/4 < log(3/2)`. -/
lemma bound_three_halves (p : ℕ) (hp : 2 ≤ p) :
    (1 + 1/(4*(p:ℝ)+1)) ^ (p:ℝ) ≤ 3/2 := by
  have hpR : (2:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hx1 : (0:ℝ) < 1 + 1/(4*(p:ℝ)+1) := by positivity
  have hlog1 : Real.log (1 + 1/(4*(p:ℝ)+1)) ≤ 1/(4*(p:ℝ)+1) := by
    have := Real.log_le_sub_one_of_pos hx1; linarith
  have hlog32 : (1:ℝ)/4 < Real.log (3/2) := by
    have h2 := Real.one_sub_inv_le_log_of_pos (by norm_num : (0:ℝ) < 3/2)
    norm_num at h2 ⊢
    linarith
  have hq : (p:ℝ) * (1/(4*(p:ℝ)+1)) ≤ 1/4 := by
    rw [mul_one_div, div_le_iff₀ (by positivity : (0:ℝ) < 4*(p:ℝ)+1)]
    linarith
  have hl : (p:ℝ) * Real.log (1 + 1/(4*(p:ℝ)+1)) ≤ Real.log (3/2) := by
    have := mul_le_mul_of_nonneg_left hlog1 (Nat.cast_nonneg p)
    linarith
  have hexp := Real.exp_le_exp.mpr hl
  have h1 : Real.exp ((p:ℝ) * Real.log (1 + 1/(4*(p:ℝ)+1)))
      = (1 + 1/(4*(p:ℝ)+1)) ^ (p:ℝ) := by
    rw [Real.rpow_def_of_pos hx1, mul_comm]
  have h2 : Real.exp (Real.log (3/2)) = 3/2 := Real.exp_log (by norm_num)
  rwa [h1, h2] at hexp

/-- **Existence of the completeness threshold (discrete).**  For `p ≥ 2` there is `N`
with `b_N ≤ T_{N+1}`; the witness is `N = 4p`.

Write `t₁ = term p (4p+1)`, `t₂ = term p (4p+2)`.  `term_ratio` gives
`t₂/t₁ = (1 + 1/(4p+2))^{-p}`, and `bernoulli` gives
`t₂/t₁ ≥ 1 - p/(4p+2) ≥ 2/3` (since `p ≥ 0`).  Separately `term p (4p)/t₁ =
(1 + 1/(4p+1))^p ≤ 3/2` by `bound_three_halves`.  Hence
`b_{4p} ≤ (3/2)·t₁ ≤ t₁ + t₂ ≤ T_{4p+1}` by `tailSum_ge_first_two`. -/
theorem exists_isComplete (p : ℕ) (hp : 2 ≤ p) : ∃ N, IsComplete p N := by
  refine ⟨4 * p, ?_⟩
  have hp1 : 1 ≤ p := by omega
  have h2t : term p (4*p + 1) + term p (4*p + 2) ≤ tailSum p (4*p + 1) :=
    tailSum_ge_first_two p hp (4*p)
  -- ratio for t₂
  have hr2 := term_ratio p (4*p)
  rw [show ((4*p : ℕ):ℝ) + 2 = 4*(p:ℝ)+2 by push_cast; ring] at hr2
  -- ratio for t₁ (= b · R^{-p})
  have hr1 := term_ratio p (4*p - 1)
  have hcast : (((4*p - 1 : ℕ)):ℝ) + 2 = 4*(p:ℝ)+1 := by
    have hc : (1:ℕ) ≤ 4*p := by omega
    push_cast [Nat.cast_sub hc]
    ring
  rw [hcast] at hr1
  -- b = t₁ · (1 + 1/(4p+1))^p
  have hb_eq : term p (4*p) = term p (4*p + 1) * (1 + 1/(4*(p:ℝ)+1)) ^ (p:ℝ) := by
    have hR : (0:ℝ) < 1 + 1/(4*(p:ℝ)+1) := by positivity
    have h4 : (4*p - 1 : ℕ) + 1 = 4*p := by omega
    rw [show 4*p = (4*p - 1) + 1 by omega]
    rw [hr1, mul_assoc, ← Real.rpow_add hR (-(p:ℝ)) (p:ℝ),
        show -(p:ℝ) + (p:ℝ) = 0 by ring, Real.rpow_zero, mul_one]
  -- so b ≤ (3/2) t₁
  have hb_le : term p (4*p) ≤ (3:ℝ)/2 * term p (4*p + 1) := by
    rw [hb_eq]
    nlinarith [bound_three_halves p hp, term_pos p (4*p + 1)]
  -- t₂ ≥ (2/3) t₁
  have ht2 : (2:ℝ)/3 * term p (4*p + 1) ≤ term p (4*p + 2) := by
    have hx2 : (0:ℝ) ≤ 1/(4*(p:ℝ)+2) := by positivity
    have hpx2 : (p:ℝ) * (1/(4*(p:ℝ)+2)) ≤ 1 := by
      rw [mul_one_div, div_le_iff₀ (by positivity : (0:ℝ) < 4*(p:ℝ)+2)]
      nlinarith
    have hb2 := bernoulli (1/(4*(p:ℝ)+2)) (p:ℝ) hx2 (Nat.cast_nonneg p) hpx2
    have h23 : (2:ℝ)/3 ≤ 1 - (p:ℝ) * (1/(4*(p:ℝ)+2)) := by
      have hq : (p:ℝ) * (1/(4*(p:ℝ)+2)) ≤ 1/3 := by
        rw [mul_one_div, div_le_iff₀ (by positivity : (0:ℝ) < 4*(p:ℝ)+2)]
        nlinarith
      linarith
    have hR2 : (2:ℝ)/3 ≤ (1 + 1/(4*(p:ℝ)+2)) ^ (-(p:ℝ)) := le_trans h23 hb2
    rw [hr2, mul_comm (2/3 : ℝ)]
    exact mul_le_mul_of_nonneg_left hR2 (term_pos p (4*p + 1)).le
  have hmain : term p (4*p) ≤ term p (4*p + 1) + term p (4*p + 2) := by
    have hpos1 : (0:ℝ) < term p (4*p + 1) := term_pos p _
    linarith [hb_le, ht2, hpos1]
  unfold IsComplete
  linarith [hmain, h2t]

/-! ### The threshold and the OP-6 quantities -/

/-- **The threshold is well defined in the range of interest.**  For `p < 2` the
half-series `Σ (2(n+1))^{-p}` diverges, so Mathlib's `tsum` takes the value `0` there and
`IsComplete p N` is *false* for every `N` (as `term p N > 0`).  The OP-5/OP-6 theory
lives in `p ≥ 2`, which is exactly where the half-series converges, so `exists_isComplete`
is the correct statement and `nmin` below is made total by a junk value outside it. -/
theorem exists_isComplete_all (p : ℕ) (hp : 2 ≤ p) : ∃ N, IsComplete p N :=
  exists_isComplete p hp

/-- The first index satisfying Brown's criterion.  For `p ≥ 2` this is
`Nat.find (exists_isComplete p hp)`; for `p < 2` (where no such index exists) it is the
junk value `0`.  Use `nmin_spec`/`nmin_minimal`, both of which require `2 ≤ p`. -/
def nmin (p : ℕ) : ℕ := by
  classical
  exact if h : 2 ≤ p then Nat.find (exists_isComplete p h) else 0

lemma nmin_spec (p : ℕ) (hp : 2 ≤ p) : IsComplete p (nmin p) := by
  classical
  have h : nmin p = Nat.find (exists_isComplete p hp) := by
    simp only [nmin, dif_pos hp]
  rw [h]
  exact Nat.find_spec (exists_isComplete p hp)

lemma nmin_minimal (p : ℕ) (hp : 2 ≤ p) {N : ℕ} (hN : N < nmin p) : ¬ IsComplete p N := by
  classical
  have h : nmin p = Nat.find (exists_isComplete p hp) := by
    simp only [nmin, dif_pos hp]
  rw [h] at hN
  exact Nat.find_min (exists_isComplete p hp) hN

/-- The exact measure of `S_1` (census law, `Op56/Census.lean`). -/
def reachableMeasure (p : ℕ) : ℝ :=
  (2 : ℝ) ^ (nmin p) * tailSum p (nmin p)

/-- The OP-6 fraction: reachable measure against the budget. -/
def reachableFraction (p : ℕ) : ℝ :=
  reachableMeasure p / budget p

/-- The reciprocal logarithm `L(p) = -log (measure/P)` of the OP-6 write-up. -/
def L (p : ℕ) : ℝ := -Real.log (reachableFraction p)

end

end Op56
