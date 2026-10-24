/-
  DirichletPrimeTail.lean — **prime-tail bounds, proved**, for the Dirichlet
  explicit formula.

  The prime side of the explicit formula is
  `∑_n (Λ(n) χ(n)/√n)(g(log n) + g(−log n))`.  `DirichletExplicit.lean` defines it;
  this file proves Chebyshev bounds on its remainder.

  Mathlib supplies the ingredients unconditionally:
  `ArithmeticFunction.vonMangoldt_nonneg`, `DirichletCharacter.norm_le_one`, and
  Chebyshev's `Chebyshev.psi_le_const_mul_self` (`ψ x ≤ (log 4 + 4) x`).

  The first theorem bounds a *finite* remainder by Abel-free comparison: for
  `n > K`, `Λ(n)/√n ≤ Λ(n)/√K`, and `∑_{n≤nmax} Λ n = ψ nmax ≤ (log 4+4) nmax`.
  The second keeps a `n^{-1/2}` decay of the weight, so the remainder is `O(K^{-1})`
  uniformly in `nmax` — the block-level form of the numerical tail bound.
-/
import DirichletExplicit
import Mathlib.NumberTheory.Chebyshev
import Mathlib.NumberTheory.DirichletCharacter.Bounds

namespace RouteABC

noncomputable section

open scoped BigOperators ArithmeticFunction.vonMangoldt

/-- The norm of a real cast into `ℂ`. -/
theorem norm_ofReal_coe (x : ℝ) : ‖(x : ℂ)‖ = ‖x‖ := by
  rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two, Real.sqrt_sq_eq_abs,
    Real.norm_eq_abs]

/-- The weight `dirichletWeight χ n` is dominated by `Λ n` in norm, because `Λ n ≥ 0`
and `‖χ n‖ ≤ 1`. -/
theorem norm_dirichletWeight_le {N : ℕ} (χ : DirichletCharacter ℂ N) (n : ℕ) :
    ‖dirichletWeight χ n‖ ≤ Λ n := by
  rw [dirichletWeight_def, norm_mul,
    Complex.norm_of_nonneg ArithmeticFunction.vonMangoldt_nonneg]
  calc Λ n * ‖χ n‖ ≤ Λ n * 1 :=
        mul_le_mul_of_nonneg_left (DirichletCharacter.norm_le_one (χ := χ) (n : ZMod N))
          ArithmeticFunction.vonMangoldt_nonneg
    _ = Λ n := mul_one _

/-- `∑_{n ∈ Icc 0 nmax} Λ n ≤ (log 4 + 4) nmax`, from Mathlib's Chebyshev bound. -/
theorem sum_vonMangoldt_le (nmax : ℕ) :
    ∑ n ∈ Finset.Icc 0 nmax, Λ n ≤ (Real.log 4 + 4) * (nmax : ℝ) := by
  have hpsi := Chebyshev.psi_eq_sum_Icc (nmax : ℝ)
  simp only [Nat.floor_natCast] at hpsi
  rw [← hpsi]
  exact Chebyshev.psi_le_const_mul_self (by positivity)

/-- **Chebyshev bound on the `+log` prime remainder, finite range.**
For `1 ≤ K` and `‖g (log n)‖ ≤ D`,

    ‖∑_{K<n≤nmax} (Λ(n)χ(n)/√n) g(log n)‖ ≤ D (log 4 + 4) nmax / √K. -/
