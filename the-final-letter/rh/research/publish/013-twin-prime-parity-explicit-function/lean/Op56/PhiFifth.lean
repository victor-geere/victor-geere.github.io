/-
  Op56/PhiFifth.lean — the *fifth-order* (fourth-order-in-`n`) refinement of the
  geometrically-dominated asymptotics of `Phi`.

  `Op56/PhiFourth.lean` proved, uniformly for `u ∈ [1/2,1]`,

      Phi (u*n) n = (e^u − 1)^{-1} + u·PhiS(u)/(2n) + D(u)/n² + E(u)/n³ + O(n⁻⁴),

  with `D(u) = −(u/3)·PhiK3u(u) + (u²/8)·PhiK4u(u)` and
  `E(u) = (u/4)·PhiK4u(u) − (u²/6)·PhiK5u(u) + (u³/48)·PhiK6u(u)`.

  The desired threshold statement is

      u = L + 3L/(2n) + (3L² − (25/12)L)/n² + ((73L − 244L² + 200L³)/8)/n³ + O(n⁻⁴),
      L = log 2,

  uniformly over the threshold solutions `Phi (u*n) n = 1`.

  **Status.**  This file lands the *complete one-order-sharpened analytic layer* the
  inversion needs, but **does not yet land `threshold_fourth_order_uniform` itself**.
  Everything below is proved (0 `sorry`, 0 `axiom`):

  * `exp_sub_three_bound` — the cubic exponential remainder
    `|e^x − 1 − x − x²/2 − x³/6| ≤ 4|x|⁴e^{|x|}`;
  * `phiS_term_taylor3`, `PhiS_taylor3_at_log2` — `PhiS(u) = 6 − 26δ + 75δ² − (541/3)δ³
    + O(δ⁴)`, `δ = u − log 2`, with the explicit constant `4·10¹⁵`;
  * `tsum_quad_poly_log2` — the reusable moment identity
    `Σ k²2^{−k}(c₀+c₁k+c₂k²+c₃k³) = 6c₀+26c₁+150c₂+1082c₃`;
  * `uPhiS_expansion_fourth` — `u·PhiS(u) = 6L + (6−26L)δ + (−26+75L)δ²
    + (75−(541/3)L)δ³ + O(δ⁴)`;
  * `D`, `SFourth` — the second/third-order coefficients as standalone objects;
  * `tsum_pow_exp_neg_quarter_le`, `phiS_term_taylor_quarter`,
    `tsum_pow_exp_first_order`, `PhiK_diff_linear_le` — a general first-order expansion
    `Σ k^m e^{−uk} = Σ k^m e^{−Lk} − δ·Σ k^{m+1}e^{−Lk} + O(δ²)` for `3 ≤ m ≤ 6`;
  * `D_first_order` — `D(u) = D(L) + D'(L)δ + O(δ²)` with the exact
    `D'(L) = −26/3 + (175/2)L − (541/4)L²`;
  * `EFourth_diff_le` — the Lipschitz bound `|E(u) − E(L)| ≤ 10²¹|δ|`.

  **What remains for the headline.**  One assembly lemma
  `psi_model_of_candidate` is missing: with `a₁ = 3L/2`, `a₂ = 3L² − (25/12)L`,
  `a₃ = (73L − 244L² + 200L³)/8`, `q = a₁/n + a₂/n² + a₃/n³` and
  `ψ(x) = x + x²/2 + x³/6`, one must show
  `|ψ(q) − (SFourth(L+q,n)/2 + SFourth(L+q,n)²/2 + SFourth(L+q,n)³/2)| ≤ C/n⁴`.
  The three coefficient identities
  `B₀/2 = a₁`, `b₁a₁/2 + B₀²/2 + D₀/2 = a₂ + a₁²/2`,
  `b₂a₁²/2 + D₁a₁/2 + E₀/2 + B₀b₁a₁ + B₀D₀ + B₀³/2 = a₃ + a₁a₂ + a₁³/6`
  (with `B₀ = 3L`, `b₁ = (6−26L)/2`, `b₂ = (−26+75L)/2`,
  `D₀ = −(26/3)L + (75/4)L²`, `D₁ = D'(L)`, `E₀ = E(L)`) are `ring`-level and all
  ingredients above suffice; only the explicit `O(n⁻⁴)` bookkeeping over the
  `(1/n)`-graded expansion of `SFourth` was not completed here.
-/
import Op56.PhiFourth

namespace Op56

noncomputable section

open scoped BigOperators Topology

set_option maxHeartbeats 4000000

/-! ### The cubic exponential remainder -/

/-- **Cubic exponential remainder.**  For every real `x`,
`|e^x − 1 − x − x²/2 − x³/6| ≤ 4·|x|⁴·e^{|x|}`.  For `|x| ≤ 1` this is `Real.exp_bound`
at `n = 4` (whose constant `5/96` is far below `4`); for `|x| > 1` the polynomial and the
exponential are both dominated by `|x|⁴·e^{|x|}`. -/
lemma exp_sub_three_bound (x : ℝ) :
    |Real.exp x - 1 - x - x^2/2 - x^3/6| ≤ 4 * |x|^4 * Real.exp |x| := by
  rcases le_or_gt |x| 1 with hx | hx
  · have h := Real.exp_bound hx (n := 4) (by norm_num)
    have hsum : (∑ m ∈ Finset.range 4, x ^ m / (m.factorial : ℝ))
        = 1 + x + x^2/2 + x^3/6 := by
      norm_num [Finset.sum_range_succ]
    rw [hsum] at h
    have hfac : ((4:ℕ).succ : ℝ) / ((4:ℕ).factorial * ((4:ℕ):ℝ)) = 5/96 := by norm_num
    rw [hfac] at h
    have hx4 : (0:ℝ) ≤ |x|^4 := by positivity
    have hexp : (1:ℝ) ≤ Real.exp |x| := Real.one_le_exp_iff.mpr (abs_nonneg x)
    have h5 : |x|^4 * (5/96) ≤ 4 * |x|^4 * Real.exp |x| := by
      have hc : (5/96 : ℝ) ≤ 4 * Real.exp |x| := by nlinarith
      calc |x|^4 * (5/96) ≤ |x|^4 * (4 * Real.exp |x|) :=
            mul_le_mul_of_nonneg_left hc hx4
        _ = 4 * |x|^4 * Real.exp |x| := by ring
    rw [show Real.exp x - 1 - x - x^2/2 - x^3/6
        = Real.exp x - (1 + x + x^2/2 + x^3/6) by ring]
    linarith [h, h5]
  · have hx1 : (1:ℝ) ≤ |x| := le_of_lt hx
    have hx0 : (0:ℝ) < |x| := by linarith
    have hexp_le : Real.exp x ≤ Real.exp |x| := Real.exp_le_exp.mpr (le_abs_self x)
    have hpoly : |1 + x + x^2/2 + x^3/6| ≤ 1 + |x| + |x|^2/2 + |x|^3/6 := by
      rw [abs_le]
      have hxx : x ≤ |x| := le_abs_self x
      have hnx : -|x| ≤ x := neg_abs_le x
      have hs : x^2 = |x|^2 := (sq_abs x).symm
      constructor
      · nlinarith [hxx, hnx, abs_nonneg x]
      · nlinarith [hxx, hnx, abs_nonneg x]
    have hB : 1 + |x| + |x|^2/2 + |x|^3/6 ≤ (8/3) * |x|^4 := by
      have h1 : (1:ℝ) ≤ |x|^4 := one_le_pow₀ hx1
      have h2 : |x| ≤ |x|^4 := by
        have h : |x|^1 ≤ |x|^4 := pow_le_pow_right₀ hx1 (by norm_num : 1 ≤ 4)
        simpa using h
      have h3 : |x|^2 ≤ |x|^4 := pow_le_pow_right₀ hx1 (by norm_num : 2 ≤ 4)
      have h4 : |x|^3/6 ≤ |x|^4/6 := by
        have h : |x|^3 ≤ |x|^4 := pow_le_pow_right₀ hx1 (by norm_num : 3 ≤ 4)
        linarith
      nlinarith [h1, h2, h3, h4]
    have hexp4 : Real.exp |x| ≤ |x|^4 * Real.exp |x| := by
      have h1 : (1:ℝ) ≤ |x|^4 := one_le_pow₀ hx1
      nlinarith [Real.exp_pos |x|]
    have htri : |Real.exp x - (1 + x + x^2/2 + x^3/6)|
        ≤ Real.exp x + |1 + x + x^2/2 + x^3/6| := by
      calc |Real.exp x - (1 + x + x^2/2 + x^3/6)|
          = |Real.exp x + -(1 + x + x^2/2 + x^3/6)| := by ring_nf
        _ ≤ |Real.exp x| + |-(1 + x + x^2/2 + x^3/6)| := abs_add_le _ _
        _ = Real.exp x + |1 + x + x^2/2 + x^3/6| := by
              rw [abs_of_pos (Real.exp_pos x), abs_neg]
    have hexpB : Real.exp x + (1 + |x| + |x|^2/2 + |x|^3/6)
        ≤ 4 * |x|^4 * Real.exp |x| := by
      have h4e : Real.exp |x| ≤ |x|^4 * Real.exp |x| := hexp4
      have hB8 : (8/3) * |x|^4 ≤ (8/3) * (|x|^4 * Real.exp |x|) := by
        have h1 : (1:ℝ) ≤ Real.exp |x| := Real.one_le_exp_iff.mpr (abs_nonneg x)
        nlinarith [pow_nonneg (abs_nonneg x) 4]
      nlinarith [hexp_le, h4e, hB, hB8]
    rw [show Real.exp x - 1 - x - x^2/2 - x^3/6
        = Real.exp x - (1 + x + x^2/2 + x^3/6) by ring]
    linarith [htri, hpoly, hexpB]

/-! ### Termwise third-order Taylor expansion of `e^{−uk}` -/

/-- **Termwise cubic Taylor bound for the `PhiS`-summands.**  With `x = −(u−b)k`,
`|e^{−uk} − e^{−bk}(1 + x + x²/2 + x³/6)| ≤ 4·k⁴·e^{−k/8}·(u−b)⁴` for `b ≥ 5/8`,
`|u−b| ≤ 1/2`.  Direct consequence of `exp_sub_three_bound` and
`e^{−bk}e^{|x|} ≤ e^{−k/8}` (as in `phiS_term_taylor`). -/
lemma phiS_term_taylor3 (u b : ℝ) (hb : 5/8 ≤ b) (hub : |u - b| ≤ 1/2) (k : ℕ) :
    |Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
        * (1 + (-(u - b)*(k:ℝ)) + (-(u - b)*(k:ℝ))^2/2 + (-(u - b)*(k:ℝ))^3/6)|
      ≤ 4 * ((k:ℝ)^4) * Real.exp (-((k:ℝ)/8)) * (u - b)^4 := by
  set x : ℝ := -(u - b) * (k:ℝ) with hx
  have hk0 : (0:ℝ) ≤ (k:ℝ) := by positivity
  have h1 : Real.exp (-(u*(k:ℝ))) = Real.exp (-(b*(k:ℝ))) * Real.exp x := by
    rw [hx, show -(u*(k:ℝ)) = -(b*(k:ℝ)) + (-(u - b) * (k:ℝ)) by ring, Real.exp_add]
  have hkey : Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ))) * (1 + x + x^2/2 + x^3/6)
      = Real.exp (-(b*(k:ℝ))) * (Real.exp x - 1 - x - x^2/2 - x^3/6) := by
    rw [h1]; ring
  rw [hkey, abs_mul, abs_of_nonneg (le_of_lt (Real.exp_pos _))]
  have h3 : |Real.exp x - 1 - x - x^2/2 - x^3/6| ≤ 4 * |x|^4 * Real.exp |x| :=
    exp_sub_three_bound x
  have h4 : |x|^4 = ((k:ℝ)^4) * (u - b)^4 := by
    rw [hx, abs_mul, abs_neg, abs_of_nonneg hk0, mul_pow]
    rw [show |u - b|^4 = (u - b)^4 by
      rw [← abs_pow, abs_of_nonneg (by positivity : (0:ℝ) ≤ (u - b)^4)]]
    ring
  have h5 : Real.exp (-(b*(k:ℝ))) * Real.exp |x| ≤ Real.exp (-((k:ℝ)/8)) := by
    have h51 : Real.exp |x| ≤ Real.exp ((k:ℝ)/2) := by
      apply Real.exp_le_exp.mpr
      rw [hx, abs_mul, abs_of_nonneg hk0, abs_neg]
      have hform : ((1/2:ℝ) * (k:ℝ)) = (k:ℝ)/2 := by ring
      rw [← hform]
      exact mul_le_mul_of_nonneg_right hub hk0
    have h52 : Real.exp (-(b*(k:ℝ))) * Real.exp ((k:ℝ)/2) ≤ Real.exp (-((k:ℝ)/8)) := by
      rw [show Real.exp (-(b*(k:ℝ))) * Real.exp ((k:ℝ)/2)
          = Real.exp (-(b*(k:ℝ)) + (k:ℝ)/2) by rw [Real.exp_add]]
      apply Real.exp_le_exp.mpr
      nlinarith [hb, hk0]
    have hE0 : (0:ℝ) ≤ Real.exp (-(b*(k:ℝ))) := le_of_lt (Real.exp_pos _)
    exact (mul_le_mul_of_nonneg_left h51 hE0).trans h52
  have hstep1 : Real.exp (-(b*(k:ℝ))) * |Real.exp x - 1 - x - x^2/2 - x^3/6|
      ≤ Real.exp (-(b*(k:ℝ))) * (4 * |x|^4 * Real.exp |x|) :=
    mul_le_mul_of_nonneg_left h3 (le_of_lt (Real.exp_pos _))
  have hstep2 : Real.exp (-(b*(k:ℝ))) * (4 * |x|^4 * Real.exp |x|)
      ≤ 4 * ((k:ℝ)^4) * Real.exp (-((k:ℝ)/8)) * (u - b)^4 := by
    have h6 : Real.exp (-(b*(k:ℝ))) * (4 * |x|^4 * Real.exp |x|)
        = 4 * ((k:ℝ)^4) * (u - b)^4 * (Real.exp (-(b*(k:ℝ))) * Real.exp |x|) := by
      rw [h4]; ring
    rw [h6]
    have hpos : (0:ℝ) ≤ 4 * ((k:ℝ)^4) * (u - b)^4 := by positivity
    calc 4 * ((k:ℝ)^4) * (u - b)^4 * (Real.exp (-(b*(k:ℝ))) * Real.exp |x|)
        ≤ 4 * ((k:ℝ)^4) * (u - b)^4 * Real.exp (-((k:ℝ)/8)) :=
          mul_le_mul_of_nonneg_left h5 hpos
      _ = 4 * ((k:ℝ)^4) * Real.exp (-((k:ℝ)/8)) * (u - b)^4 := by ring
  linarith [hstep1, hstep2]

/-! ### Closed form of `Σ k² (1/2)^k P(k)` -/

