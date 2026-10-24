/-
  DirichletGammaLogDeriv.lean — the **archimedean half of the explicit-formula identity**.

  `DirichletLogDeriv.lean` proves the prime half, `−L'/L = LSeries (Λ·χ)`.  This file proves
  the archimedean half: the logarithmic derivative of the completed gamma factor

    `Complex.Gammaℝ s = π^{−s/2} Γ(s/2)`

  is `−½ log π + ½ ψ(s/2)`, where `ψ = Complex.digamma = logDeriv Γ`.  Concretely:

    `logDeriv Complex.Gammaℝ s = −(1/2) log π + (1/2) ψ(s/2)`  for `0 < re s`.

  Together with the prime half this gives the integrand of the Dirichlet explicit formula,
  `logDeriv (dirichletCompleted χ) = (1/2) log N + logDeriv (gammaFactor χ) − LSeries (Λ·χ)`
  on `1 < re s` (the `(1/2) log N` from `N^{s/2}`), once the `gammaFactor`/`LFunction`
  product decomposition is supplied.
-/
import DirichletExplicit
import Mathlib.Analysis.SpecialFunctions.Gamma.Deligne
import Mathlib.Analysis.SpecialFunctions.Gamma.Digamma
import Mathlib.Analysis.Calculus.LogDeriv

namespace RouteABC

noncomputable section

open scoped BigOperators

/-- `deriv (fun s : ℂ => s / 2) s = 1/2`. -/
theorem deriv_div_two (s : ℂ) : deriv (fun s : ℂ => s / 2) s = 1 / 2 := by
  simp [deriv_div_const]

/-- `deriv (fun s : ℂ => -s / 2) s = -1/2`. -/
theorem deriv_neg_div_two (s : ℂ) : deriv (fun s : ℂ => -s / 2) s = -(1 / 2) := by
  simp only [deriv_div_const, deriv_neg]
  norm_num

/-- **The archimedean half.**  `logDeriv Gammaℝ s = −½ log π + ½ ψ(s/2)` for `0 < re s`. -/
theorem Complex.logDeriv_Gammaℝ {s : ℂ} (hs : 0 < s.re) :
    logDeriv Complex.Gammaℝ s
      = -(1 / 2) * Complex.log (Real.pi : ℂ) + (1 / 2) * Complex.digamma (s / 2) := by
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hI : NeZero (Real.pi : ℂ) := ⟨hpi⟩
  have hs2 : 0 < (s / 2).re := by
    rw [Complex.div_re]
    norm_num [Complex.normSq_apply, Complex.ofReal_re, Complex.ofReal_im]
    linarith
  have hG : Complex.Gamma (s / 2) ≠ 0 := Complex.Gamma_ne_zero_of_re_pos hs2
  have hGdiff : DifferentiableAt ℂ Complex.Gamma (s / 2) :=
    Complex.differentiableAt_Gamma _ (fun m => by
      intro h
      have hre := congrArg Complex.re h
      simp only [Complex.neg_re, Complex.natCast_re] at hre
      have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      linarith)
  have hGcomp : DifferentiableAt ℂ (fun s : ℂ => Complex.Gamma (s / 2)) s :=
    hGdiff.comp s (by fun_prop)
  have hcpowdiff : DifferentiableAt ℂ (fun z : ℂ => (Real.pi : ℂ) ^ (-z / 2)) s := by
    have h : DifferentiableAt ℂ (fun z : ℂ => -z / 2) s := by fun_prop
    simpa using h.const_cpow (Or.inl hpi)
  have hcpow : logDeriv (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2)) s
      = -(1 / 2) * Complex.log (Real.pi : ℂ) := by
    have hg : DifferentiableAt ℂ (fun s : ℂ => -s / 2) s := by fun_prop
    have hf : DifferentiableAt ℂ (fun z : ℂ => (Real.pi : ℂ) ^ z) (-s / 2) :=
      differentiableAt_const_cpow_of_neZero (Real.pi : ℂ) (-s / 2)
    rw [show (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2))
          = (fun z : ℂ => (Real.pi : ℂ) ^ z) ∘ (fun s : ℂ => -s / 2) from rfl,
      logDeriv_comp (f := fun z : ℂ => (Real.pi : ℂ) ^ z) (g := fun s : ℂ => -s / 2) hf hg,
      congrFun (Complex.logDeriv_const_cpow hpi) (-s / 2), deriv_neg_div_two]
    ring
  have hgamma : logDeriv (fun s : ℂ => Complex.Gamma (s / 2)) s
      = (1 / 2) * Complex.digamma (s / 2) := by
    have hg : DifferentiableAt ℂ (fun s : ℂ => s / 2) s := by fun_prop
    rw [show (fun s : ℂ => Complex.Gamma (s / 2))
          = Complex.Gamma ∘ (fun s : ℂ => s / 2) from rfl,
      logDeriv_comp (f := Complex.Gamma) (g := fun s : ℂ => s / 2) hGdiff hg,
      deriv_div_two, Complex.digamma_def]
    ring
  rw [show Complex.Gammaℝ
        = fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2) from
      funext Complex.Gammaℝ_def]
  rw [show (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2))
        = (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2))
          * (fun s : ℂ => Complex.Gamma (s / 2)) from rfl]
  rw [logDeriv_mul (f := fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2))
        (g := fun s : ℂ => Complex.Gamma (s / 2)) s
        (Complex.cpow_ne_zero_iff.mpr (Or.inl hpi)) hG hcpowdiff hGcomp, hcpow, hgamma]

end

end RouteABC
