import ExplicitFormula
import Repair
import IBox
import Seg
import RealAxis
import Mathlib.NumberTheory.LSeries.ZetaZeros

/-!
# M3-finite bridge

This file is the bridge from `finite-window-zeros` to the existing
`absolute-polarized-hodge-index-realization` explicit-formula layer.  It does
not yet assemble the tent-function consumer; it pins the imported theorem and
namespace so the later finite-window data can be attached.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail
open AbsoluteHodgeExplicitFormula
open AbsoluteHodgeRectangle
open AbsoluteHodgeSymbol
open Filter Topology

/-- Restatement of the imported test-function explicit formula, for use by the
M3-finite assembly. -/
theorem p4_test_function_explicit_formula {U : Set ℂ} (h : ℂ → ℂ) (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc x₁ x₂) (Set.uIcc y₁ y₂) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * Complex.I) :=
  test_function_explicit_formula h S x₁ x₂ y₁ y₂ hU hsub hSU h0_notS h1_notS
    hh hF hZ hZ_zero hF_simple hF_ne h0_in h1_in hS_in


/-- The tent function scaled to support `[-1/2, 1/2]`, so its autocorrelation
has support `[-1, 1]` as required by the Paley–Wiener formula. -/
def tentS (x : ℝ) : ℝ := max 0 (1 - |2 * x|)

lemma tentS_continuous : Continuous tentS := by
  unfold tentS
  exact continuous_const.max
    (continuous_const.sub (continuous_abs.comp (continuous_const.mul continuous_id)))

lemma tentS_eq_zero_of_half_le {x : ℝ} (h : (1 / 2 : ℝ) ≤ |x|) : tentS x = 0 := by
  unfold tentS
  rw [max_eq_left]
  have h2 : (1 : ℝ) ≤ |2 * x| := by
    rw [abs_mul]
    norm_num
    linarith
  linarith

lemma tentS_support {x : ℝ} (h : tentS x ≠ 0) :
    x ∈ Set.Icc (-(1 / 2)) (1 / 2) := by
  have hpos : 0 < 1 - |2 * x| := by
    by_contra hle
    push Not at hle
    exact h (by unfold tentS; rw [max_eq_left hle])
  have h2 : |2 * x| < 1 := by linarith
  have hx2 : |x| < 1 / 2 := by
    rw [abs_mul] at h2
    norm_num at h2
    linarith
  rcases abs_lt.mp hx2 with ⟨hlo, hhi⟩
  exact Set.mem_Icc.mpr ⟨by linarith, by linarith⟩

/-- **Tent Paley–Wiener nonnegativity.** The autocorrelation transform of the
scaled tent is nonnegative on the critical line. -/
theorem p4_tent_autocorr_nonneg (t : ℝ) :
    0 ≤ (paleyWiener
      (fun u : ℝ => ∫ v : ℝ, (tentS v : ℂ) *
        (starRingEnd ℂ) ((tentS (u - v) : ℂ)))
      (1 / 2 + (t : ℂ) * Complex.I)).re := by
  apply paleyWiener_autocorrelation_nonneg (fun x : ℝ => (tentS x : ℂ))
  · exact Complex.continuous_ofReal.comp tentS_continuous
  · intro x hx
    apply tentS_support
    intro hx0
    apply hx
    rw [hx0]
    simp

/-- A zero-free open set for the completed-zeta factor `s(s−1)Z(s)`. -/
def ZeroFreeOn (U : Set ℂ) : Prop :=
∀ z ∈ U, z * (z - 1) * completedZeta z ≠ 0

/-- Zero-freeness passes to subsets. -/
theorem zeroFreeOn_mono {U V : Set ℂ} (hU : ZeroFreeOn U) (hsub : V ⊆ U) :
    ZeroFreeOn V :=
  fun z hz => hU z (hsub hz)

/-- The finite set of zeros of `ζ` in a compact rectangle. -/
noncomputable def zeroFinset (R : Set ℂ) (hR : IsCompact R) : Finset ℂ :=
  (hR.inter_riemannZetaZeros_finite).toFinset

theorem mem_zeroFinset {R : Set ℂ} (hR : IsCompact R) {z : ℂ} :
    z ∈ zeroFinset R hR ↔ z ∈ R ∧ riemannZeta z = 0 := by
  unfold zeroFinset
  rw [Set.Finite.mem_toFinset]
  exact Iff.rfl

