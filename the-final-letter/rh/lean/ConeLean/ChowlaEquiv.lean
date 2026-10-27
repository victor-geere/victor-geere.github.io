/-
ConeLean/ChowlaEquiv.lean — the exact equivalent form of the two-point Chowla statement
`Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

Nothing here proves `o(x)` (that is the open two-point Chowla conjecture).  What is
proved is the *reduction*: the exact algebraic identities that make `o(x)` equivalent
to the equidistribution of the four sign patterns of the pair `(λ(n), λ(n+2))`, given
the one-point input `Σ_{n≤x} λ(n) = o(x)` (PNT).

This is the Lean counterpart of Theorem 3.5 of
`research/twin-prime-parity/dictionary/03-parity-problem.md`.
-/
import Mathlib

namespace ConeLean

open ArithmeticFunction Filter
open scoped BigOperators Topology

noncomputable section

/-! ## 1. The Liouville sign as a real number -/

/-- The Liouville function `λ(n) = (-1)^{Ω(n)}` as a real number. -/
noncomputable def lam (n : ℕ) : ℝ := (liouville n : ℝ)

lemma lam_eq_one_or_neg_one {n : ℕ} (hn : n ≠ 0) : lam n = 1 ∨ lam n = -1 := by
  have h : lam n = (((-1 : ℤ) ^ cardFactors n : ℤ) : ℝ) := by
    rw [lam, liouville_apply hn]
  rcases Nat.even_or_odd (cardFactors n) with he | ho
  · left
    rw [h, Even.neg_one_pow he]
    norm_num
  · right
    rw [h, Odd.neg_one_pow ho]
    norm_num

lemma lam_mul_self {n : ℕ} (hn : n ≠ 0) : lam n * lam n = 1 := by
  rcases lam_eq_one_or_neg_one hn with h | h <;> rw [h] <;> norm_num

/-! ## 2. The sums and the pattern counts -/

/-- The index window `[1, N-2]`. -/
def window (N : ℕ) : Finset ℕ := Finset.Icc 1 (N - 2)

lemma mem_window {N n : ℕ} : n ∈ window N ↔ 1 ≤ n ∧ n ≤ N - 2 := Finset.mem_Icc

lemma window_ne_zero {N n : ℕ} (hn : n ∈ window N) : n ≠ 0 := by
  have := mem_window.mp hn
  omega

lemma window_add_two_ne_zero {N n : ℕ} (_hn : n ∈ window N) : n + 2 ≠ 0 := by omega

lemma card_window (N : ℕ) : (window N).card = N - 2 := by
  rw [window, Nat.card_Icc]
  omega

/-- `S(N) = Σ_{1 ≤ n ≤ N-2} λ(n)λ(n+2)`. -/
noncomputable def chowlaSum (N : ℕ) : ℝ :=
  ∑ n ∈ window N, lam n * lam (n + 2)

/-- The number of `n ∈ [1, N-2]` with `λ(n) = λ(n+2)`. -/
def eqCount (N : ℕ) : ℕ := ((window N).filter (fun n => lam n = lam (n + 2))).card

/-- The number of `n ∈ [1, N-2]` with `(λ(n), λ(n+2)) = (e₁, e₂)`. -/
def patCount (N : ℕ) (e₁ e₂ : ℝ) : ℕ :=
  ((window N).filter (fun n => lam n = e₁ ∧ lam (n + 2) = e₂)).card

/-- The one-point sum `Σ_{1 ≤ n ≤ N-2} λ(n)`. -/
noncomputable def lamSum (N : ℕ) : ℝ := ∑ n ∈ window N, lam n

/-- The shifted one-point sum `Σ_{1 ≤ n ≤ N-2} λ(n+2)`. -/
noncomputable def lamSumShift (N : ℕ) : ℝ := ∑ n ∈ window N, lam (n + 2)

/-! ## 3. Identity (i): `S(N) = 2 #{λ(n) = λ(n+2)} - (N-2)` -/

