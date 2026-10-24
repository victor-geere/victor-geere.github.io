import Mathlib
import Expr

/-!
# Partial sum plus tail — formal core

The programme evaluates `ζ(s)`, `ζ(s,a)` and `L(s,χ)` by an Euler–Maclaurin
decomposition into a finite partial sum and an explicit tail.  This file proves
the transport core of that decomposition and the cos/sin split of the eta
partial sums.  The rational interval algebra and the certificate replay are in
`IBox.lean` and `Expr.lean`; the analytic enclosures for `π`, `log`, `exp`,
`sin`, `cos` remain the trusted leaves documented in `README.md`.
-/

noncomputable section

open scoped BigOperators
open PartialTail

namespace PST

/-! ## Partial sum + tail transport -/

variable {𝕜 : Type*} [RCLike 𝕜]

/-- A finite partial sum plus the shifted tail is the total sum. -/
theorem tsum_eq_finite_add_tail {f : ℕ → 𝕜} (hf : Summable f) (K : ℕ) :
    ∑' n, f n = ∑ n ∈ Finset.range K, f n + ∑' n, f (n + K) :=
  (hf.sum_add_tsum_nat_add K).symm

/-- The truncation residual is bounded by the norm of the shifted tail. -/
theorem truncation_residual_le_tail_norm {f : ℕ → 𝕜} (hf : Summable f) (K : ℕ) :
    ‖(∑' n, f n) - ∑ n ∈ Finset.range K, f n‖ ≤ ∑' n, ‖f (n + K)‖ := by
  rw [tsum_eq_finite_add_tail hf K]
  rw [add_sub_cancel_left]
  have hnorm : Summable fun n : ℕ => ‖f (n + K)‖ :=
    (summable_nat_add_iff K).2 hf.norm
  exact norm_tsum_le_tsum_norm hnorm

/-- The arbitrary finite-family tail bound. -/
theorem truncation_residual_le_finset_tail_norm {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (tail : ι → 𝕜) {lhs computed : 𝕜}
    (hsplit : lhs = computed + ∑ i ∈ s, tail i) :
    ‖lhs - computed‖ ≤ ∑ i ∈ s, ‖tail i‖ := by
  have h : lhs - computed = ∑ i ∈ s, tail i := by
    rw [hsplit]
    abel
  rw [h]
  clear hsplit h
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
      rw [Finset.sum_insert ha]
      calc
        ‖tail a + ∑ i ∈ s, tail i‖ ≤ ‖tail a‖ + ‖∑ i ∈ s, tail i‖ := norm_add_le _ _
        _ ≤ ‖tail a‖ + ∑ i ∈ s, ‖tail i‖ := by linarith [ih]
        _ = ∑ i ∈ insert a s, ‖tail i‖ := by rw [Finset.sum_insert ha]

/-- The three-tail form used by the Euler–Maclaurin / Route C residual. -/
theorem truncation_residual_le_three_tails
    {lhs rhsTrue rhsComputed zeroTail primeTail archTail : 𝕜}
    (hlhs : lhs = rhsTrue)
    (hsplit : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)) :
    ‖lhs - rhsComputed‖ ≤ ‖zeroTail‖ + ‖primeTail‖ + ‖archTail‖ := by
  have h : lhs - rhsComputed = zeroTail + primeTail + archTail := by
    rw [hlhs, hsplit]
    abel
  rw [h]
  calc
    ‖zeroTail + primeTail + archTail‖
        ≤ ‖zeroTail + primeTail‖ + ‖archTail‖ := norm_add_le _ _
    _ ≤ (‖zeroTail‖ + ‖primeTail‖) + ‖archTail‖ := by
          linarith [norm_add_le zeroTail primeTail]
    _ = ‖zeroTail‖ + ‖primeTail‖ + ‖archTail‖ := by ring

/-! ## The eta partial sum and its cos/sin split -/

/-- The finite eta partial sum `η_M(s) = Σ_{n=1}^{M} (-1)^{n-1} n^{-s}`,
written through `n^{-s} = exp(-s log n)`. -/
def etaPartial (M : ℕ) (s : ℂ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 M,
    ((-1 : ℝ) ^ (n - 1) : ℂ) * Complex.exp (-s * (Real.log (n : ℝ) : ℂ))

/-- The cos series of the eta partial sum. -/
def etaCos (M : ℕ) (σ t : ℝ) : ℝ :=
  ∑ n ∈ Finset.Icc 1 M,
    (-1 : ℝ) ^ (n - 1) * (n : ℝ) ^ (-σ) * Real.cos (t * Real.log n)

/-- The sin series of the eta partial sum. -/
def etaSin (M : ℕ) (σ t : ℝ) : ℝ :=
  ∑ n ∈ Finset.Icc 1 M,
    (-1 : ℝ) ^ (n - 1) * (n : ℝ) ^ (-σ) * Real.sin (t * Real.log n)


/-- The imaginary part of a real sign power is zero. -/
theorem negOne_pow_im (n : ℕ) : ((-1 : ℂ) ^ n).im = 0 := by
  induction n with
  | zero => simp
  | succ n ih => rw [pow_succ]; simp [ih]

/-- The real part of a sign power is the real sign power. -/
theorem negOne_pow_re (n : ℕ) : ((-1 : ℂ) ^ n).re = (-1 : ℝ) ^ n := by
  induction n with
  | zero => simp
  | succ n ih => rw [pow_succ]; simp [ih]; ring

/-- The real part of a single eta term. -/
theorem etaTerm_re {n : ℕ} (hn : 1 ≤ n) (σ t : ℝ) :
    (Complex.exp (-(σ + t * Complex.I) * (Real.log (n : ℝ) : ℂ))).re =
      (n : ℝ) ^ (-σ) * Real.cos (t * Real.log (n : ℝ)) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have harg : -(σ + t * Complex.I) * (Real.log (n : ℝ) : ℂ) =
      ((-(σ * Real.log (n : ℝ)) : ℝ) : ℂ) +
        ((-(t * Real.log (n : ℝ)) : ℝ) : ℂ) * Complex.I := by
    push_cast
    ring
  rw [harg, Complex.exp_add, Complex.exp_ofReal_mul_I]
  simp only [Complex.add_re, Complex.add_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.mul_re, Complex.mul_im, Complex.I_re, Complex.I_im,
    Complex.exp_ofReal_re, Complex.exp_ofReal_im, zero_mul, sub_zero, add_zero,
    mul_one, mul_zero]
  rw [Real.exp_neg]
  have hexp : Real.exp (σ * Real.log (n : ℝ)) = (n : ℝ) ^ σ := by
    rw [Real.rpow_def_of_pos hnpos]; ring
  rw [hexp, Real.cos_neg, Real.rpow_neg (le_of_lt hnpos) σ]

/-- The imaginary part of a single eta term. -/
theorem etaTerm_im {n : ℕ} (hn : 1 ≤ n) (σ t : ℝ) :
    (Complex.exp (-(σ + t * Complex.I) * (Real.log (n : ℝ) : ℂ))).im =
      -((n : ℝ) ^ (-σ) * Real.sin (t * Real.log (n : ℝ))) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have harg : -(σ + t * Complex.I) * (Real.log (n : ℝ) : ℂ) =
      ((-(σ * Real.log (n : ℝ)) : ℝ) : ℂ) +
        ((-(t * Real.log (n : ℝ)) : ℝ) : ℂ) * Complex.I := by
    push_cast
    ring
  rw [harg, Complex.exp_add, Complex.exp_ofReal_mul_I]
  simp only [Complex.add_re, Complex.add_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.mul_re, Complex.mul_im, Complex.I_re, Complex.I_im,
    Complex.exp_ofReal_re, Complex.exp_ofReal_im, zero_mul, sub_zero, add_zero,
    mul_one, mul_zero]
  rw [Real.exp_neg]
  have hexp : Real.exp (σ * Real.log (n : ℝ)) = (n : ℝ) ^ σ := by
    rw [Real.rpow_def_of_pos hnpos]; ring
  rw [hexp, Real.sin_neg, Real.rpow_neg (le_of_lt hnpos) σ]
  ring_nf

/-- The real part of the eta partial sum is the cos series. -/
theorem etaPartial_re (M : ℕ) (σ t : ℝ) :
    (etaPartial M (σ + t * Complex.I)).re = etaCos M σ t := by
  unfold etaPartial etaCos
  rw [Complex.re_sum]
  refine Finset.sum_congr rfl fun n hn => ?_
  have hn1 : 1 ≤ n := (Finset.mem_Icc.mp hn).1
  rw [Complex.mul_re, etaTerm_re hn1]
  simp [negOne_pow_im, negOne_pow_re]
  ring

/-- The imaginary part of the eta partial sum is minus the sin series. -/
theorem etaPartial_im (M : ℕ) (σ t : ℝ) :
    (etaPartial M (σ + t * Complex.I)).im = -etaSin M σ t := by
  unfold etaPartial etaSin
  rw [Complex.im_sum]
  rw [← Finset.sum_neg_distrib]
  refine Finset.sum_congr rfl fun n hn => ?_
  have hn1 : 1 ≤ n := (Finset.mem_Icc.mp hn).1
  rw [Complex.mul_im, etaTerm_im hn1]
  simp [negOne_pow_im, negOne_pow_re]
  ring

end PST

end
