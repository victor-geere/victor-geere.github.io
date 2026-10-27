import EulerMaclaurin

/-!
# The `B₂` remainder on the critical line

`EulerMaclaurin.lean` proves the general-`K` Euler–Maclaurin error bound
(`norm_zetaEMRemainder_le`) only under `1 < Re s`.  The sharp `B₂` series bound
(`norm_tsum_correction_le_sharp`) needs only `0 < Re s`, but the *identification*
of the remainder with that series (`zetaEMRemainder_one`) was likewise gated
behind `1 < Re s`.

This file closes that gap by a route that avoids the divergent intermediate
quantities used in the `Re s > 1` proof.  The two finite Euler–Maclaurin
identities

* `sum_tail_first_order`      (first order, with the `(x - k - 1/2)` weight), and
* `sum_second_order_shift`    (second order, with the `B₂` weight)

have the *same* left-hand side and the same `∫ (k..k+1) emGShift` and
`emGShift s N 0 n` terms, so subtracting them cancels both and yields, for
**every** `s` and every `n`,

`Σ_{k<n} ∫ (x-k-1/2) · emG₁ = B₂(0)/2 · (emG₁ n - emG₁ 0) - ½ Σ_{k<n} ∫ B_{2}(x-k) · emG₂`.

Every term here converges as `n → ∞` for `0 < Re s` (the two sums because
`emG_j x ≍ x^{-Re s - j}`, the boundary term because `j = 1 ≥ 1`), so the
identity passes to the limit.  That gives `tsum_correction_first_eq_of_re_pos`,
and hence the `B₂` remainder bound at `Re s = 1/2`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open Filter Topology

/-! ## The shifted Bernoulli tower vanishes for `Re s > 0` -/

/-- `emGShift s N j n → 0` as soon as `Re s > 0` (no `j`-dependent hypothesis). -/
theorem tendsto_emGShift_zero_general_of_re_pos {s : ℂ} (hs : 0 < s.re) (N j : ℕ) :
    Tendsto (fun n : ℕ => emGShift s N j n) atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hle : ∀ n : ℕ, ‖emGShift s N j n‖ ≤
      ‖(descPochhammer ℂ j).eval (-s)‖ * ((n:ℝ) + 1) ^ (-s.re - j) := by
    intro n
    rw [norm_emGShift s N j (by positivity)]
    have hbase : (n:ℝ) + 1 ≤ (n:ℝ) + (N:ℝ) + 1 := by
      have hN : (0:ℝ) ≤ N := by exact_mod_cast Nat.zero_le N
      linarith
    have hexp : -s.re - (j : ℝ) ≤ 0 := by
      have : (0:ℝ) ≤ (j : ℝ) := by positivity
      linarith
    have hpow : ((n:ℝ) + (N:ℝ) + 1) ^ (-s.re - j) ≤ ((n:ℝ) + 1) ^ (-s.re - j) :=
      Real.rpow_le_rpow_of_nonpos (by positivity) hbase hexp
    exact mul_le_mul_of_nonneg_left hpow (norm_nonneg _)
  have hg : Tendsto (fun n : ℕ =>
      ‖(descPochhammer ℂ j).eval (-s)‖ * ((n:ℝ) + 1) ^ (-s.re - j)) atTop (𝓝 0) := by
    have h := tendsto_shifted_rpow_zero (σ := s.re + j + 1) (by linarith)
    simpa [show (1:ℝ) - (s.re + (j:ℝ) + 1) = -s.re - j by ring] using
      h.const_mul ‖(descPochhammer ℂ j).eval (-s)‖
  exact squeeze_zero (fun n => norm_nonneg _) hle hg

/-- The first Bernoulli tower vanishes for `Re s > 0`. -/
theorem tendsto_emGShift_one_zero_of_re_pos {s : ℂ} (hs : 0 < s.re) (N : ℕ) :
    Tendsto (fun n : ℕ => emGShift s N 1 n) atTop (𝓝 0) :=
  tendsto_emGShift_zero_general_of_re_pos hs N 1

/-! ## The finite bridge -/

