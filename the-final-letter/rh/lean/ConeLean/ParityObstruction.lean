/-
ConeLean/ParityObstruction.lean — deliverable (c1) of goal 3: why the parity-breaking methods
cannot consume `f n = λ(n)λ(n+2)`.

The methods that break parity — Selberg's asymptotic sieve and the Friedlander–Iwaniec
bilinear/Type-II inputs — consume an arithmetic *structure*: a multiplicative coefficient sequence,
or a Dirichlet convolution of such (as with `Λ = μ * log`).  This file records, machine-checked,
that `f` has none of it, and not merely that nobody has found it:

* `chowlaAF_one`               : `f 1 = -1`  (whereas multiplicativity forces `f 1 = 1`);
* `chowlaAF_not_multiplicative`: `¬ f.IsMultiplicative`;
* `chowlaAF_not_conv`          : `f` is not the Dirichlet convolution of two multiplicative
                                 arithmetic functions — so the classical Type-II shape is not
                                 available for it either.

Consequence (documented, not mechanised — it is the standard equivalence between multiplicativity
and an Euler product for absolutely convergent Dirichlet series): `Σ f(n) n^{−s}` has **no Euler
product**, so the `ζ`/Perron machinery cannot see it.  Together with route R1 (Selberg parity:
bounded-depth sieves cannot detect parity) this is why R3 is closed and R4 has nothing to consume,
as recorded in `residue-verdict.md` §6.
-/
import Mathlib.NumberTheory.ArithmeticFunction.Liouville

namespace ConeLean

open ArithmeticFunction

/-- The correlation sequence `n ↦ λ(n)λ(n+2)`, as an arithmetic function. -/
def chowlaAF : ArithmeticFunction ℤ where
  toFun n := liouville n * liouville (n + 2)
  map_zero' := by simp [liouville]

theorem chowlaAF_one : chowlaAF 1 = -1 := by native_decide

/-- The correlation sequence is not multiplicative: multiplicativity would force `f 1 = 1`, but
`f 1 = λ(1)λ(3) = -1`. -/
theorem chowlaAF_not_multiplicative : ¬ chowlaAF.IsMultiplicative := by
  intro h
  have h1 : chowlaAF 1 = 1 := h.map_one
  rw [chowlaAF_one] at h1
  norm_num at h1

/-- The correlation sequence is not a Dirichlet convolution of multiplicative arithmetic
functions, i.e. the classical Type-II/convolution shape used by the parity-breaking methods does
not apply to it. -/
theorem chowlaAF_not_conv :
    ¬ ∃ g h : ArithmeticFunction ℤ,
      g.IsMultiplicative ∧ h.IsMultiplicative ∧ g * h = chowlaAF := by
  rintro ⟨g, h, hg, hh, heq⟩
  exact chowlaAF_not_multiplicative (heq ▸ hg.mul hh)

end ConeLean