/-- Every zero in a compact rectangle is in its finite zero set. -/
theorem zero_mem_zeroFinset {R : Set ℂ} (hR : IsCompact R) {z : ℂ}
    (hzR : z ∈ R) (hz : riemannZeta z = 0) : z ∈ zeroFinset R hR :=
  (mem_zeroFinset hR).mpr ⟨hzR, hz⟩

/-- Zero sets are monotone in the compact rectangle. -/
theorem zeroFinset_mono {R R' : Set ℂ} (hR : IsCompact R) (hR' : IsCompact R')
    (hsub : R ⊆ R') : zeroFinset R hR ⊆ zeroFinset R' hR' := by
  intro z hz
  rw [mem_zeroFinset] at hz ⊢
  exact ⟨hsub hz.1, hz.2⟩

/-- If `completedZeta` is nonzero on a rectangle inside the critical strip,
then the finite ζ-zero set of that rectangle is empty. -/
theorem zeroFinset_eq_empty_of_zeroFree {R : Set ℂ} (hR : IsCompact R)
    (hstrip : ∀ z ∈ R, 0 < z.re ∧ z.re < 1)
    (hZ : ∀ z ∈ R, completedZeta z ≠ 0) :
    zeroFinset R hR = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro z hz
  rw [mem_zeroFinset] at hz
  apply hZ z hz.1
  exact (completedZeta_eq_zero_iff_zeta (hstrip z hz.1).1 (hstrip z hz.1).2).mpr hz.2

/-- **Empty-zero-set Paley–Wiener consumer.** With a zero-free contour
neighbourhood, the explicit formula has no zero contribution. -/
theorem p4_paleyWiener_empty (g : ℝ → ℂ) (hg : Continuous g)
    (hge : ∀ u : ℝ, g (-u) = g u)
    (hgr : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u)
    (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hZF : ZeroFreeOn U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener g ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    (- paleyWiener g 0 - paleyWiener g 1) * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener g ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener g ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  have h := contour_shift_paleyWiener g hg hge hgr (∅ : Finset ℂ) T hT hU hsub
    (by simp) (by simp) (by simp)
    hF hZ (by simp) (by simp)
    (by
      intro z hz hzS
      exact hZF z hz)
    (by simp) hint
  simpa using h

lemma tentS_even (x : ℝ) : tentS (-x) = tentS x := by
  unfold tentS
  rw [show 2 * (-x) = -(2 * x) by ring, abs_neg]

/-- **Concrete tent consumer.** T534 specialised to the fixed scaled tent. -/
theorem p4_tent_empty (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hZF : ZeroFreeOn U)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener (fun u : ℝ => (tentS u : ℂ))
            ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    (- paleyWiener (fun u : ℝ => (tentS u : ℂ)) 0
        - paleyWiener (fun u : ℝ => (tentS u : ℂ)) 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener (fun u : ℝ => (tentS u : ℂ))
                ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener (fun u : ℝ => (tentS u : ℂ))
                    ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  apply p4_paleyWiener_empty (fun u : ℝ => (tentS u : ℂ))
  · exact Complex.continuous_ofReal.comp tentS_continuous
  · intro u
    exact_mod_cast tentS_even u
  · intro u
    simp
  · exact hT
  · exact hU
  · exact hsub
  · exact hZF
  · exact hF
  · exact hZ
  · exact hint

/-- The scaled tent as a complex test function. -/
abbrev tentC (u : ℝ) : ℂ := (tentS u : ℂ)

/-- The archimedean `u`-superposition for the tent. -/
noncomputable def tentArch (T : ℝ) : ℂ :=
  ∫ u : ℝ in (-1)..1,
    tentC u * Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))
      * (∫ y : ℝ in (-T)..T,
          ((1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma ((2 + y * Complex.I) / 2))
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)))

/-- The prime `u`-superposition for the tent. -/
noncomputable def tentPrime (T : ℝ) : ℂ :=
  ∫ u : ℝ in (-1)..1,
    tentC u * Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))
      * (∫ y : ℝ in (-T)..T,
          LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 + y * Complex.I)
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)))

