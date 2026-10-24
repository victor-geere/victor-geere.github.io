/-
  Explicit.lean — the algebraic layer of rh45: the explicit formula's skeleton.

  Round rh45 attacks the gap left by rh044 by using the *explicit formula* rather
  than trying to smooth a partial sum.  This file isolates the part of that
  formula which is pure finite algebra, with no analysis and no complex
  function theory.  Concretely, for a test function (the "transform") `F : ℝ → ℝ`,
  an imaginary-part sequence `γ : ℕ → ℝ` and a prime-side weight `g : ℝ → ℝ`, we
  study the three pieces of Riemann–von Mangoldt,

      zeroSum F γ N    = ∑_{k < N} F (1/2 + γ k)                  (the zero side),
      polePair F       = F (1/2 + 1/2) + F (1/2 - 1/2)            (the poles s = 1, 0),
      primeSide g nmax = ∑_{n=2}^{nmax} (Λ n / √n) (g (log n) + g (-log n)),

  where `Λ` is Mathlib's von Mangoldt function `ArithmeticFunction.vonMangoldt`.
  The file records exactly the algebraic facts that the numerical side of the
  round uses:

  * the two kernels of the round — the Cauchy kernel `cauchyKernel t = 1/(1/4+t²)`
    and the Gaussian `gaussKernel t = exp (-(t²)/2)` — are even and strictly
    positive (`cauchyKernel_even`, `cauchyKernel_pos`, `gaussKernel_even`,
    `gaussKernel_pos`), with the exact special values `cauchyKernel 0 = 4`,
    `cauchyKernel (1/2) = 2` (`cauchyKernel_value`), and the shifted kernels
    `s ↦ cauchyKernel (s - 1/2)`, `s ↦ gaussKernel (s - 1/2)` are symmetric about
    `s = 1/2` (`cauchyKernel_symm_about_half`, `gaussKernel_symm_about_half`).
    The literal reading `cauchyKernel (1 - x) = cauchyKernel x` is *false* (the
    kernels live on the imaginary part `t`, not on the spectral variable `s`); the
    file records the counterexample `cauchyKernel_not_symm_about_half` and proves
    the correct shifted statement instead.
  * the pole pair collapses to a single term for a transform even about `1/2`:
    `F (1 - x) = F x → polePair F = 2 * F (1/2 + 1/2)` (`polePair_eq`).  This is
    the algebraic core of "the pole `s = 1` contributes one term".
  * the prime side splits into its `+log` and `-log` halves
    (`primeSide_split`), and for an even `g` the two halves are equal, so the
    prime side is twice its `+log` half (`primeSide_even`).
  * the smoothed count is monotone and non-negative for a non-negative transform
    (`zeroSum_mono`, `zeroSum_le_of_le`, `zeroSum_nonneg`).
  * Mathlib has no Riemann–von Mangoldt statement; what it does have is
    `riemannZetaZeros` with `IsCompact.inter_riemannZetaZeros_finite` (finitely
    many zeros in any compact set), restated here as
    `riemannZetaZeros_finite_in_compact`.  The classical *main term* of the zero
    counting function is then stated and proved independently of any analysis:
    `vonMangoldtMain T = (T/2π) log (T/(2πe)) + 7/8`, with the rewrite
    `vonMangoldtMain_eq` that pins the constant `7/8`:
    `vonMangoldtMain T = (T/2π) log (T/2π) - T/2π + 7/8` for `T > 0`.
  * the elementary integral behind the Cauchy kernel: the one-sided
    `∫_0^∞ e^{-u/2} cos (t u) du = 2/(1 + 4t²)` (`integral_exp_neg_half_mul_cos`),
    its Cauchy-kernel form `= cauchyKernel t / 2`
    (`integral_exp_neg_half_mul_cos_eq`), and the honest two-sided Fourier pairing
    `∫_ℝ expWeight u · cos (t u) du = (π/2) · cauchyKernel t`
    (`integral_expWeight_mul_cos`).  The brief's literal Laplace statement at
    `s = 1/2 + it` is divergent (see the docstring of
    `integral_exp_neg_half_mul_cos`) and is *not* asserted.

  Everything below is proved from Mathlib alone; there is no `sorry`, no extra
  axiom and no computation by reflection.
-/
import Mathlib

namespace Rh45

noncomputable section

