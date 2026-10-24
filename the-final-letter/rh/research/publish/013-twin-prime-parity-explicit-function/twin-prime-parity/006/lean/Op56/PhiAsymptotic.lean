/-
  Op56/PhiAsymptotic.lean — the geometrically-dominated asymptotics of
  `Phi p n = Σ'_j (1 + (j+1)/n)^{-p}` in the critical scaling `p = u·n`.

  **Why not Euler–Maclaurin.**  At the OP-5 threshold one has `p/n → log 2`, so `p` and
  `n` are *comparable* (`n ≈ p/log 2`), and the summands `(1 + (j+1)/n)^{-p}` decay by a
  factor `→ 1/2`; the sum is geometrically dominated.  Euler–Maclaurin is therefore both
  unnecessary and unusable here (its series diverges in this regime).  What the proof
  actually needs is the elementary split below.

  **The argument.**  With `u = p/n` and `x_j = (j+1)/n`, the log bounds
  `x - x²/2 ≤ log (1+x) ≤ x` (for `x ≥ 0`) give the two-sided estimate
  `exp (-u(j+1)) ≤ (1 + x_j)^{-un} ≤ exp (-u(j+1) + u(j+1)²/(2n))`.
  The left side sums *exactly* to `(exp u - 1)^{-1}`; the right side is that sum plus a
  correction that is `O(1/n)`.

  **Correction to an earlier guess (recorded so it is not retried).**  The tail
  `Σ_{k>n} (1 + k/n)^{-un}` does *not* decay geometrically: the consecutive ratio is
  `(1 + 1/(n+k))^{-un} → 1` as `k → ∞`, so no uniform ratio `< 1` exists.  The tail
  decays *polynomially*, like `k^{-un}` with the large exponent `un ≥ n/2`.  Two valid
  routes for it:
  * integral comparison (`AntitoneOn.integral_le_tsum_comp_add`), giving
    `Σ_{k>n} T_k ≤ n·2^{1-un}/(un-1) ≤ 4n·2^{-n/2}`; or
  * the elementary telescoping bound `Σ_{j≥M} j^{-2} ≤ 2/M` together with
    `j^{-un} ≤ j^{-2}·M^{2-un}` for `j ≥ M = 2n`, which gives the same shape.

  **Status: complete.**  The main result is `Phi_asymptotic`:
  `∃ C > 0, ∀ n ≥ 4, ∀ u ∈ [1/2,1], |Phi_{un}(n) - (exp u - 1)^{-1}| ≤ C/n`, with the
  explicit `C = (Σ'_k k² exp(-k/4))/2 + 8`.  The route:

  * **tail** (polynomial decay): `sum_rpow_tail_le` (integral comparison) →
    `phi_tail_le` (`≤ n·2^{1-un}/(un-1)`) → `nat_le_two_rpow_half` (`n ≤ 2^{n/2}`) →
    `phi_tail_le_div` (`≤ 8/n`);
  * **finite part**: `phi_term_diff_le` (`T_k - e^{-uk} ≤ u k² e^{-uk/2}/(2n)`) →
    `phi_finite_le` (`≤ S/(2n)`);
  * **assembly**: `hasSum_exp_neg`, `geometric_le_Phi`, `tsum_sub`,
    `sum_add_tsum_tsum_nat_add`.

  The finite part
  `Σ_{k≤n}(T_k - e^{-uk}) ≤ S/(2n)` with `S = Σ'_k k²·exp(-k/4)`, which Mathlib evaluates
  by `tsum_sq_mul_geometric_of_norm_lt_one`
  (`Σ_{k≥0}k²r^k = r(1+r)/(1-r)³` at `r = exp(-1/4)`).  Together with
  `phi_tail_le_div` this gives the constant `C = S/2 + 8` of `Phi_asymptotic`.
-/

import Op56.Exact
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecificLimits.Basic

namespace Op56

set_option maxHeartbeats 2000000

noncomputable section

open scoped BigOperators Topology
open MeasureTheory

/-! ### Elementary log bounds -/

/-- `log (1 + x) ≤ x` for `x > -1`. -/
lemma log_one_add_le (x : ℝ) (hx : 0 < 1 + x) : Real.log (1 + x) ≤ x := by
  have h := Real.log_le_sub_one_of_pos hx
  linarith

/-- `log (1 + x) ≥ x - x²/2` for `x ≥ 0`. -/
lemma log_one_add_ge (x : ℝ) (hx : 0 ≤ x) : x - x ^ 2 / 2 ≤ Real.log (1 + x) := by
  have h1 : 2 * x / (x + 2) ≤ Real.log (1 + x) := Real.le_log_one_add_of_nonneg hx
  have h2 : x - x ^ 2 / 2 ≤ 2 * x / (x + 2) := by
    rw [le_div_iff₀ (by linarith : (0 : ℝ) < x + 2)]
    nlinarith [sq_nonneg x, sq_nonneg (x - 2), hx]
  linarith

/-! ### The two-sided term comparison -/

/-- **Lower comparison.**  `exp (-u·n·x) ≤ (1 + x)^{-un}` for `x ≥ 0`, `u ≥ 0`. -/
lemma exp_neg_mul_le_rpow (u : ℝ) (hu : 0 ≤ u) (n : ℕ) (x : ℝ) (hx : 0 ≤ x) :
    Real.exp (-(u * (n : ℝ) * x)) ≤ (1 + x) ^ (-(u * (n : ℝ))) := by
  have h2 : (0 : ℝ) < 1 + x := by linarith
  have h1 : Real.log (1 + x) ≤ x := log_one_add_le x h2
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hun : (0 : ℝ) ≤ u * (n : ℝ) := mul_nonneg hu hn
  have h3 : Real.log (1 + x) * (u * (n : ℝ)) ≤ x * (u * (n : ℝ)) :=
    mul_le_mul_of_nonneg_right h1 hun
  have h4 : -(u * (n : ℝ) * x) ≤ Real.log (1 + x) * (-(u * (n : ℝ))) := by
    nlinarith [h3]
  rw [Real.rpow_def_of_pos h2]
  exact Real.exp_le_exp.mpr h4

/-- **Upper comparison.**  `(1 + x)^{-un} ≤ exp (-u·n·x + u·n·x²/2)` for `x ≥ 0`. -/
lemma rpow_le_exp_neg_add (u : ℝ) (hu : 0 ≤ u) (n : ℕ) (x : ℝ) (hx : 0 ≤ x) :
    (1 + x) ^ (-(u * (n : ℝ))) ≤ Real.exp (-(u * (n : ℝ) * x) + u * (n : ℝ) * x ^ 2 / 2) := by
  have h2 : (0 : ℝ) < 1 + x := by linarith
  have h1 : x - x ^ 2 / 2 ≤ Real.log (1 + x) := log_one_add_ge x hx
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hun : (0 : ℝ) ≤ u * (n : ℝ) := mul_nonneg hu hn
  have h3 : (x - x ^ 2 / 2) * (u * (n : ℝ)) ≤ Real.log (1 + x) * (u * (n : ℝ)) :=
    mul_le_mul_of_nonneg_right h1 hun
  have h4 : Real.log (1 + x) * (-(u * (n : ℝ))) ≤ -(u * (n : ℝ) * x) + u * (n : ℝ) * x ^ 2 / 2 := by
    nlinarith [h3]
  rw [Real.rpow_def_of_pos h2]
  exact Real.exp_le_exp.mpr h4

/-- **Second-order log bound.**  `log (1+x) ≤ x - x²/2 + x³/3` for `x ≥ 0`.

Proof: `g(x) = x - x²/2 + x³/3 - log (1+x)` has `g' = x³/(1+x) ≥ 0`, so `g` is monotone
on `[0,∞)` and `g(x) ≥ g(0) = 0`.  This controls the `x³`-order term
`x²/2 - x + log (1+x) ≤ x³/3`, which is what the sharp (`O(1/n²)`) expansion of `Phi`
needs. -/
lemma log_one_add_le_cubic (x : ℝ) (hx : 0 ≤ x) :
    Real.log (1 + x) ≤ x - (1/2)*x^2 + (1/3)*x^3 := by
  have hpoly_deriv : ∀ y : ℝ, deriv (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3) y = 1 - y + y^2 := by
    intro y
    have h1 : HasDerivAt (fun t : ℝ => (1/2)*t^2) y y := by
      have h := (hasDerivAt_id y).pow 2 |>.const_mul ((1:ℝ)/2)
      convert h using 1
      · ext t; rw [Pi.pow_apply, id_eq]
      · simp only [id_eq]; push_cast; ring
    have h2 : HasDerivAt (fun t : ℝ => (1/3)*t^3) (y^2) y := by
      have h := (hasDerivAt_id y).pow 3 |>.const_mul ((1:ℝ)/3)
      convert h using 1
      · ext t; rw [Pi.pow_apply, id_eq]
      · simp only [id_eq]; push_cast; ring
    have h3 := ((hasDerivAt_id y).sub h1).add h2
    have hd := h3.deriv
    have hfun : ((id - fun t : ℝ => (1/2)*t^2) + fun t : ℝ => (1/3)*t^3)
        = (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3) := by
      funext t; simp only [Pi.sub_apply, Pi.add_apply, id_eq]
    rw [hfun] at hd
    exact hd
  have hcont : ContinuousOn (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3 - Real.log (1+t))
      (Set.Ici 0) := by
    refine ContinuousOn.sub ?_ ?_
    · exact (((continuous_id.continuousOn).sub
          (((continuous_id.pow 2).const_mul ((1:ℝ)/2)).continuousOn)).add
          (((continuous_id.pow 3).const_mul ((1:ℝ)/3)).continuousOn))
    · exact ContinuousOn.log ((continuous_const.add continuous_id).continuousOn)
        (fun t ht => by simp only [Set.mem_Ici] at ht; positivity)
  have hdiff : DifferentiableOn ℝ (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3 - Real.log (1+t))
      (interior (Set.Ici 0)) := by
    refine DifferentiableOn.sub ?_ ?_
    · exact (((differentiable_id.differentiableOn).sub
          (((differentiable_id.pow 2).const_mul ((1:ℝ)/2)).differentiableOn)).add
          (((differentiable_id.pow 3).const_mul ((1:ℝ)/3)).differentiableOn))
    · exact DifferentiableOn.log
        (((differentiable_const 1).add differentiable_id).differentiableOn)
        (fun t ht => by
          rw [interior_Ici] at ht
          exact ne_of_gt (by linarith [Set.mem_Ioi.mp ht] : (0:ℝ) < 1 + t))
  have hmono : MonotoneOn (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3 - Real.log (1+t))
      (Set.Ici 0) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hdiff
    intro y hy
    rw [interior_Ici] at hy
    have hy0 : (0:ℝ) < y := hy
    have h1y : (1:ℝ) + y ≠ 0 := by positivity
    have hl := (Real.hasDerivAt_log h1y).comp y (by
      simpa using (hasDerivAt_id y).const_add 1 : HasDerivAt (fun t : ℝ => 1 + t) 1 y)
    have hp : HasDerivAt (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3) (1 - y + y^2) y :=
      (hasDerivAt_id y).sub (by
        have h := (hasDerivAt_id y).pow 2 |>.const_mul ((1:ℝ)/2)
        convert h using 1
        · ext t; rw [Pi.pow_apply, id_eq]
        · simp only [id_eq]; push_cast; ring) |>.add (by
          have h := (hasDerivAt_id y).pow 3 |>.const_mul ((1:ℝ)/3)
          convert h using 1
          · ext t; rw [Pi.pow_apply, id_eq]
          · simp only [id_eq]; push_cast; ring)
    have hall := hp.sub hl
    have hd := hall.deriv
    have hfun : ((fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3) - (Real.log ∘ HAdd.hAdd 1))
        = (fun t : ℝ => t - (1/2)*t^2 + (1/3)*t^3 - Real.log (1+t)) := by
      funext t; simp only [Pi.sub_apply, Function.comp_apply]
    rw [hfun] at hd
    rw [hd]
    rw [show (1 - y + y^2) - (1 + y)⁻¹ * 1 = y^3/(1+y) by field_simp; ring]
    positivity
  have hfin := hmono (by simp : (0:ℝ) ∈ Set.Ici 0) hx hx
  simpa using hfin

/-- **Exponential remainder.**  `|exp z - 1 - z| ≤ exp z · z²` for `z ≥ 0`.

This is what turns the two-sided log estimate into a sharp termwise expansion of `Phi`:
with `d = s(x - log(1+x)) = y - e`, one gets
`|T_k - G_k - G_k·y| ≤ T_k·y² + G_k·e`, and the dangerous `exp d` factor is harmless
because `G_k·exp d = T_k`. -/
lemma abs_exp_sub_one_sub_le (z : ℝ) (hz : 0 ≤ z) :
    |Real.exp z - 1 - z| ≤ Real.exp z * z ^ 2 := by
  have h1 : 0 ≤ Real.exp z - 1 - z := by
    have := Real.add_one_le_exp z; linarith
  have h2 : Real.exp z - 1 ≤ Real.exp z * z := by
    have h := Real.add_one_le_exp (-z)
    have he : Real.exp z - 1 = Real.exp z * (1 - Real.exp (-z)) := by
      rw [mul_sub, mul_one, ← Real.exp_add, add_neg_cancel, Real.exp_zero]
    rw [he]
    have : 1 - Real.exp (-z) ≤ z := by linarith
    nlinarith [Real.exp_pos z]
  rw [abs_of_nonneg h1]
  have h3 : Real.exp z - 1 - z ≤ (Real.exp z - 1) * z := by nlinarith
  have h4 : (Real.exp z - 1) * z ≤ Real.exp z * z ^ 2 := by
    have := mul_le_mul_of_nonneg_right h2 hz
    nlinarith [this]
  linarith [h3, h4]



