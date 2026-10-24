/-
  Op57/Blocks.lean — the character-sum regrouping that replaces the parity sieve.

  The parity sieve in the programme is the coefficient sequence `c m = 1_{2|m}`;
  the character-sum replacement is an arbitrary periodic `c`.  The single
  structural identity is

      F_r(x) = Σ_{j≥1} c(r+j) x^j = f_r(x) / (1 − x^q) ,
      f_r(x) = Σ_{s=1}^{q} c(r+s) x^s .

  It is the elementary finite Fourier / residue-class regrouping: group `j` by
  `j = kq + s`.  It converts the (divergent at `x=1`) geometric series `Σ x^j`
  of OP-5 into a *bounded character sum* whenever `c` has zero mean over its
  period, which is exactly the mechanism that can destroy the threshold.
-/

import Op57.Defs

set_option linter.style.haveILetI false

namespace Op57

noncomputable section

open scoped BigOperators Topology

open Filter

/-- A periodic coefficient depends only on `m % q`. -/
theorem periodic_mod {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q) (hc : ∀ m, c (m + q) = c m) :
    ∀ m, c m = c (m % q) := by
  intro m
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    rcases lt_or_ge m q with hm | hm
    · rw [Nat.mod_eq_of_lt hm]
    · have h1 : c m = c (m - q) := by
        have hmq : m = (m - q) + q := by omega
        conv_lhs => rw [hmq]
        exact hc (m - q)
      have h2 : c (m - q) = c ((m - q) % q) := ih (m - q) (by omega)
      rw [h1, h2, Nat.mod_eq_sub_mod hm]

/-- Two indices congruent mod `q` have equal `c`-value. -/
theorem periodic_eq_of_mod_eq {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q)
    (hc : ∀ m, c (m + q) = c m) {m n : ℕ} (h : m % q = n % q) : c m = c n := by
  rw [periodic_mod hq hc m, periodic_mod hq hc n, h]

