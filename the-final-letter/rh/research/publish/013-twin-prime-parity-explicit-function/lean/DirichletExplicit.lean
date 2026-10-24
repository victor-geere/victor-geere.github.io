/-
  DirichletExplicit.lean — the algebraic layer of Route C for a Dirichlet L-function.

  The Dirichlet analogue of `Rh45/Explicit.lean` and `Rh45/Archimedean.lean`.  For a
  primitive character `χ` mod `q` of parity `a`, the completed function is
  `Λ_χ(s) = (q/π)^((s+a)/2) Γ((s+a)/2) L(χ,s)` (`RouteABC.dirichletCompleted`), and the
  Weil explicit formula for an even test function `g` with Fourier pair `h` reads

      2 ∑_{γ>0} h γ  =  (1/2π) ∫_ℝ h(t) Ψ_χ(t) dt
                        -  ∑_{n≥2} (Λ(n) χ(n) / √n) (g (log n) + g (-log n)),

  with `Ψ_χ(t) = log(q/π) + Re ψ((1/2 + a + i t)/2)`, and **no pole term**: for a
  non-trivial `χ`, `L(χ,·)` is entire.

  The prime-side weight is the *pointwise* product `Λ n · χ n`, the coefficient of the
  Euler product `-L'/L = ∑_{p,k} (log p) χ(p)^k p^{-k s}`, i.e. the Dirichlet–von
  Mangoldt weight — **not** the Dirichlet convolution `(χ ∗ Λ)`.

  This file provides the algebraic skeleton: the weight and its prime-power values, the
  prime side and its splitting/evenness, the archimedean kernel `Ψ_χ`, and the
  `DirichletExplicitData` structure with its validated truncation inequality.  Two of the three
  tail bounds are now **proved** in `DirichletArchimedean.lean` (the archimedean derivative
  budget `dirichletPsi_deriv_bound`) and `DirichletPrimeTail.lean` (the Chebyshev prime-tail
  bounds `dirichletPrimeSideLog_remainder_le` / `..._decay`).  What remains numeric is the
  *zero/density* tail (Mathlib has no zero-counting asymptotics for `L`) and the *identity
  itself* (contour integration + Euler product + functional equation), which the file records
  as `DirichletExplicitData`, exactly as `CertifiedWindow.lean` does for Route B.
-/
import Rh45.Explicit
import Rh45.Archimedean
import Generic

namespace RouteABC

noncomputable section

open scoped BigOperators
open scoped ArithmeticFunction.vonMangoldt

/-! ## 1. The Dirichlet–von Mangoldt weight -/

/-- **The Dirichlet–von Mangoldt weight** `b(n) = Λ(n) χ(n)`, the coefficient of the
logarithmic derivative of the Euler product,
`-L'/L(s) = ∑_n b(n) n^{-s} = ∑_p ∑_{k≥1} (log p) χ(p)^k p^{-k s}`.  It is the
pointwise product with `Λ`, *not* the convolution `χ ∗ Λ`. -/
noncomputable def dirichletWeight {N : ℕ} (χ : DirichletCharacter ℂ N) (n : ℕ) : ℂ :=
  (Λ n : ℂ) * χ n

@[simp] theorem dirichletWeight_def {N : ℕ} (χ : DirichletCharacter ℂ N) (n : ℕ) :
    dirichletWeight χ n = (Λ n : ℂ) * χ n := rfl

/-- On a prime, `b(p) = (log p) χ(p)`. -/
theorem dirichletWeight_prime {N : ℕ} (χ : DirichletCharacter ℂ N) {p : ℕ} (hp : p.Prime) :
    dirichletWeight χ p = (Real.log p : ℂ) * χ p := by
  rw [dirichletWeight_def, ArithmeticFunction.vonMangoldt_apply_prime hp]

