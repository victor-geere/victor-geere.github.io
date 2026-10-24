/-
  Op56/PhiFourth.lean — auxiliary layer toward the *fourth-order* geometrically-dominated
  asymptotics of `Phi_{un}(n) = Σ'_j (1 + (j+1)/n)^{-un}`.

  The third-order layer (`Op56/PhiThird.lean`) proves

      Phi_{un}(n) = (e^u − 1)^{-1} + (u/2n)·PhiS(u) + D(u)/n² + O(n^{-3}) ,

  with `D(u) = −(u/3)·PhiK3u(u) + (u²/8)·PhiK4u(u)`.  Writing `x = k/n`, `s = un`,
  `d = s(x − log(1+x))`, the next order comes from expanding `e^d` one step further:

  * `d = y − z + δ`, `y = uk²/(2n)`, `z = uk³/(3n²)`, and
    `δ = s·(x − log(1+x) − x²/2 + x³/3) = uk⁴/(4n³) + O(k⁵/n⁴)`;
  * `e^d = 1 + d + d²/2 + d³/6 + O(d⁴)`, and collecting powers of `1/n` up to `1/n³`
    yields the fourth-order model `1 + y − z + y²/2 + w` with

        w = −y·z + y³/6 + u·k⁴/(4n³)
          = −u²k⁵/(6n³) + u³k⁶/(48n³) + uk⁴/(4n³) .

  Hence the natural fourth-order coefficient is

      E(u) = (u/4)·PhiK4u(u) − (u²/6)·PhiK5u(u) + (u³/48)·PhiK6u(u) ,

  with `PhiK5u = Σ k⁵e^{−uk}` and `PhiK6u = Σ k⁶e^{−uk}`.

  This file lands the auxiliary layer (`EFourth` and its moment inputs, plus the two sharpened
  one-order-higher Taylor remainders), the **termwise fourth-order bound `phi_term_sharp4`**,
  its summed form `phi_err_sum_le4` (rate `n^{-4}`), the `k⁸` moment majorant
  `tsum_pow8_exp_neg_half_le` (`Σ k⁸ e^{−uk/2} ≤ 10¹²`), the finite/tail split
  (`phi_finite_part_le4`, `phi_tail_sum_le4`), the auxiliary estimate `Phi_fourth_order_aux`
  and the full **`Phi_fourth_order`**.  The threshold layer (`SFourth`,
  `threshold_fourth_order_uniform`) is not yet mirrored.

  The closed forms at `u = log 2` are `Σ k⁵2^{−k} = 1082` and `Σ k⁶2^{−k} = 9366`
  (the values `541` and `4683` quoted in the task are exactly one half of these and are
  **not** the moment sums — verified numerically and by the Stirling-number formula).

  This file carries 0 `sorry`.
-/
import Op56.PhiThird

namespace Op56

noncomputable section

open scoped BigOperators Topology

set_option maxHeartbeats 2000000

/-! ### The fifth and sixth moment sums -/

/-- `PhiK5u u = Σ'_k k⁵ e^{-uk}`. -/
noncomputable def PhiK5u (u : ℝ) : ℝ := ∑' k : ℕ, (k : ℝ) ^ 5 * Real.exp (-(u * (k : ℝ)))

/-- `PhiK6u u = Σ'_k k⁶ e^{-uk}`. -/
noncomputable def PhiK6u (u : ℝ) : ℝ := ∑' k : ℕ, (k : ℝ) ^ 6 * Real.exp (-(u * (k : ℝ)))

lemma summable_PhiK5u (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k : ℕ => (k : ℝ) ^ 5 * Real.exp (-(u * (k : ℝ)))) :=
  summable_exp_neg_u u hu 5

lemma summable_PhiK6u (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k : ℕ => (k : ℝ) ^ 6 * Real.exp (-(u * (k : ℝ)))) :=
  summable_exp_neg_u u hu 6

/-- The fifth moment of the geometric reference: `Σ k⁵2^{-k} = 1082`.  (Eulerian number
identity `Σ_{k≥0} k⁵x^k = (x+26x²+66x³+26x⁴+x⁵)/(1−x)⁶` at `x = 1/2`; note the task's
quoted `541` is half of this and is not the moment sum.) -/
lemma tsum_five_half : (∑' k : ℕ, (k : ℝ) ^ 5 * (1/2 : ℝ) ^ k) = 1082 := by
  have hx : ‖(1/2 : ℝ)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  rw [tsum_pow_mul_geometric_of_norm_lt_one 5 hx]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond,
    Nat.factorial, Nat.cast_one, Nat.cast_zero]
  norm_num

/-- The sixth moment of the geometric reference: `Σ k⁶2^{-k} = 9366`.  (The task's quoted
`4683` is half of this.) -/
lemma tsum_six_half : (∑' k : ℕ, (k : ℝ) ^ 6 * (1/2 : ℝ) ^ k) = 9366 := by
  have hx : ‖(1/2 : ℝ)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (by norm_num)]; norm_num
  rw [tsum_pow_mul_geometric_of_norm_lt_one 6 hx]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond,
    Nat.factorial, Nat.cast_one, Nat.cast_zero]
  norm_num

/-- The standard rewriting `e^{-(log 2)·k} = (1/2)^k`. -/
lemma exp_neg_log_two_mul (k : ℕ) :
    Real.exp (-(Real.log 2 * (k : ℝ))) = (1/2 : ℝ) ^ k := by
  rw [show -(Real.log 2 * (k : ℝ)) = (k : ℝ) * (-(Real.log 2)) by ring,
    Real.exp_nat_mul]
  rw [show Real.exp (-(Real.log 2)) = (1/2 : ℝ) by
    rw [Real.exp_neg, Real.exp_log (by norm_num : (0 : ℝ) < 2)]; norm_num]

lemma PhiK5u_log_two : PhiK5u (Real.log 2) = 1082 := by
  rw [PhiK5u]
  have hfun : (fun k : ℕ => (k : ℝ) ^ 5 * Real.exp (-(Real.log 2 * (k : ℝ))))
      = (fun k : ℕ => (k : ℝ) ^ 5 * (1/2 : ℝ) ^ k) := by
    funext k; rw [exp_neg_log_two_mul]
  rw [hfun, tsum_five_half]

lemma PhiK6u_log_two : PhiK6u (Real.log 2) = 9366 := by
  rw [PhiK6u]
  have hfun : (fun k : ℕ => (k : ℝ) ^ 6 * Real.exp (-(Real.log 2 * (k : ℝ))))
      = (fun k : ℕ => (k : ℝ) ^ 6 * (1/2 : ℝ) ^ k) := by
    funext k; rw [exp_neg_log_two_mul]
  rw [hfun, tsum_six_half]

