/-
  DirichletZeroCounting.lean — the **zero set of the completed Dirichlet L-function** and its
  basic topology (closed, discrete, finite on compacts).

  This mirrors Mathlib's `riemannZetaZeros` API (`Mathlib/NumberTheory/LSeries/ZetaZeros.lean`)
  for `dirichletCompleted χ`.  It is the foundation for the Riemann–von Mangoldt zero-counting
  asymptotics (`N(T+1) − N(T) ≈ (1/2π) log(qT/2π)`) that `DirichletZeroTail.lean` currently
  assumes as a density input.
-/
import DirichletCompletedLogDeriv
import DirichletAnalytic
import DirichletCompletedSymmetry
import Mathlib.Analysis.Analytic.Order
import DirichletZeroTail

open Filter
open DirichletCharacter
open Rh45RouteBAnalytic
open MeasureTheory
open scoped Interval

namespace RouteABC

noncomputable section

/-- The zeros of the completed Dirichlet L-function `dirichletCompleted χ`. -/
def dirichletLZeros {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) : Set ℂ := dirichletCompleted χ ⁻¹' {0}

lemma mem_dirichletLZeros {N : ℕ} [NeZero N] {χ : DirichletCharacter ℂ N} {z : ℂ} :
    z ∈ dirichletLZeros χ ↔ dirichletCompleted χ z = 0 := .rfl

/-- `dirichletCompleted χ` is nonzero at `s = 2` for nontrivial `χ` (where the Euler product
converges). -/
theorem dirichletCompleted_two_ne_zero {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) :
    dirichletCompleted χ 2 ≠ 0 := by
  have hN : (N : ℂ) ≠ 0 := by exact_mod_cast (NeZero.ne N)
  rw [show dirichletCompleted χ 2 = (N : ℂ) ^ ((2 : ℂ) / 2) * completedLFunction χ 2 from rfl]
  refine mul_ne_zero ?_ (completedLFunction_ne_zero_of_one_lt_re χ (by norm_num))
  exact Complex.cpow_ne_zero_iff.mpr (Or.inl hN)

/-- The complement of the zero set is codiscrete. -/
theorem compl_dirichletLZeros_mem_codiscrete {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) : (dirichletLZeros χ)ᶜ ∈ codiscrete ℂ := by
  have han : AnalyticOnNhd ℂ (dirichletCompleted χ) Set.univ := by
    intro z _
    rw [Complex.analyticAt_iff_eventually_differentiableAt]
    exact Filter.Eventually.of_forall (differentiable_dirichletCompleted χ hχ)
  exact AnalyticOnNhd.preimage_zero_mem_codiscrete han (dirichletCompleted_two_ne_zero χ)

/-- The zero set is closed. -/
theorem isClosed_dirichletLZeros {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) : IsClosed (dirichletLZeros χ) :=
  isOpen_compl_iff.mp (mem_codiscrete'.mp (compl_dirichletLZeros_mem_codiscrete χ hχ)).1

/-- The zero set is discrete. -/
theorem isDiscrete_dirichletLZeros {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) : IsDiscrete (dirichletLZeros χ) :=
  by simpa using (mem_codiscrete'.mp (compl_dirichletLZeros_mem_codiscrete χ hχ)).2

/-- Any compact set contains only finitely many zeros of `dirichletCompleted χ`. -/
theorem IsCompact.inter_dirichletLZeros_finite {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {S : Set ℂ} (hS : IsCompact S) : (S ∩ dirichletLZeros χ).Finite := by
  apply (hS.inter_right (isClosed_dirichletLZeros χ hχ)).finite
  exact (isDiscrete_dirichletLZeros χ hχ).mono Set.inter_subset_right

/-- **Route B count for the completed Dirichlet L-function.**  If `Z` is exactly the zero set of
`dirichletCompleted χ` in the rectangle `[0,1] × [t₀,t₁]` with orders `m`, then the multiplicity
weighted count is `Im(rightPath (logDeriv (dirichletCompleted χ)))/π`:

    `Im (rightPath (logDeriv (dirichletCompleted χ)) t₀ t₁) = π · ∑_{z∈Z} m z`.

This instantiates `routeB_general_of_logDeriv` with the reflection
`logDeriv_dirichletCompleted_reflection` and the analyticity of `dirichletCompleted`. -/
theorem dirichletCompleted_routeBCount {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
      volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))
      volume 0 1) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  refine routeB_general_of_logDeriv (dirichletCompleted χ) t0 t1 Z m ht ?_ hmem hm hno ?_
    hint₀ hint₁
  · intro s _
    rw [Complex.analyticAt_iff_eventually_differentiableAt]
    exact Filter.Eventually.of_forall (differentiable_dirichletCompleted χ hχ)
  · intro s
    exact logDeriv_dirichletCompleted_reflection χ hprim hχinv hsign hreal s

/-- **The zero count in a unit rectangle.**  The number of zeros of `dirichletCompleted χ` with
`0 < Re s < 1` and `T < Im s ≤ T + 1` (distinct zeros, not multiplicity-weighted). -/
noncomputable def dirichletZeroCount {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (T : ℝ) : ℕ :=
  ((dirichletLZeros χ) ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T < s.im ∧ s.im ≤ T + 1}).ncard

/-- The rectangle of the count is compact (so the intersection with the zero set is finite). -/
theorem finite_dirichletZeroCount_set {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (T : ℝ) :
    ((dirichletLZeros χ) ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T < s.im ∧ s.im ≤ T + 1}).Finite := by
  have hrect : {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T < s.im ∧ s.im ≤ T + 1}
      ⊆ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc T (T + 1)) := by
    intro s hs
    rw [Complex.mem_reProdIm, Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
      Set.uIcc_of_le (le_add_of_nonneg_right (by norm_num : (0:ℝ) ≤ 1)), Set.mem_Icc, Set.mem_Icc]
    exact ⟨⟨le_of_lt hs.1, le_of_lt hs.2.1⟩, ⟨le_of_lt hs.2.2.1, hs.2.2.2⟩⟩
  have hbig : ((Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc T (T + 1)) ∩ dirichletLZeros χ).Finite :=
    IsCompact.inter_dirichletLZeros_finite χ hχ (isCompact_uIcc.reProdIm isCompact_uIcc)
  exact hbig.subset fun s hs => ⟨hrect hs.2, hs.1⟩

