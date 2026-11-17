import Mathlib

/-!
# `ℤ[√−2]` is norm-Euclidean

This file proves `EuclideanDomain (Zsqrtd (-2))`, the gate identified for
`d = 2` in [`../../GENERALISATION-QI.md`](../../GENERALISATION-QI.md). Mathlib has
the ring `ℤ[√−2] = Zsqrtd (-2)` and its norm, but no Euclidean structure.

The division algorithm rounds the two rational coordinates of `x / y` to the
nearest integer.  For `z = a + b√−2` with `a b : ℚ`, choosing `m = ⌊a + 1/2⌋`
and `n = ⌊b + 1/2⌋` gives

`N(z − (m + n√−2)) = (a − m)² + 2(b − n)² ≤ 1/4 + 2·1/4 = 3/4 < 1`,

so `N(emod x y) < N(y)`.  The rounding is done without ever constructing
`ℚ(√−2)`: `remRe`/`remIm` are the integer residuals `A − mN`, `B − nN`, where
`x * star y = A + B√−2` and `N = y.norm`.

Consequences proved here: `UniqueFactorizationMonoid (Zsqrtd (-2))` and
`IsIntegrallyClosed (Zsqrtd (-2))`, plus the unit classification
`{±1}` (so `w = 2` for the counting development).

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

namespace ZsqrtdTwo

/-- Abbreviation for `ℤ[√−2]`. -/
abbrev R2 := Zsqrtd (-2)

/-! ## Rounding a rational to the nearest integer -/

/-- The nearest integer to a rational (`⌊q + 1/2⌋`; ties go up). -/
def nearest (q : ℚ) : ℤ := ⌊q + 1 / 2⌋

lemma nearest_spec (q : ℚ) : |q - (nearest q : ℚ)| ≤ 1 / 2 := by
  have hfr : q + 1 / 2 - ((nearest q : ℤ) : ℚ) = Int.fract (q + 1 / 2) := by
    rw [nearest, Int.self_sub_floor]
  have h0 : 0 ≤ Int.fract (q + 1 / 2) := Int.fract_nonneg _
  have h1 : Int.fract (q + 1 / 2) < 1 := Int.fract_lt_one _
  rw [abs_le]
  constructor <;> linarith

/-- Squared rounding error bound, for `N : ℕ`. -/
lemma four_mul_sq_le (A : ℤ) (N : ℕ) (hN : 0 < N) :
    4 * (A - nearest ((A : ℚ) / (N : ℚ)) * (N : ℤ)) ^ 2 ≤ (N : ℤ) ^ 2 := by
  have h := nearest_spec ((A : ℚ) / (N : ℚ))
  have hNq : (0 : ℚ) < (N : ℚ) := by exact_mod_cast hN
  have hNe : (N : ℚ) ≠ 0 := ne_of_gt hNq
  have hdiv : ((A : ℚ) / (N : ℚ) - (nearest ((A : ℚ) / (N : ℚ)) : ℚ)) * (N : ℚ) =
      (A : ℚ) - (nearest ((A : ℚ) / (N : ℚ)) : ℚ) * (N : ℚ) := by field_simp
  have hb : |(A : ℚ) - (nearest ((A : ℚ) / (N : ℚ)) : ℚ) * (N : ℚ)| ≤ (N : ℚ) / 2 := by
    rw [← hdiv, abs_mul, abs_of_pos hNq]
    calc |((A : ℚ) / (N : ℚ) - (nearest ((A : ℚ) / (N : ℚ)) : ℚ))| * (N : ℚ)
        ≤ (1 / 2) * (N : ℚ) := mul_le_mul_of_nonneg_right h hNq.le
      _ = (N : ℚ) / 2 := by ring
  rw [abs_le] at hb
  have hq : ((A : ℚ) - (nearest ((A : ℚ) / (N : ℚ)) : ℚ) * (N : ℚ)) ^ 2 ≤ ((N : ℚ) / 2) ^ 2 := by
    nlinarith [hb.1, hb.2]
  have hc : ((4 : ℤ) * (A - nearest ((A : ℚ) / (N : ℚ)) * (N : ℤ)) ^ 2 : ℚ) ≤ ((N : ℤ) ^ 2 : ℚ) := by
    push_cast
    nlinarith [hq]
  exact_mod_cast hc

/-- Squared rounding error bound, for `N : ℤ`. -/
lemma four_mul_sq_le_int (A N : ℤ) (hN : 0 < N) :
    4 * (A - nearest ((A : ℚ) / (N : ℚ)) * N) ^ 2 ≤ N ^ 2 := by
  have hN' : 0 < N.toNat := by omega
  have hcast : ((N.toNat : ℕ) : ℚ) = (N : ℚ) := by
    have hz := Int.toNat_of_nonneg (le_of_lt hN)
    exact_mod_cast hz
  have h := four_mul_sq_le A N.toNat hN'
  simp only [hcast] at h
  simpa [Int.toNat_of_nonneg (le_of_lt hN)] using h

/-! ## The division algorithm -/

