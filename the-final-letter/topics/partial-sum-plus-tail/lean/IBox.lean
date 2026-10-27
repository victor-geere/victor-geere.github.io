/-
  IBox.lean

  A checked-certificate interval-arithmetic layer over `ℚ`, with an
  extension to complex rectangles (`Cx`).

  This file is self-contained: it only imports a small part of Mathlib.
  No unsound placeholder is used, and no `native_decide` is used; every
  theorem is a kernel-checked proof.

  Design notes / deviations from the written spec (see also the report):

  * `Iv` has *rational* endpoints, but `Cx.mem` is stated for `z : ℂ`, whose
    coordinates are *real*.  The original one-liner `Z.re.mem z.re` therefore
    does not typecheck.  We keep `Iv.mem : ℚ → Iv → Prop` exactly as specified
    and add a real-coordinate variant `Iv.memR : ℝ → Iv → Prop`; `Cx.mem` is
    then `Z.re.memR z.re ∧ Z.im.memR z.im`, which is the intended meaning.

  * `Cx.mem_inflate` needs the hypothesis `0 ≤ r` to be true (for `r < 0`
    `inflate` shrinks the box and is *not* sound).  We add it, matching
    `Iv.mem_inflate`.

  * `Iv.mem_inflate` is stated with the corrected signature
    `(A.inflate r).mem x` (the spec text had the `A` repeated).
-/
import Mathlib.Data.Rat.Defs
import Mathlib.Basic.Complex.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Order.MinMax

namespace PartialTail

/-! ## Four-corner `min`/`max` -/

/-- `min4 a b c d = min (min a b) (min c d)`. -/
def min4 {α : Type*} [Min α] (a b c d : α) : α := min (min a b) (min c d)

/-- `max4 a b c d = max (max a b) (max c d)`. -/
def max4 {α : Type*} [Max α] (a b c d : α) : α := max (max a b) (max c d)

section OrderLemmas
variable {α : Type*} [LinearOrder α]

theorem min4_le_left (a b c d : α) : min4 a b c d ≤ a :=
  le_trans (min_le_left _ _) (min_le_left _ _)

theorem min4_le_right (a b c d : α) : min4 a b c d ≤ b :=
  le_trans (min_le_left _ _) (min_le_right _ _)

theorem min4_le_third (a b c d : α) : min4 a b c d ≤ c :=
  le_trans (min_le_right _ _) (min_le_left _ _)

theorem min4_le_fourth (a b c d : α) : min4 a b c d ≤ d :=
  le_trans (min_le_right _ _) (min_le_right _ _)

theorem le_max4_left (a b c d : α) : a ≤ max4 a b c d :=
  le_trans (le_max_left _ _) (le_max_left _ _)

theorem le_max4_right (a b c d : α) : b ≤ max4 a b c d :=
  le_trans (le_max_right _ _) (le_max_left _ _)

theorem le_max4_third (a b c d : α) : c ≤ max4 a b c d :=
  le_trans (le_max_left _ _) (le_max_right _ _)

theorem le_max4_fourth (a b c d : α) : d ≤ max4 a b c d :=
  le_trans (le_max_right _ _) (le_max_right _ _)

end OrderLemmas

/-! ## Bilinear bounds: `x ∈ [a₁,a₂]`, `y ∈ [b₁,b₂]`

These are stated over an arbitrary linearly ordered commutative ring so that
they can be instantiated both at `ℚ` (for `Iv`) and at `ℝ` (for `Cx`). -/

section Bilinear
variable {R : Type*} [CommRing R] [LinearOrder R] [IsStrictOrderedRing R]

