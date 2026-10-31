import Mathlib

/-!
# The symbol identity `A_arch + Q = -Z'/Z`

Let `Z(s) = exp(-(s/2) log π) Γ(s/2) ζ(s)` and `ψ = Complex.digamma`.

* `logDeriv_completedZeta_of_ne_one`: the log-derivative expansion
  `Z'/Z(s) = -(1/2)log π + (1/2)ψ(s/2) + ζ'/ζ(s)`, for `s ≠ 1`,
  `Γ(s/2) ≠ 0` and `ζ(s) ≠ 0`.
* `symbol_identity_continued`: the symbol identity with the *continued*
  prime symbol `Q = -ζ'/ζ`, at every such `s` — in particular on the
  imaginary axis.
* `symbol_identity`: on `re s > 1`, the prime symbol is the von Mangoldt
  L-series, giving `A_arch + Q = -Z'/Z` with `Q = L_Λ(s)`.

No RH proof yet. No Riemann-hypothesis claim is made.  The passage from the L-series to the
continued symbol uses Mathlib's
`ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div`; the
nonvanishing of `ζ` off `re s > 1` is not assumed or proved here.
-/

namespace AbsoluteHodgeSymbol

open Complex

/-- `Z(s) = exp(-(s/2) log π) Γ(s/2) ζ(s)`. -/
noncomputable def completedZeta (s : ℂ) : ℂ :=
  cexp (-(s / 2) * log (Real.pi : ℂ)) * Gamma (s / 2) * riemannZeta s

theorem div_two_re (s : ℂ) : (s / 2).re = s.re / 2 := by
  simp

/-- `logDeriv` of the exponential factor. -/
theorem logDeriv_exp_factor (s L : ℂ) :
    logDeriv (fun z : ℂ => cexp (-(z / 2) * L)) s = -(1 / 2) * L := by
  have hd1 : DifferentiableAt ℂ cexp (-(s / 2) * L) := by fun_prop
  have hd2 : DifferentiableAt ℂ (fun z : ℂ => -(z / 2) * L) s := by fun_prop
  change logDeriv (cexp ∘ fun z : ℂ => -(z / 2) * L) s = -(1 / 2) * L
  rw [logDeriv_comp (f := cexp) (g := fun z : ℂ => -(z / 2) * L) (x := s) hd1 hd2]
  have hexp : logDeriv cexp (-(s / 2) * L) = 1 :=
    congrFun Complex.logDeriv_exp (-(s / 2) * L)
  rw [hexp]
  simp

/-- `logDeriv` of `Γ(s/2)` is `(1/2) ψ(s/2)`. -/
theorem logDeriv_gamma_half (s : ℂ) (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) :
    logDeriv (fun z : ℂ => Gamma (z / 2)) s = (1 / 2) * digamma (s / 2) := by
  have hd1 : DifferentiableAt ℂ Gamma (s / 2) := Complex.differentiableAt_Gamma (s / 2) hg
  have hd2 : DifferentiableAt ℂ (fun z : ℂ => z / 2) s := by fun_prop
  change logDeriv (Gamma ∘ fun z : ℂ => z / 2) s = (1 / 2) * digamma (s / 2)
  rw [logDeriv_comp (f := Gamma) (g := fun z : ℂ => z / 2) (x := s) hd1 hd2]
  have hpsi : logDeriv Gamma (s / 2) = digamma (s / 2) := by
    rw [Complex.digamma_def]
  rw [hpsi]
  simp
  ring

/-- `s/2` is not a pole of `Γ` when `re s > 1`. -/
theorem gamma_half_ne_pole {s : ℂ} (hs : 1 < s.re) :
    ∀ m : ℕ, s / 2 ≠ -(m : ℂ) := by
  intro m h
  have hre : s.re / 2 = -(m : ℝ) := by
    have h' := congrArg Complex.re h
    rw [div_two_re] at h'
    simpa using h'
  have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  nlinarith

/-- The log-derivative expansion of `Z`, with explicit nonvanishing
hypotheses rather than a half-plane restriction. -/
theorem logDeriv_completedZeta_of_ne_one {s : ℂ} (hs1 : s ≠ 1)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) (hz : riemannZeta s ≠ 0) :
    logDeriv completedZeta s =
      -(1 / 2) * log (Real.pi : ℂ) + (1 / 2) * digamma (s / 2)
        + logDeriv riemannZeta s := by
  have hA : cexp (-(s / 2) * log (Real.pi : ℂ)) ≠ 0 := Complex.exp_ne_zero _
  have hG : Gamma (s / 2) ≠ 0 := Complex.Gamma_ne_zero hg
  have hdA : DifferentiableAt ℂ (fun z : ℂ => cexp (-(z / 2) * log (Real.pi : ℂ))) s := by
    fun_prop
  have hdG : DifferentiableAt ℂ (fun z : ℂ => Gamma (z / 2)) s := by
    apply DifferentiableAt.comp
    · exact Complex.differentiableAt_Gamma (s / 2) hg
    · fun_prop
  have hdZ : DifferentiableAt ℂ riemannZeta s := differentiableAt_riemannZeta hs1
  have hAG : cexp (-(s / 2) * log (Real.pi : ℂ)) * Gamma (s / 2) ≠ 0 :=
    mul_ne_zero hA hG
  unfold completedZeta
  rw [logDeriv_fun_mul (f := fun z : ℂ =>
        cexp (-(z / 2) * log (Real.pi : ℂ)) * Gamma (z / 2))
      (g := riemannZeta) (x := s) hAG hz (hdA.mul hdG) hdZ]
  rw [logDeriv_fun_mul (f := fun z : ℂ => cexp (-(z / 2) * log (Real.pi : ℂ)))
      (g := fun z : ℂ => Gamma (z / 2)) (x := s) hA hG hdA hdG]
  rw [logDeriv_exp_factor s (log (Real.pi : ℂ))]
  rw [logDeriv_gamma_half s hg]

/-- The log-derivative expansion on `re s > 1`. -/
theorem logDeriv_completedZeta {s : ℂ} (hs : 1 < s.re) :
    logDeriv completedZeta s =
      -(1 / 2) * log (Real.pi : ℂ) + (1 / 2) * digamma (s / 2)
        + logDeriv riemannZeta s := by
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at hs
    norm_num at hs
  exact logDeriv_completedZeta_of_ne_one hs1 (gamma_half_ne_pole hs)
    (riemannZeta_ne_zero_of_one_lt_re hs)