open scoped BigOperators
open scoped ArithmeticFunction.vonMangoldt

/-! ## 1. The Cauchy and Gaussian kernels -/

/-- The Cauchy kernel `1 / (1/4 + t²)` of the round.  As a function of the
spectral variable `s` it is the shifted / inverted kernel `1/(s(1-s))` evaluated
at `s = 1/2 + t`: `cauchyKernel t = 1/((1/2+it)(1/2-it))`. -/
noncomputable def cauchyKernel (t : ℝ) : ℝ := 1 / (1 / 4 + t ^ 2)

/-- The Gaussian kernel `exp (-(t²)/2)`. -/
noncomputable def gaussKernel (t : ℝ) : ℝ := Real.exp (-(t ^ 2) / 2)

/-- The defining equation of `cauchyKernel`, for rewriting. -/
theorem cauchyKernel_def (t : ℝ) : cauchyKernel t = 1 / (1 / 4 + t ^ 2) := rfl

/-- The defining equation of `gaussKernel`, for rewriting. -/
theorem gaussKernel_def (t : ℝ) : gaussKernel t = Real.exp (-(t ^ 2) / 2) := rfl

/-- **Evenness of the Cauchy kernel.** -/
theorem cauchyKernel_even (t : ℝ) : cauchyKernel (-t) = cauchyKernel t := by
  rw [cauchyKernel_def, cauchyKernel_def, neg_sq]

/-- **Evenness of the Gaussian kernel.** -/
theorem gaussKernel_even (t : ℝ) : gaussKernel (-t) = gaussKernel t := by
  rw [gaussKernel_def, gaussKernel_def, neg_sq]

/-- **Strict positivity of the Cauchy kernel.**  The denominator is
`1/4 + t² ≥ 1/4 > 0`. -/
theorem cauchyKernel_pos (t : ℝ) : 0 < cauchyKernel t := by
  rw [cauchyKernel_def]
  exact one_div_pos.mpr (by nlinarith [sq_nonneg t])

/-- **Strict positivity of the Gaussian kernel.** -/
theorem gaussKernel_pos (t : ℝ) : 0 < gaussKernel t := by
  rw [gaussKernel_def]
  exact Real.exp_pos _

/-- Non-negativity of the Cauchy kernel. -/
theorem cauchyKernel_nonneg (t : ℝ) : 0 ≤ cauchyKernel t := (cauchyKernel_pos t).le

/-- Non-negativity of the Gaussian kernel. -/
theorem gaussKernel_nonneg (t : ℝ) : 0 ≤ gaussKernel t := (gaussKernel_pos t).le

/-- The Cauchy kernel as a function of the *spectral* variable `s`: the shift
`s ↦ cauchyKernel (s - 1/2)` places the point `s = 1/2 + t` over `t`.  This is the
object for which the symmetry `s ↔ 1 - s` of the explicit formula holds. -/
noncomputable def cauchyKernelAt (s : ℝ) : ℝ := cauchyKernel (s - 1 / 2)

/-- The Gaussian kernel as a function of the spectral variable `s`. -/
noncomputable def gaussKernelAt (s : ℝ) : ℝ := gaussKernel (s - 1 / 2)

/-- The defining equation of `cauchyKernelAt`. -/
theorem cauchyKernelAt_def (s : ℝ) : cauchyKernelAt s = cauchyKernel (s - 1 / 2) := rfl

/-- The defining equation of `gaussKernelAt`. -/
theorem gaussKernelAt_def (s : ℝ) : gaussKernelAt s = gaussKernel (s - 1 / 2) := rfl

/-- **The `s ↔ 1 - s` symmetry, Cauchy kernel.**  Because `1 - s - 1/2 = -(s - 1/2)`
and the kernel is even, the shifted Cauchy kernel is symmetric about `s = 1/2`.

This is the correct form of the brief's `cauchyKernel_symm_about_half`.  The
literal statement `cauchyKernel (1 - x) = cauchyKernel x` is not true: see
`cauchyKernel_not_symm_about_half`. -/
theorem cauchyKernel_symm_about_half (s : ℝ) : cauchyKernelAt (1 - s) = cauchyKernelAt s := by
  rw [cauchyKernelAt_def, cauchyKernelAt_def,
    show 1 - s - 1 / 2 = -(s - 1 / 2) by ring, cauchyKernel_even]

