import Mathlib

/-!
# The Eisenstein integers `ℤ[ω]`

`ω = (−1 + √−3)/2` is a primitive cube root of unity, so `ω² + ω + 1 = 0`.
The Eisenstein integers are `ℤ[ω]`, with `ℤ`-basis `{1, ω}` (a *half-integer*
basis: `ω` itself is not in `ℤ[√−3]`). They are the ring of integers of
`ℚ(√−3)`, with `w = 6` units and discriminant `−3`.

This is the `d = 3` ring type required by
[`../../GENERALISATION-QI.md`](../../GENERALISATION-QI.md). Mathlib has no
Eisenstein integers (and no `Zsqrtd`-shaped shortcut, since `discr = −3 ≡ 1
mod 4` forces the half-integer ring). The design follows `Zsqrtd`: a structure
with integer coordinates and the multiplication determined by `ω² = −1 − ω`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

/-- The Eisenstein integers `ℤ[ω]`, written as `a + bω` with `a b : ℤ`. -/
@[ext]
structure EisensteinInt where
  /-- Coefficient of `1`. -/
  re : ℤ
  /-- Coefficient of `ω`. -/
  im : ℤ
  deriving DecidableEq, Repr

namespace EisensteinInt

instance : Zero EisensteinInt := ⟨⟨0, 0⟩⟩
instance : One EisensteinInt := ⟨⟨1, 0⟩⟩
instance : Add EisensteinInt := ⟨fun z w => ⟨z.re + w.re, z.im + w.im⟩⟩
instance : Neg EisensteinInt := ⟨fun z => ⟨-z.re, -z.im⟩⟩
instance : Mul EisensteinInt :=
  ⟨fun z w => ⟨z.re * w.re - z.im * w.im, z.re * w.im + z.im * w.re - z.im * w.im⟩⟩

@[simp] theorem re_zero : (0 : EisensteinInt).re = 0 := rfl
@[simp] theorem im_zero : (0 : EisensteinInt).im = 0 := rfl
@[simp] theorem re_one : (1 : EisensteinInt).re = 1 := rfl
@[simp] theorem im_one : (1 : EisensteinInt).im = 0 := rfl
@[simp] theorem re_add (z w : EisensteinInt) : (z + w).re = z.re + w.re := rfl
@[simp] theorem im_add (z w : EisensteinInt) : (z + w).im = z.im + w.im := rfl
@[simp] theorem re_neg (z : EisensteinInt) : (-z).re = -z.re := rfl
@[simp] theorem im_neg (z : EisensteinInt) : (-z).im = -z.im := rfl
@[simp] theorem re_mul (z w : EisensteinInt) :
    (z * w).re = z.re * w.re - z.im * w.im := rfl
@[simp] theorem im_mul (z w : EisensteinInt) :
    (z * w).im = z.re * w.im + z.im * w.re - z.im * w.im := rfl

instance instAddCommGroup : AddCommGroup EisensteinInt := by
  refine
    { sub := fun a b => a + -b
      nsmul := @nsmulRec EisensteinInt ⟨0⟩ ⟨(· + ·)⟩
      zsmul := @zsmulRec EisensteinInt ⟨0⟩ ⟨(· + ·)⟩ ⟨Neg.neg⟩
        (@nsmulRec EisensteinInt ⟨0⟩ ⟨(· + ·)⟩)
      add_assoc := ?_
      zero_add := ?_
      add_zero := ?_
      neg_add_cancel := ?_
      add_comm := ?_ } <;>
  intros <;> ext <;> simp [add_comm, add_left_comm]

@[simp] theorem re_sub (z w : EisensteinInt) : (z - w).re = z.re - w.re := by
  simp [sub_eq_add_neg]

@[simp] theorem im_sub (z w : EisensteinInt) : (z - w).im = z.im - w.im := by
  simp [sub_eq_add_neg]

instance instAddGroupWithOne : AddGroupWithOne EisensteinInt :=
  { EisensteinInt.instAddCommGroup with
    natCast := fun n => ⟨n, 0⟩
    intCast := fun n => ⟨n, 0⟩ }

