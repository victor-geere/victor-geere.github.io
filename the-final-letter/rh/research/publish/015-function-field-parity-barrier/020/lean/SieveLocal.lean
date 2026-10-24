/-
  SieveLocal.lean — 020 round 109.

  The local factor that makes the twin sieve two-dimensional: modulo a prime,
  exactly two residues a satisfy a(a+h) = 0 when h ≠ 0 (namely 0 and -h).
  This is the "2" in A[d,e] = 2^omega(lcm) q^(n-deg lcm).
-/
import Mathlib

open Finset

namespace SieveLocal

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- Two residues solve `a (a + h) = 0` when `h ≠ 0`: `0` and `-h`. -/
theorem card_roots_mul {h : F} (hh : h ≠ 0) :
    (univ.filter (fun a : F => a * (a + h) = 0)).card = 2 := by
  have hneg : (-h : F) ≠ 0 := neg_ne_zero.mpr hh
  have hset : (univ.filter (fun a : F => a * (a + h) = 0)) = ({0, -h} : Finset F) := by
    ext a
    simp only [mem_filter, mem_univ, true_and, mem_insert, mem_singleton]
    constructor
    · intro h
      rcases mul_eq_zero.mp h with h0 | h1
      · exact Or.inl h0
      · exact Or.inr (eq_neg_of_add_eq_zero_left h1)
    · rintro (rfl | rfl)
      · simp
      · simp
  rw [hset]
  exact card_pair (Ne.symm hneg)



/-- The dimension doubles: at two independent primes there are `2 * 2 = 4`
residue pairs with `a(a+h) = 0` in each coordinate.  This is the `2^2` of the
dimension-2 sieve, measured as 4 in round 110. -/
theorem card_roots_prod {h : F} (hh : h ≠ 0) :
    (univ.filter (fun p : F × F => p.1 * (p.1 + h) = 0 ∧ p.2 * (p.2 + h) = 0)).card = 4 := by
  have hset : (univ.filter (fun p : F × F => p.1 * (p.1 + h) = 0 ∧ p.2 * (p.2 + h) = 0))
      = (univ.filter (fun a : F => a * (a + h) = 0))
        ×ˢ (univ.filter (fun a : F => a * (a + h) = 0)) := by
    ext p
    simp
  rw [hset, card_product, card_roots_mul hh]


/-- The local factor for three independent primes: `2^3 = 8` residue triples.
This is the `2^k` of the dimension-`k` sieve, `k = 3`. -/
theorem card_roots_three {h : F} (hh : h ≠ 0) :
    (univ.filter (fun p : F × F × F =>
        p.1 * (p.1 + h) = 0 ∧ p.2.1 * (p.2.1 + h) = 0 ∧ p.2.2 * (p.2.2 + h) = 0)).card = 8 := by
  have hA : (univ.filter (fun a : F => a * (a + h) = 0)).card = 2 := card_roots_mul hh
  have hset : (univ.filter (fun p : F × F × F =>
        p.1 * (p.1 + h) = 0 ∧ p.2.1 * (p.2.1 + h) = 0 ∧ p.2.2 * (p.2.2 + h) = 0))
      = (univ.filter (fun a : F => a * (a + h) = 0))
        ×ˢ ((univ.filter (fun a : F => a * (a + h) = 0))
          ×ˢ (univ.filter (fun a : F => a * (a + h) = 0))) := by
    ext p
    simp [and_assoc]
  rw [hset, card_product, card_product, hA]

end SieveLocal