/-- **The `s ↔ 1 - s` symmetry, Gaussian kernel.** -/
theorem gaussKernel_symm_about_half (s : ℝ) : gaussKernelAt (1 - s) = gaussKernelAt s := by
  rw [gaussKernelAt_def, gaussKernelAt_def,
    show 1 - s - 1 / 2 = -(s - 1 / 2) by ring, gaussKernel_even]

/-! ## 2. The exact values of the Cauchy kernel -/

/-- `cauchyKernel 0 = 4`. -/
theorem cauchyKernel_zero : cauchyKernel 0 = 4 := by
  rw [cauchyKernel_def]; norm_num

/-- `cauchyKernel (1/2) = 2`. -/
theorem cauchyKernel_half : cauchyKernel (1 / 2) = 2 := by
  rw [cauchyKernel_def]; norm_num

/-- `cauchyKernel (3/4) = 16/13`.

The brief's value `16/25` is the value of the *other* natural normalisation
`1/(1 + t²)` at `t = 3/4`; for the kernel `1/(1/4 + t²)` used throughout this
development one has `1/4 + (3/4)² = 13/16`, hence `16/13`. -/
theorem cauchyKernel_three_quarters : cauchyKernel (3 / 4) = 16 / 13 := by
  rw [cauchyKernel_def]; norm_num

/-- The exact values of the Cauchy kernel used by the numerics, collected. -/
theorem cauchyKernel_value :
    cauchyKernel 0 = 4 ∧ cauchyKernel (1 / 2) = 2 ∧ cauchyKernel (3 / 4) = 16 / 13 :=
  ⟨cauchyKernel_zero, cauchyKernel_half, cauchyKernel_three_quarters⟩

/-- `cauchyKernel 1 = 4/5`. -/
theorem cauchyKernel_one : cauchyKernel 1 = 4 / 5 := by
  rw [cauchyKernel_def]; norm_num

/-- **The literal symmetry `cauchyKernel (1 - x) = cauchyKernel x` is false.**  At
`x = 0` it would say `cauchyKernel 1 = cauchyKernel 0`, i.e. `4/5 = 4`.  The
kernels are functions of the imaginary part `t = Im s`; the symmetry `s ↔ 1 - s`
is the symmetry of the *shifted* kernels about `s = 1/2`
(`cauchyKernel_symm_about_half`), equivalently the evenness in `t`. -/
theorem cauchyKernel_not_symm_about_half : cauchyKernel (1 - 0) ≠ cauchyKernel 0 := by
  rw [sub_zero, cauchyKernel_one, cauchyKernel_zero]
  norm_num

/-- The analogous false statement for the Gaussian kernel: `gaussKernel 1 ≠ gaussKernel 0`. -/
theorem gaussKernel_not_symm_about_half : gaussKernel (1 - 0) ≠ gaussKernel 0 := by
  rw [sub_zero, gaussKernel_def, gaussKernel_def]
  intro h
  have h' : -(1 : ℝ) ^ 2 / 2 = -(0 : ℝ) ^ 2 / 2 := Real.exp_injective h
  norm_num at h'

/-! ## 3. The two-sided exponential weight -/

/-- The two-sided exponential weight `(π/2) exp (-|u|/2)` of the round. -/
noncomputable def expWeight (u : ℝ) : ℝ := (Real.pi / 2) * Real.exp (-|u| / 2)

/-- The defining equation of `expWeight`, for rewriting. -/
theorem expWeight_def (u : ℝ) : expWeight u = (Real.pi / 2) * Real.exp (-|u| / 2) := rfl

/-- **Evenness of the exponential weight.** -/
theorem expWeight_even (u : ℝ) : expWeight (-u) = expWeight u := by
  rw [expWeight_def, expWeight_def, abs_neg]

/-- **Strict positivity of the exponential weight.** -/
theorem expWeight_pos (u : ℝ) : 0 < expWeight u := by
  rw [expWeight_def]
  exact mul_pos (by positivity) (Real.exp_pos _)

/-- Non-negativity of the exponential weight. -/
theorem expWeight_nonneg (u : ℝ) : 0 ≤ expWeight u := (expWeight_pos u).le

/-- **The value at the origin:** `expWeight 0 = π/2`. -/
theorem expWeight_at_zero : expWeight 0 = Real.pi / 2 := by
  rw [expWeight_def]
  simp

