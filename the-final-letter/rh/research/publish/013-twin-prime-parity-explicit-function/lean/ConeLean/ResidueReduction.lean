/-
ConeLean/ResidueReduction.lean — the reduction between the un-averaged two-point Chowla
statement `Σ_{n≤x} f(n) = o(x)` and the vanishing of the cone residue
`lim_{ε↓0} ε Σ_n f(n) n^{−1−ε}`.

The residue is the **Abelian** mean of `f`.  This file develops the elementary part of
the reduction:

* discrete Abel summation (`sum_mul_eq`), the identity behind every Abelian mean;
* the weight-difference bound `w n − w (n+1) ≤ (1+ε) n^{−2−ε}` for `w n = n^{−1−ε}`;

and, in the later sections, the two implications that make the residue a theorem:

* `M(x) = o(x)` (Cesàro mean zero) ⟹ the Abelian mean vanishes — the direction that
  makes the residue *necessary* for `o(x)`;
* `Σ_{n≤x} f(n)/n = o(log x)` (Tao's log-averaged two-point Chowla) ⟹ the Abelian
  mean vanishes — the direction that makes the residue *provable*.

The converse fails for bounded sequences (the classical `cos(θ log n)` example), so the
residue is strictly weaker than `o(x)`; that failure is recorded, not reproved.
-/
import Mathlib
import TppLean.ThreeThresholds
import ConeLean.Cone

namespace ConeLean

open Filter
open scoped BigOperators Topology

set_option maxHeartbeats 4000000

noncomputable section

/-! ## 1. Partial sums and discrete Abel summation -/

/-- Partial sums `M(N) = Σ_{i<N} f i`. -/
def partSum (f : ℕ → ℝ) (N : ℕ) : ℝ := ∑ i ∈ Finset.range N, f i

@[simp] lemma partSum_zero (f : ℕ → ℝ) : partSum f 0 = 0 := by
  simp [partSum]

lemma partSum_succ (f : ℕ → ℝ) (n : ℕ) : partSum f (n + 1) = partSum f n + f n := by
  simp [partSum, Finset.sum_range_succ]

/-- The Abel weight `w n = n^{−1−ε}`. -/
noncomputable def abelWeight (ε : ℝ) (n : ℕ) : ℝ := (n : ℝ) ^ (-1 - ε)

/-- **Discrete Abel summation.**  For any weight `w`,
`Σ_{n<N} f n · w n = M(N)·w(N−1) − Σ_{n<N−1} M(n+1)·(w(n+1) − w(n))`. -/
lemma sum_mul_eq (f w : ℕ → ℝ) (N : ℕ) :
    ∑ n ∈ Finset.range N, f n * w n
      = partSum f N * w (N - 1)
        - ∑ n ∈ Finset.range (N - 1), partSum f (n + 1) * (w (n + 1) - w n) := by
  have h := Finset.sum_range_by_parts' (f := f) (g := w) (n := N)
  simpa only [partSum, smul_eq_mul] using h

/-! ## 2. The weight-difference bound -/

/-- For `w n = n^{−1−ε}`, `ε > 0` and `n ≥ 1`: `w n − w (n+1) ≤ (1+ε)·n^{−2−ε}`. -/
lemma abelWeight_sub_le {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) :
    abelWeight ε n - abelWeight ε (n + 1) ≤ (1 + ε) * (n : ℝ) ^ (-2 - ε) := by
  have hn0 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have h1ε : (0 : ℝ) < 1 + ε := by linarith
  have hderiv : ∀ x ∈ Set.Icc (n : ℝ) ((n + 1 : ℕ) : ℝ),
      HasDerivWithinAt (fun x : ℝ => x ^ (-1 - ε))
        ((-(1 + ε)) * x ^ (-2 - ε)) (Set.Icc (n : ℝ) ((n + 1 : ℕ) : ℝ)) x := by
    intro x hx
    have hx0 : x ≠ 0 := by
      have : (0 : ℝ) < x := lt_of_lt_of_le hn0 hx.1
      exact ne_of_gt this
    have hxpos : (0 : ℝ) < x := lt_of_lt_of_le hn0 hx.1
    have hd := Real.hasDerivAt_rpow_const (x := x) (p := -1 - ε) (Or.inl hx0)
    have hval : (-1 - ε) * x ^ (-1 - ε - 1) = (-(1 + ε)) * x ^ (-2 - ε) := by
      rw [show (-1 : ℝ) - ε - 1 = -2 - ε by ring]
      ring
    rw [hval] at hd
    exact hd.hasDerivWithinAt
  have hbound : ∀ x ∈ Set.Ico (n : ℝ) ((n + 1 : ℕ) : ℝ),
      ‖(-(1 + ε)) * x ^ (-2 - ε)‖ ≤ (1 + ε) * (n : ℝ) ^ (-2 - ε) := by
    intro x hx
    have hx0 : (0 : ℝ) < x := lt_of_lt_of_le hn0 hx.1
    have hmono : x ^ (-2 - ε) ≤ (n : ℝ) ^ (-2 - ε) :=
      Real.rpow_le_rpow_of_nonpos hn0 hx.1 (show -2 - ε ≤ 0 by linarith)
    have hnn : (0 : ℝ) ≤ x ^ (-2 - ε) := Real.rpow_nonneg (le_of_lt hx0) _
    rw [norm_mul, norm_neg, Real.norm_eq_abs, abs_of_pos h1ε, Real.norm_eq_abs,
      abs_of_nonneg hnn]
    exact mul_le_mul_of_nonneg_left hmono (le_of_lt h1ε)
  have hmain := norm_image_sub_le_of_norm_deriv_le_segment' hderiv hbound
    ((n + 1 : ℕ) : ℝ) ⟨by push_cast; linarith, le_rfl⟩
  have hcast : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by push_cast; ring
  rw [hcast, add_sub_cancel_left, mul_one] at hmain
  have hle : abelWeight ε n - abelWeight ε (n + 1)
      ≤ ‖((n : ℝ) + 1) ^ (-1 - ε) - (n : ℝ) ^ (-1 - ε)‖ := by
    simp only [abelWeight, hcast]
    rw [Real.norm_eq_abs, abs_sub_comm]
    exact le_abs_self (((n : ℝ) ^ (-1 - ε) - ((n : ℝ) + 1) ^ (-1 - ε) : ℝ))
  exact hle.trans hmain

/-! ## 3. Summability -/

/-- `Σ_n n^{−1−ε}` converges for `ε > 0`. -/
lemma summable_abelWeight {ε : ℝ} (hε : 0 < ε) : Summable (abelWeight ε) := by
  have h : Summable fun n : ℕ => ((n : ℝ)) ^ (-(1 + ε)) := by
    have h0 := (Real.summable_nat_rpow_inv (p := 1 + ε)).mpr (by linarith)
    exact h0.congr (fun n => by rw [Real.rpow_neg (Nat.cast_nonneg n)])
  refine h.congr (fun n => ?_)
  simp only [abelWeight]
  congr 1
  ring

/-- A bounded `f` still gives a convergent Abel series, for `ε > 0`. -/
lemma summable_mul_abelWeight {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1) {ε : ℝ} (hε : 0 < ε) :
    Summable fun n => f n * abelWeight ε n := by
  refine Summable.of_norm_bounded (summable_abelWeight hε) (fun n => ?_)
  have hw : |abelWeight ε n| = abelWeight ε n :=
    abs_of_nonneg (Real.rpow_nonneg (Nat.cast_nonneg n) (-1 - ε))
  rw [Real.norm_eq_abs, abs_mul, hw]
  exact mul_le_of_le_one_left (Real.rpow_nonneg (Nat.cast_nonneg n) (-1 - ε)) (hf n)

/-- The **Abelian mean** of `f` at parameter `ε`. -/
noncomputable def abelMean (f : ℕ → ℝ) (ε : ℝ) : ℝ := ε * ∑' n, f n * abelWeight ε n

/-! ## 4. Elementary properties of the weight -/

lemma abelWeight_zero {ε : ℝ} (hε : 0 < ε) : abelWeight ε 0 = 0 := by
  rw [abelWeight, Nat.cast_zero, Real.zero_rpow]
  linarith

@[simp] lemma abelWeight_one (ε : ℝ) : abelWeight ε 1 = 1 := by
  rw [abelWeight, Nat.cast_one, Real.one_rpow]

lemma abelWeight_pos {ε : ℝ} (_hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) : 0 < abelWeight ε n :=
  Real.rpow_pos_of_pos (by exact_mod_cast hn) _

lemma abelWeight_nonneg {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) : 0 ≤ abelWeight ε n :=
  le_of_lt (abelWeight_pos hε hn)

/-- The weight is decreasing on the indices `n ≥ 1`. -/
lemma abelWeight_mono {ε : ℝ} (hε : 0 < ε) {n m : ℕ} (hn : 1 ≤ n) (hnm : n ≤ m) :
    abelWeight ε m ≤ abelWeight ε n := by
  have h1 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have h2 : ((n : ℕ) : ℝ) ≤ ((m : ℕ) : ℝ) := by exact_mod_cast hnm
  exact Real.rpow_le_rpow_of_nonpos h1 h2 (show -1 - ε ≤ 0 by linarith)

lemma abelWeight_diff_nonneg {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) :
    0 ≤ abelWeight ε n - abelWeight ε (n + 1) := by
  have := abelWeight_mono hε hn (Nat.le_succ n)
  linarith

lemma abelWeight_abs_diff_le {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) :
    |abelWeight ε (n + 1) - abelWeight ε n| ≤ (1 + ε) * (n : ℝ) ^ (-2 - ε) := by
  rw [abs_sub_comm, abs_of_nonneg (abelWeight_diff_nonneg hε hn)]
  exact abelWeight_sub_le hε hn

/-- The telescoping identity for the weight differences. -/
lemma sum_abelWeight_diff {ε : ℝ} (hε : 0 < ε) (X : ℕ) :
    ∑ n ∈ Finset.range X, (abelWeight ε (n + 1) - abelWeight ε n) = abelWeight ε X := by
  rw [Finset.sum_range_sub, abelWeight_zero hε, sub_zero]

/-- The boundary term is bounded: `N · w(N-1) ≤ 4` for `N ≥ 2`, `ε ≤ 1`. -/
lemma mul_abelWeight_pred_le {ε : ℝ} (hε : 0 < ε) (hε1 : ε ≤ 1) {N : ℕ} (hN : 2 ≤ N) :
    (N : ℝ) * abelWeight ε (N - 1) ≤ 4 := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (by omega : 1 ≤ N)
  have hNm : (2 : ℕ) ≤ N := hN
  have hsub : N - 1 + 1 = N := Nat.sub_add_cancel (by omega : 1 ≤ N)
  have hbase : ((N - 1 : ℕ) : ℝ) = (N : ℝ) - 1 := by
    rw [← hsub]; push_cast; ring
  have hN2 : (2 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
  have hhalf : (N : ℝ) / 2 ≤ ((N - 1 : ℕ) : ℝ) := by
    rw [hbase]; linarith
  have h2 : (0 : ℝ) < (N : ℝ) / 2 := by positivity
  have hmono : abelWeight ε (N - 1) ≤ ((N : ℝ) / 2) ^ (-1 - ε) :=
    Real.rpow_le_rpow_of_nonpos h2 hhalf (show -1 - ε ≤ 0 by linarith)
  have h2inv : ((2 : ℝ)⁻¹) ^ (-1 - ε) = (2 : ℝ) ^ (1 + ε) := by
    rw [Real.inv_rpow (by norm_num : (0 : ℝ) ≤ 2),
      show (-1 : ℝ) - ε = -(1 + ε) by ring, Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2),
      inv_inv]
  have hsplit : ((N : ℝ) / 2) ^ (-1 - ε) = (2 : ℝ) ^ (1 + ε) * (N : ℝ) ^ (-1 - ε) := by
    rw [div_eq_mul_inv,
      Real.mul_rpow (le_of_lt hNpos) (by positivity : (0 : ℝ) ≤ (2 : ℝ)⁻¹), h2inv]
    ring
  have h2e : (2 : ℝ) ^ (1 + ε) ≤ 4 := by
    have h3 : (2 : ℝ) ^ (1 + ε) ≤ (2 : ℝ) ^ (2 : ℝ) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
    have h4 : (2 : ℝ) ^ (2 : ℝ) = 4 := by
      rw [Real.rpow_two]
      norm_num
    linarith [h3, h4.le, h4.ge]
  have hNpow : (N : ℝ) * (N : ℝ) ^ (-1 - ε) = (N : ℝ) ^ (-ε) := by
    rw [show (-ε : ℝ) = 1 + (-1 - ε) by ring,
      Real.rpow_add (by positivity : (0 : ℝ) < (N : ℝ)), Real.rpow_one]
  have hNeps : (N : ℝ) ^ (-ε) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos (by exact_mod_cast (by omega : 1 ≤ N)) (by linarith)
  calc (N : ℝ) * abelWeight ε (N - 1)
      ≤ (N : ℝ) * (((N : ℝ) / 2) ^ (-1 - ε)) :=
        mul_le_mul_of_nonneg_left hmono (le_of_lt hNpos)
    _ = (N : ℝ) * ((2 : ℝ) ^ (1 + ε) * (N : ℝ) ^ (-1 - ε)) := by rw [hsplit]
    _ = (2 : ℝ) ^ (1 + ε) * ((N : ℝ) ^ (-ε)) := by rw [← hNpow]; ring
    _ ≤ 4 * 1 := mul_le_mul h2e hNeps (by positivity) (by norm_num)
    _ = 4 := by norm_num

/-- The `p`-series tail bound: `Σ_{n ≥ X} n^{−1−ε} ≤ (X−1)^{−ε}/ε` for `X ≥ 2`. -/
lemma tsum_abelWeight_tail_le {ε : ℝ} (hε : 0 < ε) {X : ℕ} (hX : 2 ≤ X) :
    ∑' n : ℕ, abelWeight ε (n + X) ≤ (((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε := by
  have h1 : (1 : ℝ) < 1 + ε := by linarith
  have hX1 : 1 ≤ X - 1 := by omega
  have h := TppLean.tsum_tail_le (p := 1 + ε) h1 (X - 1) hX1
  have heq : (∑' n : ℕ, abelWeight ε (n + X))
      = ∑' k : ℕ, (((k + (X - 1) + 1 : ℕ)) : ℝ) ^ (-(1 + ε)) := by
    refine tsum_congr (fun n => ?_)
    rw [abelWeight]
    have h1 : (n + X : ℕ) = n + (X - 1) + 1 := by omega
    have h2 : (-1 - ε : ℝ) = -(1 + ε) := by ring
    rw [h1, h2]
  rw [heq]
  refine h.trans_eq ?_
  rw [show (1 : ℝ) - (1 + ε) = -ε by ring]
  congr 1
  ring

/-! ## 5. Sums of weight gaps -/

/-- For `n ≥ 1`, the weight gap is `w n − w (n+1)`. -/
lemma abelWeight_gap_eq {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) :
    |abelWeight ε (n + 1) - abelWeight ε n| = abelWeight ε n - abelWeight ε (n + 1) := by
  rw [abs_sub_comm]
  exact abs_of_nonneg (abelWeight_diff_nonneg hε hn)

/-- **The gaps telescope**: `Σ_{n<X} |w(n+1) − w n| ≤ 2` for `X ≥ 1`. -/
lemma sum_abelWeight_gap_le {ε : ℝ} (hε : 0 < ε) {X : ℕ} (hX : 1 ≤ X) :
    ∑ n ∈ Finset.range X, |abelWeight ε (n + 1) - abelWeight ε n| ≤ 2 := by
  have hXeq : X = (X - 1) + 1 := (Nat.sub_add_cancel hX).symm
  rw [hXeq, Finset.sum_range_succ']
  have hzero : |abelWeight ε (0 + 1) - abelWeight ε 0| = 1 := by
    rw [abelWeight_one, abelWeight_zero hε, sub_zero, abs_one]
  rw [hzero]
  have htel : ∑ i ∈ Finset.range (X - 1),
      |abelWeight ε (i + 1 + 1) - abelWeight ε (i + 1)|
      = abelWeight ε 1 - abelWeight ε X := by
    have h1 : ∀ i ∈ Finset.range (X - 1),
        |abelWeight ε (i + 1 + 1) - abelWeight ε (i + 1)|
          = abelWeight ε (i + 1) - abelWeight ε (i + 1 + 1) :=
      fun i _ => abelWeight_gap_eq hε (Nat.le_add_left 1 i)
    rw [Finset.sum_congr rfl h1]
    have h2 : ∑ i ∈ Finset.range (X - 1),
        (abelWeight ε (i + 1) - abelWeight ε (i + 1 + 1))
        = -(∑ i ∈ Finset.range (X - 1),
            (abelWeight ε (i + 1 + 1) - abelWeight ε (i + 1))) := by
      rw [← Finset.sum_neg_distrib]
      exact Finset.sum_congr rfl (fun i _ => by ring)
    rw [h2]
    rw [show (∑ i ∈ Finset.range (X - 1),
          (abelWeight ε (i + 1 + 1) - abelWeight ε (i + 1)))
        = abelWeight ε ((X - 1) + 1) - abelWeight ε (0 + 1) from
      Finset.sum_range_sub (f := fun i => abelWeight ε (i + 1)) (X - 1)]
    rw [show X - 1 + 1 = X by omega]
    norm_num
  rw [htel, abelWeight_one]
  have hXpos : (0 : ℝ) ≤ abelWeight ε X := Real.rpow_nonneg (Nat.cast_nonneg X) _
  linarith

/-! ## 6. The truncated Abel bound -/

/-- Partial sums of a sequence bounded by `1` are bounded by the index. -/
lemma abs_partSum_le (f : ℕ → ℝ) (hf : ∀ n, |f n| ≤ 1) (n : ℕ) :
    |partSum f n| ≤ (n : ℝ) := by
  calc |partSum f n| = |∑ i ∈ Finset.range n, f i| := by rw [partSum]
    _ ≤ ∑ i ∈ Finset.range n, |f i| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i ∈ Finset.range n, (1 : ℝ) := Finset.sum_le_sum (fun i _ => hf i)
    _ = (n : ℝ) := by simp

/-- **The truncated Abel bound.**  If the partial sums of a bounded `f` are `≤ δ·n` from
`X` on, then every Abel sum is bounded uniformly in `N`, by
`4δ + 2X + 2(1+ε)δ·(X−1)^{−ε}/ε`. -/
lemma abel_partial_bound {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1)
    {δ : ℝ} (hδ : 0 ≤ δ) {X N : ℕ} (hX : 2 ≤ X) (hXN : X < N)
    (hM : ∀ n, X ≤ n → |partSum f n| ≤ δ * n)
    {ε : ℝ} (hε0 : 0 < ε) (hε1 : ε ≤ 1) :
    |∑ n ∈ Finset.range N, f n * abelWeight ε n|
      ≤ 4 * δ + 2 * X + 2 * (1 + ε) * δ * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) := by
  have hN2 : 2 ≤ N := by omega
  have hN1 : 1 ≤ N := by omega
  have hwabs : ∀ n : ℕ, |abelWeight ε n| = abelWeight ε n := fun n =>
    abs_of_nonneg (Real.rpow_nonneg (Nat.cast_nonneg n) _)
  -- the boundary term
  have hbd : |partSum f N * abelWeight ε (N - 1)| ≤ 4 * δ := by
    rw [abs_mul, hwabs]
    calc |partSum f N| * abelWeight ε (N - 1)
        ≤ (δ * N) * abelWeight ε (N - 1) :=
          mul_le_mul_of_nonneg_right (hM N (le_of_lt hXN)) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
      _ = δ * ((N : ℝ) * abelWeight ε (N - 1)) := by ring
      _ ≤ δ * 4 := mul_le_mul_of_nonneg_left (mul_abelWeight_pred_le hε0 hε1 hN2) hδ
      _ = 4 * δ := by ring
  -- split the summation-by-parts sum at `X`
  have hsplit : (∑ n ∈ Finset.range (N - 1),
        partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n))
      = (∑ n ∈ Finset.range X,
          partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n))
        + (∑ n ∈ Finset.range (N - 1 - X),
            partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n))) := by
    have hNX : X + (N - 1 - X) = N - 1 := by omega
    rw [← Finset.sum_range_add, hNX]
  -- the small part
  have hsmall : |∑ n ∈ Finset.range X,
      partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n)| ≤ 2 * X := by
    calc |∑ n ∈ Finset.range X,
          partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n)|
        ≤ ∑ n ∈ Finset.range X,
            |partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n)| :=
          Finset.abs_sum_le_sum_abs _ _
      _ = ∑ n ∈ Finset.range X,
            |partSum f (n + 1)| * |abelWeight ε (n + 1) - abelWeight ε n| := by
          refine Finset.sum_congr rfl (fun n _ => ?_); rw [abs_mul]
      _ ≤ ∑ n ∈ Finset.range X,
            (X : ℝ) * |abelWeight ε (n + 1) - abelWeight ε n| := by
          refine Finset.sum_le_sum (fun n hn => ?_)
          have hnX : n + 1 ≤ X := by
            have := Finset.mem_range.mp hn; omega
          have h1 : |partSum f (n + 1)| ≤ (X : ℝ) :=
            le_trans (abs_partSum_le f hf (n + 1)) (by exact_mod_cast hnX)
          exact mul_le_mul_of_nonneg_right h1 (abs_nonneg _)
      _ = (X : ℝ) * ∑ n ∈ Finset.range X,
            |abelWeight ε (n + 1) - abelWeight ε n| := by rw [Finset.mul_sum]
      _ ≤ (X : ℝ) * 2 :=
          mul_le_mul_of_nonneg_left (sum_abelWeight_gap_le hε0 (by omega)) (by positivity)
      _ = 2 * X := by ring
  -- the far part
  have hfar : |∑ n ∈ Finset.range (N - 1 - X),
      partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n))|
      ≤ 2 * (1 + ε) * δ * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) := by
    have hterm : ∀ n : ℕ, |partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n))|
        ≤ 2 * (1 + ε) * δ * abelWeight ε (n + X) := by
      intro n
      have h1 : X ≤ X + n + 1 := by omega
      have h2 : |partSum f (X + n + 1)| ≤ δ * ((X + n + 1 : ℕ) : ℝ) := hM _ h1
      have h3 : |abelWeight ε (X + n + 1) - abelWeight ε (X + n)|
          ≤ (1 + ε) * ((X + n : ℕ) : ℝ) ^ (-2 - ε) :=
        abelWeight_abs_diff_le hε0 (by omega)
      have h4 : (0 : ℝ) < ((X + n : ℕ) : ℝ) := by positivity
      have h5 : ((X + n + 1 : ℕ) : ℝ) * (((X + n : ℕ)) : ℝ) ^ (-2 - ε)
          ≤ 2 * (((X + n : ℕ)) : ℝ) ^ (-1 - ε) := by
        have hcast : ((X + n + 1 : ℕ) : ℝ) = ((X + n : ℕ) : ℝ) + 1 := by push_cast; ring
        rw [hcast]
        have hx1 : (1 : ℝ) ≤ ((X + n : ℕ) : ℝ) := by exact_mod_cast (by omega : 1 ≤ X + n)
        have hx2 : ((X + n : ℕ) : ℝ) ^ (-2 - ε)
            = (((X + n : ℕ)) : ℝ) ^ (-1 - ε) * (((X + n : ℕ)) : ℝ) ^ (-1 : ℝ) := by
          rw [← Real.rpow_add (by positivity : (0:ℝ) < ((X + n : ℕ) : ℝ))]
          congr 1
          ring
        rw [hx2, Real.rpow_neg_one]
        have hpos : (0 : ℝ) < (((X + n : ℕ)) : ℝ) ^ (-1 - ε) :=
          Real.rpow_pos_of_pos (by positivity) _
        have hxn : (1 : ℝ) ≤ ((X + n : ℕ) : ℝ) := hx1
        have h7 : (((X + n : ℕ)) : ℝ) + 1 ≤ 2 * (((X + n : ℕ)) : ℝ) := by linarith
        calc ((((X + n : ℕ)) : ℝ) + 1)
              * ((((X + n : ℕ)) : ℝ) ^ (-1 - ε) * (((X + n : ℕ)) : ℝ)⁻¹)
            = ((((X + n : ℕ)) : ℝ) + 1) * (((X + n : ℕ)) : ℝ)⁻¹
                * (((X + n : ℕ)) : ℝ) ^ (-1 - ε) := by ring
          _ ≤ 2 * (((X + n : ℕ)) : ℝ) ^ (-1 - ε) := by
              refine mul_le_mul_of_nonneg_right ?_ (le_of_lt hpos)
              have hinv : (((X + n : ℕ)) : ℝ)⁻¹ ≤ 1 := by
                rw [inv_le_one₀ (by positivity)]; exact hx1
              rw [add_mul, one_mul, mul_inv_cancel₀ (by positivity : ((X + n : ℕ) : ℝ) ≠ 0)]
              linarith
      calc |partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n))|
          = |partSum f (X + n + 1)| * |abelWeight ε (X + n + 1) - abelWeight ε (X + n)| := by
            rw [abs_mul]
        _ ≤ (δ * ((X + n + 1 : ℕ) : ℝ)) * ((1 + ε) * ((X + n : ℕ) : ℝ) ^ (-2 - ε)) :=
            mul_le_mul h2 h3 (abs_nonneg _) (by positivity)
        _ = δ * (1 + ε) * (((X + n + 1 : ℕ) : ℝ) * (((X + n : ℕ)) : ℝ) ^ (-2 - ε)) := by ring
        _ ≤ δ * (1 + ε) * (2 * (((X + n : ℕ)) : ℝ) ^ (-1 - ε)) := by
            have h6 : (0 : ℝ) ≤ δ * (1 + ε) := by positivity
            exact mul_le_mul_of_nonneg_left h5 h6
        _ = 2 * (1 + ε) * δ * abelWeight ε (n + X) := by
            rw [abelWeight]
            have hcast : n + X = X + n := by omega
            rw [hcast]
            ring
    calc |∑ n ∈ Finset.range (N - 1 - X),
          partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n))|
        ≤ ∑ n ∈ Finset.range (N - 1 - X),
            |partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n))| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ n ∈ Finset.range (N - 1 - X), 2 * (1 + ε) * δ * abelWeight ε (n + X) :=
          Finset.sum_le_sum (fun n _ => hterm n)
      _ ≤ ∑' n : ℕ, 2 * (1 + ε) * δ * abelWeight ε (n + X) := by
          have hs : Summable fun n : ℕ => 2 * (1 + ε) * δ * abelWeight ε (n + X) :=
            ((summable_abelWeight hε0).comp_injective (fun a b hab => by omega)).mul_left _
          exact hs.sum_le_tsum _ (fun i _ =>
            mul_nonneg (by positivity) (Real.rpow_nonneg (Nat.cast_nonneg _) _))
      _ = 2 * (1 + ε) * δ * ∑' n : ℕ, abelWeight ε (n + X) := tsum_mul_left
      _ ≤ 2 * (1 + ε) * δ * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) :=
          mul_le_mul_of_nonneg_left (tsum_abelWeight_tail_le hε0 hX) (by positivity)
  rw [sum_mul_eq]
  calc |partSum f N * abelWeight ε (N - 1)
        - ∑ n ∈ Finset.range (N - 1),
            partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n)|
      ≤ |partSum f N * abelWeight ε (N - 1)|
        + |∑ n ∈ Finset.range (N - 1),
            partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n)| := by
        have := abs_add_le (partSum f N * abelWeight ε (N - 1))
          (-(∑ n ∈ Finset.range (N - 1),
            partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n)))
        simpa [sub_eq_add_neg] using this
    _ = |partSum f N * abelWeight ε (N - 1)|
        + |(∑ n ∈ Finset.range X,
              partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n))
            + (∑ n ∈ Finset.range (N - 1 - X),
              partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n)))| := by
        rw [hsplit]
    _ ≤ 4 * δ + (2 * X + 2 * (1 + ε) * δ * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε)) := by
        refine add_le_add hbd ?_
        have := abs_add_le (∑ n ∈ Finset.range X,
            partSum f (n + 1) * (abelWeight ε (n + 1) - abelWeight ε n))
          (∑ n ∈ Finset.range (N - 1 - X),
            partSum f (X + n + 1) * (abelWeight ε (X + n + 1) - abelWeight ε (X + n)))
        exact le_trans this (add_le_add hsmall hfar)
    _ = 4 * δ + 2 * X + 2 * (1 + ε) * δ * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) := by ring

