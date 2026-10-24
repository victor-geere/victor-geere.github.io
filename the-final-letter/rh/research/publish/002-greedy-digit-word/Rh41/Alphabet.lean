/-
  Alphabet.lean — machine-checked proofs for the greedy-process / alphabet items
  of `rh41/TRUTHS.md`.

  OBJECT (`TRUTHS.md` §3, `rh41/rigorous_check.py` `greedy_alpha`,
  `rh41/digitword.py`).  Given an alphabet `α : ℕ → ℚ` and a target `x > 0`, the
  greedy process at step `n` compares the residual `r` with `α n`: the digit is
  `1` iff `r ≥ α n`, and then `α n` is subtracted; otherwise the digit is `0`
  and the residual is unchanged.  The *harmonic digit word* is the case
  `α n = 1/(n+2)`.

  This file proves, with no `sorry`/`admit`, no new axioms and no `native_decide`:

  * `taken_all_of_bounded_partial_sums` / `taken_all_of_bounded_partial_sums_mono`
    / `never_halts_of_partial_sums_lt` / `partial_sums_lt_of_step`
    — **Theorem 9, the correct half** (and **Theorem 10 row 1**): if `α` is
    non-increasing and positive and every strict partial sum
    `(∑_{k<n} α k) + α n` is at most `x` (equivalently: every finite sub-sum is
    `< x`), then *every* index is taken, the residual is exactly
    `x - ∑_{k<n} α k`, and it is never `0` — the process never halts finitely.
  * `le_sum_of_residual_eq_zero` — **Theorem 9, easy direction**: if
    `residual α x N = 0`, then `x ≤ ∑_{k<N} α k`.
  * `expAlpha_*` — **Theorem 11**: for `α n = (1/2)^(n+1)`, `x = 1`, every index
    is taken (so the support is all of `ℕ`, i.e. "max gap 1") while
    `residual α 1 n = (1/2)^n → 0`.  Bounded gaps and convergence to `0` hold
    simultaneously, so the dichotomy "bounded gaps OR termination, never both"
    is false.
  * `exists_taken_ge`, `never_halts_of_tendsto_zero`, `powerAlpha_*`
    — **Theorem 10 row 3**, with the missing hypothesis made explicit: if no
    finite sub-sum of the alphabet equals `x` and `α n → 0`, then the residual
    is `> 0` at every step and the set of taken indices is infinite.  In
    particular this covers `α n = (n+2)^{-p}`, `p > 0`, `x = 1` (`powerAlpha`).
  * `no_linear_complexity_of_finite_support`, `no_sturmian_complexity_of_finite_support`,
    `no_linear_complexity_of_halting`, `max_complexity_of_halting`,
    `not_taken_of_residual_eq_zero`, `digitSupport_nonempty_of_halting`
    — **Theorem 12** (impossibility half): a halting process has a *finite*
    support; with `a_m = max S` and `N ≥ 2 a_m + 2`, the maximum of
    `L ↦ complexity S N L` over `1 ≤ L ≤ N` is the fixed number `a_m + 2`, so no
    homogeneous linear profile `p(L) = c·L` (in particular not the Sturmian
    profile `p(L) = L + 1`) is possible.

  CORRECTIONS / CAVEATS (see the individual docstrings):

  * **`TRUTHS.md` Theorem 9 is printed with an `iff` that is false.**  It reads
    "the process halts finitely **iff** `Σ_n α_n ≥ x`".  The `⇐` direction is
    refuted by the source itself: Theorem 10 row 3 has `Σ α_n = ∞` and never
    halts, and Theorem 11 has `Σ α_n = 1 = x` and never reaches `0` at a finite
    step (only `residual → 0`).  The correct content, proved here, is the pair
    "halting at `N` ⟹ some finite partial sum `∑_{k<N} α k` is `≥ x`"
    (`le_sum_of_residual_eq_zero`) and "all finite partial sums are `< x` ⟹ the
    process never halts" (`never_halts_of_partial_sums_lt`).
  * **`TRUTHS.md` Theorem 11 says the exponential alphabet "terminates
    exactly".**  Formally the residual is `(1/2)^n > 0` at every finite step, so
    the process does not reach `0` finitely; what is true (and proved) is that
    the residual tends to `0` while every index is taken.
  * **`TRUTHS.md` Theorem 10 row 3 is stated for real `p > 0`.**  The formal
    `powerAlpha` statement covers natural `p ≥ 1`; the only analytic input the
    argument uses is `(n+2)^{-p} → 0`, isolated as `powerAlpha_tendsto_zero`,
    and the abstract `never_halts_of_tendsto_zero` applies to every alphabet
    with that property.
  * The non-increasing hypothesis printed in Theorem 9 is *not needed* for the
    two directions proved here (only positivity is); it is nevertheless kept in
    `taken_all_of_bounded_partial_sums_mono` and `partial_sums_lt_of_step` so
    that the statements match the source, and the equivalence
    "`∀ n, (∑_{k<n} α k) + α n ≤ x` ⟺ every finite sub-sum is `< x`" is proved
    in `partial_sums_iff`.
  * **Theorem 12's literal `c·L` phrasing needs care.**  "For every `c > 0` there
    is `L` with `complexity S N L < c·L`" is false once `c·N ≤ a_m + 2`, since
    every complexity is `≥ 1` and `c·L ≤ c·N`.  The structural statement proved
    here is stronger and is the mathematically meaningful one: at `L = N` the
    complexity is `1` and at `L = N - 1` it is `2`, so *no* homogeneous linear
    profile `p(L) = c·L` (`c > 0`) can hold for all `L ∈ [1,N]`; in particular
    the Sturmian profile `p(L) = L + 1` fails at `L = N`.