/-- **Sharp termwise bound.**  With `k = j+1 ≤ n`, `x = k/n`, `s = un`, `y = sx²/2` and
`e = s(x²/2 - x + log(1+x))`, one has `T_k = G_k·exp (y - e)` with `0 ≤ e ≤ sx³/3`, hence
`|T_k - G_k - G_k·y| ≤ T_k·y² + G_k·e`. -/
lemma phi_term_sharp (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (j : ℕ) (hj : (j : ℝ) + 1 ≤ (n : ℝ)) (hn : 1 ≤ n) :
    |(1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))
      - Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ)))|
      ≤ Real.exp (-(u * ((j : ℝ) + 1) / 2)) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ))) ^ 2
        + Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 3 / (3 * (n : ℝ) ^ 2)) := by
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hku : (0 : ℝ) ≤ u := by linarith
  set k : ℝ := (j : ℝ) + 1 with hk
  have hk1 : 0 < k := by rw [hk]; positivity
  have hkn : k ≤ (n : ℝ) := by rw [hk]; exact hj
  set x : ℝ := k / (n : ℝ) with hxdef
  have hx0 : 0 < x := by rw [hxdef]; positivity
  have hx1 : x ≤ 1 := by rw [hxdef, div_le_one hnR]; exact hkn
  have h1x : (0 : ℝ) < 1 + x := by linarith
  set s : ℝ := u * (n : ℝ) with hsdef
  have hs0 : 0 ≤ s := by rw [hsdef]; positivity
  have hsx : s * x = u * k := by rw [hsdef, hxdef]; field_simp
  set y : ℝ := s * x ^ 2 / 2 with hydef
  set d : ℝ := s * (x - Real.log (1 + x)) with hddef
  set e : ℝ := y - d with hedef
  have he_eq : e = s * (x ^ 2 / 2 - x + Real.log (1 + x)) := by rw [hedef, hydef, hddef]; ring
  have hlogu : Real.log (1 + x) ≤ x := log_one_add_le x h1x
  have hlogl : x - x ^ 2 / 2 ≤ Real.log (1 + x) := log_one_add_ge x hx0.le
  have hlogc : Real.log (1 + x) ≤ x - (1/2) * x ^ 2 + (1/3) * x ^ 3 :=
    log_one_add_le_cubic x hx0.le
  have he0 : 0 ≤ e := by nlinarith [he_eq, hlogl, hs0]
  have hey : e ≤ y := by nlinarith [he_eq, hydef, hlogu, hs0]
  have hd0 : 0 ≤ d := by linarith [hedef, hey, he0]
  have hyx : y = u * k ^ 2 / (2 * (n : ℝ)) := by rw [hydef, hsdef, hxdef]; field_simp
  have h2 : s * (x ^ 3 / 3) = u * k ^ 3 / (3 * (n : ℝ) ^ 2) := by
    rw [hsdef, hxdef]; field_simp
  have hlogc' : x ^ 2 / 2 - x + Real.log (1 + x) ≤ x ^ 3 / 3 := by linarith [hlogc]
  have hex : e ≤ u * k ^ 3 / (3 * (n : ℝ) ^ 2) := by
    have h1 : s * (x ^ 2 / 2 - x + Real.log (1 + x)) ≤ s * (x ^ 3 / 3) :=
      mul_le_mul_of_nonneg_left hlogc' hs0
    linarith [he_eq, h1, h2]
  have hkey : (1 + x) ^ (-s) = Real.exp (-(u * k)) * Real.exp d := by
    rw [Real.rpow_def_of_pos h1x, ← Real.exp_add]
    congr 1
    rw [hddef, ← hsx]; ring
  have hTle : (1 + x) ^ (-s) ≤ Real.exp (-(u * k) / 2) := by
    rw [Real.rpow_def_of_pos h1x]
    apply Real.exp_le_exp.mpr
    have hlog : x / 2 ≤ Real.log (1 + x) := by nlinarith [hlogl, hx1]
    have hm : s * (x / 2) ≤ s * Real.log (1 + x) := mul_le_mul_of_nonneg_left hlog hs0
    nlinarith [hm, hsx]
  have hTd : Real.exp (-(u * k)) * Real.exp d ≤ Real.exp (-(u * k) / 2) := by
    rw [← hkey]; exact hTle
  have hmain : |(1 + x) ^ (-s) - Real.exp (-(u * k)) - Real.exp (-(u * k)) * y|
      ≤ Real.exp (-(u * k)) * (Real.exp d * y ^ 2) + Real.exp (-(u * k)) * e := by
    rw [hkey]
    have hge : (0 : ℝ) < Real.exp (-(u * k)) := Real.exp_pos _
    have hexp := abs_exp_sub_one_sub_le d hd0
    have hde : Real.exp d - 1 - y = (Real.exp d - 1 - d) - e := by rw [hedef]; ring
    rw [show Real.exp (-(u * k)) * Real.exp d - Real.exp (-(u * k)) - Real.exp (-(u * k)) * y
        = Real.exp (-(u * k)) * (Real.exp d - 1 - y) by ring, hde, abs_mul,
      abs_of_pos hge]
    have h2' : |Real.exp d - 1 - d - e| ≤ |Real.exp d - 1 - d| + |e| := abs_sub _ _
    rw [abs_of_nonneg he0] at h2'
    have h3 : Real.exp d * d ^ 2 ≤ Real.exp d * y ^ 2 := by
      apply mul_le_mul_of_nonneg_left _ (Real.exp_pos d).le
      nlinarith [hd0, hey, hedef]
    have h4 : |Real.exp d - 1 - d - e| ≤ Real.exp d * y ^ 2 + e := by
      linarith [h2', hexp, h3]
    calc Real.exp (-(u * k)) * |Real.exp d - 1 - d - e|
        ≤ Real.exp (-(u * k)) * (Real.exp d * y ^ 2 + e) :=
          mul_le_mul_of_nonneg_left h4 hge.le
      _ = Real.exp (-(u * k)) * (Real.exp d * y ^ 2) + Real.exp (-(u * k)) * e := by ring
  have hup : Real.exp (-(u * k)) * (Real.exp d * y ^ 2) ≤ Real.exp (-(u * k) / 2) * y ^ 2 := by
    have := mul_le_mul_of_nonneg_right hTd (sq_nonneg y)
    rwa [mul_assoc] at this
  have hup2 : Real.exp (-(u * k)) * e ≤ Real.exp (-(u * k)) * (u * k ^ 3 / (3 * (n : ℝ) ^ 2)) :=
    mul_le_mul_of_nonneg_left hex (Real.exp_pos _).le
  have hfin : |(1 + x) ^ (-s) - Real.exp (-(u * k)) - Real.exp (-(u * k)) * y|
      ≤ Real.exp (-(u * k) / 2) * y ^ 2 + Real.exp (-(u * k)) * (u * k ^ 3 / (3 * (n : ℝ) ^ 2)) :=
    le_trans hmain (add_le_add hup hup2)
  rw [hxdef, hk] at hfin
  rw [hk] at hyx
  rw [hyx] at hfin
  convert hfin using 2 <;> (rw [hk]; ring_nf)


/-- The `k⁴` reference constant of the sharp finite part. -/
noncomputable def PhiK4 : ℝ := ∑' k : ℕ, (k : ℝ) ^ 4 * Real.exp (-((k : ℝ) / 4))

/-- The `k³` reference constant of the sharp finite part. -/
noncomputable def PhiK3 : ℝ := ∑' k : ℕ, (k : ℝ) ^ 3 * Real.exp (-((k : ℝ) / 2))

lemma summable_four : Summable (fun k : ℕ => (k : ℝ) ^ 4 * Real.exp (-((k : ℝ) / 4))) := by
  have hr : ‖Real.exp (-(1/4 : ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
  have h := (hasSum_pow_mul_geometric_of_norm_lt_one 4 hr).summable
  refine h.congr (fun k => ?_)
  rw [← Real.exp_nat_mul]; congr 1; ring

lemma summable_three : Summable (fun k : ℕ => (k : ℝ) ^ 3 * Real.exp (-((k : ℝ) / 2))) := by
  have hr : ‖Real.exp (-(1/2 : ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
  have h := (hasSum_pow_mul_geometric_of_norm_lt_one 3 hr).summable
  refine h.congr (fun k => ?_)
  rw [← Real.exp_nat_mul]; congr 1; ring

/-- **Sharp finite part.**  `Σ_{j<n}|T_{j+1} - G_{j+1} - G_{j+1}·y_{j+1}| ≤ (ΦK₄/4 + ΦK₃/3)/n²`. -/
lemma phi_finite_sharp (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 1 ≤ n) :
    (∑ j ∈ Finset.range n,
        |(1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))
          - Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ)))|)
      ≤ (PhiK4 / 4 + PhiK3 / 3) / (n : ℝ) ^ 2 := by
  have hku : (0 : ℝ) ≤ u := by linarith
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hn2 : (0 : ℝ) < (n : ℝ) ^ 2 := by positivity
  have hterm : ∀ j ∈ Finset.range n,
      |(1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))
        - Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ)))|
        ≤ Real.exp (-(u * ((j : ℝ) + 1) / 2)) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ))) ^ 2
          + Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 3 / (3 * (n : ℝ) ^ 2)) := by
    intro j hj
    have hj' : (j : ℝ) + 1 ≤ (n : ℝ) := by
      have := Finset.mem_range.mp hj
      exact_mod_cast (by omega : j + 1 ≤ n)
    exact phi_term_sharp u n hu1 hu2 j hj' hn
  refine le_trans (Finset.sum_le_sum hterm) ?_
  -- bound each of the two sums
  have hA : (∑ j ∈ Finset.range n,
        Real.exp (-(u * ((j : ℝ) + 1) / 2)) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ))) ^ 2)
      ≤ PhiK4 / 4 / (n : ℝ) ^ 2 := by
    have hsplit : (∑ j ∈ Finset.range n,
          Real.exp (-(u * ((j : ℝ) + 1) / 2)) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ))) ^ 2)
        = u ^ 2 / (4 * (n : ℝ) ^ 2) * ∑ j ∈ Finset.range n,
            ((j : ℝ) + 1) ^ 4 * Real.exp (-(u * ((j : ℝ) + 1) / 2)) := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl (fun j _ => by ring)
    rw [hsplit]
    have hle : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 4 * Real.exp (-(u * ((j : ℝ) + 1) / 2)))
        ≤ PhiK4 := by
      have h1 : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 4 * Real.exp (-(u * ((j : ℝ) + 1) / 2)))
          ≤ ∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 4 * Real.exp (-(((j : ℝ) + 1) / 4)) := by
        apply Finset.sum_le_sum; intro j _
        refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by positivity)
        nlinarith [hu1, show (0 : ℝ) < (j : ℝ) + 1 by positivity]
      have h2 : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 4 * Real.exp (-(((j : ℝ) + 1) / 4)))
          = ∑ k ∈ Finset.range (n + 1), (k : ℝ) ^ 4 * Real.exp (-((k : ℝ) / 4)) := by
        rw [Finset.sum_range_succ']; simp
      have h3 : (∑ k ∈ Finset.range (n + 1), (k : ℝ) ^ 4 * Real.exp (-((k : ℝ) / 4))) ≤ PhiK4 := by
        rw [PhiK4]; exact summable_four.sum_le_tsum _ (fun i _ => by positivity)
      exact h1.trans ((le_of_eq h2).trans h3)
    have hfac : u ^ 2 / (4 * (n : ℝ) ^ 2) ≤ 1 / (4 * (n : ℝ) ^ 2) := by
      have hu2sq : u ^ 2 ≤ (1 : ℝ) := by nlinarith [hu2, hku]
      exact div_le_div_of_nonneg_right hu2sq (by positivity)
    have h0 : (0 : ℝ) ≤ PhiK4 := by
      rw [PhiK4]; exact tsum_nonneg (fun k => by positivity)
    calc u ^ 2 / (4 * (n : ℝ) ^ 2) * (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 4 * Real.exp (-(u * ((j : ℝ) + 1) / 2)))
        ≤ u ^ 2 / (4 * (n : ℝ) ^ 2) * PhiK4 := mul_le_mul_of_nonneg_left hle (by positivity)
      _ ≤ 1 / (4 * (n : ℝ) ^ 2) * PhiK4 := mul_le_mul_of_nonneg_right hfac h0
      _ = PhiK4 / 4 / (n : ℝ) ^ 2 := by ring
  have hB : (∑ j ∈ Finset.range n,
        Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 3 / (3 * (n : ℝ) ^ 2)))
      ≤ PhiK3 / 3 / (n : ℝ) ^ 2 := by
    have hsplit : (∑ j ∈ Finset.range n,
          Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 3 / (3 * (n : ℝ) ^ 2)))
        = u / (3 * (n : ℝ) ^ 2) * ∑ j ∈ Finset.range n,
            ((j : ℝ) + 1) ^ 3 * Real.exp (-(u * ((j : ℝ) + 1))) := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl (fun j _ => by ring)
    rw [hsplit]
    have hle : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 3 * Real.exp (-(u * ((j : ℝ) + 1))))
        ≤ PhiK3 := by
      have h1 : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 3 * Real.exp (-(u * ((j : ℝ) + 1))))
          ≤ ∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 3 * Real.exp (-(((j : ℝ) + 1) / 2)) := by
        apply Finset.sum_le_sum; intro j _
        refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by positivity)
        nlinarith [hu1, show (0 : ℝ) < (j : ℝ) + 1 by positivity]
      have h2 : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 3 * Real.exp (-(((j : ℝ) + 1) / 2)))
          = ∑ k ∈ Finset.range (n + 1), (k : ℝ) ^ 3 * Real.exp (-((k : ℝ) / 2)) := by
        rw [Finset.sum_range_succ']; simp
      have h3 : (∑ k ∈ Finset.range (n + 1), (k : ℝ) ^ 3 * Real.exp (-((k : ℝ) / 2))) ≤ PhiK3 := by
        rw [PhiK3]; exact summable_three.sum_le_tsum _ (fun i _ => by positivity)
      exact h1.trans ((le_of_eq h2).trans h3)
    have hfac : u / (3 * (n : ℝ) ^ 2) ≤ 1 / (3 * (n : ℝ) ^ 2) := by
      exact div_le_div_of_nonneg_right hu2 (by positivity)
    have h0 : (0 : ℝ) ≤ PhiK3 := by
      rw [PhiK3]; exact tsum_nonneg (fun k => by positivity)
    calc u / (3 * (n : ℝ) ^ 2) * (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 3 * Real.exp (-(u * ((j : ℝ) + 1))))
        ≤ u / (3 * (n : ℝ) ^ 2) * PhiK3 := mul_le_mul_of_nonneg_left hle (by positivity)
      _ ≤ 1 / (3 * (n : ℝ) ^ 2) * PhiK3 := mul_le_mul_of_nonneg_right hfac h0
      _ = PhiK3 / 3 / (n : ℝ) ^ 2 := by ring
  calc (∑ j ∈ Finset.range n,
        (Real.exp (-(u * ((j : ℝ) + 1) / 2)) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ))) ^ 2
          + Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 3 / (3 * (n : ℝ) ^ 2))))
      = (∑ j ∈ Finset.range n, Real.exp (-(u * ((j : ℝ) + 1) / 2)) * (u * ((j : ℝ) + 1) ^ 2 / (2 * (n : ℝ))) ^ 2)
        + ∑ j ∈ Finset.range n, Real.exp (-(u * ((j : ℝ) + 1))) * (u * ((j : ℝ) + 1) ^ 3 / (3 * (n : ℝ) ^ 2)) :=
        Finset.sum_add_distrib
    _ ≤ PhiK4 / 4 / (n : ℝ) ^ 2 + PhiK3 / 3 / (n : ℝ) ^ 2 := add_le_add hA hB
    _ = (PhiK4 / 4 + PhiK3 / 3) / (n : ℝ) ^ 2 := by ring

/-! ### Summability of the `Phi` summand -/

/-- The `Phi` summand is summable whenever `u·n ≥ 2`. -/
lemma summable_phi (u : ℝ) (n : ℕ) (hn : 1 ≤ n) (hun : 2 ≤ u * (n : ℝ)) :
    Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))) := by
  have hbase : Summable (fun j : ℕ => (((j : ℝ) + 1)) ^ (-(2 : ℝ))) :=
    summable_shifted 2 (by norm_num : 2 ≤ 2)
  refine Summable.of_nonneg_of_le (fun j => Real.rpow_nonneg (by positivity) _)
    (fun j => ?_) (hbase.mul_left ((n : ℝ) ^ 2))
  have hx0 : (0 : ℝ) < ((j : ℝ) + 1) / (n : ℝ) := by positivity
  have hx1 : (1 : ℝ) ≤ 1 + (((j : ℝ) + 1) / (n : ℝ)) := by linarith
  have hmono : (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
      ≤ (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2 : ℝ)) :=
    Real.rpow_le_rpow_of_exponent_le hx1 (by linarith)
  have h2 : (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2 : ℝ))
      ≤ (((j : ℝ) + 1) / (n : ℝ)) ^ (-(2 : ℝ)) :=
    Real.rpow_le_rpow_of_nonpos hx0 (by linarith) (by norm_num : (-(2 : ℝ)) ≤ 0)
  have h3 : (((j : ℝ) + 1) / (n : ℝ)) ^ (-(2 : ℝ))
      = (n : ℝ) ^ 2 * (((j : ℝ) + 1)) ^ (-(2 : ℝ)) := by
    rw [Real.div_rpow (by positivity) (by positivity)]
    rw [Real.rpow_neg (by positivity), Real.rpow_neg (by positivity)]
    rw [div_inv_eq_mul, mul_comm, Real.rpow_two]
  calc (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
      ≤ (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(2 : ℝ)) := hmono
    _ ≤ (((j : ℝ) + 1) / (n : ℝ)) ^ (-(2 : ℝ)) := h2
    _ = (n : ℝ) ^ 2 * (((j : ℝ) + 1)) ^ (-(2 : ℝ)) := h3

/-! ### The polynomially-decaying tail (integral comparison)

The tail `Σ_{k>n}(1+k/n)^{-un}` does **not** decay geometrically: the consecutive ratio
`(1+1/(n+k))^{-un}` tends to `1`.  It decays polynomially, like `(n+k)^{-un}` with the
large exponent `un ≥ n/2`, so it is bounded here by an integral. -/

/-- `Σ_m (m + 2n + 1)^{-s} ≤ (2n)^{1-s}/(s-1)` for `s > 1`, `n ≥ 1`. -/
lemma sum_rpow_tail_le (n : ℕ) (s : ℝ) (hs : 1 < s) (hn : 1 ≤ n) :
    (∑' m : ℕ, (((m + 2*n + 1 : ℕ) : ℝ)) ^ (-s))
      ≤ ((2*(n:ℝ)) ^ (1 - s)) / (s - 1) := by
  have hNpos : (0:ℝ) < (((2*n : ℕ)) : ℝ) := by positivity
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-s)) (Set.Ici (((2*n : ℕ)) : ℝ)) := by
    intro a ha b hb hab
    exact Real.rpow_le_rpow_of_nonpos (by linarith [Set.mem_Ici.mp ha, hNpos] : (0:ℝ) < a)
      hab (by linarith)
  have hint : IntegrableOn (fun x : ℝ => x ^ (-s)) (Set.Ioi (((2*n : ℕ)) : ℝ)) volume :=
    integrableOn_Ioi_rpow_of_lt (by linarith : (-s) < -1) hNpos
  have hnn : ∀ t ∈ Set.Ioi (((2*n : ℕ)) : ℝ), 0 ≤ t ^ (-s) := by
    intro t ht
    exact Real.rpow_nonneg (le_of_lt (by linarith [Set.mem_Ioi.mp ht, hNpos])) _
  have h := AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ (-s)) (2*n) hanti hint hnn
  have hval : ∫ x : ℝ in Set.Ioi (((2*n : ℕ)) : ℝ), x ^ (-s)
      = (((2*n : ℕ)) : ℝ) ^ (1 - s) / (s - 1) := by
    rw [integral_Ioi_rpow_of_lt (by linarith : (-s) < -1) hNpos, show -s + 1 = 1 - s by ring,
        show (1:ℝ) - s = -(s - 1) by ring, div_neg]
    ring
  rw [hval] at h
  refine le_trans h (le_of_eq ?_)
  rw [show (((2*n : ℕ)) : ℝ) = 2*(n:ℝ) by push_cast; ring]

/-- **The `Phi` tail beyond `n`.**  `Σ_m (1 + (m+n+1)/n)^{-un} ≤ n·2^{1-un}/(un-1)`. -/
lemma phi_tail_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 3 ≤ n) :
    (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
      ≤ (n : ℝ) * (2 : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1) := by
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hnR3 : (3 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hs1 : 1 < u * (n : ℝ) := by nlinarith [hu1, hnR3]
  have hterm : ∀ m : ℕ,
      (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
        = (n : ℝ) ^ (u * (n : ℝ)) * ((((m + 2*n + 1 : ℕ)) : ℝ)) ^ (-(u * (n : ℝ))) := by
    intro m
    have hx : (0 : ℝ) < ((m : ℝ) + 2 * (n : ℝ) + 1) := by positivity
    have h1 : 1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))
        = ((m : ℝ) + 2 * (n : ℝ) + 1) / (n : ℝ) := by field_simp; ring
    rw [h1, Real.div_rpow hx.le hnR.le, Real.rpow_neg hnR.le, Real.rpow_neg hx.le,
        div_inv_eq_mul, mul_comm]
    push_cast
    rw [Real.rpow_neg hx.le]
  have hstep : (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
      = (n : ℝ) ^ (u * (n : ℝ))
        * ∑' m : ℕ, ((((m + 2*n + 1 : ℕ)) : ℝ)) ^ (-(u * (n : ℝ))) := by
    rw [show (fun m : ℕ => (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
        = (fun m : ℕ => (n : ℝ) ^ (u * (n : ℝ))
            * ((((m + 2*n + 1 : ℕ)) : ℝ)) ^ (-(u * (n : ℝ)))) from funext hterm]
    rw [tsum_mul_left]
  rw [hstep]
  have htail := sum_rpow_tail_le n (u * (n : ℝ)) hs1 (by omega : 1 ≤ n)
  have hfac : (0 : ℝ) ≤ (n : ℝ) ^ (u * (n : ℝ)) := by positivity
  refine le_trans (mul_le_mul_of_nonneg_left htail hfac) (le_of_eq ?_)
  rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 2) hnR.le]
  have hsum : (n : ℝ) ^ (u * (n : ℝ)) * (n : ℝ) ^ (1 - u * (n : ℝ)) = (n : ℝ) := by
    rw [← Real.rpow_add hnR, show u * (n : ℝ) + (1 - u * (n : ℝ)) = 1 by ring, Real.rpow_one]
  calc (n : ℝ) ^ (u * (n : ℝ))
        * ((2 : ℝ) ^ (1 - u * (n : ℝ)) * (n : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1))
      = ((n : ℝ) ^ (u * (n : ℝ)) * (n : ℝ) ^ (1 - u * (n : ℝ)))
          * ((2 : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1)) := by ring
    _ = (n : ℝ) * ((2 : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1)) := by rw [hsum]
    _ = (n : ℝ) * (2 : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1) := by ring


/-- `n ≤ 2^{n/2}` for `n ≥ 4` (step-2 induction with bases `n = 4, 5`). -/
lemma nat_le_two_rpow_half (n : ℕ) (hn : 4 ≤ n) : (n : ℝ) ≤ (2 : ℝ) ^ ((n : ℝ) / 2) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases lt_or_ge n 6 with h | h
    · interval_cases n
      · norm_num [Real.rpow_natCast]
      · have h2 : (2 : ℝ) ^ (((5 : ℕ) : ℝ) / 2) = 4 * Real.sqrt 2 := by
          rw [show (((5 : ℕ) : ℝ)) / 2 = 2 + 1 / 2 by norm_num, Real.rpow_add (by norm_num),
              Real.rpow_two, ← Real.sqrt_eq_rpow]
          norm_num
        rw [h2]
        have hmul : (5 : ℝ) ≤ 4 * Real.sqrt 2 := by
          have hle : (5 : ℝ) / 4 ≤ Real.sqrt 2 :=
            Real.le_sqrt_of_sq_le (by norm_num : ((5 : ℝ) / 4) ^ 2 ≤ 2)
          nlinarith [hle]
        exact_mod_cast hmul
    · have hn2 : 2 ≤ n := by omega
      have h4 : 4 ≤ n - 2 := by omega
      have hlt : n - 2 < n := by omega
      have hih := ih (n - 2) hlt h4
      have hcast : ((n - 2 : ℕ) : ℝ) = (n : ℝ) - 2 := by
        push_cast [Nat.cast_sub hn2]; ring
      rw [hcast] at hih
      have hnR : (4 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
      have hsplit : (n : ℝ) / 2 = ((n : ℝ) - 2) / 2 + 1 := by ring
      rw [hsplit, Real.rpow_add (by norm_num), Real.rpow_one]
      have hge : (2 : ℝ) ≤ (2 : ℝ) ^ (((n : ℝ) - 2) / 2) := by
        have h1 : (2 : ℝ) ^ (1 : ℝ) ≤ (2 : ℝ) ^ (((n : ℝ) - 2) / 2) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2) (by linarith)
        simpa using h1
      linarith

/-- **The `Phi` tail is `O(1/n)`.**  `Σ_m (1 + (m+n+1)/n)^{-un} ≤ 8/n` for `n ≥ 4`. -/
lemma phi_tail_le_div (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 4 ≤ n) :
    (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
      ≤ 8 / (n : ℝ) := by
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hnR4 : (4 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have htail := phi_tail_le u n hu1 (by omega : 3 ≤ n)
  refine le_trans htail ?_
  have hbound : (2 : ℝ) ^ (1 - u * (n : ℝ)) ≤ 2 / (n : ℝ) := by
    have h1 : (2 : ℝ) ^ (1 - u * (n : ℝ)) ≤ (2 : ℝ) ^ (1 - (n : ℝ) / 2) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2)
        (by nlinarith [hu1, hnR])
    have h2 : (2 : ℝ) ^ (1 - (n : ℝ) / 2) = 2 / (2 : ℝ) ^ ((n : ℝ) / 2) := by
      rw [show 1 - (n : ℝ) / 2 = 1 + (-((n : ℝ) / 2)) by ring, Real.rpow_add (by norm_num),
          Real.rpow_one, Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2), div_eq_mul_inv]
      ring
    have h3 : (n : ℝ) ≤ (2 : ℝ) ^ ((n : ℝ) / 2) := nat_le_two_rpow_half n hn
    have h4 : (0 : ℝ) < (2 : ℝ) ^ ((n : ℝ) / 2) := by positivity
    rw [h2] at h1
    refine le_trans h1 ?_
    rw [div_le_div_iff₀ h4 hnR]
    linarith
  have hBD : (n : ℝ) * (2 : ℝ) ^ (1 - u * (n : ℝ)) ≤ 2 := by
    have hm := mul_le_mul_of_nonneg_left hbound hnR.le
    rwa [mul_div_cancel₀ _ (ne_of_gt hnR)] at hm
  have hD : (0 : ℝ) < u * (n : ℝ) - 1 := by nlinarith [hu1, hnR4]
  have hD4 : (0 : ℝ) < (n : ℝ) / 4 := by linarith
  have hden : (n : ℝ) / 4 ≤ u * (n : ℝ) - 1 := by nlinarith [hu1, hnR4]
  rw [div_le_div_iff₀ hD hnR]
  nlinarith [hBD, hden, hnR]


/-! ### The finite part -/

/-- **Termwise finite bound.**  With `y = u k²/(2n)`, the upper comparison gives
`T_k ≤ exp (-(uk) + y)`, so `T_k - exp (-uk) ≤ exp (-uk)(exp y - 1) ≤ exp (-uk)·y·exp y`,
and since `y ≤ uk/2` (as `k ≤ n`) the last factor is `exp (-uk)·exp y ≤ exp (-uk/2)`.
Hence `T_k - exp (-uk) ≤ y·exp (-uk/2)`. -/
lemma phi_term_diff_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (j : ℕ) (hj : (j : ℝ) + 1 ≤ (n : ℝ)) (hn : 1 ≤ n) :
    (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))
      ≤ u * ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)) / (2 * (n : ℝ)) := by
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hku : (0 : ℝ) ≤ u := by linarith
  set k : ℝ := (j : ℝ) + 1 with hk
  have hk1 : 0 < k := by rw [hk]; positivity
  have hkn : k ≤ (n : ℝ) := by rw [hk]; exact hj
  have hx : (0 : ℝ) ≤ k / (n : ℝ) := by positivity
  have hT := rpow_le_exp_neg_add u hku n (k / (n : ℝ)) hx
  have e1 : u * (n : ℝ) * (k / (n : ℝ)) = u * k := by field_simp
  have e2 : u * (n : ℝ) * (k / (n : ℝ)) ^ 2 / 2 = u * k ^ 2 / (2 * (n : ℝ)) := by
    field_simp
  rw [e1, e2] at hT
  set y : ℝ := u * k ^ 2 / (2 * (n : ℝ)) with hydef
  have hy0 : 0 ≤ y := by rw [hydef]; positivity
  have hyk : y ≤ u * k / 2 := by
    rw [hydef, div_le_iff₀ (by positivity : (0:ℝ) < 2 * (n:ℝ))]
    have h := mul_le_mul_of_nonneg_left hkn (by positivity : (0:ℝ) ≤ u * k)
    nlinarith [h, hk1, hnR]
  have hdiff : Real.exp y - 1 ≤ y * Real.exp y := by
    have h := Real.add_one_le_exp (-y)
    have he : Real.exp y - 1 = Real.exp y * (1 - Real.exp (-y)) := by
      rw [mul_sub, mul_one, ← Real.exp_add, add_neg_cancel, Real.exp_zero]
    rw [he]
    have h1 : 1 - Real.exp (-y) ≤ y := by linarith
    nlinarith [Real.exp_pos y]
  have hexp : Real.exp (-(u * k)) * Real.exp y ≤ Real.exp (-(u * k) / 2) := by
    rw [← Real.exp_add]
    apply Real.exp_le_exp.mpr
    linarith [hyk]
  have hG : (0 : ℝ) < Real.exp (-(u * k)) := Real.exp_pos _
  have h1 : Real.exp (-(u * k) + y) - Real.exp (-(u * k))
      ≤ Real.exp (-(u * k)) * (y * Real.exp y) := by
    rw [Real.exp_add]
    nlinarith [hdiff, hG]
  have h3 : Real.exp (-(u * k)) * (y * Real.exp y) ≤ Real.exp (-(u * k) / 2) * y := by
    nlinarith [hexp, hy0, hG, Real.exp_pos y]
  have h4 : Real.exp (-(u * k) / 2) * y
      = u * k ^ 2 * Real.exp (-(u * k / 2)) / (2 * (n : ℝ)) := by
    rw [hydef, show -(u * k) / 2 = -(u * k / 2) by ring]; field_simp
  rw [hk] at hT h1 h3 h4
  calc (1 + (↑j + 1) / (n : ℝ)) ^ (-(u * (n : ℝ))) - Real.exp (-(u * (↑j + 1)))
      ≤ Real.exp (-(u * (↑j + 1)) + y) - Real.exp (-(u * (↑j + 1))) := by linarith [hT]
    _ ≤ Real.exp (-(u * (↑j + 1))) * (y * Real.exp y) := h1
    _ ≤ Real.exp (-(u * (↑j + 1)) / 2) * y := h3
    _ = u * (↑j + 1) ^ 2 * Real.exp (-(u * (↑j + 1) / 2)) / (2 * (n : ℝ)) := h4