/-- **The symbol identity with the continued prime symbol.**
`A_arch(s) - ζ'/ζ(s) = -Z'/Z(s)` at every `s` where `Z` and `ζ'/ζ` are
defined (in particular on the imaginary axis, away from zeros and poles). -/
theorem symbol_identity_continued {s : ℂ} (hs1 : s ≠ 1)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) (hz : riemannZeta s ≠ 0) :
    (1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma (s / 2)
        - logDeriv riemannZeta s
      = - logDeriv completedZeta s := by
  rw [logDeriv_completedZeta_of_ne_one hs1 hg hz]
  ring

/-- The symbol identity on `re s > 1`, with `Q` the von Mangoldt L-series. -/
theorem symbol_identity {s : ℂ} (hs : 1 < s.re) :
    (1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma (s / 2)
        + LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s
      = - logDeriv completedZeta s := by
  rw [logDeriv_completedZeta hs]
  have hL := ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs
  rw [hL, logDeriv_apply]
  ring


/-- Our `completedZeta` is Mathlib's `completedRiemannZeta` (away from its
poles and the trivial zeros), using `Gammaℝ s = π^{-s/2} Γ(s/2)`. -/
theorem completedZeta_eq_completedRiemannZeta {s : ℂ} (hs0 : s ≠ 0)
    (_hs1 : s ≠ 1) (hΓ : s.Gammaℝ ≠ 0) :
    completedZeta s = completedRiemannZeta s := by
  have hπ : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hc : cexp (-(s / 2) * log (Real.pi : ℂ)) = (Real.pi : ℂ) ^ (-s / 2) := by
    rw [Complex.cpow_def, ite_eq_right hπ]
    congr 1
    ring
  have hζ : riemannZeta s = completedRiemannZeta s / s.Gammaℝ :=
    riemannZeta_def_of_ne_zero hs0
  have hΛ : completedRiemannZeta s = s.Gammaℝ * riemannZeta s := by
    rw [hζ]
    field_simp [hΓ]
  unfold completedZeta
  rw [hc, hΛ, Complex.Gammaℝ_def]

/-- **The functional equation of the completed zeta**: `Z(1 - s) = Z(s)`,
for `s` away from `0`, `1` and the poles of the Gamma factor. -/
theorem completedZeta_one_sub {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0) :
    completedZeta (1 - s) = completedZeta s := by
  have h1s0 : 1 - s ≠ 0 := by
    intro h
    apply hs1
    linear_combination -h
  have h1s1 : 1 - s ≠ 1 := by
    intro h
    apply hs0
    linear_combination -h
  rw [completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ,
    completedZeta_eq_completedRiemannZeta h1s0 h1s1 hΓ',
    completedRiemannZeta_one_sub]


/-- **Zeros pair under `s ↦ 1 - s`.**  If `Z(s) = 0`, then `Z(1 - s) = 0`. -/
theorem completedZeta_zero_symm {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hz : completedZeta s = 0) :
    completedZeta (1 - s) = 0 := by
  rw [completedZeta_one_sub hs0 hs1 hΓ hΓ', hz]

/-- Conversely, a zero at `1 - s` gives a zero at `s`. -/
theorem completedZeta_zero_symm' {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hz : completedZeta (1 - s) = 0) :
    completedZeta s = 0 := by
  rw [← completedZeta_one_sub hs0 hs1 hΓ hΓ']
  exact hz

/-- A zero off the critical line comes with a distinct partner `1 - s`. -/
theorem completedZeta_zero_pair {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hoff : s ≠ 1 - s) (hz : completedZeta s = 0) :
    ∃ t : ℂ, t ≠ s ∧ completedZeta t = 0 :=
  ⟨1 - s, fun h => hoff h.symm,
    completedZeta_zero_symm hs0 hs1 hΓ hΓ' hz⟩


/-- `Gammaℝ` is nonzero on the critical line. -/
theorem gammaR_critical_line_ne_zero (t : ℝ) :
    ((1 / 2 + Complex.I * (t : ℂ)).Gammaℝ) ≠ 0 := by
  have hπ : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hpow : (Real.pi : ℂ) ^ (-(1 / 2 + Complex.I * (t : ℂ)) / 2) ≠ 0 := by
    rw [Complex.cpow_def, ite_eq_right hπ]
    exact Complex.exp_ne_zero _
  have hg : Complex.Gamma ((1 / 2 + Complex.I * (t : ℂ)) / 2) ≠ 0 := by
    apply Complex.Gamma_ne_zero
    intro m h
    have hre := congrArg Complex.re h
    simp at hre
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    nlinarith
  rw [Complex.Gammaℝ_def]
  exact mul_ne_zero hpow hg

/-- **Critical-line symmetry**: `Z(1/2 + it) = Z(1/2 - it)`. -/
theorem completedZeta_critical_line (t : ℝ) :
    completedZeta (1 / 2 + Complex.I * (t : ℂ))
      = completedZeta (1 / 2 - Complex.I * (t : ℂ)) := by
  have hΓ := gammaR_critical_line_ne_zero t
  have hΓ' := gammaR_critical_line_ne_zero (-t)
  have h0 : (1 / 2 + Complex.I * (t : ℂ)) ≠ 0 := by
    intro h
    have hre := congrArg Complex.re h
    norm_num at hre
  have h1 : (1 / 2 + Complex.I * (t : ℂ)) ≠ 1 := by
    intro h
    have hre := congrArg Complex.re h
    norm_num at hre
  have hΓ'' : (1 - (1 / 2 + Complex.I * (t : ℂ))).Gammaℝ ≠ 0 := by
    have harg : 1 - (1 / 2 + Complex.I * (t : ℂ))
        = 1 / 2 + Complex.I * ((-t : ℝ) : ℂ) := by
      push_cast
      ring
    rw [harg]
    exact hΓ'
  have h := completedZeta_one_sub (s := 1 / 2 + Complex.I * (t : ℂ)) h0 h1 hΓ hΓ''
  have harg : 1 - (1 / 2 + Complex.I * (t : ℂ)) = 1 / 2 - Complex.I * (t : ℂ) := by
    ring
  rw [harg] at h
  exact h.symm


/-- A zero on the critical line is paired with its conjugate. -/
theorem completedZeta_critical_line_zero_iff (t : ℝ) :
    completedZeta (1 / 2 + Complex.I * (t : ℂ)) = 0
      ↔ completedZeta (1 / 2 - Complex.I * (t : ℂ)) = 0 := by
  rw [completedZeta_critical_line t]

/-- **Log-derivative antisymmetry** of the completed zeta:
`(Z'/Z)(1 - s) = -(Z'/Z)(s)`, for `s ≠ 0, 1`. -/
theorem logDeriv_completedRiemannZeta_one_sub (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    logDeriv completedRiemannZeta (1 - s) = - logDeriv completedRiemannZeta s := by
  have h1s0 : 1 - s ≠ 0 := by
    intro h; apply hs1; linear_combination -h
  have h1s1 : 1 - s ≠ 1 := by
    intro h; apply hs0; linear_combination -h
  have hd : DifferentiableAt ℂ completedRiemannZeta (1 - s) :=
    differentiableAt_completedZeta h1s0 h1s1
  have hfun : (fun z : ℂ => completedRiemannZeta (1 - z)) = completedRiemannZeta := by
    funext z
    exact completedRiemannZeta_one_sub z
  have hcomp : logDeriv (fun z : ℂ => completedRiemannZeta (1 - z)) s
      = logDeriv completedRiemannZeta (1 - s) * deriv (fun z : ℂ => 1 - z) s := by
    change logDeriv (completedRiemannZeta ∘ fun z : ℂ => 1 - z) s = _
    rw [logDeriv_comp hd (by fun_prop)]
  have hlin : deriv (fun z : ℂ => 1 - z) s = -1 := by
    simp
  have heq : logDeriv (fun z : ℂ => completedRiemannZeta (1 - z)) s
      = logDeriv completedRiemannZeta s := by
    rw [hfun]
  rw [hcomp, hlin] at heq
  have hneg : - logDeriv completedRiemannZeta (1 - s)
      = logDeriv completedRiemannZeta s := by
    simpa using heq
  rw [← hneg]
  ring


/-- The log-derivative antisymmetry on the critical line:
`(Z'/Z)(1/2 - it) = -(Z'/Z)(1/2 + it)`. -/
theorem logDeriv_completedRiemannZeta_critical_line (t : ℝ) :
    logDeriv completedRiemannZeta (1 / 2 - Complex.I * (t : ℂ))
      = - logDeriv completedRiemannZeta (1 / 2 + Complex.I * (t : ℂ)) := by
  have h0 : (1 / 2 + Complex.I * (t : ℂ)) ≠ 0 := by
    intro h
    have hre := congrArg Complex.re h
    norm_num at hre
  have h1 : (1 / 2 + Complex.I * (t : ℂ)) ≠ 1 := by
    intro h
    have hre := congrArg Complex.re h
    norm_num at hre
  have h := logDeriv_completedRiemannZeta_one_sub (s := 1 / 2 + Complex.I * (t : ℂ)) h0 h1
  have harg : 1 - (1 / 2 + Complex.I * (t : ℂ))
      = 1 / 2 - Complex.I * (t : ℂ) := by
    ring
  rwa [harg] at h

/-- **Conjugation symmetry** of the completed zeta:
`Z(conj s) = conj (Z s)`.  The zero set is conjugation-stable, so the zero
sum of the explicit formula is real. -/
theorem completedZeta_conj (s : ℂ) :
    completedZeta ((starRingEnd ℂ) s) = (starRingEnd ℂ) (completedZeta s) := by
  unfold completedZeta
  have hlog : Complex.log (Real.pi : ℂ) = ↑(Real.log Real.pi) :=
    (Complex.ofReal_log (le_of_lt Real.pi_pos)).symm
  have harg : -((starRingEnd ℂ) s / 2) * log (Real.pi : ℂ)
      = (starRingEnd ℂ) (-(s / 2) * log (Real.pi : ℂ)) := by
    rw [hlog]
    simp only [map_mul, map_div₀, map_neg, map_ofNat, Complex.conj_ofReal]
  rw [harg, Complex.exp_conj]
  rw [map_mul, map_mul, riemannZeta_conj]
  congr 1
  have h2 : (starRingEnd ℂ) s / 2 = (starRingEnd ℂ) (s / 2) := by
    have h2c : (starRingEnd ℂ) (2 : ℂ) = 2 := by
      apply Complex.ext <;> simp
    rw [map_div₀, h2c]
  rw [h2, Complex.Gamma_conj]

/-- A zero at `s` gives a zero at `conj s`. -/
theorem completedZeta_zero_conj {s : ℂ} (hz : completedZeta s = 0) :
    completedZeta ((starRingEnd ℂ) s) = 0 := by
  rw [completedZeta_conj, hz, map_zero]


/-- The completed zeta is **real on the real axis**. -/
theorem completedZeta_ofReal_im_zero (x : ℝ) :
    (completedZeta (x : ℂ)).im = 0 := by
  have h := completedZeta_conj (x : ℂ)
  rw [Complex.conj_ofReal] at h
  have := congrArg Complex.im h
  simp at this
  linarith


/-- `Z` has no zeros on `Re s > 1` (the Euler-product half-plane). -/
theorem completedZeta_ne_zero_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    completedZeta s ≠ 0 := by
  intro hZ
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hΓ : s.Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have hre := congrArg Complex.re hm
      simp at hre
      have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      nlinarith
  have hζ : riemannZeta s ≠ 0 := riemannZeta_ne_zero_of_one_lt_re hs
  have hΛ : completedRiemannZeta s = 0 := by
    rw [← completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ, hZ]
  have h := riemannZeta_def_of_ne_zero hs0
  rw [hΛ] at h
  simp at h
  exact hζ h


/-- A nontrivial zero cannot lie on `Re s < 0`: use the functional equation to
transfer to `Re > 1`, where `Z` is nonzero. -/
theorem completedZeta_ne_zero_of_re_lt_zero_of_not_trivial {s : ℂ}
    (hs : s.re < 0) (hnt : ∀ n : ℕ, s ≠ -(2 * (n + 1) : ℂ)) :
    completedZeta s ≠ 0 := by
  intro hZ
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    simp at hs
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have h1s : 1 < (1 - s).re := by
    simp [Complex.sub_re]
    linarith
  have hZ1 : completedZeta (1 - s) ≠ 0 :=
    completedZeta_ne_zero_of_one_lt_re h1s
  have hΓ : s.Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have h2 : s = -(2 * (m : ℂ)) := by
        calc s = 2 * (s / 2) := by ring
          _ = 2 * (-(m : ℂ)) := by rw [hm]
          _ = -(2 * (m : ℂ)) := by ring
      rcases m with _ | m
      · simp at h2
        rw [h2] at hs
        simp at hs
      · exact hnt m (by simpa [Nat.cast_succ] using h2)
  have hΓ' : (1 - s).Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have hre := congrArg Complex.re hm
      simp at hre
      have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      have hpos : 0 < (1 - s).re := by linarith
      nlinarith
  have h := completedZeta_one_sub hs0 hs1 hΓ hΓ'
  rw [hZ] at h
  exact hZ1 h


/-- `Z` has no zeros on the closed half-plane `Re s ≥ 1`, away from the pole
at `s = 1`. -/
theorem completedZeta_ne_zero_of_one_le_re {s : ℂ} (hs : 1 ≤ s.re)
    (hs1 : s ≠ 1) :
    completedZeta s ≠ 0 := by
  intro hZ
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hΓ : s.Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have hre := congrArg Complex.re hm
      simp at hre
      have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      nlinarith
  have hζ : riemannZeta s ≠ 0 := riemannZeta_ne_zero_of_one_le_re hs
  have hΛ : completedRiemannZeta s = 0 := by
    rw [← completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ, hZ]
  have h := riemannZeta_def_of_ne_zero hs0
  rw [hΛ] at h
  simp at h
  exact hζ h


/-- No zeros on the imaginary axis except the pole at `s = 0`. -/
theorem completedZeta_ne_zero_of_re_eq_zero {s : ℂ} (hs : s.re = 0)
    (hs0 : s ≠ 0) :
    completedZeta s ≠ 0 := by
  intro hZ
  have h1s_re : (1 - s).re = 1 := by
    simp [Complex.sub_re, hs]
  have h1s_ne : (1 - s) ≠ 1 := by
    intro h
    apply hs0
    have : s = 1 - 1 := by linear_combination -h
    simpa using this
  have hZ1 : completedZeta (1 - s) ≠ 0 :=
    completedZeta_ne_zero_of_one_le_re (by linarith) h1s_ne
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at hs
    norm_num at hs
  have hΓ : s.Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have hre := congrArg Complex.re hm
      simp at hre
      have hm0 : (m : ℝ) = 0 := by nlinarith
      have hmz : (m : ℂ) = 0 := by exact_mod_cast hm0
      rw [hmz] at hm
      have : s = 0 := by linear_combination 2 * hm
      exact hs0 this
  have hΓ' : (1 - s).Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have hre := congrArg Complex.re hm
      simp at hre
      have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      have hpos : 0 < (1 - s).re := by linarith
      nlinarith
  have h := completedZeta_one_sub hs0 hs1 hΓ hΓ'
  rw [hZ] at h
  exact hZ1 h


/-- **Nontrivial zeros lie in the open critical strip.**  If `Z(s) = 0`, `s` is
not `0`, `1`, or a trivial zero, then `0 < re s < 1`. -/
theorem completedZeta_zero_re_open_strip {s : ℂ} (hz : completedZeta s = 0)
    (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hnt : ∀ n : ℕ, s ≠ -(2 * (n + 1) : ℂ)) :
    0 < s.re ∧ s.re < 1 := by
  constructor
  · by_contra h
    simp only [not_lt] at h
    rcases lt_or_eq_of_le h with hlt | heq
    · exact completedZeta_ne_zero_of_re_lt_zero_of_not_trivial hlt hnt hz
    · exact completedZeta_ne_zero_of_re_eq_zero heq hs0 hz
  · by_contra h
    simp only [not_lt] at h
    rcases lt_or_eq_of_le h with hlt | heq
    · exact completedZeta_ne_zero_of_one_lt_re hlt hz
    · exact completedZeta_ne_zero_of_one_le_re (le_of_eq heq) hs1 hz


/-- **The Riemann Hypothesis**, stated for the completed zeta: every zero in
the critical strip has real part `1/2`.  This is the exact target; it is not
proved. -/
def RiemannHypothesis : Prop :=
  ∀ s : ℂ, completedZeta s = 0 → 0 < s.re → s.re < 1 → s.re = 1 / 2

/-- The `ζ`-form and the completed-zeta form of the Riemann Hypothesis agree
in the critical strip. -/
theorem riemannHypothesis_iff_zeta :
    RiemannHypothesis ↔
      ∀ s : ℂ, riemannZeta s = 0 → 0 < s.re → s.re < 1 → s.re = 1 / 2 := by
  constructor
  · intro h s hz h0 h1
    have hs0 : s ≠ 0 := by
      intro hh
      rw [hh] at h0
      simp at h0
    have hs1 : s ≠ 1 := by
      intro hh
      rw [hh] at h1
      norm_num at h1
    have hΓ : s.Gammaℝ ≠ 0 := by
      rw [Complex.Gammaℝ_def]
      apply mul_ne_zero
      · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
        exact Complex.exp_ne_zero _
      · apply Complex.Gamma_ne_zero
        intro m hm
        have hre := congrArg Complex.re hm
        simp at hre
        have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
        nlinarith
    have hΛ : completedRiemannZeta s = 0 := by
      have hh := riemannZeta_def_of_ne_zero hs0
      rw [hz] at hh
      rcases (div_eq_zero_iff.mp hh.symm) with hZ | hG
      · exact hZ
      · exact absurd hG hΓ
    have hZ : completedZeta s = 0 := by
      rw [completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ, hΛ]
    exact h s hZ h0 h1
  · intro h s hZ h0 h1
    have hs0 : s ≠ 0 := by
      intro hh
      rw [hh] at h0
      simp at h0
    have hs1 : s ≠ 1 := by
      intro hh
      rw [hh] at h1
      norm_num at h1
    have hΓ : s.Gammaℝ ≠ 0 := by
      rw [Complex.Gammaℝ_def]
      apply mul_ne_zero
      · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
        exact Complex.exp_ne_zero _
      · apply Complex.Gamma_ne_zero
        intro m hm
        have hre := congrArg Complex.re hm
        simp at hre
        have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
        nlinarith
    have hζ : riemannZeta s = 0 := by
      rw [riemannZeta_def_of_ne_zero hs0,
        ← completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ, hZ]
      simp
    exact h s hζ h0 h1


/-- The trivial zeros of the completed zeta: `Z(-2(n+1)) = 0`.

**Caveat.** This holds because Mathlib defines `Gamma` at nonpositive
integers as `0` (a junk value), so the product `Γ(s/2) ζ(s)` is `0` there. It
does **not** assert that the meromorphic continuation of
`Z(s) = π^{-s/2} Γ(s/2) ζ(s)` vanishes at `-2(n+1)`; at those points the
Gamma pole and the zeta zero cancel, and the identities used elsewhere are
proven away from `0, 1` and the Gamma poles. -/
theorem completedZeta_trivial_zero (n : ℕ) :
    completedZeta (-(2 * ((n + 1 : ℕ) : ℂ))) = 0 := by
  unfold completedZeta
  have harg : -(2 * ((n + 1 : ℕ) : ℂ)) / 2 = -(((n + 1 : ℕ)) : ℂ) := by
    push_cast
    ring
  rw [harg, Complex.Gamma_neg_nat_eq_zero]
  simp


/-- **The critical-line form of RH**: every zero of `Z` in the strip lies on
the line `1/2 + iℝ`. -/
theorem riemannHypothesis_iff_critical_line :
    RiemannHypothesis ↔
      ∀ s : ℂ, completedZeta s = 0 → 0 < s.re → s.re < 1 →
        ∃ t : ℝ, s = 1 / 2 + Complex.I * (t : ℂ) := by
  constructor
  · intro h s hz h0 h1
    refine ⟨s.im, ?_⟩
    apply Complex.ext
    · simp [h s hz h0 h1]
    · simp
  · intro h s hz h0 h1
    rcases h s hz h0 h1 with ⟨t, rfl⟩
    simp


/-- In the critical strip, `Z` and `ζ` have the same zeros. -/
theorem completedZeta_eq_zero_iff_zeta {s : ℂ} (h0 : 0 < s.re) (h1 : s.re < 1) :
    completedZeta s = 0 ↔ riemannZeta s = 0 := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at h0
    simp at h0
  have hs1 : s ≠ 1 := by
    intro h
    rw [h] at h1
    norm_num at h1
  have hΓ : s.Gammaℝ ≠ 0 := by
    rw [Complex.Gammaℝ_def]
    apply mul_ne_zero
    · rw [Complex.cpow_def, ite_eq_right (by exact_mod_cast Real.pi_ne_zero)]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero
      intro m hm
      have hre := congrArg Complex.re hm
      simp at hre
      have hm0 : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      nlinarith
  constructor
  · intro hZ
    rw [riemannZeta_def_of_ne_zero hs0,
      ← completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ, hZ]
    simp
  · intro hζ
    rw [completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ]
    have h := riemannZeta_def_of_ne_zero hs0
    rw [hζ] at h
    rcases (div_eq_zero_iff.mp h.symm) with hΛ | hG
    · exact hΛ
    · exact absurd hG hΓ


/-- **The symbol identity on the critical line** (away from zeros). -/
theorem symbol_identity_critical_line (t : ℝ)
    (hz : riemannZeta ((1 / 2 : ℂ) + Complex.I * t) ≠ 0) :
    (1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + Complex.I * t) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + Complex.I * t)
      = - logDeriv completedZeta ((1 / 2 : ℂ) + Complex.I * t) := by
  apply symbol_identity_continued
  · intro h
    have hre := congrArg Complex.re h
    norm_num at hre
  · intro m h
    have hre := congrArg Complex.re h
    simp at hre
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    nlinarith
  · exact hz


/-- Conjugation symmetry of the zeta derivative. -/
theorem deriv_riemannZeta_conj {s : ℂ} (hs : s ≠ 1) :
    deriv riemannZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (deriv riemannZeta s) := by
  have h := (differentiableAt_riemannZeta hs).hasDerivAt.conj_conj
  have hfun : ((starRingEnd ℂ) ∘ riemannZeta ∘ (starRingEnd ℂ)) = riemannZeta := by
    funext z
    show (starRingEnd ℂ) (riemannZeta ((starRingEnd ℂ) z)) = riemannZeta z
    rw [riemannZeta_conj]
    simp
  rw [hfun] at h
  exact h.deriv

/-- Conjugation symmetry of the zeta log-derivative. -/
theorem logDeriv_riemannZeta_conj {s : ℂ} (hs : s ≠ 1) :
    logDeriv riemannZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (logDeriv riemannZeta s) := by
  unfold logDeriv
  change deriv riemannZeta ((starRingEnd ℂ) s) / riemannZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (deriv riemannZeta s / riemannZeta s)
  rw [deriv_riemannZeta_conj hs, riemannZeta_conj, map_div₀]



/-- Differentiability of the explicit completed-zeta product. -/
theorem differentiableAt_completedZeta_explicit {s : ℂ} (hs1 : s ≠ 1)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) :
    DifferentiableAt ℂ completedZeta s := by
  unfold completedZeta
  have h1 : DifferentiableAt ℂ
      (fun s : ℂ => cexp (-(s / 2) * log (Real.pi : ℂ))) s := by fun_prop
  have h2 : DifferentiableAt ℂ (fun s : ℂ => Gamma (s / 2)) s :=
    (Complex.differentiableAt_Gamma (s / 2) hg).comp s (by fun_prop)
  have h3 : DifferentiableAt ℂ (fun s : ℂ => riemannZeta s) s :=
    differentiableAt_riemannZeta hs1
  exact (h1.mul h2).mul h3


/-- `Gammaℝ` is differentiable away from its zeros (the nonpositive even
integers). -/
theorem differentiableAt_Gammaℝ {s : ℂ} (hs : s.Gammaℝ ≠ 0) :
    DifferentiableAt ℂ (fun z : ℂ => z.Gammaℝ) s := by
  have hzero : ∀ n : ℕ, s ≠ -(2 * (n : ℂ)) := by
    intro n h
    exact hs (by rw [Complex.Gammaℝ_eq_zero_iff]; exact ⟨n, h⟩)
  have hg : ∀ n : ℕ, s / 2 ≠ -(n : ℂ) := by
    intro n h
    apply hzero n
    linear_combination 2 * h
  have hfun : (fun z : ℂ => z.Gammaℝ)
      = fun z => cexp (-(z / 2) * Complex.log (Real.pi : ℂ)) * Gamma (z / 2) := by
    funext z
    rw [Complex.Gammaℝ_def,
      Complex.cpow_def_of_ne_zero (by exact_mod_cast Real.pi_ne_zero : (Real.pi : ℂ) ≠ 0)]
    congr 1
    ring
  rw [hfun]
  apply DifferentiableAt.mul
  · fun_prop
  · exact (Complex.differentiableAt_Gamma (s / 2) hg).comp s (by fun_prop)

/-- `Gammaℝ` is nonzero on a neighbourhood of any point where it is nonzero. -/
theorem eventually_Gammaℝ_ne_zero {s : ℂ} (hs : s.Gammaℝ ≠ 0) :
    ∀ᶠ z in nhds s, z.Gammaℝ ≠ 0 :=
  (differentiableAt_Gammaℝ hs).continuousAt.tendsto.eventually
    (isOpen_ne.mem_nhds hs)


set_option maxHeartbeats 1000000 in
/-- **Functional-equation anti-symmetry of the completed-zeta log-derivative**:
`(Z'/Z)(1-s) = -(Z'/Z)(s)`. -/
theorem logDeriv_completedZeta_one_sub {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (_hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ))
    (hg' : ∀ m : ℕ, (1 - s) / 2 ≠ -(m : ℂ)) :
    logDeriv completedZeta (1 - s) = - logDeriv completedZeta s := by
  have h1s0 : 1 - s ≠ 0 := by
    intro h
    exact hs1 (by linear_combination -h)
  have h1s1 : 1 - s ≠ 1 := by
    intro h
    exact hs0 (by linear_combination -h)
  have hd : DifferentiableAt ℂ completedZeta (1 - s) :=
    differentiableAt_completedZeta_explicit h1s1 hg'
  have hlin : HasDerivAt (fun z : ℂ => 1 - z) (-1) s := by
    have h := (hasDerivAt_const s (1 : ℂ)).sub (hasDerivAt_id s)
    have hfun : ((fun _ : ℂ => 1) - id) = fun z : ℂ => 1 - z := by
      funext z
      simp
    rw [hfun] at h
    simpa using h
  have hG : HasDerivAt (fun z : ℂ => completedZeta (1 - z))
      (- deriv completedZeta (1 - s)) s := by
    have hcomp := hd.hasDerivAt.comp s hlin
    change HasDerivAt (fun z : ℂ => completedZeta (1 - z))
      (deriv completedZeta (1 - s) * (-1)) s at hcomp
    have hder : deriv completedZeta (1 - s) * (-1)
        = - deriv completedZeta (1 - s) := by ring
    rw [hder] at hcomp
    exact hcomp
  have hcont : Filter.Tendsto (fun z : ℂ => 1 - z) (nhds s) (nhds (1 - s)) := by
    have : Continuous (fun z : ℂ => 1 - z) := by fun_prop
    exact this.continuousAt
  have hΓev : ∀ᶠ z in nhds s, (1 - z).Gammaℝ ≠ 0 :=
    hcont.eventually (eventually_Gammaℝ_ne_zero hΓ')
  have hcongr : (fun z : ℂ => completedZeta (1 - z)) =ᶠ[nhds s] completedZeta := by
    filter_upwards [isOpen_ne.mem_nhds hs0, isOpen_ne.mem_nhds hs1,
      eventually_Gammaℝ_ne_zero hΓ, hΓev] with z hz0 hz1 hzΓ hzΓ'
    exact completedZeta_one_sub hz0 hz1 hzΓ hzΓ'
  have hderiv : deriv completedZeta s = - deriv completedZeta (1 - s) :=
    (hG.congr_of_eventuallyEq hcongr.symm).deriv
  unfold logDeriv
  change deriv completedZeta (1 - s) / completedZeta (1 - s)
      = - (deriv completedZeta s / completedZeta s)
  have hderiv' : deriv completedZeta (1 - s) = - deriv completedZeta s := by
    rw [hderiv]
    ring
  rw [hderiv', completedZeta_one_sub hs0 hs1 hΓ hΓ']
  ring


set_option maxHeartbeats 1000000 in
/-- **Anti-symmetry of the symbol**: `M(1-s) = -M(s)`. -/
theorem symbol_antisymm {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ))
    (hg' : ∀ m : ℕ, (1 - s) / 2 ≠ -(m : ℂ))
    (hz : riemannZeta s ≠ 0) (hz' : riemannZeta (1 - s) ≠ 0) :
    (1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((1 - s) / 2)
        - logDeriv riemannZeta (1 - s)
      = - ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma (s / 2)
        - logDeriv riemannZeta s) := by
  have h1s1 : 1 - s ≠ 1 := by
    intro h
    exact hs0 (by linear_combination -h)
  have hMs := symbol_identity_continued hs1 hg hz
  have hM1s := symbol_identity_continued h1s1 hg' hz'
  have hL := logDeriv_completedZeta_one_sub hs0 hs1 hΓ hΓ' hg hg'
  rw [hM1s, hL, hMs]


/-- Schwarz reflection for the digamma function (local copy). -/
theorem digamma_conj' (s : ℂ) :
    digamma ((starRingEnd ℂ) s) = (starRingEnd ℂ) (digamma s) := by
  have hGamma : Gamma = (starRingEnd ℂ) ∘ Gamma ∘ (starRingEnd ℂ) := by
    funext z
    simp [Complex.Gamma_conj]
  have hd : deriv Gamma ((starRingEnd ℂ) s) =
      (starRingEnd ℂ) (deriv Gamma s) := by
    conv_lhs => rw [hGamma]
    rw [deriv_conj_conj]
    simp [Function.comp_def]
  simp only [Complex.digamma_def, logDeriv_apply, Complex.Gamma_conj, hd]
  rw [map_div₀]

/-- Conjugation symmetry of the symbol (local form). -/
theorem symbol_conj' {s : ℂ} (hs : s ≠ 1) :
    (1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((starRingEnd ℂ) s / 2)
        - logDeriv riemannZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (s / 2) - logDeriv riemannZeta s) := by
  have hlogpi : (starRingEnd ℂ) (log (Real.pi : ℂ)) = log (Real.pi : ℂ) := by
    rw [← Complex.ofReal_log (le_of_lt Real.pi_pos)]
    simp
  have hdig : digamma ((starRingEnd ℂ) s / 2)
      = (starRingEnd ℂ) (digamma (s / 2)) := by
    rw [show (starRingEnd ℂ) s / 2 = (starRingEnd ℂ) (s / 2) by
      rw [map_div₀, show (starRingEnd ℂ) (2 : ℂ) = 2 by
        apply Complex.ext <;> simp]]
    exact digamma_conj' (s / 2)
  rw [hdig, logDeriv_riemannZeta_conj hs, map_sub, map_sub, map_mul, map_mul,
    map_div₀, map_one, map_ofNat, hlogpi]

/-- Critical-line conjugation of the symbol (local form). -/
theorem symbol_conj_critical_line' (t : ℝ) :
    (1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) - Complex.I * t) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) - Complex.I * t)
      = (starRingEnd ℂ) ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + Complex.I * t) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + Complex.I * t)) := by
  have hs : ((1 / 2 : ℂ) + Complex.I * (t : ℂ)) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    norm_num at this
  have h := symbol_conj' (s := ((1 / 2 : ℂ) + Complex.I * (t : ℂ))) hs
  have hconj : (starRingEnd ℂ) ((1 / 2 : ℂ) + Complex.I * (t : ℂ))
      = (1 / 2 : ℂ) - Complex.I * (t : ℂ) := by
    apply Complex.ext <;> simp
  rw [hconj] at h
  exact h


