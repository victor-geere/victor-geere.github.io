/-
ConeLean/ShiftTwoCore.lean — goal 5: the exact deconstruction of the shift-2 Chowla statement.

## ERRATUM (this file was corrected after an external check)

An earlier version of this module described the shift-1 correlation `Σ λ(n)λ(n+1)` as **SOLVED**
(Matomäki–Radziwiłł–Tao).  That is **FALSE**.  The un-averaged Chowla conjecture is open for every
`k ≥ 2`, i.e. for every shift: Matomäki–Radziwiłł–Tao, *An averaged form of Chowla's conjecture*,
Algebra & Number Theory 9 (2015) 2167–2196 (arXiv:1503.05121), state verbatim that the conjecture
"remains unproven for any h_1,...,h_k with k ≥ 2"; what they prove is the average over shifts.  What
is known for `k = 2` is (i) the shift-averaged form (ibid.), (ii) the logarithmically averaged form
(Tao 2015), and (iii) the un-averaged form for all scales outside a set of zero logarithmic density
(Tao–Teräväinen, ANT 13 (2019) 2103–2150, arXiv:1809.02518).  No un-averaged case at a prescribed
scale is known.

## What is actually true (and machine-checked below)

`λ` is completely multiplicative, `λ(mn) = λ(m)λ(n)`.  Hence for even `n = 2j`,
`λ(2j)λ(2j+2) = λ(j)λ(j+1)`, and therefore the **exact identity**

    Σ_{n < 2M} λ(n)λ(n+2) = Σ_{j < M} λ(j)λ(j+1) + Σ_{k < M} λ(2k+1)λ(2k+3)

splitting shift 2 into the shift-1 correlation at half scale plus the **odd core**.  This is an
identity, not a reduction to something known.  Its correct consequence is a **sufficiency**: if both
the shift-1 correlation and the core vanish, then shift 2 vanishes (`shift_two_of_shift_one_and_core`).
The converse FAILS in general — the two halves can cancel — so shift 2 is *not* equivalent to the
core, and (both halves being open) the split does not reduce the problem to a solved case.

Equivalent picture: `λ(n)λ(n+2) = λ((n+1)² − 1)`, so shift 2 is the sum of `λ(m²−1)` over all `m`,
and the two halves above are its odd-`m` and even-`m` parts.  Nothing in the literature distinguishes
the halves.

Everything below is machine-checked and unaffected by the erratum; only the interpretation changed.
-/
import ConeLean.ChowlaEquiv

namespace ConeLean

open scoped BigOperators Topology
open Finset
open ArithmeticFunction

/-- Complete multiplicativity of `lam`, at the level of real numbers. -/
theorem lam_mul (m n : ℕ) : lam (m * n) = lam m * lam n := by
  rw [lam, lam, lam, liouville_apply_mul]
  push_cast
  ring

theorem lam_two : lam 2 = -1 := by
  rw [lam]
  norm_num [show liouville 2 = -1 from by native_decide]

/-- **The 2-adic identity**: the even part of the shift-2 correlation *is* the shift-1 correlation.
(An identity — note that shift 1 is itself open, so this is not a reduction to a known case.) -/
theorem lam_even_shift_two (j : ℕ) : lam (2 * j) * lam (2 * j + 2) = lam j * lam (j + 1) := by
  have h1 : lam (2 * j) = lam 2 * lam j := by rw [lam_mul]
  have h2 : lam (2 * j + 2) = lam 2 * lam (j + 1) := by
    rw [show 2 * j + 2 = 2 * (j + 1) by ring, lam_mul]
  rw [h1, h2, lam_two]
  ring