/-- For fixed `y`, the minimum of `x * y` over `x ∈ [a₁,a₂]` is attained at an
endpoint of `[a₁,a₂]`. -/
theorem min_mul_endpoints (a₁ a₂ x y : R) (h₁ : a₁ ≤ x) (h₂ : x ≤ a₂) :
    min (a₁ * y) (a₂ * y) ≤ x * y := by
  rcases le_total 0 y with hy | hy
  · exact le_trans (min_le_left _ _) (mul_le_mul_of_nonneg_right h₁ hy)
  · exact le_trans (min_le_right _ _) (mul_le_mul_of_nonpos_right h₂ hy)

/-- For fixed `x`, the minimum of `x * y` over `y ∈ [b₁,b₂]` is attained at an
endpoint of `[b₁,b₂]`. -/
theorem min_mul_two (x b₁ b₂ y : R) (h₁ : b₁ ≤ y) (h₂ : y ≤ b₂) :
    min (x * b₁) (x * b₂) ≤ x * y := by
  rcases le_total 0 x with hx | hx
  · exact le_trans (min_le_left _ _) (mul_le_mul_of_nonneg_left h₁ hx)
  · exact le_trans (min_le_right _ _) (mul_le_mul_of_nonpos_left h₂ hx)

/-- For fixed `y`, the maximum of `x * y` over `x ∈ [a₁,a₂]` is attained at an
endpoint of `[a₁,a₂]`. -/
theorem mul_endpoints_le_max (a₁ a₂ x y : R) (h₁ : a₁ ≤ x) (h₂ : x ≤ a₂) :
    x * y ≤ max (a₁ * y) (a₂ * y) := by
  rcases le_total 0 y with hy | hy
  · exact le_trans (mul_le_mul_of_nonneg_right h₂ hy) (le_max_right _ _)
  · exact le_trans (mul_le_mul_of_nonpos_right h₁ hy) (le_max_left _ _)

/-- For fixed `x`, the maximum of `x * y` over `y ∈ [b₁,b₂]` is attained at an
endpoint of `[b₁,b₂]`. -/
theorem mul_le_max_two (x b₁ b₂ y : R) (h₁ : b₁ ≤ y) (h₂ : y ≤ b₂) :
    x * y ≤ max (x * b₁) (x * b₂) := by
  rcases le_total 0 x with hx | hx
  · exact le_trans (mul_le_mul_of_nonneg_left h₂ hx) (le_max_right _ _)
  · exact le_trans (mul_le_mul_of_nonpos_left h₁ hx) (le_max_left _ _)

/-- Four-corner lower bound for a product: if `a₁ ≤ x ≤ a₂` and `b₁ ≤ y ≤ b₂`
then `x * y` is at least the minimum of the four endpoint products. -/
theorem min4_mul_le (a₁ a₂ b₁ b₂ x y : R)
    (hx₁ : a₁ ≤ x) (hx₂ : x ≤ a₂) (hy₁ : b₁ ≤ y) (hy₂ : y ≤ b₂) :
    min4 (a₁ * b₁) (a₁ * b₂) (a₂ * b₁) (a₂ * b₂) ≤ x * y := by
  refine le_trans ?_ (min_mul_two x b₁ b₂ y hy₁ hy₂)
  apply le_min
  · exact le_trans (le_min (min4_le_left _ _ _ _) (min4_le_third _ _ _ _))
      (min_mul_endpoints a₁ a₂ x b₁ hx₁ hx₂)
  · exact le_trans (le_min (min4_le_right _ _ _ _) (min4_le_fourth _ _ _ _))
      (min_mul_endpoints a₁ a₂ x b₂ hx₁ hx₂)

