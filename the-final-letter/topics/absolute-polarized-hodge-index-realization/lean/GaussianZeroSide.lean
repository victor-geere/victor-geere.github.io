import ExplicitFormula

/-!
# The zero-side test function for the Gaussian Weil–Gram basis

The explicit formula of [`ExplicitFormula.lean`](ExplicitFormula.lean) is stated
for a test function `h` on the zero side.  For the Gaussian basis of
`prime-spectrum-tensor` the correct zero-side function is the Fourier transform
of the reflected convolution, evaluated at `(s − 1/2)/i`:

```
H_c(s) = 2π σ² exp(σ² (s − 1/2)²) exp(−c (s − 1/2)).
```

On the critical line `s = 1/2 + it` this is

```
H_c(1/2 + it) = 2π σ² exp(−σ² t²) exp(−ict) = ĝ_c(t),
```

the kernel of the density term; at the poles it gives

```
H_c(0) + H_c(1) = 4π σ² exp(σ²/4) cosh(c/2),
```

the pole term of the Weil functional.

This file proves the first, unconditional half of the zero-side bridge:

* `gaussianZeroTest_critical_line` — the value on the critical line is `ĝ_c`;
* `gaussianZeroTest_pole_sum` — the pole contribution is the pole term;
* `gaussian_zero_side_contour` — the explicit formula for `H_c`, i.e. the
  contour integral of `(Z'/Z)·H_c` equals the finite zero sum minus the two
  pole terms.

What is **not** here is the prime/archimedean evaluation of the same contour
integral.  That is the remaining analytic input of the bridge; see
[`../../prime-spectrum-tensor/ZERO-SIDE-BRIDGE.md`](../../prime-spectrum-tensor/ZERO-SIDE-BRIDGE.md).
No claim about RH is made.
-/

noncomputable section

namespace AbsoluteHodgeExplicitFormula

open Complex Filter TopologicalSpace Set MeasureTheory AbsoluteHodgeSymbol AbsoluteHodgeRectangle Matrix
open scoped Topology Interval

/-- The zero-side Gaussian test function `H_c(s)`. -/
def gaussianZeroTest (c σ : ℝ) (s : ℂ) : ℂ :=
  ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
    Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (s - 1 / 2) ^ 2) *
      Complex.exp (-((c : ℝ) : ℂ) * (s - 1 / 2))

/-- `H_c` is entire. -/
theorem differentiable_gaussianZeroTest (c σ : ℝ) :
    Differentiable ℂ (gaussianZeroTest c σ) := by
  unfold gaussianZeroTest
  fun_prop

/-- `H_c(0) = 2πσ² exp(σ²/4) exp(c/2)`. -/
theorem gaussianZeroTest_zero (c σ : ℝ) :
    gaussianZeroTest c σ 0 =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (((c : ℝ) : ℂ) / 2) := by
  unfold gaussianZeroTest
  norm_num
  ring

/-- `H_c(1) = 2πσ² exp(σ²/4) exp(−c/2)`. -/
theorem gaussianZeroTest_one (c σ : ℝ) :
    gaussianZeroTest c σ 1 =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (-((c : ℝ) : ℂ) / 2) := by
  unfold gaussianZeroTest
  norm_num
  ring

/-- **The pole contribution.**  `H_c(0) + H_c(1)` is the pole term
`4πσ² exp(σ²/4) cosh(c/2)` of the Weil functional. -/
theorem gaussianZeroTest_pole_sum (c σ : ℝ) :
    gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1 =
      ((4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2) : ℝ) : ℂ) := by
  rw [gaussianZeroTest_zero, gaussianZeroTest_one]
  have hx : ((c : ℝ) : ℂ) / 2 = ((c / 2 : ℝ) : ℂ) := by push_cast; ring
  have hx' : -(((c : ℝ) : ℂ)) / 2 = -(((c / 2 : ℝ) : ℂ)) := by push_cast; ring
  have hcosh : Complex.exp (((c / 2 : ℝ) : ℂ)) + Complex.exp (-(((c / 2 : ℝ) : ℂ))) =
      2 * ((Real.cosh (c / 2) : ℝ) : ℂ) := by
    have h := (Complex.two_cosh (x := ((c / 2 : ℝ) : ℂ))).symm
    rw [← Complex.ofReal_cosh] at h
    exact h
  calc
    ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (((c : ℝ) : ℂ) / 2) +
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (-((c : ℝ) : ℂ) / 2)
        = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
            (Complex.exp (((c : ℝ) : ℂ) / 2) + Complex.exp (-((c : ℝ) : ℂ) / 2)) := by
          ring
    _ = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
            (2 * ((Real.cosh (c / 2) : ℝ) : ℂ)) := by
          rw [hx, hx', hcosh]
    _ = ((4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2) : ℝ) : ℂ) := by
          push_cast
          ring

/-- On the critical line the zero-side test function is the Fourier transform
`ĝ_c(t) = 2πσ² exp(−σ²t²) exp(−ict)`. -/
theorem gaussianZeroTest_critical_line (c σ t : ℝ) :
    gaussianZeroTest c σ ((1 / 2 : ℂ) + (t : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (-((σ ^ 2 * t ^ 2 : ℝ) : ℂ)) *
          Complex.exp (-(((c * t : ℝ) : ℂ)) * I) := by
  unfold gaussianZeroTest
  have harg : ((1 / 2 : ℂ) + (t : ℂ) * I - 1 / 2) = (t : ℂ) * I := by ring
  rw [harg]
  have hI : (I : ℂ) ^ 2 = -1 := by rw [pow_two, Complex.I_mul_I]
  have hsq : ((t : ℂ) * I) ^ 2 = -((t : ℂ) ^ 2) := by
    rw [mul_pow, hI]
    ring
  rw [hsq]
  have h1 : (((σ ^ 2 : ℝ) : ℂ) * -((t : ℂ) ^ 2)) = -(((σ ^ 2 * t ^ 2 : ℝ) : ℂ)) := by
    push_cast
    ring
  have h2 : (-((c : ℝ) : ℂ) * ((t : ℂ) * I)) = -(((c * t : ℝ) : ℂ)) * I := by
    push_cast
    ring
  rw [h1, h2]

/-- **The zero-side contour identity for the Gaussian.**  For any finite zero
set `S` in a rectangle avoiding `0, 1`, the explicit formula applied to
`H_c` gives the contour integral of `(Z'/Z)·H_c` as `2πi` times the finite zero
sum minus the two pole terms. -/
theorem gaussian_zero_side_contour (c σ : ℝ) {U : Set ℂ} (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z)
        x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, gaussianZeroTest c σ ρ) -
          gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) * (2 * (Real.pi : ℂ) * I) := by
  have hh : DifferentiableOn ℂ (gaussianZeroTest c σ) U :=
    (differentiable_gaussianZeroTest c σ).differentiableOn
  exact test_function_explicit_formula (h := gaussianZeroTest c σ) S x₁ x₂ y₁ y₂
    hU hsub hSU h0_notS h1_notS hh hF hZ hZ_zero hF_simple hF_ne h0_in h1_in hS_in

/-! ## The rank-one structure of the zero side

On the critical line `H_{a−b}(1/2+it) = φ_a(t) · conj φ_b(t)` with
`φ_a(t) = σ√(2π) exp(−σ²t²/2) exp(−iat)`.  Consequently, for any finite set
of critical-line frequencies, the zero-side Gram matrix is a sum of rank-one
positive terms and is positive semidefinite.  This is the spectral explanation
of the finite certificate: the zero side is a Gram matrix of real cosine/sine
modes.  It is conditional on the zeros being on the line; that hypothesis is
exactly the open arithmetic input in general.

The real form is stated for the cosine/sine modes because the final Gram matrix
is real.  The complex mode and its conjugate are recorded first because they
give the cleanest form of the factorization. -/

/-- The complex rank-one Gaussian mode `φ_a(t)`. -/
def gaussianMode (a σ : ℝ) (t : ℝ) : ℂ :=
  ((σ * Real.sqrt (2 * Real.pi) : ℝ) : ℂ) *
    Complex.exp (-(((σ ^ 2 * t ^ 2 : ℝ)) : ℂ) / 2) *
      Complex.exp (-(((a * t : ℝ) : ℂ)) * I)

/-- The conjugate of the complex mode. -/
theorem star_gaussianMode (a σ t : ℝ) :
    starRingEnd ℂ (gaussianMode a σ t) =
      ((σ * Real.sqrt (2 * Real.pi) : ℝ) : ℂ) *
        Complex.exp (-(((σ ^ 2 * t ^ 2 : ℝ)) : ℂ) / 2) *
          Complex.exp ((((a * t : ℝ) : ℂ)) * I) := by
  unfold gaussianMode
  rw [map_mul, map_mul]
  simp only [map_neg, map_div₀, map_ofNat, Complex.conj_ofReal,
    ← Complex.exp_conj]
  simp only [map_neg, map_mul, Complex.conj_ofReal, Complex.conj_I]
  ring_nf

/-- **General shift formula.**  For any complex `z`,
`H_c(1/2+z) = 2πσ² exp(σ²z²) exp(−cz)`. -/
theorem gaussianZeroTest_add (c σ : ℝ) (z : ℂ) :
    gaussianZeroTest c σ (1 / 2 + z) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) * z ^ 2) *
        Complex.exp (-((c : ℝ) : ℂ) * z) := by
  unfold gaussianZeroTest
  congr 2 <;> ring

/-- Real part of `exp(σ²z²)` for `z = δ+iγ`. -/
theorem gaussianZeroExp_re (σ δ γ : ℝ) :
    (Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (((δ : ℂ) + (γ : ℂ) * I) ^ 2))).re =
      Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) * Real.cos (2 * σ ^ 2 * δ * γ) := by
  rw [Complex.exp_re]
  congr 1
  · simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, pow_two]
  · simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, pow_two]
    ring

/-- Imaginary part of `exp(σ²z²)` for `z = δ+iγ`. -/
theorem gaussianZeroExp_im (σ δ γ : ℝ) :
    (Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (((δ : ℂ) + (γ : ℂ) * I) ^ 2))).im =
      Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) * Real.sin (2 * σ ^ 2 * δ * γ) := by
  rw [Complex.exp_im]
  congr 1
  · simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, pow_two]
  · simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, pow_two]
    ring

/-- Real part of `exp(−cz)+exp(cz)` for `z = δ+iγ`. -/
theorem gaussianZeroPair_re (c δ γ : ℝ) :
    (Complex.exp (-((c : ℝ) : ℂ) * ((δ : ℂ) + (γ : ℂ) * I)) +
      Complex.exp (((c : ℝ) : ℂ) * ((δ : ℂ) + (γ : ℂ) * I))).re =
      2 * Real.cosh (c * δ) * Real.cos (c * γ) := by
  rw [Complex.add_re, Complex.exp_re, Complex.exp_re]
  simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
  rw [Real.cosh_eq]
  ring

/-- Imaginary part of `exp(−cz)+exp(cz)` for `z = δ+iγ`. -/
theorem gaussianZeroPair_im (c δ γ : ℝ) :
    (Complex.exp (-((c : ℝ) : ℂ) * ((δ : ℂ) + (γ : ℂ) * I)) +
      Complex.exp (((c : ℝ) : ℂ) * ((δ : ℂ) + (γ : ℂ) * I))).im =
      2 * Real.sinh (c * δ) * Real.sin (c * γ) := by
  rw [Complex.add_im, Complex.exp_im, Complex.exp_im]
  simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
  rw [Real.sinh_eq]
  ring

/-- The symmetrised contribution of one off-line zero quadruple
`{ρ, 1−ρ, conj ρ, 1−conj ρ}`, with `ρ = 1/2 + δ + iγ`, to the zero side. -/
def offLineQuad (c σ δ γ : ℝ) : ℂ :=
  gaussianZeroTest c σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * I)) +
  gaussianZeroTest c σ (1 / 2 - ((δ : ℂ) + (γ : ℂ) * I)) +
  gaussianZeroTest c σ (1 / 2 + ((δ : ℂ) - (γ : ℂ) * I)) +
  gaussianZeroTest c σ (1 / 2 - ((δ : ℂ) - (γ : ℂ) * I))

/-- The quadruple contribution is unchanged by `γ ↦ −γ`: the zero set already
contains the conjugates, so this is only a permutation of the four terms. -/
theorem offLineQuad_neg_gamma (c σ δ γ : ℝ) :
    offLineQuad c σ δ (-γ) = offLineQuad c σ δ γ := by
  unfold offLineQuad
  push_cast
  ring_nf

/-- The quadruple contribution is even in `c`: `c ↦ −c` swaps the `ρ` and
`1−ρ` halves of the quadruple. -/
theorem offLineQuad_neg_c (c σ δ γ : ℝ) :
    offLineQuad (-c) σ δ γ = offLineQuad c σ δ γ := by
  unfold offLineQuad gaussianZeroTest
  push_cast
  ring_nf

/-- **Closed form of the off-line quadruple (real part).** -/
theorem offLineQuad_re (c σ δ γ : ℝ) :
    (offLineQuad c σ δ γ).re =
      4 * (2 * Real.pi * σ ^ 2) * Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) *
        (Real.cos (2 * σ ^ 2 * δ * γ) * Real.cosh (c * δ) * Real.cos (c * γ) -
          Real.sin (2 * σ ^ 2 * δ * γ) * Real.sinh (c * δ) * Real.sin (c * γ)) := by
  unfold offLineQuad gaussianZeroTest
  simp [Complex.add_re, Complex.mul_re, Complex.exp_re, Complex.exp_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.add_im, Complex.mul_im,
    Complex.I_re, Complex.I_im, pow_two]
  rw [Real.cosh_eq, Real.sinh_eq]
  ring_nf
  rw [Real.sin_neg, Real.cos_neg]
  ring

/-- **Exponential form of the quadruple.**  With `θ = 2σ²δγ`,
`S(c) = 2A(e^{cδ}cos(cγ+θ) + e^{−cδ}cos(cγ−θ))`; this isolates the growing term. -/
theorem offLineQuad_re_exp (c σ δ γ : ℝ) :
    (offLineQuad c σ δ γ).re =
      2 * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2))) *
        (Real.exp (c * δ) * Real.cos (c * γ + 2 * σ ^ 2 * δ * γ) +
          Real.exp (-(c * δ)) * Real.cos (c * γ - 2 * σ ^ 2 * δ * γ)) := by
  rw [offLineQuad_re, Real.cosh_eq, Real.sinh_eq, Real.cos_add, Real.cos_sub]
  ring

