/-
  DirichletZeroTail.lean — the **zero/density tail**, reduced to a density input.

  The zero side of the explicit formula is `∑_γ h(γ)` over the nontrivial zeros.  The
  numerical assembly bounds the un-certified part by the Riemann–von Mangoldt density,
  `∑_{γ>T} |h γ| ≤ ∫_T^∞ |h(t)| (log(qt/2π)+1)/(2π) dt`.  That uses zero-counting,
  which Mathlib does not have for a Dirichlet `L` (no Riemann–von Mangoldt formula; only
  `riemannZetaZeros` finiteness).  What *is* formalisable, and is what this file proves,
  is the exact mechanism by which a density bound controls the tail:

  * `zeroTail_le_of_majorant` — if the zeros are at least as sparse as a majorant `f`
    (`∀ n, f n ≤ γ n`) and `h ≥ 0` is antitone, then `∑' n, h (γ n) ≤ ∑' n, h (f n)`.
    The inverse counting function `f` is the density input;
  * `gaussian_zeroTail_le` — the Gaussian instance with a constant gap `g`:
    `∑' n, exp (−(T+(n+1)g)²/2) ≤ exp (−(T+g)²/2) / (1 − exp (−(T+g)g))`.

  Supplying `f` for `L(χ,·)` (the inverse of the zero-counting function, with the `log`
  density) is the remaining zero-counting formalisation.
-/
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic

namespace RouteABC

noncomputable section

open scoped BigOperators

/-- **Density-to-tail reduction.**  If the zero imaginary parts `γ` dominate a majorant
`f` (`∀ n, f n ≤ γ n`) and `h ≥ 0` is antitone, then the zero tail is bounded by the
majorant sum.  This is the formal core of the density tail: `f` is the inverse
zero-counting function, and the hypothesis is the density bound. -/
theorem zeroTail_le_of_majorant {h : ℝ → ℝ} {γ f : ℕ → ℝ}
    (h_nonneg : ∀ t, 0 ≤ h t) (h_anti : Antitone h)
    (hγ : ∀ n, f n ≤ γ n) (hf : Summable (fun n => h (f n))) :
    ∑' n, h (γ n) ≤ ∑' n, h (f n) := by
  have hle : ∀ n, h (γ n) ≤ h (f n) := fun n => h_anti (hγ n)
  refine Real.tsum_le_of_sum_le (fun n => h_nonneg _) (fun s => ?_)
  calc ∑ i ∈ s, h (γ i) ≤ ∑ i ∈ s, h (f i) := Finset.sum_le_sum (fun i _ => hle i)
    _ ≤ ∑' n, h (f n) := hf.sum_le_tsum s (fun i _ => h_nonneg _)

/-- **Gaussian density tail with a constant gap.**  For `g > 0`, `T ≥ 0`,

    `∑' n, exp (−(T+(n+1)g)²/2) ≤ exp (−(T+g)²/2) / (1 − exp (−(T+g)g))`.

This is the explicit tail bound the density mechanism yields for the modulated Gaussian
once the zeros are `g`-separated on the scale `T`. -/
theorem gaussian_zeroTail_le {T g : ℝ} (hg : 0 < g) (hT : 0 ≤ T) :
    ∑' n : ℕ, Real.exp (-((T + ((n : ℝ) + 1) * g) ^ 2) / 2)
      ≤ Real.exp (-((T + g) ^ 2) / 2) * (1 - Real.exp (-(T + g) * g))⁻¹ := by
  have hTg : 0 < T + g := by linarith
  have hr1 : Real.exp (-(T + g) * g) < 1 := by
    rw [Real.exp_lt_one_iff]; nlinarith
  have hgeo : Summable (fun n : ℕ => (Real.exp (-(T + g) * g)) ^ n) :=
    summable_geometric_of_norm_lt_one (by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]; exact hr1)
  have hterm : ∀ n : ℕ,
      Real.exp (-((T + ((n : ℝ) + 1) * g) ^ 2) / 2)
        ≤ Real.exp (-((T + g) ^ 2) / 2) * (Real.exp (-(T + g) * g)) ^ n := by
    intro n
    have hsq : (T + g) ^ 2 + 2 * ((n : ℝ) * g) * (T + g)
        ≤ (T + ((n : ℝ) + 1) * g) ^ 2 := by
      have h := sq_nonneg ((n : ℝ) * g)
      have e : (T + ((n : ℝ) + 1) * g) = (T + g) + (n : ℝ) * g := by ring
      rw [e]; nlinarith
    have h2 : Real.exp (-((T + ((n : ℝ) + 1) * g) ^ 2) / 2)
        ≤ Real.exp (-(((T + g) ^ 2 + 2 * ((n : ℝ) * g) * (T + g)) / 2)) :=
      Real.exp_le_exp.mpr (by linarith)
    have h3 : Real.exp (-(((T + g) ^ 2 + 2 * ((n : ℝ) * g) * (T + g)) / 2))
        = Real.exp (-((T + g) ^ 2) / 2) * (Real.exp (-(T + g) * g)) ^ n := by
      rw [show -(((T + g) ^ 2 + 2 * ((n : ℝ) * g) * (T + g)) / 2)
            = -((T + g) ^ 2) / 2 + (n : ℝ) * (-(T + g) * g) by ring,
        Real.exp_add, Real.exp_nat_mul]
    rw [h3] at h2
    exact h2
  refine Real.tsum_le_of_sum_le (fun n => (Real.exp_pos _).le) (fun s => ?_)
  calc ∑ n ∈ s, Real.exp (-((T + ((n : ℝ) + 1) * g) ^ 2) / 2)
      ≤ ∑ n ∈ s, Real.exp (-((T + g) ^ 2) / 2) * (Real.exp (-(T + g) * g)) ^ n :=
        Finset.sum_le_sum (fun n _ => hterm n)
    _ ≤ ∑' n : ℕ, Real.exp (-((T + g) ^ 2) / 2) * (Real.exp (-(T + g) * g)) ^ n :=
        (hgeo.mul_left _).sum_le_tsum s (fun n _ => by positivity)
    _ = Real.exp (-((T + g) ^ 2) / 2) * (1 - Real.exp (-(T + g) * g))⁻¹ := by
        rw [tsum_mul_left, tsum_geometric_of_norm_lt_one (by
          rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]; exact hr1)]