/-- **Riemann–von Mangoldt density bound (named interface).**  The number of zeros in `(T, T+1]`
grows at most like `log(q(T+2))`.  This is the density input `DirichletZeroTail.lean` currently
assumes; stating it as a named `Prop` makes the dependency explicit. -/
def RiemannVonMangoldtDensity {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 2 ≤ T →
    (dirichletZeroCount χ T : ℝ) ≤ C * Real.log ((N : ℝ) * (T + 2))

/-- **Zero count in a general imaginary interval** `(t₀, t₁]` within the critical strip. -/
noncomputable def dirichletZeroCountIn {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (t0 t1 : ℝ) : ℕ :=
  ((dirichletLZeros χ) ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ t0 < s.im ∧ s.im ≤ t1}).ncard

/-- The unit-interval count is the `t₀ = T`, `t₁ = T+1` case. -/
theorem dirichletZeroCount_eq_countIn {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (T : ℝ) :
    dirichletZeroCount χ T = dirichletZeroCountIn χ T (T + 1) := rfl

/-- **Density consequence.**  `RiemannVonMangoldtDensity` bounds the count in *any* unit
interval `(T, T+1]` by `C·log(q(T+2))`. -/
theorem countIn_unit_le_of_density {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (h : RiemannVonMangoldtDensity χ) :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 2 ≤ T →
      (dirichletZeroCountIn χ T (T + 1) : ℝ) ≤ C * Real.log ((N : ℝ) * (T + 2)) := by
  obtain ⟨C, hC, hb⟩ := h
  exact ⟨C, hC, fun T hT => by rw [← dirichletZeroCount_eq_countIn]; exact hb T hT⟩

/-- **Cumulative zero count** `N(T)`: zeros with `0 < Re s < 1` and `0 < Im s ≤ T`. -/
noncomputable def dirichletZeroCountUpTo {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (T : ℝ) : ℕ :=
  ((dirichletLZeros χ) ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T}).ncard

/-- Finiteness of the cumulative count's intersection for `T ≥ 0`. -/
theorem finite_dirichletZeroCountUpTo_set {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T : ℝ} (hT : 0 ≤ T) :
    ((dirichletLZeros χ) ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T}).Finite := by
  have hrect : {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T}
      ⊆ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc 0 T) := by
    intro s hs
    rw [Complex.mem_reProdIm, Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
      Set.uIcc_of_le hT, Set.mem_Icc, Set.mem_Icc]
    exact ⟨⟨le_of_lt hs.1, le_of_lt hs.2.1⟩, ⟨le_of_lt hs.2.2.1, hs.2.2.2⟩⟩
  have hbig : ((Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc 0 T) ∩ dirichletLZeros χ).Finite :=
    IsCompact.inter_dirichletLZeros_finite χ hχ (isCompact_uIcc.reProdIm isCompact_uIcc)
  exact hbig.subset fun s hs => ⟨hrect hs.2, hs.1⟩

/-- **Block recurrence for the cumulative count.**  `N(T) = N(T−1) + #{zeros in (T−1,T]}` —
the disjoint-union decomposition underlying the block bound. -/
theorem dirichletZeroCountUpTo_eq_add {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T : ℝ} (hT : 1 ≤ T) :
    dirichletZeroCountUpTo χ T
      = dirichletZeroCountUpTo χ (T - 1) + dirichletZeroCountIn χ (T - 1) T := by
  have hset : dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T}
      = (dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T - 1})
        ∪ (dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T - 1 < s.im ∧ s.im ≤ T}) := by
    ext s
    simp only [Set.mem_inter_iff, Set.mem_setOf_eq, Set.mem_union]
    constructor
    · rintro ⟨h1, h2, h3, h4, h5⟩
      by_cases h : s.im ≤ T - 1
      · exact Or.inl ⟨h1, h2, h3, h4, h⟩
      · exact Or.inr ⟨h1, h2, h3, lt_of_not_ge h, h5⟩
    · rintro (⟨h1, h2, h3, h4, h5⟩ | ⟨h1, h2, h3, h4, h5⟩)
      · exact ⟨h1, h2, h3, h4, le_trans h5 (by linarith)⟩
      · exact ⟨h1, h2, h3, lt_of_le_of_lt (by linarith) h4, h5⟩
  have hfin1 : ((dirichletLZeros χ) ∩
      {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T - 1}).Finite :=
    finite_dirichletZeroCountUpTo_set χ hχ (by linarith)
  have hfin2 : ((dirichletLZeros χ) ∩
      {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T - 1 < s.im ∧ s.im ≤ T}).Finite :=
    by simpa only [sub_add_cancel] using finite_dirichletZeroCount_set χ hχ (T - 1)
  simp only [dirichletZeroCountUpTo, dirichletZeroCountIn]
  rw [hset]
  have hdisj : Disjoint (dirichletLZeros χ ∩
      {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T - 1})
      (dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T - 1 < s.im ∧ s.im ≤ T}) := by
    rw [Set.disjoint_left]
    rintro s ⟨_, _, _, _, h5⟩ ⟨_, _, _, h4, _⟩
    linarith
  have h := Set.ncard_union_add_ncard_inter
    (dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ 0 < s.im ∧ s.im ≤ T - 1})
    (dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T - 1 < s.im ∧ s.im ≤ T}) hfin1 hfin2
  rw [Set.disjoint_iff_inter_eq_empty.mp hdisj, Set.ncard_empty, add_zero] at h
  exact h

/-- **Iterated block bound for the cumulative count.**  For `T₀ ≥ 1` and `n : ℕ`,

    `N(T₀ + n) ≤ N(T₀) + ∑_{k<n} #{zeros in (T₀+k, T₀+k+1]}`. -/
