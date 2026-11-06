# Handoff — O2: Weil positivity

**Status:** **Partial — advanced (2026-11-05).**  This document scopes the
remaining work on objective **O2** of the
[angular-partition dossier](README.md): the infinite zero sum and Weil
positivity.  It records what is Lean-checked, what is numerical, and the exact
analytic obligations that remain.

**The honesty constraint.**  Unconditional O2 is **RH-equivalent**.  The
programme's own assessment
([`../prime-spectrum-tensor/WEIL-POSITIVITY.md`](../prime-spectrum-tensor/WEIL-POSITIVITY.md) §2)
shows that a uniform lower bound on the Weil form — in particular positivity on
the whole cone — rules out every off-line zero.  So O2 must not be marked closed
without proving the Riemann hypothesis.  The purpose of this handoff is to
advance the *reduction*, not to manufacture a closure.

---

## 0. The object

For the Gaussian bump

```
h_c(v) = √π σ exp(−(v−c)²/(4σ²)),
```

the Weil value is

```
W(c) = 2∫ h_c(u) cosh(u/2) du − 2Π(h_c) + (1/2π)∫ ĝ_c(t) Ω(t) dt
     = pole(c) + density(c) + prime(c),
```

which is `gaussianW c σ` of
[`../prime-spectrum-tensor/lean/GaussianGram.lean`](../prime-spectrum-tensor/lean/GaussianGram.lean).
The zero-side test function is

```
H_c(s) = 2πσ² exp(σ²(s−1/2)²) exp(−c(s−1/2)),
```

with `H_c(1/2+it) = ĝ_c(t) = 2πσ² exp(−σ²t²) exp(−ict)` and
`H_c(0)+H_c(1) = pole(c)`.  Weil's explicit formula predicts

```
Σ_ρ H_c(ρ) = W(c)                 (zero side = arithmetic side),
```

and, because the zero set is closed under `ρ ↦ 1−ρ` and conjugation, the Gram
entry is the symmetrised value `(W(c)+W(−c))/2`.

## 1. What is Lean-checked

### 1.1 The zero-side contour identity

