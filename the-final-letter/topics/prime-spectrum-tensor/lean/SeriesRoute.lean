import Mathlib
import GaussianGram

/-!
# W2 — the elementary core of the Euler-limit series route

The route of [`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) writes the archimedean
density as

```
Ω(t) = ψ(1/4) − log π + Σ_{k≥0} u_k(t),
u_k(t) = 1/(k+1/4) − (k+1/4)/((k+1/4)² + t²/4)  ≥ 0,
```

and truncates at `k = N`. This file proves the **truncation bound**

```
Σ_{k≥N} u_k(t) ≤ t² / (4 (N+1/4)²)      (N ≥ 2),
```

which is what makes the truncation usable: the error is `t²`-small, so after
multiplying by the Gaussian weight and integrating it costs only
`σ² · √π/(2σ³) / (4N²) = √π/(8σN²) ≈ 1.1/N²` — `1.1·10⁻⁴` at `N = 100`.

The proof needs no analysis beyond comparison and telescoping:

* `u_k(t) ≤ t²/(4 a_k³)` where `a_k = k + 1/4`;
* `1/a³ ≤ 1/a² − 1/(a+1)²` for `a ≥ 2` (checked by clearing denominators);
* the telescoping sum `Σ_{k=N}^{M} (1/a_k² − 1/a_{k+1}²) = 1/a_N² − 1/a_{M+1}²`.

The *identity* `Ω(t) = ψ(1/4) − log π + Σ u_k(t)` is **not** proved here: it is
the Euler-limit formula for `ψ`, which is R2's analytic half.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The `k`-th term of the Euler-limit series for `Re ψ(1/4 + it/2)`. -/
def omegaTerm (k : ℕ) (t : ℝ) : ℝ :=
  1 / ((k : ℝ) + 1 / 4) - ((k : ℝ) + 1 / 4) / (((k : ℝ) + 1 / 4) ^ 2 + t ^ 2 / 4)

theorem omegaTerm_nonneg (k : ℕ) (t : ℝ) : 0 ≤ omegaTerm k t := by
  unfold omegaTerm
  have ha : (0 : ℝ) < (k : ℝ) + 1 / 4 := by positivity
  have hd : (0 : ℝ) < ((k : ℝ) + 1 / 4) ^ 2 + t ^ 2 / 4 := by positivity
  rw [sub_nonneg, div_le_iff₀ hd]
  field_simp
  nlinarith [sq_nonneg t]

/-- The elementary bound `u_k(t) ≤ t²/(4 a_k³)`. -/
theorem omegaTerm_le (k : ℕ) (t : ℝ) :
    omegaTerm k t ≤ t ^ 2 / (4 * ((k : ℝ) + 1 / 4) ^ 3) := by
  unfold omegaTerm
  have ha : (0 : ℝ) < (k : ℝ) + 1 / 4 := by positivity
  have hd : (0 : ℝ) < ((k : ℝ) + 1 / 4) ^ 2 + t ^ 2 / 4 := by positivity
  rw [div_sub_div _ _ ha.ne' hd.ne']
  rw [show 1 * (((k : ℝ) + 1 / 4) ^ 2 + t ^ 2 / 4) - ((k : ℝ) + 1 / 4) * ((k : ℝ) + 1 / 4)
      = t ^ 2 / 4 by ring]
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith [sq_nonneg t, ha, sq_nonneg (t ^ 2)]

/-- `1/a³ ≤ 1/a² − 1/(a+1)²` for `a ≥ 2`. -/
theorem inv_cube_le {a : ℝ} (ha : 2 ≤ a) :
    1 / a ^ 3 ≤ 1 / a ^ 2 - 1 / (a + 1) ^ 2 := by
  have ha0 : (0 : ℝ) < a := by linarith
  have ha1 : (0 : ℝ) < a + 1 := by linarith
  rw [div_sub_div _ _ (by positivity) (by positivity)]
  rw [show 1 * (a + 1) ^ 2 - a ^ 2 * 1 = 2 * a + 1 by ring]
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  have hkey : (a + 1) ^ 2 ≤ (2 * a + 1) * a := by nlinarith
  nlinarith [hkey, ha, mul_pos ha0 ha0]

/-- The finite telescoping sum. -/
theorem sum_telescope (N M : ℕ) :
    ∑ k ∈ Finset.range M, (1 / ((k : ℝ) + N + 1 / 4) ^ 2 -
        1 / ((k : ℝ) + N + 1 + 1 / 4) ^ 2)
      = 1 / ((N : ℝ) + 1 / 4) ^ 2 - 1 / ((M : ℝ) + N + 1 / 4) ^ 2 := by
  induction M with
  | zero => simp
  | succ M ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      ring

/-- **The truncation bound.** For `N ≥ 2`,
`Σ_{k≥N} u_k(t) ≤ t²/(4 (N+1/4)²)`. -/
theorem sum_omegaTerm_tail_le (t : ℝ) {N : ℕ} (hN : 2 ≤ N) :
    ∑' k : ℕ, omegaTerm (k + N) t ≤ t ^ 2 / 4 * (1 / ((N : ℝ) + 1 / 4) ^ 2) := by
  refine Real.tsum_le_of_sum_range_le (fun k => omegaTerm_nonneg (k + N) t) (fun M => ?_)
  calc ∑ k ∈ Finset.range M, omegaTerm (k + N) t
      ≤ ∑ k ∈ Finset.range M, t ^ 2 / (4 * ((k : ℝ) + N + 1 / 4) ^ 3) := by
        refine Finset.sum_le_sum fun k _ => ?_
        have h := omegaTerm_le (k + N) t
        push_cast at h
        exact h
    _ ≤ ∑ k ∈ Finset.range M, t ^ 2 / 4 * (1 / ((k : ℝ) + N + 1 / 4) ^ 2 -
          1 / ((k : ℝ) + N + 1 + 1 / 4) ^ 2) := by
        refine Finset.sum_le_sum fun k _ => ?_
        have ha : (2 : ℝ) ≤ (k : ℝ) + N + 1 / 4 := by
          have : (2 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
          have : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
          linarith
        have h' : 1 / ((k : ℝ) + N + 1 / 4) ^ 3 ≤
            1 / ((k : ℝ) + N + 1 / 4) ^ 2 - 1 / ((k : ℝ) + N + 1 + 1 / 4) ^ 2 := by
          have h := inv_cube_le ha
          convert h using 2
          ring
        have ht : (0 : ℝ) ≤ t ^ 2 / 4 := by positivity
        calc t ^ 2 / (4 * ((k : ℝ) + N + 1 / 4) ^ 3)
            = t ^ 2 / 4 * (1 / ((k : ℝ) + N + 1 / 4) ^ 3) := by
                have hpos : (0 : ℝ) < ((k : ℝ) + N + 1 / 4) ^ 3 := by positivity
                field_simp
          _ ≤ t ^ 2 / 4 * (1 / ((k : ℝ) + N + 1 / 4) ^ 2 -
                1 / ((k : ℝ) + N + 1 + 1 / 4) ^ 2) :=
              mul_le_mul_of_nonneg_left h' ht
    _ = t ^ 2 / 4 * (1 / ((N : ℝ) + 1 / 4) ^ 2 -
          1 / ((M : ℝ) + N + 1 / 4) ^ 2) := by
        rw [← Finset.mul_sum, sum_telescope]
    _ ≤ t ^ 2 / 4 * (1 / ((N : ℝ) + 1 / 4) ^ 2) := by
        have hpos : (0 : ℝ) ≤ 1 / ((M : ℝ) + N + 1 / 4) ^ 2 := by positivity
        have ht : (0 : ℝ) ≤ t ^ 2 / 4 := by positivity
        exact mul_le_mul_of_nonneg_left (by linarith) ht

end PrimeSpectrumTensor
