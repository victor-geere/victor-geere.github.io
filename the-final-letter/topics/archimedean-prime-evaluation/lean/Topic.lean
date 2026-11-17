import Shift
import Mathlib

/-!
# Archimedean and prime evaluation for the Gaussian explicit formula

This topic isolates the two analytic inputs standing between the assembled
Gaussian explicit formula and an unconditional statement:

* the **archimedean evaluation** — the vertical integral of the archimedean
  factor against the Gaussian test, identified with `densityTerm`;
* the **prime evaluation** — the vertical integral of the von Mangoldt
  Dirichlet series against the Gaussian test, identified with `primeTermSym`.

What is proved here is the elementary core: the exact value of the Gaussian
test on the critical line, its real and imaginary parts, the archimedean kernel
`Ω`, and the reduction from the two evaluation equalities to the vertical-limit
identification.  The evaluations themselves are named propositions; the
contour-shift and Dirichlet-series computations they require are not in this
repository or in Mathlib.
-/

noncomputable section

open Complex Matrix MeasureTheory Filter Topology
open scoped BigOperators

namespace ArchimedeanPrimeEvaluation

/-- The Gaussian test function of the explicit-formula programme. -/
def gaussianZeroTest (c σ : ℝ) (s : ℂ) : ℂ :=
  ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
    Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (s - 1 / 2) ^ 2) *
      Complex.exp (-((c : ℝ) : ℂ) * (s - 1 / 2))

/-- The archimedean kernel `Ω(t) = Re ψ(1/4+it/2) − log π`. -/
def omega (t : ℝ) : ℝ :=
  (Complex.digamma ((1 / 4 : ℝ) + (t : ℂ) * I / 2)).re - Real.log Real.pi

/-- The archimedean density term `σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt`. -/
def densityTerm (c σ : ℝ) : ℝ :=
  σ ^ 2 * ∫ t : ℝ, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * omega t

/-- The prime term `−2 Σ_n Λ(n)/√n · √π σ exp(−(log n − c)²/(4σ²))`. -/
def primeTerm (c σ : ℝ) : ℝ :=
  -2 * ∑' n : ℕ, ArithmeticFunction.vonMangoldt n / Real.sqrt n *
    (Real.sqrt Real.pi * σ * Real.exp (-((Real.log n - c) ^ 2) / (4 * σ ^ 2)))

/-- The symmetrised prime term. -/
def primeTermSym (c σ : ℝ) : ℝ := (primeTerm c σ + primeTerm (-c) σ) / 2

/-- The archimedean evaluation equality. -/
def ArchimedeanEvaluation (c σ : ℝ) (A A' : ℂ) : Prop :=
  A.re + A'.re = -2 * Real.pi * densityTerm c σ

/-- The prime evaluation equality. -/
def PrimeEvaluation (c σ : ℝ) (P P' : ℂ) : Prop :=
  P.re + P'.re = -2 * Real.pi * primeTermSym c σ

/-- The vertical-limit identification. -/
def VerticalLimitIdentification (c σ : ℝ) (A P A' P' : ℂ) : Prop :=
  (A + P + A' + P').re = -2 * Real.pi * (densityTerm c σ + primeTermSym c σ)

/-- The two evaluation equalities imply the identification. -/
theorem verticalLimitIdentification_of_evaluations {c σ : ℝ} {A P A' P' : ℂ}
    (hA : ArchimedeanEvaluation c σ A A') (hP : PrimeEvaluation c σ P P') :
    VerticalLimitIdentification c σ A P A' P' := by
  unfold ArchimedeanEvaluation PrimeEvaluation VerticalLimitIdentification at *
  have h : (A + P + A' + P').re = A.re + P.re + A'.re + P'.re := by
    simp only [Complex.add_re]
  rw [h]
  linarith

/-- **The Gaussian test on the critical line.** -/
theorem gaussianZeroTest_half_add (c σ t : ℝ) :
    gaussianZeroTest c σ (1 / 2 + (t : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp ((-(σ ^ 2 * t ^ 2) : ℝ) : ℂ) *
          Complex.exp ((-(c * t) : ℝ) * I) := by
  unfold gaussianZeroTest
  have h1 : ((1 / 2 : ℂ) + (t : ℂ) * I - 1 / 2) = (t : ℂ) * I := by ring
  rw [h1]
  have h2 : (((σ ^ 2 : ℝ) : ℂ) * ((t : ℂ) * I) ^ 2) = ((-(σ ^ 2 * t ^ 2) : ℝ) : ℂ) := by
    push_cast
    have hI : ((t : ℂ) * I) ^ 2 = -((t : ℂ) ^ 2) := by
      rw [mul_pow]
      simp [Complex.I_mul_I]
    rw [hI]
    ring
  have h3 : (-((c : ℂ)) * ((t : ℂ) * I)) = ((-(c * t) : ℝ) : ℂ) * I := by
    push_cast
    ring
  rw [h2, h3]

/-- The critical-line exponential `e^{−ict}` in trigonometric form. -/
theorem exp_neg_mul_I (c t : ℝ) :
    Complex.exp ((-(c * t) : ℝ) * I) =
      (Real.cos (c * t) : ℂ) - (Real.sin (c * t) : ℂ) * I := by
  rw [Complex.exp_mul_I]
  simp only [Complex.ofReal_neg, Complex.cos_neg, Complex.sin_neg,
    Complex.ofReal_sin, Complex.ofReal_cos]
  ring

/-- The Gaussian exponential is a real exponential. -/
theorem exp_gaussian (σ t : ℝ) :
    Complex.exp ((-(σ ^ 2 * t ^ 2) : ℝ) : ℂ) =
      ((Real.exp (-(σ ^ 2 * t ^ 2)) : ℝ) : ℂ) := by
  rw [← Complex.ofReal_exp]

/-- Real part of the critical-line test. -/
theorem gaussianZeroTest_half_add_re (c σ t : ℝ) (hσ : 0 ≤ σ) :
    (gaussianZeroTest c σ (1 / 2 + (t : ℂ) * I)).re =
      2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * t ^ 2)) * Real.cos (c * t) := by
  rw [gaussianZeroTest_half_add, exp_neg_mul_I, exp_gaussian]
  simp only [Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.sub_re, Complex.sub_im, Complex.ofReal_neg, Complex.ofReal_ofNat,
    Complex.I_re, Complex.I_im, mul_zero, sub_zero, zero_mul, add_zero, mul_one,
    sub_neg_eq_add]

/-- Imaginary part of the critical-line test. -/
theorem gaussianZeroTest_half_add_im (c σ t : ℝ) (hσ : 0 ≤ σ) :
    (gaussianZeroTest c σ (1 / 2 + (t : ℂ) * I)).im =
      -(2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * t ^ 2)) * Real.sin (c * t)) := by
  rw [gaussianZeroTest_half_add, exp_neg_mul_I, exp_gaussian]
  simp only [Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.sub_re, Complex.sub_im, Complex.ofReal_neg, Complex.ofReal_ofNat,
    Complex.I_re, Complex.I_im, mul_zero, sub_zero, zero_mul, add_zero, mul_one,
    sub_neg_eq_add]
  ring

