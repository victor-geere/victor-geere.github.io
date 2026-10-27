import Mathlib

/-!
# RH-MTC / p-adic MTC — formal core of the local determinant bookkeeping

The archived source (`archive/maths/rh/research/rh-mtc/padic-mtc.html`)
proposes a prime-indexed family of modular tensor categories
`C_p = SU(2)_{p-2}` and asserts that the Reshetikhin–Turaev weight of the
braid attached to a length-`n` periodic orbit of the Bruhat–Tits tree shift
is exactly `p^{-n}`.  The global analytic and operator-theoretic argument,
and the RH conclusion drawn from it, are archived claims and are *not*
formalised here.

What is formalised is the finite arithmetic bookkeeping that the local
determinant step actually uses: the proposed normalised weight
`w_p(n) = p^{-n}` is positive, strictly decreasing, multiplicative in the
orbit length, bounded by one, and its generating series has the Euler-factor
value `p/(p-1)`.  The last two facts are the finite and infinite forms of
the local determinant identity `det(1 - L_p)^{-1} = (1 - p^{-1})^{-1}` at
`s = 1`.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace PadicMTC

/-- The normalised Reshetikhin–Turaev weight attached by the source to a
length-`n` periodic orbit at the prime `p`, in the local bookkeeping model:
`w_p(n) = p^{-n}`. -/
def rtWeight (p : ℕ) (n : ℕ) : ℝ := 1 / (p : ℝ) ^ n

/-- The local RT weight is strictly positive for every orbit length. -/
theorem rtWeight_pos {p : ℕ} (hp : 0 < p) (n : ℕ) : 0 < rtWeight p n := by
  unfold rtWeight
  positivity

/-- Concatenating orbits of lengths `n` and `m` multiplies their weights. -/
theorem rtWeight_mul {p : ℕ} (n m : ℕ) :
    rtWeight p (n + m) = rtWeight p n * rtWeight p m := by
  unfold rtWeight
  rw [pow_add]
  ring

/-- For `p > 1`, longer periodic orbits receive strictly smaller RT weights. -/
theorem rtWeight_strictAnti {p : ℕ} (hp : 1 < p) : StrictAnti (rtWeight p) := by
  intro a b hab
  unfold rtWeight
  apply one_div_lt_one_div_of_lt
  · positivity
  · exact pow_lt_pow_right₀ (by exact_mod_cast hp) hab

/-- The local RT weight never exceeds one. -/
theorem rtWeight_le_one {p : ℕ} (hp : 1 ≤ p) (n : ℕ) : rtWeight p n ≤ 1 := by
  unfold rtWeight
  rw [one_div, ← inv_pow]
  exact pow_le_one₀ (by positivity) (inv_le_one_of_one_le₀ (by exact_mod_cast hp))

/-- Finite Euler-factor bookkeeping: multiplying the first `N` local weights
by `(1 - w_p(1))` telescopes to `1 - w_p(N)`. -/
theorem partial_sum_bookkeeping (p : ℕ) (N : ℕ) :
    (1 - rtWeight p 1) * ((Finset.range N).sum (fun k => rtWeight p k)) =
      1 - rtWeight p N := by
  induction N with
  | zero => simp [rtWeight]
  | succ N ih =>
      rw [Finset.sum_range_succ, mul_add, ih]
      have hs : rtWeight p (N + 1) = rtWeight p N * rtWeight p 1 := by
        rw [rtWeight_mul]
      rw [hs]
      ring

/-- The local RT weights form a geometric series with Euler-factor sum
`p/(p-1)`; this is the value of the local determinant at `s = 1`. -/
theorem hasSum_rtWeight {p : ℕ} (hp : 1 < p) :
    HasSum (fun n : ℕ => rtWeight p n) ((p : ℝ) / ((p : ℝ) - 1)) := by
  have hp0 : (0 : ℝ) < (p : ℝ) := by positivity
  have hbase0 : (0 : ℝ) ≤ (p : ℝ)⁻¹ := le_of_lt (inv_pos.mpr hp0)
  have hbase1 : (p : ℝ)⁻¹ < 1 := by
    have h : (1 : ℝ) / (p : ℝ) < 1 / 1 :=
      one_div_lt_one_div_of_lt (by norm_num) (by exact_mod_cast hp)
    simpa using h
  have hgeom :
      HasSum (fun n : ℕ => ((p : ℝ)⁻¹) ^ n) (1 - (p : ℝ)⁻¹)⁻¹ :=
    hasSum_geometric_of_lt_one hbase0 hbase1
  have hfun : (fun n : ℕ => rtWeight p n) = fun n : ℕ => ((p : ℝ)⁻¹) ^ n := by
    funext n
    simp [rtWeight, one_div, inv_pow]
  rw [hfun]
  convert hgeom using 1
  field_simp

/-- The local weights tend to zero, so the local determinant series
converges for every admissible prime. -/
theorem rtWeight_tendsto_zero {p : ℕ} (hp : 1 < p) :
    Tendsto (fun n : ℕ => rtWeight p n) atTop (𝓝 0) := by
  have hp0 : (0 : ℝ) < (p : ℝ) := by positivity
  have hbase0 : (0 : ℝ) ≤ (p : ℝ)⁻¹ := le_of_lt (inv_pos.mpr hp0)
  have hbase1 : (p : ℝ)⁻¹ < 1 := by
    have h : (1 : ℝ) / (p : ℝ) < 1 / 1 :=
      one_div_lt_one_div_of_lt (by norm_num) (by exact_mod_cast hp)
    simpa using h
  have h := tendsto_pow_atTop_nhds_zero_of_lt_one hbase0 hbase1
  have hfun : (fun n : ℕ => rtWeight p n) = fun n : ℕ => ((p : ℝ)⁻¹) ^ n := by
    funext n
    simp [rtWeight, one_div, inv_pow]
  rw [hfun]
  exact h

end PadicMTC
