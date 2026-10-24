/-
  DirichletZeroCount2.lean — the **argument-principle assembly**: the Riemann–von Mangoldt count
  bound `N(T+1) − N(T) = O(log qT)` for Dirichlet L, obtained by composing

    `dirichletZeroCountIn_le_orderSum` (§86, no `hno`)      ncard ≤ Σ order
    `dirichletCompleted_zeroCount_le_of_criticalStrip` (§83) Σ order ≤ C log(qT)

  via the abstraction `dirichletZeroCount_le_of_sum_bound` (§60).  Kept in a separate module for the
  elaboration-cost reasons recorded in journals §§88–90.
-/
import DirichletZeroCounting

open MeasureTheory intervalIntegral
open scoped Interval
open Rh45RouteBAnalytic
open DirichletCharacter

namespace RouteABC

noncomputable section

open Set in
/-- **The `Z`-existence construction.**  From the boundary-free hypothesis `hbd`, produce a finite set
`Z` of zeros in the open rectangle `{0 < Re < 1, T < Im < T+2}` which contains **every** zero of the
closed rectangle.  Its statement mentions no `logDeriv` — the `hint₀/hint₁` conjuncts are supplied
separately (journal §90's abstraction technique). -/
theorem exists_Z_of_hbd {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {T : ℝ}
    (hbd : ∀ u : ℂ, dirichletCompleted χ u = 0 → 0 ≤ u.re → u.re ≤ 1 → T ≤ u.im → u.im ≤ T + 2 →
      (0 < u.re ∧ u.re < 1 ∧ T < u.im ∧ u.im < T + 2)) :
    ∃ Z : Finset ℂ,
      (∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ T < z.im ∧ z.im < T + 2) ∧
      (∀ z ∈ Z, dirichletCompleted χ z = 0) ∧
      (∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → T < z.im → z.im < T + 2 → z ∈ Z) ∧
      (∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[T, T + 2]]), u ∉ Z → dirichletCompleted χ u ≠ 0) := by
  have hIcc : T ≤ T + 2 := by linarith
  have hSfin : (dirichletLZeros χ ∩
      {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T < s.im ∧ s.im < T + 2}).Finite :=
    (IsCompact.inter_dirichletLZeros_finite χ hχ
      (isCompact_uIcc.reProdIm isCompact_uIcc)).subset fun s hs =>
      ⟨Complex.mem_reProdIm.mpr
        ⟨Set.mem_uIcc.mpr (Or.inl ⟨le_of_lt hs.2.1, le_of_lt hs.2.2.1⟩),
         Set.mem_uIcc.mpr (Or.inl ⟨le_of_lt hs.2.2.2.1, le_of_lt hs.2.2.2.2⟩)⟩, hs.1⟩
  refine ⟨hSfin.toFinset, fun z hz => (hSfin.mem_toFinset.mp hz).2,
    fun z hz => mem_dirichletLZeros.mp (hSfin.mem_toFinset.mp hz).1,
    fun z hz h1 h2 h3 h4 => hSfin.mem_toFinset.mpr ⟨hz, h1, h2, h3, h4⟩, ?_⟩
  intro u hu huz hu0
  have hu' := hu
  rw [Complex.mem_reProdIm, Set.uIcc_of_le (a := (0:ℝ)) (b := 1) (by norm_num),
    Set.uIcc_of_le (a := T) (b := T + 2) hIcc] at hu'
  obtain ⟨⟨h1, h2⟩, ⟨h3, h4⟩⟩ := hu'
  exact huz (hSfin.mem_toFinset.mpr ⟨mem_dirichletLZeros.mpr hu0, hbd u hu0 h1 h2 h3 h4⟩)

/-- **Named predicate for the `hint` conjuncts.**  `Λ_χ'/Λ_χ` is interval-integrable on the
horizontal segment `Im = t`, over `Re ∈ [0,1]`.  Naming it keeps the expensive `logDeriv`/
`dirichletCompleted` normalform out of every *subsequent* statement (journal §90). -/
def LogDerivIntegrable {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t : ℝ) : Prop :=
  IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t * Complex.I)) volume 0 1

/-- `Λ_χ'/Λ_χ` has no zero of `dirichletCompleted χ` on the segment `Im = t`, `Re ∈ [0,1]`. -/
def ZeroFreeSegment {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t : ℝ) : Prop :=
  ∀ x ∈ Set.uIcc (0 : ℝ) 1, dirichletCompleted χ (x + t * Complex.I) ≠ 0