/-- **Pointwise archimedean integrand identity on the critical line.**  The real
part of `(log π − ψ(1/4+it/2))·H_c(1/2+it)` splits into the `Ω·cos` piece
(which integrates to `densityTerm`) and the `Im ψ·sin` correction. -/
theorem arch_integrand_identity (c σ t : ℝ) :
    ((Real.log Real.pi - Complex.digamma ((1 / 4 : ℝ) + (t : ℂ) * I / 2)) *
        gaussianZeroTest c σ (1 / 2 + (t : ℂ) * I)).re =
      -2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * t ^ 2)) *
        (omega t * Real.cos (c * t) +
          (Complex.digamma ((1 / 4 : ℝ) + (t : ℂ) * I / 2)).im * Real.sin (c * t)) := by
  rw [gaussianZeroTest_half_add, exp_neg_mul_I, exp_gaussian]
  simp only [Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.sub_re, Complex.sub_im, Complex.ofReal_neg, Complex.ofReal_ofNat,
    Complex.I_re, Complex.I_im, mul_zero, sub_zero, zero_mul, add_zero, mul_one,
    sub_neg_eq_add]
  unfold omega
  ring

/-! ## O2 — the prime-side Dirichlet-series evaluation (precise statements)

The following definitions make the open content of O2 explicit.  None of them is
proved; they are the exact statements the prime evaluation requires.
-/

/-- The right-side prime vertical integral at `Re s = 2`. -/
def primeRightIntegral (c σ T : ℝ) : ℂ :=
  ∫ y : ℝ in (-T)..T,
    LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 + (y : ℂ) * I) *
      gaussianZeroTest c σ (2 + (y : ℂ) * I)

/-- The right-side prime vertical limit (the `PrimeR` of the assembled formula). -/
def PrimeRightLimit (c σ : ℝ) (P : ℂ) : Prop :=
  Filter.Tendsto (fun T : ℝ => primeRightIntegral c σ T) Filter.atTop (nhds P)

/-- The `n`-th Gaussian–Fourier term: `∫ e^{−i y log n} H_c(2+iy) dy`. -/
def termwiseIntegral (c σ : ℝ) (n : ℕ) : ℂ :=
  ∫ y : ℝ, Complex.exp (-(Real.log n) * (y : ℂ) * I) *
    gaussianZeroTest c σ (2 + (y : ℂ) * I)

/-- **The Gaussian Fourier transform.**  The explicit closed form of the
`n`-th term: the Gaussian integral with a linear phase. -/
def GaussianFourierTransform (c σ : ℝ) : Prop :=
  ∀ n : ℕ, termwiseIntegral c σ n =
    2 * (Real.pi : ℂ) * (σ : ℂ) ^ 2 *
      Complex.exp ((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ) : ℂ) *
        (((Real.pi / σ ^ 2 : ℝ) : ℂ) ^ (1 / 2 : ℂ)) *
          Complex.exp ((-(((3 * σ ^ 2 - c - Real.log n) ^ 2) / (4 * σ ^ 2)) : ℝ) : ℂ)

/-- **The termwise interchange.**  The partial sums of the Dirichlet series
against the test converge to the vertical integral. -/
def PrimeTermwiseInterchange (c σ : ℝ) (P : ℂ) : Prop :=
  Filter.Tendsto (fun N : ℕ =>
    ∑ n ∈ Finset.range N,
      (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 * termwiseIntegral c σ n)
    Filter.atTop (nhds P)

/-- The full O2 data: the vertical limit, the termwise interchange and the
Gaussian Fourier transform. -/
def PrimeSeriesEvaluation (c σ : ℝ) (P : ℂ) : Prop :=
  PrimeRightLimit c σ P ∧ PrimeTermwiseInterchange c σ P ∧ GaussianFourierTransform c σ



/-- **The Gaussian test at `Re s = 2`, in Gaussian form.** -/
theorem gaussianZeroTest_two_add (c σ y : ℝ) :
    gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) *
          Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) + (((3 * σ ^ 2 - c) * y : ℝ) : ℂ) * Complex.I) := by
  unfold gaussianZeroTest
  have h1 : ((2 : ℂ) + (y : ℂ) * Complex.I - 1 / 2) = (3 / 2 : ℂ) + (y : ℂ) * Complex.I := by ring
  rw [h1]
  have harg : ((σ ^ 2 : ℝ) : ℂ) * ((3 / 2 : ℂ) + (y : ℂ) * Complex.I) ^ 2 +
      (-((c : ℝ) : ℂ) * ((3 / 2 : ℂ) + (y : ℂ) * Complex.I)) =
      (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) +
        ((-(σ ^ 2 * y ^ 2) : ℝ) + (((3 * σ ^ 2 - c) * y : ℝ) : ℂ) * Complex.I) := by
    push_cast
    ring_nf
    simp only [pow_two, Complex.I_mul_I]
    ring
  rw [mul_assoc]
  conv_lhs => rw [← Complex.exp_add]
  rw [harg, Complex.exp_add]
  ring


