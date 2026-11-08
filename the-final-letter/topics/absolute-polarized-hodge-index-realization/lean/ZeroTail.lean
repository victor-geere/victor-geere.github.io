import GaussianZeroSide
import Hadamard

/-!
# The zero-tail summability bridge

This file connects the Hadamard zero-counting layer (`xi₀_zeros_inv_sq_summable`,
which says that the zeros of `ξ₀` are square-summable in the `(‖z‖+1)⁻²`
weight) to the named analytic input `ZeroTailSummable` of `GaussianZeroSide`.

The chain is:

* `xi₀_zeros_inv_sq_summable` — subtype summability of `((‖w‖+1)²)⁻¹` over the
  zeros of `ξ₀`;
* `summable_inv_sq_of_injective_enumeration` — transfer to an injective
  enumeration `a : ℕ → ℂ` of the zeros;
* `summable_inv_sq_im_of_strip` — under the strip bound `|Re z| ≤ 1`, the
  inverse-square weight in the imaginary part is summable;
* `zeroTailSummable_of_inv_sq` — the Gaussian tail
  `∑ exp(−σ²·Im(z)²)` is summable.

The strip bound and the growth of the ordinates are kept as explicit hypotheses;
they are the remaining zero-set bookkeeping inputs.
-/

noncomputable section
open Complex Filter Topology

namespace AbsoluteHodgeExplicitFormula
open AbsoluteHodgeHadamard AbsoluteHodgeSymbol

/-- **`ξ₀` and the completed zeta have the same nonzero zeros.**  For `s ≠ 0, 1`
off the poles of `Γ`, `ξ₀(s) = s(s−1)·Z(s)`.  This identifies the Hadamard
zero set (`xi₀`) with the explicit-formula zero set (`completedZeta`), away from
the trivial zeros and the two poles. -/
theorem xi₀_eq_mul_completedZeta {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1) (hΓ : s.Gammaℝ ≠ 0) :
    xi₀ s = s * (s - 1) * completedZeta s := by
  rw [completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ]
  unfold xi₀
  rw [completedRiemannZeta_eq]
  field_simp
  ring

/-- **Nontrivial `ξ₀` zeros lie in the open critical strip.**  For a zero with
`0 < Re s`, the completed-zeta strip theorem applies via
`xi₀_eq_mul_completedZeta`; the trivial zeros (negative even integers) are
excluded by `0 < Re s`. -/
theorem xi₀_zero_re_open_strip {s : ℂ} (hz : xi₀ s = 0) (hre : 0 < s.re) :
    0 < s.re ∧ s.re < 1 := by
  have hs0 : s ≠ 0 := by
    intro h
    subst h
    have h0 : ((0 : ℂ).re) = 0 := rfl
    rw [h0] at hre
    exact lt_irrefl 0 hre
  have hs1 : s ≠ 1 := by
    intro h
    subst h
    have h1 : xi₀ (1 : ℂ) = 1 := by unfold xi₀; ring
    rw [h1] at hz
    exact one_ne_zero hz
  have hΓ : s.Gammaℝ ≠ 0 := by
    intro h
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
    have hre' : s.re = -(2 * (n : ℝ)) := by rw [hn]; simp
    linarith [show (0 : ℝ) ≤ (n : ℝ) from Nat.cast_nonneg n]
  have hZ : completedZeta s = 0 := by
    have hid := xi₀_eq_mul_completedZeta hs0 hs1 hΓ
    have hprod : s * (s - 1) * completedZeta s = 0 := by rw [← hid]; exact hz
    have hfac : s * (s - 1) ≠ 0 := by
      apply mul_ne_zero hs0
      exact sub_ne_zero.mpr hs1
    exact (mul_eq_zero.mp hprod).resolve_left hfac
  have hnt : ∀ n : ℕ, s ≠ -(2 * (n + 1) : ℂ) := by
    intro n h
    have hre' : s.re = -(2 * ((n : ℝ) + 1)) := by
      rw [h]
      simp
    linarith [show (0 : ℝ) ≤ (n : ℝ) from Nat.cast_nonneg n]
  exact completedZeta_zero_re_open_strip hZ hs0 hs1 hnt

