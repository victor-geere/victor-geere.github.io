import Mathlib
import QuadraticInt.Eisenstein

/-!
# The split-prime theorem for `ℤ[ω]`: `p = a² − ab + b²` for `p ≡ 1 (mod 3)`

The number-theoretic input for the `d = 3` counting development.  The route is
the Eisenstein analogue of `Nat.Prime.sq_add_sq`:

1. **`X² + X + 1` has a root mod `p`** when `p ≡ 1 (mod 3)`.  Since
   `p - 1 = |(ZMod p)ˣ|` is divisible by `3`, Cauchy's theorem
   (`exists_prime_orderOf_dvd_card`) produces a unit `g` of order `3`.  Then
   `g ≠ 1` and `g³ = 1`, so `(g−1)(g²+g+1) = 0` in the field, giving the root.
2. **`p` is reducible in `ℤ[ω]`.**  If `x² + x + 1 ≡ 0 (mod p)`, the element
   `z = x − ω` has norm `N(z) = x² + x + 1`, so `p ∣ z · star z` but `p`
   divides neither factor (their `ω`-coefficients are `±1`).  Factoring
   `p = a·b` into non-units gives `N(a)·N(b) = p²` with both `> 1`, hence
   `N(a) = p`, i.e. `a = m + nω` with `m² − mn + n² = p`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

namespace EisensteinInt

/-- `X² + X + 1` has a root modulo a prime `p ≡ 1 (mod 3)`. -/
theorem exists_root_sq_add_X_add_one {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 1) :
    ∃ x : ZMod p, x ^ 2 + x + 1 = 0 := by
  haveI : Fact (Nat.Prime 3) := ⟨Nat.prime_three⟩
  have hcard : Fintype.card (ZMod p)ˣ = p - 1 := ZMod.card_units p
  have hdvd : 3 ∣ Fintype.card (ZMod p)ˣ := by rw [hcard]; omega
  obtain ⟨g, hg⟩ := exists_prime_orderOf_dvd_card 3 hdvd
  have hg3 : ((g : ZMod p)) ^ 3 = 1 := by
    have h : g ^ 3 = 1 := by rw [← hg]; exact pow_orderOf_eq_one g
    simpa using congr_arg (fun u : (ZMod p)ˣ => (u : ZMod p)) h
  have hg1 : ((g : ZMod p)) - 1 ≠ 0 := by
    intro h0
    have h1 : g = 1 := by
      ext
      simpa using sub_eq_zero.mp h0
    rw [h1, orderOf_one] at hg
    norm_num at hg
  refine ⟨(g : ZMod p), ?_⟩
  have hfact : ((g : ZMod p) - 1) * ((g : ZMod p) ^ 2 + (g : ZMod p) + 1) = 0 := by
    linear_combination hg3 - 1
  rcases mul_eq_zero.mp hfact with h1 | h1
  · exact absurd h1 hg1
  · linear_combination h1

/-- If `p ∣ m² + m + 1` then `p` is not irreducible in `ℤ[ω]`. -/
theorem not_irreducible_of_dvd_sq_add_X_add_one {p : ℕ} [hp : Fact p.Prime] {m : ℤ}
    (hm : (p : ℤ) ∣ m ^ 2 + m + 1) : ¬ Irreducible (p : EisensteinInt) := by
  have hpge : 2 ≤ p := hp.out.two_le
  intro hirr
  have hprime : Prime (p : EisensteinInt) := irreducible_iff_prime.mp hirr
  set z : EisensteinInt := (⟨m, -1⟩ : EisensteinInt) with hz
  have hz_norm : normE z = m ^ 2 + m + 1 := by
    rw [hz]
    simp only [normE_mk]
    ring
  have hzw : z * star z = ((m ^ 2 + m + 1 : ℤ) : EisensteinInt) := by
    rw [mul_star, hz_norm]
  have hpz : (p : EisensteinInt) ∣ z * star z := by
    rw [hzw]
    obtain ⟨c, hc⟩ := hm
    refine ⟨(c : EisensteinInt), ?_⟩
    rw [hc]
    push_cast
    try ring
  rcases hprime.dvd_or_dvd hpz with h | h
  · obtain ⟨u, hu⟩ := h
    have him : (z).im = -1 := by simp [hz]
    have hthis := congr_arg EisensteinInt.im hu
    rw [him, im_mul] at hthis
    simp only [re_natCast, im_natCast, zero_mul, zero_add] at hthis
    have hdvd : (p : ℤ) ∣ 1 := ⟨-u.im, by linarith⟩
    have hle : (p : ℤ) ≤ 1 := Int.le_of_dvd one_pos hdvd
    omega
  · obtain ⟨u, hu⟩ := h
    have him : (star z).im = 1 := by simp [hz, star]
    have hthis := congr_arg EisensteinInt.im hu
    rw [him, im_mul] at hthis
    simp only [re_natCast, im_natCast, zero_mul, zero_add] at hthis
    have hdvd : (p : ℤ) ∣ 1 := ⟨u.im, by linarith⟩
    have hle : (p : ℤ) ≤ 1 := Int.le_of_dvd one_pos hdvd
    omega

