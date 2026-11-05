import Mathlib
import DensityEnclosure

/-!
# R2 — the `t`-dependent derivative bound for `Ω`

The panel budget of R2 needs a bound on `|Ω′|` that decays in `t`; the global
bound `psiSeriesBound 1 ≈ 8.6` is far too coarse for panels at large `t`.

From the shared library's polygamma series
(`PanelEnclosure.norm_deriv_digamma_le_tsum`) and the chain rule
(`Rh45.iteratedDeriv_Psi_eq`) we get

```
|Ω′(t)| ≤ ½ Σ_{j≥0} ((j+1/4)² + t²/4)⁻¹,
```

and the elementary sum bound `Σ_{j≥0} ((j+1/4)²+a²)⁻¹ ≤ 1/a² + 4/a` gives

```
|Ω′(t)| ≤ 6/t      (t ≥ 2).
```

The sum bound is proved without integrals or `π`: split at `K = ⌈a⌉ + 1`, use
`1/((j+1/4)²+a²) ≤ 1/a²` below `K` and the telescoping
`1/(j+K)² ≤ 1/((j+K−1)(j+K))` above it.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- `|Ω′(t)|` bounded by half the polygamma series. -/
theorem deriv_Omega_abs_le_tsum (t : ℝ) :
    |deriv IntersectionForm.Omega t| ≤
      (1 / 2) * ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ := by
  have hnorm : ‖iteratedDeriv 1 Rh45.Psi t‖ =
      (1 / 2) * ‖deriv Complex.digamma (Rh45.digammaLine t)‖ := by
    rw [Rh45.iteratedDeriv_Psi_eq, iteratedDeriv_one, norm_mul, norm_pow, Rh45.norm_half_I]
    norm_num
  have h2 := IntersectionForm.norm_deriv_digamma_le_tsum t
  have h3 : ‖deriv Complex.digamma (Rh45.digammaLine t)‖ =
      ‖deriv Complex.digamma (IntersectionForm.sPointR t)‖ := by
    rw [IntersectionForm.sPointR_eq_digammaLine]
  calc |deriv IntersectionForm.Omega t|
      = |(iteratedDeriv 1 Rh45.Psi t).re| := by rw [IntersectionForm.deriv_Omega_eq]
    _ ≤ ‖iteratedDeriv 1 Rh45.Psi t‖ := Complex.abs_re_le_norm _
    _ = (1 / 2) * ‖deriv Complex.digamma (IntersectionForm.sPointR t)‖ := by rw [hnorm, h3]
    _ ≤ (1 / 2) * ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ := by
        linarith [h2]

/-- The head of the split: `K` terms below `K` cost `K/a²`. -/
theorem sum_range_head_le {a : ℝ} (ha : 0 < a) (K : ℕ) :
    ∑ j ∈ Finset.range K, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ K / a ^ 2 := by
  calc ∑ j ∈ Finset.range K, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
      ≤ ∑ _j ∈ Finset.range K, (a ^ 2)⁻¹ := by
        refine Finset.sum_le_sum fun j _ => ?_
        rw [inv_le_inv₀ (by positivity) (by positivity)]
        nlinarith [sq_nonneg ((j : ℝ) + 1 / 4)]
    _ = K / a ^ 2 := by
        rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
        ring

/-- The telescoping step: `1/(m+K)² ≤ 1/(m+K−1) − 1/(m+K)`. -/
theorem tail_step {K : ℕ} (hK : 2 ≤ K) (m : ℕ) :
    ((((m + K : ℕ) : ℝ)) ^ 2)⁻¹ ≤ 1 / ((m : ℝ) + K - 1) - 1 / ((m : ℝ) + K) := by
  have hK2 : (2 : ℝ) ≤ K := by exact_mod_cast hK
  have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  have hj : (0 : ℝ) < (m : ℝ) + K - 1 := by linarith
  have hj2 : (0 : ℝ) < (m : ℝ) + K := by linarith
  have hcast : (((m + K : ℕ) : ℝ)) = (m : ℝ) + K := by push_cast; ring
  rw [hcast, div_sub_div _ _ hj.ne' hj2.ne']
  rw [show 1 * ((m : ℝ) + K) - ((m : ℝ) + K - 1) * 1 = 1 by ring, one_div]
  rw [inv_le_inv₀ (by positivity) (by positivity)]
  nlinarith

