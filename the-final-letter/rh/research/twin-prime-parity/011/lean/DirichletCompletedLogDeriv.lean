/-
  DirichletCompletedLogDeriv.lean — the **explicit-formula integrand, assembled**.

  With the prime half (`DirichletLogDeriv.lean`: `−logDeriv (LSeries χ) = LSeries (Λ·χ)`) and the
  archimedean half (`DirichletGammaLogDeriv.lean`: `logDeriv Gammaℝ = −½log π + ½ψ(s/2)`), this
  file assembles the logarithmic derivative of the completed L-function on `1 < re s`:

    `logDeriv (dirichletCompleted χ) s
        = (1/2) log N + logDeriv (gammaFactor χ) s − LSeries (dirichletWeight χ) s`

  — the integrand of the Dirichlet explicit formula: archimedean-plus-conductor part minus the
  prime series.  This file proves the intermediate steps

  * `gammaFactor_ne_zero_of_one_lt_re`,
  * `completedLFunction_eq_gammaFactor_mul_LFunction` — `completedLFunction = gammaFactor · LFunction`,
  * `completedLFunction_ne_zero_of_one_lt_re`,
  * `logDeriv_LFunction_eq` — `logDeriv (LFunction χ) = −LSeries (dirichletWeight χ)`.

  The final two lines (the product rule for `completedLFunction` and the `N^{s/2}` factor) are
  recorded in the journal as the next step.
-/
import DirichletLogDeriv
import DirichletGammaLogDeriv
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Mathlib.Topology.Order.Basic

namespace RouteABC

noncomputable section

open scoped BigOperators ArithmeticFunction.vonMangoldt Topology
open DirichletCharacter
open Filter

/-- The archimedean factor does not vanish on `1 < re s`. -/
theorem gammaFactor_ne_zero_of_re_pos {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 0 < s.re) : gammaFactor χ s ≠ 0 := by
  rcases χ.even_or_odd with h | h
  · rw [h.gammaFactor_def]
    exact Complex.Gammaℝ_ne_zero_of_re_pos hs
  · rw [h.gammaFactor_def]
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    rw [Complex.add_re, Complex.one_re]
    linarith

/-- **Non-vanishing on `Re s = 1`.**  Mathlib's `LFunction_ne_zero_of_re_eq_one` supplies the
non-vanishing of `L(·, χ)` on the line, and both the archimedean factor and `N^{s/2}` are non-zero
there. -/
theorem dirichletCompleted_ne_zero_of_re_eq_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {u : ℂ} (hu : u.re = 1) : dirichletCompleted χ u ≠ 0 := by
  have hN : (N : ℂ) ≠ 0 := by exact_mod_cast NeZero.ne N
  have hu0 : u ≠ 0 := by intro h; rw [h] at hu; simp at hu
  have hL := χ.LFunction_ne_zero_of_re_eq_one hu (Or.inl hχ)
  have hgf : gammaFactor χ u ≠ 0 := gammaFactor_ne_zero_of_re_pos χ (by rw [hu]; norm_num)
  have hdiv := LFunction_eq_completed_div_gammaFactor χ u (Or.inl hu0)
  have hcomp : completedLFunction χ u = LFunction χ u * gammaFactor χ u := by
    rw [hdiv]
    exact (div_mul_cancel₀ _ hgf).symm
  have hcp : (N : ℂ) ^ (u / 2) ≠ 0 := by
    rw [Complex.cpow_ne_zero_iff]
    exact Or.inl hN
  rw [dirichletCompleted, hcomp]
  exact mul_ne_zero hcp (mul_ne_zero hL hgf)

/-- **Non-vanishing on `Re s = 0`.**  The functional equation `Λ(1-s) = ε·Λ(s)` maps the line
`Re s = 0` to `Re s = 1`, where §78 proves non-vanishing. -/
theorem dirichletCompleted_ne_zero_of_re_eq_zero {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ⁻¹ = χ) {u : ℂ} (hu : u.re = 0) :
    dirichletCompleted χ u ≠ 0 := by
  intro h0
  have hsym := dirichletCompleted_selfDual χ hprim hχinv u
  rw [h0, mul_zero] at hsym
  have h1 : (1 - u).re = 1 := by simp [hu]
  exact dirichletCompleted_ne_zero_of_re_eq_one χ hχ h1 hsym