theorem dirichletZeroCountUpTo_le_sum {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T0 : ℝ} (hT0 : 1 ≤ T0) (n : ℕ) :
    dirichletZeroCountUpTo χ (T0 + n) ≤ dirichletZeroCountUpTo χ T0
      + ∑ k ∈ Finset.range n, dirichletZeroCountIn χ (T0 + k) (T0 + k + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [show ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 by push_cast; ring]
    have hstep := dirichletZeroCountUpTo_eq_add χ hχ (T := T0 + ((n : ℝ) + 1)) (by push_cast; linarith)
    rw [show T0 + ((n : ℝ) + 1) - 1 = T0 + n by ring] at hstep
    rw [hstep, show T0 + ((n : ℝ) + 1) = T0 + (n : ℝ) + 1 by ring]
    calc dirichletZeroCountUpTo χ (T0 + n)
          + dirichletZeroCountIn χ (T0 + n) (T0 + n + 1)
        ≤ (dirichletZeroCountUpTo χ T0
            + ∑ k ∈ Finset.range n, dirichletZeroCountIn χ (T0 + k) (T0 + k + 1))
          + dirichletZeroCountIn χ (T0 + n) (T0 + n + 1) := by linarith
      _ = dirichletZeroCountUpTo χ T0
            + ∑ k ∈ Finset.range (n + 1), dirichletZeroCountIn χ (T0 + k) (T0 + k + 1) := by
          rw [Finset.sum_range_succ]; ring

/-- The block sum of unit counts is bounded by `C·n·log(q(n+4))`. -/
theorem sum_countIn_range_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {C : ℝ} (hC : 0 < C)
    (hb : ∀ T : ℝ, 2 ≤ T →
      (dirichletZeroCountIn χ T (T + 1) : ℝ) ≤ C * Real.log ((N : ℝ) * (T + 2))) (n : ℕ) :
    ∑ k ∈ Finset.range n, (dirichletZeroCountIn χ (2 + k) (2 + k + 1) : ℝ)
      ≤ C * n * Real.log ((N : ℝ) * (n + 4)) := by
  have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
  have hposn : (0 : ℝ) < (n : ℝ) + 4 := by positivity
  calc ∑ k ∈ Finset.range n, (dirichletZeroCountIn χ (2 + k) (2 + k + 1) : ℝ)
      ≤ ∑ k ∈ Finset.range n, C * Real.log ((N : ℝ) * (n + 4)) := by
        refine Finset.sum_le_sum fun k hk => ?_
        have hklt : (k : ℝ) < (n : ℝ) := by exact_mod_cast Finset.mem_range.mp hk
        have hlog : Real.log ((N : ℝ) * ((2 + (k:ℝ)) + 2)) ≤ Real.log ((N : ℝ) * (n + 4)) :=
          Real.log_le_log (mul_pos (lt_of_lt_of_le zero_lt_one hN1) (by positivity))
            (by nlinarith)
        exact (hb (2 + (k:ℝ)) (by linarith)).trans (mul_le_mul_of_nonneg_left hlog hC.le)
    _ = C * n * Real.log ((N : ℝ) * (n + 4)) := by
        rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]; ring

