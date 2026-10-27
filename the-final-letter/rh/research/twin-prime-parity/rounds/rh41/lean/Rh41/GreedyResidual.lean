/-
  GreedyResidual.lean — machine-checked proofs for the residual-orbit items of
  `rh41/TRUTHS.md` (the greedy digit word, exact rational arithmetic).

  Object (matching `rh41/digitword.py`): for `x ∈ (0,1)` the greedy rule at step
  `n` compares the residual `r` with `1/(n+2)`, takes the digit 1 iff
  `r ≥ 1/(n+2)`, and subtracts.  `residual n0 r k` below is the residual after
  `k` such steps, starting at step index `n0` with residual `r`.

  Everything is in `ℚ`/`ℕ`/`ℤ`; no analysis, no `ℝ`.  There are no `sorry`s, no
  `admit`s and no new axioms (only classical logic and `propext`/`Quot.sound` via
  Mathlib).  The only automation over concrete numbers is `norm_num` on the
  explicitly listed rationals `residual 0 1 0 … residual 0 1 5`; nothing is
  decided by compiled evaluation (`native_decide` is not used anywhere).

  TRUTHS.md items covered:

  * §3 **"Checked"** `r_{k+1} ≤ r_k²` at every active step — `squaring_identity`
    (the exact identity) and `squaring_law` (the inequality), yielding the
    `A(N) = Ω_x(log log N)` lower bound.
  * §3 **"Checked, and this is the sharp half"** the ratio has no positive lower
    bound — `no_positive_lower_bound`.
  * §3 **Theorem 8 (rational termination)** — `terminates_rat` (first half);
    `terminates_of_pos_lt_one` and `terminates_from` (general-index form);
    `residual_eq_zero_of_le`, `residual_shift`, `residual_eventually_zero` (tail
    formulation).
  * §3 **Theorem 8**, `x = 1` has support exactly `{0, 1, 4}` — `taken_one_iff`.
  * §3 **Theorem 7 (maps)** `u' = q²/s − q` and `s' = 1 − {q²/s}` — `u_map`,
    `induced_map`, `induced_map_int`.
  * The invariant behind §3 — `residual_invariant`.
-/
import Mathlib

set_option maxHeartbeats 1000000
-- Cosmetic: the explicit-statement hypotheses of `squaring_identity` are not all
-- needed by the algebraic identity, and some `Nat.cast_*` rewrites are no-ops.
set_option linter.unusedVariables false
set_option linter.unusedSimpArgs false
set_option linter.unnecessarySeqFocus false

namespace Rh41

-- The residual orbit of the *harmonic* digit word is kept in its own
-- sub-namespace: `Rh41.Alphabet` defines a general-alphabet `residual`/`taken`
-- pair with the same names, so the two must not collide.
namespace Harmonic

open scoped Classical

/-! ## 0. The residual recursion -/

/-- The greedy step at step index `n` is **active** (the digit is 1) when
`1/(n+2) ≤ r`. -/
def active (n : ℕ) (r : ℚ) : Prop := (1 : ℚ) / (n + 2) ≤ r

/-- Residual after `k` steps of the greedy process with alphabet `1/(n+2)`,
starting at step index `n0` with residual `r`.  Step `k` (0-based) uses the
constant `1/(n0+k+2)`. -/
def residual (n0 : ℕ) (r : ℚ) : ℕ → ℚ
  | 0 => r
  | k + 1 => if (1 : ℚ) / (n0 + k + 2) ≤ residual n0 r k
             then residual n0 r k - (1 : ℚ) / (n0 + k + 2) else residual n0 r k

/-- One unfolding step of `residual`, as an `if` over the explicit inequality
(matching the definition). -/
lemma residual_succ (n0 : ℕ) (r : ℚ) (k : ℕ) :
    residual n0 r (k + 1) =
      if (1 : ℚ) / (n0 + k + 2) ≤ residual n0 r k then
        residual n0 r k - (1 : ℚ) / (n0 + k + 2) else residual n0 r k := by
  simp only [residual]

/-- `active` is definitionally the inequality used by `residual`. -/
lemma active_iff (n : ℕ) (r : ℚ) : active n r ↔ (1 : ℚ) / (n + 2) ≤ r := Iff.rfl

/-! ## 1. Existence of the first active constant

For `r > 0` there is always a smallest `k ≥ 2` with `1/k ≤ r`; this is the
(`ceil (1/r)`, clamped at 2) of Theorem 8's proof. -/

/-- For `r > 0` some `k ≥ 2` satisfies `1/k ≤ r` (Archimedean property). -/
lemma exists_active_const (r : ℚ) (hr : 0 < r) :
    ∃ j : ℕ, 2 ≤ j ∧ (1 : ℚ) / j ≤ r := by
  obtain ⟨m, hm⟩ := exists_nat_gt (max (1 / r) 2 : ℚ)
  refine ⟨m, ?_, ?_⟩
  · have h2 : (2 : ℚ) < m := lt_of_le_of_lt (le_max_right _ _) hm
    exact_mod_cast h2.le
  · have h1 : (1 : ℚ) / r < m := lt_of_le_of_lt (le_max_left _ _) hm
    have hr' : (0 : ℚ) < 1 / r := by positivity
    have hmpos : (0 : ℚ) < m := by linarith
    rw [div_le_iff₀ hmpos]
    have h2 : (1 : ℚ) < m * r := (div_lt_iff₀ hr).mp h1
    linarith

