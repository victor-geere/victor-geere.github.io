/-
  Rh45/Routes.lean — the certification logic of Routes A, B, C
  (§6 of `research/twin-prime-parity/eta-euler-acceleration.html`).

  Route A: a continuous function with a sign change and a strictly positive
  derivative on the interior has a *unique simple* zero (the logic of an
  interval-arithmetic `Z(t)` certificate).

  Route B: if the certified on-line zeros are a subset of the zeros in a window,
  and the rigorously counted total is at most the number of certified ones, then
  the two sets coincide — all zeros in the window are the certified (hence
  simple, on-line) ones.

  Route C: the validated-truncation error assembly: if the true right-hand side
  differs from the computed partial sum by the sum of the three tails, then the
  residual is bounded by the three tail bounds (triangle inequality), with the
  prime tail controlled by Chebyshev's `ψ x ≤ (log 4 + 4) x`.

  Everything is proved from Mathlib alone; no `sorry`, no extra axiom.
-/
import Mathlib

open Set

namespace Rh45Routes

/-! ## Route A — the sign-change certificate -/

/-- **Route A (uniqueness + simplicity).**  Let `f` be continuous on `[a,b]`,
differentiable on `(a,b)` with *strictly positive* derivative there, and suppose
`f a < 0 < f b`.  Then `f` has exactly one zero in `(a,b)`, and that zero is
simple.

This is the logical content of an interval `Z(t)` certificate: `f a < 0` and
`f b > 0` are discharged by enclosures of `Z`, and `0 < deriv f` on `(a,b)` by an
enclosure of `Z'`. -/
theorem exists_unique_root_of_sign_change
    {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Icc a b))
    (hf' : ∀ x ∈ Ioo a b, 0 < deriv f x)
    (ha : f a < 0) (hb : 0 < f b) :
    ∃ x, x ∈ Ioo a b ∧ f x = 0 ∧ 0 < deriv f x ∧ ∀ y, y ∈ Ioo a b → f y = 0 → y = x := by
  -- existence by the intermediate value theorem
  have hmem : (0 : ℝ) ∈ Icc (f a) (f b) := ⟨ha.le, hb.le⟩
  obtain ⟨x, hx, hfx⟩ := intermediate_value_Icc hab.le hf hmem
  have hxIoo : x ∈ Ioo a b := by
    rcases hx with ⟨hax, hxb⟩
    refine ⟨lt_of_le_of_ne hax ?_, lt_of_le_of_ne hxb ?_⟩
    · rintro rfl; exact absurd hfx (ne_of_lt ha)
    · rintro rfl; exact absurd hfx (ne_of_gt hb)
  -- strict monotonicity on the closed interval
  have hmono : StrictMonoOn f (Icc a b) := by
    refine strictMonoOn_of_deriv_pos (convex_Icc a b) hf ?_
    intro z hz
    exact hf' z (by simpa [interior_Icc] using hz)
  refine ⟨x, hxIoo, hfx, hf' x hxIoo, ?_⟩
  intro y hy hy0
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · have h := hmono (Ioo_subset_Icc_self hy) (Ioo_subset_Icc_self hxIoo) hlt
    rw [hy0, hfx] at h
    exact lt_irrefl (0 : ℝ) h
  · have h := hmono (Ioo_subset_Icc_self hxIoo) (Ioo_subset_Icc_self hy) hgt
    rw [hy0, hfx] at h
    exact lt_irrefl (0 : ℝ) h

/-- **Route A (enclosure form).**  The exact hypotheses a numerical certificate
supplies: an enclosure `f a ∈ [la, ha]` with `ha < 0`, an enclosure
`f b ∈ [lb, hb]` with `0 < lb`, and an enclosure `deriv f ∈ [m, M]` on `(a,b)`
with `0 < m`.  Conclusion: a unique simple zero in `(a,b)`. -/
theorem certified_root_of_enclosures
    {f : ℝ → ℝ} {a b la ha lb hb m : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Icc a b))
    (_hfa : la ≤ f a) (hha : ha < 0) (haf : f a ≤ ha)
    (hfb : lb ≤ f b) (hlb : 0 < lb) (_hbf : f b ≤ hb)
    (hderiv : ∀ x ∈ Ioo a b, m ≤ deriv f x) (hm : 0 < m) :
    ∃ x, x ∈ Ioo a b ∧ f x = 0 ∧ 0 < deriv f x ∧ ∀ y, y ∈ Ioo a b → f y = 0 → y = x := by
  refine exists_unique_root_of_sign_change hab hf ?_ ?_ ?_
  · intro x hx
    exact lt_of_lt_of_le hm (hderiv x hx)
  · linarith
  · linarith

/-! ## Route B — the Turing reduction -/

/-- **Route B (Turing reduction).**  If every certified zero lies among the zeros
in the window (`certified ⊆ zeros`) and the rigorously counted number of zeros in
the window is at most the number of certified ones (`zeros.card ≤ certified.card`),
then the two sets are equal: every zero in the window is one of the certified
(simple, on-line) zeros.

