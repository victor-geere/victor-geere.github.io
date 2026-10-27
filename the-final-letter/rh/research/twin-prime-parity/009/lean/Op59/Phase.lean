/-
  Op59/Phase.lean — the crossing-count bound, and the invisibility of an
  angle-type sign to the pair correlation.

  Let `θ : ℕ → ℝ` be a strictly increasing phase (for the eta angle sign,
  `θ n = t log n`) and `c > 0` a modulus (for the angle sign, `c = π`).  Say
  `n` is a *phase crossing* if `(θ n, θ (n+2))` contains a positive multiple of
  `c`.  Because the intervals `(θ n, θ (n+2))` overlap at most twice, the number
  of crossings up to `N` is at most twice the number of multiples of `c` below
  `θ (N+2)`:

      #phaseCrossing ≤ 2 * (⌊θ(N+2)/c⌋ + 1) .

  Combined with `Op59.sparse_pair_bound`, any `±1`-valued weight whose pair
  crossings are phase crossings changes the shift-2 correlation by at most
  `4 * (⌊θ(N+2)/c⌋ + 1) = O(θ(N+2)/c)`; for `θ n = t log n`, `c = π` this is
  `O(t log N)`.
-/

import Op59.Sparse

namespace Op59

noncomputable section

open scoped BigOperators

open Finset

/-- `n < N` is a phase crossing when `(θ n, θ (n+2))` contains a positive
multiple of `c`. -/
def phaseCrossing (θ : ℕ → ℝ) (c : ℝ) (N : ℕ) : Finset ℕ := by
  classical
  exact (Finset.range N).filter
    (fun n => ∃ k : ℕ, θ n < (k : ℝ) * c ∧ (k : ℝ) * c < θ (n + 2))

