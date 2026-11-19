import Mathlib

/-!
# Harmonic Sine Transform — formal core

The HST programme of the archived corpus rests on two elementary layers:

* the greedy harmonic expansion of `θ ∈ [0, π]` in the harmonic angles
  `α n = π / (n + 2)`, and
* the Haar wavelets attached to the split nodes of the resulting binary tree.

This file formalises the finite, checkable part of those layers.  The
far-reaching analytic claims of the source (the Fredholm determinant
identity `det(I − ℒ_s) = ζ(s)/ζ(2s) · exp(P(s))`, the meromorphic
continuation of `Φ(θ,s)`, the Weil-type explicit formula, and the
Hilbert–Pólya/GRH route) are *not* formalised here and are recorded as
source claims or open items in the programme dossier.

The Haar coefficients below differ from the source's displayed formula
by a normalisation factor: the source's `1/√|child|` coefficients give
squared norm `2` and are not orthogonal to constants unless the two
children have equal length.  We use the correctly normalised, zero-mean
coefficients `√(b/(aL))` on the left child and `−√(a/(bL))` on the right
child, where `a`, `b` are the child lengths and `L = a + b`.  The two
lemmas `haar_normSq` and `haar_mean_zero` record exactly this repair.
-/

noncomputable section

open Filter Topology MeasureTheory
open scoped BigOperators

namespace HST