/-- If `p` is reducible in `ℤ[ω]`, then `p = a² − ab + b²`. -/
theorem exists_normE_of_not_irreducible (p : ℕ) [hp : Fact p.Prime]
    (hpi : ¬ Irreducible (p : EisensteinInt)) : ∃ a b : ℤ, a ^ 2 - a * b + b ^ 2 = p := by
  have hpu : ¬ IsUnit (p : EisensteinInt) := by
    intro hu
    have h1 : normE (p : EisensteinInt) = 1 := isUnit_iff_normE_eq_one.mp hu
    have h2 : normE (p : EisensteinInt) = (p : ℤ) ^ 2 := by
      simp only [normE, re_natCast, im_natCast, mul_zero, sub_zero]
      ring
    rw [h2] at h1
    nlinarith [hp.out.one_lt]
  obtain ⟨a, b, hpab, hau, hbu⟩ : ∃ a b, (p : EisensteinInt) = a * b ∧ ¬IsUnit a ∧ ¬IsUnit b := by
    simpa [irreducible_iff, hpu, not_forall, not_or] using hpi
  have hnorm : normE a * normE b = (p : ℤ) ^ 2 := by
    rw [← normE_mul, ← hpab]
    simp only [normE, re_natCast, im_natCast, mul_zero, sub_zero]
    ring
  have ha_abs : (normE a).natAbs * (normE b).natAbs = p ^ 2 := by
    rw [← Int.natAbs_mul, hnorm, Int.natAbs_pow, Int.natAbs_natCast]
  have ha_ne1 : (normE a).natAbs ≠ 1 := by
    intro h
    apply hau
    rw [isUnit_iff_normE_eq_one, ← Int.natAbs_of_nonneg (normE_nonneg a)]
    exact_mod_cast h
  have hb_ne1 : (normE b).natAbs ≠ 1 := by
    intro h
    apply hbu
    rw [isUnit_iff_normE_eq_one, ← Int.natAbs_of_nonneg (normE_nonneg b)]
    exact_mod_cast h
  have ha_ne0 : (normE a).natAbs ≠ 0 := by
    intro h
    have h0 : normE a = 0 := by
      have := Int.natAbs_eq_zero.mp h
      exact this
    have haz : a = 0 := normE_eq_zero_iff.mp h0
    rw [haz, zero_mul] at hpab
    have hp0 : (p : ℤ) = 0 := by simpa using congr_arg EisensteinInt.re hpab
    have : p = 0 := by exact_mod_cast hp0
    exact hp.out.ne_zero this
  have hb_ne0 : (normE b).natAbs ≠ 0 := by
    intro h
    have h0 : normE b = 0 := Int.natAbs_eq_zero.mp h
    have hbz : b = 0 := normE_eq_zero_iff.mp h0
    rw [hbz, mul_zero] at hpab
    have hp0 : (p : ℤ) = 0 := by simpa using congr_arg EisensteinInt.re hpab
    have : p = 0 := by exact_mod_cast hp0
    exact hp.out.ne_zero this
  have ha2 : 2 ≤ (normE a).natAbs := by omega
  have hb2 : 2 ≤ (normE b).natAbs := by omega
  have hdiv : (normE a).natAbs ∣ p ^ 2 := ⟨(normE b).natAbs, ha_abs.symm⟩
  obtain ⟨k, hk2, hk⟩ := (Nat.dvd_prime_pow hp.out).mp hdiv
  have hk_cases : k = 1 := by
    interval_cases k
    · exact absurd hk ha_ne1
    · rfl
    · exfalso
      have : (normE b).natAbs = 1 := by
        rw [hk] at ha_abs
        have hp0 : 0 < p := hp.out.pos
        nlinarith
      exact hb_ne1 this
  rw [hk_cases] at hk
  have hna : (normE a).natAbs = p := by simpa using hk
  have hpos : 0 ≤ normE a := normE_nonneg a
  have hnorm_a : normE a = (p : ℤ) := by
    rw [← Int.natAbs_of_nonneg hpos, hna]
  refine ⟨a.re, a.im, ?_⟩
  simpa [normE] using hnorm_a

/-- **The split-prime theorem for `d = 3`:** every prime `p ≡ 1 (mod 3)` is of
the form `a² − ab + b²`, i.e. splits in `ℤ[ω]`. -/
theorem prime_normE {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 1) :
    ∃ a b : ℤ, a ^ 2 - a * b + b ^ 2 = p := by
  obtain ⟨x, hx⟩ := exists_root_sq_add_X_add_one hp3
  -- lift the root to `x.val`
  have hval : ((x.val : ℕ) : ZMod p) = x := ZMod.natCast_zmod_val x
  have hzero : ((((x.val : ℤ) ^ 2 + x.val + 1 : ℤ)) : ZMod p) = 0 := by
    have h1 : ((((x.val : ℤ) ^ 2 + x.val + 1 : ℤ)) : ZMod p) =
        ((x.val : ℤ) : ZMod p) ^ 2 + ((x.val : ℤ) : ZMod p) + 1 := by
      push_cast; ring
    rw [h1]
    have hvalZ : ((x.val : ℤ) : ZMod p) = x := by simpa using hval
    rw [hvalZ, hx]
  have hdvdZ : (p : ℤ) ∣ (x.val : ℤ) ^ 2 + x.val + 1 :=
    (ZMod.intCast_zmod_eq_zero_iff_dvd ((x.val : ℤ) ^ 2 + x.val + 1) p).mp hzero
  exact exists_normE_of_not_irreducible p (not_irreducible_of_dvd_sq_add_X_add_one hdvdZ)

end EisensteinInt
