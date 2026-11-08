import ZeroTail
import GaussianZeroSide
import ZetaStrip

/-!
# Infinitude of the nontrivial zeros — formal core

This programme is the missing library fact behind `ZeroTailSummable`:
the nontrivial zero set has to be infinite (and then `Denumerable`) before
the Gaussian zero tail can be summed over an enumeration.

The file harvests the existing zero-counting layer (`xi₀_zeros_countable`,
`xi₀_zeros_finite_in_closedBall`, `xi₀_zero_count_bound`,
`xi₀_zeros_inv_sq_summable`, `exists_nontrivial_xi₀_enumeration`) and adds:

* `nontrivialZeros_countable` — the nontrivial zero set is countable;
* `nontrivialZeros_subtype_countable` — its subtype is `Countable`;
* `completedZeta_zero_of_xi₀_zero` — a nontrivial `ξ₀` zero is a zero of the
  completed zeta, via `xi₀_eq_mul_completedZeta`.

Infinitude itself is the open obligation; it is not assumed or axiomatised.
-/

noncomputable section
open Complex Filter Topology

namespace ZeroInfinitude
open AbsoluteHodgeExplicitFormula AbsoluteHodgeHadamard AbsoluteHodgeSymbol
open AbsoluteHodgeZetaStrip

/-- The set of nontrivial zeros `{z | ξ₀ z = 0 ∧ 0 < Re z}` is countable. -/
theorem nontrivialZeros_countable :
    {z : ℂ | xi₀ z = 0 ∧ 0 < z.re}.Countable :=
  Set.Countable.mono (fun z hz => hz.1) xi₀_zeros_countable

/-- The subtype of nontrivial zeros is countable. -/
theorem nontrivialZeros_subtype_countable :
    Countable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} :=
  Set.countable_coe_iff.mpr nontrivialZeros_countable

/-- A nontrivial `ξ₀` zero is a zero of the completed zeta. -/
theorem completedZeta_zero_of_xi₀_zero {z : ℂ} (hz : xi₀ z = 0) (hre : 0 < z.re) :
    completedZeta z = 0 := by
  have hz0 : z ≠ 0 := by intro h; subst h; simp at hre
  have hz1 : z ≠ 1 := by
    intro h
    subst h
    have h1 : xi₀ (1 : ℂ) = 1 := by unfold xi₀; ring
    rw [h1] at hz
    exact one_ne_zero hz
  have hΓ : z.Gammaℝ ≠ 0 := by
    intro h
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
    have hre' : z.re = -(2 * (n : ℝ)) := by rw [hn]; simp
    linarith [show (0 : ℝ) ≤ (n : ℝ) from Nat.cast_nonneg n]
  have hid := xi₀_eq_mul_completedZeta hz0 hz1 hΓ
  have hprod : z * (z - 1) * completedZeta z = 0 := by rw [← hid]; exact hz
  have hfac : z * (z - 1) ≠ 0 := mul_ne_zero hz0 (sub_ne_zero.mpr hz1)
  exact (mul_eq_zero.mp hprod).resolve_left hfac

/-- **Ordinate growth is automatic.**  If the inverse-square weight in the
ordinates is summable, the ordinates themselves tend to infinity: summability
forces the terms to zero and hence `|γ n| + 1 → ∞`. -/
theorem tendsto_abs_atTop_of_summable_inv_sq {γ : ℕ → ℝ}
    (h : Summable (fun n : ℕ => ((|γ n| + 1) ^ 2 : ℝ)⁻¹)) :
    Tendsto (fun n : ℕ => |γ n|) atTop atTop := by
  have h0 : Tendsto (fun n : ℕ => ((|γ n| + 1) ^ 2 : ℝ)⁻¹) atTop (𝓝 0) :=
    h.tendsto_atTop_zero
  rw [tendsto_atTop]
  intro M
  set N : ℝ := max M 0 with hN
  have hMN : M ≤ N := le_max_left M 0
  have hN1 : 0 < N + 1 := by
    have hN0 : (0 : ℝ) ≤ N := le_max_right M 0
    linarith
  have hbase : 0 < (N + 1) ^ 2 := pow_pos hN1 2
  have hev : ∀ᶠ n : ℕ in atTop, ((|γ n| + 1) ^ 2 : ℝ)⁻¹ < ((N + 1) ^ 2)⁻¹ :=
    (tendsto_order.1 h0).2 _ (inv_pos.mpr hbase)
  filter_upwards [hev] with n hn
  have hγ1 : 0 < |γ n| + 1 := by positivity
  have hq : 0 < (|γ n| + 1) ^ 2 := pow_pos hγ1 2
  have hn' : 1 / ((|γ n| + 1) ^ 2) < 1 / ((N + 1) ^ 2) := by
    simpa [one_div] using hn
  have hsq : (N + 1) ^ 2 < (|γ n| + 1) ^ 2 :=
    (one_div_lt_one_div hq hbase).1 hn'
  have hlt : N + 1 < |γ n| + 1 :=
    (sq_lt_sq₀ (by linarith : (0 : ℝ) ≤ N + 1)
      (by positivity : (0 : ℝ) ≤ |γ n| + 1)).1 hsq
  linarith

/-- **The zero tail is summable for any enumeration of nontrivial zeros.**
The linear log-growth hypothesis of `zeroTailSummable_of_nontrivial_xi₀_enumeration`
is discharged by the unconditional growth bound `exists_bound_log_norm_xi₀`,
and ordinate growth is derived from the resulting inverse-square summability.
No analytic input remains except the enumeration itself. -/
theorem zeroTailSummable_of_nontrivial_xi₀_enumeration' (a : ℕ → ℂ)
    (hinj : Function.Injective a) (hrange : ∀ n, xi₀ (a n) = 0)
    (hpos : ∀ n, 0 < (a n).re) (σ : ℝ) (hσ : 0 < σ) :
    ZeroTailSummable (fun n : ℕ => (a n).im) σ := by
  obtain ⟨A, B, hA, hgrowth⟩ := exists_bound_log_norm_xi₀
  have hgrowth' : ∀ z : ℂ,
      Real.log ‖xi₀ z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + max B 0 := by
    intro z
    have := hgrowth z
    linarith [le_max_left B 0]
  have hsub : Summable (fun w : {z : ℂ // xi₀ z = 0} =>
      (((‖(w : ℂ)‖ + 1) ^ 2 : ℝ))⁻¹) :=
    xi₀_zeros_inv_sq_summable_of_log_growth hA (le_max_right B 0) hgrowth'
  have hseq : Summable (fun n : ℕ => ((‖a n‖ + 1) ^ 2 : ℝ)⁻¹) :=
    summable_inv_sq_of_injective_enumeration hinj hrange hsub
  have hstrip : ∀ n, |(a n).re| ≤ 1 := by
    intro n
    have h := xi₀_zero_re_open_strip (hrange n) (hpos n)
    rw [abs_of_pos (hpos n)]
    linarith [h.2]
  have him : Summable (fun n : ℕ => ((|(a n).im| + 1) ^ 2 : ℝ)⁻¹) :=
    summable_inv_sq_im_of_strip a hstrip hseq
  exact zeroTailSummable_of_inv_sq (fun n : ℕ => (a n).im) σ hσ
    (tendsto_abs_atTop_of_summable_inv_sq him) (by simpa [one_div] using him)

/-- Under infinitude, the nontrivial-zero subtype is `Denumerable`. -/
theorem nontrivialZeros_denumerable_of_infinite
    (h : Infinite {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}) :
    Nonempty (Denumerable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}) := by
  haveI : Countable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} :=
    nontrivialZeros_subtype_countable
  letI : Infinite {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} := h
  exact nonempty_denumerable _

/-- **Infinitude makes the zeros unbounded in ordinate.**  If the nontrivial
zeros were bounded in imaginary part, the strip bound would place them in a
closed ball, where only finitely many zeros live. -/
theorem exists_zero_abs_im_gt (hinf : Infinite {z : ℂ // xi₀ z = 0 ∧ 0 < z.re})
    (T : ℝ) :
    ∃ z : ℂ, xi₀ z = 0 ∧ 0 < z.re ∧ T < |z.im| := by
  by_contra h
  push_neg at h
  have hinf' : ({z : ℂ | xi₀ z = 0 ∧ 0 < z.re} : Set ℂ).Infinite :=
    Set.infinite_coe_iff.mp hinf
  rcases le_or_gt 0 T with hT | hT
  · have hsub : {z : ℂ | xi₀ z = 0 ∧ 0 < z.re}
        ⊆ {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 (T + 2)} := by
      intro z hz
      refine ⟨hz.1, ?_⟩
      rw [Metric.mem_closedBall, dist_eq_norm]
      have him : |z.im| ≤ T := h z hz.1 hz.2
      have hstrip := xi₀_zero_re_open_strip hz.1 hz.2
      have hre : |z.re| ≤ 1 := by
        rw [abs_of_pos hz.2]
        linarith [hstrip.2]
      have hnorm : ‖z‖ ≤ |z.re| + |z.im| := Complex.norm_le_abs_re_add_abs_im z
      have hle : ‖z‖ ≤ T + 2 := by linarith
      simpa using hle
    have hfin : ({z : ℂ | xi₀ z = 0 ∧ 0 < z.re} : Set ℂ).Finite :=
      (xi₀_zeros_finite_in_closedBall (T + 2)).subset (fun z hz => hsub hz)
    exact hfin.not_infinite hinf'
  · obtain ⟨z, hz⟩ := hinf'.nonempty
    have hle := h z hz.1 hz.2
    have hnonneg : (0:ℝ) ≤ |z.im| := abs_nonneg _
    linarith

/-- **`Denumerable` is exactly infinitude** for the nontrivial-zero subtype,
since countability is already proved. -/
theorem nontrivialZeros_denumerable_iff_infinite :
    Nonempty (Denumerable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}) ↔
      Infinite {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} := by
  rw [nonempty_denumerable_iff]
  exact ⟨fun h => h.2, fun h => ⟨nontrivialZeros_subtype_countable, h⟩⟩

/-- Under infinitude, the nontrivial zeros admit an injective enumeration with
range exactly the nontrivial zero set. -/
theorem exists_nontrivial_xi₀_enumeration_of_infinite
    (h : Infinite {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}) :
    ∃ a : ℕ → ℂ, Function.Injective a ∧ (∀ n, xi₀ (a n) = 0) ∧
      (∀ n, 0 < (a n).re) ∧
      Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re} := by
  letI : Denumerable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} :=
    Classical.choice (nontrivialZeros_denumerable_of_infinite h)
  exact exists_nontrivial_xi₀_enumeration