/-- Uniform bound `PhiK5u u ≤ 4·10¹⁰ + 5` for `u ≥ 1/2`, from the sixth-moment majorant
`k⁵ ≤ k⁶` (`k ≥ 1`) and `tsum_pow_le_six_exp_neg_half_le` at the half-decay weight. -/
lemma PhiK5u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK5u u ≤ 4*10^10 + 5 := by
  rw [PhiK5u]
  have hle : ∀ k : ℕ, (k : ℝ) ^ 5 * Real.exp (-(u * (k : ℝ)))
      ≤ (k : ℝ) ^ 6 * Real.exp (-(u * (k : ℝ)) / 2) := by
    intro k
    rcases Nat.eq_zero_or_pos k with hk0 | hk
    · subst hk0; simp
    · have hk1 : (1 : ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
      have h1 : (k : ℝ) ^ 5 ≤ (k : ℝ) ^ 6 :=
        pow_le_pow_right₀ hk1 (by norm_num : 5 ≤ 6)
      have h2 : Real.exp (-(u * (k : ℝ))) ≤ Real.exp (-(u * (k : ℝ)) / 2) := by
        apply Real.exp_le_exp.mpr
        have hu0 : (0 : ℝ) ≤ u := by linarith
        have hk0 : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
        nlinarith [hu0, hk0]
      exact mul_le_mul h1 h2 (by positivity) (by positivity)
  exact le_trans (Summable.tsum_le_tsum hle
    (summable_exp_neg_u u hu 5) (summable_pow6_exp_half u hu))
    (tsum_pow_le_six_exp_neg_half_le u hu 6 (le_refl 6))

/-- Uniform bound `PhiK6u u ≤ 4·10¹⁰ + 5` for `u ≥ 1/2`. -/
lemma PhiK6u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK6u u ≤ 4*10^10 + 5 := by
  rw [PhiK6u]
  have hle : ∀ k : ℕ, (k : ℝ) ^ 6 * Real.exp (-(u * (k : ℝ)))
      ≤ (k : ℝ) ^ 6 * Real.exp (-(u * (k : ℝ)) / 2) := by
    intro k
    have h2 : Real.exp (-(u * (k : ℝ))) ≤ Real.exp (-(u * (k : ℝ)) / 2) := by
      apply Real.exp_le_exp.mpr
      have hu0 : (0 : ℝ) ≤ u := by linarith
      have hk0 : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
      nlinarith [hu0, hk0]
    exact mul_le_mul_of_nonneg_left h2 (by positivity)
  exact le_trans (Summable.tsum_le_tsum hle
    (summable_exp_neg_u u hu 6) (summable_pow6_exp_half u hu))
    (tsum_pow_le_six_exp_neg_half_le u hu 6 (le_refl 6))

/-! ### The fourth-order coefficient `E(u)` -/

/-- The fourth-order coefficient
`E(u) = (u/4)·PhiK4u(u) − (u²/6)·PhiK5u(u) + (u³/48)·PhiK6u(u)`.

Comes from collecting `e^d = 1 + d + d²/2 + d³/6 + …` at order `n^{-3}`, with
`d = s(x − log(1+x))`, `x = k/n`: the `n^{-3}` coefficients are `u·k⁴/4` (from `d`),
`−u²k⁵/6` (from `−yz`, i.e. `(y−z)²/2`) and `u³k⁶/48` (from `y³/6`). -/
noncomputable def EFourth (u : ℝ) : ℝ :=
  (u/4)*PhiK4u u - (u^2/6)*PhiK5u u + (u^3/48)*PhiK6u u

lemma EFourth_log_two :
    EFourth (Real.log 2) = 150*(Real.log 2)/4 - 1082*(Real.log 2)^2/6
      + 9366*(Real.log 2)^3/48 := by
  rw [EFourth, PhiK4u_log_two, PhiK5u_log_two, PhiK6u_log_two]
  ring

/-! ### Sharpened one-order-higher Taylor remainders -/

/-- **Quintic upper bound for `log(1+x)`.**  For `x ≥ 0`,
`log(1+x) ≤ x − x²/2 + x³/3 − x⁴/4 + x⁵/5`.

The function `G(x) = x⁵/5 − (log(1+x) − x + x²/2 − x³/3 + x⁴/4)` has `G(0) = 0` and
`G'(x) = x⁵/(1+x) ≥ 0`, so it is monotone.  This is the one-order-higher companion of
`log_one_add_ge_quartic`. -/
lemma log_one_add_le_quintic (x : ℝ) (hx : 0 ≤ x) :
    Real.log (1 + x) ≤ x - (1/2)*x^2 + (1/3)*x^3 - (1/4)*x^4 + (1/5)*x^5 := by
  set G : ℝ → ℝ := fun t => (1/5)*t^5 - (Real.log (1+t) - t + (1/2)*t^2 - (1/3)*t^3 + (1/4)*t^4)
    with hG
  have hcont : ContinuousOn G (Set.Ici 0) := by
    rw [hG]
    apply ContinuousOn.sub
    · fun_prop
    · apply ContinuousOn.add
      · apply ContinuousOn.sub
        · apply ContinuousOn.add
          · apply ContinuousOn.sub
            · exact ContinuousOn.log ((continuous_const.add continuous_id).continuousOn)
                (fun t ht => ne_of_gt (by simp only [Set.mem_Ici] at ht; linarith : (0:ℝ) < 1 + t))
            · fun_prop
          · fun_prop
        · fun_prop
      · fun_prop
  have hdiff : DifferentiableOn ℝ G (interior (Set.Ici 0)) := by
    rw [hG]
    apply DifferentiableOn.sub
    · fun_prop
    · apply DifferentiableOn.add
      · apply DifferentiableOn.sub
        · apply DifferentiableOn.add
          · apply DifferentiableOn.sub
            · refine DifferentiableOn.log ?_ ?_
              · exact ((differentiable_const 1).add differentiable_id).differentiableOn
              · intro t ht
                rw [interior_Ici] at ht
                exact ne_of_gt (by linarith [Set.mem_Ioi.mp ht] : (0:ℝ) < 1 + t)
            · fun_prop
          · fun_prop
        · fun_prop
      · fun_prop
  have hderiv : ∀ y ∈ interior (Set.Ici 0), deriv G y = y^5/(1+y) := by
    intro y hy
    rw [interior_Ici] at hy
    have hy0 : (0:ℝ) < y := hy
    have h1y : (1:ℝ) + y ≠ 0 := by positivity
    rw [hG]
    have hpoly : HasDerivAt (fun t : ℝ => (1/5)*t^5 + t - (1/2)*t^2 + (1/3)*t^3 - (1/4)*t^4)
        (y^4 + 1 - y + y^2 - y^3) y := by
      have h1 : HasDerivAt (fun t : ℝ => (1/5)*t^5) (y^4) y := by
        have h := (hasDerivAt_id y).pow 5 |>.const_mul ((1:ℝ)/5)
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
      have h4 : HasDerivAt (fun t : ℝ => (1/4)*t^4) (y^3) y := by
        have h := (hasDerivAt_id y).pow 4 |>.const_mul ((1:ℝ)/4)
        convert h using 1
        · funext s; rw [Pi.pow_apply, id_eq]
        · simp only [id_eq]; push_cast; ring
      have hA : HasDerivAt (fun t : ℝ => (1/5)*t^5 + t) (y^4 + 1) y :=
        h1.add (hasDerivAt_id y)
      have hB : HasDerivAt (fun t : ℝ => -(1/2)*t^2 + (1/3)*t^3 - (1/4)*t^4)
          (-y + y^2 - y^3) y := by
        have h2' : HasDerivAt (fun t : ℝ => -(1/2)*t^2) (-y) y := by
          have h := (hasDerivAt_id y).pow 2 |>.const_mul (-(1:ℝ)/2)
          convert h using 1
          · funext s; rw [Pi.pow_apply, id_eq]; ring
          · simp only [id_eq]; ring
        have h34 : HasDerivAt (fun t : ℝ => (1/3)*t^3 - (1/4)*t^4) (y^2 - y^3) y := by
          have h := h3.sub h4
          convert h using 1
        have h := h2'.add h34
        convert h using 1
        · funext s; simp only [Pi.add_apply]; ring
        · ring
      have hC := hA.add hB
      convert hC using 1
      · funext s; simp only [Pi.add_apply]; ring
      · ring
    have hlog := (Real.hasDerivAt_log h1y).comp y (by simpa using (hasDerivAt_id y).const_add 1 :
      HasDerivAt (fun t : ℝ => 1 + t) 1 y)
    have hD := hpoly.sub hlog
    have hfun : (fun t : ℝ => (1/5)*t^5 + t - (1/2)*t^2 + (1/3)*t^3 - (1/4)*t^4)
        - (Real.log ∘ HAdd.hAdd 1)
        = fun t : ℝ => (1/5)*t^5 - (Real.log (1+t) - t + (1/2)*t^2 - (1/3)*t^3 + (1/4)*t^4) := by
      funext s; simp only [Pi.sub_apply, Function.comp_apply]; ring
    rw [hfun] at hD
    rw [hD.deriv]
    rw [show (y^4 + 1 - y + y^2 - y^3) - (1+y)⁻¹ * 1 = y^5/(1+y) by field_simp; ring]
  have hmono : MonotoneOn G (Set.Ici 0) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hdiff
    intro y hy
    rw [hderiv y hy]
    rw [interior_Ici] at hy
    have hy0 : (0:ℝ) < y := hy
    exact div_nonneg (pow_nonneg (le_of_lt hy0) 5) (by linarith)
  have h := hmono (by simp : (0:ℝ) ∈ Set.Ici 0) hx hx
  have h0 : G 0 = 0 := by
    rw [hG]; norm_num
  rw [h0] at h
  rw [hG] at h
  linarith [h]

/-- **The `x⁵` remainder of `x − log(1+x)`.**
For `x ≥ 0`, `|x − log(1+x) − x²/2 + x³/3 − x⁴/4| ≤ x⁵/5`.

The upper bound `≤ 0` is `log_one_add_ge_quartic`; the lower bound `≥ −x⁵/5` is the
quintic bound `log_one_add_le_quintic`.  This is the one-order-higher sharpening of
`phi_r4_bounds` that the fourth-order termwise estimate requires. -/
lemma phi_r5_bounds (x : ℝ) (hx0 : 0 ≤ x) :
    |x - Real.log (1 + x) - x^2/2 + x^3/3 - x^4/4| ≤ x^5/5 := by
  have hge := log_one_add_ge_quartic x hx0
  have hle := log_one_add_le_quintic x hx0
  have hupper : x - Real.log (1 + x) - x^2/2 + x^3/3 - x^4/4 ≤ 0 := by
    linarith [hge]
  have hlower : -(x^5/5) ≤ x - Real.log (1 + x) - x^2/2 + x^3/3 - x^4/4 := by
    linarith [hle]
  rw [abs_le]
  constructor
  · linarith [hlower]
  · linarith [hupper]

/-- **Quartic exponential remainder.**  For `|d| ≤ 1/2`,
`|exp d − 1 − d − d²/2 − d³/6| ≤ |d|⁴`.

This is the one-order-higher companion of `exp_rem_cube`: `Real.exp_bound` at `n = 5`
controls the `d⁴` Taylor tail, and `|d| ≤ 1/2` absorbs the `d⁴/24` term. -/
lemma exp_rem_quartic (d : ℝ) (hd : |d| ≤ 1/2) :
    |Real.exp d - 1 - d - d^2/2 - d^3/6| ≤ |d|^4 := by
  have hd1 : |d| ≤ 1 := by linarith
  have h5 := Real.exp_bound (x := d) hd1 (n := 5) (by norm_num)
  have hsum : (∑ m ∈ Finset.range 5, d^m / (↑m.factorial : ℝ))
      = 1 + d + d^2/2 + d^3/6 + d^4/24 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]
    norm_num
  rw [hsum] at h5
  have hd0 : (0:ℝ) ≤ |d| := abs_nonneg d
  have hrem : |d|^5 * (6 / (Nat.factorial 5 * (5:ℝ))) ≤ |d|^4 / 23 := by
    have hf : (Nat.factorial 5 : ℝ) = 120 := by norm_num [Nat.factorial]
    rw [hf]
    have heq : |d|^5 * (6 / (120 * 5)) = |d|^4 * (|d| * (6/600)) := by ring
    rw [heq]
    have hb : |d| * (6/600) ≤ 1/23 := by nlinarith [hd, hd0]
    nlinarith [pow_nonneg hd0 4]
  have hsplit : Real.exp d - 1 - d - d^2/2 - d^3/6
      = (Real.exp d - (1 + d + d^2/2 + d^3/6 + d^4/24)) + d^4/24 := by ring
  rw [hsplit]
  set R : ℝ := Real.exp d - (1 + d + d^2/2 + d^3/6 + d^4/24) with hR
  have hRe : |R| ≤ |d|^5 * (6 / (Nat.factorial 5 * (5:ℝ))) := by
    rw [hR]
    convert h5 using 3
  have h24 : |d^4/24| ≤ |d|^4 / 12 := by
    rw [abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 24), abs_pow]
    have h4 : (0:ℝ) ≤ |d|^4 := pow_nonneg hd0 4
    rw [div_le_div_iff₀ (by norm_num : (0:ℝ) < 24) (by norm_num : (0:ℝ) < 12)]
    nlinarith [h4]
  calc |R + d^4/24| ≤ |R| + |d^4/24| := abs_add_le _ _
    _ ≤ |d|^4/23 + |d|^4/12 := by linarith [hRe, hrem, h24]
    _ ≤ |d|^4 := by
        have h4 : (0:ℝ) ≤ |d|^4 := pow_nonneg hd0 4
        nlinarith [h4]

/-! ### The exact fourth-order termwise decomposition

With `b = y − z`, `d = b + δ` and the moment model
`M = 1 + y − z + y²/2 − y·z + y³/6` (`= 1 + b + b²/2 + b³/6` **minus** the
`O(n^{-4})` correction `z²/2 − y²z/2 + yz²/2 − z³/6`), the identity below splits
`e^d − M` into exactly the pieces that the termwise fourth-order bound must control. -/

/-- **Fourth-order `e^d` decomposition.**  For `b = y − z` and `d = b + δ`,

    e^d − (1 + y − z + y²/2 − y·z + y³/6)
      = R + b·δ + δ²/2 + b²·δ/2 + b·δ²/2 + δ³/6
          + (z²/2 − y²z/2 + yz²/2 − z³/6) + δ ,

where `R = e^d − 1 − d − d²/2 − d³/6` (`exp_rem_quartic`).  Under `4k² ≤ n` every
term on the right is `O(k⁸/n⁴)` or smaller: `R = O(|d|⁴)`, `δ = O(k⁴/n³)`,
`b = O(k²/n)`, `y = O(k²/n)`, `z = O(k³/n²)`. -/
lemma exp_fourth_decomp (y z δ : ℝ) :
    Real.exp ((y - z) + δ) - (1 + y - z + y^2/2 - y*z + y^3/6)
      = (Real.exp ((y - z) + δ) - 1 - ((y - z) + δ) - ((y - z) + δ)^2/2
            - ((y - z) + δ)^3/6)
        + ((y - z)*δ + δ^2/2 + (y - z)^2*δ/2 + (y - z)*δ^2/2 + δ^3/6)
        + (z^2/2 - y^2*z/2 + y*z^2/2 - z^3/6) + δ := by
  ring

/-! ### The termwise fourth-order bound and its auxiliary budget lemmas -/

/-! ### Fourth-order termwise pieces -/

/-- Sharp fourth-order `δ` bound: `|un·A| ≤ u k⁴/(2n³)`, `A = x − log(1+x) − x²/2 + x³/3`. -/
lemma phi_delta_bound4 (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)|
      ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; linarith [hkn, hkR]
  have hAle := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).2
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  have hδ0 : (0:ℝ) ≤ (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := mul_nonneg (by positivity) hA0
  rw [abs_of_nonneg hδ0]
  have h2 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) = u*(k:ℝ)^4/(2*(n:ℝ)^3) := by field_simp
  calc (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)
      ≤ (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^4/2) :=
        mul_le_mul_of_nonneg_left hAle (by positivity)
    _ = u*(k:ℝ)^4/(2*(n:ℝ)^3) := h2

/-- Sharp fourth-order `sA` bound: `|un·(A − x⁴/4)| ≤ u k⁵/(5n⁴)`. -/
lemma phi_sA_bound5 (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
        - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3 - ((k:ℝ)/(n:ℝ))^4/4)|
      ≤ u*(k:ℝ)^5/(5*(n:ℝ)^4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hb := phi_r5_bounds ((k:ℝ)/(n:ℝ)) hx0
  have h := mul_le_mul_of_nonneg_left hb (by positivity : (0:ℝ) ≤ u*(n:ℝ))
  have habs : |(u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3 - ((k:ℝ)/(n:ℝ))^4/4)|
      = (u*(n:ℝ)) * |(k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3 - ((k:ℝ)/(n:ℝ))^4/4| := by
    rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ u*(n:ℝ))]
  rw [habs]
  have h2 : (u*(n:ℝ)) * (((k:ℝ)/(n:ℝ))^5/5) = u*(k:ℝ)^5/(5*(n:ℝ)^4) := by field_simp
  linarith [h, h2]

/-- **Monomial budget.**  If `0 ≤ u ≤ 1`, `k ≥ 1`, `n > 0`, `1 ≤ a`, `1 ≤ c`, `p ≤ 8`,
`4 ≤ q`, then `u^a k^p / (c n^q) ≤ u k^8 / n^4`, provided `n^4 ≤ c n^q`. -/
lemma phi_budget_mono {u k n : ℝ} (hu0 : 0 ≤ u) (hu1 : u ≤ 1) (hk1 : 1 ≤ k) (hn0 : 0 < n)
    {a c p q : ℕ} (ha : 1 ≤ a) (hc : 1 ≤ c) (hp : p ≤ 8)
    (hkey : n^4 ≤ (c:ℝ) * n^q) :
    u^a * k^p / ((c:ℝ) * n^q) ≤ u * k^8 / n^4 := by
  have huap : u^a ≤ u := by
    have h := pow_le_pow_of_le_one hu0 hu1 ha
    simpa using h
  have hkp : k^p ≤ k^8 := pow_le_pow_right₀ hk1 hp
  have hku : u^a * k^p ≤ u * k^8 :=
    mul_le_mul huap hkp (by positivity) hu0
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < (c:ℝ) * n^q) (by positivity : (0:ℝ) < n^4)]
  calc u^a * k^p * n^4 ≤ u * k^8 * n^4 := mul_le_mul_of_nonneg_right hku (by positivity)
    _ ≤ u * k^8 * ((c:ℝ) * n^q) := mul_le_mul_of_nonneg_left hkey (by positivity)