/-- **Finite part.**  `Σ_{j<n}(T_{j+1} - e^{-u(j+1)}) ≤ S/(2n)` with
`S = Σ'_k k²·exp(-k/4)`. -/
lemma phi_finite_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 1 ≤ n) :
    (∑ j ∈ Finset.range n,
        ((1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))))
      ≤ (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) / (2 * (n : ℝ)) := by
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hS : Summable (fun k : ℕ => (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) := by
    have hr : ‖Real.exp (-(1/4 : ℝ))‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
    have h := (hasSum_sq_mul_geometric_of_norm_lt_one hr).summable
    refine h.congr (fun k => ?_)
    rw [← Real.exp_nat_mul]; congr 1; ring
  have hterm : ∀ j ∈ Finset.range n,
      (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))
        ≤ u * ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)) / (2 * (n : ℝ)) := by
    intro j hj
    have hj' : (j : ℝ) + 1 ≤ (n : ℝ) := by
      have := Finset.mem_range.mp hj
      exact_mod_cast (by omega : j + 1 ≤ n)
    exact phi_term_diff_le u n hu1 hu2 j hj' hn
  refine le_trans (Finset.sum_le_sum hterm) ?_
  have hsum_eq : (∑ j ∈ Finset.range n,
        u * ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)) / (2 * (n : ℝ)))
      = u / (2 * (n : ℝ)) * ∑ j ∈ Finset.range n,
          ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)) := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl (fun j _ => by ring)
  rw [hsum_eq]
  have hstep : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)))
      ≤ ∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4)) := by
    have h1 : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)))
        ≤ ∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 2 * Real.exp (-(((j : ℝ) + 1) / 4)) := by
      apply Finset.sum_le_sum; intro j _
      refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by positivity)
      nlinarith [hu1, show (0 : ℝ) < (j : ℝ) + 1 by positivity]
    have h2 : (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 2 * Real.exp (-(((j : ℝ) + 1) / 4)))
        = ∑ k ∈ Finset.range (n + 1), (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4)) := by
      rw [Finset.sum_range_succ']; simp
    have h3 : (∑ k ∈ Finset.range (n + 1), (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4)))
        ≤ ∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4)) :=
      hS.sum_le_tsum _ (fun i _ => by positivity)
    exact h1.trans ((le_of_eq h2).trans h3)
  have hb : (0 : ℝ) ≤ ∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4)) :=
    tsum_nonneg (fun k => by positivity)
  have hfac : u / (2 * (n : ℝ)) ≤ 1 / (2 * (n : ℝ)) := by
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [hu2, hnR]
  calc u / (2 * (n : ℝ))
        * (∑ j ∈ Finset.range n, ((j : ℝ) + 1) ^ 2 * Real.exp (-(u * ((j : ℝ) + 1) / 2)))
      ≤ u / (2 * (n : ℝ)) * (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) :=
        mul_le_mul_of_nonneg_left hstep (by positivity)
    _ ≤ 1 / (2 * (n : ℝ)) * (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) :=
        mul_le_mul_of_nonneg_right hfac hb
    _ = (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) / (2 * (n : ℝ)) := by ring


/-- **Polynomial decay of `n⁴·exp(−un)`.**  For `u ≥ 1/2` and any `c > 0`, eventually
`n⁴·exp(−un) ≤ c`.  This is `tendsto_pow_const_mul_const_pow_of_lt_one`, so no explicit
constant is needed. -/
lemma eventually_pow_four_exp_le (u : ℝ) (hu1 : 1/2 ≤ u) (c : ℝ) (hc : 0 < c) :
    ∀ᶠ n : ℕ in Filter.atTop, (n : ℝ) ^ 4 * Real.exp (-(u * (n : ℝ))) ≤ c := by
  have ht := tendsto_pow_const_mul_const_pow_of_lt_one 4 (r := Real.exp (-(1/2 : ℝ)))
      (Real.exp_pos _).le (by rw [Real.exp_lt_one_iff]; norm_num)
  have h0 : ∀ᶠ n : ℕ in Filter.atTop, (n : ℝ) ^ 4 * (Real.exp (-(1/2 : ℝ))) ^ n < c :=
    (tendsto_order.1 ht).2 _ hc
  filter_upwards [h0] with n hn
  have h1 : (n : ℝ) ^ 4 * Real.exp (-(u * (n : ℝ)))
      ≤ (n : ℝ) ^ 4 * (Real.exp (-(1/2 : ℝ))) ^ n := by
    apply mul_le_mul_of_nonneg_left _ (by positivity)
    rw [← Real.exp_nat_mul]
    apply Real.exp_le_exp.mpr
    nlinarith [hu1, (Nat.cast_nonneg n : (0 : ℝ) ≤ (n : ℝ))]
  linarith [h1, hn]




lemma PhiK3_nonneg : 0 ≤ PhiK3 := by rw [PhiK3]; exact tsum_nonneg (fun k => by positivity)

lemma PhiK4_nonneg : 0 ≤ PhiK4 := by rw [PhiK4]; exact tsum_nonneg (fun k => by positivity)

lemma summable_three_shift : Summable (fun i : ℕ => ((i : ℝ) + 1) ^ 3 * Real.exp (-((i : ℝ) / 2))) := by
  have hr : ‖Real.exp (-(1/2 : ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
  have h := (summable_pow_mul_geometric_of_norm_lt_one 3 hr)
  have h2 : Summable (fun i : ℕ => ((i : ℝ) + 1) ^ 3 * (Real.exp (-(1/2 : ℝ))) ^ (i + 1)) := by
    have h3 := (summable_nat_add_iff 1).mpr h
    exact h3.congr (fun i => by rw [Nat.cast_add, Nat.cast_one])
  have h4 := h2.mul_left ((Real.exp (-(1/2 : ℝ)))⁻¹)
  refine h4.congr (fun i => ?_)
  rw [← Real.exp_nat_mul]
  have hr0 : Real.exp (-(1/2 : ℝ)) ≠ 0 := Real.exp_ne_zero _
  field_simp
  rw [← Real.exp_add]
  congr 1
  push_cast
  ring

lemma tsum_three_shift_eq : (∑' i : ℕ, ((i : ℝ) + 1) ^ 3 * Real.exp (-((i : ℝ) / 2)))
    = Real.exp (1/2) * PhiK3 := by
  have h := summable_three.tsum_eq_zero_add
  unfold PhiK3
  rw [h]
  simp only [Nat.cast_zero, zero_pow (by norm_num : 3 ≠ 0), mul_zero, Real.exp_zero, mul_one,
    zero_add]
  rw [show (∑' b : ℕ, (↑(b + 1) : ℝ) ^ 3 * Real.exp (-((↑(b + 1) : ℝ) / 2)))
      = Real.exp (-(1/2)) * (∑' i : ℕ, ((i : ℝ) + 1) ^ 3 * Real.exp (-((i : ℝ) / 2))) from by
    rw [← tsum_mul_left]
    apply tsum_congr; intro b
    push_cast
    rw [show -(((b : ℝ) + 1) / 2) = -(b : ℝ) / 2 + -(1 / 2) by ring, Real.exp_add]
    ring]
  rw [show (0:ℝ) * Real.exp (-(0/2)) = 0 by ring, zero_add, ← mul_assoc, ← Real.exp_add,
    add_neg_cancel, Real.exp_zero, one_mul]


lemma tsum_three_shift_le : (∑' i : ℕ, ((i : ℝ) + 1) ^ 3 * Real.exp (-((i : ℝ) / 2)))
    ≤ 2 * PhiK3 := by
  rw [tsum_three_shift_eq]
  have h2 : Real.exp (1/2 : ℝ) ≤ 2 := by
    have hlog : (1/2 : ℝ) ≤ Real.log 2 := by
      have := Real.one_sub_inv_le_log_of_pos (by norm_num : (0 : ℝ) < 2)
      norm_num at this
      linarith
    calc Real.exp (1/2 : ℝ) ≤ Real.exp (Real.log 2) := Real.exp_le_exp.mpr hlog
      _ = 2 := Real.exp_log (by norm_num)
  nlinarith [PhiK3_nonneg, h2]


/-- **The `k > n` tail of `Σ k²e^{−uk}` is `O(1/n²)`.** -/
lemma phi_S_tail_bound (u : ℝ) (hu1 : 1/2 ≤ u) :
    ∀ᶠ n : ℕ in Filter.atTop,
      (∑' i : ℕ, (((n + 1 + i : ℕ)) : ℝ) ^ 2 * Real.exp (-(u * (((n + 1 + i : ℕ)) : ℝ))))
        ≤ 1 / (n : ℝ) ^ 2 := by
  have h8 : (0 : ℝ) < 8 * (PhiK3 + 1) := by linarith [PhiK3_nonneg]
  have hev := eventually_pow_four_exp_le u hu1 (1/(8*(PhiK3+1))) (div_pos one_pos h8)
  have hS2 : Summable (fun k : ℕ => (k : ℝ) ^ 2 * Real.exp (-(u * (k : ℝ)))) := by
    have hr : ‖Real.exp (-u)‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      linarith [hu1]
    have h := (summable_pow_mul_geometric_of_norm_lt_one 2 hr)
    refine h.congr (fun k => ?_)
    rw [← Real.exp_nat_mul]; congr 1; ring
  filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
  have hnR : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn1
  have hLHS : Summable (fun i : ℕ =>
      (((n + 1 + i : ℕ)) : ℝ) ^ 2 * Real.exp (-(u * (((n + 1 + i : ℕ)) : ℝ)))) := by
    have h := (summable_nat_add_iff (n + 1)).mpr hS2
    have h' : (fun i : ℕ => (↑(i + (n+1)) : ℝ)^2 * Real.exp (-(u*↑(i+(n+1)))))
        = (fun i : ℕ => (↑(n+1+i) : ℝ)^2 * Real.exp (-(u*↑(n+1+i)))) := by
      funext i; rw [Nat.add_comm i (n+1)]
    rw [h'] at h
    exact h
  have hmaj : Summable (fun i : ℕ => ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1)))
      * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2)))) := summable_three_shift.mul_left _
  have hterm : ∀ i : ℕ,
      (((n + 1 + i : ℕ)) : ℝ) ^ 2 * Real.exp (-(u * (((n + 1 + i : ℕ)) : ℝ)))
        ≤ ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) := by
    intro i
    have hcast : (((n + 1 + i : ℕ)) : ℝ) = (n:ℝ) + 1 + i := by push_cast; ring
    have hi0 : (0 : ℝ) ≤ (i : ℝ) := Nat.cast_nonneg i
    have h1 : ((n:ℝ)+1+i)^2 ≤ ((n:ℝ)+1)^2 * ((i:ℝ)+1)^2 := by
      rw [← mul_pow]
      apply pow_le_pow_left₀ (by positivity)
      nlinarith [hnR, hi0, mul_nonneg hnR.le hi0]
    have h2 : ((i:ℝ)+1)^2 * Real.exp (-((i:ℝ)/2))
        ≤ ((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2)) :=
      mul_le_mul_of_nonneg_right (by nlinarith [hi0]) (Real.exp_pos _).le
    have h3 : Real.exp (-(u*(i:ℝ))) ≤ Real.exp (-((i:ℝ)/2)) :=
      Real.exp_le_exp.mpr (by nlinarith [hu1, hi0])
    rw [hcast, show -(u*((n:ℝ)+1+i)) = -(u*((n:ℝ)+1)) + -(u*(i:ℝ)) by ring, Real.exp_add]
    calc ((n:ℝ)+1+i)^2 * (Real.exp (-(u*((n:ℝ)+1))) * Real.exp (-(u*(i:ℝ))))
        = (Real.exp (-(u*((n:ℝ)+1))) * ((n:ℝ)+1+i)^2) * Real.exp (-(u*(i:ℝ))) := by ring
      _ ≤ (Real.exp (-(u*((n:ℝ)+1))) * (((n:ℝ)+1)^2 * ((i:ℝ)+1)^2)) * Real.exp (-((i:ℝ)/2)) :=
          mul_le_mul (mul_le_mul_of_nonneg_left h1 (Real.exp_pos _).le) h3
            (Real.exp_pos _).le (by positivity)
      _ = ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (((i:ℝ)+1)^2 * Real.exp (-((i:ℝ)/2))) := by ring
      _ ≤ ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) :=
          mul_le_mul_of_nonneg_left h2 (by positivity)
  have h1 := hLHS.tsum_le_tsum hterm hmaj
  have h2 : (∑' i : ℕ, ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1)))
      * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))))
      = ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1)))
        * (∑' i : ℕ, ((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) := tsum_mul_left
  rw [h2] at h1
  have h3 : (∑' i : ℕ, ((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) ≤ 2 * PhiK3 := tsum_three_shift_le
  have h4 : (0 : ℝ) ≤ ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) := by positivity
  have h5 := mul_le_mul_of_nonneg_left h3 h4
  have hn1R : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
  have h6 : ((n:ℝ)+1)^2 ≤ 4 * (n:ℝ)^2 := by nlinarith [hn1R, sq_nonneg (n:ℝ)]
  have h7 : Real.exp (-(u*((n:ℝ)+1))) ≤ Real.exp (-(u*(n:ℝ))) :=
    Real.exp_le_exp.mpr (by nlinarith [hu1])
  have hA : ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (2 * PhiK3)
      ≤ 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) := by
    have hstep : ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) ≤ 4 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) :=
      mul_le_mul h6 h7 (Real.exp_pos _).le (by positivity)
    calc ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (2 * PhiK3)
        ≤ 4 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) * (2 * PhiK3) :=
          mul_le_mul_of_nonneg_right hstep (by linarith [PhiK3_nonneg])
      _ = 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) := by ring
  have hB : 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) ≤ 1 / (n:ℝ)^2 := by
    rw [le_div_iff₀ (by positivity)]
    have hnp : 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) * (n:ℝ)^2
        = 8 * PhiK3 * ((n:ℝ)^4 * Real.exp (-(u*(n:ℝ)))) := by ring
    rw [hnp]
    have hm := mul_le_mul_of_nonneg_left hn (by linarith [PhiK3_nonneg] : (0:ℝ) ≤ 8 * PhiK3)
    have h10 : 8 * PhiK3 * (1/(8*(PhiK3+1))) ≤ 1 := by
      rw [mul_one_div, div_le_one (by linarith [PhiK3_nonneg])]
      linarith [PhiK3_nonneg]
    linarith [hm, h10]
  linarith [h1, h5, hA, hB]


/-- The reference sum `Σ' k²e^{−uk}` of the sharp expansion. -/
noncomputable def PhiS (u : ℝ) : ℝ := ∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-(u * (k : ℝ)))

lemma summable_S (u : ℝ) (hu : 0 < u) :
    Summable (fun k : ℕ => (k : ℝ) ^ 2 * Real.exp (-(u * (k : ℝ)))) := by
  have hr : ‖Real.exp (-u)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    linarith
  have h := (summable_pow_mul_geometric_of_norm_lt_one 2 hr)
  refine h.congr (fun k => ?_)
  rw [← Real.exp_nat_mul]; congr 1; ring