/-- **Cumulative density bound.**  `RiemannVonMangoldtDensity` controls the cumulative count:
`N(2+n) ≤ N(2) + C·n·log(q(n+4))`.  This is the concrete density consequence of the interface,
combining the iterated block bound with the block-sum estimate. -/
theorem zeroCountUpTo_le_of_density {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (h : RiemannVonMangoldtDensity χ) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, (dirichletZeroCountUpTo χ (2 + n) : ℝ)
      ≤ (dirichletZeroCountUpTo χ 2 : ℝ) + C * n * Real.log ((N : ℝ) * (n + 4)) := by
  obtain ⟨C, hC, hb⟩ := countIn_unit_le_of_density χ h
  refine ⟨C, hC, fun n => ?_⟩
  have hsum := dirichletZeroCountUpTo_le_sum χ hχ (T0 := 2) (by norm_num) n
  have hcast : (dirichletZeroCountUpTo χ (2 + n) : ℝ)
      ≤ (dirichletZeroCountUpTo χ 2 : ℝ)
        + ∑ k ∈ Finset.range n, (dirichletZeroCountIn χ (2 + k) (2 + k + 1) : ℝ) := by
    exact_mod_cast hsum
  linarith [hcast, sum_countIn_range_le χ hC hb n]

/-- **Monotonicity of the cumulative count** in `T` (with the finiteness side condition supplied by
the compact rectangle). -/
theorem dirichletZeroCountUpTo_mono {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T T' : ℝ} (hT : 0 ≤ T) (h : T ≤ T') :
    dirichletZeroCountUpTo χ T ≤ dirichletZeroCountUpTo χ T' := by
  refine Set.ncard_le_ncard (fun s hs => ?_)
    (finite_dirichletZeroCountUpTo_set χ hχ (le_trans hT h))
  exact ⟨hs.1, hs.2.1, hs.2.2.1, hs.2.2.2.1, le_trans hs.2.2.2.2 h⟩

/-- **Cumulative density bound, real `T`.**  `N(T) ≤ N(2) + C·(T+2)·log(q(T+6))` for all real
`T ≥ 2`, obtained by bracketing `T` between consecutive integers and using monotonicity. -/
theorem zeroCountUpTo_le_of_density_real {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (h : RiemannVonMangoldtDensity χ) :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 2 ≤ T →
      (dirichletZeroCountUpTo χ T : ℝ) ≤ (dirichletZeroCountUpTo χ 2 : ℝ)
        + C * (T + 2) * Real.log ((N : ℝ) * (T + 6)) := by
  obtain ⟨C, hC, hb⟩ := zeroCountUpTo_le_of_density χ hχ h
  refine ⟨C, hC, fun T hT => ?_⟩
  set m := ⌈T⌉₊ - 2 with hm
  have hceil : T ≤ (⌈T⌉₊ : ℝ) := Nat.le_ceil T
  have h2 : (2 : ℕ) ≤ ⌈T⌉₊ := by
    have : (2 : ℝ) ≤ (⌈T⌉₊ : ℝ) := le_trans hT hceil
    exact_mod_cast this
  have hm2 : 2 + m = ⌈T⌉₊ := by omega
  have hmono := dirichletZeroCountUpTo_mono χ hχ (T := T) (T' := (⌈T⌉₊ : ℝ))
    (by linarith) hceil
  have hstep := hb m
  have hmle : (m : ℝ) ≤ T + 1 := by
    have hub : ((⌈T⌉₊ : ℕ) : ℝ) ≤ T + 1 :=
      le_of_lt (Nat.ceil_lt_add_one (by linarith : (0 : ℝ) ≤ T))
    have : (m : ℝ) = (⌈T⌉₊ : ℝ) - 2 := by rw [hm]; push_cast [Nat.cast_sub h2]; ring
    linarith
  have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
  have hlogmono : Real.log ((N : ℝ) * ((m : ℝ) + 4)) ≤ Real.log ((N : ℝ) * (T + 6)) :=
    Real.log_le_log (by positivity) (by nlinarith)
  have hmnn : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  have hClog : Real.log ((N : ℝ) * ((m : ℝ) + 4)) ≥ 0 :=
    Real.log_nonneg (by nlinarith [hN1, hmnn])
  have hTm : (0 : ℝ) ≤ T + 2 := by linarith
  calc (dirichletZeroCountUpTo χ T : ℝ)
      ≤ (dirichletZeroCountUpTo χ (⌈T⌉₊ : ℝ) : ℝ) := by exact_mod_cast hmono
    _ = (dirichletZeroCountUpTo χ (2 + (m : ℝ)) : ℝ) := by
        rw [show ((⌈T⌉₊ : ℕ) : ℝ) = 2 + (m : ℝ) from by rw [← hm2]; push_cast; ring]
    _ ≤ (dirichletZeroCountUpTo χ 2 : ℝ) + C * (m : ℝ) * Real.log ((N : ℝ) * ((m : ℝ) + 4)) :=
        hstep
    _ ≤ (dirichletZeroCountUpTo χ 2 : ℝ) + C * (T + 2) * Real.log ((N : ℝ) * (T + 6)) := by
        have hmle2 : (m : ℝ) ≤ T + 2 := by linarith
        have hCm : C * (m : ℝ) ≤ C * (T + 2) := mul_le_mul_of_nonneg_left hmle2 hC.le
        have hCnn : 0 ≤ C * (T + 2) := mul_nonneg hC.le hTm
        have hkey := mul_le_mul hCm hlogmono hClog hCnn
        linarith [hkey]

/-- **Quadratic count bound.**  From the real-`T` density bound and `log x ≤ x`, the cumulative
count satisfies `N(T) ≤ C·(T+6)²` — a polynomial majorant, enough to derive a spacing for the
`n`-th zero. -/
theorem zeroCountUpTo_le_quadratic {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (h : RiemannVonMangoldtDensity χ) :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 2 ≤ T →
      (dirichletZeroCountUpTo χ T : ℝ) ≤ C * (T + 6) ^ 2 := by
  obtain ⟨C0, hC0, hb⟩ := zeroCountUpTo_le_of_density_real χ hχ h
  have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
  refine ⟨(dirichletZeroCountUpTo χ 2 : ℝ) + C0 * (N : ℝ) + 1, by positivity, fun T hT => ?_⟩
  have hT6 : (1 : ℝ) ≤ T + 6 := by linarith
  have hNpos : (0 : ℝ) ≤ (N : ℝ) := le_trans zero_le_one hN1
  have hqT : (1 : ℝ) ≤ (N : ℝ) * (T + 6) := by
    have h := mul_le_mul hN1 hT6 (by norm_num : (0:ℝ) ≤ 1) hNpos
    simpa using h
  have hqTnn : (0 : ℝ) ≤ (N : ℝ) * (T + 6) := le_trans zero_le_one hqT
  have hlog : Real.log ((N : ℝ) * (T + 6)) ≤ (N : ℝ) * (T + 6) := Real.log_le_self hqTnn
  have hsq : (1 : ℝ) ≤ (T + 6) ^ 2 := by
    have h := mul_le_mul hT6 hT6 (by norm_num : (0:ℝ) ≤ 1) (by linarith : (0:ℝ) ≤ T + 6)
    simpa [pow_two] using h
  have h2 : (T + 2 : ℝ) ≤ T + 6 := by linarith
  have h3 : (0 : ℝ) ≤ T + 2 := by linarith
  have hstep1 : Real.log ((N : ℝ) * (T + 6)) * (T + 2) ≤ (N : ℝ) * (T + 6) * (T + 6) := by
    calc Real.log ((N : ℝ) * (T + 6)) * (T + 2) ≤ (N : ℝ) * (T + 6) * (T + 2) :=
          mul_le_mul_of_nonneg_right hlog h3
      _ ≤ (N : ℝ) * (T + 6) * (T + 6) := mul_le_mul_of_nonneg_left h2 hqTnn
  have hN2 : (0 : ℝ) ≤ (dirichletZeroCountUpTo χ 2 : ℝ) := Nat.cast_nonneg _
  have hbnn : (dirichletZeroCountUpTo χ 2 : ℝ) + C0 * ((N : ℝ) * (T + 6) * (T + 6))
      ≤ ((dirichletZeroCountUpTo χ 2 : ℝ) + C0 * (N : ℝ) + 1) * (T + 6) ^ 2 := by
    have hkey : C0 * ((N : ℝ) * (T + 6) * (T + 6)) ≤ (C0 * (N : ℝ)) * (T + 6) ^ 2 := by
      nlinarith [hC0]
    have hN2sq : (dirichletZeroCountUpTo χ 2 : ℝ) ≤ (dirichletZeroCountUpTo χ 2 : ℝ) * (T + 6) ^ 2 := by
      nlinarith [hN2, hsq]
    nlinarith [hkey, hN2sq, hsq]
  linarith [hb T hT, hstep1, hC0, hbnn, mul_le_mul_of_nonneg_left hstep1 hC0.le]

/-- **Density-derived spacing.**  If the `n`-th zero `γ n` is at least `2` and its index is at
most the cumulative count at `γ n`, then `RiemannVonMangoldtDensity` forces `γ n ≳ √n`:

    `max 0 (√(n/C) − 6) ≤ γ n`. -/
theorem densitySpacing_le_zero {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (h : RiemannVonMangoldtDensity χ) {γ : ℕ → ℝ}
    (hγ2 : ∀ n : ℕ, 2 ≤ γ n) (hcount : ∀ n : ℕ, (n : ℝ) ≤ dirichletZeroCountUpTo χ (γ n)) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
      max 0 (Real.sqrt ((n : ℝ) / C) - 6) ≤ γ n := by
  obtain ⟨C, hC, hb⟩ := zeroCountUpTo_le_quadratic χ hχ h
  refine ⟨C, hC, fun n => ?_⟩
  have h1 : (n : ℝ) ≤ C * (γ n + 6) ^ 2 := (hcount n).trans (hb (γ n) (hγ2 n))
  have hγnn : 0 ≤ γ n := by linarith [hγ2 n]
  have hsqrt : Real.sqrt ((n : ℝ) / C) ≤ γ n + 6 := by
    rw [Real.sqrt_le_iff]
    refine ⟨by linarith, ?_⟩
    rw [div_le_iff₀ hC]
    nlinarith [h1]
  refine max_le hγnn ?_
  linarith

/-- **Zero tail from the density interface.**  With `RiemannVonMangoldtDensity`, the `n`-th zero
`γ n` dominates the density spacing `f n = max 0 (√(n/C) − 6)`, so the zero tail is dominated by
`Σ h(f n)` — the density input of `DirichletZeroTail.lean` discharged in terms of the named
interface. -/
theorem zeroTail_le_of_density {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    (h : RiemannVonMangoldtDensity χ) {hfun : ℝ → ℝ} (h_nonneg : ∀ t, 0 ≤ hfun t)
    (h_anti : Antitone hfun) {γ : ℕ → ℝ} (hγ2 : ∀ n : ℕ, 2 ≤ γ n)
    (hcount : ∀ n : ℕ, (n : ℝ) ≤ dirichletZeroCountUpTo χ (γ n)) :
    ∃ C : ℝ, 0 < C ∧ (Summable (fun n : ℕ => hfun (max 0 (Real.sqrt ((n : ℝ) / C) - 6))) →
      ∑' n : ℕ, hfun (γ n) ≤ ∑' n : ℕ, hfun (max 0 (Real.sqrt ((n : ℝ) / C) - 6))) := by
  obtain ⟨C, hC, hspacing⟩ := densitySpacing_le_zero χ hχ h hγ2 hcount
  exact ⟨C, hC, fun hf => zeroTail_le_of_majorant h_nonneg h_anti hspacing hf⟩

/-- **Count bound from a `rightPath` bound.**  The multiplicity-weighted zero count is at most
`M/π` whenever `‖rightPath (Λ_χ'/Λ_χ) t₀ t₁‖ ≤ M`. -/
theorem dirichletCompleted_zeroCount_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
      volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))
      volume 0 1)
    {M : ℝ} (hM : ‖rightPath (logDeriv (dirichletCompleted χ)) t0 t1‖ ≤ M) :
    (∑ z ∈ Z, (m z : ℝ)) ≤ M / Real.pi := by
  have h := dirichletCompleted_routeBCount χ hχ hprim hχinv hsign hreal t0 t1 Z m ht hmem hm
    hno hint₀ hint₁
  have h2 : Real.pi * (∑ z ∈ Z, (m z : ℝ)) ≤ M := by
    rw [← h]
    exact (Complex.im_le_norm _).trans hM
  rw [le_div_iff₀ Real.pi_pos]
  linarith

/-- **`rightPath` bound from a contour bound.**  If the integrand is bounded by `M` on the three
segments of `rightPath`, then `‖rightPath g t₀ t₁‖ ≤ M·(1 + |t₁ − t₀|)`. -/
theorem norm_rightPath_le {g : ℂ → ℂ} {t0 t1 M : ℝ} (hM : 0 ≤ M)
    (h0 : ∀ x ∈ Set.uIoc (1 / 2 : ℝ) 1, ‖g (x + t0 * Complex.I)‖ ≤ M)
    (h1 : ∀ y ∈ Set.uIoc t0 t1, ‖g (1 + y * Complex.I)‖ ≤ M)
    (h2 : ∀ x ∈ Set.uIoc (1 / 2 : ℝ) 1, ‖g (x + t1 * Complex.I)‖ ≤ M) :
    ‖rightPath g t0 t1‖ ≤ M * (1 + |t1 - t0|) := by
  rw [rightPath]
  have e1 : ‖∫ x in (1 / 2 : ℝ)..1, g (x + t0 * Complex.I)‖ ≤ M * |1 - 1 / 2| :=
    intervalIntegral.norm_integral_le_of_norm_le_const h0
  have e2 : ‖∫ y in t0..t1, g (1 + y * Complex.I)‖ ≤ M * |t1 - t0| :=
    intervalIntegral.norm_integral_le_of_norm_le_const h1
  have e3 : ‖∫ x in (1 / 2 : ℝ)..1, g (x + t1 * Complex.I)‖ ≤ M * |1 - 1 / 2| :=
    intervalIntegral.norm_integral_le_of_norm_le_const h2
  have h_abs : |1 - (1 / 2 : ℝ)| = 1 / 2 := by norm_num
  rw [h_abs] at e1 e3
  calc ‖(∫ x in (1 / 2 : ℝ)..1, g (x + t0 * Complex.I))
        + Complex.I * (∫ y in t0..t1, g (1 + y * Complex.I))
        - (∫ x in (1 / 2 : ℝ)..1, g (x + t1 * Complex.I))‖
      ≤ ‖(∫ x in (1 / 2 : ℝ)..1, g (x + t0 * Complex.I))
          + Complex.I * (∫ y in t0..t1, g (1 + y * Complex.I))‖
        + ‖∫ x in (1 / 2 : ℝ)..1, g (x + t1 * Complex.I)‖ := norm_sub_le _ _
    _ ≤ (‖∫ x in (1 / 2 : ℝ)..1, g (x + t0 * Complex.I)‖
          + ‖Complex.I * (∫ y in t0..t1, g (1 + y * Complex.I))‖)
        + ‖∫ x in (1 / 2 : ℝ)..1, g (x + t1 * Complex.I)‖ := by
        gcongr; exact norm_add_le _ _
    _ = (‖∫ x in (1 / 2 : ℝ)..1, g (x + t0 * Complex.I)‖
          + ‖∫ y in t0..t1, g (1 + y * Complex.I)‖)
        + ‖∫ x in (1 / 2 : ℝ)..1, g (x + t1 * Complex.I)‖ := by
        rw [norm_mul, Complex.norm_I, one_mul]
    _ ≤ M * (1 + |t1 - t0|) := by
        nlinarith [e1, e2, e3, abs_nonneg (t1 - t0), hM]

/-- **The argument-principle count bound.**  If the logarithmic derivative of `dirichletCompleted χ`
is bounded by `M` on the three segments of `rightPath`, then the multiplicity-weighted zero count in
the rectangle is at most `M·(1 + |t₁ − t₀|)/π`.

This is the assembly step of the Riemann–von Mangoldt bound: the contour bound `M` is what the
strip estimate (`norm_logDeriv_dirichletCompleted_le_of_digamma`, giving `O(1 + log(qT))`) supplies. -/
theorem dirichletCompleted_zeroCount_le_of_contour {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
      volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))
      volume 0 1)
    {M : ℝ} (hM : 0 ≤ M)
    (hc0 : ∀ x ∈ Set.uIoc (1 / 2 : ℝ) 1,
      ‖logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖ ≤ M)
    (hc1 : ∀ y ∈ Set.uIoc t0 t1,
      ‖logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖ ≤ M)
    (hc2 : ∀ x ∈ Set.uIoc (1 / 2 : ℝ) 1,
      ‖logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖ ≤ M) :
    (∑ z ∈ Z, (m z : ℝ)) ≤ M * (1 + |t1 - t0|) / Real.pi := by
  have hpath := norm_rightPath_le (g := logDeriv (dirichletCompleted χ)) hM hc0 hc1 hc2
  have hcnt := dirichletCompleted_zeroCount_le χ hχ hprim hχinv hsign hreal t0 t1 Z m ht hmem hm
    hno hint₀ hint₁ hpath
  calc (∑ z ∈ Z, (m z : ℝ)) ≤ M * (1 + |t1 - t0|) / Real.pi := hcnt

/-- `logDeriv (dirichletCompleted χ)` behind an `@[irreducible]` wrapper — keeps the large
`logDeriv`/`dirichletCompleted` normalform out of statements, the technique that unblocked §80. -/
@[irreducible] noncomputable def completedLogDeriv {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ) : ℂ :=
  logDeriv (dirichletCompleted χ) s

theorem completedLogDeriv_def {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ) :
    completedLogDeriv χ s = logDeriv (dirichletCompleted χ) s := by
  rw [completedLogDeriv]

/-- **Named interface: the contour bound for `Λ_χ′/Λ_χ` on the critical strip.**

Bounds the **integral** of `‖Λ_χ′/Λ_χ‖` along the three segments of `rightPath` — the horizontal
segments `Im = t₀` and `Im = t₁` over `Re ∈ [1/2, 1]`, and the vertical segment `Re = 1` over
`Im ∈ [t₀,t₁]`.

**Why the integral and not the integrand.**  A *pointwise* bound on `‖Λ_χ′/Λ_χ‖` over the strip is
**false**, even restricted to zero-free points: `Λ_χ′/Λ_χ = deriv Λ_χ / Λ_χ` is unbounded *near* a
zero while being defined there (journal §117).  The integral bound is the correct statement — the
singularities contribute only logarithmically — and it is exactly what the argument-principle count
consumes (§81 takes a bound on `‖rightPath‖`). -/
def CriticalStripLogDerivBound {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
    (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
    + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
    + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
      ≤ C * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|)

/-- **The Riemann–von Mangoldt count bound from the contour interface.**
`N(T+1) − N(T)` — here the multiplicity-weighted count in a unit-height rectangle — is
`O(log(qT))` once `‖Λ_χ′/Λ_χ‖` is bounded **in integral** along the contour (§118). -/
theorem dirichletCompleted_zeroCount_le_of_criticalStrip {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
      volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))
      volume 0 1)
    {C0 : ℝ} (hC0 : 0 < C0)
    (hcs : ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
      + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|))
    {T : ℝ} (hT0 : |t0| ≤ T) (hT1 : |t1| ≤ T) (hT2 : 0 ≤ T) :
    (∑ z ∈ Z, (m z : ℝ))
      ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) / Real.pi := by
  have hb := hcs t0 t1 T ht hT0 hT1 hT2
  have e0 : (∫ x in (1 / 2 : ℝ)..1, ‖logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖)
      = ∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖ := by
    refine intervalIntegral.integral_congr fun x _ => ?_
    simp only [completedLogDeriv_def]
  have e1 : (∫ y in t0..t1, ‖logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖)
      = ∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖ := by
    refine intervalIntegral.integral_congr fun y _ => ?_
    simp only [completedLogDeriv_def]
  have e2 : (∫ x in (1 / 2 : ℝ)..1, ‖logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖)
      = ∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖ := by
    refine intervalIntegral.integral_congr fun x _ => ?_
    simp only [completedLogDeriv_def]
  have hM : ‖rightPath (logDeriv (dirichletCompleted χ)) t0 t1‖
      ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) := by
    rw [rightPath]
    have h0 : ‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖
        ≤ ∫ x in (1 / 2 : ℝ)..1, ‖logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖ :=
      intervalIntegral.norm_integral_le_integral_norm (by norm_num)
    have h1 : ‖∫ y in t0..t1, logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖
        ≤ ∫ y in t0..t1, ‖logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖ :=
      intervalIntegral.norm_integral_le_integral_norm ht.le
    have h2 : ‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖
        ≤ ∫ x in (1 / 2 : ℝ)..1, ‖logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖ :=
      intervalIntegral.norm_integral_le_integral_norm (by norm_num)
    calc ‖(∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
          + Complex.I * (∫ y in t0..t1, logDeriv (dirichletCompleted χ) (1 + y * Complex.I))
          - (∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))‖
        ≤ ‖(∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
            + Complex.I * (∫ y in t0..t1, logDeriv (dirichletCompleted χ) (1 + y * Complex.I))‖
          + ‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖ :=
          norm_sub_le _ _
      _ ≤ (‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖
            + ‖Complex.I * (∫ y in t0..t1, logDeriv (dirichletCompleted χ) (1 + y * Complex.I))‖)
          + ‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖ := by
          gcongr; exact norm_add_le _ _
      _ = (‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖
            + ‖∫ y in t0..t1, logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖)
          + ‖∫ x in (1 / 2 : ℝ)..1, logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖ := by
          rw [norm_mul, Complex.norm_I, one_mul]
      _ ≤ ((∫ x in (1 / 2 : ℝ)..1, ‖logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)‖)
            + (∫ y in t0..t1, ‖logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖))
          + (∫ x in (1 / 2 : ℝ)..1, ‖logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)‖) :=
          add_le_add (add_le_add h0 h1) h2
      _ = (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
            + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
            + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖) := by
          rw [e0, e1, e2]
      _ ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) := hb
  exact dirichletCompleted_zeroCount_le χ hχ hprim hχinv hsign hreal t0 t1 Z m ht
    hmem hm hno hint₀ hint₁ hM

