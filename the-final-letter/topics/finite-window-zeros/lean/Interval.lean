import Mathlib

/-!
# Rational intervals with outward rounding

A minimal verified interval-arithmetic layer for the finite-window zero
certificates.  Intervals have rational endpoints and are interpreted in `ℝ`.
-/

namespace FiniteWindowZeros

structure RatInterval where
  lo : ℚ
  hi : ℚ
  le : lo ≤ hi

namespace RatInterval

/-- Membership of a real number in a rational interval. -/
def contains (I : RatInterval) (x : ℝ) : Prop :=
  (I.lo : ℝ) ≤ x ∧ x ≤ (I.hi : ℝ)

/-- The exact interval `[q,q]`. -/
def exact (q : ℚ) : RatInterval := ⟨q, q, le_refl q⟩

@[simp] theorem exact_lo (q : ℚ) : (exact q).lo = q := rfl
@[simp] theorem exact_hi (q : ℚ) : (exact q).hi = q := rfl

theorem exact_contains (q : ℚ) : (exact q).contains (q : ℝ) := by
  constructor <;> simp [contains, exact]

/-- Negation, with endpoints swapped. -/
def neg (I : RatInterval) : RatInterval :=
  ⟨-I.hi, -I.lo, by linarith [I.le]⟩

theorem neg_contains {I : RatInterval} {x : ℝ} (h : I.contains x) :
    I.neg.contains (-x) := by
  constructor
  · simp [neg]
    linarith [h.2]
  · simp [neg]
    linarith [h.1]

/-- Addition, with outward rounding at both endpoints. -/
def add (I J : RatInterval) : RatInterval :=
  ⟨I.lo + J.lo, I.hi + J.hi, by linarith [I.le, J.le]⟩

theorem add_contains {I J : RatInterval} {x y : ℝ}
    (hx : I.contains x) (hy : J.contains y) : (I.add J).contains (x + y) := by
  constructor
  · simp only [add, contains] at hx hy ⊢
    push_cast
    linarith [hx.1, hy.1]
  · simp only [add, contains] at hx hy ⊢
    push_cast
    linarith [hx.2, hy.2]

/-- Subtraction. -/
def sub (I J : RatInterval) : RatInterval := I.add J.neg

theorem sub_contains {I J : RatInterval} {x y : ℝ}
    (hx : I.contains x) (hy : J.contains y) : (I.sub J).contains (x - y) := by
  simpa [sub, sub_eq_add_neg] using I.add_contains hx (J.neg_contains hy)

/-- Multiplication for nonnegative intervals. -/
def mulNonneg (I J : RatInterval) (hI : 0 ≤ I.lo) (hJ : 0 ≤ J.lo) : RatInterval :=
  ⟨I.lo * J.lo, I.hi * J.hi, by nlinarith [I.le, J.le, hI, hJ]⟩

theorem mulNonneg_contains {I J : RatInterval} (hI : 0 ≤ I.lo) (hJ : 0 ≤ J.lo)
    {x y : ℝ} (hx : I.contains x) (hy : J.contains y) :
    (I.mulNonneg J hI hJ).contains (x * y) := by
  have hx0 : 0 ≤ x := le_trans (by exact_mod_cast hI) hx.1
  have hy0 : 0 ≤ y := le_trans (by exact_mod_cast hJ) hy.1
  constructor
  · simp only [mulNonneg, contains]
    have h : (I.lo : ℝ) * (J.lo : ℝ) ≤ x * y := by
      exact mul_le_mul hx.1 hy.1 (by exact_mod_cast hJ) hx0
    simpa using h
  · simp only [mulNonneg, contains]
    have h : x * y ≤ (I.hi : ℝ) * (J.hi : ℝ) := by
      exact mul_le_mul hx.2 hy.2 hy0 (le_trans hx0 hx.2)
    simpa using h

/-- Multiplication by a nonnegative rational scalar. -/
def scaleNonneg (q : ℚ) (hq : 0 ≤ q) (I : RatInterval) : RatInterval :=
  ⟨q * I.lo, q * I.hi, by nlinarith [I.le, hq]⟩

theorem scaleNonneg_contains {q : ℚ} (hq : 0 ≤ q) {I : RatInterval} {x : ℝ}
    (hx : I.contains x) : (I.scaleNonneg q hq).contains ((q : ℝ) * x) := by
  constructor
  · simp only [scaleNonneg, contains]
    have h : (q : ℝ) * (I.lo : ℝ) ≤ (q : ℝ) * x := by
      exact mul_le_mul_of_nonneg_left hx.1 (by exact_mod_cast hq)
    simpa using h
  · simp only [scaleNonneg, contains]
    have h : (q : ℝ) * x ≤ (q : ℝ) * (I.hi : ℝ) := by
      exact mul_le_mul_of_nonneg_left hx.2 (by exact_mod_cast hq)
    simpa using h

/-- Natural power of a nonnegative interval. -/
def powNat (I : RatInterval) (hI : 0 ≤ I.lo) (n : ℕ) : RatInterval :=
  ⟨I.lo ^ n, I.hi ^ n, pow_le_pow_left₀ hI I.le n⟩

