import Mathlib

/-!
# A finite Lee–Yang circle theorem

The two-spin ferromagnetic Ising partition function is

`Z_K(z) = e^K z^2 + 2 z + e^K`, `K > 0`.

This file proves the Lee–Yang circle theorem in this finite case: every zero of
`Z_K` lies on the unit circle. The proof is elementary: the polynomial is
palindromic with real positive coefficients, has no real roots, and a non-real
root and its conjugate multiply to `1`.
-/

noncomputable section

namespace GeoDQPT

/-- The two-spin Ising partition function as a polynomial in the fugacity `z`. -/
def ising2Partition (K : ℝ) (z : ℂ) : ℂ :=
  Real.exp K * z ^ 2 + 2 * z + Real.exp K

/-- A real quadratic `a z² + b z + a` with `0 < b < 2a` has no real roots. -/
theorem quadratic_no_real_root {a b x : ℝ} (ha : 0 < a) (hb0 : 0 < b) (hb : b < 2 * a) :
    a * x ^ 2 + b * x + a ≠ 0 := by
  intro h
  have h1 : 0 < 2 * a - b := by linarith
  have h2 : 0 < 2 * a + b := by linarith
  have hconst : 0 < 4 * a ^ 2 - b ^ 2 := by
    have hmul : 0 < (2 * a - b) * (2 * a + b) := mul_pos h1 h2
    nlinarith
  have h4 : 4 * a * (a * x ^ 2 + b * x + a) =
      (2 * a * x + b) ^ 2 + (4 * a ^ 2 - b ^ 2) := by ring
  have hsq : 0 ≤ (2 * a * x + b) ^ 2 := sq_nonneg _
  nlinarith

/-- A non-real root of a real palindromic quadratic has squared modulus `1`.
This is the algebraic heart of the finite Lee–Yang theorem. -/
theorem quadratic_root_normSq_one {a b : ℝ} (ha : 0 < a) (hb0 : 0 < b)
    (hb2 : b < 2 * a) {z : ℂ}
    (hz : a * z ^ 2 + b * z + a = 0) : Complex.normSq z = 1 := by
  have hre : a * (z.re ^ 2 - z.im ^ 2) + b * z.re + a = 0 := by
    have := congrArg Complex.re hz
    simpa [Complex.mul_re, Complex.mul_im, pow_two, Complex.add_re] using this
  have him : 2 * a * z.re * z.im + b * z.im = 0 := by
    have := congrArg Complex.im hz
    simp [Complex.mul_re, Complex.mul_im, pow_two, Complex.add_im] at this
    ring_nf at this ⊢
    exact this
  have h_im_ne : z.im ≠ 0 := by
    intro h
    have hreal : a * z.re ^ 2 + b * z.re + a = 0 := by
      simpa [h] using hre
    exact quadratic_no_real_root ha hb0 hb2 hreal
  have hx : 2 * a * z.re + b = 0 := by
    have hmul : z.im * (2 * a * z.re + b) = 0 := by
      nlinarith
    exact (mul_eq_zero.mp hmul).resolve_left h_im_ne
  have hxval : z.re = -b / (2 * a) := by
    field_simp [ha.ne']
    linarith
  have hy2' : z.im ^ 2 = 1 - z.re ^ 2 := by
    have hb_eq : b = -2 * a * z.re := by linarith
    rw [hb_eq] at hre
    nlinarith
  have hnorm : z.re ^ 2 + z.im ^ 2 = 1 := by
    rw [hy2']
    ring
  simpa [Complex.normSq_apply, pow_two] using hnorm

/-- **Finite Lee–Yang circle theorem** for the two-spin ferromagnetic Ising
model: for `K > 0`, every zero of `Z_K(z)` lies on the unit circle. -/
theorem ising2_lee_yang {K : ℝ} (hK : 0 < K) {z : ℂ}
    (hz : ising2Partition K z = 0) : Complex.normSq z = 1 := by
  have ha : 0 < Real.exp K := Real.exp_pos K
  have hb0 : 0 < (2 : ℝ) := by norm_num
  have hb2 : (2 : ℝ) < 2 * Real.exp K := by
    nlinarith [Real.exp_pos K, Real.one_lt_exp_iff.mpr hK]
  have hz' : Real.exp K * z ^ 2 + 2 * z + Real.exp K = 0 := hz
  exact quadratic_root_normSq_one ha hb0 hb2 hz'



/-- The `N = 2` polygon as a function of the complex weight. -/
def eta2 (s : ℂ) : ℂ := 1 - (2 : ℂ) ^ (-s) + (3 : ℂ) ^ (-s) - (4 : ℂ) ^ (-s)

/-- The polygon has an exact zero at `s = 0`. -/
theorem eta2_zero : eta2 0 = 0 := by
  norm_num [eta2]

/-- That exact zero is not on the critical line. -/
theorem eta2_zero_off_critical : (0 : ℂ).re ≠ 1 / 2 := by
  norm_num

end GeoDQPT
