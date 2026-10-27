/-
  AllZero.lean — the all-zero factor criterion.

  `TRUTHS.md` §2 lists as *checked* (95 835 cases):

  > The all-zero factor occurs **iff** some gap between consecutive support
  > points — or before the first / after the last — is `≥ L+1`.

  This file proves it for all supports, truncations and window lengths.  The
  "extended support" of the Python check is `[-1] + ones + [N]`; here it is
  shifted by one, which is a bijection on gaps: `extSupport S N` is
  `{0} ∪ {s + 1 : s ∈ S} ∪ {N + 1}`, so its consecutive gaps are exactly
  `a_0 + 1`, the consecutive differences `a_{j+1} - a_j`, and `N - a_m`.
-/
import Rh41.DigitWord

namespace Rh41

open Finset

/-- The shifted extended support: `{0} ∪ {s + 1 : s ∈ S} ∪ {N + 1}`, i.e. the
Python list `[-1] + ones + [N]` shifted up by one. -/
def extSupport (S : Finset ℕ) (N : ℕ) : Finset ℕ :=
  insert 0 (insert (N + 1) (S.image (fun s => s + 1)))

/-- A window of length `L` (inside the truncation) meets no support point. -/
def AllZero (S : Finset ℕ) (N L : ℕ) : Prop :=
  ∃ t, t ≤ N - L ∧ ∀ a ∈ S, ¬ (t ≤ a ∧ a ≤ t + L - 1)

/-- Two consecutive elements of the extended support are at distance `≥ L+1`. -/
def HasLargeGap (S : Finset ℕ) (N L : ℕ) : Prop :=
  ∃ a ∈ extSupport S N, ∃ b ∈ extSupport S N,
    a < b ∧ (∀ c ∈ extSupport S N, a < c → c < b → False) ∧ L + 1 ≤ b - a

lemma mem_extSupport {S : Finset ℕ} {N e : ℕ} :
    e ∈ extSupport S N ↔ e = 0 ∨ e = N + 1 ∨ ∃ s ∈ S, s + 1 = e := by
  simp [extSupport]

/-- **Claim A2.** A window of length `L` avoiding the support exists exactly
when the shifted extended support has a consecutive gap `≥ L + 1`. -/
theorem allZero_iff_hasLargeGap (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N)
    (hL1 : 1 ≤ L) (hLN : L ≤ N) : AllZero S N L ↔ HasLargeGap S N L := by
  classical
  constructor
  · -- every window avoiding `S` sits in a gap of the extended support
    rintro ⟨t, ht, hall⟩
    have hbdd : ∀ e ∈ extSupport S N, e ≤ N + 1 := by
      intro e he
      rw [mem_extSupport] at he
      rcases he with rfl | rfl | ⟨s, hs, rfl⟩
      · omega
      · omega
      · have := hS hs
        rw [mem_range] at this
        omega
    have hA : (extSupport S N).filter (fun e => e ≤ t) |>.Nonempty := by
      refine ⟨0, mem_filter.mpr ⟨mem_extSupport.mpr (Or.inl rfl), by omega⟩⟩
    have hB : (extSupport S N).filter (fun e => t < e) |>.Nonempty := by
      refine ⟨N + 1, mem_filter.mpr ⟨mem_extSupport.mpr (Or.inr (Or.inl rfl)), by omega⟩⟩
    obtain ⟨haEmem, hat⟩ := mem_filter.mp (max'_mem _ hA)
    obtain ⟨hbEmem, hbt⟩ := mem_filter.mp (min'_mem _ hB)
    have hconsec : ∀ c ∈ extSupport S N, max' _ hA < c → c < min' _ hB → False := by
      intro c hcE hac hcb
      rcases le_or_gt c t with hct | hct
      · have hcA : c ∈ (extSupport S N).filter (fun e => e ≤ t) :=
          mem_filter.mpr ⟨hcE, hct⟩
        have := le_max' _ c hcA
        omega
      · have hcB : c ∈ (extSupport S N).filter (fun e => t < e) :=
          mem_filter.mpr ⟨hcE, hct⟩
        have := min'_le _ c hcB
        omega
    refine ⟨max' _ hA, haEmem, min' _ hB, hbEmem, by omega, hconsec, ?_⟩
    -- the gap is at least `L + 1`
    have hb_ge : t + L ≤ min' _ hB := by
      rw [mem_extSupport] at hbEmem
      rcases hbEmem with h0 | hN | ⟨s, hs, hs1⟩
      · omega
      · omega
      · by_contra hcon
        have hs2 : t ≤ s := by omega
        have hs3 : s ≤ t + L - 1 := by omega
        exact hall s hs ⟨hs2, hs3⟩
    rcases lt_or_eq_of_le hat with hat' | hat'
    · omega
    · -- here the gap starts exactly at the window start; one more unit is needed
      have hb_ge' : t + L + 1 ≤ min' _ hB := by
        by_contra hcon
        have hbeq : min' _ hB = t + L := by omega
        rw [mem_extSupport] at hbEmem
        rcases hbEmem with h0 | hN | ⟨s, hs, hs1⟩
        · omega
        · omega
        · have hs2 : t ≤ s := by omega
          have hs3 : s ≤ t + L - 1 := by omega
          exact hall s hs ⟨hs2, hs3⟩
      omega
  · -- a large gap yields a window inside it
    rintro ⟨a, haE, b, hbE, hab, hconsec, hgap⟩
    have hb_le : b ≤ N + 1 := by
      rw [mem_extSupport] at hbE
      rcases hbE with rfl | rfl | ⟨s, hs, rfl⟩
      · omega
      · omega
      · have := hS hs
        rw [mem_range] at this
        omega
    refine ⟨a, ?_, fun s hs => ?_⟩
    · -- the window fits inside the truncation
      have : a + L ≤ N := by omega
      exact (Nat.le_sub_iff_add_le hLN).mpr (by omega)
    · rintro ⟨h1, h2⟩
      have hsE : s + 1 ∈ extSupport S N :=
        mem_extSupport.mpr (Or.inr (Or.inr ⟨s, hs, rfl⟩))
      exact hconsec (s + 1) hsE (by omega) (by omega)

end Rh41