/-- For `δ ≠ 0` and `γ ≠ 0`, the congruence `cγ + θ ≡ 0 (mod 2π)` has
solutions with `cδ` arbitrarily large.  This is the arithmetic input for the
off-line growth estimate. -/
theorem exists_cos_eq_one_large (δ γ θ M : ℝ) (hγ : γ ≠ 0) (hδ : δ ≠ 0) :
    ∃ c : ℝ, M < c * δ ∧ Real.cos (c * γ + θ) = 1 := by
  let s : ℤ := if 0 < δ * γ then 1 else -1
  let r : ℝ := (s : ℝ) * δ / γ
  have hr : 0 < r := by
    unfold r
    by_cases h : 0 < δ * γ
    · have hs : s = 1 := by simp [s, h]
      rw [hs]
      push_cast
      have hγγ : 0 < γ * γ := mul_self_pos.mpr hγ
      have heq : (1 : ℝ) * δ / γ = (δ * γ) / (γ * γ) := by field_simp
      rw [heq]
      exact div_pos h hγγ
    · have hneg : δ * γ < 0 := by
        rcases lt_or_eq_of_le (le_of_not_gt h) with hlt | heq
        · exact hlt
        · exfalso; exact hδ (Or.resolve_right (mul_eq_zero.mp heq) hγ)
      have hs : s = -1 := by simp [s, h]
      rw [hs]
      push_cast
      have hγγ : 0 < γ * γ := mul_self_pos.mpr hγ
      have heq : (-1 : ℝ) * δ / γ = (-(δ * γ)) / (γ * γ) := by field_simp
      rw [heq]
      exact div_pos (by linarith) hγγ
  let b : ℝ := -θ * δ / γ
  have hcform : ∀ m : ℕ, (((2 * Real.pi * ((s * ((m : ℤ) + 1)) : ℤ) - θ) / γ) * δ) =
      2 * Real.pi * ((m : ℝ) + 1) * r + b := by
    intro m
    unfold r b
    field_simp [hγ]
    push_cast
    ring
  obtain ⟨m, hm⟩ := exists_nat_gt ((M - b) / (2 * Real.pi * r))
  refine ⟨(2 * Real.pi * ((s * ((m : ℤ) + 1)) : ℤ) - θ) / γ, ?_, ?_⟩
  · rw [hcform m]
    have h2 : 0 < 2 * Real.pi * r := by positivity
    have hmul : (M - b) < 2 * Real.pi * r * (m : ℝ) := by
      have := mul_lt_mul_of_pos_left hm h2
      field_simp at this
      linarith
    nlinarith
  · have harg : ((2 * Real.pi * ((s * ((m : ℤ) + 1)) : ℤ) - θ) / γ) * γ + θ =
        2 * Real.pi * ((s * ((m : ℤ) + 1)) : ℤ) := by
      field_simp [hγ]
      ring
    rw [harg]
    have hcast : (2 * Real.pi * ((s * ((m : ℤ) + 1)) : ℤ) : ℝ) =
        (s * ((m : ℤ) + 1) : ℤ) * (2 * Real.pi) := by push_cast; ring
    rw [hcast]
    exact Real.cos_int_mul_two_pi _

/-- **A 2×2 symmetric matrix with diagonal `a` and off-diagonal `b` is not
positive semidefinite when `|b| > a`.**  Test with `(1,−1)` or `(1,1)`. -/
theorem twoByTwo_not_posSemidef {a b : ℝ} (h : |b| > a) :
    ¬ (!![a, b; b, a]).PosSemidef := by
  intro hM
  rcases lt_or_ge b 0 with hb | hb
  · have habs : |b| = -b := abs_of_neg hb
    rw [habs] at h
    have hpos := hM.dotProduct_mulVec_nonneg (![1, 1] : Fin 2 → ℝ)
    simp [dotProduct, mulVec, Fin.sum_univ_two] at hpos
    linarith
  · have habs : |b| = b := abs_of_nonneg hb
    rw [habs] at h
    have hpos := hM.dotProduct_mulVec_nonneg (![1, -1] : Fin 2 → ℝ)
    simp [dotProduct, mulVec, Fin.sum_univ_two] at hpos
    linarith

/-- **Conditional off-line obstruction.**  If the symmetrised quadruple
contribution at separation `c` exceeds its diagonal value at separation `0`,
the `2 × 2` zero-side Gram matrix is not positive semidefinite.  The remaining
W4 step is to prove that such a `c` exists when `δ ≠ 0` (the growth estimate). -/
theorem offLineQuad_obstruction (c σ δ γ : ℝ)
    (h : |(offLineQuad c σ δ γ).re| > (offLineQuad 0 σ δ γ).re) :
    ¬ (!![(offLineQuad 0 σ δ γ).re, (offLineQuad c σ δ γ).re;
        (offLineQuad c σ δ γ).re, (offLineQuad 0 σ δ γ).re]).PosSemidef :=
  twoByTwo_not_posSemidef h

theorem exists_offLineQuad_gt (σ δ γ : ℝ) (hσ : 0 < σ) (hγ : γ ≠ 0) (hδ : δ ≠ 0) (B : ℝ) :
    ∃ c, B < (offLineQuad c σ δ γ).re := by
  set A : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) with hA
  have hApos : 0 < A := by rw [hA]; positivity
  set θ : ℝ := 2 * σ ^ 2 * δ * γ with hθ
  set Mval : ℝ := max (B / (2 * A) + 2) 1 with hM
  set L : ℝ := Real.log Mval with hL
  have hM1 : 1 ≤ Mval := by rw [hM]; exact le_max_right _ _
  have hMpos : 0 < Mval := lt_of_lt_of_le zero_lt_one hM1
  have hLexp : Real.exp L = Mval := by rw [hL]; exact Real.exp_log hMpos
  have hLbound : B < 2 * A * (Real.exp L - 1) := by
    rw [hLexp]
    have hMB : B / (2 * A) + 2 ≤ Mval := by rw [hM]; exact le_max_left _ _
    have hkey : B ≤ 2 * A * (Mval - 2) := by
      have := mul_le_mul_of_nonneg_left hMB (by positivity : (0 : ℝ) ≤ 2 * A)
      field_simp at this
      linarith
    nlinarith [hApos]
  obtain ⟨c, hcδ, hcos⟩ := exists_cos_eq_one_large δ γ θ L hγ hδ
  refine ⟨c, ?_⟩
  have hcos2 : Real.cos (c * γ - 2 * σ ^ 2 * δ * γ) =
      Real.cos (2 * (2 * σ ^ 2 * δ * γ)) := by
    rw [hθ] at hcos
    obtain ⟨n, hn⟩ := (Real.cos_eq_one_iff _).1 hcos
    have harg : c * γ - 2 * σ ^ 2 * δ * γ =
        -((2 * (2 * σ ^ 2 * δ * γ)) - (n : ℝ) * (2 * Real.pi)) := by
      linarith
    rw [harg, Real.cos_neg]
    exact Real.cos_sub_int_mul_two_pi (2 * (2 * σ ^ 2 * δ * γ)) n
  rw [hθ] at hcos
  rw [offLineQuad_re_exp, hcos, hcos2]
  have hexp_le : -1 ≤ Real.exp (-(c * δ)) * Real.cos (2 * (2 * σ ^ 2 * δ * γ)) := by
    have h1 : Real.exp (-(c * δ)) ≤ 1 := by
      rw [Real.exp_le_one_iff]
      have hL0 : 0 ≤ L := by
        rw [hL]
        exact Real.log_nonneg hM1
      linarith
    have h2 : -1 ≤ Real.cos (2 * (2 * σ ^ 2 * δ * γ)) := Real.neg_one_le_cos _
    have h3 : 0 ≤ Real.exp (-(c * δ)) := (Real.exp_pos _).le
    have hmul : Real.exp (-(c * δ)) * (-1) ≤
        Real.exp (-(c * δ)) * Real.cos (2 * (2 * σ ^ 2 * δ * γ)) :=
      mul_le_mul_of_nonneg_left h2 h3
    nlinarith
  have hexp_ge : Real.exp L ≤ Real.exp (c * δ) := Real.exp_le_exp.mpr (le_of_lt hcδ)
  nlinarith [hLbound, hexp_le, hexp_ge, hApos]

/-- **Unconditional 2×2 off-line obstruction.**  If `δ ≠ 0` and `γ ≠ 0`, some
separation `c` makes the 2×2 zero-side Gram matrix indefinite. -/
theorem offLineQuad_obstruction_unconditional (σ δ γ : ℝ) (hσ : 0 < σ) (hγ : γ ≠ 0) (hδ : δ ≠ 0) :
    ∃ c, ¬ (!![(offLineQuad 0 σ δ γ).re, (offLineQuad c σ δ γ).re;
              (offLineQuad c σ δ γ).re, (offLineQuad 0 σ δ γ).re]).PosSemidef := by
  obtain ⟨c, hc⟩ := exists_offLineQuad_gt σ δ γ hσ hγ hδ (offLineQuad 0 σ δ γ).re
  refine ⟨c, offLineQuad_obstruction c σ δ γ ?_⟩
  have hle : (offLineQuad c σ δ γ).re ≤ |(offLineQuad c σ δ γ).re| := le_abs_self _
  linarith

theorem exists_offLineQuad_gt_gamma_zero (σ δ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) (B : ℝ) :
    ∃ c, B < (offLineQuad c σ δ 0).re := by
  set A : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * δ ^ 2) with hA
  have hApos : 0 < A := by rw [hA]; positivity
  set Mval : ℝ := max (B / (2 * A) + 1) 1 with hM
  have hM1 : 1 ≤ Mval := by rw [hM]; exact le_max_right _ _
  have hMpos : 0 < Mval := lt_of_lt_of_le zero_lt_one hM1
  set M : ℝ := Real.log Mval with hL
  have hMexp : Real.exp M = Mval := by rw [hL]; exact Real.exp_log hMpos
  have hMB : B / (2 * A) + 1 ≤ Mval := by rw [hM]; exact le_max_left _ _
  have hB : B < 2 * A * Real.exp M := by
    rw [hMexp]
    have hm := mul_le_mul_of_nonneg_left hMB (by positivity : (0 : ℝ) ≤ 2 * A)
    field_simp at hm
    linarith
  refine ⟨M / δ, ?_⟩
  have hcδ : (M / δ) * δ = M := by field_simp [hδ]
  rw [offLineQuad_re, hcδ]
  norm_num
  have hcosh : Real.exp M / 2 ≤ Real.cosh M := by
    rw [Real.cosh_eq]
    have hpos : 0 < Real.exp M := Real.exp_pos M
    nlinarith [Real.exp_pos (-M)]
  nlinarith