/-- **Sharp finite `G·y` sum.**  `Σ_{j<n} G_{j+1}y_{j+1} = (u/2n)·ΦS(u) + O(1/n²)`. -/
lemma phi_S_finite_part (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    ∀ᶠ n : ℕ in Filter.atTop,
      |(∑ j ∈ Finset.range n, Real.exp (-(u*((j:ℝ)+1))) * (u*((j:ℝ)+1)^2/(2*(n:ℝ))))
        - u/(2*(n:ℝ)) * PhiS u| ≤ 1 / (n:ℝ)^2 := by
  have hu0 : 0 < u := by linarith
  have hS : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))) := summable_S u hu0
  have hev := phi_S_tail_bound u hu1
  filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
  have hnR : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn1
  have hn1R : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn1
  set T : ℝ := ∑' i : ℕ, (((n+1+i : ℕ)):ℝ)^2 * Real.exp (-(u*(((n+1+i:ℕ)):ℝ))) with hT
  have hT0 : 0 ≤ T := by
    rw [hT]; exact tsum_nonneg (fun i => by positivity)
  have hsum : (∑ j ∈ Finset.range n, Real.exp (-(u*((j:ℝ)+1))) * (u*((j:ℝ)+1)^2/(2*(n:ℝ))))
      = u/(2*(n:ℝ)) * (∑ j ∈ Finset.range n, ((j:ℝ)+1)^2 * Real.exp (-(u*((j:ℝ)+1)))) := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl (fun j _ => by ring)
  have hbase : (∑ j ∈ Finset.range n, ((j:ℝ)+1)^2 * Real.exp (-(u*((j:ℝ)+1))))
      = PhiS u - T := by
    have h := hS.sum_add_tsum_nat_add (n+1)
    rw [Finset.sum_range_succ'] at h
    simp only [Nat.cast_zero, zero_pow (by norm_num : 2 ≠ 0), mul_zero, Real.exp_zero, mul_one,
      zero_add] at h
    have hT2 : T = ∑' i : ℕ, (↑(i + (n+1)) : ℝ)^2 * Real.exp (-(u*↑(i+(n+1)))) := by
      rw [hT]
      apply tsum_congr; intro i
      rw [Nat.add_comm (n+1) i]
    have h2 : (∑ j ∈ Finset.range n, ((j:ℝ)+1)^2 * Real.exp (-(u*((j:ℝ)+1))))
        = ∑ j ∈ Finset.range n, (↑(j+1) : ℝ)^2 * Real.exp (-(u*↑(j+1))) := by
      exact Finset.sum_congr rfl (fun j _ => by push_cast; ring)
    rw [PhiS, hT2, h2]
    linarith [h]
  rw [hsum, hbase]
  have hkey : u/(2*(n:ℝ)) * (PhiS u - T) - u/(2*(n:ℝ)) * PhiS u = -(u/(2*(n:ℝ))) * T := by ring
  rw [hkey, abs_mul, abs_neg, abs_of_pos (by positivity : (0:ℝ) < u/(2*(n:ℝ))), abs_of_nonneg hT0]
  have hstep1 : u/(2*(n:ℝ)) * T ≤ (1/(2*(n:ℝ))) * T := by
    apply mul_le_mul_of_nonneg_right _ hT0
    exact div_le_div_of_nonneg_right hu2 (by positivity)
  have hstep2 : (1/(2*(n:ℝ))) * T ≤ (1/(2*(n:ℝ))) * (1/(n:ℝ)^2) :=
    mul_le_mul_of_nonneg_left hn (by positivity)
  have hstep3 : (1/(2*(n:ℝ))) * (1/(n:ℝ)^2) ≤ 1/(n:ℝ)^2 := by
    rw [div_mul_eq_mul_div, one_mul, div_le_iff₀ (by positivity)]
    nlinarith [hn1R, hnR, sq_nonneg (n:ℝ)]
  exact hstep1.trans (hstep2.trans hstep3)


/-- **Polynomial × exponential decay.**  For `u > 0`, `k : ℕ` and any `c > 0`, eventually
`nᵏ·exp(−un) ≤ c`. -/
lemma eventually_pow_exp_le (u : ℝ) (hu : 0 < u) (k : ℕ) (c : ℝ) (hc : 0 < c) :
    ∀ᶠ n : ℕ in Filter.atTop, (n : ℝ) ^ k * Real.exp (-(u * (n : ℝ))) ≤ c := by
  have ht := tendsto_pow_const_mul_const_pow_of_lt_one k (Real.exp_pos (-u)).le
    (by rw [Real.exp_lt_one_iff]; linarith)
  have h0 : ∀ᶠ n : ℕ in Filter.atTop, (n : ℝ) ^ k * (Real.exp (-u)) ^ n < c :=
    (tendsto_order.1 ht).2 _ hc
  filter_upwards [h0] with n hn
  have h1 : (n : ℝ) ^ k * Real.exp (-(u * (n : ℝ))) = (n : ℝ) ^ k * (Real.exp (-u)) ^ n := by
    rw [← Real.exp_nat_mul]; congr 1; ring
  linarith [h1 ▸ hn]


/-- **The `Phi` tail is `O(1/n²)`.** -/
lemma phi_tail_le_eventually (u : ℝ) (hu1 : 1/2 ≤ u) :
    ∀ᶠ n : ℕ in Filter.atTop,
      (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
        ≤ 1 / (n : ℝ) ^ 2 := by
  have hu0 : 0 < u/2 := by linarith
  have hev := eventually_pow_exp_le (u/2) hu0 2 (1/8) (by norm_num)
  filter_upwards [hev, Filter.eventually_ge_atTop 4] with n hn hn4
  have hnR : (0 : ℝ) < (n : ℝ) := by exact_mod_cast (by omega : 0 < n)
  have hn4R : (4 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn4
  have hlog2 : (1/2 : ℝ) ≤ Real.log 2 := by
    have := Real.one_sub_inv_le_log_of_pos (by norm_num : (0 : ℝ) < 2)
    norm_num at this; linarith
  have hden : (0 : ℝ) < u * (n : ℝ) - 1 := by
    have h : (1/2:ℝ) * 4 ≤ u * (n:ℝ) :=
      mul_le_mul hu1 hn4R (by norm_num) (le_trans (by norm_num : (0:ℝ) ≤ 1/2) hu1)
    linarith
  -- (1) `2^{1-un} ≤ 2·exp(−un/2)`
  have h1 : (2:ℝ)^(1 - u*(n:ℝ)) ≤ 2 * Real.exp (-(u/2*(n:ℝ))) := by
    have h2u : (2:ℝ)^(1 - u*(n:ℝ)) = 2 * Real.exp (-(u*(n:ℝ)) * Real.log 2) := by
      rw [Real.rpow_def_of_pos (by norm_num : (0:ℝ) < 2)]
      rw [show Real.log 2 * (1 - u*(n:ℝ)) = Real.log 2 + (-(u*(n:ℝ))*Real.log 2) by ring,
        Real.exp_add, Real.exp_log (by norm_num : (0:ℝ) < 2)]
    rw [h2u]
    apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
    apply Real.exp_le_exp.mpr
    have h := mul_le_mul_of_nonneg_left hlog2 (by positivity : (0:ℝ) ≤ u * (n:ℝ))
    linarith
  -- (2) `1/(un-1) ≤ 4/n`
  have h2 : (u*(n:ℝ) - 1)⁻¹ ≤ 4 / (n:ℝ) := by
    rw [← one_div, div_le_div_iff₀ hden hnR]
    have h1' : (1/2:ℝ) * (n:ℝ) ≤ u * (n:ℝ) := mul_le_mul_of_nonneg_right hu1 hnR.le
    linarith [h1', hn4R]
  -- (3) combine
  have hY : (0:ℝ) ≤ 2 * Real.exp (-(u/2*(n:ℝ))) := by positivity
  have h3 : (n:ℝ) * (2:ℝ)^(1 - u*(n:ℝ)) / (u*(n:ℝ) - 1)
      ≤ 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) := by
    rw [div_eq_mul_inv]
    calc (n:ℝ) * (2:ℝ)^(1 - u*(n:ℝ)) * (u*(n:ℝ) - 1)⁻¹
        ≤ (n:ℝ) * (2 * Real.exp (-(u/2*(n:ℝ)))) * (4 / (n:ℝ)) :=
          mul_le_mul (mul_le_mul_of_nonneg_left h1 hnR.le) h2 (inv_nonneg.mpr hden.le)
            (by positivity)
      _ = 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) := by field_simp
  -- (4) `8·exp(−un/2) ≤ 1/n²`
  have h4 : 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) ≤ 1 / (n:ℝ)^2 := by
    rw [le_div_iff₀ (by positivity)]
    have heq : 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) * (n:ℝ)^2
        = 8 * ((n:ℝ)^2 * Real.exp (-(u/2*(n:ℝ)))) := by ring
    rw [heq]
    linarith [hn]
  calc (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
      ≤ (n : ℝ) * (2 : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1) :=
        phi_tail_le u n hu1 (by omega : 3 ≤ n)
    _ ≤ 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) := h3
    _ ≤ 1 / (n : ℝ) ^ 2 := h4


/-- **The geometric tail is `O(1/n²)`.** -/
lemma geometric_tail_le_eventually (u : ℝ) (hu1 : 1/2 ≤ u) :
    ∀ᶠ n : ℕ in Filter.atTop,
      (∑' i : ℕ, Real.exp (-(u * ((i + n : ℕ) : ℝ)))) ≤ 1 / (n : ℝ) ^ 2 := by
  have hu0 : 0 < u := by linarith
  have hev := eventually_pow_exp_le u hu0 2 (1/4) (by norm_num)
  have hx : ‖Real.exp (-u)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith
  filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
  have hnR : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn1
  have hsplit : (∑' i : ℕ, Real.exp (-(u * ((i + n : ℕ) : ℝ))))
      = Real.exp (-(u * (n : ℝ))) * (∑' i : ℕ, (Real.exp (-u)) ^ i) := by
    rw [← tsum_mul_left]
    apply tsum_congr; intro i
    rw [← Real.exp_nat_mul]
    push_cast
    rw [show -(u * (↑i + ↑n)) = -(u * ↑n) + -(u * ↑i) by ring, Real.exp_add]
    ring
  rw [hsplit, tsum_geometric_of_norm_lt_one hx]
  have h1e : (1:ℝ) - Real.exp (-u) ≥ 1/4 := by
    have h3 : Real.exp (-u) ≤ Real.exp (-(1/2:ℝ)) := Real.exp_le_exp.mpr (by linarith)
    have h4 : Real.exp (-(1/2:ℝ)) ≤ 2/3 := by
      rw [Real.exp_neg, ← one_div, div_le_iff₀ (Real.exp_pos (1/2))]
      have := Real.add_one_le_exp (1/2 : ℝ)
      linarith
    linarith [h3, h4]
  have hden : (0:ℝ) < 1 - Real.exp (-u) := by linarith [h1e]
  have h4 : (1 - Real.exp (-u))⁻¹ ≤ 4 := by
    rw [inv_le_comm₀ hden (by norm_num : (0:ℝ) < 4)]
    linarith [h1e]
  have h5 : Real.exp (-(u*(n:ℝ))) * (1 - Real.exp (-u))⁻¹ ≤ 4 * Real.exp (-(u*(n:ℝ))) := by
    have h := mul_le_mul_of_nonneg_left h4 (Real.exp_pos (-(u*(n:ℝ)))).le
    rw [mul_comm (Real.exp (-(u*(n:ℝ)))) 4] at h
    exact h
  have h6 : 4 * Real.exp (-(u*(n:ℝ))) ≤ 1/(n:ℝ)^2 := by
    rw [le_div_iff₀ (by positivity)]
    have heq : 4 * Real.exp (-(u*(n:ℝ))) * (n:ℝ)^2
        = 4 * ((n:ℝ)^2 * Real.exp (-(u*(n:ℝ)))) := by ring
    rw [heq]
    linarith [hn]
  exact h5.trans h6



/-- `ΦS(log 2) = Σ k²2^{-k} = 6`. -/
lemma PhiS_log_two : PhiS (Real.log 2) = 6 := by
  have hx : ‖(1/2 : ℝ)‖ < 1 := by rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  have h := tsum_sq_mul_geometric_of_norm_lt_one hx
  rw [PhiS]
  have hfun : (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(Real.log 2 * (k:ℝ))))
      = (fun k : ℕ => (k:ℝ)^2 * (1/2:ℝ)^k) := by
    funext k
    rw [show Real.exp (-(Real.log 2 * (k:ℝ))) = (Real.exp (-(Real.log 2)))^k by
      rw [← Real.exp_nat_mul]; congr 1; ring]
    rw [show Real.exp (-(Real.log 2)) = (1/2:ℝ) by
      rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 2)]; norm_num]
  rw [hfun, h]
  norm_num


/-- **Two-sided log bound.**  `|log(1+y) − y| ≤ 2y²` for `|y| ≤ 1/2`.

Proof: `log(1+y) ≤ y` and `1 − 1/(1+y) ≤ log(1+y)`, so
`0 ≤ y − log(1+y) ≤ y − y/(1+y) = y²/(1+y) ≤ 2y²`. -/
lemma abs_log_one_add_sub_le (y : ℝ) (hy : |y| ≤ 1/2) :
    |Real.log (1 + y) - y| ≤ 2 * y^2 := by
  have hy1 : (-(1/2):ℝ) ≤ y := by linarith [neg_abs_le y]
  have h1y : (0:ℝ) < 1 + y := by linarith [neg_abs_le y]
  have hup : Real.log (1 + y) ≤ y := by
    have := Real.log_le_sub_one_of_pos h1y
    linarith
  have hlo : y / (1 + y) ≤ Real.log (1 + y) := by
    have := Real.one_sub_inv_le_log_of_pos h1y
    rw [show (1:ℝ) - (1+y)⁻¹ = y/(1+y) by field_simp; ring] at this
    exact this
  have h2 : (0:ℝ) ≤ y - Real.log (1 + y) := by linarith
  have h3 : y - Real.log (1 + y) ≤ 2 * y^2 := by
    have h4 : y - y/(1+y) = y^2/(1+y) := by field_simp; ring
    have h5 : y^2/(1+y) ≤ 2 * y^2 := by
      rw [div_le_iff₀ h1y]
      nlinarith [hy1, sq_nonneg y]
    linarith [hlo, h4.le, h4.ge, h5]
  rw [abs_le]
  constructor <;> linarith [h2, h3]


/-- `ΦS u ≤ 30` for `u ≥ 1/2`. -/
lemma PhiS_le_thirty (u : ℝ) (hu1 : 1/2 ≤ u) : PhiS u ≤ 30 := by
  have hs : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))) := summable_S u (by linarith)
  have hx : ‖Real.exp (-(1/2:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
  have hsp : Summable (fun k : ℕ => (k:ℝ)^2 * (Real.exp (-(1/2:ℝ)))^k) :=
    summable_pow_mul_geometric_of_norm_lt_one 2 hx
  have hcomp : PhiS u ≤ ∑' k : ℕ, (k:ℝ)^2 * (Real.exp (-(1/2:ℝ)))^k := by
    rw [PhiS]
    refine hs.tsum_le_tsum (fun k => ?_) hsp
    apply mul_le_mul_of_nonneg_left _ (by positivity)
    rw [← Real.exp_nat_mul]
    apply Real.exp_le_exp.mpr
    nlinarith [hu1, (Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ))]
  refine hcomp.trans ?_
  rw [tsum_sq_mul_geometric_of_norm_lt_one hx]
  have he : Real.exp (-(1/2:ℝ)) ≤ 2/3 := by
    rw [Real.exp_neg, ← one_div, div_le_iff₀ (Real.exp_pos (1/2))]
    have := Real.add_one_le_exp (1/2 : ℝ); linarith
  have h0 : (0:ℝ) < Real.exp (-(1/2:ℝ)) := Real.exp_pos _
  have h1e : (0:ℝ) < 1 - Real.exp (-(1/2:ℝ)) := by linarith [he]
  rw [div_le_iff₀ (pow_pos h1e 3)]
  have hp : Real.exp (-(1/2:ℝ)) * (1 + Real.exp (-(1/2:ℝ))) ≤ 10/9 := by
    nlinarith [he, h0, sq_nonneg (Real.exp (-(1/2:ℝ)))]
  have hq : (1/3:ℝ) ≤ 1 - Real.exp (-(1/2:ℝ)) := by linarith [he]
  have hq3 : ((1/3:ℝ))^3 ≤ (1 - Real.exp (-(1/2:ℝ)))^3 :=
    pow_le_pow_left₀ (by norm_num) hq 3
  nlinarith [hp, hq3]


/-- The Lipschitz constant of `ΦS` on `[1/2,∞)`: `Σ k³e^{-k/2}`. -/
noncomputable def PhiL : ℝ := ∑' k : ℕ, (k : ℝ) ^ 3 * Real.exp (-((k : ℝ) / 2))

/-- **`ΦS` is Lipschitz on `[1/2,∞)`.**  `|ΦS u − ΦS v| ≤ PhiL·|u−v|`. -/
lemma PhiS_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiS u - PhiS v| ≤ PhiL * |u - v| := by
  have key : ∀ a b : ℝ, 1/2 ≤ a → 1/2 ≤ b → PhiS a - PhiS b ≤ PhiL * |a - b| := by
    intro a b ha hb
    have haS : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(a*(k:ℝ)))) := summable_S a (by linarith)
    have hbS : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(b*(k:ℝ)))) := summable_S b (by linarith)
    have hsum : Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-((k:ℝ)/2)) * |a - b|) :=
      summable_three.mul_right _
    have hpt : ∀ k : ℕ, ((k:ℝ)^2 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(b*(k:ℝ))))
        ≤ (k:ℝ)^3 * Real.exp (-((k:ℝ)/2)) * |a - b| := by
      intro k
      have hk0 : (0:ℝ) ≤ (k:ℝ) := Nat.cast_nonneg k
      rcases le_total b a with h | h
      · have he : Real.exp (-(a*(k:ℝ))) ≤ Real.exp (-(b*(k:ℝ))) :=
          Real.exp_le_exp.mpr (by nlinarith [h, hk0])
        have h2 : (0:ℝ) ≤ |a - b| := abs_nonneg _
        have hL : (k:ℝ)^2 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(b*(k:ℝ))) ≤ 0 := by
          nlinarith [he]
        have hR : (0:ℝ) ≤ (k:ℝ)^3 * Real.exp (-((k:ℝ)/2)) * |a - b| :=
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
        calc (k:ℝ)^2 * Real.exp (-(a*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(b*(k:ℝ)))
            = (k:ℝ)^2 * (Real.exp (-(a*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))) := by ring
          _ = (k:ℝ)^2 * (Real.exp (-(a*(k:ℝ))) * (1 - Real.exp (-((b-a)*(k:ℝ))))) := by rw [hbk]
          _ ≤ (k:ℝ)^2 * (Real.exp (-((k:ℝ)/2)) * ((b-a)*(k:ℝ))) := by
              apply mul_le_mul_of_nonneg_left _ (by positivity)
              exact mul_le_mul hea h1 hb1 (Real.exp_pos _).le
          _ = (k:ℝ)^3 * Real.exp (-((k:ℝ)/2)) * |a - b| := by
              rw [abs_sub_comm a b, abs_of_nonneg (by linarith : (0:ℝ) ≤ b - a)]; ring
    rw [PhiS, PhiS, ← Summable.tsum_sub haS hbS]
    refine le_trans (Summable.tsum_le_tsum hpt (haS.sub hbS) hsum) ?_
    rw [PhiL, tsum_mul_right]
  rw [abs_le]
  constructor
  · have h := key v u hv hu
    rw [abs_sub_comm v u] at h
    linarith
  · linarith [key u v hu hv]



/-- **Threshold step 1.**  From `Φ_{un}(n) = 1` and the second-order bound, the quantity
`1 − (e^u−1)^{-1}` is `O(1/n)`, with the explicit bound `15/n + C₀/n²`. -/
lemma threshold_one_sub (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C0 : ℝ) (hC0 : 0 ≤ C0)
    (hbound : |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u| ≤ C0/(n:ℝ)^2)
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |1 - (Real.exp u - 1)⁻¹| ≤ 15/(n:ℝ) + C0/(n:ℝ)^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hPS0 : (0:ℝ) ≤ PhiS u := by rw [PhiS]; exact tsum_nonneg (fun k => by positivity)
  have hPS := PhiS_le_thirty u hu1
  have hd : u/(2*(n:ℝ)) * PhiS u ≤ 15/(n:ℝ) := by
    have h1 : u * PhiS u ≤ 30 := by
      have := mul_le_mul hu2 hPS hPS0 (by norm_num : (0:ℝ) ≤ 1)
      linarith [this]
    rw [show u/(2*(n:ℝ)) * PhiS u = (u * PhiS u)/(2*(n:ℝ)) by ring,
      div_le_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ))]
    have h2 : (15/(n:ℝ)) * (2*(n:ℝ)) = 30 := by
      have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
      field_simp
      norm_num
    linarith [h1, h2]
  have hkey : 1 - (Real.exp u - 1)⁻¹
      = u/(2*(n:ℝ)) * PhiS u
        + (Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u) := by
    rw [hthr]; ring
  rw [hkey]
  have htri := abs_add_le (u/(2*(n:ℝ)) * PhiS u)
    (Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u)
  rw [abs_of_nonneg (mul_nonneg (by positivity) hPS0)] at htri
  linarith [htri, hd, hbound]


