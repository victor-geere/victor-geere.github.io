import Mathlib
import Topic
import Bridges
import TransferNoGo
import Tractable
import MatrixNoGo
import SignedF4
import LeeYang
import PartialSumTail

/-!
# Geometric DQPT — the computations as theorems

Every row of the programme ledger that was formerly labelled a *computation*
is restated here as a theorem and proved.  Where the finite computation was a
sample of a general fact already proved in `Topic.lean`, `Bridges.lean`,
`Breakthrough.lean`, `TransferNoGo.lean`, `Tractable.lean`, `MatrixNoGo.lean`,
`SignedF4.lean`, `LeeYang.lean` or `PartialSumTail.lean`, the theorem below is
the finite statement itself, derived from (or occasionally strengthening) the
general result.  The Python suite remains as a regression check, but it is no
longer the proof of any ledger row.
-/

noncomputable section

set_option maxRecDepth 10000

open scoped BigOperators
open Complex
open intervalIntegral

namespace GeoDQPT

/-! ## C1–C7: the finite filter and atomic layer -/

/-- C1: the two coefficient cases hold on the recorded finite grid. -/
theorem comp_filterCoeff_cases :
    ∀ N ∈ ({2, 3, 4, 5, 7, 12} : Finset ℕ),
      ∀ m ∈ Finset.Icc 1 (4 * N),
        filterCoeff N m = if N ∣ m then 1 - (N : ℤ) else 1 := by
  decide

/-- C2: the complete-block sum vanishes for every `2 ≤ N ≤ 60`. -/
theorem comp_complete_block_sum :
    ∀ N ∈ Finset.Icc 2 60,
      (∑ k ∈ Finset.range N, filterCoeff N (k + 1)) = 0 := by
  decide

/-- C3: the quadratic link gives inner length `N` for every `2 ≤ N ≤ 300`. -/
theorem comp_quadratic_link :
    ∀ N ∈ Finset.Icc 2 300, N ^ 2 / N = N := by
  decide

/-- The coefficient of the depth-one pair at `m`, i.e. of
`H_M^(s) - N^(1-s) H_⌊M/N⌋^(s)` (Definition 3.1). -/
def twoSumCoeff (N M m : ℕ) : ℤ :=
  1 - if N ∣ m ∧ m ≤ M then (N : ℤ) else 0

/-- C4, general form: at `m ≤ M` the depth-one pair has exactly the filter
coefficient.  This is the coefficientwise content of Lemma 3.2 and strictly
contains the finite check. -/
theorem twoSumCoeff_eq_filterCoeff {N M m : ℕ} (hN : 1 ≤ N) (hM : 1 ≤ M)
    (hm : m ≤ M) : twoSumCoeff N M m = filterCoeff N m := by
  unfold twoSumCoeff filterCoeff
  by_cases hdvd : N ∣ m
  · have hle : m ≤ M := hm
    simp [hdvd, hle]
  · simp [hdvd]

/-- C4 on the recorded grid: coefficientwise agreement for `2 ≤ N ≤ 15` and
the listed outer lengths. -/
theorem comp_twoSum_identity :
    ∀ N ∈ Finset.Icc 2 15,
      ∀ M ∈ ({1, N - 1, N, N + 1, N * N, 2 * N * N + 3} : Finset ℕ),
        1 ≤ M → ∀ m ∈ Finset.Icc 1 M,
          twoSumCoeff N M m = filterCoeff N m := by
  intro N hN M hM hM1 m hm
  have hN2 : 2 ≤ N := (Finset.mem_Icc.mp hN).1
  exact twoSumCoeff_eq_filterCoeff (N := N) (M := M) (m := m) (by omega) hM1
    (Finset.mem_Icc.mp hm).2

/-- C5: the tempering weight lies in `(0,1]` on the rational test set. -/
theorem comp_temperedWeight_testset :
    ∀ t ∈ ({0, 1 / 2, 1, 3 / 2, 3, -5} : Finset ℚ),
      0 < (1 + ((t : ℚ) : ℝ) ^ 2)⁻¹ ∧ (1 + ((t : ℚ) : ℝ) ^ 2)⁻¹ ≤ 1 := by
  intro t _
  exact ⟨temperedWeight_pos _, temperedWeight_le_one _⟩

/-- C6, exact value: the atom `3 + 4i` has weight `1/26`. -/
theorem comp_atomicWeight_3_4 : atomWeight (3 + 4 * Complex.I) = 1 / 26 := by
  unfold atomWeight
  norm_num [Complex.normSq_apply]

