/-
  GaussSumComposite.lean — Gauss-sum square for a primitive character modulo a possibly
  composite `N`.

  Mathlib proves the Gauss-sum square

  `gaussSum_sq : gaussSum χ ψ ^ 2 = χ (-1) * Fintype.card R`

  only for a multiplicative character of a finite *field* `R`
  (`Mathlib/NumberTheory/GaussSum.lean`).  Its proof goes through
  `gaussSum_mul_gaussSum_eq_card`, which divides by an arbitrary nonzero field element
  (`gaussSum_mul_aux` uses `b⁻¹` and `mulLeft_bijective₀`), so it does not apply to `ZMod N`
  for composite `N` — exactly the case needed for Dirichlet characters of composite conductor.

  This file supplies the missing statement for arbitrary `N`:

  * `gaussSum_mul_gaussSum_inv_eq_card` — the product form
    `gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar = χ (-1) * N` for primitive `χ`;
  * `gaussSum_sq_of_isPrimitive` — the square form
    `gaussSum χ stdAddChar ^ 2 = χ (-1) * N` for primitive quadratic `χ`.

  The proof never divides by an element of `ZMod N`.  Instead it uses the discrete Fourier
  transform on `ZMod N`, which exists for every `N`
  (`Mathlib/Analysis/Fourier/ZMod.lean`):

  1. for primitive `χ`, `𝓕 χ k = χ⁻¹ (-k) * τ` with `τ = gaussSum χ stdAddChar`
     (`DirichletCharacter.IsPrimitive.fourierTransform_eq_inv_mul_gaussSum`);
  2. Fourier inversion (`ZMod.dft_dft`) computes `𝓕 (𝓕 χ) k = N * χ (-k)` on the one hand,
     while substituting step 1 and reindexing with `j ↦ -j` gives
     `𝓕 (𝓕 χ) k = τ * gaussSum χ⁻¹ (stdAddChar.mulShift k) = τ * χ k * gaussSum χ⁻¹ stdAddChar`
     on the other (`gaussSum_mulShift_of_isPrimitive`);
  3. comparing at `k = 1` (where `χ 1 = 1`) yields the product identity, and `hχ₂.inv`
     (`χ⁻¹ = χ` for a quadratic `χ`) turns it into the square form.

  The hypothesis `χ ≠ 1` is kept only for parity with Mathlib's field-case `gaussSum_sq`; the
  Fourier proof does not use it (for `N > 1` primitivity already forces `χ ≠ 1`).

  We also record here that the same identity re-derives the root-number sign
  `rootNumber χ = ±1` for a nontrivial primitive quadratic Dirichlet character
  (`rootNumber_eq_one_or_neg_one'` below).  That theorem is a deliberate *second, independent*
  proof: `011/lean/RootNumber.lean` already proves the sign from the functional equation
  (`rootNumber_sq_eq_one_of_inv_eq_self`), and is left untouched.  The route here reproduces
  the intended `gaussSum_sq` argument and now works at every modulus.
-/
import Mathlib.Analysis.Fourier.ZMod
import Mathlib.NumberTheory.LSeries.DirichletContinuation

open scoped ComplexConjugate
open DirichletCharacter ZMod MulChar
open Complex

namespace DirichletCharacter.IsPrimitive

/-- **The inverse of a primitive Dirichlet character is primitive.**  This only needs the
conductor, and the conductor is invariant under inversion (`conductor_inv`).  (Mathlib has the
statement for the conductor but not this `IsPrimitive` form.) -/
theorem inv {R : Type*} [CommMonoidWithZero R] {N : ℕ} {χ : DirichletCharacter R N}
    (hχ : IsPrimitive χ) : IsPrimitive χ⁻¹ := by
  rw [isPrimitive_def] at hχ ⊢
  rwa [conductor_inv]

end DirichletCharacter.IsPrimitive

namespace RouteABC

noncomputable section

/-! ## The double Fourier transform of a primitive character -/

/-- **Fourier inversion versus the Gauss-sum expansion.**  For a primitive Dirichlet character
`χ`, applying the discrete Fourier transform twice gives, at every `k`,

`𝓕 (𝓕 χ) k = χ k * (gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar)`.

The left-hand side is the transpose of the Gauss sum; the right-hand side comes from

`𝓕 χ k = χ⁻¹ (-k) * τ` and the reindexing `j ↦ -j`, which turns the inner sum into
`gaussSum χ⁻¹ (stdAddChar.mulShift k) = χ k * gaussSum χ⁻¹ stdAddChar`.