-/
import Mathlib
import Rh41.DigitWord

namespace Rh41

open Finset

/-! ## 1. The greedy process: residual, taken indices, support -/

/-- Residual after `k` steps of the greedy process with alphabet `α` and target
`x`: `residual α x 0 = x`, and `residual α x (k+1) = residual α x k - α k` if
`α k ≤ residual α x k` (the digit is `1`), else `residual α x (k+1) = residual α x k`
(digit `0`). -/
def residual (α : ℕ → ℚ) (x : ℚ) : ℕ → ℚ
  | 0 => x
  | k + 1 => if α k ≤ residual α x k then residual α x k - α k else residual α x k

/-- `n` is taken by the process: the digit at step `n` is `1`. -/
def taken (α : ℕ → ℚ) (x : ℚ) (n : ℕ) : Prop := α n ≤ residual α x n

/-- The amount actually subtracted at step `n`: `α n` if `n` is taken, `0`
otherwise.  The residual decreases by exactly `digit α x n` at each step. -/
def digit (α : ℕ → ℚ) (x : ℚ) (n : ℕ) : ℚ :=
  if α n ≤ residual α x n then α n else 0

/-- The support of the first `N` digits: the taken indices below `N`.

The filter is written with the explicit inequality rather than with `taken`,
because `taken` is a `def` returning a `Prop` and Lean does not synthesize
`Decidable (taken α x n)` by unfolding it; `mem_digitSupport` records that the
two descriptions agree. -/
def digitSupport (α : ℕ → ℚ) (x : ℚ) (N : ℕ) : Finset ℕ :=
  (range N).filter (fun n => α n ≤ residual α x n)

/-- The only analytic input used below: `α n → 0`, in `ε`-`N` form over `ℚ`. -/
def TendsToZero (α : ℕ → ℚ) : Prop :=
  ∀ ε : ℚ, 0 < ε → ∃ N : ℕ, ∀ n ≥ N, α n < ε

/-! ## 2. Basic calculus of the residual -/

/-- The residual at time `0` is the target. -/
@[simp] lemma residual_zero (α : ℕ → ℚ) (x : ℚ) : residual α x 0 = x := rfl

/-- One unfolding step of the residual. -/
lemma residual_succ (α : ℕ → ℚ) (x : ℚ) (n : ℕ) :
    residual α x (n + 1) =
      if α n ≤ residual α x n then residual α x n - α n else residual α x n := rfl

/-- One step of the residual, written with the subtracted amount `digit`. -/
lemma residual_succ_eq (α : ℕ → ℚ) (x : ℚ) (n : ℕ) :
    residual α x (n + 1) = residual α x n - digit α x n := by
  rw [residual_succ]
  by_cases h : α n ≤ residual α x n <;> simp [digit, h]

/-- A taken step subtracts `α n`. -/
lemma residual_succ_of_le (α : ℕ → ℚ) (x : ℚ) {n : ℕ}
    (h : α n ≤ residual α x n) :
    residual α x (n + 1) = residual α x n - α n := by
  rw [residual_succ_eq, show digit α x n = α n from by simp [digit, h]]

/-- A non-taken step leaves the residual unchanged. -/
lemma residual_succ_of_not_le (α : ℕ → ℚ) (x : ℚ) {n : ℕ}
    (h : ¬ (α n ≤ residual α x n)) :
    residual α x (n + 1) = residual α x n := by
  rw [residual_succ_eq, show digit α x n = 0 from by simp [digit, h]]
  simp

/-- `taken` unfolded. -/
lemma taken_iff (α : ℕ → ℚ) (x : ℚ) (n : ℕ) :
    taken α x n ↔ α n ≤ residual α x n := Iff.rfl

/-- Membership in the support. -/
lemma mem_digitSupport (α : ℕ → ℚ) (x : ℚ) {N n : ℕ} :
    n ∈ digitSupport α x N ↔ n < N ∧ taken α x n := by
  simp [digitSupport, taken]

/-- A nonnegative alphabet and a nonnegative target keep the residual
nonnegative. -/
lemma residual_nonneg (α : ℕ → ℚ) (x : ℚ) (hx : 0 ≤ x) :
    ∀ n, 0 ≤ residual α x n := by
  intro n
  induction n with
  | zero => rw [residual_zero]; exact hx
  | succ n ih =>
      rw [residual_succ_eq]
      by_cases h : α n ≤ residual α x n
      · rw [show digit α x n = α n from by simp [digit, h]]
        linarith
      · rw [show digit α x n = 0 from by simp [digit, h]]
        simpa using ih

/-- The residual is non-increasing for a nonnegative alphabet. -/
lemma residual_succ_le (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 ≤ α n) (n : ℕ) :
    residual α x (n + 1) ≤ residual α x n := by
  rw [residual_succ_eq]
  by_cases h : α n ≤ residual α x n
  · rw [show digit α x n = α n from by simp [digit, h]]
    linarith [hα n]
  · rw [show digit α x n = 0 from by simp [digit, h]]
    linarith

