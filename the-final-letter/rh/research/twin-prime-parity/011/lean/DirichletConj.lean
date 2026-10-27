/-
  DirichletConj.lean — conjugation ("reality") of Dirichlet L-functions.

  Mathlib has the completed L-function `completedLFunction χ s` of a Dirichlet character, its
  analytic continuation `LFunction`, the archimedean factor `gammaFactor`, and the functional
  equation `IsPrimitive.completedLFunction_one_sub`; it has no statement relating any of these to
  complex conjugation.  This file supplies the missing pieces:

  * `LSeries_conj` — conjugation of an abstract L-series;
  * `LFunction_conj_of_one_lt_re` — conjugation of the L-function on the half-plane `1 < re s`;
  * `gammaFactor_conj` — conjugation of the archimedean gamma factor (unconditional);
  * `completedLFunction₀_conj` — conjugation of the *entire* normalisation `completedLFunction₀`;
  * `completedLFunction_conj` — the headline: for a character with real values
    (`∀ n, conj (χ n) = χ n`), `Λ_χ(conj s) = conj (Λ_χ s)` for all `s`.
-/
import Mathlib.Analysis.Calculus.Deriv.Star
import Mathlib.NumberTheory.LSeries.DirichletContinuation

open scoped ComplexConjugate
open Complex Filter

/-- **Conjugation of an L-series.**  Conjugating the value of the L-series of `f` at `conj s`
conjugates the coefficients: `conj (LSeries f (conj s)) = LSeries (fun n ↦ conj (f n)) s`.

The identity is unconditional: away from the half-plane of absolute convergence both sides
vanish, and on the half-plane it is termwise `conj (f n / n^(conj s)) = conj (f n) / n^s`,
which is `Complex.cpow_conj` at the real nonnegative base `n`. -/
theorem LSeries_conj (f : ℕ → ℂ) (s : ℂ) :
    conj (LSeries f (conj s)) = LSeries (fun n => conj (f n)) s := by
  rw [LSeries, LSeries, Complex.conj_tsum]
  refine tsum_congr fun n => ?_
  rw [LSeries.term_def, LSeries.term_def]
  split_ifs with hn
  · simp
  · rw [map_div₀]
    have harg : ((n : ℂ)).arg ≠ Real.pi := by
      rw [show (n : ℂ) = ((n : ℝ) : ℂ) by simp,
        Complex.arg_ofReal_of_nonneg (Nat.cast_nonneg n)]
      exact Real.pi_ne_zero.symm
    have hpow : conj ((n : ℂ) ^ conj s) = (n : ℂ) ^ s := by
      have h : (n : ℂ) ^ conj s = conj (conj (n : ℂ) ^ s) := Complex.cpow_conj (n : ℂ) s harg
      rw [h, Complex.conj_conj]
      simp
    rw [hpow]

namespace Complex

/-- **Conjugation of the archimedean factor.**  `Gammaℝ (conj s) = conj (Gammaℝ s)`; this is
`Complex.Gammaℝ s = π^{-s/2} Γ(s/2)` with `Complex.cpow_conj` at the real base `π` and
`Complex.Gamma_conj`.

(This is not in Mathlib; the same statement is proved as `Rh45RouteBAnalytic.Gammaℝ_conj` in the
`010` development, which this self-contained Mathlib-only module does not import.) -/
theorem Gammaℝ_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s) := by
  have harg : ((Real.pi : ℂ)).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
    exact Real.pi_ne_zero.symm
  calc Gammaℝ (conj s)
      = (Real.pi : ℂ) ^ (-(conj s) / 2) * Complex.Gamma (conj s / 2) := Gammaℝ_def _
    _ = conj ((Real.pi : ℂ) ^ (-s / 2)) * conj (Complex.Gamma (s / 2)) := by
          rw [show -(conj s) / 2 = conj (-s / 2) by
                rw [map_div₀, map_neg, map_ofNat],
              show conj s / 2 = conj (s / 2) by rw [map_div₀, map_ofNat],
              Complex.cpow_conj _ _ harg, Complex.conj_ofReal, Complex.Gamma_conj]
    _ = conj ((Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2)) := by rw [map_mul]
    _ = conj (Gammaℝ s) := by rw [Gammaℝ_def]

/-- `Complex.Gammaℝ` is nonvanishing on the half-plane `0 < re s`: `Gammaℝ s = π^{-s/2} Γ(s/2)`
with both factors nonzero there. -/
theorem Gammaℝ_ne_zero_of_pos_re {s : ℂ} (hs : 0 < s.re) : Gammaℝ s ≠ 0 := by
  rw [Gammaℝ_def]
  refine mul_ne_zero ?_ ?_
  · rw [Complex.cpow_ne_zero_iff]
    exact Or.inl (Complex.ofReal_ne_zero.mpr Real.pi_ne_zero)
  · refine Complex.Gamma_ne_zero_of_re_pos ?_
    rw [Complex.div_ofNat_re]
    linarith