/-- The first active constant: the least `k ≥ 2` with `1/k ≤ r`. -/
noncomputable def firstActive (r : ℚ) (hr : 0 < r) : ℕ :=
  Nat.find (exists_active_const r hr)

/-- Characterisation of `firstActive`: it is `≥ 2` and satisfies `1/k ≤ r`. -/
lemma firstActive_spec (r : ℚ) (hr : 0 < r) :
    2 ≤ firstActive r hr ∧ (1 : ℚ) / firstActive r hr ≤ r :=
  Nat.find_spec (exists_active_const r hr)

/-- Minimality of `firstActive`. -/
lemma firstActive_min (r : ℚ) (hr : 0 < r) {j : ℕ} (hj : j < firstActive r hr) :
    ¬ (2 ≤ j ∧ (1 : ℚ) / j ≤ r) :=
  Nat.find_min (exists_active_const r hr) hj

/-- Every constant `2 ≤ j < firstActive` is inactive: `r < 1/j`. -/
lemma firstActive_gt_inv (r : ℚ) (hr : 0 < r) {j : ℕ} (hj2 : 2 ≤ j)
    (hj : j < firstActive r hr) : r < (1 : ℚ) / j := by
  have h := firstActive_min r hr hj
  exact not_le.mp fun hle => h ⟨hj2, hle⟩

/-- If the residual sits below `1/(i+1)`, the first active constant is `≥ i+2`:
all constants used at step indices `≥ i` up to `i+1` are inactive. -/
lemma firstActive_ge (r : ℚ) (hr : 0 < r) {i : ℕ} (hi : r < 1 / ((i : ℚ) + 1)) :
    i + 2 ≤ firstActive r hr := by
  by_contra h
  have hk : firstActive r hr ≤ i + 1 := by omega
  obtain ⟨hk2, hkle⟩ := firstActive_spec r hr
  have hile : (1 : ℚ) / ((i : ℚ) + 1) ≤ 1 / (firstActive r hr) := by
    apply one_div_le_one_div_of_le
    · exact_mod_cast (by omega : 0 < firstActive r hr)
    · exact_mod_cast hk
  linarith

/-- `r < 1/(k-1)` for `k = firstActive r`, whenever `r < 1`. -/
lemma firstActive_gt_inv_pred (r : ℚ) (hr : 0 < r) (hr1 : r < 1) :
    r < 1 / ((firstActive r hr : ℚ) - 1) := by
  rcases lt_or_eq_of_le (firstActive_spec r hr).1 with h3 | h2
  · have hk1 : 2 ≤ firstActive r hr - 1 := by omega
    have hlt : firstActive r hr - 1 < firstActive r hr := by omega
    have hgt := firstActive_gt_inv r hr hk1 hlt
    have hcast : ((firstActive r hr - 1 : ℕ) : ℚ) = (firstActive r hr : ℚ) - 1 := by
      push_cast [Nat.cast_sub (by omega : 1 ≤ firstActive r hr)]
      ring
    rwa [hcast] at hgt
  · have hk2 : firstActive r hr = 2 := h2.symm
    rw [hk2]
    norm_num
    exact hr1

/-! ## 2. Theorem 8 (first half): rational termination

The standard Fibonacci–Sylvester argument: at an active step with constant `k`
the residual `p/q` becomes `(p·k − q)/(q·k)`, and `k < q/p + 1` gives
`p·k − q < p`, so the numerator in lowest terms strictly decreases.  The
induction is carried out for an arbitrary starting index `i` under the invariant
`r < 1/(i+1)`, which is exactly what the recursive call preserves. -/

