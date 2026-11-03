import Mathlib

/-!
# Angular partition method — exact finite core

This file formalises the part of the angular partition method that is exact and
does not depend on the Riemann hypothesis:

* the finite geometric sector sum;
* the halving-sector circle sum `π + π/2 + π/4 + ... = 2π`;
* the self-similar no-tail fixed point `S = a + r S`;
* the obstruction that the reciprocal weights `1/(n+1)` are not a
  constant-ratio (self-similar) sequence;
* the finite bookkeeping identity "head plus complementary sectors = whole".

The measure-theoretic no-tail theorem for a general sectorial partition and
the application to `ζ` are not formalised here. They are recorded as open in
the README.
-/

namespace AngularPartition

open Finset
open Filter
open scoped BigOperators

/-- **Finite geometric sector sum.**
If a sectorial decomposition has constant contraction ratio `r`, the first `n`
sector weights sum to `a * (1 - r^n) / (1 - r)`. This is the exact finite
identity behind the cake picture; no limit and no tail estimate are used. -/
theorem geom_sector_sum (a r : ℚ) (n : ℕ) (hr : r ≠ 1) :
    (∑ k ∈ Finset.range n, a * r ^ k) = a * (1 - r ^ n) / (1 - r) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, ih]
      have h1 : (1 - r : ℚ) ≠ 0 := by
        intro h
        apply hr
        linarith
      field_simp [h1]
      ring

/-- **Self-similar no-tail fixed point.**
If the whole `S` is a head `a` plus a scaled copy `r * S` of itself, then the
whole is `a / (1 - r)`. The equation is exact; it is not a truncation. -/
theorem self_similar_total (S a r : ℝ) (hr : r ≠ 1) (h : S = a + r * S) :
    S = a / (1 - r) := by
  have h1 : (1 - r : ℝ) ≠ 0 := by
    intro hz
    apply hr
    linarith
  field_simp [h1] at h ⊢
  linarith

/-- **The halving-sector circle sum.**
The sectors of angle `π, π/2, π/4, ...` tile the circle, so their angles sum
to a full turn `2π`. This is the radian form of the cake identity. -/
theorem sector_angle_hasSum :
    HasSum (fun n : ℕ => Real.pi * ((1 : ℝ) / 2) ^ n) (2 * Real.pi) := by
  have h : HasSum (fun n : ℕ => ((1 : ℝ) / 2) ^ n) 2 := hasSum_geometric_two
  have h' := h.mul_left Real.pi
  simpa [mul_comm, mul_left_comm, mul_assoc] using h'

/-- The same identity in `tsum` form. -/
theorem sector_angle_tsum :
    (∑' n : ℕ, Real.pi * ((1 : ℝ) / 2) ^ n) = 2 * Real.pi :=
  sector_angle_hasSum.tsum_eq

/-- **Obstruction: reciprocal weights are not constant-ratio.**
The sequence `1/(n+1)` is not of the form `a * r^n`, so it cannot be the
sector-weight sequence of a single-ratio self-similar partition. This is the
toy version of the obstruction to applying the naive cake method to `ζ`. -/
theorem inv_nat_not_geometric :
    ¬ ∃ r : ℚ, ∀ n : ℕ, (1 : ℚ) / (n + 2) = r * (1 / (n + 1)) := by
  rintro ⟨r, hr⟩
  have h0 := hr 0
  have h1 := hr 1
  norm_num at h0 h1
  linarith

/-- **Finite no-tail bookkeeping.**
For a finite sector set, the total is the head plus the complementary sectors.
This is the finite shadow of `μ(X) = ∑ μ(X_n)`; it contains no estimate. -/
theorem finite_partition_total {ι : Type*} [Fintype ι] (p : ι → Prop)
    [DecidablePred p] (a : ι → ℝ) :
    (∑ i, a i) =
      (∑ i ∈ Finset.univ.filter p, a i) +
        (∑ i ∈ Finset.univ.filter (fun i => ¬ p i), a i) := by
  rw [← Finset.sum_filter_add_sum_filter_not (s := Finset.univ) (p := p)]

end AngularPartition

namespace AngularPartition

open MeasureTheory
open Filter

/-- **General finite no-tail partition.**
For any finite family of pairwise disjoint measurable sectors, the measure of
the union is the sum of the sector measures. No geometric ratio, no decay
hypothesis, and no truncation are involved. -/
theorem measure_partition_finset {α : Type*} [MeasurableSpace α] (μ : Measure α)
    {ι : Type*} (s : Finset ι) (X : ι → Set α)
    (hdisj : Set.PairwiseDisjoint (↑s) X)
    (hmeas : ∀ i ∈ s, MeasurableSet (X i)) :
    μ (⋃ i ∈ s, X i) = ∑ i ∈ s, μ (X i) :=
  measure_biUnion_finset hdisj hmeas

/-- **Finite annular telescoping.**
The sum of the annulus areas `r_k^2 - r_{k+1}^2` is the disk area
`r_0^2 - r_n^2`, for arbitrary radii. No geometric progression is assumed. -/
theorem annular_telescope (r : ℕ → ℝ) (n : ℕ) :
    (∑ k ∈ Finset.range n, (r k ^ 2 - r (k + 1) ^ 2)) =
      r 0 ^ 2 - r n ^ 2 := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, ih]
      ring

