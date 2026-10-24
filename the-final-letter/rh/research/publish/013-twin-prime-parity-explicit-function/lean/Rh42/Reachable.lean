/-
  Reachable.lean — the exact structure of the reachable set of the signed (Tau)
  alphabet of rh42 (sibling of `rh42/reachable.py` and `rh42/truths.md`).

  The rh42 budgets are `P(p) = sum (2k)^(-p)` and `N(p) = sum (2k+1)^(-p)`; the
  targets actually writable are the *sub-sums* of the two half-series, and the
  question is when those sub-sums fill the whole budget interval.  The answer is
  Brown's completeness criterion:

      a_1 >= a_2 >= ... > 0,  T_n = sum_{k>=n} a_k,  A = T_1
      sub-sums = [0, A]   <=>   a_n <= T_{n+1} for every n.

  This file formalises the two one-step lemmas of that criterion (sufficiency and
  necessity), the finite sub-sum operator used by the exact computations, and the
  concrete four-term counterexample showing that the single condition
  `a_1 <= A - a_1` is not sufficient.

  Everything is over `Q` or `R`; there is no `sorry`, no `admit`, no new axiom
  and no `native_decide`.
-/
import Mathlib

open scoped Classical

set_option maxHeartbeats 1000000
set_option linter.unusedVariables false
set_option linter.unusedSimpArgs false

namespace Rh42

/-! ## 1. The two one-step lemmas of Brown's criterion -/

/-- **Sufficiency step.** If a set `S` already contains `[0,T]`, and
`0 <= a <= T`, then `S ∪ (a + S)` contains `[0, a+T]`: the lower piece is there
by hypothesis and the upper piece is its shift.  This is the induction step of
the completeness half of Brown's criterion (in `reachable.py` the set `S` is the
sub-sum set of the tail, `T = T_{n+1}` and `a = a_n`). -/
theorem Icc_subset_union_shift {S : Set ℝ} {a T : ℝ} (hS : Set.Icc 0 T ⊆ S)
    (ha : 0 ≤ a) (haT : a ≤ T) :
    Set.Icc 0 (a + T) ⊆ S ∪ (fun x => a + x) '' S := by
  intro x hx
  obtain ⟨hx0, hxT⟩ := Set.mem_Icc.mp hx
  rcases le_total x T with h | h
  · exact Or.inl (hS (Set.mem_Icc.mpr ⟨hx0, h⟩))
  · refine Or.inr ⟨x - a, hS (Set.mem_Icc.mpr ⟨by linarith, by linarith⟩), by ring⟩

/-- **Necessity step.** If `S ⊆ [0,T]` and `a > T`, then the open interval
`(T,a)` meets neither `S` nor its shift by `a`: it is a gap of `S ∪ (a + S)`.
(In `reachable.py` this is the gap `(T_2, a_1)` that opens as soon as
`p > p*`.)  The hypothesis `T < a` records the geometric situation; the
disjointness itself only needs `S ⊆ [0,T]` and `0 ≤ a`. -/
theorem gap_of_subset_Icc {S : Set ℝ} {a T : ℝ} (hS : S ⊆ Set.Icc 0 T)
    (ha : T < a) :
    ∀ x ∈ S ∪ (fun x => a + x) '' S, x ∉ Set.Ioo T a := by
  rintro x (hx | ⟨y, hy, rfl⟩) ⟨h1, h2⟩
  · exact absurd (hS hx).2 (not_le.mpr h1)
  · have hy0 : 0 ≤ y := (hS hy).1
    exact absurd (by linarith : (a : ℝ) < a + y) (not_lt.mpr h2.le)

/-- The interval merge behind both lemmas: `[0,T] ∪ [a, a+T] = [0, a+T]` when
`0 ≤ a ≤ T`. -/
theorem Icc_union_Icc_shift {a T : ℝ} (ha : 0 ≤ a) (haT : a ≤ T) :
    Set.Icc 0 T ∪ Set.Icc a (a + T) = Set.Icc 0 (a + T) := by
  ext x
  constructor
  · rintro (hx | hx)
    · exact ⟨(Set.mem_Icc.mp hx).1, by linarith [(Set.mem_Icc.mp hx).2]⟩
    · exact ⟨by linarith [(Set.mem_Icc.mp hx).1], (Set.mem_Icc.mp hx).2⟩
  · intro hx
    obtain ⟨h0, hT⟩ := Set.mem_Icc.mp hx
    rcases le_total x T with h | h
    · exact Or.inl (Set.mem_Icc.mpr ⟨h0, h⟩)
    · exact Or.inr (Set.mem_Icc.mpr ⟨le_trans haT h, hT⟩)

