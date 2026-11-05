import Mathlib
import MidpointRule
import DensityWeight

/-!
# R2 — the per-panel signed bound

On a panel `[a,b]` the archimedean density satisfies `qlo ≤ Ω ≤ qhi`, so with
`qmid` a centre and `δ = max (qmid − qlo) (qhi − qmid)`,

```
∫_p w·Ω = qmid·∫_p w + ∫_p w·(Ω − qmid),
```

hence

```
|∫_p w·Ω − qmid·(b−a)·w(m)| ≤ |qmid|·Bw·(b−a)³/4 + δ·(b−a)·Sw.
```

The bound is *signed* in the leading term `qmid·(b−a)·w(m)`, which is what makes
the panel sum usable: an absolute-value estimate would be `≈ 0.8` where the
signed density is `≈ 0.01`.
-/

noncomputable section

namespace PrimeSpectrumTensor

theorem panel_mem {w Ω : ℝ → ℝ} {a b Bw Sw qlo qhi qmid : ℝ} (hab : a ≤ b)
    (hwcont : Continuous w) (hΩcont : Continuous Ω)
    (hqlo : ∀ t ∈ Set.Icc a b, qlo ≤ Ω t)
    (hqhi : ∀ t ∈ Set.Icc a b, Ω t ≤ qhi)
    (hsw : ∀ t ∈ Set.Icc a b, |w t| ≤ Sw)
    (hsw0 : 0 ≤ Sw)
    (hmid : |(∫ x in a..b, w x) - (b - a) * w ((a + b) / 2)| ≤ Bw * (b - a) ^ 3 / 4) :
    |(∫ x in a..b, w x * Ω x) - qmid * ((b - a) * w ((a + b) / 2))| ≤
      |qmid| * (Bw * (b - a) ^ 3 / 4) +
        max (qmid - qlo) (qhi - qmid) * ((b - a) * Sw) := by
  have hwint : IntervalIntegrable w MeasureTheory.volume a b := hwcont.intervalIntegrable a b
  have hwΩ : IntervalIntegrable (fun x => w x * Ω x) MeasureTheory.volume a b :=
    (hwcont.mul hΩcont).intervalIntegrable a b
  have hwq : IntervalIntegrable (fun x => qmid * w x) MeasureTheory.volume a b :=
    (continuous_const.mul hwcont).intervalIntegrable a b
  have hdiff : IntervalIntegrable (fun x => w x * (Ω x - qmid)) MeasureTheory.volume a b :=
    (hwcont.mul (hΩcont.sub continuous_const)).intervalIntegrable a b
  -- the key linearity
  have hkey : (∫ x in a..b, w x * Ω x) - qmid * (∫ x in a..b, w x) =
      ∫ x in a..b, w x * (Ω x - qmid) := by
    have e1 : (∫ x in a..b, (fun x => w x * Ω x) x - (fun x => qmid * w x) x) =
        (∫ x in a..b, w x * Ω x) - ∫ x in a..b, qmid * w x :=
      intervalIntegral.integral_sub hwΩ hwq
    have e2 : (∫ x in a..b, qmid * w x) = qmid * (∫ x in a..b, w x) :=
      intervalIntegral.integral_const_mul qmid w
    have e3 : (∫ x in a..b, (fun x => w x * Ω x) x - (fun x => qmid * w x) x) =
        ∫ x in a..b, w x * (Ω x - qmid) := by
      apply intervalIntegral.integral_congr
      intro x _
      ring
    rw [← e3, e1, e2]
  -- the omega variation
  have hdelta : ∀ t ∈ Set.Icc a b, |Ω t - qmid| ≤ max (qmid - qlo) (qhi - qmid) := by
    intro t ht
    rw [abs_le]
    constructor
    · have := hqlo t ht
      linarith [le_max_left (qmid - qlo) (qhi - qmid)]
    · have := hqhi t ht
      linarith [le_max_right (qmid - qlo) (qhi - qmid)]
  have hpert : |∫ x in a..b, w x * (Ω x - qmid)| ≤
      max (qmid - qlo) (qhi - qmid) * ((b - a) * Sw) := by
    refine le_trans (intervalIntegral.abs_integral_le_integral_abs hab) ?_
    have hcont : Continuous (fun x => |w x * (Ω x - qmid)|) :=
      (hwcont.mul (hΩcont.sub continuous_const)).abs
    have hstep : ∀ x ∈ Set.Icc a b, |w x * (Ω x - qmid)| ≤
        Sw * max (qmid - qlo) (qhi - qmid) := by
      intro x hx
      rw [abs_mul]
      exact mul_le_mul (hsw x hx) (hdelta x hx) (abs_nonneg _) hsw0
    calc ∫ x in a..b, |w x * (Ω x - qmid)|
        ≤ ∫ x in a..b, Sw * max (qmid - qlo) (qhi - qmid) :=
          intervalIntegral.integral_mono_on hab (hcont.intervalIntegrable a b)
            (continuous_const.intervalIntegrable a b) hstep
      _ = Sw * max (qmid - qlo) (qhi - qmid) * (b - a) := by
          rw [intervalIntegral.integral_const, smul_eq_mul]
          ring
      _ = max (qmid - qlo) (qhi - qmid) * ((b - a) * Sw) := by ring
  -- assemble
  have hdecomp : (∫ x in a..b, w x * Ω x) - qmid * ((b - a) * w ((a + b) / 2)) =
      ((∫ x in a..b, w x * Ω x) - qmid * (∫ x in a..b, w x)) +
        qmid * ((∫ x in a..b, w x) - (b - a) * w ((a + b) / 2)) := by ring
  rw [hdecomp, hkey]
  calc |(∫ x in a..b, w x * (Ω x - qmid)) +
        qmid * ((∫ x in a..b, w x) - (b - a) * w ((a + b) / 2))|
      ≤ |∫ x in a..b, w x * (Ω x - qmid)| +
        |qmid * ((∫ x in a..b, w x) - (b - a) * w ((a + b) / 2))| := abs_add_le _ _
    _ ≤ max (qmid - qlo) (qhi - qmid) * ((b - a) * Sw) +
        |qmid| * (Bw * (b - a) ^ 3 / 4) := by
        have hq : |qmid * ((∫ x in a..b, w x) - (b - a) * w ((a + b) / 2))| ≤
            |qmid| * (Bw * (b - a) ^ 3 / 4) := by
          rw [abs_mul]
          exact mul_le_mul_of_nonneg_left hmid (abs_nonneg qmid)
        linarith
    _ = |qmid| * (Bw * (b - a) ^ 3 / 4) +
        max (qmid - qlo) (qhi - qmid) * ((b - a) * Sw) := by ring

end PrimeSpectrumTensor
