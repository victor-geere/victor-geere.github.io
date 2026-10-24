/-
TppLean/Budget.lean — the budget functions of the rh42 handoff, concretely.

The source (`research/twin-prime-parity/rounds/rh42/HANDOFF.md` §5.1) defines

  P(p) = Σ_{k ≥ 1} (2k)^{-p}      "positive budget"
  N(p) = Σ_{k ≥ 1} (2k+1)^{-p}    "negative budget"

and proves `P(p) = 2^{-p} ζ(p)` and `N(p) = (1 - 2^{-p}) ζ(p) - 1 = Σ_{k≥1}(2k+1)^{-p}`.
Here the sums themselves are the definitions (they are the objects the greedy rule spends),
and `ZetaR p = Σ_{n ≥ 1} n^{-p}` is the real Dirichlet series; for `p > 1` it is the real part
of Mathlib's `riemannZeta p` by `zeta_eq_tsum_one_div_nat_cpow`.

Proved here: summability, the shift identity for `ZetaR`, and **strict antitonicity** of
`ZetaR` on `(1, ∞)` — which Mathlib does not have for ζ.  The separation `N p < P p` is
proved in `TppLean/Separation.lean`.
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

namespace TppLean

open scoped BigOperators

set_option maxHeartbeats 800000

/-! ## 1. The series -/

/-- The real Dirichlet series of zeta: `ZetaR p = Σ_{n ≥ 1} n^{-p}`. -/
noncomputable def ZetaR (p : ℝ) : ℝ := ∑' n : ℕ, ((n : ℝ) ^ p)⁻¹

/-- **The even budget.** `P p = 2^{-p} · Σ_{k≥1} k^{-p}`, the sum over `n = 2k`. -/
noncomputable def BPos (p : ℝ) : ℝ := (2 : ℝ) ^ (-p) * ZetaR p

/-- **The odd budget.** `N p = Σ_{k≥0} (2k+3)^{-p}`, the sum over the odd `n ≥ 3`. -/
noncomputable def BNeg (p : ℝ) : ℝ := ∑' k : ℕ, ((2 * (k : ℝ) + 3) ^ p)⁻¹

lemma summable_zetaR {p : ℝ} (hp : 1 < p) : Summable fun n : ℕ => ((n : ℝ) ^ p)⁻¹ :=
  Real.summable_nat_rpow_inv.mpr hp

lemma summable_shift {p : ℝ} (hp : 1 < p) :
    Summable fun k : ℕ => (((k : ℝ) + 1) ^ p)⁻¹ := by
  have h : Summable fun k : ℕ => (((k + 1 : ℕ) : ℝ) ^ p)⁻¹ :=
    (summable_zetaR (p := p) hp).comp_injective
      (fun a b h => Nat.succ.inj (Nat.cast_inj.mp h))
  refine h.congr (fun k => ?_)
  rw [show (((k + 1 : ℕ)) : ℝ) = (k : ℝ) + 1 by push_cast; ring]

/-- First shift: `ZetaR p = Σ_{k≥0} (k+1)^{-p}`. -/
lemma zetaR_shift {p : ℝ} (hp : 1 < p) : ZetaR p = ∑' k : ℕ, (((k : ℝ) + 1) ^ p)⁻¹ := by
  rw [ZetaR, Summable.tsum_eq_zero_add (summable_zetaR hp)]
  norm_num [Real.zero_rpow (ne_of_gt (zero_lt_one.trans hp))]

lemma summable_BNeg {p : ℝ} (hp : 1 < p) :
    Summable fun k : ℕ => ((2 * (k : ℝ) + 3) ^ p)⁻¹ := by
  refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_)
    (summable_shift (p := p) hp)
  have h1 : (0 : ℝ) < (k : ℝ) + 1 := by positivity
  have h2 : (0 : ℝ) < 2 * (k : ℝ) + 3 := by positivity
  have hle : (k : ℝ) + 1 ≤ 2 * (k : ℝ) + 3 := by
    have : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
    linarith
  have hpow : ((k : ℝ) + 1) ^ p ≤ (2 * (k : ℝ) + 3) ^ p :=
    Real.rpow_le_rpow (le_of_lt h1) hle (le_of_lt (lt_trans zero_lt_one hp))
  have := one_div_le_one_div_of_le (Real.rpow_pos_of_pos h1 p) hpow
  simpa only [one_div] using this

/-! ## 2. Strict antitonicity of the zeta series -/

/-- **Strict antitonicity of `ZetaR` on `(1, ∞)`.**