/-- The residual is antitone in time for a nonnegative alphabet. -/
lemma residual_antitone (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 ≤ α n) :
    Antitone (residual α x) :=
  antitone_nat_of_succ_le (residual_succ_le α x hα)

/-- Hence `m ≤ n` gives `residual n ≤ residual m`. -/
lemma residual_le_of_le (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 ≤ α n)
    {m n : ℕ} (h : m ≤ n) : residual α x n ≤ residual α x m :=
  (residual_antitone α x hα) h

/-! ## 3. The residual as `x` minus the digits taken so far -/

/-- **Telescoping identity.**  After `n` steps the residual is the target minus
the sum of the digits actually taken.  No hypothesis on `α` is needed. -/
lemma residual_eq_sub_sum (α : ℕ → ℚ) (x : ℚ) (n : ℕ) :
    residual α x n = x - ∑ k ∈ range n, digit α x k := by
  induction n with
  | zero => rw [residual_zero]; simp
  | succ n ih =>
      rw [residual_succ_eq, ih, sum_range_succ]
      ring

/-! ## 4. Theorem 9, the correct half (and Theorem 10 row 1)

If `α` is positive and every strict partial sum `(∑_{k<n} α k) + α n` is at most
`x`, then `α n ≤ residual n` at *every* step, the residual is exactly
`x - ∑_{k<n} α k`, and it is `> 0`: the process never halts finitely. -/

/-- **Theorem 9 (correct half), core form.**  For a positive alphabet whose
strict partial sums satisfy `(∑_{k<n} α k) + α n ≤ x` for every `n`:

* every index is taken;
* `residual α x n = x - ∑_{k<n} α k` for every `n`;
* the residual is `> 0` at every step, so the process never halts.

No monotonicity of `α` is needed for this direction; conversely the hypothesis
is exactly "all finite sub-sums are `< x`" (`partial_sums_iff`). -/
theorem taken_all_of_bounded_partial_sums (α : ℕ → ℚ) (x : ℚ)
    (hpos : ∀ n, 0 < α n)
    (hsum : ∀ n, (∑ k ∈ range n, α k) + α n ≤ x) :
    (∀ n, taken α x n) ∧
      (∀ n, residual α x n = x - ∑ k ∈ range n, α k) ∧
      (∀ n, 0 < residual α x n) := by
  have hres : ∀ n, residual α x n = x - ∑ k ∈ range n, α k := by
    intro n
    induction n with
    | zero => rw [residual_zero]; simp
    | succ n ih =>
        have htake : α n ≤ residual α x n := by
          rw [ih]
          have := hsum n
          linarith
        rw [residual_succ_of_le α x htake, ih, sum_range_succ]
        ring
  refine ⟨?_, hres, ?_⟩
  · intro n
    show α n ≤ residual α x n
    rw [hres n]
    have := hsum n
    linarith
  · intro n
    rw [hres n]
    have h1 := hsum n
    have h2 := hpos n
    linarith

/-- **Theorem 9 (correct half), sub-sum form.**  If every *finite sub-sum* of
the alphabet is `< x` (and `α > 0`), then every index is taken and the residual
is `> 0` forever: the process never halts finitely. -/
theorem never_halts_of_partial_sums_lt (α : ℕ → ℚ) (x : ℚ)
    (hpos : ∀ n, 0 < α n)
    (hlt : ∀ s : Finset ℕ, (∑ k ∈ s, α k) < x) :
    (∀ n, taken α x n) ∧ (∀ n, 0 < residual α x n) := by
  have h := taken_all_of_bounded_partial_sums α x hpos (fun n => by
    have h1 := hlt (range (n + 1))
    rw [sum_range_succ] at h1
    linarith)
  exact ⟨h.1, h.2.2⟩