/-- At a zero of a function analytic there whose order is finite, the order is at least `1`. -/
theorem one_le_analyticOrderNatAt_of_zero {f : ℂ → ℂ} {z : ℂ} (hf : AnalyticAt ℂ f z)
    (hz : f z = 0) (htop : analyticOrderAt f z ≠ ⊤) : 1 ≤ analyticOrderNatAt f z := by
  have h0 : analyticOrderAt f z ≠ 0 := fun h => (hf.analyticOrderAt_eq_zero.mp h) hz
  have h1 : (1 : ℕ∞) ≤ analyticOrderAt f z := Order.one_le_iff_ne_zero.mpr h0
  rw [analyticOrderNatAt]
  simpa only [ENat.toNat_one] using ENat.toNat_le_toNat h1 htop

/-- **Multiplicity bridge.**  The number of distinct zeros in a finite set is at most the sum of
their orders. -/
theorem ncard_le_sum_analyticOrder {f : ℂ → ℂ} (hf : ∀ z, AnalyticAt ℂ f z)
    (htop : ∀ z, f z = 0 → analyticOrderAt f z ≠ ⊤)
    {S : Set ℂ} (hS : S.Finite) (hzero : ∀ z ∈ S, f z = 0) :
    S.ncard ≤ ∑ z ∈ hS.toFinset, analyticOrderNatAt f z := by
  rw [Set.ncard_eq_toFinset_card S hS]
  calc hS.toFinset.card = ∑ z ∈ hS.toFinset, 1 := by simp
    _ ≤ ∑ z ∈ hS.toFinset, analyticOrderNatAt f z :=
        Finset.sum_le_sum fun z hz =>
          one_le_analyticOrderNatAt_of_zero (hf z) (hzero z (hS.mem_toFinset.mp hz))
            (htop z (hzero z (hS.mem_toFinset.mp hz)))

