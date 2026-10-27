/-
ConeLean/Cone.lean — the critical cone of the note
`research/twin-prime-parity/cone/cone-critical-pair-greedy.md`.

The cone places the `n`-th term of a real Dirichlet series at

    C_n = (n^{-p} cos (t log n),  n^{-p} sin (t log n),  n)  ∈ ℝ³,

so that the **reciprocal radius is the index** `n`.  Everything below is real: no
complex numbers, only real powers.

Formalised here:

* `coneIndex_coneRadius` — the index readout `(n^{-p})^{-1/p} = n`;
* `coneRadius_injective` — the radius determines the index (the helix is the
  degenerate cone `p = 0`, where this fails);
* the critical-cone sandwich `(n+2)^{-1} ≤ (n(n+2))^{-1/2} ≤ n^{-1}`
  (`inv_add_two_le_critWeight`, `critWeight_le_inv`);
* `critWeight_error_le` and `summable_critWeight_error` — the critical weight
  differs from the log-Chowla weight `1/n` by an absolutely summable error, so the
  critical-cone transform is the log-Chowla transform up to `O(1)`;
* `shiftDiff_le` and `summable_shiftDiff` — **the one-power dichotomy**: for every
  `p > 0`, `n^{-p} - (n+2)^{-p} ≤ 2p n^{-p-1}` and the shift-difference series is
  absolutely convergent (the mean value lives only in the *undifferenced* channel);
* `pairSeparation_eq` — at `p = 1` the radial separation is exactly twice the pair
  weight.
-/
import TppLean.Budget

namespace ConeLean

open scoped BigOperators

set_option maxHeartbeats 800000

noncomputable section

/-! ## 1. The cone and its index readout -/

/-- The radial coordinate of the `n`-th term: `r_n = n^{-p}`. -/
def coneRadius (p : ℝ) (n : ℕ) : ℝ := (n : ℝ) ^ (-p)

/-- The index readout from the radius: `ρ ↦ ρ^{-1/p}`. -/
def coneIndex (p : ℝ) (r : ℝ) : ℝ := r ^ (-(1 / p))

/-- **The index is a coordinate.**  For `p ≠ 0` and `n ≥ 1`, the reciprocal radius
`r_n^{-1/p}` is the index itself. -/
lemma coneIndex_coneRadius {p : ℝ} (_hp : p ≠ 0) {n : ℕ} (_hn : 1 ≤ n) :
    coneIndex p (coneRadius p n) = (n : ℝ) := by
  unfold coneIndex coneRadius
  rw [← Real.rpow_mul (Nat.cast_nonneg n)]
  have hmul : (-p) * (-(1 / p)) = 1 := by
    field_simp
  rw [hmul, Real.rpow_one]

lemma coneRadius_pos {p : ℝ} {n : ℕ} (hn : 1 ≤ n) : 0 < coneRadius p n := by
  unfold coneRadius
  exact Real.rpow_pos_of_pos (by exact_mod_cast hn) _

lemma coneRadius_zero {p : ℝ} (hp : p ≠ 0) : coneRadius p 0 = 0 := by
  simp only [coneRadius, Nat.cast_zero]
  exact Real.zero_rpow (neg_ne_zero.mpr hp)

/-- **The radius determines the index.**  (The helix is the case `p = 0`, where the
radius is identically `1` and this fails.) -/
lemma coneRadius_injective {p : ℝ} (hp : 0 < p) : Function.Injective (coneRadius p) := by
  intro m n h
  by_cases hm : m = 0
  · subst hm
    by_cases hn : n = 0
    · exact hn.symm
    · exfalso
      have hpos : 0 < coneRadius p n := coneRadius_pos (Nat.pos_of_ne_zero hn)
      rw [← h, coneRadius_zero (ne_of_gt hp)] at hpos
      exact lt_irrefl 0 hpos
  · by_cases hn : n = 0
    · subst hn
      exfalso
      have hpos : 0 < coneRadius p m := coneRadius_pos (Nat.pos_of_ne_zero hm)
      rw [h, coneRadius_zero (ne_of_gt hp)] at hpos
      exact lt_irrefl 0 hpos
    · have hcast : (m : ℝ) = (n : ℝ) := by
        rw [← coneIndex_coneRadius (p := p) (ne_of_gt hp) (Nat.pos_of_ne_zero hm),
          ← coneIndex_coneRadius (p := p) (ne_of_gt hp) (Nat.pos_of_ne_zero hn), h]
      exact Nat.cast_injective hcast