The statement is stated for the complex target, which is the only case used below; the same
computation works over any integral domain. -/
private lemma dft_dft_eq {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (k : ZMod N) :
    𝓕 (𝓕 χ) k = χ k * (gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar) := by
  have hτ : ∀ j : ZMod N, 𝓕 χ j = χ⁻¹ (-j) * gaussSum χ stdAddChar :=
    fun j => hχ.fourierTransform_eq_inv_mul_gaussSum j
  -- Expand the outer transform with `dft_apply` and substitute `𝓕 χ`.
  have step1 : 𝓕 (𝓕 χ) k
      = ∑ j : ZMod N, stdAddChar (-(j * k)) * (χ⁻¹ (-j) * gaussSum χ stdAddChar) := by
    rw [dft_apply]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [hτ j, smul_eq_mul]
  rw [step1]
  -- Reindex `j ↦ -j`; this absorbs the `-` inside the additive character.
  rw [Fintype.sum_equiv (Equiv.neg (ZMod N))
        (fun j : ZMod N => stdAddChar (-(j * k)) * (χ⁻¹ (-j) * gaussSum χ stdAddChar))
        (fun i : ZMod N => stdAddChar (i * k) * (χ⁻¹ i * gaussSum χ stdAddChar))
        (fun j => by simp [Equiv.neg_apply, neg_mul])]
  -- The remaining sum is `gaussSum χ⁻¹ (stdAddChar.mulShift k)`, up to the factor `τ`.
  have hgs : gaussSum χ⁻¹ (stdAddChar.mulShift k) * gaussSum χ stdAddChar
      = ∑ i : ZMod N, stdAddChar (i * k) * (χ⁻¹ i * gaussSum χ stdAddChar) := by
    conv_lhs => rw [gaussSum]
    rw [Finset.sum_mul]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [AddChar.mulShift_apply, mul_comm (k : ZMod N) i]
    ring
  rw [← hgs, gaussSum_mulShift_of_isPrimitive (e := stdAddChar) hχ.inv k, inv_inv]
  ring

/-! ## The product form -/

/-- **Product of the Gauss sums of a primitive character and its inverse, modulo a possibly
composite `N`.**

`gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar = χ (-1) * N`.

This is the composite-modulus analogue of Mathlib's field-only
`gaussSum_mul_gaussSum_eq_card`.  The proof compares the two evaluations of `𝓕 (𝓕 χ)` at
`k = 1`: `dft_dft` gives `N * χ (-1)`, while `dft_dft_eq` gives
`χ 1 * (τ * gaussSum χ⁻¹ stdAddChar) = τ * gaussSum χ⁻¹ stdAddChar`. -/
theorem gaussSum_mul_gaussSum_inv_eq_card {N : ℕ} [NeZero N] {χ : DirichletCharacter ℂ N}
    (hχ : IsPrimitive χ) :
    gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar = χ (-1) * (N : ℂ) := by
  have h1 := dft_dft_eq χ hχ 1
  have h2 : 𝓕 (𝓕 χ) 1 = (N : ℂ) * χ (-1) := by
    rw [dft_dft]
    simp [smul_eq_mul]
  rw [h2] at h1
  simpa [mul_comm] using h1.symm

/-! ## The square form -/

/-- **Gauss-sum square for a primitive character modulo a possibly composite `N`.**

`gaussSum χ stdAddChar ^ 2 = χ (-1) * N` for a primitive nontrivial quadratic Dirichlet
character of arbitrary modulus.  This fills the gap left by Mathlib's `gaussSum_sq`, whose
proof needs `ZMod N` to be a field.

The hypothesis `hχ₁ : χ ≠ 1` is required by Mathlib's field-case statement and is retained for
parity, but the Fourier proof below does not use it: for `N > 1` primitivity already implies
`χ ≠ 1`, and for `N = 1` both sides are `1`. -/
theorem gaussSum_sq_of_isPrimitive {N : ℕ} [NeZero N] {χ : DirichletCharacter ℂ N}
    (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1) (hχ₂ : IsQuadratic χ) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (N : ℂ) := by
  -- Kept for parity with Mathlib's `gaussSum_sq`; not needed by the Fourier computation.
  have _ : χ ≠ 1 := hχ₁
  have h := gaussSum_mul_gaussSum_inv_eq_card hχ
  rw [hχ₂.inv] at h
  simpa [pow_two] using h

/-! ## Specialisation to prime modulus

At prime `N` the source ring `ZMod N` is a field, so Mathlib's `gaussSum_sq` applies; the
lemma below records that the new theorem and the field-case theorem hold simultaneously and
agree, using `Fintype.card (ZMod p) = p` (`ZMod.card`).  The examples after it instantiate this
at `N = 3, 5, 7`. -/

/-- **Prime modulus: the two square identities coincide.**  For a prime `p`, the
composite-modulus statement `gaussSum_sq_of_isPrimitive` and Mathlib's field-case
`gaussSum_sq` are the same identity, `Fintype.card (ZMod p)` being `p`. -/
theorem gaussSum_sq_of_isPrimitive_prime {p : ℕ} [NeZero p] [hp : Fact p.Prime]
    (χ : DirichletCharacter ℂ p) (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1) (hχ₂ : χ.IsQuadratic) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (p : ℂ) ∧
      gaussSum χ stdAddChar ^ 2 = χ (-1) * (Fintype.card (ZMod p) : ℂ) :=
  ⟨gaussSum_sq_of_isPrimitive hχ hχ₁ hχ₂, gaussSum_sq hχ₁ hχ₂ (isPrimitive_stdAddChar p)⟩

/-- At `N = 3`, the composite-modulus square and Mathlib's field-case `gaussSum_sq` agree. -/
example (χ : DirichletCharacter ℂ 3) (hχ : IsPrimitive χ) (h₁ : χ ≠ 1) (h₂ : χ.IsQuadratic) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (3 : ℂ) ∧
      gaussSum χ stdAddChar ^ 2 = χ (-1) * (Fintype.card (ZMod 3) : ℂ) :=
  gaussSum_sq_of_isPrimitive_prime (p := 3) (hp := ⟨by decide⟩) χ hχ h₁ h₂

/-- At `N = 5`, the composite-modulus square and Mathlib's field-case `gaussSum_sq` agree. -/
example (χ : DirichletCharacter ℂ 5) (hχ : IsPrimitive χ) (h₁ : χ ≠ 1) (h₂ : χ.IsQuadratic) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (5 : ℂ) ∧
      gaussSum χ stdAddChar ^ 2 = χ (-1) * (Fintype.card (ZMod 5) : ℂ) :=
  gaussSum_sq_of_isPrimitive_prime (p := 5) (hp := ⟨by decide⟩) χ hχ h₁ h₂

/-- At `N = 7`, the composite-modulus square and Mathlib's field-case `gaussSum_sq` agree. -/
example (χ : DirichletCharacter ℂ 7) (hχ : IsPrimitive χ) (h₁ : χ ≠ 1) (h₂ : χ.IsQuadratic) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (7 : ℂ) ∧
      gaussSum χ stdAddChar ^ 2 = χ (-1) * (Fintype.card (ZMod 7) : ℂ) :=
  gaussSum_sq_of_isPrimitive_prime (p := 7) (hp := ⟨by decide⟩) χ hχ h₁ h₂

/-! ## The root-number sign, re-derived by the Gauss-sum route

`011/lean/RootNumber.lean` proves `rootNumber χ = ±1` for a nontrivial primitive quadratic `χ`
from the functional equation (`rootNumber_sq_eq_one_of_inv_eq_self`).  The theorem below is a
*second, independent* proof of the same statement by the route that motivated
`gaussSum_sq_of_isPrimitive`: `rootNumber χ = τ / I^a / N^(1/2)` with `a = 0` for even `χ` and
`a = 1` for odd `χ`, so

`rootNumber χ ^ 2 = τ ^ 2 / (I^a) ^ 2 / (N^(1/2)) ^ 2 = χ (-1) * N / ((-1)^a * N) = 1`,

using `gaussSum_sq_of_isPrimitive`, `(I^a)^2 = (-1)^a`, `(N^(1/2))^2 = N`, and
`χ (-1) = (-1)^a` (which is the content of `χ.Even`/`χ.Odd`).  `RootNumber.lean` is left
untouched. -/
theorem rootNumber_eq_one_or_neg_one' {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1) (hχ₂ : χ.IsQuadratic) :
    rootNumber χ = 1 ∨ rootNumber χ = -1 := by
  refine sq_eq_one_iff.mp ?_
  have hN : (N : ℂ) ≠ 0 := by exact_mod_cast (NeZero.ne N)
  -- The Gauss-sum square, the only input not already in Mathlib.
  have hτ := gaussSum_sq_of_isPrimitive hχ hχ₁ hχ₂
  -- `(N ^ (1 / 2 : ℂ)) ^ 2 = N`.
  have hs : ((N : ℂ) ^ (1 / 2 : ℂ)) ^ 2 = (N : ℂ) := by simp
  rcases χ.even_or_odd with hE | hO
  · -- `χ` even: the archimedean root number is `I ^ 0 = 1` and `χ (-1) = 1`.
    have hroot : rootNumber χ = gaussSum χ stdAddChar / (N : ℂ) ^ (1 / 2 : ℂ) := by
      rw [rootNumber, ite_eq_left hE]
      simp
    rw [hroot, div_pow, hτ, hE, one_mul, hs]
    exact div_self hN
  · -- `χ` odd: the archimedean root number is `I ^ 1 = I` and `χ (-1) = -1`.
    have hI : Complex.I ^ 2 = -1 := by simp [pow_two, Complex.I_mul_I]
    have hroot : rootNumber χ = gaussSum χ stdAddChar / Complex.I / (N : ℂ) ^ (1 / 2 : ℂ) := by
      rw [rootNumber, ite_eq_right hO.not_even]
      simp
    rw [hroot, div_pow, div_pow, hτ, hO, hI, hs]
    field_simp

end

end RouteABC