/-- **`ncard ≤ Σ order` for the open rectangle.**  If `Z` contains every zero in the open
rectangle `{0 < Re < 1, t₀ < Im < t₁}` and all its elements are zeros, then the distinct-zero count
is at most the sum of the orders — with **no** argument-principle hypothesis `hno` needed. -/
theorem dirichletZeroCountIn_le_orderSum {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {t0 t1 : ℝ} (Z : Finset ℂ)
    (hZsub : ∀ z ∈ Z, dirichletCompleted χ z = 0)
    (htop : ∀ z : ℂ, dirichletCompleted χ z = 0 →
      analyticOrderAt (dirichletCompleted χ) z ≠ ⊤)
    (hZall : ∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → t0 < z.im → z.im ≤ t1 → z ∈ Z) :
    (dirichletZeroCountIn χ t0 t1 : ℝ)
      ≤ ∑ z ∈ Z, (analyticOrderNatAt (dirichletCompleted χ) z : ℝ) := by
  have hsub : dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ t0 < s.im ∧ s.im ≤ t1}
      ⊆ (Z : Set ℂ) := by
    intro s hs
    exact hZall s hs.1 hs.2.1 hs.2.2.1 hs.2.2.2.1 hs.2.2.2.2
  have h1 : (dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ t0 < s.im ∧ s.im ≤ t1}).ncard
      ≤ Z.card := by
    have := Set.ncard_le_ncard hsub Z.finite_toSet
    simpa using this
  have h2 : Z.card
      ≤ ∑ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z := by
    calc Z.card = ∑ z ∈ Z, 1 := by simp
      _ ≤ ∑ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z :=
          Finset.sum_le_sum fun z hz =>
            one_le_analyticOrderNatAt_of_zero (analyticAt_dirichletCompleted χ hχ z)
              (hZsub z hz) (htop z (hZsub z hz))
  have h3 : (∑ z ∈ Z, (analyticOrderNatAt (dirichletCompleted χ) z : ℝ))
      = ((∑ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z : ℕ) : ℝ) := by push_cast; ring
  rw [dirichletZeroCountIn, h3]
  exact Nat.cast_le.mpr (h1.trans h2)

