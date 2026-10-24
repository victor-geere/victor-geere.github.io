# `010/lean` — Lean 4 core of the Routes A/B/C certification

Machine-checked core of `research/twin-prime-parity/010/`: the certification logic
of §6 of `../eta-euler-acceleration.html` (Routes A, B, C), the algebraic layer and
the archimedean term of the explicit formula, the analytic (symmetric) layer of
Route B, and the von Mangoldt counterexample used by the Route C audit.

Toolchain: Lean `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`. There is no
`lake` project file; `check.sh` rebuilds `LEAN_PATH` from `lake env` inside
Mathlib (adapted from the round series). The dependency directory is
`../rounds/rh43/lean` (relative to the repository), even though the modules here
import only Mathlib.

## Building

```
cd research/twin-prime-parity/010/lean
./check.sh --all                 # Explicit, Archimedean, Routes, VonMangoldtSieve,
                                 # RouteBAnalytic, Rh45.lean -> 6/6 OK
./check.sh Rh45/Routes.lean
```

## Status

`./check.sh --all` → **`[check] OK`** for every file. **0 `sorry`**, **0 `axiom`**.
`#print axioms` on the theorems below gives exactly
`[propext, Classical.choice, Quot.sound]`.

| file | contents |
|---|---|
| `Rh45/Explicit.lean` | algebraic layer: Cauchy and Gaussian kernels, evenness and exact values, the `s ↔ 1−s` symmetry, the pole-pair collapse `polePair_eq`, the smoothed zero count, the counting main term `(T/2π)log(T/2πe) + 7/8`, and the Fourier pairing `∫ e^{−\|u\|} cos(tu) du = π/2 · cauchyKernel t` |
| `Rh45/Archimedean.lean` | the archimedean term: the digamma line `Re z = 1/4`, continuity/measurability of `Ψ(t) = −log π + Re ψ(1/4 + i t/2)`, the digamma recurrence and reflection formula on the line, the chain rule `Ψ^{(k)}(t) = (i/2)^k ψ^{(k)}(1/4+i t/2)` behind the `2^{−k}` budget, the Leibniz bound `\|(φΨ)^{(4)}\| ≤ Σ_k binom(4,k) M_k P_{4−k}`, and the composite-Simpson assembly `(b−a)h⁴/180 · Σ_k binom(4,k) M_k P_{4−k}` |
| `Rh45/Routes.lean` | **Route A**: `exists_unique_root_of_sign_change`, `exists_unique_root_of_sign_change_neg`, `certified_root_of_enclosures`. **Route B**: `turing_reduction`, `all_zeros_are_certified`. **Route C**: `validated_truncation_bound`, `prime_tail_input` (Mathlib's `Chebyshev.psi_le_const_mul_self`) |
| `Rh45/VonMangoldtSieve.lean` | `vonMangoldt_six` (`Λ 6 = 0`), `vonMangoldt_not_additive` (witness `6 = 2·3`) |
| `Rh45/RouteBAnalytic.lean` | the analytic (symmetric) layer of Route B: `xi_one_sub` (`ξ(1−s) = ξ(s)`), `logDeriv_one_sub`, `logDeriv_conj`, `logDeriv_one_sub_conj`, the contour reduction `rectBoundary_eq_rightPath_sub_conj` (`∮_{∂R} g = I₃ − conj I₃ = 2i·Im I₃`), and `routeB_reduction` / `routeB_reduction_of_functional_equation` (`Im(I₃) = πZ` from the argument-principle count `∮ = 2πiZ`) |
| `Rh45.lean` | root module importing the five |

## What Mathlib has for the digamma function

`Mathlib/Analysis/SpecialFunctions/Gamma/Digamma.lean` defines
`Complex.digamma = logDeriv Complex.Gamma` and proves exactly:

* `digamma_zero`, `digamma_one`, `digamma_one_half` (values);
* `digamma_apply_add_one` and `digamma_apply_add_nat` (`ψ(s+n) = ψ(s) + Σ_{k<n}(s+k)⁻¹`);
* `digamma_nat_add_one` (`ψ(n+1) = H_n − γ`);
* `digamma_one_sub` (Euler reflection, `ψ(1−s) = ψ(s) + π cot(πs)`);
* `digamma_two_mul` (duplication), `meromorphic_digamma`,
  `HasDerivAt.logDeriv_Gamma`.

There is **no** series, asymptotic expansion, growth estimate or value at `1/4`,
`3/4`, and **no** trigamma/polygamma and **no** quadrature at all (no Simpson, no
trapezium, no Euler–Maclaurin). Those gaps fix the shape of `Archimedean.lean`:
what is conditional is flagged as a hypothesis (`psiSeriesBound` reduction,
`SimpsonPanelEstimate`), everything else is unconditional.

## Route B — the analytic (symmetric) layer

`Rh45/RouteBAnalytic.lean` formalises the analytic content of the identity
`N(T) = Im(I₃)/π` from §3 of
[`../notes/routes-a-b-c-status.md`](notes/routes-a-b-c-status.md), leaving the
argument principle itself as an explicit hypothesis.

**The function `ξ`.**  Mathlib has no `riemannXi`; the completed zeta function is
`completedRiemannZeta` (`Λ(s) = π^{−s/2} Γ(s/2) ζ(s)`), and `xi` is defined here as
`xi s = ½ s (s−1) Λ(s)`.  Mathlib's `completedRiemannZeta_one_sub` is the functional
equation for `Λ`, so

```lean
theorem xi_one_sub (s : ℂ) : xi (1 - s) = xi s
```

is the polynomial identity `½(1−s)(−s) = ½s(s−1)`.  (The removable singularity of
`½ s(s−1)Λ(s)` at `s = 1` and the convention at `s = 0` are not renormalised; both
sides vanish there, so the equation still holds.)

**Reflection of `ξ′/ξ`.**  Two unconditional identities:

```lean
theorem logDeriv_one_sub (f : ℂ → ℂ) (hf : ∀ s, f (1 - s) = f s) (s : ℂ) :
    logDeriv f (1 - s) = -logDeriv f s
theorem logDeriv_conj (f : ℂ → ℂ) (hf : ∀ s, f (conj s) = conj (f s)) (s : ℂ) :
    logDeriv f (conj s) = conj (logDeriv f s)
```

(the first from `deriv_comp_const_sub`, the second from `deriv_conj_conj`; neither
needs a differentiability hypothesis, since `deriv` is `0` where the function is not
differentiable).  Combining them,

```lean
theorem logDeriv_one_sub_conj (f : ℂ → ℂ)
    (h1 : ∀ s, f (1 - s) = f s) (h2 : ∀ s, f (conj s) = conj (f s)) (s : ℂ) :
    logDeriv f (1 - conj s) = -conj (logDeriv f s)
```

For `f = ξ` the first input is `xi_one_sub` and the second is the reality of `ξ` on
the real axis, `ξ(conj s) = conj (ξ s)` (see the gap list below);
`xi_logDeriv_symmetry` packages this.

**The contour reduction.**  Writing `g` for the integrand, let

```
rectBoundary g t₀ t₁ = ∫₀¹ g(x+it₀) − ∫₀¹ g(x+it₁) + i∫_{t₀}^{t₁} g(1+iy) − i∫_{t₀}^{t₁} g(iy)
rightPath   g t₀ t₁ = ∫_{½}^{1} g(x+it₀) + i∫_{t₀}^{t₁} g(1+iy) − ∫_{½}^{1} g(x+it₁)
```

the boundary of `[0,1] × [t₀,t₁]` in the normal form of Mathlib's
`Complex.integral_boundary_rect_of_differentiableOn_real`, and the three-segment path
`I₃`.  The reflection `s ↦ 1 − conj s` in the line `Re s = ½` preserves the
rectangle, reverses orientation and interchanges the two halves of the boundary; the
pointwise symmetry `g(1 − conj s) = −conj (g s)` turns the left half-integral into
the conjugate of the right half-integral, giving

```lean
theorem rectBoundary_eq_rightPath_sub_conj (g : ℂ → ℂ) (t₀ t₁ : ℝ) … :
    rectBoundary g t₀ t₁ = rightPath g t₀ t₁ - conj (rightPath g t₀ t₁)
```

Since `z − conj z = 2i · Im z` (`Complex.sub_conj`), this is `∮_{∂R} g = 2i · Im I₃`.
Feeding in the argument principle `∮_{∂R} g = 2πi Z` (zeros counted with
multiplicity),

```lean
theorem routeB_reduction (g : ℂ → ℂ) (t₀ t₁ : ℝ) … (Z : ℝ)
    (hAP : rectBoundary g t₀ t₁ = 2 * π * I * Z) :
    (rightPath g t₀ t₁).im = π * Z
```

i.e. `N(T) = Im(I₃)/π` as in the note.  There is a packaged form
`routeB_reduction_of_functional_equation (f : ℂ → ℂ) …` that takes `f` itself with
`f(1−s) = f(s)`, `f(conj s) = conj (f s)` (applying `logDeriv_one_sub_conj` for the
user) and concludes `Im(I₃) = πZ` for `I₃ = rightPath (logDeriv f) t₀ t₁`.  The
conclusion is only about `Im I₃`: the boundary integral determines `Im I₃` but leaves
`Re I₃` free, which is exactly what `N(T) = Im(I₃)/π` uses.  The two
interval-integrability side conditions are exactly integrability of `ξ′/ξ` along the
two *horizontal* edges at heights `t₀` and `t₁`; they hold whenever no zero of `ξ`
has ordinate `t₀` or `t₁` (in particular for `t₀ = ½`, `t₁ = T` generic), since the
vertical edges `Re s = 0`, `Re s = 1` and the horizontal edges avoid all zeros.  The
`_of_continuous` form discharges the conditions from global continuity of `g`.

## Mathlib inventory: `logDeriv`, argument principle, `riemannXi`

Searched in `$HOME/lean/mathlib4/Mathlib`.

* **`riemannXi` / `completedRiemannZeta`.**  There is **no** `riemannXi` (0 occurrences
  in Mathlib).  `Mathlib/NumberTheory/LSeries/RiemannZeta.lean` defines
  `completedRiemannZeta` (`Λ`), `completedRiemannZeta₀`, `riemannZeta`, and proves
  `completedRiemannZeta_one_sub`, `completedRiemannZeta₀_one_sub`, `riemannZeta_one_sub`
  (the functional equations), `differentiable_completedZeta₀`,
  `differentiableAt_completedZeta` (away from `0,1`),
  `riemannZeta_conj` (conjugation symmetry of `ζ`), and
  `differentiableAt_riemannZeta`.  `Gammaℝ s = π^{−s/2} Γ(s/2)` is in
  `Mathlib/Analysis/SpecialFunctions/Gamma/Deligne.lean`; `Complex.Gamma_conj` is in
  `Mathlib/Analysis/SpecialFunctions/Gamma/Basic.lean`.  **Missing:** a conjugation
  symmetry `completedRiemannZeta (conj s) = conj (completedRiemannZeta s)` (the reality
  of `Λ`, hence of `ξ`, on the real axis).

* **`logDeriv`.**  `Mathlib/Analysis/Calculus/LogDeriv.lean` has `logDeriv_apply`
  (`logDeriv f x = deriv f x / f x`), `logDeriv_comp`, `logDeriv_comp_neg`,
  `logDeriv_mul/div/prod/zpow`, `logDeriv_congr_nhds`,
  `AnalyticAt.tendsto_mul_logDeriv_simple_zero`;
  `Mathlib/Analysis/Meromorphic/LogDeriv.lean` has the meromorphic arithmetic
  (`MeromorphicOn.logDeriv_mul_eventuallyEq` etc.).
  `Mathlib/Analysis/Calculus/Deriv/Shift.lean` (`deriv_comp_const_sub`) and
  `Mathlib/Analysis/Calculus/Deriv/Star.lean` (`deriv_conj_conj`,
  `HasDerivAt.conj_conj`) provide the reflection identities used here.
  **Missing:** no lemma relating `logDeriv f (1−s)` to `logDeriv f s`; no
  `logDeriv_conj`; both are proved in `RouteBAnalytic.lean`.

* **The argument principle.**  `Mathlib/Analysis/Complex/CauchyIntegral.lean` proves the
  Cauchy–Goursat theorem for a rectangle
  (`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`) and the Cauchy integral
  formula on circles/disks/annuli, and defines `Complex.circleIntegral`.  But there is
  **no** argument principle: no statement computing `∮ f′/f` as `2πi` times a zero count,
  no winding number, no zero-counting theorem for `f′/f` around any contour, and no
  residue-at-zero API for it.  `Mathlib/Analysis/Complex/ValueDistribution/` develops the
  value-distribution / Jensen-formula theory (`LogCounting`, `Proximity`,
  `CharacteristicFunction`, `FirstMainTheorem`), which counts zeros through `log|f|`, not
  through `∮ f′/f`; it does not provide the rectangle argument principle needed here.
  **Missing and not built:** the meromorphic rectangle argument principle
  `∮_{∂R} f′/f = 2πi · Σ_{ζ∈R} mult(ζ)`, the identification of the residue of `f′/f` with
  the order of `f`, and the existence of the rectangle boundary path as a closed curve.

## In words

* **Route A.** A continuous `f` on `[a,b]` with `f a < 0 < f b` and a strictly
  one-signed derivative has a unique simple zero in `(a,b)`; `_neg` covers the
  decreasing case (used at `γ₂` and `γ₄`, where `Z′ < 0`).
* **Route B.** If the certified on-line zeros are contained in the window's zero
  set and the rigorous count bounds the total, the two sets are equal:
  `all_zeros_are_certified` is the packaged form. Together with the numerical
  count `N(15) = 1` it closes the window `½ < Im < 15`. The *analytic* half of the
  count `N(T) = Im(I₃)/π` is in `RouteBAnalytic.lean`: `ξ(1−s) = ξ(s)`, the
  reflection of `ξ′/ξ`, and the symmetric contour reduction
  `∮_{∂R} ξ′/ξ = I₃ − conj I₃ = 2i·Im I₃`, conditional only on the argument
  principle `∮ = 2πiZ` (absent from Mathlib).
* **Route C.** `validated_truncation_bound` is the triangle inequality that turns
  the three proved tails into a bound on `|lhs − rhsComputed|`;
  `prime_tail_input` is Mathlib's Chebyshev bound `ψ(x) ≤ (log 4 + 4)x`, the
  rigorous input that replaces a density estimate.
* **Archimedean term.** `digammaLine t = 1/4 + i t/2` parametrises the line on
  which the archimedean factor lives; `PsiBar t = −log π + Re ψ(1/4 + i t/2)`, and
  `continuous_PsiBar` / `measurable_PsiBar` certify that the integrand of
  `(1/2π)∫φΨ` is continuous and measurable. `digammaLine_add_nat` and
  `digammaLine_reflection` read Mathlib's recurrence and reflection formula on the
  line. `iteratedDeriv_Psi_eq` is the chain rule
  `Ψ^{(k)}(t) = (i/2)^k ψ^{(k)}(1/4 + i t/2)`, the source of the `2^{−k}` in the
  round's derivative budget; `archimedean_deriv_bound_of_digamma_series` turns the
  (Mathlib-absent) Hurwitz-zeta estimate for `ψ^{(k)}` into
  `‖Ψ^{(k)}(t)‖ ≤ 2^{−k} k! Σ_j (1/4+j)^{−k−1}`. `abs_iteratedDeriv_four_mul_le`
  is the Leibniz bound `|(φΨ)^{(4)}| ≤ Σ_k binom(4,k) M_k P_{4−k}`, and
  `simpsonSum_mul_error_le` assembles composite Simpson from the single-panel
  estimate to the round's `(b−a)h⁴/180 · Σ_k binom(4,k) M_k P_{4−k}`.

## Axiom check

```lean
import Rh45
#print axioms Rh45Routes.exists_unique_root_of_sign_change
#print axioms Rh45Routes.exists_unique_root_of_sign_change_neg
#print axioms Rh45Routes.turing_reduction
#print axioms Rh45Routes.all_zeros_are_certified
#print axioms Rh45Routes.validated_truncation_bound
#print axioms Rh45Routes.prime_tail_input
#print axioms Rh45.continuous_PsiBar
#print axioms Rh45.iteratedDeriv_Psi_eq
#print axioms Rh45.abs_iteratedDeriv_four_mul_le
#print axioms Rh45.simpsonSum_mul_error_le
#print axioms Rh45RouteBAnalytic.xi_one_sub
#print axioms Rh45RouteBAnalytic.logDeriv_one_sub
#print axioms Rh45RouteBAnalytic.logDeriv_conj
#print axioms Rh45RouteBAnalytic.logDeriv_one_sub_conj
#print axioms Rh45RouteBAnalytic.rectBoundary_eq_rightPath_sub_conj
#print axioms Rh45RouteBAnalytic.routeB_reduction
#print axioms Rh45RouteBAnalytic.routeB_reduction_of_functional_equation
```

## Not formalised here

The numerical enclosures themselves (Python, `../rigorous/`), the Stirling-based
bounds on `θ, θ′, ψ, ψ′`, and the Chebyshev/Trudgian inputs cited by Route C; see
`../index.html` §3 and `../notes/routes-a-b-c-status.md`.

In particular `Rh45/Archimedean.lean` leaves two inputs as explicit hypotheses,
because Mathlib does not contain them:

* `psiSeriesBound` (in `archimedean_deriv_bound_of_digamma_series`): the
  Euler–Maclaurin/Hurwitz series `ψ^{(k)}(z) = (−1)^{k+1} k! Σ_{j≥0} (z+j)^{−k−1}`
  and the real-axis bound `|ψ^{(k)}(1/4 + i t/2)| ≤ k! Σ_j (1/4+j)^{−k−1}`.  (For
  `k = 0` the series `Σ_j (1/4+j)^{−1}` diverges, so the `k = 0` instance carries
  no information; the meaningful cases are `k ≥ 1`.)
* `SimpsonPanelEstimate`: the classical single-panel Simpson error bound
  `|∫_c^{c+2H} G − simpsonPanel G c H| ≤ (2H)⁵/2880 · sup|G^{(4)}|`.  Everything
  from it — the panel decomposition of the integral, the summation, and the
  sharp constant `1/180` — is proved.

`Rh45/RouteBAnalytic.lean` leaves one input as an explicit hypothesis, because
Mathlib does not contain it:

* **the argument principle for a rectangle** (in `routeB_reduction`, as `hAP`):
  `∮_{∂R} f′/f = 2πi Z`, `Z` the multiplicity-weighted number of zeros of `f`
  enclosed by `R`.  Mathlib has the Cauchy–Goursat theorem for a rectangle
  (`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`) and the Cauchy
  integral formula, but no `∮ f′/f` / winding-number / zero-counting statement
  (see the inventory above).  All the *symmetry* content of the reduction —
  `∮_{∂R} g = I₃ − conj I₃`, hence `Im(I₃) = πZ` given `∮ = 2πiZ` — is proved
  unconditionally.

Two further concrete ingredients, not needed as hypotheses of the abstract
reduction but not present in Mathlib, are not formalised:

* **reality of `ξ`** (`ξ(conj s) = conj (ξ s)`), needed to instantiate
  `logDeriv_one_sub_conj` at `f = ξ`; Mathlib has `riemannZeta_conj` and
  `Complex.Gamma_conj`, but no conjugation symmetry for `completedRiemannZeta`
  (it is defined through the Hurwitz zeta, not as `Gammaℝ * riemannZeta`);
* **entireness / the removable-singularity extension of `ξ`** at `s = 0, 1`
  (the definition `xi = ½ s(s−1)Λ(s)` is the paper's literal one, not the entire
  normalisation `½ s(s−1)Λ₀(s) + ½`, which would require the correction identity
  at `s = 0, 1`).

