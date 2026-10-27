import ZetaBox14

noncomputable section
namespace FiniteWindowZeros
open PartialTail

/-- Maximum absolute rational endpoint of a real interval. -/
def maxAbsIv (I : Iv) : ℚ := max |I.lo| |I.hi|

theorem maxAbsIv_nonneg (I : Iv) : 0 ≤ maxAbsIv I :=
  le_trans (abs_nonneg _) (le_max_left _ _)

theorem abs_le_maxAbsIv {I : Iv} {x : ℝ} (hx : I.memR x) :
    |x| ≤ (maxAbsIv I : ℝ) := by
  have hmax : (0:ℚ) ≤ maxAbsIv I := maxAbsIv_nonneg I
  have hmaxR : (0:ℝ) ≤ (maxAbsIv I : ℝ) := by exact_mod_cast hmax
  rw [abs_le]
  constructor
  · have h1 : (I.lo : ℝ) ≤ x := hx.1
    have h2 : (I.lo : ℝ) ≤ |(I.lo : ℝ)| := le_abs_self _
    have h3 : |(I.lo : ℝ)| ≤ (maxAbsIv I : ℝ) := by
      rw [← Rat.cast_abs]
      exact_mod_cast (le_max_left |I.lo| |I.hi|)
    have h4 : -(maxAbsIv I : ℝ) ≤ (I.lo : ℝ) := by
      have := neg_abs_le (I.lo : ℝ)
      linarith
    linarith
  · have h1 : x ≤ (I.hi : ℝ) := hx.2
    have h2 : (I.hi : ℝ) ≤ |(I.hi : ℝ)| := le_abs_self _
    have h3 : |(I.hi : ℝ)| ≤ (maxAbsIv I : ℝ) := by
      rw [← Rat.cast_abs]
      exact_mod_cast (le_max_right |I.lo| |I.hi|)
    linarith

theorem norm_le_of_mem_box {B : Cx} {z : ℂ} (hz : Cx.mem z B) {R : ℝ}
    (hR0 : 0 ≤ R)
    (hR : (maxAbsIv B.re) ^ 2 + (maxAbsIv B.im) ^ 2 ≤ R ^ 2) :
    ‖z‖ ≤ R := by
  have hre : |z.re| ≤ (maxAbsIv B.re : ℝ) := abs_le_maxAbsIv hz.1
  have him : |z.im| ≤ (maxAbsIv B.im : ℝ) := abs_le_maxAbsIv hz.2
  have hsq : Complex.normSq z ≤ R ^ 2 := by
    rw [Complex.normSq_apply]
    have h1 : z.re ^ 2 ≤ (maxAbsIv B.re : ℝ) ^ 2 := by
      rw [← sq_abs]; exact pow_le_pow_left₀ (abs_nonneg _) hre 2
    have h2 : z.im ^ 2 ≤ (maxAbsIv B.im : ℝ) ^ 2 := by
      rw [← sq_abs]; exact pow_le_pow_left₀ (abs_nonneg _) him 2
    linarith
  calc ‖z‖ = Real.sqrt (Complex.normSq z) := by
        rw [← Real.sqrt_sq (norm_nonneg _), Complex.normSq_eq_norm_sq]
    _ ≤ Real.sqrt (R ^ 2) := Real.sqrt_le_sqrt hsq
    _ = R := Real.sqrt_sq hR0

end FiniteWindowZeros
