import Mathlib

/-!
# A rational enclosure of `L Λ 2`

We compute `L Λ 2 = ∑' n, Λ n / n²` as a finite partial sum over `n ≤ 100`
plus an explicit p-series tail.  The tail is bounded by comparing
`Λ n / n² ≤ log n / n² ≤ 2 n^{-3/2}` and applying the integral test to
`x ↦ x^{-3/2}` on `(100, ∞)`, whose integral is `2/√100 = 1/5`.

The resulting enclosure is

`anchorPartial - 2/5 ≤ (L Λ 2).re ≤ anchorPartial + 2/5`.

## A note on the coefficient type

`ArithmeticFunction.vonMangoldt` is real-valued in current Mathlib
(`Λ : ℕ → ℝ`), and `Λ n = log p` is irrational at prime powers `n = pᵏ`.
Consequently the partial sum `∑_{n ≤ 100} Λ n / n²` is a real number with no
rational closed form, and the literal definition
`∑ n, (vonMangoldt n : ℚ) / (n : ℚ) ^ 2` does not typecheck.

We therefore keep the finite partial sum as a real number
(`anchorPartialReal`) and take `anchorPartial : ℚ` to be that real number
rounded *up* to a multiple of `1/1000`.  This is a genuine rational (the
ceiling of a real number), it overshoots the exact partial sum by less than
`1/1000`, and hence the same `±2/5` enclosure holds with rational endpoints.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open Complex MeasureTheory

namespace FiniteWindowZeros

open ArithmeticFunction

/-- The number of terms kept in the anchor partial sum. -/
def anchorN : ℕ := 100

