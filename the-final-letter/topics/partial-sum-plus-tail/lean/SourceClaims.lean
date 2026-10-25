import Mathlib
import Mathlib.NumberTheory.LSeries.DirichletContinuation

/-!
# Source claims for partial sum plus tail

This file formalises the elementary source claims S3, S4 and S5 of
`README.md`.  S1 (Euler–Maclaurin) and S2 (the explicit remainder bound)
are the two genuinely analytic inputs and are not formalised here; they have
a written proof in `notes/euler-maclaurin-proof.md`.
-/

noncomputable section

set_option maxHeartbeats 4000000

open scoped BigOperators
open MeasureTheory Set

namespace PartialTail

/-! ## S3 — the zeta bound at integers -/

/-- The bound `ζ(m) ≤ 1 + 1/(m−1)` for natural `m ≥ 2`, stated for the real
part of `riemannZeta (m : ℂ)`. -/
theorem riemannZeta_nat_re_le {m : ℕ} (hm : 2 ≤ m) :
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


/-! ## S4 — the eta identity -/

/-- The Dirichlet eta function `η(s) = Σ (-1)^(n-1) n^{-s}`, indexed from `n = 0`
with denominator `n + 1`. -/
def eta (s : ℂ) : ℂ :=
  ∑' n : ℕ, (-1 : ℂ) ^ n / ((n : ℂ) + 1) ^ s

/-- The eta identity `η(s) = (1 - 2^(1-s)) ζ(s)` in the convergence range. -/
theorem eta_eq_one_sub_two_cpow_mul_zeta {s : ℂ} (hs : 1 < s.re) :
    eta s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
  let f : ℕ → ℂ := fun n => 1 / (((n + 1 : ℕ) : ℂ)) ^ s
  have hf : Summable f := by
    have h := (Complex.summable_one_div_nat_cpow (p := s)).mpr hs
    have hshift : Summable (fun n : ℕ => 1 / ((n : ℂ) + 1) ^ s) := by
      simpa [f] using (summable_nat_add_iff 1).2 h
    simpa [f] using hshift
  have h_even : Summable fun k : ℕ => f (2 * k) := by
    exact hf.comp_injective (by
      intro a b hab
      omega)
  have h_odd : Summable fun k : ℕ => f (2 * k + 1) := by
    exact hf.comp_injective (by
      intro a b hab
      exact Nat.eq_of_mul_eq_mul_left (by decide : 0 < 2) (Nat.add_right_cancel hab))
  have hf_zeta : ∑' n, f n = riemannZeta s := by
    rw [zeta_eq_tsum_one_div_nat_add_one_cpow hs]
    simp [f, Nat.cast_add]
  have h_alt_sum : ∑' n, (-1 : ℂ) ^ n * f n =
      ∑' k, f (2 * k) - ∑' k, f (2 * k + 1) := by
    have he : Summable fun k : ℕ => (-1 : ℂ) ^ (2 * k) * f (2 * k) := by
      simpa using h_even
    have ho : Summable fun k : ℕ => (-1 : ℂ) ^ (2 * k + 1) * f (2 * k + 1) := by
      simpa [pow_succ, mul_neg] using h_odd.neg
    have h := tsum_even_add_odd (f := fun n => (-1 : ℂ) ^ n * f n) he ho
    have heq : ∑' k : ℕ, (-1 : ℂ) ^ (2 * k) * f (2 * k) = ∑' k, f (2 * k) := by
      apply tsum_congr
      intro k
      simp
    have hoq : ∑' k : ℕ, (-1 : ℂ) ^ (2 * k + 1) * f (2 * k + 1) =
        -∑' k, f (2 * k + 1) := by
      rw [← tsum_neg]
      apply tsum_congr
      intro k
      simp [pow_succ]
    rw [heq, hoq] at h
    rw [sub_eq_add_neg]
    exact h.symm
  have hsplit : ∑' k, f (2 * k) + ∑' k, f (2 * k + 1) = ∑' n, f n :=
    tsum_even_add_odd h_even h_odd
  have h_eta : ∑' n, (-1 : ℂ) ^ n * f n =
      ∑' n, f n - 2 * ∑' k, f (2 * k + 1) := by
    rw [h_alt_sum, ← hsplit]
    ring
  have hterm (k : ℕ) : f (2 * k + 1) = (2 : ℂ) ^ (-s) * f k := by
    have hnat : 2 * k + 1 + 1 = 2 * (k + 1) := by ring
    simp only [f, hnat]
    rw [show (((2 * (k + 1) : ℕ) : ℂ)) = ((2 : ℂ) * ((k + 1 : ℕ) : ℂ)) by push_cast; ring]
    change 1 / (((2 : ℂ) * ((k + 1 : ℕ) : ℂ)) ^ s) =
      2 ^ (-s) * (1 / ((k + 1 : ℕ) : ℂ) ^ s)
    rw [show (2 : ℂ) = ((2 : ℕ) : ℂ) by norm_num]
    rw [Complex.natCast_mul_natCast_cpow, Complex.cpow_neg]
    rw [one_div, one_div, mul_inv]
  have hodd_tsum : ∑' k, f (2 * k + 1) = (2 : ℂ) ^ (-s) * ∑' k, f k := by
    rw [show (fun k => f (2 * k + 1)) = (fun k => (2 : ℂ) ^ (-s) * f k) from funext hterm]
    rw [tsum_mul_left]
  have htwo : (2 : ℂ) ^ (1 - s) = 2 * (2 : ℂ) ^ (-s) := by
    rw [show 1 - s = 1 + (-s) by ring,
      Complex.cpow_add (x := (2 : ℂ)) 1 (-s) (by norm_num), Complex.cpow_one]
  calc
    eta s = ∑' n, (-1 : ℂ) ^ n * f n := by simp [eta, f, div_eq_mul_inv]
    _ = ∑' n, f n - 2 * ∑' k, f (2 * k + 1) := h_eta
    _ = riemannZeta s - 2 * ((2 : ℂ) ^ (-s) * riemannZeta s) := by
      rw [hf_zeta, hodd_tsum, hf_zeta]
    _ = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
      rw [htwo]
      ring

/-! ## S5 — the L-function as a finite Hurwitz-zeta sum -/

/-- The Dirichlet `L`-function is `N^{-s}` times a finite sum of Hurwitz zeta
values, with the `j = 0` term omitted when `N ≠ 1`. -/
theorem LFunction_eq_hurwitz_sum {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hN : N ≠ 1) (s : ℂ) :
    DirichletCharacter.LFunction χ s =
      (N : ℂ) ^ (-s) *
        ∑ j ∈ Finset.univ.erase (0 : ZMod N),
          χ j * HurwitzZeta.hurwitzZeta (ZMod.toAddCircle j) s := by
  rw [DirichletCharacter.LFunction, ZMod.LFunction]
  congr 1
  rw [← Finset.sum_erase_add _ _ (Finset.mem_univ (0 : ZMod N))]
  simp [DirichletCharacter.map_zero' χ hN]

end PartialTail
