# `Rh45/XiEntire.lean` — the concrete ingredients for Route B at `ξ`

Follow-up to `RouteBGeneral.lean`.  That module proves the abstract rectangle
argument principle and the resulting Route B reduction for an arbitrary
analytic `f` with the two structural symmetries `f(1−s) = f(s)` and
`f(conj s) = conj (f s)`.  This module supplies the two concrete facts about the
Riemann `ξ` function that Mathlib was missing — the ones named in the *"Not
formalised here"* section of `README.md` — and instantiates the abstract
theorem at `ξ`.

Everything below is proved in Lean 4 (v4.35.0-rc2) against Mathlib at
`$HOME/lean/mathlib4`, with **no `sorry`, no `axiom`, no `native_call` /
`native_decide`, no `maxHeartbeats`**; the only axioms used are
`[propext, Classical.choice, Quot.sound]` (verified by `#print axioms` for
`completedRiemannZeta₀_conj`, `xi₀_conj` and `xi_routeB_general`).

## 1. Reality of `Λ₀ = completedRiemannZeta₀`

Mathlib has `riemannZeta_conj` and `Complex.Gamma_conj`, but **no** conjugation
symmetry for `completedRiemannZeta₀` (it is defined through the Hurwitz zeta,
not as `Gammaℝ · riemannZeta`).  Two results are added.

```lean
theorem Gammaℝ_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s)
```

Since `Gammaℝ s = π^{−s/2} Γ(s/2)` (`Gammaℝ_def`), this is the commutation of
conjugation with the complex power of the positive real base `π`
(`Complex.cpow_conj`, using `arg ↑π = 0`) together with `Complex.Gamma_conj`.

```lean
theorem completedRiemannZeta₀_conj (s : ℂ) :
    completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s)
```

### Proof route

* `completedRiemannZeta_eq` gives `Λ(s) = Λ₀(s) − 1/s − 1/(1−s)`, and
  `riemannZeta_eq_completedRiemannZeta₀` (for `s ≠ 0`) puts this over
  `Gammaℝ s = π^{−s/2} Γ(s/2)`.  Hence on `1 < re s` — where the
  archimedean factor is nonzero, `Gammaℝ_ne_zero_of_re_gt_one` — the *product*
  form holds:

  ```lean
  Λ₀(s) = ζ(s) · Gammaℝ(s) + 1/s + 1/(1−s)          (1 < re s).
  ```

  Applying `conj` to this identity and using `riemannZeta_conj`, `Gammaℝ_conj`
  gives `Λ₀(conj s) = conj (Λ₀ s)` for `1 < re s`
  (`completedRiemannZeta₀_conj_of_re_gt_one`).

* The hypothesis `1 < re s` is then removed.  The function
  `conj ∘ Λ₀ ∘ conj` is entire (`differentiableAt_conj_conj_iff`) and agrees
  with `Λ₀` on the whole open half-plane `{1 < re ·}`, a neighbourhood of `2`;
  the identity principle `AnalyticOnNhd.eq_of_eventuallyEq` on `ℂ` (a
  preconnected space) propagates the equality to all `s`.  Conjugating once more
  gives the stated form.

  This detour via an open identity is what lets the module avoid the discrete
  set `s = −2m` where `Gammaℝ` vanishes: the product form (1) is never needed
  there.

## 2. The entire normalisation `xi₀`

The paper's `xi s = ½ s(s−1) Λ(s)` is the literal definition but is not
manifestly entire at `s = 0, 1`; the entire normalisation is

```lean
def xi₀ (s : ℂ) : ℂ := (1 / 2) * (s * (s - 1)) * completedRiemannZeta₀ s + 1 / 2
```

with the following properties.

```lean
theorem xi_eq_xi₀ {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1) : xi s = xi₀ s
theorem xi₀_one_sub (s : ℂ) : xi₀ (1 - s) = xi₀ s
theorem xi₀_conj (s : ℂ) : xi₀ (conj s) = conj (xi₀ s)
theorem differentiable_xi₀ : Differentiable ℂ xi₀
theorem logDeriv_xi_eq_xi₀ {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1) :
    logDeriv xi s = logDeriv xi₀ s
```