/-- **Quadratic-weight moment identity.**  For any real `c₀,…,c₃`,
`Σ_k k²2^{−k}(c₀ + c₁k + c₂k² + c₃k³) = 6c₀ + 26c₁ + 150c₂ + 1082c₃`, using the
moments `Σk²2^{−k} = 6`, `Σk³2^{−k} = 26`, `Σk⁴2^{−k} = 150`, `Σk⁵2^{−k} = 1082`. -/
lemma tsum_quad_poly_log2 (c0 c1 c2 c3 : ℝ) :
    (∑' k : ℕ, (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))
        * (c0 + c1*(k:ℝ) + c2*(k:ℝ)^2 + c3*(k:ℝ)^3))
      = c0*6 + c1*26 + c2*150 + c3*1082 := by
  have hL : (0:ℝ) < Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have hLh : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have h0 : Summable (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_S (Real.log 2) hL
  have h1 : Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hLh 3
  have h2 : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hLh 4
  have h3 : Summable (fun k : ℕ => (k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_PhiK5u (Real.log 2) hLh
  have H0 : Summable (fun k : ℕ => c0 * ((k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ))))) :=
    h0.mul_left c0
  have H1 : Summable (fun k : ℕ => c1 * ((k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ))))) :=
    h1.mul_left c1
  have H2 : Summable (fun k : ℕ => c2 * ((k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ))))) :=
    h2.mul_left c2
  have H3 : Summable (fun k : ℕ => c3 * ((k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ))))) :=
    h3.mul_left c3
  have H01 : Summable (fun k : ℕ => c0 * ((k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ))))
      + c1 * ((k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ))))) := H0.add H1
  have H012 : Summable (fun k : ℕ => (c0 * ((k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ))))
      + c1 * ((k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))))
      + c2 * ((k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ))))) := H01.add H2
  have H0123 : Summable (fun k : ℕ => ((c0 * ((k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ))))
      + c1 * ((k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))))
      + c2 * ((k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ)))))
      + c3 * ((k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ))))) := H012.add H3
  rw [show (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))
        * (c0 + c1*(k:ℝ) + c2*(k:ℝ)^2 + c3*(k:ℝ)^3))
      = (fun k : ℕ => ((c0 * ((k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ))))
          + c1 * ((k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))))
          + c2 * ((k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ)))))
          + c3 * ((k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ))))) from by funext k; ring]
  rw [Summable.tsum_add H012 H3, Summable.tsum_add H01 H2, Summable.tsum_add H0 H1]
  rw [tsum_mul_left, tsum_mul_left, tsum_mul_left, tsum_mul_left]
  have e0 : (∑' k : ℕ, (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))) = 6 := PhiS_log_two
  have e1 : (∑' k : ℕ, (k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))) = 26 := PhiK3u_log_two
  have e2 : (∑' k : ℕ, (k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ)))) = 150 := PhiK4u_log_two
  have e3 : (∑' k : ℕ, (k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ)))) = 1082 := PhiK5u_log_two
  rw [e0, e1, e2, e3]

/-- **Third-order Taylor expansion of `ΦS` at `log 2`.**
`ΦS(u) = 6 − 26δ + 75δ² − (541/3)δ³ + O(δ⁴)`, `δ = u − log 2`, uniformly on `[1/2,1]`,
with the explicit constant `4·10¹⁵`. -/
lemma PhiS_taylor3_at_log2 (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |PhiS u - (6 - 26*(u - Real.log 2) + 75*(u - Real.log 2)^2
        - (541/3)*(u - Real.log 2)^3)| ≤ 4*10^15 * (u - Real.log 2)^4 := by
  have hl1 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have hl2 : Real.log 2 ≤ 1 := log_two_le_one
  have hub : |u - Real.log 2| ≤ 1/2 := by
    rw [abs_sub_le_iff]; constructor <;> linarith
  have hb : (5/8:ℝ) ≤ Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have hLpos : (0:ℝ) < Real.log 2 := by have := Real.log_two_gt_d9; linarith
  let A : ℕ → ℝ := fun k => (k:ℝ)^2 * Real.exp (-(u*(k:ℝ)))
  let B : ℕ → ℝ := fun k => (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))
        * (1 + (-(u - Real.log 2)*(k:ℝ)) + (-(u - Real.log 2)*(k:ℝ))^2/2
           + (-(u - Real.log 2)*(k:ℝ))^3/6)
  let M : ℕ → ℝ := fun k => 4 * (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^4
  have hterm : ∀ k : ℕ, |A k - B k| ≤ M k := by
    intro k
    dsimp only [A, B, M]
    have hk := phiS_term_taylor3 u (Real.log 2) hb hub k
    have hk2 : |(k:ℝ)^2| * |Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2*(k:ℝ)))
          * (1 + (-(u - Real.log 2)*(k:ℝ)) + (-(u - Real.log 2)*(k:ℝ))^2/2
             + (-(u - Real.log 2)*(k:ℝ))^3/6)|
        ≤ (k:ℝ)^2 * (4 * (k:ℝ)^4 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^4) := by
      rw [abs_of_nonneg (by positivity : (0:ℝ) ≤ (k:ℝ)^2)]
      exact mul_le_mul_of_nonneg_left hk (by positivity)
    have hid : (k:ℝ)^2 * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))
          * (1 + (-(u - Real.log 2)*(k:ℝ)) + (-(u - Real.log 2)*(k:ℝ))^2/2
             + (-(u - Real.log 2)*(k:ℝ))^3/6)
        = (k:ℝ)^2 * (Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2*(k:ℝ)))
          * (1 + (-(u - Real.log 2)*(k:ℝ)) + (-(u - Real.log 2)*(k:ℝ))^2/2
             + (-(u - Real.log 2)*(k:ℝ))^3/6)) := by ring
    rw [hid, abs_mul]
    have hconst : (k:ℝ)^2 * (4 * (k:ℝ)^4 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^4)
        = 4 * (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)) * (u - Real.log 2)^4 := by ring
    rw [hconst] at hk2
    exact hk2
  have hA : Summable A := by
    dsimp only [A]
    exact summable_S u (by linarith)
  have hA3 : Summable (fun k : ℕ => (k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hl1 3
  have hA4 : Summable (fun k : ℕ => (k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hl1 4
  have hA5 : Summable (fun k : ℕ => (k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_PhiK5u (Real.log 2) hl1
  have hBfun : B = (fun k : ℕ => (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))
      - ((k:ℝ)^3 * Real.exp (-(Real.log 2*(k:ℝ)))) * (u - Real.log 2)
      + ((k:ℝ)^4 * Real.exp (-(Real.log 2*(k:ℝ)))) * ((u - Real.log 2)^2/2)
      - ((k:ℝ)^5 * Real.exp (-(Real.log 2*(k:ℝ)))) * ((u - Real.log 2)^3/6)) := by
    funext k; dsimp only [B]; ring
  have hBsum : Summable B := by
    rw [hBfun]
    exact ((summable_S (Real.log 2) hLpos).sub (hA3.mul_right (u - Real.log 2))).add
      (hA4.mul_right ((u - Real.log 2)^2/2)) |>.sub (hA5.mul_right ((u - Real.log 2)^3/6))
  have hFsum : Summable (fun k : ℕ => A k - B k) := hA.sub hBsum
  have hMfun : M = (fun k : ℕ => (4 * (u - Real.log 2)^4) * ((k:ℝ)^6 * Real.exp (-((k:ℝ)/8)))) := by
    funext k; dsimp only [M]; ring
  have hMsum : Summable M := by
    rw [hMfun]
    have hx2 : ‖Real.exp (-(1/8:ℝ))‖ < 1 := by
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
      norm_num
    have h1 : Summable (fun k : ℕ => (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by
      have hg := summable_pow_mul_geometric_of_norm_lt_one 6 hx2
      refine hg.congr (fun k => ?_)
      rw [show Real.exp (-((k:ℝ)/8)) = (Real.exp (-(1/8:ℝ)))^k by
        rw [show -((k:ℝ)/8) = (k:ℝ) * (-(1/8:ℝ)) by ring, Real.exp_nat_mul]]
    exact h1.mul_left (4 * (u - Real.log 2)^4)
  have hBeval : (∑' k : ℕ, B k)
      = 6 - 26*(u - Real.log 2) + 75*(u - Real.log 2)^2 - (541/3)*(u - Real.log 2)^3 := by
    have h := tsum_quad_poly_log2 1 (-(u - Real.log 2)) ((u - Real.log 2)^2/2) (-((u - Real.log 2)^3/6))
    rw [show (∑' k : ℕ, B k) = (∑' k : ℕ, (k:ℝ)^2 * Real.exp (-(Real.log 2*(k:ℝ)))
          * (1 + (-(u - Real.log 2))*(k:ℝ) + ((u - Real.log 2)^2/2)*(k:ℝ)^2
             + (-((u - Real.log 2)^3/6))*(k:ℝ)^3)) from tsum_congr (fun k => by dsimp only [B]; ring)]
    rw [h]
    ring
  have habs := abs_tsum_le_tsum_abs' (fun k : ℕ => A k - B k) hFsum
  have main := Summable.tsum_le_tsum hterm hFsum.abs hMsum
  have hMval : (∑' k : ℕ, M k)
      = 4 * (u - Real.log 2)^4 * (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by
    rw [show (∑' k : ℕ, M k)
        = (∑' k : ℕ, (4 * (u - Real.log 2)^4) * ((k:ℝ)^6 * Real.exp (-((k:ℝ)/8)))) from
          tsum_congr (fun k => by dsimp only [M]; ring)]
    rw [tsum_mul_left]
  have hMb : (∑' k : ℕ, M k) ≤ 4*10^15 * (u - Real.log 2)^4 := by
    rw [hMval]
    have hb1 := tsum_pow6_eighth_le
    have hmul := mul_le_mul_of_nonneg_left hb1 (by positivity : (0:ℝ) ≤ 4 * (u - Real.log 2)^4)
    calc 4 * (u - Real.log 2)^4 * (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8)))
        ≤ 4 * (u - Real.log 2)^4 * 10^15 := hmul
      _ = 4*10^15 * (u - Real.log 2)^4 := by ring
  have hAsum : (∑' k : ℕ, A k) = PhiS u := rfl
  have hphi : PhiS u - (6 - 26*(u - Real.log 2) + 75*(u - Real.log 2)^2
        - (541/3)*(u - Real.log 2)^3) = ∑' k : ℕ, (A k - B k) := by
    rw [Summable.tsum_sub hA hBsum, hBeval, hAsum]
  rw [hphi]
  calc |∑' k : ℕ, (A k - B k)| ≤ ∑' k : ℕ, |A k - B k| := habs
    _ ≤ ∑' k : ℕ, M k := main
    _ ≤ 4*10^15 * (u - Real.log 2)^4 := hMb

/-- **Third-order expansion of `u·ΦS(u)` at `log 2`** (the exact termwise model of the
fifth-order asymptotics).  With `δ = u − log 2`,
`uΦS(u) = 6L + (6−26L)δ + (−26+75L)δ² + (75−(541/3)L)δ³ + O(δ⁴)`, constant `10¹⁶`. -/
lemma uPhiS_expansion_fourth (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |u*PhiS u - (6*Real.log 2 + (6 - 26*Real.log 2)*(u - Real.log 2)
        + (-26 + 75*Real.log 2)*(u - Real.log 2)^2
        + (75 - (541/3)*Real.log 2)*(u - Real.log 2)^3)|
      ≤ 10^16 * (u - Real.log 2)^4 := by
  have hR := PhiS_taylor3_at_log2 u hu1 hu2
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hu_abs : |u| ≤ 1 := by
    rw [abs_of_nonneg hu0]; linarith
  have hd4 : (0:ℝ) ≤ (u - Real.log 2)^4 := by positivity
  have hkey : u*PhiS u - (6*Real.log 2 + (6 - 26*Real.log 2)*(u - Real.log 2)
        + (-26 + 75*Real.log 2)*(u - Real.log 2)^2
        + (75 - (541/3)*Real.log 2)*(u - Real.log 2)^3)
      = u*(PhiS u - (6 - 26*(u - Real.log 2) + 75*(u - Real.log 2)^2
            - (541/3)*(u - Real.log 2)^3)) + (-(541/3))*(u - Real.log 2)^4 := by
    ring
  rw [hkey]
  have h1 : |u*(PhiS u - (6 - 26*(u - Real.log 2) + 75*(u - Real.log 2)^2
        - (541/3)*(u - Real.log 2)^3))| ≤ 4*10^15 * (u - Real.log 2)^4 := by
    rw [abs_mul]
    have h := mul_le_mul hu_abs hR (abs_nonneg _) (by norm_num : (0:ℝ) ≤ 1)
    nlinarith [h]
  have h2 : |(-(541/3))*(u - Real.log 2)^4| ≤ 181 * (u - Real.log 2)^4 := by
    rw [abs_mul, abs_of_nonneg hd4]
    rw [show |(-(541/3):ℝ)| = 541/3 by norm_num]
    nlinarith [hd4]
  have hsum := abs_add_le (u*(PhiS u - (6 - 26*(u - Real.log 2) + 75*(u - Real.log 2)^2
        - (541/3)*(u - Real.log 2)^3))) ((-(541/3))*(u - Real.log 2)^4)
  have hfin : 4*10^15 * (u - Real.log 2)^4 + 181 * (u - Real.log 2)^4
      ≤ 10^16 * (u - Real.log 2)^4 := by nlinarith [hd4]
  linarith [hsum, h1, h2, hfin]

/-! ### The second- and third-order coefficients as standalone objects -/

/-- The second-order coefficient `D(u) = −(u/3)·PhiK3u(u) + (u²/8)·PhiK4u(u)` (the inline
expression of `Op56/PhiThird.lean`). -/
noncomputable def D (u : ℝ) : ℝ := -(u/3)*PhiK3u u + (u^2/8)*PhiK4u u

/-- The third-order coefficient `SFourth u n = u·ΦS(u)/(2n) + D(u)/n² + E(u)/n³`; the
model expansion of `Phi (u*n) n` at order `n⁻³`. -/
noncomputable def SFourth (u : ℝ) (n : ℕ) : ℝ :=
  u/(2*(n:ℝ))*PhiS u + D u/((n:ℝ)^2) + EFourth u/((n:ℝ)^3)

/-! ### First-order expansions of the higher moment sums -/

/-- Summability of `k^j e^{−k/8}` (geometric majorant with ratio `e^{−1/8}`). -/
lemma summable_pow_eighth (j : ℕ) :
    Summable (fun k : ℕ => (k:ℝ)^j * Real.exp (-((k:ℝ)/8))) := by
  have hx2 : ‖Real.exp (-(1/8:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have hg := summable_pow_mul_geometric_of_norm_lt_one j hx2
  refine hg.congr (fun k => ?_)
  rw [show Real.exp (-((k:ℝ)/8)) = (Real.exp (-(1/8:ℝ)))^k by
    rw [show -((k:ℝ)/8) = (k:ℝ) * (-(1/8:ℝ)) by ring, Real.exp_nat_mul]]

/-- `k e^{−k/8} ≤ 4` for every `k : ℕ`, from the quadratic lower bound `e^x ≥ 1+x+x²/2`. -/
lemma mul_exp_neg_eighth_le (k : ℕ) : (k:ℝ) * Real.exp (-((k:ℝ)/8)) ≤ 4 := by
  rcases Nat.eq_zero_or_pos k with hk | hk
  · subst hk; norm_num
  · have h := Real.sum_le_exp_of_nonneg (x := (k:ℝ)/8) (by positivity) 4
    have hsum : (∑ i ∈ Finset.range 4, ((k:ℝ)/8)^i / (i.factorial : ℝ))
        = 1 + (k:ℝ)/8 + ((k:ℝ)/8)^2/2 + ((k:ℝ)/8)^3/6 := by
      norm_num [Finset.sum_range_succ]
    rw [hsum] at h
    have h4 : (k:ℝ) ≤ 4 * Real.exp ((k:ℝ)/8) := by
      have hq : (0:ℝ) ≤ (k:ℝ)^2/32 - (k:ℝ)/2 + 4 := by
        nlinarith [sq_nonneg ((k:ℝ) - 8)]
      nlinarith [h]
    have h4b : Real.exp ((k:ℝ)/8) * Real.exp (-((k:ℝ)/8)) = 1 := by
      rw [← Real.exp_add, add_neg_cancel, Real.exp_zero]
    have hm := mul_le_mul_of_nonneg_right h4 (le_of_lt (Real.exp_pos (-((k:ℝ)/8))))
    calc (k:ℝ) * Real.exp (-((k:ℝ)/8)) ≤ (4 * Real.exp ((k:ℝ)/8)) * Real.exp (-((k:ℝ)/8)) := hm
      _ = 4 := by rw [mul_assoc, h4b, mul_one]

/-- `k² e^{−k/8} ≤ 3072` for every `k : ℕ`, from the cubic lower bound `e^x ≥ x³/6`. -/
lemma sq_mul_exp_neg_eighth_le (k : ℕ) : (k:ℝ)^2 * Real.exp (-((k:ℝ)/8)) ≤ 3072 := by
  rcases Nat.eq_zero_or_pos k with hk | hk
  · subst hk; norm_num
  · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
    have hx : (0:ℝ) < (k:ℝ) := by linarith
    have h := Real.sum_le_exp_of_nonneg (x := (k:ℝ)/8) (by positivity) 4
    have hsum : (∑ i ∈ Finset.range 4, ((k:ℝ)/8)^i / (i.factorial : ℝ))
        = 1 + (k:ℝ)/8 + ((k:ℝ)/8)^2/2 + ((k:ℝ)/8)^3/6 := by
      norm_num [Finset.sum_range_succ]
    rw [hsum] at h
    have h3 : (k:ℝ)^3/3072 ≤ Real.exp ((k:ℝ)/8) := by nlinarith [h]
    have h4b : Real.exp ((k:ℝ)/8) * Real.exp (-((k:ℝ)/8)) = 1 := by
      rw [← Real.exp_add, add_neg_cancel, Real.exp_zero]
    have hm := mul_le_mul_of_nonneg_right h3 (le_of_lt (Real.exp_pos (-((k:ℝ)/8))))
    have h2 : (k:ℝ)^3 * Real.exp (-((k:ℝ)/8)) ≤ 3072 := by nlinarith [hm]
    nlinarith [h2, hk1, hx]


lemma tsum_pow_exp_neg_quarter_le (m : ℕ) (hm : 3 ≤ m) (hm8 : m ≤ 8) :
    (∑' k : ℕ, (k:ℝ)^m * Real.exp (-((k:ℝ)/4))) ≤ 3072*10^15 := by
  have hle : ∀ k : ℕ, (k:ℝ)^m * Real.exp (-((k:ℝ)/4))
      ≤ 3072 * ((k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by
    intro k
    rcases Nat.eq_zero_or_pos k with hk | hk
    · subst hk
      have hm0 : (0:ℝ)^m = 0 := zero_pow (by omega)
      simp [hm0]
    · have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
      have hkm : (k:ℝ)^m ≤ (k:ℝ)^8 := pow_le_pow_right₀ hk1 hm8
      have hexp : Real.exp (-((k:ℝ)/4))
          = Real.exp (-((k:ℝ)/8)) * Real.exp (-((k:ℝ)/8)) := by
        rw [← Real.exp_add]; ring_nf
      calc (k:ℝ)^m * Real.exp (-((k:ℝ)/4))
          ≤ (k:ℝ)^8 * Real.exp (-((k:ℝ)/4)) :=
            mul_le_mul_of_nonneg_right hkm (by positivity)
        _ = ((k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) * ((k:ℝ)^2 * Real.exp (-((k:ℝ)/8))) := by
            rw [hexp]; ring
        _ ≤ ((k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) * 3072 :=
            mul_le_mul_of_nonneg_left (sq_mul_exp_neg_eighth_le k) (by positivity)
        _ = 3072 * ((k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) := by ring
  have hsum := Summable.tsum_le_tsum hle
    (Summable.of_nonneg_of_le (fun k => by positivity) hle ((summable_pow_eighth 6).mul_left 3072))
    ((summable_pow_eighth 6).mul_left 3072)
  rw [tsum_mul_left] at hsum
  have h6 := tsum_pow6_eighth_le
  linarith [hsum, h6]

/-- Quarter-range variant of `phiS_term_taylor`: for `|u−b| ≤ 1/4` the majorant improves
to `e^{−k/4}`. -/
lemma phiS_term_taylor_quarter (u b : ℝ) (hb : 5/8 ≤ b) (hub : |u - b| ≤ 1/4) (k : ℕ) :
    |Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
        + (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b)|
      ≤ 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/4)) * (u - b)^2 := by
  set x : ℝ := -(u - b) * (k:ℝ) with hx
  have hk0 : (0:ℝ) ≤ (k:ℝ) := by positivity
  have h1 : Real.exp (-(u*(k:ℝ))) = Real.exp (-(b*(k:ℝ))) * Real.exp x := by
    rw [hx, show -(u*(k:ℝ)) = -(b*(k:ℝ)) + (-(u - b) * (k:ℝ)) by ring, Real.exp_add]
  have h2 : (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b) = -Real.exp (-(b*(k:ℝ))) * x := by
    rw [hx]; ring
  have hkey : Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
        + (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b)
      = Real.exp (-(b*(k:ℝ))) * (Real.exp x - 1 - x) := by
    rw [h1, h2]; ring
  have hE0' : (0:ℝ) ≤ Real.exp (-(b*(k:ℝ))) := le_of_lt (Real.exp_pos _)
  rw [hkey, abs_mul, abs_of_nonneg hE0']
  have h3 : |Real.exp x - 1 - x| ≤ 3 * x^2 * Real.exp |x| := exp_sub_one_sub_id_bound x
  have h4 : x^2 = ((k:ℝ)^2) * (u - b)^2 := by rw [hx]; ring
  have h5 : Real.exp (-(b*(k:ℝ))) * Real.exp |x| ≤ Real.exp (-((k:ℝ)/4)) := by
    have h51 : Real.exp |x| ≤ Real.exp ((k:ℝ)/4) := by
      apply Real.exp_le_exp.mpr
      rw [hx, abs_mul, abs_of_nonneg hk0, abs_neg]
      have hform : ((1/4:ℝ) * (k:ℝ)) = (k:ℝ)/4 := by ring
      rw [← hform]
      exact mul_le_mul_of_nonneg_right hub hk0
    have h52 : Real.exp (-(b*(k:ℝ))) * Real.exp ((k:ℝ)/4) ≤ Real.exp (-((k:ℝ)/4)) := by
      rw [show Real.exp (-(b*(k:ℝ))) * Real.exp ((k:ℝ)/4)
          = Real.exp (-(b*(k:ℝ)) + (k:ℝ)/4) by rw [Real.exp_add]]
      apply Real.exp_le_exp.mpr
      nlinarith [hb, hk0]
    have hE0 : (0:ℝ) ≤ Real.exp (-(b*(k:ℝ))) := le_of_lt (Real.exp_pos _)
    exact (mul_le_mul_of_nonneg_left h51 hE0).trans h52
  have hstep1 : Real.exp (-(b*(k:ℝ))) * |Real.exp x - 1 - x|
      ≤ Real.exp (-(b*(k:ℝ))) * (3 * x^2 * Real.exp |x|) :=
    mul_le_mul_of_nonneg_left h3 hE0'
  have hstep2 : Real.exp (-(b*(k:ℝ))) * (3 * x^2 * Real.exp |x|)
      ≤ 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/4)) * (u - b)^2 := by
    have h6 : Real.exp (-(b*(k:ℝ))) * (3 * x^2 * Real.exp |x|)
        = 3 * ((k:ℝ)^2) * (u - b)^2 * (Real.exp (-(b*(k:ℝ))) * Real.exp |x|) := by
      rw [h4]; ring
    have h7 : 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/4)) * (u - b)^2
        = 3 * ((k:ℝ)^2) * (u - b)^2 * Real.exp (-((k:ℝ)/4)) := by ring
    rw [h6, h7]
    exact mul_le_mul_of_nonneg_left h5 (by positivity)
  linarith [hstep1, hstep2]

/-- Summability of `k^j e^{−k/4}` (geometric ratio `e^{−1/4}`). -/
lemma summable_pow_exp_neg_quarter (j : ℕ) :
    Summable (fun k : ℕ => (k:ℝ)^j * Real.exp (-((k:ℝ)/4))) := by
  have hx2 : ‖Real.exp (-(1/4:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have hg := summable_pow_mul_geometric_of_norm_lt_one j hx2
  refine hg.congr (fun k => ?_)
  rw [show Real.exp (-((k:ℝ)/4)) = (Real.exp (-(1/4:ℝ)))^k by
    rw [show -((k:ℝ)/4) = (k:ℝ) * (-(1/4:ℝ)) by ring, Real.exp_nat_mul]]

/-- **First-order expansion of an arbitrary moment sum.**  For `m ≤ 6` and uniformly on
`[1/2,1]`, `Σ k^m e^{−uk} = Σ k^m e^{−Lk} − (u−L)·Σ k^{m+1} e^{−Lk} + O((u−L)²)`, with the
explicit constant `3·C`. -/
lemma tsum_pow_exp_first_order (m : ℕ) (u : ℝ) (hu1 : 1/2 ≤ u)
    (hub : |u - Real.log 2| ≤ 1/4) (C : ℝ)
    (hC : (∑' k : ℕ, (k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4))) ≤ C) :
    |(∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
      - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))
      + (u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))))|
      ≤ 3 * C * (u - Real.log 2)^2 := by
  have hl1 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have hb : (5/8:ℝ) ≤ Real.log 2 := by have := Real.log_two_gt_d9; linarith
  let F : ℕ → ℝ := fun k => (k:ℝ)^m * Real.exp (-(u*(k:ℝ)))
      - (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ)))
      + (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))) * (u - Real.log 2)
  let M : ℕ → ℝ := fun k => 3 * ((k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4))) * (u - Real.log 2)^2
  have hterm : ∀ k : ℕ, |F k| ≤ M k := by
    intro k
    dsimp only [F, M]
    have hk := phiS_term_taylor_quarter u (Real.log 2) hb hub k
    have hk2 : |(k:ℝ)^m| * |Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2*(k:ℝ)))
          + (k:ℝ) * Real.exp (-(Real.log 2*(k:ℝ))) * (u - Real.log 2)|
        ≤ (k:ℝ)^m * (3 * (k:ℝ)^2 * Real.exp (-((k:ℝ)/4)) * (u - Real.log 2)^2) := by
      rw [abs_of_nonneg (by positivity : (0:ℝ) ≤ (k:ℝ)^m)]
      exact mul_le_mul_of_nonneg_left hk (by positivity)
    have hid : (k:ℝ)^m * Real.exp (-(u*(k:ℝ))) - (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ)))
          + (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))) * (u - Real.log 2)
        = (k:ℝ)^m * (Real.exp (-(u*(k:ℝ))) - Real.exp (-(Real.log 2*(k:ℝ)))
          + (k:ℝ) * Real.exp (-(Real.log 2*(k:ℝ))) * (u - Real.log 2)) := by ring
    rw [hid, abs_mul]
    have hconst : (k:ℝ)^m * (3 * (k:ℝ)^2 * Real.exp (-((k:ℝ)/4)) * (u - Real.log 2)^2)
        = 3 * ((k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4))) * (u - Real.log 2)^2 := by ring
    rw [hconst] at hk2
    exact hk2
  have hA : Summable (fun k : ℕ => (k:ℝ)^m * Real.exp (-(u*(k:ℝ)))) :=
    summable_exp_neg_u u hu1 m
  have hB : Summable (fun k : ℕ => (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hl1 m
  have hC1 : Summable (fun k : ℕ => (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))) :=
    summable_exp_neg_u (Real.log 2) hl1 (m+1)
  have hFfun : F = (fun k : ℕ => ((k:ℝ)^m * Real.exp (-(u*(k:ℝ)))
        - (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))
        + (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))) * (u - Real.log 2)) := by
    funext k; dsimp only [F]
  have hFsum : Summable F := by
    rw [hFfun]
    exact (hA.sub hB).add (hC1.mul_right (u - Real.log 2))
  have hMfun : M = (fun k : ℕ => (3 * (u - Real.log 2)^2) * ((k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4)))) := by
    funext k; dsimp only [M]; ring
  have hMsum : Summable M := by
    rw [hMfun]
    exact (summable_pow_exp_neg_quarter (m+2)).mul_left (3 * (u - Real.log 2)^2)
  have hFeq : (∑' k : ℕ, F k) = (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
      - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))
      + (u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))) := by
    rw [hFfun, Summable.tsum_add (hA.sub hB) (hC1.mul_right (u - Real.log 2)),
      Summable.tsum_sub hA hB, tsum_mul_right]
    ring
  have habs := abs_tsum_le_tsum_abs' F hFsum
  have hmain := Summable.tsum_le_tsum hterm hFsum.abs hMsum
  rw [← hFeq]
  have hMval : (∑' k : ℕ, M k)
      = 3 * (u - Real.log 2)^2 * (∑' k : ℕ, (k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4))) := by
    rw [show (∑' k : ℕ, M k)
        = (∑' k : ℕ, (3 * (u - Real.log 2)^2) * ((k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4)))) from
          tsum_congr (fun k => by dsimp only [M]; ring)]
    rw [tsum_mul_left]
  calc |∑' k : ℕ, F k| ≤ ∑' k : ℕ, |F k| := habs
    _ ≤ ∑' k : ℕ, M k := hmain
    _ = 3 * (u - Real.log 2)^2 * (∑' k : ℕ, (k:ℝ)^(m+2) * Real.exp (-((k:ℝ)/4))) := hMval
    _ ≤ 3 * (u - Real.log 2)^2 * C := by
        apply mul_le_mul_of_nonneg_left hC (by positivity)
    _ = 3 * C * (u - Real.log 2)^2 := by ring

/-- **Lipschitz (linear-difference) bound for the moment sums** `Σ k^m e^{−uk}`, `3 ≤ m ≤ 6`,
near `log 2`: the difference is `O(|u−log 2|)` with constant `10¹⁹`. -/
lemma PhiK_diff_linear_le (m : ℕ) (hm3 : 3 ≤ m) (hm6 : m ≤ 6) (u : ℝ) (hu1 : 1/2 ≤ u)
    (hub : |u - Real.log 2| ≤ 1/4) :
    |(∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
      - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))|
      ≤ 10^19 * |u - Real.log 2| := by
  have hl1 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have h := tsum_pow_exp_first_order m u hu1 hub (3072*10^15)
    (tsum_pow_exp_neg_quarter_le (m+2) (by omega) (by omega))
  have hCbound : (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))) ≤ 3072*10^15 := by
    have hle : ∀ k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))
        ≤ (k:ℝ)^(m+1) * Real.exp (-((k:ℝ)/4)) := by
      intro k
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      apply Real.exp_le_exp.mpr
      have h14 : (1/4:ℝ) ≤ Real.log 2 := by have := Real.log_two_gt_d9; linarith
      have hk0 : (0:ℝ) ≤ (k:ℝ) := by positivity
      nlinarith [h14, hk0]
    exact le_trans (Summable.tsum_le_tsum hle (summable_exp_neg_u (Real.log 2) hl1 (m+1))
      (summable_pow_exp_neg_quarter (m+1))) (tsum_pow_exp_neg_quarter_le (m+1) (by omega) (by omega))
  obtain ⟨C, hCdef⟩ : ∃ C : ℝ, C = 3072*10^15 := ⟨_, rfl⟩
  have h1 : |(∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
      - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))|
      ≤ 3*(3072*10^15)*(u - Real.log 2)^2 + (3072*10^15)*|u - Real.log 2| := by
    have hsplit : (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
        - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))
        = ((∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
          - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))
          + (u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))))
          + (-((u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))))) := by ring
    rw [hsplit]
    have hA := abs_add_le ((∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
          - (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(Real.log 2*(k:ℝ))))
          + (u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))))
      (-((u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))))))
    rw [abs_neg] at hA
    have hB : |(u - Real.log 2) * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))))|
        ≤ (3072*10^15) * |u - Real.log 2| := by
      rw [abs_mul]
      have hSnn : (0:ℝ) ≤ ∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))) :=
        tsum_nonneg (fun k => by positivity)
      rw [abs_of_nonneg hSnn]
      calc |u - Real.log 2| * (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ))))
          = (∑' k : ℕ, (k:ℝ)^(m+1) * Real.exp (-(Real.log 2*(k:ℝ)))) * |u - Real.log 2| := by ring
        _ ≤ (3072*10^15) * |u - Real.log 2| :=
            mul_le_mul_of_nonneg_right hCbound (abs_nonneg _)
    linarith [hA, h, hB]
  have hd : |u - Real.log 2| ≤ 1/4 := hub
  have hd2 : (u - Real.log 2)^2 ≤ (1/4) * |u - Real.log 2| := by
    rw [← sq_abs]
    nlinarith [abs_nonneg (u - Real.log 2)]
  nlinarith [h1, hd, hd2]

/-- **First-order expansion of `D` at `log 2`.**  With `δ = u − log 2`,
`D(u) = D(L) + D'(L)·δ + O(δ²)`, `D'(L) = −26/3 + (175/2)L − (541/4)L²`, constant `10²¹`. -/
lemma D_first_order (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hub : |u - Real.log 2| ≤ 1/4) :
    |D u - D (Real.log 2)
      - (-26/3 + (175/2)*Real.log 2 - (541/4)*Real.log 2^2)*(u - Real.log 2)|
      ≤ 10^21 * (u - Real.log 2)^2 := by
  have hL1 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have h3 := tsum_pow_exp_first_order 3 u hu1 hub (3072*10^15)
    (tsum_pow_exp_neg_quarter_le 5 (by norm_num) (by norm_num))
  have h4 := tsum_pow_exp_first_order 4 u hu1 hub (3072*10^15)
    (tsum_pow_exp_neg_quarter_le 6 (by norm_num) (by norm_num))
  have h3b : |PhiK3u u - PhiK3u (Real.log 2) + (u - Real.log 2)*PhiK4u (Real.log 2)|
      ≤ 10^19 * (u - Real.log 2)^2 := by
    refine h3.trans ?_
    have hd := sq_nonneg (u - Real.log 2)
    nlinarith [hd]
  have h4b : |PhiK4u u - PhiK4u (Real.log 2) + (u - Real.log 2)*PhiK5u (Real.log 2)|
      ≤ 10^19 * (u - Real.log 2)^2 := by
    refine h4.trans ?_
    have hd := sq_nonneg (u - Real.log 2)
    nlinarith [hd]
  obtain ⟨e3, he3⟩ : ∃ e3 : ℝ, e3 = PhiK3u u - PhiK3u (Real.log 2) + (u - Real.log 2)*PhiK4u (Real.log 2) := ⟨_, rfl⟩
  obtain ⟨e4, he4⟩ : ∃ e4 : ℝ, e4 = PhiK4u u - PhiK4u (Real.log 2) + (u - Real.log 2)*PhiK5u (Real.log 2) := ⟨_, rfl⟩
  have hΦ3 : PhiK3u u = PhiK3u (Real.log 2) - (u - Real.log 2)*PhiK4u (Real.log 2) + e3 := by
    rw [he3]; ring
  have hΦ4 : PhiK4u u = PhiK4u (Real.log 2) - (u - Real.log 2)*PhiK5u (Real.log 2) + e4 := by
    rw [he4]; ring
  have h31 : PhiK3u (Real.log 2) = 26 := PhiK3u_log_two
  have h41 : PhiK4u (Real.log 2) = 150 := PhiK4u_log_two
  have h51 : PhiK5u (Real.log 2) = 1082 := PhiK5u_log_two
  have hkey : D u - D (Real.log 2)
      - (-26/3 + (175/2)*Real.log 2 - (541/4)*Real.log 2^2)*(u - Real.log 2)
      = ((11/24)*PhiK4u (Real.log 2) - (Real.log 2/4)*PhiK5u (Real.log 2))*(u - Real.log 2)^2
        - (1/8)*PhiK5u (Real.log 2)*(u - Real.log 2)^3
        - (u/3)*e3 + (u^2/8)*e4 := by
    unfold D
    rw [hΦ3, hΦ4, h31, h41, h51]
    ring
  have he3b : |e3| ≤ 10^19 * (u - Real.log 2)^2 := by rw [he3]; exact h3b
  have he4b : |e4| ≤ 10^19 * (u - Real.log 2)^2 := by rw [he4]; exact h4b
  have hL2 : Real.log 2 ≤ 1 := log_two_le_one
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hu1' : u ≤ 1 := hu2
  have hd : |u - Real.log 2| ≤ 1/4 := hub
  have hd2 : (0:ℝ) ≤ (u - Real.log 2)^2 := sq_nonneg _
  rw [hkey]
  have hA : |((11/24)*PhiK4u (Real.log 2) - (Real.log 2/4)*PhiK5u (Real.log 2))*(u - Real.log 2)^2|
      ≤ 300 * (u - Real.log 2)^2 := by
    rw [abs_mul, abs_of_nonneg hd2, h41, h51]
    have hb : |(11/24)*150 - (Real.log 2/4)*1082| ≤ 300 := by
      rw [abs_le]
      constructor <;> nlinarith [hL1, hL2]
    exact mul_le_mul_of_nonneg_right hb hd2
  have hB : |(-(1/8))*PhiK5u (Real.log 2)*(u - Real.log 2)^3| ≤ 40 * (u - Real.log 2)^2 := by
    rw [h51]
    have hcube : |(u - Real.log 2)^3| ≤ (1/4) * (u - Real.log 2)^2 := by
      rw [abs_pow]
      have h2 : (0:ℝ) ≤ |u - Real.log 2|^2 := by positivity
      calc |u - Real.log 2|^3 = |u - Real.log 2|^2 * |u - Real.log 2| := by ring
        _ ≤ |u - Real.log 2|^2 * (1/4) := mul_le_mul_of_nonneg_left hd h2
        _ = (1/4) * (u - Real.log 2)^2 := by rw [sq_abs]; ring
    have heq : (-(1/8:ℝ))*1082*(u - Real.log 2)^3 = (-(1082/8:ℝ))*(u - Real.log 2)^3 := by ring
    rw [heq, abs_mul, show |(-(1082/8):ℝ)| = 1082/8 by norm_num]
    nlinarith [hcube, hd2]
  have hC3 : |(-(u/3))*e3| ≤ 10^19 * (u - Real.log 2)^2 := by
    rw [abs_mul, abs_neg]
    have hu3 : |u/3| ≤ 1/3 := by
      rw [abs_of_nonneg (by positivity)]; linarith
    calc |u/3| * |e3| ≤ (1/3) * (10^19 * (u - Real.log 2)^2) :=
          mul_le_mul hu3 he3b (abs_nonneg _) (by norm_num)
      _ ≤ 10^19 * (u - Real.log 2)^2 := by nlinarith [hd2]
  have hC4 : |(u^2/8)*e4| ≤ 10^19 * (u - Real.log 2)^2 := by
    rw [abs_mul]
    have hu8 : |u^2/8| ≤ 1/8 := by
      rw [abs_of_nonneg (by positivity)]
      nlinarith [hu0, hu1']
    calc |u^2/8| * |e4| ≤ (1/8) * (10^19 * (u - Real.log 2)^2) :=
          mul_le_mul hu8 he4b (abs_nonneg _) (by norm_num)
      _ ≤ 10^19 * (u - Real.log 2)^2 := by nlinarith [hd2]
  have htri := abs_add_le (((11/24)*PhiK4u (Real.log 2) - (Real.log 2/4)*PhiK5u (Real.log 2))*(u - Real.log 2)^2
      + (-(1/8)*PhiK5u (Real.log 2)*(u - Real.log 2)^3))
    (-(u/3)*e3 + (u^2/8)*e4)
  have htri2 := abs_add_le (((11/24)*PhiK4u (Real.log 2) - (Real.log 2/4)*PhiK5u (Real.log 2))*(u - Real.log 2)^2)
    ((-(1/8)*PhiK5u (Real.log 2)*(u - Real.log 2)^3))
  have htri3 := abs_add_le (-(u/3)*e3) ((u^2/8)*e4)
  have hid : ((11/24)*PhiK4u (Real.log 2) - (Real.log 2/4)*PhiK5u (Real.log 2))*(u - Real.log 2)^2
        - (1/8)*PhiK5u (Real.log 2)*(u - Real.log 2)^3
        - (u/3)*e3 + (u^2/8)*e4
      = (((11/24)*PhiK4u (Real.log 2) - (Real.log 2/4)*PhiK5u (Real.log 2))*(u - Real.log 2)^2
        + (-(1/8)*PhiK5u (Real.log 2)*(u - Real.log 2)^3))
        + (-(u/3)*e3 + (u^2/8)*e4) := by ring
  rw [hid]
  nlinarith [htri, htri2, htri3, hA, hB, hC3, hC4, hd2]

/-- **Lipschitz bound for `EFourth` at `log 2`**: `|E(u) − E(L)| ≤ 10²¹·|u − L|` on
`[1/2,1]` near `L`.  Follows from the linear-difference bounds of `PhiK4u,PhiK5u,PhiK6u`
and the uniform bounds `PhiKmu ≤ 4·10¹⁰+5`. -/
lemma EFourth_diff_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hub : |u - Real.log 2| ≤ 1/4) :
    |EFourth u - EFourth (Real.log 2)| ≤ 10^21 * |u - Real.log 2| := by
  have h4 := PhiK_diff_linear_le 4 (by norm_num) (by norm_num) u hu1 hub
  have h5 := PhiK_diff_linear_le 5 (by norm_num) (by norm_num) u hu1 hub
  have h6 := PhiK_diff_linear_le 6 (by norm_num) (by norm_num) u hu1 hub
  have b4 := PhiK4u_le u hu1
  have b5 := PhiK5u_le u hu1
  have b6 := PhiK6u_le u hu1
  have b4' : |PhiK4u u| ≤ 4*10^10 + 5 := by
    rw [abs_of_nonneg (PhiK4u_nonneg u)]; linarith
  have b5' : |PhiK5u u| ≤ 4*10^10 + 5 := by
    rw [abs_of_nonneg (by rw [PhiK5u]; exact tsum_nonneg (fun k => by positivity))]; linarith
  have b6' : |PhiK6u u| ≤ 4*10^10 + 5 := by
    rw [abs_of_nonneg (by rw [PhiK6u]; exact tsum_nonneg (fun k => by positivity))]; linarith
  have hL1 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have hL2 : Real.log 2 ≤ 1 := log_two_le_one
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hd : |u - Real.log 2| ≤ 1/4 := hub
  have hdnn : (0:ℝ) ≤ |u - Real.log 2| := abs_nonneg _
  have hkey : EFourth u - EFourth (Real.log 2)
      = ((u - Real.log 2)/4)*PhiK4u u + (Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2))
        + (-(((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u
            + ((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2))))
        + (((u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48)*PhiK6u u
            + ((Real.log 2)^3/48)*(PhiK6u u - PhiK6u (Real.log 2))) := by
    unfold EFourth
    ring
  have hT1 : |((u - Real.log 2)/4)*PhiK4u u + (Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2))|
      ≤ (1/4)*(4*10^10+5)*|u - Real.log 2| + (1/4)*(10^19 * |u - Real.log 2|) := by
    have h1 : |((u - Real.log 2)/4)*PhiK4u u| ≤ (1/4)*(4*10^10+5)*|u - Real.log 2| := by
      rw [abs_mul]
      have hf : |(u - Real.log 2)/4| ≤ (1/4)*|u - Real.log 2| := by
        rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 4)]
        rw [div_eq_mul_inv]
        exact le_of_eq (by ring)
      calc |(u - Real.log 2)/4| * |PhiK4u u| ≤ ((1/4)*|u - Real.log 2|) * (4*10^10+5) :=
            mul_le_mul hf b4' (abs_nonneg _) (by positivity)
        _ = (1/4)*(4*10^10+5)*|u - Real.log 2| := by ring
    have h2 : |(Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2))|
        ≤ (1/4)*(10^19 * |u - Real.log 2|) := by
      rw [abs_mul]
      have hf : |Real.log 2/4| ≤ 1/4 := by
        rw [abs_of_nonneg (by positivity)]; linarith
      calc |Real.log 2/4| * |PhiK4u u - PhiK4u (Real.log 2)|
          ≤ (1/4) * (10^19 * |u - Real.log 2|) :=
            mul_le_mul hf h4 (abs_nonneg _) (by positivity)
        _ = (1/4)*(10^19 * |u - Real.log 2|) := by ring
    exact (abs_add_le _ _).trans (add_le_add h1 h2)
  have hT2 : |(-(((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u
            + ((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2))))|
      ≤ (2/6)*(4*10^10+5)*|u - Real.log 2| + (1/6)*(10^19 * |u - Real.log 2|) := by
    rw [abs_neg]
    have h1 : |((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u|
        ≤ (2/6)*(4*10^10+5)*|u - Real.log 2| := by
      rw [abs_mul]
      have hf : |(u - Real.log 2)*(u + Real.log 2)/6| ≤ (2/6)*|u - Real.log 2| := by
        rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 6), abs_mul]
        have hsum : |u + Real.log 2| ≤ 2 := by
          rw [abs_le]; constructor <;> linarith
        rw [div_le_iff₀ (by norm_num : (0:ℝ) < 6)]
        nlinarith [abs_nonneg (u - Real.log 2), hsum]
      calc |(u - Real.log 2)*(u + Real.log 2)/6| * |PhiK5u u|
          ≤ ((2/6)*|u - Real.log 2|) * (4*10^10+5) :=
            mul_le_mul hf b5' (abs_nonneg _) (by positivity)
        _ = (2/6)*(4*10^10+5)*|u - Real.log 2| := by ring
    have h2 : |((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2))|
        ≤ (1/6)*(10^19 * |u - Real.log 2|) := by
      rw [abs_mul]
      have hf : |(Real.log 2)^2/6| ≤ 1/6 := by
        rw [abs_of_nonneg (by positivity)]; nlinarith [hL1, hL2]
      calc |(Real.log 2)^2/6| * |PhiK5u u - PhiK5u (Real.log 2)|
          ≤ (1/6) * (10^19 * |u - Real.log 2|) :=
            mul_le_mul hf h5 (abs_nonneg _) (by positivity)
        _ = (1/6)*(10^19 * |u - Real.log 2|) := by ring
    exact (abs_add_le _ _).trans (add_le_add h1 h2)
  have hT3 : |((u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48)*PhiK6u u
            + ((Real.log 2)^3/48)*(PhiK6u u - PhiK6u (Real.log 2))|
      ≤ (3/48)*(4*10^10+5)*|u - Real.log 2| + (1/48)*(10^19 * |u - Real.log 2|) := by
    have h1 : |((u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48)*PhiK6u u|
        ≤ (3/48)*(4*10^10+5)*|u - Real.log 2| := by
      rw [abs_mul]
      have hf : |(u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48|
          ≤ (3/48)*|u - Real.log 2| := by
        rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 48), abs_mul]
        have hq : |u^2 + u*Real.log 2 + (Real.log 2)^2| ≤ 3 := by
          rw [abs_le]; constructor <;> nlinarith [hu0, hu2, hL1, hL2]
        rw [div_le_iff₀ (by norm_num : (0:ℝ) < 48)]
        nlinarith [abs_nonneg (u - Real.log 2), hq]
      calc |(u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48| * |PhiK6u u|
          ≤ ((3/48)*|u - Real.log 2|) * (4*10^10+5) :=
            mul_le_mul hf b6' (abs_nonneg _) (by positivity)
        _ = (3/48)*(4*10^10+5)*|u - Real.log 2| := by ring
    have h2 : |((Real.log 2)^3/48)*(PhiK6u u - PhiK6u (Real.log 2))|
        ≤ (1/48)*(10^19 * |u - Real.log 2|) := by
      rw [abs_mul]
      have hf : |(Real.log 2)^3/48| ≤ 1/48 := by
        rw [abs_of_nonneg (by positivity)]; nlinarith [hL1, hL2]
      calc |(Real.log 2)^3/48| * |PhiK6u u - PhiK6u (Real.log 2)|
          ≤ (1/48) * (10^19 * |u - Real.log 2|) :=
            mul_le_mul hf h6 (abs_nonneg _) (by positivity)
        _ = (1/48)*(10^19 * |u - Real.log 2|) := by ring
    exact (abs_add_le _ _).trans (add_le_add h1 h2)
  rw [hkey]
  have htri := abs_add_le (((u - Real.log 2)/4)*PhiK4u u + (Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2))
      + (-(((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u
          + ((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2)))))
    (((u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48)*PhiK6u u
      + ((Real.log 2)^3/48)*(PhiK6u u - PhiK6u (Real.log 2)))
  have htri2 := abs_add_le (((u - Real.log 2)/4)*PhiK4u u + (Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2)))
    (-(((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u
        + ((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2))))
  have hid : ((u - Real.log 2)/4)*PhiK4u u + (Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2))
        + (-(((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u
            + ((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2))))
        + (((u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48)*PhiK6u u
            + ((Real.log 2)^3/48)*(PhiK6u u - PhiK6u (Real.log 2)))
      = ((((u - Real.log 2)/4)*PhiK4u u + (Real.log 2/4)*(PhiK4u u - PhiK4u (Real.log 2)))
        + (-(((u - Real.log 2)*(u + Real.log 2)/6)*PhiK5u u
            + ((Real.log 2)^2/6)*(PhiK5u u - PhiK5u (Real.log 2)))))
        + (((u - Real.log 2)*(u^2 + u*Real.log 2 + (Real.log 2)^2)/48)*PhiK6u u
            + ((Real.log 2)^3/48)*(PhiK6u u - PhiK6u (Real.log 2))) := by ring
  rw [hid]
  have hsum : (1/4)*(4*10^10+5)*|u - Real.log 2| + (1/4)*(10^19 * |u - Real.log 2|)
      + ((2/6)*(4*10^10+5)*|u - Real.log 2| + (1/6)*(10^19 * |u - Real.log 2|))
      + ((3/48)*(4*10^10+5)*|u - Real.log 2| + (1/48)*(10^19 * |u - Real.log 2|))
      ≤ 10^21 * |u - Real.log 2| := by
    nlinarith [hdnn]
  linarith [htri, htri2, hT1, hT2, hT3, hsum]

/-! ### Generic model lemmas for the fourth-order threshold inversion -/

set_option maxHeartbeats 8000000





/-- `tg Y = Y/2 + 3Y²/8 + 7Y³/24`. -/
noncomputable def tg (Y : ℝ) : ℝ := Y/2 + 3*Y^2/8 + 7*Y^3/24

/-- `thh t = t/2 - t²/8 + t³/24`. -/
noncomputable def thh (t : ℝ) : ℝ := t/2 - t^2/8 + t^3/24

lemma tg_lipschitz (Y Z : ℝ) (hY : |Y| ≤ 1/2) (hZ : |Z| ≤ 1/2) :
    |tg Y - tg Z| ≤ 2*|Y - Z| := by
  have h : tg Y - tg Z = (Y - Z) * (1/2 + 3*(Y+Z)/8 + 7*(Y^2+Y*Z+Z^2)/24) := by
    simp only [tg]; ring
  rw [h, abs_mul]
  have h1 : |Y + Z| ≤ 1 := by
    have := abs_add_le Y Z; linarith [this, hY, hZ]
  have h2 : |Y^2 + Y*Z + Z^2| ≤ 3/4 := by
    have hy2 : |Y|^2 ≤ (1/2)^2 := pow_le_pow_left₀ (abs_nonneg Y) hY 2
    have hz2 : |Z|^2 ≤ (1/2)^2 := pow_le_pow_left₀ (abs_nonneg Z) hZ 2
    have hyz : |Y*Z| ≤ (1/2)*(1/2) := by
      rw [abs_mul]
      exact mul_le_mul hY hZ (abs_nonneg Z) (by norm_num)
    have hsum : |Y^2| + |Y*Z| + |Z^2| ≤ 3/4 := by
      rw [abs_pow, abs_pow]; nlinarith [hy2, hz2, hyz]
    calc |Y^2 + Y*Z + Z^2| ≤ |Y^2| + |Y*Z| + |Z^2| := by
          have h12 := abs_add_le (Y^2 + Y*Z) (Z^2)
          have h13 := abs_add_le (Y^2) (Y*Z)
          linarith
      _ ≤ 3/4 := hsum
  have e2 : |3*(Y+Z)/8| = 3*|Y+Z|/8 := by
    rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3),
      abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8)]
  have e3 : |7*(Y^2+Y*Z+Z^2)/24| = 7*|Y^2+Y*Z+Z^2|/24 := by
    rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 7),
      abs_of_nonneg (by norm_num : (0:ℝ) ≤ 24)]
  have hb : |1/2 + 3*(Y+Z)/8 + 7*(Y^2+Y*Z+Z^2)/24| ≤ 2 := by
    have h13 := abs_add_le (1/2 + 3*(Y+Z)/8) (7*(Y^2+Y*Z+Z^2)/24)
    have h12 := abs_add_le (1/2) (3*(Y+Z)/8)
    have e1 : |(1:ℝ)/2| = 1/2 := by norm_num
    rw [e1, e2] at h12
    rw [e3] at h13
    linarith [h12, h13, h1, h2]
  have := mul_le_mul_of_nonneg_right hb (abs_nonneg (Y - Z))
  linarith [this]

lemma thh_lipschitz (t s : ℝ) (ht : |t| ≤ 1) (hs : |s| ≤ 1) :
    |thh t - thh s| ≤ |t - s| := by
  have h : thh t - thh s = (t - s) * (1/2 - (t+s)/8 + (t^2+t*s+s^2)/24) := by
    simp only [thh]; ring
  rw [h, abs_mul]
  have h1 : |t + s| ≤ 2 := by
    have := abs_add_le t s; linarith [this, ht, hs]
  have h2 : |t^2 + t*s + s^2| ≤ 3 := by
    have hy2 : |t|^2 ≤ 1 := by nlinarith [abs_nonneg t, ht]
    have hz2 : |s|^2 ≤ 1 := by nlinarith [abs_nonneg s, hs]
    have hyz : |t*s| ≤ 1 := by
      rw [abs_mul]
      simpa using mul_le_mul ht hs (abs_nonneg s) (by norm_num)
    have hsum : |t^2| + |t*s| + |s^2| ≤ 3 := by
      rw [abs_pow, abs_pow]; nlinarith [hy2, hz2, hyz]
    calc |t^2 + t*s + s^2| ≤ |t^2| + |t*s| + |s^2| := by
          have h12 := abs_add_le (t^2 + t*s) (s^2)
          have h13 := abs_add_le (t^2) (t*s)
          linarith
      _ ≤ 3 := hsum
  have e2 : |(-((t+s)/8))| = |t+s|/8 := by
    rw [abs_neg, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8)]
  have e3 : |(t^2+t*s+s^2)/24| = |t^2+t*s+s^2|/24 := by
    rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 24)]
  have hb : |1/2 - (t+s)/8 + (t^2+t*s+s^2)/24| ≤ 1 := by
    have h13 := abs_add_le (1/2 + -((t+s)/8)) ((t^2+t*s+s^2)/24)
    have h12 := abs_add_le (1/2) (-((t+s)/8))
    have e1 : |(1:ℝ)/2| = 1/2 := by norm_num
    rw [e1, e2] at h12
    rw [e3] at h13
    have heq : (1:ℝ)/2 - (t+s)/8 + (t^2+t*s+s^2)/24
        = (1/2 + -((t+s)/8)) + (t^2+t*s+s^2)/24 := by ring
    rw [heq]
    linarith [h12, h13, h1, h2]
  have := mul_le_mul_of_nonneg_right hb (abs_nonneg (t - s))
  linarith [this]

lemma thh_sub_tg (S : ℝ) (hS : |S| ≤ 1/2) :
    |thh (S + S^2 + S^3) - tg S| ≤ |S|^4 := by
  have h : thh (S + S^2 + S^3) - tg S
      = S^4 * (S^5/24 + S^4/8 + S^3/4 + S^2/6 - 1/4) := by
    simp only [thh, tg]; ring
  rw [h, abs_mul]
  have h3 : |S|^3 ≤ ((1/2:ℝ)^3) := pow_le_pow_left₀ (abs_nonneg S) hS 3
  have h4 : |S|^4 ≤ ((1/2:ℝ)^4) := pow_le_pow_left₀ (abs_nonneg S) hS 4
  have h5 : |S|^5 ≤ ((1/2:ℝ)^5) := pow_le_pow_left₀ (abs_nonneg S) hS 5
  norm_num at h3 h4 h5
  have h4' : (0:ℝ) ≤ S^4 := by positivity
  have hb : |S^5/24 + S^4/8 + S^3/4 + S^2/6 - 1/4| ≤ 1 := by
    have hS1 : S ≤ 1/2 := (abs_le.mp hS).2
    have hS2 : -(1/2:ℝ) ≤ S := (abs_le.mp hS).1
    rw [abs_le]
    constructor
    · have hb5 : -(1/32:ℝ) ≤ S^5 := by
        have : |S^5| ≤ (1/32:ℝ) := by rw [abs_pow]; exact h5
        exact (abs_le.mp this).1
      have hb3 : -(1/8:ℝ) ≤ S^3 := by
        have : |S^3| ≤ (1/8:ℝ) := by rw [abs_pow]; exact h3
        exact (abs_le.mp this).1
      nlinarith [hb5, hb3, h4', sq_nonneg S]
    · have hb5 : S^5 ≤ (1/32:ℝ) := by
        have : |S^5| ≤ (1/32:ℝ) := by rw [abs_pow]; exact h5
        exact (abs_le.mp this).2
      have hb3 : S^3 ≤ (1/8:ℝ) := by
        have : |S^3| ≤ (1/8:ℝ) := by rw [abs_pow]; exact h3
        exact (abs_le.mp this).2
      have hb4 : S^4 ≤ (1/16:ℝ) := by
        have : |S^4| ≤ (1/16:ℝ) := by rw [abs_pow]; exact h4
        exact (abs_le.mp this).2
      nlinarith [hb5, hb3, hb4, sq_nonneg S]
  have h4eq : |S^4| = |S|^4 := abs_pow S 4
  rw [h4eq]
  have := mul_le_mul_of_nonneg_right hb (by positivity : (0:ℝ) ≤ |S|^4)
  linarith [this]

lemma log_thh_bound (t : ℝ) (ht : |t| ≤ 1) :
    |Real.log (1 + t/2) - thh t| ≤ |t|^4 := by
  set y : ℝ := t/2 with hy
  have hy2 : |y| ≤ 1/2 := by
    rw [hy, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]
    linarith [ht]
  have hy1 : |y| < 1 := by linarith [hy2]
  have hmain := Real.abs_log_sub_add_sum_range_le (x := -y) (by rw [abs_neg]; exact hy1) 3
  have hsum : (∑ i ∈ Finset.range 3, (-y)^(i+1)/((i:ℝ)+1)) = -y + y^2/2 - y^3/3 := by
    norm_num [Finset.sum_range_succ]
    ring
  rw [hsum] at hmain
  have hmain' : |-y + y^2/2 - y^3/3 + Real.log (1 + y)| ≤ |y|^4/(1-|y|) := by
    simpa using hmain
  have hlog : Real.log (1 + y) = Real.log (1 + t/2) := by rw [hy]
  rw [hlog] at hmain'
  have hbound : (1:ℝ) - |y| ≥ 1/2 := by linarith [hy2]
  have hrhs : |y|^4/(1-|y|) ≤ |t|^4 := by
    rw [div_le_iff₀ (by linarith : (0:ℝ) < 1 - |y|)]
    have hy4 : |y|^4 = |t|^4/16 := by rw [hy, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]; ring
    rw [hy4]
    have ht4 : (0:ℝ) ≤ |t|^4 := by positivity
    nlinarith [ht4, hbound]
  have hkey : |-y + y^2/2 - y^3/3 + Real.log (1 + t/2)| = |Real.log (1 + t/2) - (y - y^2/2 + y^3/3)| := by
    rw [show -y + y^2/2 - y^3/3 = -(y - y^2/2 + y^3/3) by ring]
    rw [show -(y - y^2/2 + y^3/3) + Real.log (1 + t/2)
          = -((y - y^2/2 + y^3/3) - Real.log (1 + t/2)) by ring, abs_neg]
    rw [abs_sub_comm]
  rw [hkey] at hmain'
  have hthh : thh t = y - y^2/2 + y^3/3 := by
    simp only [thh]; rw [hy]; ring
  rw [hthh]
  exact hmain'.trans hrhs

noncomputable def tq (L x : ℝ) : ℝ :=
  (3*L/2)*x + (3*L^2 - (25/12)*L)*x^2 + ((73*L - 244*L^2 + 200*L^3)/8)*x^3

noncomputable def tPc (L x : ℝ) : ℝ :=
  (3*L)*x + ((6-26*L)*(3*L/2)/2 + (-(26/3)*L + (75/4)*L^2))*x^2
  + ((6-26*L)*(3*L^2 - (25/12)*L)/2 + (-26+75*L)*(3*L/2)^2/2
      + (-26/3 + (175/2)*L - (541/4)*L^2)*(3*L/2)
      + ((75/2)*L - (541/3)*L^2 + (1561/8)*L^3))*x^3

noncomputable def tPfull (L x : ℝ) : ℝ :=
  (6*L + (6-26*L)*tq L x + (-26+75*L)*(tq L x)^2 + (75-(541/3)*L)*(tq L x)^3)*x/2
  + ((-(26/3)*L + (75/4)*L^2) + (-26/3 + (175/2)*L - (541/4)*L^2)*(tq L x))*x^2
  + ((75/2)*L - (541/3)*L^2 + (1561/8)*L^3)*x^3

lemma monomial_abs_le {c x d : ℝ} {k : ℕ} (hc : |c| ≤ d) (hd : 0 ≤ d)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) (hk : 4 ≤ k) : |c * x^k| ≤ d * x^4 := by
  rw [abs_mul, abs_of_nonneg (pow_nonneg hx0 k)]
  have hpow : x^k ≤ x^4 := pow_le_pow_of_le_one hx0 hx1 hk
  calc |c| * x^k ≤ d * x^k := mul_le_mul_of_nonneg_right hc (pow_nonneg hx0 k)
    _ ≤ d * x^4 := mul_le_mul_of_nonneg_left hpow hd

lemma tg_tPc_sub_tq_le (L x : ℝ) (hL1 : (1/2:ℝ) ≤ L) (hL2 : L ≤ 1)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    |tg (tPc L x) - tq L x| ≤ ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216) + (188272301/6144) + (3386156375/12288)) * x^4 := by
  have hL0 : (0:ℝ) ≤ L := by linarith
  have h3 : L^3 ≤ 1 := pow_le_one₀ (n := 3) hL0 hL2
  have h4 : L^4 ≤ 1 := pow_le_one₀ (n := 4) hL0 hL2
  have h5 : L^5 ≤ 1 := pow_le_one₀ (n := 5) hL0 hL2
  have h6 : L^6 ≤ 1 := pow_le_one₀ (n := 6) hL0 hL2
  have h7 : L^7 ≤ 1 := pow_le_one₀ (n := 7) hL0 hL2
  have h8 : L^8 ≤ 1 := pow_le_one₀ (n := 8) hL0 hL2
  have h9 : L^9 ≤ 1 := pow_le_one₀ (n := 9) hL0 hL2
  have h10 : L^10 ≤ 1 := pow_le_one₀ (n := 10) hL0 hL2
  have hc4 : |(10107/128)*L^4 + (-4017/32)*L^3 + (4567/96)*L^2| ≤ (96793/384) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc5 : |(17703/64)*L^5 + (-3281/8)*L^4 + (59723/192)*L^3 + (-1825/32)*L^2| ≤ (101263/96) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc6 : |(12243/32)*L^6 + (-473851/256)*L^5 + (777737/384)*L^4 + (-323551/324)*L^3 + (15987/128)*L^2| ≤ (111610351/20736) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc7 : |(3824205/1024)*L^7 + (-4178293/512)*L^6 + (39814145/4608)*L^5 + (-2643893/576)*L^4 + (331639/288)*L^3| ≤ (242170145/9216) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc8 : |(-1902621/2048)*L^8 + (-9445681/3072)*L^7 + (3655127/384)*L^6 + (-8066219/768)*L^5 + (8300173/1536)*L^4 + (-932575/768)*L^3| ≤ (188272301/6144) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc9 : |(190896307/12288)*L^9 + (-107180983/2048)*L^8 + (166653165/2048)*L^7 + (-6985615/96)*L^6 + (40417545/1024)*L^5 + (-6304207/512)*L^4 + (2723119/1536)*L^3| ≤ (3386156375/12288) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hid : tg (tPc L x) - tq L x =
      ((10107/128)*L^4 + (-4017/32)*L^3 + (4567/96)*L^2)*x^4 + ((17703/64)*L^5 + (-3281/8)*L^4 + (59723/192)*L^3 + (-1825/32)*L^2)*x^5 + ((12243/32)*L^6 + (-473851/256)*L^5 + (777737/384)*L^4 + (-323551/324)*L^3 + (15987/128)*L^2)*x^6 + ((3824205/1024)*L^7 + (-4178293/512)*L^6 + (39814145/4608)*L^5 + (-2643893/576)*L^4 + (331639/288)*L^3)*x^7 + ((-1902621/2048)*L^8 + (-9445681/3072)*L^7 + (3655127/384)*L^6 + (-8066219/768)*L^5 + (8300173/1536)*L^4 + (-932575/768)*L^3)*x^8 + ((190896307/12288)*L^9 + (-107180983/2048)*L^8 + (166653165/2048)*L^7 + (-6985615/96)*L^6 + (40417545/1024)*L^5 + (-6304207/512)*L^4 + (2723119/1536)*L^3)*x^9 := by
    simp only [tg, tPc, tq]; ring
  have hx4 : (0:ℝ) ≤ x^4 := by positivity
  rw [hid, abs_le]
  constructor
  ·
    have e4 := (abs_le.mp (monomial_abs_le hc4 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 4))).1
    have e5 := (abs_le.mp (monomial_abs_le hc5 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 5))).1
    have e6 := (abs_le.mp (monomial_abs_le hc6 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 6))).1
    have e7 := (abs_le.mp (monomial_abs_le hc7 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 7))).1
    have e8 := (abs_le.mp (monomial_abs_le hc8 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 8))).1
    have e9 := (abs_le.mp (monomial_abs_le hc9 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 9))).1
    linarith [e4, e5, e6, e7, e8, e9, hx4]
  ·
    have e4 := (abs_le.mp (monomial_abs_le hc4 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 4))).2
    have e5 := (abs_le.mp (monomial_abs_le hc5 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 5))).2
    have e6 := (abs_le.mp (monomial_abs_le hc6 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 6))).2
    have e7 := (abs_le.mp (monomial_abs_le hc7 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 7))).2
    have e8 := (abs_le.mp (monomial_abs_le hc8 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 8))).2
    have e9 := (abs_le.mp (monomial_abs_le hc9 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 9))).2
    linarith [e4, e5, e6, e7, e8, e9, hx4]