/-- **Abstract fourth-order triangle assembly.** -/
lemma phi_fourth_sum_bound (b δ y z sA R Q : ℝ)
    (hR : |R| ≤ Q) (hbδ : |b*δ| ≤ Q) (hδ2 : |δ^2/2| ≤ Q)
    (hb2δ : |b^2*δ/2| ≤ Q) (hbδ2 : |b*δ^2/2| ≤ Q) (hδ3 : |δ^3/6| ≤ Q)
    (hz2 : |z^2/2| ≤ Q) (hy2z : |y^2*z/2| ≤ Q) (hyz2 : |y*z^2/2| ≤ Q)
    (hz3 : |z^3/6| ≤ Q) (hsA : |sA| ≤ Q) :
    |R + (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6)
        + (z^2/2 - y^2*z/2 + y*z^2/2 - z^3/6) + sA| ≤ 11*Q := by
  have hy2z' : |(-(y^2*z/2))| ≤ Q := by rw [abs_neg]; exact hy2z
  have hz3' : |(-(z^3/6))| ≤ Q := by rw [abs_neg]; exact hz3
  have hB : |b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6| ≤ 5*Q := by
    have h2 : |b*δ + δ^2/2| ≤ 2*Q := by
      have := abs_add_le (b*δ) (δ^2/2); linarith
    have h3 : |b*δ + δ^2/2 + b^2*δ/2| ≤ 3*Q := by
      have := abs_add_le (b*δ + δ^2/2) (b^2*δ/2); linarith
    have h4 : |b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2| ≤ 4*Q := by
      have := abs_add_le (b*δ + δ^2/2 + b^2*δ/2) (b*δ^2/2); linarith
    have h5 : |b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6| ≤ 5*Q := by
      have := abs_add_le (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2) (δ^3/6); linarith
    exact h5
  have hZ : |z^2/2 + -(y^2*z/2) + y*z^2/2 + -(z^3/6)| ≤ 4*Q := by
    have h2 : |z^2/2 + -(y^2*z/2)| ≤ 2*Q := by
      have := abs_add_le (z^2/2) (-(y^2*z/2)); linarith [hy2z']
    have h3 : |z^2/2 + -(y^2*z/2) + y*z^2/2| ≤ 3*Q := by
      have := abs_add_le (z^2/2 + -(y^2*z/2)) (y*z^2/2); linarith
    have h4 : |z^2/2 + -(y^2*z/2) + y*z^2/2 + -(z^3/6)| ≤ 4*Q := by
      have := abs_add_le (z^2/2 + -(y^2*z/2) + y*z^2/2) (-(z^3/6)); linarith [hz3']
    exact h4
  have h1 : |R + (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6)| ≤ 6*Q := by
    have := abs_add_le R (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6); linarith
  have h2 : |R + (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6)
      + (z^2/2 + -(y^2*z/2) + y*z^2/2 + -(z^3/6))| ≤ 10*Q := by
    have := abs_add_le (R + (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6))
      (z^2/2 + -(y^2*z/2) + y*z^2/2 + -(z^3/6)); linarith
  have h3 : |R + (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6)
      + (z^2/2 + -(y^2*z/2) + y*z^2/2 + -(z^3/6)) + sA| ≤ 11*Q := by
    have := abs_add_le (R + (b*δ + δ^2/2 + b^2*δ/2 + b*δ^2/2 + δ^3/6)
      + (z^2/2 + -(y^2*z/2) + y*z^2/2 + -(z^3/6))) sA; linarith
  simpa only [sub_eq_add_neg] using h3

/-- **Fourth-order `e^d` decomposition with the `u k⁴/(4n³)` term absorbed into the model.** -/
lemma exp_fourth_decomp_target (y z δ sA c : ℝ) (hc : δ = sA + c) :
    Real.exp ((y - z) + δ) - (1 + y - z + y^2/2 - y*z + y^3/6 + c)
      = (Real.exp ((y - z) + δ) - 1 - ((y - z) + δ) - ((y - z) + δ)^2/2
            - ((y - z) + δ)^3/6)
        + ((y - z)*δ + δ^2/2 + (y - z)^2*δ/2 + (y - z)*δ^2/2 + δ^3/6)
        + (z^2/2 - y^2*z/2 + y*z^2/2 - z^3/6) + sA := by
  subst hc
  ring

/-- **Termwise fourth-order bound.**  For `4k² ≤ n`, `u ∈ [1/2,1]`,

    |T_k − G_k(1 + y − z + y²/2 + w)| ≤ 11·u·e^{−uk/2}·k⁸/n⁴,

where `T_k = (1+k/n)^{-un}`, `G_k = e^{−uk}`, `y = uk²/(2n)`, `z = uk³/(3n²)` and
`w = −yz + y³/6 + u k⁴/(4n³)`. -/
lemma phi_term_sharp4 (u : ℝ) (n k : ℕ)
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
          - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
          + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
              + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))|
      ≤ 11 * u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^8/(n:ℝ)^4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn0 : (0:ℝ) ≤ (n:ℝ) := by positivity
  have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by linarith
  have hkR : (0:ℝ) < (k:ℝ) := by exact_mod_cast (by omega : 0 < k)
  have hk1R : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hk4R : 4*(k:ℝ)^2 ≤ (n:ℝ) := by exact_mod_cast hk4
  have hkk : (k:ℝ) ≤ (k:ℝ)^2 := by nlinarith [hk1R]
  have hkn : 4*(k:ℝ) ≤ (n:ℝ) := by linarith [hk4R, hkk]
  have hx0 : (0:ℝ) ≤ (k:ℝ)/(n:ℝ) := by positivity
  have hx1 : (k:ℝ)/(n:ℝ) ≤ 1 := by rw [div_le_one hnR]; linarith [hkn, hkR]
  have hA0 := (phi_r4_bounds ((k:ℝ)/(n:ℝ)) hx0 hx1).1
  have hkey : ∀ c q : ℕ, 1 ≤ c → 4 ≤ q → (n:ℝ)^4 ≤ (c:ℝ) * (n:ℝ)^q := by
    intro c q hc hq
    have h1 : (n:ℝ)^4 ≤ (n:ℝ)^q := pow_le_pow_right₀ hn1 hq
    have hc1 : (1:ℝ) ≤ (c:ℝ) := by exact_mod_cast hc
    calc (n:ℝ)^4 ≤ (n:ℝ)^q := h1
      _ = 1 * (n:ℝ)^q := by ring
      _ ≤ (c:ℝ) * (n:ℝ)^q := mul_le_mul_of_nonneg_right hc1 (by positivity)
  set y : ℝ := u*(k:ℝ)^2/(2*(n:ℝ)) with hy
  set z : ℝ := u*(k:ℝ)^3/(3*(n:ℝ)^2) with hz
  set A4 : ℝ := (k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
      - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3 with hA4
  set δ : ℝ := (u*(n:ℝ)) * A4 with hδ
  set sA : ℝ := (u*(n:ℝ)) * (A4 - ((k:ℝ)/(n:ℝ))^4/4) with hsA
  set d : ℝ := y - z + δ with hd
  set Q : ℝ := u * (k:ℝ)^8/(n:ℝ)^4 with hQ
  have hy0 : 0 ≤ y := by rw [hy]; positivity
  have hz0 : 0 ≤ z := by rw [hz]; positivity
  have hδ0 : 0 ≤ δ := by rw [hδ, hA4]; exact mul_nonneg (by positivity) hA0
  have hδub : δ ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by
    rw [hδ, hA4]
    exact (abs_le.mp (phi_delta_bound4 u n k hu1 hu2 hn hk hk4)).2
  have hδub0 : 0 ≤ u*(k:ℝ)^4/(2*(n:ℝ)^3) := by positivity
  have hyz0 : 0 ≤ y - z := by
    have h2k3n : 2*(k:ℝ) ≤ 3*(n:ℝ) := by linarith [hkn, hnR]
    have hle : z ≤ y := by
      have he : z = y * (2*(k:ℝ)/(3*(n:ℝ))) := by rw [hy, hz]; ring_nf
      rw [he]
      have hf : 2*(k:ℝ)/(3*(n:ℝ)) ≤ 1 := by
        rw [div_le_one (by positivity : (0:ℝ) < 3*(n:ℝ))]; linarith
      simpa using mul_le_mul_of_nonneg_left hf hy0
    linarith
  have hds : d = u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
      + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
          - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3) := by
    rw [hd, hy, hz, hδ, hA4]
  have hdb : |d| ≤ 1/2 := by rw [hds]; exact phi_delta_bound u n k hu1 hu2 hn hk hk4
  have hdub : |d| ≤ (59/96)*u*((k:ℝ)^2/(n:ℝ)) := by
    rw [hds]; exact phi_delta_abs_bound u n k hu1 hu2 hn hk hk4
  -- Piece R
  have hR : |Real.exp d - 1 - d - d^2/2 - d^3/6| ≤ Q := by
    have h1 := exp_rem_quartic d hdb
    have h2 : |d|^4 ≤ Q := by
      calc |d|^4 ≤ ((59/96)*u*((k:ℝ)^2/(n:ℝ)))^4 :=
            pow_le_pow_left₀ (abs_nonneg d) hdub 4
        _ = (59/96)^4 * (u^4 * ((k:ℝ)^8/(n:ℝ)^4)) := by ring_nf
        _ ≤ Q := by
            rw [hQ]
            have hu4 : u^4 ≤ u := by
              have h := pow_le_pow_of_le_one hu0 hu2 (by norm_num : 1 ≤ 4)
              simpa using h
            have hX : (0:ℝ) ≤ (k:ℝ)^8/(n:ℝ)^4 := by positivity
            calc (59/96:ℝ)^4 * (u^4 * ((k:ℝ)^8/(n:ℝ)^4))
                ≤ 1 * (u * ((k:ℝ)^8/(n:ℝ)^4)) := by
                  apply mul_le_mul (by norm_num : (59/96:ℝ)^4 ≤ 1) _ (by positivity) (by norm_num)
                  exact mul_le_mul_of_nonneg_right hu4 hX
              _ = u * (k:ℝ)^8 / (n:ℝ)^4 := by ring
    linarith [h1, h2]
  -- Piece b,delta
  have hB : |(y - z)*δ| ≤ Q := by
    rw [abs_of_nonneg (mul_nonneg hyz0 hδ0)]
    have h1 : (y - z)*δ ≤ y*δ := mul_le_mul_of_nonneg_right (by linarith) hδ0
    have h2 : y*δ ≤ y*(u*(k:ℝ)^4/(2*(n:ℝ)^3)) := mul_le_mul_of_nonneg_left hδub hy0
    have h3 : y*(u*(k:ℝ)^4/(2*(n:ℝ)^3)) = u^2*(k:ℝ)^6/(4*(n:ℝ)^4) := by rw [hy]; ring_nf
    have h4 : u^2*(k:ℝ)^6/(4*(n:ℝ)^4) ≤ Q := by
      rw [hQ]
      exact phi_budget_mono hu0 hu2 hk1R hnR (a:=2) (c:=4) (p:=6) (q:=4)
        (by norm_num) (by norm_num) (by norm_num) (hkey 4 4 (by norm_num) (by norm_num))
    linarith
  -- Piece delta^2/2
  have hC : |δ^2/2| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have hδ2 : δ^2 ≤ (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2 := pow_le_pow_left₀ hδ0 hδub 2
    have h1 : δ^2/2 ≤ (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2/2 := div_le_div_of_nonneg_right hδ2 (by norm_num)
    have h2 : (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2/2 = u^2*(k:ℝ)^8/(8*(n:ℝ)^6) := by ring_nf
    rw [h2] at h1
    have h4 : u^2*(k:ℝ)^8/(8*(n:ℝ)^6) ≤ Q := by
      rw [hQ]
      exact phi_budget_mono hu0 hu2 hk1R hnR (a:=2) (c:=8) (p:=8) (q:=6)
        (by norm_num) (by norm_num) (by norm_num) (hkey 8 6 (by norm_num) (by norm_num))
    linarith
  -- Piece b^2 delta/2
  have hD : |(y - z)^2*δ/2| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have hb2 : (y - z)^2 ≤ y^2 :=
      pow_le_pow_left₀ (by linarith : 0 ≤ y - z) (by linarith : y - z ≤ y) 2
    have h1 : (y - z)^2*δ ≤ y^2 * (u*(k:ℝ)^4/(2*(n:ℝ)^3)) :=
      mul_le_mul hb2 hδub hδ0 (pow_nonneg hy0 2)
    have h3 : (y - z)^2*δ/2 ≤ y^2 * (u*(k:ℝ)^4/(2*(n:ℝ)^3))/2 :=
      div_le_div_of_nonneg_right h1 (by norm_num)
    have h2 : y^2 * (u*(k:ℝ)^4/(2*(n:ℝ)^3))/2 = u^3*(k:ℝ)^8/(16*(n:ℝ)^5) := by rw [hy]; ring_nf
    rw [h2] at h3
    have h4 : u^3*(k:ℝ)^8/(16*(n:ℝ)^5) ≤ Q := by
      rw [hQ]
      exact phi_budget_mono hu0 hu2 hk1R hnR (a:=3) (c:=16) (p:=8) (q:=5)
        (by norm_num) (by norm_num) (by norm_num) (hkey 16 5 (by norm_num) (by norm_num))
    linarith
  -- Piece b delta^2/2
  have hE : |(y - z)*δ^2/2| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have hδ2 : δ^2 ≤ (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2 := pow_le_pow_left₀ hδ0 hδub 2
    have h1 : (y - z)*δ^2 ≤ y * (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2 :=
      mul_le_mul (by linarith : y - z ≤ y) hδ2 (by positivity) hy0
    have h3 : (y - z)*δ^2/2 ≤ y * (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2/2 :=
      div_le_div_of_nonneg_right h1 (by norm_num)
    have h2 : y * (u*(k:ℝ)^4/(2*(n:ℝ)^3))^2/2 = u^3*(k:ℝ)^10/(16*(n:ℝ)^7) := by rw [hy]; ring_nf
    rw [h2] at h3
    have h4 : u^3*(k:ℝ)^10/(16*(n:ℝ)^7) ≤ Q := by
      rw [hQ, div_le_div_iff₀ (by positivity : (0:ℝ) < 16*(n:ℝ)^7) (by positivity : (0:ℝ) < (n:ℝ)^4)]
      have hgoal : u^3*(k:ℝ)^10*(n:ℝ)^4 = (u*(k:ℝ)^8*(n:ℝ)^4) * (u^2*(k:ℝ)^2) := by ring
      have hrhs : u*(k:ℝ)^8*(16*(n:ℝ)^7) = (u*(k:ℝ)^8*(n:ℝ)^4) * (16*(n:ℝ)^3) := by ring
      rw [hgoal, hrhs]
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      have hu2le : u^2 ≤ 1 := pow_le_one₀ hu0 hu2
      have hk2n : (k:ℝ)^2 ≤ (n:ℝ)/4 := by linarith [hk4R]
      have h1 : u^2*(k:ℝ)^2 ≤ (k:ℝ)^2 := by
        simpa using mul_le_mul_of_nonneg_right hu2le (by positivity : (0:ℝ) ≤ (k:ℝ)^2)
      have h2 : (n:ℝ)/4 ≤ 16*(n:ℝ)^3 := by nlinarith [hn1, pow_pos hnR 2]
      linarith [h1, hk2n, h2]
    linarith
  -- Piece delta^3/6
  have hF : |δ^3/6| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have hδ3 : δ^3 ≤ (u*(k:ℝ)^4/(2*(n:ℝ)^3))^3 := pow_le_pow_left₀ hδ0 hδub 3
    have h1 : δ^3/6 ≤ (u*(k:ℝ)^4/(2*(n:ℝ)^3))^3/6 := div_le_div_of_nonneg_right hδ3 (by norm_num)
    have h2 : (u*(k:ℝ)^4/(2*(n:ℝ)^3))^3/6 = u^3*(k:ℝ)^12/(48*(n:ℝ)^9) := by ring_nf
    rw [h2] at h1
    have h4 : u^3*(k:ℝ)^12/(48*(n:ℝ)^9) ≤ Q := by
      rw [hQ, div_le_div_iff₀ (by positivity : (0:ℝ) < 48*(n:ℝ)^9) (by positivity : (0:ℝ) < (n:ℝ)^4)]
      have hgoal : u^3*(k:ℝ)^12*(n:ℝ)^4 = (u*(k:ℝ)^8*(n:ℝ)^4) * (u^2*(k:ℝ)^4) := by ring
      have hrhs : u*(k:ℝ)^8*(48*(n:ℝ)^9) = (u*(k:ℝ)^8*(n:ℝ)^4) * (48*(n:ℝ)^5) := by ring
      rw [hgoal, hrhs]
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      have hu2le : u^2 ≤ 1 := pow_le_one₀ hu0 hu2
      have hk2n : (k:ℝ)^2 ≤ (n:ℝ)/4 := by linarith [hk4R]
      have hk4n : (k:ℝ)^4 ≤ (n:ℝ)^2/16 := by
        have := mul_self_le_mul_self (by positivity : (0:ℝ) ≤ (k:ℝ)^2) hk2n
        nlinarith [this]
      have h1 : u^2*(k:ℝ)^4 ≤ (k:ℝ)^4 := by
        simpa using mul_le_mul_of_nonneg_right hu2le (by positivity : (0:ℝ) ≤ (k:ℝ)^4)
      have hn3 : (1:ℝ) ≤ (n:ℝ)^3 := one_le_pow₀ hn1
      have hn5 : (n:ℝ)^2 ≤ (n:ℝ)^5 := by
        have := mul_le_mul_of_nonneg_left hn3 (by positivity : (0:ℝ) ≤ (n:ℝ)^2)
        nlinarith [this]
      have h2 : (n:ℝ)^2/16 ≤ 48*(n:ℝ)^5 := by nlinarith [hn5]
      linarith [h1, hk4n, h2]
    linarith
  -- Piece z^2/2
  have hG : |z^2/2| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have h1 : z^2/2 = u^2*(k:ℝ)^6/(18*(n:ℝ)^4) := by rw [hz]; ring_nf
    rw [h1, hQ]
    exact phi_budget_mono hu0 hu2 hk1R hnR (a:=2) (c:=18) (p:=6) (q:=4)
      (by norm_num) (by norm_num) (by norm_num) (hkey 18 4 (by norm_num) (by norm_num))
  -- Piece y^2 z/2
  have hH : |y^2*z/2| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have h1 : y^2*z/2 = u^3*(k:ℝ)^7/(24*(n:ℝ)^4) := by rw [hy, hz]; ring_nf
    rw [h1, hQ]
    exact phi_budget_mono hu0 hu2 hk1R hnR (a:=3) (c:=24) (p:=7) (q:=4)
      (by norm_num) (by norm_num) (by norm_num) (hkey 24 4 (by norm_num) (by norm_num))
  -- Piece y z^2/2
  have hI : |y*z^2/2| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have h1 : y*z^2/2 = u^3*(k:ℝ)^8/(36*(n:ℝ)^5) := by rw [hy, hz]; ring_nf
    rw [h1, hQ]
    exact phi_budget_mono hu0 hu2 hk1R hnR (a:=3) (c:=36) (p:=8) (q:=5)
      (by norm_num) (by norm_num) (by norm_num) (hkey 36 5 (by norm_num) (by norm_num))
  -- Piece z^3/6
  have hJ : |z^3/6| ≤ Q := by
    rw [abs_of_nonneg (by positivity)]
    have h1 : z^3/6 = u^3*(k:ℝ)^9/(162*(n:ℝ)^6) := by rw [hz]; ring_nf
    rw [h1, hQ, div_le_div_iff₀ (by positivity : (0:ℝ) < 162*(n:ℝ)^6) (by positivity : (0:ℝ) < (n:ℝ)^4)]
    have hgoal : u^3*(k:ℝ)^9*(n:ℝ)^4 = (u*(k:ℝ)^8*(n:ℝ)^4) * (u^2*(k:ℝ)) := by ring
    have hrhs : u*(k:ℝ)^8*(162*(n:ℝ)^6) = (u*(k:ℝ)^8*(n:ℝ)^4) * (162*(n:ℝ)^2) := by ring
    rw [hgoal, hrhs]
    apply mul_le_mul_of_nonneg_left _ (by positivity)
    have hu2le : u^2 ≤ 1 := pow_le_one₀ hu0 hu2
    have hkn_le : (k:ℝ) ≤ (n:ℝ) := by linarith [hkn, hkR]
    have hn_le_sq : (n:ℝ) ≤ (n:ℝ)^2 := by nlinarith [hn1, hn0]
    have h1 : u^2*(k:ℝ) ≤ (k:ℝ) := by
      simpa using mul_le_mul_of_nonneg_right hu2le (by positivity : (0:ℝ) ≤ (k:ℝ))
    have h2 : (n:ℝ)^2 ≤ 162*(n:ℝ)^2 := by nlinarith [sq_nonneg (n:ℝ)]
    linarith [h1, hkn_le, hn_le_sq, h2]
  -- Piece sA
  have hK : |sA| ≤ Q := by
    have h1 : |sA| ≤ u*(k:ℝ)^5/(5*(n:ℝ)^4) := by
      rw [hsA, hA4]; exact phi_sA_bound5 u n k hu1 hu2 hn hk hk4
    have h2 : u*(k:ℝ)^5/(5*(n:ℝ)^4) ≤ Q := by
      rw [hQ]
      simpa using phi_budget_mono hu0 hu2 hk1R hnR (a:=1) (c:=5) (p:=5) (q:=4)
        (by norm_num) (by norm_num) (by norm_num) (hkey 5 4 (by norm_num) (by norm_num))
    linarith
  have hsum := phi_fourth_sum_bound (y - z) δ y z sA
    (Real.exp d - 1 - d - d^2/2 - d^3/6) Q hR hB hC hD hE hF hG hH hI hJ hK
  have hc : δ = sA + u*(k:ℝ)^4/(4*(n:ℝ)^3) := by
    rw [hδ, hsA, hA4]
    field_simp
    ring
  have hdec := exp_fourth_decomp_target y z δ sA (u*(k:ℝ)^4/(4*(n:ℝ)^3)) hc
  have hmain : Real.exp d - (1 + y - z + y^2/2 - y*z + y^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3))
      = (Real.exp d - 1 - d - d^2/2 - d^3/6)
        + ((y - z)*δ + δ^2/2 + (y - z)^2*δ/2 + (y - z)*δ^2/2 + δ^3/6)
        + (z^2/2 - y^2*z/2 + y*z^2/2 - z^3/6) + sA := by
    have hdec' := hdec
    rw [← hd] at hdec'
    exact hdec'
  have habs : |Real.exp d - (1 + y - z + y^2/2 - y*z + y^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3))|
      ≤ 11*Q := by
    rw [hmain]; exact hsum
  have hT : (1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      = Real.exp (-(u*(k:ℝ))) * Real.exp d := by
    rw [hd, hδ, hA4, hy, hz]
    exact phi_term_expand u n k hnR
  have hG0 : (0:ℝ) ≤ Real.exp (-(u*(k:ℝ))) := le_of_lt (Real.exp_pos _)
  rw [hT]
  have hmodel : (1 + y - z + y^2/2 + (-(y*z) + y^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))
      = (1 + y - z + y^2/2 - y*z + y^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)) := by ring
  rw [hmodel]
  rw [← mul_sub, abs_mul, abs_of_nonneg hG0, hmain]
  have hGle : Real.exp (-(u*(k:ℝ))) ≤ Real.exp (-(u*(k:ℝ))/2) := by
    apply Real.exp_le_exp.mpr
    have huk : (0:ℝ) ≤ u*(k:ℝ) := mul_nonneg hu0 (le_of_lt hkR)
    linarith
  calc Real.exp (-(u*(k:ℝ))) * |(Real.exp d - 1 - d - d^2/2 - d^3/6)
        + ((y - z)*δ + δ^2/2 + (y - z)^2*δ/2 + (y - z)*δ^2/2 + δ^3/6)
        + (z^2/2 - y^2*z/2 + y*z^2/2 - z^3/6) + sA|
      ≤ Real.exp (-(u*(k:ℝ))) * (11*Q) := mul_le_mul_of_nonneg_left hsum hG0
    _ = 11 * u * (k:ℝ)^8/(n:ℝ)^4 * Real.exp (-(u*(k:ℝ))) := by rw [hQ]; ring
    _ ≤ 11 * u * (k:ℝ)^8/(n:ℝ)^4 * Real.exp (-(u*(k:ℝ))/2) := by
        apply mul_le_mul_of_nonneg_left hGle
        positivity
    _ = 11 * u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^8/(n:ℝ)^4) := by ring

/-! ### The fourth-order moment majorant `Σ k⁸ e^{−uk/2}` and the summed error -/

/-- Uniform bound `Σ_k k⁸ e^{−uk/2} ≤ 10¹²` for `u ≥ 1/2`, via the closed form
`∑' n, n^m r^n = Σ_j S(m,j)·j!·r^j/(1−r)^{j+1}` (`tsum_pow_mul_geometric_of_norm_lt_one`)
with `r = e^{−u/2} ≤ 4/5`.  This is the constant multiplying `n^{-4}` in the fourth-order
error. The products `S(8,j)·j!` peak at `266·720 = 191520`, bounded by `2·10⁵`. -/
lemma tsum_pow8_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, (k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) ≤ 10^12 := by
  have hr0 : (0:ℝ) ≤ Real.exp (-u/2) := le_of_lt (Real.exp_pos _)
  have hr1 : Real.exp (-u/2) < 1 := Real.exp_lt_one_iff.mpr (by linarith)
  have hr45 : Real.exp (-u/2) ≤ 4/5 := by
    have h := exp_neg_quarter_le (u/2) (show (1:ℝ)/4 ≤ u/2 by linarith)
    rw [show -(u/2) = -u/2 by ring] at h
    exact h
  have hq : (0:ℝ) < 1 - Real.exp (-u/2) := by linarith
  have heq : (∑' k : ℕ, (k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2))
      = (∑' k : ℕ, (k:ℝ)^8 * (Real.exp (-u/2))^k) := by
    apply tsum_congr; intro k
    rw [show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
  rw [heq, tsum_pow_mul_geometric_of_norm_lt_one 8 (by
    rw [Real.norm_eq_abs, abs_of_nonneg hr0]; exact hr1)]
  have hterm : ∀ j : ℕ, (Real.exp (-u/2))^j / (1 - Real.exp (-u/2))^(j+1) ≤ 5^(j+1) := by
    intro j
    rw [div_le_iff₀ (by positivity : (0:ℝ) < (1 - Real.exp (-u/2))^(j+1))]
    have h1 : (1:ℝ) ≤ 5*(1 - Real.exp (-u/2)) := by linarith
    have h2 : (Real.exp (-u/2))^j ≤ 1 := pow_le_one₀ hr0 (le_trans hr45 (by norm_num))
    calc (Real.exp (-u/2))^j ≤ 1 := h2
      _ ≤ (5*(1 - Real.exp (-u/2)))^(j+1) := one_le_pow₀ h1
      _ = 5^(j+1) * (1 - Real.exp (-u/2))^(j+1) := by rw [mul_pow]
  have hb : ∀ j ∈ Finset.range 9,
      (Nat.stirlingSecond 8 j : ℝ) * (j.factorial : ℝ) * (Real.exp (-u/2))^j
        / (1 - Real.exp (-u/2))^(j+1)
      ≤ 200000 * 5^(j+1) := by
    intro j hj
    have hsj : (Nat.stirlingSecond 8 j : ℝ) * (j.factorial : ℝ) ≤ 200000 := by
      have h : Nat.stirlingSecond 8 j * j.factorial ≤ 200000 := by
        have := Finset.mem_range.mp hj
        interval_cases j <;> norm_num [Nat.stirlingSecond, Nat.factorial]
      exact_mod_cast h
    have ht := hterm j
    have hdiv0 : (0:ℝ) ≤ (Real.exp (-u/2))^j / (1 - Real.exp (-u/2))^(j+1) := by positivity
    calc (Nat.stirlingSecond 8 j : ℝ) * (j.factorial : ℝ) * (Real.exp (-u/2))^j
          / (1 - Real.exp (-u/2))^(j+1)
        = ((Nat.stirlingSecond 8 j : ℝ) * (j.factorial : ℝ))
            * ((Real.exp (-u/2))^j / (1 - Real.exp (-u/2))^(j+1)) := by ring
      _ ≤ 200000 * 5^(j+1) := by
          apply mul_le_mul hsj ht hdiv0 (by positivity)
  have hgeom : (∑ j ∈ Finset.range 9, 200000 * 5^(j+1)) ≤ 10^12 := by
    have h : (∑ j ∈ Finset.range 9, 200000 * 5^(j+1)) = 200000 * 2441405 := by
      simp [Finset.sum_mul]
      norm_num [Finset.sum_range_succ]
    rw [h]; norm_num
  linarith [Finset.sum_le_sum hb, hgeom]

lemma summable_pow8_exp_half (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun j : ℕ => (j:ℝ)^8 * Real.exp (-(u*(j:ℝ))/2)) := by
  have h1 : ‖Real.exp (-(1/4:ℝ))‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    norm_num
  have hg : Summable (fun j : ℕ => (j:ℝ)^8 * (Real.exp (-(1/4:ℝ)))^j) :=
    summable_pow_mul_geometric_of_norm_lt_one 8 h1
  refine Summable.of_nonneg_of_le (fun j => by positivity) (fun j => ?_) hg
  have he : Real.exp (-(u*(j:ℝ))/2) = (Real.exp (-u/2))^j := by
    rw [show -(u*(j:ℝ))/2 = (j:ℝ)*(-u/2) by ring, Real.exp_nat_mul]
  rw [he]
  have hu' : Real.exp (-u/2) ≤ Real.exp (-(1/4:ℝ)) := Real.exp_le_exp.mpr (by linarith)
  have h0 : (0:ℝ) ≤ Real.exp (-u/2) := le_of_lt (Real.exp_pos _)
  exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hu' j) (by positivity)

/-- **Finite-regime summed fourth-order error.**  Over any `Finset` of indices with `k ≥ 1`
and `4k² ≤ n`, the total fourth-order error is `≤ 11·10¹²/n⁴`.

Combines `phi_term_sharp4` termwise with `tsum_pow8_exp_neg_half_le`. -/
lemma phi_err_sum_le4 (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (s : Finset ℕ) (hs1 : ∀ k ∈ s, 1 ≤ k) (hs : ∀ k ∈ s, 4*k^2 ≤ n) :
    ∑ k ∈ s, |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
            - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
            + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
                + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))|
      ≤ 11 * 10^12 / (n:ℝ)^4 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hsum8 : (∑' k : ℕ, (k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) ≤ 10^12 :=
    tsum_pow8_exp_neg_half_le u hu1
  have h1 : ∀ k ∈ s, |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
          - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
          + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
              + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))|
      ≤ 11*u*Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^8/(n:ℝ)^4) := by
    intro k hk
    exact phi_term_sharp4 u n k hu1 hu2 hn (hs1 k hk) (hs k hk)
  have hsm : Summable (fun k : ℕ => (k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) :=
    summable_pow8_exp_half u hu1
  have hfac : ∀ k : ℕ, 11*u*Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^8/(n:ℝ)^4)
      = (11*u/(n:ℝ)^4) * ((k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) := by
    intro k; ring
  calc ∑ k ∈ s, |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
            - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
            + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
                + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))|
      ≤ ∑ k ∈ s, 11*u*Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^8/(n:ℝ)^4) :=
        Finset.sum_le_sum h1
    _ = ∑ k ∈ s, (11*u/(n:ℝ)^4) * ((k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) := by
        apply Finset.sum_congr rfl; intro k hk; exact hfac k
    _ = (11*u/(n:ℝ)^4) * ∑ k ∈ s, ((k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) := by
        rw [Finset.mul_sum]
    _ ≤ (11*u/(n:ℝ)^4) * ∑' k : ℕ, ((k:ℝ)^8 * Real.exp (-(u*(k:ℝ))/2)) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        exact Summable.sum_le_tsum s (fun k _ => by positivity) hsm
    _ ≤ (11*u/(n:ℝ)^4) * (10^12) := by
        apply mul_le_mul_of_nonneg_left hsum8 (by positivity)
    _ ≤ 11*10^12 / (n:ℝ)^4 := by
        have h : 11*u/(n:ℝ)^4 * (10^12) = 11*10^12 * u / (n:ℝ)^4 := by ring
        rw [h, div_le_div_iff₀ (by positivity : (0:ℝ) < (n:ℝ)^4) (by positivity : (0:ℝ) < (n:ℝ)^4)]
        have hn4 : (0:ℝ) < (n:ℝ)^4 := by positivity
        nlinarith [hu2, hn4]

/-! ### The fourth-order model sum `PhiMain4` and its `E(u)/n³` decomposition -/

/-- The "fourth-order model" sum `Σ'_k G_k(1 + y − z + y²/2 + w)` over `k ≥ 0`. -/
noncomputable def PhiMain4 (u : ℝ) (n : ℕ) : ℝ :=
  ∑' k : ℕ, Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
      - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
      + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
          + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))

lemma summable_PhiMain4_term (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) :
    Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
      - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
      + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
          + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))) := by
  have hA := summable_exp_neg_u u hu1 0
  have hB := (summable_exp_neg_u u hu1 2).mul_left (u/(2*(n:ℝ)))
  have hC := (summable_exp_neg_u u hu1 3).mul_left (u/(3*(n:ℝ)^2))
  have hD := (summable_exp_neg_u u hu1 4).mul_left (u^2/(8*(n:ℝ)^2))
  have hE := (summable_exp_neg_u u hu1 5).mul_left (u^2/(6*(n:ℝ)^3))
  have hF := (summable_exp_neg_u u hu1 6).mul_left (u^3/(48*(n:ℝ)^3))
  have hG := (summable_exp_neg_u u hu1 4).mul_left (u/(4*(n:ℝ)^3))
  refine (((((hA.add hB).sub hC).add hD).sub hE).add hF).add hG |>.congr (fun k => ?_)
  ring