/-! ## 2. Sub-sums of a finite list of rationals -/

/-- The set of sub-sums of a list of rationals. -/
def subSums : List ℚ → Finset ℚ
  | [] => {0}
  | a :: t => subSums t ∪ (subSums t).image (fun x => a + x)

@[simp] theorem subSums_nil : subSums [] = {0} := rfl

theorem subSums_cons (a : ℚ) (t : List ℚ) :
    subSums (a :: t) = subSums t ∪ (subSums t).image (fun x => a + x) := rfl

theorem mem_subSums_cons {a x : ℚ} {t : List ℚ} :
    x ∈ subSums (a :: t) ↔ x ∈ subSums t ∨ ∃ y ∈ subSums t, x = a + y := by
  rw [subSums_cons, Finset.mem_union, Finset.mem_image]
  constructor
  · rintro (h | ⟨y, hy, hyx⟩)
    · exact Or.inl h
    · exact Or.inr ⟨y, hy, hyx.symm⟩
  · rintro (h | ⟨y, hy, rfl⟩)
    · exact Or.inl h
    · exact Or.inr ⟨y, hy, rfl⟩

theorem zero_mem_subSums (l : List ℚ) : 0 ∈ subSums l := by
  induction l with
  | nil => simp
  | cons a t ih => exact mem_subSums_cons.mpr (Or.inl ih)

theorem sum_mem_subSums (l : List ℚ) : l.sum ∈ subSums l := by
  induction l with
  | nil => simp
  | cons a t ih => exact mem_subSums_cons.mpr (Or.inr ⟨t.sum, ih, rfl⟩)

theorem subSums_nonneg {l : List ℚ} (h : ∀ a ∈ l, 0 ≤ a) :
    ∀ x ∈ subSums l, 0 ≤ x := by
  induction l with
  | nil =>
      intro x hx
      rw [subSums_nil, Finset.mem_singleton] at hx
      exact hx.ge
  | cons a t ih =>
      have ha : 0 ≤ a := h a (by simp)
      have ht : ∀ b ∈ t, 0 ≤ b := fun b hb => h b (by simp [hb])
      intro x hx
      rw [mem_subSums_cons] at hx
      rcases hx with hx | ⟨y, hy, rfl⟩
      · exact ih ht x hx
      · exact add_nonneg ha (ih ht y hy)

theorem subSums_le_sum {l : List ℚ} (h : ∀ a ∈ l, 0 ≤ a) :
    ∀ x ∈ subSums l, x ≤ l.sum := by
  induction l with
  | nil =>
      intro x hx
      rw [subSums_nil, Finset.mem_singleton] at hx
      exact hx.le
  | cons a t ih =>
      have ha : 0 ≤ a := h a (by simp)
      have ht : ∀ b ∈ t, 0 ≤ b := fun b hb => h b (by simp [hb])
      intro x hx
      rw [mem_subSums_cons] at hx
      rcases hx with hx | ⟨y, hy, rfl⟩
      · have := ih ht x hx
        simp only [List.sum_cons]
        linarith
      · have := ih ht y hy
        simp only [List.sum_cons]
        linarith

/-- **The gap lemma for a finite list.** If `a` exceeds the sum of the remaining
terms, then every sub-sum below `a` already avoids `a` and the earlier terms, so
it is at most the sum of the rest: the interval `(t.sum, a)` is a gap. -/
theorem gap_lemma {a : ℚ} {t : List ℚ} (h : ∀ b ∈ t, 0 ≤ b) (ha : t.sum < a) :
    ∀ x ∈ subSums (a :: t), x < a → x ≤ t.sum := by
  have hnonneg := subSums_nonneg h
  intro x hx hxa
  rw [mem_subSums_cons] at hx
  rcases hx with hx | ⟨y, hy, rfl⟩
  · exact subSums_le_sum h x hx
  · have hy0 := hnonneg y hy
    exact absurd (by linarith : (a : ℚ) ≤ a + y) (not_le.mpr hxa)

theorem nonneg_twentieths : ∀ b ∈ ([1 / 20, 1 / 20] : List ℚ), 0 ≤ b := by
  intro b hb
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hb
  rcases hb with rfl | rfl <;> norm_num

theorem nonneg_counterexample : ∀ b ∈ ([2 / 5, 1 / 20, 1 / 20] : List ℚ), 0 ≤ b := by
  intro b hb
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hb
  rcases hb with rfl | rfl | rfl <;> norm_num