/-- **Theorem 9, the `⟸`-to-strict conversion.**  With `α` non-increasing and
positive, `(∑_{k<n} α k) + α n ≤ x` for all `n` implies that *every* finite
sub-sum of `α` is `< x`.  (The proof in fact only uses positivity.) -/
theorem partial_sums_lt_of_step (α : ℕ → ℚ) (x : ℚ)
    (hmono : ∀ n, α (n + 1) ≤ α n) (hpos : ∀ n, 0 < α n)
    (hsum : ∀ n, (∑ k ∈ range n, α k) + α n ≤ x) :
    ∀ s : Finset ℕ, (∑ k ∈ s, α k) < x := by
  have _hmono := hmono 0
  intro s
  rcases s.eq_empty_or_nonempty with rfl | hs
  · rw [sum_empty]
    have h0 := hsum 0
    simp at h0
    have := hpos 0
    linarith
  · set M := s.max' hs with hM
    have hsub : s ⊆ range (M + 1) := by
      intro k hk
      rw [mem_range]
      exact Nat.lt_succ_of_le (by rw [hM]; exact le_max' s k hk)
    have hle : (∑ k ∈ s, α k) ≤ ∑ k ∈ range (M + 1), α k :=
      sum_le_sum_of_subset_of_nonneg hsub (fun k _ _ => (hpos k).le)
    have hkey := hsum (M + 1)
    have : (∑ k ∈ range (M + 1), α k) < x := by linarith [hpos (M + 1)]
    linarith

/-- The two formulations of Theorem 9 are equivalent (for a positive
non-increasing alphabet): bounding every strict partial sum by `x` is the same
as making every finite sub-sum `< x`. -/
theorem partial_sums_iff (α : ℕ → ℚ) (x : ℚ)
    (hmono : ∀ n, α (n + 1) ≤ α n) (hpos : ∀ n, 0 < α n) :
    (∀ s : Finset ℕ, (∑ k ∈ s, α k) < x) ↔
      (∀ n, (∑ k ∈ range n, α k) + α n ≤ x) :=
  ⟨fun h n => by
      have h1 := h (range (n + 1))
      rw [sum_range_succ] at h1
      linarith,
    partial_sums_lt_of_step α x hmono hpos⟩

/-- **Theorem 9 (correct half), exactly as printed in `TRUTHS.md`** — with the
non-increasing hypothesis included (it is not needed for this direction). -/
theorem taken_all_of_bounded_partial_sums_mono (α : ℕ → ℚ) (x : ℚ)
    (hmono : ∀ n, α (n + 1) ≤ α n) (hpos : ∀ n, 0 < α n)
    (hsum : ∀ n, (∑ k ∈ range n, α k) + α n ≤ x) :
    (∀ n, taken α x n) ∧
      (∀ n, residual α x n = x - ∑ k ∈ range n, α k) ∧
      (∀ n, 0 < residual α x n) := by
  have _h := partial_sums_lt_of_step α x hmono hpos hsum
  exact taken_all_of_bounded_partial_sums α x hpos hsum

/-- **Theorem 9 (correct half), lower-bound form.**  The residual at step `n` is
bounded below by `x` minus any finite partial sum that extends `∑_{k<n} α k`. -/
theorem residual_ge_sub_sum (α : ℕ → ℚ) (x : ℚ) (hpos : ∀ n, 0 < α n)
    (hsum : ∀ n, (∑ k ∈ range n, α k) + α n ≤ x) {n : ℕ} {s : Finset ℕ}
    (hsub : range n ⊆ s) :
    x - ∑ k ∈ s, α k ≤ residual α x n := by
  have hres := (taken_all_of_bounded_partial_sums α x hpos hsum).2.1 n
  rw [hres]
  have hle : (∑ k ∈ range n, α k) ≤ ∑ k ∈ s, α k :=
    sum_le_sum_of_subset_of_nonneg hsub (fun k _ _ => (hpos k).le)
  linarith

/-! ## 5. Theorem 9, the easy direction: halting needs a large partial sum

`TRUTHS.md` Theorem 9 prints the criterion as an `iff`.  The direction proved
here is the true one.  The converse is false — see the file header and
`expAlpha_*` / `powerAlpha_*` — so the `iff` as printed is inconsistent with
Theorem 10 row 3 (`Σ α n = ∞`, never halts) and with Theorem 11
(`Σ α n = 1 = x`, never halts finitely). -/

/-- **Theorem 9, easy direction.**  If the residual vanishes at step `N`, then
the first `N` alphabet terms already sum to at least `x`.  (Nonnegativity of the
alphabet is needed: a negative alphabet can reach `0` with a smaller sum.) -/
theorem le_sum_of_residual_eq_zero (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 ≤ α n)
    (N : ℕ) (h : residual α x N = 0) :
    x ≤ ∑ k ∈ range N, α k := by
  have hid := residual_eq_sub_sum α x N
  rw [h] at hid
  have hx : x = ∑ k ∈ range N, digit α x k := by linarith
  rw [hx]
  refine sum_le_sum (fun k _ => ?_)
  by_cases hk : α k ≤ residual α x k
  · rw [show digit α x k = α k from by simp [digit, hk]]
  · rw [show digit α x k = 0 from by simp [digit, hk]]
    exact hα k

/-! ## 6. Theorem 11: the exponential alphabet

`α n = (1/2)^(n+1)`, `x = 1`.  Every index is taken, the residual is exactly
`(1/2)^n`, and it tends to `0`.  Bounded gaps and convergence to `0` therefore
hold simultaneously. -/

/-- The exponential alphabet `α n = (1/2)^(n+1)` of `TRUTHS.md` Theorem 11. -/
def expAlpha : ℕ → ℚ := fun n => (1 / 2 : ℚ) ^ (n + 1)

/-- The exponential alphabet is positive. -/
lemma expAlpha_pos (n : ℕ) : 0 < expAlpha n := by
  unfold expAlpha
  positivity

/-- `α n = (1/2)^(n+1) ≤ (1/2)^n`: the geometric alphabet is decreasing. -/
lemma expAlpha_le (n : ℕ) : expAlpha n ≤ (1 / 2 : ℚ) ^ n := by
  unfold expAlpha
  rw [pow_succ]
  have h : (0 : ℚ) ≤ (1 / 2) ^ n := pow_nonneg (by norm_num) n
  linarith

/-- The finite partial sums of the exponential alphabet are `1 - (1/2)^N`, so
they increase to `1 = x`.  Together with `expAlpha_residual_pos` (the residual is
never `0` at a finite step) this makes Theorem 9's printed `iff` concrete: the
hypothesis `Σ α n ≥ x` holds while the process never halts finitely. -/
lemma expAlpha_partial_sum (N : ℕ) :
    ∑ k ∈ range N, expAlpha k = 1 - (1 / 2 : ℚ) ^ N := by
  induction N with
  | zero => simp
  | succ N ih =>
      rw [sum_range_succ, ih]
      unfold expAlpha
      rw [pow_succ]
      ring

/-- **Theorem 11, residual.**  After `n` steps the residual is exactly
`(1/2)^n`. -/
theorem expAlpha_residual (n : ℕ) : residual expAlpha 1 n = (1 / 2 : ℚ) ^ n := by
  induction n with
  | zero => rw [residual_zero]; norm_num
  | succ n ih =>
      have htake : expAlpha n ≤ residual expAlpha 1 n := by
        rw [ih]
        exact expAlpha_le n
      have hsub : (1 / 2 : ℚ) ^ n - expAlpha n = (1 / 2 : ℚ) ^ (n + 1) := by
        unfold expAlpha
        rw [pow_succ]
        ring
      rw [residual_succ_of_le expAlpha 1 htake, ih]
      exact hsub

/-- **Theorem 11, no zero digits.**  Every index is taken. -/
theorem expAlpha_taken (n : ℕ) : taken expAlpha 1 n := by
  show expAlpha n ≤ residual expAlpha 1 n
  rw [expAlpha_residual]
  exact expAlpha_le n

/-- The support of the exponential alphabet is all of `ℕ`: all gaps are `1`. -/
theorem expAlpha_support_univ : {n : ℕ | taken expAlpha 1 n} = Set.univ :=
  Set.eq_univ_of_forall expAlpha_taken

/-- **Theorem 11, convergence.**  The residual of the exponential alphabet tends
to `0` (in `ε`-`N` form). -/
theorem expAlpha_residual_tendsto_zero :
    ∀ ε : ℚ, 0 < ε → ∃ N : ℕ, ∀ n ≥ N, residual expAlpha 1 n < ε := by
  intro ε hε
  obtain ⟨m, hm⟩ := exists_nat_gt ε⁻¹
  refine ⟨m, fun n hn => ?_⟩
  rw [expAlpha_residual]
  have hmpos : (0 : ℚ) < (m : ℚ) := lt_trans (inv_pos.mpr hε) hm
  have h1 : (1 : ℚ) / (m : ℚ) < ε := by
    have h := (inv_lt_comm₀ hε hmpos).mp hm
    simpa [one_div] using h
  have h2 : ((1 : ℚ) / 2) ^ n < (1 : ℚ) / (m : ℚ) := by
    have hmn : (m : ℚ) < (2 : ℚ) ^ n := by
      have h : m < 2 ^ n := lt_of_le_of_lt hn n.lt_two_pow_self
      exact_mod_cast h
    have hpow : ((1 : ℚ) / 2) ^ n = (1 : ℚ) / (2 : ℚ) ^ n := by
      rw [div_pow, one_pow]
    rw [hpow]
    exact one_div_lt_one_div_of_lt hmpos hmn
  linarith

/-- **Theorem 11 (dichotomy false).**  The exponential alphabet selects every
index *and* its residual converges to `0`: bounded gaps and convergence to `0`
occur together, so "bounded gaps OR termination, never both" is false. -/
theorem expAlpha_bounded_gaps_and_termination :
    (∀ n, taken expAlpha 1 n) ∧
      (∀ ε : ℚ, 0 < ε → ∃ N : ℕ, ∀ n ≥ N, residual expAlpha 1 n < ε) :=
  ⟨expAlpha_taken, expAlpha_residual_tendsto_zero⟩

/-- The exponential residual is positive at every finite step: the process never
*reaches* `0` finitely.  (`TRUTHS.md` Theorem 11 says it "terminates exactly";
the exact statement is convergence, not finite termination.) -/
theorem expAlpha_residual_pos (n : ℕ) : 0 < residual expAlpha 1 n := by
  rw [expAlpha_residual]
  positivity

/-! ## 7. Theorem 10 row 3, with the missing hypothesis made explicit -/

/-- **One-step lemma (the engine of Theorem 10 row 3).**  If the residual at step
`k` is `> 0` and `α n → 0`, then some `n ≥ k` is taken and the residual strictly
decreases at that step.

Indeed, let `n` be the first index `≥ k` with `α n ≤ residual α x k`.  Every
earlier index `j ∈ [k, n)` has `α j > residual α x k ≥ residual α x j`, hence is
*not* taken, so the residual is still `residual α x k` at time `n`; then `n` is
taken and the residual drops by `α n > 0`. -/
lemma exists_taken_ge (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 < α n)
    (htend : TendsToZero α) {k : ℕ} (hr : 0 < residual α x k) :
    ∃ n, k ≤ n ∧ taken α x n ∧ residual α x (n + 1) < residual α x k := by
  let r := residual α x k
  obtain ⟨N, hN⟩ := htend r (show 0 < r from hr)
  have hex : ∃ n, k ≤ n ∧ α n ≤ r :=
    ⟨max k N, le_max_left k N, le_of_lt (hN (max k N) (le_max_right k N))⟩
  have hkey : ∃ n, k ≤ n ∧ α n ≤ r ∧ ∀ j, k ≤ j → j < n → r < α j := by
    refine ⟨Nat.find hex, (Nat.find_spec hex).1, (Nat.find_spec hex).2, ?_⟩
    intro j hkj hjn
    by_contra hle
    exact Nat.find_min hex hjn ⟨hkj, le_of_not_gt hle⟩
  obtain ⟨n, hnk, hnr, hmin⟩ := hkey
  -- the residual is still `r` at time `n`
  have hconst : ∀ j, k ≤ j → j ≤ n → residual α x j = r := by
    intro j
    induction j with
    | zero =>
        intro hk0 _
        obtain rfl := Nat.le_zero.mp hk0
        rfl
    | succ j ih =>
        intro hkj hjn
        rcases eq_or_lt_of_le hkj with heq | hlt
        · rw [← heq]
        · have hjk : k ≤ j := Nat.lt_succ_iff.mp hlt
          have hjle : j ≤ n := Nat.le_of_succ_le hjn
          have hjlt : j < n := Nat.lt_of_succ_le hjn
          have hresj : residual α x j = r := ih hjk hjle
          have hgt : r < α j := hmin j hjk hjlt
          have hnot : ¬ (α j ≤ residual α x j) := by
            rw [hresj]
            exact not_le.mpr hgt
          rw [residual_succ_of_not_le α x hnot, hresj]
  have hresn : residual α x n = r := hconst n hnk le_rfl
  have htn : taken α x n := by
    show α n ≤ residual α x n
    rw [hresn]
    exact hnr
  refine ⟨n, hnk, htn, ?_⟩
  show residual α x (n + 1) < r
  rw [residual_succ_of_le α x (show α n ≤ residual α x n from htn), hresn]
  linarith [hα n]

/-- **Theorem 10 row 3, abstract form.**  If the alphabet is positive, tends to
`0`, and *no finite sub-sum of the alphabet equals the target* `x`, then the
residual is `> 0` at every step and infinitely many indices are taken: the
process never halts.

This is row 3 of `TRUTHS.md` Theorem 10 with its missing hypothesis ("no finite
sub-sum equals `x`") supplied.  That hypothesis is what rules out the residual
reaching `0`: `residual α x n = 0` would exhibit a finite sub-sum equal to `x`. -/
theorem never_halts_of_tendsto_zero (α : ℕ → ℚ) (x : ℚ) (hx : 0 < x)
    (hα : ∀ n, 0 < α n) (htend : TendsToZero α)
    (hsub : ∀ s : Finset ℕ, (∑ k ∈ s, α k) ≠ x) :
    (∀ n, 0 < residual α x n) ∧ Set.Infinite {n : ℕ | taken α x n} := by
  -- the residual never vanishes, by the sub-sum hypothesis
  have hne0 : ∀ n, residual α x n ≠ 0 := by
    intro n h0
    have hid := residual_eq_sub_sum α x n
    rw [h0] at hid
    have h2 : x = ∑ k ∈ range n, digit α x k := by linarith
    have h3 : x = ∑ k ∈ (range n).filter (fun k => α k ≤ residual α x k), α k := by
      have h4 : (∑ k ∈ range n, digit α x k)
          = ∑ k ∈ (range n).filter (fun k => α k ≤ residual α x k), α k := by
        rw [Finset.sum_filter]
        exact sum_congr rfl (fun k _ => rfl)
      linarith
    exact hsub _ h3.symm
  have hnonneg : ∀ n, 0 ≤ residual α x n := residual_nonneg α x hx.le
  have hrespos : ∀ n, 0 < residual α x n := by
    intro n
    rcases lt_or_eq_of_le (hnonneg n) with h | h
    · exact h
    · exact absurd h.symm (hne0 n)
  refine ⟨hrespos, ?_⟩
  rw [Set.infinite_iff_exists_gt]
  intro a
  obtain ⟨n, han, htn, -⟩ := exists_taken_ge α x hα htend (hrespos (a + 1))
  exact ⟨n, htn, by omega⟩

/-- The power alphabet `α n = (n+2)^{-p}` of `TRUTHS.md` Theorem 10, for natural
`p ≥ 1` (`(n+2)^{-p}` with a natural exponent). -/
def powerAlpha (p : ℕ) : ℕ → ℚ := fun n => ((n + 2 : ℚ) ^ p)⁻¹

/-- The power alphabet is positive. -/
lemma powerAlpha_pos (p : ℕ) (n : ℕ) : 0 < powerAlpha p n := by
  unfold powerAlpha
  exact inv_pos.mpr (pow_pos (by positivity) p)

/-- **`(n+2)^{-p} → 0` for `p > 0`** (natural `p ≥ 1`): the only analytic fact
about the power family that Theorem 10 row 3 needs. -/
lemma powerAlpha_tendsto_zero (p : ℕ) (hp : 0 < p) : TendsToZero (powerAlpha p) := by
  intro ε hε
  obtain ⟨m, hm⟩ := exists_nat_gt ε⁻¹
  refine ⟨m + 2, fun n hn => ?_⟩
  have hmpos : (0 : ℚ) < (m : ℚ) := lt_trans (inv_pos.mpr hε) hm
  have h1 : (1 : ℚ) / (m : ℚ) < ε := by
    have h := (inv_lt_comm₀ hε hmpos).mp hm
    simpa [one_div] using h
  have hbase : (1 : ℚ) ≤ (n + 2 : ℚ) := by
    have : (1 : ℕ) ≤ n + 2 := by omega
    exact_mod_cast this
  have hle : powerAlpha p n ≤ ((n + 2 : ℚ))⁻¹ := by
    unfold powerAlpha
    refine (inv_le_inv₀ (pow_pos (by positivity) p)
      (by positivity : (0 : ℚ) < (n + 2 : ℚ))).mpr ?_
    calc (n + 2 : ℚ) = ((n + 2 : ℚ)) ^ 1 := (pow_one _).symm
      _ ≤ ((n + 2 : ℚ)) ^ p := pow_le_pow_right₀ hbase hp
  have hsmall : ((n + 2 : ℚ))⁻¹ < (1 : ℚ) / (m : ℚ) := by
    have hlt : (m : ℚ) < (n + 2 : ℚ) := by
      have : m < n + 2 := by omega
      exact_mod_cast this
    have h := one_div_lt_one_div_of_lt hmpos hlt
    simpa [one_div] using h
  linarith

/-- **Theorem 10 row 3** (`α n = (n+2)^{-p}`, `p > 0`, `x = 1`) with the missing
hypothesis made explicit.  If no finite sub-sum of the alphabet equals `1`, then
the residual is positive at every step and the taken set is infinite: the
process never halts. -/
theorem powerAlpha_never_halts (p : ℕ) (hp : 0 < p)
    (hsub : ∀ s : Finset ℕ, (∑ k ∈ s, powerAlpha p k) ≠ 1) :
    (∀ n, 0 < residual (powerAlpha p) 1 n) ∧
      Set.Infinite {n : ℕ | taken (powerAlpha p) 1 n} :=
  never_halts_of_tendsto_zero (powerAlpha p) 1 one_pos (powerAlpha_pos p)
    (powerAlpha_tendsto_zero p hp) hsub

/-- Infinitely many indices are taken, in the "for every bound" form. -/
theorem powerAlpha_infinitely_many_taken (p : ℕ) (hp : 0 < p)
    (hsub : ∀ s : Finset ℕ, (∑ k ∈ s, powerAlpha p k) ≠ 1) :
    ∀ k : ℕ, ∃ n ≥ k, taken (powerAlpha p) 1 n := by
  have h := (powerAlpha_never_halts p hp hsub).2
  rw [Set.infinite_iff_exists_gt] at h
  intro k
  obtain ⟨n, htn, hkn⟩ := h k
  exact ⟨n, by omega, htn⟩

/-! ## 8. Theorem 12: the impossibility half

A halting process has a finite support.  For a finite support `S` with maximum
`a_m` and any truncation `N ≥ 2 a_m + 2`, the maximum of `L ↦ complexity S N L`
over `1 ≤ L ≤ N` is the fixed number `a_m + 2`; hence a homogeneous linear
profile `p(L) = c·L` (with `c > 0`), and in particular `p(L) = L + 1`, is
impossible. -/

/-- After halting at `N₀`, no later index is taken (the residual stays `0` and
`α > 0`). -/
theorem not_taken_of_residual_eq_zero (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 < α n)
    {N₀ : ℕ} (h : residual α x N₀ = 0) : ∀ n ≥ N₀, ¬ taken α x n := by
  have hres : ∀ k, residual α x (N₀ + k) = 0 := by
    intro k
    induction k with
    | zero => simpa using h
    | succ k ih =>
        have hnot : ¬ (α (N₀ + k) ≤ residual α x (N₀ + k)) := by
          rw [ih]
          exact not_le.mpr (hα (N₀ + k))
        rw [Nat.add_succ, residual_succ_of_not_le α x hnot, ih]
  intro n hn htn
  have hrn : residual α x n = 0 := by
    have hn' : n = N₀ + (n - N₀) := (Nat.add_sub_cancel' hn).symm
    rw [hn']
    exact hres (n - N₀)
  have hle : α n ≤ residual α x n := htn
  rw [hrn] at hle
  linarith [hα n]

/-- A halting process with positive target has nonempty support: if no digit were
ever taken, the residual would still be `x > 0`. -/
lemma digitSupport_nonempty_of_halting (α : ℕ → ℚ) (x : ℚ) {N₀ : ℕ} (hx : 0 < x)
    (h : residual α x N₀ = 0) : (digitSupport α x N₀).Nonempty := by
  by_contra hemp
  rw [Finset.not_nonempty_iff_eq_empty] at hemp
  have hzero : (∑ k ∈ range N₀, digit α x k) = 0 := by
    apply sum_eq_zero
    intro k hk
    have hkt : ¬ (α k ≤ residual α x k) := by
      intro hle
      have hmem : k ∈ digitSupport α x N₀ := by
        rw [digitSupport, mem_filter]
        exact ⟨hk, hle⟩
      rw [hemp] at hmem
      exact absurd hmem (by simp)
    simp [digit, hkt]
  have hid := residual_eq_sub_sum α x N₀
  rw [h, hzero, sub_zero] at hid
  linarith

/-- The maximum of the complexity of a finite support of size profile: for
`N ≥ 2 a_m + 2` the plateau is nonempty and the maximum over `1 ≤ L ≤ N` of
`complexity S N L` equals the number `a_m + 2`.  (This is Corollary 4 of
`TRUTHS.md`, restated here as the key input to Theorem 12.) -/
theorem max_complexity_of_finite_support (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N)
    (hne : S.Nonempty) (hN : 2 * S.max' hne + 2 ≤ N) :
    (Icc 1 N).sup (fun L => complexity S N L) = S.max' hne + 2 :=
  max_complexity S N hS hne hN

/-- **Theorem 12 (impossibility), finite-support form.**  A finite support cannot
realise a homogeneous linear complexity profile `p(L) = c·L`, `c > 0`: at
`L = N` the complexity is `1` and at `L = N - 1` it is `2`, which forces
`c = -1`. -/
theorem no_linear_complexity_of_finite_support (S : Finset ℕ) (hne : S.Nonempty)
    (N : ℕ) (hS : S ⊆ range N) (hN : 2 * S.max' hne + 2 ≤ N) (c : ℚ) (hc : 0 < c)
    (hprof : ∀ L, 1 ≤ L → L ≤ N → (complexity S N L : ℚ) = c * (L : ℚ)) : False := by
  have hN1 : 1 ≤ N := by omega
  have hmax1 : S.max' hne + 1 ≤ N := by omega
  have hmax2 : S.max' hne + 1 ≤ N - 1 := by omega
  have h1 : complexity S N N = 1 := complexity_eq_one_of_le S N hS hne hmax1
  have h2 : complexity S N (N - 1) = 2 := complexity_eq_two_of_pred S N hS hne hmax2
  have hp1 : (complexity S N N : ℚ) = c * (N : ℚ) := hprof N hN1 le_rfl
  have hp2 : (complexity S N (N - 1) : ℚ) = c * ((N - 1 : ℕ) : ℚ) :=
    hprof (N - 1) (by omega) (by omega)
  rw [h1] at hp1
  rw [h2] at hp2
  have hcast : ((N - 1 : ℕ) : ℚ) = (N : ℚ) - 1 := by
    rw [Nat.cast_sub hN1]
    norm_num
  rw [hcast] at hp2
  norm_num at hp1 hp2
  have hcN : c * (N : ℚ) = 1 := by linarith
  have hcN1 : c * ((N : ℚ) - 1) = 2 := by linarith
  have htwo : c * (N : ℚ) - c * ((N : ℚ) - 1) = 1 - 2 := by rw [hcN, hcN1]
  have hdiff : c * (N : ℚ) - c * ((N : ℚ) - 1) = c := by ring
  rw [hdiff] at htwo
  linarith

/-- **Theorem 12 (impossibility), Sturmian form.**  A finite support cannot
realise the Sturmian profile `p(L) = L + 1` on `1 ≤ L ≤ N`: at `L = N` the
complexity is `1`, not `N + 1`. -/
theorem no_sturmian_complexity_of_finite_support (S : Finset ℕ) (hne : S.Nonempty)
    (N : ℕ) (hS : S ⊆ range N) (hN : 2 * S.max' hne + 2 ≤ N)
    (hprof : ∀ L, 1 ≤ L → L ≤ N → complexity S N L = L + 1) : False := by
  have hN1 : 1 ≤ N := by omega
  have h1 : complexity S N N = 1 := complexity_eq_one_of_le S N hS hne (by omega)
  have h2 : complexity S N N = N + 1 := hprof N hN1 le_rfl
  omega

/-- **Theorem 12 (impossibility), halting-process form.**  A process that halts
at `N₀` has finite support `digitSupport α x N₀`; for `N ≥ 2 a_m + 2` its
complexity maximum is the fixed number `a_m + 2`. -/
theorem max_complexity_of_halting (α : ℕ → ℚ) (x : ℚ) {N₀ N : ℕ} (hN : N₀ ≤ N)
    (hne : (digitSupport α x N₀).Nonempty)
    (hN' : 2 * (digitSupport α x N₀).max' hne + 2 ≤ N) :
    (Icc 1 N).sup (fun L => complexity (digitSupport α x N₀) N L) =
      (digitSupport α x N₀).max' hne + 2 :=
  max_complexity (digitSupport α x N₀) N
    (fun k hk => by
      have hk1 : k < N₀ := ((mem_digitSupport α x).mp hk).1
      exact mem_range.mpr (by omega)) hne hN'

/-- **Theorem 12 (impossibility), halting-process form.**  A halting process
cannot realise the linear profile `p(L) = c·L`, `c > 0`, on its (finite) support. -/
theorem no_linear_complexity_of_halting (α : ℕ → ℚ) (x : ℚ) {N₀ N : ℕ} (hN : N₀ ≤ N)
    (hne : (digitSupport α x N₀).Nonempty)
    (hN' : 2 * (digitSupport α x N₀).max' hne + 2 ≤ N) (c : ℚ) (hc : 0 < c)
    (hprof : ∀ L, 1 ≤ L → L ≤ N →
      (complexity (digitSupport α x N₀) N L : ℚ) = c * (L : ℚ)) : False :=
  no_linear_complexity_of_finite_support (digitSupport α x N₀) hne N
    (fun k hk => by
      have hk1 : k < N₀ := ((mem_digitSupport α x).mp hk).1
      exact mem_range.mpr (by omega)) hN' c hc hprof

end Rh41