set_option maxHeartbeats 1000000 in
/-- **The symbol is purely imaginary on the critical line**:
`M(1/2 + it) = -conj (M(1/2 + it))`. -/
theorem symbol_critical_line_pure_imaginary (t : ℝ)
    (hΓ : ((1 / 2 : ℂ) + I * (t : ℂ)).Gammaℝ ≠ 0)
    (hΓ' : ((1 / 2 : ℂ) - I * (t : ℂ)).Gammaℝ ≠ 0)
    (hg : ∀ m : ℕ, ((1 / 2 : ℂ) + I * (t : ℂ)) / 2 ≠ -(m : ℂ))
    (hg' : ∀ m : ℕ, ((1 / 2 : ℂ) - I * (t : ℂ)) / 2 ≠ -(m : ℂ))
    (hz : riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 0)
    (hz' : riemannZeta ((1 / 2 : ℂ) - I * (t : ℂ)) ≠ 0) :
    (1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ))
      = - (starRingEnd ℂ) ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ))) := by
  have hs0 : ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    norm_num at this
  have hs1 : ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    norm_num at this
  have h1s : 1 - ((1 / 2 : ℂ) + I * (t : ℂ)) = (1 / 2 : ℂ) - I * (t : ℂ) := by
    ring
  have hΓ'' : (1 - ((1 / 2 : ℂ) + I * (t : ℂ))).Gammaℝ ≠ 0 := by
    rw [h1s]
    exact hΓ'
  have hg'' : ∀ m : ℕ, (1 - ((1 / 2 : ℂ) + I * (t : ℂ))) / 2 ≠ -(m : ℂ) := by
    intro m
    rw [h1s]
    exact hg' m
  have hz'' : riemannZeta (1 - ((1 / 2 : ℂ) + I * (t : ℂ))) ≠ 0 := by
    rw [h1s]
    exact hz'
  have hanti := symbol_antisymm hs0 hs1 hΓ hΓ'' hg hg'' hz hz''
  rw [h1s] at hanti
  have hconj := symbol_conj_critical_line' t
  have h : (starRingEnd ℂ) ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ)))
      = - ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ))) := by
    rw [← hconj, hanti]
  calc (1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ))
      = (starRingEnd ℂ) ((starRingEnd ℂ) ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ)))) := by simp
    _ = (starRingEnd ℂ) (- ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ)))) := by rw [h]
    _ = - (starRingEnd ℂ) ((1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ))) := by simp


/-- **Reality on the critical line**: `Z(1/2 + it)` is real. -/
theorem completedZeta_critical_line_real (t : ℝ) :
    (completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))).im = 0 := by
  have hconj := completedZeta_conj ((1 / 2 : ℂ) + I * (t : ℂ))
  have harg : (starRingEnd ℂ) ((1 / 2 : ℂ) + I * (t : ℂ))
      = (1 / 2 : ℂ) - I * (t : ℂ) := by
    apply Complex.ext <;> simp
  rw [harg] at hconj
  have hsym := completedZeta_critical_line t
  have h := hsym.trans hconj
  have him := congrArg Complex.im h
  simp at him
  linarith


/-- On the critical line, vanishing is a real equation. -/
theorem completedZeta_critical_line_zero_iff_re (t : ℝ) :
    completedZeta ((1 / 2 : ℂ) + I * (t : ℂ)) = 0
      ↔ (completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))).re = 0 := by
  constructor
  · intro h
    rw [h]
    simp
  · intro h
    apply Complex.ext
    · simpa using h
    · simpa using completedZeta_critical_line_real t