/-- The fourth-order model sum decomposes into the six moment sums, the `n^{-3}` coefficient
being `EFourth u = (u/4)PhiK4u u − (u²/6)PhiK5u u + (u³/48)PhiK6u u`. -/
lemma PhiMain4_eq (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 1 ≤ n) :
    PhiMain4 u n = (Real.exp u - 1)⁻¹ + 1 + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2
      + EFourth u/(n:ℝ)^3 := by
  have hu0 : (0:ℝ) < u := by linarith
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hA : Summable (fun k : ℕ => Real.exp (-(u*(k:ℝ)))) := by
    simpa using summable_exp_neg_u u hu1 0
  have hB : Summable (fun k : ℕ => (u/(2*(n:ℝ))) * ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 2).mul_left _
  have hC : Summable (fun k : ℕ => (u/(3*(n:ℝ)^2)) * ((k:ℝ)^3 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 3).mul_left _
  have hD : Summable (fun k : ℕ => (u^2/(8*(n:ℝ)^2)) * ((k:ℝ)^4 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 4).mul_left _
  have hE : Summable (fun k : ℕ => (u^2/(6*(n:ℝ)^3)) * ((k:ℝ)^5 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 5).mul_left _
  have hF : Summable (fun k : ℕ => (u^3/(48*(n:ℝ)^3)) * ((k:ℝ)^6 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 6).mul_left _
  have hG : Summable (fun k : ℕ => (u/(4*(n:ℝ)^3)) * ((k:ℝ)^4 * Real.exp (-(u*(k:ℝ))))) :=
    (summable_exp_neg_u u hu1 4).mul_left _
  have hkey : ∀ k : ℕ, Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
        - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
        + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
            + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))
      = Real.exp (-(u*(k:ℝ)))
        + (u/(2*(n:ℝ))) * ((k:ℝ)^2 * Real.exp (-(u*(k:ℝ))))
        - (u/(3*(n:ℝ)^2)) * ((k:ℝ)^3 * Real.exp (-(u*(k:ℝ))))
        + (u^2/(8*(n:ℝ)^2)) * ((k:ℝ)^4 * Real.exp (-(u*(k:ℝ))))
        - (u^2/(6*(n:ℝ)^3)) * ((k:ℝ)^5 * Real.exp (-(u*(k:ℝ))))
        + (u^3/(48*(n:ℝ)^3)) * ((k:ℝ)^6 * Real.exp (-(u*(k:ℝ))))
        + (u/(4*(n:ℝ)^3)) * ((k:ℝ)^4 * Real.exp (-(u*(k:ℝ)))) := by
    intro k
    have hE0 : Real.exp (-(u*(k:ℝ))) ≠ 0 := ne_of_gt (Real.exp_pos _)
    field_simp
    ring
  rw [PhiMain4, tsum_congr hkey]
  have hAB := hA.add hB
  have hABC := hAB.sub hC
  have hABCD := hABC.add hD
  have hABCDE := hABCD.sub hE
  have hABCDEF := hABCDE.add hF
  rw [Summable.tsum_add hABCDEF hG, Summable.tsum_add hABCDE hF,
    Summable.tsum_sub hABCD hE, Summable.tsum_add hABC hD,
    Summable.tsum_sub hAB hC, Summable.tsum_add hA hB,
    tsum_mul_left, tsum_mul_left, tsum_mul_left, tsum_mul_left, tsum_mul_left, tsum_mul_left,
    tsum_exp_neg_mul_eq u hu0, PhiS, PhiK3u, EFourth, PhiK5u, PhiK6u, PhiK4u]
  field_simp
  ring

/-- The fourth-order model sum with `Phi`'s own indexing (`k = j+1 ≥ 1`). -/
noncomputable def PhiMainS4 (u : ℝ) (n : ℕ) : ℝ :=
  ∑' j : ℕ, Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
      - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2
      + (-((u*((j:ℝ)+1)^2/(2*(n:ℝ))) * (u*((j:ℝ)+1)^3/(3*(n:ℝ)^2)))
          + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^3/6 + u*((j:ℝ)+1)^4/(4*(n:ℝ)^3)))

/-- `PhiMainS4` in terms of the moment sums: the `n^{-3}` coefficient is `EFourth u`. -/
lemma PhiMainS4_eq (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 1 ≤ n) :
    PhiMainS4 u n = (Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2
      + EFourth u/(n:ℝ)^3 := by
  have hsm := summable_PhiMain4_term u n hu1
  have hsh : PhiMainS4 u n = PhiMain4 u n - 1 := by
    have hsplit := hsm.sum_add_tsum_nat_add 1
    simp only [Finset.sum_range_one] at hsplit
    have hf0 : Real.exp (-(u*(((0:ℕ)):ℝ))) * (1 + u*(((0:ℕ)):ℝ)^2/(2*(n:ℝ))
        - u*(((0:ℕ)):ℝ)^3/(3*(n:ℝ)^2) + (u*(((0:ℕ)):ℝ)^2/(2*(n:ℝ)))^2/2
        + (-((u*(((0:ℕ)):ℝ)^2/(2*(n:ℝ))) * (u*(((0:ℕ)):ℝ)^3/(3*(n:ℝ)^2)))
            + (u*(((0:ℕ)):ℝ)^2/(2*(n:ℝ)))^3/6 + u*(((0:ℕ)):ℝ)^4/(4*(n:ℝ)^3))) = 1 := by
      simp
    rw [hf0] at hsplit
    have hcongr : PhiMainS4 u n
        = ∑' k : ℕ, (fun k : ℕ => Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
            - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
            + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
                + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3)))) (k+1) := by
      rw [PhiMainS4]
      apply tsum_congr; intro j
      simp only [Nat.cast_add, Nat.cast_one]
    rw [hcongr, PhiMain4]
    linarith [hsplit]
  rw [hsh, PhiMain4_eq u n hu1 hn]
  ring