/-! ## 7. The infinite Abel bound, and the Cesàro → Abel implication -/

/-- The truncated bound passes to the limit `N → ∞`. -/
lemma abel_tsum_bound {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1)
    {δ : ℝ} (hδ : 0 ≤ δ) {X : ℕ} (hX : 2 ≤ X)
    (hM : ∀ n, X ≤ n → |partSum f n| ≤ δ * n)
    {ε : ℝ} (hε0 : 0 < ε) (hε1 : ε ≤ 1) :
    |∑' n, f n * abelWeight ε n|
      ≤ 4 * δ + 2 * X + 2 * (1 + ε) * δ * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) := by
  have hlim : Tendsto (fun N : ℕ => |∑ n ∈ Finset.range N, f n * abelWeight ε n|) atTop
      (𝓝 |∑' n, f n * abelWeight ε n|) := by
    have h : Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, f n * abelWeight ε n) atTop
        (𝓝 (∑' n, f n * abelWeight ε n)) :=
      (summable_mul_abelWeight hf hε0).hasSum.tendsto_sum_nat
    exact (continuous_abs.tendsto (∑' n, f n * abelWeight ε n)).comp h
  refine le_of_tendsto_of_tendsto hlim tendsto_const_nhds ?_
  filter_upwards [eventually_gt_atTop X] with N hN
  exact abel_partial_bound hf hδ hX hN hM hε0 hε1

/-- **Cesàro ⟹ Abel.**  If the Cesàro mean of a bounded `f` vanishes, then so does its
Abelian mean `ε Σ f(n) n^{−1−ε}` as `ε → 0⁺`.  In particular `Σ_{n≤x} λ(n)λ(n+2) = o(x)`
implies the vanishing of the cone residue. -/
theorem abelMean_tendsto_zero {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1)
    (hces : Tendsto (fun N : ℕ => partSum f N / N) atTop (𝓝 0)) :
    Tendsto (fun ε : ℝ => abelMean f ε) (𝓝[>] 0) (𝓝 0) := by
  rw [Metric.tendsto_nhds]
  intro η hη
  have hδpos : (0 : ℝ) < η / 16 := by linarith
  -- from the Cesàro hypothesis, get `X` with `|M n| ≤ (η/16) n` for `n ≥ X`
  have hev : ∀ᶠ N : ℕ in atTop, |partSum f N| ≤ (η / 16) * N := by
    have h := (Metric.tendsto_nhds.mp hces) (η / 16) hδpos
    filter_upwards [h, eventually_gt_atTop 0] with N hN hN0
    have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN0
    rw [Real.dist_eq, sub_zero, abs_div, abs_of_pos hNpos, div_lt_iff₀ hNpos] at hN
    exact le_of_lt hN
  obtain ⟨X, hX2, hXM⟩ : ∃ X : ℕ, 2 ≤ X ∧ ∀ n, X ≤ n → |partSum f n| ≤ (η / 16) * n := by
    rcases Filter.eventually_atTop.mp hev with ⟨X₀, hX₀⟩
    exact ⟨max X₀ 2, le_max_right _ _, fun n hn => hX₀ n (le_trans (le_max_left _ _) hn)⟩
  have hX1 : (1 : ℝ) ≤ (((X - 1 : ℕ)) : ℝ) := by
    have : 1 ≤ X - 1 := by omega
    exact_mod_cast this
  set ε₀ : ℝ := min 1 (η / (4 * (η / 4 + 2 * X))) with hε₀def
  have hε₀pos : (0 : ℝ) < ε₀ := by
    rw [hε₀def]
    refine lt_min_iff.mpr ⟨by norm_num, ?_⟩
    have : (0 : ℝ) < 4 * (η / 4 + 2 * X) := by positivity
    exact div_pos hη this
  refine mem_of_superset (Ioo_mem_nhdsGT hε₀pos) ?_
  intro ε hε
  obtain ⟨hε0, hεlt⟩ := hε
  have hε1 : ε ≤ 1 := le_of_lt (lt_of_lt_of_le hεlt (min_le_left _ _))
  have hε2 : ε ≤ η / (4 * (η / 4 + 2 * X)) :=
    le_of_lt (lt_of_lt_of_le hεlt (min_le_right _ _))
  have hδnn : (0 : ℝ) ≤ η / 16 := le_of_lt hδpos
  have hpowε : ((((X - 1 : ℕ)) : ℝ)) ^ (-ε) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos hX1 (by linarith)
  have hbound := abel_tsum_bound hf hδnn hX2 hXM hε0 hε1
  simp only [Set.mem_ofPred_eq]
  rw [Real.dist_eq, sub_zero]
  calc |abelMean f ε| = ε * |∑' n, f n * abelWeight ε n| := by
        rw [abelMean, abs_mul, abs_of_pos hε0]
    _ ≤ ε * (4 * (η / 16) + 2 * X
          + 2 * (1 + ε) * (η / 16) * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε)) :=
        mul_le_mul_of_nonneg_left hbound (le_of_lt hε0)
    _ = ε * (4 * (η / 16) + 2 * X)
          + 2 * (1 + ε) * (η / 16) * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) * ε := by ring
    _ ≤ η / 4 + η / 4 := add_le_add (by
          have heq : 4 * (η / 16) + 2 * X = η / 4 + 2 * X := by ring
          have hpos2 : (0 : ℝ) < η / 4 + 2 * X := by positivity
          have hle : ε * (η / 4 + 2 * X)
              ≤ (η / (4 * (η / 4 + 2 * X))) * (η / 4 + 2 * X) :=
            mul_le_mul_of_nonneg_right hε2 (le_of_lt hpos2)
          have hval : (η / (4 * (η / 4 + 2 * X))) * (η / 4 + 2 * X) = η / 4 := by
            field_simp
          rw [heq]
          exact le_trans hle hval.le) (by
          have h3 : ((((X - 1 : ℕ)) : ℝ)) ^ (-ε) / ε * ε = ((((X - 1 : ℕ)) : ℝ)) ^ (-ε) := by
            field_simp
          have h8 : (0 : ℝ) ≤ 2 * (1 + ε) * (η / 16) := by positivity
          have h9 : 2 * (1 + ε) * (η / 16) * ((((X - 1 : ℕ)) : ℝ)) ^ (-ε)
              ≤ 2 * (1 + ε) * (η / 16) * 1 := mul_le_mul_of_nonneg_left hpowε h8
          have h5 : (1 + ε) ≤ 2 := by linarith
          have h6 : (0 : ℝ) ≤ η / 16 := le_of_lt hδpos
          calc 2 * (1 + ε) * (η / 16) * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε) * ε
              = 2 * (1 + ε) * (η / 16) * ((((X - 1 : ℕ)) : ℝ) ^ (-ε) / ε * ε) := by ring
            _ = 2 * (1 + ε) * (η / 16) * ((((X - 1 : ℕ)) : ℝ)) ^ (-ε) := by rw [h3]
            _ ≤ 2 * (1 + ε) * (η / 16) * 1 := h9
            _ ≤ 2 * 2 * (η / 16) * 1 := by nlinarith [h5, h6]
            _ = η / 4 := by ring)
    _ = η / 2 := by ring
    _ < η := by linarith

/-! ## 8. The log-averaged input (Tao's log-averaged two-point Chowla) -/

/-- Partial sums of `f n / n`: the numerators of the logarithmic average,
`g(N) = Σ_{n<N} f n / n`. -/
noncomputable def logPartSum (f : ℕ → ℝ) (N : ℕ) : ℝ := ∑ n ∈ Finset.range N, f n / n

/-- The gap bound for the weight `n ↦ n^{−ε}`: `n^{−ε} − (n+1)^{−ε} ≤ ε·n^{−1−ε}`. -/
lemma rpow_neg_gap_le {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) :
    (n : ℝ) ^ (-ε) - ((n : ℝ) + 1) ^ (-ε) ≤ ε * (n : ℝ) ^ (-1 - ε) := by
  have hn0 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have hderiv : ∀ x ∈ Set.Icc (n : ℝ) ((n + 1 : ℕ) : ℝ),
      HasDerivWithinAt (fun x : ℝ => x ^ (-ε)) ((-ε) * x ^ (-1 - ε))
        (Set.Icc (n : ℝ) ((n + 1 : ℕ) : ℝ)) x := by
    intro x hx
    have hx0 : x ≠ 0 := ne_of_gt (lt_of_lt_of_le hn0 hx.1)
    have hd := Real.hasDerivAt_rpow_const (x := x) (p := -ε) (Or.inl hx0)
    have hval : (-ε) * x ^ (-ε - 1) = (-ε) * x ^ (-1 - ε) := by
      rw [show -ε - 1 = -1 - ε by ring]
    rw [hval] at hd
    exact hd.hasDerivWithinAt
  have hbound : ∀ x ∈ Set.Ico (n : ℝ) ((n + 1 : ℕ) : ℝ),
      ‖((-ε) * x ^ (-1 - ε) : ℝ)‖ ≤ ε * (n : ℝ) ^ (-1 - ε) := by
    intro x hx
    have hx0 : (0 : ℝ) < x := lt_of_lt_of_le hn0 hx.1
    have hmono : x ^ (-1 - ε) ≤ (n : ℝ) ^ (-1 - ε) :=
      Real.rpow_le_rpow_of_nonpos hn0 hx.1 (show -1 - ε ≤ 0 by linarith)
    have hnn : (0 : ℝ) ≤ x ^ (-1 - ε) := Real.rpow_nonneg (le_of_lt hx0) _
    rw [norm_mul, norm_neg, Real.norm_eq_abs, abs_of_pos hε, Real.norm_eq_abs,
      abs_of_nonneg hnn]
    exact mul_le_mul_of_nonneg_left hmono (le_of_lt hε)
  have hmain := norm_image_sub_le_of_norm_deriv_le_segment' hderiv hbound
    ((n + 1 : ℕ) : ℝ) ⟨by push_cast; linarith, le_rfl⟩
  have hcast : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by push_cast; ring
  rw [hcast, add_sub_cancel_left, mul_one] at hmain
  have hle : (n : ℝ) ^ (-ε) - ((n : ℝ) + 1) ^ (-ε)
      ≤ ‖(((n : ℝ) + 1) ^ (-ε) - (n : ℝ) ^ (-ε) : ℝ)‖ := by
    rw [Real.norm_eq_abs, abs_sub_comm]
    exact le_abs_self (((n : ℝ) ^ (-ε) - ((n : ℝ) + 1) ^ (-ε) : ℝ))
  exact hle.trans hmain

/-- **Abel summation in log form**: summing against `n^{−1−ε}` is the same as summing the
log-average numerators `g(n) = Σ_{i<n} f i / i` against the gaps of `n^{−ε}`. -/
lemma log_abel (f : ℕ → ℝ) {ε : ℝ} (hε : 0 < ε) (N : ℕ) :
    ∑ n ∈ Finset.range N, f n * (n : ℝ) ^ (-1 - ε)
      = logPartSum f N * (((N - 1 : ℕ)) : ℝ) ^ (-ε)
        + ∑ n ∈ Finset.range (N - 1),
            logPartSum f (n + 1) * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)) := by
  have hterm : ∀ n ∈ Finset.range N, f n * (n : ℝ) ^ (-1 - ε)
      = (f n / n) * (n : ℝ) ^ (-ε) := by
    intro n _
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · rw [Nat.cast_zero, Real.zero_rpow (by linarith : (-1 : ℝ) - ε ≠ 0),
        Real.zero_rpow (by linarith : (-ε : ℝ) ≠ 0)]
      ring
    · have hn0 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
      rw [div_eq_mul_inv, mul_assoc, ← Real.rpow_neg_one, ← Real.rpow_add hn0]
      ring
  rw [Finset.sum_congr rfl hterm,
    sum_mul_eq (fun n => f n / n) (fun n => (n : ℝ) ^ (-ε)) N]
  simp only [partSum, logPartSum]
  rw [sub_eq_add_neg, ← Finset.sum_neg_distrib]
  congr 1
  refine Finset.sum_congr rfl (fun n _ => ?_)
  ring

