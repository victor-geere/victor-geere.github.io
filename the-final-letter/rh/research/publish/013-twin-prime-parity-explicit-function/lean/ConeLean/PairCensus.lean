/-
ConeLean/PairCensus.lean — the radial-pair alphabet, its Brown conditions and its
reachable set (the rh42 census analogue).

The pair alphabet of the positive half is

    a_k = (4k+2)^{-p} + (4k+4)^{-p} ,      k = 0, 1, 2, … ,

i.e. the even-denominator series `P(p) = 2^{-p} ζ(p)` grouped into consecutive radial
pairs `{2,4}, {6,8}, {10,12}, …`.

Proved here (no `sorry`):

* `tsum_even_add_odd_real` — the even/odd splitting identity for real series
  (Mathlib has no `tsum_even_add_odd` for `ℝ`; this is the lemma the rh42 paper
  records as having eluded elaboration);
* `tsum_pairAlphabet` — `Σ_k a_k = BPos p` (the pairing identity);
* `pair_brown_zero_iff` — Brown's first condition `a_0 ≤ Σ_{k≥1} a_k` is equivalent
  to `0 ≤ Ψ(p)`, i.e. to `p ≤ p_pair`;
* `pair_brown_all_k` (with `tsum_rpow_inv_tail_ge`) — **every** Brown condition holds
  for `1 < p ≤ 3/2` at `k ≥ 1`, with slack `≥ 3`;
* the census: `SubSumIco` (finite sub-sum sets), the recursion
  `S_{[m,n)} = S_{[m+1,n)} ∪ (a_m + S_{[m+1,n)})`, Brown completeness
  (`SubSumIco_eq_Icc_of_brown`), the gap lemma and the two-interval corollary.
-/
import ConeLean.PairThreshold

namespace ConeLean

open scoped BigOperators
open TppLean
open Filter
open scoped Topology

set_option maxHeartbeats 1000000

noncomputable section

/-! ## 1. The radial-pair alphabet -/

/-- The radial-pair alphabet `a_k = (4k+2)^{-p} + (4k+4)^{-p}`. -/
noncomputable def pairAlphabet (p : ℝ) (k : ℕ) : ℝ :=
  (((4 * k + 2 : ℕ)) : ℝ) ^ (-p) + (((4 * k + 4 : ℕ)) : ℝ) ^ (-p)

lemma pairAlphabet_pos (p : ℝ) (k : ℕ) : 0 < pairAlphabet p k := by
  unfold pairAlphabet
  positivity

lemma pairAlphabet_nonneg (p : ℝ) (k : ℕ) : 0 ≤ pairAlphabet p k :=
  le_of_lt (pairAlphabet_pos p k)

lemma pairAlphabet_zero (p : ℝ) : pairAlphabet p 0 = (2 : ℝ) ^ (-p) + (4 : ℝ) ^ (-p) := by
  unfold pairAlphabet
  norm_num

lemma pairAlphabet_antitone {p : ℝ} (hp : 0 < p) : Antitone (pairAlphabet p) := by
  intro m n hmn
  have h1 : (((4 * m + 2 : ℕ)) : ℝ) ≤ (((4 * n + 2 : ℕ)) : ℝ) := by
    exact_mod_cast (by omega : 4 * m + 2 ≤ 4 * n + 2)
  have h2 : (((4 * m + 4 : ℕ)) : ℝ) ≤ (((4 * n + 4 : ℕ)) : ℝ) := by
    exact_mod_cast (by omega : 4 * m + 4 ≤ 4 * n + 4)
  have h3 : (0 : ℝ) < ((4 * m + 2 : ℕ) : ℝ) := by positivity
  have h4 : (0 : ℝ) < ((4 * m + 4 : ℕ) : ℝ) := by positivity
  have h5 := Real.rpow_le_rpow_of_nonpos h3 h1 (show -p ≤ 0 by linarith)
  have h6 := Real.rpow_le_rpow_of_nonpos h4 h2 (show -p ≤ 0 by linarith)
  unfold pairAlphabet
  linarith

/-! ## 2. The even/odd splitting identity for real series -/