/-- **The Gaussian Fourier transform, proved.**  The `n`-th term is the
Gaussian integral with a linear phase. -/
theorem termwiseIntegral_eq (c σ : ℝ) (hσ : 0 < σ) (n : ℕ) :
    termwiseIntegral c σ n =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) *
          (((Real.pi / σ ^ 2 : ℝ) : ℂ) ^ (1 / 2 : ℂ)) *
            Complex.exp ((-(((3 * σ ^ 2 - c - Real.log n) ^ 2) / (4 * σ ^ 2)) : ℝ) : ℂ) := by
  unfold termwiseIntegral
  have hcomb : ∀ y : ℝ,
      Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
          Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) + (((3 * σ ^ 2 - c) * y : ℝ) : ℂ) * Complex.I)
        = Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) +
            (((3 * σ ^ 2 - c - Real.log n) * y : ℝ) : ℂ) * Complex.I) := by
    intro y
    rw [← Complex.exp_add]
    congr 1
    push_cast
    ring
  have hpt : ∀ y : ℝ,
      Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
          gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)
        = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) *
              Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) +
                (((3 * σ ^ 2 - c - Real.log n) * y : ℝ) : ℂ) * Complex.I) := by
    intro y
    rw [gaussianZeroTest_two_add]
    calc Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) *
              Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) + (((3 * σ ^ 2 - c) * y : ℝ) : ℂ) * Complex.I))
        = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) *
              (Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
                Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) + (((3 * σ ^ 2 - c) * y : ℝ) : ℂ) * Complex.I)) := by
          ring
      _ = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((9 * σ ^ 2 / 4 - 3 * c / 2 : ℝ)) : ℂ) *
              Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) +
                (((3 * σ ^ 2 - c - Real.log n) * y : ℝ) : ℂ) * Complex.I) := by
          rw [hcomb]
  simp_rw [hpt]
  rw [integral_const_mul]
  have hfun : (fun y : ℝ => Complex.exp ((-(σ ^ 2 * y ^ 2) : ℝ) +
        (((3 * σ ^ 2 - c - Real.log n) * y : ℝ) : ℂ) * Complex.I))
      = (fun y : ℝ => Complex.exp (((-(σ ^ 2 : ℝ) : ℂ) * (y : ℂ) ^ 2) +
          (((((3 * σ ^ 2 - c - Real.log n : ℝ)) : ℂ) * Complex.I) * (y : ℂ)) + 0)) := by
    funext y
    congr 1
    push_cast
    ring
  have hb : ((-(σ ^ 2 : ℝ) : ℂ)).re < 0 := by
    simp only [Complex.ofReal_neg, Complex.neg_re, Complex.ofReal_re]
    nlinarith [sq_pos_of_pos hσ]
  rw [hfun, integral_cexp_quadratic hb]
  have h1 : ((Real.pi : ℂ) / -((-(σ ^ 2 : ℝ) : ℂ))) = ((Real.pi / σ ^ 2 : ℝ) : ℂ) := by
    push_cast
    congr 1
    ring
  rw [h1]
  have h2 : (0 : ℂ) - (((((3 * σ ^ 2 - c - Real.log n : ℝ)) : ℂ) * Complex.I) ^ 2) /
        (4 * ((-(σ ^ 2 : ℝ) : ℂ))) =
      ((-(((3 * σ ^ 2 - c - Real.log n) ^ 2) / (4 * σ ^ 2)) : ℝ) : ℂ) := by
    push_cast
    have hI : (Complex.I : ℂ) ^ 2 = -1 := by simp [Complex.I_mul_I]
    rw [mul_pow, hI]
    ring
  rw [h2]
  ring

theorem gaussianFourierTransform (c σ : ℝ) (hσ : 0 < σ) :
    GaussianFourierTransform c σ := by
  intro n
  rw [termwiseIntegral_eq c σ hσ n]
  push_cast
  ring




/-- **Finite termwise exchange.**  For a finite partial sum of the prime series,
the vertical integral splits into the sum of the individual integrals. -/
theorem primePartialIntegral_eq (c σ : ℝ) (N : ℕ) (T : ℝ) :
    ∫ y : ℝ in (-T)..T,
        (∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I)) *
          gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)
      = ∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          ∫ y : ℝ in (-T)..T, Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
            gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I) := by
  have hpt : ∀ y : ℝ,
      (∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I)) *
        gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)
      = ∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          (Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
            gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)) := by
    intro y
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro n hn
    ring
  simp_rw [hpt]
  rw [intervalIntegral.integral_finset_sum]
  · apply Finset.sum_congr rfl
    intro n hn
    rw [intervalIntegral.integral_const_mul]
  · intro n hn
    apply Continuous.intervalIntegrable
    unfold gaussianZeroTest
    fun_prop

/-- **Term integrability.**  The `n`-th termwise integrand on `Re s = 2` is
integrable, with the Gaussian decay of the test. -/
theorem integrable_term (c σ : ℝ) (hσ : 0 < σ) (n : ℕ) :
    Integrable (fun y : ℝ => Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
      gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)) := by
  have hc : Continuous (fun y : ℝ => Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
      gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)) := by
    unfold gaussianZeroTest
    fun_prop
  have hnorm : ∀ y : ℝ,
      ‖Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
        gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)‖
      = 2 * Real.pi * σ ^ 2 * Real.exp (9 * σ ^ 2 / 4 - 3 * c / 2) *
        Real.exp (-(σ ^ 2 * y ^ 2)) := by
    intro y
    rw [gaussianZeroTest_two_add]
    simp only [Complex.norm_mul, Complex.norm_exp, Complex.ofReal_re, Complex.ofReal_im,
      Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im, Complex.I_re, Complex.I_im,
      Complex.ofReal_neg, Complex.neg_im, Complex.neg_re, mul_zero, mul_one, add_zero, zero_add,
      sub_zero]
    rw [Complex.norm_real, Real.norm_of_nonneg (by positivity)]
    norm_num
  have hgauss : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have := integrable_exp_neg_mul_sq (b := σ ^ 2) (by positivity)
    simpa [neg_mul, mul_comm, mul_left_comm, mul_assoc] using this
  refine Integrable.mono'
    (hgauss.const_mul (2 * Real.pi * σ ^ 2 * Real.exp (9 * σ ^ 2 / 4 - 3 * c / 2)))
    hc.aestronglyMeasurable ?_
  filter_upwards with y
  rw [hnorm y]

/-- **Term limit.**  The truncated vertical integral of the `n`-th term tends to
the full `termwiseIntegral`. -/
theorem tendsto_term_integral (c σ : ℝ) (hσ : 0 < σ) (n : ℕ) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
        Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
          gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I))
      atTop (nhds (termwiseIntegral c σ n)) := by
  unfold termwiseIntegral
  exact intervalIntegral_tendsto_integral (integrable_term c σ hσ n)
    tendsto_neg_atTop_atBot tendsto_id