/-- **Threshold step 2.**  With `s := 1 − (e^u−1)^{-1}` one has `e^u − 2 = s/(1−s)`, and
`|s| ≤ 16/n` gives `|e^u − 2| ≤ 32/n`. -/
lemma threshold_exp_bound (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C0 : ℝ) (hC0 : 0 ≤ C0) (hnC0 : C0 ≤ n) (hn32 : 32 ≤ n)
    (hbound : |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u| ≤ C0/(n:ℝ)^2)
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |Real.exp u - 2| ≤ 32/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn32R : (32:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn32
  set s : ℝ := 1 - (Real.exp u - 1)⁻¹ with hs
  have hn1 : 16/(n:ℝ) ≤ 1/2 := by rw [div_le_iff₀ hnR]; linarith
  have hs16 : |s| ≤ 16/(n:ℝ) := by
    have h1 := threshold_one_sub u hu1 hu2 n hn C0 hC0 hbound hthr
    have h2 : C0/(n:ℝ)^2 ≤ 1/(n:ℝ) := by
      have h1 : C0/(n:ℝ)^2 ≤ (n:ℝ)/(n:ℝ)^2 :=
        div_le_div_of_nonneg_right hnC0 (by positivity)
      have h2' : (n:ℝ)/(n:ℝ)^2 = 1/(n:ℝ) := by
        have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
        field_simp
      rw [h2'] at h1
      exact h1
    rw [hs]
    calc |1 - (Real.exp u - 1)⁻¹| ≤ 15/(n:ℝ) + C0/(n:ℝ)^2 := h1
      _ ≤ 15/(n:ℝ) + 1/(n:ℝ) := add_le_add le_rfl h2
      _ = 16/(n:ℝ) := by ring
  have hs12 : |s| ≤ 1/2 := le_trans hs16 hn1
  have hs1 : (1:ℝ) - s ≠ 0 := by
    intro hc
    have h1 : s = 1 := by linarith
    rw [h1, abs_one] at hs12
    norm_num at hs12
  have hexp : Real.exp u - 2 = s/(1-s) := by
    have h3 : (Real.exp u - 1)⁻¹ = 1 - s := by rw [hs]; ring
    have h4 : Real.exp u - 1 = (1-s)⁻¹ := by
      have h5 : (1:ℝ) - s ≠ 0 := hs1
      rw [← h3]
      field_simp
    rw [show Real.exp u - 2 = (1-s)⁻¹ - 1 by linarith [h4]]
    rw [show (1-s)⁻¹ - 1 = s/(1-s) by field_simp; ring]
  have h1s : (1:ℝ)/2 ≤ |1 - s| := by
    have hh := abs_sub_abs_le_abs_sub (1:ℝ) s
    rw [abs_one] at hh
    linarith [hh, hs12]
  rw [hexp, abs_div]
  calc |s| / |1-s| ≤ (16/(n:ℝ)) / (1/2) :=
        div_le_div₀ (by positivity) hs16 (by norm_num) h1s
    _ = 32/(n:ℝ) := by ring


/-- **Threshold step 3.**  `u − log 2 = log(1 + (e^u−2)/2)`, so
`|u − log 2 − (e^u−2)/2| ≤ 2((e^u−2)/2)² ≤ 512/n²` when `|e^u−2| ≤ 32/n`, `n ≥ 32`. -/
lemma threshold_log_bound (u : ℝ) (n : ℕ) (hn32 : 32 ≤ n)
    (h32 : |Real.exp u - 2| ≤ 32/(n:ℝ)) :
    |u - Real.log 2 - (Real.exp u - 2)/2| ≤ 512/(n:ℝ)^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have h32' : |Real.exp u - 2| ≤ 1 := by
    have h : 32/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; exact_mod_cast hn32
    linarith [h32, h]
  have hw : |Real.exp u/2 - 1| ≤ 1/2 := by
    rw [show Real.exp u/2 - 1 = (Real.exp u - 2)/2 by ring, abs_div,
      show |(2:ℝ)| = 2 by norm_num, div_le_iff₀ (by norm_num)]
    linarith [h32']
  have h1 : Real.exp u/2 - 1 = (Real.exp u - 2)/2 := by ring
  have h2 : Real.log (1 + (Real.exp u/2 - 1)) = u - Real.log 2 := by
    rw [show (1:ℝ) + (Real.exp u/2 - 1) = Real.exp u/2 by ring,
      Real.log_div (Real.exp_ne_zero u) (by norm_num : (2:ℝ) ≠ 0), Real.log_exp]
  have hkey : |u - Real.log 2 - (Real.exp u - 2)/2| ≤ 2 * ((Real.exp u - 2)/2)^2 := by
    rw [← h2, ← h1]
    exact abs_log_one_add_sub_le (Real.exp u/2 - 1) hw
  refine hkey.trans ?_
  have hs : (Real.exp u - 2)^2 ≤ (32/(n:ℝ))^2 := by
    rw [← sq_abs (Real.exp u - 2)]
    exact sq_le_sq' (by linarith [h32, abs_nonneg (Real.exp u - 2)]) h32
  have heq : 2 * ((Real.exp u - 2)/2)^2 = (Real.exp u - 2)^2/2 := by ring
  rw [heq]
  calc (Real.exp u - 2)^2/2 ≤ (32/(n:ℝ))^2/2 := by linarith [hs]
    _ = 512/(n:ℝ)^2 := by field_simp; ring


/-- **Threshold step 4.**  `(u/4n)ΦS(u) = (3 log 2)/(2n) + O(1/n²)`, using `ΦS(log 2) = 6`
and the Lipschitz bound for `ΦS`. -/
lemma threshold_main_term (u : ℝ) (hu1 : 1/2 ≤ u) (n : ℕ) (hn32 : 32 ≤ n)
    (hA : |u - Real.log 2| ≤ 32/(n:ℝ)) :
    |u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))| ≤ (240 + 8*PhiL)/(n:ℝ)^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hlog2le : Real.log 2 ≤ 1 := by
    have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 2); linarith
  have hlog2half : (1/2:ℝ) ≤ Real.log 2 := by
    have := Real.one_sub_inv_le_log_of_pos (by norm_num : (0:ℝ) < 2)
    norm_num at this; linarith
  have hL0 : (0:ℝ) ≤ PhiL := by rw [PhiL]; exact tsum_nonneg (fun k => by positivity)
  have hPS0 : (0:ℝ) ≤ PhiS u := by rw [PhiS]; exact tsum_nonneg (fun k => by positivity)
  have hPS : PhiS u ≤ 30 := PhiS_le_thirty u hu1
  have hkey : |u*PhiS u - 6*Real.log 2| ≤ (960 + 32*PhiL)/(n:ℝ) := by
    have hde : u*PhiS u - 6*Real.log 2
        = (u - Real.log 2)*PhiS u + Real.log 2*(PhiS u - 6) := by ring
    rw [hde]
    have h1 : |(u - Real.log 2)*PhiS u| ≤ (32/(n:ℝ))*30 := by
      rw [abs_mul, abs_of_nonneg hPS0]
      calc |u - Real.log 2| * PhiS u ≤ (32/(n:ℝ)) * PhiS u :=
            mul_le_mul_of_nonneg_right hA hPS0
        _ ≤ (32/(n:ℝ)) * 30 := mul_le_mul_of_nonneg_left hPS (by positivity)
    have h2 : |Real.log 2*(PhiS u - 6)| ≤ Real.log 2 * PhiL * (32/(n:ℝ)) := by
      rw [abs_mul, abs_of_pos hlog2]
      have h6 : PhiS u - 6 = PhiS u - PhiS (Real.log 2) := by rw [PhiS_log_two]
      rw [h6]
      calc Real.log 2 * |PhiS u - PhiS (Real.log 2)|
          ≤ Real.log 2 * (PhiL * |u - Real.log 2|) :=
            mul_le_mul_of_nonneg_left (PhiS_lipschitz u (Real.log 2) hu1 hlog2half) hlog2.le
        _ ≤ Real.log 2 * (PhiL * (32/(n:ℝ))) := by
            apply mul_le_mul_of_nonneg_left _ hlog2.le
            exact mul_le_mul_of_nonneg_left hA hL0
        _ = Real.log 2 * PhiL * (32/(n:ℝ)) := by ring
    have h3 : (32/(n:ℝ))*30 + Real.log 2 * PhiL * (32/(n:ℝ)) ≤ (960 + 32*PhiL)/(n:ℝ) := by
      have he : (32/(n:ℝ))*30 + Real.log 2 * PhiL * (32/(n:ℝ))
          = (960 + 32*Real.log 2*PhiL)/(n:ℝ) := by
        have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
        field_simp
        ring
      rw [he]
      apply div_le_div_of_nonneg_right _ hnR.le
      have h4 : Real.log 2 * PhiL ≤ 1 * PhiL :=
        mul_le_mul_of_nonneg_right hlog2le hL0
      have h5 : 32 * (Real.log 2 * PhiL) ≤ 32 * (1 * PhiL) :=
        mul_le_mul_of_nonneg_left h4 (by norm_num)
      linarith [h5]
    calc |(u - Real.log 2)*PhiS u + Real.log 2*(PhiS u - 6)|
        ≤ |(u - Real.log 2)*PhiS u| + |Real.log 2*(PhiS u - 6)| := abs_add_le _ _
      _ ≤ (32/(n:ℝ))*30 + Real.log 2 * PhiL * (32/(n:ℝ)) := add_le_add h1 h2
      _ ≤ (960 + 32*PhiL)/(n:ℝ) := h3
  have heq : u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))
      = (u*PhiS u - 6*Real.log 2)/(4*(n:ℝ)) := by
    have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
    field_simp
    ring
  rw [heq, abs_div, show |(4*(n:ℝ))| = 4*(n:ℝ) by rw [abs_of_pos (by positivity)]]
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 4*(n:ℝ)) (by positivity : (0:ℝ) < (n:ℝ)^2)]
  have h5 : (960 + 32*PhiL)/(n:ℝ) * (n:ℝ)^2 = (960 + 32*PhiL) * (n:ℝ) := by
    have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
    field_simp
  have h6 := mul_le_mul_of_nonneg_right hkey (by positivity : (0:ℝ) ≤ (n:ℝ)^2)
  have h7 : (240 + 8*PhiL) * (4*(n:ℝ)) = (960 + 32*PhiL) * (n:ℝ) := by ring
  linarith [h6, h5.le, h5.ge, h7.le, h7.ge]


/-- `|(u/2n)·ΦS(u)| ≤ 15/n` for `u ∈ [1/2,1]`. -/
lemma div_mul_PhiS_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |u/(2*(n:ℝ)) * PhiS u| ≤ 15/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hPS0 : (0:ℝ) ≤ PhiS u := by rw [PhiS]; exact tsum_nonneg (fun k => by positivity)
  have hPS := PhiS_le_thirty u hu1
  rw [abs_of_nonneg (mul_nonneg (by positivity) hPS0),
    show u/(2*(n:ℝ)) * PhiS u = (u * PhiS u)/(2*(n:ℝ)) by ring,
    div_le_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ))]
  have h1 : u * PhiS u ≤ 30 := by
    calc u * PhiS u ≤ 1 * PhiS u := mul_le_mul_of_nonneg_right hu2 hPS0
      _ ≤ 1 * 30 := mul_le_mul_of_nonneg_left hPS (by norm_num)
      _ = 30 := by ring
  have h2 : (15/(n:ℝ)) * (2*(n:ℝ)) = 30 := by
    have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
    field_simp
    norm_num
  linarith [h1, h2]