/-- C6: the recorded finite atomic measure has mass at most its atom count. -/
theorem comp_atomicMass_testset :
    atomicMass ({0, 1, -1, Complex.I, 3 + 4 * Complex.I,
      (1 / 2 : ℂ) + (3 / 2 : ℂ) * Complex.I} : Finset ℂ) ≤
      (({0, 1, -1, Complex.I, 3 + 4 * Complex.I,
        (1 / 2 : ℂ) + (3 / 2 : ℂ) * Complex.I} : Finset ℂ).card : ℝ) := by
  exact atomicMass_le_card _

/-- C7: the empty atomic measure has mass zero. -/
theorem comp_empty_atomicMass : atomicMass (∅ : Finset ℂ) = 0 := by
  simp [atomicMass]

/-- C7: the two admissible boundary coefficients. -/
theorem comp_filterCoeff_edges :
    filterCoeff 2 3 = 1 ∧ filterCoeff 2 4 = -1 := by
  constructor <;> decide


/-! ## C8–C12: last chord, clock zeros, prefactor, local diagonal, register -/

/-- C8: the twin product is independent of `σ` on the recorded range. -/
theorem comp_lastChord_product :
    ∀ N ∈ Finset.Icc 2 10, ∀ σ : ℝ,
      lastChordAbs N σ * lastChordAbs N (1 - σ) =
        ((N : ℝ) - 1) ^ 2 / (4 * (N : ℝ) ^ 2) := by
  intro N hN σ
  have h2 : 1 < N := by
    have := (Finset.mem_Icc.mp hN).1
    omega
  exact lastChordAbs_mul_twin h2 σ

/-- C8: the self-dual abscissa is unique on the recorded range. -/
theorem comp_lastChord_self_dual :
    ∀ N ∈ Finset.Icc 2 10, ∀ σ : ℝ,
      lastChordAbs N σ = lastChordAbs N (1 - σ) ↔ σ = 1 / 2 := by
  intro N hN σ
  have h2 : 1 < N := by
    have := (Finset.mem_Icc.mp hN).1
    omega
  exact lastChordAbs_twin_eq_iff h2 σ

/-- C8: the twin difference vanishes at `σ = 1/2` and not at `σ = 1/3`. -/
theorem comp_lastChord_twin_difference :
    lastChordAbs 3 (1 / 2) = lastChordAbs 3 (1 - 1 / 2) ∧
      lastChordAbs 3 (1 / 3) ≠ lastChordAbs 3 (1 - 1 / 3) := by
  constructor
  · norm_num [lastChordAbs]
  · intro h
    have := (lastChordAbs_twin_eq_iff (N := 3) (by norm_num) (1 / 3)).mp h
    norm_num at this

/-- The clock point of Lemma F.8. -/
def clockZero (N : ℕ) (k : ℤ) : ℂ :=
  1 - (k * (2 * Real.pi * Complex.I)) / (Real.log N : ℂ)

/-- C9, general form: every clock point is an exact zero of `1 - N^(1-s)`. -/
theorem clockZero_isZero {N : ℕ} (hN : 1 < N) (k : ℤ) :
    (N : ℂ) ^ (1 - clockZero N k) = 1 := by
  rw [clock_zero_iff hN]
  exact ⟨k, rfl⟩

/-- C9 on the recorded grid. -/
theorem comp_clock_zeros :
    ∀ N ∈ ({2, 3, 10} : Finset ℕ), ∀ k ∈ Finset.Icc (-2 : ℤ) 2,
      (N : ℂ) ^ (1 - clockZero N k) = 1 := by
  intro N hN k _
  have h2 : 1 < N := by
    have hmem := hN
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with rfl | rfl | rfl <;> norm_num
  exact clockZero_isZero h2 k

/-- C10: the prefactor lower bound on the recorded grid. -/
theorem comp_prefactor_grid :
    ∀ N ∈ (Finset.Icc 2 50 : Finset ℕ),
      ∀ σ ∈ ({1 / 4, 1 / 2, 3 / 4, 3 / 2} : Finset ℚ),
        ∀ t ∈ ({0, 1, 14134725 / 1000000} : Finset ℚ),
          (N : ℝ) ^ (1 - (σ : ℝ)) - 1 ≤
            ‖(1 : ℂ) - (N : ℂ) ^ (1 - ((σ : ℝ) + (t : ℝ) * Complex.I))‖ := by
  intro N hN σ _ t _
  have h2 : 1 < N := by
    have := (Finset.mem_Icc.mp hN).1
    omega
  exact prefactor_lower_bound (N := N) h2 (σ : ℝ) (t : ℝ)

/-- The heat-flowed register polynomial of Remark F.13(c). -/
def heatFlowed (N : ℕ) (τ : ℝ) (s : ℂ) : ℂ :=
  ∑ m ∈ Finset.Icc 1 (N * N),
    (filterCoeff N m : ℂ) * Complex.exp (τ * (Real.log m) ^ 2) * (m : ℂ) ^ (-s)