/-- **Tent archimedean/prime split.** The right-hand log-derivative integral for
the tent is the negative sum of the archimedean and prime superpositions. -/
theorem p4_tent_arch_prime (T : ℝ) :
    (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)
          * paleyWiener tentC (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I))
      = - tentArch T - tentPrime T := by
  have h := integral_logDeriv_paleyWiener_u_superposition tentC
    (Complex.continuous_ofReal.comp tentS_continuous) T
  have hleft : (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)
        * paleyWiener tentC (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) * Complex.I)
      = (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener tentC (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) * Complex.I := by
    rw [intervalIntegral.integral_mul_const]
  rw [hleft] at h
  have hmul : (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)
          * paleyWiener tentC (((2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) * Complex.I
      = (- tentArch T - tentPrime T) * Complex.I := by
    rw [h]
    unfold tentArch tentPrime
    ring
  exact mul_right_cancel₀ Complex.I_ne_zero hmul


lemma tentC_continuous : Continuous tentC :=
  Complex.continuous_ofReal.comp tentS_continuous


@[simp] lemma tentArch_zero : tentArch 0 = 0 := by
  simp [tentArch]

@[simp] lemma tentPrime_zero : tentPrime 0 = 0 := by
  simp [tentPrime]

/-- **Zero-free half-plane `Re s > 1`.** -/
theorem zeroFreeOn_of_one_lt_re {U : Set ℂ} (hU : ∀ z ∈ U, 1 < z.re) :
    ZeroFreeOn U := by
  intro z hz hprod
  have hz0 : z ≠ 0 := by
    intro h
    rw [h] at hz
    have := hU 0 hz
    norm_num at this
  have hz1 : z ≠ 1 := by
    intro h
    rw [h] at hz
    have := hU 1 hz
    norm_num at this
  have hZ : completedZeta z ≠ 0 := by
    unfold completedZeta
    refine mul_ne_zero (mul_ne_zero (Complex.exp_ne_zero _) ?_)
      (riemannZeta_ne_zero_of_one_lt_re (hU z hz))
    apply Complex.Gamma_ne_zero
    intro m hm
    have hre := congrArg Complex.re hm
    simp at hre
    have := hU z hz
    linarith
  apply hZ
  rcases mul_eq_zero.mp hprod with h | h
  · rcases mul_eq_zero.mp h with h0 | h1
    · exact absurd h0 hz0
    · exact absurd (sub_eq_zero.mp h1) hz1
  · exact h

/-- Nonvanishing of the pole-corrected product on `U`. -/
def FextNonzeroOn (U : Set ℂ) : Prop :=
  ∀ z ∈ U, AbsoluteHodgeExplicitFormula.Fext z ≠ 0

/-- **Corrected empty-zero-set consumer.**  Uses the pole-corrected product, so
the hypothesis is satisfiable at `0` and `1`. -/
theorem p4_paleyWiener_empty_repair (g : ℝ → ℂ) (hg : Continuous g)
    (hge : ∀ u : ℝ, g (-u) = g u)
    (hgr : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u)
    (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZF : FextNonzeroOn U)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener g ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    (- paleyWiener g 0 - paleyWiener g 1) * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener g ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener g ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  have h := contour_shift_paleyWiener_repair g hg hge hgr (∅ : Finset ℂ) T hT hU hsub
    (by simp) (by simp) (by simp) hΓ hZ (by simp) (by simp)
    (by
      intro z hz hzS
      exact hZF z hz)
    (by simp) hint
  simpa using h

/-- Corrected concrete tent consumer. -/
theorem p4_tent_empty_repair (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZF : FextNonzeroOn U)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    (- paleyWiener tentC 0 - paleyWiener tentC 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener tentC ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  apply p4_paleyWiener_empty_repair tentC tentC_continuous
  · intro u
    exact_mod_cast tentS_even u
  · intro u
    simp [tentC]
  · exact hT
  · exact hU
  · exact hsub
  · exact hΓ
  · exact hZ
  · exact hZF
  · exact hint



lemma tentC_even (x : ℝ) : tentC (-x) = tentC x := by
  simp [tentC, tentS_even]


/-- Corrected assembled tent-window formula. -/
theorem p4_tent_window_repair (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZF : FextNonzeroOn U)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    (- paleyWiener tentC 0 - paleyWiener tentC 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (- tentArch T - tentPrime T)
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  have h := p4_tent_empty_repair T hT hU hsub hΓ hZ hZF hint
  have hsplit : (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
        * paleyWiener tentC ((2 : ℂ) + (y : ℂ) * Complex.I)) =
      - tentArch T - tentPrime T := by
    simpa using p4_tent_arch_prime T
  rw [hsplit] at h
  exact h

/-- **General finite-zero tent formula.** The corrected Paley–Wiener formula
specialised to the tent, with a finite zero set `S` and explicit simplicity /
nonvanishing data. -/
theorem p4_tent_finite (S : Finset ℂ) (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hF_zero : ∀ ρ ∈ S, AbsoluteHodgeExplicitFormula.Fext ρ = 0)
    (hF_simple : ∀ ρ ∈ S, deriv AbsoluteHodgeExplicitFormula.Fext ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → AbsoluteHodgeExplicitFormula.Fext z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    ((∑ ρ ∈ S, paleyWiener tentC ρ) - paleyWiener tentC 0 - paleyWiener tentC 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener tentC ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  exact contour_shift_paleyWiener_repair tentC tentC_continuous
    (fun u => tentC_even u) (by intro u; simp [tentC]) S T hT hU hsub hSU h0_notS h1_notS
    hΓ hZ hF_zero hF_simple hF_ne hS_in hint

/-- A ζ-zero away from `0,1` is a zero of the corrected product. -/
theorem Fext_zero_of_zeta_zero {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hz : riemannZeta s = 0) :
    AbsoluteHodgeExplicitFormula.Fext s = 0 := by
  rw [AbsoluteHodgeExplicitFormula.Fext_apply_ne h0 h1 hΓ]
  have hZ : completedZeta s = 0 := by
    unfold completedZeta
    rw [hz]
    ring
  rw [hZ]
  ring

/-- Conversely, an `Fext`-zero away from `0,1` is a ζ-zero. -/
theorem zeta_zero_of_Fext_zero {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hF : AbsoluteHodgeExplicitFormula.Fext s = 0) :
    riemannZeta s = 0 := by
  have hFs : s * (s - 1) * completedZeta s = 0 := by
    rwa [AbsoluteHodgeExplicitFormula.Fext_apply_ne h0 h1 hΓ] at hF
  have hZ : completedZeta s = 0 := by
    rcases mul_eq_zero.mp hFs with h | h
    · rcases mul_eq_zero.mp h with h | h
      · exact absurd h h0
      · exact absurd (sub_eq_zero.mp h) h1
    · exact h
  unfold completedZeta at hZ
  rcases mul_eq_zero.mp hZ with h | h
  · rcases mul_eq_zero.mp h with h | h
    · exact absurd h (Complex.exp_ne_zero _)
    · have hG : Complex.Gamma (s / 2) ≠ 0 := by
        intro hg
        apply hΓ
        simp [Complex.Gammaℝ, hg]
      exact absurd h hG
  · exact h

/-- Away from `0,1` with gamma nonzero, `Fext` vanishes exactly at the ζ-zeros. -/
theorem Fext_zero_iff_zeta_zero {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) :
    AbsoluteHodgeExplicitFormula.Fext s = 0 ↔ riemannZeta s = 0 :=
  ⟨zeta_zero_of_Fext_zero h0 h1 hΓ, Fext_zero_of_zeta_zero h0 h1 hΓ⟩

/-- The ζ-zero set of a compact rectangle, with the two poles removed. -/
noncomputable def FextZeroFinset (R : Set ℂ) (hR : IsCompact R) : Finset ℂ :=
  (zeroFinset R hR).filter (fun z => z ≠ 0 ∧ z ≠ 1)

theorem mem_FextZeroFinset {R : Set ℂ} (hR : IsCompact R) {z : ℂ} :
    z ∈ FextZeroFinset R hR ↔ z ∈ R ∧ riemannZeta z = 0 ∧ z ≠ 0 ∧ z ≠ 1 := by
  classical
  simp [FextZeroFinset, mem_zeroFinset, and_assoc]

theorem Fext_zero_on_FextZeroFinset {R : Set ℂ} (hR : IsCompact R) {z : ℂ}
    (hz : z ∈ FextZeroFinset R hR) (hΓ : z.Gammaℝ ≠ 0) :
    AbsoluteHodgeExplicitFormula.Fext z = 0 := by
  obtain ⟨-, hzζ, hz0, hz1⟩ := (mem_FextZeroFinset hR).mp hz
  exact Fext_zero_of_zeta_zero hz0 hz1 hΓ hzζ

theorem zero_notMem_FextZeroFinset (R : Set ℂ) (hR : IsCompact R) :
    (0 : ℂ) ∉ FextZeroFinset R hR := by
  intro h
  exact ((mem_FextZeroFinset hR).mp h).2.2.1 rfl

theorem one_notMem_FextZeroFinset (R : Set ℂ) (hR : IsCompact R) :
    (1 : ℂ) ∉ FextZeroFinset R hR := by
  intro h
  exact ((mem_FextZeroFinset hR).mp h).2.2.2 rfl

theorem FextZeroFinset_subset {R : Set ℂ} (hR : IsCompact R) :
    (FextZeroFinset R hR : Set ℂ) ⊆ R := by
  intro z hz
  exact ((mem_FextZeroFinset hR).mp hz).1

theorem mem_FextZeroFinset_of_Fext_zero {R : Set ℂ} (hR : IsCompact R) {z : ℂ}
    (hzR : z ∈ R) (hF : AbsoluteHodgeExplicitFormula.Fext z = 0)
    (hz0 : z ≠ 0) (hz1 : z ≠ 1) (hΓ : z.Gammaℝ ≠ 0) :
    z ∈ FextZeroFinset R hR := by
  rw [mem_FextZeroFinset]
  exact ⟨hzR, zeta_zero_of_Fext_zero hz0 hz1 hΓ hF, hz0, hz1⟩

/-- **Finite-zero tent formula from a rectangle zero set.**  T547 instantiated
with `FextZeroFinset R`; the remaining inputs are simplicity, the statement that
all `Fext`-zeros in `U` lie in `R`, and the numeric interval data. -/
theorem p4_tent_from_zeros (R : Set ℂ) (hR : IsCompact R) (T : ℝ) (hT : 0 < T)
    {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hRU : R ⊆ U)
    (hR_in : ∀ z ∈ R, -1 < z.re ∧ z.re < 2 ∧ -T < z.im ∧ z.im < T)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZeroIn : ∀ z ∈ U, AbsoluteHodgeExplicitFormula.Fext z = 0 → z ∈ R)
    (hF_simple : ∀ ρ ∈ FextZeroFinset R hR,
      deriv AbsoluteHodgeExplicitFormula.Fext ρ ≠ 0)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    ((∑ ρ ∈ FextZeroFinset R hR, paleyWiener tentC ρ)
        - paleyWiener tentC 0 - paleyWiener tentC 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener tentC ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener tentC ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  apply p4_tent_finite (FextZeroFinset R hR) T hT hU hsub
  · intro ρ hρ
    exact hRU (FextZeroFinset_subset hR hρ)
  · exact zero_notMem_FextZeroFinset R hR
  · exact one_notMem_FextZeroFinset R hR
  · exact hΓ
  · exact hZ
  · intro ρ hρ
    exact Fext_zero_on_FextZeroFinset hR hρ (hΓ ρ (hRU (FextZeroFinset_subset hR hρ)))
  · exact hF_simple
  · intro z hzU hzS hFzero
    apply hzS
    apply mem_FextZeroFinset_of_Fext_zero hR (hZeroIn z hzU hFzero) hFzero
    · intro h
      rw [h, AbsoluteHodgeExplicitFormula.Fext_zero] at hFzero
      norm_num at hFzero
    · intro h
      rw [h, AbsoluteHodgeExplicitFormula.Fext_one] at hFzero
      norm_num at hFzero
    · exact hΓ z hzU
  · intro ρ hρ
    exact hR_in ρ (FextZeroFinset_subset hR hρ)
  · exact hint


/-- Membership in the filtered zero set, characterized directly by `Fext`. -/
theorem mem_FextZeroFinset_iff_Fext_zero {R : Set ℂ} (hR : IsCompact R) {z : ℂ}
    (hzR : z ∈ R) (hΓ : z.Gammaℝ ≠ 0) :
    z ∈ FextZeroFinset R hR ↔
      AbsoluteHodgeExplicitFormula.Fext z = 0 ∧ z ≠ 0 ∧ z ≠ 1 := by
  constructor
  · intro hz
    obtain ⟨-, hζ, hz0, hz1⟩ := (mem_FextZeroFinset hR).mp hz
    exact ⟨Fext_zero_of_zeta_zero hz0 hz1 hΓ hζ, hz0, hz1⟩
  · rintro ⟨hF, hz0, hz1⟩
    exact mem_FextZeroFinset_of_Fext_zero hR hzR hF hz0 hz1 hΓ

theorem FextZeroFinset_mono {R R' : Set ℂ} (hR : IsCompact R) (hR' : IsCompact R')
    (hsub : R ⊆ R') : FextZeroFinset R hR ⊆ FextZeroFinset R' hR' := by
  intro z hz
  obtain ⟨hzR, hzζ, hz0, hz1⟩ := (mem_FextZeroFinset hR).mp hz
  exact (mem_FextZeroFinset hR').mpr ⟨hsub hzR, hzζ, hz0, hz1⟩

/-- At a ζ-zero with `re s > 0` and `s ≠ 1`, the derivative of the completed
zeta is the derivative of the zeta times the archimedean prefactor. -/
theorem deriv_completedZeta_of_zeta_zero {s : ℂ} (hre : 0 < s.re) (hne : s ≠ 1)
    (hζ : riemannZeta s = 0) :
    deriv completedZeta s
      = Complex.exp (-(s / 2) * Complex.log (Real.pi : ℂ))
        * Complex.Gamma (s / 2) * deriv riemannZeta s := by
  have hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ) := by
    intro m h
    have h' := congrArg Complex.re h
    have hre' : s.re / 2 = -(m : ℝ) := by simpa using h'
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    nlinarith
  have hdA : DifferentiableAt ℂ
      (fun z : ℂ => Complex.exp (-(z / 2) * Complex.log (Real.pi : ℂ))) s := by
    fun_prop
  have hdG : DifferentiableAt ℂ (fun z : ℂ => Complex.Gamma (z / 2)) s := by
    apply DifferentiableAt.comp
    · exact Complex.differentiableAt_Gamma (s / 2) hg
    · fun_prop
  have hdZ : DifferentiableAt ℂ riemannZeta s := differentiableAt_riemannZeta hne
  unfold completedZeta
  change deriv ((fun z : ℂ =>
      Complex.exp (-(z / 2) * Complex.log (Real.pi : ℂ))
        * Complex.Gamma (z / 2)) * riemannZeta) s
    = Complex.exp (-(s / 2) * Complex.log (Real.pi : ℂ))
      * Complex.Gamma (s / 2) * deriv riemannZeta s
  rw [deriv_mul]
  · rw [hζ, mul_zero, zero_add]
  · exact hdA.mul hdG
  · exact hdZ

/-- At a simple ζ-zero with `re s > 0`, away from the two poles and Gamma
poles, the derivative of the pole-corrected product `Fext` is nonzero. -/
theorem deriv_Fext_ne_zero_of_simple {s : ℂ} (hre : 0 < s.re) (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) (hζ0 : riemannZeta s = 0)
    (hd : deriv riemannZeta s ≠ 0) :
    deriv AbsoluteHodgeExplicitFormula.Fext s ≠ 0 := by
  have hg : ∀ m : ℕ, s / 2 ≠ -(m : ℂ) := by
    intro m h
    have h' := congrArg Complex.re h
    have hre' : s.re / 2 = -(m : ℝ) := by simpa using h'
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    nlinarith
  have hG : Complex.Gamma (s / 2) ≠ 0 := by
    intro h
    apply hΓ
    rw [Complex.Gammaℝ_def, h, mul_zero]
  have hcontG : ContinuousAt (fun x : ℂ => Complex.Gamma (x / 2)) s := by
    apply ContinuousAt.comp
    · exact (Complex.differentiableAt_Gamma (s / 2) hg).continuousAt
    · fun_prop
  have hGevent : ∀ᶠ x : ℂ in 𝓝 s, Complex.Gamma (x / 2) ≠ 0 :=
    hcontG.eventually_ne hG
  have hΓevent : ∀ᶠ x : ℂ in 𝓝 s, x.Gammaℝ ≠ 0 := by
    filter_upwards [hGevent] with x hx hx0
    apply hx
    rw [Complex.Gammaℝ_def] at hx0
    exact (mul_eq_zero.mp hx0).resolve_left
      (Complex.cpow_ne_zero_iff.mpr (Or.inl (by exact_mod_cast Real.pi_ne_zero)))
  have hev : AbsoluteHodgeExplicitFormula.Fext =ᶠ[𝓝 s]
      fun x : ℂ => x * (x - 1) * completedZeta x := by
    filter_upwards [hΓevent, isOpen_compl_singleton.mem_nhds h0,
      isOpen_compl_singleton.mem_nhds h1] with x hΓx hx0 hx1
    exact AbsoluteHodgeExplicitFormula.Fext_apply_ne hx0 hx1 hΓx
  have hZ : DifferentiableAt ℂ completedZeta s := by
    unfold completedZeta
    exact (((by fun_prop : DifferentiableAt ℂ
        (fun z : ℂ => Complex.exp (-(z / 2) * Complex.log (Real.pi : ℂ))) s).mul
      (DifferentiableAt.comp s (Complex.differentiableAt_Gamma (s / 2) hg)
        (by fun_prop))).mul (differentiableAt_riemannZeta h1))
  have h12 : DifferentiableAt ℂ (fun x : ℂ => x * (x - 1)) s := by fun_prop
  have hZ0 : completedZeta s = 0 := by
    unfold completedZeta
    rw [hζ0, mul_zero]
  have hderiv : deriv (fun x : ℂ => x * (x - 1) * completedZeta x) s
      = s * (s - 1) * deriv completedZeta s := by
    change deriv ((fun x : ℂ => x * (x - 1)) * completedZeta) s = _
    rw [deriv_mul h12 hZ, hZ0, mul_zero, zero_add]
  have hF : deriv AbsoluteHodgeExplicitFormula.Fext s
      = s * (s - 1) * deriv completedZeta s := by
    rw [hev.deriv_eq, hderiv]
  rw [hF, deriv_completedZeta_of_zeta_zero hre h1 hζ0]
  exact mul_ne_zero (mul_ne_zero h0 (sub_ne_zero.mpr h1))
    (mul_ne_zero (mul_ne_zero (Complex.exp_ne_zero _) hG) hd)

/-- The open contour neighbourhood for the `T=1` window. -/
def T1U : Set ℂ :=
  {z | -(3 / 2 : ℝ) < z.re ∧ z.re < (5 / 2 : ℝ) ∧
    -(3 / 2 : ℝ) < z.im ∧ z.im < (3 / 2 : ℝ)}

theorem T1U_isOpen : IsOpen T1U := by
  unfold T1U
  exact (isOpen_lt continuous_const Complex.continuous_re).inter
    ((isOpen_lt Complex.continuous_re continuous_const).inter
      ((isOpen_lt continuous_const Complex.continuous_im).inter
        (isOpen_lt Complex.continuous_im continuous_const)))

/-- Corrected tent-window formula at `T = 1`, with the zero-free and enclosure
inputs explicit. -/
theorem p4_tent_T1 (hZF : FextNonzeroOn T1U)
    (hΓ : ∀ z ∈ T1U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (T1U \ {0, 1}))
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (1 : ℂ) * Complex.I)
        * paleyWiener tentC ((x : ℂ) + (1 : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    (- paleyWiener tentC 0 - paleyWiener tentC 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (- tentArch 1 - tentPrime 1)
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (1 : ℂ) * Complex.I)
                * paleyWiener tentC ((x : ℂ) + (1 : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  apply p4_tent_window_repair (T := 1) (U := T1U) (by norm_num) T1U_isOpen
  · intro z hz
    simp only [Complex.mem_reProdIm] at hz
    rw [Set.uIcc_of_le (by norm_num : (-1 : ℝ) ≤ 2)] at hz
    rw [Set.uIcc_of_le (by norm_num : (-1 : ℝ) ≤ 1)] at hz
    norm_num at hz
    unfold T1U
    refine ⟨?_, ?_, ?_, ?_⟩ <;> linarith [hz.1.1, hz.1.2, hz.2.1, hz.2.2]
  · exact hΓ
  · exact hZ
  · exact hZF
  · exact hint


/-- An asymmetric rectangle with separate real and imaginary radii. -/
def rectOfRadii (a b : ℚ) : Cx := ⟨⟨-a, a⟩, ⟨-b, b⟩⟩

theorem mem_rectOfRadii {a b : ℚ} {z : ℂ}
    (hre : |z.re| ≤ (a : ℝ)) (him : |z.im| ≤ (b : ℝ)) :
    Cx.mem z (rectOfRadii a b) := by
  rcases abs_le.mp hre with ⟨hre1, hre2⟩
  rcases abs_le.mp him with ⟨him1, him2⟩
  unfold rectOfRadii Cx.mem Iv.memR
  exact ⟨⟨by simpa using hre1, by simpa using hre2⟩,
    ⟨by simpa using him1, by simpa using him2⟩⟩

/-- **Componentwise-tail eta certificate.** If the shifted pair tail has separate
real/imaginary bounds and the folded box with `rectOfRadii a b` excludes zero,
then `ζ` is nonvanishing on the rectangle. -/
theorem zeta_ne_zero_on_rect_of_component_tail (M : ℕ) (S : Cx) (a b : ℚ)
    (hcond : ∀ p ∈ params M, PairConditions p S)
    (hre : ∀ s : ℂ, Cx.mem s S → 0 < s.re)
    (hne : ∀ s : ℂ, Cx.mem s S → s ≠ 1)
    (htail_re : ∀ s : ℂ, Cx.mem s S →
      |(∑' m : ℕ, pairTerm s (m + M)).re| ≤ (a : ℝ))
    (htail_im : ∀ s : ℂ, Cx.mem s S →
      |(∑' m : ℕ, pairTerm s (m + M)).im| ≤ (b : ℝ))
    (hzero : containsZero ((sumBox (params M) S).add (rectOfRadii a b)) = false) :
    ∀ s : ℂ, Cx.mem s S → riemannZeta s ≠ 0 := by
  intro s hs
  have hsum : Cx.mem (sumValue (params M) s) (sumBox (params M) S) :=
    sumBox_mem (params M) S s hs hcond
  have hsum_eq : sumValue (params M) s =
      ∑ m ∈ Finset.range M, pairTerm s m :=
    sumValue_params M s
  have hsummable : Summable (fun m : ℕ => pairTerm s m) :=
    summable_pairTerm (hre s hs)
  have hdecomp : etaGrouped s = sumValue (params M) s +
      ∑' m : ℕ, pairTerm s (m + M) := by
    rw [etaGrouped, ← hsummable.sum_add_tsum_nat_add M, ← hsum_eq]
  let B : Cx := (sumBox (params M) S).add (rectOfRadii a b)
  have htail_mem : Cx.mem (∑' m : ℕ, pairTerm s (m + M)) (rectOfRadii a b) :=
    mem_rectOfRadii (htail_re s hs) (htail_im s hs)
  have hB : Cx.mem (etaGrouped s) B := by
    rw [hdecomp]
    exact Cx.mem_add hsum htail_mem
  have hzero' : ¬ Cx.mem (0 : ℂ) B := by
    intro h
    have htrue := (containsZero_iff B).mpr h
    rw [hzero] at htrue
    exact Bool.false_ne_true htrue
  exact zeta_ne_zero_of_eta_mem (U := {z : ℂ | Cx.mem z B}) (hre s hs) (hne s hs) hB hzero'

/-- The explicit zero-free band for `Fext`, as an open set. -/
def ExplicitBand : Set ℂ :=
  {z | (1 / 4 : ℝ) < z.re ∧ z.re < (7 / 8 : ℝ) ∧ |z.im| < (1 / 2048 : ℝ)}

theorem ExplicitBand_isOpen : IsOpen ExplicitBand := by
  unfold ExplicitBand
  exact (isOpen_lt continuous_const Complex.continuous_re).inter
    ((isOpen_lt Complex.continuous_re continuous_const).inter
      (isOpen_lt (continuous_abs.comp Complex.continuous_im) continuous_const))

theorem FextNonzeroOn_explicitBand : FextNonzeroOn ExplicitBand := by
  intro z hz
  exact Fext_ne_zero_band (le_of_lt hz.1) (le_of_lt hz.2.1) (le_of_lt hz.2.2)

end FiniteWindowZeros
