import EulerMaclaurin
import Transcend

noncomputable section
namespace PartialTail

open scoped BigOperators
open MeasureTheory Set

/-! ## A crude bound on `ζ` at odd integers -/



/-- The bound `ζ(m) ≤ 1 + 1/(m−1)` for natural `m ≥ 2`, stated for the real
part of `riemannZeta (m : ℂ)`. -/
theorem riemannZeta_nat_re_le' {m : ℕ} (hm : 2 ≤ m) :
    (riemannZeta (m : ℂ)).re ≤ 1 + 1 / ((m : ℝ) - 1) := by
  have hm1 : 1 < m := by omega
  have hmR : (1 : ℝ) < (m : ℝ) := by exact_mod_cast hm1
  let g : ℕ → ℝ := fun n => 1 / ((n : ℝ) + 1) ^ m
  have hgsum : Summable g := by
    have hbase : Summable (fun n : ℕ => 1 / (n : ℝ) ^ (m : ℝ)) :=
      Real.summable_one_div_nat_rpow.mpr hmR
    have hshift : Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ (m : ℝ)) := by
      simpa only [Nat.cast_add, Nat.cast_one] using (summable_nat_add_iff 1).2 hbase
    simpa only [g, Real.rpow_natCast] using hshift
  have hzre : (riemannZeta (m : ℂ)).re = ∑' n, g n := by
    have hz := zeta_eq_tsum_one_div_nat_add_one_cpow (s := (m : ℂ)) (by simpa using hmR)
    have hterm (n : ℕ) : (1 / ((n : ℂ) + 1) ^ (m : ℂ)) = ((g n : ℝ) : ℂ) := by
      have hpos : (0 : ℝ) ≤ (n : ℝ) + 1 := by positivity
      have hcast : ((n : ℂ) + 1) = (((n : ℝ) + 1 : ℝ) : ℂ) := by
        push_cast
        ring
      rw [hcast]
      change 1 / ((((n : ℝ) + 1 : ℝ) : ℂ) ^ ((m : ℝ) : ℂ)) = ((g n : ℝ) : ℂ)
      rw [← Complex.ofReal_cpow hpos (m : ℝ), Real.rpow_natCast]
      simp [g, Complex.ofReal_inv]
    calc
      (riemannZeta (m : ℂ)).re = (∑' n : ℕ, 1 / ((n : ℂ) + 1) ^ (m : ℂ)).re := by rw [hz]
      _ = (∑' n : ℕ, ((g n : ℝ) : ℂ)).re := by
        rw [tsum_congr hterm]
      _ = ((∑' n : ℕ, g n : ℝ) : ℂ).re := by rw [Complex.ofReal_tsum]
      _ = ∑' n : ℕ, g n := Complex.ofReal_re _
  have hsplit : ∑' n, g n = 1 + ∑' n, g (n + 1) := by
    simpa [g] using hgsum.tsum_eq_zero_add
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-(m : ℝ))) (Ici 1) := by
    refine (Real.antitoneOn_rpow_Ioi_of_exponent_nonpos ?_).mono ?_
    · exact neg_nonpos.mpr (Nat.cast_nonneg m)
    · intro x hx
      exact lt_of_lt_of_le zero_lt_one (by simpa using hx)
  have hint : IntegrableOn (fun x : ℝ => x ^ (-(m : ℝ))) (Ioi 1) :=
    integrableOn_Ioi_rpow_of_lt (by linarith : (-(m : ℝ)) < -1) zero_lt_one
  have hnonneg : ∀ t ∈ Ioi (1 : ℝ), 0 ≤ t ^ (-(m : ℝ)) := by
    intro t ht
    exact Real.rpow_nonneg (le_of_lt (lt_trans zero_lt_one ht)) _
  have hanti' : AntitoneOn (fun x : ℝ => x ^ (-(m : ℝ))) (Ici (((1 : ℕ) : ℝ))) := by
    simpa using hanti
  have hint' : IntegrableOn (fun x : ℝ => x ^ (-(m : ℝ))) (Ioi (((1 : ℕ) : ℝ))) := by
    simpa only [Nat.cast_one] using hint
  have hnonneg' : ∀ t ∈ Ioi (((1 : ℕ) : ℝ)), 0 ≤ t ^ (-(m : ℝ)) := by
    simpa only [Nat.cast_one] using hnonneg
  have hbound := AntitoneOn.tsum_comp_add_le_integral (N := 1)
    (f := fun x : ℝ => x ^ (-(m : ℝ))) hanti' hint' hnonneg'
  have hbound' : ∑' n, g (n + 1) ≤ 1 / ((m : ℝ) - 1) := by
    have hfun : (fun n : ℕ => (fun x : ℝ => x ^ (-(m : ℝ))) (n + 1 + 1 : ℕ)) =
        (fun n : ℕ => g (n + 1)) := by
      funext n
      change (((n + 1 + 1 : ℕ) : ℝ)) ^ (-(m : ℝ)) = 1 / (((n + 1 : ℕ) : ℝ) + 1) ^ m
      rw [Real.rpow_neg (by positivity), Real.rpow_natCast, one_div]
      simp only [Nat.cast_add, Nat.cast_one]
    rw [hfun] at hbound
    convert hbound using 1
    rw [show (((1 : ℕ) : ℝ)) = (1 : ℝ) by norm_num]
    rw [integral_Ioi_rpow_of_lt (by linarith : (-(m : ℝ)) < -1) zero_lt_one]
    have hmne : (1 : ℝ) - (m : ℝ) ≠ 0 := by linarith
    simp only [Real.one_rpow]
    field_simp [hmne]
    simp only [one_div]
    rw [show (-(m : ℝ) + 1) = -((m : ℝ) - 1) by ring, inv_neg]
    simp
  calc
    (riemannZeta (m : ℂ)).re = ∑' n, g n := hzre
    _ = 1 + ∑' n, g (n + 1) := hsplit
    _ ≤ 1 + 1 / ((m : ℝ) - 1) := by gcongr

/-- A very crude bound: `ζ(m) ≤ 2` for odd natural `m ≥ 3`. -/
theorem riemannZeta_nat_re_le_two {k : ℕ} (hk : 1 ≤ k) :
    (riemannZeta ((2 * k + 1 : ℕ) : ℂ)).re ≤ 2 := by
  have hm : 2 ≤ 2 * k + 1 := by omega
  have h := riemannZeta_nat_re_le' hm
  have hmR : (2 : ℝ) ≤ ((2 * k + 1 : ℕ) : ℝ) := by
    have h2 : (2 : ℕ) ≤ 2 * k + 1 := by omega
    exact_mod_cast h2
  have hpos : (0 : ℝ) < ((2 * k + 1 : ℕ) : ℝ) - 1 := by linarith
  have h1 : (1 : ℝ) / (((2 * k + 1 : ℕ) : ℝ) - 1) ≤ 1 := by
    rw [div_le_iff₀ hpos]
    linarith
  linarith



/-- **W1: the domain bridge.** At `a = 1` the non-periodic Hurwitz zeta is the
Riemann zeta. -/
theorem zeta_eq_hurwitzZetaNP_one {s : ℂ} (hs : s ≠ 0) :
    hurwitzZetaNP 1 s = riemannZeta s := by
  rw [hurwitzZetaNP]
  have hfract : Int.fract (1 : ℝ) = 0 := by norm_num [Int.fract]
  have hfloor : Int.floor (1 : ℝ) = 1 := by norm_num [Int.floor]
  rw [hfract, hfloor]
  norm_num
  rw [Complex.zero_cpow (neg_ne_zero.mpr hs)]
  simp [HurwitzZeta.hurwitzZeta_zero]

/-- The symmetric rational ball of radius `r` around `0`. -/
def ball (r : ℚ) : Cx := ⟨⟨-r, r⟩, ⟨-r, r⟩⟩

theorem mem_ball_of_norm_le {z : ℂ} {r : ℚ} (hr : 0 ≤ r) (h : ‖z - 0‖ ≤ (r : ℝ)) :
    (ball r).mem z := by
  have hz : Cx.mem (z - 0) (Cx.inflate r (⟨⟨0, 0⟩, ⟨0, 0⟩⟩ : Cx)) := by
    apply Cx.mem_inflate_of_norm_sub_le (Z := (⟨⟨0, 0⟩, ⟨0, 0⟩⟩ : Cx)) (w := 0) (r := r)
    · refine ⟨?_, ?_⟩ <;> simp [Iv.memR]
    · exact hr
    · simpa using h
  simpa [ball, Cx.inflate, Iv.inflate, Cx.mem, Iv.memR] using hz

lemma norm_cpow_le_rpow_re {b : ℝ} (hb : 0 < b) (z : ℂ) :
    ‖(b : ℂ) ^ z‖ = b ^ z.re :=
  Complex.norm_cpow_eq_rpow_re_of_pos hb z

/-- At a base `b ≥ 1`, the modulus of `b^{-s}` is bounded by `b^{-lo}` on `S`. -/
theorem norm_cpow_neg_le {b : ℝ} (hb : 1 ≤ b) {S : Cx} {s : ℂ} (hs : Cx.mem s S) :
    ‖(b : ℂ) ^ (-s)‖ ≤ b ^ (-(S.re.lo : ℝ)) := by
  have hb0 : 0 < b := lt_of_lt_of_le zero_lt_one hb
  rw [norm_cpow_le_rpow_re hb0]
  have hre : (S.re.lo : ℝ) ≤ s.re := hs.1.1
  have hneg : (-s).re ≤ (-(S.re.lo : ℝ)) := by
    rw [Complex.neg_re]
    linarith
  exact Real.rpow_le_rpow_of_exponent_le hb hneg

/-- The integer floor of the lower real bound. -/
def lowerNat (S : Cx) : ℕ := (Int.floor S.re.lo).toNat

lemma lowerNat_cast_le {S : Cx} (hS : 0 ≤ S.re.lo) :
    ((lowerNat S : ℕ) : ℝ) ≤ (S.re.lo : ℝ) := by
  have h0 : 0 ≤ Int.floor S.re.lo := Int.floor_nonneg.mpr (by exact_mod_cast hS)
  have h := Int.floor_le S.re.lo
  have hcast : ((Int.floor S.re.lo).toNat : ℤ) = Int.floor S.re.lo :=
    Int.toNat_of_nonneg h0
  have hcastR : ((lowerNat S : ℕ) : ℝ) = ((Int.floor S.re.lo : ℤ) : ℝ) := by
    rw [lowerNat]
    exact_mod_cast hcast
  rw [hcastR]
  exact_mod_cast h

/-- Rational radius bounding `b^{-s}` for all `s ∈ S`, given `1 ≤ b`. -/
def cpowRadius (b : ℚ) (S : Cx) : ℚ := ((b ^ lowerNat S) : ℚ)⁻¹

theorem norm_cpow_neg_le_radius {b : ℚ} (hb : 1 ≤ b) {S : Cx} (hS : 0 ≤ S.re.lo)
    {s : ℂ} (hs : Cx.mem s S) :
    ‖((b : ℝ) : ℂ) ^ (-s)‖ ≤ (cpowRadius b S : ℝ) := by
  have hbR : (1 : ℝ) ≤ (b : ℝ) := by exact_mod_cast hb
  have hb0 : (0 : ℝ) < (b : ℝ) := lt_of_lt_of_le zero_lt_one hbR
  refine (norm_cpow_neg_le hbR hs).trans ?_
  have hexp : (-(S.re.lo : ℝ)) ≤ -((lowerNat S : ℕ) : ℝ) := by
    have := lowerNat_cast_le hS; linarith
  refine (Real.rpow_le_rpow_of_exponent_le hbR hexp).trans_eq ?_
  rw [cpowRadius]
  rw [show (-((lowerNat S : ℕ) : ℝ)) = -((lowerNat S : ℕ) : ℤ) by push_cast; ring]
  rw [Real.rpow_neg (le_of_lt hb0), Real.rpow_intCast, Rat.cast_inv, Rat.cast_pow]
  rfl


/-! ## Bounding the rising factorial on a rectangle -/

/-- Maximum of the absolute endpoint values. -/
def absMax (I : Iv) : ℚ := max |I.lo| |I.hi|

theorem absMax_nonneg (I : Iv) : 0 ≤ absMax I :=
  le_trans (abs_nonneg I.lo) (le_max_left _ _)

theorem abs_le_absMax {x : ℝ} {I : Iv} (hx : I.memR x) :
    |x| ≤ (absMax I : ℝ) := by
  have hlo : (I.lo : ℝ) ≤ x := hx.1
  have hhi : x ≤ (I.hi : ℝ) := hx.2
  have h1 : |x| ≤ max |(I.lo : ℝ)| |(I.hi : ℝ)| := by
    rw [abs_le]
    constructor
    · have : -(I.lo : ℝ) ≤ |(I.lo : ℝ)| := neg_le_abs _
      have hle : |(I.lo : ℝ)| ≤ max |(I.lo : ℝ)| |(I.hi : ℝ)| := le_max_left _ _
      linarith
    · have : (I.hi : ℝ) ≤ |(I.hi : ℝ)| := le_abs_self _
      have hle : |(I.hi : ℝ)| ≤ max |(I.lo : ℝ)| |(I.hi : ℝ)| := le_max_right _ _
      linarith
  have hcast : ((absMax I : ℚ) : ℝ) = max |(I.lo : ℝ)| |(I.hi : ℝ)| := by
    rw [absMax, Rat.cast_max, Rat.cast_abs, Rat.cast_abs]
  rw [hcast]
  exact h1

/-- A rational radius for the whole rectangle, in the norm. -/
def sRadius (S : Cx) : ℚ := absMax S.re + absMax S.im

theorem sRadius_nonneg (S : Cx) : 0 ≤ sRadius S :=
  add_nonneg (absMax_nonneg S.re) (absMax_nonneg S.im)

theorem norm_le_sRadius {S : Cx} {s : ℂ} (hs : Cx.mem s S) :
    ‖s‖ ≤ (sRadius S : ℝ) := by
  have h1 : ‖s‖ ≤ |s.re| + |s.im| := Complex.norm_le_abs_re_add_abs_im s
  have h2 : |s.re| ≤ (absMax S.re : ℝ) := abs_le_absMax hs.1
  have h3 : |s.im| ≤ (absMax S.im : ℝ) := abs_le_absMax hs.2
  have hcast : ((sRadius S : ℚ) : ℝ) = (absMax S.re : ℝ) + (absMax S.im : ℝ) := by
    rw [sRadius, Rat.cast_add]
  rw [hcast]
  linarith

def risingRadius (Rs : ℚ) (n : ℕ) : ℚ := ∏ i ∈ Finset.range n, (Rs + (i : ℚ))

theorem risingRadius_nonneg {Rs : ℚ} (hRs : 0 ≤ Rs) (n : ℕ) : 0 ≤ risingRadius Rs n :=
  Finset.prod_nonneg fun i _ => add_nonneg hRs (Nat.cast_nonneg i)

theorem norm_rising_le {s : ℂ} {Rs : ℚ} (hRs : 0 ≤ Rs) (hs : ‖s‖ ≤ (Rs : ℝ)) (n : ℕ) :
    ‖rising s n‖ ≤ (risingRadius Rs n : ℝ) := by
  induction n with
  | zero => simp [rising, risingRadius]
  | succ n ih =>
      rw [rising_succ, risingRadius, Finset.prod_range_succ]
      have hfac : ‖s + (n : ℂ)‖ ≤ (Rs : ℝ) + (n : ℝ) := by
        calc
          ‖s + (n : ℂ)‖ ≤ ‖s‖ + ‖(n : ℂ)‖ := norm_add_le _ _
          _ = ‖s‖ + (n : ℝ) := by simp
          _ ≤ (Rs : ℝ) + (n : ℝ) := add_le_add hs le_rfl
      rw [norm_mul]
      have hcast : (((Rs + (n : ℚ)) : ℚ) : ℝ) = (Rs : ℝ) + (n : ℝ) := by push_cast; ring
      rw [Rat.cast_mul, hcast]
      exact mul_le_mul ih hfac (norm_nonneg _) (by exact_mod_cast risingRadius_nonneg hRs n)

/-! ## The integral atom -/

/-- Rational radius for `∫_M^∞ (1+x)^{-s} dx`. -/
def integralRadius (S : Cx) (M : ℕ) : ℚ :=
  ((M + 1 : ℚ) ^ ((1 : ℤ) - (lowerNat S : ℤ))) / (S.re.lo - 1)

theorem integralRadius_nonneg {S : Cx} (hS : 1 < S.re.lo) (M : ℕ) :
    0 ≤ integralRadius S M := by
  have hlo : (0 : ℚ) < S.re.lo - 1 := by linarith
  have hbase : (0 : ℚ) ≤ (M + 1 : ℚ) := by positivity
  unfold integralRadius
  positivity

theorem norm_integral_le_radius {S : Cx} (hS : 1 < S.re.lo) (M : ℕ) (hM : 1 ≤ M)
    {s : ℂ} (hs : Cx.mem s S) :
    ‖∫ x : ℝ in Set.Ioi (M : ℝ), (((1 + x : ℝ) : ℂ) ^ (-s))‖ ≤
      (integralRadius S M : ℝ) := by
  have hSR : (1 : ℝ) < (S.re.lo : ℝ) := by exact_mod_cast hS
  have hsre : 1 < s.re := by linarith [hs.1.1]
  have hMpos : (0 : ℝ) < 1 + (M : ℝ) := by
    have : (0 : ℝ) ≤ (M : ℝ) := by exact_mod_cast (Nat.zero_le M)
    linarith
  have hInt := integral_Ioi_norm_iteratedDeriv_hurwitzTerm (a := 1) (M := (M : ℝ))
    (by linarith) (s := s) hsre 0
  have hnorm : ‖∫ x : ℝ in Set.Ioi (M : ℝ), (((1 + x : ℝ) : ℂ) ^ (-s))‖ ≤
      ∫ x : ℝ in Set.Ioi (M : ℝ), ‖(((1 + x : ℝ) : ℂ) ^ (-s))‖ :=
    MeasureTheory.norm_integral_le_integral_norm _
  have h0 : (∫ x : ℝ in Set.Ioi (M : ℝ), ‖(((1 + x : ℝ) : ℂ) ^ (-s))‖) =
      (1 + (M : ℝ)) ^ (1 - s.re) / (s.re - 1) := by
    simpa using hInt
  rw [h0] at hnorm
  have hbase : (1 : ℝ) ≤ 1 + (M : ℝ) := by linarith
  have hn_le : ((lowerNat S : ℕ) : ℝ) ≤ S.re.lo := by
    have h0 : 0 ≤ S.re.lo := by linarith
    exact lowerNat_cast_le h0
  have hexp : 1 - s.re ≤ 1 - ((lowerNat S : ℕ) : ℝ) := by
    have : ((lowerNat S : ℕ) : ℝ) ≤ s.re := le_trans hn_le hs.1.1
    linarith
  have hnum : (1 + (M : ℝ)) ^ (1 - s.re) ≤ (1 + (M : ℝ)) ^ (1 - ((lowerNat S : ℕ) : ℝ)) :=
    Real.rpow_le_rpow_of_exponent_le hbase hexp
  have hnum0 : (0 : ℝ) ≤ (1 + (M : ℝ)) ^ (1 - s.re) :=
    Real.rpow_nonneg (by linarith) _
  have hden : (0 : ℝ) < s.re - 1 := by linarith
  have hdenle : (0 : ℝ) < (S.re.lo : ℝ) - 1 := by linarith
  have hfrac : (1 + (M : ℝ)) ^ (1 - s.re) / (s.re - 1) ≤
      (1 + (M : ℝ)) ^ (1 - ((lowerNat S : ℕ) : ℝ)) / ((S.re.lo : ℝ) - 1) := by
    refine div_le_div₀ (Real.rpow_nonneg (by linarith) _) hnum hdenle ?_
    linarith [hs.1.1]
  refine hnorm.trans (hfrac.trans ?_)
  have hcast : (((M + 1 : ℚ) ^ ((1 : ℤ) - (lowerNat S : ℤ)) : ℚ) : ℝ) =
      (1 + (M : ℝ)) ^ (1 - ((lowerNat S : ℕ) : ℝ)) := by
    rw [Rat.cast_zpow,
      show (((M + 1 : ℚ) : ℚ) : ℝ) = 1 + (M : ℝ) by push_cast; ring,
      ← Real.rpow_intCast]
    push_cast
    ring
  have hdencast : (((S.re.lo - 1 : ℚ)) : ℝ) = (S.re.lo : ℝ) - 1 := by push_cast; ring
  unfold integralRadius
  rw [Rat.cast_div, hcast, hdencast]


/-! ## Bounds for the power atoms -/

theorem norm_cpow_neg_sub_le {b : ℚ} (hb : 1 ≤ b) {S : Cx} (hS : 1 < S.re.lo)
    {s : ℂ} (hs : Cx.mem s S) (n : ℕ) :
    ‖((b : ℝ) : ℂ) ^ (-s - n)‖ ≤ (((b ^ (lowerNat S + n)) : ℚ)⁻¹ : ℝ) := by
  have hbR : (1 : ℝ) ≤ (b : ℝ) := by exact_mod_cast hb
  have hb0 : (0 : ℝ) < (b : ℝ) := lt_of_lt_of_le zero_lt_one hbR
  rw [norm_cpow_le_rpow_re hb0]
  have hre : (-s - (n : ℂ)).re = -(s.re + (n : ℝ)) := by
    rw [Complex.sub_re, Complex.neg_re, Complex.natCast_re]
    ring
  rw [hre]
  have h1 : ((lowerNat S : ℕ) : ℝ) ≤ S.re.lo := lowerNat_cast_le (by linarith)
  have h2 : ((lowerNat S : ℕ) : ℝ) ≤ s.re := le_trans h1 hs.1.1
  have hexp_le : -(s.re + (n : ℝ)) ≤ -(((lowerNat S + n : ℕ) : ℕ) : ℝ) := by
    push_cast
    linarith
  have hpow : (b : ℝ) ^ (-(((lowerNat S + n : ℕ)) : ℝ)) =
      (((b ^ (lowerNat S + n)) : ℚ)⁻¹ : ℝ) := by
    rw [Real.rpow_neg (le_of_lt hb0), Real.rpow_natCast]
    push_cast
    rfl
  exact (Real.rpow_le_rpow_of_exponent_le hbR hexp_le).trans_eq hpow

theorem cpowRadius_nonneg {b : ℚ} (hb : 1 ≤ b) (S : Cx) : 0 ≤ cpowRadius b S := by
  have hb0 : (0 : ℚ) < b := by linarith
  unfold cpowRadius
  positivity

/-- Radius for the boundary term `b^{-s}/2`. -/
def boundaryRadius (S : Cx) (M : ℕ) : ℚ := cpowRadius (M + 1) S / 2

theorem boundaryRadius_nonneg (S : Cx) (M : ℕ) : 0 ≤ boundaryRadius S M := by
  unfold boundaryRadius cpowRadius
  positivity

theorem norm_boundary_le {S : Cx} (hS : 1 < S.re.lo) (M : ℕ) {s : ℂ} (hs : Cx.mem s S) :
    ‖(((1 + (M : ℝ) : ℝ) : ℂ) ^ (-s)) / 2‖ ≤ (boundaryRadius S M : ℝ) := by
  have hM1 : (1 : ℚ) ≤ (M + 1 : ℚ) := by
    have : (0 : ℚ) ≤ (M : ℚ) := by positivity
    linarith
  have hb := norm_cpow_neg_le_radius (b := M + 1) hM1 (by linarith) (S := S) hs
  have hbase : (((1 + (M : ℝ) : ℝ) : ℂ)) = ((((M + 1 : ℚ) : ℝ) : ℂ)) := by
    push_cast
    ring
  have hb' : ‖(((1 + (M : ℝ) : ℝ) : ℂ) ^ (-s))‖ ≤ (cpowRadius (M + 1) S : ℝ) := by
    rw [hbase]
    exact hb
  rw [norm_div]
  have h2 : ‖(2 : ℂ)‖ = 2 := by norm_num
  rw [h2]
  have hcast : ((boundaryRadius S M : ℚ) : ℝ) = (cpowRadius (M + 1) S : ℝ) / 2 := by
    unfold boundaryRadius
    push_cast
    ring
  rw [hcast]
  exact div_le_div_of_nonneg_right hb' (by norm_num)

/-- Radius for the `k`-th partial-sum term. -/
def termRadius (S : Cx) (k : ℕ) : ℚ := cpowRadius (k + 1) S

theorem norm_term_le {S : Cx} (hS : 1 < S.re.lo) (k : ℕ) {s : ℂ} (hs : Cx.mem s S) :
    ‖(((1 + (k : ℝ) : ℝ) : ℂ) ^ (-s))‖ ≤ (termRadius S k : ℝ) := by
  have hk : (1 : ℚ) ≤ (k + 1 : ℚ) := by
    have : (0 : ℚ) ≤ (k : ℚ) := by positivity
    linarith
  have hbase : (((1 + (k : ℝ) : ℝ) : ℂ)) = ((((k + 1 : ℚ) : ℝ)) : ℂ) := by
    norm_num
    push_cast
    ring
  rw [hbase]
  exact norm_cpow_neg_le_radius hk (by linarith) hs


/-! ## Derivative and Bernoulli atoms -/

/-- Radius for `iteratedDeriv n (1+y)^{-s}` at `y = M`. -/
def derivRadius (S : Cx) (M n : ℕ) : ℚ :=
  risingRadius (sRadius S) n * (((M + 1 : ℚ) ^ (lowerNat S + n))⁻¹)

theorem derivRadius_nonneg (S : Cx) (M n : ℕ) : 0 ≤ derivRadius S M n := by
  unfold derivRadius
  refine mul_nonneg (risingRadius_nonneg (sRadius_nonneg S) n) ?_
  have h1 : (0 : ℚ) < (M + 1 : ℚ) := by positivity
  exact inv_nonneg.mpr (le_of_lt (by positivity))

theorem norm_iteratedDeriv_le {S : Cx} (hS : 1 < S.re.lo) (M : ℕ) (hM : 1 ≤ M)
    {s : ℂ} (hs : Cx.mem s S) (n : ℕ) :
    ‖iteratedDeriv n (fun y : ℝ => (((1 + y : ℝ) : ℂ) ^ (-s))) (M : ℝ)‖ ≤
      (derivRadius S M n : ℝ) := by
  have hx : (M : ℝ) ∈ Set.Ioi (-1 : ℝ) := by
    simp only [Set.mem_Ioi]
    have : (0 : ℝ) ≤ (M : ℝ) := by exact_mod_cast (Nat.zero_le M)
    linarith
  rw [iteratedDeriv_hurwitzTerm_eqOn n hx]
  rw [norm_mul, norm_mul]
  have hneg : ‖((-1 : ℂ) ^ n)‖ = 1 := by simp
  rw [hneg, one_mul]
  have hb : (1 : ℚ) ≤ (M + 1 : ℚ) := by
    have : (0 : ℚ) ≤ (M : ℚ) := by positivity
    linarith
  have hbase : (((1 + (M : ℝ) : ℝ) : ℂ)) = ((((M + 1 : ℚ) : ℝ) : ℂ)) := by
    push_cast
    ring
  have hcp := norm_cpow_neg_sub_le (b := M + 1) hb hS hs n
  rw [← hbase] at hcp
  rw [← Rat.cast_inv] at hcp
  have hrising := norm_rising_le (s := s) (Rs := sRadius S) (sRadius_nonneg S)
    (norm_le_sRadius hs) n
  have hRn : (0 : ℝ) ≤ (risingRadius (sRadius S) n : ℝ) := by
    exact_mod_cast risingRadius_nonneg (sRadius_nonneg S) n
  have hcn : (0 : ℝ) ≤ ((((M + 1 : ℚ) ^ (lowerNat S + n)) : ℚ)⁻¹ : ℝ) := by
    have hpos : (0 : ℚ) < ((M + 1 : ℚ) ^ (lowerNat S + n)) := by
      have h1 : (0 : ℚ) < (M + 1 : ℚ) := by linarith
      positivity
    exact_mod_cast inv_nonneg.mpr (le_of_lt hpos)
  rw [derivRadius, Rat.cast_mul]
  exact mul_le_mul hrising hcp (norm_nonneg _) hRn

/-- The rational absolute value of the `j`-th Euler–Maclaurin coefficient. -/
def bernoulliCoeff (j : ℕ) : ℚ :=
  |((_root_.bernoulli (2 * (j + 1)) : ℚ) / (((2 * (j + 1)).factorial : ℕ) : ℚ))|

theorem bernoulliCoeff_nonneg (j : ℕ) : 0 ≤ bernoulliCoeff j := by
  unfold bernoulliCoeff
  exact abs_nonneg _

def bernoulliRadius (S : Cx) (M j : ℕ) : ℚ := bernoulliCoeff j * derivRadius S M (2 * j + 1)

theorem bernoulliRadius_nonneg (S : Cx) (M j : ℕ) : 0 ≤ bernoulliRadius S M j := by
  unfold bernoulliRadius
  exact mul_nonneg (bernoulliCoeff_nonneg j) (derivRadius_nonneg S M (2 * j + 1))

theorem norm_bernoulli_le {S : Cx} (hS : 1 < S.re.lo) (M : ℕ) (hM : 1 ≤ M)
    {s : ℂ} (hs : Cx.mem s S) (j : ℕ) :
    ‖((((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
          (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
        (0 - iteratedDeriv (2 * j + 1)
          (fun y : ℝ => (((1 + y : ℝ) : ℂ) ^ (-s))) (M : ℝ)))‖ ≤
      (bernoulliRadius S M j : ℝ) := by
  have hd := norm_iteratedDeriv_le hS M hM hs (2 * j + 1)
  rw [norm_mul]
  have hfpos : (0 : ℝ) < (((2 * (j + 1)).factorial : ℕ) : ℝ) := by positivity
  have hnormc : ‖(((_root_.bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
      (((2 * (j + 1)).factorial : ℕ) : ℂ))‖ =
      (bernoulliCoeff j : ℝ) := by
    rw [norm_div, Complex.norm_real, Real.norm_eq_abs, Complex.norm_natCast]
    unfold bernoulliCoeff
    rw [Rat.cast_abs, Rat.cast_div, Rat.cast_natCast, abs_div, abs_of_pos hfpos]
  rw [hnormc]
  have hd' : ‖(0 - iteratedDeriv (2 * j + 1)
      (fun y : ℝ => (((1 + y : ℝ) : ℂ) ^ (-s))) (M : ℝ))‖ ≤
      (derivRadius S M (2 * j + 1) : ℝ) := by
    simpa only [zero_sub, norm_neg] using hd
  rw [bernoulliRadius, Rat.cast_mul]
  exact mul_le_mul le_rfl hd' (norm_nonneg _) (by
    exact_mod_cast bernoulliCoeff_nonneg j)


/-! ## The tail atom -/

/-- Rational radius for the Euler–Maclaurin remainder. -/
def tailRadius (S : Cx) (K : ℕ) : ℚ :=
  risingRadius (sRadius S) (2 * K + 1) * (4 / (6 : ℚ) ^ (2 * K + 1)) *
    (1 / (S.re.lo + ((2 * K : ℕ) : ℚ)))

theorem tailRadius_nonneg {S : Cx} (hS : 1 < S.re.lo) (K : ℕ) : 0 ≤ tailRadius S K := by
  unfold tailRadius
  have hlo : (0 : ℚ) < S.re.lo + ((2 * K : ℕ) : ℚ) := by
    have : (0 : ℚ) ≤ ((2 * K : ℕ) : ℚ) := by positivity
    linarith
  refine mul_nonneg (mul_nonneg (risingRadius_nonneg (sRadius_nonneg S) _) ?_) (by positivity)
  positivity

theorem norm_tail_le {S : Cx} (hS : 1 < S.re.lo) (M K : ℕ) (hM : 1 ≤ M) (hK : 1 ≤ K)
    {s : ℂ} (hs : Cx.mem s S) :
    ‖(1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
        (∫ x : ℝ in Set.Ioi (M : ℝ),
          (periodicBernoulli (2 * K + 1) x : ℂ) *
            iteratedDeriv (2 * K + 1)
              (fun y : ℝ => (((1 + y : ℝ) : ℂ) ^ (-s))) x)‖ ≤
      (tailRadius S K : ℝ) := by
  have hSR : (1 : ℝ) < (S.re.lo : ℝ) := by exact_mod_cast hS
  have hsre : 1 < s.re := by linarith [hs.1.1]
  have htail := (hurwitzZetaNP_eulerMaclaurin_with_bound (K := K) hK (a := 1)
    (by norm_num) (s := s) hsre M hM).2
  have hR := norm_rising_le (s := s) (Rs := sRadius S) (sRadius_nonneg S)
    (norm_le_sRadius hs) (2 * K + 1)
  have hz := riemannZeta_nat_re_le_two hK
  have hpi : (6 : ℝ) ≤ 2 * Real.pi := by linarith [Real.pi_gt_three]
  have hpi0 : (0 : ℝ) < 6 := by norm_num
  have hden : (6 : ℝ) ^ (2 * K + 1) ≤ (2 * Real.pi) ^ (2 * K + 1) :=
    pow_le_pow_left₀ (le_of_lt hpi0) hpi _
  have hdenpos : (0 : ℝ) < (6 : ℝ) ^ (2 * K + 1) := by positivity
  have hfrac : 2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1) ≤
      4 / (6 : ℝ) ^ (2 * K + 1) := by
    have hnum : 2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re ≤ 4 := by linarith
    have hdenpos' : (0 : ℝ) < (2 * Real.pi) ^ (2 * K + 1) := by positivity
    calc
      2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)
          ≤ 4 / (2 * Real.pi) ^ (2 * K + 1) := by
            exact div_le_div_of_nonneg_right hnum (le_of_lt hdenpos')
      _ ≤ 4 / (6 : ℝ) ^ (2 * K + 1) := by
            exact div_le_div_of_nonneg_left (by norm_num) hdenpos hden
  have hbase : (1 : ℝ) ≤ 1 + (M : ℝ) := by
    have : (0 : ℝ) ≤ (M : ℝ) := by exact_mod_cast (Nat.zero_le M)
    linarith
  have hexp : -(s.re) - 2 * (K : ℝ) ≤ 0 := by
    have : (0 : ℝ) ≤ s.re := by linarith
    have : (0 : ℝ) ≤ (K : ℝ) := by exact_mod_cast (Nat.zero_le K)
    linarith
  have hdecay : (1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos hbase hexp
  have hdecay0 : (0 : ℝ) ≤ (1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) :=
    Real.rpow_nonneg (by linarith) _
  have hKden : (0 : ℝ) < s.re + 2 * (K : ℝ) := by
    have : (0 : ℝ) ≤ (K : ℝ) := by exact_mod_cast (Nat.zero_le K)
    linarith
  have hlo : (0 : ℝ) < (S.re.lo : ℝ) + 2 * (K : ℝ) := by linarith [hs.1.1]
  have hinv : 1 / (s.re + 2 * (K : ℝ)) ≤ 1 / ((S.re.lo : ℝ) + 2 * (K : ℝ)) := by
    apply div_le_div_of_nonneg_left (by norm_num) hlo
    linarith [hs.1.1]
  have htail' := htail
  have hstep1 : ‖(1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
        (∫ x : ℝ in Set.Ioi (M : ℝ),
          (periodicBernoulli (2 * K + 1) x : ℂ) *
            iteratedDeriv (2 * K + 1)
              (fun y : ℝ => (((1 + y : ℝ) : ℂ) ^ (-s))) x)‖ ≤
      ‖rising s (2 * K + 1)‖ *
        (2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)) *
        ((1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) / (s.re + 2 * (K : ℝ))) := by
    simpa [Nat.cast_add, Nat.cast_mul, Nat.cast_one, mul_assoc] using htail'
  have hstep2 : ‖rising s (2 * K + 1)‖ *
        (2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)) *
        ((1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) / (s.re + 2 * (K : ℝ))) ≤
      (risingRadius (sRadius S) (2 * K + 1) : ℝ) *
        (4 / (6 : ℝ) ^ (2 * K + 1)) *
        (1 / ((S.re.lo : ℝ) + 2 * (K : ℝ))) := by
    have hR0 : (0 : ℝ) ≤ (risingRadius (sRadius S) (2 * K + 1) : ℝ) := by
      exact_mod_cast risingRadius_nonneg (sRadius_nonneg S) _
    have hfrac1 : (0 : ℝ) ≤ 4 / (6 : ℝ) ^ (2 * K + 1) := by positivity
    have hinv0 : (0 : ℝ) ≤ (1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) /
        (s.re + 2 * (K : ℝ)) := by positivity
    have hinv1 : (0 : ℝ) ≤ 1 / ((S.re.lo : ℝ) + 2 * (K : ℝ)) := by positivity
    have h1' : (2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re /
          (2 * Real.pi) ^ (2 * K + 1)) * ‖rising s (2 * K + 1)‖ ≤
        (4 / (6 : ℝ) ^ (2 * K + 1)) *
          (risingRadius (sRadius S) (2 * K + 1) : ℝ) :=
      mul_le_mul hfrac hR (norm_nonneg _) hfrac1
    have h1 : ‖rising s (2 * K + 1)‖ *
        (2 * (riemannZeta (((2 * K + 1 : ℕ)) : ℂ)).re / (2 * Real.pi) ^ (2 * K + 1)) ≤
        (risingRadius (sRadius S) (2 * K + 1) : ℝ) *
          (4 / (6 : ℝ) ^ (2 * K + 1)) := by
      simpa [mul_comm, mul_left_comm, mul_assoc] using h1' 
    have h2 : (1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) / (s.re + 2 * (K : ℝ)) ≤
        1 / ((S.re.lo : ℝ) + 2 * (K : ℝ)) := by
      have := div_le_div_of_nonneg_right hdecay (le_of_lt hKden)
      have h3 : 1 / (s.re + 2 * (K : ℝ)) ≤ 1 / ((S.re.lo : ℝ) + 2 * (K : ℝ)) := hinv
      calc
        (1 + (M : ℝ)) ^ (-s.re - 2 * (K : ℝ)) / (s.re + 2 * (K : ℝ))
            ≤ 1 / (s.re + 2 * (K : ℝ)) := this
        _ ≤ 1 / ((S.re.lo : ℝ) + 2 * (K : ℝ)) := h3
    have hA : (0 : ℝ) ≤ (risingRadius (sRadius S) (2 * K + 1) : ℝ) *
        (4 / (6 : ℝ) ^ (2 * K + 1)) := mul_nonneg hR0 hfrac1
    exact mul_le_mul h1 h2 hinv0 hA
  have hRcast : ((tailRadius S K : ℚ) : ℝ) =
      (risingRadius (sRadius S) (2 * K + 1) : ℝ) * (4 / (6 : ℝ) ^ (2 * K + 1)) *
        (1 / ((S.re.lo : ℝ) + 2 * (K : ℝ))) := by
    unfold tailRadius
    push_cast
    ring
  rw [hRcast]
  exact hstep1.trans hstep2


/-! ## Certificate assembly -/

theorem termRadius_nonneg (S : Cx) (k : ℕ) : 0 ≤ termRadius S k := by
  unfold termRadius
  exact cpowRadius_nonneg (by
    have : (0 : ℚ) ≤ (k : ℚ) := by positivity
    linarith) S

/-- The zero rectangle. -/
def zeroBox : Cx := ⟨⟨0, 0⟩, ⟨0, 0⟩⟩

/-- A left fold of rational balls. -/
def sumBall (f : ℕ → ℚ) : ℕ → Cx
  | 0 => zeroBox
  | n + 1 => (sumBall f n).add (ball (f n))

theorem sumBall_mem {f : ℕ → ℚ} {z : ℕ → ℂ} (M : ℕ)
    (h : ∀ k, k < M → Cx.mem (z k) (ball (f k))) :
    Cx.mem (∑ k ∈ Finset.range M, z k) (sumBall f M) := by
  induction M with
  | zero =>
      simp [sumBall, zeroBox, Cx.mem, Iv.memR]
  | succ M ih =>
      rw [Finset.sum_range_succ, sumBall]
      exact Cx.mem_add (ih (fun k hk => h k (Nat.lt_trans hk (Nat.lt_succ_self M))))
        (h M (Nat.lt_succ_self M))

/-- The enclosure of `ζ(s)` on a rectangle with `Re s > 1`. -/
def zetaBox (S : Cx) (M K : ℕ) : Cx :=
  ((((sumBall (termRadius S) M).add (ball (integralRadius S M))).add
      (ball (boundaryRadius S M))).add (sumBall (bernoulliRadius S M) K)).add
    (ball (tailRadius S K))

/-- **P1 (rectangle form).** The general Euler–Maclaurin S1/S2 theorem, instantiated
at the evaluator's parameters, yields a closed rational enclosure of `ζ(s)` for
every `s` in a rectangle whose real part exceeds `1`.  No atom hypothesis: every
term is discharged by a proved bound. -/
theorem zeta_mem_box {S : Cx} (hS : 1 < S.re.lo) (M K : ℕ) (hM : 1 ≤ M) (hK : 1 ≤ K)
    {s : ℂ} (hs : Cx.mem s S) :
    Cx.mem (riemannZeta s) (zetaBox S M K) := by
  have hSR : (1 : ℝ) < (S.re.lo : ℝ) := by exact_mod_cast hS
  have hsre : 1 < s.re := by linarith [hs.1.1]
  have hs0 : s ≠ 0 := by
    rintro rfl
    norm_num at hsre
  rw [← zeta_eq_hurwitzZetaNP_one hs0]
  rw [hurwitzZetaNP_eq_eulerMaclaurin (K := K) hK (a := 1) (by norm_num) (s := s) hsre M hM]
  unfold zetaBox
  refine Cx.mem_add (Cx.mem_add (Cx.mem_add (Cx.mem_add ?_ ?_) ?_) ?_) ?_
  · exact sumBall_mem M (fun k _ =>
      mem_ball_of_norm_le (termRadius_nonneg S k) (by
        simpa using norm_term_le hS k hs))
  · exact mem_ball_of_norm_le (integralRadius_nonneg hS M) (by
      simpa using norm_integral_le_radius hS M hM hs)
  · exact mem_ball_of_norm_le (boundaryRadius_nonneg S M) (by
      simpa using norm_boundary_le hS M hs)
  · exact sumBall_mem K (fun j _ =>
      mem_ball_of_norm_le (bernoulliRadius_nonneg S M j) (by
        simpa using norm_bernoulli_le hS M hM hs j))
  · exact mem_ball_of_norm_le (tailRadius_nonneg hS K) (by
      simpa using norm_tail_le hS M K hM hK hs)

/-- The rectangle degenerating to a single real point. -/
def pointBox (q : ℚ) : Cx := ⟨⟨q, q⟩, ⟨0, 0⟩⟩

/-- P1 acceptance check: the general enclosure instantiates at `s = 2`, `M = 3`,
`K = 2` and contains `ζ(2)`. -/
theorem zeta_two_mem_box : Cx.mem (riemannZeta 2) (zetaBox (pointBox 2) 3 2) := by
  have hS : (1 : ℚ) < (pointBox 2).re.lo := by norm_num [pointBox]
  have hs : Cx.mem (2 : ℂ) (pointBox 2) := by
    refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩⟩ <;> norm_num [pointBox, Iv.memR]
  simpa using zeta_mem_box hS 3 2 (by norm_num) (by norm_num) hs

end PartialTail
