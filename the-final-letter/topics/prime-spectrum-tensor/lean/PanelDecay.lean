import Mathlib
import WeightDecay
import PanelCertificate
import OmegaPanel
import DensityDemo
import DensityTail

/-!
# R2 — decaying panel certificate and the chain assembly

Two additions to the R2 machinery:

* `panel_certificate_decay` replaces the global `|w| ≤ 1/400` by the rational
  panel-local bound `(1/400)/(1+a²/400)` of `WeightDecay.abs_weight_le_div`.
  This shrinks the `Ω`-variation term by a factor `1+a²/400`, which is what
  makes a coarse partition usable at large `t`.

* `PanelChain` glues the per-panel certificates together *without ever
  enumerating the panels*: the chain is a literal term of an inductive type
  whose type indices force consecutive endpoints to agree, and
  `PanelChain.bound` accumulates the panel errors by structural recursion.
  This replaces the `∀ p < P` hypothesis of `density_approx_error`, which would
  need a `P`-way `interval_cases`.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- **The decaying panel certificate.** -/
theorem panel_certificate_decay {c : ℝ} (hc : |c| ≤ 3 / 5) {a b qmlo qmhi lipx : ℝ}
    (hab : a ≤ b) (ha0 : 0 ≤ a) (hb60 : b ≤ 60)
    (hlip : ∀ t ∈ Set.Icc a b, |deriv IntersectionForm.Omega t| ≤ lipx)
    (hm1 : qmlo ≤ IntersectionForm.Omega ((a + b) / 2))
    (hm2 : IntersectionForm.Omega ((a + b) / 2) ≤ qmhi) :
    |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      ((qmlo + qmhi) / 2) * ((b - a) * weight c ((a + b) / 2))| ≤
      |(qmlo + qmhi) / 2| * ((1 / 400) * (b - a) ^ 3 / 4) +
        max ((qmlo + qmhi) / 2 - (qmlo - lipx * (b - a) / 2))
            ((qmhi + lipx * (b - a) / 2) - (qmlo + qmhi) / 2) *
          ((b - a) * ((1 / 400) / (1 + a ^ 2 / 400))) := by
  have hpanel := omega_panel_enclosure hab hlip
    (fun t _ => differentiable_Omega.differentiableAt) hm1 hm2
  refine panel_mem hab (by unfold weight; fun_prop) continuous_Omega ?_ ?_ ?_ ?_
    (weight_midpoint_rule hc hab ha0 hb60)
  · intro t ht
    exact (hpanel t ht).1
  · intro t ht
    exact (hpanel t ht).2
  · intro t ht
    exact abs_weight_le_div ha0 ht.1
  · positivity

/-- A chain of panel certificates with matching endpoints. -/
inductive PanelChain (w Ω : ℝ → ℝ) : ℝ → ℝ → Type
  /-- The empty chain at `a`. -/
  | nil (a : ℝ) : PanelChain w Ω a a
  /-- A panel `[a,b]` with rational centre `R` and error `E`, then the rest. -/
  | cons {a b c : ℝ} (R E : ℝ)
      (h : |(∫ x in a..b, w x * Ω x) - R| ≤ E)
      (rest : PanelChain w Ω b c) : PanelChain w Ω a c

namespace PanelChain

/-- The accumulated rational centre and error of a chain. -/
def total {w Ω : ℝ → ℝ} {a c : ℝ} : PanelChain w Ω a c → ℝ × ℝ
  | .nil _ => (0, 0)
  | .cons R E _ rest =>
      let t := total rest
      (R + t.1, E + t.2)

/-- **The chain bound.** -/
theorem bound {w Ω : ℝ → ℝ} (hcont : Continuous (fun x => w x * Ω x))
    {a c : ℝ} (ch : PanelChain w Ω a c) :
    |(∫ x in a..c, w x * Ω x) - (total ch).1| ≤ (total ch).2 := by
  induction ch with
  | nil a =>
      simp [total]
  | @cons a b c R E h rest ih =>
      have hsplit : (∫ x in a..c, w x * Ω x) =
          (∫ x in a..b, w x * Ω x) + ∫ x in b..c, w x * Ω x := by
        rw [intervalIntegral.integral_add_adjacent_intervals
          (hcont.intervalIntegrable a b) (hcont.intervalIntegrable b c)]
      have h1 : |((∫ x in a..b, w x * Ω x) - R) +
          ((∫ x in b..c, w x * Ω x) - (total rest).1)| ≤ E + (total rest).2 := by
        calc |((∫ x in a..b, w x * Ω x) - R) +
              ((∫ x in b..c, w x * Ω x) - (total rest).1)|
            ≤ |(∫ x in a..b, w x * Ω x) - R| +
              |(∫ x in b..c, w x * Ω x) - (total rest).1| := abs_add_le _ _
          _ ≤ E + (total rest).2 := add_le_add h ih
      simp only [total]
      rw [hsplit]
      convert h1 using 2
      ring

