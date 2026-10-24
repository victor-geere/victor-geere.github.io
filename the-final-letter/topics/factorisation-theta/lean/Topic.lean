import Mathlib

/-!
# Factorisation and theta — formal core

The archived essay starts from the divisor detector

`f_k(x) = cos (2π k / x) + cos (2π x) - 2`

and claims that its roots are exactly the integer divisors of `k`, each a
double zero.  It then passes to the theta function

`θ(t) = Σ_{n ∈ ℤ} exp (-π n² t)`

and sketches the Mellin-transform route to the zeta functional equation.

This file formalises the elementary layer that the essay actually proves:

* the detector is non-positive everywhere, because each cosine is at most one;
* it vanishes exactly when both cosines equal one;
* it is even in `x`, matching the essay's `f(-d) = f(d)`;
* every non-zero integer divisor of `k` is a root;
* conversely an integer root is a divisor of `k`;
* the finite theta sum is positive and antitone in `t`.

The infinite theta functional equation, the Mellin transform, and the
zeta/RH bridge are *not* formalised; they are recorded as source claims and
open items in the programme README.
-/

noncomputable section

open scoped BigOperators

namespace FactorisationTheta

/-- The divisor-detection function `f_k(x) = cos(2πk/x) + cos(2πx) - 2`,
defined for real `x` with the usual total convention at `x = 0`. -/
def divisorDetector (k : ℕ) (x : ℝ) : ℝ :=
  Real.cos (2 * Real.pi * (k : ℝ) / x) + Real.cos (2 * Real.pi * x) - 2

/-- The finite theta sum `Θ_N(t) = Σ_{n=0}^{N-1} exp(-π n² t)`. -/
def finiteTheta (N : ℕ) (t : ℝ) : ℝ :=
  ∑ n ∈ Finset.range N, Real.exp (-(Real.pi * (n : ℝ) ^ 2 * t))

/-- The detector is non-positive: `cos A + cos B - 2 ≤ 0`. -/
theorem divisorDetector_nonpos (k : ℕ) (x : ℝ) : divisorDetector k x ≤ 0 := by
  have h1 : Real.cos (2 * Real.pi * (k : ℝ) / x) ≤ 1 := Real.cos_le_one _
  have h2 : Real.cos (2 * Real.pi * x) ≤ 1 := Real.cos_le_one _
  unfold divisorDetector
  linarith

/-- The detector vanishes exactly when both cosines equal one. -/
theorem divisorDetector_eq_zero_iff (k : ℕ) (x : ℝ) :
    divisorDetector k x = 0 ↔
      Real.cos (2 * Real.pi * (k : ℝ) / x) = 1 ∧ Real.cos (2 * Real.pi * x) = 1 := by
  constructor
  · intro h
    have h1 : Real.cos (2 * Real.pi * (k : ℝ) / x) ≤ 1 := Real.cos_le_one _
    have h2 : Real.cos (2 * Real.pi * x) ≤ 1 := Real.cos_le_one _
    unfold divisorDetector at h
    constructor <;> linarith
  · rintro ⟨h1, h2⟩
    unfold divisorDetector
    rw [h1, h2]
    ring

/-- The detector is even in `x`, so a root at `d` gives a root at `-d`. -/
theorem divisorDetector_neg (k : ℕ) (x : ℝ) :
    divisorDetector k (-x) = divisorDetector k x := by
  unfold divisorDetector
  by_cases hx : x = 0
  · simp [hx]
  · rw [show 2 * Real.pi * (k : ℝ) / (-x) = -(2 * Real.pi * (k : ℝ) / x) by
        field_simp,
      show 2 * Real.pi * (-x) = -(2 * Real.pi * x) by ring,
      Real.cos_neg, Real.cos_neg]

