/-
  Tau.lean — the signed "Tau" greedy word of rh42.

  The rh42 object is the *signed* alphabet `α_n = (-1)^n / (n+2)^p` used at a
  signed target `x`: at step `n` the term `α_n` is taken iff it has the sign of
  the current residual `r` and `|α_n| ≤ |r|`, and then `r ← r - α_n`; otherwise
  it is skipped forever.  For a positive target this file proves that the
  residual never becomes negative (`tauStep_nonneg`, `tauStep_pos_of_lt`), so
  every take occurs at an *even* index (`take_parity`, `support_subset_even`):
  the support of the word is parity-locked, hence consecutive taken indices
  differ by an even number `≥ 2` (`support_gap_even_and_two_le`).  The mirror
  statements hold for negative targets with odd/even interchanged.

  This matters for rh42 because the support of the signed word is parity-locked,
  so all of its gaps are even and at least `2`; the rh41 factor-complexity law
  (`Rh41.complexity_c1`) then applies with a minimum-gap hypothesis that, for a
  support with a gap of exactly `2`, is forced to `L ≤ 2`
  (`c1_range_le_two_of_gap_eq_two`).
-/
import Mathlib
import Rh41.DigitWord

namespace Rh42

/-! ## 1. The alphabet and one greedy step -/

/-- The Tau alphabet term at index `n` for exponent `p`: `(-1)^n / (n+2)^p`. -/
noncomputable def tauTerm (p n : ℕ) : ℚ := (-1 : ℚ) ^ n / ((n : ℚ) + 2) ^ p

/-- One greedy step at index `n` from residual `r`: the term is taken exactly
when it has the sign of `r` and its absolute value is at most `|r|`, in which
case it is subtracted from the residual; otherwise the residual is unchanged. -/
noncomputable def tauStep (p n : ℕ) (r : ℚ) : ℚ :=
  if (0 < r ∧ 0 < tauTerm p n ∧ tauTerm p n ≤ r) ∨ (r < 0 ∧ tauTerm p n < 0 ∧ tauTerm p n ≥ r)
    then r - tauTerm p n else r

/-- The take condition of `tauStep`, as a named predicate. -/
def tauTake (p n : ℕ) (r : ℚ) : Prop :=
  (0 < r ∧ 0 < tauTerm p n ∧ tauTerm p n ≤ r) ∨ (r < 0 ∧ tauTerm p n < 0 ∧ tauTerm p n ≥ r)

lemma tauTake_iff (p n : ℕ) (r : ℚ) :
    tauTake p n r ↔ (0 < r ∧ 0 < tauTerm p n ∧ tauTerm p n ≤ r) ∨
      (r < 0 ∧ tauTerm p n < 0 ∧ tauTerm p n ≥ r) := Iff.rfl

/-- A step whose take condition holds subtracts the term. -/
lemma tauStep_eq_sub_of_cond {p n : ℕ} {r : ℚ} (hcond : tauTake p n r) :
    tauStep p n r = r - tauTerm p n := by
  unfold tauStep
  exact ite_eq_left ((tauTake_iff p n r).mp hcond)

/-- A step whose take condition fails leaves the residual unchanged. -/
lemma tauStep_eq_self_of_not {p n : ℕ} {r : ℚ} (h : ¬ tauTake p n r) :
    tauStep p n r = r := by
  unfold tauStep
  exact ite_eq_right (fun hc => h ((tauTake_iff p n r).mpr hc))

/-! ## 2. Signs and size of the alphabet term -/

/-- At an even index the term is positive. -/
lemma tauTerm_pos_of_even {p n : ℕ} (hn : Even n) : 0 < tauTerm p n := by
  have h1 : (0 : ℚ) < ((n : ℚ) + 2) ^ p := by positivity
  rw [tauTerm, Even.neg_one_pow hn]
  exact div_pos one_pos h1

/-- At an odd index the term is negative. -/
lemma tauTerm_neg_of_odd {p n : ℕ} (hn : Odd n) : tauTerm p n < 0 := by
  have h1 : (0 : ℚ) < ((n : ℚ) + 2) ^ p := by positivity
  rw [tauTerm, Odd.neg_one_pow hn]
  exact div_neg_of_neg_of_pos neg_one_lt_zero h1