/-- The tail of the split: `m` terms from `K` on cost less than `1/(K−1)`. -/
theorem sum_range_tail_le {K : ℕ} (hK : 2 ≤ K) (m : ℕ) :
    ∑ j ∈ Finset.range m, ((((j + K : ℕ) : ℝ)) ^ 2)⁻¹ ≤ 1 / ((K : ℝ) - 1) := by
  have hK2 : (2 : ℝ) ≤ K := by exact_mod_cast hK
  have hmain : ∀ m : ℕ,
      ∑ j ∈ Finset.range m, ((((j + K : ℕ) : ℝ)) ^ 2)⁻¹ ≤
        1 / ((K : ℝ) - 1) - 1 / ((m : ℝ) + K - 1) := by
    intro m
    induction m with
    | zero => simp
    | succ m ih =>
        rw [Finset.sum_range_succ]
        have hstep := tail_step hK m
        have hpos : (0 : ℝ) < (m : ℝ) + K - 1 := by
          have : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
          linarith
        have hidx : ((m + 1 : ℕ) : ℝ) + K - 1 = (m : ℝ) + K := by push_cast; ring
        rw [hidx]
        linarith
  have hpos : (0 : ℝ) ≤ 1 / ((m : ℝ) + K - 1) := by
    apply div_nonneg (by norm_num)
    have : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  linarith [hmain m]

/-- **The sum bound.** For `a ≥ 2`, `Σ_j ((j+1/4)² + a²)⁻¹ ≤ 6/a`. -/
theorem tsum_shifted_inv_le {a : ℝ} (ha : 2 ≤ a) :
    ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ 6 / a := by
  have ha0 : (0 : ℝ) < a := by linarith
  refine Real.tsum_le_of_sum_range_le (fun j => by positivity) (fun N => ?_)
  set K : ℕ := Nat.ceil a + 1 with hKdef
  have hceil : a ≤ (Nat.ceil a : ℝ) := Nat.le_ceil a
  have hKval : (K : ℝ) = (Nat.ceil a : ℝ) + 1 := by rw [hKdef]; push_cast; ring
  have hK2 : 2 ≤ K := by
    have h2 : (2 : ℝ) ≤ (Nat.ceil a : ℝ) := le_trans ha hceil
    have h3 : 2 ≤ Nat.ceil a := by exact_mod_cast h2
    omega
  have hhead : ∑ j ∈ Finset.range K, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ (a + 2) / a ^ 2 := by
    refine le_trans (sum_range_head_le ha0 K) ?_
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    have h1 : (Nat.ceil a : ℝ) < a + 1 := Nat.ceil_lt_add_one (by linarith)
    have h2 : (K : ℝ) ≤ a + 2 := by rw [hKval]; linarith
    nlinarith [h2, sq_nonneg a]
  have htail : ∑ j ∈ Finset.range N, ((((K + j : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ 1 / a := by
    have hstep : ∀ j : ℕ, ((((K + j : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
        ≤ ((((j + K : ℕ) : ℝ)) ^ 2)⁻¹ := by
      intro j
      rw [inv_le_inv₀ (by positivity) (by positivity)]
      have hcast : ((K + j : ℕ) : ℝ) = ((j + K : ℕ) : ℝ) := by
        rw [Nat.add_comm K j]
      rw [hcast]
      nlinarith [Nat.cast_nonneg (α := ℝ) (j + K), sq_nonneg (((j + K : ℕ) : ℝ))]
    refine le_trans (le_trans (Finset.sum_le_sum fun j _ => hstep j) (sum_range_tail_le hK2 N)) ?_
    apply one_div_le_one_div_of_le ha0
    rw [hKval]; linarith
  have hmono : ∑ j ∈ Finset.range N, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
      ≤ ∑ j ∈ Finset.range (K + N), (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ := by
    refine Finset.sum_le_sum_of_subset_of_nonneg (Finset.range_mono (Nat.le_add_left N K)) ?_
    intro j _ _
    positivity
  rw [Finset.sum_range_add] at hmono
  have hfinal : (a + 2) / a ^ 2 + 1 / a ≤ 6 / a := by
    have h : (a + 2) / a ^ 2 + 1 / a = (a + 2 + a) / a ^ 2 := by
      field_simp
    rw [h, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [sq_nonneg a, ha]
  have step1 : ∑ j ∈ Finset.range N, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
      ≤ (a + 2) / a ^ 2 + 1 / a := by
    linarith [hmono, hhead, htail]
  linarith [step1, hfinal]

/-- **The `t`-dependent derivative bound.** `|Ω′(t)| ≤ 6/t` for `t ≥ 4`. -/
theorem deriv_Omega_abs_le {t : ℝ} (ht : 4 ≤ t) :
    |deriv IntersectionForm.Omega t| ≤ 6 / t := by
  have h1 := deriv_Omega_abs_le_tsum t
  have ha : (2 : ℝ) ≤ t / 2 := by linarith
  have h2 := tsum_shifted_inv_le ha
  have h3 : (1 / 2 : ℝ) * (6 / (t / 2)) = 6 / t := by
    field_simp
  calc |deriv IntersectionForm.Omega t|
      ≤ (1 / 2) * ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ := h1
    _ ≤ (1 / 2) * (6 / (t / 2)) := by linarith
    _ = 6 / t := h3


end PrimeSpectrumTensor