/-- **Partial-sum limit.**  For fixed `N`, the truncated vertical integral of the
prime partial sum tends to the finite sum of the term integrals. -/
theorem tendsto_primePartial_integral (c σ : ℝ) (hσ : 0 < σ) (N : ℕ) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
        (∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I)) *
          gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I))
      atTop (nhds (∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        termwiseIntegral c σ n)) := by
  have hT : ∀ T : ℝ, ∫ y : ℝ in (-T)..T,
        (∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I)) *
          gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)
      = ∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          ∫ y : ℝ in (-T)..T, Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
            gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I) :=
    fun T => primePartialIntegral_eq c σ N T
  simp_rw [hT]
  apply tendsto_finset_sum
  intro n hn
  exact (tendsto_term_integral c σ hσ n).const_mul _

/-- Norm of the `n`-th termwise integrand on `Re s = 2`. -/
theorem norm_termwise_integrand (c σ y : ℝ) (n : ℕ) :
    ‖Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
      gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)‖
    = 2 * Real.pi * σ ^ 2 * Real.exp (9 * σ ^ 2 / 4 - 3 * c / 2) *
      Real.exp (-(σ ^ 2 * y ^ 2)) := by
  rw [gaussianZeroTest_two_add]
  simp only [Complex.norm_mul, Complex.norm_exp, Complex.ofReal_re, Complex.ofReal_im,
    Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im, Complex.I_re, Complex.I_im,
    Complex.ofReal_neg, Complex.neg_im, Complex.neg_re, mul_zero, mul_one, add_zero, zero_add,
    sub_zero]
  rw [Complex.norm_real, Real.norm_of_nonneg (by positivity)]
  norm_num

/-- The termwise integral is bounded uniformly in `n`. -/
theorem termwiseIntegral_norm_le (c σ : ℝ) (hσ : 0 < σ) (n : ℕ) :
    ‖termwiseIntegral c σ n‖ ≤
      (2 * Real.pi * σ ^ 2 * Real.exp (9 * σ ^ 2 / 4 - 3 * c / 2)) *
        Real.sqrt (Real.pi / σ ^ 2) := by
  unfold termwiseIntegral
  have h1 : ‖∫ y : ℝ, Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
      gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)‖
      ≤ ∫ y : ℝ, ‖Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) *
        gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)‖ :=
    norm_integral_le_integral_norm _
  refine h1.trans (le_of_eq ?_)
  simp_rw [norm_termwise_integrand c σ _ n]
  rw [integral_const_mul]
  have hg : ∫ y : ℝ, Real.exp (-(σ ^ 2 * y ^ 2)) = Real.sqrt (Real.pi / σ ^ 2) := by
    have := integral_gaussian (σ ^ 2)
    simpa [neg_mul, mul_comm, mul_left_comm, mul_assoc] using this
  rw [hg]

end ArchimedeanPrimeEvaluation

namespace ArchimedeanPrimeEvaluation

/-- The von Mangoldt series at `Re s = 2` is summable. -/
theorem summable_vonMangoldt_div_sq :
    Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2) := by
  have hL : LSeriesSummable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 : ℂ) :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt (by norm_num : (1 : ℝ) < ((2 : ℂ)).re)
  have h := hL
  rw [LSeriesSummable] at h
  convert h using 1
  funext n
  by_cases hn : n = 0
  · subst hn
    simp [LSeries.term]
  · rw [LSeries.term_def]
    simp only [hn, if_false]
    norm_num