/-- **Full 2×2 off-line obstruction.**  For any off-line zero with `δ ≠ 0`
(including `γ = 0`), some separation makes the 2×2 zero-side Gram matrix
indefinite. -/
theorem offLineQuad_obstruction_all (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c, ¬ (!![(offLineQuad 0 σ δ γ).re, (offLineQuad c σ δ γ).re;
              (offLineQuad c σ δ γ).re, (offLineQuad 0 σ δ γ).re]).PosSemidef := by
  by_cases hγ : γ = 0
  · subst γ
    obtain ⟨c, hc⟩ := exists_offLineQuad_gt_gamma_zero σ δ hσ hδ (offLineQuad 0 σ δ 0).re
    refine ⟨c, offLineQuad_obstruction c σ δ 0 ?_⟩
    have hle : (offLineQuad c σ δ 0).re ≤ |(offLineQuad c σ δ 0).re| := le_abs_self _
    linarith
  · obtain ⟨c, hc⟩ := exists_offLineQuad_gt σ δ γ hσ hγ hδ (offLineQuad 0 σ δ γ).re
    refine ⟨c, offLineQuad_obstruction c σ δ γ ?_⟩
    have hle : (offLineQuad c σ δ γ).re ≤ |(offLineQuad c σ δ γ).re| := le_abs_self _
    linarith

theorem exists_offLineQuad_gt_all (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) (B : ℝ) :
    ∃ c, B < (offLineQuad c σ δ γ).re := by
  by_cases hγ : γ = 0
  · subst γ
    exact exists_offLineQuad_gt_gamma_zero σ δ hσ hδ B
  · exact exists_offLineQuad_gt σ δ γ hσ hγ hδ B

theorem twoByTwo_perturbed_not_posSemidef {a b B t00 t01 t10 t11 : ℝ}
    (h00 : |t00 - a| ≤ B) (h01 : |t01 - b| ≤ B)
    (h10 : |t10 - b| ≤ B) (h11 : |t11 - a| ≤ B)
    (hB : 0 ≤ B) (h : a - b + 2 * B < 0) :
    ¬ (!![t00, t01; t10, t11]).PosSemidef := by
  intro hM
  have hpos := hM.dotProduct_mulVec_nonneg (![1, -1] : Fin 2 → ℝ)
  simp [dotProduct, mulVec, Fin.sum_univ_two] at hpos
  have e00 : t00 ≤ a + B := by
    have := (abs_le.mp h00).2; linarith
  have e11 : t11 ≤ a + B := by
    have := (abs_le.mp h11).2; linarith
  have e01 : b - B ≤ t01 := by have := (abs_le.mp h01).1; linarith
  have e10 : b - B ≤ t10 := by have := (abs_le.mp h10).1; linarith
  have hsum : t00 + -t01 + (t11 + -t10) ≤ 2 * a - 2 * b + 4 * B := by
    linarith
  linarith [hpos, hsum, h]

theorem offLineQuad_domination (σ δ γ B : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) (hB : 0 ≤ B) :
    ∃ c, (offLineQuad 0 σ δ γ).re - (offLineQuad c σ δ γ).re + 2 * B < 0 := by
  obtain ⟨c, hc⟩ := exists_offLineQuad_gt_all σ δ γ hσ hδ
    ((offLineQuad 0 σ δ γ).re + 2 * B)
  exact ⟨c, by linarith⟩


/-- **Conditional domination step for the full 2×2 block.**  If the full
zero-side block `T` is entrywise within `B` of the isolated off-line quadruple
block, and the off-line contribution satisfies
`S(0) − S(c) + 2B < 0`, then `T` is not positive semidefinite.  The remaining
W4 input is the zero-density bound that supplies such a `B`. -/
theorem offLineQuad_fullBlock_not_posSemidef (c σ δ γ B t00 t01 t10 t11 : ℝ)
    (hB : 0 ≤ B)
    (hdom : (offLineQuad 0 σ δ γ).re - (offLineQuad c σ δ γ).re + 2 * B < 0)
    (h00 : |t00 - (offLineQuad 0 σ δ γ).re| ≤ B)
    (h01 : |t01 - (offLineQuad c σ δ γ).re| ≤ B)
    (h10 : |t10 - (offLineQuad c σ δ γ).re| ≤ B)
    (h11 : |t11 - (offLineQuad 0 σ δ γ).re| ≤ B) :
    ¬ (!![t00, t01; t10, t11]).PosSemidef :=
  twoByTwo_perturbed_not_posSemidef h00 h01 h10 h11 hB hdom

/-- **Gaussian vertical-line integral.**  `∫ exp(iby) exp(−σ²y²) dy`, the
building block for the prime-side evaluation of the explicit formula on a
vertical line. -/
theorem integral_exp_gaussian_line (b σ : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, Complex.exp (I * (b : ℂ) * y) * Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * y ^ 2) =
      (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
        Complex.exp (-((b : ℂ) ^ 2) / (4 * ((σ ^ 2 : ℝ) : ℂ))) := by
  have hb : 0 < (((σ ^ 2 : ℝ) : ℂ)).re := by
    rw [Complex.ofReal_re]
    exact sq_pos_of_pos hσ
  simpa [mul_comm, mul_assoc, mul_left_comm] using
    (fourierIntegral_gaussian (b := ((σ ^ 2 : ℝ) : ℂ)) hb (t := (b : ℂ)))

/-- **Critical-line Fourier inversion for the Gaussian.**  The phase integral of
`H_c` on `Re s = 1/2` gives the Gaussian bump centred at `c`; this is the
termwise prime-side identity on the critical line. -/
theorem integral_critical_line_phase (c σ b : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, Complex.exp (-(I * (b : ℂ) * y)) *
        gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
          Complex.exp (-(((-(b + c) : ℝ) : ℂ) ^ 2) / (4 * ((σ ^ 2 : ℝ) : ℂ))) := by
  have hfun : (fun y : ℝ => Complex.exp (-(I * (b : ℂ) * y)) *
      gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)) =
      (fun y : ℝ => ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Complex.exp (I * (-(b + c) : ℝ) * y) * Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * y ^ 2))) := by
    funext y
    rw [gaussianZeroTest_critical_line]
    have hsig : (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ)) = (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2) := by
      push_cast
      ring
    rw [hsig]
    have hphase' : Complex.exp (-(I * (b : ℂ) * y)) *
          Complex.exp (-(((c * y : ℝ) : ℂ)) * I) =
        Complex.exp (I * (-(b + c) : ℝ) * y) := by
      rw [← Complex.exp_add]
      congr 1
      push_cast
      ring
    calc
      Complex.exp (-(I * (b : ℂ) * y)) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2) *
              Complex.exp (-(((c * y : ℝ) : ℂ)) * I))
          = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
              (Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2) *
                (Complex.exp (-(I * (b : ℂ) * y)) *
                  Complex.exp (-(((c * y : ℝ) : ℂ)) * I))) := by ring
      _ = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
              (Complex.exp (I * (-(b + c) : ℝ) * y) *
                Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2)) := by
            rw [hphase']; ring
  rw [hfun, MeasureTheory.integral_const_mul]
  rw [integral_exp_gaussian_line (-(b + c)) σ hσ]
  ring

/-- The `b = 0` case: the total mass of `H_c` on the critical line. -/
theorem integral_critical_line_zero_phase (c σ : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
          Complex.exp (-(((c ^ 2 : ℝ) : ℂ) / (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  simpa [neg_sq, neg_div] using integral_critical_line_phase c σ 0 hσ

/-- The critical-line phase integral is symmetric in the centre `c` and the
frequency `b` (both appear only through `b + c`). -/
theorem integral_critical_line_phase_swap (c b σ : ℝ) (hσ : 0 < σ) :
    (∫ y : ℝ, Complex.exp (-(I * (b : ℂ) * y)) *
        gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)) =
      ∫ y : ℝ, Complex.exp (-(I * (c : ℂ) * y)) *
        gaussianZeroTest b σ ((1 / 2 : ℂ) + (y : ℂ) * I) := by
  rw [integral_critical_line_phase c σ b hσ, integral_critical_line_phase b σ c hσ]
  congr 2
  ring

/-- The modulus of `H_c` on the critical line: `2πσ² exp(−σ²y²)`. -/
theorem gaussianZeroTest_critical_line_norm (c σ y : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * y ^ 2)) := by
  rw [gaussianZeroTest_critical_line]
  rw [Complex.norm_mul, Complex.norm_mul, Complex.norm_real,
    Real.norm_of_nonneg (by positivity : (0 : ℝ) ≤ 2 * Real.pi * σ ^ 2)]
  rw [Complex.norm_exp, Complex.norm_exp]
  have h1 : ((-((σ ^ 2 * y ^ 2 : ℝ)) : ℂ)).re = -(σ ^ 2 * y ^ 2) := by
    rw [Complex.neg_re, Complex.ofReal_re]
  have h2 : ((-(((c * y : ℝ)) : ℂ)) * I).re = 0 := by
    simp [Complex.mul_re]
  rw [h1, h2]
  simp

/-- **Vertical-line modulus.**  On `Re s = c`,
`‖H_c(c+iy)‖ = 2πσ² exp(σ²((c−1/2)² − y²)) exp(−c(c−1/2))`; the Gaussian
decay in `y` is the input for the contour estimates. -/
theorem gaussianZeroTest_vertical_norm (c σ y : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ ((c : ℂ) + (y : ℂ) * I)‖ =
      2 * Real.pi * σ ^ 2 *
        Real.exp (σ ^ 2 * ((c - 1 / 2) ^ 2 - y ^ 2)) *
          Real.exp (-(c * (c - 1 / 2))) := by
  unfold gaussianZeroTest
  have hz : ((c : ℂ) + (y : ℂ) * I - 1 / 2) =
      (((c - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I := by push_cast; ring
  rw [hz]
  rw [Complex.norm_mul, Complex.norm_mul, Complex.norm_real,
    Real.norm_of_nonneg (by positivity : (0 : ℝ) ≤ 2 * Real.pi * σ ^ 2)]
  rw [Complex.norm_exp, Complex.norm_exp]
  have h1 : (((σ ^ 2 : ℝ) : ℂ) * ((((c - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I) ^ 2).re =
      σ ^ 2 * ((c - 1 / 2) ^ 2 - y ^ 2) := by
    simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, pow_two]
  have h2 : (-((c : ℝ) : ℂ) * ((((c - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I)).re =
      -(c * (c - 1 / 2)) := by
    simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
  rw [h1, h2]

/-- **Vertical-line mass.**  The total modulus of `H_c` on `Re s = c` is
`2πσ² exp(σ²(c−1/2)²) exp(−c(c−1/2)) √(π/σ²)`. -/
theorem integral_vertical_norm (c σ : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, ‖gaussianZeroTest c σ ((c : ℂ) + (y : ℂ) * I)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((c - 1 / 2) ^ 2)) *
        Real.exp (-(c * (c - 1 / 2))) * Real.sqrt (Real.pi / σ ^ 2) := by
  have hfun : (fun y : ℝ => ‖gaussianZeroTest c σ ((c : ℂ) + (y : ℂ) * I)‖) =
      (fun y : ℝ => (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((c - 1 / 2) ^ 2)) *
        Real.exp (-(c * (c - 1 / 2)))) * Real.exp (-(σ ^ 2 * y ^ 2))) := by
    funext y
    rw [gaussianZeroTest_vertical_norm c σ y hσ]
    rw [show σ ^ 2 * ((c - 1 / 2) ^ 2 - y ^ 2) =
        σ ^ 2 * ((c - 1 / 2) ^ 2) + (-(σ ^ 2 * y ^ 2)) by ring, Real.exp_add]
    ring
  rw [hfun, MeasureTheory.integral_const_mul]
  have hgauss : (∫ y : ℝ, Real.exp (-(σ ^ 2 * y ^ 2))) = Real.sqrt (Real.pi / σ ^ 2) := by
    rw [show (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2))) =
        (fun y : ℝ => Real.exp (-(σ ^ 2) * y ^ 2)) by
      funext y; congr 1; ring]
    exact integral_gaussian (σ ^ 2)
  rw [hgauss]

/-- `H_c` is continuous (indeed entire). -/
theorem continuous_gaussianZeroTest (c σ : ℝ) :
    Continuous (gaussianZeroTest c σ) :=
  (differentiable_gaussianZeroTest c σ).continuous

/-- `H_c` is interval-integrable along every vertical line. -/
theorem intervalIntegrable_gaussianZeroTest_vertical (c σ a b : ℝ) :
    IntervalIntegrable (fun y : ℝ => gaussianZeroTest c σ ((c : ℂ) + (y : ℂ) * I))
      MeasureTheory.volume a b := by
  exact ((continuous_gaussianZeroTest c σ).comp
    (by fun_prop : Continuous fun y : ℝ => (c : ℂ) + (y : ℂ) * I)).intervalIntegrable a b

/-- `H_c` is interval-integrable along every horizontal line. -/
theorem intervalIntegrable_gaussianZeroTest_horizontal (c σ a b T : ℝ) :
    IntervalIntegrable (fun x : ℝ => gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * I))
      MeasureTheory.volume a b := by
  exact ((continuous_gaussianZeroTest c σ).comp
    (by fun_prop : Continuous fun x : ℝ => (x : ℂ) + (T : ℂ) * I)).intervalIntegrable a b

/-- On an interval, `(x−a)²` is bounded by the endpoint squares. -/
lemma sq_sub_le_max {x x1 x2 a : ℝ} (h1 : x1 ≤ x) (h2 : x ≤ x2) :
    (x - a) ^ 2 ≤ max ((x1 - a) ^ 2) ((x2 - a) ^ 2) := by
  have h := abs_le_max_abs_abs (show x1 - a ≤ x - a by linarith) (show x - a ≤ x2 - a by linarith)
  have h' : |x - a| ^ 2 ≤ (max |x1 - a| |x2 - a|) ^ 2 :=
    pow_le_pow_left₀ (abs_nonneg _) h 2
  rw [sq_abs] at h'
  have hmax : (max |x1 - a| |x2 - a|) ^ 2 = max ((x1 - a) ^ 2) ((x2 - a) ^ 2) := by
    rcases le_total |x1 - a| |x2 - a| with hle | hle
    · have huv : (x1 - a) ^ 2 ≤ (x2 - a) ^ 2 := by
        rw [← sq_abs (x1 - a), ← sq_abs (x2 - a)]
        exact pow_le_pow_left₀ (abs_nonneg _) hle 2
      rw [max_eq_right hle, max_eq_right huv, sq_abs]
    · have hvu : (x2 - a) ^ 2 ≤ (x1 - a) ^ 2 := by
        rw [← sq_abs (x1 - a), ← sq_abs (x2 - a)]
        exact pow_le_pow_left₀ (abs_nonneg _) hle 2
      rw [max_eq_left hle, max_eq_left hvu, sq_abs]
  rwa [hmax] at h'

/-- **General pointwise modulus.**
`‖H_c(x+iy)‖ = 2πσ² exp(σ²((x−1/2)²−y²)) exp(−c(x−1/2))`. -/
theorem gaussianZeroTest_norm (c σ x y : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2)) *
        Real.exp (-(c * (x - 1 / 2))) := by
  unfold gaussianZeroTest
  have hz : ((x : ℂ) + (y : ℂ) * I - 1 / 2) =
      (((x - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I := by push_cast; ring
  rw [hz]
  rw [Complex.norm_mul, Complex.norm_mul, Complex.norm_real,
    Real.norm_of_nonneg (by positivity : (0 : ℝ) ≤ 2 * Real.pi * σ ^ 2)]
  rw [Complex.norm_exp, Complex.norm_exp]
  have h1 : (((σ ^ 2 : ℝ) : ℂ) * ((((x - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I) ^ 2).re =
      σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2) := by
    simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, pow_two]
  have h2 : (-((c : ℝ) : ℂ) * ((((x - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I)).re =
      -(c * (x - 1 / 2)) := by
    simp [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
  rw [h1, h2]

/-- The exponential of a linear function is bounded by its endpoint values. -/
lemma exp_neg_mul_le_max (c x x1 x2 : ℝ) (h1 : x1 ≤ x) (h2 : x ≤ x2) :
    Real.exp (-(c * (x - 1 / 2))) ≤
      max (Real.exp (-(c * (x1 - 1 / 2)))) (Real.exp (-(c * (x2 - 1 / 2)))) := by
  by_cases hc : 0 ≤ c
  · have h : -(c * (x - 1 / 2)) ≤ -(c * (x1 - 1 / 2)) := by nlinarith
    exact (Real.exp_le_exp.mpr h).trans (le_max_left _ _)
  · have hc' : c ≤ 0 := le_of_lt (not_le.mp hc)
    have h : -(c * (x - 1 / 2)) ≤ -(c * (x2 - 1 / 2)) := by nlinarith
    exact (Real.exp_le_exp.mpr h).trans (le_max_right _ _)

/-- **Horizontal-side bound.**  The horizontal integral of `H_c` at height `T`
is bounded by `(x₂−x₁)` times an explicit constant times `exp(−σ²T²)`; it
therefore vanishes as `T → ∞`. -/
theorem norm_horizontal_integral_le (c σ x₁ x₂ T : ℝ) (hσ : 0 < σ) (hx : x₁ ≤ x₂) :
    ‖∫ x in x₁..x₂, gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * I)‖ ≤
      (x₂ - x₁) * (2 * Real.pi * σ ^ 2 *
        Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
          Real.exp (-(σ ^ 2 * T ^ 2)) *
            max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2))))) := by
  have hC : ∀ x ∈ Set.uIoc x₁ x₂, ‖gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * I)‖ ≤
      2 * Real.pi * σ ^ 2 *
        Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
          Real.exp (-(σ ^ 2 * T ^ 2)) *
            max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2)))) := by
    intro x hxmem
    have hxmem' : x ∈ Set.Ioc x₁ x₂ := by simpa [Set.uIoc_of_le hx] using hxmem
    have hx1 : x₁ ≤ x := le_of_lt hxmem'.1
    have hx2 : x ≤ x₂ := hxmem'.2
    rw [gaussianZeroTest_norm c σ x T hσ]
    have hmax := sq_sub_le_max (a := (1 / 2 : ℝ)) hx1 hx2
    have hexp1 : Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) ≤
        Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
          Real.exp (-(σ ^ 2 * T ^ 2)) := by
      rw [← Real.exp_add]
      apply Real.exp_le_exp.mpr
      nlinarith
    have hexp2 := exp_neg_mul_le_max c x x₁ x₂ hx1 hx2
    calc 2 * Real.pi * σ ^ 2 *
          Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) *
            Real.exp (-(c * (x - 1 / 2)))
        ≤ 2 * Real.pi * σ ^ 2 *
            (Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
              Real.exp (-(σ ^ 2 * T ^ 2))) *
                max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2)))) := by
          apply mul_le_mul _ hexp2 (by positivity) (by positivity)
          apply mul_le_mul_of_nonneg_left hexp1 (by positivity)
      _ = 2 * Real.pi * σ ^ 2 *
            Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
              Real.exp (-(σ ^ 2 * T ^ 2)) *
                max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2)))) := by ring
  have h := intervalIntegral.norm_integral_le_of_norm_le_const hC
  rw [abs_of_nonneg (by linarith : (0 : ℝ) ≤ x₂ - x₁)] at h
  simpa [mul_comm, mul_left_comm, mul_assoc] using h

