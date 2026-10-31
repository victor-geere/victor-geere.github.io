# Lean formal core — absolute polarized Hodge-index realization

## Build

```bash
the-final-letter/topics/absolute-polarized-hodge-index-realization/lean/check.sh
```

The eight files are `Rescue`, `Shadow`, `Archimedean`, `Symbol`, `Limit`, `Weil`,
`Hadamard` and `Rectangle`.

The script delegates to [`../../tools/check-lean.sh`](../../tools/check-lean.sh)
and uses the local Mathlib at `~/lean/mathlib4` (Lean 4.34.0). Last run:

```
[check] OK   Rescue.lean (11s)
[check] OK   Shadow.lean (12s)
[check] OK   Archimedean.lean (11s)
[check] OK   Symbol.lean (7s)
[check] OK   Limit.lean (4s)
[check] OK   Weil.lean (4s)
[check] OK   Hadamard.lean (8s)
```

## What is proved

[`Rescue.lean`](Rescue.lean) contains no `sorry`, `axiom` or `admit`.

| Name | Statement |
|---|---|
| `term_nonneg` | `(x - y) log (x / y) ≥ 0` for `x, y > 0`. |
| `kmsForm_nonneg` | The finite KMS form `(1/2) ∑ᵢ ∑ⱼ (pᵢ - pⱼ) log(pᵢ/pⱼ) (aᵢⱼ)²` is non-negative for `pᵢ > 0`. This is the finite Hodge-index theorem of note 03, in the diagonal-state model. |
| `kmsForm_two_nonneg` | The two-point instance, expanded. |
| `compatible_well_defined` | Compatibility of a chain of forms makes the level-wise value independent of the level. |
| `compatible_nonneg` | Under compatibility, non-negativity on every level gives a well-defined non-negative value on the union (Lemma 2.1). |
| `badB_not_compatible` | A level-dependent form on a one-point carrier violates compatibility, so the hypothesis is not vacuous. |
| `hodge_sign_iff` | With `s = -W`, the geometric inequality `s ≤ 0` is Weil positivity `0 ≤ W`. |
| `kmsFormTensor_eq` | The reduced tensor-factor form factorises: `kmsFormTensor p ω a = kmsForm p a * ∑ α, ω α`. |
| `kmsFormTensor_eq_of_sum_one` | With a normalised fibre state (`∑ ω = 1`), the tensor form equals the base form. |
| `kmsFormTensorDelta_eq` | The full Kronecker-delta tensor form equals the reduced tensor form. |
| `kmsFormTensorDelta_eq_kmsForm` | With `ω > 0` and `∑ ω = 1`, the full tensor form satisfies `B(a ⊗ 1, a ⊗ 1) = B(a, a)`. |
| `not_nonneg_of_quadForm_neg` | A negative direction refutes positive semidefiniteness — the finite algebra behind the Gram-matrix rejects. |
| `G2_not_psd` | The rational matrix `!![1, 2; 2, 1]` is not PSD: `(1, -1)` gives `-2`. |
| `two_by_two_pos` | A \(2	imes2\) real symmetric form with `a > 0` and `a c - b² > 0` is positive semidefinite; the algebraic core of the leading-minor interval certificate. |

## Rational shadows (`Shadow.lean`)

| Name | Statement |
|---|---|
| `G4_psd` | The rational Cholesky shadow `G4 = L4 * L4ᵀ` of the certified Gaussian Weil Gram is positive semidefinite. `L4` is the computed Cholesky factor rounded to four decimals; the shadow entries agree with the computed matrix to about `1.6e-5`. |
| `N4_not_psd` | The recorded Gaussian Gram, rounded to five decimals, is not positive semidefinite: the explicit rational vector `v4` gives `v4ᵀ N4 v4 ≈ -0.0408`. |
| `G4_close` | Every entry of `G4` is within `2e-5` of the published rationalised Gram `W4`; combined with `G4_psd`, this is a quantitative shadow certificate. |

These are certificates for the *rational shadows*, not for the analytic Gram
matrices. The approximations are stated in the file. No interval enclosure of
the analytic entries is formalised.

## The archimedean identity (`Archimedean.lean`)

| Name | Statement |
|---|---|
| `digamma_conj` | `ψ(conj z) = conj (ψ z)`, derived from Mathlib's `Complex.Gamma_conj` and derivative conjugation. |
| `arch_contour_identity` | `archSymbol ξ = -(1/2) * weilOmega (ξ + I/2)`, i.e. `Re A_arch(ξ) = -(1/2) Ω(ξ + i/2)`, with `A_arch(ξ) = (1/2)(log π - ψ(-iξ/2))` and `Ω(z) = Re ψ(1/4 + iz/2) - log π`. |
| `archSymbol_even` | `archSymbol (-ξ) = archSymbol ξ`: the archimedean symbol is even, from `digamma_conj`. |
| `weilOmega_neg_conj` | `Ω(-z) = Ω(conj z)`: the Weil factor's reflection is conjugation, not evenness in complex `z`. |

This is the identity behind the archimedean sign correction of notes 38–39.
It is now Lean-checked, unconditionally, against Mathlib's `Complex.digamma`.
The only analytic input is the Schwarz reflection of `Γ`, which Mathlib
provides; the rest is the contour algebra that caused the earlier errors.

## The symbol identity (`Symbol.lean`)

| Name | Statement |
|---|---|
| `completedZeta` | `Z(s) = exp(-(s/2) log π) Γ(s/2) ζ(s)`. |
| `logDeriv_exp_factor` | `logDeriv (fun z => exp(-(z/2)L)) s = -(1/2)L`. |
| `logDeriv_gamma_half` | `logDeriv (fun z => Γ(z/2)) s = (1/2) ψ(s/2)`. |
| `logDeriv_completedZeta` | `logDeriv Z s = -(1/2)log π + (1/2)ψ(s/2) + logDeriv ζ s`. |
| `symbol_identity_continued` | For `s ≠ 1`, `Γ(s/2) ≠ 0`, `ζ(s) ≠ 0`: `(1/2)log π - (1/2)ψ(s/2) - ζ'/ζ(s) = -logDeriv Z s`. This is the identity with the *continued* prime symbol, and it applies on the imaginary axis wherever `ζ ≠ 0`. |
| `symbol_identity` | For `1 < re s`: `(1/2)log π - (1/2)ψ(s/2) + L_Λ(s) = -logDeriv Z s`, i.e. `A_arch + Q = -Z'/Z` with `Q` the von Mangoldt L-series. |
| `completedZeta_eq_completedRiemannZeta` | Away from `s = 0` and the Gamma poles, our `Z(s)` equals Mathlib's `completedRiemannZeta s`. |
| `completedZeta_one_sub` | **The functional equation**: `Z(1 - s) = Z(s)` (away from `0`, `1` and the Gamma poles), from Mathlib's `completedRiemannZeta_one_sub`. |
| `completedZeta_zero_symm` | `Z(s) = 0 ⇒ Z(1 - s) = 0`. |
| `completedZeta_zero_symm'` | `Z(1 - s) = 0 ⇒ Z(s) = 0`. |
| `completedZeta_zero_pair` | a zero with `s ≠ 1 - s` has a distinct partner `1 - s`. |
| `gammaR_critical_line_ne_zero` | `Gammaℝ` is nonzero at `1/2 + it`. |
| `completedZeta_critical_line` | **critical-line symmetry**: `Z(1/2 + it) = Z(1/2 - it)` for real `t`. |
| `completedZeta_critical_line_zero_iff` | a zero at `1/2 + it` iff a zero at `1/2 - it`. |
| `logDeriv_completedRiemannZeta_one_sub` | **log-derivative antisymmetry**: `(Z'/Z)(1-s) = -(Z'/Z)(s)` for `s ≠ 0, 1`. |
| `completedZeta_conj` | **conjugation symmetry**: `Z(conj s) = conj (Z s)`, so the zero set is conjugation-stable. |
| `completedZeta_zero_conj` | a zero at `s` gives a zero at `conj s`; the explicit-formula zero sum is real. |
| `completedZeta_ofReal_im_zero` | `Z` is real on the real axis: `(Z x).im = 0` for real `x`. |
| `completedZeta_ne_zero_of_one_lt_re` | `Z` has no zeros on `Re s > 1` (the Euler-product half-plane). |
| `completedZeta_ne_zero_of_re_lt_zero_of_not_trivial` | no nontrivial zero with `Re s < 0`. |
| `completedZeta_ne_zero_of_one_le_re` | no zero on `Re s ≥ 1`, away from the pole at `1`. |
| `completedZeta_ne_zero_of_re_eq_zero` | no zero on the imaginary axis, except the pole at `0`. |
| `completedZeta_zero_re_open_strip` | **nontrivial zeros lie in the open critical strip** `0 < Re s < 1`. |
| `completedZeta_trivial_zero` | the trivial zeros: `Z(-2(n+1)) = 0`. |
| `completedZeta_eq_zero_iff_zeta` | in the critical strip, `Z(s) = 0 ↔ ζ(s) = 0`. |
| `RiemannHypothesis` | the exact RH target: every zero of `Z` in the strip has `Re s = 1/2`. Not proved. |
| `riemannHypothesis_iff_zeta` | the `ζ`-form and completed-zeta form of RH agree in the strip. |
| `riemannHypothesis_iff_critical_line` | RH is equivalent to: every strip zero lies on `1/2 + iℝ`. |
| `logDeriv_completedRiemannZeta_critical_line` | `(Z'/Z)(1/2-it) = -(Z'/Z)(1/2+it)`. |