/-- Four-corner upper bound for a product: if `a₁ ≤ x ≤ a₂` and `b₁ ≤ y ≤ b₂`
then `x * y` is at most the maximum of the four endpoint products. -/
theorem mul_le_max4 (a₁ a₂ b₁ b₂ x y : R)
    (hx₁ : a₁ ≤ x) (hx₂ : x ≤ a₂) (hy₁ : b₁ ≤ y) (hy₂ : y ≤ b₂) :
    x * y ≤ max4 (a₁ * b₁) (a₁ * b₂) (a₂ * b₁) (a₂ * b₂) := by
  refine le_trans (mul_le_max_two x b₁ b₂ y hy₁ hy₂) ?_
  apply max_le
  · exact le_trans (mul_endpoints_le_max a₁ a₂ x b₁ hx₁ hx₂)
      (max_le (le_max4_left _ _ _ _) (le_max4_third _ _ _ _))
  · exact le_trans (mul_endpoints_le_max a₁ a₂ x b₂ hx₁ hx₂)
      (max_le (le_max4_right _ _ _ _) (le_max4_fourth _ _ _ _))

end Bilinear

/-! ## Real intervals with rational endpoints -/

/-- A closed interval `[lo, hi]` with rational endpoints.  Note that `lo ≤ hi`
is *not* a field: the certificate checker verifies it separately. -/
structure Iv where
  lo : ℚ
  hi : ℚ
deriving DecidableEq, Repr

namespace Iv

/-- Rational membership. -/
def mem (x : ℚ) (I : Iv) : Prop := I.lo ≤ x ∧ x ≤ I.hi

/-- Real membership (used for the complex layer): the real number `x` lies
between the (coerced) rational endpoints. -/
def memR (x : ℝ) (I : Iv) : Prop := (I.lo : ℝ) ≤ x ∧ x ≤ (I.hi : ℝ)

def add (A B : Iv) : Iv := ⟨A.lo + B.lo, A.hi + B.hi⟩

def neg (A : Iv) : Iv := ⟨-A.hi, -A.lo⟩

def sub (A B : Iv) : Iv := add A (neg B)

/-- Multiply by a rational scalar, with the endpoint order corrected for the
sign of the scalar. -/
def scale (q : ℚ) (A : Iv) : Iv :=
  if 0 ≤ q then ⟨q * A.lo, q * A.hi⟩ else ⟨q * A.hi, q * A.lo⟩

/-- Four-corner product. -/
def mul (A B : Iv) : Iv :=
  ⟨min4 (A.lo * B.lo) (A.lo * B.hi) (A.hi * B.lo) (A.hi * B.hi),
   max4 (A.lo * B.lo) (A.lo * B.hi) (A.hi * B.lo) (A.hi * B.hi)⟩

@[simp] lemma zero_mul (A : Iv) : (⟨0, 0⟩ : Iv).mul A = ⟨0, 0⟩ := by
  simp [mul, min4, max4]

@[simp] lemma mul_zero (A : Iv) : A.mul (⟨0, 0⟩ : Iv) = ⟨0, 0⟩ := by
  simp [mul, min4, max4]

@[simp] lemma add_zero (A : Iv) : A.add ⟨0, 0⟩ = A := by
  simp [add]

@[simp] lemma zero_add (A : Iv) : (⟨0, 0⟩ : Iv).add A = A := by
  simp [add]

@[simp] lemma sub_zero (A : Iv) : A.sub ⟨0, 0⟩ = A := by
  simp [sub, add, neg]

/-- Add `± r` to the endpoints; `r ≥ 0` is required for soundness. -/
def inflate (r : ℚ) (A : Iv) : Iv := ⟨A.lo - r, A.hi + r⟩

/-! ### Soundness over `ℚ` -/

theorem mem_add {x y : ℚ} {A B : Iv} (hx : A.mem x) (hy : B.mem y) :
    (A.add B).mem (x + y) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  obtain ⟨hy₁, hy₂⟩ := hy
  constructor
  · change A.lo + B.lo ≤ x + y
    linarith
  · change x + y ≤ A.hi + B.hi
    linarith

theorem mem_neg {x : ℚ} {A : Iv} (hx : A.mem x) : A.neg.mem (-x) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  constructor
  · change -A.hi ≤ -x
    linarith
  · change -x ≤ -A.lo
    linarith