/-- The polygon at the quadratic link. -/
def polygon (N : ℕ) (s : ℂ) : ℂ :=
  ∑ m ∈ Finset.Icc 1 (N * N), (filterCoeff N m : ℂ) * (m : ℂ) ^ (-s)

/-- C12: the heat flow reduces to the polygon at `τ = 0`. -/
theorem comp_heatFlow_zero (N : ℕ) (s : ℂ) : heatFlowed N 0 s = polygon N s := by
  simp [heatFlowed, polygon]

/-- C12: the register weight at the period is `1 - N`, hence negative. -/
theorem comp_register_weight :
    ∀ N ∈ Finset.Icc 2 10,
      regCoeff N N = 1 - (N : ℝ) ∧ regCoeff N N < 0 := by
  intro N hN
  have h2 : 1 < N := by
    have := (Finset.mem_Icc.mp hN).1
    omega
  exact ⟨regCoeff_at_period N, regCoeff_at_period_neg h2⟩

/-- C18: the register coefficient at the period is negative on the recorded grid. -/
theorem comp_register_coeff :
    ∀ N ∈ Finset.Icc 2 10, regCoeff N N < 0 :=
  fun N hN => (comp_register_weight N hN).2

/-- C19: the register coupling at `m = N` is negative. -/
theorem comp_register_coupling :
    ∀ N ∈ Finset.Icc 2 10, ∀ s : ℝ, (regMat N s N) 0 1 < 0 := by
  intro N hN s
  have h2 : 1 < N := by
    have := (Finset.mem_Icc.mp hN).1
    omega
  exact regMat_coupling_neg h2 s

/-- C20: the register chain is not ferromagnetic. -/
theorem comp_register_not_ferro :
    ∀ N ∈ Finset.Icc 2 10, ∀ s : ℝ, ¬ (∀ m : ℕ, 0 ≤ (regMat N s m) 0 1) := by
  intro N hN s
  have h2 : 1 < N := by
    have := (Finset.mem_Icc.mp hN).1
    omega
  exact register_not_ferromagnetic h2 s

/-- C17: the register product agrees with the polygon at the quadratic link. -/
theorem comp_register_product :
    ∀ N ∈ Finset.Icc 2 5, ∀ s : ℝ,
      (regProd N s (N * N)) 0 1 =
        ∑ k ∈ Finset.range (N * N), regCoeff N (k + 1) * ((k + 1 : ℕ) : ℝ) ^ (-s) := by
  intro N _ s
  exact regProd_topright_polygon N s

/-- C21: the register matrix is upper triangular with unit diagonal. -/
theorem comp_register_matrix {N : ℕ} (hN : 1 < N) (s : ℝ) (m : ℕ) :
    (regMat N s m) 0 0 = 1 ∧ (regMat N s m) 1 0 = 0 ∧ (regMat N s m) 1 1 = 1 := by
  simp [regMat]

/-- C13: the Davenport–Heilbronn word is odd and mean-zero, with `a₅ = 0`. -/
theorem comp_dh_word :
    (∀ r : Fin 5, dhCoeff (3 - r) = -dhCoeff r) ∧
      (∑ r : Fin 5, dhCoeff r) = 0 ∧ dhCoeff 4 = 0 :=
  ⟨dhCoeff_odd, dhCoeff_mean_zero, dhCoeff_five⟩

/-- C23: `0 < ξ < 1`. -/
theorem comp_dh_xi_bounds : 0 < dhXi ∧ dhXi < 1 :=
  ⟨dhXi_pos, dhXi_lt_one⟩

/-! ## C25–C26: the Bourgain threshold -/

/-- C25: the threshold equivalence on sample values. -/
theorem comp_bourgain_samples :
    ∀ ε ∈ ({1 / 20, 13 / 194, 1 / 10, 1 / 6, 1 / 3} : Finset ℚ),
      ((1 / 2 - (ε : ℝ)) * (13 / 84) < (ε : ℝ) ↔ (13 / 194 : ℝ) < (ε : ℝ)) := by
  intro ε _
  exact bourgain_threshold_iff _

/-- C26: below the threshold the Bourgain exponent does not beat the target. -/
theorem comp_bourgain_below {ε : ℝ} (h : ε < 13 / 194) :
    ε ≤ (1 / 2 - ε) * (13 / 84) := by
  nlinarith

