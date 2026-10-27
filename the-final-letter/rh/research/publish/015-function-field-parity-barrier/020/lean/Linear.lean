/-
  Linear.lean — 020 round 115.

  The degree-one base case of the twin count: shifting a monic linear
  polynomial by a constant keeps it monic linear, hence irreducible.  So every
  one of the q monic linears contributes, i.e. T(1) = q -- the base case used
  in the numerics of round 115.
-/
import Mathlib

open Polynomial

namespace Linear

variable {F : Type*} [Field F]

/-- `p + C h` is irreducible whenever `p` is monic of degree one. -/
theorem shift_linear {p : F[X]} (hp : p.Monic) (hd : p.natDegree = 1) (h : F) :
    Irreducible (p + Polynomial.C h) := by
  have hmonic : (p + Polynomial.C h).Monic := by
    apply hp.add_of_left
    rw [degree_eq_natDegree hp.ne_zero, hd]
    exact lt_of_le_of_lt degree_C_le (by norm_num)
  have hdeg : (p + Polynomial.C h).natDegree = 1 := by
    rw [natDegree_add_C, hd]
  exact Monic.irreducible_of_degree_eq_one
    (by rw [degree_eq_natDegree hmonic.ne_zero, hdeg]; norm_num) hmonic

end Linear