/-- **The zero tail is monotone in the Gaussian width.**  Summability at one
positive width implies summability at every larger width, since
`exp(−σ'²γ²) ≤ exp(−σ²γ²)` for `σ ≤ σ'`. -/
theorem zeroTailSummable_mono {γ : ℕ → ℝ} {σ σ' : ℝ} (hσ : 0 < σ) (hσσ' : σ ≤ σ')
    (h : ZeroTailSummable γ σ) : ZeroTailSummable γ σ' := by
  unfold ZeroTailSummable at *
  apply Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) ?_ h
  intro n
  apply Real.exp_le_exp.mpr
  have hsq : σ ^ 2 ≤ σ' ^ 2 := by nlinarith
  nlinarith [sq_nonneg (γ n)]

/-- **`ZeroTailSummable` from infinitude alone.**  Once the nontrivial zeros
are known to be infinite, `Denumerable` gives an enumeration, and the zero tail
is summable unconditionally in the Gaussian weight. -/
theorem exists_enumeration_and_zeroTailSummable_of_infinite
    (h : Infinite {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}) (σ : ℝ) (hσ : 0 < σ) :
    ∃ a : ℕ → ℂ, Function.Injective a ∧
      Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re} ∧
      ZeroTailSummable (fun n : ℕ => (a n).im) σ := by
  obtain ⟨a, hinj, hzero, hpos, hrange⟩ :=
    exists_nontrivial_xi₀_enumeration_of_infinite h
  exact ⟨a, hinj, hrange,
    zeroTailSummable_of_nontrivial_xi₀_enumeration' a hinj hzero hpos σ hσ⟩

/-- The multiplicity-aware finite product over a finite zero set. -/
noncomputable def finiteZeroProduct (S : Finset ℂ) (m : ℂ → ℕ) : ℂ → ℂ :=
  fun z => ∏ w ∈ S, (z - w) ^ (m w)

/-- The finite zero product is entire. -/
theorem differentiable_finiteZeroProduct (S : Finset ℂ) (m : ℂ → ℕ) :
    Differentiable ℂ (finiteZeroProduct S m) := by
  unfold finiteZeroProduct
  fun_prop

/-- The finite zero product is nonzero away from its zero set. -/
theorem finiteZeroProduct_ne_zero (S : Finset ℂ) (m : ℂ → ℕ) {z : ℂ} (hz : z ∉ S) :
    finiteZeroProduct S m z ≠ 0 := by
  unfold finiteZeroProduct
  apply Finset.prod_ne_zero_iff.mpr
  intro w hw
  apply pow_ne_zero
  intro h
  apply hz
  rw [sub_eq_zero.mp h]
  exact hw

/-- The order of the finite zero product at one of its zeros is the prescribed
multiplicity. -/
theorem meromorphicOrderAt_finiteZeroProduct_of_mem (S : Finset ℂ) (m : ℂ → ℕ)
    {u : ℂ} (hu : u ∈ S) :
    meromorphicOrderAt (finiteZeroProduct S m) u = (m u : ℤ) := by
  unfold finiteZeroProduct
  have hfun : (fun z : ℂ => ∏ w ∈ S, (z - w) ^ (m w))
      = ∏ w ∈ S, fun z : ℂ => (z - w) ^ (m w) := by
    ext z
    simp
  rw [hfun]
  have hprod := meromorphicOrderAt_prod (s := S)
    (f := fun w z => (z - w) ^ (m w)) (x := u) (fun w _ => by fun_prop)
  rw [hprod]
  rw [Finset.sum_eq_single u]
  · exact meromorphicOrderAt_pow_id_sub_const (x := u) (n := m u)
  · intro w hw hwu
    have hne : (fun z : ℂ => (z - w) ^ (m w)) u ≠ 0 := by
      apply pow_ne_zero
      intro h
      exact hwu (sub_eq_zero.mp h).symm
    have hana : AnalyticAt ℂ (fun z : ℂ => (z - w) ^ (m w)) u := by fun_prop
    have h0 : meromorphicOrderAt (fun z : ℂ => (z - w) ^ (m w)) u = 0 := by
      rw [hana.meromorphicOrderAt_eq, hana.analyticOrderAt_eq_zero.mpr hne]
      simp
    simp [h0]
  · intro hnot
    exact absurd hu hnot

/-- The finite zero product has order zero away from its zero set. -/
theorem meromorphicOrderAt_finiteZeroProduct_of_not_mem (S : Finset ℂ) (m : ℂ → ℕ)
    {u : ℂ} (hu : u ∉ S) :
    meromorphicOrderAt (finiteZeroProduct S m) u = 0 := by
  have hne : finiteZeroProduct S m u ≠ 0 := finiteZeroProduct_ne_zero S m hu
  have hana : AnalyticAt ℂ (finiteZeroProduct S m) u :=
    (differentiable_finiteZeroProduct S m).analyticAt u
  rw [hana.meromorphicOrderAt_eq, hana.analyticOrderAt_eq_zero.mpr hne]
  simp