/-- Conjugation of a complex power with a *nonnegative real* base: `conj (r ^ z) = r ^ conj z`.
This is `Complex.cpow_conj` at a base whose argument is `0 ≠ π`. -/
theorem conj_cpow_ofReal (r : ℝ) (hr : 0 ≤ r) (z : ℂ) :
    conj ((r : ℂ) ^ z) = (r : ℂ) ^ conj z := by
  have harg : ((r : ℂ)).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg hr]
    exact Real.pi_ne_zero.symm
  rw [Complex.cpow_conj (r : ℂ) z harg, Complex.conj_ofReal]

end Complex

namespace DirichletCharacter

variable {N : ℕ} [NeZero N]

/-- **Conjugation of the L-function on the half-plane of convergence.**  For a character whose
values are real (`∀ n, conj (χ n) = χ n`) and `1 < re s`, the Dirichlet L-function satisfies
`L_χ(conj s) = conj (L_χ s)`.

On `1 < re s` both `LFunction` and its conjugate are the naive absolutely convergent Dirichlet
series (`LFunction_eq_LSeries`), and `LSeries_conj` conjugates the coefficients, which the
reality hypothesis leaves fixed. -/
theorem LFunction_conj_of_one_lt_re (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) {s : ℂ} (hs : 1 < s.re) :
    LFunction χ (conj s) = conj (LFunction χ s) := by
  have hcs : 1 < (conj s).re := by simpa using hs
  have key : conj (LSeries (χ ·) s) = LSeries (fun n => conj (χ n)) (conj s) := by
    simpa using LSeries_conj (fun n => χ n) (conj s)
  rw [LFunction_eq_LSeries χ hcs, LFunction_eq_LSeries χ hs, key]
  exact LSeries_congr (fun {n} _ => (hreal n).symm) (conj s)

section gammaFactor

omit [NeZero N]

/-- **Conjugation of the archimedean gamma factor**, unconditionally: an even character has
`gammaFactor χ s = Gammaℝ s` and an odd one `gammaFactor χ s = Gammaℝ (s + 1)`, and both
commute with conjugation (`Complex.Gammaℝ_conj`). -/
theorem gammaFactor_conj (χ : DirichletCharacter ℂ N) (s : ℂ) :
    gammaFactor χ (conj s) = conj (gammaFactor χ s) := by
  rcases χ.even_or_odd with hχ | hχ
  · rw [hχ.gammaFactor_def, hχ.gammaFactor_def, Complex.Gammaℝ_conj]
  · rw [hχ.gammaFactor_def, hχ.gammaFactor_def]
    rw [show conj s + 1 = conj (s + 1) by simp, Complex.Gammaℝ_conj]

/-- The archimedean gamma factor is nonvanishing on `χ` for `1 < re s` (both possible arguments
`s` and `s + 1` lie in the half-plane `0 < re`, where `Complex.Gammaℝ` is nonzero because
`Complex.Gamma` has no zeros there). -/
theorem gammaFactor_ne_zero_of_one_lt_re (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) : gammaFactor χ s ≠ 0 := by
  rcases χ.even_or_odd with hχ | hχ
  · rw [hχ.gammaFactor_def]
    exact Complex.Gammaℝ_ne_zero_of_pos_re (by linarith)
  · rw [hχ.gammaFactor_def]
    exact Complex.Gammaℝ_ne_zero_of_pos_re (s := s + 1) (by simp; linarith)

end gammaFactor

/-- **Conjugation of the completed L-function on `1 < re s`.**  On the half-plane where the
L-function is given by its Dirichlet series, solve
`LFunction_eq_completed_div_gammaFactor` for `completedLFunction = LFunction * gammaFactor`
(the gamma factor is nonzero there), then conjugate using `LFunction_conj_of_one_lt_re` and
`gammaFactor_conj`. -/
theorem completedLFunction_conj_of_one_lt_re (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) {s : ℂ} (hs : 1 < s.re) :
    completedLFunction χ (conj s) = conj (completedLFunction χ s) := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    exact absurd hs (by norm_num)
  have hcs : 1 < (conj s).re := by simpa using hs
  have hcs0 : conj s ≠ 0 := fun h => hs0 (by simpa using congrArg conj h)
  have hg : gammaFactor χ s ≠ 0 := gammaFactor_ne_zero_of_one_lt_re χ hs
  have hgc : gammaFactor χ (conj s) ≠ 0 := gammaFactor_ne_zero_of_one_lt_re χ hcs
  have e1 : completedLFunction χ s = LFunction χ s * gammaFactor χ s := by
    rw [LFunction_eq_completed_div_gammaFactor χ s (Or.inl hs0), div_mul_cancel₀ _ hg]
  have e2 : completedLFunction χ (conj s) = LFunction χ (conj s) * gammaFactor χ (conj s) := by
    rw [LFunction_eq_completed_div_gammaFactor χ (conj s) (Or.inl hcs0), div_mul_cancel₀ _ hgc]
  rw [e2, e1, map_mul, ← LFunction_conj_of_one_lt_re χ hreal hs, ← gammaFactor_conj χ s]