theorem powNat_contains {I : RatInterval} (hI : 0 ≤ I.lo) (n : ℕ)
    {x : ℝ} (hx : I.contains x) : (I.powNat hI n).contains (x ^ n) := by
  have hx0 : 0 ≤ x := le_trans (by exact_mod_cast hI) hx.1
  constructor
  · simp only [powNat, contains]
    simpa using pow_le_pow_left₀ (by exact_mod_cast hI : (0:ℝ) ≤ (I.lo:ℝ)) hx.1 n
  · simp only [powNat, contains]
    simpa using pow_le_pow_left₀ hx0 hx.2 n

/-- Reciprocal of a strictly positive interval. -/
def invPos (I : RatInterval) (hI : 0 < I.lo) : RatInterval :=
  ⟨1 / I.hi, 1 / I.lo, by
    have hhi : 0 < I.hi := lt_of_lt_of_le hI I.le
    exact one_div_le_one_div_of_le hI I.le⟩

theorem invPos_contains {I : RatInterval} (hI : 0 < I.lo) {x : ℝ}
    (hx : I.contains x) : (I.invPos hI).contains x⁻¹ := by
  have hx0 : 0 < x := lt_of_lt_of_le (by exact_mod_cast hI) hx.1
  have hhi : 0 < I.hi := lt_of_lt_of_le hI I.le
  constructor
  · simp only [invPos, contains]
    have h : (1 : ℝ) / (I.hi : ℝ) ≤ 1 / x := by
      exact one_div_le_one_div_of_le hx0 hx.2
    simpa [one_div] using h
  · simp only [invPos, contains]
    have h : (1 : ℝ) / x ≤ 1 / (I.lo : ℝ) := by
      exact one_div_le_one_div_of_le (by exact_mod_cast hI) hx.1
    simpa [one_div] using h

/-- Division by a strictly positive interval, for a nonnegative numerator. -/
def divPos (I J : RatInterval) (hI : 0 ≤ I.lo) (hJ : 0 < J.lo) : RatInterval :=
  I.mulNonneg (J.invPos hJ) hI (by
    have hhi : 0 < J.hi := lt_of_lt_of_le hJ J.le
    exact le_of_lt (one_div_pos.mpr hhi))

theorem divPos_contains {I J : RatInterval} (hI : 0 ≤ I.lo) (hJ : 0 < J.lo)
    {x y : ℝ} (hx : I.contains x) (hy : J.contains y) :
    (I.divPos J hI hJ).contains (x / y) := by
  have hinv := J.invPos_contains hJ hy
  have hhi : 0 < J.hi := lt_of_lt_of_le hJ J.le
  have hpos : (0:ℚ) ≤ 1 / J.hi := le_of_lt (one_div_pos.mpr hhi)
  have hmul := I.mulNonneg_contains hI hpos hx hinv
  simpa [divPos, div_eq_mul_inv] using hmul

/-- Negative integer power of a strictly positive interval. -/
def zpowNeg (I : RatInterval) (hI : 0 < I.lo) (n : ℕ) : RatInterval :=
  (I.powNat (le_of_lt hI) n).invPos (pow_pos hI n)

theorem zpowNeg_contains {I : RatInterval} (hI : 0 < I.lo) (n : ℕ)
    {x : ℝ} (hx : I.contains x) : (I.zpowNeg hI n).contains (x ^ (-(n : ℤ) : ℤ)) := by
  have hpow := I.powNat_contains (le_of_lt hI) n hx
  have hinv := (I.powNat (le_of_lt hI) n).invPos_contains (pow_pos hI n) hpow
  simpa [zpowNeg, zpow_neg, zpow_natCast] using hinv

/-- Maximum absolute value of the endpoints. -/
def maxAbs (I : RatInterval) : ℚ := max |I.lo| |I.hi|

theorem maxAbs_nonneg (I : RatInterval) : 0 ≤ I.maxAbs :=
  le_trans (abs_nonneg _) (le_max_left _ _)

theorem abs_le_maxAbs {I : RatInterval} {x : ℝ} (hx : I.contains x) :
    |x| ≤ (I.maxAbs : ℝ) := by
  have hmax : (0:ℚ) ≤ I.maxAbs := I.maxAbs_nonneg
  have hmaxR : (0:ℝ) ≤ (I.maxAbs : ℝ) := by exact_mod_cast hmax
  rw [abs_le]
  constructor
  · have h1 : (I.lo : ℝ) ≤ x := hx.1
    have h2 : (I.lo : ℝ) ≤ |(I.lo : ℝ)| := le_abs_self _
    have h3 : |(I.lo : ℝ)| ≤ (I.maxAbs : ℝ) := by
      rw [← Rat.cast_abs]
      exact_mod_cast (le_max_left |I.lo| |I.hi|)
    have h4 : -(I.maxAbs : ℝ) ≤ (I.lo : ℝ) := by
      have := neg_abs_le (I.lo : ℝ)
      linarith
    linarith
  · have h1 : x ≤ (I.hi : ℝ) := hx.2
    have h2 : (I.hi : ℝ) ≤ |(I.hi : ℝ)| := le_abs_self _
    have h3 : |(I.hi : ℝ)| ≤ (I.maxAbs : ℝ) := by
      rw [← Rat.cast_abs]
      exact_mod_cast (le_max_right |I.lo| |I.hi|)
    linarith

