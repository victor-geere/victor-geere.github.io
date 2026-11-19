import Mathlib

/-!
# HST transfer operator — finite reconstruction core

This topic isolates the O5 programme: the greedy harmonic dynamical system,
its inverse branches, the archived two-branch transfer operator, and the
finite/infinite operator estimates.

The source's displayed `T` map in `harmonic-sine-transform.tex` uses an
off-by-one branch index (R18); the map proved here is the one derived from the
residual rule.  The archived operator formula is retained as a separate object.

No trace-class, Fredholm-determinant, spectral, RH, or GRH claim is made.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace HSTTransfer

/-- The normalised greedy map at depth `n`. -/
def greedyT (n : ℕ) (x : ℝ) : ℝ :=
  (1 + 1 / ((n : ℝ) + 2)) * (x - if 1 ≤ x then 1 else 0)

/-- The zero-branch inverse of `greedyT`. -/
def branch0 (n : ℕ) (y : ℝ) : ℝ := y / (1 + 1 / ((n : ℝ) + 2))

/-- The one-branch inverse of `greedyT`. -/
def branch1 (n : ℕ) (y : ℝ) : ℝ :=
  y / (1 + 1 / ((n : ℝ) + 2)) + 1

/-- **T1.** `T_n(0)=0`. -/
@[simp] theorem greedyT_zero (n : ℕ) : greedyT n 0 = 0 := by
  unfold greedyT
  simp

/-- **T2.** `T_n(1)=0`. -/
@[simp] theorem greedyT_one (n : ℕ) : greedyT n 1 = 0 := by
  unfold greedyT
  simp

