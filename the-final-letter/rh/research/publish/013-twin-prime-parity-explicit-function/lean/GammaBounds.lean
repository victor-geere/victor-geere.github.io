/-
  GammaBounds.lean — elementary bounds for `Complex.Gamma` and `Complex.digamma`.

  The shape of the upstream Mathlib contribution identified in journal §111: bounds and asymptotics
  for `Γ` and `ψ` on vertical lines.  Both remaining interfaces of the 011 development
  (`CriticalStripLogDerivBound` on `1/2 ≤ σ ≤ 1`, and `DigammaGrowthBound σ0`) reduce to it.
-/
import DirichletMellinPrereq
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.NumberTheory.Harmonic.Bounds
import Mathlib.Analysis.MellinTransform
import Mathlib.Analysis.SpecialFunctions.Gamma.Deriv
import Mathlib.Analysis.Calculus.ParametricIntegral
import Mathlib.Analysis.Complex.Exponential
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Analysis.Complex.Hadamard
import Mathlib.Analysis.Complex.JensenFormula
import Mathlib.Analysis.Convex.SpecificFunctions.Basic
import Mathlib.Analysis.SpecialFunctions.Gamma.BohrMollerup
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.NumberTheory.MulChar.Basic
import Mathlib.NumberTheory.DirichletCharacter.Bounds

open MeasureTheory Complex Set Asymptotics Filter Metric

open scoped Topology

namespace RouteABC

noncomputable section

/-- **Elementary bound on `Γ`.**  For `Re s > 0`, `‖Γ s‖ ≤ Γ (Re s)`, from Euler's integral
`Γ s = ∫_{Ioi 0} x^{s-1} e^{-x}`: the triangle inequality turns it into the real integral at `Re s`. -/
theorem norm_Gamma_le_Gamma_re {s : ℂ} (hs : 0 < s.re) : ‖Gamma s‖ ≤ Real.Gamma s.re := by
  have h0 : ∀ x ∈ Set.Ioi (0 : ℝ),
      ‖↑(Real.exp (-x)) * (x : ℂ) ^ (s - 1)‖ = Real.exp (-x) * x ^ (s.re - 1) := by
    intro x hx
    rw [norm_mul, Complex.norm_of_nonneg (le_of_lt (Real.exp_pos _)),
      Complex.norm_cpow_eq_rpow_re_of_pos (Set.mem_Ioi.mp hx)]
    simp [Complex.sub_re]
  have hR : (∫ x in Set.Ioi (0 : ℝ), Real.exp (-x) * x ^ (s.re - 1)) = Real.Gamma s.re := by
    have h : ((∫ x in Set.Ioi (0 : ℝ), Real.exp (-x) * x ^ (s.re - 1) : ℝ) : ℂ)
        = ((Real.Gamma s.re : ℝ) : ℂ) := by
      rw [← Complex.GammaIntegral_ofReal (s.re),
        ← Complex.Gamma_eq_integral (s := ((s.re : ℝ) : ℂ)) (by simpa using hs),
        ← Complex.Gamma_ofReal s.re]
    exact_mod_cast h
  rw [Complex.Gamma_eq_integral hs, Complex.GammaIntegral]
  calc ‖∫ x in Set.Ioi (0 : ℝ), ↑(Real.exp (-x)) * (x : ℂ) ^ (s - 1)‖
      ≤ ∫ x in Set.Ioi (0 : ℝ), ‖↑(Real.exp (-x)) * (x : ℂ) ^ (s - 1)‖ :=
        norm_integral_le_integral_norm _
    _ = ∫ x in Set.Ioi (0 : ℝ), Real.exp (-x) * x ^ (s.re - 1) :=
        setIntegral_congr_fun measurableSet_Ioi h0
    _ = Real.Gamma s.re := hR

/-- **Head-sum bound, from `harmonic`.**  For `b ≥ 1`, `∑_{j<N} 1/(b+j) ≤ 1 + log N`.  Termwise
`1/(b+j) ≤ 1/(j+1)`, and Mathlib's `harmonic_le_one_add_log` does the rest — no integral comparison
and no telescoping needed.  This is §127's "Find 1" made formal. -/
theorem sum_range_inv_le_log {b : ℝ} (hb : 1 ≤ b) (N : ℕ) :
    ∑ j ∈ Finset.range N, 1 / (b + j) ≤ 1 + Real.log N := by
  have h1 : ∑ j ∈ Finset.range N, 1 / (b + j) ≤ ((harmonic N : ℚ) : ℝ) := by
    rw [harmonic]
    push_cast
    refine Finset.sum_le_sum fun j hj => ?_
    have hle : ((j : ℝ) + 1) ≤ b + (j : ℝ) := by
      have := Nat.cast_nonneg (α := ℝ) j
      linarith
    simpa [one_div] using one_div_le_one_div_of_le (by positivity) hle
  exact h1.trans (harmonic_le_one_add_log N)

/-- **Tail-sum bound.**  For `b ≥ 1`, `∑_{j<N} 1/(b+j)² ≤ 2/b`.  The summand is antitone, so
`AntitoneOn.sum_le_integral` compares the shifted sum to `∫_0^M dx/(b+x)² = 1/b − 1/(b+M)`; the
`j = 0` summand is added separately as `1/b² ≤ 1/b`. -/
theorem sum_range_inv_sq_le {b : ℝ} (hb : 1 ≤ b) (N : ℕ) :
    ∑ j ∈ Finset.range N, 1 / (b + j) ^ 2 ≤ 2 / b := by
  have hb0 : (0:ℝ) < b := lt_of_lt_of_le one_pos hb
  rcases Nat.eq_zero_or_pos N with h | h
  · subst h; simp; positivity
  obtain ⟨M, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp h)
  rw [Finset.sum_range_succ']
  have hanti : AntitoneOn (fun x : ℝ => 1 / (b + x) ^ 2) (Set.Icc 0 (M : ℝ)) := by
    intro x hx y hy hxy
    have hbnd : b + x ≤ b + y := by linarith [hx.1, hy.1]
    have hx0 : (0:ℝ) < b + x := by linarith [hx.1]
    have hy0 : (0:ℝ) < b + y := by linarith [hy.1]
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith
  have hsum := (show AntitoneOn (fun x : ℝ => 1 / (b + x) ^ 2) (Set.Icc 0 (0 + (M : ℝ))) from by
      simpa using hanti).sum_le_integral (x₀ := 0) (a := M)
  have hshift : ∫ x in (0 : ℝ)..(0 + (M : ℝ)), 1 / (b + x) ^ 2
      = ∫ x in b..(b + (M : ℝ)), 1 / x ^ 2 := by
    have e : (∫ x in (0 : ℝ)..(0 + (M : ℝ)), 1 / (b + x) ^ 2)
        = ∫ x in (0 : ℝ)..(0 + (M : ℝ)), 1 / (x + b) ^ 2 := by
      refine intervalIntegral.integral_congr fun x _ => ?_
      simp only [add_comm b]
    rw [e, intervalIntegral.integral_comp_add_right
      (f := fun x : ℝ => 1 / x ^ 2) (d := b)]
    simp only [zero_add, add_comm, add_zero]
  have hpow : ∫ x in b..(b + (M : ℝ)), 1 / x ^ 2 = 1 / b - 1 / (b + (M : ℝ)) := by
    rw [show (fun x : ℝ => 1 / x ^ 2) = (fun x : ℝ => x ^ (-2 : ℤ)) from by
      funext x
      rw [one_div, ← zpow_natCast (n := 2), ← zpow_neg]
      norm_num]
    rw [integral_zpow (Or.inr ⟨by norm_num, by
      rw [Set.uIcc_of_le (by linarith [Nat.cast_nonneg (α := ℝ) M] : b ≤ b + (M : ℝ))]
      intro hmem
      exact absurd hmem.1 (by linarith)⟩)]
    rw [show (-2 : ℤ) + 1 = -1 by norm_num, zpow_neg, zpow_one]
    field_simp
    ring
  rw [hshift, hpow] at hsum
  simp only [zero_add] at hsum
  have h1 : 1 / b ^ 2 ≤ 1 / b := by
    rw [div_le_div_iff₀ (by positivity) hb0]; nlinarith
  have h2 : (0:ℝ) < 1 / (b + M) := by positivity
  have h3 : 1 / b + 1 / b = 2 / b := by ring
  have hgoal : ∑ x ∈ Finset.range M, 1 / (b + (((x + 1 : ℕ)) : ℝ)) ^ 2 + 1 / b ^ 2 ≤ 2 / b := by
    calc ∑ x ∈ Finset.range M, 1 / (b + (((x + 1 : ℕ)) : ℝ)) ^ 2 + 1 / b ^ 2
        ≤ (1 / b - 1 / (b + (M : ℝ))) + 1 / b := add_le_add hsum h1
      _ ≤ 2 / b := by linarith [h2, h3]
  simpa only [zero_add, add_zero, Nat.cast_zero] using hgoal

/-- **Termwise head bound.**  `√(b²+t²) ≥ |t|`, so `|t|/(b·√(b²+t²)) ≤ 1/b`. -/
theorem abs_div_mul_sqrt_le_inv {b t : ℝ} (hb : 0 < b) :
    |t| / (b * Real.sqrt (b ^ 2 + t ^ 2)) ≤ 1 / b := by
  have hsq : (Real.sqrt (b ^ 2 + t ^ 2)) ^ 2 = b ^ 2 + t ^ 2 := Real.sq_sqrt (by positivity)
  have hs : |t| ≤ Real.sqrt (b ^ 2 + t ^ 2) := by
    nlinarith [hsq, abs_nonneg t, Real.sqrt_nonneg (b ^ 2 + t ^ 2), sq_abs t,
      sq_nonneg (Real.sqrt (b ^ 2 + t ^ 2) - |t|)]
  have hpos : (0:ℝ) < b * Real.sqrt (b ^ 2 + t ^ 2) :=
    mul_pos hb (Real.sqrt_pos.mpr (by nlinarith [sq_nonneg t]))
  rw [div_le_div_iff₀ hpos hb]
  simpa only [one_mul, mul_comm, mul_left_comm, mul_assoc] using
    mul_le_mul_of_nonneg_right hs (le_of_lt hb)

/-- **Termwise tail bound.**  `√(b²+t²) ≥ b`, so `|t|/(b·√(b²+t²)) ≤ |t|/b²`. -/
theorem abs_div_mul_sqrt_le_abs_div_sq {b t : ℝ} (hb : 0 < b) :
    |t| / (b * Real.sqrt (b ^ 2 + t ^ 2)) ≤ |t| / b ^ 2 := by
  have hsq : (Real.sqrt (b ^ 2 + t ^ 2)) ^ 2 = b ^ 2 + t ^ 2 := Real.sq_sqrt (by positivity)
  have hs : b ≤ Real.sqrt (b ^ 2 + t ^ 2) := by
    nlinarith [hsq, Real.sqrt_nonneg (b ^ 2 + t ^ 2), sq_nonneg t, le_of_lt hb,
      sq_nonneg (Real.sqrt (b ^ 2 + t ^ 2) - b)]
  have hpos : (0:ℝ) < b * Real.sqrt (b ^ 2 + t ^ 2) :=
    mul_pos hb (Real.sqrt_pos.mpr (by nlinarith [sq_nonneg t]))
  rw [div_le_div_iff₀ hpos (by positivity)]
  simpa only [pow_two, mul_comm, mul_left_comm, mul_assoc] using
    mul_le_mul_of_nonneg_left hs (mul_nonneg (abs_nonneg t) (le_of_lt hb))

/-- **Head of `Lseq_bound`.**  Over `j < M` with `|t| ≤ M`, the termwise head bound plus
`sum_range_inv_le_log` gives `|t|·∑ ≤ 1 + log(|t|+2)`. -/
theorem Lseq_head_bound {σ0 t : ℝ} (hσ0 : 1 ≤ σ0) (M : ℕ) (hM : |t| ≤ (M : ℝ))
    (hM2 : (M : ℝ) < |t| + 1) :
    |t| * ∑ j ∈ Finset.range M, 1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))
      ≤ 1 + Real.log (|t| + 2) := by
  have h1 : ∑ j ∈ Finset.range M, 1 / (σ0 + j) ≤ 1 + Real.log M :=
    sum_range_inv_le_log (b := σ0) hσ0 M
  have h2 : ∀ j ∈ Finset.range M,
      |t| * (1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))) ≤ 1 / (σ0 + j) := by
    intro j hj
    have hpos : (0:ℝ) < σ0 + (j : ℝ) := by positivity
    rw [mul_one_div]
    exact abs_div_mul_sqrt_le_inv hpos
  have hlog : Real.log (M : ℝ) ≤ Real.log (|t| + 2) := by
    rcases Nat.eq_zero_or_pos M with h | h
    · subst h
      simp only [Nat.cast_zero, Real.log_zero]
      exact Real.log_nonneg (by linarith [abs_nonneg t])
    · refine Real.log_le_log (by positivity) ?_
      linarith
  calc |t| * ∑ j ∈ Finset.range M, 1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))
      = ∑ j ∈ Finset.range M,
          |t| * (1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))) := by
        rw [Finset.mul_sum]
    _ ≤ ∑ j ∈ Finset.range M, 1 / (σ0 + j) := Finset.sum_le_sum h2
    _ ≤ 1 + Real.log M := h1
    _ ≤ 1 + Real.log (|t| + 2) := by linarith [hlog]

/-- **Tail of `Lseq_bound`.**  For `σ₀+M > |t|`, the termwise tail bound plus `sum_range_inv_sq_le`
gives `|t|·∑ ≤ |t|·2/(σ₀+M) ≤ 2`. -/
theorem Lseq_tail_bound {σ0 t : ℝ} (hσ0 : 1 ≤ σ0) (M m : ℕ) (hM : |t| < σ0 + (M : ℝ)) :
    |t| * ∑ i ∈ Finset.range m,
        1 / ((σ0 + (M : ℝ) + i) * Real.sqrt ((σ0 + (M : ℝ) + i) ^ 2 + t ^ 2)) ≤ 2 := by
  have hb : (1:ℝ) ≤ σ0 + (M : ℝ) := by
    have := Nat.cast_nonneg (α := ℝ) M
    linarith
  have hb0 : (0:ℝ) < σ0 + (M : ℝ) := by linarith
  have h2 : ∀ i ∈ Finset.range m,
      |t| * (1 / ((σ0 + (M : ℝ) + i) * Real.sqrt ((σ0 + (M : ℝ) + i) ^ 2 + t ^ 2)))
        ≤ |t| * (1 / (σ0 + (M : ℝ) + i) ^ 2) := by
    intro i hi
    have hpos : (0:ℝ) < σ0 + (M : ℝ) + i := by positivity
    rw [mul_one_div, mul_one_div]
    exact abs_div_mul_sqrt_le_abs_div_sq hpos
  calc |t| * ∑ i ∈ Finset.range m,
        1 / ((σ0 + (M : ℝ) + i) * Real.sqrt ((σ0 + (M : ℝ) + i) ^ 2 + t ^ 2))
      = ∑ i ∈ Finset.range m,
          |t| * (1 / ((σ0 + (M : ℝ) + i) * Real.sqrt ((σ0 + (M : ℝ) + i) ^ 2 + t ^ 2))) := by
        rw [Finset.mul_sum]
    _ ≤ ∑ i ∈ Finset.range m, |t| * (1 / (σ0 + (M : ℝ) + i) ^ 2) := Finset.sum_le_sum h2
    _ = |t| * ∑ i ∈ Finset.range m, 1 / (σ0 + (M : ℝ) + i) ^ 2 := by rw [Finset.mul_sum]
    _ ≤ |t| * (2 / (σ0 + (M : ℝ))) :=
        mul_le_mul_of_nonneg_left (sum_range_inv_sq_le hb m) (abs_nonneg t)
    _ = 2 * |t| / (σ0 + (M : ℝ)) := by ring
    _ ≤ 2 := by
        rw [div_le_iff₀ hb0]
        linarith [hM.le]

/-- **`Lseq_bound`.**  The uniform-in-`n` bound on the `GammaSeq` log-derivative approximant:
for `σ₀ ≥ 1` and **every** `n`,
`|t| · ∑_{j<n+1} 1/((σ₀+j)·√((σ₀+j)²+t²)) ≤ 5·(1 + log(|t|+2))`.  This is §125's estimate — the
`ℝ` content of `DigammaGrowthBound`. -/
theorem Lseq_bound {σ0 t : ℝ} (hσ0 : 1 ≤ σ0) (n : ℕ) :
    |t| * ∑ j ∈ Finset.range (n + 1),
        1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))
      ≤ 5 * (1 + Real.log (|t| + 2)) := by
  have hM1 : |t| ≤ ((⌈|t|⌉₊ : ℕ) : ℝ) := Nat.le_ceil |t|
  have hM2 : ((⌈|t|⌉₊ : ℕ) : ℝ) < |t| + 1 := Nat.ceil_lt_add_one (abs_nonneg t)
  have hM3 : |t| < σ0 + ((⌈|t|⌉₊ : ℕ) : ℝ) := by
    have : (0:ℝ) ≤ ((⌈|t|⌉₊ : ℕ) : ℝ) := Nat.cast_nonneg _
    linarith
  have hb3 : (1:ℝ) ≤ 1 + Real.log (|t| + 2) := by
    have : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
    linarith
  by_cases hn : n + 1 ≤ ⌈|t|⌉₊
  · have hsub : ∑ j ∈ Finset.range (n + 1),
        1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))
        ≤ ∑ j ∈ Finset.range ⌈|t|⌉₊,
        1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2)) := by
      refine Finset.sum_le_sum_of_subset_of_nonneg ?_ ?_
      · intro x hx
        exact Finset.mem_range.mpr (lt_of_lt_of_le (Finset.mem_range.mp hx) hn)
      · intro x hx hxM
        positivity
    have h1 : |t| * ∑ j ∈ Finset.range ⌈|t|⌉₊,
        1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2)) ≤ 1 + Real.log (|t| + 2) :=
      Lseq_head_bound hσ0 ⌈|t|⌉₊ hM1 hM2
    nlinarith [mul_le_mul_of_nonneg_left hsub (abs_nonneg t), h1, hb3]
  · push_neg at hn
    have hsplit := Finset.sum_range_add
      (f := fun j : ℕ => 1 / ((σ0 + (j : ℝ)) * Real.sqrt ((σ0 + (j : ℝ)) ^ 2 + t ^ 2)))
      ⌈|t|⌉₊ (n + 1 - ⌈|t|⌉₊)
    rw [Nat.add_sub_of_le hn.le] at hsplit
    simp only [Nat.cast_add] at hsplit
    have h1 : |t| * ∑ j ∈ Finset.range ⌈|t|⌉₊,
        1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2)) ≤ 1 + Real.log (|t| + 2) :=
      Lseq_head_bound hσ0 ⌈|t|⌉₊ hM1 hM2
    have h2 : |t| * ∑ i ∈ Finset.range (n + 1 - ⌈|t|⌉₊),
        1 / ((σ0 + (⌈|t|⌉₊ + i)) * Real.sqrt ((σ0 + (⌈|t|⌉₊ + i)) ^ 2 + t ^ 2)) ≤ 2 := by
      simpa only [add_assoc] using
        Lseq_tail_bound hσ0 ⌈|t|⌉₊ (n + 1 - ⌈|t|⌉₊) hM3
    rw [hsplit, mul_add]
    nlinarith [h1, h2, hb3]

/-- **Lower bound for the harmonic sum.**  For `b > 0` and `N ≥ 1`,
`log N − log b ≤ ∑_{j<N} 1/(b+j)`.  Via `AntitoneOn.integral_le_sum` and
`∫_0^N dx/(b+x) = log((b+N)/b) ≥ log N − log b`.  This bounds the **real bracket** of §125. -/
theorem log_sub_log_le_sum_range_inv {b : ℝ} (hb : 0 < b) {N : ℕ} (hN : 1 ≤ N) :
    Real.log N - Real.log b ≤ ∑ j ∈ Finset.range N, 1 / (b + j) := by
  have hbN : (0:ℝ) < b + (N : ℝ) := by positivity
  have hanti : AntitoneOn (fun x : ℝ => 1 / (b + x)) (Set.Icc 0 (0 + (N : ℝ))) := by
    intro x hx y hy hxy
    have hx0 : (0:ℝ) < b + x := by linarith [hx.1]
    have hy0 : (0:ℝ) < b + y := by linarith [hy.1]
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith
  have hint := hanti.integral_le_sum (x₀ := 0) (a := N)
  simp only [zero_add] at hint
  have hshift : ∫ x in (0:ℝ)..(N:ℝ), 1 / (b + x) = ∫ x in (0:ℝ) + b..(N:ℝ) + b, x⁻¹ := by
    rw [← intervalIntegral.integral_comp_add_right
      (f := fun x : ℝ => x⁻¹) (a := (0:ℝ)) (b := (N:ℝ)) (d := b)]
    refine intervalIntegral.integral_congr fun x _ => ?_
    simp only [one_div, add_comm]
  rw [hshift] at hint
  have hval : ∫ x in (0:ℝ) + b..(N:ℝ) + b, x⁻¹ = Real.log ((b + (N:ℝ)) / b) := by
    rw [integral_inv_of_pos (by linarith : (0:ℝ) < 0 + b) (by linarith : (0:ℝ) < (N:ℝ) + b),
      zero_add]
    congr 1
    ring
  rw [hval] at hint
  have hlog : Real.log N - Real.log b ≤ Real.log ((b + (N:ℝ)) / b) := by
    rw [Real.log_div (ne_of_gt hbN) (ne_of_gt hb)]
    have h1 : Real.log N ≤ Real.log (b + (N:ℝ)) :=
      Real.log_le_log (by positivity) (by linarith)
    linarith
  exact hlog.trans hint

/-- **Per-term splitting identity.**  `1/(b+it) = 1/b − it/(b(b+it))`: the real part `1/b` plus a
purely rotational term.  This is the atom of §125's split. -/
theorem inv_add_eq_inv_sub {b t : ℝ} (hb : (b : ℂ) ≠ 0)
    (hbt : (b : ℂ) + (t : ℂ) * Complex.I ≠ 0) :
    ((b : ℂ) + (t : ℂ) * Complex.I)⁻¹
      = ((1 / b : ℝ) : ℂ)
        - (t : ℂ) * Complex.I * ((b : ℂ) * ((b : ℂ) + (t : ℂ) * Complex.I))⁻¹ := by
  have hbR : (b : ℂ)⁻¹ = ((1 / b : ℝ) : ℂ) := by
    rw [one_div, Complex.ofReal_inv]
  rw [← hbR]
  field_simp
  ring

/-- **§125's splitting identity, assembled.**  Summing `inv_add_eq_inv_sub` over `j < n+1`, the
log-derivative approximant splits into a **real** bracket and a **rotational** bracket. -/
theorem Lseq_split {σ0 t : ℝ} (hσ0 : 0 < σ0) {n : ℕ} (hn : 0 < n) :
    Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1),
        (((σ0 : ℂ) + (t : ℂ) * Complex.I) + (j : ℂ))⁻¹
      = (((Real.log n - ∑ j ∈ Finset.range (n + 1), 1 / (σ0 + j) : ℝ)) : ℂ)
        + (t : ℂ) * Complex.I * ∑ j ∈ Finset.range (n + 1),
            (((σ0 + j : ℝ) : ℂ) * (((σ0 + j : ℝ) : ℂ) + (t : ℂ) * Complex.I))⁻¹ := by
  have hnpos : (0:ℝ) < n := by exact_mod_cast hn
  have hterm : ∀ j : ℕ,
      (((σ0 : ℂ) + (t : ℂ) * Complex.I) + (j : ℂ))⁻¹
        = ((1 / (σ0 + j) : ℝ) : ℂ)
          - (t : ℂ) * Complex.I
            * (((σ0 + j : ℝ) : ℂ) * (((σ0 + j : ℝ) : ℂ) + (t : ℂ) * Complex.I))⁻¹ := by
    intro j
    have hb : (0:ℝ) < σ0 + j := by positivity
    have hcast : ((σ0 : ℂ) + (t : ℂ) * Complex.I) + (j : ℂ)
        = ((σ0 + j : ℝ) : ℂ) + (t : ℂ) * Complex.I := by push_cast; ring
    rw [hcast]
    exact inv_add_eq_inv_sub (by exact_mod_cast ne_of_gt hb)
      (by
        intro h
        have hre := congrArg Complex.re h
        simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re,
          Complex.ofReal_im, Complex.I_im, mul_zero, mul_one, sub_zero, add_zero,
          Complex.zero_re] at hre
        have : (0:ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
        linarith)
  rw [show Complex.log (n : ℂ) = ((Real.log n : ℝ) : ℂ) from
    (Complex.ofReal_log (x := (n : ℝ)) (le_of_lt hnpos)).symm]
  rw [Finset.sum_congr rfl (fun j _ => hterm j), Finset.sum_sub_distrib, Finset.mul_sum,
    Complex.ofReal_sub, Complex.ofReal_sum]
  ring

/-- **Sharpened harmonic bound, with the logarithm at the *same* index.**  For `b ≥ 1`,
`∑_{j<n+1} 1/(b+j) ≤ 2 + log n`.  Compare `sum_range_inv_le_log`, which gives `1 + log(n+1)` — since
`log(n+1) > log n` that is *weaker*, and §138 shows it is too weak for the lower bound on the real
bracket.  Here the `j = 0` term is split off and bounded by `1`, leaving `harmonic n`, whose bound is
`1 + log n`. -/
theorem sum_range_inv_succ_le_log {b : ℝ} (hb : 1 ≤ b) (n : ℕ) :
    ∑ j ∈ Finset.range (n + 1), 1 / (b + j) ≤ 2 + Real.log n := by
  have hsplit : ∑ j ∈ Finset.range n, 1 / (b + (j + 1)) ≤ ((harmonic n : ℚ) : ℝ) := by
    rw [harmonic]
    push_cast
    refine Finset.sum_le_sum fun j hj => ?_
    have hle : ((j : ℝ) + 1) ≤ b + ((j : ℝ) + 1) := by
      have := Nat.cast_nonneg (α := ℝ) j
      linarith
    simpa [one_div] using one_div_le_one_div_of_le (by positivity) hle
  have h2 : ((harmonic n : ℚ) : ℝ) ≤ 1 + Real.log n := harmonic_le_one_add_log n
  have h1 : 1 / (b + 0) ≤ 1 := by
    rw [add_zero, div_le_one (by linarith)]
    linarith
  rw [Finset.sum_range_succ']
  simp only [Nat.cast_add, Nat.cast_one, Nat.cast_zero]
  calc ∑ j ∈ Finset.range n, 1 / (b + ((j : ℝ) + 1)) + 1 / (b + 0)
      ≤ ((harmonic n : ℚ) : ℝ) + 1 := add_le_add hsplit h1
    _ ≤ (1 + Real.log n) + 1 := by linarith
    _ = 2 + Real.log n := by ring

/-- **The real bracket is bounded.**  For `σ₀ ≥ 1` and `n ≥ 1`,
`|log n − ∑_{j<n+1} 1/(σ₀+j)| ≤ log σ₀ + 2`.  Upper bound from §136 (`∑ ≥ log(n+1) − log σ₀` and
`log n ≤ log(n+1)`); lower bound from §139 (`∑ ≤ 2 + log n`).  Note the two harmonic bounds are
**different lemmas**: §129's `1 + log(n+1)` would give no lower bound at all (§138). -/
theorem Lseq_real_bracket_abs_le {σ0 : ℝ} (hσ0 : 1 ≤ σ0) {n : ℕ} (hn : 1 ≤ n) :
    |Real.log (n : ℝ) - ∑ j ∈ Finset.range (n + 1), 1 / (σ0 + j)| ≤ Real.log σ0 + 2 := by
  have hb : (0:ℝ) < σ0 := by linarith
  have h1 : Real.log ((n + 1 : ℕ) : ℝ) - Real.log σ0
      ≤ ∑ j ∈ Finset.range (n + 1), 1 / (σ0 + j) :=
    log_sub_log_le_sum_range_inv (N := n + 1) hb (by omega)
  have h2 : ∑ j ∈ Finset.range (n + 1), 1 / (σ0 + j) ≤ 2 + Real.log (n : ℝ) :=
    sum_range_inv_succ_le_log hσ0 n
  have hlogn : Real.log (n : ℝ) ≤ Real.log ((n + 1 : ℕ) : ℝ) := by
    refine Real.log_le_log (by positivity) ?_
    push_cast
    linarith
  have hlogσ : (0:ℝ) ≤ Real.log σ0 := Real.log_nonneg hσ0
  set S : ℝ := ∑ j ∈ Finset.range (n + 1), 1 / (σ0 + j) with hS
  have h1' : Real.log ((n + 1 : ℕ) : ℝ) - Real.log σ0 ≤ S := h1
  have h2' : S ≤ 2 + Real.log (n : ℝ) := h2
  have hupper : Real.log (n : ℝ) - S ≤ Real.log σ0 + 2 := by linarith
  have hlower : -(Real.log σ0 + 2) ≤ Real.log (n : ℝ) - S := by linarith
  exact abs_le.mpr ⟨hlower, hupper⟩

/-- The norm of a real cast: `‖(x : ℂ)‖ = |x|`.  (`Complex.norm_of_nonneg` covers only `x ≥ 0`.) -/
theorem norm_ofReal_eq_abs (x : ℝ) : ‖(x : ℂ)‖ = |x| := by
  have h : ‖(x : ℂ)‖ ^ 2 = x ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_ofReal]; ring
  calc ‖(x : ℂ)‖ = Real.sqrt (‖(x : ℂ)‖ ^ 2) := (Real.sqrt_sq (norm_nonneg _)).symm
    _ = Real.sqrt (x ^ 2) := by rw [h]
    _ = |x| := Real.sqrt_sq_eq_abs x

