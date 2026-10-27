/-
  Curve.lean — 018 round 4

  Lifting the separation to a curve: the pair statistic depends on the map
  `π : C → P¹`, not only on the zeta of `C`.

  On a curve `C` with qrimes `S` (a `Finset` slice of the primes), a map `π`
  acts on the prime `℘` by `π(℘)`; writing `τ` for the induced shift on the
  degree-`d` slice, define

      P_τ(S)  = #{f ∈ S : Irr f ∧ Irr (τ f)}          (pair statistic)
      Z_C(S)  = #{f ∈ S : Irr f ∧ deg f = n}  (n)     (zeta datum)

  `no_pair_function_of_zeta`: if two maps give different pair counts on the
  same `S`, then no function of the zeta datum computes the pair count.  This
  is the curve form of round 3's separation, but here the curve and its qrimes
  are fixed — only the map varies, so we no longer vary the "world".

  Witness: `C = P¹` over `F₅`, degree 2.  The maps `π_a(x) = a x` induce the
  shift `δ = 2/a` on the constant term, because `a f + 2 = a (f + 2/a)` and
  irreducibility is unit-invariant.  `π₁(x) = x` gives `δ = 2`, and
  `π₂(x) = 2x` gives `δ = 1`; the pair counts are `0` and `5`.
-/
import Mathlib
import Separation

namespace CurveLift

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

variable {α : Type*}

/-- The zeta datum of a curve's qrimes: the number of degree-`n` primes. -/
def qrimeDatum (deg : α → ℕ) (Irr : α → Prop) [DecidablePred Irr] (S : Finset α) : ℕ → ℕ :=
  fun n => (S.filter (fun a => Irr a ∧ deg a = n)).card

/-- The pair statistic of a map inducing the shift `τ`. -/
def pairCount (Irr : α → Prop) [DecidablePred Irr] (τ : α → α) (S : Finset α) : ℕ :=
  (S.filter (fun a => Irr a ∧ Irr (τ a))).card

/-- **The curve lift.**  If two maps (shifts) give different pair counts on the
same qrimes of a fixed curve, then the pair count is not a function of the zeta
datum `Z_C`. -/
theorem no_pair_function_of_zeta (deg : α → ℕ) (Irr : α → Prop) [DecidablePred Irr]
    (S : Finset α) (τ₁ τ₂ : α → α)
    (h : pairCount Irr τ₁ S ≠ pairCount Irr τ₂ S) :
    ¬ ∃ Φ : (ℕ → ℕ) → ℕ, ∀ τ : α → α, pairCount Irr τ S = Φ (qrimeDatum deg Irr S) := by
  rintro ⟨Φ, hΦ⟩
  exact h (by rw [hΦ τ₁, hΦ τ₂])

/-! ## The witness: `P¹` over `𝔽₅`, degree 2 -/

open Polynomial

/-- Monic quadratic `x² + b x + c` over `𝔽₅`, from `(b,c)`. -/
noncomputable def quad (p : ZMod 5 × ZMod 5) : (ZMod 5)[X] :=
  X ^ 2 + C p.1 * X + C p.2

/-- The shift on the constant term induced by a linear map `x ↦ a x`:
`a x + 2 = a (x + 2/a)`, so `δ = 2/a`. -/
def shift (δ : ZMod 5) (p : ZMod 5 × ZMod 5) : ZMod 5 × ZMod 5 := (p.1, p.2 + δ)

/-- Irreducibility of a monic quadratic, as "no root" (equivalent for degree 2). -/
abbrev Irr5 (p : ZMod 5 × ZMod 5) : Prop := ∀ x : ZMod 5, x ^ 2 + p.1 * x + p.2 ≠ 0

/-- All 25 monic quadratics of `𝔽₅` (the degree-2 slice of `P¹`). -/
def All5 : Finset (ZMod 5 × ZMod 5) := Finset.univ

/-- Every `Irr5` quadratic is genuinely irreducible (round-3 lemma). -/
theorem witness_irreducible (p : ZMod 5 × ZMod 5) (h : Irr5 p) :
    Irreducible (quad p) :=
  Separation.irreducible_quad_of_noRoot p.1 p.2 h

/-- The degree-2 zeta datum: `I(2) = 10` qrimes over `𝔽₅`. -/
theorem zeta_datum_deg2 :
    qrimeDatum (fun _ : ZMod 5 × ZMod 5 => 2) Irr5 All5 2 = 10 := by
  decide

/-- `δ = 2` is the map `π₁(x) = x`; the pair count is `0`. -/
theorem pair_shift_two : pairCount Irr5 (shift 2) All5 = 0 := by
  decide

/-- `δ = 1` is the map `π₂(x) = 2x`; the pair count is `5`. -/
theorem pair_shift_one : pairCount Irr5 (shift 1) All5 = 5 := by
  decide

/-- **Same curve, same zeta, different pair count.** -/
theorem same_curve_different_pair :
    pairCount Irr5 (shift 2) All5 ≠ pairCount Irr5 (shift 1) All5 := by
  decide

/-- **The lift, over `P¹/𝔽₅`.**  No function of the zeta datum `Z_{P¹}` gives
the pair statistic for every map: `π₁(x) = x` and `π₂(x) = 2x` give `0` and `5`
on the same curve. -/
theorem curve_separation :
    ¬ ∃ Φ : (ℕ → ℕ) → ℕ, ∀ τ : ZMod 5 × ZMod 5 → ZMod 5 × ZMod 5,
      pairCount Irr5 τ All5 = Φ (qrimeDatum (fun _ => 2) Irr5 All5) :=
  no_pair_function_of_zeta (fun _ => 2) Irr5 All5 (shift 2) (shift 1)
    same_curve_different_pair

end CurveLift

/-! ## A second prime: the degree-2 counts over `F₇`

Over `F₅` the shift-1 count is `5` and the shift-2 count is `0`; over `F₇` both
are `7`.  This is the `χ`-dependence of the degree-2 formula (Bary-Soker–Stix,
Example 3.2). -/

namespace QuadSeven

instance : Fact (Nat.Prime 7) := ⟨by norm_num⟩

/-- The shift on the constant term over `F₇`. -/
def shift7 (δ : ZMod 7) (p : ZMod 7 × ZMod 7) : ZMod 7 × ZMod 7 := (p.1, p.2 + δ)

/-- Irreducibility of a monic quadratic over `F₇`, as "no root". -/
abbrev Irr7 (p : ZMod 7 × ZMod 7) : Prop := ∀ x : ZMod 7, x ^ 2 + p.1 * x + p.2 ≠ 0

/-- All 49 monic quadratics of `F₇`. -/
def All7 : Finset (ZMod 7 × ZMod 7) := Finset.univ

/-- Shift 1 over `F₇`: `7` twin pairs. -/
theorem pair7_shift_one : CurveLift.pairCount Irr7 (shift7 1) All7 = 7 := by
  decide

/-- Shift 2 over `F₇`: also `7`.  (Over `F₅` the same two shifts give `5` and
`0`; the degree-2 formula depends on `q mod 4`.) -/
theorem pair7_shift_two : CurveLift.pairCount Irr7 (shift7 2) All7 = 7 := by
  decide

end QuadSeven