lemma tPfull_sub_tPc_le (L x : ℝ) (hL1 : (1/2:ℝ) ≤ L) (hL2 : L ≤ 1)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    |tPfull L x - tPc L x| ≤ ((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368) + (218802155/72) + (6244672907/768) + (52926162179/1536)) * x^4 := by
  have hL0 : (0:ℝ) ≤ L := by linarith
  have h3 : L^3 ≤ 1 := pow_le_one₀ (n := 3) hL0 hL2
  have h4 : L^4 ≤ 1 := pow_le_one₀ (n := 4) hL0 hL2
  have h5 : L^5 ≤ 1 := pow_le_one₀ (n := 5) hL0 hL2
  have h6 : L^6 ≤ 1 := pow_le_one₀ (n := 6) hL0 hL2
  have h7 : L^7 ≤ 1 := pow_le_one₀ (n := 7) hL0 hL2
  have h8 : L^8 ≤ 1 := pow_le_one₀ (n := 8) hL0 hL2
  have h9 : L^9 ≤ 1 := pow_le_one₀ (n := 9) hL0 hL2
  have h10 : L^10 ≤ 1 := pow_le_one₀ (n := 10) hL0 hL2
  have hc4 : |(-11161/16)*L^4 + (18983/24)*L^3 + (-2023/6)*L^2 + (3271/72)*L^1| ≤ (269441/144) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc5 : |(-16457/8)*L^5 + (107135/32)*L^4 + (-67379/32)*L^3 + (23417/36)*L^2 + (-949/12)*L^1| ≤ (1186595/144) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc6 : |(-105939/8)*L^6 + (300209/16)*L^5 + (-158221/24)*L^4 + (-71753/96)*L^3 + (23725/48)*L^2| ≤ (3824609/96) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc7 : |(-79719/2)*L^7 + (330409/4)*L^6 + (-5380897/96)*L^5 + (98429059/10368)*L^4 + (259451/72)*L^3 + (-69277/64)*L^2| ≤ (1997833177/10368) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc8 : |(-1257825/4)*L^8 + (1816667/2)*L^7 + (-299706535/288)*L^6 + (340313167/576)*L^5 + (-47852141/288)*L^4 + (1184425/64)*L^3| ≤ (218802155/72) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc9 : |(-1014375/2)*L^9 + (43216525/24)*L^8 + (-7937153/3)*L^7 + (6175252/3)*L^6 + (-343324151/384)*L^5 + (315624625/1536)*L^4 + (-9991875/512)*L^3| ≤ (6244672907/768) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hc10 : |(-8453125/6)*L^10 + (22969375/4)*L^9 + (-159648675/16)*L^8 + (459857821/48)*L^7 + (-702555231/128)*L^6 + (480283279/256)*L^5 + (-1088144497/3072)*L^4 + (29176275/1024)*L^3| ≤ (52926162179/1536) := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, hL0,
      h3, h4, h5, h6, h7, h8, h9, h10,
      pow_nonneg hL0 3, pow_nonneg hL0 4, pow_nonneg hL0 5, pow_nonneg hL0 6,
      pow_nonneg hL0 7, pow_nonneg hL0 8, pow_nonneg hL0 9, pow_nonneg hL0 10]
  have hid : tPfull L x - tPc L x =
      ((-11161/16)*L^4 + (18983/24)*L^3 + (-2023/6)*L^2 + (3271/72)*L^1)*x^4 + ((-16457/8)*L^5 + (107135/32)*L^4 + (-67379/32)*L^3 + (23417/36)*L^2 + (-949/12)*L^1)*x^5 + ((-105939/8)*L^6 + (300209/16)*L^5 + (-158221/24)*L^4 + (-71753/96)*L^3 + (23725/48)*L^2)*x^6 + ((-79719/2)*L^7 + (330409/4)*L^6 + (-5380897/96)*L^5 + (98429059/10368)*L^4 + (259451/72)*L^3 + (-69277/64)*L^2)*x^7 + ((-1257825/4)*L^8 + (1816667/2)*L^7 + (-299706535/288)*L^6 + (340313167/576)*L^5 + (-47852141/288)*L^4 + (1184425/64)*L^3)*x^8 + ((-1014375/2)*L^9 + (43216525/24)*L^8 + (-7937153/3)*L^7 + (6175252/3)*L^6 + (-343324151/384)*L^5 + (315624625/1536)*L^4 + (-9991875/512)*L^3)*x^9 + ((-8453125/6)*L^10 + (22969375/4)*L^9 + (-159648675/16)*L^8 + (459857821/48)*L^7 + (-702555231/128)*L^6 + (480283279/256)*L^5 + (-1088144497/3072)*L^4 + (29176275/1024)*L^3)*x^10 := by
    simp only [tPfull, tPc, tq]; ring
  have hx4 : (0:ℝ) ≤ x^4 := by positivity
  rw [hid, abs_le]
  constructor
  ·
    have e4 := (abs_le.mp (monomial_abs_le hc4 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 4))).1
    have e5 := (abs_le.mp (monomial_abs_le hc5 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 5))).1
    have e6 := (abs_le.mp (monomial_abs_le hc6 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 6))).1
    have e7 := (abs_le.mp (monomial_abs_le hc7 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 7))).1
    have e8 := (abs_le.mp (monomial_abs_le hc8 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 8))).1
    have e9 := (abs_le.mp (monomial_abs_le hc9 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 9))).1
    have e10 := (abs_le.mp (monomial_abs_le hc10 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 10))).1
    linarith [e4, e5, e6, e7, e8, e9, e10, hx4]
  ·
    have e4 := (abs_le.mp (monomial_abs_le hc4 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 4))).2
    have e5 := (abs_le.mp (monomial_abs_le hc5 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 5))).2
    have e6 := (abs_le.mp (monomial_abs_le hc6 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 6))).2
    have e7 := (abs_le.mp (monomial_abs_le hc7 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 7))).2
    have e8 := (abs_le.mp (monomial_abs_le hc8 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 8))).2
    have e9 := (abs_le.mp (monomial_abs_le hc9 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 9))).2
    have e10 := (abs_le.mp (monomial_abs_le hc10 (by norm_num) hx0 hx1 (by norm_num : 4 ≤ 10))).2
    linarith [e4, e5, e6, e7, e8, e9, e10, hx4]