/-- The real coefficients `Λ n / n²` of the series. -/
private def anchorCoeff (n : ℕ) : ℝ :=
  (ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ 2

/-- The exact real finite partial sum `∑_{n ≤ 100} Λ n / n²`. -/
private def anchorPartialReal : ℝ :=
  ∑ n ∈ Finset.range (anchorN + 1), anchorCoeff n

/-- The rational anchor: the exact partial sum rounded up to a multiple of
`1/1000`.  (The exact partial sum itself is irrational in general; see the
module docstring.) -/
def anchorPartial : ℚ :=
  ((⌈(1000 : ℝ) * anchorPartialReal⌉ : ℤ) : ℚ) / 1000

/-- Lower end of the rational enclosure. -/
def anchorLo : ℚ := anchorPartial - 2 / 5

/-- Upper end of the rational enclosure. -/
def anchorHi : ℚ := anchorPartial + 2 / 5

private lemma anchorCoeff_nonneg (n : ℕ) : 0 ≤ anchorCoeff n := by
  unfold anchorCoeff
  positivity

private lemma anchorCoeff_le_rpow (n : ℕ) :
    anchorCoeff n ≤ 2 * (n : ℝ) ^ (-(3 / 2 : ℝ)) := by
  rcases eq_or_ne n 0 with h0 | hn
  · subst n
    unfold anchorCoeff
    simp
  · have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hn
    have hlog : (ArithmeticFunction.vonMangoldt n : ℝ) ≤ Real.log (n : ℝ) :=
      ArithmeticFunction.vonMangoldt_le_log
    have hlogbound : Real.log (n : ℝ) ≤ 2 * (n : ℝ) ^ (1 / 2 : ℝ) := by
      have h := Real.log_le_rpow_div (x := (n : ℝ)) (ε := (1 / 2 : ℝ))
        (le_of_lt hnpos) (by norm_num)
      calc Real.log (n : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) / (1 / 2 : ℝ) := h
        _ = 2 * (n : ℝ) ^ (1 / 2 : ℝ) := by ring
    have hsub : (n : ℝ) ^ (1 / 2 : ℝ) / (n : ℝ) ^ 2 = (n : ℝ) ^ (-(3 / 2 : ℝ)) := by
      rw [show (n : ℝ) ^ 2 = (n : ℝ) ^ (2 : ℝ) by rw [Real.rpow_two]]
      rw [← Real.rpow_sub hnpos]
      norm_num
    calc anchorCoeff n
        = (ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ 2 := rfl
      _ ≤ Real.log (n : ℝ) / (n : ℝ) ^ 2 := by gcongr
      _ ≤ (2 * (n : ℝ) ^ (1 / 2 : ℝ)) / (n : ℝ) ^ 2 := by gcongr
      _ = 2 * ((n : ℝ) ^ (1 / 2 : ℝ) / (n : ℝ) ^ 2) := by ring
      _ = 2 * (n : ℝ) ^ (-(3 / 2 : ℝ)) := by rw [hsub]

private lemma summable_anchorCoeff : Summable anchorCoeff := by
  have hmaj : Summable (fun n : ℕ => 2 * (n : ℝ) ^ (-(3 / 2 : ℝ))) := by
    have h : Summable (fun n : ℕ => (n : ℝ) ^ (-(3 / 2 : ℝ))) :=
      (Real.summable_nat_rpow (p := -(3 / 2 : ℝ))).mpr (by norm_num)
    exact h.mul_left 2
  exact hmaj.of_nonneg_of_le anchorCoeff_nonneg anchorCoeff_le_rpow

/-- The L-series of `Λ` at `2` is the real series of the coefficients `Λ n / n²`. -/
private lemma LSeries_vonMangoldt_two_eq_tsum :
    LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2
      = ((∑' n : ℕ, anchorCoeff n : ℝ) : ℂ) := by
  have hterm : ∀ n : ℕ,
      LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2 n
        = ((anchorCoeff n : ℝ) : ℂ) := by
    intro n
    rcases eq_or_ne n 0 with h0 | hn
    · subst n
      simp [anchorCoeff]
    · rw [LSeries.term_of_ne_zero hn]
      simp only [anchorCoeff]
      rw [Complex.cpow_two]
      push_cast
      ring
  rw [LSeries]
  rw [tsum_congr hterm]
  exact (Complex.ofReal_tsum (fun n => anchorCoeff n)).symm

/-- The tail bound: `∑_{n > 100} Λ n / n² ≤ 2/5`. -/
private lemma anchor_tail_le :
    (∑' n : ℕ, anchorCoeff (n + 101)) ≤ 2 / 5 := by
  have hpt : ∀ n : ℕ,
      anchorCoeff (n + 101) ≤ 2 * ((n + 101 : ℕ) : ℝ) ^ (-(3 / 2 : ℝ)) :=
    fun n => anchorCoeff_le_rpow (n + 101)
  have hsumm_tail : Summable (fun n : ℕ => anchorCoeff (n + 101)) :=
    (summable_nat_add_iff 101).mpr summable_anchorCoeff
  have hmaj : Summable (fun n : ℕ => 2 * ((n + 101 : ℕ) : ℝ) ^ (-(3 / 2 : ℝ))) := by
    have hbase : Summable (fun n : ℕ => 2 * (n : ℝ) ^ (-(3 / 2 : ℝ))) := by
      have h : Summable (fun n : ℕ => (n : ℝ) ^ (-(3 / 2 : ℝ))) :=
        (Real.summable_nat_rpow (p := -(3 / 2 : ℝ))).mpr (by norm_num)
      exact h.mul_left 2
    exact (summable_nat_add_iff 101).mpr hbase
  have hupper : (∑' n : ℕ, anchorCoeff (n + 101))
      ≤ ∑' n : ℕ, 2 * ((n + 101 : ℕ) : ℝ) ^ (-(3 / 2 : ℝ)) :=
    Summable.tsum_le_tsum hpt hsumm_tail hmaj
  -- Integral test on `x ↦ x^{-3/2}` over `(100, ∞)`.
  set p : ℝ := -(3 / 2 : ℝ) with hp
  have hpneg : p < -1 := by rw [hp]; norm_num
  have hpnonpos : p ≤ 0 := by rw [hp]; norm_num
  have hanti : AntitoneOn (fun x : ℝ => x ^ p) (Set.Ici (((100 : ℕ) : ℝ))) := by
    refine (Real.antitoneOn_rpow_Ioi_of_exponent_nonpos hpnonpos).mono ?_
    intro x hx
    have hx100 : (100 : ℝ) ≤ x := by simpa using hx
    exact lt_of_lt_of_le (by norm_num) hx100
  have hInt : IntegrableOn (fun x : ℝ => x ^ p) (Set.Ioi (((100 : ℕ) : ℝ))) :=
    integrableOn_Ioi_rpow_of_lt (a := p) (c := ((100 : ℕ) : ℝ)) hpneg (by norm_num)
  have hnonneg : ∀ t ∈ Set.Ioi (((100 : ℕ) : ℝ)), 0 ≤ t ^ p := by
    intro t ht
    have ht100 : (100 : ℝ) < t := by simpa using ht
    exact Real.rpow_nonneg (le_of_lt (lt_trans (by norm_num) ht100)) _
  have htail_int : (∑' n : ℕ, ((n + 100 + 1 : ℕ) : ℝ) ^ p)
      ≤ ∫ x in Set.Ioi (((100 : ℕ) : ℝ)), x ^ p :=
    AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ p) (N := 100)
      hanti hInt hnonneg
  have hint : (∫ x in Set.Ioi (((100 : ℕ) : ℝ)), x ^ p) = 1 / 5 := by
    rw [hp]
    rw [integral_Ioi_rpow_of_lt (a := -(3 / 2 : ℝ)) (c := ((100 : ℕ) : ℝ))
      (by norm_num) (by norm_num)]
    rw [show (-(3 / 2 : ℝ) + 1) = -(1 / 2 : ℝ) by ring]
    rw [show ((100 : ℕ) : ℝ) = 100 by norm_num]
    have hsqrt : (100 : ℝ) ^ (-(1 / 2 : ℝ)) = 1 / 10 := by
      rw [show (-(1 / 2 : ℝ)) = -((1 / 2 : ℝ)) by ring, Real.rpow_neg (by norm_num)]
      rw [← Real.sqrt_eq_rpow]
      norm_num
    rw [hsqrt]
    norm_num
  have hshift : (∑' n : ℕ, 2 * ((n + 101 : ℕ) : ℝ) ^ p)
      = 2 * ∑' n : ℕ, ((n + 101 : ℕ) : ℝ) ^ p := by
    rw [tsum_mul_left]
  have htsum_le : (∑' n : ℕ, ((n + 101 : ℕ) : ℝ) ^ p) ≤ 1 / 5 := by
    have h := htail_int
    simpa only [Nat.add_assoc] using h.trans_eq hint
  calc (∑' n : ℕ, anchorCoeff (n + 101))
      ≤ ∑' n : ℕ, 2 * ((n + 101 : ℕ) : ℝ) ^ (-(3 / 2 : ℝ)) := hupper
    _ = ∑' n : ℕ, 2 * ((n + 101 : ℕ) : ℝ) ^ p := by rw [hp]
    _ = 2 * ∑' n : ℕ, ((n + 101 : ℕ) : ℝ) ^ p := hshift
    _ ≤ 2 * (1 / 5) := by gcongr
    _ = 2 / 5 := by norm_num

/-- The rational anchor overshoots the exact partial sum. -/
private lemma anchorPartial_cast_le : anchorPartialReal ≤ (anchorPartial : ℝ) := by
  have h : (1000 : ℝ) * anchorPartialReal
      ≤ (((⌈(1000 : ℝ) * anchorPartialReal⌉ : ℤ)) : ℝ) := Int.le_ceil _
  unfold anchorPartial
  push_cast
  linarith

/-- The rational anchor overshoots the exact partial sum by less than `1/1000`. -/
private lemma anchorPartial_cast_lt : (anchorPartial : ℝ) < anchorPartialReal + 1 / 1000 := by
  have h : (((⌈(1000 : ℝ) * anchorPartialReal⌉ : ℤ)) : ℝ)
      < 1000 * anchorPartialReal + 1 := Int.ceil_lt_add_one _
  unfold anchorPartial
  push_cast
  linarith

/-- Rational enclosure of the real part of `L Λ 2`. -/
theorem LSeries_two_anchor :
    (anchorLo : ℝ) ≤ (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re ∧
    (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re ≤ (anchorHi : ℝ) := by
  have hL := LSeries_vonMangoldt_two_eq_tsum
  have hre : (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re
      = ∑' n : ℕ, anchorCoeff n := by
    rw [hL]
    simp
  have hdecomp : (∑' n : ℕ, anchorCoeff n)
      = (∑ n ∈ Finset.range (anchorN + 1), anchorCoeff n)
        + ∑' n : ℕ, anchorCoeff (n + 101) :=
    (summable_anchorCoeff.sum_add_tsum_nat_add 101).symm
  have hpartial : anchorPartialReal = ∑ n ∈ Finset.range (anchorN + 1), anchorCoeff n := rfl
  have htail_nonneg : 0 ≤ ∑' n : ℕ, anchorCoeff (n + 101) :=
    tsum_nonneg fun n => anchorCoeff_nonneg (n + 101)
  have htail_le : (∑' n : ℕ, anchorCoeff (n + 101)) ≤ 2 / 5 := anchor_tail_le
  have hle := anchorPartial_cast_le
  have hlt := anchorPartial_cast_lt
  have hlo : (anchorLo : ℝ) = (anchorPartial : ℝ) - 2 / 5 := by
    unfold anchorLo
    push_cast
    ring
  have hhi : (anchorHi : ℝ) = (anchorPartial : ℝ) + 2 / 5 := by
    unfold anchorHi
    push_cast
    ring
  constructor
  · rw [hre, hdecomp, ← hpartial, hlo]
    linarith
  · rw [hre, hdecomp, ← hpartial, hhi]
    linarith

/-- The imaginary part of `L Λ 2` vanishes. -/
theorem LSeries_two_anchor_im :
    (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).im = 0 := by
  rw [LSeries_vonMangoldt_two_eq_tsum]
  simp

/-- The same enclosure with real endpoints, without the rational rounding. -/
theorem LSeries_two_anchor_real :
    anchorPartialReal - 2 / 5
        ≤ (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re ∧
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re
        ≤ anchorPartialReal + 2 / 5 := by
  have hL := LSeries_vonMangoldt_two_eq_tsum
  have hre : (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re
      = ∑' n : ℕ, anchorCoeff n := by
    rw [hL]
    simp
  have hdecomp : (∑' n : ℕ, anchorCoeff n)
      = (∑ n ∈ Finset.range (anchorN + 1), anchorCoeff n)
        + ∑' n : ℕ, anchorCoeff (n + 101) :=
    (summable_anchorCoeff.sum_add_tsum_nat_add 101).symm
  have hpartial : anchorPartialReal = ∑ n ∈ Finset.range (anchorN + 1), anchorCoeff n := rfl
  have htail_nonneg : 0 ≤ ∑' n : ℕ, anchorCoeff (n + 101) :=
    tsum_nonneg fun n => anchorCoeff_nonneg (n + 101)
  have htail_le : (∑' n : ℕ, anchorCoeff (n + 101)) ≤ 2 / 5 := anchor_tail_le
  constructor <;> rw [hre, hdecomp, ← hpartial] <;> linarith

end FiniteWindowZeros