/-- **General vertical mass.**  The total modulus of `H_c` on any vertical line
`Re s = x` is `2πσ² exp(σ²(x−1/2)²) exp(−c(x−1/2)) √(π/σ²)`. -/
theorem integral_norm_general (c σ x : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2)) *
        Real.exp (-(c * (x - 1 / 2))) * Real.sqrt (Real.pi / σ ^ 2) := by
  have hfun : (fun y : ℝ => ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖) =
      (fun y : ℝ => (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2)) *
        Real.exp (-(c * (x - 1 / 2)))) * Real.exp (-(σ ^ 2 * y ^ 2))) := by
    funext y
    rw [gaussianZeroTest_norm c σ x y hσ]
    rw [show σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2) =
        σ ^ 2 * ((x - 1 / 2) ^ 2) + (-(σ ^ 2 * y ^ 2)) by ring, Real.exp_add]
    ring
  rw [hfun, MeasureTheory.integral_const_mul]
  have hgauss : (∫ y : ℝ, Real.exp (-(σ ^ 2 * y ^ 2))) = Real.sqrt (Real.pi / σ ^ 2) := by
    rw [show (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2))) =
        (fun y : ℝ => Real.exp (-(σ ^ 2) * y ^ 2)) by
      funext y; congr 1; ring]
    exact integral_gaussian (σ ^ 2)
  rw [hgauss]

/-- A constant multiple of the critical-line phase integral. -/
theorem integral_phase_weighted (c σ b : ℝ) (hσ : 0 < σ) (a : ℂ) :
    ∫ y : ℝ, a * (Complex.exp (-(I * (b : ℂ) * y)) *
        gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)) =
      a * (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
          Complex.exp (-(((-(b + c) : ℝ) : ℂ) ^ 2) / (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  rw [MeasureTheory.integral_const_mul]
  rw [integral_critical_line_phase c σ b hσ]


/-- **Termwise prime-side contribution on the critical line.**  The `n`-th
von Mangoldt term `Λ(n) n^{-1/2} e^{-iy log n}` integrates against `H_c` to the
Gaussian bump centred at `c`.  This is the termwise form of the prime side of
the explicit formula, before summing over `n`. -/
theorem integral_vonMangoldt_term_critical_line (c σ : ℝ) (hσ : 0 < σ) (n : ℕ) :
    ∫ y : ℝ, ((ArithmeticFunction.vonMangoldt n : ℂ) *
        Real.exp (-(1 / 2) * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)) =
      ((ArithmeticFunction.vonMangoldt n : ℂ) *
        Real.exp (-(1 / 2) * Real.log n)) *
        (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
          (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
            Complex.exp (-(((-((Real.log n) + c) : ℝ) : ℂ) ^ 2) /
              (4 * ((σ ^ 2 : ℝ) : ℂ)))) :=
  integral_phase_weighted c σ (Real.log n) hσ _

/-- **Finite sums of phase integrals.**  Linearity of the integral over a finite
family of critical-line phase weights. -/
theorem integral_finset_sum_phase (c σ : ℝ) (hσ : 0 < σ) (s : Finset ℕ)
    (a : ℕ → ℂ) (b : ℕ → ℝ)
    (hint : ∀ n ∈ s, Integrable (fun y : ℝ => a n *
      (Complex.exp (-(I * (b n : ℂ) * y)) *
        gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)))) :
    ∫ y : ℝ, (∑ n ∈ s, a n * (Complex.exp (-(I * (b n : ℂ) * y)) *
        gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I))) =
      ∑ n ∈ s, a n * (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
          Complex.exp (-(((-(b n + c) : ℝ) : ℂ) ^ 2) / (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  rw [MeasureTheory.integral_finset_sum s hint]
  apply Finset.sum_congr rfl
  intro n hn
  exact integral_phase_weighted c σ (b n) hσ (a n)

/-- **Truncated prime side.**  The finite von Mangoldt sum integrates
termwise against `H_c` on the critical line, giving the corresponding finite
sum of Gaussian bumps.  The integrability hypothesis is the only remaining
side condition. -/
theorem integral_finset_sum_vonMangoldt (c σ : ℝ) (hσ : 0 < σ) (s : Finset ℕ)
    (hint : ∀ n ∈ s, Integrable (fun y : ℝ =>
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-(1 / 2) * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I)))) :
    ∫ y : ℝ, (∑ n ∈ s,
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-(1 / 2) * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I))) =
      ∑ n ∈ s,
        ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-(1 / 2) * Real.log n)) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
              Complex.exp (-(((-((Real.log n) + c) : ℝ) : ℂ) ^ 2) /
                (4 * ((σ ^ 2 : ℝ) : ℂ)))) :=
  integral_finset_sum_phase c σ hσ s
    (fun n => (ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-(1 / 2) * Real.log n))
    (fun n => Real.log n) hint

/-- The phase-weighted test function is integrable on the critical line. -/
theorem integrable_phase_weighted (c σ b : ℝ) (hσ : 0 < σ) (a : ℂ) :
    Integrable (fun y : ℝ => a * (Complex.exp (-(I * (b : ℂ) * y)) *
      gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I))) := by
  have hg : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2) * y ^ 2)) :=
    integrable_exp_neg_mul_sq (sq_pos_of_pos hσ)
  have hbound : ∀ y : ℝ,
      ‖a * (Complex.exp (-(I * (b : ℂ) * y)) *
        gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I))‖ ≤
      ‖a‖ * (2 * Real.pi * σ ^ 2) * Real.exp (-(σ ^ 2) * y ^ 2) := by
    intro y
    rw [norm_mul, norm_mul]
    have h1 : ‖Complex.exp (-(I * (b : ℂ) * y))‖ = 1 := by
      rw [Complex.norm_exp]
      have hre : (-(I * (b : ℂ) * y)).re = 0 := by
        simp [Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
          Complex.I_re, Complex.I_im, Complex.ofReal_re, Complex.ofReal_im]
      rw [hre, Real.exp_zero]
    rw [h1, gaussianZeroTest_critical_line_norm c σ y hσ]
    have heq : Real.exp (-(σ ^ 2 * y ^ 2)) = Real.exp (-(σ ^ 2) * y ^ 2) := by
      congr 1
      ring
    rw [heq]
    ring_nf
    exact le_rfl
  have hint : Integrable (fun y : ℝ =>
      ‖a‖ * (2 * Real.pi * σ ^ 2) * Real.exp (-(σ ^ 2) * y ^ 2)) :=
    hg.const_mul _
  have hcont : Continuous (fun y : ℝ => a * (Complex.exp (-(I * (b : ℂ) * y)) *
      gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I))) := by
    apply Continuous.mul continuous_const
    apply Continuous.mul
    · fun_prop
    · exact (continuous_gaussianZeroTest c σ).comp (by fun_prop)
  exact hint.mono' hcont.aestronglyMeasurable (Filter.Eventually.of_forall hbound)

/-- **Unconditional truncated prime side.**  The finite von Mangoldt sum
integrates termwise against `H_c` on the critical line, with no remaining side
conditions. -/
theorem integral_finset_sum_vonMangoldt_all (c σ : ℝ) (hσ : 0 < σ) (s : Finset ℕ) :
    ∫ y : ℝ, (∑ n ∈ s,
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-(1 / 2) * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((1 / 2 : ℂ) + (y : ℂ) * I))) =
      ∑ n ∈ s,
        ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-(1 / 2) * Real.log n)) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
              Complex.exp (-(((-((Real.log n) + c) : ℝ) : ℂ) ^ 2) /
                (4 * ((σ ^ 2 : ℝ) : ℂ)))) :=
  integral_finset_sum_vonMangoldt c σ hσ s
    (fun n _ => integrable_phase_weighted c σ (Real.log n) hσ _)

/-- **General vertical-line decomposition.**  On `Re s = x`,
`H_c(x+iy) = 2πσ² exp(σ²(x−1/2)² − c(x−1/2)) exp(−σ²y²) exp(i(2σ²(x−1/2)−c)y)`.
This is the phase form used to evaluate the prime side on `Re s > 1`. -/
theorem gaussianZeroTest_vertical_form (c σ x y : ℝ) :
    gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
          Complex.exp (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ))) *
        Complex.exp (I * (((2 * σ ^ 2 * (x - 1 / 2) - c) * y : ℝ) : ℂ)) := by
  unfold gaussianZeroTest
  have hz : ((x : ℂ) + (y : ℂ) * I - 1 / 2) =
      (((x - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I := by push_cast; ring
  rw [hz]
  set a : ℝ := x - 1 / 2
  set X : ℝ := σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2) with hX
  set Y : ℝ := 2 * σ ^ 2 * (x - 1 / 2) * y with hY
  set U : ℝ := -(c * (x - 1 / 2)) with hU
  set V : ℝ := -(c * y) with hV
  have hsq : (((σ ^ 2 : ℝ) : ℂ) * ((((x - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I) ^ 2) =
      ((X : ℝ) : ℂ) + ((Y : ℝ) : ℂ) * I := by
    rw [hX, hY]
    push_cast
    ring_nf
    simp [Complex.I_mul_I]
    ring
  have hlin : (-((c : ℝ) : ℂ) * ((((x - 1 / 2 : ℝ)) : ℂ) + (y : ℂ) * I)) =
      ((U : ℝ) : ℂ) + ((V : ℝ) : ℂ) * I := by
    rw [hU, hV]
    push_cast
    ring
  rw [hsq, hlin, Complex.exp_add, Complex.exp_add]
  have hXU : X + U = (σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2)) + (-(σ ^ 2 * y ^ 2)) := by
    rw [hX, hU]; ring
  have hYV : Y + V = (2 * σ ^ 2 * (x - 1 / 2) - c) * y := by
    rw [hY, hV]; ring
  calc
    ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        (Complex.exp ((X : ℝ) : ℂ) * Complex.exp (((Y : ℝ) : ℂ) * I)) *
          (Complex.exp ((U : ℝ) : ℂ) * Complex.exp (((V : ℝ) : ℂ) * I))
        = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            (Complex.exp ((X : ℝ) : ℂ) * Complex.exp ((U : ℝ) : ℂ)) *
              (Complex.exp (((Y : ℝ) : ℂ) * I) * Complex.exp (((V : ℝ) : ℂ) * I)) := by ring
    _ = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((X + U : ℝ)) : ℂ) *
              Complex.exp ((((Y + V : ℝ)) : ℂ) * I) := by
          rw [← Complex.exp_add, ← Complex.exp_add]
          congr 2
          · push_cast; ring
          · push_cast; ring
    _ = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            (Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
              Complex.exp (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ))) *
              Complex.exp (I * (((2 * σ ^ 2 * (x - 1 / 2) - c) * y : ℝ) : ℂ)) := by
          rw [hXU, hYV]
          rw [show ((((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2)) + (-(σ ^ 2 * y ^ 2)) : ℝ) : ℂ)) =
              (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) +
                ((-(((σ ^ 2 * y ^ 2 : ℝ))) : ℂ)) by push_cast; ring,
            Complex.exp_add]
          ring

/-- On the real axis, `H_c(x) = 2πσ² exp(σ²(x−1/2)² − c(x−1/2))` is a
positive real number. -/
theorem gaussianZeroTest_real (c σ x : ℝ) :
    gaussianZeroTest c σ (x : ℂ) =
      ((2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2)) : ℝ) : ℂ) := by
  simpa using gaussianZeroTest_vertical_form c σ x 0

/-- The real-axis modulus of `H_c`. -/
theorem gaussianZeroTest_real_norm (c σ x : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ (x : ℂ)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2)) := by
  rw [gaussianZeroTest_real, Complex.norm_real,
    Real.norm_of_nonneg (by positivity)]

/-- The modulus at the pole `s = 0`. -/
theorem gaussianZeroTest_zero_norm (c σ : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ (0 : ℂ)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4 + c / 2) := by
  rw [show (0 : ℂ) = ((0 : ℝ) : ℂ) by norm_num]
  rw [gaussianZeroTest_real_norm c σ 0 hσ]
  congr 1
  ring

/-- The modulus at the pole `s = 1`. -/
theorem gaussianZeroTest_one_norm (c σ : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ (1 : ℂ)‖ =
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4 - c / 2) := by
  rw [show (1 : ℂ) = ((1 : ℝ) : ℂ) by norm_num]
  rw [gaussianZeroTest_real_norm c σ 1 hσ]
  congr 1
  ring

/-- The product of the two pole-point moduli. -/
theorem gaussianZeroTest_pole_norm_mul (c σ : ℝ) (hσ : 0 < σ) :
    ‖gaussianZeroTest c σ (0 : ℂ)‖ * ‖gaussianZeroTest c σ (1 : ℂ)‖ =
      (2 * Real.pi * σ ^ 2) ^ 2 * Real.exp (σ ^ 2 / 2) := by
  rw [gaussianZeroTest_zero_norm c σ hσ, gaussianZeroTest_one_norm c σ hσ]
  have h : Real.exp (σ ^ 2 / 4 + c / 2) * Real.exp (σ ^ 2 / 4 - c / 2) =
      Real.exp (σ ^ 2 / 2) := by
    rw [← Real.exp_add]
    congr 1
    ring
  rw [show (2 * Real.pi * σ ^ 2) * Real.exp (σ ^ 2 / 4 + c / 2) *
        ((2 * Real.pi * σ ^ 2) * Real.exp (σ ^ 2 / 4 - c / 2)) =
      (2 * Real.pi * σ ^ 2) ^ 2 *
        (Real.exp (σ ^ 2 / 4 + c / 2) * Real.exp (σ ^ 2 / 4 - c / 2)) by ring, h]