/-! ### Analytic inputs for the fourth-order inversion -/

/-- The model polynomial `tM(L,δ,x)`: the expansion of `SFourth(L+δ,n)` in powers of `δ`
and `x = 1/n`, with the explicit constants of `D(L)`, `D'(L)`, `E(L)`. -/
noncomputable def tM (L δ x : ℝ) : ℝ :=
  (6*L + (6-26*L)*δ + (-26+75*L)*δ^2 + (75-(541/3)*L)*δ^3)*x/2
  + ((-(26/3)*L + (75/4)*L^2) + (-26/3 + (175/2)*L - (541/4)*L^2)*δ)*x^2
  + ((75/2)*L - (541/3)*L^2 + (1561/8)*L^3)*x^3

lemma tPfull_eq_tM (L x : ℝ) : tPfull L x = tM L (tq L x) x := rfl

lemma D_log_two_explicit :
    D (Real.log 2) = -(26/3)*Real.log 2 + (75/4)*(Real.log 2)^2 := by
  unfold D; rw [PhiK3u_log_two, PhiK4u_log_two]; ring

lemma EFourth_log_two_explicit :
    EFourth (Real.log 2)
      = (75/2)*Real.log 2 - (541/3)*(Real.log 2)^2 + (1561/8)*(Real.log 2)^3 := by
  rw [EFourth_log_two]; ring

