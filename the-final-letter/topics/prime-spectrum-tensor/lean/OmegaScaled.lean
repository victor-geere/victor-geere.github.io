import PanelEnclosure

/-!
# A cheap pointwise enclosure of `Ω`

`IntersectionForm.omega_mem` encloses `Ω t` by evaluating the `log` series of
`panelQ t N = (N+1/4)² + t²/4` directly.  At `t = 60` this is `q ≈ 900`, so the
atanh series ratio is `(q−1)/(q+1) ≈ 0.998` and several thousand terms are
needed — far too slow to `native_decide` on every panel.

The identity

```
log q = log (q / 4^j) + j log 4
```

reduces the argument to `[1, 4)`, where the ratio is at most `3/5` and a few
dozen terms give full precision.  This file mirrors `omega_mem` with that
scaled log; the remainder in the digamma asymptotic expansion is unchanged
(`1/(81 (N+1/4)^5)`), so `N = 4` already gives a bracket of width `~2·10⁻⁵`.
-/

open Complex Filter MeasureTheory
open scoped Topology BigOperators

namespace IntersectionForm

/-- A rational enclosure of `log 4` (from the atanh series, ratio `3/5`). -/
def log4Lo : ℚ := logPointLo 60 4
def log4Hi : ℚ := logPointHi 60 4

theorem log4_mem : (log4Lo : ℝ) ≤ Real.log 4 ∧ Real.log 4 ≤ (log4Hi : ℝ) :=
  logPoint_mem 60 (x := (4 : ℚ)) (by norm_num)

