import Mathlib

/-!
# Geometric DQPT — gap bridges

Exact algebraic bridges between the canonical paper and its open gaps.
The analytic statements (Euler–Maclaurin remainder, tightness, the measure
limits, and the conversion of RH) are not proved here; they remain source
claims or open items.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

/-- The absolute size of the unmatched last chord
`H_N(s) = ½(1-N)N^{-2s}` at `s = σ + it`. -/
def lastChordAbs (N : ℕ) (σ : ℝ) : ℝ := ((N : ℝ) - 1) / 2 * (N : ℝ) ^ (-2 * σ)

theorem lastChordAbs_pos {N : ℕ} (hN : 1 < N) (σ : ℝ) : 0 < lastChordAbs N σ := by
  unfold lastChordAbs
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_trans Nat.zero_lt_one hN)
  have hcoef : 0 < ((N : ℝ) - 1) / 2 := by
    have : (1 : ℝ) < (N : ℝ) := by exact_mod_cast hN
    linarith
  have hpow : 0 < (N : ℝ) ^ (-2 * σ) := Real.rpow_pos_of_pos hNpos _
  positivity

theorem lastChordAbs_mul_twin {N : ℕ} (hN : 1 < N) (σ : ℝ) :
    lastChordAbs N σ * lastChordAbs N (1 - σ) = ((N : ℝ) - 1) ^ 2 / (4 * (N : ℝ) ^ 2) := by
  unfold lastChordAbs
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_trans Nat.zero_lt_one hN)
  have hpow : (N : ℝ) ^ (-2 * σ) * (N : ℝ) ^ (-2 * (1 - σ)) = (N : ℝ) ^ (-2 : ℝ) := by
    rw [← Real.rpow_add hNpos]
    ring_nf
  calc
    ((N : ℝ) - 1) / 2 * (N : ℝ) ^ (-2 * σ) *
        (((N : ℝ) - 1) / 2 * (N : ℝ) ^ (-2 * (1 - σ)))
        = (((N : ℝ) - 1) / 2) ^ 2 *
            ((N : ℝ) ^ (-2 * σ) * (N : ℝ) ^ (-2 * (1 - σ))) := by ring_nf
    _ = (((N : ℝ) - 1) / 2) ^ 2 * (N : ℝ) ^ (-2 : ℝ) := by rw [hpow]
    _ = ((N : ℝ) - 1) ^ 2 / (4 * (N : ℝ) ^ 2) := by
      rw [show (-2 : ℝ) = -(2 : ℝ) by norm_num, Real.rpow_neg (le_of_lt hNpos), Real.rpow_two]
      field_simp
      ring_nf

theorem lastChordAbs_twin_eq_iff {N : ℕ} (hN : 1 < N) (σ : ℝ) :
    lastChordAbs N σ = lastChordAbs N (1 - σ) ↔ σ = 1 / 2 := by
  unfold lastChordAbs
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_trans Nat.zero_lt_one hN)
  have hcoef : 0 < ((N : ℝ) - 1) / 2 := by
    have : (1 : ℝ) < (N : ℝ) := by exact_mod_cast hN
    linarith
  constructor
  · intro h
    have hpow : (N : ℝ) ^ (-2 * σ) = (N : ℝ) ^ (-2 * (1 - σ)) := by
      exact mul_left_cancel₀ (ne_of_gt hcoef) h
    have hexp : -2 * σ = -2 * (1 - σ) := by
      exact (Real.strictMono_rpow_of_base_gt_one (by exact_mod_cast hN)).injective hpow
    linarith
  · intro h
    subst h
    ring_nf