/-- **The genuine trivial zeros of zeta**: `ζ(-2m) = 0` for `m ≥ 1`, from
`ζ(-k) = (-1)^k B_{k+1}/(k+1)` and the vanishing of odd Bernoulli numbers. -/
theorem riemannZeta_trivial_zero (m : ℕ) (hm : 1 ≤ m) :
    riemannZeta (-(2 * (m : ℂ))) = 0 := by
  rw [show -(2 * (m : ℂ)) = -(((2 * m : ℕ) : ℂ)) by push_cast; ring]
  rw [riemannZeta_neg_nat_eq_bernoulli]
  have hodd : Odd (2 * m + 1) := ⟨m, by ring⟩
  have hlt : 1 < 2 * m + 1 := by omega
  rw [bernoulli_eq_zero_of_odd hodd hlt]
  simp


/-- **RH as the absence of zeros in the left half of the strip.** -/
theorem riemannHypothesis_iff_no_zeros_left_half :
    RiemannHypothesis ↔
      ∀ s : ℂ, completedZeta s = 0 → 0 < s.re → s.re < 1 / 2 → False := by
  constructor
  · intro h s hz h0 hhalf
    have := h s hz h0 (by linarith)
    linarith
  · intro h s hz h0 h1
    by_contra hne
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · exact h s hz h0 hlt
    · have hs0 : s ≠ 0 := by
        intro hh
        rw [hh] at h0
        simp at h0
      have hs1 : s ≠ 1 := by
        intro hh
        rw [hh] at h1
        norm_num at h1
      have hΓ : s.Gammaℝ ≠ 0 := by
        intro hh
        rw [Complex.Gammaℝ_eq_zero_iff] at hh
        obtain ⟨n, hn⟩ := hh
        have hre : s.re = -(2 * (n : ℝ)) := by
          have := congrArg Complex.re hn
          simpa using this
        have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
        linarith
      have h1s0 : (1 - s) ≠ 0 := by
        intro hh
        apply hs1
        linear_combination -hh
      have h1s1 : (1 - s) ≠ 1 := by
        intro hh
        apply hs0
        linear_combination -hh
      have hΓ' : (1 - s).Gammaℝ ≠ 0 := by
        intro hh
        rw [Complex.Gammaℝ_eq_zero_iff] at hh
        obtain ⟨n, hn⟩ := hh
        have hre : (1 - s).re = -(2 * (n : ℝ)) := by
          have := congrArg Complex.re hn
          simpa using this
        have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
        simp only [Complex.sub_re, Complex.one_re] at hre
        linarith
      have hz' := completedZeta_zero_symm hs0 hs1 hΓ hΓ' hz
      have h0' : 0 < (1 - s).re := by
        simp only [Complex.sub_re, Complex.one_re]
        linarith
      have hhalf' : (1 - s).re < 1 / 2 := by
        simp only [Complex.sub_re, Complex.one_re]
        linarith
      exact h (1 - s) hz' h0' hhalf'


/-- Conjugation symmetry of `Gammaℝ`. -/
theorem Gammaℝ_conj (s : ℂ) :
    Complex.Gammaℝ ((starRingEnd ℂ) s) = (starRingEnd ℂ) (Complex.Gammaℝ s) := by
  rw [Complex.Gammaℝ_def, Complex.Gammaℝ_def, map_mul]
  have harg : (Real.pi : ℂ).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg (le_of_lt Real.pi_pos)]
    exact Ne.symm Real.pi_ne_zero
  congr 1
  · have h := Complex.cpow_conj (x := (Real.pi : ℂ)) (n := (-(s / 2))) harg
    rw [Complex.conj_ofReal] at h
    have h2 : (starRingEnd ℂ) (2 : ℂ) = 2 := by
      apply Complex.ext <;> simp
    have harg2 : (starRingEnd ℂ) (-(s / 2)) = -((starRingEnd ℂ) s) / 2 := by
      rw [map_neg, map_div₀, h2, neg_div]
    rw [harg2] at h
    rw [show (-(s / 2) : ℂ) = -s / 2 by ring] at h
    exact h
  · have h2 : (starRingEnd ℂ) (2 : ℂ) = 2 := by
      apply Complex.ext <;> simp
    simpa [h2] using Complex.Gamma_conj (s / 2)

/-- A zero produces the full conjugation/reflection quadruple. -/
theorem completedZeta_zero_quadruple {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hΓ' : (1 - s).Gammaℝ ≠ 0)
    (hz : completedZeta s = 0) :
    completedZeta (1 - s) = 0 ∧ completedZeta ((starRingEnd ℂ) s) = 0
      ∧ completedZeta (1 - (starRingEnd ℂ) s) = 0 := by
  have h1 := completedZeta_zero_symm hs0 hs1 hΓ hΓ' hz
  have h2 := completedZeta_zero_conj hz
  have h3 : completedZeta (1 - (starRingEnd ℂ) s) = 0 := by
    have harg : 1 - (starRingEnd ℂ) s = (starRingEnd ℂ) (1 - s) := by
      rw [map_sub, map_one]
    rw [harg]
    exact completedZeta_zero_conj h1
  exact ⟨h1, h2, h3⟩


/-- Conjugation symmetry of the completed-zeta log-derivative. -/
theorem logDeriv_completedZeta_conj {s : ℂ} (_hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ)) :
    logDeriv completedZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (logDeriv completedZeta s) := by
  have h1s1 : (starRingEnd ℂ) s ≠ 1 := by
    intro h
    apply hs1
    have := congrArg (starRingEnd ℂ) h
    simpa using this
  have hg' : ∀ m : ℕ, (starRingEnd ℂ) s / 2 ≠ -(m : ℂ) := by
    intro m h
    apply hg m
    have := congrArg (starRingEnd ℂ) h
    have h2 : (starRingEnd ℂ) (2 : ℂ) = 2 := by
      apply Complex.ext <;> simp
    simpa [h2] using this
  have hd : DifferentiableAt ℂ completedZeta ((starRingEnd ℂ) s) :=
    differentiableAt_completedZeta_explicit h1s1 hg'
  have h := hd.hasDerivAt.conj_conj
  have hfun : ((starRingEnd ℂ) ∘ completedZeta ∘ (starRingEnd ℂ)) = completedZeta := by
    funext z
    show (starRingEnd ℂ) (completedZeta ((starRingEnd ℂ) z)) = completedZeta z
    rw [completedZeta_conj]
    simp
  rw [hfun] at h
  have hderiv : deriv completedZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (deriv completedZeta s) := by
    have := congrArg (starRingEnd ℂ) h.deriv
    simpa using this.symm
  unfold logDeriv
  change deriv completedZeta ((starRingEnd ℂ) s) / completedZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (deriv completedZeta s / completedZeta s)
  rw [hderiv, completedZeta_conj, map_div₀]


/-- **The completed-zeta log-derivative is purely imaginary on the critical
line**: `Re ((Z'/Z)(1/2+it)) = 0`. -/
theorem logDeriv_completedZeta_critical_line_imaginary {t : ℝ}
    (hs0 : ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 0)
    (hs1 : ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 1)
    (hΓ : ((1 / 2 : ℂ) + I * (t : ℂ)).Gammaℝ ≠ 0)
    (hΓ' : ((1 / 2 : ℂ) - I * (t : ℂ)).Gammaℝ ≠ 0)
    (hg : ∀ m : ℕ, ((1 / 2 : ℂ) + I * (t : ℂ)) / 2 ≠ -(m : ℂ))
    (hg' : ∀ m : ℕ, ((1 / 2 : ℂ) - I * (t : ℂ)) / 2 ≠ -(m : ℂ)) :
    (logDeriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))).re = 0 := by
  have h1s : 1 - ((1 / 2 : ℂ) + I * (t : ℂ)) = (1 / 2 : ℂ) - I * (t : ℂ) := by
    ring
  have hΓ'' : (1 - ((1 / 2 : ℂ) + I * (t : ℂ))).Gammaℝ ≠ 0 := by
    rw [h1s]
    exact hΓ'
  have hg'' : ∀ m : ℕ, (1 - ((1 / 2 : ℂ) + I * (t : ℂ))) / 2 ≠ -(m : ℂ) := by
    intro m
    rw [h1s]
    exact hg' m
  have hL1 := logDeriv_completedZeta_one_sub hs0 hs1 hΓ hΓ'' hg hg''
  rw [h1s] at hL1
  have hL2 := logDeriv_completedZeta_conj (s := ((1 / 2 : ℂ) + I * (t : ℂ))) hs0 hs1 hg
  have hconj_arg : (starRingEnd ℂ) ((1 / 2 : ℂ) + I * (t : ℂ))
      = (1 / 2 : ℂ) - I * (t : ℂ) := by
    apply Complex.ext <;> simp
  rw [hconj_arg] at hL2
  have h : (starRingEnd ℂ) (logDeriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ)))
      = - logDeriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ)) := by
    rw [← hL2, hL1]
  have h2 : logDeriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))
      = - (starRingEnd ℂ) (logDeriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))) := by
    have := congrArg (starRingEnd ℂ) h
    simpa using this
  have him := congrArg Complex.re h2
  simp at him
  linarith


/-- **The critical-line explicit form**: on the line, the symbol equals minus
the completed-zeta log-derivative. -/
theorem symbol_critical_line_eq_neg_logDeriv (t : ℝ)
    (hg : ∀ m : ℕ, ((1 / 2 : ℂ) + I * (t : ℂ)) / 2 ≠ -(m : ℂ))
    (hζ : riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 0) :
    (1 / 2) * log (Real.pi : ℂ)
        - (1 / 2) * digamma (((1 / 2 : ℂ) + I * (t : ℂ)) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + I * (t : ℂ))
      = - logDeriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ)) := by
  apply symbol_identity_continued (s := ((1 / 2 : ℂ) + I * (t : ℂ)))
  · intro h
    have := congrArg Complex.re h
    norm_num at this
  · exact hg
  · exact hζ



/-- A finite sum paired by conjugation is real. -/
theorem finset_sum_real_of_conj {ι : Type*} (s : Finset ι) (f : ι → ℂ) (σ : ι → ι)
    (hσ : ∀ i ∈ s, σ i ∈ s) (hinv : ∀ i ∈ s, σ (σ i) = i)
    (hpair : ∀ i ∈ s, f (σ i) = (starRingEnd ℂ) (f i)) :
    ((∑ i ∈ s, f i)).im = 0 := by
  have hreindex : ∑ i ∈ s, f (σ i) = ∑ i ∈ s, f i := by
    refine Finset.sum_bij (fun i _ => σ i) ?_ ?_ ?_ ?_
    · exact fun i hi => hσ i hi
    · intro a ha b hb hab
      have := congrArg σ hab
      rw [hinv a ha, hinv b hb] at this
      exact this
    · intro b hb
      exact ⟨σ b, hσ b hb, hinv b hb⟩
    · intro a _
      rfl
  have hconj : (starRingEnd ℂ) (∑ i ∈ s, f i) = ∑ i ∈ s, f i := by
    have h1 : ∀ i ∈ s, (starRingEnd ℂ) (f i) = f (σ i) := by
      intro i hi
      rw [hpair i hi]
    calc (starRingEnd ℂ) (∑ i ∈ s, f i)
        = ∑ i ∈ s, (starRingEnd ℂ) (f i) := by rw [map_sum]
      _ = ∑ i ∈ s, f (σ i) := Finset.sum_congr rfl h1
      _ = ∑ i ∈ s, f i := hreindex
  have him := congrArg Complex.im hconj
  simp at him
  have him2 : (∑ i ∈ s, f i).im = ∑ i ∈ s, (f i).im := by simp
  have hT : ∑ i ∈ s, (f i).im = 0 := by linarith
  rw [him2, hT]


/-- **A finite zero sum is real** when the zero set is stable under conjugation
and the test function satisfies `h(conj ρ) = conj(h ρ)`. -/
theorem zero_sum_real_of_finite {h : ℂ → ℂ} {S : Finset ℂ}
    (hS : ∀ ρ ∈ S, (starRingEnd ℂ) ρ ∈ S)
    (hpair : ∀ ρ ∈ S, h ((starRingEnd ℂ) ρ) = (starRingEnd ℂ) (h ρ)) :
    ((∑ ρ ∈ S, h ρ)).im = 0 := by
  apply finset_sum_real_of_conj S h (starRingEnd ℂ)
  · exact hS
  · intro ρ _
    simp
  · exact hpair


