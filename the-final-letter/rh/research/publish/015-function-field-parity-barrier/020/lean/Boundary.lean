/-
  Boundary.lean — 020 round 108.

  Why the boundary stratum of the coprime-pair expansion has coefficient 0 or 1:
  when the modulus m = d·e has degree larger than n, a residue class modulo m
  contains at most one polynomial of degree n.  Hence `C(d,e) ∈ {0,1}` on the
  boundary, and the truncation `deg d + deg e ≤ n` is not a valid cut.
-/
import Mathlib

open Polynomial

namespace Boundary

variable {F : Type*} [Field F]

/-- If `m ∣ f - g` and `deg (f - g) < deg m`, then `f = g`. -/
theorem eq_of_dvd_sub {m f g : F[X]} (hm : m.Monic)
    (hdvd : m ∣ f - g) (hdeg : (f - g).natDegree < m.natDegree) : f = g := by
  have hzero : f - g = 0 := by
    by_contra hne
    exact (hm.not_dvd_of_natDegree_lt hne hdeg) hdvd
  exact sub_eq_zero.mp hzero

/-- **Uniqueness on the boundary.** Two polynomials of the same degree `n`
that are congruent modulo `m`, with `n < deg m`, are equal.  This is the lemma
that makes the boundary coefficients `0` or `1`. -/
theorem unique_of_deg_lt {m f g : F[X]} (hm : m.Monic) {n : ℕ}
    (hdeg : n < m.natDegree)
    (hfn : f.natDegree = n) (hgn : g.natDegree = n)
    (hdvd : m ∣ f - g) : f = g := by
  refine eq_of_dvd_sub hm hdvd ?_
  have hle : (f - g).natDegree ≤ n := by
    simpa [hfn, hgn] using natDegree_sub_le f g
  exact lt_of_le_of_lt hle hdeg

end Boundary