theorem dirichletPrimeSideLog_remainder_le {N : ℕ} (χ : DirichletCharacter ℂ N)
    {K nmax : ℕ} (hK : 1 ≤ K) (g : ℝ → ℝ) {D : ℝ} (hD : 0 ≤ D)
    (hg : ∀ n : ℕ, ‖g (Real.log n)‖ ≤ D) :
    ‖∑ n ∈ Finset.Icc (K + 1) nmax,
        dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)‖
      ≤ D * (Real.log 4 + 4) * (nmax : ℝ) / Real.sqrt K := by
  have hKpos : (0 : ℝ) < Real.sqrt K := Real.sqrt_pos.mpr (by exact_mod_cast hK)
  have hterm : ∀ n ∈ Finset.Icc (K + 1) nmax,
      ‖dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)‖
        ≤ Λ n * D / Real.sqrt K := by
    intro n hn
    have hnK : K + 1 ≤ n := (Finset.mem_Icc.mp hn).1
    have hn1 : 1 ≤ n := le_trans hK (le_trans (Nat.le_succ K) hnK)
    have hnR : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn1
    have hsqrtK : Real.sqrt K ≤ Real.sqrt n :=
      Real.sqrt_le_sqrt (by exact_mod_cast (le_trans (Nat.le_succ K) hnK))
    have hsqrtn : (0 : ℝ) < Real.sqrt n := Real.sqrt_pos.mpr hnR
    calc ‖dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)‖
        = ‖dirichletWeight χ n‖ / Real.sqrt n * ‖g (Real.log n)‖ := by
          rw [norm_mul, norm_div, Complex.norm_of_nonneg (Real.sqrt_nonneg n),
            norm_ofReal_coe]
      _ ≤ Λ n / Real.sqrt n * D :=
          mul_le_mul (div_le_div_of_nonneg_right (norm_dirichletWeight_le χ n)
            (le_of_lt hsqrtn)) (hg n) (norm_nonneg _) (by positivity)
      _ ≤ Λ n * D / Real.sqrt K := by
          rw [div_mul_eq_mul_div]
          exact div_le_div_of_nonneg_left (by positivity) hKpos hsqrtK
  calc ‖∑ n ∈ Finset.Icc (K + 1) nmax, _‖
      ≤ ∑ n ∈ Finset.Icc (K + 1) nmax, ‖_‖ := norm_sum_le _ _
    _ ≤ ∑ n ∈ Finset.Icc (K + 1) nmax, Λ n * D / Real.sqrt K :=
        Finset.sum_le_sum hterm
    _ = (D / Real.sqrt K) * ∑ n ∈ Finset.Icc (K + 1) nmax, Λ n := by
        rw [Finset.mul_sum]; refine Finset.sum_congr rfl fun n _ => ?_; ring
    _ ≤ (D / Real.sqrt K) * ((Real.log 4 + 4) * (nmax : ℝ)) := by
        refine mul_le_mul_of_nonneg_left ?_ (by positivity)
        refine (Finset.sum_le_sum_of_subset_of_nonneg ?_
          (fun i _ _ => ArithmeticFunction.vonMangoldt_nonneg)).trans (sum_vonMangoldt_le nmax)
        intro n hn; obtain ⟨_, h2⟩ := Finset.mem_Icc.mp hn
        exact Finset.mem_Icc.mpr ⟨Nat.zero_le n, h2⟩
    _ = D * (Real.log 4 + 4) * (nmax : ℝ) / Real.sqrt K := by ring

