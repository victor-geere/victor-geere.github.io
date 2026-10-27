/-
  DirichletExplicitWiring2.lean — **wiring the assembled explicit formula into
  `DirichletExplicitData`.**

  `dirichlet_explicit_formula_assembled` (`DirichletMellinPrereq.lean`) proves

    `π·Re(∑_{z∈Z} m z·F z)
        = Re(∫ arch) − Re(∑' n, ∫ F·Λ(n)χ(n)n^{−(c+it)})
          + Im(horizontal edge terms)`,

  i.e. exactly the `lhs = rhsTrue` field of `DirichletExplicitData` with
  `lhs = zero sum` and `rhsTrue = archimedean − prime + horizontal edges`.  Combining it with the
  numerical split `h_split` yields `DirichletExplicitData` and hence the Route-C residual bound —
  now with the identity coming from the *analytic* side (archimedean − prime) rather than from the
  zero side.
-/
import DirichletExplicitWiring
import DirichletMellinPrereq

open MeasureTheory intervalIntegral
open scoped Interval
open Rh45RouteBAnalytic
open DirichletCharacter

namespace RouteABC

noncomputable section

/-- The `rhsTrue` of the assembled explicit formula: archimedean − prime + horizontal edges. -/
noncomputable def assembledRhs {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (F : ℂ → ℂ)
    (c : ℝ) (t0 t1 : ℝ) : ℝ :=
  (∫ t in t0..t1, F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))).re
    - (∑' n : ℕ, ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
        * (n : ℂ) ^ (-(c + t * Complex.I))).re
    + ((∫ x in (1 / 2 : ℝ)..c, F (x + t0 * Complex.I)
          * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
        - (∫ x in (1 / 2 : ℝ)..c, F (x + t1 * Complex.I)
          * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))).im

/-- A `DirichletExplicitData` whose identity is the **assembled explicit formula**
(`zero sum = archimedean − prime + horizontal edge terms`). -/
noncomputable def dirichletExplicitDataOfAssembled {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (hχ1 : χ ≠ 1) (hE : χ.Even) {F : ℂ → ℂ}
    (hF : Continuous F) (hF_refl : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    {c B : ℝ} (hc : 1 < c) (hB : 0 ≤ B) (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B)
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hAn : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hF_an : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1)
    (hcont : ContinuousOn (fun s => F s * logDeriv (dirichletCompleted χ) s)
      ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ (fun s => F s * logDeriv (dirichletCompleted χ) s) x)
    (hint0 : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint1 : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint_arch : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))) volume t0 t1)
    (hint_L : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) volume t0 t1)
    (rhsComputed zeroTail primeTail archTail : ℝ)
    (h_split : assembledRhs χ F c t0 t1
      = rhsComputed + (zeroTail + primeTail + archTail)) :
    DirichletExplicitData χ where
  lhs := Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re
  rhsTrue := assembledRhs χ F c t0 t1
  rhsComputed := rhsComputed
  zeroTail := zeroTail
  primeTail := primeTail
  archTail := archTail
  h_identity := dirichlet_explicit_formula_assembled χ hχ hχinv hsign hreal hχ1 hE hF hF_refl hc
    hB hFb t0 t1 Z m ht hAn hF_an hZ hm hno hint₀ hint₁ hcont hdiff hint0 hint1 hint_arch hint_L
  h_split := h_split

/-- **Route-C residual bound with the assembled explicit formula as identity.** -/
theorem routeC_residual_bound_of_assembled {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (hχ1 : χ ≠ 1) (hE : χ.Even) {F : ℂ → ℂ}
    (hF : Continuous F) (hF_refl : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    {c B : ℝ} (hc : 1 < c) (hB : 0 ≤ B) (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B)
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hAn : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hF_an : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1)
    (hcont : ContinuousOn (fun s => F s * logDeriv (dirichletCompleted χ) s)
      ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ (fun s => F s * logDeriv (dirichletCompleted χ) s) x)
    (hint0 : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint1 : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint_arch : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))) volume t0 t1)
    (hint_L : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) volume t0 t1)
    (rhsComputed zeroTail primeTail archTail : ℝ)
    (h_split : assembledRhs χ F c t0 t1
      = rhsComputed + (zeroTail + primeTail + archTail)) :
    |Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re - rhsComputed|
      ≤ |zeroTail| + |primeTail| + |archTail| :=
  (dirichletExplicitDataOfAssembled χ hχ hχinv hsign hreal hχ1 hE hF hF_refl hc hB hFb t0 t1 Z m
    ht hAn hF_an hZ hm hno hint₀ hint₁ hcont hdiff hint0 hint1 hint_arch hint_L rhsComputed
    zeroTail primeTail archTail h_split).validated