/-- Coarse multiplication using absolute endpoint bounds. -/
def mulCoarse (I J : RatInterval) : RatInterval :=
  ⟨-(I.maxAbs * J.maxAbs), I.maxAbs * J.maxAbs, by
    have h : (0:ℚ) ≤ I.maxAbs * J.maxAbs := mul_nonneg I.maxAbs_nonneg J.maxAbs_nonneg
    linarith⟩

theorem mulCoarse_contains {I J : RatInterval} {x y : ℝ}
    (hx : I.contains x) (hy : J.contains y) : (I.mulCoarse J).contains (x * y) := by
  have hx' := I.abs_le_maxAbs hx
  have hy' := J.abs_le_maxAbs hy
  have hM : (0:ℝ) ≤ (I.maxAbs : ℝ) * (J.maxAbs : ℝ) :=
    mul_nonneg (by exact_mod_cast I.maxAbs_nonneg) (by exact_mod_cast J.maxAbs_nonneg)
  have hxy : |x * y| ≤ (I.maxAbs : ℝ) * (J.maxAbs : ℝ) := by
    rw [abs_mul]
    exact mul_le_mul hx' hy' (abs_nonneg _) (by exact_mod_cast I.maxAbs_nonneg)
  constructor
  · simpa [mulCoarse, contains, Rat.cast_mul] using (abs_le.mp hxy).1
  · simpa [mulCoarse, contains, Rat.cast_mul] using (abs_le.mp hxy).2

/-- Nonnegative coarse enclosure of a square. -/
def sqNonneg (I : RatInterval) : RatInterval :=
  ⟨0, I.maxAbs * I.maxAbs, by
    exact mul_nonneg I.maxAbs_nonneg I.maxAbs_nonneg⟩

theorem sqNonneg_contains {I : RatInterval} {x : ℝ} (hx : I.contains x) :
    (I.sqNonneg).contains (x ^ 2) := by
  have hx' := I.abs_le_maxAbs hx
  have hM : (0:ℝ) ≤ (I.maxAbs : ℝ) := by exact_mod_cast I.maxAbs_nonneg
  constructor
  · simp only [sqNonneg, contains]
    have h0 : (0:ℝ) ≤ x ^ 2 := sq_nonneg x
    simpa using h0
  · simp only [sqNonneg, contains]
    have h := pow_le_pow_left₀ (abs_nonneg x) hx' 2
    simpa [sq_abs, Rat.cast_mul, pow_two] using h

/-- Reciprocal of an interval avoiding zero. -/
def invAvoid (I : RatInterval) (h : 0 < I.lo ∨ I.hi < 0) : RatInterval :=
  if h0 : 0 < I.lo then I.invPos h0
  else
    (I.neg.invPos (by
      have hhi : I.hi < 0 := by
        rcases h with h | h
        · exact absurd h h0
        · exact h
      show (0:ℚ) < -I.hi
      linarith)).neg

theorem invAvoid_contains {I : RatInterval} (h : 0 < I.lo ∨ I.hi < 0) {x : ℝ}
    (hx : I.contains x) : (I.invAvoid h).contains x⁻¹ := by
  unfold invAvoid
  split_ifs with h0
  · exact I.invPos_contains h0 hx
  · have hhi : I.hi < 0 := by
      rcases h with h | h
      · exact absurd h h0
      · exact h
    have hneg : I.neg.contains (-x) := I.neg_contains hx
    have hpos' : (0:ℚ) < (I.neg).lo := by
      show (0:ℚ) < -I.hi
      linarith
    have hinv := (I.neg).invPos_contains hpos' hneg
    have hfin := RatInterval.neg_contains hinv
    have hval : -((-x)⁻¹) = x⁻¹ := by rw [neg_inv, neg_neg]
    simpa [hval] using hfin

/-- Lower bound for `|x|` on an interval avoiding zero. -/
def absLower (I : RatInterval) (h : 0 < I.lo ∨ I.hi < 0) : ℚ :=
  if 0 < I.lo then I.lo else -I.hi

theorem absLower_pos {I : RatInterval} (h : 0 < I.lo ∨ I.hi < 0) :
    0 < I.absLower h := by
  rw [absLower]
  split_ifs with h0
  · exact h0
  · have hhi : I.hi < 0 := by
      rcases h with h | h
      · exact absurd h h0
      · exact h
    linarith

theorem absLower_le_abs {I : RatInterval} (h : 0 < I.lo ∨ I.hi < 0) {x : ℝ}
    (hx : I.contains x) : (I.absLower h : ℝ) ≤ |x| := by
  rw [absLower]
  split_ifs with h0
  · have hx0 : 0 ≤ x := le_trans (by exact_mod_cast le_of_lt h0) hx.1
    rw [abs_of_nonneg hx0]
    exact_mod_cast hx.1
  · have hhi : I.hi < 0 := by
      rcases h with h | h
      · exact absurd h h0
      · exact h
    have hx0 : x ≤ 0 := le_trans hx.2 (by exact_mod_cast le_of_lt hhi)
    rw [abs_of_nonpos hx0, Rat.cast_neg]
    linarith [hx.2]

end RatInterval