/-- On a prime power, `b(p^k) = (log p) χ(p)^k` — the Euler-product coefficient. -/
theorem dirichletWeight_pow_prime {N : ℕ} (χ : DirichletCharacter ℂ N)
    {p k : ℕ} (hp : p.Prime) (hk : k ≠ 0) :
    dirichletWeight χ (p ^ k) = (Real.log p : ℂ) * χ p ^ k := by
  rw [dirichletWeight_def, ArithmeticFunction.vonMangoldt_apply_pow hk,
    ArithmeticFunction.vonMangoldt_apply_prime hp]
  simp only [Nat.cast_pow, map_pow]

/-- `b` vanishes off the prime powers. -/
theorem dirichletWeight_eq_zero_of_not_isPrimePow {N : ℕ} (χ : DirichletCharacter ℂ N)
    {n : ℕ} (hn : ¬ IsPrimePow n) : dirichletWeight χ n = 0 := by
  have h : Λ n = 0 := by
    by_contra h0
    exact hn ((ArithmeticFunction.vonMangoldt_ne_zero_iff).mp h0)
  rw [dirichletWeight_def, h]
  simp

/-! ## 2. The archimedean kernel `Ψ_χ` -/

/-- The digamma line of parity `a`: `w = (1+2a)/4 + i t/2`, the argument of `ψ` in
`Ψ_χ`.  For `a = 0` this is the `1/4 + i t/2` of `Rh45.digammaLine`. -/
def dirichletDigammaLine (a t : ℝ) : ℂ := (t : ℂ) * (Complex.I / 2) + (1 + 2 * a) / 4

theorem dirichletDigammaLine_eq (a t : ℝ) :
    dirichletDigammaLine a t = ((1 + 2 * a) / 4 : ℂ) + ((t / 2 : ℝ) : ℂ) * Complex.I := by
  rw [dirichletDigammaLine]; push_cast; ring

theorem dirichletDigammaLine_re (a t : ℝ) : (dirichletDigammaLine a t).re = (1 + 2 * a) / 4 := by
  rw [dirichletDigammaLine_eq]; simp

/-- **The archimedean kernel**
`Ψ_χ(t) = log(q/π) + Re ψ((1/2 + a + i t)/2) = log(q/π) + Re ψ((1+2a)/4 + i t/2)`. -/
noncomputable def dirichletPsi (q : ℕ) (a t : ℝ) : ℝ :=
  Real.log ((q : ℝ) / Real.pi) + (Complex.digamma (dirichletDigammaLine a t)).re

/-- For `q = 1`, `a = 0`, `dirichletPsi` is the `Ψ` of `Rh45.Archimedean`. -/
theorem dirichletPsi_one_zero (t : ℝ) :
    dirichletPsi 1 0 t = -Real.log Real.pi + (Complex.digamma (Rh45.digammaLine t)).re := by
  rw [dirichletPsi, dirichletDigammaLine_eq, Rh45.digammaLine_eq]
  norm_num [Real.log_div]

/-! ## 3. The prime side -/

/-- The Dirichlet prime side
`∑_{n=2}^{nmax} (Λ(n) χ(n) / √n) (g (log n) + g (-log n))`. -/
noncomputable def dirichletPrimeSide {N : ℕ} (χ : DirichletCharacter ℂ N) (g : ℝ → ℝ)
    (nmax : ℕ) : ℂ :=
  ∑ n ∈ Finset.Icc 2 nmax,
    dirichletWeight χ n / (Real.sqrt n : ℂ) * ((g (Real.log n) : ℂ) + (g (-(Real.log n)) : ℂ))

/-- The `+log` half. -/
noncomputable def dirichletPrimeSideLog {N : ℕ} (χ : DirichletCharacter ℂ N) (g : ℝ → ℝ)
    (nmax : ℕ) : ℂ :=
  ∑ n ∈ Finset.Icc 2 nmax, dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)

/-- The `-log` half. -/
noncomputable def dirichletPrimeSideNegLog {N : ℕ} (χ : DirichletCharacter ℂ N) (g : ℝ → ℝ)
    (nmax : ℕ) : ℂ :=
  ∑ n ∈ Finset.Icc 2 nmax, dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (-(Real.log n)) : ℂ)