/-! ### Status of the full `Phi_fourth_order`

The full target

    Phi_fourth_order : ∃ C > 0, ∀ᶠ n, ∀ u ∈ [1/2,1],
      |Phi_{un}(n) − (e^u−1)⁻¹ − (u/2n)PhiS(u) − D(u)/n² − E(u)/n³| ≤ C/n⁴

is now **landed** in this file (`Phi_fourth_order`), together with every new analytic input:

1. **`phi_term_sharp4`** (termwise).  For `4k² ≤ n`, `1 ≤ k`, `u ∈ [1/2,1]`,

       |T_k − G_k·(1 + y − z + y²/2 + w)| ≤ 11·u·e^{−uk/2}·k⁸/n⁴ ,

   with `y = uk²/(2n)`, `z = uk³/(3n²)`, `w = −yz + y³/6 + u·k⁴/(4n³)`.  The proof splits
   `e^d − M` by `exp_fourth_decomp_target` into the eleven terms
   `R, bδ, δ²/2, b²δ/2, bδ²/2, δ³/6, z²/2, −y²z/2, yz²/2, −z³/6, sA` (`b = y−z`, `R` the
   quartic `exp` remainder, `sA = δ − uk⁴/(4n³)`), bounds each by `Q = u·k⁸/n⁴` (directly for
   `sA` via `phi_r5_bounds`, so the `b·sA` product stays `O(k⁶/n⁴)` rather than the fatal
   `O(k⁴/n²)`), and assembles them by the triangle inequality `phi_fourth_sum_bound`.
   The budget lemmas are `phi_delta_bound4`, `phi_sA_bound5` and the monomial engine
   `phi_budget_mono`.