/-! ### Conjugation of the completed L-function: the entire normalisation

`completedLFunction χ` is not entire for the trivial character (pole at `s = 1`), so the identity
theorem cannot be applied to it directly.  Mathlib's `ZMod.completedLFunction₀ Φ` *is* entire
(`ZMod.differentiable_completedLFunction₀`) and differs from `ZMod.completedLFunction Φ` by the two
explicit correction terms of `ZMod.completedLFunction_eq`.  Conjugating those terms is elementary
(the level `N` is a nonnegative real, and `Φ` is real), so:

* the identity on `1 < re s`, available for the L-function itself, transfers to
  `completedLFunction₀` by the identity theorem;
* conjugating `ZMod.completedLFunction_eq` transfers it back to `completedLFunction`. -/

/-- The two correction terms in `ZMod.completedLFunction_eq`, bundled.  They account for the poles
of `completedLFunction` at `s = 0` and `s = 1`. -/
private noncomputable def completedLFunctionCorr (Φ : ZMod N → ℂ) (z : ℂ) : ℂ :=
  (N : ℂ) ^ (-z) * Φ 0 / z + (N : ℂ) ^ (-z) * (∑ j : ZMod N, Φ j) / (1 - z)

/-- `ZMod.completedLFunction_eq`, rearranged. -/
private theorem completedLFunction_eq_corr (Φ : ZMod N → ℂ) (z : ℂ) :
    ZMod.completedLFunction Φ z = ZMod.completedLFunction₀ Φ z - completedLFunctionCorr Φ z := by
  rw [ZMod.completedLFunction_eq]
  unfold completedLFunctionCorr
  ring

/-- The correction terms commute with conjugation for a real function `Φ`. -/
private theorem completedLFunctionCorr_conj (Φ : ZMod N → ℂ)
    (hreal : ∀ n : ℕ, conj (Φ n) = Φ n) (z : ℂ) :
    completedLFunctionCorr Φ (conj z) = conj (completedLFunctionCorr Φ z) := by
  have hN : ∀ w : ℂ, conj ((N : ℂ) ^ (-w)) = (N : ℂ) ^ (-(conj w)) := by
    intro w
    rw [show (N : ℂ) = ((N : ℝ) : ℂ) by simp,
      Complex.conj_cpow_ofReal (N : ℝ) (Nat.cast_nonneg N) (-w), map_neg]
  have h0 : conj (Φ (0 : ZMod N)) = Φ (0 : ZMod N) := by simpa using hreal 0
  have hj : ∀ j : ZMod N, conj (Φ j) = Φ j := by
    intro j
    have : (j.val : ZMod N) = j := ZMod.natCast_zmod_val j
    rw [← this]
    exact hreal j.val
  have hsum : conj (∑ j : ZMod N, Φ j) = ∑ j : ZMod N, Φ j := by
    rw [map_sum]
    exact Finset.sum_congr rfl fun j _ => hj j
  unfold completedLFunctionCorr
  simp only [map_add, map_mul, map_div₀, map_one, map_sub, hN z, h0, hsum]