/-- The exact ratio `L_N(σ)/N^(1-2σ) = 1/2 - 1/(2N)` (the content of T24,
restated here because `Breakthrough.lean` is not imported). -/
theorem lastChordAbs_ratio' {N : ℕ} (hN : 1 ≤ N) (σ : ℝ) :
    lastChordAbs N σ / (N : ℝ) ^ (1 - 2 * σ) = 1 / 2 - 1 / (2 * (N : ℝ)) := by
  unfold lastChordAbs
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hN)
  have hNne : (N : ℝ) ≠ 0 := ne_of_gt hNpos
  have hpow : (N : ℝ) ^ (-2 * σ) = (N : ℝ) ^ (1 - 2 * σ) / (N : ℝ) := by
    rw [show (-2 * σ : ℝ) = (1 - 2 * σ) - 1 by ring, Real.rpow_sub hNpos, Real.rpow_one]
  rw [hpow]
  field_simp

/-- C16: the exact ratio on the recorded grid. -/
theorem comp_lastChord_ratio :
    ∀ N ∈ ({2, 3, 5} : Finset ℕ),
      ∀ σ ∈ ({1 / 3, 1 / 2, 2 / 3} : Finset ℚ),
        lastChordAbs N (σ : ℝ) / (N : ℝ) ^ (1 - 2 * (σ : ℝ)) =
          1 / 2 - 1 / (2 * (N : ℝ)) := by
  intro N hN σ _
  have h1 : 1 ≤ N := by
    have hmem := hN
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with rfl | rfl | rfl <;> norm_num
  exact lastChordAbs_ratio' h1 (σ : ℝ)

/-! ## C15: the asymptotic classes at `N = 10^10` -/

/-- C15: the critical-line value at `N = 10^10` is within `10^-5` of `1/2`. -/
theorem comp_lastChord_half_value :
    |lastChordAbs (10 ^ 10) (1 / 2) - 1 / 2| < 1 / 100000 := by
  unfold lastChordAbs
  norm_num

/-- C15: the left-half value at `N = 10^10` blows up. -/
theorem comp_lastChord_left_value :
    100 < lastChordAbs (10 ^ 10) (1 / 4) := by
  unfold lastChordAbs
  norm_num

/-- C15: the right-half value at `N = 10^10` is small. -/
theorem comp_lastChord_right_value :
    lastChordAbs (10 ^ 10) (3 / 4) < 1 / 100000 := by
  unfold lastChordAbs
  norm_num

/-- C15: the two twins behave oppositely at `N = 10^10`. -/
theorem comp_lastChord_twins :
    lastChordAbs (10 ^ 10) (1 / 4) > 100 ∧
      lastChordAbs (10 ^ 10) (3 / 4) < 1 / 100000 :=
  ⟨comp_lastChord_left_value, comp_lastChord_right_value⟩


/-! ## C11: the corrected local diagonal -/

/-- The normalized quartic `f(u) = (3/4)(1-u²)` has integral `1`. -/
theorem quartic_integral_one :
    (∫ u in (-1)..1, (3 / 4 : ℝ) * (1 - u ^ 2)) = 1 := by
  norm_num [integral_add, integral_sub,
    integral_const, integral_pow]

/-- The normalized quartic has `∫ f² = 3/5`. -/
theorem quartic_integral_sq :
    (∫ u in (-1)..1, ((3 / 4 : ℝ) * (1 - u ^ 2)) ^ 2) = 3 / 5 := by
  have h : ∀ u : ℝ, ((3 / 4 : ℝ) * (1 - u ^ 2)) ^ 2 =
      (9 / 16 : ℝ) + (-(9 / 8)) * u ^ 2 + (9 / 16) * u ^ 4 := by
    intro u
    ring
  simp_rw [h]
  have h1 : IntervalIntegrable (fun u : ℝ => (9 / 16 : ℝ) + (-(9 / 8)) * u ^ 2)
      MeasureTheory.volume (-1) 1 :=
    (by fun_prop : Continuous fun u : ℝ => (9 / 16 : ℝ) + (-(9 / 8)) * u ^ 2).intervalIntegrable _ _
  have h2 : IntervalIntegrable (fun u : ℝ => (9 / 16 : ℝ) * u ^ 4)
      MeasureTheory.volume (-1) 1 :=
    (by fun_prop : Continuous fun u : ℝ => (9 / 16 : ℝ) * u ^ 4).intervalIntegrable _ _
  rw [integral_add h1 h2]
  have h3 : IntervalIntegrable (fun u : ℝ => (9 / 16 : ℝ)) MeasureTheory.volume (-1) 1 :=
    continuous_const.intervalIntegrable _ _
  have h4 : IntervalIntegrable (fun u : ℝ => (-(9 / 8 : ℝ)) * u ^ 2)
      MeasureTheory.volume (-1) 1 :=
    (by fun_prop : Continuous fun u : ℝ => (-(9 / 8 : ℝ)) * u ^ 2).intervalIntegrable _ _
  rw [integral_add h3 h4]
  rw [integral_const, integral_const_mul,
    integral_pow, integral_const_mul,
    integral_pow]
  norm_num

