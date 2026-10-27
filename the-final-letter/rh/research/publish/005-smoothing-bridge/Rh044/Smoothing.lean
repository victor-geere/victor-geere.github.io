/-
  Smoothing.lean — the algebraic layer of rh044: smoothed partial sums of the
  zeta Dirichlet series.

  For `N : ℕ`, a complex argument `s` and a *weight* `φ : ℝ → ℝ` (sampled at the
  normalised abscissae `n/N`) this file studies the two finite sums

      zetaSum N s        = ∑_{n=1}^{N} zetaTerm s n            (sharp cutoff),
      smoothedSum N φ s  = ∑_{n=1}^{N} φ (n/N) · zetaTerm s n  (smoothed),

  where the individual Dirichlet term is

      zetaTerm s n = exp (-(s · log n))         (`n^{-s}`, principal branch).

  The indices run over `Finset.Icc 1 N` throughout — the same range as the
  partial sums of the round and of `Rh43.Balance`, so that `N = 0` gives the
  empty (zero) sum and the summand `n = 1` is always present for `N ≥ 1`.  (The
  equivalent `Finset.range N` with `n + 1` is *not* used, so that the index in
  the statements is literally the Dirichlet index `n`.)  No analytic
  continuation, no zeta function and no infinite series enter the definitions:
  everything is an ordinary finite sum over `ℂ`.

  The mathematical content of the file is the bridge between the sharp and the
  smoothed truncation:

  * `zetaTerm_eq` — the term is the principal-branch power: for `n ≥ 1`,
    `zetaTerm s n = (n : ℂ) ^ (-s)`.  Consequently `‖zetaTerm (σ + t·I) n‖`
    depends only on the real part `σ`, namely `abs_zetaTerm` gives the exact
    radial decay `‖zetaTerm (σ + t·I) n‖ = n^{-σ}`.
  * `weighted_decomposition` — the *key exact identity*: the sharp and the
    smoothed sums differ term by term by the "weight defect" `1 - φ (n/N)`,
    `zetaSum N s - smoothedSum N φ s = ∑_{n≤N} (1 - φ (n/N)) · zetaTerm s n`.
    It is pure algebra (no estimates), and the two degenerate weights are
    recovered from it: `smoothedSum_one` (`φ ≡ 1` is the sharp sum) and
    `smoothedSum_zero_of_weight_eq_zero` (`φ (n/N) = 0` on the range makes the
    smoothed sum vanish — the trivial obstruction that has to be excluded for
    the numerics to mean anything).
  * `norm_smoothedSum_sub_smoothedSum_le` and its specialisations — the
    elementary rigorous error bound obtained from the triangle inequality for
    the norm on `ℂ`,
    `‖smoothedSum N φ s - zetaSum N s‖ ≤ ∑_{n≤N} ‖1 - φ (n/N)‖ · n^{-σ}`.
    This is the estimate that the numerical round refines into the error laws
    `O(√N)` (sharp) versus `O(N^{-σ})` (smooth).
  * `summable_norm_zetaTerm` — absolute convergence of the tail for `σ > 1`:
    the `ℕ`-indexed series `∑' n, ‖zetaTerm (σ : ℂ) (n + 1)‖` is summable, by
    comparison with the real `p`-series (`Real.summable_nat_rpow`), together
    with the explicit comparison `norm_zetaTerm_le_rpow`.
  * the quadratic weight `quadWeight u = u (1 - u)` used by the round, its
    vanishing at the endpoint `u = 1` (which is what removes the sharp-cutoff
    fluctuation), the split of `smoothedSum N quadWeight s` into two
    `zetaSum`-type pieces, and the exact closed form of its weight defect
    `1 - (n/N)(1 - n/N) = (N² - nN + n²) / N²`.

  Everything below is proved from Mathlib alone; there is no `sorry`, no extra
  axiom and no computation by reflection.
-/
import Mathlib

namespace Rh044

noncomputable section

open scoped BigOperators

/-! ## 1. The Dirichlet term, the sharp sum and the smoothed sum -/