/-- **Even/odd splitting.**  For a summable real series,
`Σ_k f(2k) + Σ_k f(2k+1) = Σ_j f j`.  (Mathlib provides this for `ℝ≥0∞` only.) -/
lemma tsum_even_add_odd_real {f : ℕ → ℝ} (hf : Summable f) :
    (∑' k : ℕ, f (2 * k)) + (∑' k : ℕ, f (2 * k + 1)) = ∑' j : ℕ, f j := by
  have he : Summable fun k : ℕ => f (2 * k) :=
    hf.comp_injective (fun a b h => by omega)
  have ho : Summable fun k : ℕ => f (2 * k + 1) :=
    hf.comp_injective (fun a b h => by omega)
  have hblock : ∀ n : ℕ, (∑ j ∈ Finset.range (2 * n), f j)
      = (∑ k ∈ Finset.range n, f (2 * k)) + (∑ k ∈ Finset.range n, f (2 * k + 1)) := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
        have h2 : 2 * (n + 1) = 2 * n + 1 + 1 := by ring
        rw [h2, Finset.sum_range_succ, Finset.sum_range_succ, ih,
          Finset.sum_range_succ, Finset.sum_range_succ]
        ring
  have h1 : Tendsto (fun n : ℕ => ∑ j ∈ Finset.range (2 * n), f j) atTop (𝓝 (∑' j, f j)) :=
    hf.hasSum.tendsto_sum_nat.comp
      (tendsto_atTop_atTop.mpr (fun b => ⟨b, fun a ha => by omega⟩))
  have h2 : Tendsto (fun n : ℕ => (∑ k ∈ Finset.range n, f (2 * k))
      + (∑ k ∈ Finset.range n, f (2 * k + 1))) atTop
      (𝓝 ((∑' k, f (2 * k)) + (∑' k, f (2 * k + 1)))) :=
    he.hasSum.tendsto_sum_nat.add ho.hasSum.tendsto_sum_nat
  have h2' : Tendsto (fun n : ℕ => ∑ j ∈ Finset.range (2 * n), f j) atTop
      (𝓝 ((∑' k, f (2 * k)) + (∑' k, f (2 * k + 1)))) :=
    h2.congr' (Eventually.of_forall (fun n => (hblock n).symm))
  exact tendsto_nhds_unique h2' h1

/-! ## 3. The pairing identity `Σ_k a_k = BPos p` -/

/-- The pair alphabet is the even series grouped in consecutive pairs. -/
lemma pairAlphabet_eq {p : ℝ} (k : ℕ) :
    (fun j : ℕ => (((2 * j + 2 : ℕ)) : ℝ) ^ (-p)) (2 * k)
      + (fun j : ℕ => (((2 * j + 2 : ℕ)) : ℝ) ^ (-p)) (2 * k + 1) = pairAlphabet p k := by
  simp only
  unfold pairAlphabet
  rw [show 2 * (2 * k) + 2 = 4 * k + 2 by ring,
    show 2 * (2 * k + 1) + 2 = 4 * k + 4 by ring]

lemma summable_pairAlphabet {p : ℝ} (hp : 1 < p) : Summable (pairAlphabet p) := by
  have hg := summable_even (p := p) hp
  have he : Summable fun k : ℕ => (fun j : ℕ => (((2 * j + 2 : ℕ)) : ℝ) ^ (-p)) (2 * k) :=
    hg.comp_injective (fun a b h => by omega)
  have ho : Summable fun k : ℕ => (fun j : ℕ => (((2 * j + 2 : ℕ)) : ℝ) ^ (-p)) (2 * k + 1) :=
    hg.comp_injective (fun a b h => by omega)
  exact (he.add ho).congr (fun k => pairAlphabet_eq k)

/-- **The pairing identity**: the radial pairs sum to the positive budget. -/
lemma tsum_pairAlphabet {p : ℝ} (hp : 1 < p) : (∑' k, pairAlphabet p k) = BPos p := by
  have hg := summable_even (p := p) hp
  have he : Summable fun k : ℕ => (fun j : ℕ => (((2 * j + 2 : ℕ)) : ℝ) ^ (-p)) (2 * k) :=
    hg.comp_injective (fun a b h => by omega)
  have ho : Summable fun k : ℕ => (fun j : ℕ => (((2 * j + 2 : ℕ)) : ℝ) ^ (-p)) (2 * k + 1) :=
    hg.comp_injective (fun a b h => by omega)
  have hsplit := tsum_even_add_odd_real hg
  rw [BPos_eq_even hp, ← hsplit, ← Summable.tsum_add he ho]
  exact tsum_congr (fun k => (pairAlphabet_eq k).symm)

/-! ## 4. Brown's first condition is the threshold `Ψ(p) ≥ 0` -/

/-- **Brown's first (`k = 0`) condition for the pair alphabet** is equivalent to
`Ψ(p) ≥ 0`, i.e. to `p ≤ p_pair`. -/
lemma pair_brown_zero_iff {p : ℝ} (hp : 1 < p) :
    (pairAlphabet p 0 ≤ ∑' k : ℕ, pairAlphabet p (k + 1)) ↔ 0 ≤ Psi p := by
  have hs := summable_pairAlphabet hp
  have hsplit : (∑' k : ℕ, pairAlphabet p k)
      = pairAlphabet p 0 + ∑' k : ℕ, pairAlphabet p (k + 1) := hs.tsum_eq_zero_add
  have htot : (∑' k : ℕ, pairAlphabet p k) = (2 : ℝ) ^ (-p) * ZetaR p := tsum_pairAlphabet hp
  have h0 := pairAlphabet_zero p
  have h4 : (4 : ℝ) ^ (-p) = (2 : ℝ) ^ (-p) * (2 : ℝ) ^ (-p) := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, ← Real.rpow_natCast,
      ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2),
      show (((2 : ℕ)) : ℝ) * (-p) = -p + -p by push_cast; ring,
      Real.rpow_add (by norm_num : (0 : ℝ) < 2)]
  have h2p : (2 : ℝ) ^ (1 - p) = 2 * (2 : ℝ) ^ (-p) := by
    rw [show (1 : ℝ) - p = 1 + (-p) by ring, Real.rpow_add (by norm_num), Real.rpow_one]
  have hpos : (0 : ℝ) < (2 : ℝ) ^ (-p) := Real.rpow_pos_of_pos (by norm_num) _
  have hmul : (2 : ℝ) ^ (-p) * (2 : ℝ) ^ p = 1 := by
    rw [← Real.rpow_add (by norm_num), neg_add_cancel, Real.rpow_zero]
  rw [Psi]
  constructor
  · intro h
    have h2 : 2 * ((2 : ℝ) ^ (-p) + (4 : ℝ) ^ (-p)) ≤ (2 : ℝ) ^ (-p) * ZetaR p := by
      linarith [hsplit, htot, h, h0]
    rw [h4] at h2
    have h3 : 2 * (1 + (2 : ℝ) ^ (-p)) ≤ ZetaR p := by
      have hpos2 : (0 : ℝ) < (2 : ℝ) ^ p := Real.rpow_pos_of_pos (by norm_num) _
      have := mul_le_mul_of_nonneg_right h2 (le_of_lt hpos2)
      nlinarith [this, hmul, hpos, hpos2]
    linarith [h3, h2p]
  · intro h
    have h3 : 2 + (2 : ℝ) ^ (1 - p) ≤ ZetaR p := by linarith
    have h2 : 2 * ((2 : ℝ) ^ (-p) + (4 : ℝ) ^ (-p)) ≤ (2 : ℝ) ^ (-p) * ZetaR p := by
      rw [h4]
      have := mul_le_mul_of_nonneg_left h3 (le_of_lt hpos)
      nlinarith [this, hmul, h2p, hpos]
    linarith [hsplit, htot, h2, h0]


/-! ## 5. The integral lower bound for a `p`-series tail -/

/-- **Lower integral test.**  For `p > 1` and `N ≥ 1`,
`N^{1-p}/(p-1) ≤ Σ_{k≥0} (k+N)^{-p}` (the mirror of `TppLean.tsum_tail_le`). -/
lemma tsum_rpow_inv_tail_ge {p : ℝ} (hp : 1 < p) {N : ℕ} (hN : 1 ≤ N) :
    ((N : ℝ)) ^ (1 - p) / (p - 1) ≤ ∑' k : ℕ, (((k + N : ℕ)) : ℝ) ^ (-p) := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hp1 : (0 : ℝ) < p - 1 := by linarith
  have hsummable : Summable fun k : ℕ => (((k + N : ℕ)) : ℝ) ^ (-p) := by
    have h0 : Summable fun n : ℕ => ((n : ℝ)) ^ (-p) := by
      have h := (Real.summable_nat_rpow_inv (p := p)).mpr hp
      exact h.congr (fun n => by rw [Real.rpow_neg (Nat.cast_nonneg n)])
    exact h0.comp_injective (fun a b hab => Nat.add_right_cancel hab)
  have hkey : ∀ M : ℕ, ((N : ℝ) ^ (1 - p) - ((N + M : ℕ) : ℝ) ^ (1 - p)) / (p - 1)
      ≤ ∑' k : ℕ, (((k + N : ℕ)) : ℝ) ^ (-p) := by
    intro M
    have hanti : AntitoneOn (fun x : ℝ => x ^ (-p)) (Set.Icc (N : ℝ) ((N + M : ℕ) : ℝ)) := by
      intro x hx y hy hxy
      have hx0 : (0 : ℝ) < x := lt_of_lt_of_le hNpos hx.1
      have hy0 : (0 : ℝ) < y := lt_of_lt_of_le hNpos hy.1
      exact (Real.rpow_le_rpow_iff_of_neg hy0 hx0 (by linarith : -p < 0)).mpr hxy
    have h := hanti.integral_le_sum_Ico (a := N) (b := N + M) (by omega)
    have hne : (0 : ℝ) ∉ Set.uIcc (N : ℝ) ((N + M : ℕ) : ℝ) := by
      rw [Set.uIcc_of_le (by exact_mod_cast (Nat.le_add_right N M : N ≤ N + M))]
      intro hmem
      exact absurd hmem.1 (not_le.mpr hNpos)
    have hint : ∫ x in (N : ℝ)..((N + M : ℕ) : ℝ), x ^ (-p)
        = ((N : ℝ) ^ (1 - p) - ((N + M : ℕ) : ℝ) ^ (1 - p)) / (p - 1) := by
      rw [integral_rpow (Or.inr ⟨by linarith, hne⟩)]
      rw [show (-p) + 1 = 1 - p by ring]
      have hd : (1 : ℝ) - p = -(p - 1) := by ring
      rw [hd, div_neg]
      ring
    have hreindex : (∑ x ∈ Finset.Ico N (N + M), (x : ℝ) ^ (-p))
        = ∑ k ∈ Finset.range M, (((k + N : ℕ)) : ℝ) ^ (-p) := by
      rw [Finset.sum_Ico_eq_sum_range]
      rw [show N + M - N = M by omega]
      refine Finset.sum_congr rfl (fun k _ => ?_)
      congr 1
      push_cast
      ring
    have hle : (∑ k ∈ Finset.range M, (((k + N : ℕ)) : ℝ) ^ (-p))
        ≤ ∑' k : ℕ, (((k + N : ℕ)) : ℝ) ^ (-p) :=
      hsummable.sum_le_tsum _ (fun i _ => by positivity)
    rw [hreindex, hint] at h
    linarith
  have hlim : Tendsto (fun M : ℕ =>
      ((N : ℝ) ^ (1 - p) - ((N + M : ℕ) : ℝ) ^ (1 - p)) / (p - 1)) atTop
      (𝓝 (((N : ℝ) ^ (1 - p) - 0) / (p - 1))) := by
    refine Tendsto.div_const ?_ _
    refine Tendsto.sub tendsto_const_nhds ?_
    have h1 : Tendsto (fun M : ℕ => (((N + M : ℕ)) : ℝ)) atTop atTop :=
      tendsto_natCast_atTop_atTop.comp
        (tendsto_atTop_atTop.mpr (fun b => ⟨b, fun a ha => by omega⟩))
    have h2 : Tendsto (fun x : ℝ => x ^ (-(p - 1))) atTop (𝓝 0) :=
      tendsto_rpow_neg_atTop hp1
    have h3 : Tendsto (fun x : ℝ => x ^ (1 - p)) atTop (𝓝 0) := by
      simpa only [show (1 : ℝ) - p = -(p - 1) by ring] using h2
    exact h3.comp h1
  have hfin := le_of_tendsto_of_tendsto hlim tendsto_const_nhds (Eventually.of_forall hkey)
  simpa using hfin


/-! ## 6. The all-k Brown conditions (`k ≥ 1`, slack `≥ 3`) -/

/-- `a_k ≤ 2 (4k+2)^{-p}`: for a negative exponent the *larger* base gives the
*smaller* value, so both terms are dominated by `(4k+2)^{-p}`. -/
lemma pairAlphabet_le {p : ℝ} (hp : 0 < p) (k : ℕ) :
    pairAlphabet p k ≤ 2 * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p) := by
  have h1 : (0 : ℝ) < (((4 * k + 2 : ℕ)) : ℝ) := by positivity
  have h2 : (((4 * k + 2 : ℕ)) : ℝ) ≤ (((4 * k + 4 : ℕ)) : ℝ) := by
    exact_mod_cast (by omega : 4 * k + 2 ≤ 4 * k + 4)
  have h3 := Real.rpow_le_rpow_of_nonpos h1 h2 (show -p ≤ 0 by linarith)
  unfold pairAlphabet
  linarith

/-- The tail of the pair alphabet dominates `4^{-p}(k+2)^{1-p}/(p-1)`. -/
lemma pairAlphabet_tail_ge {p : ℝ} (hp : 1 < p) {k : ℕ} (hk : 1 ≤ k) :
    (4 : ℝ) ^ (-p) * (((k + 2 : ℕ)) : ℝ) ^ (1 - p) / (p - 1)
      ≤ ∑' j : ℕ, pairAlphabet p (j + (k + 1)) := by
  have hsum1 : Summable fun j : ℕ => (((4 * (j + (k + 1)) + 4 : ℕ)) : ℝ) ^ (-p) := by
    have h0 : Summable fun n : ℕ => ((n : ℝ)) ^ (-p) := by
      have h := (Real.summable_nat_rpow_inv (p := p)).mpr hp
      exact h.congr (fun n => by rw [Real.rpow_neg (Nat.cast_nonneg n)])
    exact h0.comp_injective (fun a b hab => by omega)
  have hsum2 : Summable fun j : ℕ => pairAlphabet p (j + (k + 1)) :=
    (summable_pairAlphabet hp).comp_injective (fun a b hab => Nat.add_right_cancel hab)
  have hle : ∀ j : ℕ, (((4 * (j + (k + 1)) + 4 : ℕ)) : ℝ) ^ (-p)
      ≤ pairAlphabet p (j + (k + 1)) := by
    intro j
    have h1 : (0 : ℝ) < (((4 * (j + (k + 1)) + 2 : ℕ)) : ℝ) := by positivity
    have h2 : (((4 * (j + (k + 1)) + 2 : ℕ)) : ℝ)
        ≤ (((4 * (j + (k + 1)) + 4 : ℕ)) : ℝ) := by
      exact_mod_cast (by omega : 4 * (j + (k + 1)) + 2 ≤ 4 * (j + (k + 1)) + 4)
    have h3 := Real.rpow_le_rpow_of_nonpos h1 h2 (show -p ≤ 0 by linarith)
    have h4 : (0 : ℝ) ≤ (((4 * (j + (k + 1)) + 2 : ℕ)) : ℝ) ^ (-p) := by positivity
    unfold pairAlphabet
    linarith
  have hcomp := Summable.tsum_le_tsum hle hsum1 hsum2
  have hrewrite : (∑' j : ℕ, (((4 * (j + (k + 1)) + 4 : ℕ)) : ℝ) ^ (-p))
      = (4 : ℝ) ^ (-p) * ∑' j : ℕ, (((j + (k + 2) : ℕ)) : ℝ) ^ (-p) := by
    rw [← tsum_mul_left]
    refine tsum_congr (fun j => ?_)
    have harg : (((4 * (j + (k + 1)) + 4 : ℕ)) : ℝ)
        = (4 : ℝ) * (((j + (k + 2) : ℕ)) : ℝ) := by push_cast; ring
    rw [harg, Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 4) (by positivity)]
  have hint := tsum_rpow_inv_tail_ge (p := p) hp (N := k + 2) (by omega)
  rw [hrewrite] at hcomp
  calc (4 : ℝ) ^ (-p) * (((k + 2 : ℕ)) : ℝ) ^ (1 - p) / (p - 1)
      = (4 : ℝ) ^ (-p) * ((((k + 2 : ℕ)) : ℝ) ^ (1 - p) / (p - 1)) := by ring
    _ ≤ (4 : ℝ) ^ (-p) * ∑' j : ℕ, (((j + (k + 2) : ℕ)) : ℝ) ^ (-p) :=
        mul_le_mul_of_nonneg_left hint (by positivity)
    _ ≤ ∑' j : ℕ, pairAlphabet p (j + (k + 1)) := hcomp

/-- **The key inequality**: `2(p-1) ≤ (k+2)^{1-p} ((2k+1)/2)^p` for `1 ≤ k`, `p ≤ 3/2`.
Equivalently `2(p-1) 4^p (4k+2)^{-p} ≤ (k+2)^{1-p}`. -/
lemma pair_key {p : ℝ} (hp1 : 1 < p) (hp32 : p ≤ 3 / 2) {k : ℕ} (hk : 1 ≤ k) :
    2 * (p - 1) * (4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
      ≤ (((k + 2 : ℕ)) : ℝ) ^ (1 - p) := by
  have hp0 : (0 : ℝ) < p := by linarith
  have h4pos : (0 : ℝ) < (((4 * k + 2 : ℕ)) : ℝ) := by positivity
  have hk2pos : (0 : ℝ) < (((k + 2 : ℕ)) : ℝ) := by positivity
  have h2k1pos : (0 : ℝ) < (((2 * k + 1 : ℕ)) : ℝ) := by positivity
  -- step 1: `4^p (4k+2)^{-p} = (2/(2k+1))^p`
  have h4 : (4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
      = ((2 : ℝ) / (((2 * k + 1 : ℕ)) : ℝ)) ^ p := by
    rw [Real.rpow_neg (le_of_lt h4pos), ← div_eq_mul_inv,
      ← Real.div_rpow (by norm_num : (0 : ℝ) ≤ 4) (le_of_lt h4pos),
      show (4 : ℝ) / (((4 * k + 2 : ℕ)) : ℝ) = 2 / (((2 * k + 1 : ℕ)) : ℝ) by
        push_cast
        rw [div_eq_div_iff (by positivity) (by positivity)]
        ring]
  -- step 2: the ratio is at most `2/(k+2)`
  have hr : (2 : ℝ) / (((2 * k + 1 : ℕ)) : ℝ) ≤ 2 / (((k + 2 : ℕ)) : ℝ) := by
    have h1 : (((k + 2 : ℕ)) : ℝ) ≤ (((2 * k + 1 : ℕ)) : ℝ) := by
      exact_mod_cast (by omega : k + 2 ≤ 2 * k + 1)
    exact div_le_div_of_nonneg_left (by norm_num) hk2pos h1
  have hrp : ((2 : ℝ) / (((2 * k + 1 : ℕ)) : ℝ)) ^ p
      ≤ ((2 : ℝ) / (((k + 2 : ℕ)) : ℝ)) ^ p :=
    Real.rpow_le_rpow (by positivity) hr (le_of_lt hp0)
  have h5 : ((2 : ℝ) / (((k + 2 : ℕ)) : ℝ)) ^ p
      = (2 : ℝ) ^ p * (((k + 2 : ℕ)) : ℝ) ^ (-p) := by
    rw [Real.div_rpow (by norm_num) (le_of_lt hk2pos), Real.rpow_neg (le_of_lt hk2pos),
      div_eq_mul_inv]
  -- step 3: `2(p-1) 2^p ≤ 3`
  have h6 : 2 * (p - 1) * (2 : ℝ) ^ p ≤ 3 := by
    have h2p1 : 2 * (p - 1) ≤ 1 := by linarith
    have h2p : (2 : ℝ) ^ p ≤ 3 := by
      have h3 : (2 : ℝ) ^ p ≤ (2 : ℝ) ^ ((3 : ℝ) / 2) :=
        Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2) hp32
      have h4 : (2 : ℝ) ^ ((3 : ℝ) / 2) ≤ 3 := by
        have hsq : ((2 : ℝ) ^ ((3 : ℝ) / 2)) ^ (2 : ℕ) = 8 := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
          norm_num
        nlinarith [hsq, Real.rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ((3 : ℝ) / 2)]
      linarith
    have h2pnn : (0 : ℝ) ≤ (2 : ℝ) ^ p := by positivity
    nlinarith [h2p1, h2p, h2pnn]
  -- step 4: `3 ≤ k+2`, and `(k+2)(k+2)^{-p} = (k+2)^{1-p}`
  have h7 : (3 : ℝ) ≤ (((k + 2 : ℕ)) : ℝ) := by exact_mod_cast (by omega : 3 ≤ k + 2)
  have h8 : (((k + 2 : ℕ)) : ℝ) * (((k + 2 : ℕ)) : ℝ) ^ (-p)
      = (((k + 2 : ℕ)) : ℝ) ^ (1 - p) := by
    rw [show (1 : ℝ) - p = 1 + (-p) by ring,
      Real.rpow_add (show (0 : ℝ) < (((k + 2 : ℕ)) : ℝ) by positivity), Real.rpow_one]
  have hkn : (0 : ℝ) ≤ (((k + 2 : ℕ)) : ℝ) ^ (-p) := by positivity
  calc 2 * (p - 1) * (4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
      = 2 * (p - 1) * ((2 : ℝ) / (((2 * k + 1 : ℕ)) : ℝ)) ^ p := by
        rw [show 2 * (p - 1) * (4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
            = 2 * (p - 1) * ((4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)) by ring, h4]
    _ ≤ 2 * (p - 1) * ((2 : ℝ) / (((k + 2 : ℕ)) : ℝ)) ^ p := by
        refine mul_le_mul_of_nonneg_left hrp ?_
        linarith
    _ = 2 * (p - 1) * ((2 : ℝ) ^ p * (((k + 2 : ℕ)) : ℝ) ^ (-p)) := by rw [h5]
    _ ≤ 3 * (((k + 2 : ℕ)) : ℝ) ^ (-p) := by
        have h6' : 2 * (p - 1) * (2 : ℝ) ^ p * (((k + 2 : ℕ)) : ℝ) ^ (-p)
            ≤ 3 * (((k + 2 : ℕ)) : ℝ) ^ (-p) :=
          mul_le_mul_of_nonneg_right h6 hkn
        linarith [h6']
    _ ≤ (((k + 2 : ℕ)) : ℝ) * (((k + 2 : ℕ)) : ℝ) ^ (-p) :=
        mul_le_mul_of_nonneg_right h7 hkn
    _ = (((k + 2 : ℕ)) : ℝ) ^ (1 - p) := h8

/-- **All the Brown conditions at `k ≥ 1` hold** for `1 < p ≤ 3/2`. -/
theorem pair_brown_all_k {p : ℝ} (hp1 : 1 < p) (hp32 : p ≤ 3 / 2) :
    ∀ k : ℕ, 1 ≤ k → pairAlphabet p k ≤ ∑' j : ℕ, pairAlphabet p (j + (k + 1)) := by
  intro k hk
  have hp0 : (0 : ℝ) < p := by linarith
  have hpm : (0 : ℝ) < p - 1 := by linarith
  have hA : (0 : ℝ) < (((4 * k + 2 : ℕ)) : ℝ) := by positivity
  have htail := pairAlphabet_tail_ge (p := p) hp1 hk
  have hkey := pair_key hp1 hp32 hk
  have h4p : (0 : ℝ) < (4 : ℝ) ^ (-p) := Real.rpow_pos_of_pos (by norm_num) _
  have h4p' : (4 : ℝ) ^ p * (4 : ℝ) ^ (-p) = 1 := by
    rw [← Real.rpow_add (by norm_num : (0 : ℝ) < 4), add_neg_cancel, Real.rpow_zero]
  -- divide the key inequality by `4^p`
  have hsplit : 2 * (p - 1) * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
      ≤ (4 : ℝ) ^ (-p) * (((k + 2 : ℕ)) : ℝ) ^ (1 - p) := by
    have h1 := mul_le_mul_of_nonneg_right hkey (le_of_lt h4p)
    have h2 : (2 * (p - 1) * (4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)) * (4 : ℝ) ^ (-p)
        = 2 * (p - 1) * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p) := by
      rw [show (2 * (p - 1) * (4 : ℝ) ^ p * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)) * (4 : ℝ) ^ (-p)
          = 2 * (p - 1) * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
            * ((4 : ℝ) ^ p * (4 : ℝ) ^ (-p)) by ring,
        h4p', mul_one]
    rw [h2] at h1
    have h3 : (((k + 2 : ℕ)) : ℝ) ^ (1 - p) * (4 : ℝ) ^ (-p)
        = (4 : ℝ) ^ (-p) * (((k + 2 : ℕ)) : ℝ) ^ (1 - p) := mul_comm _ _
    rw [h3] at h1
    exact h1
  have hstep : 2 * (((4 * k + 2 : ℕ)) : ℝ) ^ (-p)
      ≤ (4 : ℝ) ^ (-p) * (((k + 2 : ℕ)) : ℝ) ^ (1 - p) / (p - 1) := by
    rw [le_div_iff₀ hpm]
    linarith [hsplit]
  exact le_trans (pairAlphabet_le hp0 k) (le_trans hstep htail)


/-! ## 7. The reachable set: recursion, gap, glue, census -/

/-- Finite sub-sums of `a` over the index window `[m, n)`. -/
def SubSumIco (a : ℕ → ℝ) (m n : ℕ) : Set ℝ :=
  {s | ∃ S : Finset ℕ, (∀ i ∈ S, m ≤ i ∧ i < n) ∧ s = ∑ i ∈ S, a i}

/-- An empty window has only the sub-sum `0`. -/
lemma SubSumIco_eq_singleton {a : ℕ → ℝ} {m n : ℕ} (h : n ≤ m) :
    SubSumIco a m n = {0} := by
  ext s; constructor
  · rintro ⟨S, hS, rfl⟩
    have hS0 : S = ∅ := by
      apply Finset.not_nonempty_iff_eq_empty.mp
      rintro ⟨i, hi⟩
      have h1 := (hS i hi).1
      have h2 := (hS i hi).2
      omega
    simp [hS0]
  · intro hs
    rw [Set.mem_singleton_iff] at hs
    subst hs
    exact ⟨∅, by simp, by simp⟩

/-- **The census recursion**: a sub-sum either uses the first term of the window or it
does not, so `S_{[m,n)} = S_{[m+1,n)} ∪ (a_m + S_{[m+1,n)})`. -/
lemma SubSumIco_succ {a : ℕ → ℝ} {m n : ℕ} (hmn : m < n) :
    SubSumIco a m n
      = SubSumIco a (m + 1) n ∪ (fun t => a m + t) '' SubSumIco a (m + 1) n := by
  ext s; constructor
  · rintro ⟨S, hS, rfl⟩
    by_cases hm : m ∈ S
    · right
      refine ⟨∑ i ∈ S.erase m, a i, ⟨S.erase m, ?_, rfl⟩, ?_⟩
      · intro i hi
        have h1 := Finset.mem_erase.mp hi
        have h2 := hS i (Finset.mem_of_mem_erase hi)
        omega
      · rw [show (∑ i ∈ S, a i) = a m + ∑ i ∈ S.erase m, a i by
          rw [← Finset.sum_erase_add _ _ hm]; ring]
    · left
      refine ⟨S, fun i hi => ⟨?_, (hS i hi).2⟩, rfl⟩
      have h1 := (hS i hi).1
      have h2 : i ≠ m := fun h => hm (h ▸ hi)
      omega
  · rintro (⟨S, hS, rfl⟩ | ⟨t, ⟨S, hS, rfl⟩, rfl⟩)
    · exact ⟨S, fun i hi => ⟨le_trans (by omega) (hS i hi).1, (hS i hi).2⟩, rfl⟩
    · refine ⟨insert m S, ?_, ?_⟩
      · intro i hi
        rcases Finset.mem_insert.mp hi with rfl | hi
        · exact ⟨le_rfl, hmn⟩
        · exact ⟨by have := (hS i hi).1; omega, (hS i hi).2⟩
      · have hnot : m ∉ S := by
          intro hmem
          have h1 := (hS m hmem).1
          omega
        rw [Finset.sum_insert hnot]

/-- **The gap lemma**: no sub-sum lies strictly between the tail total and `a m`. -/
lemma SubSumIco_gap {a : ℕ → ℝ} (ha : ∀ i, 0 ≤ a i) {m n : ℕ} {T : ℝ}
    (hT : ∀ S : Finset ℕ, (∀ i ∈ S, m < i) → (∀ i ∈ S, i < n) → ∑ i ∈ S, a i ≤ T)
    {s : ℝ} (hs : s ∈ SubSumIco a m n) : s ≤ T ∨ a m ≤ s := by
  obtain ⟨S, hS, rfl⟩ := hs
  by_cases hm : m ∈ S
  · exact Or.inr (Finset.single_le_sum (fun i _ => ha i) hm)
  · refine Or.inl (hT S (fun i hi => ?_) (fun i hi => (hS i hi).2))
    rcases eq_or_lt_of_le (hS i hi).1 with h | h
    · exact absurd (h ▸ hi) hm
    · exact h

/-- **Glueing (Brown's criterion, one step)**: if the tail window already fills `[0, T]`
and `a m ≤ T`, then the window fills `[0, a m + T]`. -/
lemma SubSumIco_glue {a : ℕ → ℝ} (ha : ∀ i, 0 ≤ a i) {m n : ℕ} (hmn : m < n) {T : ℝ}
    (hT : SubSumIco a (m + 1) n = Set.Icc 0 T) (hle : a m ≤ T) :
    SubSumIco a m n = Set.Icc 0 (a m + T) := by
  rw [SubSumIco_succ hmn, hT]
  ext s; constructor
  · rintro (hs | ⟨t, ht, rfl⟩)
    · rw [Set.mem_Icc] at hs ⊢
      exact ⟨hs.1, by linarith [hs.2, ha m]⟩
    · rw [Set.mem_Icc] at ht ⊢
      exact ⟨by linarith [ht.1, ha m], by linarith [ht.2]⟩
  · intro hs
    rw [Set.mem_Icc] at hs
    rcases le_or_gt s T with h | h
    · exact Or.inl ⟨hs.1, h⟩
    · exact Or.inr ⟨s - a m, ⟨by linarith [hs.1, ha m], by linarith [hs.2]⟩, by ring⟩

set_option linter.unusedVariables false in
/-- **The census at the first failure**: if the tail fills `[0, T]` and `a m > T`, the
window's sub-sums are exactly two intervals `[0, T] ∪ [a m, a m + T]`, with a gap of
length `a m - T`. -/
lemma SubSumIco_two_intervals {a : ℕ → ℝ} (ha : ∀ i, 0 ≤ a i) {m n : ℕ} (hmn : m < n)
    {T : ℝ} (hT : SubSumIco a (m + 1) n = Set.Icc 0 T) (hgap : T < a m) :
    SubSumIco a m n = Set.Icc 0 T ∪ Set.Icc (a m) (a m + T) := by
  rw [SubSumIco_succ hmn, hT]
  ext s; constructor
  · rintro (hs | ⟨t, ht, rfl⟩)
    · exact Or.inl hs
    · right
      rw [Set.mem_Icc] at ht ⊢
      exact ⟨by linarith [ht.1], by linarith [ht.2]⟩
  · rintro (hs | hs)
    · exact Or.inl hs
    · right
      rw [Set.mem_Icc] at hs
      exact ⟨s - a m, ⟨by linarith [hs.1], by linarith [hs.2]⟩, by ring⟩

/-- **Brown completeness (finite windows)**: if every term is dominated by the sum of
the later terms of the window, the sub-sums fill the whole interval `[0, Σ a]`. -/
theorem SubSumIco_eq_Icc_of_brown {a : ℕ → ℝ} (ha : ∀ i, 0 ≤ a i) :
    ∀ L : ℕ, ∀ m n : ℕ, n = m + L →
      (∀ i, m ≤ i → i < n → a i ≤ ∑ j ∈ Finset.Ico (i + 1) n, a j) →
      SubSumIco a m n = Set.Icc 0 (∑ i ∈ Finset.Ico m n, a i) := by
  intro L
  induction L with
  | zero =>
      intro m n hn _
      have hmn : n = m := by omega
      rw [hmn]
      rw [SubSumIco_eq_singleton (le_refl m), Finset.Ico_self, Finset.sum_empty, Set.Icc_self]
  | succ L ih =>
      intro m n hn hb
      have hlt : m < n := by omega
      have hb' : ∀ i, m + 1 ≤ i → i < n → a i ≤ ∑ j ∈ Finset.Ico (i + 1) n, a j :=
        fun i hi1 hi2 => hb i (by omega) hi2
      have hIH := ih (m + 1) n (by omega) hb'
      have hle : a m ≤ ∑ j ∈ Finset.Ico (m + 1) n, a j := hb m le_rfl hlt
      rw [SubSumIco_glue ha hlt hIH hle]
      have hsum : (∑ i ∈ Finset.Ico m n, a i)
          = a m + ∑ i ∈ Finset.Ico (m + 1) n, a i := by
        rw [Finset.sum_Ico_eq_sum_range, Finset.sum_Ico_eq_sum_range,
          show n - m = (n - (m + 1)) + 1 by omega, Finset.sum_range_succ',
          show m + 0 = m by omega]
        have hS : (∑ k ∈ Finset.range (n - (m + 1)), a (m + (k + 1)))
            = ∑ k ∈ Finset.range (n - (m + 1)), a (m + 1 + k) :=
          Finset.sum_congr rfl (fun k _ => by
            rw [show m + (k + 1) = m + 1 + k by omega])
        exact (add_comm _ _).trans (congrArg (fun x => a m + x) hS)
      rw [hsum]

/-- **The pair-alphabet gap**: no sub-sum of the pair alphabet lies strictly between the
tail total `Σ_{j≥1} a_j` and `a_0`. -/
lemma pairAlphabet_subsum_gap {p : ℝ} (hp : 1 < p) (n : ℕ) {s : ℝ}
    (hs : s ∈ SubSumIco (pairAlphabet p) 0 n) :
    s ≤ ∑' j : ℕ, pairAlphabet p (j + 1) ∨ pairAlphabet p 0 ≤ s := by
  refine SubSumIco_gap (pairAlphabet_nonneg p) (T := ∑' j : ℕ, pairAlphabet p (j + 1))
    (fun S hS1 hS2 => ?_) hs
  have h1 : (∑ i ∈ S, pairAlphabet p i) ≤ ∑ i ∈ Finset.Ico 1 n, pairAlphabet p i := by
    refine Finset.sum_le_sum_of_subset_of_nonneg ?_ ?_
    · intro i hi
      exact Finset.mem_Ico.mpr ⟨hS1 i hi, hS2 i hi⟩
    · intro i _ _; exact pairAlphabet_nonneg p i
  have h2 : (∑ i ∈ Finset.Ico 1 n, pairAlphabet p i) ≤ ∑' j : ℕ, pairAlphabet p (j + 1) := by
    rw [Finset.sum_Ico_eq_sum_range]
    have hsum : Summable fun j : ℕ => pairAlphabet p (j + 1) :=
      (summable_pairAlphabet hp).comp_injective (fun a b hab => by omega)
    have := hsum.sum_le_tsum (Finset.range (n - 1))
      (fun i _ => pairAlphabet_nonneg p (i + 1))
    simpa [Nat.add_comm] using this
  linarith

end

end ConeLean