/-- The log of `panelQ t N`, with the argument scaled into `[1, 4)` by `4^j`. -/
lemma panel_log_re_mem_scaled (t : ℚ) (N M j : ℕ) (hj : (4 : ℚ) ^ j ≤ panelQ t N) :
    (1 / 2) * ((logPointLo M (panelQ t N / 4 ^ j) : ℝ) + (j : ℝ) * (log4Lo : ℝ)) ≤
      (Complex.log (panelPoint t N)).re ∧
    (Complex.log (panelPoint t N)).re ≤
      (1 / 2) * ((logPointHi M (panelQ t N / 4 ^ j) : ℝ) + (j : ℝ) * (log4Hi : ℝ)) := by
  have hpowpos : (0 : ℚ) < (4 : ℚ) ^ j := by positivity
  have hqpos : 0 < panelQ t N := panelQ_pos t N
  have hq : (1 : ℚ) ≤ panelQ t N / 4 ^ j := by
    rw [one_le_div (by positivity)]
    exact hj
  have hmem := logPoint_mem M (x := panelQ t N / 4 ^ j) hq
  have h4 := log4_mem
  have hsplit : ((panelQ t N : ℚ) : ℝ) = ((panelQ t N / 4 ^ j : ℚ) : ℝ) * 4 ^ j := by
    push_cast
    field_simp
  have hlogeq : Real.log (panelQ t N : ℝ) =
      Real.log ((panelQ t N / 4 ^ j : ℚ) : ℝ) + (j : ℝ) * Real.log 4 := by
    rw [hsplit, Real.log_mul (by positivity) (by positivity), Real.log_pow]
  have hlogq : Real.log ((((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2 : ℚ) : ℝ) =
      Real.log ((panelQ t N / 4 ^ j : ℚ) : ℝ) + (j : ℝ) * Real.log 4 := by
    have h1 : ((((N : ℚ) + 1 / 4) ^ 2 + (t / 2) ^ 2 : ℚ) : ℝ) = ((panelQ t N : ℚ) : ℝ) := by
      unfold panelQ panelReW panelImW
      push_cast
      ring
    rw [h1]
    exact hlogeq
  rw [panel_log_re_eq]
  constructor
  · have h1 : (logPointLo M (panelQ t N / 4 ^ j) : ℝ) ≤
        Real.log ((panelQ t N / 4 ^ j : ℚ) : ℝ) := hmem.1
    have h2 : (log4Lo : ℝ) ≤ Real.log 4 := h4.1
    have hj0 : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    have h3 := mul_le_mul_of_nonneg_left h2 hj0
    rw [hlogq]
    linarith
  · have h1 : Real.log ((panelQ t N / 4 ^ j : ℚ) : ℝ) ≤
        (logPointHi M (panelQ t N / 4 ^ j) : ℝ) := hmem.2
    have h2 : Real.log 4 ≤ (log4Hi : ℝ) := h4.2
    have hj0 : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    have h3 := mul_le_mul_of_nonneg_left h2 hj0
    rw [hlogq]
    linarith

/-- The lower endpoint of the scaled `Ω` enclosure. -/
def omegaLoS (t : ℚ) (N M j : ℕ) : ℚ :=
  (1 / 2) * (logPointLo M (panelQ t N / 4 ^ j) + (j : ℚ) * log4Lo)
    - panelReW N / (2 * panelQ t N)
    - ((panelReW N) ^ 2 - (panelImW t) ^ 2) / (12 * (panelQ t N) ^ 2)
    + omegaTerm4 t N
    - omegaRem N
    - omegaSum t N
    - logPointHi M piHi

/-- The upper endpoint of the scaled `Ω` enclosure. -/
def omegaHiS (t : ℚ) (N M j : ℕ) : ℚ :=
  (1 / 2) * (logPointHi M (panelQ t N / 4 ^ j) + (j : ℚ) * log4Hi)
    - panelReW N / (2 * panelQ t N)
    - ((panelReW N) ^ 2 - (panelImW t) ^ 2) / (12 * (panelQ t N) ^ 2)
    + omegaTerm4 t N
    + omegaRem N
    - omegaSum t N
    - logPointLo M piLo

theorem omega_mem_scaled (t : ℚ) (N M j : ℕ) (hN : 1 ≤ N) (ht : t ≠ 0)
    (hj : (4 : ℚ) ^ j ≤ panelQ t N) :
    (omegaLoS t N M j : ℝ) ≤ Omega (t : ℝ) ∧
      Omega (t : ℝ) ≤ (omegaHiS t N M j : ℝ) := by
  rw [Omega_eq_digamma, re_digamma_shifted N t ht]
  have hlog := panel_log_re_mem_scaled t N M j hj
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
  unfold omegaLoS omegaHiS omegaRem omegaTerm4 omegaSum
  push_cast
  set A : ℝ := (Complex.log (panelPoint t N)).re
  set B : ℝ := (panelR t N).re
  set C : ℝ := Real.log Real.pi
  set rem : ℝ := 1 / (81 * (panelReW N : ℝ) ^ 5)
  have hA1 : (1 / 2) * ((logPointLo M (panelQ t N / 4 ^ j) : ℝ) +
      (j : ℝ) * (log4Lo : ℝ)) ≤ A := hlog.1
  have hA2 : A ≤ (1 / 2) * ((logPointHi M (panelQ t N / 4 ^ j) : ℝ) +
      (j : ℝ) * (log4Hi : ℝ)) := hlog.2
  have hC1 : (logPointLo M piLo : ℝ) ≤ C := hpi.1
  have hC2 : C ≤ (logPointHi M piHi : ℝ) := hpi.2
  have hlow : (omegaLoS t N M j : ℝ) - Omega (t : ℝ) =
      -((A - (1 / 2) * ((logPointLo M (panelQ t N / 4 ^ j) : ℝ) +
          (j : ℝ) * (log4Lo : ℝ))) +
        (rem - B) + ((logPointHi M piHi : ℝ) - C)) := by
    simp only [A, B, C, rem]
    rw [Omega_eq_digamma, re_digamma_shifted N t ht, ht1, ht2, ht4, hsum]
    unfold omegaLoS omegaRem omegaTerm4 omegaSum
    push_cast
    ring
  have hhigh : (omegaHiS t N M j : ℝ) - Omega (t : ℝ) =
      ((1 / 2) * ((logPointHi M (panelQ t N / 4 ^ j) : ℝ) +
          (j : ℝ) * (log4Hi : ℝ)) - A) +
        (rem + B) + (C - (logPointLo M piLo : ℝ)) := by
    simp only [A, B, C, rem]
    rw [Omega_eq_digamma, re_digamma_shifted N t ht, ht1, ht2, ht4, hsum]
    unfold omegaHiS omegaRem omegaTerm4 omegaSum
    push_cast
    ring
  constructor
  · linarith [hlow, hA1, hRbound.2, hC2]
  · linarith [hhigh, hA2, hRbound.1, hC1]

end IntersectionForm
