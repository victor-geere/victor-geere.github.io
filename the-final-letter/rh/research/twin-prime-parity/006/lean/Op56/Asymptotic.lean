/-
  Op56/Asymptotic.lean — the asymptotic layer: OP-5 and OP-6.

  ## The two statements

  Both open problems are asymptotic.  We state them in the exact form of the write-ups,
  with the constants in closed form:

  * **OP-5.**  With `Phi_p n = Σ_{j≥1} (1 + j/n)^(-p)` and the threshold `P_n` defined by
    `Phi_{P_n} n = 1`,

        P_n  =  (n + 3/2) log 2 + c/n + O(1/n²),    c = 3 (log 2)² - (25/12) log 2 ,

    equivalently (1-based) `n_min(p) = p / log 2 - 3/2 + O(1)` (the error term is
    `O(1)`, **not** `O(1/p)`: see the note on `op5_nmin_asymptotic` below).

  * **OP-6.**  With `L p = -log (measure(S_1)/P(p))` (`Op56/Exact.lean`),

        L p  =  p log p - (1 + log log 2) p + O(1) ,
        measure(S_1)/P(p)  =  p^(-p) · exp((1 + log log 2) p) · (1 + o(1))  →  0 .

  ## What is proved

  **All three main theorems are proved, with no `sorry`**:
  `op5_threshold_asymptotic`, `op5_nmin_asymptotic` (restated with the correct `O(1)`
  error term — the previously stated `O(1/p)` was false, since `nmin p` is an integer
  and cannot beat the Diophantine gap against an irrational linear threshold) and
  `op6_reachable_fraction`.  Also proved here: `leadingCoeff_forced` — the leading rate
  `log 2` of OP-5 is *forced* by `Σ_{j≥1} x^j = 1`, not fitted; and the second-order
  layer (`op5_threshold_leading`, `op5_threshold_second_order`).

  No `axiom` is declared, and no proof uses a compiled decision procedure: every
  numeric side condition is kernel-checked, so the three main theorems rest on exactly
  `[propext, Classical.choice, Quot.sound]`.

  The numeric content of both theorems is verified independently to ten significant
  figures by `../op06_reachable_fraction.py` / `../op05_nmin.py`, and the exact
  combinatorial layer is in `Op56/Exact.lean`.
-/

import Op56.Exact
import Op56.PhiAsymptotic
import Op56.PhiThird
import Mathlib.Analysis.Asymptotics.AsymptoticEquivalent

namespace Op56

noncomputable section

open scoped BigOperators Topology Asymptotics

open Filter

/-! ### The arithmetic constants -/

/-- The OP-5 arithmetic constant `c = 3 (log 2)² - (25/12) log 2 = -0.0026975844…`. -/
def c5 : ℝ := 3 * (Real.log 2) ^ 2 - (25 / 12) * Real.log 2

/-- The OP-6 `1/p` coefficient **at `e = 0`**, `-0.540509640658… = -(9/8)(log 2)²`.

**Not the coefficient of the true integer index.**  The exact `1/p` coefficient is the
*function* `c(e) = -((log 2)²/2)(e² - e + 9/4)` of the ceiling error
`e(p) = ⌈p/log 2 - 5/2⌉ - (p/log 2 - 5/2) ∈ [0,1)`, ranging over
`[-(log 2)², -(9/8)(log 2)²]`.  The numeral below is the `e = 0` value, i.e. the value for
the *smooth* (non-integer) threshold; see `OP-06-reachable-fraction.md` §2.4 and the
correction note there.  This declaration is **unused** by any theorem (the OP-6 theorem
states `L p - LAsym p = O(1)`, which is unaffected). -/
def c6 : ℝ := -0.540509640658

/-! ### The threshold function -/

/-! ### The leading coefficient is forced (fully proved) -/