/-- **Half 1: rectangle membership only.**  `hbd` makes the two horizontal segments zero-free.
The statement names neither `logDeriv` nor `IntervalIntegrable`. -/
theorem zeroFreeSegment_of_hbd {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {T : ℝ}
    (hbd : ∀ u : ℂ, dirichletCompleted χ u = 0 → 0 ≤ u.re → u.re ≤ 1 → T ≤ u.im → u.im ≤ T + 2 →
      (0 < u.re ∧ u.re < 1 ∧ T < u.im ∧ u.im < T + 2)) :
    ZeroFreeSegment χ T ∧ ZeroFreeSegment χ (T + 2) := by
  have keyT : ∀ x ∈ Set.Icc (0 : ℝ) 1, dirichletCompleted χ (x + T * Complex.I) ≠ 0 := by
    intro x hx hx0
    have him : (x + T * Complex.I).im = T := by simp
    have hre : (x + T * Complex.I).re = x := by simp
    have h := (hbd _ hx0 (by rw [hre]; exact hx.1) (by rw [hre]; exact hx.2)
      (by rw [him]) (by rw [him]; linarith)).2.2.1
    rw [him] at h
    exact lt_irrefl T h
  have keyT2 : ∀ x ∈ Set.Icc (0 : ℝ) 1, dirichletCompleted χ (x + (T + 2) * Complex.I) ≠ 0 := by
    intro x hx hx0
    have him : (x + (T + 2) * Complex.I).im = T + 2 := by simp
    have hre : (x + (T + 2) * Complex.I).re = x := by simp
    have h := (hbd _ hx0 (by rw [hre]; exact hx.1) (by rw [hre]; exact hx.2)
      (by rw [him]; linarith) (by rw [him])).2.2.2
    rw [him] at h
    exact lt_irrefl (T + 2) h
  refine ⟨?_, ?_⟩
  · intro x hx hx0
    rw [Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1)] at hx
    exact keyT x hx hx0
  · intro x hx hx0
    rw [Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1)] at hx
    refine keyT2 x hx ?_
    simpa only [Complex.ofReal_add, Complex.ofReal_ofNat] using hx0