theorem mem_sub {x y : ℚ} {A B : Iv} (hx : A.mem x) (hy : B.mem y) :
    (A.sub B).mem (x - y) := by
  simpa only [sub, sub_eq_add_neg] using mem_add hx (mem_neg hy)

theorem mem_scale {q x : ℚ} {A : Iv} (hx : A.mem x) : (A.scale q).mem (q * x) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  by_cases hq : 0 ≤ q
  · constructor
    · rw [Iv.scale, ite_eq_left hq]
      exact mul_le_mul_of_nonneg_left hx₁ hq
    · rw [Iv.scale, ite_eq_left hq]
      exact mul_le_mul_of_nonneg_left hx₂ hq
  · have hq' : q ≤ 0 := le_of_lt (not_le.mp hq)
    exact ⟨by rw [Iv.scale, ite_eq_right hq]; exact mul_le_mul_of_nonpos_left hx₂ hq',
           by rw [Iv.scale, ite_eq_right hq]; exact mul_le_mul_of_nonpos_left hx₁ hq'⟩

theorem mem_mul {x y : ℚ} {A B : Iv} (hx : A.mem x) (hy : B.mem y) :
    (A.mul B).mem (x * y) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  obtain ⟨hy₁, hy₂⟩ := hy
  exact ⟨min4_mul_le _ _ _ _ x y hx₁ hx₂ hy₁ hy₂,
         mul_le_max4 _ _ _ _ x y hx₁ hx₂ hy₁ hy₂⟩

theorem mem_inflate {r x : ℚ} {A : Iv} (hr : 0 ≤ r) (hx : A.mem x) :
    (A.inflate r).mem x := by
  obtain ⟨hx₁, hx₂⟩ := hx
  constructor
  · change A.lo - r ≤ x
    linarith
  · change x ≤ A.hi + r
    linarith

/-! ### Soundness over `ℝ` (mirror of the above, used by `Cx`) -/

theorem memR_add {x y : ℝ} {A B : Iv} (hx : A.memR x) (hy : B.memR y) :
    (A.add B).memR (x + y) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  obtain ⟨hy₁, hy₂⟩ := hy
  constructor
  · change ((A.lo + B.lo : ℚ) : ℝ) ≤ x + y
    push_cast
    linarith
  · change x + y ≤ ((A.hi + B.hi : ℚ) : ℝ)
    push_cast
    linarith

theorem memR_neg {x : ℝ} {A : Iv} (hx : A.memR x) : A.neg.memR (-x) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  constructor
  · change ((-A.hi : ℚ) : ℝ) ≤ -x
    push_cast
    linarith
  · change -x ≤ ((-A.lo : ℚ) : ℝ)
    push_cast
    linarith

theorem memR_sub {x y : ℝ} {A B : Iv} (hx : A.memR x) (hy : B.memR y) :
    (A.sub B).memR (x - y) := by
  simpa only [sub, sub_eq_add_neg] using memR_add hx (memR_neg hy)