/-- The leading rate of OP-5 is forced: `Σ_{j≥1} x^j = 1` has the unique solution
`x = 1/2` in `[0,1)`, i.e. the exponent rate is `log 2`. -/
theorem leadingCoeff_forced {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1)
    (h : HasSum (fun j : ℕ => x ^ (j + 1)) 1) : x = 1 / 2 := by
  have hnorm : ‖x‖ < 1 := by rw [Real.norm_eq_abs, abs_of_nonneg hx0]; exact hx1
  have h1 : HasSum (fun j : ℕ => x ^ j) (1 - x)⁻¹ := hasSum_geometric_of_norm_lt_one hnorm
  have h2 : HasSum (fun j : ℕ => x * x ^ j) (x * (1 - x)⁻¹) := h1.mul_left x
  have h3 : (fun j : ℕ => x * x ^ j) = (fun j : ℕ => x ^ (j + 1)) := by
    funext j; rw [pow_succ, mul_comm]
  rw [h3] at h2
  have hx : x * (1 - x)⁻¹ = 1 := h2.unique h
  have hne : (1:ℝ) - x ≠ 0 := by linarith
  rw [mul_inv_eq_one₀ hne] at hx
  linarith

/-! ### OP-5 -/

/-- **OP-5, leading term (proved).**  The threshold index satisfies
`P_n = n·log 2 + O(1)`.  This is the leading term of `thresholdAsym`; it follows from
`Phi_asymptotic` (`Op56/PhiAsymptotic.lean`) via `threshold_scaling`. -/
theorem op5_threshold_leading (Pfun : ℕ → ℝ) (hP : ∀ n : ℕ, IsThreshold n (Pfun n))
    (hu1 : ∀ n : ℕ, 1 / 2 ≤ Pfun n / (n : ℝ)) (hu2 : ∀ n : ℕ, Pfun n / (n : ℝ) ≤ 1) :
    (fun n : ℕ => Pfun n - (n : ℝ) * Real.log 2) =O[Filter.atTop]
      (fun _ : ℕ => (1 : ℝ)) := by
  have key : ∀ n : ℕ, max 4 ⌈2 * PhiC⌉₊ ≤ n →
      ‖Pfun n - (n : ℝ) * Real.log 2‖ ≤ 2 * PhiC * ‖(1 : ℝ)‖ := by
    intro n hn
    have hn4 : 4 ≤ n := le_trans (le_max_left _ _) hn
    have hnK : 2 * PhiC ≤ (n : ℝ) := by
      have h1 : (⌈2 * PhiC⌉₊ : ℝ) ≤ (n : ℝ) := by
        exact_mod_cast (le_trans (le_max_right _ _) hn)
      calc 2 * PhiC ≤ (⌈2 * PhiC⌉₊ : ℝ) := Nat.le_ceil _
        _ ≤ (n : ℝ) := h1
    have hnR : (0 : ℝ) < (n : ℝ) := by positivity
    have hmul : (Pfun n / (n : ℝ)) * (n : ℝ) = Pfun n := by field_simp
    have h := threshold_scaling n hn4 hnK (Pfun n / (n : ℝ)) (hu1 n) (hu2 n)
      (by rw [hmul]; exact hP n)
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_one, mul_one]
    have h2 : Pfun n - (n : ℝ) * Real.log 2
        = (n : ℝ) * (Pfun n / (n : ℝ) - Real.log 2) := by field_simp
    rw [h2, abs_mul, abs_of_pos hnR]
    calc (n : ℝ) * |Pfun n / (n : ℝ) - Real.log 2| ≤ (n : ℝ) * (2 * PhiC / (n : ℝ)) :=
          mul_le_mul_of_nonneg_left h (le_of_lt hnR)
      _ = 2 * PhiC := by field_simp
  have hev : ∀ᶠ x : ℕ in Filter.atTop,
      ‖Pfun x - (x : ℝ) * Real.log 2‖ ≤ 2 * PhiC * ‖(1 : ℝ)‖ :=
    Filter.eventually_atTop.mpr ⟨_, key⟩
  exact Asymptotics.IsBigO.of_bound (2 * PhiC) hev