/-- **The composition step.**  Given any finite `Z` containing the zeros in `(T, T+1]`, the
distinct-zero count `dirichletZeroCount χ T` is at most any bound `B` on the sum of the orders over
`Z`.  Its statement mentions neither `logDeriv` nor the rectangle arithmetic — the whole point of the
decomposition (journal §88/§90). -/
theorem dirichletZeroCount_le_of_sum_bound {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T : ℝ} (Z : Finset ℂ)
    (hzeroZ : ∀ z ∈ Z, dirichletCompleted χ z = 0)
    (htop : ∀ z : ℂ, dirichletCompleted χ z = 0 →
      analyticOrderAt (dirichletCompleted χ) z ≠ ⊤)
    (hZall' : ∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → T < z.im → z.im ≤ T + 1 → z ∈ Z)
    {B : ℝ} (hbound : (∑ z ∈ Z, (analyticOrderNatAt (dirichletCompleted χ) z : ℝ)) ≤ B) :
    (dirichletZeroCount χ T : ℝ) ≤ B := by
  rw [dirichletZeroCount_eq_countIn]
  exact (dirichletZeroCountIn_le_orderSum χ hχ Z hzeroZ htop hZall').trans hbound

/-- **`htop`: the order of `dirichletCompleted χ` is finite at every point.**  If
`analyticOrderAt f z = ⊤` then `f` vanishes in a neighbourhood of `z`, so by the identity theorem on
the connected set `ℂ` it vanishes everywhere — contradicting `dirichletCompleted χ 2 ≠ 0`. -/
theorem analyticOrderAt_ne_top_dirichletCompleted {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (z : ℂ) :
    analyticOrderAt (dirichletCompleted χ) z ≠ ⊤ := by
  intro htop
  rw [analyticOrderAt_eq_top] at htop
  have h2 : dirichletCompleted χ 2 = 0 := by
    have han : AnalyticOnNhd ℂ (dirichletCompleted χ) (Set.univ : Set ℂ) := fun w _ =>
      analyticAt_dirichletCompleted χ hχ w
    have h := han.eqOn_zero_of_preconnected_of_eventuallyEq_zero isPreconnected_univ
      (Set.mem_univ z) htop
    exact h (Set.mem_univ 2)
  exact dirichletCompleted_two_ne_zero χ h2


/-- **Reduction of the contour interface to its two edge bounds.** -/
theorem criticalStripLogDerivBound_of_edge_bounds {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hH : ∃ C : ℝ, 0 < C ∧ ∀ t T : ℝ, |t| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t * Complex.I)‖)
        ≤ C * (1 + Real.log ((N : ℝ) * (T + 2))))
    (hV : ∃ C : ℝ, 0 < C ∧ ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
        ≤ C * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|)) :
    CriticalStripLogDerivBound χ := by
  obtain ⟨CH, hCH0, hCH⟩ := hH
  obtain ⟨CV, hCV0, hCV⟩ := hV
  refine ⟨2 * CH + CV + 1, by positivity, fun t0 t1 T ht hT0 hT1 hT2 => ?_⟩
  have hN1 : (1 : ℝ) ≤ N := by
    exact_mod_cast Nat.one_le_iff_ne_zero.mpr (NeZero.ne N)
  have hL : (0 : ℝ) ≤ Real.log ((N : ℝ) * (T + 2)) := by
    refine Real.log_nonneg ?_
    nlinarith
  have hD : (0 : ℝ) ≤ |t1 - t0| := abs_nonneg _
  have e1 := hCH t0 T hT0 hT2
  have e2 := hCH t1 T hT1 hT2
  have e3 := hCV t0 t1 T ht hT0 hT1 hT2
  have hC1 : (0 : ℝ) < 1 + Real.log ((N : ℝ) * (T + 2)) := by linarith
  have hX0 : (0 : ℝ) ≤ 1 + Real.log ((N : ℝ) * (T + 2)) := hC1.le
  have hD1 : (0 : ℝ) ≤ 1 + |t1 - t0| := by linarith [abs_nonneg (t1 - t0)]
  have h1 : CH * (1 + Real.log ((N : ℝ) * (T + 2)))
      ≤ CH * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) := by
    nth_rewrite 1 [← mul_one (CH * (1 + Real.log ((N : ℝ) * (T + 2))))]
    exact mul_le_mul_of_nonneg_left (by linarith [abs_nonneg (t1 - t0)])
      (mul_nonneg hCH0.le hX0)
  have hstep : CH * (1 + Real.log ((N : ℝ) * (T + 2)))
        + CV * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|)
        + CH * (1 + Real.log ((N : ℝ) * (T + 2)))
      ≤ (2 * CH + CV + 1) * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) := by
    nlinarith [h1, hX0, hD1, hCH0, hCV0]
  linarith [e1, e2, e3, hstep]

