/-
  Twist.lean — 019: the algebraic core of the "twisted Parseval" identity.

  The F4 identity of the 018 programme (notes/round105-Ksums.md) is

      sum_A chi2(A) |K(A,c)|^2 = 2 chi2(c) sqrt(q) Re J(chi4,chi4)^2 ,

  and its derivation (rounds 99-105) rests on exactly one combinatorial step:
  summing over the squares is the same as summing over everything and then
  weighting by the quadratic character,

      2 * sum_{A a square} f(A)  =  sum_A f(A) + sum_A chi2(A) f(A)   (f 0 = 0) .

  That step is what this file proves, for an arbitrary function on ZMod p with
  values in C.  It is the bookkeeping lemma, not the identity itself: the
  character sum on the right is still open (see 019/README.md).  What is
  certified here is that no arithmetic is hidden in the passage between the
  two sums.
-/
import Mathlib

open Finset

namespace Twist

variable (p : ℕ) [Fact p.Prime]

/-- Pointwise: at a nonzero `a`, twice the square indicator is `1 + chi2(a)`. -/
theorem two_mul_indicator {a : ZMod p} (ha : a ≠ 0) :
    2 * (if IsSquare a then (1 : ℂ) else 0)
      = 1 + (quadraticChar (ZMod p) a : ℂ) := by
  by_cases hs : IsSquare a
  · have hχ : quadraticChar (ZMod p) a = 1 :=
      (quadraticChar_one_iff_isSquare ha).mpr hs
    simp [hs, hχ]
    norm_num
  · have hχ : quadraticChar (ZMod p) a = -1 :=
      quadraticChar_neg_one_iff_not_isSquare.mpr hs
    simp [hs, hχ]

/-- The same, multiplied by an arbitrary value `f a`. -/
theorem two_mul_indicator_mul (f : ZMod p → ℂ) {a : ZMod p} (ha : a ≠ 0) :
    2 * (if IsSquare a then f a else 0)
      = f a + (quadraticChar (ZMod p) a : ℂ) * f a := by
  have h := two_mul_indicator p ha
  calc 2 * (if IsSquare a then f a else 0)
      = (2 * (if IsSquare a then (1 : ℂ) else 0)) * f a := by
        split <;> ring
    _ = (1 + (quadraticChar (ZMod p) a : ℂ)) * f a := by rw [h]
    _ = f a + (quadraticChar (ZMod p) a : ℂ) * f a := by ring

/-- **The splitting identity**, over all of `ZMod p` (the `f 0` term is the
correction at the origin, where `0` is a square but `chi2 0 = 0`). -/
theorem two_mul_sum_isSquare (f : ZMod p → ℂ) :
    2 * ∑ a, (if IsSquare a then f a else 0)
      = ∑ a, f a + ∑ a, (quadraticChar (ZMod p) a : ℂ) * f a + f 0 := by
  have key : ∀ a : ZMod p,
      2 * (if IsSquare a then f a else 0)
        = f a + (quadraticChar (ZMod p) a : ℂ) * f a + (if a = 0 then f 0 else 0) := by
    intro a
    by_cases ha : a = 0
    · subst ha
      simp [IsSquare.zero]
      ring
    · rw [two_mul_indicator_mul p f ha]
      simp [ha]
  calc 2 * ∑ a, (if IsSquare a then f a else 0)
      = ∑ a, (f a + (quadraticChar (ZMod p) a : ℂ) * f a
                + (if a = 0 then f 0 else 0)) := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl fun a _ => key a
    _ = ∑ a, f a + ∑ a, (quadraticChar (ZMod p) a : ℂ) * f a + f 0 := by
        rw [Finset.sum_add_distrib, Finset.sum_add_distrib]
        simp

/-- **The twisted-Parseval step** in the shape used by the programme: for a
function vanishing at `0` (in the application, `f A = |K(A,c)|^2` at `A = 0`),

    2 * sum over squares = sum over all + sum weighted by chi2. -/
theorem twisted_parseval_step (f : ZMod p → ℂ) (h0 : f 0 = 0) :
    2 * ∑ a, (if IsSquare a then f a else 0)
      = ∑ a, f a + ∑ a, (quadraticChar (ZMod p) a : ℂ) * f a := by
  rw [two_mul_sum_isSquare p f, h0, add_zero]

/-- A sanity corollary: with `f = 1` the step counts the squares.  In `ZMod p`
with `p` odd there are `(p+1)/2` squares, including zero. -/
theorem sum_square_indicator (hp : p ≠ 2) :
    ∑ a : ZMod p, (if IsSquare a then (1 : ℂ) else 0) = ((p : ℂ) + 1) / 2 := by
  have hodd : ringChar (ZMod p) ≠ 2 := (ZMod.ringChar_zmod_n p).substr hp
  have hχ : ∑ a : ZMod p, (quadraticChar (ZMod p) a : ℂ) = 0 := by
    rw [← Int.cast_sum, quadraticChar_sum_zero (F := ZMod p) hodd]
    simp
  have h := two_mul_sum_isSquare p (fun _ : ZMod p => (1 : ℂ))
  simp only [mul_one, Finset.sum_const, Finset.card_univ, ZMod.card, nsmul_eq_mul] at h
  rw [hχ, add_zero] at h
  rw [eq_div_iff (by norm_num : (2 : ℂ) ≠ 0), mul_comm]
  exact h

end Twist