2. **`tsum_pow8_exp_neg_half_le`** (`Σ_k k⁸ e^{−uk/2} ≤ 10¹²` for `u ≥ 1/2`), with the
   summability companion `summable_pow8_exp_half`, and its summed consequence
   **`phi_err_sum_le4`**: over any finite index set with `k ≥ 1`, `4k² ≤ n`,
   `Σ |T_k − G_k M_k| ≤ 11·10¹²/n⁴`.  The finite/tail split is
   `phi_finite_part_le4` (+ `Phi_fourth_order_aux`), and the tail is `phi_tail_sum_le4`,
   whose model piece `phi_Q_abs_tail_le4` rests on the pointwise bound `phi_M4_abs_le`
   (`|M4_k| ≤ 2k⁶`) and on the `m ≤ 8` shifted moment bound `tsum_shift_pow_exp_le8`.
   The `n⁻⁴` eventual smallness lemmas are `exp_neg_sqrt16_le4` and `poly_two_neg_le4`.

**Remaining (not part of `Phi_fourth_order`)**: the threshold layer
`SThird → SFourth`, `uPhiS_expansion` to one more order, and
`threshold_third_order_uniform` upgraded to `n⁻⁴`.  The model-sum half of this is already
landed: `PhiMain4_eq` / `PhiMainS4_eq` give
`PhiMainS4 u n = (e^u−1)⁻¹ + (u/2n)PhiS(u) + D(u)/n² + EFourth(u)/n³`, so only the
threshold inversion (`SFourth`, one-more-order `uPhiS_expansion`,
`threshold_fourth_order_uniform`) remains; it requires a cubic expansion of `u·PhiS(u)`
around `u = log 2` and the `u`-expansion of `EFourth` (not yet available in `PhiThird.lean`). -/

/-! ### The `m ≤ 8` shifted moment tail -/

