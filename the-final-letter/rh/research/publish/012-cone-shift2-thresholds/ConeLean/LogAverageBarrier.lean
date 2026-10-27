/-
ConeLean/LogAverageBarrier.lean — deliverable (b3) of goal 3: what a logarithmic average does and
does not give for a prescribed scale.

The log-average of a sequence `a` over `[1, x]` is `(1/log x) Σ_{n≤x} a n / n`.  Its weight is
`1/n`, not `1`, so it is blind to any set of zero *harmonic* density — however large that set is in
counting measure.  The squares are the standard witness, and the machine-checked content below is
that their harmonic weight is bounded by `ζ(2) = π²/6`, hence their log-average vanishes:

    sum_inv_sq_le_zeta_two     : ∑_{n≤N} 1/n² ≤ π²/6
    tendsto_sum_inv_sq_div_log : (∑_{n≤N} 1/n²) / log N → 0

The counting side is the contrast, and is elementary but *not* mechanised here (labelled ARGUMENT,
not MACHINE-CHECKED): there are `C + 1` squares among `0, …, C²`, so the counting function of the
squares is unbounded even though their harmonic weight is bounded by `π²/6 < ∞`.  So a logarithmic
average cannot certify anything at a prescribed scale — which is exactly why Tao's log-averaged
two-point Chowla theorem controls the Abelian mean (goal 2, deliverable (1b)) but cannot see the
single point `x`, consistent with the residue being strictly weaker than `o(x)`.
-/
import Mathlib.NumberTheory.ZetaValues

namespace ConeLean

open scoped BigOperators
open Finset

noncomputable section

/-- The harmonic weight of the squares up to `N` is at most `ζ(2) = π²/6`. -/
theorem sum_inv_sq_le_zeta_two (N : ℕ) :
    ∑ n ∈ Finset.range (N + 1), (1 : ℝ) / (n : ℝ) ^ 2 ≤ Real.pi ^ 2 / 6 := by
  have h := hasSum_zeta_two.summable.sum_le_tsum (Finset.range (N + 1))
    (fun n _ => by positivity)
  rwa [hasSum_zeta_two.tsum_eq] at h

/-- **The log-average is blind to the squares**: their harmonic weight divided by `log N` tends to
`0`, even though there are unboundedly many of them. -/
theorem tendsto_sum_inv_sq_div_log :
    Filter.Tendsto
      (fun N : ℕ => (∑ n ∈ Finset.range (N + 1), (1 : ℝ) / (n : ℝ) ^ 2) / Real.log N)
      Filter.atTop (nhds 0) := by
  have hlog : ∀ N : ℕ, (0 : ℝ) ≤ Real.log N := by
    intro N
    rcases Nat.eq_zero_or_pos N with rfl | hN
    · simp
    · exact Real.log_nonneg (by exact_mod_cast hN)
  refine squeeze_zero
    (f := fun N : ℕ => (∑ n ∈ Finset.range (N + 1), (1 : ℝ) / (n : ℝ) ^ 2) / Real.log N)
    (g := fun N : ℕ => (Real.pi ^ 2 / 6) / Real.log N)
    (fun N => div_nonneg (Finset.sum_nonneg (fun n _ => by positivity)) (hlog N))
    (fun N => ?_)
    ?_
  · exact div_le_div_of_nonneg_right (sum_inv_sq_le_zeta_two N) (hlog N)
  · exact tendsto_const_nhds.div_atTop
      (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)

/-! ## 2. A set of zero logarithmic density can meet every dyadic block -/

/-- **(structure lemma, goal 4).**  "Almost all scales" carries no sparsity at any scale: the
powers of two have bounded harmonic weight — `Σ_k 2^{−k} ≤ 2` — so their logarithmic density is
zero, yet one of them lands in every dyadic block `[2^k, 2^{k+1})`.  An exceptional set of zero
logarithmic density can therefore intersect every scale range; nothing about the *structure* of the
exceptional set follows from its density alone. -/
theorem zero_log_density_meets_every_dyadic_block :
    (∀ k : ℕ, ∃ n : ℕ, 2 ^ k ≤ n ∧ n < 2 ^ (k + 1))
      ∧ Filter.Tendsto
          (fun N : ℕ => (∑ k ∈ Finset.range N, (1 : ℝ) / 2 ^ k) / Real.log N)
          Filter.atTop (nhds 0) := by
  refine ⟨fun k => ⟨2 ^ k, le_rfl, Nat.pow_lt_pow_right (by norm_num) (by omega)⟩, ?_⟩
  have hlog : ∀ N : ℕ, (0 : ℝ) ≤ Real.log N := by
    intro N
    rcases Nat.eq_zero_or_pos N with rfl | hN
    · simp
    · exact Real.log_nonneg (by exact_mod_cast hN)
  have hbound : ∀ N : ℕ, (∑ k ∈ Finset.range N, (1 : ℝ) / 2 ^ k) ≤ 2 := by
    intro N
    have h2 : ∀ k : ℕ, (1 : ℝ) / 2 ^ k = (1 / 2 : ℝ) ^ k := by
      intro k
      rw [div_pow, one_pow]
    simp only [h2]
    calc ∑ k ∈ Finset.range N, (1 / 2 : ℝ) ^ k
        ≤ ∑' k : ℕ, (1 / 2 : ℝ) ^ k :=
          Summable.sum_le_tsum _ (fun k _ => by positivity)
            (summable_geometric_of_norm_lt_one (by norm_num))
      _ = 2 := by
          rw [tsum_geometric_of_norm_lt_one (by norm_num : ‖(1 / 2 : ℝ)‖ < 1)]
          norm_num
  refine squeeze_zero
    (f := fun N : ℕ => (∑ k ∈ Finset.range N, (1 : ℝ) / 2 ^ k) / Real.log N)
    (g := fun N : ℕ => (2 : ℝ) / Real.log N)
    (fun N => div_nonneg (Finset.sum_nonneg (fun k _ => by positivity)) (hlog N))
    (fun N => div_le_div_of_nonneg_right (hbound N) (hlog N)) ?_
  exact tendsto_const_nhds.div_atTop (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)

end

end ConeLean