/-- Rational bounds for a real square root, from rational square comparisons. -/
theorem sqrt_rat_bounds {a lo hi : ℚ} (hlo : 0 ≤ lo) (hhi : 0 ≤ hi)
    (h1 : lo ^ 2 ≤ a) (h2 : a ≤ hi ^ 2) :
    (lo : ℝ) ≤ Real.sqrt (a : ℝ) ∧ Real.sqrt (a : ℝ) ≤ (hi : ℝ) := by
  constructor
  · have h1' : (lo : ℝ) ^ 2 ≤ (a : ℝ) := by exact_mod_cast h1
    exact Real.le_sqrt_of_sq_le h1'
  · calc Real.sqrt (a : ℝ) ≤ Real.sqrt ((hi : ℝ) ^ 2) :=
        Real.sqrt_le_sqrt (by exact_mod_cast h2)
      _ = (hi : ℝ) := Real.sqrt_sq (by exact_mod_cast hhi)

/-- Rational enclosure of `π` with 20 decimal places. -/
def piInterval : RatInterval :=
  ⟨314159265358979323846 / 100000000000000000000,
    314159265358979323847 / 100000000000000000000, by norm_num⟩

theorem piInterval_contains : piInterval.contains Real.pi := by
  constructor
  · have h := Real.pi_gt_d20
    norm_num [piInterval] at h ⊢
    linarith
  · have h := Real.pi_lt_d20
    norm_num [piInterval] at h ⊢
    linarith

/-- Componentwise containment for complex numbers. -/
def containsComplex (I : RatInterval) (z : ℂ) : Prop :=
  I.contains z.re ∧ I.contains z.im

theorem containsComplex_ofReal {I : RatInterval} {x : ℝ}
    (h0 : I.contains 0) (h : I.contains x) :
    containsComplex I (x : ℂ) := by
  constructor
  · simpa [containsComplex, RatInterval.contains, Complex.ofReal_re] using h
  · simpa [containsComplex, RatInterval.contains, Complex.ofReal_im] using h0

/-- Rational enclosure of `ζ(2) = π²/6`. -/
def zeta2Interval : RatInterval :=
  (piInterval.mulNonneg piInterval (by norm_num [piInterval]) (by norm_num [piInterval])).scaleNonneg
    (1 / 6) (by norm_num)

theorem zeta2Interval_contains : zeta2Interval.contains (riemannZeta (2 : ℂ)).re := by
  have hpi := piInterval_contains
  have hlo : (0 : ℚ) ≤ piInterval.lo := by norm_num [piInterval]
  have hmul := piInterval.mulNonneg_contains hlo hlo hpi hpi
  have hsc := (piInterval.mulNonneg piInterval hlo hlo).scaleNonneg_contains
    (show (0:ℚ) ≤ 1 / 6 by norm_num) hmul
  have hval : (riemannZeta (2 : ℂ)).re = Real.pi * Real.pi / 6 := by
    rw [riemannZeta_two]
    norm_num [Complex.div_re, Complex.mul_re, pow_two]
  rw [hval]
  simpa [zeta2Interval, div_eq_mul_inv, mul_comm, mul_assoc, mul_left_comm] using hsc

/-- Rational enclosure of `ζ(4) = π⁴/90`. -/
def zeta4Interval : RatInterval :=
  (piInterval.powNat (by norm_num [piInterval]) 4).scaleNonneg (1 / 90) (by norm_num)

theorem zeta4Interval_contains : zeta4Interval.contains (riemannZeta (4 : ℂ)).re := by
  have hpi := piInterval_contains
  have hlo : (0 : ℚ) ≤ piInterval.lo := by norm_num [piInterval]
  have hpow := piInterval.powNat_contains hlo 4 hpi
  have hsc := (piInterval.powNat hlo 4).scaleNonneg_contains
    (show (0:ℚ) ≤ 1 / 90 by norm_num) hpow
  have hc : riemannZeta (4 : ℂ) = (8 : ℂ) * (Real.pi : ℂ) ^ 4 * (1 / 30) / 24 := by
    have h := riemannZeta_two_mul_nat (k := 2) (by norm_num : (2:ℕ) ≠ 0)
    have h4 : (4 : ℂ) = 2 * (2 : ℂ) := by norm_num
    rw [h4]
    convert h using 2 <;>
      norm_num [show _root_.bernoulli 4 = (-1 / 30 : ℚ) by decide +kernel, pow_succ]
  have hval : (riemannZeta (4 : ℂ)).re = Real.pi ^ 4 / 90 := by
    rw [hc]
    norm_num [Complex.div_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, pow_succ]
    ring
  rw [hval]
  simpa [zeta4Interval, div_eq_mul_inv, mul_comm, mul_assoc, mul_left_comm] using hsc

/-- Rational enclosure of `ζ(6) = π⁶/945`. -/
def zeta6Interval : RatInterval :=
  (piInterval.powNat (by norm_num [piInterval]) 6).scaleNonneg (1 / 945) (by norm_num)