theorem gammaFactor_ne_zero_of_one_lt_re {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) : gammaFactor χ s ≠ 0 := by
  rcases χ.even_or_odd with h | h
  · rw [h.gammaFactor_def]
    exact Complex.Gammaℝ_ne_zero_of_re_pos (by linarith)
  · rw [h.gammaFactor_def]
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    rw [Complex.add_re, Complex.one_re]
    linarith

/-- **The completed L-function is `gammaFactor · LFunction`** on `1 < re s`. -/
theorem completedLFunction_eq_gammaFactor_mul_LFunction {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    {s : ℂ} (hs : 1 < s.re) :
    completedLFunction χ s = gammaFactor χ s * LFunction χ s := by
  have hs0 : s ≠ 0 := by intro h; rw [h] at hs; norm_num at hs
  have h := LFunction_eq_completed_div_gammaFactor χ s (Or.inl hs0)
  rw [h]
  field_simp [gammaFactor_ne_zero_of_one_lt_re χ hs]

/-- **`LFunction` does not vanish on `1 < re s`.** -/
theorem LFunction_ne_zero_of_one_lt_re' {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) : LFunction χ s ≠ 0 :=
  LFunction_ne_zero_of_one_le_re χ (Or.inr (by rintro rfl; simp at hs)) hs.le

/-- **`completedLFunction` does not vanish on `1 < re s`.** -/
theorem completedLFunction_ne_zero_of_one_lt_re {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) : completedLFunction χ s ≠ 0 := by
  rw [completedLFunction_eq_gammaFactor_mul_LFunction χ hs]
  exact mul_ne_zero (gammaFactor_ne_zero_of_one_lt_re χ hs)
    (LFunction_ne_zero_of_one_lt_re' χ hs)

/-- **The `LFunction` logarithmic derivative is minus the prime series.**  On `1 < re s`,
    `logDeriv (LFunction χ) s = −LSeries (fun n ↦ Λ n · χ n) s`. -/
theorem logDeriv_LFunction_eq {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ} (hs : 1 < s.re) :
    logDeriv (LFunction χ) s = -LSeries (fun n => dirichletWeight χ n) s := by
  have heq : LFunction χ =ᶠ[𝓝 s] (fun z => LSeries (fun n => χ n) z) := by
    filter_upwards [(isOpen_lt continuous_const Complex.continuous_re).mem_nhds hs] with z hz
    exact LFunction_eq_LSeries χ hz
  rw [(logDeriv_congr_nhds heq).eq_of_nhds]
  exact neg_eq_iff_eq_neg.mp (neg_logDeriv_LSeries_dirichlet χ hs)

/-- `Gammaℝ` is complex-differentiable on `0 < re s`. -/
theorem differentiableAt_Gammaℝ {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ Complex.Gammaℝ s := by
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  haveI : NeZero (Real.pi : ℂ) := ⟨hpi⟩
  have hs2 : 0 < (s / 2).re := by
    rw [Complex.div_re]
    norm_num [Complex.normSq_apply, Complex.ofReal_re, Complex.ofReal_im]
    linarith
  rw [show Complex.Gammaℝ
        = fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2) from
      funext Complex.Gammaℝ_def]
  refine DifferentiableAt.mul ?_ ?_
  · exact (differentiableAt_const_cpow_of_neZero (Real.pi : ℂ) (-s / 2)).comp s (by fun_prop)
  · refine (Complex.differentiableAt_Gamma (s / 2) ?_).comp s (by fun_prop)
    intro m h
    have hre := congrArg Complex.re h
    simp only [Complex.neg_re, Complex.natCast_re] at hre
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith

/-- `s ↦ Gammaℝ (s + 1)` is complex-differentiable where the argument has positive real part. -/
theorem differentiableAt_Gammaℝ_add_one {s : ℂ} (hs : 0 < (s + 1).re) :
    DifferentiableAt ℂ (fun s : ℂ => Complex.Gammaℝ (s + 1)) s := by
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  haveI : NeZero (Real.pi : ℂ) := ⟨hpi⟩
  have hs2 : 0 < ((s + 1) / 2).re := by
    have hs' : 0 < s.re + 1 := by
      have h := hs; rw [Complex.add_re, Complex.one_re] at h; exact h
    rw [Complex.div_re]
    norm_num [Complex.normSq_apply, Complex.ofReal_re, Complex.ofReal_im]
    linarith
  rw [show (fun s : ℂ => Complex.Gammaℝ (s + 1))
        = fun s : ℂ => (Real.pi : ℂ) ^ (-(s + 1) / 2) * Complex.Gamma ((s + 1) / 2) from
      funext (fun s => Complex.Gammaℝ_def (s + 1))]
  refine DifferentiableAt.mul ?_ ?_
  · exact (differentiableAt_const_cpow_of_neZero (Real.pi : ℂ) (-(s + 1) / 2)).comp s (by fun_prop)
  · refine (Complex.differentiableAt_Gamma ((s + 1) / 2) ?_).comp s (by fun_prop)
    intro m h
    have hre := congrArg Complex.re h
    simp only [Complex.neg_re, Complex.natCast_re] at hre
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith

/-- `gammaFactor χ` is complex-differentiable on `1 < re s`. -/
theorem differentiableAt_gammaFactor {N : ℕ} (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) : DifferentiableAt ℂ (gammaFactor χ) s := by
  rcases χ.even_or_odd with h | h
  · rw [show gammaFactor χ = Complex.Gammaℝ from funext h.gammaFactor_def]
    exact differentiableAt_Gammaℝ (by linarith)
  · rw [show gammaFactor χ = fun s => Complex.Gammaℝ (s + 1) from funext h.gammaFactor_def]
    exact differentiableAt_Gammaℝ_add_one (by
      simp only [Complex.add_re, Complex.one_re]; linarith)

/-- **The product rule for the completed L-function.** -/
theorem logDeriv_completedLFunction_eq {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) :
    logDeriv (completedLFunction χ) s
      = logDeriv (gammaFactor χ) s + logDeriv (LFunction χ) s := by
  have heq : completedLFunction χ =ᶠ[𝓝 s]
      (fun z => gammaFactor χ z * LFunction χ z) := by
    filter_upwards [(isOpen_lt continuous_const Complex.continuous_re).mem_nhds hs] with z hz
    exact completedLFunction_eq_gammaFactor_mul_LFunction χ hz
  rw [(logDeriv_congr_nhds heq).eq_of_nhds]
  have hs1 : s ≠ 1 := by intro h; rw [h] at hs; norm_num at hs
  exact logDeriv_mul s (gammaFactor_ne_zero_of_one_lt_re χ hs)
    (LFunction_ne_zero_of_one_lt_re' χ hs) (differentiableAt_gammaFactor χ hs)
    (differentiableAt_LFunction χ s (Or.inl hs1))

/-- **The assembled integrand of the Dirichlet explicit formula.**  For nontrivial `χ` and
`1 < re s`,

    `logDeriv (dirichletCompleted χ) s
        = (1/2) log N + logDeriv (gammaFactor χ) s − LSeries (fun n ↦ Λ n · χ n) s`.

This is the archimedean-plus-conductor part minus the prime series — the integrand whose
contour integral is the explicit formula. -/
theorem logDeriv_dirichletCompleted_eq {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 1 < s.re) :
    logDeriv (dirichletCompleted χ) s
      = (1 / 2) * Complex.log (N : ℂ) + logDeriv (gammaFactor χ) s
        - LSeries (fun n => dirichletWeight χ n) s := by
  have hN : (N : ℂ) ≠ 0 := by exact_mod_cast (NeZero.ne N)
  have hs0 : s ≠ 0 := by intro h; rw [h] at hs; norm_num at hs
  have hNdiff : DifferentiableAt ℂ (fun s : ℂ => (N : ℂ) ^ (s / 2)) s := by
    have h : DifferentiableAt ℂ (fun s : ℂ => s / 2) s := by fun_prop
    simpa using h.const_cpow (Or.inl hN)
  have hClog : logDeriv (fun s : ℂ => (N : ℂ) ^ (s / 2)) s
      = (1 / 2) * Complex.log (N : ℂ) := by
    have hg : DifferentiableAt ℂ (fun s : ℂ => s / 2) s := by fun_prop
    have hf : DifferentiableAt ℂ (fun z : ℂ => (N : ℂ) ^ z) (s / 2) :=
      differentiableAt_const_cpow_of_neZero (N : ℂ) (s / 2)
    rw [show (fun s : ℂ => (N : ℂ) ^ (s / 2))
          = (fun z : ℂ => (N : ℂ) ^ z) ∘ (fun s : ℂ => s / 2) from rfl,
      logDeriv_comp (f := fun z : ℂ => (N : ℂ) ^ z) (g := fun s : ℂ => s / 2) hf hg,
      congrFun (Complex.logDeriv_const_cpow hN) (s / 2), deriv_div_two]
    ring
  have hCdiff : DifferentiableAt ℂ (fun s : ℂ => completedLFunction χ s) s :=
    differentiableAt_completedLFunction χ s (Or.inl hs0) (Or.inr hχ)
  unfold dirichletCompleted
  rw [show (fun s : ℂ => (N : ℂ) ^ (s / 2) * completedLFunction χ s)
        = (fun s : ℂ => (N : ℂ) ^ (s / 2)) * (fun s : ℂ => completedLFunction χ s) from rfl]
  rw [logDeriv_mul (f := fun s : ℂ => (N : ℂ) ^ (s / 2))
        (g := fun s : ℂ => completedLFunction χ s) s
        (Complex.cpow_ne_zero_iff.mpr (Or.inl hN))
        (completedLFunction_ne_zero_of_one_lt_re χ hs) hNdiff hCdiff,
      hClog, logDeriv_completedLFunction_eq χ hs, logDeriv_LFunction_eq χ hs]
  ring

/-- The archimedean factor's logarithmic derivative, evaluated (even case). -/
theorem logDeriv_gammaFactor_even {N : ℕ} (χ : DirichletCharacter ℂ N) (hE : χ.Even) {s : ℂ}
    (hs : 1 < s.re) :
    logDeriv (gammaFactor χ) s
      = -(1 / 2) * Complex.log (Real.pi : ℂ) + (1 / 2) * Complex.digamma (s / 2) := by
  rw [show gammaFactor χ = Complex.Gammaℝ from funext hE.gammaFactor_def]
  exact Complex.logDeriv_Gammaℝ (by linarith)

/-- The archimedean factor's logarithmic derivative, evaluated (odd case). -/
theorem logDeriv_gammaFactor_odd {N : ℕ} (χ : DirichletCharacter ℂ N) (hO : χ.Odd) {s : ℂ}
    (hs : 1 < s.re) :
    logDeriv (gammaFactor χ) s
      = -(1 / 2) * Complex.log (Real.pi : ℂ) + (1 / 2) * Complex.digamma ((s + 1) / 2) := by
  have hs' : 0 < (s + 1).re := by rw [Complex.add_re, Complex.one_re]; linarith
  have hg : DifferentiableAt ℂ (fun s : ℂ => s + 1) s := by fun_prop
  have hf : DifferentiableAt ℂ Complex.Gammaℝ (s + 1) := differentiableAt_Gammaℝ hs'
  rw [show gammaFactor χ = fun s : ℂ => Complex.Gammaℝ (s + 1) from funext hO.gammaFactor_def,
    show (fun s : ℂ => Complex.Gammaℝ (s + 1)) = Complex.Gammaℝ ∘ (fun s : ℂ => s + 1) from rfl,
    logDeriv_comp (f := Complex.Gammaℝ) (g := fun s : ℂ => s + 1) hf hg,
    Complex.logDeriv_Gammaℝ hs']
  simp

/-- **The explicit-formula integrand, fully evaluated (even `χ`).** -/
theorem logDeriv_dirichletCompleted_eq_even {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hE : χ.Even) {s : ℂ} (hs : 1 < s.re) :
    logDeriv (dirichletCompleted χ) s
      = (1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
        + (1 / 2) * Complex.digamma (s / 2)
        - LSeries (fun n => dirichletWeight χ n) s := by
  rw [logDeriv_dirichletCompleted_eq χ hχ hs, logDeriv_gammaFactor_even χ hE hs]
  ring

/-- **The explicit-formula integrand, fully evaluated (odd `χ`).** -/
theorem logDeriv_dirichletCompleted_eq_odd {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hO : χ.Odd) {s : ℂ} (hs : 1 < s.re) :
    logDeriv (dirichletCompleted χ) s
      = (1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
        + (1 / 2) * Complex.digamma ((s + 1) / 2)
        - LSeries (fun n => dirichletWeight χ n) s := by
  rw [logDeriv_dirichletCompleted_eq χ hχ hs, logDeriv_gammaFactor_odd χ hO hs]
  ring

/-- `gammaFactor` is differentiable on the whole right half-plane `Re s > 0` — the `1 < re s`
hypothesis of `differentiableAt_gammaFactor` is stronger than its proof needs.  This is what makes
the factorisation `Λ = N^{s/2}·γ·L` available on the edge `Re s = 1`. -/
theorem differentiableAt_gammaFactor_of_re_pos {N : ℕ} (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 0 < s.re) : DifferentiableAt ℂ (gammaFactor χ) s := by
  rcases χ.even_or_odd with h | h
  · rw [show gammaFactor χ = Complex.Gammaℝ from funext h.gammaFactor_def]
    exact differentiableAt_Gammaℝ hs
  · rw [show gammaFactor χ = fun s => Complex.Gammaℝ (s + 1) from funext h.gammaFactor_def]
    exact differentiableAt_Gammaℝ_add_one (by
      simp only [Complex.add_re, Complex.one_re]; linarith)

/-- **The edge factorisation (O1.T9).**  `Λ_χ = N^{s/2}·γ_χ·L_χ` on the whole right half-plane
`Re s > 0`, not merely for `Re s > 1`.  This is what makes the decomposition
`Λ'/Λ = (1/2)log N + γ'/γ + L'/L` available on the edge `Re s = 1`.  Purely an
analytic-continuation identity: both sides are holomorphic on `{0 < Re s}` and agree on the
non-empty open `{1 < Re s}`. -/
theorem completedLFunction_eq_gammaFactor_mul_LFunction_of_re_pos {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) :
    completedLFunction χ s = gammaFactor χ s * LFunction χ s := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const Complex.continuous_re
  have hconn : IsPreconnected {s : ℂ | 0 < s.re} := (convex_halfSpace_re_gt 0).isPreconnected
  have hf : AnalyticOnNhd ℂ (completedLFunction χ) {s : ℂ | 0 < s.re} :=
    (differentiable_completedLFunction hχ).differentiableOn.analyticOnNhd hU
  have hg : AnalyticOnNhd ℂ (fun s => gammaFactor χ s * LFunction χ s) {s : ℂ | 0 < s.re} := by
    refine DifferentiableOn.analyticOnNhd (fun s hs => ?_) hU
    exact ((differentiableAt_gammaFactor_of_re_pos χ hs).mul
      ((differentiable_LFunction hχ).differentiableAt)).differentiableWithinAt
  have h2 : (2 : ℂ) ∈ {s : ℂ | 0 < s.re} := by norm_num
  have hmem : {z : ℂ | 1 < z.re} ∈ 𝓝 (2 : ℂ) :=
    (isOpen_lt continuous_const Complex.continuous_re).mem_nhds (by norm_num : (1 : ℝ) < (2 : ℂ).re)
  have heq : completedLFunction χ =ᶠ[𝓝 (2 : ℂ)]
      fun s => gammaFactor χ s * LFunction χ s :=
    Filter.eventually_iff_exists_mem.mpr ⟨{z : ℂ | 1 < z.re}, hmem, fun z hz =>
      completedLFunction_eq_gammaFactor_mul_LFunction χ hz⟩
  exact AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hf hg hconn h2 heq hs



/-- **The edge decomposition (O1.T9).**  On `Re s = 1` — where `L` does not vanish and `γ` does not
either — the log-derivative of the completed L-function splits into conductor, archimedean and
L-function parts.  This is the decomposition (V) integrates. -/
theorem logDeriv_completedLFunction_eq_re_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : s.re = 1) :
    logDeriv (completedLFunction χ) s = logDeriv (gammaFactor χ) s + logDeriv (LFunction χ) s := by
  have hs0 : 0 < s.re := by rw [hs]; norm_num
  have heq : completedLFunction χ =ᶠ[𝓝 s]
      fun z => gammaFactor χ z * LFunction χ z := by
    filter_upwards [(isOpen_lt continuous_const Complex.continuous_re).mem_nhds hs0] with z hz
    exact completedLFunction_eq_gammaFactor_mul_LFunction_of_re_pos χ hχ hz
  rw [(logDeriv_congr_nhds heq).eq_of_nhds]
  exact logDeriv_mul s (gammaFactor_ne_zero_of_re_pos χ hs0)
    (LFunction_ne_zero_of_re_eq_one χ hs (Or.inl hχ))
    (differentiableAt_gammaFactor_of_re_pos χ hs0)
    ((differentiable_LFunction hχ).differentiableAt)

/-- **(V) on the edge, assembled.**  Given the two pointwise bounds on the edge `Re s = 1` — one for
the archimedean factor and one for `L′/L` — the log-derivative of the completed L-function obeys the
interface's pointwise shape on that edge.  This *names* exactly what (V) consumes: the `L′/L` bound is
the only input not yet available (journal 275/278), and the archimedean one is journal 273. -/
theorem norm_logDeriv_completedLFunction_re_one_le {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {Cγ CL : ℝ}
    (hγ : ∀ y : ℝ, ‖logDeriv (gammaFactor χ) (1 + y * Complex.I)‖
      ≤ Cγ * (1 + Real.log (|y| + 2)))
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2))) :
    ∀ y : ℝ, ‖logDeriv (completedLFunction χ) (1 + y * Complex.I)‖
      ≤ (Cγ + CL) * (1 + Real.log (|y| + 2)) := by
  intro y
  have hs : ((1 : ℂ) + (y : ℂ) * Complex.I).re = 1 := by simp
  rw [logDeriv_completedLFunction_eq_re_one χ hχ hs]
  calc ‖logDeriv (gammaFactor χ) (1 + y * Complex.I)
        + logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ ‖logDeriv (gammaFactor χ) (1 + y * Complex.I)‖
        + ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖ := norm_add_le _ _
    _ ≤ Cγ * (1 + Real.log (|y| + 2)) + CL * (1 + Real.log (|y| + 2)) :=
        add_le_add (hγ y) (hL y)
    _ = (Cγ + CL) * (1 + Real.log (|y| + 2)) := by ring

/-- `logDeriv (z ↦ c ^ (z / 2)) = (1/2) log c` — the conductor term, assembled by hand because
Mathlib has no `logDeriv_const_cpow` (journals 284/285). -/
theorem logDeriv_cpow_half (c : ℂ) (hc : c ≠ 0) (s : ℂ) :
    logDeriv (fun z : ℂ => c ^ (z / 2)) s = (1 / 2) * Complex.log c := by
  have hpow : c ^ (s / 2) ≠ 0 := by
    rw [Complex.cpow_def_of_ne_zero hc]
    exact Complex.exp_ne_zero _
  have h1 : HasDerivAt (fun z : ℂ => z / 2) (1 / 2) s := by
    simpa using (hasDerivAt_id s).div_const 2
  have h2 : HasDerivAt (fun z : ℂ => c ^ (z / 2))
      ((1 / 2) * c ^ (s / 2) * Complex.log c) s := by
    simpa [mul_comm, mul_left_comm, mul_assoc] using h1.const_cpow (Or.inl hc)
  rw [logDeriv_apply, h2.deriv]
  field_simp [hpow]



/-- **O1.T10 step 1.**  On the edge `Re s = 1`, the log-derivative of `dirichletCompleted χ` splits
off the conductor term `(1/2) log N` — so the landed assembly (journal 281) transfers to
`completedLogDeriv χ`, the integrand the interface actually names. -/
theorem logDeriv_dirichletCompleted_eq_re_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : s.re = 1) :
    logDeriv (dirichletCompleted χ) s
      = (1 / 2) * Complex.log (N : ℂ) + logDeriv (completedLFunction χ) s := by
  have hN : (N : ℂ) ≠ 0 := by exact_mod_cast NeZero.ne N
  have hs0 : 0 < s.re := by rw [hs]; norm_num
  have hcL : completedLFunction χ s ≠ 0 := by
    rw [completedLFunction_eq_gammaFactor_mul_LFunction_of_re_pos χ hχ hs0]
    exact mul_ne_zero (gammaFactor_ne_zero_of_re_pos χ hs0)
      (LFunction_ne_zero_of_re_eq_one χ hs (Or.inl hχ))
  have hpow : (N : ℂ) ^ (s / 2) ≠ 0 := by
    rw [Complex.cpow_def_of_ne_zero hN]
    exact Complex.exp_ne_zero _
  have hfun : dirichletCompleted χ
      = fun z => (N : ℂ) ^ (z / 2) * completedLFunction χ z := by
    funext z
    rfl
  have hdiff1 : DifferentiableAt ℂ (fun z : ℂ => (N : ℂ) ^ (z / 2)) s := by
    have h1 : HasDerivAt (fun z : ℂ => z / 2) (1 / 2) s := by
      simpa using (hasDerivAt_id s).div_const 2
    exact (h1.const_cpow (Or.inl hN)).differentiableAt
  have hmul : logDeriv (fun z => (N : ℂ) ^ (z / 2) * completedLFunction χ z) s
      = logDeriv ((fun z : ℂ => (N : ℂ) ^ (z / 2)) * completedLFunction χ) s := by
    rfl
  rw [hfun, hmul, logDeriv_mul s hpow hcL hdiff1
    ((differentiable_completedLFunction hχ).differentiableAt),
    logDeriv_cpow_half (N : ℂ) hN s]
end

end RouteABC