/-- **Half 2: continuity only.**  A zero-free segment makes the log-derivative interval-integrable.
The statement names neither `dirichletCompleted`'s rectangle nor the arithmetic of `T`. -/
theorem logDerivIntegrable_of_zeroFreeSegment {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {t : ℝ} (h : ZeroFreeSegment χ t) : LogDerivIntegrable χ t := by
  unfold LogDerivIntegrable ZeroFreeSegment at *
  exact (continuousOn_logDeriv_dirichletCompleted χ hχ t h).intervalIntegrable

/-- **The remaining obligation, closed.**  `hbd` implies both `hint` conjuncts, by composing the two
halves above. -/
theorem logDerivIntegrable_of_hbd {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T : ℝ}
    (hbd : ∀ u : ℂ, dirichletCompleted χ u = 0 → 0 ≤ u.re → u.re ≤ 1 → T ≤ u.im → u.im ≤ T + 2 →
      (0 < u.re ∧ u.re < 1 ∧ T < u.im ∧ u.im < T + 2)) :
    LogDerivIntegrable χ T ∧ LogDerivIntegrable χ (T + 2) :=
  ⟨logDerivIntegrable_of_zeroFreeSegment χ hχ (zeroFreeSegment_of_hbd χ hbd).1,
   logDerivIntegrable_of_zeroFreeSegment χ hχ (zeroFreeSegment_of_hbd χ hbd).2⟩

/-- **The assembled Riemann–von Mangoldt count bound.**  With `CriticalStripLogDerivBound`, the zero
count in a unit rectangle is `O(log(qT))`.  `hbd` is the single boundary hypothesis; `htop` records
that the order of `dirichletCompleted χ` is finite at its zeros (true since it is entire and not
identically zero). -/
theorem dirichletZeroCount_le_of_criticalStrip {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) {C0 : ℝ} (hC0 : 0 < C0)
    (hcs : ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
      + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|))
    (htop : ∀ z : ℂ, dirichletCompleted χ z = 0 →
      analyticOrderAt (dirichletCompleted χ) z ≠ ⊤)
    {T : ℝ} (hT : 2 ≤ T)
    (hZ : ∃ Z : Finset ℂ,
      (∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ T < z.im ∧ z.im < T + 2) ∧
      (∀ z ∈ Z, dirichletCompleted χ z = 0) ∧
      (∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → T < z.im → z.im < T + 2 → z ∈ Z) ∧
      (∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[T, T + 2]]), u ∉ Z → dirichletCompleted χ u ≠ 0) ∧
      IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + T * Complex.I))
        volume 0 1 ∧
      IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
        (x + (T + 2) * Complex.I)) volume 0 1) :
    (dirichletZeroCount χ T : ℝ)
      ≤ (C0 * 3 / Real.pi * 2 + 1) * (1 + Real.log ((N : ℝ) * (T + 2))) := by
  obtain ⟨Z, hmem, hzeroZ, hZall, hno, hint0, hint1⟩ := hZ
  have hZall' : ∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → T < z.im → z.im ≤ T + 1 → z ∈ Z :=
    fun z hz h1 h2 h3 h4 => hZall z hz h1 h2 h3 (by linarith)
  have hN1 : (1:ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
  have hlog0 : 0 ≤ Real.log ((N : ℝ) * (T + 2)) := Real.log_nonneg (by nlinarith)
  have hint1' : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + (↑(T + 2) : ℂ) * Complex.I)) volume 0 1 := by
    simpa only [Complex.ofReal_add, Complex.ofReal_ofNat] using hint1
  have hbound := dirichletCompleted_zeroCount_le_of_criticalStrip χ hχ hprim hχinv hsign hreal
    T (T + 2) Z (fun z => analyticOrderNatAt (dirichletCompleted χ) z) (by linarith) hmem
    (fun z _ => rfl) hno hint0 hint1' hC0 hcs (T := T + 2)
    (by rw [abs_of_nonneg (by linarith)]; linarith)
    (by rw [abs_of_nonneg (by linarith)]) (by linarith)
  have hC1 := hbound
  have habs : |T + 2 - T| = 2 := by norm_num
  have h2e : (2:ℝ) < Real.exp 1 := by nlinarith [Real.exp_one_gt_d9]
  have hlog : Real.log ((N : ℝ) * (T + 2 + 2)) ≤ Real.log ((N : ℝ) * (T + 2)) + 1 := by
    rw [show ((N : ℝ) * (T + 2 + 2)) = ((N : ℝ) * (T + 2)) * ((T + 4) / (T + 2)) by
      field_simp; ring]
    rw [Real.log_mul (by positivity) (by positivity)]
    have h2 : (T + 4) / (T + 2) ≤ 2 := by
      rw [div_le_iff₀ (by linarith : (0:ℝ) < T + 2)]; linarith
    have h3 : Real.log ((T + 4) / (T + 2)) ≤ 1 := by
      rw [Real.log_le_iff_le_exp (by positivity)]
      linarith
    linarith
  calc (dirichletZeroCount χ T : ℝ)
      ≤ ∑ z ∈ Z, (analyticOrderNatAt (dirichletCompleted χ) z : ℝ) :=
        dirichletZeroCount_le_of_sum_bound χ hχ Z hzeroZ htop hZall' le_rfl
    _ ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2 + 2))) * (1 + |T + 2 - T|) / Real.pi := hC1
    _ = (C0 * 3 / Real.pi) * (1 + Real.log ((N : ℝ) * (T + 2 + 2))) := by rw [habs]; ring
    _ ≤ (C0 * 3 / Real.pi) * (1 + (Real.log ((N : ℝ) * (T + 2)) + 1)) :=
        mul_le_mul_of_nonneg_left (by linarith) (by positivity)
    _ ≤ (C0 * 3 / Real.pi * 2 + 1) * (1 + Real.log ((N : ℝ) * (T + 2))) := by
        have h3 : (1:ℝ) ≤ 1 + Real.log ((N : ℝ) * (T + 2)) := by linarith
        have hp : (0:ℝ) < C0 * 3 / Real.pi := by positivity
        have hmul : 0 ≤ (C0 * 3 / Real.pi) * Real.log ((N : ℝ) * (T + 2)) :=
          mul_nonneg hp.le hlog0
        nlinarith [h3, hlog0, hp, hmul]