/-- Away from a finite set containing all the zeros, `ξ₀` has order zero. -/
theorem meromorphicOrderAt_xi₀_of_not_mem (S : Finset ℂ)
    (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {u : ℂ} (hu : u ∉ S) :
    meromorphicOrderAt xi₀ u = 0 := by
  have hne : xi₀ u ≠ 0 := by
    intro h
    exact hu ((hS u).mp h)
  have hana : AnalyticAt ℂ xi₀ u := differentiable_xi₀.analyticAt u
  rw [hana.meromorphicOrderAt_eq, hana.analyticOrderAt_eq_zero.mpr hne]
  simp

/-- The analytic order of `ξ₀` is finite everywhere (the function is not
identically zero). -/
theorem analyticOrderAt_xi₀_ne_top (u : ℂ) : analyticOrderAt xi₀ u ≠ ⊤ := by
  intro h
  have hzero : ∀ᶠ z in 𝓝 u, xi₀ z = 0 := analyticOrderAt_eq_top.mp h
  have hU : IsPreconnected (Set.univ : Set ℂ) := isPreconnected_univ
  have hana : AnalyticOnNhd ℂ xi₀ Set.univ :=
    differentiable_xi₀.differentiableOn.analyticOnNhd isOpen_univ
  have hEq : Set.EqOn xi₀ 0 Set.univ :=
    hana.eqOn_zero_of_preconnected_of_eventuallyEq_zero
      hU (Set.mem_univ u) (by
        filter_upwards [hzero] with z hz
        simpa using hz)
  have h0 := hEq (Set.mem_univ (0 : ℂ))
  simp [xi₀] at h0

/-- At a zero, the meromorphic order of `ξ₀` is its analytic multiplicity. -/
theorem meromorphicOrderAt_xi₀_of_mem (S : Finset ℂ)
    (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {u : ℂ} (hu : u ∈ S) :
    meromorphicOrderAt xi₀ u = (analyticOrderNatAt xi₀ u : ℤ) := by
  have hana : AnalyticAt ℂ xi₀ u := differentiable_xi₀.analyticAt u
  rw [hana.meromorphicOrderAt_eq]
  rw [← Nat.cast_analyticOrderNatAt (f := xi₀) (z₀ := u) (analyticOrderAt_xi₀_ne_top u)]
  rw [ENat.map_natCast]

/-- **The finite-zero quotient exists.**  If the zero set is a finite set `S`,
then `ξ₀ / ∏ (z−w)^{m_w}` has an entire zero-free representative. -/
theorem exists_entire_zeroFree_quotient_of_finite_zeros (S : Finset ℂ)
    (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) :
    ∃ Q : ℂ → ℂ,
      Q = toMeromorphicNFOn
        (fun z => xi₀ z / finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z)
        Set.univ ∧
      Differentiable ℂ Q ∧ ∀ z, Q z ≠ 0 := by
  set m : ℂ → ℕ := fun w => analyticOrderNatAt xi₀ w
  have hf : MeromorphicOn xi₀ Set.univ :=
    fun z _ => (differentiable_xi₀.analyticAt z).meromorphicAt
  have hP : MeromorphicOn (finiteZeroProduct S m) Set.univ :=
    fun z _ => ((differentiable_finiteZeroProduct S m).analyticAt z).meromorphicAt
  have hmatch : ∀ u, meromorphicOrderAt xi₀ u
      = meromorphicOrderAt (finiteZeroProduct S m) u := by
    intro u
    by_cases hu : u ∈ S
    · rw [meromorphicOrderAt_xi₀_of_mem S hS hu,
        meromorphicOrderAt_finiteZeroProduct_of_mem S m hu]
    · rw [meromorphicOrderAt_xi₀_of_not_mem S hS hu,
        meromorphicOrderAt_finiteZeroProduct_of_not_mem S m hu]
  have hfin : ∀ u, meromorphicOrderAt xi₀ u ≠ ⊤ := by
    intro u
    have hana : AnalyticAt ℂ xi₀ u := differentiable_xi₀.analyticAt u
    rw [hana.meromorphicOrderAt_eq]
    simp only [ne_eq, ENat.map_eq_top_iff]
    exact analyticOrderAt_xi₀_ne_top u
  exact exists_entire_zeroFree_quotient hf hP hmatch hfin

/-- The finite zero product times the quotient representative recovers `ξ₀`. -/
theorem finiteZeroProduct_mul_quotient_eq (S : Finset ℂ)
    (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {Q : ℂ → ℂ}
    (hQ : Q = toMeromorphicNFOn
      (fun z => xi₀ z / finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z) Set.univ)
    (hQdiff : Differentiable ℂ Q) :
    ∀ z, finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * Q z = xi₀ z := by
  intro z
  set m : ℂ → ℕ := fun w => analyticOrderNatAt xi₀ w
  set P : ℂ → ℂ := finiteZeroProduct S m
  by_cases hPz : P z = 0
  · have hzS : z ∈ S := by
      by_contra hz
      exact (finiteZeroProduct_ne_zero S m hz) hPz
    have hξz : xi₀ z = 0 := (hS z).mpr hzS
    rw [hPz, zero_mul, hξz]
  · have hG : DifferentiableAt ℂ (fun w => xi₀ w / P w) z :=
      (differentiable_xi₀ z).div ((differentiable_finiteZeroProduct S m) z) hPz
    have hf : MeromorphicOn (fun w => xi₀ w / P w) Set.univ := by
      intro w _
      exact ((differentiable_xi₀.analyticAt w).meromorphicAt.div
        ((differentiable_finiteZeroProduct S m).analyticAt w).meromorphicAt)
    have hQeq : Q =ᶠ[𝓝[≠] z] (fun w => xi₀ w / P w) := by
      rw [hQ]
      exact MeromorphicOn.toMeromorphicNFOn_eq_self_on_nhdsNE hf (Set.mem_univ z)
    have hQcont : Tendsto Q (𝓝[≠] z) (𝓝 (Q z)) :=
      (hQdiff z).continuousAt.tendsto.mono_left nhdsWithin_le_nhds
    have hGcont : Tendsto (fun w => xi₀ w / P w) (𝓝[≠] z) (𝓝 (xi₀ z / P z)) :=
      hG.continuousAt.tendsto.mono_left nhdsWithin_le_nhds
    have hGQ : xi₀ z / P z = Q z :=
      tendsto_nhds_unique hGcont (hQcont.congr' hQeq)
    calc P z * Q z = P z * (xi₀ z / P z) := by rw [← hGQ]
      _ = xi₀ z := by field_simp [hPz]

/-- **Finite-zero factorization with an entire exponent.**  If the zero set is
finite, then `ξ₀` is the finite zero product times `exp` of an entire function. -/
theorem exists_entire_log_factorization_of_finite_zeros (S : Finset ℂ)
    (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) :
    ∃ g : ℂ → ℂ, Differentiable ℂ g ∧
      ∀ z, xi₀ z
        = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (g z) := by
  obtain ⟨Q, hQ, hQdiff, hQne⟩ := exists_entire_zeroFree_quotient_of_finite_zeros S hS
  have hfac := finiteZeroProduct_mul_quotient_eq S hS hQ hQdiff
  obtain ⟨g, hg, hgce⟩ := exists_differentiable_cexp_univ hQdiff hQne
  exact ⟨g, hg, fun z => by rw [← hfac z, hgce z]⟩

/-- **Conditional affine factorization.**  If the entire exponent of the
finite-zero factorization has linear real growth, then it is affine. -/
theorem exists_affine_factorization_of_finite_zeros_of_growth
    (S : Finset ℂ) (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S)
    (h : ∃ (g : ℂ → ℂ) (A B : ℝ), Differentiable ℂ g ∧ 0 ≤ A ∧
      (∀ z, xi₀ z
        = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (g z)) ∧
      ∀ z, (g z).re ≤ A * ‖z‖ + B) :
    ∃ a b : ℂ, ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (a + b * z) := by
  obtain ⟨g, A, B, hg, hA, hfac, hbound⟩ := h
  set Q : ℂ → ℂ := fun z => cexp (g z)
  have hQdiff : Differentiable ℂ Q := by
    unfold Q
    exact hg.cexp
  have hQne : ∀ z, Q z ≠ 0 := by
    intro z
    exact Complex.exp_ne_zero (g z)
  have hlog : HasLogGrowthOne Q := by
    refine ⟨A, B, hA, fun z => ?_⟩
    have hnorm : ‖Q z‖ = Real.exp ((g z).re) := by
      unfold Q
      rw [Complex.norm_exp]
    rw [hnorm, Real.log_exp]
    exact hbound z
  have hfac' : ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * Q z := by
    intro z
    rw [hfac z]
  exact exists_affine_factorization_of_zeroFree_quotient hQdiff hQne hlog hfac'

/-- A nonconstant complex polynomial is at least `1` in modulus on every
sufficiently large circle. -/
theorem exists_norm_eval_ge_one_on_sphere (P : Polynomial ℂ) (hP : 0 < P.degree) :
    ∃ R0 : ℝ, ∀ R : ℝ, R0 ≤ R → ∀ w : ℂ, ‖w‖ = R → 1 ≤ ‖P.eval w‖ := by
  have htend : Tendsto (fun w : ℂ => ‖P.eval w‖) (Bornology.cobounded ℂ) atTop :=
    P.tendsto_norm_atTop hP tendsto_norm_cobounded_atTop
  have hev : ∀ᶠ w : ℂ in Bornology.cobounded ℂ, 1 ≤ ‖P.eval w‖ :=
    htend.eventually_ge_atTop 1
  obtain ⟨R0, -, hR0⟩ := (Filter.hasBasis_cobounded_norm (E := ℂ)).mem_iff.mp hev
  refine ⟨R0, fun R hR w hw => hR0 ?_⟩
  rw [Set.mem_setOf_eq, hw]
  exact hR

/-- Maximum-modulus corollary: an entire function bounded on a circle is
bounded by the same constant on the closed disk. -/
theorem norm_le_of_forall_sphere_norm_le {f : ℂ → ℂ} (hf : Differentiable ℂ f)
    {R C : ℝ} (hR : 0 < R) (hC : ∀ w : ℂ, ‖w‖ = R → ‖f w‖ ≤ C) :
    ∀ z : ℂ, ‖z‖ ≤ R → ‖f z‖ ≤ C := by
  intro z hz
  refine Complex.norm_le_of_forall_mem_frontier_norm_le
    (U := Metric.ball (0 : ℂ) R) Metric.isBounded_ball ?_ ?_ ?_
  · exact hf.diffContOnCl
  · intro w hw
    rw [frontier_ball (0 : ℂ) hR.ne'] at hw
    exact hC w (by simpa [Metric.mem_sphere] using hw)
  · rw [closure_ball (0 : ℂ) hR.ne']
    exact Metric.mem_closedBall.mpr (by simpa using hz)

/-- The zero-free quotient is bounded on a disk by the `ξ₀` growth, once the
polynomial is at least `1` on the boundary circle. -/
theorem norm_quotient_le_on_ball {P Q : ℂ → ℂ} {A B R : ℝ}
    (hfac : ∀ z, xi₀ z = P z * Q z) (hQne : ∀ z, Q z ≠ 0)
    (hQdiff : Differentiable ℂ Q)
    (hξ : ∀ z, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + B)
    (hP : ∀ w : ℂ, ‖w‖ = R → 1 ≤ ‖P w‖) (hR : 0 < R) :
    ∀ z : ℂ, ‖z‖ ≤ R →
      ‖Q z‖ ≤ Real.exp (A * R * Real.log (R + 2) + B) := by
  have hcircle : ∀ w : ℂ, ‖w‖ = R →
      ‖Q w‖ ≤ Real.exp (A * R * Real.log (R + 2) + B) := by
    intro w hw
    have hξw : ‖xi₀ w‖ = ‖P w‖ * ‖Q w‖ := by
      rw [hfac w, norm_mul]
    have hPw : 1 ≤ ‖P w‖ := hP w hw
    have hQle : ‖Q w‖ ≤ ‖xi₀ w‖ := by
      rw [hξw]
      exact le_mul_of_one_le_left (norm_nonneg _) hPw
    have hpos : 0 < ‖xi₀ w‖ := by
      rw [hξw]
      exact mul_pos (lt_of_lt_of_le zero_lt_one hPw) (norm_pos_iff.mpr (hQne w))
    have hexp : ‖xi₀ w‖ ≤ Real.exp (A * R * Real.log (R + 2) + B) := by
      have hlog : Real.log ‖xi₀ w‖ ≤ A * ‖w‖ * Real.log (‖w‖ + 2) + B := hξ w
      rw [hw] at hlog
      exact (Real.log_le_iff_le_exp hpos).mp hlog
    exact hQle.trans hexp
  exact fun z hz => norm_le_of_forall_sphere_norm_le hQdiff hR hcircle z hz

/-- **Conditional affine factorization from a subquadratic bound.**  If the
entire exponent of the finite-zero factorization is `O(‖z‖^{3/2})`, it is
affine. -/
theorem exists_affine_factorization_of_finite_zeros_of_subquadratic
    (S : Finset ℂ) (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S)
    (h : ∃ (g : ℂ → ℂ) (C D : ℝ), 0 ≤ C ∧ Differentiable ℂ g ∧
      (∀ z, xi₀ z
        = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (g z)) ∧
      ∀ z, (g z).re ≤ C * ‖z‖ ^ (3 / 2 : ℝ) + D) :
    ∃ a b : ℂ, ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (a + b * z) := by
  obtain ⟨g, C, D, hC, hg, hfac, hbound⟩ := h
  obtain ⟨a, b, hab⟩ := subquadratic_eq_affine_of_re_le_rpow hg hC
    (by norm_num : (1 : ℝ) < 3 / 2) (by norm_num : (3 / 2 : ℝ) < 2) hbound
  exact ⟨a, b, fun z => by rw [hfac z, hab z]⟩

/-- The logarithmic bound `log(1+x) ≤ 2√(1+x)` used in the subquadratic
estimate. -/
theorem log_one_add_le_two_sqrt (x : ℝ) (hx : 0 ≤ x) :
    Real.log (1 + x) ≤ 2 * (1 + x) ^ (1 / 2 : ℝ) := by
  have hpos : 0 < 1 + x := by linarith
  have h := Real.log_le_sub_one_of_pos (Real.rpow_pos_of_pos hpos (1 / 2 : ℝ))
  rw [Real.log_rpow hpos] at h
  have hsqrt : 0 < (1 + x) ^ (1 / 2 : ℝ) := Real.rpow_pos_of_pos hpos _
  nlinarith

/-- The remaining analytic input for infinitude: a subquadratic real-growth
bound on the entire exponent of the finite-zero factorization. -/
def FiniteZeroSubquadraticBound (g : ℂ → ℂ) : Prop :=
  ∃ C D : ℝ, 0 ≤ C ∧ ∀ z, (g z).re ≤ C * ‖z‖ ^ (3 / 2 : ℝ) + D

/-- The named subquadratic input makes the finite-zero factorization affine. -/
theorem exists_affine_factorization_of_finite_zeros_of_bound
    (S : Finset ℂ) (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {g : ℂ → ℂ}
    (hg : Differentiable ℂ g)
    (hfac : ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (g z))
    (h : FiniteZeroSubquadraticBound g) :
    ∃ a b : ℂ, ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (a + b * z) := by
  obtain ⟨C, D, hC, hbound⟩ := h
  exact exists_affine_factorization_of_finite_zeros_of_subquadratic S hS
    ⟨g, C, D, hC, hg, hfac, hbound⟩

/-- For `r ≥ 0`, `1 + r ≤ (1 + r)^{3/2}`. -/
theorem one_add_le_rpow_three_halves (r : ℝ) (hr : 0 ≤ r) :
    (1 + r) ≤ (1 + r) ^ (3 / 2 : ℝ) := by
  have h1 : 1 ≤ (1 + r) ^ (1 / 2 : ℝ) :=
    Real.one_le_rpow (by linarith) (by norm_num)
  calc (1 + r) = (1 + r) * 1 := by ring
    _ ≤ (1 + r) * (1 + r) ^ (1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left h1 (by linarith)
    _ = (1 + r) ^ (3 / 2 : ℝ) := by
        nth_rewrite 1 [← Real.rpow_one (1 + r)]
        rw [← Real.rpow_add (by linarith)]
        norm_num

/-- The real inequality behind the subquadratic bound:
`max R0 (r+1) · log(max R0 (r+1) + 2) ≤ C (1+r)^{3/2}`. -/
theorem rlog_bound (R0 : ℝ) (hR0 : 0 ≤ R0) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ r : ℝ, 0 ≤ r →
      max R0 (r + 1) * Real.log (max R0 (r + 1) + 2)
        ≤ C * (1 + r) ^ (3 / 2 : ℝ) := by
  have hL : 0 ≤ Real.log (R0 + 3) := Real.log_nonneg (by linarith)
  refine ⟨(R0 + 1) * (Real.log (R0 + 3) + 2), by positivity, fun r hr => ?_⟩
  set R := max R0 (r + 1) with hR
  have hRle : R ≤ (R0 + 1) * (r + 1) := by
    have hmax : R ≤ R0 + (r + 1) := by
      rw [hR]
      exact max_le (by linarith) (by linarith)
    nlinarith
  have hRge1 : 1 ≤ R := by
    rw [hR]
    exact le_trans (by linarith : (1 : ℝ) ≤ r + 1) (le_max_right R0 (r + 1))
  have hlog_le : Real.log (R + 2) ≤ Real.log ((R0 + 3) * (r + 1)) := by
    apply Real.log_le_log (by positivity)
    rw [hR]
    nlinarith [le_max_left R0 (r + 1), le_max_right R0 (r + 1)]
  have hlog_split : Real.log ((R0 + 3) * (r + 1))
      = Real.log (R0 + 3) + Real.log (r + 1) := by
    rw [Real.log_mul (by positivity) (by linarith)]
  have hlog_sqrt : Real.log (r + 1) ≤ 2 * (1 + r) ^ (1 / 2 : ℝ) := by
    have := log_one_add_le_two_sqrt r (by linarith)
    simpa [add_comm] using this
  have hlog_bound : Real.log (R + 2)
      ≤ Real.log (R0 + 3) + 2 * (1 + r) ^ (1 / 2 : ℝ) := by
    rw [hlog_split] at hlog_le
    linarith
  have hlogR_nonneg : 0 ≤ Real.log (R + 2) := by
    apply Real.log_nonneg
    linarith
  have hmul : R * Real.log (R + 2) ≤ (R0 + 1) * (r + 1) *
      (Real.log (R0 + 3) + 2 * (1 + r) ^ (1 / 2 : ℝ)) := by
    exact mul_le_mul hRle hlog_bound hlogR_nonneg
      (mul_nonneg (by linarith) (by linarith))
  have hnorm : (r + 1) * (1 + r) ^ (1 / 2 : ℝ) = (1 + r) ^ (3 / 2 : ℝ) := by
    have h1r : (r + 1) = (1 + r) ^ (1 : ℝ) := by
      rw [Real.rpow_one]
      ring
    rw [h1r, ← Real.rpow_add (by linarith)]
    norm_num
  have hpow : (1 + r) ≤ (1 + r) ^ (3 / 2 : ℝ) :=
    one_add_le_rpow_three_halves r hr
  have h2 : (r + 1) * (Real.log (R0 + 3) + 2 * (1 + r) ^ (1 / 2 : ℝ))
      ≤ (Real.log (R0 + 3) + 2) * (1 + r) ^ (3 / 2 : ℝ) := by
    have hsq : 0 ≤ (1 + r) ^ (1 / 2 : ℝ) := Real.rpow_nonneg (by linarith) _
    calc (r + 1) * (Real.log (R0 + 3) + 2 * (1 + r) ^ (1 / 2 : ℝ))
        = Real.log (R0 + 3) * (r + 1) + 2 * ((r + 1) * (1 + r) ^ (1 / 2 : ℝ)) := by ring
      _ = Real.log (R0 + 3) * (r + 1) + 2 * (1 + r) ^ (3 / 2 : ℝ) := by rw [hnorm]
      _ ≤ Real.log (R0 + 3) * (1 + r) ^ (3 / 2 : ℝ) + 2 * (1 + r) ^ (3 / 2 : ℝ) := by
          have h := mul_le_mul_of_nonneg_left hpow hL
          linarith
      _ = (Real.log (R0 + 3) + 2) * (1 + r) ^ (3 / 2 : ℝ) := by ring
  calc R * Real.log (R + 2)
      ≤ (R0 + 1) * (r + 1) * (Real.log (R0 + 3) + 2 * (1 + r) ^ (1 / 2 : ℝ)) := hmul
    _ = (R0 + 1) * ((r + 1) * (Real.log (R0 + 3) + 2 * (1 + r) ^ (1 / 2 : ℝ))) := by ring
    _ ≤ (R0 + 1) * ((Real.log (R0 + 3) + 2) * (1 + r) ^ (3 / 2 : ℝ)) := by
        exact mul_le_mul_of_nonneg_left h2 (by positivity)
    _ = ((R0 + 1) * (Real.log (R0 + 3) + 2)) * (1 + r) ^ (3 / 2 : ℝ) := by ring

/-- The subquadratic comparison `(1+r)^{3/2} ≤ 2^{3/2}(1+r^{3/2})`. -/
theorem one_add_rpow_three_halves_le (r : ℝ) (hr : 0 ≤ r) :
    (1 + r) ^ (3 / 2 : ℝ) ≤ (2 : ℝ) ^ (3 / 2 : ℝ) * (1 + r ^ (3 / 2 : ℝ)) := by
  have h23 : 0 ≤ (2 : ℝ) ^ (3 / 2 : ℝ) := Real.rpow_nonneg (by norm_num) _
  rcases le_or_gt r 1 with hle | hgt
  · have h1 : 0 ≤ (1 + r) ^ (3 / 2 : ℝ) := Real.rpow_nonneg (by linarith) _
    have h2 : (1 + r) ^ (3 / 2 : ℝ) ≤ (2 : ℝ) ^ (3 / 2 : ℝ) := by
      apply Real.rpow_le_rpow (by linarith) (by linarith) (by norm_num)
    have h3 : (1 : ℝ) ≤ 1 + r ^ (3 / 2 : ℝ) := by
      have : 0 ≤ r ^ (3 / 2 : ℝ) := Real.rpow_nonneg hr _
      linarith
    calc (1 + r) ^ (3 / 2 : ℝ) ≤ (2 : ℝ) ^ (3 / 2 : ℝ) := h2
      _ = (2 : ℝ) ^ (3 / 2 : ℝ) * 1 := by ring
      _ ≤ (2 : ℝ) ^ (3 / 2 : ℝ) * (1 + r ^ (3 / 2 : ℝ)) := by
          exact mul_le_mul_of_nonneg_left h3 h23
  · have hr1 : 1 ≤ r := le_of_lt hgt
    have hle2 : 1 + r ≤ 2 * r := by linarith
    have h1 : (1 + r) ^ (3 / 2 : ℝ) ≤ (2 * r) ^ (3 / 2 : ℝ) := by
      apply Real.rpow_le_rpow (by linarith) hle2 (by norm_num)
    have h2 : (2 * r) ^ (3 / 2 : ℝ) = (2 : ℝ) ^ (3 / 2 : ℝ) * r ^ (3 / 2 : ℝ) := by
      rw [Real.mul_rpow (by norm_num) hr]
    have h3 : (2 : ℝ) ^ (3 / 2 : ℝ) * r ^ (3 / 2 : ℝ)
        ≤ (2 : ℝ) ^ (3 / 2 : ℝ) * (1 + r ^ (3 / 2 : ℝ)) := by
      apply mul_le_mul_of_nonneg_left _ h23
      have : 0 ≤ r ^ (3 / 2 : ℝ) := Real.rpow_nonneg hr _
      linarith
    calc (1 + r) ^ (3 / 2 : ℝ) ≤ (2 * r) ^ (3 / 2 : ℝ) := h1
      _ = (2 : ℝ) ^ (3 / 2 : ℝ) * r ^ (3 / 2 : ℝ) := h2
      _ ≤ (2 : ℝ) ^ (3 / 2 : ℝ) * (1 + r ^ (3 / 2 : ℝ)) := h3

/-- **The subquadratic exponent bound from the quotient estimate.**  Combining
the quotient disk bound, the real `r log r` estimate and the subquadratic
comparison gives `FiniteZeroSubquadraticBound g`. -/
theorem finiteZeroSubquadraticBound_of_quotient {P Q g : ℂ → ℂ} {A B R0 : ℝ}
    (hA : 0 ≤ A)
    (hfac : ∀ z, xi₀ z = P z * Q z) (hQne : ∀ z, Q z ≠ 0)
    (hQdiff : Differentiable ℂ Q) (hQexp : ∀ z, Q z = cexp (g z))
    (hξ : ∀ z, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + B)
    (hP : ∀ w : ℂ, R0 ≤ ‖w‖ → 1 ≤ ‖P w‖) (hR0 : 0 ≤ R0) :
    FiniteZeroSubquadraticBound g := by
  obtain ⟨C, hC, hbound⟩ := rlog_bound R0 hR0
  have h23 : 0 ≤ (2 : ℝ) ^ (3 / 2 : ℝ) := Real.rpow_nonneg (by norm_num) _
  have hAC : 0 ≤ A * C := mul_nonneg hA hC
  refine ⟨A * C * (2 : ℝ) ^ (3 / 2 : ℝ), B + A * C * (2 : ℝ) ^ (3 / 2 : ℝ), ?_, fun z => ?_⟩
  · positivity
  · set r := ‖z‖ with hr
    have hr0 : 0 ≤ r := norm_nonneg z
    set R := max R0 (r + 1) with hR
    have hR0le : R0 ≤ R := le_max_left _ _
    have hzR : ‖z‖ ≤ R := by
      rw [hR]
      exact le_trans (by linarith : r ≤ r + 1) (le_max_right R0 (r + 1))
    have hRpos : 0 < R := by
      rw [hR]
      exact lt_of_lt_of_le (by linarith : 0 < r + 1) (le_max_right R0 (r + 1))
    have hP' : ∀ w : ℂ, ‖w‖ = R → 1 ≤ ‖P w‖ := by
      intro w hw
      exact hP w (by rw [hw]; exact hR0le)
    have hQbound := norm_quotient_le_on_ball hfac hQne hQdiff hξ hP' hRpos z hzR
    have hnormQ : ‖Q z‖ = Real.exp ((g z).re) := by
      rw [hQexp z, Complex.norm_exp]
    have hexp_le : Real.exp ((g z).re) ≤ Real.exp (A * R * Real.log (R + 2) + B) := by
      rwa [← hnormQ]
    have hre_le : (g z).re ≤ A * R * Real.log (R + 2) + B :=
      Real.exp_le_exp.mp hexp_le
    have hrlog : R * Real.log (R + 2) ≤ C * (1 + r) ^ (3 / 2 : ℝ) := hbound r hr0
    have hmul : A * R * Real.log (R + 2) ≤ A * C * (1 + r) ^ (3 / 2 : ℝ) := by
      have h := mul_le_mul_of_nonneg_left hrlog hA
      nlinarith
    have hstep : (g z).re ≤ A * C * (1 + r) ^ (3 / 2 : ℝ) + B := by linarith
    have hconv := one_add_rpow_three_halves_le r hr0
    have hfinal : A * C * (1 + r) ^ (3 / 2 : ℝ) + B
        ≤ (A * C * (2 : ℝ) ^ (3 / 2 : ℝ)) * r ^ (3 / 2 : ℝ)
          + (B + A * C * (2 : ℝ) ^ (3 / 2 : ℝ)) := by
      have h := mul_le_mul_of_nonneg_left hconv hAC
      have hrp : 0 ≤ r ^ (3 / 2 : ℝ) := Real.rpow_nonneg hr0 _
      nlinarith
    calc (g z).re ≤ A * C * (1 + r) ^ (3 / 2 : ℝ) + B := hstep
      _ ≤ (A * C * (2 : ℝ) ^ (3 / 2 : ℝ)) * r ^ (3 / 2 : ℝ)
            + (B + A * C * (2 : ℝ) ^ (3 / 2 : ℝ)) := hfinal
      _ = (A * C * (2 : ℝ) ^ (3 / 2 : ℝ)) * ‖z‖ ^ (3 / 2 : ℝ)
            + (B + A * C * (2 : ℝ) ^ (3 / 2 : ℝ)) := by rw [hr]

/-- The logarithmic derivative of the finite zero product is the sum of the
multiplicity-weighted simple poles. -/
theorem logDeriv_finiteZeroProduct (S : Finset ℂ) (m : ℂ → ℕ) {z : ℂ} (hz : z ∉ S) :
    logDeriv (finiteZeroProduct S m) z = ∑ w ∈ S, (m w : ℂ) / (z - w) := by
  unfold finiteZeroProduct
  have hfun : (fun z : ℂ => ∏ w ∈ S, (z - w) ^ (m w))
      = ∏ w ∈ S, fun z : ℂ => (z - w) ^ (m w) := by
    ext z
    simp
  rw [hfun]
  rw [logDeriv_prod (x := z) (f := fun w z => (z - w) ^ (m w))]
  · apply Finset.sum_congr rfl
    intro w hw
    have hcomp : (fun z : ℂ => (z - w) ^ (m w)) = (fun t : ℂ => t ^ (m w)) ∘ (fun z : ℂ => z - w) := rfl
    rw [hcomp, logDeriv_comp]
    · rw [logDeriv_pow]
      simp
    · fun_prop
    · fun_prop
  · intro w hw
    exact pow_ne_zero _ (sub_ne_zero.mpr (by intro h; exact hz (h ▸ hw)))
  · intro w hw
    fun_prop

/-- The logarithmic derivative of the finite zero product is bounded along the
large real axis. -/
theorem exists_norm_logDeriv_finiteZeroProduct_le (S : Finset ℂ) (m : ℂ → ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ s : ℝ, M ≤ s →
      ‖logDeriv (finiteZeroProduct S m) (s : ℂ)‖ ≤ M := by
  obtain ⟨R, hR⟩ := S.finite_toSet.isBounded.exists_norm_le
  set M : ℝ := max (∑ w ∈ S, (m w : ℝ)) (R + 1) with hM
  have hM0 : 0 ≤ M := by
    rw [hM]
    exact le_max_of_le_left (by positivity)
  refine ⟨M, hM0, fun s hs => ?_⟩
  · have hMsum : (∑ w ∈ S, (m w : ℝ)) ≤ M := by rw [hM]; exact le_max_left _ _
    have hMR : R + 1 ≤ M := by rw [hM]; exact le_max_right _ _
    have hsR : R + 1 ≤ s := le_trans hMR hs
    have hs0 : 0 ≤ s := le_trans hM0 hs
    have hnot : (s : ℂ) ∉ S := by
      intro hmem
      have hle : ‖(s : ℂ)‖ ≤ R := hR (s : ℂ) (by simpa using hmem)
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hs0] at hle
      linarith
    rw [logDeriv_finiteZeroProduct S m hnot]
    calc ‖∑ w ∈ S, (m w : ℂ) / ((s : ℂ) - w)‖
        ≤ ∑ w ∈ S, ‖(m w : ℂ) / ((s : ℂ) - w)‖ := norm_sum_le _ _
      _ ≤ ∑ w ∈ S, (m w : ℝ) := by
          apply Finset.sum_le_sum
          intro w hw
          have hwR : ‖w‖ ≤ R := hR w (by simpa using hw)
          have h1 : 1 ≤ ‖(s : ℂ) - w‖ := by
            have h := abs_norm_sub_norm_le (s : ℂ) w
            rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hs0] at h
            have h2 : s - ‖w‖ ≤ ‖(s : ℂ) - w‖ := (abs_le.mp h).2
            linarith
          rw [norm_div, Complex.norm_natCast]
          rw [div_le_iff₀ (by positivity)]
          nlinarith
      _ ≤ M := hMsum

/-- The logarithmic derivative of `completedRiemannZeta` in terms of the
finite zero product and the affine exponent. -/
theorem logDeriv_completedRiemannZeta_eq_of_finite_factorization
    (S : Finset ℂ) (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {a b : ℂ}
    (hfac : ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (a + b * z))
    {x : ℂ} (hx0 : x ≠ 0) (hx1 : x ≠ 1)
    (hPx : finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) x ≠ 0)
    (hΛ : completedRiemannZeta x ≠ 0) :
    logDeriv completedRiemannZeta x
      = logDeriv (finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w)) x + b
        - 1 / x - 1 / (x - 1) := by
  set P : ℂ → ℂ := finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) with hPdef
  have hPdiff : Differentiable ℂ P := differentiable_finiteZeroProduct S _
  have hlogcexp : logDeriv (fun z : ℂ => cexp (a + b * z)) x = b := by
    rw [logDeriv_apply, deriv_cexp (by fun_prop)]
    have hd1 : deriv (fun z : ℂ => a + b * z) x = b := by simp
    rw [hd1]
    have hexp : cexp (a + b * x) ≠ 0 := Complex.exp_ne_zero _
    field_simp
  have hlogfac : logDeriv xi₀ x = logDeriv P x + b := by
    have hxi : xi₀ = fun z => P z * cexp (a + b * z) := by
      funext z
      simpa [P] using hfac z
    have hmul : logDeriv (fun z => P z * cexp (a + b * z)) x
        = logDeriv P x + logDeriv (fun z : ℂ => cexp (a + b * z)) x :=
      logDeriv_mul x hPx (Complex.exp_ne_zero _) (hPdiff x) (by fun_prop)
    rw [hxi, hmul, hlogcexp]
  have hev : xi₀ =ᶠ[𝓝 x] (fun z : ℂ => z * (z - 1) * completedRiemannZeta z) := by
    filter_upwards [eventually_ne_nhds hx0, eventually_ne_nhds hx1] with z hz0 hz1
    exact xi₀_eq_weighted z hz0 hz1
  have hxi_eq : logDeriv xi₀ x
      = logDeriv (fun z : ℂ => z * (z - 1) * completedRiemannZeta z) x := by
    rw [logDeriv_apply, logDeriv_apply, hev.deriv_eq, xi₀_eq_weighted x hx0 hx1]
  have hlogmul1 : logDeriv (fun z : ℂ => z * (z - 1) * completedRiemannZeta z) x
      = logDeriv (fun z : ℂ => z * (z - 1)) x + logDeriv completedRiemannZeta x :=
    logDeriv_mul x (mul_ne_zero hx0 (sub_ne_zero.mpr hx1)) hΛ (by fun_prop)
      (differentiableAt_completedZeta hx0 hx1)
  have hlogmul2 : logDeriv (fun z : ℂ => z * (z - 1)) x = 1 / x + 1 / (x - 1) := by
    have h1 : (fun z : ℂ => z * (z - 1)) = id * (fun z : ℂ => z - 1) := rfl
    have hg : (fun z : ℂ => z - 1) x ≠ 0 := by simpa using sub_ne_zero.mpr hx1
    rw [h1, logDeriv_mul (f := id) (g := fun z : ℂ => z - 1) x hx0 hg
      (by fun_prop) (by fun_prop), logDeriv_id]
    congr 1
    rw [logDeriv_apply]
    simp
  have hxilog : logDeriv xi₀ x = 1 / x + 1 / (x - 1) + logDeriv completedRiemannZeta x := by
    rw [hxi_eq, hlogmul1, hlogmul2]
  rw [show logDeriv completedRiemannZeta x = logDeriv xi₀ x - 1 / x - 1 / (x - 1) by
    rw [hxilog]
    ring]
  rw [hlogfac]

/-- On the half-plane `Re s > 1`, the log-derivatives of the two completed
zeta functions agree. -/
theorem logDeriv_completedZeta_eq_completedRiemannZeta {s : ℂ} (hre : 1 < s.re) :
    logDeriv completedZeta s = logDeriv completedRiemannZeta s := by
  have h1 : ∀ᶠ z in 𝓝 s, 1 < z.re :=
    (isOpen_lt continuous_const continuous_re).mem_nhds hre
  have hev : completedZeta =ᶠ[𝓝 s] completedRiemannZeta := by
    filter_upwards [h1] with z hz
    have hz0 : z ≠ 0 := by
      intro h; rw [h] at hz; norm_num at hz
    have hz1 : z ≠ 1 := by
      intro h; rw [h] at hz; norm_num at hz
    have hΓ : Gammaℝ z ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos (by linarith)
    exact completedZeta_eq_completedRiemannZeta hz0 hz1 hΓ
  exact (logDeriv_congr_nhds hev).eq_of_nhds

/-- Real-part bound for the log-derivative under the finite affine
factorization. -/
theorem re_logDeriv_completedRiemannZeta_le
    (S : Finset ℂ) (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {a b : ℂ}
    (hfac : ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (a + b * z))
    {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (hPs : finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) s ≠ 0)
    (hΛ : completedRiemannZeta s ≠ 0) {M : ℝ}
    (hM : ‖logDeriv (finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w)) s‖ ≤ M)
    (h1 : 0 ≤ (1 / s).re) (h2 : 0 ≤ (1 / (s - 1)).re) :
    (logDeriv completedRiemannZeta s).re ≤ M + b.re := by
  have hlog := logDeriv_completedRiemannZeta_eq_of_finite_factorization S hS hfac hs0 hs1 hPs hΛ
  rw [hlog]
  have hPre : (logDeriv (finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w)) s).re ≤ M :=
    le_trans (Complex.re_le_norm _) hM
  rw [Complex.sub_re, Complex.sub_re, Complex.add_re]
  linarith

/-- **Finite zeros contradict the affine factorization.**  If the zero set is
finite and `ξ₀ = P · exp(a + bz)` with `P` the finite zero product, then the
real-axis log-derivative limit is contradicted. -/
theorem false_of_affine_factorization
    (S : Finset ℂ) (hS : ∀ z, xi₀ z = 0 ↔ z ∈ S) {a b : ℂ}
    (hfac : ∀ z, xi₀ z
      = finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) z * cexp (a + b * z)) :
    False := by
  set P : ℂ → ℂ := finiteZeroProduct S (fun w => analyticOrderNatAt xi₀ w) with hPdef
  obtain ⟨M, hM0, hM⟩ := exists_norm_logDeriv_finiteZeroProduct_le S (fun w => analyticOrderNatAt xi₀ w)
  obtain ⟨R, hR⟩ := S.finite_toSet.isBounded.exists_norm_le
  obtain ⟨m, hm⟩ := exists_nat_gt (max M (R + 1))
  have hmM : M < (m : ℝ) := lt_of_le_of_lt (le_max_left M (R+1)) hm
  have hmR : R + 1 < (m : ℝ) := lt_of_le_of_lt (le_max_right M (R+1)) hm
  have hbound : ∀ k : ℕ, m ≤ k →
      (logDeriv completedZeta ((2 * k + 2 : ℕ) : ℂ)).re ≤ M + b.re := by
    intro k hk
    set s : ℂ := ((2 * k + 2 : ℕ) : ℂ) with hs
    have hsre : s.re = ((2 * k + 2 : ℕ) : ℝ) := by
      rw [hs]
      simp
    have hmk : (m : ℝ) ≤ ((2 * k + 2 : ℕ) : ℝ) := by
      exact_mod_cast (by omega : m ≤ 2 * k + 2)
    have hxM : M ≤ ((2 * k + 2 : ℕ) : ℝ) := le_trans (le_of_lt hmM) hmk
    have hxR : R + 1 ≤ ((2 * k + 2 : ℕ) : ℝ) := le_trans (le_of_lt hmR) hmk
    have hx2 : 1 < ((2 * k + 2 : ℕ) : ℝ) := by
      exact_mod_cast (by omega : 1 < 2 * k + 2)
    have hnotS : s ∉ S := by
      intro hmem
      have hle : ‖s‖ ≤ R := hR s (by simpa using hmem)
      have hnorm : ‖s‖ = ((2 * k + 2 : ℕ) : ℝ) := by
        rw [hs]
        exact Complex.norm_natCast (2 * k + 2)
      rw [hnorm] at hle
      linarith
    have hPs : P s ≠ 0 := finiteZeroProduct_ne_zero S _ hnotS
    have hs0 : s ≠ 0 := by
      intro h
      have hre := congrArg Complex.re h
      rw [hsre] at hre
      have : (2 * k + 2 : ℕ) = 0 := by exact_mod_cast hre
      omega
    have hs1' : s ≠ 1 := by
      intro h
      have hre := congrArg Complex.re h
      rw [hsre] at hre
      have : (2 * k + 2 : ℕ) = 1 := by exact_mod_cast hre
      omega
    have hΛ : completedRiemannZeta s ≠ 0 := by
      intro h
      have hζ : riemannZeta s ≠ 0 := by
        apply riemannZeta_ne_zero_of_one_lt_re
        rw [hsre]; exact hx2
      apply hζ
      rw [riemannZeta_def_of_ne_zero hs0]
      rw [h, zero_div]
    have hPbound : ‖logDeriv P s‖ ≤ M := by
      have h := hM ((2 * k + 2 : ℕ) : ℝ) hxM
      simpa [s] using h
    have hxpos : 0 < ((2 * k + 2 : ℕ) : ℝ) := by positivity
    have h1 : 0 ≤ (1 / s).re := by
      rw [hs]
      rw [Complex.div_re]
      simp
      have hsq : 0 < Complex.normSq (2 * (k : ℂ) + 2) := by
        rw [show (2 * (k : ℂ) + 2) = (((2 * k + 2 : ℕ) : ℝ) : ℂ) by push_cast; ring]
        rw [Complex.normSq_ofReal]
        positivity
      exact div_nonneg (by positivity) (le_of_lt hsq)
    have h2 : 0 ≤ (1 / (s - 1)).re := by
      rw [hs]
      rw [Complex.div_re]
      simp
      have hx1 : 0 < ((2 * k + 2 : ℕ) : ℝ) - 1 := by
        have : (1 : ℝ) ≤ ((2 * k + 2 : ℕ) : ℝ) := by exact_mod_cast (by omega : 1 ≤ 2 * k + 2)
        linarith
      have hsq : 0 < Complex.normSq (2 * (k : ℂ) + 2 - 1) := by
        rw [show (2 * (k : ℂ) + 2 - 1) = ((((2 * k + 2 : ℕ) : ℝ) - 1 : ℝ) : ℂ) by push_cast; ring]
        rw [Complex.normSq_ofReal]
        positivity
      have hnum : (0 : ℝ) ≤ 2 * (k : ℝ) + 2 - 1 := by
        have hk : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
        linarith
      exact div_nonneg hnum (le_of_lt hsq)
    have hle := re_logDeriv_completedRiemannZeta_le S hS hfac hs0 hs1' hPs hΛ hPbound h1 h2
    rw [logDeriv_completedZeta_eq_completedRiemannZeta (s := s) (by rw [hsre]; exact hx2)]
    exact hle
  have hbot := tendsto_logDeriv_completedZeta_re_atTop
  have hev : ∀ᶠ k : ℕ in atTop,
      (logDeriv completedZeta ((2 * k + 2 : ℕ) : ℂ)).re ≤ M + b.re := by
    filter_upwards [eventually_ge_atTop m] with k hk
    exact hbound k hk
  have hgt : ∀ᶠ k : ℕ in atTop,
      M + b.re + 1 ≤ (logDeriv completedZeta ((2 * k + 2 : ℕ) : ℂ)).re :=
    hbot.eventually_ge_atTop (M + b.re + 1)
  obtain ⟨k, h1, h2⟩ := (hev.and hgt).exists
  linarith

/-- Every zero of `ξ₀` has positive real part. -/
theorem xi₀_zero_re_pos {s : ℂ} (hz : xi₀ s = 0) : 0 < s.re := by
  by_contra h
  have hle : s.re ≤ 0 := le_of_not_gt h
  have hs0 : s ≠ 0 := by
    intro h0
    rw [h0] at hz
    have : xi₀ 0 = 1 := by simp [xi₀]
    rw [this] at hz
    exact one_ne_zero hz
  have hs1 : s ≠ 1 := by
    intro h1
    rw [h1] at hle
    norm_num at hle
  have hw := xi₀_eq_weighted s hs0 hs1
  rw [hz] at hw
  have hΛ : completedRiemannZeta s = 0 := by
    rcases mul_eq_zero.mp hw.symm with h' | h'
    · exact absurd h' (mul_ne_zero hs0 (sub_ne_zero.mpr hs1))
    · exact h'
  have h1s_re : 1 ≤ (1 - s).re := by
    simp
    linarith
  have h1s0 : (1 - s) ≠ 0 := by
    intro h1
    apply hs1
    linear_combination -h1
  have h1s1 : (1 - s) ≠ 1 := by
    intro h1
    apply hs0
    linear_combination -h1
  have hΓ : Gammaℝ (1 - s) ≠ 0 := by
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    linarith
  have hcz : completedZeta (1 - s) = completedRiemannZeta (1 - s) :=
    completedZeta_eq_completedRiemannZeta h1s0 h1s1 hΓ
  have hne : completedZeta (1 - s) ≠ 0 :=
    completedZeta_ne_zero_of_one_le_re h1s_re h1s1
  have hΛ1 : completedRiemannZeta (1 - s) ≠ 0 := by
    rwa [← hcz]
  rw [completedRiemannZeta_one_sub s] at hΛ1
  exact hΛ1 hΛ




theorem xi₀_zero_re_lt_one {s : ℂ} (hz : xi₀ s = 0) : s.re < 1 := by
  by_contra h
  have hle : 1 ≤ s.re := le_of_not_gt h
  have hs1 : s ≠ 1 := by
    intro h1
    rw [h1] at hz
    have : xi₀ 1 = 1 := by simp [xi₀]
    rw [this] at hz
    exact one_ne_zero hz
  have hs0 : s ≠ 0 := by
    intro h0
    rw [h0] at hle
    norm_num at hle
  have hΓ : Gammaℝ s ≠ 0 := by
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    linarith
  have hcz : completedZeta s = completedRiemannZeta s :=
    completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ
  have hne : completedZeta s ≠ 0 := completedZeta_ne_zero_of_one_le_re hle hs1
  have hΛ : completedRiemannZeta s ≠ 0 := by
    rwa [← hcz]
  have hw := xi₀_eq_weighted s hs0 hs1
  rw [hz] at hw
  have hzero : completedRiemannZeta s = 0 := by
    rcases mul_eq_zero.mp hw.symm with h' | h'
    · exact absurd h' (mul_ne_zero hs0 (sub_ne_zero.mpr hs1))
    · exact h'
  exact hΛ hzero

/-- The finite zero product is at least `1` in modulus outside a large ball. -/
theorem exists_finiteZeroProduct_norm_ge_one (S : Finset ℂ) (m : ℂ → ℕ) :
    ∃ R0 : ℝ, ∀ z : ℂ, R0 ≤ ‖z‖ → 1 ≤ ‖finiteZeroProduct S m z‖ := by
  obtain ⟨R, hR⟩ := S.finite_toSet.isBounded.exists_norm_le
  refine ⟨R + 1, fun z hz => ?_⟩
  unfold finiteZeroProduct
  rw [norm_prod]
  rw [show (1 : ℝ) = ∏ _w ∈ S, (1 : ℝ) by simp]
  apply Finset.prod_le_prod₀
  · intro w hw
    positivity
  · intro w hw
    rw [norm_pow]
    apply one_le_pow₀
    have hwR : ‖w‖ ≤ R := hR w (by simpa using hw)
    have h := abs_norm_sub_norm_le z w
    have h2 : ‖z‖ - ‖w‖ ≤ ‖z - w‖ := (abs_le.mp h).2
    linarith

/-- **The nontrivial zero set is infinite.**  Assuming it finite, the
finite-zero machinery produces an affine factorization, which T38 refutes. -/
theorem infinite_nontrivialZeros :
    ¬ Set.Finite {z : ℂ | xi₀ z = 0 ∧ 0 < z.re} := by
  intro hfin
  set S : Finset ℂ := hfin.toFinset with hSfin
  have hS : ∀ z, xi₀ z = 0 ↔ z ∈ S := by
    intro z
    constructor
    · intro hz
      have hpos := xi₀_zero_re_pos hz
      exact hfin.mem_toFinset.mpr ⟨hz, hpos⟩
    · intro hz
      exact (hfin.mem_toFinset.mp hz).1
  set m : ℂ → ℕ := fun w => analyticOrderNatAt xi₀ w with hm
  obtain ⟨g, hg, hfac⟩ := exists_entire_log_factorization_of_finite_zeros S hS
  obtain ⟨R0, hP0⟩ := exists_finiteZeroProduct_norm_ge_one S m
  have hR0' : 0 ≤ max R0 0 := le_max_right _ _
  have hP : ∀ w : ℂ, max R0 0 ≤ ‖w‖ → 1 ≤ ‖finiteZeroProduct S m w‖ := by
    intro w hw
    exact hP0 w (le_trans (le_max_left _ _) hw)
  obtain ⟨A, B, hA, hξ⟩ := exists_bound_log_norm_xi₀
  have hbound : FiniteZeroSubquadraticBound g :=
    finiteZeroSubquadraticBound_of_quotient (P := finiteZeroProduct S m)
      (Q := fun z => cexp (g z)) (g := g) (A := A) (B := B) (R0 := max R0 0)
      hA (fun z => hfac z) (fun z => Complex.exp_ne_zero _) hg.cexp (fun z => rfl)
      hξ hP hR0'
  obtain ⟨a, b, hab⟩ := exists_affine_factorization_of_finite_zeros_of_bound S hS hg hfac hbound
  exact false_of_affine_factorization S hS hab

/-- **The zero tail is unconditional.**  The nontrivial zeros admit an
injective enumeration with summable inverse-square tail. -/
theorem exists_enumeration_and_zeroTailSummable (σ : ℝ) (hσ : 0 < σ) :
    ∃ a : ℕ → ℂ, Function.Injective a ∧
      Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re} ∧
      ZeroTailSummable (fun n : ℕ => (a n).im) σ :=
  exists_enumeration_and_zeroTailSummable_of_infinite
    (Set.infinite_coe_iff.mpr infinite_nontrivialZeros) σ hσ

/-- **Gaussian summability for the actual zero enumeration.**  The enumeration
of T43 makes the Gaussian weight series summable, which is exactly the input
consumed by the on-line PSD result in zero-density-bound. -/
theorem exists_enumeration_and_gaussian_summable (σ : ℝ) (hσ : 0 < σ) :
    ∃ a : ℕ → ℂ, Function.Injective a ∧
      Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re} ∧
      Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * ((a n).im) ^ 2))) := by
  obtain ⟨a, hinj, hrange, htail⟩ := exists_enumeration_and_zeroTailSummable σ hσ
  exact ⟨a, hinj, hrange, htail⟩

