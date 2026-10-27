/-
  DirichletLogDeriv.lean — the **prime-coefficient half of the explicit formula, proved**.

  `DirichletExplicit.lean` defines the Dirichlet–von Mangoldt weight
  `dirichletWeight χ n = Λ(n) χ(n)` (the pointwise product) and `DirichletPrimeTail.lean`
  bounds its prime side.  This file proves that the weight really is the coefficient
  sequence of `−L'/L` on `re s > 1`:

    `LSeries (Λ·χ) s = − deriv (LSeries χ) s / LSeries χ s`,

  equivalently `−logDeriv (LSeries χ) s = LSeries (Λ·χ) s`.  It is the identity's prime side,
  and it is obtained from Mathlib's Euler-product logarithm
  (`DirichletCharacter.LSeries_twist_vonMangoldt_eq`, whose `*` is the *pointwise* product of
  coefficient functions — the Dirichlet convolution is `LSeries.convolution`).
-/
import DirichletExplicit
import Mathlib.NumberTheory.LSeries.Dirichlet

namespace RouteABC

noncomputable section

open scoped BigOperators ArithmeticFunction.vonMangoldt
open DirichletCharacter

/-- **The prime side of the explicit formula is `−L'/L`.**  On `re s > 1`,

    `LSeries (fun n ↦ Λ n · χ n) s = − deriv (LSeries (fun n ↦ χ n)) s / LSeries (fun n ↦ χ n) s`.

This is the coefficient identity behind the prime term of the explicit formula; the weight
`dirichletWeight χ` is the pointwise product `Λ·χ`, not the Dirichlet convolution `χ ∗ Λ`. -/
theorem LSeries_dirichletWeight_eq {N : ℕ} (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) :
    LSeries (fun n => dirichletWeight χ n) s
      = - deriv (LSeries (fun n => χ n)) s / LSeries (fun n => χ n) s := by
  refine (LSeries_congr (fun n => ?_) s).trans
    (DirichletCharacter.LSeries_twist_vonMangoldt_eq χ hs)
  simp [dirichletWeight_def, mul_comm]

/-- The identity in `logDeriv` form: `−logDeriv (LSeries χ) = LSeries (Λ·χ)` on `re s > 1`. -/
theorem neg_logDeriv_LSeries_dirichlet {N : ℕ} (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) :
    -logDeriv (LSeries (fun n => χ n)) s = LSeries (fun n => dirichletWeight χ n) s := by
  rw [LSeries_dirichletWeight_eq χ hs, logDeriv_apply]
  ring

end

end RouteABC