/-- **The `GammaSeq` log-derivative approximant is `O(log(|t|+2))`, uniformly in `n`.**  This is the
`ℂ`-valued assembly: `Lseq_split` (§137) writes `L_n` as a real bracket plus a rotational term, §140
bounds the first, and §135 bounds `|t|` times the second. -/
theorem norm_Lseq_le {σ0 t : ℝ} (hσ0 : 1 ≤ σ0) (n : ℕ) :
    ‖Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1),
        ((σ0 : ℂ) + (t : ℂ) * Complex.I + (j : ℂ))⁻¹‖
      ≤ (Real.log σ0 + 20) * (1 + Real.log (|t| + 2)) := by
  have hb3 : (1:ℝ) ≤ 1 + Real.log (|t| + 2) := by
    have : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
    linarith
  have hlogσ : (0:ℝ) ≤ Real.log σ0 := Real.log_nonneg hσ0
  rcases Nat.eq_zero_or_pos n with h | h
  · subst h
    have h0 : ∑ j ∈ Finset.range (0 + 1),
        ((σ0 : ℂ) + (t : ℂ) * Complex.I + (j : ℂ))⁻¹
        = ((σ0 : ℂ) + (t : ℂ) * Complex.I)⁻¹ := by
      rw [Finset.sum_range_one]; norm_num
    rw [show Complex.log ((0 : ℕ) : ℂ) = 0 by simp [Complex.log], h0, zero_sub, norm_neg]
    rw [norm_inv]
    have hsn : (1:ℝ) ≤ ‖(σ0 : ℂ) + (t : ℂ) * Complex.I‖ := by
      rw [show (σ0 : ℂ) + (t : ℂ) * Complex.I = ((σ0 : ℝ) : ℂ) + (t : ℝ) * Complex.I from rfl,
        Complex.norm_add_mul_I]
      have hs : σ0 ≤ Real.sqrt (σ0 ^ 2 + t ^ 2) := by
        rw [Real.le_sqrt (by linarith) (by positivity)]
        nlinarith [sq_nonneg t]
      linarith
    have hnorm : ‖(σ0 : ℂ) + (t : ℂ) * Complex.I‖⁻¹ ≤ 1 := inv_le_one_of_one_le₀ hsn
    have hC : (1:ℝ) ≤ (Real.log σ0 + 20) * (1 + Real.log (|t| + 2)) := by
      nlinarith [hb3, hlogσ]
    linarith
  · have hR : ‖∑ j ∈ Finset.range (n + 1),
        (((σ0 + j : ℝ) : ℂ) * (((σ0 + j : ℝ) : ℂ) + (t : ℂ) * Complex.I))⁻¹‖
        ≤ ∑ j ∈ Finset.range (n + 1),
            1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2)) := by
      refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun j hj => ?_)
      have h1 : ‖(((σ0 + j : ℝ)) : ℂ)‖ = σ0 + j :=
        Complex.norm_of_nonneg (by positivity)
      have h2 : ‖(((σ0 + j : ℝ)) : ℂ) + (t : ℂ) * Complex.I‖
          = Real.sqrt ((σ0 + j) ^ 2 + t ^ 2) := by
        rw [show (((σ0 + j : ℝ)) : ℂ) + (t : ℂ) * Complex.I
            = (((σ0 + j : ℝ)) : ℂ) + ((t : ℝ) : ℂ) * Complex.I from rfl]
        exact Complex.norm_add_mul_I (σ0 + j) t
      rw [norm_inv, norm_mul, h1, h2, one_div]
    have hreal := Lseq_real_bracket_abs_le hσ0 h
    have hrot := Lseq_bound (t := t) hσ0 n
    rw [Lseq_split (by linarith : (0:ℝ) < σ0) h]
    have htri : ‖(((Real.log (n : ℝ) - ∑ j ∈ Finset.range (n + 1),
          1 / (σ0 + j) : ℝ)) : ℂ)
        + (t : ℂ) * Complex.I * ∑ j ∈ Finset.range (n + 1),
            (((σ0 + j : ℝ) : ℂ) * (((σ0 + j : ℝ) : ℂ) + (t : ℂ) * Complex.I))⁻¹‖
        ≤ (Real.log σ0 + 2)
          + |t| * ∑ j ∈ Finset.range (n + 1),
              1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2)) := by
      have h3 : ‖(((Real.log (n : ℝ) - ∑ j ∈ Finset.range (n + 1),
            1 / (σ0 + j) : ℝ)) : ℂ)‖
          = |Real.log (n : ℝ) - ∑ j ∈ Finset.range (n + 1), 1 / (σ0 + j)| :=
        norm_ofReal_eq_abs _
      calc _ ≤ ‖(((Real.log (n : ℝ) - ∑ j ∈ Finset.range (n + 1),
                1 / (σ0 + j) : ℝ)) : ℂ)‖
              + ‖(t : ℂ) * Complex.I * ∑ j ∈ Finset.range (n + 1),
                  (((σ0 + j : ℝ) : ℂ) * (((σ0 + j : ℝ) : ℂ) + (t : ℂ) * Complex.I))⁻¹‖ :=
            norm_add_le _ _
        _ ≤ (Real.log σ0 + 2)
              + |t| * ∑ j ∈ Finset.range (n + 1),
                  1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2)) := by
            rw [h3, norm_mul, norm_mul, Complex.norm_I, mul_one, norm_ofReal_eq_abs]
            exact add_le_add hreal (mul_le_mul_of_nonneg_left hR (abs_nonneg t))
    nlinarith [htri, hrot, hb3, hlogσ]

/-- **Product rule for `GammaSeq`.**  `logDeriv (GammaSeq · n) s = log n − ∑_{j<n+1} (s+j)⁻¹`, i.e.
`deriv Γ_n s = Γ_n s · L_n s`.  This links §144's free `Mellin` derivative to the explicit `L_n`.

The four earlier failures (rounds 19, 20, 40, 41) were all normalform collisions.  The three
resolutions: the lambda/product bridge is `funext w; simp only [Finset.prod_apply]`; the `GammaSeq`
unfolding is `funext w; simp only [GammaSeq, Pi.div_apply]`; and `logDeriv_mul_const` **already**
strips the constant factor, so no `logDeriv_const`/`sub_zero` step may follow it. -/
theorem logDeriv_GammaSeq {n : ℕ} (hn : n ≠ 0) (s : ℂ)
    (hs : ∀ j ∈ Finset.range (n + 1), s + (j : ℂ) ≠ 0) :
    logDeriv (fun w : ℂ => GammaSeq w n) s
      = Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
  have hfac : ((Nat.factorial n : ℕ) : ℂ) ≠ 0 := by exact_mod_cast Nat.factorial_ne_zero n
  have hprod : (∏ j ∈ Finset.range (n + 1), (s + (j : ℂ))) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr (fun j hj => hs j hj)
  have hn0 : (n : ℂ) ≠ 0 := by exact_mod_cast hn
  have hnum : (n : ℂ) ^ s * ((Nat.factorial n : ℕ) : ℂ) ≠ 0 :=
    mul_ne_zero (cpow_ne_zero_iff.mpr (Or.inl hn0)) hfac
  have hcw : HasDerivAt (fun w : ℂ => (n : ℂ) ^ w) ((n : ℂ) ^ s * Complex.log (n : ℂ)) s := by
    convert! (hasDerivAt_id s).const_cpow (Or.inl hn0) using 1
    simp only [id_eq]; ring
  have hD : DifferentiableAt ℂ (fun w : ℂ => (n : ℂ) ^ w * ((Nat.factorial n : ℕ) : ℂ)) s :=
    hcw.differentiableAt.mul_const _
  have hP : DifferentiableAt ℂ (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s := by
    fun_prop
  have hsum : logDeriv (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s
      = ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
    rw [show (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ)))
        = ∏ j ∈ Finset.range (n + 1), (fun w : ℂ => w + (j : ℂ)) from by
      funext w; simp only [Finset.prod_apply]]
    rw [logDeriv_prod (s := Finset.range (n + 1)) (fun j hj => by simpa using hs j hj)
      (fun j hj => by fun_prop)]
    refine Finset.sum_congr rfl fun j hj => ?_
    rw [logDeriv_apply, deriv_add_const, deriv_id'']; simp
  have hfun : (fun w : ℂ => GammaSeq w n)
      = ((fun w : ℂ => (n : ℂ) ^ w * ((Nat.factorial n : ℕ) : ℂ)) : ℂ → ℂ)
        / (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) := by
    funext w; simp only [GammaSeq, Pi.div_apply]
  rw [hfun]
  rw [logDeriv_div s hnum hprod hD hP, logDeriv_mul_const s _ hfac, hsum]
  congr 1
  rw [logDeriv_apply, hcw.deriv]
  exact mul_div_cancel_left₀ _ (cpow_ne_zero_iff.mpr (Or.inl hn0))

/-- The compactly-supported kernel whose Mellin transform is `GammaSeq · n`: `x ↦ 1_{x ≤ n}(1−x/n)ⁿ`. -/
noncomputable def gammaKernel (n : ℕ) : ℝ → ℂ :=
  fun x => if x ≤ (n : ℝ) then ((1 - x / n) ^ n : ℝ) else 0

theorem gammaKernel_eq_indicator (n : ℕ) {x : ℝ} (hx : 0 < x) :
    gammaKernel n x = (Set.Ioc (0:ℝ) (n:ℝ)).indicator (fun x => ((1 - x / n) ^ n : ℝ)) x := by
  by_cases hxn : x ≤ (n : ℝ)
  · rw [gammaKernel, if_pos hxn, Set.indicator_of_mem (Set.mem_Ioc.mpr ⟨hx, hxn⟩)]
  · rw [gammaKernel, if_neg hxn, Set.indicator_of_notMem (fun h => hxn h.2), Complex.ofReal_zero]

theorem mellin_gammaKernel (n : ℕ) (hn : n ≠ 0) {s : ℂ} (hs : 0 < s.re) :
    mellin (gammaKernel n) s = GammaSeq s n := by
  have hnR : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
  have hAgree : ∀ x ∈ Set.Ioi (0:ℝ),
      (x : ℂ) ^ (s - 1) • gammaKernel n x
        = (Set.Ioc (0:ℝ) (n:ℝ)).indicator
            (fun x => (x : ℂ) ^ (s - 1) * ((1 - x / n) ^ n : ℝ)) x := by
    intro x hx
    rw [smul_eq_mul, gammaKernel_eq_indicator n hx]
    by_cases hxn : x ≤ (n : ℝ)
    · rw [Set.indicator_of_mem (Set.mem_Ioc.mpr ⟨hx, hxn⟩),
        Set.indicator_of_mem (Set.mem_Ioc.mpr ⟨hx, hxn⟩)]
    · rw [Set.indicator_of_notMem (fun h => hxn h.2),
        Set.indicator_of_notMem (fun h => hxn h.2), Complex.ofReal_zero, mul_zero]
  rw [mellin, GammaSeq_eq_approx_Gamma_integral hs hn,
    intervalIntegral.integral_of_le hnR.le]
  rw [setIntegral_congr_fun measurableSet_Ioi hAgree]
  rw [← integral_indicator measurableSet_Ioi, ← integral_indicator measurableSet_Ioc]
  rw [show (Set.Ioi (0:ℝ)).indicator
        ((Set.Ioc (0:ℝ) (n:ℝ)).indicator (fun x => (x : ℂ) ^ (s - 1) * ((1 - x / n) ^ n : ℝ)))
      = (Set.Ioc (0:ℝ) (n:ℝ)).indicator
        (fun x => (x : ℂ) ^ (s - 1) * ((1 - x / n) ^ n : ℝ)) from by
    rw [Set.indicator_indicator, Set.inter_eq_right.mpr Set.Ioc_subset_Ioi_self]]
  refine integral_congr_ae ?_
  filter_upwards with x
  by_cases hx : x ∈ Set.Ioc (0:ℝ) (n:ℝ)
  · rw [Set.indicator_of_mem hx, Set.indicator_of_mem hx]; ring
  · rw [Set.indicator_of_notMem hx, Set.indicator_of_notMem hx]


theorem gammaKernel_eq_min (n : ℕ) (hn : n ≠ 0) :
    gammaKernel n = fun x : ℝ => ((1 - min x (n:ℝ) / n) ^ n : ℂ) := by
  funext x
  have hn0 : (n : ℂ) ≠ 0 := by exact_mod_cast hn
  by_cases hx : x ≤ (n:ℝ)
  · rw [gammaKernel, if_pos hx, min_eq_left hx]; push_cast; ring
  · rw [gammaKernel, if_neg hx, min_eq_right (not_le.mp hx).le]
    push_cast
    rw [div_self hn0, sub_self, zero_pow hn]

theorem continuous_gammaKernel (n : ℕ) (hn : n ≠ 0) : Continuous (gammaKernel n) := by
  rw [gammaKernel_eq_min n hn]
  fun_prop

theorem deriv_GammaSeq_eq_mellin {n : ℕ} (hn : n ≠ 0) {s : ℂ} (hs : 0 < s.re) :
    deriv (fun w => GammaSeq w n) s = mellin (fun t => Real.log t • gammaKernel n t) s := by
  have hcont := continuous_gammaKernel n hn
  have hfc : LocallyIntegrableOn (gammaKernel n) (Set.Ioi 0) :=
    (hcont.continuousOn).locallyIntegrableOn measurableSet_Ioi
  have htop : gammaKernel n =O[atTop] (fun t : ℝ => t ^ (-(s.re + 1))) := by
    refine (isBigO_zero (l := atTop) (g := fun t : ℝ => t ^ (-(s.re + 1)))).congr' ?_ (EventuallyEq.refl _ _)
    filter_upwards [eventually_gt_atTop ((n : ℝ))] with x hx
    rw [gammaKernel, if_neg (not_le.mpr hx)]
  have hbot : gammaKernel n =O[𝓝[Set.Ioi (0:ℝ)] 0] (fun t : ℝ => t ^ (-(0:ℝ))) := by
    simp only [neg_zero, Real.rpow_zero]
    refine isBigO_const_of_tendsto (y := 1) ?_ one_ne_zero
    have h0 : Tendsto (gammaKernel n) (𝓝[Set.Ioi (0:ℝ)] 0) (𝓝 (gammaKernel n 0)) :=
      (continuous_gammaKernel n hn).continuousAt.tendsto.mono_left inf_le_left
    convert h0 using 2
    rw [gammaKernel, if_pos (by positivity : (0:ℝ) ≤ (n:ℝ))]
    norm_num
  have hd := (mellin_hasDerivAt_of_isBigO_rpow (f := gammaKernel n) (s := s)
    hfc htop (by linarith) hbot hs).2
  rw [← hd.deriv]
  refine Filter.EventuallyEq.deriv_eq ?_
  filter_upwards [(isOpen_re_gt 0).mem_nhds hs] with w hw
  exact (mellin_gammaKernel n hn hw).symm


theorem tendsto_gammaKernel {t : ℝ} (ht : 0 < t) :
    Tendsto (fun n : ℕ => gammaKernel n t) atTop (𝓝 (↑(Real.exp (-t)))) := by
  have hbase : Tendsto (fun n : ℕ => (1 - t / (n : ℝ)) ^ n) atTop (𝓝 (Real.exp (-t))) := by
    have := Real.tendsto_one_add_div_pow_exp (-t)
    simpa only [neg_div, sub_eq_add_neg] using this
  have hcast := (continuous_ofReal.tendsto (Real.exp (-t))).comp hbase
  refine hcast.congr' ?_
  filter_upwards [eventually_ge_atTop ⌈t⌉₊] with n hn
  have hn' : t ≤ (n : ℝ) := (Nat.le_ceil t).trans (by exact_mod_cast hn)
  rw [gammaKernel, if_pos hn']
  rfl

theorem norm_gammaKernel_le {n : ℕ} {t : ℝ} (ht : 0 < t) :
    ‖gammaKernel n t‖ ≤ Real.exp (-t) := by
  rw [gammaKernel]
  split_ifs with h
  · rw [Complex.norm_of_nonneg (pow_nonneg (sub_nonneg.mpr (div_le_one_of_le₀ h (Nat.cast_nonneg n))) n)]
    exact Real.one_sub_div_pow_le_exp_neg h
  · rw [norm_zero]
    exact (Real.exp_pos _).le


/-- `|log u| ≤ u + u⁻¹` for `u > 0`. -/
theorem abs_log_le_add_inv {u : ℝ} (hu : 0 < u) : |Real.log u| ≤ u + u⁻¹ := by
  have h1 : Real.log u ≤ u - 1 := Real.log_le_sub_one_of_pos hu
  have h2 : Real.log u⁻¹ ≤ u⁻¹ - 1 := Real.log_le_sub_one_of_pos (by positivity)
  rw [Real.log_inv] at h2
  have h3 : (0:ℝ) < u⁻¹ := by positivity
  rw [abs_le]
  constructor <;> linarith

/-- `|log t| ≤ (t^δ + t^(-δ))/δ` for `t > 0`, `δ > 0`. -/
theorem abs_log_le_rpow {t δ : ℝ} (ht : 0 < t) (hδ : 0 < δ) :
    |Real.log t| ≤ (t ^ δ + t ^ (-δ)) / δ := by
  have hu : (0:ℝ) < t ^ δ := Real.rpow_pos_of_pos ht _
  have h1 : Real.log (t ^ δ) = δ * Real.log t := Real.log_rpow ht δ
  have h2 : |Real.log (t ^ δ)| ≤ t ^ δ + (t ^ δ)⁻¹ := abs_log_le_add_inv hu
  rw [h1, abs_mul, abs_of_pos hδ] at h2
  have h3 : (t ^ δ)⁻¹ = t ^ (-δ) := by rw [← Real.rpow_neg ht.le]
  rw [h3] at h2
  rw [le_div_iff₀ hδ]
  linarith



-- The dominator is integrable on `Ioi 0` for `σ > 0`.
theorem integrableOn_dominator {σ : ℝ} (hσ : 0 < σ) :
    IntegrableOn (fun t : ℝ => t ^ (σ - 1) * (|Real.log t| * Real.exp (-t))) (Set.Ioi 0) := by
  have hδ : 0 < σ / 2 := by positivity
  have hbase : ∀ a : ℝ, -1 < a →
      IntegrableOn (fun t : ℝ => t ^ a * Real.exp (-t)) (Set.Ioi 0) := by
    intro a ha
    simpa only [one_mul, neg_one_mul, Real.rpow_one] using
      integrableOn_rpow_mul_exp_neg_mul_rpow (p := (1:ℝ)) ha one_pos one_pos
  refine Integrable.mono'
    (((hbase (σ - 1 + σ / 2) (by linarith)).add (hbase (σ - 1 - σ / 2) (by linarith))).const_mul
      (2 / σ)) ?_ ?_
  · refine (Measurable.aestronglyMeasurable ?_)
    fun_prop
  · filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    have ht0 : (0:ℝ) < t := ht
    have hlog := abs_log_le_rpow ht0 hδ
    have hle : t ^ (σ - 1) * |Real.log t| ≤ (2 / σ) * (t ^ (σ - 1 + σ / 2) + t ^ (σ - 1 - σ / 2)) := by
      have h1 : t ^ (σ - 1) * |Real.log t| ≤ t ^ (σ - 1) * ((t ^ (σ/2) + t ^ (-(σ/2))) / (σ/2)) := by
        exact mul_le_mul_of_nonneg_left hlog (Real.rpow_nonneg ht0.le _)
      calc t ^ (σ - 1) * |Real.log t|
          ≤ t ^ (σ - 1) * ((t ^ (σ/2) + t ^ (-(σ/2))) / (σ/2)) :=
            mul_le_mul_of_nonneg_left hlog (Real.rpow_nonneg ht0.le _)
        _ = (2 / σ) * (t ^ (σ - 1) * (t ^ (σ/2) + t ^ (-(σ/2)))) := by
            field_simp
        _ = (2 / σ) * (t ^ (σ - 1 + σ / 2) + t ^ (σ - 1 - σ / 2)) := by
            rw [mul_add, ← Real.rpow_add ht0, ← Real.rpow_add ht0]
            congr 1

    rw [Real.norm_eq_abs, abs_mul, abs_of_nonneg (Real.rpow_nonneg ht0.le _), abs_mul,
      abs_of_nonneg (abs_nonneg _), abs_of_nonneg (Real.exp_pos _).le]
    calc t ^ (σ - 1) * (|Real.log t| * Real.exp (-t))
        = (t ^ (σ - 1) * |Real.log t|) * Real.exp (-t) := by ring
      _ ≤ ((2 / σ) * (t ^ (σ - 1 + σ / 2) + t ^ (σ - 1 - σ / 2))) * Real.exp (-t) :=
          mul_le_mul_of_nonneg_right hle (Real.exp_pos _).le
      _ = (2 / σ) * ((t ^ (σ - 1 + σ / 2) * Real.exp (-t)) + (t ^ (σ - 1 - σ / 2) * Real.exp (-t))) := by
          ring


/-- `t ↦ (t : ℂ) ^ c` is continuous on the positive reals. -/
theorem continuousOn_cpow_ofReal_Ioi (c : ℂ) :
    ContinuousOn (fun t : ℝ => (t : ℂ) ^ c) (Set.Ioi 0) := by
  intro t ht
  exact ((continuousAt_cpow_const (ofReal_mem_slitPlane.2 ht)).comp
    continuous_ofReal.continuousAt).continuousWithinAt

example {n : ℕ} (hn : n ≠ 0) {s : ℂ} :
    ContinuousOn (fun t : ℝ => (t : ℂ) ^ (s - 1) * (↑(Real.log t) * gammaKernel n t))
      (Set.Ioi 0) := by
  refine (continuousOn_cpow_ofReal_Ioi (s - 1)).mul ?_
  refine (ContinuousOn.mul ?_ ?_)
  · exact continuous_ofReal.comp_continuousOn (Real.continuousOn_log.mono (fun x hx => ne_of_gt hx))
  · exact (continuous_gammaKernel n hn).continuousOn



theorem tendsto_mellin_log_gammaKernel {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun n : ℕ => mellin (fun t => Real.log t • gammaKernel n t) s) atTop
      (𝓝 (deriv Gamma s)) := by
  rw [← tendsto_add_atTop_iff_nat 1]
  rw [(hasDerivAt_Gamma_of_re_pos hs).deriv]
  simp only [mellin, smul_eq_mul]
  refine tendsto_integral_of_dominated_convergence
    (fun t : ℝ => t ^ (s.re - 1) * (|Real.log t| * Real.exp (-t)))
    (fun n => ?_) (integrableOn_dominator hs) (fun n => ?_) ?_
  · refine ContinuousOn.aestronglyMeasurable_of_isSeparable ?_ measurableSet_Ioi
      (TopologicalSpace.IsSeparable.of_separableSpace _)
    have h := continuousOn_cpow_ofReal_Ioi (s - 1)
    exact h.mul ((continuous_ofReal.comp_continuousOn
      (Real.continuousOn_log.mono (fun x hx => ne_of_gt hx))).mul
      (continuous_gammaKernel (n + 1) (Nat.succ_ne_zero n)).continuousOn)
  · filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    have ht0 : (0:ℝ) < t := ht
    rw [norm_mul, norm_smul, Real.norm_eq_abs, Complex.norm_cpow_eq_rpow_re_of_pos ht0,
      sub_re, one_re]
    have hgn := norm_gammaKernel_le (n := n + 1) ht0
    have h1 : (0:ℝ) ≤ t ^ (s.re - 1) := Real.rpow_nonneg ht0.le _
    have h2 : (0:ℝ) ≤ |Real.log t| := abs_nonneg _
    exact mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hgn h2) h1
  · filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    have ht0 : (0:ℝ) < t := ht
    have hc : Continuous fun z : ℂ => (t : ℂ) ^ (s - 1) * (↑(Real.log t) * z) := by fun_prop
    exact (hc.tendsto _).comp ((tendsto_gammaKernel ht0).comp (tendsto_add_atTop_nat 1))