/-- **Fibonacci–Sylvester numerator decrease.**  If the step with constant `k`
is active (`1/k ≤ r`), the next constant is strictly beyond the greedy choice
(`r·(k−1) < 1`), and the new residual is nonzero, then the numerator of the new
residual (in lowest terms) is strictly smaller. -/
lemma num_sub_inv_lt {r : ℚ} {k : ℕ} (hk : 2 ≤ k) (hle : (1 : ℚ) / k ≤ r)
    (hltrk : r * ((k : ℚ) - 1) < 1) (hne : r - (1 : ℚ) / k ≠ 0) :
    (r - (1 : ℚ) / k).num.natAbs < r.num.natAbs := by
  have hr : 0 < r := lt_of_lt_of_le (by positivity) hle
  have hnum : 0 < r.num := Rat.num_pos.mpr hr
  have hkq : (0 : ℚ) < (k : ℚ) := by
    have : 0 < k := by omega
    exact_mod_cast this
  set m : ℤ := r.num * (k : ℤ) - (r.den : ℤ) with hm
  set n : ℤ := (r.den : ℤ) * (k : ℤ) with hn
  have hden : (r.den : ℤ) ≠ 0 := by exact_mod_cast r.den_ne_zero
  have hkZ : (k : ℤ) ≠ 0 := by
    have : 0 < k := by omega
    exact_mod_cast this.ne'
  have hn0 : n ≠ 0 := by
    rw [hn]; exact mul_ne_zero hden hkZ
  have hrden : r * (r.den : ℚ) = (r.num : ℚ) := by
    nth_rewrite 1 [← Rat.num_div_den r]
    rw [div_mul_cancel₀]
    exact_mod_cast r.den_ne_zero
  have hrepr : r - (1 : ℚ) / k = (m : ℚ) / (n : ℚ) := by
    rw [hm, hn]
    push_cast
    rw [eq_div_iff (by positivity : ((r.den : ℚ) * (k : ℚ)) ≠ 0)]
    field_simp
    nlinarith [hrden]
  have hdvd : (r - (1 : ℚ) / k).num ∣ m := by
    rw [hrepr, ← Rat.divInt_eq_div m n]
    exact Rat.num_dvd m hn0
  have hmnonneg : 0 ≤ m := by
    have h1 : (1 : ℚ) ≤ r * (k : ℚ) := (div_le_iff₀ hkq).mp hle
    have h2 : (r.den : ℚ) ≤ (k : ℚ) * (r.num : ℚ) := by
      have h3 := mul_le_mul_of_nonneg_right h1 (show (0 : ℚ) ≤ r.den by positivity)
      nlinarith [h3, hrden]
    have h4 : (0 : ℚ) ≤ (m : ℚ) := by
      rw [hm]; push_cast; linarith
    exact_mod_cast h4
  have hmne : m ≠ 0 := by
    intro h0
    apply hne
    rw [hrepr, h0]
    simp
  have hmlt : m < r.num := by
    have h1 : r * ((k : ℚ) - 1) * (r.den : ℚ) < 1 * (r.den : ℚ) :=
      mul_lt_mul_of_pos_right hltrk (by positivity)
    have h2 : (m : ℚ) < (r.num : ℚ) := by
      rw [hm]; push_cast
      nlinarith [hrden, h1]
    exact_mod_cast h2
  have hle' : (r - (1 : ℚ) / k).num.natAbs ≤ m.natAbs :=
    Int.natAbs_le_of_dvd_ne_zero hdvd hmne
  have hmlt' : m.natAbs < r.num.natAbs := by
    have : (m.natAbs : ℤ) < (r.num.natAbs : ℤ) := by
      rw [Int.natAbs_of_nonneg hmnonneg, Int.natAbs_of_nonneg hnum.le]
      exact hmlt
    exact_mod_cast this
  omega

/-! ## 3. Shift and tail lemmas for the residual -/

/-- The residual is a genuine time-homogeneous orbit: after `k` steps the rest
of the run is the run started afresh at index `n0+k` with the current residual. -/
lemma residual_add (n0 : ℕ) (r : ℚ) (k : ℕ) :
    ∀ m, residual n0 r (k + m) = residual (n0 + k) (residual n0 r k) m
  | 0 => rfl
  | m + 1 => by
      rw [Nat.add_succ, residual_succ, residual_succ, residual_add n0 r k m]
      simp only [Nat.cast_add, add_assoc]

/-- Once the residual is `0` it stays `0`: all later steps are inactive. -/
lemma residual_eq_zero_of_le {n0 : ℕ} {r : ℚ} {k m : ℕ}
    (h : residual n0 r k = 0) (hkm : k ≤ m) : residual n0 r m = 0 := by
  obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le hkm
  clear hkm
  induction d with
  | zero => rw [Nat.add_zero]; exact h
  | succ d ih =>
      rw [Nat.add_succ, residual_succ, ih]
      simp only [Nat.cast_add, Nat.cast_ofNat]
      have hpos : (0 : ℚ) < 1 / (↑n0 + (↑k + ↑d) + 2) := by positivity
      rw [ite_eq_right (not_le.mpr hpos)]

/-- If the residual is below every constant of the skipped prefix, the run from
step `0` does not move during the first `n0` steps. -/
lemma residual_zero_prefix (n0 : ℕ) (r : ℚ) (hr : r < 1 / ((n0 : ℚ) + 1)) :
    residual 0 r n0 = r := by
  induction n0 with
  | zero => rfl
  | succ n ih =>
      have h1 : r < 1 / ((n : ℚ) + 1) := by
        have h2 : (1 : ℚ) / ((n : ℚ) + 2) ≤ 1 / ((n : ℚ) + 1) := by
          apply one_div_le_one_div_of_le <;> [positivity; linarith]
        have h3 : (1 : ℚ) / ((↑n : ℚ) + 2) = 1 / ((↑(n + 1) : ℚ) + 1) := by push_cast; ring
        rw [h3] at h2
        linarith
      rw [residual_succ, ih h1]
      simp only [Nat.cast_add, Nat.cast_ofNat, Nat.cast_zero]
      have h3 : ¬ ((1 : ℚ) / (0 + (↑n : ℚ) + 2) ≤ r) := by
        have hr' : r < 1 / (0 + (↑n : ℚ) + 2) := by
          have h4 : (1 : ℚ) / (0 + (↑n : ℚ) + 2) = 1 / ((↑(n + 1) : ℚ) + 1) := by
            push_cast; ring
          rw [h4]; exact hr
        exact not_le.mpr hr'
      rw [ite_eq_right h3]

/-- Residual from step `n0` with `r < 1/(n0+1)` equals the residual from step `0`
at time `n0+m`: the skipped prefix is a genuine shift. -/
lemma residual_shift (n0 : ℕ) (r : ℚ) (hr : r < 1 / ((n0 : ℚ) + 1)) (m : ℕ) :
    residual n0 r m = residual 0 r (n0 + m) := by
  have h := residual_add 0 r n0 m
  rw [Nat.zero_add] at h
  rw [residual_zero_prefix n0 r hr] at h
  exact h.symm

