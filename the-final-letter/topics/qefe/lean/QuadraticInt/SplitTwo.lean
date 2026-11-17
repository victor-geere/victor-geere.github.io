import Mathlib
import QuadraticInt.ZsqrtdTwo

/-!
# The split-prime theorem for `ℤ[√−2]`: `p = a² + 2b²`

This is the number-theoretic input the `d = 2` counting development needs, and
which Mathlib did not have (only the `x² + y²` analogue,
`Nat.Prime.sq_add_sq`).

The mathematical content is in two steps, mirroring Fermat's two-squares proof:

1. **`−2` is a square mod `p`** for `p ≡ 1, 3 mod 8`. Mathlib supplies the
   Legendre-symbol identity `legendreSym.at_neg_two : legendreSym p (-2) = χ₈' p`
   and the explicit table for `χ₈'`; Euler's criterion
   (`legendreSym.eq_one_iff`) converts the symbol value `1` into a square root.
2. **`p` is reducible in `ℤ[√−2]`.**  If `x² ≡ −2`, then
   `p ∣ (x + √−2)(x − √−2)` but `p` divides neither factor (their imaginary
   parts are `±1`), so `p` is not prime, hence not irreducible.  Factoring
   `p = a·b` into non-units and taking norms gives `N(a)·N(b) = p²` with both
   factors `> 1`, so `N(a) = p`, i.e. `a = m + n√−2` with `m² + 2n² = p`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

namespace ZsqrtdTwo