/-- `ZetaR p = Σ n^{-p}` in the cone's exponent notation. -/
lemma ZetaR_eq_tsum_rpow_neg (p : ℝ) :
    TppLean.ZetaR p = ∑' n : ℕ, ((n : ℝ)) ^ (-p) := by
  refine tsum_congr (fun n => ?_)
  rw [Real.rpow_neg (Nat.cast_nonneg n)]

/-! ## 2. The pair weight and the critical cone -/

/-- The shift-symmetric pair weight `r_n r_{n+2} = (n(n+2))^{-p}`. -/
def pairWeight (p : ℝ) (n : ℕ) : ℝ := ((n : ℝ) * ((n : ℝ) + 2)) ^ (-p)

/-- The critical-cone weight `(n(n+2))^{-1/2}` (the pair weight at `p = 1/2`). -/
def critWeight (n : ℕ) : ℝ := ((n : ℝ) * ((n : ℝ) + 2)) ^ (-(1 / 2 : ℝ))

/-- `(x²)^{-1/2} = x^{-1}` for `x > 0`. -/
lemma rpow_sq_neg_half {x : ℝ} (hx : 0 < x) : (x ^ 2) ^ (-(1 / 2 : ℝ)) = x⁻¹ := by
  have h2 : (x ^ 2 : ℝ) = x ^ (2 : ℝ) := (Real.rpow_natCast x 2).symm
  rw [h2, ← Real.rpow_mul (le_of_lt hx), show (2 : ℝ) * (-(1 / 2)) = -1 by norm_num,
    Real.rpow_neg_one]

/-- **Critical-cone sandwich, lower half**: `(n+2)^{-1} ≤ (n(n+2))^{-1/2}`. -/
lemma inv_add_two_le_critWeight {n : ℕ} (hn : 1 ≤ n) :
    (((n : ℝ) + 2))⁻¹ ≤ critWeight n := by
  have hpos : (0 : ℝ) < (n : ℝ) + 2 := by
    have : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    linarith
  have hle : (n : ℝ) * ((n : ℝ) + 2) ≤ ((n : ℝ) + 2) ^ 2 := by nlinarith
  calc (((n : ℝ) + 2))⁻¹ = (((n : ℝ) + 2) ^ 2) ^ (-(1 / 2 : ℝ)) :=
        (rpow_sq_neg_half hpos).symm
    _ ≤ ((n : ℝ) * ((n : ℝ) + 2)) ^ (-(1 / 2 : ℝ)) :=
        Real.rpow_le_rpow_of_nonpos (by positivity) hle (by norm_num)
    _ = critWeight n := rfl

/-- **Critical-cone sandwich, upper half**: `(n(n+2))^{-1/2} ≤ n^{-1}`. -/
lemma critWeight_le_inv {n : ℕ} (hn : 1 ≤ n) : critWeight n ≤ ((n : ℝ))⁻¹ := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hle : (n : ℝ) ^ 2 ≤ (n : ℝ) * ((n : ℝ) + 2) := by nlinarith
  calc critWeight n = ((n : ℝ) * ((n : ℝ) + 2)) ^ (-(1 / 2 : ℝ)) := rfl
    _ ≤ ((n : ℝ) ^ 2) ^ (-(1 / 2 : ℝ)) :=
        Real.rpow_le_rpow_of_nonpos (by positivity) hle (by norm_num)
    _ = ((n : ℝ))⁻¹ := rpow_sq_neg_half hn0

/-- The critical weight is nonnegative. -/
lemma critWeight_nonneg (n : ℕ) : 0 ≤ critWeight n := by
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn
    simp [critWeight]
  · exact le_of_lt (lt_of_lt_of_le (by positivity : (0:ℝ) < (((n:ℝ)+2))⁻¹)
      (inv_add_two_le_critWeight hn))

/-- **The error of the critical weight.**  `1/n - (n(n+2))^{-1/2} ≤ 2/(n(n+2))`. -/
lemma critWeight_error_le {n : ℕ} (hn : 1 ≤ n) :
    ((n : ℝ))⁻¹ - critWeight n ≤ 2 / ((n : ℝ) * ((n : ℝ) + 2)) := by
  have h1 := inv_add_two_le_critWeight hn
  have hn0 : (n : ℝ) ≠ 0 := by positivity
  have hn2 : (n : ℝ) + 2 ≠ 0 := by positivity
  have h2 : ((n : ℝ))⁻¹ - ((n : ℝ) + 2)⁻¹ = 2 / ((n : ℝ) * ((n : ℝ) + 2)) := by
    field_simp
    ring
  linarith