This is the full `ζ`/`Γ` half of the normalization dictionary. The
convergence-half-plane form (`symbol_identity`) uses the von Mangoldt
L-series; the continued form (`symbol_identity_continued`) uses `-ζ'/ζ` and
holds at every `s` with `s ≠ 1`, `Γ(s/2) ≠ 0` and `ζ(s) ≠ 0`, including
points of the imaginary axis. **Nonvanishing of `ζ` on the imaginary axis is
a hypothesis, not proved in Lean here.** Nothing is asserted on the critical
line beyond what those hypotheses give.

## What is *not* formalised

These are the parts of notes 37–39 that remain text proofs, computations, or
open problems. They must not be cited as Lean-checked:

- the continuation of `symbol_identity` from `re s > 1` to the critical
  line; the identity itself is now Lean-checked;
- the Riemann–Weil explicit formula in any form — analytic;
- the numerical Gram matrices (Gaussian, compact-support, multiplicative
  Gaussian) and their eigenvalues — floating-point computation;
- the Bost–Connes compatibility itself — the Lean lemma says what
  compatibility *implies*, not that the Bost–Connes forms satisfy it;
- the sign crossover of `multiplicative_gaussian_gram` — numerical.

The rational-shadow (including its quantitative bound), archimedean-identity
and full tensor-factor targets of the previous rounds are now done. The
remaining formalisation targets are:

1. an interval enclosure of one **analytic** Gram entry, with a proved
   remainder bound for the digamma integral (the current `G4_close` bounds the
   shadow against a rationalised target, not against the analytic integral);
2. the continuation of `symbol_identity` to the critical line, which is where
   the `-Ω` versus `+Ω` question lives;
3. the actual Bost–Connes level inclusions; the Lean work covers the
   finite tensor-factor case and the compatibility lemma, not the BC algebra.

[Back to the dossier](../README.md) · [Rescue](../notes/38-rescue.md)

## Inductive limit (`Limit.lean`)

| Name | Statement |
|---|---|
| `limit_well_defined` | On a chain of subspaces, two presentations of the same vector at levels `n` and `m` give the same value for compatible forms. This is the compatibility-only core of Lemma 2.1 (note 34): no uniform bound is needed. |
| `limit_nonpos` | Non-positivity on every level transfers to the level-wise value. |
| `limitForm` | The limit form on the union `⋃ₙ Vₙ`, defined by choosing a level via `Submodule.mem_iSup_of_chain`. |
| `limitForm_eq_level` | The limit form agrees with the level form at any level containing the vector. |
| `limitForm_nonpos` | The limit form is non-positive when every level form is. |

## The explicit-formula signs (`Weil.lean`)

| Name | Statement |
|---|---|
| `pole_term_nonneg` | the pole term `∫_{−2}^{2} h(x) cosh(x/2) dx` is non-negative for `h ≥ 0`. |
| `prime_term_nonpos` | the prime sum `−2 ∑_{n<N} Λ(n)/√n · h(log n)` is non-positive for `h ≥ 0`. |

## Hadamard milestone 1 (`Hadamard.lean`)