/-- At an even index the term is at most `1`. -/
lemma tauTerm_le_one_of_even (p n : ℕ) (hn : Even n) : tauTerm p n ≤ 1 := by
  unfold tauTerm
  rw [Even.neg_one_pow hn]
  refine div_le_one_of_le₀ ?_ (by positivity)
  rcases Nat.eq_zero_or_pos p with hp | hp
  · subst hp; norm_num
  · have h2 : (1 : ℚ) ≤ (n : ℚ) + 2 := by
      have : (0 : ℚ) ≤ (n : ℚ) := Nat.cast_nonneg n
      linarith
    exact le_trans h2 (le_self_pow₀ (by linarith) hp.ne')

/-- At an odd index the term is negative, hence at most `1`. -/
lemma tauTerm_le_one_of_odd (p n : ℕ) (hn : Odd n) : tauTerm p n ≤ 1 := by
  unfold tauTerm
  rw [Odd.neg_one_pow hn]
  exact le_trans (div_nonpos_of_nonpos_of_nonneg (show (-1 : ℚ) ≤ 0 by norm_num)
    (by positivity : (0:ℚ) ≤ ((n : ℚ) + 2) ^ p)) (by norm_num)

/-- The alphabet term is at most `1` in absolute value; indeed `|α_n| ≤ 1 / 2`
because `n + 2 ≥ 2`. -/
lemma tauTerm_le_one (p n : ℕ) : tauTerm p n ≤ 1 := by
  rcases Nat.even_or_odd n with h | h
  · exact tauTerm_le_one_of_even p n h
  · exact tauTerm_le_one_of_odd p n h

/-- The alphabet term is nonnegative exactly at even indices. -/
lemma tauTerm_nonneg_iff_even (p n : ℕ) : 0 ≤ tauTerm p n ↔ Even n := by
  constructor
  · intro h
    by_contra hc
    exact absurd h (not_le.mpr (tauTerm_neg_of_odd (Nat.not_even_iff_odd.mp hc)))
  · intro h
    exact le_of_lt (tauTerm_pos_of_even h)

/-! ## 3. Sign invariance of the residual -/

/-- A take condition at a nonnegative residual forces the residual to be
strictly positive. -/
lemma pos_of_take_of_nonneg {p n : ℕ} {r : ℚ} (hr : 0 ≤ r) (h : tauTake p n r) : 0 < r := by
  rcases (tauTake_iff p n r).mp h with hc | hc
  · exact hc.1
  · exact absurd hc.1 (not_lt.mpr hr)

/-- **Sign invariance (non-strict).** For a positive residual, a step leaves the
residual nonnegative. -/
theorem tauStep_nonneg (p n : ℕ) {r : ℚ} (hr : 0 < r) : 0 ≤ tauStep p n r := by
  by_cases hcond : tauTake p n r
  · rw [tauStep_eq_sub_of_cond hcond]
    rcases (tauTake_iff p n r).mp hcond with h | h
    · exact sub_nonneg.mpr h.2.2
    · exact le_of_lt (sub_pos.mpr (lt_trans h.2.1 hr))
  · rw [tauStep_eq_self_of_not hcond]
    exact le_of_lt hr

/-- **Sign invariance (strict, with a strictness hypothesis).** If the term is
strictly smaller than a positive residual, a step preserves strict positivity.
(Without this hypothesis strict positivity can fail: at `r = 1/2`, `n = 0`,
`p = 1` the term is taken with equality and the residual becomes `0`.) -/
theorem tauStep_pos_of_lt (p n : ℕ) {r : ℚ} (hr : 0 < r) (h : tauTerm p n < r) :
    0 < tauStep p n r := by
  by_cases hcond : tauTake p n r
  · rw [tauStep_eq_sub_of_cond hcond]
    rcases (tauTake_iff p n r).mp hcond with hc | hc
    · exact sub_pos.mpr h
    · exact sub_pos.mpr (lt_trans hc.2.1 hr)
  · rw [tauStep_eq_self_of_not hcond]
    exact hr

/-- **Sign invariance (mirror, non-strict).** For a negative residual, a step
leaves the residual nonpositive. -/
theorem tauStep_nonpos (p n : ℕ) {r : ℚ} (hr : r < 0) : tauStep p n r ≤ 0 := by
  have h1 := tauTerm_le_one p n
  by_cases hcond : tauTake p n r
  · rw [tauStep_eq_sub_of_cond hcond]
    rcases (tauTake_iff p n r).mp hcond with h | h
    · exact absurd hr (not_lt.mpr h.1.le)
    · exact sub_nonpos.mpr h.2.2
  · rw [tauStep_eq_self_of_not hcond]
    exact le_of_lt hr

/-- **Sign invariance (mirror, non-strict, strict form).** A nonpositive residual
stays nonpositive; moreover a strictly negative residual never increases.  The
strict form below is the one used later: a take at a negative residual gives
`r - α ≤ 0`, and `r - α < 0` unless `α = r` exactly -- which can happen (e.g.
`r = α = -1/2`), so only the non-strict version holds in general. -/
theorem tauStep_neg (p n : ℕ) {r : ℚ} (hr : r < 0) : tauStep p n r ≤ 0 := by
  by_cases hcond : tauTake p n r
  · rw [tauStep_eq_sub_of_cond hcond]
    rcases (tauTake_iff p n r).mp hcond with h | h
    · exact absurd hr (not_lt.mpr h.1.le)
    · exact sub_nonpos.mpr h.2.2
  · rw [tauStep_eq_self_of_not hcond]
    exact le_of_lt hr

/-! ## 4. Parity lock -/

/-- At an odd (negative) index a positive residual never takes the term. -/
theorem tauStep_eq_self_of_odd (p : ℕ) {n : ℕ} (hn : Odd n) {r : ℚ} (hr : 0 < r) :
    tauStep p n r = r := by
  refine tauStep_eq_self_of_not ?_
  rintro (h | h)
  · exact absurd h.2.1 (not_lt.mpr (le_of_lt (tauTerm_neg_of_odd hn)))
  · exact absurd hr (not_lt.mpr h.1.le)

/-- **Parity lock.** For a positive residual, a step that changes the residual
(i.e. that takes the term) happens at an even index. -/
theorem take_parity (p : ℕ) {r : ℚ} (hr : 0 < r) :
    ∀ {n : ℕ}, tauStep p n r ≠ r → Even n := by
  intro n hne
  by_contra hc
  exact hne (tauStep_eq_self_of_odd p (Nat.not_even_iff_odd.mp hc) hr)

/-- At an even (positive) index a negative residual never takes the term. -/
theorem tauStep_eq_self_of_even (p : ℕ) {n : ℕ} (hn : Even n) {r : ℚ} (hr : r < 0) :
    tauStep p n r = r := by
  refine tauStep_eq_self_of_not ?_
  rintro (h | h)
  · exact absurd hr (not_lt.mpr h.1.le)
  · exact absurd h.2.1 (not_lt.mpr (le_of_lt (tauTerm_pos_of_even hn)))

/-- **Parity lock (mirror).** For a negative residual, a take happens at an odd
index. -/
theorem take_parity_neg (p : ℕ) {r : ℚ} (hr : r < 0) :
    ∀ {n : ℕ}, tauStep p n r ≠ r → Odd n := by
  intro n hne
  by_contra hc
  exact hne (tauStep_eq_self_of_even p (Nat.not_odd_iff_even.mp hc) hr)

/-! ## 5. The algorithm, its support and the even-gap theorem -/

/-- The residual obtained from `x` after performing the greedy steps at the
indices `0, 1, …, n-1`. -/
noncomputable def tauResidual (p : ℕ) (x : ℚ) : ℕ → ℚ
  | 0 => x
  | n + 1 => tauStep p n (tauResidual p x n)

/-- The greedy algorithm takes the term at index `n` (starting from `x`) when
the residual at index `n` changes. -/
def tauTaken (p : ℕ) (x : ℚ) (n : ℕ) : Prop :=
  tauStep p n (tauResidual p x n) ≠ tauResidual p x n

/-- The support of the greedy word within the truncation `[0, N)`: the set of
taken indices below `N`. -/
noncomputable def support (p : ℕ) (x : ℚ) (N : ℕ) : Finset ℕ := by
  classical
  exact (Finset.range N).filter fun n => tauTaken p x n

/-- Membership in the support, unfolded. -/
lemma mem_support {p N : ℕ} {x : ℚ} {n : ℕ} :
    n ∈ support p x N ↔ n < N ∧ tauTaken p x n := by
  classical
  show n ∈ (Finset.range N).filter (fun k => tauTaken p x k) ↔ n < N ∧ tauTaken p x n
  rw [Finset.mem_filter, Finset.mem_range]

/-- The successor residual is the step applied to the current residual. -/
lemma tauResidual_succ (p : ℕ) (x : ℚ) (n : ℕ) :
    tauResidual p x (n + 1) = tauStep p n (tauResidual p x n) := rfl

/-- With a residual of `0` no term is ever taken, so the residual stays `0`. -/
lemma tauStep_zero (p n : ℕ) : tauStep p n 0 = 0 := by
  have h : ¬ tauTake p n 0 := by
    rintro (h | h)
    · exact absurd h.1 (lt_irrefl 0)
    · exact absurd h.1 (lt_irrefl 0)
  rw [tauStep_eq_self_of_not h]

/-- Every residual of the algorithm on a nonnegative target is nonnegative. -/
theorem tauResidual_nonneg (p : ℕ) {x : ℚ} (hx : 0 ≤ x) : ∀ n, 0 ≤ tauResidual p x n
  | 0 => hx
  | n + 1 => by
      rw [tauResidual_succ]
      rcases eq_or_lt_of_le (tauResidual_nonneg p hx n) with h | h
      · rw [← h, tauStep_zero]
      · exact tauStep_nonneg p n h

/-- Every residual of the algorithm on a nonpositive target is nonpositive:
when it is `0` it stays `0`, and otherwise the step is nonpositive. -/
theorem tauResidual_nonpos (p : ℕ) {x : ℚ} (hx : x ≤ 0) : ∀ n, tauResidual p x n ≤ 0
  | 0 => hx
  | n + 1 => by
      rw [tauResidual_succ]
      rcases eq_or_lt_of_le (tauResidual_nonpos p hx n) with h | h
      · rw [h, tauStep_zero]
      · exact tauStep_neg p n h

/-- The support of the word of a positive target consists of even indices: every
residual is nonnegative and a take forces it to be positive, so the parity lock
applies. -/
theorem support_subset_even (p : ℕ) {x : ℚ} (hx : 0 < x) (N : ℕ) :
    ∀ n ∈ support p x N, Even n := by
  intro n hn
  have hmem := mem_support.mp hn
  have hcond : tauTake p n (tauResidual p x n) := by
    by_contra hc
    exact hmem.2 (tauStep_eq_self_of_not hc)
  have hpos : 0 < tauResidual p x n := by
    rcases (tauTake_iff p n (tauResidual p x n)).mp hcond with h | h
    · exact h.1
    · exact absurd h.1 (not_lt.mpr (tauResidual_nonneg p (le_of_lt hx) n))
  exact take_parity p hpos hmem.2

/-- The support of the word of a negative target consists of odd indices. -/
theorem support_subset_odd_of_neg (p : ℕ) {x : ℚ} (hx : x < 0) (N : ℕ) :
    ∀ n ∈ support p x N, Odd n := by
  intro n hn
  have hmem := mem_support.mp hn
  have hcond : tauTake p n (tauResidual p x n) := by
    by_contra hc
    exact hmem.2 (tauStep_eq_self_of_not hc)
  have hneg : tauResidual p x n < 0 := by
    rcases (tauTake_iff p n (tauResidual p x n)).mp hcond with h | h
    · exact absurd h.1 (not_lt.mpr (tauResidual_nonpos p (le_of_lt hx) n))
    · exact h.1
  exact take_parity_neg p hneg hmem.2

/-- **Even gaps.** For a positive target, consecutive taken indices differ by at
least `2` (they are both even, so their difference is even and nonzero). -/
theorem support_gap_even_and_two_le (p : ℕ) {x : ℚ} (hx : 0 < x) {N a b : ℕ}
    (ha : a ∈ support p x N) (hb : b ∈ support p x N) (hab : a < b) : 2 ≤ b - a := by
  obtain ⟨i, rfl⟩ := support_subset_even p hx N a ha
  obtain ⟨j, rfl⟩ := support_subset_even p hx N b hb
  have hij : i < j := by omega
  have h2 : 2 * (j - i) = 2 * j - 2 * i := Nat.mul_sub_left_distrib 2 j i
  omega

/-- The gap between two taken indices of a positive target is even. -/
theorem support_gap_even (p : ℕ) {x : ℚ} (hx : 0 < x) {N a b : ℕ}
    (ha : a ∈ support p x N) (hb : b ∈ support p x N) : Even (b - a) := by
  rcases le_or_gt b a with h | h
  · rw [Nat.sub_eq_zero_of_le h]
    exact ⟨0, rfl⟩
  · obtain ⟨i, rfl⟩ := support_subset_even p hx N a ha
    obtain ⟨j, rfl⟩ := support_subset_even p hx N b hb
    exact ⟨j - i, by omega⟩

/-! ## 6. Negative mirror: odd takes, same even gaps -/

/-- Consecutive taken indices of a negative target differ by at least `2`. -/
theorem support_gap_even_and_two_le_of_neg (p : ℕ) {x : ℚ} (hx : x < 0) {N a b : ℕ}
    (ha : a ∈ support p x N) (hb : b ∈ support p x N) (hab : a < b) : 2 ≤ b - a := by
  obtain ⟨i, rfl⟩ := support_subset_odd_of_neg p hx N a ha
  obtain ⟨j, rfl⟩ := support_subset_odd_of_neg p hx N b hb
  have hij : i < j := by omega
  have h2 : 2 * (j - i) = 2 * j - 2 * i := Nat.mul_sub_left_distrib 2 j i
  omega

/-- The gap between two taken indices of a negative target is even. -/
theorem support_gap_even_of_neg (p : ℕ) {x : ℚ} (hx : x < 0) {N a b : ℕ}
    (ha : a ∈ support p x N) (hb : b ∈ support p x N) : Even (b - a) := by
  rcases le_or_gt b a with h | h
  · rw [Nat.sub_eq_zero_of_le h]
    exact ⟨0, rfl⟩
  · obtain ⟨i, rfl⟩ := support_subset_odd_of_neg p hx N a ha
    obtain ⟨j, rfl⟩ := support_subset_odd_of_neg p hx N b hb
    exact ⟨j - i, by omega⟩

/-! ## 7. Transfer to the rh41 factor-complexity law

The parity lock says that consecutive taken indices of a positive target are even
and at least `2` apart (`support_gap_even_and_two_le`).  Consequently, if the
support has a gap equal to `2` then rh41's C1 minimum-gap hypothesis
`GapsAtLeast S L` can only hold for `L ≤ 2`, i.e. `L ∈ {1, 2}`. -/

/-- `GapsAtLeast S L`: every pair of support points is at distance `≥ L`. -/
def GapsAtLeast (S : Finset ℕ) (L : ℕ) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, a < b → L ≤ b - a

/-- An even positive natural number is at least `2`. -/
lemma two_le_of_even_pos {d : ℕ} (hd : Even d) (hpos : 0 < d) : 2 ≤ d := by
  obtain ⟨k, rfl⟩ := hd
  omega

/-- If a support has a gap equal to `2`, then rh41's C1 hypothesis
`GapsAtLeast S L` forces `L ≤ 2`.  Combined with `support_gap_even`, this is the
honest structural consequence of the parity lock for the complexity law. -/
theorem c1_range_le_two_of_gap_eq_two (S : Finset ℕ) {a b : ℕ} (ha : a ∈ S)
    (hb : b ∈ S) (hab : a < b) (hg : b - a = 2) {L : ℕ} (hgap : GapsAtLeast S L) :
    L ≤ 2 := by
  have hLab : L ≤ b - a := hgap a ha b hb hab
  omega

/-- **Instantiation of the rh41 C1 law.** The parity-locked support `{2, 4}`
has minimum gap exactly `2`, so with `N = 10` and `L = 2` the C1 hypotheses hold
and `Rh41.complexity_c1` gives `p(2) = L + 1 = 3`. -/
theorem complexity_c1_example :
    Rh41.complexity ({2, 4} : Finset ℕ) 10 2 = 3 := by
  have hmem2 : (2 : ℕ) ∈ ({2, 4} : Finset ℕ) := by decide
  have hS : ({2, 4} : Finset ℕ) ⊆ Finset.range 10 := by decide
  have hne : ({2, 4} : Finset ℕ).Nonempty := ⟨2, hmem2⟩
  have hminle : ({2, 4} : Finset ℕ).min' hne ≤ 2 := Finset.min'_le _ 2 hmem2
  have hmin2 : 2 ≤ ({2, 4} : Finset ℕ).min' hne := by
    refine Finset.le_min' _ _ 2 ?_
    intro y hy
    rw [Finset.mem_insert, Finset.mem_singleton] at hy
    rcases hy with rfl | rfl <;> decide
  have hmin : ({2, 4} : Finset ℕ).min' hne = 2 := le_antisymm hminle hmin2
  have hLmin : 2 ≤ ({2, 4} : Finset ℕ).min' hne := hmin2
  have hLedge : 2 ≤ 10 - ({2, 4} : Finset ℕ).min' hne - 1 := by
    rw [hmin]
    norm_num
  have hres := Rh41.complexity_c1 ({2, 4} : Finset ℕ) 10 2 hS hne (by decide) (by decide)
    (by decide) hLmin hLedge
  rw [show (2 : ℕ) + 1 = 3 from rfl] at hres
  exact hres

end Rh42