/-- The maximal-distance-zero precondition of the full-block route: some
nontrivial zero has maximal distance from the critical line. -/
def MaximalDistanceZero : Prop :=
  ∃ z : ℂ, xi₀ z = 0 ∧ 0 < z.re ∧
    ∀ w : ℂ, xi₀ w = 0 → 0 < w.re → |w.re - 1 / 2| ≤ |z.re - 1 / 2|

theorem maximalDistanceZero_of_riemannHypothesis
    (h : AbsoluteHodgeSymbol.RiemannHypothesis) : MaximalDistanceZero := by
  obtain ⟨a, -, hrange, -⟩ := exists_enumeration_and_zeroTailSummable 1 (by norm_num)
  have hzmem : a 0 ∈ Set.range a := Set.mem_range_self 0
  rw [hrange] at hzmem
  refine ⟨a 0, hzmem.1, hzmem.2, ?_⟩
  intro w hw hwpos
  have hwlt : w.re < 1 := xi₀_zero_re_lt_one hw
  have h0val : xi₀ 0 = 1 := by simp [xi₀]
  have h1val : xi₀ 1 = 1 := by simp [xi₀]
  have hw0 : w ≠ 0 := by
    intro h0; rw [h0, h0val] at hw; exact one_ne_zero hw
  have hw1 : w ≠ 1 := by
    intro h1; rw [h1, h1val] at hw; exact one_ne_zero hw
  have hΛ : completedRiemannZeta w = 0 := (xi₀_eq_zero_iff w hw0 hw1).mp hw
  have hΓ : Complex.Gammaℝ w ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hwpos
  have hcz : completedZeta w = completedRiemannZeta w :=
    completedZeta_eq_completedRiemannZeta hw0 hw1 hΓ
  have hre : w.re = 1 / 2 := h w (by rw [hcz]; exact hΛ) hwpos hwlt
  have hzlt : (a 0).re < 1 := xi₀_zero_re_lt_one hzmem.1
  have hz0 : a 0 ≠ 0 := by
    intro h0
    have h : xi₀ (a 0) = 0 := hzmem.1
    rw [h0, h0val] at h
    exact one_ne_zero h
  have hz1 : a 0 ≠ 1 := by
    intro h1
    have h : xi₀ (a 0) = 0 := hzmem.1
    rw [h1, h1val] at h
    exact one_ne_zero h
  have hΛz : completedRiemannZeta (a 0) = 0 := (xi₀_eq_zero_iff (a 0) hz0 hz1).mp hzmem.1
  have hΓz : Complex.Gammaℝ (a 0) ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hzmem.2
  have hczz : completedZeta (a 0) = completedRiemannZeta (a 0) :=
    completedZeta_eq_completedRiemannZeta hz0 hz1 hΓz
  have hzre : (a 0).re = 1 / 2 := h (a 0) (by rw [hczz]; exact hΛz) hzmem.2 hzlt
  rw [hre, hzre]

