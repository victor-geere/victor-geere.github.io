# `Rh45/ArgumentPrinciple.lean` — the rectangle argument principle

Journal item **J8** (Route B / T8 follow-up).  This module supplies the Mathlib
ingredient that `Rh45/RouteBAnalytic.lean` had to assume as the hypothesis `hAP`,
namely the **argument principle for the rectangle** `[0,1] × [t₀,t₁]`.

Everything below is proved in Lean 4 (v4.35.0-rc2) against Mathlib at
`$HOME/lean/mathlib4`, with **no `sorry`, no `axiom`, no `native_decide`**; the
only axioms used are the standard `[propext, Classical.choice, Quot.sound]`
(verified with `#print axioms`, see below).

## 1. The winding number

The core geometric statement is the total change of `arg` around the rectangle,
computed as the integral of `(s − a)⁻¹`:

```lean
theorem rectBoundary_inv_of_mem (a : ℂ) (t0 t1 : ℝ)
    (hre0 : 0 < a.re) (hre1 : a.re < 1) (him0 : t0 < a.im) (him1 : a.im < t1) :
    rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1 = 2 * (Real.pi : ℂ) * Complex.I
```

```lean
theorem rectBoundary_inv_of_notMem (a : ℂ) (t0 t1 : ℝ)
    (ha : a ∉ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1)) :
    rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1 = 0

theorem rectBoundary_inv_of_outside (a : ℂ) (t0 t1 : ℝ) (ht : t0 ≤ t1)
    (h : a.re < 0 ∨ 1 < a.re ∨ a.im < t0 ∨ t1 < a.im) :
    rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1 = 0
```

`rectBoundary` is the normal form of `Rh45/RouteBAnalytic.lean`
(`∫₀¹ g(x+it₀) − ∫₀¹ g(x+it₁) + i∫_{t₀}^{t₁} g(1+iy) − i∫_{t₀}^{t₁} g(iy)`); the
closed rectangle is `[[0,1]] ×ℂ [[t₀,t₁]]` (`Set.uIcc 0 1 ×ℂ Set.uIcc t0 t1`).

### How the inside case is proved (no Cauchy–Goursat, no homotopy)

The integral is computed edge by edge with the fundamental theorem of calculus
for `Complex.log` (`Complex.hasDerivAt_log`, which holds on the slit plane
`Complex.slitPlane = {z | 0 < z.re ∨ z.im ≠ 0}`):

| edge | integrand | antiderivative | why it is valid |
|---|---|---|---|
| `Im s = t₀` | `(x+it₀−a)⁻¹` | `log(x+it₀−a)` | `Im = t₀ − a.im < 0`, so the whole edge avoids the slit |
| `Im s = t₁` | `(x+it₁−a)⁻¹` | `log(x+it₁−a)` | `Im = t₁ − a.im > 0` |
| `Re s = 1` | `i(1+iy−a)⁻¹` | `log(1+iy−a)` | `Re = 1 − a.re > 0` |
| `Re s = 0` | `i(iy−a)⁻¹` | `log(a−iy)` | `Re(a−iy) = a.re > 0` |

The last row is the only subtle one: the naive antiderivative `log(iy−a)` would
have to cross the slit at `y = a.im`, so the *shifted* logarithm `log(a−iy)` is
used instead (`d/dy log(a−iy) = i/(iy−a)`).

With `u₀ = a − it₀` (`Im u₀ = a.im − t₀ > 0`) and `u₁ = a − it₁`
(`Im u₁ = a.im − t₁ < 0`) the four edge values telescope to

```
(log u₀ − log(−u₀)) + (log(−u₁) − log u₁).
```

Each bracket is the jump of `Complex.arg` across the negative real axis and is
computed from `Complex.arg_neg_eq_arg_sub_pi_of_im_pos` /
`Complex.arg_neg_eq_arg_add_pi_of_im_neg`:

```lean
theorem log_sub_log_neg (u : ℂ) (h : 0 < u.im) :
    Complex.log u - Complex.log (-u) = (Real.pi : ℂ) * Complex.I

theorem log_neg_sub_log (u : ℂ) (h : u.im < 0) :
    Complex.log (-u) - Complex.log u = (Real.pi : ℂ) * Complex.I
```

so the total is `πi + πi = 2πi`.

The **outside** case needs no new computation at all: `(s − a)⁻¹` is then
holomorphic on a neighbourhood of the closed rectangle, so Cauchy–Goursat for a
rectangle (`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`, already
in Mathlib) gives `0`.

## 2. Linearity and `logDeriv` of a factorised function

```lean
theorem rectBoundary_const_mul (c : ℂ) (f : ℂ → ℂ) (t0 t1 : ℝ) :
    rectBoundary (fun s => c * f s) t0 t1 = c * rectBoundary f t0 t1

theorem rectBoundary_finsetSum {ι : Type*} (Z : Finset ι) (F : ι → ℂ → ℂ) (t0 t1 : ℝ)
    (h0 : ∀ z ∈ Z, IntervalIntegrable (fun x : ℝ => F z (x + t0 * Complex.I)) volume 0 1)
    (h1 : ∀ z ∈ Z, IntervalIntegrable (fun x : ℝ => F z (x + t1 * Complex.I)) volume 0 1)
    (h2 : ∀ z ∈ Z, IntervalIntegrable (fun y : ℝ => F z (1 + y * Complex.I)) volume t0 t1)
    (h3 : ∀ z ∈ Z, IntervalIntegrable (fun y : ℝ => F z (y * Complex.I)) volume t0 t1) :
    rectBoundary (fun s => ∑ z ∈ Z, F z s) t0 t1 = ∑ z ∈ Z, rectBoundary (F z) t0 t1

theorem logDeriv_sub_const (z x : ℂ) : logDeriv (fun s : ℂ => s - z) x = (x - z)⁻¹

theorem logDeriv_prod_pow (Z : Finset ℂ) (m : ℂ → ℕ) (C : ℂ) (hC : C ≠ 0) (x : ℂ)
    (hx : ∀ z ∈ Z, x ≠ z) :
    logDeriv (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z)) x
      = ∑ z ∈ Z, (m z : ℂ) * (x - z)⁻¹
```