/-- **The Riemann–von Mangoldt count bound, unconditional in `hbd`.**  Every hypothesis of §90's
counting theorem is now derived from the single boundary-free hypothesis `hbd`, via
`exists_Z_of_hbd` (§92) + `logDerivIntegrable_of_hbd` (§93) + `analyticOrderAt_ne_top_…` (§91). -/
theorem dirichletZeroCount_le_of_hbd {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) {C0 : ℝ} (hC0 : 0 < C0)
    (hcs : ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
      + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|))
    {T : ℝ} (hT : 2 ≤ T)
    (hbd : ∀ u : ℂ, dirichletCompleted χ u = 0 → 0 ≤ u.re → u.re ≤ 1 → T ≤ u.im → u.im ≤ T + 2 →
      (0 < u.re ∧ u.re < 1 ∧ T < u.im ∧ u.im < T + 2)) :
    (dirichletZeroCount χ T : ℝ)
      ≤ (C0 * 3 / Real.pi * 2 + 1) * (1 + Real.log ((N : ℝ) * (T + 2))) := by
  obtain ⟨Z, hmem, hzeroZ, hZall, hno⟩ := exists_Z_of_hbd χ hχ hbd
  obtain ⟨hint0, hint1⟩ := logDerivIntegrable_of_hbd χ hχ hbd
  refine dirichletZeroCount_le_of_criticalStrip χ hχ hprim hχinv hsign hreal hC0 hcs
    (fun z _ => analyticOrderAt_ne_top_dirichletCompleted χ hχ z) hT ⟨Z, hmem, hzeroZ, hZall, hno, ?_, ?_⟩
  · unfold LogDerivIntegrable at hint0; exact hint0
  · unfold LogDerivIntegrable at hint1
    simpa only [Complex.ofReal_add, Complex.ofReal_ofNat] using hint1

/-- **`RiemannVonMangoldtDensity` from the critical-strip interface and boundary-freeness.**  The
constant is uniform in `T` because §94 builds it from the `C0` carried by `hcs`. -/
theorem riemannVonMangoldtDensity_of_criticalStrip {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (hcs : CriticalStripLogDerivBound χ)
    (hbd : ∀ T : ℝ, 2 ≤ T → ∀ u : ℂ, dirichletCompleted χ u = 0 → 0 ≤ u.re → u.re ≤ 1 →
      T ≤ u.im → u.im ≤ T + 2 → (0 < u.re ∧ u.re < 1 ∧ T < u.im ∧ u.im < T + 2)) :
    RiemannVonMangoldtDensity χ := by
  obtain ⟨C0, hC0, hcs'⟩ := hcs
  refine ⟨2 * (C0 * 3 / Real.pi * 2 + 1), by positivity, fun T hT => ?_⟩
  have h := dirichletZeroCount_le_of_hbd χ hχ hprim hχinv hsign hreal hC0 hcs' hT (hbd T hT)
  have hN1 : (1:ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
  have hlog1 : 1 ≤ Real.log ((N : ℝ) * (T + 2)) := by
    rw [Real.le_log_iff_exp_le (by positivity)]
    have he : Real.exp 1 ≤ 4 := le_of_lt (lt_trans Real.exp_one_lt_d9 (by norm_num))
    nlinarith [hN1, hT, he]
  calc (dirichletZeroCount χ T : ℝ)
      ≤ (C0 * 3 / Real.pi * 2 + 1) * (1 + Real.log ((N : ℝ) * (T + 2))) := h
    _ ≤ 2 * (C0 * 3 / Real.pi * 2 + 1) * Real.log ((N : ℝ) * (T + 2)) := by
        nlinarith [hlog1, Real.pi_pos, hC0]

/-- **Count bound on an arbitrary interval.**  The general-interval form of §90: for any `t₀ < t₁`
and any `Z` satisfying §83's hypotheses (which include the four-sided `hno`), the count over
`(t₀, t₁]` is `O(log(qT)·(1 + |t₁ − t₀|))`.

This is the form the shift argument needs: to avoid an exceptional `T` one moves the rectangle, and
the count over the original interval is compared with the count over the moved one. -/
theorem dirichletZeroCountIn_le_of_criticalStrip {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) {C0 : ℝ} (hC0 : 0 < C0)
    (hcs : ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
      + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|))
    (htop : ∀ z : ℂ, dirichletCompleted χ z = 0 →
      analyticOrderAt (dirichletCompleted χ) z ≠ ⊤)
    {t0 t1 T : ℝ} (ht : t0 < t1) (hT0 : |t0| ≤ T) (hT1 : |t1| ≤ T) (hT2 : 0 ≤ T)
    (hZ : ∃ Z : Finset ℂ,
      (∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1) ∧
      (∀ z ∈ Z, dirichletCompleted χ z = 0) ∧
      (∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → t0 < z.im → z.im < t1 → z ∈ Z) ∧
      (∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0) ∧
      IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
        volume 0 1 ∧
      IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))
        volume 0 1) :
    (dirichletZeroCountIn χ t0 t1 : ℝ)
      ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) / Real.pi := by
  obtain ⟨Z, hmem, hzeroZ, hZall, hno, hint0, hint1⟩ := hZ
  have hint1' : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + (↑t1 : ℂ) * Complex.I)) volume 0 1 := hint1
  have hbound := dirichletCompleted_zeroCount_le_of_criticalStrip χ hχ hprim hχinv hsign hreal
    t0 t1 Z (fun z => analyticOrderNatAt (dirichletCompleted χ) z) ht hmem (fun z _ => rfl) hno
    hint0 hint1' hC0 hcs hT0 hT1 hT2
  have hZall' : ∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → t0 < z.im → z.im ≤ t1 → z ∈ Z := by
    intro z hz h1 h2 h3 h4
    rcases lt_or_eq_of_le h4 with h5 | h5
    · exact hZall z hz h1 h2 h3 h5
    · exfalso
      have hcl : z ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]) := by
        rw [Complex.mem_reProdIm, Set.uIcc_of_le (a := (0:ℝ)) (b := 1) (by norm_num),
          Set.uIcc_of_le (a := t0) (b := t1) (le_of_lt ht), Set.mem_Icc, Set.mem_Icc]
        exact ⟨⟨le_of_lt h1, le_of_lt h2⟩, ⟨le_of_lt h3, le_of_eq h5⟩⟩
      refine (hno z hcl) (fun hzZ => absurd (hmem z hzZ).2.2.2 ?_) ?_
      · rw [h5]; exact lt_irrefl t1
      · exact mem_dirichletLZeros.mp hz
  exact (dirichletZeroCountIn_le_orderSum χ hχ Z hzeroZ htop hZall').trans hbound

/-- **The shift lemma.**  Given a finite set `S` of forbidden values, there is `δ ∈ (0,1]` with
`t₀ - δ ∉ S` and `t₁ - δ ∉ S`.  This is what lets the rectangle sidestep zeros lying on a horizontal
side: the relevant imaginary parts form a finite set, and an interval cannot be covered by finitely
many points. -/
theorem exists_delta_avoiding (S : Finset ℝ) (t0 t1 : ℝ) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 ∧ t0 - δ ∉ S ∧ t1 - δ ∉ S := by
  by_contra h
  push_neg at h
  have hfin : (↑(S.image fun s => t0 - s) ∪ ↑(S.image fun s => t1 - s) : Set ℝ).Finite :=
    (S.image _).finite_toSet.union (S.image _).finite_toSet
  have hsub : Set.Ioc (0 : ℝ) 1 ⊆ (↑(S.image fun s => t0 - s) ∪ ↑(S.image fun s => t1 - s) : Set ℝ) := by
    intro δ hδ
    by_cases h1 : t0 - δ ∈ S
    · exact Or.inl (Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨t0 - δ, h1, by ring⟩))
    · exact Or.inr (Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨t1 - δ, h δ hδ.1 hδ.2 h1, by ring⟩))
  have := hfin.subset hsub
  exact (Set.Ioc_infinite (by norm_num : (0:ℝ) < 1)) this

