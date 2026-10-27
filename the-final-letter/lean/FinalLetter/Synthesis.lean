/-
  Synthesis.lean — the formal spine of the-final-letter.

  This file does three things:

  1. Defines the two walls as propositions: the Riemann hypothesis (in
     Mathlib's zeta-zero vocabulary) and the twin-prime conjecture.
  2. Defines two-point Chowla using the finite-prefix development vendored
     from rh46.
  3. Restates the one clean logical theorem of the programme: finite prefixes
     cannot distinguish the Liouville function from a function that differs at
     a later index, and the slash perturbation changes the correlation at the
     flipped index.

  Nothing here asserts the Riemann hypothesis, the twin-prime conjecture, or
  two-point Chowla. The open statements are `def`s, not `axiom`s.
-/
import FinalLetter.Chowla
import Mathlib.NumberTheory.LSeries.RiemannZeta

namespace FinalLetter

open scoped BigOperators

/-! ## 1. The two walls -/

/-- The Riemann hypothesis: every non-trivial zero of `ζ` has real part `1/2`.
Trivial zeros (the negative even integers) are excluded by `0 < s.re`. -/
def RiemannHypothesis : Prop :=
  ∀ s ∈ riemannZetaZeros, 0 < s.re → s.re < 1 → s.re = 1 / 2

/-- The twin-prime conjecture, in "infinitely many" form. -/
def TwinPrimeConjecture : Prop :=
  ∀ N : ℕ, ∃ p : ℕ, N < p ∧ Nat.Prime p ∧ Nat.Prime (p + 2)

/-- Two-point Chowla for `h = 2`, using the rh46 definition. -/
def ChowlaTwoPoint : Prop := Rh46.corrAsymptotic 2

/-! ## 2. A correlation for an arbitrary sign function -/

/-- `corrOf g h N` is the shifted correlation of an arbitrary `g : ℕ → ℤ`.
For `g = Rh46.liouville` it is definitionally `Rh46.corr`. -/
def corrOf (g : ℕ → ℤ) (h N : ℕ) : ℤ :=
  ∑ n ∈ Finset.Icc 1 N, g n * g (n + h)

@[simp] theorem corrOf_liouville (h N : ℕ) :
    corrOf Rh46.liouville h N = Rh46.corr h N := rfl

@[simp] theorem corrOf_slice (h a N : ℕ) :
    corrOf (Rh46.liouvilleSlice a) h N = Rh46.corrSlice h a N := rfl

/-! ## 3. Finite-prefix indeterminacy -/

/-- A function `g` agrees with `λ` on the prefix `[0, a)`. -/
def AgreesBelow (g : ℕ → ℤ) (a : ℕ) : Prop :=
  ∀ n : ℕ, n < a → g n = Rh46.liouville n

/-- The slice at `a` agrees with `λ` below `a`. -/
theorem slice_agrees_below (a : ℕ) :
    AgreesBelow (Rh46.liouvilleSlice a) a :=
  fun _ hn => Rh46.slice_agree hn

/-- The slice at a nonzero `a` is not `λ`. -/
theorem slice_differs (a : ℕ) (ha : a ≠ 0) :
    Rh46.liouvilleSlice a ≠ Rh46.liouville :=
  Rh46.slice_ne a ha

/-- **Finite-prefix indeterminacy.** For every `a ≠ 0` and every `h`, there is a
function `g` that agrees with `λ` below `a`, differs from `λ`, and reproduces
the correlation `corr h N` on every prefix with `N + h < a`.

This is the formal content of the programme's one clean new theorem: a finite
prefix cannot distinguish `λ` from a function that changes the correlation later.
It does not assert that the two functions have different *asymptotics*; that is
a statement about the limit and is not formalised here. -/
theorem finite_prefix_indeterminacy {h a : ℕ} (ha : a ≠ 0) :
    ∃ g : ℕ → ℤ,
      AgreesBelow g a ∧
      g ≠ Rh46.liouville ∧
      (∀ N : ℕ, N + h < a → corrOf g h N = Rh46.corr h N) := by
  refine ⟨Rh46.liouvilleSlice a, slice_agrees_below a, slice_differs a ha, ?_⟩
  intro N hN
  rw [corrOf_slice]
  exact Rh46.corrSlice_eq_corr_of_lt hN

/-- The explicit perturbation identity at the flipped index. -/
theorem slice_perturbation {h a : ℕ} (hh : 0 < h) (hha : h < a) :
    Rh46.corrSlice h a a - Rh46.corr h a =
      -2 * (Rh46.liouville a * Rh46.liouville (a + h)) -
        2 * (Rh46.liouville (a - h) * Rh46.liouville a) :=
  Rh46.corrSlice_sub_corr_self_eq hh hha

/-- An explicit witness that a finite prefix fails to determine the value at the
next index: `h = 2`, `a = 5` changes the correlation by `-4`. -/
theorem finite_prefix_witness :
    ∃ h a : ℕ, Rh46.corrSlice h a a ≠ Rh46.corr h a :=
  Rh46.exists_corrSlice_ne_corr

/-! ## 4. Elementary wall facts -/

/-- The trivial bound: `|corr h N| ≤ N`. -/
theorem corr_abs_le (h N : ℕ) : |Rh46.corr h N| ≤ N :=
  Rh46.corr_abs_le h N

/-- The sharpness witness: `corr 0 N = N`, so `o(N)` is not formal. -/
theorem corr_zero (N : ℕ) : Rh46.corr 0 N = N :=
  Rh46.corr_zero N

/-- Therefore `corrAsymptotic 0` is false. -/
theorem corrAsymptotic_zero_false : ¬ Rh46.corrAsymptotic 0 :=
  Rh46.corrAsymptotic_zero_false

/-- The shifted product is not completely multiplicative. -/
theorem shiftProd_not_completely_multiplicative :
    ∃ m n : ℕ, Rh46.shiftProd 2 (m * n) ≠ Rh46.shiftProd 2 m * Rh46.shiftProd 2 n :=
  Rh46.shiftProd_not_completely_multiplicative

/-- The slice perturbation has `ℓ²`-mass exactly `4`. -/
theorem slice_l2_mass {a N : ℕ} (ha : 1 ≤ a) (haN : a ≤ N) :
    ∑ n ∈ Finset.Icc 1 N, (Rh46.liouvilleSlice a n - Rh46.liouville n) ^ 2 = 4 :=
  Rh46.corrSliceSqSub ha haN

end FinalLetter