/-- **The pole residue**: the completed zeta has residue `1` at `s = 1`, the
pole term of the explicit formula. -/
theorem completedZeta_residue_one :
    Filter.Tendsto (fun s : ℂ => (s - 1) * completedZeta s)
      (nhdsWithin 1 {1}ᶜ) (nhds 1) := by
  have hfun : ∀ s : ℂ, (s - 1) * completedZeta s
      = cexp (-(s / 2) * log (Real.pi : ℂ)) * Complex.Gamma (s / 2)
        * ((s - 1) * riemannZeta s) := by
    intro s
    unfold completedZeta
    ring
  have h1 : Filter.Tendsto (fun s : ℂ => cexp (-(s / 2) * log (Real.pi : ℂ)))
      (nhdsWithin 1 {1}ᶜ) (nhds (cexp (-((1 : ℂ) / 2) * log (Real.pi : ℂ)))) := by
    have hc : ContinuousAt (fun s : ℂ => cexp (-(s / 2) * log (Real.pi : ℂ))) (1 : ℂ) := by
      fun_prop
    exact hc.tendsto.comp nhdsWithin_le_nhds
  have h2 : Filter.Tendsto (fun s : ℂ => Complex.Gamma (s / 2))
      (nhdsWithin 1 {1}ᶜ) (nhds (Complex.Gamma (1 / 2))) := by
    have hc : ContinuousAt Complex.Gamma ((1 : ℂ) / 2) := by
      apply Complex.continuousAt_Gamma
      intro m h
      have hre := congrArg Complex.re h
      norm_num at hre
      have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      linarith
    have hlin : Filter.Tendsto (fun s : ℂ => s / 2) (nhdsWithin 1 {1}ᶜ)
        (nhds ((1 : ℂ) / 2)) := by
      have : ContinuousAt (fun s : ℂ => s / 2) (1 : ℂ) := by fun_prop
      exact this.tendsto.comp nhdsWithin_le_nhds
    exact hc.tendsto.comp hlin
  have hprod := (h1.mul h2).mul riemannZeta_residue_one
  have hpi : (Real.pi : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  have hval : cexp (-((1 : ℂ) / 2) * log (Real.pi : ℂ))
      * Complex.Gamma (1 / 2) * 1 = 1 := by
    rw [Complex.Gamma_one_half_eq, Complex.cpow_def_of_ne_zero hpi]
    rw [← Complex.exp_add]
    ring_nf
    simp
  rw [hval] at hprod
  refine hprod.congr' ?_
  filter_upwards with s
  exact (hfun s).symm


/-- **Pole reflection.**  If `(u-1) f u → 1` as `u → 1`, then the reflected
function satisfies `s f (1-s) → -1` as `s → 0`.  This transfers the residue at
`s = 1` to the pole at `s = 0`. -/
theorem tendsto_smul_comp_one_sub {f : ℂ → ℂ}
    (h : Filter.Tendsto (fun u : ℂ => (u - 1) * f u)
      (nhdsWithin 1 {1}ᶜ) (nhds 1)) :
    Filter.Tendsto (fun s : ℂ => s * f (1 - s))
      (nhdsWithin 0 {0}ᶜ) (nhds (-1)) := by
  have hmap : Filter.Tendsto (fun s : ℂ => 1 - s)
      (nhdsWithin 0 {0}ᶜ) (nhdsWithin 1 {1}ᶜ) := by
    rw [tendsto_nhdsWithin_iff]
    refine ⟨?_, ?_⟩
    · have hc : ContinuousAt (fun s : ℂ => 1 - s) (0 : ℂ) := by fun_prop
      have hmono := hc.tendsto.mono_left
        (nhdsWithin_le_nhds (a := (0 : ℂ)) (s := ({0}ᶜ : Set ℂ)))
      simpa using hmono
    · have hmem : ({s : ℂ | 1 - s ≠ 1}) ∈ nhdsWithin 0 {0}ᶜ := by
        apply Filter.mem_of_superset
          (show ({0}ᶜ : Set ℂ) ∈ nhdsWithin 0 {0}ᶜ from
            Filter.mem_inf_iff.mpr
              ⟨Set.univ, Filter.univ_mem, {0}ᶜ, by simp, by ext; simp⟩)
        intro s hs h1
        have hs' : s ≠ 0 := fun h => hs (by simp [h])
        exact hs' (by linear_combination -h1)
      filter_upwards [hmem] with s hs
      simpa using hs
  have hcomp := h.comp hmap
  have hneg := hcomp.neg
  refine hneg.congr' ?_
  filter_upwards with s
  simp only [Function.comp_apply]
  ring


/-- The punctured neighbourhood `{a}ᶜ` is a member of `nhdsWithin a {a}ᶜ`. -/
theorem compl_singleton_mem_nhdsWithin (a : ℂ) :
    ({a}ᶜ : Set ℂ) ∈ nhdsWithin a {a}ᶜ :=
  Filter.mem_inf_iff.mpr ⟨Set.univ, Filter.univ_mem, {a}ᶜ, by simp, by ext; simp⟩

theorem eventually_GammaR_ne_zero_near_zero :
    ∀ᶠ s : ℂ in nhdsWithin 0 {0}ᶜ, s.Gammaℝ ≠ 0 := by
  have hball : ∀ᶠ s : ℂ in nhds 0, ‖s‖ < 1 := by
    have h := Metric.ball_mem_nhds (0 : ℂ) (by norm_num : (0 : ℝ) < 1)
    filter_upwards [h] with s hs
    simpa [Metric.mem_ball, dist_eq_norm] using hs
  filter_upwards [hball.filter_mono nhdsWithin_le_nhds,
    compl_singleton_mem_nhdsWithin 0] with s hs hs0
  have hs' : ‖s‖ < 1 := hs
  intro hzero
  rw [Complex.Gammaℝ_eq_zero_iff] at hzero
  obtain ⟨n, hn⟩ := hzero
  cases n with
  | zero =>
      have hseq : s = 0 := by simpa using hn
      have hs0' : s ≠ 0 := fun h => hs0 (by simpa [h])
      exact hs0' hseq
  | succ k =>
      have hge : (2 : ℝ) ≤ ‖s‖ := by
        rw [hn, norm_neg, norm_mul]
        have hk : (1 : ℝ) ≤ ‖((k + 1 : ℕ) : ℂ)‖ := by
          have hcast : ‖((k + 1 : ℕ) : ℂ)‖ = ((k + 1 : ℕ) : ℝ) := by
            simp only [Complex.norm_natCast]
          rw [hcast]
          exact_mod_cast Nat.succ_le_succ (Nat.zero_le k)
        have h2 : ‖(2 : ℂ)‖ = 2 := by norm_num
        rw [h2]
        nlinarith
      linarith

theorem eventually_GammaR_one_sub_ne_zero_near_zero :
    ∀ᶠ s : ℂ in nhdsWithin 0 {0}ᶜ, (1 - s).Gammaℝ ≠ 0 := by
  have hball : ∀ᶠ s : ℂ in nhds 0, ‖s‖ < 1 / 2 := by
    have h := Metric.ball_mem_nhds (0 : ℂ) (by norm_num : (0 : ℝ) < 1 / 2)
    filter_upwards [h] with s hs
    simpa [Metric.mem_ball, dist_eq_norm] using hs
  filter_upwards [hball.filter_mono nhdsWithin_le_nhds] with s hs
  have hs' : ‖s‖ < 1 / 2 := hs
  intro hzero
  rw [Complex.Gammaℝ_eq_zero_iff] at hzero
  obtain ⟨n, hn⟩ := hzero
  have hre : (1 - s).re = -(2 * (n : ℝ)) := by
    have := congrArg Complex.re hn
    simpa using this
  have hrepos : (1 - s).re > 1 / 2 := by
    have habs := abs_le.mp (Complex.abs_re_le_norm s)
    simp only [Complex.sub_re, Complex.one_re]
    linarith [habs.1]
  have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  linarith

theorem eventually_ne_one_near_zero :
    ∀ᶠ s : ℂ in nhdsWithin 0 {0}ᶜ, s ≠ 1 := by
  have hball : ∀ᶠ s : ℂ in nhds 0, ‖s‖ < 1 / 2 := by
    have h := Metric.ball_mem_nhds (0 : ℂ) (by norm_num : (0 : ℝ) < 1 / 2)
    filter_upwards [h] with s hs
    simpa [Metric.mem_ball, dist_eq_norm] using hs
  filter_upwards [hball.filter_mono nhdsWithin_le_nhds] with s hs
  have hs' : ‖s‖ < 1 / 2 := hs
  intro h
  rw [h] at hs'
  norm_num at hs'

/-- **The pole at `s = 0`**: the completed zeta has residue `-1` there. -/
theorem completedZeta_residue_zero :
    Filter.Tendsto (fun s : ℂ => s * completedZeta s)
      (nhdsWithin 0 {0}ᶜ) (nhds (-1)) := by
  have hrefl := tendsto_smul_comp_one_sub completedZeta_residue_one
  refine hrefl.congr' ?_
  filter_upwards [eventually_ne_one_near_zero, eventually_GammaR_ne_zero_near_zero,
    eventually_GammaR_one_sub_ne_zero_near_zero,
    compl_singleton_mem_nhdsWithin 0] with s hs1 hΓ hΓ1 hs0
  have hs0' : s ≠ 0 := fun h => hs0 (by simpa [h])
  have hsym := completedZeta_one_sub hs0' hs1 hΓ hΓ1
  rw [hsym]


open scoped ComplexOrder

/-- **Positivity on the real axis**: `Z(x) > 0` for `x > 1`. -/
theorem completedZeta_ofReal_pos {x : ℝ} (hx : 1 < x) :
    0 < completedZeta (x : ℂ) := by
  rw [Complex.pos_iff]
  constructor
  · unfold completedZeta
    have hlog : log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) :=
      (Complex.ofReal_log (le_of_lt Real.pi_pos)).symm
    have hcexp : cexp (-((x : ℂ) / 2) * log (Real.pi : ℂ))
        = ((Real.exp (-(x / 2) * Real.log Real.pi) : ℝ) : ℂ) := by
      rw [hlog]
      rw [show -((x : ℂ) / 2) * ((Real.log Real.pi : ℝ) : ℂ)
          = ((-(x / 2) * Real.log Real.pi : ℝ) : ℂ) by
        push_cast
        ring]
      exact (Complex.ofReal_exp _).symm
    have hGamma : Complex.Gamma ((x : ℂ) / 2)
        = ((Real.Gamma (x / 2) : ℝ) : ℂ) := by
      rw [show (x : ℂ) / 2 = ((x / 2 : ℝ) : ℂ) by push_cast; ring]
      exact Complex.Gamma_ofReal (x / 2)
    have hζ := Complex.pos_iff.mp (riemannZeta_pos_of_one_lt hx)
    rw [hcexp, hGamma]
    have h1 : (0 : ℝ) < Real.exp (-(x / 2) * Real.log Real.pi) := Real.exp_pos _
    have h2 : (0 : ℝ) < Real.Gamma (x / 2) := Real.Gamma_pos_of_pos (by linarith)
    have himζ : (riemannZeta (x : ℂ)).im = 0 := hζ.2.symm
    simp only [Complex.ofReal_re, Complex.ofReal_im, Complex.mul_re, Complex.mul_im,
      mul_zero, add_zero, zero_mul, sub_zero, himζ]
    exact mul_pos (mul_pos h1 h2) hζ.1
  · exact (completedZeta_ofReal_im_zero x).symm


/-- **A real-valued differentiable function has a real derivative**: if
`f : ℝ → ℂ` is real-valued and `HasDerivAt f f' t`, then `f'.im = 0`. -/
theorem HasDerivAt.im_eq_zero {f : ℝ → ℂ} {f' : ℂ} {t : ℝ}
    (hf : HasDerivAt f f' t) (him : ∀ s, (f s).im = 0) : f'.im = 0 := by
  have hf' : HasFDerivAt f (ContinuousLinearMap.toSpanSingleton ℝ f') t :=
    hf.hasFDerivAt
  have hcomp : HasFDerivAt (fun s => (f s).im)
      (Complex.imCLM.comp (ContinuousLinearMap.toSpanSingleton ℝ f')) t :=
    (Complex.imCLM.hasFDerivAt (x := f t)).comp t hf'
  have hderiv : HasDerivAt (fun s => (f s).im) (Complex.imCLM f') t := by
    have := hcomp.hasDerivAt
    simpa [ContinuousLinearMap.comp_apply, ContinuousLinearMap.toSpanSingleton_apply,
      Function.comp_def] using this
  have hconst : HasDerivAt (fun s => (f s).im) 0 t := by
    have hfun : (fun s => (f s).im) = fun _ => (0 : ℝ) := funext him
    rw [hfun]
    exact hasDerivAt_const t 0
  have hzero := hderiv.unique hconst
  simpa using hzero

/-- **The derivative of the completed zeta on the critical line is purely
imaginary**: `Re Z'(1/2+it) = 0`. -/
theorem deriv_completedZeta_critical_line_imaginary {t : ℝ}
    (h1 : ((1 / 2 : ℂ) + I * (t : ℂ)) ≠ 1)
    (hg : ∀ m : ℕ, ((1 / 2 : ℂ) + I * (t : ℂ)) / 2 ≠ -(m : ℂ)) :
    (deriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))).re = 0 := by
  have hd : DifferentiableAt ℂ completedZeta ((1 / 2 : ℂ) + I * (t : ℂ)) :=
    differentiableAt_completedZeta_explicit h1 hg
  have hs : HasDerivAt (fun t : ℝ => (1 / 2 : ℂ) + I * (t : ℂ)) I t := by
    have hd : DifferentiableAt ℝ (fun t : ℝ => (1 / 2 : ℂ) + I * (t : ℂ)) t := by
      fun_prop
    have h := hd.hasDerivAt
    have hderiv : deriv (fun t : ℝ => (1 / 2 : ℂ) + I * (t : ℂ)) t = I := by
      have hof : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 t := Complex.ofRealCLM.hasDerivAt
      have hlin : HasDerivAt (fun y : ℝ => I * (y : ℂ)) I t := by
        have h := hof.const_mul (I : ℂ)
        simpa using h
      have hconst : HasDerivAt (fun _ : ℝ => (1 / 2 : ℂ)) 0 t :=
        hasDerivAt_const t (1 / 2 : ℂ)
      have hsum := hconst.add hlin
      have hfun : ((fun _ : ℝ => (1 / 2 : ℂ)) + fun y : ℝ => I * (y : ℂ))
          = fun y : ℝ => (1 / 2 : ℂ) + I * (y : ℂ) := by
        funext y
        simp
      rw [hfun] at hsum
      simpa using hsum.deriv
    rwa [hderiv] at h
  have hz : HasDerivAt completedZeta
      (deriv completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))) ((1 / 2 : ℂ) + I * (t : ℂ)) :=
    hd.hasDerivAt
  have hcomp := hz.comp t hs
  have him : ∀ t : ℝ, (completedZeta ((1 / 2 : ℂ) + I * (t : ℂ))).im = 0 :=
    completedZeta_critical_line_real
  have h := HasDerivAt.im_eq_zero hcomp him
  simpa [Complex.mul_im] using h


/-- **Base case of the argument principle**: the logarithmic derivative of a
single linear factor has winding number `1` around a circle enclosing its
zero.  This is Cauchy's integral formula applied to the constant function
`1`. -/
theorem circleIntegral_sub_inv_linear (c w : ℂ) (R : ℝ) (hw : w ∈ Metric.ball c R) :
    (2 * (Real.pi : ℂ) * Complex.I)⁻¹ * ∮ (z : ℂ) in C(c, R), (z - w)⁻¹ = 1 := by
  have h := Complex.two_pi_I_inv_smul_circleIntegral_sub_inv_smul_of_differentiable_on_off_countable
    (E := ℂ) (f := fun _ : ℂ => (1 : ℂ)) (s := ∅) (by simp) hw
    continuous_const.continuousOn
    (by intro x _; exact differentiableAt_const (1 : ℂ))
  simpa using h


