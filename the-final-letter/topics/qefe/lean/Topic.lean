import Mathlib

/-!
# Quantum–Egyptian functional equation — formal core

The archived source (`archive/qefe/quantum-egyptian-functional-equation-v8.html`)
claims a Riemann-zeta-type functional equation for a Dirichlet series built from
the *Egyptian denominators* `m_i = D² / d_i²` of an integral modular tensor
category.  The full functional equation is recorded as a source claim in the
programme dossier: the archived proof has an acknowledged gap, and the exact
examples tabulated in the source do not satisfy the displayed identity away from
the central point.

This file proves the elementary part that is genuinely available: the Egyptian
denominator algebra, the finite Egyptian-fraction identity of Lemma 2.2, and the
central-point value of the gamma-factor ratio and the QEFE prefactor.
-/

noncomputable section

open scoped BigOperators
open MeasureTheory

namespace QEFE

/-- The Egyptian denominator `m = D² / d²` attached to an object of squared
quantum dimension `d²`. -/
def egyptianDenom (D2 d2 : ℝ) : ℝ := D2 / d2

/-- The reciprocal Egyptian mass of the non-unit objects predicted by Lemma 2.2:
`1 - 1/D²`. -/
def egyptianUnit (D2 : ℝ) : ℝ := 1 - 1 / D2

/-- Egyptian denominators are positive whenever `D²` and `d²` are. -/
theorem egyptianDenom_pos {D2 d2 : ℝ} (hD : 0 < D2) (hd : 0 < d2) :
    0 < egyptianDenom D2 d2 := by
  unfold egyptianDenom
  exact div_pos hD hd

/-- The reciprocal of an Egyptian denominator is `d² / D²`; this is the
identity used to turn the sum of reciprocals into the quantum-dimension sum. -/
theorem inv_egyptianDenom {D2 d2 : ℝ} (hD : D2 ≠ 0) (hd : d2 ≠ 0) :
    (egyptianDenom D2 d2)⁻¹ = d2 / D2 := by
  unfold egyptianDenom
  field_simp

/-- The non-unit Egyptian mass is positive once `D² > 1`. -/
theorem egyptianUnit_pos {D2 : ℝ} (hD : 1 < D2) : 0 < egyptianUnit D2 := by
  unfold egyptianUnit
  have hpos : 0 < D2 := by linarith
  rw [sub_pos, div_lt_one hpos]
  exact hD

/-- The total Egyptian reciprocal sum is one: `∑_i 1/m_i = 1`. -/
theorem egyptian_total {n : ℕ} (d2 : Fin (n + 1) → ℝ) (D2 : ℝ)
    (hD : D2 = ∑ i, d2 i) (hd : ∀ i, d2 i ≠ 0) (hD0 : D2 ≠ 0) :
    ∑ i, (egyptianDenom D2 (d2 i))⁻¹ = 1 := by
  have h : ∀ i, (egyptianDenom D2 (d2 i))⁻¹ = d2 i / D2 := by
    intro i
    exact inv_egyptianDenom hD0 (hd i)
  simp_rw [h]
  rw [← Finset.sum_div, ← hD]
  exact div_self hD0

/-- Lemma 2.2 of the source: for a finite integral MTC datum with unit object
`d_0² = 1`, the non-unit Egyptian denominators satisfy
`∑_{i ≠ 0} 1/m_i = 1 - 1/D²`. -/
theorem egyptian_fraction_identity {n : ℕ} (d2 : Fin (n + 1) → ℝ) (D2 : ℝ)
    (hD : D2 = ∑ i, d2 i) (h0 : d2 0 = 1) (hd : ∀ i, d2 i ≠ 0) (hD0 : D2 ≠ 0) :
    ∑ i ∈ Finset.univ.erase 0, (egyptianDenom D2 (d2 i))⁻¹ = 1 - 1 / D2 := by
  have h : ∀ i, (egyptianDenom D2 (d2 i))⁻¹ = d2 i / D2 := by
    intro i
    exact inv_egyptianDenom hD0 (hd i)
  have hsplit : ∑ i ∈ Finset.univ.erase 0, d2 i + d2 0 = ∑ i, d2 i :=
    Finset.sum_erase_add Finset.univ d2 (Finset.mem_univ 0)
  have herase : ∑ i ∈ Finset.univ.erase 0, d2 i = D2 - 1 := by
    rw [h0] at hsplit
    linarith
  simp_rw [h]
  rw [← Finset.sum_div, herase]
  field_simp

/-- The gamma-factor ratio appearing in the claimed functional equation. -/
def gammaRatio (a s : ℝ) : ℝ :=
  Real.Gamma ((1 - s + a) / 2) / Real.Gamma ((s + a) / 2)

/-- At the central point `s = 1/2` the gamma-factor ratio is exactly `1`. -/
theorem gammaRatio_center {a : ℝ} (ha : 0 ≤ a) :
    gammaRatio a (1 / 2) = 1 := by
  unfold gammaRatio
  have harg : (1 - (1 / 2 : ℝ) + a) / 2 = ((1 / 2 : ℝ) + a) / 2 := by ring
  rw [harg]
  have hpos : 0 < ((1 / 2 : ℝ) + a) / 2 := by positivity
  exact div_self (ne_of_gt (Real.Gamma_pos_of_pos hpos))

/-- The full prefactor of the claimed QEFE, `(D²/π)^(s-1/2) Γ((1-s+a)/2)/Γ((s+a)/2)`. -/
def qefePrefactor (D2 a s : ℝ) : ℝ :=
  (D2 / Real.pi) ^ (s - 1 / 2) * gammaRatio a s

/-- At `s = 1/2` the QEFE prefactor is exactly `1`, so the claimed functional
equation degenerates to a self-duality statement at the central point. -/
theorem qefePrefactor_center {D2 a : ℝ} (_hD : 0 < D2) (ha : 0 ≤ a) :
    qefePrefactor D2 a (1 / 2) = 1 := by
  unfold qefePrefactor
  rw [gammaRatio_center ha, sub_self, Real.rpow_zero, one_mul]

/-! ## The gamma-pole obstruction to the displayed equation

The claimed equation has `Γ((1-s+a)/2)` on its right-hand side.  That factor has
poles at `s = 1 + a + 2n` for `n ≥ 0`, while the categorical Dirichlet polynomial
`Ψ(s) = ∑ χ_i m_i^{-s}` is entire.  At the first pole the numerator is
`Ψ(-a)`, which is non-zero for both worked examples, so the pole does not
cancel: the displayed identity cannot hold.

The two theorems below evaluate the identity at the poles `s = 3` (Ising,
`a = 0`) and `s = 4` (`SU(2)₄`, `a = 1`).  They use Mathlib's convention
`Real.Gamma (-n) = 0` at non-positive integers; meromorphically, the same point
is a pole of the right-hand side.  Either reading makes the equation fail. -/

/-- Mathlib's value of `Γ` at `-1` (a pole of the meromorphic continuation). -/
lemma Gamma_neg_one : Real.Gamma (-1) = 0 := by
  simpa using Real.Gamma_neg_nat_eq_zero 1

/-- The right-hand side of the claimed QEFE for a real Dirichlet polynomial
`psi` and example data `(D², a, ε)`. -/
def qefeRhs (D2 a eps : ℝ) (psi : ℝ → ℝ) (s : ℝ) : ℝ :=
  eps * (D2 / Real.pi) ^ (s - 1 / 2) * gammaRatio a s * psi (1 - s)

/-- Ising Dirichlet polynomial `Ψ(s) = 2·4^{-s} - 2^{-s}`. -/
def isingPsi (s : ℝ) : ℝ := 2 * (4 : ℝ) ^ (-s) - (2 : ℝ) ^ (-s)

/-- `SU(2)₄` Dirichlet polynomial `Ψ(s) = 2·12^{-s} - 2·4^{-s} + 3^{-s}`. -/
def su2Psi (s : ℝ) : ℝ :=
  2 * (12 : ℝ) ^ (-s) - 2 * (4 : ℝ) ^ (-s) + (3 : ℝ) ^ (-s)

/-- The Ising value at the pole point: `Ψ(3) = -3/32`. -/
theorem isingPsi_three : isingPsi 3 = -3 / 32 := by
  norm_num [isingPsi]

/-- At the first Ising pole `s = 3` the gamma ratio is zero (a pole). -/
theorem gammaRatio_ising_pole : gammaRatio 0 3 = 0 := by
  unfold gammaRatio
  have h : (1 - (3 : ℝ) + 0) / 2 = -1 := by norm_num
  rw [h, Gamma_neg_one, zero_div]

/-- The Ising data refute the displayed QEFE at `s = 3`. -/
theorem qefe_fails_ising : isingPsi 3 ≠ qefeRhs 4 0 1 isingPsi 3 := by
  unfold qefeRhs
  rw [gammaRatio_ising_pole]
  simp [isingPsi]
  norm_num

/-- The `SU(2)₄` value at the pole point: `Ψ(4) = 1/216`. -/
theorem su2Psi_four : su2Psi 4 = 1 / 216 := by
  norm_num [su2Psi]

/-- At the first `SU(2)₄` pole `s = 4` the gamma ratio is zero (a pole). -/
theorem gammaRatio_su2_pole : gammaRatio 1 4 = 0 := by
  unfold gammaRatio
  have h : (1 - (4 : ℝ) + 1) / 2 = -1 := by norm_num
  rw [h, Gamma_neg_one, zero_div]

/-- The `SU(2)₄` data refute the displayed QEFE at `s = 4`. -/
theorem qefe_fails_su2 : su2Psi 4 ≠ qefeRhs 12 1 1 su2Psi 4 := by
  unfold qefeRhs
  rw [gammaRatio_su2_pole]
  simp [su2Psi]
  norm_num

/-! ## The lattice theta

The rank-one lattice `a ℤ` has theta series `∑_{n∈ℤ} exp(-π a² τ n²)`.  Its
modular transformation is proved here from Mathlib's Gaussian Poisson
summation (`Real.tsum_exp_neg_mul_int_sq`).  This is the analytic input for the
lattice `L`-series programme. -/

/-- The theta series of the one-dimensional lattice `a ℤ`. -/
def thetaL (a τ : ℝ) : ℝ :=
  ∑' n : ℤ, Real.exp (-Real.pi * a ^ 2 * τ * (n : ℝ) ^ 2)

/-- **T8:** the rank-one lattice theta transforms with weight `1/2`:
`Θ_{aℤ}(1/τ) = (√τ / a) Θ_{(1/a)ℤ}(τ)`.  For the self-dual lattice `a = 1`
this is `Θ(1/τ) = √τ Θ(τ)`. -/
theorem thetaL_one_div (ha : 0 < a) (hτ : 0 < τ) :
    thetaL a (1 / τ) = Real.sqrt τ / a * thetaL (1 / a) τ := by
  unfold thetaL
  have hA : 0 < a ^ 2 * (1 / τ) := by positivity
  simp_rw [show ∀ n : ℤ, -Real.pi * a ^ 2 * (1 / τ) * (n : ℝ) ^ 2
      = -Real.pi * (a ^ 2 * (1 / τ)) * (n : ℝ) ^ 2 by intro n; ring]
  rw [Real.tsum_exp_neg_mul_int_sq hA]
  have hsum : (∑' n : ℤ, Real.exp (-Real.pi / (a ^ 2 * (1 / τ)) * (n : ℝ) ^ 2))
      = ∑' n : ℤ, Real.exp (-Real.pi * (1 / a) ^ 2 * τ * (n : ℝ) ^ 2) := by
    apply tsum_congr
    intro n
    congr 1
    field_simp
  rw [hsum]
  have hfac : (1 : ℝ) / (a ^ 2 * (1 / τ)) ^ (1 / 2 : ℝ) = Real.sqrt τ / a := by
    rw [show a ^ 2 * (1 / τ) = a ^ 2 / τ by ring]
    rw [← Real.sqrt_eq_rpow]
    rw [Real.sqrt_div (by positivity : (0:ℝ) ≤ a ^ 2)]
    simp [Real.sqrt_sq ha.le]
  rw [hfac]

/-- The theta series of the square lattice `ℤ²`, written as the square of the
rank-one theta. -/
def theta2 (τ : ℝ) : ℝ := thetaL 1 τ ^ 2

/-- **T9:** the square-lattice theta transforms with weight `1`:
`Θ_{ℤ²}(1/τ) = τ Θ_{ℤ²}(τ)`. -/
theorem theta2_one_div (hτ : 0 < τ) :
    theta2 (1 / τ) = τ * theta2 τ := by
  unfold theta2
  rw [thetaL_one_div one_pos hτ, div_one]
  rw [mul_pow, Real.sq_sqrt hτ.le]
  ring

/-- The theta series of the cubic lattice `ℤ^n`, written as the `n`-th power
of the rank-one theta. -/
def thetaZn (n : ℕ) (τ : ℝ) : ℝ := (thetaL 1 τ) ^ n

/-- **T28:** the rank-`n` cubic-lattice theta transforms with weight `n/2`:
`Θ_{ℤ^n}(1/τ) = τ^(n/2) Θ_{ℤ^n}(τ)`. -/
theorem thetaZn_one_div (n : ℕ) (hτ : 0 < τ) :
    thetaZn n (1 / τ) = τ ^ ((n : ℝ) / 2) * thetaZn n τ := by
  unfold thetaZn
  rw [thetaL_one_div one_pos hτ, div_one, mul_pow]
  have hsqrt : (Real.sqrt τ) ^ n = τ ^ ((n : ℝ) / 2) := by
    rw [Real.sqrt_eq_rpow, ← Real.rpow_natCast, ← Real.rpow_mul hτ.le]
    congr 1
    ring
  rw [hsqrt]
  norm_num

/-! ## Finite Galois sign data -/

/-- The normalized Ising `S`-matrix with `r = √2`. -/
def isingS (r : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  (1 / 2 : ℝ) • !![1, r, 1; r, 0, -r; 1, -r, 1]

/-- The Ising sign vector `(1, -1, 1)`. -/
def isingEps : Fin 3 → ℝ := ![1, -1, 1]

/-- **T10:** the Ising sign datum.  For every `r`, the substitution `r ↦ -r` acts
on the normalized `S`-matrix by `S(-r)_{ij} = ε_i ε_j S(r)_{ij}` with
`ε = (1, -1, 1)`.  Taking `r = √2` gives the Galois conjugation. -/
theorem ising_galois (r : ℝ) :
    ∀ i j : Fin 3, isingS (-r) i j = isingEps i * isingEps j * isingS r i j := by
  intro i j
  fin_cases i <;> fin_cases j <;>
    simp [isingS, isingEps] <;> ring

/-- The normalized `SU(2)₄` `S`-matrix with `r = √3`. -/
def su2S (r : ℝ) : Matrix (Fin 5) (Fin 5) ℝ :=
  (1 / 12 : ℝ) •
    !![1, r, 2, r, 1;
       r, r, 0, -r, -r;
       2, 0, -2, 0, 2;
       r, -r, 0, r, -r;
       1, -r, 2, -r, 1]

/-- **T11:** the nontrivial `√3`-conjugation of `SU(2)₄` has no sign/permutation
datum.  If `r² = 3` and `S(-r)_{ij} = ε_i ε_j S(r)_{π(i),π(j)}` for signs
`ε_i = ±1`, comparison at `(1,1)` forces `r ∈ {0, -1, 2}` (depending on `π(1)`),
contradicting `r² = 3`. -/
theorem su2_no_signs (r : ℝ) (hr : 0 < r) (hr2 : r ^ 2 = 3)
    (π : Equiv (Fin 5) (Fin 5)) (ε : Fin 5 → ℝ)
    (hε : ∀ i, ε i = 1 ∨ ε i = -1)
    (h : ∀ i j : Fin 5, su2S (-r) i j = ε i * ε j * su2S r (π i) (π j)) :
    False := by
  have h11 := h 1 1
  have he1 : ε 1 * ε 1 = 1 := by
    rcases hε 1 with h1 | h1 <;> simp [h1]
  simp only [su2S, Matrix.smul_apply, Matrix.cons_val', Matrix.empty_val',
    Matrix.cons_val_fin_one, Matrix.cons_val_zero, Matrix.cons_val_succ] at h11
  generalize hk : π 1 = k at h11
  fin_cases k <;> simp [su2S, he1] at h11 <;> nlinarith [hr2]

/-- **T12:** a lattice-VOA realisation with one simple object per lattice coset
forces all squared quantum dimensions to be `1`.  If the number of objects is
`n` and `d_i² = f i` sums to `D² = n`, then every `f i = 1`.  In particular a
non-pointed category (some `d_i² > 1`) cannot come from a single lattice VOA. -/
theorem lattice_realisation_pointed {n : ℕ} (f : Fin n → ℕ)
    (hpos : ∀ i, 0 < f i) (hsum : ∑ i, f i = n) : ∀ i, f i = 1 := by
  intro i
  by_contra hi
  have h1 : f i ≠ 0 := ne_of_gt (hpos i)
  have hi2 : 2 ≤ f i := by omega
  have hsplit : ∑ j, f j = f i + ∑ j ∈ Finset.univ.erase i, f j := by
    rw [← Finset.sum_erase_add (s := Finset.univ) (a := i) (f := f) (by simp)]
    rw [add_comm]
  have herase : ∑ j ∈ Finset.univ.erase i, f j ≥ ∑ _j ∈ Finset.univ.erase i, (1 : ℕ) :=
    Finset.sum_le_sum (fun j _ => hpos j)
  have hcard : ∑ _j ∈ Finset.univ.erase i, (1 : ℕ) = n - 1 := by
    simp
  omega

/-! ## Worked-example computations -/

/-- Ising squared quantum dimensions `(1,2,1)`. -/
def isingDsq : Fin 3 → ℝ := ![1, 2, 1]

/-- `SU(2)₄` squared quantum dimensions `(1,3,4,3,1)`. -/
def su2Dsq : Fin 5 → ℝ := ![1, 3, 4, 3, 1]

/-- **T13:** the Egyptian sums for the two worked examples. -/
theorem egyptian_examples :
    (∑ i, isingDsq i / 4 = 1) ∧
    (∑ i ∈ Finset.univ.erase (0 : Fin 3), isingDsq i / 4 = 3 / 4) ∧
    (∑ i, su2Dsq i / 12 = 1) ∧
    (∑ i ∈ Finset.univ.erase (0 : Fin 5), su2Dsq i / 12 = 11 / 12) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    norm_num [isingDsq, su2Dsq, Fin.sum_univ_three, Fin.sum_univ_five]

/-- **T14:** the Ising polynomial at `s = 0, 1`. -/
theorem ising_psi_zero_one : isingPsi 0 = 1 ∧ isingPsi 1 = 0 := by
  constructor <;> norm_num [isingPsi]

/-- **T14:** the `SU(2)₄` polynomial at `s = 0, 1`. -/
theorem su2_psi_zero_one : su2Psi 0 = 1 ∧ su2Psi 1 = 0 := by
  constructor <;> norm_num [su2Psi]

/-- The finite theta of a categorical datum:
`Θ(τ) = Σ_i χ_i exp(-π τ / d_i²)`. -/
def finiteTheta (n : ℕ) (chi dsq : Fin n → ℝ) (τ : ℝ) : ℝ :=
  ∑ i ∈ Finset.univ, chi i * Real.exp (-(Real.pi / dsq i) * τ)

/-- **T15:** the Mellin transform of the finite theta.  For `Re s > 0`,
`∫_0^∞ τ^(s-1) Θ(τ) dτ = Γ(s) π^(-s) Σ_i χ_i d_i^(2s)`. -/
theorem finiteTheta_mellin {n : ℕ} (chi dsq : Fin n → ℝ)
    (hdsq : ∀ i, 0 < dsq i) {s : ℝ} (hs : 0 < s) :
    ∫ τ in Set.Ioi (0 : ℝ), τ ^ (s - 1) * finiteTheta n chi dsq τ
      = Real.Gamma s * Real.pi ^ (-s) * ∑ i ∈ Finset.univ, chi i * (dsq i) ^ s := by
  simp_rw [finiteTheta, Finset.mul_sum]
  rw [integral_finsetSum]
  · apply Finset.sum_congr rfl
    intro i _
    rw [show (fun τ : ℝ => τ ^ (s - 1) * (chi i * Real.exp (-(Real.pi / dsq i) * τ)))
        = fun τ => chi i * (τ ^ (s - 1) * Real.exp (-(Real.pi / dsq i) * τ)) by
      funext τ; ring]
    rw [integral_const_mul]
    simp_rw [show ∀ a : ℝ, -(Real.pi / dsq i) * a = -(Real.pi / dsq i * a) by
      intro a; ring]
    rw [Real.integral_rpow_mul_exp_neg_mul_Ioi (by linarith : (0:ℝ) < s)
      (div_pos Real.pi_pos (hdsq i))]
    have hx : 0 < Real.pi / dsq i := div_pos Real.pi_pos (hdsq i)
    have hmain : (1 / (Real.pi / dsq i)) ^ s = (dsq i) ^ s * Real.pi ^ (-s) := by
      rw [one_div, Real.inv_rpow (le_of_lt hx),
        Real.div_rpow Real.pi_pos.le (le_of_lt (hdsq i)), Real.rpow_neg Real.pi_pos.le s]
      field_simp
    rw [hmain]
    ring
  · intro i _
    have h : IntegrableOn (fun τ : ℝ => τ ^ (s - 1) * Real.exp (-(Real.pi / dsq i) * τ))
        (Set.Ioi 0) := by
      simpa using (integrableOn_rpow_mul_exp_neg_mul_rpow (p := 1)
        (b := Real.pi / dsq i) (s := s - 1) (by linarith) one_pos
        (div_pos Real.pi_pos (hdsq i)))
    simpa [mul_assoc, mul_comm, mul_left_comm] using h.const_mul (chi i)

/-- The Ising `T`-eigenvalues `(1, e^{πi/8}, -1)`. -/
def isingTheta : Fin 3 → ℂ :=
  ![1, Complex.exp (Complex.I * (Real.pi / 8)), -1]

/-- **T16:** the Ising normalized Gauss root number is `e^{πi/8}`. -/
theorem ising_root_number :
    (∑ i, (isingDsq i : ℂ) * isingTheta i) / 2
      = Complex.exp (Complex.I * (Real.pi / 8)) := by
  simp [isingDsq, isingTheta, Fin.sum_univ_three]

/-- The `SU(2)₄` `T`-eigenvalues `(1, e^{πi/4}, e^{2πi/3}, e^{5πi/4}, 1)`. -/
def su2Theta : Fin 5 → ℂ :=
  ![1,
    Complex.exp (Complex.I * (Real.pi / 4)),
    Complex.exp (Complex.I * (2 * Real.pi / 3)),
    Complex.exp (Complex.I * (5 * Real.pi / 4)),
    1]

lemma su2_exp_five :
    Complex.exp (Complex.I * (5 * Real.pi / 4))
      = - Complex.exp (Complex.I * (Real.pi / 4)) := by
  rw [show Complex.I * (5 * Real.pi / 4)
      = Complex.I * (Real.pi / 4) + (Real.pi : ℂ) * Complex.I by
    push_cast; ring]
  rw [Complex.exp_add, Complex.exp_pi_mul_I]
  ring

lemma su2_exp_two_thirds :
    Complex.exp (Complex.I * (2 * Real.pi / 3))
      = (-1 / 2 : ℂ) + (Real.sqrt 3 / 2 : ℂ) * Complex.I := by
  rw [show Complex.I * (2 * Real.pi / 3) = (2 * Real.pi / 3 : ℝ) * Complex.I by
    push_cast; ring]
  rw [Complex.exp_ofReal_mul_I]
  rw [show (2 * Real.pi / 3 : ℝ) = Real.pi - Real.pi / 3 by ring]
  rw [Real.cos_pi_sub, Real.sin_pi_sub, Real.cos_pi_div_three, Real.sin_pi_div_three]
  push_cast
  ring

/-- **T17:** the `SU(2)₄` normalized Gauss root number is `i`. -/
theorem su2_root_number :
    (∑ i, (su2Dsq i : ℂ) * su2Theta i) / (2 * (Real.sqrt 3 : ℂ)) = Complex.I := by
  have hsum : (∑ i, (su2Dsq i : ℂ) * su2Theta i)
      = 2 * (Real.sqrt 3 : ℂ) * Complex.I := by
    simp [su2Dsq, su2Theta, Fin.sum_univ_five, su2_exp_five, su2_exp_two_thirds]
    ring
  rw [hsum]
  field_simp

/-- **T18:** the `SU(2)₄` polynomial at `s = 2` and `s = 3`. -/
theorem su2_psi_two_three : su2Psi 2 = 0 ∧ su2Psi 3 = 1 / 144 := by
  constructor <;> norm_num [su2Psi]

/-- The categorical Dirichlet polynomial
`Ψ(s) = Σ_i χ_i (D²/d_i²)^(-s)`. -/
def categoricalPsi (n : ℕ) (chi dsq : Fin n → ℝ) (D2 s : ℝ) : ℝ :=
  ∑ i, chi i * (D2 / dsq i) ^ (-s)

/-- **T19:** the bridge `D^(2s) Ψ(s) = Σ_i χ_i d_i^(2s)`. -/
theorem D2_rpow_mul_categoricalPsi {n : ℕ} (chi dsq : Fin n → ℝ) (D2 s : ℝ)
    (hD2 : 0 < D2) (hdsq : ∀ i, 0 < dsq i) :
    D2 ^ s * categoricalPsi n chi dsq D2 s
      = ∑ i, chi i * (dsq i) ^ s := by
  unfold categoricalPsi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  have hd := hdsq i
  have hterm : D2 ^ s * (D2 / dsq i) ^ (-s) = (dsq i) ^ s := by
    rw [Real.div_rpow (le_of_lt hD2) (le_of_lt hd), Real.rpow_neg (le_of_lt hD2)]
    field_simp
    rw [← Real.rpow_add hd]
    simp
  rw [← hterm]
  ring

/-- **T20:** the Mellin transform in categorical form,
`∫_0^∞ τ^(s-1) Θ(τ) dτ = Γ(s) π^(-s) D^(2s) Ψ(s)`. -/
theorem finiteTheta_mellin_categorical {n : ℕ} (chi dsq : Fin n → ℝ) (D2 s : ℝ)
    (hD2 : 0 < D2) (hdsq : ∀ i, 0 < dsq i) (hs : 0 < s) :
    ∫ τ in Set.Ioi (0 : ℝ), τ ^ (s - 1) * finiteTheta n chi dsq τ
      = Real.Gamma s * Real.pi ^ (-s) * (D2 ^ s * categoricalPsi n chi dsq D2 s) := by
  rw [finiteTheta_mellin chi dsq hdsq hs]
  rw [← D2_rpow_mul_categoricalPsi chi dsq D2 s hD2 hdsq]

/-- The primitive quadratic character modulo `4`, with complex values. -/
def chi4 : DirichletCharacter ℂ 4 where
  toFun a := (ZMod.χ₄ a : ℂ)
  map_one' := by simp
  map_mul' := by
    intro a b
    norm_cast
    exact map_mul ZMod.χ₄ a b
  map_nonunit' := by
    intro a ha
    norm_cast
    exact MulChar.map_nonunit ZMod.χ₄ ha

/-- **T21:** the character `χ₄` is odd, `χ₄(-1) = -1`. -/
theorem chi4_neg_one : chi4 (-1 : ZMod 4) = -1 := by
  have h : (-1 : ZMod 4) = 3 := by decide
  rw [h]
  simp [chi4]

lemma chi4_three : chi4 (3 : ZMod 4) = -1 := by simp [chi4]

lemma chi4_ne_one : chi4 ≠ 1 := by
  intro h
  have h3 := chi4_three
  rw [h] at h3
  rw [MulChar.one_apply (by decide : IsUnit (3 : ZMod 4))] at h3
  norm_num at h3

lemma chi4_not_factors_one : ¬ DirichletCharacter.FactorsThrough chi4 1 := by
  rw [DirichletCharacter.factorsThrough_one_iff]
  exact chi4_ne_one

lemma chi4_not_factors_two : ¬ DirichletCharacter.FactorsThrough chi4 2 := by
  rintro ⟨hdvd, χ₀, hχ⟩
  have h3 := chi4_three
  rw [hχ] at h3
  have hcast : (DirichletCharacter.changeLevel hdvd χ₀) (3 : ZMod 4)
      = χ₀ (3 : ZMod 2) :=
    DirichletCharacter.changeLevel_eq_cast_of_dvd' χ₀ hdvd
      (a := 3) (by decide : IsCoprime (3 : ℤ) 4)
  rw [hcast] at h3
  have h32 : (3 : ZMod 2) = 1 := by decide
  rw [h32, map_one] at h3
  norm_num at h3

/-- **T22:** the conductor of `χ₄` is `4`. -/
lemma chi4_conductor : DirichletCharacter.conductor chi4 = 4 := by
  classical
  apply le_antisymm
  · exact Nat.sInf_le (DirichletCharacter.level_mem_conductorSet chi4)
  · change 4 ≤ sInf (DirichletCharacter.conductorSet chi4)
    rw [Nat.sInf_def ⟨4, DirichletCharacter.level_mem_conductorSet chi4⟩]
    rw [Nat.le_find_iff]
    intro m hm4 hmem
    have hdvd : m ∣ 4 := hmem.dvd
    interval_cases m
    · exact DirichletCharacter.zero_ne_mem_conductorSet (χ := chi4) hmem
    · exact chi4_not_factors_one hmem
    · exact chi4_not_factors_two hmem
    · norm_num at hdvd

/-- **T23:** `χ₄` is primitive. -/
theorem chi4_primitive : DirichletCharacter.IsPrimitive chi4 := by
  rw [DirichletCharacter.isPrimitive_def chi4]
  exact chi4_conductor

/-- **T24:** the functional equation of the completed `L`-function of `χ₄`. -/
theorem chi4_completedLFunction_one_sub (s : ℂ) :
    DirichletCharacter.completedLFunction chi4 (1 - s)
      = (4 : ℂ) ^ (s - 1 / 2) * DirichletCharacter.rootNumber chi4 *
        DirichletCharacter.completedLFunction chi4⁻¹ s :=
  chi4_primitive.completedLFunction_one_sub s

/-! ## The phase-corrected categorical series -/

/-- The phase-corrected finite categorical series
`Ψ(s,t) = Σ_i χ_i m_i^(-σ) e^(-it log m_i)`, written as a complex sum. -/
def phasePsi (n : ℕ) (chi m : Fin n → ℝ) (σ t : ℝ) : ℂ :=
  ∑ i, (chi i : ℂ) *
    Complex.exp (-(σ : ℂ) * (Real.log (m i) : ℂ)) *
    Complex.exp (-(t : ℂ) * (Real.log (m i) : ℂ) * Complex.I)

lemma exp_ofReal_star (x : ℝ) :
    starRingEnd ℂ (Complex.exp (x : ℂ)) = Complex.exp (x : ℂ) := by
  rw [← Complex.exp_conj]
  congr 1
  simp

lemma exp_phase_conj (t l : ℝ) :
    Complex.exp (t * l * Complex.I)
      = starRingEnd ℂ (Complex.exp (-(t * l * Complex.I))) := by
  rw [← Complex.exp_conj]
  congr 1
  simp

/-- **T25:** time reversal is conjugation: `Ψ(σ,-t) = conj Ψ(σ,t)`. -/
theorem phasePsi_conj (n : ℕ) (chi m : Fin n → ℝ) (σ t : ℝ) :
    phasePsi n chi m σ (-t) = starRingEnd ℂ (phasePsi n chi m σ t) := by
  unfold phasePsi
  simp only [map_sum, map_mul, Complex.conj_ofReal]
  apply Finset.sum_congr rfl
  intro i _
  have hreal : (-↑σ : ℂ) * ↑(Real.log (m i)) = ↑(-(σ * Real.log (m i))) := by
    push_cast
    ring
  simp only [hreal, exp_ofReal_star]
  rw [show (-↑(-t) : ℂ) * ↑(Real.log (m i)) * Complex.I
      = ↑t * ↑(Real.log (m i)) * Complex.I by push_cast; ring]
  rw [exp_phase_conj t (Real.log (m i))]
  congr 2
  ring

/-- The quadratic character `χ₄` on the integers, with complex values. -/
def chi4Int (n : ℤ) : ℂ := ((ZMod.χ₄ (n : ZMod 4) : ℤ) : ℂ)


lemma sin_zero_mod (k : ℤ) : Complex.sin (Real.pi * (4 * k) / 2 : ℂ) = 0 := by
  rw [show (Real.pi * (4 * (k : ℂ)) / 2) =
      ((Real.pi * (2 * (k : ℝ)) : ℝ) : ℂ) by push_cast; ring]
  rw [← Complex.ofReal_sin]
  rw [show Real.pi * (2 * (k : ℝ)) = ((2 * k : ℤ) : ℝ) * Real.pi by push_cast; ring]
  rw [Real.sin_int_mul_pi]
  norm_num

lemma sin_one_mod (k : ℤ) : Complex.sin (Real.pi * (1 + 4 * k) / 2 : ℂ) = 1 := by
  rw [show (Real.pi * (1 + 4 * (k : ℂ)) / 2) =
      ((Real.pi * (1 + 4 * (k : ℝ)) / 2 : ℝ) : ℂ) by push_cast; ring]
  rw [← Complex.ofReal_sin]
  congr 1
  rw [show Real.pi * (1 + 4 * (k : ℝ)) / 2 = Real.pi / 2 + (k : ℝ) * (2 * Real.pi) by ring]
  rw [Real.sin_add_int_mul_two_pi, Real.sin_pi_div_two]

lemma sin_two_mod (k : ℤ) : Complex.sin (Real.pi * (2 + 4 * k) / 2 : ℂ) = 0 := by
  rw [show (Real.pi * (2 + 4 * (k : ℂ)) / 2) =
      ((Real.pi * (2 + 4 * (k : ℝ)) / 2 : ℝ) : ℂ) by push_cast; ring]
  rw [← Complex.ofReal_sin]
  congr 1
  rw [show Real.pi * (2 + 4 * (k : ℝ)) / 2 = Real.pi + (k : ℝ) * (2 * Real.pi) by ring]
  rw [Real.sin_add_int_mul_two_pi, Real.sin_pi]

lemma sin_three_mod (k : ℤ) : Complex.sin (Real.pi * (3 + 4 * k) / 2 : ℂ) = -1 := by
  rw [show (Real.pi * (3 + 4 * (k : ℂ)) / 2) =
      ((Real.pi * (3 + 4 * (k : ℝ)) / 2 : ℝ) : ℂ) by push_cast; ring]
  rw [← Complex.ofReal_sin]
  congr 1
  rw [show Real.pi * (3 + 4 * (k : ℝ)) / 2 =
      (Real.pi / 2 + Real.pi) + (k : ℝ) * (2 * Real.pi) by ring]
  rw [Real.sin_add_int_mul_two_pi, Real.sin_add_pi, Real.sin_pi_div_two]
  norm_num

/-- **T45:** the integer character equals the sine character:
`χ₄(n) = sin(πn/2)`. -/
lemma chi4Int_eq_sin (n : ℤ) :
    chi4Int n = (Real.sin (Real.pi * n / 2) : ℂ) := by
  unfold chi4Int
  rw [ZMod.χ₄_int_eq_if_mod_four]
  have hnon : 0 ≤ n % 4 := Int.emod_nonneg n (by norm_num)
  have hlt : n % 4 < 4 := Int.emod_lt_of_pos n (by norm_num)
  have hdec : n = (n % 4) + 4 * (n / 4) := by
    have h := Int.emod_add_mul_ediv n 4
    linarith
  interval_cases h : n % 4
  · have hd : (2 : ℤ) ∣ 4 * (n / 4) := ⟨2 * (n / 4), by ring⟩
    rw [hdec]
    norm_num
    simp [hd]
    exact (sin_zero_mod (n / 4)).symm
  · have hd : ¬ (2 : ℤ) ∣ 1 + 4 * (n / 4) := by omega
    rw [hdec]
    norm_num
    simp [hd]
    exact (sin_one_mod (n / 4)).symm
  · have hd : (2 : ℤ) ∣ 2 + 4 * (n / 4) := ⟨1 + 2 * (n / 4), by ring⟩
    rw [hdec]
    norm_num
    have hd2 : (2 : ℤ) ∣ 4 * (n / 4) := ⟨2 * (n / 4), by ring⟩
    simp [hd2]
    exact (sin_two_mod (n / 4)).symm
  · have hd : ¬ (2 : ℤ) ∣ 3 + 4 * (n / 4) := by omega
    rw [hdec]
    norm_num
    simp [hd]
    exact (sin_three_mod (n / 4)).symm


/-- **T29:** `χ₄` has period `4`. -/
lemma chi4Int_add_four (n : ℤ) : chi4Int (n + 4) = chi4Int n := by
  unfold chi4Int
  congr 1
  push_cast
  rw [show (4 : ZMod 4) = 0 by decide, add_zero]

/-- **T30:** `χ₄` is odd. -/
lemma chi4Int_neg (n : ℤ) : chi4Int (-n) = -chi4Int n := by
  unfold chi4Int
  have h : ((-n : ℤ) : ZMod 4) = -(n : ZMod 4) := by push_cast; ring
  rw [h]
  rw [show -(n : ZMod 4) = (-1 : ZMod 4) * (n : ZMod 4) by ring, map_mul]
  have hneg : ZMod.χ₄ (-1 : ZMod 4) = -1 := by decide
  rw [hneg]
  push_cast
  ring

/-- **T31:** the Gaussian-times-`n` kernel is summable on `ℕ`:
`Σ n exp(-a n²)` converges for every `a > 0`. -/
lemma summable_nat_mul_exp_neg_sq (a : ℝ) (ha : 0 < a) :
    Summable fun n : ℕ => (n : ℝ) * Real.exp (-a * (n : ℝ) ^ 2) := by
  have hbase : Summable fun n : ℕ => (n : ℝ) ^ 1 * Real.exp (-a * (n : ℝ)) := by
    simpa using Real.summable_pow_mul_exp_neg_nat_mul 1 ha
  refine Summable.of_nonneg_of_le (fun n => by positivity) (fun n => ?_) hbase
  have hn : (n : ℝ) ≤ (n : ℝ) ^ 2 := by
    rcases n with _ | n
    · norm_num
    · push_cast
      have h : (0 : ℝ) ≤ n := by exact_mod_cast Nat.zero_le n
      nlinarith [sq_nonneg (n : ℝ), h]
  have harg : -a * (n : ℝ) ^ 2 ≤ -a * (n : ℝ) := by nlinarith
  have hexp : Real.exp (-a * (n : ℝ) ^ 2) ≤ Real.exp (-a * (n : ℝ)) :=
    Real.exp_le_exp.mpr harg
  simpa [pow_one] using mul_le_mul_of_nonneg_left hexp (Nat.cast_nonneg n)

/-- The `χ₄` Gauss sum `Σ_{a mod 4} χ₄(a) e^(2πia/4)`. -/
def gaussSumChi4 : ℂ :=
  ∑ a : Fin 4, (ZMod.χ₄ (a : ZMod 4) : ℂ) *
    Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) / 4)

