import Mathlib

/-!
# sin(x)/x with the greedy harmonic sine — formal core

The archived `harmonic-sine` programme reconstructs `sin (π x)` from the
harmonic angle steps `ε n = 1 / (n + 2)` (in units of `π`), selected
greedily and fused by the angle-addition rule.  This file formalises the
finite objects needed to ask what happens to the normalised sinc kernel

    sinc x = sin (π x) / (π x),    sinc 0 = 1,

when the ordinary sine is replaced by the finite greedy sine
`sin (π * theta_N x)`.

The theorems below are finite-stage facts:

* the step sequence is positive and strictly antitone;
* the greedy residual never increases;
* if every step is larger than the target, no step is selected and
  `theta_N = 0` (the vanishing zone around the origin);
* the reconstruction takes the exact value `1/2` at `theta = 5/6`,
  whereas the ordinary sine vanishes at the integer `1` — the finite
  stage does not share the zeros of the sine;
* a conditional pointwise error bound of size `π/(N+1)`.

The global convergence theorem `theta_N x → x` is **not** proved here.
It is a source claim of the harmonic-sine programme, tested numerically
in the Python layer and recorded as open in the dossier.  Consequently
nothing here asserts that the limit of the reconstructed sinc is the
classical sinc, nor anything about the Riemann hypothesis.
-/

noncomputable section

open Finset

namespace SinXOverX

/-- The harmonic step `ε n = 1 / (n + 2)`, in units of `π`. -/
def eps (n : ℕ) : ℝ := 1 / ((n : ℝ) + 2)

/-- One greedy residual step: subtract `ε n` exactly when it fits. -/
def step (r : ℝ) (n : ℕ) : ℝ := r - if eps n ≤ r then eps n else 0

/-- The residual after `n` greedy steps. -/
def resid (y : ℝ) : ℕ → ℝ
  | 0 => y
  | n + 1 => step (resid y n) n

/-- The angle selected at step `n`. -/
def delta (y : ℝ) (n : ℕ) : ℝ := if eps n ≤ resid y n then eps n else 0

/-- The accumulated greedy angle after `N` steps. -/
def theta (y : ℝ) (N : ℕ) : ℝ := (Finset.range N).sum (fun n => delta y n)

/-- The angle-addition sine of a greedy angle. -/
def greedySine (θ : ℝ) : ℝ := Real.sin (Real.pi * θ)

/-- The finite greedy reconstruction of `sin (π y)`. -/
def reconSine (y : ℝ) (N : ℕ) : ℝ := greedySine (theta y N)

/-- The reconstructed normalised sinc `S_N(y) / (π y)`. -/
def reconSinc (y : ℝ) (N : ℕ) : ℝ := reconSine y N / (Real.pi * y)

theorem eps_pos (n : ℕ) : 0 < eps n := by
  unfold eps
  positivity

theorem eps_strictAnti : StrictAnti eps := by
  intro a b hab
  unfold eps
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left one_pos (by positivity) h

/-- The harmonic steps decrease with `n`. -/
theorem eps_le_eps_of_le {n m : ℕ} (h : n ≤ m) : eps m ≤ eps n := by
  rcases Nat.lt_or_eq_of_le h with hlt | rfl
  · exact (eps_strictAnti hlt).le
  · exact le_rfl

theorem step_le_self (r : ℝ) (n : ℕ) : step r n ≤ r := by
  unfold step
  split_ifs with h
  · linarith [eps_pos n]
  · linarith

/-- The residual never increases. -/
theorem resid_le (y : ℝ) (n : ℕ) : resid y n ≤ y := by
  induction n with
  | zero => exact le_rfl
  | succ n ih =>
      have h1 : resid y (n + 1) ≤ resid y n := step_le_self (resid y n) n
      exact h1.trans ih

/-- If the current residual is below the step, nothing is selected. -/
theorem delta_eq_zero_of_resid_lt {y : ℝ} {n : ℕ} (h : resid y n < eps n) :
    delta y n = 0 := by
  unfold delta
  split_ifs with hle
  · exact absurd hle (not_le.2 h)
  · rfl

/-- If the target is below every step, no step is selected. -/
theorem theta_eq_zero_of_forall_lt {y : ℝ} {N : ℕ}
    (h : ∀ n < N, y < eps n) : theta y N = 0 := by
  unfold theta
  exact Finset.sum_eq_zero (fun n hn =>
    delta_eq_zero_of_resid_lt ((resid_le y n).trans_lt (h n (Finset.mem_range.1 hn))))

/-- The vanishing zone: if `y < ε N`, the first `N + 1` steps are all
skipped and the reconstructed sine is zero. -/
theorem theta_eq_zero_of_lt_eps {y : ℝ} {N : ℕ} (h : y < eps N) :
    theta y (N + 1) = 0 := by
  refine theta_eq_zero_of_forall_lt ?_
  intro n hn
  exact h.trans_le (eps_le_eps_of_le (Nat.le_of_lt_succ hn))

theorem greedySine_zero : greedySine 0 = 0 := by
  unfold greedySine
  simp

/-- The reconstructed sine still vanishes at every integer angle. -/
theorem greedySine_int (k : ℤ) : greedySine (k : ℝ) = 0 := by
  unfold greedySine
  have h : Real.pi * (k : ℝ) = (k : ℝ) * Real.pi := by ring
  rw [h, Real.sin_int_mul_pi]