/-- **Step 1 of the contour repair (O1.T9).**  The multiplicity-weighted zero count is monotone in
the rectangle.  This is the limit-passage step that lets a bound proved for rectangles with
*zero-free* horizontal edges transfer to an arbitrary rectangle: take `t0, t1` through zero-free
heights and pass to the limit. -/
theorem zeroCount_mono {Z Z' : Finset ℂ} {m : ℂ → ℕ} (hsub : Z ⊆ Z') :
    (∑ z ∈ Z, m z) ≤ ∑ z ∈ Z', m z :=
  Finset.sum_le_sum_of_subset_of_nonneg hsub (fun z _ _ => Nat.zero_le _)

/-- **Step 2 of the contour repair (O1.T9), combinatorial half.**  If the zeros of `f` in the
rectangle `[a,b] × (t0-ε, t0+ε)` are finite, then some height `t` in `(t0-ε, t0+ε)` is zero-free on
the whole segment `[a,b]` — so a horizontal edge can always be perturbed off the zeros. -/
theorem exists_zero_free_height_of_finite {f : ℂ → ℂ} {a b t0 ε : ℝ} (hε : 0 < ε)
    (hfin : {z : ℂ | f z = 0 ∧ z.re ∈ Set.Icc a b ∧ z.im ∈ Set.Ioo (t0 - ε) (t0 + ε)}.Finite) :
    ∃ t ∈ Set.Ioo (t0 - ε) (t0 + ε), ∀ x ∈ Set.Icc a b, f (x + t * Complex.I) ≠ 0 := by
  have him : (Complex.im '' {z : ℂ | f z = 0 ∧ z.re ∈ Set.Icc a b ∧
      z.im ∈ Set.Ioo (t0 - ε) (t0 + ε)}).Finite := hfin.image Complex.im
  have hlt : t0 - ε < t0 + ε := by linarith
  obtain ⟨t, ht, htn⟩ := (Set.Ioo_infinite hlt).exists_notMem_finite him
  refine ⟨t, ht, fun x hx hfx => htn ?_⟩
  have hz : (x + (t : ℂ) * Complex.I) ∈ {z : ℂ | f z = 0 ∧ z.re ∈ Set.Icc a b ∧
      z.im ∈ Set.Ioo (t0 - ε) (t0 + ε)} := ⟨hfx, by simpa using hx, by simpa using ht⟩
  simpa using Set.mem_image_of_mem Complex.im hz

open scoped Topology

/-- **Step 2 of the contour repair (O1.T9), analytic half (i).**  The zero set of an entire function
which is not identically zero is discrete — the input `IsCompact.finite` needs. -/
theorem isDiscrete_zeroSet_of_analyticOnNhd {f : ℂ → ℂ} (hf : AnalyticOnNhd ℂ f Set.univ)
    (hne : f ≠ 0) : IsDiscrete {z : ℂ | f z = 0} := by
  rw [isDiscrete_iff_nhdsNE]
  intro x hx
  rcases (hf x (Set.mem_univ x)).eventually_eq_zero_or_eventually_ne_zero with h0 | hiso
  · exact absurd (funext fun w => hf.eqOn_zero_of_preconnected_of_eventuallyEq_zero
      isPreconnected_univ (Set.mem_univ x) h0 (Set.mem_univ w)) hne
  · have hle : 𝓝[≠] x ≤ 𝓟 {w : ℂ | f w ≠ 0} := Filter.le_principal_iff.mpr hiso
    have hbot : 𝓟 {w : ℂ | f w ≠ 0} ⊓ 𝓟 {z : ℂ | f z = 0} = ⊥ := by
      rw [inf_principal, show {w : ℂ | f w ≠ 0} ∩ {z : ℂ | f z = 0} = ∅ from by
        ext w
        simp]
      simp
    exact le_antisymm (hbot ▸ inf_le_inf hle le_rfl) bot_le

/-- **Step 2 of the contour repair (O1.T9), analytic half (ii).**  A nonzero entire function has
finitely many zeros in the rectangle `[a,b] × [t0-ε, t0+ε]`. -/
theorem finite_zeros_in_reProdIm {f : ℂ → ℂ} (hf : AnalyticOnNhd ℂ f Set.univ) (hne : f ≠ 0)
    (a b t0 ε : ℝ) :
    ({z : ℂ | f z = 0} ∩ (Set.uIcc a b ×ℂ Set.uIcc (t0 - ε) (t0 + ε))).Finite := by
  have hcont : Continuous f := continuousOn_univ.mp hf.continuousOn
  have hclosed : IsClosed ({z : ℂ | f z = 0}) := isClosed_eq hcont continuous_const
  have hcomp : IsCompact (Set.uIcc a b ×ℂ Set.uIcc (t0 - ε) (t0 + ε)) :=
    isCompact_uIcc.reProdIm isCompact_uIcc
  exact (hcomp.inter_left hclosed).finite
    ((isDiscrete_zeroSet_of_analyticOnNhd hf hne).mono Set.inter_subset_left)



/-- **Step 2 of the contour repair (O1.T9), completed.**  For an entire function which is not
identically zero, every horizontal edge can be perturbed to a height that is zero-free on `[a,b]`. -/
theorem exists_zero_free_height_of_analytic {f : ℂ → ℂ} (hf : AnalyticOnNhd ℂ f Set.univ)
    (hne : f ≠ 0) {a b t0 ε : ℝ} (hε : 0 < ε) :
    ∃ t ∈ Set.Ioo (t0 - ε) (t0 + ε), ∀ x ∈ Set.Icc a b, f (x + t * Complex.I) ≠ 0 := by
  refine exists_zero_free_height_of_finite (f := f) hε ?_
  refine (finite_zeros_in_reProdIm hf hne a b t0 ε).subset ?_
  rintro z ⟨hz0, hzre, hzim⟩
  refine ⟨hz0, ?_, ?_⟩
  · exact Set.Icc_subset_uIcc (a := a) (b := b) hzre
  · exact Set.Icc_subset_uIcc (a := t0 - ε) (b := t0 + ε) (Set.Ioo_subset_Icc_self hzim)

/-- **O1.T9, corrected reading.**  Where the horizontal-edge integrand is not integrable on the
segment, the interface's horizontal term is `0` — so those instances of the interface are *weaker*
(one fewer positive term on the left), not false.  This is the formal content of the retraction of
journal 267: the exceptional heights are free, and what the *proof* needs is the generic-height
bound together with the perturbation lemma. -/
theorem horizontal_edge_eq_zero_of_not_integrable {f : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (h : ¬ Integrable (fun x => ‖f x‖) (volume.restrict (Set.Ioc a b))) :
    ∫ x in a..b, ‖f x‖ = 0 := by
  rw [intervalIntegral.integral_of_le hab]
  exact MeasureTheory.integral_undef h
end

end RouteABC
