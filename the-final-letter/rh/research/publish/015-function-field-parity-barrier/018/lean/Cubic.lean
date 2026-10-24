/-
  Cubic.lean — 018 round 4

  A finite Lean check of the exact degree-3 twin count used in step 2:
  over `F₅`, exactly `10` monic cubics `f` have both `f` and `f + 2`
  irreducible.  This matches the Bary-Soroker–Stix exact formula

      T(3) = q(q-2)(q+1)/9   (q ≡ 2 mod 3),

  which at `q = 5` gives `5·3·6/9 = 10`.

  Degree 3: a monic cubic is irreducible iff it has no root, so `NoRoot3` is
  the irreducibility predicate and the whole statement is a finite check.
-/
import Mathlib

namespace CubicTwins

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

open Polynomial

/-- The monic cubic `x³ + a x² + b x + c` over `F₅`, from `(a,b,c)`. -/
noncomputable def cubic (p : ZMod 5 × ZMod 5 × ZMod 5) : (ZMod 5)[X] :=
  X ^ 3 + C p.1 * X ^ 2 + C p.2.1 * X + C p.2.2

/-- Irreducibility of a monic cubic, as "no root". -/
abbrev NoRoot3 (p : ZMod 5 × ZMod 5 × ZMod 5) : Prop :=
  ∀ x : ZMod 5, x ^ 3 + p.1 * x ^ 2 + p.2.1 * x + p.2.2 ≠ 0

/-- `f ↦ f + 2`: shift the constant coefficient. -/
def shift2 (p : ZMod 5 × ZMod 5 × ZMod 5) : ZMod 5 × ZMod 5 × ZMod 5 :=
  (p.1, p.2.1, p.2.2 + 2)

/-- The degree-3 twin count over `F₅`. -/
def cubicTwin : ℕ :=
  (Finset.univ.filter (fun p : ZMod 5 × ZMod 5 × ZMod 5 =>
      NoRoot3 p ∧ NoRoot3 (shift2 p))).card

/-- `T(3) = 10` over `F₅`; the exact formula `q(q-2)(q+1)/9` gives `10`. -/
theorem cubicTwin_five : cubicTwin = 10 := by
  decide

end CubicTwins

/-! ## The ordinary case: `F₇` -/

namespace CubicSeven

instance : Fact (Nat.Prime 7) := ⟨by norm_num⟩

open Polynomial

/-- The monic cubic `x³ + a x² + b x + c` over `F₇`. -/
noncomputable def cubic7 (p : ZMod 7 × ZMod 7 × ZMod 7) : (ZMod 7)[X] :=
  X ^ 3 + C p.1 * X ^ 2 + C p.2.1 * X + C p.2.2

/-- Irreducibility of a monic cubic over `F₇`, as "no root". -/
abbrev NoRoot7 (p : ZMod 7 × ZMod 7 × ZMod 7) : Prop :=
  ∀ x : ZMod 7, x ^ 3 + p.1 * x ^ 2 + p.2.1 * x + p.2.2 ≠ 0

/-- `f ↦ f + 2` over `F₇`. -/
def shift2_7 (p : ZMod 7 × ZMod 7 × ZMod 7) : ZMod 7 × ZMod 7 × ZMod 7 :=
  (p.1, p.2.1, p.2.2 + 2)

/-- The degree-3 twin count over `F₇` (shift 2). -/
def cubicTwin7 : ℕ :=
  (Finset.univ.filter (fun p : ZMod 7 × ZMod 7 × ZMod 7 =>
      NoRoot7 p ∧ NoRoot7 (shift2_7 p))).card

/-- `T(3) = 35` over `F₇`.  Here `q ≡ 1 (mod 3)` and the curve `E: Y²-Y=X³` is
*ordinary*; the Bary-Soroker–Stix formula gives `35`, not the supersingular
`q(q-2)(q+1)/9 = 280/9`. -/
theorem cubicTwin_seven : cubicTwin7 = 35 := by
  decide

/-- `f ↦ f + h` for a general shift `h` over `F₇`. -/
def shift7h (h : ZMod 7) (p : ZMod 7 × ZMod 7 × ZMod 7) : ZMod 7 × ZMod 7 × ZMod 7 :=
  (p.1, p.2.1, p.2.2 + h)

/-- The degree-3 twin count over `F₇` for a general shift `h`. -/
def cubicTwin7h (h : ZMod 7) : ℕ :=
  (Finset.univ.filter (fun p : ZMod 7 × ZMod 7 × ZMod 7 =>
      NoRoot7 p ∧ NoRoot7 (shift7h h p))).card

/-- **The shift average over `F₇`.**  Summing the degree-3 twin count over all
nonzero shifts gives `168`, i.e. the average is `28` — the Bary-Soroker–Stix
Theorem 1.4 value for `q = 7`. -/
theorem sum_cubicTwin7 :
    (Finset.univ.filter (fun h : ZMod 7 => h ≠ 0)).sum cubicTwin7h = 168 := by
  decide

end CubicSeven
/-! ## Shift averages at `F₅` and `F₁₁` -/

namespace CubicAverageFive

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

open Polynomial

/-- Shift `h` on the constant term over `F₅`. -/
def shift5h (h : ZMod 5) (p : ZMod 5 × ZMod 5 × ZMod 5) : ZMod 5 × ZMod 5 × ZMod 5 :=
  (p.1, p.2.1, p.2.2 + h)

abbrev NoRoot5 (p : ZMod 5 × ZMod 5 × ZMod 5) : Prop :=
  ∀ x : ZMod 5, x ^ 3 + p.1 * x ^ 2 + p.2.1 * x + p.2.2 ≠ 0

/-- Degree-3 twin count over `F₅` for shift `h`. -/
def cubicTwin5h (h : ZMod 5) : ℕ :=
  (Finset.univ.filter (fun p : ZMod 5 × ZMod 5 × ZMod 5 =>
      NoRoot5 p ∧ NoRoot5 (shift5h h p))).card

/-- Shift average over `F₅`: `Σ_{h≠0} = 40`, average `10`. -/
theorem sum_cubicTwin5 :
    (Finset.univ.filter (fun h : ZMod 5 => h ≠ 0)).sum cubicTwin5h = 40 := by
  decide

end CubicAverageFive

namespace CubicAverageFive

/-- Over `F_5` the degree-3 twin count is the same for every nonzero shift
(`q = 2 (mod 3)`, so every `h` is a cube).  Finite check over the four shifts. -/
theorem cubicTwin5_shift_independent :
    ∀ h : ZMod 5, h ≠ 0 → cubicTwin5h h = 10 := by
  decide

end CubicAverageFive