theorem tendsto_Lseq_digamma {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun n : ℕ => Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹)
      atTop (𝓝 (Complex.digamma s)) := by
  rw [← tendsto_add_atTop_iff_nat 1]
  have hEq : ∀ n : ℕ,
      Complex.log (((n + 1 : ℕ)) : ℂ) - ∑ j ∈ Finset.range (n + 1 + 1), (s + (j : ℂ))⁻¹
        = logDeriv (fun w : ℂ => GammaSeq w (n + 1)) s := by
    intro n
    have hs' : ∀ j ∈ Finset.range (n + 1 + 1), s + (j : ℂ) ≠ 0 := by
      intro j hj h
      have hre : s.re + (j : ℝ) = 0 := by
        simpa using congrArg Complex.re h
      have : (0:ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
      linarith
    exact (logDeriv_GammaSeq (Nat.succ_ne_zero n) s hs').symm
  simp only [hEq]
  have hderiv : Tendsto (fun n : ℕ => deriv (fun w : ℂ => GammaSeq w (n + 1)) s) atTop
      (𝓝 (deriv Gamma s)) := by
    have h := (tendsto_mellin_log_gammaKernel hs).comp (tendsto_add_atTop_nat 1)
    rw [show (fun n : ℕ => deriv (fun w : ℂ => GammaSeq w (n + 1)) s)
        = (fun n : ℕ => mellin (fun t => Real.log t • gammaKernel n t) s) ∘ (fun a : ℕ => a + 1)
        from by
      funext n
      rw [Function.comp_apply, deriv_GammaSeq_eq_mellin (Nat.succ_ne_zero n) hs]]
    exact h
  have hval : Tendsto (fun n : ℕ => GammaSeq s (n + 1)) atTop (𝓝 (Gamma s)) :=
    (GammaSeq_tendsto_Gamma s).comp (tendsto_add_atTop_nat 1)
  have hne : Gamma s ≠ 0 := Complex.Gamma_ne_zero_of_re_pos hs
  have := hderiv.div hval hne
  rw [Complex.digamma_def, logDeriv_apply]
  refine Tendsto.congr' (Filter.Eventually.of_forall fun n => ?_) this
  exact Pi.div_apply ..



/-- **Part (B), for `σ₀ ≥ 1`**: the digamma growth bound along a vertical line. -/
theorem digammaGrowthBound_of_one_le {σ0 : ℝ} (hσ0 : 1 ≤ σ0) : DigammaGrowthBound σ0 := by
  refine ⟨Real.log σ0 + 20, by linarith [Real.log_nonneg hσ0], fun t => ?_⟩
  have hs : (0:ℝ) < ((σ0 : ℂ) + (t : ℂ) * Complex.I).re := by
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.ofReal_im,
      Complex.I_im, mul_zero, mul_one, sub_zero, add_zero]
    linarith
  have hlim := tendsto_Lseq_digamma (s := (σ0 : ℂ) + (t : ℂ) * Complex.I) hs
  have hbdd : ∀ n : ℕ, ‖Complex.log (n : ℂ)
      - ∑ j ∈ Finset.range (n + 1), (((σ0 : ℂ) + (t : ℂ) * Complex.I) + (j : ℂ))⁻¹‖
      ≤ (Real.log σ0 + 20) * (1 + Real.log (|t| + 2)) := by
    intro n
    have := norm_Lseq_le (σ0 := σ0) (t := t) hσ0 n
    simpa only [Complex.ofReal_re] using this
  have := le_of_tendsto (hlim.norm) (Filter.Eventually.of_forall hbdd)
  simp only [digammaC]
  exact this

/-- The uniform strip bound on `1 ≤ σ ≤ 2`, with the constant `log 2 + 20`. -/
theorem digamma_norm_le_strip {σ t : ℝ} (h1 : 1 ≤ σ) (h2 : σ ≤ 2) :
    ‖Complex.digamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ (Real.log 2 + 20) * (1 + Real.log (|t| + 2)) := by
  have hs : (0:ℝ) < ((σ : ℂ) + (t : ℂ) * Complex.I).re := by
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.ofReal_im,
      Complex.I_im, mul_zero, mul_one, sub_zero, add_zero]
    linarith
  have hlim := tendsto_Lseq_digamma (s := (σ : ℂ) + (t : ℂ) * Complex.I) hs
  have hbdd : ∀ n : ℕ, ‖Complex.log (n : ℂ)
      - ∑ j ∈ Finset.range (n + 1), (((σ : ℂ) + (t : ℂ) * Complex.I) + (j : ℂ))⁻¹‖
      ≤ (Real.log 2 + 20) * (1 + Real.log (|t| + 2)) := by
    intro n
    have hn := norm_Lseq_le (σ0 := σ) (t := t) h1 n
    have hlog : Real.log σ + 20 ≤ Real.log 2 + 20 := by
      have := Real.log_le_log (by linarith) h2
      linarith
    have h1n : (1:ℝ) ≤ 1 + Real.log (|t| + 2) := by
      have : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
      linarith
    calc ‖Complex.log (n : ℂ)
          - ∑ j ∈ Finset.range (n + 1), (((σ : ℂ) + (t : ℂ) * Complex.I) + (j : ℂ))⁻¹‖
        ≤ (Real.log σ + 20) * (1 + Real.log (|t| + 2)) := by
          simpa only [Complex.ofReal_re] using hn
      _ ≤ (Real.log 2 + 20) * (1 + Real.log (|t| + 2)) :=
          mul_le_mul_of_nonneg_right hlog (by linarith)
  have := le_of_tendsto (hlim.norm) (Filter.Eventually.of_forall hbdd)
  simpa only [digammaC] using this

/-- **Part (B), complete**: the digamma growth bound for **every** `σ₀ > 0`. -/
theorem digammaGrowthBound_of_pos {σ0 : ℝ} (hσ0 : 0 < σ0) : DigammaGrowthBound σ0 := by
  refine digammaGrowthBound_of_stripBound_all hσ0
    ⟨Real.log 2 + 20, by linarith [Real.log_nonneg (by norm_num : (1:ℝ) ≤ 2)],
      fun σ hσ t => ?_⟩
  exact digamma_norm_le_strip hσ.1 hσ.2


open Complex.HadamardThreeLines in
/-- **Hadamard three-lines, interpolation form.**  For `f` differentiable on the strip `0 < re z < 1`
and bounded on its closure,
`‖f z‖ ≤ (ε + M₀)^(1 − z.re) · (ε + M₁)^(z.re)` where `Mᵢ = sSupNormIm f i`. -/
theorem norm_le_three_lines {f : ℂ → ℂ} (hd : DiffContOnCl ℂ f (verticalStrip 0 1))
    (hB : BddAbove ((norm ∘ f) '' verticalClosedStrip 0 1))
    {z : ℂ} (hz : z ∈ verticalClosedStrip 0 1) {ε : ℝ} (hε : 0 < ε) :
    ‖f z‖ ≤ (ε + sSupNormIm f 0) ^ (1 - z.re) * (ε + sSupNormIm f 1) ^ (z.re) := by
  have h := norm_mul_invInterpStrip_le_one_of_mem_verticalClosedStrip f ε hε z hd hB hz
  simp only [F] at h
  rw [norm_smul, norm_invInterpStrip f z hε, mul_comm] at h
  have h0 : (0:ℝ) < ε + sSupNormIm f 0 := sSupNormIm_eps_pos f hε 0
  have h1 : (0:ℝ) < ε + sSupNormIm f 1 := sSupNormIm_eps_pos f hε 1
  have hX : (0:ℝ) < (ε + sSupNormIm f 0) ^ (z.re - 1) * (ε + sSupNormIm f 1) ^ (-z.re) :=
    mul_pos (Real.rpow_pos_of_pos h0 _) (Real.rpow_pos_of_pos h1 _)
  rw [← le_div_iff₀ hX] at h
  have key : (1:ℝ) / ((ε + sSupNormIm f 0) ^ (z.re - 1) * (ε + sSupNormIm f 1) ^ (-z.re))
      = (ε + sSupNormIm f 0) ^ (1 - z.re) * (ε + sSupNormIm f 1) ^ (z.re) := by
    rw [one_div, mul_inv, ← Real.rpow_neg h0.le, ← Real.rpow_neg h1.le]
    rw [show -(z.re - 1) = 1 - z.re by ring, show -(-z.re) = z.re by ring]
  rwa [key] at h


open Complex.HadamardThreeLines in
/-- **Regularised three-lines.**  Applying three-lines to `g z = f z * exp (δ z²)` and undoing the
regulariser gives `‖f z‖ ≤ ‖g z‖ · exp (δ (im z)²)`.  Correcting §157: the exponential factor **is**
needed — `‖exp (δ z²)‖ = exp (δ (re z)² − δ (im z)²)` is `< 1` once `|im z| > re z`.  On `|im z| ≤ T`
with `δ = 1/T²` it is `≤ exp 1`. -/
theorem norm_le_of_three_lines_regularised {f : ℂ → ℂ} {δ : ℝ} (hδ : 0 ≤ δ)
    (hd : DiffContOnCl ℂ f (verticalStrip 0 1))
    (hB : BddAbove ((norm ∘ fun z => f z * Complex.exp (δ * z ^ 2)) '' verticalClosedStrip 0 1))
    {z : ℂ} (hz : z ∈ verticalClosedStrip 0 1) {ε : ℝ} (hε : 0 < ε) :
    ‖f z‖ ≤ ((ε + sSupNormIm (fun w => f w * Complex.exp (δ * w ^ 2)) 0) ^ (1 - z.re)
      * (ε + sSupNormIm (fun w => f w * Complex.exp (δ * w ^ 2)) 1) ^ (z.re))
      * Real.exp (δ * z.im ^ 2) := by
  set g : ℂ → ℂ := fun w => f w * Complex.exp (δ * w ^ 2) with hg
  have hgd : DiffContOnCl ℂ g (verticalStrip 0 1) :=
    ⟨hd.differentiableOn.mul (Differentiable.differentiableOn (by fun_prop)),
      hd.continuousOn.mul (by fun_prop)⟩
  have hnorm : ‖Complex.exp (δ * z ^ 2)‖ = Real.exp (δ * (z.re ^ 2 - z.im ^ 2)) := by
    rw [Complex.norm_exp]
    congr 1
    have h2 : (z ^ 2).re = z.re ^ 2 - z.im ^ 2 := by rw [sq, Complex.mul_re]; ring
    simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
      mul_zero, sub_zero, h2]
    ring
  have hkey : ‖f z‖ ≤ ‖g z‖ * Real.exp (δ * z.im ^ 2) := by
    rw [hg, norm_mul, hnorm]
    have hexp : Real.exp (δ * (z.re ^ 2 - z.im ^ 2)) * Real.exp (δ * z.im ^ 2)
        = Real.exp (δ * z.re ^ 2) := by
      rw [← Real.exp_add]; congr 1; ring
    have hge : ‖f z‖ ≤ ‖f z‖ * Real.exp (δ * (z.re ^ 2 - z.im ^ 2)) * Real.exp (δ * z.im ^ 2) := by
      rw [mul_assoc, hexp]
      calc ‖f z‖ = ‖f z‖ * 1 := (mul_one _).symm
        _ ≤ ‖f z‖ * Real.exp (δ * z.re ^ 2) := by
            refine mul_le_mul_of_nonneg_left ?_ (norm_nonneg _)
            rw [Real.one_le_exp_iff]
            nlinarith [sq_nonneg z.re, hδ]
    linarith [hge]
  exact hkey.trans (mul_le_mul_of_nonneg_right
    (norm_le_three_lines (f := g) hgd (by simpa only [hg] using hB) hz hε)
    (Real.exp_pos _).le)