/-- C11: for the normalized quartic the corrected local diagonal is
`-1 + R·(3/5)`, not the withdrawn `-1/2`. -/
theorem comp_local_diagonal_quartic (R : ℝ) :
    (∫ u in (-1)..1, (1 - R * ((3 / 4 : ℝ) * (1 - u ^ 2))) * (-((3 / 4 : ℝ) * (1 - u ^ 2)))) =
      -1 + R * (3 / 5) := by
  rw [local_diagonal_identity _ (by fun_prop) R]
  rw [quartic_integral_sq, quartic_integral_one]

/-- C11: the unnormalized input `u²` is rejected by the normalization test,
since `∫u² = 2/3 ≠ 1`. -/
theorem comp_local_diagonal_unnormalized :
    (∫ u in (-1)..1, (u : ℝ) ^ 2) = 2 / 3 ∧ (2 / 3 : ℝ) ≠ 1 := by
  constructor
  · norm_num [integral_pow]
  · norm_num

/-! ## C22: the heat-flow derivative at `τ = 0` -/

/-- The complex exponential of a real multiple has the expected derivative. -/
theorem hasDerivAt_cexp_mul_const (a : ℝ) :
    HasDerivAt (fun τ : ℝ => Complex.exp (τ * a)) (a : ℂ) 0 := by
  have hinner : HasDerivAt (fun z : ℂ => z * (a : ℂ)) (a : ℂ) 0 := by
    simpa using (hasDerivAt_id (0 : ℂ)).mul_const (a : ℂ)
  have houter : HasDerivAt (fun z : ℂ => Complex.exp (z * (a : ℂ))) (a : ℂ) 0 := by
    have h := HasDerivAt.comp (x := (0 : ℂ)) (h := fun z : ℂ => z * (a : ℂ))
      (h₂ := Complex.exp) (Complex.hasDerivAt_exp (0 * (a : ℂ))) hinner
    convert h using 1
    · ext z
      rfl
    · simp
  have hrestrict := houter.comp_ofReal (z := (0 : ℝ))
  simpa using hrestrict

/-- C22: the first heat-flow derivative at `τ = 0`. -/
theorem comp_heatFlow_deriv (N : ℕ) (s : ℂ) :
    deriv (fun τ : ℝ => heatFlowed N τ s) 0 =
      ∑ m ∈ Finset.Icc 1 (N * N),
        (filterCoeff N m : ℂ) * ((Real.log m) ^ 2 : ℂ) * (m : ℂ) ^ (-s) := by
  have hterm : ∀ m ∈ Finset.Icc 1 (N * N), HasDerivAt
      (fun τ : ℝ => (filterCoeff N m : ℂ) * Complex.exp (τ * (Real.log m) ^ 2) * (m : ℂ) ^ (-s))
      ((filterCoeff N m : ℂ) * ((Real.log m) ^ 2 : ℂ) * (m : ℂ) ^ (-s)) 0 := by
    intro m _
    have hexp := hasDerivAt_cexp_mul_const ((Real.log m) ^ 2)
    have hmul := (hexp.const_mul (filterCoeff N m : ℂ)).mul_const ((m : ℂ) ^ (-s))
    convert hmul using 1
    · ext τ
      push_cast
      ring
    · push_cast
      ring
  have hsum := HasDerivAt.sum (u := Finset.Icc 1 (N * N))
    (A := fun m τ => (filterCoeff N m : ℂ) * Complex.exp (τ * (Real.log m) ^ 2) * (m : ℂ) ^ (-s))
    (A' := fun m => (filterCoeff N m : ℂ) * ((Real.log m) ^ 2 : ℂ) * (m : ℂ) ^ (-s))
    (x := (0 : ℝ)) hterm
  have hsum' : HasDerivAt (fun τ : ℝ => ∑ m ∈ Finset.Icc 1 (N * N),
      (filterCoeff N m : ℂ) * Complex.exp (τ * (Real.log m) ^ 2) * (m : ℂ) ^ (-s))
      (∑ m ∈ Finset.Icc 1 (N * N),
        (filterCoeff N m : ℂ) * ((Real.log m) ^ 2 : ℂ) * (m : ℂ) ^ (-s)) 0 := by
    convert hsum using 1
    ext τ
    simp
  simpa [heatFlowed] using hsum'.deriv

/-! ## C27–C30: the no-go computations -/

