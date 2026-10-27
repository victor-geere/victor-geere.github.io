/-
TppLean/Core.lean — the **ordering core** of T14.

`theorems/tpp-rh42-handoff-three-thresholds.md` states (VERIFIED, numerical) that the
three thresholds of the rh42 handoff satisfy `pN < pP < p*`.

The logical content of that ordering is *order-theoretic*: the positive budget `F` and the
negative budget `G` are continuous and strictly decreasing, `G` lies strictly below `F`,
and both have already dropped below their levels at a common bracket `q`.  This file proves
the ordering `pG < pF` from exactly those hypotheses, for **arbitrary** real functions, so
that nothing here depends on the zeta function or on any numerical approximation.

The instantiation to the concrete budgets `P(p) = 2^{-p} ζ(p)` and
`N(p) = (1 - 2^{-p}) ζ(p) - 1` lives in `TppLean/ThreeThresholds.lean`.
-/
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Topology.Order.IntermediateValue

namespace TppLean

/-- `c` is the threshold at which the budget `B` reaches the level `L`, given that `B` is
continuous and strictly decreasing to the right of `q` and starts below `L` at `q`.
Uniqueness is a consequence of strict antitonicity, so this predicate records it. -/
def IsThreshold (B : ℝ → ℝ) (q L c : ℝ) : Prop :=
  q < c ∧ B c = L ∧ ∀ x, q < x → B x = L → x = c

/-- A budget that crosses its level exactly once to the right of `q`.

This is the reusable analytic shape: `B` continuous on `[q, ∞)`, strictly decreasing on
`(q, ∞)`, above `L` at `q`, and below `L` at some explicit point further right. -/
structure CrossesOnce (B : ℝ → ℝ) (q L : ℝ) : Prop where
  cont : ContinuousOn B (Set.Ici q)
  anti : ∀ x y, q < x → q < y → x < y → B y < B x
  above_q : L < B q
  below_far : ∃ x, q < x ∧ B x < L

/-- **Existence and uniqueness of the crossing.** -/
theorem CrossesOnce.exists_unique (h : CrossesOnce B q L) : ∃! c, q < c ∧ B c = L := by
  obtain ⟨hcont, hanti, hq, x, hqx, hx⟩ := h
  have hqle : q ≤ x := le_of_lt hqx
  have hcontIcc : ContinuousOn B (Set.Icc q x) :=
    hcont.mono fun y hy => hy.1
  have hL : L ∈ Set.Icc (B x) (B q) := ⟨le_of_lt hx, le_of_lt hq⟩
  obtain ⟨c, hcIcc, hcval⟩ := intermediate_value_Icc' hqle hcontIcc hL
  have hcne : c ≠ q := by
    intro hcq
    rw [hcq] at hcval
    exact absurd hcval (Ne.symm (ne_of_lt hq))
  have hqltc : q < c := lt_of_le_of_ne hcIcc.1 (Ne.symm hcne)
  refine ⟨c, ⟨hqltc, hcval⟩, ?_⟩
  rintro d ⟨hqd, hdval⟩
  rcases lt_trichotomy c d with hcd | heq | hdc
  · have hstrict := hanti c d hqltc hqd hcd
    rw [hcval, hdval] at hstrict
    exact absurd hstrict (lt_irrefl L)
  · rw [heq]
  · have hstrict := hanti d c hqd hqltc hdc
    rw [hdval, hcval] at hstrict
    exact absurd hstrict (lt_irrefl L)

/-- Core hypothesis package for the two budget functions of T14.

`F` is the positive budget `P(p) = 2^{-p} ζ(p)`, `G` the negative budget
`N(p) = (1 - 2^{-p}) ζ(p) - 1`.  The relation `G x < F x` is `P - N = 1 - η(p) > 0` in the
source.  The two `CrossesOnce` fields are the `p = 7/5` and `p = 3/2` rows of the source's
§5.3 table, transported to the common bracket `q`. -/
structure BudgetHyp (F G : ℝ → ℝ) (q : ℝ) : Prop where
  crossesP : CrossesOnce F q 1
  crossesN : CrossesOnce G q 2
  hGF : ∀ x, q < x → G x < F x

/-- **T14, the ordering: `pN < pP`.**  The negative budget reaches `2` strictly before the
positive budget reaches `1`.  The proof needs no numerics beyond the bracket `q`: the two
budgets have the *same* level-`1` bracket on the left, and `G < F` everywhere gives
`G(pP) < F(pP) = 1`, whence `pP` already lies beyond the `G`-crossing.

Note this is the direction the source cares about: the crossing of the *smaller* budget
comes first. -/
theorem threshold_ordering {F G : ℝ → ℝ} {q pF pG : ℝ}
    (h : BudgetHyp F G q) (hF : IsThreshold F q 1 pF) (hG : IsThreshold G q 2 pG) :
    pG < pF := by
  obtain ⟨hqG, hGval, _⟩ := hG
  obtain ⟨hqF, hFval, _⟩ := hF
  by_contra hle
  have hle' : pF ≤ pG := not_lt.mp hle
  -- `hle' : pF ≤ pG`; then `G pF ≤ G pG = 2` by antitonicity, while `G pF < F pF = 1`.
  have hGF' : G pF < 1 := by
    have := h.hGF pF hqF
    rwa [hFval] at this
  rcases lt_or_eq_of_le hle' with hlt | heq
  · have hmono := h.crossesN.anti pF pG hqF hqG hlt
    rw [hGval] at hmono
    linarith
  · have : G pF = 2 := by rw [heq, hGval]
    linarith

end TppLean