end PanelChain

/-- **Gluing a node bracket into the panel certificate.** -/
theorem panel_glue {c : ℝ} {a b qmlo qmhi E1 w0 eps : ℝ} (hab : a ≤ b)
    (hpc : |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      ((qmlo + qmhi) / 2) * ((b - a) * weight c ((a + b) / 2))| ≤ E1)
    (hw : |weight c ((a + b) / 2) - w0| ≤ eps) :
    |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      ((qmlo + qmhi) / 2) * ((b - a) * w0)| ≤
      E1 + |(qmlo + qmhi) / 2| * (b - a) * eps := by
  set qmid : ℝ := (qmlo + qmhi) / 2 with hqmid
  have hdecomp : (∫ x in a..b, weight c x * IntersectionForm.Omega x) - qmid * ((b - a) * w0) =
      ((∫ x in a..b, weight c x * IntersectionForm.Omega x) - qmid * ((b - a) * weight c ((a + b) / 2))) +
        qmid * ((b - a) * (weight c ((a + b) / 2) - w0)) := by ring
  rw [hdecomp]
  have h2 : |qmid * ((b - a) * (weight c ((a + b) / 2) - w0))| ≤ |qmid| * (b - a) * eps := by
    rw [abs_mul, abs_mul, abs_of_nonneg (by linarith : (0 : ℝ) ≤ b - a)]
    have h1 : (0 : ℝ) ≤ b - a := by linarith
    have h3 : (b - a) * |weight c ((a + b) / 2) - w0| ≤ (b - a) * eps :=
      mul_le_mul_of_nonneg_left hw h1
    calc |qmid| * ((b - a) * |weight c ((a + b) / 2) - w0|)
        = |qmid| * ((b - a) * |weight c ((a + b) / 2) - w0|) := rfl
      _ ≤ |qmid| * ((b - a) * eps) := by
          exact mul_le_mul_of_nonneg_left h3 (abs_nonneg _)
      _ = |qmid| * (b - a) * eps := by ring
  calc |((∫ x in a..b, weight c x * IntersectionForm.Omega x) - qmid * ((b - a) * weight c ((a + b) / 2))) +
        qmid * ((b - a) * (weight c ((a + b) / 2) - w0))|
      ≤ |(∫ x in a..b, weight c x * IntersectionForm.Omega x) - qmid * ((b - a) * weight c ((a + b) / 2))| +
        |qmid * ((b - a) * (weight c ((a + b) / 2) - w0))| := abs_add_le _ _
    _ ≤ E1 + |qmid| * (b - a) * eps := by linarith

/-- **One cumulative step.**  Extends an enclosure of `∫_a^b` by a panel `[b,c]`. -/
theorem panel_step {w Ω : ℝ → ℝ} {a b c T S R E : ℝ}
    (hcont : Continuous (fun x => w x * Ω x))
    (hprev : |(∫ x in a..b, w x * Ω x) - T| ≤ S)
    (hstep : |(∫ x in b..c, w x * Ω x) - R| ≤ E) :
    |(∫ x in a..c, w x * Ω x) - (T + R)| ≤ S + E := by
  have hsplit : (∫ x in a..c, w x * Ω x) =
      (∫ x in a..b, w x * Ω x) + ∫ x in b..c, w x * Ω x := by
    rw [intervalIntegral.integral_add_adjacent_intervals
      (hcont.intervalIntegrable a b) (hcont.intervalIntegrable b c)]
  rw [hsplit]
  calc |((∫ x in a..b, w x * Ω x) + ∫ x in b..c, w x * Ω x) - (T + R)|
      = |((∫ x in a..b, w x * Ω x) - T) + ((∫ x in b..c, w x * Ω x) - R)| := by ring_nf
    _ ≤ |(∫ x in a..b, w x * Ω x) - T| + |(∫ x in b..c, w x * Ω x) - R| := abs_add_le _ _
    _ ≤ S + E := add_le_add hprev hstep

end PrimeSpectrumTensor