`logDeriv_prod_pow` is the pointwise product rule, from `logDeriv_const_mul`,
`logDeriv_prod`, `logDeriv_fun_pow` (all in Mathlib) and `logDeriv_sub_const`.

## 3. The factorised argument principle

```lean
theorem argument_principle_factorized (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (C : ℂ) (hC : C ≠ 0)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      f =ᶠ[𝓝 s] (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z))) :
    rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ))
```

That is `∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z`, the multiplicity-weighted zero count.
The proof composes the three ingredients of §1–§2: on the rectangle
`logDeriv f = logDeriv (C ∏ (s−z)^{m z}) = ∑_z m_z (s−z)⁻¹` (the factorization is
used only through the eventual equality, via `logDeriv_congr_nhds`, and only at
boundary points, where `s ∉ Z`); then `rectBoundary_finsetSum` splits the sum;
finally `rectBoundary_const_mul` and `rectBoundary_inv_of_mem` evaluate each
term to `m_z · 2πi`.

## 4. Discharging `hAP`

```lean
theorem routeB_reduction_factorized (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (C : ℂ) (hC : C ≠ 0)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      f =ᶠ[𝓝 s] (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z)))
    (h1 : ∀ s, f (1 - s) = f s) (h2 : ∀ s, f (conj s) = conj (f s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv f) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

This is `N(T) = Im(I₃)/π` with `N(T) = ∑_{z∈Z} m z` **derived**, not assumed:
`argument_principle_factorized` supplies `hAP`, and
`routeB_reduction_of_functional_equation` (from `RouteBAnalytic.lean`) turns it
into the imaginary-part statement.  `routeB_reduction` itself is left untouched.

## 5. What is *not* landed, and precisely why

> **Update.**  The Weierstrass-type factorization and the resulting
> `argument_principle_general` (with `Z` and `analyticOrderNatAt` defined rather
> than assumed) are now proved in `Rh45/WEIERSTRASS.md` / `Rh45/Weierstrass.lean`.
> The items below record the state of *this* module; of them, only the first is
> resolved by that file.

* **`argument_principle_general` for an arbitrary analytic `f`** (with the zero
  set `Z` and multiplicities `m z = analyticOrderNatAt f z` *defined*, not
  assumed) is **not** delivered.  Everything reduces to the existence of the
  finite factorization

  `f =ᶠ[𝓝 s] (fun s => C · ∏_{z∈Z} (s − z)^(m z))` on the rectangle,

  i.e. a Weierstrass-type factorization of an analytic function with finitely
  many zeros.  Mathlib has the *local* order machinery
  (`AnalyticAt.analyticOrderAt_eq_natCast`, `MeromorphicOn.divisor`,
  `meromorphicOrderAt`) and isolated zeros (`AnalyticOn.eqOn_zero_of_preconnected_of_eventuallyEq_zero`),
  but **no theorem** that divides out the finitely many zeros and identifies the
  remaining zero-free analytic function with the constant `C` (nor even that the
  remaining function is a nonzero constant on the rectangle).  Producing that
  factorization is a separate, substantial development; hence the hypothesis
  `hfac` is explicit in the delivered theorem rather than silently assumed.

* **The `hAP` instance for `ξ` itself.**  Even with §3, instantiating at
  `f = ξ` additionally needs (a) the factorization of `ξ` above, (b) the
  conduction that the zero set of `ξ` in the rectangle is finite (available via
  isolated zeros for an entire `ξ`, but `xi` as defined in
  `RouteBAnalytic.lean` has removable singularities at `0,1` and is not known to
  be entire), and (c) the reality `ξ(conj s) = conj (ξ s)` — all three are the
  gaps already listed in `README.md`.  None of them is an argument-principle
  issue.

* **Points on the boundary.**  For `a` exactly on `∂R` the integral of
  `(s−a)⁻¹` is not an ordinary (Lebesgue) interval integral; no statement is
  made.  The inside/outside cases are the only two that occur in Route B, since
  the zeros of `ξ` are not assumed to lie on the contour.

* **`Complex.log`-vs-`arg` for `a` inside the rectangle in the general
  half-plane orientation**: the proof is stated for the rectangle `[0,1] × [t₀,t₁]`
  with `t₀ < t₁` forced by `t₀ < a.im < t₁`.  This is exactly the orientation
  used by `rectBoundary`, so no generality is lost for the application.

## 6. Axiom check

```
#print axioms Rh45RouteBAnalytic.rectBoundary_inv_of_mem
#print axioms Rh45RouteBAnalytic.rectBoundary_inv_of_outside
#print axioms Rh45RouteBAnalytic.logDeriv_prod_pow
#print axioms Rh45RouteBAnalytic.rectBoundary_finsetSum
#print axioms Rh45RouteBAnalytic.argument_principle_factorized
#print axioms Rh45RouteBAnalytic.routeB_reduction_factorized
```

All six print `[propext, Classical.choice, Quot.sound]`.

## 7. Reproduce

```bash
cd /Users/victor/workspace/rh/research/twin-prime-parity/010/lean
./check.sh --all          # 7/7 OK
./check.sh Rh45/ArgumentPrinciple.lean
```