/-- **The parity split of the shift-2 correlation** (an identity, valid for every `M`). -/
theorem chowlaSum_shift_two_split (M : ℕ) :
    ∑ n ∈ Finset.range (2 * M), lam n * lam (n + 2)
      = (∑ j ∈ Finset.range M, lam j * lam (j + 1))
        + (∑ k ∈ Finset.range M, lam (2 * k + 1) * lam (2 * k + 3)) := by
  induction M with
  | zero => simp
  | succ M ih =>
      have h2M : 2 * (M + 1) = 2 * M + 2 := by ring
      rw [h2M, Finset.sum_range_succ, Finset.sum_range_succ, ih,
        Finset.sum_range_succ, Finset.sum_range_succ]
      have heven : lam (2 * M) * lam (2 * M + 2) = lam M * lam (M + 1) :=
        lam_even_shift_two M
      have hodd : lam (2 * M + 1) * lam (2 * M + 1 + 2)
          = lam (2 * M + 1) * lam (2 * M + 3) := by ring_nf
      rw [heven, hodd]
      ring

/-- **No further reduction of the shift exists**: `2` is the only prime dividing both `n` and
`n + 2`.  So the substitution used above is the only one of its kind. -/
theorem prime_dvd_shift_two {p n : ℕ} (hp : p.Prime) (h1 : p ∣ n) (h2 : p ∣ n + 2) : p = 2 := by
  have h : p ∣ 2 := by
    have h' := Nat.dvd_sub h2 h1
    rwa [Nat.add_sub_cancel_left] at h'
  rcases (Nat.dvd_prime Nat.prime_two).mp h with h1' | h2'
  · exact absurd h1' hp.ne_one
  · exact h2'

/-- **The core is a difference of squares**: `(2k+1)(2k+3) = (2k+2)^2 - 1`. -/
theorem core_diff_squares (k : ℕ) : (2 * k + 1) * (2 * k + 3) = (2 * k + 2) ^ 2 - 1 := by
  have h : (2 * k + 1) * (2 * k + 3) + 1 = (2 * k + 2) ^ 2 := by ring
  omega