/-! ## 9. The log-weighted tail bound -/

/-- The termwise log bound: for `m ≥ 2`, `log(m+1)·m^{−1−ε} ≤ (4/ε)·m^{−1−ε/2}`. -/
lemma log_abelWeight_le {ε : ℝ} (hε0 : 0 < ε) (hε1 : ε ≤ 1) (m : ℕ) (hm : 2 ≤ m) :
    Real.log ((m : ℝ) + 1) * abelWeight ε m ≤ (4 / ε) * abelWeight (ε / 2) m := by
  have hε2 : (0 : ℝ) < ε / 2 := by linarith
  have hε2one : ε / 2 ≤ 1 := by linarith
  have hm1 : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast (by omega : 1 ≤ m)
  have hmpos : (0 : ℝ) < (m : ℝ) := by linarith
  have hm1pos : (0 : ℝ) ≤ (m : ℝ) + 1 := by linarith
  have hlog : Real.log ((m : ℝ) + 1) ≤ (4 / ε) * (m : ℝ) ^ (ε / 2) := by
    have h1 := Real.log_le_rpow_div hm1pos hε2
    have h2 : ((m : ℝ) + 1) ^ (ε / 2) ≤ 2 * (m : ℝ) ^ (ε / 2) := by
      have hbase : (m : ℝ) + 1 ≤ 2 * (m : ℝ) := by linarith
      have h3 : ((m : ℝ) + 1) ^ (ε / 2) ≤ (2 * (m : ℝ)) ^ (ε / 2) :=
        Real.rpow_le_rpow (by linarith) hbase (le_of_lt hε2)
      have h4 : (2 * (m : ℝ)) ^ (ε / 2) = (2 : ℝ) ^ (ε / 2) * (m : ℝ) ^ (ε / 2) :=
        Real.mul_rpow (by norm_num) (le_of_lt hmpos)
      have h5 : (2 : ℝ) ^ (ε / 2) ≤ 2 := by
        have h6 : (2 : ℝ) ^ (ε / 2) ≤ (2 : ℝ) ^ (1 : ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) hε2one
        simpa using h6
      rw [h4] at h3
      nlinarith [h3, h5, Real.rpow_nonneg (le_of_lt hmpos) (ε / 2)]
    calc Real.log ((m : ℝ) + 1) ≤ ((m : ℝ) + 1) ^ (ε / 2) / (ε / 2) := h1
      _ ≤ (2 * (m : ℝ) ^ (ε / 2)) / (ε / 2) :=
          div_le_div_of_nonneg_right h2 (le_of_lt hε2)
      _ = (4 / ε) * (m : ℝ) ^ (ε / 2) := by ring
  have hpow : (m : ℝ) ^ (ε / 2) * (m : ℝ) ^ (-1 - ε) = (m : ℝ) ^ (-1 - ε / 2) := by
    rw [← Real.rpow_add hmpos]
    congr 1
    ring
  have habel : abelWeight ε m = (m : ℝ) ^ (-1 - ε) := rfl
  have habel2 : abelWeight (ε / 2) m = (m : ℝ) ^ (-1 - ε / 2) := rfl
  rw [habel, habel2]
  calc Real.log ((m : ℝ) + 1) * (m : ℝ) ^ (-1 - ε)
      ≤ ((4 / ε) * (m : ℝ) ^ (ε / 2)) * (m : ℝ) ^ (-1 - ε) :=
        mul_le_mul_of_nonneg_right hlog (Real.rpow_nonneg (le_of_lt hmpos) _)
    _ = (4 / ε) * ((m : ℝ) ^ (ε / 2) * (m : ℝ) ^ (-1 - ε)) := by ring
    _ = (4 / ε) * (m : ℝ) ^ (-1 - ε / 2) := by rw [hpow]