/-- **Threshold step 5.**  `(e^u−2)/2 = s/(2(1−s))` with `s = (u/2n)ΦS(u) + ε`, so
`|(e^u−2)/2 − (u/4n)ΦS(u)| ≤ 256/n² + |ε|/2`. -/
lemma threshold_second_term (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C0 : ℝ) (hC0 : 0 ≤ C0) (hnC0 : C0 ≤ n) (hn32 : 32 ≤ n)
    (hbound : |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u| ≤ C0/(n:ℝ)^2)
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |(Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u| ≤ (256 + C0/2)/(n:ℝ)^2 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16R : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 16 ≤ n)
  have hn32R : (32:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn32
  have hn1 : 16/(n:ℝ) ≤ 1/2 := by rw [div_le_iff₀ hnR]; linarith
  set s : ℝ := 1 - (Real.exp u - 1)⁻¹ with hs
  set e : ℝ := Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u with he
  have hebound : |e| ≤ C0/(n:ℝ)^2 := by rw [he]; exact hbound
  have hseq : s = u/(2*(n:ℝ)) * PhiS u + e := by rw [hs, he, hthr]; ring
  have hs16 : |s| ≤ 16/(n:ℝ) := by
    have hd := div_mul_PhiS_abs_le u hu1 hu2 n hn
    have h2 : C0/(n:ℝ)^2 ≤ 1/(n:ℝ) := by
      have h1 : C0/(n:ℝ)^2 ≤ (n:ℝ)/(n:ℝ)^2 :=
        div_le_div_of_nonneg_right hnC0 (by positivity)
      have h2' : (n:ℝ)/(n:ℝ)^2 = 1/(n:ℝ) := by
        have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
        field_simp
      rw [h2'] at h1
      exact h1
    rw [hseq]
    calc |u/(2*(n:ℝ)) * PhiS u + e| ≤ |u/(2*(n:ℝ)) * PhiS u| + |e| := abs_add_le _ _
      _ ≤ 15/(n:ℝ) + C0/(n:ℝ)^2 := add_le_add hd hebound
      _ ≤ 15/(n:ℝ) + 1/(n:ℝ) := add_le_add le_rfl h2
      _ = 16/(n:ℝ) := by ring
  have hs12 : |s| ≤ 1/2 := le_trans hs16 hn1
  have hs1 : (1:ℝ) - s ≠ 0 := by
    intro hc
    have h1 : s = 1 := by linarith
    rw [h1, abs_one] at hs12
    norm_num at hs12
  have h1s : (1:ℝ)/2 ≤ |1 - s| := by
    have hh := abs_sub_abs_le_abs_sub (1:ℝ) s
    rw [abs_one] at hh
    linarith [hh, hs12]
  -- (e^u-2)/2 = s/(2(1-s))
  have hexp : (Real.exp u - 2)/2 = s/(2*(1-s)) := by
    have h3 : (Real.exp u - 1)⁻¹ = 1 - s := by rw [hs]; ring
    have h4 : Real.exp u - 1 = (1-s)⁻¹ := by
      rw [← h3]
      field_simp
    rw [show Real.exp u - 2 = (1-s)⁻¹ - 1 by linarith [h4]]
    rw [show ((1-s)⁻¹ - 1)/2 = s/(2*(1-s)) by field_simp; ring]
  -- s/(2(1-s)) - s/2 = s^2/(2(1-s))
  have hdiff : s/(2*(1-s)) - s/2 = s^2/(2*(1-s)) := by
    field_simp
    ring
  have hsq : |s^2/(2*(1-s))| ≤ 256/(n:ℝ)^2 := by
    rw [abs_div]
    have hnum : |s^2| ≤ (16/(n:ℝ))^2 := by
      rw [abs_sq, sq_le_sq, abs_of_nonneg (by positivity : (0:ℝ) ≤ 16/(n:ℝ))]
      exact hs16
    have hden : (1:ℝ) ≤ |2*(1-s)| := by
      rw [abs_mul, show |(2:ℝ)| = 2 by norm_num]; linarith [h1s]
    calc |s^2| / |2*(1-s)| ≤ ((16/(n:ℝ))^2) / 1 :=
          div_le_div₀ (by positivity) hnum (by norm_num) hden
      _ = 256/(n:ℝ)^2 := by ring
  have he2 : |e/2| ≤ C0/2/(n:ℝ)^2 := by
    rw [abs_div, show |(2:ℝ)| = 2 by norm_num, div_le_div_iff₀ (by norm_num) (by positivity)]
    have h3 : (C0/(n:ℝ)^2) * (n:ℝ)^2 = C0 := by
      have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR
      field_simp
    have h4 := mul_le_mul_of_nonneg_right hebound (by positivity : (0:ℝ) ≤ (n:ℝ)^2)
    linarith [h3.le, h3.ge, h4]
  have hAss : (Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u
      = s^2/(2*(1-s)) + e/2 := by
    rw [hexp]
    have h1 : u/(4*(n:ℝ)) * PhiS u = (s - e)/2 := by
      rw [hseq]; ring
    rw [h1]
    field_simp
    ring
  rw [hAss]
  calc |s^2/(2*(1-s)) + e/2| ≤ |s^2/(2*(1-s))| + |e/2| := abs_add_le _ _
    _ ≤ 256/(n:ℝ)^2 + C0/2/(n:ℝ)^2 := add_le_add hsq he2
    _ = (256 + C0/2)/(n:ℝ)^2 := by ring


/-- **Uniform polynomial × exponential decay.**  For `k`, `c > 0`, `v₀ > 0`, eventually
`nᵏ·exp(−vn) ≤ c` holds **for all** `v ≥ v₀` simultaneously. -/
lemma eventually_pow_exp_le_uniform (k : ℕ) (c v0 : ℝ) (hc : 0 < c) (hv0 : 0 < v0) :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ v : ℝ, v0 ≤ v →
      (n : ℝ) ^ k * Real.exp (-(v * (n : ℝ))) ≤ c := by
  have ht := tendsto_pow_const_mul_const_pow_of_lt_one k (Real.exp_pos (-v0)).le
    (by rw [Real.exp_lt_one_iff]; linarith)
  have h0 : ∀ᶠ n : ℕ in Filter.atTop, (n : ℝ) ^ k * (Real.exp (-v0)) ^ n < c :=
    (tendsto_order.1 ht).2 _ hc
  filter_upwards [h0] with n hn
  intro v hv
  have h1 : (n : ℝ) ^ k * Real.exp (-(v * (n : ℝ)))
      = (n : ℝ) ^ k * (Real.exp (-v)) ^ n := by
    rw [← Real.exp_nat_mul]; congr 1; ring_nf
  rw [h1]
  apply le_of_lt
  calc (n : ℝ) ^ k * (Real.exp (-v)) ^ n
      ≤ (n : ℝ) ^ k * (Real.exp (-v0)) ^ n := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        apply pow_le_pow_left₀ (Real.exp_pos _).le
        exact Real.exp_le_exp.mpr (by linarith)
    _ < c := hn


/-- **Uniformly in `u ≥ 1/2`, the `Phi` tail is `O(1/n²)`.** -/
lemma phi_tail_le_eventually_uniform :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u →
      (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
        ≤ 1 / (n : ℝ) ^ 2 := by
  have hev := eventually_pow_exp_le_uniform 2 (1/8) (1/4) (by norm_num) (by norm_num)
  have hlog2 : (1/2 : ℝ) ≤ Real.log 2 := by
    have := Real.one_sub_inv_le_log_of_pos (by norm_num : (0 : ℝ) < 2)
    norm_num at this; linarith
  filter_upwards [hev, Filter.eventually_ge_atTop 8] with n hn hn8
  intro u hu1
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn8R : (8:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn8
  have hnu4 : (1/4:ℝ) ≤ u/2 := by linarith
  have hn2 : (n:ℝ)^2 * Real.exp (-((u/2) * (n:ℝ))) ≤ 1/8 := hn (u/2) hnu4
  have hden : (0:ℝ) < u * (n:ℝ) - 1 := by nlinarith [hu1, hn8R]
  -- 2^{1-un} ≤ 2 e^{-un/2}
  have h1 : (2:ℝ)^(1 - u*(n:ℝ)) ≤ 2 * Real.exp (-(u/2*(n:ℝ))) := by
    have h2u : (2:ℝ)^(1 - u*(n:ℝ)) = 2 * Real.exp (-(u*(n:ℝ)) * Real.log 2) := by
      rw [Real.rpow_def_of_pos (by norm_num : (0:ℝ) < 2)]
      rw [show Real.log 2 * (1 - u*(n:ℝ)) = Real.log 2 + (-(u*(n:ℝ))*Real.log 2) by ring,
        Real.exp_add, Real.exp_log (by norm_num : (0:ℝ) < 2)]
    rw [h2u]
    apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
    apply Real.exp_le_exp.mpr
    have h := mul_le_mul_of_nonneg_left hlog2 (by positivity : (0:ℝ) ≤ u * (n:ℝ))
    linarith
  -- 1/(un-1) ≤ 4/n
  have h2 : (u*(n:ℝ) - 1)⁻¹ ≤ 4 / (n:ℝ) := by
    rw [← one_div, div_le_div_iff₀ hden hnR]
    have h1' : (1/2:ℝ) * (n:ℝ) ≤ u * (n:ℝ) := mul_le_mul_of_nonneg_right hu1 hnR.le
    linarith [h1', hn8R]
  have hY : (0:ℝ) ≤ 2 * Real.exp (-(u/2*(n:ℝ))) := by positivity
  have h3 : (n:ℝ) * (2:ℝ)^(1 - u*(n:ℝ)) / (u*(n:ℝ) - 1)
      ≤ 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) := by
    rw [div_eq_mul_inv]
    calc (n:ℝ) * (2:ℝ)^(1 - u*(n:ℝ)) * (u*(n:ℝ) - 1)⁻¹
        ≤ (n:ℝ) * (2 * Real.exp (-(u/2*(n:ℝ)))) * (4 / (n:ℝ)) :=
          mul_le_mul (mul_le_mul_of_nonneg_left h1 hnR.le) h2 (inv_nonneg.mpr hden.le)
            (by positivity)
      _ = 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) := by field_simp
  -- 8·exp(-un/2) ≤ 1/n²
  have h4 : 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) ≤ 1 / (n:ℝ)^2 := by
    rw [le_div_iff₀ (by positivity)]
    have heq : 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) * (n:ℝ)^2
        = 8 * ((n:ℝ)^2 * Real.exp (-(u/2*(n:ℝ)))) := by ring
    rw [heq]
    linarith [hn2]
  calc (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
      ≤ (n : ℝ) * (2 : ℝ) ^ (1 - u * (n : ℝ)) / (u * (n : ℝ) - 1) :=
        phi_tail_le u n hu1 (by omega : 3 ≤ n)
    _ ≤ 4 * (2 * Real.exp (-(u/2*(n:ℝ)))) := h3
    _ ≤ 1 / (n : ℝ) ^ 2 := h4


/-- **Uniformly in `u ≥ 1/2`, the geometric tail is `O(1/n²)`.** -/
lemma geometric_tail_le_eventually_uniform :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u →
      (∑' i : ℕ, Real.exp (-(u * ((i + n : ℕ) : ℝ)))) ≤ 1 / (n : ℝ) ^ 2 := by
  have hev := eventually_pow_exp_le_uniform 2 (1/4) (1/2) (by norm_num) (by norm_num)
  filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
  intro u hu1
  have hnR : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn1
  have hx : ‖Real.exp (-u)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith
  have hsplit : (∑' i : ℕ, Real.exp (-(u * ((i + n : ℕ) : ℝ))))
      = Real.exp (-(u * (n : ℝ))) * (∑' i : ℕ, (Real.exp (-u)) ^ i) := by
    rw [← tsum_mul_left]
    apply tsum_congr; intro i
    rw [← Real.exp_nat_mul]
    push_cast
    rw [show -(u * (↑i + ↑n)) = -(u * ↑n) + -(u * ↑i) by ring, Real.exp_add]
    ring
  rw [hsplit, tsum_geometric_of_norm_lt_one hx]
  have h1e : (1:ℝ) - Real.exp (-u) ≥ 1/4 := by
    have h3 : Real.exp (-u) ≤ Real.exp (-(1/2:ℝ)) := Real.exp_le_exp.mpr (by linarith)
    have h4 : Real.exp (-(1/2:ℝ)) ≤ 2/3 := by
      rw [Real.exp_neg, ← one_div, div_le_iff₀ (Real.exp_pos (1/2))]
      have := Real.add_one_le_exp (1/2 : ℝ)
      linarith
    linarith [h3, h4]
  have hden : (0:ℝ) < 1 - Real.exp (-u) := by linarith [h1e]
  have h4 : (1 - Real.exp (-u))⁻¹ ≤ 4 := by
    rw [inv_le_comm₀ hden (by norm_num : (0:ℝ) < 4)]
    linarith [h1e]
  have h5 : Real.exp (-(u*(n:ℝ))) * (1 - Real.exp (-u))⁻¹ ≤ 4 * Real.exp (-(u*(n:ℝ))) := by
    have h := mul_le_mul_of_nonneg_left h4 (Real.exp_pos (-(u*(n:ℝ)))).le
    rw [mul_comm (Real.exp (-(u*(n:ℝ)))) 4] at h
    exact h
  have h6 : 4 * Real.exp (-(u*(n:ℝ))) ≤ 1/(n:ℝ)^2 := by
    rw [le_div_iff₀ (by positivity)]
    have heq : 4 * Real.exp (-(u*(n:ℝ))) * (n:ℝ)^2
        = 4 * ((n:ℝ)^2 * Real.exp (-(u*(n:ℝ)))) := by ring
    rw [heq]
    linarith [hn u hu1]
  exact h5.trans h6


/-- **Uniformly in `u ≥ 1/2`, the `k > n` tail of `Σ k²e^{−uk}` is `O(1/n²)`.** -/
lemma phi_S_tail_bound_uniform :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u →
      (∑' i : ℕ, (((n + 1 + i : ℕ)) : ℝ) ^ 2 * Real.exp (-(u * (((n + 1 + i : ℕ)) : ℝ))))
        ≤ 1 / (n : ℝ) ^ 2 := by
  have h8 : (0 : ℝ) < 8 * (PhiK3 + 1) := by linarith [PhiK3_nonneg]
  have hev := eventually_pow_exp_le_uniform 4 (1/(8*(PhiK3+1))) (1/2)
    (div_pos one_pos h8) (by norm_num)
  have hS2 : Summable (fun k : ℕ => (k : ℝ) ^ 2 * Real.exp (-((1/2:ℝ) * (k : ℝ)))) := by
    have hr : ‖Real.exp (-(1/2:ℝ))‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; norm_num
    have h := (summable_pow_mul_geometric_of_norm_lt_one 2 hr)
    refine h.congr (fun k => ?_)
    rw [← Real.exp_nat_mul]; congr 1; ring
  filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
  intro u hu1
  have hnR : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn1
  have hn1R : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
  have huS : Summable (fun k : ℕ => (k : ℝ) ^ 2 * Real.exp (-(u * (k : ℝ)))) := by
    have hr : ‖Real.exp (-u)‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      linarith [hu1]
    have h := (summable_pow_mul_geometric_of_norm_lt_one 2 hr)
    refine h.congr (fun k => ?_)
    rw [← Real.exp_nat_mul]; congr 1; ring
  have hLHS : Summable (fun i : ℕ =>
      (((n + 1 + i : ℕ)) : ℝ) ^ 2 * Real.exp (-(u * (((n + 1 + i : ℕ)) : ℝ)))) := by
    have h := (summable_nat_add_iff (n + 1)).mpr huS
    have h' : (fun i : ℕ => (↑(i + (n+1)) : ℝ)^2 * Real.exp (-(u*↑(i+(n+1)))))
        = (fun i : ℕ => (↑(n+1+i) : ℝ)^2 * Real.exp (-(u*↑(n+1+i)))) := by
      funext i; rw [Nat.add_comm i (n+1)]
    rw [h'] at h
    exact h
  have hmaj : Summable (fun i : ℕ => ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1)))
      * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2)))) := summable_three_shift.mul_left _
  have hterm : ∀ i : ℕ,
      (((n + 1 + i : ℕ)) : ℝ) ^ 2 * Real.exp (-(u * (((n + 1 + i : ℕ)) : ℝ)))
        ≤ ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) := by
    intro i
    have hcast : (((n + 1 + i : ℕ)) : ℝ) = (n:ℝ) + 1 + i := by push_cast; ring
    have hi0 : (0 : ℝ) ≤ (i : ℝ) := Nat.cast_nonneg i
    have h1 : ((n:ℝ)+1+i)^2 ≤ ((n:ℝ)+1)^2 * ((i:ℝ)+1)^2 := by
      rw [← mul_pow]
      apply pow_le_pow_left₀ (by positivity)
      nlinarith [hnR, hi0, mul_nonneg hnR.le hi0]
    have h2 : ((i:ℝ)+1)^2 * Real.exp (-((i:ℝ)/2))
        ≤ ((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2)) :=
      mul_le_mul_of_nonneg_right (by nlinarith [hi0]) (Real.exp_pos _).le
    have h3 : Real.exp (-(u*(i:ℝ))) ≤ Real.exp (-((i:ℝ)/2)) :=
      Real.exp_le_exp.mpr (by nlinarith [hu1, hi0])
    rw [hcast, show -(u*((n:ℝ)+1+i)) = -(u*((n:ℝ)+1)) + -(u*(i:ℝ)) by ring, Real.exp_add]
    calc ((n:ℝ)+1+i)^2 * (Real.exp (-(u*((n:ℝ)+1))) * Real.exp (-(u*(i:ℝ))))
        = (Real.exp (-(u*((n:ℝ)+1))) * ((n:ℝ)+1+i)^2) * Real.exp (-(u*(i:ℝ))) := by ring
      _ ≤ (Real.exp (-(u*((n:ℝ)+1))) * (((n:ℝ)+1)^2 * ((i:ℝ)+1)^2)) * Real.exp (-((i:ℝ)/2)) :=
          mul_le_mul (mul_le_mul_of_nonneg_left h1 (Real.exp_pos _).le) h3
            (Real.exp_pos _).le (by positivity)
      _ = ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (((i:ℝ)+1)^2 * Real.exp (-((i:ℝ)/2))) := by ring
      _ ≤ ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) :=
          mul_le_mul_of_nonneg_left h2 (by positivity)
  have h1 := hLHS.tsum_le_tsum hterm hmaj
  have h2 : (∑' i : ℕ, ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1)))
      * (((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))))
      = ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1)))
        * (∑' i : ℕ, ((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) := tsum_mul_left
  rw [h2] at h1
  have h3 : (∑' i : ℕ, ((i:ℝ)+1)^3 * Real.exp (-((i:ℝ)/2))) ≤ 2 * PhiK3 := tsum_three_shift_le
  have h4 : (0 : ℝ) ≤ ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) := by positivity
  have h5 := mul_le_mul_of_nonneg_left h3 h4
  have h6 : ((n:ℝ)+1)^2 ≤ 4 * (n:ℝ)^2 := by nlinarith [hn1R, sq_nonneg (n:ℝ)]
  have h7 : Real.exp (-(u*((n:ℝ)+1))) ≤ Real.exp (-(u*(n:ℝ))) :=
    Real.exp_le_exp.mpr (by nlinarith [hu1])
  have hA : ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (2 * PhiK3)
      ≤ 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) := by
    have hstep : ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) ≤ 4 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) :=
      mul_le_mul h6 h7 (Real.exp_pos _).le (by positivity)
    calc ((n:ℝ)+1)^2 * Real.exp (-(u*((n:ℝ)+1))) * (2 * PhiK3)
        ≤ 4 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) * (2 * PhiK3) :=
          mul_le_mul_of_nonneg_right hstep (by linarith [PhiK3_nonneg])
      _ = 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) := by ring
  have hB : 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) ≤ 1 / (n:ℝ)^2 := by
    rw [le_div_iff₀ (by positivity)]
    have hnp : 8 * PhiK3 * (n:ℝ)^2 * Real.exp (-(u*(n:ℝ))) * (n:ℝ)^2
        = 8 * PhiK3 * ((n:ℝ)^4 * Real.exp (-(u*(n:ℝ)))) := by ring
    rw [hnp]
    have hnu : Real.exp (-(u*(n:ℝ))) ≤ Real.exp (-((1/2)*(n:ℝ))) :=
      Real.exp_le_exp.mpr (by nlinarith [hu1])
    have hm2 : 8 * PhiK3 * ((n:ℝ)^4 * Real.exp (-(u*(n:ℝ))))
        ≤ 8 * PhiK3 * ((n:ℝ)^4 * Real.exp (-((1/2)*(n:ℝ)))) := by
      apply mul_le_mul_of_nonneg_left _ (by linarith [PhiK3_nonneg])
      exact mul_le_mul_of_nonneg_left hnu (by positivity)
    have hm := mul_le_mul_of_nonneg_left (hn (1/2) (by norm_num))
      (by linarith [PhiK3_nonneg] : (0:ℝ) ≤ 8 * PhiK3)
    have h10 : 8 * PhiK3 * (1/(8*(PhiK3+1))) ≤ 1 := by
      rw [mul_one_div, div_le_one (by linarith [PhiK3_nonneg])]
      linarith [PhiK3_nonneg]
    linarith [hm2, hm, h10]
  linarith [h1, h5, hA, hB]