/-- **The core's arguments are coprime** (so no shared-factor mechanism is available there). -/
theorem core_coprime (k : ℕ) : Nat.Coprime (2 * k + 1) (2 * k + 3) := by
  rw [Nat.coprime_iff_gcd_eq_one]
  have h : Nat.gcd (2 * k + 1) (2 * k + 3) ∣ 2 := by
    have hsub : Nat.gcd (2 * k + 1) (2 * k + 3) ∣ (2 * k + 3) - (2 * k + 1) :=
      Nat.dvd_sub (Nat.gcd_dvd_right (2 * k + 1) (2 * k + 3))
        (Nat.gcd_dvd_left (2 * k + 1) (2 * k + 3))
    have hval : (2 * k + 3) - (2 * k + 1) = 2 := by omega
    rwa [hval] at hsub
  have hodd : ¬ (2 ∣ 2 * k + 1) := by
    intro hd
    obtain ⟨c, hc⟩ := hd
    omega
  rcases (Nat.dvd_prime Nat.prime_two).mp h with h1' | h2'
  · exact h1'
  · have hdvd : Nat.gcd (2 * k + 1) (2 * k + 3) ∣ 2 * k + 1 := Nat.gcd_dvd_left _ _
    rw [h2'] at hdvd
    exact absurd hdvd hodd

/-! ## 3. The core is not multiplicative either -/

/-- **The core sequence `k ↦ λ(2k+1)λ(2k+3)` is not multiplicative.**  Witness: `k = 2`, `m = 5`
(coprime), where the core at `km = 10` is `λ(21)λ(23) = -1` while the product of the core values is
`+1`.  So the Euler-product/Perron route is closed for the core as well, not merely for the
unrestricted shift-2 sequence. -/
theorem core_not_multiplicative :
    liouville (2 * 10 + 1) * liouville (2 * 10 + 3)
      ≠ (liouville (2 * 2 + 1) * liouville (2 * 2 + 3))
        * (liouville (2 * 5 + 1) * liouville (2 * 5 + 3)) := by
  native_decide

/-- The same witness in the normalization used by `lam`. -/
theorem core_not_multiplicative_lam :
    lam 21 * lam 23 ≠ (lam 5 * lam 7) * (lam 11 * lam 13) := by
  intro h
  have h' : ((liouville 21 * liouville 23 : ℤ) : ℝ)
      = (((liouville 5 * liouville 7) * (liouville 11 * liouville 13) : ℤ) : ℝ) := by
    simpa only [lam, ← Int.cast_mul] using h
  exact core_not_multiplicative (by exact_mod_cast h')

/-! ## 4. The core is a shift-1 correlation of a NON-multiplicative sequence -/

/-- The sequence underlying the core: `g k = λ(2k+1)`.  The core is then exactly
`Σ_{k<K} g k * g (k+1)` — a shift-1 two-point correlation, of this sequence rather than of `λ`.
(Shift 1 itself is open, so this is a restatement, not a reduction.) -/
def oddLam (k : ℕ) : ℤ := liouville (2 * k + 1)

/-- **`oddLam` is not multiplicative** — witness `k = 3`, `m = 5` (coprime):
`g 15 = λ(31) = -1` while `g 3 * g 5 = λ(7)λ(11) = +1`.  This is the structural reason the
Matomäki–Radziwiłł–Tao mechanism, which consumes multiplicativity, has nothing to consume in the
core.  (It is a reason, not a proof that the method cannot be adapted.) -/
theorem oddLam_not_multiplicative :
    oddLam (3 * 5) ≠ oddLam 3 * oddLam 5 := by
  native_decide

/-! ## 5. The correct consequence: sufficiency, not equivalence -/

/-- **What the split actually gives.**  If the shift-1 correlation vanishes and the core vanishes
then shift 2 vanishes — a *sufficiency*.  The converse fails in general (the two halves can cancel),
and both hypotheses are open; so this does not reduce shift 2 to a solved case. -/
theorem shift_two_of_shift_one_and_core
    (h1 : Filter.Tendsto
      (fun M : ℕ => (∑ j ∈ Finset.range M, lam j * lam (j + 1)) / (M : ℝ))
      Filter.atTop (𝓝 0))
    (hc : Filter.Tendsto
      (fun M : ℕ => (∑ k ∈ Finset.range M, lam (2 * k + 1) * lam (2 * k + 3)) / (M : ℝ))
      Filter.atTop (𝓝 0)) :
    Filter.Tendsto
      (fun M : ℕ => (∑ n ∈ Finset.range (2 * M), lam n * lam (n + 2)) / (2 * (M : ℝ)))
      Filter.atTop (𝓝 0) := by
  have hsum : Filter.Tendsto
      (fun M : ℕ => ((∑ j ∈ Finset.range M, lam j * lam (j + 1))
        + (∑ k ∈ Finset.range M, lam (2 * k + 1) * lam (2 * k + 3))) / (M : ℝ))
      Filter.atTop (𝓝 0) := by
    have := h1.add hc
    simpa [add_div] using this
  have h2 : Filter.Tendsto
      (fun M : ℕ => ((∑ j ∈ Finset.range M, lam j * lam (j + 1))
        + (∑ k ∈ Finset.range M, lam (2 * k + 1) * lam (2 * k + 3))) / (M : ℝ) / 2)
      Filter.atTop (𝓝 0) := by
    have := hsum.div_const 2
    simpa using this
  have hpt : ∀ M : ℕ, (∑ n ∈ Finset.range (2 * M), lam n * lam (n + 2)) / (2 * (M : ℝ))
      = ((∑ j ∈ Finset.range M, lam j * lam (j + 1))
        + (∑ k ∈ Finset.range M, lam (2 * k + 1) * lam (2 * k + 3))) / (M : ℝ) / 2 := by
    intro M
    rcases Nat.eq_zero_or_pos M with rfl | hM
    · simp
    · rw [chowlaSum_shift_two_split M]
      have hM0 : (M : ℝ) ≠ 0 := by exact_mod_cast Nat.pos_iff_ne_zero.mp hM
      field_simp
  simpa only [hpt] using h2

end ConeLean