/-- **The outside-zero case**: if `w` lies strictly outside the closed disk,
the logarithmic derivative of `z - w` has zero contour integral around the
circle.  This is Cauchy's theorem applied to `1/(z-w)`. -/
theorem circleIntegral_sub_inv_eq_zero (c w : ℂ) (R : ℝ) (hR : 0 ≤ R)
    (hw : w ∉ Metric.closedBall c R) :
    ∮ (z : ℂ) in C(c, R), (z - w)⁻¹ = 0 := by
  have hne : ∀ z ∈ Metric.closedBall c R, z - w ≠ 0 := by
    intro z hz h
    apply hw
    have : z = w := sub_eq_zero.mp h
    rwa [this] at hz
  apply Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable
    (R := R) (s := (∅ : Set ℂ)) (h0 := hR) (hs := by simp)
  · have hcont : ContinuousOn (fun z : ℂ => z - w) (Metric.closedBall c R) := by
      fun_prop
    exact hcont.inv₀ (fun z hz => hne z hz)
  · intro z hz
    have hd : DifferentiableAt ℂ (fun z : ℂ => z - w) z := by fun_prop
    exact hd.inv (hne z (Metric.ball_subset_closedBall (by simpa [Metric.mem_ball] using hz)))


/-- **Linearity of the circle integral** for finite sums. -/
theorem circleIntegral_finset_sum {ι : Type*} (s : Finset ι) {f : ι → ℂ → ℂ}
    (hf : ∀ i ∈ s, Continuous (f i)) (c : ℂ) (R : ℝ) :
    ∮ z in C(c, R), (∑ i ∈ s, f i z) = ∑ i ∈ s, ∮ z in C(c, R), f i z := by
  unfold circleIntegral
  have hcont : ∀ i ∈ s,
      Continuous (fun θ : ℝ => deriv (circleMap c R) θ • f i (circleMap c R θ)) := by
    intro i hi
    have hfun : (fun θ : ℝ => deriv (circleMap c R) θ • f i (circleMap c R θ))
        = fun θ : ℝ => (circleMap 0 R θ * Complex.I) • f i (circleMap c R θ) := by
      funext θ
      rw [deriv_circleMap]
    rw [hfun]
    exact ((continuous_circleMap 0 R).mul continuous_const).smul
      ((hf i hi).comp (continuous_circleMap c R))
  rw [show (fun θ : ℝ => deriv (circleMap c R) θ • (∑ i ∈ s, f i (circleMap c R θ)))
      = fun θ : ℝ => ∑ i ∈ s, deriv (circleMap c R) θ • f i (circleMap c R θ) by
    funext θ
    rw [Finset.smul_sum]]
  exact intervalIntegral.integral_finset_sum
    (fun i hi => (hcont i hi).intervalIntegrable 0 (2 * Real.pi))


/-- The logarithmic derivative of a linear factor: `(z - w)'/(z - w) = 1/(z - w)`. -/
theorem logDeriv_sub_const (w z : ℂ) (hz : z ≠ w) :
    logDeriv (fun y : ℂ => y - w) z = (z - w)⁻¹ := by
  rw [logDeriv_apply]
  have h : HasDerivAt (fun y : ℂ => y - w) 1 z := by
    have := (hasDerivAt_id z).sub_const (w : ℂ)
    simpa using this
  rw [h.deriv, one_div]


/-- **Linearity of the circle integral** for finite sums, with continuity only
on the circle (enough since `circleMap` maps into the sphere). -/
theorem circleIntegral_finset_sum_of_continuousOn {ι : Type*} (s : Finset ι)
    {f : ι → ℂ → ℂ} (c : ℂ) (R : ℝ) (hR : 0 ≤ R)
    (hf : ∀ i ∈ s, ContinuousOn (f i) (Metric.sphere c R)) :
    ∮ z in C(c, R), (∑ i ∈ s, f i z) = ∑ i ∈ s, ∮ z in C(c, R), f i z := by
  unfold circleIntegral
  have hcont : ∀ i ∈ s,
      Continuous (fun θ : ℝ => deriv (circleMap c R) θ • f i (circleMap c R θ)) := by
    intro i hi
    have hfun : (fun θ : ℝ => deriv (circleMap c R) θ • f i (circleMap c R θ))
        = fun θ : ℝ => (circleMap 0 R θ * Complex.I) • f i (circleMap c R θ) := by
      funext θ
      rw [deriv_circleMap]
    rw [hfun]
    exact ((continuous_circleMap 0 R).mul continuous_const).smul
      ((hf i hi).comp_continuous (continuous_circleMap c R)
        (fun θ => circleMap_mem_sphere c hR θ))
  rw [show (fun θ : ℝ => deriv (circleMap c R) θ • (∑ i ∈ s, f i (circleMap c R θ)))
      = fun θ : ℝ => ∑ i ∈ s, deriv (circleMap c R) θ • f i (circleMap c R θ) by
    funext θ
    rw [Finset.smul_sum]]
  exact intervalIntegral.integral_finset_sum
    (fun i hi => (hcont i hi).intervalIntegrable 0 (2 * Real.pi))



/-- The circle integral depends only on the values on the circle. -/
theorem circleIntegral_congr {f g : ℂ → ℂ} (c : ℂ) (R : ℝ) (hR : 0 ≤ R)
    (h : ∀ z ∈ Metric.sphere c R, f z = g z) :
    ∮ z in C(c, R), f z = ∮ z in C(c, R), g z := by
  unfold circleIntegral
  apply intervalIntegral.integral_congr
  intro θ _
  change deriv (circleMap c R) θ • f (circleMap c R θ)
      = deriv (circleMap c R) θ • g (circleMap c R θ)
  rw [h (circleMap c R θ) (circleMap_mem_sphere c hR θ)]


open Classical

/-- **The argument-principle count.**  For a finite set `S` of roots, each
strictly inside or strictly outside the circle, the logarithmic derivative of
`∏(z - w)` has contour integral `2πi` times the number of roots inside. -/
theorem circleIntegral_logDeriv_prod (c : ℂ) (R : ℝ) (S : Finset ℂ)
    (hR : 0 ≤ R)
    (hSep : ∀ w ∈ S, w ∈ Metric.ball c R ∨ w ∉ Metric.closedBall c R) :
    (2 * (Real.pi : ℂ) * Complex.I)⁻¹
        * ∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
      = ((S.filter (fun w => w ∈ Metric.ball c R)).card : ℂ) := by
  have hsphere : ∀ w ∈ S, w ∉ Metric.sphere c R := by
    intro w hw
    rcases hSep w hw with hb | ho
    · intro hs
      rw [Metric.mem_sphere] at hs
      rw [Metric.mem_ball] at hb
      linarith
    · exact fun hs => ho (Metric.sphere_subset_closedBall hs)
  have hcongr : ∀ z ∈ Metric.sphere c R,
      logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z = ∑ w ∈ S, (z - w)⁻¹ := by
    intro z hz
    have hne : ∀ w ∈ S, z - w ≠ 0 := by
      intro w hw h
      have hzw : z = w := sub_eq_zero.mp h
      exact hsphere w hw (hzw ▸ hz)
    have hd : ∀ w ∈ S, DifferentiableAt ℂ (fun y : ℂ => y - w) z := by
      intro w hw
      fun_prop
    have hfun : (fun y : ℂ => ∏ w ∈ S, (y - w)) = ∏ w ∈ S, (fun y : ℂ => y - w) := by
      funext y
      simp [Finset.prod_apply]
    rw [hfun, logDeriv_prod hne hd]
    apply Finset.sum_congr rfl
    intro w hw
    exact logDeriv_sub_const w z (sub_ne_zero.mp (hne w hw))
  have hInt : ∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
      = ∮ z in C(c, R), (∑ w ∈ S, (z - w)⁻¹) :=
    circleIntegral_congr c R hR hcongr
  have hcont : ∀ w ∈ S, ContinuousOn (fun z : ℂ => (z - w)⁻¹) (Metric.sphere c R) := by
    intro w hw
    have hcont' : ContinuousOn (fun z : ℂ => z - w) (Metric.sphere c R) := by
      fun_prop
    exact hcont'.inv₀ (fun z hz => sub_ne_zero.mpr (fun h => hsphere w hw (h ▸ hz)))
  have hLin : ∮ z in C(c, R), (∑ w ∈ S, (z - w)⁻¹)
      = ∑ w ∈ S, ∮ z in C(c, R), (z - w)⁻¹ :=
    circleIntegral_finset_sum_of_continuousOn S c R hR hcont
  have h2pi : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
    apply mul_ne_zero
    · apply mul_ne_zero
      · norm_num
      · exact Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
    · exact Complex.I_ne_zero
  have hterm : ∀ w ∈ S, ∮ z in C(c, R), (z - w)⁻¹
      = if w ∈ Metric.ball c R then 2 * (Real.pi : ℂ) * Complex.I else 0 := by
    intro w hw
    by_cases hb : w ∈ Metric.ball c R
    · simp only [hb, if_true]
      have h := circleIntegral_sub_inv_linear c w R hb
      calc ∮ z in C(c, R), (z - w)⁻¹
          = (2 * (Real.pi : ℂ) * Complex.I) * ((2 * (Real.pi : ℂ) * Complex.I)⁻¹
              * ∮ z in C(c, R), (z - w)⁻¹) := by field_simp
        _ = (2 * (Real.pi : ℂ) * Complex.I) * 1 := by rw [h]
        _ = 2 * (Real.pi : ℂ) * Complex.I := by ring
    · simp only [hb, if_false]
      apply circleIntegral_sub_inv_eq_zero c w R hR
      rcases hSep w hw with hb' | ho
      · exact absurd hb' hb
      · exact ho
  rw [hInt, hLin]
  have hsum : ∑ w ∈ S, (∮ z in C(c, R), (z - w)⁻¹)
      = ∑ w ∈ S, (if w ∈ Metric.ball c R then 2 * (Real.pi : ℂ) * Complex.I else 0) :=
    Finset.sum_congr rfl (fun w hw => hterm w hw)
  rw [hsum]
  have hfilter : ∑ w ∈ S,
      (if w ∈ Metric.ball c R then 2 * (Real.pi : ℂ) * Complex.I else 0)
      = ((S.filter (fun w => w ∈ Metric.ball c R)).card : ℂ)
        * (2 * (Real.pi : ℂ) * Complex.I) := by
    rw [← Finset.sum_filter]
    rw [Finset.sum_const, nsmul_eq_mul]
  rw [hfilter]
  field_simp


/-- **Local log-derivative factorisation.**  If `f = (z-w)·g` near `z`, then
`f'/f = 1/(z-w) + g'/g`.  This is the local step of the argument principle at
a simple zero. -/
theorem logDeriv_eq_inv_add {f g : ℂ → ℂ} {w z : ℂ}
    (h : f =ᶠ[nhds z] fun y => (y - w) * g y) (hz : z ≠ w) (hg : g z ≠ 0)
    (hdg : DifferentiableAt ℂ g z) :
    logDeriv f z = (z - w)⁻¹ + logDeriv g z := by
  have hfz : f z = (z - w) * g z := h.eq_of_nhds
  have hderiv : deriv f z = deriv (fun y : ℂ => (y - w) * g y) z := h.deriv_eq
  rw [logDeriv_apply, logDeriv_apply, hderiv, hfz]
  have hd : deriv (fun y : ℂ => (y - w) * g y) z
      = 1 * g z + (z - w) * deriv g z := by
    have hfun : (fun y : ℂ => (y - w) * g y) = (fun y : ℂ => y - w) * g := by
      funext y
      simp
    rw [hfun, deriv_mul]
    · rw [deriv_sub_const]
      simp
    · fun_prop
    · exact hdg
  rw [hd]
  field_simp [hz, hg]


/-- Additivity of the circle integral with continuity only on the sphere. -/
theorem circleIntegral_add_of_continuousOn {f g : ℂ → ℂ} (c : ℂ) (R : ℝ) (hR : 0 ≤ R)
    (hf : ContinuousOn f (Metric.sphere c R)) (hg : ContinuousOn g (Metric.sphere c R)) :
    ∮ z in C(c, R), (f z + g z) = (∮ z in C(c, R), f z) + ∮ z in C(c, R), g z := by
  unfold circleIntegral
  have hcont : ∀ h : ℂ → ℂ, ContinuousOn h (Metric.sphere c R) →
      Continuous (fun θ : ℝ => deriv (circleMap c R) θ • h (circleMap c R θ)) := by
    intro h hh
    have hfun : (fun θ : ℝ => deriv (circleMap c R) θ • h (circleMap c R θ))
        = fun θ : ℝ => (circleMap 0 R θ * Complex.I) • h (circleMap c R θ) := by
      funext θ
      rw [deriv_circleMap]
    rw [hfun]
    exact ((continuous_circleMap 0 R).mul continuous_const).smul
      (hh.comp_continuous (continuous_circleMap c R) (fun θ => circleMap_mem_sphere c hR θ))
  rw [show (fun θ : ℝ => deriv (circleMap c R) θ • (f (circleMap c R θ) + g (circleMap c R θ)))
      = fun θ : ℝ => deriv (circleMap c R) θ • f (circleMap c R θ)
          + deriv (circleMap c R) θ • g (circleMap c R θ) by
    funext θ
    rw [smul_add]]
  exact intervalIntegral.integral_add
    ((hcont f hf).intervalIntegrable 0 (2 * Real.pi))
    ((hcont g hg).intervalIntegrable 0 (2 * Real.pi))