/-- **Tail of a summable series tends to zero.** -/
theorem tendsto_tail_summable (f : ℕ → ℂ) (hf : Summable f) :
    Tendsto (fun N : ℕ => ∑' k : ℕ, f (k + N)) atTop (nhds 0) := by
  have h : ∀ N : ℕ, ∑' k : ℕ, f (k + N) = (∑' n, f n) - ∑ n ∈ Finset.range N, f n := by
    intro N
    rw [eq_sub_iff_add_eq, add_comm]
    exact hf.sum_add_tsum_nat_add N
  simp_rw [h]
  have hlim : Tendsto (fun N : ℕ => (∑' n, f n) - ∑ n ∈ Finset.range N, f n) atTop
      (nhds ((∑' n, f n) - ∑' n, f n)) :=
    tendsto_const_nhds.sub hf.hasSum.tendsto_sum_nat
  simpa [sub_self] using hlim

/-- **The von Mangoldt tail tends to zero** at `Re s = 2`. -/
theorem tendsto_tail_vonMangoldt_div_sq :
    Tendsto (fun N : ℕ => ∑' k : ℕ,
      (ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2) atTop (nhds 0) :=
  tendsto_tail_summable _ summable_vonMangoldt_div_sq

/-- **Summability of the prime series** at `Re s = 2`. -/
theorem summable_primeSeries (c σ : ℝ) (hσ : 0 < σ) :
    Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
      termwiseIntegral c σ n) := by
  have hL : LSeriesSummable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 : ℂ) :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt (by norm_num : (1 : ℝ) < ((2 : ℂ)).re)
  have hS2 : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2) :=
    summable_vonMangoldt_div_sq
  have hC : ∀ n : ℕ, ‖termwiseIntegral c σ n‖ ≤
      (2 * Real.pi * σ ^ 2 * Real.exp (9 * σ ^ 2 / 4 - 3 * c / 2)) *
        Real.sqrt (Real.pi / σ ^ 2) :=
    termwiseIntegral_norm_le c σ hσ
  have hmaj : Summable (fun n : ℕ =>
      ‖(ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2‖ *
        ((2 * Real.pi * σ ^ 2 * Real.exp (9 * σ ^ 2 / 4 - 3 * c / 2)) *
          Real.sqrt (Real.pi / σ ^ 2))) :=
    hS2.norm.mul_right _
  refine Summable.of_norm_bounded hmaj ?_
  intro n
  rw [norm_mul]
  exact mul_le_mul_of_nonneg_left (hC n) (norm_nonneg _)

/-- **The termwise interchange, proved.**  The partial sums of the prime series
converge to the sum of the termwise integrals. -/
theorem primeTermwiseInterchange (c σ : ℝ) (hσ : 0 < σ) :
    PrimeTermwiseInterchange c σ
      (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        termwiseIntegral c σ n) := by
  unfold PrimeTermwiseInterchange
  exact (summable_primeSeries c σ hσ).hasSum.tendsto_sum_nat



/-- The partial vertical integral of the prime series (explicit finite sum). -/
def primePartialIntegral (c σ : ℝ) (N : ℕ) (T : ℝ) : ℂ :=
  ∫ y : ℝ in (-T)..T,
    (∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
      Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I)) *
      gaussianZeroTest c σ (2 + (y : ℂ) * Complex.I)

/-- The partial series value. -/
def primePartialSum (c σ : ℝ) (N : ℕ) : ℂ :=
  ∑ n ∈ Finset.range N, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
    termwiseIntegral c σ n

/-- **Uniform tail bound**: for every `ε`, some partial sum is uniformly close to
the full prime vertical integral, and stays so for all larger partial sums. -/
def UniformTailBound (c σ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N : ℕ, ∀ N' : ℕ, N ≤ N' → ∀ T : ℝ,
    ‖primeRightIntegral c σ T - primePartialIntegral c σ N' T‖ < ε

/-- **The limit pass.**  The uniform tail bound together with the partial-sum
limits gives the full vertical limit, equal to the sum of the termwise
integrals. -/
theorem primeRightLimit_of_uniformTail (c σ : ℝ) (hσ : 0 < σ)
    (h : UniformTailBound c σ) :
    PrimeRightLimit c σ
      (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        termwiseIntegral c σ n) := by
  unfold PrimeRightLimit
  rw [Metric.tendsto_atTop]
  intro ε hε
  have hε3 : 0 < ε / 3 := by positivity
  obtain ⟨N₁, hN⟩ := h (ε / 3) hε3
  have hsum : Tendsto (fun N : ℕ => primePartialSum c σ N) atTop
      (nhds (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        termwiseIntegral c σ n)) :=
    (summable_primeSeries c σ hσ).hasSum.tendsto_sum_nat
  rw [Metric.tendsto_atTop] at hsum
  obtain ⟨N₀, hN₀⟩ := hsum (ε / 3) hε3
  let N := max N₁ N₀
  have hN₁ : N₁ ≤ N := le_max_left _ _
  have hN₀le : N₀ ≤ N := le_max_right _ _
  have hp : Tendsto (fun T : ℝ => primePartialIntegral c σ N T) atTop
      (nhds (primePartialSum c σ N)) :=
    tendsto_primePartial_integral c σ hσ N
  rw [Metric.tendsto_atTop] at hp
  obtain ⟨T₀, hT₀⟩ := hp (ε / 3) hε3
  refine ⟨max T₀ 0, ?_⟩
  intro T hT
  have hT' : T₀ ≤ T := le_trans (le_max_left _ _) hT
  have h1 : ‖primeRightIntegral c σ T - primePartialIntegral c σ N T‖ < ε / 3 := hN N hN₁ T
  have h2 : ‖primePartialIntegral c σ N T - primePartialSum c σ N‖ < ε / 3 := by
    rw [← dist_eq_norm]
    exact hT₀ T hT'
  have h3 : ‖primePartialSum c σ N - (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
      termwiseIntegral c σ n)‖ < ε / 3 := by
    rw [← dist_eq_norm]
    exact hN₀ N hN₀le
  have hgoal : ‖primeRightIntegral c σ T -
      (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        termwiseIntegral c σ n)‖ < ε := by
    have hsplit : primeRightIntegral c σ T -
        (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
          termwiseIntegral c σ n)
        = (primeRightIntegral c σ T - primePartialIntegral c σ N T) +
            (primePartialIntegral c σ N T - primePartialSum c σ N) +
              (primePartialSum c σ N -
                (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
                  termwiseIntegral c σ n)) := by ring
    rw [hsplit]
    have htri1 : ‖(primeRightIntegral c σ T - primePartialIntegral c σ N T) +
        (primePartialIntegral c σ N T - primePartialSum c σ N)‖ < ε / 3 + ε / 3 := by
      exact lt_of_le_of_lt (norm_add_le _ _) (add_lt_add h1 h2)
    have htri2 : ‖((primeRightIntegral c σ T - primePartialIntegral c σ N T) +
        (primePartialIntegral c σ N T - primePartialSum c σ N)) +
        (primePartialSum c σ N -
          (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
            termwiseIntegral c σ n))‖ < (ε / 3 + ε / 3) + ε / 3 :=
      lt_of_le_of_lt (norm_add_le _ _) (add_lt_add htri1 h3)
    have heq : ε / 3 + ε / 3 + ε / 3 = ε := by ring
    rw [heq] at htri2
    exact htri2
  rw [dist_eq_norm]
  exact hgoal





/-- The series value in `PrimeTermwiseInterchange` is unique. -/
theorem primeTermwiseInterchange_unique (c σ : ℝ) (hσ : 0 < σ) {P : ℂ}
    (h : PrimeTermwiseInterchange c σ P) :
    P = ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
      termwiseIntegral c σ n :=
  tendsto_nhds_unique h (primeTermwiseInterchange c σ hσ)



/-- **The von Mangoldt L-series at `Re s = 2`, explicitly.** -/
theorem LSeries_vonMangoldt_eq (y : ℝ) :
    LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 + (y : ℂ) * Complex.I)
      = ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I) := by
  rw [LSeries_def₀ (by simp)]
  congr 1
  funext n
  by_cases hn : n = 0
  · subst hn
    simp
  · have hpos : (0 : ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
    have hn' : (n : ℂ) ≠ 0 := by exact_mod_cast hpos.ne'
    rw [Complex.cpow_def_of_ne_zero hn' (2 + (y : ℂ) * Complex.I)]
    have hlog : Complex.log (n : ℂ) = ((Real.log n : ℝ) : ℂ) := by
      rw [show (n : ℂ) = ((n : ℝ) : ℂ) by push_cast; ring]
      rw [← Complex.ofReal_log hpos.le]
    rw [hlog]
    have harg : ((Real.log n : ℝ) : ℂ) * (2 + (y : ℂ) * Complex.I) =
        2 * ((Real.log n : ℝ) : ℂ) + ((Real.log n : ℝ) : ℂ) * (y : ℂ) * Complex.I := by ring
    rw [harg, Complex.exp_add]
    have hexp2 : Complex.exp (2 * ((Real.log n : ℝ) : ℂ)) = ((n : ℂ) ^ 2) := by
      rw [show (2 : ℂ) * ((Real.log n : ℝ) : ℂ) = ((2 * Real.log n : ℝ) : ℂ) by
        push_cast; ring]
      rw [← Complex.ofReal_exp]
      rw [show Real.exp (2 * Real.log n) = ((n : ℝ) ^ 2) by
        rw [show (2 : ℝ) * Real.log n = Real.log ((n : ℝ) ^ 2) by
          rw [Real.log_pow]; norm_num]
        rw [Real.exp_log (by positivity)]]
      push_cast
      ring
    rw [hexp2]
    rw [show (-(Real.log n) * (y : ℂ) * Complex.I) =
      -(((Real.log n : ℝ) : ℂ) * (y : ℂ) * Complex.I) by ring]
    rw [Complex.exp_neg]
    field_simp



/-- `y ↦ LSeries(Λ, 2+iy)` is continuous. -/
theorem continuous_LSeries_line :
    Continuous (fun y : ℝ => LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I)) := by
  apply continuous_iff_continuousAt.mpr
  intro y
  have hlin : ContinuousAt (fun y : ℝ => ((2 : ℂ) + (y : ℂ) * Complex.I)) y := by fun_prop
  have hsum : LSeriesSummable (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((3 / 2 : ℝ) : ℂ) :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt (by norm_num)
  have hle : LSeries.abscissaOfAbsConv (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ≤ ((3 / 2 : ℝ) : EReal) :=
    hsum.abscissaOfAbsConv_le
  have hlt : LSeries.abscissaOfAbsConv (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) < ((2 : ℝ) : EReal) :=
    lt_of_le_of_lt hle (by norm_num)
  have hmem : ((2 : ℂ) + (y : ℂ) * Complex.I) ∈
      {s : ℂ | LSeries.abscissaOfAbsConv (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) < (s.re : EReal)} := by
    simp only [Set.mem_setOf_eq]
    simpa using hlt
  have hcont : ContinuousAt (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))) ((2 : ℂ) + (y : ℂ) * Complex.I) :=
    (LSeries_analyticOnNhd _ _ hmem).continuousAt
  exact hcont.comp (x := y) hlin



/-- **The archimedean evaluation is proved.** -/
theorem archimedeanEvaluation_proved (c σ : ℝ) (hσ : 0 < σ) :
    ArchimedeanEvaluation c σ
      (∫ y : ℝ, DigammaContourShift.archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        DigammaContourShift.gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I))
      (∫ y : ℝ, DigammaContourShift.archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        DigammaContourShift.gaussianTest (-c) σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) := by
  unfold ArchimedeanEvaluation
  have h := DigammaContourShift.archimedeanValue_sum c σ hσ
  rw [h]
  congr 1