/-- **Uniformly in `u ∈ [1/2,1]`, the sharp finite `G·y` sum.** -/
lemma phi_S_finite_part_uniform :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      |(∑ j ∈ Finset.range n, Real.exp (-(u*((j:ℝ)+1))) * (u*((j:ℝ)+1)^2/(2*(n:ℝ))))
        - u/(2*(n:ℝ)) * PhiS u| ≤ 1 / (n:ℝ)^2 := by
  have hev := phi_S_tail_bound_uniform
  filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
  intro u hu1 hu2
  have hu0 : 0 < u := by linarith
  have hS : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))) := summable_S u hu0
  have hnR : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn1
  have hn1R : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn1
  have hnt : (∑' i : ℕ, (((n+1+i : ℕ)):ℝ)^2 * Real.exp (-(u*(((n+1+i:ℕ)):ℝ)))) ≤ 1/(n:ℝ)^2 :=
    hn u hu1
  set T : ℝ := ∑' i : ℕ, (((n+1+i : ℕ)):ℝ)^2 * Real.exp (-(u*(((n+1+i:ℕ)):ℝ))) with hT
  have hT0 : 0 ≤ T := by
    rw [hT]; exact tsum_nonneg (fun i => by positivity)
  have hsum : (∑ j ∈ Finset.range n, Real.exp (-(u*((j:ℝ)+1))) * (u*((j:ℝ)+1)^2/(2*(n:ℝ))))
      = u/(2*(n:ℝ)) * (∑ j ∈ Finset.range n, ((j:ℝ)+1)^2 * Real.exp (-(u*((j:ℝ)+1)))) := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl (fun j _ => by ring)
  have hbase : (∑ j ∈ Finset.range n, ((j:ℝ)+1)^2 * Real.exp (-(u*((j:ℝ)+1))))
      = PhiS u - T := by
    have h := hS.sum_add_tsum_nat_add (n+1)
    rw [Finset.sum_range_succ'] at h
    simp only [Nat.cast_zero, zero_pow (by norm_num : 2 ≠ 0), mul_zero, Real.exp_zero, mul_one,
      zero_add] at h
    have hT2 : T = ∑' i : ℕ, (↑(i + (n+1)) : ℝ)^2 * Real.exp (-(u*↑(i+(n+1)))) := by
      rw [hT]
      apply tsum_congr; intro i
      rw [Nat.add_comm (n+1) i]
    have h2 : (∑ j ∈ Finset.range n, ((j:ℝ)+1)^2 * Real.exp (-(u*((j:ℝ)+1))))
        = ∑ j ∈ Finset.range n, (↑(j+1) : ℝ)^2 * Real.exp (-(u*↑(j+1))) := by
      exact Finset.sum_congr rfl (fun j _ => by push_cast; ring)
    rw [PhiS, hT2, h2]
    linarith [h]
  rw [hsum, hbase]
  have hkey : u/(2*(n:ℝ)) * (PhiS u - T) - u/(2*(n:ℝ)) * PhiS u = -(u/(2*(n:ℝ))) * T := by ring
  rw [hkey, abs_mul, abs_neg, abs_of_pos (by positivity : (0:ℝ) < u/(2*(n:ℝ))), abs_of_nonneg hT0]
  have hstep1 : u/(2*(n:ℝ)) * T ≤ (1/(2*(n:ℝ))) * T := by
    apply mul_le_mul_of_nonneg_right _ hT0
    exact div_le_div_of_nonneg_right hu2 (by positivity)
  have hstep2 : (1/(2*(n:ℝ))) * T ≤ (1/(2*(n:ℝ))) * (1/(n:ℝ)^2) :=
    mul_le_mul_of_nonneg_left hnt (by positivity)
  have hstep3 : (1/(2*(n:ℝ))) * (1/(n:ℝ)^2) ≤ 1/(n:ℝ)^2 := by
    rw [div_mul_eq_mul_div, one_mul, div_le_iff₀ (by positivity)]
    nlinarith [hn1R, hnR, sq_nonneg (n:ℝ)]
  exact hstep1.trans (hstep2.trans hstep3)


/-- The third moment of the geometric reference: `Σ k³2^{-k} = 26`. -/
lemma tsum_cube_half : (∑' k : ℕ, (k:ℝ)^3 * (1/2:ℝ)^k) = 26 := by
  have hx : ‖(1/2:ℝ)‖ < 1 := by rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  rw [tsum_pow_mul_geometric_of_norm_lt_one 3 hx]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond,
    Nat.factorial, Nat.cast_one, Nat.cast_zero]
  norm_num

/-- The fourth moment of the geometric reference: `Σ k⁴2^{-k} = 150`. -/
lemma tsum_four_half : (∑' k : ℕ, (k:ℝ)^4 * (1/2:ℝ)^k) = 150 := by
  have hx : ‖(1/2:ℝ)‖ < 1 := by rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  rw [tsum_pow_mul_geometric_of_norm_lt_one 4 hx]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond,
    Nat.factorial, Nat.cast_one, Nat.cast_zero]
  norm_num


/-- **Fourth-order log lower bound.**  `x - x²/2 + x³/3 - x⁴/4 ≤ log(1+x)` for `x ≥ 0`,
via `h(x) = x⁴/4 - x + x²/2 - x³/3 + log(1+x)` having `h' = x⁴/(1+x) ≥ 0` and `h(0) = 0`.
Together with `log_one_add_le_cubic` this gives
`0 ≤ x - log(1+x) - x²/2 + x³/3 ≤ x⁴/4`, the third-order input for `Phi`. -/
lemma log_one_add_ge_quartic (x : ℝ) (hx : 0 ≤ x) :
    x - (1/2)*x^2 + (1/3)*x^3 - (1/4)*x^4 ≤ Real.log (1 + x) := by

  have hcont : ContinuousOn (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3 + Real.log (1+t)) (Set.Ici 0) := by
    apply ContinuousOn.add
    · fun_prop
    · exact ContinuousOn.log ((continuous_const.add continuous_id).continuousOn)
        (fun t ht => ne_of_gt (by simp only [Set.mem_Ici] at ht; linarith : (0:ℝ) < 1 + t))
  have hdiff : DifferentiableOn ℝ (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3 + Real.log (1+t)) (interior (Set.Ici 0)) := by
    apply DifferentiableOn.add
    · fun_prop
    · refine DifferentiableOn.log ?_ ?_
      · exact ((differentiable_const 1).add differentiable_id).differentiableOn
      · intro t ht
        rw [interior_Ici] at ht
        exact ne_of_gt (by linarith [Set.mem_Ioi.mp ht] : (0:ℝ) < 1 + t)
  have hmono : MonotoneOn (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3 + Real.log (1+t)) (Set.Ici 0) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hdiff
    intro y hy
    rw [interior_Ici] at hy
    have hy0 : (0:ℝ) < y := hy
    have h1y : (1:ℝ) + y ≠ 0 := by positivity
    have hd : deriv (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3 + Real.log (1+t)) y = y^4/(1+y) := by
      have hpoly : HasDerivAt (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3) (y^3 - 1 + y - y^2) y := by
        have h1 : HasDerivAt (fun t : ℝ => (1/4)*t^4) (y^3) y := by
          have h := (hasDerivAt_id y).pow 4 |>.const_mul ((1:ℝ)/4)
          convert h using 1
          · funext s; rw [Pi.pow_apply, id_eq]
          · simp only [id_eq]; push_cast; ring
        have h2 : HasDerivAt (fun t : ℝ => (1/2)*t^2) y y := by
          have h := (hasDerivAt_id y).pow 2 |>.const_mul ((1:ℝ)/2)
          convert h using 1
          · funext s; rw [Pi.pow_apply, id_eq]
          · simp only [id_eq]; push_cast; ring
        have h3 : HasDerivAt (fun t : ℝ => (1/3)*t^3) (y^2) y := by
          have h := (hasDerivAt_id y).pow 3 |>.const_mul ((1:ℝ)/3)
          convert h using 1
          · funext s; rw [Pi.pow_apply, id_eq]
          · simp only [id_eq]; push_cast; ring
        have hA : HasDerivAt (fun t : ℝ => (1/4)*t^4 - t) (y^3 - 1) y :=
          h1.sub (hasDerivAt_id y)
        have hB : HasDerivAt (fun t : ℝ => (1/2)*t^2 - (1/3)*t^3) (y - y^2) y := h2.sub h3
        have h4 := hA.add hB
        convert h4 using 1
        · funext s; simp only [Pi.sub_apply, Pi.add_apply]; ring
        · ring
      have hB := (Real.hasDerivAt_log h1y).comp y (by simpa using (hasDerivAt_id y).const_add 1 :
        HasDerivAt (fun t : ℝ => 1 + t) 1 y)
      have hC := hpoly.add hB
      have hd0 := hC.deriv
      have hfun : (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3) + (Real.log ∘ HAdd.hAdd 1)
          = (fun t : ℝ => (1/4)*t^4 - t + (1/2)*t^2 - (1/3)*t^3 + Real.log (1+t)) := rfl
      rw [hfun] at hd0
      rw [hd0]
      rw [show (y^3 - 1 + y - y^2) + (1+y)⁻¹ * 1 = y^4/(1+y) by field_simp; ring]
    rw [hd]
    positivity
  have h := hmono (by simp : (0:ℝ) ∈ Set.Ici 0) hx hx
  simp only [Set.mem_Ici] at h
  have h0 : (1/4)*0^4 - 0 + (1/2)*0^2 - (1/3)*0^3 + Real.log (1+0) = 0 := by norm_num
  rw [h0] at h
  linarith [h]


/-- **The `x⁴` remainder of `x − log(1+x)`.**  For `x ≥ 0`,
`0 ≤ x − log(1+x) − x²/2 + x³/3 ≤ x⁴/4`. -/
lemma phi_r_bounds (x : ℝ) (hx : 0 ≤ x) :
    0 ≤ x - Real.log (1 + x) - x^2/2 + x^3/3
      ∧ x - Real.log (1 + x) - x^2/2 + x^3/3 ≤ x^4/4 := by
  constructor
  · have := log_one_add_le_cubic x hx; linarith
  · have := log_one_add_ge_quartic x hx; linarith

/-- `1 + t + t²/2 ≤ exp t` for `t ≥ 0`. -/
lemma exp_ge_quad (t : ℝ) (ht : 0 ≤ t) : 1 + t + t^2/2 ≤ Real.exp t := by
  have hmono : MonotoneOn (fun s : ℝ => Real.exp s - 1 - s - s^2/2) (Set.Ici 0) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0)
    · fun_prop
    · fun_prop
    · intro y hy
      rw [interior_Ici] at hy
      have hy0 : (0:ℝ) < y := hy
      have hd : deriv (fun s : ℝ => Real.exp s - 1 - s - s^2/2) y = Real.exp y - 1 - y := by
        have h2 : HasDerivAt (fun s : ℝ => s^2/2) y y := by
          have h := (hasDerivAt_id y).pow 2 |>.const_mul ((1:ℝ)/2)
          convert h using 1
          · ext s; rw [Pi.pow_apply, id_eq]; try ring
          · simp only [id_eq]; push_cast; ring
        have hB : HasDerivAt (fun s : ℝ => Real.exp s - 1 - s - s^2/2) (Real.exp y - 1 - y) y := by
          have h4 := (((Real.hasDerivAt_exp y).sub (hasDerivAt_const y 1)).sub (hasDerivAt_id y)).sub h2
          have hfun : (Real.exp - (fun _ : ℝ => 1)) - id - (fun s : ℝ => s^2/2)
              = (fun s : ℝ => Real.exp s - 1 - s - s^2/2) := rfl
          rw [hfun] at h4
          convert h4 using 1
          ring
        exact hB.deriv
      rw [hd]
      have := Real.add_one_le_exp y
      linarith
  have h := hmono (by simp : (0:ℝ) ∈ Set.Ici 0) ht ht
  simp only at h
  rw [Real.exp_zero] at h
  norm_num at h
  linarith [h]

/-- **Third-order exponential remainder.**  `|exp z − 1 − z − z²/2| ≤ exp z · z³` for `z ≥ 0`.
Below `z ≤ 1` this is `Real.exp_bound` (giving `≤ (2/9)|z|³`); above, `≤ exp z ≤ exp z·z³`. -/
lemma abs_exp_sub_one_sub_sub_sq_le (z : ℝ) (hz : 0 ≤ z) :
    |Real.exp z - 1 - z - z^2/2| ≤ Real.exp z * z^3 := by
  rcases le_total z 1 with h | h
  · have hx : |z| ≤ 1 := by rw [abs_of_nonneg hz]; exact h
    have hb := Real.exp_bound hx (n := 3) (by norm_num)
    have hsum : (∑ m ∈ Finset.range 3, z^m/((m.factorial : ℕ) : ℝ)) = 1 + z + z^2/2 := by
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]
      norm_num
    rw [hsum] at hb
    have hb' : |Real.exp z - 1 - z - z^2/2| ≤ (2/9) * |z|^3 := by
      have h1 : Real.exp z - 1 - z - z^2/2 = Real.exp z - (1 + z + z^2/2) := by ring
      rw [h1]
      calc |Real.exp z - (1 + z + z^2/2)|
          ≤ |z|^3 * (↑(Nat.succ 3) / (↑(Nat.factorial 3) * ↑3)) := hb
        _ = (2/9) * |z|^3 := by norm_num [Nat.factorial]; ring
    have he : (1:ℝ) ≤ Real.exp z := Real.one_le_exp_iff.mpr hz
    have hz3 : (0:ℝ) ≤ z^3 := by positivity
    have h2 : (2/9) * |z|^3 ≤ Real.exp z * z^3 := by
      rw [abs_of_nonneg hz]
      nlinarith [he, hz3]
    linarith [hb', h2]
  · have hpos : 0 ≤ Real.exp z - 1 - z - z^2/2 := by
      have := exp_ge_quad z hz; linarith
    rw [abs_of_nonneg hpos]
    have h3 : Real.exp z ≤ Real.exp z * z^3 := by
      have he : (0:ℝ) < Real.exp z := Real.exp_pos z
      have hz1 : (1:ℝ) ≤ z^3 := by nlinarith [h, sq_nonneg z]
      nlinarith [he, hz1]
    linarith [h3, sq_nonneg z, hz]


/-- **Third-order setup, part 1.**  The quantity `d = un·(x − log(1+x))` at `x = (j+1)/n`
satisfies `0 ≤ d ≤ u(j+1)²/(2n)`. -/
lemma phi_d_bounds (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (j : ℕ) (hn : 1 ≤ n) :
    0 ≤ u*(n:ℝ)*(((j:ℝ)+1)/(n:ℝ) - Real.log (1 + ((j:ℝ)+1)/(n:ℝ)))
      ∧ u*(n:ℝ)*(((j:ℝ)+1)/(n:ℝ) - Real.log (1 + ((j:ℝ)+1)/(n:ℝ)))
        ≤ u*((j:ℝ)+1)^2/(2*(n:ℝ)) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hk1 : (0:ℝ) < (j:ℝ)+1 := by positivity
  set x : ℝ := ((j:ℝ)+1)/(n:ℝ) with hxdef
  have hx0 : 0 < x := by rw [hxdef]; positivity
  have hku : (0:ℝ) ≤ u := by linarith
  have hs0 : (0:ℝ) ≤ u*(n:ℝ) := by positivity
  constructor
  · apply mul_nonneg hs0
    have h := log_one_add_le x (by linarith)
    linarith [h]
  · have h1 : x - Real.log (1 + x) ≤ x^2/2 := by
      have h := log_one_add_ge x hx0.le
      linarith
    have h2 : u*(n:ℝ) * (x - Real.log (1+x)) ≤ u*(n:ℝ)*(x^2/2) :=
      mul_le_mul_of_nonneg_left h1 hs0
    have h3 : u*(n:ℝ)*(x^2/2) = u*((j:ℝ)+1)^2/(2*(n:ℝ)) := by
      rw [hxdef]; field_simp; try ring
    rw [hxdef] at h2
    linarith [h2, h3.le, h3.ge]

/-! ### The geometric reference sum -/

/-- `Σ'_{k≥1} exp (-u k) = (exp u - 1)^{-1}` for `u > 0`. -/
lemma hasSum_exp_neg (u : ℝ) (hu : 0 < u) :
    HasSum (fun k : ℕ => Real.exp (-(u * ((k : ℝ) + 1)))) ((Real.exp u - 1)⁻¹) := by
  have hx : ‖Real.exp (-u)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    linarith
  have h := (hasSum_geometric_of_norm_lt_one hx).mul_left (Real.exp (-u))
  have hfun : (fun k : ℕ => Real.exp (-u) * (Real.exp (-u)) ^ k)
      = (fun k : ℕ => Real.exp (-(u * ((k : ℝ) + 1)))) := by
    funext k
    rw [← Real.exp_nat_mul, ← Real.exp_add]
    congr 1
    ring
  rw [hfun] at h
  have hval : Real.exp (-u) * (1 - Real.exp (-u))⁻¹ = (Real.exp u - 1)⁻¹ := by
    rw [Real.exp_neg]
    have he : Real.exp u ≠ 0 := Real.exp_ne_zero u
    have h1 : Real.exp u - 1 ≠ 0 := by
      have h2 : (1 : ℝ) < Real.exp u := by
        simpa using Real.exp_lt_exp.mpr hu
      linarith
    field_simp
  rwa [hval] at h

/-! ### The lower bound `Phi ≥ (exp u - 1)^{-1}` -/

/-- The geometric reference sum is a lower bound for `Phi`. -/
lemma geometric_le_Phi (u : ℝ) (n : ℕ) (hn : 1 ≤ n) (hu : 0 < u) (hun : 2 ≤ u * (n : ℝ)) :
    (Real.exp u - 1)⁻¹ ≤ Phi (u * (n : ℝ)) n := by
  have hG := hasSum_exp_neg u hu
  have hT := summable_phi u n hn hun
  have hle : ∀ j : ℕ, Real.exp (-(u * ((j : ℝ) + 1)))
      ≤ (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) := by
    intro j
    have hx : (0 : ℝ) ≤ ((j : ℝ) + 1) / (n : ℝ) := by positivity
    have h := exp_neg_mul_le_rpow u hu.le n (((j : ℝ) + 1) / (n : ℝ)) hx
    rwa [show u * (n : ℝ) * (((j : ℝ) + 1) / (n : ℝ)) = u * ((j : ℝ) + 1) by
      field_simp] at h
  rw [Phi]
  calc (Real.exp u - 1)⁻¹ = ∑' j : ℕ, Real.exp (-(u * ((j : ℝ) + 1))) := hG.tsum_eq.symm
    _ ≤ ∑' j : ℕ, (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) :=
        hG.summable.tsum_le_tsum hle hT

/-! ### The main theorem -/

/-- The explicit constant of `Phi_asymptotic`, `(Σ'_k k² exp(-k/4))/2 + 8`
(and `Σ'_k k² exp(-k/4) = r(1+r)/(1-r)³` at `r = exp(-1/4)`). -/
noncomputable def PhiC : ℝ := (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) / 2 + 8

lemma PhiC_pos : 0 < PhiC := by unfold PhiC; positivity

/-- **The `O(1/n)` expansion of `Phi` in the critical scaling, explicit constant.**
For `n ≥ 4` and `1/2 ≤ u ≤ 1`, `|Phi_{un}(n) - (exp u - 1)^{-1}| ≤ PhiC/n`. -/
theorem Phi_asymptotic_explicit (n : ℕ) (hn : 4 ≤ n) (u : ℝ) (hu1 : 1/2 ≤ u)
    (hu2 : u ≤ 1) :
    |Phi (u * (n : ℝ)) n - (Real.exp u - 1)⁻¹| ≤ PhiC / (n : ℝ) := by
  unfold PhiC
  have hn1 : 1 ≤ n := by omega
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hu : 0 < u := by linarith
  have hnR4 : (4 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hun : 2 ≤ u * (n : ℝ) := by nlinarith [hu1, hnR4]
  have hT : Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))) :=
    summable_phi u n hn1 hun
  have hG : Summable (fun j : ℕ => Real.exp (-(u * ((j : ℝ) + 1)))) :=
    (hasSum_exp_neg u hu).summable
  have hsub : (∑' j : ℕ, ((1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
        - Real.exp (-(u * ((j : ℝ) + 1)))))
      = (∑' j : ℕ, (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
        - (Real.exp u - 1)⁻¹ := by
    rw [hT.tsum_sub hG, (hasSum_exp_neg u hu).tsum_eq]
  have hEq : Phi (u * (n : ℝ)) n - (Real.exp u - 1)⁻¹
      = ∑' j : ℕ, ((1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
          - Real.exp (-(u * ((j : ℝ) + 1)))) := by
    rw [Phi]; exact hsub.symm
  have hsplit := (hT.sub hG).sum_add_tsum_nat_add n
  have hfin : (∑ j ∈ Finset.range n,
        ((1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) - Real.exp (-(u * ((j : ℝ) + 1)))))
      ≤ (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) / (2 * (n : ℝ)) :=
    phi_finite_le u n hu1 hu2 hn1
  have htail : (∑' j : ℕ, (((1 + (((j + n : ℕ) : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
        - Real.exp (-(u * (((j + n : ℕ) : ℝ) + 1))))) ≤ 8 / (n : ℝ) := by
    have h1 : (∑' j : ℕ, (((1 + (((j + n : ℕ) : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ)))
          - Real.exp (-(u * (((j + n : ℕ) : ℝ) + 1)))))
        ≤ ∑' j : ℕ, (1 + (((j + n : ℕ) : ℝ) + 1) / (n : ℝ)) ^ (-(u * (n : ℝ))) := by
      exact ((summable_nat_add_iff n).mpr (hT.sub hG)).tsum_le_tsum
        (fun j => by linarith [Real.exp_pos (-(u * (((j + n : ℕ) : ℝ) + 1)))])
        ((summable_nat_add_iff n).mpr hT)
    have h2 : (∑' j : ℕ, (1 + (((j + n : ℕ) : ℝ) + 1) / (n : ℝ)) ^ (-(u * (n : ℝ))))
        = ∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))) := by
      apply tsum_congr; intro m
      congr 1
      push_cast; ring
    linarith [h1.trans (le_of_eq h2), phi_tail_le_div u n hu1 hn]
  have hlower : (0 : ℝ) ≤ Phi (u * (n : ℝ)) n - (Real.exp u - 1)⁻¹ := by
    have := geometric_le_Phi u n hn1 hu hun
    linarith
  rw [abs_of_nonneg hlower, hEq, ← hsplit]
  have hS : (0 : ℝ) ≤ ∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4)) :=
    tsum_nonneg (fun k => by positivity)
  have hgoal_eq : ((∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) / 2 + 8) / (n : ℝ)
      = (∑' k : ℕ, (k : ℝ) ^ 2 * Real.exp (-((k : ℝ) / 4))) / (2 * (n : ℝ))
        + 8 / (n : ℝ) := by
    have hn0 : (n : ℝ) ≠ 0 := ne_of_gt hnR
    field_simp
  rw [hgoal_eq]
  linarith [hfin, htail]

/-- **The `O(1/n)` expansion of `Phi` in the critical scaling.** -/
theorem Phi_asymptotic :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 4 ≤ n → ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      |Phi (u * (n : ℝ)) n - (Real.exp u - 1)⁻¹| ≤ C / (n : ℝ) :=
  ⟨PhiC, PhiC_pos, Phi_asymptotic_explicit⟩


/-! ### The threshold scaling -/

/-- `|log x - log 2| ≤ |x - 2|` for `x ≥ 1`. -/
lemma abs_log_sub_log_two_le (x : ℝ) (hx : 1 ≤ x) :
    |Real.log x - Real.log 2| ≤ |x - 2| := by
  have hx0 : 0 < x := by linarith
  have h2pos : (0 : ℝ) < 2 := by norm_num
  rw [← Real.log_div (ne_of_gt hx0) (ne_of_gt h2pos)]
  rcases lt_or_ge (x / 2) 1 with h | h
  · have hlt2 : x < 2 := by linarith
    have hlog : Real.log (x / 2) ≤ 0 := Real.log_nonpos (by linarith) (by linarith)
    rw [abs_of_nonpos hlog, abs_of_nonpos (by linarith : x - 2 ≤ 0)]
    have hx2 : (0 : ℝ) < 2 / x := by positivity
    have hlog2 : Real.log (2 / x) ≤ 2 / x - 1 := Real.log_le_sub_one_of_pos hx2
    have hxlog : Real.log (2 / x) = -Real.log (x / 2) := by
      rw [Real.log_div (ne_of_gt h2pos) (ne_of_gt hx0),
          Real.log_div (ne_of_gt hx0) (ne_of_gt h2pos)]
      ring
    rw [hxlog] at hlog2
    have hge : 2 / x - 1 ≤ 2 - x := by
      rw [div_sub_one (ne_of_gt hx0), div_le_iff₀ hx0]
      nlinarith [hx, hlt2]
    linarith
  · have hlog : Real.log (x / 2) ≤ x / 2 - 1 := Real.log_le_sub_one_of_pos (by linarith)
    have hlog0 : 0 ≤ Real.log (x / 2) := Real.log_nonneg h
    rw [abs_of_nonneg hlog0]
    have hb : x / 2 - 1 ≤ |x - 2| := by
      rcases lt_or_ge x 2 with h3 | h3
      · rw [abs_of_nonpos (by linarith)]; linarith
      · rw [abs_of_nonneg (by linarith)]; linarith
    linarith

/-- **The OP-5 threshold sits at `u = log 2 + O(1/n)`.**  If `Phi_{un}(n) = 1` with
`1/2 ≤ u ≤ 1` and `2·PhiC ≤ n`, then `|u - log 2| ≤ 2·PhiC/n`; equivalently the threshold
index satisfies `P_n = n·log 2 + O(1)`. -/
theorem threshold_scaling (n : ℕ) (hn : 4 ≤ n) (hK : 2 * PhiC ≤ (n : ℝ)) (u : ℝ)
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (h : IsThreshold n (u * (n : ℝ))) :
    |u - Real.log 2| ≤ 2 * PhiC / (n : ℝ) := by
  have hnR : (0 : ℝ) < (n : ℝ) := by positivity
  have hKn : PhiC / (n : ℝ) ≤ 1 / 2 := by
    rw [div_le_iff₀ hnR]; linarith
  have hKnn : 0 < PhiC / (n : ℝ) := div_pos PhiC_pos hnR
  have hPhi := Phi_asymptotic_explicit n hn u hu1 hu2
  rw [show Phi (u * (n : ℝ)) n = 1 from h] at hPhi
  obtain ⟨hlo, hhi⟩ := abs_le.mp hPhi
  have h2 : (1 : ℝ) - PhiC / (n : ℝ) ≤ (Real.exp u - 1)⁻¹ := by linarith
  have h3 : (Real.exp u - 1)⁻¹ ≤ 1 + PhiC / (n : ℝ) := by linarith
  have h4 : (0 : ℝ) < (Real.exp u - 1)⁻¹ := by linarith
  have h5 : (0 : ℝ) < Real.exp u - 1 := inv_pos.mp h4
  have h6 : (0 : ℝ) < 1 + PhiC / (n : ℝ) := by linarith
  have h7 : (0 : ℝ) < 1 - PhiC / (n : ℝ) := by linarith
  have einv : Real.exp u - 1 = ((Real.exp u - 1)⁻¹)⁻¹ := (inv_inv _).symm
  have h8 : (1 + PhiC / (n : ℝ))⁻¹ ≤ Real.exp u - 1 := by
    rw [einv]; exact inv_le_inv₀ h6 h4 |>.mpr h3
  have h9 : Real.exp u - 1 ≤ (1 - PhiC / (n : ℝ))⁻¹ := by
    rw [einv]; exact inv_le_inv₀ h4 h7 |>.mpr h2
  have h10 : (2 : ℝ) - PhiC / (n : ℝ) ≤ Real.exp u := by
    have h11 : 1 - PhiC / (n : ℝ) ≤ (1 + PhiC / (n : ℝ))⁻¹ := by
      rw [inv_eq_one_div, le_div_iff₀ h6]
      nlinarith [hKn, hKnn]
    linarith
  have h12 : Real.exp u ≤ 2 + 2 * (PhiC / (n : ℝ)) := by
    have h13 : (1 - PhiC / (n : ℝ))⁻¹ ≤ 1 + 2 * (PhiC / (n : ℝ)) := by
      rw [inv_eq_one_div, div_le_iff₀ h7]
      nlinarith [hKn, hKnn]
    linarith
  have hexp1 : (1 : ℝ) ≤ Real.exp u := by linarith [hu1, Real.exp_pos u]
  have h14 : |Real.exp u - 2| ≤ 2 * (PhiC / (n : ℝ)) := by
    rw [abs_le]; constructor <;> linarith
  have h15 : |u - Real.log 2| ≤ |Real.exp u - 2| := by
    have h := abs_log_sub_log_two_le (Real.exp u) hexp1
    rwa [Real.log_exp u] at h
  calc |u - Real.log 2| ≤ |Real.exp u - 2| := h15
    _ ≤ 2 * (PhiC / (n : ℝ)) := h14
    _ = 2 * PhiC / (n : ℝ) := by ring

/-- **Second-order expansion of `Phi`.**  In the critical scaling `p = un`,
`Φ_{un}(n) − (e^u−1)^{-1} = (u/2n)·ΦS(u) + O(1/n²)`. -/
theorem Phi_second_order (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop,
      |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u| ≤ C/(n:ℝ)^2 := by
  have hu0 : 0 < u := by linarith
  have hG := hasSum_exp_neg u hu0
  have hC : (0:ℝ) < PhiK4/4 + PhiK3/3 + 3 := by linarith [PhiK3_nonneg, PhiK4_nonneg]
  refine ⟨PhiK4/4 + PhiK3/3 + 3, hC, ?_⟩
  filter_upwards [phi_S_finite_part u hu1 hu2, geometric_tail_le_eventually u hu1,
    phi_tail_le_eventually u hu1, Filter.eventually_ge_atTop 4] with n hB hGt hTt hn4
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : 1 ≤ n := by omega
  have hn4R : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn4
  have hun : 2 ≤ u * (n:ℝ) := by
    have h : (1/2:ℝ) * 4 ≤ u * (n:ℝ) :=
      mul_le_mul hu1 hn4R (by norm_num) (le_trans (by norm_num : (0:ℝ) ≤ 1/2) hu1)
    linarith
  have hTs : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n hn1 hun
  have hGs : Summable (fun j : ℕ => Real.exp (-(u*((j:ℝ)+1)))) := hG.summable
  have hDsub : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*((j:ℝ)+1)))) := hTs.sub hGs
  -- Phi - (e^u-1)^{-1} = sum of the differences
  have hsub : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹
      = ∑' j : ℕ, ((1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))) - Real.exp (-(u*((j:ℝ)+1)))) := by
    rw [Phi, ← hG.tsum_eq]
    exact (hTs.tsum_sub hGs).symm
  -- split finite / tail
  have hsplit := hDsub.sum_add_tsum_nat_add n
  have htail : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹
      = (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((i:ℝ)+1)))))
        + (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))) := by
    rw [hsub, ← hsplit]
  -- decompose the finite sum
  have hfin : (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+1)))))
      = (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((i:ℝ)+1)))
            - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
        + (∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => by ring)
  -- bounds
  have hA : |∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+1)))
        - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))|
      ≤ (PhiK4/4 + PhiK3/3)/(n:ℝ)^2 := by
    refine le_trans (Finset.abs_sum_le_sum_abs _ _) ?_
    exact phi_finite_sharp u n hu1 hu2 hn1
  have htailT : |∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))| ≤ 2/(n:ℝ)^2 := by
    have h1 : (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))
        = (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          - ∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))) := by
      apply Summable.tsum_sub
      · exact (summable_nat_add_iff n).mpr hTs
      · exact (summable_nat_add_iff n).mpr hGs
    have hTa : (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) ≤ 1/(n:ℝ)^2 := by
      have heq : (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          = ∑' m : ℕ, (1 + (((m:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))) := by
        apply tsum_congr; intro i; push_cast; ring_nf
      rw [heq]; exact hTt
    have hTb : (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) ≤ 1/(n:ℝ)^2 := by
      have hgs : Summable (fun i : ℕ => Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) :=
        (summable_nat_add_iff n).mpr hGs
      have hb : Summable (fun i : ℕ => Real.exp (-(u*(((i+n:ℕ):ℝ))))) := by
        have hhr : Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ)))) := by
          have hx : ‖Real.exp (-u)‖ < 1 := by
            rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith
          have hgg := (summable_geometric_of_norm_lt_one hx)
          refine hgg.congr (fun k => ?_)
          rw [← Real.exp_nat_mul]; congr 1; ring
        exact (summable_nat_add_iff n).mpr hhr
      have hle : ∀ i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))) ≤ Real.exp (-(u*(((i+n:ℕ):ℝ)))) := by
        intro i; apply Real.exp_le_exp.mpr
        push_cast
        nlinarith [hu0, (Nat.cast_nonneg i : (0:ℝ) ≤ (i:ℝ)), (Nat.cast_nonneg n : (0:ℝ) ≤ (n:ℝ))]
      exact le_trans (hgs.tsum_le_tsum hle hb) hGt
    rw [h1]
    have ha0 : 0 ≤ (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
      tsum_nonneg (fun i => by positivity)
    have hb0 : 0 ≤ (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) :=
      tsum_nonneg (fun i => by positivity)
    calc |(∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          - (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))| 
        ≤ |(∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))| 
          + |(∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))| := by
          have := abs_add_le (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
            (-(∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))
          simpa [abs_neg, sub_eq_add_neg] using this
      _ = (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          + (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) := by
          rw [abs_of_nonneg ha0, abs_of_nonneg hb0]
      _ ≤ 1/(n:ℝ)^2 + 1/(n:ℝ)^2 := by linarith [hTa, hTb]
      _ = 2/(n:ℝ)^2 := by ring
  -- assemble
  have hgoal : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u
      = (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((i:ℝ)+1)))
            - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
        + ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
            - u/(2*(n:ℝ)) * PhiS u)
        + (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))) := by
    rw [htail, hfin]; ring
  rw [hgoal]
  have hB2 : |(∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
      - u/(2*(n:ℝ)) * PhiS u| ≤ 1/(n:ℝ)^2 := hB
  calc |(∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
      + ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u)
      + (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))|
      ≤ |(∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))| 
        + |(∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u| 
        + |(∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))| := by
        have h2 := abs_add_le (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
          ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u)
        have h3 := abs_add_le ((∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
          + ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u))
          (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))
        linarith [h2, h3]
    _ ≤ (PhiK4/4 + PhiK3/3)/(n:ℝ)^2 + 1/(n:ℝ)^2 + 2/(n:ℝ)^2 :=
        add_le_add (add_le_add hA hB2) htailT
    _ = (PhiK4/4 + PhiK3/3 + 3)/(n:ℝ)^2 := by ring