theorem memR_scale {q : ℚ} {x : ℝ} {A : Iv} (hx : A.memR x) :
    (A.scale q).memR ((q : ℝ) * x) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  have hqR : ∀ h : 0 ≤ q, (0 : ℝ) ≤ (q : ℝ) := by
    intro h
    exact_mod_cast h
  have hqR' : ∀ h : ¬ 0 ≤ q, (q : ℝ) ≤ 0 := by
    intro h
    have : ¬ (0 : ℝ) ≤ (q : ℝ) := by
      intro hc
      exact h (by exact_mod_cast hc)
    linarith
  by_cases hq : 0 ≤ q
  · constructor
    · rw [Iv.scale, ite_eq_left hq]
      push_cast
      exact mul_le_mul_of_nonneg_left hx₁ (hqR hq)
    · rw [Iv.scale, ite_eq_left hq]
      push_cast
      exact mul_le_mul_of_nonneg_left hx₂ (hqR hq)
  · constructor
    · rw [Iv.scale, ite_eq_right hq]
      push_cast
      exact mul_le_mul_of_nonpos_left hx₂ (hqR' hq)
    · rw [Iv.scale, ite_eq_right hq]
      push_cast
      exact mul_le_mul_of_nonpos_left hx₁ (hqR' hq)

theorem memR_mul {x y : ℝ} {A B : Iv} (hx : A.memR x) (hy : B.memR y) :
    (A.mul B).memR (x * y) := by
  obtain ⟨hx₁, hx₂⟩ := hx
  obtain ⟨hy₁, hy₂⟩ := hy
  constructor
  · have h := min4_mul_le ((A.lo : ℝ)) ((A.hi : ℝ)) ((B.lo : ℝ)) ((B.hi : ℝ)) x y
      hx₁ hx₂ hy₁ hy₂
    simpa only [mul, min4, max4, Rat.cast_min, Rat.cast_max, Rat.cast_mul] using h
  · have h := mul_le_max4 ((A.lo : ℝ)) ((A.hi : ℝ)) ((B.lo : ℝ)) ((B.hi : ℝ)) x y
      hx₁ hx₂ hy₁ hy₂
    simpa only [mul, min4, max4, Rat.cast_min, Rat.cast_max, Rat.cast_mul] using h

theorem memR_inflate {r : ℚ} {x : ℝ} {A : Iv} (hr : 0 ≤ r) (hx : A.memR x) :
    (A.inflate r).memR x := by
  obtain ⟨hx₁, hx₂⟩ := hx
  have hrR : (0 : ℝ) ≤ (r : ℝ) := by exact_mod_cast hr
  constructor
  · rw [Iv.inflate]
    push_cast
    linarith
  · rw [Iv.inflate]
    push_cast
    linarith

end Iv

/-! ## Complex rectangles -/

/-- An axis-parallel complex rectangle `re × im` with rational endpoints. -/
structure Cx where
  re : Iv
  im : Iv
deriving DecidableEq, Repr

namespace Cx

/-- Membership of a complex number in a rectangle.  The coordinates are real,
so this uses the real-coordinate interval membership `Iv.memR`. -/
def mem (z : ℂ) (Z : Cx) : Prop := Z.re.memR z.re ∧ Z.im.memR z.im

def add (Z W : Cx) : Cx := ⟨Z.re.add W.re, Z.im.add W.im⟩

def neg (Z : Cx) : Cx := ⟨Z.re.neg, Z.im.neg⟩

def sub (Z W : Cx) : Cx := add Z (neg W)

/-- Complex multiplication of boxes: `re = re*re - im*im`,
`im = re*im + im*re`. -/
def mul (Z W : Cx) : Cx :=
  ⟨(Z.re.mul W.re).sub (Z.im.mul W.im), (Z.re.mul W.im).add (Z.im.mul W.re)⟩

/-- Rational scalar scaling of both coordinates. -/
def scale (q : ℚ) (Z : Cx) : Cx := ⟨Z.re.scale q, Z.im.scale q⟩

/-- Inflate both coordinates by `± r` (`r` bounds the modulus of an error). -/
def inflate (r : ℚ) (Z : Cx) : Cx := ⟨Z.re.inflate r, Z.im.inflate r⟩

theorem mem_add {z w : ℂ} {Z W : Cx} (hz : Z.mem z) (hw : W.mem w) :
    (Z.add W).mem (z + w) := by
  obtain ⟨hz₁, hz₂⟩ := hz
  obtain ⟨hw₁, hw₂⟩ := hw
  exact ⟨by simpa only [add, Complex.add_re] using Iv.memR_add hz₁ hw₁,
         by simpa only [add, Complex.add_im] using Iv.memR_add hz₂ hw₂⟩

theorem mem_neg {z : ℂ} {Z : Cx} (hz : Z.mem z) : Z.neg.mem (-z) := by
  obtain ⟨hz₁, hz₂⟩ := hz
  exact ⟨by simpa only [neg, Complex.neg_re] using Iv.memR_neg hz₁,
         by simpa only [neg, Complex.neg_im] using Iv.memR_neg hz₂⟩

theorem mem_sub {z w : ℂ} {Z W : Cx} (hz : Z.mem z) (hw : W.mem w) :
    (Z.sub W).mem (z - w) := by
  simpa only [sub, sub_eq_add_neg] using mem_add hz (mem_neg hw)

theorem mem_scale {q : ℚ} {z : ℂ} {Z : Cx} (hz : Z.mem z) :
    (Z.scale q).mem ((q : ℂ) * z) := by
  obtain ⟨hz₁, hz₂⟩ := hz
  exact ⟨by simpa [scale, Complex.mul_re] using Iv.memR_scale (q := q) hz₁,
         by simpa [scale, Complex.mul_re] using Iv.memR_scale (q := q) hz₂⟩

theorem mem_mul {z w : ℂ} {Z W : Cx} (hz : Z.mem z) (hw : W.mem w) :
    (Z.mul W).mem (z * w) := by
  obtain ⟨hz₁, hz₂⟩ := hz
  obtain ⟨hw₁, hw₂⟩ := hw
  exact ⟨by
          have h := Iv.memR_sub (Iv.memR_mul hz₁ hw₁) (Iv.memR_mul hz₂ hw₂)
          simpa only [mul, Complex.mul_re] using h,
        by
          have h := Iv.memR_add (Iv.memR_mul hz₁ hw₂) (Iv.memR_mul hz₂ hw₁)
          simpa only [mul, Complex.mul_im] using h⟩

theorem mem_inflate {r : ℚ} {z : ℂ} {Z : Cx} (hr : 0 ≤ r) (hz : Z.mem z) :
    (Z.inflate r).mem z := by
  obtain ⟨hz₁, hz₂⟩ := hz
  exact ⟨by simpa only [inflate] using Iv.memR_inflate hr hz₁,
         by simpa only [inflate] using Iv.memR_inflate hr hz₂⟩

end Cx

/-! ## Smoke tests (compile-time checks, no proofs by evaluation needed) -/

#check @Iv.mem_add
#check @Iv.mem_neg
#check @Iv.mem_sub
#check @Iv.mem_scale
#check @Iv.mem_mul
#check @Iv.mem_inflate
#check @Cx.mem_add
#check @Cx.mem_neg
#check @Cx.mem_sub
#check @Cx.mem_scale
#check @Cx.mem_mul
#check @Cx.mem_inflate

-- A tiny concrete computation / evaluation smoke test.
example : (Iv.add ⟨1, 2⟩ ⟨3, 5⟩).lo = 4 := by norm_num [Iv.add]
example : (Iv.neg ⟨1, 2⟩).hi = -1 := by norm_num [Iv.neg]
example : (Iv.mul ⟨1, 2⟩ ⟨3, 5⟩).hi = 10 := by norm_num [Iv.mul, min4, max4]
example : (Iv.scale (-2) ⟨1, 2⟩).lo = -4 := by norm_num [Iv.scale]
example : (Iv.scale (-2) ⟨1, 2⟩).hi = -2 := by norm_num [Iv.scale]
example : (Iv.inflate 1 ⟨0, 1⟩).lo = -1 := by norm_num [Iv.inflate]

-- A concrete soundness instance.
example : (Iv.mul ⟨1, 2⟩ ⟨3, 5⟩).mem (2 * 5) := by
  norm_num [Iv.mem, Iv.mul, min4, max4]

-- `#eval` works because of `deriving Repr`.
#eval Iv.mul ⟨1, 2⟩ ⟨3, 5⟩
#eval Cx.mul ⟨⟨1, 2⟩, ⟨0, 1⟩⟩ ⟨⟨3, 5⟩, ⟨-1, 0⟩⟩

end PartialTail