| Name | Statement |
|---|---|
| `weierstrassFactor` | \(E_p(z)=(1-z)\exp(\sum_{k=1}^{p}z^k/k)\). |
| `weierstrassFactor_eq_zero_iff` | \(E_p(z)=0\iff z=1\). |
| `finiteCanonicalProduct` | \(z\mapsto\prod_{w\in S}E_p(z/w)\). |
| `finiteCanonicalProduct_eq_zero_iff` | for \(0\notin S\), the finite product vanishes exactly on \(S\). |
| `hasDerivAt_weierstrassFactor` | the derivative of \(E_p\). |
| `deriv_weierstrassFactor` | the `deriv` form. |
| `logDeriv_weierstrassFactor` | \(E_p'/E_p(z)=-1/(1-z)+\sum_{k=0}^{p-1}z^k\) for \(z\ne1\). |
| `one_sub_mul_sum_range_pow` | the telescoping identity \((1-z)\sum_{k<p}z^k=1-z^p\). |
| `deriv_weierstrassFactor'` | the compact derivative form \(E_p'(z)=-z^p e^{S_p(z)}\). |
| `norm_weierstrassSum_le_one` | for \(\lVert w\rVert\le1/2\), \(\lVert S_p(w)\rVert\le1\). |
| `norm_cexp_weierstrassSum_le_exp_one` | on the path \(t\mapsto tz\), \(t\in[0,1]\), \(\lVert e^{S_p(tz)}\rVert\le e\). |
| `hasDerivAt_weierstrassPath` | the derivative of \(t\mapsto E_p(tz)\) along the real line. |
| `norm_weierstrassFactor_sub_one_le` | **convergence bound**: for \(\lVert z\rVert\le1/2\), \(\lVert E_p(z)-1\rVert\le e\,\lVert z\rVert^{p+1}\). |
| `norm_weierstrassFactor_div_sub_one_le` | in terms of the zero: \(\lVert E_p(z/a)-1\rVert\le e\lVert z\rVert^{p+1}/\lVert a\rVert^{p+1}\). |
| `summable_weierstrassFactor_sub_one` | if \(2\lVert z\rVert\le\lVert a_n\rVert\) and \(\sum\lVert z\rVert^{p+1}/\lVert a_n\rVert^{p+1}<\infty\), then \(\sum(E_p(z/a_n)-1)\) converges. |
| `summable_norm_weierstrassFactor_sub_one` | the norm-summable version. |
| `multipliable_weierstrassFactor` | **the infinite canonical product converges**: \(\prod_n E_p(z/a_n)\) is multipliable. |
| `hasProd_weierstrassFactor` | the `HasProd` form. |
| `logDeriv_finiteCanonicalProduct` | \(P_S'/P_S(z)=\sum_{w\in S}(1/w)\,E_p'/E_p(z/w)\). |
| `hasProd_weierstrassFactor_zero` | the product takes the value `1` at `z = 0`. |
| `hasProd_weierstrassFactor_at_zero` | the product vanishes at each prescribed zero `a k`. |
| `tprod_weierstrassFactor_ne_zero` | off the zeros, the product is nonzero (log-series route). |
| `hasProdUniformlyOn_weierstrassFactor` | the product converges **uniformly on compact sets** under a summable majorant `e R^(p+1)/‖a n‖^(p+1)`. |
| `analyticOnNhd_tprod_weierstrassFactor` | if the product is a locally uniform limit of its partial products, it is analytic. |
| `tendstoUniformlyOn_weierstrassFactor_closedBall` | uniform convergence on a closed ball. |
| `tendstoLocallyUniformlyOn_weierstrassFactor_ball` | local uniform convergence on the open ball. |
| `symbol_identity_critical_line` | the symbol identity on the **critical line** away from zeros: `s = 1/2 + it`. |
| `symbol_conj` | **conjugation symmetry of the symbol**: `M(conj s) = conj (M s)`. |
| `symbol_conj_critical_line` | **critical-line form**: `M(1/2 - it) = conj (M(1/2 + it))`. |
| `differentiableAt_completedZeta_explicit` | differentiability of the explicit completed-zeta product (enables the functional-equation anti-symmetry). |
| `differentiableAt_Gammaℝ` | `Gammaℝ` is differentiable away from its zeros. |
| `eventually_Gammaℝ_ne_zero` | `Gammaℝ` is nonzero on a neighbourhood of any nonzero point. |
| `logDeriv_completedZeta_one_sub` | **functional-equation anti-symmetry**: `(Z'/Z)(1-s) = -(Z'/Z)(s)`. |
| `completedZeta_critical_line_real` | **reality on the critical line**: `Z(1/2+it)` is real. |
| `completedZeta_critical_line_zero_iff_re` | on the critical line, `Z = 0 ↔ Re Z = 0`. |
| `completedZeta_ofReal_pos` | **\(Z(x)>0\) for \(x>1\)** on the real axis. |
| `HasDerivAt.im_eq_zero` | a real-valued differentiable `f : ℝ → ℂ` has a real derivative. |
| `deriv_completedZeta_critical_line_imaginary` | **\(\operatorname{Re} Z'(1/2+it)=0\)** on the critical line. |
| `circleIntegral_sub_inv_linear` | **base case of the argument principle**: `(2πi)⁻¹ ∮ 1/(z-w) = 1` for a circle enclosing `w`. |
| `circleIntegral_sub_inv_eq_zero` | the outside-zero case: `∮ 1/(z-w) = 0` for `w` outside the closed disk (Cauchy's theorem). |
| `circleIntegral_finset_sum` | **linearity of the circle integral** for finite sums. |
| `circleIntegral_finset_sum_of_continuousOn` | the same with continuity only on the sphere (enough for `(z-w)⁻¹`). |
| `circleIntegral_congr` | the circle integral depends only on the values on the sphere. |
| **`circleIntegral_logDeriv_prod`** | **the argument-principle count**: for roots each strictly inside or outside, `(2πi)⁻¹ ∮ d(log ∏(z-w)) = #(roots inside)`. |
| `logDeriv_sub_const` | the logarithmic derivative of a linear factor: `logDeriv (z - w) = 1/(z - w)`. |
| `logDeriv_eq_inv_add` | **local factorisation at a simple zero**: `f = (z-w)·g` near `z` gives `f'/f = 1/(z-w) + g'/g`. |
| `circleIntegral_add_of_continuousOn` | additivity of the circle integral on the sphere. |
| `circleIntegral_logDeriv_eq_zero` | **zero-free log-derivative integral**: `∮ h'/h = 0` for `h` differentiable and nonzero near the disk. |
| **`circleIntegral_logDeriv_mul_prod`** | **multi-zero count**: if `f = P·h` with `P` the product over roots inside and `h` zero-free, then `∮ f'/f = 2πi·#S`. |
| `logDeriv_inv_comp` | the log-derivative of a reciprocal: `logDeriv (1/f) = -logDeriv f`. |
| `circleIntegral_neg` | negation of the circle integral. |
| **`circleIntegral_logDeriv_simple_zero`** | **local-to-global**: if `f = (z-w)·g` on a neighbourhood of the closed disk with `g` differentiable and nonzero there, then `∮ f'/f = 2πi`. |
| `circleIntegral_logDeriv_prod_eq` | the product count with the `(2πi)⁻¹` absorbed: `∮ d(log ∏(z-w)) = 2πi·#S` for roots inside. |
| **`circleIntegral_logDeriv_simple_pole`** | **argument principle at a simple pole**: if `1/f = (z-p)·k` near the disk with `k` differentiable and nonzero and `p` inside, then `∮ f'/f = -2πi`. |
| **`circleIntegral_logDeriv_div_prod`** | **divisor-form argument principle on a circle**: for `f = P_Z·P_P⁻¹·h` (zeros `Z`, poles `P` inside, `h` zero-free), `∮ f'/f = 2πi·(#Z - #P)`. |
| `riemannZeta_trivial_zero` | **the genuine trivial zeros of zeta**: `ζ(-2m) = 0` for `m ≥ 1`. |
| `riemannHypothesis_iff_no_zeros_left_half` | **RH as the absence of zeros in the left half of the strip**. |
| `Gammaℝ_conj` | conjugation symmetry of `Gammaℝ`. |
| `completedZeta_zero_quadruple` | a zero produces the full quadruple `s, 1-s, conj s, 1-conj s`. |
| `logDeriv_completedZeta_conj` | conjugation symmetry of the completed-zeta log-derivative. |
| `logDeriv_completedZeta_critical_line_imaginary` | **the completed-zeta log-derivative is purely imaginary on the critical line**. |
| `symbol_critical_line_eq_neg_logDeriv` | on the critical line, `M(1/2+it) = -(Z'/Z)(1/2+it)`. |
| `finset_sum_real_of_conj` | a finite sum paired by conjugation is real (via `Finset.sum_bij`). |
| `zero_sum_real_of_finite` | **a finite zero sum is real** for a conjugation-stable zero set and a conjugate-pairing test function. |
| `completedZeta_residue_one` | **the pole residue of the completed zeta at `s = 1` is `1`**, the pole term of the explicit formula. |
| `tendsto_smul_comp_one_sub` | **pole reflection**: if `(u-1)f(u) → 1` as `u → 1`, then `s f(1-s) → -1` as `s → 0`. |
| `completedZeta_residue_zero` | **the pole at `s = 0` has residue `-1`**: `s Z(s) → -1`. |
| `eventually_GammaR_ne_zero_near_zero`, `eventually_GammaR_one_sub_ne_zero_near_zero` | the eventual nonvanishing of `Gammaℝ` near `0` and at `1-s`. |
| `abs_quad_le_row_sum`, `abs_quad_le_row_sum_rat` | row-sum bound for a symmetric quadratic form, **any finite dimension**. |
| `box_ge`, `box_ge_rat` | box inequality `A ⪰ P` from entrywise bounds and row sums, **any finite dimension**. |
| `posDef_of_box`, `posDef_of_box_rat` | positive definiteness from a box, **any finite dimension**. |
| `ldl_posDef_rat` | an exact rational `L d Lᵀ` with `d > 0` is positive definite, **any finite dimension**. |
| `Pqm_posDef` | `G4 - (1/12500)·1` is positive definite (exact LDLᵀ). |
| **`W4m_posDef`** | **the 4×4 Gaussian Weil Gram shadow `W4` is positive definite**, the finite cone positivity certificate. |
| `P2m_posDef`, **`W2m_posDef`** | the 2×2 rung: the rational centre minus slack and the numerical shadow are positive definite, exercising the general box theorem. |
| `gram_quadFormR_nonneg` | **every finite Gram matrix of an inner product is positive semidefinite**. |
| `gram_quadFormR_pos_iff` | **a finite Gram matrix is positive definite iff the vectors are linearly independent**. |
| `hodge_defect_identity` | **the Hodge defect is a sum of squares**: `(A·D)² - 6D² = 2((a-b)² + (b-c)² + (c-a)²)`. |
| `hodge_index_explicit` | the explicit rank-three Hodge-index inequality `6D² ≤ (A·D)²`. |
| `hodge_defect_eq_zero_iff` | **the Hodge defect vanishes exactly on the ample line** `a = b = c`. |
| `Bint`, `Bint_comm`, `Bint_self`, `Bint_ample_sq`, `Bint_ample_dot` | the explicit rank-three intersection pairing and its numbers (`A² = 6`, `A·D = 2(a+b+c)`, `D² = 2(ab+ac+bc)`). |
| `symbol_antisymm` | **anti-symmetry of the symbol**: `M(1-s) = -M(s)`. |
| `digamma_conj'`, `symbol_conj'`, `symbol_conj_critical_line'` | local forms of the symbol conjugation in `Symbol.lean`. |
| `symbol_critical_line_pure_imaginary` | **the symbol is purely imaginary on the critical line**: `M(1/2+it) = -conj (M(1/2+it))`. |
| `deriv_riemannZeta_conj` | conjugation symmetry of the zeta derivative. |
| `logDeriv_riemannZeta_conj` | conjugation symmetry of the zeta log-derivative. |
| `analyticOnNhd_tprod_weierstrassFactor_ball` | **the infinite product is analytic on the ball** where `2R ≤ ‖a n‖`; the whole chain (`hasProdUniformlyOn`, `tendstoUniformlyOn`, `tendstoLocallyUniformlyOn`, `analyticOnNhd`) is stated for an **arbitrary index type**. |
| `Jensen_finiteCanonicalProduct` | **Jensen's formula** for the finite canonical product (circle average = divisor sum + `log ‖P_S 0‖`). |
| `sum_divisor_finiteCanonicalProduct_le` | **Jensen's inequality** (zero counting) for the finite canonical product. |
| `sum_divisor_le_two_mul` | zero counting in radius `r`: divisor sum `≤ log (M / ‖f 0‖) / log 2`, with `M` bounding `f` on the sphere of radius `2r`. |
| `exists_const_of_re_le` | an entire function whose real part is bounded above is constant (bounded-real-part Liouville / simplest Borel–Carathéodory). |
| `eq_affine_of_deriv_bounded` | an entire function with bounded derivative is affine. |
| `eq_affine_of_re_le_linear` | **linear real-part growth implies affine**: \(\operatorname{Re} g(z)\le A\lVert z\rVert+B\) with \(A\ge0\) gives \(g(z)=a+bz\), via Borel–Carathéodory and the Cauchy estimate. |
| `exists_differentiable_cexp_univ` | **global zero-free logarithm**: an entire function with no zeros is `exp g`, with `g` entire. |
| `meromorphicOrderAt_weierstrassFactor_one` | the elementary factor has a simple zero at `1`: `meromorphicOrderAt E_p 1 = 1`. |
| `meromorphicOrderAt_weierstrassFactor_of_ne_one` | away from `1`, the elementary factor has order `0`. |
| `meromorphicOrderAt_weierstrassFactor` | the full divisor: `meromorphicOrderAt E_p z = if z = 1 then 1 else 0`. |
| `meromorphicOrderAt_weierstrassFactor_div` | the scaled factor `z ↦ E_p(z/w)` has order `1` at `w`, `0` elsewhere. |
| `meromorphicOrderAt_finiteCanonicalProduct` | **finite-product divisor**: the order at `u` is the number of prescribed zeros equal to `u`. |
| `meromorphicOrderAt_finiteCanonicalProduct_self` | at a prescribed zero, the order is exactly `1`. |
| `meromorphicOrderAt_finiteCanonicalProduct_of_not_mem` | away from the prescribed zeros, the order is `0`. |
| `meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero` | an analytic function with nonzero value has meromorphic order `0` (general tool for the infinite product). |
| `multipliable_tail_weierstrassFactor` | **the tail product at a zero converges** (index type generalised to the complement of one point). |
| `tprod_tail_weierstrassFactor_ne_zero` | **the tail product is nonzero at the zero**. |
| `analyticOnNhd_tprod_tail_weierstrassFactor` | **the tail product is analytic on a ball** around the removed zero. |
| `tprod_weierstrassFactor_eq_mul_tail` | **split the infinite product at one factor**: `∏' n, E_p(z/a n) = E_p(z/a k) * ∏' n ≠ k, E_p(z/a n)` (subtype transport by `Equiv.hasProd_iff`). |
| `tprod_weierstrassFactor_eq_mul_tail_on_ball` | the split holds for every `z` in the disk where `2R ≤ ‖a n‖` (including `z = 0`). |
| `tprod_weierstrassFactor_eq_mul_tail_of_ne` | the split with the decay bound only **off** `k`: this reaches the zero. |
| `tprod_weierstrassFactor_eq_mul_tail_on_tailBall` | the split holds on the **tail ball** (bound only off `k`), which can contain `a k`. |
| `meromorphicOrderAt_tprod_weierstrassFactor_at_zero` | **the infinite product has a simple zero at each prescribed zero** (under separation and distinctness). |
| `meromorphicOrderAt_div_eq_zero_of_eq` | if two meromorphic functions have the same **finite** order at a point, their quotient has order `0` there. |
| `analyticAt_of_meromorphicNFAt_order_nonneg` | a meromorphic function in normal form with nonnegative order is analytic. |
| `ne_zero_of_meromorphicNFAt_order_eq_zero` | a meromorphic function in normal form with order `0` is nonzero. |
| `exists_entire_zeroFree_quotient` | **the quotient normal form is entire and zero-free**: if `f` and `P` are meromorphic everywhere with the same finite orders, then `f/P` extends to an entire zero-free function. |
| `eventually_two_mul_le_norm` | if the reciprocal-power majorant is summable and the zeros are nonzero, then `2R ≤ ‖a n‖` eventually — the gateway to the global analyticity of the canonical product. |
| `hasProd_range` | the finite initial product `∏ n ∈ range N` as a `HasProd` over the subtype. |
| `complRangeEquiv` | the equivalence `ℕ ≃ {n // n ∉ range N}`, `m ↦ N + m`, for reindexing the tail. |
| `tprod_eq_prod_range_mul_tprod_shift` | **split at a finite initial segment**: `∏' f = (∏ n < N, f n) * ∏' m, f (N+m)`. |
| `analyticOnNhd_tprod_weierstrassFactor_ball_shift` | the reindexed tail product is analytic on the ball when the tail satisfies the global decay bound. |
| `analyticOnNhd_tprod_weierstrassFactor_of_eventually` | the product is analytic on the ball when the zeros **eventually** satisfy `2R ≤ ‖a n‖`. |
| `differentiable_tprod_weierstrassFactor` | **the canonical product is entire** under nonzero zeros and summability of the reciprocal-power majorant. |
| `quotient_nf_eventuallyEq` | the quotient normal form agrees with `f / P` on the punctured neighbourhood of `0`. |
| `eventual_eq_mul_quotientNF` | `P · Q` agrees with `f` eventually at `0`. |
| `eq_mul_quotientNF` | **global identity `f = P · Q`** for `Q` the entire normal form of `f/P`. |
| `exists_factorization_of_divisor_match` | **Hadamard factorisation (quotient form)**: if the canonical product's divisor matches the finite-order divisor of `f`, then `f = P · exp g` with `g` entire. |
| `re_eq_log_norm_of_cexp` | \(\operatorname{Re} g = \log\lVert e^g
Vert\). |
| `exists_affine_factorization` | **affine form**: given `f = P·exp g` and a linear bound on `Re g`, the exponent is affine. |
| `exists_affine_factorization_of_log_growth` | given `f = P·Q`, `Q = exp g`, and a linear bound on `log ‖Q‖`, the exponent is affine. |
| `exists_affine_factorization_of_divisor_match` | **order-1 Hadamard factorisation (conditional)**: divisor match plus linear log-growth of the quotient gives `f = P · exp (a + bz)`. |
| `HasLogGrowthOne` | the order-at-most-one log-growth property `log ‖f z‖ ≤ A‖z‖ + B`, `A ≥ 0`. |
| `hasLogGrowthOne_const`, `hasLogGrowthOne_cexp_affine` | constants and exponentials of affine functions satisfy it. |
| `exists_affine_factorization_of_logGrowthOne` | the conditional order-1 factorisation with the log-growth hypothesis named. |
| `hasLogGrowthOne_mul_cexp_affine` | multiplying a zero-free order-1 function by an affine exponential preserves `HasLogGrowthOne`. |
| `hasLogGrowthOne_cexp_of_re_le` | linear growth of `Re g` gives `HasLogGrowthOne (exp g)`. |
| `hasLogGrowthOne_mul` | the product of two zero-free order-1 functions is order-1. |
| `hasLogGrowthOne_finset_prod` | finite products of zero-free order-1 functions are order-1. |
| `hasLogGrowthOne_id` | the identity function has order-1 log-growth (`log r ≤ r`). |
| `hasLogGrowthOne_affine` | every affine function `z ↦ a + bz` has order-1 log-growth. |
| `hasLogGrowthOne_pow` | every power `z ↦ z^n` has order-1 log-growth. |
| `hasLogGrowthOne_const_mul` | multiplying an order-1 function by a nonzero constant preserves the property. |
| `hasLogGrowthOne_add_of_ne_zero` | the sum of two zero-free order-1 functions (itself zero-free) is order-1. |
| `hasLogGrowthOne_comp_affine` | affine reparametrisation `z ↦ Q(a + bz)` preserves order-1 log-growth. |
| `HasLogGrowthOneNonneg` | order-1 log-growth with a nonnegative constant, closed under products without zero-freeness. |
| `HasLogGrowthOneNonneg.finset_prod` | finite products of `HasLogGrowthOneNonneg` functions are `HasLogGrowthOneNonneg`. |
| `hasLogGrowthOne_finiteCanonicalProduct_zero` | **the genus-0 finite canonical product is order-1** (a finite product of linear factors). |
| `HasLogGrowthOne.pow` | powers of an order-1 function are order-1 (no zero-free hypothesis). |
| `hasLogGrowthOne_div_of_lower_bound` | dividing an order-1 function by a bounded-below function preserves the property. |
| `hasLogGrowthOne_add_const` | adding a constant preserves order-1 log-growth. |
| `hasLogGrowthOne_const_mul_finiteCanonicalProduct_zero` | constants times genus-0 finite canonical products are order-1. |
| `HasLogGrowthOneNonneg.congr` | transport of the nonnegative-constant order-1 property. |
| `hasLogGrowthOne_finiteCanonicalProduct_one` | **the genus-1 finite canonical product is order-1** (each factor `(1-z/w)·exp(z/w)`). |
| `HasLogGrowthOne.congr` | transport of `HasLogGrowthOne` along pointwise equality. |
| `multiset_prod_linear_hasLogGrowthOneNonneg` | multiset products of linear factors `z - a` are order-1. |
| `polynomial_hasLogGrowthOne` | **every complex polynomial has order-1 log-growth**. |
| `polynomial_mul_cexp_affine_hasLogGrowthOne` | a polynomial times an affine exponential is order-1 (consistency with the factorised form). |
| `exists_norm_le_of_re_le_linear` | **Borel–Carathéodory, linear bound**: `Re g(z) ≤ A‖z‖+B` gives `‖g z‖ ≤ C(1+‖z‖)`. |
| `exists_affine_cexp_of_zeroFree_logGrowth` | **zero-free order-1 theorem**: a zero-free entire function with `HasLogGrowthOne` is `exp (a + bz)`. |
| `exists_affine_factorization_of_zeroFree_quotient` | **final assembly**: `f = P·Q` with `Q` zero-free order-1 gives `f = P · exp (a + bz)`. |
| `eq_const_of_deriv_eq_zero_ball` | a holomorphic function on a ball with zero derivative is constant. |
| `hasDerivAt_mul_cexp_neg_of_logDeriv` | if `G' = f'/f` and `f ≠ 0`, then `f * exp(-G)` has zero derivative. |
| `const_mul_cexp_neg_of_primitive` | `f * exp(-G)` is constant on a ball when `G' = f'/f`. |
| `exists_cexp_of_primitive` | zero-free differentiable logarithm on a ball, given a primitive: `f = exp (G + c₀)`. |
| `exists_differentiable_cexp_ball` | **unconditional zero-free differentiable logarithm**: a holomorphic zero-free function on a ball is `exp g`. |

Part of the zero-side Hadamard project (note 50); the infinite product and
the factorisation theorem are later milestones.

## The rectangle contour (`Rectangle.lean`)

| Name | Statement |
|---|---|
| `rectIntegral` | the boundary integral over `[x₁,x₂] × [y₁,y₂]` (bottom − top + I·right − I·left). |
| `rectIntegral_add`, `rectIntegral_neg`, `rectIntegral_congr` | additivity, negation and congruence of the boundary integral. |
| `rectIntegral_eq_zero_of_differentiableOn` | **rectangle Cauchy–Goursat**: continuous on the closed rectangle, complex differentiable inside ⇒ `∮ = 0`. |
| `rectIntegral_logDeriv_eq_zero` | **zero-free log-derivative integral**: `∮ h'/h = 0` around the rectangle. |
| `integral_inv_horizontal` | `∫ dx/(x+iy-w) = log(x₂+iy-w) - log(x₁+iy-w)` for `y ≠ Im w`. |
| `integral_inv_vertical` | the right vertical side via the principal logarithm. |
| `integral_inv_vertical_left` | the left vertical side via the branch `log (w-z)`. |
| `log_neg_of_im_pos`, `log_neg_of_im_neg` | **branch corrections** `log(-q) = log q ∓ πi` for `±Im q > 0`. |
| **`rectIntegral_inv_of_mem`** | **rectangle winding integral**: `∮ dz/(z-w) = 2πi` for `w` strictly inside. |
| **`rectIntegral_inv_of_not_mem`** | `∮ dz/(z-w) = 0` for `w` outside the closed rectangle. |
| `rectBoundarySet` | the boundary of the rectangle (closed-rectangle points on a side). |
| `rectIntegral_add_boundary`, `rectIntegral_congr_boundary`, `rectIntegral_finset_sum_boundary` | linearity, congruence and finite sums with continuity only on the boundary. |
| **`rectIntegral_logDeriv_prod_eq`** | **product count**: `∮ d(log ∏(z-w)) = 2πi·#S` for roots strictly inside. |
| **`rectIntegral_logDeriv_div_prod`** | **divisor-form argument principle on a rectangle**: `f = P_Z·P_P⁻¹·h` with `Z`, `P` strictly inside and `h` differentiable zero-free near the rectangle ⇒ `∮ f'/f = 2πi·(#Z − #P)`. |

| `AnalyticAt.exists_eventuallyEq_sub_mul` | **local factorisation at a simple zero**: `f` analytic, `f w = 0`, `f' w ≠ 0` ⇒ near `w`, `f = (z-w)·g` with `g` analytic and `g w ≠ 0`. |

| `rectIntegral_eq_zero_of_differentiable_on_off_countable` | **Cauchy–Goursat off a countable set** on a rectangle. |

| `polyProd`, `deriv_polyProd_mem`, `prod_erase_ne_zero` | the monic polynomial with root set `S`; its derivative at a root is the product of the differences, which is nonzero. |
| `quotientExtension` | `f/polyProd S` off `S` with the removable value at `S`. |
| `analyticAt_quotientExtension_of_mem`, `differentiableOn_quotientExtension`, `quotientExtension_ne_zero` | the quotient extension is analytic on the open set, and zero-free there. |
| **`rectIntegral_logDeriv_eq_card_of_simple_zeros`** | **argument principle for analytic functions with simple zeros**: `∮ f'/f = 2πi·#S` when the zeros in `U` are exactly the simple set `S`. |
| **`rectIntegral_logDeriv_completedZeta_eq_card`** | **zero side of the explicit formula**: `∮ Z'/Z = 2πi·(#S − 2)` over the rectangle. |

| `rectIntegral_const_mul` | constants pull out of the rectangle integral. |
| **`rectIntegral_logDeriv_eq_sum_multiplicity`** | **argument principle with multiplicities**: `f = (∏(z-w)^{m w})·q`, `q` zero-free ⇒ `∮ f'/f = 2πi·∑ m`. |
| **`rectIntegral_logDeriv_completedZeta_eq_sum`** | **zero side with multiplicities**: `∮ Z'/Z = 2πi·(∑ m − 2)` for a factorisation of `s(s-1)Z` with zero-free quotient. |

| `polyProdPow`, `quotientExtensionPow` | roots with multiplicities; the quotient extension at a zero set with multiplicities. |
| `exists_eventuallyEq_pow_mul_of_order` | the local factor `f = (z-w)^m·g` from `analyticOrderNatAt f w = m`. |
| `differentiableOn_quotientExtensionPow`, `quotientExtensionPow_ne_zero` | the multiplicity quotient extension is analytic and zero-free. |
| **`rectIntegral_logDeriv_eq_divisor_sum`** | **argument principle from the analytic order**: zeros exactly `S` with orders `m w > 0` ⇒ `∮ f'/f = 2πi·∑ m`. |
| **`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`** | **zero side from order data**: `∮ Z'/Z = 2πi·(∑ m − 2)`. |

## The prime side (`ExplicitFormula.lean`)

| Name | Statement |
|---|---|
| `norm_natCast_cpow_vertical` | on a vertical line, `‖n^{-(c+iy)}‖ = n^{-c}`. |
| `continuous_natCast_cpow_vertical`, `continuous_lseriesTerm` | continuity of the vertical power and of an L-series term. |
| `summable_vonMangoldt_majorant` | `Σ ‖Λ(n)n^{-c}‖ < ∞` for `c > 1`. |
| **`integral_lseries_vonMangoldt`** | **term-by-term integration**: `∫_{y₁}^{y₂} L_Λ(c+iy) dy = Σ' n, ∫_{y₁}^{y₂} Λ(n)n^{-(c+iy)} dy`. |

| `hasDerivAt_natCast_cpow_vertical` | derivative of `y ↦ n^{-(c+iy)}`. |
| **`integral_natCast_cpow_vertical`** | `∫_{y₁}^{y₂} n^{-(c+iy)}dy = i(n^{-(c+iy₂)} - n^{-(c+iy₁)})/log n`. |
| `integral_lseriesTerm_vonMangoldt` | the term integral, vanishing for `n ≤ 1`. |
| **`integral_lseries_vonMangoldt_closed`** | **prime side in closed form**: `∫ L_Λ(c+iy)dy = Σ' n, iΛ(n)(n^{-(c+iy₂)} - n^{-(c+iy₁)})/log n`. |

| **`integral_logDeriv_completedZeta_right_side`** | **right vertical side**: `∫ (Z'/Z)(c+iy)·i dy = i·(∫ arch − Σ′ term_n)` for `c > 1`, conditional on interval integrability. |

| `continuousOn_lseries_vonMangoldt`, `continuousOn_logDeriv_completedZeta` | continuity of the two integrands on a vertical line with `Re s > 1`. |
| **`integral_logDeriv_completedZeta_right_side'`** | **unconditional right vertical side** of the contour. |

| **`integral_logDeriv_completedZeta_left_side`** | **left vertical side**: `∫(Z'/Z)((1-x₂)+iy)·i dy = -∫_{-y₂}^{-y₁}(Z'/Z)(x₂+it)·i dt` for `1 < x₂ < 3`. |

| `archSymbol`, `primeSide` | the archimedean symbol and the closed-form prime side. |
| `integral_logDeriv_completedZeta_left_eq_neg_right` | the left side is minus the right side on `[-T,T]`. |
| **`explicit_formula_h1_symmetric`** | **assembly for `h ≡ 1`**: `(Σ m − 2)·2πi = (bottom − top) + 2·(∫ archSymbol − primeSide)·i` on a symmetric rectangle. |

| **`integral_logDeriv_completedZeta_bottom_eq_neg_top`** | **exact horizontal reflection**: `bottom = -top` on a symmetric rectangle. |
| **`explicit_formula_h1_symmetric_exact`** | **assembly with exact horizontal difference**: `(Σ m − 2)·2πi = 2·bottom + 2·(∫ archSymbol − primeSide)·i`. |

| `integral_conj_interval` | conjugation commutes with the interval integral. |
| `integral_logDeriv_completedZeta_bottom_eq_conj_top` | `bottom = conj(top)`. |
| **`integral_logDeriv_completedZeta_top_pure_imaginary`** | `top = −conj(top)`, i.e. the top side is purely imaginary. |

| `divisor_openRect_support_finite`, `divisor_openRect_support_subset`, `analyticOrderNatAt_eq_divisor_toNat` | finiteness, location and values of the divisor support on an open rectangle. |
| **`rectIntegral_logDeriv_eq_divisor_sum_of_analytic`** | **argument principle from the divisor**: the zero set and multiplicities are derived from `f`; `∮ f'/f = 2πi·∑ div(w)`. |

| **`rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`** | **zeta zero side from the divisor**: `∮ Z'/Z = 2πi·(∑ div − 2)` with the zeros derived from Mathlib's divisor. |

| **`explicit_formula_h1_symmetric_divisor`** | **full `h ≡ 1` explicit formula**: `(∑ div − 2)·2πi = 2·bottom + 2·(∫ archSymbol − primeSide)·i`, zero side derived from the divisor. |

| `integral_logDeriv_completedZeta_bottom_pure_imaginary` | the bottom horizontal side is purely imaginary too. |

| **`rectIntegral_mul_inv_sub_eq`** | **Cauchy integral formula on a rectangle**: `∮ h(z)/(z-a) dz = 2πi·h(a)` for `a` strictly inside. |

| **`tendsto_sub_mul_logDeriv_of_simple_zero`** | **simple-zero residue**: `(s-ρ)·f'/f → 1` for `f` analytic at `ρ`, `f ρ = 0`, `f' ρ ≠ 0`. |
| `tendsto_sub_mul_logDeriv_completedZeta_zero` | zeta instance: the residue of `Z'/Z` at a simple zero is `1`. |

| **`tendsto_sub_mul_logDeriv_of_simple_pole`** | **simple-pole residue**: `f = F/(s-p)` with `F` analytic, `F p ≠ 0` ⇒ `(s-p)·f'/f → −1`. |

| `poleExtensionOne`, `poleExtensionZero`, `analyticAt_poleExtensionOne`, `analyticAt_poleExtensionZero` | the residues of `Z` at `1` and `0` used to extend `(s-1)Z` and `sZ` analytically. |
| **`tendsto_sub_mul_logDeriv_completedZeta_pole_one`**, **`tendsto_mul_logDeriv_completedZeta_pole_zero`** | the residues of `Z'/Z` at the poles `1` and `0` are `-1`. |

| **`exists_analyticAt_logDeriv_mul_sub_residue`** | **local residue subtraction**: analytic germ at a simple zero agreeing off `ρ` with `(f'/f)·h − h(ρ)/(s−ρ)`, witness `dslope h ρ + h·logDeriv g`. |

| **`exists_analyticAt_logDeriv_mul_add_residue_pole`** | **local pole subtraction**: germ `h·logDeriv F − dslope h p` agrees off `p` with `(f'/f)·h + h(p)/(s−p)`. |
| `exists_analyticAt_logDeriv_completedZeta_add_residue_pole_one`, `..._pole_zero` | zeta instances at the poles `1` and `0`. |

| **`rectIntegral_sum_const_inv_sub`** | **residue sum**: `∮ ∑_{w∈S} c(w)/(z-w) dz = (∑_{w∈S} c(w))·2πi` for `S` strictly inside. |

| **`rectIntegral_logDeriv_mul_eq_residue_sum`** | **residue assembly**: boundary decomposition `(Z'/Z)·h = ψ + ∑ c(w)/(z−w)` with `∮ψ = 0` ⇒ `∮(Z'/Z)·h = (∑ c(w))·2πi`. |

| **`logDeriv_completedZeta_eq_logDeriv_poleExtension`** | **pole-free form**: `Z'/Z = F'/F − 1/s − 1/(s−1)` for `F = s(s−1)Z`; reduces the global remainder to `h·F'/F − Σ h(ρ)/(s−ρ) − dslope h 0 − dslope h 1`. |

| **`exists_analyticOnNhd_of_differentiableOn_compl_finset`** | **finite patching**: analytic germs at a finite set of points combine into an analytic extension on the whole open set. |

| `differentiableAt_dslope_of_analyticAt`, `differentiableAt_logDeriv_of_analyticAt` | differentiability of the divided slope and of the log-derivative of a nonzero analytic function. |
| **`differentiableOn_globalRemainder`** | the global remainder `h·F'/F − ∑ h(ρ)/(s−ρ) − dslope h 0 − dslope h 1` is differentiable on `U ∖ S`. |

| `analyticAt_dslope_of_analyticAt`, `analyticAt_finset_sum` | analyticity of the divided slope and of finite sums. |
| **`exists_analyticOnNhd_globalRemainder`** | the global remainder has an analytic extension on `U` agreeing with it off the zero set `S`. |

| **`logDeriv_mul_eq_remainder_plus_residues`** | **boundary decomposition**: `Z'/Z·h = (remainder) + ∑ h(ρ)/(z-ρ) - h(0)/z - h(1)/(z-1)`. |

| **`test_function_explicit_formula`** | **test-function explicit formula (zero side)**: `∮ (Z'/Z)·h = 2πi(∑_ρ h(ρ) − h(0) − h(1))`. |

| `test_function_explicit_formula_linear` | the test-function formula for `h(s) = s`: `∮ (Z'/Z)·s = 2πi(∑ ρ − 1)`. |

| **`logDeriv_mul_I_eq_neg_arch_add_prime`** | **pointwise prime side with a test function**: `Z'/Z·h·i = −(arch·h·i + L_Λ·h·i)` on `Re s > 1`. |

| `norm_lseriesTerm_vonMangoldt_le`, **`integral_lseries_vonMangoldt_mul`** | **prime-side termwise integration against a continuous factor**: `∫ L_Λ(c+iy)·h(y) dy = ∑_n ∫ term_n(c+iy)·h(y) dy` for `c > 1`. |

| **`integral_logDeriv_mul_I_eq_neg_arch_prime`** | **integrated prime-side identity**: `∫ Z'/Z·h·i = −∫ arch·h·i − ∫ L_Λ·h·i` on `Re = c > 1`. |

| `AbsoluteHodgeArchimedean.analyticAt_Gamma_of_re_pos`, `differentiableAt_digamma_of_re_pos`, `continuousAt_digamma_of_re_pos` | `Γ` analytic and `ψ` differentiable/continuous on `Re > 0`. |
| `continuousOn_arch_mul` | continuity of the archimedean factor along `Re = c > 1`. |
| **`integral_logDeriv_mul_I_eq_neg_arch_prime'`** | the integrated prime-side identity with the archimedean continuity discharged. |

| `integral_logDeriv_mul_I_eq_neg_arch_prime_const` | the prime-side identity for `h ≡ 1`. |

| **`logDeriv_mul_one_sub`**, **`logDeriv_mul_conj`** | pointwise reflection `Z'/Z(1−s)·h(1−s) = −Z'/Z(s)·h(s)` and conjugation `Z'/Z(conj s)·h(conj s) = conj(Z'/Z(s)·h(s))` for symmetric test functions. |

| **`integral_logDeriv_mul_left_eq_neg_right_two`** | **integrated left reflection for symmetric test functions**: `∫ Φ(−1+iy)·i dy = −∫ Φ(2+iy)·i dy`. |

| **`integral_horizontal_bottom_eq_conj_top_two`** | **integrated horizontal reflection**: `∫ Φ(x-iT) dx = conj(∫ Φ(x+iT) dx)` for conjugation-symmetric `h`. |

| `conj_sub_self_eq`, **`contour_shift_symmetric`** | the contour-shift identity `(Σh − h(0) − h(1))·2πi = 2i·Right − 2i·Im(Top)`. |

| **`contour_shift_symmetric'`** | the contour-shift identity with the two reflection relations **discharged**: `(Σh − h(0) − h(1))·2πi = 2i·Right − 2i·Im(Top)`. |

| `gaussianTest`, `differentiable_gaussianTest`, `gaussianTest_one_sub`, `gaussianTest_conj`, **`contour_shift_gaussian`** | the concrete symmetric test function `exp(-(s-1/2)²/1000)` and its contour-shift identity. |

| `fourierG`, **`fourierG_even`**, **`fourierG_conj`** | the Fourier transform of a function supported on `[-1,1]`, and its evenness/reality symmetries. |

| **`continuous_fourierG`**, **`norm_fourierG_le`** | continuity and `L¹` bound of the Fourier transform `fourierG`. |

| **`integral_lseries_vonMangoldt_fourier`** | **Fourier form of the prime-measure identity**: `∫ L_Λ(c+iy)e^{iuy}dy = ∑_n ∫ term_n(c+iy)e^{iuy}dy`. |

| **`integral_natCast_cpow_vertical_fourier`** | **closed Fourier coefficient**: `∫ n^{-(c+iy)}e^{iuy}dy = [n^{-(c+iy)}e^{iuy}/(i(u−log n))]_{y₁}^{y₂}`. |

| **`integral_lseriesTerm_vonMangoldt_fourier`** | **closed Fourier term**: `∫ term_n(c+iy)e^{iuy}dy = Λ(n)·[n^{-(c+iy)}e^{iuy}/(i(u−log n))]_{y₁}^{y₂}`. |

| **`integral_lseries_vonMangoldt_fourier_closed`** | **full closed Fourier form of the prime measure**: `∫ L_Λ(c+iy)e^{iuy}dy = ∑_n` closed terms. |

| **`integral_logDeriv_mul_I_eq_neg_arch_prime_fourier`** | **Fourier-kernel prime-side identity**: `∫ Z'/Z·e^{iuy}·i = −∫ arch·e^{iuy}·i − ∫ L_Λ·e^{iuy}·i`. |

| `fourierCoeffClosed`, `integral_lseries_vonMangoldt_fourier_closed'`, **`integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed`** | the closed prime Fourier coefficient and the closed Fourier form of the integrated `Z'/Z`. |

| **`digamma_add_conj_critical`**, **`archimedeanTerm_critical_line_real`** | the digamma sum at conjugate points and the realness of the archimedean term on the critical line. |

| **`integral_archimedean_term_real`** | the critical-line archimedean integral is real for real-valued test functions. |

| `fourierCoeffClosed_self`, `fourierCoeffClosed_add` | the closed Fourier coefficient vanishes on degenerate intervals and telescopes over adjacent intervals. |

| **`conj_integral_archimedean_fourier`** | conjugate symmetry of the archimedean Fourier integral on the critical line: `conj ∫ arch·e^{iut} = ∫ arch·e^{−iut}`. |

| **`fourierCoeffClosed_zero`** | `u = 0` consistency: the closed Fourier coefficient specialises to `Λ(n)·(i/log n)(n^{-(c+iy₂)}−n^{-(c+iy₁)})`, the known closed term. |

| `integral_lseries_vonMangoldt_fourier_closed_zero`, `integral_lseries_vonMangoldt_closed_eq_fourier_zero` | `u = 0` consistency: the Fourier prime sum specialises to the established closed prime sum. |

| **`test_function_explicit_formula_quadratic`**, **`contour_shift_quadratic`** | the quadratic symmetric test function `h(s) = (s−1/2)²`: zero side and contour-shift identity. |

| **`test_function_explicit_formula_const`** | constant test function `h ≡ 1`: `∮ Z'/Z = 2πi·(∑ 1 − 2)`. |

| **`integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed_zero`** | the `u = 0` case of the closed Fourier `Z'/Z` identity. |

| **`primeSide_eq_fourier_zero`** | the `h ≡ 1` `primeSide` equals the `u = 0` closed Fourier sum. |

| **`hasDerivAt_neg_inv_sub`**, **`rectIntegral_inv_sq_eq_zero`** | the inverse-square winding integral vanishes: `∮ ((z−a)²)⁻¹ dz = 0` for `a` strictly inside. |

| **`rectIntegral_mul_inv_sq_eq`** | **rectangle derivative Cauchy formula**: `∮ h(z)·((z−a)²)⁻¹ dz = 2πi·h′(a)` for `h` holomorphic near the closed rectangle, `a` strictly inside. |

| **`hasDerivAt_neg_half_inv_sq`**, **`rectIntegral_inv_cube_eq_zero`** | the inverse-cube winding integral vanishes: `∮ ((z−a)³)⁻¹ dz = 0`. |

| **`rectIntegral_completedZeta_mul_inv_sub_eq`**, **`rectIntegral_completedZeta_mul_inv_sq_eq`** | completed-zeta Cauchy and derivative Cauchy instances: `∮ Z/(z−a) = 2πi·Z(a)`, `∮ Z/(z−a)² = 2πi·Z′(a)`. |

| **`fourierG_one_eq`** | closed Fourier transform of the constant: `∫_{−1}^{1} e^{−ixu} du = 2 sin x / x`. |

| **`fourierG_exp_eq`** | Fourier transform of a complex exponential: `∫_{−1}^{1} e^{bu}e^{−ixu}du = (e^{b−ix} − e^{−b+ix})/(b−ix)`. |

| **`fourierG_add`**, **`fourierG_const_mul`** | linearity of the Fourier transform on continuous functions: `fourierG (g+h) = fourierG g + fourierG h`, `fourierG (c·g) = c·fourierG g`. |

| **`fourierG_exp_I_eq`** | Fourier transform of a pure exponential: `∫_{−1}^{1} e^{iau}e^{−ixu}du = 2 sin(a−x)/(a−x)`. |

| **`fourierG_const_eq`**, **`fourierG_const_mul_exp_I_eq`** | constant and scaled-exponential Fourier transforms: `c·2 sin x/x` and `c·2 sin(a−x)/(a−x)`. |

| **`fourierG_cos_eq`** | Fourier transform of a cosine: `∫_{−1}^{1} cos(au)e^{−ixu}du = sin(a−x)/(a−x) + sin(a+x)/(a+x)`. |

| **`fourierG_sub`**, **`fourierG_sin_eq`** | subtraction linearity and the Fourier transform of a sine: `∫_{−1}^{1} sin(au)e^{−ixu}du = i(sin(a+x)/(a+x) − sin(a−x)/(a−x))`. |

| **`fourierG_zero`**, **`fourierG_neg`** | `fourierG 0 = 0` and `fourierG (−g) = −fourierG g`. |

| **`fourierG_finset_sum`** | finite-sum linearity: `fourierG (∑ g_i) = ∑ fourierG g_i`. |

| **`fourierG_congr`** | congruence: functions agreeing on `[-1,1]` have the same Fourier transform. |

| **`fourierG_exp_zero_eq`** | `b = 0` consistency: the exponential transform reduces to `2 sin x/x`. |

| **`fourierG_const_zero`** | the constant transform at `x = 0`: `fourierG (fun _ => c) 0 = 2c`. |

| **`hasDerivAt_antideriv_id_mul_cexp`**, **`fourierG_id_eq`** | Fourier transform of the identity: `∫_{−1}^{1} u·e^{−ixu}du = e^{−ix}(i/x+1/x²) − e^{ix}(−i/x+1/x²)`. |

| **`hasDerivAt_antideriv_sq_mul_cexp`**, **`fourierG_sq_eq`** | Fourier transform of the square: `∫_{−1}^{1} u²e^{−ixu}du = e^{−ix}(i/x+2/x²−2i/x³) − e^{ix}(i/x−2/x²−2i/x³)`. |

| **`fourierG_id_zero`**, **`fourierG_sq_zero`** | values at `x = 0`: `∫_{−1}^{1} u du = 0`, `∫_{−1}^{1} u² du = 2/3`. |

| **`fourierG_modulation`** | modulation: `fourierG (fun u => e^{iau}g(u)) x = fourierG g (x−a)`. |

| **`fourierG_conj_shift`** | conjugation shift: `conj(fourierG g x) = fourierG (conj ∘ g) (−x)`. |

| **`hasDerivAt_antideriv_cube_mul_cexp`**, **`fourierG_cube_eq`** | Fourier transform of the cube: `∫_{−1}^{1} u³e^{−ixu}du`. |

| **`fourierG_cos_zero`**, **`fourierG_sin_zero`** | trigonometric values at `x = 0`: `∫ cos(au) = 2 sin a/a`, `∫ sin(au) = 0`. |

| **`fourierG_cube_zero`** | cube at `x = 0`: `∫_{−1}^{1} u³ du = 0`. |

| **`fourierG_quartic_zero`** | quartic moment at `x = 0`: `∫_{−1}^{1} u⁴ du = 2/5`. |

| **`fourierG_real_conj`** | for real-valued `g`: `conj(fourierG g x) = fourierG g (−x)`. |

| **`hasDerivAt_fourierG`** | differentiation under the integral: `d/dx ĝ(x) = fourierG (fun u => −iu·g(u)) x`. |

| **`deriv_fourierG`**, **`hasDerivAt_fourierG_moment`** | `deriv ĝ x = fourierG (−iu·g)` and the second-order moment correspondence. |

| **`iteratedDeriv_fourierG`** | iterated derivative correspondence: `d^n/dx^n ĝ(x) = fourierG ((−iu)^n g) x`. |

| **`norm_fourierG_le_div`** | quantitative Riemann–Lebesgue decay: `‖ĝ(x)‖ ≤ (‖g(1)‖+‖g(−1)‖+∫‖g'‖)/|x|`. |

| **`tendsto_fourierG_atTop`** | Riemann–Lebesgue lemma: `fourierG g x → 0` as `x → +∞` for `C¹` `g`. |

| **`fourierG_ibp`**, **`norm_fourierG_le_div_sq`** | integration by parts for `fourierG` and the `C²` decay `‖ĝ(x)‖ ≤ A/|x| + B/|x|²`. |

| **`fourierGExt`**, **`fourier_fourierGExt`**, **`integrable_fourierGExt`** | the full-line Fourier bridge: `𝓕 (g_ext) w = fourierG g (2πw)` and integrability of the extension. |

| **`fourier_inversion_conditional`** | Fourier inversion for `fourierG` conditional on integrability of the transform: `𝓕⁻ (𝓕 g_ext) u = g u` for `u ∈ (−1,1)`. |

| **`integrable_fourier_fourierGExt`**, **`fourier_inversion`** | unconditional integrability (endpoint-vanishing `C²`) and the **Fourier inversion theorem** `𝓕⁻ (𝓕 g_ext) u = g u` for `u ∈ (−1,1)`. |

| **`paleyWiener`**, **`paleyWiener_one_sub`**, **`paleyWiener_conj`** | the Paley–Wiener test function `h(s) = ∫_{−1}^{1} g(u)e^{i(s−1/2)u}du`, its symmetry `h(1−s)=h(s)` (even `g`) and conjugation `conj h(s) = h(1−conj s)` (real `g`). |

| **`hasDerivAt_paleyWiener`**, **`differentiable_paleyWiener`**, **`differentiableOn_paleyWiener`** | the Paley–Wiener test function is entire (with its derivative formula). |

| **`contour_shift_paleyWiener`** | the assembled contour-shift identity for the Paley–Wiener test function (finite `T`). |

| **`paleyWiener_one`** | `paleyWiener (fun _ => 1) s = 2 sin(s−1/2)/(s−1/2)` — the classical example. |

| **`paleyWiener_critical_line_real`** | `conj h(1/2+it) = h(1/2+it)` for real `g` and real `t`. |

| **`paleyWiener_kernel_split`** | `e^{i(2+iy−1/2)u} = e^{3iu/2}·e^{−yu}`. |

| **`continuous_logDeriv_completedZeta_line`** | global continuity of `y ↦ Z'/Z(c+iy)` for `c > 1`. |

| **`integral_logDeriv_paleyWiener_swap`** | finite-`T` Fubini swap: `∫_y (Z'/Z)h = ∫_u g e^{3iu/2}·∫_y (Z'/Z)e^{−yu}`. |

| **`integral_lseries_vonMangoldt_exp`** | termwise prime side against `e^{−uy}`: `∫ L_Λ(c+iy)e^{−uy}dy = Σ_n ∫ term_n(c+iy)e^{−uy}dy`. |

| **`natCast_cpow_vertical_eq_exp`** | `n^{-(c+iy)} = n^{-c}·e^{−iy log n}`. |