/-- The `n`-th term of the zeta Dirichlet series at `s`, with the principal
branch of the logarithm: `zetaTerm s n = exp (-(s * log n))`.  This is `n^{-s}`
for `n ≥ 1` (`zetaTerm_eq`); for `n = 0` the real `log 0 = 0` makes the term
`1`, which is never used. -/
noncomputable def zetaTerm (s : ℂ) (n : ℕ) : ℂ := Complex.exp (-(s * Real.log n))

/-- The sharp partial sum `∑_{n=1}^{N} n^{-s}`, an ordinary finite sum over the
range `Finset.Icc 1 N` (empty, hence `0`, when `N = 0`). -/
noncomputable def zetaSum (N : ℕ) (s : ℂ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 N, zetaTerm s n

/-- The smoothed partial sum `∑_{n=1}^{N} φ (n/N) · n^{-s}` with weight
`φ : ℝ → ℝ` sampled at the normalised abscissae `n/N`. -/
noncomputable def smoothedSum (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 N, ((φ ((n : ℝ) / N) : ℝ) : ℂ) * zetaTerm s n

/-- The defining equation of `zetaTerm`, for rewriting. -/
theorem zetaTerm_def (s : ℂ) (n : ℕ) : zetaTerm s n = Complex.exp (-(s * Real.log n)) :=
  rfl

/-- The defining equation of `zetaSum`, for rewriting. -/
theorem zetaSum_def (N : ℕ) (s : ℂ) : zetaSum N s = ∑ n ∈ Finset.Icc 1 N, zetaTerm s n :=
  rfl

/-- The defining equation of `smoothedSum`, for rewriting. -/
theorem smoothedSum_def (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    smoothedSum N φ s
      = ∑ n ∈ Finset.Icc 1 N, ((φ ((n : ℝ) / N) : ℝ) : ℂ) * zetaTerm s n :=
  rfl

/-- Every Dirichlet term is non-zero: it is an exponential. -/
theorem zetaTerm_ne_zero (s : ℂ) (n : ℕ) : zetaTerm s n ≠ 0 := by
  rw [zetaTerm]
  exact Complex.exp_ne_zero _

/-- **The term is the principal-branch power.**  For `n ≥ 1` the two definitions
agree: `zetaTerm s n = (n : ℂ) ^ (-s)`. -/
theorem zetaTerm_eq (s : ℂ) {n : ℕ} (hn : 1 ≤ n) : zetaTerm s n = (n : ℂ) ^ (-s) := by
  have hn0 : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  rw [zetaTerm, Complex.cpow_def_of_ne_zero hn0, Complex.natCast_log]
  congr 1
  ring_nf

/-- The elementary restatement used in the brief: the term at `n = 1` is `1`. -/
theorem zetaTerm_one (s : ℂ) : zetaTerm s 1 = 1 := by
  rw [zetaTerm]
  simp [Real.log_one]

/-! ## 2. The exact weighted decomposition -/

/-- **Key exact identity (weight defect).**  The sharp sum and the smoothed sum
differ term by term by the defect `1 - φ (n/N)`:
`zetaSum N s - smoothedSum N φ s = ∑_{n≤N} (1 - φ (n/N)) · zetaTerm s n`.
Pure algebra; no estimate is involved. -/
theorem weighted_decomposition (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    zetaSum N s - smoothedSum N φ s
      = ∑ n ∈ Finset.Icc 1 N, (((1 - φ ((n : ℝ) / N) : ℝ)) : ℂ) * zetaTerm s n := by
  rw [zetaSum, smoothedSum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun n _ => ?_
  push_cast
  ring_nf

/-- **The weight `φ ≡ 1` recovers the sharp sum.** -/
theorem smoothedSum_one (N : ℕ) (s : ℂ) :
    smoothedSum N (fun _ : ℝ => 1) s = zetaSum N s := by
  rw [smoothedSum, zetaSum]
  refine Finset.sum_congr rfl fun n _ => ?_
  simp

/-- **A weight vanishing on the sampled abscissae gives the zero sum.**  This is
the trivial obstruction: no error estimate about `smoothedSum N φ s` can hold
for such a `φ`, since the smoothed sum is exactly `0`. -/
theorem smoothedSum_zero_of_weight_eq_zero (N : ℕ) (φ : ℝ → ℝ) (s : ℂ)
    (h : ∀ n ∈ Finset.Icc 1 N, φ ((n : ℝ) / N) = 0) : smoothedSum N φ s = 0 := by
  rw [smoothedSum]
  refine Finset.sum_eq_zero fun n hn => ?_
  rw [h n hn]
  simp

/-- The decomposition specialised to a weight vanishing on the range: the sharp
sum equals the weight-defect sum. -/
theorem zetaSum_eq_sum_defect_of_weight_eq_zero (N : ℕ) (φ : ℝ → ℝ) (s : ℂ)
    (h : ∀ n ∈ Finset.Icc 1 N, φ ((n : ℝ) / N) = 0) :
    zetaSum N s
      = ∑ n ∈ Finset.Icc 1 N, (((1 - φ ((n : ℝ) / N) : ℝ)) : ℂ) * zetaTerm s n := by
  have hdec := weighted_decomposition N φ s
  rwa [smoothedSum_zero_of_weight_eq_zero N φ s h, sub_zero] at hdec

/-! ## 3. The triangle-inequality error bound -/

/-- **Two-weight triangle bound.**  The difference of two smoothed sums is
bounded by the sum of the pointwise weight differences times the term moduli:
`‖smoothedSum N φ s - smoothedSum N ψ s‖ ≤ ∑_{n≤N} ‖φ (n/N) - ψ (n/N)‖ · ‖zetaTerm s n‖`.

The brief wrote the left-hand side as `smoothedSum N φ s - zetaSum N ψ s`; since
`zetaSum` carries no weight, the meaningful two-weight statement is this one
(the right-hand side is the one displayed in the brief).  Taking `ψ ≡ 1`
(`norm_smoothedSum_sub_zetaSum_le`) and `φ ≡ 1`
(`norm_zetaSum_sub_smoothedSum_le`) specialises it back to `zetaSum`. -/
theorem norm_smoothedSum_sub_smoothedSum_le (N : ℕ) (φ ψ : ℝ → ℝ) (s : ℂ) :
    ‖smoothedSum N φ s - smoothedSum N ψ s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖φ ((n : ℝ) / N) - ψ ((n : ℝ) / N)‖ * ‖zetaTerm s n‖ := by
  have hdecomp : smoothedSum N φ s - smoothedSum N ψ s
      = ∑ n ∈ Finset.Icc 1 N,
          ((((φ ((n : ℝ) / N) - ψ ((n : ℝ) / N)) : ℝ) : ℂ)) * zetaTerm s n := by
    rw [smoothedSum, smoothedSum, ← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun n _ => ?_
    push_cast
    ring_nf
  rw [hdecomp]
  refine le_trans (norm_sum_le _ _) (le_of_eq ?_)
  refine Finset.sum_congr rfl fun n _ => ?_
  rw [norm_mul, Complex.norm_real]

/-- **Sharp-versus-smoothed triangle bound.**  Specialising the two-weight bound
to `ψ ≡ 1` (using `smoothedSum_one`) gives the error of the smoothed sum against
the sharp sum, with the weight defect `φ (n/N) - 1`. -/
theorem norm_smoothedSum_sub_zetaSum_le (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    ‖smoothedSum N φ s - zetaSum N s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖φ ((n : ℝ) / N) - 1‖ * ‖zetaTerm s n‖ := by
  have h := norm_smoothedSum_sub_smoothedSum_le N φ (fun _ : ℝ => 1) s
  rwa [smoothedSum_one] at h

/-- **The error bound in the form used by the round.**  With the weight defect
written as `1 - φ (n/N)`,
`‖zetaSum N s - smoothedSum N φ s‖ ≤ ∑_{n≤N} ‖1 - φ (n/N)‖ · ‖zetaTerm s n‖`. -/
theorem norm_zetaSum_sub_smoothedSum_le (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    ‖zetaSum N s - smoothedSum N φ s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖1 - φ ((n : ℝ) / N)‖ * ‖zetaTerm s n‖ := by
  have hdec := weighted_decomposition N φ s
  rw [hdec]
  refine le_trans (norm_sum_le _ _) (le_of_eq ?_)
  refine Finset.sum_congr rfl fun n _ => ?_
  rw [norm_mul, Complex.norm_real]

/-- Equivalent form of `norm_zetaSum_sub_smoothedSum_le` with the two sides of
the difference exchanged (`‖a - b‖ = ‖b - a‖`). -/
theorem norm_smoothedSum_sub_zetaSum_le' (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    ‖smoothedSum N φ s - zetaSum N s‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖1 - φ ((n : ℝ) / N)‖ * ‖zetaTerm s n‖ := by
  rw [norm_sub_rev]
  exact norm_zetaSum_sub_smoothedSum_le N φ s

/-! ## 4. The radial decay of the term -/

/-- **Radial decay.**  For `n ≥ 1` the modulus of the `n`-th term depends only
on the real part `σ` of `s = σ + t·I`, and equals exactly `n^{-σ}`:
`‖zetaTerm (σ + t·I) n‖ = (n : ℝ) ^ (-σ)`. -/
theorem abs_zetaTerm (σ t : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖zetaTerm ((σ : ℂ) + (t : ℂ) * Complex.I) n‖ = (n : ℝ) ^ (-σ) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast (by omega : 0 < n)
  rw [zetaTerm, Complex.norm_exp]
  have hmul : (((σ : ℂ) + (t : ℂ) * Complex.I) * (Real.log n : ℂ))
      = (((σ * Real.log n : ℝ)) : ℂ) + (((t * Real.log n : ℝ)) : ℂ) * Complex.I := by
    push_cast
    ring_nf
  have hre : (-(((σ : ℂ) + (t : ℂ) * Complex.I) * (Real.log n : ℂ))).re
      = -(σ * Real.log n) := by
    rw [hmul]
    simp only [Complex.neg_re, Complex.add_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.mul_re, Complex.I_re, Complex.I_im]
    ring_nf
  rw [hre, Real.exp_neg, Real.rpow_neg hnpos.le σ, Real.rpow_def_of_pos hnpos σ]
  congr 1
  ring_nf

/-- The same radial decay for a real argument `σ` (the case `t = 0`). -/
theorem abs_zetaTerm_ofReal (σ : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖zetaTerm (σ : ℂ) n‖ = (n : ℝ) ^ (-σ) := by
  have h := abs_zetaTerm σ 0 hn
  simpa using h

/-- **Explicit comparison with the `p`-series.**  For `n ≥ 1` the modulus of the
term is at most `n^{-σ}`; for `σ > 1` these are the summable `p`-series terms. -/
theorem norm_zetaTerm_le_rpow (σ : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖zetaTerm ((σ : ℂ)) n‖ ≤ (n : ℝ) ^ (-σ) :=
  le_of_eq (abs_zetaTerm_ofReal σ hn)

/-- **Absolute convergence of the tail for `σ > 1`.**  The `ℕ`-indexed series of
the term moduli, `∑' n, ‖zetaTerm (σ : ℂ) (n + 1)‖`, is summable; the proof
compares it with the real `p`-series `∑ (n + 1)^{-σ}` via `abs_zetaTerm_ofReal`
and `Real.summable_nat_rpow`. -/
theorem summable_norm_zetaTerm (σ : ℝ) (hσ : 1 < σ) :
    Summable (fun n : ℕ => ‖zetaTerm (σ : ℂ) (n + 1)‖) := by
  have hbase : Summable (fun m : ℕ => (m : ℝ) ^ (-σ)) :=
    (Real.summable_nat_rpow (p := -σ)).mpr (by linarith)
  have hshift : Summable (fun n : ℕ => ((n + 1 : ℕ) : ℝ) ^ (-σ)) :=
    (summable_nat_add_iff 1).mpr hbase
  refine hshift.congr fun n => ?_
  exact (abs_zetaTerm_ofReal σ (by omega : 1 ≤ n + 1)).symm

/-- The radial decay read off the principal-branch power `(n : ℂ) ^ (-s)`: for
`n ≥ 1` and `s = σ + t·I`, `‖(n : ℂ) ^ (-s)‖ = n^{-σ}`. -/
theorem abs_cpow_neg_eq (σ t : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖(n : ℂ) ^ (-(((σ : ℂ) + (t : ℂ) * Complex.I)))‖ = (n : ℝ) ^ (-σ) := by
  rw [← zetaTerm_eq (((σ : ℂ) + (t : ℂ) * Complex.I)) hn, abs_zetaTerm σ t hn]

/-- **The error bound with the radial decay substituted.**  Combining the
triangle bound with `abs_zetaTerm`, the sharp-versus-smoothed error at
`s = σ + t·I` is bounded by
`∑_{n≤N} ‖1 - φ (n/N)‖ · n^{-σ}` — the form in which the round reads off the
`O(√N)` (sharp, `φ ≡ 1` has defect `0`) versus `O(N^{-σ})` (smooth) laws. -/
theorem norm_zetaSum_sub_smoothedSum_le_rpow (N : ℕ) (φ : ℝ → ℝ) (σ t : ℝ) :
    ‖zetaSum N ((σ : ℂ) + (t : ℂ) * Complex.I)
        - smoothedSum N φ ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖1 - φ ((n : ℝ) / N)‖ * (n : ℝ) ^ (-σ) := by
  refine le_trans (norm_zetaSum_sub_smoothedSum_le N φ _) ?_
  refine Finset.sum_le_sum fun n hn => ?_
  have hn1 : 1 ≤ n := (Finset.mem_Icc.mp hn).1
  exact mul_le_mul_of_nonneg_left (le_of_eq (abs_zetaTerm σ t hn1)) (norm_nonneg _)

/-! ## 5. The quadratic weight `φ u = u (1 - u)` -/

/-- The quadratic weight of the round: `quadWeight u = u * (1 - u)`.  It vanishes
at the right endpoint `u = 1`, which is what removes the `O(√N)` fluctuation of
the sharp cutoff, and at the left endpoint `u = 0`. -/
def quadWeight (u : ℝ) : ℝ := u * (1 - u)

/-- The defining equation of `quadWeight`. -/
theorem quadWeight_apply (u : ℝ) : quadWeight u = u * (1 - u) := rfl

/-- `quadWeight 1 = 0`, the endpoint vanishing responsible for the smoothing. -/
theorem quadWeight_one : quadWeight 1 = 0 := by
  rw [quadWeight]; ring_nf

/-- `quadWeight 0 = 0`. -/
theorem quadWeight_zero : quadWeight 0 = 0 := by
  rw [quadWeight]; ring_nf

/-- The quadratic weight is non-negative on the unit interval. -/
theorem quadWeight_nonneg {u : ℝ} (hu0 : 0 ≤ u) (hu1 : u ≤ 1) : 0 ≤ quadWeight u := by
  rw [quadWeight]
  nlinarith

/-- The sampled quadratic weight, pinned for the numerics:
`quadWeight (n/N) = (n/N) * (1 - n/N)`. -/
theorem quadWeight_div (n N : ℕ) :
    quadWeight ((n : ℝ) / N) = ((n : ℝ) / N) * (1 - (n : ℝ) / N) :=
  rfl

/-- The smoothed sum with the quadratic weight, in the form used by the
numerics: the coefficient of `zetaTerm s n` is `(n/N)(1 - n/N)`. -/
theorem smoothedSum_quadWeight (N : ℕ) (s : ℂ) :
    smoothedSum N quadWeight s
      = ∑ n ∈ Finset.Icc 1 N,
          ((((n : ℝ) / N) * (1 - (n : ℝ) / N) : ℝ) : ℂ) * zetaTerm s n :=
  rfl

/-- **Split into `zetaSum`-type pieces.**  The quadratic weight splits as
`u (1 - u) = u - u²`, so
`smoothedSum N quadWeight s = ∑ (n/N) zetaTerm s n - ∑ (n/N)² zetaTerm s n`. -/
theorem smoothedSum_quadWeight_split (N : ℕ) (s : ℂ) :
    smoothedSum N quadWeight s
      = (∑ n ∈ Finset.Icc 1 N, ((((n : ℝ) / N) : ℝ) : ℂ) * zetaTerm s n)
        - ∑ n ∈ Finset.Icc 1 N, (((((n : ℝ) / N) ^ 2 : ℝ)) : ℂ) * zetaTerm s n := by
  rw [smoothedSum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun n _ => ?_
  rw [quadWeight]
  push_cast
  ring_nf

/-- The weight defect of the quadratic weight in closed form.  With `x = n/N`,
`1 - x (1 - x) = 1 - x + x² = (N² - n N + n²) / N²` for `N ≠ 0`.

The rearrangement suggested in the brief, `((N - n)² + n (N - n)) / N²`, is
*not* this quantity: it simplifies to `(N - n)/N = 1 - n/N`, i.e. it is the
defect of the *linear* weight `u`, not of `u (1 - u)` (the two agree only for
`n = 0`).  The correct `u²`-completing numerator is
`(N - n)² + n (N - n) + n² = N² - n N + n²`; both forms are recorded below. -/
theorem quadWeight_defect_eq {n N : ℕ} (hN : N ≠ 0) :
    1 - quadWeight ((n : ℝ) / N)
      = (((N : ℝ) ^ 2 - (n : ℝ) * N + (n : ℝ) ^ 2)) / (N : ℝ) ^ 2 := by
  rw [quadWeight]
  have hN' : (N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hN
  field_simp
  ring_nf

/-- The same closed form of the quadratic weight defect, with the numerator
`(N - n)² + n (N - n) + n²` (the corrected "`u²`-completed" rearrangement; the
last summand `n²` is exactly what the brief's displayed formula omits). -/
theorem quadWeight_defect_eq' {n N : ℕ} (hN : N ≠ 0) :
    1 - quadWeight ((n : ℝ) / N)
      = (((N : ℝ) - n) ^ 2 + (n : ℝ) * ((N : ℝ) - n) + (n : ℝ) ^ 2) / (N : ℝ) ^ 2 := by
  rw [quadWeight]
  have hN' : (N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hN
  field_simp
  ring_nf

/-- The equation that the brief displays, `((N - n)² + n (N - n)) / N²`, is the
defect of the *linear* weight: `1 - n/N = ((N - n)² + n (N - n)) / N²`.  Keeping
it makes explicit which rearrangement the brief intended. -/
theorem linearWeight_defect_eq {n N : ℕ} (hN : N ≠ 0) :
    1 - (n : ℝ) / N = (((N : ℝ) - n) ^ 2 + (n : ℝ) * ((N : ℝ) - n)) / (N : ℝ) ^ 2 := by
  have hN' : (N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hN
  field_simp
  ring_nf

/-- The weighted decomposition for the quadratic weight. -/
theorem zetaSum_sub_smoothedSum_quadWeight (N : ℕ) (s : ℂ) :
    zetaSum N s - smoothedSum N quadWeight s
      = ∑ n ∈ Finset.Icc 1 N, (((1 - quadWeight ((n : ℝ) / N) : ℝ)) : ℂ) * zetaTerm s n :=
  weighted_decomposition N quadWeight s

/-- The weighted decomposition for the quadratic weight with the defect replaced
by its explicit closed form `(N² - nN + n²)/N²`. -/
theorem weighted_decomposition_quadWeight_defect {N : ℕ} (hN : N ≠ 0) (s : ℂ) :
    zetaSum N s - smoothedSum N quadWeight s
      = ∑ n ∈ Finset.Icc 1 N,
          (((((N : ℝ) ^ 2 - (n : ℝ) * N + (n : ℝ) ^ 2) / (N : ℝ) ^ 2 : ℝ)) : ℂ)
            * zetaTerm s n := by
  rw [zetaSum_sub_smoothedSum_quadWeight]
  refine Finset.sum_congr rfl fun n _ => ?_
  rw [quadWeight_defect_eq hN]

end

end Rh044
