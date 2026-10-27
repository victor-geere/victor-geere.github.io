/-
  DirichletRightPathLinear.lean — linearity of the three-segment `rightPath`.

  `rightPath g t₀ t₁ = ∫_{1/2}^1 g(x+t₀i) + i∫_{t₀}^{t₁} g(1+yi) − ∫_{1/2}^1 g(x+t₁i)`
  (`Rh45RouteBAnalytic.rightPath`), so it is additive in `g`.  This is the step that splits the
  weighted contour integral of `logDeriv (dirichletCompleted χ)` into its archimedean and prime
  parts.

  **Scope note.**  The integrand identity `logDeriv (dirichletCompleted χ) = arch − LSeries(Λ·χ)`
  (`DirichletCompletedLogDeriv.lean`) holds for `Re s > 1`, whereas `rightPath` integrates over
  `Re s ∈ [1/2, 1]`.  Reading the prime side off `rightPath` therefore needs the Dirichlet series
  continued (or the contour shifted to `Re s = c > 1`, the standard Mellin-transform step), which
  is the remaining piece; the linearity below is unconditional and holds either way.
-/
import Rh45.RouteBAnalytic

open MeasureTheory intervalIntegral
open scoped Interval

namespace RouteABC

noncomputable section

/-- `rightPath` is additive in the integrand. -/
theorem rightPath_add (f g : ℂ → ℂ) (t0 t1 : ℝ)
    (h0f : IntervalIntegrable (fun x : ℝ => f (x + t0 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (h0g : IntervalIntegrable (fun x : ℝ => g (x + t0 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (h1f : IntervalIntegrable (fun x : ℝ => f (x + t1 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (h1g : IntervalIntegrable (fun x : ℝ => g (x + t1 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (hvf : IntervalIntegrable (fun y : ℝ => f (1 + y * Complex.I)) volume t0 t1)
    (hvg : IntervalIntegrable (fun y : ℝ => g (1 + y * Complex.I)) volume t0 t1) :
    Rh45RouteBAnalytic.rightPath (fun s => f s + g s) t0 t1
      = Rh45RouteBAnalytic.rightPath f t0 t1 + Rh45RouteBAnalytic.rightPath g t0 t1 := by
  simp only [Rh45RouteBAnalytic.rightPath]
  rw [intervalIntegral.integral_add h0f h0g, intervalIntegral.integral_add hvf hvg,
    intervalIntegral.integral_add h1f h1g]
  ring

/-- `rightPath` is additive over a subtraction. -/
theorem rightPath_sub (f g : ℂ → ℂ) (t0 t1 : ℝ)
    (h0f : IntervalIntegrable (fun x : ℝ => f (x + t0 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (h0g : IntervalIntegrable (fun x : ℝ => g (x + t0 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (h1f : IntervalIntegrable (fun x : ℝ => f (x + t1 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (h1g : IntervalIntegrable (fun x : ℝ => g (x + t1 * Complex.I)) volume (1 / 2 : ℝ) 1)
    (hvf : IntervalIntegrable (fun y : ℝ => f (1 + y * Complex.I)) volume t0 t1)
    (hvg : IntervalIntegrable (fun y : ℝ => g (1 + y * Complex.I)) volume t0 t1) :
    Rh45RouteBAnalytic.rightPath (fun s => f s - g s) t0 t1
      = Rh45RouteBAnalytic.rightPath f t0 t1 - Rh45RouteBAnalytic.rightPath g t0 t1 := by
  simp only [Rh45RouteBAnalytic.rightPath]
  rw [intervalIntegral.integral_sub h0f h0g, intervalIntegral.integral_sub hvf hvg,
    intervalIntegral.integral_sub h1f h1g]
  ring

end

end RouteABC