/-- The local Gaussian test is the `Shift` Gaussian test. -/
theorem gaussianZeroTest_eq_gaussianTest (c σ : ℝ) :
    gaussianZeroTest c σ = DigammaContourShift.gaussianTest c σ := by
  funext s
  simp [gaussianZeroTest, DigammaContourShift.gaussianTest]

/-- Horizontal decay of the local Gaussian test on `Re s = 2`. -/
theorem gaussianZeroTest_two_norm_le (c σ y : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)‖ ≤
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
        Real.exp (-(σ ^ 2 * y ^ 2)) := by
  rw [gaussianZeroTest_eq_gaussianTest]
  exact DigammaContourShift.gaussianTest_norm_le (c := c) (σ := σ) (x := 2) (T := y) hσ
    (by norm_num) (by norm_num)

end ArchimedeanPrimeEvaluation

namespace ArchimedeanPrimeEvaluation

/-- The `n`-th term of the explicit prime series at `Re s = 2`. -/
def primeTermFun (y : ℝ) (n : ℕ) : ℂ :=
  (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
    Complex.exp (-(Real.log n) * (y : ℂ) * Complex.I)

/-- The explicit prime series is summable. -/
theorem summable_primeTermFun (y : ℝ) : Summable (primeTermFun y) := by
  refine Summable.of_norm_bounded (g := fun n : ℕ => ‖(ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2‖)
    summable_vonMangoldt_div_sq.norm ?_
  intro n
  rw [primeTermFun, norm_mul, Complex.norm_exp]
  have hre : (-(Real.log n) * (y : ℂ) * Complex.I).re = 0 := by
    simp only [Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, mul_zero, mul_one,
      sub_zero, zero_mul]
    ring
  rw [hre, Real.exp_zero, mul_one]

/-- The pointwise tail identity. -/
theorem LSeries_sub_partial (y : ℝ) (N : ℕ) :
    LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I) -
        ∑ n ∈ Finset.range N, primeTermFun y n =
      ∑' k : ℕ, primeTermFun y (k + N) := by
  rw [LSeries_vonMangoldt_eq y]
  rw [sub_eq_iff_eq_add]
  change (∑' n : ℕ, primeTermFun y n) = ∑' k : ℕ, primeTermFun y (k + N) + ∑ n ∈ Finset.range N, primeTermFun y n
  rw [add_comm]
  exact ((summable_primeTermFun y).sum_add_tsum_nat_add N).symm

/-- The Gaussian test is continuous. -/
theorem continuous_gaussianZeroTest (c σ : ℝ) : Continuous (gaussianZeroTest c σ) := by
  unfold gaussianZeroTest
  fun_prop

/-- **The prime integral minus its partial sum as a tail integral.** -/
theorem primeRightIntegral_sub_eq (c σ : ℝ) (T : ℝ) (N : ℕ) :
    primeRightIntegral c σ T - primePartialIntegral c σ N T =
      ∫ y : ℝ in (-T)..T,
        (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I) -
          ∑ n ∈ Finset.range N, primeTermFun y n) *
          gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I) := by
  rw [primeRightIntegral, primePartialIntegral, ← intervalIntegral.integral_sub]
  · congr 1
    funext y
    simp only [primeTermFun, div_eq_mul_inv, inv_pow]
    ring
  · exact (continuous_LSeries_line.mul ((continuous_gaussianZeroTest c σ).comp
      (by fun_prop : Continuous fun y : ℝ => ((2 : ℂ) + (y : ℂ) * Complex.I)))).intervalIntegrable _ _
  · apply Continuous.intervalIntegrable
    apply Continuous.mul
    · apply continuous_finset_sum
      intro n hn
      apply Continuous.mul continuous_const
      fun_prop
    · exact (continuous_gaussianZeroTest c σ).comp
        (by fun_prop : Continuous fun y : ℝ => ((2 : ℂ) + (y : ℂ) * Complex.I))



