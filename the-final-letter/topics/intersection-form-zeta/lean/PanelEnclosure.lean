import DigammaEnclosure
import Enclosure
import PolygammaSeries

open Complex Filter MeasureTheory
open scoped Topology BigOperators

namespace IntersectionForm

noncomputable def panelPoint (t : ℚ) (N : ℕ) : ℂ :=
  ((N : ℂ) + 1 / 4) + ((t : ℂ) / 2) * Complex.I

lemma panelPoint_re (t : ℚ) (N : ℕ) : (panelPoint t N).re = (N : ℝ) + 1 / 4 := by
  simp [panelPoint]

lemma panelPoint_im (t : ℚ) (N : ℕ) : (panelPoint t N).im = (t : ℝ) / 2 := by
  simp [panelPoint]

lemma normSq_panelPoint (t : ℚ) (N : ℕ) :
    Complex.normSq (panelPoint t N) =
      ((((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2 : ℚ) : ℝ) := by
  rw [Complex.normSq_apply, panelPoint_re, panelPoint_im]
  push_cast
  ring

lemma panel_log_re_eq (t : ℚ) (N : ℕ) :
    (Complex.log (panelPoint t N)).re =
      (1 / 2) * Real.log ((((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2 : ℚ) : ℝ) := by
  rw [log_re_eq_half_log_normSq, normSq_panelPoint]

end IntersectionForm

namespace IntersectionForm

lemma one_le_panel_q (t : ℚ) (N : ℕ) (hN : 1 ≤ N) :
    (1 : ℚ) ≤ ((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
  have hN' : (1 : ℚ) ≤ (N : ℚ) := by exact_mod_cast hN
  have h : (1 : ℚ) ≤ (N : ℚ) + 1 / 4 := by linarith
  have h2 : (1 : ℚ) ≤ ((N : ℚ) + 1 / 4) ^ 2 := by nlinarith
  have ht : 0 ≤ (t / 2) ^ 2 := sq_nonneg _
  linarith

lemma panel_log_re_mem (t : ℚ) (N : ℕ) (hN : 1 ≤ N) (M : ℕ) :
    (1 / 2) * (logPointLo M (((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2) : ℝ) ≤
      (Complex.log (panelPoint t N)).re ∧
    (Complex.log (panelPoint t N)).re ≤
      (1 / 2) * (logPointHi M (((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2) : ℝ) := by
  rw [panel_log_re_eq]
  have hq := one_le_panel_q t N hN
  have hmem := logPoint_mem M hq
  constructor
  · nlinarith [hmem.1]
  · nlinarith [hmem.2]

def panelReW (N : ℕ) : ℚ := (N : ℚ) + 1 / 4
def panelImW (t : ℚ) : ℚ := t / 2
def panelQ (t : ℚ) (N : ℕ) : ℚ := panelReW N ^ 2 + panelImW t ^ 2

lemma panelQ_pos (t : ℚ) (N : ℕ) : 0 < panelQ t N := by
  have h1 : (0 : ℚ) < panelReW N := by
    unfold panelReW
    have : (0 : ℚ) ≤ N := Nat.cast_nonneg N
    linarith
  have h2 : 0 ≤ panelImW t ^ 2 := sq_nonneg _
  have h3 : 0 < panelReW N ^ 2 := pow_pos h1 2
  unfold panelQ
  linarith

lemma panelQ_cast (t : ℚ) (N : ℕ) :
    (panelQ t N : ℝ) = Complex.normSq (panelPoint t N) := by
  rw [normSq_panelPoint]
  unfold panelQ panelReW panelImW
  push_cast
  ring

lemma panel_term1 (t : ℚ) (N : ℕ) :
    (1 / (2 * panelPoint t N)).re = (panelReW N / (2 * panelQ t N) : ℚ) := by
  have hq : panelQ t N ≠ 0 := ne_of_gt (panelQ_pos t N)
  have hqR : (panelQ t N : ℝ) ≠ 0 := by exact_mod_cast hq
  have hcast : (panelQ t N : ℝ) = Complex.normSq (panelPoint t N) := panelQ_cast t N
  rw [show (1 / (2 * panelPoint t N)) = (1 / 2 : ℂ) * (panelPoint t N)⁻¹ by
    rw [div_eq_mul_inv, mul_inv]
    norm_num]
  rw [Complex.mul_re]
  norm_num
  rw [panelPoint_re, ← hcast]
  unfold panelReW
  push_cast
  ring

lemma panel_term2 (t : ℚ) (N : ℕ) :
    (1 / (12 * (panelPoint t N) ^ 2)).re =
      (((panelReW N ^ 2 - panelImW t ^ 2) / (12 * panelQ t N ^ 2) : ℚ) : ℝ) := by
  have hqpos : 0 < panelQ t N := panelQ_pos t N
  have hqne : (panelQ t N : ℝ) ≠ 0 := ne_of_gt (by exact_mod_cast hqpos)
  have hcast : (panelQ t N : ℝ) = Complex.normSq (panelPoint t N) := panelQ_cast t N
  have hw : panelPoint t N ≠ 0 := by
    intro h
    have h0 : Complex.normSq (panelPoint t N) = 0 := by rw [h]; simp
    have hq0 : (panelQ t N : ℝ) = 0 := by rw [hcast, h0]
    exact hqne hq0
  have hsq_re : ((panelPoint t N) ^ 2).re =
      (panelReW N) ^ 2 - (panelImW t) ^ 2 := by
    rw [pow_two, Complex.mul_re, panelPoint_re, panelPoint_im]
    unfold panelReW panelImW
    push_cast
    ring
  have hsq_norm : Complex.normSq ((panelPoint t N) ^ 2) = (panelQ t N) ^ 2 := by
    rw [pow_two, Complex.normSq_mul, ← pow_two, ← hcast]
  calc (1 / (12 * (panelPoint t N) ^ 2)).re
      = (1 / 12 : ℝ) * (((panelPoint t N) ^ 2)⁻¹).re := by
        rw [show (1 / (12 * (panelPoint t N) ^ 2) : ℂ) =
          (1 / 12 : ℂ) * (((panelPoint t N) ^ 2)⁻¹) by
          rw [div_eq_mul_inv, mul_inv]
          norm_num]
        rw [Complex.mul_re]
        norm_num
    _ = (1 / 12 : ℝ) * (((panelPoint t N) ^ 2).re /
          Complex.normSq ((panelPoint t N) ^ 2)) := by rw [Complex.inv_re]
    _ = (((panelReW N ^ 2 - panelImW t ^ 2) / (12 * panelQ t N ^ 2) : ℚ) : ℝ) := by
        rw [hsq_re, hsq_norm]
        unfold panelReW panelImW panelQ
        push_cast
        field_simp

lemma panel_term4 (t : ℚ) (N : ℕ) :
    (1 / (120 * (panelPoint t N) ^ 4)).re =
      (((((panelReW N ^ 2 - panelImW t ^ 2) ^ 2 -
          (2 * panelReW N * panelImW t) ^ 2) /
        (120 * panelQ t N ^ 4)) : ℚ) : ℝ) := by
  have hqpos : 0 < panelQ t N := panelQ_pos t N
  have hqne : (panelQ t N : ℝ) ≠ 0 := ne_of_gt (by exact_mod_cast hqpos)
  have hcast : (panelQ t N : ℝ) = Complex.normSq (panelPoint t N) := panelQ_cast t N
  have hw : panelPoint t N ≠ 0 := by
    intro h
    have h0 : Complex.normSq (panelPoint t N) = 0 := by rw [h]; simp
    have hq0 : (panelQ t N : ℝ) = 0 := by rw [hcast, h0]
    exact hqne hq0
  have h2re : ((panelPoint t N) ^ 2).re =
      (panelReW N) ^ 2 - (panelImW t) ^ 2 := by
    rw [pow_two, Complex.mul_re, panelPoint_re, panelPoint_im]
    unfold panelReW panelImW
    push_cast
    ring
  have h2im : ((panelPoint t N) ^ 2).im = 2 * (panelReW N) * (panelImW t) := by
    rw [pow_two, Complex.mul_im, panelPoint_re, panelPoint_im]
    unfold panelReW panelImW
    push_cast
    ring
  have h4re : (((panelPoint t N) ^ 2) ^ 2).re =
      (((panelPoint t N) ^ 2).re) ^ 2 - (((panelPoint t N) ^ 2).im) ^ 2 := by
    rw [pow_two, Complex.mul_re]
    ring
  have h2norm : Complex.normSq ((panelPoint t N) ^ 2) = (panelQ t N) ^ 2 := by
    rw [pow_two, Complex.normSq_mul, ← pow_two, ← hcast]
  have h4norm : Complex.normSq (((panelPoint t N) ^ 2) ^ 2) =
      (panelQ t N) ^ 4 := by
    rw [pow_two, Complex.normSq_mul, h2norm]
    ring
  calc (1 / (120 * (panelPoint t N) ^ 4)).re
      = (1 / 120 : ℝ) * (((((panelPoint t N) ^ 2) ^ 2))⁻¹).re := by
        rw [show (1 / (120 * (panelPoint t N) ^ 4) : ℂ) =
          (1 / 120 : ℂ) * (((((panelPoint t N) ^ 2) ^ 2))⁻¹) by
          rw [div_eq_mul_inv, mul_inv]
          norm_num
          ring]
        rw [Complex.mul_re]
        norm_num
    _ = (1 / 120 : ℝ) * (((((panelPoint t N) ^ 2) ^ 2)).re /
          Complex.normSq (((panelPoint t N) ^ 2) ^ 2)) := by rw [Complex.inv_re]
    _ = (((((panelReW N ^ 2 - panelImW t ^ 2) ^ 2 -
          (2 * panelReW N * panelImW t) ^ 2) /
        (120 * panelQ t N ^ 4)) : ℚ) : ℝ) := by
        rw [h4re, h2re, h2im, h4norm]
        unfold panelReW panelImW panelQ
        push_cast
        field_simp

noncomputable def sPoint (t : ℚ) : ℂ := (1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I

lemma sPoint_add_nat (t : ℚ) (k : ℕ) :
    sPoint t + (k : ℂ) = panelPoint t k := by
  unfold sPoint panelPoint
  ring

lemma panel_inv_re (t : ℚ) (N : ℕ) :
    (1 / panelPoint t N).re = ((panelReW N / panelQ t N : ℚ) : ℝ) := by
  have hqpos : 0 < panelQ t N := panelQ_pos t N
  have hqne : (panelQ t N : ℝ) ≠ 0 := ne_of_gt (by exact_mod_cast hqpos)
  have hcast : (panelQ t N : ℝ) = Complex.normSq (panelPoint t N) := panelQ_cast t N
  have hw : panelPoint t N ≠ 0 := by
    intro h
    have h0 : Complex.normSq (panelPoint t N) = 0 := by rw [h]; simp
    have hq0 : (panelQ t N : ℝ) = 0 := by rw [hcast, h0]
    exact hqne hq0
  calc (1 / panelPoint t N).re = ((panelPoint t N)⁻¹).re := by rw [one_div]
    _ = (panelPoint t N).re / Complex.normSq (panelPoint t N) := by rw [Complex.inv_re]
    _ = ((panelReW N / panelQ t N : ℚ) : ℝ) := by
        rw [panelPoint_re, ← hcast]
        unfold panelReW
        push_cast
        ring

lemma panel_sum_re (t : ℚ) (N : ℕ) :
    (∑ k ∈ Finset.range N, (1 / (sPoint t + (k : ℂ))).re) =
      ((∑ k ∈ Finset.range N, (panelReW k / panelQ t k : ℚ)) : ℝ) := by
  rw [show (∑ k ∈ Finset.range N, (1 / (sPoint t + (k : ℂ))).re) =
      ∑ k ∈ Finset.range N, ((panelReW k / panelQ t k : ℚ) : ℝ) by
    apply Finset.sum_congr rfl
    intro k hk
    rw [sPoint_add_nat, panel_inv_re]]

noncomputable def panelR (t : ℚ) (N : ℕ) : ℂ :=
  (1 / (Nat.factorial 5 : ℂ)) *
    ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + panelPoint t N)⁻¹) x

lemma re_digamma_shifted (N : ℕ) (t : ℚ) (ht : t ≠ 0) :
    (Complex.digamma (sPoint t)).re =
      (Complex.log (panelPoint t N)).re
      - (1 / (2 * panelPoint t N)).re
      - (1 / (12 * (panelPoint t N) ^ 2)).re
      + (1 / (120 * (panelPoint t N) ^ 4)).re
      - (panelR t N).re
      - (∑ k ∈ Finset.range N, (1 / (sPoint t + (k : ℂ))).re) := by
  have hs : 0 < (sPoint t).re := by
    simp [sPoint]
  have hsi : (sPoint t).im ≠ 0 := by
    intro h
    have him : (sPoint t).im = (t : ℝ) / 2 := by simp [sPoint]
    rw [him] at h
    have ht0 : (t : ℝ) = 0 := by linarith
    exact ht (by exact_mod_cast ht0)
  have hexp := digamma_shifted_expansion N hs hsi
  rw [sPoint_add_nat] at hexp
  have hre := congrArg Complex.re hexp
  simp only [Complex.sub_re, Complex.add_re, Complex.re_sum, panelR] at hre
  simpa [panelR, one_div] using hre

lemma Omega_eq_digamma (t : ℚ) :
    Omega (t : ℝ) = (Complex.digamma (sPoint t)).re - Real.log Real.pi := by
  unfold Omega
  have harg : ((1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I) = sPoint t := by
    unfold sPoint
    push_cast
    ring
  rw [harg]
  ring

def omegaRem (N : ℕ) : ℚ := 1 / (81 * (panelReW N) ^ 5)

def omegaTerm4 (t : ℚ) (N : ℕ) : ℚ :=
  (((panelReW N) ^ 2 - (panelImW t) ^ 2) ^ 2 - (2 * panelReW N * panelImW t) ^ 2) /
    (120 * (panelQ t N) ^ 4)

def omegaSum (t : ℚ) (N : ℕ) : ℚ :=
  ∑ k ∈ Finset.range N, panelReW k / panelQ t k

def omegaLo (t : ℚ) (N M : ℕ) : ℚ :=
  (1 / 2) * logPointLo M (panelQ t N)
    - panelReW N / (2 * panelQ t N)
    - ((panelReW N) ^ 2 - (panelImW t) ^ 2) / (12 * (panelQ t N) ^ 2)
    + omegaTerm4 t N
    - omegaRem N
    - omegaSum t N
    - logPointHi M piHi

def omegaHi (t : ℚ) (N M : ℕ) : ℚ :=
  (1 / 2) * logPointHi M (panelQ t N)
    - panelReW N / (2 * panelQ t N)
    - ((panelReW N) ^ 2 - (panelImW t) ^ 2) / (12 * (panelQ t N) ^ 2)
    + omegaTerm4 t N
    + omegaRem N
    - omegaSum t N
    - logPointLo M piLo

theorem omega_mem (t : ℚ) (N M : ℕ) (hN : 1 ≤ N) (ht : t ≠ 0) :
    (omegaLo t N M : ℝ) ≤ Omega (t : ℝ) ∧ Omega (t : ℝ) ≤ (omegaHi t N M : ℝ) := by
  rw [Omega_eq_digamma, re_digamma_shifted N t ht]
  have hlog := panel_log_re_mem t N hN M
  have ht1 := panel_term1 t N
  have ht2 := panel_term2 t N
  have ht4 := panel_term4 t N
  have hsum := panel_sum_re t N
  have hpi := log_pi_mem M
  have hre : 0 < (panelPoint t N).re := by
    rw [panelPoint_re]
    have : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
    linarith
  have him : (panelPoint t N).im ≠ 0 := by
    rw [panelPoint_im]
    intro h
    have ht0 : (t : ℝ) = 0 := by linarith
    exact ht (by exact_mod_cast ht0)
  have hrem := norm_remainder_five_le (w := panelPoint t N) hre him
  have hreR : |(panelR t N).re| ≤ ‖panelR t N‖ := Complex.abs_re_le_norm _
  have hremR : ‖panelR t N‖ ≤ 1 / (81 * (panelReW N : ℝ) ^ 5) := by
    have h := hrem
    rw [panelPoint_re] at h
    unfold panelReW
    push_cast at h ⊢
    simpa [panelR, norm_mul] using h
  have hRbound := abs_le.mp (le_trans hreR hremR)
  rw [ht1, ht2, ht4, hsum]
  unfold omegaLo omegaHi omegaRem omegaTerm4 omegaSum
  push_cast
  set A : ℝ := (Complex.log (panelPoint t N)).re
  set B : ℝ := (panelR t N).re
  set C : ℝ := Real.log Real.pi
  set rem : ℝ := 1 / (81 * (panelReW N : ℝ) ^ 5)
  have hA1 : (1 / 2) * (logPointLo M (panelQ t N) : ℝ) ≤ A := hlog.1
  have hA2 : A ≤ (1 / 2) * (logPointHi M (panelQ t N) : ℝ) := hlog.2
  have hB1 : -rem ≤ B := hRbound.1
  have hB2 : B ≤ rem := hRbound.2
  have hC1 : (logPointLo M piLo : ℝ) ≤ C := hpi.1
  have hC2 : C ≤ (logPointHi M piHi : ℝ) := hpi.2
  have hlow : (omegaLo t N M : ℝ) - Omega (t : ℝ) =
      -((A - (1 / 2) * (logPointLo M (panelQ t N) : ℝ)) +
        (rem - B) + ((logPointHi M piHi : ℝ) - C)) := by
    simp only [A, B, C, rem]
    rw [Omega_eq_digamma, re_digamma_shifted N t ht, ht1, ht2, ht4, hsum]
    unfold omegaLo omegaRem omegaTerm4 omegaSum
    push_cast
    ring
  have hhigh : (omegaHi t N M : ℝ) - Omega (t : ℝ) =
      ((1 / 2) * (logPointHi M (panelQ t N) : ℝ) - A) +
        (rem + B) + (C - (logPointLo M piLo : ℝ)) := by
    simp only [A, B, C, rem]
    rw [Omega_eq_digamma, re_digamma_shifted N t ht, ht1, ht2, ht4, hsum]
    unfold omegaHi omegaRem omegaTerm4 omegaSum
    push_cast
    ring
  constructor
  · linarith [hlow, hA1, hB2, hC2]
  · linarith [hhigh, hA2, hB1, hC1]

lemma mul_between (w lo hi x : ℝ) (hlo : lo ≤ x) (hhi : x ≤ hi) :
    min (w * lo) (w * hi) ≤ w * x ∧ w * x ≤ max (w * lo) (w * hi) := by
  constructor
  · rcases le_total 0 w with hw | hw
    · exact (min_le_left _ _).trans (mul_le_mul_of_nonneg_left hlo hw)
    · exact (min_le_right _ _).trans (mul_le_mul_of_nonpos_left hhi hw)
  · rcases le_total 0 w with hw | hw
    · exact (mul_le_mul_of_nonneg_left hhi hw).trans (le_max_right _ _)
    · exact (mul_le_mul_of_nonpos_left hlo hw).trans (le_max_left _ _)

noncomputable def densityWeight (σ c t : ℝ) : ℝ :=
  σ ^ 2 * Real.exp (-(σ ^ 2 * t ^ 2)) * Real.cos (c * t)

noncomputable def density (σ c : ℝ) : ℝ :=
  ∫ t in Set.Ioi 0, densityWeight σ c t * Omega t

theorem density_mem {σ c : ℝ} {lo hi : ℝ → ℝ}
    (hlo : ∀ t ∈ Set.Ioi 0, lo t ≤ Omega t)
    (hhi : ∀ t ∈ Set.Ioi 0, Omega t ≤ hi t)
    (hint_min : IntegrableOn (fun t : ℝ =>
      min (densityWeight σ c t * lo t) (densityWeight σ c t * hi t)) (Set.Ioi 0))
    (hint_max : IntegrableOn (fun t : ℝ =>
      max (densityWeight σ c t * lo t) (densityWeight σ c t * hi t)) (Set.Ioi 0))
    (hint_om : IntegrableOn (fun t : ℝ => densityWeight σ c t * Omega t) (Set.Ioi 0)) :
    (∫ t in Set.Ioi 0,
        min (densityWeight σ c t * lo t) (densityWeight σ c t * hi t)) ≤ density σ c ∧
    density σ c ≤ (∫ t in Set.Ioi 0,
        max (densityWeight σ c t * lo t) (densityWeight σ c t * hi t)) := by
  constructor
  · rw [density]
    apply MeasureTheory.integral_mono_ae hint_min hint_om
    filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
    exact (mul_between (densityWeight σ c t) (lo t) (hi t) (Omega t) (hlo t ht) (hhi t ht)).1
  · rw [density]
    apply MeasureTheory.integral_mono_ae hint_om hint_max
    filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
    exact (mul_between (densityWeight σ c t) (lo t) (hi t) (Omega t) (hlo t ht) (hhi t ht)).2

lemma abs_sub_le_of_abs_deriv_le {f : ℝ → ℝ} {a b L : ℝ}
    (hf : ContinuousOn f (Set.Icc a b))
    (hfd : DifferentiableOn ℝ f (Set.Ioo a b))
    (hL : ∀ x ∈ Set.Ioo a b, |deriv f x| ≤ L)
    {x y : ℝ} (hx : x ∈ Set.Icc a b) (hy : y ∈ Set.Icc a b) (hxy : x ≤ y) :
    |f y - f x| ≤ L * (y - x) := by
  have hconv : Convex ℝ (Set.Icc a b) := convex_Icc a b
  have hint : interior (Set.Icc a b) = Set.Ioo a b := interior_Icc
  have hfd' : DifferentiableOn ℝ f (interior (Set.Icc a b)) := by
    rwa [hint]
  have hL' : ∀ z ∈ interior (Set.Icc a b), |deriv f z| ≤ L := by
    intro z hz
    exact hL z (by rwa [hint] at hz)
  have h1 : f y - f x ≤ L * (y - x) :=
    Convex.image_sub_le_mul_sub_of_deriv_le hconv hf hfd'
      (fun z hz => (abs_le.mp (hL' z hz)).2) x hx y hy hxy
  have h2 : -L * (y - x) ≤ f y - f x :=
    Convex.mul_sub_le_image_sub_of_le_deriv hconv hf hfd'
      (fun z hz => (abs_le.mp (hL' z hz)).1) x hx y hy hxy
  rw [abs_le]
  constructor <;> linarith

lemma Omega_eq_Psi (t : ℝ) :
    Omega t = -Real.log Real.pi + (Rh45.Psi t).re := by
  unfold Omega Rh45.Psi Rh45.digammaLine
  ring_nf

lemma continuous_Omega : Continuous Omega := by
  have h : Omega = fun t : ℝ => -Real.log Real.pi + (Rh45.Psi t).re := by
    funext t
    exact Omega_eq_Psi t
  rw [h]
  exact (Complex.continuous_re.comp Rh45.continuous_Psi).const_add _

lemma differentiableAt_Psi' (t : ℝ) : DifferentiableAt ℝ Rh45.Psi t := by
  have hψ : DifferentiableAt ℂ Complex.digamma (Rh45.digammaLine t) :=
    Rh45.differentiableAt_digamma_line t
  have hline : DifferentiableAt ℝ Rh45.digammaLine t := by
    unfold Rh45.digammaLine
    fun_prop
  exact (hψ.restrictScalars (𝕜 := ℝ) (𝕜' := ℂ)).comp t hline

lemma deriv_Omega_eq (t : ℝ) :
    deriv Omega t = (iteratedDeriv 1 Rh45.Psi t).re := by
  have hfun : Omega = fun t => -Real.log Real.pi + (Rh45.Psi t).re := by
    funext t
    exact Omega_eq_Psi t
  rw [hfun]
  have hd : HasDerivAt (fun t : ℝ => -Real.log Real.pi + (Rh45.Psi t).re)
      ((deriv Rh45.Psi t).re) t := by
    have h1 : HasDerivAt (fun t : ℝ => (Rh45.Psi t).re) ((deriv Rh45.Psi t).re) t := by
      have hf : HasFDerivAt Rh45.Psi (fderiv ℝ Rh45.Psi t) t :=
        (differentiableAt_Psi' t).hasFDerivAt
      have hcomp := Complex.reCLM.hasFDerivAt.comp t hf
      exact hcomp.hasDerivAt
    exact h1.const_add _
  rw [hd.deriv, iteratedDeriv_one]

lemma abs_deriv_Omega_le (t : ℝ) :
    |deriv Omega t| ≤ Rh45.psiSeriesBound 1 := by
  rw [deriv_Omega_eq]
  have h1 : |(iteratedDeriv 1 Rh45.Psi t).re| ≤ ‖iteratedDeriv 1 Rh45.Psi t‖ :=
    Complex.abs_re_le_norm _
  have h2 := Rh45.archimedean_deriv_bound 1 (by norm_num) t
  linarith

lemma differentiableAt_Omega (t : ℝ) : DifferentiableAt ℝ Omega t := by
  have hfun : Omega = fun t : ℝ => -Real.log Real.pi + (Rh45.Psi t).re := by
    funext t
    exact Omega_eq_Psi t
  rw [hfun]
  exact ((Complex.reCLM.differentiableAt.comp t (differentiableAt_Psi' t)).const_add _)

lemma Omega_panel_global (a b : ℝ) (hab : a ≤ b) {t : ℝ} (ht : t ∈ Set.Icc a b) :
    Omega a - Rh45.psiSeriesBound 1 * (t - a) ≤ Omega t ∧
    Omega t ≤ Omega a + Rh45.psiSeriesBound 1 * (t - a) := by
  have hat : a ≤ t := ht.1
  have h := abs_sub_le_of_abs_deriv_le (f := Omega) (a := a) (b := b)
    (L := Rh45.psiSeriesBound 1)
    (continuous_Omega.continuousOn)
    (fun x _ => (differentiableAt_Omega x).differentiableWithinAt)
    (fun x _ => abs_deriv_Omega_le x)
    (Set.left_mem_Icc.mpr hab) ht hat
  rw [abs_le] at h
  constructor <;> linarith [h.1, h.2]

lemma norm_polygamma_term_sq (t : ℝ) (j : ℕ) :
    ‖((1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)) ^ (-2 : ℤ)‖ =
      (((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ := by
  have hz : ((1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)) ≠ 0 := by
    intro h
    have hre := congrArg Complex.re h
    simp at hre
    have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    linarith
  have hsq : ‖((1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)) ^ 2‖ =
      ((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
    rw [show ((1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)) ^ 2 =
      ((1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)) *
        ((1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)) by ring]
    rw [norm_mul, ← sq]
    have hnorm : ‖(1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I + (j : ℂ)‖ ^ 2 =
        ((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      simp
      ring
    exact hnorm
  rw [zpow_neg, norm_inv, inv_inj]
  exact hsq

noncomputable def sPointR (t : ℝ) : ℂ := (1 / 4 : ℂ) + ((t : ℂ) / 2) * Complex.I

lemma sPointR_re (t : ℝ) : (sPointR t).re = 1 / 4 := by
  simp [sPointR]

lemma sPointR_eq_digammaLine (t : ℝ) : sPointR t = Rh45.digammaLine t := by
  unfold sPointR Rh45.digammaLine
  ring

lemma hasSum_polygamma_sq (t : ℝ) :
    HasSum (fun j : ℕ => (sPointR t + (j : ℂ)) ^ (-2 : ℤ))
      (deriv Complex.digamma (sPointR t)) := by
  have hs : 0 < (Rh45.digammaLine t).re := by
    rw [Rh45.digammaLine_re]
    norm_num
  have h := Rh45RouteBAnalytic.digamma_polygamma_series 1 (by norm_num) (s := Rh45.digammaLine t) hs
  rw [sPointR_eq_digammaLine]
  convert h using 1
  · ext j
    congr 1
  · have hc : (((-1 : ℂ) ^ (1 + 1) * (Nat.factorial 1 : ℂ))⁻¹) = 1 := by norm_num
    simp only [Complex.digamma_def, Function.iterate_one]
    rw [hc, one_mul]

lemma norm_deriv_digamma_le_tsum (t : ℝ) :
    ‖deriv Complex.digamma (sPointR t)‖ ≤
      ∑' j : ℕ, ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ := by
  have h := hasSum_polygamma_sq t
  calc ‖deriv Complex.digamma (sPointR t)‖
      = ‖∑' j : ℕ, (sPointR t + (j : ℂ)) ^ (-2 : ℤ)‖ := by rw [h.tsum_eq]
    _ ≤ ∑' j : ℕ, ‖(sPointR t + (j : ℂ)) ^ (-2 : ℤ)‖ :=
        norm_tsum_le_tsum_norm h.summable.norm
    _ = ∑' j : ℕ, ((((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ := by
        apply tsum_congr
        intro j
        exact norm_polygamma_term_sq t j

end IntersectionForm