/-- **The log-weighted tail is bounded by a constant**: for `ε ∈ (0,1]` and `X ≥ 2`,
`ε² Σ_{n≥X} log(n+1)·n^{−1−ε} ≤ 8`.  (The point of the constant is that it does *not*
grow as `ε → 0`, which is what lets the log-average hypothesis control the Abelian
mean.) -/
lemma sq_mul_log_tail_le {ε : ℝ} (hε0 : 0 < ε) (hε1 : ε ≤ 1) {X : ℕ} (hX : 2 ≤ X) :
    ε ^ 2 * ∑' k : ℕ, Real.log (((k + X : ℕ)) + 1) * abelWeight ε (k + X) ≤ 8 := by
  have hε2 : (0 : ℝ) < ε / 2 := by linarith
  have hε2one : ε / 2 ≤ 1 := by linarith
  have hterm := fun k => log_abelWeight_le hε0 hε1 (k + X) (by omega)
  -- summability and the tail bound
  have hsum2 : Summable fun k : ℕ => abelWeight (ε / 2) (k + X) :=
    (summable_abelWeight hε2).comp_injective (fun a b hab => by omega)
  have hsum1 : Summable fun k : ℕ =>
      Real.log (((k + X : ℕ)) + 1) * abelWeight ε (k + X) := by
    refine Summable.of_norm_bounded (hsum2.mul_left (4 / ε)) (fun k => ?_)
    have hlogpos : (0 : ℝ) ≤ Real.log (((k + X : ℕ)) + 1) :=
      Real.log_nonneg (by exact_mod_cast (by omega : 1 ≤ k + X + 1))
    have hwpos : (0 : ℝ) ≤ abelWeight ε (k + X) := Real.rpow_nonneg (Nat.cast_nonneg _) _
    rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg hlogpos hwpos)]
    exact hterm k
  have hmain := Summable.tsum_le_tsum hterm hsum1 (hsum2.mul_left (4 / ε))
  have htail := tsum_abelWeight_tail_le (ε := ε / 2) hε2 hX
  have hnonneg : (0 : ℝ) ≤ ∑' k : ℕ, abelWeight (ε / 2) (k + X) :=
    tsum_nonneg (fun k => Real.rpow_nonneg (Nat.cast_nonneg _) _)
  have hX1 : (1 : ℝ) ≤ (((X - 1 : ℕ)) : ℝ) := by
    have : 1 ≤ X - 1 := by omega
    exact_mod_cast this
  have hpowX : ((((X - 1 : ℕ)) : ℝ)) ^ (-ε / 2) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos hX1 (by linarith)
  calc ε ^ 2 * ∑' k : ℕ, Real.log (((k + X : ℕ)) + 1) * abelWeight ε (k + X)
      ≤ ε ^ 2 * ∑' k : ℕ, (4 / ε) * abelWeight (ε / 2) (k + X) :=
        mul_le_mul_of_nonneg_left hmain (by positivity)
    _ = ε ^ 2 * ((4 / ε) * ∑' k : ℕ, abelWeight (ε / 2) (k + X)) := by
        rw [tsum_mul_left]
    _ ≤ ε ^ 2 * ((4 / ε) * ((((X - 1 : ℕ)) : ℝ) ^ (-(ε / 2)) / (ε / 2))) := by
        refine mul_le_mul_of_nonneg_left ?_ (by positivity)
        exact mul_le_mul_of_nonneg_left htail (by positivity)
    _ = 8 * ((((X - 1 : ℕ)) : ℝ) ^ (-ε / 2)) := by
        rw [show -(ε / 2) = -ε / 2 by ring]
        field_simp
        ring
    _ ≤ 8 * 1 := mul_le_mul_of_nonneg_left hpowX (by norm_num)
    _ = 8 := by ring

/-! ## 10. The partial-sum bound in log form -/

/-- The log-weight gap is non-negative for `n ≥ 1`. -/
lemma rpow_neg_gap_nonneg {ε : ℝ} (hε : 0 < ε) {n : ℕ} (hn : 1 ≤ n) :
    0 ≤ (n : ℝ) ^ (-ε) - ((n : ℝ) + 1) ^ (-ε) := by
  have h1 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have h2 : (n : ℝ) ≤ (n : ℝ) + 1 := by linarith
  have h3 := Real.rpow_le_rpow_of_nonpos h1 h2 (show -ε ≤ 0 by linarith)
  linarith

/-- **The log-form partial bound**: the Abel sum is controlled by the log-average
numerators `g` against the gaps of `n^{−ε}`. -/
lemma log_abel_partial_le {f : ℕ → ℝ} {ε : ℝ} (hε : 0 < ε) (N : ℕ) :
    |∑ n ∈ Finset.range N, f n * (n : ℝ) ^ (-1 - ε)|
      ≤ |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε)
        + ∑ n ∈ Finset.range (N - 1),
            |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)) := by
  rw [log_abel f hε N]
  have hbd : |logPartSum f N * (((N - 1 : ℕ)) : ℝ) ^ (-ε)|
      ≤ |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε) := by
    rw [abs_mul, abs_of_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _)]
  refine le_trans (abs_add_le _ _) (add_le_add hbd ?_)
  calc |∑ n ∈ Finset.range (N - 1),
        logPartSum f (n + 1) * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε))|
      ≤ ∑ n ∈ Finset.range (N - 1),
          |logPartSum f (n + 1) * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε))| :=
        Finset.abs_sum_le_sum_abs _ _
    _ = ∑ n ∈ Finset.range (N - 1),
          |logPartSum f (n + 1)| * |(n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)| := by
        refine Finset.sum_congr rfl (fun n _ => ?_); rw [abs_mul]
    _ ≤ ∑ n ∈ Finset.range (N - 1),
          |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)) := by
        refine Finset.sum_le_sum (fun n _ => ?_)
        rcases Nat.eq_zero_or_pos n with rfl | hn
        · simp [logPartSum]
        · have hcast : (((n + 1 : ℕ)) : ℝ) = (n : ℝ) + 1 := by push_cast; ring
          rw [hcast, abs_of_nonneg (rpow_neg_gap_nonneg hε hn)]