/-- **T38:** the `χ₄` Gauss sum is `2i`. -/
theorem gaussSumChi4_eq : gaussSumChi4 = 2 * Complex.I := by
  unfold gaussSumChi4
  rw [Fin.sum_univ_four]
  norm_num [ZMod.χ₄]
  rw [show (2 * ↑Real.pi * Complex.I / 4) = (Real.pi / 2) * Complex.I by
    push_cast; ring]
  rw [show (2 * ↑Real.pi * Complex.I * 3 / 4) =
      Real.pi * Complex.I + (Real.pi / 2) * Complex.I by push_cast; ring]
  rw [Complex.exp_add, Complex.exp_pi_mul_I, Complex.exp_pi_div_two_mul_I]
  ring

/-- The normalized `χ₄` root number. -/
def rootNumberChi4 : ℂ := gaussSumChi4 / 2

/-- **T39:** the normalized root number is `i`. -/
theorem rootNumberChi4_eq : rootNumberChi4 = Complex.I := by
  unfold rootNumberChi4
  rw [gaussSumChi4_eq]
  ring

/-- **T33:** the integer character is bounded by `1`. -/
lemma norm_chi4Int_le_one (n : ℤ) : ‖chi4Int n‖ ≤ 1 := by
  unfold chi4Int
  rw [ZMod.χ₄_int_eq_if_mod_four]
  split_ifs <;> norm_num

/-- The real-cast theta kernel `n e^(-a n²)`. -/
def thetaKernel (a : ℝ) (n : ℤ) : ℂ :=
  (n : ℂ) * (Real.exp (-a * (n : ℝ) ^ 2) : ℂ)

lemma norm_thetaKernel (a : ℝ) (n : ℤ) :
    ‖thetaKernel a n‖ = |(n : ℝ)| * Real.exp (-a * (n : ℝ) ^ 2) := by
  unfold thetaKernel
  rw [norm_mul]
  have hn : ‖(n : ℂ)‖ = |(n : ℝ)| := by
    rw [show (n : ℂ) = ((n : ℝ) : ℂ) by norm_num]
    rw [Complex.norm_real, Real.norm_eq_abs]
  rw [hn]
  have he : ‖((Real.exp (-a * (n : ℝ) ^ 2) : ℝ) : ℂ)‖ =
      Real.exp (-a * (n : ℝ) ^ 2) := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  rw [he]

lemma thetaKernel_neg (a : ℝ) (n : ℤ) :
    thetaKernel a (-n) = -thetaKernel a n := by
  unfold thetaKernel
  norm_num

/-- **T41:** the Gaussian is summable over `ℤ` for `a > 0`. -/
lemma summable_gaussian_int (a : ℝ) (ha : 0 < a) :
    Summable fun n : ℤ => Real.exp (-a * (n : ℝ) ^ 2) := by
  have hpos : Summable fun n : ℕ => Real.exp (-a * (n : ℝ) ^ 2) := by
    have hbase : Summable fun n : ℕ => Real.exp (-a * (n : ℝ)) := by
      have h : Summable fun n : ℕ => Real.exp ((n : ℝ) * (-a)) :=
        Real.summable_exp_nat_mul_iff.mpr (by linarith)
      simpa [mul_comm] using h
    refine Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) (fun n => ?_) hbase
    apply Real.exp_le_exp.mpr
    have hn : (n : ℝ) ≤ (n : ℝ) ^ 2 := by
      rcases n with _ | n
      · norm_num
      · push_cast
        have h : (0 : ℝ) ≤ n := by exact_mod_cast Nat.zero_le n
        nlinarith [sq_nonneg (n : ℝ), h]
    nlinarith
  have hneg : Summable fun n : ℕ => Real.exp (-a * ((-(n + 1 : ℕ) : ℤ) : ℝ) ^ 2) := by
    have hs : Summable fun n : ℕ => Real.exp (-a * ((n + 1 : ℕ) : ℝ) ^ 2) :=
      hpos.comp_injective Nat.succ_injective
    refine hs.congr (fun n => ?_)
    congr 2
    push_cast
    ring
  exact Summable.of_nat_of_neg_add_one hpos hneg

/-- **T32:** the theta kernel is summable over `ℤ` for `a > 0`. -/
lemma summable_thetaKernel_int (a : ℝ) (ha : 0 < a) :
    Summable fun n : ℤ => thetaKernel a n := by
  have hpos : Summable fun n : ℕ => thetaKernel a (n : ℤ) := by
    refine Summable.of_norm_bounded (summable_nat_mul_exp_neg_sq a ha) (fun n => ?_)
    rw [norm_thetaKernel]
    norm_num
  have hneg : Summable fun n : ℕ => thetaKernel a (-(n + 1 : ℕ) : ℤ) := by
    have hs : Summable fun n : ℕ => thetaKernel a ((n + 1 : ℕ) : ℤ) :=
      hpos.comp_injective Nat.succ_injective
    have h : (fun n : ℕ => thetaKernel a (-↑(n + 1) : ℤ)) =
        fun n : ℕ => -thetaKernel a (↑n + 1 : ℤ) := by
      funext n
      simpa using thetaKernel_neg a (↑n + 1 : ℤ)
    rw [h]
    exact hs.neg
  exact Summable.of_nat_of_neg_add_one hpos hneg

/-- **T34:** the norm of the theta kernel is summable over `ℤ`. -/
lemma exp_jac_plus (a : ℝ) (n : ℤ) :
    Complex.exp (2 * Real.pi * Complex.I * n * (1/4) +
      Real.pi * Complex.I * n^2 * (Complex.I * (a:ℂ)))
      = ((Real.cos (Real.pi * n / 2) + Real.sin (Real.pi * n / 2) * Complex.I : ℂ) *
          (Real.exp (-Real.pi * a * n^2) : ℂ)) := by
  rw [show 2 * Real.pi * Complex.I * (n:ℂ) * (1/4) +
      Real.pi * Complex.I * (n:ℂ)^2 * (Complex.I * (a:ℂ))
      = ((Real.pi * n / 2 : ℝ) : ℂ) * Complex.I +
        ((-(Real.pi * a * n^2) : ℝ) : ℂ) by
    push_cast
    ring_nf
    rw [pow_two, Complex.I_mul_I]
    ring]
  rw [Complex.exp_add, Complex.exp_ofReal_mul_I, ← Complex.ofReal_exp]
  push_cast
  ring

lemma exp_jac_minus (a : ℝ) (n : ℤ) :
    Complex.exp (2 * Real.pi * Complex.I * n * (-1/4) +
      Real.pi * Complex.I * n^2 * (Complex.I * (a:ℂ)))
      = ((Real.cos (Real.pi * n / 2) - Real.sin (Real.pi * n / 2) * Complex.I : ℂ) *
          (Real.exp (-Real.pi * a * n^2) : ℂ)) := by
  rw [show 2 * Real.pi * Complex.I * (n:ℂ) * (-1/4) +
      Real.pi * Complex.I * (n:ℂ)^2 * (Complex.I * (a:ℂ))
      = ((-(Real.pi * n / 2) : ℝ) : ℂ) * Complex.I +
        ((-(Real.pi * a * n^2) : ℝ) : ℂ) by
    push_cast
    ring_nf
    rw [pow_two, Complex.I_mul_I]
    ring]
  rw [Complex.exp_add, Complex.exp_ofReal_mul_I, ← Complex.ofReal_exp]
  rw [Real.cos_neg, Real.sin_neg]
  push_cast
  ring

/-- **T46:** the pointwise Jacobi-term difference. -/
lemma jacobiTheta2'_term_diff (a : ℝ) (n : ℤ) :
    jacobiTheta₂'_term n (1/4) (Complex.I * a) -
      jacobiTheta₂'_term n (-1/4) (Complex.I * a)
      = -4 * Real.pi * (chi4Int n * thetaKernel (Real.pi * a) n) := by
  unfold jacobiTheta₂'_term jacobiTheta₂_term
  rw [exp_jac_plus, exp_jac_minus, chi4Int_eq_sin]
  unfold thetaKernel
  push_cast
  ring_nf
  rw [pow_two, Complex.I_mul_I]
  ring

lemma summable_norm_thetaKernel_int (a : ℝ) (ha : 0 < a) :
    Summable fun n : ℤ => ‖thetaKernel a n‖ := by
  have hpos : Summable fun n : ℕ => ‖thetaKernel a (n : ℤ)‖ := by
    refine (summable_nat_mul_exp_neg_sq a ha).congr (fun n => ?_)
    rw [norm_thetaKernel]
    norm_num
  have hneg : Summable fun n : ℕ => ‖thetaKernel a (-(n + 1 : ℕ) : ℤ)‖ := by
    have hs : Summable fun n : ℕ => ‖thetaKernel a ((n + 1 : ℕ) : ℤ)‖ :=
      hpos.comp_injective Nat.succ_injective
    have h : (fun n : ℕ => ‖thetaKernel a (-↑(n + 1) : ℤ)‖) =
        fun n : ℕ => ‖thetaKernel a (↑n + 1 : ℤ)‖ := by
      funext n
      rw [thetaKernel_neg, norm_neg]
      norm_num
    rw [h]
    exact hs
  exact Summable.of_nat_of_neg_add_one hpos hneg

/-- **T35:** the character-twisted theta is summable for `τ > 0`. -/
lemma summable_twistedTheta4 (τ : ℝ) (hτ : 0 < τ) :
    Summable fun n : ℤ => chi4Int n * thetaKernel (Real.pi * τ) n := by
  have hπτ : 0 < Real.pi * τ := mul_pos Real.pi_pos hτ
  refine Summable.of_norm_bounded
    (f := fun n : ℤ => chi4Int n * thetaKernel (Real.pi * τ) n)
    (summable_norm_thetaKernel_int _ hπτ) (fun n => ?_)
  rw [norm_mul]
  calc ‖chi4Int n‖ * ‖thetaKernel (Real.pi * τ) n‖
      ≤ 1 * ‖thetaKernel (Real.pi * τ) n‖ :=
        mul_le_mul_of_nonneg_right (norm_chi4Int_le_one n) (norm_nonneg _)
    _ = ‖thetaKernel (Real.pi * τ) n‖ := one_mul _

/-- The shifted characteristic theta kernel
`(n - b) e^(-a (n - b)²)`. -/
def charKernel (a b : ℝ) (n : ℤ) : ℂ :=
  (((n : ℝ) - b : ℂ)) * (Real.exp (-a * ((n : ℝ) - b) ^ 2) : ℂ)

/-- **T40:** the characteristic-kernel norm. -/
lemma norm_charKernel (a b : ℝ) (n : ℤ) :
    ‖charKernel a b n‖ = |(n : ℝ) - b| * Real.exp (-a * ((n : ℝ) - b) ^ 2) := by
  unfold charKernel
  have hcast : ((n : ℝ) - b : ℂ) = ((((n : ℝ) - b : ℝ)) : ℂ) := by
    push_cast
    rfl
  rw [hcast]
  rw [norm_mul]
  have hn : ‖(((n : ℝ) - b : ℝ) : ℂ)‖ = |(n : ℝ) - b| := by
    rw [Complex.norm_real, Real.norm_eq_abs]
  rw [hn]
  have he : ‖((Real.exp (-a * ((n : ℝ) - b) ^ 2) : ℝ) : ℂ)‖ =
      Real.exp (-a * ((n : ℝ) - b) ^ 2) := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  rw [he]

lemma norm_charKernel_le (a b : ℝ) (ha : 0 < a) (n : ℤ) :
    ‖charKernel a b n‖ ≤ Real.exp (a * b ^ 2) * (1 + |b|) *
      (‖thetaKernel (a / 2) n‖ + Real.exp (-(a / 2) * (n : ℝ) ^ 2)) := by
  rw [norm_charKernel, norm_thetaKernel]
  have h1 : |(n : ℝ) - b| ≤ |(n : ℝ)| + |b| := by
    rw [abs_sub_le_iff]
    constructor <;> nlinarith [le_abs_self (n : ℝ), neg_abs_le (n : ℝ),
      le_abs_self b, neg_abs_le b]
  have h2 : (n : ℝ) ^ 2 / 2 - b ^ 2 ≤ ((n : ℝ) - b) ^ 2 := by
    nlinarith [sq_nonneg ((n : ℝ) - 2 * b)]
  have harg : -a * ((n : ℝ) - b) ^ 2 ≤ a * b ^ 2 + -(a / 2) * (n : ℝ) ^ 2 := by
    nlinarith
  have hexp : Real.exp (-a * ((n : ℝ) - b) ^ 2) ≤
      Real.exp (a * b ^ 2 + -(a / 2) * (n : ℝ) ^ 2) := Real.exp_le_exp.mpr harg
  rw [Real.exp_add] at hexp
  have hnonneg : 0 ≤ Real.exp (-a * ((n : ℝ) - b) ^ 2) := (Real.exp_pos _).le
  have hstep : |(n : ℝ) - b| * Real.exp (-a * ((n : ℝ) - b) ^ 2) ≤
      (|(n : ℝ)| + |b|) * (Real.exp (a * b ^ 2) * Real.exp (-(a / 2) * (n : ℝ) ^ 2)) := by
    calc |(n : ℝ) - b| * Real.exp (-a * ((n : ℝ) - b) ^ 2)
        ≤ (|(n : ℝ)| + |b|) * Real.exp (-a * ((n : ℝ) - b) ^ 2) :=
          mul_le_mul_of_nonneg_right h1 hnonneg
      _ ≤ (|(n : ℝ)| + |b|) *
          (Real.exp (a * b ^ 2) * Real.exp (-(a / 2) * (n : ℝ) ^ 2)) :=
          mul_le_mul_of_nonneg_left hexp (by positivity)
  have hfac : |(n : ℝ)| + |b| ≤ (1 + |b|) * (|(n : ℝ)| + 1) := by
    nlinarith [abs_nonneg (n : ℝ), abs_nonneg b]
  calc |(n : ℝ) - b| * Real.exp (-a * ((n : ℝ) - b) ^ 2)
      ≤ (|(n : ℝ)| + |b|) * (Real.exp (a * b ^ 2) * Real.exp (-(a / 2) * (n : ℝ) ^ 2)) := hstep
    _ ≤ (Real.exp (a * b ^ 2) * (1 + |b|)) *
        ((|(n : ℝ)| + 1) * Real.exp (-(a / 2) * (n : ℝ) ^ 2)) := by
        have hx : 0 ≤ Real.exp (a * b ^ 2) * Real.exp (-(a / 2) * (n : ℝ) ^ 2) := by positivity
        nlinarith [mul_le_mul_of_nonneg_right hfac hx]
    _ = Real.exp (a * b ^ 2) * (1 + |b|) *
        (|(n : ℝ)| * Real.exp (-(a / 2) * (n : ℝ) ^ 2) +
          Real.exp (-(a / 2) * (n : ℝ) ^ 2)) := by ring

/-- **T42:** the characteristic theta kernel is summable over `ℤ`,
for every shift `b` and every `a > 0`. -/
lemma summable_charKernel (a b : ℝ) (ha : 0 < a) :
    Summable fun n : ℤ => charKernel a b n := by
  have hsum : Summable fun n : ℤ => Real.exp (a * b ^ 2) * (1 + |b|) *
      (‖thetaKernel (a / 2) n‖ + Real.exp (-(a / 2) * (n : ℝ) ^ 2)) := by
    have h1 := summable_norm_thetaKernel_int (a / 2) (half_pos ha)
    have h2 := summable_gaussian_int (a / 2) (half_pos ha)
    exact Summable.mul_left (Real.exp (a * b ^ 2) * (1 + |b|)) (h1.add h2)
  refine Summable.of_norm_bounded hsum (fun n => ?_)
  exact norm_charKernel_le a b ha n

/-- The `+` characteristic theta `Σ (n - 1/4)e^(-π(n - 1/4)²τ)`. -/
def thetaPlus (τ : ℝ) : ℂ :=
  ∑' n : ℤ, charKernel (Real.pi * τ) (1 / 4) n

/-- The `-` characteristic theta `Σ (n + 1/4)e^(-π(n + 1/4)²τ)`. -/
def thetaMinus (τ : ℝ) : ℂ :=
  ∑' n : ℤ, charKernel (Real.pi * τ) (-1 / 4) n

/-- **T43:** `thetaPlus` is summable for `τ > 0`. -/
lemma summable_thetaPlus (τ : ℝ) (hτ : 0 < τ) :
    Summable fun n : ℤ => charKernel (Real.pi * τ) (1 / 4) n :=
  summable_charKernel _ _ (mul_pos Real.pi_pos hτ)

/-- **T44:** `thetaMinus` is summable for `τ > 0`. -/
lemma summable_thetaMinus (τ : ℝ) (hτ : 0 < τ) :
    Summable fun n : ℤ => charKernel (Real.pi * τ) (-1 / 4) n :=
  summable_charKernel _ _ (mul_pos Real.pi_pos hτ)


/-- Named input: the `thetaPlus` Jacobi prefactor identity. -/
def ThetaPlusJacobiStatement : Prop :=
  ∀ c : ℝ, 0 < c →
    thetaPlus c = (Real.exp (-Real.pi * c / 16) : ℂ) *
      ((1 / (2 * Real.pi * Complex.I)) *
          jacobiTheta₂' (-Complex.I * c / 4) (Complex.I * c) -
        (1 / 4) * jacobiTheta₂ (-Complex.I * c / 4) (Complex.I * c))

/-- Named input: the `thetaMinus` Jacobi prefactor identity. -/
def ThetaMinusJacobiStatement : Prop :=
  ∀ c : ℝ, 0 < c →
    thetaMinus c = (Real.exp (-Real.pi * c / 16) : ℂ) *
      ((1 / (2 * Real.pi * Complex.I)) *
          jacobiTheta₂' (Complex.I * c / 4) (Complex.I * c) +
        (1 / 4) * jacobiTheta₂ (Complex.I * c / 4) (Complex.I * c))


/-- The Mellin transform of `thetaPlus`. -/
def mellinThetaPlus (s : ℂ) : ℂ := mellin thetaPlus s

/-- The Mellin transform of `thetaMinus`. -/
def mellinThetaMinus (s : ℂ) : ℂ := mellin thetaMinus s



/-- **T48:** the `thetaPlus` pointwise Jacobi combination. -/
lemma jacobiTheta2'_term_thetaPlus (c : ℝ) (n : ℤ) :
    (1/(2*Real.pi*Complex.I)) * jacobiTheta₂'_term n (-Complex.I*c/4) (Complex.I*c) -
      (1/4) * jacobiTheta₂_term n (-Complex.I*c/4) (Complex.I*c)
      = ((n:ℂ) - 1/4) * Complex.exp (-Real.pi*c*(n:ℝ)^2 + Real.pi*c*(n:ℝ)/2) := by
  unfold jacobiTheta₂'_term jacobiTheta₂_term
  have hE : Complex.exp (2 * Real.pi * Complex.I * (n:ℂ) * (-Complex.I * (c:ℂ) / 4) +
      Real.pi * Complex.I * (n:ℂ)^2 * (Complex.I * (c:ℂ)))
      = Complex.exp (-Real.pi*c*(n:ℝ)^2 + Real.pi*c*(n:ℝ)/2) := by
    congr 1
    push_cast
    ring_nf
    rw [pow_two, Complex.I_mul_I]
    ring
  rw [hE]
  norm_num
  field_simp
  norm_num


/-- **T49:** the characteristic kernel factors through the plain exponential. -/
lemma charKernel_eq_exp (c : ℝ) (n : ℤ) :
    charKernel (Real.pi*c) (1/4) n
      = (Real.exp (-Real.pi*c/16) : ℂ) *
        (((n:ℂ) - 1/4) * Complex.exp (-Real.pi*c*(n:ℝ)^2 + Real.pi*c*(n:ℝ)/2)) := by
  unfold charKernel
  ring_nf
  have hR : (↑(Real.exp (Real.pi * c * (-1 / 16))) : ℂ) =
      Complex.exp ((Real.pi * c * (-1 / 16) : ℝ) : ℂ) := by
    rw [Complex.ofReal_exp]
  rw [hR]
  norm_num
  rw [show (-(↑Real.pi * ↑c * (1 / 16)) + ↑Real.pi * ↑c * ↑n * (1 / 2) - ↑Real.pi * ↑c * ↑n ^ 2 : ℂ)
      = (-(↑Real.pi * ↑c * (1 / 16))) +
        (↑Real.pi * ↑c * ↑n * (1 / 2) - ↑Real.pi * ↑c * ↑n ^ 2) by ring]
  rw [Complex.exp_add]
  ring