/-- Shifted tail moment bound at the `k⁸` weight: for `K ≥ 1`, `m ≤ 8`,
`Σ_i (i+K)^m e^{−u(i+K)} ≤ e^{−uK/2}·10¹²`.  This is the `m ≤ 8` extension of
`tsum_shift_pow_exp_le` (which stops at `m ≤ 6`) needed by the fourth-order model tail. -/
lemma tsum_shift_pow_exp_le8 (u : ℝ) (hu : 1/2 ≤ u) (K m : ℕ) (hK : 1 ≤ K) (hm : m ≤ 8) :
    (∑' i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (10^12) := by
  have hu0 : (0:ℝ) < u := by linarith
  have hK0 : (0:ℝ) < (K:ℝ) := by exact_mod_cast hK
  have hsm8 := summable_pow8_exp_half u hu
  have hshift8 : (∑' i : ℕ, ((i:ℝ)+K)^8 * Real.exp (-(u*((i:ℝ)+K))/2)) ≤ 10^12 := by
    have hsplit := hsm8.sum_add_tsum_nat_add K
    simp only [Nat.cast_add] at hsplit
    have hb := tsum_pow8_exp_neg_half_le u hu
    have h0 : (0:ℝ) ≤ ∑ i ∈ Finset.range K, (i:ℝ)^8 * Real.exp (-(u*(i:ℝ))/2) := by positivity
    have h1 : (∑' i : ℕ, ((i:ℝ)+K)^8 * Real.exp (-(u*((i:ℝ)+K))/2))
        ≤ ∑' i : ℕ, (i:ℝ)^8 * Real.exp (-(u*(i:ℝ))/2) := by linarith [hsplit, h0]
    linarith [h1, hb]
  have hle : ∀ i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)
      ≤ ((i:ℝ)+K)^8 * Real.exp (-(u*((i:ℝ)+K))/2) := by
    intro i
    have hK1 : (1:ℝ) ≤ (K:ℝ) := by exact_mod_cast hK
    have h1 : (1:ℝ) ≤ (i:ℝ)+(K:ℝ) := by
      have hi : (0:ℝ) ≤ (i:ℝ) := by positivity
      linarith
    exact mul_le_mul_of_nonneg_right (pow_le_pow_right₀ h1 hm) (by positivity)
  have hsm8' : Summable (fun i : ℕ => ((i:ℝ)+K)^8 * Real.exp (-(u*((i:ℝ)+K))/2)) := by
    have := (summable_nat_add_iff K).2 hsm8
    refine this.congr (fun i => ?_)
    simp [Nat.cast_add]
  have hsm' : Summable (fun i : ℕ => ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) :=
    Summable.of_nonneg_of_le (fun i => by positivity) hle hsm8'
  have hle8 : (∑' i : ℕ, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))/2)) ≤ 10^12 := by
    have h2 := Summable.tsum_le_tsum hle hsm' hsm8'
    linarith [h2, hshift8]
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
    _ ≤ Real.exp (-(u*(K:ℝ))/2) * (10^12) :=
        mul_le_mul_of_nonneg_left hle8 hpos

/-! ### Fourth-order model tail -/

/-- **Pointwise fourth-order model bound.**  For `u ∈ [0,1]`, `n ≥ 16`, `k ≥ 1` the whole
fourth-order model factor `M4_k = 1 + y − z + y²/2 + (−yz + y³/6 + uk⁴/(4n³))` is bounded by
`2k⁶`.  All coefficients are dominated by the `n ≥ 16` powers of the `k⁶` term. -/
lemma phi_M4_abs_le (u : ℝ) (n : ℕ) (k : ℕ) (hu0 : 0 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) :
    |1 + u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2
        + (-((u*(k:ℝ)^2/(2*(n:ℝ))) * (u*(k:ℝ)^3/(3*(n:ℝ)^2)))
            + (u*(k:ℝ)^2/(2*(n:ℝ)))^3/6 + u*(k:ℝ)^4/(4*(n:ℝ)^3))|
      ≤ 2*(k:ℝ)^6 := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16 : (16:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hn2 : (256:ℝ) ≤ (n:ℝ)^2 := by nlinarith
  have hn3 : (4096:ℝ) ≤ (n:ℝ)^3 := by nlinarith [hn2]
  have hu2' : u^2 ≤ 1 := pow_le_one₀ hu0 hu2
  have hu3' : u^3 ≤ 1 := pow_le_one₀ hu0 hu2
  set t : ℝ := (k:ℝ) with ht
  have ht1 : (1:ℝ) ≤ t := by rw [ht]; exact_mod_cast hk
  have ht0 : (0:ℝ) ≤ t := le_of_lt (by linarith)
  have hA : u*t^2/(2*(n:ℝ)) ≤ t^2/32 := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 2*(n:ℝ)) (by norm_num : (0:ℝ) < 32)]
    have h1 : u*32 ≤ (2:ℝ)*(n:ℝ) := by nlinarith
    nlinarith [h1, sq_nonneg t]
  have hB : u*t^3/(3*(n:ℝ)^2) ≤ t^3/768 := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 3*(n:ℝ)^2) (by norm_num : (0:ℝ) < 768)]
    have h1 : u*768 ≤ 3*(n:ℝ)^2 := by nlinarith
    nlinarith [h1, pow_nonneg ht0 3]
  have hC : (u*t^2/(2*(n:ℝ)))^2/2 ≤ t^4/2048 := by
    have he : (u*t^2/(2*(n:ℝ)))^2/2 = u^2*t^4/(8*(n:ℝ)^2) := by ring_nf
    rw [he, div_le_div_iff₀ (by positivity : (0:ℝ) < 8*(n:ℝ)^2) (by norm_num : (0:ℝ) < 2048)]
    have h1 : u^2*2048 ≤ 8*(n:ℝ)^2 := by nlinarith [hu2', hn2]
    nlinarith [h1, pow_nonneg ht0 4]
  have hD : (u*t^2/(2*(n:ℝ)))*(u*t^3/(3*(n:ℝ)^2)) ≤ t^5/24576 := by
    have he : (u*t^2/(2*(n:ℝ)))*(u*t^3/(3*(n:ℝ)^2)) = u^2*t^5/(6*(n:ℝ)^3) := by ring_nf
    rw [he, div_le_div_iff₀ (by positivity : (0:ℝ) < 6*(n:ℝ)^3) (by norm_num : (0:ℝ) < 24576)]
    have h1 : u^2*24576 ≤ 6*(n:ℝ)^3 := by nlinarith [hu2', hn3]
    nlinarith [h1, pow_nonneg ht0 5]
  have hE : (u*t^2/(2*(n:ℝ)))^3/6 ≤ t^6/196608 := by
    have he : (u*t^2/(2*(n:ℝ)))^3/6 = u^3*t^6/(48*(n:ℝ)^3) := by ring_nf
    rw [he, div_le_div_iff₀ (by positivity : (0:ℝ) < 48*(n:ℝ)^3) (by norm_num : (0:ℝ) < 196608)]
    have h1 : u^3*196608 ≤ 48*(n:ℝ)^3 := by nlinarith [hu3', hn3]
    nlinarith [h1, pow_nonneg ht0 6]
  have hF : u*t^4/(4*(n:ℝ)^3) ≤ t^4/16384 := by
    rw [div_le_div_iff₀ (by positivity : (0:ℝ) < 4*(n:ℝ)^3) (by norm_num : (0:ℝ) < 16384)]
    have h1 : u*16384 ≤ 4*(n:ℝ)^3 := by nlinarith
    nlinarith [h1, pow_nonneg ht0 4]
  set M : ℝ := 1 + u*t^2/(2*(n:ℝ)) - u*t^3/(3*(n:ℝ)^2) + (u*t^2/(2*(n:ℝ)))^2/2
      + (-((u*t^2/(2*(n:ℝ)))*(u*t^3/(3*(n:ℝ)^2))) + (u*t^2/(2*(n:ℝ)))^3/6
          + u*t^4/(4*(n:ℝ)^3)) with hM
  have ht6 : (1:ℝ) ≤ t^6 := one_le_pow₀ ht1
  have hcoef : 1 + t^2/32 + t^4/2048 + t^6/196608 + t^4/16384 ≤ 2*t^6 := by
    have ht2 : t^2 ≤ t^6 := pow_le_pow_right₀ ht1 (by norm_num : 2 ≤ 6)
    have ht4 : t^4 ≤ t^6 := pow_le_pow_right₀ ht1 (by norm_num : 4 ≤ 6)
    nlinarith [ht2, ht4, ht6, pow_nonneg ht0 6]
  have hup : M ≤ 2*t^6 := by
    have hB0 : (0:ℝ) ≤ u*t^3/(3*(n:ℝ)^2) := by positivity
    have hD0 : (0:ℝ) ≤ (u*t^2/(2*(n:ℝ)))*(u*t^3/(3*(n:ℝ)^2)) := by positivity
    linarith [hM, hA, hC, hE, hF, hcoef, hB0, hD0]
  have hlow : -(2*t^6) ≤ M := by
    have h1 : (0:ℝ) ≤ 1 + u*t^2/(2*(n:ℝ)) + (u*t^2/(2*(n:ℝ)))^2/2
        + (u*t^2/(2*(n:ℝ)))^3/6 + u*t^4/(4*(n:ℝ)^3) := by positivity
    have ht3 : t^3 ≤ t^6 := pow_le_pow_right₀ ht1 (by norm_num : 3 ≤ 6)
    have ht5 : t^5 ≤ t^6 := pow_le_pow_right₀ ht1 (by norm_num : 5 ≤ 6)
    have hBle : u*t^3/(3*(n:ℝ)^2) ≤ t^6 := le_trans hB (by nlinarith [ht3])
    have hDle : (u*t^2/(2*(n:ℝ)))*(u*t^3/(3*(n:ℝ)^2)) ≤ t^6 := le_trans hD (by nlinarith [ht5])
    linarith [hM, h1, hBle, hDle]
  rw [abs_le]
  exact ⟨hlow, hup⟩

/-- **Absolute fourth-order model tail.**  `Σ_i |Q^{(4)}_{i+K}| ≤ e^{−uK/2}·2·10¹²` for
`K ≥ 1`, obtained by dominating the model by `2k⁶` (`phi_M4_abs_le`) and applying
`tsum_shift_pow_exp_le8` at `m = 6`. -/
lemma phi_Q_abs_tail_le4 (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hK : 1 ≤ K) :
    (∑' i : ℕ, |Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+K)^2/(2*(n:ℝ))) * (u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+K)^4/(4*(n:ℝ)^3)))|)
      ≤ Real.exp (-(u*(K:ℝ))/2) * (2*10^12) := by
  have hu0 : (0:ℝ) ≤ u := by linarith
  have hle : ∀ i : ℕ, |Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+K)^2/(2*(n:ℝ))) * (u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+K)^4/(4*(n:ℝ)^3)))|
      ≤ 2 * (((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K)))) := by
    intro i
    have hmodel := phi_M4_abs_le u n (i+K) hu0 hu2 hn (by omega)
    have hmodel' : |1 + u*((i:ℝ)+K)^2/(2*(n:ℝ)) - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+K)^2/(2*(n:ℝ))) * (u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^3/6 + u*((i:ℝ)+K)^4/(4*(n:ℝ)^3))|
        ≤ 2*((i:ℝ)+K)^6 := by
      simpa [Nat.cast_add] using hmodel
    rw [abs_mul, abs_of_pos (Real.exp_pos _)]
    calc Real.exp (-(u*((i:ℝ)+K))) * |1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
          - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
          + (-((u*((i:ℝ)+K)^2/(2*(n:ℝ))) * (u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)))
              + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^3/6 + u*((i:ℝ)+K)^4/(4*(n:ℝ)^3))|
        ≤ Real.exp (-(u*((i:ℝ)+K))) * (2*((i:ℝ)+K)^6) :=
          mul_le_mul_of_nonneg_left hmodel' (le_of_lt (Real.exp_pos _))
      _ = 2 * (((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K)))) := by ring
  have hshift : ∀ m : ℕ, Summable (fun i : ℕ =>
      ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K)))) := by
    intro m
    have h := (summable_nat_add_iff K).2 (summable_exp_neg_u u hu1 m)
    refine h.congr (fun i => ?_)
    simp [Nat.cast_add]
  have hR : Summable (fun i : ℕ => 2 * (((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K))))) :=
    (hshift 6).mul_left 2
  have hL : Summable (fun i : ℕ => |Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+K)^2/(2*(n:ℝ))) * (u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+K)^4/(4*(n:ℝ)^3)))|) :=
    Summable.of_nonneg_of_le (fun i => abs_nonneg _) hle hR
  have hmain := Summable.tsum_le_tsum hle hL hR
  rw [tsum_mul_left] at hmain
  calc (∑' i : ℕ, |Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+K)^2/(2*(n:ℝ))) * (u*((i:ℝ)+K)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+K)^4/(4*(n:ℝ)^3)))|)
      ≤ 2 * (∑' i : ℕ, ((i:ℝ)+K)^6 * Real.exp (-(u*((i:ℝ)+K)))) := hmain
    _ ≤ 2 * (Real.exp (-(u*(K:ℝ))/2) * (10^12)) :=
        mul_le_mul_of_nonneg_left (tsum_shift_pow_exp_le8 u hu1 K 6 hK (by norm_num))
          (by norm_num)
    _ = Real.exp (-(u*(K:ℝ))/2) * (2*10^12) := by ring

/-- `phi_Q_abs_tail_le4` restated with the index in the `↑i+↑N+1` form the tail assembly needs. -/
lemma phi_Q_abs_tail_le4' (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hN : 1 ≤ N) :
    (∑' i : ℕ, |Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
        - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))|)
      ≤ Real.exp (-(u*(N:ℝ))/2) * (2*10^12) := by
  have h := phi_Q_abs_tail_le4 u n (N+1) hu1 hu2 hn (by omega)
  have hconv : (∑' i : ℕ, |Real.exp (-(u*((i:ℝ)+(((N+1:ℕ)):ℝ)))) * (1 + u*((i:ℝ)+(((N+1:ℕ)):ℝ))^2/(2*(n:ℝ))
        - u*((i:ℝ)+(((N+1:ℕ)):ℝ))^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+(((N+1:ℕ)):ℝ))^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+(((N+1:ℕ)):ℝ))^2/(2*(n:ℝ))) * (u*((i:ℝ)+(((N+1:ℕ)):ℝ))^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+(((N+1:ℕ)):ℝ))^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+(((N+1:ℕ)):ℝ))^4/(4*(n:ℝ)^3)))|)
      = (∑' i : ℕ, |Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
        - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
        + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
        + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
            + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))|) := by
    apply tsum_congr; intro i
    congr 1
    push_cast
    ring
  rw [hconv] at h
  have hN1 : Real.exp (-(u*(((N+1:ℕ)):ℝ))/2) ≤ Real.exp (-(u*(N:ℝ))/2) := by
    apply Real.exp_le_exp.mpr
    have hu0 : (0:ℝ) ≤ u := by linarith
    push_cast
    linarith
  have hfac : (0:ℝ) ≤ (2*10^12) := by norm_num
  have := mul_le_mul_of_nonneg_right hN1 hfac
  linarith [h, this]

/-- Summability of the shifted fourth-order model summand. -/
lemma summable_Q4_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    Summable (fun i : ℕ => Real.exp (-(u*((i:ℝ)+(N:ℝ)+1)))
        * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))) := by
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
  have h2 := (hshift 2).mul_left (u/(2*(n:ℝ)))
  have h3 := (hshift 3).mul_left (u/(3*(n:ℝ)^2))
  have h4 := (hshift 4).mul_left (u^2/(8*(n:ℝ)^2))
  have h5 := (hshift 5).mul_left (u^2/(6*(n:ℝ)^3))
  have h6 := (hshift 6).mul_left (u^3/(48*(n:ℝ)^3))
  have h4' := (hshift 4).mul_left (u/(4*(n:ℝ)^3))
  refine ((((((h0.add h2).sub h3).add h4).sub h5).add h6).add h4').congr (fun i => ?_)
  ring

/-- **Tail of `Φ − PhiMainS4`.**  `Σ'_i |U_{i+N+1} − Q^{(4)}_{i+N+1}| ≤
e^{−uN/2}·2·10¹² + 6e^{−uN/2} + 4n·2^{−un}`, combining `phi_U_shift_le`,
`phi_Q_abs_tail_le4'` and the triangle inequality. -/
lemma phi_tail_sum_le4 (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i : ℕ, |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))|)
      ≤ Real.exp (-(u*(N:ℝ))/2) * (2*10^12) + 6 * Real.exp (-(u*(N:ℝ))/2)
        + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
  have hU := phi_U_shift_le u n N hu1 hu2 hn hN hNn
  have hQ := phi_Q_abs_tail_le4' u n N hu1 hu2 hn hN
  have hsumU : Summable (fun i : ℕ => (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi_shiftN u n N hu1 hn
  have hsumQ := summable_Q4_shiftN u n N hu1 hu2 hn
  have hle : ∀ i : ℕ, |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))|
      ≤ (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        + |Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))| := by
    intro i
    have hU0 : (0:ℝ) ≤ (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))) := by positivity
    refine abs_sub_le_iff.mpr ⟨?_, ?_⟩
    · linarith [neg_le_abs (Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3))))]
    · linarith [le_abs_self (Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))), hU0]
  have hsumm : Summable (fun i : ℕ => |(1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
            - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))) * (u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^3/6
                + u*((i:ℝ)+(N:ℝ)+1)^4/(4*(n:ℝ)^3)))|) :=
    Summable.of_nonneg_of_le (fun i => abs_nonneg _) hle (hsumU.add hsumQ.abs)
  have hmain := Summable.tsum_le_tsum hle hsumm (hsumU.add hsumQ.abs)
  rw [Summable.tsum_add hsumU hsumQ.abs] at hmain
  linarith [hmain, hU, hQ]

/-! ### Eventual `n^{-4}` smallness -/

