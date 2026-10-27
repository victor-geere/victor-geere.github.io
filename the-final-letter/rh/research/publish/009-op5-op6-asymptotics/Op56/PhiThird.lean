/-
  Op56/PhiThird.lean — the *third-order* geometrically-dominated asymptotics of
  `Phi p n = Σ'_j (1 + (j+1)/n)^{-p}` in the critical scaling `p = u·n`.

  This file refines `Op56/PhiAsymptotic.lean`.  The second-order expansion there is

      Phi_{un}(n) = (e^u - 1)^{-1} + (u/2n)·PhiS(u) + O(1/n²) ,

  uniformly for `u ∈ [1/2,1]`.  The third-order target is

      Phi_{un}(n) = (e^u - 1)^{-1} + (u/2n)·PhiS(u) + D(u)/n² + O(1/n³) ,

  where `PhiS(u) = Σ'_k k² e^{-uk}`, `PhiK3u(u) = Σ'_k k³ e^{-uk}`,
  `PhiK4u(u) = Σ'_k k⁴ e^{-uk}` and

      D(u) = -(u/3)·PhiK3u(u) + (u²/8)·PhiK4u(u) .

  At `u = log 2` this is `PhiS = 6`, `PhiK3u = 26`, `PhiK4u = 150` and
  `D(log 2) = -(26/3)log 2 + (75/4)(log 2)²`, the constant that produces the OP-5
  `c/n` term `c = 3(log 2)² - (25/12)log 2`.

  ## The mechanism

  With `k = j+1`, `x = k/n`, `s = un`, `d = s(x - log(1+x)) = y - z + eps` where
  `y = sx²/2`, `z = sx³/3` and `eps = s(x - log(1+x) - x²/2 + x³/3)`, one has **exactly**
  `T_k = G_k·e^d` with `G_k = e^{-uk}`.  Writing `e^d = 1 + y - z + h`, the `e^d` factor
  cancels against `G_k` (turning `G_k e^d` back into `T_k`, which is what keeps the
  `exp d` term from blowing up); the remainder is bounded by a polynomial of degree
  `≤ 6` in `k` times `n^{-3}`, weighted by `e^{-uk/2}`.

  ## Status

  **Complete and proved; this file carries 0 `sorry`.**  It contains the sharp quartic
  log-remainder bound `phi_r4_bounds`, the per-term third-order bound `phi_term_sharp3`
  (with its sub-lemmas), the `n^{-3}` finite and tail sums, the `D(u)` layer, the
  `Phi_third_order` assembly, the threshold inversion, and the whole OP-6 estimate chain
  (`L_bounded`, `PhiC`, `PhiC_le`).

  The historical plan that produced them is `open/HANDOFF.md` §7; the authoritative
  current account is `../../006/handoff.md` §5.  The three asymptotic theorems are
  stated and proved in `Op56/Asymptotic.lean`.
-/

import Op56.PhiAsymptotic

namespace Op56

set_option maxHeartbeats 2000000

noncomputable section

open scoped BigOperators Topology
open MeasureTheory

/-- **The quartic log remainder bounds.**  For `x ∈ [0,1]`,
`0 ≤ x - log(1+x) - x²/2 + x³/3` and `x - log(1+x) - x²/2 + x³/3 ≤ x⁴/2`.

The first bound is `log_one_add_le_cubic` (`Op56/PhiAsymptotic.lean`); the second is the
sharp one on `[0,1]` (the naive `x⁴/4` of `phi_r_bounds` is not enough). -/
lemma phi_r4_bounds (x : ℝ) (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    0 ≤ x - Real.log (1 + x) - x^2/2 + x^3/3
      ∧ x - Real.log (1 + x) - x^2/2 + x^3/3 ≤ x^4/2 := by
  have h1 := log_one_add_le_cubic x hx0
  have hA : x - Real.log (1 + x) - x^2/2 + x^3/3 ≤ x^4/4 :=
    (Op56.phi_r_bounds x hx0).2
  have h4n : (0:ℝ) ≤ x^4 := pow_nonneg hx0 4
  have h4b : x - Real.log (1 + x) - x^2/2 + x^3/3 ≤ x^4/2 := by linarith
  exact ⟨by linarith [h1], h4b⟩

/-! ### Exponential remainders for the third-order term -/

/-- **Quadratic exponential remainder** (nonnegative argument).

For `0 ≤ t ≤ 1/2`, `|exp t - 1 - t| ≤ 2 t²`.

This is the order-2 Taylor estimate refined by `Real.exp_bound'` at `n = 3`.  It is the
quantitative form of the cubic log bound that the third-order termwise estimate needs. -/
lemma exp_rem_pos (t : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1/2) :
    |Real.exp t - 1 - t| ≤ 2 * t^2 := by
  have h3 := Real.exp_bound' (x := t) h0 (by linarith) (n := 3) (by norm_num)
  have hsum : (∑ m ∈ Finset.range 3, t^m / (↑m.factorial : ℝ)) = 1 + t + t^2/2 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]
    norm_num
  rw [hsum] at h3
  have hrem : t^3 * (↑3 + 1) / (↑(Nat.factorial 3) * ↑3) ≤ (1/2) * t^2 := by
    have h4 : (↑(Nat.factorial 3) * (↑3:ℝ)) = 18 := by norm_num [Nat.factorial]
    rw [h4]
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 18)]
    have h5 : t^3 ≤ t^2 := by nlinarith [h0, h1, sq_nonneg t]
    nlinarith [h5, sq_nonneg t]
  have hexp : Real.exp t ≤ 1 + t + 2 * t^2 := by nlinarith [h3, hrem, h0, h1, sq_nonneg t]
  have hnn : (0:ℝ) ≤ Real.exp t - 1 - t := by
    have h := Real.add_one_le_exp t; linarith
  rw [abs_of_nonneg hnn]
  linarith

/-! ### Remaining work for `phi_term_sharp3` (documented, not yet Lean)

The full termwise bound needs, in addition:

* `exp_rem_two_sq : |exp eps - 1 - eps| ≤ 2 eps²` for `|eps| ≤ 1/2`.  The case `eps ≤ 0`
  reduces to `exp_rem_pos` at `t = -eps` via the exact identity
  `exp eps - 1 - eps = -((1 - exp t + exp t·t) · (exp t)⁻¹)`, together with the two
  arithmetic facts `0 ≤ 1 - E + E t` (from `E ≤ 1 + t + 2t²` and
  `(1+t+2t²)(1-t) = 1 + t² - 2t³ ≤ 1`) and `1 - E + E t ≤ 2t²E` (from `E ≥ 1 + t`).
* the assembly `|T_k - G_k - G_k(y-z)| ≤ C·u·(k³/n² + k⁶/n³)` (see `open/HANDOFF.md` §13).
-/

/-- **The quadratic upper bound on `exp` is enough for the third-order term.**

For `0 ≤ t`, `exp t ≤ 1 + t + t²`, hence `(1 - exp t + exp t·t) ≥ 1 - t³ ≥ 0` for
`t ≤ 1`.  (Using the cruder `exp t ≤ 1 + t + 2t²` makes the statement *false*: with
`E = 1 + t + 2t²` one gets `E(1-t) = 1 + t² - 2t³ > 1` for `0 < t < 1/2`.) -/
lemma first_term_nonneg (t E : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1) (hE : E ≤ 1 + t + t^2) :
    (0:ℝ) ≤ 1 - E + E * t := by
  have hlt : (0:ℝ) ≤ 1 - t := by linarith
  have key : 1 - E + E * t = 1 - E * (1 - t) := by ring
  rw [key]
  have h2 : E * (1 - t) ≤ (1 + t + t^2) * (1 - t) :=
    mul_le_mul_of_nonneg_right hE hlt
  have h3 : (1 + t + t^2) * (1 - t) = 1 - t^3 := by ring
  rw [h3] at h2
  have h4 : (0:ℝ) ≤ t^3 := pow_nonneg h0 3
  linarith [h2, h4]

/-- **Tight quadratic upper bound for `exp`.**  For `0 ≤ t ≤ 1/2`, `exp t ≤ 1 + t + t²`.

This is what the negative branch of `exp_rem_two_sq` needs: the cruder
`exp t ≤ 1 + t + 2t²` is *not* enough, because `(1+t+2t²)(1-t) = 1 + t²(1-2t) > 1`. -/
lemma exp_le_one_add_add_sq (t : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1/2) :
    Real.exp t ≤ 1 + t + t^2 := by
  have h3 := Real.exp_bound' (x := t) h0 (by linarith) (n := 3) (by norm_num)
  have hsum : (∑ m ∈ Finset.range 3, t^m / (↑m.factorial : ℝ)) = 1 + t + t^2/2 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]
    norm_num
  rw [hsum] at h3
  have hrem : t^3 * (↑3 + 1) / (↑(Nat.factorial 3) * ↑3) ≤ (1/2) * t^2 := by
    have h4 : (↑(Nat.factorial 3) * (↑3:ℝ)) = 18 := by norm_num [Nat.factorial]
    rw [h4]
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 18)]
    have h5 : t^3 ≤ t^2 := by nlinarith [h0, h1, sq_nonneg t]
    nlinarith [h5, sq_nonneg t, h1]
  linarith [h3, hrem]

/-- The exact identity behind the negative branch of `exp_rem_two_sq`. -/
lemma exp_neg_rem_eq (t : ℝ) :
    Real.exp (-t) - 1 - (-t) = (1 - Real.exp t + Real.exp t * t) / Real.exp t := by
  have hne : Real.exp t ≠ 0 := Real.exp_ne_zero t
  rw [Real.exp_neg]
  field_simp
  ring

/-- For `t ≤ 1/2`, `t²(1 - 2t) ≥ 0`. -/
lemma sq_one_sub_two_mul_nonneg (t : ℝ) (h1 : t ≤ 1/2) : (0:ℝ) ≤ t^2 * (1 - 2*t) :=
  mul_nonneg (sq_nonneg t) (by linarith)

/-- **Exponential remainder, quadratic form.**  For `|eps| ≤ 1/2`,

    |exp eps - 1 - eps| ≤ 2·eps².

This is the quantitative second-order input for the third-order expansion of `Phi`.
The case `eps ≥ 0` is `exp_rem_pos`; for `eps ≤ 0` one writes `t = -eps` and uses
`exp_neg_rem_eq` together with `first_term_nonneg` and `exp_le_one_add_add_sq`. -/
lemma exp_rem_two_sq (eps : ℝ) (he : |eps| ≤ 1/2) :
    |Real.exp eps - 1 - eps| ≤ 2 * eps^2 := by
  rcases le_total 0 eps with hpos | hneg
  · exact exp_rem_pos eps hpos (by rwa [abs_of_nonneg hpos] at he)
  · set t := -eps with ht
    have ht0 : (0:ℝ) ≤ t := by rw [ht]; linarith
    have ht1 : t ≤ 1/2 := by rw [ht]; rwa [abs_of_nonpos hneg] at he
    have hElow : 1 + t ≤ Real.exp t := by
      have h := Real.add_one_le_exp t; linarith
    have hEup : Real.exp t ≤ 1 + t + t^2 := exp_le_one_add_add_sq t ht0 ht1
    have heps : eps = -t := by rw [ht]; ring
    have hkey : Real.exp eps - 1 - eps = (1 - Real.exp t + Real.exp t * t) / Real.exp t := by
      rw [heps]; exact exp_neg_rem_eq t
    rw [hkey, abs_div, abs_of_pos (Real.exp_pos t)]
    have hlt : (0:ℝ) ≤ 1 - Real.exp t + Real.exp t * t :=
      first_term_nonneg t (Real.exp t) ht0 (by linarith) hEup
    rw [abs_of_nonneg hlt]
    have hnum : 1 - Real.exp t + Real.exp t * t ≤ 2 * t^2 * Real.exp t := by
      have key : 1 - Real.exp t + Real.exp t * t = 1 - Real.exp t * (1 - t) := by ring
      have h2 : Real.exp t * (1 - t) ≥ (1 + t) * (1 - t) :=
        mul_le_mul_of_nonneg_right hElow (by linarith)
      have h3 : (1 + t) * (1 - t) = 1 - t^2 := by ring
      have h4 : Real.exp t * (1 - t) ≥ 1 - t^2 := by linarith [h2, h3]
      nlinarith [key, h4, hElow, ht0, ht1, sq_nonneg t]
    rw [div_le_iff₀ (Real.exp_pos t)]
    linarith [hnum]

/-- **Exponential domination of the `Phi` summand.**  For `1 ≤ k ≤ n`, `1/2 ≤ u`,
`4 ≤ n`,

    (1 + k/n)^{-un} ≤ exp (-u k / 2).

This is the estimate that lets every `k`-power sum in the third-order expansion be
compared against `e^{-uk/2}`; it follows from `log(1+x) ≥ x/2` on `[0,1]`. -/
lemma rpow_le_exp_half (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 4 ≤ n) (hk : 1 ≤ k) (hkn : k ≤ n) :
    (1 + ((k:ℝ)/(n:ℝ))) ^ (-(u * (n:ℝ))) ≤ Real.exp (-(u*(k:ℝ))/2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hx0 : (0:ℝ) < (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; exact_mod_cast hkn
  rw [Real.rpow_def_of_pos (by linarith : (0:ℝ) < 1 + (k:ℝ)/(n:ℝ))]
  apply Real.exp_le_exp.mpr
  have hlog : ((k:ℝ)/(n:ℝ))/2 ≤ Real.log (1 + (k:ℝ)/(n:ℝ)) := by
    have h := log_one_add_ge ((k:ℝ)/(n:ℝ)) hx0.le
    have hx2 : ((k:ℝ)/(n:ℝ))^2 ≤ (k:ℝ)/(n:ℝ) := by nlinarith [hx0, hx1]
    linarith [h, hx2]
  have hmul : (u * (n:ℝ)) * (((k:ℝ)/(n:ℝ))/2) ≤ (u * (n:ℝ)) * Real.log (1 + (k:ℝ)/(n:ℝ)) :=
    mul_le_mul_of_nonneg_left hlog (by positivity)
  have hsimp : (u * (n:ℝ)) * (((k:ℝ)/(n:ℝ))/2) = u*(k:ℝ)/2 := by field_simp
  have h2 : Real.log (1 + (k:ℝ)/(n:ℝ)) * (-(u * (n:ℝ))) ≤ -(u*(k:ℝ)/2) := by
    nlinarith [hmul, hsimp]
  linarith [h2]

/-! ### The geometric bound used by the threshold derivative -/

/-- `exp (-x) ≤ 4/5` for `x ≥ 1/4`, from `exp (1/4) ≥ 5/4`. -/
lemma exp_neg_quarter_le (x : ℝ) (hx : 1/4 ≤ x) : Real.exp (-x) ≤ 4/5 := by
  have h : Real.exp (-x) ≤ Real.exp (-(1/4:ℝ)) := Real.exp_le_exp.mpr (by linarith)
  have h2 : Real.exp (-(1/4:ℝ)) ≤ 4/5 := by
    rw [show Real.exp (-(1/4:ℝ)) = (Real.exp (1/4:ℝ))⁻¹ by rw [← Real.exp_neg]]
    rw [inv_le_comm₀ (Real.exp_pos _) (by norm_num : (0:ℝ) < 4/5)]
    have h3 : (5:ℝ)/4 ≤ Real.exp (1/4:ℝ) := by
      have h1 : 1 + 1/4 ≤ Real.exp (1/4:ℝ) := by
        have := Real.add_one_le_exp (1/4:ℝ); linarith
      linarith
    calc ((4/5:ℝ))⁻¹ = 5/4 := by norm_num
      _ ≤ Real.exp (1/4:ℝ) := h3
  linarith

/-- **Geometric bound.**  For `u ≥ 1/2`, `Σ_k e^{-uk/2} ≤ 6`. -/
lemma tsum_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, Real.exp (-(u*(k:ℝ))/2)) ≤ 6 := by
  have hr : Real.exp (-u/2) ≤ 4/5 := by
    have h := exp_neg_quarter_le (u/2) (by linarith)
    rwa [show (-(u/2) : ℝ) = -u/2 by ring] at h
  have hr1 : Real.exp (-u/2) < 1 := lt_of_le_of_lt hr (by norm_num)
  have h3 : ‖Real.exp (-u/2)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]; exact hr1
  have h4 : (∑' k : ℕ, (Real.exp (-u/2))^k) = (1 - Real.exp (-u/2))⁻¹ :=
    tsum_geometric_of_norm_lt_one h3
  have h5 : (∑' k : ℕ, Real.exp (-(u*(k:ℝ))/2)) = (∑' k : ℕ, (Real.exp (-u/2))^k) := by
    apply tsum_congr; intro k
    rw [← Real.exp_nat_mul]; congr 1; ring
  rw [h5, h4]
  have h6 : (1:ℝ)/5 ≤ 1 - Real.exp (-u/2) := by linarith
  have h7 : (1 - Real.exp (-u/2))⁻¹ ≤ 5 := by
    rw [inv_le_comm₀ (by linarith : (0:ℝ) < 1 - Real.exp (-u/2)) (by norm_num : (0:ℝ) < 5)]
    linarith
  linarith

/-- **Weighted geometric bound.**  For `u ≥ 1/2`, `Σ_k k·e^{-uk/2} ≤ 20`.

Since `e^{-uk/2} = (e^{-u/2})^k ≤ (4/5)^k`, this reduces to the closed form
`Σ_k k·r^k = r/(1-r)² = 20` at `r = 4/5`. -/
lemma tsum_mul_exp_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, (k:ℝ) * Real.exp (-(u*(k:ℝ))/2)) ≤ 20 := by
  have hr' : Real.exp (-(u/2)) ≤ 4/5 := exp_neg_quarter_le (u/2) (by linarith)
  have hr : Real.exp (-u/2) ≤ 4/5 := by
    rwa [show (-(u/2) : ℝ) = -u/2 by ring] at hr'
  have hr0 : (0:ℝ) < Real.exp (-u/2) := Real.exp_pos _
  have hterm : ∀ k : ℕ, (k:ℝ) * Real.exp (-(u*(k:ℝ))/2) ≤ (k:ℝ) * (4/5:ℝ)^k := by
    intro k
    have h1 : Real.exp (-(u*(k:ℝ))/2) = (Real.exp (-u/2))^k := by
      rw [← Real.exp_nat_mul]; congr 1; ring
    rw [h1]
    exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ hr0.le hr k) (Nat.cast_nonneg k)
  have hg : Summable (fun k : ℕ => (k:ℝ) * (4/5:ℝ)^k) := by
    have h : ‖(4/5:ℝ)‖ < 1 := by norm_num
    have h2 := (summable_pow_mul_geometric_of_norm_lt_one 1 h)
    exact h2.congr (fun k => by rw [pow_one])
  have hf : Summable (fun k : ℕ => (k:ℝ) * Real.exp (-(u*(k:ℝ))/2)) := by
    have h : ‖Real.exp (-u/2)‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos hr0]
      exact lt_of_le_of_lt hr (by norm_num)
    have h2 := (summable_pow_mul_geometric_of_norm_lt_one 1 h)
    refine h2.congr (fun k => ?_)
    rw [pow_one, ← Real.exp_nat_mul]; congr 1; ring
  have hcmp := Summable.tsum_le_tsum hterm hf hg
  have hval : (∑' k : ℕ, (k:ℝ) * (4/5:ℝ)^k) = 20 := by
    have h3 : (∑' k : ℕ, (k:ℝ) * (4/5:ℝ)^k) = (∑' k : ℕ, (k:ℝ)^1 * (4/5:ℝ)^k) := by
      apply tsum_congr; intro k; ring
    rw [h3]
    have h4 : ‖(4/5:ℝ)‖ < 1 := by norm_num
    rw [tsum_pow_mul_geometric_of_norm_lt_one 1 h4]
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond, Nat.factorial]
    norm_num
  linarith [hcmp, hval]

/-! ### Lipschitz tools for the threshold equation -/

/-- `1 - exp(-t) ≤ t` for `t ≥ 0`. -/
lemma one_sub_exp_neg_le (t : ℝ) (ht : 0 ≤ t) : 1 - Real.exp (-t) ≤ t := by
  have h : 1 + (-t) ≤ Real.exp (-t) := by
    have := Real.add_one_le_exp (-t); linarith
  linarith

/-- `exp t - 1 ≤ t·exp t` for `t ≥ 0`. -/
lemma exp_sub_one_le (t : ℝ) (ht : 0 ≤ t) : Real.exp t - 1 ≤ t * Real.exp t := by
  have h1 : 1 - Real.exp (-t) ≤ t := one_sub_exp_neg_le t ht
  have he : Real.exp (-t) = (Real.exp t)⁻¹ := by rw [Real.exp_neg]
  rw [he] at h1
  have hpos : (0:ℝ) < Real.exp t := Real.exp_pos t
  have h2 : (1 - (Real.exp t)⁻¹) * Real.exp t ≤ t * Real.exp t :=
    mul_le_mul_of_nonneg_right h1 hpos.le
  have h3 : (1 - (Real.exp t)⁻¹) * Real.exp t = Real.exp t - 1 := by field_simp
  linarith [h2, h3]

/-- **Mean-value form for `exp`.**  For `b ≤ a`, `exp a - exp b ≤ exp a·(a - b)`.

The factor on the right is `exp a`, **not** `exp b`: with `exp b` the statement is *false*
(`a = 1, b = 0` gives `e - 1 ≈ 1.718 > 1`).  This is the exact slip that blocked
rounds 14–16. -/
lemma exp_diff_le_of_le {a b : ℝ} (h : b ≤ a) :
    Real.exp a - Real.exp b ≤ Real.exp a * (a - b) := by
  have ht : (0:ℝ) ≤ a - b := by linarith
  have h2 : Real.exp (a - b) - 1 ≤ (a - b) * Real.exp (a - b) := exp_sub_one_le (a - b) ht
  have hkey : Real.exp a - Real.exp b = Real.exp b * (Real.exp (a - b) - 1) := by
    rw [mul_sub, mul_one]
    rw [show Real.exp b * Real.exp (a - b) = Real.exp a by
      rw [← Real.exp_add]; congr 1; ring]
  rw [hkey]
  have h4 : Real.exp b * (Real.exp (a - b) - 1) ≤ Real.exp b * ((a - b) * Real.exp (a - b)) :=
    mul_le_mul_of_nonneg_left h2 (Real.exp_pos b).le
  have h5 : Real.exp b * ((a - b) * Real.exp (a - b)) = Real.exp a * (a - b) := by
    rw [show Real.exp b * ((a - b) * Real.exp (a - b))
        = (Real.exp b * Real.exp (a - b)) * (a - b) by ring]
    rw [show Real.exp b * Real.exp (a - b) = Real.exp a by
      rw [← Real.exp_add]; congr 1; ring]
  linarith [h4, h5]

/-- **`exp` is 1-Lipschitz on `(-∞,0]`.**  For `x,y ≤ 0`, `|exp x - exp y| ≤ |x - y|`. -/
lemma abs_exp_sub_exp_le' {x y : ℝ} (hx : x ≤ 0) (hy : y ≤ 0) :
    |Real.exp x - Real.exp y| ≤ |x - y| := by
  have hx1 : Real.exp x ≤ 1 := Real.exp_le_one_iff.mpr hx
  have hy1 : Real.exp y ≤ 1 := Real.exp_le_one_iff.mpr hy
  rcases le_total y x with h | h
  · have h1 : Real.exp x - Real.exp y ≤ Real.exp x * (x - y) := exp_diff_le_of_le h
    have hx0 : (0:ℝ) ≤ x - y := by linarith
    have hnn : (0:ℝ) ≤ Real.exp x - Real.exp y := sub_nonneg.mpr (Real.exp_le_exp.mpr h)
    rw [abs_of_nonneg hnn, abs_of_nonneg hx0]
    have h2 : Real.exp x * (x - y) ≤ 1 * (x - y) := mul_le_mul_of_nonneg_right hx1 hx0
    linarith [h1, h2]
  · have h1 : Real.exp y - Real.exp x ≤ Real.exp y * (y - x) := exp_diff_le_of_le h
    have hy0 : (0:ℝ) ≤ y - x := by linarith
    have hnn : (0:ℝ) ≤ Real.exp y - Real.exp x := sub_nonneg.mpr (Real.exp_le_exp.mpr h)
    rw [abs_sub_comm (Real.exp x) (Real.exp y), abs_of_nonneg hnn,
      abs_of_nonpos (by linarith : x - y ≤ 0)]
    have h2 : Real.exp y * (y - x) ≤ 1 * (y - x) := mul_le_mul_of_nonneg_right hy1 hy0
    linarith [h1, h2]

/-! ### Tail decay for the `Phi` threshold sum -/

/-- For `x ≥ 1`: `(log 2 + log x)/2 ≤ log (1+x)`. -/
lemma half_log_two_add_log_le (x : ℝ) (hx : 1 ≤ x) :
    (Real.log 2 + Real.log x) / 2 ≤ Real.log (1 + x) := by
  have hx0 : (0:ℝ) < x := by linarith
  have h2 : 2 * x ≤ (1 + x)^2 := by nlinarith [hx]
  have h3 : Real.log 2 + Real.log x ≤ Real.log ((1+x)^2) := by
    rw [← Real.log_mul (by norm_num : (2:ℝ) ≠ 0) (ne_of_gt hx0)]
    exact Real.log_le_log (by positivity) h2
  rw [Real.log_pow] at h3
  push_cast at h3
  linarith

/-- **Tail decay of the `Phi` summand in the threshold regime.**  For `k ≥ n ≥ 4` and
`1/2 ≤ u`,

    (1 + k/n)^{-un} ≤ 2^{-un/2}·(k/n)^{-un/2},

which is exponentially small in `n` and polynomially small in `k` simultaneously — the
estimate that controls the `k > n` tail of `Φ`.  Proof: `2·(k/n) ≤ (1+k/n)²` and
`Real.rpow_le_rpow_of_nonpos`. -/
lemma rpow_decay_tail (u : ℝ) (n k : ℕ) (hu : 1/2 ≤ u) (hn : 4 ≤ n) (hkn : n ≤ k) :
    (1 + ((k:ℝ)/(n:ℝ))) ^ (-(u * (n:ℝ)))
      ≤ (2:ℝ)^(-(u*(n:ℝ)/2)) * ((k:ℝ)/(n:ℝ))^(-(u*(n:ℝ)/2)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hx : (1:ℝ) ≤ (k:ℝ)/(n:ℝ) := by
    rw [le_div_iff₀ hnR]
    simpa using (show ((n:ℝ)) ≤ (k:ℝ) by exact_mod_cast hkn)
  have hx0 : (0:ℝ) < (k:ℝ)/(n:ℝ) := by linarith
  have hA : (1 + (k:ℝ)/(n:ℝ)) ^ (-(u * (n:ℝ)))
      = ((1 + (k:ℝ)/(n:ℝ))^2) ^ (-(u*(n:ℝ)/2)) := by
    rw [← Real.rpow_natCast (1 + (k:ℝ)/(n:ℝ)) 2,
      ← Real.rpow_mul (by positivity : (0:ℝ) ≤ 1 + (k:ℝ)/(n:ℝ))]
    congr 1; push_cast; ring
  rw [hA]
  have h2 : 2 * ((k:ℝ)/(n:ℝ)) ≤ (1 + (k:ℝ)/(n:ℝ))^2 := by nlinarith [hx0]
  have h3 : (0:ℝ) < 2 * ((k:ℝ)/(n:ℝ)) := by linarith
  have hz : -(u*(n:ℝ)/2) ≤ 0 := by
    have : (0:ℝ) ≤ u*(n:ℝ)/2 := by positivity
    linarith
  have hmono := Real.rpow_le_rpow_of_nonpos h3 h2 hz
  rwa [Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) hx0.le] at hmono

/-! ### Termwise Lipschitz estimate for the threshold sum -/

/-- `|exp x - exp y| ≤ |x - y|·exp (max x y)`. -/
lemma exp_diff_abs_le_max (x y : ℝ) :
    |Real.exp x - Real.exp y| ≤ |x - y| * Real.exp (max x y) := by
  rcases le_total y x with h | h
  · rw [abs_of_nonneg (sub_nonneg.mpr (Real.exp_le_exp.mpr h)),
      abs_of_nonneg (sub_nonneg.mpr h), max_eq_left h]
    calc Real.exp x - Real.exp y ≤ Real.exp x * (x - y) := exp_diff_le_of_le h
      _ = (x - y) * Real.exp x := by ring
  · rw [abs_sub_comm (Real.exp x) (Real.exp y),
      abs_of_nonneg (sub_nonneg.mpr (Real.exp_le_exp.mpr h)),
      abs_of_nonpos (sub_nonpos.mpr h), max_eq_right h]
    calc Real.exp y - Real.exp x ≤ Real.exp y * (y - x) := exp_diff_le_of_le h
      _ = -(x - y) * Real.exp y := by ring

/-- **Termwise Lipschitz estimate.**  For `a ≥ 1`, `u,u' ∈ [1/2,1]`, `n ≥ 4`,

    |a^{-u'n} - a^{-un}| ≤ n·log a·|u'-u|·a^{-n/2}.

The factor `a^{-n/2}` (from `min u u' ≥ 1/2`) is what makes the sum over `k` converge: it
supplies the exponential decay that the plain mean-value bound `n log a·|u'-u|` lacks. -/
lemma rpow_diff_abs_le (a : ℝ) (ha : 1 ≤ a) (n : ℕ) (hn : 4 ≤ n) (u u' : ℝ)
    (hu1 : 1/2 ≤ u) (hu1' : 1/2 ≤ u') :
    |a ^ (-(u'*(n:ℝ))) - a ^ (-(u*(n:ℝ)))|
      ≤ (n:ℝ) * Real.log a * |u' - u| * a ^ (-((n:ℝ)/2)) := by
  have hlog : (0:ℝ) ≤ Real.log a := Real.log_nonneg ha
  have ha0 : (0:ℝ) < a := by linarith
  have hn' : (0:ℝ) < (n:ℝ) := by positivity
  have hc : (0:ℝ) ≤ (n:ℝ) * Real.log a := by positivity
  have h1 : a ^ (-(u'*(n:ℝ))) = Real.exp (-(u'*((n:ℝ)*Real.log a))) := by
    rw [Real.rpow_def_of_pos ha0]; congr 1; ring
  have h2 : a ^ (-(u*(n:ℝ))) = Real.exp (-(u*((n:ℝ)*Real.log a))) := by
    rw [Real.rpow_def_of_pos ha0]; congr 1; ring
  rw [h1, h2]
  have h3 := exp_diff_abs_le_max (-(u'*((n:ℝ)*Real.log a))) (-(u*((n:ℝ)*Real.log a)))
  rw [show max (-(u'*((n:ℝ)*Real.log a))) (-(u*((n:ℝ)*Real.log a)))
      = -(min u u' * ((n:ℝ)*Real.log a)) by
    rw [max_neg_neg, ← min_mul_of_nonneg u' u hc, min_comm u' u]] at h3
  have h5 : Real.exp (-(min u u' * ((n:ℝ)*Real.log a)))
      = a ^ (-(min u u' * (n:ℝ))) := by
    rw [Real.rpow_def_of_pos ha0]; congr 1; ring
  rw [h5] at h3
  have hmin : (1/2:ℝ) ≤ min u u' := le_min hu1 hu1'
  have h6 : a ^ (-(min u u' * (n:ℝ))) ≤ a ^ (-((n:ℝ)/2)) := by
    rw [Real.rpow_def_of_pos ha0, Real.rpow_def_of_pos ha0]
    apply Real.exp_le_exp.mpr
    nlinarith [hlog, hmin, hn']
  have h7 : |-(u'*((n:ℝ)*Real.log a)) - -(u*((n:ℝ)*Real.log a))|
      = (n:ℝ) * Real.log a * |u' - u| := by
    rw [show -(u'*((n:ℝ)*Real.log a)) - -(u*((n:ℝ)*Real.log a))
        = ((n:ℝ)*Real.log a)*(u - u') by ring,
      abs_mul, abs_of_nonneg hc, abs_sub_comm]
  rw [h7] at h3
  calc |Real.exp (-(u'*((n:ℝ)*Real.log a))) - Real.exp (-(u*((n:ℝ)*Real.log a)))|
      ≤ (n:ℝ) * Real.log a * |u' - u| * a ^ (-(min u u' * (n:ℝ))) := h3
    _ ≤ (n:ℝ) * Real.log a * |u' - u| * a ^ (-((n:ℝ)/2)) :=
        mul_le_mul_of_nonneg_left h6 (by positivity)

/-! ### Integral-free tail summation for the Lipschitz bound -/

/-- Tail comparison for negative powers: for `1 ≤ n < k` and `m ≥ 3`,

    k^{-(m-1)} ≤ k^{-2}·n^{-(m-3)}.

Together with the telescoping bound `Σ_{k>n} k^{-2} ≤ 1/n` this gives the **integral-free**
tail estimate `Σ_{k>n} k^{-(m-1)} ≤ n^{2-m}`, which is what the `k > n` part of the
`Φ`-Lipschitz sum needs. -/
lemma pow_neg_tail_le (n k : ℕ) (hn : 1 ≤ n) (hk : n < k) (m : ℝ) (hm : 3 ≤ m) :
    (k:ℝ) ^ (-(m-1)) ≤ (k:ℝ)^((-2:ℝ)) * (n:ℝ)^(-(m-3)) := by
  have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast (by omega : 0 < n)
  have hk0 : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hnk : (n:ℝ) < (k:ℝ) := by exact_mod_cast hk
  have hsplit : (k:ℝ) ^ (-(m-1)) = (k:ℝ)^((-2:ℝ)) * (k:ℝ)^(-(m-3)) := by
    rw [← Real.rpow_add hk0]
    congr 1; ring
  rw [hsplit]
  exact mul_le_mul_of_nonneg_left
    (Real.rpow_le_rpow_of_nonpos hn0 hnk.le (by linarith : -(m-3) ≤ 0))
    (Real.rpow_nonneg hk0.le _)

/-- Finite telescoping identity: `Σ_{i<N} (1/(n+i) - 1/(n+i+1)) = 1/n - 1/(n+N)`. -/
lemma sum_range_inv_sub (n N : ℕ) :
    (∑ i ∈ Finset.range N, (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))))
      = 1/(n:ℝ) - 1/((n:ℝ)+N) := by
  have h := Finset.sum_range_sub (fun i : ℕ => (1/((n:ℝ)+i))) N
  rw [Finset.sum_sub_distrib] at h
  rw [Finset.sum_sub_distrib]
  simp only [Nat.cast_add, Nat.cast_one, Nat.cast_zero, add_zero] at h ⊢
  linarith

/-- Pointwise majorant for the tail: `1/(m+1)² ≤ 1/(m(m+1))` for `m ≥ 1`. -/
lemma inv_succ_sq_le (m : ℕ) (hm : 1 ≤ m) :
    (1/((m:ℝ)+1))^2 ≤ 1/((m:ℝ)*((m:ℝ)+1)) := by
  have hm0 : (0:ℝ) < (m:ℝ) := by exact_mod_cast (by omega : 0 < m)
  have h : (0:ℝ) < (m:ℝ)*((m:ℝ)+1) := by positivity
  rw [div_pow, div_le_div_iff₀ (by positivity) h]
  nlinarith [hm0]

/-- `1/(n+N) → 0` as `N → ∞`. -/
lemma tendsto_inv_nat_add_zero (n : ℕ) :
    Filter.Tendsto (fun N : ℕ => 1/((n:ℝ)+N)) Filter.atTop (𝓝 0) := by
  have h1 : Filter.Tendsto (fun N : ℕ => ((n:ℝ)+N)) Filter.atTop Filter.atTop := by
    rw [Filter.tendsto_atTop]
    intro b
    filter_upwards [Filter.eventually_ge_atTop (Nat.ceil (b - n))] with N hN
    have h2 : b - n ≤ (N:ℝ) := le_trans (Nat.le_ceil _) (by exact_mod_cast hN)
    linarith
  have h2 := tendsto_inv_atTop_zero.comp h1
  have he : (fun N : ℕ => 1/((n:ℝ)+N))
      = (fun r : ℝ => r⁻¹) ∘ (fun N : ℕ => (n:ℝ)+N) := by
    funext N; simp [one_div]
  rw [he]
  exact h2

lemma nonneg_inv_sub_inv_succ (n i : ℕ) (hn : 1 ≤ n) :
    (0:ℝ) ≤ (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))) := by
  have h1 : (0:ℝ) < (n:ℝ)+i := by
    have : (0:ℝ) < (n:ℝ) := by exact_mod_cast (by omega : 0 < n)
    positivity
  have h2 : (n:ℝ)+i ≤ (n:ℝ)+(i+1) := by push_cast; linarith
  have h3 : 1/((n:ℝ)+(i+1)) ≤ 1/((n:ℝ)+i) := one_div_le_one_div_of_le h1 h2
  linarith

lemma hasSum_inv_mul_inv_succ (n : ℕ) (hn : 1 ≤ n) :
    HasSum (fun i : ℕ => (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) (1/(n:ℝ)) := by
  rw [hasSum_iff_tendsto_nat_of_nonneg (fun i => nonneg_inv_sub_inv_succ n i hn)]
  have heq : (fun N : ℕ => ∑ i ∈ Finset.range N, (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))))
      = fun N : ℕ => 1/(n:ℝ) - 1/((n:ℝ)+N) := by
    funext N
    simpa only [Nat.cast_add, Nat.cast_one, Nat.cast_zero, add_zero] using sum_range_inv_sub n N
  rw [heq]
  have := (tendsto_inv_nat_add_zero n).const_sub (1/(n:ℝ))
  simpa using this

lemma tsum_inv_mul_inv_succ (n : ℕ) (hn : 1 ≤ n) :
    (∑' i : ℕ, (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) = 1/(n:ℝ) :=
  (hasSum_inv_mul_inv_succ n hn).tsum_eq

/-- **Tail inverse-square bound.**  For `n ≥ 1`,

    Σ'_i (1/(n+i+1))² ≤ 1/n,

the `tsum` form of `Σ_{k>n} k^{-2} ≤ 1/n`.  Proved by comparison with the telescoping
sum `Σ'_i (1/(n+i) - 1/(n+i+1)) = 1/n` (`inv_succ_sq_le` gives the pointwise bound), so
**no interval integral is involved**. -/
lemma tsum_inv_succ_sq_le (n : ℕ) (hn : 1 ≤ n) :
    (∑' i : ℕ, (1/((n:ℝ)+i+1))^2) ≤ 1/(n:ℝ) := by
  have hf : Summable (fun i : ℕ => (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) :=
    (hasSum_inv_mul_inv_succ n hn).summable
  have hle : ∀ i : ℕ, (1/((n:ℝ)+i+1))^2 ≤ (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))) := by
    intro i
    have hm : 1 ≤ n + i := by omega
    have h := inv_succ_sq_le (n+i) hm
    have he : (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))) = 1/(((n:ℝ)+i)*((n:ℝ)+i+1)) := by
      field_simp; ring
    rw [he]
    convert h using 2 <;> push_cast <;> ring
  have := Summable.tsum_le_tsum hle
    (Summable.of_nonneg_of_le (fun i => by positivity) hle hf) hf
  rwa [tsum_inv_mul_inv_succ n hn] at this

/-! ### Termwise regimes of the Lipschitz sum -/

/-- Finite regime (`1 ≤ k ≤ n`): `n·log(1+k/n)·(1+k/n)^{-n/2} ≤ k·e^{-k/4}`.

Uses `log(1+x) ≤ x` for the factor `n log(1+k/n) ≤ k`, and `log(1+x) ≥ x/2` (valid
`x ≤ 1`) for the decay `(1+k/n)^{-n/2} ≤ e^{-k/4}`. -/
lemma phi_deriv_term_finite (n k : ℕ) (hn : 4 ≤ n) (hk : 1 ≤ k) (hkn : k ≤ n) :
    (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (k:ℝ) * Real.exp (-(k:ℝ)/4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; exact_mod_cast hkn
  have hbase : (0:ℝ) < 1 + (k:ℝ)/(n:ℝ) := by linarith
  have hlog : Real.log (1 + (k:ℝ)/(n:ℝ)) ≤ (k:ℝ)/(n:ℝ) := log_one_add_le _ hbase
  have hlog2 : (k:ℝ)/(n:ℝ)/2 ≤ Real.log (1 + (k:ℝ)/(n:ℝ)) := by
    have h := log_one_add_ge ((k:ℝ)/(n:ℝ)) hx0
    have hx2 : ((k:ℝ)/(n:ℝ))^2 ≤ (k:ℝ)/(n:ℝ) := by nlinarith [hx0, hx1]
    linarith [h, hx2]
  have hrp : (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2)) ≤ Real.exp (-(k:ℝ)/4) := by
    rw [Real.rpow_def_of_pos hbase]
    apply Real.exp_le_exp.mpr
    have h := mul_le_mul_of_nonneg_left hlog2 (by positivity : (0:ℝ) ≤ (n:ℝ)/2)
    have he : ((n:ℝ)/2) * ((k:ℝ)/(n:ℝ)/2) = (k:ℝ)/4 := by field_simp; ring
    linarith [h, he]
  have h1 : (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) ≤ (k:ℝ) := by
    have h := mul_le_mul_of_nonneg_left hlog hnR.le
    have he : (n:ℝ) * ((k:ℝ)/(n:ℝ)) = (k:ℝ) := by field_simp
    linarith [h, he]
  have h2 : (0:ℝ) ≤ (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2)) := Real.rpow_nonneg hbase.le _
  calc (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (k:ℝ) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2)) :=
        mul_le_mul_of_nonneg_right h1 h2
    _ ≤ (k:ℝ) * Real.exp (-(k:ℝ)/4) :=
        mul_le_mul_of_nonneg_left hrp (by positivity)

/-- Tail regime (`n < k`, `n ≥ 12`):
`n·log(1+k/n)·(1+k/n)^{-n/2} ≤ 2^{-n/4}·n³/k²`.

The decay comes from `rpow_decay_tail` at `u = 1/2`, and the reduction to `k^{-2}` from
`(k/n)^{-n/4} ≤ (k/n)^{-3}` (base `≥ 1`, exponents `-n/4 ≤ -3`). -/
lemma phi_deriv_term_tail (n k : ℕ) (hn : 12 ≤ n) (hkn : n < k) :
    (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (2:ℝ)^(-((n:ℝ)/4)) * (n:ℝ)^3 / (k:ℝ)^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hnkR : (n:ℝ) ≤ (k:ℝ) := by exact_mod_cast hkn.le
  have hbase : (0:ℝ) < 1 + (k:ℝ)/(n:ℝ) := by positivity
  have hc : (1:ℝ) ≤ (k:ℝ)/(n:ℝ) := by
    rw [le_div_iff₀ hnR]; simpa using hnkR
  have hlog : Real.log (1 + (k:ℝ)/(n:ℝ)) ≤ (k:ℝ)/(n:ℝ) := log_one_add_le _ hbase
  have h1 : (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) ≤ (k:ℝ) := by
    have h := mul_le_mul_of_nonneg_left hlog hnR.le
    have he : (n:ℝ) * ((k:ℝ)/(n:ℝ)) = (k:ℝ) := by field_simp
    linarith [h, he]
  have hrp := rpow_decay_tail (1/2) n k (by norm_num) (by omega) hkn.le
  have hrp1 : (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (2:ℝ)^(-((n:ℝ)/4)) * ((k:ℝ)/(n:ℝ))^(-((n:ℝ)/4)) := by
    convert hrp using 3 <;> ring
  have hexp : (-((n:ℝ)/4) : ℝ) ≤ -3 := by
    have : (12:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    linarith
  have hmono : ((k:ℝ)/(n:ℝ))^(-((n:ℝ)/4)) ≤ ((k:ℝ)/(n:ℝ))^((-3:ℝ)) :=
    Real.rpow_le_rpow_of_exponent_le hc hexp
  calc (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (k:ℝ) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2)) :=
        mul_le_mul_of_nonneg_right h1 (Real.rpow_nonneg hbase.le _)
    _ ≤ (k:ℝ) * ((2:ℝ)^(-((n:ℝ)/4)) * ((k:ℝ)/(n:ℝ))^(-((n:ℝ)/4))) :=
        mul_le_mul_of_nonneg_left hrp1 hkR.le
    _ ≤ (k:ℝ) * ((2:ℝ)^(-((n:ℝ)/4)) * ((k:ℝ)/(n:ℝ))^((-3:ℝ))) := by
        apply mul_le_mul_of_nonneg_left _ hkR.le
        exact mul_le_mul_of_nonneg_left hmono (Real.rpow_nonneg (by norm_num) _)
    _ = (2:ℝ)^(-((n:ℝ)/4)) * (n:ℝ)^3 / (k:ℝ)^2 := by
        have hcub : ((k:ℝ)/(n:ℝ))^((-3:ℝ)) = (n:ℝ)^3 / (k:ℝ)^3 := by
          rw [show ((-3:ℝ)) = -(3:ℝ) by norm_num,
            Real.rpow_neg (by positivity : (0:ℝ) ≤ (k:ℝ)/(n:ℝ))]
          rw [show ((k:ℝ)/(n:ℝ))^((3:ℝ)) = ((k:ℝ)/(n:ℝ))^(3:ℕ) by
            exact Real.rpow_natCast _ 3]
          rw [div_pow]
          field_simp
        rw [hcub]
        field_simp

/-! ### Summing the finite regime of the Lipschitz estimate -/

lemma tsum_mul_exp_quarter_le :
    (∑' k : ℕ, (k:ℝ) * Real.exp (-(k:ℝ)/4)) ≤ 20 := by
  have h := tsum_mul_exp_le (1/2) (by norm_num)
  rw [show (∑' k : ℕ, (k:ℝ) * Real.exp (-(k:ℝ)/4))
      = (∑' k : ℕ, (k:ℝ) * Real.exp (-((1/2:ℝ)*(k:ℝ))/2)) by
    apply tsum_congr; intro k
    rw [show -((1/2:ℝ)*(k:ℝ))/2 = -(k:ℝ)/4 by ring]]
  exact h

lemma summable_mul_exp_quarter :
    Summable (fun k : ℕ => (k:ℝ) * Real.exp (-(k:ℝ)/4)) := by
  have h : ‖Real.exp (-(1/4:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have h2 := summable_pow_mul_geometric_of_norm_lt_one 1 h
  refine h2.congr (fun k => ?_)
  rw [pow_one, ← Real.exp_nat_mul]
  congr 1; ring

/-- Finite regime of the Lipschitz sum: `Σ_{j<n} n·log(1+(j+1)/n)·(1+(j+1)/n)^{-n/2} ≤ 20`. -/
lemma sum_range_deriv_le (n : ℕ) (hn : 16 ≤ n) :
    (∑ j ∈ Finset.range n, (n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ))
        * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2))) ≤ 20 := by
  have hn4 : 4 ≤ n := by omega
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hterm : ∀ j ∈ Finset.range n,
      (n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ)) * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2))
        ≤ ((j:ℝ)+1) * Real.exp (-((j:ℝ)+1)/4) := by
    intro j hj
    have hjn : j < n := Finset.mem_range.mp hj
    have h := phi_deriv_term_finite n (j+1) hn4 (by omega) (by omega)
    simpa only [Nat.cast_add, Nat.cast_one] using h
  calc (∑ j ∈ Finset.range n, (n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ))
        * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2)))
      ≤ ∑ j ∈ Finset.range n, ((j:ℝ)+1) * Real.exp (-((j:ℝ)+1)/4) :=
        Finset.sum_le_sum hterm
    _ = ∑ k ∈ Finset.range (n+1), (k:ℝ) * Real.exp (-(k:ℝ)/4) := by
        rw [Finset.sum_range_succ']
        simp
    _ ≤ ∑' k : ℕ, (k:ℝ) * Real.exp (-(k:ℝ)/4) :=
        summable_mul_exp_quarter.sum_le_tsum (Finset.range (n+1)) (fun k _ => by positivity)
    _ ≤ 20 := tsum_mul_exp_quarter_le

/-! ### The constant in the Lipschitz bound -/

/-- `2^{-n/4}·n² ≤ 16` for `n ≥ 16`.

Substituting `n = 16 + m`, the bound is `(1 + m/16)² ≤ 2^{m/4}`, which follows from
`1 + m/16 ≤ 2^{m/8}`; the latter is `Real.add_one_le_exp` plus `log 2 ≥ 1/2`
(`Real.log_two_gt_d9`). -/
lemma two_rpow_neg_quarter_mul_sq_le (n : ℕ) (hn : 16 ≤ n) :
    (2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^2 ≤ 16 := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le hn
  push_cast
  have hlog : (1/2:ℝ) ≤ Real.log 2 := by
    have := Real.log_two_gt_d9; linarith
  have hkey : 1 + (m:ℝ)/16 ≤ (2:ℝ)^((m:ℝ)/8) := by
    rw [Real.rpow_def_of_pos (by norm_num : (0:ℝ) < 2)]
    have h := Real.add_one_le_exp (Real.log 2 * ((m:ℝ)/8))
    have h1 : (m:ℝ)/8 * (1/2) ≤ (m:ℝ)/8 * Real.log 2 :=
      mul_le_mul_of_nonneg_left hlog (by positivity)
    have he : (m:ℝ)/8 * (1/2) = (m:ℝ)/16 := by ring
    have he2 : (m:ℝ)/8 * Real.log 2 = Real.log 2 * ((m:ℝ)/8) := by ring
    linarith [h, h1, he, he2]
  have hA2 : (2:ℝ)^((m:ℝ)/8) * (2:ℝ)^((m:ℝ)/8) = (2:ℝ)^((m:ℝ)/4) := by
    rw [← Real.rpow_add (by norm_num : (0:ℝ) < 2)]
    congr 1; ring
  have h16 : ((16:ℝ) + m) ≤ 16 * (2:ℝ)^((m:ℝ)/8) := by
    have h := mul_le_mul_of_nonneg_left hkey (by norm_num : (0:ℝ) ≤ 16)
    have he : (16:ℝ) * (1 + (m:ℝ)/16) = 16 + (m:ℝ) := by ring
    linarith [h, he]
  have hsq : ((16:ℝ) + m)^2 ≤ 256 * (2:ℝ)^((m:ℝ)/4) := by
    have h := pow_le_pow_left₀ (by linarith : (0:ℝ) ≤ (16:ℝ)+m) h16 2
    have h2 : ((16:ℝ) * (2:ℝ)^((m:ℝ)/8))^2 = 256 * (2:ℝ)^((m:ℝ)/4) := by
      rw [mul_pow]
      rw [show ((2:ℝ)^((m:ℝ)/8))^2 = (2:ℝ)^((m:ℝ)/4) by
        rw [← Real.rpow_natCast ((2:ℝ)^((m:ℝ)/8)) 2,
          ← Real.rpow_mul (by norm_num : (0:ℝ) ≤ 2)]
        congr 1; push_cast; ring]
      norm_num
    linarith [h, h2]
  have hsplit : (2:ℝ)^(-(((16:ℝ)+m))/4) = (2:ℝ)^((-4:ℝ)) * (2:ℝ)^(-(m:ℝ)/4) := by
    rw [← Real.rpow_add (by norm_num : (0:ℝ) < 2)]
    congr 1; ring
  have h4 : (2:ℝ)^((-4:ℝ)) = 1/16 := by
    rw [show ((-4:ℝ)) = -(4:ℝ) by norm_num,
      Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2),
      show ((2:ℝ)^((4:ℝ))) = (2:ℝ)^(4:ℕ) by exact Real.rpow_natCast _ 4]
    norm_num
  rw [hsplit, h4]
  have hcancel : (2:ℝ)^(-(m:ℝ)/4) * (2:ℝ)^((m:ℝ)/4) = 1 := by
    rw [← Real.rpow_add (by norm_num : (0:ℝ) < 2)]
    rw [show -(m:ℝ)/4 + (m:ℝ)/4 = 0 by ring, Real.rpow_zero]
  have hfin : (1/16:ℝ) * (2:ℝ)^(-(m:ℝ)/4) * ((16:ℝ)+m)^2
      ≤ (1/16:ℝ) * (2:ℝ)^(-(m:ℝ)/4) * (256 * (2:ℝ)^((m:ℝ)/4)) :=
    mul_le_mul_of_nonneg_left hsq (by positivity)
  nlinarith [hfin, hcancel]

/-! ### Summability of the inverse-square majorant -/

/-- Pointwise form of `inv_succ_sq_le`, against the telescoping summand. -/
lemma inv_succ_sq_le_inv_sub (n i : ℕ) (hn : 1 ≤ n) :
    (1/((n:ℝ)+i+1))^2 ≤ (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))) := by
  have hm : 1 ≤ n + i := by omega
  have h := inv_succ_sq_le (n+i) hm
  have he : (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))) = 1/(((n:ℝ)+i)*((n:ℝ)+i+1)) := by
    field_simp; ring
  rw [he]
  convert h using 2 <;> push_cast <;> ring

/-- Summability of `i ↦ (1/(n+i+1))²`, from the telescoping majorant. -/
lemma summable_inv_succ_sq (n : ℕ) (hn : 1 ≤ n) :
    Summable (fun i : ℕ => (1/((n:ℝ)+i+1))^2) := by
  have hf : Summable (fun i : ℕ => (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) :=
    (hasSum_inv_mul_inv_succ n hn).summable
  exact Summable.of_nonneg_of_le (fun i => by positivity)
    (fun i => inv_succ_sq_le_inv_sub n i hn) hf

/-- **Tail regime summed:** `Σ'_i g (i+n) ≤ 16` for `n ≥ 16`, where
`g j = n·log(1+(j+1)/n)·(1+(j+1)/n)^{-n/2}`.

Termwise `phi_deriv_term_tail` gives `g (i+n) ≤ 2^{-n/4}·n³/(i+n+1)²`, and
`tsum_inv_succ_sq_le` gives `Σ'_i (1/(n+i+1))² ≤ 1/n`, so the tail is
`≤ 2^{-n/4}·n³·(1/n) = 2^{-n/4}·n² ≤ 16` (`two_rpow_neg_quarter_mul_sq_le`). -/
lemma tsum_deriv_shift_le (n : ℕ) (hn : 16 ≤ n) :
    (∑' i : ℕ, (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))) ≤ 16 := by
  have hn12 : 12 ≤ n := by omega
  have hn1 : 1 ≤ n := by omega
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  set C : ℝ := (2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^3 with hC
  have hC0 : (0:ℝ) ≤ C := by rw [hC]; positivity
  have hnn : ∀ i : ℕ, (0:ℝ) ≤ (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
      * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2)) := by
    intro i
    have hx : (1:ℝ) ≤ 1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ) := by
      have : (0:ℝ) ≤ ((i:ℝ)+(n:ℝ)+1)/(n:ℝ) := by positivity
      linarith
    exact mul_nonneg (mul_nonneg (by positivity) (Real.log_nonneg hx))
      (Real.rpow_nonneg (by linarith) _)
  have hterm : ∀ i : ℕ,
      (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ C / (((i:ℝ)+(n:ℝ)+1))^2 := by
    intro i
    have hk : n < i + n + 1 := by omega
    have h := phi_deriv_term_tail n (i+n+1) hn12 hk
    rw [hC]
    have hcast : ((i:ℝ)+(n:ℝ)+1) = ((i+n+1 : ℕ) : ℝ) := by
      simp only [Nat.cast_add, Nat.cast_one]
    rw [hcast, neg_div]
    exact h
  have hmaj : Summable (fun i : ℕ => C / (((i:ℝ)+(n:ℝ)+1))^2) := by
    rw [hC]
    refine ((summable_inv_succ_sq n hn1).mul_left ((2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^3)).congr (fun i => ?_)
    rw [show (((i:ℝ)+(n:ℝ)+1)) = ((n:ℝ)+i+1) by ring]
    rw [div_eq_mul_inv, one_div, inv_pow, div_eq_mul_inv]
  have hsum : Summable (fun i : ℕ => (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))) :=
    Summable.of_nonneg_of_le hnn hterm hmaj
  calc (∑' i : ℕ, (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2)))
      ≤ ∑' i : ℕ, C / (((i:ℝ)+(n:ℝ)+1))^2 := Summable.tsum_le_tsum hterm hsum hmaj
    _ = C * (∑' i : ℕ, (1/((n:ℝ)+i+1))^2) := by
        rw [← tsum_mul_left]
        apply tsum_congr; intro i
        rw [show (((i:ℝ)+(n:ℝ)+1)) = ((n:ℝ)+i+1) by ring]
        rw [div_eq_mul_inv, one_div, inv_pow]
    _ ≤ C * (1/(n:ℝ)) := mul_le_mul_of_nonneg_left (tsum_inv_succ_sq_le n hn1) hC0
    _ = (2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^2 := by
        rw [hC]; field_simp
    _ ≤ 16 := two_rpow_neg_quarter_mul_sq_le n hn

/-! ### The `Φ`-Lipschitz bound -/

/-- Summability of the tail summand
`i ↦ n·log(1+(i+n+1)/n)·(1+(i+n+1)/n)^{-n/2}`, via the majorant
`2^{-n/4}·n³/(i+n+1)²`. -/
lemma summable_deriv_shift (n : ℕ) (hn : 16 ≤ n) :
    Summable (fun i : ℕ => (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))) := by
  have hn12 : 12 ≤ n := by omega
  have hn1 : 1 ≤ n := by omega
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  set C : ℝ := (2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^3 with hC
  have hnn : ∀ i : ℕ, (0:ℝ) ≤ (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
      * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2)) := by
    intro i
    have hx : (1:ℝ) ≤ 1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ) := by
      have : (0:ℝ) ≤ ((i:ℝ)+(n:ℝ)+1)/(n:ℝ) := by positivity
      linarith
    exact mul_nonneg (mul_nonneg (by positivity) (Real.log_nonneg hx))
      (Real.rpow_nonneg (by linarith) _)
  have hterm : ∀ i : ℕ,
      (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ C / (((i:ℝ)+(n:ℝ)+1))^2 := by
    intro i
    have hk : n < i + n + 1 := by omega
    have h := phi_deriv_term_tail n (i+n+1) hn12 hk
    rw [hC]
    have hcast : ((i:ℝ)+(n:ℝ)+1) = ((i+n+1 : ℕ) : ℝ) := by
      simp only [Nat.cast_add, Nat.cast_one]
    rw [hcast, neg_div]
    exact h
  have hmaj : Summable (fun i : ℕ => C / (((i:ℝ)+(n:ℝ)+1))^2) := by
    rw [hC]
    refine ((summable_inv_succ_sq n hn1).mul_left ((2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^3)).congr (fun i => ?_)
    rw [show (((i:ℝ)+(n:ℝ)+1)) = ((n:ℝ)+i+1) by ring]
    rw [div_eq_mul_inv, one_div, inv_pow, div_eq_mul_inv]
  exact Summable.of_nonneg_of_le hnn hterm hmaj

/-- **`Φ` is Lipschitz in the threshold parameter.**  For `u,u' ∈ [1/2,1]` and `n ≥ 16`,

    |Φ (u'·n) n − Φ (u·n) n| ≤ 40·|u' − u|.

The constant is `O(1)` — not `O(n)` — because `∂_pΦ ≈ −2/n`.  The two regimes of the
sum give `20` (finite, `sum_range_deriv_le`) and `16` (tail, `tsum_deriv_shift_le`). -/
lemma Phi_lipschitz_p (u u' : ℝ) (n : ℕ)
    (hu1 : 1/2 ≤ u) (hu1' : 1/2 ≤ u') (hn : 16 ≤ n) :
    |Phi (u'*(n:ℝ)) n - Phi (u*(n:ℝ)) n| ≤ 40 * |u' - u| := by
  have hn1 : 1 ≤ n := by omega
  have hn4 : 4 ≤ n := by omega
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hu0 : (0:ℝ) < u := by linarith
  have hu0' : (0:ℝ) < u' := by linarith
  have hb2 : (2:ℝ) ≤ u * (n:ℝ) := by
    have h : (1/2:ℝ) * 4 ≤ u * (n:ℝ) :=
      mul_le_mul hu1 (by exact_mod_cast hn4) (by norm_num) (by linarith)
    linarith
  have hb2' : (2:ℝ) ≤ u' * (n:ℝ) := by
    have h : (1/2:ℝ) * 4 ≤ u' * (n:ℝ) :=
      mul_le_mul hu1' (by exact_mod_cast hn4) (by norm_num) (by linarith)
    linarith
  set f : ℕ → ℝ := fun j => (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-(u'*(n:ℝ)))
      - (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-(u*(n:ℝ))) with hf
  set g : ℕ → ℝ := fun j => (n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ))
      * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2)) with hg
  have hTs : Summable (fun j : ℕ => (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-(u'*(n:ℝ)))) :=
    summable_phi u' n hn1 hb2'
  have hUs : Summable (fun j : ℕ => (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n hn1 hb2
  have hfs : Summable f := by rw [hf]; exact hTs.sub hUs
  have hdiff : Phi (u'*(n:ℝ)) n - Phi (u*(n:ℝ)) n = ∑' j : ℕ, f j := by
    rw [hf, Phi, Phi, ← hTs.tsum_sub hUs]
  have hterm : ∀ j : ℕ, |f j| ≤ |u' - u| * g j := by
    intro j
    have ha : (1:ℝ) ≤ 1 + ((j:ℝ)+1)/(n:ℝ) := by
      have : (0:ℝ) ≤ ((j:ℝ)+1)/(n:ℝ) := by positivity
      linarith
    have h := rpow_diff_abs_le (1 + ((j:ℝ)+1)/(n:ℝ)) ha n hn4 u u' hu1 hu1'
    rw [hf, hg]
    calc |(1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-(u'*(n:ℝ)))
          - (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-(u*(n:ℝ)))|
        ≤ (n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ)) * |u' - u|
            * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2)) := h
      _ = |u' - u| * ((n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ))
            * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2))) := by ring
  have hfabs : Summable (fun j : ℕ => |f j|) := hfs.abs
  have hbound1 : (∑' j : ℕ, f j) ≤ ∑' j : ℕ, |f j| :=
    Summable.tsum_le_tsum (fun j => le_abs_self _) hfs hfabs
  have hbound2 : -(∑' j : ℕ, f j) ≤ ∑' j : ℕ, |f j| := by
    rw [← tsum_neg]
    exact Summable.tsum_le_tsum (fun j => neg_le_abs _) hfs.neg hfabs
  have hsplit := hfabs.sum_add_tsum_nat_add n
  have hfin : (∑ j ∈ Finset.range n, |f j|) ≤ 20 * |u' - u| := by
    calc (∑ j ∈ Finset.range n, |f j|)
        ≤ ∑ j ∈ Finset.range n, |u' - u| * g j := Finset.sum_le_sum (fun j _ => hterm j)
      _ = |u' - u| * (∑ j ∈ Finset.range n, g j) := by rw [Finset.mul_sum]
      _ ≤ |u' - u| * 20 := by
          apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
          rw [hg]
          exact sum_range_deriv_le n hn
      _ = 20 * |u' - u| := by ring
  have hg_sum : Summable (fun i : ℕ => g (i+n)) := by
    refine (summable_deriv_shift n hn).congr (fun i => ?_)
    rw [hg]
    simp only [Nat.cast_add, Nat.cast_one]
  have htailg : (∑' i : ℕ, g (i+n)) ≤ 16 := by
    have h := tsum_deriv_shift_le n hn
    rw [show (∑' i : ℕ, g (i+n))
        = (∑' i : ℕ, (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
            * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))) by
      apply tsum_congr; intro i
      rw [hg]
      simp only [Nat.cast_add, Nat.cast_one]]
    exact h
  have htail : (∑' i : ℕ, |f (i+n)|) ≤ 16 * |u' - u| := by
    have hshift_sum : Summable (fun i : ℕ => |f (i+n)|) :=
      hfabs.comp_injective (fun a b h => Nat.add_right_cancel h)
    have hmaj_sum : Summable (fun i : ℕ => |u' - u| * g (i+n)) := hg_sum.mul_left _
    calc (∑' i : ℕ, |f (i+n)|) ≤ ∑' i : ℕ, |u' - u| * g (i+n) :=
          Summable.tsum_le_tsum (fun i => hterm (i+n)) hshift_sum hmaj_sum
      _ = |u' - u| * (∑' i : ℕ, g (i+n)) := by rw [tsum_mul_left]
      _ ≤ |u' - u| * 16 := mul_le_mul_of_nonneg_left htailg (abs_nonneg _)
      _ = 16 * |u' - u| := by ring
  rw [hdiff]
  calc |∑' j : ℕ, f j| ≤ ∑' j : ℕ, |f j| := abs_le.mpr ⟨by linarith [hbound2], hbound1⟩
    _ = (∑ j ∈ Finset.range n, |f j|) + ∑' i : ℕ, |f (i+n)| := hsplit.symm
    _ ≤ 20 * |u' - u| + 16 * |u' - u| := add_le_add hfin htail
    _ ≤ 40 * |u' - u| := by linarith [abs_nonneg (u' - u)]

/-! ### The cubic exponential remainder (third-order term) -/

/-- **Cubic exponential remainder.**  For `|d| ≤ 1/2`,

    |exp d - 1 - d - d²/2| ≤ |d|³.

From `Real.exp_bound` at `n = 4` the error after `1 + d + d²/2 + d³/6` is at most
`5|d|⁴/96`, so the total is `|d|³/6 + 5|d|⁴/96 ≤ 37|d|³/192 < |d|³` for `|d| ≤ 1/2`.

This is the tool for the **third-order** termwise expansion
`Φ = (e^u−1)^{-1} + (u/2n)ΦS(u) + D(u)/n² + O(1/n³)` — the one genuinely new analytic
input for `op5_threshold_asymptotic`. -/
lemma exp_rem_cube (d : ℝ) (hd : |d| ≤ 1/2) :
    |Real.exp d - 1 - d - d^2/2| ≤ |d|^3 := by
  have hd1 : |d| ≤ 1 := by linarith
  have h3 := Real.exp_bound (x := d) hd1 (n := 4) (by norm_num)
  have hsum : (∑ m ∈ Finset.range 4, d^m / (↑m.factorial : ℝ))
      = 1 + d + d^2/2 + d^3/6 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]
    norm_num
  rw [hsum] at h3
  have hd0 : (0:ℝ) ≤ |d| := abs_nonneg d
  have hrem : |d|^4 * (5/96) ≤ |d|^3 / 6 := by
    have h : |d|^4 * (5/96) = |d|^3 * (|d| * (5/96)) := by ring
    rw [h]
    have : |d| * (5/96) ≤ 1/6 := by nlinarith [hd, hd0]
    nlinarith [pow_nonneg hd0 3, this]
  have hsplit : Real.exp d - 1 - d - d^2/2
      = (Real.exp d - (1 + d + d^2/2 + d^3/6)) + d^3/6 := by ring
  rw [hsplit]
  set R : ℝ := Real.exp d - (1 + d + d^2/2 + d^3/6) with hR
  have hRe : |R| ≤ |d|^4 * (5/96) := by
    rw [hR]
    convert h3 using 3 <;> ring
  calc |R + d^3/6| ≤ |R| + |d^3/6| := abs_add_le _ _
    _ ≤ |d|^3/6 + |d|^3/6 := by
        apply add_le_add
        · linarith [hRe, hrem]
        · rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 6), abs_pow]
    _ ≤ |d|^3 := by nlinarith [pow_nonneg hd0 3]

/-! ### Setup for the third-order expansion -/

/-- The exponent identity behind the third-order expansion.  With `x = k/n`,

    -un·log(1+x) = -uk + y - z + un·A,
    y = uk²/(2n),  z = uk³/(3n²),  A = x - log(1+x) - x²/2 + x³/3.

`A` is the fourth-order log remainder, and `phi_r4_bounds` bounds it by `[0, x⁴/2]`. -/
lemma phi_log_expand (u : ℝ) (n k : ℕ) (hnR : (0:ℝ) < (n:ℝ)) :
    -(u*(n:ℝ)) * Real.log (1 + (k:ℝ)/(n:ℝ))
      = -(u*(k:ℝ)) + u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := by
  field_simp
  ring

/-- First piece of the `δ` bound: `y = uk²/(2n) ≤ u/8` when `4k² ≤ n`. -/
lemma phi_delta_y_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    u*(k:ℝ)^2/(2*(n:ℝ)) ≤ u/8 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hu0 : (0:ℝ) ≤ u := by linarith
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by norm_num : (0:ℝ) < 8)]
  nlinarith [hk4R, hu0]

/-- Second piece of the `δ` bound: `z = uk³/(3n²) ≤ u/48` when `4k² ≤ n`. -/
lemma phi_delta_z_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    u*(k:ℝ)^3/(3*(n:ℝ)^2) ≤ u/48 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hu0 : (0:ℝ) ≤ u := by linarith
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 3*(n:ℝ)^2) (by norm_num : (0:ℝ) < 48)]
  have h3 : 16*(k:ℝ)^4 ≤ (n:ℝ)^2 := by
    have := mul_self_le_mul_self (by positivity : (0:ℝ) ≤ 4*(k:ℝ)^2) hk4R
    nlinarith [this]
  have hk3 : (k:ℝ)^3 ≤ (k:ℝ)^4 := by
    have h : (k:ℝ)^3 * 1 ≤ (k:ℝ)^3 * (k:ℝ) := mul_le_mul_of_nonneg_left hk1 (by positivity)
    linarith
  nlinarith [h3, hk3, hu0]

/-- Third piece of the `δ` bound: `un·A ≤ u/128` when `4k² ≤ n`.

Uses `phi_r4_bounds` (`A ≤ x⁴/2`) and `k²/n ≤ 1/4`: `n·x⁴/2 = (k²/n)²/(2n) ≤ 1/512`. -/
lemma phi_delta_A_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) ≤ u/128 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; nlinarith [hk4R, hk1]
  have hAle := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).2
  have hA1 : (n:ℝ) * (((k:ℝ)/(n:ℝ))^4/2) ≤ 1/512 := by
    have he : (n:ℝ) * (((k:ℝ)/(n:ℝ))^4/2) = (k:ℝ)^4/(2*(n:ℝ)^3) := by field_simp
    rw [he, div_le_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)^3)]
    have hk2 : (k:ℝ)^2 ≤ (n:ℝ)/4 := by linarith
    have hk4le : (k:ℝ)^4 ≤ (n:ℝ)^2/16 := by
      have := mul_self_le_mul_self (by positivity : (0:ℝ) ≤ (k:ℝ)^2) hk2
      nlinarith [this]
    nlinarith [hk4le, hn16, hnR]
  have h4 : (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) ≤ (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) :=
    mul_le_mul_of_nonneg_left hAle (by positivity)
  have h5 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) = u * ((n:ℝ) * (((k:ℝ)/(n:ℝ))^4/2)) := by ring
  rw [h5] at h4
  have h6 : u * ((n:ℝ) * (((k:ℝ)/(n:ℝ))^4/2)) ≤ u * (1/512) :=
    mul_le_mul_of_nonneg_left hA1 hu0
  linarith [h4, h6]

/-- **The `δ` bound.**  For `4k² ≤ n`, `u ∈ [1/2,1]`,

    |δ| ≤ 1/2,    δ = uk²/(2n) − uk³/(3n²) + un·A,

so the exponential expansion `e^δ = 1 + δ + δ²/2 + O(δ³)` is valid
(`exp_rem_cube` applies).  The three pieces give
`|δ| ≤ u/8 + u/48 + u/128 = 59u/384 < 1/2`. -/
lemma phi_delta_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
      + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)| ≤ 1/2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; nlinarith [hk4R, hk1]
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  have hy := phi_delta_y_bound u n k hu1 hu2 hn hk hk4
  have hz := phi_delta_z_bound u n k hu1 hu2 hn hk hk4
  have hA := phi_delta_A_bound u n k hu1 hu2 hn hk hk4
  have hy0 : (0:ℝ) ≤ u*(k:ℝ)^2/(2*(n:ℝ)) := by positivity
  have hz0 : (0:ℝ) ≤ u*(k:ℝ)^3/(3*(n:ℝ)^2) := by positivity
  have hA0' : (0:ℝ) ≤ (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := mul_nonneg (by positivity) hA0
  rw [abs_le]
  constructor <;> linarith

/-! ### Algebraic setup for the termwise third-order bound -/

/-- `T_k = G·e^δ` with `G = e^{-uk}` and `δ = y - z + un·A`. -/
lemma phi_term_expand (u : ℝ) (n k : ℕ) (hnR : (0:ℝ) < (n:ℝ)) :
    (1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      = Real.exp (-(u*(k:ℝ)))
        * Real.exp (u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
            + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
                - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)) := by
  rw [Real.rpow_def_of_pos (by positivity : (0:ℝ) < 1 + (k:ℝ)/(n:ℝ)),
    ← Real.exp_add]
  congr 1
  linarith [phi_log_expand u n k hnR]

/-- The decomposition used to bound the termwise error:
`e^δ - (1 + y - z + y²/2) = (e^δ - 1 - δ - δ²/2) + sA + (δ² - y²)/2`,
where the middle term is `sA = δ - (y-z)`. -/
lemma phi_term_diff_decomp (d y z : ℝ) :
    Real.exp d - (1 + y - z + y^2/2)
      = (Real.exp d - 1 - d - d^2/2) + (d - (y - z)) + (d^2 - y^2)/2 := by
  ring

/-- `δ² - y²` expanded with `δ = y - z + sA`; the `y²` cancels and
`-2yz` (order `k⁵/n³`) is the leading error term. -/
lemma phi_delta_sq_sub (y z sA : ℝ) :
    (y - z + sA)^2 - y^2 = -2*(y*z) + z^2 + 2*(y-z)*sA + sA^2 := by ring

/-- Quantitative `δ` bound: `|δ| ≤ (59/96)·u·k²/n` for `4k² ≤ n`.

With `k/n ≤ 1/4` and `k²/n ≤ 1/4`, the three pieces satisfy `y ≤ (1/2)T`,
`z ≤ (1/12)T`, `sA ≤ (1/32)T` where `T = u k²/n`; the last uses `16k² ≤ n²`
(from `4k ≤ n`).  Hence `|δ|³ ≤ (59/96)³·u³k⁶/n³ ≈ 0.232·u k⁶/n³`. -/
lemma phi_delta_abs_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
      + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)|
      ≤ (59/96) * u * ((k:ℝ)^2/(n:ℝ)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hkk4 : (k:ℝ) ≤ 4*(k:ℝ) := by linarith [hkR]
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; linarith [hkn, hkk4]
  have hAle := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).2
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  set Y : ℝ := u*(k:ℝ)^2/(2*(n:ℝ)) with hY
  set Z : ℝ := u*(k:ℝ)^3/(3*(n:ℝ)^2) with hZ
  set SA : ℝ := (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) with hSA
  set T : ℝ := u*((k:ℝ)^2/(n:ℝ)) with hT
  have hT0 : (0:ℝ) ≤ T := by rw [hT]; positivity
  have hYb : Y ≤ (1/2)*T := le_of_eq (by rw [hY, hT]; ring)
  have hZb : Z ≤ (1/12)*T := by
    have he : Z = T * ((k:ℝ)/(3*(n:ℝ))) := by rw [hZ, hT]; ring
    rw [he]
    have hk3n : (k:ℝ)/(3*(n:ℝ)) ≤ 1/12 := by
      rw [div_le_iff₀ (by positivity : (0:ℝ) < 3*(n:ℝ))]; linarith [hkn]
    linarith [mul_le_mul_of_nonneg_left hk3n hT0]
  have hSAb : SA ≤ (1/32)*T := by
    have h1 : SA ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by
      rw [hSA]
      have h := mul_le_mul_of_nonneg_left hAle (by positivity : (0:ℝ) ≤ u*(n:ℝ))
      have h2 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) = u*(k:ℝ)^4/(2*(n:ℝ)^3) := by field_simp
      linarith [h, h2]
    have h3 : u*(k:ℝ)^4/(2*(n:ℝ)^3) ≤ (1/32)*T := by
      have he : u*(k:ℝ)^4/(2*(n:ℝ)^3) = T * ((k:ℝ)^2/(2*(n:ℝ)^2)) := by rw [hT]; ring
      rw [he]
      have hsq2 : (k:ℝ)^2/(2*(n:ℝ)^2) ≤ 1/32 := by
        rw [div_le_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)^2)]
        nlinarith [hkn, hnR, hkR, sq_nonneg ((n:ℝ) - 4*(k:ℝ))]
      linarith [mul_le_mul_of_nonneg_left hsq2 hT0]
    linarith [h1, h3]
  have hY0 : (0:ℝ) ≤ Y := by rw [hY]; positivity
  have hZ0 : (0:ℝ) ≤ Z := by rw [hZ]; positivity
  have hSA0 : (0:ℝ) ≤ SA := by rw [hSA]; exact mul_nonneg (by positivity) hA0
  rw [hY, hZ, hSA] at *
  rw [abs_le]
  constructor <;> nlinarith [hY0, hZ0, hSA0, hYb, hZb, hSAb, hT0]

/-- `sA ≤ (1/2)·u·k⁶/n³` (for `k ≥ 1`), the second piece of the termwise third-order
budget, in the sharp `k⁶/n³` form. -/
lemma phi_sA_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)
      ≤ (1/2) * (u * (k:ℝ)^6 / (n:ℝ)^3) := by
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hAle := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) (by positivity) (by
    rw [div_le_one hnR]; linarith [hkn, hkR])).2
  have h1 : (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by
    have h := mul_le_mul_of_nonneg_left hAle (by positivity : (0:ℝ) ≤ u*(n:ℝ))
    have h2 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) = u*(k:ℝ)^4/(2*(n:ℝ)^3) := by field_simp
    linarith [h, h2]
  have h3 : u*(k:ℝ)^4/(2*(n:ℝ)^3) ≤ (1/2) * (u * (k:ℝ)^6 / (n:ℝ)^3) := by
    have he : u*(k:ℝ)^4/(2*(n:ℝ)^3) = (u * (k:ℝ)^6/(n:ℝ)^3) * (1/(2*(k:ℝ)^2)) := by
      field_simp
    rw [he]
    have h4 : 1/(2*(k:ℝ)^2) ≤ 1/2 := by
      rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(k:ℝ)^2) (by norm_num : (0:ℝ) < 2)]
      nlinarith [hk1]
    have h5 : (0:ℝ) ≤ u * (k:ℝ)^6/(n:ℝ)^3 := by positivity
    linarith [mul_le_mul_of_nonneg_left h4 h5]
  linarith [h1, h3]

/-- `|δ|³ ≤ (59/96)³·u·k⁶/n³`. -/
lemma phi_d3_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
      + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)|^3
      ≤ ((59/96)^3) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hu0 : (0:ℝ) ≤ u := by linarith
  set X : ℝ := (k:ℝ)^6/(n:ℝ)^3 with hX
  have hX0 : (0:ℝ) ≤ X := by rw [hX]; positivity
  have habs := phi_delta_abs_bound u n k hu1 hu2 hn hk hk4
  have h1 : |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
      + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)|^3
      ≤ (((59/96) * u * ((k:ℝ)^2/(n:ℝ)))^3) :=
    pow_le_pow_left₀ (abs_nonneg _) habs 3
  have h2 : ((59/96) * u * ((k:ℝ)^2/(n:ℝ)))^3 = ((59/96)^3) * (u^3 * X) := by
    rw [hX, mul_pow, mul_pow, div_pow]
    ring
  have hu3 : u^3 ≤ u := by
    have hu2' : u^2 ≤ 1 := by nlinarith [hu0, hu2]
    have := mul_le_mul_of_nonneg_left hu2' hu0
    nlinarith [this, hu0]
  have h3 : ((59/96)^3) * (u^3 * X) ≤ ((59/96)^3) * (u * X) := by
    apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ (59/96)^3)
    exact mul_le_mul_of_nonneg_right hu3 hX0
  rw [hX] at h3 ⊢
  linarith [h1, h2, h3]

/-! ### The four pieces of the `|δ²−y²|/2` bound -/

/-- `y·z ≤ R/6` with `R = u·k⁶/n³` (needs only `u ≤ k`). -/
lemma phi_yz_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) :
    (u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2))
      ≤ (1/6) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have huk : u ≤ (k:ℝ) := by linarith
  have he : (u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2))
      = u^2*(k:ℝ)^5/(6*(n:ℝ)^3) := by
    field_simp
    ring
  rw [he, div_le_iff₀ (by positivity : (0:ℝ) < 6*(n:ℝ)^3)]
  field_simp
  nlinarith [huk, hu1, hkR, hnR]

/-- `z²/2 ≤ R/288` (needs only `16u ≤ n`). -/
lemma phi_z2_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hk : 1 ≤ k) :
    (u*(k:ℝ)^3/(3*(n:ℝ)^2))^2/2
      ≤ (1/288) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have he : (u*(k:ℝ)^3/(3*(n:ℝ)^2))^2/2 = u^2*(k:ℝ)^6/(18*(n:ℝ)^4) := by
    field_simp
    ring
  rw [he, div_le_iff₀ (by positivity : (0:ℝ) < 18*(n:ℝ)^4)]
  field_simp
  have h16 : 16*u ≤ (n:ℝ) := by nlinarith [hu2, hn16]
  nlinarith [h16, hu2, hn16, hnR, hkR, pow_pos hkR 6]

/-- `y·(u k⁴/(2n³)) ≤ R/64` (needs only `16u ≤ n`). -/
lemma phi_yz2_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hk : 1 ≤ k) :
    (u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^4/(2*(n:ℝ)^3))
      ≤ (1/64) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have he : (u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^4/(2*(n:ℝ)^3))
      = u^2*(k:ℝ)^6/(4*(n:ℝ)^4) := by
    field_simp
    ring
  rw [he, div_le_iff₀ (by positivity : (0:ℝ) < 4*(n:ℝ)^4)]
  field_simp
  have h16 : 16*u ≤ (n:ℝ) := by nlinarith [hu2, hn16]
  nlinarith [h16, hu2, hn16, hnR, hkR, pow_pos hkR 6]

/-- `(u k⁴/(2n³))²/2 ≤ R/8192` (needs only `1024k² ≤ n³`, from `4k² ≤ n`). -/
lemma phi_sA2ub_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2/2
      ≤ (1/8192) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have he : (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2/2 = u^2*(k:ℝ)^8/(8*(n:ℝ)^6) := by
    field_simp
    ring
  rw [he, div_le_iff₀ (by positivity : (0:ℝ) < 8*(n:ℝ)^6)]
  field_simp
  have hsq : (k:ℝ)^2 ≤ (n:ℝ)/4 := by linarith
  have hk4 : (k:ℝ)^4 ≤ ((n:ℝ)/4)^2 := by
    have h := mul_self_le_mul_self (by positivity : (0:ℝ) ≤ (k:ℝ)^2) hsq
    nlinarith [h]
  nlinarith [hk4, hu2, hn16, hnR, hkR]

/-- **Abstract assembly of the `|δ² − y²|/2` bound.**  Pure algebra in four named reals —
no `u`, `n`, `k` or `log` — so the parser and `linarith` both cope.  Instantiated for the
`Φ` summand with `y = uk²/(2n)`, `z = uk³/(3n²)`, `sA = un·A`, `R = u k⁶/n³`. -/
lemma phi_dy2_abstract (y z sA R : ℝ)
    (hy0 : 0 ≤ y) (hz0 : 0 ≤ z) (hsA0 : 0 ≤ sA) (hR0 : 0 ≤ R)
    (hzy : y*z ≤ (1/6)*R) (hz2 : z^2/2 ≤ (1/288)*R)
    (hyz : (|y-z|)*sA ≤ (1/64)*R) (hsA2 : sA^2/2 ≤ (1/8192)*R) :
    |(y - z + sA)^2 - y^2|/2 ≤ (1/5)*R := by
  have hdec : (y - z + sA)^2 - y^2 = -2*(y*z) + z^2 + 2*(y-z)*sA + sA^2 :=
    phi_delta_sq_sub y z sA
  have h5 : |(-2*(y*z)) + z^2 + 2*(y-z)*sA + sA^2|
      ≤ 2*(y*z) + z^2 + 2*((|y-z|)*sA) + sA^2 := by
    have h6 := abs_add_le ((-2*(y*z)) + z^2 + 2*(y-z)*sA) (sA^2)
    have h7 := abs_add_le ((-2*(y*z)) + z^2) (2*(y-z)*sA)
    have h8 := abs_add_le (-2*(y*z)) (z^2)
    have hzsq : |z^2| = z^2 := abs_of_nonneg (sq_nonneg z)
    have hsAsq : |sA^2| = sA^2 := abs_of_nonneg (sq_nonneg sA)
    have h9 : |(-2:ℝ)*(y*z)| = 2*(y*z) := by
      rw [show (-2:ℝ)*(y*z) = -(2*(y*z)) by ring, abs_neg, abs_of_nonneg]
      positivity
    have h10 : |2*(y-z)*sA| = 2*((|y-z|)*sA) := by
      have he : (2:ℝ)*(y-z)*sA = 2*((y-z)*sA) := by ring
      rw [he, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2), abs_mul, abs_of_nonneg hsA0]
    linarith [h6, h7, h8, hzsq, hsAsq, h9, h10]
  have hbound : |(y - z + sA)^2 - y^2|/2 ≤ y*z + z^2/2 + (|y-z|)*sA + sA^2/2 := by
    rw [hdec]
    have h6 := div_le_div_of_nonneg_right h5 (by norm_num : (0:ℝ) ≤ 2)
    have h7 : (2*(y*z) + z^2 + 2*((|y-z|)*sA) + sA^2)/2
        = y*z + z^2/2 + (|y-z|)*sA + sA^2/2 := by ring
    linarith [h6, h7]
  have hsum : y*z + z^2/2 + (|y-z|)*sA + sA^2/2 ≤ (1/5)*R := by
    have hc : (1/6:ℝ) + 1/288 + 1/64 + 1/8192 ≤ 1/5 := by norm_num
    have hRc : ((1/6:ℝ) + 1/288 + 1/64 + 1/8192) * R ≤ (1/5)*R :=
      mul_le_mul_of_nonneg_right hc hR0
    linarith [hzy, hz2, hyz, hsA2, hRc]
  linarith [hbound, hsum]

/-! ### The `|y−z|·sA` piece and the fully instantiated bound -/

lemma phi_hlyz_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)|
      * ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))
      ≤ (1/64) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; linarith [hkn, hkR]
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  have hAle := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).2
  have hy0 : (0:ℝ) ≤ u*(k:ℝ)^2/(2*(n:ℝ)) := by positivity
  have hz0 : (0:ℝ) ≤ u*(k:ℝ)^3/(3*(n:ℝ)^2) := by positivity
  have hsA0 : (0:ℝ) ≤ (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := mul_nonneg (by positivity) hA0
  have hk4' : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have h23 : 2*(k:ℝ) ≤ 3*(n:ℝ) := by linarith [hk4', hnR]
  have hzy2 : u*(k:ℝ)^3/(3*(n:ℝ)^2) ≤ u*(k:ℝ)^2/(2*(n:ℝ)) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 3*(n:ℝ)^2) (by positivity : (0:ℝ) < 2*(n:ℝ))]
    have hkey : 2*(k:ℝ) * (u*(k:ℝ)^2*(n:ℝ)) ≤ 3*(n:ℝ) * (u*(k:ℝ)^2*(n:ℝ)) :=
      mul_le_mul_of_nonneg_right h23 (by positivity)
    linarith [hkey]
  have hle : |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)| ≤ u*(k:ℝ)^2/(2*(n:ℝ)) := by
    rw [abs_le]
    exact ⟨by linarith [hy0, hz0], by linarith [hzy2]⟩
  have hsAub : (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by
    have h := mul_le_mul_of_nonneg_left hAle (by positivity : (0:ℝ) ≤ u*(n:ℝ))
    have h2 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) = u*(k:ℝ)^4/(2*(n:ℝ)^3) := by field_simp
    linarith [h, h2]
  have h1 : |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)|
      * ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))
      ≤ (u*(k:ℝ)^2/(2*(n:ℝ))) * ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)) :=
    mul_le_mul_of_nonneg_right hle hsA0
  have h2 : (u*(k:ℝ)^2/(2*(n:ℝ))) * ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))
      ≤ (u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^4/(2*(n:ℝ)^3)) :=
    mul_le_mul_of_nonneg_left hsAub hy0
  have h3 := phi_yz2_bound u n k hu1 hu2 hn hk
  linarith [h1, h2, h3]

/-- `|δ² − y²|/2 ≤ R/5` for the `Φ` summand. -/
lemma phi_dy2_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))^2
      - (u*(k:ℝ)^2/(2*(n:ℝ)))^2| / 2
      ≤ (1/5) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; linarith [hkn, hkR]
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  have hAle := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).2
  have hsAub : ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)) ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by
    have h := mul_le_mul_of_nonneg_left hAle (by positivity : (0:ℝ) ≤ u*(n:ℝ))
    have h2 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) = u*(k:ℝ)^4/(2*(n:ℝ)^3) := by field_simp
    linarith [h, h2]
  have hsA2' : ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))^2/2
      ≤ (1/8192) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
    have h2 : ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))^2
        ≤ (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2 := by
      have h := mul_self_le_mul_self (mul_nonneg (by positivity) hA0) hsAub
      linarith [h]
    linarith [h2, phi_sA2ub_bound u n k hu1 hu2 hn hk hk4]
  exact phi_dy2_abstract (u*(k:ℝ)^2/(2*(n:ℝ))) (u*(k:ℝ)^3/(3*(n:ℝ)^2))
    ((u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))
    (u * ((k:ℝ)^6/(n:ℝ)^3))
    (by positivity) (by positivity) (mul_nonneg (by positivity) hA0) (by positivity)
    (phi_yz_bound u n k hu1 hu2 hn hk)
    (phi_z2_bound u n k hu1 hu2 hn hk)
    (phi_hlyz_bound u n k hu1 hu2 hn hk hk4)
    hsA2'

/-- **Abstract termwise third-order assembly.**  With `G ≥ 0`, `d`, `y`, `z` named reals,

    |G·e^d − G·(1 + y − z + y²/2)|
      ≤ G·(|e^d − 1 − d − d²/2| + |d − (y−z)| + |(d² − y²)/2|),

i.e. the three error pieces.  Instantiated with `d = y − z + sA`. -/
lemma phi_term_sharp3_abstract (G d y z : ℝ) (hG : 0 ≤ G) :
    |G * Real.exp d - G * (1 + y - z + y^2/2)|
      ≤ G * (|Real.exp d - 1 - d - d^2/2| + |d - (y-z)| + |(d^2 - y^2)/2|) := by
  rw [← mul_sub, abs_mul, abs_of_nonneg hG, phi_term_diff_decomp]
  have h1 := abs_add_le ((Real.exp d - 1 - d - d^2/2) + (d - (y - z))) ((d^2 - y^2)/2)
  have h2 := abs_add_le (Real.exp d - 1 - d - d^2/2) (d - (y - z))
  have h3 : |(Real.exp d - 1 - d - d^2/2) + (d - (y - z)) + (d^2 - y^2)/2|
      ≤ |Real.exp d - 1 - d - d^2/2| + |d - (y - z)| + |(d^2 - y^2)/2| := by
    linarith [h1, h2]
  exact mul_le_mul_of_nonneg_left h3 hG

/-! ### The termwise third-order bound -/

/-- **Termwise third-order bound.**  For `4k² ≤ n`,

    |T_k − G_k(1 + y − z + y²/2)| ≤ 2·u·e^{−uk/2}·k⁶/n³,

where `T_k = (1+k/n)^{-un}`, `G_k = e^{−uk}`, `y = uk²/(2n)`, `z = uk³/(3n²)`.

Assembled from `phi_term_expand` (`T_k = G_k e^δ`), `phi_term_sharp3_abstract` and the
three budget bounds `phi_d3_bound` (0.233), `phi_sA_bound` (0.5), `phi_dy2_bound` (0.2). -/
lemma phi_term_sharp3 (u : ℝ) (n k : ℕ)
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
          - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ 2 * u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; linarith [hkn, hkR]
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  set d : ℝ := u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
      + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) with hd
  have hG0 : (0:ℝ) ≤ Real.exp (-(u*(k:ℝ))) := by positivity
  have hR0 : (0:ℝ) ≤ u * ((k:ℝ)^6/(n:ℝ)^3) := by positivity
  have hsA0 : (0:ℝ) ≤ (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := mul_nonneg (by positivity) hA0
  have hT : (1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      = Real.exp (-(u*(k:ℝ))) * Real.exp d := by
    rw [hd]
    exact phi_term_expand u n k hnR
  have hAbs := phi_term_sharp3_abstract (Real.exp (-(u*(k:ℝ)))) d
      (u*(k:ℝ)^2/(2*(n:ℝ))) (u*(k:ℝ)^3/(3*(n:ℝ)^2)) hG0
  have hdb : |d| ≤ 1/2 := by
    rw [hd]
    exact phi_delta_bound u n k hu1 hu2 hn hk hk4
  have hcube : |Real.exp d - 1 - d - d^2/2| ≤ |d|^3 := exp_rem_cube d hdb
  have hd3 : |d|^3 ≤ ((59/96)^3) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
    rw [hd]
    exact phi_d3_bound u n k hu1 hu2 hn hk hk4
  have hpiece1 : |Real.exp d - 1 - d - d^2/2| ≤ ((59/96)^3) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
    linarith [hcube, hd3]
  have hsA : |d - (u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2))|
      ≤ (1/2) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
    rw [hd]
    have he : (u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))
        - (u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2))
        = (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := by ring
    rw [he, abs_of_nonneg hsA0]
    have h := phi_sA_bound u n k hu1 hu2 hn hk hk4
    have heq : (1/2) * (u * (k:ℝ)^6 / (n:ℝ)^3) = (1/2) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by ring
    linarith [h, heq]
  have hdy2 : |(d^2 - (u*(k:ℝ)^2/(2*(n:ℝ)))^2)/2|
      ≤ (1/5) * (u * ((k:ℝ)^6/(n:ℝ)^3)) := by
    have h := phi_dy2_bound u n k hu1 hu2 hn hk hk4
    have heqy : |((u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))^2
        - (u*(k:ℝ)^2/(2*(n:ℝ)))^2)/2|
        = |(u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3))^2
        - (u*(k:ℝ)^2/(2*(n:ℝ)))^2| / 2 := by
      rw [div_eq_mul_inv, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ (2:ℝ)⁻¹)]
      ring
    rw [hd, heqy]
    exact h
  have hsum : |Real.exp d - 1 - d - d^2/2|
      + |d - (u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2))|
      + |(d^2 - (u*(k:ℝ)^2/(2*(n:ℝ)))^2)/2| ≤ u * ((k:ℝ)^6/(n:ℝ)^3) := by
    linarith [hpiece1, hsA, hdy2, hR0]
  rw [hT]
  calc |Real.exp (-(u*(k:ℝ))) * Real.exp d - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
        - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ Real.exp (-(u*(k:ℝ))) * (|Real.exp d - 1 - d - d^2/2|
          + |d - (u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2))|
          + |(d^2 - (u*(k:ℝ)^2/(2*(n:ℝ)))^2)/2|) := hAbs
    _ ≤ Real.exp (-(u*(k:ℝ))) * (u * ((k:ℝ)^6/(n:ℝ)^3)) :=
        mul_le_mul_of_nonneg_left hsum hG0
    _ ≤ 2 * u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) := by
        have he : Real.exp (-(u*(k:ℝ))) ≤ Real.exp (-(u*(k:ℝ))/2) := by
          apply Real.exp_le_exp.mpr
          nlinarith [hu0, hkR]
        have hX0 : (0:ℝ) ≤ (k:ℝ)^6/(n:ℝ)^3 := by positivity
        have he0 : (0:ℝ) ≤ Real.exp (-(u*(k:ℝ))/2) := le_of_lt (Real.exp_pos _)
        have h1 : Real.exp (-(u*(k:ℝ))) * (u * ((k:ℝ)^6/(n:ℝ)^3))
            ≤ Real.exp (-(u*(k:ℝ))/2) * (u * ((k:ℝ)^6/(n:ℝ)^3)) :=
          mul_le_mul_of_nonneg_right he (by positivity)
        have h3 : (0:ℝ) ≤ u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) :=
          mul_nonneg (mul_nonneg hu0 he0) hX0
        have h2 : Real.exp (-(u*(k:ℝ))/2) * (u * ((k:ℝ)^6/(n:ℝ)^3))
            ≤ 2 * u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) := by
          have heq : Real.exp (-(u*(k:ℝ))/2) * (u * ((k:ℝ)^6/(n:ℝ)^3))
              = u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) := by ring
          rw [heq]
          linarith [h3]
        linarith [h1, h2]

/-! ### The `u`-dependent moment sums `PhiK3u`, `PhiK4u` -/

/-- `PhiK3u u = Σ'_k k³ e^{-uk}`. -/
noncomputable def PhiK3u (u : ℝ) : ℝ := ∑' k : ℕ, (k : ℝ) ^ 3 * Real.exp (-(u * (k : ℝ)))

/-- `PhiK4u u = Σ'_k k⁴ e^{-uk}`. -/
noncomputable def PhiK4u (u : ℝ) : ℝ := ∑' k : ℕ, (k : ℝ) ^ 4 * Real.exp (-(u * (k : ℝ)))

lemma summable_exp_neg_u (u : ℝ) (hu : 1/2 ≤ u) (m : ℕ) :
    Summable (fun k : ℕ => (k:ℝ)^m * Real.exp (-(u*(k:ℝ)))) := by
  have h1 : ‖Real.exp (-(1/2:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have hg : Summable (fun k : ℕ => (k:ℝ)^m * (Real.exp (-(1/2:ℝ)))^k) :=
    summable_pow_mul_geometric_of_norm_lt_one m h1
  refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_) hg
  have he : Real.exp (-(u*(k:ℝ))) = (Real.exp (-u))^k := by
    rw [show -(u*(k:ℝ)) = (k:ℝ)*(-u) by ring, Real.exp_nat_mul]
  rw [he]
  have hu' : Real.exp (-u) ≤ Real.exp (-(1/2:ℝ)) := Real.exp_le_exp.mpr (by linarith)
  have h0 : (0:ℝ) ≤ Real.exp (-u) := le_of_lt (Real.exp_pos _)
  exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hu' k) (by positivity)

lemma summable_PhiK3u (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(u*(k:ℝ)))) :=
  summable_exp_neg_u u hu 3

lemma summable_PhiK4u (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(u*(k:ℝ)))) :=
  summable_exp_neg_u u hu 4

/-- Uniform bound `Σ_k k⁶ e^{−uk/2} ≤ 4·10¹⁰` for `u ≥ 1/2`, via the closed form
`∑' n, n^m r^n = Σ_j S(m,j)·j!·r^j/(1−r)^{j+1}` (`tsum_pow_mul_geometric_of_norm_lt_one`)
with `r = e^{−u/2} ≤ 4/5`.  This is the constant multiplying `n^{-3}` in the
third-order error. -/
lemma tsum_pow6_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10 := by
  have hr0 : (0:ℝ) ≤ Real.exp (-u/2) := le_of_lt (Real.exp_pos _)
  have hr1 : Real.exp (-u/2) < 1 := Real.exp_lt_one_iff.mpr (by linarith)
  have hr45 : Real.exp (-u/2) ≤ 4/5 := by
    have h := exp_neg_quarter_le (u/2) (show (1:ℝ)/4 ≤ u/2 by linarith)
    rw [show -(u/2) = -u/2 by ring] at h
    exact h
  have hq : (0:ℝ) < 1 - Real.exp (-u/2) := by linarith
  have heq : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2))
      = (∑' k : ℕ, (k:ℝ)^6 * (Real.exp (-u/2))^k) := by
    apply tsum_congr; intro k
    rw [show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
  rw [heq, tsum_pow_mul_geometric_of_norm_lt_one 6 (by
    rw [Real.norm_eq_abs, abs_of_nonneg hr0]; exact hr1)]
  have hterm : ∀ j : ℕ, (Real.exp (-u/2))^j / (1 - Real.exp (-u/2))^(j+1) ≤ 5^(j+1) := by
    intro j
    rw [div_le_iff₀ (by positivity : (0:ℝ) < (1 - Real.exp (-u/2))^(j+1))]
    have h1 : (1:ℝ) ≤ 5*(1 - Real.exp (-u/2)) := by linarith
    have h2 : (Real.exp (-u/2))^j ≤ 1 := pow_le_one₀ hr0 (le_trans hr45 (by norm_num))
    calc (Real.exp (-u/2))^j ≤ 1 := h2
      _ ≤ (5*(1 - Real.exp (-u/2)))^(j+1) := one_le_pow₀ h1
      _ = 5^(j+1) * (1 - Real.exp (-u/2))^(j+1) := by rw [mul_pow]
  have hb : ∀ j ∈ Finset.range 7,
      (Nat.stirlingSecond 6 j : ℝ) * (j.factorial : ℝ) * (Real.exp (-u/2))^j
        / (1 - Real.exp (-u/2))^(j+1)
      ≤ 72000 * 5^(j+1) := by
    intro j hj
    have hj7 : j ≤ 6 := by
      have := Finset.mem_range.mp hj; omega
    have hs : (Nat.stirlingSecond 6 j : ℝ) ≤ 100 := by
      have h : Nat.stirlingSecond 6 j ≤ 100 := by
        interval_cases j <;> norm_num [Nat.stirlingSecond]
      exact_mod_cast h
    have hf : (j.factorial : ℝ) ≤ 720 := by
      have h : j.factorial ≤ 720 := by
        interval_cases j <;> norm_num [Nat.factorial]
      exact_mod_cast h
    have ht := hterm j
    have hs0 : (0:ℝ) ≤ (Nat.stirlingSecond 6 j : ℝ) := by positivity
    have hf0 : (0:ℝ) ≤ (j.factorial : ℝ) := by positivity
    have hsj : (Nat.stirlingSecond 6 j : ℝ) * (j.factorial : ℝ) ≤ 100 * 720 := by nlinarith
    have hdiv0 : (0:ℝ) ≤ (Real.exp (-u/2))^j / (1 - Real.exp (-u/2))^(j+1) := by positivity
    calc (Nat.stirlingSecond 6 j : ℝ) * (j.factorial : ℝ) * (Real.exp (-u/2))^j
          / (1 - Real.exp (-u/2))^(j+1)
        = ((Nat.stirlingSecond 6 j : ℝ) * (j.factorial : ℝ))
            * ((Real.exp (-u/2))^j / (1 - Real.exp (-u/2))^(j+1)) := by ring
      _ ≤ (100 * 720) * 5^(j+1) := by
          apply mul_le_mul hsj ht hdiv0 (by positivity)
      _ = 72000 * 5^(j+1) := by norm_num
  have hgeom : (∑ j ∈ Finset.range 7, 72000 * 5^(j+1)) ≤ 4*10^10 := by
    have h : (∑ j ∈ Finset.range 7, 72000 * 5^(j+1)) = 72000 * 97655 := by
      simp [Finset.sum_mul]
      norm_num [Finset.sum_range_succ]
    rw [h]; norm_num
  linarith [Finset.sum_le_sum hb, hgeom]

/-- **Finite-regime summed error.**  Over any `Finset` of indices with `k ≥ 1` and
`4k² ≤ n`, the total third-order error is `≤ 8·10¹⁰/n³`.

Combines `phi_term_sharp3` termwise with `tsum_pow6_exp_neg_half_le`. -/
lemma phi_err_sum_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (s : Finset ℕ) (hs1 : ∀ k ∈ s, 1 ≤ k) (hs : ∀ k ∈ s, 4*k^2 ≤ n) :
    ∑ k ∈ s, |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
            - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ 8*10^10 / (n:ℝ)^3 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hsum6 : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10 :=
    tsum_pow6_exp_neg_half_le u hu1
  have h1 : ∀ k ∈ s, |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
          - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ 2*u*Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) := by
    intro k hk
    exact phi_term_sharp3 u n k hu1 hu2 hn (hs1 k hk) (hs k hk)
  have hsm : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
    have h1 : ‖Real.exp (-(1/4:ℝ))‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      norm_num
    have hg : Summable (fun k : ℕ => (k:ℝ)^6 * (Real.exp (-(1/4:ℝ)))^k) :=
      summable_pow_mul_geometric_of_norm_lt_one 6 h1
    refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_) hg
    have he : Real.exp (-(u*(k:ℝ))/2) = (Real.exp (-u/2))^k := by
      rw [show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
    rw [he]
    have hu' : Real.exp (-u/2) ≤ Real.exp (-(1/4:ℝ)) := Real.exp_le_exp.mpr (by linarith)
    have h0 : (0:ℝ) ≤ Real.exp (-u/2) := le_of_lt (Real.exp_pos _)
    exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hu' k) (by positivity)
  have hfac : ∀ k : ℕ, 2*u*Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3)
      = (2*u/(n:ℝ)^3) * ((k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
    intro k; ring
  calc ∑ k ∈ s, |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
            - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ ∑ k ∈ s, 2*u*Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3) :=
        Finset.sum_le_sum h1
    _ = ∑ k ∈ s, (2*u/(n:ℝ)^3) * ((k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
        apply Finset.sum_congr rfl; intro k hk; exact hfac k
    _ = (2*u/(n:ℝ)^3) * ∑ k ∈ s, ((k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
        rw [Finset.mul_sum]
    _ ≤ (2*u/(n:ℝ)^3) * ∑' k : ℕ, ((k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        exact Summable.sum_le_tsum s (fun k _ => by positivity) hsm
    _ ≤ (2*u/(n:ℝ)^3) * (4*10^10) := by
        apply mul_le_mul_of_nonneg_left hsum6 (by positivity)
    _ ≤ 8*10^10 / (n:ℝ)^3 := by
        have h : 2*u/(n:ℝ)^3 * (4*10^10) = 8*10^10 * u / (n:ℝ)^3 := by ring
        rw [h, div_le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^3) (by positivity : (0:ℝ) < (n:ℝ)^3)]
        have hn3 : (0:ℝ) < (n:ℝ)^3 := by positivity
        nlinarith [hu2, hn3]

/-! ### The model sum `PhiMain` and its exact decomposition -/

/-- The "main" model sum `Σ'_k G_k(1 + y − z + y²/2)` over `k ≥ 0`. -/
noncomputable def PhiMain (u : ℝ) (n : ℕ) : ℝ :=
  ∑' k : ℕ, Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
      - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)

/-- `Σ'_k e^{-uk} = (e^u − 1)^{-1} + 1`. -/
lemma tsum_exp_neg_mul_eq (u : ℝ) (hu : 0 < u) :
    (∑' k : ℕ, Real.exp (-(u*(k:ℝ)))) = (Real.exp u - 1)⁻¹ + 1 := by
  have heq : (∑' k : ℕ, Real.exp (-(u*(k:ℝ)))) = ∑' k : ℕ, (Real.exp (-u))^k := by
    apply tsum_congr; intro k
    rw [show -(u*(k:ℝ)) = (k:ℝ)*(-u) by ring, Real.exp_nat_mul]
  rw [heq, tsum_geometric_of_norm_lt_one (by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith)]
  have h1 : Real.exp u - 1 ≠ 0 := by
    have : (1:ℝ) < Real.exp u := by
      rw [← Real.exp_zero]; exact Real.exp_lt_exp.mpr hu
    linarith
  have h2 : (1:ℝ) - Real.exp (-u) ≠ 0 := by
    have : Real.exp (-u) < 1 := Real.exp_lt_one_iff.mpr (by linarith)
    linarith
  rw [inv_eq_iff_eq_inv]
  field_simp
  rw [Real.exp_neg]
  field_simp
  ring

/-- The model sum decomposes into the four moment sums. -/
lemma PhiMain_eq (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 1 ≤ n) :
    PhiMain u n = (Real.exp u - 1)⁻¹ + 1 + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2 := by
  have hu0 : (0:ℝ) < u := by linarith
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
  have hA : Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ)))) := by
    simpa using summable_exp_neg_u u hu1 0
  have hB : Summable (fun k : ℕ => (u/(2*(n:ℝ))) * ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 2).mul_left _
  have hC : Summable (fun k : ℕ => (u/(3*(n:ℝ)^2)) * ((k:ℝ)^3 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 3).mul_left _
  have hD : Summable (fun k : ℕ => (u^2/(8*(n:ℝ)^2)) * ((k:ℝ)^4 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 4).mul_left _
  have hkey : ∀ k : ℕ, Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
        - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)
      = Real.exp (-(u*(k:ℝ)))
        + (u/(2*(n:ℝ))) * ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ))))
        - (u/(3*(n:ℝ)^2)) * ((k:ℝ)^3 * Real.exp (-(u*(k:ℝ))))
        + (u^2/(8*(n:ℝ)^2)) * ((k:ℝ)^4 * Real.exp (-(u*(k:ℝ)))) := by
    intro k
    have hE : Real.exp (-(u*(k:ℝ))) ≠ 0 := ne_of_gt (Real.exp_pos _)
    field_simp
    ring
  rw [PhiMain, tsum_congr hkey]
  have hAB : Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ)))
      + (u/(2*(n:ℝ))) * ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ))))) := hA.add hB
  have hABC : Summable (fun k : ℕ => (Real.exp (-(u*(k:ℝ)))
      + (u/(2*(n:ℝ))) * ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))))
      - (u/(3*(n:ℝ)^2)) * ((k:ℝ)^3 * Real.exp (-(u*(k:ℝ))))) := hAB.sub hC
  rw [Summable.tsum_add hABC hD, Summable.tsum_sub hAB hC, Summable.tsum_add hA hB,
    tsum_mul_left, tsum_mul_left, tsum_mul_left,
    tsum_exp_neg_mul_eq u hu0, PhiS, PhiK3u, PhiK4u]
  field_simp
  ring

/-- For `m ≤ 6` and `u ≥ 1/2`, `Σ_k k^m e^{−uk/2} ≤ 4·10¹⁰ + 5`. -/
lemma tsum_pow_le_six_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) (m : ℕ) (hm : m ≤ 6) :
    (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10 + 5 := by
  have h6 := tsum_pow6_exp_neg_half_le u hu
  have hu0 : (0:ℝ) < u := by linarith
  rcases Nat.eq_zero_or_pos m with hm0 | hm0
  · subst hm0
    have heq : (∑' k : ℕ, (k:ℝ)^0 * Real.exp (-(u*(k:ℝ))/2))
        = ∑' k : ℕ, (Real.exp (-u/2))^k := by
      apply tsum_congr; intro k
      rw [pow_zero, one_mul, show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
    rw [heq, tsum_geometric_of_norm_lt_one (by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith)]
    have hr : Real.exp (-u/2) ≤ 4/5 := by
      have h := exp_neg_quarter_le (u/2) (show (1:ℝ)/4 ≤ u/2 by linarith)
      rw [show -(u/2) = -u/2 by ring] at h
      exact h
    have hq : (0:ℝ) < 1 - Real.exp (-u/2) := by linarith
    have h5 : (1:ℝ) - Real.exp (-u/2) ≥ 1/5 := by linarith
    have hb : (1:ℝ)/(1 - Real.exp (-u/2)) ≤ 5 := by
      rw [div_le_iff₀ hq]
      linarith
    simpa [one_div] using le_trans hb (show (5:ℝ) ≤ 4*10^10 + 5 by norm_num)
  · have hsm : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
      have h1 : ‖Real.exp (-(1/4:ℝ))‖ < 1 := by
        rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
        norm_num
      have hg : Summable (fun k : ℕ => (k:ℝ)^6 * (Real.exp (-(1/4:ℝ)))^k) :=
        summable_pow_mul_geometric_of_norm_lt_one 6 h1
      refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_) hg
      have he : Real.exp (-(u*(k:ℝ))/2) = (Real.exp (-u/2))^k := by
        rw [show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
      rw [he]
      have hu' : Real.exp (-u/2) ≤ Real.exp (-(1/4:ℝ)) := Real.exp_le_exp.mpr (by linarith)
      have h0 : (0:ℝ) ≤ Real.exp (-u/2) := le_of_lt (Real.exp_pos _)
      exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hu' k) (by positivity)
    have hle : ∀ k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))/2)
        ≤ (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2) := by
      intro k
      rcases Nat.eq_zero_or_pos k with hk0 | hk
      · subst hk0
        have : (0:ℝ)^m = 0 := zero_pow (by omega : m ≠ 0)
        simp [this]
      · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
        exact mul_le_mul_of_nonneg_right (pow_le_pow_right₀ hk1 hm) (by positivity)
    have hsm2 : Summable (fun k : ℕ => (k:ℝ)^m * Real.exp (-(u*(k:ℝ))/2)) :=
      Summable.of_nonneg_of_le (fun k => by positivity) hle hsm
    calc (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))/2))
        ≤ ∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2) :=
          Summable.tsum_le_tsum hle hsm2 hsm
      _ ≤ 4*10^10 := h6
      _ ≤ 4*10^10 + 5 := by norm_num

lemma summable_pow6_exp_half (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun j : ℕ => (j:ℝ)^6 * Real.exp (-(u*(j:ℝ))/2)) := by
  have h1 : ‖Real.exp (-(1/4:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have hg : Summable (fun j : ℕ => (j:ℝ)^6 * (Real.exp (-(1/4:ℝ)))^j) :=
    summable_pow_mul_geometric_of_norm_lt_one 6 h1
  refine Summable.of_nonneg_of_le (fun j => by positivity) (fun j => ?_) hg
  have he : Real.exp (-(u*(j:ℝ))/2) = (Real.exp (-u/2))^j := by
    rw [show -(u*(j:ℝ))/2 = (j:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
  rw [he]
  have hu' : Real.exp (-u/2) ≤ Real.exp (-(1/4:ℝ)) := Real.exp_le_exp.mpr (by linarith)
  have h0 : (0:ℝ) ≤ Real.exp (-u/2) := le_of_lt (Real.exp_pos _)
  exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hu' j) (by positivity)

/-- Shifted tail moment bound: for `K ≥ 1`, `m ≤ 6`,
`Σ_i (i+K)^m e^{−u(i+K)} ≤ e^{−uK/2}·(4·10¹⁰+5)`. -/
lemma tsum_shift_pow_exp_le (u : ℝ) (hu : 1/2 ≤ u) (K m : ℕ) (hK : 1 ≤ K) (hm : m ≤ 6) :
    (∑' i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) := by
  have hu0 : (0:ℝ) < u := by linarith
  have hK0 : (0:ℝ) < (K:ℝ) := by exact_mod_cast hK
  have hsm6 := summable_pow6_exp_half u hu
  have hshift6 : (∑' i : ℕ, ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))/2)) ≤ 4*10^10 + 5 := by
    have hsplit := hsm6.sum_add_tsum_nat_add K
    simp only [Nat.cast_add] at hsplit
    have hb := tsum_pow_le_six_exp_neg_half_le u hu 6 (le_refl 6)
    have h0 : (0:ℝ) ≤ ∑ i ∈ Finset.range K, (i:ℝ)^6 * Real.exp (-(u*(i:ℝ))/2) := by positivity
    have h1 : (∑' i : ℕ, ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))/2))
        ≤ ∑' i : ℕ, (i:ℝ)^6 * Real.exp (-(u*(i:ℝ))/2) := by linarith [hsplit, h0]
    linarith [h1, hb]
  have hle : ∀ i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)
      ≤ ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))/2) := by
    intro i
    have hK1 : (1:ℝ) ≤ (K:ℝ) := by exact_mod_cast hK
    have h1 : (1:ℝ) ≤ (i:ℝ)+(K:ℝ) := by
      have hi : (0:ℝ) ≤ (i:ℝ) := by positivity
      linarith
    exact mul_le_mul_of_nonneg_right (pow_le_pow_right₀ h1 hm) (by positivity)
  have hsm6' : Summable (fun i : ℕ => ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))/2)) := by
    have := (summable_nat_add_iff K).2 hsm6
    refine this.congr (fun i => ?_)
    simp [Nat.cast_add]
  have hsm' : Summable (fun i : ℕ => ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) :=
    Summable.of_nonneg_of_le (fun i => by positivity) hle hsm6'
  have hle6 : (∑' i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) ≤ 4*10^10 + 5 := by
    have h2 := Summable.tsum_le_tsum hle hsm' hsm6'
    linarith [h2, hshift6]
  have houter : ∀ i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K)))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) := by
    intro i
    have he : Real.exp (-(u*((i:ℝ)+K)))
        ≤ Real.exp (-(u*(K:ℝ))/2) * Real.exp (-(u*((i:ℝ)+K))/2) := by
      rw [← Real.exp_add]
      apply Real.exp_le_exp.mpr
      have hi : (0:ℝ) ≤ (i:ℝ) := by positivity
      nlinarith [hu0, hi, hK0]
    calc ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K)))
        ≤ ((i:ℝ)+K)^m * (Real.exp (-(u*(K:ℝ))/2) * Real.exp (-(u*((i:ℝ)+K))/2)) :=
          mul_le_mul_of_nonneg_left he (by positivity)
      _ = Real.exp (-(u*(K:ℝ))/2) * (((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) := by ring
  have hsmL : Summable (fun i : ℕ => ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K)))) := by
    refine Summable.of_nonneg_of_le (fun i => by positivity) houter ?_
    exact hsm'.mul_left _
  have hsmR : Summable (fun i : ℕ => Real.exp (-(u*(K:ℝ))/2)
      * (((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2))) := hsm'.mul_left _
  have := Summable.tsum_le_tsum houter hsmL hsmR
  rw [tsum_mul_left] at this
  have hpos : (0:ℝ) ≤ Real.exp (-(u*(K:ℝ))/2) := le_of_lt (Real.exp_pos _)
  calc (∑' i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (∑' i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) :=
        this
    _ ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) :=
        mul_le_mul_of_nonneg_left hle6 hpos

/-- The model sum with `Phi`'s own indexing (`k = j+1 ≥ 1`). -/
noncomputable def PhiMainS (u : ℝ) (n : ℕ) : ℝ :=
  ∑' j : ℕ, Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
      - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2)

lemma summable_PhiMain_term (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) :
    Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
      - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)) := by
  have hA := summable_exp_neg_u u hu1 0
  have hB := (summable_exp_neg_u u hu1 2).mul_left (u/(2*(n:ℝ)))
  have hC := (summable_exp_neg_u u hu1 3).mul_left (u/(3*(n:ℝ)^2))
  have hD := (summable_exp_neg_u u hu1 4).mul_left (u^2/(8*(n:ℝ)^2))
  refine (((hA.add hB).sub hC).add hD).congr (fun k => ?_)
  ring

lemma PhiMainS_eq (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 1 ≤ n) :
    PhiMainS u n = (Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2 := by
  have hsm := summable_PhiMain_term u n hu1
  have hsh : PhiMainS u n = PhiMain u n - 1 := by
    have hsplit := hsm.sum_add_tsum_nat_add 1
    simp only [Finset.sum_range_one] at hsplit
    have hf0 : Real.exp (-(u*(((0:ℕ)):ℝ))) * (1 + u*(((0:ℕ)):ℝ)^2/(2*(n:ℝ))
        - u*(((0:ℕ)):ℝ)^3/(3*(n:ℝ)^2) + (u*(((0:ℕ)):ℝ)^2/(2*(n:ℝ)))^2/2) = 1 := by
      simp
    rw [hf0] at hsplit
    have hcongr : PhiMainS u n
        = ∑' k : ℕ, (fun k : ℕ => Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
            - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)) (k+1) := by
      rw [PhiMainS]
      apply tsum_congr; intro j
      simp only [Nat.cast_add, Nat.cast_one]
    rw [hcongr, PhiMain]
    linarith [hsplit]
  rw [hsh, PhiMain_eq u n hu1 hn]
  ring

/-- **Finite part of the tail split.**  For `K` such that every `k < K` satisfies
`4k² ≤ n`, the first `K−1` terms of the `Φ`-vs-`PhiMainS` comparison sum to `≤ 8·10¹⁰/n³`. -/
lemma phi_finite_part_le (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hK : ∀ k, k < K → 4*k^2 ≤ n) :
    ∑ j ∈ Finset.range (K-1), |(1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
            - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2)|
      ≤ 8*10^10 / (n:ℝ)^3 := by
  have h := phi_err_sum_le u n hu1 hu2 hn (Finset.Ico 1 K)
    (fun k hk => (Finset.mem_Ico.mp hk).1)
    (fun k hk => hK k (Finset.mem_Ico.mp hk).2)
  rw [Finset.sum_Ico_eq_sum_range] at h
  have hidx : ∀ i : ℕ, 1 + i = i + 1 := fun i => by omega
  simp only [hidx] at h
  simpa [Nat.cast_add, Nat.cast_one] using h

/-- **Eventual exponential smallness.**  For `n ≥ 10⁸`, `exp(−√n/8) ≤ n⁻³`, i.e. the
`exp(−c√n)` tail bounds are `o(n⁻³)`.  Uses `Real.log_le_rpow_div` with `ε = 1/4`:
`3 log n ≤ 12 n^{1/4} ≤ √n/8` once `n^{1/4} ≥ 96`, i.e. `n ≥ 96⁴ ≈ 8.5·10⁷`. -/
lemma exp_neg_sqrt_le {n : ℕ} (hn : 100000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/8) ≤ (1:ℝ)/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hbig : (96:ℝ)^4 ≤ (n:ℝ) := by
    have h100 : (100000000:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    have h96 : (96:ℝ)^4 ≤ (100000000:ℝ) := by norm_num
    linarith
  have hrw : ((96:ℝ)^(4:ℕ))^(1/4:ℝ) = 96 := by
    norm_num [Real.rpow_natCast, Real.rpow_mul]
  have h96 : (96:ℝ) ≤ (n:ℝ)^(1/4:ℝ) := by
    have h0 : (0:ℝ) ≤ (96:ℝ)^4 := by positivity
    have h := Real.rpow_le_rpow h0 hbig (by norm_num : (0:ℝ) ≤ (1/4:ℝ))
    rwa [hrw] at h
  have hq : (0:ℝ) < (n:ℝ)^(1/4:ℝ) := Real.rpow_pos_of_pos hnR _
  have hlog : 3 * Real.log (n:ℝ) ≤ Real.sqrt (n:ℝ)/8 := by
    have h1 : Real.log (n:ℝ) ≤ (n:ℝ)^(1/4:ℝ)/(1/4:ℝ) :=
      Real.log_le_rpow_div (le_of_lt hnR) (by norm_num : (0:ℝ) < 1/4)
    have h2 : (n:ℝ)^(1/4:ℝ)/(1/4:ℝ) = 4 * (n:ℝ)^(1/4:ℝ) := by ring
    rw [h2] at h1
    have h3 : Real.sqrt (n:ℝ) = (n:ℝ)^(1/2:ℝ) := Real.sqrt_eq_rpow _
    have h5 : (n:ℝ)^(1/2:ℝ) = (n:ℝ)^(1/4:ℝ) * (n:ℝ)^(1/4:ℝ) := by
      rw [← Real.rpow_add (by positivity)]
      norm_num
    have h4 : 12 * (n:ℝ)^(1/4:ℝ) ≤ (n:ℝ)^(1/2:ℝ)/8 := by
      rw [h5]
      have h6 : (12:ℝ) ≤ (n:ℝ)^(1/4:ℝ)/8 := by linarith
      have hm : (n:ℝ)^(1/4:ℝ) * 12 ≤ (n:ℝ)^(1/4:ℝ) * ((n:ℝ)^(1/4:ℝ)/8) :=
        mul_le_mul_of_nonneg_left h6 (le_of_lt hq)
      linarith [hm]
    rw [h3]
    linarith [h1, h4]
  have hgoal : (n:ℝ)^3 ≤ Real.exp (Real.sqrt (n:ℝ)/8) := by
    rw [← Real.log_le_iff_le_exp (by positivity : (0:ℝ) < (n:ℝ)^3), Real.log_pow]
    push_cast
    linarith
  rw [show -Real.sqrt (n:ℝ)/8 = -(Real.sqrt (n:ℝ)/8) by ring, Real.exp_neg, one_div,
    inv_le_inv₀ (Real.exp_pos _) (by positivity)]
  exact hgoal

/-- **Model-term tail.**  `Σ_i Q_{i+K} ≤ e^{−uK/2}(4·10¹⁰+5)·2`, the tail of the model sum
`PhiMainS` beyond index `K`.  Uses `tsum_shift_pow_exp_le` at `m = 0, 2, 4`. -/
lemma phi_Q_tail_le (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hK : 1 ≤ K) :
    (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) * 2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hK0 : (1:ℝ) ≤ (K:ℝ) := by exact_mod_cast hK
  have hbase : ∀ i : ℕ, ((i:ℝ)+K) ^ (0:ℕ) * Real.exp (-(u*((i:ℝ)+K)))
      = Real.exp (-(u*((i:ℝ)+K))) := fun i => by rw [pow_zero, one_mul]
  have hb2 := tsum_shift_pow_exp_le u hu1 K 2 hK (by norm_num)
  have hb4 := tsum_shift_pow_exp_le u hu1 K 4 hK (by norm_num)
  have hb0 : (∑' i : ℕ, ((i:ℝ)+K) ^ (0:ℕ) * Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) :=
    tsum_shift_pow_exp_le u hu1 K 0 hK (by norm_num)
  have he0 : (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) := by
    rw [← tsum_congr hbase]; exact hb0
  have hle : ∀ i : ℕ, Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2)
      ≤ Real.exp (-(u*((i:ℝ)+K)))
        + (1/(2*(n:ℝ))) * (((i:ℝ)+K)^2 * Real.exp (-(u*((i:ℝ)+K))))
        + (1/(4*(n:ℝ)^2)) * (((i:ℝ)+K)^4 * Real.exp (-(u*((i:ℝ)+K)))) := by
    intro i
    have hE : (0:ℝ) ≤ Real.exp (-(u*((i:ℝ)+K))) := le_of_lt (Real.exp_pos _)
    have hnn : (0:ℝ) ≤ (i:ℝ)+K := by positivity
    have hkey : 1 + u*((i:ℝ)+K)^2/(2*(n:ℝ)) - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
        ≤ 1 + ((i:ℝ)+K)^2/(2*(n:ℝ)) + ((i:ℝ)+K)^4/(4*(n:ℝ)^2) := by
      have ha : u*((i:ℝ)+K)^2/(2*(n:ℝ)) ≤ ((i:ℝ)+K)^2/(2*(n:ℝ)) := by
        rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by positivity : (0:ℝ) < 2*(n:ℝ))]
        have hp : (0:ℝ) ≤ ((i:ℝ)+K)^2 * (2*(n:ℝ)) := by positivity
        nlinarith [hu2, hp]
      have hb : (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2 ≤ ((i:ℝ)+K)^4/(4*(n:ℝ)^2) := by
        have he : (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2 = u^2*((i:ℝ)+K)^4/(8*(n:ℝ)^2) := by
          field_simp
          ring
        rw [he, div_le_div_iff₀ (by positivity : (0:ℝ) < 8*(n:ℝ)^2) (by positivity : (0:ℝ) < 4*(n:ℝ)^2)]
        have hp : (0:ℝ) ≤ ((i:ℝ)+K)^4 * (4*(n:ℝ)^2) := by positivity
        have hu2' : u^2 ≤ 1 := pow_le_one₀ (by linarith : (0:ℝ) ≤ u) hu2
        nlinarith [hu2', hp]
      have hc : (0:ℝ) ≤ u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) := by positivity
      linarith [ha, hb, hc]
    calc Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
          - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2)
        ≤ Real.exp (-(u*((i:ℝ)+K))) * (1 + ((i:ℝ)+K)^2/(2*(n:ℝ)) + ((i:ℝ)+K)^4/(4*(n:ℝ)^2)) :=
          mul_le_mul_of_nonneg_left hkey hE
      _ = Real.exp (-(u*((i:ℝ)+K)))
          + (1/(2*(n:ℝ))) * (((i:ℝ)+K)^2 * Real.exp (-(u*((i:ℝ)+K))))
          + (1/(4*(n:ℝ)^2)) * (((i:ℝ)+K)^4 * Real.exp (-(u*((i:ℝ)+K)))) := by ring
  have hsm : ∀ m : ℕ, m ≤ 6 → Summable (fun i : ℕ =>
      ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K)))) := by
    intro m hm
    have h := (summable_nat_add_iff K).2 (summable_pow6_exp_half u hu1)
    have h2 : Summable (fun i : ℕ => ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))/2)) := by
      refine h.congr (fun i => ?_)
      simp only [Nat.cast_add]
    refine Summable.of_nonneg_of_le (fun i => by positivity) (fun i => ?_) h2
    have he : Real.exp (-(u*((i:ℝ)+K))) ≤ Real.exp (-(u*((i:ℝ)+K))/2) := by
      apply Real.exp_le_exp.mpr
      have h4 : (0:ℝ) ≤ u*((i:ℝ)+K) := by positivity
      linarith
    have h5 : ((i:ℝ)+K)^m ≤ ((i:ℝ)+K)^6 := by
      have h1 : (1:ℝ) ≤ (i:ℝ)+K := by
        have hi : (0:ℝ) ≤ (i:ℝ) := by positivity
        linarith
      exact pow_le_pow_right₀ h1 hm
    calc ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K)))
        ≤ ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))) :=
          mul_le_mul_of_nonneg_right h5 (by positivity)
      _ ≤ ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))/2) :=
          mul_le_mul_of_nonneg_left he (by positivity)
  have he0s := hsm 0 (by norm_num)
  have he2s := hsm 2 (by norm_num)
  have he4s := hsm 4 (by norm_num)
  have he0s' : Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+K)))) := by
    refine he0s.congr (fun i => ?_)
    rw [pow_zero, one_mul]
  have hsumm : Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+K)))
      + (1/(2*(n:ℝ))) * (((i:ℝ)+K)^2 * Real.exp (-(u*((i:ℝ)+K))))
      + (1/(4*(n:ℝ)^2)) * (((i:ℝ)+K)^4 * Real.exp (-(u*((i:ℝ)+K))))) :=
    (he0s'.add (he2s.mul_left _)).add (he4s.mul_left _)
  have hsumL : Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2)) := by
    have h2 := (hsm 2 (by norm_num)).mul_left (u/(2*(n:ℝ)))
    have h3 := (hsm 3 (by norm_num)).mul_left (u/(3*(n:ℝ)^2))
    have h4 := (hsm 4 (by norm_num)).mul_left (u^2/(8*(n:ℝ)^2))
    refine (((he0s'.add h2).sub h3).add h4).congr (fun i => ?_)
    ring
  have := Summable.tsum_le_tsum hle hsumL hsumm

  have := Summable.tsum_le_tsum hle hsumL hsumm
  rw [Summable.tsum_add (he0s'.add (he2s.mul_left _)) (he4s.mul_left _), Summable.tsum_add he0s' (he2s.mul_left _),
    tsum_mul_left, tsum_mul_left] at this
  have h1 : (0:ℝ) ≤ (n:ℝ) := le_of_lt hnR
  calc (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2))
      ≤ (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+K))))
        + (1/(2*(n:ℝ))) * (∑' i : ℕ, ((i:ℝ)+K)^2 * Real.exp (-(u*((i:ℝ)+K))))
        + (1/(4*(n:ℝ)^2)) * (∑' i : ℕ, ((i:ℝ)+K)^4 * Real.exp (-(u*((i:ℝ)+K)))) := this
    _ ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5)
        + (1/(2*(n:ℝ))) * (Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5))
        + (1/(4*(n:ℝ)^2)) * (Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5)) := by
        have hB := tsum_shift_pow_exp_le u hu1 K 0 hK (by norm_num)
        have h2 := tsum_shift_pow_exp_le u hu1 K 2 hK (by norm_num)
        have h4 := tsum_shift_pow_exp_le u hu1 K 4 hK (by norm_num)
        have h0e : (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+K)))) ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) := by
          rw [← tsum_congr hbase]; exact hB
        have hE0 : (0:ℝ) ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) := by positivity
        have hc2 : (0:ℝ) ≤ 1/(2*(n:ℝ)) := by positivity
        have hc4 : (0:ℝ) ≤ 1/(4*(n:ℝ)^2) := by positivity
        have hm2 := mul_le_mul_of_nonneg_left h2 hc2
        have hm4 := mul_le_mul_of_nonneg_left h4 hc4
        linarith [h0e, hm2, hm4]
    _ ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) * 2 := by
        have hE0 : (0:ℝ) ≤ Real.exp (-(u*(K:ℝ))/2) := le_of_lt (Real.exp_pos _)
        have hc2 : (0:ℝ) ≤ 1/(2*(n:ℝ)) := by positivity
        have hc4 : (0:ℝ) ≤ 1/(4*(n:ℝ)^2) := by positivity
        have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
        have h2 : 1/(2*(n:ℝ)) ≤ 1/2 := by
          rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by norm_num : (0:ℝ) < 2)]
          linarith
        have h4 : 1/(4*(n:ℝ)^2) ≤ 1/4 := by
          rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 4*(n:ℝ)^2) (by norm_num : (0:ℝ) < 4)]
          nlinarith [hn1]
        nlinarith [hE0, h2, h4]

lemma rpow_neg_split (y : ℝ) (hy : 2 ≤ y) (s : ℝ) (hs : 2 ≤ s) :
    y^(-s) ≤ y^(-(2:ℝ)) * (2:ℝ)^(-(s-2)) := by
  have hy0 : (0:ℝ) < y := by linarith
  rw [show y^(-s) = y^(-(2:ℝ)) * y^(-(s-2)) by
    rw [← Real.rpow_add hy0]
    congr 1
    ring]
  apply mul_le_mul_of_nonneg_left _ (by positivity)
  rw [Real.rpow_neg (le_of_lt hy0), Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2)]
  rw [inv_le_inv₀ (by positivity) (by positivity)]
  exact Real.rpow_le_rpow (by norm_num : (0:ℝ) ≤ 2) hy (by linarith : (0:ℝ) ≤ s-2)

/-! ### Normalisation lemmas for the `U`-tail -/

lemma rpow_neg_two_eq_inv_sq (y : ℝ) (hy : 2 ≤ y) :
    y^(-(2:ℝ)) = (y⁻¹)^2 := by
  have hy0 : (0:ℝ) ≤ y := by linarith
  rw [Real.rpow_neg hy0 (2:ℝ)]
  rw [show y^(2:ℝ) = y^2 by norm_num [Real.rpow_natCast]]
  rw [← inv_pow]

lemma one_add_fourn_div (i n : ℕ) (hn : 1 ≤ n) :
    1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) = ((i:ℝ)+(5:ℝ)*(n:ℝ)+1)/(n:ℝ) := by
  have hn0 : (n:ℝ) ≠ 0 := by positivity
  rw [eq_div_iff hn0, add_mul, one_mul, div_mul_cancel₀ _ hn0]
  ring

lemma rpow_neg_two_fourn (i n : ℕ) (hn : 1 ≤ n) :
    (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)))^(-(2:ℝ))
      = ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2 := by
  have hn0 : (n:ℝ) ≠ 0 := by positivity
  have hy2 : (2:ℝ) ≤ 1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) := by
    have h1 : (1:ℝ) ≤ (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) := by
      rw [le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ))]
      linarith
    linarith
  rw [rpow_neg_two_eq_inv_sq _ hy2, one_add_fourn_div i n hn, inv_div]

/-- Summability of the shifted `U`-tail summand (numerator `↑i + ↑n + 1`); obtained by
comparison with `summable_phi`, whose numerator is the Nat successor `↑j + 1`. -/
lemma summable_phi_shift (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i : ℕ => (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hbase := summable_phi u n (by omega) hun
  refine Summable.of_nonneg_of_le (fun i => by positivity) (fun i => ?_) hbase
  have hb : (1:ℝ) + (((i:ℝ)+1)/(n:ℝ)) ≤ 1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ)) := by
    have hq : ((i:ℝ)+1)/(n:ℝ) ≤ ((i:ℝ)+(n:ℝ)+1)/(n:ℝ) := by
      rw [div_le_div_iff₀ hnR hnR]
      nlinarith [hn1]
    linarith
  exact Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((i:ℝ)+1)/(n:ℝ))) hb
    (by linarith : -(u*(n:ℝ)) ≤ 0)

lemma summable_phi_shift4 (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i : ℕ => (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hbase := summable_phi u n (by omega) hun
  refine Summable.of_nonneg_of_le (fun i => by positivity) (fun i => ?_) hbase
  have hb : (1:ℝ) + (((i:ℝ)+1)/(n:ℝ)) ≤ 1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) := by
    have hq : ((i:ℝ)+1)/(n:ℝ) ≤ ((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ) := by
      rw [div_le_div_iff₀ hnR hnR]
      nlinarith [hn1]
    linarith
  exact Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((i:ℝ)+1)/(n:ℝ))) hb
    (by linarith : -(u*(n:ℝ)) ≤ 0)

/-- `Σ_i (n/(i+5n+1))² = n²·Σ_i (1/(i+5n+1))²`, matching index forms on both sides so no
commutativity is needed. -/
lemma tsum_div_sq_eq (n : ℕ) :
    (∑' i : ℕ, ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2)
      = (n:ℝ)^2 * (∑' i : ℕ, (1/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2) := by
  rw [← tsum_mul_left]
  apply tsum_congr
  intro i
  rw [div_pow, one_div, inv_pow]
  ring

lemma tsum_inv_fiven_le (n : ℕ) (hn : 1 ≤ n) :
    (∑' i : ℕ, (1/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2) ≤ 1/(5*(n:ℝ)) := by
  have h5n : (((5*n:ℕ)):ℝ) = 5*(n:ℝ) := by push_cast; ring
  have h := tsum_inv_succ_sq_le (5*n) (by omega)
  rw [h5n] at h
  have he : ∀ i : ℕ, (1/((5:ℝ)*(n:ℝ)+i+1))^2 = (1/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2 := by
    intro i
    congr 2
    ring
  rw [tsum_congr he] at h
  exact h

/-- `2^{−(un−2)} = 2^{−un}·4`. -/
lemma rpow_two_shift (u : ℝ) (n : ℕ) :
    (2:ℝ)^(-(u*(n:ℝ)-2)) = (2:ℝ)^(-(u*(n:ℝ))) * 4 := by
  rw [show -(u*(n:ℝ)-2) = -(u*(n:ℝ)) - (-(2:ℝ)) by ring,
    Real.rpow_sub (by norm_num : (0:ℝ) < 2)]
  rw [show (2:ℝ)^(-(2:ℝ)) = 1/4 by
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2)]
    norm_num [Real.rpow_natCast]]
  ring

lemma phi_U_beyond_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    (∑' i : ℕ, (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hexp : -(u*(n:ℝ)) ≤ 0 := by linarith
  have hsumm := summable_phi_shift u n hu1 hn
  have hsplit := hsumm.sum_add_tsum_nat_add (3*n)
  -- Part 1: the first 3n terms, each ≤ 2^{-un}
  have hA : ∑ i ∈ Finset.range (3*n), (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      ≤ 3*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
    have h1 : ∀ i ∈ Finset.range (3*n), (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        ≤ (2:ℝ)^(-(u*(n:ℝ))) := by
      intro i hi
      have hxy : (2:ℝ) ≤ 1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ)) := by
        have hq : (1:ℝ) ≤ (((i:ℝ)+(n:ℝ)+1)/(n:ℝ)) := by
          rw [le_div_iff₀ hnR]; linarith
        linarith
      exact Real.rpow_le_rpow_of_nonpos (by norm_num : (0:ℝ) < 2) hxy hexp
    calc ∑ i ∈ Finset.range (3*n), (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        ≤ ∑ i ∈ Finset.range (3*n), (2:ℝ)^(-(u*(n:ℝ))) := Finset.sum_le_sum h1
      _ = ((3*n : ℕ) : ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
          rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
      _ = 3*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by push_cast; ring
  -- Part 2: the shifted tail, each term ≤ (n/(i+5n+1))² · 2^{-(un-2)}
  have hB : (∑' i : ℕ, (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ (n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
    have hle : ∀ i : ℕ, (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        ≤ (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2 := by
      intro i
      have hy2 : (2:ℝ) ≤ 1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) := by
        have hq : (1:ℝ) ≤ (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) := by
          rw [le_div_iff₀ hnR]; linarith
        linarith
      have h1 := rpow_neg_split _ hy2 (u*(n:ℝ)) hun
      rw [rpow_neg_two_fourn i n (by omega)] at h1
      calc (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          ≤ ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2 * (2:ℝ)^(-(u*(n:ℝ)-2)) := h1
        _ = (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2 := by ring
    have hL := summable_phi_shift4 u n hu1 hn
    have hR : Summable (fun i : ℕ => (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2) := by
      have h5n : (((5*n:ℕ)):ℝ) = 5*(n:ℝ) := by push_cast; ring
      have h := summable_inv_succ_sq (5*n) (by omega)
      rw [h5n] at h
      have h2 : Summable (fun i : ℕ => (1/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2) :=
        h.congr (fun i => by
          rw [show (5:ℝ)*(n:ℝ)+i+1 = (i:ℝ)+(5:ℝ)*(n:ℝ)+1 by ring])
      exact (((h2.mul_left ((n:ℝ)^2)).mul_left ((2:ℝ)^(-(u*(n:ℝ)-2))))).congr (fun i => by ring)
    have hmain := Summable.tsum_le_tsum hle hL hR
    have hmaj : (∑' i : ℕ, (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2)
        ≤ (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)^2 * (1/(5*(n:ℝ)))) := by
      rw [tsum_mul_left]
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      rw [tsum_div_sq_eq]
      exact mul_le_mul_of_nonneg_left (tsum_inv_fiven_le n (by omega)) (by positivity)
    have h7 := rpow_two_shift u n
    have h5 : (5:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 5 ≤ n)
    calc (∑' i : ℕ, (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
        ≤ (∑' i : ℕ, (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2) := hmain
      _ ≤ (2:ℝ)^(-(u*(n:ℝ)-2)) * ((n:ℝ)^2 * (1/(5*(n:ℝ)))) := hmaj
      _ = (2:ℝ)^(-(u*(n:ℝ))) * 4 * ((n:ℝ)^2 * (1/(5*(n:ℝ)))) := by rw [h7]
      _ ≤ (n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
          have hpos : (0:ℝ) < (2:ℝ)^(-(u*(n:ℝ))) := Real.rpow_pos_of_pos (by norm_num) _
          have hb : 4 * ((n:ℝ)^2 * (1/(5*(n:ℝ)))) ≤ (n:ℝ) := by
            have h5n : (5:ℝ)*(n:ℝ) ≠ 0 := by positivity
            rw [show (n:ℝ)^2 * (1/(5*(n:ℝ))) = (n:ℝ)/5 by
              field_simp]
            linarith
          have hb2 : (2:ℝ)^(-(u*(n:ℝ))) * (4 * ((n:ℝ)^2 * (1/(5*(n:ℝ))))) ≤ (2:ℝ)^(-(u*(n:ℝ))) * (n:ℝ) :=
            mul_le_mul_of_nonneg_left hb (le_of_lt hpos)
          linarith [hb2]
  have hcard : ∑ i ∈ Finset.range (3*n), (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      + (∑' i : ℕ, (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      = (∑' i : ℕ, (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) := by
    rw [← hsplit]
    congr 1
    apply tsum_congr
    intro i
    congr 1
    push_cast
    ring
  linarith [hcard, hA, hB]

/-! ### The last eventual estimate -/

/-- `4n ≤ 2^{n/4}` for `n ≥ 1024`, via `log(4n) = log 4 + log n ≤ 3 + 2√n ≤ n/8 ≤ (n/4)log 2`. -/
lemma four_mul_le_two_pow {n : ℕ} (hn : 1024 ≤ n) :
    4*(n:ℝ) ≤ (2:ℝ)^((n:ℝ)/4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  rw [Real.le_rpow_iff_log_le (by positivity : (0:ℝ) < 4*(n:ℝ)) (by norm_num : (0:ℝ) < 2)]
  have hn1024 : (1024:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hs : (32:ℝ) ≤ Real.sqrt (n:ℝ) :=
    (Real.le_sqrt (by norm_num : (0:ℝ) ≤ 32) (by positivity : (0:ℝ) ≤ (n:ℝ))).mpr (by
      nlinarith [hn1024])
  have hsq : Real.sqrt (n:ℝ) ^ 2 = (n:ℝ) := Real.sq_sqrt (le_of_lt hnR)
  have hlog4 : Real.log 4 ≤ 3 := by
    have h := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 4)
    linarith
  have h2 : Real.log (4*(n:ℝ)) = Real.log 4 + Real.log (n:ℝ) :=
    Real.log_mul (by norm_num : (4:ℝ) ≠ 0) (ne_of_gt hnR)
  have h5 : Real.log (n:ℝ) ≤ 2 * Real.sqrt (n:ℝ) := by
    have h := Real.log_le_rpow_div (le_of_lt hnR) (by norm_num : (0:ℝ) < 1/2)
    have h2 : (n:ℝ)^(1/2:ℝ)/(1/2:ℝ) = 2*(n:ℝ)^(1/2:ℝ) := by ring
    rw [Real.sqrt_eq_rpow]
    linarith [h, h2]
  have h3 : 3 + 2 * Real.sqrt (n:ℝ) ≤ (n:ℝ)/8 := by
    nlinarith [hs, hsq, hn1024]
  have hlog2 : (1/2:ℝ) ≤ Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have h4 : (n:ℝ)/8 ≤ ((n:ℝ)/4) * Real.log 2 := by nlinarith [hlog2, hnR]
  rw [h2]
  linarith [hlog4, h5, h3, h4]


/-- `4n·2^{−un} ≤ 1/n³` for `n ≥ 10⁸` and `u ≥ 1/2`, chaining through
`exp_neg_sqrt_le`: `4n·2^{−un} ≤ 4n·2^{−n/2} ≤ 2^{−n/4} ≤ e^{−√n/8} ≤ n⁻³`. -/
lemma poly_two_neg_le {u : ℝ} {n : ℕ} (hu : 1/2 ≤ u) (hn : 100000000 ≤ n) :
    4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) ≤ (1:ℝ)/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1024 : 1024 ≤ n := by omega
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have h1 : (2:ℝ)^(-(u*(n:ℝ))) ≤ (2:ℝ)^(-((n:ℝ)/2)) := by
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num : (1:ℝ) ≤ 2)
    nlinarith [hu, hn1]
  have h1b : 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) ≤ 4*(n:ℝ) * (2:ℝ)^(-((n:ℝ)/2)) :=
    mul_le_mul_of_nonneg_left h1 (by positivity)
  have h2 : 4*(n:ℝ) * (2:ℝ)^(-((n:ℝ)/2)) ≤ (2:ℝ)^(-((n:ℝ)/4)) := by
    have h := four_mul_le_two_pow h1024
    rw [show (2:ℝ)^(-((n:ℝ)/4)) = (2:ℝ)^((n:ℝ)/4) * (2:ℝ)^(-((n:ℝ)/2)) by
      rw [← Real.rpow_add (by norm_num : (0:ℝ) < 2)]
      congr 1
      ring]
    exact mul_le_mul_of_nonneg_right h (by positivity)
  have h3 : (2:ℝ)^(-((n:ℝ)/4)) ≤ Real.exp (-(Real.sqrt (n:ℝ))/8) := by
    rw [Real.rpow_def_of_pos (by norm_num : (0:ℝ) < 2)]
    apply Real.exp_le_exp.mpr
    have hsq : Real.sqrt (n:ℝ)^2 = (n:ℝ) := Real.sq_sqrt (le_of_lt hnR)
    have hs1 : (1:ℝ) ≤ Real.sqrt (n:ℝ) := by
      rw [Real.le_sqrt (by norm_num : (0:ℝ) ≤ 1) (by positivity : (0:ℝ) ≤ (n:ℝ))]
      nlinarith [hn1]
    have hlog2 : (1/2:ℝ) ≤ Real.log 2 := by
      have := Real.log_two_gt_d9
      linarith
    nlinarith [hlog2, hs1, hsq]
  have h4 : Real.exp (-(Real.sqrt (n:ℝ))/8) ≤ (1:ℝ)/((n:ℝ)^3) := exp_neg_sqrt_le hn
  linarith [h1b, h2, h3, h4]

/-- **Model-term positivity.**  `Q_j = e^{−u(j+1)}(1 + y − z + y²/2) ≥ 0` for every `j`
(no lower bound on `j` needed): the key is `z ≤ y + y²/2`, which after clearing denominators
reads `8j ≤ 12n + 3uj²` and holds by splitting on `j < 6` vs `j ≥ 6`. -/
lemma phi_Q_term_nonneg (u : ℝ) (n j : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    0 ≤ Real.exp (-(u*(j:ℝ))) * (1 + u*(j:ℝ)^2/(2*(n:ℝ))
        - u*(j:ℝ)^3/(3*(n:ℝ)^2) + (u*(j:ℝ)^2/(2*(n:ℝ)))^2/2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hE : (0:ℝ) ≤ Real.exp (-(u*(j:ℝ))) := le_of_lt (Real.exp_pos _)
  have hsq : (u*(j:ℝ)^2/(2*(n:ℝ)))^2/2 = u^2*(j:ℝ)^4/(8*(n:ℝ)^2) := by
    field_simp
    ring
  have hcore : 8*u*(j:ℝ)^3 ≤ 12*u*(j:ℝ)^2*(n:ℝ) + 3*u^2*(j:ℝ)^4 := by
    rcases lt_or_ge j 6 with hj | hj
    · have hj5 : (j:ℝ) ≤ 5 := by exact_mod_cast (by omega : j ≤ 5)
      have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
      have hjn : 8*(j:ℝ) ≤ 12*(n:ℝ) := by nlinarith [hj5, hn16]
      have hprod : u*(j:ℝ)^2 * (8*(j:ℝ)) ≤ u*(j:ℝ)^2 * (12*(n:ℝ)) :=
        mul_le_mul_of_nonneg_left hjn (by positivity)
      nlinarith [hprod, hu0, pow_nonneg (by positivity : (0:ℝ) ≤ (j:ℝ)) 2, pow_nonneg (by positivity : (0:ℝ) ≤ (j:ℝ)) 3, pow_nonneg (by positivity : (0:ℝ) ≤ (j:ℝ)) 4]
    · have hj6 : (6:ℝ) ≤ (j:ℝ) := by exact_mod_cast hj
      have hmul : 8*(j:ℝ) ≤ 3*u*(j:ℝ)^2 := by nlinarith [hj6, hu1, sq_nonneg ((j:ℝ))]
      have hj0 : (0:ℝ) ≤ (j:ℝ) := by positivity
      have hprod : u*(j:ℝ)^2 * (8*(j:ℝ)) ≤ u*(j:ℝ)^2 * (3*u*(j:ℝ)^2) :=
        mul_le_mul_of_nonneg_left hmul (by positivity)
      nlinarith [hprod, pow_nonneg (by positivity : (0:ℝ) ≤ (j:ℝ)) 2, pow_nonneg (by positivity : (0:ℝ) ≤ (j:ℝ)) 3, pow_nonneg (by positivity : (0:ℝ) ≤ (j:ℝ)) 4]
  have hkey : u*(j:ℝ)^3/(3*(n:ℝ)^2) ≤ u*(j:ℝ)^2/(2*(n:ℝ)) + (u*(j:ℝ)^2/(2*(n:ℝ)))^2/2 := by
    rw [hsq]
    field_simp
    nlinarith [hcore]
  nlinarith [hE, hkey, sq_nonneg (u*(j:ℝ)^2/(2*(n:ℝ)))]

/-- **Shifted `U`-tail.**  `Σ'_i U_{i+N} ≤ 6e^{−uN/2} + 4n·2^{−un}` for `1 ≤ N ≤ n`,
obtained by splitting the sum at `n−N`: the first block is geometric (`rpow_le_exp_half`), the
second is exactly `phi_U_beyond_le`. -/
lemma summable_exp_shift (u : ℝ) (hu1 : 1/2 ≤ u) (N : ℕ) :
    Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2)) := by
  have hbase : Summable (fun i : ℕ => (Real.exp (-u/2))^i) :=
    summable_geometric_of_norm_lt_one (by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      linarith)
  refine (hbase.mul_left (Real.exp (-(u*((N:ℝ)+1))/2))).congr (fun i => ?_)
  rw [show -(u*((i:ℝ)+(N:ℝ)+1))/2 = -(u*((N:ℝ)+1))/2 + (i:ℝ)*(-u/2) by ring, Real.exp_add,
    Real.exp_nat_mul]

lemma phi_U_shift_le (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i : ℕ, (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ 6 * Real.exp (-(u*(N:ℝ))/2) + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hf : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n (by omega) hun
  have hsm : Summable (fun i : ℕ => (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) := by
    have h := (summable_nat_add_iff N).2 hf
    refine h.congr (fun i => ?_)
    simp only [Nat.cast_add]
  have hsplit := hsm.sum_add_tsum_nat_add (n - N)
  have hfirst : ∑ i ∈ Finset.range (n - N), (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      ≤ 6 * Real.exp (-(u*(N:ℝ))/2) := by
    have h1 : ∀ i ∈ Finset.range (n - N), (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        ≤ Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2) := by
      intro i hi
      have hi' : i < n - N := Finset.mem_range.mp hi
      have hik : i + N + 1 ≤ n := by omega
      have hk1 : 1 ≤ i + N + 1 := by omega
      have h4 : 4 ≤ n := by omega
      have h := rpow_le_exp_half u n (i+N+1) hu1 hu2 h4 hk1 hik
      simpa [Nat.cast_add, Nat.cast_one] using h
    have h2 : ∑ i ∈ Finset.range (n - N), Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2)
        ≤ ∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2) :=
      Summable.sum_le_tsum (Finset.range (n-N)) (fun i _ => by positivity)
        (summable_exp_shift u hu1 N)
    have h3 : (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2))
        = Real.exp (-(u*((N:ℝ)+1))/2) * (∑' i : ℕ, Real.exp (-(u*(i:ℝ))/2)) := by
      rw [← tsum_mul_left]
      apply tsum_congr; intro i
      rw [show -(u*((i:ℝ)+(N:ℝ)+1))/2 = -(u*((N:ℝ)+1))/2 + -(u*(i:ℝ))/2 by ring, Real.exp_add]
    have h4 : (∑' i : ℕ, Real.exp (-(u*(i:ℝ))/2)) ≤ 6 := tsum_exp_neg_half_le u hu1
    have hN1 : -(u*((N:ℝ)+1))/2 ≤ -(u*(N:ℝ))/2 := by
      have : (0:ℝ) ≤ u := by linarith
      linarith
    have h5 : (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2))
        ≤ 6 * Real.exp (-(u*(N:ℝ))/2) := by
      rw [h3]
      have hp : (0:ℝ) < Real.exp (-(u*(N:ℝ))/2) := Real.exp_pos _
      nlinarith [h4, hp, Real.exp_le_exp.mpr hN1, Real.exp_pos (-(u*((N:ℝ)+1))/2)]
    calc ∑ i ∈ Finset.range (n - N), (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        ≤ ∑ i ∈ Finset.range (n - N), Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2) := Finset.sum_le_sum h1
      _ ≤ 6 * Real.exp (-(u*(N:ℝ))/2) := le_trans h2 h5
  have hsecond : (∑' i : ℕ, (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := phi_U_beyond_le u n hu1 hu2 hn
  have hcong2 : (∑' i : ℕ, (1 + (((i:ℝ)+((n-N:ℕ):ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      = (∑' i : ℕ, (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) := by
    apply tsum_congr; intro i
    rw [show (((n-N:ℕ)):ℝ) = (n:ℝ)-(N:ℝ) by rw [Nat.cast_sub hNn]]
    congr 2
    ring
  rw [← hsplit]
  simp only [Nat.cast_add] at *
  rw [hcong2]
  linarith [hfirst, hsecond]

/-! ### General-`N` summability witnesses for the tail assembly -/

lemma summable_phi_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i : ℕ => (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) := by
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hf : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n (by omega) hun
  have h := (summable_nat_add_iff N).2 hf
  refine h.congr (fun i => ?_)
  simp only [Nat.cast_add]

lemma summable_Q_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+(N:ℝ)+1)))
        * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)) := by
  have hshift : ∀ m : ℕ, Summable (fun i : ℕ =>
      ((i:ℝ)+(N:ℝ)+1)^m * Real.exp (-(u*((i:ℝ)+(N:ℝ)+1)))) := by
    intro m
    have h := (summable_nat_add_iff (N+1)).2 (summable_exp_neg_u u hu1 m)
    refine h.congr (fun i => ?_)
    push_cast
    ring
  have h0 : Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+(N:ℝ)+1)))) := by
    have h := hshift 0
    refine h.congr (fun i => ?_)
    rw [pow_zero, one_mul]
  refine ((((h0.add ((hshift 2).mul_left (u/(2*(n:ℝ))))).sub
    ((hshift 3).mul_left (u/(3*(n:ℝ)^2)))).add
    ((hshift 4).mul_left (u^2/(8*(n:ℝ)^2))))).congr (fun i => ?_)
  ring

/-- `phi_Q_tail_le` restated with the index in the `↑i+↑N+1` form the tail assembly needs. -/
lemma phi_Q_tail_le' (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) :
    (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
        - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2))
      ≤ Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2 := by
  have h := phi_Q_tail_le u n (N+1) hu1 hu2 hn (by omega)
  have hconv : (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(((N+1:ℕ)):ℝ))))
        * (1 + u*((i:ℝ)+(((N+1:ℕ)):ℝ))^2/(2*(n:ℝ))
            - u*((i:ℝ)+(((N+1:ℕ)):ℝ))^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(((N+1:ℕ)):ℝ))^2/(2*(n:ℝ)))^2/2))
      = (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)) := by
    apply tsum_congr; intro i
    push_cast
    ring
  rw [hconv] at h
  have hN1 : Real.exp (-(u*(((N+1:ℕ)):ℝ))/2) ≤ Real.exp (-(u*(N:ℝ))/2) := by
    apply Real.exp_le_exp.mpr
    have hu0 : (0:ℝ) ≤ u := by linarith
    push_cast
    linarith
  have hfac : (0:ℝ) ≤ (4*10^10 + 5) * 2 := by norm_num
  have := mul_le_mul_of_nonneg_right hN1 hfac
  linarith [h, this]

/-- **Tail of `Φ − PhiMainS`.**  `Σ'_i |U_{i+N} − Q_{i+N}| ≤ 2e^{−uN/2}(4·10¹⁰+5) + 6e^{−uN/2}
+ 4n·2^{−un}`, combining `phi_U_shift_le`, `phi_Q_tail_le'` and `φ_Q ≥ 0`. -/
lemma phi_tail_sum_le (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i : ℕ, |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)|)
      ≤ Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2 + 6 * Real.exp (-(u*(N:ℝ))/2)
        + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hU := phi_U_shift_le u n N hu1 hu2 hn hN hNn
  have hQ := phi_Q_tail_le' u n N hu1 hu2 hn hN
  have hsumU : Summable (fun i : ℕ => (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi_shiftN u n N hu1 hn
  have hsumQ := summable_Q_shiftN u n N hu1 hu2 hn
  have hle : ∀ i : ℕ, |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)|
      ≤ (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        + Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2) := by
    intro i
    have h1 : (0:ℝ) ≤ (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))) := by positivity
    have h2 : (0:ℝ) ≤ Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
        - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2) := by
      have h := phi_Q_term_nonneg u n (i+N+1) hu1 hu2 hn
      simpa [Nat.cast_add, Nat.cast_one] using h
    refine abs_sub_le_iff.mpr ⟨?_, ?_⟩
    · linarith [h2]
    · linarith [h1]
  have hsumm : Summable (fun i : ℕ => |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)|) :=
    Summable.of_nonneg_of_le (fun i => abs_nonneg _) hle (hsumU.add hsumQ)
  have hmain := Summable.tsum_le_tsum hle hsumm (hsumU.add hsumQ)
  have hUQ := Summable.tsum_add hsumU hsumQ
  have hstep : (∑' i : ℕ, |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)|)
      ≤ (∑' i : ℕ, (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
        + (∑' i : ℕ, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2)) := by
    rw [hUQ] at hmain
    exact hmain
  linarith [hstep, hU, hQ]

/-- `exp(−√n/16) ≤ n⁻³` for `n ≥ 2·10⁹` (the `1/16` companion of `exp_neg_sqrt_le`). -/
lemma exp_neg_sqrt16_le {n : ℕ} (hn : 2000000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/16) ≤ (1:ℝ)/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hbig : (192:ℝ)^4 ≤ (n:ℝ) := by
    have h100 : (2000000000:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    have h192 : (192:ℝ)^4 ≤ (2000000000:ℝ) := by norm_num
    linarith
  have hrw : ((192:ℝ)^(4:ℕ))^(1/4:ℝ) = 192 := by
    norm_num [Real.rpow_natCast, Real.rpow_mul]
  have h192 : (192:ℝ) ≤ (n:ℝ)^(1/4:ℝ) := by
    have h0 : (0:ℝ) ≤ (192:ℝ)^4 := by positivity
    have h := Real.rpow_le_rpow h0 hbig (by norm_num : (0:ℝ) ≤ (1/4:ℝ))
    rwa [hrw] at h
  have hq : (0:ℝ) < (n:ℝ)^(1/4:ℝ) := Real.rpow_pos_of_pos hnR _
  have hlog : 3 * Real.log (n:ℝ) ≤ Real.sqrt (n:ℝ)/16 := by
    have h1 : Real.log (n:ℝ) ≤ (n:ℝ)^(1/4:ℝ)/(1/4:ℝ) :=
      Real.log_le_rpow_div (le_of_lt hnR) (by norm_num : (0:ℝ) < 1/4)
    have h2 : (n:ℝ)^(1/4:ℝ)/(1/4:ℝ) = 4 * (n:ℝ)^(1/4:ℝ) := by ring
    rw [h2] at h1
    have h3 : Real.sqrt (n:ℝ) = (n:ℝ)^(1/2:ℝ) := Real.sqrt_eq_rpow _
    have h5 : (n:ℝ)^(1/2:ℝ) = (n:ℝ)^(1/4:ℝ) * (n:ℝ)^(1/4:ℝ) := by
      rw [← Real.rpow_add (by positivity)]
      norm_num
    have h4 : 12 * (n:ℝ)^(1/4:ℝ) ≤ (n:ℝ)^(1/2:ℝ)/16 := by
      rw [h5]
      have h6 : (12:ℝ) ≤ (n:ℝ)^(1/4:ℝ)/16 := by linarith
      have hm : (n:ℝ)^(1/4:ℝ) * 12 ≤ (n:ℝ)^(1/4:ℝ) * ((n:ℝ)^(1/4:ℝ)/16) :=
        mul_le_mul_of_nonneg_left h6 (le_of_lt hq)
      linarith [hm]
    rw [h3]
    linarith [h1, h4]
  have hgoal : (n:ℝ)^3 ≤ Real.exp (Real.sqrt (n:ℝ)/16) := by
    rw [← Real.log_le_iff_le_exp (by positivity : (0:ℝ) < (n:ℝ)^3), Real.log_pow]
    push_cast
    linarith
  rw [show -Real.sqrt (n:ℝ)/16 = -(Real.sqrt (n:ℝ)/16) by ring, Real.exp_neg, one_div,
    inv_le_inv₀ (Real.exp_pos _) (by positivity)]
  exact hgoal
/-! ### The third-order assembly -/

/-- `|∑' g| ≤ ∑' |g|` (Mathlib has no `abs_tsum_le_tsum_abs`). -/
lemma abs_tsum_le_tsum_abs' (g : ℕ → ℝ) (hg : Summable g) :
    |∑' i, g i| ≤ ∑' i, |g i| := by
  have h1 : (∑' i, g i) ≤ ∑' i, |g i| :=
    Summable.tsum_le_tsum (fun i => le_abs_self (g i)) hg hg.abs
  have h3 : (0:ℝ) ≤ ∑' i, (|g i| + g i) :=
    tsum_nonneg (fun i => by have h := neg_le_abs (g i); linarith)
  have h4 : (∑' i, (|g i| + g i)) = (∑' i, |g i|) + (∑' i, g i) := Summable.tsum_add hg.abs hg
  have h2 : (-∑' i, |g i|) ≤ ∑' i, g i := by linarith [h3, h4]
  exact abs_le.mpr ⟨h2, h1⟩

lemma Phi_third_order_aux {u : ℝ} {n N : ℕ}
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hN1 : 1 ≤ N) (hNn : N ≤ n)
    (hK : ∀ k, k ≤ N → 4*k^2 ≤ n)
    (hbig : Real.sqrt ((n:ℝ))/4 ≤ (N:ℝ)) :
    |Phi (u*(n:ℝ)) n - PhiMainS u n| ≤ (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16 : 16 ≤ n := by omega
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hu0 : (0:ℝ) ≤ u := by linarith
  set f : ℕ → ℝ := fun j => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
          - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2) with hf
  have hsumU : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n (by omega) hun
  have hsumQ : Summable (fun j : ℕ => Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
      - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2)) := by
    have h := (summable_nat_add_iff 1).2 (summable_PhiMain_term u n hu1)
    refine h.congr (fun j => ?_)
    simp only [Nat.cast_add, Nat.cast_one]
  have hfsum : Summable f := hsumU.sub hsumQ
  have hsub : Phi (u*(n:ℝ)) n - PhiMainS u n = ∑' j, f j := by
    rw [Phi, PhiMainS, hf]
    exact (Summable.tsum_sub hsumU hsumQ).symm
  have hsplit := hfsum.sum_add_tsum_nat_add N
  have hfinN : ∑ j ∈ Finset.range N, |f j| ≤ 8*10^10/((n:ℝ)^3) := by
    have h := phi_finite_part_le u n (N+1) hu1 hu2 (by omega) (fun k hk => hK k (by omega))
    simpa [Nat.add_sub_cancel, hf] using h
  have htailN : (∑' i : ℕ, |f (i+N)|) ≤ Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2
      + 6 * Real.exp (-(u*(N:ℝ))/2) + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
    have h := phi_tail_sum_le u n N hu1 hu2 (by omega) hN1 hNn
    simpa [hf, Nat.cast_add] using h
  have htri : |∑' j, f j| ≤ ∑ j ∈ Finset.range N, |f j| + ∑' i : ℕ, |f (i+N)| := by
    rw [← hsplit]
    have hA := abs_add_le (∑ j ∈ Finset.range N, f j) (∑' i : ℕ, f (i+N))
    have hB := Finset.abs_sum_le_sum_abs f (Finset.range N)
    have hC := abs_tsum_le_tsum_abs' (fun i => f (i+N))
      (hfsum.comp_injective (fun a b h => Nat.add_right_cancel h))
    linarith [hA, hB, hC]
  have hnum : Real.exp (-(u*(N:ℝ))/2) ≤ (1:ℝ)/((n:ℝ)^3) := by
    have h1 : Real.exp (-(u*(N:ℝ))/2) ≤ Real.exp (-(Real.sqrt (n:ℝ))/16) := by
      apply Real.exp_le_exp.mpr
      nlinarith [hbig, hu1]
    exact le_trans h1 (exp_neg_sqrt16_le hn)
  have hnum2 : 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) ≤ (1:ℝ)/((n:ℝ)^3) :=
    poly_two_neg_le hu1 (by omega : 100000000 ≤ n)
  have h1n : (0:ℝ) < (n:ℝ)^3 := by positivity
  have hb1 : Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2
      ≤ (1:ℝ)/((n:ℝ)^3) * (4*10^10 + 5) * 2 := by
    have h := mul_le_mul_of_nonneg_right hnum (by norm_num : (0:ℝ) ≤ (4*10^10+5)*2)
    linarith [h]
  have hb2 : 6 * Real.exp (-(u*(N:ℝ))/2) ≤ 6 * ((1:ℝ)/((n:ℝ)^3)) :=
    mul_le_mul_of_nonneg_left hnum (by norm_num)
  rw [hsub]
  have hconst : 8*10^10/((n:ℝ)^3) + ((1:ℝ)/((n:ℝ)^3) * (4*10^10 + 5) * 2
      + 6 * ((1:ℝ)/((n:ℝ)^3)) + (1:ℝ)/((n:ℝ)^3))
      = (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) := by
    field_simp
    ring
  linarith [htri, hfinN, htailN, hb1, hb2, hnum2, hconst]

/-- **`Phi_third_order`.**  `Φ_{un}(n) = (e^u−1)⁻¹ + (u/2n)ΦS(u) + D(u)/n² + O(n⁻³)`,
uniformly for `u ∈ [1/2,1]`, with the split point `N` carried as a parameter. -/
theorem Phi_third_order {u : ℝ} {n N : ℕ}
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hN1 : 1 ≤ N) (hNn : N ≤ n)
    (hK : ∀ k, k ≤ N → 4*k^2 ≤ n)
    (hbig : Real.sqrt ((n:ℝ))/4 ≤ (N:ℝ)) :
    |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))|
      ≤ (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) := by
  rw [← PhiMainS_eq u n hu1 (by omega : 1 ≤ n)]
  exact Phi_third_order_aux hu1 hu2 hn hN1 hNn hK hbig

/-! ### Threshold inversion, third order -/

/-- **Threshold step 1 (third order).**  At the threshold, `Φ = 1`, so subtracting the
third-order model from both sides is immediate. -/
lemma threshold_one_sub_third (u : ℝ) (n : ℕ) (C3 : ℝ)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |1 - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ))*PhiS u
      - (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ C3/((n:ℝ)^3) := by
  have hkey : 1 - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ))*PhiS u
      - (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)
      = Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)) := by
    rw [IsThreshold] at hthr
    rw [hthr]
    ring
  rw [hkey]
  exact hbound3

/-- Summability of the sixth-moment majorant `k⁶e^{−uk/2}` for `u ≥ 1/2`, built from the
geometric series (note `e^{−u/2} < 1` needs only `u > 0`, unlike `summable_exp_neg_u` which
needs `u ≥ 1/2` for its own parameter). -/
lemma summable_pow6_half (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
  have hu0 : (0:ℝ) < u := by linarith
  have hx : ‖Real.exp (-u/2)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    linarith
  have h := summable_pow_mul_geometric_of_norm_lt_one 6 hx
  refine h.congr (fun k => ?_)
  rw [show Real.exp (-(u*(k:ℝ))/2) = (Real.exp (-u/2))^k by
    rw [show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]]

lemma PhiK3u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK3u u ≤ 4*10^10 := by
  have h1 := summable_pow6_half u hu
  have h2 : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10 :=
    tsum_pow6_exp_neg_half_le u hu
  have hle : (∑' k : ℕ, (k:ℝ)^3 * Real.exp (-(u*(k:ℝ))))
      ≤ (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
    refine Summable.tsum_le_tsum (fun k => ?_) (summable_PhiK3u u hu) h1
    rcases Nat.eq_zero_or_pos k with hk | hk
    · subst hk; norm_num
    · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
      have hk3 : (k:ℝ)^3 ≤ (k:ℝ)^6 := by
        have h3 : (1:ℝ) ≤ (k:ℝ)^3 := one_le_pow₀ (n := 3) hk1
        have h6 : (k:ℝ)^6 = (k:ℝ)^3 * (k:ℝ)^3 := by ring
        nlinarith [h3, pow_pos (by positivity : (0:ℝ) < (k:ℝ)) 3]
      have he : Real.exp (-(u*(k:ℝ))) ≤ Real.exp (-(u*(k:ℝ))/2) :=
        Real.exp_le_exp.mpr (by nlinarith [hu, (Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ))])
      have hm : (0:ℝ) < (k:ℝ)^3 := by positivity
      have he0 : (0:ℝ) < Real.exp (-(u*(k:ℝ))) := Real.exp_pos _
      calc (k:ℝ)^3 * Real.exp (-(u*(k:ℝ)))
          ≤ (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))) := by nlinarith [hk3, he0, hm]
        _ ≤ (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2) :=
            mul_le_mul_of_nonneg_left he (by positivity)
  rw [PhiK3u]
  linarith [hle, h2]

lemma PhiK4u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK4u u ≤ 4*10^10 := by
  have h1 := summable_pow6_half u hu
  have h2 : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10 :=
    tsum_pow6_exp_neg_half_le u hu
  have hle : (∑' k : ℕ, (k:ℝ)^4 * Real.exp (-(u*(k:ℝ))))
      ≤ (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
    refine Summable.tsum_le_tsum (fun k => ?_) (summable_PhiK4u u hu) h1
    rcases Nat.eq_zero_or_pos k with hk | hk
    · subst hk; norm_num
    · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
      have hk4 : (k:ℝ)^4 ≤ (k:ℝ)^6 := by
        have h4 : (1:ℝ) ≤ (k:ℝ)^4 := one_le_pow₀ (n := 4) hk1
        have h6 : (k:ℝ)^6 = (k:ℝ)^4 * (k:ℝ)^2 := by ring
        nlinarith [h4, pow_pos (by positivity : (0:ℝ) < (k:ℝ)) 2]
      have he : Real.exp (-(u*(k:ℝ))) ≤ Real.exp (-(u*(k:ℝ))/2) :=
        Real.exp_le_exp.mpr (by nlinarith [hu, (Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ))])
      have hm : (0:ℝ) < (k:ℝ)^4 := by positivity
      have he0 : (0:ℝ) < Real.exp (-(u*(k:ℝ))) := Real.exp_pos _
      calc (k:ℝ)^4 * Real.exp (-(u*(k:ℝ)))
          ≤ (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))) := by nlinarith [hk4, he0, hm]
        _ ≤ (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2) :=
            mul_le_mul_of_nonneg_left he (by positivity)
  rw [PhiK4u]
  linarith [hle, h2]

/-- The third-order correction term `u/(2n)·ΦS(u) + D(u)/n²`. -/
noncomputable def SThird (u : ℝ) (n : ℕ) : ℝ :=
  u/(2*(n:ℝ))*PhiS u + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)

lemma threshold_one_sub_third' (u : ℝ) (n : ℕ) (C3 : ℝ)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |1 - (Real.exp u - 1)⁻¹ - SThird u n| ≤ C3/((n:ℝ)^3) := by
  have hkey : 1 - (Real.exp u - 1)⁻¹ - SThird u n
      = Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n) := by
    rw [IsThreshold] at hthr
    rw [hthr]; ring
  rw [hkey]
  exact hbound3

lemma SThird_first_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |u/(2*(n:ℝ))*PhiS u| ≤ 15/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hPS := PhiS_le_thirty u hu1
  have hPS0 : (0:ℝ) ≤ PhiS u := by rw [PhiS]; exact tsum_nonneg (fun k => by positivity)
  rw [abs_of_nonneg (mul_nonneg (by positivity) hPS0)]
  have h2 : u/(2*(n:ℝ)) ≤ (1:ℝ)/(2*(n:ℝ)) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by positivity : (0:ℝ) < 2*(n:ℝ))]
    nlinarith [hu2, hnR]
  have h3 : u/(2*(n:ℝ))*PhiS u ≤ ((1:ℝ)/(2*(n:ℝ))) * 30 :=
    mul_le_mul h2 hPS hPS0 (by positivity)
  have h4 : ((1:ℝ)/(2*(n:ℝ))) * 30 = 15/(n:ℝ) := by
    field_simp
    ring
  linarith [h3, h4]

/-! ### Bounding `SThird` -/

lemma PhiK3u_nonneg (u : ℝ) : (0:ℝ) ≤ PhiK3u u := by
  rw [PhiK3u]; exact tsum_nonneg (fun k => by positivity)

lemma PhiK4u_nonneg (u : ℝ) : (0:ℝ) ≤ PhiK4u u := by
  rw [PhiK4u]; exact tsum_nonneg (fun k => by positivity)

lemma neg_u_div_three_K3u_le (u : ℝ) (hu1 : 1/2 ≤ u) : -(u/3)*PhiK3u u ≤ 0 := by
  have h0 : (0:ℝ) ≤ u/3 := by linarith
  have h := mul_nonneg h0 (PhiK3u_nonneg u)
  linarith

lemma u_div_three_K3u_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    (u/3)*PhiK3u u ≤ (1/3)*4*10^10 := by
  have h0 : (0:ℝ) ≤ u/3 := by linarith
  have h5 : u/3 ≤ 1/3 := by linarith
  have hh := mul_le_mul h5 (PhiK3u_le u hu1) (PhiK3u_nonneg u) (by norm_num : (0:ℝ) ≤ 1/3)
  nlinarith [hh]

lemma u_sq_div_eight_K4u_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    (u^2/8)*PhiK4u u ≤ 4*10^10 := by
  have hu0 : (0:ℝ) ≤ u := by linarith
  have h5 : u^2/8 ≤ 1/8 := by nlinarith [mul_nonneg hu0 (sub_nonneg.mpr hu2)]
  have hh := mul_le_mul h5 (PhiK4u_le u hu1) (PhiK4u_nonneg u) (by norm_num : (0:ℝ) ≤ 1/8)
  nlinarith [hh]

lemma u_sq_div_eight_K4u_nonneg (u : ℝ) : (0:ℝ) ≤ (u^2/8)*PhiK4u u :=
  mul_nonneg (by positivity) (PhiK4u_nonneg u)

lemma SThird_second_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1R : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hD2 : |-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u| ≤ 4*10^10 := by
    have h1 := neg_u_div_three_K3u_le u hu1
    have h2 := u_sq_div_eight_K4u_le u hu1 hu2
    have h3 := u_div_three_K3u_le u hu1 hu2
    have h4 := u_sq_div_eight_K4u_nonneg u
    rw [abs_le]
    exact ⟨by linarith, by linarith⟩
  rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^2))]
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^2)) hnR]
  nlinarith [hD2, hn1R, hnR]

lemma SThird_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |SThird u n| ≤ 2*10^11/(n:ℝ) := by
  rw [SThird]
  have h1 := SThird_first_le u hu1 hu2 n hn
  have h2 := SThird_second_le u hu1 hu2 n hn
  have h3 := abs_add_le (u/(2*(n:ℝ))*PhiS u)
    ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h6 : 15/(n:ℝ) + 4*10^10/(n:ℝ) ≤ 2*10^11/(n:ℝ) := by
    rw [← add_div]
    rw [div_le_div_iff₀ hnR hnR]
    nlinarith [hnR]
  linarith [h3, h1, h2, h6]

lemma one_add_s_add_sq_abs_le (s : ℝ) (hs : |s| ≤ 1/2) : |1 + s + s^2| ≤ 7/4 := by
  have h2 : |s^2| ≤ 1/4 := by
    have h3 : |s^2| = |s|^2 := abs_pow s 2
    rw [h3]
    nlinarith [abs_nonneg s, hs]
  have h3 : |s + s^2| ≤ 1/2 + 1/4 := by
    have h4 := abs_add_le s (s^2)
    linarith [h4, hs, h2]
  have hassoc : (1:ℝ) + s + s^2 = 1 + (s + s^2) := by ring
  have h4 := abs_add_le 1 (s + s^2)
  have h5 : |(1:ℝ)| = 1 := abs_one
  rw [hassoc]
  linarith [h4, h3, h5]

lemma s_cube_abs_le {s : ℝ} {n : ℕ} (hn : 1 ≤ n)
    (hs : |s| ≤ 2*10^11/(n:ℝ)) : |s^3| ≤ 8*10^33/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h : |s|^3 ≤ (2*10^11/(n:ℝ))^3 := pow_le_pow_left₀ (abs_nonneg s) hs 3
  have h1 : |s^3| = |s|^3 := abs_pow s 3
  have h2 : (2*10^11/(n:ℝ))^3 = 8*10^33/((n:ℝ)^3) := by
    rw [div_pow]
    norm_num
  rw [h2] at h
  linarith [h1, h]

lemma exp_sub_two_eq (u s r : ℝ) (h : (Real.exp u - 1)⁻¹ = 1 - s - r)
    (hne : 1 - s - r ≠ 0) :
    Real.exp u - 2 = (s + r)/(1 - s - r) := by
  have h1 : Real.exp u - 1 = (1 - s - r)⁻¹ := by
    have h2 : Real.exp u - 1 = ((Real.exp u - 1)⁻¹)⁻¹ := (inv_inv (Real.exp u - 1)).symm
    rw [h] at h2
    exact h2
  have hexp : Real.exp u = 1 + (1 - s - r)⁻¹ := by linarith [h1]
  rw [hexp]
  field_simp
  ring

lemma SThird_numerator_le {n : ℕ} {C3 s r : ℝ} (hn : 1 ≤ n)
    (hr : |r| ≤ C3/((n:ℝ)^3)) (hC3 : 0 ≤ C3) (hs : |s| ≤ 2*10^11/(n:ℝ))
    (hsh : |s| ≤ 1/2) (hden : (1:ℝ)/2 ≤ 1 - s - r) :
    |r*(1 + s + s^2) + s^3| ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) * (1 - s - r) := by
  have h1 : |1 + s + s^2| ≤ 7/4 := one_add_s_add_sq_abs_le s hsh
  have h2 : |s^3| ≤ 8*10^33/((n:ℝ)^3) := s_cube_abs_le hn hs
  have h3 : |r*(1 + s + s^2)| ≤ (C3/((n:ℝ)^3)) * (7/4) := by
    rw [abs_mul]
    exact mul_le_mul hr h1 (abs_nonneg _) (by positivity)
  have h4 := abs_add_le (r*(1 + s + s^2)) (s^3)
  have h7 : C3/((n:ℝ)^3) * (7/4) + 8*10^33/((n:ℝ)^3)
      ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) * (1/2) := by
    have hn3 : (0:ℝ) < ((n:ℝ)^3) := by positivity
    have h8 : C3/((n:ℝ)^3) * (7/4) = (7*C3/4)/((n:ℝ)^3) := by
      field_simp
    rw [h8, ← add_div]
    rw [show (4*C3 + 4*10^34)/((n:ℝ)^3) * (1/2) = (4*C3 + 4*10^34)/(2*((n:ℝ)^3)) by ring]
    rw [div_le_div_iff₀ hn3 (by positivity : (0:ℝ) < 2*((n:ℝ)^3))]
    have hnum : (8:ℝ) * 10^33 * 2 ≤ 4*10^34 := by norm_num
    nlinarith [hC3, hnum, hn3]
  have h5 : (4*C3 + 4*10^34)/((n:ℝ)^3) * (1/2)
      ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) * (1 - s - r) := by
    have h0 : (0:ℝ) ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) := by positivity
    exact mul_le_mul_of_nonneg_left hden h0
  linarith [h4, h3, h2, h7, h5]

lemma exp_sub_two_algebra (s r : ℝ) (h : 1 - s - r ≠ 0) :
    (s + r)/(1 - s - r) - s - s^2 = (r*(1 + s + s^2) + s^3)/(1 - s - r) := by
  field_simp
  ring

lemma threshold_r_quarter {n : ℕ} {C3 R : ℝ} (hn : 4 ≤ n) (hC3 : 0 ≤ C3) (hnC3 : C3 ≤ n)
    (hR : |R| ≤ C3/((n:ℝ)^3)) : |R| ≤ 1/4 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn4R : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hr3 : (0:ℝ) < ((n:ℝ)^3) := by positivity
  have h1 : C3/((n:ℝ)^3) ≤ (n:ℝ)/((n:ℝ)^3) := div_le_div_of_nonneg_right hnC3 (le_of_lt hr3)
  have h2 : (n:ℝ)/((n:ℝ)^3) = 1/(n:ℝ)^2 := by field_simp
  have h3 : (1:ℝ)/(n:ℝ)^2 ≤ 1/4 := by
    rw [div_le_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^2))]
    nlinarith [hn4R]
  linarith [hR, h1, h2, h3]

lemma threshold_s_quarter {n : ℕ} {s : ℝ} (hn : 1 ≤ n) (hnbig : 8*10^11 ≤ n)
    (hs : |s| ≤ 2*10^11/(n:ℝ)) : |s| ≤ 1/4 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hnbigR : (8*10^11:ℝ) ≤ (n:ℝ) := by exact_mod_cast hnbig
  have h1 : 2*10^11/(n:ℝ) ≤ 1/4 := by
    rw [div_le_iff₀ hnR]
    nlinarith [hnbigR]
  linarith [hs, h1]

lemma threshold_den {s r : ℝ} (hsh : |s| ≤ 1/4) (hrq : |r| ≤ 1/4) :
    (1:ℝ)/2 ≤ 1 - s - r := by
  have h1 : |s + r| ≤ 1/4 + 1/4 := by
    have := abs_add_le s r
    linarith [this, hsh, hrq]
  have h2 : s + r ≤ 1/4 + 1/4 := le_trans (le_abs_self _) h1
  have h3 : (1:ℝ) - s - r = 1 - (s + r) := by ring
  linarith [h2, h3]

lemma threshold_exp_bound_third (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C3 : ℝ) (hC3 : 0 ≤ C3) (hnC3 : C3 ≤ n) (hnbig : 8*10^11 ≤ n)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |Real.exp u - 2 - SThird u n - (SThird u n)^2| ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) := by
  have hrle : |1 - (Real.exp u - 1)⁻¹ - SThird u n| ≤ C3/((n:ℝ)^3) :=
    threshold_one_sub_third' u n C3 hbound3 hthr
  have hsle : |SThird u n| ≤ 2*10^11/(n:ℝ) := SThird_abs_le u hu1 hu2 n hn
  have hrq := threshold_r_quarter (by omega : 4 ≤ n) hC3 hnC3 hrle
  have hsh := threshold_s_quarter hn hnbig hsle
  have hden : (1:ℝ)/2 ≤ 1 - SThird u n - (1 - (Real.exp u - 1)⁻¹ - SThird u n) :=
    threshold_den hsh hrq
  have hpos : (0:ℝ) < 1 - SThird u n - (1 - (Real.exp u - 1)⁻¹ - SThird u n) := by linarith [hden]
  have hexp : Real.exp u - 2 = (SThird u n + (1 - (Real.exp u - 1)⁻¹ - SThird u n))
      / (1 - SThird u n - (1 - (Real.exp u - 1)⁻¹ - SThird u n)) :=
    exp_sub_two_eq u (SThird u n) (1 - (Real.exp u - 1)⁻¹ - SThird u n) (by ring) (ne_of_gt hpos)
  have hkey : Real.exp u - 2 - SThird u n - (SThird u n)^2
      = ((1 - (Real.exp u - 1)⁻¹ - SThird u n)*(1 + SThird u n + (SThird u n)^2)
          + (SThird u n)^3)
        / (1 - SThird u n - (1 - (Real.exp u - 1)⁻¹ - SThird u n)) := by
    rw [hexp]
    exact exp_sub_two_algebra _ _ (ne_of_gt hpos)
  have hsh2 : |SThird u n| ≤ 1/2 := by linarith [hsh]
  have hnum := SThird_numerator_le hn hrle hC3 hsle hsh2 hden
  rw [hkey, abs_div, abs_of_pos hpos]
  rw [div_le_iff₀ hpos]
  exact hnum

/-! ### Third-order log expansion -/

lemma abs_log_one_add_sub_sq_le_pos (x : ℝ) (hx : 0 ≤ x) (hx2 : x ≤ 1/2) :
    |Real.log (1 + x) - x + x^2/2| ≤ x^3 := by
  have h1 := log_one_add_le_cubic x hx
  have h2 := log_one_add_ge_quartic x hx
  have h4 : x^4/4 ≤ x^3/2 := by
    have hx0 : (0:ℝ) < x + 1 := by linarith
    nlinarith [hx, hx2, pow_pos hx0 3, sq_nonneg x]
  rw [abs_le]
  constructor <;> linarith

lemma abs_log_one_add_sub_sq_le_neg (z : ℝ) (hz : 0 ≤ z) (hz2 : z ≤ 1/2) :
    |Real.log (1 - z) + z + (1/2)*z^2| ≤ 2*z^3 := by
  have hz2' : z^2 ≤ 1/4 := by nlinarith [hz, hz2]
  have h1 : Real.log (1 - z^2) ≤ -z^2 := by
    have hpos : (0:ℝ) < 1 - z^2 := by nlinarith [hz2']
    have h := Real.log_le_sub_one_of_pos hpos
    linarith
  have h2 : -z^2 - 2*z^4 ≤ Real.log (1 - z^2) := by
    have hpos : (0:ℝ) < 1 - z^2 := by nlinarith [hz2']
    have h3 : Real.log (1/(1 - z^2)) ≤ 1/(1 - z^2) - 1 :=
      Real.log_le_sub_one_of_pos (by positivity)
    have h4 : Real.log (1/(1 - z^2)) = -Real.log (1 - z^2) := by
      rw [Real.log_div (by norm_num : (1:ℝ) ≠ 0) (ne_of_gt hpos), Real.log_one]
      ring
    have h5 : 1/(1 - z^2) - 1 = z^2/(1 - z^2) := by field_simp; ring
    have h6 : z^2/(1 - z^2) ≤ z^2 + 2*z^4 := by
      rw [div_le_iff₀ hpos]
      have h7 : (z^2 + 2*z^4)*(1 - z^2) = z^2 + z^4 - 2*z^6 := by ring
      rw [h7]
      nlinarith [hz2', sq_nonneg (z^2)]
    linarith [h3, h4, h5, h6]
  have h3c : Real.log (1 + z) ≤ z - (1/2)*z^2 + (1/3)*z^3 := log_one_add_le_cubic z hz
  have h4c : z - (1/2)*z^2 + (1/3)*z^3 - (1/4)*z^4 ≤ Real.log (1 + z) := log_one_add_ge_quartic z hz
  have hident : Real.log (1 - z) = Real.log (1 - z^2) - Real.log (1 + z) := by
    rw [← Real.log_div (by nlinarith [hz2'] : (1 - z^2) ≠ 0) (by linarith : (1 + z) ≠ 0)]
    congr 1
    field_simp
    ring
  have hz4 : z^4 ≤ z^3/2 := by nlinarith [hz, hz2, pow_nonneg hz 3]
  have hz3n : (0:ℝ) ≤ z^3 := pow_nonneg hz 3
  rw [hident, abs_le]
  constructor
  · linarith [h2, h4c, hz4, hz3n]
  · linarith [h1, h3c, hz3n]

lemma abs_log_one_add_sub_sq_le (y : ℝ) (hy : |y| ≤ 1/2) :
    |Real.log (1 + y) - y + y^2/2| ≤ 2*(|y|^3) := by
  have hy2 : y ≤ 1/2 := le_trans (le_abs_self y) hy
  rcases le_or_gt 0 y with h | h
  · have hp := abs_log_one_add_sub_sq_le_pos y h hy2
    rw [abs_of_nonneg h]
    have hy3 : y^3 ≤ 2*y^3 := by nlinarith [pow_nonneg h 3]
    exact le_trans hp hy3
  · have hz : 0 ≤ -y := by linarith
    have hz2 : -y ≤ 1/2 := by linarith [neg_abs_le y]
    have hn := abs_log_one_add_sub_sq_le_neg (-y) hz hz2
    have hkey : Real.log (1 + y) - y + y^2/2
        = Real.log (1 - (-y)) + (-y) + (1/2)*(-y)^2 := by ring_nf
    rw [hkey, abs_of_neg h]
    exact hn

/-- The `D(u)` bound in the form the wrapper needs: the denominator of the *sum*, not of the
original quotient. -/
lemma SThird_D_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u| ≤ 4*10^10 := by
  have h1 := neg_u_div_three_K3u_le u hu1
  have h2 := u_sq_div_eight_K4u_le u hu1 hu2
  have h3 := u_div_three_K3u_le u hu1 hu2
  have h4 := u_sq_div_eight_K4u_nonneg u
  rw [abs_le]
  exact ⟨by linarith, by linarith⟩

lemma SThird_second_le' (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/((n:ℝ)^2) := by
  have hD := SThird_D_abs_le u hu1 hu2
  have hnR : (0:ℝ) < (n:ℝ) := by exact_mod_cast (by omega : 0 < n)
  rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^2))]
  exact div_le_div_of_nonneg_right hD (by positivity : (0:ℝ) ≤ ((n:ℝ)^2))

lemma threshold_exp_two_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C3 : ℝ) (hC3 : 0 ≤ C3) (hn32 : 32 ≤ n) (hnC0 : C3 + 4*10^10 ≤ (n:ℝ))
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |Real.exp u - 2| ≤ 32/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1R : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hC0 : (0:ℝ) ≤ C3 + 4*10^10 := by linarith [hC3]
  have hS : SThird u n = u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) := rfl
  have hD : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/((n:ℝ)^2) :=
    SThird_second_le' u hu1 hu2 n hn
  have hbound2 : |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u|
      ≤ (C3 + 4*10^10)/((n:ℝ)^2) := by
    have h3 : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u
        = (Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n))
          + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) := by
      rw [hS]; ring
    rw [h3]
    have h4 := abs_add_le (Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n))
      ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))
    have hn23 : (n:ℝ)^2 ≤ (n:ℝ)^3 := by nlinarith [hn1R, pow_pos hnR 2]
    have h6 : C3/((n:ℝ)^3) ≤ C3/((n:ℝ)^2) := by
      rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
      nlinarith [hC3, hn23]
    have h8 : C3/((n:ℝ)^2) + 4*10^10/((n:ℝ)^2) = (C3 + 4*10^10)/((n:ℝ)^2) := by ring
    linarith [h4, hbound3, hD, h6, h8]
  exact threshold_exp_bound u hu1 hu2 n hn (C3 + 4*10^10) hC0 hnC0 hn32 hbound2 hthr

/-- **Threshold log step (third order).**  The `−x²/8` term of the log expansion, in the exact
shape `threshold_log_bound` uses (`Real.exp u/2 - 1` throughout). -/
lemma threshold_log_bound_third (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (hn32 : 32 ≤ n) (hexp : |Real.exp u - 2| ≤ 32/(n:ℝ)) :
    |u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8| ≤ 8192/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h32' : |Real.exp u - 2| ≤ 1 := by
    have h : 32/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; exact_mod_cast hn32
    linarith [hexp, h]
  have hw : |Real.exp u/2 - 1| ≤ 1/2 := by
    rw [show Real.exp u/2 - 1 = (Real.exp u - 2)/2 by ring, abs_div,
      show |(2:ℝ)| = 2 by norm_num, div_le_iff₀ (by norm_num)]
    linarith [h32']
  have h1 : Real.exp u/2 - 1 = (Real.exp u - 2)/2 := by ring
  have h2 : Real.log (1 + (Real.exp u/2 - 1)) = u - Real.log 2 := by
    rw [show (1:ℝ) + (Real.exp u/2 - 1) = Real.exp u/2 by ring,
      Real.log_div (Real.exp_ne_zero u) (by norm_num : (2:ℝ) ≠ 0), Real.log_exp]
  have hkey : |u - Real.log 2 - (Real.exp u - 2)/2 + ((Real.exp u - 2)/2)^2/2|
      ≤ 2*|(Real.exp u - 2)/2|^3 := by
    have hb := abs_log_one_add_sub_sq_le (Real.exp u/2 - 1) hw
    rw [h2, h1] at hb
    exact hb
  have hkey' : |u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8|
      ≤ 2*|(Real.exp u - 2)/2|^3 := by
    have h6 : ((Real.exp u - 2)/2)^2/2 = (Real.exp u - 2)^2/8 := by ring
    rw [h6] at hkey
    exact hkey
  have hw2 : |Real.exp u/2 - 1| ≤ 16/(n:ℝ) := by
    rw [show Real.exp u/2 - 1 = (Real.exp u - 2)/2 by ring, abs_div,
      show |(2:ℝ)| = 2 by norm_num]
    rw [div_le_div_iff₀ (by norm_num) hnR]
    have hprod : |Real.exp u - 2| * (n:ℝ) ≤ 32 := by
      have hh := mul_le_mul_of_nonneg_right hexp (le_of_lt hnR)
      field_simp at hh
      exact hh
    linarith [hprod]
  have h3 : |(Real.exp u - 2)/2|^3 ≤ (16/(n:ℝ))^3 := by
    rw [← h1]
    exact pow_le_pow_left₀ (abs_nonneg _) hw2 3
  have h4 : (16/(n:ℝ))^3 = 4096/((n:ℝ)^3) := by
    rw [div_pow]
    congr 1
    norm_num
  have h5 : 2 * (4096/((n:ℝ)^3)) = 8192/((n:ℝ)^3) := by ring
  linarith [hkey', h3, h4, h5]

/-! ### Second-order `ΦS` expansion at `log 2` -/

lemma exp_sub_one_sub_id_bound (x : ℝ) :
    |Real.exp x - 1 - x| ≤ 3 * x^2 * Real.exp |x| := by
  rcases le_or_gt |x| 1 with h | h
  · have h1 := Real.abs_exp_sub_one_sub_id_le h
    have hE : (1:ℝ) ≤ 3 * Real.exp |x| := by
      have h0 : (0:ℝ) ≤ |x| := abs_nonneg x
      have h1 : (1:ℝ) ≤ Real.exp |x| := Real.one_le_exp_iff.mpr h0
      linarith
    have hsq : x^2 ≤ 3 * x^2 * Real.exp |x| := by
      have hh := mul_nonneg (sq_nonneg x) (sub_nonneg.mpr hE)
      nlinarith [hh]
    linarith [h1, hsq]
  · have h1 : |Real.exp x - 1| ≤ 2 * Real.exp |x| := by
      have h2 : |Real.exp x| ≤ Real.exp |x| := by
        rw [abs_of_pos (Real.exp_pos x)]
        exact Real.exp_le_exp.mpr (le_abs_self x)
      have h3 : |Real.exp x - 1| ≤ |Real.exp x| + 1 := by
        rw [abs_sub_le_iff]
        have he0 : |Real.exp x| = Real.exp x := abs_of_pos (Real.exp_pos x)
        exact ⟨by rw [he0]; linarith [Real.exp_pos x],
                by rw [he0]; linarith [Real.exp_pos x]⟩
      have h4 : (1:ℝ) ≤ Real.exp |x| := by
        have : (0:ℝ) ≤ |x| := abs_nonneg x
        exact Real.one_le_exp_iff.mpr this
      linarith [h2, h3, h4]
    have hx : |x| ≤ x^2 := by
      have hh := mul_nonneg (abs_nonneg x) (sub_nonneg.mpr (le_of_lt h))
      nlinarith [hh, sq_abs x, abs_nonneg x]
    have h2 : 2 * Real.exp |x| + |x| ≤ 3 * x^2 * Real.exp |x| := by
      have hA : 2 * Real.exp |x| ≤ 2 * |x| * Real.exp |x| :=
        mul_le_mul_of_nonneg_right (by linarith : (2:ℝ) ≤ 2 * |x|) (le_of_lt (Real.exp_pos _))
      have h4 : (1:ℝ) ≤ Real.exp |x| := by
        have : (0:ℝ) ≤ |x| := abs_nonneg x
        exact Real.one_le_exp_iff.mpr this
      have hB1 : |x| ≤ |x| * Real.exp |x| := by
        have hh := mul_nonneg (abs_nonneg x) (sub_nonneg.mpr h4)
        nlinarith [hh]
      have hB2 : |x| * Real.exp |x| ≤ x^2 * Real.exp |x| :=
        mul_le_mul_of_nonneg_right hx (le_of_lt (Real.exp_pos _))
      nlinarith [hA, hB1, hB2, Real.exp_pos |x|]
    have h3 : |(Real.exp x - 1) - x| ≤ |Real.exp x - 1| + |x| := by
      rw [abs_sub_le_iff]
      constructor
      · linarith [le_abs_self (Real.exp x - 1), neg_le_abs x]
      · linarith [le_abs_self x, neg_le_abs (Real.exp x - 1)]
    linarith [h3, h1, h2]

lemma phiS_term_taylor (u b : ℝ) (hb : 5/8 ≤ b) (hub : |u - b| ≤ 1/2) (k : ℕ) :
    |Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
        + (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b)|
      ≤ 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/8)) * (u - b)^2 := by
  set x : ℝ := -(u - b) * (k:ℝ) with hx
  have hk0 : (0:ℝ) ≤ (k:ℝ) := by positivity
  have h1 : Real.exp (-(u*(k:ℝ))) = Real.exp (-(b*(k:ℝ))) * Real.exp x := by
    rw [hx, show -(u*(k:ℝ)) = -(b*(k:ℝ)) + (-(u - b) * (k:ℝ)) by ring, Real.exp_add]
  have h2 : (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b) = -Real.exp (-(b*(k:ℝ))) * x := by
    rw [hx]
    ring
  have hkey : Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
        + (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b)
      = Real.exp (-(b*(k:ℝ))) * (Real.exp x - 1 - x) := by
    rw [h1, h2]
    ring
  have hE0' : (0:ℝ) ≤ Real.exp (-(b*(k:ℝ))) := le_of_lt (Real.exp_pos _)
  rw [hkey, abs_mul, abs_of_nonneg hE0']
  have h3 : |Real.exp x - 1 - x| ≤ 3 * x^2 * Real.exp |x| := exp_sub_one_sub_id_bound x
  have h4 : x^2 = ((k:ℝ)^2) * (u - b)^2 := by rw [hx]; ring
  have h5 : Real.exp (-(b*(k:ℝ))) * Real.exp |x| ≤ Real.exp (-((k:ℝ)/8)) := by
    have h51 : Real.exp |x| ≤ Real.exp ((k:ℝ)/2) := by
      apply Real.exp_le_exp.mpr
      rw [hx, abs_mul, abs_of_nonneg hk0, abs_neg]
      have hform : ((1/2:ℝ) * (k:ℝ)) = (k:ℝ)/2 := by ring
      rw [← hform]
      exact mul_le_mul_of_nonneg_right hub hk0
    have h52 : Real.exp (-(b*(k:ℝ))) * Real.exp ((k:ℝ)/2) ≤ Real.exp (-((k:ℝ)/8)) := by
      rw [show Real.exp (-(b*(k:ℝ))) * Real.exp ((k:ℝ)/2) = Real.exp (-(b*(k:ℝ)) + (k:ℝ)/2) by rw [Real.exp_add]]
      apply Real.exp_le_exp.mpr
      nlinarith [hb, hk0]
    have hE0 : (0:ℝ) ≤ Real.exp (-(b*(k:ℝ))) := le_of_lt (Real.exp_pos _)
    exact (mul_le_mul_of_nonneg_left h51 hE0).trans h52
  have hstep1 : Real.exp (-(b*(k:ℝ))) * |Real.exp x - 1 - x|
      ≤ Real.exp (-(b*(k:ℝ))) * (3 * x^2 * Real.exp |x|) :=
    mul_le_mul_of_nonneg_left h3 hE0'
  have hstep2 : Real.exp (-(b*(k:ℝ))) * (3 * x^2 * Real.exp |x|)
      ≤ 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/8)) * (u - b)^2 := by
    have h6 : Real.exp (-(b*(k:ℝ))) * (3 * x^2 * Real.exp |x|)
        = 3 * ((k:ℝ)^2) * (u - b)^2 * (Real.exp (-(b*(k:ℝ))) * Real.exp |x|) := by
      rw [h4]
      ring
    have h7 : 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/8)) * (u - b)^2
        = 3 * ((k:ℝ)^2) * (u - b)^2 * Real.exp (-((k:ℝ)/8)) := by ring
    rw [h6, h7]
    have hpos : (0:ℝ) ≤ 3 * ((k:ℝ)^2) * (u - b)^2 := by positivity
    exact mul_le_mul_of_nonneg_left h5 hpos
  linarith [hstep1, hstep2]

/-- `exp(−1/8) ≤ 15/16`, via `log(15/16) ≥ −1/15 ≥ −1/8`; and the eighth-moment tail
`Σ k⁶e^{−k/8} ≤ 10¹⁵`, bounding against `(15/16)^k` with the rational closed form. -/
lemma exp_neg_eighth_le : Real.exp (-(1/8:ℝ)) ≤ 15/16 := by
  have hlog : -(1/15:ℝ) ≤ Real.log (15/16) := by
    have h1 : Real.log (1/(15/16)) ≤ 1/(15/16) - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    have h2 : Real.log (1/(15/16)) = -Real.log (15/16) := by
      rw [Real.log_div (by norm_num : (1:ℝ) ≠ 0) (by norm_num : (15/16:ℝ) ≠ 0), Real.log_one]
      ring
    rw [h2] at h1
    norm_num at h1
    linarith
  rw [← Real.log_le_log_iff (Real.exp_pos (-(1/8:ℝ))) (by norm_num : (0:ℝ) < 15/16), Real.log_exp]
  linarith [hlog]

lemma tsum_pow6_eighth_le : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) ≤ 10^15 := by
  have hx : ‖(15/16 : ℝ)‖ < 1 := by rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  have hx2 : ‖Real.exp (-(1/8:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have hsumm : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by
    have h := summable_pow_mul_geometric_of_norm_lt_one 6 hx2
    refine h.congr (fun k => ?_)
    rw [show Real.exp (-((k:ℝ)/8)) = (Real.exp (-(1/8:ℝ)))^k by
      rw [show -((k:ℝ)/8) = (k:ℝ)*(-(1/8:ℝ)) by ring, Real.exp_nat_mul]]
  have hcomp : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) ≤ ∑' k : ℕ, (k:ℝ)^6 * (15/16:ℝ)^k := by
    refine Summable.tsum_le_tsum (fun k => ?_) hsumm (summable_pow_mul_geometric_of_norm_lt_one 6 hx)
    have he : Real.exp (-((k:ℝ)/8)) ≤ (15/16:ℝ)^k := by
      have h := pow_le_pow_left₀ (le_of_lt (Real.exp_pos _)) exp_neg_eighth_le k
      rw [show Real.exp (-((k:ℝ)/8)) = (Real.exp (-(1/8:ℝ)))^k by
        rw [show -((k:ℝ)/8) = (k:ℝ)*(-(1/8:ℝ)) by ring, Real.exp_nat_mul]]
      exact h
    exact mul_le_mul_of_nonneg_left he (by positivity)
  have hval : (∑' k : ℕ, (k:ℝ)^6 * (15/16:ℝ)^k) ≤ 10^15 := by
    rw [tsum_pow_mul_geometric_of_norm_lt_one 6 hx]
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond,
      Nat.factorial, Nat.cast_one, Nat.cast_zero]
    norm_num
  linarith [hcomp, hval]

/-- **Sharp second-order expansion of `ΦS` at `log 2`:** `ΦS(u) = 6 − 26(u−log2) + O((u−log2)²)`,
the sharp first-order term the inversion needs (the Lipschitz bound's coefficient 96 is not
enough). -/
lemma PhiS_second_order_at_log2 (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |PhiS u - 6 + 26*(u - Real.log 2)| ≤ 10^16 * (u - Real.log 2)^2 := by
  have hl1 : (1/2:ℝ) ≤ Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hl2 : Real.log 2 ≤ 1 := by
    have h : (2:ℝ) ≤ Real.exp 1 := by
      have h1 := Real.add_one_le_exp (1:ℝ)
      norm_num at h1 ⊢
      exact h1
    have h1 := Real.log_le_log (by norm_num : (0:ℝ) < 2) h
    rwa [Real.log_exp] at h1
  have hub : |u - Real.log 2| ≤ 1/2 := by
    rw [abs_sub_le_iff]
    constructor <;> linarith [hu1, hu2, hl1, hl2]
  have hb : (5/8:ℝ) ≤ Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hlu : (1:ℝ)/2 ≤ Real.log 2 := hl1
  have hterm : ∀ k : ℕ, |(k:ℝ)^2 * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)|
      ≤ 3 * (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2 := by
    intro k
    have hk := phiS_term_taylor u (Real.log 2) hb hub k
    have hk2 : |(k:ℝ)^2 * (Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ) * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2))|
      ≤ 3 * (k:ℝ)^4 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2 := by
      rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ (k:ℝ)^2)]
      have h := mul_le_mul_of_nonneg_left hk (by positivity : (0:ℝ) ≤ (k:ℝ)^2)
      ring_nf at h ⊢
      exact h
    have hk3 : |(k:ℝ)^2 * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)|
      = |(k:ℝ)^2 * (Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ) * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2))| := by
      rw [show (k:ℝ)^2 * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
          + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)
          = (k:ℝ)^2 * (Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2 * (k:ℝ)))
            + (k:ℝ) * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)) by ring]
    have hk4 : 3 * (k:ℝ)^4 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2
        ≤ 3 * (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2 := by
      have hE : (0:ℝ) ≤ Real.exp (-((k:ℝ)/8)) := le_of_lt (Real.exp_pos _)
      have hq : (0:ℝ) ≤ (u - Real.log 2)^2 := sq_nonneg _
      have hk6 : (k:ℝ)^4 ≤ (k:ℝ)^6 := by
        rcases Nat.eq_zero_or_pos k with hkz | hkz
        · subst hkz; norm_num
        · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hkz
          have h := one_le_pow₀ (n := 4) hk1
          nlinarith [h, pow_nonneg (Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ)) 2]
      have hk6' : (k:ℝ)^4 * Real.exp (-((k:ℝ)/8)) ≤ (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) :=
        mul_le_mul_of_nonneg_right hk6 hE
      have hk6'' : (k:ℝ)^4 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2
          ≤ (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2 :=
        mul_le_mul_of_nonneg_right hk6' hq
      nlinarith [hk6'']
    linarith [hk2, hk3, hk4]
  have hA : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))) := summable_S u (by linarith)
  have hB : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))) :=
    summable_S (Real.log 2) (by linarith : (0:ℝ) < Real.log 2)
  have hC : Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hlu 3
  have hsumf : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))
        - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)) :=
    (hA.sub hB).add (hC.mul_right (u - Real.log 2))
  have hsumm : Summable (fun k : ℕ => 3 * (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2) := by
    have hx2 : ‖Real.exp (-(1/8:ℝ))‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      norm_num
    have h1 : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by
      have h := summable_pow_mul_geometric_of_norm_lt_one 6 hx2
      refine h.congr (fun k => ?_)
      rw [show Real.exp (-((k:ℝ)/8)) = (Real.exp (-(1/8:ℝ)))^k by
        rw [show -((k:ℝ)/8) = (k:ℝ)*(-(1/8:ℝ)) by ring, Real.exp_nat_mul]]
    exact (h1.mul_right (3 * (u - Real.log 2)^2)).congr (fun k => by ring)
  have hmain := Summable.tsum_le_tsum hterm hsumf.abs hsumm
  have habs := abs_tsum_le_tsum_abs' (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))
        - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)) hsumf
  have hsum_eval : (∑' k : ℕ, ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))
        - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)))
      = PhiS u - 6 + 26 * (u - Real.log 2) := by
    have hsplit : (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ)))
        + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2))
        = (fun k : ℕ => ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ))))
          + (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2)) := by
      funext k; ring
    rw [hsplit]
    rw [Summable.tsum_add (hA.sub hB) (hC.mul_right (u - Real.log 2))]
    rw [Summable.tsum_sub hA hB]
    rw [PhiS, ← PhiS_log_two, PhiS]
    have hfun : (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ))))
        = (fun k : ℕ => (k:ℝ)^2 * (1/2:ℝ)^k) := by
      funext k
      rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (Real.exp (-(Real.log 2)))^k by
        rw [← Real.exp_nat_mul]; congr 1; ring]
      rw [show Real.exp (-(Real.log 2)) = (1/2:ℝ) by
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 2)]; norm_num]
    have hfun3 : (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))))
        = (fun k : ℕ => (k:ℝ)^3 * (1/2:ℝ)^k) := by
      funext k
      rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (Real.exp (-(Real.log 2)))^k by
        rw [← Real.exp_nat_mul]; congr 1; ring]
      rw [show Real.exp (-(Real.log 2)) = (1/2:ℝ) by
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 2)]; norm_num]
    rw [hfun]
    rw [show (∑' k : ℕ, (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))) * (u - Real.log 2))
        = (u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^3 * (1/2:ℝ)^k) by
      rw [← tsum_mul_left]
      congr 1
      funext k
      rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (1/2:ℝ)^k by
        rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (Real.exp (-(Real.log 2)))^k by
          rw [← Real.exp_nat_mul]; congr 1; ring]
        rw [show Real.exp (-(Real.log 2)) = (1/2:ℝ) by
          rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 2)]; norm_num]]
      ring]
    rw [tsum_cube_half]
    ring
  rw [← hsum_eval]
  have hbig : (∑' k : ℕ, 3 * (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^2)
      = 3 * (u - Real.log 2)^2 * (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by
    rw [← tsum_mul_left]
    congr 1
    funext k
    ring
  rw [hbig] at hmain
  have hb1 : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) ≤ 10^15 := tsum_pow6_eighth_le
  have hm := mul_le_mul_of_nonneg_left hb1 (by positivity : (0:ℝ) ≤ 3 * (u - Real.log 2)^2)
  have hnum : 3 * (u - Real.log 2)^2 * 10^15 ≤ 10^16 * (u - Real.log 2)^2 := by
    nlinarith [sq_nonneg (u - Real.log 2)]
  linarith [habs, hmain, hm, hnum]

/-- Lipschitz bounds for the moment sums `PhiK3u`/`PhiK4u` (mirrors of `PhiS_lipschitz`, one
moment higher, with the `4·10¹⁰` tail from `tsum_pow6_exp_neg_half_le`). -/
lemma PhiK3u_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiK3u u - PhiK3u v| ≤ 4*10^10 * |u - v| := by
  have key : ∀ a b : ℝ, 1/2 ≤ a → 1/2 ≤ b → PhiK3u a - PhiK3u b ≤ 4*10^10 * |a - b| := by
    intro a b ha hb
    have haS : Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(a*(k:ℝ)))) := summable_PhiK3u a ha
    have hbS : Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(b*(k:ℝ)))) := summable_PhiK3u b hb
    have hsum : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-((k:ℝ)/2)) * |a - b|) := by
      have h0 : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(((1:ℝ)/2)*(k:ℝ))) * |a - b|) :=
        (summable_exp_neg_u ((1:ℝ)/2) (by norm_num : (1:ℝ)/2 ≤ (1:ℝ)/2) 4).mul_right |a - b|
      refine h0.congr (fun k => ?_)
      rw [show -(((1:ℝ)/2)*(k:ℝ)) = -((k:ℝ)/2) by ring]
    have hpt : ∀ k : ℕ, ((k:ℝ)^3 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^3 * Real.exp (-(b*(k:ℝ))))
        ≤ (k:ℝ)^4 * Real.exp (-((k:ℝ)/2)) * |a - b| := by
      intro k
      have hk0 : (0:ℝ) ≤ (k:ℝ) := Nat.cast_nonneg k
      rcases le_total b a with h | h
      · have he : Real.exp (-(a*(k:ℝ))) ≤ Real.exp (-(b*(k:ℝ))) :=
          Real.exp_le_exp.mpr (by nlinarith [h, hk0])
        have h2 : (0:ℝ) ≤ |a - b| := abs_nonneg _
        have hL : (k:ℝ)^3 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^3 * Real.exp (-(b*(k:ℝ))) ≤ 0 := by
          have := mul_le_mul_of_nonneg_left he (by positivity : (0:ℝ) ≤ (k:ℝ)^3)
          nlinarith
        have hR : (0:ℝ) ≤ (k:ℝ)^4 * Real.exp (-((k:ℝ)/2)) * |a - b| :=
          mul_nonneg (mul_nonneg (by positivity) (Real.exp_pos _).le) h2
        linarith [hL, hR]
      · have hba : (0:ℝ) ≤ b - a := by linarith
        have hbk : Real.exp (-(a*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
            = Real.exp (-(a*(k:ℝ))) * (1 - Real.exp (-((b-a)*(k:ℝ)))) := by
          rw [mul_sub, mul_one, ← Real.exp_add]; ring_nf
        have h1 : 1 - Real.exp (-((b-a)*(k:ℝ))) ≤ (b-a)*(k:ℝ) := by
          have := Real.add_one_le_exp (-((b-a)*(k:ℝ))); linarith
        have hea : Real.exp (-(a*(k:ℝ))) ≤ Real.exp (-((k:ℝ)/2)) :=
          Real.exp_le_exp.mpr (by nlinarith [ha, hk0])
        have hb1 : (0:ℝ) ≤ 1 - Real.exp (-((b-a)*(k:ℝ))) := by
          have h : Real.exp (-((b-a)*(k:ℝ))) ≤ 1 := by
            rw [← Real.exp_zero]
            exact Real.exp_le_exp.mpr (by nlinarith [hba, hk0])
          linarith
        calc (k:ℝ)^3 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^3 * Real.exp (-(b*(k:ℝ)))
            = (k:ℝ)^3 * (Real.exp (-(a*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))) := by ring
          _ = (k:ℝ)^3 * (Real.exp (-(a*(k:ℝ))) * (1 - Real.exp (-((b-a)*(k:ℝ))))) := by rw [hbk]
          _ ≤ (k:ℝ)^3 * (Real.exp (-((k:ℝ)/2)) * ((b-a)*(k:ℝ))) := by
              apply mul_le_mul_of_nonneg_left _ (by positivity : (0:ℝ) ≤ (k:ℝ)^3)
              exact mul_le_mul hea h1 hb1 (Real.exp_pos _).le
          _ = (k:ℝ)^4 * Real.exp (-((k:ℝ)/2)) * |a - b| := by
              rw [abs_sub_comm a b, abs_of_nonneg (by linarith : (0:ℝ) ≤ b - a)]; ring
    rw [PhiK3u, PhiK3u, ← Summable.tsum_sub haS hbS]
    refine le_trans (Summable.tsum_le_tsum hpt (haS.sub hbS) hsum) ?_
    rw [tsum_mul_right]
    have hb1 : (∑' k : ℕ, (k:ℝ)^4 * Real.exp (-((k:ℝ)/2))) ≤ 4*10^10 := by
      have h1 : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) := by
        have h0 := summable_pow6_half 1 (by norm_num : (1:ℝ)/2 ≤ (1:ℝ))
        refine h0.congr (fun k => ?_)
        rw [show -(1*(k:ℝ))/2 = -((k:ℝ)/2) by ring]
      have hcmp : (∑' k : ℕ, (k:ℝ)^4 * Real.exp (-((k:ℝ)/2)))
          ≤ (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) := by
        have h4sum : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-((k:ℝ)/2))) := by
          have h0 : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(((1:ℝ)/2)*(k:ℝ)))) :=
            summable_exp_neg_u ((1:ℝ)/2) (by norm_num : (1:ℝ)/2 ≤ (1:ℝ)/2) 4
          refine h0.congr (fun k => ?_)
          rw [show -(((1:ℝ)/2)*(k:ℝ)) = -((k:ℝ)/2) by ring]
        refine Summable.tsum_le_tsum (fun k => ?_) h4sum h1
        rcases Nat.eq_zero_or_pos k with hkz | hkz
        · subst hkz; norm_num
        · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hkz
          have hk2 : (1:ℝ) ≤ (k:ℝ)^2 := one_le_pow₀ (n := 2) hk1
          have hk4 : (k:ℝ)^4 ≤ (k:ℝ)^6 := by
            have hm := mul_le_mul_of_nonneg_left hk2 (by positivity : (0:ℝ) ≤ (k:ℝ)^4)
            nlinarith [hm]
          have hE : (0:ℝ) ≤ Real.exp (-((k:ℝ)/2)) := (Real.exp_pos _).le
          exact mul_le_mul_of_nonneg_right hk4 hE
      have h2 : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) ≤ 4*10^10 := by
        have h0 := tsum_pow6_exp_neg_half_le 1 (by norm_num : (1:ℝ)/2 ≤ (1:ℝ))
        have hc : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(1*(k:ℝ))/2))
            = (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) := by
          apply tsum_congr; intro k
          rw [show -(1*(k:ℝ))/2 = -((k:ℝ)/2) by ring]
        linarith [h0, hc]
      linarith [hcmp, h2]
    exact mul_le_mul_of_nonneg_right hb1 (abs_nonneg _)
  rw [abs_le]
  constructor
  · have h := key v u hv hu
    rw [abs_sub_comm v u] at h
    linarith
  · linarith [key u v hu hv]

lemma PhiK4u_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiK4u u - PhiK4u v| ≤ 4*10^10 * |u - v| := by
  have key : ∀ a b : ℝ, 1/2 ≤ a → 1/2 ≤ b → PhiK4u a - PhiK4u b ≤ 4*10^10 * |a - b| := by
    intro a b ha hb
    have haS : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(a*(k:ℝ)))) := summable_PhiK4u a ha
    have hbS : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(b*(k:ℝ)))) := summable_PhiK4u b hb
    have hsum : Summable (fun k : ℕ => (k:ℝ)^5 * Real.exp (-((k:ℝ)/2)) * |a - b|) := by
      have h0 : Summable (fun k : ℕ => (k:ℝ)^5 * Real.exp (-(((1:ℝ)/2)*(k:ℝ))) * |a - b|) :=
        (summable_exp_neg_u ((1:ℝ)/2) (by norm_num : (1:ℝ)/2 ≤ (1:ℝ)/2) 5).mul_right |a - b|
      refine h0.congr (fun k => ?_)
      rw [show -(((1:ℝ)/2)*(k:ℝ)) = -((k:ℝ)/2) by ring]
    have hpt : ∀ k : ℕ, ((k:ℝ)^4 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^4 * Real.exp (-(b*(k:ℝ))))
        ≤ (k:ℝ)^5 * Real.exp (-((k:ℝ)/2)) * |a - b| := by
      intro k
      have hk0 : (0:ℝ) ≤ (k:ℝ) := Nat.cast_nonneg k
      rcases le_total b a with h | h
      · have he : Real.exp (-(a*(k:ℝ))) ≤ Real.exp (-(b*(k:ℝ))) :=
          Real.exp_le_exp.mpr (by nlinarith [h, hk0])
        have h2 : (0:ℝ) ≤ |a - b| := abs_nonneg _
        have hL : (k:ℝ)^4 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^4 * Real.exp (-(b*(k:ℝ))) ≤ 0 := by
          have := mul_le_mul_of_nonneg_left he (by positivity : (0:ℝ) ≤ (k:ℝ)^4)
          nlinarith
        have hR : (0:ℝ) ≤ (k:ℝ)^5 * Real.exp (-((k:ℝ)/2)) * |a - b| :=
          mul_nonneg (mul_nonneg (by positivity) (Real.exp_pos _).le) h2
        linarith [hL, hR]
      · have hba : (0:ℝ) ≤ b - a := by linarith
        have hbk : Real.exp (-(a*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
            = Real.exp (-(a*(k:ℝ))) * (1 - Real.exp (-((b-a)*(k:ℝ)))) := by
          rw [mul_sub, mul_one, ← Real.exp_add]; ring_nf
        have h1 : 1 - Real.exp (-((b-a)*(k:ℝ))) ≤ (b-a)*(k:ℝ) := by
          have := Real.add_one_le_exp (-((b-a)*(k:ℝ))); linarith
        have hea : Real.exp (-(a*(k:ℝ))) ≤ Real.exp (-((k:ℝ)/2)) :=
          Real.exp_le_exp.mpr (by nlinarith [ha, hk0])
        have hb1 : (0:ℝ) ≤ 1 - Real.exp (-((b-a)*(k:ℝ))) := by
          have h : Real.exp (-((b-a)*(k:ℝ))) ≤ 1 := by
            rw [← Real.exp_zero]
            exact Real.exp_le_exp.mpr (by nlinarith [hba, hk0])
          linarith
        calc (k:ℝ)^4 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^4 * Real.exp (-(b*(k:ℝ)))
            = (k:ℝ)^4 * (Real.exp (-(a*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))) := by ring
          _ = (k:ℝ)^4 * (Real.exp (-(a*(k:ℝ))) * (1 - Real.exp (-((b-a)*(k:ℝ))))) := by rw [hbk]
          _ ≤ (k:ℝ)^4 * (Real.exp (-((k:ℝ)/2)) * ((b-a)*(k:ℝ))) := by
              apply mul_le_mul_of_nonneg_left _ (by positivity : (0:ℝ) ≤ (k:ℝ)^4)
              exact mul_le_mul hea h1 hb1 (Real.exp_pos _).le
          _ = (k:ℝ)^5 * Real.exp (-((k:ℝ)/2)) * |a - b| := by
              rw [abs_sub_comm a b, abs_of_nonneg (by linarith : (0:ℝ) ≤ b - a)]; ring
    rw [PhiK4u, PhiK4u, ← Summable.tsum_sub haS hbS]
    refine le_trans (Summable.tsum_le_tsum hpt (haS.sub hbS) hsum) ?_
    rw [tsum_mul_right]
    have hb1 : (∑' k : ℕ, (k:ℝ)^5 * Real.exp (-((k:ℝ)/2))) ≤ 4*10^10 := by
      have h1 : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) := by
        have h0 := summable_pow6_half 1 (by norm_num : (1:ℝ)/2 ≤ (1:ℝ))
        refine h0.congr (fun k => ?_)
        rw [show -(1*(k:ℝ))/2 = -((k:ℝ)/2) by ring]
      have hcmp : (∑' k : ℕ, (k:ℝ)^5 * Real.exp (-((k:ℝ)/2)))
          ≤ (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) := by
        have h4sum : Summable (fun k : ℕ => (k:ℝ)^5 * Real.exp (-((k:ℝ)/2))) := by
          have h0 : Summable (fun k : ℕ => (k:ℝ)^5 * Real.exp (-(((1:ℝ)/2)*(k:ℝ)))) :=
            summable_exp_neg_u ((1:ℝ)/2) (by norm_num : (1:ℝ)/2 ≤ (1:ℝ)/2) 5
          refine h0.congr (fun k => ?_)
          rw [show -(((1:ℝ)/2)*(k:ℝ)) = -((k:ℝ)/2) by ring]
        refine Summable.tsum_le_tsum (fun k => ?_) h4sum h1
        rcases Nat.eq_zero_or_pos k with hkz | hkz
        · subst hkz; norm_num
        · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hkz
          have hk2 : (1:ℝ) ≤ (k:ℝ)^2 := one_le_pow₀ (n := 2) hk1
          have hk5 : (k:ℝ)^5 ≤ (k:ℝ)^6 := by
            have hm := mul_le_mul_of_nonneg_left hk2 (by positivity : (0:ℝ) ≤ (k:ℝ)^5)
            nlinarith [hm]
          have hE : (0:ℝ) ≤ Real.exp (-((k:ℝ)/2)) := (Real.exp_pos _).le
          exact mul_le_mul_of_nonneg_right hk5 hE
      have h2 : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) ≤ 4*10^10 := by
        have h0 := tsum_pow6_exp_neg_half_le 1 (by norm_num : (1:ℝ)/2 ≤ (1:ℝ))
        have hc : (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(1*(k:ℝ))/2))
            = (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/2))) := by
          apply tsum_congr; intro k
          rw [show -(1*(k:ℝ))/2 = -((k:ℝ)/2) by ring]
        linarith [h0, hc]
      linarith [hcmp, h2]
    exact mul_le_mul_of_nonneg_right hb1 (abs_nonneg _)
  rw [abs_le]
  constructor
  · have h := key v u hv hu
    rw [abs_sub_comm v u] at h
    linarith
  · linarith [key u v hu hv]

lemma D_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hu2 : u ≤ 1) (hv : 1/2 ≤ v) (hv2 : v ≤ 1) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(v/3)*PhiK3u v + (v^2/8)*PhiK4u v)|
      ≤ 10^12 * |u - v| := by
  have hk3 := PhiK3u_lipschitz u v hu hv
  have hk4 := PhiK4u_lipschitz u v hu hv
  have hk3b := PhiK3u_le u hu
  have hk4b := PhiK4u_le u hu
  have hk30 := PhiK3u_nonneg u
  have hk40 := PhiK4u_nonneg u
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hv0 : (0:ℝ) ≤ v := by linarith
  have h3 : |(u/3)*PhiK3u u - (v/3)*PhiK3u v| ≤ 4*10^10 * |u - v| := by
    have h31 : (u/3)*PhiK3u u - (v/3)*PhiK3u v
        = ((u-v)/3)*PhiK3u u + (v/3)*(PhiK3u u - PhiK3u v) := by ring
    rw [h31]
    have h32 := abs_add_le (((u-v)/3)*PhiK3u u) ((v/3)*(PhiK3u u - PhiK3u v))
    have h33 : |((u-v)/3) * PhiK3u u| ≤ (4*10^10/3) * |u - v| := by
      rw [abs_mul, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3), abs_of_nonneg hk30]
      nlinarith [hk3b, abs_nonneg (u - v)]
    have h34 : |(v/3) * (PhiK3u u - PhiK3u v)| ≤ (1/3) * 4*10^10 * |u - v| := by
      rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ v/3)]
      have h1 : v/3 ≤ 1/3 := by linarith [hv2]
      have h2 := mul_le_mul h1 hk3 (abs_nonneg _) (by norm_num : (0:ℝ) ≤ 1/3)
      nlinarith [h2]
    have hsum : 4*10^10/3 * |u - v| + 1/3 * 4*10^10 * |u - v| ≤ 4*10^10 * |u - v| := by
      nlinarith [abs_nonneg (u - v)]
    linarith [h32, h33, h34, hsum]
  have h4 : |(u^2/8)*PhiK4u u - (v^2/8)*PhiK4u v| ≤ 4*10^10 * |u - v| := by
    have h41 : (u^2/8)*PhiK4u u - (v^2/8)*PhiK4u v
        = ((u^2-v^2)/8)*PhiK4u u + (v^2/8)*(PhiK4u u - PhiK4u v) := by ring
    rw [h41]
    have h42 := abs_add_le (((u^2-v^2)/8)*PhiK4u u) ((v^2/8)*(PhiK4u u - PhiK4u v))
    have h43 : |((u^2-v^2)/8) * PhiK4u u| ≤ (1/2) * 4*10^10 * |u - v| := by
      rw [abs_mul, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8), abs_of_nonneg hk40]
      have h431 : |u^2 - v^2| ≤ 2 * |u - v| := by
        have h1 : |u^2 - v^2| = |u+v| * |u-v| := by rw [sq_sub_sq, abs_mul]
        have h2 : |u+v| ≤ 2 :=
          abs_le.mpr ⟨by linarith [hu2, hv2], by linarith [hu0, hv0]⟩
        nlinarith [h1, h2, abs_nonneg (u - v)]
      nlinarith [h431, hk4b, abs_nonneg (u - v), hk40]
    have h44 : |(v^2/8) * (PhiK4u u - PhiK4u v)| ≤ (1/8) * 4*10^10 * |u - v| := by
      rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ v^2/8)]
      have h1 : v^2/8 ≤ 1/8 := by nlinarith [hv0, hv2, sq_nonneg v]
      have h2 := mul_le_mul h1 hk4 (abs_nonneg _) (by norm_num : (0:ℝ) ≤ 1/8)
      nlinarith [h2]
    have hsum2 : (1/2) * 4*10^10 * |u - v| + (1/8) * 4*10^10 * |u - v| ≤ 4*10^10 * |u - v| := by
      nlinarith [abs_nonneg (u - v)]
    linarith [h42, h43, h44, hsum2]
  have hmain : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(v/3)*PhiK3u v + (v^2/8)*PhiK4u v)|
      ≤ |(u/3)*PhiK3u u - (v/3)*PhiK3u v| + |(u^2/8)*PhiK4u u - (v^2/8)*PhiK4u v| := by
    have h1 : (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(v/3)*PhiK3u v + (v^2/8)*PhiK4u v)
        = ((v/3)*PhiK3u v - (u/3)*PhiK3u u) + ((u^2/8)*PhiK4u u - (v^2/8)*PhiK4u v) := by ring
    rw [h1]
    have h2 := abs_add_le ((v/3)*PhiK3u v - (u/3)*PhiK3u u) ((u^2/8)*PhiK4u u - (v^2/8)*PhiK4u v)
    have h3 : |(v/3)*PhiK3u v - (u/3)*PhiK3u u| = |(u/3)*PhiK3u u - (v/3)*PhiK3u v| := by
      rw [abs_sub_comm]
    nlinarith [h2, h3]
  have hnum : 4*10^10 * |u - v| + 4*10^10 * |u - v| ≤ 10^12 * |u - v| := by
    nlinarith [abs_nonneg (u - v)]
  linarith [hmain, h3, h4, hnum]

lemma split_bounds {n : ℕ} (hn : 100000000 ≤ n) :
    (1 ≤ Nat.sqrt (n/4) + 1) ∧ (Nat.sqrt (n/4) + 1 ≤ n)
    ∧ (4*(Nat.sqrt (n/4))^2 ≤ n)
    ∧ (Real.sqrt ((n:ℝ))/4 ≤ (Nat.sqrt (n/4):ℝ) + 1) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16 : 16 ≤ n := by omega
  have hnR16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn16
  have hKle : Nat.sqrt (n/4) ≤ n/4 := Nat.sqrt_le_self (n/4)
  have hKsq := Nat.sqrt_le' (n/4)
  have hsq4 : 4 * (Nat.sqrt (n/4))^2 ≤ n := by
    have h1 : 4 * (Nat.sqrt (n/4))^2 ≤ 4 * (n/4) := by omega
    have h2 : 4 * (n/4) ≤ n := by omega
    omega
  refine ⟨by omega, by omega, hsq4, ?_⟩
  have hK0 : (0:ℝ) < (Nat.sqrt (n/4) : ℝ) + 1 := by positivity
  have heq : Real.sqrt ((n:ℝ))/4 = Real.sqrt ((n:ℝ)/16) := by
    rw [Real.sqrt_div (le_of_lt hnR)]
    norm_num
  · rw [heq]
    have h4 : (n:ℝ)/16 ≤ (n:ℝ)/4 - 1 := by nlinarith [hnR16]
    have hb : (n:ℕ) < ((n/4:ℕ) + 1) * 4 := by
      have := Nat.div_add_mod n 4
      omega
    have hbR' : (n:ℝ) < ((((n/4:ℕ) + 1) * 4 : ℕ) : ℝ) := by exact_mod_cast hb
    push_cast at hbR'
    have h2 : (n:ℝ)/4 < (((n/4:ℕ)):ℝ) + 1 := by
      rw [div_lt_iff₀ (by norm_num : (0:ℝ) < 4)]
      linarith [hbR']
    have h5 : (n:ℝ)/4 - 1 ≤ (((n/4:ℕ)):ℝ) := by linarith [h2]
    have hs1 : Real.sqrt ((n:ℝ)/16) ≤ Real.sqrt ((((n/4:ℕ)):ℝ)) :=
      Real.sqrt_le_sqrt (le_trans h4 h5)
    have hs2 : Real.sqrt ((((n/4:ℕ)):ℝ)) < (Nat.sqrt (n/4) : ℝ) + 1 := by
      rw [Real.sqrt_lt' hK0]
      have hb2 := Nat.lt_succ_sqrt' (n/4)
      have hbN : n/4 < (Nat.sqrt (n/4) + 1)^2 := by
        rw [Nat.succ_eq_add_one] at hb2
        exact hb2
      have hbR : (((n/4:ℕ)):ℝ) < ((Nat.sqrt (n/4) : ℝ) + 1)^2 := by
        exact_mod_cast hbN
      exact hbR
    exact le_of_lt (lt_of_le_of_lt hs1 hs2)

lemma uPhiS_expansion (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2)|
      ≤ 3*10^16 * (u - Real.log 2)^2 := by
  have hlog1 : (0:ℝ) ≤ Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have hlog2 : Real.log 2 ≤ 1 := by
    have h : (2:ℝ) ≤ Real.exp 1 := by
      have h1 := Real.add_one_le_exp (1:ℝ)
      norm_num at h1 ⊢
      exact h1
    have h1 := Real.log_le_log (by norm_num : (0:ℝ) < 2) h
    rwa [Real.log_exp] at h1
  have hlog15 : (1/2:ℝ) ≤ Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have hw12 : |u - Real.log 2| ≤ 1/2 := by
    rw [abs_sub_le_iff]
    constructor <;> linarith [hu1, hu2, hlog15, hlog2]
  have hR := PhiS_second_order_at_log2 u hu1 hu2
  have hident : u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2)
      = -26*(u - Real.log 2)^2 + (Real.log 2 + (u - Real.log 2))*(PhiS u - 6 + 26*(u - Real.log 2)) := by
    ring
  rw [hident]
  have h1 : |-26*(u - Real.log 2)^2| ≤ 26 * (u - Real.log 2)^2 := by
    rw [abs_mul, show |(-26:ℝ)| = 26 by norm_num, abs_of_nonneg (sq_nonneg _)]
  have h2 : |(Real.log 2 + (u - Real.log 2))*(PhiS u - 6 + 26*(u - Real.log 2))|
      ≤ (Real.log 2 + |u - Real.log 2|) * (10^16 * (u - Real.log 2)^2) := by
    rw [abs_mul]
    have h21 : |Real.log 2 + (u - Real.log 2)| ≤ Real.log 2 + |u - Real.log 2| := by
      have := abs_add_le (Real.log 2) (u - Real.log 2)
      rw [abs_of_nonneg hlog1] at this
      exact this
    exact mul_le_mul h21 hR (abs_nonneg _) (by positivity)
  have h3 : (Real.log 2 + |u - Real.log 2|) * (10^16 * (u - Real.log 2)^2)
      ≤ 2*10^16 * (u - Real.log 2)^2 := by
    have h31 : Real.log 2 + |u - Real.log 2| ≤ 2 := by linarith [hlog2, hw12]
    have h32 : (Real.log 2 + |u - Real.log 2|) * (10^16 * (u - Real.log 2)^2)
        ≤ 2 * (10^16 * (u - Real.log 2)^2) :=
      mul_le_mul_of_nonneg_right h31 (by positivity)
    nlinarith [h32]
  have h4 := abs_add_le (-26*(u - Real.log 2)^2)
    ((Real.log 2 + (u - Real.log 2))*(PhiS u - 6 + 26*(u - Real.log 2)))
  have hsum : 26 * (u - Real.log 2)^2 + 2*10^16 * (u - Real.log 2)^2
      ≤ 3*10^16 * (u - Real.log 2)^2 := by
    nlinarith [sq_nonneg (u - Real.log 2)]
  have h5 := add_le_add h1 h2
  have h6 : 26 * (u - Real.log 2)^2 + (Real.log 2 + |u - Real.log 2|) * (10^16 * (u - Real.log 2)^2)
      ≤ 26 * (u - Real.log 2)^2 + 2*10^16 * (u - Real.log 2)^2 :=
    add_le_add_right h3 (26 * (u - Real.log 2)^2)
  have h7 := (h4.trans (h5.trans h6)).trans hsum
  exact h7

lemma log_two_le_one : Real.log 2 ≤ 1 := by
  have h : (2:ℝ) ≤ Real.exp 1 := by
    have h1 := Real.add_one_le_exp (1:ℝ)
    norm_num at h1 ⊢
    exact h1
  have h1 := Real.log_le_log (by norm_num : (0:ℝ) < 2) h
  rwa [Real.log_exp] at h1

lemma log_two_ge_half : (1/2:ℝ) ≤ Real.log 2 := by
  have := Real.log_two_gt_d9
  linarith

lemma SThird_leading (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hw : |u - Real.log 2| ≤ 32/(n:ℝ)) :
    |SThird u n - 3*Real.log 2/(n:ℝ)| ≤ 2*10^11/(n:ℝ)^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hup := uPhiS_expansion u hu1 hu2
  have hD := SThird_second_le' u hu1 hu2 n (by omega : 1 ≤ n)
  have hkey : SThird u n - 3*Real.log 2/(n:ℝ)
      = (u*PhiS u - 6*Real.log 2)/(2*(n:ℝ))
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) := by
    rw [SThird]
    field_simp
    ring
  rw [hkey]
  have hE : |u*PhiS u - 6*Real.log 2| ≤ 32 * (32/(n:ℝ)) + 3*10^16 * (32/(n:ℝ))^2 := by
    have h1 : u*PhiS u - 6*Real.log 2
        = (6 - 26*Real.log 2)*(u - Real.log 2)
          + (u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2)) := by ring
    rw [h1]
    have h2 := abs_add_le ((6 - 26*Real.log 2)*(u - Real.log 2))
      (u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))
    have h3 : |(6 - 26*Real.log 2)*(u - Real.log 2)| = |6 - 26*Real.log 2| * |u - Real.log 2| :=
      abs_mul (6 - 26*Real.log 2) (u - Real.log 2)
    have h32 : |6 - 26*Real.log 2| ≤ 32 := by
      rw [abs_le]
      constructor <;> linarith [log_two_ge_half, log_two_le_one]
    have hE2 : |6 - 26*Real.log 2| * |u - Real.log 2| ≤ 32 * (32/(n:ℝ)) :=
      mul_le_mul h32 hw (abs_nonneg _) (by positivity)
    have hE3 : 3*10^16 * (u - Real.log 2)^2 ≤ 3*10^16 * (32/(n:ℝ))^2 := by
      have hq : (u - Real.log 2)^2 ≤ (32/(n:ℝ))^2 := by
        rw [← sq_abs]
        exact sq_le_sq' (by linarith [abs_nonneg (u - Real.log 2), hw]) hw
      exact mul_le_mul_of_nonneg_left hq (by norm_num : (0:ℝ) ≤ 3*10^16)
    have hsum : 32 * (32/(n:ℝ)) + 3*10^16 * (32/(n:ℝ))^2
        ≤ 32 * (32/(n:ℝ)) + 3*10^16 * (32/(n:ℝ))^2 := le_rfl
    linarith [h2, h3, hE2, hE3, hup, hsum]
  have hA : |(u*PhiS u - 6*Real.log 2)/(2*(n:ℝ))| ≤ 10^11/(n:ℝ)^2 := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 2*(n:ℝ))]
    have hn2e9 : (2*10^9:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    have h1 : (32 * (32/(n:ℝ)) + 3*10^16 * (32/(n:ℝ))^2)/(2*(n:ℝ)) ≤ 10^11/(n:ℝ)^2 := by
      rw [div_pow]
      rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
      have hnz : (n:ℝ) ≠ 0 := ne_of_gt hnR
      field_simp [hnz] at *
      ring_nf at *
      nlinarith [hn1, hnR, hn2e9]
    exact (div_le_div_of_nonneg_right hE (by positivity : (0:ℝ) ≤ 2*(n:ℝ))).trans h1
  have hC : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/(n:ℝ)^2 := hD
  have hsum := abs_add_le ((u*PhiS u - 6*Real.log 2)/(2*(n:ℝ)))
    ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))
  have hfinal : 10^11/(n:ℝ)^2 + 4*10^10/(n:ℝ)^2 ≤ 2*10^11/(n:ℝ)^2 := by
    rw [← add_div]
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^2)) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
    nlinarith [hnR]
  linarith [hsum, hA, hC, hfinal]

/-! ### The sharp `s`-expansion and its coefficient -/

lemma PhiK3u_log_two : PhiK3u (Real.log 2) = 26 := by
  rw [PhiK3u]
  have hx : ‖(1/2:ℝ)‖ < 1 := by rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  have hfun : (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(Real.log 2 * (k:ℝ))))
      = (fun k : ℕ => (k:ℝ)^3 * (1/2:ℝ)^k) := by
    funext k
    rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (Real.exp (-(Real.log 2)))^k by
      rw [← Real.exp_nat_mul]; congr 1; ring]
    rw [show Real.exp (-(Real.log 2)) = (1/2:ℝ) by
      rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 2)]; norm_num]
  rw [hfun, tsum_cube_half]

lemma PhiK4u_log_two : PhiK4u (Real.log 2) = 150 := by
  rw [PhiK4u]
  have hx : ‖(1/2:ℝ)‖ < 1 := by rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  have hfun : (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(Real.log 2 * (k:ℝ))))
      = (fun k : ℕ => (k:ℝ)^4 * (1/2:ℝ)^k) := by
    funext k
    rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (Real.exp (-(Real.log 2)))^k by
      rw [← Real.exp_nat_mul]; congr 1; ring]
    rw [show Real.exp (-(Real.log 2)) = (1/2:ℝ) by
      rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 2)]; norm_num]
  rw [hfun, tsum_four_half]

lemma SThird_expansion (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hw : |u - Real.log 2| ≤ 32/(n:ℝ)) (hw2 : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ 10^4/(n:ℝ)^2) :
    |SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ))
        - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2| ≤ 10^23/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hnz : (n:ℝ) ≠ 0 := ne_of_gt hnR
  have hup := uPhiS_expansion u hu1 hu2
  have hDl := D_lipschitz u (Real.log 2) hu1 hu2 log_two_ge_half log_two_le_one
  have hs := SThird_abs_le u hu1 hu2 n (by omega : 1 ≤ n)
  have hident : SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ))
        - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2
      = ((6 - 26*Real.log 2)*3*Real.log 2/8 + (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2))/2 + 27*Real.log 2^2/8 - (3*Real.log 2^2 - (25/12)*Real.log 2))/(n:ℝ)^2
        + (u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))
        + ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2)
        + (6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ))
        + 3*((SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2)/8 := by
    rw [SThird]
    field_simp [hnz]
    ring
  rw [hident]
  have hc : (6 - 26*Real.log 2)*3*Real.log 2/8 + (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2))/2 + 27*Real.log 2^2/8 - (3*Real.log 2^2 - (25/12)*Real.log 2) = 0 := by
    rw [PhiK3u_log_two, PhiK4u_log_two]
    ring
  rw [hc, zero_div, zero_add]
  have hE : |(u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))|
      ≤ 3*10^16 * (32/(n:ℝ))^2/(4*(n:ℝ)) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 4*(n:ℝ))]
    have hup2 : |u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2)|
        ≤ 3*10^16 * (32/(n:ℝ))^2 := by
      have hq : (u - Real.log 2)^2 ≤ (32/(n:ℝ))^2 := by
        rw [← sq_abs]
        exact sq_le_sq' (by linarith [abs_nonneg (u - Real.log 2), hw]) hw
      exact hup.trans (mul_le_mul_of_nonneg_left hq (by norm_num : (0:ℝ) ≤ 3*10^16))
    exact div_le_div_of_nonneg_right hup2 (by positivity)
  have hE2 : 3*10^16 * (32/(n:ℝ))^2/(4*(n:ℝ)) ≤ 10^19/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR]
  have hD : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2)|
      ≤ 10^12 * (32/(n:ℝ))/(2*(n:ℝ)^2) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 2*((n:ℝ)^2))]
    have h1 : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))| ≤ 10^12 * |u - Real.log 2| := by
      have h1' := D_lipschitz u (Real.log 2) hu1 hu2 log_two_ge_half log_two_le_one
      ring_nf at h1' ⊢
      exact h1'
    have h1b : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))| ≤ 10^12 * (32/(n:ℝ)) := by
      have h1c : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))| ≤ 10^12 * |u - Real.log 2| := h1
      exact h1c.trans (mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 10^12))
    exact div_le_div_of_nonneg_right h1b (by positivity)
  have hD2 : 10^12 * (32/(n:ℝ))/(2*(n:ℝ)^2) ≤ 2*10^13/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR]
  have hw2' : |(6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ))|
      ≤ 32 * (10^4/(n:ℝ)^2)/(4*(n:ℝ)) := by
    rw [abs_div, abs_mul, abs_of_pos (by positivity : (0:ℝ) < 4*(n:ℝ))]
    have h61 : |6 - 26*Real.log 2| ≤ 32 := by
      rw [abs_le]
      constructor <;> linarith [log_two_ge_half, log_two_le_one]
    have hprod : |6 - 26*Real.log 2| * |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ 32 * (10^4/(n:ℝ)^2) := by
      have h61b : |6 - 26*Real.log 2| ≤ 32 := h61
      have hw2b : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ 10^4/(n:ℝ)^2 := hw2
      exact mul_le_mul h61b hw2b (abs_nonneg _) (by norm_num : (0:ℝ) ≤ 32)
    exact div_le_div_of_nonneg_right hprod (by positivity)
  have hw2'' : 32 * (10^4/(n:ℝ)^2)/(4*(n:ℝ)) ≤ 10^5/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR]
  have hsq : |3*((SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2)/8| ≤ 3*(2*10^11/(n:ℝ)^2 * (2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ)))/8 := by
    rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8), abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3)]
    have h1 : |(SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2| ≤ 2*10^11/(n:ℝ)^2 * (2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ)) := by
      have hsq : |(SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2| = |SThird u n - 3*Real.log 2/(n:ℝ)| * |SThird u n + 3*Real.log 2/(n:ℝ)| := by
        rw [sq_sub_sq, abs_mul]
        ring_nf
      rw [hsq]
      have hlead := SThird_leading u n hu1 hu2 hn hw
      have hsum : |SThird u n + 3*Real.log 2/(n:ℝ)| ≤ 2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ) := by
        have h2 := abs_add_le (SThird u n) (3*Real.log 2/(n:ℝ))
        rw [abs_of_nonneg (by positivity : (0:ℝ) ≤ 3*Real.log 2/(n:ℝ))] at h2
        linarith [h2, hs]
      have hleadb : |SThird u n - 3*Real.log 2/(n:ℝ)| ≤ 2*10^11/(n:ℝ)^2 := hlead
      exact mul_le_mul hleadb hsum (abs_nonneg _) (by positivity : (0:ℝ) ≤ 2*10^11/(n:ℝ)^2)
    nlinarith [h1, hs]
  have hsq2 : 3*(2*10^11/(n:ℝ)^2 * (2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ)))/8 ≤ 2*10^22/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR, log_two_le_one]
  have hsum := abs_add_le ((u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ)))
    (((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2))
  have hsum2 := abs_add_le ((u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))
      + ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2))
    ((6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ)))
  have hsum3 := abs_add_le ((u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))
      + ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2)
      + (6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ)))
    (3*((SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2)/8)
  have htot : 10^19/((n:ℝ)^3) + 2*10^13/((n:ℝ)^3) + 10^5/((n:ℝ)^3) + 2*10^22/((n:ℝ)^3)
      ≤ 10^23/((n:ℝ)^3) := by
    rw [← add_div, ← add_div, ← add_div]
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) (by positivity : (0:ℝ) < ((n:ℝ)^3))]
    nlinarith
  linarith [hsum3, hsum2, hsum, hE, hE2, hD, hD2, hw2', hw2'', hsq, hsq2, htot]

lemma SThird_expansion_C (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (C2 : ℝ) (hC2 : 0 ≤ C2) (hw : |u - Real.log 2| ≤ 32/(n:ℝ))
    (hw2 : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ C2/(n:ℝ)^2) :
    |SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ))
        - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2| ≤ (10^23 + 10^5*C2)/((n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hnz : (n:ℝ) ≠ 0 := ne_of_gt hnR
  have hup := uPhiS_expansion u hu1 hu2
  have hDl := D_lipschitz u (Real.log 2) hu1 hu2 log_two_ge_half log_two_le_one
  have hs := SThird_abs_le u hu1 hu2 n (by omega : 1 ≤ n)
  have hident : SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ))
        - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2
      = ((6 - 26*Real.log 2)*3*Real.log 2/8 + (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2))/2 + 27*Real.log 2^2/8 - (3*Real.log 2^2 - (25/12)*Real.log 2))/(n:ℝ)^2
        + (u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))
        + ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2)
        + (6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ))
        + 3*((SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2)/8 := by
    rw [SThird]
    field_simp [hnz]
    ring
  rw [hident]
  have hc : (6 - 26*Real.log 2)*3*Real.log 2/8 + (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2))/2 + 27*Real.log 2^2/8 - (3*Real.log 2^2 - (25/12)*Real.log 2) = 0 := by
    rw [PhiK3u_log_two, PhiK4u_log_two]
    ring
  rw [hc, zero_div, zero_add]
  have hE : |(u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))|
      ≤ 3*10^16 * (32/(n:ℝ))^2/(4*(n:ℝ)) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 4*(n:ℝ))]
    have hup2 : |u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2)|
        ≤ 3*10^16 * (32/(n:ℝ))^2 := by
      have hq : (u - Real.log 2)^2 ≤ (32/(n:ℝ))^2 := by
        rw [← sq_abs]
        exact sq_le_sq' (by linarith [abs_nonneg (u - Real.log 2), hw]) hw
      exact hup.trans (mul_le_mul_of_nonneg_left hq (by norm_num : (0:ℝ) ≤ 3*10^16))
    exact div_le_div_of_nonneg_right hup2 (by positivity)
  have hE2 : 3*10^16 * (32/(n:ℝ))^2/(4*(n:ℝ)) ≤ 10^19/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR]
  have hD : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2)|
      ≤ 10^12 * (32/(n:ℝ))/(2*(n:ℝ)^2) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 2*((n:ℝ)^2))]
    have h1 : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))| ≤ 10^12 * |u - Real.log 2| := by
      have h1' := D_lipschitz u (Real.log 2) hu1 hu2 log_two_ge_half log_two_le_one
      ring_nf at h1' ⊢
      exact h1'
    have h1b : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))| ≤ 10^12 * (32/(n:ℝ)) := by
      have h1c : |((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))| ≤ 10^12 * |u - Real.log 2| := h1
      exact h1c.trans (mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 10^12))
    exact div_le_div_of_nonneg_right h1b (by positivity)
  have hD2 : 10^12 * (32/(n:ℝ))/(2*(n:ℝ)^2) ≤ 2*10^13/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR]
  have hw2' : |(6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ))|
      ≤ 32 * (C2/(n:ℝ)^2)/(4*(n:ℝ)) := by
    rw [abs_div, abs_mul, abs_of_pos (by positivity : (0:ℝ) < 4*(n:ℝ))]
    have h61 : |6 - 26*Real.log 2| ≤ 32 := by
      rw [abs_le]
      constructor <;> linarith [log_two_ge_half, log_two_le_one]
    have hprod : |6 - 26*Real.log 2| * |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ 32 * (C2/(n:ℝ)^2) := by
      have h61b : |6 - 26*Real.log 2| ≤ 32 := h61
      have hw2b : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ C2/(n:ℝ)^2 := hw2
      exact mul_le_mul h61b hw2b (abs_nonneg _) (by norm_num : (0:ℝ) ≤ 32)
    exact div_le_div_of_nonneg_right hprod (by positivity)
  have hw2'' : 32 * (C2/(n:ℝ)^2)/(4*(n:ℝ)) ≤ 10^5*C2/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR, hC2]
  have hsq : |3*((SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2)/8| ≤ 3*(2*10^11/(n:ℝ)^2 * (2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ)))/8 := by
    rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8), abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3)]
    have h1 : |(SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2| ≤ 2*10^11/(n:ℝ)^2 * (2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ)) := by
      have hsq : |(SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2| = |SThird u n - 3*Real.log 2/(n:ℝ)| * |SThird u n + 3*Real.log 2/(n:ℝ)| := by
        rw [sq_sub_sq, abs_mul]
        ring_nf
      rw [hsq]
      have hlead := SThird_leading u n hu1 hu2 hn hw
      have hsum : |SThird u n + 3*Real.log 2/(n:ℝ)| ≤ 2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ) := by
        have h2 := abs_add_le (SThird u n) (3*Real.log 2/(n:ℝ))
        rw [abs_of_nonneg (by positivity : (0:ℝ) ≤ 3*Real.log 2/(n:ℝ))] at h2
        linarith [h2, hs]
      have hleadb : |SThird u n - 3*Real.log 2/(n:ℝ)| ≤ 2*10^11/(n:ℝ)^2 := hlead
      exact mul_le_mul hleadb hsum (abs_nonneg _) (by positivity : (0:ℝ) ≤ 2*10^11/(n:ℝ)^2)
    nlinarith [h1, hs]
  have hsq2 : 3*(2*10^11/(n:ℝ)^2 * (2*10^11/(n:ℝ) + 3*Real.log 2/(n:ℝ)))/8 ≤ 2*10^22/((n:ℝ)^3) := by
    field_simp [hnz]
    nlinarith [hn1, hnR, log_two_le_one]
  have hsum := abs_add_le ((u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ)))
    (((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2))
  have hsum2 := abs_add_le ((u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))
      + ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2))
    ((6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ)))
  have hsum3 := abs_add_le ((u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2))/(4*(n:ℝ))
      + ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(Real.log 2/3)*PhiK3u (Real.log 2) + (Real.log 2^2/8)*PhiK4u (Real.log 2)))/(2*(n:ℝ)^2)
      + (6 - 26*Real.log 2)*(u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)))/(4*(n:ℝ)))
    (3*((SThird u n)^2 - (3*Real.log 2/(n:ℝ))^2)/8)
  have htot : 10^19/((n:ℝ)^3) + 2*10^13/((n:ℝ)^3) + 10^5*C2/((n:ℝ)^3) + 2*10^22/((n:ℝ)^3)
      ≤ (10^23 + 10^5*C2)/((n:ℝ)^3) := by
    rw [← add_div, ← add_div, ← add_div]
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) (by positivity : (0:ℝ) < ((n:ℝ)^3))]
    nlinarith [hC2]
  linarith [hsum3, hsum2, hsum, hE, hE2, hD, hD2, hw2', hw2'', hsq, hsq2, htot]

lemma split_bounds' {n : ℕ} (hn : 100000000 ≤ n) :
    (1 ≤ Nat.sqrt (n/4)) ∧ (Nat.sqrt (n/4) ≤ n)
    ∧ (∀ k : ℕ, k ≤ Nat.sqrt (n/4) → 4*k^2 ≤ n)
    ∧ (Real.sqrt ((n:ℝ))/4 ≤ (Nat.sqrt (n/4):ℝ)) := by
  have hn16 : 16 ≤ n := by omega
  have hKsq := Nat.sqrt_le' (n/4)
  have hK : ∀ k : ℕ, k ≤ Nat.sqrt (n/4) → 4*k^2 ≤ n := by
    intro k hk
    have hk2 : k^2 ≤ (Nat.sqrt (n/4))^2 := Nat.pow_le_pow_left hk 2
    have h1 : 4*k^2 ≤ 4*(Nat.sqrt (n/4))^2 := Nat.mul_le_mul_left 4 hk2
    have h2 : 4*(Nat.sqrt (n/4))^2 ≤ n := by
      have h3 : 4*(Nat.sqrt (n/4))^2 ≤ 4*(n/4) := Nat.mul_le_mul_left 4 hKsq
      have h4 : 4*(n/4) ≤ n := Nat.mul_div_le n 4
      exact le_trans h3 h4
    exact le_trans h1 h2
  have h1s : 1 ≤ Nat.sqrt (n/4) := by
    exact (Nat.le_sqrt (n := n/4)).2 (by omega : 1 ≤ n/4)
  have hns : Nat.sqrt (n/4) ≤ n := by
    have h1 := Nat.sqrt_le_self (n/4)
    exact le_trans h1 (by omega : n/4 ≤ n)
  refine ⟨h1s, hns, hK, ?_⟩
  have hb := Nat.lt_succ_sqrt' (n/4)
  have hbN : n/4 < (Nat.sqrt (n/4) + 1)^2 := by
    rw [Nat.succ_eq_add_one] at hb
    exact hb
  have hb1 : (((n/4:ℕ):ℝ)) < ((Nat.sqrt (n/4) : ℝ) + 1)^2 := by
    exact_mod_cast hbN
  have hb2 : Real.sqrt (((n/4:ℕ):ℝ)) < (Nat.sqrt (n/4) : ℝ) + 1 := by
    rw [Real.sqrt_lt' (by positivity : (0:ℝ) < (Nat.sqrt (n/4) : ℝ) + 1)]
    exact hb1
  have hq : (n:ℝ)/4 ≤ (((n/4:ℕ):ℝ) + 1) := by
    have hbm : (n:ℕ) < ((n/4:ℕ) + 1) * 4 := by
      have := Nat.div_add_mod n 4
      omega
    have hbR : (n:ℝ) < ((((n/4:ℕ) + 1) * 4 : ℕ) : ℝ) := by exact_mod_cast hbm
    push_cast at hbR
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 4)]
    linarith
  have hsq : Real.sqrt ((n:ℝ)/4) ≤ Real.sqrt ((((n/4:ℕ):ℝ) + 1)) :=
    Real.sqrt_le_sqrt hq
  have hs2 : Real.sqrt ((((n/4:ℕ):ℝ) + 1)) ≤ Real.sqrt (((n/4:ℕ):ℝ)) + 1 := by
    rw [Real.sqrt_le_left (by positivity : (0:ℝ) ≤ Real.sqrt (((n/4:ℕ):ℝ)) + 1)]
    have hsqx : Real.sqrt (((n/4:ℕ):ℝ))^2 = (((n/4:ℕ):ℝ)) := Real.sq_sqrt (by positivity)
    ring_nf
    nlinarith [hsqx, Real.sqrt_nonneg (((n/4:ℕ):ℝ))]
  have hK2 : (2:ℝ) ≤ (Nat.sqrt (n/4) : ℝ) := by
    have h4 : (4:ℕ)^2 ≤ n/4 := by
      exact (Nat.le_div_iff_mul_le (by norm_num : 0 < 4)).2 (by norm_num; omega)
    have h4s : 4 ≤ Nat.sqrt (n/4) := (Nat.le_sqrt (n := n/4)).2 h4
    have h4R : (4:ℝ) ≤ (Nat.sqrt (n/4) : ℝ) := by exact_mod_cast h4s
    have h2R : (2:ℝ) ≤ (4:ℝ) := by norm_num
    linarith [h2R, h4R]
  have heq : Real.sqrt ((n:ℝ))/4 = Real.sqrt ((n:ℝ)/4)/2 := by
    rw [Real.sqrt_div (by positivity : (0:ℝ) ≤ (n:ℝ))]
    ring_nf
  rw [heq]
  calc Real.sqrt ((n:ℝ)/4)/2 ≤ Real.sqrt ((((n/4:ℕ):ℝ) + 1))/2 := by nlinarith [hsq]
    _ ≤ (Real.sqrt (((n/4:ℕ):ℝ)) + 1)/2 := by nlinarith [hs2]
    _ ≤ ((Nat.sqrt (n/4):ℝ) + 2)/2 := by nlinarith [hb2]
    _ ≤ (Nat.sqrt (n/4):ℝ) := by nlinarith [hK2]

/-! ### Third-order uniform threshold bound -/

/-! ### Third-order uniform threshold bound -/

lemma threshold_third_order_uniform :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      IsThreshold n (u*(n:ℝ)) →
        |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)) - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2|
          ≤ C/(n:ℝ)^3 := by
  let C3 : ℝ := 8*10^10 + 2*(4*10^10 + 5) + 7
  obtain ⟨C2, hC2pos, hev2⟩ := threshold_second_order_uniform
  refine ⟨2*C3 + 4*10^34 + 10^23 + 10^5*C2, by dsimp [C3]; positivity, ?_⟩
  have hN : ∀ᶠ n : ℕ in Filter.atTop, (10^12:ℕ) ≤ n ∧ 32 ≤ n ∧ C3 + 4*10^10 ≤ (n:ℝ) ∧ (8*10^11:ℕ) ≤ n := by
    filter_upwards [Filter.eventually_ge_atTop (10^12), Filter.eventually_ge_atTop 32]
      with n hn12 hn32
    have hn12R : (10^12:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn12
    have hC : C3 + 4*10^10 ≤ (n:ℝ) := by
      have : C3 + 4*10^10 ≤ (10^12:ℝ) := by dsimp [C3]; norm_num
      linarith
    have hb : (8*10^11:ℕ) ≤ n := by omega
    exact ⟨hn12, hn32, hC, hb⟩
  filter_upwards [hev2, hN] with n hw2' hnbigs
  intro u hu1 hu2 hthr
  obtain ⟨hn12, hn32, hnC0, hnbig⟩ := hnbigs
  have hn12R : (10^12:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn12
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : 1 ≤ n := by omega
  have hC3 : (0:ℝ) ≤ C3 := by dsimp [C3]; norm_num
  have hnC3 : C3 ≤ (n:ℝ) := by
    have : C3 ≤ (10^12:ℝ) := by dsimp [C3]; norm_num
    linarith
  have sb := split_bounds' (by omega : 100000000 ≤ n)
  have hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3) := by
    have h := Phi_third_order hu1 hu2 (by omega : 2000000000 ≤ n) sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
    dsimp [SThird, C3]
    convert h using 1
    · ring
  have hexp := threshold_exp_two_le u hu1 hu2 n (by omega : 1 ≤ n) C3 hC3 hn32 hnC0 hbound3 hthr
  have hlogx : |Real.log (Real.exp u) - Real.log 2| ≤ |Real.exp u - 2| :=
    abs_log_sub_log_two_le (Real.exp u) (by rw [Real.one_le_exp_iff]; linarith)
  have hw : |u - Real.log 2| ≤ 32/(n:ℝ) := by
    rw [Real.log_exp] at hlogx
    linarith [hlogx, hexp]
  have hw2 : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ C2/(n:ℝ)^2 := hw2' u hu1 hu2 hthr
  have hexp3 := threshold_exp_bound_third u hu1 hu2 n (by omega : 1 ≤ n) C3 hC3 hnC3 hnbig hbound3 hthr
  have hlog3 := threshold_log_bound_third u hu1 hu2 n (by omega : 1 ≤ n) hn32 hexp
  have hsexp := SThird_expansion_C u n hu1 hu2 (by omega : 2000000000 ≤ n) C2 hC2pos.le hw hw2
  have hid : u - Real.log 2 - SThird u n/2 - 3*(SThird u n)^2/8
      = (u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8)
        + (Real.exp u - 2 - SThird u n - (SThird u n)^2)/2
        + (-((Real.exp u - 2)^2 - (SThird u n)^2))/8 := by ring
  have hstage1 : |u - Real.log 2 - SThird u n/2 - 3*(SThird u n)^2/8| ≤ (2*C3 + 4*10^34)/((n:ℝ)^3) := by
    rw [hid]
    have hs := SThird_abs_le u hu1 hu2 n (by omega : 1 ≤ n)
    have h1 : |u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8| ≤ 8192/((n:ℝ)^3) := hlog3
    have h2 : |(Real.exp u - 2 - SThird u n - (SThird u n)^2)/2| ≤ ((4*C3 + 4*10^34)/((n:ℝ)^3))/2 := by
      rw [abs_div, abs_of_pos (by norm_num : (0:ℝ) < 2)]
      exact div_le_div_of_nonneg_right hexp3 (by norm_num : (0:ℝ) ≤ 2)
    have h3 : |((Real.exp u - 2)^2 - (SThird u n)^2)/8| ≤ 10^34/((n:ℝ)^3) := by
      rw [abs_div, abs_of_pos (by norm_num : (0:ℝ) < 8)]
      have h32 : ((4*C3 + 4*10^34)/((n:ℝ)^3) + (2*10^11/(n:ℝ))^2) * (3*10^11/(n:ℝ)) ≤ 26*10^33/((n:ℝ)^3) := by
        have hA : (4*C3 + 4*10^34)/((n:ℝ)^3) * (3*10^11/(n:ℝ)) ≤ 13*10^33/((n:ℝ)^3) := by
          have hC3n : 4*C3 + 4*10^34 ≤ 4*(n:ℝ) + 4*10^34 := by linarith [hnC3]
          have h1 : (4*C3 + 4*10^34)/((n:ℝ)^3) * (3*10^11/(n:ℝ))
              ≤ (4*(n:ℝ) + 4*10^34)/((n:ℝ)^3) * (3*10^11/(n:ℝ)) := by
            exact mul_le_mul_of_nonneg_right
              (div_le_div_of_nonneg_right hC3n (by positivity : (0:ℝ) ≤ (n:ℝ)^3))
              (by positivity : (0:ℝ) ≤ 3*10^11/(n:ℝ))
          have h2 : (4*(n:ℝ) + 4*10^34)/((n:ℝ)^3) * (3*10^11/(n:ℝ)) ≤ 13*10^33/((n:ℝ)^3) := by
            field_simp [hnR]
            nlinarith [hn12R, hnR]
          linarith [h1, h2]
        have hB : (2*10^11/(n:ℝ))^2 * (3*10^11/(n:ℝ)) = 12*10^33/((n:ℝ)^3) := by
          field_simp [hnR]
          ring
        have hdist : ((4*C3 + 4*10^34)/((n:ℝ)^3) + (2*10^11/(n:ℝ))^2) * (3*10^11/(n:ℝ))
            = (4*C3 + 4*10^34)/((n:ℝ)^3) * (3*10^11/(n:ℝ)) + (2*10^11/(n:ℝ))^2 * (3*10^11/(n:ℝ)) := by ring
        rw [hdist]
        have hsumAB : 13*10^33/((n:ℝ)^3) + 12*10^33/((n:ℝ)^3) ≤ 26*10^33/((n:ℝ)^3) := by
          rw [← add_div]
          rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) (by positivity : (0:ℝ) < ((n:ℝ)^3))]
          nlinarith [hnR]
        linarith [hA, hB, hsumAB]
      have h31 : |(Real.exp u - 2)^2 - (SThird u n)^2| ≤ 26*10^33/((n:ℝ)^3) := by
        have hd : |Real.exp u - 2 - SThird u n| ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) + (2*10^11/(n:ℝ))^2 := by
          have hid2 : Real.exp u - 2 - SThird u n = (Real.exp u - 2 - SThird u n - (SThird u n)^2) + (SThird u n)^2 := by ring
          rw [hid2]
          have hdd := abs_add_le (Real.exp u - 2 - SThird u n - (SThird u n)^2) ((SThird u n)^2)
          have hs2 : |(SThird u n)^2| ≤ (2*10^11/(n:ℝ))^2 := by
            rw [abs_of_nonneg (sq_nonneg _), ← sq_abs]
            exact sq_le_sq' (by linarith [abs_nonneg (SThird u n), hs]) hs
          linarith [hdd, hexp3, hs2]
        have hsum : |Real.exp u - 2 + SThird u n| ≤ 3*10^11/(n:ℝ) := by
          have h := abs_add_le (Real.exp u - 2) (SThird u n)
          have hnum : (32:ℝ) + 2*10^11 ≤ 3*10^11 := by norm_num
          have hsum2 : 32/(n:ℝ) + 2*10^11/(n:ℝ) ≤ 3*10^11/(n:ℝ) := by
            rw [← add_div]
            exact div_le_div_of_nonneg_right hnum (by positivity : (0:ℝ) ≤ (n:ℝ))
          linarith [h, hexp, hs, hsum2]
        rw [sq_sub_sq, abs_mul, mul_comm]
        have hmul : |Real.exp u - 2 - SThird u n| * |Real.exp u - 2 + SThird u n|
            ≤ ((4*C3 + 4*10^34)/((n:ℝ)^3) + (2*10^11/(n:ℝ))^2) * (3*10^11/(n:ℝ)) :=
          mul_le_mul hd hsum (abs_nonneg _)
            (by
              have h4C : (0:ℝ) ≤ 4*C3 + 4*10^34 := by linarith [hC3]
              have hd1 : (0:ℝ) ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) := div_nonneg h4C (by positivity)
              have hd2 : (0:ℝ) ≤ (2*10^11/(n:ℝ))^2 := sq_nonneg _
              linarith)
        exact hmul.trans h32
      have h3' : |(Real.exp u - 2)^2 - (SThird u n)^2|/8 ≤ (26*10^33/((n:ℝ)^3))/8 :=
        div_le_div_of_nonneg_right h31 (by norm_num : (0:ℝ) ≤ 8)
      have h3'' : (26*10^33/((n:ℝ)^3))/8 ≤ 10^34/((n:ℝ)^3) := by
        field_simp [hnR]
        nlinarith [hnR]
      linarith [h3', h3'']
    have hsum1 := abs_add_le (u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8)
      ((Real.exp u - 2 - SThird u n - (SThird u n)^2)/2)
    have hsum2 := abs_add_le (u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8
        + (Real.exp u - 2 - SThird u n - (SThird u n)^2)/2)
      ((-((Real.exp u - 2)^2 - (SThird u n)^2))/8)
    have hneg2 : |(-((Real.exp u - 2)^2 - (SThird u n)^2))/8| = |((Real.exp u - 2)^2 - (SThird u n)^2)/8| := by
      rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8), abs_neg, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8)]
    have htot : 8192/((n:ℝ)^3) + ((4*C3 + 4*10^34)/((n:ℝ)^3))/2 + 10^34/((n:ℝ)^3) ≤ (2*C3 + 4*10^34)/((n:ℝ)^3) := by
      field_simp [hnR]
      dsimp [C3]
      nlinarith [hnR]
    linarith [hsum2, hsum1, h1, h2, h3, hneg2, htot]
  have hstage2 : |SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ))
        - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2| ≤ (10^23 + 10^5*C2)/((n:ℝ)^3) := hsexp
  have hfin : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)) - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2|
      ≤ (2*C3 + 4*10^34 + 10^23 + 10^5*C2)/((n:ℝ)^3) := by
    have hidf : u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)) - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2
        = (u - Real.log 2 - SThird u n/2 - 3*(SThird u n)^2/8)
          + (SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ)) - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2) := by ring
    rw [hidf]
    have h := abs_add_le (u - Real.log 2 - SThird u n/2 - 3*(SThird u n)^2/8)
      (SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ)) - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2)
    have htot2 : (2*C3 + 4*10^34)/((n:ℝ)^3) + (10^23 + 10^5*C2)/((n:ℝ)^3) ≤ (2*C3 + 4*10^34 + 10^23 + 10^5*C2)/((n:ℝ)^3) := by
      rw [← add_div]
      ring_nf
      have : (0:ℝ) < ((n:ℝ)^3) := by positivity
      nlinarith
    linarith [h, hstage1, hstage2, htot2]
  exact hfin

/-! ### Monotonicity of `Phi` in the exponent -/

lemma summable_phi_gt_one (p : ℝ) (n : ℕ) (hn : 1 ≤ n) (hp : 1 < p) :
    Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hbase : Summable (fun j : ℕ => ((n:ℝ) ^ p) * (((j : ℝ) + 1) ^ (-p))) := by
    have h1 : Summable (fun j : ℕ => ((j : ℝ) + 1) ^ (-p)) := by
      have h2 : Summable (fun j : ℕ => (((j:ℕ) + 1 : ℝ) ^ p)⁻¹) := by
        have hc : (fun n : ℕ => ((↑n : ℝ) ^ p)⁻¹) ∘ Nat.succ = fun j : ℕ => ((↑(j+1) : ℝ) ^ p)⁻¹ := by
          funext j
          rfl
        have h2' := (Real.summable_nat_rpow_inv.mpr hp).comp_injective Nat.succ_injective
        rw [hc] at h2'
        convert h2' using 1
        ext j
        simp only [Nat.cast_add]
        norm_num
      refine h2.congr (fun j => ?_)
      rw [Real.rpow_neg (by positivity : (0:ℝ) ≤ (j:ℝ) + 1) p]
    exact h1.mul_left ((n:ℝ) ^ p)
  refine Summable.of_nonneg_of_le (fun j => Real.rpow_nonneg (by positivity) _) (fun j => ?_) hbase
  have hx0 : (0:ℝ) < ((j : ℝ) + 1) / (n : ℝ) := by positivity
  have h1 : (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p) ≤ (((j : ℝ) + 1) / (n : ℝ)) ^ (-p) :=
    Real.rpow_le_rpow_of_nonpos hx0 (by linarith) (by linarith [hp.le] : (-p) ≤ 0)
  have h2 : (((j : ℝ) + 1) / (n : ℝ)) ^ (-p) = ((n:ℝ) ^ p) * (((j : ℝ) + 1) ^ (-p)) := by
    have hdiv : (((j : ℝ) + 1) / (n : ℝ)) ^ (-p) = (((j : ℝ) + 1) ^ (-p)) / ((n : ℝ) ^ (-p)) :=
      Real.div_rpow (by positivity : (0:ℝ) ≤ (j:ℝ) + 1) hnR.le (-p)
    rw [hdiv, Real.rpow_neg hnR.le p]
    field_simp [ne_of_gt (Real.rpow_pos_of_pos hnR p)]
  exact h1.trans (le_of_eq h2)



lemma Phi_antitone (n : ℕ) (hn : 1 ≤ n) (p1 p2 : ℝ) (hp1 : 1 < p1) (h : p1 ≤ p2) :
    Phi p2 n ≤ Phi p1 n := by
  have hf : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p1)) :=
    summable_phi_gt_one p1 n hn hp1
  have hg : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p2)) :=
    summable_phi_gt_one p2 n hn (lt_of_lt_of_le hp1 h)
  rw [Phi, Phi]
  refine Summable.tsum_le_tsum (fun j => ?_) hg hf
  have hbase : (1:ℝ) ≤ 1 + (((j : ℝ) + 1) / (n : ℝ)) := by
    have hx : (0:ℝ) ≤ (((j : ℝ) + 1) / (n : ℝ)) := div_nonneg (by positivity) (by positivity)
    linarith
  exact Real.rpow_le_rpow_of_exponent_le hbase (by linarith)

lemma Phi_strictAnti (n : ℕ) (hn : 1 ≤ n) (p1 p2 : ℝ) (hp1 : 1 < p1) (h : p1 < p2) :
    Phi p2 n < Phi p1 n := by
  have hf : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p1)) :=
    summable_phi_gt_one p1 n hn hp1
  have hg : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p2)) :=
    summable_phi_gt_one p2 n hn (lt_trans hp1 h)
  rw [Phi, Phi]
  refine Summable.tsum_lt_tsum (i := 0) (fun j => ?_) ?_ hg hf
  · have hbase : (1:ℝ) ≤ 1 + (((j : ℝ) + 1) / (n : ℝ)) := by
      have hx : (0:ℝ) ≤ (((j : ℝ) + 1) / (n : ℝ)) := div_nonneg (by positivity) (by positivity)
      linarith
    exact Real.rpow_le_rpow_of_exponent_le hbase (by linarith [h.le])
  · have hnpos : (0:ℝ) < (n:ℝ) := by exact_mod_cast (show (0:ℕ) < n by omega)
    have hbase : (1:ℝ) < 1 + ((↑(0:ℕ) + 1) / (n : ℝ)) := by
      norm_num
      linarith [div_pos (by norm_num : (0:ℝ) < 1) hnpos]
    exact Real.rpow_lt_rpow_of_exponent_lt hbase (by linarith)

lemma Phi_two_gt_one' {n : ℕ} (hn : 10 ≤ n) : 1 < Phi 2 n := by
  let f : ℕ → ℝ := fun j => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ))
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hnonneg : ∀ j : ℕ, (0:ℝ) ≤ f j :=
    fun j => Real.rpow_nonneg (by positivity) _
  have hn1 : 1 ≤ n := by omega
  have hnz : (n:ℝ) ≠ 0 := by exact_mod_cast (show (n:ℕ) ≠ 0 by omega)
  have hf : Summable f := by
    have h1 := summable_phi (2/(n:ℝ)) n hn1 (by
      rw [show (2/(n:ℝ))*(n:ℝ) = 2 by field_simp [hnz]])
    refine h1.congr (fun j => ?_)
    rw [show -((2/(n:ℝ))*(n:ℝ)) = -(2:ℝ) by field_simp [hnz]]
  have htwo : (1:ℝ) < f 0 + f 1 := by
    dsimp [f]
    have hle : 1 + (((1:ℝ) + 1) / (n : ℝ)) ≤ 6/5 := by
      have hn10 : (10:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
      have hd : (2:ℝ)/(n:ℝ) ≤ 2/10 := div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 2) (by norm_num : (0:ℝ) < 10) hn10
      linarith
    have hr : (6/5:ℝ) ^ (-(2:ℝ)) ≤ (1 + (((1:ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) :=
      Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((1:ℝ) + 1) / (n : ℝ))) hle (by norm_num : (-(2:ℝ)) ≤ 0)
    have hr0 : (6/5:ℝ) ^ (-(2:ℝ)) ≤ (1 + (((0:ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) := by
      have hle0 : 1 + (((0:ℝ) + 1) / (n : ℝ)) ≤ 6/5 := by
        have hn10 : (10:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
        have hd : (1:ℝ)/(n:ℝ) ≤ 1/10 := div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 1) (by norm_num : (0:ℝ) < 10) hn10
        linarith
      exact Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((0:ℝ) + 1) / (n : ℝ))) hle0 (by norm_num : (-(2:ℝ)) ≤ 0)
    have hval : (2/3:ℝ) ≤ (6/5:ℝ) ^ (-(2:ℝ)) := by
      rw [show (-(2:ℝ)) = ((-2:ℤ):ℝ) by norm_num, Real.rpow_intCast]
      norm_num
    linarith [hr, hr0, hval]
  have hsum : f 0 + f 1 ≤ Phi 2 n := by
    rw [Phi]
    have htr : HasSum (fun j : ℕ => if j = 0 then f 0 else if j = 1 then f 1 else 0) (f 0 + f 1) := by
      have hs0 := hasSum_ite_eq 0 (f 0)
      have hs1 := hasSum_ite_eq 1 (f 1)
      have hsum := hs0.add hs1
      have hfun : (fun j : ℕ => if j = 0 then f 0 else if j = 1 then f 1 else 0)
          = (fun j : ℕ => (if j = 0 then f 0 else 0) + (if j = 1 then f 1 else 0)) := by
        funext j
        by_cases h0 : j = 0 <;> by_cases h1 : j = 1 <;> simp [h0, h1]
      rwa [← hfun] at hsum
    have htrS : Summable (fun j : ℕ => if j = 0 then f 0 else if j = 1 then f 1 else 0) := htr.summable
    have hge : ∀ j : ℕ, (if j = 0 then f 0 else if j = 1 then f 1 else 0) ≤ f j := by
      intro j
      by_cases h0 : j = 0
      · subst h0; simp
      · by_cases h1 : j = 1
        · subst h1; simp
        · simp [h0, h1]; exact hnonneg j
    have h := Summable.tsum_le_tsum hge htrS hf
    rwa [htr.tsum_eq] at h
  linarith [htwo, hsum]

lemma first_two_terms_gt_one {n : ℕ} (hn : 10 ≤ n) :
    (1:ℝ) < (1 + (((0:ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ))
      + (1 + (((1:ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) := by
  have hle : 1 + (((1:ℝ) + 1) / (n : ℝ)) ≤ 6/5 := by
    have hn10 : (10:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    have hd : (2:ℝ)/(n:ℝ) ≤ 2/10 := div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 2) (by norm_num : (0:ℝ) < 10) hn10
    linarith
  have hr : (6/5:ℝ) ^ (-(2:ℝ)) ≤ (1 + (((1:ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) :=
    Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((1:ℝ) + 1) / (n : ℝ))) hle (by norm_num : (-(2:ℝ)) ≤ 0)
  have hr0 : (6/5:ℝ) ^ (-(2:ℝ)) ≤ (1 + (((0:ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) := by
    have hle0 : 1 + (((0:ℝ) + 1) / (n : ℝ)) ≤ 6/5 := by
      have hn10 : (10:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
      have hd : (1:ℝ)/(n:ℝ) ≤ 1/10 := div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 1) (by norm_num : (0:ℝ) < 10) hn10
      linarith
    exact Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((0:ℝ) + 1) / (n : ℝ))) hle0 (by norm_num : (-(2:ℝ)) ≤ 0)
  have hval : (2/3:ℝ) ≤ (6/5:ℝ) ^ (-(2:ℝ)) := by
    rw [show (-(2:ℝ)) = ((-2:ℤ):ℝ) by norm_num, Real.rpow_intCast]
    norm_num
  linarith [hr, hr0, hval]

/-! ### The threshold lies in `[1/2, 1]` -/

lemma exp_half_le_seven_fourths : Real.exp (1/2) ≤ 7/4 := by
  have hlog : (1/2:ℝ) ≤ Real.log (7/4) := by
    have h := log_one_add_ge_quartic (3/4) (by norm_num)
    nlinarith [h]
  have h1 := Real.exp_le_exp.mpr hlog
  rw [Real.exp_log (by norm_num : (0:ℝ) < 7/4)] at h1
  exact h1

lemma exp_half_inv_ge : (4/3:ℝ) ≤ (Real.exp (1/2) - 1)⁻¹ := by
  have h := exp_half_le_seven_fourths
  have hpos : (0:ℝ) < Real.exp (1/2) - 1 := by
    have := Real.exp_pos (1/2)
    have h1 : (1:ℝ) < Real.exp (1/2) := by
      exact (Real.one_lt_exp_iff).2 (by norm_num : (0:ℝ) < 1/2)
    linarith
  have hle : Real.exp (1/2) - 1 ≤ 3/4 := by linarith
  have hinv : (3/4:ℝ)⁻¹ ≤ (Real.exp (1/2) - 1)⁻¹ :=
    (inv_le_inv₀ (by norm_num : (0:ℝ) < 3/4) hpos).2 hle
  have h34 : (3/4:ℝ)⁻¹ = 4/3 := by norm_num
  rw [h34] at hinv
  exact hinv

lemma exp_one_inv_le_three_fourths : (Real.exp 1 - 1)⁻¹ ≤ 3/4 := by
  have h74 : (7/3:ℝ) ≤ Real.exp 1 := by
    have h1 : Real.log (7/4) ≤ 2/3 := by
      have h := log_one_add_le_cubic (3/4) (by norm_num)
      nlinarith [h]
    have h2 : Real.log (4/3) ≤ 1/3 := by
      have h := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 4/3)
      nlinarith [h]
    have h3 : Real.log (7/3) ≤ 1 := by
      have h4 : Real.log (7/3) = Real.log (7/4) + Real.log (4/3) := by
        rw [← Real.log_mul (by norm_num : (7/4:ℝ) ≠ 0) (by norm_num : (4/3:ℝ) ≠ 0)]
        norm_num
      rw [h4]
      linarith [h1, h2]
    have h5 := Real.exp_le_exp.mpr h3
    rw [Real.exp_log (by norm_num : (0:ℝ) < 7/3)] at h5
    linarith [h5]
  have hpos : (0:ℝ) < Real.exp 1 - 1 := by
    have h1 : (1:ℝ) < Real.exp 1 := (Real.one_lt_exp_iff).2 (by norm_num : (0:ℝ) < 1)
    linarith
  have hle2 : (4/3:ℝ) ≤ Real.exp 1 - 1 := by linarith
  have hinv : (Real.exp 1 - 1)⁻¹ ≤ (4/3:ℝ)⁻¹ :=
    (inv_le_inv₀ hpos (by norm_num : (0:ℝ) < 4/3)).2 hle2
  have h43 : (4/3:ℝ)⁻¹ = 3/4 := by norm_num
  rw [h43] at hinv
  exact hinv

lemma threshold_u_range :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ,
      IsThreshold n (u*(n:ℝ)) → 1/2 ≤ u ∧ u ≤ 1 := by
  filter_upwards [Filter.eventually_ge_atTop (max 10 (Nat.ceil (4*PhiC)))]
    with n hn
  intro u hthr
  have hn10 : 10 ≤ n := le_trans (le_max_left _ _) hn
  have hn4 : 4 ≤ n := by omega
  have hn1 : 1 ≤ n := by omega
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hK : 4*PhiC ≤ (n:ℝ) := by
    have h1 : (⌈4*PhiC⌉₊ : ℝ) ≤ (n:ℝ) := by
      exact_mod_cast (le_trans (le_max_right _ _) hn)
    calc 4*PhiC ≤ (⌈4*PhiC⌉₊ : ℝ) := Nat.le_ceil _
      _ ≤ (n:ℝ) := h1
  have hPhiC : PhiC/(n:ℝ) ≤ 1/4 := by
    rw [div_le_iff₀ hnR]
    nlinarith [hK]
  have hu_ge : 1/2 ≤ u := by
    by_contra hbad
    have hu2 : u < 1/2 := lt_of_not_ge hbad
    have h2un : 2 < u*(n:ℝ) := by
      by_contra hbad2
      have hle : u*(n:ℝ) ≤ 2 := le_of_not_gt hbad2
      let fp : ℕ → ℝ := fun j => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u*(n:ℝ)))
      let f2 : ℕ → ℝ := fun j => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ))
      have hsumm : Summable fp := by
        by_contra hbadS
        have h0 : Phi (u*(n:ℝ)) n = 0 := by
          rw [Phi]
          exact tsum_eq_zero_of_not_summable hbadS
        have hthr' : Phi (u*(n:ℝ)) n = 1 := hthr
        linarith [h0, hthr']
      have hlej : ∀ j : ℕ, f2 j ≤ fp j := by
        intro j
        dsimp [f2, fp]
        have hbase : (1:ℝ) ≤ 1 + (((j : ℝ) + 1) / (n : ℝ)) := by
          have hx : (0:ℝ) ≤ (((j : ℝ) + 1) / (n : ℝ)) := div_nonneg (by positivity) (by positivity)
          linarith
        exact Real.rpow_le_rpow_of_exponent_le hbase (by linarith)
      have htwo : (1:ℝ) < f2 0 + f2 1 := by
        dsimp [f2]
        simpa only [Nat.cast_zero, Nat.cast_one] using (first_two_terms_gt_one hn10)
      have hgt : (1:ℝ) < fp 0 + fp 1 := by linarith [hlej 0, hlej 1, htwo]
      have htr : HasSum (fun j : ℕ => if j = 0 then fp 0 else if j = 1 then fp 1 else 0) (fp 0 + fp 1) := by
        have hs0 := hasSum_ite_eq 0 (fp 0)
        have hs1 := hasSum_ite_eq 1 (fp 1)
        have hsum := hs0.add hs1
        have hfun : (fun j : ℕ => if j = 0 then fp 0 else if j = 1 then fp 1 else 0)
            = (fun j : ℕ => (if j = 0 then fp 0 else 0) + (if j = 1 then fp 1 else 0)) := by
          funext j
          by_cases h0 : j = 0 <;> by_cases h1 : j = 1 <;> simp [h0, h1]
        rwa [← hfun] at hsum
      have hnonneg : ∀ j : ℕ, (0:ℝ) ≤ fp j := fun j => Real.rpow_nonneg (by positivity) _
      have hge : ∀ j : ℕ, (if j = 0 then fp 0 else if j = 1 then fp 1 else 0) ≤ fp j := by
        intro j
        by_cases h0 : j = 0
        · subst h0; simp
        · by_cases h1 : j = 1
          · subst h1; simp
          · simp [h0, h1]; exact hnonneg j
      have h1 := Summable.tsum_le_tsum hge htr.summable hsumm
      have h2 : fp 0 + fp 1 ≤ Phi (u*(n:ℝ)) n := by
        rw [Phi]
        rw [htr.tsum_eq] at h1
        exact h1
      have hthr' : Phi (u*(n:ℝ)) n = 1 := hthr
      linarith [hgt, h2, hthr']
    have hstrict := Phi_strictAnti n hn1 (u*(n:ℝ)) ((1/2:ℝ)*(n:ℝ)) (by linarith) (by
      nlinarith [hu2, hnR])
    have hPhi2 : Phi ((1/2:ℝ)*(n:ℝ)) n < 1 := hstrict.trans_eq hthr
    have hend := Phi_asymptotic_explicit n hn4 (1/2) (by norm_num) (by norm_num)
    have hend1 : 1 ≤ Phi ((1/2:ℝ)*(n:ℝ)) n := by
      have hlo : (Real.exp (1/2) - 1)⁻¹ - PhiC/(n:ℝ) ≤ Phi ((1/2:ℝ)*(n:ℝ)) n := by
        have habs := (abs_sub_le_iff.mp hend).2
        linarith [habs]
      have hsum : (1:ℝ) ≤ (Real.exp (1/2) - 1)⁻¹ - PhiC/(n:ℝ) := by
        linarith [exp_half_inv_ge, hPhiC]
      linarith [hlo, hsum]
    exact (not_lt.mpr hend1) hPhi2
  have hu_le : u ≤ 1 := by
    by_contra hbad
    have hu2 : 1 < u := lt_of_not_ge hbad
    have hstrict := Phi_strictAnti n hn1 (n:ℝ) (u*(n:ℝ)) (by exact_mod_cast (by omega : 2 ≤ n)) (by
      nlinarith [hu2, hnR])
    have hPhi2 : Phi (u*(n:ℝ)) n < Phi (n:ℝ) n := hstrict
    have hend : |Phi (n:ℝ) n - (Real.exp 1 - 1)⁻¹| ≤ PhiC/(n:ℝ) := by
      simpa using (Phi_asymptotic_explicit n hn4 1 (by norm_num) (by norm_num))
    have hend1 : Phi (n:ℝ) n ≤ 1 := by
      have hhi : Phi (n:ℝ) n ≤ (Real.exp 1 - 1)⁻¹ + PhiC/(n:ℝ) := by
        have habs := (abs_sub_le_iff.mp hend).1
        linarith [habs]
      have hsum : (Real.exp 1 - 1)⁻¹ + PhiC/(n:ℝ) ≤ 1 := by
        linarith [exp_one_inv_le_three_fourths, hPhiC]
      linarith [hhi, hsum]
    have h3' : Phi (u*(n:ℝ)) n = 1 := hthr
    have hlt : Phi (u*(n:ℝ)) n < 1 := hPhi2.trans_le hend1
    linarith [hlt, h3']
  exact ⟨hu_ge, hu_le⟩

/-! ### The exact Brown-criterion / threshold bridge -/

lemma IsComplete_iff (p N : ℕ) : IsComplete p N ↔ 1 ≤ Phi (p : ℝ) (N + 1) := by
  have h2 : (0:ℝ) < (2:ℝ) ^ (p:ℝ) := Real.rpow_pos_of_pos (by norm_num) _
  have hN : (0:ℝ) < ((N:ℝ) + 1) ^ (p:ℝ) := Real.rpow_pos_of_pos (by positivity) _
  have hc : (0:ℝ) < (2:ℝ) ^ (p:ℝ) * ((N:ℝ) + 1) ^ (p:ℝ) := mul_pos h2 hN
  have key0 : (2:ℝ) ^ (p:ℝ) * ((N:ℝ) + 1) ^ (p:ℝ) * term p N = 1 := by
    unfold term
    rw [Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) (by positivity : (0:ℝ) ≤ (N:ℝ) + 1)]
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2) p, Real.rpow_neg (by positivity : (0:ℝ) ≤ (N:ℝ) + 1) p]
    rw [← mul_inv]
    exact mul_inv_cancel₀ (ne_of_gt (mul_pos h2 hN))
  have key : ∀ n : ℕ, (2:ℝ) ^ (p:ℝ) * ((N:ℝ) + 1) ^ (p:ℝ) * term p (N + 1 + n)
      = (1 + (((n:ℝ) + 1) / ((N:ℝ) + 1))) ^ (-(p:ℝ)) := by
    intro n
    have hbase : (0:ℝ) < (N:ℝ) + 2 + (n:ℝ) := by positivity
    have hNp : (0:ℝ) < (N:ℝ) + 1 := by positivity
    unfold term
    push_cast
    rw [show (2 * ((N:ℝ) + 1 + (n:ℝ) + 1)) = (2:ℝ) * ((N:ℝ) + 2 + (n:ℝ)) by ring]
    rw [Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) hbase.le,
        Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2) p]
    have hB : (1 + (((n:ℝ) + 1) / ((N:ℝ) + 1))) = ((N:ℝ) + 2 + (n:ℝ)) / ((N:ℝ) + 1) := by
      field_simp
      ring
    rw [hB, Real.div_rpow hbase.le hNp.le,
        Real.rpow_neg hbase.le p, Real.rpow_neg hNp.le p]
    rw [← mul_inv]
    field_simp
  have hscaled : (2:ℝ) ^ (p:ℝ) * ((N:ℝ) + 1) ^ (p:ℝ) * (∑' n : ℕ, term p (N + 1 + n))
      = ∑' n : ℕ, (1 + (((n:ℝ) + 1) / ((N:ℝ) + 1))) ^ (-(p:ℝ)) := by
    rw [← tsum_mul_left]
    exact tsum_congr (fun n => key n)
  rw [IsComplete, tailSum, Phi]
  rw [← mul_le_mul_iff_of_pos_left hc, key0, hscaled]
  constructor
  · intro h; simpa only [Nat.cast_add, Nat.cast_one] using h
  · intro h; simpa only [Nat.cast_add, Nat.cast_one] using h

lemma Phi_mono_n (p : ℝ) (hp : 1 < p) (n m : ℕ) (hn : 1 ≤ n) (hnm : n ≤ m) :
    Phi p n ≤ Phi p m := by
  have hm : 1 ≤ m := le_trans hn hnm
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hf : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p)) :=
    summable_phi_gt_one p n hn hp
  have hg : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (m : ℝ))) ^ (-p)) :=
    summable_phi_gt_one p m hm hp
  rw [Phi, Phi]
  refine Summable.tsum_le_tsum (fun j => ?_) hf hg
  have hle : 1 + (((j : ℝ) + 1) / (m : ℝ)) ≤ 1 + (((j : ℝ) + 1) / (n : ℝ)) := by
    have h : (((j : ℝ) + 1) / (m : ℝ)) ≤ (((j : ℝ) + 1) / (n : ℝ)) :=
      div_le_div_of_nonneg_left (by positivity) hnR (by exact_mod_cast hnm)
    linarith
  exact Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((j:ℝ) + 1) / (m : ℝ)))
    hle (by linarith [hp.le] : (-p) ≤ 0)

lemma Phi_two_ge_one {n : ℕ} (hn : 4 ≤ n) : 1 ≤ Phi 2 n := by
  have hn1 : 1 ≤ n := by omega
  have hf : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ))) :=
    summable_phi_gt_one 2 n hn1 (by norm_num)
  have hsum := hf.sum_le_tsum (Finset.range n) (fun i _ => Real.rpow_nonneg (by positivity) _)
  have hterm : ∀ j ∈ Finset.range n,
      (1/4:ℝ) ≤ (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) := by
    intro j hj
    have hjn : j < n := Finset.mem_range.mp hj
    have hle : 1 + (((j : ℝ) + 1) / (n : ℝ)) ≤ 2 := by
      have h1 : ((j:ℝ) + 1) / (n:ℝ) ≤ 1 := by
        rw [div_le_one (by positivity : (0:ℝ) < (n:ℝ))]
        exact_mod_cast (by omega : j + 1 ≤ n)
      linarith
    have h := Real.rpow_le_rpow_of_nonpos (by positivity : (0:ℝ) < 1 + (((j:ℝ) + 1) / (n:ℝ))) hle (by norm_num : (-(2:ℝ)) ≤ 0)
    have h2 : (2:ℝ)^(-(2:ℝ)) = 1/4 := by
      rw [show (-(2:ℝ)) = ((-2:ℤ):ℝ) by norm_num, Real.rpow_intCast]
      norm_num
    linarith [h, h2]
  have h1 : ∑ j ∈ Finset.range n, (1/4:ℝ)
      ≤ ∑ j ∈ Finset.range n, (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ)) :=
    Finset.sum_le_sum hterm
  have h2 : ∑ j ∈ Finset.range n, (1/4:ℝ) = (n:ℝ)/4 := by
    rw [Finset.sum_const, Finset.card_range]
    push_cast
    ring
  have h3 : (1:ℝ) ≤ (n:ℝ)/4 := by
    have h4 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    linarith
  have h4 : (∑' j : ℕ, (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2:ℝ))) = Phi 2 n := rfl
  linarith [h1, h2, h3, hsum]

lemma log_one_add_ge_half_mul {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    x/2 ≤ Real.log (1 + x) := by
  have hpos : (0:ℝ) < 1 + x := by linarith
  have h1 : Real.log (1/(1+x)) ≤ 1/(1+x) - 1 := Real.log_le_sub_one_of_pos (by positivity)
  rw [Real.log_div (by norm_num : (1:ℝ) ≠ 0) (ne_of_gt hpos), Real.log_one] at h1
  have h2 : x/(1+x) ≤ Real.log (1+x) := by
    have h4 : x/(1+x) = 1 - 1/(1+x) := by field_simp; ring
    linarith
  have h3 : x/2 ≤ x/(1+x) := by
    rw [div_le_div_iff₀ (by norm_num : (0:ℝ) < 2) hpos]
    nlinarith
  linarith

/-! ### The linearization of `(e^u−1)^{-1}` at `log 2` -/

lemma exp_half_ge_eleven_twentieths : (11/20:ℝ) ≤ Real.exp (-(1/2)) := by
  have hlog : (1/2:ℝ) ≤ Real.log (20/11) := by
    have h := log_one_add_ge_quartic (9/11) (by norm_num)
    nlinarith [h]
  have h1 : Real.exp (1/2) ≤ 20/11 := by
    have h2 := Real.exp_le_exp.mpr hlog
    rwa [Real.exp_log (by norm_num : (0:ℝ) < 20/11)] at h2
  have hpos : (0:ℝ) < Real.exp (1/2) := Real.exp_pos _
  have h3 : (20/11:ℝ)⁻¹ ≤ (Real.exp (1/2))⁻¹ := inv_anti₀ hpos h1
  have h4 : (20/11:ℝ)⁻¹ = 11/20 := by norm_num
  rw [Real.exp_neg, ← h4]
  exact h3

lemma exp_threshold_linear (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |(Real.exp u - 1)⁻¹ - 1 + 2*(u - Real.log 2)| ≤ 500 * (u - Real.log 2)^2 := by
  set w := u - Real.log 2 with hw
  have hw12 : |w| ≤ 1/2 := by
    rw [hw]
    rw [abs_le]
    constructor <;> linarith [hu1, hu2, log_two_le_one, log_two_ge_half]
  have heu : Real.exp u = 2 * Real.exp w := by
    have hu' : u = Real.log 2 + w := by rw [hw]; ring
    rw [hu', Real.exp_add, Real.exp_log (by norm_num : (0:ℝ) < 2)]
  have hexp1 : (11/20:ℝ) ≤ Real.exp w := by
    have h2 : Real.exp (-(1/2)) ≤ Real.exp w :=
      Real.exp_le_exp.mpr (by linarith [neg_le.mp (abs_le.mp hw12).1])
    linarith [exp_half_ge_eleven_twentieths, h2]
  have hdenpos : (0:ℝ) < 2 * Real.exp w - 1 := by linarith
  have hident : (Real.exp u - 1)⁻¹ - 1 = 2*(1 - Real.exp w)/(2*Real.exp w - 1) := by
    rw [heu]
    field_simp
    ring
  rw [hident]
  have hE := exp_sub_one_sub_id_bound w
  have hexpabs : Real.exp |w| ≤ 2 := by
    have h2 : Real.exp |w| ≤ Real.exp (1/2) := Real.exp_le_exp.mpr hw12
    have h3 : Real.exp (1/2) ≤ 2 := by
      have h4 : Real.exp (1/2) ≤ Real.exp (Real.log 2) := Real.exp_le_exp.mpr log_two_ge_half
      rwa [Real.exp_log (by norm_num : (0:ℝ) < 2)] at h4
    linarith [h2, h3]
  have hbnd : |Real.exp w - 1 - w| ≤ 6 * w^2 := by
    have h5 : 3 * w^2 * Real.exp |w| ≤ 6 * w^2 := by nlinarith [hE, hexpabs, sq_nonneg w]
    linarith [hE, h5]
  have hnum : |1 - Real.exp w + 2*w*Real.exp w - w| ≤ 20 * w^2 := by
    have hR : |Real.exp w - 1 - w| ≤ 6 * w^2 := hbnd
    have hw' : |w| ≤ 1/2 := hw12
    have h1 : |w^2 + w*(Real.exp w - 1 - w)| ≤ 4 * w^2 := by
      have h2a := abs_add_le (w^2) (w*(Real.exp w - 1 - w))
      have h3 : |w*(Real.exp w - 1 - w)| = |w| * |Real.exp w - 1 - w| := abs_mul w _
      rw [h3] at h2a
      have h4 : |w| * |Real.exp w - 1 - w| ≤ (1/2) * (6 * w^2) :=
        mul_le_mul hw' hR (abs_nonneg _) (by norm_num)
      have h5 : |w^2| = w^2 := abs_of_nonneg (sq_nonneg w)
      rw [h5] at h2a
      nlinarith [h2a, h4, sq_nonneg w]
    have h2 : |w^2 + w*(Real.exp w - 1 - w) - (Real.exp w - 1 - w)| ≤ 10 * w^2 := by
      have h2a := abs_add_le (w^2 + w*(Real.exp w - 1 - w)) (-(Real.exp w - 1 - w))
      have h6 : |-(Real.exp w - 1 - w)| = |Real.exp w - 1 - w| := abs_neg _
      rw [h6] at h2a
      have hC2 : w^2 + w*(Real.exp w - 1 - w) - (Real.exp w - 1 - w)
          = (w^2 + w*(Real.exp w - 1 - w)) + (-(Real.exp w - 1 - w)) := by ring
      rw [hC2]
      nlinarith [h2a, h1, hR, sq_nonneg w]
    have hC : 1 - Real.exp w + 2*w*Real.exp w - w
        = (w^2 + w*(Real.exp w - 1 - w) - (Real.exp w - 1 - w))
          + (w^2 + w*(Real.exp w - 1 - w)) := by ring
    rw [hC]
    have hsum := abs_add_le (w^2 + w*(Real.exp w - 1 - w) - (Real.exp w - 1 - w))
      (w^2 + w*(Real.exp w - 1 - w))
    nlinarith [hsum, h1, h2, sq_nonneg w]
  have hkey : 2*(1 - Real.exp w)/(2*Real.exp w - 1) + 2*w
      = 2 * ((1 - Real.exp w + 2*w*Real.exp w - w)/(2*Real.exp w - 1)) := by
    field_simp [ne_of_gt hdenpos]
    ring
  rw [hkey, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]
  have hq : |(1 - Real.exp w + 2*w*Real.exp w - w)/(2*Real.exp w - 1)| ≤ 200 * w^2 := by
    rw [abs_div, abs_of_pos hdenpos]
    rw [div_le_iff₀ hdenpos]
    nlinarith [hnum, hdenpos, sq_nonneg w]
  nlinarith [hq, sq_nonneg w]

/-! ### The window bounds: where `Φ(u·n)` crosses 1 (used for `nmin`) -/

private lemma window_arith (n : ℕ) (hn : 2000000000 ≤ n)
    (A B C : ℝ)
    (hA : -(8000/((n:ℝ)^2)) ≤ A)
    (hB : -3*Real.log 2/(n:ℝ) + 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2)) ≤ B)
    (hC : -(4*10^10/((n:ℝ)^2)) ≤ C) :
    (0:ℝ) < A + B + C - 10^12/((n:ℝ)^2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn2 : (0:ℝ) < ((n:ℝ)^2) := by positivity
  have hval : A + B + C - 10^12/((n:ℝ)^2) ≥
      (-(8000/((n:ℝ)^2))) + (-3*Real.log 2/(n:ℝ) + 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2)))
      + (-(4*10^10/((n:ℝ)^2))) - 10^12/((n:ℝ)^2) := by
    linarith only [hA, hB, hC]
  have hnum : (0:ℝ) < (2*10^19 - 8000 - 40 - 4*10^10 - 2*10^17 - 10^12)/((n:ℝ)^2) := by
    apply div_pos _ hn2
    norm_num
  have heq : (-(8000/((n:ℝ)^2))) + (-3*Real.log 2/(n:ℝ) + 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2)))
      + (-(4*10^10/((n:ℝ)^2))) - 10^12/((n:ℝ)^2)
      = (2*10^19 - 8000 - 40 - 4*10^10 - 2*10^17 - 10^12)/((n:ℝ)^2) := by
    field_simp
    ring
  linarith only [hval, hnum, heq]

lemma Phi_window_low (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hwabs : |u - Real.log 2| ≤ 4/(n:ℝ))
    (hw : u ≤ Real.log 2 + 3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2)) :
    1 < Phi (u*(n:ℝ)) n := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hn2e9 : (2000000000:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hlog1 : Real.log 2 ≤ 1 := log_two_le_one
  have hlog15 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have sb := split_bounds' (by omega : 100000000 ≤ n)
  have hPhi := Phi_third_order hu1 hu2 hn sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hlin := exp_threshold_linear u hu1 hu2
  have hPS := PhiS_second_order_at_log2 u hu1 hu2
  have hD := SThird_D_abs_le u hu1 hu2
  set w := u - Real.log 2 with hwset
  have hwle : w ≤ 3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2) := by
    have h' : u - Real.log 2 ≤ 3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2) := by linarith only [hw]
    simpa only [hwset] using h'
  have hw4 : |w| ≤ 4/(n:ℝ) := by simpa only [hwset] using hwabs
  have hw12 : |w| ≤ 1/2 := by
    have hn8 : (8:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 8 ≤ n)
    have h : 4/(n:ℝ) ≤ 1/2 := by
      rw [div_le_iff₀ hnR]; linarith only [hn8]
    linarith only [hw4, h]
  have hw2 : w^2 ≤ 16/((n:ℝ)^2) := by
    have h1 : w^2 ≤ (4/(n:ℝ))^2 := sq_le_sq' (abs_le.mp hw4).1 (abs_le.mp hw4).2
    have h1b : (4/(n:ℝ))^2 = 16/((n:ℝ)^2) := by field_simp; ring
    linarith only [h1, h1b]
  -- (A)
  have hA : -(8000/((n:ℝ)^2)) ≤ (Real.exp u - 1)⁻¹ - 1 + 2*w := by
    have h18 := abs_le.mp hlin
    have h19 : (Real.exp u - 1)⁻¹ - 1 + 2*(u - Real.log 2)
        = (Real.exp u - 1)⁻¹ - 1 + 2*w := by rw [hwset]
    rw [h19] at h18
    have hq : 500 * w^2 ≤ 8000/((n:ℝ)^2) := by
      have h1b : 500 * (16/((n:ℝ)^2)) = 8000/((n:ℝ)^2) := by ring
      have h1c : 500 * w^2 ≤ 500 * (16/((n:ℝ)^2)) :=
        mul_le_mul_of_nonneg_left hw2 (by norm_num)
      linarith only [h1b, h1c]
    linarith only [h18.1, hq]
  -- (B)
  have hB : -3*Real.log 2/(n:ℝ) + 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2))
      ≤ -2*w + u*PhiS u/(2*(n:ℝ)) := by
    have h1 : -3*Real.log 2/(n:ℝ) + 2*10^19/((n:ℝ)^2) ≤ -2*w := by
      have h2w : -2*w ≥ -2*(3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2)) := by linarith only [hwle]
      have hexp : -2*(3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2))
          = -3*Real.log 2/(n:ℝ) + 2*10^19/((n:ℝ)^2) := by
        field_simp [ne_of_gt hnR]; ring
      linarith only [h2w, hexp]
    have hPSb : PhiS u ≥ 6 - 26*w - 10^16 * w^2 := by
      have h := (abs_le.mp hPS).1
      rw [hwset]
      linarith only [h]
    have hlog_abs : |6 - 26*Real.log 2| ≤ 20 := by
      rw [abs_le]
      constructor <;> linarith only [hlog1, hlog15]
    have huPhiS : u*PhiS u ≥ 6*Real.log 2 + (6 - 26*Real.log 2)*w
        - (26 + 2*10^16)*w^2 := by
      have h1' : Real.log 2 + w ≤ u := by
        have h : Real.log 2 + (u - Real.log 2) = u := by ring
        rw [hwset]; linarith only [h]
      have h4 : (0:ℝ) ≤ 6 - 26*w - 10^16*w^2 := by
        have h5 : 26*w ≤ 26*(4/(n:ℝ)) := by linarith only [le_of_abs_le hw4]
        have h5b : 26*(4/(n:ℝ)) ≤ 2 := by
          rw [show 26*(4/(n:ℝ)) = 104/(n:ℝ) by ring, div_le_iff₀ hnR]
          linarith only [hn2e9]
        have h6 : 10^16*w^2 ≤ 10^16*(16/((n:ℝ)^2)) :=
          mul_le_mul_of_nonneg_left hw2 (by norm_num)
        have h6b : 10^16*(16/((n:ℝ)^2)) ≤ 1 := by
          rw [show 10^16*(16/((n:ℝ)^2)) = (16*10^16)/((n:ℝ)^2) by ring,
            div_le_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^2))]
          nlinarith only [hn2e9, hnR]
        linarith only [h5, h5b, h6, h6b]
      have h4b : (0:ℝ) ≤ u := by linarith only [hu1]
      have h3 : (Real.log 2 + w) * (6 - 26*w - 10^16*w^2) ≤ u * PhiS u :=
        mul_le_mul h1' hPSb h4 h4b
      have hw12b : w ≤ 1/2 := le_of_abs_le hw12
      have h8 : 6*Real.log 2 + (6 - 26*Real.log 2)*w - (26 + 2*10^16)*w^2
          ≤ (Real.log 2 + w) * (6 - 26*w - 10^16*w^2) := by
        have h9 : w^2 ≥ 0 := sq_nonneg w
        nlinarith only [h9, hlog1, hw12b]
      linarith only [h3, h8]
    have h2 : u*PhiS u/(2*(n:ℝ)) ≥ 3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2) := by
      have h3 : (0:ℝ) < 2*(n:ℝ) := by positivity
      have hsplit : (6*Real.log 2 + (6 - 26*Real.log 2)*w - (26 + 2*10^16)*w^2)/(2*(n:ℝ))
          = (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
            - (26 + 2*10^16)*w^2/(2*(n:ℝ)) := by ring
      have hdiv : u*PhiS u/(2*(n:ℝ)) ≥
          (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
            - (26 + 2*10^16)*w^2/(2*(n:ℝ)) := by
        rw [← hsplit]
        exact div_le_div_of_nonneg_right huPhiS (by positivity)
      have e1 : (6*Real.log 2)/(2*(n:ℝ)) = 3*Real.log 2/(n:ℝ) := by
        field_simp [ne_of_gt hnR]
        ring
      have e2 : (6 - 26*Real.log 2)*w/(2*(n:ℝ)) ≥ -40/((n:ℝ)^2) := by
        have h5 := abs_le.mp hlog_abs
        have h6 : w ≥ -(4/(n:ℝ)) := (abs_le.mp hw4).1
        have h7 : w ≤ 4/(n:ℝ) := le_of_abs_le hw4
        have h8a : (6 - 26*Real.log 2)*w ≥ -80/(n:ℝ) := by
          have h8a' : (6 - 26*Real.log 2)*w ≥ -20*(4/(n:ℝ)) := by nlinarith only [h5.1, h5.2, h6, h7]
          have h8b : -20*(4/(n:ℝ)) = -80/(n:ℝ) := by ring
          linarith only [h8a', h8b]
        rw [ge_iff_le, le_div_iff₀ h3]
        have h8c : (-40/((n:ℝ)^2))*(2*(n:ℝ)) = -80/(n:ℝ) := by field_simp; ring
        nlinarith only [h8a, h8c]
      have e3 : (26 + 2*10^16)*w^2/(2*(n:ℝ)) ≤ 2*10^17/((n:ℝ)^2) := by
        have h8 : (26 + 2*10^16)*w^2 ≤ (26 + 2*10^16)*(16/((n:ℝ)^2)) :=
          mul_le_mul_of_nonneg_left hw2 (by norm_num)
        have h9 : (26 + 2*10^16)*w^2/(2*(n:ℝ)) ≤ (26 + 2*10^16)*(16/((n:ℝ)^2))/(2*(n:ℝ)) :=
          div_le_div_of_nonneg_right h8 (by positivity)
        have h10 : (26 + 2*10^16)*(16/((n:ℝ)^2))/(2*(n:ℝ)) = (16*(26 + 2*10^16))/(2*(n:ℝ)^3) := by
          field_simp [ne_of_gt hnR]
        rw [h10] at h9
        have h11 : (16*(26 + 2*10^16))/(2*(n:ℝ)^3) ≤ 2*10^17/((n:ℝ)^2) := by
          rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)^3) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
          nlinarith only [hn2e9, hnR]
        exact le_trans h9 h11
      have hY : -(40/((n:ℝ)^2)) ≤ (6 - 26*Real.log 2)*w/(2*(n:ℝ)) := by
        rw [← neg_div]
        exact e2
      have hA : 3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2)
          = (6*Real.log 2)/(2*(n:ℝ)) + (-(40/((n:ℝ)^2))) + (-(2*10^17/((n:ℝ)^2))) := by
        rw [e1]; ring
      have hcombine : 3*Real.log 2/(n:ℝ) - 40/((n:ℝ)^2) - 2*10^17/((n:ℝ)^2)
          ≤ (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
            - (26 + 2*10^16)*w^2/(2*(n:ℝ)) := by
        rw [hA]
        have h1'' : (6*Real.log 2)/(2*(n:ℝ)) + (-(40/((n:ℝ)^2)))
            ≤ (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ)) :=
          add_le_add le_rfl hY
        have h2'' : (-(2*10^17/((n:ℝ)^2)))
            ≤ -((26 + 2*10^16)*w^2/(2*(n:ℝ))) := neg_le_neg e3
        exact add_le_add h1'' h2''
      exact le_trans hcombine hdiv
    linarith only [h1, h2]
  -- (C)
  have hC : -(4*10^10/((n:ℝ)^2)) ≤ (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) := by
    have hD' : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)|/((n:ℝ)^2) ≤ 4*10^10/((n:ℝ)^2) :=
      div_le_div_of_nonneg_right hD (by positivity)
    have habs : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)|
        = |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)|/((n:ℝ)^2) := by
      rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^2))]
    have h20 : -(4*10^10/((n:ℝ)^2))
        ≤ -(|(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)|/((n:ℝ)^2)) := by linarith only [hD']
    have h21 : -(|(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)|/((n:ℝ)^2))
        ≤ (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) := by
      rw [← habs]
      exact neg_abs_le _
    linarith only [h20, h21]
  -- final
  have hE : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))|
      ≤ (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) := hPhi
  have hE' : (Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))) ≥ -(10^12/((n:ℝ)^2)) := by
    have h17 := abs_le.mp hE
    have h18 : (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) ≤ 10^12/((n:ℝ)^2) := by
      rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
      nlinarith only [hn1, hnR]
    linarith only [h17.1, h18]
  have hident : Phi (u*(n:ℝ)) n - 1
      = ((Real.exp u - 1)⁻¹ - 1 + 2*w) + (-2*w + u*PhiS u/(2*(n:ℝ)))
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)
        + (Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
            + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))) := by ring
  have hkey := window_arith n hn ((Real.exp u - 1)⁻¹ - 1 + 2*w)
    (-2*w + u*PhiS u/(2*(n:ℝ))) ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)) hA hB hC
  have hfin : (0:ℝ) < Phi (u*(n:ℝ)) n - 1 := by
    rw [hident]
    linarith only [hkey, hE']
  linarith only [hfin]

private lemma window_arith_high (n : ℕ) (hn : 2000000000 ≤ n) (A B C : ℝ)
    (hA : A ≤ 8000/((n:ℝ)^2))
    (hB : B ≤ -3*Real.log 2/(n:ℝ) - 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2)))
    (hC : C ≤ 4*10^10/((n:ℝ)^2)) :
    A + B + C + 10^12/((n:ℝ)^2) < 0 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn2 : (0:ℝ) < ((n:ℝ)^2) := by positivity
  have h1 : A + B + C + 10^12/((n:ℝ)^2) ≤
      8000/((n:ℝ)^2) + (-3*Real.log 2/(n:ℝ) - 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2)))
      + 4*10^10/((n:ℝ)^2) + 10^12/((n:ℝ)^2) :=
    add_le_add (add_le_add (add_le_add hA hB) hC) le_rfl
  have heq : 8000/((n:ℝ)^2) + (-3*Real.log 2/(n:ℝ) - 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2)))
      + 4*10^10/((n:ℝ)^2) + 10^12/((n:ℝ)^2)
      = (8000 + 50 + 3*10^17 + 4*10^10 + 10^12 - 2*10^19)/((n:ℝ)^2) := by
    field_simp
    ring
  have hneg : (8000 + 50 + 3*10^17 + 4*10^10 + 10^12 - 2*10^19)/((n:ℝ)^2) < 0 := by
    apply div_neg_of_neg_of_pos _ hn2
    norm_num
  linarith only [h1, heq.le, heq.ge, hneg]

lemma Phi_window_high (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hwabs : |u - Real.log 2| ≤ 4/(n:ℝ))
    (hw : Real.log 2 + 3*Real.log 2/(2*(n:ℝ)) + 10^19/((n:ℝ)^2) ≤ u) :
    Phi (u*(n:ℝ)) n < 1 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hn2e9 : (2000000000:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hlog1 : Real.log 2 ≤ 1 := log_two_le_one
  have hlog15 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have sb := split_bounds' (by omega : 100000000 ≤ n)
  have hPhi := Phi_third_order hu1 hu2 hn sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hlin := exp_threshold_linear u hu1 hu2
  have hPS := PhiS_second_order_at_log2 u hu1 hu2
  have hD := SThird_D_abs_le u hu1 hu2
  set w := u - Real.log 2 with hwset
  have hwge : 3*Real.log 2/(2*(n:ℝ)) + 10^19/((n:ℝ)^2) ≤ w := by
    have h' : 3*Real.log 2/(2*(n:ℝ)) + 10^19/((n:ℝ)^2) ≤ u - Real.log 2 := by linarith only [hw]
    simpa only [hwset] using h'
  have hw4 : |w| ≤ 4/(n:ℝ) := by simpa only [hwset] using hwabs
  have hw2 : w^2 ≤ 16/((n:ℝ)^2) := by
    have h1 : w^2 ≤ (4/(n:ℝ))^2 := sq_le_sq' (abs_le.mp hw4).1 (abs_le.mp hw4).2
    have h1b : (4/(n:ℝ))^2 = 16/((n:ℝ)^2) := by field_simp; ring
    linarith only [h1, h1b]
  have hw12 : |w| ≤ 1/2 := by
    have hn8 : (8:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 8 ≤ n)
    have h : 4/(n:ℝ) ≤ 1/2 := by
      rw [div_le_iff₀ hnR]; linarith only [hn8]
    linarith only [hw4, h]
  have hwpos : (0:ℝ) ≤ Real.log 2 + w := by
    have hn8 : (8:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 8 ≤ n)
    have h4n : 4/(n:ℝ) ≤ 1/2 := by
      rw [div_le_iff₀ hnR]; linarith only [hn8]
    have h : -(4/(n:ℝ)) ≤ w := (abs_le.mp hw4).1
    linarith only [hlog15, h, h4n]
  -- (A) upper bound on the linearization term
  have hA : (Real.exp u - 1)⁻¹ - 1 + 2*w ≤ 8000/((n:ℝ)^2) := by
    have h18 := abs_le.mp hlin
    have h19 : (Real.exp u - 1)⁻¹ - 1 + 2*(u - Real.log 2)
        = (Real.exp u - 1)⁻¹ - 1 + 2*w := by rw [hwset]
    rw [h19] at h18
    have hq : 500 * w^2 ≤ 8000/((n:ℝ)^2) := by
      have h1b : 500 * (16/((n:ℝ)^2)) = 8000/((n:ℝ)^2) := by ring
      have h1c : 500 * w^2 ≤ 500 * (16/((n:ℝ)^2)) :=
        mul_le_mul_of_nonneg_left hw2 (by norm_num)
      linarith only [h1b, h1c]
    linarith only [h18.2, hq]
  -- (B) upper bound on the crossing term
  have hB : -2*w + u*PhiS u/(2*(n:ℝ))
      ≤ -3*Real.log 2/(n:ℝ) - 2*10^19/((n:ℝ)^2)
        + (3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2)) := by
    have h1 : -2*w ≤ -3*Real.log 2/(n:ℝ) - 2*10^19/((n:ℝ)^2) := by
      have h2w : -2*w ≤ -2*(3*Real.log 2/(2*(n:ℝ)) + 10^19/((n:ℝ)^2)) := by
        linarith only [hwge]
      have hexp : -2*(3*Real.log 2/(2*(n:ℝ)) + 10^19/((n:ℝ)^2))
          = -3*Real.log 2/(n:ℝ) - 2*10^19/((n:ℝ)^2) := by
        field_simp [ne_of_gt hnR]; ring
      linarith only [h2w, hexp]
    have hPSb : PhiS u ≤ 6 - 26*w + 10^16 * w^2 := by
      have h := (abs_le.mp hPS).2
      rw [hwset]
      linarith only [h]
    have huPhiS : u*PhiS u ≤ 6*Real.log 2 + (6 - 26*Real.log 2)*w
        + (16*10^16 + 26)*w^2 := by
      have h6 : (0:ℝ) ≤ 6 - 26*w + 10^16*w^2 := by
        have h5 : 26*w ≤ 26*(4/(n:ℝ)) := by linarith only [le_of_abs_le hw4]
        have h5b : 26*(4/(n:ℝ)) ≤ 6 := by
          rw [show 26*(4/(n:ℝ)) = 104/(n:ℝ) by ring, div_le_iff₀ hnR]
          linarith only [hn2e9]
        have h6a : 10^16*w^2 ≥ 0 := by positivity
        linarith only [h5, h5b, h6a]
      have h3 : u*PhiS u ≤ (Real.log 2 + w) * (6 - 26*w + 10^16*w^2) := by
        have h7 : Real.log 2 + w = u := by rw [hwset]; ring
        rw [h7]
        exact mul_le_mul_of_nonneg_left hPSb (by rw [← h7]; exact hwpos)
      have h8 : 6*Real.log 2 + (6 - 26*Real.log 2)*w + (16*10^16 + 26)*w^2
          ≥ (Real.log 2 + w) * (6 - 26*w + 10^16*w^2) := by
        have h9 : w^2 ≥ 0 := sq_nonneg w
        have hw12b : w ≥ -(1/2) := (abs_le.mp hw12).1
        have hw12c : w ≤ 1/2 := le_of_abs_le hw12
        nlinarith only [h9, hlog1, hlog15, hw12b, hw12c]
      linarith only [h3, h8]
    have h2 : u*PhiS u/(2*(n:ℝ)) ≤ 3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2) := by
      have h3 : (0:ℝ) < 2*(n:ℝ) := by positivity
      have hsplit : (6*Real.log 2 + (6 - 26*Real.log 2)*w + (16*10^16 + 26)*w^2)/(2*(n:ℝ))
          = (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
            + (16*10^16 + 26)*w^2/(2*(n:ℝ)) := by ring
      have hdiv : u*PhiS u/(2*(n:ℝ)) ≤ (6*Real.log 2)/(2*(n:ℝ))
          + (6 - 26*Real.log 2)*w/(2*(n:ℝ)) + (16*10^16 + 26)*w^2/(2*(n:ℝ)) := by
        have hd : u*PhiS u/(2*(n:ℝ)) ≤ (6*Real.log 2 + (6 - 26*Real.log 2)*w
            + (16*10^16 + 26)*w^2)/(2*(n:ℝ)) :=
          div_le_div_of_nonneg_right huPhiS (by positivity)
        rw [hsplit] at hd
        exact hd
      have e1 : (6*Real.log 2)/(2*(n:ℝ)) = 3*Real.log 2/(n:ℝ) := by
        field_simp [ne_of_gt hnR]; ring
      have hlog_abs : |6 - 26*Real.log 2| ≤ 20 := by
        rw [abs_le]
        constructor <;> linarith only [hlog1, hlog15]
      have e2 : (6 - 26*Real.log 2)*w/(2*(n:ℝ)) ≤ 20*(4/(n:ℝ))/(2*(n:ℝ)) := by
        have h5 := abs_le.mp hlog_abs
        have h6 : w ≥ -(4/(n:ℝ)) := (abs_le.mp hw4).1
        have h7 : w ≤ 4/(n:ℝ) := le_of_abs_le hw4
        have h8 : (6 - 26*Real.log 2)*w ≤ 20*(4/(n:ℝ)) := by nlinarith only [h5.1, h5.2, h6, h7]
        exact div_le_div_of_nonneg_right h8 (by positivity)
      have e2b : 20*(4/(n:ℝ))/(2*(n:ℝ)) ≤ 50/((n:ℝ)^2) := by
        have hA : (0:ℝ) < 1/((n:ℝ)^2) := by positivity
        have heq : 20*(4/(n:ℝ))/(2*(n:ℝ)) = 40 * (1/((n:ℝ)^2)) := by
          field_simp [ne_of_gt hnR]
          ring
        have heq2 : 50/((n:ℝ)^2) = 50 * (1/((n:ℝ)^2)) := by ring
        rw [heq, heq2]
        linarith only [hA]
      have e3 : (16*10^16 + 26)*w^2/(2*(n:ℝ)) ≤ 3*10^17/((n:ℝ)^2) := by
        have h8 : (16*10^16 + 26)*w^2 ≤ (16*10^16 + 26)*(16/((n:ℝ)^2)) :=
          mul_le_mul_of_nonneg_left hw2 (by norm_num)
        have h9 : (16*10^16 + 26)*(16/((n:ℝ)^2))/(2*(n:ℝ))
            ≤ 3*10^17/((n:ℝ)^2) := by
          rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
          rw [show (16*10^16 + 26)*(16/((n:ℝ)^2))*((n:ℝ)^2) = (16*10^16 + 26)*16 by
            field_simp]
          nlinarith only [hn2e9]
        have h10 : (16*10^16 + 26)*w^2/(2*(n:ℝ))
            ≤ (16*10^16 + 26)*(16/((n:ℝ)^2))/(2*(n:ℝ)) :=
          div_le_div_of_nonneg_right h8 (by positivity)
        linarith only [h10, h9]
      have hstep1 : (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
          ≤ 3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) := by
        have hA2 : (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
            ≤ 3*Real.log 2/(n:ℝ) + 20*(4/(n:ℝ))/(2*(n:ℝ)) := by
          rw [← e1]
          exact add_le_add le_rfl e2
        exact le_trans hA2 (add_le_add le_rfl e2b)
      have hA4 : 3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2)
          + (16*10^16 + 26)*w^2/(2*(n:ℝ))
          ≤ 3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2) :=
        add_le_add le_rfl e3
      have hfin : (6*Real.log 2)/(2*(n:ℝ)) + (6 - 26*Real.log 2)*w/(2*(n:ℝ))
          + (16*10^16 + 26)*w^2/(2*(n:ℝ))
          ≤ 3*Real.log 2/(n:ℝ) + 50/((n:ℝ)^2) + 3*10^17/((n:ℝ)^2) :=
        le_trans (add_le_add hstep1 le_rfl) hA4
      exact le_trans hdiv hfin
    linarith only [h1, h2]
  -- (C)
  have hC : (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) ≤ 4*10^10/((n:ℝ)^2) := by
    have hD' : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)|/((n:ℝ)^2) ≤ 4*10^10/((n:ℝ)^2) :=
      div_le_div_of_nonneg_right hD (by positivity)
    have habs : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)|
        = |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)|/((n:ℝ)^2) := by
      rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^2))]
    have h20 : |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/((n:ℝ)^2) := by
      rw [habs]; exact hD'
    exact le_trans (le_abs_self _) h20
  -- final
  have hE : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))|
      ≤ (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) := hPhi
  have hE' : (Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))) ≤ 10^12/((n:ℝ)^2) := by
    have h17 := abs_le.mp hE
    have h18 : (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3) ≤ 10^12/((n:ℝ)^2) := by
      rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) (by positivity : (0:ℝ) < ((n:ℝ)^2))]
      nlinarith only [hn1, hnR]
    linarith only [h17.2, h18]
  have hident : Phi (u*(n:ℝ)) n - 1
      = ((Real.exp u - 1)⁻¹ - 1 + 2*w) + (-2*w + u*PhiS u/(2*(n:ℝ)))
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)
        + (Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
            + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))) := by ring
  have hkey := window_arith_high n hn ((Real.exp u - 1)⁻¹ - 1 + 2*w)
    (-2*w + u*PhiS u/(2*(n:ℝ))) ((-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)) hA hB hC
  have hfin : Phi (u*(n:ℝ)) n - 1 < 0 := by
    rw [hident]
    linarith only [hkey, hE']
  linarith only [hfin]

lemma nmin_Phi_ge (p : ℕ) (hp : 2 ≤ p) : 1 ≤ Phi (p:ℝ) (nmin p + 1) := by
  have h := nmin_spec p hp
  rw [IsComplete_iff] at h
  exact h

lemma nmin_Phi_lt (p : ℕ) (hp : 2 ≤ p) (hpos : 1 ≤ nmin p) : Phi (p:ℝ) (nmin p) < 1 := by
  have hN : nmin p - 1 < nmin p := by omega
  have h := nmin_minimal p hp hN
  rw [IsComplete_iff] at h
  have hidx : nmin p - 1 + 1 = nmin p := by omega
  rw [hidx] at h
  exact not_le.mp h

/-! ### The exact ceiling law, reduced to two evaluations of `Φ`

The OP-5 exact ceiling law is the statement

    nmin p = ⌈p/log 2 − 5/2⌉          (`Op56.nmin`, `Op56.nminAsym`).

Since `nmin` is the *least* index with `IsComplete p N`, and `IsComplete p N ↔ 1 ≤ Φ_p(N+1)`
(`IsComplete_iff`), while `Φ_p` is increasing in its index argument (`Phi_mono_n`), the law is
*equivalent* to the pair of pointwise inequalities

    Φ_p(⌈p/log 2 − 5/2⌉) < 1    and    1 ≤ Φ_p(⌈p/log 2 − 5/2⌉ + 1).

The two lemmas below make this reduction explicit (`nmin_eq_of_Phi`, `nmin_eq_ceil_of_Phi_bounds`).

**Warning (measured, not proved here).**  The ceiling law is *false* as a universal
statement: there are (very sparse) values of `p` for which `nmin p = ⌈p/log 2 − 5/2⌉ + 1`.
The first such value found by continued-fraction search of `2/log 2` has 451 decimal digits
and is recorded in `research/twin-prime-parity/006/verify/op05_nmin_ceiling_false.py`, which
verifies at 1150 dps that `Φ_p(⌈y⌉) < 1 < Φ_p(⌈y⌉+1)` with `y = p/log 2 − 3/2`, forcing
`nmin p = ⌈y⌉ = ⌈p/log 2 − 5/2⌉ + 1`.  Consequently *no* sharpened form of the two-sided
windows `Phi_window_low`/`Phi_window_high` can prove the law universally: a window whose
slack in `w = p/n − log 2` is `K/n²` for a fixed constant `K` cannot decide the crossing when
`1 − {p/log 2 − 3/2} < K/(n log 2)`, which is exactly the bad case.  The strongest *true*
uniform statement still open is `nmin p ∈ {⌈p/log 2 − 5/2⌉, ⌈p/log 2 − 5/2⌉ + 1}`. -/

/-- `IsComplete` is monotone in the index (for `p` in the convergent range). -/
lemma IsComplete_mono (p : ℕ) (hp : 2 ≤ p) {a b : ℕ} (hab : a ≤ b) (h : IsComplete p a) :
    IsComplete p b := by
  rw [IsComplete_iff] at h ⊢
  have hp1 : (1:ℝ) < (p:ℝ) := by exact_mod_cast (by omega : 1 < p)
  have hmono := Phi_mono_n (p:ℝ) hp1 (a+1) (b+1) (by omega) (by omega)
  linarith

/-- `nmin p` is bounded by any index satisfying `IsComplete p`. -/
lemma nmin_le_of_IsComplete {p N : ℕ} (hp : 2 ≤ p) (h : IsComplete p N) : nmin p ≤ N := by
  classical
  have h' : nmin p = Nat.find (exists_isComplete p hp) := by simp only [nmin, dif_pos hp]
  rw [h']
  exact Nat.find_min' _ h

/-- **The exact ceiling law, reduced to two `Φ`-evaluations.**  If `Φ_p(N) < 1 ≤ Φ_p(N+1)`
then `N` is *the* crossing index, i.e. `nmin p = N`.  This is the precise "two halves" form of
the ceiling law: all of the difficulty is concentrated in the two hypotheses. -/
lemma nmin_eq_of_Phi {p N : ℕ} (hp : 2 ≤ p) (hN : Phi (p:ℝ) N < 1)
    (hN1 : 1 ≤ Phi (p:ℝ) (N + 1)) : nmin p = N := by
  classical
  have hI : IsComplete p N := (IsComplete_iff p N).mpr hN1
  have hle : nmin p ≤ N := nmin_le_of_IsComplete hp hI
  have hge : N ≤ nmin p := by
    by_contra hlt
    push_neg at hlt
    have hNm : ¬ IsComplete p (N - 1) := by
      rw [IsComplete_iff]
      have hsucc : (N - 1) + 1 = N := by omega
      rw [hsucc]
      exact not_le.mpr hN
    exact hNm (IsComplete_mono p hp (by omega : nmin p ≤ N - 1) (nmin_spec p hp))
  omega

/-- The ceiling law is *equivalent* to the pair of `Φ`-inequalities at the candidate index
(the forward direction is `nmin_Phi_lt`/`nmin_Phi_ge`). -/
lemma nmin_eq_iff_Phi_bounds {p N : ℕ} (hp : 2 ≤ p) (hN : 1 ≤ N) :
    nmin p = N ↔ Phi (p:ℝ) N < 1 ∧ 1 ≤ Phi (p:ℝ) (N + 1) := by
  constructor
  · intro h
    subst h
    exact ⟨nmin_Phi_lt p hp hN, nmin_Phi_ge p hp⟩
  · intro ⟨h1, h2⟩
    exact nmin_eq_of_Phi hp h1 h2

/-- **The exact OP-5 ceiling law in reduced form.**  If the two `Φ`-inequalities hold at
`N = ⌈p/log 2 − 5/2⌉`, then `nmin p = N`.  (This statement is true; the hypotheses are *not*
universally true — see the warning above and `nmin_eq_of_Phi`.) -/
theorem nmin_eq_ceil_of_Phi_bounds (p : ℕ) (hp : 2 ≤ p)
    (hlo : Phi (p:ℝ) (Nat.ceil ((p:ℝ) / Real.log 2 - 5 / 2)) < 1)
    (hhi : 1 ≤ Phi (p:ℝ) (Nat.ceil ((p:ℝ) / Real.log 2 - 5 / 2) + 1)) :
    nmin p = Nat.ceil ((p:ℝ) / Real.log 2 - 5 / 2) :=
  nmin_eq_of_Phi hp hlo hhi

/-! ### The explicit completeness witness `N = 4p`, and `nmin`'s upper bound -/

lemma IsComplete_four_mul (p : ℕ) (hp : 2 ≤ p) : IsComplete p (4 * p) := by
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
lemma nmin_le_four_p (p : ℕ) (hp : 2 ≤ p) : nmin p ≤ 4*p := by
  classical
  have h : nmin p = Nat.find (exists_isComplete p hp) := by simp only [nmin, dif_pos hp]
  rw [h]
  exact Nat.find_le (IsComplete_four_mul p hp)
/-! ### The p-series tail bound (integral comparison, upper direction) -/

lemma tsum_pow_tail_le (K p : ℕ) (hK : 1 ≤ K) (hp : 1 < p) :
    (∑' m : ℕ, ((K + m : ℕ) : ℝ) ^ (-(p:ℝ)))
      ≤ (K:ℝ) ^ (-(p:ℝ)) * (1 + (K:ℝ)/((p:ℝ) - 1)) := by
  have hKpos : (0:ℝ) < (K:ℝ) := by exact_mod_cast (by omega : 0 < K)
  have hpR : (1:ℝ) < (p:ℝ) := by exact_mod_cast hp
  have hp1 : (0:ℝ) < (p:ℝ) - 1 := by linarith
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-(p:ℝ))) (Set.Ici (K:ℝ)) := by
    intro x hx y hy hxy
    exact Real.rpow_le_rpow_of_nonpos (lt_of_lt_of_le hKpos hx) hxy (by linarith)
  have hbase : Summable (fun n : ℕ => ((n:ℝ)) ^ (-(p:ℝ))) := by
    have h := (Real.summable_nat_rpow_inv (p := (p:ℝ))).mpr hpR
    refine h.congr (fun n => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg n)]
  have hsum' : Summable (fun m : ℕ => ((K + m : ℕ) : ℝ) ^ (-(p:ℝ))) := by
    have h2 : Summable (fun m : ℕ => ((m + K : ℕ) : ℝ) ^ (-(p:ℝ))) :=
      (summable_nat_add_iff K).mpr hbase
    refine h2.congr (fun m => ?_)
    rw [show m + K = K + m by omega]
  have hint := AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ (-(p:ℝ))) K hanti
    (integrableOn_Ioi_rpow_of_lt (by linarith : -(p:ℝ) < -1) hKpos)
    (fun t ht => Real.rpow_nonneg (le_of_lt (lt_of_lt_of_le hKpos (le_of_lt ht))) _)
  have hval : (∫ x in Set.Ioi (K:ℝ), x ^ (-(p:ℝ))) = (K:ℝ) ^ (1 - (p:ℝ)) / ((p:ℝ) - 1) := by
    rw [integral_Ioi_rpow_of_lt (by linarith : -(p:ℝ) < -1) hKpos]
    rw [show (-(p:ℝ)) + 1 = 1 - (p:ℝ) by ring]
    field_simp [show (1:ℝ) - (p:ℝ) ≠ 0 by linarith]
    ring
  rw [hval] at hint
  have hsplit := Summable.sum_add_tsum_nat_add (f := fun m : ℕ => ((K + m : ℕ) : ℝ) ^ (-(p:ℝ))) 1 hsum'
  rw [Finset.sum_range_one] at hsplit
  have hshift : (∑' (i : ℕ), ((K + (i + 1) : ℕ) : ℝ) ^ (-(p:ℝ)))
      = (∑' (i : ℕ), ((K + i + 1 : ℕ) : ℝ) ^ (-(p:ℝ))) := by
    refine tsum_congr (fun i => ?_)
    rw [show K + (i + 1) = K + i + 1 by omega]
  rw [hshift] at hsplit
  have hint' : (∑' (i : ℕ), ((K + i + 1 : ℕ) : ℝ) ^ (-(p:ℝ)))
      ≤ (K:ℝ) ^ (1 - (p:ℝ)) / ((p:ℝ) - 1) := by
    refine le_trans (le_of_eq ?_) hint
    exact tsum_congr (fun i => by rw [show K + i + 1 = i + K + 1 by omega])
  have hsplit' : (∑' m : ℕ, ((K + m : ℕ) : ℝ) ^ (-(p:ℝ)))
      = (K:ℝ) ^ (-(p:ℝ)) + (∑' (i : ℕ), ((K + i + 1 : ℕ) : ℝ) ^ (-(p:ℝ))) := by
    have h1 : (((K + 0 : ℕ)) : ℝ) ^ (-(p:ℝ)) = (K:ℝ) ^ (-(p:ℝ)) := by
      rw [Nat.add_zero]
    have hsp : (∑' m : ℕ, ((K + m : ℕ) : ℝ) ^ (-(p:ℝ)))
        = (((K + 0 : ℕ)) : ℝ) ^ (-(p:ℝ))
          + (∑' (i : ℕ), (((K + (i + 1) : ℕ)) : ℝ) ^ (-(p:ℝ))) := hsplit.symm
    rw [hsp, h1]
    congr 1
  have hfin : (∑' m : ℕ, ((K + m : ℕ) : ℝ) ^ (-(p:ℝ)))
      ≤ (K:ℝ) ^ (-(p:ℝ)) + (K:ℝ) ^ (1 - (p:ℝ)) / ((p:ℝ) - 1) := by
    linarith [hsplit', hint']
  have heq : (K:ℝ) ^ (-(p:ℝ)) + (K:ℝ) ^ (1 - (p:ℝ)) / ((p:ℝ) - 1)
      = (K:ℝ) ^ (-(p:ℝ)) * (1 + (K:ℝ)/((p:ℝ) - 1)) := by
    rw [show (1:ℝ) - (p:ℝ) = (-(p:ℝ)) + 1 by ring, Real.rpow_add hKpos, Real.rpow_one]
    field_simp
  linarith [hfin, heq.le, heq.ge]

lemma binomial_margin (p : ℕ) (hp : 6 ≤ p) :
    1 + ((p:ℝ)+1)/((p:ℝ)-1) < (1 + 1/(p:ℝ))^p := by
  have hpR : (0:ℝ) < (p:ℝ) := by positivity
  have hp1 : (1:ℝ) < (p:ℝ) := by exact_mod_cast (by omega : 1 < p)
  have hp6 : (6:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hx : (0:ℝ) ≤ 1/(p:ℝ) := by positivity
  have hbase : (0:ℝ) < 1 + 1/(p:ℝ) := by positivity
  have h1 : 1 - 1/(2*(p:ℝ)) ≤ (p:ℝ) * Real.log (1 + 1/(p:ℝ)) := by
    have hlog := log_one_add_ge_quartic (1/(p:ℝ)) hx
    have h2 := mul_le_mul_of_nonneg_left hlog hpR.le
    have h3 : (p:ℝ) * (1/(p:ℝ) - (1/2)*(1/(p:ℝ))^2 + (1/3)*(1/(p:ℝ))^3 - (1/4)*(1/(p:ℝ))^4)
        = 1 - 1/(2*(p:ℝ)) + 1/(3*(p:ℝ)^2) - 1/(4*(p:ℝ)^3) := by
      field_simp
    have h4 : 1 - 1/(2*(p:ℝ)) ≤ 1 - 1/(2*(p:ℝ)) + 1/(3*(p:ℝ)^2) - 1/(4*(p:ℝ)^3) := by
      have h5 : 0 ≤ 1/(3*(p:ℝ)^2) - 1/(4*(p:ℝ)^3) := by
        rw [sub_nonneg, div_le_div_iff₀ (by positivity : (0:ℝ) < 4*(p:ℝ)^3)
          (by positivity : (0:ℝ) < 3*(p:ℝ)^2)]
        nlinarith [hpR]
      linarith
    linarith [h2, h3.le, h3.ge, h4]
  have hstep : (1 + 1/(p:ℝ))^p = Real.exp ((p:ℝ) * Real.log (1 + 1/(p:ℝ))) := by
    rw [← Real.rpow_natCast (1 + 1/(p:ℝ)) p, Real.rpow_def_of_pos hbase]
    ring_nf
  have h3 : Real.exp (1 - 1/(2*(p:ℝ))) ≤ (1 + 1/(p:ℝ))^p := by
    rw [hstep]
    exact Real.exp_le_exp.mpr h1
  have h4 : Real.exp (1 - 1/(2*(p:ℝ))) = Real.exp 1 * Real.exp (-(1/(2*(p:ℝ)))) := by
    have h := Real.exp_add 1 (-(1/(2*(p:ℝ))))
    rw [show (1:ℝ) + (-(1/(2*(p:ℝ)))) = 1 - 1/(2*(p:ℝ)) by ring] at h
    exact h
  have h5 : (1:ℝ) - 1/(2*(p:ℝ)) ≤ Real.exp (-(1/(2*(p:ℝ)))) := Real.one_sub_le_exp_neg _
  have h6 : Real.exp 1 * ((1:ℝ) - 1/(2*(p:ℝ))) ≤ Real.exp (1 - 1/(2*(p:ℝ))) := by
    rw [h4]
    exact mul_le_mul_of_nonneg_left h5 (Real.exp_pos 1).le
  have h7 : (2.7182818283:ℝ) * (1 - 1/(2*(p:ℝ))) ≤ (1 + 1/(p:ℝ))^p := by
    have he : (2.7182818283:ℝ) < Real.exp 1 := Real.exp_one_gt_d9
    have hpos : (0:ℝ) < 1 - 1/(2*(p:ℝ)) := by
      rw [sub_pos, div_lt_one (by positivity)]
      linarith [hp6]
    nlinarith [h6, h3, he, hpos]
  have hfin : 1 + ((p:ℝ)+1)/((p:ℝ)-1) < (2.7182818283:ℝ) * (1 - 1/(2*(p:ℝ))) := by
    have hp1' : (0:ℝ) < (p:ℝ) - 1 := by linarith
    have hmid : ((p:ℝ)+1)/((p:ℝ)-1) < (2.7182818283:ℝ) * (1 - 1/(2*(p:ℝ))) - 1 := by
      rw [div_lt_iff₀ hp1']
      field_simp
      nlinarith [hp6]
    linarith [hmid]
  linarith [h7, hfin]

lemma IsComplete_criterion (p N : ℕ) (h : IsComplete p N) :
    ((N:ℝ)+1) ^ (-(p:ℝ))
      ≤ ∑' k : ℕ, (((N + 2 + k : ℕ)) : ℝ) ^ (-(p:ℝ)) := by
  have h2p : (0:ℝ) < (2:ℝ) ^ (-(p:ℝ)) := Real.rpow_pos_of_pos (by norm_num) _
  have h1 : term p N = (2:ℝ)^(-(p:ℝ)) * ((N:ℝ)+1)^(-(p:ℝ)) := by
    unfold term
    rw [show (2 * ((N:ℝ)+1)) = (2:ℝ) * ((N:ℝ)+1) by ring,
        Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) (by positivity : (0:ℝ) ≤ (N:ℝ)+1)]
  have h2 : (∑' k : ℕ, term p (N+1+k))
      = (2:ℝ)^(-(p:ℝ)) * (∑' k : ℕ, (((N + 2 + k : ℕ)) : ℝ)^(-(p:ℝ))) := by
    rw [← tsum_mul_left]
    congr 1
    ext k
    unfold term
    have harg : (2 * ((((N + 1 + k : ℕ)):ℝ) + 1)) = (2:ℝ) * (((N + 2 + k : ℕ)):ℝ) := by
      push_cast
      ring
    rw [harg, Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2)
      (by positivity : (0:ℝ) ≤ (((N + 2 + k : ℕ)):ℝ))]
  have h3 : (2:ℝ)^(-(p:ℝ)) * ((N:ℝ)+1)^(-(p:ℝ))
      ≤ (2:ℝ)^(-(p:ℝ)) * (∑' k : ℕ, (((N + 2 + k : ℕ)) : ℝ)^(-(p:ℝ))) := by
    rw [← h1, ← h2]
    exact h
  exact le_of_mul_le_mul_left h3 h2p

/-! ### The coarse bound on `nmin`: `p ≤ nmin p` -/

lemma nmin_ge_p (p : ℕ) (hp : 6 ≤ p) : p ≤ nmin p := by
  have h2 : 2 ≤ p := by omega
  have hp1 : (1:ℝ) < (p:ℝ) := by exact_mod_cast (by omega : 1 < p)
  have hpR : (0:ℝ) < (p:ℝ) := by positivity
  have hp6 : (6:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hPhi_lt : Phi (p:ℝ) p < 1 := by
    by_contra hge
    push_neg at hge
    have hc : IsComplete p (p-1) := by
      rw [IsComplete_iff]
      have hidx : p - 1 + 1 = p := by omega
      rw [hidx]
      exact hge
    have hcrit := IsComplete_criterion p (p-1) hc
    have hidx2 : (((p-1 : ℕ)):ℝ) + 1 = (p:ℝ) := by
      have h1p : (1:ℕ) ≤ p := by omega
      push_cast [Nat.cast_sub h1p]
      ring
    rw [hidx2] at hcrit
    have hidx3 : (∑' k : ℕ, (((p - 1 + 2 + k : ℕ)) : ℝ) ^ (-(p:ℝ)))
        = (∑' m : ℕ, (((p + 1 + m : ℕ)) : ℝ) ^ (-(p:ℝ))) := by
      apply tsum_congr
      intro k
      rw [show p - 1 + 2 + k = p + 1 + k by omega]
    rw [hidx3] at hcrit
    have htail := tsum_pow_tail_le (p+1) p (by omega) (by omega)
    have hchain : (p:ℝ) ^ (-(p:ℝ))
        ≤ (p+1:ℝ) ^ (-(p:ℝ)) * (1 + (p+1:ℝ) / ((p:ℝ) - 1)) := by
      simp only [Nat.cast_add, Nat.cast_one] at hcrit htail
      exact le_trans hcrit htail
    have hp1p : (0:ℝ) < (p+1:ℝ) ^ (-(p:ℝ)) := Real.rpow_pos_of_pos (by positivity) _
    have hp1pos : (0:ℝ) < (p+1:ℝ) := by positivity
    have hdiv : ((p+1:ℝ)/p) ^ (p:ℕ) ≤ 1 + (p+1:ℝ) / ((p:ℝ) - 1) := by
      have hp1p' : (0:ℝ) < ((p:ℝ) ^ (p:ℕ)) := by positivity
      have h1 : ((p:ℝ) ^ (-(p:ℝ))) / ((p+1:ℝ) ^ (-(p:ℝ)))
          = ((p+1:ℝ) ^ (p:ℕ)) / ((p:ℝ) ^ (p:ℕ)) := by
        rw [Real.rpow_neg hpR.le, Real.rpow_neg hp1pos.le]
        rw [div_inv_eq_mul, inv_mul_eq_div]
        rw [Real.rpow_natCast, Real.rpow_natCast]
      have hkey : ((p:ℝ) ^ (-(p:ℝ))) / ((p+1:ℝ) ^ (-(p:ℝ)))
          ≤ 1 + (p+1:ℝ) / ((p:ℝ) - 1) := by
        rw [div_le_iff₀ hp1p]
        linarith only [hchain, mul_comm ((p+1:ℝ) ^ (-(p:ℝ)))
          (1 + (p+1:ℝ) / ((p:ℝ) - 1))]
      have h2 : ((p+1:ℝ) ^ (p:ℕ)) / ((p:ℝ) ^ (p:ℕ)) = ((p+1:ℝ)/p) ^ (p:ℕ) := by
        rw [show ((p+1:ℝ)/p) ^ (p:ℕ) = ((p+1:ℝ)/p) ^ ((p:ℕ):ℝ) by rw [Real.rpow_natCast],
            Real.div_rpow hp1pos.le hpR.le, Real.rpow_natCast, Real.rpow_natCast]
      linarith only [hkey, h1.le, h1.ge, h2.le, h2.ge]
    have hb := binomial_margin p hp
    have hcast : (1 + 1/(p:ℝ))^p = ((p+1:ℝ)/p)^(p:ℕ) := by
      rw [show (1:ℝ) + 1/(p:ℝ) = ((p:ℝ)+1)/p by field_simp]
    rw [← hcast] at hdiv
    linarith [hdiv, hb]
  by_contra hcon
  push_neg at hcon
  have hN : nmin p + 1 ≤ p := by omega
  have h1 := nmin_Phi_ge p h2
  have h2' := Phi_mono_n (p:ℝ) hp1 (nmin p + 1) p (by omega) hN
  linarith [h1, h2', hPhi_lt]

lemma nmin_lt_two_p (p : ℕ) (hp : 2 ≤ p) (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) :
    nmin p < 2*p := by
  have hc : IsComplete p (2*p - 1) := by
    rw [IsComplete_iff]
    have hidx : 2*p - 1 + 1 = 2*p := by omega
    rw [hidx]
    have h := Phi_asymptotic_explicit (2*p) (by omega) (1/2) (by norm_num) (by norm_num)
    have h2 := exp_half_inv_ge
    have hK : PhiC / (((2*p : ℕ)):ℝ) ≤ 1/3 := by
      rw [div_le_iff₀ (by positivity : (0:ℝ) < (((2*p : ℕ)):ℝ))]
      linarith [hlarge]
    have h3 := (abs_le.mp h).1
    have harg : ((1/2:ℝ) * (((2*p : ℕ)):ℝ)) = (p:ℝ) := by push_cast; ring
    rw [harg] at h3
    linarith
  have hle : nmin p ≤ 2*p - 1 := by
    classical
    have h : nmin p = Nat.find (exists_isComplete p hp) := by simp only [nmin, dif_pos hp]
    rw [h]
    exact Nat.find_le hc
  omega

/-! ### The crude bound `|p/nmin p - log 2| = O(1/nmin p)` -/

lemma nmin_w_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) :
    -(PhiC/(nmin p :ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2 := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p : ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hlt := nmin_Phi_lt p hp2 (by omega : 1 ≤ nmin p)
  have hthreshold : (1/2:ℝ) ≤ (p:ℝ)/(nmin p : ℝ) ∧ (p:ℝ)/(nmin p : ℝ) ≤ 1 := by
    constructor
    · rw [le_div_iff₀ hnR]
      have h2 := nmin_lt_two_p p hp2 hlarge
      have : (nmin p :ℝ) ≤ 2*(p:ℝ) := by exact_mod_cast (le_of_lt h2)
      linarith
    · rw [div_le_one hnR]
      have := nmin_ge_p p hp
      exact_mod_cast this
  have h := Phi_asymptotic_explicit (nmin p) (by omega) ((p:ℝ)/(nmin p : ℝ)) hthreshold.1 hthreshold.2
  have harg : ((p:ℝ)/(nmin p : ℝ)) * (nmin p : ℝ) = (p:ℝ) := by field_simp
  rw [harg] at h
  have h3 := (abs_le.mp h).1
  have hkey : (Real.exp ((p:ℝ)/(nmin p : ℝ)) - 1)⁻¹ < 1 + PhiC/(nmin p :ℝ) := by
    linarith [h3, hlt]
  have hpos : (0:ℝ) < Real.exp ((p:ℝ)/(nmin p : ℝ)) - 1 := by
    have h0 : (0:ℝ) < (p:ℝ)/(nmin p : ℝ) := by positivity
    have := Real.one_lt_exp_iff.mpr h0
    linarith
  have hC : (0:ℝ) < 1 + PhiC/(nmin p :ℝ) := by positivity
  have hkey2 : (1 + PhiC/(nmin p :ℝ))⁻¹ < Real.exp ((p:ℝ)/(nmin p : ℝ)) - 1 :=
    (inv_lt_comm₀ hpos hC).mp hkey
  have hmid : 1 + (1 + PhiC/(nmin p :ℝ))⁻¹ < Real.exp ((p:ℝ)/(nmin p : ℝ)) := by
    have hh := add_lt_add_right hkey2 1
    rw [show 1 + (Real.exp ((p:ℝ)/(nmin p : ℝ)) - 1) = Real.exp ((p:ℝ)/(nmin p : ℝ)) by ring] at hh
    exact hh
  have hlog : Real.log (1 + (1 + PhiC/(nmin p :ℝ))⁻¹) ≤ (p:ℝ)/(nmin p : ℝ) := by
    refine (Real.log_le_iff_le_exp (by positivity : (0:ℝ) < 1 + (1 + PhiC/(nmin p :ℝ))⁻¹)).mpr ?_
    exact hmid.le
  have hmain : Real.log (1 + (1 + PhiC/(nmin p :ℝ))⁻¹) ≥ Real.log 2 - PhiC/(nmin p :ℝ) := by
    have h1 : 1 + (1 + PhiC/(nmin p :ℝ))⁻¹ = (2 + PhiC/(nmin p :ℝ)) * (1 + PhiC/(nmin p :ℝ))⁻¹ := by
      field_simp
      ring
    rw [h1, Real.log_mul (by positivity) (by positivity), Real.log_inv]
    have h2 : Real.log (2 + PhiC/(nmin p :ℝ)) = Real.log 2 + Real.log (1 + (PhiC/(nmin p :ℝ))/2) := by
      rw [show (2:ℝ) + PhiC/(nmin p :ℝ) = 2*(1 + (PhiC/(nmin p :ℝ))/2) by ring,
          Real.log_mul (by norm_num) (by positivity)]
    rw [h2]
    have h3 : 0 ≤ Real.log (1 + (PhiC/(nmin p :ℝ))/2) := by
      apply Real.log_nonneg
      have hCpos := PhiC_pos
      have h1 : (0:ℝ) ≤ PhiC/(nmin p :ℝ) := by positivity
      linarith
    have h4 : Real.log (1 + PhiC/(nmin p :ℝ)) ≤ PhiC/(nmin p :ℝ) := by
      have := Real.log_le_sub_one_of_pos (by linarith : (0:ℝ) < 1 + PhiC/(nmin p :ℝ))
      linarith
    linarith
  linarith [hlog, hmain]

lemma log_one_add_inv_le (x : ℝ) (hx0 : 0 ≤ x) (hx : x ≤ 1/2) :
    Real.log (1 + (1 - x)⁻¹) ≤ Real.log 2 + 2*x := by
  have hx1 : (0:ℝ) < 1 - x := by linarith
  have h1 : 1 + (1 - x)⁻¹ = (2 - x) * (1 - x)⁻¹ := by field_simp; ring
  have h2 : Real.log (2 - x) ≤ Real.log 2 := Real.log_le_log (by linarith) (by linarith)
  have h3 : -Real.log (1 - x) ≤ 2*x := by
    have h4 := Real.log_le_sub_one_of_pos (by positivity : (0:ℝ) < 1/(1-x))
    have h5 : Real.log (1/(1-x)) = -Real.log (1-x) := by rw [one_div, Real.log_inv]
    rw [h5] at h4
    have h6 : 1/(1-x) - 1 = x/(1-x) := by field_simp; ring
    rw [h6] at h4
    have h7 : x/(1-x) ≤ 2*x := by
      rw [div_le_iff₀ hx1]
      nlinarith
    linarith
  rw [h1, Real.log_mul (by linarith) (by positivity), Real.log_inv]
  linarith

lemma nmin_w_upper (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) (hC : 2*PhiC ≤ (((nmin p + 1 : ℕ)):ℝ)) :
    (p:ℝ)/(nmin p :ℝ) - Real.log 2
      ≤ 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + 1/(nmin p :ℝ) := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p : ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hge := nmin_Phi_ge p hp2
  have hnn : nmin p < 2*p := nmin_lt_two_p p hp2 hlarge
  have hle : p ≤ nmin p := nmin_ge_p p hp
  have hthreshold : (1/2:ℝ) ≤ (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ∧ (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ 1 := by
    have h1 : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by positivity
    constructor
    · rw [le_div_iff₀ h1]
      have : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(p:ℝ) := by
        have h2 : nmin p + 1 ≤ 2*p := by omega
        exact_mod_cast h2
      linarith
    · rw [div_le_one h1]
      have : (p:ℝ) ≤ ((nmin p :ℝ)) := by exact_mod_cast hle
      push_cast
      linarith
  have h := Phi_asymptotic_explicit (nmin p + 1) (by omega) ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ))
    hthreshold.1 hthreshold.2
  have harg : ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) * (((nmin p + 1 : ℕ)):ℝ) = (p:ℝ) := by field_simp
  rw [harg] at h
  have h3 := (abs_le.mp h).2
  -- (e^u' - 1)^{-1} ≥ 1 - PhiC/n'
  have hkey : (1:ℝ) - PhiC/(((nmin p + 1 : ℕ)):ℝ)
      ≤ (Real.exp ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 1)⁻¹ := by
    have h4 : (1:ℝ) - PhiC/(((nmin p + 1 : ℕ)):ℝ)
        ≤ Phi (p:ℝ) (nmin p + 1) - PhiC/(((nmin p + 1 : ℕ)):ℝ) :=
      sub_le_sub_right hge _
    have h5 : Phi (p:ℝ) (nmin p + 1) - PhiC/(((nmin p + 1 : ℕ)):ℝ)
        ≤ (Real.exp ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 1)⁻¹ := by
      rw [sub_le_iff_le_add]
      rw [sub_le_iff_le_add] at h3
      exact h3.trans (le_of_eq (add_comm _ _))
    exact le_trans h4 h5
  have hxc : PhiC/(((nmin p + 1 : ℕ)):ℝ) ≤ 1/2 := by
    rw [div_le_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ))]
    push_cast at hC ⊢
    linarith only [hC]
  have hpos1 : (0:ℝ) < 1 - PhiC/(((nmin p + 1 : ℕ)):ℝ) := by linarith
  have hpos : (0:ℝ) < Real.exp ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 1 := by
    have h0 : (0:ℝ) < (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) := by positivity
    have := Real.one_lt_exp_iff.mpr h0
    linarith
  -- 1 - x ≤ (e^{u'}-1)^{-1}  ⟹  e^{u'} - 1 ≤ (1-x)^{-1}
  have hkey2 : Real.exp ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 1
      ≤ (1 - PhiC/(((nmin p + 1 : ℕ)):ℝ))⁻¹ :=
    (le_inv_comm₀ hpos1 hpos).mp hkey
  -- u' ≤ log(1 + 1/(1-x))
  have hlog : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
      ≤ Real.log (1 + (1 - PhiC/(((nmin p + 1 : ℕ)):ℝ))⁻¹) := by
    have h3' : Real.exp ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ))
        ≤ 1 + (1 - PhiC/(((nmin p + 1 : ℕ)):ℝ))⁻¹ := by linarith [hkey2]
    exact (Real.le_log_iff_exp_le
      (by positivity : (0:ℝ) < 1 + (1 - PhiC/(((nmin p + 1 : ℕ)):ℝ))⁻¹)).mpr h3'
  -- log(1 + 1/(1-x)) ≤ log 2 + 2x
  have hmain : Real.log (1 + (1 - PhiC/(((nmin p + 1 : ℕ)):ℝ))⁻¹)
      ≤ Real.log 2 + 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) :=
    log_one_add_inv_le (PhiC/(((nmin p + 1 : ℕ)):ℝ)) (by positivity) hxc
  have hw' : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2
      ≤ 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) := by
    have hh : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + Real.log 2 :=
      (le_trans hlog hmain).trans (le_of_eq (by ring :
        Real.log 2 + 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ))
          = 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + Real.log 2))
    exact sub_le_iff_le_add.mpr hh
  -- u - u' ≤ 1/n
  have hudiff : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ 1/(nmin p :ℝ) := by
    have h1 : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by positivity
    have h2 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
        = (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
      push_cast
      field_simp
      ring
    rw [h2]
    rw [div_le_iff₀ (by positivity : (0:ℝ) < (nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))]
    have hp' : (p:ℝ) ≤ (nmin p :ℝ) := by exact_mod_cast hle
    have h3 : (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))
        = (((nmin p + 1 : ℕ)):ℝ) := by
      field_simp
    have hn1 : (nmin p :ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith [hnR]
    exact calc (p:ℝ) ≤ (nmin p :ℝ) := hp'
      _ ≤ (((nmin p + 1 : ℕ)):ℝ) := hn1
      _ = (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := h3.symm
  have hfin : (p:ℝ)/(nmin p :ℝ) - Real.log 2
      ≤ 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + 1/(nmin p :ℝ) := by
    have h1 : ((p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ))
        + ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2)
        ≤ 1/(nmin p :ℝ) + 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) := add_le_add hudiff hw'
    have h2 : (p:ℝ)/(nmin p :ℝ) - Real.log 2
        = ((p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ))
          + ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2) := by ring
    have h3 : (1:ℝ)/(nmin p :ℝ) + 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ))
        = 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + 1/(nmin p :ℝ) := by ring
    linarith only [h1, h2.le, h2.ge, h3.le, h3.ge]
  exact hfin

lemma stage2_lower_arith (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w : ℝ) (hw : w^2 ≤ (K/(n:ℝ))^2)
    (h : -2*w - 500*w^2 < -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2)) :
    -(4/(n:ℝ)) ≤ w := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : 500*w^2 ≤ 500*K^2/((n:ℝ)^2) := by
    have h1a := mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 500)
    have h1b : 500*(K/(n:ℝ))^2 = 500*K^2/((n:ℝ)^2) := by field_simp
    linarith only [h1a, h1b.le, h1b.ge]
  have h2 : (500*K^2 + 10^15 : ℝ) ≤ 11/10 * (n:ℝ) := by
    have h2b : (10^15:ℝ) ≤ (n:ℝ) := by nlinarith only [hnK, sq_nonneg K]
    nlinarith only [hnK, h2b, sq_nonneg K]
  have h3 : (500*K^2 + 10^15)/((n:ℝ)^2) ≤ 11/10/(n:ℝ) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ))^2) hnR]
    nlinarith only [h2, hnR]
  have h6 : -2*w < -(11/8)/(n:ℝ) + 11/10/(n:ℝ) := by
    have ha : -2*w < -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w^2 := by linarith only [h]
    have hb : -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w^2
        ≤ -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2) := by linarith only [h1]
    have hc : -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2)
        = -(11/8)/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) := by ring
    linarith only [ha, hb, hc.le, hc.ge, h3]
  have h6' : -11/40/(n:ℝ) < w := by
    have h9 : -(11/8)/(n:ℝ) + 11/10/(n:ℝ) = -11/40/(n:ℝ) := by ring
    rw [h9] at h6
    have hA : (-11/40:ℝ)/(n:ℝ) = -((11/40:ℝ)/(n:ℝ)) := by field_simp
    have h10 : (11/40:ℝ)/(n:ℝ) < 2*w := by linarith only [h6, hA]
    have h10' : (11/80:ℝ)/(n:ℝ) < w := by
      have h10b : (11/40:ℝ) < 2*w*(n:ℝ) := by
        rw [div_lt_iff₀ hnR] at h10
        exact h10
      rw [div_lt_iff₀ hnR]
      linarith only [h10b]
    have h11 : -11/40/(n:ℝ) ≤ (11/80:ℝ)/(n:ℝ) := by
      rw [show -11/40/(n:ℝ) = ((-11/40:ℝ))/(n:ℝ) by ring]
      exact div_le_div_of_nonneg_right (by norm_num) hnR.le
    exact lt_of_le_of_lt h11 h10'
  have h7 : -(4/(n:ℝ)) ≤ -11/40/(n:ℝ) := by
    rw [show -(4/(n:ℝ)) = (-4:ℝ)/(n:ℝ) by ring,
        show -11/40/(n:ℝ) = (-(11/40):ℝ)/(n:ℝ) by ring]
    exact div_le_div_of_nonneg_right (by norm_num : (-4:ℝ) ≤ -(11/40)) hnR.le
  exact le_trans h7 h6'.le

lemma stage2_upper_arith (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -(3/2*Real.log 2)/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : 500*w'^2 ≤ 500*K^2/((n:ℝ)^2) := by
    have h1a := mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 500)
    have h1b : 500*(K/(n:ℝ))^2 = 500*K^2/((n:ℝ)^2) := by field_simp
    linarith only [h1a, h1b.le, h1b.ge]
  have h2 : (500*K^2 + 10^15 : ℝ) ≤ 11/10 * (n:ℝ) := by
    have h2a : K^2 + 1 ≤ (n:ℝ)/10^15 := by
      rw [le_div_iff₀ (by norm_num : (0:ℝ) < 10^15)]
      nlinarith only [hnK]
    have h2b : (10^15:ℝ) ≤ (n:ℝ) := by nlinarith only [hnK, sq_nonneg K]
    nlinarith only [h2a, h2b, sq_nonneg K]
  have h3 : (500*K^2 + 10^15)/((n:ℝ)^2) ≤ 11/10/(n:ℝ) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ))^2) hnR]
    nlinarith only [h2, hnR]
  have h4 : 2*w' < (3/2*Real.log 2)/(n:ℝ) + 11/10/(n:ℝ) := by
    have hA : -((3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2))
        = -(3/2*Real.log 2)/(n:ℝ) - 10^15/((n:ℝ)^2) := by ring
    have ha : 2*w' < (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2 := by
      linarith only [h, hA]
    have hb : (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2
        ≤ (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2) := by linarith only [h1]
    have hc : (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2)
        = (3/2*Real.log 2)/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) := by ring
    have hb' : (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2
        ≤ (3/2*Real.log 2)/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) :=
      calc (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2
          ≤ (3/2*Real.log 2)/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2) := hb
        _ = (3/2*Real.log 2)/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) := hc
    have h3' : (3/2*Real.log 2)/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2)
        ≤ (3/2*Real.log 2)/(n:ℝ) + 11/10/(n:ℝ) := by linarith only [h3]
    exact lt_of_lt_of_le (lt_of_lt_of_le ha hb') h3'
  have h5 : (3/2*Real.log 2 + 11/10)/(n:ℝ) ≤ 3/(n:ℝ) := by
    rw [div_le_div_iff₀ hnR hnR]
    have hl : Real.log 2 ≤ 1 := log_two_le_one
    nlinarith only [hl, hnR]
  have h6 : w' ≤ 3/2/(n:ℝ) := by
    have h6a : 2*w' < (3/2*Real.log 2 + 11/10)/(n:ℝ) := by
      rw [add_div]
      exact h4
    have h6b : 2*w' < 3/(n:ℝ) := by
      have h9 : (3/2*Real.log 2 + 11/10)/(n:ℝ)
          = 3/2*Real.log 2/(n:ℝ) + 11/10/(n:ℝ) := by
        field_simp
      linarith only [h6a, h5, h9.le, h9.ge]
    have h6c : 2*w'*(n:ℝ) < 3 := (lt_div_iff₀ hnR).mp h6b
    rw [le_div_iff₀ hnR]
    linarith only [h6c]
  have h8 : 3/2/(n:ℝ) + 1/(n:ℝ) = 5/2/(n:ℝ) := by ring
  have h9 : (5/2:ℝ)/(n:ℝ) ≤ 4/(n:ℝ) := by
    rw [div_le_div_iff₀ hnR hnR]
    nlinarith only [hnR]
  linarith only [hww, h6, h8.le, h8.ge, h9]

lemma nmin_w_stage1 (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^15 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ))
    (hnK1 : 10^15 * (2*PhiC + 2) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(nmin p :ℝ) - Real.log 2| ≤ (2*PhiC+1)/(nmin p :ℝ) := by
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have h1 : -(PhiC/(nmin p :ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2 :=
    nmin_w_lower p hp hn hlarge
  have h2 : 2*PhiC ≤ (((nmin p + 1 : ℕ)):ℝ) := by
    have h2a : 2*PhiC + 1 ≤ (nmin p:ℝ) := by
      have h2b : 2*PhiC + 2 ≤ (nmin p:ℝ)/10^15 := by
        rw [le_div_iff₀ (by norm_num : (0:ℝ) < 10^15)]
        linarith only [hnK1]
      have h2c : (1:ℝ) ≤ (nmin p:ℝ)/10^15 := by linarith only [h2b, hCpos]
      linarith only [h2b, h2c]
    push_cast
    linarith only [h2a]
  have h3 : (p:ℝ)/(nmin p :ℝ) - Real.log 2
      ≤ 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + 1/(nmin p :ℝ) :=
    nmin_w_upper p hp hn hlarge h2
  have h4 : 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) ≤ 2*(PhiC/(nmin p :ℝ)) := by
    have h4a : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by positivity
    have h4b : (nmin p :ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith [hnR]
    have h4c : PhiC/(((nmin p + 1 : ℕ)):ℝ) ≤ PhiC/(nmin p :ℝ) :=
      div_le_div_of_nonneg_left hCpos.le hnR h4b
    linarith only [h4c]
  have h5 : 2*(PhiC/(nmin p :ℝ)) + 1/(nmin p :ℝ) ≤ (2*PhiC+1)/(nmin p :ℝ) := by
    have h5a : (2*PhiC+1)/(nmin p :ℝ) = 2*(PhiC/(nmin p :ℝ)) + 1/(nmin p :ℝ) := by
      field_simp
    linarith only [h5a.le, h5a.ge]
  have h6 : -(PhiC/(nmin p :ℝ)) ≥ -((2*PhiC+1)/(nmin p :ℝ)) := by
    have : PhiC/(nmin p :ℝ) ≤ (2*PhiC+1)/(nmin p :ℝ) := by
      apply div_le_div_of_nonneg_right _ hnR.le
      linarith only [hCpos]
    linarith only [this]
  rw [abs_le]
  constructor
  · linarith only [h1, h6]
  · linarith only [h3, h4, h5]

lemma uPhiS_ge (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu1 : 1/2 ≤ u) (hu : u = Real.log 2 + w)
    (hPS : 6 - 26*w - 10^16*w^2 ≤ PhiS u) :
    (11/4:ℝ) ≤ u * PhiS u := by
  have hw2 : w^2 ≤ q^2 := sq_le_sq' (abs_le.mp hw).1 (abs_le.mp hw).2
  have h1 : 26*w + 10^16*w^2 ≤ 1/2 := by
    have hq1 : 26*q + 10^16*q^2 ≤ 1/2 := by nlinarith only [hq0, hq]
    nlinarith only [hq0, hq1, hw2, (abs_le.mp hw).1, (abs_le.mp hw).2]
  have h2 : (11/4:ℝ) ≤ (1/2)*(6 - 26*w - 10^16*w^2) := by
    nlinarith only [h1, sq_nonneg w]
  have h3 : (0:ℝ) < u := by linarith only [hu1]
  have h4 : (1/2:ℝ) * (6 - 26*w - 10^16*w^2) ≤ u * PhiS u := by
    nlinarith only [hPS, h2, hu1, h3, h2]
  linarith only [h2, h4]

lemma stage2_lower_final (n : ℕ) (hn : 1 ≤ n) (w : ℝ)
    (h : -2*w - 500*w^2 < -((11/8)/(n:ℝ)) + (4*10^10 + 10^12)/((n:ℝ)^2)) :
    -2*w - 500*w^2 < -((11/8)/(n:ℝ)) + 10^15/((n:ℝ)^2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : (4*10^10 + 10^12 : ℝ) ≤ 10^15 := by norm_num
  have h2 : (4*10^10 + 10^12)/((n:ℝ)^2) ≤ 10^15/((n:ℝ)^2) :=
    div_le_div_of_nonneg_right h1 (by positivity)
  linarith only [h, h2]

lemma stage2_lower_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (11/8)/(n:ℝ) ≤ X)
    (hD : -(4*10^10) ≤ D)
    (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -((11/8)/(n:ℝ)) + (4*10^10 + 10^12)/((n:ℝ)^2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : -((4*10^10)/((n:ℝ)^2)) ≤ D/((n:ℝ)^2) := by
    have h1a : -((4*10^10:ℝ)) ≤ D := by linarith only [hD]
    have h1b : -((4*10^10:ℝ))/((n:ℝ)^2) = -((4*10^10)/((n:ℝ)^2)) := by rw [neg_div]
    rw [← h1b]
    exact div_le_div_of_nonneg_right h1a (by positivity)
  have h2 : -X ≤ -((11/8)/(n:ℝ)) := by
    have h2a : -X ≤ -((11/8)/(n:ℝ)) := neg_le_neg hX
    exact h2a
  have h3 : (4*10^10:ℝ)/((n:ℝ)^2) + 10^12/((n:ℝ)^2)
      = (4*10^10 + 10^12)/((n:ℝ)^2) := by ring
  have h4 : Y < 1 - X - D/((n:ℝ)^2) + E := by linarith only [hthird]
  have h5 : -2*w - 500*w^2 < -X - D/((n:ℝ)^2) + E := by linarith only [hexp, h4]
  have h6 : -X - D/((n:ℝ)^2) + E ≤ -((11/8)/(n:ℝ)) + (4*10^10 + 10^12)/((n:ℝ)^2) := by
    linarith only [h2, h1, hE, h3.le, h3.ge]
  linarith only [h5, h6]

lemma stage2_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    -(4/(nmin p :ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2 := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
  have hX0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := by positivity
  have hnK15 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hX0]
    linarith only [hnK, h1]
  have hstage1 := nmin_w_stage1 p hp hn hlarge hnK15
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      nlinarith only [hnK15, this])
  set w : ℝ := (p:ℝ)/(nmin p :ℝ) - Real.log 2 with hwdef
  have hu : (p:ℝ)/(nmin p :ℝ) = Real.log 2 + w := by rw [hwdef]; ring
  have hwabs : |w| ≤ (2*PhiC+1)/(nmin p:ℝ) := by rw [hwdef]; exact hstage1
  have hw : w^2 ≤ ((2*PhiC+1)/(nmin p:ℝ))^2 :=
    sq_le_sq' (abs_le.mp hwabs).1 (abs_le.mp hwabs).2
  have hq0 : (0:ℝ) ≤ (2*PhiC+1)/(nmin p:ℝ) := by positivity
  have hq1 : (2*PhiC+1)/(nmin p:ℝ) ≤ 1/10^9 := by
    rw [div_le_iff₀ hnR]
    have h1d : (0:ℝ) ≤ 2*PhiC+1 := by linarith only [hCpos]
    have h1e : (0:ℝ) ≤ 1/10^9 * (nmin p:ℝ) := by positivity
    have h1a : (2*PhiC+1)^2 ≤ (1/10^9 * (nmin p:ℝ))^2 := by
      have h1b : (2*PhiC+1)^2 ≤ (nmin p:ℝ)/10^40 := by
        nlinarith only [hnK, sq_nonneg (2*PhiC+1), hX0]
      have h1c : (nmin p:ℝ)/10^40 ≤ (1/10^9 * (nmin p:ℝ))^2 := by
        have h3 : (1/10^9 * (nmin p:ℝ))^2 = (nmin p:ℝ)^2/10^18 := by ring
        rw [h3, div_le_div_iff₀ (by norm_num : (0:ℝ) < 10^40) (by norm_num : (0:ℝ) < 10^18)]
        nlinarith only [hnR, hn1]
      linarith only [h1b, h1c]
    have h1f := sq_le_sq.mp h1a
    rw [abs_of_nonneg h1d, abs_of_nonneg h1e] at h1f
    linarith only [h1f]
  have hu2 : (p:ℝ)/(nmin p :ℝ) ≤ 1 := by
    rw [div_le_one hnR]
    have h1 := nmin_ge_p p hp
    exact_mod_cast h1
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/(nmin p :ℝ) := by
    rw [le_div_iff₀ hnR]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (nmin p :ℝ) ≤ 2*(p:ℝ) := by exact_mod_cast (le_of_lt h2)
    linarith
  have sb := split_bounds' (by omega : 100000000 ≤ nmin p)
  have hthird := Phi_third_order hu1 hu2 hn sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hlt := nmin_Phi_lt p hp2 (by omega : 1 ≤ nmin p)
  have hlin := exp_threshold_linear ((p:ℝ)/(nmin p:ℝ)) hu1 hu2
  have hPS := PhiS_second_order_at_log2 ((p:ℝ)/(nmin p:ℝ)) hu1 hu2
  have hD := SThird_D_abs_le ((p:ℝ)/(nmin p:ℝ)) hu1 hu2
  have hPSb : 6 - 26*w - 10^16*w^2 ≤ PhiS ((p:ℝ)/(nmin p:ℝ)) := by
    have h := (abs_le.mp hPS).1
    rw [hwdef]
    linarith only [h]
  have hS := uPhiS_ge ((p:ℝ)/(nmin p:ℝ)) ((2*PhiC+1)/(nmin p:ℝ)) w hq0 hq1 hwabs hu1 hu hPSb
  have hexp : -2*w - 500*w^2
      ≤ (Real.exp ((p:ℝ)/(nmin p:ℝ)) - 1)⁻¹ - 1 := by
    have h := (abs_le.mp hlin).1
    rw [hwdef]
    linarith only [h]
  have hMeq := PhiMainS_eq ((p:ℝ)/(nmin p:ℝ)) (nmin p) hu1 (by omega : 1 ≤ nmin p)
  have hD' : -(4*10^10:ℝ) ≤ -(((p:ℝ)/(nmin p:ℝ))/3)*PhiK3u ((p:ℝ)/(nmin p:ℝ))
      + (((p:ℝ)/(nmin p:ℝ))^2/8)*PhiK4u ((p:ℝ)/(nmin p:ℝ)) := (abs_le.mp hD).1
  have hthird' : (Real.exp ((p:ℝ)/(nmin p:ℝ)) - 1)⁻¹
      + ((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ))
      + (-(((p:ℝ)/(nmin p:ℝ))/3)*PhiK3u ((p:ℝ)/(nmin p:ℝ))
          + (((p:ℝ)/(nmin p:ℝ))^2/8)*PhiK4u ((p:ℝ)/(nmin p:ℝ)))/((nmin p:ℝ)^2)
      - (8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3) < 1 := by
    have h1 := (abs_le.mp hthird).1
    rw [div_mul_cancel₀ _ (ne_of_gt hnR)] at h1
    have h2 : PhiMainS ((p:ℝ)/(nmin p:ℝ)) (nmin p)
        - (8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3) ≤ Phi (p:ℝ) (nmin p) := by
      rw [hMeq]
      linarith only [h1]
    rw [hMeq] at h2
    exact lt_of_le_of_lt h2 hlt
  have hE : (8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3) ≤ 10^12/((nmin p:ℝ)^2) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((nmin p:ℝ))^3)
      (by positivity : (0:ℝ) < ((nmin p:ℝ))^2)]
    have hb : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 := by norm_num
    have hbig : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 * (nmin p:ℝ) :=
      le_trans hb (by nlinarith only [hn1])
    have hcube : ((nmin p:ℝ))^3 = (nmin p:ℝ) * ((nmin p:ℝ))^2 := by ring
    rw [hcube]
    have hmul := mul_le_mul_of_nonneg_right hbig (sq_nonneg ((nmin p:ℝ)))
    have heq : (10^12 * (nmin p:ℝ)) * ((nmin p:ℝ))^2
        = 10^12 * ((nmin p:ℝ) * ((nmin p:ℝ))^2) := by ring
    linarith only [hmul, heq.le, heq.ge]
  have hX : (11/8)/(nmin p:ℝ)
      ≤ ((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ)) := by
    rw [div_mul_eq_mul_div]
    rw [le_div_iff₀ (by positivity : (0:ℝ) < 2*(nmin p:ℝ))]
    have h3 : (11/8:ℝ)/(nmin p:ℝ) * (2*(nmin p:ℝ)) = 11/4 := by
      rw [div_mul_eq_mul_div]
      have h4 : (11/8:ℝ) * (2*(nmin p:ℝ)) = (11/4) * (nmin p:ℝ) := by ring
      rw [h4, mul_div_cancel_right₀ _ (ne_of_gt hnR)]
    rw [h3]
    exact hS
  have hstep := stage2_lower_exp (nmin p) (by omega) w
    ((Real.exp ((p:ℝ)/(nmin p:ℝ)) - 1)⁻¹)
    (((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ)))
    (-(((p:ℝ)/(nmin p:ℝ))/3)*PhiK3u ((p:ℝ)/(nmin p:ℝ))
      + (((p:ℝ)/(nmin p:ℝ))^2/8)*PhiK4u ((p:ℝ)/(nmin p:ℝ)))
    ((8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3)) hX hD' hE hexp hthird'
  have hstep' := stage2_lower_final (nmin p) (by omega) w hstep
  have hbr : -((11/8)/(nmin p:ℝ)) = -(11/8)/(nmin p:ℝ) := by rw [neg_div]
  have hmain : -2*w - 500*w^2 < -(11/8)/(nmin p:ℝ) + 10^15/((nmin p:ℝ)^2) := by
    rw [← hbr]
    exact hstep'
  exact stage2_lower_arith (nmin p) (by omega) (2*PhiC+1)
    (by linarith only [hCpos]) hnK15 w hw hmain

lemma stage2_upper_arith2 (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -((3:ℝ))/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : 500*w'^2 ≤ 500*K^2/((n:ℝ)^2) := by
    have h1a := mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 500)
    have h1b : 500*(K/(n:ℝ))^2 = 500*K^2/((n:ℝ)^2) := by field_simp
    linarith only [h1a, h1b.le, h1b.ge]
  have h2 : (500*K^2 + 10^15 : ℝ) ≤ 11/10 * (n:ℝ) := by
    have h2a : K^2 + 1 ≤ (n:ℝ)/10^15 := by
      rw [le_div_iff₀ (by norm_num : (0:ℝ) < 10^15)]
      nlinarith only [hnK]
    have h2b : (10^15:ℝ) ≤ (n:ℝ) := by nlinarith only [hnK, sq_nonneg K]
    nlinarith only [h2a, h2b, sq_nonneg K]
  have h3 : (500*K^2 + 10^15)/((n:ℝ)^2) ≤ 11/10/(n:ℝ) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ))^2) hnR]
    nlinarith only [h2, hnR]
  have h4 : 2*w' < ((3:ℝ))/(n:ℝ) + 11/10/(n:ℝ) := by
    have hA : -(((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2))
        = -((3:ℝ))/(n:ℝ) - 10^15/((n:ℝ)^2) := by ring
    have ha : 2*w' < ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2 := by
      linarith only [h, hA]
    have hb : ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2
        ≤ ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2) := by linarith only [h1]
    have hc : ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2)
        = ((3:ℝ))/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) := by ring
    have hb' : ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2
        ≤ ((3:ℝ))/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) :=
      calc ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*w'^2
          ≤ ((3:ℝ))/(n:ℝ) + 10^15/((n:ℝ)^2) + 500*K^2/((n:ℝ)^2) := hb
        _ = ((3:ℝ))/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2) := hc
    have h3' : ((3:ℝ))/(n:ℝ) + (500*K^2 + 10^15)/((n:ℝ)^2)
        ≤ ((3:ℝ))/(n:ℝ) + 11/10/(n:ℝ) := by linarith only [h3]
    exact lt_of_lt_of_le (lt_of_lt_of_le ha hb') h3'
  have h5 : (3/2*Real.log 2 + 11/10)/(n:ℝ) ≤ 3/(n:ℝ) := by
    rw [div_le_div_iff₀ hnR hnR]
    have hl : Real.log 2 ≤ 1 := log_two_le_one
    nlinarith only [hl, hnR]
  have h6 : w' ≤ 41/20/(n:ℝ) := by
    have h6a : 2*w' < ((3:ℝ) + 11/10)/(n:ℝ) := by
      rw [add_div]
      exact h4
    have h6b : 2*w' < 41/10/(n:ℝ) := by
      have h9 : ((3:ℝ) + 11/10)/(n:ℝ)
          = ((3:ℝ))/(n:ℝ) + 11/10/(n:ℝ) := by
        field_simp
      linarith only [h6a, h5, h9.le, h9.ge]
    have h6c : 2*w'*(n:ℝ) < 41/10 := (lt_div_iff₀ hnR).mp h6b
    rw [le_div_iff₀ hnR]
    linarith only [h6c]
  have h8 : 41/20/(n:ℝ) + 1/(n:ℝ) = 61/20/(n:ℝ) := by ring
  have h9 : (61/20:ℝ)/(n:ℝ) ≤ 4/(n:ℝ) := by
    rw [div_le_div_iff₀ hnR hnR]
    nlinarith only [hnR]
  linarith only [hww, h6, h8.le, h8.ge, h9]

lemma lt_of_lt_le_le {A B C D : ℝ} (h1 : D < C) (h2 : C ≤ B) (h3 : B ≤ A) : D < A :=
  lt_of_lt_of_le h1 (le_trans h2 h3)

namespace Op56
set_option maxHeartbeats 16000000
noncomputable section
open scoped BigOperators Topology
open MeasureTheory

/-- The `exp`-side inequality for `stage2_upper`.  `hthird` is supplied in the conclusion's form. -/
lemma stage2_upper_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : X ≤ 3/(n:ℝ))
    (hD : D ≤ 4*10^10)
    (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y) :
    -((3:ℝ)/(n:ℝ)) - 10^15/((n:ℝ)^2) < -2*w + 500*w^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : D/((n:ℝ)^2) ≤ (4*10^10)/((n:ℝ)^2) :=
    div_le_div_of_nonneg_right hD (by positivity)
  have h5 : -2*w + 500*w^2 ≥ -E - X - D/((n:ℝ)^2) := by linarith only [hexp, hthird]
  have h6 : -E - X - D/((n:ℝ)^2) ≥ -((3:ℝ)/(n:ℝ)) - (4*10^10 + 10^12)/((n:ℝ)^2) := by
    have h6a : -X ≥ -((3:ℝ)/(n:ℝ)) := neg_le_neg hX
    have h6b : -E ≥ -(10^12/((n:ℝ)^2)) := neg_le_neg hE
    have hD2 : (-D)/((n:ℝ)^2) = -(D/((n:ℝ)^2)) := by field_simp
    have h6c : -(D/((n:ℝ)^2)) ≥ -((4*10^10)/((n:ℝ)^2)) := by
      have h := neg_le_neg h1
      linarith only [h, hD2]
    have hsum : (-E) + (-X) + (-(D/((n:ℝ)^2)))
        ≥ (-(10^12/((n:ℝ)^2))) + (-((3:ℝ)/(n:ℝ))) + (-((4*10^10)/((n:ℝ)^2))) :=
      add_le_add (add_le_add h6b h6a) h6c
    have hs : (-(10^12/((n:ℝ)^2))) + (-((3:ℝ)/(n:ℝ))) + (-((4*10^10)/((n:ℝ)^2)))
        = -((3:ℝ)/(n:ℝ)) - (4*10^10 + 10^12)/((n:ℝ)^2) := by
      field_simp
      ring
    linarith only [hsum, hs]
  have h7 : (4*10^10 + 10^12:ℝ)/((n:ℝ)^2) < 10^15/((n:ℝ)^2) := by
    apply div_lt_div_of_pos_right _ (by positivity)
    norm_num
  have h8 : -((3:ℝ)/(n:ℝ)) - (4*10^10 + 10^12)/((n:ℝ)^2)
      > -((3:ℝ)/(n:ℝ)) - 10^15/((n:ℝ)^2) := by linarith only [h7]
  exact lt_of_lt_le_le h8 h6 h5

lemma uPhiS_le (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu2 : u ≤ 1) (hu : u = Real.log 2 + w)
    (hPS : PhiS u ≤ 6 - 26*w + 10^16*w^2) :
    u * PhiS u ≤ 5 := by
  have hw2 : w^2 ≤ q^2 := sq_le_sq' (abs_le.mp hw).1 (abs_le.mp hw).2
  have h1 : 26*w + 10^16*w^2 ≤ 1/2 := by
    have hq1 : 26*q + 10^16*q^2 ≤ 1/2 := by nlinarith only [hq0, hq]
    nlinarith only [hq0, hq1, hw2, (abs_le.mp hw).1, (abs_le.mp hw).2]
  have hl : Real.log 2 ≤ 3/4 := by
    have h := Real.log_two_lt_d9
    norm_num at h
    linarith only [h]
  have h2 : (Real.log 2 + w) * (6 - 26*w + 10^16*w^2) ≤ 5 := by
    have hl2 : Real.log 2 ≤ 694/1000 := by
      have h := Real.log_two_lt_d9
      norm_num at h
      linarith only [h]
    have hwq : w ≤ 1/10^9 := le_trans (abs_le.mp hw).2 hq
    have ha : Real.log 2 + w ≤ 7/10 := by linarith only [hl2, hwq]
    have hb : 6 - 26*w + 10^16*w^2 ≤ 7 := by
      have hwl : -q ≤ w := (abs_le.mp hw).1
      nlinarith only [h1, hwl, hq0, hq]
    have hapos : (0:ℝ) ≤ Real.log 2 + w := by
      have hlg := Real.log_two_gt_d9
      have hwl : -q ≤ w := (abs_le.mp hw).1
      norm_num at hlg
      linarith only [hlg, hwl, hq0, hq]
    have hbpos : (0:ℝ) ≤ 6 - 26*w + 10^16*w^2 := by
      have hwl : -q ≤ w := (abs_le.mp hw).1
      nlinarith only [h1, hwl, hq0, hq]
    have hprod := mul_le_mul ha hb hbpos (le_trans hapos ha)
    have hq2 : (7/10:ℝ) * 7 ≤ 5 := by norm_num
    linarith only [hprod, hq2]
  have h3 : u * PhiS u ≤ (Real.log 2 + w) * (6 - 26*w + 10^16*w^2) := by
    rw [hu] at hPS ⊢
    have hpos : (0:ℝ) ≤ Real.log 2 + w := by
      have hlg := Real.log_two_gt_d9
      have hwl : -q ≤ w := (abs_le.mp hw).1
      norm_num at hlg
      linarith only [hlg, hwl, hq0, hq]
    exact mul_le_mul_of_nonneg_left hPS hpos
  exact le_trans h3 h2

lemma stage2_upper (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(nmin p :ℝ) - Real.log 2 ≤ 4/(nmin p :ℝ) := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
  have hN1 : (1:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) :=
    by exact_mod_cast (by omega : 1 ≤ nmin p + 1)
  have hNpos : (0:ℝ) < ((nmin p + 1 : ℕ):ℝ) := by linarith only [hN1]
  have hX0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := by positivity
  have hnK15 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hX0]
    linarith only [hnK, h1]
  have hnK15' : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ ((nmin p + 1 : ℕ):ℝ) := by
    have h2 : (nmin p:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) := by push_cast; linarith only [hnR]
    linarith only [hnK15, h2]
  have hstage1 := nmin_w_stage1 p hp hn hlarge
    (by
      have h0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := hX0
      have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
        nlinarith only [h0]
      linarith only [hnK, h1])
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      have h1 : (10^15:ℝ) * ((2*PhiC+2)) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
        nlinarith only [this]
      linarith only [hnK15, h1])
  have hu2 : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ 1 := by
    rw [div_le_one hNpos]
    have h1 := nmin_ge_p p hp
    have h2 : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast h1
    have h3 : (nmin p:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) := by push_cast; linarith only [hnR]
    linarith only [h2, h3, hNpos]
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/((nmin p + 1 : ℕ):ℝ) := by
    rw [le_div_iff₀ hNpos]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(p:ℝ) := by
      exact_mod_cast (by omega : nmin p + 1 ≤ 2*p)
    have h4 := mul_le_mul_of_nonneg_left h3 (by norm_num : (0:ℝ) ≤ 1/2)
    linarith only [h4]
  have sb := split_bounds' (by omega : 100000000 ≤ nmin p + 1)
  have hthird := Phi_third_order hu1 hu2 (by omega : 2000000000 ≤ nmin p + 1) sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hge := nmin_Phi_ge p hp2
  have hMeq := PhiMainS_eq ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) (nmin p + 1) hu1 (by omega : 1 ≤ nmin p + 1)
  set w : ℝ := (p:ℝ)/(nmin p :ℝ) - Real.log 2 with hwdef
  set w' : ℝ := (p:ℝ)/((nmin p + 1 : ℕ):ℝ) - Real.log 2 with hwdef'
  have hstage1 := nmin_w_stage1 p hp hn hlarge hnK15
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      nlinarith only [hnK15, this])
  have hwabs : |w| ≤ (2*PhiC+1)/(nmin p:ℝ) := by rw [hwdef]; exact hstage1
  have hdiff : |(p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)| ≤ 1/(nmin p:ℝ) := by
    have hle : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) :=
      div_le_div_of_nonneg_left (by positivity) hnR (by push_cast; linarith only [hnR])
    rw [abs_of_nonpos (by linarith only [hle]), neg_sub]
    have h2 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
        = (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
      push_cast
      field_simp
      ring
    rw [h2]
    rw [div_le_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)))]
    have hp' : (p:ℝ) ≤ (nmin p :ℝ) := by exact_mod_cast (nmin_ge_p p hp)
    have hid : (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))
        = (((nmin p + 1 : ℕ)):ℝ) := by field_simp
    have hnle : (nmin p :ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    exact calc (p:ℝ) ≤ (nmin p :ℝ) := hp'
      _ ≤ (((nmin p + 1 : ℕ)):ℝ) := hnle
      _ = (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := hid.symm
  have hwabs' : |w'| ≤ (2*PhiC+2)/(nmin p:ℝ) := by
    have he : w' = w + ((p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)) := by
      rw [hwdef, hwdef']
      ring
    rw [he]
    calc |w + ((p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ))|
        ≤ |w| + |(p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)| := abs_add_le _ _
      _ ≤ (2*PhiC+1)/(nmin p:ℝ) + 1/(nmin p:ℝ) := add_le_add hwabs hdiff
      _ = (2*PhiC+2)/(nmin p:ℝ) := by ring
  have hq' : (2*PhiC+2)/(nmin p:ℝ) ≤ 1/10^9 := by
    rw [div_le_iff₀ hnR]
    have h1 : (10^9:ℝ) * (2*PhiC+2) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hCpos, sq_nonneg (2*PhiC+1)]
    linarith only [h1, hnK15]
  have hstep : 1 - (8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3)
        - ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
        - (-(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
            + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
            /(((nmin p + 1 : ℕ)):ℝ)^2
      ≤ (Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹ := by
    have h1 := (abs_le.mp hthird).2
    rw [div_mul_cancel₀ _ (ne_of_gt hNpos)] at h1
    linarith only [h1, hge]
  have hlin := exp_threshold_linear ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hPS := PhiS_second_order_at_log2 ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hD := SThird_D_abs_le ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hu' : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) = Real.log 2 + w' := by rw [hwdef']; ring
  have hwabsG : |w'| ≤ (2*PhiC+2)/(nmin p:ℝ) := hwabs'
  have hPSu : PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ 6 - 26*w' + 10^16*w'^2 := by
    have h := (abs_le.mp hPS).2
    rw [← hwdef'] at h
    linarith only [h]
  have hS := Op56.Op56.uPhiS_le ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ((2*PhiC+2)/(nmin p:ℝ)) w'
    (by positivity) hq' hwabsG hu2 hu' hPSu
  have hexp : (Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹ - 1
      ≤ -2*w' + 500*w'^2 := by
    have h := (abs_le.mp hlin).2
    rw [← hwdef'] at h
    linarith only [h]
  have hDup : -(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ≤ 4*10^10 :=
    (abs_le.mp hD).2
  have hX : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ 3/((nmin p + 1 : ℕ):ℝ) := by
    have h1 : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ≤ 5 := hS
    have h2 : (2:ℝ) * (((nmin p + 1 : ℕ)):ℝ) > 0 := by positivity
    have h3 : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
        = (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))/(2*(((nmin p + 1 : ℕ)):ℝ)) := by
      rw [div_mul_eq_mul_div]
    rw [h3]
    rw [div_le_div_iff₀ h2 (by positivity : (0:ℝ) < ((nmin p + 1 : ℕ):ℝ))]
    have h4 : (3:ℝ) * 2 = 6 := by norm_num
    nlinarith only [h1, h4]
  have hww : w ≤ w' + 1/(nmin p:ℝ) := by
    have h5 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ 1/(nmin p:ℝ) := by
      have h := hdiff
      rw [abs_of_nonpos, neg_sub] at h
      · exact h
      · have hle : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) :=
          div_le_div_of_nonneg_left (by positivity) hnR (by push_cast; linarith only [hnR])
        linarith only [hle]
    rw [hwdef, hwdef']
    linarith only [h5]
  have hE' : (8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3) ≤ 10^12/(((nmin p + 1 : ℕ):ℝ)^2) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^3)
      (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^2)]
    have hb : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 := by norm_num
    have hn1'' : (1:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := hN1
    have hbig : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 * (((nmin p + 1 : ℕ)):ℝ) :=
      le_trans hb (by nlinarith only [hn1''])
    have hcube : (((nmin p + 1 : ℕ)):ℝ)^3 = (((nmin p + 1 : ℕ)):ℝ) * (((nmin p + 1 : ℕ)):ℝ)^2 := by ring
    rw [hcube]
    have hmul := mul_le_mul_of_nonneg_right hbig (sq_nonneg (((nmin p + 1 : ℕ)):ℝ))
    have heq : (10^12 * (((nmin p + 1 : ℕ)):ℝ)) * (((nmin p + 1 : ℕ)):ℝ)^2
        = 10^12 * ((((nmin p + 1 : ℕ)):ℝ) * (((nmin p + 1 : ℕ)):ℝ)^2) := by ring
    linarith only [hmul, heq.le, heq.ge]
  have hstep' := Op56.Op56.stage2_upper_exp (nmin p + 1) (by omega) w'
    ((Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹)
    (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
    (-(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
    ((8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3)) hX hDup hE' hexp hstep
  have hbridge : -(3:ℝ) / (nmin p:ℝ) - 10^15/((nmin p:ℝ)^2)
      < -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 10^15/((((nmin p + 1 : ℕ)):ℝ)^2) := by
    have h1 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    have h2 : (0:ℝ) < (nmin p:ℝ) := hnR
    have h3 : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := hNpos
    have h1s : (nmin p:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    have h4 : (10^15:ℝ)/((((nmin p + 1 : ℕ)):ℝ)^2) < 10^15/((nmin p:ℝ)^2) := by
      rw [div_lt_div_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^2)
        (by positivity : (0:ℝ) < ((nmin p:ℝ)^2))]
      nlinarith only [h1s, hnR]
    have h5 : (3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) < 3/(nmin p:ℝ) := by
      rw [div_lt_div_iff₀ h3 h2]
      nlinarith only [h1s]
    have e1 : -((3:ℝ)/(nmin p:ℝ)) = -(3:ℝ)/(nmin p:ℝ) := by ring
    have e2 : -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) = -(3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) := by ring
    linarith only [h4, h5, e1, e2]
  have hwK : w'^2 ≤ ((2*PhiC+2)/(nmin p:ℝ))^2 :=
    sq_le_sq' (abs_le.mp hwabs').1 (abs_le.mp hwabs').2
  have hnKK : (10^15:ℝ) * ((2*PhiC+2)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+2)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hCpos, sq_nonneg (2*PhiC+1)]
    linarith only [hnK, h1]
  exact stage2_upper_arith2 (nmin p) (by omega) (2*PhiC+2)
    (by linarith only [hCpos]) hnKK w w' hwK (lt_trans hbridge hstep') hww


/-- Stage 2 conclusion: `|p/nmin p − log 2| ≤ 4/nmin p` — the hypothesis both window lemmas need. -/
lemma nmin_w_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(nmin p :ℝ) - Real.log 2| ≤ 4/(nmin p :ℝ) := by
  refine abs_le.mpr ⟨?_, ?_⟩
  · exact stage2_lower p hp hn hlarge hnK
  · exact stage2_upper p hp hn hlarge hnK


/-- The lower window bound at `nmin p` (contrapositive of `Phi_window_low`). -/
lemma nmin_window_low (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    Real.log 2 + 3*Real.log 2/(2*(nmin p:ℝ)) - 10^19/((nmin p:ℝ)^2)
      < (p:ℝ)/(nmin p:ℝ) := by
  by_contra hcon
  push_neg at hcon
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hp2 : 2 ≤ p := by omega
  have hu2 : (p:ℝ)/(nmin p :ℝ) ≤ 1 := by
    rw [div_le_one hnR]
    have h1 := nmin_ge_p p hp
    exact_mod_cast h1
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/(nmin p :ℝ) := by
    rw [le_div_iff₀ hnR]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (nmin p :ℝ) ≤ 2*(p:ℝ) := by exact_mod_cast (le_of_lt h2)
    linarith only [h3]
  have hwabs := nmin_w_sharp p hp hn hlarge hnK
  have hwin := Phi_window_low ((p:ℝ)/(nmin p :ℝ)) (nmin p) hu1 hu2 hn hwabs hcon
  rw [div_mul_cancel₀ _ (ne_of_gt hnR)] at hwin
  have hlt := nmin_Phi_lt p hp2 (by omega : 1 ≤ nmin p)
  linarith only [hwin, hlt]


/-- Stage 1 at `nmin p + 1`: `|p/n' − log 2| ≤ (2PhiC+3)/n'`. -/
lemma nmin_w_stage1' (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2| ≤ (2*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ) := by
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hNpos : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hX0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := by positivity
  have hnK15 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hX0]
    linarith only [hnK, h1]
  have hstage1 := nmin_w_stage1 p hp hn hlarge hnK15
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      nlinarith only [hnK15, this])
  have hdiff : |(p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)| ≤ 1/(((nmin p + 1 : ℕ)):ℝ) := by
    have hle : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) :=
      div_le_div_of_nonneg_left (by positivity) hnR (by push_cast; linarith only [hnR])
    rw [abs_of_nonneg (by linarith only [hle])]
    have h2 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
        = (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
      push_cast
      field_simp
      ring
    rw [h2]
    rw [div_le_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)))]
    have hp' : (p:ℝ) ≤ (nmin p :ℝ) := by exact_mod_cast (nmin_ge_p p hp)
    have hid : (1/(((nmin p + 1 : ℕ)):ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) = (nmin p :ℝ) := by
      field_simp
    linarith only [hp', hid]
  have htri : |(p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2|
      ≤ |(p:ℝ)/(nmin p :ℝ) - Real.log 2| + |(p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)| := by
    have he : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2
        = ((p:ℝ)/(nmin p :ℝ) - Real.log 2) - ((p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) := by
      ring
    rw [he]
    exact abs_sub _ _
  have h3 : (2*PhiC+1)/(nmin p:ℝ) + 1/(((nmin p + 1 : ℕ)):ℝ)
      ≤ (2*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ) := by
    have hp' : (p:ℝ) ≤ (nmin p :ℝ) := by exact_mod_cast (nmin_ge_p p hp)
    have hge : (2*PhiC+1:ℝ) ≤ (nmin p:ℝ) := by
      have h1 : (2*PhiC+1 : ℝ) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
        have h2 : (1:ℝ) ≤ 10^15 := by norm_num
        nlinarith only [hX0, h2]
      linarith only [h1, hnK15]
    rw [div_add_div _ _ (ne_of_gt hnR) (ne_of_gt hNpos)]
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))) hNpos]
    push_cast
    nlinarith only [hge, hnR, hp']
  linarith only [htri, hstage1, hdiff, h3]


/-- The largeness condition for `K := 2*PhiC+3` at `nmin p + 1`. -/
lemma nmin_K_bounds (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (10^15:ℝ) * ((2*PhiC+3)^2 + 1) ≤ (((nmin p + 1 : ℕ)):ℝ) := by
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have h1 : (10^15:ℝ) * ((2*PhiC+3)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
    nlinarith only [hCpos, sq_nonneg (2*PhiC+1)]
  have h2 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
  linarith only [hnK, h1, h2]


/-- The `w'` bound at `nmin p + 1`, with `K := 2*PhiC+3`. -/
lemma nmin_hwK' (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2)^2
      ≤ ((2*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ))^2 := by
  have h := nmin_w_stage1' p hp hn hlarge hnK
  exact sq_le_sq' (abs_le.mp h).1 (abs_le.mp h).2

lemma nmin_upper_sharp_p (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2 ≤ 4/(((nmin p + 1 : ℕ)):ℝ) := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
  have hN1 : (1:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) :=
    by exact_mod_cast (by omega : 1 ≤ nmin p + 1)
  have hNpos : (0:ℝ) < ((nmin p + 1 : ℕ):ℝ) := by linarith only [hN1]
  have hX0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := by positivity
  have hnK15 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hX0]
    linarith only [hnK, h1]
  have hnK15' : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ ((nmin p + 1 : ℕ):ℝ) := by
    have h2 : (nmin p:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) := by push_cast; linarith only [hnR]
    linarith only [hnK15, h2]
  have hstage1 := nmin_w_stage1 p hp hn hlarge
    (by
      have h0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := hX0
      have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
        nlinarith only [h0]
      linarith only [hnK, h1])
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      have h1 : (10^15:ℝ) * ((2*PhiC+2)) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
        nlinarith only [this]
      linarith only [hnK15, h1])
  have hu2 : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ 1 := by
    rw [div_le_one hNpos]
    have h1 := nmin_ge_p p hp
    have h2 : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast h1
    have h3 : (nmin p:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) := by push_cast; linarith only [hnR]
    linarith only [h2, h3, hNpos]
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/((nmin p + 1 : ℕ):ℝ) := by
    rw [le_div_iff₀ hNpos]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(p:ℝ) := by
      exact_mod_cast (by omega : nmin p + 1 ≤ 2*p)
    have h4 := mul_le_mul_of_nonneg_left h3 (by norm_num : (0:ℝ) ≤ 1/2)
    linarith only [h4]
  have sb := split_bounds' (by omega : 100000000 ≤ nmin p + 1)
  have hthird := Phi_third_order hu1 hu2 (by omega : 2000000000 ≤ nmin p + 1) sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hge := nmin_Phi_ge p hp2
  have hMeq := PhiMainS_eq ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) (nmin p + 1) hu1 (by omega : 1 ≤ nmin p + 1)
  set w : ℝ := (p:ℝ)/((nmin p + 1 : ℕ):ℝ) - Real.log 2 with hwdef
  set w' : ℝ := (p:ℝ)/((nmin p + 1 : ℕ):ℝ) - Real.log 2 with hwdef'
  have hstage1 := nmin_w_stage1 p hp hn hlarge hnK15
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      nlinarith only [hnK15, this])
  have hwabs : |w| ≤ (2*PhiC+3)/((nmin p + 1 : ℕ):ℝ) := by
    rw [hwdef]
    exact Op56.nmin_w_stage1' p hp hn hlarge hnK
  have hdiff : |(p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)| ≤ 1/(nmin p:ℝ) := by
    have hle : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) :=
      div_le_div_of_nonneg_left (by positivity) hnR (by push_cast; linarith only [hnR])
    rw [abs_of_nonpos (by linarith only [hle]), neg_sub]
    have h2 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
        = (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
      push_cast
      field_simp
      ring
    rw [h2]
    rw [div_le_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)))]
    have hp' : (p:ℝ) ≤ (nmin p :ℝ) := by exact_mod_cast (nmin_ge_p p hp)
    have hid : (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))
        = (((nmin p + 1 : ℕ)):ℝ) := by field_simp
    have hnle : (nmin p :ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    exact calc (p:ℝ) ≤ (nmin p :ℝ) := hp'
      _ ≤ (((nmin p + 1 : ℕ)):ℝ) := hnle
      _ = (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := hid.symm
  have hwabs' : |w'| ≤ (2*PhiC+3)/((nmin p + 1 : ℕ):ℝ) :=
    Op56.nmin_w_stage1' p hp hn hlarge hnK
  have hq' : (2*PhiC+3)/((nmin p + 1 : ℕ):ℝ) ≤ 1/10^9 := by
    rw [div_le_iff₀ hNpos]
    have h1 : (10^9:ℝ) * (2*PhiC+3) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hCpos, sq_nonneg (2*PhiC+1)]
    have h2 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := hnK15
    have h3 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    linarith only [h1, h2, h3]
  have hstep : 1 - (8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3)
        - ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
        - (-(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
            + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
            /(((nmin p + 1 : ℕ)):ℝ)^2
      ≤ (Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹ := by
    have h1 := (abs_le.mp hthird).2
    rw [div_mul_cancel₀ _ (ne_of_gt hNpos)] at h1
    linarith only [h1, hge]
  have hlin := exp_threshold_linear ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hPS := PhiS_second_order_at_log2 ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hD := SThird_D_abs_le ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hu' : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) = Real.log 2 + w' := by rw [hwdef']; ring
  have hwabsG : |w'| ≤ (2*PhiC+3)/((nmin p + 1 : ℕ):ℝ) := hwabs'
  have hPSu : PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ 6 - 26*w' + 10^16*w'^2 := by
    have h := (abs_le.mp hPS).2
    rw [← hwdef'] at h
    linarith only [h]
  have hS := Op56.Op56.uPhiS_le ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ((2*PhiC+3)/((nmin p + 1 : ℕ):ℝ)) w'
    (by positivity) hq' hwabsG hu2 hu' hPSu
  have hexp : (Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹ - 1
      ≤ -2*w' + 500*w'^2 := by
    have h := (abs_le.mp hlin).2
    rw [← hwdef'] at h
    linarith only [h]
  have hDup : -(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ≤ 4*10^10 :=
    (abs_le.mp hD).2
  have hX : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ 3/((nmin p + 1 : ℕ):ℝ) := by
    have h1 : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ≤ 5 := hS
    have h2 : (2:ℝ) * (((nmin p + 1 : ℕ)):ℝ) > 0 := by positivity
    have h3 : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
        = (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))/(2*(((nmin p + 1 : ℕ)):ℝ)) := by
      rw [div_mul_eq_mul_div]
    rw [h3]
    rw [div_le_div_iff₀ h2 (by positivity : (0:ℝ) < ((nmin p + 1 : ℕ):ℝ))]
    have h4 : (3:ℝ) * 2 = 6 := by norm_num
    nlinarith only [h1, h4]
  have hww : w ≤ w' + 1/(nmin p:ℝ) := by
    rw [hwdef, hwdef']
    exact le_add_of_nonneg_right (by positivity)
  have hE' : (8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3) ≤ 10^12/(((nmin p + 1 : ℕ):ℝ)^2) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^3)
      (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^2)]
    have hb : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 := by norm_num
    have hn1'' : (1:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := hN1
    have hbig : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 * (((nmin p + 1 : ℕ)):ℝ) :=
      le_trans hb (by nlinarith only [hn1''])
    have hcube : (((nmin p + 1 : ℕ)):ℝ)^3 = (((nmin p + 1 : ℕ)):ℝ) * (((nmin p + 1 : ℕ)):ℝ)^2 := by ring
    rw [hcube]
    have hmul := mul_le_mul_of_nonneg_right hbig (sq_nonneg (((nmin p + 1 : ℕ)):ℝ))
    have heq : (10^12 * (((nmin p + 1 : ℕ)):ℝ)) * (((nmin p + 1 : ℕ)):ℝ)^2
        = 10^12 * ((((nmin p + 1 : ℕ)):ℝ) * (((nmin p + 1 : ℕ)):ℝ)^2) := by ring
    linarith only [hmul, heq.le, heq.ge]
  have hstep' := Op56.Op56.stage2_upper_exp (nmin p + 1) (by omega) w'
    ((Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹)
    (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
    (-(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
    ((8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3)) hX hDup hE' hexp hstep
  have hbridge : -(3:ℝ) / (nmin p:ℝ) - 10^15/((nmin p:ℝ)^2)
      < -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 10^15/((((nmin p + 1 : ℕ)):ℝ)^2) := by
    have h1 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    have h2 : (0:ℝ) < (nmin p:ℝ) := hnR
    have h3 : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := hNpos
    have h1s : (nmin p:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    have h4 : (10^15:ℝ)/((((nmin p + 1 : ℕ)):ℝ)^2) < 10^15/((nmin p:ℝ)^2) := by
      rw [div_lt_div_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^2)
        (by positivity : (0:ℝ) < ((nmin p:ℝ)^2))]
      nlinarith only [h1s, hnR]
    have h5 : (3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) < 3/(nmin p:ℝ) := by
      rw [div_lt_div_iff₀ h3 h2]
      nlinarith only [h1s]
    have e1 : -((3:ℝ)/(nmin p:ℝ)) = -(3:ℝ)/(nmin p:ℝ) := by ring
    have e2 : -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) = -(3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) := by ring
    linarith only [h4, h5, e1, e2]
  have hstep'' : -(3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - 10^15/((((nmin p + 1 : ℕ)):ℝ)^2)
      < -2*w' + 500*w'^2 := by
    have e : -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) = -(3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) := by ring
    linarith only [hstep', e]
  exact stage2_upper_arith2 (nmin p + 1) (by omega) (2*PhiC+3)
    (by linarith only [hCpos]) (Op56.nmin_K_bounds p hp hn hnK) w' w' (Op56.nmin_hwK' p hp hn hlarge hnK)
    hstep'' (le_add_of_nonneg_right (by positivity))



lemma nmin_w_lower2x_p (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    -(2/(nmin p:ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2 := by
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hlow := Op56.Op56.nmin_window_low p hp hn hlarge hnK
  have hn1e19 : (10^19:ℝ) ≤ (nmin p:ℝ) := by
    have hC : (1:ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith only [sq_nonneg (2*PhiC+1)]
    have h1 : (10^40:ℝ) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by nlinarith only [hC]
    linarith only [hnK, h1]
  have hmain : -(2/(nmin p:ℝ))
      ≤ 3*Real.log 2/(2*(nmin p:ℝ)) - 10^19/((nmin p:ℝ)^2) := by
    have he : 3*Real.log 2/(2*(nmin p:ℝ)) - 10^19/((nmin p:ℝ)^2)
        = (3*Real.log 2/2 * (nmin p:ℝ) - 10^19)/((nmin p:ℝ)^2) := by
      field_simp
    rw [he]
    rw [le_div_iff₀ (by positivity : (0:ℝ) < ((nmin p:ℝ)^2))]
    have hl2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num : (1:ℝ) < 2)
    have hid : -(2/(nmin p:ℝ)) * ((nmin p:ℝ)^2) = -2 * (nmin p:ℝ) := by field_simp
    nlinarith only [hn1e19, hnR, hl2, hid]
  have hmain2 : Real.log 2 - 2/(nmin p:ℝ)
      ≤ Real.log 2 + 3*Real.log 2/(2*(nmin p:ℝ)) - 10^19/((nmin p:ℝ)^2) := by
    have e : Real.log 2 - 2/(nmin p:ℝ) = Real.log 2 + (-(2/(nmin p:ℝ))) := by ring
    rw [e]
    linarith only [hmain]
  linarith only [hlow, hmain2]

lemma nmin_window_high (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
      < Real.log 2 + 3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ)) + 10^19/((((nmin p + 1 : ℕ)):ℝ)^2) := by
  by_contra hcon
  push_neg at hcon
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hNpos : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by positivity
  have hp2 : 2 ≤ p := by omega
  have hu2 : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ 1 := by
    rw [div_le_one hNpos]
    have h1 := nmin_ge_p p hp
    have h2 : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast h1
    push_cast
    linarith only [h2]
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) := by
    rw [le_div_iff₀ hNpos]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(p:ℝ) := by
      exact_mod_cast (by omega : nmin p + 1 ≤ 2*p)
    have h4 := mul_le_mul_of_nonneg_left h3 (by norm_num : (0:ℝ) ≤ 1/2)
    linarith only [h4]
  have hwabs : |(p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2| ≤ 4/(((nmin p + 1 : ℕ)):ℝ) := by
    refine abs_le.mpr ⟨?_, ?_⟩
    · have h2 := Op56.Op56.nmin_w_lower2x_p p hp hn hlarge hnK
      have hle : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) := by
        rw [div_le_div_iff₀ hNpos hnR]
        have h3 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
        have hp' : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (nmin_ge_p p hp)
        nlinarith only [h3, hp']
      have hA : (p:ℝ)/(nmin p :ℝ) - Real.log 2 ≥ -(2/(nmin p:ℝ)) := h2
      have hB : -(4/(((nmin p + 1 : ℕ)):ℝ)) ≤ -(2/(nmin p:ℝ)) - 1/(((nmin p + 1 : ℕ)):ℝ) := by
        have h3 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
        have e : -(2/(nmin p:ℝ)) - 1/(((nmin p + 1 : ℕ)):ℝ)
            = (-(2 * (((nmin p + 1 : ℕ)):ℝ)) - (nmin p:ℝ))/((nmin p:ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
          field_simp
        rw [e]
        rw [le_div_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)))]
        have hid2 : -(4/(((nmin p + 1 : ℕ)):ℝ)) * ((nmin p:ℝ) * (((nmin p + 1 : ℕ)):ℝ))
            = -4 * (nmin p:ℝ) := by field_simp
        have hn2 : (2:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 2 ≤ nmin p)
        have hn3 : (((nmin p + 1 : ℕ)):ℝ) ≤ (nmin p:ℝ) + 1 := by push_cast; linarith only [hnR]
        nlinarith only [h3, hnR, hNpos, hid2, hn2, hn3]
      have hC : (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2
          ≥ (p:ℝ)/(nmin p :ℝ) - Real.log 2 - 1/(((nmin p + 1 : ℕ)):ℝ) := by
        have hq : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) ≤ 1/(((nmin p + 1 : ℕ)):ℝ) := by
          have hp' : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (nmin_ge_p p hp)
          have h2 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
              = (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
            push_cast
            field_simp
            ring
          rw [h2]
          rw [div_le_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)))]
          have hid : (1/(((nmin p + 1 : ℕ)):ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) = (nmin p :ℝ) := by
            field_simp
          linarith only [hp', hid]
        linarith only [hq]
      have e4 : -(4/(((nmin p + 1 : ℕ)):ℝ)) = -4/(((nmin p + 1 : ℕ)):ℝ) := by ring
      linarith only [hA, hB, hC, e4]
    · exact Op56.Op56.nmin_upper_sharp_p p hp hn hlarge hnK
  have hwin := Phi_window_high ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) (nmin p + 1) hu1 hu2 (by omega) hwabs hcon
  rw [div_mul_cancel₀ _ (ne_of_gt hNpos)] at hwin
  have hge := nmin_Phi_ge p hp2
  linarith only [hwin, hge]

lemma uPhiS_sharp (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2) :
    |u * PhiS u - 6*Real.log 2| ≤ 10^18 * q := by
  have hwq : w^2 ≤ q^2 := sq_le_sq' (abs_le.mp hw).1 (abs_le.mp hw).2
  have hwl : -q ≤ w := (abs_le.mp hw).1
  have hwr : w ≤ q := (abs_le.mp hw).2
  have h6 : Real.log 2 ≤ 1 := log_two_le_one
  have h6' : 0 < Real.log 2 := Real.log_pos (by norm_num : (1:ℝ) < 2)
  have hq1 : q ≤ 1 := by linarith only [hq]
  have he : |PhiS u - (6 - 26*w)| ≤ 10^16 * w^2 := by
    have h : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2 := hPS
    rwa [show PhiS u - 6 + 26*w = PhiS u - (6 - 26*w) by ring] at h
  have hdec : u * PhiS u - 6*Real.log 2
      = (w*(6 - 26*Real.log 2) - 26*w^2) + (Real.log 2 + w)*(PhiS u - (6 - 26*w)) := by
    rw [hu]; ring
  rw [hdec]
  have hb1 : |w*(6 - 26*Real.log 2) - 26*w^2| ≤ 3*10^17 * q := by
    have h1 : |w*(6 - 26*Real.log 2)| ≤ 40 * q := by
      rw [abs_mul]
      have h8 : |Real.log 2| ≤ 1 := by rw [abs_of_pos h6']; exact h6
      have h2 : |6 - 26*Real.log 2| ≤ 40 := by
        have h9 : |26*Real.log 2| = 26 * |Real.log 2| := by rw [abs_mul]; norm_num
        have h10 := abs_sub (6:ℝ) (26*Real.log 2)
        rw [h9] at h10
        have h11 : |(6:ℝ)| = 6 := by norm_num
        rw [h11] at h10
        linarith only [h10, h8]
      nlinarith only [h2, hw, abs_nonneg w, hq0]
    have h3 : |26*w^2| ≤ 26 * q^2 := by
      rw [abs_of_nonneg (by positivity : (0:ℝ) ≤ 26*w^2)]
      nlinarith only [hwq]
    have h4 : 26 * q^2 ≤ 10^17 * q := by
      have hq' : 26 * q ≤ 26 * (1/10^9) := by nlinarith only [hq0, hq]
      have hq'' : (26:ℝ) * (1/10^9) ≤ 10^17 := by norm_num
      nlinarith only [hq0, hq', hq'', hq]
    have h5 : |w*(6 - 26*Real.log 2) - 26*w^2|
        ≤ |w*(6 - 26*Real.log 2)| + |26*w^2| := by
      have := abs_sub (w*(6 - 26*Real.log 2)) (26*w^2)
      simpa using this
    have h6 : 40*q + 26*q^2 ≤ 3*10^17 * q := by nlinarith only [hq0, hq, h4]
    linarith only [h5, h1, h3, h6]
  have hb2 : |(Real.log 2 + w)*(PhiS u - (6 - 26*w))| ≤ 10^17 * q := by
    rw [abs_mul]
    have h8 : |Real.log 2| ≤ 1 := by rw [abs_of_pos h6']; exact h6
    have h1 : |Real.log 2 + w| ≤ 2 := by
      have h9 := abs_add_le (Real.log 2) w
      linarith only [h9, h8, hw, hq1]
    have h2 : |PhiS u - (6 - 26*w)| ≤ 10^16 * q^2 := by linarith only [he, hwq]
    have h3 : (0:ℝ) ≤ 10^16 * q^2 := by positivity
    have h4 : 2 * (10^16 * q^2) ≤ 10^17 * q := by
      have hq' : (2*10^16:ℝ) * q ≤ 2*10^16 * (1/10^9) := by nlinarith only [hq0, hq]
      have hq'' : (2*10^16:ℝ) * (1/10^9) ≤ 10^17 := by norm_num
      nlinarith only [hq0, hq', hq'', hq]
    nlinarith only [h1, h2, h3, h4, abs_nonneg (Real.log 2 + w), abs_nonneg (PhiS u - (6 - 26*w))]
  have hsum : |(w*(6 - 26*Real.log 2) - 26*w^2) + (Real.log 2 + w)*(PhiS u - (6 - 26*w))|
      ≤ |w*(6 - 26*Real.log 2) - 26*w^2| + |(Real.log 2 + w)*(PhiS u - (6 - 26*w))| :=
    abs_add_le _ _
  have hfin : 3*10^17 * q + 10^17 * q ≤ 10^18 * q := by nlinarith only [hq0]
  linarith only [hsum, hb1, hb2, hfin]


/-- The lower mirror of `uPhiS_sharp`: `u·ΦS(u) ≥ 6log2 − 10¹⁸q`. -/
lemma uPhiS_lower_sharp (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2) :
    6*Real.log 2 - 10^18 * q ≤ u * PhiS u := by
  have h := uPhiS_sharp u q w hq0 hq hw hu hPS
  linarith only [(abs_le.mp h).1]

lemma stage2_lower_sharp_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (3*Real.log 2)/(n:ℝ) - 10^18/((n:ℝ)^2) ≤ X)
    (hD : -(4*10^10) ≤ D)
    (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -((3*Real.log 2)/(n:ℝ)) + (4*10^10 + 10^12 + 10^18)/((n:ℝ)^2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : -((4*10^10)/((n:ℝ)^2)) ≤ D/((n:ℝ)^2) := by
    have h1a : -((4*10^10:ℝ)) ≤ D := by linarith only [hD]
    have h1b : -((4*10^10:ℝ))/((n:ℝ)^2) = -((4*10^10)/((n:ℝ)^2)) := by rw [neg_div]
    rw [← h1b]
    exact div_le_div_of_nonneg_right h1a (by positivity)
  have h2 : -X ≤ -((3*Real.log 2)/(n:ℝ)) + 10^18/((n:ℝ)^2) := by linarith only [hX]
  have h3 : (4*10^10:ℝ)/((n:ℝ)^2) + 10^12/((n:ℝ)^2) + 10^18/((n:ℝ)^2)
      = (4*10^10 + 10^12 + 10^18)/((n:ℝ)^2) := by ring
  have h4 : Y < 1 - X - D/((n:ℝ)^2) + E := by linarith only [hthird]
  have h5 : -2*w - 500*w^2 < -X - D/((n:ℝ)^2) + E := by linarith only [hexp, h4]
  have h6 : -X - D/((n:ℝ)^2) + E
      ≤ -((3*Real.log 2)/(n:ℝ)) + (4*10^10 + 10^12 + 10^18)/((n:ℝ)^2) := by
    linarith only [h2, h1, hE, h3.le, h3.ge]
  linarith only [h5, h6]

lemma stage2_lower_sharp_exp2 (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (3*Real.log 2)/(n:ℝ) - K/((n:ℝ)^2) ≤ X)
    (hD : -(4*10^10) ≤ D)
    (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -((3*Real.log 2)/(n:ℝ)) + (4*10^10 + 10^12 + K)/((n:ℝ)^2) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : -((4*10^10)/((n:ℝ)^2)) ≤ D/((n:ℝ)^2) := by
    have h1a : -((4*10^10:ℝ)) ≤ D := by linarith only [hD]
    have h1b : -((4*10^10:ℝ))/((n:ℝ)^2) = -((4*10^10)/((n:ℝ)^2)) := by rw [neg_div]
    rw [← h1b]
    exact div_le_div_of_nonneg_right h1a (by positivity)
  have h2 : -X ≤ -((3*Real.log 2)/(n:ℝ)) + K/((n:ℝ)^2) := by linarith only [hX]
  have h3 : (4*10^10:ℝ)/((n:ℝ)^2) + 10^12/((n:ℝ)^2) + K/((n:ℝ)^2)
      = (4*10^10 + 10^12 + K)/((n:ℝ)^2) := by ring
  have h4 : Y < 1 - X - D/((n:ℝ)^2) + E := by linarith only [hthird]
  have h5 : -2*w - 500*w^2 < -X - D/((n:ℝ)^2) + E := by linarith only [hexp, h4]
  have h6 : -X - D/((n:ℝ)^2) + E
      ≤ -((3*Real.log 2)/(n:ℝ)) + (4*10^10 + 10^12 + K)/((n:ℝ)^2) := by
    linarith only [h2, h1, hE, h3.le, h3.ge]
  linarith only [h5, h6]

lemma w_lower_from_exp (n : ℕ) (w K C : ℝ) (hn : 1 ≤ n)
    (hw2 : w^2 ≤ (K/(n:ℝ))^2)
    (h : -2*w - 500*w^2 < -((3*Real.log 2)/(n:ℝ)) + C/((n:ℝ)^2)) :
    3*Real.log 2/(2*(n:ℝ)) - (C + 500*K^2)/(2*((n:ℝ)^2)) ≤ w := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h500 : 500*w^2 ≤ 500*K^2/((n:ℝ)^2) := by
    have h1 : 500*w^2 ≤ 500*(K/(n:ℝ))^2 := mul_le_mul_of_nonneg_left hw2 (by norm_num)
    have h2 : 500*(K/(n:ℝ))^2 = 500*K^2/((n:ℝ)^2) := by field_simp
    linarith only [h1, h2.le, h2.ge]
  have heq : 500*K^2/((n:ℝ)^2) + C/((n:ℝ)^2) = (C + 500*K^2)/((n:ℝ)^2) := by ring
  have hkey : 2*w > 3*Real.log 2/(n:ℝ) - (C + 500*K^2)/((n:ℝ)^2) := by linarith only [h, h500, heq.le, heq.ge]
  have hfin : 3*Real.log 2/(2*(n:ℝ)) - (C + 500*K^2)/(2*((n:ℝ)^2))
      = (3*Real.log 2/(n:ℝ) - (C + 500*K^2)/((n:ℝ)^2))/2 := by
    field_simp
  linarith only [hkey, hfin.le, hfin.ge]

lemma stage2_lower_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    3*Real.log 2/(2*(nmin p:ℝ)) - (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)/(2*((nmin p:ℝ)^2))
      ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2 := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
  have hX0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := by positivity
  have hnK15 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hX0]
    linarith only [hnK, h1]
  have hstage1 := nmin_w_stage1 p hp hn hlarge hnK15
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      nlinarith only [hnK15, this])
  set w : ℝ := (p:ℝ)/(nmin p :ℝ) - Real.log 2 with hwdef
  have hu : (p:ℝ)/(nmin p :ℝ) = Real.log 2 + w := by rw [hwdef]; ring
  have hwabs : |w| ≤ (2*PhiC+1)/(nmin p:ℝ) := by rw [hwdef]; exact hstage1
  have hw : w^2 ≤ ((2*PhiC+1)/(nmin p:ℝ))^2 :=
    sq_le_sq' (abs_le.mp hwabs).1 (abs_le.mp hwabs).2
  have hq0 : (0:ℝ) ≤ (2*PhiC+1)/(nmin p:ℝ) := by positivity
  have hq1 : (2*PhiC+1)/(nmin p:ℝ) ≤ 1/10^9 := by
    rw [div_le_iff₀ hnR]
    have h1d : (0:ℝ) ≤ 2*PhiC+1 := by linarith only [hCpos]
    have h1e : (0:ℝ) ≤ 1/10^9 * (nmin p:ℝ) := by positivity
    have h1a : (2*PhiC+1)^2 ≤ (1/10^9 * (nmin p:ℝ))^2 := by
      have h1b : (2*PhiC+1)^2 ≤ (nmin p:ℝ)/10^40 := by
        nlinarith only [hnK, sq_nonneg (2*PhiC+1), hX0]
      have h1c : (nmin p:ℝ)/10^40 ≤ (1/10^9 * (nmin p:ℝ))^2 := by
        have h3 : (1/10^9 * (nmin p:ℝ))^2 = (nmin p:ℝ)^2/10^18 := by ring
        rw [h3, div_le_div_iff₀ (by norm_num : (0:ℝ) < 10^40) (by norm_num : (0:ℝ) < 10^18)]
        nlinarith only [hnR, hn1]
      linarith only [h1b, h1c]
    have h1f := sq_le_sq.mp h1a
    rw [abs_of_nonneg h1d, abs_of_nonneg h1e] at h1f
    linarith only [h1f]
  have hu2 : (p:ℝ)/(nmin p :ℝ) ≤ 1 := by
    rw [div_le_one hnR]
    have h1 := nmin_ge_p p hp
    exact_mod_cast h1
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/(nmin p :ℝ) := by
    rw [le_div_iff₀ hnR]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (nmin p :ℝ) ≤ 2*(p:ℝ) := by exact_mod_cast (le_of_lt h2)
    linarith
  have sb := split_bounds' (by omega : 100000000 ≤ nmin p)
  have hthird := Phi_third_order hu1 hu2 hn sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hlt := nmin_Phi_lt p hp2 (by omega : 1 ≤ nmin p)
  have hlin := exp_threshold_linear ((p:ℝ)/(nmin p:ℝ)) hu1 hu2
  have hPS := PhiS_second_order_at_log2 ((p:ℝ)/(nmin p:ℝ)) hu1 hu2
  have hD := SThird_D_abs_le ((p:ℝ)/(nmin p:ℝ)) hu1 hu2
  have hPSb : 6 - 26*w - 10^16*w^2 ≤ PhiS ((p:ℝ)/(nmin p:ℝ)) := by
    have h := (abs_le.mp hPS).1
    rw [hwdef]
    linarith only [h]
  have hS := Op56.Op56.uPhiS_lower_sharp ((p:ℝ)/(nmin p:ℝ)) ((2*PhiC+1)/(nmin p:ℝ)) w hq0 hq1 hwabs hu hPS
  have hexp : -2*w - 500*w^2
      ≤ (Real.exp ((p:ℝ)/(nmin p:ℝ)) - 1)⁻¹ - 1 := by
    have h := (abs_le.mp hlin).1
    rw [hwdef]
    linarith only [h]
  have hMeq := PhiMainS_eq ((p:ℝ)/(nmin p:ℝ)) (nmin p) hu1 (by omega : 1 ≤ nmin p)
  have hD' : -(4*10^10:ℝ) ≤ -(((p:ℝ)/(nmin p:ℝ))/3)*PhiK3u ((p:ℝ)/(nmin p:ℝ))
      + (((p:ℝ)/(nmin p:ℝ))^2/8)*PhiK4u ((p:ℝ)/(nmin p:ℝ)) := (abs_le.mp hD).1
  have hthird' : (Real.exp ((p:ℝ)/(nmin p:ℝ)) - 1)⁻¹
      + ((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ))
      + (-(((p:ℝ)/(nmin p:ℝ))/3)*PhiK3u ((p:ℝ)/(nmin p:ℝ))
          + (((p:ℝ)/(nmin p:ℝ))^2/8)*PhiK4u ((p:ℝ)/(nmin p:ℝ)))/((nmin p:ℝ)^2)
      - (8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3) < 1 := by
    have h1 := (abs_le.mp hthird).1
    rw [div_mul_cancel₀ _ (ne_of_gt hnR)] at h1
    have h2 : PhiMainS ((p:ℝ)/(nmin p:ℝ)) (nmin p)
        - (8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3) ≤ Phi (p:ℝ) (nmin p) := by
      rw [hMeq]
      linarith only [h1]
    rw [hMeq] at h2
    exact lt_of_le_of_lt h2 hlt
  have hE : (8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3) ≤ 10^12/((nmin p:ℝ)^2) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((nmin p:ℝ))^3)
      (by positivity : (0:ℝ) < ((nmin p:ℝ))^2)]
    have hb : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 := by norm_num
    have hbig : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 * (nmin p:ℝ) :=
      le_trans hb (by nlinarith only [hn1])
    have hcube : ((nmin p:ℝ))^3 = (nmin p:ℝ) * ((nmin p:ℝ))^2 := by ring
    rw [hcube]
    have hmul := mul_le_mul_of_nonneg_right hbig (sq_nonneg ((nmin p:ℝ)))
    have heq : (10^12 * (nmin p:ℝ)) * ((nmin p:ℝ))^2
        = 10^12 * ((nmin p:ℝ) * ((nmin p:ℝ))^2) := by ring
    linarith only [hmul, heq.le, heq.ge]
  have hX : (3*Real.log 2)/(nmin p:ℝ) - (10^18*(2*PhiC+1)/2)/((nmin p:ℝ)^2)
      ≤ ((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ)) := by
    have hnR2 : (0:ℝ) < 2*(nmin p:ℝ) := by positivity
    have h1 : (6 * Real.log 2 - 10^18 * ((2*PhiC+1)/(nmin p:ℝ)))/(2*(nmin p:ℝ))
        ≤ ((p:ℝ)/(nmin p:ℝ) * PhiS ((p:ℝ)/(nmin p:ℝ)))/(2*(nmin p:ℝ)) :=
      div_le_div_of_nonneg_right hS hnR2.le
    have e1 : (6 * Real.log 2 - 10^18 * ((2*PhiC+1)/(nmin p:ℝ)))/(2*(nmin p:ℝ))
        = (3*Real.log 2)/(nmin p:ℝ) - (10^18*(2*PhiC+1)/2)/((nmin p:ℝ)^2) := by
      field_simp
      push_cast
      ring
    have e2 : ((p:ℝ)/(nmin p:ℝ) * PhiS ((p:ℝ)/(nmin p:ℝ)))/(2*(nmin p:ℝ))
        = ((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ)) := by
      field_simp
    linarith only [h1, e1, e2]
  have hstep := Op56.Op56.stage2_lower_sharp_exp2 (nmin p) (10^18*(2*PhiC+1)/2) (by omega) w
    ((Real.exp ((p:ℝ)/(nmin p:ℝ)) - 1)⁻¹)
    (((p:ℝ)/(nmin p:ℝ))/(2*(nmin p:ℝ))*PhiS ((p:ℝ)/(nmin p:ℝ)))
    (-(((p:ℝ)/(nmin p:ℝ))/3)*PhiK3u ((p:ℝ)/(nmin p:ℝ))
      + (((p:ℝ)/(nmin p:ℝ))^2/8)*PhiK4u ((p:ℝ)/(nmin p:ℝ)))
    ((8*10^10 + 2*(4*10^10 + 5) + 7)/((nmin p:ℝ)^3)) hX hD' hE hexp hthird'
  exact Op56.Op56.w_lower_from_exp (nmin p) w (2*PhiC+1) (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2)
    (by omega) hw hstep
lemma stage2_upper_sharp_exp (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : X ≤ (3*Real.log 2)/(n:ℝ) + K/(n:ℝ))
    (hD : D ≤ 4*10^10)
    (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y) :
    -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12 + 1)/((n:ℝ)^2) - K/(n:ℝ)
      < -2*w + 500*w^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h1 : D/((n:ℝ)^2) ≤ (4*10^10)/((n:ℝ)^2) :=
    div_le_div_of_nonneg_right hD (by positivity)
  have h5 : -2*w + 500*w^2 ≥ -E - X - D/((n:ℝ)^2) := by linarith only [hexp, hthird]
  have h6 : -E - X - D/((n:ℝ)^2)
      ≥ -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12)/((n:ℝ)^2) - K/(n:ℝ) := by
    have h6a : -X ≥ -((3*Real.log 2)/(n:ℝ)) - K/(n:ℝ) := by linarith only [hX]
    have h6b : -E ≥ -(10^12/((n:ℝ)^2)) := neg_le_neg hE
    have hD2 : (-D)/((n:ℝ)^2) = -(D/((n:ℝ)^2)) := by field_simp
    have h6c : -(D/((n:ℝ)^2)) ≥ -((4*10^10)/((n:ℝ)^2)) := by
      have h := neg_le_neg h1
      linarith only [h, hD2]
    have hsum : (-E) + (-X) + (-(D/((n:ℝ)^2)))
        ≥ (-(10^12/((n:ℝ)^2))) + (-((3*Real.log 2)/(n:ℝ)) - K/(n:ℝ)) + (-((4*10^10)/((n:ℝ)^2))) :=
      add_le_add (add_le_add h6b h6a) h6c
    have hs : (-(10^12/((n:ℝ)^2))) + (-((3*Real.log 2)/(n:ℝ)) - K/(n:ℝ)) + (-((4*10^10)/((n:ℝ)^2)))
        = -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12)/((n:ℝ)^2) - K/(n:ℝ) := by
      field_simp
      ring
    linarith only [hsum, hs]
  have h7 : (4*10^10 + 10^12)/((n:ℝ)^2) < (4*10^10 + 10^12 + 1)/((n:ℝ)^2) := by
    apply div_lt_div_of_pos_right _ (by positivity)
    linarith only []
  have h8 : -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12)/((n:ℝ)^2) - K/(n:ℝ)
      > -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12 + 1)/((n:ℝ)^2) - K/(n:ℝ) := by linarith only [h7]
  exact lt_of_lt_le_le h8 h6 h5

lemma w_upper_from_exp (n : ℕ) (w K C : ℝ) (hn : 1 ≤ n)
    (hw2 : w^2 ≤ (K/(n:ℝ))^2)
    (h : -((3*Real.log 2)/(n:ℝ)) - C/((n:ℝ)^2) < -2*w + 500*w^2) :
    w < 3*Real.log 2/(2*(n:ℝ)) + (C + 500*K^2)/(2*((n:ℝ)^2)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h500 : 500*w^2 ≤ 500*K^2/((n:ℝ)^2) := by
    have h1 : 500*w^2 ≤ 500*(K/(n:ℝ))^2 := mul_le_mul_of_nonneg_left hw2 (by norm_num)
    have h2 : 500*(K/(n:ℝ))^2 = 500*K^2/((n:ℝ)^2) := by field_simp
    linarith only [h1, h2.le, h2.ge]
  have heq : 500*K^2/((n:ℝ)^2) + C/((n:ℝ)^2) = (C + 500*K^2)/((n:ℝ)^2) := by ring
  have hkey : 2*w < 3*Real.log 2/(n:ℝ) + (C + 500*K^2)/((n:ℝ)^2) := by
    linarith only [h, h500, heq.le, heq.ge]
  have hfin : 3*Real.log 2/(2*(n:ℝ)) + (C + 500*K^2)/(2*((n:ℝ)^2))
      = (3*Real.log 2/(n:ℝ) + (C + 500*K^2)/((n:ℝ)^2))/2 := by
    field_simp
  linarith only [hkey, hfin.le, hfin.ge]

lemma stage2_upper_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2
      ≤ 3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ))
        + (4*10^10 + 10^12 + 1 + (10^18*(2*PhiC+2)/2)*(((nmin p + 1 : ℕ)):ℝ)
            + 500*(4*PhiC+3)^2)/(2*((((nmin p + 1 : ℕ)):ℝ)^2)) := by
  have hp2 : 2 ≤ p := by omega
  have hnR : (0:ℝ) < (nmin p :ℝ) := by positivity
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
  have hN1 : (1:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) :=
    by exact_mod_cast (by omega : 1 ≤ nmin p + 1)
  have hNpos : (0:ℝ) < ((nmin p + 1 : ℕ):ℝ) := by linarith only [hN1]
  have hX0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := by positivity
  have hnK15 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hX0]
    linarith only [hnK, h1]
  have hnK15' : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ ((nmin p + 1 : ℕ):ℝ) := by
    have h2 : (nmin p:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) := by push_cast; linarith only [hnR]
    linarith only [hnK15, h2]
  have hstage1 := nmin_w_stage1 p hp hn hlarge
    (by
      have h0 : (0:ℝ) ≤ (2*PhiC+1)^2 + 1 := hX0
      have h1 : (10^15:ℝ) * ((2*PhiC+1)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
        nlinarith only [h0]
      linarith only [hnK, h1])
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      have h1 : (10^15:ℝ) * ((2*PhiC+2)) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
        nlinarith only [this]
      linarith only [hnK15, h1])
  have hu2 : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ 1 := by
    rw [div_le_one hNpos]
    have h1 := nmin_ge_p p hp
    have h2 : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast h1
    have h3 : (nmin p:ℝ) ≤ ((nmin p + 1 : ℕ):ℝ) := by push_cast; linarith only [hnR]
    linarith only [h2, h3, hNpos]
  have hu1 : (1/2:ℝ) ≤ (p:ℝ)/((nmin p + 1 : ℕ):ℝ) := by
    rw [le_div_iff₀ hNpos]
    have h2 := nmin_lt_two_p p hp2 hlarge
    have h3 : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(p:ℝ) := by
      exact_mod_cast (by omega : nmin p + 1 ≤ 2*p)
    have h4 := mul_le_mul_of_nonneg_left h3 (by norm_num : (0:ℝ) ≤ 1/2)
    linarith only [h4]
  have sb := split_bounds' (by omega : 100000000 ≤ nmin p + 1)
  have hthird := Phi_third_order hu1 hu2 (by omega : 2000000000 ≤ nmin p + 1) sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  have hge := nmin_Phi_ge p hp2
  have hMeq := PhiMainS_eq ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) (nmin p + 1) hu1 (by omega : 1 ≤ nmin p + 1)
  set w : ℝ := (p:ℝ)/(nmin p :ℝ) - Real.log 2 with hwdef
  set w' : ℝ := (p:ℝ)/((nmin p + 1 : ℕ):ℝ) - Real.log 2 with hwdef'
  have hstage1 := nmin_w_stage1 p hp hn hlarge hnK15
    (by
      have : (2*PhiC+2 : ℝ) ≤ (2*PhiC+1)^2 + 1 := by nlinarith [hCpos]
      nlinarith only [hnK15, this])
  have hwabs : |w| ≤ (2*PhiC+1)/(nmin p:ℝ) := by rw [hwdef]; exact hstage1
  have hdiff : |(p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)| ≤ 1/(nmin p:ℝ) := by
    have hle : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) :=
      div_le_div_of_nonneg_left (by positivity) hnR (by push_cast; linarith only [hnR])
    rw [abs_of_nonpos (by linarith only [hle]), neg_sub]
    have h2 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
        = (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
      push_cast
      field_simp
      ring
    rw [h2]
    rw [div_le_iff₀ (by positivity : (0:ℝ) < ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)))]
    have hp' : (p:ℝ) ≤ (nmin p :ℝ) := by exact_mod_cast (nmin_ge_p p hp)
    have hid : (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))
        = (((nmin p + 1 : ℕ)):ℝ) := by field_simp
    have hnle : (nmin p :ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    exact calc (p:ℝ) ≤ (nmin p :ℝ) := hp'
      _ ≤ (((nmin p + 1 : ℕ)):ℝ) := hnle
      _ = (1/(nmin p :ℝ)) * ((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := hid.symm
  have hwabs' : |w'| ≤ (2*PhiC+2)/(nmin p:ℝ) := by
    have he : w' = w + ((p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)) := by
      rw [hwdef, hwdef']
      ring
    rw [he]
    calc |w + ((p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ))|
        ≤ |w| + |(p:ℝ)/((nmin p + 1 : ℕ):ℝ) - (p:ℝ)/(nmin p :ℝ)| := abs_add_le _ _
      _ ≤ (2*PhiC+1)/(nmin p:ℝ) + 1/(nmin p:ℝ) := add_le_add hwabs hdiff
      _ = (2*PhiC+2)/(nmin p:ℝ) := by ring
  have hq' : (2*PhiC+2)/(nmin p:ℝ) ≤ 1/10^9 := by
    rw [div_le_iff₀ hnR]
    have h1 : (10^9:ℝ) * (2*PhiC+2) ≤ 10^15 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hCpos, sq_nonneg (2*PhiC+1)]
    linarith only [h1, hnK15]
  have hstep : 1 - (8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3)
        - ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
        - (-(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
            + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
            /(((nmin p + 1 : ℕ)):ℝ)^2
      ≤ (Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹ := by
    have h1 := (abs_le.mp hthird).2
    rw [div_mul_cancel₀ _ (ne_of_gt hNpos)] at h1
    linarith only [h1, hge]
  have hlin := exp_threshold_linear ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hPS := PhiS_second_order_at_log2 ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hD := SThird_D_abs_le ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
  have hu' : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) = Real.log 2 + w' := by rw [hwdef']; ring
  have hwabsG : |w'| ≤ (2*PhiC+2)/(nmin p:ℝ) := hwabs'
  have hPSu : PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ 6 - 26*w' + 10^16*w'^2 := by
    have h := (abs_le.mp hPS).2
    rw [← hwdef'] at h
    linarith only [h]
  have hPS2 : |PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 6 + 26*w'| ≤ 10^16 * w'^2 := by
    have h := Op56.PhiS_second_order_at_log2 ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) hu1 hu2
    rwa [show ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - Real.log 2 = w' from by linarith only [hwdef']] at h
  have hS := Op56.Op56.uPhiS_sharp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ((2*PhiC+2)/(nmin p:ℝ)) w'
    (by positivity) hq' hwabsG hu' hPS2
  have hSu : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) * PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ 6*Real.log 2 + 10^18*((2*PhiC+2)/(nmin p:ℝ)) := by
    have h := (abs_le.mp hS).2
    linarith only [h]
  have hexp : (Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹ - 1
      ≤ -2*w' + 500*w'^2 := by
    have h := (abs_le.mp hlin).2
    rw [← hwdef'] at h
    linarith only [h]
  have hDup : -(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) ≤ 4*10^10 :=
    (abs_le.mp hD).2
  have hX : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      ≤ (3*Real.log 2)/(((nmin p + 1 : ℕ)):ℝ) + (10^18*(2*PhiC+2)/2)/(((nmin p + 1 : ℕ)):ℝ) := by
    have h2 : (2:ℝ) * (((nmin p + 1 : ℕ)):ℝ) > 0 := by positivity
    have h3 : ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ)):ℝ)
        = (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ)):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ)) := by
      rw [div_mul_eq_mul_div]
    have h4 : ((6*Real.log 2 + 10^18*((2*PhiC+2)/(nmin p:ℝ)))/(2*(((nmin p + 1 : ℕ)):ℝ)))
        ≤ (3*Real.log 2)/(((nmin p + 1 : ℕ)):ℝ)
          + (10^18*(2*PhiC+2)/2)/(((nmin p + 1 : ℕ)):ℝ) := by
      have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
      rw [div_le_iff₀ (by positivity : (0:ℝ) < 2*(((nmin p + 1 : ℕ)):ℝ))]
      push_cast
      field_simp
      nlinarith only [hn1, hNpos, hCpos]
    rw [h3]
    have h5 : (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ)):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))
        ≤ (6*Real.log 2 + 10^18*((2*PhiC+2)/(nmin p:ℝ)))/(2*(((nmin p + 1 : ℕ)):ℝ)) :=
      div_le_div_of_nonneg_right hSu h2.le
    linarith only [h5, h4]
  have hww : w ≤ w' + 1/(nmin p:ℝ) := by
    have h5 : (p:ℝ)/(nmin p :ℝ) - (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ 1/(nmin p:ℝ) := by
      have h := hdiff
      rw [abs_of_nonpos, neg_sub] at h
      · exact h
      · have hle : (p:ℝ)/((nmin p + 1 : ℕ):ℝ) ≤ (p:ℝ)/(nmin p :ℝ) :=
          div_le_div_of_nonneg_left (by positivity) hnR (by push_cast; linarith only [hnR])
        linarith only [hle]
    rw [hwdef, hwdef']
    linarith only [h5]
  have hE' : (8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3) ≤ 10^12/(((nmin p + 1 : ℕ):ℝ)^2) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^3)
      (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^2)]
    have hb : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 := by norm_num
    have hn1'' : (1:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := hN1
    have hbig : (8*10^10 + 2*(4*10^10 + 5) + 7 : ℝ) ≤ 10^12 * (((nmin p + 1 : ℕ)):ℝ) :=
      le_trans hb (by nlinarith only [hn1''])
    have hcube : (((nmin p + 1 : ℕ)):ℝ)^3 = (((nmin p + 1 : ℕ)):ℝ) * (((nmin p + 1 : ℕ)):ℝ)^2 := by ring
    rw [hcube]
    have hmul := mul_le_mul_of_nonneg_right hbig (sq_nonneg (((nmin p + 1 : ℕ)):ℝ))
    have heq : (10^12 * (((nmin p + 1 : ℕ)):ℝ)) * (((nmin p + 1 : ℕ)):ℝ)^2
        = 10^12 * ((((nmin p + 1 : ℕ)):ℝ) * (((nmin p + 1 : ℕ)):ℝ)^2) := by ring
    linarith only [hmul, heq.le, heq.ge]
  have hstep' := Op56.stage2_upper_sharp_exp (nmin p + 1) (10^18*(2*PhiC+2)/2) (by omega) w'
    ((Real.exp ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)) - 1)⁻¹)
    (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/(2*(((nmin p + 1 : ℕ)):ℝ))*PhiS ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
    (-(((p:ℝ)/((nmin p + 1 : ℕ):ℝ))/3)*PhiK3u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ))
      + (((p:ℝ)/((nmin p + 1 : ℕ):ℝ))^2/8)*PhiK4u ((p:ℝ)/((nmin p + 1 : ℕ):ℝ)))
    ((8*10^10 + 2*(4*10^10 + 5) + 7)/(((nmin p + 1 : ℕ):ℝ)^3)) hX hDup hE' hexp hstep
  have hbridge : -(3:ℝ) / (nmin p:ℝ) - 10^15/((nmin p:ℝ)^2)
      < -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) - 10^15/((((nmin p + 1 : ℕ)):ℝ)^2) := by
    have h1 : (nmin p:ℝ) ≤ (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    have h2 : (0:ℝ) < (nmin p:ℝ) := hnR
    have h3 : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := hNpos
    have h1s : (nmin p:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by push_cast; linarith only [hnR]
    have h4 : (10^15:ℝ)/((((nmin p + 1 : ℕ)):ℝ)^2) < 10^15/((nmin p:ℝ)^2) := by
      rw [div_lt_div_iff₀ (by positivity : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ)^2)
        (by positivity : (0:ℝ) < ((nmin p:ℝ)^2))]
      nlinarith only [h1s, hnR]
    have h5 : (3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) < 3/(nmin p:ℝ) := by
      rw [div_lt_div_iff₀ h3 h2]
      nlinarith only [h1s]
    have e1 : -((3:ℝ)/(nmin p:ℝ)) = -(3:ℝ)/(nmin p:ℝ) := by ring
    have e2 : -((3:ℝ)/(((nmin p + 1 : ℕ)):ℝ)) = -(3:ℝ)/(((nmin p + 1 : ℕ)):ℝ) := by ring
    linarith only [h4, h5, e1, e2]
  have hwK : w'^2 ≤ ((2*PhiC+2)/(nmin p:ℝ))^2 :=
    sq_le_sq' (abs_le.mp hwabs').1 (abs_le.mp hwabs').2
  have hnKK : (10^15:ℝ) * ((2*PhiC+2)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^15:ℝ) * ((2*PhiC+2)^2 + 1) ≤ 10^40 * ((2*PhiC+1)^2 + 1) := by
      nlinarith only [hCpos, sq_nonneg (2*PhiC+1)]
    linarith only [hnK, h1]
  have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
  have hp'' : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (nmin_ge_p p hp)
  have hn2 : (2:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 2 ≤ nmin p)
  have hnd : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(nmin p:ℝ) := by push_cast; linarith only [hn2]
  have hwabsN : |w'| ≤ (4*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ) := by
    have he : w' = w - (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
      rw [hwdef, hwdef']; field_simp; push_cast; ring
    rw [he]
    have h2 : |(p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))| ≤ 1/(((nmin p + 1 : ℕ)):ℝ) := by
      rw [abs_of_nonneg (by positivity)]
      rw [div_le_div_iff₀ (by positivity) hNpos]
      push_cast
      nlinarith only [hp'', hnR, hNpos]
    calc |w - (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))|
        ≤ |w| + |(p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))| := abs_sub _ _
      _ ≤ (2*PhiC+1)/(nmin p:ℝ) + 1/(((nmin p + 1 : ℕ)):ℝ) := add_le_add hwabs h2
      _ ≤ (4*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ) := by
        have hb1 : (2*PhiC+1)/(nmin p:ℝ) ≤ 2*(2*PhiC+1)/(((nmin p + 1 : ℕ)):ℝ) := by
          rw [div_le_div_iff₀ hnR hNpos]
          nlinarith only [hnd, hCpos]
        have hb3 : 2*(2*PhiC+1)/(((nmin p + 1 : ℕ)):ℝ) + 1/(((nmin p + 1 : ℕ)):ℝ)
            = (4*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ) := by ring
        linarith only [hb1, hb3]
  have hwK : w'^2 ≤ ((4*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ))^2 :=
    sq_le_sq' (abs_le.mp hwabsN).1 (abs_le.mp hwabsN).2
  have hstep'' : -((3*Real.log 2)/(((nmin p + 1 : ℕ)):ℝ))
        - ((4*10^10 + 10^12 + 1) + (10^18*(2*PhiC+2)/2)*(((nmin p + 1 : ℕ)):ℝ))
          /((((nmin p + 1 : ℕ)):ℝ)^2)
        < -2*w' + 500*w'^2 := by
    have h : -((3*Real.log 2)/(((nmin p + 1 : ℕ)):ℝ))
          - ((4*10^10 + 10^12 + 1) + (10^18*(2*PhiC+2)/2)*(((nmin p + 1 : ℕ)):ℝ))
            /((((nmin p + 1 : ℕ)):ℝ)^2)
        = -((3*Real.log 2)/(((nmin p + 1 : ℕ)):ℝ))
          - (4*10^10 + 10^12 + 1)/((((nmin p + 1 : ℕ)):ℝ)^2)
          - (10^18*(2*PhiC+2)/2)/(((nmin p + 1 : ℕ)):ℝ) := by
      field_simp
      ring
    rw [h]
    exact hstep'
  exact le_of_lt (Op56.w_upper_from_exp (nmin p + 1) w' (4*PhiC+3)
    ((4*10^10 + 10^12 + 1) + (10^18*(2*PhiC+2)/2)*(((nmin p + 1 : ℕ)):ℝ))
    (by omega) hwK hstep'')

lemma nmin_wp_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ))
      - ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/(((nmin p + 1 : ℕ)):ℝ)
      ≤ (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2 := by
  have h1 := Op56.Op56.stage2_lower_sharp p hp hn hlarge hnK
  have hnR : (0:ℝ) < (nmin p:ℝ) := by positivity
  have hNpos : (0:ℝ) < (((nmin p + 1 : ℕ)):ℝ) := by positivity
  have hL : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num : (1:ℝ) < 2)
  set n := (nmin p:ℝ) with hn'
  set N := (((nmin p + 1 : ℕ)):ℝ) with hN
  have hNn : N = n + 1 := by rw [hN, hn']; push_cast; ring
  have hnR' : (0:ℝ) < n := by rw [hn']; exact hnR
  have hNpos' : (0:ℝ) < N := by rw [hN]; exact hNpos
  have hwsh := Op56.Op56.nmin_w_sharp p hp hn hlarge hnK
  rw [← hn'] at hwsh
  have h4 : Real.log 2/4 ≤ 3*Real.log 2/2 - (p:ℝ)/n := by
    have hw4 : (p:ℝ)/n - Real.log 2 ≤ 4/n := (abs_le.mp hwsh).2
    have hn16 : (16:ℝ) ≤ n * Real.log 2 := by
      rw [hn']
      have h2 : (16:ℝ) ≤ (nmin p:ℝ) * Real.log 2 := by
        have hgt := Real.log_two_gt_d9
        norm_num at hgt
        have hnR2 : (2000000000:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast hn
        nlinarith only [hnR2, hgt]
      linarith only [h2]
    have h16n : 4/n ≤ Real.log 2/4 := by
      rw [div_le_div_iff₀ hnR' (by norm_num : (0:ℝ) < 4)]
      nlinarith only [hn16, hL]
    linarith only [hw4, h16n]
  have hw' : (p:ℝ)/N - Real.log 2 = ((p:ℝ)/n - Real.log 2) - (p:ℝ)/(n*N) := by
    rw [hNn]; field_simp; ring
  have h3 : 3*Real.log 2/(2*n) = 3*Real.log 2/(2*N) + 3*Real.log 2/(2*(n*N)) := by
    rw [hNn]; field_simp
  have hnN : n ≤ N := by rw [hNn]; linarith only [hnR']
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  have hN1 : (1:ℝ) ≤ N := by rw [hN]; exact_mod_cast (by omega : 1 ≤ nmin p + 1)
  have hK1 : 4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2
      ≤ (10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2) * N := by
    nlinarith only [hCpos, sq_nonneg (2*PhiC+1), hNpos', hN1]
  rw [hw']
  rw [h3] at h1
  have hCpos' : (0:ℝ) < PhiC := PhiC_pos
  have hK1C : 4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2
      ≤ 10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2 := by
    nlinarith only [hCpos', sq_nonneg (2*PhiC+1)]
  have hCbig : (10^20:ℝ) ≤ (10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
      + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2) := by
    nlinarith only [hCpos', sq_nonneg (2*PhiC+1)]
  have hCK' : (2:ℝ) ≤ (10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
      + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2) := by
    linarith only [hCbig]
  have h2n : (2:ℝ) ≤ n := by rw [hn']; exact_mod_cast (by omega : 2 ≤ nmin p)
  have hn2 : (1:ℝ) ≤ n^2 := by nlinarith only [h2n]
  have hCK1 : (1:ℝ) ≤ (10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
      + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2) := by
    nlinarith only [hCK']
  have hP : (1:ℝ) ≤ ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
        + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))*n^2 :=
    one_le_mul_of_one_le_of_one_le hCK1 hn2
  have hC1 : (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)/(2*n^2)
      ≤ ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/(2*N) := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*n^2) (by positivity : (0:ℝ) < 2*N), hNn]
    have hA : (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)*(n+1)
        ≤ (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)*n^2 := by
      have h1' : n + 1 ≤ n^2 := by nlinarith only [h2n]
      exact mul_le_mul_of_nonneg_left h1' (by nlinarith only [hCpos', sq_nonneg (2*PhiC+1)])
    have hA2 : (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)*(n+1)/2
        ≤ (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)*n^2/2 := by
      linarith only [hA]
    nlinarith only [hA2, hA, hCpos', sq_nonneg (2*PhiC+1), h2n]
  have hC2 : 1/(n^2*N) ≤ ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/N := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < n^2*N) hNpos']
    have := mul_le_mul_of_nonneg_right hP hNpos'.le
    have hassoc : (((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))*n^2)*N
        = ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))*(N*n^2) := by ring
    have hcomm : ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))*(N*n^2)
        = ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))*(n^2*N) := by ring
    linarith only [this, hassoc, hcomm]
  have hw4 : (p:ℝ)/n - Real.log 2 ≤ 4/n := (abs_le.mp hwsh).2
  have hC3 : (p:ℝ)/(n*N) - 3*Real.log 2/(2*(n*N))
      ≤ ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/(2*N) := by
    have hid : (p:ℝ)/(n*N) - 3*Real.log 2/(2*(n*N)) = ((p:ℝ) - 3*Real.log 2/2)/(n*N) := by
      field_simp
    rw [hid, div_le_div_iff₀ (by positivity : (0:ℝ) < n*N) (by positivity : (0:ℝ) < 2*N)]
    have hp : (p:ℝ) ≤ n*(Real.log 2 + 4/n) := by
      have hwn := mul_le_mul_of_nonneg_right hw4 hnR'.le
      have e1 : ((p:ℝ)/n - Real.log 2)*n = (p:ℝ) - n*Real.log 2 := by field_simp
      have e2 : (4/n)*n = 4 := by field_simp
      nlinarith only [hwn, e1, e2, hnR']
    have hL4 : Real.log 2 + 4/n ≤ ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)) := by
      have hl1 : Real.log 2 ≤ 1 := log_two_le_one
      have hn4 : (4:ℝ) ≤ n := by rw [hn']; exact_mod_cast (by omega : 4 ≤ nmin p)
      have h4n : 4/n ≤ 1 := by rw [div_le_one hnR']; linarith only [hn4]
      linarith only [hCK', hl1, h4n]
    have hCK4 : 2*Real.log 2 + 6 ≤ (10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
        + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2) := by
      have hL1 : Real.log 2 ≤ 1 := log_two_le_one
      linarith only [hCbig, hL1]
    have hn6 : (6:ℝ) ≤ n := by rw [hn']; exact_mod_cast (by omega : 6 ≤ nmin p)
    have hp4 : 2*((p:ℝ) - 3*Real.log 2/2) ≤ n*(((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))) := by
      have hstep : 2*(n*(Real.log 2 + 4/n) - 3*Real.log 2/2)
          ≤ n*(((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))) := by
        have h1 : 2*(n*(Real.log 2 + 4/n) - 3*Real.log 2/2)
            = 2*n*Real.log 2 + 8 - 3*Real.log 2 := by field_simp; ring
        rw [h1]
        nlinarith only [hCK4, log_two_le_one, hn6, hL]
      linarith only [hp, hstep, hnR']
    nlinarith only [hp4, hnR', hNpos', hL]
  have hERR : (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)/(2*n^2)
        + ((p:ℝ)/(n*N) - 3*Real.log 2/(2*(n*N)))
      ≤ ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/N := by
    have h2N : ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/(2*N)
        + ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/(2*N)
        = ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/N := by
      field_simp
      ring
    linarith only [hC1, hC3, h2N]
  have hstepA : (p:ℝ)/N - Real.log 2 = (p:ℝ)/n - Real.log 2 - (p:ℝ)/(n*N) := by
    rw [hNn]
    field_simp
    ring
  have hgoal : 3*Real.log 2/(2*N) - ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/N
      ≤ (p:ℝ)/n - Real.log 2 - (p:ℝ)/(n*N) := by
    linarith only [h1, hERR]
  exact hgoal
lemma uPhiS_lower_sharp3 (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw0 : 0 ≤ w) (hw : w ≤ q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2) :
    6*Real.log 2 - (26*Real.log 2 - 6)*w - 10^18*q^2 ≤ u * PhiS u := by
  have hwq : w^2 ≤ q^2 := by nlinarith only [hw0, hw, hq0]
  have hL : Real.log 2 ≤ 1 := log_two_le_one
  have hLpos : 0 < Real.log 2 := Real.log_pos (by norm_num : (1:ℝ) < 2)
  have hPS' : 6 - 26*w - 10^16*w^2 ≤ PhiS u := by
    have h := (abs_le.mp hPS).1
    linarith only [h]
  have hu0 : 0 ≤ u := by rw [hu]; linarith only [hLpos, hw0]
  have hprod := mul_le_mul_of_nonneg_left hPS' hu0
  rw [hu] at hprod ⊢
  have hexp : (Real.log 2 + w)*(6 - 26*w - 10^16*w^2)
      = 6*Real.log 2 - (26*Real.log 2 - 6)*w - 26*w^2 - 10^16*(w^2*(Real.log 2 + w)) := by ring
  rw [hexp] at hprod
  have hLw : Real.log 2 + w ≤ 2 := by linarith only [hL, hw, hq]
  have hLw0 : 0 ≤ Real.log 2 + w := by linarith only [hLpos, hw0]
  have hbd : w^2*(Real.log 2 + w) ≤ q^2*2 := mul_le_mul hwq hLw hLw0 (by positivity)
  have hrem : 10^16*(w^2*(Real.log 2 + w)) ≤ 10^16*(q^2*2) := mul_le_mul_of_nonneg_left hbd (by norm_num)
  have h26 : 26*w^2 ≤ 26*q^2 := by nlinarith only [hwq]
  nlinarith only [hprod, hrem, h26, hw0, hq0, hL, hLpos]

lemma budget_lower (p : ℕ) (hp : 2 ≤ p) : 2^(-(p:ℝ)) ≤ budget p := by
  have hs := summable_term p hp
  have h0 : term p 0 = 2^(-(p:ℝ)) := by unfold term; norm_num
  rw [← h0, budget]
  exact hs.le_tsum 0 (fun i _ => by unfold term; positivity)

lemma tail2_le (p : ℕ) (hp : 2 ≤ p) :
    (∑' k : ℕ, (((k:ℝ) + 2)) ^ (-(p:ℝ))) ≤ 1 / ((p:ℝ) - 1) := by
  have hpR : (2:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have h1 : (((1:ℕ):ℝ)) = (1:ℝ) := by norm_num
  have h := AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ (-(p:ℝ))) (1:ℕ)
    (by
      intro a ha b hb hab
      rw [h1] at ha
      have ha1 : (1:ℝ) ≤ a := ha
      exact Real.rpow_le_rpow_of_nonpos (by linarith only [ha1] : (0:ℝ) < a) hab (by linarith))
    (by
      simpa [h1] using (integrableOn_Ioi_rpow_of_lt (a := -(p:ℝ)) (c := 1)
        (by linarith [hpR] : -(p:ℝ) < -1) (by norm_num : (0:ℝ) < 1) :
          IntegrableOn (fun x : ℝ => x ^ (-(p:ℝ))) (Set.Ioi (1:ℝ))))
    (by
      intro t ht
      rw [h1] at ht
      exact Real.rpow_nonneg (le_of_lt (by linarith [Set.mem_Ioi.mp ht] : (0:ℝ) < t)) _)
  have hval : ∫ x : ℝ in Set.Ioi (((1:ℕ):ℝ)), x ^ (-(p:ℝ)) = 1 / ((p:ℝ) - 1) := by
    rw [h1]
    rw [integral_Ioi_rpow_of_lt (a := -(p:ℝ)) (c := 1) (by linarith [hpR] : -(p:ℝ) < -1) (by norm_num : (0:ℝ) < 1)]
    rw [show -(p:ℝ) + 1 = 1 - (p:ℝ) by ring]
    rw [show (1:ℝ) - (p:ℝ) = -((p:ℝ) - 1) by ring, Real.rpow_neg (by norm_num), Real.one_rpow]
    have hp2 : (0:ℝ) < (p:ℝ) - 1 := by linarith [hpR]
    field_simp
  rw [hval] at h
  convert h using 2 with k
  · push_cast
    ring

lemma budget_upper (p : ℕ) (hp : 2 ≤ p) : budget p ≤ 3 * 2^(-(p:ℝ)) := by
  have hpR : (2:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hs : Summable (fun n : ℕ => (((n:ℝ) + 1)) ^ (-(p:ℝ))) := by
    have h := (summable_term p hp).mul_left ((2:ℝ) ^ (p:ℝ))
    refine h.congr (fun n => ?_)
    rw [show ((2:ℝ) ^ (p:ℝ)) * term p n = (((n:ℝ) + 1)) ^ (-(p:ℝ)) from by
      unfold term
      rw [show (2 * ((n:ℝ) + 1)) ^ (-(p:ℝ))
          = (2:ℝ) ^ (-(p:ℝ)) * (((n:ℝ) + 1)) ^ (-(p:ℝ)) from by
        rw [Real.mul_rpow (by norm_num) (by positivity)]]
      rw [← mul_assoc, ← Real.rpow_add (by norm_num : (0:ℝ) < 2)]
      rw [show (p:ℝ) + (-(p:ℝ)) = 0 by ring, Real.rpow_zero, one_mul]]
  have hsplit : (∑' k : ℕ, (((k:ℝ) + 1)) ^ (-(p:ℝ)))
      = 1 + (∑' k : ℕ, (((k:ℝ) + 2)) ^ (-(p:ℝ))) := by
    rw [hs.tsum_eq_zero_add]
    congr 1
    · norm_num
    · apply tsum_congr
      intro n
      push_cast
      ring
  have hbud : budget p = 2^(-(p:ℝ)) * (∑' k : ℕ, (((k:ℝ) + 1)) ^ (-(p:ℝ))) := by
    rw [budget]
    simp_rw [show ∀ n : ℕ, term p n = 2^(-(p:ℝ)) * (((n:ℝ) + 1)) ^ (-(p:ℝ)) from fun n => by
      unfold term
      rw [Real.mul_rpow (by norm_num) (by positivity)]]
    rw [tsum_mul_left]
  rw [hbud, hsplit]
  have hpos : (0:ℝ) < (p:ℝ) - 1 := by linarith
  have hle : 1 / ((p:ℝ) - 1) ≤ 1 := by
    rw [div_le_one hpos]; linarith
  have h2p : (0:ℝ) < 2^(-(p:ℝ)) := by positivity
  nlinarith [Op56.Op56.tail2_le p hp, hle, h2p]

lemma tailSum_lower (p N : ℕ) (hp : 2 ≤ p) : term p N ≤ tailSum p N := by
  have hs : Summable (fun n : ℕ => term p (N + n)) := by
    have h := (summable_nat_add_iff N).mpr (summable_term p hp)
    refine h.congr (fun n => ?_)
    ring_nf
  rw [tailSum]
  exact hs.le_tsum 0 (fun i _ => by unfold term; positivity)

lemma tailSum_upper (p N : ℕ) (hp : 2 ≤ p) (hN : 0 < N) :
    tailSum p N ≤ (2 * (N:ℝ)) ^ (-(p:ℝ)) * ((N:ℝ) / ((p:ℝ) - 1)) := by
  have hpR : (2:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hNpos : (0:ℝ) < (N:ℝ) := by exact_mod_cast hN
  have hfac : ∀ n : ℕ, term p (N + n)
      = 2^(-(p:ℝ)) * (((N:ℝ) + ((n:ℝ) + 1))) ^ (-(p:ℝ)) := by
    intro n
    unfold term
    rw [show (2 * (((N + n : ℕ):ℝ) + 1)) = 2 * (((N:ℝ) + ((n:ℝ) + 1))) by push_cast; ring]
    rw [Real.mul_rpow (by norm_num) (by positivity)]
  have h := AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ (-(p:ℝ))) N
    (by
      intro a ha b hb hab
      have ha1 : (N:ℝ) ≤ a := Set.mem_Ici.mp ha
      exact Real.rpow_le_rpow_of_nonpos (by linarith only [ha1, hNpos] : (0:ℝ) < a) hab (by linarith))
    (integrableOn_Ioi_rpow_of_lt (a := -(p:ℝ)) (c := (N:ℝ))
      (by linarith [hpR] : -(p:ℝ) < -1) hNpos)
    (by
      intro t ht
      exact Real.rpow_nonneg (le_of_lt (by linarith [Set.mem_Ioi.mp ht, hNpos] : (0:ℝ) < t)) _)
  have hval : ∫ x : ℝ in Set.Ioi (N:ℝ), x ^ (-(p:ℝ))
      = (N:ℝ) ^ (1 - (p:ℝ)) / ((p:ℝ) - 1) := by
    rw [integral_Ioi_rpow_of_lt (a := -(p:ℝ)) (c := (N:ℝ)) (by linarith [hpR] : -(p:ℝ) < -1) hNpos,
        show -(p:ℝ) + 1 = 1 - (p:ℝ) by ring]
    have hp2 : (0:ℝ) < (p:ℝ) - 1 := by linarith [hpR]
    rw [show (1:ℝ) - (p:ℝ) = -((p:ℝ) - 1) by ring, neg_div_neg_eq]
  rw [hval] at h
  rw [tailSum]
  simp_rw [hfac]
  rw [tsum_mul_left]
  have hkey : (2:ℝ)^(-(p:ℝ)) * ((N:ℝ) ^ (1 - (p:ℝ)) / ((p:ℝ) - 1))
      = (2 * (N:ℝ)) ^ (-(p:ℝ)) * ((N:ℝ) / ((p:ℝ) - 1)) := by
    rw [Real.mul_rpow (by norm_num) hNpos.le]
    have hN1 : (N:ℝ) ^ (-(p:ℝ)) * (N:ℝ) = (N:ℝ) ^ (1 - (p:ℝ)) := by
      rw [show (1:ℝ) - (p:ℝ) = -(p:ℝ) + 1 by ring, Real.rpow_add (by linarith), Real.rpow_one]
    rw [← hN1]
    ring
  have hm := mul_le_mul_of_nonneg_left h (by positivity : (0:ℝ) ≤ 2^(-(p:ℝ)))
  rw [hkey] at hm
  convert hm using 1
  · congr 1
    apply tsum_congr
    intro n
    push_cast
    ring

lemma log_tailSum_upper (p N : ℕ) (hp : 2 ≤ p) (hN : 0 < N) (hN3p : (N:ℝ) ≤ 3*(p:ℝ)) :
    Real.log (tailSum p N) ≤ Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ))) + Real.log 6 := by
  have hNpos : (0:ℝ) < (N:ℝ) := by exact_mod_cast hN
  have hpR : (2:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hp1 : (0:ℝ) < (p:ℝ) - 1 := by linarith
  have hbase : (0:ℝ) < (2 * (N:ℝ)) ^ (-(p:ℝ)) := by positivity
  have hlow : (0:ℝ) < term p N := by unfold term; positivity
  have hts : (0:ℝ) < tailSum p N := by
    have := Op56.Op56.tailSum_lower p N hp
    linarith
  have h := Op56.Op56.tailSum_upper p N hp hN
  have h2 : (N:ℝ) / ((p:ℝ) - 1) ≤ 6 := by
    rw [div_le_iff₀ hp1]
    linarith
  have hratio : (0:ℝ) < (N:ℝ) / ((p:ℝ) - 1) := by positivity
  calc Real.log (tailSum p N)
      ≤ Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ)) * ((N:ℝ) / ((p:ℝ) - 1))) := Real.log_le_log hts h
    _ = Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ))) + Real.log ((N:ℝ) / ((p:ℝ) - 1)) :=
        Real.log_mul (ne_of_gt hbase) (ne_of_gt hratio)
    _ ≤ Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ))) + Real.log 6 := by
        linarith [Real.log_le_log hratio h2]

lemma log_tailSum_lower (p N : ℕ) (hp : 2 ≤ p) (hN : 8 ≤ N)
    (hpn : (p:ℝ) / (N:ℝ) ≤ 2) :
    Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ))) - Real.log 9 ≤ Real.log (tailSum p N) := by
  have hNpos : (0:ℝ) < (N:ℝ) := by exact_mod_cast (by omega : 0 < N)
  have hpR : (2:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hbase : (0:ℝ) < (2 * (N:ℝ)) ^ (-(p:ℝ)) := by positivity
  have hN1 : (0:ℝ) < 1 + (N:ℝ)⁻¹ := by positivity
  have hlow := Op56.Op56.tailSum_lower p N hp
  have hterm : (0:ℝ) < term p N := by unfold term; positivity
  have hts : (0:ℝ) < tailSum p N := by linarith
  -- (1 + 1/N)^p <= 9
  have hlog : Real.log (1 + (N:ℝ)⁻¹) ≤ (N:ℝ)⁻¹ := log_one_add_le _ hN1
  have hpow : (1 + (N:ℝ)⁻¹) ^ (p:ℝ) ≤ Real.exp 2 := by
    rw [Real.rpow_def_of_pos (by positivity : (0:ℝ) < 1 + (N:ℝ)⁻¹)]
    rw [Real.exp_le_exp]
    have hmul : (p:ℝ) * Real.log (1 + (N:ℝ)⁻¹) ≤ (p:ℝ) * (N:ℝ)⁻¹ := by
      exact mul_le_mul_of_nonneg_left hlog (by linarith)
    have hpN : (p:ℝ) * (N:ℝ)⁻¹ ≤ 2 := by rw [← div_eq_mul_inv]; exact hpn
    linarith
  have h9' : Real.exp 2 < 9 := by
    rw [show (2:ℝ) = 1 + 1 by norm_num, Real.exp_add]
    nlinarith [Real.exp_one_lt_three, Real.exp_pos 1]
  have h9 : (1 + (N:ℝ)⁻¹) ^ (p:ℝ) ≤ 9 := le_trans hpow h9'.le
  have hterm_eq : term p N = (2 * (N:ℝ)) ^ (-(p:ℝ)) * ((1 + (N:ℝ)⁻¹) ^ (p:ℝ))⁻¹ := by
    unfold term
    rw [show (2 * ((N:ℝ) + 1)) = (2 * (N:ℝ)) * (1 + (N:ℝ)⁻¹) by
      field_simp]
    rw [Real.mul_rpow (by positivity) hN1.le]
    rw [Real.rpow_neg (by positivity), Real.rpow_neg (le_of_lt (by exact add_pos one_pos (inv_pos.mpr hNpos)) : (0:ℝ) ≤ 1 + (N:ℝ)⁻¹)]
  have hge : (2 * (N:ℝ)) ^ (-(p:ℝ)) / 9 ≤ term p N := by
    rw [hterm_eq]
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 9)]
    rw [mul_comm ((2 * (N:ℝ)) ^ (-(p:ℝ))) ((1 + (N:ℝ)⁻¹) ^ (p:ℝ))⁻¹]
    have hinv : (9:ℝ)⁻¹ ≤ ((1 + (N:ℝ)⁻¹) ^ (p:ℝ))⁻¹ :=
      (inv_le_inv₀ (by norm_num : (0:ℝ) < 9) (by positivity)).mpr h9
    nlinarith [hinv, hbase]
  calc Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ))) - Real.log 9
      = Real.log ((2 * (N:ℝ)) ^ (-(p:ℝ)) / 9) := by rw [Real.log_div (ne_of_gt hbase) (by norm_num)]
    _ ≤ Real.log (term p N) := Real.log_le_log (by positivity) hge
    _ ≤ Real.log (tailSum p N) := Real.log_le_log hterm hlow

lemma L_decomp (p : ℕ) (hp : 2 ≤ p) :
    L p = -((nmin p : ℝ)) * Real.log 2 - Real.log (tailSum p (nmin p))
      + Real.log (budget p) := by
  have hterm : (0:ℝ) < term p (nmin p) := by unfold term; positivity
  have hts : (0:ℝ) < tailSum p (nmin p) := by
    have := Op56.Op56.tailSum_lower p (nmin p) hp
    linarith
  have hbud : (0:ℝ) < budget p := by
    have := Op56.Op56.budget_lower p hp
    linarith [show (0:ℝ) < 2^(-(p:ℝ)) by positivity]
  have h2 : (0:ℝ) < (2:ℝ) ^ (nmin p) := by positivity
  have hnum : (0:ℝ) < (2:ℝ) ^ (nmin p) * tailSum p (nmin p) := mul_pos h2 hts
  unfold L reachableFraction reachableMeasure
  rw [Real.log_div (ne_of_gt hnum) (ne_of_gt hbud)]
  rw [Real.log_mul (ne_of_gt h2) (ne_of_gt hts)]
  rw [Real.log_pow]
  ring

lemma log_abs_one_add_le (t : ℝ) (ht : |t| ≤ 1/2) : |Real.log (1 + t)| ≤ 2 * |t| := by
  have h1 : 0 < 1 + t := by linarith [abs_le.mp ht |>.1]
  by_cases h : 0 ≤ t
  · rw [abs_of_nonneg (Real.log_nonneg (by linarith))]
    have := Real.log_le_sub_one_of_pos h1
    linarith [abs_of_nonneg h]
  · push_neg at h
    rw [abs_of_neg (Real.log_neg h1 (by linarith)), abs_of_neg h]
    have h2 : 0 < 1 / (1 + t) := by positivity
    have := Real.log_le_sub_one_of_pos h2
    rw [Real.log_div (by norm_num) (ne_of_gt h1), Real.log_one] at this
    have ht1 := (abs_le.mp ht).1
    have hprod : t * (1 + 2 * t) ≤ 0 :=
      mul_nonpos_of_nonpos_of_nonneg h.le (by linarith [(abs_le.mp ht).1])
    have hrec : 2 * t ≤ 1 - 1 / (1 + t) := by
      have h3 : 1 / (1 + t) ≤ 1 - 2 * t := by
        rw [div_le_iff₀ h1]
        nlinarith [hprod]
      linarith only [h3]
    have hlog : 2 * t ≤ Real.log (1 + t) := by
      have := Real.log_le_sub_one_of_pos (show (0:ℝ) < 1 / (1 + t) by positivity)
      rw [Real.log_div (by norm_num) (ne_of_gt h1), Real.log_one] at this
      linarith only [this, hrec]
    linarith only [hlog]

lemma nmin_ratio_close (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1| ≤ 100/(p:ℝ) := by
  have hpR : (6:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hN : (0:ℝ) < (nmin p : ℝ) := by
    have : (2000000000:ℕ) ≤ nmin p := hn
    exact_mod_cast (by omega : 0 < nmin p)
  have hw : |(p:ℝ)/(nmin p:ℝ) - Real.log 2| ≤ 4/(nmin p:ℝ) :=
    Op56.Op56.nmin_w_sharp p hp hn hlarge hnK
  rw [show Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1
      = -((nmin p : ℝ)/(p:ℝ)) * ((p:ℝ)/(nmin p:ℝ) - Real.log 2) by field_simp; ring]
  have hNp : (0:ℝ) ≤ (nmin p : ℝ) / (p:ℝ) := by positivity
  rw [abs_mul, abs_neg, abs_of_nonneg hNp]
  have hb : ((nmin p : ℝ)/(p:ℝ)) * (4/(nmin p:ℝ)) = 4/(p:ℝ) := by field_simp
  have h4 : 4/(p:ℝ) ≤ 100/(p:ℝ) := by
    rw [div_le_div_iff₀ (by linarith : (0:ℝ) < (p:ℝ)) (by linarith : (0:ℝ) < (p:ℝ))]
    linarith
  calc ((nmin p : ℝ)/(p:ℝ)) * |(p:ℝ)/(nmin p:ℝ) - Real.log 2|
      ≤ ((nmin p : ℝ)/(p:ℝ)) * (4/(nmin p:ℝ)) :=
        mul_le_mul_of_nonneg_left hw (by positivity)
    _ = 4/(p:ℝ) := hb
    _ ≤ 100/(p:ℝ) := h4

lemma log_ratio_close (p : ℕ) (hp : 16 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |Real.log (2 * (nmin p:ℝ) / (p:ℝ)) - (Real.log 2 - Real.log (Real.log 2))| ≤ 300 / (p:ℝ) := by
  have hL := Real.log_pos (by norm_num : (1:ℝ) < 2)
  have hpR : (16:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp
  have hN : (0:ℝ) < (nmin p : ℝ) := by
    have : (2000000000:ℕ) ≤ nmin p := hn
    exact_mod_cast (by omega : 0 < nmin p)
  have ht := Op56.Op56.nmin_ratio_close p (by omega) hn hlarge hnK
  have hw : |(p:ℝ)/(nmin p:ℝ) - Real.log 2| ≤ 4/(nmin p:ℝ) :=
    Op56.Op56.nmin_w_sharp p (by omega) hn hlarge hnK
  have htabs : |Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1| ≤ 1/4 := by
    have hNp : (0:ℝ) ≤ (nmin p : ℝ) / (p:ℝ) := by positivity
    rw [show Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1
        = -((nmin p : ℝ) / (p:ℝ)) * ((p:ℝ)/(nmin p:ℝ) - Real.log 2) by field_simp; ring]
    rw [abs_mul, abs_neg, abs_of_nonneg hNp]
    have hb : ((nmin p : ℝ) / (p:ℝ)) * (4/(nmin p:ℝ)) = 4/(p:ℝ) := by field_simp
    have h4 : 4/(p:ℝ) ≤ 1/4 := by
      rw [div_le_iff₀ (by linarith : (0:ℝ) < (p:ℝ))]
      linarith
    calc ((nmin p : ℝ)/(p:ℝ)) * |(p:ℝ)/(nmin p:ℝ) - Real.log 2|
        ≤ ((nmin p : ℝ)/(p:ℝ)) * (4/(nmin p:ℝ)) := mul_le_mul_of_nonneg_left hw hNp
      _ = 4/(p:ℝ) := hb
      _ ≤ 1/4 := h4
  rw [show (2:ℝ) * (nmin p : ℝ) / (p:ℝ)
      = (2 / Real.log 2) * (1 + (Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1)) by
    field_simp
    ring]
  have ht1 : -(1/4 : ℝ) ≤ Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1 := (abs_le.mp htabs).1
  have hpos : (0:ℝ) < 1 + (Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1) := by linarith
  rw [Real.log_mul (by positivity : (2:ℝ) / Real.log 2 ≠ 0) hpos.ne']
  rw [Real.log_div (by norm_num : (2:ℝ) ≠ 0) (ne_of_gt hL)]
  rw [show (Real.log 2 - Real.log (Real.log 2))
        + Real.log (1 + (Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1))
        - (Real.log 2 - Real.log (Real.log 2))
      = Real.log (1 + (Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1)) by ring]
  calc |Real.log (1 + (Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1))|
      ≤ 2 * |Real.log 2 * (nmin p : ℝ) / (p:ℝ) - 1| :=
        Op56.Op56.log_abs_one_add_le _ (le_trans htabs (by norm_num : (1:ℝ)/4 ≤ 1/2))
    _ ≤ 200 / (p:ℝ) := by
      have h2 := mul_le_mul_of_nonneg_left ht (by norm_num : (0:ℝ) ≤ 2)
      rw [show (2:ℝ) * (100 / (p:ℝ)) = 200 / (p:ℝ) by ring] at h2
      exact h2
    _ ≤ 300 / (p:ℝ) := by
      rw [div_le_div_iff₀ (by linarith : (0:ℝ) < (p:ℝ)) (by linarith : (0:ℝ) < (p:ℝ))]
      linarith

lemma log_budget_close (p : ℕ) (hp : 2 ≤ p) :
    |Real.log (budget p) + (p:ℝ) * Real.log 2| ≤ Real.log 3 := by
  have hL := Real.log_pos (by norm_num : (1:ℝ) < 2)
  have hlow := Op56.Op56.budget_lower p hp
  have hup := Op56.Op56.budget_upper p hp
  have hpos : (0:ℝ) < budget p := by
    have : (0:ℝ) < 2^(-(p:ℝ)) := by positivity
    linarith
  have h3 : (0:ℝ) < 3 := by norm_num
  rw [abs_le]
  constructor
  · -- lower: -log 3 <= log (budget p) + p log 2
    have h1 : Real.log (2^(-(p:ℝ))) ≤ Real.log (budget p) := Real.log_le_log (by positivity) hlow
    rw [Real.log_rpow (by norm_num : (0:ℝ) < 2)] at h1
    linarith [h1, Real.log_nonneg (by norm_num : (1:ℝ) ≤ 3)]
  · -- upper: log (budget p) + p log 2 <= log 3
    have h1 : Real.log (budget p) ≤ Real.log (3 * 2^(-(p:ℝ))) := Real.log_le_log hpos hup
    rw [Real.log_mul (by norm_num : (3:ℝ) ≠ 0) (by positivity : (2:ℝ)^(-(p:ℝ)) ≠ 0),
        Real.log_rpow (by norm_num : (0:ℝ) < 2)] at h1
    linarith

lemma log_tailSum_close (p N : ℕ) (hp : 2 ≤ p) (hN : 8 ≤ N) (hN3p : (N:ℝ) ≤ 3*(p:ℝ))
    (hpn : (p:ℝ) / (N:ℝ) ≤ 2) :
    |Real.log (tailSum p N) + (p:ℝ) * Real.log (2 * (N:ℝ))| ≤ Real.log 9 := by
  have hNpos : (0:ℝ) < (N:ℝ) := by exact_mod_cast (by omega : 0 < N)
  have h2N : (0:ℝ) < 2 * (N:ℝ) := by linarith
  have hbase : (0:ℝ) < (2 * (N:ℝ)) ^ (-(p:ℝ)) := by positivity
  have hup := Op56.Op56.log_tailSum_upper p N hp (by omega) hN3p
  have hlow := Op56.Op56.log_tailSum_lower p N hp hN hpn
  rw [Real.log_rpow (by linarith : (0:ℝ) < 2 * (N:ℝ))] at hup hlow
  rw [abs_le]
  constructor
  · linarith only [hlow]
  · have h69 : Real.log 6 ≤ Real.log 9 := Real.log_le_log (by norm_num) (by norm_num)
    linarith only [hup, h69]

lemma log_nmin_close (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(nmin p : ℝ) * Real.log 2 - (p:ℝ)| ≤ 4 := by
  have hN : (0:ℝ) < (nmin p : ℝ) := by
    have : (2000000000:ℕ) ≤ nmin p := hn
    exact_mod_cast (by omega : 0 < nmin p)
  have hw := Op56.Op56.nmin_w_sharp p hp hn hlarge hnK
  have h3 : ((nmin p : ℝ)) * ((p:ℝ)/(nmin p:ℝ) - Real.log 2)
      = (p:ℝ) - (nmin p : ℝ) * Real.log 2 := by field_simp
  calc |(nmin p : ℝ) * Real.log 2 - (p:ℝ)|
      = |((nmin p : ℝ)) * ((p:ℝ)/(nmin p:ℝ) - Real.log 2)| := by rw [h3, abs_sub_comm]
    _ = ((nmin p : ℝ)) * |(p:ℝ)/(nmin p:ℝ) - Real.log 2| := by
        rw [abs_mul, abs_of_nonneg hN.le]
    _ ≤ ((nmin p : ℝ)) * (4/(nmin p:ℝ)) := mul_le_mul_of_nonneg_left hw hN.le
    _ = 4 := by field_simp

lemma L_bounded_abstract (p : ℕ) (N M B T : ℝ)
    (hdecomp : L p = -N * Real.log 2 - Real.log T + Real.log B)
    (hN : N * Real.log 2 - (p:ℝ) = -(-(N * Real.log 2) + (p:ℝ)))
    (hasym : LAsym p = (p:ℝ) * Real.log (p:ℝ) - (1 + Real.log (Real.log 2)) * (p:ℝ))
    (h1 : |-(N * Real.log 2) + (p:ℝ)| ≤ 4)
    (h2 : |Real.log B + (p:ℝ) * Real.log 2| ≤ Real.log 3)
    (h3 : |-(Real.log T) - (p:ℝ) * Real.log (2*N)| ≤ Real.log 9)
    (h4 : |(p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))| ≤ 300)
    (hlog : Real.log (2*N/(p:ℝ)) = Real.log (2*N) - Real.log (p:ℝ)) :
    |L p - LAsym p| ≤ 1000 := by
  have hkey : L p - LAsym p
      = (-(N * Real.log 2) + (p:ℝ))
        + (Real.log B + (p:ℝ) * Real.log 2)
        + (-(Real.log T) - (p:ℝ) * Real.log (2*N))
        + ((p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))) := by
    rw [hdecomp, hasym, hlog]
    ring
  rw [hkey]
  have hassoc : -(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)
        + (-Real.log T - (p:ℝ) * Real.log (2*N))
        + (p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))
      = (-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)
          + (-Real.log T - (p:ℝ) * Real.log (2*N)))
        + (p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2))) := by ring
  calc |-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)
        + (-Real.log T - (p:ℝ) * Real.log (2*N))
        + (p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))|
      ≤ |-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)
          + (-Real.log T - (p:ℝ) * Real.log (2*N))|
        + |(p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))| := by
        rw [hassoc]
        exact abs_add_le _ _
    _ ≤ (|-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)|
          + |-Real.log T - (p:ℝ) * Real.log (2*N)|) + |(p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))| := by
        linarith [abs_add_le (-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)) (-Real.log T - (p:ℝ) * Real.log (2*N)), h4]
    _ ≤ ((|-(N * Real.log 2) + (p:ℝ)| + |Real.log B + (p:ℝ) * Real.log 2|)
          + |-Real.log T - (p:ℝ) * Real.log (2*N)|) + |(p:ℝ) * (Real.log (2*N/(p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))| := by
        have h := abs_add_le (-(N * Real.log 2) + (p:ℝ)) (Real.log B + (p:ℝ) * Real.log 2)
        have hA2 : (|-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)|
              + |-Real.log T - (p:ℝ) * Real.log (2 * N)|) + |(p:ℝ) * (Real.log (2 * N / (p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))| 
            = |-(N * Real.log 2) + (p:ℝ) + (Real.log B + (p:ℝ) * Real.log 2)|
              + (|-Real.log T - (p:ℝ) * Real.log (2 * N)|
                + |(p:ℝ) * (Real.log (2 * N / (p:ℝ)) - (Real.log 2 - Real.log (Real.log 2)))|) := by ring
        rw [hA2]
        linarith only [h]
    _ ≤ 1000 := by
        have h3u : Real.log 3 ≤ 2 := by
          have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 3)
          linarith
        have h9u : Real.log 9 ≤ 8 := by
          have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 9)
          linarith
        linarith [h1, h2, h3, h4, h3u, h9u]

lemma L_bounded (p : ℕ) (hp : 16 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |L p - LAsym p| ≤ 1000 := by
  have hL := Real.log_pos (by norm_num : (1:ℝ) < 2)
  have hN : (0:ℝ) < (nmin p : ℝ) := by
    have : (2000000000:ℕ) ≤ nmin p := hn
    exact_mod_cast (by omega : 0 < nmin p)
  have hw := Op56.Op56.nmin_w_sharp p (by omega : 6 ≤ p) hn hlarge hnK
  have hwhi : (p:ℝ)/(nmin p:ℝ) ≤ Real.log 2 + 4/(nmin p:ℝ) := by linarith [(abs_le.mp hw).2]
  have h4N : 4/(nmin p:ℝ) ≤ 1 := by
    rw [div_le_one (by linarith : (0:ℝ) < (nmin p:ℝ))]
    have : (2000000000:ℕ) ≤ nmin p := hn
    exact_mod_cast (by omega : 4 ≤ nmin p)
  have hpn : (p:ℝ)/(nmin p:ℝ) ≤ 2 := by
    have hL1 : Real.log 2 ≤ 1 := log_two_le_one
    linarith [hwhi, hL1, h4N]
  have hpR2 : (8:ℝ) ≤ (p:ℝ) := by exact_mod_cast (by omega : 8 ≤ p)
  have hNle : (nmin p : ℝ) ≤ 3 * (p:ℝ) := by
    have hwlo : Real.log 2 - 4/(nmin p:ℝ) ≤ (p:ℝ)/(nmin p:ℝ) := by linarith [(abs_le.mp hw).1]
    have hmul := mul_le_mul_of_nonneg_left hwlo hN.le
    have he : (nmin p : ℝ) * ((p:ℝ)/(nmin p:ℝ)) = (p:ℝ) := by field_simp
    have he2 : (nmin p : ℝ) * (Real.log 2 - 4/(nmin p:ℝ)) = (nmin p : ℝ) * Real.log 2 - 4 := by
      field_simp
    rw [he, he2] at hmul
    have hL12 : (1/2:ℝ) < Real.log 2 := by linarith [Real.log_two_gt_d9]
    nlinarith [hmul, h4N, hL12, hN, hpR2]
  exact Op56.Op56.L_bounded_abstract p (nmin p : ℝ) 0 (budget p) (tailSum p (nmin p))
    (Op56.Op56.L_decomp p (by omega : 2 ≤ p))
    (by ring)
    rfl
    (by
      have h := Op56.Op56.log_nmin_close p (by omega : 6 ≤ p) hn hlarge hnK
      rw [abs_sub_comm] at h
      simpa [sub_eq_add_neg, add_comm] using h)
    (Op56.Op56.log_budget_close p (by omega : 2 ≤ p))
    (by
      have h := Op56.Op56.log_tailSum_close p (nmin p) (by omega : 2 ≤ p) (by omega : 8 ≤ nmin p)
        (by linarith [hNle] : (nmin p : ℝ) ≤ 3 * (p:ℝ)) hpn
      rw [show -(Real.log (tailSum p (nmin p))) - (p:ℝ) * Real.log (2 * (nmin p : ℝ))
          = -((Real.log (tailSum p (nmin p))) + (p:ℝ) * Real.log (2 * (nmin p : ℝ))) by ring,
        abs_neg]
      exact h)
    (by
      have h := Op56.Op56.log_ratio_close p hp hn hlarge hnK
      have h2 := mul_le_mul_of_nonneg_left h (by linarith : (0:ℝ) ≤ (p:ℝ))
      rw [show (p:ℝ) = |(p:ℝ)| from (abs_of_nonneg (by linarith : (0:ℝ) ≤ (p:ℝ))).symm] at h2
      rw [← abs_mul] at h2
      rw [abs_of_nonneg (by linarith : (0:ℝ) ≤ (p:ℝ))] at h2
      have h6 : (p:ℝ) * (300 / (p:ℝ)) = 300 := by field_simp
      linarith [h2, h6])
    (Real.log_div (by positivity : (2:ℝ) * (nmin p : ℝ) ≠ 0) (by linarith : (p:ℝ) ≠ 0))

lemma exp_neg_quarter_le (k : ℕ) : Real.exp (-((k : ℝ)/4)) ≤ ((7:ℝ)/8)^k := by
  have h1 : (8:ℝ)/7 ≤ Real.exp (1/4) := by
    have := Real.add_one_le_exp (1/4 : ℝ)
    linarith
  have h2 : ((8:ℝ)/7)^k ≤ (Real.exp (1/4))^k := pow_le_pow_left₀ (by norm_num) h1 k
  have h3 : (Real.exp (1/4))^k = Real.exp ((k:ℝ)/4) := by
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  rw [h3] at h2
  have h4 : (0:ℝ) < Real.exp ((k:ℝ)/4) := Real.exp_pos _
  have h5 : (Real.exp ((k:ℝ)/4))⁻¹ ≤ (((8:ℝ)/7 : ℝ)^k)⁻¹ := by
    rw [inv_le_inv₀ (Real.exp_pos _) (by positivity)]
    exact h2
  calc Real.exp (-((k : ℝ)/4)) = (Real.exp ((k:ℝ)/4))⁻¹ := Real.exp_neg _
    _ ≤ (((8:ℝ)/7 : ℝ)^k)⁻¹ := h5
    _ = ((7:ℝ)/8)^k := by rw [← inv_pow]; norm_num

lemma PhiC_le : PhiC ≤ 3368 := by
  have hr : ‖((7:ℝ)/8)‖ < 1 := by norm_num
  have hbig : Summable (fun k : ℕ => (k:ℝ)^2 * ((7:ℝ)/8)^k) := by
    have h := (hasSum_pow_mul_geometric_of_norm_lt_one 2 hr).summable
    convert h using 2 with n
  have hle : ∀ k : ℕ, (k:ℝ)^2 * Real.exp (-((k:ℝ)/4)) ≤ (k:ℝ)^2 * ((7:ℝ)/8)^k := by
    intro k
    exact mul_le_mul_of_nonneg_left (Op56.exp_neg_quarter_le k) (sq_nonneg _)
  have hsmall : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-((k:ℝ)/4))) :=
    Summable.of_nonneg_of_le (fun k => mul_nonneg (sq_nonneg _) (Real.exp_pos _).le) hle hbig
  have hsum := Summable.tsum_le_tsum hle hsmall hbig
  have hclosed : (∑' k : ℕ, (k:ℝ)^2 * ((7:ℝ)/8)^k) = 840 := by
    have h := tsum_pow_mul_geometric_of_norm_lt_one 2 (by norm_num : ‖((7:ℝ)/8)‖ < 1)
    rw [h]
    norm_num [Nat.stirlingSecond, Finset.sum_range_succ]
  unfold PhiC
  rw [hclosed] at hsum
  linarith

end
end Op56