/-- **The density weight is summable against exponential decay.**  `Σ_k log(k+2)·e^{−k} < ∞` —
the real-analysis brick behind the density→tail step (the `log` comes from
`RiemannVonMangoldtDensity`, the `e^{−k}` from the test function). -/
theorem summable_log_mul_exp :
    Summable (fun k : ℕ => Real.log ((k : ℝ) + 2) * Real.exp (-(k : ℝ))) := by
  have hr : ‖Real.exp (-(1 : ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
  have hexp : ∀ k : ℕ, Real.exp (-(k : ℝ)) = (Real.exp (-(1 : ℝ))) ^ k := by
    intro k
    rw [← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hk : Summable (fun k : ℕ => ((k : ℝ) + 2) * Real.exp (-(k : ℝ))) := by
    have h : Summable (fun k : ℕ => ((k : ℝ) + 2) * (Real.exp (-(1 : ℝ))) ^ k) := by
      have h1 : Summable (fun k : ℕ => (k : ℝ) ^ 1 * (Real.exp (-(1 : ℝ))) ^ k) :=
        summable_pow_mul_geometric_of_norm_lt_one 1 hr
      have h0 : Summable (fun k : ℕ => (Real.exp (-(1 : ℝ))) ^ k) :=
        summable_geometric_of_norm_lt_one hr
      have := h1.add (h0.mul_left 2)
      refine this.congr fun k => ?_
      simp only [pow_one]; ring
    exact h.congr fun k => by rw [hexp k]
  refine hk.of_nonneg_of_le (fun k => ?_) (fun k => ?_)
  · exact mul_nonneg (Real.log_nonneg (by linarith [(Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ))])) (Real.exp_nonneg _)
  · have hlog : Real.log ((k : ℝ) + 2) ≤ (k : ℝ) + 2 :=
      Real.log_le_self (by linarith [(Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ))])
    exact mul_le_mul_of_nonneg_right hlog (Real.exp_nonneg _)

/-- **The density weight `log(q(k+4))` is summable against `e^{−k}`.**  This is what lets a
`RiemannVonMangoldtDensity` count bound (`≤ C·log(q(k+4))` per block) sum against an exponentially
decaying test function. -/
theorem summable_densityWeight_mul_exp (q : ℕ) :
    Summable (fun k : ℕ => Real.log ((q : ℝ) * ((k : ℝ) + 4)) * Real.exp (-(k : ℝ))) := by
  have hr : ‖Real.exp (-(1 : ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
  have hexp : ∀ k : ℕ, Real.exp (-(k : ℝ)) = (Real.exp (-(1 : ℝ))) ^ k := by
    intro k; rw [← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hmaj : Summable (fun k : ℕ => ((q : ℝ) * ((k : ℝ) + 4)) * Real.exp (-(k : ℝ))) := by
    have h1 : Summable (fun k : ℕ => (k : ℝ) ^ 1 * (Real.exp (-(1 : ℝ))) ^ k) :=
      summable_pow_mul_geometric_of_norm_lt_one 1 hr
    have h0 : Summable (fun k : ℕ => (Real.exp (-(1 : ℝ))) ^ k) :=
      summable_geometric_of_norm_lt_one hr
    have h := (h1.mul_left (q : ℝ)).add (h0.mul_left ((q : ℝ) * 4))
    refine h.congr fun k => ?_
    rw [hexp k]; simp only [pow_one]; ring
  rcases Nat.eq_zero_or_pos q with rfl | hq
  · simpa only [Nat.cast_zero, zero_mul, Real.log_zero, zero_mul] using summable_zero
  · have hq1 : (1 : ℝ) ≤ (q : ℝ) := by exact_mod_cast hq
    refine hmaj.of_nonneg_of_le (fun k => ?_) (fun k => ?_)
    · have hk : (1 : ℝ) ≤ (k : ℝ) + 4 := by
        have hk0 : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
        linarith
      have hone : (1 : ℝ) ≤ (q : ℝ) * ((k : ℝ) + 4) := by
        have h := mul_le_mul hq1 hk (by norm_num : (0:ℝ) ≤ 1) (by linarith : (0:ℝ) ≤ (q:ℝ))
        simpa using h
      exact mul_nonneg (Real.log_nonneg hone) (Real.exp_nonneg _)
    · exact mul_le_mul_of_nonneg_right (Real.log_le_self (by positivity)) (Real.exp_nonneg _)

end

end RouteABC