/-! ## 4. The pole pair -/

/-- The pole pair `F (1/2 + 1/2) + F (1/2 - 1/2) = F 1 + F 0`: the two pole
contributions `s = 1` and `s = 0` of the explicit formula, for a transform `F`
viewed as a function of the spectral variable `s`. -/
noncomputable def polePair (F : ℝ → ℝ) : ℝ := F (1 / 2 + 1 / 2) + F (1 / 2 - 1 / 2)

/-- The pole pair is literally `F 1 + F 0`. -/
theorem polePair_def (F : ℝ → ℝ) : polePair F = F 1 + F 0 := by
  rw [polePair]; norm_num

/-- **The pole pair collapses to one term.**  If the transform is even about
`1/2`, i.e. `F (1 - x) = F x` for all `x`, then `F 0 = F 1` and the two pole
contributions coincide:
`polePair F = 2 * F (1/2 + 1/2)`.

This is the algebraic core of "the pole `s = 1` contributes one term"; the factor
`2` is the multiplicativity of the count, not a second pole. -/
theorem polePair_eq (F : ℝ → ℝ) (hF : ∀ x, F (1 - x) = F x) :
    polePair F = 2 * F (1 / 2 + 1 / 2) := by
  have h0 : F 0 = F 1 := by
    have h := hF 1
    simpa using h
  have hone : (1 : ℝ) = 1 / 2 + 1 / 2 := by norm_num
  rw [polePair_def, h0, ← hone]
  ring

/-! ## 5. The smoothed zero count -/

/-- The finite zero sum `∑_{k < N} F (1/2 + γ k)` — the `N`-term truncation of the
zero side of the explicit formula, with `γ` the imaginary parts of the zeros. -/
noncomputable def zeroSum (F : ℝ → ℝ) (γ : ℕ → ℝ) (N : ℕ) : ℝ :=
  ∑ k ∈ Finset.range N, F (1 / 2 + γ k)

/-- The defining equation of `zeroSum`, for rewriting. -/
theorem zeroSum_def (F : ℝ → ℝ) (γ : ℕ → ℝ) (N : ℕ) :
    zeroSum F γ N = ∑ k ∈ Finset.range N, F (1 / 2 + γ k) := rfl

/-- The successor recurrence of the zero sum: adjoining the `N`-th zero. -/
theorem zeroSum_succ (F : ℝ → ℝ) (γ : ℕ → ℝ) (N : ℕ) :
    zeroSum F γ (N + 1) = zeroSum F γ N + F (1 / 2 + γ N) := by
  rw [zeroSum_def, zeroSum_def, Finset.sum_range_succ]

/-- **Monotonicity of the smoothed count.**  A pointwise non-negative transform
makes the partial zero sums monotone in the number of terms — the finite
statement that makes the windowed count well defined. -/
theorem zeroSum_mono (F : ℝ → ℝ) (γ : ℕ → ℝ) (hF : ∀ x, 0 ≤ F x) :
    Monotone (fun N => zeroSum F γ N) := by
  refine monotone_nat_of_le_succ fun N => ?_
  rw [zeroSum_succ]
  exact le_add_of_nonneg_right (hF _)

/-- Monotonicity in the explicit `N ≤ M` form. -/
theorem zeroSum_le_of_le (F : ℝ → ℝ) (γ : ℕ → ℝ) (hF : ∀ x, 0 ≤ F x)
    {N M : ℕ} (h : N ≤ M) : zeroSum F γ N ≤ zeroSum F γ M :=
  (zeroSum_mono F γ hF) h

/-- **Non-negativity of the smoothed count.** -/
theorem zeroSum_nonneg (F : ℝ → ℝ) (γ : ℕ → ℝ) (N : ℕ) (hF : ∀ x, 0 ≤ F x) :
    0 ≤ zeroSum F γ N := by
  rw [zeroSum_def]
  exact Finset.sum_nonneg fun k _ => hF _

/-! ## 6. The prime side and its splitting -/

/-- The prime side of the explicit formula,
`∑_{n=2}^{nmax} (Λ n / √n) (g (log n) + g (-log n))`, with `Λ` the von Mangoldt
function.  (Mathlib's `Λ n = ArithmeticFunction.vonMangoldt n` already has values
in `ℝ`, so no coercion is needed.) -/
noncomputable def primeSide (g : ℝ → ℝ) (nmax : ℕ) : ℝ :=
  ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * (g (Real.log n) + g (-(Real.log n)))