/-- **Any finite weight sequence is an annular partition.**
If the weights are the differences of squared radii, their sum is the area of
the whole disk. This is the general radial bookkeeping transform: the depth
index is the radius, and the weights need not decay geometrically. -/
theorem annular_weight_sum (a r : ℕ → ℝ) (n : ℕ)
    (h : ∀ k, k < n → a k = r k ^ 2 - r (k + 1) ^ 2) :
    (∑ k ∈ Finset.range n, a k) = r 0 ^ 2 - r n ^ 2 := by
  calc
    (∑ k ∈ Finset.range n, a k)
        = ∑ k ∈ Finset.range n, (r k ^ 2 - r (k + 1) ^ 2) := by
          apply Finset.sum_congr rfl
          intro k hk
          exact h k (Finset.mem_range.mp hk)
    _ = r 0 ^ 2 - r n ^ 2 := annular_telescope r n

end AngularPartition

namespace AngularPartition

/-- The tail sum `∑_{k≥n} a (n+k)`. -/
noncomputable def tail (a : ℕ → ℝ) (n : ℕ) : ℝ :=
  ∑' k : ℕ, a (n + k)

/-- The squared tail radius is the tail sum; the radius itself is its square
root. -/
noncomputable def tailRadius (a : ℕ → ℝ) (n : ℕ) : ℝ :=
  Real.sqrt (tail a n)

