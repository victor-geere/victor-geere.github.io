import Mathlib

/-!
# A Taylor remainder for `cos` on `|x| ≤ 1`

Mathlib has no cos Taylor remainder.  For `|x| ≤ 1` one follows from
`Complex.exp_bound` at `x·i`, taking real parts:

```
|cos x − Re(Σ_{m<n} (x i)^m/m!)| ≤ |x|^n · (n+1)/(n!·n).
```
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

theorem re_cos_ofReal (x : ℝ) : (Complex.cos ((x : ℝ) : ℂ)).re = Real.cos x := by
  rw [← Complex.ofReal_cos, Complex.ofReal_re]

theorem re_exp_mul_I (x : ℝ) : (Complex.exp ((x : ℂ) * Complex.I)).re = Real.cos x := by
  rw [Complex.exp_mul_I]
  simp only [Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re,
    Complex.I_im, mul_zero, sub_zero]
  rw [re_cos_ofReal]
  have hsin : (Complex.sin ((x : ℝ) : ℂ)).im = 0 := by
    rw [← Complex.ofReal_sin, Complex.ofReal_im]
  rw [hsin]
  ring

/-- **Cos Taylor remainder on `|x| ≤ 1`.** -/
theorem cos_bound_small {x : ℝ} (hx : |x| ≤ 1) {n : ℕ} (hn : 0 < n) :
    |Real.cos x -
      (∑ m ∈ Finset.range n, ((x : ℂ) * Complex.I) ^ m / (m.factorial : ℂ)).re| ≤
      |x| ^ n * ((n.succ : ℝ) * ((n.factorial : ℝ) * n)⁻¹) := by
  have hnorm : ‖(x : ℂ) * Complex.I‖ = |x| := by
    rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs]
  have hle : ‖(x : ℂ) * Complex.I‖ ≤ 1 := by rw [hnorm]; exact hx
  have h := Complex.exp_bound (x := (x : ℂ) * Complex.I) hle hn
  rw [hnorm] at h
  have hre : |(Complex.exp ((x : ℂ) * Complex.I) -
      ∑ m ∈ Finset.range n, ((x : ℂ) * Complex.I) ^ m / (m.factorial : ℂ)).re| ≤
      ‖Complex.exp ((x : ℂ) * Complex.I) -
        ∑ m ∈ Finset.range n, ((x : ℂ) * Complex.I) ^ m / (m.factorial : ℂ)‖ :=
    Complex.abs_re_le_norm _
  have hexp : (Complex.exp ((x : ℂ) * Complex.I) -
      ∑ m ∈ Finset.range n, ((x : ℂ) * Complex.I) ^ m / (m.factorial : ℂ)).re =
      Real.cos x - (∑ m ∈ Finset.range n, ((x : ℂ) * Complex.I) ^ m / (m.factorial : ℂ)).re := by
    rw [Complex.sub_re, re_exp_mul_I]
  rw [hexp] at hre
  exact le_trans hre h

/-- The square of a number in `[lo,hi]`, bracketed tightly. -/
theorem sq_mem_Icc {lo hi c : ℝ} (h : c ∈ Set.Icc lo hi) :
    c ^ 2 ∈ Set.Icc (if 0 ≤ lo then lo ^ 2 else if hi ≤ 0 then hi ^ 2 else 0)
      (max (lo ^ 2) (hi ^ 2)) := by
  obtain ⟨hl, hh⟩ := h
  have hmax : c ^ 2 ≤ max (lo ^ 2) (hi ^ 2) := by
    by_cases hc : 0 ≤ c
    · have h1 : c ^ 2 ≤ hi ^ 2 := by nlinarith
      exact le_trans h1 (le_max_right _ _)
    · have h1 : c ^ 2 ≤ lo ^ 2 := by nlinarith
      exact le_trans h1 (le_max_left _ _)
  refine ⟨?_, hmax⟩
  split_ifs with h1 h2
  · have : lo ^ 2 ≤ c ^ 2 := by nlinarith
    exact this
  · have : hi ^ 2 ≤ c ^ 2 := by nlinarith
    exact this
  · positivity

/-- **The doubling step for `cos`.** -/
theorem cos_double_mem {lo hi y : ℝ} (h : Real.cos y ∈ Set.Icc lo hi) :
    Real.cos (2 * y) ∈ Set.Icc (2 * (if 0 ≤ lo then lo ^ 2 else if hi ≤ 0 then hi ^ 2 else 0) - 1)
      (2 * max (lo ^ 2) (hi ^ 2) - 1) := by
  rw [Real.cos_two_mul]
  have hs := sq_mem_Icc h
  obtain ⟨hs1, hs2⟩ := hs
  constructor
  · linarith [hs1]
  · linarith [hs2]

/-- The doubling step, positive branch (avoids `if`/`max` in the numeric goals). -/
theorem cos_double_mem_pos {lo hi y nlo nhi : ℝ} (h : Real.cos y ∈ Set.Icc lo hi)
    (h0 : 0 ≤ lo) (hmax : max (lo ^ 2) (hi ^ 2) = hi ^ 2)
    (h1 : nlo ≤ 2 * lo ^ 2 - 1) (h2 : 2 * hi ^ 2 - 1 ≤ nhi) :
    Real.cos (2 * y) ∈ Set.Icc nlo nhi := by
  have hd := cos_double_mem h
  simp only [if_pos h0, hmax] at hd
  exact ⟨le_trans h1 hd.1, le_trans hd.2 h2⟩

/-- The doubling step, negative branch. -/
theorem cos_double_mem_neg {lo hi y nlo nhi : ℝ} (h : Real.cos y ∈ Set.Icc lo hi)
    (h0 : hi < 0) (hmax : max (lo ^ 2) (hi ^ 2) = lo ^ 2)
    (h1 : nlo ≤ 2 * hi ^ 2 - 1) (h2 : 2 * lo ^ 2 - 1 ≤ nhi) :
    Real.cos (2 * y) ∈ Set.Icc nlo nhi := by
  have hd := cos_double_mem h
  have hlo : ¬ (0 ≤ lo) := by
    intro hpos
    linarith [h.1, h.2, hpos, h0]
  simp only [if_neg hlo, if_pos h0.le, hmax] at hd
  exact ⟨le_trans h1 hd.1, le_trans hd.2 h2⟩

/-- The doubling step, mixed-sign branch. -/
theorem cos_double_mem_mixed {lo hi y nlo nhi : ℝ} (h : Real.cos y ∈ Set.Icc lo hi)
    (h0 : ¬ 0 ≤ lo) (h1 : ¬ hi ≤ 0) (h2 : nlo ≤ -1)
    (h3 : 2 * (max (lo ^ 2) (hi ^ 2)) - 1 ≤ nhi) :
    Real.cos (2 * y) ∈ Set.Icc nlo nhi := by
  have hd := cos_double_mem h
  simp only [if_neg h0, if_neg h1] at hd
  exact ⟨by linarith [h2, hd.1], le_trans hd.2 h3⟩

end PrimeSpectrumTensor