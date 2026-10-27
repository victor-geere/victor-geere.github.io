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

**Paper.** The polygamma bridge of `Rh45/GammaProduct.lean` and
`Rh45/PolygammaSeries.lean` — locally uniform Gauss product, Weierstrass
differentiation, the Gauss–Hurwitz series, and the archimedean budget — is written
up as [`../polygamma.html`](../polygamma.html), in the same style as the round's
[`../index.html`](../index.html).

## Building

```
cd research/twin-prime-parity/010/lean
./check.sh --all                 # Explicit, SimpsonPanel, Archimedean, Routes,
                                 # VonMangoldtSieve, RouteBAnalytic, ArgumentPrinciple,
                                 # Weierstrass, RouteBGeneral, XiEntire, GammaProduct,
                                 # PolygammaSeries, Rh45.lean
                                 # -> 13/13 OK
./check.sh Rh45/Routes.lean
```

## Status

`./check.sh --all` → **`[check] OK`** for every file. **0 `sorry`**, **0 `axiom`**.
`#print axioms` on the theorems below gives exactly
`[propext, Classical.choice, Quot.sound]`.

| file | contents |
|---|---|
| `Rh45/Explicit.lean` | algebraic layer: Cauchy and Gaussian kernels, evenness and exact values, the `s ↔ 1−s` symmetry, the pole-pair collapse `polePair_eq`, the smoothed zero count, the counting main term `(T/2π)log(T/2πe) + 7/8`, and the Fourier pairing `∫ e^{−\|u\|} cos(tu) du = π/2 · cauchyKernel t` |
| `Rh45/SimpsonPanel.lean` | the single-panel Simpson estimate, **proved**: `simpsonPanel`/`simpsonSum`, the corrected `SimpsonPanelEstimate` (with the `C⁴` regularity hypothesis that the original statement omitted, and restricted to `0 ≤ H`), its proof `simpsonPanelEstimate`, exactness of Simpson's rule on cubics (`simpsonPanel_taylorWithinEval`), the triangular-swap identity behind the Peano-kernel decomposition, and the sharp constant `(2H)⁵/2880`; see `Rh45/SIMPSON.md` |
| `Rh45/Archimedean.lean` | the archimedean term: the digamma line `Re z = 1/4`, continuity/measurability of `Ψ(t) = −log π + Re ψ(1/4 + i t/2)`, the digamma recurrence and reflection formula on the line, the chain rule `Ψ^{(k)}(t) = (i/2)^k ψ^{(k)}(1/4+i t/2)` behind the `2^{−k}` budget, the Leibniz bound `\|(φΨ)^{(4)}\| ≤ Σ_k binom(4,k) M_k P_{4−k}`, and the composite-Simpson assembly `(b−a)h⁴/180 · Σ_k binom(4,k) M_k P_{4−k}` |
| `Rh45/Routes.lean` | **Route A**: `exists_unique_root_of_sign_change`, `exists_unique_root_of_sign_change_neg`, `certified_root_of_enclosures`. **Route B**: `turing_reduction`, `all_zeros_are_certified`. **Route C**: `validated_truncation_bound`, `prime_tail_input` (Mathlib's `Chebyshev.psi_le_const_mul_self`) |
| `Rh45/VonMangoldtSieve.lean` | `vonMangoldt_six` (`Λ 6 = 0`), `vonMangoldt_not_additive` (witness `6 = 2·3`) |
| `Rh45/RouteBAnalytic.lean` | the analytic (symmetric) layer of Route B: `xi_one_sub` (`ξ(1−s) = ξ(s)`), `logDeriv_one_sub`, `logDeriv_conj`, `logDeriv_one_sub_conj`, the contour reduction `rectBoundary_eq_rightPath_sub_conj` (`∮_{∂R} g = I₃ − conj I₃ = 2i·Im I₃`), and `routeB_reduction` / `routeB_reduction_of_functional_equation` (`Im(I₃) = πZ` from the argument-principle count `∮ = 2πiZ`) |
| `Rh45/ArgumentPrinciple.lean` | the rectangle argument principle missing from Mathlib: the winding number `rectBoundary_inv_of_mem` (`∮_{∂R} (s−a)⁻¹ = 2πi`, `a` strictly inside), `rectBoundary_inv_of_notMem` / `rectBoundary_inv_of_outside` (`= 0`, `a` outside the closed rectangle), the linearity lemmas `rectBoundary_const_mul` / `rectBoundary_finsetSum`, the product rule `logDeriv_prod_pow`, and the factorised argument principle `argument_principle_factorized` (`∮_{∂R} f′/f = 2πi·∑ m z`) |
| `Rh45/Weierstrass.lean` | the zero-division ("Weierstrass") factorisation **not** in Mathlib: `exists_factorization` (`f = g · ∏_{z∈Z}(s−z)^{m z}` with `g` analytic and nowhere zero on the closed rectangle, built by gluing the local order factors of `AnalyticAt.analyticOrderAt_ne_top`), the Cauchy–Goursat step `rectBoundary_logDeriv_eq_zero` (`∮_{∂R} g′/g = 0`), `argument_principle_of_factorization`, and the **general** rectangle argument principle `argument_principle_general` (`∮_{∂R} f′/f = 2πi·∑ m z` with no factorisation hypothesis) |
| `Rh45/RouteBGeneral.lean` | **Route B with the zero count derived**: `routeB_reduction_general` (`(rightPath (logDeriv f) t₀ t₁).im = π·∑_{z∈Z} m z` from analyticity of `f`, its zero data on the rectangle, and `f(1−s)=f(s)`, `f(conj s)=conj(f s)`) — supersedes `routeB_reduction_factorized` and its constant-`C` factorisation hypothesis |
| `Rh45/XiEntire.lean` | the concrete ingredients for Route B at `ξ`: the reality `completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s)` and `Gammaℝ_conj`, the entire normalisation `xi₀ s = ½ s(s−1)Λ₀(s) + ½` with `xi_eq_xi₀`, `xi₀_one_sub`, `xi₀_conj`, `Differentiable ℂ xi₀` and `logDeriv_xi_eq_xi₀`, and the instantiation `xi_routeB_general` (`(rightPath (logDeriv ξ) t₀ t₁).im = π·∑_{z∈Z} m z`); see `Rh45/XI_ENTIRE.md` |
| `Rh45/GammaProduct.lean` | the locally uniform Euler product limit: `analyticAt_GammaSeq`, `norm_GammaSeq_le`, `tendstoLocallyUniformlyOn_GammaSeq`, `tendstoLocallyUniformlyOn_deriv_GammaSeq`, `tendstoLocallyUniformlyOn_logDeriv_GammaSeq` and the explicit finite log-derivative `logDeriv_GammaSeq` |
| `Rh45/PolygammaSeries.lean` | the polygamma series: the explicit iterated derivative `iteratedDeriv_logDeriv_GammaSeq` (`deriv^[k] (logDeriv (GammaSeq · n)) = (−1)^{k+1} k! ∑_{j≤n} (s+j)^{−k−1}` for `k ≥ 1`), the Gauss/Hurwitz series `digamma_polygamma_series` (`HasSum`), summability `summable_polygamma_series`, the norm bound `norm_deriv_digamma_le`, the **unconditional** archimedean budget `Rh45.archimedean_deriv_bound` (`‖Ψ^{(k)}(t)‖ ≤ psiSeriesBound k`, `k ≥ 1`), `Rh45.psiSeriesBound_zero` (`psiSeriesBound 0 = 0`) and the valid `k = 0` bound `Rh45.norm_digamma_le`; see `Rh45/POLYGAMMA.md` |
| `Rh45.lean` | root module importing the twelve |

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
`3/4`, and **no** trigamma/polygamma.  Mathlib has the trapezium
(`Mathlib/MeasureTheory/Integral/IntervalIntegral/TrapezoidalRule.lean`) but no
Simpson; that gap is filled by `Rh45/SimpsonPanel.lean`.  The polygamma series
that `Archimedean.lean` originally left as a hypothesis is now **proved for
`k ≥ 1`** in `Rh45/PolygammaSeries.lean` (`digamma_polygamma_series`), so the
round's archimedean budget `‖Ψ^{(k)}(t)‖ ≤ psiSeriesBound k` is unconditional
there (`Rh45.archimedean_deriv_bound`); the `k = 0` series diverges
(`Rh45.psiSeriesBound_zero`) and is replaced by the valid bound
`Rh45.norm_digamma_le`.  Everything else is unconditional.

## Route B — the analytic (symmetric) layer

`Rh45/RouteBAnalytic.lean` formalises the analytic content of the identity
`N(T) = Im(I₃)/π` from §3 of
[`../notes/routes-a-b-c-status.md`](../notes/routes-a-b-c-status.md).  The argument
principle it originally took as an explicit hypothesis is now proved in general
form (`Rh45/Weierstrass.lean` + `Rh45/RouteBGeneral.lean`), and the concrete
ingredients for `ξ` (`Rh45/XiEntire.lean`), so Route B at `ξ` no longer has an
analytic input beyond the zero data.

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
  `∮_{∂R} ξ′/ξ = I₃ − conj I₃ = 2i·Im I₃`, and the argument principle
  `∮ = 2πiZ` is proved in general form downstream (see below), together with the
  instantiation at `f = ξ` (`xi_routeB_general`).
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
  `simpsonSum_mul_error_le` assembles composite Simpson to the round's
  `(b−a)h⁴/180 · Σ_k binom(4,k) M_k P_{4−k}`, unconditional in the single-panel
  input (supplied by `simpsonPanelEstimate` from `Rh45/SimpsonPanel.lean`).

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
#print axioms Rh45.simpsonPanelEstimate
#print axioms Rh45RouteBAnalytic.xi_one_sub
#print axioms Rh45RouteBAnalytic.logDeriv_one_sub
#print axioms Rh45RouteBAnalytic.logDeriv_conj
#print axioms Rh45RouteBAnalytic.logDeriv_one_sub_conj
#print axioms Rh45RouteBAnalytic.rectBoundary_eq_rightPath_sub_conj
#print axioms Rh45RouteBAnalytic.routeB_reduction
#print axioms Rh45RouteBAnalytic.routeB_reduction_of_functional_equation
#print axioms Rh45RouteBAnalytic.rectBoundary_inv_of_mem
#print axioms Rh45RouteBAnalytic.rectBoundary_inv_of_outside
#print axioms Rh45RouteBAnalytic.logDeriv_prod_pow
#print axioms Rh45RouteBAnalytic.rectBoundary_finsetSum
#print axioms Rh45RouteBAnalytic.argument_principle_factorized
#print axioms Rh45RouteBAnalytic.routeB_reduction_factorized
#print axioms Rh45RouteBAnalytic.exists_factorization
#print axioms Rh45RouteBAnalytic.argument_principle_general
#print axioms Rh45RouteBAnalytic.routeB_reduction_general
#print axioms Rh45RouteBAnalytic.Gammaℝ_conj
#print axioms Rh45RouteBAnalytic.completedRiemannZeta₀_conj
#print axioms Rh45RouteBAnalytic.xi_eq_xi₀
#print axioms Rh45RouteBAnalytic.xi₀_one_sub
#print axioms Rh45RouteBAnalytic.xi₀_conj
#print axioms Rh45RouteBAnalytic.differentiable_xi₀
#print axioms Rh45RouteBAnalytic.xi_routeB_general
#print axioms Rh45RouteBAnalytic.tendstoLocallyUniformlyOn_GammaSeq
#print axioms Rh45RouteBAnalytic.tendstoLocallyUniformlyOn_deriv_GammaSeq
#print axioms Rh45RouteBAnalytic.tendstoLocallyUniformlyOn_logDeriv_GammaSeq
#print axioms Rh45RouteBAnalytic.logDeriv_GammaSeq
#print axioms Rh45RouteBAnalytic.logDeriv_GammaSeq_of_ne
#print axioms Rh45RouteBAnalytic.iteratedDeriv_logDeriv_GammaSeq
#print axioms Rh45RouteBAnalytic.digamma_polygamma_series
#print axioms Rh45RouteBAnalytic.summable_polygamma_series
#print axioms Rh45RouteBAnalytic.norm_deriv_digamma_le
#print axioms Rh45.digamma_series_bound
#print axioms Rh45.archimedean_deriv_bound
#print axioms Rh45.psiSeriesBound_zero
#print axioms Rh45.norm_digamma_le
```

## Not formalised here

The numerical enclosures themselves (Python, `../rigorous/`), the Stirling-based
bounds on `θ, θ′, ψ, ψ′`, and the Chebyshev/Trudgian inputs cited by Route C; see
`../index.html` §3 and `../notes/routes-a-b-c-status.md`.

In particular `Rh45/Archimedean.lean` used to leave one input as an explicit
hypothesis.  **It is no longer unproved for `k ≥ 1`**: the polygamma series is now
formalised in `Rh45/PolygammaSeries.lean` (see `Rh45/POLYGAMMA.md`), so the round's
archimedean derivative budget is unconditional for `k ≥ 1`.  The remaining
`k = 0` case is recorded below.

* ~~`psiSeriesBound` (in `archimedean_deriv_bound_of_digamma_series`): the
  Euler–Maclaurin/Hurwitz series `ψ^{(k)}(z) = (−1)^{k+1} k! Σ_{j≥0} (z+j)^{−k−1}`
  and the real-axis bound `|ψ^{(k)}(1/4 + i t/2)| ≤ k! Σ_j (1/4+j)^{−k−1}`.~~
  **Now proved for `k ≥ 1`** in `Rh45/PolygammaSeries.lean`:
  `Rh45RouteBAnalytic.digamma_polygamma_series` proves the series as a `HasSum`,
  `Rh45RouteBAnalytic.norm_deriv_digamma_le` the real-axis bound, and
  `Rh45.archimedean_deriv_bound` the resulting unconditional budget
  `‖Ψ^{(k)}(t)‖ ≤ psiSeriesBound k` for `k ≥ 1`.  The
  hypothesis-style `Rh45.archimedean_deriv_bound_of_digamma_series` is kept for
  compatibility.  Mathlib itself has `Complex.digamma = logDeriv Gamma` with only
  the recurrence/reflection/duplication identities (no series), and the **real**
  Bohr–Mollerup limit `Real.BohrMollerup.tendsto_logGammaSeq` for `Gamma` on
  `(0,∞)`; it has **no** complex Gamma product/sequence, no termwise
  differentiation of `n! n^z/∏(z+j)` and no polygamma at all.  The route taken
  here (see `Rh45/POLYGAMMA.md`) avoids a full Weierstrass product: it starts from
  the *pointwise* `Complex.GammaSeq_tendsto_Gamma`, upgrades it to locally uniform
  convergence in `Rh45/GammaProduct.lean`, differentiates the explicit finite
  log-derivative, and passes to the limit.
* **`k = 0`.**  The series `Σ_j (1/4+j)^{−1}` diverges, so `psiSeriesBound 0` is
  the junk value `0` (`Rh45.psiSeriesBound_zero`), and the `k = 0` instance of
  `archimedean_deriv_bound_of_digamma_series` carries no information.  A valid
  replacement is `Rh45.norm_digamma_le`:
  `‖Ψ t‖ ≤ γ + (3/4 + |t|/2) · ∑_j ((j+1)(1/4+j))⁻¹ + 4`, obtained from the
  Weierstrass partial-sum form `ψ(s) = −γ + Σ_j (1/(j+1) − 1/(s+j))` and the
  harmonic limit `Real.tendsto_harmonic_sub_log`.
* ~~`SimpsonPanelEstimate`: the classical single-panel Simpson error bound
  `|∫_c^{c+2H} G − simpsonPanel G c H| ≤ (2H)⁵/2880 · sup|G^{(4)}|`.~~
  **Now proved** in `Rh45/SimpsonPanel.lean` (`simpsonPanelEstimate`), and the
  statement as it stood was false: it omitted `ContDiffOn ℝ 4 G` (reason:
  `G x = |x|` on `[-1,1]` has `iteratedDeriv 4 G = 0` yet
  `simpsonPanel G (-1) 1 = 2/3 ≠ 1 = ∫_{-1}^1 |x|`), and it was asserted for all
  `H` although for `H < 0` the derivative hypothesis is vacuous and the bound
  `(2H)⁵/2880 · B` is negative.  See `Rh45/SIMPSON.md`.

`Rh45/RouteBAnalytic.lean` originally left one input as an explicit hypothesis,
because Mathlib did not contain it:

* **the argument principle for a rectangle** (in `routeB_reduction`, as `hAP`):
  `∮_{∂R} f′/f = 2πi Z`, `Z` the multiplicity-weighted number of zeros of `f`
  enclosed by `R`.  Mathlib has the Cauchy–Goursat theorem for a rectangle
  (`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`) and the Cauchy
  integral formula, but no `∮ f′/f` / winding-number / zero-counting statement
  (see the inventory above).  All the *symmetry* content of the reduction —
  `∮_{∂R} g = I₃ − conj I₃`, hence `Im(I₃) = πZ` given `∮ = 2πiZ` — is proved
  unconditionally.

  **This gap is now filled, in general form, across four modules** (journal items
  J8 and its Weierstrass follow-up):

  * `Rh45/ArgumentPrinciple.lean`: the rectangle winding number
    `∮_{∂R} (s−a)⁻¹ = 2πi` for `a` strictly inside and `= 0` for `a` outside,
    the product rule `logDeriv_prod_pow`, and the factorised argument principle
    `argument_principle_factorized` (hypothesis: `f =ᶠ[𝓝 s] C · ∏ (s−z)^(m z)`);
  * `Rh45/Weierstrass.lean`: **`exists_factorization`** removes that hypothesis —
    an analytic `f` whose only zeros on the closed rectangle are the finite set `Z`
    (interior, orders `m`) factors as `f = g · ∏_{z∈Z}(s−z)^(m z)` with `g`
    analytic and nowhere zero.  Mathlib has the *local* order factorisation
    (`AnalyticAt.analyticOrderAt_ne_top`) but no gluing over a finite zero set;
    the module builds `g` from the chosen local factors.  Consequently
    `rectBoundary_logDeriv_eq_zero` (`∮_{∂R} g′/g = 0` for zero-free analytic `g`,
    by Cauchy–Goursat) and the **general** rectangle argument principle
    `argument_principle_general`
    (`∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z`, no factorisation hypothesis);
  * `Rh45/RouteBGeneral.lean`: **`routeB_reduction_general`** feeds that into
    Route B, concluding `(rightPath (logDeriv f) t₀ t₁).im = π · ∑_{z∈Z} m z`
    from analyticity of `f`, its zero data, and `f(1−s) = f(s)`, `f(conj s) =
    conj (f s)` — no factorisation hypothesis and no constant `C`.  This
    supersedes `routeB_reduction_factorized` (kept for compatibility).

Two further concrete ingredients, not needed as hypotheses of the abstract
reduction but not present in Mathlib, **are now formalised** in
`Rh45/XiEntire.lean` (see `Rh45/XI_ENTIRE.md`):

* **reality of `ξ`** (`ξ(conj s) = conj (ξ s)`), needed to instantiate
  `logDeriv_one_sub_conj` at `f = ξ`: the underlying reality of
  `completedRiemannZeta₀` (`completedRiemannZeta₀_conj`), together with
  `Gammaℝ_conj`, is proved in `Rh45/XiEntire.lean`;
* **entireness / the removable-singularity extension of `ξ`** at `s = 0, 1`:
  the entire normalisation `xi₀ s = ½ s(s−1)Λ₀(s) + ½` and the identity
  `xi s = xi₀ s` for `s ≠ 0, 1` are proved there, together with
  `xi₀(1−s) = xi₀ s`, `xi₀(conj s) = conj (xi₀ s)`, `Differentiable ℂ xi₀` and
  `logDeriv xi = logDeriv xi₀` off `{0,1}`.  The instantiation
  `xi_routeB_general` then gives Route B at `ξ` itself:
  `(rightPath (logDeriv ξ) t₀ t₁).im = π · ∑_{z∈Z} m z`.