[`../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean):

| Name | Statement |
|---|---|
| `gaussianZeroTest_critical_line` | `H_c(1/2+it) = 2πσ² exp(−σ²t²) exp(−ict)`. |
| `gaussianZeroTest_pole_sum` | `H_c(0)+H_c(1) = 4πσ² exp(σ²/4) cosh(c/2)`. |
| `gaussian_zero_side_contour` | for a finite zero set `S` in a rectangle, `∮(Z'/Z)H_c = 2πi(Σ_{ρ∈S}H_c(ρ) − H_c(0) − H_c(1))`. |

### 1.2 The rank-one / PSD structure

Same file:

| Name | Statement |
|---|---|
| `gaussianZeroTest_eq_mode_mul` | `H_{a−b}(1/2+it) = φ_a(t) conj φ_b(t)`, `φ_a(t) = σ√(2π) exp(−σ²t²/2) exp(−iat)`. |
| `gaussianZeroTest_add` | general complex shift: `H_c(1/2+z) = 2πσ² exp(σ²z²) exp(−cz)`; the starting point for the off-line quadruple in W4. |
| `gaussianZeroExp_re`, `gaussianZeroExp_im` | real and imaginary parts of `exp(σ²z²)` for `z = δ+iγ`. |
| `gaussianZeroPair_re`, `gaussianZeroPair_im` | real and imaginary parts of `exp(−cz)+exp(cz)` for `z = δ+iγ`. |
| `offLineQuad` | the symmetrised four-point contribution `{ρ, 1−ρ, conj ρ, 1−conj ρ}`. |
| `offLineQuad_neg_gamma`, `offLineQuad_neg_c` | the quadruple is unchanged by `γ ↦ −γ` and by `c ↦ −c` (the latter is the `ρ ↔ 1−ρ` symmetry). |
| **`offLineQuad_re`** | **the closed form** `S(c) = 4A(cosθ cosh(cδ)cos(cγ) − sinθ sinh(cδ)sin(cγ))`. |
| **`offLineQuad_re_exp`** | the exponential form `S(c) = 2A(e^{cδ}cos(cγ+θ) + e^{−cδ}cos(cγ−θ))`, which isolates the growing term. |
| `twoByTwo_not_posSemidef` | a symmetric 2×2 matrix with diagonal `a` and off-diagonal `b` is not PSD when `|b| > a`. |
| **`offLineQuad_obstruction`** | conditional off-line obstruction: if `|S(c)| > S(0)`, the 2×2 zero-side Gram matrix is not PSD. |
| `exists_cos_eq_one_large` | for `δ ≠ 0`, `γ ≠ 0`, the congruence `cγ+θ ≡ 0 (mod 2π)` has solutions with `cδ` arbitrarily large. |
| `gaussianZeroTest_critical_line_norm` | `‖H_c(1/2+iy)‖ = 2πσ² exp(−σ²y²)`. |
| **`gaussianZeroTest_vertical_norm`** | `‖H_c(c+iy)‖ = 2πσ² exp(σ²((c−1/2)²−y²)) exp(−c(c−1/2))`; the Gaussian decay used in the contour estimates. |
| **`gaussianZeroTest_norm`** | the general pointwise modulus `‖H_c(x+iy)‖ = 2πσ² exp(σ²((x−1/2)²−y²)) exp(−c(x−1/2))`. |
| **`gaussianZeroTest_vertical_form`** | the general vertical-line phase decomposition `H_c(x+iy) = 2πσ² exp(σ²(x−1/2)²−c(x−1/2)) exp(−σ²y²) exp(i(2σ²(x−1/2)−c)y)`; the form needed for the `Re s > 1` termwise sum. |
| **`integral_vertical_phase`** | the general vertical phase integral: `∫ e^{−iay}H_c(x+iy)dy` is an explicit Gaussian bump in `a`; the termwise prime-side identity for `Re s > 1`. |
| `integral_gaussianZeroTest_vertical` | the zero-frequency vertical integral `∫ H_c(x+iy)dy`. |
| `integral_gaussianZeroTest_vertical_self` | the same on the line `Re s = c`. |
| `integral_vertical_phase_weighted` | its constant-multiple form. |
| **`integral_vonMangoldt_term_vertical`** | the `n`-th von Mangoldt term `n^{-x}e^{-iy log n}` integrated against `H_c` on `Re s = x`; the termwise prime side off the critical line. |
| **`integral_finset_sum_vonMangoldt_vertical`** | the finite vertical prime side: the truncated von Mangoldt sum on `Re s = x`, conditional only on integrability. |
| `integrable_phase_vertical` | integrability of the phase-weighted test function on any vertical line. |
| **`integral_finset_sum_vonMangoldt_vertical_all`** | the **unconditional** finite vertical prime side: the truncated von Mangoldt sum on `Re s = x`, with no side conditions. |
| **`hasSum_integral_vonMangoldt`** | the infinite prime-side reduction: under summability of the norm integrals, the prime-side integrals sum to the integral of the `tsum`. |
| **`integral_logDeriv_gaussianZeroTest_right_side`** | the right vertical side of the explicit formula for `H_c` on `Re s = c > 1`, decomposed into the archimedean factor and the von Mangoldt L-series. |
| `integral_logDeriv_gaussianZeroTest_right_side'` | the general right-side decomposition with independent centre `c` and line `Re s = x > 1`. |
| **`rectIntegral_gaussian_right_side`** | the rectangle assembly: `rectIntegral` of `(Z'/Z)·H_c` expressed through its four sides, with the right side split into archimedean and von Mangoldt terms. |
| `gaussianZeroTest_one_sub` | reflection of the test function: `H_c(1−w) = H_{−c}(w)`. |
| `gaussianZeroTest_one_sub_norm` | reflection preserves the modulus: `‖H_c(1−w)‖ = ‖H_{−c}(w)‖`. |
| `gaussianZeroTest_one_sub_zero` | the symmetric test function is reflection-invariant: `H_0(1−w) = H_0(w)`. |
| `gaussianZeroTest_one_eq_neg_zero`, `gaussianZeroTest_zero_eq_neg_one` | the pole values swap under reflection: `H_c(1) = H_{−c}(0)` and `H_c(0) = H_{−c}(1)`. |
| **`tendsto_vertical_integral`** | the truncated vertical integral of `H_c` converges to the full integral as `T → ∞`. |
| `tendsto_exp_neg_sq_zero` | the Gaussian decay `exp(−σ²T²)` tends to zero as `T → ∞`; the horizontal-side limit ingredient. |
| **`tendsto_horizontal_integral_zero`** | **the horizontal sides vanish:** `∫_{x₁}^{x₂}H_c(x+iT)dx → 0` as `T → ∞`. |
| **`tendsto_rectIntegral_of_sides`** | assembly: if the bottom/top integrals vanish and the right/left converge to `R`/`L`, then `rectIntegral → I·R − I·L`. |
| **`tendsto_vertical_integral_logDeriv`** | the log-derivative-weighted vertical integral converges to the full integral as `T → ∞` (conditional on integrability). |
| **`explicit_formula_assembly`** | **the infinite explicit formula:** from the finite contour identity, horizontal vanishing, right/left side limits and zero-sum convergence, `(Zsum − h(0) − h(1))·2πi = I·R − I·L`. |
| **`explicit_formula_gaussianZeroTest`** | the same assembly specialised to `h = H_c`. |
| **`explicit_formula_gaussianZeroTest_arch_prime`** | **capstone:** the Gaussian explicit formula in archimedean/prime form, `(Zsum − H_c(0) − H_c(1))·2πi = I·(−ArchR − PrimeR) − I·(ArchL + PrimeL)`. |
| **`right_limit_eq_arch_prime`** | the right-side limit is identified as `−Arch·I − Prime·I` from the archimedean and prime limits. |
| **`left_limit_eq_arch_prime`** | the left-side limit is identified as `Arch·I + Prime·I` for `H_{−c}`. |
| **`summable_exp_neg_sq`** | the Gaussian sequence `exp(−σ²n²)` is summable; the model decay for the zero-sum tail. |
| **`summable_exp_neg_sq_of_abs_ge`** | if `|γ n| ≥ c·n` with `c > 0`, then `∑ exp(−σ²γ_n²)` converges; the zero-counting input for the Gaussian tail. |
| **`ZeroTailSummable`** | the named `Prop`: summability of the Gaussian-weighted zero tail, `∑ exp(−σ²γ_n²)`. |
| `zeroTailSummable_iff` | the definition unfolding. |
| **`summable_of_eventually_le_inv_sq`** | a sequence eventually bounded by `1/n²` is summable; the comparison tool for the sublinear zero tail. |
| `summable_inv_sq` | `∑ 1/n²` converges. |
| **`summable_exp_neg_div_log_sq_of_le`** | sublinear zero-tail reduction: if `exp(−σ²(n/log n)²) ≤ 1/n²` eventually, the tail is summable. |
| **`tendsto_log_cube_div_sq_zero`** | `(log x)³ / x² → 0`; the growth input for the sublinear domination. |
| **`eventually_exp_neg_div_log_sq_le_inv_sq`** | eventually `exp(−σ²(n/log n)²) ≤ 1/n²`; the sublinear domination. |
| **`summable_exp_neg_div_log_sq`** | the `n/log n` model zero tail is **summable, unconditionally**. |
| **`zeroTailSummable_of_ge_div_log`** | if `|γ n| ≥ c·n/log n` eventually, then `ZeroTailSummable γ σ`. |
| **`VerticalLogDerivIntegrable`** | the named `Prop`: integrability of `(Z'/Z)·H_c` on a vertical line. |
| `verticalLogDerivIntegrable_iff` | the definition unfolding. |
| **`FullBlockWithin`** | the named W4 input: entrywise bound of the full 2×2 block by the isolated quadruple block. |
| `offLineQuad_fullBlock_not_posSemidef_of_within` | the domination theorem stated through `FullBlockWithin`. |
| **`logDeriv_mul_gaussianZeroTest_one_sub`** | pointwise functional-equation reflection: `(Z'/Z)(1−s)·H_c(1−s) = −(Z'/Z)(s)·H_{−c}(s)`; the left side of `H_c` is the right side of `H_{−c}`. |
| **`integral_logDeriv_gaussianZeroTest_left_eq_neg_right`** | the integrated left-side reflection: the left vertical side at `Re s = −1` equals minus the right side of `H_{−c}` at `Re s = 2`. |
| `integral_logDeriv_gaussianZeroTest_left_eq_neg_right_zero` | the symmetric case `c = 0`: left side = minus right side for the same `H_0`. |
| **`gaussianZeroTest_real`** | the real-axis value `H_c(x) = 2πσ² exp(σ²(x−1/2)² − c(x−1/2))`, a positive real. |
| `gaussianZeroTest_real_norm` | the real-axis modulus `‖H_c(x)‖ = 2πσ² exp(σ²(x−1/2)² − c(x−1/2))`. |
| `gaussianZeroTest_zero_norm`, `gaussianZeroTest_one_norm` | the pole-point moduli `‖H_c(0)‖ = 2πσ² exp(σ²/4 + c/2)` and `‖H_c(1)‖ = 2πσ² exp(σ²/4 − c/2)`. |
| `gaussianZeroTest_pole_norm_mul` | `‖H_c(0)‖·‖H_c(1)‖ = (2πσ²)² exp(σ²/2)`. |
| `sq_sub_le_max` | on an interval, `(x−a)²` is bounded by the endpoint squares; the input for horizontal-side bounds. |
| `exp_neg_mul_le_max` | the exponential of a linear function is bounded by its endpoint values. |
| **`norm_horizontal_integral_le`** | **horizontal-side decay:** `‖∫_{x₁}^{x₂}H_c(x+iT)dx‖ ≤ (x₂−x₁)·C·exp(−σ²T²)`, so the horizontal integrals vanish as `T → ∞`. |
| **`integral_vertical_norm`** | the vertical-line mass `∫‖H_c(c+iy)‖dy = 2πσ² exp(σ²(c−1/2)²) exp(−c(c−1/2)) √(π/σ²)`. |
| **`integral_norm_general`** | the vertical-line mass at any `Re s = x`: `∫‖H_c(x+iy)‖dy = 2πσ² exp(σ²(x−1/2)²) exp(−c(x−1/2)) √(π/σ²)`. |
| `continuous_gaussianZeroTest` | `H_c` is continuous (indeed entire). |
| `intervalIntegrable_gaussianZeroTest_vertical`, `_horizontal` | `H_c` is interval-integrable along every vertical and horizontal line. |
| **`exists_offLineQuad_gt`** | for `δ ≠ 0`, `γ ≠ 0`, the quadruple contribution is unbounded above: for every `B` there is `c` with `B < S(c)`. |
| **`offLineQuad_obstruction_unconditional`** | for `δ ≠ 0`, `γ ≠ 0`, some separation `c` makes the 2×2 zero-side Gram matrix indefinite. |
| `exists_offLineQuad_gt_gamma_zero` | the `γ = 0` growth case: `4A cosh(cδ)` is unbounded above. |
| **`offLineQuad_obstruction_all`** | **full 2×2 off-line obstruction:** for every `δ ≠ 0` (including `γ = 0`), some `c` makes the 2×2 zero-side Gram matrix indefinite. |
| `exists_offLineQuad_gt_all` | the growth form for every `γ` (including `γ = 0`): for every bound `B` there is `c` with `B < S(c)`. |
| `twoByTwo_perturbed_not_posSemidef` | a 2×2 block within `B` of `[[a,b],[b,a]]` is not PSD when `a − b + 2B < 0`. |
| **`offLineQuad_domination`** | for every `B ≥ 0` there is `c` with `S(0) − S(c) + 2B < 0`. |
| **`offLineQuad_fullBlock_not_posSemidef`** | **conditional domination:** if the full zero-side 2×2 block is entrywise within `B` of the isolated quadruple block and `S(0) − S(c) + 2B < 0`, it is not PSD. |
| `zeroSideGramReal_term` | `2πσ²e^{−σ²γ²}cos((a−b)γ) = cosMode_a cosMode_b + sinMode_a sinMode_b`. |
| `zeroSideGramReal_posSemidef` | for a finite family of critical-line frequencies, `G_{ij} = Σ_k 2πσ²e^{−σ²γ_k²}cos((a_i−a_j)γ_k)` is positive semidefinite. |
| `ZeroSideWeilPositivity` | the named target: every finite critical-line frequency family gives a PSD zero-side Gram matrix. |
| **`zeroSideWeilPositivity`** | **the named statement is proved** for finite critical-line families. |

This is the spectral explanation: on the critical line the zero side is a sum
of rank-one positive terms.  An off-line zero breaks the rank-one form; that
break is the obstruction.

### 1.3 The pole identity on the Gram side

[`../prime-spectrum-tensor/lean/ZeroSidePole.lean`](../prime-spectrum-tensor/lean/ZeroSidePole.lean):

| Name | Statement |
|---|---|
| `poleTerm_eq_zeroSideGaussian_pole` | `poleTerm c σ = H_c(0) + H_c(1)`. |
| `poleTerm_eq_zeroSideGaussian_pole_re` | the real form used by the Gram entry. |

### 1.4 Numerical

C25 in [`../prime-spectrum-tensor/tests/test_programme.py`](../prime-spectrum-tensor/tests/test_programme.py):
the first 40 non-trivial zeros reproduce the five 5×5 Gram entries to
`3.5·10⁻¹⁸`.

## 2. What remains

### W1 — the prime-side evaluation on `Re s > 1`

The library already has, in
[`../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean`](../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean):

* `logDeriv_mul_I_eq_neg_arch_add_prime`: pointwise `Z'/Z·h·i = −(arch·h·i + L_Λ·h·i)` on `Re s > 1`;
* `integral_lseries_vonMangoldt_mul`: `∫ L_Λ(c+iy)h(y)dy = Σ_n ∫ term_n(c+iy)h(y)dy` for `c > 1`;
* `integral_logDeriv_mul_I_eq_neg_arch_prime'`: the integrated vertical-line identity.

**First primitives (Lean-checked).**  `integral_exp_gaussian_line`:
`∫ y, exp(I b y) exp(−σ²y²) = (π/σ²)^{1/2} exp(−b²/(4σ²))`, the Gaussian
vertical-line integral used by both the prime and archimedean evaluations;
`integral_critical_line_phase`: the phase integral of `H_c` on
`Re s = 1/2` gives the Gaussian bump centred at `c`, the termwise prime-side
identity on the critical line; the weighted form `integral_phase_weighted`; and
`integral_vonMangoldt_term_critical_line`, the termwise von Mangoldt
contribution (the `n`-th prime-side term) on the critical line; and
`integral_finset_sum_phase`, the finite-sum linearity that assembles a
truncated prime side; and `integral_finset_sum_vonMangoldt`, the truncated
von Mangoldt sum; `integrable_phase_weighted`, which discharges its integrability
condition; and `integral_finset_sum_vonMangoldt_all`, the **unconditional**
truncated prime side; its `b = 0` case
`integral_critical_line_zero_phase`, the total mass of `H_c` on the critical
line; and `integral_critical_line_phase_swap`, the centre/frequency symmetry.

**Missing.**  Evaluate the two integrals for `h(y) = H_c(c+iy)`:

1. the prime integral: `∫ L_Λ(c+iy)H_c(c+iy)dy`; expand the series and use
   Fourier inversion to obtain `−2Π(h_c)` in the limit `c ↓ 1/2` (or at the
   contour's left edge);
2. the archimedean integral: `∫ arch(c+iy)H_c(c+iy)dy`; identify it with the
   density term `σ²∫ exp(−σ²t²)cos(ct)Ω(t)dt` via the digamma/Fourier identity
   `Re A_arch(ξ) = −Ω(ξ+i/2)/2` already in
   [`Archimedean.lean`](../absolute-polarized-hodge-index-realization/lean/Archimedean.lean).

This is the analytic core.  It is self-contained enough to be attempted
independently of the zero side.

### W2 — the contour shift

The explicit formula's contour is a rectangle enclosing the critical strip.
The zero side is already computed by `gaussian_zero_side_contour`.  What is
missing is the deformation from the line `Re s = c > 1` (where W1 evaluates the
integral) to the critical strip, picking up the pole at `s = 1` and the zeros.
The rectangle/argument-principle machinery is in
[`Rectangle.lean`](../absolute-polarized-hodge-index-realization/lean/Rectangle.lean)
(`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`, the residue-sum
decomposition, and the boundary estimates).  The sign convention must be pinned
by the `c = 0` case, where `W(0) = 0.043135958…` is known.

### W3 — the infinite-zero limit

`gaussianZeroTest_vertical_norm` gives the explicit Gaussian decay of `H_c` on
the vertical sides, so `zero_sum_tail_bound`
([`TailBound.lean`](../absolute-polarized-hodge-index-realization/lean/TailBound.lean))
bounds the difference of finite zero sums by `(M/2π)(perimeter' + perimeter)`,
where `M` bounds `‖(Z'/Z)H_c‖` on the boundary.  On the vertical sides
`|H_c(x+iT)|` decays like `exp(−σ²T²)`, so the tail vanishes if `Z'/Z` grows
slower than `exp(σ²T²)`.  A polynomial growth bound on `Z'/Z` in the critical
strip is standard but not in the library; `ZetaStrip.lean` has polynomial growth
bounds for `ζ` itself (`exists_bound_norm_zeta_strip_polefree`,
`xigrowth_norm_riemannZeta_le_quadratic`), which are the starting point.

The linear-bound lemma `summable_exp_neg_sq_of_abs_ge` is only a **model**: by
Riemann–von Mangoldt the actual zero ordinates grow like `n / log n`, which is
sublinear, so the linear comparison does not apply directly.  The `n/log n` model is now **unconditionally summable**
(`summable_exp_neg_div_log_sq`), so the analytic comparison is done.  The
remaining step is to derive the `n/log n` lower bound for the actual zero
ordinates from the library's zero-counting results; given that bound,
`zeroTailSummable_of_ge_div_log` proves `ZeroTailSummable`.

**Remaining named inputs.**  After the reductions above, the open analytic
obligations are exactly:

1. the zero-counting lower bound `|γ n| ≥ c·n/log n`, which by
   `zeroTailSummable_of_ge_div_log` gives `ZeroTailSummable`;
2. `VerticalLogDerivIntegrable`, the integrability of `(Z'/Z)·H_c` on the
   vertical sides (`tendsto_vertical_integral_logDeriv` consumes it);
3. `FullBlockWithin`, the W4 zero-density entrywise bound (consumed by
   `offLineQuad_fullBlock_not_posSemidef_of_within`).

Everything else in the zero-side bridge is Lean-checked.

### W4 — the off-line obstruction

Write `ρ = 1/2 + δ + iγ` with `δ ≠ 0`.  The symmetrised quadruple
`{ρ, 1−ρ, conj ρ, 1−conj ρ}` contributes to the Gram entry at separation `c`:

```
S(c) = 4|A| [ cos θ cosh(cδ) cos(cγ) − sin θ sinh(cδ) sin(cγ) ],
A = 2πσ² exp(σ²(δ²−γ²)),   θ = 2σ²δγ.
```

The closed form of `S(c)` (both trigonometric and exponential), the growth
estimate, and the **unconditional 2×2 off-line obstruction** are now
Lean-checked (`offLineQuad_re`, `offLineQuad_re_exp`,
`exists_offLineQuad_gt`, `offLineQuad_obstruction_unconditional`).  What remains
for W4 is the **zero-density input**: an entrywise bound `B` on the contribution
of the other zeros.  Given such a `B`, `offLineQuad_fullBlock_not_posSemidef`
turns the growth of the off-line quadruple into indefiniteness of the full 2×2
block.  The `γ = 0` case is covered.  The on-line zeros contribute
a bounded amount (zero-density / Riemann–von Mangoldt), so a sufficiently wide
2×2 Gaussian Gram matrix becomes indefinite.  This is the quantitative converse
direction.  The algebra of `S(c)` is formalisable now; the domination by the
off-line term needs the zero-counting input.

## 3. Work order

1. **W1a** (prime integral) and **W1b** (archimedean integral) on `Re s > 1`;
   compare with `primeTerm` and `densityTerm` at `c = 0` and `c = 4/5`.
2. **W2** (contour shift) for a rectangle, then the limit `T → ∞` (W3).
3. **W4a** (the algebra of `S(c)`) and **W4b** (the domination/no-go).
4. Assemble `WeilPositivityGaussian ↔ RiemannHypothesis` only if W1–W4 are all
   Lean-proved.  Until then O2 stays **Partial — advanced**.

## 4. Acceptance criteria for O2

1. A Lean theorem identifying `gaussianW c σ` with the zero sum over the
   non-trivial zeros (with multiplicities), for the Gaussian basis.
2. A Lean theorem `gaussianGram_posSemidef` for every finite Gaussian basis,
   derived from the zero side (not from the entrywise certificate).
3. The off-line obstruction: an explicit off-line zero forces a negative
   direction in a sufficiently wide Gaussian basis.
4. No `sorry`, `axiom` or `admit`; standard axioms only.
5. The O2 row and §7.10 of the [dossier](README.md) updated at every step;
   `index.html` kept in sync; generated indexes regenerated.

## 5. Non-goals

* Claiming O2 closed without the Riemann hypothesis.
* Replacing the explicit formula by a numerical identity.
* Importing across topic roots by filename (`HANDOFF-O4.md` §8): the
  explicit-formula half lives in `absolute-polarized-hodge-index-realization`,
  the Gram half in `prime-spectrum-tensor`, and the O2 bookkeeping here.

---

[Back to the dossier](README.md) · [Zero-side bridge](../prime-spectrum-tensor/ZERO-SIDE-BRIDGE.md) ·
[Margin scaling](../prime-spectrum-tensor/MARGIN-SCALING.md) ·
[Weil positivity assessment](../prime-spectrum-tensor/WEIL-POSITIVITY.md)