theorem zeta6Interval_contains : zeta6Interval.contains (riemannZeta (6 : ℂ)).re := by
  have hpi := piInterval_contains
  have hlo : (0 : ℚ) ≤ piInterval.lo := by norm_num [piInterval]
  have hpow := piInterval.powNat_contains hlo 6 hpi
  have hsc := (piInterval.powNat hlo 6).scaleNonneg_contains
    (show (0:ℚ) ≤ 1 / 945 by norm_num) hpow
  have hc : riemannZeta (6 : ℂ) = (32 : ℂ) * (Real.pi : ℂ) ^ 6 * (1 / 42) / 720 := by
    have h := riemannZeta_two_mul_nat (k := 3) (by norm_num : (3:ℕ) ≠ 0)
    have h6 : (6 : ℂ) = 2 * (3 : ℂ) := by norm_num
    rw [h6]
    convert h using 2 <;>
      norm_num [show _root_.bernoulli 6 = (1 / 42 : ℚ) by decide +kernel, pow_succ]
  have hval : (riemannZeta (6 : ℂ)).re = Real.pi ^ 6 / 945 := by
    rw [hc]
    norm_num [Complex.div_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, pow_succ]
    ring
  rw [hval]
  simpa [zeta6Interval, div_eq_mul_inv, mul_comm, mul_assoc, mul_left_comm] using hsc

/-- Rational interval enclosing `√a`, from rational squares bracketing `a`. -/
def sqrtInterval (a lo hi : ℚ) (hlo : 0 ≤ lo) (hhi : 0 ≤ hi)
    (h1 : lo ^ 2 ≤ a) (h2 : a ≤ hi ^ 2) : RatInterval :=
  ⟨lo, hi, by nlinarith [h1, h2, hlo, hhi]⟩

theorem sqrtInterval_contains {a lo hi : ℚ} (hlo : 0 ≤ lo) (hhi : 0 ≤ hi)
    (h1 : lo ^ 2 ≤ a) (h2 : a ≤ hi ^ 2) :
    (sqrtInterval a lo hi hlo hhi h1 h2).contains (Real.sqrt (a : ℝ)) :=
  sqrt_rat_bounds hlo hhi h1 h2

/-- Rational enclosure of `(2π)^{-2} = 1/(4π²)`. -/
def invTwoPiSqInterval : RatInterval :=
  ((piInterval.powNat (by norm_num [piInterval]) 2).invPos
    (pow_pos (by norm_num [piInterval]) 2)).scaleNonneg (1 / 4) (by norm_num)

theorem invTwoPiSqInterval_contains :
    invTwoPiSqInterval.contains ((2 * Real.pi) ^ 2)⁻¹ := by
  have hpi := piInterval_contains
  have hlo : (0 : ℚ) ≤ piInterval.lo := by norm_num [piInterval]
  have hplo : (0 : ℚ) < piInterval.lo := by norm_num [piInterval]
  have hpow := piInterval.powNat_contains hlo 2 hpi
  have hinv := (piInterval.powNat hlo 2).invPos_contains (pow_pos hplo 2) hpow
  have hsc := ((piInterval.powNat hlo 2).invPos (pow_pos hplo 2)).scaleNonneg_contains
    (show (0:ℚ) ≤ 1 / 4 by norm_num) hinv
  have hval : ((2 * Real.pi) ^ 2)⁻¹ = (1 / 4 : ℝ) * ((Real.pi ^ 2)⁻¹) := by
    field_simp
    ring
  rw [hval]
  simpa [invTwoPiSqInterval, div_eq_mul_inv, mul_comm, mul_assoc, mul_left_comm] using hsc

/-- Rational enclosure of `(2π)^{-4}`. -/
def invTwoPiFourthInterval : RatInterval :=
  invTwoPiSqInterval.powNat (by
    norm_num [invTwoPiSqInterval, piInterval, RatInterval.invPos,
      RatInterval.scaleNonneg, RatInterval.powNat]) 2

theorem invTwoPiFourthInterval_contains :
    invTwoPiFourthInterval.contains (((2 * Real.pi) ^ 4)⁻¹) := by
  have hlo : (0 : ℚ) ≤ invTwoPiSqInterval.lo := by
    norm_num [invTwoPiSqInterval, piInterval, RatInterval.invPos,
      RatInterval.scaleNonneg, RatInterval.powNat]
  have h := invTwoPiSqInterval_contains
  have h2 := invTwoPiSqInterval.powNat_contains hlo 2 h
  have hval : (((2 * Real.pi) ^ 2)⁻¹) ^ 2 = (((2 * Real.pi) ^ 4)⁻¹) := by
    rw [inv_pow]
    congr 1
    ring
  rw [← hval]
  simpa [invTwoPiFourthInterval, hlo] using h2

/-- `x^(1/2)` is the real square root. -/
theorem rpow_half_eq_sqrt (x : ℝ) : x ^ ((1:ℝ)/2) = Real.sqrt x := by
  rw [Real.sqrt_eq_rpow]

