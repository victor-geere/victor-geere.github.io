import Mathlib
import GaussianInt.QuadraticField

/-!
# The ring of integers of `ℚ(i)` is `ℤ[i]`

This file proves the bridge that the QEFE Gaussian-integer development needs in
order to use Mathlib's Dedekind zeta function and class number formula:

`NumberField.RingOfIntegers.equiv`: `𝓞 (ℚ(i)) ≃+* ℤ[i]`.

The proof does not go through a trace/norm computation.  Instead it uses the
general integral-closure machinery:

* `ℤ[i]` is a Euclidean domain, hence integrally closed (`IsIntegrallyClosed`);
* `ℚ(i)` is the fraction field of `ℤ[i]` (`IsFractionRing (Zsqrtd (-1)) QI`),
  proved from the coordinate decomposition `z = a + b·i` with `a b : ℚ`
  (`GaussianInt.coord_eq`) and a common denominator;
* `ℤ[i]` is module-finite over `ℤ` (`Module.Finite.of_basis gaussianBasis`),
  hence integral over `ℤ`.

Mathlib's `IsIntegralClosure.of_isIntegrallyClosed` then gives
`IsIntegralClosure (Zsqrtd (-1)) ℤ QI`, and `NumberField.RingOfIntegers.equiv`
turns that into the ring equivalence.

This is the first of the two gates in Phase 2 of
`HANDOFF-GAUSSIAN-IDEAL-COUNT.md`; the remaining gate is transporting the ideal
count across this equivalence and evaluating the residue at `s = 1`.
-/

noncomputable section

open Polynomial

namespace GaussianInt

/-- `toQI` on coordinates: `m + n·i`. -/
@[simp]
lemma toQI_mk (m n : ℤ) : toQI (⟨m, n⟩ : Zsqrtd (-1)) = (m : QI) + (n : QI) * iRoot := by
  simp [toQI]

/-- `ℚ(i)` is a `ℤ[i]`-algebra through the embedding `ℤ[i] ↪ ℚ(i)`. -/
instance instAlgebraQI : Algebra (Zsqrtd (-1)) QI := toQI.toAlgebra

/-- The ring map `ℤ[i] → ℚ(i)` is the `algebraMap` of the algebra structure
installed above. -/
lemma algebraMap_QI_eq_toQI : (algebraMap (Zsqrtd (-1)) QI) = toQI := rfl

instance : FaithfulSMul (Zsqrtd (-1)) QI :=
  (faithfulSMul_iff_algebraMap_injective _ _).mpr toQI_injective

instance : IsScalarTower ℤ (Zsqrtd (-1)) QI := by
  refine IsScalarTower.of_algebraMap_eq (fun r => ?_)
  show (algebraMap ℤ QI) r = (algebraMap (Zsqrtd (-1)) QI) ((algebraMap ℤ (Zsqrtd (-1))) r)
  simp

/-- A rational number, as an element of `ℚ(i)`, is the quotient of its numerator
and denominator. -/
lemma algebraMap_eq_div_den (q : ℚ) :
    algebraMap ℚ QI q = ((q.num : ℤ) : QI) / ((q.den : ℤ) : QI) := by
  conv_lhs => rw [← Rat.num_div_den q]
  rw [map_div₀]
  push_cast
  rfl

/-- Every element of `ℚ(i)` is a quotient of two elements of `ℤ[i]`: this is the
surjectivity input to `IsFractionRing.of_field`. -/
lemma exists_div (z : QI) : ∃ x y : Zsqrtd (-1), z = toQI x / toQI y := by
  set a := pb2.repr z 0
  set b := pb2.repr z 1
  refine ⟨⟨(a.num : ℤ) * (b.den : ℤ), (b.num : ℤ) * (a.den : ℤ)⟩,
    ⟨(a.den : ℤ) * (b.den : ℤ), 0⟩, ?_⟩
  have hy : toQI (⟨(a.den : ℤ) * (b.den : ℤ), 0⟩ : Zsqrtd (-1)) ≠ 0 := by
    rw [toQI_mk]
    norm_num
  rw [eq_div_iff hy, coord_eq z, algebraMap_eq_div_den a, algebraMap_eq_div_den b]
  rw [toQI_mk, toQI_mk]
  push_cast
  field_simp
  ring

/-- **`ℚ(i)` is the fraction field of `ℤ[i]`.** -/
instance : IsFractionRing (Zsqrtd (-1)) QI :=
  IsFractionRing.of_field (R := Zsqrtd (-1)) (K := QI) exists_div

/-- **`ℤ[i]` is integrally closed in `ℚ(i)`**: the integral closure of `ℤ` in
`ℚ(i)` is exactly `ℤ[i]`. -/
instance instIsIntegralClosure : IsIntegralClosure (Zsqrtd (-1)) ℤ QI :=
  haveI : Module.Finite ℤ (Zsqrtd (-1)) := Module.Finite.of_basis gaussianBasis
  haveI : Algebra.IsIntegral ℤ (Zsqrtd (-1)) := Algebra.IsIntegral.of_finite ℤ (Zsqrtd (-1))
  IsIntegralClosure.of_isIntegrallyClosed (Zsqrtd (-1)) ℤ QI

/-- **The bridge:** the ring of integers of `ℚ(i)` is `ℤ[i]`. -/
noncomputable def ringOfIntegersEquiv : NumberField.RingOfIntegers QI ≃+* Zsqrtd (-1) :=
  @NumberField.RingOfIntegers.equiv QI _ (Zsqrtd (-1)) _ instAlgebraQI instIsIntegralClosure

end GaussianInt
