import Mathlib

/-! A mean value inequality for complex derivatives, via the convex mean
value theorem for Fréchet derivatives. -/

noncomputable section

namespace FiniteWindowZeros

/-- Mean value inequality on a real segment for a complex function. -/
theorem norm_sub_le_of_deriv_bound {f f' : ℂ → ℂ} {x y : ℂ} {C : ℝ}
    (h : ∀ z ∈ segment ℝ x y, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ segment ℝ x y, ‖f' z‖ ≤ C) :
    ‖f y - f x‖ ≤ C * ‖y - x‖ := by
  have hdiff : ∀ z ∈ segment ℝ x y, DifferentiableAt ℂ f z :=
    fun z hz => (h z hz).differentiableAt
  have hbound : ∀ z ∈ segment ℝ x y, ‖fderiv ℂ f z‖ ≤ C := by
    intro z hz
    rw [(h z hz).hasFDerivAt.fderiv]
    simpa using hC z hz
  exact Convex.norm_image_sub_le_of_norm_fderiv_le hdiff hbound
    (convex_segment x y) (left_mem_segment ℝ x y) (right_mem_segment ℝ x y)

/-- The Newton map `z ↦ z - Y f z` is Lipschitz with constant `q` when
`‖1 - Y f′‖ ≤ q` on the segment. -/
theorem norm_newton_sub_le {f f' : ℂ → ℂ} {Y : ℂ} {x y : ℂ} {q : ℝ}
    (h : ∀ z ∈ segment ℝ x y, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ segment ℝ x y, ‖1 - Y * f' z‖ ≤ q) :
    ‖(x - Y * f x) - (y - Y * f y)‖ ≤ q * ‖x - y‖ := by
  have hg : ∀ z ∈ segment ℝ x y,
      HasDerivAt (fun w : ℂ => w - Y * f w) (1 - Y * f' z) z := by
    intro z hz
    have h1 : HasDerivAt (fun w : ℂ => w) 1 z := hasDerivAt_id z
    have h2 : HasDerivAt (fun w : ℂ => Y * f w) (Y * f' z) z := by
      simpa [mul_comm] using (h z hz).const_mul Y
    convert h1.sub h2 using 1
  have hmain := norm_sub_le_of_deriv_bound
    (f := fun w : ℂ => w - Y * f w) (f' := fun z => 1 - Y * f' z) hg hC
  simpa only [norm_sub_rev] using hmain

/-- The Newton map sends the closed ball into itself under the Krawczyk
mapping condition. -/
theorem newton_mapsTo_closedBall {f f' : ℂ → ℂ} {x0 : ℂ} {r q : ℝ} {Y : ℂ}
    (hr : 0 ≤ r) (hq0 : 0 ≤ q)
    (h : ∀ z ∈ Metric.closedBall x0 r, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ Metric.closedBall x0 r, ‖1 - Y * f' z‖ ≤ q)
    (hmap : ‖Y * f x0‖ + q * r ≤ r) :
    Set.MapsTo (fun z : ℂ => z - Y * f z) (Metric.closedBall x0 r) (Metric.closedBall x0 r) := by
  intro z hz
  have hx0 : x0 ∈ Metric.closedBall x0 r := Metric.mem_closedBall_self hr
  have hseg : segment ℝ x0 z ⊆ Metric.closedBall x0 r :=
    (convex_closedBall x0 r).segment_subset hx0 hz
  have hzseg : z ∈ segment ℝ x0 z := right_mem_segment ℝ x0 z
  have hx0seg : x0 ∈ segment ℝ x0 z := left_mem_segment ℝ x0 z
  have hderiv : ∀ w ∈ segment ℝ x0 z, HasDerivAt f (f' w) w :=
    fun w hw => h w (hseg hw)
  have hbound : ∀ w ∈ segment ℝ x0 z, ‖1 - Y * f' w‖ ≤ q :=
    fun w hw => hC w (hseg hw)
  have hlip := norm_newton_sub_le (x := x0) (y := z) (Y := Y) (q := q) hderiv hbound
  have hdist : ‖z - x0‖ ≤ r := by
    simpa [dist_eq_norm] using hz
  have h1 : ‖(z - Y * f z) - (x0 - Y * f x0)‖ ≤ q * r := by
    have h := hlip
    rw [norm_sub_rev (x0 - Y * f x0) (z - Y * f z),
      norm_sub_rev x0 z] at h
    exact le_trans h (mul_le_mul_of_nonneg_left hdist hq0)
  have h2 : ‖(x0 - Y * f x0) - x0‖ ≤ ‖Y * f x0‖ := by
    simpa [sub_eq_add_neg, norm_neg, mul_comm] using le_rfl (a := ‖Y * f x0‖)
  have h3 : ‖(z - Y * f z) - x0‖ ≤ ‖Y * f x0‖ + q * r := by
    calc
      ‖(z - Y * f z) - x0‖
          = ‖((z - Y * f z) - (x0 - Y * f x0)) + ((x0 - Y * f x0) - x0)‖ := by ring_nf
      _ ≤ ‖(z - Y * f z) - (x0 - Y * f x0)‖ + ‖(x0 - Y * f x0) - x0‖ := norm_add_le _ _
      _ ≤ q * r + ‖Y * f x0‖ := add_le_add h1 h2
      _ = ‖Y * f x0‖ + q * r := by ring
  exact Metric.mem_closedBall.mpr (by simpa [dist_eq_norm] using le_trans h3 hmap)

/-- **Krawczyk/Newton zero existence.**  If the Newton map maps the closed
ball into itself and is a `q`-contraction there, then `f` has a zero in the
ball. -/
theorem exists_zero_of_krawczyk {f f' : ℂ → ℂ} {x0 : ℂ} {r q : ℝ} {Y : ℂ}
    (hr : 0 ≤ r) (hq0 : 0 ≤ q) (hq1 : q < 1) (hY : Y ≠ 0)
    (h : ∀ z ∈ Metric.closedBall x0 r, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ Metric.closedBall x0 r, ‖1 - Y * f' z‖ ≤ q)
    (hmap : ‖Y * f x0‖ + q * r ≤ r) :
    ∃ z ∈ Metric.closedBall x0 r, f z = 0 := by
  let g : ℂ → ℂ := fun z => z - Y * f z
  let s : Set ℂ := Metric.closedBall x0 r
  have hsc : IsComplete s := Metric.isClosed_closedBall.isComplete
  have hsf : Set.MapsTo g s s := newton_mapsTo_closedBall hr hq0 h hC hmap
  have hcontr : ContractingWith ⟨q, hq0⟩ (hsf.restrict g s s) := by
    constructor
    · exact_mod_cast hq1
    · apply LipschitzWith.of_dist_le_mul
      intro x y
      have hx : (x : ℂ) ∈ s := x.2
      have hy : (y : ℂ) ∈ s := y.2
      have hseg : segment ℝ (x : ℂ) (y : ℂ) ⊆ s :=
        (convex_closedBall x0 r).segment_subset hx hy
      have hderiv : ∀ w ∈ segment ℝ (x : ℂ) (y : ℂ), HasDerivAt f (f' w) w :=
        fun w hw => h w (hseg hw)
      have hbound : ∀ w ∈ segment ℝ (x : ℂ) (y : ℂ), ‖1 - Y * f' w‖ ≤ q :=
        fun w hw => hC w (hseg hw)
      have hlip := norm_newton_sub_le (x := (x : ℂ)) (y := (y : ℂ)) (Y := Y) (q := q)
        hderiv hbound
      simp only [g, Subtype.dist_eq, dist_eq_norm, NNReal.coe_mk]
      exact hlip
  obtain ⟨z, hz, hfix, _⟩ :=
    ContractingWith.exists_fixedPoint' (s := s) (f := g) hsc hsf hcontr
      (x := x0) (Metric.mem_closedBall_self hr) (by simp)
  refine ⟨z, hz, ?_⟩
  have hzero : Y * f z = 0 := by
    have := congrArg (fun w : ℂ => w - z) hfix
    simpa [g] using this
  exact (mul_eq_zero.mp hzero).resolve_left hY

/-- The quarter-ball around `1/2 + 14i` avoids `1`. -/
theorem quarter_ball_ne_one :
    ∀ z ∈ Metric.closedBall ((1/2 : ℂ) + 14 * Complex.I) (1/4), z ≠ 1 := by
  intro z hz hz1
  subst hz1
  rw [Metric.mem_closedBall, dist_eq_norm] at hz
  have him := Complex.abs_im_le_norm ((1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I))
  have hval : ((1 : ℂ) - ((1/2 : ℂ) + 14 * Complex.I)).im = -14 := by norm_num
  rw [hval] at him
  norm_num at him
  linarith

/-- Rational approximation of `1/ζ′(1/2+14i)`. -/
def Yk : ℂ :=
  (12436403768 / 10000000000 : ℝ) + (-3397942771 / 10000000000 : ℝ) * Complex.I

theorem norm_Yk_le_three_halves : ‖Yk‖ ≤ (3 / 2 : ℝ) := by
  have hsq : Complex.normSq Yk ≤ ((3 / 2 : ℝ) ^ 2) := by
    rw [Yk]
    norm_num [Complex.normSq_apply, Complex.add_re, Complex.add_im,
      Complex.mul_re, Complex.mul_im]
  calc ‖Yk‖ = Real.sqrt (Complex.normSq Yk) := by
        rw [← Real.sqrt_sq (norm_nonneg _), Complex.normSq_eq_norm_sq]
    _ ≤ Real.sqrt ((3 / 2 : ℝ) ^ 2) := Real.sqrt_le_sqrt hsq
    _ = (3 / 2 : ℝ) := by rw [Real.sqrt_sq (by norm_num)]

theorem hmap_of_zeta_bound
    (h : ‖riemannZeta ((1/2 : ℂ) + 14 * Complex.I)‖ ≤ (1/8 : ℝ)) :
    ‖Yk * riemannZeta ((1/2 : ℂ) + 14 * Complex.I)‖ +
      (1/4 : ℝ) * (1/4 : ℝ) ≤ (1/4 : ℝ) := by
  have hmul : ‖Yk * riemannZeta ((1/2 : ℂ) + 14 * Complex.I)‖ ≤
      (3 / 2 : ℝ) * (1 / 8 : ℝ) := by
    rw [norm_mul]
    exact mul_le_mul norm_Yk_le_three_halves h (norm_nonneg _) (by norm_num)
  norm_num at hmul ⊢
  linarith



namespace FiniteWindowZeros

/-- Krawczyk instantiated for the Riemann zeta function. -/
theorem zeta_zero_of_krawczyk {x0 : ℂ} {r q : ℝ} {Y : ℂ}
    (hr : 0 ≤ r) (hq0 : 0 ≤ q) (hq1 : q < 1) (hY : Y ≠ 0)
    (h1 : ∀ z ∈ Metric.closedBall x0 r, z ≠ 1)
    (hC : ∀ z ∈ Metric.closedBall x0 r, ‖1 - Y * deriv riemannZeta z‖ ≤ q)
    (hmap : ‖Y * riemannZeta x0‖ + q * r ≤ r) :
    ∃ z ∈ Metric.closedBall x0 r, riemannZeta z = 0 := by
  apply exists_zero_of_krawczyk (f := riemannZeta) (f' := deriv riemannZeta)
    hr hq0 hq1 hY
  · intro z hz
    exact (differentiableAt_riemannZeta (h1 z hz)).hasDerivAt
  · exact hC
  · exact hmap

/-- Concrete Krawczyk target at `1/2 + 14i`, radius `1/4`, contraction `1/4`. -/
theorem zeta_zero_quarter_ball {Y : ℂ} (hY : Y ≠ 0)
    (h1 : ∀ z ∈ Metric.closedBall ((1/2 : ℂ) + 14 * Complex.I) (1/4), z ≠ 1)
    (hC : ∀ z ∈ Metric.closedBall ((1/2 : ℂ) + 14 * Complex.I) (1/4),
      ‖1 - Y * deriv riemannZeta z‖ ≤ (1/4 : ℝ))
    (hmap : ‖Y * riemannZeta ((1/2 : ℂ) + 14 * Complex.I)‖ +
      (1/4 : ℝ) * (1/4 : ℝ) ≤ (1/4 : ℝ)) :
    ∃ z ∈ Metric.closedBall ((1/2 : ℂ) + 14 * Complex.I) (1/4),
      riemannZeta z = 0 :=
  FiniteWindowZeros.zeta_zero_of_krawczyk (x0 := (1/2 : ℂ) + 14 * Complex.I) (r := 1/4) (q := 1/4)
    (by norm_num) (by norm_num) (by norm_num) hY h1 hC hmap

end FiniteWindowZeros