/-- **General vertical phase integral.**  On any vertical line `Re s = x`, the
phase integral of `H_c` is an explicit Gaussian bump in `a`; this is the
termwise prime-side identity off the critical line. -/
theorem integral_vertical_phase (c σ x a : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, Complex.exp (-(I * (a : ℂ) * y)) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
          (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
            Complex.exp (-(((((2 * σ ^ 2 * (x - 1 / 2) - c) - a) : ℝ) : ℂ) ^ 2) /
              (4 * ((σ ^ 2 : ℝ) : ℂ))) := by
  set b : ℝ := 2 * σ ^ 2 * (x - 1 / 2) - c with hb
  set real : ℝ := σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) with hreal
  have hfun : (fun y : ℝ => Complex.exp (-(I * (a : ℂ) * y)) *
      gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) =
      (fun y : ℝ => (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((real : ℝ)) : ℂ)) *
        (Complex.exp (I * ((((b - a) * y : ℝ)) : ℂ)) *
          Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2))) := by
    funext y
    rw [gaussianZeroTest_vertical_form]
    have hphase : Complex.exp (-(I * (a : ℂ) * y)) *
          Complex.exp (I * (((b * y : ℝ)) : ℂ)) =
        Complex.exp (I * ((((b - a) * y : ℝ)) : ℂ)) := by
      rw [← Complex.exp_add]
      congr 1
      push_cast
      ring
    have hsig : Complex.exp (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ)) =
        Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2) := by
      congr 1
      push_cast
      ring
    calc
      Complex.exp (-(I * (a : ℂ) * y)) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            (Complex.exp (((real : ℝ)) : ℂ) *
              Complex.exp (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ))) *
            Complex.exp (I * (((b * y : ℝ)) : ℂ)))
          = (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
              Complex.exp (((real : ℝ)) : ℂ)) *
              (Complex.exp (-(I * (a : ℂ) * y)) *
                Complex.exp (I * (((b * y : ℝ)) : ℂ))) *
              Complex.exp (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ)) := by ring
      _ = (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
              Complex.exp (((real : ℝ)) : ℂ)) *
              Complex.exp (I * ((((b - a) * y : ℝ)) : ℂ)) *
              Complex.exp (-(((σ ^ 2 * y ^ 2 : ℝ)) : ℂ)) := by rw [hphase]
      _ = (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
              Complex.exp (((real : ℝ)) : ℂ)) *
              (Complex.exp (I * ((((b - a) * y : ℝ)) : ℂ)) *
                Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2)) := by rw [hsig]; ring
  rw [hfun]
  simp only [mul_assoc]
  rw [MeasureTheory.integral_const_mul]
  rw [MeasureTheory.integral_const_mul]
  have hInt : (∫ y : ℝ, Complex.exp (I * ((((b - a) * y : ℝ)) : ℂ)) *
        Complex.exp (-(((σ ^ 2 : ℝ) : ℂ)) * (y : ℂ) ^ 2)) =
      (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
        Complex.exp (-((((b - a) : ℝ) : ℂ) ^ 2) / (4 * ((σ ^ 2 : ℝ) : ℂ))) := by
    simpa [mul_assoc] using integral_exp_gaussian_line (b - a) σ hσ
  rw [hInt]


/-- Weighted form of the general vertical phase integral. -/
theorem integral_vertical_phase_weighted (c σ x a : ℝ) (hσ : 0 < σ) (ncoef : ℂ) :
    ∫ y : ℝ, ncoef * (Complex.exp (-(I * (a : ℂ) * y)) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) =
      ncoef * (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
          (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
            Complex.exp (-(((((2 * σ ^ 2 * (x - 1 / 2) - c) - a) : ℝ) : ℂ) ^ 2) /
              (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  rw [MeasureTheory.integral_const_mul]
  rw [integral_vertical_phase c σ x a hσ]

/-- **Termwise prime term off the critical line.**  The `n`-th von Mangoldt
test term `n^{-x}e^{-iy log n}` integrates against `H_c` on `Re s = x` to an
explicit Gaussian bump. -/
theorem integral_vonMangoldt_term_vertical (c σ x : ℝ) (hσ : 0 < σ) (n : ℕ) :
    ∫ y : ℝ, ((Real.exp (-x * Real.log n) : ℝ) : ℂ) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) =
      ((Real.exp (-x * Real.log n) : ℝ) : ℂ) *
        (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
          Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
            (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
              Complex.exp (-(((((2 * σ ^ 2 * (x - 1 / 2) - c) - Real.log n) : ℝ) : ℂ) ^ 2) /
                (4 * ((σ ^ 2 : ℝ) : ℂ)))) :=
  integral_vertical_phase_weighted c σ x (Real.log n) hσ _

/-- **Finite vertical prime side.**  The finite von Mangoldt sum integrates
termwise against `H_c` on `Re s = x`, giving a finite sum of Gaussian bumps;
conditional only on integrability. -/
theorem integral_finset_sum_vonMangoldt_vertical (c σ x : ℝ) (hσ : 0 < σ) (s : Finset ℕ)
    (hint : ∀ n ∈ s, Integrable (fun y : ℝ =>
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))) :
    ∫ y : ℝ, (∑ n ∈ s,
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) =
      ∑ n ∈ s,
        ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
              (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
                Complex.exp (-(((((2 * σ ^ 2 * (x - 1 / 2) - c) - Real.log n) : ℝ) : ℂ) ^ 2) /
                  (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  rw [MeasureTheory.integral_finset_sum s hint]
  apply Finset.sum_congr rfl
  intro n hn
  exact integral_vertical_phase_weighted c σ x (Real.log n) hσ _

/-- The phase-weighted test function is integrable on any vertical line. -/
theorem integrable_phase_vertical (c σ x b : ℝ) (hσ : 0 < σ) (a : ℂ) :
    Integrable (fun y : ℝ => a * (Complex.exp (-(I * (b : ℂ) * y)) *
      gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) := by
  have hg : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2) * y ^ 2)) :=
    integrable_exp_neg_mul_sq (sq_pos_of_pos hσ)
  have hbound : ∀ y : ℝ,
      ‖a * (Complex.exp (-(I * (b : ℂ) * y)) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))‖ ≤
      ‖a‖ * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2)) *
        Real.exp (-(c * (x - 1 / 2)))) * Real.exp (-(σ ^ 2) * y ^ 2) := by
    intro y
    rw [norm_mul, norm_mul]
    have h1 : ‖Complex.exp (-(I * (b : ℂ) * y))‖ = 1 := by
      rw [Complex.norm_exp]
      have hre : (-(I * (b : ℂ) * y)).re = 0 := by
        simp [Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
          Complex.I_re, Complex.I_im, Complex.ofReal_re, Complex.ofReal_im]
      rw [hre, Real.exp_zero]
    rw [h1, gaussianZeroTest_norm c σ x y hσ]
    rw [show σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2) =
        σ ^ 2 * ((x - 1 / 2) ^ 2) + (-(σ ^ 2 * y ^ 2)) by ring, Real.exp_add]
    have heq : Real.exp (-(σ ^ 2 * y ^ 2)) = Real.exp (-(σ ^ 2) * y ^ 2) := by
      congr 1
      ring
    rw [heq]
    ring_nf
    exact le_rfl
  have hint : Integrable (fun y : ℝ =>
      ‖a‖ * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2)) *
        Real.exp (-(c * (x - 1 / 2)))) * Real.exp (-(σ ^ 2) * y ^ 2)) :=
    hg.const_mul _
  have hcont : Continuous (fun y : ℝ => a * (Complex.exp (-(I * (b : ℂ) * y)) *
      gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) := by
    apply Continuous.mul continuous_const
    apply Continuous.mul
    · fun_prop
    · exact (continuous_gaussianZeroTest c σ).comp (by fun_prop)
  exact hint.mono' hcont.aestronglyMeasurable (Filter.Eventually.of_forall hbound)

/-- **Unconditional finite vertical prime side.**  The truncated von Mangoldt
sum integrates termwise against `H_c` on any vertical line `Re s = x`, with no
remaining side conditions. -/
theorem integral_finset_sum_vonMangoldt_vertical_all (c σ x : ℝ) (hσ : 0 < σ) (s : Finset ℕ) :
    ∫ y : ℝ, (∑ n ∈ s,
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) =
      ∑ n ∈ s,
        ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
          (((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
            Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
              (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
                Complex.exp (-(((((2 * σ ^ 2 * (x - 1 / 2) - c) - Real.log n) : ℝ) : ℂ) ^ 2) /
                  (4 * ((σ ^ 2 : ℝ) : ℂ)))) :=
  integral_finset_sum_vonMangoldt_vertical c σ x hσ s
    (fun n _ => integrable_phase_vertical c σ x (Real.log n) hσ
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)))

/-- **Infinite prime-side reduction.**  If the norm integrals of the von
Mangoldt terms are summable, the integrals sum to the integral of the `tsum`;
the infinite prime side is reduced to the Gaussian bumps. -/
theorem hasSum_integral_vonMangoldt (c σ x : ℝ) (hσ : 0 < σ)
    (hsum : Summable (fun n : ℕ => ∫ y : ℝ,
      ‖((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))‖)) :
    HasSum (fun n : ℕ => ∫ y : ℝ,
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
        (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
          gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))
      (∫ y : ℝ, (∑' n : ℕ,
        ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n)) *
          (Complex.exp (-(I * (Real.log n : ℂ) * y)) *
            gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))) :=
  hasSum_integral_of_summable_integral_norm
    (fun n => integrable_phase_vertical c σ x (Real.log n) hσ
      ((ArithmeticFunction.vonMangoldt n : ℂ) * Real.exp (-x * Real.log n))) hsum

