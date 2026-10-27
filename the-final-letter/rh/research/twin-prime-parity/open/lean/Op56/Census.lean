/-
  Op56/Census.lean — the census layer of OP-6.

  The census theorem (rh42 Thm 10) says that, with `a_k = (2k)^{-p}` and
  `T_n = Σ_{k≥n} a_k`,

      S_1 = ⋃_{A ⊆ {1,…,n-1}} ( Σ_{k∈A} a_k + [0, T_n] )        (n = n_min(p)),
      measure(S_1) = 2^{n-1} · T_n .

  In the 0-based indexing of `Op56/Defs.lean` (`term p n = a_{n+1}`,
  `nmin p = n_min - 1`) this reads

      measure(S_1) = 2^{nmin p} · tailSum p (nmin p) .

  ## What is provided

  The census is *reflected in the definition*: `reachableMeasure` is
  `2^{nmin p} · tailSum p (nmin p)`, exactly the right-hand side of the census law, and
  `census_measure_eq` records the identity, so every consumer (in particular OP-6 in
  `Op56/Asymptotic.lean`) uses the same object as rh42.

  `reachableSum` is the sub-sum selected by an index set; the abstract set-up is
  `S_1 = {x | ∃ A, x = reachableSum p A}` (`IsReachable` in `Op56/Defs.lean`).

  **PROOF OBSTRUCTION (the census counting).**  A machine-checked proof that the
  `2^{nmin}` translates in the union are pairwise disjoint, and that their union is
  exactly the sub-sum set, is not provided.  It needs

  * `term p n > tailSum p (n+1)` for `n < nmin`, i.e. `nmin_minimal`
    (`Op56/Exact.lean`) unfolded — this gives disjointness of the translates; and
  * the measure identity for a disjoint union of `2^{nmin}` intervals of length
    `T_{nmin}`.

  The arithmetic is verified numerically to `3.9·10⁻⁶²` for thirteen exponents by
  `../../rounds/rh42/reachable.py` §2, and the identity is re-derived in
  `../OP-06-reachable-fraction.md` §1.
-/

import Op56.Exact

namespace Op56

noncomputable section

open scoped BigOperators Topology

/-- The value of the sub-sum selected by an index set `A`: `Σ_{n ∈ A} term p n`. -/
def reachableSum (p : ℕ) (A : Set ℕ) : ℝ := by
  classical
  exact ∑' n : ℕ, if n ∈ A then term p n else 0

/-- **The census identity** (rh42 Thm 10, 0-based form): the measure of the reachable
set is `2^{nmin} · tailSum p (nmin)`.  By construction `reachableMeasure` *is* that
right-hand side; the content recorded here is the equality of the two forms, the
counting proof being the documented obstruction above. -/
theorem census_measure_eq (p : ℕ) :
    reachableMeasure p = (2 : ℝ) ^ (nmin p) * tailSum p (nmin p) := rfl

/-- The census ratio: `measure / tail` is the interval count `2^{nmin p}`. -/
theorem census_ratio (p : ℕ) (hT : tailSum p (nmin p) ≠ 0) :
    reachableMeasure p / tailSum p (nmin p) = (2 : ℝ) ^ (nmin p) := by
  rw [census_measure_eq, mul_div_cancel_right₀]
  exact hT

end

end Op56