/-- C27: the `N = 2` polygon at `s = -1` is `-2`. -/
theorem comp_eta_two : etaAtNegOne 2 = -2 := etaAtNegOne_two

/-- C28: a concrete nonnegative matrix product stays entrywise nonnegative. -/
theorem comp_matProd_nonneg :
    ∀ i j, 0 ≤ (matProd
      [!![1, 2; 3, 4], !![2, 1; 3, 5]] : Matrix (Fin 2) (Fin 2) ℝ) i j := by
  apply matProd_nonneg
  intro A hA i j
  simp only [List.mem_cons, List.mem_nil_iff, or_false] at hA
  rcases hA with rfl | rfl <;> fin_cases i <;> fin_cases j <;> norm_num

/-- C29: a concrete nonnegative contraction is nonnegative. -/
theorem comp_contraction_nonneg :
    0 ≤ contraction (fun i : Fin 2 => (1 : ℝ)) (fun j : Fin 2 => (1 : ℝ))
      (matProd [!![1, 2; 3, 4], !![2, 1; 3, 5]] : Matrix (Fin 2) (Fin 2) ℝ) := by
  apply contraction_nonneg
  · intro A hA i j
    simp only [List.mem_cons, List.mem_nil_iff, or_false] at hA
    rcases hA with rfl | rfl <;> fin_cases i <;> fin_cases j <;> norm_num
  · intro i; norm_num
  · intro j; norm_num

/-- C30: no nonnegative contraction can hit `-2`. -/
theorem comp_no_rep_minus_two :
    ¬ ∃ (L : List (Matrix (Fin 2) (Fin 2) ℝ)) (u w : Fin 2 → ℝ),
      (∀ A ∈ L, ∀ i j, 0 ≤ A i j) ∧
      (∀ i, 0 ≤ u i) ∧ (∀ j, 0 ≤ w j) ∧
      contraction u w (matProd L) = -2 :=
  no_nonneg_matrix_product_rep_of_neg (by norm_num)

/-! ## C32–C35: the signed gauge -/

/-- C32: the signed gauge and its inverse compose to the identity. -/
theorem comp_gauge_inverse :
    signedGauge * signedGaugeInv = 1 ∧ signedGaugeInv * signedGauge = 1 :=
  ⟨signedGauge_mul_inv, signedGauge_inv_mul⟩

/-- C33: the gauged first matrix is not upper triangular. -/
theorem comp_gauge_non_triangular :
    (signedGaugeInv * signedRegMat 2 1 * signedGauge) 1 0 = -1 ∧
      (signedGaugeInv * signedRegMat 2 1 * signedGauge) 1 0 ≠ 0 :=
  ⟨signedGauge_nonTriangular, signedGauge_nonTriangular_ne_zero⟩

/-! ## C37–C40: the finite Lee–Yang computations -/

/-- C37: every zero of the two-spin partition function lies on the unit circle. -/
theorem comp_ising_lee_yang {K : ℝ} (hK : 0 < K) {z : ℂ}
    (hz : ising2Partition K z = 0) : Complex.normSq z = 1 :=
  ising2_lee_yang hK hz

/-- C38: a non-real root is accompanied by its conjugate. -/
theorem comp_ising_conjugate {K : ℝ} {z : ℂ}
    (hz : ising2Partition K z = 0) :
    ising2Partition K (starRingEnd ℂ z) = 0 := by
  have h : ising2Partition K (starRingEnd ℂ z) = starRingEnd ℂ (ising2Partition K z) := by
    unfold ising2Partition
    simp only [map_add, map_mul, map_pow, map_ofNat, Complex.conj_ofReal]
  rw [h, hz, map_zero]

/-- C38: two distinct roots multiply to `1`. -/
theorem comp_ising_product {K : ℝ} (hK : 0 < K) {z w : ℂ}
    (hz : ising2Partition K z = 0) (hw : ising2Partition K w = 0) (hne : z ≠ w) :
    z * w = 1 := by
  set a : ℂ := (Real.exp K : ℂ) with ha
  have ha0 : a ≠ 0 := by
    rw [ha]
    exact_mod_cast (Real.exp_ne_zero K)
  have hz' : a * z ^ 2 + 2 * z + a = 0 := hz
  have hw' : a * w ^ 2 + 2 * w + a = 0 := hw
  have hdiff : (z - w) * (a * (z + w) + 2) = 0 := by
    linear_combination hz' - hw'
  have hsum : a * (z + w) + 2 = 0 := by
    rcases mul_eq_zero.mp hdiff with h | h
    · exact absurd (sub_eq_zero.mp h) hne
    · exact h
  have hprod : a * (1 - z * w) = 0 := by
    linear_combination hz' - z * hsum
  have : 1 - z * w = 0 := (mul_eq_zero.mp hprod).resolve_left ha0
  linear_combination -this