/-! ## 4. Index bookkeeping for the first active step -/

/-- Before the first active constant the residual is constant. -/
lemma residual_stays (i : ℕ) (r : ℚ) (hr : 0 < r) {m : ℕ}
    (hm : m ≤ firstActive r hr - i - 2) : residual i r m = r := by
  induction m with
  | zero => rfl
  | succ m ih =>
      have hm' : m ≤ firstActive r hr - i - 2 := by omega
      rw [residual_succ, ih hm']
      have hconst : i + m + 2 < firstActive r hr := by omega
      have h2 : 2 ≤ i + m + 2 := by omega
      have hgt : r < (1 : ℚ) / (↑i + ↑m + 2) := by
        have h := firstActive_gt_inv r hr h2 hconst
        simpa only [Nat.cast_add, Nat.cast_ofNat] using h
      exact ite_eq_right (not_le.mpr hgt)

/-- The residual exactly after the first active step: `r - 1/firstActive`. -/
lemma residual_first (i : ℕ) (r : ℚ) (hr : 0 < r) (hik : i + 2 ≤ firstActive r hr) :
    residual i r (firstActive r hr - i - 1) = r - 1 / (firstActive r hr) := by
  have h1 : firstActive r hr - i - 1 = (firstActive r hr - i - 2) + 1 := by omega
  rw [h1, residual_succ, residual_stays i r hr (by omega)]
  have hcast : (↑i : ℚ) + ↑(firstActive r hr - i - 2) + 2 = (firstActive r hr : ℚ) := by
    have hc : i + (firstActive r hr - i - 2) + 2 = firstActive r hr := by omega
    exact_mod_cast hc
  rw [hcast, ite_eq_left (firstActive_spec r hr).2]

/-! ## 5. Termination theorem -/

/-- **Theorem 8 (first half), general-index form.**  From any step index `i`,
a positive rational residual below `1/(i+1)` reaches `0` in finitely many
steps. -/
theorem terminates_aux (p : ℕ) : ∀ (i : ℕ) (r : ℚ),
    0 < r → r < 1 / ((i : ℚ) + 1) → r.num.natAbs = p → ∃ N, residual i r N = 0 := by
  induction p using Nat.strong_induction_on with
  | h p ih =>
    intro i r hr hlt hnum
    have hk2 : 2 ≤ firstActive r hr := (firstActive_spec r hr).1
    have hkle : (1 : ℚ) / (firstActive r hr) ≤ r := (firstActive_spec r hr).2
    have hkpos : (0 : ℚ) < (firstActive r hr : ℚ) := by
      have : 0 < firstActive r hr := by omega
      exact_mod_cast this
    have hk1pos : (0 : ℚ) < (firstActive r hr : ℚ) - 1 := by
      have h : (2 : ℚ) ≤ (firstActive r hr : ℚ) := by exact_mod_cast hk2
      linarith
    have hge : i + 2 ≤ firstActive r hr := firstActive_ge r hr hlt
    have hdiv1 : (1 : ℚ) / ((i : ℚ) + 1) ≤ 1 := by
      rw [div_le_one (by positivity)]; linarith
    have hr1 : r < 1 := lt_of_lt_of_le hlt hdiv1
    have hgtpred : r < 1 / ((firstActive r hr : ℚ) - 1) := firstActive_gt_inv_pred r hr hr1
    have hltrk : r * ((firstActive r hr : ℚ) - 1) < 1 := (lt_div_iff₀ hk1pos).mp hgtpred
    by_cases hzero : r - (1 : ℚ) / (firstActive r hr) = 0
    · exact ⟨firstActive r hr - i - 1, by rw [residual_first i r hr hge]; exact hzero⟩
    · have hr'pos : 0 < r - (1 : ℚ) / (firstActive r hr) := by
        have : 0 ≤ r - (1 : ℚ) / (firstActive r hr) := by linarith
        exact lt_of_le_of_ne this (Ne.symm hzero)
      have hnumlt : (r - (1 : ℚ) / (firstActive r hr)).num.natAbs < p := by
        rw [← hnum]
        exact num_sub_inv_lt hk2 hkle hltrk hzero
      have hinv : r - (1 : ℚ) / (firstActive r hr)
          < 1 / (((firstActive r hr - 1 : ℕ) : ℚ) + 1) := by
        have hcast : (((firstActive r hr - 1 : ℕ)) : ℚ) + 1 = (firstActive r hr : ℚ) := by
          push_cast [Nat.cast_sub (by omega : 1 ≤ firstActive r hr)]
          ring
        rw [hcast]
        have hsub : (1 : ℚ) / ((firstActive r hr : ℚ) - 1) - 1 / (firstActive r hr : ℚ)
            = 1 / ((firstActive r hr : ℚ) * ((firstActive r hr : ℚ) - 1)) := by
          field_simp
          ring
        have hle1 : (1 : ℚ) / ((firstActive r hr : ℚ) * ((firstActive r hr : ℚ) - 1))
            ≤ 1 / (firstActive r hr : ℚ) := by
          apply one_div_le_one_div_of_le hkpos
          have h2 : (0 : ℚ) ≤ (firstActive r hr : ℚ) - 2 := by
            have h3 : (2 : ℚ) ≤ (firstActive r hr : ℚ) := by exact_mod_cast hk2
            linarith
          nlinarith
        linarith [hgtpred, hsub, hle1]
      obtain ⟨M, hM⟩ := ih (r - (1 : ℚ) / (firstActive r hr)).num.natAbs hnumlt
        (firstActive r hr - 1) (r - (1 : ℚ) / (firstActive r hr)) hr'pos hinv rfl
      refine ⟨firstActive r hr - i - 1 + M, ?_⟩
      rw [residual_add i r (firstActive r hr - i - 1) M, residual_first i r hr hge]
      have : i + (firstActive r hr - i - 1) = firstActive r hr - 1 := by omega
      rw [this]
      exact hM

/-- **Theorem 8 (first half).**  Every positive rational below `1` terminates
under the greedy rule. -/
theorem terminates_of_pos_lt_one (r : ℚ) (hr0 : 0 < r) (hr1 : r < 1) :
    ∃ N, residual 0 r N = 0 :=
  terminates_aux r.num.natAbs 0 r hr0 (by simpa using hr1) rfl

/-- **Theorem 8 (first half), `p/q` form.**  For `0 < p < q` the greedy residual
of `p/q` reaches `0` at some finite step. -/
theorem terminates_rat (p q : ℕ) (hp : 0 < p) (hq : p < q) :
    ∃ N, residual 0 ((p : ℚ) / q) N = 0 := by
  have hq0 : (0 : ℚ) < q := by
    have : 0 < q := by omega
    exact_mod_cast this
  have hr0 : 0 < (p : ℚ) / q := by positivity
  have hr1 : (p : ℚ) / q < 1 := by
    rw [div_lt_one hq0]
    exact_mod_cast hq
  exact terminates_of_pos_lt_one _ hr0 hr1

/-- Termination from an arbitrary starting index `i`, under the invariant
`r < 1/(i+1)`. -/
theorem terminates_from (i : ℕ) (r : ℚ) (hr : 0 < r) (hlt : r < 1 / ((i : ℚ) + 1)) :
    ∃ N, residual i r N = 0 :=
  terminates_aux r.num.natAbs i r hr hlt rfl

/-- **Tail formulation.**  The residual vanishes from some index on (and then
stays `0`). -/
theorem residual_eventually_zero (i : ℕ) (r : ℚ) (hr : 0 < r)
    (hlt : r < 1 / ((i : ℚ) + 1)) : ∃ N, ∀ m, N ≤ m → residual i r m = 0 := by
  obtain ⟨N, hN⟩ := terminates_from i r hr hlt
  exact ⟨N, fun m hm => residual_eq_zero_of_le hN hm⟩

/-! ## 6. Theorem 1: the invariant of the residual -/

/-- Nonnegativity of one greedy step (`c = 1/(n+2)`). -/
lemma step_nonneg {c r : ℚ} (hr : 0 ≤ r) : 0 ≤ (if c ≤ r then r - c else r) := by
  by_cases h : c ≤ r
  · rw [ite_eq_left h]; linarith
  · rw [ite_eq_right h]; exact hr

/-- One step preserves the strict upper bound: from `r < 1/(n+1)` the residual
after the step is `< 1/(n+2)`. -/
lemma step_lt {r : ℚ} {n : ℕ} (hr : r < 1 / ((n : ℚ) + 1)) :
    (if (1 : ℚ) / ((n : ℚ) + 2) ≤ r then r - 1 / ((n : ℚ) + 2) else r)
      < 1 / ((n : ℚ) + 2) := by
  by_cases h : (1 : ℚ) / ((n : ℚ) + 2) ≤ r
  · rw [ite_eq_left h]
    have hkey : (1 : ℚ) / ((n : ℚ) + 1) - 1 / ((n : ℚ) + 2) ≤ 1 / ((n : ℚ) + 2) := by
      have h1 : (0 : ℚ) < (n : ℚ) + 1 := by positivity
      have h2 : (0 : ℚ) < (n : ℚ) + 2 := by positivity
      rw [sub_le_iff_le_add, ← two_mul, mul_one_div]
      rw [div_le_div_iff₀ h1 h2]
      nlinarith
    linarith
  · rw [ite_eq_right h]
    exact not_le.mp h

/-- **Theorem 1 (invariant).**  For `0 < x < 1` the residual never goes negative
and stays below `1/(n+1)` at step `n`. -/
theorem residual_invariant (x : ℚ) (hx0 : 0 < x) (hx1 : x < 1) :
    ∀ n, 0 ≤ residual 0 x n ∧ residual 0 x n < 1 / ((n : ℚ) + 1) := by
  intro n
  induction n with
  | zero => exact ⟨hx0.le, by norm_num; exact hx1⟩
  | succ n ih =>
      obtain ⟨h0, h1⟩ := ih
      rw [residual_succ]
      simp only [Nat.cast_add, Nat.cast_ofNat, Nat.cast_zero, zero_add]
      refine ⟨step_nonneg h0, ?_⟩
      convert step_lt h1 using 2 <;> push_cast <;> ring

/-! ## 7. Theorem 8 (second half): `x = 1` has support exactly `{0,1,4}`

`1/2 + 1/3 + 1/6 = 1`, so the ones are at steps `0`, `1`, `4`.  Note: the
support is `{0,1,4}`, and the residual first vanishes only at index `5`
(`residual 0 1 4 = 1/6`, `residual 0 1 5 = 0`); the parenthetical "residual
0 1 3 = 0" in the task statement is off by two. -/

/-- `taken n` is the greedy predicate at step `n` for `x = 1`. -/
def taken (n : ℕ) : Prop := (1 : ℚ) / (n + 2) ≤ residual 0 1 n

lemma residual_one_0 : residual 0 1 0 = 1 := rfl
lemma residual_one_1 : residual 0 1 1 = 1 / 2 := by norm_num [residual]
lemma residual_one_2 : residual 0 1 2 = 1 / 6 := by norm_num [residual]
lemma residual_one_3 : residual 0 1 3 = 1 / 6 := by norm_num [residual]
lemma residual_one_4 : residual 0 1 4 = 1 / 6 := by norm_num [residual]
lemma residual_one_5 : residual 0 1 5 = 0 := by norm_num [residual]

lemma taken_zero : taken 0 := by
  show (1 : ℚ) / (0 + 2) ≤ residual 0 1 0
  rw [residual_one_0]; norm_num
lemma taken_one : taken 1 := by
  show (1 : ℚ) / (1 + 2) ≤ residual 0 1 1
  rw [residual_one_1]; norm_num
lemma taken_four : taken 4 := by
  show (1 : ℚ) / (4 + 2) ≤ residual 0 1 4
  rw [residual_one_4]; norm_num
lemma not_taken_two : ¬ taken 2 := by
  show ¬ ((1 : ℚ) / (2 + 2) ≤ residual 0 1 2)
  rw [residual_one_2]; norm_num
lemma not_taken_three : ¬ taken 3 := by
  show ¬ ((1 : ℚ) / (3 + 2) ≤ residual 0 1 3)
  rw [residual_one_3]; norm_num

/-- **Theorem 8 (second half).**  The support for `x = 1` (the `θ = π` case) is
exactly `{0,1,4}`. -/
theorem taken_one_iff (n : ℕ) : taken n ↔ n = 0 ∨ n = 1 ∨ n = 4 := by
  rcases lt_or_ge n 5 with hn | hn
  · interval_cases n
    · exact ⟨fun _ => Or.inl rfl, fun _ => taken_zero⟩
    · exact ⟨fun _ => Or.inr (Or.inl rfl), fun _ => taken_one⟩
    · exact ⟨fun h => absurd h not_taken_two, fun h => by omega⟩
    · exact ⟨fun h => absurd h not_taken_three, fun h => by omega⟩
    · exact ⟨fun _ => Or.inr (Or.inr rfl), fun _ => taken_four⟩
  · have h0 : residual 0 1 n = 0 := residual_eq_zero_of_le residual_one_5 hn
    have hpos : (0 : ℚ) < (1 : ℚ) / (n + 2) := by positivity
    constructor
    · intro h
      have h' : (1 : ℚ) / (n + 2) ≤ residual 0 1 n := h
      rw [h0] at h'
      linarith
    · rintro (h | h | h) <;> omega

/-! ## 8. §3 "Checked": the squaring law `r_{k+1} ≤ r_k²` -/

/-- `f = 1/r - (n+1)`, the fractional-part bookkeeping of TRUTHS.md §3, so that
`1 - f = (n+2) - 1/r`. -/
def squaringFactor (n : ℕ) (r : ℚ) : ℚ := 1 / r - ((n : ℚ) + 1)

/-- **The exact squaring identity** (TRUTHS.md §3).  At an active step with
`1/(n+2) ≤ r < 1/(n+1)` and `f = 1/r - (n+1)`,
`r - 1/(n+2) = (1-f)·r²/(1 + (1-f)·r)`. -/
theorem squaring_identity (n : ℕ) (r : ℚ) (hr : 0 < r)
    (hact : (1 : ℚ) / (n + 2) ≤ r) (hlt : r < 1 / ((n : ℚ) + 1)) :
    r - 1 / (n + 2) =
      (1 - squaringFactor n r) * r^2 / (1 + (1 - squaringFactor n r) * r) := by
  have hq : (0 : ℚ) < (n : ℚ) + 2 := by positivity
  have hqne : ((n : ℚ) + 2) ≠ 0 := hq.ne'
  have hrne : r ≠ 0 := hr.ne'
  have hden : 1 + (1 - squaringFactor n r) * r ≠ 0 := by
    have heq : 1 + (1 - squaringFactor n r) * r = ((n : ℚ) + 2) * r := by
      rw [squaringFactor]
      field_simp
      ring
    rw [heq]
    positivity
  rw [eq_div_iff hden, squaringFactor]
  field_simp
  ring

/-- **The squaring law** (TRUTHS.md §3, checked): at every active step,
`r_{k+1} ≤ r_k²`.  With the active-step lower bound `r_k ≥ 1/(n_k+2)` (the take
rule) this iterates to `r_k ≤ x^{2^k}`, hence `n_k + 2 ≥ x^{−2^k}` and the
**upper** bound `A(N) ≤ log₂(log(N+2)/log(1/x)) = O_x(log log N)`
(direction corrected in the B.2-ranking pass; the earlier docstring stated it as
`Ω_x(log log N)`). -/
theorem squaring_law (n : ℕ) (r : ℚ) (hr : 0 < r)
    (hact : (1 : ℚ) / (n + 2) ≤ r) (hlt : r < 1 / ((n : ℚ) + 1)) :
    r - 1 / (n + 2) ≤ r^2 := by
  rw [squaring_identity n r hr hact hlt]
  have hf0 : 0 < squaringFactor n r := by
    rw [squaringFactor, sub_pos, lt_div_iff₀ hr]
    have h := (lt_div_iff₀ (by positivity : (0 : ℚ) < (n : ℚ) + 1)).mp hlt
    linarith
  have hf1 : squaringFactor n r ≤ 1 := by
    rw [squaringFactor, sub_le_iff_le_add,
      show (1 : ℚ) + ((n : ℚ) + 1) = (n : ℚ) + 2 by ring]
    rw [div_le_iff₀ hr]
    have h := (div_le_iff₀ (by positivity : (0 : ℚ) < (n : ℚ) + 2)).mp hact
    linarith
  have h1f : 0 ≤ 1 - squaringFactor n r := by linarith
  have hden : 0 < 1 + (1 - squaringFactor n r) * r := by
    have : 0 ≤ (1 - squaringFactor n r) * r := mul_nonneg h1f hr.le
    linarith
  rw [div_le_iff₀ hden]
  have hcube : 0 ≤ (1 - squaringFactor n r) * r^3 := mul_nonneg h1f (by positivity)
  nlinarith

/-! ## 9. §5 (refuted row): no positive lower bound for `r'/r²` -/

/-- **No two-sided squaring law** (TRUTHS.md §5, refuted row 8).  For every
`ε > 0` there is a residual `0 < r < 1` and a step index `n` at which the step
is active and `(r - 1/(n+2))/r² < ε`.  Witness `r = 1/2 + 1/m` at `n = 0`. -/
theorem no_positive_lower_bound (ε : ℚ) (hε : 0 < ε) :
    ∃ r : ℚ, 0 < r ∧ r < 1 ∧ ∃ n : ℕ,
      (1 : ℚ) / (n + 2) ≤ r ∧ r < 1 / ((n : ℚ) + 1) ∧
        (r - 1 / (n + 2)) / r^2 < ε := by
  obtain ⟨m, hm⟩ := exists_nat_gt (max (4 / ε) 3 : ℚ)
  have hm4 : (4 : ℚ) / ε < m := lt_of_le_of_lt (le_max_left _ _) hm
  have hm3 : (3 : ℚ) < m := lt_of_le_of_lt (le_max_right _ _) hm
  have hm0 : (0 : ℚ) < m := by linarith
  have h4m : (4 : ℚ) / m < ε := by
    rw [div_lt_iff₀ hm0]
    have h := (div_lt_iff₀ hε).mp hm4
    nlinarith
  refine ⟨1 / 2 + 1 / m, ?_, ?_, 0, ?_, ?_, ?_⟩
  · have : (0 : ℚ) < 1 / (m : ℚ) := one_div_pos.mpr hm0
    linarith
  · have : (1 : ℚ) / (m : ℚ) < 1 / 2 := by
      rw [div_lt_div_iff₀ hm0 (by norm_num : (0 : ℚ) < 2)]
      linarith
    linarith
  · have he : (1 : ℚ) / (((0 : ℕ) : ℚ) + 2) = 1 / 2 := by norm_num
    rw [he]
    have : (0 : ℚ) < 1 / (m : ℚ) := one_div_pos.mpr hm0
    linarith
  · have he : (1 : ℚ) / (((0 : ℕ) : ℚ) + 1) = 1 := by norm_num
    rw [he]
    have : (1 : ℚ) / (m : ℚ) < 1 / 2 := by
      rw [div_lt_div_iff₀ hm0 (by norm_num : (0 : ℚ) < 2)]
      linarith
    linarith
  · have he : (1 : ℚ) / (((0 : ℕ) : ℚ) + 2) = 1 / 2 := by norm_num
    rw [he]
    have h1mpos : (0 : ℚ) < 1 / (m : ℚ) := one_div_pos.mpr hm0
    have hbase : (0 : ℚ) < 1 / 2 + 1 / (m : ℚ) := by linarith
    have hpos : (0 : ℚ) < (1 / 2 + 1 / (m : ℚ))^2 := pow_pos hbase 2
    have hle : (1 / 4 : ℚ) ≤ (1 / 2 + 1 / (m : ℚ))^2 := by nlinarith
    have hεle : ε * (1 / 4) ≤ ε * (1 / 2 + 1 / (m : ℚ))^2 :=
      mul_le_mul_of_nonneg_left hle hε.le
    have h14 : (1 : ℚ) / (m : ℚ) = (1 / 4) * ((4 : ℚ) / (m : ℚ)) := by
      field_simp
    have hkey : (1 : ℚ) / (m : ℚ) < ε * (1 / 2 + 1 / (m : ℚ))^2 := by nlinarith
    rw [div_lt_iff₀ hpos]
    have hrew : 1 / 2 + 1 / (m : ℚ) - 1 / 2 = 1 / (m : ℚ) := by ring
    rw [hrew]
    exact hkey

/-! ## 10. Theorem 7: the `u`-map and the induced map on `s` -/

/-- **Theorem 7, first identity.**  With `u = 1/r` and `q = n+2`, the next
inverse residual is `u' = q²/s - q` where `s = q - u`.  The hypothesis
`1/(n+2) < r` is strict: when `r = 1/(n+2)` the residual vanishes and `s = 0`
(termination), so the identity has no meaning there. -/
theorem u_map (n : ℕ) (r : ℚ) (hr : 0 < r) (hact : (1 : ℚ) / (n + 2) < r) :
    1 / (r - 1 / (n + 2)) =
      ((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r) - ((n : ℚ) + 2) := by
  have hq : (0 : ℚ) < (n : ℚ) + 2 := by positivity
  have h1 : (0 : ℚ) < r - 1 / ((n : ℚ) + 2) := by
    rw [sub_pos, div_lt_iff₀ hq]
    have h := (div_lt_iff₀ hq).mp hact
    nlinarith
  have hs : (0 : ℚ) < ((n : ℚ) + 2) - 1 / r := by
    rw [sub_pos, div_lt_iff₀ hr]
    have h := (div_lt_iff₀ hq).mp hact
    nlinarith
  have h1ne : r - 1 / ((n : ℚ) + 2) ≠ 0 := h1.ne'
  have hsne : ((n : ℚ) + 2) - 1 / r ≠ 0 := hs.ne'
  have hrne : r ≠ 0 := hr.ne'
  have hqne : ((n : ℚ) + 2) ≠ 0 := hq.ne'
  have hqr : r * ((n : ℚ) + 2) - 1 ≠ 0 := by
    have h := (div_lt_iff₀ hq).mp hact
    exact (show (0 : ℚ) < r * ((n : ℚ) + 2) - 1 by nlinarith).ne'
  field_simp
  ring

/-- **Theorem 7, induced map (non-integral case).**  With `t = q²/s`, the new
`q' - u'` equals `1 - {t}` (the fractional part is `Int.fract`), provided
`t` is not an integer.  When `t` is an integer the left side is `0` — this is
exactly the termination case, see `induced_map_int`.  `Int.fract` is used as the
`ℚ`-valued fractional part. -/
theorem induced_map (n : ℕ) (r : ℚ) (hr : 0 < r) (hact : (1 : ℚ) / (n + 2) < r)
    (hfract : Int.fract (((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r)) ≠ 0) :
    ((⌈1 / (r - 1 / (n + 2))⌉ : ℤ) : ℚ) - 1 / (r - 1 / (n + 2)) =
      1 - Int.fract (((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r)) := by
  set t : ℚ := ((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r) with ht
  have hfract' : Int.fract t ≠ 0 := by rw [ht]; exact hfract
  have hu : 1 / (r - 1 / (n + 2)) = t - ((n : ℚ) + 2) := by
    rw [ht]; exact u_map n r hr hact
  have hceil : (⌈1 / (r - 1 / (n + 2))⌉ : ℤ) = ⌈t⌉ - ((n + 2 : ℕ) : ℤ) := by
    rw [hu, show ((n : ℚ) + 2) = ((n + 2 : ℕ) : ℚ) by push_cast; ring,
      Int.ceil_sub_natCast]
  have hcast : (((n + 2 : ℕ) : ℤ) : ℚ) = (n : ℚ) + 2 := by push_cast; ring
  have hceil_eq : (⌈t⌉ : ℚ) = (⌊t⌋ : ℚ) + 1 := by
    have hfpos : 0 < Int.fract t := lt_of_le_of_ne (Int.fract_nonneg t) (Ne.symm hfract')
    have h1 : (⌊t⌋ : ℚ) < t := by
      have hlt : t - ⌊t⌋ < 1 := by rw [Int.self_sub_floor]; exact Int.fract_lt_one t
      have : 0 < t - ⌊t⌋ := by rw [Int.self_sub_floor]; exact hfpos
      linarith
    have h2 : t ≤ (⌊t⌋ : ℚ) + 1 := by
      have hlt : t - ⌊t⌋ < 1 := by rw [Int.self_sub_floor]; exact Int.fract_lt_one t
      linarith
    have h3 : ⌈t⌉ = ⌊t⌋ + 1 := by
      refine Int.ceil_eq_iff.mpr ⟨?_, ?_⟩ <;> push_cast <;> linarith
    rw [h3]
    push_cast
    ring
  rw [hceil, hu]
  push_cast
  rw [hceil_eq, ← Int.self_sub_floor t]
  ring

/-- **Theorem 7, induced map (integral / terminating case).**  When
`t = q²/s` is an integer (i.e. `{t} = 0`) the next residual is `0`, so the new
`s' = q' - u'` is `0`.  This is the missing case of `induced_map`. -/
theorem induced_map_int (n : ℕ) (r : ℚ) (hr : 0 < r) (hact : (1 : ℚ) / (n + 2) < r)
    (hfract : Int.fract (((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r)) = 0) :
    ((⌈1 / (r - 1 / (n + 2))⌉ : ℤ) : ℚ) - 1 / (r - 1 / (n + 2)) = 0 := by
  set t : ℚ := ((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r) with ht
  have hfract' : Int.fract t = 0 := by rw [ht]; exact hfract
  have ht_int : t = (⌊t⌋ : ℚ) := by
    have : t - ⌊t⌋ = 0 := by rw [Int.self_sub_floor]; exact hfract'
    linarith
  have hu : 1 / (r - 1 / (n + 2)) = t - ((n : ℚ) + 2) := by
    rw [ht]; exact u_map n r hr hact
  rw [hu, ht_int]
  have hcast : ((⌊t⌋ : ℚ) - ((n : ℚ) + 2)) = (((⌊t⌋ - ((n + 2 : ℕ) : ℤ)) : ℤ) : ℚ) := by
    push_cast; ring
  rw [hcast, Int.ceil_intCast]
  ring

end Harmonic

end Rh41