/-- **The maximal-distance precondition, witnessed on the line, gives RH.**  If
the maximal-distance zero has real part `1/2`, every nontrivial zero is on the
critical line. -/
theorem riemannHypothesis_of_maximalDistanceZero_witness_onLine
    (z : ℂ) (hz : xi₀ z = 0) (hzpos : 0 < z.re) (hzline : z.re = 1 / 2)
    (hmax : ∀ w : ℂ, xi₀ w = 0 → 0 < w.re → |w.re - 1 / 2| ≤ |z.re - 1 / 2|) :
    AbsoluteHodgeSymbol.RiemannHypothesis := by
  intro s hΛ hs0 hs1
  have hs0' : s ≠ 0 := by
    intro h; rw [h] at hs0; norm_num at hs0
  have hs1' : s ≠ 1 := by
    intro h; rw [h] at hs1; norm_num at hs1
  have hΓ : Complex.Gammaℝ s ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos (by linarith)
  have hcz : completedZeta s = completedRiemannZeta s :=
    completedZeta_eq_completedRiemannZeta hs0' hs1' hΓ
  have hΛ' : completedRiemannZeta s = 0 := by rw [← hcz]; exact hΛ
  have hs : xi₀ s = 0 := (xi₀_eq_zero_iff s hs0' hs1').mpr hΛ'
  have h := hmax s hs hs0
  rw [hzline] at h
  simp at h
  linarith