/-- **The simple-zero contour integral.**  If `f = (z-w)·g` on a neighbourhood
of the closed disk, `g` is differentiable and nonzero there, and `w` is inside
the circle, then `∮ f'/f = 2πi`.  This is the local-to-global argument-principle
step at a simple zero. -/
theorem circleIntegral_logDeriv_simple_zero {f g : ℂ → ℂ} (c w : ℂ) (R : ℝ)
    (hR : 0 < R) (hw : w ∈ Metric.ball c R)
    (hfac : ∀ z ∈ Metric.ball c (R + 1), f z = (z - w) * g z)
    (hg : DifferentiableOn ℂ g (Metric.ball c (R + 1)))
    (hne : ∀ z ∈ Metric.ball c (R + 1), g z ≠ 0) :
    ∮ z in C(c, R), logDeriv f z = 2 * (Real.pi : ℂ) * Complex.I := by
  have hR1 : 0 ≤ R + 1 := by linarith
  have hsub : Metric.sphere c R ⊆ Metric.ball c (R + 1) := by
    intro z hz
    rw [Metric.mem_sphere] at hz
    rw [Metric.mem_ball]
    linarith
  have hsub_closed : Metric.closedBall c R ⊆ Metric.ball c (R + 1) := by
    intro z hz
    rw [Metric.mem_closedBall] at hz
    rw [Metric.mem_ball]
    linarith
  have hzw : ∀ z ∈ Metric.sphere c R, z ≠ w := by
    intro z hz h
    have hzR : dist z c = R := Metric.mem_sphere.mp hz
    have hwR : dist w c < R := Metric.mem_ball.mp hw
    rw [h] at hzR
    linarith
  have hlog : ∀ z ∈ Metric.sphere c R,
      logDeriv f z = (z - w)⁻¹ + logDeriv g z := by
    intro z hz
    have hmem : z ∈ Metric.ball c (R + 1) := hsub hz
    have hev : f =ᶠ[nhds z] fun y : ℂ => (y - w) * g y := by
      filter_upwards [Metric.isOpen_ball.mem_nhds hmem] with y hy
      exact hfac y hy
    have hgd : DifferentiableAt ℂ g z := hg.differentiableAt (Metric.isOpen_ball.mem_nhds hmem)
    exact logDeriv_eq_inv_add hev (hzw z hz) (hne z hmem) hgd
  have hInt : ∮ z in C(c, R), logDeriv f z
      = ∮ z in C(c, R), ((z - w)⁻¹ + logDeriv g z) :=
    circleIntegral_congr c R (le_of_lt hR) hlog
  have hcont_inv : ContinuousOn (fun z : ℂ => (z - w)⁻¹) (Metric.sphere c R) := by
    have hcont' : ContinuousOn (fun z : ℂ => z - w) (Metric.sphere c R) := by fun_prop
    exact hcont'.inv₀ (fun z hz => sub_ne_zero.mpr (hzw z hz))
  have hlogd : DifferentiableOn ℂ (logDeriv g) (Metric.ball c (R + 1)) := by
    have hderiv_diff : DifferentiableOn ℂ (deriv g) (Metric.ball c (R + 1)) :=
      hg.deriv Metric.isOpen_ball
    have h : DifferentiableOn ℂ (fun z : ℂ => deriv g z / g z) (Metric.ball c (R + 1)) :=
      hderiv_diff.div hg hne
    have hfun : logDeriv g = fun z : ℂ => deriv g z / g z := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact h
  have hcont_log : ContinuousOn (logDeriv g) (Metric.sphere c R) :=
    (hlogd.continuousOn).mono hsub
  have hAdd : ∮ z in C(c, R), ((z - w)⁻¹ + logDeriv g z)
      = (∮ z in C(c, R), (z - w)⁻¹) + ∮ z in C(c, R), logDeriv g z :=
    circleIntegral_add_of_continuousOn c R (le_of_lt hR) hcont_inv hcont_log
  have hLin := circleIntegral_sub_inv_linear c w R hw
  have h2pi : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
    apply mul_ne_zero
    · apply mul_ne_zero
      · norm_num
      · exact Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
    · exact Complex.I_ne_zero
  have hinv : ∮ z in C(c, R), (z - w)⁻¹ = 2 * (Real.pi : ℂ) * Complex.I := by
    calc ∮ z in C(c, R), (z - w)⁻¹
        = (2 * (Real.pi : ℂ) * Complex.I) * ((2 * (Real.pi : ℂ) * Complex.I)⁻¹
            * ∮ z in C(c, R), (z - w)⁻¹) := by field_simp
      _ = (2 * (Real.pi : ℂ) * Complex.I) * 1 := by rw [hLin]
      _ = 2 * (Real.pi : ℂ) * Complex.I := by ring
  have hZero : ∮ z in C(c, R), logDeriv g z = 0 := by
    have hcont_closed : ContinuousOn (logDeriv g) (Metric.closedBall c R) :=
      (hlogd.continuousOn).mono hsub_closed
    have hdiff : ∀ z ∈ Metric.ball c R \ (∅ : Set ℂ), DifferentiableAt ℂ (logDeriv g) z := by
      intro z hz
      have hzball : z ∈ Metric.ball c R := by simpa using hz
      exact hlogd.differentiableAt
        (Metric.isOpen_ball.mem_nhds (hsub_closed (Metric.ball_subset_closedBall hzball)))
    exact circleIntegral_eq_zero_of_differentiable_on_off_countable
      (R := R) (s := (∅ : Set ℂ)) (h0 := le_of_lt hR) (hs := by simp) hcont_closed hdiff
  rw [hInt, hAdd, hinv, hZero, add_zero]


/-- **Zero-free log-derivative integral.**  If `h` is differentiable and
nonzero on a neighbourhood of the closed disk, then `∮ h'/h = 0` (Cauchy). -/
theorem circleIntegral_logDeriv_eq_zero {h : ℂ → ℂ} (c : ℂ) (R : ℝ) (hR : 0 < R)
    (hh : DifferentiableOn ℂ h (Metric.ball c (R + 1)))
    (hne : ∀ z ∈ Metric.ball c (R + 1), h z ≠ 0) :
    ∮ z in C(c, R), logDeriv h z = 0 := by
  have hsub_closed : Metric.closedBall c R ⊆ Metric.ball c (R + 1) := by
    intro z hz
    rw [Metric.mem_closedBall] at hz
    rw [Metric.mem_ball]
    linarith
  have hderiv_diff : DifferentiableOn ℂ (deriv h) (Metric.ball c (R + 1)) :=
    hh.deriv Metric.isOpen_ball
  have hlogd : DifferentiableOn ℂ (logDeriv h) (Metric.ball c (R + 1)) := by
    have hquot : DifferentiableOn ℂ (fun z : ℂ => deriv h z / h z) (Metric.ball c (R + 1)) :=
      hderiv_diff.div hh hne
    have hfun : logDeriv h = fun z : ℂ => deriv h z / h z := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact hquot
  have hcont_closed : ContinuousOn (logDeriv h) (Metric.closedBall c R) :=
    (hlogd.continuousOn).mono hsub_closed
  have hdiff : ∀ z ∈ Metric.ball c R \ (∅ : Set ℂ), DifferentiableAt ℂ (logDeriv h) z := by
    intro z hz
    have hzball : z ∈ Metric.ball c R := by simpa using hz
    exact hlogd.differentiableAt
      (Metric.isOpen_ball.mem_nhds (hsub_closed (Metric.ball_subset_closedBall hzball)))
  exact circleIntegral_eq_zero_of_differentiable_on_off_countable
    (R := R) (s := (∅ : Set ℂ)) (h0 := le_of_lt hR) (hs := by simp) hcont_closed hdiff