/-- The tail norm. -/
noncomputable def tailNorm (N : ℕ) : ℝ :=
  ∑' k : ℕ, ‖(ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2‖

/-- Symmetry: the prime integral at `−T` is the negative at `T`. -/
theorem primeRightIntegral_neg (c σ T : ℝ) :
    primeRightIntegral c σ (-T) = -primeRightIntegral c σ T := by
  unfold primeRightIntegral
  rw [show -(-T) = T by ring, intervalIntegral.integral_symm]

/-- Symmetry: the partial integral at `−T` is the negative at `T`. -/
theorem primePartialIntegral_neg (c σ : ℝ) (N : ℕ) (T : ℝ) :
    primePartialIntegral c σ N (-T) = -primePartialIntegral c σ N T := by
  unfold primePartialIntegral
  rw [show -(-T) = T by ring, intervalIntegral.integral_symm]



/-- The tail norm bounds the tail tsum. -/
theorem norm_tail_tsum_le (y : ℝ) (N : ℕ) :
    ‖∑' k : ℕ, primeTermFun y (k + N)‖ ≤ tailNorm N := by
  have hsum : Summable (fun k : ℕ => primeTermFun y (k + N)) :=
    (summable_primeTermFun y).comp_injective (add_left_injective N)
  refine le_trans (norm_tsum_le_tsum_norm hsum.norm) ?_
  apply Summable.tsum_le_tsum
  · intro k
    rw [primeTermFun, norm_mul, Complex.norm_exp]
    have hre : (-(Real.log ((k + N : ℕ) : ℝ)) * (y : ℂ) * Complex.I).re = 0 := by
      simp [Complex.mul_re, Complex.mul_im, Complex.log_im, Complex.arg_ofReal_of_nonneg]
    rw [hre, Real.exp_zero, mul_one]
  · exact hsum.norm
  · convert hsum.norm using 1
    funext k
    rw [primeTermFun, norm_mul, Complex.norm_exp]
    have hre : (-(Real.log ((k + N : ℕ) : ℝ)) * (y : ℂ) * Complex.I).re = 0 := by
      simp [Complex.mul_re, Complex.mul_im, Complex.log_im, Complex.arg_ofReal_of_nonneg]
    rw [hre, Real.exp_zero, mul_one]



/-- The Gaussian mass at `Re s = 2`. -/
noncomputable def gaussMass (c σ : ℝ) : ℝ :=
  2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) * Real.sqrt (Real.pi / σ ^ 2)

/-- The interval Gaussian integral is at most the full one. -/
theorem integral_exp_neg_sq_le_sqrt (σ T : ℝ) (hσ : 0 < σ) (hT : 0 ≤ T) :
    (∫ y : ℝ in (-T)..T, Real.exp (-(σ ^ 2 * y ^ 2))) ≤ Real.sqrt (Real.pi / σ ^ 2) := by
  have hexp : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have := integrable_exp_neg_mul_sq (b := σ ^ 2) (by positivity)
    simpa [neg_mul, mul_comm, mul_left_comm, mul_assoc] using this
  have hmono : (∫ y : ℝ in (-T)..T, Real.exp (-(σ ^ 2 * y ^ 2))) ≤
      ∫ y : ℝ, Real.exp (-(σ ^ 2 * y ^ 2)) := by
    rw [intervalIntegral.integral_of_le (by linarith : -T ≤ T)]
    have h := setIntegral_mono_set (μ := volume) (s := Set.Ioc (-T) T) hexp.integrableOn
      (Filter.Eventually.of_forall (fun x => (Real.exp_pos _).le))
      (Set.subset_univ _).eventuallySubset
    simpa using h
  refine hmono.trans ?_
  have hg : ∫ y : ℝ, Real.exp (-(σ ^ 2 * y ^ 2)) = Real.sqrt (Real.pi / σ ^ 2) := by
    have := integral_gaussian (σ ^ 2)
    simpa [neg_mul, mul_comm, mul_left_comm, mul_assoc] using this
  rw [hg]

/-- **The tail-integral bound** (for `T ≥ 0`). -/
theorem norm_primeRightIntegral_sub_le (c σ : ℝ) (hσ : 0 < σ) (T : ℝ) (hT : 0 ≤ T) (N : ℕ) :
    ‖primeRightIntegral c σ T - primePartialIntegral c σ N T‖ ≤ tailNorm N * gaussMass c σ := by
  rw [primeRightIntegral_sub_eq]
  have hnt := intervalIntegral.norm_integral_le_integral_norm (μ := volume)
    (f := fun y : ℝ =>
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I) -
        ∑ n ∈ Finset.range N, primeTermFun y n) *
        gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I))
    (by linarith : -T ≤ T)
  refine hnt.trans ?_
  have hbound : ∀ y : ℝ,
      ‖(LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I) -
        ∑ n ∈ Finset.range N, primeTermFun y n) *
        gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)‖ ≤
      tailNorm N * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
        Real.exp (-(σ ^ 2 * y ^ 2))) := by
    intro y
    rw [LSeries_sub_partial y N, norm_mul]
    have htail := norm_tail_tsum_le y N
    have hH := gaussianZeroTest_two_norm_le c σ y hσ
    have htn : (0:ℝ) ≤ tailNorm N := tsum_nonneg (fun k => norm_nonneg _)
    exact mul_le_mul htail hH (norm_nonneg _) (by positivity)
  have hmaj : IntervalIntegrable (fun y : ℝ =>
      tailNorm N * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
        Real.exp (-(σ ^ 2 * y ^ 2)))) volume (-T) T := by
    apply Continuous.intervalIntegrable
    fun_prop
  have hfint : IntervalIntegrable (fun y : ℝ =>
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I) -
        ∑ n ∈ Finset.range N, primeTermFun y n) *
        gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)) volume (-T) T := by
    apply Continuous.intervalIntegrable
    apply Continuous.mul
    · apply Continuous.sub continuous_LSeries_line
      apply continuous_finsetSum
      intro n hn
      apply Continuous.mul continuous_const
      fun_prop
    · exact (continuous_gaussianZeroTest c σ).comp
        (by fun_prop : Continuous fun y : ℝ => ((2 : ℂ) + (y : ℂ) * Complex.I))
  have hmono : (∫ y : ℝ in (-T)..T,
        ‖(LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((2 : ℂ) + (y : ℂ) * Complex.I) -
          ∑ n ∈ Finset.range N, primeTermFun y n) *
          gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)‖) ≤
      ∫ y : ℝ in (-T)..T, tailNorm N * (2 * Real.pi * σ ^ 2 *
        Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) * Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have hab : -T ≤ T := by linarith
    exact intervalIntegral.integral_mono_on hab hfint.norm hmaj (fun x hx => hbound x)
  refine hmono.trans ?_
  rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul]
  have hle := integral_exp_neg_sq_le_sqrt σ T hσ hT
  have htn : (0:ℝ) ≤ tailNorm N := tsum_nonneg (fun k => norm_nonneg _)
  calc tailNorm N * ((2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))) *
        (∫ y : ℝ in (-T)..T, Real.exp (-(σ ^ 2 * y ^ 2))))
      ≤ tailNorm N * ((2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))) *
          Real.sqrt (Real.pi / σ ^ 2)) := by
        apply mul_le_mul_of_nonneg_left
        · exact mul_le_mul_of_nonneg_left hle (by positivity)
        · exact htn
    _ = tailNorm N * gaussMass c σ := by
        unfold gaussMass
        ring