/-- Splitting the tail: `tail n = a n + tail (n+1)`. -/
theorem tail_eq_add (a : ℕ → ℝ) (hsum : Summable a) (n : ℕ) :
    tail a n = a n + tail a (n + 1) := by
  have hs' : Summable (fun k : ℕ => a (k + n)) :=
    (summable_nat_add_iff n).2 hsum
  have hs : Summable (fun k : ℕ => a (n + k)) := by
    simpa [Nat.add_comm] using hs' 
  have h := hs.tsum_eq_zero_add
  simpa [tail, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using h

/-- Every tail is nonnegative. -/
theorem tail_nonneg (a : ℕ → ℝ) (ha : ∀ n, 0 ≤ a n) (n : ℕ) :
    0 ≤ tail a n := by
  exact tsum_nonneg (fun k => ha (n + k))

/-- **Infinite annular representation.**
For any summable nonnegative sequence `a`, the squared tail radii
`R_n = sqrt (∑_{k≥n} a (n+k))` satisfy
`a n = R_n ^ 2 - R_{n+1} ^ 2`, and the whole sum is `R_0 ^ 2`.
This is the exact radial bookkeeping transform; no geometric decay is assumed.
-/
theorem annular_representation (a : ℕ → ℝ) (ha : ∀ n, 0 ≤ a n)
    (hsum : Summable a) :
    (∀ n, a n = tailRadius a n ^ 2 - tailRadius a (n + 1) ^ 2) ∧
      tailRadius a 0 ^ 2 = ∑' n, a n := by
  constructor
  · intro n
    have hsplit := tail_eq_add a hsum n
    have h1 : tailRadius a n ^ 2 = tail a n :=
      Real.sq_sqrt (tail_nonneg a ha n)
    have h2 : tailRadius a (n + 1) ^ 2 = tail a (n + 1) :=
      Real.sq_sqrt (tail_nonneg a ha (n + 1))
    rw [h1, h2]
    linarith
  · have h0 : tailRadius a 0 ^ 2 = tail a 0 :=
      Real.sq_sqrt (tail_nonneg a ha 0)
    rw [h0]
    simp [tail]

end AngularPartition

namespace AngularPartition

/-- The complex tail sum `∑_{k≥n} c (n+k)`. -/
noncomputable def ctail (c : ℕ → ℂ) (n : ℕ) : ℂ :=
  ∑' k : ℕ, c (n + k)

/-- The radius of the phase-carrying coil. -/
noncomputable def coilRadius (c : ℕ → ℂ) (n : ℕ) : ℝ :=
  ‖ctail c n‖

/-- The angle of the phase-carrying coil. -/
noncomputable def coilAngle (c : ℕ → ℂ) (n : ℕ) : ℝ :=
  Complex.arg (ctail c n)

/-- Splitting the complex tail: `ctail n = c n + ctail (n+1)`. -/
theorem ctail_eq_add (c : ℕ → ℂ) (hsum : Summable c) (n : ℕ) :
    ctail c n = c n + ctail c (n + 1) := by
  have hs' : Summable (fun k : ℕ => c (k + n)) :=
    (summable_nat_add_iff n).2 hsum
  have hs : Summable (fun k : ℕ => c (n + k)) := by
    simpa [Nat.add_comm] using hs'
  have h := hs.tsum_eq_zero_add
  simpa [ctail, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using h

/-- The complex tail tends to zero: the coil spirals into the origin. -/
theorem ctail_tendsto_zero (c : ℕ → ℂ) :
    Filter.Tendsto (fun n => ctail c n) Filter.atTop (nhds 0) := by
  simpa [ctail, Nat.add_comm] using tendsto_sum_nat_add c

/-- The finite sum is the difference of the starting and ending points of the
coil: `∑_{k<n} c k = ctail 0 - ctail n`. -/
theorem ctail_telescope (c : ℕ → ℂ) (hsum : Summable c) (n : ℕ) :
    (∑ k ∈ Finset.range n, c k) = ctail c 0 - ctail c n := by
  have h := hsum.sum_add_tsum_nat_add n
  have hct : ctail c n = ∑' i : ℕ, c (i + n) := by
    simp [ctail, Nat.add_comm]
  have h0 : ctail c 0 = ∑' i : ℕ, c i := by simp [ctail]
  rw [hct, h0]
  calc
    (∑ k ∈ Finset.range n, c k)
        = ((∑ k ∈ Finset.range n, c k) + (∑' i : ℕ, c (i + n))) -
            (∑' i : ℕ, c (i + n)) := by
          abel
    _ = (∑' i : ℕ, c i) - (∑' i : ℕ, c (i + n)) := by rw [h]

/-- **Phase-carrying coil.**
For a summable complex sequence `c`, the tail `ctail n` is the cumulative
(tail) sum, its norm is the coil radius, and its argument is the phase. The
coil tends to the origin, and the finite sum is the chord from the start to the
current point. -/
theorem phase_carrying_coil (c : ℕ → ℂ) (hsum : Summable c) :
    (∀ n, c n = ctail c n - ctail c (n + 1)) ∧
      (∀ n, ctail c n =
        (coilRadius c n : ℂ) * Complex.exp (coilAngle c n * Complex.I)) ∧
      Filter.Tendsto (fun n => ctail c n) Filter.atTop (nhds 0) := by
  refine ⟨?_, ?_, ctail_tendsto_zero c⟩
  · intro n
    have h := ctail_eq_add c hsum n
    rw [h]
    abel
  · intro n
    exact (Complex.norm_mul_exp_arg_mul_I (ctail c n)).symm

/-- The unit coil: normalize the tail by its initial value. -/
noncomputable def unitCoil (c : ℕ → ℂ) (n : ℕ) : ℂ :=
  ctail c n / ctail c 0

/-- The unit coil starts at `1`. -/
theorem unitCoil_zero (c : ℕ → ℂ) (h0 : ctail c 0 ≠ 0) :
    unitCoil c 0 = 1 := by
  simp [unitCoil, h0]

/-- The unit coil spirals into the origin. -/
theorem unitCoil_tendsto_zero (c : ℕ → ℂ) :
    Filter.Tendsto (fun n => unitCoil c n) Filter.atTop (nhds 0) := by
  have h := ctail_tendsto_zero c
  simpa [unitCoil] using h.div_const (ctail c 0)

end AngularPartition