/-- The `+log` half of the prime side. -/
noncomputable def primeSideLog (g : ℝ → ℝ) (nmax : ℕ) : ℝ :=
  ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * g (Real.log n)

/-- The `-log` half of the prime side. -/
noncomputable def primeSideNegLog (g : ℝ → ℝ) (nmax : ℕ) : ℝ :=
  ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * g (-(Real.log n))

/-- The defining equation of `primeSide`, for rewriting. -/
theorem primeSide_def (g : ℝ → ℝ) (nmax : ℕ) :
    primeSide g nmax
      = ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * (g (Real.log n) + g (-(Real.log n))) :=
  rfl

/-- The defining equation of `primeSideLog`, for rewriting. -/
theorem primeSideLog_def (g : ℝ → ℝ) (nmax : ℕ) :
    primeSideLog g nmax = ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * g (Real.log n) := rfl

/-- The defining equation of `primeSideNegLog`, for rewriting. -/
theorem primeSideNegLog_def (g : ℝ → ℝ) (nmax : ℕ) :
    primeSideNegLog g nmax = ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * g (-(Real.log n)) :=
  rfl

/-- **Splitting of the prime side.**  The two logs separate term by term:
`primeSide g nmax = primeSideLog g nmax + primeSideNegLog g nmax`.  Finite algebra
(distributivity and `Finset.sum_add_distrib`), no analysis. -/
theorem primeSide_split (g : ℝ → ℝ) (nmax : ℕ) :
    primeSide g nmax = primeSideLog g nmax + primeSideNegLog g nmax := by
  rw [primeSide_def, primeSideLog_def, primeSideNegLog_def, ← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun n _ => by ring

/-- **Evenness halves the prime side.**  If `g (-u) = g u` for all `u`, the `-log`
half equals the `+log` half, so `primeSide g nmax = 2 * primeSideLog g nmax`. -/
theorem primeSide_even (g : ℝ → ℝ) (hg : ∀ u, g (-u) = g u) (nmax : ℕ) :
    primeSide g nmax = 2 * primeSideLog g nmax := by
  have hneg : primeSideNegLog g nmax = primeSideLog g nmax := by
    rw [primeSideNegLog_def, primeSideLog_def]
    exact Finset.sum_congr rfl fun n _ => by rw [hg]
  rw [primeSide_split, hneg]
  ring

/-- The same statement with the two halves displayed as a single sum:
for even `g`, `primeSide g nmax = 2 * ∑_{n≤nmax} (Λ n / √n) g (log n)`. -/
theorem primeSide_even_eq_two_mul_sum (g : ℝ → ℝ) (hg : ∀ u, g (-u) = g u) (nmax : ℕ) :
    primeSide g nmax
      = 2 * ∑ n ∈ Finset.Icc 2 nmax, Λ n / Real.sqrt n * g (Real.log n) :=
  primeSide_even g hg nmax

/-- **Non-negativity of the prime side.**  `Λ ≥ 0`, `√n ≥ 0` and a non-negative
`g` make every summand non-negative. -/
theorem primeSide_nonneg (g : ℝ → ℝ) (nmax : ℕ) (hg : ∀ x, 0 ≤ g x) :
    0 ≤ primeSide g nmax := by
  rw [primeSide_def]
  refine Finset.sum_nonneg fun n _ => ?_
  have h1 : 0 ≤ Λ n / Real.sqrt n :=
    div_nonneg ArithmeticFunction.vonMangoldt_nonneg (Real.sqrt_nonneg _)
  exact mul_nonneg h1 (add_nonneg (hg _) (hg _))

/-! ## 7. What Mathlib has, and the counting-function main term -/

/-- Mathlib's Riemann–von Mangoldt substitute: the zeros of `ζ` are a discrete
set, so a compact region contains only finitely many of them.  This file states no
Riemann–von Mangoldt identity, because Mathlib contains none; this is the directly
available finiteness statement (`IsCompact.inter_riemannZetaZeros_finite`,
restated). -/
theorem riemannZetaZeros_finite_in_compact {S : Set ℂ} (hS : IsCompact S) :
    (S ∩ riemannZetaZeros).Finite :=
  hS.inter_riemannZetaZeros_finite

/-- The classical main term of the zero counting function,
`(T/2π) log (T/(2π e)) + 7/8`.  Stated here as an elementary real function, with
the constant `7/8` made explicit. -/
noncomputable def vonMangoldtMain (T : ℝ) : ℝ :=
  (T / (2 * Real.pi)) * Real.log (T / (2 * Real.pi * Real.exp 1)) + 7 / 8

/-- The defining equation of `vonMangoldtMain`, for rewriting. -/
theorem vonMangoldtMain_def (T : ℝ) :
    vonMangoldtMain T
      = (T / (2 * Real.pi)) * Real.log (T / (2 * Real.pi * Real.exp 1)) + 7 / 8 := rfl

/-- **The counting-function main term, rewritten.**  For `T > 0` the `2πe` in the
logarithm splits into `2π` and `e`, and `log e = 1`:
`(T/2π) log (T/(2πe)) + 7/8 = (T/2π) log (T/2π) - T/2π + 7/8`.  This is the
elementary rewrite that pins the constant `7/8`. -/
theorem vonMangoldtMain_eq {T : ℝ} (hT : 0 < T) :
    vonMangoldtMain T
      = (T / (2 * Real.pi)) * Real.log (T / (2 * Real.pi)) - T / (2 * Real.pi) + 7 / 8 := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have he : Real.exp 1 ≠ 0 := Real.exp_ne_zero 1
  have h2pi : (0 : ℝ) < 2 * Real.pi := by positivity
  have hden : (0 : ℝ) < 2 * Real.pi * Real.exp 1 := by positivity
  have hsplit : T / (2 * Real.pi * Real.exp 1) = T / (2 * Real.pi) / Real.exp 1 := by
    field_simp
  rw [vonMangoldtMain_def, hsplit, Real.log_div (by positivity) he, Real.log_exp]
  ring

/-! ## 8. The elementary integral behind the Cauchy kernel -/

open MeasureTheory in
/-- **The elementary integral of the round.**  The one-sided Laplace/cosine
integral
`∫_0^∞ e^{-u/2} cos (t u) du = 2/(1 + 4 t²)`.

This is the elementary identity offered by the brief as the fallback for its
target 11.  The literal two-sided identity of the brief,
`∫_ℝ (π/2) e^{-|u|/2} e^{-(1/2+it)u} du = 1/(1/4 + t²)`, is *not* correct: the
factor `e^{-(1/2+it)u}` does not decay as `u → -∞` (it oscillates with constant
modulus), so the two-sided integral diverges on the line `Re s = 1/2`.  The
two-sided exponential weight has Laplace transform `1/(1/4 - s²)` in the strip
`|Re s| < 1/2`, and its *Fourier* transform `∫_ℝ e^{-|u|/2} e^{-itu} du =
4/(1+4t²)` is the Cauchy kernel; the honest one-sided statement proved here is
exactly the real part of the transform at `s = 1/2 + it`, and the factor is
recorded in `integral_exp_neg_half_mul_cos_eq`.

The proof uses Mathlib's improper integral of the complex exponential,
`MeasureTheory.integral_exp_mul_complex_Ioi`, applied to `a = -(1/2 + it)`, and
takes real parts with `MeasureTheory.integral_re`. -/
theorem integral_exp_neg_half_mul_cos (t : ℝ) :
    ∫ u : ℝ in Set.Ioi 0, Real.exp (-u / 2) * Real.cos (t * u) = 2 / (1 + 4 * t ^ 2) := by
  set a : ℂ := -(((1 : ℝ) / 2 : ℝ) : ℂ) - (t : ℂ) * Complex.I with ha
  have ha_lt : a.re < 0 := by simp [ha]
  have hpt : ∀ u : ℝ, RCLike.re (Complex.exp (a * u)) = Real.exp (-u / 2) * Real.cos (t * u) := by
    intro u
    rw [RCLike.re_to_complex, Complex.exp_re]
    have h1 : (a * (u : ℂ)).re = -u / 2 := by
      simp [ha, Complex.mul_re]
      ring
    have h2 : (a * (u : ℂ)).im = -(t * u) := by
      simp [ha, Complex.mul_im]
    rw [h1, h2, Real.cos_neg]
  have hkey : -Complex.exp (a * 0) / a = 1 / (((1 : ℝ) / 2 : ℝ) + (t : ℂ) * Complex.I) := by
    rw [mul_zero, Complex.exp_zero, ha,
      show -(((1 : ℝ) / 2 : ℝ) : ℂ) - (t : ℂ) * Complex.I
        = -((((1 : ℝ) / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) by ring]
    rw [neg_div_neg_eq]
  have hval : (-Complex.exp (a * 0) / a).re = 2 / (1 + 4 * t ^ 2) := by
    rw [hkey, Complex.div_re]
    rw [show Complex.normSq ((((1 : ℝ) / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) = 1 / 4 + t ^ 2 by
      rw [Complex.normSq_apply]; simp; ring]
    simp
    field_simp
    ring
  calc ∫ u : ℝ in Set.Ioi 0, Real.exp (-u / 2) * Real.cos (t * u)
      = ∫ u : ℝ in Set.Ioi 0, RCLike.re (Complex.exp (a * u)) :=
        integral_congr_ae (Filter.Eventually.of_forall fun u => (hpt u).symm)
    _ = RCLike.re (∫ u : ℝ in Set.Ioi 0, Complex.exp (a * u)) :=
        integral_re (f := fun u : ℝ => Complex.exp (a * u))
          (integrableOn_exp_mul_complex_Ioi (a := a) ha_lt 0)
    _ = 2 / (1 + 4 * t ^ 2) := by
        rw [integral_exp_mul_complex_Ioi (a := a) ha_lt 0]
        simpa using hval

open MeasureTheory in
/-- **The one-sided integral is half the Cauchy kernel.**  With
`cauchyKernel t = 1/(1/4 + t²) = 4/(1+4t²)`, the value `2/(1+4t²)` of
`integral_exp_neg_half_mul_cos` is exactly `cauchyKernel t / 2` — equivalently
`4/(1+4t²) = cauchyKernel t` is the value of the two-sided Fourier transform of
the exponential weight `expWeight` at frequency `t`. -/
theorem integral_exp_neg_half_mul_cos_eq (t : ℝ) :
    ∫ u : ℝ in Set.Ioi 0, Real.exp (-u / 2) * Real.cos (t * u) = cauchyKernel t / 2 := by
  rw [integral_exp_neg_half_mul_cos, cauchyKernel_def]
  field_simp
  ring

open MeasureTheory in
/-- **The Cauchy kernel is the Fourier transform of the exponential weight.**
This is the correct, convergent form of the brief's target 11: the two-sided
integral of the *even* weight against `cos (t u)`,
`∫_ℝ (π/2) e^{-|u|/2} cos (t u) du = (π/2) · cauchyKernel t`.

The proof folds the two halves `u > 0` and `u < 0` into one by writing the
integrand as `g |u|` for `g y = (π/2) e^{-y/2} cos (t y)` (`Real.cos` is even, so
`cos (t |u|) = cos (t u)`) and applying Mathlib's `integral_comp_abs`,
`∫ x, f |x| = 2 ∫_{x > 0} f x`, together with
`integral_exp_neg_half_mul_cos`. -/
theorem integral_expWeight_mul_cos (t : ℝ) :
    ∫ u : ℝ, expWeight u * Real.cos (t * u) = (Real.pi / 2) * cauchyKernel t := by
  set g : ℝ → ℝ := fun y => (Real.pi / 2) * (Real.exp (-y / 2) * Real.cos (t * y)) with hg
  have hfun : (fun u : ℝ => expWeight u * Real.cos (t * u)) = fun u : ℝ => g |u| := by
    funext u
    have hc : Real.cos (t * |u|) = Real.cos (t * u) := by
      rcases le_total 0 u with h | h
      · rw [abs_of_nonneg h]
      · rw [abs_of_nonpos h, mul_neg, Real.cos_neg]
    rw [hg]
    simp only []
    rw [expWeight_def, ← hc]
    ring
  rw [hfun, integral_comp_abs]
  have hf : ∫ y : ℝ in Set.Ioi 0, g y = (Real.pi / 2) * (2 / (1 + 4 * t ^ 2)) := by
    rw [hg]
    simp only []
    rw [integral_const_mul, integral_exp_neg_half_mul_cos]
  rw [hf, cauchyKernel_def]
  field_simp
  ring

end

end Rh45