/-- The tail-integral bound for all `T`. -/
theorem norm_primeRightIntegral_sub_le_all (c σ : ℝ) (hσ : 0 < σ) (T : ℝ) (N : ℕ) :
    ‖primeRightIntegral c σ T - primePartialIntegral c σ N T‖ ≤ tailNorm N * gaussMass c σ := by
  rcases le_or_gt 0 T with hT | hT
  · exact norm_primeRightIntegral_sub_le c σ hσ T hT N
  · have h := norm_primeRightIntegral_sub_le c σ hσ (-T) (by linarith) N
    have hP : primeRightIntegral c σ T = -primeRightIntegral c σ (-T) := by
      simpa using primeRightIntegral_neg (c := c) (σ := σ) (T := -T)
    have hQ : primePartialIntegral c σ N T = -primePartialIntegral c σ N (-T) := by
      simpa using primePartialIntegral_neg (c := c) (σ := σ) (N := N) (T := -T)
    have hs : primeRightIntegral c σ T - primePartialIntegral c σ N T =
        -(primeRightIntegral c σ (-T) - primePartialIntegral c σ N (-T)) := by
      rw [hP, hQ]
      ring
    rw [hs, norm_neg]
    exact h

/-- The tail norm is the real part of the complex tail series. -/
theorem tailNorm_eq_re (N : ℕ) :
    tailNorm N = (∑' k : ℕ, (ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2).re := by
  have hf : Summable (fun k : ℕ => (ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2) :=
    summable_vonMangoldt_div_sq.comp_injective (add_left_injective N)
  rw [tailNorm, Complex.re_tsum hf]
  apply tsum_congr
  intro k
  have hnn : (0:ℝ) ≤ (ArithmeticFunction.vonMangoldt (k + N) : ℝ) / (((k + N : ℕ) : ℝ)) ^ 2 := by
    apply div_nonneg ArithmeticFunction.vonMangoldt_nonneg
    positivity
  have hcast : (ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2 =
      (((ArithmeticFunction.vonMangoldt (k + N) : ℝ) / (((k + N : ℕ) : ℝ)) ^ 2 : ℝ) : ℂ) := by
    push_cast
    ring
  rw [hcast, Complex.ofReal_re, Complex.norm_real, Real.norm_of_nonneg hnn]

/-- The tail norm tends to zero. -/
theorem tendsto_tailNorm :
    Tendsto tailNorm atTop (nhds 0) := by
  have hS : Tendsto (fun N : ℕ => ∑' k : ℕ,
      (ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2) atTop (nhds 0) :=
    tendsto_tail_vonMangoldt_div_sq
  have hre : Tendsto (fun N : ℕ =>
      (∑' k : ℕ, (ArithmeticFunction.vonMangoldt (k + N) : ℂ) / ((k + N : ℕ) : ℂ) ^ 2).re) atTop (nhds 0) := by
    have h := (Complex.continuous_re.tendsto (0 : ℂ)).comp hS
    convert h using 1
    ext N
    rfl
  convert hre using 1
  ext N
  rw [tailNorm_eq_re]

end ArchimedeanPrimeEvaluation

namespace ArchimedeanPrimeEvaluation

/-- **`UniformTailBound` is proved.** -/
theorem uniformTailBound (c σ : ℝ) (hσ : 0 < σ) : UniformTailBound c σ := by
  intro ε hε
  have hMpos : 0 < gaussMass c σ := by unfold gaussMass; positivity
  have hε' : 0 < ε / gaussMass c σ := by positivity
  have hev : ∀ᶠ N : ℕ in atTop, tailNorm N < ε / gaussMass c σ :=
    tendsto_tailNorm.eventually (eventually_lt_nhds hε')
  rw [eventually_atTop] at hev
  obtain ⟨N, hN⟩ := hev
  refine ⟨N, fun N' hN' T => ?_⟩
  have h1 := norm_primeRightIntegral_sub_le_all c σ hσ T N'
  have h2 : tailNorm N' * gaussMass c σ < (ε / gaussMass c σ) * gaussMass c σ :=
    mul_lt_mul_of_pos_right (hN N' hN') hMpos
  rw [div_mul_cancel₀ _ hMpos.ne'] at h2
  exact lt_of_le_of_lt h1 h2

/-- **The prime vertical limit exists.** -/
theorem primeRightLimit (c σ : ℝ) (hσ : 0 < σ) :
    PrimeRightLimit c σ
      (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ 2 *
        termwiseIntegral c σ n) :=
  primeRightLimit_of_uniformTail c σ hσ (uniformTailBound c σ hσ)

end ArchimedeanPrimeEvaluation
