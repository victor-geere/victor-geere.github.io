import Mathlib
import LipSmall

/-!
# The Lipschitz bound for `Ω`, from `t ≥ 1`

`LipSmall.deriv_Omega_abs_le_ten` gives `|Ω′| ≤ 10` for all `t`.
`DensityPanel.deriv_Omega_abs_le` gives `|Ω′| ≤ 6/t` only for `t ≥ 4`, because
its sum bound `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 6/a` was proved under `a ≥ 2`.

The same proof goes through for `a ≥ 1/2`: the head contributes `(a+2)/a²` and
the tail `1/a`, and

```
(a+2)/a² + 1/a = (2a+2)/a² ≤ 6/a   ⟺   a ≥ 1/2.
```

Hence `|Ω′(t)| ≤ 6/t` for `t ≥ 1`, which is the bound the density partition
uses on `[1,60]` (only `[0,1]` needs the global constant `10`).
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- **The head/tail estimate for the shifted sum.**  For `a ≥ 1/2` every finite
partial sum is at most `(a+2)/a² + 1/a`: the `K = ⌈a⌉+1` head terms cost at most
`K/a²`, and the tail is compared with the telescoping series `Σ 1/(j+K)² ≤ 1/K`.

This is the common core of every Lipschitz bound for `Ω`; the sharper constants
come from choosing a different head and a different final comparison. -/
theorem sum_range_shifted_inv_le {a : ℝ} (ha : 1 / 2 ≤ a) (N : ℕ) :
    ∑ j ∈ Finset.range N, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
      ≤ (a + 2) / a ^ 2 + 1 / a := by
  have ha0 : (0 : ℝ) < a := by linarith
  set K : ℕ := Nat.ceil a + 1 with hKdef
  have hceil : a ≤ (Nat.ceil a : ℝ) := Nat.le_ceil a
  have hKval : (K : ℝ) = (Nat.ceil a : ℝ) + 1 := by rw [hKdef]; push_cast; ring
  have hK2 : 2 ≤ K := by
    have h1 : 1 ≤ Nat.ceil a := Nat.ceil_pos.mpr (by linarith)
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
  linarith [hmono, hhead, htail]

/-- The `a ≥ 1/2` tsum bound `Σ ≤ 6/a`. -/
theorem tsum_shifted_inv_le_six {a : ℝ} (ha : 1 / 2 ≤ a) :
    ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ 6 / a := by
  have ha0 : (0 : ℝ) < a := by linarith
  refine Real.tsum_le_of_sum_range_le (fun j => by positivity) (fun N => ?_)
  have hmain := sum_range_shifted_inv_le ha N
  have hfinal : (a + 2) / a ^ 2 + 1 / a ≤ 6 / a := by
    have h : (a + 2) / a ^ 2 + 1 / a = (a + 2 + a) / a ^ 2 := by
      field_simp
    rw [h, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [sq_nonneg a, ha]
  linarith [hmain, hfinal]

/-- **The `t ≥ 1` Lipschitz bound.** `|Ω′(t)| ≤ 6/t` for `t ≥ 1`. -/
theorem deriv_Omega_abs_le_six {t : ℝ} (ht : 1 ≤ t) :
    |deriv IntersectionForm.Omega t| ≤ 6 / t := by
  have h1 := deriv_Omega_abs_le_tsum t
  have ha : (1 / 2 : ℝ) ≤ t / 2 := by linarith
  have h2 := tsum_shifted_inv_le_six ha
  have h3 : (1 / 2 : ℝ) * (6 / (t / 2)) = 6 / t := by
    field_simp
  calc |deriv IntersectionForm.Omega t|
      ≤ (1 / 2) * ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ := h1
    _ ≤ (1 / 2) * (6 / (t / 2)) := by linarith
    _ = 6 / t := h3

end PrimeSpectrumTensor