/-- **Conjugation of the entire normalisation of the completed L-function.**  If `Φ` is real on `ℕ`
and `ZMod.completedLFunction Φ` is conjugation-equivariant on `1 < re s`, then the entire function
`ZMod.completedLFunction₀ Φ` is conjugation-equivariant everywhere (identity theorem). -/
private theorem zmod_completedLFunction₀_conj (Φ : ZMod N → ℂ)
    (hreal : ∀ n : ℕ, conj (Φ n) = Φ n)
    (hcf : ∀ z : ℂ, 1 < z.re →
      ZMod.completedLFunction Φ (conj z) = conj (ZMod.completedLFunction Φ z)) (s : ℂ) :
    ZMod.completedLFunction₀ Φ (conj s) = conj (ZMod.completedLFunction₀ Φ s) := by
  -- On the half-plane `1 < re z`, transfer the identity to `completedLFunction₀`.
  have h₀_right : ∀ z : ℂ, 1 < z.re →
      ZMod.completedLFunction₀ Φ (conj z) = conj (ZMod.completedLFunction₀ Φ z) := by
    intro z hz
    have e1 : ZMod.completedLFunction₀ Φ z
        = ZMod.completedLFunction Φ z + completedLFunctionCorr Φ z := by
      rw [completedLFunction_eq_corr]; ring
    have e2 : ZMod.completedLFunction₀ Φ (conj z)
        = ZMod.completedLFunction Φ (conj z) + completedLFunctionCorr Φ (conj z) := by
      rw [completedLFunction_eq_corr]; ring
    rw [e2, hcf z hz, completedLFunctionCorr_conj Φ hreal z, ← map_add, e1]
  -- Propagate to all of `ℂ` with the identity theorem.
  have hF : Differentiable ℂ
      (fun z : ℂ => conj (ZMod.completedLFunction₀ Φ (conj z))) := by
    intro z
    exact differentiableAt_conj_conj_iff.mpr
      (ZMod.differentiable_completedLFunction₀ Φ).differentiableAt
  have heq : (fun z : ℂ => ZMod.completedLFunction₀ Φ z)
      = (fun z : ℂ => conj (ZMod.completedLFunction₀ Φ (conj z))) := by
    refine AnalyticOnNhd.eq_of_eventuallyEq (z₀ := 2)
      ((ZMod.differentiable_completedLFunction₀ Φ).differentiableOn.analyticOnNhd isOpen_univ)
      (hF.differentiableOn.analyticOnNhd isOpen_univ) ?_
    refine eventuallyEq_of_mem
      ((isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num : (1 : ℝ) < (2 : ℂ).re)) ?_
    intro z hz
    have h' : conj (ZMod.completedLFunction₀ Φ (conj z)) = ZMod.completedLFunction₀ Φ z := by
      simpa using congrArg conj (h₀_right z hz)
    exact h'.symm
  have hfin := congrFun heq s
  have hconj := congrArg conj hfin
  simpa using hconj.symm

/-- **Conjugation of the entire normalisation `completedLFunction₀` of the completed L-function.**
For a real character, the entire function `ZMod.completedLFunction₀ χ` (which differs from
`completedLFunction χ` by the two pole terms of `ZMod.completedLFunction_eq`) is
conjugation-equivariant for all `s`. -/
theorem completedLFunction₀_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    ZMod.completedLFunction₀ (⇑χ) (conj s) = conj (ZMod.completedLFunction₀ (⇑χ) s) :=
  zmod_completedLFunction₀_conj (⇑χ) hreal
    (fun _ hz => completedLFunction_conj_of_one_lt_re χ hreal hz) s

/-- **Conjugation of the completed L-function.**  If `χ` takes real values on `ℕ`
(`∀ n, conj (χ n) = χ n`), then `completedLFunction χ` is conjugation-equivariant:
`Λ_χ(conj s) = conj (Λ_χ s)` for **all** `s`.

The proof uses `completedLFunction_conj_of_one_lt_re` on the half-plane `1 < re s`, extends it to
the entire normalisation `ZMod.completedLFunction₀ χ` by the identity theorem, and transfers back
through the two pole correction terms (`completedLFunctionCorr_conj`).  No hypothesis on `N`,
primitivity, or the parity of `χ` is needed: this covers the trivial character as well. -/
theorem completedLFunction_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    completedLFunction χ (conj s) = conj (completedLFunction χ s) := by
  change ZMod.completedLFunction (⇑χ) (conj s) = conj (ZMod.completedLFunction (⇑χ) s)
  rw [completedLFunction_eq_corr (⇑χ) (conj s),
    completedLFunction₀_conj χ hreal s,
    completedLFunctionCorr_conj (⇑χ) hreal s, ← map_sub,
    ← completedLFunction_eq_corr (⇑χ) s]

end DirichletCharacter

/-- **Conjugation of the completed Riemann zeta function**, obtained as the `N = 1` case of
`DirichletCharacter.completedLFunction_conj` (`completedLFunction_modOne_eq`). -/
theorem completedRiemannZeta_conj (s : ℂ) :
    completedRiemannZeta (conj s) = conj (completedRiemannZeta s) := by
  have hreal : ∀ n : ℕ, conj ((1 : DirichletCharacter ℂ 1) n) = (1 : DirichletCharacter ℂ 1) n := by
    intro n
    rw [MulChar.one_apply (isUnit_of_subsingleton _)]
    simp
  simpa only [DirichletCharacter.completedLFunction_modOne_eq] using
    (DirichletCharacter.completedLFunction_conj (1 : DirichletCharacter ℂ 1) hreal s)