/-- **The full-block precondition is exactly RH** once its witness is required
to lie on the critical line. -/
theorem riemannHypothesis_iff_exists_onLine_maximalDistanceZero :
    AbsoluteHodgeSymbol.RiemannHypothesis ↔
      ∃ z : ℂ, xi₀ z = 0 ∧ 0 < z.re ∧ z.re = 1 / 2 ∧
        ∀ w : ℂ, xi₀ w = 0 → 0 < w.re → |w.re - 1 / 2| ≤ |z.re - 1 / 2| := by
  constructor
  · intro h
    obtain ⟨z, hz, hzpos, hmax⟩ := maximalDistanceZero_of_riemannHypothesis h
    refine ⟨z, hz, hzpos, ?_, hmax⟩
    have hzlt : z.re < 1 := xi₀_zero_re_lt_one hz
    have hz0 : z ≠ 0 := by
      intro h0; rw [h0] at hz; simp [xi₀] at hz
    have hz1 : z ≠ 1 := by
      intro h1; rw [h1] at hz; simp [xi₀] at hz
    have hΛ : completedRiemannZeta z = 0 := (xi₀_eq_zero_iff z hz0 hz1).mp hz
    have hΓ : Complex.Gammaℝ z ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hzpos
    have hcz : completedZeta z = completedRiemannZeta z :=
      completedZeta_eq_completedRiemannZeta hz0 hz1 hΓ
    exact h z (by rw [hcz]; exact hΛ) hzpos hzlt
  · rintro ⟨z, hz, hzpos, hzline, hmax⟩
    exact riemannHypothesis_of_maximalDistanceZero_witness_onLine z hz hzpos hzline hmax

end ZeroInfinitude
