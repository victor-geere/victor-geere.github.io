/-
  Qrime.lean — 018: finite facts behind the qrime / twin-qrime dictionary.

  A qrime of `F_q[x]` is a monic irreducible; a monic degree-`n` polynomial is a
  coefficient vector `(a_0,…,a_{n-1}) ∈ (ZMod q)^n`, so there are `q^n` of them.
  Twin qrimes are pairs `(f, f+2)`; the map `f ↦ f+2` adds `2` to the constant
  coefficient and is a bijection.  The last theorem records the parity barrier in
  qrime form: the *linear* statistic `|S|` does not determine the *pair*
  statistic `#{f ∈ S : f+2 ∈ S}`.
-/
import Mathlib

namespace Qrime

/-- The coefficient vectors of monic degree-`n` polynomials over `F_q` number `q^n`. -/
theorem card_monic (q n : ℕ) [NeZero q] :
    Fintype.card (Fin n → ZMod q) = q ^ n := by
  simp

/-- `f ↦ f + 2`: add `2` to the constant coefficient. -/
def shift {q n : ℕ} (h : 0 < n) (c : Fin n → ZMod q) : Fin n → ZMod q :=
  Function.update c ⟨0, h⟩ (c ⟨0, h⟩ + 2)

/-- The inverse of `shift` (subtract `2`). -/
def unshift {q n : ℕ} (h : 0 < n) (c : Fin n → ZMod q) : Fin n → ZMod q :=
  Function.update c ⟨0, h⟩ (c ⟨0, h⟩ - 2)

theorem unshift_shift {q n : ℕ} (h : 0 < n) :
    Function.LeftInverse (unshift (q := q) (n := n) h) (shift (q := q) (n := n) h) := by
  intro c
  funext i
  by_cases hi : i = ⟨0, h⟩
  · subst hi
    simp [shift, unshift]
  · simp [shift, unshift, hi]

theorem shift_unshift {q n : ℕ} (h : 0 < n) :
    Function.LeftInverse (shift (q := q) (n := n) h) (unshift (q := q) (n := n) h) := by
  intro c
  funext i
  by_cases hi : i = ⟨0, h⟩
  · subst hi
    simp [shift, unshift]
  · simp [shift, unshift, hi]

/-- **The twin map is a bijection** — so "f + 2" is measure-preserving on monic
polynomials: it moves qrimes but preserves the total count. -/
theorem shift_bijective {q n : ℕ} (h : 0 < n) :
    Function.Bijective (shift (q := q) (n := n) h) :=
  ⟨(unshift_shift h).injective, (shift_unshift h).surjective⟩

/-! ## The parity barrier in qrime form -/

/-- The twin count of a finite set of "qrimes": `#{f ∈ S : f + 2 ∈ S}`. -/
def twinCount (S : Finset (ZMod 4)) : ℕ := (S.filter (fun f => f + 2 ∈ S)).card

/-- **The linear statistic does not determine the pair statistic.**  Two sets of
qrimes of the same size can have different twin counts: `|S|` (a linear, zeta-type
statistic) does not determine `#{f ∈ S : f+2 ∈ S}` (a bilinear, pair statistic). -/
theorem linear_not_determine_twin :
    ∃ S T : Finset (ZMod 4), S.card = T.card ∧ twinCount S ≠ twinCount T := by
  refine ⟨{0, 1}, {0, 2}, by decide, ?_⟩
  decide

/-! ## The singular-series local factor -/

/-- The local factor of the twin-qrime singular series:
`(1 − 2/Q)/(1 − 1/Q)² = (Q − 2)Q/(Q − 1)²`. -/
theorem local_factor (Q : ℚ) (h0 : Q ≠ 0) (h1 : Q ≠ 1) :
    (1 - 2/Q) / (1 - 1/Q)^2 = (Q - 2) * Q / (Q - 1)^2 := by
  field_simp

end Qrime