/-- **Decaying form.**  If `‖g (log n)‖ ≤ D / √n` for `n > K`, the remainder is
bounded by `D (log 4 + 4) nmax / K`. -/
theorem dirichletPrimeSideLog_remainder_le_decay {N : ℕ} (χ : DirichletCharacter ℂ N)
    {K nmax : ℕ} (hK : 1 ≤ K) (g : ℝ → ℝ) {D : ℝ} (hD : 0 ≤ D)
    (hg : ∀ n : ℕ, ‖g (Real.log n)‖ ≤ D / Real.sqrt n) :
    ‖∑ n ∈ Finset.Icc (K + 1) nmax,
        dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)‖
      ≤ D * (Real.log 4 + 4) * (nmax : ℝ) / K := by
  have hKpos : (0 : ℝ) < (K : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hK)
  have hterm : ∀ n ∈ Finset.Icc (K + 1) nmax,
      ‖dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)‖
        ≤ Λ n * D / K := by
    intro n hn
    have hnK : K + 1 ≤ n := (Finset.mem_Icc.mp hn).1
    have hn1 : 1 ≤ n := le_trans hK (le_trans (Nat.le_succ K) hnK)
    have hnR : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn1
    have hnK' : (K : ℝ) ≤ (n : ℝ) := by exact_mod_cast (le_trans (Nat.le_succ K) hnK)
    have hsqrtn : (0 : ℝ) < Real.sqrt n := Real.sqrt_pos.mpr hnR
    calc ‖dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ)‖
        = ‖dirichletWeight χ n‖ / Real.sqrt n * ‖g (Real.log n)‖ := by
          rw [norm_mul, norm_div, Complex.norm_of_nonneg (Real.sqrt_nonneg n),
            norm_ofReal_coe]
      _ ≤ Λ n / Real.sqrt n * (D / Real.sqrt n) :=
          mul_le_mul (div_le_div_of_nonneg_right (norm_dirichletWeight_le χ n)
            (le_of_lt hsqrtn)) (hg n) (norm_nonneg _) (by positivity)
      _ = Λ n * D / (n : ℝ) := by
          rw [div_mul_div_comm, Real.mul_self_sqrt (le_of_lt hnR)]
      _ ≤ Λ n * D / (K : ℝ) :=
          div_le_div_of_nonneg_left (by positivity) hKpos hnK'
      _ = Λ n * D / K := by ring
  calc ‖∑ n ∈ Finset.Icc (K + 1) nmax, _‖
      ≤ ∑ n ∈ Finset.Icc (K + 1) nmax, ‖_‖ := norm_sum_le _ _
    _ ≤ ∑ n ∈ Finset.Icc (K + 1) nmax, Λ n * D / K := Finset.sum_le_sum hterm
    _ = (D / K) * ∑ n ∈ Finset.Icc (K + 1) nmax, Λ n := by
        rw [Finset.mul_sum]; refine Finset.sum_congr rfl fun n _ => ?_; ring
    _ ≤ (D / K) * ((Real.log 4 + 4) * (nmax : ℝ)) := by
        refine mul_le_mul_of_nonneg_left ?_ (by positivity)
        refine (Finset.sum_le_sum_of_subset_of_nonneg ?_
          (fun i _ _ => ArithmeticFunction.vonMangoldt_nonneg)).trans (sum_vonMangoldt_le nmax)
        intro n hn; obtain ⟨_, h2⟩ := Finset.mem_Icc.mp hn
        exact Finset.mem_Icc.mpr ⟨Nat.zero_le n, h2⟩
    _ = D * (Real.log 4 + 4) * (nmax : ℝ) / K := by ring

/-- **Full prime-side remainder, both `±log` halves.**  For an even `g` with
`‖g (log n)‖ ≤ D / √n`, the whole remainder of the Dirichlet prime side is bounded by
`2 D (log 4 + 4) nmax / K`. -/
theorem dirichletPrimeSide_remainder_le_decay {N : ℕ} (χ : DirichletCharacter ℂ N)
    {K nmax : ℕ} (hK : 1 ≤ K) (g : ℝ → ℝ) {D : ℝ} (hD : 0 ≤ D)
    (hg : ∀ n : ℕ, ‖g (Real.log n)‖ ≤ D / Real.sqrt n)
    (heven : ∀ u : ℝ, g (-u) = g u) :
    ‖∑ n ∈ Finset.Icc (K + 1) nmax,
        dirichletWeight χ n / (Real.sqrt n : ℂ)
          * ((g (Real.log n) : ℂ) + (g (-(Real.log n)) : ℂ))‖
      ≤ 2 * D * (Real.log 4 + 4) * (nmax : ℝ) / K := by
  have hsum : ∑ n ∈ Finset.Icc (K + 1) nmax,
        dirichletWeight χ n / (Real.sqrt n : ℂ)
          * ((g (Real.log n) : ℂ) + (g (-(Real.log n)) : ℂ))
      = (∑ n ∈ Finset.Icc (K + 1) nmax,
          dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (Real.log n) : ℂ))
        + (∑ n ∈ Finset.Icc (K + 1) nmax,
          dirichletWeight χ n / (Real.sqrt n : ℂ) * (g (-(Real.log n)) : ℂ)) := by
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun n _ => ?_; ring
  have hneg : ∀ n : ℕ, ‖g (-(Real.log n))‖ ≤ D / Real.sqrt n := by
    intro n; rw [heven (Real.log n)]; exact hg n
  rw [hsum]
  calc ‖_ + _‖ ≤ _ := norm_add_le _ _
    _ ≤ D * (Real.log 4 + 4) * (nmax : ℝ) / K
          + D * (Real.log 4 + 4) * (nmax : ℝ) / K :=
        add_le_add (dirichletPrimeSideLog_remainder_le_decay χ hK g hD hg)
          (dirichletPrimeSideLog_remainder_le_decay χ hK (fun u => g (-u)) hD hneg)
    _ = 2 * D * (Real.log 4 + 4) * (nmax : ℝ) / K := by ring

end

end RouteABC
