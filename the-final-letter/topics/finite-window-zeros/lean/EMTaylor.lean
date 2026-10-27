import EMDeriv

/-!
# The `K = 3` generator factored through `21^{-s}`, and the Taylor route to `h2`

`h1` is proved in `EMDeriv.lean`.  The remaining Krawczyk input is
`h2 : ∀ z ∈ closedBall s14 (1/5), ‖ζ′(z) − ζ′(s14)‖ ≤ 47/250`, which is proved
by a Taylor model: the true variation is `0.13928`, achieved by the first few
Taylor coefficients of `ζ` at `s14`.

The key structural fact is that the `K = 3` Euler–Maclaurin generator factors as

`zetaEMGen 3 20 s = Σ_{n≤20} n^{-s} + 21^{-s} · Ψ₃(s)`

with `Ψ₃` a **rational** function of `s`.  Hence every derivative at `s14` is
a Gaussian rational (from `1/(s14−1)`, `P₃(−s14)`, `P₅(−s14)`) times a power of
`log 21`, i.e. amenable to the same point-box arithmetic as `Vbox`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-! ## Folding the higher `21`-powers -/

theorem cpow21_neg_three : (21 : ℂ) ^ (((-3 : ℤ)) : ℂ) = (1 / 9261 : ℂ) := by
  rw [Complex.cpow_intCast]
  norm_num

theorem cpow21_neg_five : (21 : ℂ) ^ (((-5 : ℤ)) : ℂ) = (1 / 4084101 : ℂ) := by
  rw [Complex.cpow_intCast]
  norm_num

/-- `21^(-(s+3)) = 21^(-s) / 9261`. -/
theorem pow21_neg_add_three (s : ℂ) :
    (21 : ℂ) ^ (-(s + 3)) = (21 : ℂ) ^ (-s) / 9261 := by
  rw [show -(s + 3) = (-s) + ((-3 : ℤ) : ℂ) by push_cast; ring,
    Complex.cpow_add _ _ (by norm_num : (21 : ℂ) ≠ 0), cpow21_neg_three]
  ring

/-- `21^(-(s+5)) = 21^(-s) / 4084101`. -/
theorem pow21_neg_add_five (s : ℂ) :
    (21 : ℂ) ^ (-(s + 5)) = (21 : ℂ) ^ (-s) / 4084101 := by
  rw [show -(s + 5) = (-s) + ((-5 : ℤ) : ℂ) by push_cast; ring,
    Complex.cpow_add _ _ (by norm_num : (21 : ℂ) ≠ 0), cpow21_neg_five]
  ring

/-! ## The explicit `K = 3` generator -/

/-- The `K = 3` generator, written out in its six pieces. -/
theorem zetaEMGen_three_explicit (s : ℂ) :
    zetaEMGen 3 20 s =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s)))
        + (21 : ℂ) ^ (1 - s) / (s - 1)
        + (21 : ℂ) ^ (-s) / 2
        + (1 / 12 : ℂ) * s * (21 : ℂ) ^ (-(s + 1))
        + (1 / 720 : ℂ) * (descPochhammer ℂ 3).eval (-s) * (21 : ℂ) ^ (-(s + 3))
        - (1 / 30240 : ℂ) * (descPochhammer ℂ 5).eval (-s) * (21 : ℂ) ^ (-(s + 5)) := by
  have hP3 : (descPochhammer ℂ 3).eval (-s) = (-s) * (-s - 1) * (-s - 2) := by
    simp [descPochhammer]
    ring
  have hP5 : (descPochhammer ℂ 5).eval (-s) =
      (-s) * (-s - 1) * (-s - 2) * (-s - 3) * (-s - 4) := by
    simp [descPochhammer]
    ring
  rw [zetaEMGen_three_expand, zetaEMGen_one, zetaBase]
  simp only [emGShift, descPochhammer_zero, Polynomial.eval_zero,
    Polynomial.eval_one, hP3, hP5, zero_add, Nat.cast_ofNat, Nat.cast_zero, mul_one,
    add_zero, sub_zero]
  rw [emCoef_two, emCoef_three]
  push_cast
  ring

/-- `Ψ₃`: the rational factor of the `K = 3` generator after `21^{-s}`. -/
noncomputable def Psi3 (s : ℂ) : ℂ :=
  21 / (s - 1) + 1 / 2 + s / 252
    + (descPochhammer ℂ 3).eval (-s) / (720 * 9261)
    - (descPochhammer ℂ 5).eval (-s) / (30240 * 4084101)

/-- **The factorization** `zetaEMGen 3 20 s = Σ_{n≤20} n^{-s} + 21^{-s}·Ψ₃(s)`. -/
theorem gen3_eq_sum_psi (s : ℂ) :
    zetaEMGen 3 20 s =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s))) + (21 : ℂ) ^ (-s) * Psi3 s := by
  rw [zetaEMGen_three_explicit, pow21_one_sub, pow21_neg_succ, pow21_neg_add_three,
    pow21_neg_add_five, Psi3]
  field_simp
  ring

end FiniteWindowZeros