lemma EFourth_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) : |EFourth u| ≤ 10^11 := by
  have h4 := PhiK4u_le u hu1
  have h5 := PhiK5u_le u hu1
  have h6 := PhiK6u_le u hu1
  have h40 := PhiK4u_nonneg u
  have h50 : (0:ℝ) ≤ PhiK5u u := by rw [PhiK5u]; exact tsum_nonneg (fun k => by positivity)
  have h60 : (0:ℝ) ≤ PhiK6u u := by rw [PhiK6u]; exact tsum_nonneg (fun k => by positivity)
  have hu0 : (0:ℝ) ≤ u := by linarith
  have e1 : |(u/4)*PhiK4u u| ≤ (1/4)*(4*10^10) := by
    rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ u/4), abs_of_nonneg h40]
    exact mul_le_mul (by linarith : u/4 ≤ 1/4) h4 h40 (by norm_num)
  have e2 : |(u^2/6)*PhiK5u u| ≤ (1/6)*(4*10^10+5) := by
    rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ u^2/6), abs_of_nonneg h50]
    have hq : u^2/6 ≤ 1/6 := by nlinarith [hu0, hu2, sq_nonneg u]
    exact mul_le_mul hq h5 h50 (by norm_num)
  have e3 : |(u^3/48)*PhiK6u u| ≤ (1/48)*(4*10^10+5) := by
    rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ u^3/48), abs_of_nonneg h60]
    have hq : u^3/48 ≤ 1/48 := by nlinarith [hu0, hu2, pow_nonneg hu0 3]
    exact mul_le_mul hq h6 h60 (by norm_num)
  have hb := abs_add_le ((u/4)*PhiK4u u - (u^2/6)*PhiK5u u) ((u^3/48)*PhiK6u u)
  have hb2 : |(u/4)*PhiK4u u - (u^2/6)*PhiK5u u| ≤ |(u/4)*PhiK4u u| + |(u^2/6)*PhiK5u u| := by
    have h := abs_add_le ((u/4)*PhiK4u u) (-((u^2/6)*PhiK5u u))
    rw [show (u/4)*PhiK4u u + -((u^2/6)*PhiK5u u) = (u/4)*PhiK4u u - (u^2/6)*PhiK5u u by ring,
      abs_neg] at h
    exact h
  have hkey : EFourth u = ((u/4)*PhiK4u u - (u^2/6)*PhiK5u u) + (u^3/48)*PhiK6u u := by
    unfold EFourth; ring
  rw [hkey]
  linarith [hb, hb2, e1, e2, e3]