instance instCommRing : CommRing EisensteinInt := by
  refine
    { EisensteinInt.instAddGroupWithOne with
      npow := @npowRec EisensteinInt ⟨1⟩ ⟨(· * ·)⟩
      add_comm := ?_
      left_distrib := ?_
      right_distrib := ?_
      zero_mul := ?_
      mul_zero := ?_
      mul_assoc := ?_
      one_mul := ?_
      mul_one := ?_
      mul_comm := ?_ } <;>
  intros <;> ext <;> simp <;> ring

@[simp] theorem re_mk (a b : ℤ) : (⟨a, b⟩ : EisensteinInt).re = a := rfl
@[simp] theorem im_mk (a b : ℤ) : (⟨a, b⟩ : EisensteinInt).im = b := rfl
@[simp] theorem re_intCast (n : ℤ) : (n : EisensteinInt).re = n := rfl
@[simp] theorem im_intCast (n : ℤ) : (n : EisensteinInt).im = 0 := rfl
@[simp] theorem re_natCast (n : ℕ) : (n : EisensteinInt).re = (n : ℤ) := rfl
@[simp] theorem im_natCast (n : ℕ) : (n : EisensteinInt).im = 0 := rfl

instance instInfinite : Infinite EisensteinInt :=
  Infinite.of_injective (fun n : ℤ => (⟨n, 0⟩ : EisensteinInt)) (by
    intro a b h
    simpa using congr_arg EisensteinInt.re h)

instance : Nontrivial EisensteinInt :=
  ⟨⟨0, 1, by intro h; have := congr_arg EisensteinInt.re h; simp at this⟩⟩

/-- The primitive cube root of unity `ω ∈ ℤ[ω]`. -/
def omega : EisensteinInt := ⟨0, 1⟩

@[simp] theorem re_omega : omega.re = 0 := rfl
@[simp] theorem im_omega : omega.im = 1 := rfl

/-- `ω² = −1 − ω`. -/
theorem omega_sq : omega ^ 2 = -1 - omega := by
  ext <;> simp [omega, pow_two] <;> norm_num

theorem omega_sq_add_omega_add_one : omega ^ 2 + omega + 1 = 0 := by
  rw [omega_sq]; ring

/-- Conjugation `a + bω ↦ a + bω² = (a − b) − bω`. -/
def star (z : EisensteinInt) : EisensteinInt := ⟨z.re - z.im, -z.im⟩

instance : Star EisensteinInt where
  star := star

@[simp] theorem star_mk (a b : ℤ) : star (⟨a, b⟩ : EisensteinInt) = ⟨a - b, -b⟩ := rfl
@[simp] theorem re_star (z : EisensteinInt) : (star z).re = z.re - z.im := rfl
@[simp] theorem im_star (z : EisensteinInt) : (star z).im = -z.im := rfl

/-- The norm form `N(a + bω) = a² − ab + b²`. -/
def normE (z : EisensteinInt) : ℤ := z.re ^ 2 - z.re * z.im + z.im ^ 2

@[simp] theorem normE_mk (a b : ℤ) : normE (⟨a, b⟩ : EisensteinInt) = a ^ 2 - a * b + b ^ 2 := rfl

/-- **The norm is multiplicative.** -/
theorem normE_mul (z w : EisensteinInt) : normE (z * w) = normE z * normE w := by
  simp only [normE, re_mul, im_mul]; ring

theorem normE_zero : normE (0 : EisensteinInt) = 0 := by simp [normE]

theorem normE_one : normE (1 : EisensteinInt) = 1 := by simp [normE]

theorem normE_nonneg (z : EisensteinInt) : 0 ≤ normE z := by
  have h : 4 * normE z = (2 * z.re - z.im) ^ 2 + 3 * z.im ^ 2 := by
    simp only [normE]; ring
  nlinarith [sq_nonneg (2 * z.re - z.im), sq_nonneg z.im]