* `xi_eq_xi₀` is the algebra
  `½ s(s−1)(Λ₀(s) − 1/s − 1/(1−s)) = ½ s(s−1) Λ₀(s) + ½` under `s ≠ 0, 1`
  (`completedRiemannZeta_eq`, `field_simp`, `ring`); the removable-singularity
  values at `0, 1` are both `½`.
* `xi₀_one_sub` is `completedRiemannZeta₀_one_sub` plus `(1−s)(−s) = s(s−1)`.
* `xi₀_conj` pushes `conj` through the product, using
  `completedRiemannZeta₀_conj`.
* `differentiable_xi₀` is `differentiable_completedZeta₀` closed under
  multiplication and addition (`fun_prop`).
* `logDeriv_xi_eq_xi₀` is `logDeriv_congr_nhds` from `xi =ᶠ[𝓝 s] xi₀`
  (`eventually_ne_nhds` for `s ≠ 0, 1`): `{0,1}` is closed, so its complement is
  a neighbourhood of `s`.

## 3. Route B at `ξ`

```lean
theorem xi_routeB_general (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : 0 < t0) (ht' : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt xi₀ z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → xi₀ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv xi₀ (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv xi₀ (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv xi) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

That is `N = Im(I₃)/π` for `ξ`, with the zero count derived rather than
assumed.  The proof is

* `routeB_reduction_general xi₀ t0 t1 Z m ht' han hmem hm hno xi₀_one_sub
  xi₀_conj hint₀ hint₁`, where `han` is `differentiable_xi₀` restricted to the
  rectangle (`DifferentiableOn.analyticOnNhd`); this yields the statement for
  `rightPath (logDeriv xi₀)`;
* transfer to `xi`.  `rightPath g t₀ t₁` is a sum of three interval integrals
  (bottom `x ↦ x + i t₀`, right `y ↦ 1 + i y`, top `x ↦ x + i t₁`).  On each,
  `logDeriv xi = logDeriv xi₀` by `logDeriv_xi_eq_xi₀`, because every point has
  imaginary part `≥ t₀ > 0` (`ofReal_add_mul_I_ne_zero_one`,
  `one_add_mul_I_ne_zero_one`, via `congrArg Complex.im`) and so is neither `0`
  nor `1`.  `intervalIntegral.integral_congr` rewrites the three integrals, and
  `rightPath (logDeriv xi) = rightPath (logDeriv xi₀)` follows.

The hypothesis `t0 > 0` is exactly what keeps the rectangle off the
non-entire locus `{0,1}` of `xi`; the vertical edge `Re s = 1` only meets `1`
at `y = 0`, which is excluded by `t0 > 0`.

## What remains

* **Instantiation data.**  `xi_routeB_general` still takes the zero set `Z`, the
  orders `m`, zero-freeness of `xi₀` on the rectangle and the two
  interval-integrability conditions as hypotheses.  Producing them for a
  concrete window (e.g. `t₀ = ½`, `t₁ = 15`) is the numerical part of the
  round, not analytic: it is the verified enclosure work of `../rigorous/`.
* **Continuity of `logDeriv xi₀` on the edges.**  The two
  `IntervalIntegrable` hypotheses are not discharged here; the
  `_of_continuous`-style companion of `RouteBAnalytic.lean` could discharge them
  from global continuity of `logDeriv xi₀` away from the zeros, which in turn
  needs a lower bound on `|xi₀|` on the horizontal edges.
* `logDeriv xi = logDeriv xi₀` is stated as an equality of values at
  `s ∉ {0,1}` rather than an `=ᶠ[𝓝 s]` statement; the neighbourhood form is
  recovered immediately by `Filter.EventuallyEq.eventually_nhds` from the
  equality of the two functions on the open complement of the finite closed set
  `{0,1}`.