lemma SFourth_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |SFourth u n| ≤ 2*10^11/(n:ℝ) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have h1 := SThird_first_le u hu1 hu2 n hn
  have h2 := SThird_D_abs_le u hu1 hu2
  have h3 := EFourth_abs_le u hu1 hu2
  have hn2 : (n:ℝ) ≤ (n:ℝ)^2 := by nlinarith [hn1]
  have t2 : |D u/((n:ℝ)^2)| ≤ 4*10^10/(n:ℝ) := by
    rw [show D u = -(u/3)*PhiK3u u + (u^2/8)*PhiK4u u from rfl]
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^2))]
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^2)) hnR]
    nlinarith [h2, hn1, hn2, hnR]
  have hn3 : (n:ℝ) ≤ (n:ℝ)^3 := by nlinarith [hn1, hn2]
  have t3 : |EFourth u/((n:ℝ)^3)| ≤ 10^11/(n:ℝ) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^3))]
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < ((n:ℝ)^3)) hnR]
    nlinarith [h3, hn1, hn2, hn3, hnR]
  have hb := abs_add_le (u/(2*(n:ℝ))*PhiS u + D u/((n:ℝ)^2)) (EFourth u/((n:ℝ)^3))
  have hb2 := abs_add_le (u/(2*(n:ℝ))*PhiS u) (D u/((n:ℝ)^2))
  have hsum : 15/(n:ℝ) + 4*10^10/(n:ℝ) + 10^11/(n:ℝ) ≤ 2*10^11/(n:ℝ) := by
    rw [← add_div, ← add_div]
    rw [div_le_div_iff₀ hnR hnR]
    nlinarith [hnR]
  rw [show SFourth u n = u/(2*(n:ℝ))*PhiS u + D u/((n:ℝ)^2) + EFourth u/((n:ℝ)^3) from rfl]
  linarith [hb, hb2, h1, t2, t3, hsum]

lemma tq_abs_le (L x : ℝ) (hL1 : (1/2:ℝ) ≤ L) (hL2 : L ≤ 1)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) : |tq L x| ≤ 200 * x := by
  have hLabs : |L| ≤ 1 := by rw [abs_le]; constructor <;> linarith [hL1, hL2]
  have hp2 : |L|^2 ≤ 1 := pow_le_pow_left₀ (abs_nonneg L) hLabs 2 |>.trans_eq (by norm_num)
  have hp3 : |L|^3 ≤ 1 := pow_le_pow_left₀ (abs_nonneg L) hLabs 3 |>.trans_eq (by norm_num)
  have ha : |3*L/2| ≤ 2 := by
    rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3),
      abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]
    nlinarith [hLabs]
  have hb : |3*L^2 - (25/12)*L| ≤ 6 := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2, sq_nonneg L]
  have hc : |(73*L - 244*L^2 + 200*L^3)/8| ≤ 70 := by
    have hA : |73*L - 244*L^2 + 200*L^3| ≤ 73 + 244 + 200 := by
      have a1 := abs_add_le (73*L - 244*L^2) (200*L^3)
      have a2 : |(73:ℝ)*L - 244*L^2| ≤ |73*L| + |244*L^2| := by
        have h := abs_add_le (73*L) (-(244*L^2))
        rw [show (73:ℝ)*L + -(244*L^2) = 73*L - 244*L^2 by ring, abs_neg] at h
        exact h
      have e1 : |73*L| = 73*|L| := by rw [abs_mul]; norm_num
      have e2 : |244*L^2| = 244*|L|^2 := by rw [abs_mul, abs_pow]; norm_num
      have e3 : |200*L^3| = 200*|L|^3 := by rw [abs_mul, abs_pow]; norm_num
      have q1 : |73*L| ≤ 73 := by rw [e1]; nlinarith [hLabs]
      have q2 : |244*L^2| ≤ 244 := by rw [e2]; nlinarith [hp2]
      have q3 : |200*L^3| ≤ 200 := by rw [e3]; nlinarith [hp3]
      linarith [a1, a2, q1, q2, q3]
    rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8)]
    linarith [hA]
  have hsa := abs_add_le ((3*L/2)*x) ((3*L^2 - (25/12)*L)*x^2)
  have hsb := abs_add_le ((3*L/2)*x + (3*L^2 - (25/12)*L)*x^2) (((73*L - 244*L^2 + 200*L^3)/8)*x^3)
  have e1 : |(3*L/2)*x| ≤ 2*x := by
    rw [abs_mul, abs_of_nonneg hx0]
    exact mul_le_mul_of_nonneg_right ha hx0
  have e2 : |(3*L^2 - (25/12)*L)*x^2| ≤ 6*x := by
    rw [abs_mul, abs_of_nonneg (pow_nonneg hx0 2)]
    have hx2 : x^2 ≤ x := by nlinarith [hx0, hx1]
    exact mul_le_mul hb hx2 (pow_nonneg hx0 2) (by norm_num)
  have e3 : |((73*L - 244*L^2 + 200*L^3)/8)*x^3| ≤ 70*x := by
    rw [abs_mul, abs_of_nonneg (pow_nonneg hx0 3)]
    have hx3 : x^3 ≤ x := by nlinarith [hx0, hx1, sq_nonneg x]
    exact mul_le_mul hc hx3 (pow_nonneg hx0 3) (by norm_num)
  rw [show tq L x = (3*L/2)*x + (3*L^2 - (25/12)*L)*x^2 + ((73*L - 244*L^2 + 200*L^3)/8)*x^3 from rfl]
  linarith [hsa, hsb, e1, e2, e3]

lemma tM_lipschitz (L δ q x : ℝ) (hL1 : (1/2:ℝ) ≤ L) (hL2 : L ≤ 1)
    (hδ : |δ| ≤ 1/4) (hq : |q| ≤ 1/4) (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    |tM L δ x - tM L q x| ≤ 500 * |δ - q| * x := by
  have h : tM L δ x - tM L q x
      = (δ - q) * (((6-26*L) + (-26+75*L)*(δ+q) + (75-(541/3)*L)*(δ^2+δ*q+q^2))*x/2
          + (-26/3 + (175/2)*L - (541/4)*L^2)*x^2) := by
    unfold tM; ring
  rw [h, abs_mul]
  have hdq : |δ + q| ≤ 1/2 := by
    have := abs_add_le δ q; linarith [this, hδ, hq]
  have hdqs : |δ^2 + δ*q + q^2| ≤ 3/16 := by
    have h1 : |δ|^2 ≤ (1/4)^2 := pow_le_pow_left₀ (abs_nonneg δ) hδ 2
    have h2 : |q|^2 ≤ (1/4)^2 := pow_le_pow_left₀ (abs_nonneg q) hq 2
    have h3 : |δ*q| ≤ (1/4)*(1/4) := by
      rw [abs_mul]; exact mul_le_mul hδ hq (abs_nonneg q) (by norm_num)
    have hsum : |δ^2| + |δ*q| + |q^2| ≤ 3/16 := by
      rw [abs_pow, abs_pow]; nlinarith [h1, h2, h3]
    calc |δ^2 + δ*q + q^2| ≤ |δ^2| + |δ*q| + |q^2| := by
          have a := abs_add_le (δ^2 + δ*q) (q^2)
          have b := abs_add_le (δ^2) (δ*q)
          linarith
      _ ≤ 3/16 := hsum
  have ca : |6-26*L| ≤ 100 := by
    rw [abs_le]; constructor <;> linarith [hL1, hL2]
  have cb : |-26+75*L| ≤ 200 := by
    rw [abs_le]; constructor <;> linarith [hL1, hL2]
  have cc : |75-(541/3)*L| ≤ 200 := by
    rw [abs_le]; constructor <;> linarith [hL1, hL2]
  have cd : |-26/3 + (175/2)*L - (541/4)*L^2| ≤ 100 := by
    rw [abs_le]; constructor <;> nlinarith [hL1, hL2]
  have hb : |((6-26*L) + (-26+75*L)*(δ+q) + (75-(541/3)*L)*(δ^2+δ*q+q^2))*x/2
        + (-26/3 + (175/2)*L - (541/4)*L^2)*x^2| ≤ 500 * x := by
    have hA : |(6-26*L) + (-26+75*L)*(δ+q) + (75-(541/3)*L)*(δ^2+δ*q+q^2)| ≤ 500 := by
      have a := abs_add_le ((6-26*L) + (-26+75*L)*(δ+q)) ((75-(541/3)*L)*(δ^2+δ*q+q^2))
      have b := abs_add_le (6-26*L) ((-26+75*L)*(δ+q))
      have e1 : |(-26+75*L)*(δ+q)| ≤ 200*(1/2) := by
        rw [abs_mul]; exact mul_le_mul cb hdq (abs_nonneg _) (by norm_num)
      have e2 : |(75-(541/3)*L)*(δ^2+δ*q+q^2)| ≤ 200*(3/16) := by
        rw [abs_mul]; exact mul_le_mul cc hdqs (abs_nonneg _) (by norm_num)
      linarith [a, b, ca, e1, e2]
    have t1 : |((6-26*L) + (-26+75*L)*(δ+q) + (75-(541/3)*L)*(δ^2+δ*q+q^2))*x/2| ≤ 500*x/2 := by
      rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2), abs_of_nonneg hx0]
      have := mul_le_mul_of_nonneg_right hA hx0
      linarith [this]
    have t2 : |(-26/3 + (175/2)*L - (541/4)*L^2)*x^2| ≤ 100*x := by
      rw [abs_mul, abs_of_nonneg (pow_nonneg hx0 2)]
      have hx2 : x^2 ≤ x := by nlinarith [hx0, hx1]
      exact mul_le_mul cd hx2 (pow_nonneg hx0 2) (by norm_num)
    have t3 := abs_add_le (((6-26*L) + (-26+75*L)*(δ+q) + (75-(541/3)*L)*(δ^2+δ*q+q^2))*x/2)
      ((-26/3 + (175/2)*L - (541/4)*L^2)*x^2)
    linarith [t3, t1, t2, hx0]
  have := mul_le_mul_of_nonneg_right hb (abs_nonneg (δ - q))
  linarith [this]

/-- **Model expansion of `SFourth`.**  For `u ∈ [1/2,1]` with `δ = u - log 2`, `|δ| ≤ 1/4`,
and any `D ≥ 0` with `|δ| ≤ D/n`, the model `tM (log 2) δ (1/n)` approximates
`SFourth u n` to order `n⁻⁴`. -/
lemma SFourth_model (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hub : |u - Real.log 2| ≤ 1/4)
    (n : ℕ) (hn : 1 ≤ n) (Dd : ℝ) (hD : 0 ≤ Dd) (hδx : |u - Real.log 2| ≤ Dd / (n:ℝ)) :
    |SFourth u n - tM (Real.log 2) (u - Real.log 2) (1/(n:ℝ))|
      ≤ (10^16 * Dd^4/2 + 10^21 * Dd^2 + 10^21 * Dd) / (n:ℝ)^4 := by
  have hL1 : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  have hL2 : Real.log 2 ≤ 1 := log_two_le_one
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have h1 := uPhiS_expansion_fourth u hu1 hu2
  have h2 := D_first_order u hu1 hu2 hub
  have h3 := EFourth_diff_le u hu1 hu2 hub
  rw [D_log_two_explicit] at h2
  rw [EFourth_log_two_explicit] at h3
  have hkey : SFourth u n - tM (Real.log 2) (u - Real.log 2) (1/(n:ℝ))
      = (u*PhiS u - (6*Real.log 2 + (6 - 26*Real.log 2)*(u - Real.log 2)
          + (-26 + 75*Real.log 2)*(u - Real.log 2)^2
          + (75 - (541/3)*Real.log 2)*(u - Real.log 2)^3))/(2*(n:ℝ))
        + (D u - (-(26/3)*Real.log 2 + (75/4)*Real.log 2^2)
            - (-26/3 + (175/2)*Real.log 2 - (541/4)*Real.log 2^2)*(u - Real.log 2))/((n:ℝ)^2)
        + (EFourth u - ((75/2)*Real.log 2 - (541/3)*Real.log 2^2 + (1561/8)*Real.log 2^3))/((n:ℝ)^3) := by
    unfold SFourth tM
    field_simp
    ring
  rw [hkey]
  have hd1 : |u - Real.log 2| * (n:ℝ) ≤ Dd := by
    have h := mul_le_mul_of_nonneg_right hδx (le_of_lt hnR)
    rwa [div_mul_cancel₀ _ (ne_of_gt hnR)] at h
  have hd2 : |u - Real.log 2|^2 * (n:ℝ)^2 ≤ Dd^2 := by
    have hh : |u - Real.log 2|^2 ≤ (Dd/(n:ℝ))^2 := pow_le_pow_left₀ (abs_nonneg _) hδx 2
    rw [div_pow] at hh
    rwa [le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^2)] at hh
  have hd4 : |u - Real.log 2|^4 * (n:ℝ)^4 ≤ Dd^4 := by
    have hh : |u - Real.log 2|^4 ≤ (Dd/(n:ℝ))^4 := pow_le_pow_left₀ (abs_nonneg _) hδx 4
    rw [div_pow] at hh
    rwa [le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^4)] at hh
  have habs4 : |u - Real.log 2|^4 = (u - Real.log 2)^4 := by
    rw [← abs_pow, abs_of_nonneg (show (0:ℝ) ≤ (u - Real.log 2)^4 by positivity)]
  have habs2 : |u - Real.log 2|^2 = (u - Real.log 2)^2 := sq_abs _
  have t1 : |(u*PhiS u - (6*Real.log 2 + (6 - 26*Real.log 2)*(u - Real.log 2)
        + (-26 + 75*Real.log 2)*(u - Real.log 2)^2
        + (75 - (541/3)*Real.log 2)*(u - Real.log 2)^3))/(2*(n:ℝ))|
      ≤ 10^16 * (u - Real.log 2)^4 / (2*(n:ℝ)) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 2*(n:ℝ))]
    exact div_le_div_of_nonneg_right h1 (by positivity)
  have t2 : |(D u - (-(26/3)*Real.log 2 + (75/4)*Real.log 2^2)
        - (-26/3 + (175/2)*Real.log 2 - (541/4)*Real.log 2^2)*(u - Real.log 2))/((n:ℝ)^2)|
      ≤ 10^21 * (u - Real.log 2)^2 / ((n:ℝ)^2) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^2))]
    exact div_le_div_of_nonneg_right h2 (by positivity)
  have t3 : |(EFourth u - ((75/2)*Real.log 2 - (541/3)*Real.log 2^2 + (1561/8)*Real.log 2^3))/((n:ℝ)^3)|
      ≤ 10^21 * |u - Real.log 2| / ((n:ℝ)^3) := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((n:ℝ)^3))]
    exact div_le_div_of_nonneg_right h3 (by positivity)
  have hD4nn : (0:ℝ) ≤ Dd^4 := pow_nonneg hD 4
  have hD2nn : (0:ℝ) ≤ Dd^2 := pow_nonneg hD 2
  have hDn4 : Dd^4 ≤ Dd^4 * (n:ℝ) := by nlinarith [hD4nn, hn1]
  have hDn2 : Dd^2 ≤ Dd^2 * (n:ℝ) := by nlinarith [hD2nn, hn1]
  have e1 : 10^16 * (u - Real.log 2)^4 / (2*(n:ℝ)) ≤ (10^16 * Dd^4/2) / (n:ℝ)^4 := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by positivity : (0:ℝ) < (n:ℝ)^4)]
    rw [← habs4]
    nlinarith [hd4, hn1, hD, hD4nn, hDn4, pow_pos hnR 4]
  have e2 : 10^21 * (u - Real.log 2)^2 / ((n:ℝ)^2) ≤ (10^21 * Dd^2) / (n:ℝ)^4 := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^2) (by positivity : (0:ℝ) < (n:ℝ)^4)]
    rw [← habs2]
    nlinarith [hd2, hn1, hD, hD2nn, hDn2, pow_pos hnR 2]
  have e3 : 10^21 * |u - Real.log 2| / ((n:ℝ)^3) ≤ (10^21 * Dd) / (n:ℝ)^4 := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^3) (by positivity : (0:ℝ) < (n:ℝ)^4)]
    nlinarith [hd1, hn1, hD, pow_pos hnR 3]
  have hb1 := abs_add_le ((u*PhiS u - (6*Real.log 2 + (6 - 26*Real.log 2)*(u - Real.log 2)
        + (-26 + 75*Real.log 2)*(u - Real.log 2)^2
        + (75 - (541/3)*Real.log 2)*(u - Real.log 2)^3))/(2*(n:ℝ))
      + (D u - (-(26/3)*Real.log 2 + (75/4)*Real.log 2^2)
          - (-26/3 + (175/2)*Real.log 2 - (541/4)*Real.log 2^2)*(u - Real.log 2))/((n:ℝ)^2))
    ((EFourth u - ((75/2)*Real.log 2 - (541/3)*Real.log 2^2 + (1561/8)*Real.log 2^3))/((n:ℝ)^3))
  have hb2 := abs_add_le ((u*PhiS u - (6*Real.log 2 + (6 - 26*Real.log 2)*(u - Real.log 2)
        + (-26 + 75*Real.log 2)*(u - Real.log 2)^2
        + (75 - (541/3)*Real.log 2)*(u - Real.log 2)^3))/(2*(n:ℝ)))
    ((D u - (-(26/3)*Real.log 2 + (75/4)*Real.log 2^2)
        - (-26/3 + (175/2)*Real.log 2 - (541/4)*Real.log 2^2)*(u - Real.log 2))/((n:ℝ)^2))
  have hfin : (10^16 * Dd^4/2) / (n:ℝ)^4 + (10^21 * Dd^2) / (n:ℝ)^4 + (10^21 * Dd) / (n:ℝ)^4
      = (10^16 * Dd^4/2 + 10^21 * Dd^2 + 10^21 * Dd) / (n:ℝ)^4 := by ring
  linarith [hb1, hb2, t1, t2, t3, e1, e2, e3, hfin]


/-! ### Wide Lipschitz bound and the fourth-order uniform threshold theorem -/

