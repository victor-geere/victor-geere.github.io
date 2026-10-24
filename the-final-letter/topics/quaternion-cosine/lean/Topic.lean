import Mathlib

/-!
# Quaternion–cosine framework — formal core

The archived source (`archive/essays/rh/riemann-hypothesis.html`) proposes a
quaternion-valued cosine phase

`φ(x) = cos (2π x) i + cos (2π p / x) j`

as a geometric divisor detector, and an alignment energy

`E(x) = (1 - cos (2π x))^2 + (1 - cos (2π p / x))^2`.

This file formalises the elementary, checkable part of that proposal:

* the quaternion relations `i² = j² = k² = -1`, `ij = k`, `ji = -k`;
* the norm of the lifted phase;
* the exact periodicity `cos (2π n) = 1` for integers `n`, hence the
  divisor-detector equivalence;
* non-negativity of the energy and its vanishing exactly at alignment;
* the vanishing of the functional-equation warping factor `2σ - 1` at
  `σ = 1/2`.

The central conjecture of the source — that vanishing alignment energy is
equivalent to a zero of the Riemann xi function, and that this forces
`σ = 1/2` — is *not* formalised and is recorded as an open/source claim in
the programme dossier.
-/

noncomputable section

open scoped Quaternion

namespace QuaternionCosine

/-- The first quaternion unit `i`, as an element of `ℍ[ℝ]`. -/
def I : ℍ[ℝ] := ⟨0, 1, 0, 0⟩

/-- The second quaternion unit `j`, as an element of `ℍ[ℝ]`. -/
def J : ℍ[ℝ] := ⟨0, 0, 1, 0⟩

/-- The third quaternion unit `k`, as an element of `ℍ[ℝ]`. -/
def K : ℍ[ℝ] := ⟨0, 0, 0, 1⟩

/-- The source's quaternion relations `i² = j² = k² = -1`,
`ij = k`, `ji = -k`. -/
theorem quaternion_relations :
    I * I = -1 ∧ J * J = -1 ∧ K * K = -1 ∧ I * J = K ∧ J * I = -K := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> ext <;> norm_num [I, J, K]

/-- The lifted cosine phase `φ = a i + b j`, with real coefficients. -/
def phase (a b : ℝ) : ℍ[ℝ] := ⟨0, a, b, 0⟩

/-- The squared norm of the lifted phase is `a² + b²`. -/
theorem phase_normSq (a b : ℝ) :
    Quaternion.normSq (phase a b) = a ^ 2 + b ^ 2 := by
  simp [phase, Quaternion.normSq_def']

/-- The alignment energy used in the source. -/
def energy (a b : ℝ) : ℝ := (1 - Real.cos a) ^ 2 + (1 - Real.cos b) ^ 2

/-- The alignment energy is non-negative. -/
theorem energy_nonneg (a b : ℝ) : 0 ≤ energy a b := by
  unfold energy
  nlinarith [sq_nonneg (1 - Real.cos a), sq_nonneg (1 - Real.cos b)]

/-- The alignment energy vanishes exactly when both cosines equal one. -/
theorem energy_eq_zero_iff (a b : ℝ) :
    energy a b = 0 ↔ Real.cos a = 1 ∧ Real.cos b = 1 := by
  constructor
  · intro h
    have h1 : (1 - Real.cos a) ^ 2 = 0 := by
      unfold energy at h
      nlinarith [sq_nonneg (1 - Real.cos a), sq_nonneg (1 - Real.cos b)]
    have h2 : (1 - Real.cos b) ^ 2 = 0 := by
      unfold energy at h
      nlinarith [sq_nonneg (1 - Real.cos a), sq_nonneg (1 - Real.cos b)]
    constructor <;> nlinarith
  · rintro ⟨h1, h2⟩
    simp [energy, h1, h2]

/-- `cos (2π x) = 1` exactly when `x` is an integer. This is the elementary
fact behind the source's cosine divisor detector. -/
theorem cos_two_pi_mul_eq_one_iff (x : ℝ) :
    Real.cos (2 * Real.pi * x) = 1 ↔ ∃ n : ℤ, x = n := by
  constructor
  · intro h
    rcases (Real.cos_eq_one_iff (2 * Real.pi * x)).1 h with ⟨n, hn⟩
    refine ⟨n, ?_⟩
    have h2pi : (2 * Real.pi : ℝ) ≠ 0 := by positivity
    have : (2 * Real.pi) * (n : ℝ) = (2 * Real.pi) * x := by
      linarith
    exact (mul_left_cancel₀ h2pi this).symm
  · rintro ⟨n, rfl⟩
    have h := Real.cos_int_mul_two_pi n
    simpa [mul_comm, mul_left_comm, mul_assoc] using h

/-- The scalar divisor detector `cos u + cos v - 2`. -/
def detector (u v : ℝ) : ℝ := Real.cos u + Real.cos v - 2

/-- The detector vanishes exactly when both arguments are integer multiples
of `2π`. For `u = 2π x` and `v = 2π p / x` this says that both `x` and `p/x`
are integers. -/
theorem detector_eq_zero_iff (x p : ℝ) (_hx : x ≠ 0) :
    detector (2 * Real.pi * x) (2 * Real.pi * p / x) = 0 ↔
      (∃ m : ℤ, x = m) ∧ (∃ n : ℤ, p / x = n) := by
  unfold detector
  constructor
  · intro h
    have hcos : Real.cos (2 * Real.pi * x) = 1 ∧
        Real.cos (2 * Real.pi * p / x) = 1 := by
      constructor <;> nlinarith [Real.cos_le_one (2 * Real.pi * x),
        Real.cos_le_one (2 * Real.pi * p / x)]
    constructor
    · exact (cos_two_pi_mul_eq_one_iff x).1 hcos.1
    · have hx' : (2 * Real.pi * p / x) = 2 * Real.pi * (p / x) := by ring
      rw [hx'] at hcos
      exact (cos_two_pi_mul_eq_one_iff (p / x)).1 hcos.2
  · rintro ⟨⟨m, hm⟩, ⟨n, hn⟩⟩
    have h1 : Real.cos (2 * Real.pi * x) = 1 :=
      (cos_two_pi_mul_eq_one_iff x).2 ⟨m, hm⟩
    have h2 : Real.cos (2 * Real.pi * p / x) = 1 := by
      have hx' : (2 * Real.pi * p / x) = 2 * Real.pi * (p / x) := by ring
      rw [hx']
      exact (cos_two_pi_mul_eq_one_iff (p / x)).2 ⟨n, hn⟩
    rw [h1, h2]
    ring

/-- The functional-equation warping factor `2σ - 1`. -/
def warp (σ : ℝ) : ℝ := 2 * σ - 1

/-- The warping factor vanishes exactly on the critical line `σ = 1/2`. -/
theorem warp_eq_zero_iff (σ : ℝ) : warp σ = 0 ↔ σ = 1 / 2 := by
  unfold warp
  constructor <;> intro h <;> linarith

end QuaternionCosine
