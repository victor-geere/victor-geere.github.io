/-
  Op57/Leading.lean — the forced leading coefficient under a twisted alphabet.

  OP-5 (`c ≡ 1`, `q = 1`) is the statement `Σ_{j≥1} x^j = 1 ⊢ x = 1/2`, proved in
  006 as `Op56.leadingCoeff_forced`: the rate `log 2` is *not fitted*.

  Replacing the parity sieve `c m = 1_{2|m}` by a residue-class sieve, the
  geometric identity `Σ_{j≥1} x^j = 1` is replaced by the **character sum**

      Σ_{j≥1} c(r+j) x^j  = 1 ,

  which regroups over the period `q` into `x^s / (1 − x^q) = 1`, i.e.

      x^s = 1 − x^q .                                       (LEAD)

  The two parity cases are `x^2 = 1/2` (even `r`, `1/√2`) and `x^2 + x = 1`
  (odd `r`, the golden-ratio conjugate `(√5−1)/2`).  Both are quadratic
  irrationals: the leading rate is again *forced*, now by a character equation
  rather than by a single geometric series.
-/

import Op57.Defs

namespace Op57

noncomputable section

open scoped BigOperators Topology

open Filter

/-- **(LEAD)** The leading equation `F_r(x) = 1` of a residue-class sieve,
regrouped over the period: `x^s = 1 − x^q`.  This is the character-sum
replacement of 006's `leadingCoeff_forced`. -/
theorem leading_forced_of_hasSum_geom {q s : ℕ} (hq : 0 < q) (_hs : 1 ≤ s)
    {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1)
    (h : HasSum (fun k : ℕ => x ^ (q * k + s)) 1) : x ^ s = 1 - x ^ q := by
  have hlt := geom_norm_lt_one hx0 hx1 hq
  have hgeom : HasSum (fun k : ℕ => (x ^ q) ^ k) (1 - x ^ q)⁻¹ :=
    hasSum_geometric_of_norm_lt_one hlt
  have hmul : HasSum (fun k : ℕ => x ^ s * (x ^ q) ^ k) (x ^ s * (1 - x ^ q)⁻¹) :=
    hgeom.mul_left (x ^ s)
  have hfun : (fun k : ℕ => x ^ (q * k + s)) = fun k : ℕ => x ^ s * (x ^ q) ^ k := by
    funext k
    exact geom_term x q s k
  have hmul' : HasSum (fun k : ℕ => x ^ (q * k + s)) (x ^ s * (1 - x ^ q)⁻¹) := by
    rw [hfun]
    exact hmul
  have huniq : (1 : ℝ) = x ^ s * (1 - x ^ q)⁻¹ := h.unique hmul'
  have hpos : (0 : ℝ) < 1 - x ^ q := by
    have := geom_norm_lt_one hx0 hx1 hq
    rw [Real.norm_eq_abs, abs_of_nonneg (pow_nonneg hx0 q)] at this
    linarith
  have hne : (1 - x ^ q) ≠ 0 := ne_of_gt hpos
  have hclear : (1 - x ^ q) = x ^ s := by
    have h1 : x ^ s * (1 - x ^ q)⁻¹ * (1 - x ^ q) = x ^ s := by
      rw [mul_assoc, inv_mul_cancel₀ hne, mul_one]
    have h2 := congrArg (fun t : ℝ => t * (1 - x ^ q)) huniq
    rw [one_mul] at h2
    rw [h2]
    exact h1
  exact hclear.symm

/-- **Parity sieve, even residue class** (`s = q = 2`): the forced leading
equation is `x^2 = 1/2`, i.e. `x = 1/√2`. -/
theorem leading_forced_parity_even {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1)
    (h : HasSum (fun k : ℕ => x ^ (2 * k + 2)) 1) : x ^ 2 = 1 / 2 := by
  have h2 := leading_forced_of_hasSum_geom (q := 2) (s := 2) (by norm_num) (by norm_num)
    hx0 hx1 h
  linarith

/-- **Parity sieve, odd residue class** (`s = 1`, `q = 2`): the forced leading
equation is `x^2 + x = 1`, i.e. `x = (√5−1)/2`. -/
theorem leading_forced_parity_odd {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1)
    (h : HasSum (fun k : ℕ => x ^ (2 * k + 1)) 1) : x ^ 2 + x = 1 := by
  have h2 := leading_forced_of_hasSum_geom (q := 2) (s := 1) (by norm_num) (by norm_num)
    hx0 hx1 h
  have h3 : x = 1 - x ^ 2 := by simpa using h2
  linarith

/-- The even-parity constant, explicitly. -/
theorem leading_forced_parity_even_eq {x : ℝ} (hx0 : 0 ≤ x) (h : x ^ 2 = 1 / 2) :
    x = Real.sqrt (1 / 2) := by
  rw [← Real.sqrt_sq hx0, h]

/-- The odd-parity constant, explicitly: the golden-ratio conjugate. -/
theorem leading_forced_parity_odd_eq {x : ℝ} (hx0 : 0 ≤ x) (h : x ^ 2 + x = 1) :
    x = (Real.sqrt 5 - 1) / 2 := by
  have hs5 : (Real.sqrt 5) ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  have h2 : (2 * x + 1) ^ 2 = 5 := by nlinarith
  have hsq : (2 * x + 1) ^ 2 = (Real.sqrt 5) ^ 2 := by rw [h2, hs5]
  rcases sq_eq_sq_iff_eq_or_eq_neg.mp hsq with h4 | h4
  · linarith
  · have hnn : (0 : ℝ) ≤ Real.sqrt 5 := Real.sqrt_nonneg 5
    linarith

end

end Op57