The analytic content to discharge the hypotheses is (i) a rigorous argument-
principle count giving `N(T) ≤ certified.card` and (ii) the Route-A certificates
giving the `certified` set; the set-theoretic step is the theorem below. -/
theorem turing_reduction {α : Type*} [DecidableEq α] {zeros certified : Finset α}
    (hsub : certified ⊆ zeros) (hcard : zeros.card ≤ certified.card) :
    zeros = certified :=
  (Finset.eq_of_subset_of_card_le hsub hcard).symm

/-! ## Route C — the validated truncation error assembly -/

/-- **Route C (error assembly).**  If the exact right-hand side is the computed
partial sum plus the three tails, then the residual is bounded by the three tail
bounds (triangle inequality).  This is the step that turns three proved tail
inequalities into a validated evaluation of the explicit formula. -/
theorem validated_truncation_bound
    {lhs rhsTrue rhsComputed zeroTail primeTail archTail : ℝ}
    (hlhs : lhs = rhsTrue)
    (hsplit : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)) :
    |lhs - rhsComputed| ≤ |zeroTail| + |primeTail| + |archTail| := by
  have h : lhs - rhsComputed = zeroTail + primeTail + archTail := by
    rw [hlhs, hsplit]; ring
  rw [h]
  calc |zeroTail + primeTail + archTail|
      ≤ |zeroTail + primeTail| + |archTail| := abs_add_le _ _
    _ ≤ (|zeroTail| + |primeTail|) + |archTail| := by
        linarith [abs_add_le zeroTail primeTail]
    _ = |zeroTail| + |primeTail| + |archTail| := by ring

/-- **Route C (prime tail, Chebyshev input).**  Mathlib's Chebyshev bound
`ψ x ≤ (log 4 + 4) x` for `x ≥ 0` is the rigorous input that replaces the
density estimate `ψ(x) ≈ x` used by the round's numerical script. -/
theorem prime_tail_input (x : ℝ) (hx : 0 ≤ x) :
    Chebyshev.psi x ≤ (Real.log 4 + 4) * x :=
  Chebyshev.psi_le_const_mul_self hx

/-- **Route A, decreasing case.**  The mirror of `exists_unique_root_of_sign_change`
for a strictly negative derivative (e.g. `Z'(γ₂) < 0`). -/
theorem exists_unique_root_of_sign_change_neg
    {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Icc a b))
    (hf' : ∀ x ∈ Ioo a b, deriv f x < 0)
    (ha : 0 < f a) (hb : f b < 0) :
    ∃ x, x ∈ Ioo a b ∧ f x = 0 ∧ deriv f x < 0 ∧ ∀ y, y ∈ Ioo a b → f y = 0 → y = x := by
  have hmem : (0 : ℝ) ∈ Icc (f b) (f a) := ⟨hb.le, ha.le⟩
  obtain ⟨x, hx, hfx⟩ := intermediate_value_Icc' hab.le hf hmem
  have hxIoo : x ∈ Ioo a b := by
    rcases hx with ⟨hax, hxb⟩
    refine ⟨lt_of_le_of_ne hax ?_, lt_of_le_of_ne hxb ?_⟩
    · rintro rfl; exact absurd hfx (ne_of_gt ha)
    · rintro rfl; exact absurd hfx (ne_of_lt hb)
  have hanti : StrictAntiOn f (Icc a b) := by
    refine strictAntiOn_of_deriv_neg (convex_Icc a b) hf ?_
    intro z hz
    exact hf' z (by simpa [interior_Icc] using hz)
  refine ⟨x, hxIoo, hfx, hf' x hxIoo, ?_⟩
  intro y hy hy0
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · have h := hanti (Ioo_subset_Icc_self hy) (Ioo_subset_Icc_self hxIoo) hlt
    rw [hy0, hfx] at h
    exact lt_irrefl (0 : ℝ) h
  · have h := hanti (Ioo_subset_Icc_self hxIoo) (Ioo_subset_Icc_self hy) hgt
    rw [hy0, hfx] at h
    exact lt_irrefl (0 : ℝ) h

/-- **Route B, packaged (Turing window closed).**  If `certified` is a set of zeros
contained in the window's zero set `zeros`, and the rigorous count says
`zeros.card ≤ certified.card`, then *every* zero of the window lies in `certified` —
i.e. (given the Route-A certificates) every zero in the window is simple and on the
critical line. -/
theorem all_zeros_are_certified {α : Type*} [DecidableEq α]
    {zeros certified : Finset α}
    (hsub : certified ⊆ zeros) (hcard : zeros.card ≤ certified.card) :
    ∀ z ∈ zeros, z ∈ certified := by
  intro z hz
  rw [turing_reduction hsub hcard] at hz
  exact hz

end Rh45Routes