/-- `−2` is a square modulo a prime `p ≡ 1, 3 (mod 8)`. -/
theorem isSquare_neg_two {p : ℕ} [hp : Fact p.Prime] (hp8 : p % 8 = 1 ∨ p % 8 = 3) :
    IsSquare ((-2 : ℤ) : ZMod p) := by
  have hp2 : p ≠ 2 := by
    rintro rfl
    rcases hp8 with h | h <;> norm_num at h
  have hne : ((-2 : ℤ) : ZMod p) ≠ 0 := by
    intro h
    have hdvd : (p : ℤ) ∣ -2 := (ZMod.intCast_zmod_eq_zero_iff_dvd (-2) p).mp h
    obtain ⟨c, hc⟩ := hdvd
    have h2 : (p : ℤ) ∣ 2 := ⟨-c, by linarith⟩
    have hple : (p : ℤ) ≤ 2 := Int.le_of_dvd (by norm_num) h2
    have hpge : 2 ≤ p := hp.out.two_le
    have : p = 2 := by omega
    exact hp2 this
  rw [← legendreSym.eq_one_iff p hne, legendreSym.at_neg_two hp2,
    ZMod.χ₈'_nat_eq_if_mod_eight]
  have hodd : p % 2 ≠ 0 := by
    rcases hp8 with h | h <;> omega
  rcases hp8 with h | h <;> simp [h, hodd]

/-- If `p ∣ m² + 2` then `p` is not irreducible in `ℤ[√−2]`: it divides the
product `(m + √−2)(m − √−2)` but neither factor. -/
theorem not_irreducible_of_dvd_sq_add_two {p : ℕ} [hp : Fact p.Prime] {m : ℤ}
    (hm : (p : ℤ) ∣ m ^ 2 + 2) : ¬ Irreducible (p : R2) := by
  have hpge : 2 ≤ p := hp.out.two_le
  intro hirr
  have hprime : Prime (p : R2) := irreducible_iff_prime.mp hirr
  -- the two factors
  set z : R2 := (m : R2) + Zsqrtd.sqrtd with hz
  set w : R2 := (m : R2) - Zsqrtd.sqrtd with hw
  have hzw : z * w = ((m ^ 2 + 2 : ℤ) : R2) := by
    rw [hz, hw]
    push_cast
    ring_nf
    rw [show (Zsqrtd.sqrtd : R2) ^ 2 = ((-2 : ℤ) : R2) from by
      rw [pow_two, Zsqrtd.dmuld]]
    ring
  have hpz : (p : R2) ∣ z * w := by
    rw [hzw]
    obtain ⟨c, hc⟩ := hm
    exact ⟨(c : R2), by rw [hc]; push_cast; ring⟩
  rcases hprime.dvd_or_dvd hpz with h | h
  · obtain ⟨u, hu⟩ := h
    have him : (z).im = 1 := by
      rw [hz]
      simp only [Zsqrtd.im_add, Zsqrtd.im_intCast, Zsqrtd.im_sqrtd, zero_add]
    have hthis := congr_arg Zsqrtd.im hu
    rw [him, Zsqrtd.im_mul] at hthis
    simp only [Zsqrtd.re_natCast, Zsqrtd.im_natCast, zero_mul, zero_add] at hthis
    have hdvd : (p : ℤ) ∣ 1 := ⟨u.im, by linarith⟩
    have hle : (p : ℤ) ≤ 1 := Int.le_of_dvd one_pos hdvd
    omega
  · obtain ⟨u, hu⟩ := h
    have him : (w).im = -1 := by
      rw [hw]
      simp only [Zsqrtd.im_sub, Zsqrtd.im_intCast, Zsqrtd.im_sqrtd, zero_sub]
    have hthis := congr_arg Zsqrtd.im hu
    rw [him, Zsqrtd.im_mul] at hthis
    simp only [Zsqrtd.re_natCast, Zsqrtd.im_natCast, zero_mul, zero_add] at hthis
    have hdvd : (p : ℤ) ∣ 1 := ⟨-u.im, by linarith⟩
    have hle : (p : ℤ) ≤ 1 := Int.le_of_dvd one_pos hdvd
    omega

/-- If `p` is reducible in `ℤ[√−2]`, then `p = a² + 2b²`. -/
theorem exists_nat_repr_of_not_irreducible (p : ℕ) [hp : Fact p.Prime]
    (hpi : ¬ Irreducible (p : R2)) : ∃ a b : ℕ, a ^ 2 + 2 * b ^ 2 = p := by
  have hpu : ¬ IsUnit (p : R2) := by
    intro hu
    have h1 : (p : R2).norm = 1 :=
      (Zsqrtd.norm_eq_one_iff' (by norm_num : (-2 : ℤ) ≤ 0) _).mpr hu
    rw [Zsqrtd.norm_natCast] at h1
    have := hp.out.one_lt
    nlinarith
  obtain ⟨a, b, hpab, hau, hbu⟩ : ∃ a b, (p : R2) = a * b ∧ ¬IsUnit a ∧ ¬IsUnit b := by
    simpa [irreducible_iff, hpu, not_forall, not_or] using hpi
  -- norms
  have hnorm : a.norm * b.norm = (p : ℤ) ^ 2 := by
    rw [← Zsqrtd.norm_mul, ← hpab, Zsqrtd.norm_natCast]; ring
  have ha_abs : a.norm.natAbs * b.norm.natAbs = p ^ 2 := by
    rw [← Int.natAbs_mul, hnorm, Int.natAbs_pow, Int.natAbs_natCast]
  have ha_ne1 : a.norm.natAbs ≠ 1 := by
    intro h
    exact hau (Zsqrtd.norm_eq_one_iff.mp h)
  have hb_ne1 : b.norm.natAbs ≠ 1 := by
    intro h
    exact hbu (Zsqrtd.norm_eq_one_iff.mp h)
  have ha_ne0 : a.norm.natAbs ≠ 0 := by
    intro h
    have h0 : a = 0 := by
      have : a.norm = 0 := by
        have := Int.natAbs_eq_zero.mp h
        exact this
      exact (Zsqrtd.norm_eq_zero_iff (by norm_num : (-2 : ℤ) < 0) a).mp this
    rw [h0, zero_mul] at hpab
    have hp0 : (p : ℤ) = 0 := by simpa using congr_arg Zsqrtd.re hpab
    have : p = 0 := by exact_mod_cast hp0
    exact hp.out.ne_zero this
  have hb_ne0 : b.norm.natAbs ≠ 0 := by
    intro h
    have h0 : b = 0 := by
      have : b.norm = 0 := Int.natAbs_eq_zero.mp h
      exact (Zsqrtd.norm_eq_zero_iff (by norm_num : (-2 : ℤ) < 0) b).mp this
    rw [h0, mul_zero] at hpab
    have hp0 : (p : ℤ) = 0 := by simpa using congr_arg Zsqrtd.re hpab
    have : p = 0 := by exact_mod_cast hp0
    exact hp.out.ne_zero this
  have ha2 : 2 ≤ a.norm.natAbs := by omega
  have hb2 : 2 ≤ b.norm.natAbs := by omega
  have hdiv : a.norm.natAbs ∣ p ^ 2 := ⟨b.norm.natAbs, ha_abs.symm⟩
  obtain ⟨k, hk2, hk⟩ := (Nat.dvd_prime_pow hp.out).mp hdiv
  have hk_ne0 : k ≠ 0 := by
    rintro rfl
    simp at hk
    omega
  have hk_cases : k = 1 := by
    have hk_le : k ≤ 2 := hk2
    interval_cases k
    · exact absurd hk ha_ne1
    · rfl
    · exfalso
      -- a.norm.natAbs = p² forces b.norm.natAbs = 1
      have : b.norm.natAbs = 1 := by
        rw [hk] at ha_abs
        have hp0 : 0 < p := hp.out.pos
        nlinarith
      exact hb_ne1 this
  rw [hk_cases] at hk
  -- now a.norm.natAbs = p, i.e. |N(a)| = p
  have hna : a.norm.natAbs = p := by simpa using hk
  have hpos : 0 ≤ a.norm := Zsqrtd.norm_nonneg (by norm_num) a
  have hnorm_a : a.norm = (p : ℤ) := by
    rw [← Int.natAbs_of_nonneg hpos, hna]
  have hdef : a.norm = a.re ^ 2 + 2 * a.im ^ 2 := by
    rw [Zsqrtd.norm_def]; ring
  have hnat : |a.re| ^ 2 + 2 * |a.im| ^ 2 = (p : ℤ) := by
    rw [← hnorm_a, hdef, ← sq_abs a.re, ← sq_abs a.im]
  refine ⟨a.re.natAbs, a.im.natAbs, ?_⟩
  have hcast : ((a.re.natAbs ^ 2 + 2 * a.im.natAbs ^ 2 : ℕ) : ℤ) = (p : ℤ) := by
    push_cast
    exact hnat
  exact_mod_cast hcast

/-- **The split-prime theorem for `d = 2`:** every prime `p ≡ 1, 3 (mod 8)` is
of the form `a² + 2b²`, i.e. splits in `ℤ[√−2]`. -/
theorem prime_sq_add_two_sq {p : ℕ} [hp : Fact p.Prime]
    (hp8 : p % 8 = 1 ∨ p % 8 = 3) : ∃ a b : ℕ, a ^ 2 + 2 * b ^ 2 = p := by
  obtain ⟨x, hx⟩ := isSquare_neg_two hp8
  have hp2 : p ≠ 2 := by
    rintro rfl
    rcases hp8 with h | h <;> norm_num at h
  -- lift the square root to `x.val` and get `p ∣ x.val² + 2`
  have hvalZ : ((x.val : ℤ) : ZMod p) = x := by
    have h := ZMod.natCast_zmod_val x
    simpa using h
  have hzero : ((((x.val : ℤ) ^ 2 + 2 : ℤ)) : ZMod p) = 0 := by
    have h1 : ((((x.val : ℤ) ^ 2 + 2 : ℤ)) : ZMod p) = ((x.val : ℤ) : ZMod p) ^ 2 + 2 := by
      push_cast; ring
    rw [h1, hvalZ, show x ^ 2 = x * x from pow_two x, ← hx]
    norm_num
  have hdvdZ : (p : ℤ) ∣ (x.val : ℤ) ^ 2 + 2 :=
    (ZMod.intCast_zmod_eq_zero_iff_dvd ((x.val : ℤ) ^ 2 + 2) p).mp hzero
  exact exists_nat_repr_of_not_irreducible p (not_irreducible_of_dvd_sq_add_two hdvdZ)

end ZsqrtdTwo