/-- **The count comparison for the shift.**  Any interval `(t₀, t₁]` with `t₀ < T` and `T+1 ≤ t₁`
contains `(T, T+1]`, so its count dominates `dirichletZeroCount χ T`. -/
theorem dirichletZeroCount_le_countIn {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {T t0 t1 : ℝ} (h0 : t0 < T) (h1 : T + 1 ≤ t1) :
    (dirichletZeroCount χ T : ℝ) ≤ (dirichletZeroCountIn χ t0 t1 : ℝ) := by
  have hsub : dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ T < s.im ∧ s.im ≤ T + 1}
      ⊆ dirichletLZeros χ ∩ {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ t0 < s.im ∧ s.im ≤ t1} := by
    intro s hs
    exact ⟨hs.1, hs.2.1, hs.2.2.1, by linarith [hs.2.2.2.1], by linarith [hs.2.2.2.2]⟩
  have hfin : (dirichletLZeros χ ∩
      {s : ℂ | 0 < s.re ∧ s.re < 1 ∧ t0 < s.im ∧ s.im ≤ t1}).Finite :=
    (IsCompact.inter_dirichletLZeros_finite χ hχ
      ((isCompact_uIcc (a := (0:ℝ)) (b := 1)).reProdIm
        (isCompact_uIcc (a := t0) (b := t1)))).subset fun s hs =>
      ⟨Complex.mem_reProdIm.mpr
        ⟨Set.mem_uIcc.mpr (Or.inl ⟨le_of_lt hs.2.1, le_of_lt hs.2.2.1⟩),
         Set.mem_uIcc.mpr (Or.inl ⟨hs.2.2.2.1.le, hs.2.2.2.2⟩)⟩, hs.1⟩
  rw [dirichletZeroCount, dirichletZeroCountIn]
  exact Nat.cast_le.mpr (Set.ncard_le_ncard hsub hfin)