/-- Real residual `A − mN` of `x * star y = A + B√−2` modulo the rounded quotient. -/
def remRe (x y : R2) : ℤ :=
  (x * star y).re - nearest (((x * star y).re : ℚ) / (y.norm : ℚ)) * y.norm

/-- Imaginary residual `B − nN`. -/
def remIm (x y : R2) : ℤ :=
  (x * star y).im - nearest (((x * star y).im : ℚ) / (y.norm : ℚ)) * y.norm

/-- The rounded quotient `x / y` in `ℤ[√−2]`. -/
def ediv (x y : R2) : R2 :=
  ⟨nearest (((x * star y).re : ℚ) / (y.norm : ℚ)),
   nearest (((x * star y).im : ℚ) / (y.norm : ℚ))⟩

/-- The remainder `x − y * (x / y)`. -/
def emod (x y : R2) : R2 := x - y * ediv x y

lemma norm_pos' {z : R2} (hz : z ≠ 0) : 0 < z.norm := by
  have h0 := Zsqrtd.norm_nonneg (by norm_num : (-2 : ℤ) ≤ 0) z
  have hne : z.norm ≠ 0 := by
    intro h
    exact hz ((Zsqrtd.norm_eq_zero_iff (by norm_num : (-2 : ℤ) < 0) z).mp h)
  omega

/-- The key factorisation: the remainder times `N = y.norm` is `y` times the
residual pair. -/
lemma emod_fact (x y : R2) :
    emod x y * (y.norm : R2) = y * (⟨remRe x y, remIm x y⟩ : R2) := by
  have h1 : y * (x * star y) = x * (y.norm : R2) := by
    rw [Zsqrtd.norm_eq_mul_conj]; ring
  have h2 : x * (y.norm : R2) = y * ((y.norm : R2) * (⟨nearest (((x * star y).re : ℚ) / (y.norm : ℚ)),
      nearest (((x * star y).im : ℚ) / (y.norm : ℚ))⟩ : R2) + (⟨remRe x y, remIm x y⟩ : R2)) := by
    rw [← h1]
    congr 1
    ext <;> simp [remRe, remIm] <;> ring
  calc emod x y * (y.norm : R2)
      = x * (y.norm : R2) - y * (⟨nearest (((x * star y).re : ℚ) / (y.norm : ℚ)),
          nearest (((x * star y).im : ℚ) / (y.norm : ℚ))⟩ : R2) * (y.norm : R2) := by
        simp only [emod, ediv]; ring
    _ = y * ((y.norm : R2) * (⟨nearest (((x * star y).re : ℚ) / (y.norm : ℚ)),
          nearest (((x * star y).im : ℚ) / (y.norm : ℚ))⟩ : R2) + (⟨remRe x y, remIm x y⟩ : R2))
          - y * (⟨nearest (((x * star y).re : ℚ) / (y.norm : ℚ)),
          nearest (((x * star y).im : ℚ) / (y.norm : ℚ))⟩ : R2) * (y.norm : R2) := by rw [h2]
    _ = y * (⟨remRe x y, remIm x y⟩ : R2) := by ring

lemma rem_norm_eq (x y : R2) :
    (⟨remRe x y, remIm x y⟩ : R2).norm = (remRe x y) ^ 2 + 2 * (remIm x y) ^ 2 := by
  rw [Zsqrtd.norm_def]; ring

/-- **The Euclidean step:** `N(emod x y) < N(y)` for `y ≠ 0`. -/
lemma emod_norm_lt (x y : R2) (hy : y ≠ 0) :
    (emod x y).norm.natAbs < y.norm.natAbs := by
  have hN : 0 < y.norm := norm_pos' hy
  have hnorm : (emod x y).norm * y.norm = (⟨remRe x y, remIm x y⟩ : R2).norm := by
    have h1 : (emod x y * (y.norm : R2)).norm = (emod x y).norm * (y.norm : R2).norm :=
      Zsqrtd.norm_mul _ _
    rw [emod_fact, Zsqrtd.norm_mul, Zsqrtd.norm_intCast] at h1
    have h2 : y.norm * (⟨remRe x y, remIm x y⟩ : R2).norm =
        y.norm * ((emod x y).norm * y.norm) := by rw [h1]; ring
    exact (mul_left_cancel₀ (ne_of_gt hN) h2).symm
  have hrem : 4 * (⟨remRe x y, remIm x y⟩ : R2).norm ≤ 3 * y.norm ^ 2 := by
    rw [rem_norm_eq]
    have hA := four_mul_sq_le_int (x * star y).re y.norm hN
    have hB := four_mul_sq_le_int (x * star y).im y.norm hN
    simp only [remRe, remIm]
    nlinarith [hA, hB]
  have hb2 : 4 * ((emod x y).norm * y.norm) ≤ 3 * y.norm ^ 2 := by rw [hnorm]; exact hrem
  have hkey : 4 * (emod x y).norm ≤ 3 * y.norm := by
    have h3 : (4 * (emod x y).norm) * y.norm ≤ (3 * y.norm) * y.norm := by nlinarith [hb2]
    exact le_of_mul_le_mul_right h3 hN
  have hlt : (emod x y).norm < y.norm := by omega
  have hnonneg : 0 ≤ (emod x y).norm := Zsqrtd.norm_nonneg (by norm_num) _
  have h1 : ((emod x y).norm.natAbs : ℤ) = (emod x y).norm := Int.natAbs_of_nonneg hnonneg
  have h2 : ((y.norm).natAbs : ℤ) = y.norm := Int.natAbs_of_nonneg (le_of_lt hN)
  omega

