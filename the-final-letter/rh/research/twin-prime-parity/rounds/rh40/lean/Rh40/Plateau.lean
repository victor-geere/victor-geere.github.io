/-
  Plateau.lean — OP-37(c): the corrected plateau-injectivity lemma.

  Setting.  `S ⊆ [0, n)` is a finite support with ones `a_0 < … < a_m`, written
  here as an arbitrary `Finset ℕ` whose maximum is `am`.  For a window start
  `t` the *factor* is the set of offsets of the ones the window `[t, t+L)` meets,

      wfactor S L t = { a - t : a ∈ S, t ≤ a ≤ t + L - 1 },

  and `pcount S n L` is the number of distinct such factors, i.e. `p(L)`.

  The harvested OP-37 statement claimed that on the plateau
  (`p(L) = a_m + 2`) the map `(first-one index, offset) ↦ factor` is injective,
  and the tractability survey reported it true for `N ≥ 2a_m + 3` but left the
  proof open.  The theorem below proves the sharp, hypothesis-free form:

      p(L) ≥ a_m + 2   ⟹   t ↦ wfactor S L t is injective on nonempty windows.

  (Injectivity of the window map is equivalent to injectivity of `(i,x) ↦ factor`,
  because `t = a_i - x` and `i = a_i - x = t` recovers the window start.)

  Proof (no plateau-value theorem needed).  Every nonempty window starts at
  `t ≤ a_m` (it contains a one `a ≤ a_m` with `t ≤ a`), so there are at most
  `a_m + 1` nonempty windows.  If two distinct nonempty windows had the same
  factor, the image of the nonempty windows would have at most `a_m` elements.
  Every window factor is either `∅` or a nonempty-window factor, so
  `p(L) ≤ (image card) + 1 ≤ a_m + 1 < a_m + 2` — a contradiction.

  No `sorry`, no `axiom`.
-/
import Mathlib

namespace Rh40

open Finset

/-- The offset set (factor) of the window `[t, t+L)` in the support `S`. -/
def wfactor (S : Finset ℕ) (L t : ℕ) : Finset ℕ :=
  (S.filter (fun a => t ≤ a ∧ a ≤ t + L - 1)).image (fun a => a - t)

/-- The window starts `0, …, n-L` whose window is nonempty. -/
def nonemptyWindows (S : Finset ℕ) (n L : ℕ) : Finset ℕ :=
  (Finset.range (n - L + 1)).filter (fun t => (wfactor S L t).Nonempty)

/-- The factor complexity `p(L)`: the number of distinct window factors. -/
def pcount (S : Finset ℕ) (n L : ℕ) : ℕ :=
  ((Finset.range (n - L + 1)).image (fun t => wfactor S L t)).card

/-- A window is nonempty only if it starts at or before the last one, so there
are at most `a_m + 1` nonempty windows. -/
theorem nonemptyWindows_card_le (S : Finset ℕ) (am n L : ℕ)
    (hmax : ∀ a ∈ S, a ≤ am) :
    (nonemptyWindows S n L).card ≤ am + 1 := by
  rw [show am + 1 = (Finset.range (am + 1)).card by simp]
  apply Finset.card_le_card
  intro t ht
  rw [nonemptyWindows, Finset.mem_filter] at ht
  obtain ⟨htW, htne⟩ := ht
  rw [Finset.mem_range] at htW ⊢
  obtain ⟨a, ha⟩ := htne
  rw [wfactor, Finset.mem_image] at ha
  obtain ⟨b, hb, _⟩ := ha
  rw [Finset.mem_filter] at hb
  obtain ⟨hbS, htb, _⟩ := hb
  have : b ≤ am := hmax b hbS
  omega

/-- **Corrected plateau injectivity.**  If `p(L) ≥ a_m + 2` then distinct
nonempty windows produce distinct factors. -/
theorem injOn_of_card_ge (S : Finset ℕ) (am n L : ℕ)
    (hmax : ∀ a ∈ S, a ≤ am)
    (hp : am + 2 ≤ pcount S n L) :
    Set.InjOn (fun t => wfactor S L t) (nonemptyWindows S n L) := by
  by_contra h
  have hcard : ((nonemptyWindows S n L).image (fun t => wfactor S L t)).card <
      (nonemptyWindows S n L).card := by
    rw [lt_iff_le_and_ne]
    refine ⟨Finset.card_image_le, fun heq => h ?_⟩
    exact (Finset.card_image_iff).mp heq
  have hsub : (Finset.range (n - L + 1)).image (fun t => wfactor S L t) ⊆
      ((nonemptyWindows S n L).image (fun t => wfactor S L t)) ∪ {∅} := by
    intro f hf
    rw [Finset.mem_image] at hf
    obtain ⟨t, ht, rfl⟩ := hf
    rw [Finset.mem_range] at ht
    rw [Finset.mem_union]
    by_cases hne : (wfactor S L t).Nonempty
    · left
      exact Finset.mem_image.mpr
        ⟨t, Finset.mem_filter.mpr ⟨Finset.mem_range.mpr ht, hne⟩, rfl⟩
    · right
      rw [Finset.mem_singleton]
      exact Finset.not_nonempty_iff_eq_empty.mp hne
  have hpim : pcount S n L ≤
      ((nonemptyWindows S n L).image (fun t => wfactor S L t)).card + 1 := by
    calc pcount S n L
        = ((Finset.range (n - L + 1)).image (fun t => wfactor S L t)).card := rfl
      _ ≤ (((nonemptyWindows S n L).image (fun t => wfactor S L t)) ∪ {∅}).card :=
            Finset.card_le_card hsub
      _ ≤ ((nonemptyWindows S n L).image (fun t => wfactor S L t)).card +
            ({∅} : Finset (Finset ℕ)).card := Finset.card_union_le _ _
      _ = ((nonemptyWindows S n L).image (fun t => wfactor S L t)).card + 1 := by simp
  have hNE : (nonemptyWindows S n L).card ≤ am + 1 := nonemptyWindows_card_le S am n L hmax
  have : pcount S n L ≤ am + 1 := by omega
  omega

end Rh40