/-- `dirichletCompleted χ` has no zero on the **vertical** sides of `[0,1] × [t₀,t₁]`. -/
def VerticalFree {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ) : Prop :=
  ∀ u : ℂ, dirichletCompleted χ u = 0 → (u.re = 0 ∨ u.re = 1) → t0 ≤ u.im → u.im ≤ t1 → False

/-- **Step (i) of the shift packaging.**  Given vertical-freeness on `[0,1] × [T-1, T+2]`, there is
a shifted rectangle `[0,1] × [t₀, t₀+2]` which still contains `(T, T+1]` (`t₀ < T`, `T+1 ≤ t₀+2`)
and whose boundary is zero-free.  The shift is chosen by §100 from the finitely many imaginary parts
of zeros in the compact `[0,1] × [T-1, T+2]`. -/
theorem exists_hbd_shift {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {T : ℝ}
    (hvert : VerticalFree χ (T - 1) (T + 2)) :
    ∃ t0 : ℝ, t0 < T ∧ T + 1 ≤ t0 + 2 ∧
      (∀ u : ℂ, dirichletCompleted χ u = 0 → 0 ≤ u.re → u.re ≤ 1 →
        t0 ≤ u.im → u.im ≤ t0 + 2 →
        (0 < u.re ∧ u.re < 1 ∧ t0 < u.im ∧ u.im < t0 + 2)) := by
  have hT1 : T - 1 ≤ T + 2 := by linarith
  have hKfin : ((Set.uIcc (0:ℝ) 1 ×ℂ Set.uIcc (T - 1) (T + 2)) ∩ dirichletLZeros χ).Finite :=
    IsCompact.inter_dirichletLZeros_finite χ hχ (isCompact_uIcc.reProdIm isCompact_uIcc)
  obtain ⟨δ, hδ0, hδ1, hδa, hδb⟩ :=
    exists_delta_avoiding (hKfin.toFinset.image Complex.im) T (T + 2)
  refine ⟨T - δ, by linarith, by linarith, ?_⟩
  intro u hu0 hu1 hu2 hu3 hu4
  have huz : u ∈ dirichletLZeros χ := mem_dirichletLZeros.mpr hu0
  have himS : u.im ∈ hKfin.toFinset.image Complex.im := by
    refine Finset.mem_image.mpr ⟨u, hKfin.mem_toFinset.mpr ⟨?_, huz⟩, rfl⟩
    rw [Complex.mem_reProdIm, Set.uIcc_of_le (a := (0:ℝ)) (b := 1) (by norm_num),
      Set.uIcc_of_le hT1]
    exact ⟨⟨hu1, hu2⟩, ⟨by linarith, by linarith⟩⟩
  have hvt := hvert u hu0
  refine ⟨?_, ?_, ?_, ?_⟩
  · rcases lt_or_eq_of_le hu1 with h | h
    · exact h
    · exact (hvt (Or.inl h.symm) (by linarith) (by linarith)).elim
  · rcases lt_or_eq_of_le hu2 with h | h
    · exact h
    · exact (hvt (Or.inr h) (by linarith) (by linarith)).elim
  · rcases lt_or_eq_of_le hu3 with h | h
    · exact h
    · exact absurd (by rw [← h] at himS; exact himS) hδa
  · rcases lt_or_eq_of_le hu4 with h | h
    · exact h
    · have h2 : u.im = T + 2 - δ := by linarith
      exact absurd (by rw [h2] at himS; exact himS) hδb

/-- **Step (ii) of the shift packaging.**  Combine §104 (the shifted rectangle) with §92 (`Z`) and
§93 (the `hint` conjuncts) to produce exactly the `∃ Z, ...` that
`dirichletZeroCountIn_le_of_criticalStrip` (§99) asks for — at the shifted endpoints `t₀`, `t₀+2`. -/
theorem exists_Z_shift {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {T : ℝ}
    (hvert : VerticalFree χ (T - 1) (T + 2)) :
    ∃ t0 : ℝ, t0 < T ∧ T + 1 ≤ t0 + 2 ∧ ∃ Z : Finset ℂ,
      (∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t0 + 2) ∧
      (∀ z ∈ Z, dirichletCompleted χ z = 0) ∧
      (∀ z ∈ dirichletLZeros χ, 0 < z.re → z.re < 1 → t0 < z.im → z.im < t0 + 2 → z ∈ Z) ∧
      (∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t0 + 2]]), u ∉ Z → dirichletCompleted χ u ≠ 0) ∧
      IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
        volume 0 1 ∧
      IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
        (x + (t0 + 2) * Complex.I)) volume 0 1 := by
  obtain ⟨t0, ht0T, hTt0, hbd⟩ := exists_hbd_shift χ hχ hvert
  obtain ⟨Z, hmem, hzeroZ, hZall, hno⟩ := exists_Z_of_hbd χ hχ (T := t0) hbd
  obtain ⟨hint0, hint1⟩ := logDerivIntegrable_of_hbd χ hχ (T := t0) hbd
  unfold LogDerivIntegrable at hint0 hint1
  refine ⟨t0, ht0T, hTt0, Z, hmem, hzeroZ, hZall, hno, hint0, ?_⟩
  simpa only [Complex.ofReal_add, Complex.ofReal_ofNat] using hint1

