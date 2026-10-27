import EMTaylor
import Krawczyk

/-!
# The Taylor induction behind `h2`

`h2` bounds `‖ζ′(z) − ζ′(s14)‖` on the closed `1/5`-ball.  The Taylor model
(design in `research-journal-003.md` §2b) writes

`ζ′(z) − ζ′(s14) = Σ_{k=2..K} k c_k w^{k−1} + remainder`,  `w = z − s14`,

and bounds the remainder by a uniform bound on the `(K+1)`-st derivative.

This file proves the **downward induction** on which the remainder estimate rests,
in the abstract form needed below: if all derivatives of `g` up to order `K`
vanish at `0` and `‖g^{(K+1)}‖ ≤ 2C` on the closed ball of radius `r`, then

`‖g′(w)‖ ≤ 2·C·r^K / K!`  for `‖w‖ ≤ r`.

The `2` is the price of not knowing `g^{(K+1)}(0)` more precisely; it costs
nothing here (journal I.294).

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open Filter Topology

/-- **Taylor remainder by downward induction.**  If `g` and all its derivatives
up to order `K` vanish at `0`, and the `(K+1)`-st derivative is bounded by `2C`
on the closed `r`-ball, then the first derivative is bounded by
`2·C·r^K/K!` there.  Requires differentiability of `iteratedDeriv m g` on a
slightly larger ball (`r + 1`) so that the mean value theorem applies on every
segment. -/
theorem norm_iteratedDeriv_one_le_of_taylor_zero
    {g : ℂ → ℂ} {K : ℕ} {r C : ℝ} {R : ℝ}
    (hr : 0 ≤ r) (hR : r < R) (hC0 : 0 ≤ C)
    (hzero : ∀ m ≤ K, iteratedDeriv m g 0 = 0)
    (hbound : ∀ w, ‖w‖ ≤ r → ‖iteratedDeriv (K + 1) g w‖ ≤ 2 * C)
    (hdiff : ∀ m ≤ K, DifferentiableOn ℂ (iteratedDeriv m g) (Metric.ball (0 : ℂ) R)) :
    ∀ w, ‖w‖ ≤ r → ‖iteratedDeriv 1 g w‖ ≤ 2 * C * r ^ K / (K.factorial : ℝ) := by
  -- Downward induction, indexed by `d = K + 1 - m`.
  have key : ∀ d m : ℕ, K + 1 - m = d → m ≤ K + 1 → ∀ w, ‖w‖ ≤ r →
      ‖iteratedDeriv m g w‖ ≤ 2 * C * r ^ (K + 1 - m) / ((K + 1 - m).factorial : ℝ) := by
    intro d
    induction d with
    | zero =>
        intro m hm _ w hw
        have hm' : m = K + 1 := by omega
        subst hm'
        have hfac : ((K + 1 - (K + 1)).factorial : ℝ) = 1 := by norm_num
        rw [hfac, show K + 1 - (K + 1) = 0 from rfl, pow_zero]
        simpa using hbound w hw
    | succ d ih =>
        intro m hm hmle w hw
        have hmK : m ≤ K := by omega
        -- the induction hypothesis at `m + 1`
        have hIH : ∀ z, ‖z‖ ≤ r →
            ‖iteratedDeriv (m + 1) g z‖ ≤ 2 * C * r ^ d / (d.factorial : ℝ) := by
          intro z hz
          have h := ih (m + 1) (by omega) (by omega) z hz
          simpa using h
        -- the segment from `0` to `w` stays in the closed `r`-ball
        have hseg : segment ℝ (0 : ℂ) w ⊆ Metric.closedBall (0 : ℂ) r :=
          (convex_closedBall (0 : ℂ) r).segment_subset (by simpa using hr) (by simpa using hw)
        have hseg' : ∀ z ∈ segment ℝ (0 : ℂ) w, ‖z‖ ≤ r := by
          intro z hz
          have := hseg hz
          simpa [Metric.mem_closedBall, dist_eq_norm] using this
        have hderiv : ∀ z ∈ segment ℝ (0 : ℂ) w,
            HasDerivAt (iteratedDeriv m g) (iteratedDeriv (m + 1) g z) z := by
          intro z hz
          have hzr : ‖z‖ ≤ r := hseg' z hz
          have hmem : z ∈ Metric.ball (0 : ℂ) R := by
            simp only [Metric.mem_ball, dist_eq_norm, sub_zero]
            linarith
          have hd := (hdiff m hmK).differentiableAt (Metric.isOpen_ball.mem_nhds hmem)
          have h := hd.hasDerivAt
          rwa [show deriv (iteratedDeriv m g) z = iteratedDeriv (m + 1) g z by
            rw [iteratedDeriv_succ]] at h
        have hb : ∀ z ∈ segment ℝ (0 : ℂ) w,
            ‖iteratedDeriv (m + 1) g z‖ ≤ 2 * C * r ^ d / (d.factorial : ℝ) :=
          fun z hz => hIH z (hseg' z hz)
        have hmvt := norm_sub_le_of_deriv_bound (f := iteratedDeriv m g)
          (f' := fun z => iteratedDeriv (m + 1) g z) (x := 0) (y := w) hderiv hb
        have h0 : iteratedDeriv m g 0 = 0 := hzero m hmK
        have hval : ‖iteratedDeriv m g w‖ ≤ (2 * C * r ^ d / (d.factorial : ℝ)) * ‖w‖ := by
          have := hmvt
          rw [h0, sub_zero] at this
          calc ‖iteratedDeriv m g w‖ ≤ (2 * C * r ^ d / (d.factorial : ℝ)) * ‖w‖ := this
        have hfacpos : (0 : ℝ) < (d.factorial : ℝ) := by positivity
        have hfacpos' : (0 : ℝ) < ((d + 1).factorial : ℝ) := by positivity
        have hle : (d.factorial : ℝ) ≤ ((d + 1).factorial : ℝ) := by
          rw [Nat.factorial_succ]
          have : (0 : ℝ) ≤ (d.factorial : ℝ) := le_of_lt hfacpos
          push_cast
          nlinarith
        have hstep : (2 * C * r ^ d / (d.factorial : ℝ)) * ‖w‖
            ≤ 2 * C * r ^ (d + 1) / (((d + 1).factorial : ℝ)) := by
          rw [div_mul_eq_mul_div, div_le_div_iff_of_pos_right hfacpos',
            show (d + 1) = d + 1 from rfl, pow_succ]
          have hpow : (0 : ℝ) ≤ r ^ d := pow_nonneg hr d
          have hcw : (0 : ℝ) ≤ 2 * C * r ^ d := by positivity
          calc 2 * C * r ^ d * ‖w‖ * (d.factorial : ℝ)
              ≤ 2 * C * r ^ d * r * (d.factorial : ℝ) := by gcongr
            _ ≤ 2 * C * r ^ d * r * ((d + 1).factorial : ℝ) := by gcongr
        have hK : K + 1 - m = d + 1 := hm
        rw [hK]
        exact hval.trans hstep
  intro w hw
  have h := key K 1 (by omega) (by omega) w hw
  rw [show K + 1 - 1 = K from by omega] at h
  exact h

end FiniteWindowZeros