/-- The four-term counterexample: `a_1 = 1/2` equals the sum of the rest, yet
`1/5` is not a sub-sum, so the single condition `a_1 <= A - a_1` does not imply
completeness (it is the *unimodality* of `h`, verified in `reachable.py`, that
rescues the `p`-series). -/
theorem single_condition_not_sufficient :
    (1 / 5 : ℚ) ∉ subSums [1 / 2, 2 / 5, 1 / 20, 1 / 20] ∧
      (1 / 2 : ℚ) = (1 / 2 + 2 / 5 + 1 / 20 + 1 / 20) - 1 / 2 := by
  constructor
  · intro hx
    rw [mem_subSums_cons] at hx
    rcases hx with hx | ⟨y, hy, hxy⟩
    · -- `1/5` would have to be a sub-sum of `[2/5, 1/20, 1/20]`; the gap lemma at
      -- `a = 2/5` forces it below `1/10`, which is less than `1/5`.
      have h1 : (1 / 5 : ℚ) ≤ (1 / 20 + 1 / 20 : ℚ) := by
        simpa using gap_lemma (a := 2 / 5) (t := [1 / 20, 1 / 20]) nonneg_twentieths
          (by norm_num) (1 / 5) hx (by norm_num)
      norm_num at h1
    · have hy0 : 0 ≤ y := subSums_nonneg nonneg_counterexample y hy
      norm_num at hxy
      linarith
  · norm_num

/-- **The doubling step of the census theorem.** If every term is non-negative
and `a` exceeds the sum of the rest, then the two pieces `subSums t` and
`a + subSums t` are disjoint: with `r = n_min - 1` of that shape the sub-sum set
of the `p`-series has exactly `2^r` components, each a translate of the first. -/
theorem subSums_cons_disjoint {a : ℚ} {t : List ℚ} (h : ∀ b ∈ t, 0 ≤ b)
    (ha : t.sum < a) :
    Disjoint (subSums t) ((subSums t).image (fun x => a + x)) := by
  rw [Finset.disjoint_left]
  intro x hx hx'
  obtain ⟨y, hy, hxay⟩ := Finset.mem_image.mp hx'
  rw [← hxay] at hx
  have h1 := subSums_le_sum h (a + y) hx
  have h2 := subSums_nonneg h y hy
  linarith

/-! ## 3. The greedy on a finite list -/

/-- The greedy total: walk the list and take a term whenever it fits. -/
def greedySum : List ℚ → ℚ → ℚ
  | [], _ => 0
  | a :: t, x => if a ≤ x then a + greedySum t (x - a) else greedySum t x

@[simp] theorem greedySum_nil (x : ℚ) : greedySum [] x = 0 := rfl

theorem greedySum_cons (a : ℚ) (t : List ℚ) (x : ℚ) :
    greedySum (a :: t) x = if a ≤ x then a + greedySum t (x - a) else greedySum t x := rfl

/-- The greedy total is a sub-sum. -/
theorem greedySum_mem_subSums (l : List ℚ) (x : ℚ) :
    greedySum l x ∈ subSums l := by
  induction l generalizing x with
  | nil => simp
  | cons a t ih =>
      rw [greedySum_cons]
      split_ifs with h
      · exact mem_subSums_cons.mpr (Or.inr ⟨greedySum t (x - a), ih (x - a), rfl⟩)
      · exact mem_subSums_cons.mpr (Or.inl (ih x))

/-- The greedy never overshoots a non-negative target when all terms are
non-negative. -/
theorem greedySum_le {l : List ℚ} (h : ∀ a ∈ l, 0 ≤ a) :
    ∀ x : ℚ, 0 ≤ x → greedySum l x ≤ x := by
  induction l with
  | nil => intro x hx; simpa using hx
  | cons a t ih =>
      have ha : 0 ≤ a := h a (by simp)
      have ht : ∀ b ∈ t, 0 ≤ b := fun b hb => h b (by simp [hb])
      intro x hx
      rw [greedySum_cons]
      split_ifs with hle
      · have := ih ht (x - a) (by linarith)
        linarith
      · exact ih ht x hx

/-- **The optimality step.** If the tail's sub-sums already fill `[0,T]` and
`0 ≤ a ≤ T`, then on a target `x ≤ a + T` the greedy's choice between "take `a`"
and "skip `a`" loses nothing: every `x ∈ [0, a+T]` lies in `S` or in `a + S`.
This is the reason the greedy is optimal for the `p`-series, where every tail
from `n_min` on is complete. -/
theorem greedy_step_optimal {S : Set ℝ} {a T : ℝ} (hS : Set.Icc 0 T ⊆ S)
    (ha : 0 ≤ a) (haT : a ≤ T) :
    Set.Icc 0 (a + T) ⊆ S ∪ (fun x => a + x) '' S :=
  Icc_subset_union_shift hS ha haT

end Rh42