/-- **Step (iii) of the shift packaging.**  The numeric comparison absorbing the `1 + log` into the
constant: `C0·(1 + log(q(T+4)))·3/π ≤ 2·(C0·3/π + 1)·log(q(T+2))` for `T ≥ 2`. -/
theorem log_absorb {N : ℕ} [NeZero N] {C0 T : ℝ} (hC0 : 0 < C0) (hT : 2 ≤ T) :
    C0 * (1 + Real.log ((N : ℝ) * (T + 2 + 2))) * 3 / Real.pi
      ≤ (3 * (C0 * 3 / Real.pi) + 1) * Real.log ((N : ℝ) * (T + 2)) := by
  have hN1 : (1:ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne N)
  have hN2 : (1:ℝ) ≤ (N : ℝ) * (T + 2) := by nlinarith [hN1, hT]
  have hlog0 : 0 ≤ Real.log ((N : ℝ) * (T + 2)) := Real.log_nonneg hN2
  have hL : (1:ℝ) ≤ 1 + Real.log ((N : ℝ) * (T + 2)) := by linarith
  have hlog : Real.log ((N : ℝ) * (T + 2 + 2)) ≤ Real.log ((N : ℝ) * (T + 2)) + 1 := by
    have h4 : ((N : ℝ) * (T + 2 + 2)) = ((N : ℝ) * (T + 2)) * ((T + 4) / (T + 2)) := by
      field_simp; ring
    rw [h4, Real.log_mul (by positivity) (by positivity)]
    have h2e : (2:ℝ) < Real.exp 1 := by nlinarith [Real.exp_one_gt_d9]
    have h2 : (T + 4) / (T + 2) ≤ Real.exp 1 := by
      have h2' : (T + 4) / (T + 2) ≤ 2 := by
        rw [div_le_iff₀ (by linarith : (0:ℝ) < T + 2)]; linarith
      linarith
    have h3 := (Real.log_le_iff_le_exp (by positivity : (0:ℝ) < (T + 4) / (T + 2))).mpr h2
    linarith
  have hlog1 : (1:ℝ) ≤ Real.log ((N : ℝ) * (T + 2)) := by
    rw [Real.le_log_iff_exp_le (by positivity)]
    nlinarith [hN1, hT, Real.exp_one_lt_d9, (by norm_num : (2.7182818286 : ℝ) < 4)]
  have hA : (1 + Real.log ((N : ℝ) * (T + 2 + 2)))
      ≤ 3 * Real.log ((N : ℝ) * (T + 2)) := by linarith
  have hB : (0:ℝ) ≤ C0 * 3 / Real.pi := by positivity
  have hC' : C0 * (1 + Real.log ((N : ℝ) * (T + 2 + 2))) * 3 / Real.pi
      = (C0 * 3 / Real.pi) * (1 + Real.log ((N : ℝ) * (T + 2 + 2))) := by ring
  rw [hC']
  refine (mul_le_mul_of_nonneg_left hA hB).trans ?_
  nlinarith [hlog0, hC0, Real.pi_pos]

/-- **`RiemannVonMangoldtDensity` from vertical-only boundary freeness.**  The horizontal sides need
no hypothesis: §104 moves the rectangle down by a `δ` avoiding the finitely many imaginary parts of
zeros, §105 packages the resulting `Z`, §99 bounds the shifted count, §102 compares it with the
original and §106 does the numeric absorption. -/
theorem riemannVonMangoldtDensity_of_verticalFree {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) {C0 : ℝ} (hC0 : 0 < C0)
    (hcs : ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
      + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|))
    (hvert : ∀ T : ℝ, 2 ≤ T → VerticalFree χ (T - 1) (T + 2)) :
    RiemannVonMangoldtDensity χ := by
  refine ⟨3 * (C0 * 3 / Real.pi) + 1, by positivity, fun T hT => ?_⟩
  obtain ⟨t0, ht0T, hTt0, Z, hmem, hzeroZ, hZall, hno, hint0, hint1⟩ :=
    exists_Z_shift χ hχ (hvert T hT)
  have htlt : t0 < t0 + 2 := by linarith
  have ht0pos : 0 ≤ t0 := by linarith
  have ht0pos2 : (0:ℝ) ≤ t0 + 2 := by linarith
  have hint1' : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + (↑(t0 + 2) : ℂ) * Complex.I)) volume 0 1 := by
    simpa only [Complex.ofReal_add, Complex.ofReal_ofNat] using hint1
  have h99 := dirichletZeroCountIn_le_of_criticalStrip χ hχ hprim hχinv hsign hreal hC0 hcs
    (fun z _ => analyticOrderAt_ne_top_dirichletCompleted χ hχ z) htlt
    (T := T + 2) (by rw [abs_of_nonneg ht0pos]; linarith)
    (by rw [abs_of_nonneg ht0pos2]; linarith) (by linarith)
    ⟨Z, hmem, hzeroZ, hZall, hno, hint0, hint1'⟩
  rw [show |t0 + 2 - t0| = 2 by norm_num] at h99
  have h106 : C0 * (1 + Real.log ((N : ℝ) * (T + 2 + 2))) * (1 + 2) / Real.pi
      ≤ (3 * (C0 * 3 / Real.pi) + 1) * Real.log ((N : ℝ) * (T + 2)) :=
    by simpa only [show (1:ℝ) + 2 = 3 by norm_num] using log_absorb (N := N) hC0 hT
  have h101 := dirichletZeroCount_le_countIn χ hχ (T := T) (t0 := t0) (t1 := t0 + 2) ht0T hTt0
  exact le_trans h101 (le_trans h99 h106)