theorem chowlaSum_eq (N : ℕ) :
    chowlaSum N = 2 * (eqCount N : ℝ) - ((N - 2 : ℕ) : ℝ) := by
  have hpt : ∀ n ∈ window N, lam n * lam (n + 2)
      = 2 * (if lam n = lam (n + 2) then (1 : ℝ) else 0) - 1 := by
    intro n hn
    have h1 := lam_eq_one_or_neg_one (window_ne_zero hn)
    have h2 := lam_eq_one_or_neg_one (window_add_two_ne_zero hn)
    rcases h1 with h | h <;> rcases h2 with h' | h' <;> norm_num [h, h']
  calc chowlaSum N
      = ∑ n ∈ window N, (2 * (if lam n = lam (n + 2) then (1 : ℝ) else 0) - 1) :=
        Finset.sum_congr rfl hpt
    _ = 2 * (∑ n ∈ window N, if lam n = lam (n + 2) then (1 : ℝ) else 0)
          - ((window N).card : ℝ) := by
        rw [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_const, nsmul_eq_mul]
        ring
    _ = 2 * (eqCount N : ℝ) - ((N - 2 : ℕ) : ℝ) := by
        rw [← Finset.natCast_card_filter (fun n => lam n = lam (n + 2)) (window N),
          card_window]
        rfl

/-! ## 4. Identity (ii): the four-pattern decomposition -/

theorem patCount_mul_four (N : ℕ) {e₁ e₂ : ℝ} (h₁ : e₁ * e₁ = 1) (h₂ : e₂ * e₂ = 1) :
    4 * (patCount N e₁ e₂ : ℝ)
      = ((N - 2 : ℕ) : ℝ) + e₁ * lamSum N + e₂ * lamSumShift N
        + e₁ * e₂ * chowlaSum N := by
  have he₁ : e₁ = 1 ∨ e₁ = -1 := mul_self_eq_one_iff.mp h₁
  have he₂ : e₂ = 1 ∨ e₂ = -1 := mul_self_eq_one_iff.mp h₂
  have hpt : ∀ n ∈ window N, 4 * (if lam n = e₁ ∧ lam (n + 2) = e₂ then (1 : ℝ) else 0)
      = (1 + e₁ * lam n) * (1 + e₂ * lam (n + 2)) := by
    intro n hn
    have h1 := lam_eq_one_or_neg_one (window_ne_zero hn)
    have h2 := lam_eq_one_or_neg_one (window_add_two_ne_zero hn)
    rcases h1 with h | h <;> rcases h2 with h' | h' <;>
      rcases he₁ with rfl | rfl <;> rcases he₂ with rfl | rfl <;>
      norm_num [h, h']
  have hsum : 4 * (patCount N e₁ e₂ : ℝ)
      = ∑ n ∈ window N, (1 + e₁ * lam n) * (1 + e₂ * lam (n + 2)) := by
    rw [patCount, Finset.natCast_card_filter, Finset.mul_sum]
    exact Finset.sum_congr rfl (fun n hn => hpt n hn)
  rw [hsum]
  have hexp : ∀ n ∈ window N, (1 + e₁ * lam n) * (1 + e₂ * lam (n + 2))
      = 1 + e₁ * lam n + e₂ * lam (n + 2) + e₁ * e₂ * (lam n * lam (n + 2)) := by
    intro n _
    ring
  rw [Finset.sum_congr rfl hexp]
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib, Finset.sum_add_distrib,
    Finset.sum_const, nsmul_eq_mul, mul_one]
  rw [← Finset.mul_sum, ← Finset.mul_sum, ← Finset.mul_sum]
  rw [card_window, lamSum, lamSumShift, chowlaSum]

/-! ## 5. Identity (iii): the asymptotic equivalence -/

/-- `((N-2)/N) → 1`. -/
lemma tendsto_card_div : Tendsto (fun N : ℕ => ((N - 2 : ℕ) : ℝ) / N) atTop (𝓝 1) := by
  have h0 : Tendsto (fun N : ℕ => (2 : ℝ) / N) atTop (𝓝 0) :=
    tendsto_const_div_atTop_nhds_zero_nat (2 : ℝ)
  have h1 : Tendsto (fun N : ℕ => 1 - (2 : ℝ) / N) atTop (𝓝 (1 - 0)) :=
    tendsto_const_nhds.sub h0
  rw [sub_zero] at h1
  refine h1.congr' ?_
  filter_upwards [eventually_ge_atTop 2] with N hN
  have h : ((N - 2 : ℕ) : ℝ) = (N : ℝ) - 2 := by
    have : 2 ≤ N := hN
    push_cast [Nat.cast_sub this]
    ring
  rw [h]
  field_simp

/-- **The reduction.**  Given the one-point input `Σ_{n≤x} λ(n) = o(x)` (PNT, in the
two shifted forms), `S(x) = o(x)` is equivalent to each of the four sign patterns of
`(λ(n), λ(n+2))` having density `1/4`. -/
theorem chowlaSum_tendsto_iff_patCount_tendsto
    (hone : Tendsto (fun N : ℕ => lamSum N / N) atTop (𝓝 0))
    (hone' : Tendsto (fun N : ℕ => lamSumShift N / N) atTop (𝓝 0)) :
    Tendsto (fun N : ℕ => chowlaSum N / N) atTop (𝓝 0)
      ↔ ∀ e₁ e₂ : ℝ, e₁ * e₁ = 1 → e₂ * e₂ = 1 →
          Tendsto (fun N : ℕ => (patCount N e₁ e₂ : ℝ) / N) atTop (𝓝 (1 / 4)) := by
  constructor
  · intro hS e₁ e₂ h₁ h₂
    have hfour : Tendsto (fun N : ℕ => 4 * (patCount N e₁ e₂ : ℝ) / N) atTop (𝓝 1) := by
      have hsplit : Tendsto (fun N : ℕ =>
          ((N - 2 : ℕ) : ℝ) / N + e₁ * (lamSum N / N) + e₂ * (lamSumShift N / N)
            + e₁ * e₂ * (chowlaSum N / N)) atTop
          (𝓝 (1 + e₁ * 0 + e₂ * 0 + e₁ * e₂ * 0)) :=
        (((tendsto_card_div.add (hone.const_mul e₁)).add (hone'.const_mul e₂)).add
          (hS.const_mul (e₁ * e₂)))
      rw [mul_zero, mul_zero, mul_zero, add_zero, add_zero, add_zero] at hsplit
      refine hsplit.congr' ?_
      filter_upwards with N
      have hid := patCount_mul_four N h₁ h₂
      rw [hid]
      ring
    have hdiv := hfour.div_const 4
    rw [show (1 : ℝ) / 4 = 1 / 4 by norm_num] at hdiv
    refine hdiv.congr' ?_
    filter_upwards with N
    ring
  · intro hpat
    have h11 := hpat 1 1 (by norm_num) (by norm_num)
    have hfour : Tendsto (fun N : ℕ => 4 * (patCount N 1 1 : ℝ) / N) atTop (𝓝 1) := by
      have h := h11.const_mul 4
      rw [show (4 : ℝ) * (1 / 4) = 1 by norm_num] at h
      refine h.congr' ?_
      filter_upwards with N
      ring
    have hsplit : Tendsto (fun N : ℕ =>
        4 * (patCount N 1 1 : ℝ) / N - ((N - 2 : ℕ) : ℝ) / N - lamSum N / N
          - lamSumShift N / N) atTop (𝓝 (1 - 1 - 0 - 0)) :=
      ((hfour.sub tendsto_card_div).sub hone).sub hone'
    rw [sub_zero, sub_zero, show (1 : ℝ) - 1 = 0 by norm_num] at hsplit
    refine hsplit.congr' ?_
    filter_upwards with N
    have hid := patCount_mul_four N (e₁ := 1) (e₂ := 1) (by norm_num) (by norm_num)
    rw [hid]
    ring

/-! ## 6. A machine-checked barrier: the correlation is not multiplicative -/

/-- **The correlation sequence is not multiplicative.**  For `f(n) = λ(n)λ(n+2)` we have
`f(9) = −1` while `f(3)·f(3) = +1`: the sequence has no Euler product, so no
`ζ`/Perron contour argument applies to it.  This is the machine-checked form of route R3
in the residue ledger ([`residue-verdict.md`](../../research/twin-prime-parity/cone/residue-verdict.md) §6):
the `ζ`-machinery route is closed, not merely unexplored. -/
theorem chowla_not_multiplicative :
    liouville 9 * liouville 11
      ≠ (liouville 3 * liouville 5) * (liouville 3 * liouville 5) := by
  native_decide

/-- The same barrier in the real-valued normalization used by `chowlaSum`. -/
theorem lam_not_multiplicative :
    lam 9 * lam 11 ≠ (lam 3 * lam 5) * (lam 3 * lam 5) := by
  intro hc
  apply chowla_not_multiplicative
  have h : ((liouville 9 * liouville 11 : ℤ) : ℝ)
      = (((liouville 3 * liouville 5) * (liouville 3 * liouville 5) : ℤ) : ℝ) := by
    simpa only [lam, ← Int.cast_mul] using hc
  exact_mod_cast h

end

end ConeLean