/-- **T3.** The zero branch is a right inverse on `y < 1+1/(n+2)`. -/
theorem greedyT_branch0 (n : ℕ) (y : ℝ) (hy : branch0 n y < 1) :
    greedyT n (branch0 n y) = y := by
  unfold greedyT branch0
  have hden : 1 + 1 / ((n : ℝ) + 2) ≠ 0 := by positivity
  have hy' : y / (1 + 1 / ((n : ℝ) + 2)) < 1 := by
    simpa [branch0] using hy
  rw [ite_eq_right (not_le.mpr hy')]
  field_simp
  ring

/-- **T4.** The one branch is a right inverse on `y ≥ 0`. -/
theorem greedyT_branch1 (n : ℕ) {y : ℝ} (hy : 0 ≤ y) :
    greedyT n (branch1 n y) = y := by
  unfold greedyT branch1
  have hden : 1 + 1 / ((n : ℝ) + 2) ≠ 0 := by positivity
  have hnonneg : 0 ≤ y / (1 + 1 / ((n : ℝ) + 2)) := by positivity
  have h1 : 1 ≤ y / (1 + 1 / ((n : ℝ) + 2)) + 1 := by linarith
  rw [ite_eq_left h1]
  field_simp
  ring

/-- **T5.** The two branches recover `x` on `x<1` and `x≥1`. -/
theorem greedyT_branch_partition (n : ℕ) {x : ℝ} :
    (x < 1 → branch0 n (greedyT n x) = x) ∧
    (1 ≤ x → branch1 n (greedyT n x) = x) := by
  constructor
  · intro hx1
    unfold greedyT branch0
    rw [ite_eq_right (not_le.mpr hx1)]
    field_simp
    ring
  · intro hx1
    unfold greedyT branch1
    rw [ite_eq_left hx1]
    field_simp
    ring

/-- The weight of the archived transfer operator. -/
def weight (n k : ℕ) : ℝ := ((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k

/-- The archived two-branch operator, truncated at depth `N`. -/
def greedyL (N k : ℕ) (f : ℝ → ℝ) (y : ℝ) : ℝ :=
  ∑ n ∈ Finset.range N,
    weight n k *
      (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
        + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))

/-- **T6.** The finite operator is additive in `f`. -/
theorem greedyL_add (N k : ℕ) (f g : ℝ → ℝ) (y : ℝ) :
    greedyL N k (fun x => f x + g x) y = greedyL N k f y + greedyL N k g y := by
  unfold greedyL
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro n hn
  ring

/-- **T7.** The finite operator is homogeneous in `f`. -/
theorem greedyL_smul (N k : ℕ) (c : ℝ) (f : ℝ → ℝ) (y : ℝ) :
    greedyL N k (fun x => c * f x) y = c * greedyL N k f y := by
  unfold greedyL
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro n hn
  ring

/-- **T8.** The finite operator on constants. -/
theorem greedyL_const (N k : ℕ) (c y : ℝ) :
    greedyL N k (fun _ => c) y
      = c * (2 * ∑ n ∈ Finset.range N, weight n k) := by
  unfold greedyL weight
  calc
    ∑ n ∈ Finset.range N,
        (((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) * (c + c)
        = ∑ n ∈ Finset.range N,
            (2 * c) * (((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
          apply Finset.sum_congr rfl
          intro n hn
          ring
    _ = (2 * c) * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k) := by
          rw [Finset.mul_sum]
    _ = c * (2 * ∑ n ∈ Finset.range N,
          (((n : ℝ) + 1) / ((n : ℝ) + 2) ^ k)) := by ring

/-- **T9.** The `k=1` weight does not tend to zero, so it is not summable. -/
theorem weight_one_not_summable :
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

/-- **T10.** For `k ≥ 3` the weight is summable. -/
theorem weight_summable {k : ℕ} (hk : 3 ≤ k) :
    Summable (fun n : ℕ => weight n k) := by
  have hbase : Summable (fun n : ℕ => 2 / ((n : ℝ) + 2) ^ (k - 1)) := by
    have hnat : Summable (fun n : ℕ => 1 / (n : ℝ) ^ (k - 1)) :=
      Real.summable_one_div_nat_pow.mpr (by omega : 1 < k - 1)
    have hshift : Summable (fun n : ℕ => 1 / (((n + 2 : ℕ) : ℝ)) ^ (k - 1)) :=
      (summable_nat_add_iff 2).2 hnat
    have hshift2 : Summable (fun n : ℕ =>
        2 * (1 / (((n + 2 : ℕ) : ℝ)) ^ (k - 1))) := hshift.mul_left 2
    simpa only [one_div, div_eq_mul_inv, one_mul, Nat.cast_add, Nat.cast_ofNat] using hshift2
  refine Summable.of_nonneg_of_le (fun n => by unfold weight; positivity) ?_ hbase
  intro n
  unfold weight
  have hk1 : k = (k - 1) + 1 := by omega
  rw [hk1, pow_succ]
  have hfac : (0 : ℝ) < ((n : ℝ) + 2) ^ (k - 1) := by positivity
  have hbasepos : (0 : ℝ) < (n : ℝ) + 2 := by positivity
  have hksub : k - 1 + 1 - 1 = k - 1 := by omega
  rw [hksub]
  rw [div_le_div_iff₀ (by positivity : (0 : ℝ) < ((n : ℝ) + 2) ^ (k - 1) * ((n : ℝ) + 2)) hfac]
  nlinarith [mul_le_mul_of_nonneg_left (by nlinarith : (n : ℝ) + 1 ≤ 2 * ((n : ℝ) + 2)) (le_of_lt hfac)]

/-- **T11.** A finite-operator bound. -/
theorem greedyL_abs_le (N k : ℕ) (f : ℝ → ℝ) (C : ℝ)
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    |greedyL N k f y| ≤ C * (2 * ∑ n ∈ Finset.range N, weight n k) := by
  unfold greedyL weight
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

/-- The infinite archived transfer operator. -/
def greedyLInf (k : ℕ) (f : ℝ → ℝ) (y : ℝ) : ℝ :=
  ∑' n : ℕ,
    weight n k *
      (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
        + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))

/-- **T12.** Branch term summability for bounded `f`, `k ≥ 3`. -/
theorem summable_greedyL_term {k : ℕ} (hk : 3 ≤ k) {f : ℝ → ℝ} {C : ℝ}
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    Summable (fun n : ℕ =>
      weight n k *
        (f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
          + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2)))) := by
  have hC : 0 ≤ C := le_trans (abs_nonneg _) (hf 0)
  have hW := weight_summable hk
  refine Summable.of_norm_bounded (hW.mul_left (2 * C)) ?_
  intro n
  rw [Real.norm_eq_abs, abs_mul]
  have hw : 0 ≤ weight n k := by unfold weight; positivity
  rw [abs_of_nonneg hw]
  have harg : |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
        + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))| ≤ 2 * C := by
    calc
      |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)
          + f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))|
          ≤ |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y)|
            + |f ((((n : ℝ) + 1) / ((n : ℝ) + 2)) * y + 1 / ((n : ℝ) + 2))| :=
            abs_add_le _ _
      _ ≤ C + C := add_le_add (hf _) (hf _)
      _ = 2 * C := by ring
  nlinarith