lemma norm_mul_le_natAbs (a b : R2) (hb : b ≠ 0) : a.norm.natAbs ≤ (a * b).norm.natAbs := by
  rw [Zsqrtd.norm_mul, Int.natAbs_mul]
  have hb0 : 0 < b.norm := norm_pos' hb
  have hb1 : 0 < b.norm.natAbs := Int.natAbs_pos.mpr (ne_of_gt hb0)
  calc a.norm.natAbs = a.norm.natAbs * 1 := by ring
    _ ≤ a.norm.natAbs * b.norm.natAbs := Nat.mul_le_mul_left _ hb1

lemma ediv_zero (a : R2) : ediv a 0 = 0 := by
  ext <;> (simp [ediv, nearest]; norm_num)

/-! ## The Euclidean domain structure and its consequences -/

instance instEuclideanDomain : EuclideanDomain R2 :=
  { Zsqrtd.commRing, Zsqrtd.nontrivial with
    quotient := ediv
    remainder := emod
    quotient_zero := ediv_zero
    quotient_mul_add_remainder_eq := by
      intro a b
      simp only [emod]
      ring
    r := _
    r_wellFounded := (measure (fun x : R2 => x.norm.natAbs)).wf
    remainder_lt := fun a {b} hb => emod_norm_lt a b hb
    mul_left_not_lt := fun a {b} hb => not_lt_of_ge (norm_mul_le_natAbs a b hb) }

instance instUniqueFactorizationMonoid : UniqueFactorizationMonoid R2 := inferInstance

/-- **The `d = 2` gate:** `ℤ[√−2]` is integrally closed. -/
instance instIsIntegrallyClosed : IsIntegrallyClosed R2 := inferInstance

/-! ## Units: `ℤ[√−2]ˣ = {±1}` -/

lemma unit_norm_eq_one (u : R2ˣ) : (u : R2).norm = 1 := by
  have h := (Zsqrtd.norm_eq_one_iff' (by norm_num : (-2 : ℤ) ≤ 0) (u : R2)).mpr u.isUnit
  exact h

/-- **The unit classification for `d = 2`:** the only units are `±1`, so `w = 2`. -/
lemma unit_eq_one_or_neg_one (u : R2ˣ) : (u : R2) = 1 ∨ (u : R2) = -1 := by
  have hnorm := unit_norm_eq_one u
  rw [Zsqrtd.norm_def] at hnorm
  have him : (u : R2).im = 0 := by
    nlinarith [sq_nonneg ((u : R2).re), sq_nonneg ((u : R2).im)]
  have hre : (u : R2).re = 1 ∨ (u : R2).re = -1 := by
    rw [him] at hnorm
    have hsq : ((u : R2).re) ^ 2 = 1 := by
      rw [pow_two]; simpa using hnorm
    exact sq_eq_one_iff.mp hsq
  rcases hre with h | h
  · left; ext <;> simp [h, him]
  · right; ext <;> simp [h, him]


/-! ## The `ℤ`-basis `{1, √−2}` -/

/-- The two basis vectors `1` and `√−2`. -/
def sqrtdVec : Fin 2 → R2
  | 0 => 1
  | 1 => Zsqrtd.sqrtd

lemma sqrtdVec_linInd : LinearIndependent ℤ sqrtdVec := by
  have h : sqrtdVec = ![(1 : R2), (Zsqrtd.sqrtd : R2)] := by
    funext i; fin_cases i <;> rfl
  rw [h, LinearIndependent.pair_iff]
  intro s t hst
  have hre := congr_arg Zsqrtd.re hst
  have him := congr_arg Zsqrtd.im hst
  simp [Zsqrtd.re_intCast, Zsqrtd.im_intCast] at hre him
  constructor
  · simpa [hre]
  · simpa [him]

lemma sqrtdVec_span : ⊤ ≤ Submodule.span ℤ (Set.range sqrtdVec) := by
  intro x hx
  rw [Submodule.mem_span_range_iff_exists_fun]
  refine ⟨fun i : Fin 2 => if i = 0 then x.re else x.im, ?_⟩
  rw [Fin.sum_univ_two]
  simp [sqrtdVec]
  ext <;> simp

/-- The `ℤ`-basis `{1, √−2}` of `ℤ[√−2]`. -/
noncomputable def sqrtdBasis : Module.Basis (Fin 2) ℤ R2 :=
  Module.Basis.mk sqrtdVec_linInd sqrtdVec_span

end ZsqrtdTwo