/-- Every non-zero divisor of `k` is a root of the detector. -/
theorem divisorDetector_of_dvd {k d : ℕ} (hd : d ∣ k) (hd0 : d ≠ 0) :
    divisorDetector k (d : ℝ) = 0 := by
  rcases hd with ⟨m, rfl⟩
  have hdR : (d : ℝ) ≠ 0 := by exact_mod_cast hd0
  have harg : 2 * Real.pi * ((d * m : ℕ) : ℝ) / (d : ℝ) = (m : ℝ) * (2 * Real.pi) := by
    rw [Nat.cast_mul]
    field_simp
  unfold divisorDetector
  rw [harg,
    Real.cos_nat_mul_two_pi,
    show 2 * Real.pi * (d : ℝ) = (d : ℝ) * (2 * Real.pi) by ring,
    Real.cos_nat_mul_two_pi]
  ring

/-- Conversely, a non-zero integer root of the detector divides `k`.  Together
with `divisorDetector_eq_zero_iff` this is the essay's "roots are exactly the
integer divisors" claim, stated on integer inputs. -/
theorem divisorDetector_eq_zero_iff_dvd {k : ℕ} {x : ℤ} (hx : x ≠ 0) :
    divisorDetector k (x : ℝ) = 0 ↔ x ∣ (k : ℤ) := by
  constructor
  · intro h
    rw [divisorDetector_eq_zero_iff] at h
    obtain ⟨h1, _⟩ := h
    obtain ⟨n, hn⟩ := (Real.cos_eq_one_iff _).mp h1
    have hxR : (x : ℝ) ≠ 0 := by exact_mod_cast hx
    have hkx : (n : ℝ) * (x : ℝ) = (k : ℝ) := by
      apply mul_right_cancel₀ (by positivity : (2 * Real.pi : ℝ) ≠ 0)
      calc
        (n : ℝ) * (x : ℝ) * (2 * Real.pi) = ((n : ℝ) * (2 * Real.pi)) * (x : ℝ) := by
          ring
        _ = ((2 * Real.pi) * (k : ℝ) / (x : ℝ)) * (x : ℝ) := by rw [hn]
        _ = (k : ℝ) * (2 * Real.pi) := by
          field_simp
    have hkZ : n * x = (k : ℤ) := by
      exact_mod_cast hkx
    exact ⟨n, by rw [mul_comm]; exact hkZ.symm⟩
  · rintro ⟨m, hm⟩
    have hxR : (x : ℝ) ≠ 0 := by exact_mod_cast hx
    have hmR : (k : ℝ) = (x : ℝ) * (m : ℝ) := by exact_mod_cast hm
    unfold divisorDetector
    have hdiv : 2 * Real.pi * (k : ℝ) / (x : ℝ) = (m : ℝ) * (2 * Real.pi) := by
      rw [hmR]
      field_simp
    rw [hdiv, Real.cos_int_mul_two_pi,
      show 2 * Real.pi * (x : ℝ) = (x : ℝ) * (2 * Real.pi) by ring,
      Real.cos_int_mul_two_pi]
    ring

/-- The finite theta sum is positive as soon as it has a term. -/
theorem finiteTheta_pos (N : ℕ) (hN : 0 < N) (t : ℝ) : 0 < finiteTheta N t := by
  unfold finiteTheta
  apply Finset.sum_pos
  · intro n _
    exact Real.exp_pos _
  · exact Finset.nonempty_range_iff.mpr (Nat.pos_iff_ne_zero.mp hN)

/-- The finite theta sum is antitone in `t`: larger `t` gives faster decay. -/
theorem finiteTheta_antitone (N : ℕ) : Antitone (finiteTheta N) := by
  intro t1 t2 h
  unfold finiteTheta
  apply Finset.sum_le_sum
  intro n _
  apply Real.exp_le_exp.mpr
  have hn : (0 : ℝ) ≤ (n : ℝ) ^ 2 := sq_nonneg _
  have hcoef : (0 : ℝ) ≤ Real.pi * (n : ℝ) ^ 2 :=
    mul_nonneg (le_of_lt Real.pi_pos) hn
  nlinarith [mul_le_mul_of_nonneg_left h hcoef]

end FactorisationTheta