/-- **T13.** Finite truncations converge to the infinite operator. -/
theorem greedyL_tendsto {k : ℕ} (hk : 3 ≤ k) {f : ℝ → ℝ} {C : ℝ}
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    Tendsto (fun N : ℕ => greedyL N k f y) atTop (𝓝 (greedyLInf k f y)) := by
  have hsum := summable_greedyL_term hk hf y
  simpa [greedyL, greedyLInf] using hsum.hasSum.tendsto_sum_nat

/-- **T14.** Infinite operator zero and negation. -/
@[simp] theorem greedyLInf_zero (k : ℕ) (y : ℝ) :
    greedyLInf k (fun _ => 0) y = 0 := by
  simp [greedyLInf]

theorem greedyLInf_neg (k : ℕ) (f : ℝ → ℝ) (y : ℝ) :
    greedyLInf k (fun x => -f x) y = -greedyLInf k f y := by
  unfold greedyLInf
  rw [← tsum_neg]
  apply tsum_congr
  intro n
  ring

/-- Uniform finite-operator bound for `k ≥ 3`. -/
lemma greedyL_uniform_bound {k : ℕ} (hk : 3 ≤ k) (f : ℝ → ℝ) (C : ℝ)
    (hf : ∀ x, |f x| ≤ C) (N : ℕ) (y : ℝ) :
    |greedyL N k f y| ≤ C * (2 * ∑' n : ℕ, weight n k) := by
  have hC : 0 ≤ C := le_trans (abs_nonneg _) (hf 0)
  have hW := weight_summable hk
  have hfin := greedyL_abs_le N k f C hf y
  have hle : (∑ n ∈ Finset.range N, weight n k) ≤ ∑' n : ℕ, weight n k :=
    hW.sum_le_tsum (Finset.range N) (fun n hn => by unfold weight; positivity)
  calc
    |greedyL N k f y| ≤ C * (2 * ∑ n ∈ Finset.range N, weight n k) := hfin
    _ ≤ C * (2 * ∑' n : ℕ, weight n k) := by gcongr

/-- **T15.** The infinite operator inherits the uniform bound for `k ≥ 3`. -/
lemma greedyLInf_abs_le {k : ℕ} (hk : 3 ≤ k) {f : ℝ → ℝ} {C : ℝ}
    (hf : ∀ x, |f x| ≤ C) (y : ℝ) :
    |greedyLInf k f y| ≤ C * (2 * ∑' n : ℕ, weight n k) := by
  have hconv : Tendsto (fun N : ℕ => greedyL N k f y) atTop (𝓝 (greedyLInf k f y)) :=
    greedyL_tendsto hk hf y
  have hbound : ∀ N : ℕ, |greedyL N k f y|
      ≤ C * (2 * ∑' n : ℕ, weight n k) := fun N =>
    greedyL_uniform_bound hk f C hf N y
  have habs : Tendsto (fun N : ℕ => |greedyL N k f y|) atTop
      (𝓝 |greedyLInf k f y|) := by
    simpa [Real.norm_eq_abs] using hconv.abs
  exact le_of_tendsto_of_tendsto' habs tendsto_const_nhds hbound

end HSTTransfer