/-- The zeros of the reconstructed sine are exactly the integers. -/
theorem greedySine_eq_zero_iff (θ : ℝ) :
    greedySine θ = 0 ↔ ∃ k : ℤ, θ = k := by
  unfold greedySine
  rw [Real.sin_eq_zero_iff]
  constructor
  · rintro ⟨k, hk⟩
    refine ⟨k, ?_⟩
    have hk' : Real.pi * (k : ℝ) = Real.pi * θ := by
      simpa [mul_comm] using hk
    exact (mul_left_cancel₀ Real.pi_ne_zero hk').symm
  · rintro ⟨k, rfl⟩
    exact ⟨k, by ring⟩

/-- The reconstructed sine is positive on `(0, 1)` in angle units. -/
theorem greedySine_pos {θ : ℝ} (h0 : 0 < θ) (h1 : θ < 1) : 0 < greedySine θ := by
  unfold greedySine
  apply Real.sin_pos_of_pos_of_lt_pi
  · exact mul_pos Real.pi_pos h0
  · simpa using mul_lt_mul_of_pos_left h1 Real.pi_pos

/-- The finite reconstruction is exactly `1/2` at the angle `5/6`.
The ordinary sine vanishes at the integer angle `1`, so the finite stage
does not share the zeros of the sine it reconstructs. -/
theorem greedySine_five_six : greedySine (5 / 6) = 1 / 2 := by
  unfold greedySine
  have h : Real.pi * (5 / 6 : ℝ) = Real.pi - Real.pi / 6 := by ring
  rw [h, Real.sin_pi_sub, Real.sin_pi_div_six]

/-- Conditional pointwise error bound: if the greedy residual after `N`
steps is at most `1/(N+1)` in angle units, the reconstructed sine is
within `π/(N+1)` of the true sine. -/
theorem reconSine_error {y : ℝ} {N : ℕ}
    (h : |theta y N - y| ≤ 1 / ((N : ℝ) + 1)) :
    |reconSine y N - Real.sin (Real.pi * y)| ≤ Real.pi / ((N : ℝ) + 1) := by
  unfold reconSine greedySine
  have hsin := Real.abs_sin_sub_sin_le (Real.pi * theta y N) (Real.pi * y)
  have hdiff : Real.pi * theta y N - Real.pi * y = Real.pi * (theta y N - y) := by
    ring
  have hbound : |Real.pi * theta y N - Real.pi * y| ≤ Real.pi * (1 / ((N : ℝ) + 1)) := by
    rw [hdiff]
    rw [abs_mul, abs_of_pos Real.pi_pos]
    exact mul_le_mul_of_nonneg_left h Real.pi_pos.le
  calc
    |Real.sin (Real.pi * theta y N) - Real.sin (Real.pi * y)|
        ≤ |Real.pi * theta y N - Real.pi * y| := hsin
    _ ≤ Real.pi * (1 / ((N : ℝ) + 1)) := hbound
    _ = Real.pi / ((N : ℝ) + 1) := by ring

theorem reconSine_eq_zero_of_lt_eps {y : ℝ} {N : ℕ} (h : y < eps N) :
    reconSine y (N + 1) = 0 := by
  unfold reconSine
  rw [theta_eq_zero_of_lt_eps h, greedySine_zero]

theorem reconSinc_eq_zero_of_lt_eps {y : ℝ} {N : ℕ} (h : y < eps N) :
    reconSinc y (N + 1) = 0 := by
  unfold reconSinc
  rw [reconSine_eq_zero_of_lt_eps h]
  simp

theorem theta_one_two : theta 1 2 = 5 / 6 := by
  norm_num [theta, delta, resid, step, eps, Finset.sum_range_succ]

theorem theta_one_five : theta 1 5 = 1 := by
  norm_num [theta, delta, resid, step, eps, Finset.sum_range_succ]

theorem reconSine_one_two : reconSine 1 2 = 1 / 2 := by
  unfold reconSine
  rw [theta_one_two, greedySine_five_six]

theorem reconSine_one_five : reconSine 1 5 = 0 := by
  unfold reconSine
  rw [theta_one_five]
  simpa using greedySine_int (1 : ℤ)

theorem step_zero (n : ℕ) : step 0 n = 0 := by
  unfold step
  split_ifs with h
  · linarith [eps_pos n]
  · ring

/-- At the target `1/2` the first step is selected exactly and the
residual is zero from then on. -/
theorem resid_half (N : ℕ) : resid (1 / 2) (N + 1) = 0 := by
  induction N with
  | zero => norm_num [resid, step, eps]
  | succ N ih =>
      change step (resid (1 / 2) (N + 1)) (N + 1) = 0
      rw [ih, step_zero]

theorem delta_half_zero (N : ℕ) : delta (1 / 2) (N + 1) = 0 := by
  unfold delta
  rw [resid_half N]
  split_ifs with hle
  · linarith [eps_pos (N + 1)]
  · rfl

/-- The Wallis point is exact at every finite stage: `theta_N(1/2) = 1/2`. -/
theorem theta_half (N : ℕ) : theta (1 / 2) (N + 1) = 1 / 2 := by
  induction N with
  | zero => norm_num [theta, delta, resid, step, eps, Finset.sum_range_succ]
  | succ N ih =>
      have h : theta (1 / 2) ((N + 1) + 1) =
          theta (1 / 2) (N + 1) + delta (1 / 2) (N + 1) := by
        unfold theta
        rw [Finset.sum_range_succ]
      rw [h, ih, delta_half_zero N, add_zero]

theorem reconSine_half (N : ℕ) : reconSine (1 / 2) (N + 1) = 1 := by
  unfold reconSine greedySine
  rw [theta_half N]
  rw [show Real.pi * (1 / 2 : ℝ) = Real.pi / 2 by ring, Real.sin_pi_div_two]

theorem reconSinc_half (N : ℕ) : reconSinc (1 / 2) (N + 1) = 2 / Real.pi := by
  unfold reconSinc
  rw [reconSine_half N]
  field_simp

end SinXOverX