/-- **Uniform digamma bound on `[1/4, 1]`.**  Via the recursion `ψ(s) = ψ(s+1) − s⁻¹`, which costs
`1/σ₀ ≤ 4`, and §155's uniform strip bound on `[1,2]`.  Needed because the `∃ C` inside
`DigammaGrowthBound` is opaque, so no constant can be extracted from §155 — the uniform form must be
proved directly. -/
theorem digamma_norm_le_quarter {σ0 t : ℝ} (h0 : 1/4 ≤ σ0) (h1 : σ0 ≤ 1) :
    ‖Complex.digamma ((σ0 : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ (Real.log 2 + 25) * (1 + Real.log (|t| + 2)) := by
  have hσ0 : (0:ℝ) < σ0 := by linarith
  have hne : ∀ m : ℕ, ((σ0 : ℂ) + (t : ℂ) * Complex.I) ≠ -(m : ℂ) := by
    intro m hc
    have hre : (((σ0 : ℂ) + (t : ℂ) * Complex.I)).re = σ0 := by simp
    have h2 : (((σ0 : ℂ) + (t : ℂ) * Complex.I)).re = -(m : ℝ) := by rw [hc]; simp
    have hm : (0:ℝ) ≤ m := Nat.cast_nonneg m
    rw [hre] at h2
    linarith
  have hrec := Complex.digamma_apply_add_one ((σ0 : ℂ) + (t : ℂ) * Complex.I) hne
  have harg : ((σ0 : ℂ) + (t : ℂ) * Complex.I) + 1 = ((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I := by
    push_cast; ring
  have hstrip := digamma_norm_le_strip (σ := σ0 + 1) (t := t) (by linarith) (by linarith)
  have hinv : ‖(((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹‖ ≤ 4 := by
    rw [norm_inv]
    refine inv_le_of_inv_le₀ ?_ ?_
    · positivity
    · calc (4:ℝ)⁻¹ = 1/4 := by norm_num
        _ ≤ σ0 := h0
        _ = (((σ0 : ℂ) + (t : ℂ) * Complex.I)).re := by simp
        _ ≤ ‖(σ0 : ℂ) + (t : ℂ) * Complex.I‖ := Complex.re_le_norm _
  have hL : (1:ℝ) ≤ 1 + Real.log (|t| + 2) := by
    have : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
    linarith
  have hlog2 : (0:ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  calc ‖Complex.digamma ((σ0 : ℂ) + (t : ℂ) * Complex.I)‖
      = ‖Complex.digamma (((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I)
          - (((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹‖ := by
        rw [← harg, hrec]; ring
    _ ≤ ‖Complex.digamma (((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I)‖
        + ‖(((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹‖ := norm_sub_le _ _
    _ ≤ (Real.log 2 + 20) * (1 + Real.log (|t| + 2)) + 4 := add_le_add hstrip hinv
    _ ≤ (Real.log 2 + 25) * (1 + Real.log (|t| + 2)) := by nlinarith [hL, hlog2]


/-- `MeromorphicOn.divisor`, wrapped (README rule 1).  Elaborating `MeromorphicOn.divisor f U u` in a
*statement* blows the heartbeat cap (§165); going through this opaque wrapper keeps statements cheap
while `rw [zeroDivisor]` still recovers the real thing in proofs. -/
@[irreducible] noncomputable def zeroDivisor (f : ℂ → ℂ) (U : Set ℂ) : Function.locallyFinsuppWithin U ℤ :=
  MeromorphicOn.divisor f U

/-- **Jensen's bound for zero counting.**  Directly `AnalyticOnNhd.sum_divisor_le`, stated through
`zeroDivisor` so the statement elaborates.  Hypotheses are kept in Mathlib's `|r|`, `|R|` form. -/
theorem zeroCount_le_of_jensen {f : ℂ → ℂ} {c : ℂ} {r R M : ℝ}
    (hr : 0 < |r|) (hrR : |r| < |R|) (hM : 1 ≤ M)
    (h₁ : AnalyticOnNhd ℂ f (closedBall c |R|)) (h₂ : f c ≠ 0)
    (hb : ∀ z ∈ sphere c |R|, ‖f z‖ ≤ M) :
    ∑ᶠ u, zeroDivisor f (closedBall c |r|) u
      ≤ Real.log (M / ‖f c‖) / Real.log (R / r) := by
  rw [zeroDivisor]
  exact AnalyticOnNhd.sum_divisor_le hr hrR hM h₁ h₂ hb


/-- **The seam for `norm_Gamma_decay` (§173).**  A bound on `GammaSeq`'s modulus **uniform in `n`**
passes to `Γ` itself.  Since `GammaSeq s n = n^s n!/∏_{j≤n}(s+j)` has fully explicit modulus
(`n^σ n!/∏_{j≤n}√((σ+j)²+t²)`), a successor needs only to bound *that*, with no Stirling and no lower
bound on `Γ`. -/
theorem norm_Gamma_le_of_GammaSeq_bound {s : ℂ} {C : ℝ} (h : ∀ n : ℕ, ‖GammaSeq s n‖ ≤ C) :
    ‖Complex.Gamma s‖ ≤ C :=
  le_of_tendsto_of_tendsto (GammaSeq_tendsto_Gamma s).norm tendsto_const_nhds
    (Filter.Eventually.of_forall h)


/-- ℝ-valued Gaussian sum (Mathlib's `sum_range_id` is ℕ-valued only). -/
theorem sum_range_cast_id (n : ℕ) :
    ∑ j ∈ Finset.range n, (j : ℝ) = (n : ℝ) * ((n : ℝ) - 1) / 2 := by
  induction n with
  | zero => simp
  | succ k ih => rw [Finset.sum_range_succ, ih]; push_cast; ring

theorem sum_div_sub_one {n : ℕ} (hn : n ≠ 0) :
    ∑ j ∈ Finset.range n, (((j : ℝ) + 1) / n - 1) = -(((n : ℝ) - 1) / 2) := by
  have hn0 : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn
  have hsum : ∑ j ∈ Finset.range n, ((j : ℝ) + 1) = (n : ℝ) * ((n : ℝ) + 1) / 2 := by
    rw [Finset.sum_add_distrib, Finset.sum_const, Finset.card_range, nsmul_eq_mul,
      sum_range_cast_id]
    push_cast
    ring
  rw [Finset.sum_sub_distrib, ← Finset.sum_div, hsum, Finset.sum_const, Finset.card_range,
    nsmul_eq_mul]
  field_simp
  ring

/-- `log (n!/n^n) ≤ −(n−1)/2` for `n ≠ 0`. -/
theorem log_factorial_div_pow_le {n : ℕ} (hn : n ≠ 0) :
    Real.log ((n.factorial : ℝ) / (n : ℝ) ^ n) ≤ -(((n : ℝ) - 1) / 2) := by
  have hnpos : (0:ℝ) < (n : ℝ) := Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn)
  have hfac : (0:ℝ) < (n.factorial : ℝ) := Nat.cast_pos.mpr (Nat.factorial_pos n)
  have hnn : (0:ℝ) < (n : ℝ) ^ n := pow_pos hnpos n
  have hL : ∑ j ∈ Finset.range n, Real.log (((j : ℝ) + 1) / n)
      = (∑ j ∈ Finset.range n, Real.log ((j : ℝ) + 1)) - ∑ j ∈ Finset.range n, Real.log n := by
    rw [← Finset.sum_sub_distrib]
    exact Finset.sum_congr rfl fun j hj => Real.log_div (by positivity) hnpos.ne'
  have hRn : ∑ j ∈ Finset.range n, Real.log n = (n : ℝ) * Real.log n := by
    rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
  rw [Real.log_div hfac.ne' hnn.ne', Real.log_pow, ← Real.sum_log_add_one_eq_log_factorial,
    ← hRn, ← hL, ← sum_div_sub_one hn]
  exact Finset.sum_le_sum fun j hj => Real.log_le_sub_one_of_pos (by positivity)

/-- **Elementary factorial decay, no Stirling.** -/
theorem factorial_div_pow_le {n : ℕ} (hn : n ≠ 0) :
    (n.factorial : ℝ) / (n : ℝ) ^ n ≤ Real.exp (-(((n : ℝ) - 1) / 2)) := by
  have hnpos : (0:ℝ) < (n : ℝ) := Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn)
  have hfac : (0:ℝ) < (n.factorial : ℝ) := Nat.cast_pos.mpr (Nat.factorial_pos n)
  have hpos : (0:ℝ) < (n.factorial : ℝ) / (n : ℝ) ^ n := div_pos hfac (pow_pos hnpos n)
  rw [← Real.log_le_log_iff hpos (Real.exp_pos _), Real.log_exp]
  exact log_factorial_div_pow_le hn


/-- `∏ f i ^ r = (∏ f i) ^ r` for nonnegative `f` (no such lemma for `ℝ` in Mathlib). -/
theorem prod_rpow_real {ι : Type*} (s : Finset ι) (f : ι → ℝ) (r : ℝ)
    (h : ∀ i ∈ s, 0 ≤ f i) :
    ∏ i ∈ s, (f i) ^ r = (∏ i ∈ s, f i) ^ r := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | insert a s ha ih =>
    rw [Finset.prod_insert ha, Finset.prod_insert ha, Real.mul_rpow (h a (Finset.mem_insert_self a s))]
    · rw [ih fun i hi => h i (Finset.mem_insert_of_mem hi)]
    · exact Finset.prod_nonneg fun i hi => h i (Finset.mem_insert_of_mem hi)

/-- **The product telescoping step.**  `(n+1)^σ ≤ ∏_{j<n} (1 + σ/(j+1))` for `0 < σ ≤ 1`, by
Bernoulli (`Real.rpow_one_add_le_one_add_mul_self`) pointwise and `∏(1 + 1/(j+1)) = n+1`. -/
theorem rpow_succ_le_prod_one_add_div {σ : ℝ} (hσ : 0 < σ) (hσ1 : σ ≤ 1) (n : ℕ) :
    ((n : ℝ) + 1) ^ σ ≤ ∏ j ∈ Finset.range n, (1 + σ / ((j : ℝ) + 1)) := by
  have htel : ∏ j ∈ Finset.range n, (1 + 1 / ((j : ℝ) + 1)) = (n : ℝ) + 1 := by
    induction n with
    | zero => simp
    | succ k ih =>
      rw [Finset.prod_range_succ, ih]
      have hk : ((k : ℝ) + 1) ≠ 0 := by positivity
      rw [mul_add, mul_one, mul_one_div, div_self hk]
      push_cast
      ring
  have hpt : ∀ j ∈ Finset.range n,
      (1 + 1 / ((j : ℝ) + 1)) ^ σ ≤ (1 + σ / ((j : ℝ) + 1)) := by
    intro j hj
    have := rpow_one_add_le_one_add_mul_self (s := 1 / ((j : ℝ) + 1))
      (by linarith [show (0:ℝ) ≤ 1 / ((j : ℝ) + 1) by positivity]) hσ.le hσ1
    rwa [mul_div_assoc', mul_one] at this
  calc ((n : ℝ) + 1) ^ σ
      = (∏ j ∈ Finset.range n, (1 + 1 / ((j : ℝ) + 1))) ^ σ := by rw [htel]
    _ = ∏ j ∈ Finset.range n, (1 + 1 / ((j : ℝ) + 1)) ^ σ :=
        (prod_rpow_real _ _ _ fun j hj => by positivity).symm
    _ ≤ ∏ j ∈ Finset.range n, (1 + σ / ((j : ℝ) + 1)) := by
        gcongr with j hj
        exact hpt j hj


/-- **Step 2(a), quotient form.**  `n^σ · n!/∏_{j≤n}(σ+j) ≤ 1/σ` for `0 < σ ≤ 1`, uniformly in `n`.
This is the `n`-part of `‖GammaSeq s n‖`, bounded independently of `n` and of `t`. -/
theorem natCast_pow_mul_factorial_div_prod_le {σ : ℝ} (hσ : 0 < σ) (hσ1 : σ ≤ 1) (n : ℕ) :
    (n : ℝ) ^ σ * (n.factorial : ℝ) / ∏ j ∈ Finset.range (n + 1), (σ + (j : ℝ)) ≤ 1 / σ := by
  have hden : ∏ j ∈ Finset.range (n + 1), (σ + (j : ℝ))
      = σ * ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) := by
    rw [Finset.prod_range_succ']
    have hpt : ∀ j ∈ Finset.range n, (σ + (((j + 1 : ℕ)) : ℝ)) = (σ + ((j : ℝ) + 1)) :=
      fun j hj => by push_cast; ring
    rw [Finset.prod_congr rfl hpt]
    push_cast
    ring
  have hfac : (n.factorial : ℝ) = ∏ j ∈ Finset.range n, ((j : ℝ) + 1) := by
    rw [Nat.factorial_eq_prod_range_add_one]
    push_cast
    rfl
  have hkey : ((n : ℝ) + 1) ^ σ * (n.factorial : ℝ)
      ≤ ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) := by
    rw [hfac]
    have hP1 : (0:ℝ) ≤ ∏ j ∈ Finset.range n, ((j : ℝ) + 1) :=
      Finset.prod_nonneg fun j hj => by positivity
    have h2 := mul_le_mul_of_nonneg_left (rpow_succ_le_prod_one_add_div hσ hσ1 n) hP1
    have hsplit : (∏ j ∈ Finset.range n, ((j : ℝ) + 1))
          * (∏ j ∈ Finset.range n, (1 + σ / ((j : ℝ) + 1)))
        = ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) := by
      rw [← Finset.prod_mul_distrib]
      exact Finset.prod_congr rfl fun j hj => by
        have hj0 : ((j : ℝ) + 1) ≠ 0 := by positivity
        field_simp
        ring
    rw [hsplit] at h2
    calc ((n : ℝ) + 1) ^ σ * ∏ j ∈ Finset.range n, ((j : ℝ) + 1)
        = (∏ j ∈ Finset.range n, ((j : ℝ) + 1)) * ((n : ℝ) + 1) ^ σ := mul_comm _ _
      _ ≤ ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) := h2
  have hP : (0:ℝ) < ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) :=
    Finset.prod_pos fun j hj => by positivity
  have hfacpos : (0:ℝ) ≤ (n.factorial : ℝ) := (Nat.cast_pos.mpr (Nat.factorial_pos n)).le
  have hn1 : (n : ℝ) ≤ (n : ℝ) + 1 := by linarith
  have hle : (n : ℝ) ^ σ * (n.factorial : ℝ) ≤ ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) :=
    calc (n : ℝ) ^ σ * (n.factorial : ℝ)
        ≤ ((n : ℝ) + 1) ^ σ * (n.factorial : ℝ) :=
          mul_le_mul_of_nonneg_right
            (Real.rpow_le_rpow (Nat.cast_nonneg n) hn1 hσ.le) hfacpos
      _ ≤ ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1)) := hkey
  rw [hden, div_le_iff₀ (by positivity : (0:ℝ) < σ * ∏ j ∈ Finset.range n, (σ + ((j : ℝ) + 1))),
    one_div, inv_mul_cancel_left₀ hσ.ne']
  exact hle


/-- **Exact modulus of `GammaSeq`** (step 2(b), structural).  Since
`GammaSeq s n = n^s · n!/∏_{j≤n}(s+j)` and `‖s+j‖ = √((σ+j)²+t²)`:
`‖GammaSeq s n‖ = n^σ · n!/∏_{j≤n}√((σ+j)²+t²)`. -/
theorem norm_GammaSeq_eq {s : ℂ} {n : ℕ} (hn : n ≠ 0) :
    ‖GammaSeq s n‖ = (n : ℝ) ^ s.re * (n.factorial : ℝ)
      / ∏ j ∈ Finset.range (n + 1), Real.sqrt ((s.re + (j : ℝ)) ^ 2 + s.im ^ 2) := by
  have hnpos : (0:ℝ) < (n : ℝ) := Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn)
  have hnC : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr hn
  have hcpow : ‖(n : ℂ) ^ s‖ = (n : ℝ) ^ s.re :=
    Complex.norm_cpow_eq_rpow_re_of_pos hnpos s
  have hfacn : ‖((n.factorial : ℕ) : ℂ)‖ = (n.factorial : ℝ) := by
    rw [Complex.norm_natCast]
  have hprod : ∀ j ∈ Finset.range (n + 1), ‖s + (j : ℂ)‖
      = Real.sqrt ((s.re + (j : ℝ)) ^ 2 + s.im ^ 2) := by
    intro j hj
    have : s + (j : ℂ) = ((s.re + (j : ℝ) : ℝ) : ℂ) + (s.im : ℂ) * Complex.I := by
      apply Complex.ext <;> simp
    rw [this, Complex.norm_add_mul_I]
  rw [GammaSeq, norm_div, norm_mul, hcpow, hfacn, norm_prod]
  exact congrArg _ (Finset.prod_congr rfl hprod)


/-- Product monotonicity for `ℝ` (Mathlib's `prod_le_prod` needs `MulLeftMono ℝ`, which does not
exist). -/
theorem prod_le_prod_of_nonneg {ι : Type*} (s : Finset ι) {f g : ι → ℝ}
    (hf : ∀ i ∈ s, 0 ≤ f i) (h : ∀ i ∈ s, f i ≤ g i) :
    ∏ i ∈ s, f i ≤ ∏ i ∈ s, g i := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | insert a s ha ih =>
    rw [Finset.prod_insert ha, Finset.prod_insert ha]
    exact mul_le_mul (h a (Finset.mem_insert_self a s))
      (ih (fun i hi => hf i (Finset.mem_insert_of_mem hi))
          (fun i hi => h i (Finset.mem_insert_of_mem hi)))
      (Finset.prod_nonneg fun i hi => hf i (Finset.mem_insert_of_mem hi))
      (le_trans (hf a (Finset.mem_insert_self a s)) (h a (Finset.mem_insert_self a s)))

/-- Each factor of `∏_{j≤n}√((σ+j)²+t²)` dominates both `|t|` and `σ+j` (for `σ+j ≥ 0`). -/
theorem le_sqrt_sq_add_sq_left {x t : ℝ} : |t| ≤ Real.sqrt (x ^ 2 + t ^ 2) := by
  rw [Real.le_sqrt (abs_nonneg t) (by positivity), sq_abs]
  nlinarith [sq_nonneg x]

theorem le_sqrt_sq_add_sq_right {x t : ℝ} (hx : 0 ≤ x) : x ≤ Real.sqrt (x ^ 2 + t ^ 2) := by
  rw [Real.le_sqrt hx (by positivity)]
  nlinarith [sq_nonneg t]

/-- **Factor split.**  For any `k ≤ n+1`, the product dominates `|t|^k · ∏_{j=k}^{n}(σ+j)`. -/
theorem prod_sqrt_lower (σ t : ℝ) (hσ : 0 ≤ σ) (n k : ℕ) (hk : k ≤ n + 1) :
    |t| ^ k * ∏ j ∈ Finset.range (n + 1 - k), (σ + ((k + j : ℕ) : ℝ))
      ≤ ∏ j ∈ Finset.range (n + 1), Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2) := by
  have hsplit : ∏ j ∈ Finset.range (n + 1), Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2)
      = (∏ j ∈ Finset.range k, Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2))
        * ∏ j ∈ Finset.range (n + 1 - k), Real.sqrt ((σ + (((k + j : ℕ)) : ℝ)) ^ 2 + t ^ 2) := by
    conv_lhs => rw [← Nat.add_sub_of_le hk]
    rw [Finset.prod_range_add]
  rw [hsplit]
  refine mul_le_mul ?_ ?_ ?_ ?_
  · calc |t| ^ k = ∏ _j ∈ Finset.range k, |t| := by rw [Finset.prod_const, Finset.card_range]
      _ ≤ ∏ j ∈ Finset.range k, Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2) :=
          prod_le_prod_of_nonneg _ (fun j hj => abs_nonneg t) fun j hj => le_sqrt_sq_add_sq_left
  · exact prod_le_prod_of_nonneg _ (fun j hj => by positivity)
      fun j hj => le_sqrt_sq_add_sq_right (by positivity)
  · positivity
  · exact Finset.prod_nonneg fun j hj => Real.sqrt_nonneg _


/-- **Each factor of the ratio `∏(σ+j)/∏√((σ+j)²+t²)` is `≤ min 1 ((σ+j)/|t|)`.**  Above by
`√(x²+t²) ≥ x`, below by `√(x²+t²) ≥ |t|`. -/
theorem div_sqrt_le_min {x t : ℝ} (hx : 0 ≤ x) (ht : t ≠ 0) :
    x / Real.sqrt (x ^ 2 + t ^ 2) ≤ min 1 (x / |t|) := by
  have hs : 0 < Real.sqrt (x ^ 2 + t ^ 2) := Real.sqrt_pos.mpr (by positivity)
  have ht' : 0 < |t| := abs_pos.mpr ht
  refine le_min ?_ ?_
  · rw [div_le_one hs]
    exact le_sqrt_sq_add_sq_right hx
  · exact div_le_div_of_nonneg_left hx ht' (le_sqrt_sq_add_sq_left (x := x) (t := t))


/-- **Truncated product estimate.**  If every index `≥ k` already makes the factor at least `1`, the
whole product is dominated by its first `k` factors, which telescope to `k!/|t|^k`. -/
theorem prod_min_one_div_le (t : ℝ) (ht : t ≠ 0) (n k : ℕ) (hk : k ≤ n + 1)
    (hk' : ∀ j : ℕ, k ≤ j → (1:ℝ) ≤ ((j : ℝ) + 1) / |t|) :
    ∏ j ∈ Finset.range (n + 1), min 1 (((j : ℝ) + 1) / |t|)
      ≤ (k.factorial : ℝ) / |t| ^ k := by
  set g : ℕ → ℝ := fun j => min 1 (((j : ℝ) + 1) / |t|) with hg
  have htail : ∏ j ∈ Finset.range (n + 1 - k), g (k + j) = 1 := by
    rw [Finset.prod_eq_one]
    intro j hj
    rw [hg]
    simp only
    rw [min_eq_left]
    simpa using hk' (k + j) (Nat.le_add_right k j)
  have hsplit : ∏ j ∈ Finset.range (n + 1), g j
      = (∏ j ∈ Finset.range k, g j) * ∏ j ∈ Finset.range (n + 1 - k), g (k + j) := by
    conv_lhs => rw [← Nat.add_sub_of_le hk]
    exact Finset.prod_range_add g k (n + 1 - k)
  rw [hsplit, htail, mul_one]
  calc ∏ j ∈ Finset.range k, g j
      ≤ ∏ j ∈ Finset.range k, (((j : ℝ) + 1) / |t|) := by
        refine prod_le_prod_of_nonneg _ (fun j hj => by positivity) fun j hj => ?_
        rw [hg]; simp only; exact min_le_right _ _
    _ = (∏ j ∈ Finset.range k, ((j : ℝ) + 1)) / |t| ^ k := by
        rw [Finset.prod_div_distrib, Finset.prod_const, Finset.card_range]
    _ = (k.factorial : ℝ) / |t| ^ k := by
        rw [Nat.factorial_eq_prod_range_add_one]
        push_cast
        rfl


/-- `N!/(N−1)^N ≤ N·exp(−(N−2)/2)` for `N ≥ 2`. -/
theorem factorial_div_pow_pred_le {N : ℕ} (hN : 2 ≤ N) :
    (N.factorial : ℝ) / (((N - 1 : ℕ)) : ℝ) ^ N
      ≤ (N : ℝ) * Real.exp (-(((N : ℝ) - 2) / 2)) := by
  have hN1 : 1 ≤ N := le_trans (by norm_num) hN
  have hcast : ((N - 1 : ℕ) : ℝ) = (N : ℝ) - 1 := by
    rw [Nat.cast_sub hN1]; ring
  have hb : (1:ℝ) ≤ ((N - 1 : ℕ) : ℝ) := by
    rw [hcast]
    have h2 : (2:ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
    linarith
  have hfac : (N.factorial : ℝ) = (N : ℝ) * ((N - 1).factorial : ℝ) := by
    conv_lhs => rw [show N = (N - 1) + 1 by omega, Nat.factorial_succ]
    push_cast
    rw [hcast]; ring
  have hstep := factorial_div_pow_le (n := N - 1) (by omega : (N - 1) ≠ 0)
  have hsplit : ((N - 1 : ℕ) : ℝ) ^ N
      = ((N - 1 : ℕ) : ℝ) * ((N - 1 : ℕ) : ℝ) ^ (N - 1) := by
    conv_lhs => rw [show N = (N - 1) + 1 by omega]
    rw [pow_succ']
    simp only [Nat.add_sub_cancel]
  have h3 : (N : ℝ) / ((N - 1 : ℕ) : ℝ) ≤ (N : ℝ) := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith [hb]
  rw [hfac, hsplit]
  calc (N : ℝ) * ((N - 1).factorial : ℝ)
        / (((N - 1 : ℕ) : ℝ) * ((N - 1 : ℕ) : ℝ) ^ (N - 1))
      = (N : ℝ) / ((N - 1 : ℕ) : ℝ)
        * (((N - 1).factorial : ℝ) / ((N - 1 : ℕ) : ℝ) ^ (N - 1)) := by
        field_simp
    _ ≤ (N : ℝ) / ((N - 1 : ℕ) : ℝ) * Real.exp (-((((N - 1 : ℕ) : ℝ) - 1) / 2)) :=
        mul_le_mul_of_nonneg_left hstep (by positivity)
    _ ≤ (N : ℝ) * Real.exp (-((((N - 1 : ℕ) : ℝ) - 1) / 2)) :=
        mul_le_mul_of_nonneg_right h3 (Real.exp_pos _).le
    _ = (N : ℝ) * Real.exp (-(((N : ℝ) - 2) / 2)) := by
        rw [hcast]; ring_nf


/-- **The seam, eventual form.**  A bound on `‖GammaSeq s n‖` holding only *eventually in `n`* already
passes to `Γ`.  This is strictly easier to use than the `∀ n` form: in step 2(b) the split point
`min (n+1) ⌈|t|⌉` can then be taken to be `⌈|t|⌉` outright, so no `min` appears at all. -/
theorem norm_Gamma_le_of_GammaSeq_eventually {s : ℂ} {C : ℝ}
    (h : ∀ᶠ n in Filter.atTop, ‖GammaSeq s n‖ ≤ C) : ‖Complex.Gamma s‖ ≤ C :=
  le_of_tendsto_of_tendsto (GammaSeq_tendsto_Gamma s).norm tendsto_const_nhds h


/-- **Step 2(b), assembled.**  For `0 < σ ≤ 1`, `t ≠ 0` and `n ≥ ⌈|t|⌉`:
`‖GammaSeq (σ+it) n‖ ≤ (1/σ)·⌈|t|⌉!/|t|^⌈|t|⌉` — the split point is `⌈|t|⌉` **outright** (§187). -/
theorem norm_GammaSeq_le_eventually {σ t : ℝ} (hσ0 : 0 < σ) (hσ1 : σ ≤ 1) (ht : t ≠ 0)
    {n : ℕ} (hn : ⌈|t|⌉₊ ≤ n) :
    ‖GammaSeq ((σ : ℂ) + (t : ℂ) * Complex.I) n‖
      ≤ (1 / σ) * ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊) := by
  set N := ⌈|t|⌉₊ with hN
  have hNpos : 0 < N := by rw [hN]; exact Nat.ceil_pos.mpr (abs_pos.mpr ht)
  have hn0 : n ≠ 0 := by omega
  set P : ℝ := ∏ j ∈ Finset.range (n + 1), Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2) with hP
  set Q : ℝ := ∏ j ∈ Finset.range (n + 1), (σ + (j : ℝ)) with hQ
  have hNle : N ≤ n + 1 := le_trans hn (Nat.le_succ n)
  have hmod := norm_GammaSeq_eq (s := (σ : ℂ) + (t : ℂ) * Complex.I) (n := n) hn0
  have hre : (((σ : ℂ) + (t : ℂ) * Complex.I)).re = σ := by simp
  have him : (((σ : ℂ) + (t : ℂ) * Complex.I)).im = t := by simp
  rw [hmod, hre, him]
  have hQ1 : (n : ℝ) ^ σ * (n.factorial : ℝ) / Q ≤ 1 / σ :=
    natCast_pow_mul_factorial_div_prod_le hσ0 hσ1 n
  have hPpos : 0 < P := Finset.prod_pos fun j hj => Real.sqrt_pos.mpr (by positivity)
  have hQpos : 0 < Q := Finset.prod_pos fun j hj => by positivity
  have hQN : 0 < ((N.factorial : ℝ) / |t| ^ N) := by positivity
  have hR : Q / P ≤ (N.factorial : ℝ) / |t| ^ N := by
    have h1 : Q / P = ∏ j ∈ Finset.range (n + 1),
        ((σ + (j : ℝ)) / Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2)) := by
      rw [hP, hQ, Finset.prod_div_distrib]
    have h2 : ∀ j ∈ Finset.range (n + 1),
        ((σ + (j : ℝ)) / Real.sqrt ((σ + (j : ℝ)) ^ 2 + t ^ 2))
          ≤ min 1 (((j : ℝ) + 1) / |t|) := by
      intro j hj
      have hx : (0:ℝ) ≤ σ + (j : ℝ) := by positivity
      refine (div_sqrt_le_min hx ht).trans ?_
      exact min_le_min_left _ (by
        rw [div_le_div_iff_of_pos_right (abs_pos.mpr ht)]
        linarith)
    calc Q / P ≤ ∏ j ∈ Finset.range (n + 1), min 1 (((j : ℝ) + 1) / |t|) := by
          rw [h1]
          exact prod_le_prod_of_nonneg _ (fun j hj => by positivity) h2
      _ ≤ (N.factorial : ℝ) / |t| ^ N := by
          refine prod_min_one_div_le t ht n N hNle ?_
          intro j hj
          have hj' : |t| ≤ (j : ℝ) := le_trans (Nat.le_ceil _) (by exact_mod_cast hj)
          rw [le_div_iff₀ (abs_pos.mpr ht)]
          linarith
  calc (n : ℝ) ^ σ * (n.factorial : ℝ) / P
      = ((n : ℝ) ^ σ * (n.factorial : ℝ) / Q) * (Q / P) := by
        field_simp
    _ ≤ (1 / σ) * ((N.factorial : ℝ) / |t| ^ N) :=
        mul_le_mul hQ1 hR (by positivity) (by positivity)
    _ = (1 / σ) * (N.factorial : ℝ) / |t| ^ N := by ring


/-- **Exponential beats linear, explicitly.**  `|t|·exp(−|t|/4) ≤ 4/e` for `t ≠ 0`, from
`log u ≤ u − 1` at `u = |t|/4`. -/
theorem abs_mul_exp_neg_div_le {t : ℝ} (ht : t ≠ 0) :
    |t| * Real.exp (-(|t| / 4)) ≤ 4 / Real.exp 1 := by
  have ht0 : 0 < |t| := abs_pos.mpr ht
  have h4 : (0:ℝ) < 4 := by norm_num
  have hpos : 0 < |t| / 4 := div_pos ht0 h4
  have hlog : Real.log (|t| / 4) ≤ |t| / 4 - 1 := Real.log_le_sub_one_of_pos hpos
  have hdiv : |t| / 4 ≤ Real.exp (|t| / 4) / Real.exp 1 := by
    calc |t| / 4 = Real.exp (Real.log (|t| / 4)) := (Real.exp_log hpos).symm
      _ ≤ Real.exp (|t| / 4 - 1) := Real.exp_le_exp.mpr hlog
      _ = Real.exp (|t| / 4) / Real.exp 1 := Real.exp_sub _ _
  have h2 : |t| ≤ 4 * (Real.exp (|t| / 4) / Real.exp 1) := by linarith
  rw [Real.exp_neg]
  calc |t| * (Real.exp (|t| / 4))⁻¹
      ≤ 4 * (Real.exp (|t| / 4) / Real.exp 1) * (Real.exp (|t| / 4))⁻¹ :=
        mul_le_mul_of_nonneg_right h2 (by positivity)
    _ = 4 / Real.exp 1 := by
        rw [div_eq_mul_inv]
        field_simp


/-- **`Γ` is at most `1` on `[1,2]`** — from `Real.convexOn_Gamma` and `Γ 1 = Γ 2 = 1`. -/
theorem Gamma_le_one_of_mem {σ : ℝ} (h1 : 1 ≤ σ) (h2 : σ ≤ 2) : Real.Gamma σ ≤ 1 := by
  have hpos : (0:ℝ) < σ := lt_of_lt_of_le one_pos h1
  have hx : (1:ℝ) ∈ Set.Ioi (0:ℝ) := by norm_num
  have hy : (2:ℝ) ∈ Set.Ioi (0:ℝ) := by norm_num
  have hz : σ ∈ Set.Ioi (0:ℝ) := hpos
  have hrepr : σ = (2 - σ) * 1 + (σ - 1) * 2 := by ring
  have hcoef : (2 - σ) + (σ - 1) = 1 := by ring
  have h := Real.convexOn_Gamma.2 hx hy (by linarith) (by linarith) hcoef
  rw [hrepr]
  calc Real.Gamma ((2 - σ) • (1:ℝ) + (σ - 1) • (2:ℝ))
      = Real.Gamma ((2 - σ) * 1 + (σ - 1) * 2) := by rw [smul_eq_mul, smul_eq_mul]
    _ ≤ (2 - σ) * Real.Gamma 1 + (σ - 1) * Real.Gamma 2 := by
        simpa only [smul_eq_mul] using h
    _ = 1 := by rw [Real.Gamma_one, Real.Gamma_two]; ring

/-- **`Γ` is at most `2` on `[1/2,1]`** — `Γ(σ) = Γ(σ+1)/σ ≤ 1/σ ≤ 2`. -/
theorem Gamma_le_two_of_mem {σ : ℝ} (h1 : 1/2 ≤ σ) (h2 : σ ≤ 1) : Real.Gamma σ ≤ 2 := by
  have hpos : (0:ℝ) < σ := by linarith
  have hrec : Real.Gamma σ = Real.Gamma (σ + 1) / σ := by
    rw [Real.Gamma_add_one (ne_of_gt hpos), mul_div_cancel_left₀ _ (ne_of_gt hpos)]
  rw [hrec]
  have hb : Real.Gamma (σ + 1) ≤ 1 := Gamma_le_one_of_mem (by linarith) (by linarith)
  calc Real.Gamma (σ + 1) / σ ≤ 1 / σ := by
        exact div_le_div_of_nonneg_right hb hpos.le
    _ ≤ 2 := by
        rw [div_le_iff₀ hpos]
        linarith


/-- **The decay of `⌈|t|⌉!/|t|^⌈|t|⌉`.**  For `|t| ≥ 2`: §186 at `N := ⌈|t|⌉`, then
`N ≤ 2|t|` and `N ≥ |t|` reduce it to `2e·|t|·exp(−|t|/2)`, and §189 kills the linear factor. -/
theorem factorial_div_pow_ceil_le {t : ℝ} (ht : 2 ≤ |t|) :
    ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊) ≤ 8 * Real.exp (-(|t| / 4)) := by
  set N := ⌈|t|⌉₊ with hN
  have ht0 : t ≠ 0 := by
    intro h; rw [h] at ht; simp at ht; linarith
  have hceil : |t| ≤ (N : ℝ) := Nat.le_ceil _
  have hN2 : 2 ≤ N := Nat.cast_le.mp (le_trans ht hceil)
  have hpred : (((N - 1 : ℕ)) : ℝ) ≤ |t| := by
    have h1 : (N : ℝ) < |t| + 1 := by rw [hN]; exact Nat.ceil_lt_add_one (abs_nonneg t)
    have h2 : ((N - 1 : ℕ) : ℝ) = (N : ℝ) - 1 := by
      rw [Nat.cast_sub (by omega : 1 ≤ N)]; ring
    rw [h2]; linarith
  have hNle : (N : ℝ) ≤ 2 * |t| := by
    have h1 : (N : ℝ) < |t| + 1 := by rw [hN]; exact Nat.ceil_lt_add_one (abs_nonneg t)
    linarith
  have hstep := factorial_div_pow_pred_le hN2
  have hmine : (N.factorial : ℝ) / |t| ^ N
      ≤ (N.factorial : ℝ) / (((N - 1 : ℕ)) : ℝ) ^ N := by
    have hb : (0:ℝ) < ((N - 1 : ℕ) : ℝ) := Nat.cast_pos.mpr (by omega)
    refine div_le_div_of_nonneg_left (by positivity) (by positivity) ?_
    exact pow_le_pow_left₀ (Nat.cast_nonneg _) hpred N
  have hmain : (N.factorial : ℝ) / |t| ^ N ≤ (N : ℝ) * Real.exp (-(((N : ℝ) - 2) / 2)) :=
    hmine.trans hstep
  refine hmain.trans ?_
  have hexp : Real.exp (-(((N : ℝ) - 2) / 2)) ≤ Real.exp 1 * Real.exp (-(|t| / 2)) := by
    rw [← Real.exp_add]
    refine Real.exp_le_exp.mpr ?_
    have h2 : |t| ≤ (N : ℝ) := hceil
    linarith [neg_le_neg (by linarith : (|t| : ℝ) / 2 ≤ (N : ℝ) / 2)]
  calc (N : ℝ) * Real.exp (-(((N : ℝ) - 2) / 2))
      ≤ (N : ℝ) * (Real.exp 1 * Real.exp (-(|t| / 2))) :=
        mul_le_mul_of_nonneg_left hexp (by positivity)
    _ ≤ (2 * |t|) * (Real.exp 1 * Real.exp (-(|t| / 2))) :=
        mul_le_mul_of_nonneg_right hNle (by positivity)
    _ = 2 * Real.exp 1 * (|t| * Real.exp (-(|t| / 4))) * Real.exp (-(|t| / 4)) := by
        rw [show -(|t| / 2) = -(|t| / 4) + -(|t| / 4) by ring, Real.exp_add]
        ring
    _ ≤ 2 * Real.exp 1 * (4 / Real.exp 1) * Real.exp (-(|t| / 4)) :=
        mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left (abs_mul_exp_neg_div_le ht0) (by positivity)) (by positivity)
    _ = 8 * Real.exp (-(|t| / 4)) := by
        field_simp
        ring


/-- **`exp (1/2) ≤ 3`**, and hence `64 * exp (−1/2) ≥ 2` — the numeric facts that let the `|t| ≤ 2`
branch of `norm_Gamma_decay` be closed by `‖Γ‖ ≤ Γ(σ) ≤ 2`.  (`Real.exp_one_lt_three` lives in
`Mathlib/Analysis/Complex/ExponentialBounds.lean`, which had to be imported explicitly.) -/
theorem exp_half_le_three : Real.exp ((1:ℝ) / 2) ≤ 3 := by
  have h1 : Real.exp ((1:ℝ)/2) ≤ Real.exp 1 := Real.exp_le_exp.mpr (by norm_num)
  linarith [Real.exp_one_lt_three]

/-- `2 ≤ 64 * exp (−1/2)`, i.e. `2 * exp (1/2) ≤ 64`. -/
theorem two_le_sixtyFour_mul_exp_neg_half : (2:ℝ) ≤ 64 * Real.exp (-(1/2)) := by
  have hprod : Real.exp (-(1/2)) * Real.exp (1/2) = 1 := by
    rw [← Real.exp_add]; norm_num
  nlinarith [hprod, exp_half_le_three, Real.exp_pos (-(1/2))]


/-- **`norm_Gamma_decay` on `1/2 ≤ σ ≤ 1`** (step 2, half range).  For `|t| ≤ 2`: `‖Γ‖ ≤ Γ(σ) ≤ 2` and
`2 ≤ 64·exp(−1/2) ≤ 64·(1+|t|)^σ·exp(−|t|/4)`.  For `|t| ≥ 2`: §187 + §188 + §191 give
`≤ 2·8·exp(−|t|/4) = 16·exp(−|t|/4) ≤ 64·(1+|t|)^σ·exp(−|t|/4)`. -/
theorem norm_Gamma_le_decay_half {σ t : ℝ} (hσ0 : 1/2 ≤ σ) (hσ1 : σ ≤ 1) :
    ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 64 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
  have hσpos : 0 < σ := by linarith
  have hbase : (1:ℝ) ≤ 1 + |t| := by linarith [abs_nonneg t]
  have hone : (1:ℝ) ≤ (1 + |t|) ^ σ := Real.one_le_rpow hbase hσpos.le
  have hX : (0:ℝ) ≤ Real.exp (-(|t| / 4)) := (Real.exp_pos _).le
  have h64 : (16:ℝ) ≤ 64 * (1 + |t|) ^ σ := by
    have := mul_le_mul_of_nonneg_left hone (by norm_num : (0:ℝ) ≤ 64)
    linarith
  by_cases h2 : |t| ≤ 2
  · have hb : ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ 2 := by
      have h1 : ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
          ≤ Real.Gamma (((σ : ℂ) + (t : ℂ) * Complex.I).re) :=
        norm_Gamma_le_Gamma_re (by simp; linarith)
      have hre : (((σ : ℂ) + (t : ℂ) * Complex.I)).re = σ := by simp
      rw [hre] at h1
      exact h1.trans (Gamma_le_two_of_mem hσ0 hσ1)
    have hexp : Real.exp (-(1/2)) ≤ Real.exp (-(|t| / 4)) :=
      Real.exp_le_exp.mpr (by linarith [h2])
    have hle : Real.exp (-(1/2)) ≤ (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
      nlinarith [hone, hexp, hX, Real.exp_pos (-(1/2))]
    calc ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ 2 := hb
      _ ≤ 64 * Real.exp (-(1/2)) := two_le_sixtyFour_mul_exp_neg_half
      _ ≤ 64 * ((1 + |t|) ^ σ * Real.exp (-(|t| / 4))) :=
          mul_le_mul_of_nonneg_left hle (by norm_num)
      _ = 64 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by ring
  · have ht0 : t ≠ 0 := by
      intro h; rw [h] at h2; simp at h2
    have hchain : ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
        ≤ (1 / σ) * ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊) := by
      refine norm_Gamma_le_of_GammaSeq_eventually ?_
      filter_upwards [Filter.eventually_atTop.mpr ⟨⌈|t|⌉₊, fun n hn => hn⟩] with n hn
      exact norm_GammaSeq_le_eventually hσpos hσ1 ht0 hn
    have hinv : (1 / σ) ≤ 2 := by rw [div_le_iff₀ hσpos]; linarith
    have hdec := factorial_div_pow_ceil_le (le_of_lt (not_le.mp h2))
    have hprod : (1 / σ) * ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊)
        ≤ 2 * (8 * Real.exp (-(|t| / 4))) := by
      have hstep : (1 / σ) * (((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊))
          ≤ 2 * (8 * Real.exp (-(|t| / 4))) :=
        mul_le_mul hinv hdec (by positivity) (by norm_num)
      rwa [← mul_div_assoc] at hstep
    calc ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
        ≤ (1 / σ) * ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊) := hchain
      _ ≤ 2 * (8 * Real.exp (-(|t| / 4))) := hprod
      _ = 16 * Real.exp (-(|t| / 4)) := by ring
      _ ≤ 64 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
          have h16 : (16:ℝ) * Real.exp (-(|t| / 4))
              ≤ (64 * (1 + |t|) ^ σ) * Real.exp (-(|t| / 4)) :=
            mul_le_mul_of_nonneg_right h64 hX
          linarith [h16]


/-- **The recursion factor.**  For `0 ≤ x ≤ 1`, `‖x + t·I‖ = √(x²+t²) ≤ 1 + |t|` — the cost of one
`Γ(s+1) = sΓ(s)` step in the `3/2 ≤ σ ≤ 2` extension of `norm_Gamma_decay`. -/
theorem norm_ofReal_add_mul_I_le (x t : ℝ) (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    ‖(x : ℂ) + (t : ℂ) * Complex.I‖ ≤ 1 + |t| := by
  rw [Complex.norm_add_mul_I]
  have h1 : x ^ 2 ≤ 1 := by nlinarith
  have h2 : (1 + |t|) ^ 2 = 1 + 2 * |t| + |t| ^ 2 := by ring
  have h3 : t ^ 2 = |t| ^ 2 := by rw [sq_abs]
  have hsq := Real.sq_sqrt (by positivity : (0:ℝ) ≤ x ^ 2 + t ^ 2)
  nlinarith [Real.sqrt_nonneg (x ^ 2 + t ^ 2), abs_nonneg t, h1, h2, h3, hsq]


/-- **`Γ ≤ 4` on `[1/4,1]`** — `Γ(σ) = Γ(σ+1)/σ ≤ 1/σ ≤ 4`.  Covers `Re(s/2)` for the archimedean
factor on the strip `1/2 ≤ σ ≤ 1`. -/
theorem Gamma_le_four_of_quarter {σ : ℝ} (h1 : 1/4 ≤ σ) (h2 : σ ≤ 1) : Real.Gamma σ ≤ 4 := by
  have hpos : (0:ℝ) < σ := by linarith
  have hrec : Real.Gamma σ = Real.Gamma (σ + 1) / σ := by
    rw [Real.Gamma_add_one (ne_of_gt hpos), mul_div_cancel_left₀ _ (ne_of_gt hpos)]
  rw [hrec]
  have hb : Real.Gamma (σ + 1) ≤ 1 := Gamma_le_one_of_mem (by linarith) (by linarith)
  calc Real.Gamma (σ + 1) / σ ≤ 1 / σ := div_le_div_of_nonneg_right hb hpos.le
    _ ≤ 4 := by rw [div_le_iff₀ hpos]; linarith

/-- **`norm_Gamma_decay` on `1/4 ≤ σ ≤ 1`.**  Same two branches as §193, with `1/σ ≤ 4` and
`Γ(σ) ≤ 4`, so the constant becomes `128 = 4·32`. -/
theorem norm_Gamma_le_decay_quarter {σ t : ℝ} (hσ0 : 1/4 ≤ σ) (hσ1 : σ ≤ 1) :
    ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
  have hσpos : 0 < σ := by linarith
  have hbase : (1:ℝ) ≤ 1 + |t| := by linarith [abs_nonneg t]
  have hone : (1:ℝ) ≤ (1 + |t|) ^ σ := Real.one_le_rpow hbase hσpos.le
  have hX : (0:ℝ) ≤ Real.exp (-(|t| / 4)) := (Real.exp_pos _).le
  have h128 : (32:ℝ) ≤ 128 * (1 + |t|) ^ σ := by
    have := mul_le_mul_of_nonneg_left hone (by norm_num : (0:ℝ) ≤ 128)
    linarith
  by_cases h2 : |t| ≤ 2
  · have hb : ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ 4 := by
      have h1 : ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
          ≤ Real.Gamma (((σ : ℂ) + (t : ℂ) * Complex.I).re) :=
        norm_Gamma_le_Gamma_re (by simp; linarith)
      have hre : (((σ : ℂ) + (t : ℂ) * Complex.I)).re = σ := by simp
      rw [hre] at h1
      exact h1.trans (Gamma_le_four_of_quarter hσ0 hσ1)
    have hexp : Real.exp (-(1/2)) ≤ Real.exp (-(|t| / 4)) :=
      Real.exp_le_exp.mpr (by linarith [h2])
    have hle : Real.exp (-(1/2)) ≤ (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
      nlinarith [hone, hexp, hX, Real.exp_pos (-(1/2))]
    have hnum : (4:ℝ) ≤ 128 * Real.exp (-(1/2)) := by
      have hprod : Real.exp (-(1/2)) * Real.exp (1/2) = 1 := by
        rw [← Real.exp_add]; norm_num
      have hE : Real.exp ((1:ℝ)/2) ≤ 3 := by
        have h1 : Real.exp ((1:ℝ)/2) ≤ Real.exp 1 := Real.exp_le_exp.mpr (by norm_num)
        linarith [Real.exp_one_lt_three]
      nlinarith [hprod, hE, Real.exp_pos (-(1/2))]
    calc ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ 4 := hb
      _ ≤ 128 * Real.exp (-(1/2)) := hnum
      _ ≤ 128 * ((1 + |t|) ^ σ * Real.exp (-(|t| / 4))) :=
          mul_le_mul_of_nonneg_left hle (by norm_num)
      _ = 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by ring
  · have ht0 : t ≠ 0 := by
      intro h; rw [h] at h2; simp at h2
    have hchain : ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
        ≤ (1 / σ) * ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊) := by
      refine norm_Gamma_le_of_GammaSeq_eventually ?_
      filter_upwards [Filter.eventually_atTop.mpr ⟨⌈|t|⌉₊, fun n hn => hn⟩] with n hn
      exact norm_GammaSeq_le_eventually hσpos hσ1 ht0 hn
    have hinv : (1 / σ) ≤ 4 := by rw [div_le_iff₀ hσpos]; linarith
    have hdec := factorial_div_pow_ceil_le (le_of_lt (not_le.mp h2))
    have hprod : (1 / σ) * (((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊))
        ≤ 4 * (8 * Real.exp (-(|t| / 4))) :=
      mul_le_mul hinv hdec (by positivity) (by norm_num)
    calc ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
        ≤ (1 / σ) * ((⌈|t|⌉₊).factorial : ℝ) / |t| ^ (⌈|t|⌉₊) := hchain
      _ ≤ 4 * (8 * Real.exp (-(|t| / 4))) := by rwa [← mul_div_assoc] at hprod
      _ = 32 * Real.exp (-(|t| / 4)) := by ring
      _ ≤ 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
          have h32 : (32:ℝ) * Real.exp (-(|t| / 4))
              ≤ (128 * (1 + |t|) ^ σ) * Real.exp (-(|t| / 4)) :=
            mul_le_mul_of_nonneg_right h128 hX
          linarith [h32]


/-- **`norm_Gamma_decay` on `3/2 ≤ σ ≤ 2`.**  `Γ(s) = (s-1)Γ(s-1)` with `Re(s-1) ∈ [1/2,1] ⊂ [1/4,1]`,
so §195 applies to `Γ(s-1)` and the factor costs exactly one power of `(1+|t|)`. -/
theorem norm_Gamma_le_decay_upper {σ t : ℝ} (hσ0 : 3/2 ≤ σ) (hσ1 : σ ≤ 2) :
    ‖Complex.Gamma ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
  have hbase : (1:ℝ) ≤ 1 + |t| := by linarith [abs_nonneg t]
  have hne : (((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.ofReal_im,
      Complex.I_im, mul_zero, mul_one, sub_zero, add_zero, Complex.zero_re] at this
    linarith
  have hrec : Complex.Gamma ((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I + 1)
      = ((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I)
        * Complex.Gamma ((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I) :=
    Complex.Gamma_add_one _ hne
  have harg : (((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I + 1 = (σ : ℂ) + (t : ℂ) * Complex.I := by
    push_cast; ring
  rw [harg] at hrec
  rw [hrec]
  have hsmall : ‖Complex.Gamma ((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 128 * (1 + |t|) ^ (σ - 1) * Real.exp (-(|t| / 4)) :=
    norm_Gamma_le_decay_quarter (σ := σ - 1) (t := t) (by linarith) (by linarith)
  have hfac : ‖(((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I‖ ≤ 1 + |t| :=
    norm_ofReal_add_mul_I_le (σ - 1) t (by linarith) (by linarith)
  calc ‖((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I)
        * Complex.Gamma ((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I)‖
      = ‖(((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I‖
        * ‖Complex.Gamma ((((σ - 1 : ℝ)) : ℂ) + (t : ℂ) * Complex.I)‖ := norm_mul _ _
    _ ≤ (1 + |t|) * (128 * (1 + |t|) ^ (σ - 1) * Real.exp (-(|t| / 4))) :=
        mul_le_mul hfac hsmall (norm_nonneg _) (by positivity)
    _ = 128 * ((1 + |t|) * (1 + |t|) ^ (σ - 1)) * Real.exp (-(|t| / 4)) := by ring
    _ = 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4)) := by
        have hpow : (1 + |t|) * (1 + |t|) ^ (σ - 1) = (1 + |t|) ^ σ := by
          rw [mul_comm, ← Real.rpow_add_one (ne_of_gt (by linarith : (0:ℝ) < 1 + |t|))]
          ring_nf
        rw [hpow]


/-- **Two recursion steps.**  `Γ(w) = Γ(w+2)/(w·(w+1))` for `w ≠ 0`, `w ≠ −1`.  This is what carries
`norm_Gamma_decay` down to `0 ≤ Re w ≤ 1/4` — the range `Γ((1−s)/2)` meets in the functional equation:
`w+2` has `Re ∈ [2,9/4] ⊂ [3/2,2]`, where §196 applies, and the two factors only help. -/
theorem Gamma_eq_Gamma_add_two_div (w : ℂ) (h0 : w ≠ 0) (h1 : w + 1 ≠ 0) :
    Complex.Gamma w = Complex.Gamma (w + 2) / (w * (w + 1)) := by
  have hstep1 : Complex.Gamma (w + 1) = w * Complex.Gamma w := Complex.Gamma_add_one w h0
  have hstep2 : Complex.Gamma (w + 1 + 1) = (w + 1) * Complex.Gamma (w + 1) :=
    Complex.Gamma_add_one (w + 1) h1
  rw [show w + 2 = w + 1 + 1 by ring, hstep2, hstep1]
  field_simp


/-- **The archimedean factor is bounded with exponential decay on the strip.**  `Gammaℝ s = π^{−s/2}Γ(s/2)`,
so this is §195 at `(σ/2, t/2)` — and `Re(σ/2) ∈ [1/4,1/2]` for `σ ∈ [1/2,1]`, exactly §195's range.
This is the form the strip `1/2 ≤ σ ≤ 1` consumes: for even `χ`, `gammaFactor χ s = Gammaℝ s`; for odd,
`gammaFactor χ s = Gammaℝ (s+1)`, whose argument has `Re ∈ [3/4,1]` — also in range. -/
theorem norm_Gammaℝ_le {σ t : ℝ} (hσ0 : 1/2 ≤ σ) (hσ1 : σ ≤ 2) :
    ‖Complex.Gammaℝ ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 128 * (1 + |t| / 2) ^ (σ / 2) * Real.exp (-(|t| / 8)) := by
  have hπ : (0:ℝ) < Real.pi := Real.pi_pos
  rw [Complex.Gammaℝ_def, norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos hπ _]
  have hre : ((-(((σ : ℂ) + (t : ℂ) * Complex.I))) / 2).re = -(σ / 2) := by
    rw [show (-(((σ : ℂ) + (t : ℂ) * Complex.I))) / 2
        = -((((σ : ℂ) + (t : ℂ) * Complex.I)) / 2) by ring]
    rw [Complex.neg_re, Complex.div_re]
    simp
    ring
  rw [hre]
  have hpow : Real.pi ^ (-(σ / 2)) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos (by linarith [Real.pi_gt_three]) (by linarith)
  have hhalf : (((σ : ℂ) + (t : ℂ) * Complex.I) / 2)
      = (((σ / 2 : ℝ)) : ℂ) + (((t / 2 : ℝ)) : ℂ) * Complex.I := by
    push_cast; ring
  have hΓ : ‖Complex.Gamma (((σ : ℂ) + (t : ℂ) * Complex.I) / 2)‖
      ≤ 128 * (1 + |t| / 2) ^ (σ / 2) * Real.exp (-(|t| / 8)) := by
    rw [hhalf]
    have := norm_Gamma_le_decay_quarter (σ := σ / 2) (t := t / 2) (by linarith) (by linarith)
    rw [abs_div, show |(2:ℝ)| = 2 by norm_num] at this
    convert this using 2 <;> ring
  have hpos : (0:ℝ) ≤ Real.pi ^ (-(σ / 2)) := Real.rpow_nonneg hπ.le _
  have hnn : (0:ℝ) ≤ 128 * (1 + |t| / 2) ^ (σ / 2) * Real.exp (-(|t| / 8)) := by positivity
  calc Real.pi ^ (-(σ / 2)) * ‖Complex.Gamma (((σ : ℂ) + (t : ℂ) * Complex.I) / 2)‖
      ≤ 1 * (128 * (1 + |t| / 2) ^ (σ / 2) * Real.exp (-(|t| / 8))) :=
        mul_le_mul hpow hΓ (norm_nonneg _) (by norm_num)
    _ = 128 * (1 + |t| / 2) ^ (σ / 2) * Real.exp (-(|t| / 8)) := one_mul _


/-- `∑_{k<N} χ (k : ZMod N) = ∑ a : ZMod N, χ a` — `k ↦ (k : ZMod N)` is a bijection `range N → univ`. -/
theorem sum_range_natCast_chi_eq_univ {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) :
    ∑ k ∈ Finset.range N, χ (k : ZMod N) = ∑ a : ZMod N, χ a := by
  refine Finset.sum_bij (fun k _ => (k : ZMod N)) (fun k hk => Finset.mem_univ _)
    (fun k hk k' hk' h => ?_) (fun a _ => ⟨a.val, Finset.mem_range.mpr a.val_lt, ?_⟩)
    (fun k hk => rfl)
  · rw [← ZMod.val_natCast_of_lt (Finset.mem_range.mp hk),
      ← ZMod.val_natCast_of_lt (Finset.mem_range.mp hk')]
    exact congrArg ZMod.val h
  · exact ZMod.natCast_zmod_val a

/-- **Bounded partial sums.**  `∑_{k<N} χ (k : ZMod N) = 0` for non-principal `χ`. -/
theorem sum_range_natCast_chi_eq_zero {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    ∑ k ∈ Finset.range N, χ (k : ZMod N) = 0 := by
  rw [sum_range_natCast_chi_eq_univ χ, MulChar.sum_eq_zero_of_ne_one hχ]


/-- **Complete blocks vanish.**  `∑_{x<q·N} χ (x : ZMod N) = 0` for non-principal `χ`, by induction on
`q`: each block of `N` consecutive terms is a full period, and a full period sums to `0`. -/
theorem sum_range_mul_chi_eq_zero {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    (q : ℕ) : ∑ x ∈ Finset.range (q * N), χ (x : ZMod N) = 0 := by
  induction q with
  | zero => simp
  | succ k ih =>
    have hshift : ∀ x : ℕ, ((k * N + x : ℕ) : ZMod N) = ((x : ℕ) : ZMod N) := by
      intro x
      push_cast
      rw [show ((N : ZMod N)) = 0 by simp, mul_zero, zero_add]
    rw [show (k + 1) * N = k * N + N by ring, Finset.sum_range_add, ih, zero_add]
    simp only [hshift]
    exact sum_range_natCast_chi_eq_zero χ hχ


/-- **Bounded partial sums of a non-principal Dirichlet character.**  `‖∑_{k<n} χ (k : ZMod N)‖ ≤ N`.
Split `n = N·(n/N) + n % N`; the complete blocks vanish (`sum_range_mul_chi_eq_zero`), the tail shifts
back to `∑_{k<n % N} χ k`, and there are `n % N < N` terms of modulus `≤ 1`. -/
theorem norm_sum_range_chi_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (n : ℕ) :
    ‖∑ k ∈ Finset.range n, χ (k : ZMod N)‖ ≤ (N : ℝ) := by
  have hN : 0 < N := Nat.pos_of_ne_zero (NeZero.ne N)
  have hshift : ∀ x : ℕ, ((N * (n / N) + x : ℕ) : ZMod N) = ((x : ℕ) : ZMod N) := by
    intro x
    push_cast
    rw [show ((N : ZMod N)) = 0 by simp, zero_mul, zero_add]
  have htail : ∑ k ∈ Finset.range (n % N), χ ((N * (n / N) + k : ℕ) : ZMod N)
      = ∑ k ∈ Finset.range (n % N), χ (k : ZMod N) :=
    Finset.sum_congr rfl fun k hk => by rw [hshift]
  have hblock : ∑ x ∈ Finset.range (N * (n / N)), χ (x : ZMod N) = 0 := by
    rw [show N * (n / N) = (n / N) * N from Nat.mul_comm N (n / N)]
    exact sum_range_mul_chi_eq_zero χ hχ (n / N)
  rw [show n = N * (n / N) + n % N from (Nat.div_add_mod n N).symm, Finset.sum_range_add, hblock,
    zero_add, htail]
  calc ‖∑ k ∈ Finset.range (n % N), χ (k : ZMod N)‖
      ≤ ∑ k ∈ Finset.range (n % N), ‖χ (k : ZMod N)‖ := norm_sum_le _ _
    _ ≤ ∑ _k ∈ Finset.range (n % N), (1 : ℝ) := Finset.sum_le_sum fun k hk => χ.norm_le_one _
    _ = ((n % N : ℕ) : ℝ) := by simp
    _ ≤ (N : ℝ) := by exact_mod_cast (Nat.mod_lt n hN).le


/-- **The Abel weight's modulus.**  `‖(k+1) ^ (−σ)‖ = (k+1) ^ (−σ)` — the weight is a positive real. -/
theorem norm_natCast_cpow_neg (σ : ℝ) (k : ℕ) :
    ‖((k + 1 : ℕ) : ℂ) ^ (-(σ : ℂ))‖ = ((k + 1 : ℕ) : ℝ) ^ (-σ) := by
  have h1 : (((k + 1 : ℕ)) : ℂ) = ((((k + 1 : ℕ)) : ℝ) : ℂ) := by push_cast; ring
  rw [h1, Complex.norm_cpow_eq_rpow_re_of_pos (by positivity : (0:ℝ) < ((k + 1 : ℕ) : ℝ))]
  simp

/-- **The Abel weight is decreasing** for `σ ≥ 0` — the hypothesis that makes the variation sum in
`Finset.sum_Ico_by_parts` telescope (§211). -/
theorem norm_natCast_cpow_neg_anti {σ : ℝ} (hσ : 0 ≤ σ) {a b : ℕ} (hab : a ≤ b) :
    ‖((b + 1 : ℕ) : ℂ) ^ (-(σ : ℂ))‖ ≤ ‖((a + 1 : ℕ) : ℂ) ^ (-(σ : ℂ))‖ := by
  rw [norm_natCast_cpow_neg, norm_natCast_cpow_neg]
  refine Real.rpow_le_rpow_of_nonpos (by positivity) ?_ (by linarith)
  exact_mod_cast Nat.succ_le_succ hab


/-- **Telescoping over `Ico`.**  `∑_{i ∈ Ico m n} (g i − g (i+1)) = g m − g n`. -/
theorem sum_Ico_sub_telescope (g : ℕ → ℝ) {m n : ℕ} (hmn : m ≤ n) :
    ∑ i ∈ Finset.Ico m n, (g i - g (i + 1)) = g m - g n := by
  induction n, hmn using Nat.le_induction with
  | base => simp
  | succ k hk ih => rw [Finset.sum_Ico_succ_top hk, ih]; ring


/-- **The Abel variation telescopes** (sub-lemma (iii) of §211).  For `σ ≥ 0` the weight
`k ↦ (k+1)^{−σ}` is non-negative, so the variation sum in `Finset.sum_Ico_by_parts` is at most one value
of the weight.  Carrying `m ≤ n` avoids the empty-`Ico` case entirely. -/
theorem sum_Ico_rpow_sub_le {σ : ℝ} (hσ : 0 ≤ σ) {m n : ℕ} (hmn : m ≤ n) :
    ∑ i ∈ Finset.Ico m n, (((i + 1 : ℕ) : ℝ) ^ (-σ) - ((i + 2 : ℕ) : ℝ) ^ (-σ))
      ≤ ((m + 1 : ℕ) : ℝ) ^ (-σ) := by
  have htel := sum_Ico_sub_telescope (fun k : ℕ => ((k + 1 : ℕ) : ℝ) ^ (-σ)) hmn
  have hsub : (∑ i ∈ Finset.Ico m n, (((i + 1 : ℕ) : ℝ) ^ (-σ) - ((i + 2 : ℕ) : ℝ) ^ (-σ)))
      = ((m + 1 : ℕ) : ℝ) ^ (-σ) - ((n + 1 : ℕ) : ℝ) ^ (-σ) := by
    rw [← htel]
  rw [hsub]
  have h1 : (0:ℝ) ≤ ((n + 1 : ℕ) : ℝ) ^ (-σ) := (Real.rpow_pos_of_pos (by positivity) _).le
  linarith


/-- **Mean-value bound on one step of the complex Abel weight.** -/
theorem norm_cpow_neg_sub_le {s : ℂ} (hs : 0 < s.re) {a b : ℝ} (ha : 1 ≤ a) (hab : a ≤ b) :
    ‖(b : ℂ) ^ (-s) - (a : ℂ) ^ (-s)‖ ≤ ‖s‖ * a ^ (-s.re - 1) * (b - a) := by
  have hsne : (-s) ≠ 0 := by
    intro h
    have hre := congrArg Complex.re h
    simp at hre
    linarith
  have hdiff : ∀ x ∈ Set.Icc a b, DifferentiableAt ℝ (fun x : ℝ => (x : ℂ) ^ (-s)) x := by
    intro x hx
    exact (hasDerivAt_ofReal_cpow_const (by linarith [hx.1] : x ≠ 0) hsne).differentiableAt
  have hbound : ∀ x ∈ Set.Icc a b,
      ‖deriv (fun x : ℝ => (x : ℂ) ^ (-s)) x‖ ≤ ‖s‖ * a ^ (-s.re - 1) := by
    intro x hx
    have hx0 : (0:ℝ) < x := by linarith [hx.1]
    have hxne : x ≠ 0 := ne_of_gt hx0
    rw [deriv_ofReal_cpow_const hxne hsne, norm_mul, norm_neg,
      Complex.norm_cpow_eq_rpow_re_of_pos hx0]
    have hre : (-s - 1).re = -s.re - 1 := by simp
    rw [hre]
    have hle := Real.rpow_le_rpow_of_nonpos (by linarith : (0:ℝ) < a) hx.1 (by linarith : -s.re - 1 ≤ 0)
    exact mul_le_mul_of_nonneg_left hle (norm_nonneg s)
  have hmvt := Convex.norm_image_sub_le_of_norm_deriv_le (𝕜 := ℝ) (s := Set.Icc a b)
    (f := fun x : ℝ => (x : ℂ) ^ (-s)) hdiff hbound (convex_Icc a b)
    ⟨le_refl a, hab⟩ ⟨hab, le_refl b⟩
  rwa [Real.norm_eq_abs, abs_of_nonneg (by linarith : (0:ℝ) ≤ b - a)] at hmvt

/-- **Sharp tail sum for the complex Abel variation.** -/
theorem sum_Ico_rpow_neg_succ_le {σ : ℝ} (hσ : 1 ≤ σ) {m n : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n) :
    ∑ i ∈ Finset.Ico m n, ((i + 1 : ℕ) : ℝ) ^ (-σ - 1) ≤ ((m : ℕ) : ℝ) ^ (-σ) := by
  have hterm : ∀ i ∈ Finset.Ico m n, ((i + 1 : ℕ) : ℝ) ^ (-σ - 1)
      ≤ ((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ) := by
    intro i hi
    have hi1 : 1 ≤ i := le_trans hm (Finset.mem_Ico.mp hi).1
    have hA : (0:ℝ) < ((i : ℕ) : ℝ) := by exact_mod_cast hi1
    have hAB : ((i : ℕ) : ℝ) ≤ ((i + 1 : ℕ) : ℝ) := by push_cast; linarith
    have hB : (0:ℝ) < ((i + 1 : ℕ) : ℝ) := by positivity
    set w : ℝ := ((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ) with hw
    have hwpos : 0 < w := div_pos hA hB
    have hwle : w ≤ 1 := (div_le_one hB).mpr hAB
    have hw1 : w ^ (-σ) ≥ w ^ (-1 : ℝ) :=
      Real.rpow_le_rpow_of_exponent_ge hwpos hwle (by linarith : (-σ:ℝ) ≤ (-1:ℝ))
    have hw2 : w ^ (-1 : ℝ) ≥ 2 - w := by
      rw [Real.rpow_neg_one, ge_iff_le, sub_le_iff_le_add]
      have hthis : w⁻¹ + w = 2 + (1 - w) ^ 2 / w := by
        field_simp
        ring
      rw [hthis]
      have hnn : (0:ℝ) ≤ (1 - w) ^ 2 / w := div_nonneg (sq_nonneg _) (le_of_lt hwpos)
      linarith
    have hkey : w ^ (-σ) ≥ 2 - w := le_trans hw2 hw1
    have hfac : ((i + 1 : ℕ) : ℝ) ^ (-σ) * w ^ (-σ) = ((i : ℕ) : ℝ) ^ (-σ) := by
      rw [← Real.mul_rpow (le_of_lt hB) (le_of_lt hwpos)]
      congr 1
      rw [hw]
      field_simp
    have hone : ((i + 1 : ℕ) : ℝ) ^ (-1 : ℝ) = 1 - w := by
      rw [Real.rpow_neg_one, hw]
      field_simp
      push_cast
      ring
    have hgoal : ((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)
        ≥ ((i + 1 : ℕ) : ℝ) ^ (-σ - 1) := by
      have hstep : ((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)
          = ((i + 1 : ℕ) : ℝ) ^ (-σ) * (w ^ (-σ) - 1) := by
        rw [mul_sub, mul_one, hfac]
      have hB1 : ((i + 1 : ℕ) : ℝ) ^ (-σ - 1)
          = ((i + 1 : ℕ) : ℝ) ^ (-σ) * (1 - w) := by
        rw [show (-σ - 1 : ℝ) = -σ + (-1) by ring, Real.rpow_add (by positivity), hone]
      rw [hstep, hB1]
      exact mul_le_mul_of_nonneg_left (by linarith [hkey]) (le_of_lt (Real.rpow_pos_of_pos hB _))
    linarith [hgoal]
  have htel := sum_Ico_sub_telescope (fun k : ℕ => ((k : ℕ) : ℝ) ^ (-σ)) hmn
  calc ∑ i ∈ Finset.Ico m n, ((i + 1 : ℕ) : ℝ) ^ (-σ - 1)
      ≤ ∑ i ∈ Finset.Ico m n, (((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)) :=
        Finset.sum_le_sum hterm
    _ = ((m : ℕ) : ℝ) ^ (-σ) - ((n : ℕ) : ℝ) ^ (-σ) := htel
    _ ≤ ((m : ℕ) : ℝ) ^ (-σ) := by
        have : (0:ℝ) ≤ ((n : ℕ) : ℝ) ^ (-σ) := Real.rpow_nonneg (Nat.cast_nonneg n) _
        linarith



/-- `χ 0 = 0` for a non-principal Dirichlet character. -/
theorem chi_zero_eq_zero {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    χ (0 : ZMod N) = 0 := by
  have hN : N ≠ 1 := by
    intro h1
    apply hχ
    subst h1
    exact Subsingleton.elim χ 1
  haveI : Nontrivial (ZMod N) := ZMod.nontrivial_iff.mpr hN
  exact MulChar.map_zero χ

/-- Partial sums of `j ↦ χ (j+1)` are bounded by `N`. -/
theorem norm_sum_range_chi_succ_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    (k : ℕ) : ‖∑ j ∈ Finset.range k, χ ((j + 1 : ℕ) : ZMod N)‖ ≤ (N : ℝ) := by
  have h0 := chi_zero_eq_zero χ hχ
  have hshift : (∑ j ∈ Finset.range k, χ ((j + 1 : ℕ) : ZMod N))
      = (∑ j ∈ Finset.range (k + 1), χ (j : ZMod N)) - χ (0 : ZMod N) := by
    rw [Finset.sum_range_succ']
    ring
  rw [hshift, h0, sub_zero]
  exact norm_sum_range_chi_le χ hχ (k + 1)

/-- **The complex Abel identity.** -/
theorem sum_Ico_mul_cpow_eq (g : ℕ → ℂ) (s : ℂ) {m n : ℕ} (hmn : m < n) :
    (∑ i ∈ Finset.Ico m n, g i * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      = ((n : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range n, g i)
        - ((m + 1 : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range m, g i)
        - ∑ i ∈ Finset.Ico m (n - 1),
            ((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
              * (∑ j ∈ Finset.range (i + 1), g j) := by
  have hspec := Finset.sum_Ico_by_parts (R := ℂ) (M := ℂ)
    (fun i : ℕ => ((i + 1 : ℕ) : ℂ) ^ (-s)) (fun i : ℕ => g i) hmn
  have hn1 : n - 1 + 1 = n :=
    Nat.succ_pred_eq_of_pos (Nat.lt_of_le_of_lt (Nat.zero_le m) hmn)
  have h1 : (∑ i ∈ Finset.Ico m n, g i * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      = ∑ i ∈ Finset.Ico m n, (((i + 1 : ℕ) : ℂ) ^ (-s)) • g i := by
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [smul_eq_mul, mul_comm]
  rw [h1, hspec, hn1]
  simp only [smul_eq_mul]

/-- **The complex Abel capstone.** -/
theorem norm_sum_Ico_mul_cpow_le {g : ℕ → ℂ} {B : ℝ} (hB : 0 ≤ B)
    (hg : ∀ k : ℕ, ‖∑ j ∈ Finset.range k, g j‖ ≤ B)
    {s : ℂ} (hs : 1 ≤ s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, g i * (((i + 1 : ℕ) : ℂ) ^ (-s))‖
      ≤ (2 + ‖s‖) * B * ((m : ℕ) : ℝ) ^ (-s.re) := by
  have hmR : (0:ℝ) < ((m : ℕ) : ℝ) := by exact_mod_cast hm
  have hpow : (0:ℝ) ≤ ((m : ℕ) : ℝ) ^ (-s.re) := (Real.rpow_pos_of_pos hmR _).le
  have hn1 : 1 ≤ n := by omega
  have hnR : (0:ℝ) < ((n : ℕ) : ℝ) := by exact_mod_cast hn1
  have hm1R : (0:ℝ) < ((m + 1 : ℕ) : ℝ) := by positivity
  have hcn : ((n : ℕ) : ℂ) = (((n : ℕ) : ℝ) : ℂ) := by push_cast; ring
  have hcm1 : ((m + 1 : ℕ) : ℂ) = (((m + 1 : ℕ) : ℝ) : ℂ) := by push_cast; ring
  -- arm A: the `G n` endpoint
  have hA : ‖((n : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range n, g i)‖
      ≤ ((m : ℕ) : ℝ) ^ (-s.re) * B := by
    rw [norm_mul, hcn, Complex.norm_cpow_eq_rpow_re_of_pos hnR, Complex.neg_re]
    refine mul_le_mul ?_ (hg n) (norm_nonneg _) hpow
    exact Real.rpow_le_rpow_of_nonpos hmR (by exact_mod_cast (by omega : m ≤ n)) (by linarith)
  -- arm B: the `G m` endpoint
  have hB' : ‖((m + 1 : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range m, g i)‖
      ≤ ((m : ℕ) : ℝ) ^ (-s.re) * B := by
    rw [norm_mul, hcm1, Complex.norm_cpow_eq_rpow_re_of_pos hm1R, Complex.neg_re]
    refine mul_le_mul ?_ (hg m) (norm_nonneg _) hpow
    exact Real.rpow_le_rpow_of_nonpos hmR (by push_cast; linarith) (by linarith)
  -- arm C: the telescoping variation
  have hC : ‖∑ i ∈ Finset.Ico m (n - 1),
        ((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
          * (∑ j ∈ Finset.range (i + 1), g j)‖
      ≤ ‖s‖ * B * ((m : ℕ) : ℝ) ^ (-s.re) := by
    refine (norm_sum_le _ _).trans ?_
    have hterm : ∀ i ∈ Finset.Ico m (n - 1),
        ‖((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
          * (∑ j ∈ Finset.range (i + 1), g j)‖
        ≤ ‖s‖ * ((i + 1 : ℕ) : ℝ) ^ (-s.re - 1) * B := by
      intro i hi
      have hi1 : 1 ≤ i + 1 := Nat.succ_le_succ (Nat.zero_le i)
      have hle : ((i + 1 : ℕ) : ℝ) ≤ ((i + 1 + 1 : ℕ) : ℝ) := by push_cast; linarith
      have hdiff := norm_cpow_neg_sub_le (s := s) (by linarith)
        (a := ((i + 1 : ℕ) : ℝ)) (b := ((i + 1 + 1 : ℕ) : ℝ)) (by exact_mod_cast hi1) hle
      have hsub : ((i + 1 + 1 : ℕ) : ℝ) - ((i + 1 : ℕ) : ℝ) = 1 := by push_cast; ring
      rw [norm_mul]
      refine le_trans (mul_le_mul_of_nonneg_right hdiff (norm_nonneg _)) ?_
      rw [hsub, mul_one]
      exact mul_le_mul_of_nonneg_left (hg (i + 1)) (by positivity)
    calc ∑ i ∈ Finset.Ico m (n - 1),
          ‖((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
            * (∑ j ∈ Finset.range (i + 1), g j)‖
        ≤ ∑ i ∈ Finset.Ico m (n - 1), ‖s‖ * ((i + 1 : ℕ) : ℝ) ^ (-s.re - 1) * B :=
          Finset.sum_le_sum hterm
      _ = ‖s‖ * (∑ i ∈ Finset.Ico m (n - 1), ((i + 1 : ℕ) : ℝ) ^ (-s.re - 1)) * B := by
          rw [Finset.mul_sum, Finset.sum_mul]
      _ ≤ ‖s‖ * ((m : ℕ) : ℝ) ^ (-s.re) * B := by
          refine mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left ?_ (norm_nonneg s)) hB
          exact sum_Ico_rpow_neg_succ_le (by linarith [hs]) hm (by omega)
      _ = ‖s‖ * B * ((m : ℕ) : ℝ) ^ (-s.re) := by ring
  set X : ℂ := ((n : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range n, g i) with hX
  set Y : ℂ := ((m + 1 : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range m, g i) with hY
  set Z : ℂ := ∑ i ∈ Finset.Ico m (n - 1),
      ((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
        * (∑ j ∈ Finset.range (i + 1), g j) with hZ
  have htri : ‖X - Y - Z‖ ≤ ‖X‖ + ‖Y‖ + ‖Z‖ := by
    refine (norm_sub_le (X - Y) Z).trans ?_
    have h2 := norm_sub_le X Y
    linarith
  rw [sum_Ico_mul_cpow_eq g s hmn, hX, hY, hZ] at *
  refine htri.trans ?_
  have hid : ((m : ℕ) : ℝ) ^ (-s.re) * B
      + ((m : ℕ) : ℝ) ^ (-s.re) * B + ‖s‖ * B * ((m : ℕ) : ℝ) ^ (-s.re)
      = (2 + ‖s‖) * B * ((m : ℕ) : ℝ) ^ (-s.re) := by ring
  linarith [hA, hB', hC, hid]

/-- Abel capstone for a non-principal Dirichlet character, complex exponent. -/
theorem norm_sum_Ico_chi_cpow_le_cmplx {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {s : ℂ} (hs : 1 ≤ s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))‖
      ≤ (2 + ‖s‖) * (N : ℝ) * ((m : ℕ) : ℝ) ^ (-s.re) :=
  norm_sum_Ico_mul_cpow_le (Nat.cast_nonneg N) (fun k => norm_sum_range_chi_le χ hχ k) hs hm hmn

/-- Abel capstone with the character index shifted by one. -/
theorem norm_sum_Ico_chi_succ_cpow_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {s : ℂ} (hs : 1 ≤ s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))‖
      ≤ (2 + ‖s‖) * (N : ℝ) * ((m : ℕ) : ℝ) ^ (-s.re) :=
  norm_sum_Ico_mul_cpow_le (Nat.cast_nonneg N) (fun k => norm_sum_range_chi_succ_le χ hχ k) hs hm hmn



/-- Head-sum bound for the Dirichlet series at `Re ≥ 1`. -/
theorem sum_range_rpow_neg_le_log {σ : ℝ} (hσ : 1 ≤ σ) (M : ℕ) :
    ∑ k ∈ Finset.range M, (k : ℝ) ^ (-σ) ≤ 1 + Real.log M := by
  have h1 : ∑ k ∈ Finset.range M, (k : ℝ) ^ (-σ)
      ≤ ∑ k ∈ Finset.range M, (k : ℝ) ^ (-1 : ℝ) := by
    refine Finset.sum_le_sum fun k hk => ?_
    by_cases hk0 : k = 0
    · subst hk0
      simp only [Nat.cast_zero, Real.zero_rpow (by linarith : (-σ:ℝ) ≠ 0),
        Real.zero_rpow (by norm_num : (-1:ℝ) ≠ 0)]
      exact le_refl 0
    · have hk1 : (1:ℝ) ≤ (k : ℝ) := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr hk0
      exact Real.rpow_le_rpow_of_exponent_le hk1 (by linarith)
  refine h1.trans ?_
  rcases Nat.eq_zero_or_pos M with hM | hM
  · subst hM; simp
  obtain ⟨M', rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hM)
  rw [Finset.sum_range_succ']
  simp only [Nat.cast_zero, Real.rpow_neg_one, inv_zero, add_zero]
  have hb := sum_range_inv_le_log (b := 1) le_rfl M'
  have hterm : ∑ k ∈ Finset.range M', (((k + 1 : ℕ)) : ℝ)⁻¹
      = ∑ k ∈ Finset.range M', 1 / (1 + (k : ℝ)) := by
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [one_div]; push_cast; ring
  rw [hterm]
  have hlog : Real.log (M' : ℝ) ≤ Real.log ((M' + 1 : ℕ) : ℝ) := by
    rcases Nat.eq_zero_or_pos M' with h | h
    · subst h; simp
    · refine Real.log_le_log (by positivity) ?_
      push_cast; linarith
  linarith



/-- Tail bound for the Dirichlet series of a non-principal character. -/
theorem norm_sum_Ico_chi_cpow_tail_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {σ t : ℝ} (hσ1 : 1 ≤ σ) (hσ2 : σ ≤ 2) {M n : ℕ} (hM : 2 ≤ M) (hMn : M < n)
    (hMt : |t| ≤ (M : ℝ)) :
    ‖∑ k ∈ Finset.Ico M n, χ (k : ZMod N) * ((k : ℕ) : ℂ) ^ (-((σ:ℂ) + (t:ℂ)*I))‖
      ≤ 6 * (N : ℝ) := by
  set s : ℂ := (σ:ℂ) + (t:ℂ)*I with hs
  have hM1 : 1 ≤ M := by omega
  have hn1 : 1 ≤ n := by omega
  have hsre : s.re = σ := by rw [hs]; simp
  have hstep : ∑ k ∈ Finset.Ico M n, χ (k : ZMod N) * ((k : ℕ) : ℂ) ^ (-s)
      = ∑ i ∈ Finset.Ico (M-1) (n-1), χ ((i+1 : ℕ) : ZMod N) * (((i+1:ℕ)):ℂ) ^ (-s) := by
    have h := Finset.sum_Ico_add (fun k : ℕ => χ (k : ZMod N) * ((k : ℕ) : ℂ) ^ (-s))
      (M-1) (n-1) 1
    rw [show (M-1)+1 = M from Nat.sub_add_cancel hM1,
        show (n-1)+1 = n from Nat.sub_add_cancel hn1] at h
    rw [← h]
    exact Finset.sum_congr rfl (fun i _ => by rw [Nat.add_comm 1 i])
  rw [hstep]
  have hcap := norm_sum_Ico_chi_succ_cpow_le χ hχ (s := s) (m := M-1) (n := n-1)
    (by rw [hsre]; linarith) (by omega) (by omega)
  have hA1 : (1:ℝ) ≤ (((M-1 : ℕ)) : ℝ) := by
    have : 1 ≤ M - 1 := by omega
    exact_mod_cast this
  have hApos : (0:ℝ) < (((M-1 : ℕ)) : ℝ) := lt_of_lt_of_le zero_lt_one hA1
  have ht : |t| ≤ (((M-1 : ℕ)) : ℝ) + 1 := by
    have hcast : (((M-1 : ℕ)) : ℝ) = (M : ℝ) - 1 := by
      rw [Nat.cast_sub hM1]; norm_num
    linarith [hMt, hcast]
  have hnorm : ‖s‖ ≤ σ + |t| := by
    rw [hs]
    refine (norm_add_le _ _).trans ?_
    rw [norm_mul, Complex.norm_I, mul_one, norm_ofReal_eq_abs, norm_ofReal_eq_abs,
      abs_of_nonneg (by linarith : (0:ℝ) ≤ σ)]
  have hAinv : (((M-1 : ℕ)) : ℝ) ^ (-σ) ≤ (((M-1 : ℕ)) : ℝ) ^ (-1 : ℝ) :=
    Real.rpow_le_rpow_of_exponent_le hA1 (by linarith)
  have hAinv' : (((M-1 : ℕ)) : ℝ) ^ (-1 : ℝ) = 1 / (((M-1 : ℕ)) : ℝ) := by
    rw [Real.rpow_neg_one, inv_eq_one_div]
  have hmain : (2 + ‖s‖) * (((M-1 : ℕ)) : ℝ) ^ (-σ) ≤ 6 := by
    have h1 : 2 + ‖s‖ ≤ (((M-1 : ℕ)) : ℝ) + 5 := by linarith [hnorm, ht, hσ2]
    have h2 : (2 + ‖s‖) * (((M-1 : ℕ)) : ℝ) ^ (-σ)
        ≤ ((((M-1 : ℕ)) : ℝ) + 5) * (1 / (((M-1 : ℕ)) : ℝ)) := by
      refine mul_le_mul h1 ?_ (Real.rpow_nonneg (le_of_lt hApos) _) (by positivity)
      rwa [← hAinv']
    refine h2.trans ?_
    rw [mul_one_div, div_le_iff₀ hApos]
    linarith
  refine hcap.trans ?_
  rw [hsre]
  calc (2 + ‖s‖) * (N : ℝ) * (((M-1 : ℕ)) : ℝ) ^ (-σ)
      = (2 + ‖s‖) * (((M-1 : ℕ)) : ℝ) ^ (-σ) * (N : ℝ) := by ring
    _ ≤ 6 * (N : ℝ) := mul_le_mul_of_nonneg_right hmain (Nat.cast_nonneg N)



open DirichletCharacter

/-- The `k`-th term of the Dirichlet series is bounded by `k^{-σ}`. -/

theorem norm_chi_mul_cpow_neg_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {s : ℂ} {σ : ℝ}
    (hsre : s.re = σ) (hσ : 0 < σ) (k : ℕ) :
    ‖χ (k : ZMod N) * ((k : ℕ) : ℂ) ^ (-s)‖ ≤ (k : ℝ) ^ (-σ) := by
  rw [norm_mul]
  have h1 : ‖χ (k : ZMod N)‖ ≤ 1 := χ.norm_le_one _
  have h2 : ‖((k : ℕ) : ℂ) ^ (-s)‖ ≤ (k : ℝ) ^ (-σ) := by
    by_cases hk0 : k = 0
    · subst hk0
      have hs0 : (-s) ≠ 0 := by
        intro h
        have := congrArg Complex.re h
        simp at this
        linarith
      rw [show (((0:ℕ)) : ℂ) = (0:ℂ) by norm_num, Complex.zero_cpow hs0, norm_zero,
        show (((0:ℕ)) : ℝ) = (0:ℝ) by norm_num, Real.zero_rpow (by linarith : (-σ:ℝ) ≠ 0)]
    · have hk1 : (0:ℝ) < (k : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hk0
      have hbridge : ((k : ℕ) : ℂ) = (((k : ℕ) : ℝ) : ℂ) := by push_cast; ring
      rw [hbridge, Complex.norm_cpow_eq_rpow_re_of_pos hk1, Complex.neg_re, hsre]
  exact le_trans (mul_le_mul_of_nonneg_right h1 (norm_nonneg _))
    (by rw [one_mul]; exact h2)

/-- Uniform-in-`n` bound for the partial sums of the Dirichlet series. -/
theorem norm_LSeries_range_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {σ t : ℝ} (hσ : 1 < σ) (hσ2 : σ ≤ 2) (n : ℕ) :
    ‖∑ k ∈ Finset.range n,
        LSeries.term (fun m => χ (m : ZMod N)) ((σ : ℂ) + (t : ℂ) * I) k‖
      ≤ (6 * (N : ℝ) + 3) * (1 + Real.log (|t| + 2)) := by
  set s : ℂ := (σ:ℂ) + (t:ℂ)*I with hs
  set f : ℕ → ℂ := fun k => χ (k : ZMod N) * ((k:ℕ):ℂ)^(-s) with hf
  have hsre : s.re = σ := by rw [hs]; simp
  have hterm : ∀ k, LSeries.term (fun m => χ (m : ZMod N)) s k = f k := by
    intro k
    rw [LSeries.term_def₀ (by simpa using chi_zero_eq_zero χ hχ), hf]
  rw [show (∑ k ∈ Finset.range n, LSeries.term (fun m => χ (m : ZMod N)) ((σ:ℂ)+(t:ℂ)*I) k)
      = ∑ k ∈ Finset.range n, f k from
        Finset.sum_congr rfl (fun k _ => by rw [hterm k])]
  set M : ℕ := max 2 ⌈|t|⌉₊ with hMdef
  have hM2 : 2 ≤ M := le_max_left _ _
  have hMt : |t| ≤ (M : ℝ) := by
    have h1 : |t| ≤ ((⌈|t|⌉₊ : ℕ) : ℝ) := Nat.le_ceil |t|
    have h2 : ((⌈|t|⌉₊ : ℕ) : ℝ) ≤ (M : ℝ) := by exact_mod_cast le_max_right 2 ⌈|t|⌉₊
    linarith
  have hMlog : Real.log (M : ℝ) ≤ Real.log (|t| + 2) := by
    refine Real.log_le_log (by positivity) ?_
    have h2 : ((⌈|t|⌉₊ : ℕ) : ℝ) ≤ |t| + 1 := le_of_lt (Nat.ceil_lt_add_one (abs_nonneg t))
    have h3 : (M : ℝ) ≤ |t| + 2 := by
      rw [hMdef, Nat.cast_max]
      refine max_le ?_ ?_
      · push_cast; linarith [abs_nonneg t]
      · linarith
    linarith
  have hlog2 : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
  have hhead : ‖∑ k ∈ Finset.range (min M n), f k‖ ≤ 1 + Real.log (|t| + 2) := by
    refine (norm_sum_le _ _).trans ?_
    have hbound : ∀ k ∈ Finset.range (min M n), ‖f k‖ ≤ (k:ℝ)^(-σ) := by
      intro k hk
      rw [hf]
      exact norm_chi_mul_cpow_neg_le χ hsre (by linarith) k
    calc ∑ k ∈ Finset.range (min M n), ‖f k‖
        ≤ ∑ k ∈ Finset.range (min M n), (k:ℝ)^(-σ) := Finset.sum_le_sum hbound
      _ ≤ ∑ k ∈ Finset.range M, (k:ℝ)^(-σ) := by
          refine Finset.sum_le_sum_of_subset_of_nonneg ?_ ?_
          · intro x hx
            exact Finset.mem_range.mpr (lt_of_lt_of_le (Finset.mem_range.mp hx) (min_le_left _ _))
          · intro x hx hxM
            exact Real.rpow_nonneg (Nat.cast_nonneg x) _
      _ ≤ 1 + Real.log M := sum_range_rpow_neg_le_log hσ.le M
      _ ≤ 1 + Real.log (|t| + 2) := by linarith
  by_cases hn : n ≤ M
  · refine (by simpa [min_eq_right hn] using hhead : ‖∑ k ∈ Finset.range n, f k‖
        ≤ 1 + Real.log (|t| + 2)).trans ?_
    have hCN : (1:ℝ) ≤ 6 * (N : ℝ) + 3 := by
      have := Nat.cast_nonneg (α := ℝ) N; linarith
    nlinarith [hlog2, hCN]
  · have hnlt : M < n := not_le.mp hn
    have hsplit : ∑ k ∈ Finset.range n, f k
        = (∑ k ∈ Finset.range M, f k) + ∑ k ∈ Finset.Ico M n, f k := by
      simp only [Finset.range_eq_Ico]
      exact (Finset.sum_Ico_consecutive f (Nat.zero_le M) hnlt.le).symm
    rw [hsplit]
    refine (norm_add_le _ _).trans ?_
    have hheadM : ‖∑ k ∈ Finset.range M, f k‖ ≤ 1 + Real.log (|t| + 2) := by
      have := hhead
      rwa [min_eq_left hnlt.le] at this
    have htail : ‖∑ k ∈ Finset.Ico M n, f k‖ ≤ 6 * (N : ℝ) := by
      have := norm_sum_Ico_chi_cpow_tail_le χ hχ (le_of_lt hσ) hσ2 hM2 hnlt hMt
      simpa [hf, hs] using this
    have hC : (0:ℝ) < (6 * (N : ℝ) + 3) := by positivity
    nlinarith [hheadM, htail, hlog2, hC]

/-- The Dirichlet series bound for `1 < σ`. -/
theorem norm_LFunction_le_of_gt_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {σ t : ℝ} (hσ : 1 < σ) (hσ2 : σ ≤ 2) :
    ‖LFunction χ ((σ : ℂ) + (t : ℂ) * I)‖ ≤ (6 * (N : ℝ) + 3) * (1 + Real.log (|t| + 2)) := by
  have hsre : 1 < ((σ : ℂ) + (t : ℂ) * I).re := by simp; linarith
  rw [DirichletCharacter.LFunction_eq_LSeries χ hsre]
  have hsumm : LSeriesSummable (fun m => χ (m : ZMod N)) ((σ : ℂ) + (t : ℂ) * I) :=
    LSeriesSummable_of_bounded_of_one_lt_re (m := 1) (fun n _ => χ.norm_le_one _) hsre
  have htend := (hsumm.hasSum.tendsto_sum_nat).norm
  exact le_of_tendsto_of_tendsto' htend tendsto_const_nhds
    (fun n => norm_LSeries_range_le χ hχ hσ hσ2 n)

/-- The Dirichlet series bound on the line `σ = 1`, by continuity. -/
theorem norm_LFunction_le_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    (t : ℝ) :
    ‖LFunction χ ((1 : ℂ) + (t : ℂ) * I)‖
      ≤ (6 * (N : ℝ) + 3) * (1 + Real.log (|t| + 2)) := by
  have hcont : ContinuousAt (fun σ : ℝ => LFunction χ ((σ : ℂ) + (t : ℂ) * I)) 1 :=
    (differentiable_LFunction hχ).continuous.continuousAt.comp (by fun_prop)
  have htend : Tendsto (fun σ : ℝ => ‖LFunction χ ((σ : ℂ) + (t : ℂ) * I)‖) (𝓝[>] (1:ℝ))
      (𝓝 ‖LFunction χ ((1 : ℂ) + (t : ℂ) * I)‖) :=
    (hcont.mono_left nhdsWithin_le_nhds).norm
  refine le_of_tendsto htend ?_
  have h2 : ∀ᶠ σ : ℝ in 𝓝[>] (1:ℝ), σ ≤ 2 := by
    rw [eventually_nhdsWithin_iff]
    filter_upwards [eventually_lt_nhds (by norm_num : (1:ℝ) < 2)] with σ hσ _
    linarith
  filter_upwards [self_mem_nhdsWithin, h2] with σ hσ hσ2
  exact norm_LFunction_le_of_gt_one χ hχ hσ hσ2

/-- **The `L`-function is `O(log)` on the line `Re = 1` and uniformly in `1 ≤ σ ≤ 2`.** -/
theorem norm_LFunction_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    ∃ C : ℝ, 0 < C ∧ ∀ σ t : ℝ, 1 ≤ σ → σ ≤ 2 →
      ‖LFunction χ ((σ : ℂ) + (t : ℂ) * I)‖ ≤ C * (1 + Real.log (|t| + 2)) := by
  refine ⟨6 * (N : ℝ) + 6, by positivity, fun σ t hσ1 hσ2 => ?_⟩
  rcases eq_or_lt_of_le hσ1 with h | h
  · subst h
    refine (norm_LFunction_le_one χ hχ t).trans ?_
    have hlog2 : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
    have hCN : (0:ℝ) ≤ 6 * (N : ℝ) + 3 := by positivity
    nlinarith
  · refine (norm_LFunction_le_of_gt_one χ hχ h hσ2).trans ?_
    have hlog2 : (0:ℝ) ≤ Real.log (|t| + 2) := Real.log_nonneg (by linarith [abs_nonneg t])
    have hCN : (0:ℝ) ≤ 6 * (N : ℝ) + 3 := by positivity
    nlinarith


/-- For `0 < w ≤ 1` and `σ > 0`: `σ(1−w) ≤ w^{−σ} − 1`. -/
theorem mul_one_sub_le_rpow_neg_sub_one {σ w : ℝ} (hσ : 0 < σ) (hw : 0 < w) (hw1 : w ≤ 1) :
    σ * (1 - w) ≤ w ^ (-σ) - 1 := by
  have hint : ∫ x in w..1, (1 : ℝ) ≤ ∫ x in w..1, x ^ (-σ - 1) := by
    refine intervalIntegral.integral_mono_on hw1 intervalIntegrable_const ?_ ?_
    · exact (continuous_id.continuousOn.rpow_const (fun x hx => by
        rw [Set.uIcc_of_le hw1] at hx
        exact Or.inl (ne_of_gt (lt_of_lt_of_le hw hx.1)))).intervalIntegrable
    · intro x hx
      have hx0 : 0 < x := lt_of_lt_of_le hw hx.1
      have h1x : (1 : ℝ) ≤ x⁻¹ := (one_le_inv₀ hx0).mpr hx.2
      have h2 := Real.one_le_rpow h1x (by linarith : (0 : ℝ) ≤ σ + 1)
      rw [Real.inv_rpow hx0.le, ← Real.rpow_neg hx0.le (σ + 1),
        show -(σ + 1) = -σ - 1 by ring] at h2
      exact h2
  have hInt : ∫ x in w..1, x ^ (-σ - 1) = (w ^ (-σ) - 1) / σ := by
    rw [integral_rpow (Or.inr ⟨by linarith [hσ], by
      rw [Set.uIcc_of_le hw1]
      exact fun h => absurd h.1 (not_le.mpr hw)⟩)]
    rw [show (-σ - 1) + 1 = -σ by ring, Real.one_rpow]
    field_simp
    ring
  rw [intervalIntegral.integral_const] at hint
  simp only [smul_eq_mul, mul_one] at hint
  rw [hInt] at hint
  have h := (le_div_iff₀ hσ).mp hint
  nlinarith [h]

/-- **Sharp tail sum for the Abel variation, `σ > 0`.** -/
theorem sum_Ico_rpow_neg_succ_le_of_pos {σ : ℝ} (hσ : 0 < σ) {m n : ℕ} (hm : 1 ≤ m)
    (hmn : m ≤ n) :
    ∑ i ∈ Finset.Ico m n, ((i + 1 : ℕ) : ℝ) ^ (-σ - 1) ≤ ((m : ℕ) : ℝ) ^ (-σ) / σ := by
  have hterm : ∀ i ∈ Finset.Ico m n, ((i + 1 : ℕ) : ℝ) ^ (-σ - 1)
      ≤ (1 / σ) * (((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)) := by
    intro i hi
    have hi1 : 1 ≤ i := le_trans hm (Finset.mem_Ico.mp hi).1
    have hA : (0 : ℝ) < ((i : ℕ) : ℝ) := by exact_mod_cast hi1
    have hB : (0 : ℝ) < ((i + 1 : ℕ) : ℝ) := by positivity
    have hAB : ((i : ℕ) : ℝ) ≤ ((i + 1 : ℕ) : ℝ) := by push_cast; linarith
    have hw : (0 : ℝ) < ((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ) := div_pos hA hB
    have hwle : ((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ) ≤ 1 := (div_le_one hB).mpr hAB
    have hkey := mul_one_sub_le_rpow_neg_sub_one hσ hw hwle
    have hwpow : ((i + 1 : ℕ) : ℝ) ^ (-σ) * (((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ)) ^ (-σ)
        = ((i : ℕ) : ℝ) ^ (-σ) := by
      rw [← Real.mul_rpow hB.le (div_nonneg hA.le hB.le)]
      congr 1
      field_simp
    have hdiff : ((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)
        = ((i + 1 : ℕ) : ℝ) ^ (-σ) * ((((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ)) ^ (-σ) - 1) := by
      rw [mul_sub, mul_one, hwpow]
    have hL : ((i + 1 : ℕ) : ℝ) ^ (-σ) * (1 - ((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ))
        = ((i + 1 : ℕ) : ℝ) ^ (-σ - 1) := by
      have hw1 : 1 - ((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ) = 1 / ((i + 1 : ℕ) : ℝ) := by
        field_simp; push_cast; ring
      rw [hw1, show (-σ - 1 : ℝ) = -σ + (-1) by ring, Real.rpow_add hB, Real.rpow_neg_one,
        inv_eq_one_div]
    have hmul : ((i + 1 : ℕ) : ℝ) ^ (-σ) * (1 - ((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ))
        ≤ (1 / σ) * (((i + 1 : ℕ) : ℝ) ^ (-σ)
          * ((((i : ℕ) : ℝ) / ((i + 1 : ℕ) : ℝ)) ^ (-σ) - 1)) := by
      rw [one_div_mul_eq_div, le_div_iff₀ hσ]
      have h := mul_le_mul_of_nonneg_left hkey (Real.rpow_pos_of_pos hB (-σ)).le
      nlinarith [h]
    rwa [hL, ← hdiff] at hmul
  have htel := sum_Ico_sub_telescope (fun k : ℕ => ((k : ℕ) : ℝ) ^ (-σ)) hmn
  calc ∑ i ∈ Finset.Ico m n, ((i + 1 : ℕ) : ℝ) ^ (-σ - 1)
      ≤ ∑ i ∈ Finset.Ico m n, (1 / σ) * (((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)) :=
        Finset.sum_le_sum hterm
    _ = (1 / σ) * ∑ i ∈ Finset.Ico m n, (((i : ℕ) : ℝ) ^ (-σ) - ((i + 1 : ℕ) : ℝ) ^ (-σ)) := by
        rw [Finset.mul_sum]
    _ = (1 / σ) * (((m : ℕ) : ℝ) ^ (-σ) - ((n : ℕ) : ℝ) ^ (-σ)) := by rw [htel]
    _ ≤ (1 / σ) * ((m : ℕ) : ℝ) ^ (-σ) := by
        refine mul_le_mul_of_nonneg_left ?_ (by positivity)
        have := Real.rpow_nonneg (Nat.cast_nonneg n) (-σ)
        linarith
    _ = ((m : ℕ) : ℝ) ^ (-σ) / σ := by ring

end

end RouteABC

namespace RouteABC
noncomputable section
open scoped BigOperators

/-- **The Abel capstone for `0 < Re s`.**  The `Re s ≥ 1` form is `norm_sum_Ico_mul_cpow_le`; here
the variation sum costs `m^{−σ}/σ` instead of `m^{−σ}`, and the two endpoint arms no longer telescope. -/
theorem norm_sum_Ico_mul_cpow_le_of_pos {g : ℕ → ℂ} {B : ℝ} (hB : 0 ≤ B)
    (hg : ∀ k : ℕ, ‖∑ j ∈ Finset.range k, g j‖ ≤ B)
    {s : ℂ} (hs : 0 < s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, g i * (((i + 1 : ℕ) : ℂ) ^ (-s))‖
      ≤ B * (((n : ℕ) : ℝ) ^ (-s.re) + ((m + 1 : ℕ) : ℝ) ^ (-s.re))
        + ‖s‖ * B * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) := by
  have hmR : (0 : ℝ) < ((m : ℕ) : ℝ) := by exact_mod_cast hm
  have hn1 : 1 ≤ n := by omega
  have hnR : (0 : ℝ) < ((n : ℕ) : ℝ) := by exact_mod_cast hn1
  have hm1R : (0 : ℝ) < ((m + 1 : ℕ) : ℝ) := by positivity
  have hcn : ((n : ℕ) : ℂ) = (((n : ℕ) : ℝ) : ℂ) := by push_cast; ring
  have hcm1 : ((m + 1 : ℕ) : ℂ) = (((m + 1 : ℕ) : ℝ) : ℂ) := by push_cast; ring
  have hA : ‖((n : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range n, g i)‖
      ≤ ((n : ℕ) : ℝ) ^ (-s.re) * B := by
    rw [norm_mul, hcn, Complex.norm_cpow_eq_rpow_re_of_pos hnR]
    exact mul_le_mul_of_nonneg_left (hg n) (Real.rpow_pos_of_pos hnR _).le
  have hB' : ‖((m + 1 : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range m, g i)‖
      ≤ ((m + 1 : ℕ) : ℝ) ^ (-s.re) * B := by
    rw [norm_mul, hcm1, Complex.norm_cpow_eq_rpow_re_of_pos hm1R]
    exact mul_le_mul_of_nonneg_left (hg m) (Real.rpow_pos_of_pos hm1R _).le
  have hC : ‖∑ i ∈ Finset.Ico m (n - 1),
        ((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
          * (∑ j ∈ Finset.range (i + 1), g j)‖
      ≤ ‖s‖ * B * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) := by
    refine (norm_sum_le _ _).trans ?_
    have hterm : ∀ i ∈ Finset.Ico m (n - 1),
        ‖((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
          * (∑ j ∈ Finset.range (i + 1), g j)‖
        ≤ ‖s‖ * ((i + 1 : ℕ) : ℝ) ^ (-s.re - 1) * B := by
      intro i hi
      have hi1 : 1 ≤ i + 1 := Nat.succ_le_succ (Nat.zero_le i)
      have hle : ((i + 1 : ℕ) : ℝ) ≤ ((i + 1 + 1 : ℕ) : ℝ) := by push_cast; linarith
      have hdiff := norm_cpow_neg_sub_le (s := s) hs
        (a := ((i + 1 : ℕ) : ℝ)) (b := ((i + 1 + 1 : ℕ) : ℝ)) (by exact_mod_cast hi1) hle
      have hsub : ((i + 1 + 1 : ℕ) : ℝ) - ((i + 1 : ℕ) : ℝ) = 1 := by push_cast; ring
      rw [norm_mul]
      refine le_trans (mul_le_mul_of_nonneg_right hdiff (norm_nonneg _)) ?_
      rw [hsub, mul_one]
      exact mul_le_mul_of_nonneg_left (hg (i + 1)) (by positivity)
    calc ∑ i ∈ Finset.Ico m (n - 1),
          ‖((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
            * (∑ j ∈ Finset.range (i + 1), g j)‖
        ≤ ∑ i ∈ Finset.Ico m (n - 1), ‖s‖ * ((i + 1 : ℕ) : ℝ) ^ (-s.re - 1) * B :=
          Finset.sum_le_sum hterm
      _ = ‖s‖ * (∑ i ∈ Finset.Ico m (n - 1), ((i + 1 : ℕ) : ℝ) ^ (-s.re - 1)) * B := by
          rw [Finset.mul_sum, Finset.sum_mul]
      _ ≤ ‖s‖ * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) * B := by
          refine mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left ?_ (norm_nonneg s)) hB
          exact sum_Ico_rpow_neg_succ_le_of_pos hs hm (by omega)
      _ = ‖s‖ * B * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) := by ring
  set X : ℂ := ((n : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range n, g i) with hX
  set Y : ℂ := ((m + 1 : ℕ) : ℂ) ^ (-s) * (∑ i ∈ Finset.range m, g i) with hY
  set Z : ℂ := ∑ i ∈ Finset.Ico m (n - 1),
      ((((i + 1 + 1 : ℕ) : ℂ) ^ (-s)) - (((i + 1 : ℕ) : ℂ) ^ (-s)))
        * (∑ j ∈ Finset.range (i + 1), g j) with hZ
  have htri : ‖X - Y - Z‖ ≤ ‖X‖ + ‖Y‖ + ‖Z‖ := by
    refine (norm_sub_le (X - Y) Z).trans ?_
    have h2 := norm_sub_le X Y
    linarith
  rw [sum_Ico_mul_cpow_eq g s hmn, hX, hY, hZ] at *
  refine htri.trans ?_
  have hid : ((n : ℕ) : ℝ) ^ (-s.re) * B + ((m + 1 : ℕ) : ℝ) ^ (-s.re) * B
      + ‖s‖ * B * (((m : ℕ) : ℝ) ^ (-s.re) / s.re)
      = B * (((n : ℕ) : ℝ) ^ (-s.re) + ((m + 1 : ℕ) : ℝ) ^ (-s.re))
        + ‖s‖ * B * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) := by ring
  linarith [hA, hB', hC, hid]

/-- The `χ`-form of the `0 < Re s` capstone. -/
theorem norm_sum_Ico_chi_cpow_le_of_pos {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))‖
      ≤ (N : ℝ) * (((n : ℕ) : ℝ) ^ (-s.re) + ((m + 1 : ℕ) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) :=
  norm_sum_Ico_mul_cpow_le_of_pos (Nat.cast_nonneg N)
    (fun k => norm_sum_range_chi_le χ hχ k) hs hm hmn

/-- The shifted-`χ` form of the `0 < Re s` capstone. -/
theorem norm_sum_Ico_chi_succ_cpow_le_of_pos {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))‖
      ≤ (N : ℝ) * (((n : ℕ) : ℝ) ^ (-s.re) + ((m + 1 : ℕ) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * (((m : ℕ) : ℝ) ^ (-s.re) / s.re) :=
  norm_sum_Ico_mul_cpow_le_of_pos (Nat.cast_nonneg N)
    (fun k => norm_sum_range_chi_succ_le χ hχ k) hs hm hmn

/-- **O1.T12 sub-target (i).**  The GammaSeq bracketing antiderivative has the claimed derivative.
Stated in the `(1/2) log` normalisation the algebra produces (journal 322); `√` form is the corollary. -/
theorem hasDerivAt_gammaAntideriv (σ t : ℝ) (ht : 0 < t) (u : ℝ) :
    HasDerivAt (fun x : ℝ => (1 / 2) * ((σ + x) * Real.log ((σ + x) ^ 2 + t ^ 2) - 2 * (σ + x)
        + 2 * t * Real.arctan ((σ + x) / t)))
      ((1 / 2) * Real.log ((σ + u) ^ 2 + t ^ 2)) u := by
  have hne : (σ + u) ^ 2 + t ^ 2 ≠ 0 := by positivity
  have h1 : HasDerivAt (fun x : ℝ => σ + x) 1 u := (hasDerivAt_id u).const_add σ
  have h2 : HasDerivAt (fun x : ℝ => (σ + x) ^ 2 + t ^ 2) (2 * (σ + u)) u := by
    have hp := h1.pow 2
    have hc := hp.add_const (t ^ 2)
    simpa using hc
  have h3 : HasDerivAt (fun x : ℝ => Real.log ((σ + x) ^ 2 + t ^ 2))
      ((2 * (σ + u)) / ((σ + u) ^ 2 + t ^ 2)) u := h2.log hne
  have h4 := h1.mul h3
  have h5 := h1.const_mul (-2)
  have h6 : HasDerivAt (fun x : ℝ => (σ + x) / t) (1 / t) u := h1.div_const t
  have h7 : HasDerivAt (fun x : ℝ => Real.arctan ((σ + x) / t))
      ((1 / (1 + ((σ + u) / t) ^ 2)) * (1 / t)) u := by
    have hbase : HasDerivAt Real.arctan (1 / (1 + ((σ + u) / t) ^ 2)) ((σ + u) / t) :=
      Real.hasDerivAt_arctan _
    exact hbase.comp u h6
  have h8 := h7.const_mul (2 * t)
  have h9 := ((h4.add h5).add h8).const_mul (1 / 2)
  convert h9 using 1
  · funext x
    simp only [Pi.add_apply, Pi.mul_apply, Pi.sub_apply]
    ring
  · field_simp
    ring

/-- The `√` form, from the `(1/2) log` normalisation via `Real.log_sqrt` **outside** the motive. -/
theorem hasDerivAt_gammaAntideriv_sqrt (σ t : ℝ) (ht : 0 < t) (u : ℝ) :
    HasDerivAt (fun x : ℝ => (1 / 2) * ((σ + x) * Real.log ((σ + x) ^ 2 + t ^ 2) - 2 * (σ + x)
        + 2 * t * Real.arctan ((σ + x) / t)))
      (Real.log (Real.sqrt ((σ + u) ^ 2 + t ^ 2))) u := by
  have hnn : (0 : ℝ) ≤ (σ + u) ^ 2 + t ^ 2 := by positivity
  convert hasDerivAt_gammaAntideriv σ t ht u using 1
  rw [Real.log_sqrt hnn]
  ring

/-- **O1.T12 sub-target (ii), step 1.**  The GammaSeq bracketing integrand
`x ↦ log √((σ+x)² + t²)` is monotone on `[0, ∞)` for `σ > 0` — no hypothesis on `t` is needed, because
`σ + x > 0` on that half-line already makes the radicand positive. -/
theorem monotoneOn_logSqrt_sq {σ t : ℝ} (hσ : 0 < σ) :
    MonotoneOn (fun x : ℝ => Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2))) (Set.Ici 0) := by
  intro x hx y hy hxy
  have hx0 : 0 < σ + x := by
    have := Set.mem_Ici.mp hx
    linarith
  have h1 : (σ + x) ^ 2 ≤ (σ + y) ^ 2 := by nlinarith [Set.mem_Ici.mp hy]
  have h2 : Real.sqrt ((σ + x) ^ 2 + t ^ 2) ≤ Real.sqrt ((σ + y) ^ 2 + t ^ 2) :=
    Real.sqrt_le_sqrt (by linarith)
  have h3 : (0 : ℝ) < Real.sqrt ((σ + x) ^ 2 + t ^ 2) :=
    Real.sqrt_pos.mpr (by positivity)
  exact Real.log_le_log h3 h2
open MeasureTheory intervalIntegral

/-- **O1.T12 sub-target (ii), step 3.** -/
theorem logSqrt_le_intervalIntegral {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) (k : ℕ) :
    Real.log (Real.sqrt ((σ + (k : ℝ)) ^ 2 + t ^ 2))
      ≤ ∫ x in (k : ℝ)..((k : ℝ) + 1), Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)) := by
  have hmono := monotoneOn_logSqrt_sq (t := t) hσ
  have hcont : Continuous fun x : ℝ => Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)) :=
    Continuous.log (Real.continuous_sqrt.comp (by fun_prop)) (fun x => by
      have h : (0 : ℝ) < (σ + x) ^ 2 + t ^ 2 := by positivity
      exact ne_of_gt (Real.sqrt_pos.mpr h))
  have hk : (k : ℝ) ≤ (k : ℝ) + 1 := by linarith
  have hmem : ∀ x ∈ Set.Icc (k : ℝ) ((k : ℝ) + 1),
      Real.log (Real.sqrt ((σ + (k : ℝ)) ^ 2 + t ^ 2))
        ≤ Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)) := by
    intro x hx
    exact hmono (Set.mem_Ici.mpr (by positivity)) (Set.mem_Ici.mpr (by linarith [hx.1])) hx.1
  have h := intervalIntegral.integral_mono_on (μ := volume) hk
    (continuous_const.intervalIntegrable (k : ℝ) ((k : ℝ) + 1))
    (hcont.intervalIntegrable (k : ℝ) ((k : ℝ) + 1)) hmem
  rw [intervalIntegral.integral_const] at h
  simpa using h

/-- **O1.T12 (ii): bracketing integrand monotonicity, pointwise** (journal 330). -/
theorem logSqrt_sq_mono {σ t x y : ℝ} (hσ : 0 < σ) (hx : 0 ≤ x) (hxy : x ≤ y) :
    Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2))
      ≤ Real.log (Real.sqrt ((σ + y) ^ 2 + t ^ 2)) := by
  have hx0 : 0 < σ + x := by linarith
  have h1 : (σ + x) ^ 2 ≤ (σ + y) ^ 2 := by nlinarith
  have h2 : Real.sqrt ((σ + x) ^ 2 + t ^ 2) ≤ Real.sqrt ((σ + y) ^ 2 + t ^ 2) :=
    Real.sqrt_le_sqrt (by linarith)
  have h3 : (0 : ℝ) < Real.sqrt ((σ + x) ^ 2 + t ^ 2) :=
    Real.sqrt_pos.mpr (by positivity)
  exact Real.log_le_log h3 h2

/-- **O1.T12 sub-target (ii), step 3 — RIGHT-endpoint direction** (the one T12 consumes, journals
329-330), with the statement normalised so that the argument of `logSqrt_sq_mono` matches without an
associativity rewrite: the right endpoint is written `σ + ((k : ℝ) + 1)`. -/
theorem intervalIntegral_logSqrt_le {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) (k : ℕ) :
    (∫ x in (k : ℝ)..((k : ℝ) + 1), Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)))
      ≤ Real.log (Real.sqrt ((σ + ((k : ℝ) + 1)) ^ 2 + t ^ 2)) := by
  have hcont : Continuous fun x : ℝ => Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)) :=
    Continuous.log (Real.continuous_sqrt.comp (by fun_prop)) (fun x => by
      have h : (0 : ℝ) < (σ + x) ^ 2 + t ^ 2 := by positivity
      exact ne_of_gt (Real.sqrt_pos.mpr h))
  have hk : (k : ℝ) ≤ (k : ℝ) + 1 := by linarith
  have hmem : ∀ x ∈ Set.Icc (k : ℝ) ((k : ℝ) + 1),
      Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2))
        ≤ Real.log (Real.sqrt ((σ + ((k : ℝ) + 1)) ^ 2 + t ^ 2)) := fun x hx =>
    logSqrt_sq_mono hσ (by linarith [hx.1]) hx.2
  have h := intervalIntegral.integral_mono_on (μ := volume) hk
    (hcont.intervalIntegrable (k : ℝ) ((k : ℝ) + 1))
    (continuous_const.intervalIntegrable (k : ℝ) ((k : ℝ) + 1)) hmem
  rw [intervalIntegral.integral_const] at h
  simpa using h

/-- **O1.T12 (ii), steps 2+4 — by INDUCTION** (journal 334): no `Ico`, no `map`, no `omega`.  The
induction step splits the integral with `integral_add_adjacent_intervals` and closes the new piece with
the right-endpoint lemma above. -/
theorem integral_le_sum_Ico_logSqrt {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) (n : ℕ) :
    (∫ x in (0 : ℝ)..(n : ℝ), Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)))
      ≤ ∑ k ∈ Finset.Ico 1 (n + 1), Real.log (Real.sqrt ((σ + (k : ℝ)) ^ 2 + t ^ 2)) := by
  induction n with
  | zero => simp
  | succ m ih =>
      have hstep : (∫ x in (0 : ℝ)..((m : ℝ) + 1),
            Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)))
          = (∫ x in (0 : ℝ)..(m : ℝ), Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)))
            + ∫ x in (m : ℝ)..((m : ℝ) + 1), Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)) := by
        have hcont : Continuous fun x : ℝ => Real.log (Real.sqrt ((σ + x) ^ 2 + t ^ 2)) :=
          Continuous.log (Real.continuous_sqrt.comp (by fun_prop)) (fun x => by
            have h : (0 : ℝ) < (σ + x) ^ 2 + t ^ 2 := by positivity
            exact ne_of_gt (Real.sqrt_pos.mpr h))
        exact (intervalIntegral.integral_add_adjacent_intervals
          (hcont.intervalIntegrable (0 : ℝ) (m : ℝ))
          (hcont.intervalIntegrable (m : ℝ) ((m : ℝ) + 1))).symm
      rw [Nat.cast_succ, hstep,
        Finset.sum_Ico_succ_top (by omega : 1 ≤ m + 1)]
      have hpiece := intervalIntegral_logSqrt_le (σ := σ) (t := t) hσ ht m
      push_cast
      linarith [ih, hpiece]

/-- **O1.T12: the closed-form integral.**  Fundamental theorem applied to the journal-324 derivative.
`μ := volume` is passed explicitly per the standing rule of journal 337. -/
theorem intervalIntegral_logSqrt_eq (σ t n : ℝ) (ht : 0 < t) :
    (∫ x in (0 : ℝ)..n, (1 / 2) * Real.log ((σ + x) ^ 2 + t ^ 2))
      = (1 / 2) * ((σ + n) * Real.log ((σ + n) ^ 2 + t ^ 2) - 2 * (σ + n)
          + 2 * t * Real.arctan ((σ + n) / t))
        - (1 / 2) * (σ * Real.log (σ ^ 2 + t ^ 2) - 2 * σ + 2 * t * Real.arctan (σ / t)) := by
  have hcont : Continuous fun x : ℝ => (1 / 2) * Real.log ((σ + x) ^ 2 + t ^ 2) :=
    continuous_const.mul (Continuous.log (by fun_prop) (fun x => by
      have h : (0 : ℝ) < (σ + x) ^ 2 + t ^ 2 := by positivity
      exact ne_of_gt h))
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
    (f := fun x : ℝ => (1 / 2) * ((σ + x) * Real.log ((σ + x) ^ 2 + t ^ 2) - 2 * (σ + x)
        + 2 * t * Real.arctan ((σ + x) / t)))
    (fun x _ => hasDerivAt_gammaAntideriv σ t ht x)
    (hcont.intervalIntegrable (μ := volume) 0 n)]
  ring_nf
open scoped Topology

/-- **O1.T12: the `π/2` isolated.**  T12's sharp rate comes from the ARGUMENT `(σ+n)/t → +∞` making
`arctan` tend to `π/2`.  `open scoped Topology` is REQUIRED at the splice point for `𝓝` — without it the
STATEMENT fails to elaborate, which cost five rounds (journals 339-344). -/
theorem tendsto_arctan_div_atTop {σ t : ℝ} (ht : 0 < t) :
    Tendsto (fun n : ℝ => Real.arctan ((σ + n) / t)) atTop (𝓝 (Real.pi / 2)) := by
  have h1 : Tendsto (fun n : ℝ => σ + n) atTop atTop := by
    simpa [add_comm] using tendsto_atTop_add_const_right (l := atTop) σ tendsto_id
  have h2 : Tendsto (fun n : ℝ => (σ + n) / t) atTop atTop := h1.atTop_div_const ht
  exact (Real.tendsto_arctan_atTop.comp h2).mono_right nhdsWithin_le_nhds

open Stirling

/-- **O1.T12 step 5, first brick.**  The telescoping identity for `log ∘ stirlingSeq`, which converts
Mathlib's two-term estimate `log_stirlingSeq_sdiff_le` into a bound on an arbitrary tail.  The statement
writes `n + (k + 1)` to match what `Finset.sum_range_sub` produces (journals 322/331/353). -/
theorem sum_range_log_stirlingSeq_telescope (n m : ℕ) :
    (∑ k ∈ Finset.range m,
        (Real.log (stirlingSeq (n + (k + 1))) - Real.log (stirlingSeq (n + k))))
      = Real.log (stirlingSeq (n + m)) - Real.log (stirlingSeq n) := by
  simpa using Finset.sum_range_sub (fun k => Real.log (stirlingSeq (n + k))) m

/-- **O1.T12 step 5, second brick.**  The partial-fraction telescoping sum, which turns Mathlib's
two-term estimate `log_stirlingSeq_sdiff_le` into a bound on a tail of the Stirling series. -/
theorem sum_range_one_div_mul_succ (n m : ℕ) (hn : n ≠ 0) :
    (∑ k ∈ Finset.range m, (1 / ((n + k : ℝ) * (n + k + 1))))
      = 1 / (n : ℝ) - 1 / ((n + m : ℕ) : ℝ) := by
  induction m with
  | zero => simp
  | succ m ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      have h1 : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn
      field_simp
      ring

/-- **O1.T12 step 5 (orientation facts).**  `log ∘ stirlingSeq` is antitone (Mathlib
`log_stirlingSeq'_antitone`), read off in the `succ`-shifted form the tail argument uses. -/
theorem log_stirlingSeq_succ_antitone {a b : ℕ} (h : a ≤ b) :
    Real.log (stirlingSeq (b + 1)) ≤ Real.log (stirlingSeq (a + 1)) :=
  log_stirlingSeq'_antitone h

/-- **O1.T12 step 5 (lower bound).**  `√π ≤ stirlingSeq n` in logarithmic form — the fact that lets the
corrected orientation of journal 358 close the Stirling upper bound WITHOUT a limit. -/
theorem log_sqrt_pi_le_log_stirlingSeq {n : ℕ} (hn : n ≠ 0) :
    Real.log (Real.sqrt Real.pi) ≤ Real.log (stirlingSeq n) :=
  Real.log_le_log (Real.sqrt_pos.mpr Real.pi_pos) (sqrt_pi_le_stirlingSeq hn)

/-- **O1.T12 step 5, brick 2'.**  The same telescoping value as §357's brick 2 but with the `12 *` kept
INSIDE the summand — the exact shape Mathlib's `log_stirlingSeq_sdiff_le` produces, so the tail bound
needs no rearrangement at all (journals 359-360). -/
theorem sum_range_one_div_twelve_mul_succ (n m : ℕ) (hn : n ≠ 0) :
    (∑ k ∈ Finset.range m, (1 / (12 * ((n + k : ℝ) * (n + k + 1)))))
      = 1 / 12 * (1 / (n : ℝ) - 1 / ((n + m : ℕ) : ℝ)) := by
  induction m with
  | zero => simp
  | succ m ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      have h1 : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn
      field_simp
      ring

/-- **O1.T12 step 5, brick 3.**  The backward tail bound.  Fix 1 (journal 362): the telescoping
identity is obtained with `congrArg Neg.neg` from `Finset.sum_range_sub`'s forward orientation and
normalised with `sum_neg_distrib`/`neg_sub`.  Fix 2: the per-term bound needs `mul_assoc`. -/
theorem log_stirlingSeq_sub_le {n m : ℕ} (hn : n ≠ 0) :
    Real.log (stirlingSeq n) - Real.log (stirlingSeq (n + m))
      ≤ 1 / 12 * (1 / (n : ℝ) - 1 / ((n + m : ℕ) : ℝ)) := by
  have htel : Real.log (stirlingSeq n) - Real.log (stirlingSeq (n + m))
      = ∑ k ∈ Finset.range m,
          (Real.log (stirlingSeq (n + k)) - Real.log (stirlingSeq (n + (k + 1)))) := by
    have h := congrArg Neg.neg (Finset.sum_range_sub (fun k => Real.log (stirlingSeq (n + k))) m)
    simpa [Finset.sum_neg_distrib, neg_sub, Nat.add_assoc] using h.symm
  rw [htel]
  calc (∑ k ∈ Finset.range m,
          (Real.log (stirlingSeq (n + k)) - Real.log (stirlingSeq (n + (k + 1)))))
      ≤ ∑ k ∈ Finset.range m, (1 / (12 * ((n + k : ℝ) * (n + k + 1)))) := by
        refine Finset.sum_le_sum fun k _ => ?_
        simpa [mul_assoc, Nat.add_assoc] using log_stirlingSeq_sdiff_le (n + k)
    _ = 1 / 12 * (1 / (n : ℝ) - 1 / ((n + m : ℕ) : ℝ)) :=
        sum_range_one_div_twelve_mul_succ n m hn

/-- **O1.T12 step 5 COMPLETE: the sharp Stirling upper bound.  `log n! ≤ n log n − n + (1/2)log(2πn) + 1/(12n)`
follows from this and Mathlib's `log_stirlingSeq_formula`.** -/
theorem log_stirlingSeq_le_log_sqrt_pi_add {n : ℕ} (hn : n ≠ 0) :
    Real.log (stirlingSeq n) ≤ Real.log (Real.sqrt Real.pi) + 1 / (12 * (n : ℝ)) := by
  have hle1 : ∀ m : ℕ, Real.log (stirlingSeq n)
      ≤ Real.log (stirlingSeq (n + m)) + 1 / 12 * (1 / (n : ℝ)) := by
    intro m
    have h1 := log_stirlingSeq_sub_le (n := n) (m := m) hn
    have h2 : (0 : ℝ) ≤ 1 / ((n + m : ℕ) : ℝ) := by positivity
    linarith
  have hle2 : ∀ m : ℕ, Real.log (Real.sqrt Real.pi) + 1 / 12 * (1 / (n : ℝ))
      ≤ Real.log (stirlingSeq (n + m)) + 1 / 12 * (1 / (n : ℝ)) := fun m =>
    add_le_add_left (log_sqrt_pi_le_log_stirlingSeq (n := n + m) (by omega)) (1 / 12 * (1 / (n : ℝ)))
  have h1 : Tendsto (fun m : ℕ => Real.log (stirlingSeq (n + m))) atTop
      (𝓝 (Real.log (Real.sqrt Real.pi))) := by
    simpa [Nat.add_comm] using
      (tendsto_stirlingSeq_sqrt_pi.comp (tendsto_add_atTop_nat n)).log (by positivity)
  have hlim : Tendsto (fun m : ℕ => Real.log (stirlingSeq (n + m)) + 1 / 12 * (1 / (n : ℝ)))
      atTop (𝓝 (Real.log (Real.sqrt Real.pi) + 1 / 12 * (1 / (n : ℝ)))) :=
    h1.add tendsto_const_nhds
  have hinf : (⨅ m : ℕ, (Real.log (stirlingSeq (n + m)) + 1 / 12 * (1 / (n : ℝ))))
      = Real.log (Real.sqrt Real.pi) + 1 / 12 * (1 / (n : ℝ)) :=
    iInf_eq_of_forall_le_of_tendsto (a := Real.log (Real.sqrt Real.pi) + 1 / 12 * (1 / (n : ℝ)))
      hle2 hlim
  calc Real.log (stirlingSeq n)
      ≤ ⨅ m : ℕ, (Real.log (stirlingSeq (n + m)) + 1 / 12 * (1 / (n : ℝ))) := le_ciInf hle1
    _ = Real.log (Real.sqrt Real.pi) + 1 / 12 * (1 / (n : ℝ)) := hinf
    _ = Real.log (Real.sqrt Real.pi) + 1 / (12 * (n : ℝ)) := by
        have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn
        field_simp

/-- **O1.T12 step 2, first brick.**  The explicit sharp Stirling upper bound in factorial form. -/
theorem log_factorial_le_stirling {n : ℕ} (hn : n ≠ 0) :
    Real.log (n.factorial : ℝ)
      ≤ n * Real.log n - n + 1 / 2 * Real.log (2 * Real.pi * n) + 1 / (12 * n) := by
  have hnR : (0 : ℝ) < (n : ℝ) := Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn)
  have hne : (n : ℝ) ≠ 0 := ne_of_gt hnR
  have hform := log_stirlingSeq_formula n
  have hbound := log_stirlingSeq_le_log_sqrt_pi_add hn
  have hlog : Real.log ((n : ℝ) / Real.exp 1) = Real.log n - 1 := by
    rw [Real.log_div hne (Real.exp_ne_zero 1), Real.log_exp]
  have hsqrt : Real.log (Real.sqrt Real.pi) = Real.log Real.pi / 2 := Real.log_sqrt Real.pi_pos.le
  have hmul : Real.log (2 * Real.pi * n) = Real.log (2 * n) + Real.log Real.pi := by
    rw [show (2 : ℝ) * Real.pi * n = (2 * n) * Real.pi by ring]
    rw [Real.log_mul (by positivity) Real.pi_ne_zero]
  have h1 : Real.log (n.factorial : ℝ)
      = Real.log (stirlingSeq n) + 1 / 2 * Real.log (2 * n)
        + (n : ℝ) * Real.log ((n : ℝ) / Real.exp 1) := by
    linarith [hform]
  rw [h1, hlog, hmul]
  rw [hsqrt] at hbound
  have hpos : (0 : ℝ) ≤ 1 / (12 * (n : ℝ)) := by positivity
  nlinarith [hbound]

/-- **O1.T12 step 2b, bridging brick.**  The two spellings of `‖s + j‖` agree (journals 380-381): this is
what lets the log identity's sum be normalised to the product's elaborated spelling. -/
theorem log_norm_complex_add_nat (s : ℂ) (j : ℕ) :
    Real.log ‖s + j‖ = Real.log (Real.sqrt ((s.re + j) ^ 2 + s.im ^ 2)) := by
  congr 1
  rw [Complex.norm_def, Complex.normSq_apply]
  simp only [Complex.add_re, Complex.add_im, Complex.natCast_re, Complex.natCast_im, Complex.ofReal_re,
    Complex.ofReal_im, add_zero]
  ring_nf

/-- **O1.T12 step 2b bridging brick (product form).**  Normalises the product's spelling to `‖s + j‖`,
which is what the `log_div`/`log_prod` patterns require (journals 383-385). -/
theorem prod_norm_eq_prod_sqrt {s : ℂ} (hs : 0 < s.re) (n : ℕ) :
    (∏ j ∈ Finset.range (n + 1), Real.sqrt ((s.re + j) ^ 2 + s.im ^ 2))
      = ∏ j ∈ Finset.range (n + 1), ‖s + j‖ := by
  refine Finset.prod_congr rfl fun j _ => ?_
  have hne : (s + j) ≠ 0 := by
    intro h
    have h2 := congrArg Complex.re h
    simp only [Complex.add_re, Complex.natCast_re, Complex.zero_re] at h2
    have : (0 : ℝ) < s.re + j := by positivity
    linarith
  have hpos : (0 : ℝ) < ‖s + j‖ := norm_pos_iff.mpr hne
  have hnorm : ‖s + j‖ = Real.sqrt ((s.re + j) ^ 2 + s.im ^ 2) := by
    rw [Complex.norm_def, Complex.normSq_apply]
    simp only [Complex.add_re, Complex.add_im, Complex.natCast_re, Complex.natCast_im, add_zero, pow_two]
  rw [hnorm] at hpos
  exact Real.log_injOn_pos hpos (norm_pos_iff.mpr hne) (log_norm_complex_add_nat s j).symm

/-- **O1.T12 step 2b COMPLETE: the logarithm of the norm identity.**  Turns §349's norm identity into the
additive form the landed bounds consume. -/
theorem log_norm_GammaSeq {s : ℂ} {n : ℕ} (hn : n ≠ 0) (hs : 0 < s.re) :
    Real.log ‖Complex.GammaSeq s n‖
      = s.re * Real.log n + Real.log (n.factorial : ℝ)
        - ∑ j ∈ Finset.range (n + 1), Real.log ‖s + j‖ := by
  have hne (j : ℕ) : (s + j) ≠ 0 := by
    intro h
    have h2 := congrArg Complex.re h
    simp only [Complex.add_re, Complex.natCast_re, Complex.zero_re] at h2
    have : (0 : ℝ) < s.re + j := by
      have : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
      linarith
    linarith
  have hfac : (0 : ℝ) < (n.factorial : ℝ) := by positivity
  have hprod : (0 : ℝ) < ∏ j ∈ Finset.range (n + 1), ‖s + j‖ :=
    Finset.prod_pos fun j _ => norm_pos_iff.mpr (hne j)
  rw [norm_GammaSeq_eq hn, prod_norm_eq_prod_sqrt hs n]
  rw [Real.log_div (by positivity) (ne_of_gt hprod),
      Real.log_mul (by positivity) (ne_of_gt hfac),
      Real.log_rpow (Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn)),
      Real.log_prod (fun j _ => ne_of_gt (norm_pos_iff.mpr (hne j)))]

/-- **O1.T12 assembly sub-brick (i).**  Proved by INDUCTION to avoid the index-coercion reindexing that
three direct fixes failed on (journal 390). -/
theorem sum_range_eq_sum_Ico_add (s : ℂ) : ∀ n : ℕ,
    (∑ j ∈ Finset.range (n + 1), Real.log ‖s + j‖)
      = (∑ j ∈ Finset.Ico 1 (n + 1), Real.log ‖s + j‖) + Real.log ‖s‖
  | 0 => by simp
  | n + 1 => by
      rw [Finset.sum_range_succ, Finset.sum_Ico_succ_top (by omega : 1 ≤ n + 1)]
      rw [sum_range_eq_sum_Ico_add s n]
      ring

/-- **O1.T12 assembly (ii), steps 1-5: the combined log bound.** -/
theorem log_norm_GammaSeq_le (s : ℂ) (hs : 0 < s.re) (ht : 0 < s.im) {n : ℕ} (hn : n ≠ 0) :
    Real.log ‖Complex.GammaSeq s n‖
      ≤ s.re * Real.log n
        + (n * Real.log n - n + 1 / 2 * Real.log (2 * Real.pi * n) + 1 / (12 * n))
        - (∫ x in (0 : ℝ)..(n : ℝ), Real.log (Real.sqrt ((s.re + x) ^ 2 + s.im ^ 2)))
        - Real.log ‖s‖ := by
  have h1 := log_norm_GammaSeq (s := s) hn hs
  have h2 := log_factorial_le_stirling hn
  have h3 := sum_range_eq_sum_Ico_add s n
  have h4 := integral_le_sum_Ico_logSqrt (σ := s.re) (t := s.im) hs ht n
  have h5 : (∑ k ∈ Finset.Ico 1 (n + 1), Real.log (Real.sqrt ((s.re + k) ^ 2 + s.im ^ 2)))
      = ∑ k ∈ Finset.Ico 1 (n + 1), Real.log ‖s + k‖ :=
    Finset.sum_congr rfl fun k _ => (log_norm_complex_add_nat s k).symm
  rw [h5] at h4
  calc Real.log ‖Complex.GammaSeq s n‖
      = s.re * Real.log n + Real.log (n.factorial : ℝ)
          - ((∑ k ∈ Finset.Ico 1 (n + 1), Real.log ‖s + k‖) + Real.log ‖s‖) := by
        rw [h1, h3]
    _ ≤ s.re * Real.log n
          + (n * Real.log n - n + 1 / 2 * Real.log (2 * Real.pi * n) + 1 / (12 * n))
          - ((∑ k ∈ Finset.Ico 1 (n + 1), Real.log ‖s + k‖) + Real.log ‖s‖) := by
        gcongr
    _ ≤ s.re * Real.log n
          + (n * Real.log n - n + 1 / 2 * Real.log (2 * Real.pi * n) + 1 / (12 * n))
          - ((∫ x in (0 : ℝ)..(n : ℝ), Real.log (Real.sqrt ((s.re + x) ^ 2 + s.im ^ 2)))
              + Real.log ‖s‖) := by
        gcongr
    _ = s.re * Real.log n
          + (n * Real.log n - n + 1 / 2 * Real.log (2 * Real.pi * n) + 1 / (12 * n))
          - (∫ x in (0 : ℝ)..(n : ℝ), Real.log (Real.sqrt ((s.re + x) ^ 2 + s.im ^ 2)))
        - Real.log ‖s‖ := by
        ring

theorem arctan_le_pi_div_two (x : ℝ) : Real.arctan x ≤ Real.pi / 2 :=
  le_of_lt (Real.arctan_lt_pi_div_two x)

/-- **O1.T12 step 6(b) ingredient: the log-in-n bound.**  `log n ≤ n` for `n ≥ 1`, from Mathlib's
`log x ≤ x − 1`. -/
theorem log_natCast_le_self {n : ℕ} (hn : 1 ≤ n) : Real.log (n : ℝ) ≤ (n : ℝ) := by
  have h := Real.log_le_sub_one_of_pos (show (0 : ℝ) < (n : ℝ) by exact_mod_cast hn)
  linarith

/-- **O1.T12 step 6(b), the n log n cancellation** (journal 409 term (i)): `n log n ≤ n log(σ + n)` for
`n ≥ 1` and `σ > 0`, which is what lets the `n log n` from Stirling cancel against the closed form. -/
theorem mul_log_le_mul_log_add {n : ℕ} {σ : ℝ} (hn : 1 ≤ n) (hσ : 0 < σ) :
    (n : ℝ) * Real.log (n : ℝ) ≤ (n : ℝ) * Real.log (σ + (n : ℝ)) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have hle : (n : ℝ) ≤ σ + (n : ℝ) := by linarith
  have := Real.log_le_log hnpos hle
  exact mul_le_mul_of_nonneg_left this (le_of_lt hnpos)

/-- **O1.T12 step 6(b), the arctan cancellation** (journal 409 term (iv)): `arctan(σ/t) ≤ arctan((σ+n)/t)`
for `t > 0`, which is what lets the `−t·arctan((σ+n)/t)` from the closed form be bounded by the `n`-free
`−t·arctan(σ/t)`. -/
theorem arctan_div_le_arctan_add_div (σ t : ℝ) (ht : 0 < t) (n : ℕ) :
    Real.arctan (σ / t) ≤ Real.arctan ((σ + n) / t) := by
  refine Real.arctan_mono ?_
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  exact div_le_div_of_nonneg_right (by linarith) (le_of_lt ht)

/-- **O1.T12 step 6(b), the sigma log n cancellation** (journal 409 term (ii)): `σ log n ≤ σ log(σ + n)`
for `n ≥ 1` and `σ > 0`. -/
theorem mul_log_le_mul_log_add_left {n : ℕ} {σ : ℝ} (hn : 1 ≤ n) (hσ : 0 < σ) :
    σ * Real.log (n : ℝ) ≤ σ * Real.log (σ + (n : ℝ)) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have hle : (n : ℝ) ≤ σ + (n : ℝ) := by linarith
  exact mul_le_mul_of_nonneg_left (Real.log_le_log hnpos hle) (le_of_lt hσ)

/-- **O1.T12 step 6(b), cancellation (v)** (journal 409): the `log(2πn)` term is dominated by `2πn`, so it
is absorbed by the `−n log n` growth once `n` is large -- and it is `n`-free in the exponent's constant. -/
theorem log_two_pi_mul_le_self (n : ℕ) (hn : 1 ≤ n) :
    Real.log (2 * Real.pi * (n : ℝ)) ≤ 2 * Real.pi * (n : ℝ) := by
  have hpos : (0 : ℝ) < 2 * Real.pi * (n : ℝ) := by
    have : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
    positivity
  have h := Real.log_le_sub_one_of_pos hpos
  linarith

/-- **O1.T12 step 6(a): the assembled bound, exponentiated.**  `Real.le_exp_of_log_le` needs no
positivity assumption, so it handles `‖GammaSeq s n‖ = 0` too. -/
theorem norm_GammaSeq_le_exp (s : ℂ) (hs : 0 < s.re) (ht : 0 < s.im) {n : ℕ} (hn : n ≠ 0) :
    ‖Complex.GammaSeq s n‖ ≤ Real.exp (s.re * Real.log n
      + (n * Real.log n - n + 1 / 2 * Real.log (2 * Real.pi * n) + 1 / (12 * n))
      - (∫ x in (0 : ℝ)..(n : ℝ), Real.log (Real.sqrt ((s.re + x) ^ 2 + s.im ^ 2)))
      - Real.log ‖s‖) :=
  Real.le_exp_of_log_le (log_norm_GammaSeq_le s hs ht hn)

/-- **O1.T12 step 6(c), the spelling bridge** (journal 417): `log √x = (1/2) log x`, which reconciles
journal-338's `(1/2)·log` integral integrand with the `log √` form used in the assembled exponent. -/
theorem log_sqrt_eq_half_mul_log {x : ℝ} (hx : 0 ≤ x) :
    Real.log (Real.sqrt x) = 1 / 2 * Real.log x := by
  rw [Real.log_sqrt hx]
  ring

/-- **O1.T12 step 6(c1) brick: the integral in the exponent's spelling.**  Packages journal-338's
closed form with the journal-418 bridge, so the assembled exponent can substitute it directly. -/
theorem integral_logSqrt_eq (s : ℂ) (ht : 0 < s.im) (n : ℝ) :
    (∫ x in (0 : ℝ)..n, Real.log (Real.sqrt ((s.re + x) ^ 2 + s.im ^ 2)))
      = (1 / 2) * ((s.re + n) * Real.log ((s.re + n) ^ 2 + s.im ^ 2) - 2 * (s.re + n)
            + 2 * s.im * Real.arctan ((s.re + n) / s.im))
        - (1 / 2) * (s.re * Real.log (s.re ^ 2 + s.im ^ 2) - 2 * s.re
            + 2 * s.im * Real.arctan (s.re / s.im)) := by
  rw [← intervalIntegral_logSqrt_eq (σ := s.re) (t := s.im) ht (n := n)]
  refine intervalIntegral.integral_congr fun x _ => ?_
  rw [log_sqrt_eq_half_mul_log (by positivity)]

/-- **O1.T12 step 6(c1) ingredient.**  `2 log(σ+n) ≤ log((σ+n)² + t²)`, the inequality that lets the
`n log n` and `σ log n` cancellations act on the terms already present in the exponent, without expanding
the closed form `F`. -/
theorem two_mul_log_le_log_sq_add (σ t : ℝ) (n : ℕ) (h : 0 < σ + n) :
    2 * Real.log (σ + n) ≤ Real.log ((σ + n) ^ 2 + t ^ 2) := by
  have hle : (σ + n) ^ 2 ≤ (σ + n) ^ 2 + t ^ 2 := by nlinarith [sq_nonneg t]
  have hpos : (0 : ℝ) < (σ + n) ^ 2 := by positivity
  have h1 : Real.log ((σ + n) ^ 2) ≤ Real.log ((σ + n) ^ 2 + t ^ 2) :=
    Real.log_le_log hpos hle
  rwa [Real.log_pow] at h1
  -- hmm: log_pow gives log (x^n) = n * log x for nat exponent

/-- **O1.T12 step 6(c1) calc-step.**  Statement corrected in journal 440, side conditions in 441. -/
theorem n_log_cancel {σ t : ℝ} (ht : 0 < t) (hσ : 0 < σ) {n : ℕ} (hn : 1 ≤ n) (h : 0 < σ + n) :
    (n : ℝ) * Real.log n - n + (σ + n) - 1 / 2 * (σ + n) * Real.log ((σ + n) ^ 2 + t ^ 2) ≤ σ := by
  have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have h433 := two_mul_log_le_log_sq_add σ t n h
  have h411 := mul_log_le_mul_log_add (σ := σ) hn hσ
  have hL0 : (0 : ℝ) ≤ Real.log (σ + n) := Real.log_nonneg (by linarith)
  have h1 : (n : ℝ) * Real.log (σ + n) ≤ (σ + n) * Real.log (σ + n) :=
    mul_le_mul_of_nonneg_right (by linarith) hL0
  have h2 : (σ + n) * Real.log (σ + n) ≤ 1 / 2 * (σ + n) * Real.log ((σ + n) ^ 2 + t ^ 2) := by
    have := mul_le_mul_of_nonneg_left h433 (by linarith : (0 : ℝ) ≤ σ + n)
    linarith
  linarith [h411, h1, h2]

/-- **O1.T12 step 6(c1) calc-step: the arctan cancellation.**  `-t·arctan((σ+n)/t) ≤ -t·arctan(σ/t)` for
`t > 0`, which is what makes the arctan term `n`-free. -/
theorem arctan_cancel {σ t : ℝ} (ht : 0 < t) (n : ℕ) :
    -t * Real.arctan ((σ + n) / t) ≤ -t * Real.arctan (σ / t) := by
  have h := arctan_div_le_arctan_add_div σ t ht n
  nlinarith [ht, h]

/-- **O1.T12 step 6(c1): the combined sigma-log group** (journal 455).  The three terms that must be
bounded TOGETHER, because two of them point the wrong way individually:
`σ log n − ½σ log((σ+n)²+t²) + ½σ log(σ²+t²) ≤ ½σ log(σ²+t²)`. -/
theorem sigma_log_group_le {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) {n : ℕ} (hn : 1 ≤ n) :
    σ * Real.log n - 1 / 2 * σ * Real.log ((σ + n) ^ 2 + t ^ 2)
      + 1 / 2 * σ * Real.log (σ ^ 2 + t ^ 2)
    ≤ 1 / 2 * σ * Real.log (σ ^ 2 + t ^ 2) := by
  have hn0 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hn)
  have h1 : Real.log n ≤ Real.log (σ + n) := Real.log_le_log hn0 (by linarith)
  have h433 := two_mul_log_le_log_sq_add σ t n (by linarith : 0 < σ + n)
  have : Real.log n ≤ 1 / 2 * Real.log ((σ + n) ^ 2 + t ^ 2) := by linarith
  nlinarith [hσ, this]

/-- **O1.T12 step 6(c1) key intermediate** (journal 467). -/
theorem n_log_absorb {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) {n : ℕ} (hn : 1 ≤ n)
    (he : Real.exp 1 ≤ σ + n) :
    (n : ℝ) * Real.log n - 1 / 2 * (σ + n) * Real.log ((σ + n) ^ 2 + t ^ 2) + σ ≤ 0 := by
  have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hn0 : (0 : ℝ) < (n : ℝ) := by linarith
  have hσn : (0 : ℝ) < σ + n := by linarith
  -- log(sigma+n) >= 1
  have hlog1 : (1 : ℝ) ≤ Real.log (σ + n) := by
    rw [Real.le_log_iff_exp_le hσn]; exact he
  -- log n <= log(sigma+n)
  have hlogn : Real.log n ≤ Real.log (σ + n) := Real.log_le_log hn0 (by linarith)
  -- log((sigma+n)^2+t^2) >= 2 log(sigma+n)
  have h433 := two_mul_log_le_log_sq_add σ t n hσn
  -- n log n <= n log(sigma+n) and n log(sigma+n) <= (sigma+n) log(sigma+n)
  have h1 : (n : ℝ) * Real.log n ≤ (n : ℝ) * Real.log (σ + n) :=
    mul_le_mul_of_nonneg_left hlogn (Nat.cast_nonneg n)
  have h2 : (n : ℝ) * Real.log (σ + n) ≤ (σ + n) * Real.log (σ + n) :=
    mul_le_mul_of_nonneg_right (by linarith) (Real.log_nonneg (by linarith))
  have h3 : σ ≤ σ * Real.log (σ + n) := by nlinarith [hσ, hlog1]
  nlinarith [h1, h2, h3, h433, hσn, sq_nonneg t]

/-- **O1.T12 step 6(c1)**: the log-variant of `n_log_absorb` (journal 478; probed true journal 479). -/
theorem n_log_absorb_log {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) {n : ℕ} (hn : 1 ≤ n)
    (he : Real.exp 1 ≤ σ + n) :
    (n : ℝ) * Real.log n - 1 / 2 * (σ + n) * Real.log ((σ + n) ^ 2 + t ^ 2)
      + σ * Real.log n ≤ 0 := by
  have hn0 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hn)
  have hσn : (0 : ℝ) < σ + n := by linarith
  have hnle : (n : ℝ) ≤ σ + n := le_add_of_nonneg_left hσ.le
  have hlog1 : (1 : ℝ) ≤ Real.log (σ + n) := by
    rw [Real.le_log_iff_exp_le hσn]; exact he
  have hlogpos : (0 : ℝ) ≤ Real.log (σ + n) := by linarith
  have hlogn : Real.log n ≤ Real.log (σ + n) := Real.log_le_log hn0 (by linarith)
  have h2 : (n : ℝ) * Real.log n ≤ (n : ℝ) * Real.log (σ + n) :=
    mul_le_mul_of_nonneg_left hlogn (Nat.cast_nonneg n)
  have h3 : (n : ℝ) * Real.log (σ + n) ≤ (σ + n) * Real.log (σ + n) :=
    mul_le_mul_of_nonneg_right hnle hlogpos
  have hstep : (n : ℝ) * Real.log n ≤ (σ + n) * Real.log (σ + n) := le_trans h2 h3
  have h413 := mul_log_le_mul_log_add (σ := σ) hn hσ
  have h433 := two_mul_log_le_log_sq_add σ t n hσn
  have hself : (σ + n) * Real.log (σ + n)
      ≤ 1 / 2 * (σ + n) * Real.log ((σ + n) ^ 2 + t ^ 2) := by
    have := mul_le_mul_of_nonneg_left h433 (by linarith : (0 : ℝ) ≤ σ + n)
    linarith
  nlinarith [hstep, h413, hself, hσ, hσn, ht]

/-- **O1.T12 (re-aimed product-sum route)**: every factor `‖s + j‖ ≥ |s.im|`, so the product sum is at least
`(n+1)·log|t|`.  First brick of the re-aimed route (journals 490-491, 494-497). -/
theorem sum_log_norm_add_ge {s : ℂ} (ht : 0 < s.im) (n : ℕ) :
    ((n + 1 : ℕ) : ℝ) * Real.log s.im
      ≤ ∑ j ∈ Finset.range (n + 1), Real.log ‖s + (j : ℂ)‖ := by
  have hterm : ∀ j : ℕ, Real.log s.im ≤ Real.log ‖s + (j : ℂ)‖ := by
    intro j
    apply Real.log_le_log ht
    rw [Complex.norm_def, Complex.normSq_apply]
    simp only [Complex.add_re, Complex.add_im, Complex.ofReal_re, Complex.ofReal_im, add_zero,
      Complex.natCast_re, Complex.natCast_im]
    exact Real.le_sqrt_of_sq_le (by nlinarith [sq_nonneg (s.re + (j : ℝ))])
  calc ((n + 1 : ℕ) : ℝ) * Real.log s.im
      = ∑ _j ∈ Finset.range (n + 1), Real.log s.im := by
        rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
    _ ≤ ∑ j ∈ Finset.range (n + 1), Real.log ‖s + (j : ℂ)‖ :=
        Finset.sum_le_sum (fun j _ => hterm j)

/-- **O1.T12 (re-aimed product-sum route)**: the companion UPPER bound (journal 505, route 1 inlined). -/
theorem log_norm_add_le {s : ℂ} (hs : 0 ≤ s.re) (ht : 0 < s.im) (j : ℕ) :
    Real.log ‖s + (j : ℂ)‖ ≤ Real.log (s.re + (j : ℝ) + |s.im|) := by
  have harg : (0 : ℝ) ≤ s.re + (j : ℝ) + |s.im| := by
    have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    nlinarith [abs_nonneg s.im, hs, hj]
  rw [Complex.norm_def, Complex.normSq_apply]
  simp only [Complex.add_re, Complex.add_im, Complex.ofReal_re, Complex.ofReal_im, add_zero,
    Complex.natCast_re, Complex.natCast_im]
  exact Real.log_le_log
    (Real.sqrt_pos.2 (by nlinarith [sq_nonneg (s.re + (j : ℝ)), ht]))
    (Real.sqrt_le_iff.2 ⟨harg, by nlinarith [sq_abs s.im, sq_nonneg (s.re + (j : ℝ)), abs_nonneg s.im]⟩)

/-- **O1.T12 (re-aimed product-sum route)**: the sum-level upper bound, `Finset.sum_le_sum` of journal-506's
pointwise brick.  With journal-498's lower bound this brackets the product sum. -/
theorem sum_log_norm_add_le {s : ℂ} (hs : 0 ≤ s.re) (ht : 0 < s.im) (n : ℕ) :
    ∑ j ∈ Finset.range (n + 1), Real.log ‖s + (j : ℂ)‖
      ≤ ∑ j ∈ Finset.range (n + 1), Real.log (s.re + (j : ℝ) + |s.im|) :=
  Finset.sum_le_sum (fun j _ => log_norm_add_le hs ht j)

/-- **O1.T12 (re-aimed product-sum route)**: the SHARP lower bound, `log(s.re + j) ≤ log‖s + j‖`, matching
journal-507's upper branch.  Hypothesis strengthened to `0 < s.re` per journal 510, which makes the
degenerate case `s.re + j = 0` impossible and the case split unnecessary. -/
theorem sum_log_le_sum_log_norm {s : ℂ} (hs : 0 < s.re) (j : ℕ) :
    Real.log (s.re + (j : ℝ)) ≤ Real.log ‖s + (j : ℂ)‖ := by
  have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
  apply Real.log_le_log (by linarith)
  rw [Complex.norm_def, Complex.normSq_apply]
  simp only [Complex.add_re, Complex.add_im, Complex.ofReal_re, Complex.ofReal_im, add_zero,
    Complex.natCast_re, Complex.natCast_im]
  exact Real.le_sqrt_of_sq_le (by nlinarith [sq_nonneg (s.im : ℝ)])

/-- **O1.T12 (re-aimed product-sum route)**: the sum-level sharp lower bound, `Finset.sum_le_sum` of
journal-511's pointwise brick.  With journal-507 this brackets `Σ log‖s+j‖` between `Σ log(s.re+j)` and
`Σ log(s.re+j+|s.im|)`, whence the rate's `π/2` enters through `Γ(s.re+n+1)/Γ(s.re)`. -/
theorem sum_log_norm_ge {s : ℂ} (hs : 0 < s.re) (n : ℕ) :
    ∑ j ∈ Finset.range (n + 1), Real.log (s.re + (j : ℝ))
      ≤ ∑ j ∈ Finset.range (n + 1), Real.log ‖s + (j : ℂ)‖ :=
  Finset.sum_le_sum (fun j _ => sum_log_le_sum_log_norm hs j)

/-- **O1.T12 (corrected target, journal 516)**: `log‖GammaSeq s n‖ → log‖Γ s‖` — the logarithm of Mathlib's
`Complex.GammaSeq_tendsto_Gamma` composed with continuity.  No `σ log n` subtraction. -/
theorem tendsto_log_norm_GammaSeq (s : ℂ) (h : ∀ m : ℕ, s ≠ -(m : ℂ)) :
    Tendsto (fun n : ℕ => Real.log ‖Complex.GammaSeq s n‖) atTop
      (𝓝 (Real.log ‖Complex.Gamma s‖)) := by
  have hlim : Tendsto (fun n : ℕ => Complex.GammaSeq s n) atTop (𝓝 (Complex.Gamma s)) :=
    Complex.GammaSeq_tendsto_Gamma s
  have hnorm : Tendsto (fun n : ℕ => ‖Complex.GammaSeq s n‖) atTop (𝓝 ‖Complex.Gamma s‖) :=
    (continuous_norm.tendsto _).comp hlim
  have hpos : 0 < ‖Complex.Gamma s‖ := norm_pos_iff.mpr (Complex.Gamma_ne_zero h)
  exact (Real.continuousAt_log hpos.ne').tendsto.comp hnorm

/-- **O1.T12 (final bound, first brick)**: the size bound on `GammaSeq`. -/
theorem log_norm_GammaSeq_le_sum {s : ℂ} (hs : 0 < s.re) (ht : 0 < s.im) {n : ℕ} (hn : n ≠ 0) :
    Real.log ‖Complex.GammaSeq s n‖
      ≤ s.re * Real.log n + Real.log (n.factorial)
        - ((n + 1 : ℕ) : ℝ) * Real.log s.im := by
  rw [RouteABC.log_norm_GammaSeq (s := s) (n := n) hn hs]
  have h := RouteABC.sum_log_norm_add_ge (s := s) ht n
  linarith [h]
end

end RouteABC