/-- Rational enclosure of `√201`, used for `(N+1)^{-1/2}` at `N = 200`. -/
def sqrt201Interval : RatInterval :=
  sqrtInterval 201 14 15 (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem sqrt201Interval_contains :
    sqrt201Interval.contains ((201 : ℝ) ^ ((1:ℝ)/2)) := by
  rw [rpow_half_eq_sqrt]
  simpa [sqrt201Interval] using
    sqrtInterval_contains (a := 201) (lo := 14) (hi := 15)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Complex intervals with rational real and imaginary parts. -/
structure ComplexInterval where
  re : RatInterval
  im : RatInterval

namespace ComplexInterval

def contains (I : ComplexInterval) (z : ℂ) : Prop :=
  I.re.contains z.re ∧ I.im.contains z.im

def add (I J : ComplexInterval) : ComplexInterval :=
  ⟨I.re.add J.re, I.im.add J.im⟩

theorem add_contains {I J : ComplexInterval} {z w : ℂ}
    (hz : I.contains z) (hw : J.contains w) : (I.add J).contains (z + w) := by
  constructor
  · simpa [ComplexInterval.add, Complex.add_re] using RatInterval.add_contains hz.1 hw.1
  · simpa [ComplexInterval.add, Complex.add_im] using RatInterval.add_contains hz.2 hw.2

def neg (I : ComplexInterval) : ComplexInterval :=
  ⟨I.re.neg, I.im.neg⟩

theorem neg_contains {I : ComplexInterval} {z : ℂ}
    (hz : I.contains z) : (I.neg).contains (-z) := by
  constructor
  · simpa [ComplexInterval.neg, Complex.neg_re] using RatInterval.neg_contains hz.1
  · simpa [ComplexInterval.neg, Complex.neg_im] using RatInterval.neg_contains hz.2

def sub (I J : ComplexInterval) : ComplexInterval := I.add J.neg

theorem sub_contains {I J : ComplexInterval} {z w : ℂ}
    (hz : I.contains z) (hw : J.contains w) : (I.sub J).contains (z - w) := by
  simpa [ComplexInterval.sub, sub_eq_add_neg] using I.add_contains hz (J.neg_contains hw)

def mul (I J : ComplexInterval) : ComplexInterval :=
  ⟨(I.re.mulCoarse J.re).sub (I.im.mulCoarse J.im),
   (I.re.mulCoarse J.im).add (I.im.mulCoarse J.re)⟩

theorem mul_contains {I J : ComplexInterval} {z w : ℂ}
    (hz : I.contains z) (hw : J.contains w) : (I.mul J).contains (z * w) := by
  constructor
  · simpa [ComplexInterval.mul, Complex.mul_re] using
      RatInterval.sub_contains
        (RatInterval.mulCoarse_contains hz.1 hw.1)
        (RatInterval.mulCoarse_contains hz.2 hw.2)
  · simpa [ComplexInterval.mul, Complex.mul_im] using
      RatInterval.add_contains
        (RatInterval.mulCoarse_contains hz.1 hw.2)
        (RatInterval.mulCoarse_contains hz.2 hw.1)

/-- Complex conjugation of an interval. -/
def conj (I : ComplexInterval) : ComplexInterval :=
  ⟨I.re, I.im.neg⟩

theorem conj_contains {I : ComplexInterval} {z : ℂ}
    (hz : I.contains z) : (I.conj).contains (starRingEnd ℂ z) := by
  constructor
  · simpa [ComplexInterval.conj, Complex.conj_re] using hz.1
  · simpa [ComplexInterval.conj, Complex.conj_im] using RatInterval.neg_contains hz.2

/-- Coarse upper enclosure of `|z|²`. -/
def normSqUpper (I : ComplexInterval) : RatInterval :=
  (I.re.sqNonneg).add (I.im.sqNonneg)

theorem normSqUpper_contains {I : ComplexInterval} {z : ℂ}
    (hz : I.contains z) : (I.normSqUpper).contains ((Complex.normSq z : ℝ)) := by
  have h1 := RatInterval.sqNonneg_contains hz.1
  have h2 := RatInterval.sqNonneg_contains hz.2
  have h := RatInterval.add_contains h1 h2
  simpa [ComplexInterval.normSqUpper, Complex.normSq_apply, pow_two] using h

/-- Lower bound on `|z|²` from a real-part lower bound. -/
def normSqLower (I : ComplexInterval) (h : 0 < I.re.lo ∨ I.re.hi < 0) : ℚ :=
  (I.re.absLower h) ^ 2

theorem normSqLower_le {I : ComplexInterval} (h : 0 < I.re.lo ∨ I.re.hi < 0)
    {z : ℂ} (hz : I.contains z) :
    (I.normSqLower h : ℝ) ≤ Complex.normSq z := by
  have hm : (I.re.absLower h : ℝ) ≤ |z.re| := RatInterval.absLower_le_abs h hz.1
  have hm2 : ((I.re.absLower h : ℝ)) ^ 2 ≤ |z.re| ^ 2 :=
    pow_le_pow_left₀ (by exact_mod_cast le_of_lt (RatInterval.absLower_pos h)) hm 2
  have hre : |z.re| ^ 2 = z.re ^ 2 := sq_abs _
  have hsq : (0:ℝ) ≤ z.im ^ 2 := sq_nonneg _
  simp only [normSqLower, Complex.normSq_apply]
  rw [hre] at hm2
  have hgoal : ((I.re.absLower h : ℝ)) ^ 2 ≤ z.re ^ 2 + z.im ^ 2 := by linarith
  simpa [Rat.cast_pow, Complex.normSq_apply, pow_two] using hgoal

/-- Embedding of a real interval as a complex interval with zero imaginary part. -/
def ofReal (I : RatInterval) : ComplexInterval :=
  ⟨I, RatInterval.exact 0⟩

theorem ofReal_contains {I : RatInterval} {x : ℝ} (hx : I.contains x) :
    (ofReal I).contains (x : ℂ) := by
  constructor
  · simpa [ofReal] using hx
  · constructor <;> simp [ofReal, RatInterval.exact]

/-- Complex inverse, using `1/z = conj z / |z|²`. -/
def inv (I : ComplexInterval) (h : 0 < I.re.lo ∨ I.re.hi < 0)
    (hle : I.normSqLower h ≤ (I.normSqUpper).hi) : ComplexInterval :=
  I.conj.mul (ofReal
    (((⟨I.normSqLower h, (I.normSqUpper).hi, hle⟩ : RatInterval)).invPos
      (pow_pos (RatInterval.absLower_pos h) 2)))

theorem inv_contains {I : ComplexInterval} (h : 0 < I.re.lo ∨ I.re.hi < 0)
    (hle : I.normSqLower h ≤ (I.normSqUpper).hi) {z : ℂ} (hz : I.contains z) :
    (I.inv h hle).contains z⁻¹ := by
  have hD : (⟨I.normSqLower h, (I.normSqUpper).hi, hle⟩ : RatInterval).contains
      (Complex.normSq z : ℝ) := by
    constructor
    · exact I.normSqLower_le h hz
    · exact (I.normSqUpper_contains hz).2
  have hinv := (⟨I.normSqLower h, (I.normSqUpper).hi, hle⟩ : RatInterval).invPos_contains
    (pow_pos (RatInterval.absLower_pos h) 2) hD
  have hreal := ComplexInterval.ofReal_contains hinv
  have hconj := I.conj_contains hz
  have hmul := ComplexInterval.mul_contains hconj hreal
  have hval : (starRingEnd ℂ z) * (((Complex.normSq z : ℝ))⁻¹ : ℂ) = z⁻¹ := by
    by_cases h0 : Complex.normSq z = 0
    · have hz0 : z = 0 := Complex.normSq_eq_zero.mp h0
      simp [hz0]
    · apply Complex.ext <;>
        simp [Complex.mul_re, Complex.mul_im, Complex.inv_re, Complex.inv_im,
          div_eq_mul_inv, h0] <;>
        field_simp [h0] <;> ring
  simpa [ComplexInterval.inv, hval] using hmul

end ComplexInterval

/-- `|cos x| ≤ 1`. -/
theorem abs_cos_le_one (x : ℝ) : |Real.cos x| ≤ 1 := Real.abs_cos_le_one x

/-- `|sin x| ≤ 1`. -/
theorem abs_sin_le_one (x : ℝ) : |Real.sin x| ≤ 1 := Real.abs_sin_le_one x

/-- `exp` is monotone. -/
theorem exp_le_exp {x y : ℝ} (h : x ≤ y) : Real.exp x ≤ Real.exp y :=
  Real.exp_le_exp.mpr h

/-- `log` is monotone on positive reals. -/
theorem log_le_log {x y : ℝ} (hx : 0 < x) (h : x ≤ y) : Real.log x ≤ Real.log y :=
  Real.log_le_log hx h

/-- Round a rational down to the grid `g`. -/
def gridDown (g q : ℚ) : ℚ := (Rat.floor (q / g) : ℚ) * g

/-- Round a rational up to the grid `g`. -/
def gridUp (g q : ℚ) : ℚ := (Rat.ceil (q / g) : ℚ) * g

theorem gridDown_le {g q : ℚ} (hg : 0 < g) : gridDown g q ≤ q := by
  have h := Rat.floor_le (q / g)
  have hcast : ((Rat.floor (q / g) : ℤ) : ℚ) ≤ q / g := h
  have hmul : ((Rat.floor (q / g) : ℤ) : ℚ) * g ≤ (q / g) * g := by
    exact mul_le_mul_of_nonneg_right hcast (le_of_lt hg)
  rw [div_mul_cancel₀ q (ne_of_gt hg)] at hmul
  simpa [gridDown] using hmul

theorem le_gridUp {g q : ℚ} (hg : 0 < g) : q ≤ gridUp g q := by
  have h := Rat.le_ceil (x := q / g)
  have hcast : q / g ≤ ((Rat.ceil (q / g) : ℤ) : ℚ) := h
  have hmul : (q / g) * g ≤ ((Rat.ceil (q / g) : ℤ) : ℚ) * g := by
    exact mul_le_mul_of_nonneg_right hcast (le_of_lt hg)
  rw [div_mul_cancel₀ q (ne_of_gt hg)] at hmul
  simpa [gridUp] using hmul

/-- Snap a rational interval outward to the grid `g`. -/
def snap (g : ℚ) (hg : 0 < g) (I : RatInterval) : RatInterval :=
  ⟨gridDown g I.lo, gridUp g I.hi, by
    exact le_trans (gridDown_le hg) (le_trans I.le (le_gridUp hg))⟩

theorem snap_contains {g : ℚ} (hg : 0 < g) {I : RatInterval} {x : ℝ}
    (hx : I.contains x) : (snap g hg I).contains x := by
  constructor
  · have h1 : (gridDown g I.lo : ℚ) ≤ I.lo := gridDown_le hg
    exact le_trans (by exact_mod_cast h1) hx.1
  · have h2 : I.hi ≤ gridUp g I.hi := le_gridUp hg
    exact le_trans hx.2 (by exact_mod_cast h2)

/-- Snapped addition: outward-rounded sum on the grid. -/
def addSnap (g : ℚ) (hg : 0 < g) (I J : RatInterval) : RatInterval :=
  snap g hg (I.add J)

theorem addSnap_contains {g : ℚ} (hg : 0 < g) {I J : RatInterval} {x y : ℝ}
    (hx : I.contains x) (hy : J.contains y) : (addSnap g hg I J).contains (x + y) :=
  snap_contains hg (I.add_contains hx hy)

/-- Floor of `q/g`, using integer division on numerators. -/
def gridDownInt (g q : ℚ) : ℚ :=
  ((Int.ediv (q.num * g.den) (q.den * g.num) : ℤ) : ℚ) * g

theorem gridDownInt_le {g q : ℚ} (hg : 0 < g) : gridDownInt g q ≤ q := by
  have hqden : (0:ℤ) < (q.den : ℤ) := by exact_mod_cast q.den_pos
  have hgnum : (0:ℤ) < g.num := Rat.num_pos.mpr hg
  have hD : (0:ℤ) < q.den * g.num := mul_pos hqden hgnum
  have hDq : (0:ℚ) < ((q.den * g.num : ℤ) : ℚ) := by exact_mod_cast hD
  have hqden0 : (q.den : ℚ) ≠ 0 := by exact_mod_cast (ne_of_gt q.den_pos)
  have hgden0 : (g.den : ℚ) ≠ 0 := by exact_mod_cast (ne_of_gt g.den_pos)
  have hfloor := Int.ediv_mul_le (q.num * g.den) (ne_of_gt hD)
  have hfloorQ : (((Int.ediv (q.num * g.den) (q.den * g.num) : ℤ) : ℚ) *
      ((q.den * g.num : ℤ) : ℚ)) ≤ ((q.num * g.den : ℤ) : ℚ) := by
    exact_mod_cast hfloor
  have hle : ((Int.ediv (q.num * g.den) (q.den * g.num) : ℤ) : ℚ) ≤
      ((q.num * g.den : ℤ) : ℚ) / ((q.den * g.num : ℤ) : ℚ) :=
    (le_div_iff₀ hDq).mpr (by simpa [mul_comm] using hfloorQ)
  have hq : q * (q.den : ℚ) = (q.num : ℚ) := by
    nth_rewrite 1 [← Rat.num_div_den q]
    rw [div_mul_cancel₀ _ hqden0]
  have hg' : g * (g.den : ℚ) = (g.num : ℚ) := by
    nth_rewrite 1 [← Rat.num_div_den g]
    rw [div_mul_cancel₀ _ hgden0]
  have hqg : q / g = ((q.num * g.den : ℤ) : ℚ) / ((q.den * g.num : ℤ) : ℚ) := by
    rw [div_eq_div_iff (ne_of_gt hg) (by simpa using (ne_of_gt hDq))]
    push_cast
    calc q * (↑q.den * ↑g.num) = (q * ↑q.den) * ↑g.num := by ring
      _ = ↑q.num * ↑g.num := by rw [hq]
      _ = ↑q.num * (g * ↑g.den) := by rw [hg']
      _ = ↑q.num * ↑g.den * g := by ring
  calc gridDownInt g q
      = ((Int.ediv (q.num * g.den) (q.den * g.num) : ℤ) : ℚ) * g := rfl
    _ ≤ (((q.num * g.den : ℤ) : ℚ) / ((q.den * g.num : ℤ) : ℚ)) * g :=
        mul_le_mul_of_nonneg_right hle (le_of_lt hg)
    _ = q := by rw [← hqg]; field_simp

/-- Ceiling of `q/g`, via negation of the floor. -/
def gridUpInt (g q : ℚ) : ℚ := - gridDownInt g (-q)

theorem le_gridUpInt {g q : ℚ} (hg : 0 < g) : q ≤ gridUpInt g q := by
  have h := gridDownInt_le (g := g) (q := -q) hg
  simp only [gridUpInt]
  linarith

/-- Snapped interval using integer-division rounding. -/
def snapInt (g : ℚ) (hg : 0 < g) (I : RatInterval) : RatInterval :=
  ⟨gridDownInt g I.lo, gridUpInt g I.hi, by
    exact le_trans (gridDownInt_le hg) (le_trans I.le (le_gridUpInt hg))⟩

theorem snapInt_contains {g : ℚ} (hg : 0 < g) {I : RatInterval} {x : ℝ}
    (hx : I.contains x) : (snapInt g hg I).contains x := by
  constructor
  · have h1 : (gridDownInt g I.lo : ℚ) ≤ I.lo := gridDownInt_le hg
    exact le_trans (by exact_mod_cast h1) hx.1
  · have h2 : I.hi ≤ gridUpInt g I.hi := le_gridUpInt hg
    exact le_trans hx.2 (by exact_mod_cast h2)

end FiniteWindowZeros