/-- The vertical integral of `H_c` itself (zero frequency). -/
theorem integral_gaussianZeroTest_vertical (c σ x : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((σ ^ 2 * ((x - 1 / 2) ^ 2) - c * (x - 1 / 2) : ℝ)) : ℂ) *
          (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
            Complex.exp (-(((((2 * σ ^ 2 * (x - 1 / 2) - c) : ℝ) : ℂ) ^ 2) /
              (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  simpa [neg_div] using integral_vertical_phase c σ x 0 hσ

/-- The vertical integral of `H_c` on the line `Re s = c`. -/
theorem integral_gaussianZeroTest_vertical_self (c σ : ℝ) (hσ : 0 < σ) :
    ∫ y : ℝ, gaussianZeroTest c σ ((c : ℂ) + (y : ℂ) * I) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
        Complex.exp (((σ ^ 2 * ((c - 1 / 2) ^ 2) - c * (c - 1 / 2) : ℝ)) : ℂ) *
          (Real.pi / ((σ ^ 2 : ℝ) : ℂ)) ^ (1 / 2 : ℂ) *
            Complex.exp (-(((((2 * σ ^ 2 * (c - 1 / 2) - c) : ℝ) : ℂ) ^ 2) /
              (4 * ((σ ^ 2 : ℝ) : ℂ)))) := by
  simpa using integral_gaussianZeroTest_vertical c σ c hσ

/-- **Right-side prime/archimedean decomposition for the Gaussian.**  On
`Re s = c > 1`, the right vertical side of the explicit formula for `H_c`
splits into the archimedean factor and the von Mangoldt L-series. -/
theorem integral_logDeriv_gaussianZeroTest_right_side (c σ y₁ y₂ : ℝ) (hc : 1 < c) :
    ∫ y : ℝ in y₁..y₂,
        logDeriv completedZeta (c + y * I) * gaussianZeroTest c σ (c + y * I) * I
      = - ((∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((c + y * I) / 2))
              * gaussianZeroTest c σ (c + y * I)) * I)
        - ((∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
              * gaussianZeroTest c σ (c + y * I)) * I) := by
  have hh : ContinuousOn (fun y : ℝ => gaussianZeroTest c σ (c + y * I)) (Set.uIcc y₁ y₂) :=
    ((continuous_gaussianZeroTest c σ).comp
      (by fun_prop : Continuous fun y : ℝ => (c : ℂ) + (y : ℂ) * I)).continuousOn
  have hL : ContinuousOn (fun y : ℝ =>
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (c + y * I)
        * gaussianZeroTest c σ (c + y * I) * I) (Set.uIcc y₁ y₂) := by
    exact ((continuousOn_lseries_vonMangoldt c y₁ y₂ hc).mul hh).mul_const I
  simpa using integral_logDeriv_mul_I_eq_neg_arch_prime' (h := gaussianZeroTest c σ) c y₁ y₂ hc hh hL

/-- **General right-side decomposition.**  On `Re s = x > 1`, with an
independent Gaussian centre `c`. -/
theorem integral_logDeriv_gaussianZeroTest_right_side' (c σ x y₁ y₂ : ℝ) (hx : 1 < x) :
    ∫ y : ℝ in y₁..y₂,
        logDeriv completedZeta (x + y * I) * gaussianZeroTest c σ (x + y * I) * I
      = - ((∫ y : ℝ in y₁..y₂,
            ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((x + y * I) / 2))
              * gaussianZeroTest c σ (x + y * I)) * I)
        - ((∫ y : ℝ in y₁..y₂,
            LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (x + y * I)
              * gaussianZeroTest c σ (x + y * I)) * I) := by
  have hh : ContinuousOn (fun y : ℝ => gaussianZeroTest c σ (x + y * I)) (Set.uIcc y₁ y₂) :=
    ((continuous_gaussianZeroTest c σ).comp
      (by fun_prop : Continuous fun y : ℝ => (x : ℂ) + (y : ℂ) * I)).continuousOn
  have hL : ContinuousOn (fun y : ℝ =>
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (x + y * I)
        * gaussianZeroTest c σ (x + y * I) * I) (Set.uIcc y₁ y₂) := by
    exact ((continuousOn_lseries_vonMangoldt x y₁ y₂ hx).mul hh).mul_const I
  simpa using integral_logDeriv_mul_I_eq_neg_arch_prime' (h := gaussianZeroTest c σ) x y₁ y₂ hx hh hL

/-- **Rectangle assembly with the right side decomposed.**  The rectangle
integral of `(Z'/Z)·H_c` is expressed through its four sides, with the right
side split into the archimedean and von Mangoldt contributions. -/
theorem rectIntegral_gaussian_right_side (c σ x₁ x₂ y₁ y₂ : ℝ) (hx₂ : 1 < x₂) :
    AbsoluteHodgeRectangle.rectIntegral
        (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) x₁ x₂ y₁ y₂
      = (∫ x : ℝ in x₁..x₂,
            logDeriv completedZeta (x + y₁ * I) * gaussianZeroTest c σ (x + y₁ * I))
        - (∫ x : ℝ in x₁..x₂,
            logDeriv completedZeta (x + y₂ * I) * gaussianZeroTest c σ (x + y₂ * I))
        + (- ((∫ y : ℝ in y₁..y₂,
              ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((x₂ + y * I) / 2))
                * gaussianZeroTest c σ (x₂ + y * I)) * I)
            - ((∫ y : ℝ in y₁..y₂,
              LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (x₂ + y * I)
                * gaussianZeroTest c σ (x₂ + y * I)) * I))
        - I * (∫ y : ℝ in y₁..y₂,
            logDeriv completedZeta (x₁ + y * I) * gaussianZeroTest c σ (x₁ + y * I)) := by
  unfold AbsoluteHodgeRectangle.rectIntegral
  have hconv : I * (∫ y : ℝ in y₁..y₂,
        logDeriv completedZeta (x₂ + y * I) * gaussianZeroTest c σ (x₂ + y * I)) =
      ∫ y : ℝ in y₁..y₂,
        logDeriv completedZeta (x₂ + y * I) * gaussianZeroTest c σ (x₂ + y * I) * I := by
    rw [intervalIntegral.integral_mul_const]
    ring
  rw [hconv, integral_logDeriv_gaussianZeroTest_right_side' c σ x₂ y₁ y₂ hx₂]

/-- Reflection of the Gaussian test function: `H_c(1−w) = H_{−c}(w)`. -/
theorem gaussianZeroTest_one_sub (c σ : ℝ) (w : ℂ) :
    gaussianZeroTest c σ (1 - w) = gaussianZeroTest (-c) σ w := by
  unfold gaussianZeroTest
  congr 1
  · ring
  · congr 1
    push_cast
    ring

/-- **Pointwise functional-equation reflection.**  For `s ≠ 0,1` off the
pole conditions, `(Z'/Z)(1−s)·H_c(1−s) = −(Z'/Z)(s)·H_{−c}(s)`.  The left
side of the explicit formula for `H_c` is the right side for `H_{−c}`. -/
theorem logDeriv_mul_gaussianZeroTest_one_sub (c σ : ℝ) {s : ℂ}
    (hs0 : s ≠ 0) (hs1 : s ≠ 1) (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) (hg' : ∀ m : ℕ, (1 - s) / 2 ≠ -(m : ℂ)) :
    logDeriv completedZeta (1 - s) * gaussianZeroTest c σ (1 - s)
      = - (logDeriv completedZeta s * gaussianZeroTest (-c) σ s) := by
  rw [gaussianZeroTest_one_sub c σ s]
  rw [AbsoluteHodgeSymbol.logDeriv_completedZeta_one_sub hs0 hs1 hΓ hΓ' hg hg']
  ring

/-- **Left vertical side reflected to the right side.**  The left side of the
explicit formula for `H_c` (at `Re s = −1`) equals minus the right side for
`H_{−c}` (at `Re s = 2`). -/
theorem integral_logDeriv_gaussianZeroTest_left_eq_neg_right (c σ T : ℝ) :
    (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((-1 : ℂ) + y * I) * gaussianZeroTest c σ ((-1 : ℂ) + y * I) * I)
      = - (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * gaussianZeroTest (-c) σ ((2 : ℝ) + y * I) * I) := by
  have hneg : (∫ x : ℝ in (-T)..T,
        logDeriv completedZeta ((-1 : ℂ) + (-x) * I)
          * gaussianZeroTest c σ ((-1 : ℂ) + (-x) * I) * I)
      = ∫ x : ℝ in (-T)..T,
          logDeriv completedZeta ((-1 : ℂ) + x * I) * gaussianZeroTest c σ ((-1 : ℂ) + x * I) * I := by
    have := intervalIntegral.integral_comp_neg
      (f := fun y : ℝ => logDeriv completedZeta ((-1 : ℂ) + y * I)
        * gaussianZeroTest c σ ((-1 : ℂ) + y * I) * I) (a := -T) (b := T)
    simpa using this
  rw [← hneg]
  rw [← intervalIntegral.integral_neg]
  apply intervalIntegral.integral_congr
  intro y hy
  show logDeriv completedZeta ((-1 : ℂ) + -(y : ℂ) * I)
      * gaussianZeroTest c σ ((-1 : ℂ) + -(y : ℂ) * I) * I
    = -(logDeriv completedZeta (2 + (y : ℂ) * I)
      * gaussianZeroTest (-c) σ (2 + (y : ℂ) * I) * I)
  have harg : ((-1 : ℂ)) + (-(y : ℂ)) * I = 1 - (2 + (y : ℂ) * I) := by ring
  rw [harg]
  have hs0 : (2 + (y : ℂ) * I) ≠ 0 := by
    intro h0
    have hre : (2 + (y : ℂ) * I).re = 2 := by simp
    rw [h0] at hre
    simp at hre
  have hs1 : (2 + (y : ℂ) * I) ≠ 1 := by
    intro h0
    have hre : (2 + (y : ℂ) * I).re = 2 := by simp
    rw [h0] at hre
    simp at hre
  have hΓ : (2 + (y : ℂ) * I).Gammaℝ ≠ 0 := by
    intro h0
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h0
    have hre : (2 + (y : ℂ) * I).re = 2 := by simp
    rw [hn] at hre
    simp at hre
    linarith [show (0 : ℝ) ≤ (n : ℝ) from Nat.cast_nonneg n]
  have hΓ' : (1 - (2 + (y : ℂ) * I)).Gammaℝ ≠ 0 := by
    intro h0
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h0
    have hre : (1 - (2 + (y : ℂ) * I)).re = (-1 : ℝ) := by
      have h1 : (1 - (2 + (y : ℂ) * I)) = (-1 : ℂ) - (y : ℂ) * I := by ring
      rw [h1]
      simp
    rw [hn] at hre
    simp at hre
    have h2' : ((2 * n : ℕ) : ℝ) = 1 := by push_cast; linarith
    have h2 : (2 * n : ℕ) = 1 := by exact_mod_cast h2'
    omega
  have hg : ∀ m : ℕ, (2 + (y : ℂ) * I) / 2 ≠ -(m : ℂ) := by
    intro m h0
    have hre : ((2 + (y : ℂ) * I) / 2).re = 1 := by simp
    rw [h0] at hre
    simp at hre
    linarith [show (0 : ℝ) ≤ (m : ℝ) from Nat.cast_nonneg m]
  have hg' : ∀ m : ℕ, (1 - (2 + (y : ℂ) * I)) / 2 ≠ -(m : ℂ) := by
    intro m h0
    have hre : ((1 - (2 + (y : ℂ) * I)) / 2).re = (-(1 / 2) : ℝ) := by
      have h1 : (1 - (2 + (y : ℂ) * I)) / 2 = (-(1 / 2) : ℂ) - ((y : ℂ) / 2) * I := by ring
      rw [h1]
      simp
    rw [h0] at hre
    simp at hre
    have h2' : ((2 * m : ℕ) : ℝ) = 1 := by push_cast; linarith
    have h2 : (2 * m : ℕ) = 1 := by exact_mod_cast h2'
    omega
  rw [logDeriv_mul_gaussianZeroTest_one_sub c σ hs0 hs1 hΓ hΓ' hg hg']
  ring

/-- The symmetric case `c = 0`: the left side is minus the right side for the
same test function `H_0`. -/
theorem integral_logDeriv_gaussianZeroTest_left_eq_neg_right_zero (σ T : ℝ) :
    (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((-1 : ℂ) + y * I) * gaussianZeroTest 0 σ ((-1 : ℂ) + y * I) * I)
      = - (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * I) * gaussianZeroTest 0 σ ((2 : ℝ) + y * I) * I) := by
  simpa using integral_logDeriv_gaussianZeroTest_left_eq_neg_right 0 σ T

/-- Reflection preserves the modulus: `‖H_c(1−w)‖ = ‖H_{−c}(w)‖`. -/
theorem gaussianZeroTest_one_sub_norm (c σ : ℝ) (w : ℂ) :
    ‖gaussianZeroTest c σ (1 - w)‖ = ‖gaussianZeroTest (-c) σ w‖ := by
  rw [gaussianZeroTest_one_sub]

/-- The symmetric test function is invariant under `w ↦ 1−w`:
`H_0(1−w) = H_0(w)`. -/
theorem gaussianZeroTest_one_sub_zero (σ : ℝ) (w : ℂ) :
    gaussianZeroTest 0 σ (1 - w) = gaussianZeroTest 0 σ w := by
  rw [gaussianZeroTest_one_sub]
  norm_num

/-- The pole values swap under reflection: `H_c(1) = H_{−c}(0)`. -/
theorem gaussianZeroTest_one_eq_neg_zero (c σ : ℝ) :
    gaussianZeroTest c σ (1 : ℂ) = gaussianZeroTest (-c) σ (0 : ℂ) := by
  simpa using gaussianZeroTest_one_sub c σ (0 : ℂ)

/-- The pole values swap under reflection: `H_c(0) = H_{−c}(1)`. -/
theorem gaussianZeroTest_zero_eq_neg_one (c σ : ℝ) :
    gaussianZeroTest c σ (0 : ℂ) = gaussianZeroTest (-c) σ (1 : ℂ) := by
  simpa using gaussianZeroTest_one_sub c σ (1 : ℂ)

/-- **Vertical integral limit.**  The truncated vertical integral of `H_c`
converges to the full integral as `T → ∞`. -/
theorem tendsto_vertical_integral (c σ x : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) atTop
      (nhds (∫ y : ℝ, gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) := by
  have hfi : Integrable (fun y : ℝ => gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) := by
    simpa using integrable_phase_vertical c σ x 0 hσ (1 : ℂ)
  simpa using intervalIntegral_tendsto_integral
    (f := fun y : ℝ => gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) hfi
    (tendsto_neg_atTop_atBot) tendsto_id

/-- The Gaussian decay `exp(−σ²T²)` tends to zero as `T → ∞`. -/
theorem tendsto_exp_neg_sq_zero (σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => Real.exp (-(σ ^ 2 * T ^ 2))) atTop (nhds 0) := by
  have hsq : Tendsto (fun T : ℝ => T ^ 2) atTop atTop := tendsto_pow_atTop (by norm_num)
  have hneg : Tendsto (fun T : ℝ => (-(σ ^ 2)) * T ^ 2) atTop atBot :=
    (tendsto_const_mul_atBot_of_neg (f := fun T : ℝ => T ^ 2)
      (by nlinarith [sq_pos_of_pos hσ])).mpr hsq
  have hexp : Tendsto (fun T : ℝ => Real.exp ((-(σ ^ 2)) * T ^ 2)) atTop (nhds 0) :=
    Real.tendsto_exp_atBot.comp hneg
  simpa [neg_mul] using hexp

/-- **Horizontal sides vanish.**  The horizontal integral of `H_c` tends to
zero as `T → ∞`. -/
theorem tendsto_horizontal_integral_zero (c σ x₁ x₂ : ℝ) (hσ : 0 < σ) (hx : x₁ ≤ x₂) :
    Tendsto (fun T : ℝ => ∫ x : ℝ in x₁..x₂,
      gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * I)) atTop (nhds 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  set K : ℝ := (x₂ - x₁) * (2 * Real.pi * σ ^ 2 *
    Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
      max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2))))) with hK
  have hbound : ∀ T : ℝ, ‖∫ x : ℝ in x₁..x₂,
      gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * I)‖ ≤ K * Real.exp (-(σ ^ 2 * T ^ 2)) := by
    intro T
    have h := norm_horizontal_integral_le c σ x₁ x₂ T hσ hx
    rw [hK]
    calc ‖∫ x : ℝ in x₁..x₂, gaussianZeroTest c σ ((x : ℂ) + (T : ℂ) * I)‖
        ≤ (x₂ - x₁) * (2 * Real.pi * σ ^ 2 *
            Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
              Real.exp (-(σ ^ 2 * T ^ 2)) *
                max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2))))) := h
      _ = (x₂ - x₁) * (2 * Real.pi * σ ^ 2 *
            Real.exp (σ ^ 2 * max ((x₁ - 1 / 2) ^ 2) ((x₂ - 1 / 2) ^ 2)) *
              max (Real.exp (-(c * (x₁ - 1 / 2)))) (Real.exp (-(c * (x₂ - 1 / 2))))) *
            Real.exp (-(σ ^ 2 * T ^ 2)) := by ring
  have hlim : Tendsto (fun T : ℝ => K * Real.exp (-(σ ^ 2 * T ^ 2))) atTop (nhds 0) := by
    simpa using (tendsto_exp_neg_sq_zero σ hσ).const_mul K
  exact squeeze_zero (fun T => norm_nonneg _) hbound hlim

/-- **Rectangle limit from its sides.**  If the bottom and top integrals vanish
and the right/left integrals converge to `R`/`L`, the rectangle integral
converges to `I·R − I·L`. -/
theorem tendsto_rectIntegral_of_sides {f : ℂ → ℂ} {x₁ x₂ : ℝ} {R L : ℂ}
    (hbottom : Tendsto (fun T : ℝ => ∫ x : ℝ in x₁..x₂, f ((x : ℂ) + (-T : ℝ) * I))
      atTop (nhds 0))
    (htop : Tendsto (fun T : ℝ => ∫ x : ℝ in x₁..x₂, f ((x : ℂ) + (T : ℝ) * I))
      atTop (nhds 0))
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T, f ((x₂ : ℂ) + (y : ℂ) * I))
      atTop (nhds R))
    (hleft : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T, f ((x₁ : ℂ) + (y : ℂ) * I))
      atTop (nhds L)) :
    Tendsto (fun T : ℝ => rectIntegral f x₁ x₂ (-T) T) atTop (nhds (I * R - I * L)) := by
  unfold rectIntegral
  have h1 : Tendsto (fun T : ℝ =>
      (∫ x : ℝ in x₁..x₂, f ((x : ℂ) + (-T : ℝ) * I)) -
        (∫ x : ℝ in x₁..x₂, f ((x : ℂ) + (T : ℝ) * I))) atTop (nhds (0 - 0)) :=
    hbottom.sub htop
  have h2 : Tendsto (fun T : ℝ => I * (∫ y : ℝ in (-T)..T, f ((x₂ : ℂ) + (y : ℂ) * I)))
      atTop (nhds (I * R)) :=
    tendsto_const_nhds.mul hright
  have h3 : Tendsto (fun T : ℝ => I * (∫ y : ℝ in (-T)..T, f ((x₁ : ℂ) + (y : ℂ) * I)))
      atTop (nhds (I * L)) :=
    tendsto_const_nhds.mul hleft
  have h := (h1.add h2).sub h3
  simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h