/-- Wide Lipschitz bound for `tg` on `|·| ≤ 1` (constant `3`). -/
lemma tg_lipschitz_wide (Y Z : ℝ) (hY : |Y| ≤ 1) (hZ : |Z| ≤ 1) :
    |tg Y - tg Z| ≤ 3 * |Y - Z| := by
  have h : tg Y - tg Z = (Y - Z) * (1/2 + 3*(Y+Z)/8 + 7*(Y^2+Y*Z+Z^2)/24) := by
    simp only [tg]; ring
  rw [h, abs_mul]
  have h1 : |Y + Z| ≤ 2 := by
    have := abs_add_le Y Z; linarith [this, hY, hZ]
  have h2 : |Y^2 + Y*Z + Z^2| ≤ 3 := by
    have hy2 : |Y|^2 ≤ 1 := by nlinarith [abs_nonneg Y, hY]
    have hz2 : |Z|^2 ≤ 1 := by nlinarith [abs_nonneg Z, hZ]
    have hyz : |Y*Z| ≤ 1 := by
      rw [abs_mul]; simpa using mul_le_mul hY hZ (abs_nonneg Z) (by norm_num)
    have hsum : |Y^2| + |Y*Z| + |Z^2| ≤ 3 := by
      rw [abs_pow, abs_pow]; nlinarith [hy2, hz2, hyz]
    calc |Y^2 + Y*Z + Z^2| ≤ |Y^2| + |Y*Z| + |Z^2| := by
          have a := abs_add_le (Y^2 + Y*Z) (Z^2)
          have b := abs_add_le (Y^2) (Y*Z)
          linarith
      _ ≤ 3 := hsum
  have e2 : |3*(Y+Z)/8| = 3*|Y+Z|/8 := by
    rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3),
      abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8)]
  have e3 : |7*(Y^2+Y*Z+Z^2)/24| = 7*|Y^2+Y*Z+Z^2|/24 := by
    rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 7),
      abs_of_nonneg (by norm_num : (0:ℝ) ≤ 24)]
  have hb : |1/2 + 3*(Y+Z)/8 + 7*(Y^2+Y*Z+Z^2)/24| ≤ 3 := by
    have h13 := abs_add_le (1/2 + 3*(Y+Z)/8) (7*(Y^2+Y*Z+Z^2)/24)
    have h12 := abs_add_le (1/2) (3*(Y+Z)/8)
    have e1 : |(1:ℝ)/2| = 1/2 := by norm_num
    rw [e1, e2] at h12
    rw [e3] at h13
    linarith [h12, h13, h1, h2]
  have := mul_le_mul_of_nonneg_right hb (abs_nonneg (Y - Z))
  linarith [this]

/-- **`threshold_fourth_order_uniform`.**  Uniformly over the threshold solutions
`Phi (u*n) n = 1` (`u ∈ [1/2,1]`),