/-- The `n`-th harmonic angle `α_n = π / (n + 2)`. -/
def alpha (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- Accumulated angle before digit `n`: the sum of the selected `α_k`, `k < n`. -/
def accum : ℕ → ℝ → ℝ
  | 0, _ => 0
  | n + 1, θ => accum n θ + if alpha n ≤ θ - accum n θ then alpha n else 0

/-- The `n`-th greedy harmonic digit of `θ` (the source's `δ_n(θ)`). -/
def digit (n : ℕ) (θ : ℝ) : ℕ :=
  if alpha n ≤ θ - accum n θ then 1 else 0

/-- The harmonic angles are positive. -/
theorem alpha_pos (n : ℕ) : 0 < alpha n := by
  unfold alpha
  positivity

/-- The harmonic angles are strictly decreasing in `n`. -/
theorem alpha_strictAnti : StrictAnti alpha := by
  intro a b hab
  unfold alpha
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left Real.pi_pos (by positivity) h

/-- The accumulated angle never exceeds the target angle: partial sums of the
greedy expansion stay below `θ`. -/
theorem accum_le_self (n : ℕ) {θ : ℝ} (hθ : 0 ≤ θ) : accum n θ ≤ θ := by
  induction n with
  | zero => simpa [accum] using hθ
  | succ n ih =>
      rw [accum]
      split_ifs with h
      · linarith
      · simpa using ih

/-- Below the threshold `α_n` no earlier digit is selected, so the accumulated
angle is still zero. -/
theorem accum_eq_zero_of_lt (n : ℕ) {θ : ℝ} (h : θ < alpha n) : accum n θ = 0 := by
  induction n with
  | zero => simp [accum]
  | succ n ih =>
      have hn : θ < alpha n := lt_trans h (alpha_strictAnti (Nat.lt_succ_self n))
      rw [accum, ih hn]
      simp [not_le.mpr hn]

/-- **Threshold theorem.**  For the residual-subtraction convention of the
source's equation (1), `α_n` is the *least* angle whose `n`-th digit is `1`.
This is the precise finite statement behind the source's threshold angles. -/
theorem threshold_isLeast (n : ℕ) : IsLeast {θ : ℝ | digit n θ = 1} (alpha n) := by
  constructor
  · show digit n (alpha n) = 1
    unfold digit
    have h0 : accum n (alpha n) = 0 := by
      induction n with
      | zero => simp [accum]
      | succ n _ =>
          have hlt : alpha (n + 1) < alpha n := alpha_strictAnti (Nat.lt_succ_self n)
          have hz : accum n (alpha (n + 1)) = 0 := accum_eq_zero_of_lt n hlt
          rw [accum, hz]
          simp [not_le.mpr hlt]
    rw [h0]
    simp
  · intro θ hθ
    by_contra hle
    have hlt : θ < alpha n := not_le.mp hle
    have hz : digit n θ = 0 := by
      unfold digit
      rw [accum_eq_zero_of_lt n hlt]
      simp [not_le.mpr hlt]
    have hθ' : digit n θ = 1 := hθ
    rw [hz] at hθ'
    exact Nat.zero_ne_one hθ'

/-- The residual angle after `n` digits: `r_n(θ) = θ - A_n(θ)`. -/
def residual (n : ℕ) (θ : ℝ) : ℝ := θ - accum n θ

/-- The residual is non-negative for `θ ≥ 0`: the greedy partial sums never pass
the target. -/
theorem residual_nonneg (n : ℕ) {θ : ℝ} (hθ : 0 ≤ θ) : 0 ≤ residual n θ := by
  unfold residual
  linarith [accum_le_self n hθ]

/-- **Residual bound.**  For `0 ≤ θ ≤ π` the residual after `n` digits is at
most `π/(n+1)`.  This is the quantitative form of the expansion's convergence;
the source only asserts convergence with `O(1/n)` error. -/
theorem residual_le_pi_div (n : ℕ) {θ : ℝ} (_h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    residual n θ ≤ Real.pi / ((n : ℝ) + 1) := by
  induction n with
  | zero => simpa [residual, accum] using hπ
  | succ n ih =>
      have hα : alpha n = Real.pi / ((n : ℝ) + 2) := rfl
      have hidx : ((n + 1 : ℕ) : ℝ) + 1 = (n : ℝ) + 2 := by
        push_cast
        ring
      rw [hidx]
      rw [residual, accum]
      split_ifs with h
      · have hstep :
            θ - (accum n θ + alpha n) = (θ - accum n θ) - alpha n := by ring
        have ih' : θ - accum n θ ≤ Real.pi / ((n : ℝ) + 1) := by
          simpa [residual] using ih
        have hle :
            Real.pi / ((n : ℝ) + 1) - Real.pi / ((n : ℝ) + 2)
              ≤ Real.pi / ((n : ℝ) + 2) := by
          have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
          have h2 : (0 : ℝ) < (n : ℝ) + 2 := by positivity
          field_simp [h1.ne', h2.ne']
          nlinarith [Real.pi_pos, Nat.cast_nonneg (α := ℝ) n]
        rw [hstep, hα]
        linarith
      · have hlt : θ - accum n θ < alpha n := lt_of_not_ge h
        have : θ - accum n θ < Real.pi / ((n : ℝ) + 2) := by
          simpa [alpha] using hlt
        linarith

/-- The residual tends to zero, so the greedy harmonic expansion converges for
every `θ ∈ [0, π]`. -/
theorem tendsto_residual (θ : ℝ) (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    Tendsto (fun n : ℕ => residual n θ) atTop (𝓝 0) := by
  have hbound :
      Tendsto (fun n : ℕ => Real.pi / ((n : ℝ) + 1)) atTop (𝓝 0) := by
    simpa [div_eq_mul_inv, mul_comm] using
      (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).const_mul Real.pi
  exact squeeze_zero (fun n => residual_nonneg n h0)
    (fun n => residual_le_pi_div n h0 hπ) hbound

/-- The accumulated angle converges to the target: `A_n(θ) → θ`. -/
theorem tendsto_accum (θ : ℝ) (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    Tendsto (fun n : ℕ => accum n θ) atTop (𝓝 θ) := by
  have h : Tendsto (fun n : ℕ => θ - residual n θ) atTop (𝓝 (θ - 0)) :=
    (tendsto_const_nhds (x := θ)).sub (tendsto_residual θ h0 hπ)
  simpa [residual] using h

/-- The partial accumulated mass is the finite sum of the selected digit
contributions. -/
theorem accum_eq_sum_range (n : ℕ) (θ : ℝ) :
    accum n θ = ∑ k ∈ Finset.range n, (digit k θ : ℝ) * alpha k := by
  induction n with
  | zero => simp [accum]
  | succ n ih =>
      change accum n θ + (if alpha n ≤ θ - accum n θ then alpha n else 0) =
        ∑ k ∈ Finset.range (n + 1), (digit k θ : ℝ) * alpha k
      rw [Finset.sum_range_succ, ← ih]
      by_cases h : alpha n ≤ θ - accum n θ
      · have hd : digit n θ = 1 := by simp [digit, h]
        simp [h, hd]
      · have hd : digit n θ = 0 := by simp [digit, h]
        simp [h, hd]

/-- **Greedy expansion theorem.**  For every `θ ∈ [0, π]`,
`θ = Σ_n δ_n(θ) α_n`.  This closes the source's equation (2) for the
residual-subtraction rule. -/
theorem hasSum_digit_mul_alpha (θ : ℝ) (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    HasSum (fun n : ℕ => (digit n θ : ℝ) * alpha n) θ := by
  rw [hasSum_iff_tendsto_nat_of_nonneg (fun n => mul_nonneg (Nat.cast_nonneg _) (alpha_pos n).le) θ]
  have hfun :
      (fun n : ℕ => ∑ k ∈ Finset.range n, (digit k θ : ℝ) * alpha k)
        = fun n : ℕ => accum n θ := by
    funext n
    exact (accum_eq_sum_range n θ).symm
  rw [hfun]
  exact tendsto_accum θ h0 hπ

/-- The π-normalised form of the expansion, matching the source's equation (2)
literally: `θ/π = Σ_n δ_n(θ)/(n+2)`. -/
theorem hasSum_digit_div_pi (θ : ℝ) (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    HasSum (fun n : ℕ => (digit n θ : ℝ) / ((n : ℝ) + 2)) (θ / Real.pi) := by
  have h := (hasSum_digit_mul_alpha θ h0 hπ).div_const Real.pi
  convert h using 1
  · ext n
    simp only [alpha]
    field_simp

/-- **Separation.**  If two angles in `[0, π]` have the same greedy digits then
they are equal.  Equivalently, the digit map is injective. -/
theorem digits_eq_imp_eq {θ φ : ℝ} (h0θ : 0 ≤ θ) (hπθ : θ ≤ Real.pi)
    (h0φ : 0 ≤ φ) (hπφ : φ ≤ Real.pi)
    (h : ∀ n, digit n θ = digit n φ) : θ = φ := by
  have hacc : ∀ n, accum n θ = accum n φ := by
    intro n
    rw [accum_eq_sum_range, accum_eq_sum_range]
    refine Finset.sum_congr rfl ?_
    intro k _
    rw [h k]
  have htθ := tendsto_accum θ h0θ hπθ
  have htφ := tendsto_accum φ h0φ hπφ
  have hfun : (fun n : ℕ => accum n θ) = fun n : ℕ => accum n φ := by
    funext n
    exact hacc n
  rw [hfun] at htθ
  exact tendsto_nhds_unique htθ htφ

/-- **Cylinder diameter.**  Two angles whose first `n` digits agree differ by at
most `π/(n+1)`.  Together with separation this gives mesh-to-zero, the
hypothesis of the standard completeness argument for the Haar system. -/
theorem cylinder_diameter {θ φ : ℝ} (h0θ : 0 ≤ θ) (hπθ : θ ≤ Real.pi)
    (h0φ : 0 ≤ φ) (hπφ : φ ≤ Real.pi) {n : ℕ}
    (h : ∀ k, k < n → digit k θ = digit k φ) :
    |θ - φ| ≤ Real.pi / ((n : ℝ) + 1) := by
  have hacc : accum n θ = accum n φ := by
    rw [accum_eq_sum_range, accum_eq_sum_range]
    refine Finset.sum_congr rfl ?_
    intro k hk
    rw [h k (Finset.mem_range.mp hk)]
  have hrθ := residual_le_pi_div n h0θ hπθ
  have hrφ := residual_le_pi_div n h0φ hπφ
  have hθ0 := residual_nonneg n h0θ
  have hφ0 := residual_nonneg n h0φ
  have hdiff : θ - φ = residual n θ - residual n φ := by
    unfold residual
    rw [hacc]
    ring
  rw [hdiff, abs_sub_le_iff]
  constructor <;> linarith

/-- **Sine convergence with rate.**  The source's `O(1/n)` sine-error claim,
made quantitative: `|sin θ − sin A_n(θ)| ≤ π/(n+1)`. -/
theorem abs_sin_sub_sin_accum_le (n : ℕ) {θ : ℝ} (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    |Real.sin θ - Real.sin (accum n θ)| ≤ Real.pi / ((n : ℝ) + 1) := by
  calc
    |Real.sin θ - Real.sin (accum n θ)| ≤ |θ - accum n θ| :=
      Real.abs_sin_sub_sin_le θ (accum n θ)
    _ = |residual n θ| := by rw [residual]
    _ = residual n θ := abs_of_nonneg (residual_nonneg n h0)
    _ ≤ Real.pi / ((n : ℝ) + 1) := residual_le_pi_div n h0 hπ

/-- Left-child Haar coefficient `√(b / (aL))`. -/
def haarL (a b L : ℝ) : ℝ := Real.sqrt (b / (a * L))

/-- Right-child Haar coefficient `−√(a / (bL))`, up to the displayed sign. -/
def haarR (a b L : ℝ) : ℝ := Real.sqrt (a / (b * L))

/-- The Haar wavelet of a split node has squared norm `1` in the
`θ`-normalised (`L²[0,1]`) picture.  The coefficients multiply the child
lengths `a` and `b`, and `L = a + b`. -/
theorem haar_normSq {a b L : ℝ} (ha : 0 < a) (hb : 0 < b) (hL : L = a + b) :
    a * haarL a b L ^ 2 + b * haarR a b L ^ 2 = 1 := by
  have hLpos : 0 < L := by rw [hL]; positivity
  have ha0 : a ≠ 0 := ne_of_gt ha
  have hb0 : b ≠ 0 := ne_of_gt hb
  have hL0 : L ≠ 0 := ne_of_gt hLpos
  unfold haarL haarR
  rw [Real.sq_sqrt (by positivity), Real.sq_sqrt (by positivity)]
  field_simp [ha0, hb0, hL0]
  rw [hL]
  ring

/-- The Haar wavelet has zero mean over its node: the signed child masses
cancel.  This is the orthogonality to the constant function. -/
theorem haar_mean_zero {a b L : ℝ} (ha : 0 < a) (hb : 0 < b) (hL : L = a + b) :
    haarL a b L * a - haarR a b L * b = 0 := by
  have hLpos : 0 < L := by rw [hL]; positivity
  have hL0 : L ≠ 0 := ne_of_gt hLpos
  have hleft : haarL a b L * a = Real.sqrt (a * b / L) := by
    unfold haarL
    calc
      Real.sqrt (b / (a * L)) * a
          = Real.sqrt (b / (a * L)) * Real.sqrt (a ^ 2) := by
            rw [Real.sqrt_sq (le_of_lt ha)]
      _ = Real.sqrt ((b / (a * L)) * a ^ 2) := by
            rw [Real.sqrt_mul (by positivity)]
      _ = Real.sqrt (a * b / L) := by
            congr 1
            field_simp [ne_of_gt ha, hL0]
  have hright : haarR a b L * b = Real.sqrt (a * b / L) := by
    unfold haarR
    calc
      Real.sqrt (a / (b * L)) * b
          = Real.sqrt (a / (b * L)) * Real.sqrt (b ^ 2) := by
            rw [Real.sqrt_sq (le_of_lt hb)]
      _ = Real.sqrt ((a / (b * L)) * b ^ 2) := by
            rw [Real.sqrt_mul (by positivity)]
      _ = Real.sqrt (a * b / L) := by
            congr 1
            field_simp [ne_of_gt hb, hL0]
  rw [hleft, hright]
  ring

/-! ## Source-wavelet defect: the text and the tree disagree

The source (`harmonic-tree-haar.tex`, equation (5)) puts the coefficient
`1/√α_n` on the right child `I_{ε1}` and `−1/√(ℓ−α_n)` on the left child
`I_{ε0}`.  Its prose also says the right child has length `α_n`.  The actual
greedy split is at `A_n + α_n`, so on every cylinder the lower endpoint has
residual zero and it is the *left* child that has length `α_n`; the right child
has length `ℓ−α_n`.  The source's figure already draws the correct geometry,
contradicting its prose.

The next four lemmas record both readings, so the defect is not hidden by a
convention choice. -/

/-- The source's displayed coefficients read with the source's prose
convention (left length `a`, right length `b`). -/
def sourceHaarL (a _b : ℝ) : ℝ := -1 / Real.sqrt a

/-- Right coefficient of the source's displayed wavelet under its prose
convention. -/
def sourceHaarR (_a b : ℝ) : ℝ := 1 / Real.sqrt b

/-- Under the source's prose convention the displayed wavelet has squared norm
`2`, not `1`. -/
theorem source_haar_normSq {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    a * sourceHaarL a b ^ 2 + b * sourceHaarR a b ^ 2 = 2 := by
  unfold sourceHaarL sourceHaarR
  rw [div_pow, div_pow, Real.sq_sqrt ha.le, Real.sq_sqrt hb.le]
  field_simp [ha.ne', hb.ne']
  norm_num

/-- Under the source's prose convention the displayed wavelet has mean
`√b − √a`, which vanishes only when the children have equal length. -/
theorem source_haar_mean {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    a * sourceHaarL a b + b * sourceHaarR a b = Real.sqrt b - Real.sqrt a := by
  unfold sourceHaarL sourceHaarR
  field_simp [ha.ne', hb.ne']
  nlinarith [Real.sq_sqrt ha.le, Real.sq_sqrt hb.le, Real.sqrt_nonneg a, Real.sqrt_nonneg b]

/-- The source's displayed coefficients read on the *actual* tree, where the
left child has length `a = α_n` and the right child length `b = ℓ − α_n`. -/
def actualSourceHaarL (_a b : ℝ) : ℝ := -1 / Real.sqrt b

/-- Right coefficient of the source's displayed wavelet on the actual tree. -/
def actualSourceHaarR (a _b : ℝ) : ℝ := 1 / Real.sqrt a

/-- On the actual tree the displayed wavelet has squared norm `a/b + b/a`,
not the constant `2`. -/
theorem actual_source_normSq {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    a * actualSourceHaarL a b ^ 2 + b * actualSourceHaarR a b ^ 2 = a / b + b / a := by
  unfold actualSourceHaarL actualSourceHaarR
  rw [div_pow, div_pow, Real.sq_sqrt hb.le, Real.sq_sqrt ha.le]
  norm_num
  field_simp [ha.ne', hb.ne']

/-- On the actual tree the displayed wavelet has mean `−a/√b + b/√a`. -/
theorem actual_source_mean {a b : ℝ} (_ha : 0 < a) (_hb : 0 < b) :
    a * actualSourceHaarL a b + b * actualSourceHaarR a b
      = -a / Real.sqrt b + b / Real.sqrt a := by
  unfold actualSourceHaarL actualSourceHaarR
  ring

/-- The actual-tree squared norm is at least `2`, with equality only in the
equal-child case.  Thus the displayed wavelet is never normalised on the real
tree unless the split is centred. -/
theorem actual_source_normSq_ge_two {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    2 ≤ a * actualSourceHaarL a b ^ 2 + b * actualSourceHaarR a b ^ 2 := by
  rw [actual_source_normSq ha hb]
  have hdiff : a / b + b / a - 2 = (a - b) ^ 2 / (a * b) := by
    field_simp [ha.ne', hb.ne']
    ring
  have hnonneg : 0 ≤ (a - b) ^ 2 / (a * b) :=
    div_nonneg (sq_nonneg (a - b)) (mul_pos ha hb).le
  linarith

/-! ## Threshold table and digit monotonicity

The source's table after equation (4) lists `θ₃* = 5π/12` and claims the
digits are monotone step functions.  Both are refuted by explicit evaluation
of the source's own recursion. -/

/-- The source's listed third threshold is wrong: `δ₃(5π/12) = 0`, so
`5π/12` is not a threshold for digit 3. -/
theorem source_threshold_three_wrong : digit 3 (5 * Real.pi / 12) = 0 := by
  simp only [digit, accum, alpha]
  norm_num
  split_ifs <;> nlinarith [Real.pi_pos]

/-- The digits are not monotone in `θ`: `δ₁(2π/5) = 1` but
`δ₁(11π/20) = 0`, although `2π/5 < 11π/20`. -/
theorem digit_not_monotone_explicit :
    digit 1 (2 * Real.pi / 5) = 1 ∧ digit 1 (11 * Real.pi / 20) = 0 := by
  constructor
  · simp only [digit, accum, alpha]
    norm_num
    split_ifs <;> nlinarith [Real.pi_pos]
  · simp only [digit, accum, alpha]
    norm_num
    split_ifs <;> nlinarith [Real.pi_pos]

/-! ## The research guide's floor recursion is factorial, not harmonic

The guide's §3.1 defines `δₙ = ⌊(n+2) rₙ⌋`, `rₙ₊₁ = (n+2)rₙ − δₙ` and calls
the digits binary while also asserting `θ/π = Σ δₙ/(n+2)`.  The recursion is
not binary (at `t = 9/10` the second digit is `2`), and its exact expansion has
factorial denominators: `t = Σ δₙ/(n+2)! + r_N/(N+1)!`.  The harmonic series
assertion is therefore false, not merely unproved. -/

/-- The guide's floor digit `δₙ = ⌊(n+2) rₙ⌋`. -/
def floorDigit (n : ℕ) (r : ℚ) : ℤ := ⌊((n : ℚ) + 2) * r⌋

/-- The guide's floor recursion `rₙ₊₁ = (n+2) rₙ − δₙ`. -/
def floorRem : ℕ → ℚ → ℚ
  | 0, t => t
  | n + 1, t => ((n : ℚ) + 2) * floorRem n t - (floorDigit n (floorRem n t) : ℚ)

@[simp] lemma floorRem_succ (n : ℕ) (t : ℚ) :
    floorRem (n + 1) t = ((n : ℚ) + 2) * floorRem n t
      - (floorDigit n (floorRem n t) : ℚ) := rfl

/-- Partial sum of the guide's digits with the factorial denominators that the
recursion actually produces. -/
def floorFactorialPartial (n : ℕ) (t : ℚ) : ℚ :=
  ∑ k ∈ Finset.range n, (floorDigit k (floorRem k t) : ℚ) / (Nat.factorial (k + 2) : ℚ)

/-- Partial sum of the guide's digits with the harmonic denominators that the
guide asserts. -/
def floorHarmonicPartial (n : ℕ) (t : ℚ) : ℚ :=
  ∑ k ∈ Finset.range n, (floorDigit k (floorRem k t) : ℚ) / ((k : ℚ) + 2)

lemma floor_step_algebra (n : ℕ) (t : ℚ) :
    floorFactorialPartial n t + floorRem n t / (Nat.factorial (n + 1) : ℚ)
      = floorFactorialPartial (n + 1) t
          + floorRem (n + 1) t / (Nat.factorial (n + 2) : ℚ) := by
  unfold floorFactorialPartial
  rw [Finset.sum_range_succ, floorRem_succ]
  have hfac : (Nat.factorial (n + 1) : ℚ) ≠ 0 := by
    exact_mod_cast Nat.factorial_ne_zero (n + 1)
  have hfac2 : (Nat.factorial (n + 2) : ℚ)
      = ((n : ℚ) + 2) * (Nat.factorial (n + 1) : ℚ) := by
    rw [show n + 2 = n + 1 + 1 by ring, Nat.factorial_succ]
    push_cast
    ring
  rw [hfac2]
  field_simp [hfac]
  ring

/-- **Factorial expansion identity.**  The guide's recursion reconstructs `t`
with factorial denominators, not harmonic ones:
`t = Σ_{k<n} δ_k/(k+2)! + r_n/(n+1)!`. -/
theorem floor_factorial_identity (n : ℕ) (t : ℚ) :
    t = floorFactorialPartial n t + floorRem n t / (Nat.factorial (n + 1) : ℚ) := by
  induction n with
  | zero => simp [floorFactorialPartial, floorRem]
  | succ n ih =>
      calc
        t = floorFactorialPartial n t + floorRem n t / (Nat.factorial (n + 1) : ℚ) := ih
        _ = floorFactorialPartial (n + 1) t
              + floorRem (n + 1) t / (Nat.factorial (n + 1 + 1) : ℚ) :=
            floor_step_algebra n t

/-- The guide's recursion is not binary: at `t = 9/10` its second digit is `2`. -/
theorem floor_digit_not_binary : floorDigit 1 (floorRem 1 (9 / 10)) = 2 := by
  norm_num [floorDigit, floorRem]

/-- The guide's harmonic-denominator partial sum already exceeds the target at
`t = 9/10`: `Σ_{k<4} δ_k/(k+2) = 121/60 > 9/10`.  Since the terms are
non-negative, the harmonic expansion cannot converge to `t`. -/
theorem floor_harmonic_partial_gt_target :
    (9 / 10 : ℚ) < floorHarmonicPartial 4 (9 / 10) := by
  rw [show floorHarmonicPartial 4 (9 / 10) = 121 / 60 by
    norm_num [floorHarmonicPartial, Finset.sum_range_succ, floorDigit, floorRem]]
  norm_num

/-- The factorial-denominator partial sum does reconstruct the target:
`Σ_{k<5} δ_k/(k+2)! = 9/10`. -/
theorem floor_factorial_partial_eq_target :
    floorFactorialPartial 5 (9 / 10) = 9 / 10 := by
  norm_num [floorFactorialPartial, Finset.sum_range_succ, floorDigit, floorRem]

/-! ## F1: the finite cylinder partition

The finite combinatorics behind O1 is developed over `ℚ` in the normalised
coordinate `t = θ/π`.  A `Cyl` is a half-open interval `[lo, hi)` inside
`[0, 1]`.  At depth `n` the split point is `lo + 1/(n+2)`: the residual at the
lower endpoint is zero, so the **left** child has length `1/(n+2)` and the right
child has the remainder.  This is the source's figure, not its prose (R5).
-/

/-- A half-open cylinder `[lo, hi)` inside the unit interval. -/
structure Cyl where
  lo : ℚ
  hi : ℚ
  hlo : 0 ≤ lo
  hhi : hi ≤ 1
  hlt : lo < hi

namespace Cyl

/-- Length of a cylinder. -/
def length (c : Cyl) : ℚ := c.hi - c.lo

end Cyl

/-- The split point at depth `n`, in normalised coordinates. -/
def cut (n : ℕ) (c : Cyl) : ℚ := c.lo + 1 / ((n : ℚ) + 2)

lemma cut_pos (n : ℕ) (c : Cyl) : c.lo < cut n c := by
  unfold cut
  have : (0 : ℚ) < 1 / ((n : ℚ) + 2) := by positivity
  linarith

/-- Refine one cylinder at depth `n`.  If the cut reaches the right endpoint the
cylinder is unsplit and passes through unchanged; otherwise it splits into the
left child of length `1/(n+2)` and the right child. -/
def splitAt (n : ℕ) (c : Cyl) : List Cyl :=
  if h : c.hi ≤ cut n c then [c]
  else
    let hlt : cut n c < c.hi := lt_of_not_ge h
    [⟨c.lo, cut n c, c.hlo, by linarith [c.hhi, hlt], cut_pos n c⟩,
     ⟨cut n c, c.hi, by linarith [c.hlo, cut_pos n c], c.hhi, hlt⟩]

/-- `TilesFrom a b xs` says the list `xs` tiles `[a, b)` in order, with no gaps
or overlaps. -/
def TilesFrom (a b : ℚ) : List Cyl → Prop
  | [] => a = b
  | c :: cs => c.lo = a ∧ TilesFrom c.hi b cs

lemma TilesFrom.append :
    ∀ {xs ys : List Cyl} {a m b : ℚ}, TilesFrom a m xs →
      TilesFrom m b ys → TilesFrom a b (xs ++ ys)
  | [], ys, a, m, b, h1, h2 => by
      simp [TilesFrom] at h1
      subst h1
      simpa using h2
  | c :: cs, ys, a, m, b, h1, h2 => by
      simp [TilesFrom] at h1 ⊢
      obtain ⟨rfl, h1'⟩ := h1
      exact ⟨rfl, TilesFrom.append h1' h2⟩

lemma splitAt_tiles (n : ℕ) (c : Cyl) : TilesFrom c.lo c.hi (splitAt n c) := by
  unfold splitAt
  split_ifs with h
  · simp [TilesFrom]
  · simp [TilesFrom, cut]

lemma tiles_flatMap {f : Cyl → List Cyl} :
    ∀ {xs : List Cyl} {a b : ℚ}, TilesFrom a b xs →
      (∀ c ∈ xs, TilesFrom c.lo c.hi (f c)) →
      TilesFrom a b (xs.flatMap f)
  | [], a, b, h1, _ => by simpa [TilesFrom] using h1
  | c :: cs, a, b, h1, h2 => by
      simp [TilesFrom] at h1
      obtain ⟨rfl, h1'⟩ := h1
      simp only [List.flatMap_cons]
      have hc : TilesFrom c.lo c.hi (f c) := h2 c (by simp)
      have hcs : ∀ d ∈ cs, TilesFrom d.lo d.hi (f d) := by
        intro d hd
        exact h2 d (by simp [hd])
      exact TilesFrom.append hc (tiles_flatMap h1' hcs)

/-- The root rational cylinder. -/
def rootCyl : Cyl := ⟨0, 1, by norm_num, by norm_num, by norm_num⟩

/-- The depth-`n` cylinder partition, starting from `[0,1)`. -/
def partition : ℕ → List Cyl
  | 0 => [rootCyl]
  | n + 1 => (partition n).flatMap (splitAt n)

/-- **F1 tiling.**  The depth-`n` partition tiles `[0,1)` in order. -/
theorem partition_tiles (n : ℕ) : TilesFrom 0 1 (partition n) := by
  induction n with
  | zero => simp [partition, rootCyl, TilesFrom]
  | succ n ih =>
      simp only [partition]
      exact tiles_flatMap ih (fun c _ => splitAt_tiles n c)

lemma splitAt_length_le {c : Cyl} {n : ℕ}
    (hc : c.length ≤ 1 / ((n : ℚ) + 1)) :
    ∀ d ∈ splitAt n c, d.length ≤ 1 / ((n : ℚ) + 2) := by
  intro d hd
  unfold splitAt at hd
  split_ifs at hd with h
  · simp only [List.mem_singleton] at hd
    subst hd
    dsimp [Cyl.length] at hc ⊢
    unfold cut at h
    linarith
  · simp only [List.mem_cons, List.not_mem_nil, or_false] at hd
    rcases hd with rfl | rfl
    · dsimp [Cyl.length]
      unfold cut
      field_simp
      norm_num
    · dsimp [Cyl.length] at hc ⊢
      unfold cut
      have hle : 1 / ((n : ℚ) + 1) - 1 / ((n : ℚ) + 2)
          ≤ 1 / ((n : ℚ) + 2) := by
        field_simp
        nlinarith
      linarith

/-- **F1 left split length.**  When a cylinder splits at depth `n`, the left
child has length exactly `1/(n+2)`.  This is the finite content of the source's
child-length claim, with the correct side. -/
lemma splitAt_left_length {c : Cyl} {n : ℕ} (h : ¬ c.hi ≤ cut n c) :
    ∃ l : Cyl, l ∈ splitAt n c ∧ l.lo = c.lo
      ∧ l.length = 1 / ((n : ℚ) + 2) := by
  let l : Cyl := ⟨c.lo, cut n c, c.hlo,
    by linarith [c.hhi, lt_of_not_ge h], cut_pos n c⟩
  refine ⟨l, ?_, rfl, ?_⟩
  · simp [l, splitAt, h]
  · dsimp [l, Cyl.length]
    unfold cut
    ring

/-- **F1 right split length.**  When a cylinder splits at depth `n`, the right
child starts at the cut and has length `c.length − 1/(n+2)`. -/
lemma splitAt_right_length {c : Cyl} {n : ℕ} (h : ¬ c.hi ≤ cut n c) :
    ∃ r : Cyl, r ∈ splitAt n c ∧ r.lo = cut n c
      ∧ r.length = c.length - 1 / ((n : ℚ) + 2) := by
  let r : Cyl := ⟨cut n c, c.hi, by linarith [c.hlo, cut_pos n c],
    c.hhi, lt_of_not_ge h⟩
  refine ⟨r, ?_, rfl, ?_⟩
  · simp [r, splitAt, h]
  · dsimp [r, Cyl.length]
    unfold cut
    ring

/-- If a list tiles `[a,b)`, every point of `[a,b)` lies in one of its cylinders. -/
lemma TilesFrom.exists_mem :
    ∀ {xs : List Cyl} {a b x : ℚ}, TilesFrom a b xs → a ≤ x → x < b →
      ∃ c ∈ xs, c.lo ≤ x ∧ x < c.hi
  | [], a, b, x, h, ha, hb => by
      simp [TilesFrom] at h
      subst h
      linarith
  | c :: cs, a, b, x, h, ha, hb => by
      simp [TilesFrom] at h
      obtain ⟨rfl, hcs⟩ := h
      by_cases hx : x < c.hi
      · exact ⟨c, by simp, ha, hx⟩
      · have hx' : c.hi ≤ x := le_of_not_gt hx
        obtain ⟨d, hd, hdlo, hdhi⟩ := TilesFrom.exists_mem hcs hx' hb
        exact ⟨d, by simp [hd], hdlo, hdhi⟩

/-- **F1 coverage.**  Every `x ∈ [0,1)` lies in a depth-`n` cylinder. -/
theorem partition_cover (n : ℕ) {x : ℚ} (h0 : 0 ≤ x) (h1 : x < 1) :
    ∃ c ∈ partition n, c.lo ≤ x ∧ x < c.hi :=
  (partition_tiles n).exists_mem h0 h1

/-- In a tiling, every later cylinder starts at or after the start of the list. -/
lemma TilesFrom.start_le :
    ∀ {xs : List Cyl} {a b : ℚ}, TilesFrom a b xs → ∀ d ∈ xs, a ≤ d.lo
  | [], a, b, h, d, hd => by simp at hd
  | h0 :: cs, a, b, h, d, hd => by
      simp [TilesFrom] at h
      obtain ⟨rfl, hcs⟩ := h
      rcases List.mem_cons.mp hd with rfl | hd
      · exact le_rfl
      · exact le_trans h0.hlt.le (TilesFrom.start_le hcs d hd)

/-- A tiling determines the cylinder containing a point uniquely. -/
lemma TilesFrom.unique :
    ∀ {xs : List Cyl} {a b x : ℚ}, TilesFrom a b xs →
      ∀ c ∈ xs, ∀ d ∈ xs,
        c.lo ≤ x → x < c.hi → d.lo ≤ x → x < d.hi → c = d
  | [], a, b, x, h, c, hc, d, hd, _, _, _, _ => by simp at hc
  | h0 :: cs, a, b, x, h, c1, hc1, c2, hc2, h1lo, h1hi, h2lo, h2hi => by
      simp [TilesFrom] at h
      obtain ⟨rfl, hcs⟩ := h
      rcases List.mem_cons.mp hc1 with heq1 | hc1'
      · rw [heq1] at h1lo h1hi ⊢
        rcases List.mem_cons.mp hc2 with heq2 | hc2'
        · rw [heq2]
        · have hge : h0.hi ≤ c2.lo := TilesFrom.start_le hcs c2 hc2'
          linarith
      · rcases List.mem_cons.mp hc2 with heq2 | hc2'
        · rw [heq2] at h2lo h2hi ⊢
          have hge : h0.hi ≤ c1.lo := TilesFrom.start_le hcs c1 hc1'
          linarith
        · exact TilesFrom.unique hcs c1 hc1' c2 hc2' h1lo h1hi h2lo h2hi

/-- **F1 uniqueness.**  The depth-`n` cylinder containing `x` is unique. -/
theorem partition_unique (n : ℕ) {x : ℚ} :
    ∀ c ∈ partition n, ∀ d ∈ partition n,
      c.lo ≤ x → x < c.hi → d.lo ≤ x → x < d.hi → c = d := by
  intro c hc d hd hclo hchi hdlo hdhi
  exact (partition_tiles n).unique c hc d hd hclo hchi hdlo hdhi

/-- **F1 mesh bound.**  Every depth-`n` cylinder has length at most `1/(n+1)`. -/
theorem partition_mesh (n : ℕ) :
    ∀ c ∈ partition n, c.length ≤ 1 / ((n : ℚ) + 1) := by
  induction n with
  | zero =>
      intro c hc
      simp [partition, rootCyl] at hc
      subst hc
      dsimp [Cyl.length, rootCyl]
      norm_num
  | succ n ih =>
      intro c hc
      simp only [partition, List.mem_flatMap] at hc
      obtain ⟨p, hp, hcp⟩ := hc
      convert splitAt_length_le (ih p hp) c hcp using 2
      push_cast
      ring

/-! ## O1: the real lift of the cylinder partition

The rational partition is lifted to `ℝ` so that continuous functions on
`[0,1]` can be approximated by cylinder step functions.  The real intervals are
the casts of the rational ones, so tiling, coverage, uniqueness and the mesh
bound transfer directly. -/

/-- A half-open real cylinder `[lo, hi)` inside `[0,1]`. -/
structure CylR where
  lo : ℝ
  hi : ℝ
  hlo : 0 ≤ lo
  hhi : hi ≤ 1
  hlt : lo < hi
  deriving DecidableEq

namespace CylR

/-- Length of a real cylinder. -/
def length (c : CylR) : ℝ := c.hi - c.lo

end CylR

/-- Cast a rational cylinder to a real one. -/
def Cyl.toReal (c : Cyl) : CylR :=
  ⟨c.lo, c.hi, by exact_mod_cast c.hlo, by exact_mod_cast c.hhi, by exact_mod_cast c.hlt⟩

/-- Real analogue of `TilesFrom`. -/
def TilesFromR (a b : ℝ) : List CylR → Prop
  | [] => a = b
  | c :: cs => c.lo = a ∧ TilesFromR c.hi b cs

lemma TilesFrom.cast {xs : List Cyl} {a b : ℚ} (h : TilesFrom a b xs) :
    TilesFromR (a : ℝ) (b : ℝ) (xs.map Cyl.toReal) := by
  induction xs generalizing a with
  | nil =>
      simp [TilesFrom] at h
      subst h
      simp [TilesFromR]
  | cons c cs ih =>
      simp [TilesFrom] at h
      obtain ⟨rfl, hcs⟩ := h
      simp [TilesFromR, Cyl.toReal, ih hcs]

/-- The real depth-`n` partition. -/
def partitionR (n : ℕ) : List CylR := (partition n).map Cyl.toReal

/-- **O1 real tiling.**  The real partition tiles `[0,1)`. -/
theorem partitionR_tiles (n : ℕ) : TilesFromR 0 1 (partitionR n) := by
  unfold partitionR
  simpa using (partition_tiles n).cast

lemma TilesFromR.exists_mem :
    ∀ {xs : List CylR} {a b x : ℝ}, TilesFromR a b xs → a ≤ x → x < b →
      ∃ c ∈ xs, c.lo ≤ x ∧ x < c.hi
  | [], a, b, x, h, ha, hb => by
      simp [TilesFromR] at h
      subst h
      linarith
  | c :: cs, a, b, x, h, ha, hb => by
      simp [TilesFromR] at h
      obtain ⟨rfl, hcs⟩ := h
      by_cases hx : x < c.hi
      · exact ⟨c, by simp, ha, hx⟩
      · have hx' : c.hi ≤ x := le_of_not_gt hx
        obtain ⟨d, hd, hdlo, hdhi⟩ := TilesFromR.exists_mem hcs hx' hb
        exact ⟨d, by simp [hd], hdlo, hdhi⟩

lemma TilesFromR.start_le :
    ∀ {xs : List CylR} {a b : ℝ}, TilesFromR a b xs → ∀ d ∈ xs, a ≤ d.lo
  | [], a, b, h, d, hd => by simp at hd
  | h0 :: cs, a, b, h, d, hd => by
      simp [TilesFromR] at h
      obtain ⟨rfl, hcs⟩ := h
      rcases List.mem_cons.mp hd with rfl | hd
      · exact le_rfl
      · exact le_trans h0.hlt.le (TilesFromR.start_le hcs d hd)

lemma TilesFromR.unique :
    ∀ {xs : List CylR} {a b x : ℝ}, TilesFromR a b xs →
      ∀ c ∈ xs, ∀ d ∈ xs,
        c.lo ≤ x → x < c.hi → d.lo ≤ x → x < d.hi → c = d
  | [], a, b, x, h, c, hc, d, hd, _, _, _, _ => by simp at hc
  | h0 :: cs, a, b, x, h, c1, hc1, c2, hc2, h1lo, h1hi, h2lo, h2hi => by
      simp [TilesFromR] at h
      obtain ⟨rfl, hcs⟩ := h
      rcases List.mem_cons.mp hc1 with heq1 | hc1'
      · rw [heq1] at h1lo h1hi ⊢
        rcases List.mem_cons.mp hc2 with heq2 | hc2'
        · rw [heq2]
        · have hge : h0.hi ≤ c2.lo := TilesFromR.start_le hcs c2 hc2'
          linarith
      · rcases List.mem_cons.mp hc2 with heq2 | hc2'
        · rw [heq2] at h2lo h2hi ⊢
          have hge : h0.hi ≤ c1.lo := TilesFromR.start_le hcs c1 hc1'
          linarith
        · exact TilesFromR.unique hcs c1 hc1' c2 hc2' h1lo h1hi h2lo h2hi

/-- **O1 real coverage.**  Every `x ∈ [0,1)` lies in a real depth-`n` cylinder. -/
theorem partitionR_cover (n : ℕ) {x : ℝ} (h0 : 0 ≤ x) (h1 : x < 1) :
    ∃ c ∈ partitionR n, c.lo ≤ x ∧ x < c.hi :=
  (partitionR_tiles n).exists_mem h0 h1

/-- **O1 real uniqueness.**  The real depth-`n` cylinder containing `x` is unique. -/
theorem partitionR_unique (n : ℕ) {x : ℝ} :
    ∀ c ∈ partitionR n, ∀ d ∈ partitionR n,
      c.lo ≤ x → x < c.hi → d.lo ≤ x → x < d.hi → c = d := by
  intro c hc d hd hclo hchi hdlo hdhi
  exact (partitionR_tiles n).unique c hc d hd hclo hchi hdlo hdhi

/-- **O1 real mesh.**  Every real depth-`n` cylinder has length at most
`1/(n+1)`. -/
theorem partitionR_mesh (n : ℕ) :
    ∀ c ∈ partitionR n, c.length ≤ 1 / ((n : ℝ) + 1) := by
  intro c hc
  simp only [partitionR, List.mem_map] at hc
  obtain ⟨d, hd, rfl⟩ := hc
  have hmesh := partition_mesh n d hd
  dsimp [CylR.length, Cyl.toReal]
  have hcast : (d.length : ℝ) ≤ ((1 / ((n : ℚ) + 1) : ℚ) : ℝ) := by
    exact_mod_cast hmesh
  simpa [Cyl.length, Nat.cast_add, Nat.cast_one] using hcast

/-- **O1 uniform oscillation.**  For every continuous `f` on `[0,1]` and every
`ε > 0`, some depth-`n` partition has oscillation at most `ε` on every
cylinder.  This is the analytic heart of the density step. -/
theorem exists_partition_oscillation_lt {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ n : ℕ, ∀ c ∈ partitionR n, ∀ x ∈ Set.Icc c.lo c.hi,
      ∀ y ∈ Set.Icc c.lo c.hi, |f x - f y| ≤ ε := by
  have huc : UniformContinuousOn f (Set.Icc (0 : ℝ) 1) :=
    isCompact_Icc.uniformContinuousOn_of_continuous hf
  rw [Metric.uniformContinuousOn_iff] at huc
  obtain ⟨δ, hδ, hδprop⟩ := huc ε hε
  obtain ⟨n, hn⟩ := exists_nat_one_div_lt hδ
  refine ⟨n, ?_⟩
  intro c hc x hx y hy
  have hcmesh := partitionR_mesh n c hc
  have hx01 : x ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨le_trans c.hlo hx.1, le_trans hx.2 c.hhi⟩
  have hy01 : y ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨le_trans c.hlo hy.1, le_trans hy.2 c.hhi⟩
  have hxy : |x - y| ≤ c.length := by
    dsimp [CylR.length]
    rw [abs_sub_le_iff]
    constructor <;> linarith [hx.1, hx.2, hy.1, hy.2]
  have hdist : dist x y < δ := by
    rw [Real.dist_eq]
    exact lt_of_le_of_lt (le_trans hxy hcmesh) hn
  have hlt := hδprop x hx01 y hy01 hdist
  rw [Real.dist_eq] at hlt
  exact le_of_lt hlt

/-- A chosen representative (the left endpoint) of the depth-`n` cylinder
containing `x`; set to `0` outside `[0,1)`. -/
noncomputable def cylinderRep (n : ℕ) (x : ℝ) : ℝ :=
  if hx : 0 ≤ x ∧ x < 1 then
    (Classical.choose (partitionR_cover n hx.1 hx.2)).lo
  else 0

lemma cylinderRep_spec {n : ℕ} {x : ℝ} (hx : 0 ≤ x ∧ x < 1) :
    ∃ c ∈ partitionR n, cylinderRep n x = c.lo ∧ c.lo ≤ x ∧ x < c.hi := by
  have h := Classical.choose_spec (partitionR_cover n hx.1 hx.2)
  refine ⟨Classical.choose (partitionR_cover n hx.1 hx.2), h.1, ?_, h.2.1, h.2.2⟩
  simp [cylinderRep, hx]

lemma cylinderRep_eq_of_mem {n : ℕ} {x : ℝ} (hx : 0 ≤ x ∧ x < 1)
    {c : CylR} (hc : c ∈ partitionR n) (hlo : c.lo ≤ x) (hhi : x < c.hi) :
    cylinderRep n x = c.lo := by
  obtain ⟨d, hd, hr, hdlo, hdhi⟩ := cylinderRep_spec hx
  have hdc : d = c := partitionR_unique n d hd c hc hdlo hdhi hlo hhi
  rw [hdc] at hr
  exact hr

/-- The cylinder-step function of `f` at depth `n`: `f` evaluated at the
representative of the cylinder containing `x`. -/
noncomputable def cylinderStep (n : ℕ) (f : ℝ → ℝ) (x : ℝ) : ℝ :=
  f (cylinderRep n x)

lemma cylinderStep_eq_of_mem {n : ℕ} {f : ℝ → ℝ} {x y : ℝ}
    (hx : 0 ≤ x ∧ x < 1) (hy : 0 ≤ y ∧ y < 1)
    {c : CylR} (hc : c ∈ partitionR n) (hxlo : c.lo ≤ x) (hxhi : x < c.hi)
    (hylo : c.lo ≤ y) (hyhi : y < c.hi) :
    cylinderStep n f x = cylinderStep n f y := by
  unfold cylinderStep
  rw [cylinderRep_eq_of_mem hx hc hxlo hxhi,
      cylinderRep_eq_of_mem hy hc hylo hyhi]

/-- **O1 step approximation.**  Every continuous `f` on `[0,1]` is uniformly
approximated on `[0,1)` by a function constant on depth-`n` cylinders. -/
theorem exists_cylinder_step_approx {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ n : ℕ, ∀ x : ℝ, ∀ _hx : 0 ≤ x ∧ x < 1,
      |f x - cylinderStep n f x| ≤ ε := by
  obtain ⟨n, hn⟩ := exists_partition_oscillation_lt hf hε
  refine ⟨n, ?_⟩
  intro x hx
  obtain ⟨c, hc, hr, hclo, hchi⟩ := cylinderRep_spec hx
  have hxI : x ∈ Set.Icc c.lo c.hi := ⟨hclo, le_of_lt hchi⟩
  have hrepI : cylinderRep n x ∈ Set.Icc c.lo c.hi := by
    rw [hr]
    exact ⟨le_rfl, le_of_lt c.hlt⟩
  have h := hn c hc x hxI (cylinderRep n x) hrepI
  unfold cylinderStep
  rw [hr] at h ⊢
  exact h

/-- A function is a cylinder step function if it is constant on the cylinders of
some depth-`n` partition. -/
def IsCylinderStep (g : ℝ → ℝ) : Prop :=
  ∃ n : ℕ, ∀ c ∈ partitionR n, ∀ x ∈ Set.Ico c.lo c.hi,
    ∀ y ∈ Set.Ico c.lo c.hi, g x = g y

lemma cylinderStep_isCylinderStep (n : ℕ) (f : ℝ → ℝ) :
    IsCylinderStep (cylinderStep n f) := by
  refine ⟨n, ?_⟩
  intro c hc x hx y hy
  exact cylinderStep_eq_of_mem
    ⟨le_trans c.hlo hx.1, lt_of_lt_of_le hx.2 c.hhi⟩
    ⟨le_trans c.hlo hy.1, lt_of_lt_of_le hy.2 c.hhi⟩
    hc hx.1 hx.2 hy.1 hy.2

/-- **O1 density.**  Continuous functions on `[0,1]` are uniformly approximated
by cylinder step functions. -/
theorem cylinder_step_dense {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ g : ℝ → ℝ, IsCylinderStep g ∧
      ∀ x : ℝ, ∀ _hx : 0 ≤ x ∧ x < 1, |f x - g x| ≤ ε := by
  obtain ⟨n, hn⟩ := exists_cylinder_step_approx hf hε
  exact ⟨cylinderStep n f, cylinderStep_isCylinderStep n f, hn⟩

/-- The parents at depth `n` that actually split. -/
def splitsAt (n : ℕ) : List Cyl :=
  (partition n).filter (fun c => ¬ c.hi ≤ cut n c)

/-- Number of splits at depth `n`. -/
def splitCount (n : ℕ) : ℕ := (splitsAt n).length

lemma splitAt_length (n : ℕ) (c : Cyl) :
    (splitAt n c).length = if c.hi ≤ cut n c then 1 else 2 := by
  unfold splitAt
  split_ifs <;> simp

lemma length_flatMap_splitAt (n : ℕ) (l : List Cyl) :
    (l.flatMap (splitAt n)).length
      = l.length + (l.filter (fun c => ¬ c.hi ≤ cut n c)).length := by
  induction l with
  | nil => simp
  | cons c cs ih =>
      rw [List.flatMap_cons, List.length_append, splitAt_length, ih]
      by_cases h : c.hi ≤ cut n c
      · have hlt : ¬ cut n c < c.hi := not_lt_of_ge h
        simp [h, hlt]
        omega
      · have hlt : cut n c < c.hi := lt_of_not_ge h
        simp [h, hlt]
        omega

/-- **O1 dimension count, step.**  Refining from depth `n` to `n+1` adds one
cylinder for each split parent. -/
theorem partition_length_succ (n : ℕ) :
    (partition (n + 1)).length = (partition n).length + splitCount n := by
  rw [show partition (n + 1) = (partition n).flatMap (splitAt n) from rfl]
  unfold splitCount splitsAt
  rw [length_flatMap_splitAt]

/-- **O1 dimension count.**  The depth-`n` partition has `1 +` the total number
of splits above it.  This is the combinatorial side of the constant-plus-Haar
dimension count. -/
theorem partition_length (n : ℕ) :
    (partition n).length = 1 + ∑ k ∈ Finset.range n, splitCount k := by
  induction n with
  | zero => simp [partition]
  | succ n ih =>
      rw [partition_length_succ, ih, Finset.sum_range_succ]
      ring

/-! ## O1: local Haar algebra

On a split parent `p` with left child `l` and right child `r`, the parent
indicator is the sum of the child indicators, and each child indicator is a
linear combination of the parent indicator and the Haar difference
`(1/|l|) 1_l − (1/|r|) 1_r`.  This is the local step of the
constant-plus-Haar span induction. -/

/-- The underlying set of a real cylinder. -/
def cylSet (c : CylR) : Set ℝ := Set.Ico c.lo c.hi

/-- The indicator function of a real cylinder. -/
def cylInd (c : CylR) : ℝ → ℝ := (cylSet c).indicator (fun _ => 1)

/-- The unnormalised Haar difference on a split with children `l`, `r`. -/
def haarDiff (l r : CylR) : ℝ → ℝ :=
  (1 / l.length) • cylInd l - (1 / r.length) • cylInd r

/-- **Local partition identity.**  A parent indicator is the sum of its two child
indicators. -/
lemma cylInd_parent_eq_add {p l r : CylR} (hlo : l.lo = p.lo)
    (hmid : l.hi = r.lo) (hhi : r.hi = p.hi) :
    cylInd p = cylInd l + cylInd r := by
  ext x
  simp only [cylInd, cylSet, Set.indicator_apply, Pi.add_apply]
  by_cases hx : x < r.lo
  · have hxl : x < l.hi := by rw [hmid]; exact hx
    have hxrhi : x < r.hi := hx.trans r.hlt
    have hxrlo : ¬ r.lo ≤ x := not_le.mpr hx
    by_cases hxlo : l.lo ≤ x
    · have hxplo : p.lo ≤ x := by rwa [← hlo]
      have hxphi : x < p.hi := by rwa [← hhi]
      simp [hxlo, hxl, hxrhi, hxrlo, hxplo, hxphi]
    · have hxplo : ¬ p.lo ≤ x := by rwa [← hlo]
      simp [hxlo, hxl, hxrhi, hxrlo, hxplo]
  · have hxrlo : r.lo ≤ x := le_of_not_gt hx
    by_cases hxrh : x < r.hi
    · have hxphi : x < p.hi := by rwa [← hhi]
      have hxplo : p.lo ≤ x := by
        rw [← hlo]
        exact le_trans l.hlt.le (by rwa [hmid])
      have hxlhi : ¬ x < l.hi := by rw [hmid]; exact hx
      simp [hxrlo, hxrh, hxphi, hxplo, hxlhi]
    · have hxphi : ¬ x < p.hi := by rwa [← hhi]
      have hxlhi : ¬ x < l.hi := by rw [hmid]; exact hx
      simp [hxrlo, hxrh, hxphi, hxlhi]

/-- **Local Haar identity, left child.**  The left-child indicator is a linear
combination of the parent indicator and the Haar difference. -/
theorem cylInd_left_eq_smul {p l r : CylR} (hlo : l.lo = p.lo)
    (hmid : l.hi = r.lo) (hhi : r.hi = p.hi) :
    cylInd l = (l.length / (l.length + r.length)) • cylInd p
      + ((l.length * r.length) / (l.length + r.length)) • haarDiff l r := by
  have hp : cylInd p = cylInd l + cylInd r := cylInd_parent_eq_add hlo hmid hhi
  have ha : 0 < l.length := by dsimp [CylR.length]; linarith [l.hlt]
  have hb : 0 < r.length := by dsimp [CylR.length]; linarith [r.hlt]
  calc
    cylInd l = (l.length / (l.length + r.length)) • (cylInd l + cylInd r)
        + ((l.length * r.length) / (l.length + r.length)) •
            ((1 / l.length) • cylInd l - (1 / r.length) • cylInd r) := by
      ext x
      simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
      field_simp [ha.ne', hb.ne', (add_pos ha hb).ne']
      ring
    _ = (l.length / (l.length + r.length)) • cylInd p
        + ((l.length * r.length) / (l.length + r.length)) • haarDiff l r := by
      rw [← hp]
      rfl

/-- **Local Haar identity, right child.**  The right-child indicator is the
complementary linear combination. -/
theorem cylInd_right_eq_smul {p l r : CylR} (hlo : l.lo = p.lo)
    (hmid : l.hi = r.lo) (hhi : r.hi = p.hi) :
    cylInd r = (r.length / (l.length + r.length)) • cylInd p
      - ((l.length * r.length) / (l.length + r.length)) • haarDiff l r := by
  have hp : cylInd p = cylInd l + cylInd r := cylInd_parent_eq_add hlo hmid hhi
  have ha : 0 < l.length := by dsimp [CylR.length]; linarith [l.hlt]
  have hb : 0 < r.length := by dsimp [CylR.length]; linarith [r.hlt]
  calc
    cylInd r = (r.length / (l.length + r.length)) • (cylInd l + cylInd r)
        - ((l.length * r.length) / (l.length + r.length)) •
            ((1 / l.length) • cylInd l - (1 / r.length) • cylInd r) := by
      ext x
      simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
      field_simp [ha.ne', hb.ne', (add_pos ha hb).ne']
      ring
    _ = (r.length / (l.length + r.length)) • cylInd p
        - ((l.length * r.length) / (l.length + r.length)) • haarDiff l r := by
      rw [← hp]
      rfl

/-- The left-child indicator lies in the span of the parent indicator and the
Haar difference. -/
theorem cylInd_left_mem_span {p l r : CylR} (hlo : l.lo = p.lo)
    (hmid : l.hi = r.lo) (hhi : r.hi = p.hi) :
    cylInd l ∈ Submodule.span ℝ ({cylInd p, haarDiff l r} : Set (ℝ → ℝ)) := by
  rw [Submodule.mem_span_pair]
  exact ⟨l.length / (l.length + r.length),
    (l.length * r.length) / (l.length + r.length),
    (cylInd_left_eq_smul hlo hmid hhi).symm⟩

/-- The right-child indicator lies in the span of the parent indicator and the
Haar difference. -/
theorem cylInd_right_mem_span {p l r : CylR} (hlo : l.lo = p.lo)
    (hmid : l.hi = r.lo) (hhi : r.hi = p.hi) :
    cylInd r ∈ Submodule.span ℝ ({cylInd p, haarDiff l r} : Set (ℝ → ℝ)) := by
  rw [Submodule.mem_span_pair]
  refine ⟨r.length / (l.length + r.length),
    -((l.length * r.length) / (l.length + r.length)), ?_⟩
  rw [cylInd_right_eq_smul hlo hmid hhi, neg_smul]
  abel

/-- The left child of a splitting rational cylinder. -/
def leftChild (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) : Cyl :=
  ⟨p.lo, cut n p, p.hlo, by linarith [p.hhi, lt_of_not_ge h], cut_pos n p⟩

/-- The right child of a splitting rational cylinder. -/
def rightChild (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) : Cyl :=
  ⟨cut n p, p.hi, by linarith [p.hlo, cut_pos n p], p.hhi, lt_of_not_ge h⟩

lemma splitAt_eq_children (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) :
    splitAt n p = [leftChild n p h, rightChild n p h] := by
  unfold splitAt
  rw [dite_eq_right h]
  rfl

/-- The Haar differences generated by the splits at depth `k`. -/
def haarDiffAt (k : ℕ) : Set (ℝ → ℝ) :=
  {f | ∃ p ∈ partition k, ∃ h : ¬ p.hi ≤ cut k p,
      f = haarDiff (leftChild k p h).toReal (rightChild k p h).toReal}

/-- The generator set: the root indicator plus all Haar differences up to depth
`n`. -/
def haarGens : ℕ → Set (ℝ → ℝ)
  | 0 => {cylInd rootCyl.toReal}
  | n + 1 => haarGens n ∪ haarDiffAt n

/-- The constant-plus-Haar span at depth `n`. -/
def haarSpan (n : ℕ) : Submodule ℝ (ℝ → ℝ) := Submodule.span ℝ (haarGens n)

lemma haarGens_subset_succ (n : ℕ) : haarGens n ⊆ haarGens (n + 1) := by
  simp [haarGens]

lemma haarGens_mono {m n : ℕ} (h : m ≤ n) : haarGens m ⊆ haarGens n := by
  induction h with
  | refl => exact subset_rfl
  | step _ ih => exact fun f hf => haarGens_subset_succ _ (ih hf)

lemma haarSpan_mono {m n : ℕ} (h : m ≤ n) : haarSpan m ≤ haarSpan n := by
  unfold haarSpan
  exact Submodule.span_mono (haarGens_mono h)

lemma splitAt_eq_self (n : ℕ) (p : Cyl) (h : p.hi ≤ cut n p) :
    splitAt n p = [p] := by
  unfold splitAt
  rw [dite_eq_left h]

lemma root_mem_partition_zero : rootCyl ∈ partition 0 := by
  simp [partition, rootCyl]

lemma span_pair_le_haarSpan_succ {n : ℕ} {p : Cyl} {h : ¬ p.hi ≤ cut n p}
    (hpmem : p ∈ partition n) (hp : cylInd p.toReal ∈ haarSpan n) :
    Submodule.span ℝ
      ({cylInd p.toReal,
        haarDiff (leftChild n p h).toReal (rightChild n p h).toReal} : Set (ℝ → ℝ))
      ≤ haarSpan (n + 1) := by
  apply Submodule.span_le.mpr
  intro f hf
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hf
  rcases hf with rfl | rfl
  · exact haarSpan_mono (Nat.le_succ n) hp
  · apply Submodule.subset_span
    simp only [haarGens, Set.mem_union]
    exact Or.inr ⟨p, hpmem, h, rfl⟩

/-- **O1 cylinder-to-Haar span.**  Every depth-`n` cylinder indicator lies in
the span of the root indicator and the Haar differences above it. -/
theorem cylInd_mem_haarSpan (n : ℕ) :
    ∀ c ∈ partition n, cylInd c.toReal ∈ haarSpan n := by
  induction n with
  | zero =>
      intro c hc
      simp [partition] at hc
      subst hc
      exact Submodule.subset_span (by simp [haarGens])
  | succ n ih =>
      intro c hc
      rw [show partition (n + 1) = (partition n).flatMap (splitAt n) from rfl] at hc
      obtain ⟨p, hp, hcp⟩ := List.mem_flatMap.mp hc
      by_cases h : p.hi ≤ cut n p
      · rw [splitAt_eq_self n p h] at hcp
        simp only [List.mem_singleton] at hcp
        rw [show c = p by simpa using hcp]
        exact haarSpan_mono (Nat.le_succ n) (ih p hp)
      · rw [splitAt_eq_children n p h] at hcp
        simp only [List.mem_cons, List.not_mem_nil, or_false] at hcp
        rcases hcp with rfl | rfl
        · have hmem := cylInd_left_mem_span
            (p := p.toReal) (l := (leftChild n p h).toReal)
            (r := (rightChild n p h).toReal) rfl rfl rfl
          exact span_pair_le_haarSpan_succ hp (ih p hp) hmem
        · have hmem := cylInd_right_mem_span
            (p := p.toReal) (l := (leftChild n p h).toReal)
            (r := (rightChild n p h).toReal) rfl rfl rfl
          exact span_pair_le_haarSpan_succ hp (ih p hp) hmem

/-- **O1 indicator span inside the Haar span.**  The span of the depth-`n`
cylinder indicators is contained in the constant-plus-Haar span. -/
theorem indicatorSpan_le_haarSpan (n : ℕ) :
    Submodule.span ℝ {g : ℝ → ℝ | ∃ c ∈ partition n, g = cylInd c.toReal}
      ≤ haarSpan n := by
  apply Submodule.span_le.mpr
  rintro g ⟨c, hc, rfl⟩
  exact cylInd_mem_haarSpan n c hc

/-- The finite cylinder-step sum at depth `n`. -/
noncomputable def cylSum (n : ℕ) (f : ℝ → ℝ) : ℝ → ℝ :=
  ∑ c ∈ (partitionR n).toFinset, (f c.lo) • cylInd c

theorem indicatorSpanR_le_haarSpan (n : ℕ) :
    Submodule.span ℝ {g : ℝ → ℝ | ∃ c ∈ partitionR n, g = cylInd c}
      ≤ haarSpan n := by
  apply Submodule.span_le.mpr
  rintro g ⟨c, hc, rfl⟩
  simp only [partitionR, List.mem_map] at hc
  obtain ⟨d, hd, rfl⟩ := hc
  exact cylInd_mem_haarSpan n d hd

theorem cylSum_mem_haarSpan (n : ℕ) (f : ℝ → ℝ) :
    cylSum n f ∈ haarSpan n := by
  apply indicatorSpanR_le_haarSpan n
  unfold cylSum
  apply Submodule.sum_mem
  intro c hc
  apply Submodule.smul_mem
  apply Submodule.subset_span
  exact ⟨c, by simpa using hc, rfl⟩

lemma cylInd_apply_of_not_mem {c : CylR} {x : ℝ}
    (h : ¬ (c.lo ≤ x ∧ x < c.hi)) : cylInd c x = 0 := by
  simp [cylInd, cylSet, h]

lemma cylSum_apply_of_mem (n : ℕ) (f : ℝ → ℝ) {x : ℝ}
    (hx : 0 ≤ x ∧ x < 1) : cylSum n f x = f (cylinderRep n x) := by
  obtain ⟨c0, hc0, hr, hc0lo, hc0hi⟩ := cylinderRep_spec hx
  have hc0' : c0 ∈ (partitionR n).toFinset := by simpa using hc0
  unfold cylSum
  rw [Finset.sum_apply]
  rw [Finset.sum_eq_single c0]
  · simp [cylInd, cylSet, hc0lo, hc0hi, hr]
  · intro b hb hne
    have hbpart : b ∈ partitionR n := by simpa using hb
    have hnot : ¬ (b.lo ≤ x ∧ x < b.hi) := by
      rintro ⟨hblo, hbhi⟩
      have hbc : b = c0 := partitionR_unique n b hbpart c0 hc0 hblo hbhi hc0lo hc0hi
      exact hne hbc
    change f b.lo * cylInd b x = 0
    rw [cylInd_apply_of_not_mem hnot, mul_zero]
  · intro h
    exact (h hc0').elim

/-- **O1 Haar-span density.**  Continuous functions on `[0,1]` are uniformly
approximated by elements of the constant-plus-Haar span. -/
theorem haarSpan_dense {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ n : ℕ, ∃ g ∈ haarSpan n,
      ∀ x : ℝ, ∀ _hx : 0 ≤ x ∧ x < 1, |f x - g x| ≤ ε := by
  obtain ⟨n, hn⟩ := exists_cylinder_step_approx hf hε
  refine ⟨n, cylSum n f, cylSum_mem_haarSpan n f, ?_⟩
  intro x hx
  rw [cylSum_apply_of_mem n f hx]
  exact hn x hx

/-- Lebesgue measure restricted to the half-open unit interval. -/
def unitMeasure : Measure ℝ := volume.restrict (Set.Ico (0 : ℝ) 1)

lemma unitMeasure_univ : unitMeasure Set.univ = 1 := by
  simp [unitMeasure, Real.volume_Ico]

lemma cylInd_aestronglyMeasurable (c : CylR) :
    AEStronglyMeasurable (cylInd c) unitMeasure := by
  unfold cylInd cylSet
  measurability

lemma cylSum_aestronglyMeasurable (n : ℕ) (f : ℝ → ℝ) :
    AEStronglyMeasurable (cylSum n f) unitMeasure := by
  unfold cylSum
  classical
  refine Finset.induction_on (partitionR n).toFinset ?_ ?_
  · change AEStronglyMeasurable (fun _ : ℝ => (0 : ℝ)) unitMeasure
    exact aestronglyMeasurable_const
  · intro a s ha ih
    rw [Finset.sum_insert ha]
    exact ((cylInd_aestronglyMeasurable a).const_smul (f a.lo)).add ih

/-- **O1 `L²` approximation.**  Every continuous function on `[0,1]` is
approximated in `L²(unitMeasure)` by an element of the constant-plus-Haar
span. -/
theorem haarSpan_eLpNorm_approx {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ n : ℕ, ∃ g ∈ haarSpan n,
      eLpNorm (fun x => f x - g x) 2 unitMeasure ≤ ENNReal.ofReal ε := by
  obtain ⟨n, hn⟩ := exists_cylinder_step_approx hf hε
  refine ⟨n, cylSum n f, cylSum_mem_haarSpan n f, ?_⟩
  have hbound : ∀ᵐ x ∂unitMeasure, ‖f x - cylSum n f x‖ ≤ ε := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ico] with x hx
    rw [cylSum_apply_of_mem n f hx, Real.norm_eq_abs]
    simpa [cylinderStep] using hn x hx
  have hf_ae : AEStronglyMeasurable f unitMeasure :=
    (hf.mono Set.Ico_subset_Icc_self).aestronglyMeasurable measurableSet_Ico
  have hmeas : AEStronglyMeasurable (fun x => f x - cylSum n f x) unitMeasure :=
    hf_ae.sub (cylSum_aestronglyMeasurable n f)
  have h := eLpNorm_le_of_ae_bound (p := 2) hmeas hbound
  simpa [unitMeasure_univ] using h

instance : IsFiniteMeasure unitMeasure := by
  rw [unitMeasure]
  infer_instance

/-- The finite cylinder-step sum is in `L²` for continuous `f`. -/
theorem cylSum_memLp (n : ℕ) {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) : MemLp (cylSum n f) 2 unitMeasure := by
  obtain ⟨C, hC⟩ := isCompact_Icc.exists_bound_of_continuousOn hf
  refine MemLp.of_bound (cylSum_aestronglyMeasurable n f) C ?_
  filter_upwards [self_mem_ae_restrict measurableSet_Ico] with x hx
  obtain ⟨c, _hc, hr, _hclo, _hchi⟩ := cylinderRep_spec hx
  rw [cylSum_apply_of_mem n f hx, hr]
  exact hC c.lo ⟨c.hlo, le_trans c.hlt.le c.hhi⟩

/-- A function continuous on `[0,1]` is in `L²(unitMeasure)`. -/
theorem memLp_of_continuousOn {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) : MemLp f 2 unitMeasure := by
  obtain ⟨C, hC⟩ := isCompact_Icc.exists_bound_of_continuousOn hf
  have hf_ae : AEStronglyMeasurable f unitMeasure :=
    (hf.mono Set.Ico_subset_Icc_self).aestronglyMeasurable measurableSet_Ico
  refine MemLp.of_bound hf_ae C ?_
  filter_upwards [self_mem_ae_restrict measurableSet_Ico] with x hx
  exact hC x ⟨hx.1, le_of_lt hx.2⟩

/-- The cylinder-step sum gives an `L²` approximation, stated with `eLpNorm`. -/
theorem cylSum_eLpNorm_approx {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ n : ℕ,
      eLpNorm (fun x => f x - cylSum n f x) 2 unitMeasure ≤ ENNReal.ofReal ε := by
  obtain ⟨n, hn⟩ := exists_cylinder_step_approx hf hε
  refine ⟨n, ?_⟩
  have hbound : ∀ᵐ x ∂unitMeasure, ‖f x - cylSum n f x‖ ≤ ε := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ico] with x hx
    rw [cylSum_apply_of_mem n f hx, Real.norm_eq_abs]
    simpa [cylinderStep] using hn x hx
  have hmeas : AEStronglyMeasurable (fun x => f x - cylSum n f x) unitMeasure :=
    (memLp_of_continuousOn hf).aestronglyMeasurable.sub
      (cylSum_aestronglyMeasurable n f)
  have h := eLpNorm_le_of_ae_bound (p := 2) hmeas hbound
  simpa [unitMeasure_univ] using h

/-- **O1 `Lp`-distance approximation.**  The `Lp` distance between a continuous
function and its cylinder-step sum is at most `ε`. -/
theorem edist_toLp_cylSum_approx {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Icc 0 1)) {ε : ℝ} (hε : 0 < ε) :
    ∃ n : ℕ,
      edist ((memLp_of_continuousOn hf).toLp f)
        ((cylSum_memLp n hf).toLp (cylSum n f)) ≤ ENNReal.ofReal ε := by
  obtain ⟨n, hn⟩ := cylSum_eLpNorm_approx hf hε
  refine ⟨n, ?_⟩
  rw [Lp.edist_toLp_toLp]
  exact hn

instance : unitMeasure.WeaklyRegular := by
  rw [unitMeasure]
  exact Measure.WeaklyRegular.restrict_of_measure_ne_top (by simp [Real.volume_Ico])

/-- **O1 `Lp` density with a continuous witness.**  Every `L²` class is within
`ε` of a cylinder-step sum coming from a continuous function. -/
theorem exists_cylSum_edist_lt (F : Lp ℝ 2 unitMeasure) {ε : ℝ} (hε : 0 < ε) :
    ∃ (f : ℝ → ℝ) (_hf : ContinuousOn f (Set.Icc 0 1)) (n : ℕ),
      edist F ((cylSum_memLp n _hf).toLp (cylSum n f)) ≤ ENNReal.ofReal ε := by
  have hε2 : 0 < ε / 2 := by positivity
  have hdense : DenseRange
      (BoundedContinuousFunction.toLp (E := ℝ) (p := 2) (μ := unitMeasure) (𝕜 := ℝ)) :=
    BoundedContinuousFunction.toLp_denseRange ℝ unitMeasure ℝ (by norm_num)
  obtain ⟨φ, hφ⟩ := hdense.exists_dist_lt F hε2
  let φLp : Lp ℝ 2 unitMeasure :=
    BoundedContinuousFunction.toLp (E := ℝ) (p := 2) (μ := unitMeasure) (𝕜 := ℝ) φ
  have hφcont : ContinuousOn (φ : ℝ → ℝ) (Set.Icc 0 1) := φ.continuous.continuousOn
  obtain ⟨n, hn⟩ := edist_toLp_cylSum_approx (f := (φ : ℝ → ℝ)) hφcont hε2
  refine ⟨(φ : ℝ → ℝ), hφcont, n, ?_⟩
  have hφLp_eq : φLp = (memLp_of_continuousOn hφcont).toLp (φ : ℝ → ℝ) := by
    apply Lp.ext
    filter_upwards [BoundedContinuousFunction.coeFn_toLp (p := 2) (μ := unitMeasure) (𝕜 := ℝ) φ,
      MemLp.coeFn_toLp (memLp_of_continuousOn hφcont)] with x hx1 hx2
    rw [hx1, hx2]
  have h1 : edist F φLp ≤ ENNReal.ofReal (ε / 2) := by
    rw [MeasureTheory.Lp.edist_dist]
    exact ENNReal.ofReal_le_ofReal hφ.le
  have h2 : edist φLp ((cylSum_memLp n hφcont).toLp (cylSum n (φ : ℝ → ℝ)))
      ≤ ENNReal.ofReal (ε / 2) := by
    rw [hφLp_eq]
    exact hn
  have htri := edist_triangle F φLp
    ((cylSum_memLp n hφcont).toLp (cylSum n (φ : ℝ → ℝ)))
  have hsum : ENNReal.ofReal (ε / 2) + ENNReal.ofReal (ε / 2) = ENNReal.ofReal ε := by
    rw [← ENNReal.ofReal_add (by positivity) (by positivity)]
    congr 1
    ring
  exact le_trans htri (le_trans (add_le_add h1 h2) (le_of_eq hsum))

/-- **O1 Haar-span `Lp` density.**  Every `L²` class is within `ε` of the image of
an element of the constant-plus-Haar span. -/
theorem haarSpan_dense_Lp (F : Lp ℝ 2 unitMeasure) {ε : ℝ} (hε : 0 < ε) :
    ∃ (n : ℕ) (g : ℝ → ℝ), g ∈ haarSpan n ∧
      ∃ hg : MemLp g 2 unitMeasure,
        edist F (hg.toLp g) ≤ ENNReal.ofReal ε := by
  obtain ⟨f, hf, n, hn⟩ := exists_cylSum_edist_lt F hε
  exact ⟨n, cylSum n f, cylSum_mem_haarSpan n f, cylSum_memLp n hf, hn⟩

/-- **Haar completeness (density form).**  The constant-plus-Haar span is dense
in `L²([0,1))`. -/
theorem haar_complete (F : Lp ℝ 2 unitMeasure) {ε : ℝ} (hε : 0 < ε) :
    ∃ (n : ℕ) (g : ℝ → ℝ), g ∈ haarSpan n ∧
      ∃ hg : MemLp g 2 unitMeasure,
        edist F (hg.toLp g) ≤ ENNReal.ofReal ε :=
  haarSpan_dense_Lp F hε

/-- The normalising scalar for a split with children `l`, `r`. -/
def haarScale (l r : CylR) : ℝ :=
  Real.sqrt ((l.length * r.length) / (l.length + r.length))

lemma haarScale_pos {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    0 < haarScale l r := by
  unfold haarScale
  positivity

/-- The normalised Haar wavelet, as a scalar multiple of `haarDiff`. -/
def haarFun (l r : CylR) : ℝ → ℝ := haarScale l r • haarDiff l r

lemma haarFun_eq_smul (l r : CylR) : haarFun l r = haarScale l r • haarDiff l r :=
  rfl

/-- The normalised wavelet spans the same one-dimensional space as the
unnormalised Haar difference. -/
theorem span_haarFun_eq_span_haarDiff {l r : CylR}
    (hl : 0 < l.length) (hr : 0 < r.length) :
    Submodule.span ℝ ({haarFun l r} : Set (ℝ → ℝ))
      = Submodule.span ℝ ({haarDiff l r} : Set (ℝ → ℝ)) := by
  apply le_antisymm
  · apply Submodule.span_le.mpr
    intro f hf
    simp only [Set.mem_singleton_iff] at hf
    subst hf
    exact Submodule.smul_mem _ _
      (Submodule.subset_span (by simp : haarDiff l r ∈ ({haarDiff l r} : Set (ℝ → ℝ))))
  · apply Submodule.span_le.mpr
    intro f hf
    simp only [Set.mem_singleton_iff] at hf
    subst hf
    have hc : haarScale l r ≠ 0 := (haarScale_pos hl hr).ne'
    have hEq : haarDiff l r = (haarScale l r)⁻¹ • haarFun l r := by
      rw [haarFun, smul_smul, inv_mul_cancel₀ hc, one_smul]
    rw [hEq]
    exact Submodule.smul_mem _ _
      (Submodule.subset_span (by simp : haarFun l r ∈ ({haarFun l r} : Set (ℝ → ℝ))))

/-- The normalised Haar differences generated by the splits at depth `k`. -/
def haarDiffAtNorm (k : ℕ) : Set (ℝ → ℝ) :=
  {f | ∃ p ∈ partition k, ∃ h : ¬ p.hi ≤ cut k p,
      f = haarFun (leftChild k p h).toReal (rightChild k p h).toReal}

/-- The normalised generator set: root indicator plus normalised wavelets. -/
def haarGensNorm : ℕ → Set (ℝ → ℝ)
  | 0 => {cylInd rootCyl.toReal}
  | n + 1 => haarGensNorm n ∪ haarDiffAtNorm n

/-- The constant-plus-normalised-Haar span at depth `n`. -/
def haarSpanNorm (n : ℕ) : Submodule ℝ (ℝ → ℝ) :=
  Submodule.span ℝ (haarGensNorm n)

lemma haarFun_mem_span_haarDiff {l r : CylR} (_hl : 0 < l.length) (_hr : 0 < r.length) :
    haarFun l r ∈ Submodule.span ℝ ({haarDiff l r} : Set (ℝ → ℝ)) := by
  exact Submodule.smul_mem _ _
    (Submodule.subset_span (by simp : haarDiff l r ∈ ({haarDiff l r} : Set (ℝ → ℝ))))

lemma haarDiff_mem_span_haarFun {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    haarDiff l r ∈ Submodule.span ℝ ({haarFun l r} : Set (ℝ → ℝ)) := by
  have hc : haarScale l r ≠ 0 := (haarScale_pos hl hr).ne'
  have hEq : haarDiff l r = (haarScale l r)⁻¹ • haarFun l r := by
    rw [haarFun, smul_smul, inv_mul_cancel₀ hc, one_smul]
  rw [hEq]
  exact Submodule.smul_mem _ _
    (Submodule.subset_span (by simp : haarFun l r ∈ ({haarFun l r} : Set (ℝ → ℝ))))

lemma length_leftChild_pos (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) :
    0 < (leftChild n p h).toReal.length := by
  dsimp [CylR.length, Cyl.toReal, leftChild]
  exact_mod_cast (sub_pos.mpr (cut_pos n p))

lemma length_rightChild_pos (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) :
    0 < (rightChild n p h).toReal.length := by
  dsimp [CylR.length, Cyl.toReal, rightChild]
  exact_mod_cast (sub_pos.mpr (lt_of_not_ge h))

lemma span_haarDiffAtNorm_eq (k : ℕ) :
    Submodule.span ℝ (haarDiffAtNorm k) = Submodule.span ℝ (haarDiffAt k) := by
  apply le_antisymm
  · apply Submodule.span_le.mpr
    rintro f ⟨p, hp, h, rfl⟩
    have hl := length_leftChild_pos k p h
    have hr := length_rightChild_pos k p h
    refine Submodule.span_mono ?_ (haarFun_mem_span_haarDiff hl hr)
    intro g hg
    simp only [Set.mem_singleton_iff] at hg
    subst hg
    exact ⟨p, hp, h, rfl⟩
  · apply Submodule.span_le.mpr
    rintro f ⟨p, hp, h, rfl⟩
    have hl := length_leftChild_pos k p h
    have hr := length_rightChild_pos k p h
    refine Submodule.span_mono ?_ (haarDiff_mem_span_haarFun hl hr)
    intro g hg
    simp only [Set.mem_singleton_iff] at hg
    subst hg
    exact ⟨p, hp, h, rfl⟩

/-- **Normalised span equality.**  The constant-plus-normalised-Haar span equals
the constant-plus-`haarDiff` span at every depth. -/
theorem haarSpanNorm_eq (n : ℕ) : haarSpanNorm n = haarSpan n := by
  induction n with
  | zero => rfl
  | succ n ih =>
      change Submodule.span ℝ (haarGensNorm n) = Submodule.span ℝ (haarGens n) at ih
      unfold haarSpanNorm haarSpan
      rw [show haarGensNorm (n + 1) = haarGensNorm n ∪ haarDiffAtNorm n from rfl]
      rw [show haarGens (n + 1) = haarGens n ∪ haarDiffAt n from rfl]
      rw [Submodule.span_union, Submodule.span_union, ih, span_haarDiffAtNorm_eq n]

/-- **Normalised Haar completeness.**  The constant-plus-normalised-Haar span
is dense in `L²([0,1))`. -/
theorem haar_complete_norm (F : Lp ℝ 2 unitMeasure) {ε : ℝ} (hε : 0 < ε) :
    ∃ (n : ℕ) (g : ℝ → ℝ), g ∈ haarSpanNorm n ∧
      ∃ hg : MemLp g 2 unitMeasure,
        edist F (hg.toLp g) ≤ ENNReal.ofReal ε := by
  obtain ⟨n, g, hg, hmem, hdist⟩ := haar_complete F hε
  exact ⟨n, g, by rwa [haarSpanNorm_eq], hmem, hdist⟩

/-- The normalised wavelet has unit squared coefficient norm. -/
theorem haarFun_coeff_normSq {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    l.length * (haarScale l r * (1 / l.length)) ^ 2
      + r.length * (haarScale l r * (-1 / r.length)) ^ 2 = 1 := by
  have hc : haarScale l r ^ 2 = (l.length * r.length) / (l.length + r.length) := by
    unfold haarScale
    rw [Real.sq_sqrt (by positivity)]
  calc
    l.length * (haarScale l r * (1 / l.length)) ^ 2
        + r.length * (haarScale l r * (-1 / r.length)) ^ 2
      = haarScale l r ^ 2 *
          (l.length * (1 / l.length) ^ 2 + r.length * (-1 / r.length) ^ 2) := by ring
    _ = 1 := by
      rw [hc]
      field_simp [hl.ne', hr.ne', (add_pos hl hr).ne']
      ring

/-- The normalised wavelet has zero signed coefficient mass. -/
theorem haarFun_coeff_mean {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    l.length * (haarScale l r * (1 / l.length))
      + r.length * (haarScale l r * (-1 / r.length)) = 0 := by
  calc
    l.length * (haarScale l r * (1 / l.length))
        + r.length * (haarScale l r * (-1 / r.length))
      = haarScale l r * (l.length * (1 / l.length) + r.length * (-1 / r.length)) := by ring
    _ = 0 := by
      field_simp [hl.ne', hr.ne']
      ring

/-- The normalised wavelet vanishes outside its two children. -/
lemma haarFun_apply_of_not_mem {l r : CylR} {x : ℝ}
    (hl : ¬ (l.lo ≤ x ∧ x < l.hi)) (hr : ¬ (r.lo ≤ x ∧ x < r.hi)) :
    haarFun l r x = 0 := by
  unfold haarFun haarDiff
  simp [cylInd, cylSet, hl, hr]

/-- The residual is non-increasing. -/
theorem residual_succ_le (n : ℕ) (θ : ℝ) : residual (n + 1) θ ≤ residual n θ := by
  unfold residual
  rw [show accum (n + 1) θ
      = accum n θ + (if alpha n ≤ θ - accum n θ then alpha n else 0) from rfl]
  by_cases h : alpha n ≤ θ - accum n θ
  · simp [h]
    linarith [alpha_pos n]
  · simp [h]

theorem residual_antitone (θ : ℝ) : Antitone (fun n : ℕ => residual n θ) := by
  intro n m hnm
  induction hnm with
  | refl => exact le_rfl
  | step _ ih => exact le_trans (residual_succ_le _ θ) ih

/-- A selected digit leaves residual at most `π/((n+1)(n+2))`. -/
lemma residual_succ_le_of_digit_eq_one {n : ℕ} {θ : ℝ}
    (h : digit n θ = 1) (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) :
    residual (n + 1) θ ≤ Real.pi / (((n : ℝ) + 1) * ((n : ℝ) + 2)) := by
  have hsel : alpha n ≤ θ - accum n θ := by
    by_contra hnot
    have hdigit : digit n θ = 0 := by
      unfold digit
      simp [hnot]
    rw [h] at hdigit
    exact Nat.one_ne_zero hdigit
  have hacc : accum (n + 1) θ = accum n θ + alpha n := by
    rw [show accum (n + 1) θ
        = accum n θ + (if alpha n ≤ θ - accum n θ then alpha n else 0) from rfl]
    simp [hsel]
  have hr : residual (n + 1) θ = residual n θ - alpha n := by
    unfold residual
    rw [hacc]
    ring
  have hbound := residual_le_pi_div n h0 hπ
  have hα : alpha n = Real.pi / ((n : ℝ) + 2) := rfl
  calc
    residual (n + 1) θ = residual n θ - alpha n := hr
    _ ≤ Real.pi / ((n : ℝ) + 1) - Real.pi / ((n : ℝ) + 2) := by
      rw [hα]
      linarith
    _ = Real.pi / (((n : ℝ) + 1) * ((n : ℝ) + 2)) := by
      field_simp
      ring

lemma alpha_le_residual_of_digit_eq_one {n : ℕ} {θ : ℝ} (h : digit n θ = 1) :
    alpha n ≤ residual n θ := by
  have hsel : alpha n ≤ θ - accum n θ := by
    by_contra hnot
    have hdigit : digit n θ = 0 := by
      unfold digit
      simp [hnot]
    rw [h] at hdigit
    exact Nat.one_ne_zero hdigit
  simpa [residual] using hsel

/-- **O3 gap bound.**  After a selected digit at `n`, any later selected digit
`m` satisfies `(n+1)(n+2) ≤ m+2`.  The selection indices therefore grow at
least quadratically. -/
theorem digit_one_gap {θ : ℝ} (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi)
    {n m : ℕ} (hn : digit n θ = 1) (hm : digit m θ = 1) (hnm : n < m) :
    (n + 1) * (n + 2) ≤ m + 2 := by
  have hmono : residual m θ ≤ residual (n + 1) θ :=
    residual_antitone θ (Nat.succ_le_of_lt hnm)
  have hbound := residual_succ_le_of_digit_eq_one hn h0 hπ
  have hle : alpha m ≤ Real.pi / (((n : ℝ) + 1) * ((n : ℝ) + 2)) :=
    le_trans (alpha_le_residual_of_digit_eq_one hm) (le_trans hmono hbound)
  have hα : alpha m = Real.pi / ((m : ℝ) + 2) := rfl
  rw [hα] at hle
  have h1 : (0 : ℝ) < (m : ℝ) + 2 := by positivity
  have h2 : (0 : ℝ) < ((n : ℝ) + 1) * ((n : ℝ) + 2) := by positivity
  rw [div_le_div_iff₀ h1 h2] at hle
  have hreal : ((n : ℝ) + 1) * ((n : ℝ) + 2) ≤ (m : ℝ) + 2 := by
    nlinarith [Real.pi_pos]
  exact_mod_cast hreal

/-- The integral of a cylinder indicator with respect to `unitMeasure` is its
length. -/
lemma integral_cylInd (c : CylR) :
    ∫ x, cylInd c x ∂unitMeasure = c.length := by
  unfold cylInd cylSet unitMeasure CylR.length
  rw [MeasureTheory.integral_indicator measurableSet_Ico]
  simp only [MeasureTheory.setIntegral_const, smul_eq_mul, mul_one]
  rw [Measure.real_def, Measure.restrict_apply measurableSet_Ico]
  have hsub : Set.Ico c.lo c.hi ⊆ Set.Ico (0 : ℝ) 1 := by
    intro x hx
    exact ⟨le_trans c.hlo hx.1, lt_of_lt_of_le hx.2 c.hhi⟩
  rw [Set.inter_eq_left.mpr hsub]
  rw [Real.volume_Ico]
  simp [ENNReal.toReal_ofReal (sub_nonneg.mpr c.hlt.le)]

lemma integrable_cylInd (c : CylR) : Integrable (cylInd c) unitMeasure := by
  refine Integrable.of_bound (cylInd_aestronglyMeasurable c) 1 ?_
  filter_upwards with x
  unfold cylInd cylSet
  rw [Set.indicator_apply]
  split_ifs <;> norm_num

lemma integral_haarDiff_eq_zero {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    ∫ x, haarDiff l r x ∂unitMeasure = 0 := by
  unfold haarDiff
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  rw [integral_sub ((integrable_cylInd l).const_mul (1 / l.length))
      ((integrable_cylInd r).const_mul (1 / r.length)),
    integral_const_mul, integral_const_mul, integral_cylInd, integral_cylInd]
  field_simp [hl.ne', hr.ne']
  ring

lemma integral_haarFun_eq_zero {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    ∫ x, haarFun l r x ∂unitMeasure = 0 := by
  unfold haarFun
  simp only [Pi.smul_apply, smul_eq_mul]
  rw [integral_const_mul, integral_haarDiff_eq_zero hl hr, mul_zero]

/-- After index `1`, two consecutive digits cannot both be selected. -/
theorem digit_one_not_succ {θ : ℝ} (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi)
    {n : ℕ} (hn : 1 ≤ n) (h : digit n θ = 1) : digit (n + 1) θ = 0 := by
  by_contra hzero
  have hle : digit (n + 1) θ ≤ 1 := by
    unfold digit
    split_ifs <;> omega
  have hone : digit (n + 1) θ = 1 := by omega
  have hgap := digit_one_gap h0 hπ h hone (Nat.lt_succ_self n)
  have hineq : (n + 1) * (n + 2) ≤ n + 3 := by simpa using hgap
  nlinarith

/-- **O3 doubling.**  After index `1`, a later selected index at least doubles
the shifted index: `2(n+2) ≤ m+2`. -/
theorem digit_one_doubling {θ : ℝ} (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi)
    {n m : ℕ} (hn : 1 ≤ n) (h : digit n θ = 1) (hm : digit m θ = 1)
    (hnm : n < m) : 2 * (n + 2) ≤ m + 2 := by
  have hgap := digit_one_gap h0 hπ h hm hnm
  have hquad : 2 * (n + 2) ≤ (n + 1) * (n + 2) := by nlinarith
  exact le_trans hquad hgap

/-- Pointwise square identity for the normalised wavelet on disjoint children. -/
lemma haarFun_sq_eq {l r : CylR} (hmid : l.hi = r.lo) (x : ℝ) :
    (haarFun l r x) ^ 2 = (haarScale l r) ^ 2 *
      ((1 / l.length) ^ 2 * cylInd l x + (1 / r.length) ^ 2 * cylInd r x) := by
  unfold haarFun haarDiff cylInd cylSet
  simp only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul, Set.indicator_apply]
  by_cases hl : l.lo ≤ x ∧ x < l.hi
  · have hr : ¬ (r.lo ≤ x ∧ x < r.hi) := by
      rintro ⟨h1, h2⟩
      linarith [hl.2, hmid, h1]
    simp [hl, hr]
    ring
  · by_cases hr : r.lo ≤ x ∧ x < r.hi
    · simp [hl, hr]
      ring
    · simp [hl, hr]

/-- The normalised wavelet has unit `L²` norm on a split with disjoint children. -/
theorem integral_haarFun_sq {l r : CylR} (hmid : l.hi = r.lo)
    (hl : 0 < l.length) (hr : 0 < r.length) :
    ∫ x, (haarFun l r x) ^ 2 ∂unitMeasure = 1 := by
  have hcongr : (∫ x, (haarFun l r x) ^ 2 ∂unitMeasure)
      = ∫ x, (haarScale l r) ^ 2 *
          ((1 / l.length) ^ 2 * cylInd l x + (1 / r.length) ^ 2 * cylInd r x)
          ∂unitMeasure := by
    apply integral_congr_ae
    filter_upwards with x
    exact haarFun_sq_eq hmid x
  rw [hcongr]
  have hA : Integrable (fun x => (1 / l.length) ^ 2 * cylInd l x) unitMeasure :=
    (integrable_cylInd l).const_mul _
  have hB : Integrable (fun x => (1 / r.length) ^ 2 * cylInd r x) unitMeasure :=
    (integrable_cylInd r).const_mul _
  rw [integral_const_mul, integral_add hA hB, integral_const_mul, integral_const_mul,
    integral_cylInd, integral_cylInd]
  calc
    (haarScale l r) ^ 2 *
        ((1 / l.length) ^ 2 * l.length + (1 / r.length) ^ 2 * r.length)
      = l.length * (haarScale l r * (1 / l.length)) ^ 2
          + r.length * (haarScale l r * (-1 / r.length)) ^ 2 := by ring
    _ = 1 := haarFun_coeff_normSq hl hr

/-- If `θ < αₙ₋₁`, no digit up to `n` is selected. -/
lemma accum_eq_zero_of_lt_alpha_pred {n : ℕ} (hn : 0 < n) {θ : ℝ}
    (h : θ < alpha (n - 1)) : accum n θ = 0 := by
  have hz : accum (n - 1) θ = 0 := accum_eq_zero_of_lt (n - 1) h
  rw [show n = (n - 1) + 1 by omega, accum, hz]
  simp [not_le.mpr h]

/-- **F2/O4 first component.**  On the first cylinder band
`[αₙ, αₙ₋₁)`, the `n`-th digit is selected. -/
theorem digit_one_on_first_interval {n : ℕ} (hn : 0 < n) {θ : ℝ}
    (hlo : alpha n ≤ θ) (hhi : θ < alpha (n - 1)) : digit n θ = 1 := by
  have hacc : accum n θ = 0 := accum_eq_zero_of_lt_alpha_pred hn hhi
  unfold digit
  rw [hacc]
  simp [hlo]

/-- **F2/O4 first component, converse.**  Below `αₙ₋₁`, the `n`-th digit is
selected exactly when `θ ≥ αₙ`. -/
theorem digit_one_iff_first_interval {n : ℕ} (hn : 0 < n) {θ : ℝ}
    (hhi : θ < alpha (n - 1)) : digit n θ = 1 ↔ alpha n ≤ θ := by
  constructor
  · intro h
    have hsel : alpha n ≤ θ - accum n θ := by
      by_contra hnot
      have hdigit : digit n θ = 0 := by
        unfold digit
        simp [hnot]
      rw [h] at hdigit
      exact Nat.one_ne_zero hdigit
    have hacc : accum n θ = 0 := accum_eq_zero_of_lt_alpha_pred hn hhi
    simpa [hacc] using hsel
  · intro h
    exact digit_one_on_first_interval hn h hhi

/-- The normalised wavelet vanishes outside its parent interval. -/
lemma haarFun_eq_zero_of_not_mem_parent {l r : CylR} (hmid : l.hi = r.lo)
    {x : ℝ} (hx : x ∉ Set.Ico l.lo r.hi) : haarFun l r x = 0 := by
  apply haarFun_apply_of_not_mem
  · intro h
    exact hx ⟨h.1, by linarith [h.2, hmid, r.hlt]⟩
  · intro h
    exact hx ⟨by linarith [h.1, hmid, l.hlt], h.2⟩

/-- **Disjoint-support orthogonality.**  Normalised Haar wavelets whose parent
intervals are disjoint are orthogonal in `L²`. -/
theorem integral_mul_eq_zero_of_disjoint {l1 r1 l2 r2 : CylR}
    (hmid1 : l1.hi = r1.lo) (hmid2 : l2.hi = r2.lo)
    (hdisj : Disjoint (Set.Ico l1.lo r1.hi) (Set.Ico l2.lo r2.hi)) :
    ∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure = 0 := by
  apply MeasureTheory.integral_eq_zero_of_ae
  filter_upwards with x
  by_cases hx1 : x ∈ Set.Ico l1.lo r1.hi
  · have hx2 : x ∉ Set.Ico l2.lo r2.hi :=
      fun h2 => (Set.disjoint_left.mp hdisj) hx1 h2
    simp [haarFun_eq_zero_of_not_mem_parent hmid2 hx2]
  · simp [haarFun_eq_zero_of_not_mem_parent hmid1 hx1]

lemma haarFun_eq_left_const {l r : CylR} (hmid : l.hi = r.lo) {x : ℝ}
    (hx : x ∈ Set.Ico l.lo l.hi) :
    haarFun l r x = haarScale l r * (1 / l.length) := by
  unfold haarFun haarDiff cylInd cylSet
  simp only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul, Set.indicator_apply]
  have hr : ¬ (r.lo ≤ x ∧ x < r.hi) := by
    rintro ⟨h1, h2⟩
    linarith [hx.2, hmid, h1]
  simp [hx.1, hx.2, hr]

lemma haarFun_eq_right_const {l r : CylR} (hmid : l.hi = r.lo) {x : ℝ}
    (hx : x ∈ Set.Ico r.lo r.hi) :
    haarFun l r x = haarScale l r * (-1 / r.length) := by
  unfold haarFun haarDiff cylInd cylSet
  simp only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul, Set.indicator_apply]
  have hl : ¬ (l.lo ≤ x ∧ x < l.hi) := by
    rintro ⟨h1, h2⟩
    linarith [hx.1, hmid, h2]
  simp [hl, hx.1, hx.2]
  ring

/-- **Nested-support orthogonality (left).**  If one wavelet's parent lies in
the left child of another, the two are orthogonal. -/
theorem integral_mul_eq_zero_of_subset_left {l1 r1 l2 r2 : CylR}
    (hmid1 : l1.hi = r1.lo) (hmid2 : l2.hi = r2.lo)
    (hl1 : 0 < l1.length) (hr1 : 0 < r1.length)
    (hsub : Set.Ico l1.lo r1.hi ⊆ Set.Ico l2.lo l2.hi) :
    ∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure = 0 := by
  let c : ℝ := haarScale l2 r2 * (1 / l2.length)
  have hcongr : (∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure)
      = ∫ x, haarFun l1 r1 x * c ∂unitMeasure := by
    apply integral_congr_ae
    filter_upwards with x
    by_cases hx : x ∈ Set.Ico l1.lo r1.hi
    · rw [haarFun_eq_left_const hmid2 (hsub hx)]
    · rw [haarFun_eq_zero_of_not_mem_parent hmid1 hx]
      simp
  rw [hcongr, integral_mul_const, integral_haarFun_eq_zero hl1 hr1, zero_mul]

/-- **Nested-support orthogonality (right).**  If one wavelet's parent lies in
the right child of another, the two are orthogonal. -/
theorem integral_mul_eq_zero_of_subset_right {l1 r1 l2 r2 : CylR}
    (hmid1 : l1.hi = r1.lo) (hmid2 : l2.hi = r2.lo)
    (hl1 : 0 < l1.length) (hr1 : 0 < r1.length)
    (hsub : Set.Ico l1.lo r1.hi ⊆ Set.Ico r2.lo r2.hi) :
    ∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure = 0 := by
  let c : ℝ := haarScale l2 r2 * (-1 / r2.length)
  have hcongr : (∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure)
      = ∫ x, haarFun l1 r1 x * c ∂unitMeasure := by
    apply integral_congr_ae
    filter_upwards with x
    by_cases hx : x ∈ Set.Ico l1.lo r1.hi
    · rw [haarFun_eq_right_const hmid2 (hsub hx)]
    · rw [haarFun_eq_zero_of_not_mem_parent hmid1 hx]
      simp
  rw [hcongr, integral_mul_const, integral_haarFun_eq_zero hl1 hr1, zero_mul]

/-- On the second band, the accumulated angle stays at `π/2` up to depth `n`. -/
lemma accum_eq_half_pi_of_lt {n k : ℕ} (hk : 1 ≤ k) (hkn : k ≤ n) {θ : ℝ}
    (hlo : Real.pi / 2 ≤ θ)
    (hhi : θ < Real.pi / 2 + Real.pi / ((n : ℝ) + 1)) : accum k θ = Real.pi / 2 := by
  induction k, hk using Nat.le_induction with
  | base =>
      have hα : alpha 0 = Real.pi / 2 := by norm_num [alpha]
      simp [accum, hα, hlo]
  | succ k hk ih =>
      have hα : alpha k = Real.pi / ((k : ℝ) + 2) := rfl
      have hk2 : ((k : ℝ) + 2) ≤ ((n : ℝ) + 1) := by
        exact_mod_cast (by omega : k + 2 ≤ n + 1)
      have hle : Real.pi / ((n : ℝ) + 1) ≤ Real.pi / ((k : ℝ) + 2) := by
        exact div_le_div_of_nonneg_left Real.pi_pos.le (by positivity) hk2
      have hlt : θ - accum k θ < alpha k := by
        rw [ih (by omega), hα]
        linarith
      rw [show accum (k + 1) θ
          = accum k θ + (if alpha k ≤ θ - accum k θ then alpha k else 0) from rfl]
      rw [ite_eq_right (not_le.mpr hlt), ih (by omega)]
      ring

/-- **F2/O4 second component.**  On the second cylinder band, the `n`-th digit
is selected exactly when `θ ≥ π/2 + π/(n+2)`. -/
theorem digit_one_iff_second_interval {n : ℕ} (hn : 2 ≤ n) {θ : ℝ}
    (hlo : Real.pi / 2 ≤ θ)
    (hhi : θ < Real.pi / 2 + Real.pi / ((n : ℝ) + 1)) :
    digit n θ = 1 ↔ Real.pi / 2 + Real.pi / ((n : ℝ) + 2) ≤ θ := by
  constructor
  · intro h
    have hsel : alpha n ≤ θ - accum n θ := by
      by_contra hnot
      have hdigit : digit n θ = 0 := by
        unfold digit
        simp [hnot]
      rw [h] at hdigit
      exact Nat.one_ne_zero hdigit
    have hacc : accum n θ = Real.pi / 2 :=
      accum_eq_half_pi_of_lt (k := n) (by omega) le_rfl hlo hhi
    rw [hacc] at hsel
    have hα : alpha n = Real.pi / ((n : ℝ) + 2) := rfl
    rw [hα] at hsel
    linarith
  · intro h
    have hacc : accum n θ = Real.pi / 2 :=
      accum_eq_half_pi_of_lt (k := n) (by omega) le_rfl hlo hhi
    unfold digit
    rw [hacc]
    have hα : alpha n = Real.pi / ((n : ℝ) + 2) := rfl
    rw [hα]
    have hsel : Real.pi / ((n : ℝ) + 2) ≤ θ - Real.pi / 2 := by linarith
    simp [hsel]

/-- **F2/O4 general component.**  If the first selected digit is at `j` and no
digit is selected again until `n`, then the `n`-th digit is selected exactly on
the component starting at `α_j + α_n`. -/
theorem digit_one_on_component {n j : ℕ} (hj : j < n) (hj1 : 1 ≤ j) {θ : ℝ}
    (hlo : alpha j ≤ θ) (hhi : θ < alpha (j - 1))
    (hhi2 : θ < alpha j + alpha (n - 1))
    (hlo2 : alpha j + alpha n ≤ θ) : digit n θ = 1 := by
  have haccj : accum j θ = 0 := accum_eq_zero_of_lt_alpha_pred hj1 hhi
  have hdj : digit j θ = 1 := digit_one_on_first_interval hj1 hlo hhi
  have hbase : accum (j + 1) θ = alpha j := by
    rw [show accum (j + 1) θ
        = accum j θ + (if alpha j ≤ θ - accum j θ then alpha j else 0) from rfl]
    rw [haccj]
    have hsel : alpha j ≤ θ - 0 := by simpa using hlo
    rw [ite_eq_left hsel]
    ring
  have hacc_from : ∀ k, j + 1 ≤ k → k ≤ n → accum k θ = alpha j := by
    intro k hk1 hkn
    induction k, hk1 using Nat.le_induction with
    | base => exact hbase
    | succ k hk ih =>
        have hk_le : k ≤ n := by omega
        have hacc : accum k θ = alpha j := ih hk_le
        have hk_le_pred : k ≤ n - 1 := by omega
        have hαle : alpha (n - 1) ≤ alpha k :=
          alpha_strictAnti.antitone hk_le_pred
        have hlt : θ - accum k θ < alpha k := by
          rw [hacc]
          linarith
        rw [show accum (k + 1) θ
            = accum k θ + (if alpha k ≤ θ - accum k θ then alpha k else 0) from rfl]
        rw [ite_eq_right (not_le.mpr hlt), hacc]
        ring
  have haccn : accum n θ = alpha j := hacc_from n (by omega) le_rfl
  unfold digit
  rw [haccn]
  have hsel : alpha n ≤ θ - alpha j := by linarith
  simp [hsel]

/-- If `j` is the first selected digit and no digit between `j` and `n` is
selected, the accumulated angle at `n` is `αⱼ`. -/
theorem accum_eq_alpha_of_first_component {n j : ℕ} (hj : j < n) (hj1 : 1 ≤ j)
    {θ : ℝ} (hhi : θ < alpha (j - 1)) (hdj : digit j θ = 1)
    (hno : ∀ k, j < k → k < n → digit k θ = 0) :
    accum n θ = alpha j := by
  have haccj : accum j θ = 0 := accum_eq_zero_of_lt_alpha_pred hj1 hhi
  have hbase : accum (j + 1) θ = alpha j := by
    have hsel : alpha j ≤ θ - accum j θ := alpha_le_residual_of_digit_eq_one hdj
    rw [haccj] at hsel
    rw [show accum (j + 1) θ
        = accum j θ + (if alpha j ≤ θ - accum j θ then alpha j else 0) from rfl]
    rw [haccj, ite_eq_left hsel]
    ring
  have hacc_from : ∀ k, j + 1 ≤ k → k ≤ n → accum k θ = alpha j := by
    intro k hk1 hkn
    induction k, hk1 using Nat.le_induction with
    | base => exact hbase
    | succ k hk ih =>
        have hk_le : k ≤ n := by omega
        have hacc : accum k θ = alpha j := ih hk_le
        have hk_lt_n : k < n := by omega
        have hdigit0 : digit k θ = 0 := hno k (by omega) hk_lt_n
        have hcond : ¬ alpha k ≤ θ - accum k θ := by
          by_contra hc
          have hdigit1 : digit k θ = 1 := by
            unfold digit
            simp [hc]
          rw [hdigit0] at hdigit1
          exact Nat.zero_ne_one hdigit1
        rw [show accum (k + 1) θ
            = accum k θ + (if alpha k ≤ θ - accum k θ then alpha k else 0) from rfl]
        rw [ite_eq_right hcond, hacc]
        ring
  exact hacc_from n (by omega) le_rfl

/-- **F2/O4 component converse.**  For the component whose first selected digit
is `j`, the `n`-th digit is selected exactly when `αⱼ + αₙ ≤ θ`. -/
theorem digit_one_component_iff {n j : ℕ} (hj : j < n) (hj1 : 1 ≤ j)
    {θ : ℝ} (hhi : θ < alpha (j - 1)) (hdj : digit j θ = 1)
    (hno : ∀ k, j < k → k < n → digit k θ = 0) :
    digit n θ = 1 ↔ alpha j + alpha n ≤ θ := by
  have hacc : accum n θ = alpha j :=
    accum_eq_alpha_of_first_component hj hj1 hhi hdj hno
  constructor
  · intro h
    have hsel := alpha_le_residual_of_digit_eq_one h
    rw [residual, hacc] at hsel
    linarith
  · intro h
    unfold digit
    rw [hacc]
    have hsel : alpha n ≤ θ - alpha j := by linarith
    simp [hsel]

/-- The parent cylinder of two adjacent children. -/
def parentCyl (l r : CylR) (hmid : l.hi = r.lo) : CylR :=
  ⟨l.lo, r.hi, l.hlo, r.hhi, by linarith [l.hlt, hmid, r.hlt]⟩

/-- Distinct nodes of the same partition have disjoint intervals. -/
theorem partitionR_disjoint {n : ℕ} {c d : CylR}
    (hc : c ∈ partitionR n) (hd : d ∈ partitionR n) (hne : c ≠ d) :
    Disjoint (Set.Ico c.lo c.hi) (Set.Ico d.lo d.hi) := by
  rw [Set.disjoint_left]
  intro x hx1 hx2
  exact hne (partitionR_unique n c hc d hd hx1.1 hx1.2 hx2.1 hx2.2)

/-- **Same-depth orthogonality.**  Wavelets on distinct nodes of the same
partition are orthogonal. -/
theorem integral_mul_eq_zero_of_partition_ne {n : ℕ} {l1 r1 l2 r2 : CylR}
    (hmid1 : l1.hi = r1.lo) (hmid2 : l2.hi = r2.lo)
    (hp1 : parentCyl l1 r1 hmid1 ∈ partitionR n)
    (hp2 : parentCyl l2 r2 hmid2 ∈ partitionR n)
    (hne : parentCyl l1 r1 hmid1 ≠ parentCyl l2 r2 hmid2) :
    ∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure = 0 := by
  apply integral_mul_eq_zero_of_disjoint hmid1 hmid2
  exact partitionR_disjoint hp1 hp2 hne

/-- The real cut point at depth `n`. -/
def cutR (n : ℕ) (p : CylR) : ℝ := p.lo + 1 / ((n : ℝ) + 2)

/-- Every real depth-`n+1` node is its parent or a strict child of it. -/
lemma partitionR_succ_parent {n : ℕ} {c : CylR} (hc : c ∈ partitionR (n + 1)) :
    ∃ p ∈ partitionR n,
      c = p ∨
      (c.lo = p.lo ∧ c.hi < p.hi) ∨
      (p.lo < c.lo ∧ c.hi = p.hi) := by
  simp only [partitionR, List.mem_map] at hc
  obtain ⟨d, hd, rfl⟩ := hc
  rw [show partition (n + 1) = (partition n).flatMap (splitAt n) from rfl] at hd
  obtain ⟨p, hp, hdp⟩ := List.mem_flatMap.mp hd
  refine ⟨p.toReal, List.mem_map.mpr ⟨p, hp, rfl⟩, ?_⟩
  by_cases h : p.hi ≤ cut n p
  · rw [splitAt_eq_self n p h] at hdp
    simp only [List.mem_singleton] at hdp
    subst hdp
    exact Or.inl rfl
  · rw [splitAt_eq_children n p h] at hdp
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hdp
    rcases hdp with rfl | rfl
    · have hlt : cut n p < p.hi := lt_of_not_ge h
      refine Or.inr (Or.inl ⟨rfl, ?_⟩)
      dsimp [leftChild, cutR, Cyl.toReal]
      exact_mod_cast hlt
    · have hpos : p.lo < cut n p := cut_pos n p
      refine Or.inr (Or.inr ⟨?_, rfl⟩)
      dsimp [rightChild, cutR, Cyl.toReal]
      exact_mod_cast hpos

/-- Every real depth-`n+1` node is contained in its parent. -/
lemma partitionR_succ_subset_parent {n : ℕ} {c : CylR}
    (hc : c ∈ partitionR (n + 1)) :
    ∃ p ∈ partitionR n, Set.Ico c.lo c.hi ⊆ Set.Ico p.lo p.hi := by
  obtain ⟨p, hp, h⟩ := partitionR_succ_parent hc
  refine ⟨p, hp, ?_⟩
  rcases h with rfl | ⟨hlo, hhi⟩ | ⟨hlo, hhi⟩
  · exact subset_rfl
  · intro x hx
    exact ⟨by rw [← hlo]; exact hx.1, lt_trans hx.2 hhi⟩
  · intro x hx
    exact ⟨(lt_of_lt_of_le hlo hx.1).le, by rw [← hhi]; exact hx.2⟩

/-- **Refinement.**  A node at a deeper level is either contained in a given
node or disjoint from it. -/
theorem partitionR_subset_or_disjoint {m n : ℕ} (hmn : m ≤ n) {c d : CylR}
    (hc : c ∈ partitionR n) (hd : d ∈ partitionR m) :
    Set.Ico c.lo c.hi ⊆ Set.Ico d.lo d.hi ∨
      Disjoint (Set.Ico c.lo c.hi) (Set.Ico d.lo d.hi) := by
  induction hmn generalizing c with
  | refl =>
      by_cases hcd : c = d
      · exact Or.inl (by rw [hcd])
      · exact Or.inr (partitionR_disjoint hc hd hcd)
  | step hmn ih =>
      obtain ⟨p, hp, hsub⟩ := partitionR_succ_subset_parent hc
      rcases ih hp with hpd | hdisj
      · exact Or.inl (Set.Subset.trans hsub hpd)
      · exact Or.inr (hdisj.mono_left hsub)

/-- If a deeper node is not disjoint from a shallower one, it is contained in it. -/
theorem partitionR_subset_of_not_disjoint {m n : ℕ} (hmn : m ≤ n) {c d : CylR}
    (hc : c ∈ partitionR n) (hd : d ∈ partitionR m)
    (h : ¬ Disjoint (Set.Ico c.lo c.hi) (Set.Ico d.lo d.hi)) :
    Set.Ico c.lo c.hi ⊆ Set.Ico d.lo d.hi :=
  (partitionR_subset_or_disjoint hmn hc hd).resolve_right h

/-- Same-depth containment forces equality. -/
theorem partitionR_eq_of_subset {n : ℕ} {c d : CylR}
    (hc : c ∈ partitionR n) (hd : d ∈ partitionR n)
    (hsub : Set.Ico c.lo c.hi ⊆ Set.Ico d.lo d.hi) : c = d := by
  by_contra hne
  have hdisj := partitionR_disjoint hc hd hne
  have hx : c.lo ∈ Set.Ico c.lo c.hi := ⟨le_rfl, c.hlt⟩
  exact (Set.disjoint_left.mp hdisj) hx (hsub hx)

/-- **Tree order.**  Any two real partition nodes (at any depths) are either
disjoint, or one is contained in the other. -/
theorem partitionR_disjoint_or_subset {m n : ℕ} {c d : CylR}
    (hc : c ∈ partitionR n) (hd : d ∈ partitionR m) :
    Disjoint (Set.Ico c.lo c.hi) (Set.Ico d.lo d.hi) ∨
      Set.Ico c.lo c.hi ⊆ Set.Ico d.lo d.hi ∨
      Set.Ico d.lo d.hi ⊆ Set.Ico c.lo c.hi := by
  rcases le_total m n with hmn | hnm
  · rcases partitionR_subset_or_disjoint hmn hc hd with hsub | hdisj
    · exact Or.inr (Or.inl hsub)
    · exact Or.inl hdisj
  · rcases partitionR_subset_or_disjoint hnm hd hc with hsub | hdisj
    · exact Or.inr (Or.inr hsub)
    · exact Or.inl hdisj.symm

lemma cut_cast (n : ℕ) (p : Cyl) : ((cut n p : ℚ) : ℝ) = cutR n p.toReal := by
  simp [cut, cutR, Cyl.toReal]

/-- Exact child-or-self form of the real refinement. -/
lemma partitionR_succ_child_or_self {n : ℕ} {c : CylR}
    (hc : c ∈ partitionR (n + 1)) :
    ∃ p ∈ partitionR n,
      c = p ∨
      (c.lo = p.lo ∧ c.hi = cutR n p ∧ cutR n p < p.hi) ∨
      (p.lo < cutR n p ∧ c.lo = cutR n p ∧ c.hi = p.hi) := by
  simp only [partitionR, List.mem_map] at hc
  obtain ⟨d, hd, rfl⟩ := hc
  rw [show partition (n + 1) = (partition n).flatMap (splitAt n) from rfl] at hd
  obtain ⟨p, hp, hdp⟩ := List.mem_flatMap.mp hd
  refine ⟨p.toReal, List.mem_map.mpr ⟨p, hp, rfl⟩, ?_⟩
  by_cases h : p.hi ≤ cut n p
  · rw [splitAt_eq_self n p h] at hdp
    simp only [List.mem_singleton] at hdp
    subst hdp
    exact Or.inl rfl
  · rw [splitAt_eq_children n p h] at hdp
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hdp
    rcases hdp with rfl | rfl
    · have hlt : cut n p < p.hi := lt_of_not_ge h
      refine Or.inr (Or.inl ⟨rfl, ?_, ?_⟩)
      · change ((cut n p : ℚ) : ℝ) = cutR n p.toReal
        exact cut_cast n p
      · rw [← cut_cast n p]
        change ((cut n p : ℚ) : ℝ) < ((p.hi : ℚ) : ℝ)
        exact_mod_cast hlt
    · have hpos : p.lo < cut n p := cut_pos n p
      refine Or.inr (Or.inr ⟨?_, ?_, rfl⟩)
      · rw [← cut_cast n p]
        change ((p.lo : ℚ) : ℝ) < ((cut n p : ℚ) : ℝ)
        exact_mod_cast hpos
      · change ((cut n p : ℚ) : ℝ) = cutR n p.toReal
        exact cut_cast n p

/-- **One-step child containment.**  A depth-`n+1` node contained in a depth-`n`
node is either that node or lies in one of its two children. -/
theorem partitionR_succ_subset_child_or_eq {n : ℕ} {c d : CylR}
    (hc : c ∈ partitionR (n + 1)) (hd : d ∈ partitionR n)
    (hsub : Set.Ico c.lo c.hi ⊆ Set.Ico d.lo d.hi) :
    c = d ∨
      Set.Ico c.lo c.hi ⊆ Set.Ico d.lo (cutR n d) ∨
      Set.Ico c.lo c.hi ⊆ Set.Ico (cutR n d) d.hi := by
  obtain ⟨p, hp, hcase⟩ := partitionR_succ_child_or_self hc
  have hsubp : Set.Ico c.lo c.hi ⊆ Set.Ico p.lo p.hi := by
    rcases hcase with rfl | ⟨hlo, hhi, hlt⟩ | ⟨hpos, hlo, hhi⟩
    · exact subset_rfl
    · intro x hx
      exact ⟨by rw [← hlo]; exact hx.1,
        lt_trans hx.2 (by rw [hhi]; exact hlt)⟩
    · intro x hx
      exact ⟨(lt_of_lt_of_le hpos (by rw [← hlo]; exact hx.1)).le,
        by rw [← hhi]; exact hx.2⟩
  have hx : c.lo ∈ Set.Ico c.lo c.hi := ⟨le_rfl, c.hlt⟩
  have hx_p := hsubp hx
  have hx_d := hsub hx
  have hpd : p = d :=
    partitionR_unique n p hp d hd hx_p.1 hx_p.2 hx_d.1 hx_d.2
  subst hpd
  rcases hcase with rfl | ⟨hlo, hhi, _⟩ | ⟨_, hlo, hhi⟩
  · exact Or.inl rfl
  · exact Or.inr (Or.inl (by intro x hx; exact ⟨by rw [← hlo]; exact hx.1, by rw [← hhi]; exact hx.2⟩))
  · exact Or.inr (Or.inr (by intro x hx; exact ⟨by rw [← hlo]; exact hx.1, by rw [← hhi]; exact hx.2⟩))




/-- The two child intervals of a split at `cutR n d` are disjoint. -/
theorem child_intervals_disjoint (n : ℕ) (d : CylR) :
    Disjoint (Set.Ico d.lo (cutR n d)) (Set.Ico (cutR n d) d.hi) := by
  rw [Set.disjoint_left]
  intro x hx1 hx2
  linarith [hx1.2, hx2.1]
lemma Cyl_toReal_injective : Function.Injective Cyl.toReal := by
  intro a b h
  have hlo : a.lo = b.lo := by
    have := congrArg CylR.lo h
    simpa [Cyl.toReal] using this
  have hhi : a.hi = b.hi := by
    have := congrArg CylR.hi h
    simpa [Cyl.toReal] using this
  cases a
  cases b
  simp_all

lemma splitAt_subset {n : ℕ} {r p : Cyl} (hp : p ∈ splitAt n r) :
    r.lo ≤ p.lo ∧ p.hi ≤ r.hi := by
  by_cases h : r.hi ≤ cut n r
  · rw [splitAt_eq_self n r h] at hp
    simp only [List.mem_singleton] at hp
    subst hp
    exact ⟨le_rfl, le_rfl⟩
  · rw [splitAt_eq_children n r h] at hp
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hp
    rcases hp with rfl | rfl
    · exact ⟨le_rfl, le_of_lt (lt_of_not_ge h)⟩
    · exact ⟨le_of_lt (cut_pos n r), le_rfl⟩

lemma partition_mem_succ_unsplit {n : ℕ} {p : Cyl}
    (hp : p ∈ partition n) (hp1 : p ∈ partition (n + 1)) :
    p.hi ≤ cut n p := by
  by_contra h
  rw [show partition (n + 1) = (partition n).flatMap (splitAt n) from rfl] at hp1
  obtain ⟨r, hr, hpr⟩ := List.mem_flatMap.mp hp1
  have hsub := splitAt_subset hpr
  have hrp : r = p :=
    partition_unique n r hr p hp hsub.1 (lt_of_lt_of_le p.hlt hsub.2) le_rfl p.hlt
  rw [hrp] at hpr
  rw [splitAt_eq_children n p h] at hpr
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hpr
  rcases hpr with hleft | hright
  · have : p.hi = cut n p := by simpa [leftChild] using congrArg Cyl.hi hleft
    linarith [lt_of_not_ge h]
  · have : p.lo = cut n p := by simpa [rightChild] using congrArg Cyl.lo hright
    linarith [cut_pos n p]

/-- **Split-node persistence.**  A node present at two consecutive depths is
unsplit at the earlier depth. -/
theorem partitionR_persist_unsplit {n : ℕ} {d : CylR}
    (hd : d ∈ partitionR n) (hd1 : d ∈ partitionR (n + 1)) :
    d.hi ≤ cutR n d := by
  simp only [partitionR, List.mem_map] at hd hd1
  obtain ⟨p, hp, rfl⟩ := hd
  obtain ⟨q, hq, hqeq⟩ := hd1
  have hqp : q = p := Cyl_toReal_injective hqeq
  rw [hqp] at hq
  have hp1 : p ∈ partition (n + 1) := hq
  have hunsplit : p.hi ≤ cut n p := partition_mem_succ_unsplit hp hp1
  change ((p.hi : ℚ) : ℝ) ≤ cutR n p.toReal
  rw [← cut_cast n p]
  exact_mod_cast hunsplit

lemma subset_of_child_or_self {n : ℕ} {c q : CylR}
    (h : c = q ∨
      (c.lo = q.lo ∧ c.hi = cutR n q ∧ cutR n q < q.hi) ∨
      (q.lo < cutR n q ∧ c.lo = cutR n q ∧ c.hi = q.hi)) :
    Set.Ico c.lo c.hi ⊆ Set.Ico q.lo q.hi := by
  rcases h with rfl | ⟨hlo, hhi, hlt⟩ | ⟨hpos, hlo, hhi⟩
  · exact subset_rfl
  · intro x hx
    exact ⟨by rw [← hlo]; exact hx.1,
      lt_trans hx.2 (by rw [hhi]; exact hlt)⟩
  · intro x hx
    exact ⟨(lt_of_lt_of_le hpos (by rw [← hlo]; exact hx.1)).le,
      by rw [← hhi]; exact hx.2⟩

/-- **Membership monotonicity.**  A node present at depths `m < n` is already
present at depth `m + 1`. -/
theorem partitionR_mem_succ_of_mem_of_lt {m n : ℕ} (hmn : m < n) {d : CylR}
    (hdm : d ∈ partitionR m) (hdn : d ∈ partitionR n) :
    d ∈ partitionR (m + 1) := by
  have hmn' : m + 1 ≤ n := Nat.succ_le_of_lt hmn
  induction n, hmn' using Nat.le_induction with
  | base => exact hdn
  | succ n hmn ih =>
      obtain ⟨q, hq, hcase⟩ := partitionR_succ_child_or_self hdn
      have hsubdq : Set.Ico d.lo d.hi ⊆ Set.Ico q.lo q.hi :=
        subset_of_child_or_self hcase
      by_cases hqeq : q = d
      · rw [hqeq] at hq
        exact ih (by omega) hq
      · exfalso
        have hnot : ¬ Disjoint (Set.Ico q.lo q.hi) (Set.Ico d.lo d.hi) := by
          intro hdisj
          have hxq : d.lo ∈ Set.Ico q.lo q.hi := hsubdq ⟨le_rfl, d.hlt⟩
          have hxd : d.lo ∈ Set.Ico d.lo d.hi := ⟨le_rfl, d.hlt⟩
          exact (Set.disjoint_left.mp hdisj) hxq hxd
        have hqd : Set.Ico q.lo q.hi ⊆ Set.Ico d.lo d.hi :=
          partitionR_subset_of_not_disjoint (by omega) hq hdm hnot
        have hqlo : d.lo ≤ q.lo := ((Set.Ico_subset_Ico_iff q.hlt).mp hqd).1
        have hqhi : q.hi ≤ d.hi := ((Set.Ico_subset_Ico_iff q.hlt).mp hqd).2
        have hdlo : q.lo ≤ d.lo := ((Set.Ico_subset_Ico_iff d.hlt).mp hsubdq).1
        have hdhi : d.hi ≤ q.hi := ((Set.Ico_subset_Ico_iff d.hlt).mp hsubdq).2
        have hlo : q.lo = d.lo := le_antisymm hdlo hqlo
        have hhi : q.hi = d.hi := le_antisymm hqhi hdhi
        apply hqeq
        cases q
        cases d
        simp_all

/-- A node that splits at depth `m` does not appear at any deeper depth. -/
theorem partitionR_not_mem_of_splits {m n : ℕ} (hmn : m < n) {d : CylR}
    (hdm : d ∈ partitionR m) (hs : cutR m d < d.hi) :
    d ∉ partitionR n := by
  intro hdn
  have hdm1 : d ∈ partitionR (m + 1) :=
    partitionR_mem_succ_of_mem_of_lt hmn hdm hdn
  have hunsplit : d.hi ≤ cutR m d := partitionR_persist_unsplit hdm hdm1
  linarith

/-- **Arbitrary-depth child containment.**  A deeper node inside a splitting
shallower node lies in its left or right child. -/
theorem partitionR_subset_child_of_lt {m n : ℕ} (hmn : m < n) {c d : CylR}
    (hc : c ∈ partitionR n) (hd : d ∈ partitionR m)
    (hdsplit : cutR m d < d.hi)
    (hsub : Set.Ico c.lo c.hi ⊆ Set.Ico d.lo d.hi) :
    Set.Ico c.lo c.hi ⊆ Set.Ico d.lo (cutR m d) ∨
      Set.Ico c.lo c.hi ⊆ Set.Ico (cutR m d) d.hi := by
  revert c
  have hmn' : m + 1 ≤ n := Nat.succ_le_of_lt hmn
  induction n, hmn' using Nat.le_induction with
  | base =>
      intro c hc hsub
      rcases partitionR_succ_subset_child_or_eq hc hd hsub with hcd | hleft | hright
      · exact False.elim
          (partitionR_not_mem_of_splits (n := m + 1) (Nat.lt_succ_self m) hd hdsplit
            (by simpa [hcd] using hc))
      · exact Or.inl hleft
      · exact Or.inr hright
  | succ n hmn ih =>
      intro c hc hsub
      obtain ⟨q, hq, hcase⟩ := partitionR_succ_child_or_self hc
      have hsubq : Set.Ico c.lo c.hi ⊆ Set.Ico q.lo q.hi :=
        subset_of_child_or_self hcase
      have hx : c.lo ∈ Set.Ico c.lo c.hi := ⟨le_rfl, c.hlt⟩
      have hxq := hsubq hx
      have hxd := hsub hx
      have hnot : ¬ Disjoint (Set.Ico q.lo q.hi) (Set.Ico d.lo d.hi) := by
        intro hdisj
        exact (Set.disjoint_left.mp hdisj) hxq hxd
      have hqd : Set.Ico q.lo q.hi ⊆ Set.Ico d.lo d.hi :=
        partitionR_subset_of_not_disjoint (by omega) hq hd hnot
      by_cases hqeq : q = d
      · exact False.elim
          (partitionR_not_mem_of_splits (n := n) (by omega) hd hdsplit
            (by simpa [hqeq] using hq))
      · rcases ih (by omega) hq hqd with hleft | hright
        · exact Or.inl (Set.Subset.trans hsubq hleft)
        · exact Or.inr (Set.Subset.trans hsubq hright)

/-- **Pairwise orthogonality from the four local cases.**  If two Haar parents
are disjoint, or one lies in a child of the other, the wavelets are orthogonal. -/
theorem integral_mul_eq_zero_of_haar_cases {l1 r1 l2 r2 : CylR}
    (hmid1 : l1.hi = r1.lo) (hmid2 : l2.hi = r2.lo)
    (hl1 : 0 < l1.length) (hr1 : 0 < r1.length)
    (hl2 : 0 < l2.length) (hr2 : 0 < r2.length)
    (h : Disjoint (Set.Ico l1.lo r1.hi) (Set.Ico l2.lo r2.hi) ∨
      Set.Ico l1.lo r1.hi ⊆ Set.Ico l2.lo l2.hi ∨
      Set.Ico l1.lo r1.hi ⊆ Set.Ico r2.lo r2.hi ∨
      Set.Ico l2.lo r2.hi ⊆ Set.Ico l1.lo l1.hi ∨
      Set.Ico l2.lo r2.hi ⊆ Set.Ico r1.lo r1.hi) :
    ∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure = 0 := by
  rcases h with hdisj | hleft | hright | hleft' | hright'
  · exact integral_mul_eq_zero_of_disjoint hmid1 hmid2 hdisj
  · exact integral_mul_eq_zero_of_subset_left hmid1 hmid2 hl1 hr1 hleft
  · exact integral_mul_eq_zero_of_subset_right hmid1 hmid2 hl1 hr1 hright
  · have h' := integral_mul_eq_zero_of_subset_left hmid2 hmid1 hl2 hr2 hleft'
    simpa only [id_eq, mul_comm] using h'
  · have h' := integral_mul_eq_zero_of_subset_right hmid2 hmid1 hl2 hr2 hright'
    simpa only [id_eq, mul_comm] using h'

lemma CylR_eq_of_subset_both {a b : CylR}
    (hab : Set.Ico a.lo a.hi ⊆ Set.Ico b.lo b.hi)
    (hba : Set.Ico b.lo b.hi ⊆ Set.Ico a.lo a.hi) : a = b := by
  have h1 := (Set.Ico_subset_Ico_iff a.hlt).mp hab
  have h2 := (Set.Ico_subset_Ico_iff b.hlt).mp hba
  have hlo : a.lo = b.lo := le_antisymm h2.1 h1.1
  have hhi : a.hi = b.hi := le_antisymm h1.2 h2.2
  cases a
  cases b
  simp_all

/-- **General pairwise orthogonality.**  Wavelets whose parents are partition
nodes, with the split point matching the partition cut, are orthogonal unless
they are the same parent. -/
theorem integral_mul_eq_zero_of_partition_parents {n1 n2 : ℕ}
    {l1 r1 l2 r2 : CylR} (hmid1 : l1.hi = r1.lo) (hmid2 : l2.hi = r2.lo)
    (hp1 : parentCyl l1 r1 hmid1 ∈ partitionR n1)
    (hp2 : parentCyl l2 r2 hmid2 ∈ partitionR n2)
    (hcut1 : l1.hi = cutR n1 (parentCyl l1 r1 hmid1))
    (hcut2 : l2.hi = cutR n2 (parentCyl l2 r2 hmid2))
    (hne : parentCyl l1 r1 hmid1 ≠ parentCyl l2 r2 hmid2) :
    ∫ x, haarFun l1 r1 x * haarFun l2 r2 x ∂unitMeasure = 0 := by
  let p1 := parentCyl l1 r1 hmid1
  let p2 := parentCyl l2 r2 hmid2
  have hcut1' : cutR n1 p1 = l1.hi := by simpa [p1, parentCyl] using hcut1.symm
  have hcut2' : cutR n2 p2 = l2.hi := by simpa [p2, parentCyl] using hcut2.symm
  have split1 : cutR n1 p1 < p1.hi := by
    rw [hcut1']
    dsimp [p1, parentCyl]
    rw [hmid1]
    exact r1.hlt
  have split2 : cutR n2 p2 < p2.hi := by
    rw [hcut2']
    dsimp [p2, parentCyl]
    rw [hmid2]
    exact r2.hlt
  refine integral_mul_eq_zero_of_haar_cases hmid1 hmid2
    (sub_pos.mpr l1.hlt) (sub_pos.mpr r1.hlt)
    (sub_pos.mpr l2.hlt) (sub_pos.mpr r2.hlt) ?_
  rcases partitionR_disjoint_or_subset hp1 hp2 with hdisj | hsub12 | hsub21
  · exact Or.inl hdisj
  · rcases lt_trichotomy n1 n2 with hlt | heq | hgt
    · exfalso
      have hnot : ¬ Disjoint (Set.Ico p2.lo p2.hi) (Set.Ico p1.lo p1.hi) := by
        intro hdisj
        have hx : p1.lo ∈ Set.Ico p1.lo p1.hi := ⟨le_rfl, p1.hlt⟩
        exact (Set.disjoint_left.mp hdisj) (hsub12 hx) hx
      have h21 : Set.Ico p2.lo p2.hi ⊆ Set.Ico p1.lo p1.hi :=
        partitionR_subset_of_not_disjoint (le_of_lt hlt) hp2 hp1 hnot
      exact hne (CylR_eq_of_subset_both hsub12 h21)
    · subst heq
      exact False.elim (hne (partitionR_eq_of_subset hp1 hp2 hsub12))
    · have hch := partitionR_subset_child_of_lt hgt hp1 hp2 split2 hsub12
      rcases hch with hl | hr
      · refine Or.inr (Or.inl ?_)
        rw [← hcut2']
        exact hl
      · refine Or.inr (Or.inr (Or.inl ?_))
        change Set.Ico l1.lo r1.hi ⊆ Set.Ico (cutR n2 p2) r2.hi at hr
        rw [hcut2', hmid2] at hr
        exact hr
  · rcases lt_trichotomy n2 n1 with hlt | heq | hgt
    · exfalso
      have hnot : ¬ Disjoint (Set.Ico p1.lo p1.hi) (Set.Ico p2.lo p2.hi) := by
        intro hdisj
        have hx : p2.lo ∈ Set.Ico p2.lo p2.hi := ⟨le_rfl, p2.hlt⟩
        exact (Set.disjoint_left.mp hdisj) (hsub21 hx) hx
      have h12 : Set.Ico p1.lo p1.hi ⊆ Set.Ico p2.lo p2.hi :=
        partitionR_subset_of_not_disjoint (le_of_lt hlt) hp1 hp2 hnot
      exact hne (CylR_eq_of_subset_both h12 hsub21)
    · subst heq
      exact False.elim (hne (partitionR_eq_of_subset hp2 hp1 hsub21).symm)
    · have hch := partitionR_subset_child_of_lt hgt hp2 hp1 split1 hsub21
      rcases hch with hl | hr
      · refine Or.inr (Or.inr (Or.inr (Or.inl ?_)))
        change Set.Ico l2.lo r2.hi ⊆ Set.Ico l1.lo (cutR n1 p1) at hl
        rw [hcut1'] at hl
        exact hl
      · refine Or.inr (Or.inr (Or.inr (Or.inr ?_)))
        change Set.Ico l2.lo r2.hi ⊆ Set.Ico (cutR n1 p1) p1.hi at hr
        rw [hcut1', hmid1] at hr
        exact hr

lemma cylInd_root_apply {x : ℝ} (hx : x ∈ Set.Ico (0 : ℝ) 1) :
    cylInd rootCyl.toReal x = 1 := by
  unfold cylInd cylSet
  rw [Set.indicator_of_mem]
  simpa [rootCyl, Cyl.toReal] using hx

/-- The root indicator has unit `L²` norm. -/
theorem integral_root_sq :
    ∫ x, (cylInd rootCyl.toReal x) ^ 2 ∂unitMeasure = 1 := by
  calc
    ∫ x, (cylInd rootCyl.toReal x) ^ 2 ∂unitMeasure
        = ∫ x, cylInd rootCyl.toReal x ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards [ae_restrict_mem measurableSet_Ico] with x hx
          rw [cylInd_root_apply hx]
          ring
    _ = 1 := by
      rw [integral_cylInd]
      norm_num [rootCyl, Cyl.toReal, CylR.length]

/-- The root indicator is orthogonal to every normalised wavelet. -/
theorem integral_root_mul_haarFun {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    ∫ x, cylInd rootCyl.toReal x * haarFun l r x ∂unitMeasure = 0 := by
  calc
    ∫ x, cylInd rootCyl.toReal x * haarFun l r x ∂unitMeasure
        = ∫ x, haarFun l r x ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards [ae_restrict_mem measurableSet_Ico] with x hx
          rw [cylInd_root_apply hx, one_mul]
    _ = 0 := integral_haarFun_eq_zero hl hr

/-- Every normalised generator is the root indicator or a wavelet at some
partition node below the depth. -/
lemma haarGensNorm_cases {N : ℕ} {f : ℝ → ℝ} (hf : f ∈ haarGensNorm N) :
    f = cylInd rootCyl.toReal ∨
    ∃ k, k < N ∧ ∃ p ∈ partition k, ∃ h : ¬ p.hi ≤ cut k p,
      f = haarFun (leftChild k p h).toReal (rightChild k p h).toReal := by
  induction N with
  | zero =>
      simp [haarGensNorm] at hf
      subst hf
      exact Or.inl rfl
  | succ N ih =>
      simp only [haarGensNorm, Set.mem_union] at hf
      rcases hf with hf | hf
      · rcases ih hf with hroot | ⟨k, hk, p, hp, h, hf'⟩
        · exact Or.inl hroot
        · exact Or.inr ⟨k, Nat.lt_succ_of_lt hk, p, hp, h, hf'⟩
      · simp only [haarDiffAtNorm, Set.mem_ofPred_eq] at hf
        obtain ⟨p, hp, h, rfl⟩ := hf
        exact Or.inr ⟨N, Nat.lt_succ_self N, p, hp, h, rfl⟩

lemma leftChild_toReal_length_pos (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) :
    0 < (leftChild n p h).toReal.length := by
  simp [CylR.length, leftChild, Cyl.toReal, cut]
  positivity

lemma rightChild_toReal_length_pos (n : ℕ) (p : Cyl) (h : ¬ p.hi ≤ cut n p) :
    0 < (rightChild n p h).toReal.length := by
  simp [CylR.length, rightChild, Cyl.toReal]
  have hlt : cut n p < p.hi := lt_of_not_ge h
  linarith

/-- Every normalised generator has unit `L²` norm. -/
theorem haarGensNorm_unit (N : ℕ) {f : ℝ → ℝ} (hf : f ∈ haarGensNorm N) :
    ∫ x, (f x) ^ 2 ∂unitMeasure = 1 := by
  rcases haarGensNorm_cases hf with rfl | ⟨k, _hk, p, _hp, h, rfl⟩
  · exact integral_root_sq
  · have hmid : (leftChild k p h).toReal.hi = (rightChild k p h).toReal.lo := by
      change ((cut k p : ℚ) : ℝ) = ((cut k p : ℚ) : ℝ)
      rfl
    exact integral_haarFun_sq hmid
      (leftChild_toReal_length_pos k p h)
      (rightChild_toReal_length_pos k p h)

/-- Parent data for a normalised wavelet generator. -/
lemma haarDiffAtNorm_parent_data {k : ℕ} {f : ℝ → ℝ}
    (hf : f ∈ haarDiffAtNorm k) :
    ∃ (p : Cyl) (_hp : p ∈ partition k) (_h : ¬ p.hi ≤ cut k p)
      (l r : CylR) (hmid : l.hi = r.lo),
      f = haarFun l r ∧ parentCyl l r hmid = p.toReal ∧
        l.hi = cutR k p.toReal := by
  rcases hf with ⟨p, hp, h, rfl⟩
  refine ⟨p, hp, h, (leftChild k p h).toReal, (rightChild k p h).toReal, ?_, rfl, ?_, ?_⟩
  · change ((cut k p : ℚ) : ℝ) = ((cut k p : ℚ) : ℝ)
    rfl
  · cases p
    rfl
  · change ((cut k p : ℚ) : ℝ) = cutR k p.toReal
    exact cut_cast k p

/-- The root indicator is distinct from every normalised wavelet. -/
theorem root_ne_haarFun {l r : CylR} (hl : 0 < l.length) (hr : 0 < r.length) :
    cylInd rootCyl.toReal ≠ haarFun l r := by
  intro h
  have h1 : ∫ x, cylInd rootCyl.toReal x ∂unitMeasure = 1 := by
    rw [integral_cylInd]
    norm_num [rootCyl, Cyl.toReal, CylR.length]
  have h2 : ∫ x, haarFun l r x ∂unitMeasure = 0 := integral_haarFun_eq_zero hl hr
  have hcongr := congrArg (fun f : ℝ → ℝ => ∫ x, f x ∂unitMeasure) h
  simp [h1, h2] at hcongr

lemma wavelet_parent_split_of_data {k : ℕ} {p : Cyl} {l r : CylR} {hmid : l.hi = r.lo}
    (hpar : parentCyl l r hmid = p.toReal)
    (hcut : l.hi = cutR k p.toReal) :
    cutR k p.toReal < p.toReal.hi := by
  have hhi : p.toReal.hi = r.hi := (congrArg CylR.hi hpar).symm
  rw [← hcut, hhi, hmid]
  exact r.hlt

/-- Two normalised wavelets with the same parent interval are equal. -/
lemma haarFun_eq_of_parent_eq {k j : ℕ} {p q : Cyl}
    {l1 r1 l2 r2 : CylR} {hmid1 : l1.hi = r1.lo} {hmid2 : l2.hi = r2.lo}
    (hp : p ∈ partition k) (hq : q ∈ partition j)
    (hpar1 : parentCyl l1 r1 hmid1 = p.toReal)
    (hpar2 : parentCyl l2 r2 hmid2 = q.toReal)
    (hcut1 : l1.hi = cutR k p.toReal)
    (hcut2 : l2.hi = cutR j q.toReal)
    (hpq : p.toReal = q.toReal) :
    haarFun l1 r1 = haarFun l2 r2 := by
  have split1 : cutR k p.toReal < p.toReal.hi :=
    wavelet_parent_split_of_data hpar1 hcut1
  have split2 : cutR j q.toReal < q.toReal.hi :=
    wavelet_parent_split_of_data hpar2 hcut2
  have hk : k = j := by
    by_contra hne
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · have hpR : p.toReal ∈ partitionR k := List.mem_map.mpr ⟨p, hp, rfl⟩
      have hnot : p.toReal ∉ partitionR j :=
        partitionR_not_mem_of_splits hlt hpR split1
      have hqR : q.toReal ∈ partitionR j := List.mem_map.mpr ⟨q, hq, rfl⟩
      have : p.toReal ∈ partitionR j := by rwa [← hpq] at hqR
      exact hnot this
    · have hqR : q.toReal ∈ partitionR j := List.mem_map.mpr ⟨q, hq, rfl⟩
      have hnot : q.toReal ∉ partitionR k :=
        partitionR_not_mem_of_splits hgt hqR split2
      have hpR : p.toReal ∈ partitionR k := List.mem_map.mpr ⟨p, hp, rfl⟩
      have : q.toReal ∈ partitionR k := by rwa [hpq] at hpR
      exact hnot this
  subst hk
  have hpqC : p = q := Cyl_toReal_injective hpq
  subst hpqC
  have hl_lo : l1.lo = l2.lo := by
    have h1 := congrArg CylR.lo hpar1
    have h2 := congrArg CylR.lo hpar2
    exact h1.trans h2.symm
  have hl_hi : l1.hi = l2.hi := hcut1.trans hcut2.symm
  have hr_lo : r1.lo = r2.lo := hmid1.symm.trans (hl_hi.trans hmid2)
  have hr_hi : r1.hi = r2.hi := by
    have h1 := congrArg CylR.hi hpar1
    have h2 := congrArg CylR.hi hpar2
    exact h1.trans h2.symm
  have hl : l1 = l2 := by cases l1; cases l2; simp_all
  have hr : r1 = r2 := by cases r1; cases r2; simp_all
  rw [hl, hr]

/-- **Generator orthogonality.**  Distinct normalised generators are orthogonal. -/
theorem haarGensNorm_orthogonal (N : ℕ) {f g : ℝ → ℝ}
    (hf : f ∈ haarGensNorm N) (hg : g ∈ haarGensNorm N) (hne : f ≠ g) :
    ∫ x, f x * g x ∂unitMeasure = 0 := by
  rcases haarGensNorm_cases hf with rfl | ⟨k, _hk, p, hp, h1, rfl⟩
  · rcases haarGensNorm_cases hg with rfl | ⟨j, _hj, q, hq, h2, rfl⟩
    · exact (hne rfl).elim
    · exact integral_root_mul_haarFun
        (leftChild_toReal_length_pos j q h2)
        (rightChild_toReal_length_pos j q h2)
  · rcases haarGensNorm_cases hg with rfl | ⟨j, _hj, q, hq, h2, rfl⟩
    · have h := integral_root_mul_haarFun
        (leftChild_toReal_length_pos k p h1)
        (rightChild_toReal_length_pos k p h1)
      simpa only [id_eq, mul_comm] using h
    · have hm1 : (leftChild k p h1).toReal.hi = (rightChild k p h1).toReal.lo := by
        change ((cut k p : ℚ) : ℝ) = ((cut k p : ℚ) : ℝ)
        rfl
      have hm2 : (leftChild j q h2).toReal.hi = (rightChild j q h2).toReal.lo := by
        change ((cut j q : ℚ) : ℝ) = ((cut j q : ℚ) : ℝ)
        rfl
      have hpar1 : parentCyl (leftChild k p h1).toReal (rightChild k p h1).toReal hm1
          = p.toReal := by
        cases p
        rfl
      have hpar2 : parentCyl (leftChild j q h2).toReal (rightChild j q h2).toReal hm2
          = q.toReal := by
        cases q
        rfl
      have hcut1 : (leftChild k p h1).toReal.hi = cutR k p.toReal := by
        change ((cut k p : ℚ) : ℝ) = cutR k p.toReal
        exact cut_cast k p
      have hcut2 : (leftChild j q h2).toReal.hi = cutR j q.toReal := by
        change ((cut j q : ℚ) : ℝ) = cutR j q.toReal
        exact cut_cast j q
      by_cases hpq : p.toReal = q.toReal
      · exact (hne (haarFun_eq_of_parent_eq hp hq hpar1 hpar2 hcut1 hcut2 hpq)).elim
      · have hp1 : parentCyl (leftChild k p h1).toReal (rightChild k p h1).toReal hm1
            ∈ partitionR k := by
          rw [hpar1]
          exact List.mem_map.mpr ⟨p, hp, rfl⟩
        have hp2 : parentCyl (leftChild j q h2).toReal (rightChild j q h2).toReal hm2
            ∈ partitionR j := by
          rw [hpar2]
          exact List.mem_map.mpr ⟨q, hq, rfl⟩
        have hc1 : (leftChild k p h1).toReal.hi
            = cutR k (parentCyl (leftChild k p h1).toReal (rightChild k p h1).toReal hm1) := by
          rw [hpar1]
          exact hcut1
        have hc2 : (leftChild j q h2).toReal.hi
            = cutR j (parentCyl (leftChild j q h2).toReal (rightChild j q h2).toReal hm2) := by
          rw [hpar2]
          exact hcut2
        have hpq' : parentCyl (leftChild k p h1).toReal (rightChild k p h1).toReal hm1
            ≠ parentCyl (leftChild j q h2).toReal (rightChild j q h2).toReal hm2 := by
          rw [hpar1, hpar2]
          exact hpq
        exact integral_mul_eq_zero_of_partition_parents hm1 hm2 hp1 hp2 hc1 hc2 hpq'


/-- **Two-term isometry step.**  The sum of two orthogonal unit vectors has
squared norm `2`. -/
theorem integral_add_sq_of_orthonormal {f g : ℝ → ℝ}
    (hff : Integrable (fun x => f x * f x) unitMeasure)
    (hgg : Integrable (fun x => g x * g x) unitMeasure)
    (hfg : Integrable (fun x => f x * g x) unitMeasure)
    (hf : ∫ x, f x * f x ∂unitMeasure = 1)
    (hg : ∫ x, g x * g x ∂unitMeasure = 1)
    (horth : ∫ x, f x * g x ∂unitMeasure = 0) :
    ∫ x, (f x + g x) ^ 2 ∂unitMeasure = 2 := by
  have h2fg : Integrable (fun x => 2 * (f x * g x)) unitMeasure := hfg.const_mul 2
  have hsum : Integrable (fun x => f x * f x + 2 * (f x * g x)) unitMeasure :=
    hff.add h2fg
  calc
    ∫ x, (f x + g x) ^ 2 ∂unitMeasure
        = ∫ x, (f x * f x + 2 * (f x * g x) + g x * g x) ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards with x
          ring
    _ = ∫ x, (f x * f x + 2 * (f x * g x)) ∂unitMeasure
          + ∫ x, g x * g x ∂unitMeasure := by
          rw [integral_add hsum hgg]
    _ = (∫ x, f x * f x ∂unitMeasure + ∫ x, 2 * (f x * g x) ∂unitMeasure)
          + ∫ x, g x * g x ∂unitMeasure := by
          rw [integral_add hff h2fg]
    _ = (1 + 2 * 0) + 1 := by
          rw [integral_const_mul, hf, horth, hg]
    _ = 2 := by norm_num

/-- **Scaled two-term isometry.**  For orthogonal unit `f, g`, the combination
`a f + b g` has squared norm `a² + b²`. -/
theorem integral_add_scaled_sq {a b : ℝ} {f g : ℝ → ℝ}
    (hff : Integrable (fun x => f x * f x) unitMeasure)
    (hgg : Integrable (fun x => g x * g x) unitMeasure)
    (hfg : Integrable (fun x => f x * g x) unitMeasure)
    (hf : ∫ x, f x * f x ∂unitMeasure = 1)
    (hg : ∫ x, g x * g x ∂unitMeasure = 1)
    (horth : ∫ x, f x * g x ∂unitMeasure = 0) :
    ∫ x, (a * f x + b * g x) ^ 2 ∂unitMeasure = a ^ 2 + b ^ 2 := by
  have h1 : Integrable (fun x => a ^ 2 * (f x * f x)) unitMeasure := hff.const_mul _
  have h2 : Integrable (fun x => 2 * a * b * (f x * g x)) unitMeasure := hfg.const_mul _
  have h3 : Integrable (fun x => b ^ 2 * (g x * g x)) unitMeasure := hgg.const_mul _
  calc
    ∫ x, (a * f x + b * g x) ^ 2 ∂unitMeasure
        = ∫ x, (a ^ 2 * (f x * f x) + 2 * a * b * (f x * g x)
            + b ^ 2 * (g x * g x)) ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards with x
          ring
    _ = ∫ x, (a ^ 2 * (f x * f x) + 2 * a * b * (f x * g x)) ∂unitMeasure
          + ∫ x, b ^ 2 * (g x * g x) ∂unitMeasure := by
          simpa only [Pi.add_apply] using integral_add (h1.add h2) h3
    _ = (∫ x, a ^ 2 * (f x * f x) ∂unitMeasure
          + ∫ x, 2 * a * b * (f x * g x) ∂unitMeasure)
          + ∫ x, b ^ 2 * (g x * g x) ∂unitMeasure := by
          have h := integral_add h1 h2
          rw [h]
    _ = (a ^ 2 * 1 + 2 * a * b * 0) + b ^ 2 * 1 := by
          rw [integral_const_mul, integral_const_mul, integral_const_mul, hf, horth, hg]
    _ = a ^ 2 + b ^ 2 := by ring

/-- **Orthonormality of the normalised generator family.** -/
theorem haarGensNorm_orthonormal (N : ℕ) :
    (∀ f ∈ haarGensNorm N, ∫ x, f x * f x ∂unitMeasure = 1) ∧
    (∀ f ∈ haarGensNorm N, ∀ g ∈ haarGensNorm N, f ≠ g →
      ∫ x, f x * g x ∂unitMeasure = 0) :=
  ⟨fun f hf => by simpa [pow_two] using haarGensNorm_unit N hf,
   fun _ hf _ hg hne => haarGensNorm_orthogonal N hf hg hne⟩

/-- **Orthogonal block additivity.**  Adding an orthogonal block adds squared
norms. -/
theorem integral_add_sq_of_orthogonal {F G : ℝ → ℝ}
    (hFF : Integrable (fun x => F x * F x) unitMeasure)
    (hGG : Integrable (fun x => G x * G x) unitMeasure)
    (hFG : Integrable (fun x => F x * G x) unitMeasure)
    (horth : ∫ x, F x * G x ∂unitMeasure = 0) :
    ∫ x, (F x + G x) ^ 2 ∂unitMeasure
      = ∫ x, F x * F x ∂unitMeasure + ∫ x, G x * G x ∂unitMeasure := by
  have h2FG : Integrable (fun x => 2 * (F x * G x)) unitMeasure := hFG.const_mul 2
  have hsum : Integrable (fun x => F x * F x + 2 * (F x * G x)) unitMeasure :=
    hFF.add h2FG
  calc
    ∫ x, (F x + G x) ^ 2 ∂unitMeasure
        = ∫ x, (F x * F x + 2 * (F x * G x) + G x * G x) ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards with x
          ring
    _ = ∫ x, (F x * F x + 2 * (F x * G x)) ∂unitMeasure
          + ∫ x, G x * G x ∂unitMeasure := by
          simpa only [Pi.add_apply] using integral_add hsum hGG
    _ = (∫ x, F x * F x ∂unitMeasure + ∫ x, 2 * (F x * G x) ∂unitMeasure)
          + ∫ x, G x * G x ∂unitMeasure := by
          have h := integral_add hFF h2FG
          rw [h]
    _ = (∫ x, F x * F x ∂unitMeasure + 2 * 0)
          + ∫ x, G x * G x ∂unitMeasure := by
          rw [integral_const_mul, horth]
    _ = ∫ x, F x * F x ∂unitMeasure + ∫ x, G x * G x ∂unitMeasure := by ring

/-- Multiplication by a fixed function distributes over a finite sum under the
integral. -/
lemma integral_mul_finsetSum {ι : Type*} (s : Finset ι) {F : ℝ → ℝ}
    {f : ι → ℝ → ℝ} (h : ∀ i ∈ s, Integrable (fun x => F x * f i x) unitMeasure) :
    ∫ x, F x * (∑ i ∈ s, f i x) ∂unitMeasure
      = ∑ i ∈ s, ∫ x, F x * f i x ∂unitMeasure := by
  rw [← integral_finsetSum s h]
  apply integral_congr_ae
  filter_upwards with x
  rw [Finset.mul_sum]

/-- **Three-block additivity.**  Three pairwise orthogonal blocks add squared
norms. -/
theorem integral_add_three_sq_of_orthogonal {F G H : ℝ → ℝ}
    (hFF : Integrable (fun x => F x * F x) unitMeasure)
    (hGG : Integrable (fun x => G x * G x) unitMeasure)
    (hHH : Integrable (fun x => H x * H x) unitMeasure)
    (hFG : Integrable (fun x => F x * G x) unitMeasure)
    (hFH : Integrable (fun x => F x * H x) unitMeasure)
    (hGH : Integrable (fun x => G x * H x) unitMeasure)
    (hFG0 : ∫ x, F x * G x ∂unitMeasure = 0)
    (hFH0 : ∫ x, F x * H x ∂unitMeasure = 0)
    (hGH0 : ∫ x, G x * H x ∂unitMeasure = 0) :
    ∫ x, (F x + G x + H x) ^ 2 ∂unitMeasure
      = ∫ x, F x * F x ∂unitMeasure + ∫ x, G x * G x ∂unitMeasure
        + ∫ x, H x * H x ∂unitMeasure := by
  have hFGsq_int : Integrable (fun x => (F x + G x) * (F x + G x)) unitMeasure := by
    have h : Integrable (fun x => F x * F x + 2 * (F x * G x) + G x * G x) unitMeasure :=
      (hFF.add (hFG.const_mul 2)).add hGG
    convert h using 1
    ext x
    ring
  have hFGH : Integrable (fun x => (F x + G x) * H x) unitMeasure := by
    have h : Integrable (fun x => F x * H x + G x * H x) unitMeasure := hFH.add hGH
    convert h using 1
    ext x
    ring
  have horth : ∫ x, (F x + G x) * H x ∂unitMeasure = 0 := by
    have h : ∫ x, (F x + G x) * H x ∂unitMeasure
        = ∫ x, F x * H x + G x * H x ∂unitMeasure := by
      apply integral_congr_ae
      filter_upwards with x
      ring
    rw [h]
    have hadd := integral_add hFH hGH
    rw [hadd, hFH0, hGH0]
    ring
  have htwo := integral_add_sq_of_orthogonal hFGsq_int hHH hFGH horth
  have hFG_sq := integral_add_sq_of_orthogonal hFF hGG hFG hFG0
  have hFG_sq' : ∫ x, (F x + G x) * (F x + G x) ∂unitMeasure
      = ∫ x, F x * F x ∂unitMeasure + ∫ x, G x * G x ∂unitMeasure := by
    simpa [pow_two] using hFG_sq
  calc
    ∫ x, (F x + G x + H x) ^ 2 ∂unitMeasure
        = ∫ x, ((F x + G x) + H x) ^ 2 ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards with x
          ring
    _ = ∫ x, (F x + G x) * (F x + G x) ∂unitMeasure
          + ∫ x, H x * H x ∂unitMeasure := htwo
    _ = (∫ x, F x * F x ∂unitMeasure + ∫ x, G x * G x ∂unitMeasure)
          + ∫ x, H x * H x ∂unitMeasure := by rw [hFG_sq']
    _ = ∫ x, F x * F x ∂unitMeasure + ∫ x, G x * G x ∂unitMeasure
          + ∫ x, H x * H x ∂unitMeasure := by ring

/-- **Single-generator coefficient isometry.**  Scaling a unit vector by `c`
scales its squared norm by `c²`. -/
theorem integral_smul_sq_of_unit {c : ℝ} {f : ℝ → ℝ}
    (_hff : Integrable (fun x => f x * f x) unitMeasure)
    (hf : ∫ x, f x * f x ∂unitMeasure = 1) :
    ∫ x, (c * f x) ^ 2 ∂unitMeasure = c ^ 2 := by
  calc
    ∫ x, (c * f x) ^ 2 ∂unitMeasure
        = ∫ x, c ^ 2 * (f x * f x) ∂unitMeasure := by
          apply integral_congr_ae
          filter_upwards with x
          ring
    _ = c ^ 2 * ∫ x, f x * f x ∂unitMeasure := by
          rw [integral_const_mul]
    _ = c ^ 2 := by rw [hf, mul_one]

/-- A squared finite sum is integrable when all pairwise products are. -/
lemma integrable_finset_sum_sq {ι : Type*} (s : Finset ι)
    (f : ι → ℝ → ℝ) (c : ι → ℝ)
    (hint : ∀ i ∈ s, ∀ j ∈ s, Integrable (fun x => f i x * f j x) unitMeasure) :
    Integrable (fun x => (∑ i ∈ s, c i * f i x) ^ 2) unitMeasure := by
  have h_eq : (fun x => (∑ i ∈ s, c i * f i x) ^ 2)
      = fun x => ∑ i ∈ s, ∑ j ∈ s, (c i * f i x) * (c j * f j x) := by
    funext x
    rw [sq, Finset.sum_mul_sum]
  rw [h_eq]
  apply integrable_finsetSum
  intro i hi
  apply integrable_finsetSum
  intro j hj
  have hij : Integrable (fun x => f i x * f j x) unitMeasure := hint i hi j hj
  have h : (fun x => (c i * f i x) * (c j * f j x))
      = fun x => (c i * c j) * (f i x * f j x) := by
    funext x
    ring
  rw [h]
  exact hij.const_mul _

/-- **Finite-sum coefficient isometry.**  For a finite orthonormal family, the
squared norm of a coefficient sum is the sum of squared coefficients. -/
theorem integral_finset_sum_sq_of_orthonormal {ι : Type*} (s : Finset ι)
    (f : ι → ℝ → ℝ) (c : ι → ℝ)
    (hunit : ∀ i ∈ s, ∫ x, f i x * f i x ∂unitMeasure = 1)
    (horth : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → ∫ x, f i x * f j x ∂unitMeasure = 0)
    (hint : ∀ i ∈ s, ∀ j ∈ s, Integrable (fun x => f i x * f j x) unitMeasure) :
    ∫ x, (∑ i ∈ s, c i * f i x) ^ 2 ∂unitMeasure = ∑ i ∈ s, (c i) ^ 2 := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      simp
  | insert a s ha ih =>
      set G : ℝ → ℝ := fun x => ∑ i ∈ s, c i * f i x with hG
      set H : ℝ → ℝ := fun x => c a * f a x with hH
      have hsum_eq : (fun x => ∑ i ∈ insert a s, c i * f i x) = fun x => G x + H x := by
        funext x
        rw [Finset.sum_insert ha]
        simp [G, H]
        ring
      have hunit_s : ∀ i ∈ s, ∫ x, f i x * f i x ∂unitMeasure = 1 :=
        fun i hi => hunit i (Finset.mem_insert_of_mem hi)
      have horth_s : ∀ i ∈ s, ∀ j ∈ s, i ≠ j →
          ∫ x, f i x * f j x ∂unitMeasure = 0 :=
        fun i hi j hj hne => horth i (Finset.mem_insert_of_mem hi)
          j (Finset.mem_insert_of_mem hj) hne
      have hint_s : ∀ i ∈ s, ∀ j ∈ s,
          Integrable (fun x => f i x * f j x) unitMeasure :=
        fun i hi j hj => hint i (Finset.mem_insert_of_mem hi)
          j (Finset.mem_insert_of_mem hj)
      have hGG : Integrable (fun x => G x * G x) unitMeasure := by
        have := integrable_finset_sum_sq s f c hint_s
        simpa [G, pow_two] using this
      have hHH : Integrable (fun x => H x * H x) unitMeasure := by
        have haa : Integrable (fun x => f a x * f a x) unitMeasure :=
          hint a (Finset.mem_insert_self a s) a (Finset.mem_insert_self a s)
        have h : (fun x => H x * H x)
            = fun x => (c a * c a) * (f a x * f a x) := by
          funext x
          simp [H]
          ring
        rw [h]
        exact haa.const_mul _
      have hGH : Integrable (fun x => G x * H x) unitMeasure := by
        have hinner : Integrable (fun x => ∑ i ∈ s, c i * (f i x * f a x)) unitMeasure := by
          apply integrable_finsetSum
          intro i hi
          exact (hint i (Finset.mem_insert_of_mem hi) a
            (Finset.mem_insert_self a s)).const_mul _
        have hconst : Integrable (fun x => c a * (∑ i ∈ s, c i * (f i x * f a x)))
            unitMeasure := hinner.const_mul _
        have h : (fun x => G x * H x)
            = fun x => c a * (∑ i ∈ s, c i * (f i x * f a x)) := by
          funext x
          simp only [G, H]
          rw [Finset.sum_mul, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i hi
          ring
        rw [h]
        exact hconst
      have horth_GH : ∫ x, G x * H x ∂unitMeasure = 0 := by
        have h : (fun x => G x * H x)
            = fun x => c a * (∑ i ∈ s, c i * (f i x * f a x)) := by
          funext x
          simp only [G, H]
          rw [Finset.sum_mul, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i hi
          ring
        rw [h, integral_const_mul]
        have hsum : ∫ x, (∑ i ∈ s, c i * (f i x * f a x)) ∂unitMeasure
            = ∑ i ∈ s, ∫ x, c i * (f i x * f a x) ∂unitMeasure := by
          apply integral_finsetSum
          intro i hi
          exact (hint i (Finset.mem_insert_of_mem hi) a
            (Finset.mem_insert_self a s)).const_mul _
        have hzero : ∀ i ∈ s, ∫ x, c i * (f i x * f a x) ∂unitMeasure = 0 := by
          intro i hi
          rw [integral_const_mul]
          rw [horth i (Finset.mem_insert_of_mem hi) a
            (Finset.mem_insert_self a s) (by
              intro hia
              exact ha (hia ▸ hi))]
          ring
        rw [hsum]
        have hsum_zero : (∑ i ∈ s, ∫ x, c i * (f i x * f a x) ∂unitMeasure) = 0 := by
          apply Finset.sum_eq_zero
          intro i hi
          exact hzero i hi
        rw [hsum_zero, mul_zero]
      have htwo := integral_add_sq_of_orthogonal hGG hHH hGH horth_GH
      have hG_sq : ∫ x, G x * G x ∂unitMeasure = ∑ i ∈ s, (c i) ^ 2 := by
        simpa [G, pow_two] using ih hunit_s horth_s hint_s
      have hH_sq : ∫ x, H x * H x ∂unitMeasure = (c a) ^ 2 := by
        have haa : Integrable (fun x => f a x * f a x) unitMeasure :=
          hint a (Finset.mem_insert_self a s) a (Finset.mem_insert_self a s)
        have h := integral_smul_sq_of_unit (c := c a) (f := f a) haa
          (hunit a (Finset.mem_insert_self a s))
        simpa [H, pow_two] using h
      have hcongr : ∫ x, (∑ i ∈ insert a s, c i * f i x) ^ 2 ∂unitMeasure
          = ∫ x, (G x + H x) ^ 2 ∂unitMeasure := by
        apply integral_congr_ae
        filter_upwards with x
        rw [congrFun hsum_eq x]
      have htwo' : ∫ x, (G x + H x) ^ 2 ∂unitMeasure
          = ∫ x, G x * G x ∂unitMeasure + ∫ x, H x * H x ∂unitMeasure := by
        simpa [pow_two] using htwo
      rw [hcongr, htwo', hG_sq, hH_sq, Finset.sum_insert ha]
      ring

lemma integrable_haarFun (l r : CylR) : Integrable (haarFun l r) unitMeasure := by
  unfold haarFun haarDiff
  exact (((integrable_cylInd l).smul (1 / l.length)).sub
    ((integrable_cylInd r).smul (1 / r.length))).smul (haarScale l r)

lemma integrable_root_mul_haarFun (l r : CylR) :
    Integrable (fun x => cylInd rootCyl.toReal x * haarFun l r x) unitMeasure := by
  apply Integrable.congr (integrable_haarFun l r)
  filter_upwards [ae_restrict_mem measurableSet_Ico] with x hx
  rw [cylInd_root_apply hx, one_mul]

lemma abs_cylInd_le_one (c : CylR) (x : ℝ) : |cylInd c x| ≤ 1 := by
  unfold cylInd cylSet
  rw [Set.indicator_apply]
  split_ifs <;> norm_num

lemma haarFun_abs_le (l r : CylR) (x : ℝ) :
    |haarFun l r x| ≤
      |haarScale l r| * (|1 / l.length| + |1 / r.length|) := by
  unfold haarFun haarDiff
  simp only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul]
  rw [abs_mul]
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  calc
    |(1 / l.length) * cylInd l x - (1 / r.length) * cylInd r x|
        ≤ |(1 / l.length) * cylInd l x| + |(1 / r.length) * cylInd r x| :=
          abs_sub _ _
    _ = |1 / l.length| * |cylInd l x| + |1 / r.length| * |cylInd r x| := by
          rw [abs_mul, abs_mul]
    _ ≤ |1 / l.length| * 1 + |1 / r.length| * 1 := by
          gcongr
          · exact abs_cylInd_le_one l x
          · exact abs_cylInd_le_one r x
    _ = |1 / l.length| + |1 / r.length| := by ring

lemma aestronglyMeasurable_haarFun (l r : CylR) :
    AEStronglyMeasurable (haarFun l r) unitMeasure := by
  unfold haarFun haarDiff
  exact (((cylInd_aestronglyMeasurable l).const_smul ((1 : ℝ) / l.length)).sub
    ((cylInd_aestronglyMeasurable r).const_smul ((1 : ℝ) / r.length))).const_smul
      (haarScale l r)

lemma integrable_haarFun_mul (l1 r1 l2 r2 : CylR) :
    Integrable (fun x => haarFun l1 r1 x * haarFun l2 r2 x) unitMeasure := by
  refine Integrable.of_bound
    ((aestronglyMeasurable_haarFun l1 r1).mul (aestronglyMeasurable_haarFun l2 r2))
    (|haarScale l1 r1| * (|1 / l1.length| + |1 / r1.length|) *
      (|haarScale l2 r2| * (|1 / l2.length| + |1 / r2.length|))) ?_
  filter_upwards with x
  rw [Real.norm_eq_abs, abs_mul]
  exact mul_le_mul (haarFun_abs_le l1 r1 x) (haarFun_abs_le l2 r2 x)
    (abs_nonneg _) (by positivity)

lemma cylInd_root_apply_of_not_mem {x : ℝ} (hx : x ∉ Set.Ico (0 : ℝ) 1) :
    cylInd rootCyl.toReal x = 0 := by
  unfold cylInd cylSet
  rw [Set.indicator_of_notMem]
  simpa [rootCyl, Cyl.toReal] using hx

lemma integrable_root_mul_root :
    Integrable (fun x => cylInd rootCyl.toReal x * cylInd rootCyl.toReal x) unitMeasure := by
  apply Integrable.congr (integrable_cylInd rootCyl.toReal)
  filter_upwards with x
  by_cases hx : x ∈ Set.Ico (0 : ℝ) 1
  · rw [cylInd_root_apply hx]
    ring
  · rw [cylInd_root_apply_of_not_mem hx]
    ring

/-- **Haar coefficient isometry.**  For any finite subfamily of the normalised
generators, the squared `L²` norm of a coefficient sum is the sum of squared
coefficients. -/
theorem hst_isometry (N : ℕ) (s : Finset (ℝ → ℝ))
    (hs : ∀ f ∈ s, f ∈ haarGensNorm N) (c : (ℝ → ℝ) → ℝ) :
    ∫ x, (∑ f ∈ s, c f * f x) ^ 2 ∂unitMeasure = ∑ f ∈ s, (c f) ^ 2 := by
  apply integral_finset_sum_sq_of_orthonormal s id c
  · intro f hf
    exact (haarGensNorm_orthonormal N).1 f (hs f hf)
  · intro f hf g hg hne
    exact (haarGensNorm_orthonormal N).2 f (hs f hf) g (hs g hg) hne
  · intro f hf g hg
    rcases haarGensNorm_cases (hs f hf) with rfl | ⟨k, _hk, p, hp, h1, rfl⟩
    · rcases haarGensNorm_cases (hs g hg) with rfl | ⟨j, _hj, q, hq, h2, rfl⟩
      · exact integrable_root_mul_root
      · exact integrable_root_mul_haarFun
          (leftChild j q h2).toReal (rightChild j q h2).toReal
    · rcases haarGensNorm_cases (hs g hg) with rfl | ⟨j, _hj, q, hq, h2, rfl⟩
      · have h := integrable_root_mul_haarFun
          (leftChild k p h1).toReal (rightChild k p h1).toReal
        simpa only [id_eq, mul_comm] using h
      · exact integrable_haarFun_mul _ _ _ _

lemma integrable_haarGensNorm_sq (N : ℕ) {f : ℝ → ℝ} (hf : f ∈ haarGensNorm N) :
    Integrable (fun x => f x * f x) unitMeasure := by
  rcases haarGensNorm_cases hf with rfl | ⟨k, _hk, p, hp, h, rfl⟩
  · exact integrable_root_mul_root
  · exact integrable_haarFun_mul _ _ _ _

/-- **Single-generator coefficient isometry for the Haar family.** -/
theorem hst_isometry_single (N : ℕ) {f : ℝ → ℝ} (hf : f ∈ haarGensNorm N) (c : ℝ) :
    ∫ x, (c * f x) ^ 2 ∂unitMeasure = c ^ 2 := by
  exact integral_smul_sq_of_unit (integrable_haarGensNorm_sq N hf)
    ((haarGensNorm_orthonormal N).1 f hf)

theorem single_component_lower_of_mul_lt {n j : ℕ} (hj : 1 ≤ j) (h : j * (j + 3) < n) :
    alpha j + alpha n < alpha (j - 1) := by
  unfold alpha
  have hjm : ((j - 1 : ℕ) : ℝ) + 1 = (j : ℝ) := by
    exact_mod_cast Nat.sub_add_cancel hj
  have hden : ((j - 1 : ℕ) : ℝ) + 2 = (j : ℝ) + 1 := by linarith
  rw [hden]
  have hj2 : (0 : ℝ) < (j : ℝ) + 2 := by positivity
  have hj1 : (0 : ℝ) < (j : ℝ) + 1 := by positivity
  have hn2 : (0 : ℝ) < (n : ℝ) + 2 := by positivity
  rw [div_add_div _ _ hj2.ne' hn2.ne']
  rw [div_lt_div_iff₀ (by positivity) hj1]
  have hjcast : (0 : ℝ) ≤ (j : ℝ) := by positivity
  have hncast : (0 : ℝ) ≤ (n : ℝ) := by positivity
  have hreal : (j : ℝ) * ((j : ℝ) + 3) < (n : ℝ) := by exact_mod_cast h
  nlinarith [Real.pi_pos]

/-- **Accumulator as a selected sum.**  The accumulated angle is the sum of the
selected harmonic angles. -/
theorem accum_eq_sum_digits (n : ℕ) (θ : ℝ) :
    accum n θ = ∑ k ∈ (Finset.range n).filter (fun k => digit k θ = 1), alpha k := by
  induction n with
  | zero => simp [accum]
  | succ n ih =>
      rw [accum, ih]
      conv_rhs => rw [Finset.sum_filter, Finset.sum_range_succ, ← Finset.sum_filter]
      congr 1
      simp [digit, ih]

/-- **General selection criterion.**  Digit `n` is selected exactly when the sum
of the earlier selected angles plus `α_n` does not exceed `θ`. -/
theorem digit_eq_one_iff_sum_add_le (n : ℕ) (θ : ℝ) :
    digit n θ = 1 ↔
      (∑ k ∈ (Finset.range n).filter (fun k => digit k θ = 1), alpha k) + alpha n ≤ θ := by
  rw [show digit n θ = (if alpha n ≤ θ - accum n θ then 1 else 0) from rfl]
  rw [accum_eq_sum_digits]
  by_cases h : alpha n ≤ θ - (∑ k ∈ (Finset.range n).filter
      (fun k => digit k θ = 1), alpha k)
  · simp [h]
    linarith
  · simp [h]
    linarith

/-- **Two-selected-index component.**  If exactly `j` and `k` are selected before
`n`, then `δ_n = 1` exactly when `α_j + α_k + α_n ≤ θ`. -/
theorem digit_one_two_selected_iff {n j k : ℕ} {θ : ℝ} (hjk : j ≠ k)
    (hset : (Finset.range n).filter (fun i => digit i θ = 1) = {j, k}) :
    digit n θ = 1 ↔ alpha j + alpha k + alpha n ≤ θ := by
  rw [digit_eq_one_iff_sum_add_le, hset, Finset.sum_pair hjk]

/-- **General component criterion.**  For any finite set `s` of earlier selected
indices, `δ_n = 1` exactly when `∑_{k∈s} α_k + α_n ≤ θ`. -/
theorem digit_one_iff_selected_finset_sum_le {n : ℕ} {s : Finset ℕ} {θ : ℝ}
    (hset : (Finset.range n).filter (fun k => digit k θ = 1) = s) :
    digit n θ = 1 ↔ (∑ k ∈ s, alpha k) + alpha n ≤ θ := by
  rw [digit_eq_one_iff_sum_add_le, hset]

/-- **Local digit density.**  For `n ≥ 1`, the interval `[n, 2n+1]` contains at
most one selected index. -/
theorem at_most_one_selected_in_doubling_interval {θ : ℝ} (h0 : 0 ≤ θ)
    (hπ : θ ≤ Real.pi) {n a b : ℕ} (hn : 1 ≤ n)
    (ha : digit a θ = 1) (hb : digit b θ = 1)
    (hna : n ≤ a) (hab : a < b) (hb2 : b ≤ 2 * n + 1) : False := by
  have ha1 : 1 ≤ a := le_trans hn hna
  have hgap := digit_one_doubling h0 hπ ha1 ha hb hab
  have h1 : 2 * (n + 2) ≤ 2 * (a + 2) := by nlinarith
  have h2 : b + 2 ≤ 2 * n + 3 := by omega
  nlinarith

/-- **Dyadic block density.**  For `m ≥ 0`, the dyadic block
`[2^m, 2^(m+1)-1]` contains at most one selected index. -/
theorem at_most_one_selected_in_dyadic_block {θ : ℝ} (h0 : 0 ≤ θ)
    (hπ : θ ≤ Real.pi) {m a b : ℕ}
    (ha : digit a θ = 1) (hb : digit b θ = 1)
    (ha1 : 2 ^ m ≤ a) (hb1 : b ≤ 2 ^ (m + 1) - 1) (hab : a < b) : False := by
  have hn : 1 ≤ 2 ^ m := Nat.one_le_two_pow
  have hb2 : b ≤ 2 * (2 ^ m) + 1 := by
    have hpow : 2 ^ (m + 1) = 2 * 2 ^ m := by rw [pow_succ]; ring
    omega
  exact at_most_one_selected_in_doubling_interval h0 hπ hn ha hb ha1 hab hb2

/-- **Global digit-count bound.**  The number of selected indices in `[1,N]` is
at most `log₂ N + 1`. -/
theorem digit_count_le_log {θ : ℝ} (h0 : 0 ≤ θ) (hπ : θ ≤ Real.pi) (N : ℕ) :
    ((Finset.Icc 1 N).filter (fun n => digit n θ = 1)).card
      ≤ Nat.log 2 N + 1 := by
  classical
  set S := (Finset.Icc 1 N).filter (fun n => digit n θ = 1) with hS
  by_cases hN : N = 0
  · subst N
    simp [hS]
  have hinj : Set.InjOn (fun n => Nat.log 2 n) (↑S : Set ℕ) := by
    intro a ha b hb hlog
    have haS : a ∈ S := ha
    have hbS : b ∈ S := hb
    have ha_sel : digit a θ = 1 := (Finset.mem_filter.mp haS).2
    have hb_sel : digit b θ = 1 := (Finset.mem_filter.mp hbS).2
    have ha1 : 1 ≤ a := (Finset.mem_Icc.mp (Finset.mem_filter.mp haS).1).1
    have hb1 : 1 ≤ b := (Finset.mem_Icc.mp (Finset.mem_filter.mp hbS).1).1
    by_contra hne
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · have ha_pow : 2 ^ (Nat.log 2 a) ≤ a :=
        Nat.pow_log_le_self 2 (by omega)
      have hb_lt : b < 2 ^ (Nat.log 2 b + 1) :=
        Nat.lt_pow_succ_log_self (by norm_num) b
      have hlog'' : Nat.log 2 a = Nat.log 2 b := hlog
      rw [← hlog''] at hb_lt
      have hb_le : b ≤ 2 ^ (Nat.log 2 a + 1) - 1 := by omega
      exact at_most_one_selected_in_dyadic_block h0 hπ ha_sel hb_sel ha_pow hb_le hlt
    · have hb_pow : 2 ^ (Nat.log 2 b) ≤ b :=
        Nat.pow_log_le_self 2 (by omega)
      have ha_lt : a < 2 ^ (Nat.log 2 a + 1) :=
        Nat.lt_pow_succ_log_self (by norm_num) a
      have hlog' : Nat.log 2 a = Nat.log 2 b := hlog
      rw [hlog'] at ha_lt
      have ha_le : a ≤ 2 ^ (Nat.log 2 b + 1) - 1 := by omega
      exact at_most_one_selected_in_dyadic_block h0 hπ hb_sel ha_sel hb_pow ha_le hgt
  have hcard : (S.image (fun n => Nat.log 2 n)).card = S.card :=
    Finset.card_image_of_injOn hinj
  have hsub : S.image (fun n => Nat.log 2 n) ⊆ Finset.range (Nat.log 2 N + 1) := by
    intro m hm
    rcases Finset.mem_image.mp hm with ⟨a, ha, rfl⟩
    have haN : a ≤ N := (Finset.mem_Icc.mp (Finset.mem_filter.mp ha).1).2
    have ha1 : 1 ≤ a := (Finset.mem_Icc.mp (Finset.mem_filter.mp ha).1).1
    have hpow : 2 ^ (Nat.log 2 a) ≤ N :=
      le_trans (Nat.pow_log_le_self 2 (by omega)) haN
    have hle : Nat.log 2 a ≤ Nat.log 2 N :=
      Nat.le_log_of_pow_le (by norm_num) hpow
    exact Finset.mem_range.mpr (Nat.lt_succ_of_le hle)
  calc
    S.card = (S.image (fun n => Nat.log 2 n)).card := hcard.symm
    _ ≤ (Finset.range (Nat.log 2 N + 1)).card := Finset.card_le_card hsub
    _ = Nat.log 2 N + 1 := Finset.card_range _

lemma accum_zero (n : ℕ) : accum n 0 = 0 := by
  induction n with
  | zero => simp [accum]
  | succ n ih => simp [accum, ih, not_le.mpr (alpha_pos n)]

/-- At `θ = 0` every harmonic digit is zero, so the digit-one frequency there is
zero. -/
theorem digit_zero_eq_zero (n : ℕ) : digit n 0 = 0 := by
  unfold digit
  rw [accum_zero]
  simp [not_le.mpr (alpha_pos n)]

/-- The residual recurrence: the next residual is the current residual minus the
selected angle. -/
lemma residual_succ_eq (n : ℕ) (θ : ℝ) :
    residual (n + 1) θ = residual n θ - (if digit n θ = 1 then alpha n else 0) := by
  unfold residual
  rw [show accum (n + 1) θ
      = accum n θ + (if alpha n ≤ θ - accum n θ then alpha n else 0) from rfl]
  by_cases h : alpha n ≤ θ - accum n θ
  · have hd : digit n θ = 1 := by
      unfold digit
      simp [h]
    simp [h, hd]
    ring
  · have hd : digit n θ = 0 := by
      unfold digit
      simp [h]
    simp [h, hd]

/-- The normalised greedy remainder `x_n = (n+2) r_n / π`. -/
def greedyX (n : ℕ) (θ : ℝ) : ℝ := ((n : ℝ) + 2) * residual n θ / Real.pi

lemma greedyX_nonneg {n : ℕ} {θ : ℝ} (h0 : 0 ≤ θ) : 0 ≤ greedyX n θ := by
  unfold greedyX
  have hr : 0 ≤ residual n θ := residual_nonneg n h0
  positivity

lemma digit_eq_one_iff_one_le_greedyX {n : ℕ} {θ : ℝ} :
    digit n θ = 1 ↔ 1 ≤ greedyX n θ := by
  unfold greedyX
  have hpi : 0 < Real.pi := Real.pi_pos
  have hn : 0 < ((n : ℝ) + 2) := by positivity
  constructor
  · intro h
    have hsel : alpha n ≤ θ - accum n θ := alpha_le_residual_of_digit_eq_one h
    have halpha : alpha n = Real.pi / ((n : ℝ) + 2) := rfl
    rw [halpha, div_le_iff₀ hn] at hsel
    rw [le_div_iff₀ hpi]
    have hsel' : Real.pi ≤ ((n : ℝ) + 2) * (θ - accum n θ) := by
      calc Real.pi ≤ (θ - accum n θ) * ((n : ℝ) + 2) := hsel
        _ = ((n : ℝ) + 2) * (θ - accum n θ) := by ring
    simpa [residual, one_mul] using hsel'
  · intro h
    rw [le_div_iff₀ hpi] at h
    have hsel : alpha n ≤ θ - accum n θ := by
      have halpha : alpha n = Real.pi / ((n : ℝ) + 2) := rfl
      rw [halpha, div_le_iff₀ hn]
      have h' : Real.pi ≤ ((n : ℝ) + 2) * (θ - accum n θ) := by
        simpa [residual, one_mul] using h
      calc Real.pi ≤ ((n : ℝ) + 2) * (θ - accum n θ) := h'
        _ = (θ - accum n θ) * ((n : ℝ) + 2) := by ring
    unfold digit
    simp [hsel]


/-- **Normalised greedy remainder map.**  The source's map
`x_{n+1} = (1 + 1/(n+2))(x_n - 1_{x_n ≥ 1})` is the exact normalised residual
recursion. -/
theorem greedyX_succ (n : ℕ) (θ : ℝ) :
    greedyX (n + 1) θ
      = (1 + 1 / ((n : ℝ) + 2)) *
          (greedyX n θ - (if 1 ≤ greedyX n θ then 1 else 0)) := by
  unfold greedyX
  rw [residual_succ_eq]
  by_cases h : 1 ≤ ((n : ℝ) + 2) * residual n θ / Real.pi
  · have hd : digit n θ = 1 := (digit_eq_one_iff_one_le_greedyX).2 h
    simp [hd, h]
    unfold alpha
    field_simp [Real.pi_ne_zero]
    ring
  · have hd : digit n θ = 0 := by
      have hdle : digit n θ ≤ 1 := by
        unfold digit
        split_ifs <;> omega
      have hd1 : digit n θ ≠ 1 := fun h1 =>
        h ((digit_eq_one_iff_one_le_greedyX).1 h1)
      omega
    simp [hd, h]
    field_simp [Real.pi_ne_zero]
    ring
/-- The normalised greedy map at depth `n`. -/
def greedyT (n : ℕ) (x : ℝ) : ℝ :=
  (1 + 1 / ((n : ℝ) + 2)) * (x - if 1 ≤ x then 1 else 0)

/-- The `0`-branch inverse of `greedyT`. -/
def greedyBranch0 (n : ℕ) (y : ℝ) : ℝ := y / (1 + 1 / ((n : ℝ) + 2))

/-- The `1`-branch inverse of `greedyT`. -/
def greedyBranch1 (n : ℕ) (y : ℝ) : ℝ :=
  y / (1 + 1 / ((n : ℝ) + 2)) + 1

lemma greedyT_branch0 (n : ℕ) (y : ℝ) (hy : greedyBranch0 n y < 1) :
    greedyT n (greedyBranch0 n y) = y := by
  unfold greedyT greedyBranch0
  have hden : 1 + 1 / ((n : ℝ) + 2) ≠ 0 := by positivity
  have hy' : y / (1 + 1 / ((n : ℝ) + 2)) < 1 := by
    simpa [greedyBranch0] using hy
  rw [ite_eq_right (not_le.mpr hy')]
  field_simp
  ring

lemma greedyT_branch1 (n : ℕ) {y : ℝ} (hy : 0 ≤ y) :
    greedyT n (greedyBranch1 n y) = y := by
  unfold greedyT greedyBranch1
  have hden : 1 + 1 / ((n : ℝ) + 2) ≠ 0 := by positivity
  have hnonneg : 0 ≤ y / (1 + 1 / ((n : ℝ) + 2)) := by positivity
  have h1 : 1 ≤ y / (1 + 1 / ((n : ℝ) + 2)) + 1 := by linarith
  rw [ite_eq_left h1]
  field_simp
  ring

lemma greedyBranch0_nonneg {n : ℕ} {y : ℝ} (hy : 0 ≤ y) :
    0 ≤ greedyBranch0 n y := by
  unfold greedyBranch0
  positivity

lemma greedyBranch0_lt_one {n : ℕ} {y : ℝ}
    (hy : y < 1 + 1 / ((n : ℝ) + 2)) : greedyBranch0 n y < 1 := by
  unfold greedyBranch0
  have hden : 0 < 1 + 1 / ((n : ℝ) + 2) := by positivity
  rw [div_lt_one hden]
  exact hy

lemma greedyBranch1_ge_one {n : ℕ} {y : ℝ} (hy : 0 ≤ y) :
    1 ≤ greedyBranch1 n y := by
  unfold greedyBranch1
  have h : 0 ≤ y / (1 + 1 / ((n : ℝ) + 2)) := by positivity
  linarith

/-- The two branches recover `x` on the two sides of the Markov cut `x = 1`. -/
theorem greedyT_branch_partition (n : ℕ) {x : ℝ} :
    (x < 1 → greedyBranch0 n (greedyT n x) = x) ∧
    (1 ≤ x → greedyBranch1 n (greedyT n x) = x) := by
  constructor
  · intro hx1
    unfold greedyT greedyBranch0
    rw [ite_eq_right (not_le.mpr hx1)]
    field_simp
    ring
  · intro hx1
    unfold greedyT greedyBranch1
    rw [ite_eq_left hx1]
    field_simp
    ring

/-- Finite truncation of the archived transfer operator
`(L_s f)(y) = Σ (n+1)/(n+2)^{s+1} [f(γ_{n,1}y)+f(γ_{n,2}y)]`,
with `k = s+1` a natural exponent. -/
def greedyL (N k : ℕ) (f : ℝ → ℝ) (y : ℝ) : ℝ :=
  ∑ n ∈ Finset.range N,
    (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) *
      (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
        + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))

lemma greedyL_add (N k : ℕ) (f g : ℝ → ℝ) (y : ℝ) :
    greedyL N k (fun x => f x + g x) y = greedyL N k f y + greedyL N k g y := by
  unfold greedyL
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro n hn
  ring

lemma greedyL_smul (N k : ℕ) (c : ℝ) (f : ℝ → ℝ) (y : ℝ) :
    greedyL N k (fun x => c * f x) y = c * greedyL N k f y := by
  unfold greedyL
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro n hn
  ring

/-- The greedy harmonic zeta function `Φ(θ,s)=Σ δ_n(θ)/(n+2)^s`, at natural
integer `s`. -/
def greedyZeta (θ : ℝ) (s : ℕ) : ℝ :=
  ∑' n : ℕ, (digit n θ : ℝ) / ((n : ℝ) + 2) ^ s

lemma greedyZeta_summable (θ : ℝ) {s : ℕ} (hs : 2 ≤ s) :
    Summable (fun n : ℕ => (digit n θ : ℝ) / ((n : ℝ) + 2) ^ s) := by
  have hbase : Summable (fun n : ℕ => 1 / ((n : ℝ) + 2) ^ s) := by
    have hnat : Summable (fun n : ℕ => 1 / (n : ℝ) ^ s) :=
      Real.summable_one_div_nat_pow.mpr (by omega : 1 < s)
    have hshift : Summable (fun n : ℕ => 1 / (((n + 2 : ℕ) : ℝ)) ^ s) :=
      (summable_nat_add_iff 2).2 hnat
    simpa [Nat.cast_add, Nat.cast_ofNat] using hshift
  refine Summable.of_nonneg_of_le (fun n => by positivity) ?_ hbase
  intro n
  have hdle : digit n θ ≤ 1 := by
    unfold digit
    split_ifs <;> omega
  have hdR : (digit n θ : ℝ) ≤ 1 := by exact_mod_cast hdle
  gcongr

/-- The finite transfer operator sends constants to the constant
`2c Σ (n+1)/(n+2)^k`. -/
lemma greedyL_const (N k : ℕ) (c y : ℝ) :
    greedyL N k (fun _ => c) y
      = c * (2 * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k))) := by
  unfold greedyL
  calc
    ∑ n ∈ Finset.range N,
        (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) * (c + c)
        = ∑ n ∈ Finset.range N,
            (2 * c) * (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) := by
          apply Finset.sum_congr rfl
          intro n hn
          ring
    _ = (2 * c) * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) := by
          rw [Finset.mul_sum]
    _ = c * (2 * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k))) := by ring

/-- A finite-operator bound: if `|f| ≤ C`, then `|L f|` is bounded by the
weighted mass `2C Σ (n+1)/(n+2)^k`. -/
lemma greedyL_abs_le (N k : ℕ) (f : ℝ → ℝ) (C : ℝ)
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    |greedyL N k f y|
      ≤ C * (2 * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k))) := by
  unfold greedyL
  calc
    |∑ n ∈ Finset.range N,
        (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) *
          (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
            + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))|
        ≤ ∑ n ∈ Finset.range N,
            |(((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) *
              (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
                + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))| :=
          Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) * (C + C) := by
          apply Finset.sum_le_sum
          intro n hn
          have hw : 0 ≤ ((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k) := by positivity
          rw [abs_mul, abs_of_nonneg hw]
          have harg : |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
                + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))|
              ≤ C + C := by
            calc
              |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
                  + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))|
                  ≤ |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)|
                    + |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))| :=
                    abs_add_le _ _
              _ ≤ C + C := add_le_add (hf _) (hf _)
          exact mul_le_mul_of_nonneg_left harg hw
    _ = C * (2 * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k))) := by
          rw [show C * (2 * ∑ n ∈ Finset.range N,
              (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)))
              = (2 * C) * ∑ n ∈ Finset.range N,
                (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) by ring]
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro n hn
          ring

/-- At `k = 1` the finite-operator weight does not decay: its terms are at least
`1/2`, so the weight series diverges. This is the finite trace-class threshold. -/
theorem greedyWeight_one_not_summable :
    ¬ Summable (fun n : ℕ => ((n : ℝ) + 1) / ((n : ℝ) + 2)) := by
  intro h
  have hzero := h.tendsto_atTop_zero
  rcases (Metric.tendsto_atTop.mp hzero) (1 / 4) (by norm_num) with ⟨N, hN⟩
  have hterm := hN N le_rfl
  have hhalf : (1 / 2 : ℝ) ≤ ((N : ℝ) + 1) / ((N : ℝ) + 2) := by
    rw [le_div_iff₀ (by positivity : (0 : ℝ) < (N : ℝ) + 2)]
    nlinarith
  have hnonneg : 0 ≤ ((N : ℝ) + 1) / ((N : ℝ) + 2) := by positivity
  have hterm' : |((N : ℝ) + 1) / ((N : ℝ) + 2)| < 1 / 4 := by
    simpa only [Real.dist_eq, sub_zero] using hterm
  rw [abs_of_nonneg hnonneg] at hterm'
  linarith


@[simp] lemma greedyT_zero (n : ℕ) : greedyT n 0 = 0 := by
  unfold greedyT
  simp

@[simp] lemma greedyT_one (n : ℕ) : greedyT n 1 = 0 := by
  unfold greedyT
  simp

set_option maxHeartbeats 400000 in
/-- For `k ≥ 3` the finite-operator weight is summable; the weight behaves like
`1/n^{k-1}`. -/
lemma greedyWeight_summable {k : ℕ} (hk : 3 ≤ k) :
    Summable (fun n : ℕ => ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
  have hbase : Summable (fun n : ℕ => 2 / ((n : ℝ) + 2) ^ (k - 1)) := by
    have hnat : Summable (fun n : ℕ => 1 / (n : ℝ) ^ (k - 1)) :=
      Real.summable_one_div_nat_pow.mpr (by omega : 1 < k - 1)
    have hshift : Summable (fun n : ℕ => 1 / (((n + 2 : ℕ) : ℝ)) ^ (k - 1)) :=
      (summable_nat_add_iff 2).2 hnat
    have hshift2 : Summable (fun n : ℕ =>
        2 * (1 / (((n + 2 : ℕ) : ℝ)) ^ (k - 1))) := hshift.mul_left 2
    simpa only [one_div, div_eq_mul_inv, one_mul, Nat.cast_add, Nat.cast_ofNat] using hshift2
  refine Summable.of_nonneg_of_le (fun n => by positivity) ?_ hbase
  intro n
  have hk1 : k = (k - 1) + 1 := by omega
  rw [hk1, pow_succ]
  have hfac : (0 : ℝ) < ((n : ℝ) + 2) ^ (k - 1) := by positivity
  have hbasepos : (0 : ℝ) < (n : ℝ) + 2 := by positivity
  have hksub : k - 1 + 1 - 1 = k - 1 := by omega
  rw [hksub]
  rw [div_le_div_iff₀ (by positivity : (0 : ℝ) < ((n : ℝ) + 2) ^ (k - 1) * ((n : ℝ) + 2)) hfac]
  nlinarith [mul_le_mul_of_nonneg_left (by nlinarith : (n : ℝ) + 1 ≤ 2 * ((n : ℝ) + 2)) (le_of_lt hfac)]

/-- The source's displayed `T` at branch index `0`, with threshold `1/2` and
scaling `2`. -/
def sourceT0 (y : ℝ) : ℝ := if y ≤ 1 / 2 then 2 * y else 2 * (y - 1 / 2)

lemma sourceT0_one : sourceT0 1 = 1 := by
  unfold sourceT0
  norm_num

/-- **Source map mismatch.**  The source's displayed `T` at `n=0` sends `1` to
`1`, while the actual normalised remainder map sends `1` to `0`. -/
theorem sourceT0_one_ne_greedyT_zero_one : sourceT0 1 ≠ greedyT 0 1 := by
  rw [sourceT0_one]
  simp

/-- Uniform bound on the finite transfer operators for `k ≥ 3`. -/
lemma greedyL_uniform_bound {k : ℕ} (hk : 3 ≤ k) (f : ℝ → ℝ) (C : ℝ)
    (hf : ∀ x, |f x| ≤ C) (N : ℕ) (y : ℝ) :
    |greedyL N k f y|
      ≤ C * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
  have hC : 0 ≤ C := le_trans (abs_nonneg _) (hf 0)
  have hsum := greedyWeight_summable hk
  have hfin := greedyL_abs_le N k f C hf y
  have hle : (∑ n ∈ Finset.range N, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k)
      ≤ ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k :=
    hsum.sum_le_tsum (Finset.range N) (fun n hn => by positivity)
  calc
    |greedyL N k f y|
        ≤ C * (2 * ∑ n ∈ Finset.range N,
            ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := hfin
    _ ≤ C * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
          gcongr

/-- The infinite archived transfer operator, defined by the sum of its branches. -/
def greedyLInf (k : ℕ) (f : ℝ → ℝ) (y : ℝ) : ℝ :=
  ∑' n : ℕ,
    (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) *
      (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
        + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))

lemma summable_greedyL_term {k : ℕ} (hk : 3 ≤ k) {f : ℝ → ℝ} {C : ℝ}
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    Summable (fun n : ℕ =>
      (((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k)) *
        (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
          + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))) := by
  have hC : 0 ≤ C := le_trans (abs_nonneg _) (hf 0)
  have hW := greedyWeight_summable hk
  refine Summable.of_norm_bounded (hW.mul_left (2 * C)) ?_
  intro n
  rw [Real.norm_eq_abs, abs_mul]
  have hw : 0 ≤ ((n : ℝ) + 1) / (((n : ℝ) + 2) ^ k) := by positivity
  rw [abs_of_nonneg hw]
  have harg : |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
        + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))|
      ≤ 2 * C := by
    calc
      |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
          + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))|
          ≤ |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)|
            + |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))| :=
            abs_add_le _ _
      _ ≤ C + C := add_le_add (hf _) (hf _)
      _ = 2 * C := by ring
  nlinarith

/-- The finite truncations converge to the infinite transfer operator. -/
theorem greedyL_tendsto {k : ℕ} (hk : 3 ≤ k) {f : ℝ → ℝ} {C : ℝ}
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    Tendsto (fun N : ℕ => greedyL N k f y) atTop (𝓝 (greedyLInf k f y)) := by
  have hsum := summable_greedyL_term hk hf y
  simpa [greedyL, greedyLInf] using hsum.hasSum.tendsto_sum_nat


/-- The finite constant action converges to the infinite-operator constant action. -/
lemma greedyL_const_tendsto {k : ℕ} (hk : 3 ≤ k) (c y : ℝ) :
    Tendsto (fun N : ℕ => greedyL N k (fun _ => c) y) atTop
      (𝓝 (c * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k))) := by
  have hW := greedyWeight_summable hk
  have h := hW.hasSum.tendsto_sum_nat
  have h2 : Tendsto (fun N : ℕ =>
      c * (2 * ∑ n ∈ Finset.range N, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k))
      atTop (𝓝 (c * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k))) := by
    have hm := h.const_mul (2 * c)
    simpa [mul_assoc, mul_comm, mul_left_comm] using hm
  simpa [greedyL_const] using h2

/-- Additivity of the infinite transfer operator on bounded functions. -/
lemma greedyLInf_add {k : ℕ} (hk : 3 ≤ k) {f g : ℝ → ℝ} {Cf Cg : ℝ}
    (hf : ∀ x, |f x| ≤ Cf) (hg : ∀ x, |g x| ≤ Cg) (y : ℝ) :
    greedyLInf k (fun x => f x + g x) y
      = greedyLInf k f y + greedyLInf k g y := by
  have hf_sum := summable_greedyL_term hk hf y
  have hg_sum := summable_greedyL_term hk hg y
  have hfg_bound : ∀ x, |(fun x => f x + g x) x| ≤ Cf + Cg := by
    intro x
    calc
      |f x + g x| ≤ |f x| + |g x| := abs_add_le _ _
      _ ≤ Cf + Cg := add_le_add (hf x) (hg x)
  have hfg_sum := summable_greedyL_term hk hfg_bound y
  unfold greedyLInf
  rw [← hf_sum.tsum_add hg_sum]
  apply tsum_congr
  intro n
  ring

/-- Homogeneity of the infinite transfer operator. -/
lemma greedyLInf_smul (k : ℕ) (c : ℝ) (f : ℝ → ℝ) (y : ℝ) :
    greedyLInf k (fun x => c * f x) y = c * greedyLInf k f y := by
  unfold greedyLInf
  rw [← tsum_mul_left]
  apply tsum_congr
  intro n
  ring

lemma summable_greedyBase {s : ℕ} (hs : 2 ≤ s) :
    Summable (fun n : ℕ => 1 / ((n : ℝ) + 2) ^ s) := by
  have hnat : Summable (fun n : ℕ => 1 / (n : ℝ) ^ s) :=
    Real.summable_one_div_nat_pow.mpr (by omega : 1 < s)
  have hshift : Summable (fun n : ℕ => 1 / (((n + 2 : ℕ) : ℝ)) ^ s) :=
    (summable_nat_add_iff 2).2 hnat
  simpa [Nat.cast_add, Nat.cast_ofNat] using hshift

/-- The greedy harmonic zeta is bounded by the corresponding `p`-series. -/
lemma greedyZeta_le_base (θ : ℝ) {s : ℕ} (hs : 2 ≤ s) :
    greedyZeta θ s ≤ ∑' n : ℕ, 1 / ((n : ℝ) + 2) ^ s := by
  have hZ := greedyZeta_summable θ hs
  have hB := summable_greedyBase hs
  unfold greedyZeta
  refine hZ.tsum_le_tsum (fun n => ?_) hB
  have hdle : digit n θ ≤ 1 := by
    unfold digit
    split_ifs <;> omega
  have hdR : (digit n θ : ℝ) ≤ 1 := by exact_mod_cast hdle
  gcongr

/-- The greedy harmonic zeta decreases as the integer exponent increases. -/
lemma greedyZeta_succ_le (θ : ℝ) {s : ℕ} (hs : 2 ≤ s) :
    greedyZeta θ (s + 1) ≤ greedyZeta θ s := by
  have h1 := greedyZeta_summable θ (by omega : 2 ≤ s + 1)
  have h0 := greedyZeta_summable θ hs
  unfold greedyZeta
  refine h1.tsum_le_tsum (fun n => ?_) h0
  have hd : 0 ≤ (digit n θ : ℝ) := by positivity
  have hbase : (1 : ℝ) ≤ (n : ℝ) + 2 := by
    have hn : (0 : ℝ) ≤ (n : ℝ) := by exact_mod_cast Nat.zero_le n
    nlinarith
  gcongr
  omega

/-- The greedy harmonic zeta is the limit of its finite partial sums. -/
lemma greedyZeta_tendsto (θ : ℝ) {s : ℕ} (hs : 2 ≤ s) :
    Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N,
      (digit n θ : ℝ) / ((n : ℝ) + 2) ^ s) atTop (𝓝 (greedyZeta θ s)) := by
  have h := greedyZeta_summable θ hs
  simpa [greedyZeta] using h.hasSum.tendsto_sum_nat

lemma greedyZeta_nonneg (θ : ℝ) (s : ℕ) : 0 ≤ greedyZeta θ s := by
  unfold greedyZeta
  exact tsum_nonneg (fun n => by positivity)

@[simp] lemma greedyZeta_zero (s : ℕ) : greedyZeta 0 s = 0 := by
  unfold greedyZeta
  simp [digit_zero_eq_zero]

/-- The infinite transfer operator inherits the finite uniform bound. -/
lemma greedyLInf_abs_le {k : ℕ} (hk : 3 ≤ k) {f : ℝ → ℝ} {C : ℝ}
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    |greedyLInf k f y|
      ≤ C * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
  let B : ℝ := C * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k)
  have hconv : Tendsto (fun N : ℕ => greedyL N k f y) atTop (𝓝 (greedyLInf k f y)) :=
    greedyL_tendsto hk hf y
  have hbound : ∀ N : ℕ, |greedyL N k f y| ≤ B := fun N =>
    greedyL_uniform_bound hk f C hf N y
  exact le_of_tendsto_of_tendsto' hconv.abs tendsto_const_nhds hbound

@[simp] lemma greedyLInf_zero (k : ℕ) (y : ℝ) :
    greedyLInf k (fun _ => 0) y = 0 := by
  simp [greedyLInf]

lemma greedyLInf_neg (k : ℕ) (f : ℝ → ℝ) (y : ℝ) :
    greedyLInf k (fun x => -f x) y = -greedyLInf k f y := by
  unfold greedyLInf
  rw [← tsum_neg]
  apply tsum_congr
  intro n
  ring

/-- The infinite operator is Lipschitz on bounded functions: differences are
controlled by the same weight mass. -/
lemma greedyLInf_sub_abs_le {k : ℕ} (hk : 3 ≤ k) {f g : ℝ → ℝ} {Cg C : ℝ}
    (hg : ∀ x, |g x| ≤ Cg)
    (hdiff : ∀ x, |f x - g x| ≤ C) (y : ℝ) :
    |greedyLInf k f y - greedyLInf k g y|
      ≤ C * (2 * ∑' n : ℕ, ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
  have hlin := greedyLInf_add hk hdiff hg y
  have hf_eq : (fun x => (f x - g x) + g x) = f := by
    funext x
    ring
  rw [hf_eq] at hlin
  have hbound := greedyLInf_abs_le hk hdiff y
  have hdiff_eq : greedyLInf k f y - greedyLInf k g y
      = greedyLInf k (fun x => f x - g x) y := by linarith
  rw [hdiff_eq]
  exact hbound

end HST
