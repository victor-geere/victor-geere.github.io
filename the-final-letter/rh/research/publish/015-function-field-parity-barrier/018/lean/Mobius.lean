/-
  Mobius.lean — 018 round 3

  The linear side of the dictionary, machine-checked.

  The Euler product of the polynomial zeta satisfies
      log ζ(T) = Σ_{n≥1} (Σ_{d|n} d I(d)) T^n / n ,
  so the "point counts" `q^n` are the divisor sums `Σ_{d|n} d I(d)`.  The
  content of the zeta being *linear data* is that this identity inverts:

      q^n = Σ_{d|n} d · I(d)   ⇒   n · I(n) = Σ_{d|n} μ(d) q^{n/d} .

  That is the form proved here, over ℤ and over ℚ.
-/
import Mathlib

namespace ZetaMobius

open ArithmeticFunction

/-- **Möbius inversion of the zeta coefficient identity** (over `ℤ`).  If the
degree counts `I` satisfy the log-Euler-product identity `q^n = Σ_{d|n} d I(d)`
for every `n`, then `n I(n) = Σ_{d|n} μ(d) q^{n/d}`. -/
theorem mobius_inversion (q : ℕ) (I : ℕ → ℤ) (n : ℕ) (hn : 0 < n)
    (h : ∀ m, 0 < m → ∑ d ∈ m.divisors, (Nat.cast d : ℤ) * I d = (q : ℤ) ^ m) :
    (n : ℤ) * I n = ∑ d ∈ n.divisors, (moebius d : ℤ) * (q : ℤ) ^ (n / d) := by
  have h' := (sum_eq_iff_sum_mul_moebius_eq (f := fun d : ℕ => (Nat.cast d : ℤ) * I d)
      (g := fun m => (q : ℤ) ^ m)).mp h n hn
  calc (n : ℤ) * I n
      = ∑ x ∈ n.divisorsAntidiagonal, (moebius x.1 : ℤ) * (q : ℤ) ^ x.2 := h'.symm
    _ = ∑ d ∈ n.divisors, (moebius d : ℤ) * (q : ℤ) ^ (n / d) :=
        Nat.sum_divisorsAntidiagonal (fun a b => (moebius a : ℤ) * (q : ℤ) ^ b)

/-- **Möbius inversion of the zeta coefficient identity** (over `ℚ`). -/
theorem mobius_inversion_rat (q : ℕ) (I : ℕ → ℚ) (n : ℕ) (hn : 0 < n)
    (h : ∀ m, 0 < m → ∑ d ∈ m.divisors, (Nat.cast d : ℚ) * I d = (q : ℚ) ^ m) :
    (n : ℚ) * I n = ∑ d ∈ n.divisors, (moebius d : ℚ) * (q : ℚ) ^ (n / d) := by
  have h' := (sum_eq_iff_sum_mul_moebius_eq (f := fun d : ℕ => (Nat.cast d : ℚ) * I d)
      (g := fun m => (q : ℚ) ^ m)).mp h n hn
  calc (n : ℚ) * I n
      = ∑ x ∈ n.divisorsAntidiagonal, (moebius x.1 : ℚ) * (q : ℚ) ^ x.2 := h'.symm
    _ = ∑ d ∈ n.divisors, (moebius d : ℚ) * (q : ℚ) ^ (n / d) :=
        Nat.sum_divisorsAntidiagonal (fun a b => (moebius a : ℚ) * (q : ℚ) ^ b)

/-- The degree counts, in the form used by the dictionary: since `n > 0`, the
identity `n · I(n) = Σ_{d|n} μ(d) q^{n/d}` is equivalently
`I(n) = (1/n) Σ_{d|n} μ(d) q^{n/d}`. -/
theorem qrime_count (q : ℕ) (I : ℕ → ℚ) (n : ℕ) (hn : 0 < n)
    (h : ∀ m, 0 < m → ∑ d ∈ m.divisors, (Nat.cast d : ℚ) * I d = (q : ℚ) ^ m) :
    (n : ℚ) * I n = ∑ d ∈ n.divisors, (moebius d : ℚ) * (q : ℚ) ^ (n / d) :=
  mobius_inversion_rat q I n hn h

end ZetaMobius