/-- The regrouping as a `HasSum` statement. -/
theorem hasSum_F_of_periodic {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q)
    (hc : ∀ m, c (m + q) = c m) (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    HasSum (fun j : ℕ => c (r + j + 1) * x ^ (j + 1))
      (fblock c q r x / (1 - x ^ q)) := by
  haveI : NeZero q := ⟨by omega⟩
  set g : ℕ → ℝ := fun j => c (r + j + 1) * x ^ (j + 1) with hg
  set A : Fin q → ℝ := fun s => c (r + s.val + 1) * x ^ (s.val + 1) with hA
  set B : ℕ → ℝ := fun k => (x ^ q) ^ k with hB
  have hBsum : HasSum B (1 - x ^ q)⁻¹ :=
    hasSum_geometric_of_norm_lt_one (geom_norm_lt_one hx0 hx1 hq)
  have hAsum : HasSum A (∑ s, A s) := hasSum_fintype A
  have hBnorm : Summable (fun k : ℕ => ‖B k‖) := hBsum.summable.norm
  set C : ℝ := ∑ s : Fin q, ‖A s‖ with hC
  have hCnonneg : 0 ≤ C := Finset.sum_nonneg (fun s _ => norm_nonneg (A s))
  have hCle : ∀ s : Fin q, ‖A s‖ ≤ C := fun s =>
    Finset.single_le_sum (fun i _ => norm_nonneg (A i)) (Finset.mem_univ s)
  have hcomp : Summable (fun p : Fin q × ℕ => C * ‖B p.2‖) := by
    have hfib : ∀ s : Fin q, Summable (fun k : ℕ => C * ‖B k‖) :=
      fun _ => hBnorm.mul_left C
    have hsigma : Summable (fun z : (s : Fin q) × ℕ => C * ‖B z.2‖) := by
      rw [summable_sigma_of_nonneg (f := fun z : (s : Fin q) × ℕ => C * ‖B z.2‖)
        (fun z => mul_nonneg hCnonneg (norm_nonneg _))]
      exact ⟨hfib, (hasSum_fintype (fun _ : Fin q => ∑' k : ℕ, C * ‖B k‖)).summable⟩
    exact (Equiv.summable_iff (Equiv.sigmaEquivProd (Fin q) ℕ)).mp hsigma
  have hsummable : Summable (fun p : Fin q × ℕ => A p.1 * B p.2) :=
    Summable.of_norm_bounded hcomp (fun p => by
      rw [norm_mul]
      exact mul_le_mul_of_nonneg_right (hCle p.1) (norm_nonneg _))
  have hprod : HasSum (fun p : Fin q × ℕ => A p.1 * B p.2)
      ((∑ s, A s) * (1 - x ^ q)⁻¹) := HasSum.mul hAsum hBsum hsummable
  -- swap the two coordinates
  have hswap : HasSum (fun p : ℕ × Fin q => A p.2 * B p.1)
      ((∑ s, A s) * (1 - x ^ q)⁻¹) :=
    (Equiv.hasSum_iff (Equiv.prodComm (Fin q) ℕ)).mp hprod
  -- identify the swapped function with `g ∘ e`
  have hpt : ∀ p : ℕ × Fin q, A p.2 * B p.1 = g ((Nat.divModEquiv q).symm p) := by
    intro p
    obtain ⟨k, s⟩ := p
    simp only [hA, hB, hg, Nat.divModEquiv_symm_apply]
    have hmod : (r + (k * q + (s : ℕ)) + 1) % q = (r + (s : ℕ) + 1) % q := by
      rw [show r + (k * q + (s : ℕ)) + 1 = (r + (s : ℕ) + 1) + k * q by ring]
      exact Nat.add_mul_mod_self_right _ _ _
    have hceq : c (r + (k * q + (s : ℕ)) + 1) = c (r + (s : ℕ) + 1) :=
      periodic_eq_of_mod_eq hq hc hmod
    have hexp : x ^ (k * q + (s : ℕ) + 1) = (x ^ q) ^ k * x ^ ((s : ℕ) + 1) := by
      rw [show k * q + (s : ℕ) + 1 = q * k + ((s : ℕ) + 1) by ring, geom_term]
      exact mul_comm _ _
    rw [hceq, hexp]
    ring
  have hfun : g ∘ (Nat.divModEquiv q).symm = fun p : ℕ × Fin q => A p.2 * B p.1 :=
    (funext hpt).symm
  have hfinal : HasSum g ((∑ s, A s) * (1 - x ^ q)⁻¹) := by
    refine (Equiv.hasSum_iff (Nat.divModEquiv q).symm).mp ?_
    rw [hfun]
    exact hswap
  have hfblock : (∑ s : Fin q, A s) = fblock c q r x := by
    simp only [fblock, hA]
    rw [Fin.sum_univ_eq_sum_range (fun i => c (r + i + 1) * x ^ (i + 1)) q]
  rw [hfblock, hg] at hfinal
  rwa [div_eq_mul_inv]

/-- `fblock` depends on `r` only through `r % q`. -/
theorem fblock_mod {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q) (hc : ∀ m, c (m + q) = c m)
    (r : ℕ) (x : ℝ) : fblock c q r x = fblock c q (r % q) x := by
  unfold fblock
  refine Finset.sum_congr rfl ?_
  intro s hs
  have hr : r = (r % q) + (r / q) * q := by
    rw [eq_comm, add_comm, mul_comm (r / q) q]
    exact Nat.div_add_mod r q
  have hmod : (r + s + 1) % q = (r % q + s + 1) % q := by
    have hlin : r + s + 1 = (r % q + s + 1) + (r / q) * q := by
      conv_lhs => rw [hr]
      ring
    rw [hlin, Nat.add_mul_mod_self_right]
  rw [periodic_eq_of_mod_eq hq hc hmod]

/-- The regrouping as an identity for `F`. -/
theorem F_eq_fblock {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q) (hc : ∀ m, c (m + q) = c m)
    (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    F c r x = fblock c q r x / (1 - x ^ q) :=
  (hasSum_F_of_periodic hq hc r hx0 hx1).tsum_eq

/-- `F_r` depends on `r` only through `r % q` (for a periodic coefficient). -/
theorem F_mod {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q) (hc : ∀ m, c (m + q) = c m)
    (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) : F c r x = F c (r % q) x := by
  rw [F_eq_fblock hq hc r hx0 hx1, F_eq_fblock hq hc (r % q) hx0 hx1,
    fblock_mod hq hc r x]

end

end Op57