/-- **Multi-zero argument-principle count.**  If `f = P·h` with `P` the
product of linear factors at roots inside the circle and `h` differentiable
and zero-free near the disk, then `∮ f'/f = 2πi · #S`. -/
theorem circleIntegral_logDeriv_mul_prod {h : ℂ → ℂ} (c : ℂ) (R : ℝ) (S : Finset ℂ)
    (hR : 0 < R) (hS : ∀ w ∈ S, w ∈ Metric.ball c R)
    (hh : DifferentiableOn ℂ h (Metric.ball c (R + 1)))
    (hne : ∀ z ∈ Metric.ball c (R + 1), h z ≠ 0) :
    ∮ z in C(c, R), logDeriv (fun y : ℂ => (∏ w ∈ S, (y - w)) * h y) z
      = (S.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  have hsub : Metric.sphere c R ⊆ Metric.ball c (R + 1) := by
    intro z hz
    rw [Metric.mem_sphere] at hz
    rw [Metric.mem_ball]
    linarith
  have hPne : ∀ z ∈ Metric.sphere c R, (∏ w ∈ S, (z - w)) ≠ 0 := by
    intro z hz
    apply Finset.prod_ne_zero_iff.mpr
    intro w hw
    have hzw : z ≠ w := by
      intro hzw
      have hzR : dist z c = R := Metric.mem_sphere.mp hz
      have hwR : dist w c < R := Metric.mem_ball.mp (hS w hw)
      rw [hzw] at hzR
      linarith
    exact sub_ne_zero.mpr hzw
  have hhnz : ∀ z ∈ Metric.sphere c R, h z ≠ 0 := fun z hz => hne z (hsub hz)
  have hlog : ∀ z ∈ Metric.sphere c R,
      logDeriv (fun y : ℂ => (∏ w ∈ S, (y - w)) * h y) z
        = (deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z / (∏ w ∈ S, (z - w))
            + deriv h z / h z) := by
    intro z hz
    have hPdiff : DifferentiableAt ℂ (fun y : ℂ => ∏ w ∈ S, (y - w)) z := by
      fun_prop
    have hhdiff : DifferentiableAt ℂ h z := hh.differentiableAt (Metric.isOpen_ball.mem_nhds (hsub hz))
    have hmul := logDeriv_mul z (hPne z hz) (hhnz z hz) hPdiff hhdiff
    have hfun : ((fun y : ℂ => ∏ w ∈ S, (y - w)) * h)
        = fun y : ℂ => (∏ w ∈ S, (y - w)) * h y := by
      funext y
      simp
    rw [hfun] at hmul
    simpa [logDeriv_apply] using hmul
  have hInt : ∮ z in C(c, R), logDeriv (fun y : ℂ => (∏ w ∈ S, (y - w)) * h y) z
      = ∮ z in C(c, R), (deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
          / (∏ w ∈ S, (z - w)) + deriv h z / h z) :=
    circleIntegral_congr c R (le_of_lt hR) hlog
  have hcontP : ContinuousOn (fun z : ℂ => deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
      / (∏ w ∈ S, (z - w))) (Metric.sphere c R) := by
    have hderiv_cont : Continuous (deriv (fun y : ℂ => ∏ w ∈ S, (y - w))) := by
      fun_prop
    have hP_cont : ContinuousOn (fun z : ℂ => ∏ w ∈ S, (z - w)) (Metric.sphere c R) := by
      fun_prop
    exact (hderiv_cont.continuousOn).div hP_cont hPne
  have hcontH : ContinuousOn (fun z : ℂ => deriv h z / h z) (Metric.sphere c R) := by
    have hderiv_cont : ContinuousOn (deriv h) (Metric.sphere c R) := by
      have := (hh.deriv Metric.isOpen_ball).continuousOn
      exact this.mono hsub
    have hh_cont : ContinuousOn h (Metric.sphere c R) := (hh.continuousOn).mono hsub
    exact hderiv_cont.div hh_cont hhnz
  have hAdd : ∮ z in C(c, R), (deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
        / (∏ w ∈ S, (z - w)) + deriv h z / h z)
      = (∮ z in C(c, R), deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z / (∏ w ∈ S, (z - w)))
        + ∮ z in C(c, R), deriv h z / h z :=
    circleIntegral_add_of_continuousOn c R (le_of_lt hR) hcontP hcontH
  have hProdInt : ∮ z in C(c, R), deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z / (∏ w ∈ S, (z - w))
      = (S.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
    have h := circleIntegral_logDeriv_prod c R S (le_of_lt hR) (fun w hw => Or.inl (hS w hw))
    -- h : (2πi)⁻¹ * ∮ logDeriv prod = card of filter
    have hfilter : S.filter (fun w => w ∈ Metric.ball c R) = S :=
      Finset.filter_true_of_mem hS
    rw [hfilter] at h
    -- h : (2πi)⁻¹ * ∮ logDeriv prod = S.card
    have h2pi : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
      apply mul_ne_zero
      · apply mul_ne_zero
        · norm_num
        · exact Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
      · exact Complex.I_ne_zero
    -- the integrand is definitionally logDeriv of the product
    have hlogdef : ∀ z, logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
        = deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z / (∏ w ∈ S, (z - w)) := by
      intro z
      rw [logDeriv_apply]
    simp only [hlogdef] at h
    calc ∮ z in C(c, R), deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z / (∏ w ∈ S, (z - w))
        = (2 * (Real.pi : ℂ) * Complex.I) * ((2 * (Real.pi : ℂ) * Complex.I)⁻¹
            * ∮ z in C(c, R), deriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z / (∏ w ∈ S, (z - w))) := by
          field_simp
      _ = (2 * (Real.pi : ℂ) * Complex.I) * (S.card : ℂ) := by rw [h]
      _ = (S.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by ring
  have hZero : ∮ z in C(c, R), deriv h z / h z = 0 := by
    have := circleIntegral_logDeriv_eq_zero c R hR hh hne
    simpa [logDeriv_apply] using this
  rw [hInt, hAdd, hProdInt, hZero, add_zero]


/-- The log-derivative of a reciprocal: `logDeriv (1/f) = -logDeriv f`. -/
theorem logDeriv_inv_comp {f : ℂ → ℂ} {z : ℂ} (hf : DifferentiableAt ℂ f z)
    (hz : f z ≠ 0) :
    logDeriv (fun y : ℂ => (f y)⁻¹) z = -logDeriv f z := by
  have h := logDeriv_comp (f := fun x : ℂ => x⁻¹) (g := f) (x := z)
    (differentiableAt_inv hz) hf
  rw [logDeriv_inv] at h
  have hfun : ((fun x : ℂ => x⁻¹) ∘ f) = fun y : ℂ => (f y)⁻¹ := rfl
  rw [hfun] at h
  rw [logDeriv_apply] at h
  rw [logDeriv_apply, h, logDeriv_apply]
  field_simp [hz]

/-- Negation of the circle integral. -/
theorem circleIntegral_neg {f : ℂ → ℂ} (c : ℂ) (R : ℝ) :
    ∮ z in C(c, R), (-(f z)) = -(∮ z in C(c, R), f z) := by
  unfold circleIntegral
  rw [show (fun θ : ℝ => deriv (circleMap c R) θ • (-(f (circleMap c R θ))))
      = fun θ : ℝ => -(deriv (circleMap c R) θ • f (circleMap c R θ)) by
    funext θ
    rw [smul_neg]]
  rw [intervalIntegral.integral_neg]


/-- **The simple-pole contour integral.**  If `1/f = (z-p)·k` on a
neighbourhood of the closed disk, with `k` differentiable and nonzero there,
and the pole `p` is inside the circle, then `∮ f'/f = -2πi`.  This is the
argument-principle step at a simple pole: the reciprocal has a simple zero. -/
theorem circleIntegral_logDeriv_simple_pole {f k : ℂ → ℂ} (c p : ℂ) (R : ℝ)
    (hR : 0 < R) (hp : p ∈ Metric.ball c R)
    (hfac : ∀ z ∈ Metric.ball c (R + 1), f z = ((z - p) * k z)⁻¹)
    (hk : DifferentiableOn ℂ k (Metric.ball c (R + 1)))
    (hne : ∀ z ∈ Metric.ball c (R + 1), k z ≠ 0) :
    ∮ z in C(c, R), logDeriv f z = -(2 * (Real.pi : ℂ) * Complex.I) := by
  have hsub : Metric.sphere c R ⊆ Metric.ball c (R + 1) := by
    intro z hz
    rw [Metric.mem_sphere] at hz
    rw [Metric.mem_ball]
    linarith
  have hzp : ∀ z ∈ Metric.sphere c R, z ≠ p := by
    intro z hz h
    have hzR : dist z c = R := Metric.mem_sphere.mp hz
    have hpR : dist p c < R := Metric.mem_ball.mp hp
    rw [h] at hzR
    linarith
  have hrecfac : ∀ z ∈ Metric.ball c (R + 1), (f z)⁻¹ = (z - p) * k z := by
    intro z hz
    rw [hfac z hz, inv_inv]
  have hIntRec : ∮ z in C(c, R), logDeriv (fun y : ℂ => (f y)⁻¹) z
      = 2 * (Real.pi : ℂ) * Complex.I :=
    circleIntegral_logDeriv_simple_zero c p R hR hp hrecfac hk hne
  have hpoint : ∀ z ∈ Metric.sphere c R,
      logDeriv (fun y : ℂ => (f y)⁻¹) z = -logDeriv f z := by
    intro z hz
    have hmem := hsub hz
    have hz_p := hzp z hz
    have hkz : k z ≠ 0 := hne z hmem
    have hfk : (z - p) * k z ≠ 0 := mul_ne_zero (sub_ne_zero.mpr hz_p) hkz
    have hfz : f z ≠ 0 := by
      rw [hfac z hmem]
      exact inv_ne_zero hfk
    have hev : f =ᶠ[nhds z] fun y : ℂ => ((y - p) * k y)⁻¹ := by
      filter_upwards [Metric.isOpen_ball.mem_nhds hmem] with y hy
      exact hfac y hy
    have hkd : DifferentiableAt ℂ k z :=
      hk.differentiableAt (Metric.isOpen_ball.mem_nhds hmem)
    have hmul : DifferentiableAt ℂ (fun y : ℂ => (y - p) * k y) z :=
      (differentiableAt_id.sub_const p).mul hkd
    have hdf : DifferentiableAt ℂ f z :=
      hev.differentiableAt_iff.mpr (hmul.inv hfk)
    exact logDeriv_inv_comp hdf hfz
  have hcongr : ∮ z in C(c, R), logDeriv (fun y : ℂ => (f y)⁻¹) z
      = ∮ z in C(c, R), -logDeriv f z :=
    circleIntegral_congr c R (le_of_lt hR) hpoint
  have hneg : ∮ z in C(c, R), -logDeriv f z
      = -(∮ z in C(c, R), logDeriv f z) := by
    simpa using circleIntegral_neg (f := fun z : ℂ => logDeriv f z) c R
  have hEq : ∮ z in C(c, R), -logDeriv f z = 2 * (Real.pi : ℂ) * Complex.I := by
    rw [← hcongr, hIntRec]
  rw [hneg] at hEq
  exact neg_eq_iff_eq_neg.mp hEq


/-- **Product contour integral, unnormalised form.**  For a finite set `S` of
roots all inside the circle, `∮ logDeriv ∏(z-w) = 2πi·#S`.  This is the
normalised count `circleIntegral_logDeriv_prod` with the factor `(2πi)⁻¹`
absorbed. -/
theorem circleIntegral_logDeriv_prod_eq (c : ℂ) (R : ℝ) (S : Finset ℂ)
    (hR : 0 < R) (hS : ∀ w ∈ S, w ∈ Metric.ball c R) :
    ∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
      = (S.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  have hprod := circleIntegral_logDeriv_prod c R S (le_of_lt hR)
    (fun w hw => Or.inl (hS w hw))
  have hfilter : S.filter (fun w => w ∈ Metric.ball c R) = S :=
    Finset.filter_true_of_mem hS
  rw [hfilter] at hprod
  have h2pi : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
    apply mul_ne_zero
    · apply mul_ne_zero
      · norm_num
      · exact Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
    · exact Complex.I_ne_zero
  calc ∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z
      = (2 * (Real.pi : ℂ) * Complex.I) * ((2 * (Real.pi : ℂ) * Complex.I)⁻¹
          * ∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z) := by
        field_simp
    _ = (2 * (Real.pi : ℂ) * Complex.I) * (S.card : ℂ) := by rw [hprod]
    _ = (S.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by ring


/-- **Divisor-form argument principle on a circle.**  If `f = P_Z · P_P⁻¹ · h`
with `P_Z, P_P` the products of linear factors over the zeros `Z` and poles `P`
inside the circle and `h` differentiable and zero-free near the disk, then
`∮ f'/f = 2πi·(#Z − #P)`.  This is the zero/pole count of the argument
principle in the form needed for `Z'/Z` on a contour. -/
theorem circleIntegral_logDeriv_div_prod {h : ℂ → ℂ} (c : ℂ) (R : ℝ)
    (Z P : Finset ℂ) (hR : 0 < R)
    (hZ : ∀ w ∈ Z, w ∈ Metric.ball c R)
    (hP : ∀ w ∈ P, w ∈ Metric.ball c R)
    (hh : DifferentiableOn ℂ h (Metric.ball c (R + 1)))
    (hne : ∀ z ∈ Metric.ball c (R + 1), h z ≠ 0) :
    ∮ z in C(c, R), logDeriv
        (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y) z
      = ((Z.card : ℂ) - (P.card : ℂ)) * (2 * (Real.pi : ℂ) * Complex.I) := by
  have hsub : Metric.sphere c R ⊆ Metric.ball c (R + 1) := by
    intro z hz
    rw [Metric.mem_sphere] at hz
    rw [Metric.mem_ball]
    linarith
  have hZne : ∀ z ∈ Metric.sphere c R, (∏ w ∈ Z, (z - w)) ≠ 0 := by
    intro z hz
    apply Finset.prod_ne_zero_iff.mpr
    intro w hw
    exact sub_ne_zero.mpr (by
      intro hzw
      have hzR : dist z c = R := Metric.mem_sphere.mp hz
      have hwR : dist w c < R := Metric.mem_ball.mp (hZ w hw)
      rw [hzw] at hzR
      linarith)
  have hPne : ∀ z ∈ Metric.sphere c R, (∏ w ∈ P, (z - w)) ≠ 0 := by
    intro z hz
    apply Finset.prod_ne_zero_iff.mpr
    intro w hw
    exact sub_ne_zero.mpr (by
      intro hzw
      have hzR : dist z c = R := Metric.mem_sphere.mp hz
      have hwR : dist w c < R := Metric.mem_ball.mp (hP w hw)
      rw [hzw] at hzR
      linarith)
  have hhnz : ∀ z ∈ Metric.sphere c R, h z ≠ 0 := fun z hz => hne z (hsub hz)
  have hlog : ∀ z ∈ Metric.sphere c R,
      logDeriv (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y) z
        = logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
          + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) + logDeriv h z := by
    intro z hz
    have hzZ := hZne z hz
    have hzP := hPne z hz
    have hzh := hhnz z hz
    have hPzd : DifferentiableAt ℂ (fun y : ℂ => ∏ w ∈ Z, (y - w)) z := by fun_prop
    have hPpd : DifferentiableAt ℂ (fun y : ℂ => ∏ w ∈ P, (y - w)) z := by fun_prop
    have hinvd : DifferentiableAt ℂ (fun y : ℂ => (∏ w ∈ P, (y - w))⁻¹) z :=
      hPpd.inv hzP
    have hhd : DifferentiableAt ℂ h z :=
      hh.differentiableAt (Metric.isOpen_ball.mem_nhds (hsub hz))
    have houter : (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y)
        = ((fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹) * h) := by
      funext y
      rfl
    have hinner : (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹)
        = ((fun y : ℂ => ∏ w ∈ Z, (y - w)) * (fun y : ℂ => (∏ w ∈ P, (y - w))⁻¹)) := by
      funext y
      rfl
    rw [houter]
    rw [logDeriv_mul (f := fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹)
      (g := h) z (mul_ne_zero hzZ (inv_ne_zero hzP)) hzh (hPzd.mul hinvd) hhd]
    rw [hinner]
    rw [logDeriv_mul (f := fun y : ℂ => ∏ w ∈ Z, (y - w))
      (g := fun y : ℂ => (∏ w ∈ P, (y - w))⁻¹) z hzZ (inv_ne_zero hzP) hPzd hinvd]
    rw [logDeriv_inv_comp (f := fun y : ℂ => ∏ w ∈ P, (y - w)) hPpd hzP]
  have hInt : ∮ z in C(c, R), logDeriv
        (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y) z
      = ∮ z in C(c, R), (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
          + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) + logDeriv h z) :=
    circleIntegral_congr c R (le_of_lt hR) hlog
  have hcontZ : ContinuousOn (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)))
      (Metric.sphere c R) := by
    have hd : ContinuousOn (deriv (fun y : ℂ => ∏ w ∈ Z, (y - w))) (Metric.sphere c R) := by
      fun_prop
    have hp : ContinuousOn (fun z : ℂ => ∏ w ∈ Z, (z - w)) (Metric.sphere c R) := by
      fun_prop
    have hfun : logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
        = fun z : ℂ => deriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z / (∏ w ∈ Z, (z - w)) := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact hd.div hp hZne
  have hcontP : ContinuousOn (logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)))
      (Metric.sphere c R) := by
    have hd : ContinuousOn (deriv (fun y : ℂ => ∏ w ∈ P, (y - w))) (Metric.sphere c R) := by
      fun_prop
    have hp : ContinuousOn (fun z : ℂ => ∏ w ∈ P, (z - w)) (Metric.sphere c R) := by
      fun_prop
    have hfun : logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))
        = fun z : ℂ => deriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z / (∏ w ∈ P, (z - w)) := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact hd.div hp hPne
  have hcontH : ContinuousOn (logDeriv h) (Metric.sphere c R) := by
    have hderiv_diff : DifferentiableOn ℂ (deriv h) (Metric.ball c (R + 1)) :=
      hh.deriv Metric.isOpen_ball
    have hlogd : DifferentiableOn ℂ (logDeriv h) (Metric.ball c (R + 1)) := by
      have hquot : DifferentiableOn ℂ (fun z : ℂ => deriv h z / h z)
          (Metric.ball c (R + 1)) := hderiv_diff.div hh hne
      have hfun : logDeriv h = fun z : ℂ => deriv h z / h z := by
        funext z
        rw [logDeriv_apply]
      rw [hfun]
      exact hquot
    exact hlogd.continuousOn.mono hsub
  have hsplit : ∮ z in C(c, R), (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
        + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) + logDeriv h z)
      = ∮ z in C(c, R), ((logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
          + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z + logDeriv h z) := by
    apply circleIntegral_congr c R (le_of_lt hR)
    intro z hz
    rfl
  have hAdd1 : ∮ z in C(c, R), ((logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
        + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z + logDeriv h z)
      = (∮ z in C(c, R), (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
          + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)
        + (∮ z in C(c, R), logDeriv h z) :=
    circleIntegral_add_of_continuousOn c R (le_of_lt hR)
      (hcontZ.add hcontP.neg) hcontH
  have hsplit2 : ∮ z in C(c, R), (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
        + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z
      = ∮ z in C(c, R), (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
          + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z) := by
    apply circleIntegral_congr c R (le_of_lt hR)
    intro z hz
    rfl
  have hAdd2 : ∮ z in C(c, R), (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
        + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)
      = (∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z)
        + (∮ z in C(c, R), (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z) :=
    circleIntegral_add_of_continuousOn c R (le_of_lt hR) hcontZ hcontP.neg
  have hZint : ∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
      = (Z.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) :=
    circleIntegral_logDeriv_prod_eq c R Z hR hZ
  have hPint : ∮ z in C(c, R), (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z
      = -((P.card : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)) := by
    have hneg : ∮ z in C(c, R), (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z
        = -(∮ z in C(c, R), logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) := by
      simpa only [Pi.neg_apply] using circleIntegral_neg (f := fun z : ℂ => logDeriv
        (fun y : ℂ => ∏ w ∈ P, (y - w)) z) c R
    rw [hneg, circleIntegral_logDeriv_prod_eq c R P hR hP]
  have hHint : ∮ z in C(c, R), logDeriv h z = 0 :=
    circleIntegral_logDeriv_eq_zero c R hR hh hne
  rw [hInt]
  rw [hsplit]
  rw [hAdd1]
  rw [hsplit2]
  rw [hAdd2]
  rw [hZint]
  rw [hPint]
  rw [hHint]
  ring

end AbsoluteHodgeSymbol