/-- **Vertical freeness is a theorem, not a hypothesis.**  Non-vanishing of `dirichletCompleted χ` on
the lines `Re s = 0, 1`: on `Re = 1` it is Mathlib's `LFunction_ne_zero_of_re_eq_one` (§78), and on
`Re = 0` it follows from the functional equation `Λ(1-s) = ε·Λ(s)`. -/
theorem verticalFree_of_ne_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (t0 t1 : ℝ) :
    VerticalFree χ t0 t1 := by
  intro u hu0 hcase _ _
  rcases hcase with h | h
  · exact dirichletCompleted_ne_zero_of_re_eq_zero χ hχ hprim hχinv h hu0
  · exact dirichletCompleted_ne_zero_of_re_eq_one χ hχ h hu0

/-- **`RiemannVonMangoldtDensity` from the critical-strip interface alone.**
`CriticalStripLogDerivBound χ` implies the Riemann–von Mangoldt zero-count bound.  Vertical
freeness is a theorem (§105's `verticalFree_of_ne_zero` of §78), so no boundary hypothesis remains. -/
theorem riemannVonMangoldtDensity_of_stripBound {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) {C0 : ℝ} (hC0 : 0 < C0)
    (hcs : ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * Complex.I)‖)
      + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      + (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * Complex.I)‖)
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|)) :
    RiemannVonMangoldtDensity χ :=
  riemannVonMangoldtDensity_of_verticalFree χ hχ hprim hχinv hsign hreal hC0 hcs
    fun T _ => verticalFree_of_ne_one χ hχ hprim hχinv (T - 1) (T + 2)

/-- **`RiemannVonMangoldtDensity` from the bundled interface.** -/
theorem riemannVonMangoldtDensity_of_interface {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hreal : CompletedLFunctionConj χ) (hcs : CriticalStripLogDerivBound χ) :
    RiemannVonMangoldtDensity χ := by
  obtain ⟨C0, hC0, hcs'⟩ := hcs
  exact riemannVonMangoldtDensity_of_stripBound χ hχ hprim hχinv
    (rootNumberSign_of_inv_eq_self χ hprim hχ hχinv) hreal hC0 hcs'

end

end RouteABC
