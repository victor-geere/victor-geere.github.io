/-
  Grading.lean — 020 round 111.

  Why the degree grading makes the Legendre sieve exact at `y = n/2`: every
  nontrivial factorisation of a degree-`n` polynomial has a factor of degree at
  most `n/2`.  This is the lemma that bounds the growth of the sieve support by
  the degree, which is exactly what fails over Z.
-/
import Mathlib

open Polynomial

namespace Grading

variable {F : Type*} [Field F]

/-- A nontrivial factor of `f` has degree at most half of `deg f`. -/
theorem exists_two_mul_le {f g h : F[X]} (hf : f = g * h)
    (hg0 : g ≠ 0) (hh0 : h ≠ 0) (hgd : g.natDegree ≠ 0) (hhd : h.natDegree ≠ 0) :
    2 * g.natDegree ≤ f.natDegree ∨ 2 * h.natDegree ≤ f.natDegree := by
  have hdeg : f.natDegree = g.natDegree + h.natDegree := by
    rw [hf, natDegree_mul hg0 hh0]
  have hg1 : 0 < g.natDegree := Nat.pos_of_ne_zero hgd
  have hh1 : 0 < h.natDegree := Nat.pos_of_ne_zero hhd
  omega

/-- Contrapositive form: if one factor has degree `> n/2`, the other has
degree `≤ n/2`.  Hence no reducible `f` of degree `n` escapes the sieve level. -/
theorem not_both_large {f g h : F[X]} (hf : f = g * h)
    (hg0 : g ≠ 0) (hh0 : h ≠ 0) (hgd : g.natDegree ≠ 0) (hhd : h.natDegree ≠ 0)
    (hgt : f.natDegree < 2 * g.natDegree) : 2 * h.natDegree ≤ f.natDegree := by
  rcases exists_two_mul_le hf hg0 hh0 hgd hhd with h | h
  · omega
  · exact h

end Grading