/-- **`ZeroTailSummable` from an enumerated `ξ₀` zero set.**  Given an injective
enumeration `a` of the zeros of `ξ₀`, the linear growth constants of `ξ₀`, the
critical-strip bound `|Re(a n)| ≤ 1`, and the growth of the ordinates, the
Gaussian zero tail over the imaginary parts is summable. -/
theorem zeroTailSummable_of_xi₀_enumeration {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ + B)
    (a : ℕ → ℂ) (hinj : Function.Injective a)
    (hrange : ∀ n, xi₀ (a n) = 0)
    (hstrip : ∀ n, |(a n).re| ≤ 1)
    (σ : ℝ) (hσ : 0 < σ)
    (hγ : Tendsto (fun n : ℕ => |(a n).im|) atTop atTop) :
    ZeroTailSummable (fun n : ℕ => (a n).im) σ := by
  have hsub : Summable (fun w : {z : ℂ // xi₀ z = 0} =>
      (((‖(w : ℂ)‖ + 1) ^ 2 : ℝ))⁻¹) :=
    xi₀_zeros_inv_sq_summable hA hB hgrowth
  have hseq : Summable (fun n : ℕ => (((‖a n‖ + 1) ^ 2 : ℝ))⁻¹) :=
    summable_inv_sq_of_injective_enumeration hinj hrange hsub
  have him : Summable (fun n : ℕ => ((|(a n).im| + 1) ^ 2 : ℝ)⁻¹) :=
    summable_inv_sq_im_of_strip a hstrip hseq
  exact zeroTailSummable_of_inv_sq (fun n : ℕ => (a n).im) σ hσ hγ
    (by simpa [one_div] using him)

/-- **`ZeroTailSummable` for a nontrivial-zero enumeration.**  Restricting the
enumeration to zeros with `0 < Re s` discharges the strip hypothesis via
`xi₀_zero_re_open_strip`; only the injective enumeration and the ordinate growth
remain. -/
theorem zeroTailSummable_of_nontrivial_xi₀_enumeration {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ + B)
    (a : ℕ → ℂ) (hinj : Function.Injective a)
    (hrange : ∀ n, xi₀ (a n) = 0)
    (hpos : ∀ n, 0 < (a n).re)
    (σ : ℝ) (hσ : 0 < σ)
    (hγ : Tendsto (fun n : ℕ => |(a n).im|) atTop atTop) :
    ZeroTailSummable (fun n : ℕ => (a n).im) σ := by
  apply zeroTailSummable_of_xi₀_enumeration hA hB hgrowth a hinj hrange
  · intro n
    have h := xi₀_zero_re_open_strip (hrange n) (hpos n)
    rw [abs_of_pos (hpos n)]
    linarith [h.2]
  · exact hσ
  · exact hγ

/-- **An injective enumeration of the nontrivial zeros.**  Under a
`Denumerable` instance on the nontrivial zero subtype (available from
countability plus infinitude), the zeros admit an injective sequence with
range exactly the nontrivial zero set. -/
theorem exists_nontrivial_xi₀_enumeration
    [Denumerable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}] :
    ∃ a : ℕ → ℂ, Function.Injective a ∧
      (∀ n, xi₀ (a n) = 0) ∧ (∀ n, 0 < (a n).re) ∧
      Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re} := by
  let e : ℕ ≃ {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} := (Denumerable.eqv _).symm
  refine ⟨fun n => (e n : ℂ), ?_, ?_, ?_, ?_⟩
  · intro m n h
    exact e.injective (Subtype.ext h)
  · intro n
    exact (e n).2.1
  · intro n
    exact (e n).2.2
  · ext z
    constructor
    · rintro ⟨n, rfl⟩
      exact (e n).2
    · intro hz
      exact ⟨e.symm ⟨z, hz⟩, by simp⟩

end AbsoluteHodgeExplicitFormula