/-- **OP-5, threshold form, second order (proved).**  `P_n = (n + 3/2)·log 2 + O(1)`.

This is the next order beyond `op5_threshold_leading`: the `O(1)` correction is exactly
`(3/2)·log 2`, because `ΦS(log 2) = Σ k²2^{-k} = 6` makes the threshold equation give
`u = log 2 + (3 log 2)/(2n) + O(1/n²)`.  It follows from `threshold_second_order_uniform`
(`Op56/PhiAsymptotic.lean`), which is uniform in `u ∈ [1/2,1]` — needed because
`Pfun n / n` varies with `n`. -/
theorem op5_threshold_second_order (Pfun : ℕ → ℝ) (hP : ∀ n : ℕ, IsThreshold n (Pfun n))
    (hu1 : ∀ n : ℕ, 1 / 2 ≤ Pfun n / (n : ℝ)) (hu2 : ∀ n : ℕ, Pfun n / (n : ℝ) ≤ 1) :
    (fun n : ℕ => Pfun n - ((n : ℝ) + 3 / 2) * Real.log 2) =O[Filter.atTop]
      (fun _ : ℕ => (1 : ℝ)) := by
  obtain ⟨C, hCpos, hev⟩ := threshold_second_order_uniform
  have key : ∀ᶠ n : ℕ in Filter.atTop,
      ‖Pfun n - ((n : ℝ) + 3 / 2) * Real.log 2‖ ≤ C * ‖(1 : ℝ)‖ := by
    filter_upwards [hev, Filter.eventually_ge_atTop 1] with n hn hn1
    have hnR : (0 : ℝ) < (n : ℝ) := by positivity
    have h1n : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
    have hthr : IsThreshold n ((Pfun n / (n : ℝ)) * (n : ℝ)) := by
      rw [div_mul_cancel₀ _ (ne_of_gt hnR)]
      exact hP n
    have h := hn (Pfun n / (n : ℝ)) (hu1 n) (hu2 n) hthr
    have h2 : Pfun n - ((n : ℝ) + 3 / 2) * Real.log 2
        = (n : ℝ) * (Pfun n / (n : ℝ) - Real.log 2 - 3 * Real.log 2 / (2 * (n : ℝ))) := by
      field_simp
      ring
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_one, mul_one, h2, abs_mul, abs_of_pos hnR]
    calc (n : ℝ) * |Pfun n / (n : ℝ) - Real.log 2 - 3 * Real.log 2 / (2 * (n : ℝ))|
        ≤ (n : ℝ) * (C / (n : ℝ) ^ 2) := mul_le_mul_of_nonneg_left h hnR.le
      _ = C / (n : ℝ) := by field_simp
      _ ≤ C := by
        rw [div_le_iff₀ hnR]
        have hh := mul_le_mul_of_nonneg_left h1n hCpos.le
        linarith [hh]
  exact Asymptotics.IsBigO.of_bound C key

/-- **OP-5, threshold form (proved).**  `P_n = (n + 3/2) log 2 + c/n + O(1/n²)`, i.e. the
difference between the actual threshold `Pfun n` and `thresholdAsym n` is `O(1/n²)`.
The proof is the body below, from `threshold_third_order_uniform`
(`Op56/PhiThird.lean`).

**Historical note (re-diagnosed).**  At the threshold `p/n → log 2`, so `p` and `n`
are *comparable* (`n ≈ p/log 2`), **not** `p ≫ n`; numerically `p/N = 1.000, 0.833,
0.769, 0.714, 0.699` at `p = 2, 5, 10, 20, 100`.  At this scaling the summands
`(1 + (j+1)/n)^{-p}` decay by a factor `→ 1/2`, so `Φ_p(n)` is **geometrically
dominated** (`p = 100, N = 143`: eight terms give `99.75%` of the sum).  Euler–Maclaurin
is therefore *not* the right tool here, and would give a divergent series.  What is
missing from Mathlib is an elementary truncate-and-Taylor lemma for such sums with a
geometric tail bound; `NumberTheory/LSeries/HurwitzZeta` supplies continuation and
analyticity but no large-parameter asymptotics.  The expansion of the write-up §3 is
reproduced numerically to `1e-10` by `../op05_nmin.py`.