/-! ## 11. The log-average input bounds the Abel sum -/

/-- Auxiliary: `log N · N^{−ε} → 0`. -/
lemma tendsto_log_mul_rpow_neg {ε : ℝ} (hε : 0 < ε) :
    Tendsto (fun N : ℕ => Real.log N * (N : ℝ) ^ (-ε)) atTop (𝓝 0) := by
  have hε2 : (0 : ℝ) < ε / 2 := by linarith
  have hbound : ∀ N : ℕ, 1 ≤ N → Real.log N * (N : ℝ) ^ (-ε)
      ≤ (2 / ε) * (N : ℝ) ^ (-ε / 2) := by
    intro N hN
    have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
    have hlog : Real.log (N : ℝ) ≤ ((N : ℝ)) ^ (ε / 2) / (ε / 2) :=
      Real.log_le_rpow_div (le_of_lt hNpos) hε2
    have hsplit : (N : ℝ) ^ (ε / 2) * (N : ℝ) ^ (-ε) = (N : ℝ) ^ (-ε / 2) := by
      rw [← Real.rpow_add hNpos]
      congr 1
      ring
    calc Real.log N * (N : ℝ) ^ (-ε)
        ≤ (((N : ℝ)) ^ (ε / 2) / (ε / 2)) * (N : ℝ) ^ (-ε) :=
          mul_le_mul_of_nonneg_right hlog (Real.rpow_nonneg (le_of_lt hNpos) _)
      _ = (2 / ε) * ((N : ℝ) ^ (ε / 2) * (N : ℝ) ^ (-ε)) := by ring
      _ = (2 / ε) * (N : ℝ) ^ (-ε / 2) := by rw [hsplit]
  have hlim : Tendsto (fun N : ℕ => (2 / ε) * (N : ℝ) ^ (-ε / 2)) atTop (𝓝 0) := by
    have h1 : Tendsto (fun x : ℝ => x ^ (-ε / 2)) atTop (𝓝 0) := by
      simpa only [neg_div] using tendsto_rpow_neg_atTop hε2
    have h2 : Tendsto (fun N : ℕ => ((N : ℝ))) atTop atTop := tendsto_natCast_atTop_atTop
    have h3 := h1.comp h2
    simpa using h3.const_mul (2 / ε)
  refine squeeze_zero' ?_ ?_ hlim
  · filter_upwards [eventually_ge_atTop 1] with N hN
    exact mul_nonneg (Real.log_nonneg (by exact_mod_cast hN)) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
  · filter_upwards [eventually_ge_atTop 1] with N hN
    exact hbound N hN