/-- C39: the partition function vanishes at any of its roots (definitional). -/
theorem comp_ising_vanishes {K : ℝ} {z : ℂ} (hz : ising2Partition K z = 0) :
    ising2Partition K z = 0 := hz

/-- C40: there are no real roots for positive coupling. -/
theorem comp_ising_no_real {K : ℝ} (hK : 0 < K) (x : ℝ) :
    ising2Partition K (x : ℂ) ≠ 0 := by
  intro h
  have ha : 0 < Real.exp K := Real.exp_pos K
  have hb0 : (0 : ℝ) < 2 := by norm_num
  have hb2 : (2 : ℝ) < 2 * Real.exp K := by
    nlinarith [Real.one_lt_exp_iff.mpr hK]
  have hpow : (↑x ^ 2 : ℂ).re = x ^ 2 := by
    rw [pow_two, Complex.mul_re]
    simp [Complex.ofReal_re, Complex.ofReal_im]
    ring
  have hre : Real.exp K * x ^ 2 + 2 * x + Real.exp K = 0 := by
    have h' := congrArg Complex.re h
    simp [ising2Partition, Complex.mul_re, Complex.add_re, Complex.exp_ofReal_re,
      Complex.ofReal_re, hpow] at h'
    exact h'
  exact quadratic_no_real_root ha hb0 hb2 hre

/-! ## C41–C44: the geometric model -/

def geomTotal (q : ℚ) : ℚ := 1 / (1 - q)
def geomPartial (q : ℚ) (K : ℕ) : ℚ := ∑ n ∈ Finset.range K, q ^ n
def geomTail (q : ℚ) (K : ℕ) : ℚ := q ^ K / (1 - q)

/-- C41: the finite partial sum plus the shifted tail is the total. -/
theorem comp_geom_partial_add_tail {q : ℚ} (hq : q ≠ 1) (K : ℕ) :
    geomPartial q K + geomTail q K = geomTotal q := by
  rw [geomPartial, geomTail, geomTotal, geom_sum_eq hq]
  have h1 : (1 : ℚ) - q ≠ 0 := by intro h; apply hq; linarith
  have h2 : q - 1 ≠ 0 := by intro h; apply hq; linarith
  field_simp [h1, h2]
  ring

/-- C42: the truncation residual equals the tail. -/
theorem comp_geom_residual {q : ℚ} (hq : q ≠ 1) (K : ℕ) :
    geomTotal q - geomPartial q K = geomTail q K := by
  have := comp_geom_partial_add_tail hq K
  linarith

/-- C43: the residual is bounded by the tail norm (equality here). -/
theorem comp_geom_residual_bound {q : ℚ} (hq : q ≠ 1) (K : ℕ) :
    |geomTotal q - geomPartial q K| ≤ |geomTail q K| := by
  rw [comp_geom_residual hq K]

/-- C44: the three-tail Route C bound on the recorded real data. -/
theorem comp_three_tail_real :
    ‖(10 : ℂ) - 6‖ ≤ ‖(1 : ℂ)‖ + ‖(2 : ℂ)‖ + ‖(1 : ℂ)‖ := by
  have h := truncation_residual_le_three_tails (lhs := (10 : ℂ)) (rhsTrue := (10 : ℂ))
    (rhsComputed := (6 : ℂ)) (zeroTail := (1 : ℂ)) (primeTail := (2 : ℂ))
    (archTail := (1 : ℂ)) rfl (by ring)
  simpa using h

/-- C44: the three-tail Route C bound on the recorded complex data. -/
theorem comp_three_tail_complex :
    ‖(5 : ℂ) + Complex.I - 3‖ ≤ ‖(1 : ℂ)‖ + ‖Complex.I‖ + ‖(1 : ℂ)‖ := by
  have h := truncation_residual_le_three_tails (lhs := (5 : ℂ) + Complex.I) (rhsTrue := (5 : ℂ) + Complex.I)
    (rhsComputed := (3 : ℂ)) (zeroTail := (1 : ℂ)) (primeTail := Complex.I)
    (archTail := (1 : ℂ)) rfl (by ring)
  simpa using h


/-! ## C14: the complex last chord -/

/-- C14: the complex twin product. -/
theorem comp_complex_last_chord {N : ℕ} (hN : 1 < N) (s : ℂ) :
    lastChord N s * lastChord N (1 - s) =
      ((N : ℂ) - 1) ^ 2 / (4 * (N : ℂ) ^ 2) :=
  lastChord_mul_twin_complex hN s

