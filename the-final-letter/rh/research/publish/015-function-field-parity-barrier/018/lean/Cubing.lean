/-
  Cubing.lean — 018 round 12

  The algebraic reason the degree-3 count is independent of the shift when
  `q = 2 (mod 3)`: the cubing map `x ↦ x^3` is a bijection of `F_q`.

  We prove the general lemma for prime fields: if `3 ∤ q - 1`, the only cube
  root of unity is `1`, hence `x ↦ x^3` is injective (and finite, so
  bijective).  The `q = 2 (mod 3)` condition is exactly `3 ∤ q-1` for odd `q`.
-/
import Mathlib

namespace Cubing

/-- The only cube root of unity in `F_q` is `1`, when `3 ∤ q - 1`. -/
theorem cube_eq_one {q : ℕ} [Fact q.Prime] (h : ¬ 3 ∣ q - 1) (u : (ZMod q)ˣ)
    (hu : u ^ 3 = 1) : u = 1 := by
  have h3 : orderOf u ∣ 3 := orderOf_dvd_iff_pow_eq_one.mpr hu
  have hcard : orderOf u ∣ Fintype.card (ZMod q)ˣ := orderOf_dvd_card
  rw [ZMod.card_units_eq_totient, Nat.totient_prime (Fact.out : q.Prime)] at hcard
  have hgcd : orderOf u ∣ Nat.gcd 3 (q - 1) := Nat.dvd_gcd h3 hcard
  have hcop : Nat.Coprime 3 (q - 1) :=
    (Nat.Prime.coprime_iff_not_dvd Nat.prime_three).mpr h
  rw [show Nat.gcd 3 (q - 1) = 1 from hcop] at hgcd
  exact orderOf_eq_one_iff.mp (Nat.dvd_one.mp hgcd)

/-- `x ↦ x^3` is injective on `F_q` when `3 ∤ q - 1`. -/
theorem cube_injective {q : ℕ} [Fact q.Prime] (h : ¬ 3 ∣ q - 1) :
    Function.Injective (fun x : ZMod q => x ^ 3) := by
  intro x y hxy
  by_cases hx : x = 0
  · subst hx
    have hy : y = 0 := by
      have h0 : y ^ 3 = 0 := by simpa using hxy.symm
      exact (pow_eq_zero_iff (by norm_num : (3:ℕ) ≠ 0)).mp h0
    rw [hy]
  · have hy : y ≠ 0 := by
      intro hy0
      subst hy0
      have h0 : x ^ 3 = 0 := by simpa using hxy
      exact hx ((pow_eq_zero_iff (by norm_num : (3:ℕ) ≠ 0)).mp h0)
    let ux : (ZMod q)ˣ := Units.mk0 x hx
    let uy : (ZMod q)ˣ := Units.mk0 y hy
    have huxy : ux ^ 3 = uy ^ 3 := by
      ext
      simp only [ux, uy, Units.val_pow_eq_pow_val, Units.val_mk0, hxy]
    have hu : (ux / uy) ^ 3 = 1 := by
      rw [div_pow, huxy]
      simp
    have h1 : ux / uy = 1 := cube_eq_one h (ux / uy) hu
    have hux : ux = uy := by
      have h2 : ux / uy * uy = 1 * uy := by rw [h1]
      simpa using h2
    have hv := congrArg (fun u : (ZMod q)ˣ => (u : ZMod q)) hux
    simpa [ux, uy] using hv

/-- `x ↦ x^3` is a bijection of `F_q` when `3 ∤ q - 1`. -/
theorem cube_bijective {q : ℕ} [Fact q.Prime] (h : ¬ 3 ∣ q - 1) :
    Function.Bijective (fun x : ZMod q => x ^ 3) := by
  have hinj := cube_injective h
  exact ⟨hinj, Finite.injective_iff_surjective.mp hinj⟩

end Cubing