/-! ## 12. Log-average ⟹ Abel (deliverable 1b) -/

/-- **The log-average input bounds the Abel sum.**  If `|g(m)| ≤ lam·log m` for `m ≥ X`
then `|Σ' f(n)n^{−1−ε}| ≤ εK + 8·lam/ε`, where `K = Σ_{n<X} |g(n+1)|/n`. -/
lemma abel_tsum_le_of_logAverage {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1)
    {lam : ℝ} (hlam : 0 ≤ lam) {X : ℕ} (hX : 2 ≤ X)
    (hg : ∀ m, X ≤ m → |logPartSum f m| ≤ lam * Real.log m)
    {ε : ℝ} (hε0 : 0 < ε) (hε1 : ε ≤ 1) :
    |∑' n, f n * abelWeight ε n|
      ≤ ε * (∑ n ∈ Finset.range X, |logPartSum f (n + 1)| / (n : ℝ)) + 8 * lam / ε := by
  set K := ∑ n ∈ Finset.range X, |logPartSum f (n + 1)| / (n : ℝ) with hK
  have hgapcast : ∀ n : ℕ, (((n + 1 : ℕ)) : ℝ) = (n : ℝ) + 1 := by
    intro n; push_cast; ring
  -- the partial bound, valid for every `N > X`
  have hpartial : ∀ N : ℕ, X < N →
      |∑ n ∈ Finset.range N, f n * abelWeight ε n| ≤
        |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε) + (ε * K + 8 * lam / ε) := by
    intro N hN
    have h0 := log_abel_partial_le (f := f) hε0 N
    have hNX : X + (N - 1 - X) = N - 1 := by omega
    have hsplit : (∑ n ∈ Finset.range (N - 1),
          |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)))
        = (∑ n ∈ Finset.range X,
            |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)))
          + (∑ k ∈ Finset.range (N - 1 - X),
              |logPartSum f (X + k + 1)| * (((X + k : ℕ) : ℝ) ^ (-ε)
                - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε))) := by
      rw [← Finset.sum_range_add, hNX]
    rw [hsplit] at h0
    -- the small part
    have hsmall : (∑ n ∈ Finset.range X,
          |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)))
        ≤ ε * K := by
      rw [hK, Finset.mul_sum]
      refine Finset.sum_le_sum (fun n _ => ?_)
      rcases Nat.eq_zero_or_pos n with rfl | hn
      · have h1 : logPartSum f (0 + 1) = 0 := by simp [logPartSum]
        rw [h1]
        simp
      · have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
        have hgap : ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε))
            ≤ ε * (n : ℝ) ^ (-1 : ℝ) := by
          rw [hgapcast n]
          have h2 : (n : ℝ) ^ (-1 - ε) ≤ (n : ℝ) ^ (-1 : ℝ) := by
            have h3 : (n : ℝ) ^ (-1 - ε)
                = (n : ℝ) ^ (-1 : ℝ) * (n : ℝ) ^ (-ε) := by
              rw [← Real.rpow_add hnpos, show (-1 : ℝ) + (-ε) = -1 - ε by ring]
            rw [h3]
            have h4 : (n : ℝ) ^ (-ε) ≤ 1 :=
              Real.rpow_le_one_of_one_le_of_nonpos (by exact_mod_cast hn) (by linarith)
            have h5 : (0 : ℝ) < (n : ℝ) ^ (-1 : ℝ) := Real.rpow_pos_of_pos hnpos _
            nlinarith [h4, h5]
          calc (n : ℝ) ^ (-ε) - ((n : ℝ) + 1) ^ (-ε)
              ≤ ε * (n : ℝ) ^ (-1 - ε) := rpow_neg_gap_le hε0 hn
            _ ≤ ε * (n : ℝ) ^ (-1 : ℝ) :=
                mul_le_mul_of_nonneg_left h2 (le_of_lt hε0)
        calc |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε))
            ≤ |logPartSum f (n + 1)| * (ε * (n : ℝ) ^ (-1 : ℝ)) :=
              mul_le_mul_of_nonneg_left hgap (abs_nonneg _)
          _ = ε * (|logPartSum f (n + 1)| / (n : ℝ)) := by
              rw [div_eq_mul_inv, Real.rpow_neg_one]; ring
    -- the far part
    have hfar : (∑ k ∈ Finset.range (N - 1 - X),
          |logPartSum f (X + k + 1)| * (((X + k : ℕ) : ℝ) ^ (-ε)
            - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε))) ≤ 8 * lam / ε := by
      have hlogpos : ∀ k : ℕ, (0 : ℝ) ≤ Real.log (((X + k : ℕ)) + 1) := fun k =>
        Real.log_nonneg (by exact_mod_cast (by omega : 1 ≤ X + k + 1))
      have hterm : ∀ k : ℕ,
          |logPartSum f (X + k + 1)| * (((X + k : ℕ) : ℝ) ^ (-ε)
            - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε))
          ≤ lam * ε * (Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k)) := by
        intro k
        have h1 : |logPartSum f (X + k + 1)| ≤ lam * Real.log (((X + k : ℕ)) + 1) := by
          have h := hg (X + k + 1) (by omega : X ≤ X + k + 1)
          have hc : ((X + k + 1 : ℕ) : ℝ) = ((X + k : ℕ) : ℝ) + 1 := by push_cast; ring
          rwa [hc] at h
        have h2 : (((X + k : ℕ) : ℝ) ^ (-ε) - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε))
            ≤ ε * abelWeight ε (X + k) := by
          rw [hgapcast (X + k), abelWeight]
          exact rpow_neg_gap_le hε0 (by omega)
        have h3 : (0 : ℝ) ≤ ((X + k : ℕ) : ℝ) ^ (-ε)
            - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε) := by
          rw [hgapcast (X + k)]
          exact rpow_neg_gap_nonneg hε0 (by omega)
        calc |logPartSum f (X + k + 1)| * (((X + k : ℕ) : ℝ) ^ (-ε)
              - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε))
            ≤ (lam * Real.log (((X + k : ℕ)) + 1)) * (ε * abelWeight ε (X + k)) :=
              mul_le_mul h1 h2 (by positivity) (mul_nonneg hlam (hlogpos k))
          _ = lam * ε * (Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k)) := by ring
      have hbase : Summable fun k : ℕ => abelWeight (ε / 2) (X + k) := by
        have h := (summable_nat_add_iff X).mpr
          (summable_abelWeight (by linarith : (0 : ℝ) < ε / 2))
        simpa [Nat.add_comm] using h
      have hsumm : Summable fun k : ℕ =>
          Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k) := by
        refine Summable.of_norm_bounded (hbase.mul_left (4 / ε)) (fun k => ?_)
        simp only [abelWeight]
        rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg (hlogpos k)
          (Real.rpow_nonneg (Nat.cast_nonneg (X + k)) (-1 - ε)))]
        exact log_abelWeight_le hε0 hε1 (X + k) (by omega)
      have hbound : ∑' k : ℕ, Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k)
          ≤ 8 / ε ^ 2 := by
        have hpos : (0 : ℝ) < ε ^ 2 := by positivity
        rw [le_div_iff₀ hpos]
        have heq : (∑' k : ℕ, Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k)) * ε ^ 2
            = ε ^ 2 * ∑' k : ℕ, Real.log (((k + X : ℕ)) + 1) * abelWeight ε (k + X) := by
          rw [mul_comm]
          congr 1
          exact tsum_congr (fun k => by rw [show X + k = k + X by omega])
        rw [heq]
        exact sq_mul_log_tail_le hε0 hε1 hX
      calc (∑ k ∈ Finset.range (N - 1 - X),
            |logPartSum f (X + k + 1)| * (((X + k : ℕ) : ℝ) ^ (-ε)
              - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε)))
          ≤ ∑ k ∈ Finset.range (N - 1 - X),
              lam * ε * (Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k)) :=
            Finset.sum_le_sum (fun k _ => hterm k)
        _ = lam * ε * ∑ k ∈ Finset.range (N - 1 - X),
              Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k) := by
            rw [Finset.mul_sum]
        _ ≤ lam * ε * ∑' k : ℕ,
              Real.log (((X + k : ℕ)) + 1) * abelWeight ε (X + k) := by
            refine mul_le_mul_of_nonneg_left ?_ (by positivity)
            exact hsumm.sum_le_tsum _ (fun k _ => mul_nonneg (hlogpos k)
              (Real.rpow_nonneg (Nat.cast_nonneg _) _))
        _ ≤ lam * ε * (8 / ε ^ 2) := mul_le_mul_of_nonneg_left hbound (by positivity)
        _ = 8 * lam / ε := by field_simp
    calc |∑ n ∈ Finset.range N, f n * abelWeight ε n|
        ≤ |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε)
            + ((∑ n ∈ Finset.range X,
                |logPartSum f (n + 1)| * ((n : ℝ) ^ (-ε) - (((n + 1 : ℕ)) : ℝ) ^ (-ε)))
              + (∑ k ∈ Finset.range (N - 1 - X),
                |logPartSum f (X + k + 1)| * (((X + k : ℕ) : ℝ) ^ (-ε)
                  - (((X + k + 1 : ℕ)) : ℝ) ^ (-ε)))) := h0
      _ ≤ |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε) + (ε * K + 8 * lam / ε) :=
          add_le_add le_rfl (add_le_add hsmall hfar)
      _ = |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε) + (ε * K + 8 * lam / ε) := rfl
  -- pass to the limit `N → ∞`
  have hbd0 : Tendsto (fun N : ℕ => |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε))
      atTop (𝓝 0) := by
    have h1 : Tendsto (fun N : ℕ => (2 * lam) * (Real.log N * (N : ℝ) ^ (-ε))) atTop
        (𝓝 ((2 * lam) * 0)) :=
      (tendsto_log_mul_rpow_neg hε0).const_mul (2 * lam)
    rw [mul_zero] at h1
    refine squeeze_zero' ?_ ?_ h1
    · filter_upwards [eventually_ge_atTop 2] with N _
      exact mul_nonneg (abs_nonneg _) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
    · filter_upwards [eventually_ge_atTop X, eventually_ge_atTop 2] with N hNX hN2
      have hN2 : (2 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN2
      have hNpos : (0 : ℝ) < (N : ℝ) := by linarith
      have hle : (((N - 1 : ℕ)) : ℝ) ^ (-ε) ≤ 2 * (N : ℝ) ^ (-ε) := by
        have hcast : (((N - 1 : ℕ)) : ℝ) = (N : ℝ) - 1 := by
          rw [Nat.cast_sub (by omega : 1 ≤ N)]; norm_num
        have hhalf : (N : ℝ) / 2 ≤ (((N - 1 : ℕ)) : ℝ) := by
          rw [hcast]; linarith
        have h2pos : (0 : ℝ) < (N : ℝ) / 2 := by linarith
        have h3 : (((N - 1 : ℕ)) : ℝ) ^ (-ε) ≤ ((N : ℝ) / 2) ^ (-ε) :=
          Real.rpow_le_rpow_of_nonpos h2pos hhalf (show -ε ≤ 0 by linarith)
        have h2e : (2 : ℝ) ^ (-ε) = ((2 : ℝ) ^ ε)⁻¹ := by
          rw [show (-ε : ℝ) = -(ε) by ring, Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2)]
        have h4 : ((N : ℝ) / 2) ^ (-ε) = (2 : ℝ) ^ ε * (N : ℝ) ^ (-ε) := by
          rw [Real.div_rpow (le_of_lt hNpos) (by norm_num : (0 : ℝ) ≤ 2)]
          rw [h2e, div_eq_mul_inv, inv_inv, mul_comm]
        have h5 : (2 : ℝ) ^ ε ≤ 2 := by
          have h6 : (2 : ℝ) ^ ε ≤ (2 : ℝ) ^ (1 : ℝ) :=
            Real.rpow_le_rpow_of_exponent_le (by norm_num) hε1
          simpa using h6
        calc (((N - 1 : ℕ)) : ℝ) ^ (-ε) ≤ ((N : ℝ) / 2) ^ (-ε) := h3
          _ = (2 : ℝ) ^ ε * (N : ℝ) ^ (-ε) := h4
          _ ≤ 2 * (N : ℝ) ^ (-ε) :=
              mul_le_mul_of_nonneg_right h5 (Real.rpow_nonneg (Nat.cast_nonneg _) _)
      calc |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε)
          ≤ (lam * Real.log N) * (((N - 1 : ℕ)) : ℝ) ^ (-ε) :=
            mul_le_mul_of_nonneg_right (hg N hNX) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
        _ ≤ (lam * Real.log N) * (2 * (N : ℝ) ^ (-ε)) := by
            refine mul_le_mul_of_nonneg_left hle ?_
            exact mul_nonneg hlam (Real.log_nonneg (by exact_mod_cast (by omega : 1 ≤ N)))
        _ = 2 * lam * (Real.log N * (N : ℝ) ^ (-ε)) := by ring
  have hlim := (summable_mul_abelWeight hf hε0).hasSum.tendsto_sum_nat
  have hleft : Tendsto (fun N : ℕ => |∑ n ∈ Finset.range N, f n * abelWeight ε n|) atTop
      (𝓝 |∑' n, f n * abelWeight ε n|) :=
    (continuous_abs.tendsto _).comp hlim
  have hright : Tendsto (fun N : ℕ =>
      |logPartSum f N| * (((N - 1 : ℕ)) : ℝ) ^ (-ε) + (ε * K + 8 * lam / ε)) atTop
      (𝓝 (0 + (ε * K + 8 * lam / ε))) := hbd0.add tendsto_const_nhds
  have hfin := le_of_tendsto_of_tendsto hleft hright (by
    filter_upwards [eventually_gt_atTop X] with N hN
    exact hpartial N hN)
  simpa [hK] using hfin

/-- **Log-average ⟹ Abel (deliverable 1b).**  If the log-average numerators satisfy
`Σ_{n≤N} f n / n = o(log N)` — the conclusion of Tao's log-averaged two-point Chowla
theorem for `f(n) = λ(n)λ(n+2)` — then the Abelian mean `ε Σ f(n)n^{−1−ε}` vanishes as
`ε → 0⁺`, i.e. the cone residue vanishes.  The log-averaged theorem is an *external*
input here: this lemma is the machine-checked reduction, not a proof of `o(x)`. -/
theorem abelMean_tendsto_zero_of_logAverage {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1)
    (hlog : Tendsto (fun N : ℕ => logPartSum f N / Real.log N) atTop (𝓝 0)) :
    Tendsto (fun ε : ℝ => abelMean f ε) (𝓝[>] 0) (𝓝 0) := by
  rw [Metric.tendsto_nhds]
  intro η hη
  have hlampos : (0 : ℝ) < η / 16 := by linarith
  have hev : ∀ᶠ N : ℕ in atTop, |logPartSum f N| ≤ (η / 16) * Real.log N := by
    have h := (Metric.tendsto_nhds.mp hlog) (η / 16) hlampos
    filter_upwards [h, eventually_gt_atTop 1] with N hN hN1
    have hlogpos : 0 < Real.log N := Real.log_pos (by exact_mod_cast hN1)
    rw [Real.dist_eq, sub_zero, abs_div, abs_of_pos hlogpos, div_lt_iff₀ hlogpos] at hN
    exact le_of_lt hN
  obtain ⟨X, hX2, hg⟩ : ∃ X : ℕ, 2 ≤ X ∧
      ∀ m, X ≤ m → |logPartSum f m| ≤ (η / 16) * Real.log m := by
    rcases Filter.eventually_atTop.mp hev with ⟨X₀, hX₀⟩
    exact ⟨max X₀ 2, le_max_right _ _, fun m hm => hX₀ m (le_trans (le_max_left _ _) hm)⟩
  set K := ∑ n ∈ Finset.range X, |logPartSum f (n + 1)| / (n : ℝ) with hK
  have hKnn : 0 ≤ K := by
    rw [hK]
    exact Finset.sum_nonneg (fun n _ => div_nonneg (abs_nonneg _) (Nat.cast_nonneg n))
  set ε₀ : ℝ := min 1 (η / (4 * (K + 1))) with hε₀
  have hε₀pos : 0 < ε₀ := by
    rw [hε₀]
    exact lt_min_iff.mpr ⟨by norm_num, div_pos hη (by positivity)⟩
  refine mem_of_superset (Ioo_mem_nhdsGT hε₀pos) ?_
  intro ε hε
  obtain ⟨hε0, hεlt⟩ := hε
  have hε1 : ε ≤ 1 := le_of_lt (lt_of_lt_of_le hεlt (min_le_left _ _))
  have hε2 : ε ≤ η / (4 * (K + 1)) := le_of_lt (lt_of_lt_of_le hεlt (min_le_right _ _))
  have hb := abel_tsum_le_of_logAverage hf (le_of_lt hlampos) hX2 hg hε0 hε1
  simp only [Set.mem_ofPred_eq]
  rw [Real.dist_eq, sub_zero]
  have hεK : ε * K ≤ η / 4 := by
    have hden : (0 : ℝ) < 4 * (K + 1) := by positivity
    rw [le_div_iff₀ hden] at hε2
    nlinarith [hε2, hKnn, hε0]
  have h3 : ε * (8 * (η / 16) / ε) = η / 2 := by
    field_simp
    ring
  have hsq : ε ^ 2 * K ≤ ε * K := by
    have h1 : ε ^ 2 ≤ ε := by nlinarith [hε0, hε1]
    exact mul_le_mul_of_nonneg_right h1 hKnn
  calc |abelMean f ε| = ε * |∑' n, f n * abelWeight ε n| := by
        rw [abelMean, abs_mul, abs_of_pos hε0]
    _ ≤ ε * (ε * K + 8 * (η / 16) / ε) :=
        mul_le_mul_of_nonneg_left hb (le_of_lt hε0)
    _ = ε ^ 2 * K + ε * (8 * (η / 16) / ε) := by ring
    _ = ε ^ 2 * K + η / 2 := by rw [h3]
    _ ≤ ε * K + η / 2 := by linarith [hsq]
    _ ≤ η / 4 + η / 2 := by linarith [hεK]
    _ < η := by linarith

/-! ## 13. The pair transform versus the Dirichlet series (deliverable 1c) -/

-- The pair weight `(n(n+2))^{−p}` is `ConeLean.pairWeight`, defined in `ConeLean/Cone.lean`.

lemma pairWeight_zero {p : ℝ} (hp : 0 < p) : pairWeight p 0 = 0 := by
  rw [pairWeight, Nat.cast_zero, zero_mul, Real.zero_rpow (by linarith : (-p) ≠ 0)]

lemma abelWeight_one_zero : abelWeight 1 0 = 0 := by
  rw [abelWeight, Nat.cast_zero, Real.zero_rpow]
  norm_num

/-- Mean-value bound over `[n, n+2]`: `n^{−p} − (n+2)^{−p} ≤ 2p·n^{−p−1}`. -/
lemma rpow_neg_gap_two {p : ℝ} (hp : 0 < p) {n : ℕ} (hn : 1 ≤ n) :
    (n : ℝ) ^ (-p) - ((n : ℝ) + 2) ^ (-p) ≤ 2 * (p * (n : ℝ) ^ (-p - 1)) := by
  have hn0 : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have hderiv : ∀ x ∈ Set.Icc (n : ℝ) ((n : ℝ) + 2),
      HasDerivWithinAt (fun x : ℝ => x ^ (-p)) ((-p) * x ^ (-p - 1))
        (Set.Icc (n : ℝ) ((n : ℝ) + 2)) x := by
    intro x hx
    have hx0 : x ≠ 0 := ne_of_gt (lt_of_lt_of_le hn0 hx.1)
    exact (Real.hasDerivAt_rpow_const (x := x) (p := -p) (Or.inl hx0)).hasDerivWithinAt
  have hbound : ∀ x ∈ Set.Ico (n : ℝ) ((n : ℝ) + 2),
      ‖((-p) * x ^ (-p - 1) : ℝ)‖ ≤ p * (n : ℝ) ^ (-p - 1) := by
    intro x hx
    have hx0 : (0 : ℝ) < x := lt_of_lt_of_le hn0 hx.1
    have hmono : x ^ (-p - 1) ≤ (n : ℝ) ^ (-p - 1) :=
      Real.rpow_le_rpow_of_nonpos hn0 hx.1 (show -p - 1 ≤ 0 by linarith)
    have hnn : (0 : ℝ) ≤ x ^ (-p - 1) := Real.rpow_nonneg (le_of_lt hx0) _
    rw [norm_mul, norm_neg, Real.norm_eq_abs, abs_of_pos hp, Real.norm_eq_abs,
      abs_of_nonneg hnn]
    exact mul_le_mul_of_nonneg_left hmono (le_of_lt hp)
  have hmain := norm_image_sub_le_of_norm_deriv_le_segment' hderiv hbound
    ((n : ℝ) + 2) ⟨by linarith, le_rfl⟩
  rw [add_sub_cancel_left] at hmain
  have hle : (n : ℝ) ^ (-p) - ((n : ℝ) + 2) ^ (-p)
      ≤ ‖(((n : ℝ) + 2) ^ (-p) - (n : ℝ) ^ (-p) : ℝ)‖ := by
    rw [Real.norm_eq_abs, abs_sub_comm]
    exact le_abs_self (((n : ℝ) ^ (-p) - ((n : ℝ) + 2) ^ (-p) : ℝ))
  refine hle.trans ?_
  calc ‖(((n : ℝ) + 2) ^ (-p) - (n : ℝ) ^ (-p) : ℝ)‖
      ≤ p * (n : ℝ) ^ (-p - 1) * 2 := hmain
    _ = 2 * (p * (n : ℝ) ^ (-p - 1)) := by ring

/-- **The pairwise comparison**: for `1/2 ≤ p ≤ 1`, the pair weight and the pure weight
`n^{−2p}` differ by at most `2n^{−2}`. -/
lemma pairWeight_sub_le {p : ℝ} (hp0 : 0 < p) (hph : 1 / 2 ≤ p) (hp1 : p ≤ 1) (n : ℕ) :
    |pairWeight p n - (n : ℝ) ^ (-2 * p)| ≤ 2 * abelWeight 1 n := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · rw [pairWeight_zero hp0, Nat.cast_zero, Real.zero_rpow (by linarith : (-2 * p) ≠ 0),
      abelWeight_one_zero, sub_zero, abs_zero]
    norm_num
  · have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
    have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hn2pos : (0 : ℝ) ≤ (n : ℝ) + 2 := by linarith
    have hnppos : (0 : ℝ) ≤ (n : ℝ) ^ (-p) := Real.rpow_nonneg (le_of_lt hnpos) _
    have hmono : ((n : ℝ) + 2) ^ (-p) ≤ (n : ℝ) ^ (-p) :=
      Real.rpow_le_rpow_of_nonpos hnpos (by linarith) (show -p ≤ 0 by linarith)
    have hpair : pairWeight p n = (n : ℝ) ^ (-p) * ((n : ℝ) + 2) ^ (-p) :=
      Real.mul_rpow (le_of_lt hnpos) hn2pos
    have hn2p : (n : ℝ) ^ (-2 * p) = (n : ℝ) ^ (-p) * (n : ℝ) ^ (-p) := by
      rw [← Real.rpow_add hnpos]
      congr 1
      ring
    have hle : pairWeight p n ≤ (n : ℝ) ^ (-2 * p) := by
      rw [hpair, hn2p]
      exact mul_le_mul_of_nonneg_left hmono hnppos
    have hdiff : (n : ℝ) ^ (-2 * p) - pairWeight p n
        = (n : ℝ) ^ (-p) * ((n : ℝ) ^ (-p) - ((n : ℝ) + 2) ^ (-p)) := by
      rw [hpair, hn2p]
      ring
    have hmvt := rpow_neg_gap_two hp0 hn
    rw [abs_of_nonpos (sub_nonpos.mpr hle), neg_sub, hdiff]
    calc (n : ℝ) ^ (-p) * ((n : ℝ) ^ (-p) - ((n : ℝ) + 2) ^ (-p))
        ≤ (n : ℝ) ^ (-p) * (2 * (p * (n : ℝ) ^ (-p - 1))) :=
          mul_le_mul_of_nonneg_left hmvt hnppos
      _ = 2 * p * ((n : ℝ) ^ (-p) * (n : ℝ) ^ (-p - 1)) := by ring
      _ = 2 * p * (n : ℝ) ^ (-2 * p - 1) := by
          rw [← Real.rpow_add hnpos]
          congr 2
          ring
      _ ≤ 2 * 1 * (n : ℝ) ^ (-1 - 1 : ℝ) := by
          have h1 : (n : ℝ) ^ (-2 * p - 1) ≤ (n : ℝ) ^ (-1 - 1 : ℝ) :=
            Real.rpow_le_rpow_of_exponent_le hn1 (by linarith)
          calc 2 * p * (n : ℝ) ^ (-2 * p - 1)
              ≤ 2 * p * (n : ℝ) ^ (-1 - 1 : ℝ) :=
                mul_le_mul_of_nonneg_left h1 (by linarith)
            _ ≤ 2 * 1 * (n : ℝ) ^ (-1 - 1 : ℝ) := by
                refine mul_le_mul_of_nonneg_right ?_
                  (Real.rpow_nonneg (le_of_lt hnpos) _)
                linarith
      _ = 2 * abelWeight 1 n := by rw [abelWeight]; ring

/-- The pair weight is dominated by the pure weight `n^{−2p}`. -/
lemma pairWeight_nonneg {p : ℝ} (_hp : 0 < p) (n : ℕ) : 0 ≤ pairWeight p n := by
  rw [pairWeight]
  exact Real.rpow_nonneg (by positivity) _

lemma pairWeight_le_rpow {p : ℝ} (hp0 : 0 < p) (n : ℕ) :
    pairWeight p n ≤ (n : ℝ) ^ (-2 * p) := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · rw [pairWeight_zero hp0, Nat.cast_zero, Real.zero_rpow (by linarith : (-2 * p) ≠ 0)]
  · have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
    have hn2pos : (0 : ℝ) ≤ (n : ℝ) + 2 := by linarith
    have hnppos : (0 : ℝ) ≤ (n : ℝ) ^ (-p) := Real.rpow_nonneg (le_of_lt hnpos) _
    have hmono : ((n : ℝ) + 2) ^ (-p) ≤ (n : ℝ) ^ (-p) :=
      Real.rpow_le_rpow_of_nonpos hnpos (by linarith) (show -p ≤ 0 by linarith)
    rw [show pairWeight p n = (n : ℝ) ^ (-p) * ((n : ℝ) + 2) ^ (-p) from
        Real.mul_rpow (le_of_lt hnpos) hn2pos,
      show (n : ℝ) ^ (-2 * p) = (n : ℝ) ^ (-p) * (n : ℝ) ^ (-p) by
        rw [← Real.rpow_add hnpos]; congr 1; ring]
    exact mul_le_mul_of_nonneg_left hmono hnppos

/-- **(1c) The pair transform versus the Dirichlet series.**  For `1/2 < p ≤ 1` and
`|f| ≤ 1`, the difference between the cone pair transform at exponent `p` and the
Dirichlet series at `2p` is absolutely convergent, with a bound independent of `p`:

```
|Σ_n f(n)·((n(n+2))^{−p} − n^{−2p})| ≤ 2 Σ_n n^{−2} .
```

So at `p = 1/2 + ε/2` the pair transform's residue is the Dirichlet-series residue; the
two full series are recovered by adding back `F(2p)`, which converges for `p > 1/2`. -/
theorem coneTransform_sub_dirichlet_le {f : ℕ → ℝ} (hf : ∀ n, |f n| ≤ 1)
    {p : ℝ} (hp0 : 0 < p) (hph : 1 / 2 < p) (hp1 : p ≤ 1) :
    |∑' n, (f n * pairWeight p n - f n * (n : ℝ) ^ (-2 * p))|
      ≤ 2 * ∑' n, abelWeight 1 n := by
  have hw : Summable fun n : ℕ => 2 * abelWeight 1 n :=
    (summable_abelWeight (by norm_num : (0 : ℝ) < 1)).mul_left 2
  have hle : ∀ n : ℕ, |f n * pairWeight p n - f n * (n : ℝ) ^ (-2 * p)|
      ≤ 2 * abelWeight 1 n := by
    intro n
    rw [← mul_sub, abs_mul]
    calc |f n| * |pairWeight p n - (n : ℝ) ^ (-2 * p)|
        ≤ 1 * (2 * abelWeight 1 n) :=
          mul_le_mul (hf n) (pairWeight_sub_le hp0 (le_of_lt hph) hp1 n)
            (abs_nonneg _) (by norm_num)
      _ = 2 * abelWeight 1 n := by ring
  have hs : Summable fun n : ℕ =>
      f n * pairWeight p n - f n * (n : ℝ) ^ (-2 * p) := by
    refine Summable.of_norm_bounded hw (fun n => ?_)
    rw [Real.norm_eq_abs]
    exact hle n
  calc |∑' n, (f n * pairWeight p n - f n * (n : ℝ) ^ (-2 * p))|
      ≤ ∑' n, |f n * pairWeight p n - f n * (n : ℝ) ^ (-2 * p)| := by
        simpa only [Real.norm_eq_abs] using norm_tsum_le_tsum_norm hs.norm
    _ ≤ ∑' n, 2 * abelWeight 1 n := Summable.tsum_le_tsum hle hs.abs hw
    _ = 2 * ∑' n, abelWeight 1 n := tsum_mul_left

end

end ConeLean