/-- **Finite bridge.**  For every `s` and `n`, the first-order correction sum
equals the `B₂` boundary term minus half the `B₂` block sum.  Both identities
have the same left-hand side, so the proof is a subtraction. -/
theorem sum_correction_eq_B2 (s : ℂ) (N n : ℕ) :
    Finset.sum (Finset.range n) (fun k =>
        ∫ x in (k:ℝ)..(k+1), (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 n - emGShift s N 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have h1 := sum_tail_first_order s N n
  have h2 := sum_second_order_shift s N n
  linear_combination h2 - h1

/-- **The `B₂` bridge series identity at `Re s > 0`.**

This is the statement that `EulerMaclaurin.lean` proves only for `1 < Re s`
(as `tsum_correction_first_eq`), here obtained by taking `n → ∞` in the finite
bridge `sum_correction_eq_B2`. -/
theorem tsum_correction_first_eq_of_re_pos (s : ℂ) (N : ℕ) (hs : 0 < s.re) :
    (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        (((x - k - 1 / 2 : ℝ) : ℂ)) * emGShift s N 1 x) =
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emGShift s N 1 0) -
        (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  have hcorr := tendsto_sum_tail_correction hs N
  have hB2 := tendsto_sum_B2_shift s N hs
  have hE1 := tendsto_emGShift_one_zero_of_re_pos hs N
  have hR : Tendsto (fun n : ℕ =>
      (((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (emGShift s N 1 n - emGShift s N 1 0) -
        (1 / 2) * Finset.sum (Finset.range n) (fun k =>
          ∫ x in (k:ℝ)..(k+1), emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)))
      atTop (𝓝 ((((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2) * (0 - emGShift s N 1 0) -
        (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)))) :=
    ((hE1.sub_const (emGShift s N 1 0)).const_mul
      ((((BR 2).eval 0 : ℝ) : ℂ) * (1 / 2))).sub (hB2.const_mul (1 / 2))
  exact tendsto_nhds_unique hcorr
    (hR.congr' (Eventually.of_forall (fun n => (sum_correction_eq_B2 s N n).symm)))

/-! ## The `K = 1` remainder at `Re s > 0` -/

/-- `zetaEM` equals the `K = 1` general expression minus the `B₂` series. -/
theorem zetaEM_eq_gen_one_of_re_pos (N : ℕ) (s : ℂ) (hs : 0 < s.re) :
    zetaEM N s = zetaEMGen 1 N s -
      (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEM_eq_base_add]
  rw [tsum_correction_first_eq_of_re_pos s N hs]
  rw [c1_emGShift_one_zero]
  rw [show zetaBase N s +
        ((1 / 12 : ℂ) * s * ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1))) -
          (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
            emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ))) =
      (zetaBase N s + (1 / 12 : ℂ) * s * ((((N:ℝ) + 1 : ℝ) : ℂ) ^ (-(s + 1)))) -
        (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) by ring]
  rw [← zetaEMGen_one]

/-- `K = 1` remainder is minus half the `B₂` series, for `0 < Re s`. -/
theorem zetaEMRemainder_one_of_re_pos (N : ℕ) (s : ℂ) (hs : 0 < s.re) :
    zetaEMRemainder 1 N s =
      - (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) := by
  rw [zetaEMRemainder]
  rw [zetaEM_eq_gen_one_of_re_pos N s hs]
  ring

/-! ## The bound -/

/-- The `B₂` constant is `1/12`. -/
theorem emConst_two : (2 * (riemannZeta (2 : ℂ)).re / (2 * Real.pi) ^ 2) = (1 / 12 : ℝ) := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hz2 : (riemannZeta (2 : ℂ)).re = Real.pi ^ 2 / 6 := by
    rw [riemannZeta_two]
    have h : ((Real.pi : ℂ) ^ 2 / 6) = ((Real.pi ^ 2 / 6 : ℝ) : ℂ) := by
      push_cast
      ring
    rw [h, Complex.ofReal_re]
  rw [hz2]
  field_simp
  ring

/-- **The `B₂` remainder bound on the critical line.**  This is
`norm_zetaEMRemainder_le` for `K = 1`, but with the hypothesis weakened from
`1 < Re s` to `0 < Re s`.  The constant is `2·Re ζ(2)/(2π)² = 1/12`. -/
theorem norm_zetaEMRemainder_one_le_of_re_pos (N : ℕ) (s : ℂ) (hs : 0 < s.re) :
    ‖zetaEMRemainder 1 N s‖ ≤
      (1 / 12 : ℝ) * ‖(descPochhammer ℂ 2).eval (-s)‖ *
        ((((N:ℝ) + 1) ^ (-s.re - 2)) +
          ((((N:ℝ) + 1) ^ (1 - s.re - 2)) / (s.re + 1))) := by
  have hT : (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        emGShift s N 2 x * (((BR 2).eval (x - k) : ℝ) : ℂ)) =
      (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
        ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x) := by
    congr 1
    ext k
    congr 1
    ext x
    ring
  rw [zetaEMRemainder_one_of_re_pos N s hs, hT]
  have h := norm_tsum_correction_le_sharp N s hs
  have hc : ∀ x y : ℝ,
      (1 / 2 : ℝ) * ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
          (2 * (riemannZeta (2 : ℂ)).re) * x * y) = (1 / 12 : ℝ) * x * y := by
    intro x y
    have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
    have hz2 : (riemannZeta (2 : ℂ)).re = Real.pi ^ 2 / 6 := by
      rw [riemannZeta_two]
      have h : ((Real.pi : ℂ) ^ 2 / 6) = ((Real.pi ^ 2 / 6 : ℝ) : ℂ) := by
        push_cast
        ring
      rw [h, Complex.ofReal_re]
    rw [hz2, show (Nat.factorial 2 : ℝ) = 2 by norm_num]
    field_simp
    ring
  calc
    ‖- (1 / 2) * (∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
          ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x)‖
        = (1 / 2) * ‖(∑' k : ℕ, ∫ x in (k:ℝ)..(k+1),
            ((((BR 2).eval (x - k) : ℝ) : ℂ)) * emGShift s N 2 x)‖ := by
          rw [norm_mul, norm_neg]
          norm_num
    _ ≤ (1 / 2) * ((Nat.factorial 2 : ℝ) / (2 * Real.pi) ^ 2 *
          (2 * (riemannZeta (2 : ℂ)).re) *
            ‖(descPochhammer ℂ 2).eval (-s)‖ *
            ((((N:ℝ) + 1) ^ (-s.re - 2)) +
              ((((N:ℝ) + 1) ^ (1 - s.re - 2)) / (s.re + 1)))) := by
          exact mul_le_mul_of_nonneg_left h (by norm_num)
    _ = (1 / 12 : ℝ) * ‖(descPochhammer ℂ 2).eval (-s)‖ *
        ((((N:ℝ) + 1) ^ (-s.re - 2)) +
          ((((N:ℝ) + 1) ^ (1 - s.re - 2)) / (s.re + 1))) := by
          exact hc _ _

end FiniteWindowZeros