/-- **Weighted vertical limit.**  If the log-derivative-weighted Gaussian is
integrable on the vertical line, its truncated integral converges to the full
one as `T → ∞`. -/
theorem tendsto_vertical_integral_logDeriv (c σ x : ℝ) (hσ : 0 < σ)
    (hint : Integrable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) atTop
      (nhds (∫ y : ℝ, logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))) := by
  simpa using intervalIntegral_tendsto_integral
    (f := fun y : ℝ => logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
      gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))
    hint tendsto_neg_atTop_atBot tendsto_id

/-- **Explicit-formula assembly.**  Given the finite contour identity for each
`T`, the vanishing of the bottom/top sides, the convergence of the right/left
sides to `R`/`L`, and the convergence of the zero sum, the infinite explicit
formula holds: `(Zsum − h(0) − h(1))·2πi = I·R − I·L`. -/
theorem explicit_formula_assembly {h : ℂ → ℂ} (S : ℝ → Finset ℂ) (Zsum R L : ℂ)
    (hcontour : ∀ T : ℝ,
      rectIntegral (fun z => logDeriv completedZeta z * h z) (-1) 2 (-T) T =
        ((∑ ρ ∈ S T, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I))
    (hbottom : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * h ((x : ℂ) + (-T : ℝ) * I)) atTop (nhds 0))
    (htop : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * h ((x : ℂ) + (T : ℝ) * I)) atTop (nhds 0))
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) * h (((2 : ℝ) : ℂ) + (y : ℂ) * I)) atTop (nhds R))
    (hleft : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + (y : ℂ) * I) * h (((-1 : ℝ) : ℂ) + (y : ℂ) * I)) atTop (nhds L))
    (hsum : Tendsto (fun T : ℝ => (∑ ρ ∈ S T, h ρ) - h 0 - h 1) atTop
      (nhds (Zsum - h 0 - h 1))) :
    (Zsum - h 0 - h 1) * (2 * (Real.pi : ℂ) * I) = I * R - I * L := by
  have hrect := tendsto_rectIntegral_of_sides (f := fun z => logDeriv completedZeta z * h z)
    (x₁ := -1) (x₂ := 2) hbottom htop hright hleft
  have hrhs : Tendsto (fun T : ℝ => ((∑ ρ ∈ S T, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I))
      atTop (nhds ((Zsum - h 0 - h 1) * (2 * (Real.pi : ℂ) * I))) :=
    hsum.mul_const _
  have hcongr : (fun T : ℝ => rectIntegral (fun z => logDeriv completedZeta z * h z) (-1) 2 (-T) T) =
      fun T : ℝ => ((∑ ρ ∈ S T, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I) :=
    funext hcontour
  rw [hcongr] at hrect
  exact tendsto_nhds_unique hrhs hrect

/-- The explicit-formula assembly specialised to the Gaussian test function
`H_c`. -/
theorem explicit_formula_gaussianZeroTest (c σ : ℝ) (S : ℝ → Finset ℂ) (Zsum R L : ℂ)
    (hcontour : ∀ T : ℝ,
      rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) (-1) 2 (-T) T =
        ((∑ ρ ∈ S T, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
          (2 * (Real.pi : ℂ) * I))
    (hbottom : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (-T : ℝ) * I))
      atTop (nhds 0))
    (htop : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (T : ℝ) * I))
      atTop (nhds 0))
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) * gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds R))
    (hleft : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + (y : ℂ) * I) * gaussianZeroTest c σ (((-1 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds L))
    (hsum : Tendsto (fun T : ℝ =>
      (∑ ρ ∈ S T, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) atTop
      (nhds (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1))) :
    (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) * (2 * (Real.pi : ℂ) * I) =
      I * R - I * L :=
  explicit_formula_assembly S Zsum R L hcontour hbottom htop hright hleft hsum

/-- **Right-side limit identified.**  If the right-side integral and its
archimedean/prime pieces converge, the right-side limit is
`−Arch·I − Prime·I`. -/
theorem right_limit_eq_arch_prime (c σ : ℝ) (hσ : 0 < σ) (R Arch Prime : ℂ)
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I) * I) atTop (nhds R))
    (harch : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((((2 : ℝ) : ℂ) + (y : ℂ) * I) / 2)) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) atTop (nhds Arch))
    (hprime : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) atTop (nhds Prime)) :
    R = - (Arch * I) - (Prime * I) := by
  have harchI : Tendsto (fun T : ℝ => (∫ y : ℝ in (-T)..T,
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((((2 : ℝ) : ℂ) + (y : ℂ) * I) / 2)) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) * I) atTop (nhds (Arch * I)) :=
    harch.mul_const I
  have hprimeI : Tendsto (fun T : ℝ => (∫ y : ℝ in (-T)..T,
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) * I) atTop (nhds (Prime * I)) :=
    hprime.mul_const I
  have hrhs : Tendsto (fun T : ℝ => - ((∫ y : ℝ in (-T)..T,
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((((2 : ℝ) : ℂ) + (y : ℂ) * I) / 2)) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) * I) -
      ((∫ y : ℝ in (-T)..T,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
          gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) * I))
      atTop (nhds (- (Arch * I) - (Prime * I))) :=
    harchI.neg.sub hprimeI
  have hcontour : (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I) * I) =
      fun T : ℝ => - ((∫ y : ℝ in (-T)..T,
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((((2 : ℝ) : ℂ) + (y : ℂ) * I) / 2)) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) * I) -
      ((∫ y : ℝ in (-T)..T,
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
          gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) * I) :=
    funext fun T => integral_logDeriv_gaussianZeroTest_right_side' c σ 2 (-T) T (by norm_num)
  rw [hcontour] at hright
  exact tendsto_nhds_unique hright hrhs

/-- **Left-side limit identified.**  The left-side limit is `Arch·I + Prime·I`
where `Arch`/`Prime` are the limits for `H_{−c}`. -/
theorem left_limit_eq_arch_prime (c σ : ℝ) (hσ : 0 < σ) (Rneg L Arch Prime : ℂ)
    (hleft : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((-1 : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((-1 : ℂ) + (y : ℂ) * I) * I) atTop (nhds L))
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest (-c) σ (((2 : ℝ) : ℂ) + (y : ℂ) * I) * I) atTop (nhds Rneg))
    (harch : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((((2 : ℝ) : ℂ) + (y : ℂ) * I) / 2)) *
        gaussianZeroTest (-c) σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) atTop (nhds Arch))
    (hprime : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest (-c) σ (((2 : ℝ) : ℂ) + (y : ℂ) * I)) atTop (nhds Prime)) :
    L = Arch * I + Prime * I := by
  have hRneg : Rneg = - (Arch * I) - (Prime * I) :=
    right_limit_eq_arch_prime (-c) σ hσ Rneg Arch Prime hright harch hprime
  have hleft_eq_fun : (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((-1 : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((-1 : ℂ) + (y : ℂ) * I) * I) =
      fun T : ℝ => - (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
          gaussianZeroTest (-c) σ (((2 : ℝ) : ℂ) + (y : ℂ) * I) * I) :=
    funext fun T => integral_logDeriv_gaussianZeroTest_left_eq_neg_right c σ T
  have hright' : Tendsto (fun T : ℝ => - (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest (-c) σ (((2 : ℝ) : ℂ) + (y : ℂ) * I) * I)) atTop (nhds (-Rneg)) :=
    hright.neg
  rw [hleft_eq_fun] at hleft
  have hL : L = -Rneg := tendsto_nhds_unique hleft hright'
  rw [hL, hRneg]
  ring

/-- The Gaussian sequence `exp(−σ²n²)` is summable; the model decay for the
zero-sum tail. -/
theorem summable_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) :
    Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (n : ℝ) ^ 2))) := by
  have hgeo : Summable (fun n : ℕ => (Real.exp (-(σ ^ 2))) ^ n) := by
    apply summable_geometric_of_norm_lt_one
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]
    linarith [sq_pos_of_pos hσ]
  apply Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) ?_ hgeo
  intro n
  rw [← Real.exp_nat_mul]
  apply Real.exp_le_exp.mpr
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hsq : (n : ℝ) ≤ (n : ℝ) ^ 2 := by
    rcases Nat.eq_zero_or_pos n with hn0 | hnpos
    · subst n
      norm_num
    · have h1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hnpos
      nlinarith [sq_nonneg ((n : ℝ) - 1)]
  nlinarith [sq_pos_of_pos hσ]

/-- **Gaussian summability from a linear zero bound.**  If `|γ n| ≥ c·n` with
`c > 0`, then `∑ exp(−σ²γ_n²)` converges.  This is the zero-counting input for
the Gaussian tail. -/
theorem summable_exp_neg_sq_of_abs_ge (γ : ℕ → ℝ) (c σ : ℝ) (hc : 0 < c) (hσ : 0 < σ)
    (hγ : ∀ n : ℕ, c * (n : ℝ) ≤ |γ n|) :
    Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (γ n) ^ 2))) := by
  have hbase : Summable (fun n : ℕ => Real.exp (-(((σ * c) ^ 2) * (n : ℝ) ^ 2))) :=
    summable_exp_neg_sq (σ * c) (mul_pos hσ hc)
  apply Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) ?_ hbase
  intro n
  apply Real.exp_le_exp.mpr
  have hcn : (0 : ℝ) ≤ c * (n : ℝ) := mul_nonneg hc.le (Nat.cast_nonneg n)
  have hsq : (c * (n : ℝ)) ^ 2 ≤ (γ n) ^ 2 := by
    nlinarith [abs_nonneg (γ n), hγ n, sq_abs (γ n)]
  have hmul : σ ^ 2 * (c * (n : ℝ)) ^ 2 ≤ σ ^ 2 * (γ n) ^ 2 :=
    mul_le_mul_of_nonneg_left hsq (sq_nonneg σ)
  have heq : ((σ * c) ^ 2) * (n : ℝ) ^ 2 = σ ^ 2 * (c * (n : ℝ)) ^ 2 := by ring
  rw [heq]
  linarith

/-- **The zero-tail summability input.**  A named `Prop` for the convergence
of the Gaussian-weighted zero tail; the remaining analytic input for W3. -/
def ZeroTailSummable (γ : ℕ → ℝ) (σ : ℝ) : Prop :=
  Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (γ n) ^ 2)))

/-- The named zero-tail input is exactly summability of the Gaussian weights. -/
theorem zeroTailSummable_iff (γ : ℕ → ℝ) (σ : ℝ) :
    ZeroTailSummable γ σ ↔ Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * (γ n) ^ 2))) :=
  Iff.rfl

/-- **Inverse-square comparison.**  A sequence eventually bounded by `1/n²` is
summable; the comparison tool for the sublinear zero tail. -/
theorem summable_of_eventually_le_inv_sq {f : ℕ → ℝ}
    (h : ∀ᶠ n : ℕ in atTop, ‖f n‖ ≤ 1 / (n : ℝ) ^ 2) : Summable f := by
  apply Summable.of_norm_bounded_eventually (g := fun n : ℕ => 1 / (n : ℝ) ^ 2)
  · exact (Real.summable_one_div_nat_pow (p := 2)).mpr (by norm_num)
  · simpa [Nat.cofinite_eq_atTop] using h

/-- The inverse-square series `∑ 1/n²` converges. -/
theorem summable_inv_sq : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) :=
  (Real.summable_one_div_nat_pow (p := 2)).mpr (by norm_num)

/-- **Sublinear zero-tail reduction.**  If the Gaussian weight is eventually
bounded by `1/n²` (the `n/log n` zero-growth model), the tail is summable. -/
theorem summable_exp_neg_div_log_sq_of_le (σ : ℝ)
    (h : ∀ᶠ n : ℕ in atTop,
      Real.exp (-(σ ^ 2 * ((n : ℝ) / Real.log n) ^ 2)) ≤ 1 / (n : ℝ) ^ 2) :
    Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * ((n : ℝ) / Real.log n) ^ 2))) := by
  apply summable_of_eventually_le_inv_sq
  filter_upwards [h] with n hn
  rwa [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]

/-- The log-cube grows slower than the square: `(log x)³ / x² → 0`; the growth
input for the sublinear zero-tail domination. -/
theorem tendsto_log_cube_div_sq_zero :
    Tendsto (fun x : ℝ => Real.log x ^ 3 / x ^ 2) atTop (nhds 0) := by
  have h1 : Tendsto (fun x : ℝ => Real.log x ^ 3 / x) atTop (nhds 0) := by
    simpa using Real.tendsto_pow_log_div_mul_add_atTop 1 0 3 one_ne_zero
  have h2 := h1.div_atTop (tendsto_id : Tendsto (fun x : ℝ => x) atTop atTop)
  simpa [div_div, pow_two] using h2