theorem normE_eq_zero_iff {z : EisensteinInt} : normE z = 0 ↔ z = 0 := by
  constructor
  · intro h
    have hd : (2 * z.re - z.im) ^ 2 + 3 * z.im ^ 2 = 0 := by
      have : 4 * normE z = (2 * z.re - z.im) ^ 2 + 3 * z.im ^ 2 := by
        simp only [normE]; ring
      rw [h] at this; omega
    have him : z.im = 0 := by nlinarith [sq_nonneg (2 * z.re - z.im), sq_nonneg z.im]
    have hre : z.re = 0 := by
      rw [him] at hd; nlinarith [sq_nonneg (2 * z.re)]
    ext <;> simp [hre, him]
  · rintro rfl; simp [normE]

theorem normE_pos {z : EisensteinInt} (hz : z ≠ 0) : 0 < normE z := by
  have h0 := normE_nonneg z
  have hne : normE z ≠ 0 := fun h => hz (normE_eq_zero_iff.mp h)
  omega

/-- `z * star z = N(z)`. -/
theorem mul_star (z : EisensteinInt) : z * star z = (normE z : EisensteinInt) := by
  ext <;> simp [normE, star, pow_two] <;> ring


/-! ## The `ℤ`-basis `{1, ω}` -/

/-- The two basis vectors `1` and `ω`. -/
def basisVec : Fin 2 → EisensteinInt
  | 0 => 1
  | 1 => omega

lemma basisVec_linInd : LinearIndependent ℤ basisVec := by
  have h : basisVec = ![(1 : EisensteinInt), omega] := by
    funext i; fin_cases i <;> rfl
  rw [h, LinearIndependent.pair_iff]
  intro s t hst
  have hre := congr_arg EisensteinInt.re hst
  have him := congr_arg EisensteinInt.im hst
  simp at hre him
  exact ⟨hre, him⟩

lemma basisVec_span : ⊤ ≤ Submodule.span ℤ (Set.range basisVec) := by
  intro x hx
  rw [Submodule.mem_span_range_iff_exists_fun]
  refine ⟨fun i : Fin 2 => if i = 0 then x.re else x.im, ?_⟩
  rw [Fin.sum_univ_two]
  simp [basisVec]
  ext <;> simp

/-- The `ℤ`-basis `{1, ω}` of the Eisenstein integers. -/
noncomputable def eisensteinBasis : Module.Basis (Fin 2) ℤ EisensteinInt :=
  Module.Basis.mk basisVec_linInd basisVec_span

end EisensteinInt

namespace EisensteinInt

/-- `z` is a unit iff its norm is `1`. -/
theorem isUnit_iff_normE_eq_one {z : EisensteinInt} : IsUnit z ↔ normE z = 1 := by
  constructor
  · rintro ⟨u, rfl⟩
    have h : normE ((u : EisensteinInt) * ↑u⁻¹) = normE (1 : EisensteinInt) := by
      rw [Units.mul_inv]
    rw [normE_mul, normE_one] at h
    set N := normE (u : EisensteinInt) with hN
    have hdvd : N ∣ 1 := ⟨_, h.symm⟩
    have hle : N ≤ 1 := Int.le_of_dvd one_pos hdvd
    have h0 : 0 ≤ N := hN ▸ normE_nonneg (u : EisensteinInt)
    have hpos : N ≠ 0 := by
      rw [hN]
      exact (normE_eq_zero_iff.not.mpr (Units.ne_zero u))
    omega
  · intro h
    exact ⟨⟨z, star z, by rw [mul_star, h]; rfl, by rw [mul_comm, mul_star, h]; rfl⟩, rfl⟩

lemma unit_normE_eq_one (u : EisensteinIntˣ) : normE (u : EisensteinInt) = 1 :=
  isUnit_iff_normE_eq_one.mp u.isUnit

