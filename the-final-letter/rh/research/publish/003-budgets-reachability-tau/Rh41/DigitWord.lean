/-
  DigitWord.lean — machine-checked proofs for the combinatorial truths of
  `rh41/TRUTHS.md` (the greedy digit word's factor complexity).

  Every statement in this file is a theorem of Lean 4 + Mathlib; there are no
  `sorry`s and no extra axioms (the only non-constructive ingredient is
  classical logic).  Theorem names quote the items of `TRUTHS.md` in their
  docstrings.

  Conventions (matching `rh41/digitword.py`):
  * a word is given by its support `S : Finset ℕ` and its truncation length `N`;
  * the *factor* at window start `t` of length `L` is the set of offsets
    `{a - t : a ∈ S, t ≤ a ≤ t + L - 1}` — a set of natural numbers, which is
    exactly the record used by the ground-truth layer;
  * `complexity S N L` is the number of distinct such factors over all windows
    `t ∈ [0, N-L]`, i.e. `p(L)`.
-/
import Mathlib

set_option linter.unnecessarySeqFocus false

namespace Rh41

open Finset

/-! ## 1. The combinatorial core -/

/-- The offset set of the support points of `S` lying in the window `[t, t+L-1]`. -/
def factor (S : Finset ℕ) (L t : ℕ) : Finset ℕ :=
  (S.filter (fun a => t ≤ a ∧ a ≤ t + L - 1)).image (fun a => a - t)

/-- `p(L)`: the number of distinct length-`L` factors of the length-`N` truncation. -/
def complexity (S : Finset ℕ) (N L : ℕ) : ℕ :=
  ((range (N - L + 1)).image (fun t => factor S L t)).card

/-- Membership in a factor, unfolded. -/
lemma mem_factor {S : Finset ℕ} {L t x : ℕ} :
    x ∈ factor S L t ↔ ∃ a ∈ S, t ≤ a ∧ a ≤ t + L - 1 ∧ a - t = x := by
  simp only [factor, mem_image, mem_filter]
  constructor
  · rintro ⟨a, ⟨ha, h1, h2⟩, rfl⟩
    exact ⟨a, ha, h1, h2, rfl⟩
  · rintro ⟨a, ha, h1, h2, rfl⟩
    exact ⟨a, ⟨ha, h1, h2⟩, rfl⟩

/-- A factor of a window of length `L ≥ 1` is a set of offsets `< L`. -/
lemma factor_subset_range {S : Finset ℕ} {L t : ℕ} (hL : 1 ≤ L) :
    factor S L t ⊆ range L := by
  intro x hx
  rw [mem_factor] at hx
  obtain ⟨a, -, h1, h2, rfl⟩ := hx
  rw [mem_range, Nat.sub_lt_iff_lt_add' h1]
  exact (Nat.le_sub_one_iff_lt (by omega : 0 < t + L)).mp h2

/-- If the window does not contain the maximum `am` of the support, and
`am + 1 ≤ L`, then the window lies strictly to the right of `am` and the factor
is empty.  (`a_m < L` is what rules out the window lying to the left.) -/
lemma factor_eq_empty_of_not {S : Finset ℕ} {L t am : ℕ} (hmax : ∀ a ∈ S, a ≤ am)
    (hL : am + 1 ≤ L) (h : ¬ (t ≤ am ∧ am ≤ t + L - 1)) : factor S L t = ∅ := by
  rw [← not_nonempty_iff_eq_empty]
  rintro ⟨x, hx⟩
  rw [mem_factor] at hx
  obtain ⟨a, ha, h1, h2, -⟩ := hx
  refine h ⟨le_trans h1 (hmax a ha), ?_⟩
  have h3 : t + L - 1 = t + (L - 1) := Nat.add_sub_assoc (by omega : 1 ≤ L) t
  have h4 : am ≤ L - 1 := by omega
  omega

/-- The negation of "the window contains `a_m`", made explicit: a window that
misses `a_m` starts after it. -/
lemma not_window_iff {am L t : ℕ} (hL : am + 1 ≤ L) :
    ¬ (t ≤ am ∧ am ≤ t + L - 1) ↔ am + 1 ≤ t := by
  constructor
  · intro h
    by_contra hc
    have hct : t ≤ am := by omega
    refine h ⟨hct, ?_⟩
    have h3 : t + L - 1 = t + (L - 1) := Nat.add_sub_assoc (by omega : 1 ≤ L) t
    have h4 : am ≤ L - 1 := by omega
    omega
  · rintro h ⟨h1, -⟩
    omega

/-- A window containing `a_m` produces a nonempty factor. -/
lemma factor_nonempty {S : Finset ℕ} {L t am : ℕ} (ham : am ∈ S)
    (ht : t ≤ am ∧ am ≤ t + L - 1) : (factor S L t).Nonempty :=
  ⟨am - t, by rw [mem_factor]; exact ⟨am, ham, ht.1, ht.2, rfl⟩⟩

/-- Every element of a factor is at most `a_m - t`. -/
lemma factor_le_max_sub {S : Finset ℕ} {L t am : ℕ} (hmax : ∀ a ∈ S, a ≤ am) :
    ∀ y ∈ factor S L t, y ≤ am - t := by
  intro y hy
  rw [mem_factor] at hy
  obtain ⟨a, ha, -, -, rfl⟩ := hy
  exact Nat.sub_le_sub_right (hmax a ha) t

/-- The factor of a window containing `a_m` has `a_m - t` as its maximum. -/
lemma max'_factor_eq {S : Finset ℕ} {L t am : ℕ} (hmax : ∀ a ∈ S, a ≤ am)
    (ht : t ≤ am ∧ am ≤ t + L - 1) (ham : am ∈ S) :
    (factor S L t).max' (factor_nonempty ham ht) = am - t := by
  refine le_antisymm ?_ ?_
  · exact max'_le _ _ _ (factor_le_max_sub hmax)
  · exact le_max' _ _ (by rw [mem_factor]; exact ⟨am, ham, ht.1, ht.2, rfl⟩)

/-! ## 2. Theorem 1 — the main complexity law

`TRUTHS.md` Theorem 1 states the formula for `L ≥ max(span, a_m + 1)`.  The
proof below only uses `L ≥ a_m + 1` (the span hypothesis is not needed); the
statement is therefore given in the sharper form, and
`complexity_main_TRUTHS` restates it with the hypotheses exactly as in
`TRUTHS.md`. -/

/-- **Theorem 1 (main).** For `L ≥ a_m + 1` (and `1 ≤ L ≤ N`):

`p(L) = min(a_m + 1, N - L + 1) + [L ≤ N - a_m - 1]`.

The `+1` is the single all-zero factor, which occurs exactly when a window of
length `L` fits strictly to the right of `a_m`. -/
theorem complexity_main (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hL1 : 1 ≤ L) (hLN : L ≤ N) (hL : S.max' hne + 1 ≤ L) :
    complexity S N L = min (S.max' hne + 1) (N - L + 1)
      + (if L ≤ N - S.max' hne - 1 then 1 else 0) := by
  classical
  set am := S.max' hne with ham
  have hmax : ∀ a ∈ S, a ≤ am := fun a ha => by rw [ham]; exact le_max' S a ha
  have hmem_am : am ∈ S := by rw [ham]; exact max'_mem S hne
  have hmem_am_lt : am < N := by have := hS hmem_am; rwa [mem_range] at this
  have hL' : am + 1 ≤ L := hL
  -- the two classes of windows
  set Wm := (range (N - L + 1)).filter (fun t => t ≤ am ∧ am ≤ t + L - 1) with hWm
  set Wz := (range (N - L + 1)).filter (fun t => ¬ (t ≤ am ∧ am ≤ t + L - 1)) with hWz
  have hW : Wm ∪ Wz = range (N - L + 1) := by
    ext t
    simp only [hWm, hWz, mem_union, mem_filter]
    constructor
    · rintro (⟨h, -⟩ | ⟨h, -⟩) <;> exact h
    · intro h
      by_cases hp : t ≤ am ∧ am ≤ t + L - 1
      · exact Or.inl ⟨h, hp⟩
      · exact Or.inr ⟨h, hp⟩
  have hdisj : Disjoint (Wm.image (factor S L)) (Wz.image (factor S L)) := by
    rw [disjoint_left]
    intro x hx1 hx2
    rw [mem_image] at hx1 hx2
    obtain ⟨t, ht, rfl⟩ := hx1
    obtain ⟨t', ht', ht'eq⟩ := hx2
    have htP : t ≤ am ∧ am ≤ t + L - 1 := (mem_filter.mp ht).2
    have ht'P : ¬ (t' ≤ am ∧ am ≤ t' + L - 1) := (mem_filter.mp ht').2
    have hne0 : (factor S L t).Nonempty := factor_nonempty hmem_am htP
    rw [← ht'eq, factor_eq_empty_of_not hmax hL' ht'P] at hne0
    simp at hne0
  have hinj : Set.InjOn (factor S L) ↑Wm := by
    intro t ht t' ht' heq
    have htP : t ≤ am ∧ am ≤ t + L - 1 := (mem_filter.mp ht).2
    have ht'P : t' ≤ am ∧ am ≤ t' + L - 1 := (mem_filter.mp ht').2
    have hm1 : am - t ∈ factor S L t' := by
      rw [← heq, mem_factor]
      exact ⟨am, hmem_am, htP.1, htP.2, rfl⟩
    have hm2 : am - t' ∈ factor S L t := by
      rw [heq, mem_factor]
      exact ⟨am, hmem_am, ht'P.1, ht'P.2, rfl⟩
    have h1 : am - t ≤ am - t' := factor_le_max_sub hmax (t := t') (am - t) hm1
    have h2 : am - t' ≤ am - t := factor_le_max_sub hmax (t := t) (am - t') hm2
    omega
  have hcard1 : (Wm.image (factor S L)).card = min (N - L + 1) (am + 1) := by
    rw [card_image_of_injOn hinj]
    have heq : Wm = range (min (N - L + 1) (am + 1)) := by
      ext t
      simp only [hWm, mem_filter, mem_range]
      constructor
      · rintro ⟨h1, h2, -⟩
        omega
      · intro h
        refine ⟨by omega, by omega, ?_⟩
        have h3 : t + L - 1 = t + (L - 1) := Nat.add_sub_assoc hL1 t
        have h4 : am ≤ L - 1 := by omega
        omega
    rw [heq, card_range]
  have hcard2 : (Wz.image (factor S L)).card = if L ≤ N - am - 1 then 1 else 0 := by
    have hz : ∀ t ∈ Wz, factor S L t = ∅ :=
      fun t ht => factor_eq_empty_of_not hmax hL' (mem_filter.mp ht).2
    have hne : Wz.Nonempty ↔ L ≤ N - am - 1 := by
      constructor
      · rintro ⟨t, ht⟩
        obtain ⟨ht1, ht2⟩ := mem_filter.mp ht
        rw [mem_range] at ht1
        have : am + 1 ≤ t := (not_window_iff hL').mp ht2
        omega
      · intro h
        refine ⟨am + 1, mem_filter.mpr ⟨?_, ?_⟩⟩
        · rw [mem_range]; omega
        · exact fun hc => absurd hc.1 (by omega)
    by_cases h : L ≤ N - am - 1
    · rw [ite_eq_left h]
      obtain ⟨t, ht⟩ := hne.mpr h
      have himg : Wz.image (factor S L) = {∅} := by
        ext x
        rw [mem_image, mem_singleton]
        constructor
        · rintro ⟨u, hu, rfl⟩; exact hz u hu
        · intro hx; exact ⟨t, ht, by rw [hx]; exact hz t ht⟩
      rw [himg, card_singleton]
    · rw [ite_eq_right h]
      have hempty : Wz.image (factor S L) = ∅ := by
        rw [image_eq_empty]
        exact not_nonempty_iff_eq_empty.mp fun hne' => h (hne.mp hne')
      rw [hempty, card_empty]
  rw [complexity, ← hW, image_union, card_union_of_disjoint hdisj, hcard1, hcard2, min_comm]

/-- **Theorem 1 (main), as stated in `TRUTHS.md`** — with the redundant
hypothesis `L ≥ span = a_m - a_0` included, to match the source exactly. -/
theorem complexity_main_TRUTHS (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hL1 : 1 ≤ L) (hLN : L ≤ N)
    (hL : max (S.max' hne - S.min' hne) (S.max' hne + 1) ≤ L) :
    complexity S N L = min (S.max' hne + 1) (N - L + 1)
      + (if L ≤ N - S.max' hne - 1 then 1 else 0) :=
  complexity_main S N L hS hne hL1 hLN (le_trans (le_max_right _ _) hL)
/-! ## 3. Corollaries 2–4 and the C1 regime (Theorem 5) -/

/-- The left end of the saturation plateau, `max(span, a_m + 1)`. -/
def plateauStart (S : Finset ℕ) (hne : S.Nonempty) : ℕ :=
  max (S.max' hne - S.min' hne) (S.max' hne + 1)

/-- **Corollary 2 (plateau).** On `max(span, a_m+1) ≤ L ≤ N - a_m - 1` the
complexity is constant, `p(L) = a_m + 2`. -/
theorem complexity_plateau (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hLlo : plateauStart S hne ≤ L) (hLhi : L ≤ N - S.max' hne - 1) :
    complexity S N L = S.max' hne + 2 := by
  have h3 : S.max' hne + 1 ≤ L := le_trans (le_max_right _ _) hLlo
  have h1 : 1 ≤ L := le_trans (by omega : (1:ℕ) ≤ S.max' hne + 1) h3
  have h2 : L ≤ N := by omega
  rw [complexity_main S N L hS hne h1 h2 h3, ite_eq_left hLhi,
    min_eq_left (show S.max' hne + 1 ≤ N - L + 1 by omega)]

/-- **Corollary 3 (decay).** For `L ≥ max(span, a_m+1, N - a_m - 1)` the
complexity decays linearly, `p(L) = N - L + 1`. -/
theorem complexity_decay (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hLN : L ≤ N) (hLlo : max (plateauStart S hne) (N - S.max' hne - 1) ≤ L) :
    complexity S N L = N - L + 1 := by
  have hLplateau : plateauStart S hne ≤ L := le_trans (le_max_left _ _) hLlo
  have h3 : S.max' hne + 1 ≤ L := le_trans (le_max_right _ _) hLplateau
  have h1 : 1 ≤ L := le_trans (by omega : (1:ℕ) ≤ S.max' hne + 1) h3
  have h4 : N - S.max' hne - 1 ≤ L := le_trans (le_max_right _ _) hLlo
  rw [complexity_main S N L hS hne h1 hLN h3]
  by_cases h : L ≤ N - S.max' hne - 1
  · rw [ite_eq_left h]
    have h5 : L = N - S.max' hne - 1 := le_antisymm h h4
    rw [show N - L + 1 = S.max' hne + 2 by omega,
      min_eq_left (show S.max' hne + 1 ≤ S.max' hne + 2 by omega)]
  · rw [ite_eq_right h, min_eq_right (show N - L + 1 ≤ S.max' hne + 1 by omega), add_zero]

/-- The right-hand end of Corollary 3: `p(N) = 1`. -/
theorem complexity_eq_one_of_le (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hN : S.max' hne + 1 ≤ N) : complexity S N N = 1 := by
  have h1 : 1 ≤ N := le_trans (by omega : (1:ℕ) ≤ S.max' hne + 1) hN
  rw [complexity_main S N N hS hne h1 le_rfl hN,
    ite_eq_right (show ¬ (N ≤ N - S.max' hne - 1) by omega),
    min_eq_right (show N - N + 1 ≤ S.max' hne + 1 by omega), add_zero]
  omega

/-- The right-hand end of Corollary 3: `p(N-1) = 2`. -/
theorem complexity_eq_two_of_pred (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hN : S.max' hne + 1 ≤ N - 1) : complexity S N (N - 1) = 2 := by
  have h1 : 1 ≤ N - 1 := le_trans (by omega : (1:ℕ) ≤ S.max' hne + 1) hN
  have h2 : N - 1 ≤ N := by omega
  rw [complexity_main S N (N - 1) hS hne h1 h2 hN]
  by_cases h : N - 1 ≤ N - S.max' hne - 1
  · rw [ite_eq_left h]
    have : S.max' hne = 0 := by omega
    rw [min_eq_left (show S.max' hne + 1 ≤ N - (N - 1) + 1 by omega)]
    omega
  · rw [ite_eq_right h, min_eq_right (show N - (N - 1) + 1 ≤ S.max' hne + 1 by omega)]
    omega

/-- **The general upper bound behind Corollary 4.** For every truncation length
`N` and every `L`, at most `a_m + 2` factors occur: there are only `a_m + 1`
windows starting at or before `a_m`, and every window starting later is empty. -/
theorem complexity_le_max_add_two (S : Finset ℕ) (N L : ℕ) (hne : S.Nonempty) :
    complexity S N L ≤ S.max' hne + 2 := by
  classical
  set am := S.max' hne with ham
  have hmax : ∀ a ∈ S, a ≤ am := fun a ha => by rw [ham]; exact le_max' S a ha
  set W := range (N - L + 1) with hW
  set W1 := W.filter (fun t => t ≤ am) with hW1
  set W2 := W.filter (fun t => am + 1 ≤ t) with hW2
  have hunion : W1 ∪ W2 = W := by
    ext t
    simp only [hW1, hW2, mem_union, mem_filter]
    constructor
    · rintro (⟨h, -⟩ | ⟨h, -⟩) <;> exact h
    · intro h
      rcases le_or_gt t am with ht | ht
      · exact Or.inl ⟨h, ht⟩
      · exact Or.inr ⟨h, by omega⟩
  have h2empty : ∀ t ∈ W2, factor S L t = ∅ := by
    intro t ht
    rw [← not_nonempty_iff_eq_empty]
    rintro ⟨x, hx⟩
    rw [mem_factor] at hx
    obtain ⟨a, ha, h1, -, -⟩ := hx
    have ht2 : am + 1 ≤ t := (mem_filter.mp ht).2
    have := hmax a ha
    omega
  have hcard2 : (W2.image (factor S L)).card ≤ 1 := by
    rw [card_le_one]
    intro x hx y hy
    rw [mem_image] at hx hy
    obtain ⟨t, ht, rfl⟩ := hx
    obtain ⟨u, hu, rfl⟩ := hy
    rw [h2empty t ht, h2empty u hu]
  have hcard1 : W1.card ≤ am + 1 := by
    have hsub : W1 ⊆ range (am + 1) := by
      intro t ht
      rw [mem_range]
      have := (mem_filter.mp ht).2
      omega
    calc W1.card ≤ (range (am + 1)).card := card_le_card hsub
      _ = am + 1 := card_range _
  rw [complexity, ← hW]
  have himg : W.image (factor S L) = W1.image (factor S L) ∪ W2.image (factor S L) := by
    rw [← image_union, hunion]
  rw [himg]
  calc (W1.image (factor S L) ∪ W2.image (factor S L)).card
      ≤ (W1.image (factor S L)).card + (W2.image (factor S L)).card := card_union_le _ _
    _ ≤ W1.card + 1 := Nat.add_le_add card_image_le hcard2
    _ ≤ (am + 1) + 1 := Nat.add_le_add_right hcard1 1
    _ = am + 2 := by omega

/-- **Corollary 4.** If `N ≥ 2a_m + 2` the plateau is nonempty and the maximum
of `p` over `1 ≤ L ≤ N` is exactly `a_m + 2`. -/
theorem max_complexity (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hN : 2 * S.max' hne + 2 ≤ N) :
    (Icc 1 N).sup (fun L => complexity S N L) = S.max' hne + 2 := by
  have hNle : S.max' hne + 2 ≤ N := by omega
  refine le_antisymm ?_ ?_
  · exact Finset.sup_le (fun L _ => complexity_le_max_add_two S N L hne)
  · have hmem : plateauStart S hne ∈ Icc 1 N := by
      rw [mem_Icc]
      refine ⟨?_, ?_⟩ <;> simp only [plateauStart]
      · exact le_trans (by omega : (1:ℕ) ≤ S.max' hne + 1) (le_max_right _ _)
      · exact max_le (by omega) (by omega)
    refine le_trans (le_of_eq (complexity_plateau S N (plateauStart S hne) hS hne
      le_rfl (by simp only [plateauStart]; omega)).symm) (Finset.le_sup hmem)

/-- **Theorem 5 (C1 regime).** If `L` is at most the minimal gap, at most `a_0`
and at most `N - a_0 - 1`, then `p(L) = L + 1`. -/
theorem complexity_c1 (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hL1 : 1 ≤ L) (hLN : L ≤ N)
    (hgap : ∀ a ∈ S, ∀ b ∈ S, a < b → L ≤ b - a)
    (hmin : L ≤ S.min' hne) (hedge : L ≤ N - S.min' hne - 1) :
    complexity S N L = L + 1 := by
  classical
  set a0 := S.min' hne with ha0
  have hmem_a0 : a0 ∈ S := by rw [ha0]; exact min'_mem S hne
  have hle_a0 : ∀ a ∈ S, a0 ≤ a := fun a ha => by rw [ha0]; exact min'_le S a ha
  have ha0_lt : a0 < N := by have := hS hmem_a0; rwa [mem_range] at this
  -- (1) a window of length L contains at most one support point
  have hone : ∀ t a b, a ∈ S → b ∈ S → t ≤ a → a ≤ t + L - 1 → t ≤ b → b ≤ t + L - 1 → a = b := by
    intro t a b ha hb h1 h2 h3 h4
    rcases lt_trichotomy a b with h | h | h
    · exfalso
      have hbL : b < a + L := by
        have := (Nat.le_sub_one_iff_lt (by omega : 0 < t + L)).mp h4
        omega
      have h5 : b - a ≤ L - 1 := by
        rw [Nat.sub_le_iff_le_add]
        omega
      have h6 := hgap a ha b hb h
      omega
    · exact h
    · exfalso
      have haL : a < b + L := by
        have := (Nat.le_sub_one_iff_lt (by omega : 0 < t + L)).mp h2
        omega
      have h5 : a - b ≤ L - 1 := by
        rw [Nat.sub_le_iff_le_add]
        omega
      have h6 := hgap b hb a ha h
      omega
  -- (2) every factor is empty or a singleton `{j}` with `j < L`
  have hsingle : ∀ t ∈ range (N - L + 1), factor S L t = ∅ ∨ ∃ j, j < L ∧ factor S L t = {j} := by
    intro t ht
    by_cases h : factor S L t = ∅
    · exact Or.inl h
    · refine Or.inr ?_
      obtain ⟨x, hx⟩ := Finset.nonempty_iff_ne_empty.mpr h
      rw [mem_factor] at hx
      obtain ⟨a, ha, h1, h2, rfl⟩ := hx
      refine ⟨a - t, ?_, ?_⟩
      · have := (Nat.le_sub_one_iff_lt (by omega : 0 < t + L)).mp h2
        omega
      · ext y
        rw [mem_factor, mem_singleton]
        constructor
        · rintro ⟨b, hb, h3, h4, rfl⟩
          have := hone t b a hb ha h3 h4 h1 h2
          omega
        · rintro rfl
          exact ⟨a, ha, h1, h2, rfl⟩
  -- (3) the two inclusions, giving `p(L) = L + 1`
  have hsub : (range (N - L + 1)).image (factor S L) ⊆
      insert ∅ ((range L).image (fun j => ({j} : Finset ℕ))) := by
    intro f hf
    rw [mem_image] at hf
    obtain ⟨t, ht, rfl⟩ := hf
    rcases hsingle t ht with h | ⟨j, hj, hjeq⟩
    · exact mem_insert.mpr (Or.inl h)
    · exact mem_insert.mpr (Or.inr (mem_image.mpr ⟨j, mem_range.mpr hj, hjeq.symm⟩))
  have hsup : insert ∅ ((range L).image (fun j => ({j} : Finset ℕ))) ⊆
      (range (N - L + 1)).image (factor S L) := by
    intro f hf
    rcases mem_insert.mp hf with rfl | hf
    · -- the empty factor occurs at `t = 0`
      refine mem_image.mpr ⟨0, mem_range.mpr (by omega), ?_⟩
      rw [← not_nonempty_iff_eq_empty]
      rintro ⟨x, hx⟩
      rw [mem_factor] at hx
      obtain ⟨a, ha, -, h2, -⟩ := hx
      have h1 : L ≤ a := by
        have := hle_a0 a ha
        omega
      omega
    · rw [mem_image] at hf
      obtain ⟨j, hj, hjeq⟩ := hf
      rw [mem_range] at hj
      have hja0 : j ≤ a0 := by omega
      have ha0NL : a0 ≤ N - L := (Nat.le_sub_iff_add_le hLN).mpr (by omega)
      refine mem_image.mpr ⟨a0 - j, mem_range.mpr (by
        have : a0 - j ≤ a0 := Nat.sub_le _ _
        omega), ?_⟩
      have hwin : a0 ≤ a0 - j + L - 1 := by
        have h1 : a0 - j + L - 1 = a0 - j + (L - 1) := Nat.add_sub_assoc hL1 (a0 - j)
        rw [h1, ← Nat.sub_add_cancel hja0]
        omega
      have hsingle_eq : factor S L (a0 - j) = {a0 - (a0 - j)} := by
        ext y
        rw [mem_factor, mem_singleton]
        constructor
        · rintro ⟨b, hb, h3, h4, rfl⟩
          have hb_eq : b = a0 := hone (a0 - j) b a0 hb hmem_a0 h3 h4 (by omega) hwin
          rw [hb_eq]
        · rintro rfl
          exact ⟨a0, hmem_a0, by omega, hwin, rfl⟩
      rw [hsingle_eq, Nat.sub_sub_self hja0, hjeq]
  have hset : (range (N - L + 1)).image (factor S L) =
      insert ∅ ((range L).image (fun j => ({j} : Finset ℕ))) :=
    Subset.antisymm hsub hsup
  have hnotmem : (∅ : Finset ℕ) ∉ (range L).image (fun j => ({j} : Finset ℕ)) := by
    intro h
    rw [mem_image] at h
    obtain ⟨j, -, hj⟩ := h
    exact absurd hj.symm (by simp)
  rw [complexity, hset, card_insert_of_notMem hnotmem,
    card_image_of_injOn (fun j _ k _ h => by simpa using h), card_range]

/-! ## 4. The definition of record: offset tuples versus bit strings (claim A1)

`TRUTHS.md` §2 records this as *checked* over all words of length `≤ 14`.  It is
in fact a theorem: the offset set of the ones in a window and the bit string of
the window determine each other. -/

/-- The bit string of a window: `bitFactor S L t i = true` iff position `t + i`
belongs to the support. -/
def bitFactor (S : Finset ℕ) (L t : ℕ) : Fin L → Bool :=
  fun i => decide (t + i.val ∈ S)

/-- `p(L)` computed from bit strings rather than from offset sets. -/
def bitComplexity (S : Finset ℕ) (N L : ℕ) : ℕ :=
  ((range (N - L + 1)).image (fun t => bitFactor S L t)).card

/-- The offset set of a length-`L` window read as a bit string. -/
def toBit (L : ℕ) (F : Finset ℕ) : Fin L → Bool := fun i => decide (i.val ∈ F)

/-- Offset `i` of the window at `t` is a one exactly when `t + i` is in the
support. -/
lemma mem_factor_iff {S : Finset ℕ} {L t : ℕ} (i : Fin L) :
    i.val ∈ factor S L t ↔ t + i.val ∈ S := by
  rw [mem_factor]
  constructor
  · rintro ⟨a, ha, h1, h2, h3⟩
    have : t + i.val = a := by omega
    rw [this]
    exact ha
  · intro h
    exact ⟨t + i.val, h, by omega, by omega, by omega⟩

/-- Reading the offset set as a bit string gives the bit string of the window. -/
lemma toBit_factor (S : Finset ℕ) (L t : ℕ) :
    toBit L (factor S L t) = bitFactor S L t := by
  funext i
  simp only [toBit, bitFactor, mem_factor_iff]

/-- `toBit` is injective on the sets contained in `range L`. -/
lemma card_image_toBit (L : ℕ) {A : Finset (Finset ℕ)}
    (hA : ∀ F ∈ A, F ⊆ range L) : (A.image (toBit L)).card = A.card := by
  refine card_image_of_injOn ?_
  intro F hF G hG h
  ext n
  constructor
  · intro hn
    have hnL : n < L := mem_range.mp (hA F hF hn)
    have h2 : n ∈ G := by
      have := congrFun h ⟨n, hnL⟩
      simpa [toBit, hn] using this
    exact h2
  · intro hn
    have hnL : n < L := mem_range.mp (hA G hG hn)
    have h2 : n ∈ F := by
      have := congrFun h ⟨n, hnL⟩
      simpa [toBit, hn] using this
    exact h2

/-- **Claim A1.** The offset-tuple count and the bit-string count of length-`L`
factors agree, for every support and every truncation. -/
theorem complexity_eq_bitComplexity (S : Finset ℕ) (N L : ℕ) (hL : 1 ≤ L) :
    complexity S N L = bitComplexity S N L := by
  have hA : ∀ F ∈ (range (N - L + 1)).image (fun t => factor S L t), F ⊆ range L := by
    intro F hF
    rw [mem_image] at hF
    obtain ⟨t, -, rfl⟩ := hF
    exact factor_subset_range hL
  have hkey : ((range (N - L + 1)).image (fun t => factor S L t)).image (toBit L)
      = (range (N - L + 1)).image (fun t => bitFactor S L t) := by
    rw [image_image]
    exact image_congr (fun t _ => toBit_factor S L t)
  rw [complexity, bitComplexity, ← hkey, card_image_toBit L hA]

/-! ## 5. The onset (Theorem 6) and the refuted formulas of `TRUTHS.md` §5 -/

/-- Consecutive gaps of the support, in increasing order of position. -/
def gapSeq (S : Finset ℕ) : List ℕ :=
  (S.sort (· ≤ ·)).zipWith (fun a b => b - a) (S.sort (· ≤ ·)).tail

/-- `on` is the onset of the plateau: the least `L ∈ [1,N]` at which `p`
attains its maximum over `[1,N]`. -/
def IsOnset (S : Finset ℕ) (N on : ℕ) : Prop :=
  1 ≤ on ∧ on ≤ N ∧ complexity S N on = (Icc 1 N).sup (fun L => complexity S N L) ∧
    ∀ L, 1 ≤ L → L < on → complexity S N L < complexity S N on

/-- **Theorem 6 (onset determinacy).**  The onset is *not* a function of
`(gap sequence, N)`: the supports `{0,2}` and `{1,3}` have the same gap
sequence and the same truncation `N = 6`, but onsets `3` and `2`.

(Note: the example printed in `TRUTHS.md` §5 interchanges these two values;
this statement is the one checked by `rh41/rigorous_check.py`.) -/
theorem onset_not_determined_by_gaps :
    gapSeq ({0, 2} : Finset ℕ) = gapSeq ({1, 3} : Finset ℕ) ∧
      IsOnset ({0, 2} : Finset ℕ) 6 3 ∧ IsOnset ({1, 3} : Finset ℕ) 6 2 := by
  refine ⟨by native_decide, ⟨⟨by decide, by decide, by decide, ?_⟩, ⟨by decide, by decide, by decide, ?_⟩⟩⟩
  · intro L h1 h2
    interval_cases L <;> decide
  · intro L h1 h2
    interval_cases L <;> decide

/-- The number of support pairs at distance at most `L`. -/
def pairCount (S : Finset ℕ) (L : ℕ) : ℕ :=
  ((S.product S).filter (fun p => p.1 < p.2 ∧ p.2 - p.1 ≤ L)).card

/-- The number of distinct distances at most `L` between support points. -/
def distCount (S : Finset ℕ) (L : ℕ) : ℕ :=
  (((S.product S).filter (fun p => p.1 < p.2 ∧ p.2 - p.1 ≤ L)).image
    (fun p => p.2 - p.1)).card

/-- Refuted: the unrestricted main formula (row 1).  For support `{0,1}`,
`N = 2`, `L = 1` the true value is `1` while the formula reads `2`. -/
theorem refuted_main_formula_all_L :
    complexity ({0, 1} : Finset ℕ) 2 1 = 1 ∧
      min (({0, 1} : Finset ℕ).max' (by decide) + 1) (2 - 1 + 1)
        + (if 1 ≤ 2 - ({0, 1} : Finset ℕ).max' (by decide) - 1 then 1 else 0) = 2 := by
  refine ⟨by decide, by decide⟩

/-- Refuted: `p(L) = L + 1 + #{pairs at distance ≤ L}` (row 2); `1/π`, `L = 11`. -/
theorem refuted_pair_count_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 11 = 12 ∧
      11 + 1 + pairCount ({2, 13, 607} : Finset ℕ) 11 = 13 := by
  refine ⟨by native_decide, by native_decide⟩

/-- Refuted: `p(L) = L + 1 + #{distinct distances ≤ L}` (row 3); `1/π`, `L = 11`. -/
theorem refuted_dist_count_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 11 = 12 ∧
      11 + 1 + distCount ({2, 13, 607} : Finset ℕ) 11 = 13 := by
  refine ⟨by native_decide, by native_decide⟩

/-- Refuted: the gap-deficit formula (row 4); `1/π`, `L = 20`.  The two gaps of
the support are `11` and `594`, so `Σ max(0, L - d_j) = 9` and the formula
reads `21 + 9 = 30`, while `p(20) = 24`. -/
theorem refuted_gap_deficit_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 20 = 24 ∧
      20 + 1 + (max 0 (20 - (13 - 2)) + max 0 (20 - (607 - 13))) = 30 := by
  refine ⟨by native_decide, by norm_num⟩

/-- Refuted: the linear-slope formula `p(L) = 2L - 10` on `12 ≤ L ≤ 593`
(row 5); `1/π`, `L = 100`: `p(100) = 104`, the formula reads `190`. -/
theorem refuted_slope_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 100 = 104 ∧ 2 * 100 - 10 = 190 := by
  refine ⟨by native_decide, by norm_num⟩

/-- Refuted: `p(L) = min(L + span, N - L + 1)` (row 6); support `{139,151}`,
`N = 172`, `L = 13`: `p(13) = 15`, the formula reads `min 25 160 = 25`. -/
theorem refuted_span_formula :
    complexity ({139, 151} : Finset ℕ) 172 13 = 15 ∧
      min (13 + (151 - 139)) (172 - 13 + 1) = 25 := by
  refine ⟨by native_decide, by norm_num⟩

/-- The illustrative case of Corollary 4 with an *empty* plateau: for the
support `{0,…,199}` and `N = 259 < 2·199 + 2 = 400` the maximum of `p` is `60`,
not `a_m + 2 = 201`.  (Evaluated by `native_decide`, i.e. by compiled
evaluation of the decidable proposition.) -/
theorem plateau_empty_example :
    (Icc 1 259).sup (fun L => complexity (range 200) 259 L) = 60 := by
  native_decide

/-! ## 6. Necessity of the three bounds in Theorem 5

`TRUTHS.md` Theorem 5 claims that each of the three bounds in
`L ≤ min(min gap, a_0, N - a_0 - 1)` is necessary.  These three theorems record
concrete counterexamples to the weakened forms. -/

/-- Dropping `L ≤ a_0` fails: support `{1}`, `N = 3`, `L = 2` gives `p = 2 ≠ 3`. -/
theorem c1_bound_a0_necessary :
    complexity ({1} : Finset ℕ) 3 2 = 2 ∧ 2 + 1 = 3 := by
  refine ⟨by decide, by norm_num⟩

/-- Dropping `L ≤ min gap` fails: `1/π`, `L = 13` (min gap `11`) gives
`p = 16 ≠ 14`. -/
theorem c1_bound_gap_necessary :
    complexity ({2, 13, 607} : Finset ℕ) 1400 13 = 16 ∧ 13 + 1 = 14 := by
  refine ⟨by native_decide, by norm_num⟩

/-- Dropping `L ≤ N - a_0 - 1` fails: support `{5}`, `N = 8`, `L = 4` gives
`p = 4 ≠ 5` (the gap hypothesis is vacuous and `L = 4 ≤ a_0 = 5`). -/
theorem c1_bound_hedge_necessary :
    complexity ({5} : Finset ℕ) 8 4 = 4 ∧ 4 + 1 = 5 := by
  refine ⟨by decide, by norm_num⟩

end Rh41
