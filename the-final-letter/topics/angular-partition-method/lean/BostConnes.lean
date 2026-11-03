import Mathlib

/-!
# Bost–Connes periodic-orbit data

The Bost–Connes periodic orbits have lengths `n log p`.  This file records the
two exact angular sums that are visible in the convergence domain:

* the single-prime angular series is a geometric series with ratio
  `p^(-s)`, hence has the exact closed form `1 / (1 - p^(-s))`;
* the all-prime angular product is the Riemann-zeta Euler product.

It also proves the elementary commensurability obstruction: for distinct
primes `p` and `q`, the logarithms `log p` and `log q` have no common positive
period.  This is the precise reason there is no finite-monodromy replacement
for the full prime data; the Euler product is the exact replacement in the
convergence domain, while continuation beyond it is the separate O7/O8 layer.
-/

namespace AngularPartition

open scoped BigOperators

/-- The single-prime Bost–Connes angular ratio `p^(-s)`. -/
noncomputable def bostConnesRatio (p : ℕ) (s : ℂ) : ℂ :=
  (p : ℂ) ^ (-s)

/-- **Single-prime exact angular sum.**
For a prime `p` and `Re(s) > 0`, the periodic-orbit series
`Σ n, (p^(-s))^n` converges exactly to `1/(1-p^(-s))`. -/
theorem bostConnes_single_prime_angular {p : ℕ} (hp : p.Prime) {s : ℂ}
    (hs : 0 < s.re) :
    HasSum (fun n : ℕ => (bostConnesRatio p s) ^ n) (1 - bostConnesRatio p s)⁻¹ := by
  unfold bostConnesRatio
  apply hasSum_geometric_of_norm_lt_one
  rw [show (p : ℂ) = ((p : ℝ) : ℂ) by norm_num,
    Complex.norm_cpow_eq_rpow_re_of_pos (show (0 : ℝ) < p by exact_mod_cast hp.pos)]
  simpa [Complex.neg_re] using
    Real.rpow_lt_one_of_one_lt_of_neg (by exact_mod_cast hp.one_lt) (by linarith : -s.re < 0)

/-- The single-prime exact angular sum in `tsum` form. -/
theorem bostConnes_single_prime_tsum {p : ℕ} (hp : p.Prime) {s : ℂ}
    (hs : 0 < s.re) :
    (∑' n : ℕ, (bostConnesRatio p s) ^ n) = (1 - bostConnesRatio p s)⁻¹ :=
  (bostConnes_single_prime_angular hp hs).tsum_eq

/-- **All-prime exact angular product.**
For `Re(s) > 1`, the product of the single-prime angular sums is the Riemann
zeta Euler product. -/
theorem bostConnes_all_primes_product {s : ℂ} (hs : 1 < s.re) :
    HasProd (fun p : Nat.Primes => (1 - (p : ℂ) ^ (-s))⁻¹) (riemannZeta s) :=
  riemannZeta_eulerProduct_hasProd hs

/-- The all-prime product in `tprod` form. -/
theorem bostConnes_all_primes_tprod {s : ℂ} (hs : 1 < s.re) :
    (∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹) = riemannZeta s :=
  riemannZeta_eulerProduct_tprod hs

/-- **No common positive period for two distinct prime logs.**
If `p` and `q` are distinct primes and `m,n > 0`, then
`m log p ≠ n log q`.  Hence the periodic-orbit angles of two distinct primes
are not commensurable. -/
theorem log_primes_not_commensurable {p q : ℕ} (hp : p.Prime) (hq : q.Prime)
    (hpq : p ≠ q) {m n : ℕ} (hm : 0 < m) (_hn : 0 < n) :
    (m : ℝ) * Real.log p ≠ (n : ℝ) * Real.log q := by
  intro h
  have hp0 : (0 : ℝ) < p := by exact_mod_cast hp.pos
  have hq0 : (0 : ℝ) < q := by exact_mod_cast hq.pos
  have hexp := congrArg Real.exp h
  rw [Real.exp_nat_mul, Real.exp_nat_mul, Real.exp_log hp0, Real.exp_log hq0] at hexp
  have hnat : p ^ m = q ^ n := by exact_mod_cast hexp
  have hdvd : p ∣ q ^ n := by
    rw [← hnat]
    exact dvd_pow_self p (Nat.pos_iff_ne_zero.mp hm)
  exact hpq (Nat.prime_eq_prime_of_dvd_pow hp hq hdvd)

end AngularPartition
