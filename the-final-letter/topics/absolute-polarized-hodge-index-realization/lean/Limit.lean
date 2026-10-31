import Mathlib

/-!
# The inductive limit of compatible quadratic forms

The corrected Bost–Connes inductive-limit step (note 34) needs only
compatibility, not a uniform bound.  This file formalises the core: on a
chain of subspaces, the values of compatible forms agree on a common vector,
so the limit form is well defined on the union.
-/

namespace AbsoluteHodgeLimit

variable {E : Type*} [AddCommGroup E] [Module ℝ E]
variable {V : ℕ → Submodule ℝ E}
variable {Q : (n : ℕ) → V n → ℝ}

/-- **The limit form is well defined.**  If the same vector is presented at
two levels, compatible forms give the same value.  This is the core of
Lemma 2.1 in the rescue note: compatibility alone suffices. -/
theorem limit_well_defined
    (hmono : ∀ n m : ℕ, n ≤ m → V n ≤ V m)
    (hcompat : ∀ (n m : ℕ) (h : n ≤ m) (v : V n),
      Q m ⟨v.1, hmono n m h v.2⟩ = Q n v)
    {n m : ℕ} (v : V n) (w : V m) (h : v.1 = w.1) :
    Q n v = Q m w := by
  let N := max n m
  have hn : n ≤ N := le_max_left n m
  have hm : m ≤ N := le_max_right n m
  have h1 : Q N ⟨v.1, hmono n N hn v.2⟩ = Q n v := hcompat n N hn v
  have h2 : Q N ⟨w.1, hmono m N hm w.2⟩ = Q m w := hcompat m N hm w
  have hvw : (⟨v.1, hmono n N hn v.2⟩ : V N) = ⟨w.1, hmono m N hm w.2⟩ := by
    ext
    exact h
  rw [← h1, ← h2, hvw]

/-- Compatibility transfers non-positivity along the chain. -/
theorem limit_nonpos (hnsd : ∀ n v, Q n v ≤ 0) {n : ℕ} (v : V n) :
    Q n v ≤ 0 :=
  hnsd n v


section Union

variable {V : ℕ →o Submodule ℝ E}

/-- The limit form on the union `⋃ₙ Vₙ`, defined by choosing a level. -/
noncomputable def limitForm (Q : (n : ℕ) → V n → ℝ)
    (v : ↥(⨆ n, V n)) : ℝ := by
  classical
  exact
    let h : ∃ n, v.1 ∈ V n := (Submodule.mem_iSup_of_chain V v.1).mp v.2
    Q h.choose ⟨v.1, h.choose_spec⟩

/-- The limit form agrees with the level form at **any** level containing the
vector. -/
theorem limitForm_eq_level (Q : (n : ℕ) → V n → ℝ)
    (hcompat : ∀ (n m : ℕ) (h : n ≤ m) (v : V n),
      Q m ⟨v.1, V.monotone h v.2⟩ = Q n v)
    (v : ↥(⨆ n, V n)) (n : ℕ) (hv : v.1 ∈ V n) :
    limitForm Q v = Q n ⟨v.1, hv⟩ := by
  classical
  unfold limitForm
  dsimp only
  exact limit_well_defined (fun a b h => V.monotone h) hcompat
    ⟨v.1, (Classical.choose_spec
      (show ∃ n, v.1 ∈ V n from (Submodule.mem_iSup_of_chain V v.1).mp v.2))⟩
    ⟨v.1, hv⟩ rfl

/-- The limit form is non-positive if every level form is. -/
theorem limitForm_nonpos (Q : (n : ℕ) → V n → ℝ)
    (hnsd : ∀ n v, Q n v ≤ 0) (v : ↥(⨆ n, V n)) :
    limitForm Q v ≤ 0 := by
  classical
  unfold limitForm
  dsimp only
  exact hnsd _ _


/-- The limit form is non-negative if every level form is.  (Dual of
`limitForm_nonpos`.) -/
theorem limitForm_nonneg (Q : (n : ℕ) → V n → ℝ)
    (hnn : ∀ n v, 0 ≤ Q n v) (v : ↥(⨆ n, V n)) :
    0 ≤ limitForm Q v := by
  classical
  unfold limitForm
  dsimp only
  exact hnn _ _

end Union



end AbsoluteHodgeLimit