/-- `exp(−√n/16) ≤ n⁻⁴` for `n ≥ 10¹⁰` (the `n⁻⁴` companion of `exp_neg_sqrt16_le`; the
natural threshold is `256⁴ ≈ 4.3·10⁹`). -/
lemma exp_neg_sqrt16_le4 {n : ℕ} (hn : 10000000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/16) ≤ (1:ℝ)/((n:ℝ)^4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hbig : (256:ℝ)^4 ≤ (n:ℝ) := by
    have h100 : (10000000000:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
    have h256 : (256:ℝ)^4 ≤ (10000000000:ℝ) := by norm_num
    linarith
  have hrw : ((256:ℝ)^(4:ℕ))^(1/4:ℝ) = 256 := by
    norm_num [Real.rpow_natCast, Real.rpow_mul]
  have h256 : (256:ℝ) ≤ (n:ℝ)^(1/4:ℝ) := by
    have h0 : (0:ℝ) ≤ (256:ℝ)^4 := by positivity
    have h := Real.rpow_le_rpow h0 hbig (by norm_num : (0:ℝ) ≤ (1/4:ℝ))
    rwa [hrw] at h
  have hq : (0:ℝ) < (n:ℝ)^(1/4:ℝ) := Real.rpow_pos_of_pos hnR _
  have hlog : 4 * Real.log (n:ℝ) ≤ Real.sqrt (n:ℝ)/16 := by
    have h1 : Real.log (n:ℝ) ≤ (n:ℝ)^(1/4:ℝ)/(1/4:ℝ) :=
      Real.log_le_rpow_div (le_of_lt hnR) (by norm_num : (0:ℝ) < 1/4)
    have h2 : (n:ℝ)^(1/4:ℝ)/(1/4:ℝ) = 4 * (n:ℝ)^(1/4:ℝ) := by ring
    rw [h2] at h1
    have h3 : Real.sqrt (n:ℝ) = (n:ℝ)^(1/2:ℝ) := Real.sqrt_eq_rpow _
    have h5 : (n:ℝ)^(1/2:ℝ) = (n:ℝ)^(1/4:ℝ) * (n:ℝ)^(1/4:ℝ) := by
      rw [← Real.rpow_add (by positivity)]
      norm_num
    have h4 : 16 * (n:ℝ)^(1/4:ℝ) ≤ (n:ℝ)^(1/2:ℝ)/16 := by
      rw [h5]
      have h6 : (16:ℝ) ≤ (n:ℝ)^(1/4:ℝ)/16 := by linarith
      have hm : (n:ℝ)^(1/4:ℝ) * 16 ≤ (n:ℝ)^(1/4:ℝ) * ((n:ℝ)^(1/4:ℝ)/16) :=
        mul_le_mul_of_nonneg_left h6 (le_of_lt hq)
      linarith [hm]
    rw [h3]
    linarith [h1, h4]
  have hgoal : (n:ℝ)^4 ≤ Real.exp (Real.sqrt (n:ℝ)/16) := by
    rw [← Real.log_le_iff_le_exp (by positivity : (0:ℝ) < (n:ℝ)^4), Real.log_pow]
    push_cast
    linarith
  rw [show -Real.sqrt (n:ℝ)/16 = -(Real.sqrt (n:ℝ)/16) by ring, Real.exp_neg, one_div,
    inv_le_inv₀ (Real.exp_pos _) (by positivity)]
  exact hgoal

/-- `2^{−n/4} ≤ n⁻⁴` for `n ≥ 10¹⁰`. -/
lemma two_neg_quarter_le_inv_four {n : ℕ} (hn : 10000000000 ≤ n) :
    (2:ℝ)^(-((n:ℝ)/4)) ≤ (1:ℝ)/((n:ℝ)^4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn10 : (10000000000:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  rw [show (1:ℝ)/((n:ℝ)^4) = ((n:ℝ)^4)⁻¹ by rw [one_div]]
  rw [show (2:ℝ)^(-((n:ℝ)/4)) = (((2:ℝ)^((n:ℝ)/4))⁻¹) by
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2)]]
  rw [inv_le_inv₀ (by positivity) (by positivity)]
  rw [Real.le_rpow_iff_log_le (by positivity : (0:ℝ) < (n:ℝ)^4) (by norm_num : (0:ℝ) < 2)]
  rw [show Real.log ((n:ℝ)^4) = 4 * Real.log (n:ℝ) by
    rw [Real.log_pow]; push_cast; ring]
  have hsq : (100000:ℝ) ≤ Real.sqrt (n:ℝ) := by
    rw [Real.le_sqrt (by norm_num : (0:ℝ) ≤ 100000) (by positivity : (0:ℝ) ≤ (n:ℝ))]
    nlinarith [hn10]
  have hlog : Real.log (n:ℝ) ≤ 2 * Real.sqrt (n:ℝ) := by
    have h := Real.log_le_rpow_div (le_of_lt hnR) (by norm_num : (0:ℝ) < 1/2)
    have h2 : (n:ℝ)^(1/2:ℝ)/(1/2:ℝ) = 2*(n:ℝ)^(1/2:ℝ) := by ring
    rw [Real.sqrt_eq_rpow]
    linarith [h, h2]
  have hlog2 : (1/2:ℝ) ≤ Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have h4 : 8 * Real.sqrt (n:ℝ) ≤ ((n:ℝ)/4) * Real.log 2 := by
    have hs : Real.sqrt (n:ℝ)^2 = (n:ℝ) := Real.sq_sqrt (le_of_lt hnR)
    have h5 : 8 * Real.sqrt (n:ℝ) ≤ (n:ℝ)/8 := by nlinarith [hsq, hs]
    have h6 : (n:ℝ)/8 ≤ ((n:ℝ)/4) * Real.log 2 := by nlinarith [hlog2, hnR]
    linarith [h5, h6]
  linarith [hlog, h4]

/-- `4n·2^{−un} ≤ n⁻⁴` for `n ≥ 10¹⁰`, `u ≥ 1/2`. -/
lemma poly_two_neg_le4 {u : ℝ} {n : ℕ} (hu : 1/2 ≤ u) (hn : 10000000000 ≤ n) :
    4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) ≤ (1:ℝ)/((n:ℝ)^4) := by
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
  have h3 : (2:ℝ)^(-((n:ℝ)/4)) ≤ (1:ℝ)/((n:ℝ)^4) := two_neg_quarter_le_inv_four hn
  linarith [h1b, h2, h3]

/-! ### The fourth-order assembly -/

/-- **Finite part of the fourth-order tail split.**  For `K` such that every `k < K`
satisfies `4k² ≤ n`, the first `K−1` terms of the `Φ`-vs-`PhiMainS4` comparison sum to
`≤ 11·10¹²/n⁴`.  Direct consequence of `phi_err_sum_le4`. -/
lemma phi_finite_part_le4 (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hK : ∀ k, k < K → 4*k^2 ≤ n) :
    ∑ j ∈ Finset.range (K-1), |(1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
        - Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
            - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2
            + (-((u*((j:ℝ)+1)^2/(2*(n:ℝ))) * (u*((j:ℝ)+1)^3/(3*(n:ℝ)^2)))
                + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^3/6 + u*((j:ℝ)+1)^4/(4*(n:ℝ)^3)))|
      ≤ 11*10^12 / (n:ℝ)^4 := by
  have h := phi_err_sum_le4 u n hu1 hu2 hn (Finset.Ico 1 K)
    (fun k hk => (Finset.mem_Ico.mp hk).1)
    (fun k hk => hK k (Finset.mem_Ico.mp hk).2)
  rw [Finset.sum_Ico_eq_sum_range] at h
  have hidx : ∀ i : ℕ, 1 + i = i + 1 := fun i => by omega
  simp only [hidx] at h
  simpa [Nat.cast_add, Nat.cast_one] using h

/-- **`Phi_fourth_order_aux`.**  `Φ_{un}(n) = PhiMainS4(u,n) + O(n⁻⁴)`, uniformly for
`u ∈ [1/2,1]`, with the split point `N` carried as a parameter.  The finite part is
`phi_finite_part_le4`, the tail is `phi_tail_sum_le4` together with the exponentially
small `exp(−√n/16)` and `2^{−un}` bounds at rate `n⁻⁴`. -/
lemma Phi_fourth_order_aux {u : ℝ} {n N : ℕ}
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 10000000000 ≤ n)
    (hN1 : 1 ≤ N) (hNn : N ≤ n)
    (hK : ∀ k, k ≤ N → 4*k^2 ≤ n)
    (hbig : Real.sqrt ((n:ℝ))/4 ≤ (N:ℝ)) :
    |Phi (u*(n:ℝ)) n - PhiMainS4 u n| ≤ (11*10^12 + 2*10^12 + 7)/((n:ℝ)^4) := by
  have hnR : (0:ℝ) < (n:ℝ) := by positivity
  have hn16 : 16 ≤ n := by omega
  have hun : (2:ℝ) ≤ u*(n:ℝ) := by
    have h2 : (4:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 4 ≤ n)
    nlinarith [hu1, h2]
  have hu0 : (0:ℝ) ≤ u := by linarith
  set f : ℕ → ℝ := fun j => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
          - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2
          + (-((u*((j:ℝ)+1)^2/(2*(n:ℝ))) * (u*((j:ℝ)+1)^3/(3*(n:ℝ)^2)))
              + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^3/6 + u*((j:ℝ)+1)^4/(4*(n:ℝ)^3))) with hf
  have hsumU : Summable (fun j : ℕ => (1 + (((j:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    summable_phi u n (by omega) hun
  have hsumQ : Summable (fun j : ℕ => Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
      - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2
      + (-((u*((j:ℝ)+1)^2/(2*(n:ℝ))) * (u*((j:ℝ)+1)^3/(3*(n:ℝ)^2)))
          + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^3/6 + u*((j:ℝ)+1)^4/(4*(n:ℝ)^3)))) := by
    have h := (summable_nat_add_iff 1).2 (summable_PhiMain4_term u n hu1)
    refine h.congr (fun j => ?_)
    simp only [Nat.cast_add, Nat.cast_one]
  have hfsum : Summable f := hsumU.sub hsumQ
  have hsub : Phi (u*(n:ℝ)) n - PhiMainS4 u n = ∑' j, f j := by
    rw [Phi, PhiMainS4, hf]
    exact (Summable.tsum_sub hsumU hsumQ).symm
  have hsplit := hfsum.sum_add_tsum_nat_add N
  have hfinN : ∑ j ∈ Finset.range N, |f j| ≤ 11*10^12/((n:ℝ)^4) := by
    have h := phi_finite_part_le4 u n (N+1) hu1 hu2 (by omega) (fun k hk => hK k (by omega))
    simpa [Nat.add_sub_cancel, hf] using h
  have htailN : (∑' i : ℕ, |f (i+N)|) ≤ Real.exp (-(u*(N:ℝ))/2) * (2*10^12)
      + 6 * Real.exp (-(u*(N:ℝ))/2) + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) := by
    have h := phi_tail_sum_le4 u n N hu1 hu2 (by omega) hN1 hNn
    simpa [hf, Nat.cast_add] using h
  have htri : |∑' j, f j| ≤ ∑ j ∈ Finset.range N, |f j| + ∑' i : ℕ, |f (i+N)| := by
    rw [← hsplit]
    have hA := abs_add_le (∑ j ∈ Finset.range N, f j) (∑' i : ℕ, f (i+N))
    have hB := Finset.abs_sum_le_sum_abs f (Finset.range N)
    have hC := abs_tsum_le_tsum_abs' (fun i => f (i+N))
      (hfsum.comp_injective (fun a b h => Nat.add_right_cancel h))
    linarith [hA, hB, hC]
  have hnum : Real.exp (-(u*(N:ℝ))/2) ≤ (1:ℝ)/((n:ℝ)^4) := by
    have h1 : Real.exp (-(u*(N:ℝ))/2) ≤ Real.exp (-(Real.sqrt (n:ℝ))/16) := by
      apply Real.exp_le_exp.mpr
      nlinarith [hbig, hu1]
    exact le_trans h1 (exp_neg_sqrt16_le4 hn)
  have hnum2 : 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) ≤ (1:ℝ)/((n:ℝ)^4) :=
    poly_two_neg_le4 hu1 hn
  have hb1 : Real.exp (-(u*(N:ℝ))/2) * (2*10^12) ≤ (1:ℝ)/((n:ℝ)^4) * (2*10^12) :=
    mul_le_mul_of_nonneg_right hnum (by norm_num)
  have hb2 : 6 * Real.exp (-(u*(N:ℝ))/2) ≤ 6 * ((1:ℝ)/((n:ℝ)^4)) :=
    mul_le_mul_of_nonneg_left hnum (by norm_num)
  rw [hsub]
  have hconst : 11*10^12/((n:ℝ)^4) + ((1:ℝ)/((n:ℝ)^4) * (2*10^12)
      + 6 * ((1:ℝ)/((n:ℝ)^4)) + (1:ℝ)/((n:ℝ)^4))
      = (11*10^12 + 2*10^12 + 7)/((n:ℝ)^4) := by
    field_simp
    ring
  linarith [htri, hfinN, htailN, hb1, hb2, hnum2, hconst]

/-- **`Phi_fourth_order`.**  `Φ_{un}(n) = (e^u−1)⁻¹ + (u/2n)ΦS(u) + D(u)/n² + E(u)/n³ + O(n⁻⁴)`,
uniformly for `u ∈ [1/2,1]`, with `D(u) = −(u/3)ΦK3u + (u²/8)ΦK4u` and the fourth-order
coefficient `EFourth u = (u/4)ΦK4u − (u²/6)ΦK5u + (u³/48)ΦK6u`.  Assembly of
`Phi_fourth_order_aux` with the model identity `PhiMainS4_eq`. -/
theorem Phi_fourth_order :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
          + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2) + EFourth u/((n:ℝ)^3))|
        ≤ C/((n:ℝ)^4) := by
  refine ⟨11*10^12 + 2*10^12 + 7, by norm_num, ?_⟩
  filter_upwards [Filter.eventually_ge_atTop 10000000000] with n hn
  intro u hu1 hu2
  have sb := split_bounds' (by omega : 100000000 ≤ n)
  have h := Phi_fourth_order_aux hu1 hu2 hn sb.1 sb.2.1 sb.2.2.1 sb.2.2.2
  rw [← PhiMainS4_eq u n hu1 (by omega : 1 ≤ n)]
  exact h

end

end Op56