/-- **Crossing-count bound** (parametrised form).  If `θ (N+2) ≤ (K+1) c` then
there are at most `2 (K+1)` phase crossings below `N`. -/
theorem phaseCrossing_card_le_of_le (θ : ℕ → ℝ) (c : ℝ) (N K : ℕ)
    (hθ : StrictMono θ) (hc : 0 < c) (hK : θ (N + 2) ≤ ((K : ℝ) + 1) * c) :
    (phaseCrossing θ c N).card ≤ 2 * (K + 1) := by
  classical
  set Xk : ℕ → Finset ℕ := fun k =>
    (Finset.range N).filter (fun n => θ n < (k : ℝ) * c ∧ (k : ℝ) * c < θ (n + 2)) with hXk
  -- any two members of a fibre differ by at most one
  have hpair : ∀ k, ∀ m ∈ Xk k, ∀ m' ∈ Xk k, m ≤ m' + 1 := by
    intro k m hm m' hm'
    simp only [hXk, Finset.mem_filter] at hm hm'
    by_contra hcon
    push_neg at hcon
    have hmono : θ (m' + 2) ≤ θ m := hθ.monotone (by omega)
    linarith [hm.2.1, hm'.2.2]
  have hfib : ∀ k, (Xk k).card ≤ 2 := by
    intro k
    by_cases hne : (Xk k).Nonempty
    · obtain ⟨n0, hn0⟩ := hne
      by_cases hnext : n0 + 1 ∈ Xk k
      · have hsub : Xk k ⊆ ({n0, n0 + 1} : Finset ℕ) := by
          intro m hm
          have h1 : m ≤ n0 + 1 := hpair k m hm n0 hn0
          have h3 : n0 ≤ m := by
            by_contra hc'
            push_neg at hc'
            have h5 := hpair k (n0 + 1) hnext m hm
            omega
          simp only [Finset.mem_insert, Finset.mem_singleton]
          omega
        calc (Xk k).card ≤ ({n0, n0 + 1} : Finset ℕ).card := Finset.card_le_card hsub
          _ ≤ 2 := by simp
      · have hsub : Xk k ⊆ ({n0 - 1, n0} : Finset ℕ) := by
          intro m hm
          have h2 : n0 ≤ m + 1 := hpair k n0 hn0 m hm
          have h3 : m ≤ n0 := by
            by_contra hc'
            push_neg at hc'
            have h4 := hpair k m hm n0 hn0
            have h5 : m = n0 + 1 := by omega
            rw [h5] at hm
            exact hnext hm
          simp only [Finset.mem_insert, Finset.mem_singleton]
          omega
        calc (Xk k).card ≤ ({n0 - 1, n0} : Finset ℕ).card := Finset.card_le_card hsub
          _ ≤ ({n0} : Finset ℕ).card + 1 := Finset.card_insert_le _ _
          _ = 2 := by simp
    · rw [Finset.not_nonempty_iff_eq_empty] at hne
      rw [hne, Finset.card_empty]
      omega
  have hsub : phaseCrossing θ c N ⊆ (Finset.range (K + 1)).biUnion Xk := by
    intro n hn
    simp only [phaseCrossing, Finset.mem_filter] at hn
    obtain ⟨hnN, k, hk1, hk2⟩ := hn
    have hkN : k < K + 1 := by
      have hnN' : n + 2 ≤ N + 2 := by have := Finset.mem_range.mp hnN; omega
      have hle : θ (n + 2) ≤ θ (N + 2) := hθ.monotone hnN'
      have hlt : (k : ℝ) * c < ((K : ℝ) + 1) * c := lt_of_lt_of_le (lt_of_lt_of_le hk2 hle) hK
      have hdiv : (k : ℝ) < (K : ℝ) + 1 :=
        (mul_lt_mul_iff_of_pos_right hc).mp hlt
      exact_mod_cast hdiv
    exact Finset.mem_biUnion.mpr ⟨k, Finset.mem_range.mpr hkN,
      Finset.mem_filter.mpr ⟨hnN, hk1, hk2⟩⟩
  calc (phaseCrossing θ c N).card
      ≤ ((Finset.range (K + 1)).biUnion Xk).card := Finset.card_le_card hsub
    _ ≤ ∑ k ∈ Finset.range (K + 1), (Xk k).card := Finset.card_biUnion_le
    _ ≤ ∑ _k ∈ Finset.range (K + 1), 2 := Finset.sum_le_sum (fun k _ => hfib k)
    _ = 2 * (K + 1) := by
        rw [Finset.sum_const, smul_eq_mul, Finset.card_range]; ring

/-- **Crossing-count bound** with the natural constant `K = ⌊θ(N+2)/c⌋`. -/
theorem phaseCrossing_card_le (θ : ℕ → ℝ) (c : ℝ) (N : ℕ)
    (hθ : StrictMono θ) (hc : 0 < c) (_h0 : 0 ≤ θ 0) :
    (phaseCrossing θ c N).card ≤ 2 * (Nat.floor (θ (N + 2) / c) + 1) := by
  have hK : θ (N + 2) ≤ ((Nat.floor (θ (N + 2) / c) : ℝ) + 1) * c := by
    have h := Nat.lt_floor_add_one (θ (N + 2) / c)
    have hmul : θ (N + 2) / c * c < ((Nat.floor (θ (N + 2) / c) : ℝ) + 1) * c :=
      mul_lt_mul_of_pos_right h hc
    rw [div_mul_cancel₀ _ (ne_of_gt hc)] at hmul
    exact le_of_lt hmul
  exact phaseCrossing_card_le_of_le θ c N (Nat.floor (θ (N + 2) / c)) hθ hc hK

/-- **Angle-sign invisibility.** If every pair crossing of a `±1`-valued weight
`w` is a phase crossing, the symmetric twist changes the correlation by at most
`4 * (⌊θ(N+2)/c⌋ + 1)`. -/
theorem angle_twist_invisible (a w : ℕ → ℤ) (θ : ℕ → ℝ) (c : ℝ) (N : ℕ)
    (ha : ∀ n, |a n| ≤ 1) (hw : ∀ n, w n = 1 ∨ w n = -1)
    (hθ : StrictMono θ) (hc : 0 < c) (h0 : 0 ≤ θ 0)
    (hphase : ∀ n, w n * w (n + 2) ≠ 1 → ∃ k : ℕ, θ n < (k : ℝ) * c ∧ (k : ℝ) * c < θ (n + 2)) :
    |∑ n ∈ Finset.range N, a n * w n * w (n + 2) - ∑ n ∈ Finset.range N, a n|
      ≤ 4 * ((Nat.floor (θ (N + 2) / c) + 1 : ℕ) : ℤ) := by
  classical
  have hsub : crossingSet w N ⊆ phaseCrossing θ c N := by
    intro n hn
    simp only [crossingSet, Finset.mem_filter] at hn
    exact Finset.mem_filter.mpr ⟨hn.1, hphase n hn.2⟩
  have hcard : ((crossingSet w N).card : ℤ) ≤ 2 * ((Nat.floor (θ (N + 2) / c) + 1 : ℕ) : ℤ) := by
    have h1 : (crossingSet w N).card ≤ 2 * (Nat.floor (θ (N + 2) / c) + 1) :=
      le_trans (Finset.card_le_card hsub) (phaseCrossing_card_le θ c N hθ hc h0)
    exact_mod_cast h1
  have hdiff : (∑ n ∈ Finset.range N, a n * w n * w (n + 2)) - ∑ n ∈ Finset.range N, a n
      = ∑ n ∈ Finset.range N, a n * (w n * w (n + 2) - 1) := by
    rw [← Finset.sum_sub_distrib]
    exact Finset.sum_congr rfl (fun n _ => by ring)
  rw [hdiff]
  calc |∑ n ∈ Finset.range N, a n * (w n * w (n + 2) - 1)|
      ≤ 2 * ((crossingSet w N).card : ℤ) := sparse_pair_bound a w N ha hw
    _ ≤ 4 * ((Nat.floor (θ (N + 2) / c) + 1 : ℕ) : ℤ) := by linarith

end

end Op59
