import Mathlib
import Topic

/-!
# Product-to-sum for Euler products

This file formalises the exact product-to-sum step behind the annular
representation of Euler products:

* a finite Euler product is the exponential of the sum of the logarithms of
  its local factors;
* for the Riemann zeta Euler product, the prime log-series is summable and its
  exponential is `ζ(s)` for `re s > 1`.

The logarithmic sum is the object to which the annular/coil representation is
applied; the analyticity of the logarithm is only used where the local factors
are nonzero.
-/

namespace AngularPartition

open scoped BigOperators

/-- The `n`-th prime, as an element of `Nat.Primes`. -/
noncomputable def nthPrime (n : ℕ) : Nat.Primes :=
  ⟨Nat.nth Nat.Prime n, Nat.nth_mem_of_infinite Nat.infinite_setOfPred_prime n⟩

/-- The prime enumeration is injective. -/
theorem nthPrime_injective : Function.Injective nthPrime := by
  intro m n h
  apply Nat.nth_injective Nat.infinite_setOfPred_prime
  exact congrArg Subtype.val h

/-- **Finite product-to-sum.**
For a finite set of local factors whose factors are nonzero, the product is the
exponential of the sum of the logarithms. This is the exact finite form of the
product-to-sum transform; no truncation of an infinite product is involved. -/
theorem finite_eulerProduct_exp_log (P : Finset ℕ) (s : ℂ)
    (h : ∀ p ∈ P, 1 - (p : ℂ) ^ (-s) ≠ 0) :
    (∏ p ∈ P, (1 - (p : ℂ) ^ (-s))⁻¹) =
      Complex.exp (∑ p ∈ P, -Complex.log (1 - (p : ℂ) ^ (-s))) := by
  rw [Complex.exp_sum]
  apply Finset.prod_congr rfl
  intro p hp
  rw [Complex.exp_neg, Complex.exp_log (h p hp)]

/-- The prime log-series of the Riemann zeta Euler product is summable for
`re s > 1`. This is the summability input for its annular/coil
representation. -/
theorem eulerLogSeries_summable {s : ℂ} (hs : 1 < s.re) :
    Summable (fun p : Nat.Primes => -Complex.log (1 - (p : ℂ) ^ (-s))) := by
  have h := (summable_riemannZetaSummand hs).of_norm.clog_one_sub.neg.subtype Nat.Prime
  have h' : Summable (fun p : Nat.Primes =>
      -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) p)) := by
    simpa [Nat.Primes, Function.comp_def] using h
  exact h'.congr (fun p => by simp [riemannZetaSummandHom])

/-- **Euler product-to-sum for `ζ`.**
For `re s > 1`, the exponential of the prime log-series is the Riemann zeta
function. Equivalently, the Euler product is the exponential of the annular
log-sum. -/
theorem riemannZeta_eulerProduct_exp_log {s : ℂ} (hs : 1 < s.re) :
    Complex.exp (∑' p : Nat.Primes, -Complex.log (1 - (p : ℂ) ^ (-s))) = riemannZeta s := by
  have h := EulerProduct.exp_tsum_primes_log_eq_tsum
    (f := riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs))
    (summable_riemannZetaSummand hs)
  rw [tsum_riemannZetaSummand hs] at h
  simpa [riemannZetaSummandHom, MonoidWithZeroHom.coe_mk, ZeroHom.coe_mk, Nat.Primes, Function.comp_def] using h

/-- Combined product-to-sum and summability statement: the Euler log-series is
summable and its exponential is `ζ(s)`. -/
theorem riemannZeta_eulerProduct_product_to_sum {s : ℂ} (hs : 1 < s.re) :
    Summable (fun p : Nat.Primes => -Complex.log (1 - (p : ℂ) ^ (-s))) ∧
      Complex.exp (∑' p : Nat.Primes, -Complex.log (1 - (p : ℂ) ^ (-s))) = riemannZeta s :=
  ⟨eulerLogSeries_summable hs, riemannZeta_eulerProduct_exp_log hs⟩

/-- The log-series is summable after enumerating the primes by `Nat.nth`. -/
theorem eulerLogSeries_summable_nth {s : ℂ} (hs : 1 < s.re) :
    Summable (fun n : ℕ => -Complex.log (1 -
    riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) := by
  exact (eulerLogSeries_summable hs).comp_injective nthPrime_injective

/-- **Annular/coil representation of the Euler log-series.**
After enumerating the primes, the log-series has the phase-carrying annular
representation: its terms are the differences of successive tail coils, the
tail is represented by radius and phase, and the coil spirals to the origin.
-/
theorem eulerLogSeries_coil {s : ℂ} (hs : 1 < s.re) :
    (∀ n, -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n)) =
      ctail (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) n -
        ctail (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) (n + 1)) ∧
      (∀ n, ctail (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) n =
        (coilRadius (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) n : ℂ) *
          Complex.exp (coilAngle (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) n * Complex.I)) ∧
      Filter.Tendsto (fun n => ctail (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n))) n)
        Filter.atTop (nhds 0) :=
  phase_carrying_coil (fun n : ℕ => -Complex.log (1 - riemannZetaSummandHom (Complex.ne_zero_of_one_lt_re hs) (nthPrime n)))
    (eulerLogSeries_summable_nth hs)

end AngularPartition