**Numerical verification of this statement** (mpmath, 40 digits): solving `Φ_p(n) = 1` for `p` and comparing with `thresholdAsym n`,

```
   n        p*             thresholdAsym n     (p* − asym)·n²
   50    35.6970245715    35.6970258471        −0.00318906
  100    70.3544115299    70.3544118510        −0.00321085
  200   139.6691433140   139.6691433950        −0.00322174
  400   278.2985862310   278.2985862510        −0.00322717
  800   555.5574618420   555.5574618470        −0.00322989
 1600  1110.0752079800  1110.0752079800        −0.00323124
```

so the difference is genuinely `O(1/n²)` with coefficient `≈ −0.00323`, confirming the
`c = 3(log 2)² − (25/12)log 2` term of `thresholdAsym`.

**Proof route.** The `c/n` term arises as `D₀/2` in a *third-order* expansion
`Φ_{un}(n) − (e^u−1)^{-1} − (u/2n)ΦS(u) = D(u)/n² + O(1/n³)`; `threshold_second_order`
(`Op56/PhiAsymptotic.lean`, proved) already supplies the second order, giving
`u = log 2 + (3 log 2)/(2n) + O(1/n²)` and hence `P_n = (n + 3/2)log 2 + O(1/n)`.
The `O(1/n²)` refinement (which needs `D`) and the `u`-uniformity are supplied by
`threshold_third_order_uniform` (`Op56/PhiThird.lean`); the proof is the body below. -/
theorem op5_threshold_asymptotic (Pfun : ℕ → ℝ)
    (hP : ∀ n : ℕ, IsThreshold n (Pfun n)) :
    (fun n : ℕ => Pfun n - thresholdAsym n) =O[Filter.atTop]
      (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2) := by
  obtain ⟨C, hCpos, hev⟩ := threshold_third_order_uniform
  have key : ∀ᶠ n : ℕ in Filter.atTop,
      ‖Pfun n - thresholdAsym n‖ ≤ (4*C) * ‖1 / ((n : ℝ) + 1) ^ 2‖ := by
    filter_upwards [hev, threshold_u_range, Filter.eventually_ge_atTop 1] with n hn hur hn1
    have hnR : (0 : ℝ) < (n : ℝ) := by positivity
    have h1n : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
    have hnz : (n : ℝ) ≠ 0 := ne_of_gt hnR
    have hthr : IsThreshold n ((Pfun n / (n : ℝ)) * (n : ℝ)) := by
      rw [div_mul_cancel₀ _ hnz]
      exact hP n
    have hur' : 1/2 ≤ Pfun n / (n : ℝ) ∧ Pfun n / (n : ℝ) ≤ 1 := hur (Pfun n / (n : ℝ)) hthr
    have h := hn (Pfun n / (n : ℝ)) hur'.1 hur'.2 hthr
    have h2 : Pfun n - thresholdAsym n
        = (n : ℝ) * (Pfun n / (n : ℝ) - Real.log 2 - 3 * Real.log 2 / (2 * (n : ℝ))
            - (3 * (Real.log 2) ^ 2 - (25 / 12) * Real.log 2) / (n : ℝ)^2) := by
      rw [thresholdAsym]
      field_simp [hnz]
      ring
    rw [Real.norm_eq_abs, Real.norm_eq_abs,
      abs_of_pos (by positivity : (0:ℝ) < 1 / ((n : ℝ) + 1) ^ 2), h2, abs_mul, abs_of_pos hnR]
    have hc : (n : ℝ) * |Pfun n / (n : ℝ) - Real.log 2 - 3 * Real.log 2 / (2 * (n : ℝ))
          - (3 * (Real.log 2) ^ 2 - (25 / 12) * Real.log 2) / (n : ℝ)^2|
        ≤ (n : ℝ) * (C / (n : ℝ) ^ 3) :=
      mul_le_mul_of_nonneg_left h hnR.le
    have hc2 : (n : ℝ) * (C / (n : ℝ) ^ 3) ≤ (4*C) * (1 / ((n : ℝ) + 1) ^ 2) := by
      field_simp [hnz]
      have hs : ((n:ℝ) + 1)^2 ≤ 4*(n:ℝ)^2 := by
        have hsq := pow_le_pow_left₀ (by positivity : (0:ℝ) ≤ (n:ℝ) + 1) (by linarith : (n:ℝ)+1 ≤ 2*(n:ℝ)) 2
        nlinarith [hsq, sq_nonneg (n:ℝ)]
      nlinarith [hs, hCpos.le, hnR]
    exact le_trans hc hc2
  exact Asymptotics.IsBigO.of_bound (4*C) key