/-- **Splitting of the prime side** into its `+log` and `-log` halves. -/
theorem dirichletPrimeSide_split {N : ℕ} (χ : DirichletCharacter ℂ N) (g : ℝ → ℝ)
    (nmax : ℕ) :
    dirichletPrimeSide χ g nmax = dirichletPrimeSideLog χ g nmax + dirichletPrimeSideNegLog χ g nmax := by
  rw [dirichletPrimeSide, dirichletPrimeSideLog, dirichletPrimeSideNegLog,
    ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun n _ => ?_
  ring

/-- For an even `g` the two halves of the Dirichlet prime side are equal. -/
theorem dirichletPrimeSideNegLog_eq_of_even {N : ℕ} (χ : DirichletCharacter ℂ N) (g : ℝ → ℝ)
    (hg : ∀ u, g (-u) = g u) (nmax : ℕ) :
    dirichletPrimeSideNegLog χ g nmax = dirichletPrimeSideLog χ g nmax := by
  rw [dirichletPrimeSideLog, dirichletPrimeSideNegLog]
  refine Finset.sum_congr rfl fun n _ => ?_
  rw [hg]

/-- For an even `g`, the prime side is twice its `+log` half. -/
theorem dirichletPrimeSide_even_eq_two_mul {N : ℕ} (χ : DirichletCharacter ℂ N) (g : ℝ → ℝ)
    (hg : ∀ u, g (-u) = g u) (nmax : ℕ) :
    dirichletPrimeSide χ g nmax = 2 * dirichletPrimeSideLog χ g nmax := by
  rw [dirichletPrimeSide_split, dirichletPrimeSideNegLog_eq_of_even χ g hg nmax]
  ring

/-! ## 4. The Route-C obligation, named -/

/-- **The Route-C data for `L(χ,·)`.**  The exact identity (`h_identity`) and the
three-way split of the right-hand side into the computed value plus the zero, prime
and archimedean tails.  Supplying it is the analytic/numerical certificate; consuming
it bounds the residual by the tails. has no pole term for non-trivial `χ`, so the
`rhsTrue` here is `archimedean - prime` (the zero side sits on the left). -/
structure DirichletExplicitData (χ : DirichletCharacter ℂ N) where
  lhs : ℝ
  rhsTrue : ℝ
  rhsComputed : ℝ
  zeroTail : ℝ
  primeTail : ℝ
  archTail : ℝ
  h_identity : lhs = rhsTrue
  h_split : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)

/-- **Validated truncation bound for the Dirichlet explicit formula.** -/
theorem DirichletExplicitData.validated {N : ℕ} {χ : DirichletCharacter ℂ N}
    (D : DirichletExplicitData χ) :
    |D.lhs - D.rhsComputed| ≤ |D.zeroTail| + |D.primeTail| + |D.archTail| :=
  Rh45Routes.validated_truncation_bound D.h_identity D.h_split

/-- **Residual bound from externally proved tail bounds.**  If the prime and archimedean
tails are bounded by numbers `P`, `A` — e.g. by the proved
`dirichletPrimeSide_remainder_le_decay` and `dirichletPsi_deriv_bound` — then

    `|lhs − computed| ≤ |zeroTail| + P + A`.

Only the zero/density tail remains an input; it is bounded by
`zeroTail_le_of_majorant` + `gaussian_zeroTail_le` once a zero-spacing (density) fact is
supplied. -/
theorem DirichletExplicitData.validated_le {N : ℕ} {χ : DirichletCharacter ℂ N}
    (D : DirichletExplicitData χ) {P A : ℝ}
    (hP : |D.primeTail| ≤ P) (hA : |D.archTail| ≤ A) :
    |D.lhs - D.rhsComputed| ≤ |D.zeroTail| + P + A :=
  D.validated.trans (by linarith [abs_nonneg D.zeroTail])

end

end RouteABC