/-- C14 at the recorded point `s = 1/3 + 2i`. -/
theorem comp_complex_last_chord_point :
    lastChord 3 ((1 / 3 : ℂ) + 2 * Complex.I) *
      lastChord 3 (1 - ((1 / 3 : ℂ) + 2 * Complex.I)) =
      ((3 : ℂ) - 1) ^ 2 / (4 * (3 : ℂ) ^ 2) :=
  lastChord_mul_twin_complex (by norm_num) _

/-! ## C31/C36: the domain guards -/

/-- A matrix is entrywise nonnegative. -/
def EntrywiseNonneg {ι : Type*} (A : Matrix ι ι ℝ) : Prop := ∀ i j, 0 ≤ A i j

/-- C31: a matrix with a negative entry fails the nonnegative-entry guard. -/
theorem comp_invalid_entries :
    ¬ EntrywiseNonneg (!![1, -1; 0, 1] : Matrix (Fin 2) (Fin 2) ℝ) := by
  intro h
  have := h 0 1
  norm_num at this

/-- C31: a boundary vector with a negative entry fails the sign guard. -/
theorem comp_invalid_boundary :
    ¬ (∀ i : Fin 2, 0 ≤ (![1, -1] : Fin 2 → ℝ) i) := by
  intro h
  have := h 1
  norm_num at this

/-- The advertised period domain of the Python layer. -/
def ValidPeriod (N : ℕ) : Prop := 2 ≤ N

/-- C36: the invalid periods `0` and `1` are outside the advertised domain. -/
theorem comp_invalid_period : ¬ ValidPeriod 0 ∧ ¬ ValidPeriod 1 := by
  constructor <;> simp [ValidPeriod]

/-! ## C34–C35: gauge-invariant signed contraction -/

/-- Contraction of a matrix product with two boundary vectors. -/
def contractionVec {ι : Type*} [Fintype ι] (u w : ι → ℝ) (P : Matrix ι ι ℝ) : ℝ :=
  dotProduct u (P.mulVec w)

/-- C34, general form: a constant gauge preserves the contraction when the
boundary vectors are transformed by `Sᵀ` and `S⁻¹`. -/
theorem gauge_contractionVec {ι : Type*} [Fintype ι] [DecidableEq ι]
    (S Sinv P : Matrix ι ι ℝ) (u w : ι → ℝ) (hS : S * Sinv = 1) :
    contractionVec (S.transpose.mulVec u) (Sinv.mulVec w) (Sinv * P * S) =
      contractionVec u w P := by
  unfold contractionVec
  rw [dotProduct_comm, Matrix.dotProduct_transpose_mulVec, dotProduct_comm]
  have hm : (S * (Sinv * P * S)) * Sinv = P := by
    calc (S * (Sinv * P * S)) * Sinv = (S * Sinv) * P * (S * Sinv) := by noncomm_ring
      _ = 1 * P * 1 := by rw [hS]
      _ = P := by simp
  have hvec : S.mulVec ((Sinv * P * S).mulVec (Sinv.mulVec w)) = P.mulVec w := by
    rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, hm]
  rw [hvec, dotProduct_comm]

/-- The real signed gauge `[[1,1],[1,2]]`. -/
def signedGaugeR : Matrix (Fin 2) (Fin 2) ℝ := !![1, 1; 1, 2]

/-- The real inverse of `signedGaugeR`. -/
def signedGaugeInvR : Matrix (Fin 2) (Fin 2) ℝ := !![2, -1; -1, 1]

theorem signedGaugeR_mul_inv : signedGaugeR * signedGaugeInvR = 1 := by
  ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [signedGaugeR, signedGaugeInvR]

/-- C34 on the signed gauge. -/
theorem comp_gauge_contraction (P : Matrix (Fin 2) (Fin 2) ℝ) (u w : Fin 2 → ℝ) :
    contractionVec (signedGaugeR.transpose.mulVec u) (signedGaugeInvR.mulVec w)
      (signedGaugeInvR * P * signedGaugeR) = contractionVec u w P :=
  gauge_contractionVec _ _ _ _ _ signedGaugeR_mul_inv

/-- C35: the gauged signed contraction reproduces the polygon value. -/
theorem comp_signed_representation (N : ℕ) (hN : 1 < N) :
    contractionVec (signedGaugeR.transpose.mulVec (![1, 0] : Fin 2 → ℝ))
      (signedGaugeInvR.mulVec (![0, 1] : Fin 2 → ℝ))
      (signedGaugeInvR * regProd N 1 (N * N) * signedGaugeR) =
      (regProd N 1 (N * N)) 0 1 := by
  rw [comp_gauge_contraction]
  simp [contractionVec, dotProduct, Matrix.mulVec, Fin.sum_univ_two]

end GeoDQPT