/-- **The unit classification:** a norm-one Eisenstein integer is one of
`±1, ±ω, ±ω²`. -/
theorem normE_eq_one_cases {z : EisensteinInt} (h : normE z = 1) :
    (z = 1) ∨ (z = -1) ∨ (z = omega) ∨ (z = -omega) ∨
      (z = -1 - omega) ∨ (z = 1 + omega) := by
  obtain ⟨a, b, rfl⟩ : ∃ a b, z = (⟨a, b⟩ : EisensteinInt) := ⟨z.re, z.im, rfl⟩
  simp only [normE_mk] at h
  have h4 : (2 * a - b) ^ 2 + 3 * b ^ 2 = 4 := by
    have hh : 4 * (a ^ 2 - a * b + b ^ 2) = (2 * a - b) ^ 2 + 3 * b ^ 2 := by ring
    linarith
  have hb1 : -1 ≤ b := by nlinarith [sq_nonneg (2 * a - b), sq_nonneg b]
  have hb2 : b ≤ 1 := by nlinarith [sq_nonneg (2 * a - b), sq_nonneg b]
  have ha1 : -1 ≤ a := by
    nlinarith [sq_nonneg (2 * a - b), sq_nonneg b, sq_nonneg (2 * a - b - 2),
      sq_nonneg (2 * a - b + 2)]
  have ha2 : a ≤ 1 := by
    nlinarith [sq_nonneg (2 * a - b), sq_nonneg b, sq_nonneg (2 * a - b - 2),
      sq_nonneg (2 * a - b + 2)]
  interval_cases b <;> interval_cases a <;>
    simp_all [normE_mk, omega, sub_eq_add_neg] <;> decide

/-- The six units, as a finset. -/
def units6 : Finset EisensteinInt :=
  {1, -1, omega, -omega, -1 - omega, 1 + omega}

theorem units6_card : units6.card = 6 := by
  decide

theorem mem_units6 {z : EisensteinInt} (hz : IsUnit z) : z ∈ units6 := by
  have h := isUnit_iff_normE_eq_one.mp hz
  rcases normE_eq_one_cases h with rfl | rfl | rfl | rfl | rfl | rfl <;> simp [units6]

theorem isUnit_of_mem_units6 {z : EisensteinInt} (hz : z ∈ units6) : IsUnit z := by
  simp only [units6, Finset.mem_insert, Finset.mem_singleton] at hz
  rcases hz with rfl | rfl | rfl | rfl | rfl | rfl <;>
    rw [isUnit_iff_normE_eq_one] <;> simp [normE]