/-- **Sublinear domination.**  Eventually the Gaussian weight is bounded by
`1/n²` in the `n/log n` zero-growth model. -/
theorem eventually_exp_neg_div_log_sq_le_inv_sq (σ : ℝ) (hσ : 0 < σ) :
    ∀ᶠ n : ℕ in atTop,
      Real.exp (-(σ ^ 2 * ((n : ℝ) / Real.log n) ^ 2)) ≤ 1 / (n : ℝ) ^ 2 := by
  have hlim : Tendsto (fun n : ℕ => Real.log (n : ℝ) ^ 3 / (n : ℝ) ^ 2) atTop (nhds 0) :=
    tendsto_log_cube_div_sq_zero.comp tendsto_natCast_atTop_atTop
  have hev : ∀ᶠ n : ℕ in atTop, Real.log (n : ℝ) ^ 3 / (n : ℝ) ^ 2 < σ ^ 2 / 2 :=
    (tendsto_order.1 hlim).2 _ (by positivity)
  filter_upwards [hev, eventually_ge_atTop 2] with n hn hge
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hge
  have hnpos : (0 : ℝ) < (n : ℝ) := by linarith
  have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by linarith)
  have hbound : 2 * (Real.log (n : ℝ)) ^ 3 ≤ σ ^ 2 * (n : ℝ) ^ 2 := by
    have h1 : Real.log (n : ℝ) ^ 3 ≤ (σ ^ 2 / 2) * (n : ℝ) ^ 2 := by
      have h2 := (div_lt_iff₀ (by positivity : (0 : ℝ) < (n : ℝ) ^ 2)).mp hn
      linarith
    nlinarith
  have hineq : 2 * Real.log (n : ℝ) ≤ σ ^ 2 * ((n : ℝ) / Real.log (n : ℝ)) ^ 2 := by
    field_simp [hlog.ne']
    nlinarith [hbound]
  calc Real.exp (-(σ ^ 2 * ((n : ℝ) / Real.log (n : ℝ)) ^ 2))
      ≤ Real.exp (-(2 * Real.log (n : ℝ))) := by
        apply Real.exp_le_exp.mpr
        linarith
    _ = 1 / (n : ℝ) ^ 2 := by
        rw [show -(2 * Real.log (n : ℝ)) = -Real.log ((n : ℝ) ^ 2) by
          rw [Real.log_pow]
          push_cast
          ring]
        rw [Real.exp_neg, Real.exp_log (by positivity : (0 : ℝ) < (n : ℝ) ^ 2)]
        simp

/-- **Sublinear zero-tail summability.**  In the `n/log n` zero-growth model the
Gaussian tail is summable, unconditionally. -/
theorem summable_exp_neg_div_log_sq (σ : ℝ) (hσ : 0 < σ) :
    Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * ((n : ℝ) / Real.log n) ^ 2))) :=
  summable_exp_neg_div_log_sq_of_le σ (eventually_exp_neg_div_log_sq_le_inv_sq σ hσ)

/-- **Zero-tail summability from log growth.**  If `|γ n| ≥ c·n/log n`
eventually, the Gaussian zero tail is summable; the remaining input is exactly
the zero-counting lower bound. -/
theorem zeroTailSummable_of_ge_div_log (γ : ℕ → ℝ) (σ c : ℝ) (hc : 0 < c) (hσ : 0 < σ)
    (hγ : ∀ᶠ n : ℕ in atTop, c * (n : ℝ) / Real.log n ≤ |γ n|) :
    ZeroTailSummable γ σ := by
  unfold ZeroTailSummable
  apply Summable.of_norm_bounded_eventually
    (g := fun n : ℕ => Real.exp (-((σ * c) ^ 2 * ((n : ℝ) / Real.log n) ^ 2)))
  · exact summable_exp_neg_div_log_sq (σ * c) (mul_pos hσ hc)
  · have h : ∀ᶠ n : ℕ in atTop,
        ‖Real.exp (-(σ ^ 2 * (γ n) ^ 2))‖ ≤
          Real.exp (-((σ * c) ^ 2 * ((n : ℝ) / Real.log n) ^ 2)) := by
      filter_upwards [hγ, eventually_ge_atTop 2] with n hn hge
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      apply Real.exp_le_exp.mpr
      have hn2 : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hge
      have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by linarith)
      have hcn : (0 : ℝ) ≤ c * (n : ℝ) / Real.log n := by positivity
      have hsq : (c * (n : ℝ) / Real.log n) ^ 2 ≤ (γ n) ^ 2 := by
        nlinarith [abs_nonneg (γ n), hn, sq_abs (γ n)]
      have hmul : σ ^ 2 * (c * (n : ℝ) / Real.log n) ^ 2 ≤ σ ^ 2 * (γ n) ^ 2 :=
        mul_le_mul_of_nonneg_left hsq (sq_nonneg σ)
      have heq : (σ * c) ^ 2 * ((n : ℝ) / Real.log n) ^ 2 =
          σ ^ 2 * (c * (n : ℝ) / Real.log n) ^ 2 := by ring
      rw [heq]
      linarith
    simpa [Nat.cofinite_eq_atTop] using h

/-- **The vertical log-derivative integrability input.**  Names the remaining
analytic hypothesis that `(Z'/Z)·H_c` is integrable on a vertical line. -/
def VerticalLogDerivIntegrable (c σ x : ℝ) : Prop :=
  Integrable (fun y : ℝ => logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
    gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I))

/-- The named input is exactly the integrability statement. -/
theorem verticalLogDerivIntegrable_iff (c σ x : ℝ) :
    VerticalLogDerivIntegrable c σ x ↔
      Integrable (fun y : ℝ => logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) :=
  Iff.rfl

/-- **The W4 zero-density input.**  Names the entrywise bound of the full
zero-side 2×2 block by the isolated off-line quadruple block. -/
def FullBlockWithin (t00 t01 t10 t11 S0 Sc B : ℝ) : Prop :=
  |t00 - S0| ≤ B ∧ |t01 - Sc| ≤ B ∧ |t10 - Sc| ≤ B ∧ |t11 - S0| ≤ B

/-- The conditional domination theorem stated through `FullBlockWithin`. -/
theorem offLineQuad_fullBlock_not_posSemidef_of_within
    (c σ δ γ B t00 t01 t10 t11 : ℝ) (hB : 0 ≤ B)
    (hwithin : FullBlockWithin t00 t01 t10 t11
      (offLineQuad 0 σ δ γ).re (offLineQuad c σ δ γ).re B)
    (hdom : (offLineQuad 0 σ δ γ).re - (offLineQuad c σ δ γ).re + 2 * B < 0) :
    ¬ (!![t00, t01; t10, t11]).PosSemidef :=
  offLineQuad_fullBlock_not_posSemidef c σ δ γ B t00 t01 t10 t11 hB hdom
    hwithin.1 hwithin.2.1 hwithin.2.2.1 hwithin.2.2.2

/-- **Capstone: the Gaussian explicit formula in archimedean/prime form.**
Given the contour data and the archimedean/prime limits, the zero sum equals the
archimedean and prime contributions:
`(Zsum − H_c(0) − H_c(1))·2πi = I·(−ArchR − PrimeR) − I·(ArchL + PrimeL)`. -/
theorem explicit_formula_gaussianZeroTest_arch_prime
    (c σ : ℝ) (hσ : 0 < σ) (S : ℝ → Finset ℂ) (Zsum ArchR PrimeR ArchL PrimeL : ℂ)
    (hcontour : ∀ T : ℝ,
      rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) (-1) 2 (-T) T =
        ((∑ ρ ∈ S T, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
          (2 * (Real.pi : ℂ) * I))
    (hbottom : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (-T : ℝ) * I))
      atTop (nhds 0))
    (htop : Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (T : ℝ) * I))
      atTop (nhds 0))
    (hright : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) * gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds (- ArchR - PrimeR)))
    (hleft : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + (y : ℂ) * I) * gaussianZeroTest c σ (((-1 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds (ArchL + PrimeL)))
    (hsum : Tendsto (fun T : ℝ =>
      (∑ ρ ∈ S T, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) atTop
      (nhds (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1))) :
    (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) * (2 * (Real.pi : ℂ) * I) =
      I * (- ArchR - PrimeR) - I * (ArchL + PrimeL) :=
  explicit_formula_gaussianZeroTest c σ S Zsum _ _ hcontour hbottom htop hright hleft hsum

/-- **Rank-one factorization on the critical line.**
`H_{a−b}(1/2+it) = φ_a(t) · conj φ_b(t)`. -/
theorem gaussianZeroTest_eq_mode_mul (a b σ t : ℝ) :
    gaussianZeroTest (a - b) σ ((1 / 2 : ℂ) + (t : ℂ) * I) =
      gaussianMode a σ t * starRingEnd ℂ (gaussianMode b σ t) := by
  rw [gaussianZeroTest_critical_line, star_gaussianMode]
  unfold gaussianMode
  have hsqrt : Real.sqrt (2 * Real.pi) * Real.sqrt (2 * Real.pi) = 2 * Real.pi := by
    rw [← sq]
    exact Real.sq_sqrt (by positivity)
  have hsq : ((σ * Real.sqrt (2 * Real.pi) : ℝ) : ℂ) *
        ((σ * Real.sqrt (2 * Real.pi) : ℝ) : ℂ) =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) := by
    have h : (σ * Real.sqrt (2 * Real.pi)) * (σ * Real.sqrt (2 * Real.pi)) =
        2 * Real.pi * σ ^ 2 := by
      calc (σ * Real.sqrt (2 * Real.pi)) * (σ * Real.sqrt (2 * Real.pi))
          = σ ^ 2 * (Real.sqrt (2 * Real.pi) * Real.sqrt (2 * Real.pi)) := by ring
        _ = σ ^ 2 * (2 * Real.pi) := by rw [hsqrt]
        _ = 2 * Real.pi * σ ^ 2 := by ring
    exact_mod_cast h
  have h1 : Complex.exp (-(((σ ^ 2 * t ^ 2 : ℝ)) : ℂ) / 2) *
        Complex.exp (-(((σ ^ 2 * t ^ 2 : ℝ)) : ℂ) / 2) =
      Complex.exp (-(((σ ^ 2 * t ^ 2 : ℝ)) : ℂ)) := by
    rw [← Complex.exp_add]
    congr 1
    ring
  have h2 : Complex.exp (-(((a * t : ℝ)) : ℂ) * I) *
        Complex.exp ((((b * t : ℝ)) : ℂ) * I) =
      Complex.exp (-(((a - b) * t : ℝ) : ℂ) * I) := by
    rw [← Complex.exp_add]
    congr 1
    push_cast
    ring
  rw [← hsq, ← h1, ← h2]
  ring

/-- The real cosine mode. -/
def gaussianCosMode (a σ γ : ℝ) : ℝ :=
  Real.sqrt (2 * Real.pi) * σ * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.cos (a * γ)

/-- The real sine mode. -/
def gaussianSinMode (a σ γ : ℝ) : ℝ :=
  Real.sqrt (2 * Real.pi) * σ * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.sin (a * γ)

/-- **The real rank-one identity.**  One critical-line zero frequency contributes
`2πσ² exp(−σ²γ²) cos((a−b)γ)` to the Gram entry, and this is the sum of the
cosine and sine mode products. -/
theorem zeroSideGramReal_term (a b σ γ : ℝ) :
    2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) * Real.cos ((a - b) * γ) =
      gaussianCosMode a σ γ * gaussianCosMode b σ γ +
        gaussianSinMode a σ γ * gaussianSinMode b σ γ := by
  unfold gaussianCosMode gaussianSinMode
  have hsqrt : Real.sqrt (2 * Real.pi) * Real.sqrt (2 * Real.pi) = 2 * Real.pi := by
    rw [← sq]
    exact Real.sq_sqrt (by positivity)
  have hexp : Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) =
      Real.exp (-(σ ^ 2 * γ ^ 2)) := by
    rw [← Real.exp_add]
    congr 1
    ring
  calc 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) *
        Real.cos ((a - b) * γ)
      = 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) *
          (Real.cos (a * γ) * Real.cos (b * γ) + Real.sin (a * γ) * Real.sin (b * γ)) := by
        rw [sub_mul, Real.cos_sub]
    _ = (Real.sqrt (2 * Real.pi) * Real.sqrt (2 * Real.pi)) * (σ * σ) *
          (Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.exp (-(σ ^ 2 * γ ^ 2) / 2)) *
            (Real.cos (a * γ) * Real.cos (b * γ) + Real.sin (a * γ) * Real.sin (b * γ)) := by
        rw [hsqrt, hexp]
        ring
    _ = (Real.sqrt (2 * Real.pi) * σ * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.cos (a * γ)) *
          (Real.sqrt (2 * Real.pi) * σ * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.cos (b * γ)) +
        (Real.sqrt (2 * Real.pi) * σ * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.sin (a * γ)) *
          (Real.sqrt (2 * Real.pi) * σ * Real.exp (-(σ ^ 2 * γ ^ 2) / 2) * Real.sin (b * γ)) := by
        ring

/-- **The zero-side Gram matrix is PSD.**  For a finite family of critical-line
frequencies `γ_k`, the real matrix `G_{ij} = Σ_k 2πσ² exp(−σ²γ_k²) cos((a_i−a_j)γ_k)`
is positive semidefinite.  The proof writes it as `L·Lᵀ + M·Mᵀ` with
`L i k = cosMode (a_i) σ γ_k` and `M i k = sinMode (a_i) σ γ_k`. -/
theorem zeroSideGramReal_posSemidef {κ ι : Type*} [Fintype κ] [Fintype ι] [DecidableEq κ]
    (a : κ → ℝ) (σ : ℝ) (γ : ι → ℝ) :
    (Matrix.of fun i j =>
      ∑ k, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ k ^ 2)) *
        Real.cos ((a i - a j) * γ k)).PosSemidef := by
  classical
  let L : Matrix κ ι ℝ := fun i k => gaussianCosMode (a i) σ (γ k)
  let M : Matrix κ ι ℝ := fun i k => gaussianSinMode (a i) σ (γ k)
  have hG : (Matrix.of fun i j =>
      ∑ k, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ k ^ 2)) *
        Real.cos ((a i - a j) * γ k)) = L * Matrix.transpose L + M * Matrix.transpose M := by
    ext i j
    simp only [Matrix.add_apply, Matrix.of_apply, Matrix.transpose_apply, Matrix.mul_apply]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro k _
    simpa [L, M] using zeroSideGramReal_term (a i) (a j) σ (γ k)
  rw [hG]
  have hL : (L * Matrix.transpose L).PosSemidef := by
    simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using
      Matrix.posSemidef_self_mul_conjTranspose L
  have hM : (M * Matrix.transpose M).PosSemidef := by
    simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using
      Matrix.posSemidef_self_mul_conjTranspose M
  exact hL.add hM

/-- **The formal zero-side positivity statement.**  Every finite family of
critical-line frequencies gives a positive-semidefinite real zero-side Gram
matrix.  This is the named `Prop` that the bridge aims to identify with the
arithmetic side. -/
def ZeroSideWeilPositivity : Prop :=
  ∀ (n m : ℕ) (a : Fin n → ℝ) (σ : ℝ) (γ : Fin m → ℝ),
    (Matrix.of fun i j =>
      ∑ k, 2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ k ^ 2)) *
        Real.cos ((a i - a j) * γ k)).PosSemidef

/-- The zero-side positivity statement is proved for finite critical-line
frequency families. -/
theorem zeroSideWeilPositivity : ZeroSideWeilPositivity := by
  intro n m a σ γ
  exact zeroSideGramReal_posSemidef a σ γ

end AbsoluteHodgeExplicitFormula