/-- `Σ 2/(n(n+2))` converges. -/
lemma summable_two_div_mul_add_two :
    Summable fun n : ℕ => (2 : ℝ) / ((n : ℝ) * ((n : ℝ) + 2)) := by
  have hbase : Summable fun n : ℕ => (2 : ℝ) * ((n : ℝ) ^ 2)⁻¹ :=
    ((Real.summable_nat_pow_inv (p := 2)).mpr (by norm_num)).mul_left (2 : ℝ)
  refine Summable.of_nonneg_of_le (fun n => by positivity) (fun n => ?_) hbase
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn; norm_num
  · have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
    rw [div_le_iff₀ (by positivity)]
    have hle : (n : ℝ) ^ 2 ≤ (n : ℝ) * ((n : ℝ) + 2) := by nlinarith
    calc (2 : ℝ) ≤ 2 * ((n : ℝ) ^ 2)⁻¹ * ((n : ℝ) ^ 2) := by
          rw [mul_assoc, inv_mul_cancel₀ (by positivity), mul_one]
      _ ≤ 2 * ((n : ℝ) ^ 2)⁻¹ * ((n : ℝ) * ((n : ℝ) + 2)) := by
          have hpos : (0 : ℝ) < ((n : ℝ) ^ 2)⁻¹ := by positivity
          nlinarith

/-- **The critical weight differs from the log-Chowla weight by a summable error.**
This is why the critical-cone transform is the log-Chowla transform up to `O(1)`. -/
lemma summable_critWeight_error :
    Summable fun n : ℕ => ((n : ℝ))⁻¹ - critWeight n := by
  refine Summable.of_nonneg_of_le (fun n => ?_) (fun n => ?_)
    summable_two_div_mul_add_two
  · rcases Nat.eq_zero_or_pos n with hn | hn
    · subst hn; simp [critWeight]
    · have h := critWeight_le_inv hn
      linarith
  · rcases Nat.eq_zero_or_pos n with hn | hn
    · subst hn; simp [critWeight]
    · exact critWeight_error_le hn

/-- For any bounded correlation `f`, the critical-cone transform and the log-Chowla
transform differ by an absolutely convergent series. -/
lemma summable_critWeight_sub_inv_mul {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1) :
    Summable fun n : ℕ => f n * (critWeight n - ((n : ℝ))⁻¹) := by
  refine Summable.of_norm_bounded (g := fun n : ℕ => ((n : ℝ))⁻¹ - critWeight n)
    summable_critWeight_error (fun n => ?_)
  have hnn : 0 ≤ ((n : ℝ))⁻¹ - critWeight n := by
    rcases Nat.eq_zero_or_pos n with hn | hn
    · subst hn; simp [critWeight]
    · have h := critWeight_le_inv hn
      linarith
  rw [Real.norm_eq_abs, abs_mul, abs_sub_comm, abs_of_nonneg hnn]
  calc |f n| * (((n : ℝ))⁻¹ - critWeight n)
      ≤ 1 * (((n : ℝ))⁻¹ - critWeight n) := by gcongr; exact hf n
    _ = ((n : ℝ))⁻¹ - critWeight n := one_mul _

/-! ## 3. The one-power dichotomy -/

/-- At `p = 1` the radial separation of a pair is exactly twice the pair weight. -/
lemma pairSeparation_eq (n : ℕ) (hn : 1 ≤ n) :
    ((n : ℝ))⁻¹ - (((n : ℝ) + 2))⁻¹ = 2 * pairWeight 1 n := by
  have hn0 : (n : ℝ) ≠ 0 := by positivity
  have hn2 : (n : ℝ) + 2 ≠ 0 := by positivity
  have hw : pairWeight 1 n = ((n : ℝ) * ((n : ℝ) + 2))⁻¹ := by
    rw [pairWeight, Real.rpow_neg_one]
  have hprod : (n : ℝ) * ((n : ℝ) + 2) ≠ 0 := mul_ne_zero hn0 hn2
  rw [hw]
  field_simp
  ring

/-- The shift-difference weight is nonnegative. -/
lemma shiftDiff_nonneg {p : ℝ} (hp : 0 < p) {n : ℕ} (hn : 1 ≤ n) :
    0 ≤ ((n : ℝ)) ^ (-p) - (((n : ℝ) + 2)) ^ (-p) := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hle : (n : ℝ) ≤ (n : ℝ) + 2 := by linarith
  have h := Real.rpow_le_rpow_of_nonpos hn0 hle (show -p ≤ 0 by linarith)
  linarith