For `p < q` every term of the difference is nonnegative and the `n = 2` term is strictly
positive, so the difference series has a positive sum. -/
lemma ZetaR_strictAnti {p q : ℝ} (hp : 1 < p) (hpq : p < q) : ZetaR q < ZetaR p := by
  have hq : 1 < q := lt_trans hp hpq
  have hp0 : (0 : ℝ) < p := lt_trans zero_lt_one hp
  have hq0 : (0 : ℝ) < q := lt_trans zero_lt_one hq
  set c : ℕ → ℝ := fun n => ((n : ℝ) ^ p)⁻¹ - ((n : ℝ) ^ q)⁻¹ with hc
  have hsum_c : Summable c := (summable_zetaR hp).sub (summable_zetaR hq)
  have hnonneg : ∀ n, 0 ≤ c n := by
    intro n
    rcases le_or_gt n 1 with hn | hn
    · interval_cases n
      · simp [hc, Real.zero_rpow (ne_of_gt hp0), Real.zero_rpow (ne_of_gt hq0)]
      · simp [hc]
    · have hn1 : (1 : ℝ) < (n : ℝ) := by
        have : (1 : ℕ) < n := hn
        exact_mod_cast this
      have hnp : (0 : ℝ) < (n : ℝ) := by positivity
      have hlt : (n : ℝ) ^ (-q) < (n : ℝ) ^ (-p) :=
        Real.rpow_lt_rpow_of_exponent_lt hn1 (by linarith)
      rw [Real.rpow_neg (le_of_lt hnp) p, Real.rpow_neg (le_of_lt hnp) q] at hlt
      simp only [hc]
      linarith
  have hfirst : 0 < c 2 := by
    have hlt : (2 : ℝ) ^ (-q) < (2 : ℝ) ^ (-p) :=
      Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)
    rw [Real.rpow_neg (by norm_num) p, Real.rpow_neg (by norm_num) q] at hlt
    simp only [hc]
    linarith
  have hpos : 0 < ∑' n, c n := by
    have h0 : c 0 = 0 := by simp [hc, Real.zero_rpow (ne_of_gt hp0), Real.zero_rpow (ne_of_gt hq0)]
    calc (0 : ℝ) = c 0 := h0.symm
      _ < c 2 := by rw [h0]; exact hfirst
      _ ≤ ∑' n, c n := hsum_c.le_tsum 2 (fun j _ => hnonneg j)
  have hdiff : ZetaR p - ZetaR q = ∑' n, c n := by
    rw [ZetaR, ZetaR]
    exact (Summable.tsum_sub (summable_zetaR hp) (summable_zetaR hq)).symm
  linarith [hdiff ▸ hpos]

/-! ## 3. Relation to Mathlib's `riemannZeta` -/

/-- **The bridge to Mathlib's zeta.**  On the real axis above `1`, the real Dirichlet series
`ZetaR` is exactly the real part of Mathlib's `riemannZeta`.

`zeta_eq_tsum_one_div_nat_cpow` writes `riemannZeta s = Σ' n, 1 / (n : ℂ) ^ s` for `1 < s.re`;
each term is `↑((n : ℝ) ^ p)⁻¹` by `Complex.ofReal_cpow` and `Complex.ofReal_inv`, so
`Complex.ofReal_tsum` factors the whole series through `ℝ`, and `Complex.ofReal_re` reads off the
real part. -/
lemma ZetaR_eq_riemannZeta_re {p : ℝ} (hp : 1 < p) :
    ZetaR p = (riemannZeta (p : ℂ)).re := by
  have hre : (1 : ℝ) < (p : ℂ).re := by simpa using hp
  rw [zeta_eq_tsum_one_div_nat_cpow hre]
  have hcongr : (∑' n : ℕ, 1 / (n : ℂ) ^ ((p : ℂ))) = ↑(∑' n : ℕ, ((n : ℝ) ^ p)⁻¹) := by
    rw [Complex.ofReal_tsum]
    refine tsum_congr (fun n => ?_)
    rw [show ((n : ℂ) ^ ((p : ℂ))) = ↑((n : ℝ) ^ p) by
      rw [← Complex.ofReal_natCast, Complex.ofReal_cpow (Nat.cast_nonneg n) p]]
    rw [one_div, Complex.ofReal_inv]
  rw [hcongr, Complex.ofReal_re, ZetaR]

/-- Consequently the positive budget is `2^{-p}` times the real part of `riemannZeta` at `p`.

Note the factor: `BPos p` is *not* `(riemannZeta p).re`, it is `2^{-p}` times it, because the
positive budget sums over even denominators only.  It is `ZetaR p` that is the real part itself. -/
lemma BPos_eq_riemannZeta_re {p : ℝ} (hp : 1 < p) :
    BPos p = (2 : ℝ) ^ (-p) * (riemannZeta (p : ℂ)).re := by
  rw [BPos, ZetaR_eq_riemannZeta_re hp]

end TppLean