/-- **Finite/tail decomposition of a summable real series** — the abstract shape of the numerical
truncation in `DirichletExplicitData.h_split`. -/
theorem tsum_eq_finite_add_tail {f : ℕ → ℝ} (hf : Summable f) (K : ℕ) :
    ∑' n, f n = ∑ n ∈ Finset.range K, f n + ∑' n, f (n + K) :=
  (hf.sum_add_tsum_nat_add K).symm

/-- **`h_split` discharged by truncation.**  A `DirichletExplicitData` whose `rhsTrue` is a
summable total, whose `rhsComputed` is its finite part, and whose three tails partition the
remainder.  The field `h_split` is *proved* (no longer a hypothesis): it is
`tsum_eq_finite_add_tail` followed by the partition identity. -/
noncomputable def dirichletExplicitDataOfTruncation {N : ℕ} (χ : DirichletCharacter ℂ N)
    (lhs : ℝ) (f : ℕ → ℝ) (hf : Summable f) (K : ℕ)
    (zeroTail primeTail archTail : ℝ)
    (h_part : ∑' n, f (n + K) = zeroTail + primeTail + archTail)
    (h_id : lhs = ∑' n, f n) :
    DirichletExplicitData χ where
  lhs := lhs
  rhsTrue := ∑' n, f n
  rhsComputed := ∑ n ∈ Finset.range K, f n
  zeroTail := zeroTail
  primeTail := primeTail
  archTail := archTail
  h_identity := h_id
  h_split := by rw [tsum_eq_finite_add_tail hf K, h_part]

/-- The residual bound for the truncation instance: `|lhs − finite part| ≤ |tails|`. -/
theorem routeC_residual_bound_of_truncation {N : ℕ} (χ : DirichletCharacter ℂ N)
    (lhs : ℝ) (f : ℕ → ℝ) (hf : Summable f) (K : ℕ)
    (zeroTail primeTail archTail : ℝ)
    (h_part : ∑' n, f (n + K) = zeroTail + primeTail + archTail)
    (h_id : lhs = ∑' n, f n) :
    |lhs - ∑ n ∈ Finset.range K, f n| ≤ |zeroTail| + |primeTail| + |archTail| :=
  (dirichletExplicitDataOfTruncation χ lhs f hf K zeroTail primeTail archTail h_part h_id).validated

/-- **Both fields discharged.**  A `DirichletExplicitData` whose
* `h_identity` is the assembled explicit formula (§58), and
* `h_split` is **proved** by truncating the prime series at `K` (`tsum_eq_finite_add_tail`),

so the structure carries neither an analytic nor a truncation hypothesis. -/
noncomputable def dirichletExplicitDataOfAssembledTruncated {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (hχ1 : χ ≠ 1) (hE : χ.Even) {F : ℂ → ℂ}
    (hF : Continuous F) (hF_refl : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    {c B : ℝ} (hc : 1 < c) (hB : 0 ≤ B) (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B)
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hAn : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hF_an : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1)
    (hcont : ContinuousOn (fun s => F s * logDeriv (dirichletCompleted χ) s)
      ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ (fun s => F s * logDeriv (dirichletCompleted χ) s) x)
    (hint0 : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint1 : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint_arch : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))) volume t0 t1)
    (hint_L : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) volume t0 t1)
    (hsum : Summable fun n : ℕ => ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
      * (n : ℂ) ^ (-(c + t * Complex.I))) (K : ℕ) :
    DirichletExplicitData χ where
  lhs := Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re
  rhsTrue := assembledRhs χ F c t0 t1
  rhsComputed := (∫ t in t0..t1, F (c + t * Complex.I)
        * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
           + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))).re
      - (∑ n ∈ Finset.range K, (∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
          * (n : ℂ) ^ (-(c + t * Complex.I))).re)
      + ((∫ x in (1 / 2 : ℝ)..c, F (x + t0 * Complex.I)
            * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
          - (∫ x in (1 / 2 : ℝ)..c, F (x + t1 * Complex.I)
            * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))).im
  zeroTail := 0
  primeTail := -(∑' n : ℕ, (∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ (n + K)
      * ((n + K : ℕ) : ℂ) ^ (-(c + t * Complex.I))).re)
  archTail := 0
  h_identity := dirichlet_explicit_formula_assembled χ hχ hχinv hsign hreal hχ1 hE hF hF_refl hc
    hB hFb t0 t1 Z m ht hAn hF_an hZ hm hno hint₀ hint₁ hcont hdiff hint0 hint1 hint_arch hint_L
  h_split := by
    rw [assembledRhs, Complex.re_tsum hsum,
      tsum_eq_finite_add_tail (f := fun n : ℕ => (∫ t in t0..t1, F (c + t * Complex.I)
        * dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))).re)
        (hsum.map Complex.reCLM Complex.reCLM.continuous) K]
    ring

end

end RouteABC