/-- **T50:** the `thetaPlus` Jacobi assembly. -/
lemma thetaPlus_eq_jacobi (c : ℝ) (hc : 0 < c) :
    thetaPlus c = (Real.exp (-Real.pi*c/16) : ℂ) *
      ((1/(2*Real.pi*Complex.I)) * jacobiTheta₂' (-Complex.I*c/4) (Complex.I*c) -
        (1/4) * jacobiTheta₂ (-Complex.I*c/4) (Complex.I*c)) := by
  rw [thetaPlus]
  rw [show (∑' n : ℤ, charKernel (Real.pi*c) (1/4) n)
      = ∑' n : ℤ, (Real.exp (-Real.pi*c/16) : ℂ) *
          (((n:ℂ) - 1/4) * Complex.exp (-Real.pi*c*(n:ℝ)^2 + Real.pi*c*(n:ℝ)/2)) by
    apply tsum_congr
    intro n
    exact charKernel_eq_exp c n]
  rw [tsum_mul_left]
  congr 1
  have h1 : Summable fun n : ℤ => jacobiTheta₂'_term n (-Complex.I*c/4) (Complex.I*c) :=
    (summable_jacobiTheta₂'_term_iff _ _).mpr (by simpa using hc)
  have h2 : Summable fun n : ℤ => jacobiTheta₂_term n (-Complex.I*c/4) (Complex.I*c) :=
    (summable_jacobiTheta₂_term_iff _ _).mpr (by simpa using hc)
  rw [jacobiTheta₂', jacobiTheta₂]
  rw [← (h1.hasSum.mul_left (1/(2*Real.pi*Complex.I))).sub
    (h2.hasSum.mul_left (1/4)) |>.tsum_eq]
  apply tsum_congr
  intro n
  exact (jacobiTheta2'_term_thetaPlus c n).symm


/-- **T51:** the `thetaMinus` pointwise Jacobi combination. -/
lemma jacobiTheta2'_term_thetaMinus (c : ℝ) (n : ℤ) :
    (1/(2*Real.pi*Complex.I)) * jacobiTheta₂'_term n (Complex.I*c/4) (Complex.I*c) +
      (1/4) * jacobiTheta₂_term n (Complex.I*c/4) (Complex.I*c)
      = ((n:ℂ) + 1/4) * Complex.exp (-Real.pi*c*(n:ℝ)^2 - Real.pi*c*(n:ℝ)/2) := by
  unfold jacobiTheta₂'_term jacobiTheta₂_term
  have hE : Complex.exp (2 * Real.pi * Complex.I * (n:ℂ) * (Complex.I * (c:ℂ) / 4) +
      Real.pi * Complex.I * (n:ℂ)^2 * (Complex.I * (c:ℂ)))
      = Complex.exp (-Real.pi*c*(n:ℝ)^2 - Real.pi*c*(n:ℝ)/2) := by
    congr 1
    push_cast
    ring_nf
    rw [pow_two, Complex.I_mul_I]
    ring
  rw [hE]
  norm_num
  field_simp
  norm_num


/-- **T52:** the `thetaMinus` characteristic-kernel factorization. -/
lemma charKernel_minus_eq_exp (c : ℝ) (n : ℤ) :
    charKernel (Real.pi*c) (-1/4) n
      = (Real.exp (-Real.pi*c/16) : ℂ) *
        (((n:ℂ) + 1/4) * Complex.exp (-Real.pi*c*(n:ℝ)^2 - Real.pi*c*(n:ℝ)/2)) := by
  unfold charKernel
  ring_nf
  have hR : (↑(Real.exp (Real.pi * c * (-1 / 16))) : ℂ) =
      Complex.exp ((Real.pi * c * (-1 / 16) : ℝ) : ℂ) := by
    rw [Complex.ofReal_exp]
  rw [hR]
  norm_num
  rw [show (-(↑Real.pi * ↑c * (1 / 16)) + -(↑Real.pi * ↑c * ↑n * (1 / 2)) - ↑Real.pi * ↑c * ↑n ^ 2 : ℂ)
      = (-(↑Real.pi * ↑c * (1 / 16))) +
        (-(↑Real.pi * ↑c * ↑n * (1 / 2)) - ↑Real.pi * ↑c * ↑n ^ 2) by ring]
  rw [Complex.exp_add]
  ring

/-- **T53:** the `thetaMinus` Jacobi assembly. -/
lemma thetaMinus_eq_jacobi (c : ℝ) (hc : 0 < c) :
    thetaMinus c = (Real.exp (-Real.pi*c/16) : ℂ) *
      ((1/(2*Real.pi*Complex.I)) * jacobiTheta₂' (Complex.I*c/4) (Complex.I*c) +
        (1/4) * jacobiTheta₂ (Complex.I*c/4) (Complex.I*c)) := by
  rw [thetaMinus]
  rw [show (∑' n : ℤ, charKernel (Real.pi*c) (-1/4) n)
      = ∑' n : ℤ, (Real.exp (-Real.pi*c/16) : ℂ) *
          (((n:ℂ) + 1/4) * Complex.exp (-Real.pi*c*(n:ℝ)^2 - Real.pi*c*(n:ℝ)/2)) by
    apply tsum_congr
    intro n
    exact charKernel_minus_eq_exp c n]
  rw [tsum_mul_left]
  congr 1
  have h1 : Summable fun n : ℤ => jacobiTheta₂'_term n (Complex.I*c/4) (Complex.I*c) :=
    (summable_jacobiTheta₂'_term_iff _ _).mpr (by simpa using hc)
  have h2 : Summable fun n : ℤ => jacobiTheta₂_term n (Complex.I*c/4) (Complex.I*c) :=
    (summable_jacobiTheta₂_term_iff _ _).mpr (by simpa using hc)
  rw [jacobiTheta₂', jacobiTheta₂]
  rw [← (h1.hasSum.mul_left (1/(2*Real.pi*Complex.I))).add
    (h2.hasSum.mul_left (1/4)) |>.tsum_eq]
  apply tsum_congr
  intro n
  exact (jacobiTheta2'_term_thetaMinus c n).symm


/-- **T54:** the `jacobiTheta₂` quarter-point argument normalisation. -/
lemma jacobiTheta₂_arg_quarter (a : ℝ) (ha : a ≠ 0) :
    jacobiTheta₂ (1/4 * (Complex.I / (a:ℂ))) (Complex.I / (a:ℂ)) =
      jacobiTheta₂ (Complex.I * (↑(1/a):ℂ) / 4) (Complex.I * (↑(1/a):ℂ)) := by
  congr 1
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp

/-- **T55:** the `jacobiTheta₂'` quarter-point argument normalisation. -/
lemma jacobiTheta₂'_arg_quarter (a : ℝ) (ha : a ≠ 0) :
    jacobiTheta₂' (1/4 * (Complex.I / (a:ℂ))) (Complex.I / (a:ℂ)) =
      jacobiTheta₂' (Complex.I * (↑(1/a):ℂ) / 4) (Complex.I * (↑(1/a):ℂ)) := by
  congr 1
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp


/-- **T56:** `jacobiTheta₂''` at `z=1/4`, `τ=i/a` equals `thetaMinus(1/a)`. -/
lemma jacobiTheta2''_quarter_minus (a : ℝ) (ha : 0 < a) :
    HurwitzZeta.jacobiTheta₂'' (1/4) (Complex.I/a) = thetaMinus (1/a) := by
  rw [HurwitzZeta.jacobiTheta₂'', thetaMinus_eq_jacobi (1/a) (by positivity)]
  congr 2
  · rw [show (Real.pi * Complex.I * (1/4 : ℂ)^2 * (Complex.I / (a:ℂ)) : ℂ)
        = ((-Real.pi * (1/a) / 16 : ℝ) : ℂ) by
      push_cast
      ring_nf
      rw [pow_two, Complex.I_mul_I]
      ring]
    rw [← Complex.ofReal_exp]
  · rw [jacobiTheta₂'_arg_quarter a (by positivity)]
    field_simp
  · rw [jacobiTheta₂_arg_quarter a (by positivity)]


/-- **T57:** negative `jacobiTheta₂` quarter-point argument normalisation. -/
lemma jacobiTheta₂_arg_quarter_neg (a : ℝ) (ha : a ≠ 0) :
    jacobiTheta₂ (-1/4 * (Complex.I / (a:ℂ))) (Complex.I / (a:ℂ)) =
      jacobiTheta₂ (-Complex.I * (↑(1/a):ℂ) / 4) (Complex.I * (↑(1/a):ℂ)) := by
  congr 1
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp

/-- **T58:** negative `jacobiTheta₂'` quarter-point argument normalisation. -/
lemma jacobiTheta₂'_arg_quarter_neg (a : ℝ) (ha : a ≠ 0) :
    jacobiTheta₂' (-1/4 * (Complex.I / (a:ℂ))) (Complex.I / (a:ℂ)) =
      jacobiTheta₂' (-Complex.I * (↑(1/a):ℂ) / 4) (Complex.I * (↑(1/a):ℂ)) := by
  congr 1
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp
  · have hinv : (↑(1/a):ℂ) = (↑a)⁻¹ := by
      rw [one_div, Complex.ofReal_inv]
    rw [hinv]
    field_simp



/-- **T59:** `jacobiTheta₂''` at `z=-1/4`, `τ=i/a` equals `thetaPlus(1/a)`. -/
lemma jacobiTheta2''_quarter_plus (a : ℝ) (ha : 0 < a) :
    HurwitzZeta.jacobiTheta₂'' (-1/4) (Complex.I/a) = thetaPlus (1/a) := by
  rw [HurwitzZeta.jacobiTheta₂'', thetaPlus_eq_jacobi (1/a) (by positivity)]
  congr 2
  · rw [show (Real.pi * Complex.I * (-1/4 : ℂ)^2 * (Complex.I / (a:ℂ)) : ℂ)
        = ((-Real.pi * (1/a) / 16 : ℝ) : ℂ) by
      push_cast
      ring_nf
      rw [pow_two, Complex.I_mul_I]
      ring]
    rw [← Complex.ofReal_exp]
  · rw [jacobiTheta₂'_arg_quarter_neg a (by positivity),
      jacobiTheta₂_arg_quarter_neg a (by positivity)]
    field_simp
    ring





/-- Named input: the `thetaPlus` Mellin HasSum identity. -/
def ThetaPlusMellinStatement : Prop :=
  ∀ s : ℂ, 0 < s.re →
    (Summable fun i : ℤ => (1:ℝ) / |(i:ℝ) - 1/4| ^ s.re) →
    HasSum (fun i : ℤ => Complex.Gammaℝ (s + 1) *
      SignType.sign ((i:ℝ) - 1/4) / |(i:ℝ) - 1/4| ^ s)
      (mellinThetaPlus ((s + 1) / 2))

/-- Named input: the `thetaMinus` Mellin HasSum identity. -/
def ThetaMinusMellinStatement : Prop :=
  ∀ s : ℂ, 0 < s.re →
    (Summable fun i : ℤ => (1:ℝ) / |(i:ℝ) + 1/4| ^ s.re) →
    HasSum (fun i : ℤ => Complex.Gammaℝ (s + 1) *
      SignType.sign ((i:ℝ) + 1/4) / |(i:ℝ) + 1/4| ^ s)
      (mellinThetaMinus ((s + 1) / 2))


/-- **T61:** the `thetaPlus` Mellin HasSum identity for `Re s > 1`. -/
lemma hasSum_mellin_thetaPlus (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun i : ℤ => Complex.Gammaℝ (s + 1) *
      SignType.sign ((i:ℝ) - 1/4) / |(i:ℝ) - 1/4| ^ s)
      (mellinThetaPlus ((s + 1) / 2)) := by
  have hs0 : 0 < s.re := lt_trans zero_lt_one hs
  have hsum : Summable fun i : ℤ => (1:ℝ) / |(i:ℝ) - 1/4| ^ s.re := by
    convert (Real.summable_one_div_int_add_rpow (-1/4) s.re).mpr hs using 2 with i
    ring_nf
  have h := hasSum_mellin_pi_mul_sq' (a := fun _ : ℤ => (1:ℂ))
    (r := fun i : ℤ => (i:ℝ) - 1/4) (F := thetaPlus) (s := s) hs0 ?_
    (by simpa using hsum)
  · simpa [mellinThetaPlus] using h
  · intro t ht
    have hsum_t : Summable fun i : ℤ => charKernel (Real.pi * t) (1/4) i :=
      summable_thetaPlus t ht
    simpa [thetaPlus, charKernel, mul_assoc, mul_comm, mul_left_comm] using hsum_t.hasSum


/-- **T62:** the `thetaMinus` summand rewritten with `n+1/4`. -/
lemma thetaMinus_eq_tsum_plus (t : ℝ) :
    thetaMinus t = ∑' n : ℤ, (((n:ℝ) + 1/4 : ℂ) *
      (Real.exp (-Real.pi * ((n:ℝ) + 1/4)^2 * t) : ℂ)) := by
  rw [thetaMinus]
  apply tsum_congr
  intro n
  unfold charKernel
  norm_num
  left
  congr 1
  ring




/-- **T63:** the `thetaMinus` Mellin HasSum identity for `Re s > 1`. -/
lemma hasSum_mellin_thetaMinus (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun i : ℤ => Complex.Gammaℝ (s + 1) *
      SignType.sign ((i:ℝ) + 1/4) / |(i:ℝ) + 1/4| ^ s)
      (mellinThetaMinus ((s + 1) / 2)) := by
  have hs0 : 0 < s.re := lt_trans zero_lt_one hs
  have hsum : Summable fun i : ℤ => (1:ℝ) / |(i:ℝ) + 1/4| ^ s.re := by
    convert (Real.summable_one_div_int_add_rpow (1/4) s.re).mpr hs using 2 with i
  have hfun : (fun t : ℝ => ∑' n : ℤ, (((n:ℝ) + 1/4 : ℂ) *
      (Real.exp (-Real.pi * ((n:ℝ) + 1/4)^2 * t) : ℂ))) = thetaMinus := by
    funext t
    rw [thetaMinus_eq_tsum_plus]
  have h := hasSum_mellin_pi_mul_sq' (a := fun _ : ℤ => (1:ℂ))
    (r := fun i : ℤ => (i:ℝ) + 1/4)
    (F := fun t : ℝ => ∑' n : ℤ, (((n:ℝ) + 1/4 : ℂ) *
      (Real.exp (-Real.pi * ((n:ℝ) + 1/4)^2 * t) : ℂ)))
    (s := s) hs0 ?_ (by simpa using hsum)
  · rw [show mellinThetaMinus ((s + 1) / 2) =
        mellin (fun t : ℝ => ∑' n : ℤ, (((n:ℝ) + 1/4 : ℂ) *
          (Real.exp (-Real.pi * ((n:ℝ) + 1/4)^2 * t) : ℂ))) ((s + 1) / 2) by
      rw [mellinThetaMinus, ← hfun]]
    simpa using h
  · intro t ht
    have hs_t : Summable fun i : ℤ => charKernel (Real.pi * t) (-1/4) i :=
      summable_thetaMinus t ht
    rw [← thetaMinus_eq_tsum_plus t]
    refine HasSum.congr_fun hs_t.hasSum ?_
    intro i
    simp [charKernel]
    norm_num
    left
    congr 1
    ring


/-- The Dirichlet beta series. -/
noncomputable def betaSeries (s : ℂ) : ℂ :=
  ∑' k : ℕ, (-1:ℂ) ^ k * ((2 * (k:ℂ) + 1) ^ (-s))

/-- Named input: the signed odd series equals `-4^s` times the beta series. -/
def BetaSeriesStatement : Prop :=
  ∀ s : ℂ, 1 < s.re →
    (∑' i : ℤ, (SignType.sign ((i:ℝ) - 1/4) : ℂ) /
        ((|(i:ℝ) - 1/4| : ℝ) : ℂ) ^ s) =
      -((4:ℂ) ^ s) * betaSeries s


/-- The parity reindexing of odd denominators. -/
def oddIndex (k : ℕ) : ℤ :=
  if k % 2 = 0 then -(k / 2 : ℤ) else (k / 2 : ℤ) + 1

lemma oddIndex_even (m : ℕ) : oddIndex (2*m) = -(m:ℤ) := by
  unfold oddIndex
  have h : (2*m) % 2 = 0 := by omega
  simp [h]

lemma oddIndex_odd (m : ℕ) : oddIndex (2*m+1) = (m:ℤ) + 1 := by
  unfold oddIndex
  have h : (2*m+1) % 2 ≠ 0 := by omega
  simp [h]
  omega

/-- **T64:** the absolute value of the odd-index shift. -/
lemma abs_oddIndex_sub_quarter (k : ℕ) :
    |(oddIndex k : ℝ) - 1/4| = (2 * (k:ℝ) + 1) / 4 := by
  rcases Nat.even_or_odd k with ⟨m, rfl⟩ | ⟨m, rfl⟩
  · rw [show m + m = 2*m by ring, oddIndex_even]
    push_cast
    rw [show (-(m:ℝ) - 1/4) = -(m + 1/4) by ring, abs_neg,
      abs_of_nonneg (by positivity)]
    ring
  · rw [oddIndex_odd]
    push_cast
    rw [show ((m:ℝ) + 1 - 1/4) = m + 3/4 by ring,
      abs_of_nonneg (by positivity)]
    ring


/-- **T65:** the sign of the odd-index shift. -/
lemma sign_oddIndex_sub_quarter (k : ℕ) :
    SignType.sign ((oddIndex k : ℝ) - 1/4) = ((-1:ℝ) ^ (k+1)) := by
  rcases Nat.even_or_odd k with ⟨m, rfl⟩ | ⟨m, rfl⟩
  · rw [show m + m = 2*m by ring, oddIndex_even]
    push_cast
    have hneg : (-(m:ℝ) - 1/4) < 0 := by
      nlinarith [(Nat.cast_nonneg m : (0:ℝ) ≤ (m:ℝ))]
    rw [sign_neg hneg]
    rw [show 2*m + 1 = 2*m+1 by ring, pow_succ, pow_mul, neg_one_sq, one_pow]
    norm_num
  · rw [oddIndex_odd]
    push_cast
    have hpos : (0:ℝ) < (m:ℝ) + 1 - 1/4 := by
      nlinarith [(Nat.cast_nonneg m : (0:ℝ) ≤ (m:ℝ))]
    rw [sign_pos hpos]
    rw [show 2*m + 1 + 1 = 2*(m+1) by ring, pow_mul, neg_one_sq, one_pow]
    norm_num


/-- **T66:** `oddIndex` is injective. -/
lemma oddIndex_injective : Function.Injective oddIndex := by
  intro a b h
  rcases Nat.even_or_odd a with ⟨m, rfl⟩ | ⟨m, rfl⟩ <;>
    rcases Nat.even_or_odd b with ⟨n, rfl⟩ | ⟨n, rfl⟩
  · rw [show m + m = 2*m by ring, show n + n = 2*n by ring,
      oddIndex_even, oddIndex_even] at h
    omega
  · rw [show m + m = 2*m by ring, oddIndex_even, oddIndex_odd] at h
    omega
  · rw [oddIndex_odd, show n + n = 2*n by ring, oddIndex_even] at h
    omega
  · rw [oddIndex_odd, oddIndex_odd] at h
    omega

/-- **T67:** `oddIndex` is surjective, hence a bijection `ℕ ≃ ℤ`. -/
lemma oddIndex_surjective : Function.Surjective oddIndex := by
  intro z
  rcases lt_trichotomy z 0 with hneg | hzero | hpos
  · use (-2*z).toNat
    rw [show (-2*z).toNat = 2*((-2*z).toNat/2) by omega]
    rw [oddIndex_even]
    omega
  · subst hzero
    use 0
    rw [show 0 = 2*0 by ring, oddIndex_even]
    norm_num
  · use (2*z-1).toNat
    rw [show (2*z-1).toNat = 2*((2*z-1).toNat/2)+1 by omega]
    rw [oddIndex_odd]
    omega

/-- The bijection `ℕ ≃ ℤ` enumerating the odd-quarter integers. -/
def oddIndexEquiv : ℕ ≃ ℤ :=
  Equiv.ofBijective oddIndex ⟨oddIndex_injective, oddIndex_surjective⟩


/-- **T68:** the cast sign formula. -/
lemma sign_oddIndex_cast (k : ℕ) :
    (SignType.sign ((oddIndex k : ℝ) - 1/4) : ℂ) = ((-1:ℂ) ^ (k+1)) := by
  exact_mod_cast sign_oddIndex_sub_quarter k

/-- **T69:** reindex the signed odd series along `oddIndex`. -/
lemma betaSeries_reindex (s : ℂ) :
    (∑' i : ℤ, (SignType.sign ((i:ℝ) - 1/4) : ℂ) /
      ((|(i:ℝ) - 1/4| : ℝ) : ℂ) ^ s)
    = ∑' k : ℕ, ((-1:ℂ) ^ (k+1)) *
      ((((2*(k:ℝ)+1)/4 : ℝ) : ℂ) ^ (-s)) := by
  rw [← oddIndexEquiv.tsum_eq]
  apply tsum_congr
  intro k
  change (SignType.sign ((oddIndex k : ℝ) - 1/4) : ℂ) /
      ((|(oddIndex k : ℝ) - 1/4| : ℝ) : ℂ) ^ s
      = ((-1:ℂ) ^ (k+1)) * ((((2*(k:ℝ)+1)/4 : ℝ) : ℂ) ^ (-s))
  rw [abs_oddIndex_sub_quarter, sign_oddIndex_cast]
  rw [Complex.cpow_neg]
  ring


/-- The character-twisted theta for `χ₄`:
`θ_χ(τ) = Σ_{n∈Z} χ₄(n) n e^(-π n² τ)`.  Convergence and its weight-`3/2`
modular transformation are the named input `LatticeThetaMellinChi4`. -/
def twistedTheta4 (τ : ℝ) : ℂ :=
  ∑' n : ℤ, chi4Int n * thetaKernel (Real.pi * τ) n

def VectorModularStatement : Prop :=
  ∀ a : ℝ, 0 < a →
    twistedTheta4 a = (((1 / (2 * a ^ (3 / 2 : ℝ))) : ℝ) : ℂ) *
      (thetaMinus (1 / a) - thetaPlus (1 / a))



/-- **T47:** the Jacobi-theta identification of the scalar twisted theta. -/
lemma twistedTheta4_eq_jacobi (a : ℝ) (ha : 0 < a) :
    twistedTheta4 a =
      -(1 / (4 * Real.pi)) *
        (jacobiTheta₂' (1/4) (Complex.I * a) -
          jacobiTheta₂' (-1/4) (Complex.I * a)) := by
  have h1 : Summable fun n : ℤ => jacobiTheta₂'_term n (1/4) (Complex.I * a) :=
    (summable_jacobiTheta₂'_term_iff _ _).mpr (by simpa using ha)
  have h2 : Summable fun n : ℤ => jacobiTheta₂'_term n (-1/4) (Complex.I * a) :=
    (summable_jacobiTheta₂'_term_iff _ _).mpr (by simpa using ha)
  rw [jacobiTheta₂', jacobiTheta₂']
  rw [← (h1.hasSum.sub h2.hasSum).tsum_eq]
  rw [tsum_congr (fun n => jacobiTheta2'_term_diff a n)]
  rw [tsum_mul_left]
  unfold twistedTheta4
  field_simp



/-- The real finite categorical series `Σ_i χ_i m_i^(-σ)`. -/
def psiR (n : ℕ) (chi m : Fin n → ℝ) (σ : ℝ) : ℝ :=
  ∑ i, chi i * (m i) ^ (-σ)

/-- The `SU(2)₄` Galois signs. -/
def su2Chi : Fin 5 → ℝ := ![1, -1, 1, -1, 1]

/-- **T27:** the exact `SU(2)₄` value at `σ = 1/2`:
`Ψ(1/2) = 2/√3 - 1`. -/
theorem su2_psiR_half :
    psiR 5 su2Chi (fun i => (12 : ℝ) / su2Dsq i) (1 / 2)
      = 2 / Real.sqrt 3 - 1 := by
  unfold psiR
  simp [su2Chi, su2Dsq, Fin.sum_univ_five]
  have h12 : (12 : ℝ) ^ (1 / 2 : ℝ) = 2 * Real.sqrt 3 := by
    rw [← Real.sqrt_eq_rpow, show (12 : ℝ) = 4 * 3 by norm_num,
      Real.sqrt_mul (by norm_num)]
    norm_num
  have h3 : (3 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 3 := by
    rw [← Real.sqrt_eq_rpow]
  norm_num [Real.rpow_neg, h12, h3]
  field_simp
  ring

lemma norm_exp_phase (t l : ℝ) :
    ‖Complex.exp (-(t : ℂ) * (l : ℂ) * Complex.I)‖ = 1 := by
  have h : (-(t : ℂ) * (l : ℂ) * Complex.I) = (-(t * l) : ℝ) * Complex.I := by
    push_cast
    ring
  rw [h, Complex.norm_exp_ofReal_mul_I]

lemma norm_exp_decay (σ l : ℝ) :
    ‖Complex.exp (-(σ : ℂ) * (l : ℂ))‖ = Real.exp (-(σ * l)) := by
  have h : (-(σ : ℂ) * (l : ℂ)) = (-(σ * l) : ℝ) := by push_cast; ring
  rw [h, ← Complex.ofReal_exp, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (Real.exp_pos _)]

/-- **T26:** the phase-corrected series is bounded by its real decay envelope:
`‖Ψ(σ,t)‖ ≤ Σ_i |χ_i| exp(-σ log m_i)`. -/
theorem phasePsi_norm_le (n : ℕ) (chi m : Fin n → ℝ) (σ t : ℝ) :
    ‖phasePsi n chi m σ t‖
      ≤ ∑ i, |chi i| * Real.exp (-(σ * Real.log (m i))) := by
  unfold phasePsi
  calc ‖∑ i, (chi i : ℂ) * Complex.exp (-(σ : ℂ) * (Real.log (m i) : ℂ)) *
        Complex.exp (-(t : ℂ) * (Real.log (m i) : ℂ) * Complex.I)‖
      ≤ ∑ i, ‖(chi i : ℂ) * Complex.exp (-(σ : ℂ) * (Real.log (m i) : ℂ)) *
        Complex.exp (-(t : ℂ) * (Real.log (m i) : ℂ) * Complex.I)‖ := norm_sum_le _ _
    _ = ∑ i, |chi i| * Real.exp (-(σ * Real.log (m i))) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [norm_mul, norm_mul, norm_exp_decay, norm_exp_phase, mul_one]
      rw [Complex.norm_real, Real.norm_eq_abs]


/-- **T60:** the vector modular relation. -/
lemma twistedTheta4_vector_modular (a : ℝ) (ha : 0 < a) :
    twistedTheta4 a = (((1 / (2 * a ^ (3 / 2 : ℝ))) : ℝ) : ℂ) *
      (thetaMinus (1/a) - thetaPlus (1/a)) := by
  rw [twistedTheta4_eq_jacobi a ha]
  rw [HurwitzZeta.jacobiTheta₂'_functional_equation',
    HurwitzZeta.jacobiTheta₂'_functional_equation']
  rw [show -1 / (Complex.I * (a:ℂ)) = Complex.I / (a:ℂ) by
    field_simp
    rw [pow_two, Complex.I_mul_I]
    ring]
  rw [jacobiTheta2''_quarter_minus a ha, jacobiTheta2''_quarter_plus a ha]
  rw [show -Complex.I * (Complex.I * (a:ℂ)) = (a:ℂ) by
    ring_nf
    rw [pow_two, Complex.I_mul_I]
    ring]
  have hpow : ((a:ℂ) ^ (3/2 : ℂ)) = ((a ^ (3/2 : ℝ) : ℝ) : ℂ) := by
    rw [show (3/2 : ℂ) = ((3/2 : ℝ) : ℂ) by norm_num]
    rw [← Complex.ofReal_cpow ha.le (3/2 : ℝ)]
  rw [hpow]
  field_simp
  push_cast
  ring




/-- **T70:** quarter-denominator cpow factor. -/
lemma cpow_quarter (k : ℕ) (s : ℂ) :
    ((((2*(k:ℝ)+1)/4 : ℝ) : ℂ) ^ (-s)) =
      (4:ℂ)^s * (((2*(k:ℝ)+1 : ℝ) : ℂ) ^ (-s)) := by
  have hx : (0:ℝ) ≤ 2*(k:ℝ)+1 := by positivity
  have hbase : (((2*(k:ℝ)+1)/4 : ℝ) : ℂ) =
      (((2*(k:ℝ)+1 : ℝ) : ℂ) * ((1/4:ℝ):ℂ)) := by
    push_cast
    ring
  rw [hbase]
  rw [Complex.mul_cpow_ofReal_nonneg (a := 2*(k:ℝ)+1) (b := 1/4) hx (by norm_num)]
  have h4 : ((4:ℂ)⁻¹) ^ (-s) = (4:ℂ)^s := by
    rw [show (4:ℂ) = ((4:ℝ):ℂ) by norm_num]
    rw [Complex.inv_cpow_ofReal_nonneg (by norm_num : (0:ℝ) ≤ 4)]
    rw [Complex.cpow_neg]
    group
  rw [show ((1/4:ℝ):ℂ) = (4:ℂ)⁻¹ by norm_num, h4]
  ring


/-- **T71:** the signed odd series is `-4^s` times the beta series. -/
theorem betaSeriesStatement : BetaSeriesStatement := by
  intro s hs
  rw [betaSeries_reindex]
  rw [betaSeries]
  rw [show (∑' k : ℕ, ((-1:ℂ)^(k+1)) *
      ((((2*(k:ℝ)+1)/4 : ℝ):ℂ)^(-s)))
      = ∑' k : ℕ, (-(4:ℂ)^s) *
        (((-1:ℂ)^k) * (((2*(k:ℝ)+1:ℝ):ℂ)^(-s))) by
    apply tsum_congr
    intro k
    rw [cpow_quarter]
    rw [show (-1:ℂ)^(k+1) = -((-1:ℂ)^k) by
      rw [pow_succ]
      ring]
    ring]
  rw [tsum_mul_left]
  congr 1
  apply tsum_congr
  intro k
  norm_num


/-- **T72:** the `twistedTheta4` summand is even. -/
lemma twistedTheta4_summand_even (t : ℝ) :
    Function.Even (fun i : ℤ => chi4Int i * thetaKernel (Real.pi*t) i) := by
  intro i
  change chi4Int (-i) * thetaKernel (Real.pi*t) (-i)
      = chi4Int i * thetaKernel (Real.pi*t) i
  rw [chi4Int_neg, thetaKernel_neg]
  ring


/-- **T73:** the scalar Mellin HasSum for `twistedTheta4`. -/
lemma hasSum_mellin_twistedTheta4 (s : ℂ) (hs : 1 < s.re) :
    HasSum (fun i : ℤ => Complex.Gammaℝ (s+1) * chi4Int i *
      (SignType.sign (i:ℝ) : ℂ) / ((|(i:ℝ)| : ℝ) : ℂ) ^ s)
      (mellin twistedTheta4 ((s+1)/2)) := by
  have hs0 : 0 < s.re := lt_trans zero_lt_one hs
  have hbase : Summable fun i : ℤ => (1:ℝ) / |(i:ℝ)| ^ s.re := by
    simpa using (Real.summable_one_div_int_add_rpow 0 s.re).mpr hs
  have hsum : Summable fun i : ℤ => ‖chi4Int i‖ / |(i:ℝ)| ^ s.re := by
    refine hbase.of_nonneg_of_le (fun i => by positivity) (fun i => ?_)
    by_cases hi : i = 0
    · subst hi
      simp [Real.zero_rpow hs0.ne']
    · have hpos : 0 < |(i:ℝ)| ^ s.re :=
        Real.rpow_pos_of_pos (abs_pos.mpr (by exact_mod_cast hi)) _
      exact div_le_div_of_nonneg_right (norm_chi4Int_le_one i) hpos.le
  have h := hasSum_mellin_pi_mul_sq' (a := chi4Int) (r := fun i : ℤ => (i:ℝ))
    (F := twistedTheta4) (s := s) hs0 ?_ (by simpa using hsum)
  · simpa [mellin] using h
  · intro t ht
    have hs_t : Summable fun i : ℤ => chi4Int i * thetaKernel (Real.pi*t) i :=
      summable_twistedTheta4 t ht
    simpa [twistedTheta4, thetaKernel, mul_assoc, mul_comm, mul_left_comm] using hs_t.hasSum


/-- Named input: the scalar character series equals twice the beta series. -/
def ScalarBetaStatement : Prop :=
  ∀ s : ℂ, 1 < s.re →
    (∑' i : ℤ, (chi4Int i * (SignType.sign (i:ℝ) : ℂ)) /
      ((|(i:ℝ)| : ℝ) : ℂ) ^ s) = 2 * betaSeries s


/-- **T74:** the value of `χ₄` on positive odd integers. -/
lemma chi4Int_two_mul_add_one (k : ℕ) :
    chi4Int (2*k+1) = ((-1:ℝ)^k : ℂ) := by
  unfold chi4Int
  push_cast
  rw [show (2 * (k : ZMod 4) + 1) = ((2*k+1 : ℕ) : ZMod 4) by push_cast; ring]
  rw [ZMod.χ₄_eq_neg_one_pow (by omega : (2*k+1)%2 = 1)]
  norm_num
  congr 1
  rw [show (2*k+1)/2 = k by
    rw [show 2*k+1 = 1 + 2*k by ring]
    rw [Nat.add_mul_div_left 1 k (by norm_num)]
    norm_num]

/-- The scalar character summand. -/
def scalarTerm (s : ℂ) (i : ℤ) : ℂ :=
  (chi4Int i * (SignType.sign (i:ℝ) : ℂ)) / ((|(i:ℝ)| : ℝ) : ℂ) ^ s

/-- **T75:** the scalar character summand vanishes at `0`. -/
lemma scalarTerm_zero (s : ℂ) : scalarTerm s 0 = 0 := by
  unfold scalarTerm chi4Int
  norm_num

/-- **T76:** the scalar character summand is even. -/
lemma scalarTerm_neg (s : ℂ) (i : ℤ) : scalarTerm s (-i) = scalarTerm s i := by
  unfold scalarTerm
  have hcast : ((-i:ℤ):ℝ) = -((i:ℤ):ℝ) := by push_cast; ring
  rw [hcast, chi4Int_neg, abs_neg]
  have hsign : ((SignType.sign (-((i:ℤ):ℝ)) : ℂ)) = - ((SignType.sign ((i:ℤ):ℝ) : ℂ)) := by
    rw [Left.sign_neg]
    push_cast
    ring
  rw [hsign]
  ring

/-- **T77:** `χ₄` vanishes on even integers. -/
lemma chi4Int_even (k : ℕ) : chi4Int (2*(k:ℤ)) = 0 := by
  unfold chi4Int
  rw [ZMod.χ₄_int_eq_if_mod_four]
  have h : (2*(k:ℤ)) % 2 = 0 := by omega
  simp [h]

/-- **T78:** the scalar character summand vanishes at even integers. -/
lemma scalarTerm_two_mul (s : ℂ) (k : ℕ) : scalarTerm s (2*(k:ℤ)) = 0 := by
  unfold scalarTerm
  rw [chi4Int_even]
  norm_num

/-- **T79:** the scalar character summand is dominated by `1/|i|^(Re s)`. -/
lemma norm_scalarTerm_le (s : ℂ) (i : ℤ) (hi : i ≠ 0) :
    ‖scalarTerm s i‖ ≤ 1 / |(i:ℝ)| ^ s.re := by
  unfold scalarTerm
  rw [norm_div, norm_mul]
  have hpos : (0:ℝ) < |(i:ℝ)| := abs_pos.mpr (by exact_mod_cast hi)
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hpos]
  have hchi : ‖chi4Int i‖ ≤ 1 := norm_chi4Int_le_one i
  have hsign : ‖(SignType.sign (i:ℝ) : ℂ)‖ ≤ 1 := by
    cases h : SignType.sign (i:ℝ) <;> simp
  calc ‖chi4Int i‖ * ‖(SignType.sign (i:ℝ) : ℂ)‖ / |(i:ℝ)| ^ s.re
      ≤ 1 * 1 / |(i:ℝ)| ^ s.re := by gcongr
    _ = 1 / |(i:ℝ)| ^ s.re := by ring

/-- **T80:** the scalar character series is summable for `Re s > 1`. -/
lemma summable_scalarTerm (s : ℂ) (hs : 1 < s.re) : Summable (scalarTerm s) := by
  have hbase : Summable fun i : ℤ => (1:ℝ) / |(i:ℝ)| ^ s.re := by
    simpa using (Real.summable_one_div_int_add_rpow 0 s.re).mpr hs
  refine Summable.of_norm_bounded hbase (fun i => ?_)
  by_cases hi : i = 0
  · subst hi
    rw [scalarTerm_zero]
    simp [Real.zero_rpow (lt_trans zero_lt_one hs).ne']
  · exact norm_scalarTerm_le s i hi

/-- **T81:** the non-zero part of the scalar series on `ℕ` is supported on the odd integers. -/
lemma support_scalarTerm_nat (s : ℂ) :
    Function.support (fun n : ℕ => scalarTerm s (n:ℤ)) ⊆
      Set.range (fun k : ℕ => 2*k+1) := by
  intro n hn
  rcases Nat.even_or_odd n with ⟨m, rfl⟩ | ⟨m, rfl⟩
  · exfalso
    apply hn
    change scalarTerm s ((m + m : ℕ) : ℤ) = 0
    rw [show ((m + m : ℕ) : ℤ) = 2*(m:ℤ) by push_cast; ring, scalarTerm_two_mul]
  · exact ⟨m, by push_cast; ring⟩

/-- **T82:** the scalar character summand on positive odd integers is `(−1)^k/(2k+1)^s`. -/
lemma scalarTerm_odd (s : ℂ) (k : ℕ) :
    scalarTerm s ((2*k+1 : ℕ) : ℤ)
      = ((-1:ℂ)^k) / (((2*(k:ℝ)+1 : ℝ)) : ℂ)^s := by
  unfold scalarTerm
  have hcast : (((2*k+1 : ℕ)) : ℤ) = (2*(k:ℤ)+1) := by push_cast; ring
  rw [hcast]
  have hchi : chi4Int (2*(k:ℤ)+1) = ((-1:ℝ)^k : ℂ) := by
    simpa using chi4Int_two_mul_add_one k
  rw [hchi]
  have hpos : (0:ℝ) < 2*(k:ℝ)+1 := by positivity
  have hval : (((2*(k:ℤ)+1 : ℤ)) : ℝ) = 2*(k:ℝ)+1 := by push_cast; ring
  have hsign : SignType.sign (((2*(k:ℤ)+1 : ℤ)) : ℝ) = 1 := by
    rw [hval]; exact sign_pos hpos
  have habs : |(((2*(k:ℤ)+1 : ℤ)) : ℝ)| = 2*(k:ℝ)+1 := by
    rw [hval]; exact abs_of_pos hpos
  rw [hsign, habs]
  norm_num

/-- **T83:** the scalar series on `ℕ` reindexes onto `2k+1`. -/
lemma tsum_nat_odd (s : ℂ) :
    (∑' n : ℕ, scalarTerm s (n:ℤ))
      = ∑' k : ℕ, scalarTerm s ((2*k+1 : ℕ) : ℤ) := by
  have hinj : Function.Injective (fun k : ℕ => 2*k+1) := by
    intro a b h
    change 2*a+1 = 2*b+1 at h
    omega
  exact (hinj.tsum_eq (f := fun n : ℕ => scalarTerm s (n:ℤ)) (support_scalarTerm_nat s)).symm

/-- **T84:** `ScalarBetaStatement`: `Σ_i χ₄(i) sign(i)/|i|^s = 2β(s)`. -/
theorem scalarBetaStatement : ScalarBetaStatement := by
  intro s hs
  change (∑' i : ℤ, scalarTerm s i) = 2 * betaSeries s
  have hsum : Summable (scalarTerm s) := summable_scalarTerm s hs
  have h1 : Summable fun n : ℕ => scalarTerm s (n:ℤ) :=
    hsum.comp_injective (fun a b h => by exact_mod_cast h)
  have h2 : Summable fun n : ℕ => scalarTerm s (-(n:ℤ)) := by
    simpa [scalarTerm_neg] using h1
  have hint : (∑' i : ℤ, scalarTerm s i) = 2 * ∑' n : ℕ, scalarTerm s (n:ℤ) := by
    rw [Summable.tsum_of_nat_of_neg h1 h2]
    have hz : scalarTerm s 0 = 0 := scalarTerm_zero s
    rw [hz]
    have hsym : (∑' n : ℕ, scalarTerm s (-(n:ℤ))) = ∑' n : ℕ, scalarTerm s (n:ℤ) := by
      apply tsum_congr
      intro n
      exact scalarTerm_neg s (n:ℤ)
    rw [hsym]
    ring
  rw [hint, tsum_nat_odd s, betaSeries]
  congr 1
  apply tsum_congr
  intro k
  rw [scalarTerm_odd]
  rw [show (((2*(k:ℝ)+1 : ℝ)) : ℂ) = (2*(k:ℂ)+1) by push_cast; ring]
  rw [Complex.cpow_neg]
  ring

/-! ## Completed beta functional equation -/

/-! ## Completed beta functional equation -/

/-- The `thetaPlus` character summand. -/
def plusCharTerm (s : ℂ) (i : ℤ) : ℂ :=
  (SignType.sign ((i:ℝ) - 1/4) : ℂ) / ((|(i:ℝ) - 1/4| : ℝ) : ℂ) ^ s

/-- The `thetaMinus` character summand. -/
def minusCharTerm (s : ℂ) (i : ℤ) : ℂ :=
  (SignType.sign ((i:ℝ) + 1/4) : ℂ) / ((|(i:ℝ) + 1/4| : ℝ) : ℂ) ^ s

/-- **T85:** the `thetaPlus` summand at `−i` is minus the `thetaMinus` summand at `i`. -/
lemma plusCharTerm_neg (s : ℂ) (i : ℤ) :
    plusCharTerm s (-i) = - minusCharTerm s i := by
  unfold plusCharTerm minusCharTerm
  have hcast : ((-i:ℤ):ℝ) = -((i:ℤ):ℝ) := by push_cast; ring_nf
  rw [hcast]
  have hsign : SignType.sign (-((i:ℤ):ℝ) - 1/4) = - SignType.sign (((i:ℤ):ℝ) + 1/4) := by
    rw [show -((i:ℤ):ℝ) - 1/4 = -(((i:ℤ):ℝ) + 1/4) by ring, Left.sign_neg]
  have habs : |(-((i:ℤ):ℝ) - 1/4)| = |(((i:ℤ):ℝ) + 1/4)| := by
    rw [show -((i:ℤ):ℝ) - 1/4 = -(((i:ℤ):ℝ) + 1/4) by ring, abs_neg]
  rw [hsign, habs]
  push_cast
  ring_nf

/-- **T86:** the `thetaPlus` character series is minus the `thetaMinus` series. -/
lemma tsum_plus_eq_neg_tsum_minus (s : ℂ) :
    (∑' i : ℤ, plusCharTerm s i) = - (∑' i : ℤ, minusCharTerm s i) := by
  have h := (Equiv.neg ℤ).tsum_eq (plusCharTerm s)
  rw [← h]
  rw [show (∑' c : ℤ, plusCharTerm s ((Equiv.neg ℤ) c))
      = ∑' c : ℤ, - minusCharTerm s c by
    apply tsum_congr
    intro c
    change plusCharTerm s (-c) = - minusCharTerm s c
    exact plusCharTerm_neg s c]
  rw [tsum_neg]

/-- **T87:** the `thetaMinus` character series equals `4^s β(s)`. -/
lemma tsum_minusCharTerm (s : ℂ) (hs : 1 < s.re) :
    (∑' i : ℤ, minusCharTerm s i) = (4:ℂ)^s * betaSeries s := by
  have hp : (∑' i : ℤ, plusCharTerm s i) = -((4:ℂ)^s) * betaSeries s :=
    betaSeriesStatement s hs
  have hsym := tsum_plus_eq_neg_tsum_minus s
  have h : - (∑' i : ℤ, minusCharTerm s i) = -((4:ℂ)^s * betaSeries s) := by
    rw [← hsym, hp]
    ring
  exact neg_injective h

/-- **T88:** the shifted characteristic kernel at `−n` is minus the opposite shift at `n`. -/
lemma charKernel_quarter_neg (a : ℝ) (n : ℤ) :
    charKernel a (1/4) (-n) = - charKernel a (-1/4) n := by
  unfold charKernel
  push_cast
  ring_nf

/-- **T89:** the two characteristic thetas satisfy `θ₊ = −θ₋`. -/
lemma thetaPlus_eq_neg_thetaMinus (τ : ℝ) :
    thetaPlus τ = - thetaMinus τ := by
  unfold thetaPlus thetaMinus
  have h := (Equiv.neg ℤ).tsum_eq (fun n : ℤ => charKernel (Real.pi * τ) (1/4) n)
  rw [← h]
  rw [show (∑' c : ℤ, charKernel (Real.pi * τ) (1/4) ((Equiv.neg ℤ) c))
      = ∑' c : ℤ, - charKernel (Real.pi * τ) (-1/4) c by
    apply tsum_congr
    intro c
    change charKernel (Real.pi * τ) (1/4) (-c) = - charKernel (Real.pi * τ) (-1/4) c
    exact charKernel_quarter_neg _ _]
  rw [tsum_neg]

/-- **T90:** `twistedTheta4 a = a^(−3/2) θ₋(1/a)`. -/
lemma twistedTheta4_eq_cpow_inv (a : ℝ) (ha : 0 < a) :
    twistedTheta4 a = ((a:ℂ)^(-(3/2 : ℂ))) * thetaMinus a⁻¹ := by
  rw [twistedTheta4_vector_modular a ha, thetaPlus_eq_neg_thetaMinus]
  rw [show (1/a : ℝ) = a⁻¹ by rw [one_div]]
  have hpow : (((a ^ (3/2 : ℝ) : ℝ)) : ℂ) = (a:ℂ)^(3/2 : ℂ) := by
    rw [show (3/2 : ℂ) = ((3/2 : ℝ) : ℂ) by norm_num]
    rw [Complex.ofReal_cpow ha.le]
  have hcoef : (((1 / (2 * a ^ (3/2 : ℝ))) : ℝ) : ℂ)
      = (2:ℂ)⁻¹ * ((a:ℂ)^(3/2 : ℂ))⁻¹ := by
    rw [← hpow]
    push_cast
    ring
  rw [show (thetaMinus a⁻¹ - (- thetaMinus a⁻¹)) = 2 * thetaMinus a⁻¹ by ring]
  rw [hcoef]
  rw [Complex.cpow_neg]
  ring_nf

/-- **T91:** Mellin change of variables: `M(s) = mellinThetaMinus(1 − s/2)`. -/
lemma mellin_twistedTheta4_eq (u : ℂ) :
    mellin twistedTheta4 ((u+1)/2) = mellinThetaMinus (1 - u/2) := by
  have hcongr : mellin twistedTheta4 ((u+1)/2)
      = mellin (fun t : ℝ => (t:ℂ)^(-(3/2 : ℂ)) • thetaMinus t⁻¹) ((u+1)/2) := by
    unfold mellin
    exact setIntegral_congr_fun measurableSet_Ioi (fun t ht => by
      rw [twistedTheta4_eq_cpow_inv t ht]
      simp only [smul_eq_mul])
  rw [hcongr]
  rw [mellin_cpow_smul]
  rw [mellin_comp_inv]
  unfold mellinThetaMinus
  congr 1
  ring_nf

/-- **T92:** the scalar Mellin transform of `twistedTheta4` in the convergence
half-plane `Re s > 1`. -/
lemma mellin_twistedTheta4_eq_gamma_beta (s : ℂ) (hs : 1 < s.re) :
    mellin twistedTheta4 ((s+1)/2)
      = Complex.Gammaℝ (s+1) * (2 * betaSeries s) := by
  have h73 := hasSum_mellin_twistedTheta4 s hs
  have hsummand : (fun i : ℤ => Complex.Gammaℝ (s+1) * chi4Int i *
      (SignType.sign (i:ℝ) : ℂ) / ((|(i:ℝ)| : ℝ) : ℂ) ^ s)
      = (fun i : ℤ => Complex.Gammaℝ (s+1) * scalarTerm s i) := by
    funext i
    unfold scalarTerm
    ring
  rw [hsummand] at h73
  have hSB : HasSum (scalarTerm s) (2 * betaSeries s) := by
    have h := (summable_scalarTerm s hs).hasSum
    have h' : (∑' b : ℤ, scalarTerm s b) = 2 * betaSeries s := by
      simpa [scalarTerm] using scalarBetaStatement s hs
    rwa [h'] at h
  exact h73.unique (hSB.mul_left (Complex.Gammaℝ (s+1)))

/-- **T93:** the modular-relation form of the scalar Mellin transform, using the
`thetaMinus` Mellin identity at the reflected argument. -/
lemma mellin_twistedTheta4_eq_gamma_beta_dual (s : ℂ) (hs : 1 < s.re) :
    mellin twistedTheta4 ((2-s)/2)
      = Complex.Gammaℝ (s+1) * ((4:ℂ)^s * betaSeries s) := by
  have hM := mellin_twistedTheta4_eq (1-s)
  rw [show ((2-s)/2) = ((1-s+1)/2) by ring, hM]
  rw [show (1:ℂ) - (1-s)/2 = (s+1)/2 by ring]
  have h63 := hasSum_mellin_thetaMinus s hs
  have hsummand : (fun i : ℤ => Complex.Gammaℝ (s+1) *
      SignType.sign ((i:ℝ) + 1/4) / |(i:ℝ) + 1/4| ^ s)
      = (fun i : ℤ => Complex.Gammaℝ (s+1) * minusCharTerm s i) := by
    funext i
    unfold minusCharTerm
    ring
  rw [hsummand] at h63
  have hs0 : 0 < (s+1).re := by
    rw [Complex.add_re, Complex.one_re]; linarith
  have hG : Complex.Gammaℝ (s+1) ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hs0
  have hinv : HasSum (minusCharTerm s)
      ((Complex.Gammaℝ (s+1))⁻¹ * mellinThetaMinus ((s+1)/2)) := by
    have h := h63.mul_left ((Complex.Gammaℝ (s+1))⁻¹)
    have hpoint : (fun i : ℤ => (Complex.Gammaℝ (s+1))⁻¹ *
        (Complex.Gammaℝ (s+1) * minusCharTerm s i)) = minusCharTerm s := by
      funext i
      rw [← mul_assoc, inv_mul_cancel₀ hG, one_mul]
    rwa [hpoint] at h
  have hval : (Complex.Gammaℝ (s+1))⁻¹ * mellinThetaMinus ((s+1)/2)
      = (4:ℂ)^s * betaSeries s := by
    rw [← hinv.tsum_eq, tsum_minusCharTerm s hs]
  calc mellinThetaMinus ((s+1)/2)
      = Complex.Gammaℝ (s+1) *
          ((Complex.Gammaℝ (s+1))⁻¹ * mellinThetaMinus ((s+1)/2)) := by
        rw [← mul_assoc, mul_inv_cancel₀ hG, one_mul]
    _ = Complex.Gammaℝ (s+1) * ((4:ℂ)^s * betaSeries s) := by rw [hval]

/-- The completed beta function, in its Mellin form
`Λ(s) = 2^s ∫_0^∞ t^((s-1)/2) θ_χ(t) dt`. -/
def completedBeta (s : ℂ) : ℂ := (2:ℂ)^s * mellin twistedTheta4 ((s+1)/2)

/-- **T94:** in the series half-plane `Re s > 1`, `completedBeta` is the
classical completed beta `(4/π)^((s+1)/2) Γ((s+1)/2) β(s)`, written here as
`2^(s+1) Γℝ(s+1) β(s)`. -/
theorem completedBeta_eq_gamma_beta (s : ℂ) (hs : 1 < s.re) :
    completedBeta s = (2:ℂ)^(s+1) * Complex.Gammaℝ (s+1) * betaSeries s := by
  unfold completedBeta
  rw [mellin_twistedTheta4_eq_gamma_beta s hs]
  have hp : (2:ℂ)^(s+1) = (2:ℂ)^s * 2 := by
    rw [Complex.cpow_add s 1 (by norm_num : (2:ℂ) ≠ 0)]
    norm_num
  rw [hp]
  ring_nf

/-- **T95:** the completed beta functional equation `Λ(s) = Λ(1-s)`, in the
completed-beta normalisation of T94. -/
theorem completedBeta_functional_equation (s : ℂ) (hs : 1 < s.re) :
    completedBeta s = completedBeta (1-s) := by
  unfold completedBeta
  rw [show ((1-s)+1)/2 = (2-s)/2 by ring]
  rw [mellin_twistedTheta4_eq_gamma_beta s hs,
    mellin_twistedTheta4_eq_gamma_beta_dual s hs]
  have h4 : (4:ℂ)^s = (2:ℂ)^s * (2:ℂ)^s := by
    have h := Complex.mul_cpow_ofReal_nonneg (a := 2) (b := 2)
      (by norm_num : (0:ℝ) ≤ 2) (by norm_num : (0:ℝ) ≤ 2) s
    norm_num at h
    exact h
  have hp : (2:ℂ)^(1-s) * (2:ℂ)^s = 2 := by
    rw [← Complex.cpow_add _ _ (by norm_num : (2:ℂ) ≠ 0)]
    norm_num
  rw [h4]
  calc (2:ℂ)^s * (Complex.Gammaℝ (s+1) * (2 * betaSeries s))
      = 2 * ((2:ℂ)^s * (Complex.Gammaℝ (s+1) * betaSeries s)) := by ring_nf
    _ = ((2:ℂ)^(1-s) * (2:ℂ)^s) *
          ((2:ℂ)^s * (Complex.Gammaℝ (s+1) * betaSeries s)) := by rw [hp]
    _ = (2:ℂ)^(1-s) *
          (Complex.Gammaℝ (s+1) * ((2:ℂ)^s * (2:ℂ)^s * betaSeries s)) := by ring_nf


/-! ## The `χ₄` Dirichlet series, the completed beta, and P1 -/

open Asymptotics
open Filter
open scoped Topology

lemma chi4_natCast (n : ℕ) : chi4 ((n : ZMod 4)) = chi4Int (n : ℤ) := rfl

/-- **T97:** `χ₄(2m) = 0`. -/
lemma chi4_two_mul (m : ℕ) : chi4 ((2*m : ℕ) : ZMod 4) = 0 := by
  rw [show ((2*m : ℕ) : ZMod 4) = (2 * (m : ZMod 4)) by push_cast; ring, map_mul]
  have h : chi4 (2 : ZMod 4) = 0 := by simp [chi4]
  rw [h, zero_mul]

/-- **T98:** the `χ₄` Dirichlet-series summand on `ℕ` is supported on the odd integers. -/
lemma support_chi4_LSeries (s : ℂ) :
    Function.support (fun n : ℕ => chi4 (n : ZMod 4) / (n : ℂ) ^ s) ⊆
      Set.range (fun k : ℕ => 2*k+1) := by
  intro n hn
  rcases Nat.even_or_odd n with ⟨m, rfl⟩ | ⟨m, rfl⟩
  · exfalso
    apply hn
    show chi4 ((m + m : ℕ) : ZMod 4) / (((m + m : ℕ) : ℂ) ^ s) = 0
    rw [show ((m + m : ℕ) : ZMod 4) = ((2*m : ℕ) : ZMod 4) by congr 1; omega,
      chi4_two_mul]
    simp
  · exact ⟨m, by push_cast; ring⟩

/-- **T99:** the naive Dirichlet series of `χ₄` is `β(s)`. -/
lemma LSeries_chi4 (s : ℂ) :
    LSeries (fun n : ℕ => chi4 (n : ZMod 4)) s = betaSeries s := by
  rw [LSeries_def₀ (by simp [chi4]), betaSeries]
  have hinj : Function.Injective (fun k : ℕ => 2*k+1) := by
    intro a b h
    change 2*a+1 = 2*b+1 at h
    omega
  rw [← hinj.tsum_eq (f := fun n : ℕ => chi4 (n : ZMod 4) / (n : ℂ) ^ s)
    (support_chi4_LSeries s)]
  apply tsum_congr
  intro k
  have hchi : chi4 (((2*k+1 : ℕ)) : ZMod 4) = ((-1:ℂ)^k) := by
    rw [chi4_natCast]
    rw [show (((2*k+1 : ℕ)) : ℤ) = 2*(k:ℤ)+1 by push_cast; ring]
    rw [chi4Int_two_mul_add_one]
    push_cast
    ring
  rw [hchi]
  rw [show (((2*k+1 : ℕ)) : ℂ) = (2*(k:ℂ)+1) by push_cast; ring]
  rw [Complex.cpow_neg]
  ring

/-- **T100:** `χ₄` is a quadratic character. -/
lemma chi4_isQuadratic : MulChar.IsQuadratic (chi4 : MulChar (ZMod 4) ℂ) := by
  intro a
  have h := ZMod.isQuadratic_χ₄ a
  change ((ZMod.χ₄ a : ℤ) : ℂ) = 0 ∨ ((ZMod.χ₄ a : ℤ) : ℂ) = 1 ∨
    ((ZMod.χ₄ a : ℤ) : ℂ) = -1
  rcases h with h|h|h <;> rw [h] <;> norm_num

/-- **T101:** `χ₄⁻¹ = χ₄`. -/
lemma chi4_inv_eq_self : chi4⁻¹ = chi4 := by
  ext a
  rw [MulChar.inv_apply_eq_inv']
  have hq := chi4_isQuadratic a
  rcases hq with h|h|h <;> rw [h] <;> norm_num

/-- **T102:** Mathlib's Gauss sum of `χ₄` equals the computed `gaussSumChi4`. -/
lemma gaussSum_chi4_eq_std : gaussSum chi4 ZMod.stdAddChar = gaussSumChi4 := by
  unfold gaussSum gaussSumChi4
  apply Finset.sum_congr rfl
  intro a ha
  rw [ZMod.stdAddChar_apply, ZMod.toCircle_apply]
  simp only [ZMod.val]
  norm_num
  rfl

/-- **T103:** the normalized root number of `χ₄` is `1`. -/
lemma rootNumber_chi4_eq_one : DirichletCharacter.rootNumber chi4 = 1 := by
  unfold DirichletCharacter.rootNumber
  rw [gaussSum_chi4_eq_std, gaussSumChi4_eq]
  have hodd : chi4.Odd := chi4_neg_one
  have hne : ¬ chi4.Even := hodd.not_even
  simp [hne]
  have h4 : ((4:ℂ) ^ ((2:ℂ)⁻¹)) = 2 := by
    rw [show ((2:ℂ)⁻¹) = ((1/2:ℝ):ℂ) by norm_num]
    rw [show (4:ℂ) = ((4:ℝ):ℂ) by norm_num]
    rw [← Complex.ofReal_cpow (by norm_num : (0:ℝ) ≤ 4)]
    norm_num
  rw [h4]
  field_simp

/-- **T104:** `completedLFunction χ₄ s = Γℝ(s+1)·β(s)` for `Re s > 1`. -/
lemma completedLFunction_chi4_eq (s : ℂ) (hs : 1 < s.re) :
    DirichletCharacter.completedLFunction chi4 s
      = Complex.Gammaℝ (s+1) * betaSeries s := by
  have hγ : DirichletCharacter.gammaFactor chi4 s = Complex.Gammaℝ (s+1) :=
    DirichletCharacter.Odd.gammaFactor_def chi4_neg_one s
  have h := DirichletCharacter.LFunction_eq_completed_div_gammaFactor chi4 s
    (Or.inr (by norm_num : (4:ℕ) ≠ 1))
  rw [hγ] at h
  have hG : Complex.Gammaℝ (s+1) ≠ 0 := by
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    rw [Complex.add_re, Complex.one_re]; linarith
  have hCL : DirichletCharacter.completedLFunction chi4 s
      = DirichletCharacter.LFunction chi4 s * Complex.Gammaℝ (s+1) := by
    rw [h, div_mul_cancel₀ _ hG]
  rw [hCL, DirichletCharacter.LFunction_eq_LSeries chi4 hs, LSeries_chi4 s]
  ring

/-- **T105:** `completedBeta s = 2^(s+1)·completedLFunction χ₄ s` for `Re s > 1`. -/
lemma completedBeta_eq_two_cpow_completedLFunction (s : ℂ) (hs : 1 < s.re) :
    completedBeta s
      = (2:ℂ)^(s+1) * DirichletCharacter.completedLFunction chi4 s := by
  rw [completedBeta_eq_gamma_beta s hs, completedLFunction_chi4_eq s hs]
  ring

lemma thetaMinus_eq_oddKernel (x : ℝ) (hx : 0 < x) :
    thetaMinus x = (HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) x : ℂ) := by
  rw [HurwitzZeta.oddKernel_def (1/4) x]
  have h := jacobiTheta2''_quarter_minus (1/x) (by positivity : 0 < 1/x)
  have hx' : (1/(1/x) : ℝ) = x := by field_simp
  rw [hx'] at h
  rw [← h]
  congr 1
  norm_num
  rw [one_div, Complex.ofReal_inv]
  field_simp

/-- **T107:** `twistedTheta4` is the `sinKernel` at shift `1/4`. -/
lemma twistedTheta4_eq_sinKernel (t : ℝ) (ht : 0 < t) :
    twistedTheta4 t = (HurwitzZeta.sinKernel (↑(1/4:ℝ) : UnitAddCircle) t : ℂ) := by
  rw [twistedTheta4_eq_cpow_inv t ht]
  have htinv : (t⁻¹ : ℝ) = 1/t := by rw [one_div]
  rw [htinv]
  rw [thetaMinus_eq_oddKernel (1/t) (by positivity)]
  have hFE := HurwitzZeta.oddKernel_functional_equation (↑(1/4:ℝ) : UnitAddCircle) (1/t)
  have h1 : (1/(1/t) : ℝ) = t := by field_simp
  rw [h1] at hFE
  rw [hFE]
  rw [Complex.ofReal_mul]
  have hr : (t:ℝ)^(-(3/2:ℝ)) * (1 / ((1/t:ℝ)^(3/2:ℝ))) = 1 := by
    rw [Real.rpow_neg ht.le]
    rw [show (1/t:ℝ) = t⁻¹ by rw [one_div]]
    rw [Real.inv_rpow ht.le]
    field_simp
  have hpow : (t:ℂ)^(-(3/2:ℂ)) = (((t:ℝ)^(-(3/2:ℝ)) : ℝ) : ℂ) := by
    rw [show (-(3/2:ℂ)) = ((-(3/2:ℝ) : ℝ) : ℂ) by norm_num]
    exact (Complex.ofReal_cpow ht.le (-(3/2:ℝ))).symm
  have hcoe : (t:ℂ)^(-(3/2:ℂ)) * ((1 / ((1/t:ℝ)^(3/2:ℝ)) : ℝ) : ℂ) = 1 := by
    rw [hpow]
    norm_cast
  rw [← mul_assoc, hcoe, one_mul]

/-- **T108:** `twistedTheta4` is continuous on `(0,∞)`. -/
lemma continuousOn_twistedTheta4 : ContinuousOn twistedTheta4 (Set.Ioi 0) := by
  have h := (Complex.continuous_ofReal.comp_continuousOn
    (HurwitzZeta.continuousOn_sinKernel (↑(1/4:ℝ) : UnitAddCircle)))
  refine h.congr ?_
  intro t ht
  exact twistedTheta4_eq_sinKernel t ht

/-- **T109:** `twistedTheta4` has exponential decay at `+∞`. -/
lemma isBigO_twistedTheta4_atTop :
    ∃ p, 0 < p ∧ IsBigO Filter.atTop twistedTheta4 (fun x => Real.exp (-p * x)) := by
  obtain ⟨p, hp, hpO⟩ := HurwitzZeta.isBigO_atTop_sinKernel (↑(1/4:ℝ) : UnitAddCircle)
  refine ⟨p, hp, ?_⟩
  have hEq : twistedTheta4 =ᶠ[Filter.atTop]
      (fun t : ℝ => (HurwitzZeta.sinKernel (↑(1/4:ℝ) : UnitAddCircle) t : ℂ)) := by
    have hpos : ∀ᶠ t : ℝ in Filter.atTop, 0 < t := Filter.eventually_gt_atTop (0:ℝ)
    filter_upwards [hpos] with t ht
    exact twistedTheta4_eq_sinKernel t ht
  have hO : (fun t : ℝ => (HurwitzZeta.sinKernel (↑(1/4:ℝ) : UnitAddCircle) t : ℂ))
      =O[Filter.atTop] (fun x : ℝ => Real.exp (-p * x)) := by
    refine IsBigO.of_norm_left ?_
    have hnorm : (fun t : ℝ => ‖(HurwitzZeta.sinKernel (↑(1/4:ℝ) : UnitAddCircle) t : ℂ)‖) =
        (fun t : ℝ => ‖HurwitzZeta.sinKernel (↑(1/4:ℝ) : UnitAddCircle) t‖) := by
      funext t
      simp [Complex.norm_real, Real.norm_eq_abs]
    rw [hnorm]
    simpa using hpO.norm_left
  exact hEq.trans_isBigO hO

/-- **T110:** `twistedTheta4` is `O(t^(−b))` at `0` for every `b`. -/
lemma isBigO_twistedTheta4_zero (b : ℝ) :
    IsBigO (nhdsWithin 0 (Set.Ioi 0)) twistedTheta4 (fun t : ℝ => t ^ (-b)) := by
  obtain ⟨p, hp, hpO⟩ := HurwitzZeta.isBigO_atTop_oddKernel (↑(1/4:ℝ) : UnitAddCircle)
  have hoddreal : (fun t : ℝ => HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) t⁻¹)
      =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => Real.exp (-p * t⁻¹)) :=
    hpO.comp_tendsto (tendsto_inv_nhdsGT_zero (𝕜 := ℝ))
  have hexp : (fun t : ℝ => Real.exp (-p * t⁻¹))
      =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => t ^ (-(b - 3/2))) := by
    have h := (isLittleO_exp_neg_mul_rpow_atTop hp (b - 3/2)).comp_tendsto
      (tendsto_inv_nhdsGT_zero (𝕜 := ℝ))
    have hEq : (fun t : ℝ => (t⁻¹) ^ (b - 3/2))
        =ᶠ[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => t ^ (-(b - 3/2))) := by
      filter_upwards [self_mem_nhdsWithin] with t ht
      rw [Real.inv_rpow ht.le, ← Real.rpow_neg ht.le]
    exact h.isBigO.trans hEq.isBigO
  have hpow : (fun t : ℝ => t ^ (-(3/2:ℝ)) * Real.exp (-p * t⁻¹))
      =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => t ^ (-b)) := by
    have hmul := (isBigO_refl (fun t : ℝ => t ^ (-(3/2:ℝ))) _).mul hexp
    refine hmul.trans ?_
    have hcongr : (fun t : ℝ => t ^ (-(3/2:ℝ)) * t ^ (-(b - 3/2)))
        =ᶠ[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => t ^ (-b)) := by
      filter_upwards [self_mem_nhdsWithin] with t ht
      rw [← Real.rpow_add (show (0:ℝ) < t from ht)]
      congr 1
      ring
    exact hcongr.isBigO
  have hreal : (fun t : ℝ => t ^ (-(3/2:ℝ)) *
      HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) t⁻¹)
      =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => t ^ (-b)) :=
    ((isBigO_refl (fun t : ℝ => t ^ (-(3/2:ℝ))) _).mul hoddreal).trans hpow
  have hEq : twistedTheta4 =ᶠ[nhdsWithin 0 (Set.Ioi 0)]
      (fun t : ℝ => (t:ℂ)^(-(3/2:ℂ)) *
        (HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) t⁻¹ : ℂ)) := by
    filter_upwards [self_mem_nhdsWithin] with t ht
    rw [twistedTheta4_eq_cpow_inv t ht]
    rw [thetaMinus_eq_oddKernel t⁻¹ (inv_pos.mpr ht)]
  have hcomplex : (fun t : ℝ => (t:ℂ)^(-(3/2:ℂ)) *
      (HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) t⁻¹ : ℂ))
      =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ => t ^ (-b)) := by
    refine IsBigO.of_norm_left ?_
    have hnorm : (fun t : ℝ => ‖(t:ℂ)^(-(3/2:ℂ)) *
        (HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) t⁻¹ : ℂ)‖)
        =ᶠ[nhdsWithin 0 (Set.Ioi 0)]
        (fun t : ℝ => ‖t ^ (-(3/2:ℝ)) *
          HurwitzZeta.oddKernel (↑(1/4:ℝ) : UnitAddCircle) t⁻¹‖) := by
      filter_upwards [self_mem_nhdsWithin] with t ht
      rw [norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos ht,
        show (-(3/2:ℂ)).re = -(3/2:ℝ) by norm_num,
        Complex.norm_real, Real.norm_eq_abs]
      rw [Real.norm_eq_abs, abs_mul, abs_of_nonneg (Real.rpow_nonneg ht.le _)]
    exact hnorm.trans_isBigO hreal.norm_left
  exact hEq.trans_isBigO hcomplex

/-- **T111:** `twistedTheta4` is locally integrable on `(0,∞)`. -/
lemma locallyIntegrableOn_twistedTheta4 :
    LocallyIntegrableOn twistedTheta4 (Set.Ioi 0) :=
  continuousOn_twistedTheta4.locallyIntegrableOn measurableSet_Ioi

/-- **T112:** the Mellin transform of `twistedTheta4` is entire. -/
lemma mellin_twistedTheta4_differentiableAt (u : ℂ) :
    DifferentiableAt ℂ (fun z : ℂ => mellin twistedTheta4 z) u := by
  obtain ⟨p, hp, hpO⟩ := isBigO_twistedTheta4_atTop
  have hb : IsBigO (nhdsWithin 0 (Set.Ioi 0)) twistedTheta4
      (fun t : ℝ => t ^ (-(u.re - 1))) := isBigO_twistedTheta4_zero (u.re - 1)
  exact mellin_differentiableAt_of_isBigO_rpow_exp hp locallyIntegrableOn_twistedTheta4 hpO hb
    (by linarith)

/-- **T113:** the Mellin transform of `twistedTheta4` is differentiable. -/
lemma differentiable_mellin_twistedTheta4 :
    Differentiable ℂ (fun u : ℂ => mellin twistedTheta4 u) :=
  fun u => mellin_twistedTheta4_differentiableAt u

/-- **T114:** `completedBeta` is entire. -/
lemma differentiable_completedBeta : Differentiable ℂ completedBeta := by
  intro s
  unfold completedBeta
  refine DifferentiableAt.mul ?_ ?_
  · exact (differentiableAt_id.const_cpow (Or.inl (by norm_num : (2:ℂ) ≠ 0)))
  · exact differentiable_mellin_twistedTheta4.differentiableAt.comp s (by fun_prop)

/-- **T115:** `completedBeta s = completedBeta (1−s)` for all `s`. -/
theorem completedBeta_functional_equation_all (s : ℂ) :
    completedBeta s = completedBeta (1 - s) := by
  have hF : AnalyticOnNhd ℂ completedBeta Set.univ := by
    rw [Complex.analyticOnNhd_univ_iff_differentiable]
    exact differentiable_completedBeta
  have hG : AnalyticOnNhd ℂ (fun t : ℂ => completedBeta (1 - t)) Set.univ := by
    rw [Complex.analyticOnNhd_univ_iff_differentiable]
    exact differentiable_completedBeta.comp (by fun_prop)
  have hmem : {z : ℂ | 1 < z.re} ∈ 𝓝 (2 : ℂ) :=
    (isOpen_lt continuous_const Complex.continuous_re).mem_nhds (by norm_num)
  have hEq : completedBeta =ᶠ[𝓝 (2 : ℂ)] (fun t : ℂ => completedBeta (1 - t)) := by
    filter_upwards [hmem] with t ht
    exact completedBeta_functional_equation t ht
  have h := hF.eq_of_eventuallyEq hG hEq
  exact congr_fun h s

/-- **T116:** the bridge `completedBeta s = 2^(s+1)·completedLFunction χ₄ s` for all `s`. -/
theorem completedBeta_eq_two_cpow_completedLFunction_all (s : ℂ) :
    completedBeta s
      = (2:ℂ)^(s+1) * DirichletCharacter.completedLFunction chi4 s := by
  have hF : AnalyticOnNhd ℂ completedBeta Set.univ := by
    rw [Complex.analyticOnNhd_univ_iff_differentiable]
    exact differentiable_completedBeta
  have hG : AnalyticOnNhd ℂ
      (fun t : ℂ => (2:ℂ)^(t+1) * DirichletCharacter.completedLFunction chi4 t) Set.univ := by
    rw [Complex.analyticOnNhd_univ_iff_differentiable]
    refine Differentiable.mul ?_ ?_
    · exact (differentiable_id.add_const 1).const_cpow (Or.inl (by norm_num : (2:ℂ) ≠ 0))
    · exact DirichletCharacter.differentiable_completedLFunction chi4_ne_one
  have hmem : {z : ℂ | 1 < z.re} ∈ 𝓝 (2 : ℂ) :=
    (isOpen_lt continuous_const Complex.continuous_re).mem_nhds (by norm_num)
  have hEq : completedBeta =ᶠ[𝓝 (2 : ℂ)]
      (fun t : ℂ => (2:ℂ)^(t+1) * DirichletCharacter.completedLFunction chi4 t) := by
    filter_upwards [hmem] with t ht
    exact completedBeta_eq_two_cpow_completedLFunction t ht
  have h := hF.eq_of_eventuallyEq hG hEq
  exact congr_fun h s

/-- **T117:** T24 replacement: the completed `L`-function functional equation for `χ₄`, from the theta route. -/
theorem chi4_completedLFunction_one_sub_theta (s : ℂ) :
    DirichletCharacter.completedLFunction chi4 (1 - s)
      = (4 : ℂ) ^ (s - 1 / 2) * DirichletCharacter.rootNumber chi4 *
        DirichletCharacter.completedLFunction chi4⁻¹ s := by
  rw [rootNumber_chi4_eq_one, chi4_inv_eq_self]
  have h := completedBeta_functional_equation_all s
  rw [completedBeta_eq_two_cpow_completedLFunction_all s,
      completedBeta_eq_two_cpow_completedLFunction_all (1-s)] at h
  rw [show (1:ℂ) - s + 1 = 2 - s by ring] at h
  have hB : (2:ℂ)^(2-s) ≠ 0 := by
    rw [Complex.cpow_ne_zero_iff]; left; norm_num
  have hpow4 : (4:ℂ)^(s - 1/2) = (2:ℂ)^(s - 1/2) * (2:ℂ)^(s - 1/2) := by
    have h := Complex.mul_cpow_ofReal_nonneg (a := 2) (b := 2)
      (by norm_num : (0:ℝ) ≤ 2) (by norm_num : (0:ℝ) ≤ 2) (s - 1/2)
    rw [show (4:ℂ) = (2:ℂ) * (2:ℂ) by norm_num]
    exact h
  have hcoef : (2:ℂ)^(2-s) * (4:ℂ)^(s - 1/2) = (2:ℂ)^(s+1) := by
    rw [hpow4]
    have hinner : (2:ℂ)^(s - 1/2) * (2:ℂ)^(s - 1/2) = (2:ℂ)^(2*s - 1) := by
      rw [← Complex.cpow_add _ _ (by norm_num : (2:ℂ) ≠ 0)]
      congr 1; ring
    rw [hinner, ← Complex.cpow_add _ _ (by norm_num : (2:ℂ) ≠ 0)]
    congr 1; ring
  have h' : DirichletCharacter.completedLFunction chi4 (1-s)
      = ((2:ℂ)^(2-s))⁻¹ *
        ((2:ℂ)^(s+1) * DirichletCharacter.completedLFunction chi4 s) := by
    rw [h, ← mul_assoc, inv_mul_cancel₀ hB, one_mul]
  rw [h']
  have hBA : ((2:ℂ)^(2-s))⁻¹ * (2:ℂ)^(s+1) = (4:ℂ)^(s - 1/2) := by
    rw [← hcoef, ← mul_assoc, inv_mul_cancel₀ hB, one_mul]
  rw [← mul_assoc, hBA]
  ring

/-- **T118:** Legendre duplication in the form `2^(s+1)Γℝ(s)Γℝ(s+1) = 4π^(−s)Γ(s)`. -/
lemma gammaR_duplication (s : ℂ) :
    (2:ℂ)^(s+1) * Complex.Gammaℝ s * Complex.Gammaℝ (s+1)
      = 4 * ((Real.pi : ℝ) : ℂ)^(-s) * Complex.Gamma s := by
  have hdup : Complex.Gamma (s/2) * Complex.Gamma ((s+1)/2) =
      Complex.Gamma s * (2:ℂ)^(1-s) * ((Real.sqrt Real.pi : ℝ) : ℂ) := by
    have h := Complex.Gamma_mul_Gamma_add_half (s/2)
    rw [show 2*(s/2) = s by ring, show s/2 + 1/2 = (s+1)/2 by ring] at h
    exact h
  have hsqrt : ((Real.sqrt Real.pi : ℝ) : ℂ) = ((Real.pi : ℝ) : ℂ)^(1/2 : ℂ) := by
    rw [Real.sqrt_eq_rpow]
    rw [show (1/2 : ℂ) = ((1/2 : ℝ) : ℂ) by norm_num]
    rw [← Complex.ofReal_cpow Real.pi_pos.le]
  have hpi : ((Real.pi : ℝ) : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  rw [Complex.Gammaℝ_def, Complex.Gammaℝ_def]
  calc (2:ℂ)^(s+1) * (((Real.pi : ℝ) : ℂ)^(-s/2) * Complex.Gamma (s/2)) *
        (((Real.pi : ℝ) : ℂ)^(-(s+1)/2) * Complex.Gamma ((s+1)/2))
      = ((2:ℂ)^(s+1) * (((Real.pi : ℝ) : ℂ)^(-s/2) * ((Real.pi : ℝ) : ℂ)^(-(s+1)/2))) *
          (Complex.Gamma (s/2) * Complex.Gamma ((s+1)/2)) := by ring
    _ = ((2:ℂ)^(s+1) * ((Real.pi : ℝ) : ℂ)^(-s - 1/2)) *
          (Complex.Gamma s * (2:ℂ)^(1-s) * ((Real.pi : ℝ) : ℂ)^(1/2 : ℂ)) := by
          have hsum : ((Real.pi : ℝ) : ℂ)^(-s/2) * ((Real.pi : ℝ) : ℂ)^(-(s+1)/2)
              = ((Real.pi : ℝ) : ℂ)^(-s - 1/2) := by
            rw [← Complex.cpow_add _ _ hpi]
            congr 1; ring
          rw [hsum, hdup, hsqrt]
    _ = 4 * ((Real.pi : ℝ) : ℂ)^(-s) * Complex.Gamma s := by
          have h2 : (2:ℂ)^(s+1) * (2:ℂ)^(1-s) = 4 := by
            rw [← Complex.cpow_add _ _ (by norm_num : (2:ℂ) ≠ 0)]
            rw [show s + 1 + (1-s) = (2:ℂ) by ring]
            norm_num
          have hpi2 : ((Real.pi : ℝ) : ℂ)^(-s - 1/2) * ((Real.pi : ℝ) : ℂ)^(1/2 : ℂ)
              = ((Real.pi : ℝ) : ℂ)^(-s) := by
            rw [← Complex.cpow_add _ _ hpi]
            congr 1; ring
          calc ((2:ℂ)^(s+1) * ((Real.pi : ℝ) : ℂ)^(-s - 1/2)) *
                (Complex.Gamma s * (2:ℂ)^(1-s) * ((Real.pi : ℝ) : ℂ)^(1/2 : ℂ))
              = ((2:ℂ)^(s+1) * (2:ℂ)^(1-s)) *
                  (((Real.pi : ℝ) : ℂ)^(-s - 1/2) * ((Real.pi : ℝ) : ℂ)^(1/2 : ℂ)) *
                    Complex.Gamma s := by ring
            _ = 4 * ((Real.pi : ℝ) : ℂ)^(-s) * Complex.Gamma s := by rw [h2, hpi2]

/-- The completed `ℤ²` `L`-series `Λ_ℤ²(s)`, in product form. -/
def LambdaZ2 (s : ℂ) : ℂ := completedRiemannZeta s * completedBeta s

/-- **T119:** P1: `Λ_ℤ²(s) = Λ_ℤ²(1−s)`. -/
theorem lambdaZ2_self_dual (s : ℂ) : LambdaZ2 s = LambdaZ2 (1-s) := by
  unfold LambdaZ2
  rw [completedRiemannZeta_one_sub, ← completedBeta_functional_equation_all s]

/-- **T120:** P1: `Λ_ℤ²(s) = 4π^(−s)Γ(s)ζ(s)β(s)` for `Re s > 1`. -/
theorem lambdaZ2_product (s : ℂ) (hs : 1 < s.re) :
    LambdaZ2 s
      = 4 * ((Real.pi : ℝ) : ℂ)^(-s) * Complex.Gamma s * riemannZeta s * betaSeries s := by
  unfold LambdaZ2
  have hs0 : s ≠ 0 := by rintro rfl; norm_num at hs
  have hG : Complex.Gammaℝ s ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos (lt_trans zero_lt_one hs)
  have hCRZ : completedRiemannZeta s = Complex.Gammaℝ s * riemannZeta s := by
    rw [riemannZeta_def_of_ne_zero hs0]
    field_simp [hG]
  rw [hCRZ, completedBeta_eq_gamma_beta s hs]
  rw [show (Complex.Gammaℝ s * riemannZeta s) *
        ((2:ℂ)^(s+1) * Complex.Gammaℝ (s+1) * betaSeries s)
      = ((2:ℂ)^(s+1) * Complex.Gammaℝ s * Complex.Gammaℝ (s+1)) *
          (riemannZeta s * betaSeries s) by ring]
  rw [gammaR_duplication s]
  ring


/-! ## The Epstein/lattice series reduction -/

/-- The number of ordered integer pairs `(x,y)` with `x² + y² = n`. -/
def r2 (n : ℕ) : ℕ :=
  (((Finset.Icc (-(n:ℤ)) (n:ℤ)).product (Finset.Icc (-(n:ℤ)) (n:ℤ))).filter
    (fun p : ℤ × ℤ => p.1^2 + p.2^2 = (n:ℤ))).card

/-- The divisor sum `Σ_{d|n} χ₄(d)`. -/
def divisorSumChi4 (n : ℕ) : ℤ :=
  ∑ d ∈ n.divisors, ZMod.χ₄ (d : ZMod 4)

/-- Named arithmetic input: the two-squares representation count. -/
def TwoSquaresFormula : Prop :=
  ∀ n : ℕ, 1 ≤ n → (r2 n : ℤ) = 4 * divisorSumChi4 n


/-- **T121:** the divisor-sum L-series is `ζ(s)β(s)`. -/
lemma LSeries_divisorSumChi4 (s : ℂ) (hs : 1 < s.re) :
    LSeries (fun n : ℕ => (divisorSumChi4 n : ℂ)) s
      = riemannZeta s * betaSeries s := by
  let f : ℕ → ℂ := fun n => chi4Int (n:ℤ)
  let g : ℕ → ℂ := fun _ => 1
  have hconv : (fun n : ℕ => (divisorSumChi4 n : ℂ)) = LSeries.convolution f g := by
    rw [LSeries.convolution_def f g]
    funext n
    rw [Nat.sum_divisorsAntidiagonal (fun i j => f i * g j)]
    simp only [f, g, mul_one]
    rw [show (divisorSumChi4 n : ℂ) = ∑ d ∈ n.divisors, chi4Int (d:ℤ) by
      unfold divisorSumChi4
      push_cast
      simp [chi4Int]]
  have hf : f = fun n : ℕ => chi4 (n : ZMod 4) := by
    funext n
    exact (chi4_natCast n).symm
  rw [hconv, LSeries_convolution' ?_ ?_]
  · rw [hf, LSeries_chi4]
    simp only [g]
    rw [show (fun _ : ℕ => (1:ℂ)) = 1 by rfl, LSeries_one_eq_riemannZeta hs]
    ring
  · rw [hf]
    exact DirichletCharacter.LSeriesSummable_of_one_lt_re chi4 hs
  · exact LSeriesSummable_one_iff.mpr hs

/-- **T124:** `r2 n = 0` iff there is no integer representation `x²+y²=n`. -/
lemma r2_eq_zero_iff (n : ℕ) :
    r2 n = 0 ↔ ¬ ∃ x y : ℤ, x^2 + y^2 = (n:ℤ) := by
  unfold r2
  rw [Finset.card_eq_zero, Finset.filter_eq_empty_iff]
  constructor
  · rintro h ⟨x, y, hxy⟩
    have hxmem : x ∈ Finset.Icc (-(n:ℤ)) (n:ℤ) := by
      rw [Finset.mem_Icc]
      have hx2 : x^2 ≤ (n:ℤ) := by nlinarith [sq_nonneg y]
      constructor <;> nlinarith [sq_nonneg x]
    have hymem : y ∈ Finset.Icc (-(n:ℤ)) (n:ℤ) := by
      rw [Finset.mem_Icc]
      have hy2 : y^2 ≤ (n:ℤ) := by nlinarith [sq_nonneg x]
      constructor <;> nlinarith [sq_nonneg y]
    exact h (x := (x, y)) (Finset.mem_product.mpr ⟨hxmem, hymem⟩) hxy
  · rintro h x _ hxy
    exact h ⟨x.1, x.2, hxy⟩


/-! ## Gaussian integers: basis, algebra norm, and ideal norm -/

def gaussianVec : Fin 2 → GaussianInt
  | 0 => 1
  | 1 => ⟨0, 1⟩

lemma gaussianVec_zero : gaussianVec 0 = 1 := rfl
lemma gaussianVec_one : gaussianVec 1 = (⟨0, 1⟩ : GaussianInt) := rfl

lemma gaussianVec_linearIndependent : LinearIndependent ℤ gaussianVec := by
  have h : gaussianVec = ![(1:GaussianInt), (⟨0,1⟩ : GaussianInt)] := by
    funext i
    fin_cases i <;> rfl
  rw [h, LinearIndependent.pair_iff]
  intro s t hst
  have hre := congr_arg Zsqrtd.re hst
  have him := congr_arg Zsqrtd.im hst
  simp at hre him
  omega

lemma gaussianVec_span : ⊤ ≤ Submodule.span ℤ (Set.range gaussianVec) := by
  intro x hx
  rw [Submodule.mem_span_range_iff_exists_fun]
  refine ⟨fun i : Fin 2 => if i = 0 then x.re else x.im, ?_⟩
  rw [Fin.sum_univ_two]
  simp [gaussianVec_zero, gaussianVec_one]
  ext <;> simp

noncomputable def gaussianBasis : Module.Basis (Fin 2) ℤ GaussianInt :=
  Module.Basis.mk gaussianVec_linearIndependent gaussianVec_span

lemma gaussianBasis_apply_zero : gaussianBasis (0 : Fin 2) = (1 : GaussianInt) := by
  rw [show gaussianBasis = Module.Basis.mk gaussianVec_linearIndependent gaussianVec_span from rfl,
    Module.Basis.mk_apply]
  rfl

lemma gaussianBasis_apply_one : gaussianBasis (1 : Fin 2) = (⟨0, 1⟩ : GaussianInt) := by
  rw [show gaussianBasis = Module.Basis.mk gaussianVec_linearIndependent gaussianVec_span from rfl,
    Module.Basis.mk_apply]
  rfl

lemma repr_gaussian_zero (z : GaussianInt) : gaussianBasis.repr z 0 = z.re := by
  have h : z = z.re • gaussianBasis 0 + z.im • gaussianBasis 1 := by
    rw [gaussianBasis_apply_zero, gaussianBasis_apply_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [gaussianBasis_apply_zero, gaussianBasis_apply_one]

lemma repr_gaussian_one (z : GaussianInt) : gaussianBasis.repr z 1 = z.im := by
  have h : z = z.re • gaussianBasis 0 + z.im • gaussianBasis 1 := by
    rw [gaussianBasis_apply_zero, gaussianBasis_apply_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [gaussianBasis_apply_zero, gaussianBasis_apply_one]

/-- **T125:** the algebra norm of a Gaussian integer is its `Zsqrtd.norm`. -/
lemma algebra_norm_gaussian (z : GaussianInt) : Algebra.norm ℤ z = z.norm := by
  rw [Algebra.norm_eq_matrix_det gaussianBasis z]
  have hmat : Algebra.leftMulMatrix gaussianBasis z = !![z.re, -z.im; z.im, z.re] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Algebra.leftMulMatrix_eq_repr_mul, gaussianBasis_apply_zero,
        gaussianBasis_apply_one, repr_gaussian_zero, repr_gaussian_one, mul_one]
  rw [hmat]
  simp only [Matrix.det_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one]
  rw [Zsqrtd.norm_def]
  ring

/-- **T126:** the ideal norm of the principal ideal `(z)` is `z.norm.natAbs`. -/
lemma absNorm_span_gaussian (z : GaussianInt) :
    Ideal.absNorm (Ideal.span {z}) = z.norm.natAbs := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  rw [Ideal.absNorm_span_singleton]
  congr 1
  exact algebra_norm_gaussian z


/-! ## Gaussian units -/

lemma gaussian_unit_norm_eq_one (u : GaussianIntˣ) :
    (u : GaussianInt).norm = 1 := by
  have h := (Zsqrtd.norm_eq_one_iff (x := (u : GaussianInt))).mpr u.isUnit
  have habs := GaussianInt.abs_natCast_norm (u : GaussianInt)
  rw [← habs, h]
  norm_num

/-- **T127:** every Gaussian unit is one of `1, -1, i, -i`. -/
lemma gaussian_unit_classification (u : GaussianIntˣ) :
    (u : GaussianInt) = 1 ∨ (u : GaussianInt) = -1 ∨
      (u : GaussianInt) = ⟨0, 1⟩ ∨ (u : GaussianInt) = ⟨0, -1⟩ := by
  have hnorm := gaussian_unit_norm_eq_one u
  rw [Zsqrtd.norm_def] at hnorm
  have hre1 : -1 ≤ (u : GaussianInt).re := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  have hre2 : (u : GaussianInt).re ≤ 1 := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  have him1 : -1 ≤ (u : GaussianInt).im := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  have him2 : (u : GaussianInt).im ≤ 1 := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  interval_cases h1 : (u : GaussianInt).re <;> interval_cases h2 : (u : GaussianInt).im
  all_goals simp_all
  case «-1».«0» => right; left; ext <;> simp_all
  case «0».«-1» => right; right; right; ext <;> simp_all
  case «0».«1» => right; right; left; ext <;> simp_all
  case «1».«0» => left; ext <;> simp_all

def gaussianIUnit : GaussianIntˣ :=
  ⟨⟨0, 1⟩, ⟨0, -1⟩, by ext <;> simp, by ext <;> simp⟩

def gaussianNegIUnit : GaussianIntˣ :=
  ⟨⟨0, -1⟩, ⟨0, 1⟩, by ext <;> simp, by ext <;> simp⟩

def gaussianUnits : Finset GaussianIntˣ :=
  {1, -1, gaussianIUnit, gaussianNegIUnit}

lemma mem_gaussianUnits (u : GaussianIntˣ) : u ∈ gaussianUnits := by
  rcases gaussian_unit_classification u with h | h | h | h
  · have hu : u = (1 : GaussianIntˣ) := Units.ext (by simpa using h)
    rw [hu]; simp [gaussianUnits]
  · have hu : u = (-1 : GaussianIntˣ) := Units.ext (by simpa using h)
    rw [hu]; simp [gaussianUnits]
  · have hu : u = gaussianIUnit := Units.ext (by simpa [gaussianIUnit] using h)
    rw [hu]; simp [gaussianUnits]
  · have hu : u = gaussianNegIUnit := Units.ext (by simpa [gaussianNegIUnit] using h)
    rw [hu]; simp [gaussianUnits]

def unitsEquivSubtype : GaussianIntˣ ≃ {x : GaussianIntˣ // x ∈ gaussianUnits} where
  toFun u := ⟨u, mem_gaussianUnits u⟩
  invFun x := x.1
  left_inv _ := rfl
  right_inv x := by
    obtain ⟨u, hu⟩ := x
    exact Subtype.ext rfl

/-- **T128:** the Gaussian unit group has cardinality four. -/
lemma gaussianUnits_card_four : Nat.card GaussianIntˣ = 4 := by
  rw [Nat.card_congr unitsEquivSubtype]
  letI : Fintype {x : GaussianIntˣ // x ∈ gaussianUnits} :=
    Fintype.subtype gaussianUnits (fun x => Iff.rfl)
  rw [Nat.card_eq_fintype_card]
  have h : Fintype.card {x : GaussianIntˣ // x ∈ gaussianUnits} = gaussianUnits.card := by
    rw [← Finset.card_attach]
    rfl
  rw [h]
  decide


/-! ## Counting Gaussian integers of a given norm -/

lemma gaussian_norm_mk (x y : ℤ) : (⟨x, y⟩ : GaussianInt).norm = x^2 + y^2 := by
  rw [Zsqrtd.norm_def]
  ring

def pairToGaussian (n : ℕ) :
    {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} → {z : GaussianInt // z.norm.natAbs = n}
  | ⟨⟨x, y⟩, h⟩ => ⟨⟨x, y⟩, by
      rw [gaussian_norm_mk, h, Int.natAbs_natCast]⟩

def gaussianToPair (n : ℕ) :
    {z : GaussianInt // z.norm.natAbs = n} → {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)}
  | ⟨z, hz⟩ => ⟨(z.re, z.im), by
      have hnonneg : 0 ≤ z.norm := Zsqrtd.norm_nonneg (by norm_num) z
      have hcast : ((z.norm.natAbs : ℤ)) = z.norm := by
        rw [GaussianInt.abs_natCast_norm]
      change z.re ^ 2 + z.im ^ 2 = (n:ℤ)
      have hnorm : z.norm = (n:ℤ) := by
        rw [← hcast, hz]
      rw [Zsqrtd.norm_def] at hnorm
      linarith⟩

lemma gaussianToPair_pairToGaussian (n : ℕ) (p : {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)}) :
    gaussianToPair n (pairToGaussian n p) = p := by
  obtain ⟨⟨x, y⟩, h⟩ := p
  rfl

lemma pairToGaussian_gaussianToPair (n : ℕ) (z : {z : GaussianInt // z.norm.natAbs = n}) :
    pairToGaussian n (gaussianToPair n z) = z := by
  obtain ⟨⟨x, y⟩, hz⟩ := z
  rfl

def pairGaussianEquiv (n : ℕ) :
    {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} ≃ {z : GaussianInt // z.norm.natAbs = n} where
  toFun := pairToGaussian n
  invFun := gaussianToPair n
  left_inv := gaussianToPair_pairToGaussian n
  right_inv := pairToGaussian_gaussianToPair n

lemma r2_eq_natCard_pairs (n : ℕ) :
    r2 n = Nat.card {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := by
  let S : Finset (ℤ × ℤ) :=
    (Finset.Icc (-(n:ℤ)) (n:ℤ)).product (Finset.Icc (-(n:ℤ)) (n:ℤ))
  have hfin : ∀ p : ℤ × ℤ, p.1^2 + p.2^2 = (n:ℤ) → p ∈ S := by
    intro p hp
    dsimp only [S]
    refine Finset.mem_product.mpr ⟨?_, ?_⟩
    · rw [Finset.mem_Icc]
      constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
    · rw [Finset.mem_Icc]
      constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
  have hSfin : ({p : ℤ × ℤ | p ∈ S} : Set (ℤ × ℤ)).Finite := S.finite_toSet
  have hfinS : ({p : ℤ × ℤ | p.1^2 + p.2^2 = (n:ℤ)} : Set (ℤ × ℤ)).Finite :=
    hSfin.subset (fun p hp => hfin p hp)
  letI : Fintype {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := hfinS.fintype
  rw [Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype (S.filter (fun p => p.1^2 + p.2^2 = (n:ℤ))) (by
    intro p
    rw [Finset.mem_filter]
    constructor
    · intro hp; exact hp.2
    · intro hp; exact ⟨hfin p hp, hp⟩)]
  unfold r2
  dsimp [S]

/-- **T129:** `r2 n` is the number of Gaussian integers of norm `n`. -/
lemma r2_eq_natCard_gaussian (n : ℕ) :
    r2 n = Nat.card {z : GaussianInt // z.norm.natAbs = n} := by
  rw [r2_eq_natCard_pairs, Nat.card_congr (pairGaussianEquiv n)]


/-- **T130:** a norm-`n` Gaussian integer generates an ideal of norm `n`. -/
lemma absNorm_span_gaussian_of_norm (n : ℕ) (z : GaussianInt)
    (hz : z.norm.natAbs = n) : Ideal.absNorm (Ideal.span {z}) = n := by
  rw [absNorm_span_gaussian, hz]

/-- **T131:** two Gaussian integers generate the same principal ideal iff they
are associates. -/
lemma gaussian_span_eq_iff_associated (x y : GaussianInt) :
    Ideal.span ({x} : Set GaussianInt) = Ideal.span ({y} : Set GaussianInt) ↔
      Associated x y :=
  Ideal.span_singleton_eq_span_singleton


/-! ## Free unit action on norm-`n` Gaussian integers -/

abbrev NormElements (n : ℕ) := {z : GaussianInt // z.norm.natAbs = n}

def normElementsSmul (n : ℕ) (u : GaussianIntˣ) (z : NormElements n) : NormElements n :=
  ⟨(u : GaussianInt) * z.val, by
    rw [Zsqrtd.norm_mul, Int.natAbs_mul, gaussian_unit_norm_eq_one u, z.2]
    norm_num⟩

@[simp]
lemma normElementsSmul_def (n : ℕ) (u : GaussianIntˣ) (z : NormElements n) :
    (normElementsSmul n u z).val = (u : GaussianInt) * z.val := rfl

instance normElementsMulAction (n : ℕ) : MulAction GaussianIntˣ (NormElements n) where
  smul := normElementsSmul n
  one_smul z := by
    apply Subtype.ext
    change (normElementsSmul n 1 z).val = z.val
    rw [normElementsSmul_def]
    simp
  mul_smul u v z := by
    apply Subtype.ext
    change (normElementsSmul n (u * v) z).val = (normElementsSmul n u (normElementsSmul n v z)).val
    rw [normElementsSmul_def, normElementsSmul_def, normElementsSmul_def]
    simp [mul_assoc]

lemma normElements_ne_zero (n : ℕ) (hn : 0 < n) (z : NormElements n) :
    z.val ≠ 0 := by
  intro h
  have hz := z.2
  rw [h] at hz
  simp at hz
  omega

/-- **T132:** the Gaussian unit action on norm-`n` elements is free for `n > 0`. -/
lemma normElements_smul_eq_self_iff (n : ℕ) (hn : 0 < n) (u : GaussianIntˣ)
    (z : NormElements n) : u • z = z ↔ u = 1 := by
  constructor
  · intro h
    have hz : z.val ≠ 0 := normElements_ne_zero n hn z
    have hval : (u : GaussianInt) * z.val = z.val := by
      have := congr_arg Subtype.val h
      change (normElementsSmul n u z).val = z.val at this
      rwa [normElementsSmul_def] at this
    have h1 : (u : GaussianInt) * z.val = (1 : GaussianInt) * z.val := by
      simpa using hval
    have hu : (u : GaussianInt) = 1 := mul_right_cancel₀ hz h1
    exact Units.ext hu
  · intro h
    rw [h]
    exact one_smul _ _


/-! ## The 4-to-1 generator/ideal correspondence -/

instance gaussianUnitsFintype : Fintype GaussianIntˣ := by
  letI : Fintype {x : GaussianIntˣ // x ∈ gaussianUnits} :=
    Fintype.subtype gaussianUnits (fun x => Iff.rfl)
  exact Fintype.ofEquiv _ unitsEquivSubtype.symm

lemma gaussianUnits_fintype_card : Fintype.card GaussianIntˣ = 4 := by
  rw [← Nat.card_eq_fintype_card]
  exact gaussianUnits_card_four

def fintype_pairs_norm (n : ℕ) : Fintype {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := by
  let S : Finset (ℤ × ℤ) :=
    (Finset.Icc (-(n:ℤ)) (n:ℤ)).product (Finset.Icc (-(n:ℤ)) (n:ℤ))
  have hfin : ∀ p : ℤ × ℤ, p.1^2 + p.2^2 = (n:ℤ) → p ∈ S := by
    intro p hp
    dsimp only [S]
    refine Finset.mem_product.mpr ⟨?_, ?_⟩
    · rw [Finset.mem_Icc]; constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
    · rw [Finset.mem_Icc]; constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
  have hsub : {p : ℤ × ℤ | p.1^2 + p.2^2 = (n:ℤ)} ⊆ {p | p ∈ S} := fun p hp => hfin p hp
  exact Fintype.ofFinset (S.filter (fun p => p.1^2 + p.2^2 = (n:ℤ))) (by
    intro p
    rw [Finset.mem_filter]
    constructor
    · intro hp; exact hp.2
    · intro hp; exact ⟨hfin p hp, hp⟩)

def fintype_normElements (n : ℕ) : Fintype (NormElements n) :=
  letI : Fintype {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := fintype_pairs_norm n
  Fintype.ofEquiv _ (pairGaussianEquiv n)

/-- **T133:** Burnside count: `|NormElements n| = 4 * #orbits` for `n > 0`. -/
lemma normElements_card_eq_four_mul_orbits (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElements n) =
      4 * Nat.card (Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n))) := by
  letI : Fintype (NormElements n) := fintype_normElements n
  let Ω := Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n))
  letI : DecidableEq Ω := Classical.decEq Ω
  letI : Fintype Ω := Fintype.ofSurjective (Quotient.mk'' : NormElements n → Ω) Quotient.mk''_surjective
  have hburn := MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group
    GaussianIntˣ (NormElements n)
  have hsum : (∑ g : GaussianIntˣ, Fintype.card (MulAction.fixedBy (NormElements n) g)) =
      Fintype.card (NormElements n) := by
    rw [Finset.sum_eq_single (1 : GaussianIntˣ)]
    · refine Fintype.card_congr ?_
      refine ⟨fun x => x.val, fun x => ⟨x, ?_⟩, fun x => rfl, fun x => rfl⟩
      simp [MulAction.fixedBy]
    · intro g _ hg
      rw [Fintype.card_eq_zero_iff]
      refine ⟨fun x => ?_⟩
      exact hg ((normElements_smul_eq_self_iff n hn g x.val).mp x.2)
    · intro h
      simp at h
  rw [hsum, gaussianUnits_fintype_card] at hburn
  rw [Nat.card_eq_fintype_card, hburn]
  rw [Nat.card_eq_fintype_card]
  omega

def orbitToIdeal (n : ℕ) :
    Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n)) →
      {I : Ideal GaussianInt // Ideal.absNorm I = n} :=
  Quotient.lift
    (fun z : NormElements n => ⟨Ideal.span {z.val}, absNorm_span_gaussian_of_norm n z.val z.2⟩)
    (by
      intro z y hzy
      obtain ⟨g, hg⟩ := hzy
      have hval : z.val = (g : GaussianInt) * y.val := by
        have := congr_arg Subtype.val hg
        change (normElementsSmul n g y).val = z.val at this
        rw [normElementsSmul_def] at this
        exact this.symm
      have hAssoc : Associated y.val z.val := ⟨g, by rw [mul_comm, ← hval]⟩
      have hspan : Ideal.span {z.val} = Ideal.span {y.val} :=
        ((gaussian_span_eq_iff_associated y.val z.val).mpr hAssoc).symm
      exact Subtype.ext hspan)

def idealToOrbit (n : ℕ) :
    {I : Ideal GaussianInt // Ideal.absNorm I = n} →
      Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n)) :=
  fun I =>
    Quotient.mk'' ⟨Submodule.IsPrincipal.generator I.1, by
      letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
      have hspan : Ideal.span ({Submodule.IsPrincipal.generator I.1} : Set GaussianInt) = I.1 :=
        Ideal.span_singleton_generator I.1
      have h := I.2
      rw [← hspan] at h
      rw [absNorm_span_gaussian] at h
      exact h⟩

/-- **T134:** the orbit quotient of norm-`n` Gaussian integers is the set of ideals of norm `n`. -/
def orbitsEquivIdeals (n : ℕ) :
    Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n)) ≃
      {I : Ideal GaussianInt // Ideal.absNorm I = n} where
  toFun := orbitToIdeal n
  invFun := idealToOrbit n
  left_inv q := by
    induction q using Quotient.ind with
    | _ z =>
      apply Quotient.sound
      letI : (Ideal.span ({z.val} : Set GaussianInt)).IsPrincipal :=
        IsPrincipalIdealRing.principal _
      have hspan := Ideal.span_singleton_generator (Ideal.span ({z.val} : Set GaussianInt))
      have hassoc : Associated z.val (Submodule.IsPrincipal.generator
          (Ideal.span ({z.val} : Set GaussianInt))) := by
        rw [← gaussian_span_eq_iff_associated, hspan]
      obtain ⟨u, hu⟩ := hassoc
      have hI : orbitToIdeal n (Quotient.mk'' z) =
          ⟨Ideal.span {z.val}, absNorm_span_gaussian_of_norm n z.val z.2⟩ := by
        apply Subtype.ext
        rw [orbitToIdeal, Quotient.lift_mk]
      refine ⟨u, ?_⟩
      rw [hI]
      apply Subtype.ext
      simp only [Subtype.coe_mk]
      change (u : GaussianInt) * z.val =
        Submodule.IsPrincipal.generator (Ideal.span ({z.val} : Set GaussianInt))
      rw [mul_comm, hu]
  right_inv I := by
    apply Subtype.ext
    letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
    exact Ideal.span_singleton_generator I.1

/-- **T135:** the 4-to-1 generator/ideal count. -/
theorem normElements_card_eq_four_mul_idealCount (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElements n) =
      4 * Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} := by
  rw [normElements_card_eq_four_mul_orbits n hn]
  rw [Nat.card_congr (orbitsEquivIdeals n)]

/-- **T136:** `r2 n` is four times the number of ideals of norm `n`. -/
theorem r2_eq_four_mul_idealCount (n : ℕ) (hn : 0 < n) :
    r2 n = 4 * Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} := by
  rw [r2_eq_natCard_gaussian, normElements_card_eq_four_mul_idealCount n hn]



/-- Named arithmetic input: the number of ideals of norm `n` is `Σ_{d|n} χ₄(d)`. -/
def IdealCountFormula : Prop :=
  ∀ n : ℕ, 1 ≤ n →
    (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} : ℤ) = divisorSumChi4 n

/-- **T137:** the two-squares formula follows from the ideal-count formula. -/
theorem twoSquaresFormula_of_idealCount (h : IdealCountFormula) : TwoSquaresFormula := by
  intro n hn
  have h4 := r2_eq_four_mul_idealCount n (Nat.pos_of_ne_zero (by omega))
  rw [h4]
  push_cast
  have hc := h n hn
  rw [hc]


/-! ## Splitting of rational primes in `ℤ[i]` -/

lemma gaussian_star_mk (a b : ℤ) : star (⟨a, b⟩ : GaussianInt) = ⟨a, -b⟩ := by
  ext <;> simp

lemma gaussian_mul_star_mk (a b : ℤ) :
    (⟨a, b⟩ : GaussianInt) * star (⟨a, b⟩ : GaussianInt) = (⟨a^2 + b^2, 0⟩ : GaussianInt) := by
  rw [gaussian_star_mk]
  ext <;> simp <;> ring

lemma gaussian_norm_mk' (a b : ℤ) : (⟨a, b⟩ : GaussianInt).norm = a^2 + b^2 := by
  rw [Zsqrtd.norm_def]; ring

/-- **T138:** a prime `p ≡ 1 mod 4` splits as `π * star π` in `ℤ[i]`. -/
theorem gaussian_split_prime {p : ℕ} [Fact p.Prime] (hp4 : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧ π * star π = (p : GaussianInt) := by
  let hp : p.Prime := Fact.out
  letI : Fact p.Prime := ⟨hp⟩
  have hp3 : p % 4 ≠ 3 := by omega
  obtain ⟨a, b, hab⟩ := Nat.Prime.sq_add_sq (p := p) hp3
  refine ⟨⟨(a:ℤ), (b:ℤ)⟩, ?_, ?_⟩
  · apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : (⟨(a:ℤ), (b:ℤ)⟩ : GaussianInt).norm = 0 := by rw [h]; rfl
      rw [GaussianInt.norm_eq_zero] at hz
      -- contradiction with norm = p > 0
      have hnorm : (⟨(a:ℤ), (b:ℤ)⟩ : GaussianInt).norm = (p:ℤ) := by
        rw [gaussian_norm_mk']; exact_mod_cast hab
      rw [hz] at hnorm
      simp at hnorm
      have hpz : p = 0 := by exact_mod_cast hnorm.symm
      exact hp.ne_zero hpz
    · have hnorm : Ideal.absNorm (Ideal.span ({⟨(a:ℤ), (b:ℤ)⟩} : Set GaussianInt)) = p := by
        rw [absNorm_span_gaussian, gaussian_norm_mk']
        rw [show (a:ℤ)^2 + (b:ℤ)^2 = (p:ℤ) by exact_mod_cast hab]
        exact Int.natAbs_natCast p
      rw [hnorm]
      exact hp
  · rw [gaussian_mul_star_mk]
    have h : ((a:ℤ)^2 + (b:ℤ)^2) = (p:ℤ) := by exact_mod_cast hab
    ext <;> simp [h]

/-- **T139:** the principal ideal `(p)` factors as `(π)(star π)` for `p ≡ 1 mod 4`. -/
theorem gaussian_span_prime_factorization {p : ℕ} [Fact p.Prime] (hp4 : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧
      Ideal.span ({π} : Set GaussianInt) * Ideal.span ({star π} : Set GaussianInt) =
        Ideal.span ({(p : GaussianInt)} : Set GaussianInt) := by
  obtain ⟨π, hprime, hprod⟩ := gaussian_split_prime hp4
  exact ⟨π, hprime, by rw [Ideal.span_singleton_mul_span_singleton, hprod]⟩


/-! ## Inert and ramified primes in `ℤ[i]` -/

#check @GaussianInt.prime_iff_mod_four_eq_three_of_nat_prime
#check @Ideal.span_singleton_prime
#check @Ideal.absNorm_span_natCast
#check @Module.finrank_eq_card_basis
#check @Module.finrank_fin_fun

example : Module.finrank ℤ GaussianInt = 2 := by
  rw [Module.finrank_eq_card_basis gaussianBasis]
  simp

lemma gaussian_finrank : Module.finrank ℤ GaussianInt = 2 := by
  rw [Module.finrank_eq_card_basis gaussianBasis]
  simp

/-- **T140:** see the theorem statement. -/
lemma gaussian_absNorm_span_natCast (n : ℕ) :
    Ideal.absNorm (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) = n^2 := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  rw [Ideal.absNorm_span_natCast, gaussian_finrank]

/-- **T141:** see the theorem statement. -/
lemma gaussian_inert_prime {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) :
    Prime (p : GaussianInt) :=
  (GaussianInt.prime_iff_mod_four_eq_three_of_nat_prime p).mpr hp

def gaussianI : GaussianInt := ⟨0, 1⟩

lemma gaussianI_sq : gaussianI ^ 2 = (-1 : GaussianInt) := by
  decide

lemma gaussian_one_add_I_sq : (1 + gaussianI) ^ 2 = 2 * gaussianI := by
  decide

/-- **T142:** see the theorem statement. -/
lemma gaussian_prime_one_add_I : Prime (1 + gaussianI) := by
  apply Ideal.prime_of_irreducible_absNorm_span
  · intro h
    have := congr_arg Zsqrtd.re h
    simp [gaussianI] at this
  · have hnorm : Ideal.absNorm (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) = 2 := by
      rw [absNorm_span_gaussian, gaussian_norm_mk]
      norm_num [gaussianI]
    rw [hnorm]
    exact Nat.prime_two

/-- **T143:** see the theorem statement. -/
lemma gaussian_ramified_two :
    Ideal.span ({(2 : GaussianInt)} : Set GaussianInt) =
      Ideal.span ({(1 + gaussianI)} : Set GaussianInt) ^ 2 := by
  rw [pow_two, Ideal.span_singleton_mul_span_singleton, ← pow_two, gaussian_one_add_I_sq]
  rw [Ideal.span_singleton_eq_span_singleton]
  exact ⟨gaussianIUnit, by simp [gaussianIUnit, gaussianI]⟩


/-- **T144:** the ideal `(p)` is prime for inert `p ≡ 3 mod 4`. -/
lemma gaussian_inert_span_prime {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) :
    (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr (gaussian_inert_prime hp)
  intro h
  have hpz : (p : GaussianInt) = 0 := h
  have := congr_arg Zsqrtd.re hpz
  simp at this
  exact (Fact.out : p.Prime).ne_zero this

/-- **T145:** the ramified ideal `(1+i)` is prime. -/
lemma gaussian_ramified_span_prime :
    (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr gaussian_prime_one_add_I
  intro h
  have := congr_arg Zsqrtd.re h
  simp [gaussianI] at this


/-- **T146:** the unique maximal ideal above an inert prime `p ≡ 3 mod 4`. -/
lemma gaussian_inert_unique_prime {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3)
    (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) := by
  have hpP : (p : GaussianInt) ∈ P := by
    have hmem : (p : ℤ) ∈ P.under ℤ := by
      rw [hP]
      exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hle : Ideal.span ({(p : GaussianInt)} : Set GaussianInt) ≤ P :=
    Ideal.span_le.mpr (by simpa using hpP)
  have hmax : (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)).IsMaximal :=
    (gaussian_inert_span_prime hp).isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have hp0 : p = 0 := by exact_mod_cast h
      exact (Fact.out : p.Prime).ne_zero hp0)
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm


/-! ## Local ideal count: inert primes -/

/-- **T147:** every ideal of norm `p^(2e)` is `(p)^e` for inert `p`. -/
lemma gaussian_inert_ideal_eq_span_pow (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3)
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p ^ (2 * e)) :
    I = (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)) ^ e := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  induction e generalizing I with
  | zero =>
      simp only [Nat.mul_zero, pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ e ih =>
      have hp_dvd : p ∣ Ideal.absNorm I := by
        rw [hI]
        exact dvd_pow_self p (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I hp_dvd
      have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
        gaussian_inert_unique_prime hp P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, rfl⟩ := hPdvd
      have hnormP : Ideal.absNorm P = p ^ 2 := by
        rw [hP, gaussian_absNorm_span_natCast]
      rw [map_mul, hnormP] at hI
      have hJ : Ideal.absNorm J = p ^ (2 * e) := by
        have hpow : p ^ (2 * (e + 1)) = p ^ (2 * e) * p ^ 2 := by
          rw [show 2 * (e + 1) = 2 * e + 2 by omega, pow_add]
        rw [hpow] at hI
        exact Nat.mul_right_cancel (pow_pos (Fact.out : p.Prime).pos 2) hI
      have hJe := ih J hJ
      rw [hP, hJe, pow_succ]

/-- **T148:** the inert even-exponent local ideal count is one. -/
lemma gaussian_inert_ideal_count_even (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e)} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [gaussian_inert_ideal_eq_span_pow p e hp I I.2,
      gaussian_inert_ideal_eq_span_pow p e hp J J.2]
  · refine ⟨⟨(Ideal.span ({(p : GaussianInt)} : Set GaussianInt)) ^ e, ?_⟩⟩
    rw [map_pow, gaussian_absNorm_span_natCast]
    rw [← pow_mul]


/-- **T149:** there is no ideal of norm `p` for inert `p`. -/
lemma gaussian_inert_no_ideal_norm_prime (p : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p} = 0 := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  have : IsEmpty {I : Ideal GaussianInt // Ideal.absNorm I = p} := by
    refine ⟨fun I => ?_⟩
    have hI : Ideal.absNorm I.1 = p := I.2
    have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
    obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
      Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I.1 hp_dvd
    have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
      gaussian_inert_unique_prime hp P hPunder
    rw [dvd_iff_exists_eq_mul_left] at hPdvd
    obtain ⟨J, hIJ⟩ := hPdvd
    have hPnorm : Ideal.absNorm P = p ^ 2 := by
      rw [hP, gaussian_absNorm_span_natCast]
    have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
      rw [hIJ, map_mul, hPnorm]
      ring
    rw [hI] at hnorm
    have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
    have hle : p ^ 2 ≤ p := Nat.le_of_dvd (Fact.out : p.Prime).pos hdiv
    have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
    nlinarith
  exact Nat.card_of_isEmpty

/-- **T150:** there is no ideal of odd exponent norm for inert `p`. -/
lemma gaussian_inert_no_ideal_norm_odd (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    IsEmpty {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e + 1)} := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  induction e with
  | zero =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p := by simpa using I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I.1 hp_dvd
      have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
        gaussian_inert_unique_prime hp P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by
        rw [hP, gaussian_absNorm_span_natCast]
      have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]
        ring
      rw [hI] at hnorm
      have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
      have hle : p ^ 2 ≤ p := Nat.le_of_dvd (Fact.out : p.Prime).pos hdiv
      have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
      nlinarith
  | succ e ih =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p ^ (2 * (e + 1) + 1) := I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by
        rw [hI]
        exact dvd_pow_self p (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I.1 hp_dvd
      have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
        gaussian_inert_unique_prime hp P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by
        rw [hP, gaussian_absNorm_span_natCast]
      have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]
        ring
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = p ^ (2 * e + 1) := by
        have hpow : p ^ (2 * (e + 1) + 1) = p ^ (2 * e + 1) * p ^ 2 := by
          rw [show 2 * (e + 1) + 1 = 2 * e + 1 + 2 by omega, pow_add]
        rw [hpow] at hnorm
        rw [mul_comm (p ^ 2) (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (pow_pos (Fact.out : p.Prime).pos 2) hnorm).symm
      exact ih.false ⟨J, hJ⟩


/-- **T151:** the inert odd-exponent local ideal count is zero. -/
lemma gaussian_inert_ideal_count_odd (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e + 1)} = 0 := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  letI : IsEmpty {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e + 1)} :=
    gaussian_inert_no_ideal_norm_odd p e hp
  exact Nat.card_of_isEmpty


/-! ## Local ideal count: the ramified prime -/

/-- **T152:** the unique maximal ideal above `2` is `(1+i)`. -/
lemma gaussian_ramified_unique_prime (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(2 : ℤ)} : Set ℤ)) :
    P = Ideal.span ({(1 + gaussianI)} : Set GaussianInt) := by
  have h2P : (2 : GaussianInt) ∈ P := by
    have hmem : (2 : ℤ) ∈ P.under ℤ := by
      rw [hP]
      exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hsq : (1 + gaussianI) ^ 2 ∈ P := by
    rw [gaussian_one_add_I_sq]
    exact P.mul_mem_right gaussianI h2P
  have hprime : P.IsPrime := inferInstance
  have hmem : (1 + gaussianI) ∈ P := hprime.mem_of_pow_mem 2 hsq
  have hle : Ideal.span ({(1 + gaussianI)} : Set GaussianInt) ≤ P :=
    Ideal.span_le.mpr (by simpa using hmem)
  have hmax : (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)).IsMaximal :=
    gaussian_ramified_span_prime.isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have := congr_arg Zsqrtd.re h
      simp [gaussianI] at this)
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm

/-- **T153:** every ideal of norm `2^k` is `(1+i)^k`. -/
lemma gaussian_ramified_ideal_eq_span_pow (k : ℕ) (I : Ideal GaussianInt)
    (hI : Ideal.absNorm I = 2 ^ k) :
    I = (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) ^ k := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  induction k generalizing I with
  | zero =>
      simp only [pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ k ih =>
      have h2dvd : 2 ∣ Ideal.absNorm I := by
        rw [hI]
        exact dvd_pow_self 2 (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' Nat.prime_two I h2dvd
      have hP : P = Ideal.span ({(1 + gaussianI)} : Set GaussianInt) :=
        gaussian_ramified_unique_prime P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = 2 := by
        rw [hP, absNorm_span_gaussian, gaussian_norm_mk]
        norm_num [gaussianI]
      have hnorm : Ideal.absNorm I = 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm, mul_comm]
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = 2 ^ k := by
        have hpow : 2 ^ (k + 1) = 2 ^ k * 2 := by rw [pow_succ]
        rw [hpow] at hnorm
        rw [mul_comm 2 (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (by norm_num : 0 < 2) hnorm).symm
      have hJe := ih J hJ
      rw [hIJ, hP, hJe, pow_succ]

/-- **T154:** the ramified local ideal count is one. -/
lemma gaussian_ramified_ideal_count (k : ℕ) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = 2 ^ k} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [gaussian_ramified_ideal_eq_span_pow k I I.2,
      gaussian_ramified_ideal_eq_span_pow k J J.2]
  · refine ⟨⟨(Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) ^ k, ?_⟩⟩
    rw [map_pow]
    have hP : Ideal.absNorm (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) = 2 := by
      rw [absNorm_span_gaussian, gaussian_norm_mk]
      norm_num [gaussianI]
    rw [hP]


/-! ## Ideals divide their norm ideal -/

/-- **T155:** every ideal divides the principal ideal generated by its norm. -/
lemma gaussian_ideal_dvd_span_absNorm (I : Ideal GaussianInt) :
    I ∣ Ideal.span ({((Ideal.absNorm I : ℕ) : GaussianInt)} : Set GaussianInt) := by
  rw [Ideal.dvd_iff_le]
  exact Ideal.span_le.mpr (by simpa using Ideal.absNorm_mem I)

/-- **T156:** an ideal of norm `p^k` divides `(p)^k`. -/
lemma gaussian_ideal_dvd_span_pow_of_absNorm (p k : ℕ) (I : Ideal GaussianInt)
    (hI : Ideal.absNorm I = p ^ k) :
    I ∣ (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)) ^ k := by
  have h := gaussian_ideal_dvd_span_absNorm I
  rw [hI] at h
  rw [Ideal.span_singleton_pow]
  simpa [Nat.cast_pow] using h


/-- **T157:** a maximal ideal above a split prime `p` is `(π)` or `(star π)`. -/
lemma gaussian_split_maximal_eq {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    (π : GaussianInt) (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    P = Ideal.span ({π} : Set GaussianInt) ∨
      P = Ideal.span ({star π} : Set GaussianInt) := by
  have hpP : (p : GaussianInt) ∈ P := by
    have hmem : (p : ℤ) ∈ P.under ℤ := by
      rw [hP]
      exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hmem : π * star π ∈ P := by
    rw [hprod]
    exact hpP
  have hprime : P.IsPrime := inferInstance
  rcases hprime.mem_or_mem hmem with h | h
  · left
    have hle : Ideal.span ({π} : Set GaussianInt) ≤ P :=
      Ideal.span_le.mpr (by simpa using h)
    have hmax : (Ideal.span ({π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ.ne_zero).mpr hπ).isMaximal (by
        intro h
        rw [Ideal.span_singleton_eq_bot] at h
        exact hπ.ne_zero h)
    exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm
  · right
    have hle : Ideal.span ({star π} : Set GaussianInt) ≤ P :=
      Ideal.span_le.mpr (by simpa using h)
    have hmax : (Ideal.span ({star π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ'.ne_zero).mpr hπ').isMaximal (by
        intro h
        rw [Ideal.span_singleton_eq_bot] at h
        exact hπ'.ne_zero h)
    exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm


/-- **T158:** a Gaussian integer of prime norm is prime. -/
lemma gaussian_prime_of_norm_natAbs {p : ℕ} [Fact p.Prime] {z : GaussianInt}
    (hz : z.norm.natAbs = p) : Prime z := by
  apply Ideal.prime_of_irreducible_absNorm_span
  · intro h
    have hp0 : p = 0 := by
      rw [← hz, h]
      rfl
    exact (Fact.out : p.Prime).ne_zero hp0
  · have hnorm : Ideal.absNorm (Ideal.span ({z} : Set GaussianInt)) = p := by
      rw [absNorm_span_gaussian, hz]
    rw [hnorm]
    exact (Fact.out : p.Prime)

/-- **T159:** both `π` and `star π` are prime in the split factorization. -/
lemma gaussian_split_prime_star {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : GaussianInt) := by
  obtain ⟨π, hπ, hprod⟩ := gaussian_split_prime hp
  refine ⟨π, hπ, ?_, hprod⟩
  have hnorm_mul : π.norm * (star π).norm = (p : ℤ) ^ 2 := by
    rw [← Zsqrtd.norm_mul, hprod]
    rw [Zsqrtd.norm_def]
    simp
    ring
  rw [Zsqrtd.norm_conj] at hnorm_mul
  have hnonneg : 0 ≤ π.norm := Zsqrtd.norm_nonneg (by norm_num) π
  have hnorm : π.norm = (p : ℤ) := by nlinarith
  apply gaussian_prime_of_norm_natAbs (p := p)
  rw [Zsqrtd.norm_conj, hnorm]
  simp

/-- **T160:** unconditional classification of maximal ideals above a split prime. -/
lemma gaussian_split_maximal_eq' {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    ∃ π : GaussianInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : GaussianInt) ∧
      (P = Ideal.span ({π} : Set GaussianInt) ∨
        P = Ideal.span ({star π} : Set GaussianInt)) := by
  obtain ⟨π, hπ, hπ', hprod⟩ := gaussian_split_prime_star hp
  exact ⟨π, hπ, hπ', hprod, gaussian_split_maximal_eq hp π hπ hπ' hprod P hP⟩


/-- **T161:** the split factor `π` has norm `p`. -/
lemma gaussian_split_norm {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) : π.norm.natAbs = p := by
  have hnorm_mul : π.norm * (star π).norm = (p : ℤ) ^ 2 := by
    rw [← Zsqrtd.norm_mul, hprod]
    rw [Zsqrtd.norm_def]
    simp
    ring
  rw [Zsqrtd.norm_conj] at hnorm_mul
  have hnonneg : 0 ≤ π.norm := Zsqrtd.norm_nonneg (by norm_num) π
  have hnorm : π.norm = (p : ℤ) := by nlinarith
  rw [hnorm]
  simp

/-- **T162:** both split prime ideals have norm `p`. -/
lemma gaussian_split_span_norm {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) :
    Ideal.absNorm (Ideal.span ({π} : Set GaussianInt)) = p ∧
      Ideal.absNorm (Ideal.span ({star π} : Set GaussianInt)) = p := by
  constructor
  · rw [absNorm_span_gaussian, gaussian_split_norm hprod]
  · rw [absNorm_span_gaussian, Zsqrtd.norm_conj, gaussian_split_norm hprod]


/-- **T163:** the two split prime ideals are distinct. -/
lemma gaussian_split_span_ne {p : ℕ} [Fact p.Prime] {a b : ℤ}
    (hp : (p : ℤ) % 4 = 1) (ha : a ≠ 0) (hb : b ≠ 0)
    (hab : a ^ 2 + b ^ 2 = (p : ℤ)) :
    Ideal.span ({⟨a, b⟩} : Set GaussianInt) ≠
      Ideal.span ({star (⟨a, b⟩ : GaussianInt)} : Set GaussianInt) := by
  intro h
  have hassoc : Associated (⟨a, b⟩ : GaussianInt) (star (⟨a, b⟩ : GaussianInt)) :=
    (gaussian_span_eq_iff_associated _ _).mp h
  obtain ⟨u, hu⟩ := hassoc
  rcases gaussian_unit_classification u with h1 | h1 | h1 | h1
  · have hπ : (⟨a, b⟩ : GaussianInt) = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have him := congr_arg Zsqrtd.im hπ
    simp [Zsqrtd.star_mk] at him
    exact hb (by linarith)
  · have hπ : -(⟨a, b⟩ : GaussianInt) = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    simp [Zsqrtd.star_mk] at hre
    exact ha (by linarith)
  · have hπ : (⟨a, b⟩ : GaussianInt) * ⟨0, 1⟩ = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    have him := congr_arg Zsqrtd.im hπ
    simp [Zsqrtd.star_mk] at hre him
    have hab' : a = -b := by linarith
    have h2dvd : 2 ∣ (p : ℤ) := ⟨a ^ 2, by rw [← hab, hab']; ring⟩
    omega
  · have hπ : (⟨a, b⟩ : GaussianInt) * ⟨0, -1⟩ = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    have him := congr_arg Zsqrtd.im hπ
    simp [Zsqrtd.star_mk] at hre him
    have hab' : a = b := by linarith
    have h2dvd : 2 ∣ (p : ℤ) := ⟨a ^ 2, by rw [← hab, hab']; ring⟩
    omega

/-- **T164:** the split representation has both coordinates nonzero. -/
lemma gaussian_split_nonzero_data {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    ∃ a b : ℤ, a ≠ 0 ∧ b ≠ 0 ∧ a ^ 2 + b ^ 2 = (p : ℤ) := by
  have hp3 : p % 4 ≠ 3 := by omega
  obtain ⟨a, b, hab⟩ := Nat.Prime.sq_add_sq (p := p) hp3
  have hpp : Nat.Prime p := Fact.out
  have ha : (a : ℤ) ≠ 0 := by
    intro h
    have ha0 : a = 0 := by exact_mod_cast h
    have hp_sq : p = b ^ 2 := by
      rw [← hab]
      simp [ha0]
    have hdvd : b ∣ p := ⟨b, by rw [hp_sq]; ring⟩
    rcases hpp.eq_one_or_self_of_dvd b hdvd with hb1 | hbp
    · subst hb1
      have hp1 : p = 1 := by simpa using hp_sq
      exact hpp.ne_one hp1
    · subst hbp
      nlinarith [hpp.two_le]
  refine ⟨(a : ℤ), (b : ℤ), ha, ?_, ?_⟩
  · intro h
    have hb0 : b = 0 := by exact_mod_cast h
    have hp_sq : p = a ^ 2 := by
      rw [← hab]
      simp [hb0]
    have hdvd : a ∣ p := ⟨a, by rw [hp_sq]; ring⟩
    rcases hpp.eq_one_or_self_of_dvd a hdvd with ha1 | hap
    · subst ha1
      have hp1 : p = 1 := by simpa using hp_sq
      exact hpp.ne_one hp1
    · subst hap
      nlinarith [hpp.two_le]
  · exact_mod_cast hab

/-- **T165:** there is a split factorization with distinct prime ideals. -/
lemma gaussian_split_prime_star_ne {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : GaussianInt) ∧
      Ideal.span ({π} : Set GaussianInt) ≠
        Ideal.span ({star π} : Set GaussianInt) := by
  obtain ⟨a, b, ha, hb, hab⟩ := gaussian_split_nonzero_data hp
  let π : GaussianInt := ⟨a, b⟩
  have hπnorm : π.norm.natAbs = p := by
    rw [show π.norm = (p : ℤ) by rw [gaussian_norm_mk]; exact hab]
    simp
  have hπ : Prime π := gaussian_prime_of_norm_natAbs hπnorm
  have hπ' : Prime (star π) := by
    apply gaussian_prime_of_norm_natAbs (p := p)
    rw [Zsqrtd.norm_conj, hπnorm]
  have hprod : π * star π = (p : GaussianInt) := by
    rw [show π = ⟨a, b⟩ from rfl]
    rw [show star (⟨a, b⟩ : GaussianInt) = ⟨a, -b⟩ from Zsqrtd.star_mk a b]
    ext <;> simp
    all_goals first | nlinarith [hab] | ring
  have hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt) := by
    apply gaussian_split_span_ne (p := p)
    · exact_mod_cast hp
    · exact ha
    · exact hb
    · exact hab
  exact ⟨π, hπ, hπ', hprod, hne⟩


/-- **T166:** an ideal of prime norm is maximal. -/
lemma gaussian_isMaximal_of_absNorm_prime {p : ℕ} [Fact p.Prime]
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p) : I.IsMaximal := by
  have hprime : I.IsPrime := by
    apply Ideal.isPrime_of_irreducible_absNorm
    rw [hI]
    exact (Fact.out : p.Prime)
  have hne : I ≠ ⊥ := by
    intro h
    rw [h] at hI
    simp at hI
    exact (Fact.out : p.Prime).ne_zero hI.symm
  exact hprime.isMaximal hne

/-- **T167:** an ideal of norm `p` is `(π)` or `(star π)`. -/
lemma gaussian_split_ideal_eq_of_absNorm {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    (π : GaussianInt) (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p) :
    I = Ideal.span ({π} : Set GaussianInt) ∨
      I = Ideal.span ({star π} : Set GaussianInt) := by
  have hmax := gaussian_isMaximal_of_absNorm_prime I hI
  haveI : I.IsPrime := hmax.isPrime
  have hpI : (p : GaussianInt) ∈ I := by
    have := Ideal.absNorm_mem I
    rwa [hI] at this
  have hmem : π * star π ∈ I := by
    rw [hprod]
    exact hpI
  rcases (inferInstance : I.IsPrime).mem_or_mem hmem with h | h
  · left
    have hle : Ideal.span ({π} : Set GaussianInt) ≤ I :=
      Ideal.span_le.mpr (by simpa using h)
    have hPmax : (Ideal.span ({π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ.ne_zero).mpr hπ).isMaximal (by
        intro hbot
        rw [Ideal.span_singleton_eq_bot] at hbot
        exact hπ.ne_zero hbot)
    exact (hPmax.eq_of_le hmax.ne_top hle).symm
  · right
    have hle : Ideal.span ({star π} : Set GaussianInt) ≤ I :=
      Ideal.span_le.mpr (by simpa using h)
    have hQmax : (Ideal.span ({star π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ'.ne_zero).mpr hπ').isMaximal (by
        intro hbot
        rw [Ideal.span_singleton_eq_bot] at hbot
        exact hπ'.ne_zero hbot)
    exact (hQmax.eq_of_le hmax.ne_top hle).symm

/-- **T168:** there are exactly two ideals of norm `p` for split `p`. -/
lemma gaussian_split_ideal_count_one {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p} = 2 := by
  obtain ⟨π, hπ, hπ', hprod, hne⟩ := gaussian_split_prime_star_ne hp
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  have hP : Ideal.absNorm P = p := (gaussian_split_span_norm hprod).1
  have hQ : Ideal.absNorm Q = p := (gaussian_split_span_norm hprod).2
  let S : Finset (Ideal GaussianInt) := {P, Q}
  have hmem : ∀ I : {I : Ideal GaussianInt // Ideal.absNorm I = p}, I.1 ∈ S := by
    intro I
    rcases gaussian_split_ideal_eq_of_absNorm hp π hπ hπ' hprod I.1 I.2 with h | h
    · rw [h]; simp [S, P]
    · rw [h]; simp [S, Q]
  have hiff : ∀ I : Ideal GaussianInt, I ∈ S ↔ Ideal.absNorm I = p := by
    intro I
    constructor
    · intro h
      simp [S] at h
      rcases h with rfl | rfl
      · exact hP
      · exact hQ
    · intro h
      exact hmem ⟨I, h⟩
  letI : Fintype {I : Ideal GaussianInt // Ideal.absNorm I = p} :=
    Fintype.subtype S hiff
  rw [Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype S hiff]
  dsimp [S]
  exact Finset.card_pair_eq_two_iff.mpr hne


/-- **T169:** the norm of `(π)^a (star π)^b` is `p^(a+b)`. -/
lemma gaussian_split_pow_norm {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) (a b : ℕ) :
    Ideal.absNorm ((Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ b) = p ^ (a + b) := by
  rw [map_mul, map_pow, map_pow, (gaussian_split_span_norm hprod).1,
    (gaussian_split_span_norm hprod).2, ← pow_add]

/-- **T170:** the norm of `(π)^a (star π)^b` is `p^k` when `a+b=k`. -/
lemma gaussian_split_pow_norm_of_add {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) {a b k : ℕ} (h : a + b = k) :
    Ideal.absNorm ((Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ b) = p ^ k := by
  rw [gaussian_split_pow_norm hprod, h]


/-- **T171:** the two split prime ideals are coprime. -/
lemma gaussian_split_isCoprime {P Q : Ideal GaussianInt} [P.IsMaximal] [Q.IsMaximal]
    (hne : P ≠ Q) : IsCoprime P Q := by
  rw [Ideal.isCoprime_iff_sup_eq]
  by_contra h
  have h1 : P ⊔ Q = P := ((inferInstance : P.IsMaximal).eq_of_le h le_sup_left).symm
  have h2 : P ⊔ Q = Q := ((inferInstance : Q.IsMaximal).eq_of_le h le_sup_right).symm
  exact hne (h1.symm.trans h2)

/-- **T172:** powers of the two split prime ideals are coprime. -/
lemma gaussian_split_isCoprime_pow {P Q : Ideal GaussianInt} [P.IsMaximal] [Q.IsMaximal]
    (hne : P ≠ Q) (a b : ℕ) : IsCoprime (P ^ a) (Q ^ b) :=
  (gaussian_split_isCoprime hne).pow


/-- **T173:** distinct powers of the two split primes are unequal. -/
lemma gaussian_split_pow_ne {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt))
    (hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt))
    {k : ℕ} (hk : 0 < k) :
    (Ideal.span ({π} : Set GaussianInt)) ^ k ≠
      (Ideal.span ({star π} : Set GaussianInt)) ^ k := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  have hPnorm : Ideal.absNorm P = p := (gaussian_split_span_norm hprod).1
  have hQnorm : Ideal.absNorm Q = p := (gaussian_split_span_norm hprod).2
  have hPmax : P.IsMaximal := gaussian_isMaximal_of_absNorm_prime _ hPnorm
  have hQmax : Q.IsMaximal := gaussian_isMaximal_of_absNorm_prime _ hQnorm
  letI : P.IsMaximal := hPmax
  letI : Q.IsMaximal := hQmax
  intro h
  have hcop : IsCoprime (P ^ k) (Q ^ k) := gaussian_split_isCoprime_pow hne k k
  rw [h] at hcop
  have hunit : IsUnit (Q ^ k) := hcop.isUnit_of_dvd (dvd_refl _)
  have htop : Q ^ k = ⊤ := by
    rwa [Ideal.isUnit_iff] at hunit
  have hnorm : Ideal.absNorm (Q ^ k) = p ^ k := by
    rw [map_pow, hQnorm]
  have hone : p ^ k = 1 := by
    rw [← hnorm, htop, Ideal.absNorm_top]
  have hgt : 1 < p ^ k := Nat.one_lt_pow hk.ne' (Fact.out : p.Prime).one_lt
  omega


/-- **T174:** the `k+1` ideals `(π)^a (star π)^(k-a)` are distinct. -/
lemma gaussian_split_pow_inj {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt))
    (hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt))
    {a c k : ℕ} (ha : a ≤ k) (hc : c ≤ k)
    (h : (Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ (k - a) =
      (Ideal.span ({π} : Set GaussianInt)) ^ c *
        (Ideal.span ({star π} : Set GaussianInt)) ^ (k - c)) : a = c := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  have hPnorm : Ideal.absNorm P = p := (gaussian_split_span_norm hprod).1
  have hQnorm : Ideal.absNorm Q = p := (gaussian_split_span_norm hprod).2
  have hP0 : P ≠ 0 := by
    intro h
    rw [h] at hPnorm
    simp at hPnorm
    exact (Fact.out : p.Prime).ne_zero hPnorm.symm
  have hQ0 : Q ≠ 0 := by
    intro h
    rw [h] at hQnorm
    simp at hQnorm
    exact (Fact.out : p.Prime).ne_zero hQnorm.symm
  change P ^ a * Q ^ (k - a) = P ^ c * Q ^ (k - c) at h
  by_contra hne_ac
  rcases lt_or_gt_of_ne hne_ac with hac | hca
  · have hPc : P ^ c = P ^ a * P ^ (c - a) := by
      rw [← pow_add]
      congr 1
      omega
    have hQka : Q ^ (k - a) = Q ^ (k - c) * Q ^ (c - a) := by
      rw [← pow_add]
      congr 1
      omega
    rw [hPc, hQka] at h
    rw [mul_assoc] at h
    have h2 : Q ^ (k - c) * Q ^ (c - a) = P ^ (c - a) * Q ^ (k - c) :=
      mul_left_cancel₀ (pow_ne_zero a hP0) h
    rw [mul_comm (P ^ (c - a)) (Q ^ (k - c))] at h2
    have h3 : Q ^ (c - a) = P ^ (c - a) :=
      mul_left_cancel₀ (pow_ne_zero (k - c) hQ0) h2
    exact (gaussian_split_pow_ne hprod hne (Nat.sub_pos_of_lt hac)) h3.symm
  · have hPa : P ^ a = P ^ c * P ^ (a - c) := by
      rw [← pow_add]
      congr 1
      omega
    have hQkc : Q ^ (k - c) = Q ^ (k - a) * Q ^ (a - c) := by
      rw [← pow_add]
      congr 1
      omega
    rw [hPa, hQkc] at h
    rw [mul_assoc] at h
    have h2 : P ^ (a - c) * Q ^ (k - a) = Q ^ (k - a) * Q ^ (a - c) :=
      mul_left_cancel₀ (pow_ne_zero c hP0) h
    rw [mul_comm (P ^ (a - c)) (Q ^ (k - a))] at h2
    have h3 : P ^ (a - c) = Q ^ (a - c) :=
      mul_left_cancel₀ (pow_ne_zero (k - a) hQ0) h2
    exact (gaussian_split_pow_ne hprod hne (Nat.sub_pos_of_lt hca)) h3


/-- **T175:** the split local count follows from exhaustiveness. -/
lemma gaussian_split_ideal_count_of_exhaustive {p k : ℕ} [Fact p.Prime]
    {π : GaussianInt} (hprod : π * star π = (p : GaussianInt))
    (hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt))
    (hex : ∀ I : Ideal GaussianInt, Ideal.absNorm I = p ^ k →
      ∃ a : ℕ, a ≤ k ∧ I = (Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ (k - a)) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k} = k + 1 := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  let f : ℕ → Ideal GaussianInt := fun a => P ^ a * Q ^ (k - a)
  let S : Finset (Ideal GaussianInt) := (Finset.range (k + 1)).image f
  have hinj : Set.InjOn f (Finset.range (k + 1) : Set ℕ) := by
    intro a ha c hc h
    have ha' : a ≤ k := by simpa using ha
    have hc' : c ≤ k := by simpa using hc
    exact gaussian_split_pow_inj hprod hne ha' hc' h
  have hScard : S.card = k + 1 := by
    rw [show S = (Finset.range (k + 1)).image f from rfl]
    rw [Finset.card_image_of_injOn hinj, Finset.card_range]
  have hmem_norm : ∀ I ∈ S, Ideal.absNorm I = p ^ k := by
    intro I hI
    simp [S, f] at hI
    obtain ⟨a, ha, rfl⟩ := hI
    rw [gaussian_split_pow_norm_of_add hprod (by omega : a + (k - a) = k)]
  have hmem : ∀ I : {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k}, I.1 ∈ S := by
    intro I
    obtain ⟨a, ha, hIa⟩ := hex I.1 I.2
    rw [hIa]
    simp [S, f]
    exact ⟨a, by omega, rfl⟩
  have hiff : ∀ I : Ideal GaussianInt, I ∈ S ↔ Ideal.absNorm I = p ^ k := by
    intro I
    constructor
    · exact hmem_norm I
    · intro h
      exact hmem ⟨I, h⟩
  letI : Fintype {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k} :=
    Fintype.subtype S hiff
  rw [Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype S hiff]
  exact hScard


/-- **T176:** every norm-`p^(k+1)` ideal peels off `(π)` or `(star π)`. -/
lemma gaussian_split_peel {p k : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    {π : GaussianInt} (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p ^ (k + 1)) :
    ∃ M : Ideal GaussianInt, (M = Ideal.span ({π} : Set GaussianInt) ∨
        M = Ideal.span ({star π} : Set GaussianInt)) ∧
      ∃ J : Ideal GaussianInt, I = M * J ∧ Ideal.absNorm J = p ^ k := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  have hpdvd : p ∣ Ideal.absNorm I := by
    rw [hI]
    exact dvd_pow_self p (by omega)
  obtain ⟨M, hMmax, hMunder, hMdvd⟩ :=
    Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I hpdvd
  have hM : M = Ideal.span ({π} : Set GaussianInt) ∨
      M = Ideal.span ({star π} : Set GaussianInt) :=
    gaussian_split_maximal_eq hp π hπ hπ' hprod M hMunder
  rw [dvd_iff_exists_eq_mul_left] at hMdvd
  obtain ⟨J, hIJ⟩ := hMdvd
  have hIJ' : I = M * J := by rw [hIJ, mul_comm]
  refine ⟨M, hM, J, hIJ', ?_⟩
  have hMnorm : Ideal.absNorm M = p := by
    rcases hM with rfl | rfl
    · exact (gaussian_split_span_norm hprod).1
    · exact (gaussian_split_span_norm hprod).2
  have hnorm : Ideal.absNorm I = Ideal.absNorm M * Ideal.absNorm J := by
    rw [hIJ', map_mul]
  rw [hI, hMnorm] at hnorm
  have hpow : p ^ (k + 1) = p ^ k * p := by rw [pow_succ]
  rw [hpow, mul_comm (p ^ k) p] at hnorm
  exact (Nat.mul_left_cancel (Fact.out : p.Prime).pos hnorm).symm

/-- **T177:** every ideal of norm `p^k` is among the `k+1` candidates. -/
lemma gaussian_split_exhaustive {p k : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    {π : GaussianInt} (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p ^ k) :
    ∃ a : ℕ, a ≤ k ∧ I = (Ideal.span ({π} : Set GaussianInt)) ^ a *
      (Ideal.span ({star π} : Set GaussianInt)) ^ (k - a) := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  change Ideal.absNorm I = p ^ k at hI
  induction k generalizing I with
  | zero =>
      simp only [pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      refine ⟨0, le_rfl, ?_⟩
      rw [hI]
      simp [P, Q]
  | succ k ih =>
      obtain ⟨M, hM, J, hIJ, hJ⟩ := gaussian_split_peel hp hπ hπ' hprod I hI
      obtain ⟨a, ha, hJa⟩ := ih J hJ
      rcases hM with rfl | rfl
      · refine ⟨a + 1, by omega, ?_⟩
        rw [hIJ, hJa]
        change P * (P ^ a * Q ^ (k - a)) = P ^ (a + 1) * Q ^ (k + 1 - (a + 1))
        rw [← mul_assoc, ← pow_succ']
        rw [show k + 1 - (a + 1) = k - a by omega]
      · refine ⟨a, by omega, ?_⟩
        rw [hIJ, hJa]
        change Q * (P ^ a * Q ^ (k - a)) = P ^ a * Q ^ (k + 1 - a)
        rw [← mul_assoc, mul_comm Q (P ^ a), mul_assoc, ← pow_succ']
        rw [show k + 1 - a = k - a + 1 by omega]

/-- **T178:** the split local ideal count is `k+1`. -/
lemma gaussian_split_ideal_count (p k : ℕ) [Fact p.Prime] (hp : p % 4 = 1) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k} = k + 1 := by
  obtain ⟨π, hπ, hπ', hprod, hne⟩ := gaussian_split_prime_star_ne hp
  exact gaussian_split_ideal_count_of_exhaustive hprod hne
    (gaussian_split_exhaustive hp hπ hπ' hprod)


/-- **T179:** the principal ideals `(m)` and `(n)` are coprime for coprime `m, n`. -/
lemma gaussian_isCoprime_span_nat {m n : ℕ} (h : Nat.Coprime m n) :
    IsCoprime (Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) := by
  rw [Ideal.isCoprime_span_singleton_iff]
  exact (Nat.Coprime.isCoprime h).map (Int.castRingHom GaussianInt)


/-- **T180:** a divisor of `(a)(b)` decomposes as `(K⊔(a))(K⊔(b))` when `a, b` are coprime. -/
lemma gaussian_coprime_dvd_decompose {a b : GaussianInt} (hab : IsCoprime a b)
    {K : Ideal GaussianInt}
    (hK : K ∣ Ideal.span ({a} : Set GaussianInt) * Ideal.span ({b} : Set GaussianInt)) :
    K = (K ⊔ Ideal.span ({a} : Set GaussianInt)) *
      (K ⊔ Ideal.span ({b} : Set GaussianInt)) := by
  let I := Ideal.span ({a} : Set GaussianInt)
  let J := Ideal.span ({b} : Set GaussianInt)
  have hIJle : I * J ≤ K := Ideal.le_of_dvd hK
  have habK : a * b ∈ K := by
    apply hIJle
    rw [Ideal.span_singleton_mul_span_singleton]
    exact Ideal.subset_span (by simp)
  have hcop : IsCoprime I J := (Ideal.isCoprime_span_singleton_iff a b).mpr hab
  have hsup : (K ⊔ I) ⊔ (K ⊔ J) = ⊤ := by
    have h : (K ⊔ I) ⊔ (K ⊔ J) = (I ⊔ J) ⊔ K := by ac_rfl
    rw [h, Ideal.isCoprime_iff_sup_eq.mp hcop]
    simp
  have hinf : (K ⊔ I) ⊓ (K ⊔ J) = K := by
    apply le_antisymm ?_ (le_inf le_sup_left le_sup_left)
    intro z hz
    rw [Ideal.mem_inf] at hz
    obtain ⟨hzI, hzJ⟩ := hz
    rw [Submodule.mem_sup] at hzI hzJ
    obtain ⟨k1, hk1, i, hi, hik⟩ := hzI
    obtain ⟨k2, hk2, j, hj, hjk⟩ := hzJ
    obtain ⟨x, rfl⟩ := Ideal.mem_span_singleton.mp hi
    obtain ⟨y, rfl⟩ := Ideal.mem_span_singleton.mp hj
    obtain ⟨u, v, huv⟩ := hab
    have hz1 : z = k1 + a * x := hik.symm
    have hz2 : z = k2 + b * y := hjk.symm
    have hza : z * a ∈ K := by
      rw [hz2]
      have heq : (k2 + b * y) * a = k2 * a + (a * b) * y := by ring
      rw [heq]
      exact K.add_mem (K.mul_mem_right a hk2) (K.mul_mem_right y habK)
    have hzb : z * b ∈ K := by
      rw [hz1]
      have heq : (k1 + a * x) * b = k1 * b + (a * b) * x := by ring
      rw [heq]
      exact K.add_mem (K.mul_mem_right b hk1) (K.mul_mem_right x habK)
    have hz : z = u * (z * a) + v * (z * b) := by
      calc z = z * 1 := by ring
        _ = z * (u * a + v * b) := by rw [huv]
        _ = u * (z * a) + v * (z * b) := by ring
    rw [hz]
    exact K.add_mem (K.mul_mem_left u hza) (K.mul_mem_left v hzb)
  have hprod : (K ⊔ I) * (K ⊔ J) = (K ⊔ I) ⊓ (K ⊔ J) := by
    have := Ideal.sup_mul_inf (K ⊔ I) (K ⊔ J)
    rw [hsup, Ideal.top_mul] at this
    exact this.symm
  conv_lhs => rw [← hinf]
  rw [hprod]


/-- **T181:** `chi4Int` is multiplicative. -/
lemma chi4Int_mul (a b : ℤ) : chi4Int (a * b) = chi4Int a * chi4Int b := by
  unfold chi4Int
  simp only [Int.cast_mul]
  have h : ∀ x y : ZMod 4, ZMod.χ₄ (x * y) = ZMod.χ₄ x * ZMod.χ₄ y := by decide
  rw [h (a : ZMod 4) (b : ZMod 4)]
  push_cast
  ring


/-- **T182:** a divisor of a product of coprime ideals splits as `(K⊔I)(K⊔J)`. -/
lemma ideal_coprime_dvd_decompose {I J K : Ideal GaussianInt} (hIJ : IsCoprime I J)
    (hK : K ∣ I * J) : K = (K ⊔ I) * (K ⊔ J) := by
  have hIJle : I * J ≤ K := Ideal.le_of_dvd hK
  obtain ⟨i, hi, j, hj, hij⟩ := hIJ.exists
  have hsup : (K ⊔ I) ⊔ (K ⊔ J) = ⊤ := by
    have h : (K ⊔ I) ⊔ (K ⊔ J) = (I ⊔ J) ⊔ K := by ac_rfl
    rw [h, Ideal.isCoprime_iff_sup_eq.mp hIJ]
    simp
  have hinf : (K ⊔ I) ⊓ (K ⊔ J) = K := by
    apply le_antisymm ?_ (le_inf le_sup_left le_sup_left)
    intro z hz
    rw [Ideal.mem_inf] at hz
    obtain ⟨hzI, hzJ⟩ := hz
    rw [Submodule.mem_sup] at hzI hzJ
    obtain ⟨k1, hk1, i1, hi1, hik⟩ := hzI
    obtain ⟨k2, hk2, j2, hj2, hjk⟩ := hzJ
    have hz1 : z = k1 + i1 := hik.symm
    have hz2 : z = k2 + j2 := hjk.symm
    have hzi : z * i ∈ K := by
      rw [hz2, add_mul]
      have hmul : j2 * i ∈ I * J := by
        rw [mul_comm j2 i]
        exact Ideal.mul_mem_mul hi hj2
      exact K.add_mem (K.mul_mem_right i hk2) (hIJle hmul)
    have hzj : z * j ∈ K := by
      rw [hz1, add_mul]
      exact K.add_mem (K.mul_mem_right j hk1) (hIJle (Ideal.mul_mem_mul hi1 hj))
    have hz : z = z * i + z * j := by
      rw [← mul_add, hij, mul_one]
    rw [hz]
    exact K.add_mem hzi hzj
  have hprod : (K ⊔ I) * (K ⊔ J) = (K ⊔ I) ⊓ (K ⊔ J) := by
    have := Ideal.sup_mul_inf (K ⊔ I) (K ⊔ J)
    rw [hsup, Ideal.top_mul] at this
    exact this.symm
  conv_lhs => rw [← hinf]
  rw [hprod]


/-- **T183:** for `p ≡ 1 mod 4`, `Σ_{j=0}^{k} χ₄(p^j) = k+1`. -/
lemma divisorSumChi4_prime_pow_one {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) (k : ℕ) :
    divisorSumChi4 (p ^ k) = (k + 1 : ℤ) := by
  change (∑ d ∈ (p ^ k).divisors, ZMod.χ₄ (d : ZMod 4)) = (k + 1 : ℤ)
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1), ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) = 1 := by
    intro j hj
    apply ZMod.χ₄_nat_one_mod_four
    rw [Nat.pow_mod, hp]
    simp
  rw [Finset.sum_congr rfl h]
  simp


/-- **T184:** the raw `χ₄` is multiplicative on `ℤ`. -/
lemma chi4_mul (a b : ℤ) : ZMod.χ₄ (a * b) = ZMod.χ₄ a * ZMod.χ₄ b := by
  apply Int.cast_injective (α := ℂ)
  simpa [chi4Int] using chi4Int_mul a b

/-- **T185:** `χ₄(p^j) = (-1)^j` for `p ≡ 3 mod 4`. -/
lemma chi4_pow_three {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) (j : ℕ) :
    ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) = (-1 : ℤ) ^ j := by
  induction j with
  | zero => simp
  | succ j ih =>
      have hcast : ((p ^ (j + 1) : ℕ) : ZMod 4) = ((p ^ j : ℕ) : ZMod 4) * (p : ZMod 4) := by
        rw [pow_succ, Nat.cast_mul]
      rw [hcast]
      have hmul : ZMod.χ₄ (((p ^ j : ℕ) : ZMod 4) * (p : ZMod 4)) =
          ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) * ZMod.χ₄ (p : ZMod 4) := by
        simpa using chi4_mul ((p ^ j : ℕ) : ℤ) (p : ℤ)
      rw [hmul, ih]
      have hpval : ZMod.χ₄ (p : ZMod 4) = (-1 : ℤ) := by
        have hp2 : p % 2 = 1 := by omega
        rw [ZMod.χ₄_nat_eq_if_mod_four]
        simp [hp, hp2]
      rw [hpval]
      ring

/-- **T186:** for `p ≡ 3 mod 4`, the divisor sum is `1` for even `k` and `0` for odd `k`. -/
lemma divisorSumChi4_prime_pow_three {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) (k : ℕ) :
    divisorSumChi4 (p ^ k) = if Even k then 1 else 0 := by
  change (∑ d ∈ (p ^ k).divisors, ZMod.χ₄ (d : ZMod 4)) = if Even k then 1 else 0
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1),
      ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) = (-1 : ℤ) ^ j := by
    intro j hj
    exact chi4_pow_three hp j
  rw [Finset.sum_congr rfl h]
  rw [← Fin.sum_univ_eq_sum_range (fun j => (-1 : ℤ) ^ j) (k + 1)]
  rw [Fin.sum_neg_one_pow]
  by_cases hk : Even k <;> simp [Nat.even_add_one, hk]


/-- **T187:** the ramified divisor sum `Σ_{j=0}^{k} χ₄(2^j)` is `1`. -/
lemma divisorSumChi4_prime_pow_two (k : ℕ) :
    divisorSumChi4 (2 ^ k) = 1 := by
  change (∑ d ∈ (2 ^ k).divisors, ZMod.χ₄ ((d : ℕ) : ZMod 4)) = (1 : ℤ)
  rw [Nat.sum_divisors_prime_pow Nat.prime_two]
  rw [Finset.sum_eq_single 0]
  · simp
  · intro j hj hj0
    have hj1 : 1 ≤ j := by omega
    rw [ZMod.χ₄_nat_eq_if_mod_four]
    have hmod : (2 ^ j) % 2 = 0 := by
      rw [Nat.pow_mod]
      simp [hj0]
    simp [hmod]
  · intro h
    simp at h


/-- **T188:** `divisorSumChi4` is multiplicative over coprime `m, n`. -/
lemma divisorSumChi4_mul {m n : ℕ} (hmn : Nat.Coprime m n) :
    divisorSumChi4 (m * n) = divisorSumChi4 m * divisorSumChi4 n := by
  unfold divisorSumChi4
  rw [hmn.divisors_mul]
  rw [Finset.sum_map]
  let f : ℕ × ℕ → ℤ := fun q => ZMod.χ₄ (((q.1 * q.2 : ℕ)) : ZMod 4)
  change (∑ p ∈ (m.divisors ×ˢ n.divisors).attach, f ↑p) = _
  rw [Finset.sum_attach]
  rw [Finset.sum_product]
  have h : ∀ x ∈ m.divisors, ∀ y ∈ n.divisors,
      ZMod.χ₄ ((x * y : ℕ) : ZMod 4) =
        ZMod.χ₄ (x : ZMod 4) * ZMod.χ₄ (y : ZMod 4) := by
    intro x hx y hy
    simpa using chi4_mul (x : ℤ) (y : ℤ)
  calc (∑ x ∈ m.divisors, ∑ y ∈ n.divisors, ZMod.χ₄ ((x * y : ℕ) : ZMod 4))
      = ∑ x ∈ m.divisors, (ZMod.χ₄ (x : ZMod 4) *
          ∑ y ∈ n.divisors, ZMod.χ₄ (y : ZMod 4)) := by
        apply Finset.sum_congr rfl
        intro x hx
        rw [Finset.sum_congr rfl (fun y hy => h x hx y hy), Finset.mul_sum]
    _ = (∑ x ∈ m.divisors, ZMod.χ₄ (x : ZMod 4)) *
          (∑ y ∈ n.divisors, ZMod.χ₄ (y : ZMod 4)) := by
        rw [Finset.sum_mul]

/-- **T189:** if `a ∣ m²`, `b ∣ n²`, `ab = mn` and `m, n` are coprime, then `a = m`, `b = n`. -/
lemma nat_eq_of_dvd_sq_mul {a b m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) (ha : a ∣ m ^ 2) (hb : b ∣ n ^ 2)
    (hab : a * b = m * n) : a = m ∧ b = n := by
  have hmb : Nat.Coprime m b := (hcop.pow_right 2).of_dvd_right hb
  have hma : m ∣ a := by
    have : m ∣ a * b := by rw [hab]; exact dvd_mul_right m n
    exact hmb.dvd_of_dvd_mul_right this
  have hna : Nat.Coprime n a := by
    have hnm : Nat.Coprime n (m ^ 2) := hcop.symm.pow_right 2
    exact hnm.of_dvd_right ha
  have hnb : n ∣ b := by
    have : n ∣ a * b := by rw [hab]; exact dvd_mul_left n m
    exact hna.dvd_of_dvd_mul_left this
  obtain ⟨c, rfl⟩ := hma
  obtain ⟨d, rfl⟩ := hnb
  have hmul : m * n * (c * d) = m * n * 1 := by
    calc m * n * (c * d) = m * c * (n * d) := by ring
      _ = m * n := hab
      _ = m * n * 1 := by ring
  have hmn : 0 < m * n := Nat.mul_pos (Nat.pos_of_ne_zero hm) (Nat.pos_of_ne_zero hn)
  have hcd : c * d = 1 := Nat.mul_left_cancel hmn hmul
  have hc : c = 1 := Nat.eq_one_of_mul_eq_one_right hcd
  have hd : d = 1 := Nat.eq_one_of_mul_eq_one_left hcd
  constructor <;> simp [hc, hd]

/-- **T190:** for ideals of coprime norms `m, n`, `(K1 K2) ⊔ (m) = K1`. -/
lemma gaussian_sup_mul_span_eq {K1 K2 : Ideal GaussianInt} {m n : ℕ}
    (hK1 : Ideal.absNorm K1 = m) (hK2 : Ideal.absNorm K2 = n)
    (hcop : Nat.Coprime m n) :
    (K1 * K2) ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) = K1 := by
  have hspan_m : K1 ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) := by
    rw [← hK1]
    exact gaussian_ideal_dvd_span_absNorm K1
  have hspan_n : K2 ∣ Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
    rw [← hK2]
    exact gaussian_ideal_dvd_span_absNorm K2
  have hcop_span : IsCoprime (Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) :=
    gaussian_isCoprime_span_nat hcop
  have hcop_K1K2 : IsCoprime K1 K2 :=
    (hcop_span.of_isCoprime_of_dvd_left hspan_m).of_isCoprime_of_dvd_right hspan_n
  rw [dvd_iff_exists_eq_mul_left] at hspan_m
  obtain ⟨J, hJ⟩ := hspan_m
  have hJ' : Ideal.span ({(m : GaussianInt)} : Set GaussianInt) = K1 * J := by
    rw [hJ, mul_comm]
  have hJdvd : J ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) :=
    ⟨K1, by rw [hJ', mul_comm]⟩
  have hcop_K2_m : IsCoprime K2 (Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) :=
    (hcop_span.of_isCoprime_of_dvd_right hspan_n).symm
  have hcop_K2_J : IsCoprime K2 J := hcop_K2_m.of_isCoprime_of_dvd_right hJdvd
  have hsup : K2 ⊔ J = ⊤ := Ideal.isCoprime_iff_sup_eq.mp hcop_K2_J
  calc (K1 * K2) ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)
      = (K1 * K2) ⊔ (K1 * J) := by rw [hJ']
    _ = K1 * (K2 ⊔ J) := by rw [Ideal.mul_sup]
    _ = K1 * ⊤ := by rw [hsup]
    _ = K1 := by rw [Ideal.mul_top]


/-- **T191:** the left component of an ideal of norm `mn` has norm `m`. -/
lemma gaussian_sup_span_absNorm_left {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) (K : Ideal GaussianInt)
    (hK : Ideal.absNorm K = m * n) :
    Ideal.absNorm (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) = m := by
  have hKdvd : K ∣ Ideal.span ({((m * n : ℕ) : GaussianInt)} : Set GaussianInt) := by
    rw [← hK]
    exact gaussian_ideal_dvd_span_absNorm K
  have hspan : Ideal.span ({((m * n : ℕ) : GaussianInt)} : Set GaussianInt) =
      Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
        Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
    rw [Ideal.span_singleton_mul_span_singleton, Nat.cast_mul]
  have hKdvd' : K ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
      Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
    rwa [← hspan]
  have hcop_span : IsCoprime (Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) :=
    gaussian_isCoprime_span_nat hcop
  have hdecomp := ideal_coprime_dvd_decompose hcop_span hKdvd'
  have h1dvd : (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) ∣
      Ideal.span ({(m : GaussianInt)} : Set GaussianInt) :=
    Ideal.dvd_iff_le.mpr le_sup_right
  have h2dvd : (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) ∣
      Ideal.span ({(n : GaussianInt)} : Set GaussianInt) :=
    Ideal.dvd_iff_le.mpr le_sup_right
  have h1 : Ideal.absNorm (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) ∣ m ^ 2 := by
    have := Ideal.absNorm_dvd_absNorm_of_le (I := K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (J := Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) le_sup_right
    rwa [gaussian_absNorm_span_natCast] at this
  have h2 : Ideal.absNorm (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) ∣ n ^ 2 := by
    have := Ideal.absNorm_dvd_absNorm_of_le (I := K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt))
      (J := Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) le_sup_right
    rwa [gaussian_absNorm_span_natCast] at this
  have hprod : Ideal.absNorm (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) *
      Ideal.absNorm (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) = m * n := by
    have hK' : Ideal.absNorm ((K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) *
        (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt))) = m * n := by
      conv_lhs => rw [← hdecomp]
      rw [hK]
    rwa [map_mul] at hK'
  exact (nat_eq_of_dvd_sq_mul hm hn hcop h1 h2 hprod).1

/-- **T192:** the right component of an ideal of norm `mn` has norm `n`. -/
lemma gaussian_sup_span_absNorm_right {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) (K : Ideal GaussianInt)
    (hK : Ideal.absNorm K = m * n) :
    Ideal.absNorm (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) = n := by
  have h := gaussian_sup_span_absNorm_left hn hm hcop.symm K (by rwa [mul_comm] at hK)
  simpa [mul_comm] using h

/-- **T193:** the ideal-count product equivalence. -/
noncomputable def gaussianIdealCountEquiv (m n : ℕ) (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) :
    {I : Ideal GaussianInt // Ideal.absNorm I = m * n} ≃
      {I : Ideal GaussianInt // Ideal.absNorm I = m} ×
        {I : Ideal GaussianInt // Ideal.absNorm I = n} where
  toFun I :=
    (⟨I.1 ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt),
        gaussian_sup_span_absNorm_left hm hn hcop I.1 I.2⟩,
      ⟨I.1 ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt),
        gaussian_sup_span_absNorm_right hm hn hcop I.1 I.2⟩)
  invFun p :=
    ⟨p.1.1 * p.2.1, by rw [map_mul, p.1.2, p.2.2]⟩
  left_inv I := by
    apply Subtype.ext
    have hKdvd : I.1 ∣ Ideal.span ({((Ideal.absNorm I.1 : ℕ) : GaussianInt)} : Set GaussianInt) :=
      gaussian_ideal_dvd_span_absNorm I.1
    rw [I.2] at hKdvd
    have hspan : Ideal.span ({((m * n : ℕ) : GaussianInt)} : Set GaussianInt) =
        Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
          Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
      rw [Ideal.span_singleton_mul_span_singleton, Nat.cast_mul]
    have hKdvd' : I.1 ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
        Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
      rwa [← hspan]
    exact (ideal_coprime_dvd_decompose (gaussian_isCoprime_span_nat hcop) hKdvd').symm
  right_inv p := by
    apply Prod.ext
    · apply Subtype.ext
      exact gaussian_sup_mul_span_eq p.1.2 p.2.2 hcop
    · apply Subtype.ext
      have h := gaussian_sup_mul_span_eq (m := n) (n := m) p.2.2 p.1.2 hcop.symm
      simpa [mul_comm] using h

/-- **T194:** the ideal count is multiplicative over coprime `m, n`. -/
theorem gaussian_idealCount_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m * n} =
      Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m} *
        Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} := by
  rw [Nat.card_congr (gaussianIdealCountEquiv m n hm hn hcop), Nat.card_prod]


/-- **T195:** the ideal count as an arithmetic function. -/
def idealCount (n : ℕ) : ℕ := Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n}

/-- `idealCount 1 = 1`. -/
lemma idealCount_one : idealCount 1 = 1 := by
  unfold idealCount
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [Ideal.absNorm_eq_one_iff.mp I.2, Ideal.absNorm_eq_one_iff.mp J.2]
  · exact ⟨⟨⊤, by rw [Ideal.absNorm_top]⟩⟩

/-- The ideal count packaged as an `ArithmeticFunction ℤ`. -/
def idealCountFun : ArithmeticFunction ℤ where
  toFun n := if n = 0 then 0 else (idealCount n : ℤ)
  map_zero' := by simp

/-- **T195:** the packaged ideal count is multiplicative. -/
lemma idealCountFun_isMultiplicative : idealCountFun.IsMultiplicative := by
  constructor
  · simp [idealCountFun, idealCount_one]
  · intro m n hcop
    by_cases hm : m = 0
    · subst hm
      simp [idealCountFun]
    · by_cases hn : n = 0
      · subst hn
        simp [idealCountFun]
      · have hmn : m * n ≠ 0 := Nat.mul_ne_zero hm hn
        simp only [idealCountFun, ArithmeticFunction.coe_mk, idealCount, hm, hn, hmn, if_false]
        change (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m * n} : ℤ) =
          (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m} : ℤ) *
            (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} : ℤ)
        rw [gaussian_idealCount_mul hm hn hcop]
        push_cast
        ring

/-- The divisor sum packaged as an `ArithmeticFunction ℤ`. -/
def divisorSumFun : ArithmeticFunction ℤ where
  toFun := divisorSumChi4
  map_zero' := by
    simp [divisorSumChi4]

/-- **T196:** the packaged divisor sum is multiplicative. -/
lemma divisorSumFun_isMultiplicative : divisorSumFun.IsMultiplicative := by
  constructor
  · simp [divisorSumFun, divisorSumChi4]
  · intro m n hcop
    simpa [divisorSumFun] using divisorSumChi4_mul hcop


/-- **T197:** the ideal count and divisor sum agree on prime powers. -/
lemma idealCount_prime_pow_eq (p i : ℕ) (hp : p.Prime) :
    idealCountFun (p ^ i) = divisorSumFun (p ^ i) := by
  have hpi : p ^ i ≠ 0 := pow_ne_zero i hp.ne_zero
  simp only [idealCountFun, divisorSumFun, ArithmeticFunction.coe_mk, hpi, if_false,
    idealCount]
  rcases hp.eq_two_or_odd with rfl | hodd
  · rw [gaussian_ramified_ideal_count i, divisorSumChi4_prime_pow_two i]
    norm_num
  · letI : Fact p.Prime := ⟨hp⟩
    have h4 : p % 4 = 1 ∨ p % 4 = 3 := by omega
    rcases h4 with h1 | h3
    · have hI : Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ i} = i + 1 :=
        gaussian_split_ideal_count p i h1
      have hD : divisorSumChi4 (p ^ i) = (i + 1 : ℤ) :=
        divisorSumChi4_prime_pow_one h1 i
      rw [hI, hD]
      norm_num
    · have hI : Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ i} =
          if Even i then 1 else 0 := by
        by_cases hi : Even i
        · obtain ⟨k, hk⟩ := hi
          rw [hk, show k + k = 2 * k by ring, gaussian_inert_ideal_count_even p k h3]
          simp
        · rw [Nat.not_even_iff_odd] at hi
          obtain ⟨k, hk⟩ := hi
          rw [hk, gaussian_inert_ideal_count_odd p k h3]
          simp
      have hD : divisorSumChi4 (p ^ i) = if Even i then 1 else 0 :=
        divisorSumChi4_prime_pow_three h3 i
      rw [hI, hD]
      split_ifs <;> norm_num

/-- **T198:** the ideal-count formula. -/
theorem idealCountFormula : IdealCountFormula := by
  have hfun : idealCountFun = divisorSumFun :=
    (ArithmeticFunction.IsMultiplicative.eq_iff_eq_on_prime_powers idealCountFun
      idealCountFun_isMultiplicative divisorSumFun
      divisorSumFun_isMultiplicative).mpr
      (fun p i hp => idealCount_prime_pow_eq p i hp)
  intro n hn
  have hn0 : n ≠ 0 := by omega
  have h := congrArg (fun f : ArithmeticFunction ℤ => f n) hfun
  simpa [idealCountFun, idealCount, divisorSumFun, ArithmeticFunction.coe_mk, hn0,
    if_false] using h

/-- **T199:** the two-squares formula. -/
theorem twoSquaresFormula : TwoSquaresFormula :=
  twoSquaresFormula_of_idealCount idealCountFormula

/-- **T122:** the Epstein/L-series reduction. -/
theorem epstein_series_eq_four_zeta_beta
    (s : ℂ) (hs : 1 < s.re) :
    LSeries (fun n : ℕ => (r2 n : ℂ)) s = 4 * riemannZeta s * betaSeries s := by
  have hcoef : ∀ {n : ℕ}, n ≠ 0 → (r2 n : ℂ) = 4 * (divisorSumChi4 n : ℂ) := by
    intro n hn
    have hn1 : 1 ≤ n := Nat.pos_of_ne_zero hn
    have this := twoSquaresFormula n hn1
    norm_cast
  rw [LSeries_congr hcoef s]
  have hlin : LSeries (fun n : ℕ => 4 * (divisorSumChi4 n : ℂ)) s
      = 4 * LSeries (fun n : ℕ => (divisorSumChi4 n : ℂ)) s := by
    simp only [LSeries]
    rw [show (fun n => LSeries.term (fun n => 4 * (divisorSumChi4 n : ℂ)) s n)
        = fun n => 4 * LSeries.term (fun n => (divisorSumChi4 n : ℂ)) s n by
      funext n
      by_cases hn : n = 0
      · simp [LSeries.term_def, hn]
      · simp [LSeries.term_def, hn]
        ring]
    rw [tsum_mul_left]
  rw [hlin, LSeries_divisorSumChi4 s hs]
  ring


/-- **T123:** the completed ℤ² series is `π^(−s)Γ(s)` times the Epstein
lattice series. -/
theorem LambdaZ2_eq_epstein (s : ℂ) (hs : 1 < s.re) :
    LambdaZ2 s = ((Real.pi : ℝ) : ℂ)^(-s) * Complex.Gamma s *
      LSeries (fun n : ℕ => (r2 n : ℂ)) s := by
  rw [lambdaZ2_product s hs, epstein_series_eq_four_zeta_beta s hs]
  ring




/-- **T205:** the real Gamma function has residue `1` at `0`. -/
lemma Real.tendsto_self_mul_Gamma_nhds_zero :
    Filter.Tendsto (fun x : ℝ => x * Real.Gamma x) (𝓝[≠] (0 : ℝ)) (𝓝 1) := by
  have hmap : Filter.Tendsto (fun x : ℝ => (x : ℂ)) (𝓝[≠] (0 : ℝ)) (𝓝[≠] (0 : ℂ)) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · exact (Complex.continuous_ofReal.tendsto 0).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with x hx
      simpa using hx
  have h := Complex.tendsto_self_mul_Gamma_nhds_zero.comp hmap
  have hreal : Filter.Tendsto (fun x : ℝ => ((x * Real.Gamma x : ℝ) : ℂ)) (𝓝[≠] (0 : ℝ)) (𝓝 (1 : ℂ)) := by
    convert h using 1
    · funext x
      simp [Complex.Gamma_ofReal, Complex.ofReal_mul]
  exact (Filter.tendsto_ofReal_iff).mp hreal

/-- **T206:** `‖Γ(x)‖ → ∞` as `x → −1` from the right. -/
lemma tendsto_norm_Gamma_nhdsGT_neg_one :
    Filter.Tendsto (fun x : ℝ => ‖Real.Gamma x‖) (𝓝[>] (-1)) Filter.atTop := by
  have hshift : Filter.Tendsto (fun x : ℝ => x + 1) (𝓝[>] (-1)) (𝓝[>] (0 : ℝ)) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · simpa using ((continuous_add_const (1 : ℝ)).tendsto (-1)).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with x hx
      have hx' : -1 < x := hx
      change 0 < x + 1
      linarith
  have hres : Filter.Tendsto (fun y : ℝ => y * Real.Gamma y) (𝓝[>] (0 : ℝ)) (𝓝 1) :=
    Real.tendsto_self_mul_Gamma_nhds_zero.mono_left (nhdsGT_le_nhdsNE 0)
  have hcomp := hres.comp hshift
  have hxpos : ∀ᶠ x : ℝ in 𝓝[>] (-1), 0 < x + 1 := by
    filter_upwards [self_mem_nhdsWithin] with x hx
    have hx' : -1 < x := hx
    linarith
  have hxneg : ∀ᶠ x : ℝ in 𝓝[>] (-1), x < 0 :=
    (eventually_lt_nhds (by norm_num : (-1 : ℝ) < 0)).filter_mono nhdsWithin_le_nhds
  have hxne : ∀ᶠ x : ℝ in 𝓝[>] (-1), x ≠ 0 := by
    filter_upwards [hxneg] with x hx
    exact ne_of_lt hx
  have hrec : (fun x : ℝ => (x + 1) * Real.Gamma x) =ᶠ[𝓝[>] (-1)]
      (fun x : ℝ => ((x + 1) * Real.Gamma (x + 1)) / x) := by
    filter_upwards [hxne] with x hx
    rw [Real.Gamma_add_one hx]
    field_simp [hx]
  have hid : Filter.Tendsto (fun x : ℝ => x) (𝓝[>] (-1)) (𝓝 (-1)) :=
    Filter.tendsto_id.mono_left nhdsWithin_le_nhds
  have hquot : Filter.Tendsto (fun x : ℝ => ((x + 1) * Real.Gamma (x + 1)) / x)
      (𝓝[>] (-1)) (𝓝 (-1)) := by
    have h := hcomp.div hid (by norm_num : (-1 : ℝ) ≠ 0)
    convert h using 1
    · funext x
      simp [Function.comp_apply, div_eq_mul_inv]
    · norm_num
  have hprod : Filter.Tendsto (fun x : ℝ => (x + 1) * Real.Gamma x) (𝓝[>] (-1)) (𝓝 (-1)) :=
    hquot.congr' hrec.symm
  have hnorm : Filter.Tendsto (fun x : ℝ => ‖(x + 1) * Real.Gamma x‖) (𝓝[>] (-1)) (𝓝 1) := by
    have := hprod.norm
    simpa using this
  have habs : Filter.Tendsto (fun x : ℝ => |x + 1|⁻¹) (𝓝[>] (-1)) Filter.atTop := by
    have h : Filter.Tendsto (fun x : ℝ => (x + 1)⁻¹) (𝓝[>] (-1)) Filter.atTop := by
      have h' := (tendsto_inv_nhdsGT_zero (𝕜 := ℝ)).comp hshift
      convert h' using 1
      funext x
      rfl
    refine h.congr' ?_
    filter_upwards [hxpos] with x hx
    rw [abs_of_pos hx]
  have hmain : Filter.Tendsto (fun x : ℝ => ‖(x + 1) * Real.Gamma x‖ * |x + 1|⁻¹)
      (𝓝[>] (-1)) Filter.atTop :=
    Filter.Tendsto.pos_mul_atTop (C := (1 : ℝ))
      (f := fun x : ℝ => ‖(x + 1) * Real.Gamma x‖)
      (g := fun x : ℝ => |x + 1|⁻¹) (by norm_num) hnorm habs
  refine hmain.congr' ?_
  filter_upwards [hxpos] with x hx
  rw [← div_eq_mul_inv, norm_mul, Real.norm_eq_abs, abs_of_pos hx]
  rw [mul_div_cancel_left₀]
  exact ne_of_gt hx


/-- **T207:** `‖gammaRatio 0 s‖ → ∞` as `s → 3⁻`. -/
lemma tendsto_norm_gammaRatio_zero_nhdsLT_three :
    Filter.Tendsto (fun s : ℝ => ‖gammaRatio 0 s‖) (𝓝[<] (3 : ℝ)) Filter.atTop := by
  have harg : Filter.Tendsto (fun s : ℝ => (1 - s) / 2) (𝓝[<] (3 : ℝ)) (𝓝[>] (-1)) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · have h : Filter.Tendsto (fun s : ℝ => (1 - s) / 2) (𝓝 (3 : ℝ)) (𝓝 ((1 - 3) / 2)) := by
        have hc : Continuous (fun s : ℝ => (1 - s) / 2) := by fun_prop
        exact hc.tendsto 3
      have h' := h.mono_left (nhdsWithin_le_nhds (s := Set.Iio (3 : ℝ)))
      convert h' using 1
      norm_num
    · filter_upwards [self_mem_nhdsWithin] with s hs
      have hs' : s < 3 := hs
      change -1 < (1 - s) / 2
      linarith
  have hnum : Filter.Tendsto (fun s : ℝ => ‖Real.Gamma ((1 - s) / 2)‖)
      (𝓝[<] (3 : ℝ)) Filter.atTop :=
    tendsto_norm_Gamma_nhdsGT_neg_one.comp harg
  have hden : Filter.Tendsto (fun s : ℝ => ‖Real.Gamma (s / 2)‖)
      (𝓝[<] (3 : ℝ)) (𝓝 ‖Real.Gamma (3 / 2)‖) := by
    have h2 : Filter.Tendsto (fun s : ℝ => s / 2) (𝓝 (3 : ℝ)) (𝓝 ((3 : ℝ) / 2)) := by
      have hc : Continuous (fun s : ℝ => s / 2) := by fun_prop
      exact hc.tendsto 3
    have hg : Filter.Tendsto Real.Gamma (𝓝 ((3 : ℝ) / 2)) (𝓝 (Real.Gamma (3 / 2))) :=
      (Real.hasDerivAt_Gamma_of_pos (by norm_num : (0 : ℝ) < 3 / 2)).continuousAt
    have hcomp : Filter.Tendsto (fun s : ℝ => Real.Gamma (s / 2)) (𝓝 (3 : ℝ))
        (𝓝 (Real.Gamma (3 / 2))) := by
      simpa [Function.comp_def] using hg.comp h2
    exact hcomp.norm.mono_left (nhdsWithin_le_nhds (s := Set.Iio (3 : ℝ)))
  have hden_ne : ‖Real.Gamma (3 / 2)‖ ≠ 0 :=
    norm_ne_zero_iff.mpr (Real.Gamma_pos_of_pos (by norm_num)).ne'
  have hden_inv : Filter.Tendsto (fun s : ℝ => ‖Real.Gamma (s / 2)‖⁻¹)
      (𝓝[<] (3 : ℝ)) (𝓝 (‖Real.Gamma (3 / 2)‖⁻¹)) := hden.inv₀ hden_ne
  have hCpos : 0 < ‖Real.Gamma (3 / 2)‖⁻¹ :=
    inv_pos.mpr (norm_pos_iff.mpr (Real.Gamma_pos_of_pos (by norm_num)).ne')
  have hprod : Filter.Tendsto
      (fun s : ℝ => ‖Real.Gamma (s / 2)‖⁻¹ * ‖Real.Gamma ((1 - s) / 2)‖)
      (𝓝[<] (3 : ℝ)) Filter.atTop :=
    Filter.Tendsto.pos_mul_atTop (C := ‖Real.Gamma (3 / 2)‖⁻¹)
      (f := fun s : ℝ => ‖Real.Gamma (s / 2)‖⁻¹)
      (g := fun s : ℝ => ‖Real.Gamma ((1 - s) / 2)‖) hCpos hden_inv hnum
  refine hprod.congr' ?_
  filter_upwards with s
  rw [gammaRatio, norm_div]
  ring


/-- **T208:** `‖qefeRhs 4 0 1 isingPsi s‖ → ∞` as `s → 3⁻`. -/
lemma tendsto_norm_qefeRhs_ising_nhdsLT_three :
    Filter.Tendsto (fun s : ℝ => ‖qefeRhs 4 0 1 isingPsi s‖) (𝓝[<] (3 : ℝ)) Filter.atTop := by
  have hpref_cont : ContinuousAt (fun s : ℝ => (4 / Real.pi : ℝ) ^ (s - 1 / 2)) (3 : ℝ) := by
    have hbase : (4 / Real.pi : ℝ) ≠ 0 := by positivity
    have hexp : ContinuousAt (fun s : ℝ => s - 1 / 2) (3 : ℝ) := by fun_prop
    exact (Real.continuousAt_const_rpow hbase).comp hexp
  have hpref : Filter.Tendsto (fun s : ℝ => ‖(4 / Real.pi : ℝ) ^ (s - 1 / 2)‖)
      (𝓝[<] (3 : ℝ)) (𝓝 ‖(4 / Real.pi : ℝ) ^ ((3 : ℝ) - 1 / 2)‖) :=
    hpref_cont.norm.tendsto.mono_left (nhdsWithin_le_nhds (s := Set.Iio (3 : ℝ)))
  have hpsi_cont : Continuous (fun s : ℝ => isingPsi (1 - s)) := by
    unfold isingPsi
    have h4 : Continuous (fun s : ℝ => (4 : ℝ) ^ (-(1 - s))) :=
      (Real.continuous_const_rpow (by norm_num : (4 : ℝ) ≠ 0)).comp (by fun_prop)
    have h2 : Continuous (fun s : ℝ => (2 : ℝ) ^ (-(1 - s))) :=
      (Real.continuous_const_rpow (by norm_num : (2 : ℝ) ≠ 0)).comp (by fun_prop)
    exact (h4.const_mul 2).sub h2
  have hpsi : Filter.Tendsto (fun s : ℝ => ‖isingPsi (1 - s)‖)
      (𝓝[<] (3 : ℝ)) (𝓝 ‖isingPsi (1 - 3)‖) :=
    hpsi_cont.continuousAt.norm.tendsto.mono_left (nhdsWithin_le_nhds (s := Set.Iio (3 : ℝ)))
  have hCpref : 0 < ‖(4 / Real.pi : ℝ) ^ ((3 : ℝ) - 1 / 2)‖ := by
    apply norm_pos_iff.mpr
    exact ne_of_gt (Real.rpow_pos_of_pos (by positivity) _)
  have hCpsi : 0 < ‖isingPsi (1 - 3)‖ := by
    norm_num [isingPsi]
  have h1 : Filter.Tendsto
      (fun s : ℝ => ‖gammaRatio 0 s‖ * ‖(4 / Real.pi : ℝ) ^ (s - 1 / 2)‖)
      (𝓝[<] (3 : ℝ)) Filter.atTop :=
    tendsto_norm_gammaRatio_zero_nhdsLT_three.atTop_mul_pos hCpref hpref
  have h2 : Filter.Tendsto
      (fun s : ℝ => (‖gammaRatio 0 s‖ * ‖(4 / Real.pi : ℝ) ^ (s - 1 / 2)‖) *
        ‖isingPsi (1 - s)‖) (𝓝[<] (3 : ℝ)) Filter.atTop :=
    h1.atTop_mul_pos hCpsi hpsi
  refine h2.congr' ?_
  filter_upwards with s
  rw [qefeRhs]
  simp only [norm_mul, norm_one, one_mul]
  ring

/-- **T209:** if `‖g‖ → ∞` and `‖f‖` is eventually bounded, then `‖f - g‖ → ∞`. -/
lemma tendsto_norm_sub_atTop_of_eventually_le {f g : ℝ → ℝ} {l : Filter ℝ} {C : ℝ}
    (hg : Filter.Tendsto (fun x => ‖g x‖) l Filter.atTop)
    (hf : ∀ᶠ x in l, ‖f x‖ ≤ C) :
    Filter.Tendsto (fun x => ‖f x - g x‖) l Filter.atTop := by
  rw [Filter.tendsto_atTop]
  intro b
  have hb : ∀ᶠ x in l, b + C ≤ ‖g x‖ := Filter.tendsto_atTop.1 hg (b + C)
  filter_upwards [hb, hf] with x hgx hfx
  have htri : ‖g x‖ - ‖f x‖ ≤ ‖g x - f x‖ := norm_sub_norm_le (g x) (f x)
  rw [norm_sub_rev] at htri
  linarith

/-- **T210:** `isingPsi` is eventually bounded near `3` from the left. -/
lemma isingPsi_eventually_bounded_nhdsLT_three :
    ∃ C : ℝ, ∀ᶠ s : ℝ in 𝓝[<] (3 : ℝ), ‖isingPsi s‖ ≤ C := by
  have hcont : ContinuousAt isingPsi (3 : ℝ) := by
    unfold isingPsi
    have h4 : ContinuousAt (fun s : ℝ => (4 : ℝ) ^ (-s)) (3 : ℝ) :=
      (Real.continuousAt_const_rpow (by norm_num : (4 : ℝ) ≠ 0)).comp (by fun_prop)
    have h2 : ContinuousAt (fun s : ℝ => (2 : ℝ) ^ (-s)) (3 : ℝ) :=
      (Real.continuousAt_const_rpow (by norm_num : (2 : ℝ) ≠ 0)).comp (by fun_prop)
    exact (h4.const_mul 2).sub h2
  refine ⟨‖isingPsi 3‖ + 1, ?_⟩
  have hb : ∀ᶠ s : ℝ in 𝓝 (3 : ℝ), ‖isingPsi s‖ ≤ ‖isingPsi 3‖ + 1 :=
    hcont.norm.tendsto.eventually (Iic_mem_nhds (by linarith))
  exact hb.filter_mono (nhdsWithin_le_nhds (s := Set.Iio (3 : ℝ)))

/-- The QEFE residual `Ψ(s) − RHS(s)`. -/
def qefeResidual (D2 a eps : ℝ) (psi : ℝ → ℝ) (s : ℝ) : ℝ :=
  psi s - qefeRhs D2 a eps psi s

/-- **T211:** the Ising QEFE residual is unbounded near `s = 3`. -/
lemma tendsto_norm_qefeResidual_ising_nhdsLT_three :
    Filter.Tendsto (fun s : ℝ => ‖qefeResidual 4 0 1 isingPsi s‖)
      (𝓝[<] (3 : ℝ)) Filter.atTop := by
  obtain ⟨C, hC⟩ := isingPsi_eventually_bounded_nhdsLT_three
  have h := tendsto_norm_sub_atTop_of_eventually_le
    (f := isingPsi) (g := fun s : ℝ => qefeRhs 4 0 1 isingPsi s) (l := 𝓝[<] (3 : ℝ)) (C := C)
    tendsto_norm_qefeRhs_ising_nhdsLT_three hC
  simpa [qefeResidual] using h


/-- **T212:** `‖gammaRatio 1 s‖ → ∞` as `s → 4⁻`. -/
lemma tendsto_norm_gammaRatio_one_nhdsLT_four :
    Filter.Tendsto (fun s : ℝ => ‖gammaRatio 1 s‖) (𝓝[<] (4 : ℝ)) Filter.atTop := by
  have harg : Filter.Tendsto (fun s : ℝ => (1 - s + 1) / 2) (𝓝[<] (4 : ℝ)) (𝓝[>] (-1)) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · have h : Filter.Tendsto (fun s : ℝ => (1 - s + 1) / 2) (𝓝 (4 : ℝ)) (𝓝 ((1 - 4 + 1) / 2)) := by
        have hc : Continuous (fun s : ℝ => (1 - s + 1) / 2) := by fun_prop
        exact hc.tendsto 4
      have h' := h.mono_left (nhdsWithin_le_nhds (s := Set.Iio (4 : ℝ)))
      convert h' using 1
      norm_num
    · filter_upwards [self_mem_nhdsWithin] with s hs
      have hs' : s < 4 := hs
      change -1 < (1 - s + 1) / 2
      linarith
  have hnum : Filter.Tendsto (fun s : ℝ => ‖Real.Gamma ((1 - s + 1) / 2)‖)
      (𝓝[<] (4 : ℝ)) Filter.atTop :=
    tendsto_norm_Gamma_nhdsGT_neg_one.comp harg
  have hden : Filter.Tendsto (fun s : ℝ => ‖Real.Gamma ((s + 1) / 2)‖)
      (𝓝[<] (4 : ℝ)) (𝓝 ‖Real.Gamma (5 / 2)‖) := by
    have h2 : Filter.Tendsto (fun s : ℝ => (s + 1) / 2) (𝓝 (4 : ℝ)) (𝓝 (((4 : ℝ) + 1) / 2)) := by
      have hc : Continuous (fun s : ℝ => (s + 1) / 2) := by fun_prop
      exact hc.tendsto 4
    have hg : Filter.Tendsto Real.Gamma (𝓝 (((4 : ℝ) + 1) / 2))
        (𝓝 (Real.Gamma (((4 : ℝ) + 1) / 2))) :=
      (Real.hasDerivAt_Gamma_of_pos (by norm_num : (0 : ℝ) < ((4 : ℝ) + 1) / 2)).continuousAt
    have h52 : (((4 : ℝ) + 1) / 2) = 5 / 2 := by norm_num
    rw [h52] at h2 hg
    have hcomp : Filter.Tendsto (fun s : ℝ => Real.Gamma ((s + 1) / 2)) (𝓝 (4 : ℝ))
        (𝓝 (Real.Gamma (5 / 2))) := by
      simpa [Function.comp_def] using hg.comp h2
    exact hcomp.norm.mono_left (nhdsWithin_le_nhds (s := Set.Iio (4 : ℝ)))
  have hden_ne : ‖Real.Gamma (5 / 2)‖ ≠ 0 :=
    norm_ne_zero_iff.mpr (Real.Gamma_pos_of_pos (by norm_num)).ne'
  have hden_inv : Filter.Tendsto (fun s : ℝ => ‖Real.Gamma ((s + 1) / 2)‖⁻¹)
      (𝓝[<] (4 : ℝ)) (𝓝 (‖Real.Gamma (5 / 2)‖⁻¹)) := hden.inv₀ hden_ne
  have hCpos : 0 < ‖Real.Gamma (5 / 2)‖⁻¹ :=
    inv_pos.mpr (norm_pos_iff.mpr (Real.Gamma_pos_of_pos (by norm_num)).ne')
  have hprod : Filter.Tendsto
      (fun s : ℝ => ‖Real.Gamma ((s + 1) / 2)‖⁻¹ * ‖Real.Gamma ((1 - s + 1) / 2)‖)
      (𝓝[<] (4 : ℝ)) Filter.atTop :=
    Filter.Tendsto.pos_mul_atTop (C := ‖Real.Gamma (5 / 2)‖⁻¹)
      (f := fun s : ℝ => ‖Real.Gamma ((s + 1) / 2)‖⁻¹)
      (g := fun s : ℝ => ‖Real.Gamma ((1 - s + 1) / 2)‖) hCpos hden_inv hnum
  refine hprod.congr' ?_
  filter_upwards with s
  rw [gammaRatio, norm_div]
  ring

/-- **T213:** `‖qefeRhs 12 1 1 su2Psi s‖ → ∞` as `s → 4⁻`. -/
lemma tendsto_norm_qefeRhs_su2_nhdsLT_four :
    Filter.Tendsto (fun s : ℝ => ‖qefeRhs 12 1 1 su2Psi s‖) (𝓝[<] (4 : ℝ)) Filter.atTop := by
  have hpref_cont : ContinuousAt (fun s : ℝ => (12 / Real.pi : ℝ) ^ (s - 1 / 2)) (4 : ℝ) := by
    have hbase : (12 / Real.pi : ℝ) ≠ 0 := by positivity
    have hexp : ContinuousAt (fun s : ℝ => s - 1 / 2) (4 : ℝ) := by fun_prop
    exact (Real.continuousAt_const_rpow hbase).comp hexp
  have hpref : Filter.Tendsto (fun s : ℝ => ‖(12 / Real.pi : ℝ) ^ (s - 1 / 2)‖)
      (𝓝[<] (4 : ℝ)) (𝓝 ‖(12 / Real.pi : ℝ) ^ ((4 : ℝ) - 1 / 2)‖) :=
    hpref_cont.norm.tendsto.mono_left (nhdsWithin_le_nhds (s := Set.Iio (4 : ℝ)))
  have hpsi_cont : Continuous (fun s : ℝ => su2Psi (1 - s)) := by
    unfold su2Psi
    have h12 : Continuous (fun s : ℝ => (12 : ℝ) ^ (-(1 - s))) :=
      (Real.continuous_const_rpow (by norm_num : (12 : ℝ) ≠ 0)).comp (by fun_prop)
    have h4 : Continuous (fun s : ℝ => (4 : ℝ) ^ (-(1 - s))) :=
      (Real.continuous_const_rpow (by norm_num : (4 : ℝ) ≠ 0)).comp (by fun_prop)
    have h3 : Continuous (fun s : ℝ => (3 : ℝ) ^ (-(1 - s))) :=
      (Real.continuous_const_rpow (by norm_num : (3 : ℝ) ≠ 0)).comp (by fun_prop)
    exact ((h12.const_mul 2).sub (h4.const_mul 2)).add h3
  have hpsi : Filter.Tendsto (fun s : ℝ => ‖su2Psi (1 - s)‖)
      (𝓝[<] (4 : ℝ)) (𝓝 ‖su2Psi (1 - 4)‖) :=
    hpsi_cont.continuousAt.norm.tendsto.mono_left (nhdsWithin_le_nhds (s := Set.Iio (4 : ℝ)))
  have hCpref : 0 < ‖(12 / Real.pi : ℝ) ^ ((4 : ℝ) - 1 / 2)‖ := by
    apply norm_pos_iff.mpr
    exact ne_of_gt (Real.rpow_pos_of_pos (by positivity) _)
  have hCpsi : 0 < ‖su2Psi (1 - 4)‖ := by
    norm_num [su2Psi]
  have h1 : Filter.Tendsto
      (fun s : ℝ => ‖gammaRatio 1 s‖ * ‖(12 / Real.pi : ℝ) ^ (s - 1 / 2)‖)
      (𝓝[<] (4 : ℝ)) Filter.atTop :=
    tendsto_norm_gammaRatio_one_nhdsLT_four.atTop_mul_pos hCpref hpref
  have h2 : Filter.Tendsto
      (fun s : ℝ => (‖gammaRatio 1 s‖ * ‖(12 / Real.pi : ℝ) ^ (s - 1 / 2)‖) *
        ‖su2Psi (1 - s)‖) (𝓝[<] (4 : ℝ)) Filter.atTop :=
    h1.atTop_mul_pos hCpsi hpsi
  refine h2.congr' ?_
  filter_upwards with s
  rw [qefeRhs]
  simp only [norm_mul, one_mul]
  ring

/-- **T214:** `su2Psi` is eventually bounded near `4` from the left. -/
lemma su2Psi_eventually_bounded_nhdsLT_four :
    ∃ C : ℝ, ∀ᶠ s : ℝ in 𝓝[<] (4 : ℝ), ‖su2Psi s‖ ≤ C := by
  have hcont : ContinuousAt su2Psi (4 : ℝ) := by
    unfold su2Psi
    have h12 : ContinuousAt (fun s : ℝ => (12 : ℝ) ^ (-s)) (4 : ℝ) :=
      (Real.continuousAt_const_rpow (by norm_num : (12 : ℝ) ≠ 0)).comp (by fun_prop)
    have h4 : ContinuousAt (fun s : ℝ => (4 : ℝ) ^ (-s)) (4 : ℝ) :=
      (Real.continuousAt_const_rpow (by norm_num : (4 : ℝ) ≠ 0)).comp (by fun_prop)
    have h3 : ContinuousAt (fun s : ℝ => (3 : ℝ) ^ (-s)) (4 : ℝ) :=
      (Real.continuousAt_const_rpow (by norm_num : (3 : ℝ) ≠ 0)).comp (by fun_prop)
    exact ((h12.const_mul 2).sub (h4.const_mul 2)).add h3
  refine ⟨‖su2Psi 4‖ + 1, ?_⟩
  have hb : ∀ᶠ s : ℝ in 𝓝 (4 : ℝ), ‖su2Psi s‖ ≤ ‖su2Psi 4‖ + 1 :=
    hcont.norm.tendsto.eventually (Iic_mem_nhds (by linarith))
  exact hb.filter_mono (nhdsWithin_le_nhds (s := Set.Iio (4 : ℝ)))

/-- **T215:** the `SU(2)₄` QEFE residual is unbounded near `s = 4`. -/
lemma tendsto_norm_qefeResidual_su2_nhdsLT_four :
    Filter.Tendsto (fun s : ℝ => ‖qefeResidual 12 1 1 su2Psi s‖)
      (𝓝[<] (4 : ℝ)) Filter.atTop := by
  obtain ⟨C, hC⟩ := su2Psi_eventually_bounded_nhdsLT_four
  have h := tendsto_norm_sub_atTop_of_eventually_le
    (f := su2Psi) (g := fun s : ℝ => qefeRhs 12 1 1 su2Psi s) (l := 𝓝[<] (4 : ℝ)) (C := C)
    tendsto_norm_qefeRhs_su2_nhdsLT_four hC
  simpa [qefeResidual] using h


/-- A finite exponential sum `Σ cᵢ exp(−λᵢ τ)`. -/
def finiteThetaSum {ι : Type*} [Fintype ι] (c lam : ι → ℝ) (τ : ℝ) : ℝ :=
  ∑ i, c i * Real.exp (-(lam i) * τ)

/-- **T217:** a finite exponential sum with non-zero total cannot satisfy any weight-`w` modular relation. -/
lemma finiteThetaSum_not_modular_of_sum_ne_zero {ι : Type*} [Fintype ι]
    (c lam : ι → ℝ) (hlam : ∀ i, 0 < lam i)
    (hsum : (∑ i, c i) ≠ 0) (w ε : ℝ) :
    ¬ ∀ τ : ℝ, 0 < τ → finiteThetaSum c lam (1 / τ) = ε * τ ^ w * finiteThetaSum c lam τ := by
  have hleft : Filter.Tendsto (fun τ : ℝ => finiteThetaSum c lam (1 / τ))
      Filter.atTop (𝓝 (∑ i, c i)) := by
    unfold finiteThetaSum
    apply tendsto_finset_sum
    intro i hi
    have harg : Filter.Tendsto (fun τ : ℝ => -(lam i) * (1 / τ)) Filter.atTop (𝓝 0) := by
      simpa using (tendsto_inv_atTop_zero.const_mul (-(lam i)))
    have hexp : Filter.Tendsto (fun τ : ℝ => Real.exp (-(lam i) * (1 / τ)))
        Filter.atTop (𝓝 1) := by
      simpa [Function.comp_def] using (Real.continuous_exp.tendsto 0).comp harg
    simpa using hexp.const_mul (c i)
  have hright : Filter.Tendsto (fun τ : ℝ => ε * τ ^ w * finiteThetaSum c lam τ)
      Filter.atTop (𝓝 0) := by
    have hterm : ∀ i, Filter.Tendsto
        (fun τ : ℝ => c i * (τ ^ w * Real.exp (-(lam i) * τ))) Filter.atTop (𝓝 0) := by
      intro i
      have h : Filter.Tendsto (fun τ : ℝ => τ ^ w * Real.exp (-(lam i) * τ))
          Filter.atTop (𝓝 0) :=
        tendsto_rpow_mul_exp_neg_mul_atTop_nhds_zero w (lam i) (hlam i)
      simpa using h.const_mul (c i)
    have hsum0 : Filter.Tendsto
        (fun τ : ℝ => ∑ i, c i * (τ ^ w * Real.exp (-(lam i) * τ)))
        Filter.atTop (𝓝 0) := by
      simpa using tendsto_finset_sum Finset.univ (fun i _ => hterm i)
    have h : Filter.Tendsto
        (fun τ : ℝ => ε * ∑ i, c i * (τ ^ w * Real.exp (-(lam i) * τ)))
        Filter.atTop (𝓝 0) := by
      simpa using hsum0.const_mul ε
    refine h.congr' ?_
    filter_upwards with τ
    rw [finiteThetaSum, Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    ring
  intro h
  have heq : (fun τ : ℝ => finiteThetaSum c lam (1 / τ)) =ᶠ[Filter.atTop]
      (fun τ : ℝ => ε * τ ^ w * finiteThetaSum c lam τ) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with τ hτ
    exact h τ hτ
  have hright_left : Filter.Tendsto (fun τ : ℝ => finiteThetaSum c lam (1 / τ))
      Filter.atTop (𝓝 0) := hright.congr' heq.symm
  have : (∑ i, c i) = 0 := tendsto_nhds_unique hleft hright_left
  exact hsum this


/-- The mathematical content of the named input `LatticeThetaMellinChi4`:
the completed ℤ² series equals `4π^(−s)Γ(s)ζ(s)β(s)` on `Re s > 1`. -/
def LatticeThetaMellinChi4 : Prop :=
  ∀ s : ℂ, 1 < s.re →
    LambdaZ2 s =
      4 * ((Real.pi : ℝ) : ℂ)^(-s) * Complex.Gamma s * riemannZeta s * betaSeries s

/-- **T219:** `LatticeThetaMellinChi4` holds, by T120. -/
theorem latticeThetaMellinChi4 : LatticeThetaMellinChi4 :=
  fun s hs => lambdaZ2_product s hs

end QEFE