theorem Phi_second_order_uniform :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u| ≤ C/(n:ℝ)^2 := by
  have hC : (0:ℝ) < PhiK4/4 + PhiK3/3 + 3 := by linarith [PhiK3_nonneg, PhiK4_nonneg]
  refine ⟨PhiK4/4 + PhiK3/3 + 3, hC, ?_⟩
  filter_upwards [phi_S_finite_part_uniform, geometric_tail_le_eventually_uniform,
    phi_tail_le_eventually_uniform, Filter.eventually_ge_atTop 4] with n hB hGt hTt hn4
  intro u hu1 hu2
  have hu0 : 0 < u := by linarith
  have hG := hasSum_exp_neg u hu0
  have hB' : |(∑ j ∈ Finset.range n, Real.exp (-(u*((j:ℝ)+1))) * (u*((j:ℝ)+1)^2/(2*(n:ℝ))))
        - u/(2*(n:ℝ)) * PhiS u| ≤ 1/(n:ℝ)^2 := hB u hu1 hu2
  have hGt' : (∑' i : ℕ, Real.exp (-(u * ((i + n : ℕ) : ℝ)))) ≤ 1/(n:ℝ)^2 := hGt u hu1
  have hTt' : (∑' m : ℕ, (1 + (((m : ℝ) + (n : ℝ) + 1) / (n : ℝ))) ^ (-(u * (n : ℝ))))
      ≤ 1 / (n : ℝ) ^ 2 := hTt u hu1
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : 1 ≤ n := by omega
  have hn4R : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn4
  have hun : 2 ≤ u * (n:ℝ) := by
    have h : (1/2:ℝ) * 4 ≤ u * (n:ℝ) :=
      mul_le_mul hu1 hn4R (by norm_num) (le_trans (by norm_num : (0:ℝ) ≤ 1/2) hu1)
    linarith
  have hTs : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n hn1 hun
  have hGs : Summable (fun j : ℕ => Real.exp (-(u*((j:ℝ)+1)))) := hG.summable
  have hDsub : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*((j:ℝ)+1)))) := hTs.sub hGs
  -- Phi - (e^u-1)^{-1} = sum of the differences
  have hsub : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹
      = ∑' j : ℕ, ((1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))) - Real.exp (-(u*((j:ℝ)+1)))) := by
    rw [Phi, ← hG.tsum_eq]
    exact (hTs.tsum_sub hGs).symm
  -- split finite / tail
  have hsplit := hDsub.sum_add_tsum_nat_add n
  have htail : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹
      = (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((i:ℝ)+1)))))
        + (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))) := by
    rw [hsub, ← hsplit]
  -- decompose the finite sum
  have hfin : (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+1)))))
      = (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((i:ℝ)+1)))
            - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
        + (∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => by ring)
  -- bounds
  have hA : |∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+1)))
        - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))|
      ≤ (PhiK4/4 + PhiK3/3)/(n:ℝ)^2 := by
    refine le_trans (Finset.abs_sum_le_sum_abs _ _) ?_
    exact phi_finite_sharp u n hu1 hu2 hn1
  have htailT : |∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))| ≤ 2/(n:ℝ)^2 := by
    have h1 : (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))
        = (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          - ∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))) := by
      apply Summable.tsum_sub
      · exact (summable_nat_add_iff n).mpr hTs
      · exact (summable_nat_add_iff n).mpr hGs
    have hTa : (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) ≤ 1/(n:ℝ)^2 := by
      have heq : (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          = ∑' m : ℕ, (1 + (((m:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))) := by
        apply tsum_congr; intro i; push_cast; ring_nf
      rw [heq]; exact hTt'
    have hTb : (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) ≤ 1/(n:ℝ)^2 := by
      have hgs : Summable (fun i : ℕ => Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) :=
        (summable_nat_add_iff n).mpr hGs
      have hb : Summable (fun i : ℕ => Real.exp (-(u*(((i+n:ℕ):ℝ))))) := by
        have hhr : Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ)))) := by
          have hx : ‖Real.exp (-u)‖ < 1 := by
            rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith
          have hgg := (summable_geometric_of_norm_lt_one hx)
          refine hgg.congr (fun k => ?_)
          rw [← Real.exp_nat_mul]; congr 1; ring
        exact (summable_nat_add_iff n).mpr hhr
      have hle : ∀ i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))) ≤ Real.exp (-(u*(((i+n:ℕ):ℝ)))) := by
        intro i; apply Real.exp_le_exp.mpr
        push_cast
        nlinarith [hu0, (Nat.cast_nonneg i : (0:ℝ) ≤ (i:ℝ)), (Nat.cast_nonneg n : (0:ℝ) ≤ (n:ℝ))]
      exact le_trans (hgs.tsum_le_tsum hle hb) hGt'
    rw [h1]
    have ha0 : 0 ≤ (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
      tsum_nonneg (fun i => by positivity)
    have hb0 : 0 ≤ (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) :=
      tsum_nonneg (fun i => by positivity)
    calc |(∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          - (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))| 
        ≤ |(∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))| 
          + |(∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))| := by
          have := abs_add_le (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
            (-(∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))
          simpa [abs_neg, sub_eq_add_neg] using this
      _ = (∑' i : ℕ, (1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
          + (∑' i : ℕ, Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))) := by
          rw [abs_of_nonneg ha0, abs_of_nonneg hb0]
      _ ≤ 1/(n:ℝ)^2 + 1/(n:ℝ)^2 := by linarith [hTa, hTb]
      _ = 2/(n:ℝ)^2 := by ring
  -- assemble
  have hgoal : Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u
      = (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((i:ℝ)+1)))
            - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
        + ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
            - u/(2*(n:ℝ)) * PhiS u)
        + (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
            - Real.exp (-(u*((((i+n:ℕ):ℝ)+1)))))) := by
    rw [htail, hfin]; ring
  rw [hgoal]
  have hB2 := hB'
  calc |(∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
      + ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u)
      + (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))|
      ≤ |(∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))| 
        + |(∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u| 
        + |(∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))| := by
        have h2 := abs_add_le (∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
          ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u)
        have h3 := abs_add_le ((∑ i ∈ Finset.range n, ((1 + (((i:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((i:ℝ)+1)))
          - Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ)))))
          + ((∑ i ∈ Finset.range n, Real.exp (-(u*((i:ℝ)+1))) * (u*((i:ℝ)+1)^2/(2*(n:ℝ))))
          - u/(2*(n:ℝ)) * PhiS u))
          (∑' i : ℕ, ((1 + ((((i+n:ℕ):ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
          - Real.exp (-(u*((((i+n:ℕ):ℝ)+1))))))
        linarith [h2, h3]
    _ ≤ (PhiK4/4 + PhiK3/3)/(n:ℝ)^2 + 1/(n:ℝ)^2 + 2/(n:ℝ)^2 :=
        add_le_add (add_le_add hA hB2) htailT
    _ = (PhiK4/4 + PhiK3/3 + 3)/(n:ℝ)^2 := by ring





/-- **Second-order threshold inversion.**  If `Φ_{un}(n) = 1` with `u ∈ [1/2,1]`, then
`u = log 2 + (3 log 2)/(2n) + O(1/n²)`. -/
theorem threshold_second_order (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop,
      IsThreshold n (u*(n:ℝ)) →
        |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ C/(n:ℝ)^2 := by
  obtain ⟨C0, hC0pos, hev0⟩ := Phi_second_order u hu1 hu2
  have hL0 : (0:ℝ) ≤ PhiL := by rw [PhiL]; exact tsum_nonneg (fun k => by positivity)
  refine ⟨1008 + C0/2 + 8*PhiL, by linarith [hC0pos, hL0], ?_⟩
  have hN : ∀ᶠ n : ℕ in Filter.atTop, (32:ℕ) ≤ n ∧ C0 ≤ (n:ℝ) := by
    filter_upwards [Filter.eventually_ge_atTop 32, Filter.eventually_ge_atTop (Nat.ceil C0)]
      with n h1 h2
    exact ⟨h1, le_trans (Nat.le_ceil C0) (by exact_mod_cast h2)⟩
  filter_upwards [hev0, hN] with n hbound hbig
  obtain ⟨hn32, hnC0⟩ := hbig
  intro hthr
  have hn1 : 1 ≤ n := by omega
  have hC0n : 0 ≤ C0 := hC0pos.le
  have hExpB := threshold_exp_bound u hu1 hu2 n hn1 C0 hC0n hnC0 hn32 hbound hthr
  have h1 := threshold_log_bound u n hn32 hExpB
  have h2 := threshold_second_term u hu1 hu2 n hn1 C0 hC0n hnC0 hn32 hbound hthr
  have hA : |u - Real.log 2| ≤ 32/(n:ℝ) := by
    have hexp1 : (1:ℝ) ≤ Real.exp u := by
      rw [Real.one_le_exp_iff]; linarith
    have h := abs_log_sub_log_two_le (Real.exp u) hexp1
    rw [Real.log_exp u] at h
    exact h.trans hExpB
  have h3 := threshold_main_term u hu1 n hn32 hA
  have hsum : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))|
      ≤ |u - Real.log 2 - (Real.exp u - 2)/2|
        + |(Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u|
        + |u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))| := by
    have heq : u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))
        = (u - Real.log 2 - (Real.exp u - 2)/2)
          + ((Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u)
          + (u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))) := by ring
    rw [heq]
    have hA1 := abs_add_le ((u - Real.log 2 - (Real.exp u - 2)/2)
      + ((Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u))
      (u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ)))
    have hA2 := abs_add_le (u - Real.log 2 - (Real.exp u - 2)/2)
      ((Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u)
    linarith [hA1, hA2]
  refine hsum.trans ?_
  calc |u - Real.log 2 - (Real.exp u - 2)/2|
        + |(Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u|
        + |u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))|
      ≤ 512/(n:ℝ)^2 + (256 + C0/2)/(n:ℝ)^2 + (240 + 8*PhiL)/(n:ℝ)^2 :=
        add_le_add (add_le_add h1 h2) h3
    _ = (1008 + C0/2 + 8*PhiL)/(n:ℝ)^2 := by ring


theorem threshold_second_order_uniform :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      IsThreshold n (u*(n:ℝ)) →
        |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ C/(n:ℝ)^2 := by
  obtain ⟨C0, hC0pos, hev0⟩ := Phi_second_order_uniform
  have hL0 : (0:ℝ) ≤ PhiL := by rw [PhiL]; exact tsum_nonneg (fun k => by positivity)
  refine ⟨1008 + C0/2 + 8*PhiL, by linarith [hC0pos, hL0], ?_⟩
  have hN : ∀ᶠ n : ℕ in Filter.atTop, (32:ℕ) ≤ n ∧ C0 ≤ (n:ℝ) := by
    filter_upwards [Filter.eventually_ge_atTop 32, Filter.eventually_ge_atTop (Nat.ceil C0)]
      with n h1 h2
    exact ⟨h1, le_trans (Nat.le_ceil C0) (by exact_mod_cast h2)⟩
  filter_upwards [hev0, hN] with n hbound hbig
  obtain ⟨hn32, hnC0⟩ := hbig
  intro u hu1 hu2 hthr
  have hbound' : |Phi (u*(n:ℝ)) n - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ)) * PhiS u|
      ≤ C0/(n:ℝ)^2 := hbound u hu1 hu2
  have hn1 : 1 ≤ n := by omega
  have hC0n : 0 ≤ C0 := hC0pos.le
  have hExpB := threshold_exp_bound u hu1 hu2 n hn1 C0 hC0n hnC0 hn32 hbound' hthr
  have h1 := threshold_log_bound u n hn32 hExpB
  have h2 := threshold_second_term u hu1 hu2 n hn1 C0 hC0n hnC0 hn32 hbound' hthr
  have hA : |u - Real.log 2| ≤ 32/(n:ℝ) := by
    have hexp1 : (1:ℝ) ≤ Real.exp u := by
      rw [Real.one_le_exp_iff]; linarith
    have h := abs_log_sub_log_two_le (Real.exp u) hexp1
    rw [Real.log_exp u] at h
    exact h.trans hExpB
  have h3 := threshold_main_term u hu1 n hn32 hA
  have hsum : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))|
      ≤ |u - Real.log 2 - (Real.exp u - 2)/2|
        + |(Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u|
        + |u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))| := by
    have heq : u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))
        = (u - Real.log 2 - (Real.exp u - 2)/2)
          + ((Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u)
          + (u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))) := by ring
    rw [heq]
    have hA1 := abs_add_le ((u - Real.log 2 - (Real.exp u - 2)/2)
      + ((Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u))
      (u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ)))
    have hA2 := abs_add_le (u - Real.log 2 - (Real.exp u - 2)/2)
      ((Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u)
    linarith [hA1, hA2]
  refine hsum.trans ?_
  calc |u - Real.log 2 - (Real.exp u - 2)/2|
        + |(Real.exp u - 2)/2 - u/(4*(n:ℝ)) * PhiS u|
        + |u/(4*(n:ℝ)) * PhiS u - 3*Real.log 2/(2*(n:ℝ))|
      ≤ 512/(n:ℝ)^2 + (256 + C0/2)/(n:ℝ)^2 + (240 + 8*PhiL)/(n:ℝ)^2 :=
        add_le_add (add_le_add h1 h2) h3
    _ = (1008 + C0/2 + 8*PhiL)/(n:ℝ)^2 := by ring



end

end Op56