/-- The equivalence between the six explicit units and the unit group. -/
noncomputable def unitsEquivUnits6 : {z : EisensteinInt // z ∈ units6} ≃ EisensteinIntˣ :=
  { toFun := fun z => (isUnit_of_mem_units6 z.2).unit
    invFun := fun u => ⟨(u : EisensteinInt), mem_units6 u.isUnit⟩
    left_inv := fun z => Subtype.ext (IsUnit.unit_spec (isUnit_of_mem_units6 z.2))
    right_inv := fun u => Units.ext (IsUnit.unit_spec u.isUnit) }

/-- The unit group has cardinality `6`; this is the `w` of the counting
development. -/
theorem units_card_six : Nat.card EisensteinIntˣ = 6 := by
  let e := unitsEquivUnits6
  rw [← Nat.card_congr e]
  haveI : Fintype {z : EisensteinInt // z ∈ units6} := Fintype.subtype units6 (fun z => Iff.rfl)
  rw [Nat.card_eq_fintype_card]
  have hc : Fintype.card {z : EisensteinInt // z ∈ units6} = units6.card :=
    Fintype.card_of_subtype units6 (fun z => Iff.rfl)
  rw [hc, units6_card]

end EisensteinInt

namespace EisensteinInt

/-! ## The Euclidean division -/

/-- Nearest integer to a rational (ties go up). -/
def nearest (q : ℚ) : ℤ := ⌊q + 1 / 2⌋

lemma nearest_spec (q : ℚ) : |q - (nearest q : ℚ)| ≤ 1 / 2 := by
  have hfr : q + 1 / 2 - ((nearest q : ℤ) : ℚ) = Int.fract (q + 1 / 2) := by
    rw [nearest, Int.self_sub_floor]
  have h0 : 0 ≤ Int.fract (q + 1 / 2) := Int.fract_nonneg _
  have h1 : Int.fract (q + 1 / 2) < 1 := Int.fract_lt_one _
  rw [abs_le]
  constructor <;> linarith

/-- The imaginary rounding `n`. -/
def divN (x y : EisensteinInt) : ℤ := nearest (((x * star y).im : ℚ) / (normE y : ℚ))

/-- The real rounding `m`, shifted by the imaginary rounding error. -/
def divM (x y : EisensteinInt) : ℤ :=
  nearest (((x * star y).re : ℚ) / (normE y : ℚ) -
    (((x * star y).im : ℚ) / (normE y : ℚ) - (divN x y : ℚ)) / 2)

/-- The rounded quotient. -/
def ediv (x y : EisensteinInt) : EisensteinInt := ⟨divM x y, divN x y⟩

/-- The remainder. -/
def emod (x y : EisensteinInt) : EisensteinInt := x - y * ediv x y

/-- Real residual. -/
def remRe (x y : EisensteinInt) : ℤ := (x * star y).re - divM x y * normE y

/-- Imaginary residual. -/
def remIm (x y : EisensteinInt) : ℤ := (x * star y).im - divN x y * normE y

abbrev residual (x y : EisensteinInt) : EisensteinInt := ⟨remRe x y, remIm x y⟩

lemma residual_normE (x y : EisensteinInt) :
    normE (residual x y) = (remRe x y) ^ 2 - remRe x y * remIm x y + (remIm x y) ^ 2 := rfl

/-- The factorisation of the remainder. -/
lemma emod_fact (x y : EisensteinInt) :
    emod x y * (normE y : EisensteinInt) = y * residual x y := by
  have h1 : y * (x * star y) = x * (normE y : EisensteinInt) := by
    rw [← mul_star y]; ring
  have h2 : x * (normE y : EisensteinInt) =
      y * ((normE y : EisensteinInt) * (⟨divM x y, divN x y⟩ : EisensteinInt) + residual x y) := by
    rw [← h1]
    congr 1
    ext <;> simp [residual, remRe, remIm] <;> ring
  calc emod x y * (normE y : EisensteinInt)
      = x * (normE y : EisensteinInt) -
          y * (⟨divM x y, divN x y⟩ : EisensteinInt) * (normE y : EisensteinInt) := by
        simp only [emod, ediv]; ring
    _ = y * ((normE y : EisensteinInt) * (⟨divM x y, divN x y⟩ : EisensteinInt) + residual x y)
          - y * (⟨divM x y, divN x y⟩ : EisensteinInt) * (normE y : EisensteinInt) := by rw [h2]
    _ = y * residual x y := by ring

/-- A rounding bound: `(2(B − nN))² ≤ N²` when `|B/N − n| ≤ 1/2`. -/
lemma remIm_bound (B N n : ℤ) (hN : 0 < N)
    (h : |(B : ℚ) / (N : ℚ) - (n : ℚ)| ≤ 1 / 2) :
    (2 * (B - n * N)) ^ 2 ≤ N ^ 2 := by
  have hNq : (0 : ℚ) < (N : ℚ) := by exact_mod_cast hN
  have hNe : (N : ℚ) ≠ 0 := ne_of_gt hNq
  have heq : ((B : ℚ) - (n : ℚ) * (N : ℚ)) = ((B : ℚ) / (N : ℚ) - (n : ℚ)) * (N : ℚ) := by
    field_simp
  have hb : |(B : ℚ) - (n : ℚ) * (N : ℚ)| ≤ (N : ℚ) / 2 := by
    rw [heq, abs_mul, abs_of_pos hNq]
    calc |((B : ℚ) / (N : ℚ) - (n : ℚ))| * (N : ℚ) ≤ (1 / 2) * (N : ℚ) :=
          mul_le_mul_of_nonneg_right h hNq.le
      _ = (N : ℚ) / 2 := by ring
  rw [abs_le] at hb
  have hq : ((B : ℚ) - (n : ℚ) * (N : ℚ)) ^ 2 ≤ ((N : ℚ) / 2) ^ 2 := by nlinarith [hb.1, hb.2]
  have hc : (((2 : ℤ) * (B - n * N)) ^ 2 : ℚ) ≤ ((N : ℤ) ^ 2 : ℚ) := by
    push_cast
    nlinarith [hq]
  exact_mod_cast hc

/-- A shifted rounding bound: `(2(A − mN) − (B − nN))² ≤ N²` when the error of
`m` relative to the half-shifted quotient is at most `1/2`. -/
lemma remRe_bound (A B N m n : ℤ) (hN : 0 < N)
    (h : |(A : ℚ) / (N : ℚ) - ((B : ℚ) / (N : ℚ) - (n : ℚ)) / 2 - (m : ℚ)| ≤ 1 / 2) :
    (2 * (A - m * N) - (B - n * N)) ^ 2 ≤ N ^ 2 := by
  have hNq : (0 : ℚ) < (N : ℚ) := by exact_mod_cast hN
  have hNe : (N : ℚ) ≠ 0 := ne_of_gt hNq
  have heq : ((2 : ℚ) * ((A : ℚ) - (m : ℚ) * (N : ℚ)) - ((B : ℚ) - (n : ℚ) * (N : ℚ))) =
      2 * (N : ℚ) * ((A : ℚ) / (N : ℚ) - ((B : ℚ) / (N : ℚ) - (n : ℚ)) / 2 - (m : ℚ)) := by
    field_simp
    ring
  have hb : |(2 : ℚ) * ((A : ℚ) - (m : ℚ) * (N : ℚ)) - ((B : ℚ) - (n : ℚ) * (N : ℚ))| ≤
      (N : ℚ) := by
    rw [heq, abs_mul, abs_mul, abs_of_pos hNq, abs_two]
    calc (2 : ℚ) * (N : ℚ) * |((A : ℚ) / (N : ℚ) -
        ((B : ℚ) / (N : ℚ) - (n : ℚ)) / 2 - (m : ℚ))|
        ≤ 2 * (N : ℚ) * (1 / 2) := by
          apply mul_le_mul_of_nonneg_left h
          positivity
      _ = (N : ℚ) := by ring
  rw [abs_le] at hb
  have hq : ((2 : ℚ) * ((A : ℚ) - (m : ℚ) * (N : ℚ)) -
      ((B : ℚ) - (n : ℚ) * (N : ℚ))) ^ 2 ≤ (N : ℚ) ^ 2 := by nlinarith [hb.1, hb.2]
  have hc : (((2 * (A - m * N) - (B - n * N)) ^ 2 : ℤ) : ℚ) ≤ ((N : ℤ) ^ 2 : ℚ) := by
    push_cast
    nlinarith [hq]
  exact_mod_cast hc

/-- Bound on the imaginary residual: `(2 R_im)² ≤ N²`. -/
lemma remIm_sq_le (x y : EisensteinInt) (hN : 0 < normE y) :
    (2 * remIm x y) ^ 2 ≤ (normE y) ^ 2 :=
  remIm_bound _ _ _ hN (nearest_spec _)

/-- Bound on the shifted real residual: `(2 R_re − R_im)² ≤ N²`. -/
lemma remRe_sq_le (x y : EisensteinInt) (hN : 0 < normE y) :
    (2 * remRe x y - remIm x y) ^ 2 ≤ (normE y) ^ 2 :=
  remRe_bound _ _ _ _ _ hN (nearest_spec _)

/-- The residual has small norm: `16 N(residual) ≤ 7 N(y)²`. -/
lemma residual_bound (x y : EisensteinInt) (hN : 0 < normE y) :
    16 * normE (residual x y) ≤ 7 * (normE y) ^ 2 := by
  have h1 := remIm_sq_le x y hN
  have h2 := remRe_sq_le x y hN
  rw [residual_normE]
  nlinarith [h1, h2]

/-- **The Euclidean step:** `N(emod x y) < N(y)` for `y ≠ 0`. -/
lemma emod_normE_lt (x y : EisensteinInt) (hy : y ≠ 0) :
    normE (emod x y) < normE y := by
  have hN : 0 < normE y := normE_pos hy
  have hnorm : normE (emod x y) * normE y = normE (residual x y) := by
    have h1 : normE (emod x y * (normE y : EisensteinInt)) =
        normE (emod x y) * normE (normE y : EisensteinInt) := normE_mul _ _
    rw [emod_fact, normE_mul] at h1
    -- normE (N : E) = N²
    have hcast : normE (normE y : EisensteinInt) = (normE y) ^ 2 := by
      simp only [normE, re_intCast, im_intCast]; ring
    rw [hcast] at h1
    have h2 : normE y * normE (residual x y) = normE y * (normE (emod x y) * normE y) := by
      rw [h1]; ring
    exact (mul_left_cancel₀ (ne_of_gt hN) h2).symm
  have hbound := residual_bound x y hN
  rw [← hnorm] at hbound
  have hkey : 16 * normE (emod x y) ≤ 7 * normE y := by
    have h3 : (16 * normE (emod x y)) * normE y ≤ (7 * normE y) * normE y := by
      nlinarith [hbound]
    exact le_of_mul_le_mul_right h3 hN
  omega

lemma normE_mul_le (a b : EisensteinInt) (hb : b ≠ 0) :
    normE a ≤ normE (a * b) := by
  rw [normE_mul]
  have hb0 : 0 < normE b := normE_pos hb
  have h1 : 1 ≤ normE b := by omega
  calc normE a = normE a * 1 := by ring
    _ ≤ normE a * normE b := by nlinarith [normE_nonneg a, h1]

end EisensteinInt

namespace EisensteinInt

lemma natAbs_normE_emod_lt (a b : EisensteinInt) (hb : b ≠ 0) :
    (normE (emod a b)).natAbs < (normE b).natAbs := by
  have h := emod_normE_lt a b hb
  have h1 : 0 ≤ normE (emod a b) := normE_nonneg _
  have h2 : 0 ≤ normE b := normE_nonneg _
  have e1 : ((normE (emod a b)).natAbs : ℤ) = normE (emod a b) := Int.natAbs_of_nonneg h1
  have e2 : ((normE b).natAbs : ℤ) = normE b := Int.natAbs_of_nonneg h2
  omega

lemma natAbs_normE_le_mul (a b : EisensteinInt) (hb : b ≠ 0) :
    (normE a).natAbs ≤ (normE (a * b)).natAbs := by
  have h := normE_mul_le a b hb
  have h1 : 0 ≤ normE a := normE_nonneg _
  have h2 : 0 ≤ normE (a * b) := normE_nonneg _
  have e1 : ((normE a).natAbs : ℤ) = normE a := Int.natAbs_of_nonneg h1
  have e2 : ((normE (a * b)).natAbs : ℤ) = normE (a * b) := Int.natAbs_of_nonneg h2
  omega

lemma ediv_zero (a : EisensteinInt) : ediv a 0 = 0 := by
  ext <;> simp [ediv, divM, divN, nearest] <;> norm_num

instance instEuclideanDomain : EuclideanDomain EisensteinInt :=
  { EisensteinInt.instCommRing, EisensteinInt.instNontrivial with
    quotient := ediv
    remainder := emod
    quotient_zero := ediv_zero
    quotient_mul_add_remainder_eq := by
      intro a b
      simp only [emod]
      ring
    r := _
    r_wellFounded := (measure (fun x : EisensteinInt => (normE x).natAbs)).wf
    remainder_lt := fun a {b} hb => natAbs_normE_emod_lt a b hb
    mul_left_not_lt := fun a {b} hb => not_lt_of_ge (natAbs_normE_le_mul a b hb) }

instance instUniqueFactorizationMonoid : UniqueFactorizationMonoid EisensteinInt := inferInstance

/-- **The `d = 3` gate:** the Eisenstein integers are integrally closed. -/
instance instIsIntegrallyClosed : IsIntegrallyClosed EisensteinInt := inferInstance

end EisensteinInt