/-- **OP-5, index form.**  `n_min(p) = p / log 2 - 3/2 + O(1)`, i.e. the 0-based
`nmin p = p / log 2 - 5/2 + O(1)`.

**Correction (recorded §13.677).**  This was previously stated with error `O(1/p)`.  That
statement is **false**: `nmin p` is an integer, and direct evaluation of
`Phi_p(n) = Σ_{j≥0} (1 + (j+1)/n)^{-p}` shows

    nmin p = ceil(p / log 2 - 5/2)      (verified at 40 dps for 76 values of p),

so `nmin p - nminAsym p ∈ (0,1)` and `p * (nmin p - nminAsym p)` is unbounded.  The error
term is `O(1)`, and the constant below is `11 = 8 + 5/2`, coming from
`|nmin p * log 2 - p| ≤ 4` (that is `log_nmin_close`, which is the sharp form of the
discrete crossing alignment) together with `1/2 ≤ log 2`. -/
theorem op5_nmin_asymptotic :
    (fun p : ℕ => (nmin p : ℝ) - nminAsym p) =O[atTop]
      (fun _ : ℕ => (1 : ℝ)) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨11, ?_⟩
  set K : ℕ := Nat.ceil (10^40 * ((2*PhiC+1)^2 + 1)) with hK
  have hKle : (10^40 * ((2*PhiC+1)^2 + 1) : ℝ) ≤ (K : ℝ) := Nat.le_ceil _
  filter_upwards [Filter.eventually_ge_atTop
    (max 6 (max (Nat.ceil (3*PhiC/2)) (max 2000000000 K)))] with p hp
  have hp6 : 6 ≤ p := by omega
  have hC1 : 3*PhiC ≤ ((2*p : ℕ):ℝ) := by
    have h1 : Nat.ceil (3*PhiC/2) ≤ p := by omega
    have h2 : (3*PhiC/2 : ℝ) ≤ (Nat.ceil (3*PhiC/2) : ℝ) := Nat.le_ceil _
    have h3 : (Nat.ceil (3*PhiC/2) : ℝ) ≤ (p : ℝ) := by exact_mod_cast h1
    push_cast
    linarith
  have hp2000 : 2000000000 ≤ p := by omega
  have hpK : K ≤ p := by omega
  have hnge : p ≤ nmin p := nmin_ge_p p hp6
  have hn : 2000000000 ≤ nmin p := le_trans hp2000 hnge
  have hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) :=
    le_trans hKle (by exact_mod_cast (le_trans hpK hnge))
  have h := Op56.log_nmin_close p hp6 hn hC1 hnK
  have hL : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hLh : (1/2:ℝ) ≤ Real.log 2 := log_two_ge_half
  rw [Real.norm_eq_abs, Real.norm_eq_abs]
  have h2 : (nmin p : ℝ) - nminAsym p
      = ((nmin p : ℝ) * Real.log 2 - (p:ℝ)) / Real.log 2 + 5/2 := by
    unfold nminAsym
    field_simp
    ring
  rw [abs_one, mul_one, h2]
  calc |((nmin p : ℝ) * Real.log 2 - (p:ℝ)) / Real.log 2 + 5/2|
      ≤ |((nmin p : ℝ) * Real.log 2 - (p:ℝ)) / Real.log 2| + |(5/2:ℝ)| := abs_add_le _ _
    _ = |((nmin p : ℝ) * Real.log 2 - (p:ℝ)) / Real.log 2| + 5/2 := by
        rw [abs_of_nonneg (by norm_num : (0:ℝ) ≤ 5/2)]
    _ ≤ 4 / Real.log 2 + 5/2 := by
        rw [abs_div, abs_of_pos hL]
        linarith [div_le_div_of_nonneg_right h (le_of_lt hL)]
    _ ≤ 11 := by
        have h8 : 4 / Real.log 2 ≤ 8 := by
          rw [div_le_iff₀ hL]
          linarith
        linarith