/-- The clock zeros of the elementary factor `1 - N^(1-s)`: they are exactly
`s = 1 - 2π i n / log N`, `n ∈ ℤ`. This is the algebraic content of Lemma F.8. -/
theorem clock_zero_iff {N : ℕ} (hN : 1 < N) (s : ℂ) :
    (N : ℂ) ^ (1 - s) = 1 ↔
      ∃ n : ℤ, s = 1 - (n * (2 * Real.pi * Complex.I)) / (Real.log N : ℂ) := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_trans Nat.zero_lt_one hN)
  have hNne : (N : ℂ) ≠ 0 := by exact_mod_cast (ne_of_gt hNpos)
  have hlog_pos : 0 < Real.log (N : ℝ) := Real.log_pos (by exact_mod_cast hN)
  have hlog_ne : (Real.log (N : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hlog_pos.ne'
  have hlog : Complex.log (N : ℂ) = (Real.log (N : ℝ) : ℂ) := by
    rw [← Complex.natCast_log]
  rw [Complex.cpow_def_of_ne_zero hNne, hlog, Complex.exp_eq_one_iff]
  constructor
  · rintro ⟨n, hn⟩
    refine ⟨n, ?_⟩
    have hdiv : 1 - s = (n * (2 * Real.pi * Complex.I)) / (Real.log (N : ℝ) : ℂ) := by
      rw [eq_div_iff hlog_ne]
      simpa [mul_comm, mul_left_comm, mul_assoc] using hn
    calc
      s = 1 - (1 - s) := by ring_nf
      _ = 1 - (n * (2 * Real.pi * Complex.I)) / (Real.log (N : ℝ) : ℂ) := by rw [hdiv]
  · rintro ⟨n, rfl⟩
    refine ⟨n, ?_⟩
    have hdiv : 1 - (1 - (n * (2 * Real.pi * Complex.I)) / (Real.log (N : ℝ) : ℂ))
        = (n * (2 * Real.pi * Complex.I)) / (Real.log (N : ℝ) : ℂ) := by ring_nf
    rw [hdiv]
    field_simp [hlog_ne]

/-- The elementary lower bound for the prefactor `P_N(s) = |1 - N^(1-s)|`:
`N^(1-σ) - 1 ≤ P_N(σ+it)`. This is the exact reverse-triangle step behind
truths.md 2.3 and the prefactor test. -/
theorem prefactor_lower_bound {N : ℕ} (hN : 1 < N) (σ t : ℝ) :
    (N : ℝ) ^ (1 - σ) - 1 ≤
      ‖(1 : ℂ) - (N : ℂ) ^ (1 - (σ + t * Complex.I))‖ := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_trans Nat.zero_lt_one hN)
  let z : ℂ := (N : ℂ) ^ (1 - (σ + t * Complex.I))
  have hnorm : ‖z‖ = (N : ℝ) ^ (1 - σ) := by
    dsimp [z]
    rw [show (N : ℂ) = ((N : ℝ) : ℂ) by norm_num]
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    simp
  have htri : |‖z‖ - ‖(1 : ℂ)‖| ≤ ‖z - 1‖ := abs_norm_sub_norm_le z 1
  have hnorm_one : ‖(1 : ℂ)‖ = 1 := by simp
  have hle : (N : ℝ) ^ (1 - σ) - 1 ≤ ‖z - 1‖ := by
    have h := htri
    rw [hnorm, hnorm_one] at h
    exact (le_abs_self _).trans h
  simpa [z, norm_sub_rev] using hle

open intervalIntegral in
/-- The corrected local diagonal of Lemma 6.3, in the form used to reject the
withdrawn nested-spheres/continuous-cone route:
`∫ (1 - R f)(-f) = -∫ f + R ∫ f²`.
The false constant `-1/2` is not assumed. -/
theorem local_diagonal_identity (f : ℝ → ℝ) (hf : Continuous f) (R : ℝ) :
    ∫ u in (-1)..1, (1 - R * f u) * (-f u) =
      - (∫ u in (-1)..1, f u) + R * (∫ u in (-1)..1, (f u) ^ 2) := by
  have hfun : ∀ u : ℝ, (1 - R * f u) * (-f u) = -f u + R * (f u) ^ 2 := by
    intro u
    ring_nf
  simp_rw [hfun]
  have hsplit :
      (∫ u in (-1)..1, (-f u + R * (f u) ^ 2)) =
        (∫ u in (-1)..1, -f u) + ∫ u in (-1)..1, R * (f u) ^ 2 := by
    apply intervalIntegral.integral_add
    · exact hf.neg.intervalIntegrable (-1) 1
    · exact ((hf.pow 2).const_mul R).intervalIntegrable (-1) 1
  rw [hsplit, intervalIntegral.integral_neg, intervalIntegral.integral_const_mul]



/-- The normalized form of Lemma 6.3: if `∫ f = 1`, the local diagonal is
`-1 + R ∫ f²`, not the withdrawn `-1/2`. -/
theorem local_diagonal_normalized (f : ℝ → ℝ) (hf : Continuous f) (R : ℝ)
    (hnormal : ∫ u in (-1)..1, f u = 1) :
    ∫ u in (-1)..1, (1 - R * f u) * (-f u) =
      -1 + R * (∫ u in (-1)..1, (f u) ^ 2) := by
  rw [local_diagonal_identity f hf R, hnormal]



/-- The Davenport–Heilbronn coefficient vector of Definition C.3:
`(a_1,...,a_5) = (1, ξ, -ξ, -1, 0)`, with
`ξ = (√(10+2√5) - 1 - √5)/2`. -/
def dhXi : ℝ := (Real.sqrt (10 + 2 * Real.sqrt 5) - 1 - Real.sqrt 5) / 2

def dhCoeff : Fin 5 → ℝ := ![1, dhXi, -dhXi, -1, 0]

/-- The Davenport–Heilbronn word is odd: `a_{5-r} = -a_r`. -/
theorem dhCoeff_odd (r : Fin 5) : dhCoeff (3 - r) = -dhCoeff r := by
  fin_cases r <;> simp [dhCoeff, dhXi]

/-- The Davenport–Heilbronn word has mean zero. -/
theorem dhCoeff_mean_zero : (∑ r : Fin 5, dhCoeff r) = 0 := by
  simp [Fin.sum_univ_succ, dhCoeff, dhXi]

/-- The coefficient on the residue class `5` is zero; this is the class that
carries the filter weight in Addendum D. -/
theorem dhCoeff_five : dhCoeff 4 = 0 := rfl



/-- The complex last chord `H_N(s) = ½(1-N)N^{-2s}`. -/
def lastChord (N : ℕ) (s : ℂ) : ℂ := ((1 - (N : ℂ)) / 2) * (N : ℂ) ^ (-2 * s)

/-- The complex twin product `H_N(s)H_N(1-s) = (N-1)²/(4N²)`. -/
theorem lastChord_mul_twin_complex {N : ℕ} (hN : 1 < N) (s : ℂ) :
    lastChord N s * lastChord N (1 - s) =
      ((N : ℂ) - 1) ^ 2 / (4 * (N : ℂ) ^ 2) := by
  unfold lastChord
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (lt_trans Nat.zero_lt_one hN)
  have hNne : (N : ℂ) ≠ 0 := by exact_mod_cast (ne_of_gt hNpos)
  have hpow : (N : ℂ) ^ (-2 * s) * (N : ℂ) ^ (-2 * (1 - s)) = (N : ℂ) ^ (-2 : ℂ) := by
    rw [← Complex.cpow_add _ _ hNne]
    congr 1
    ring
  calc
    ((1 - (N : ℂ)) / 2) * (N : ℂ) ^ (-2 * s) *
        (((1 - (N : ℂ)) / 2) * (N : ℂ) ^ (-2 * (1 - s)))
        = (((1 - (N : ℂ)) / 2) ^ 2) *
            ((N : ℂ) ^ (-2 * s) * (N : ℂ) ^ (-2 * (1 - s))) := by ring
    _ = (((1 - (N : ℂ)) / 2) ^ 2) * (N : ℂ) ^ (-2 : ℂ) := by rw [hpow]
    _ = ((N : ℂ) - 1) ^ 2 / (4 * (N : ℂ) ^ 2) := by
      rw [show (-2 : ℂ) = -(2 : ℂ) by norm_num, Complex.cpow_neg, Complex.cpow_two]
      field_simp
      ring



/-- The Davenport–Heilbronn constant is positive. -/
theorem dhXi_pos : 0 < dhXi := by
  unfold dhXi
  have hA : 0 ≤ Real.sqrt (10 + 2 * Real.sqrt 5) := Real.sqrt_nonneg _
  have hB : 0 ≤ 1 + Real.sqrt 5 := by positivity
  have hsq : (1 + Real.sqrt 5) ^ 2 < (Real.sqrt (10 + 2 * Real.sqrt 5)) ^ 2 := by
    rw [Real.sq_sqrt (by positivity)]
    have h5 : (Real.sqrt 5) ^ 2 = 5 := Real.sq_sqrt (by norm_num)
    nlinarith [Real.sqrt_nonneg 5]
  have hlt : 1 + Real.sqrt 5 < Real.sqrt (10 + 2 * Real.sqrt 5) :=
    (sq_lt_sq₀ hB hA).mp hsq
  linarith

/-- The Davenport–Heilbronn constant is less than one. -/
theorem dhXi_lt_one : dhXi < 1 := by
  unfold dhXi
  have hA : 0 ≤ Real.sqrt (10 + 2 * Real.sqrt 5) := Real.sqrt_nonneg _
  have hB : 0 ≤ 3 + Real.sqrt 5 := by positivity
  have hsq : (Real.sqrt (10 + 2 * Real.sqrt 5)) ^ 2 < (3 + Real.sqrt 5) ^ 2 := by
    rw [Real.sq_sqrt (by positivity)]
    have h5 : (Real.sqrt 5) ^ 2 = 5 := Real.sq_sqrt (by norm_num)
    nlinarith [Real.sqrt_nonneg 5]
  have hlt : Real.sqrt (10 + 2 * Real.sqrt 5) < 3 + Real.sqrt 5 :=
    (sq_lt_sq₀ hA hB).mp hsq
  linarith

/-- The Davenport–Heilbronn coefficient at `n = 2` has modulus strictly
between `0` and `1`. A single Dirichlet character has modulus `1` on units,
so this is the coefficient-level witness that the word is not one character. -/
theorem dhCoeff_two_abs_ne_one : |dhCoeff 1| ≠ 1 := by
  have hpos : 0 < dhXi := dhXi_pos
  have hlt : dhXi < 1 := dhXi_lt_one
  change |dhXi| ≠ 1
  rw [abs_of_pos hpos]
  linarith

end GeoDQPT