`u = log 2 + 3log2/(2n) + (3log2² − (25/12)log2)/n² + ((73log2 − 244log2² + 200log2³)/8)/n³ + O(n⁻⁴)`. -/
theorem threshold_fourth_order_uniform :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      IsThreshold n (u*(n:ℝ)) →
        |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))
            - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2
            - ((73*Real.log 2 - 244*Real.log 2^2 + 200*Real.log 2^3)/8)/(n:ℝ)^3|
          ≤ C/(n:ℝ)^4 := by
  obtain ⟨C0, hC0pos, hev0⟩ := Phi_fourth_order
  obtain ⟨C3, hC3pos, hev3⟩ := threshold_third_order_uniform
  have hC0le : (0:ℝ) ≤ C0 := le_of_lt hC0pos
  have hC3le : (0:ℝ) ≤ C3 := le_of_lt hC3pos
  have hKA_nn : (0:ℝ) ≤ 10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3) := by
    have h0 : (0:ℝ) ≤ 8 + C3 := by linarith
    have h4 : (0:ℝ) ≤ (8+C3)^4 := pow_nonneg h0 4
    have h2 : (0:ℝ) ≤ (8+C3)^2 := pow_nonneg h0 2
    nlinarith
  have hKD_nn : (0:ℝ) ≤ 500*(C3+70) := by linarith
  have hK3_nn : (0:ℝ) ≤ (269441/144:ℝ) + (1186595/144) + (3824609/96) + (1997833177/10368)
      + (218802155/72) + (6244672907/768) + (52926162179/1536) := by norm_num
  have hK2_nn : (0:ℝ) ≤ (96793/384:ℝ) + (101263/96) + (111610351/20736) + (242170145/9216)
      + (188272301/6144) + (3386156375/12288) := by norm_num
  refine ⟨(2*(2*10^11 + C0))^4 + (4*C0 + 3*(2*10^11)^4)
      + (3*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3))
         + 3*(500*(C3+70))
         + 3*((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
              + (218802155/72) + (6244672907/768) + (52926162179/1536))
         + ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216)
              + (188272301/6144) + (3386156375/12288))), ?hpos, ?hmain⟩
  · have h1 : (0:ℝ) < (2*(2*10^11 + C0))^4 := pow_pos (by linarith [hC0pos]) 4
    have h2 : (0:ℝ) ≤ 4*C0 + 3*(2*10^11)^4 := by nlinarith [hC0pos]
    linarith [h1, h2, hKA_nn, hKD_nn, hK3_nn, hK2_nn]
  · have hMev : ∀ᶠ n : ℕ in Filter.atTop,
        (8*C0 + 8*C3 + 16 + 2*(2*10^11 + C0)
          + 4*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3))
          + 4*(500*(C3+70))
          + 4*((269441/144:ℝ) + (1186595/144) + (3824609/96) + (1997833177/10368)
              + (218802155/72) + (6244672907/768) + (52926162179/1536))
          + 2000) ≤ (n:ℝ) :=
      tendsto_natCast_atTop_atTop.eventually (Filter.eventually_ge_atTop _)
    filter_upwards [hev0, hev3, hMev, Filter.eventually_ge_atTop (10^20)] with n hn0 hn3 hMn hnbig
    intro u hu1 hu2 hthr
    have hnR : (0:ℝ) < (n:ℝ) := by positivity
    have hn1e20 : (10^20:ℝ) ≤ (n:ℝ) := by exact_mod_cast hnbig
    have hn1 : (1:ℝ) ≤ (n:ℝ) := le_trans (by norm_num : (1:ℝ) ≤ 10^20) hn1e20
    have hn800 : (800:ℝ) ≤ (n:ℝ) := le_trans (by norm_num : (800:ℝ) ≤ 10^20) hn1e20
    have hn4e11 : (8*10^11:ℝ) ≤ (n:ℝ) :=
      le_trans (by norm_num : (8*10^11:ℝ) ≤ 10^20) hn1e20
    have hKtn : 2*(2*10^11 + C0) ≤ (n:ℝ) :=
      by linarith [hMn, hC0le, hC3le, hKA_nn, hKD_nn, hK3_nn]
    have hK3n : 4*((269441/144:ℝ) + (1186595/144) + (3824609/96) + (1997833177/10368)
        + (218802155/72) + (6244672907/768) + (52926162179/1536)) ≤ (n:ℝ) :=
      by linarith [hMn, hC0le, hC3le, hKA_nn, hKD_nn]
    set x : ℝ := 1/(n:ℝ) with hx
    have hx0 : (0:ℝ) ≤ x := by rw [hx]; positivity
    have hx1 : x ≤ 1 := by rw [hx, div_le_one hnR]; exact hn1
    have hxsq : x^2 ≤ x := by nlinarith [hx0, hx1]
    have hx3 : x^3 ≤ x := by nlinarith [hx0, hx1, sq_nonneg x]
    have hx4 : x^4 = 1/(n:ℝ)^4 := by rw [hx]; field_simp
    have hn14 : (n:ℝ) ≤ (n:ℝ)^4 := by
      nlinarith [hn1, hnR, sq_nonneg (n:ℝ), pow_nonneg (le_of_lt hnR) 3]
    have hthird : |(u - Real.log 2) - (3*Real.log 2/2)*x
        - (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2| ≤ C3*x^3 := by
      have h := hn3 u hu1 hu2 hthr
      rw [hx]
      convert h using 2 <;> field_simp <;> ring
    have hA1 : |3*Real.log 2/2| ≤ 2 := by
      rw [abs_div, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 3),
        abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]
      have h : |Real.log 2| ≤ 1 := abs_le.mpr ⟨by linarith [log_two_ge_half], by linarith [log_two_le_one]⟩
      linarith
    have hA2 : |3*Real.log 2^2 - (25/12)*Real.log 2| ≤ 6 := by
      rw [abs_le]; constructor <;> nlinarith [log_two_ge_half, log_two_le_one, sq_nonneg (Real.log 2)]
    have hδx : |u - Real.log 2| ≤ (8+C3)*x := by
      have hsplit : u - Real.log 2 = ((u - Real.log 2) - (3*Real.log 2/2)*x
            - (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2)
          + ((3*Real.log 2/2)*x + (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2) := by ring
      rw [hsplit]
      have hA := abs_add_le ((u - Real.log 2) - (3*Real.log 2/2)*x
          - (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2)
        ((3*Real.log 2/2)*x + (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2)
      have hb : |(3*Real.log 2/2)*x + (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2|
          ≤ 2*x + 6*x^2 := by
        have h1 : |(3*Real.log 2/2)*x| ≤ 2*x := by
          rw [abs_mul, abs_of_nonneg hx0]; exact mul_le_mul_of_nonneg_right hA1 hx0
        have h2 : |(3*Real.log 2^2 - (25/12)*Real.log 2)*x^2| ≤ 6*x^2 := by
          rw [abs_mul, abs_of_nonneg (pow_nonneg hx0 2)]
          exact mul_le_mul_of_nonneg_right hA2 (pow_nonneg hx0 2)
        have h12 := abs_add_le ((3*Real.log 2/2)*x)
          ((3*Real.log 2^2 - (25/12)*Real.log 2)*x^2)
        linarith [h12, h1, h2]
      nlinarith [hA, hthird, hb, hx0, hx1, hxsq, hx3, hC3le]
    have hδ_quarter : |u - Real.log 2| ≤ 1/4 := by
      have h4 : 4*(8+C3) ≤ (n:ℝ) := by linarith [hMn, hC0le, hKA_nn, hKD_nn, hK3_nn]
      have hsmall : (8+C3)*x ≤ 1/4 := by
        rw [hx, mul_one_div, div_le_iff₀ hnR]; linarith [h4]
      linarith [hδx, hsmall]
    have hq : |tq (Real.log 2) x| ≤ 200*x := tq_abs_le _ _ log_two_ge_half log_two_le_one hx0 hx1
    have hq_quarter : |tq (Real.log 2) x| ≤ 1/4 := by
      have hsmall : 200*x ≤ 1/4 := by
        rw [hx, mul_one_div, div_le_iff₀ hnR]; linarith [hn800]
      linarith [hq, hsmall]
    have hS_abs : |SFourth u n| ≤ 2*10^11 * x := by
      rw [hx, mul_one_div]
      exact SFourth_abs_le u hu1 hu2 n (by omega : 1 ≤ n)
    have hS_quarter : |SFourth u n| ≤ 1/4 := by
      have hsmall : 2*10^11*x ≤ 1/4 := by
        rw [hx, mul_one_div, div_le_iff₀ hnR]; linarith [hn4e11]
      linarith [hS_abs, hsmall]
    have hδn : |u - Real.log 2| ≤ (8+C3)/(n:ℝ) := by
      have h := hδx
      rwa [hx, mul_one_div] at h
    have hmodel := SFourth_model u hu1 hu2 hδ_quarter n (by omega : 1 ≤ n)
      (8+C3) (by linarith) hδn
    have hKA : |SFourth u n - tM (Real.log 2) (u - Real.log 2) x|
        ≤ (10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3)) * x^4 := by
      have h := hmodel
      have h2 : (1:ℝ)/(n:ℝ) = x := by rw [hx]
      rw [h2] at h
      have h1 : (10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3)) / (n:ℝ)^4
          = (10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3)) * x^4 := by
        rw [hx4, mul_one_div]
      rwa [h1] at h
    have hKAsm : (10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3)) * x^4 ≤ 1/4 := by
      have hKA4 : 4*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3)) ≤ (n:ℝ) :=
        by linarith [hMn, hC0le, hC3le, hKD_nn, hK3_nn]
      rw [hx4, mul_one_div]; rw [div_le_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^4)]
      nlinarith [hKA4, hn14, hn1]
    have hK3sm : ((269441/144:ℝ) + (1186595/144) + (3824609/96) + (1997833177/10368)
        + (218802155/72) + (6244672907/768) + (52926162179/1536)) * x^4 ≤ 1/4 := by
      rw [hx4, mul_one_div]; rw [div_le_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^4)]
      nlinarith [hK3n, hn14, hn1]
    have hKDsm : 500*(C3+70)*x^4 ≤ 1/4 := by
      have hC3K4 : 4*(500*(C3+70)) ≤ (n:ℝ) :=
        by linarith [hMn, hC0le, hKA_nn, hK3_nn]
      rw [hx4, mul_one_div]; rw [div_le_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^4)]
      nlinarith [hC3K4, hn14, hn1, hC3le]
    have hM_d_half : |tM (Real.log 2) (u - Real.log 2) x| ≤ 1/2 := by
      have h := abs_add_le (SFourth u n) (-(SFourth u n - tM (Real.log 2) (u - Real.log 2) x))
      rw [abs_neg] at h
      rw [show SFourth u n + (-(SFourth u n - tM (Real.log 2) (u - Real.log 2) x))
            = tM (Real.log 2) (u - Real.log 2) x by ring] at h
      linarith only [h, hS_quarter, hKA, hKAsm]
    have htg_model : |tg (SFourth u n) - tg (tM (Real.log 2) (u - Real.log 2) x)|
        ≤ 3 * ((10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3)) * x^4) := by
      have := tg_lipschitz_wide (SFourth u n) (tM (Real.log 2) (u - Real.log 2) x)
        (by linarith [hS_quarter]) (by linarith [hM_d_half])
      linarith [this, hKA]
    have hδq : |(u - Real.log 2) - tq (Real.log 2) x| ≤ (C3 + 70)*x^3 := by
      have hsplit : (u - Real.log 2) - tq (Real.log 2) x
          = ((u - Real.log 2) - (3*Real.log 2/2)*x - (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2)
            + (-(((73*Real.log 2 - 244*Real.log 2^2 + 200*Real.log 2^3)/8)*x^3)) := by
        unfold tq; ring
      rw [hsplit]
      have hA := abs_add_le ((u - Real.log 2) - (3*Real.log 2/2)*x
          - (3*Real.log 2^2 - (25/12)*Real.log 2)*x^2)
        (-(((73*Real.log 2 - 244*Real.log 2^2 + 200*Real.log 2^3)/8)*x^3))
      rw [abs_neg] at hA
      have hc : |(73*Real.log 2 - 244*Real.log 2^2 + 200*Real.log 2^3)/8| ≤ 70 := by
        rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 8)]
        rw [div_le_iff₀ (by norm_num : (0:ℝ) < 8)]
        have hLabs : |Real.log 2| ≤ 1 := by
          rw [abs_le]; constructor <;> linarith [log_two_ge_half, log_two_le_one]
        have hp2 : |Real.log 2|^2 ≤ 1 := pow_le_pow_left₀ (abs_nonneg _) hLabs 2 |>.trans_eq (by norm_num)
        have hp3 : |Real.log 2|^3 ≤ 1 := pow_le_pow_left₀ (abs_nonneg _) hLabs 3 |>.trans_eq (by norm_num)
        have h73 : |73*Real.log 2| ≤ 73 := by
          rw [abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 73)]
          nlinarith [hLabs]
        have h244 : |244*Real.log 2^2| ≤ 244 := by
          rw [abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 244), abs_pow]
          nlinarith [hp2]
        have h200 : |200*Real.log 2^3| ≤ 200 := by
          rw [abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 200), abs_pow]
          nlinarith [hp3]
        have a1 := abs_add_le (73*Real.log 2 - 244*Real.log 2^2) (200*Real.log 2^3)
        have a2 : |(73:ℝ)*Real.log 2 - 244*Real.log 2^2| ≤ |73*Real.log 2| + |244*Real.log 2^2| := by
          have h := abs_add_le (73*Real.log 2) (-(244*Real.log 2^2))
          rw [show (73:ℝ)*Real.log 2 + -(244*Real.log 2^2)
              = 73*Real.log 2 - 244*Real.log 2^2 by ring, abs_neg] at h
          exact h
        linarith [a1, a2, h73, h244, h200]
      have hc2 : |((73*Real.log 2 - 244*Real.log 2^2 + 200*Real.log 2^3)/8)*x^3| ≤ 70*x^3 := by
        rw [abs_mul, abs_of_nonneg (pow_nonneg hx0 3)]
        exact mul_le_mul_of_nonneg_right hc (pow_nonneg hx0 3)
      linarith [hA, hthird, hc2, hC3le, pow_nonneg hx0 3]
    have htm_lip : |tM (Real.log 2) (u - Real.log 2) x - tM (Real.log 2) (tq (Real.log 2) x) x|
        ≤ 500*(C3+70)*x^4 := by
      have h := tM_lipschitz (Real.log 2) (u - Real.log 2) (tq (Real.log 2) x) x
        log_two_ge_half log_two_le_one hδ_quarter hq_quarter hx0 hx1
      have hb : 500 * |(u - Real.log 2) - tq (Real.log 2) x| * x ≤ 500*(C3+70)*x^4 := by
        nlinarith [hδq, hx0, hx1, hC3le]
      linarith [h, hb]
    have hM_q_half : |tM (Real.log 2) (tq (Real.log 2) x) x| ≤ 3/4 := by
      have h := abs_add_le (tM (Real.log 2) (u - Real.log 2) x)
        (-(tM (Real.log 2) (u - Real.log 2) x - tM (Real.log 2) (tq (Real.log 2) x) x))
      rw [abs_neg] at h
      rw [show tM (Real.log 2) (u - Real.log 2) x
            + (-(tM (Real.log 2) (u - Real.log 2) x - tM (Real.log 2) (tq (Real.log 2) x) x))
            = tM (Real.log 2) (tq (Real.log 2) x) x by ring] at h
      linarith only [h, hM_d_half, htm_lip, hKDsm]
    have htg_lip : |tg (tM (Real.log 2) (u - Real.log 2) x) - tg (tM (Real.log 2) (tq (Real.log 2) x) x)|
        ≤ 3*(500*(C3+70)*x^4) := by
      have h1 := tg_lipschitz_wide (tM (Real.log 2) (u - Real.log 2) x)
        (tM (Real.log 2) (tq (Real.log 2) x) x)
        (by linarith only [hM_d_half]) (by linarith only [hM_q_half])
      have h2 : 3*|tM (Real.log 2) (u - Real.log 2) x - tM (Real.log 2) (tq (Real.log 2) x) x|
          ≤ 3*(500*(C3+70)*x^4) := by linarith only [htm_lip]
      linarith only [h1, h2]
    have hPf_eq : tM (Real.log 2) (tq (Real.log 2) x) x = tPfull (Real.log 2) x :=
      (tPfull_eq_tM _ _).symm
    have hPf_Pc : |tPfull (Real.log 2) x - tPc (Real.log 2) x| ≤
        ((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
          + (218802155/72) + (6244672907/768) + (52926162179/1536)) * x^4 :=
      tPfull_sub_tPc_le _ _ log_two_ge_half log_two_le_one hx0 hx1
    have hPc_half : |tPc (Real.log 2) x| ≤ 1 := by
      have h := abs_add_le (tPfull (Real.log 2) x) (-(tPfull (Real.log 2) x - tPc (Real.log 2) x))
      rw [abs_neg] at h
      rw [show tPfull (Real.log 2) x + (-(tPfull (Real.log 2) x - tPc (Real.log 2) x))
            = tPc (Real.log 2) x by ring] at h
      have hPfh : |tPfull (Real.log 2) x| ≤ 3/4 := by rw [← hPf_eq]; exact hM_q_half
      linarith only [h, hPfh, hPf_Pc, hK3sm]
    have htg_Pf : |tg (tPfull (Real.log 2) x) - tg (tPc (Real.log 2) x)|
        ≤ 3*(((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
          + (218802155/72) + (6244672907/768) + (52926162179/1536)) * x^4) := by
      have hPfh : |tPfull (Real.log 2) x| ≤ 1 := by rw [← hPf_eq]; linarith [hM_q_half]
      have := tg_lipschitz_wide _ _ hPfh hPc_half
      nlinarith [this, hPf_Pc]
    have htg_Pc_q : |tg (tPc (Real.log 2) x) - tq (Real.log 2) x| ≤
        ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216)
          + (188272301/6144) + (3386156375/12288)) * x^4 :=
      tg_tPc_sub_tq_le _ _ log_two_ge_half log_two_le_one hx0 hx1
    have hstepC : |tg (SFourth u n) - tq (Real.log 2) x|
        ≤ (3*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3))
           + 3*(500*(C3+70))
           + 3*((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
                + (218802155/72) + (6244672907/768) + (52926162179/1536))
           + ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216)
                + (188272301/6144) + (3386156375/12288))) * x^4 := by
      have hid : tg (SFourth u n) - tq (Real.log 2) x
          = ((tg (SFourth u n) - tg (tM (Real.log 2) (u - Real.log 2) x))
            + (tg (tM (Real.log 2) (u - Real.log 2) x) - tg (tM (Real.log 2) (tq (Real.log 2) x) x))
            + (tg (tM (Real.log 2) (tq (Real.log 2) x) x) - tg (tPfull (Real.log 2) x))
            + (tg (tPfull (Real.log 2) x) - tg (tPc (Real.log 2) x)))
            + (tg (tPc (Real.log 2) x) - tq (Real.log 2) x) := by ring
      rw [hid]
      have hmid : |tg (tM (Real.log 2) (tq (Real.log 2) x) x) - tg (tPfull (Real.log 2) x)| = 0 := by
        rw [hPf_eq, sub_self, abs_zero]
      have t1 := abs_add_le (tg (SFourth u n) - tg (tM (Real.log 2) (u - Real.log 2) x))
        (tg (tM (Real.log 2) (u - Real.log 2) x) - tg (tM (Real.log 2) (tq (Real.log 2) x) x))
      have t2 := abs_add_le (tg (SFourth u n) - tg (tM (Real.log 2) (u - Real.log 2) x)
          + (tg (tM (Real.log 2) (u - Real.log 2) x) - tg (tM (Real.log 2) (tq (Real.log 2) x) x)))
        (tg (tM (Real.log 2) (tq (Real.log 2) x) x) - tg (tPfull (Real.log 2) x))
      have t3 := abs_add_le (tg (SFourth u n) - tg (tM (Real.log 2) (u - Real.log 2) x)
          + (tg (tM (Real.log 2) (u - Real.log 2) x) - tg (tM (Real.log 2) (tq (Real.log 2) x) x))
          + (tg (tM (Real.log 2) (tq (Real.log 2) x) x) - tg (tPfull (Real.log 2) x)))
        (tg (tPfull (Real.log 2) x) - tg (tPc (Real.log 2) x))
      have t4 := abs_add_le (tg (SFourth u n) - tg (tM (Real.log 2) (u - Real.log 2) x)
          + (tg (tM (Real.log 2) (u - Real.log 2) x) - tg (tM (Real.log 2) (tq (Real.log 2) x) x))
          + (tg (tM (Real.log 2) (tq (Real.log 2) x) x) - tg (tPfull (Real.log 2) x))
          + (tg (tPfull (Real.log 2) x) - tg (tPc (Real.log 2) x)))
        (tg (tPc (Real.log 2) x) - tq (Real.log 2) x)
      nlinarith only [t4, t3, t2, t1, htg_model, htg_lip, htg_Pf, htg_Pc_q, hmid]
    -- Step B
    set r : ℝ := 1 - (Real.exp u - 1)⁻¹ - SFourth u n with hrdef
    have hr : |r| ≤ C0*x^4 := by
      have h := hn0 u hu1 hu2
      have hSval : SFourth u n = u/(2*(n:ℝ))*PhiS u
          + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) + EFourth u/((n:ℝ)^3) := by
        unfold SFourth D; ring
      have hthr' : Phi (u*(n:ℝ)) n = 1 := hthr
      have hrw : (1:ℝ) - ((Real.exp u - 1)⁻¹ + SFourth u n) = r := by rw [hrdef]; ring
      have h1 : C0 / (n:ℝ)^4 = C0 * x^4 := by rw [hx4, mul_one_div]
      calc |r| = |(1:ℝ) - ((Real.exp u - 1)⁻¹ + SFourth u n)| := by rw [hrw]
        _ = |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
              + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) + EFourth u/((n:ℝ)^3))| := by
              rw [hthr', hSval]
              congr 1
              ring
        _ ≤ C0/(n:ℝ)^4 := h
        _ = C0*x^4 := h1
    have hr_small : |r| ≤ 1/8 := by
      have hsmall : C0*x^4 ≤ 1/8 := by
        have hC0n : 8*C0 ≤ (n:ℝ) := by linarith [hMn, hC3le, hKA_nn, hKD_nn, hK3_nn]
        rw [hx4, mul_one_div]; rw [div_le_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^4)]
        nlinarith [hC0n, hn1, pow_pos hnR 4]
      linarith [hr, hsmall]
    have hden : (1:ℝ)/2 ≤ 1 - SFourth u n - r := by
      have h1 : |SFourth u n + r| ≤ 1/4 + 1/8 := by
        have := abs_add_le (SFourth u n) r; linarith [this, hS_quarter, hr_small]
      have h2 : SFourth u n + r ≤ 1/4 + 1/8 := le_trans (le_abs_self _) h1
      have h3 : (1:ℝ) - SFourth u n - r = 1 - (SFourth u n + r) := by ring
      linarith
    have hZne : 1 - SFourth u n - r ≠ 0 := by linarith [hden]
    have h1Sne : 1 - SFourth u n ≠ 0 := by
      have hlt : SFourth u n < 1 := by linarith [(abs_le.mp hS_quarter).2]
      intro hc
      have : (1:ℝ) = SFourth u n := sub_eq_zero.mp hc
      linarith
    have hZeq : (Real.exp u - 1)⁻¹ = 1 - SFourth u n - r := by rw [hrdef]; ring
    have hexpm1 : Real.exp u - 1 = (1 - SFourth u n - r)⁻¹ := by
      have h := (inv_inv (Real.exp u - 1)).symm
      rw [hZeq] at h
      exact h
    set t : ℝ := Real.exp u - 2 with htdef
    set tS : ℝ := SFourth u n/(1 - SFourth u n) with htSdef
    have ht : t = (SFourth u n + r)/(1 - SFourth u n - r) := by
      have hval : t = (Real.exp u - 1) - 1 := by rw [htdef]; ring
      rw [hval, hexpm1]
      rw [eq_div_iff hZne, sub_mul, inv_mul_cancel₀ hZne, one_mul]
      ring
    have ht_abs : |t| ≤ 2*(2*10^11 + C0)*x := by
      have h1 : |SFourth u n + r| ≤ (2*10^11 + C0)*x := by
        have h2 : |r| ≤ C0*x := by
          have hx4x : x^4 ≤ x := by nlinarith [hx0, hx1, sq_nonneg x, pow_nonneg hx0 3]
          nlinarith [hr, hx4x, hC0le, hx0]
        have := abs_add_le (SFourth u n) r; linarith [this, h2, hS_abs]
      have h2 : |1 - SFourth u n - r| ≥ 1/2 := by
        rw [abs_of_nonneg (by linarith [hden])]; exact hden
      have h3 : |t| = |SFourth u n + r| / |1 - SFourth u n - r| := by rw [ht, abs_div]
      rw [h3, div_le_iff₀ (by linarith [h2])]
      have hA : (0:ℝ) ≤ 2*(2*10^11 + C0)*x := by
        have hc : (0:ℝ) ≤ 2*10^11 + C0 := by linarith [hC0le]
        nlinarith [mul_nonneg hc hx0]
      have hb : (2*10^11 + C0)*x ≤ 2*(2*10^11 + C0)*x*|1 - SFourth u n - r| := by
        have hm := mul_le_mul_of_nonneg_left h2 hA
        nlinarith [hm]
      nlinarith [h1, hb]
    have ht_one : |t| ≤ 1 := by
      have hsmall : 2*(2*10^11 + C0)*x ≤ 1 := by
        rw [hx, mul_one_div, div_le_one hnR]; exact hKtn
      linarith [ht_abs, hsmall]
    have htu : Real.log (1 + t/2) = u - Real.log 2 := by
      rw [htdef]
      rw [show (1:ℝ) + (Real.exp u - 2)/2 = Real.exp u/2 by ring,
        Real.log_div (Real.exp_ne_zero u) (by norm_num : (2:ℝ) ≠ 0), Real.log_exp]
    have hA_bound : |(u - Real.log 2) - thh t| ≤ (2*(2*10^11 + C0))^4 * x^4 := by
      have h := log_thh_bound t ht_one
      rw [htu] at h
      have ht4 : |t|^4 ≤ (2*(2*10^11 + C0)*x)^4 :=
        pow_le_pow_left₀ (abs_nonneg t) ht_abs 4
      have he : (2*(2*10^11 + C0)*x)^4 = (2*(2*10^11 + C0))^4 * x^4 := by ring
      linarith [h, ht4, he]
    have htS_abs : |tS| ≤ 1 := by
      rw [htSdef, abs_div]
      rw [div_le_one (by positivity : (0:ℝ) < |1 - SFourth u n|)]
      have hSp : (0:ℝ) ≤ 1 - SFourth u n := by linarith [(abs_le.mp hS_quarter).2]
      rw [abs_of_nonneg hSp]
      linarith [(abs_le.mp hS_quarter).2]
    have htS_sub : t - tS = r/((1 - SFourth u n)*(1 - SFourth u n - r)) := by
      rw [ht, htSdef]
      field_simp [h1Sne, hZne]
      ring
    have hB1 : |thh t - thh tS| ≤ 4*|r| := by
      have h := thh_lipschitz t tS ht_one htS_abs
      have h2 : |t - tS| ≤ 4*|r| := by
        rw [htS_sub, abs_div, abs_mul]
        rw [div_le_iff₀ (by positivity : (0:ℝ) < |1-SFourth u n| * |1-SFourth u n-r|)]
        have h3 : |1 - SFourth u n| ≥ 3/4 := by
          have hSp : (0:ℝ) ≤ 1 - SFourth u n := by linarith [(abs_le.mp hS_quarter).2]
          rw [abs_of_nonneg hSp]; linarith [(abs_le.mp hS_quarter).2]
        have h4 : |1 - SFourth u n - r| ≥ 1/2 := by
          rw [abs_of_nonneg (by linarith [hden])]; exact hden
        have hd : (3/8:ℝ) ≤ |1 - SFourth u n| * |1 - SFourth u n - r| := by
          have hm := mul_le_mul h3 h4 (by norm_num : (0:ℝ) ≤ 1/2) (abs_nonneg (1 - SFourth u n))
          norm_num at hm
          exact hm
        nlinarith [hd, abs_nonneg r]
      linarith [h, h2]
    have hY1 : |SFourth u n + (SFourth u n)^2 + (SFourth u n)^3| ≤ 1 := by
      have h2 := abs_add_le (SFourth u n) ((SFourth u n)^2)
      have h3 : |(SFourth u n)^2| ≤ 1/16 := by
        rw [abs_pow]
        have hp := pow_le_pow_left₀ (abs_nonneg (SFourth u n)) hS_quarter 2
        norm_num at hp ⊢
        exact hp
      have h4 : |(SFourth u n)^3| ≤ 1/64 := by
        rw [abs_pow]
        have hp := pow_le_pow_left₀ (abs_nonneg (SFourth u n)) hS_quarter 3
        norm_num at hp ⊢
        exact hp
      have h5 := abs_add_le (SFourth u n + (SFourth u n)^2) ((SFourth u n)^3)
      linarith [h5, h2, h3, h4, hS_quarter]
    have hB2 : |thh tS - thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3)|
        ≤ 2*(2*10^11*x)^4 := by
      have h := thh_lipschitz tS (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3) htS_abs hY1
      have h2 : |tS - (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3)| ≤ 2*(2*10^11*x)^4 := by
        have he : tS - (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3)
            = (SFourth u n)^4/(1 - SFourth u n) := by
          rw [htSdef]
          rw [eq_div_iff h1Sne]
          field_simp [h1Sne]
          ring
        rw [he, abs_div, abs_pow]
        rw [div_le_iff₀ (by positivity : (0:ℝ) < |1 - SFourth u n|)]
        have h6 : |1 - SFourth u n| ≥ 3/4 := by
          have hSp : (0:ℝ) ≤ 1 - SFourth u n := by linarith [(abs_le.mp hS_quarter).2]
          rw [abs_of_nonneg hSp]; linarith [(abs_le.mp hS_quarter).2]
        have h7 : |SFourth u n|^4 ≤ (2*10^11*x)^4 :=
          pow_le_pow_left₀ (abs_nonneg _) hS_abs 4
        have hA : (0:ℝ) ≤ (2*10^11*x)^4 := by positivity
        nlinarith only [h7, h6, hA]
      linarith [h, h2]
    have hB3 : |thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3) - tg (SFourth u n)|
        ≤ (2*10^11*x)^4 := by
      have h := thh_sub_tg (SFourth u n) (by linarith [hS_quarter])
      have h8 : |SFourth u n|^4 ≤ (2*10^11*x)^4 :=
        pow_le_pow_left₀ (abs_nonneg _) hS_abs 4
      linarith [h, h8]
    have hB_bound : |thh t - tg (SFourth u n)| ≤ (4*C0 + 3*(2*10^11)^4) * x^4 := by
      have t1 := abs_add_le (thh t - thh tS) (thh tS - thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3))
      have t2 := abs_add_le (thh t - thh tS + (thh tS - thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3)))
        (thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3) - tg (SFourth u n))
      have hid : thh t - tg (SFourth u n) = (thh t - thh tS)
          + (thh tS - thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3))
          + (thh (SFourth u n + (SFourth u n)^2 + (SFourth u n)^3) - tg (SFourth u n)) := by ring
      rw [hid]
      have h4 : 4*|r| ≤ 4*C0*x^4 := by nlinarith [hr, hC0le]
      have h2b : (2*10^11*x)^4 = (2*10^11)^4 * x^4 := by ring
      rw [h2b] at hB2 hB3
      linarith [t2, t1, hB1, hB2, hB3, h4]
    have hfinal : |(u - Real.log 2) - tq (Real.log 2) x|
        ≤ ((2*(2*10^11 + C0))^4 + (4*C0 + 3*(2*10^11)^4)
          + (3*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3))
             + 3*(500*(C3+70))
             + 3*((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
                  + (218802155/72) + (6244672907/768) + (52926162179/1536))
             + ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216)
                  + (188272301/6144) + (3386156375/12288)))) * x^4 := by
      have hid : (u - Real.log 2) - tq (Real.log 2) x
          = ((u - Real.log 2) - thh t) + (thh t - tg (SFourth u n)) + (tg (SFourth u n) - tq (Real.log 2) x) := by ring
      rw [hid]
      have t1 := abs_add_le ((u - Real.log 2) - thh t + (thh t - tg (SFourth u n)))
        (tg (SFourth u n) - tq (Real.log 2) x)
      have t2 := abs_add_le ((u - Real.log 2) - thh t) (thh t - tg (SFourth u n))
      linarith [t1, t2, hA_bound, hB_bound, hstepC]
    have heq1 : u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))
          - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2
          - ((73*Real.log 2 - 244*Real.log 2^2 + 200*Real.log 2^3)/8)/(n:ℝ)^3
        = (u - Real.log 2) - tq (Real.log 2) x := by
      rw [hx]; unfold tq; field_simp; ring
    have heq2 : ((2*(2*10^11 + C0))^4 + (4*C0 + 3*(2*10^11)^4)
          + (3*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3))
             + 3*(500*(C3+70))
             + 3*((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
                  + (218802155/72) + (6244672907/768) + (52926162179/1536))
             + ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216)
                  + (188272301/6144) + (3386156375/12288)))) * x^4
        = ((2*(2*10^11 + C0))^4 + (4*C0 + 3*(2*10^11)^4)
          + (3*(10^16*(8+C3)^4/2 + 10^21*(8+C3)^2 + 10^21*(8+C3))
             + 3*(500*(C3+70))
             + 3*((269441/144) + (1186595/144) + (3824609/96) + (1997833177/10368)
                  + (218802155/72) + (6244672907/768) + (52926162179/1536))
             + ((96793/384) + (101263/96) + (111610351/20736) + (242170145/9216)
                  + (188272301/6144) + (3386156375/12288)))) / (n:ℝ)^4 := by
      rw [hx4]; ring
    rw [heq1, ← heq2]
    exact hfinal