/-! ### OP-6 -/

/-- **OP-6 (proved).**  `L(p) = p log p - (1 + log log 2) p + O(1)`, equivalently
`measure(S_1)/P(p) = p^{-p} exp((1 + log log 2) p) (1 + o(1)) → 0`.

**Proof.**  OP-5 composed with the census law of `Op56/Census.lean`: the `p ≫ n`
regime identity `ζ(p, n_min) = z(p) n_min^{-p}` with `z(p) → 2`, together with
`L_bounded` and `PhiC_le`, yields the `O(1)` residual `L p - LAsym p`.  The constant
`-(1 + log log 2)` is additionally verified on exact census data to ten figures by
`../op06_reachable_fraction.py`. -/
theorem op6_reachable_fraction :
    (fun p : ℕ => L p - LAsym p) =O[atTop] (fun _ : ℕ => (1 : ℝ)) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨1000, ?_⟩
  filter_upwards [Filter.eventually_ge_atTop
    (max 5052 (max 2000000000 (10^40 * ((2*3368+1)^2 + 1))))] with p hp
  have hp16 : 16 ≤ p := by omega
  have hp6 : 6 ≤ p := by omega
  have hp2000 : 2000000000 ≤ p := by omega
  have hp5052 : 5052 ≤ p := by omega
  have hpbig : 10^40 * ((2*3368+1)^2 + 1) ≤ p := by omega
  have hn : 2000000000 ≤ nmin p := le_trans hp2000 (nmin_ge_p p hp6)
  have hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ) := by
    have hc : PhiC ≤ 3368 := Op56.PhiC_le
    have hp' : (5052:ℝ) ≤ (p:ℝ) := by exact_mod_cast hp5052
    push_cast
    linarith
  have hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ) := by
    have h1 : (10^40 * ((2*3368+1)^2 + 1) : ℕ) ≤ p := hpbig
    have h2 : PhiC ≤ 3368 := Op56.PhiC_le
    have h3 : (10^40 * ((2*PhiC+1)^2 + 1) : ℝ) ≤ (10^40 * ((2*3368+1)^2 + 1) : ℝ) := by
      have hle : 2*PhiC + 1 ≤ 2*3368 + 1 := by linarith [h2]
      have h0 : (0:ℝ) ≤ 2*PhiC + 1 := by linarith [PhiC_pos]
      have hsq : (2*PhiC+1)^2 ≤ (2*3368+1)^2 := pow_le_pow_left₀ h0 hle 2
      have h99 : (0:ℝ) ≤ 10^40 := by norm_num
      nlinarith [hsq, h99]
    have h4 : ((10^40 * ((2*3368+1)^2 + 1) : ℕ) : ℝ) ≤ (nmin p : ℝ) := by
      exact_mod_cast (le_trans h1 (nmin_ge_p p hp6))
    push_cast at h4
    linarith
  have h := Op56.L_bounded p hp16 hn hlarge hnK
  rw [Real.norm_eq_abs, Real.norm_eq_abs]
  simp only [abs_one, mul_one]
  exact h

end

end Op56