/-- **The one-power bound.**  For `p > 0` and `n ≥ 1`,
`n^{-p} - (n+2)^{-p} ≤ 2p n^{-p-1}`: differencing along the shift costs one power. -/
lemma shiftDiff_le {p : ℝ} (hp : 0 < p) {n : ℕ} (hn : 1 ≤ n) :
    ((n : ℝ)) ^ (-p) - (((n : ℝ) + 2)) ^ (-p) ≤ 2 * p * ((n : ℝ)) ^ (-p - 1) := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hderiv : ∀ x ∈ Set.Icc (n : ℝ) ((n : ℝ) + 2),
      HasDerivWithinAt (fun x : ℝ => x ^ (-p)) ((-p) * x ^ (-p - 1))
        (Set.Icc (n : ℝ) ((n : ℝ) + 2)) x := by
    intro x hx
    exact (Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt (lt_of_lt_of_le hn0 hx.1)))).hasDerivWithinAt
  have hbound : ∀ x ∈ Set.Ico (n : ℝ) ((n : ℝ) + 2),
      ‖(-p) * x ^ (-p - 1)‖ ≤ p * ((n : ℝ)) ^ (-p - 1) := by
    intro x hx
    have hx1 : (n : ℝ) ≤ x := (Set.Ico_subset_Icc_self hx).1
    have hx0 : 0 < x := lt_of_lt_of_le hn0 hx1
    have hmono : x ^ (-p - 1) ≤ ((n : ℝ)) ^ (-p - 1) :=
      Real.rpow_le_rpow_of_nonpos hn0 hx1 (by linarith)
    have hxnn : 0 ≤ x ^ (-p - 1) := Real.rpow_nonneg (le_of_lt hx0) _
    rw [Real.norm_eq_abs, abs_mul, abs_neg, abs_of_pos hp, abs_of_nonneg hxnn]
    nlinarith
  have hmain := norm_image_sub_le_of_norm_deriv_le_segment' (a := (n : ℝ))
    (b := (n : ℝ) + 2) (f := fun x : ℝ => x ^ (-p))
    (f' := fun x : ℝ => (-p) * x ^ (-p - 1)) (C := p * ((n : ℝ)) ^ (-p - 1))
    hderiv hbound ((n : ℝ) + 2)
    (show (n : ℝ) + 2 ∈ Set.Icc (n : ℝ) ((n : ℝ) + 2) from ⟨by linarith, le_rfl⟩)
  have hle : (((n : ℝ) + 2)) ^ (-p) ≤ ((n : ℝ)) ^ (-p) :=
    Real.rpow_le_rpow_of_nonpos hn0 (by linarith) (show -p ≤ 0 by linarith)
  have habs : ‖(((n : ℝ) + 2)) ^ (-p) - ((n : ℝ)) ^ (-p)‖
      = ((n : ℝ)) ^ (-p) - (((n : ℝ) + 2)) ^ (-p) := by
    rw [Real.norm_eq_abs, abs_of_nonpos (sub_nonpos.mpr hle)]
    ring
  rw [habs] at hmain
  have h2 : (p * ((n : ℝ)) ^ (-p - 1)) * (((n : ℝ) + 2) - (n : ℝ))
      = 2 * p * ((n : ℝ)) ^ (-p - 1) := by ring
  linarith [hmain, h2.symm.le, h2.le]

/-- **The one-power dichotomy.**  For every `p > 0` the shift-difference series is
absolutely convergent: `Σ |n^{-p} - (n+2)^{-p}| < ∞`. -/
lemma summable_shiftDiff {p : ℝ} (hp : 0 < p) :
    Summable fun n : ℕ => ((n : ℝ)) ^ (-p) - (((n : ℝ) + 2)) ^ (-p) := by
  have hbase : Summable fun n : ℕ => (((n + 1 : ℕ)) : ℝ) ^ (-(p + 1)) := by
    have h : Summable fun n : ℕ => ((((n + 1 : ℕ)) : ℝ) ^ (p + 1))⁻¹ :=
      ((Real.summable_nat_rpow_inv (p := p + 1)).mpr (by linarith)).comp_injective
        Nat.succ_injective
    refine h.congr (fun n => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg (n + 1))]
  have htail : Summable fun n : ℕ =>
      (((n + 1 : ℕ)) : ℝ) ^ (-p) - ((((n + 1 : ℕ)) : ℝ) + 2) ^ (-p) := by
    refine Summable.of_norm_bounded
      (g := fun n : ℕ => (2 * p) * (((n + 1 : ℕ)) : ℝ) ^ (-(p + 1)))
      (hbase.mul_left (2 * p)) (fun n => ?_)
    rw [show -(p + 1) = -p - 1 by ring]
    rw [Real.norm_eq_abs,
      abs_of_nonneg (shiftDiff_nonneg hp (Nat.succ_le_succ (Nat.zero_le n)))]
    have h := shiftDiff_le hp (n := n + 1) (Nat.succ_le_succ (Nat.zero_le n))
    push_cast at h ⊢
    exact h
  exact (summable_nat_add_iff 1).mp htail

end

end ConeLean
