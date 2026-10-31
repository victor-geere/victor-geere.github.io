# Handoff — absolute polarized Hodge-index realization

**Status: No RH proof yet.** This document is the entry point for continuing
the programme. It records what is Lean-checked, what is numerical, what is
text-only, and the exact next steps.

## 1. Mission

The goal is to continue the rescued absolute-polarized Hodge-index programme
towards a proof of the Riemann hypothesis. The RH-relevant input is the
**cone positivity** (Weil's criterion), which requires the **explicit formula**;
the explicit formula requires the **argument principle** for `Z'/Z`. The
dossier has been building that chain bottom-up.

**Goal state at handoff:** id `goal-36cd1d34-f53b-48cb-be54-45c06ac6c348`,
revision **18**, phase **paused**, 215 rounds started, cap 10000. To continue
the goal in a new session, resume it with `update_goal` (action `resume`,
revision 18) after the human asks to continue. Every status must say exactly
**"No RH proof yet."** until an RH proof exists.

## 2. Build and verification

```bash
cd the-final-letter/topics/absolute-polarized-hodge-index-realization

# Lean (all seven files; uses topics/tools/check-lean.sh)
./lean/check.sh

# Python (158 test cases)
python3 -m pytest -q tests
```

Environment: Lean 4 with Mathlib at `~/lean/mathlib4`; the shared checker is
`the-final-letter/topics/tools/check-lean.sh`. Python uses numpy, mpmath,
sympy; `mp.iv` for interval arithmetic and `mp.quad` to infinity.

Runtime: the Lean check takes about 5–6 minutes (files are checked
sequentially); the Python suite about 4.5–5 minutes (the interval-certificate
tests dominate).

Hard rules: no `sorry`, `axiom`, or `admit`; no truncation of numbers or
series where a bound is available; label **Lean-checked**, **numerical**, and
**text-proof** claims distinctly.

## 3. Repository map

| path | role |
|---|---|
| `README.md` | dossier index and current-state summary |
| `HANDOFF.md` | this document |
| `notes/37`–`notes/60` | research notes; `54-final-assessment.md` the consolidated assessment, `55-cone-positivity-import.md` the finite cone positivity, `56`–`58` the explicit-formula chain and contour shift, `59` the programme-status synthesis, `60` the critical-line route |
| `research-journal.md` | round-by-round journal (through round 356) |
| `lean/Rescue.lean` | finite KMS forms, compatibility, Hodge sign, tensor forms |
| `lean/Shadow.lean` | finite Hodge-index model, box/LDLᵀ cone positivity certificates, Gram positivity |
| `lean/Archimedean.lean` | archimedean symbol, contour identity, conjugation |
| `lean/Symbol.lean` | completed zeta, symbol identity, pole terms, argument-principle chain |
| `lean/Limit.lean` | scaling-site limit form (both signs) |
| `lean/Weil.lean` | pole/prime sign conventions |
| `lean/Hadamard.lean` | canonical products, Jensen, order-1 class, factorisation |
| `lean/Rectangle.lean` | rectangle boundary integral, Cauchy–Goursat, winding integral, argument principle |
| `lean/ExplicitFormula.lean` | prime side: vertical modulus, von Mangoldt termwise integration |
| `python/rescue_probe.py` | interval/omega machinery, Gram intervals, certificates |
| `python/gram6_certificate.json` | saved 6×6 interval certificate data |
| `tests/test_rescue.py` | 101 test functions / 185 cases |

## 4. Current Lean state (549 declarations)

### Argument-principle chain in `Symbol.lean` (the active frontier)

| theorem | content |
|---|---|
| `circleIntegral_sub_inv_linear` | `(2πi)⁻¹ ∮ 1/(z−w) = 1` for `w` inside |
| `circleIntegral_sub_inv_eq_zero` | `∮ 1/(z−w) = 0` for `w` strictly outside |
| `circleIntegral_finset_sum` | circle-integral linearity (global continuity) |
| `circleIntegral_finset_sum_of_continuousOn` | linearity with continuity on the sphere |
| `circleIntegral_congr` | the integral sees only sphere values |
| `logDeriv_sub_const` | `logDeriv (z−w) = 1/(z−w)` |
| `circleIntegral_logDeriv_prod` | **argument-principle count** for a product of linear factors |
| `logDeriv_eq_inv_add` | local split `f=(z−w)g ⇒ f'/f = 1/(z−w)+g'/g` |
| `circleIntegral_add_of_continuousOn` | additivity on the sphere |
| `circleIntegral_logDeriv_simple_zero` | **local-to-global simple zero**: `∮ f'/f = 2πi` |
| `circleIntegral_logDeriv_eq_zero` | zero-free: `∮ h'/h = 0` |
| `circleIntegral_logDeriv_mul_prod` | **multi-zero count** `f = P·h` |
| `logDeriv_inv_comp` | `logDeriv (1/f) = −logDeriv f` |
| `circleIntegral_neg` | `∮(−f) = −∮f` |
| `circleIntegral_logDeriv_prod_eq` | product count with `(2πi)⁻¹` absorbed: `∮ = 2πi·#S` |
| `circleIntegral_logDeriv_simple_pole` | **simple pole**: `1/f=(z−p)k` ⇒ `∮ f'/f = −2πi` |
| `circleIntegral_logDeriv_div_prod` | **divisor form**: `f=P_Z·P_P⁻¹·h` ⇒ `∮ f'/f = 2πi·(#Z−#P)` |

### Completed zeta and symbol in `Symbol.lean`

Symbol identity (on `Im ξ>1`, continued to `s≠1`, critical-line form
`symbol_critical_line_eq_neg_logDeriv`); conjugation, anti-symmetry
`symbol_antisymm`, pure-imaginary `symbol_critical_line_pure_imaginary`;
functional equation `completedZeta_one_sub`; conjugation `completedZeta_conj`;
zero quadruple `completedZeta_zero_quadruple`; critical-line reality
`completedZeta_critical_line_real`; real-axis positivity
`completedZeta_ofReal_pos`; pole residues `completedZeta_residue_one`
(`1` at `s=1`) and `completedZeta_residue_zero` (`−1` at `s=0`); log-derivative
symmetries `logDeriv_completedZeta_conj`, `logDeriv_completedZeta_one_sub`,
`logDeriv_completedZeta_critical_line_imaginary`; derivative
`deriv_completedZeta_critical_line_imaginary`; zero-sum reality
`finset_sum_real_of_conj`, `zero_sum_real_of_finite`; RH formulations
`riemannHypothesis_iff_critical_line`,
`riemannHypothesis_iff_no_zeros_left_half`.

### Cone positivity / finite Hodge index in `Shadow.lean`

Finite Hodge-index model: `Bint`, `Bint_comm`, `Bint_self`,
`Bint_ample_sq`, `Bint_ample_dot`, `hodge_defect_identity`,
`hodge_index_explicit`, `hodge_defect_eq_zero_iff`. Cone positivity:
`abs_quad_le_row_sum(_rat)`, `box_ge(_rat)`, `posDef_of_box(_rat)`,
`ldl_posDef_rat`, `Pq_factor`, `Pqm_posDef`, `W4m_posDef` (4×4 certificate),
`P2m_posDef`, `W2m_posDef` (2×2 rung), `two_by_two_posDef`,
`gram_quadFormR_nonneg`, `gram_quadFormR_pos_iff`.

### Rectangle contour in `Rectangle.lean`

`rectIntegral` (the four-side boundary integral); `rectIntegral_add`,
`rectIntegral_neg`, `rectIntegral_congr`; `rectIntegral_eq_zero_of_differentiableOn`
(Cauchy–Goursat); `continuousOn_horizontal`, `continuousOn_vertical`;
`rectIntegral_logDeriv_eq_zero`; `integral_inv_horizontal`,
`integral_inv_vertical`, `integral_inv_vertical_left`;
`log_neg_of_im_pos`, `log_neg_of_im_neg`, `log_sub_log_neg_of_im_pos`,
`log_neg_sub_log_of_im_neg`; **`rectIntegral_inv_of_mem`** (`∮ dz/(z−w) = 2πi`
inside), **`rectIntegral_inv_of_not_mem`** (`= 0` outside); the boundary-set
layer `rectBoundarySet`, `rectIntegral_add_boundary`,
`rectIntegral_congr_boundary`, `rectIntegral_finset_sum_boundary`;
**`rectIntegral_logDeriv_prod_eq`** (product count) and
**`rectIntegral_logDeriv_div_prod`** (divisor form,
`∮ f'/f = 2πi·(#Z − #P)` on the rectangle); and
**`AnalyticAt.exists_eventuallyEq_sub_mul`** (local factorisation
`f = (z−w)·g` at a simple zero); `rectIntegral_eq_zero_of_differentiable_on_off_countable`
(Cauchy–Goursat off a countable set); `polyProd`, `deriv_polyProd_mem`,
`prod_erase_ne_zero`, `quotientExtension` and its removable-value,
continuity, analyticity (`analyticAt_quotientExtension_of_mem`),
differentiability (`differentiableOn_quotientExtension`) and zero-freeness
(`quotientExtension_ne_zero`) lemmas; **`rectIntegral_logDeriv_eq_card_of_simple_zeros`**
(argument principle for analytic functions with simple zeros) and
**`rectIntegral_logDeriv_completedZeta_eq_card`** (`∮ Z'/Z = 2πi·(#S − 2)`, the
zero side of the explicit formula); the multiplicity forms
**`rectIntegral_logDeriv_eq_sum_multiplicity`** and
**`rectIntegral_logDeriv_completedZeta_eq_sum`**
(`∮ Z'/Z = 2πi·(∑ m − 2)`, no simplicity assumption); and the construction of
the quotient from the analytic order, leading to
**`rectIntegral_logDeriv_eq_divisor_sum`** and
**`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`** (`polyProdPow`,
`quotientExtensionPow`, `exists_eventuallyEq_pow_mul_of_order`).

### Prime side in `ExplicitFormula.lean`

`norm_natCast_cpow_vertical` (`‖n^{-(c+iy)}‖ = n^{-c}`),
`continuous_natCast_cpow_vertical`, `continuous_lseriesTerm`,
`vonMangoldt_nonneg`, `summable_vonMangoldt_majorant`, and
**`integral_lseries_vonMangoldt`** (term-by-term integration of the von
Mangoldt series on a vertical segment), `hasDerivAt_natCast_cpow_vertical`,
`integral_natCast_cpow_vertical`, `integral_lseriesTerm_vonMangoldt` and
**`integral_lseries_vonMangoldt_closed`** (prime side in closed form) and
**`integral_logDeriv_completedZeta_right_side`** (right vertical side of the
contour, conditional on interval integrability), its unconditional form
**`integral_logDeriv_completedZeta_right_side'`**, the continuity inputs
`continuousOn_lseries_vonMangoldt`, `continuousOn_logDeriv_completedZeta`, and
**`integral_logDeriv_completedZeta_left_side`** (left side by the functional
equation), `archSymbol`, `primeSide`,
`integral_logDeriv_completedZeta_left_eq_neg_right`, and the assembly
**`explicit_formula_h1_symmetric`**, the exact horizontal reflection
`integral_logDeriv_completedZeta_bottom_eq_neg_top`, and
**`explicit_formula_h1_symmetric_exact`** (horizontal difference `= -2·top`,
no Stirling estimates), `integral_conj_interval`,
`integral_logDeriv_completedZeta_bottom_eq_conj_top` and
**`integral_logDeriv_completedZeta_top_pure_imaginary`** (the top side is
purely imaginary); and the divisor-derived argument principle
**`rectIntegral_logDeriv_eq_divisor_sum_of_analytic`** with
`divisor_openRect_support_finite`, `divisor_openRect_support_subset`,
`analyticOrderNatAt_eq_divisor_toNat`, and the zeta instance
**`rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`**
(`∮ Z'/Z = 2πi·(∑ div − 2)`, zero set derived), and the capstone
**`explicit_formula_h1_symmetric_divisor`** (full `h ≡ 1` explicit formula
with divisor-derived zero side), and
**`integral_logDeriv_completedZeta_bottom_pure_imaginary`** (both horizontal
sides purely imaginary), the **Cauchy integral formula on a rectangle**
`rectIntegral_mul_inv_sub_eq`, and the **simple-zero residue**
`tendsto_sub_mul_logDeriv_of_simple_zero` /
`tendsto_sub_mul_logDeriv_completedZeta_zero` and the **simple-pole residue**
`tendsto_sub_mul_logDeriv_of_simple_pole`, the pole extensions
`poleExtensionOne`/`poleExtensionZero`, and the zeta pole residues
`tendsto_sub_mul_logDeriv_completedZeta_pole_one` /
`tendsto_mul_logDeriv_completedZeta_pole_zero`, and the **closed-form local
residue subtractions** `exists_analyticAt_logDeriv_mul_sub_residue` (simple
zero) and `exists_analyticAt_logDeriv_mul_add_residue_pole` (simple pole), with
zeta instances at `1` and `0`, and the **residue sum**
`rectIntegral_sum_const_inv_sub`, and the **residue assembly**
`rectIntegral_logDeriv_mul_eq_residue_sum`, and the **pole-free identity**
`logDeriv_completedZeta_eq_logDeriv_poleExtension`, the **finite patching**
`exists_analyticOnNhd_of_differentiableOn_compl_finset`, and the
**differentiability of the global remainder**
`differentiableOn_globalRemainder` (with `differentiableAt_dslope_of_analyticAt`
and `differentiableAt_logDeriv_of_analyticAt`), and the **analytic global
remainder** `exists_analyticOnNhd_globalRemainder` (with
`analyticAt_dslope_of_analyticAt`, `analyticAt_finset_sum`), the
**boundary decomposition** `logDeriv_mul_eq_remainder_plus_residues`, and the
**test-function explicit formula** `test_function_explicit_formula`
(`∮ (Z'/Z)·h = 2πi(∑ h(ρ) − h(0) − h(1))`) and its linear case
`test_function_explicit_formula_linear`, and the pointwise prime-side identity
`logDeriv_mul_I_eq_neg_arch_add_prime`, the termwise prime-side step
`integral_lseries_vonMangoldt_mul`, the integrated prime-side identity
`integral_logDeriv_mul_I_eq_neg_arch_prime` (and its strengthened form
`..._prime'` with digamma continuity discharged via
`continuousAt_digamma_of_re_pos`), and the constant form
`integral_logDeriv_mul_I_eq_neg_arch_prime_const`. The remaining prime-side gap is
described in `notes/57-test-function-formula-and-prime-side.md`, and the
contour-shift derivation for symmetric test functions in
`notes/58-contour-shift-symmetric-test-functions.md`; its pointwise cores are
`logDeriv_mul_one_sub` and `logDeriv_mul_conj`, the integrated left
reflection is `integral_logDeriv_mul_left_eq_neg_right_two`, the integrated
horizontal reflection is `integral_horizontal_bottom_eq_conj_top_two`, and their
assembly is `contour_shift_symmetric`, with the reflection hypotheses discharged
in `contour_shift_symmetric'`, and instantiated for the concrete symmetric test
function `exp(-(s-1/2)²/1000)` in `contour_shift_gaussian`; note that the
`T → ∞` limit is not a limit of the holomorphic identity: holomorphic test
functions cannot decay horizontally, so the classical formula needs the
critical-line/Fourier route (note 58, §6); the route and its formalisation
targets are documented in `notes/60-critical-line-route.md`; the first Lean
ingredients are the Fourier-transform symmetry pair
`fourierG_even`/`fourierG_conj` and the regularity/boundedness
`continuous_fourierG`/`norm_fourierG_le`, the Fourier form of the
prime-measure identity `integral_lseries_vonMangoldt_fourier`, the closed
Fourier coefficient `integral_natCast_cpow_vertical_fourier`, the closed
Fourier term `integral_lseriesTerm_vonMangoldt_fourier`, the full closed
Fourier form `integral_lseries_vonMangoldt_fourier_closed`, and the
Fourier-kernel prime-side identity
`integral_logDeriv_mul_I_eq_neg_arch_prime_fourier` and its closed form
`..._fourier_closed` (with `fourierCoeffClosed`). The external *Angular Bochner
framework* note is recorded (with its limitative boundary) in
`notes/61-angular-bochner-framework.md`. Critical-line archimedean realness:
`digamma_add_conj_critical`, `archimedeanTerm_critical_line_real`, and the
reality of the archimedean integral `integral_archimedean_term_real`. A full
programme-status synthesis is in `notes/59-programme-status.md`. The consolidated chain status is in
`notes/56-explicit-formula-chain.md`.

### Hadamard in `Hadamard.lean`

Canonical products (finite and infinite), convergence, analyticity, divisors,
Jensen formula/inequality, zero-free logs, quotient normal form
`exists_entire_zeroFree_quotient`, `eq_mul_quotientNF`, `f = P·exp g`,
affine refinement conditional on `HasLogGrowthOne (f/P)`, and the order-1
class: constants, identity, affine, powers, products, finite products,
scalars, controlled division, affine reparametrisation, zero-free sums,
constant shifts, all complex polynomials (`polynomial_hasLogGrowthOne`),
genus-0 and genus-1 finite canonical products.

## 5. Exact next steps (updated after the rounds 250–356)

**Done (Lean-checked):**

1. ~~Simple-pole theorem~~ — `circleIntegral_logDeriv_simple_pole`; also the
   general local residue `tendsto_sub_mul_logDeriv_of_simple_pole`.
2. ~~Multi-pole / rectangle argument principle~~ — circle and rectangle
   divisor forms, multiplicity counts, and the **divisor-derived** count
   `rectIntegral_logDeriv_eq_divisor_sum_of_analytic`
   (`∮ f'/f = 2πi·∑ div`), with the zeta instance
   `rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`.
3. ~~`Z'/Z` on a rectangle~~ — complete, including the poles `0,1` and the
   Cauchy rectangle integral formula `rectIntegral_mul_inv_sub_eq`.
4. ~~Explicit formula with `h ≡ 1`~~ — `explicit_formula_h1_symmetric` and
   the divisor-derived `explicit_formula_h1_symmetric_divisor`, with the exact
   horizontal reflection (no Stirling estimates).
5. ~~Explicit formula with a test function (zero side)~~ —
   `test_function_explicit_formula` (`∮ Z'/Z·h = 2πi(∑h(ρ) − h(0) − h(1))`),
   supported by the local residue subtractions, the finite patching lemma, the
   global remainder, the boundary decomposition, and the residue assembly;
   instances: `test_function_explicit_formula_const`, `..._linear`,
   `..._quadratic`.
6. ~~Prime side~~ — pointwise (`logDeriv_mul_I_eq_neg_arch_add_prime`),
   integrated (`integral_logDeriv_mul_I_eq_neg_arch_prime'`), and termwise
   against a continuous factor (`integral_lseries_vonMangoldt_mul`), with
   digamma continuity (`continuousAt_digamma_of_re_pos`).
7. ~~Contour shift for holomorphic symmetric test functions~~ —
   `contour_shift_symmetric'`, with the Gaussian instance
   `contour_shift_gaussian`, the quadratic instance `contour_shift_quadratic`,
   and numerical checks (`h = e^{−(s−1/2)²/1000}`, `h = (s−1/2)²`,
   Paley–Wiener `2 sin(s−1/2)/(s−1/2)`).
8. ~~Fourier and critical-line layer~~ —
   `fourierG` symmetries/continuity/`L¹` bound, linearity
   (`fourierG_add`, `fourierG_sub`, `fourierG_neg`, `fourierG_const_mul`, `fourierG_finset_sum`) and
   the closed transforms of `1`, `c`, `e^{bu}`, `e^{iau}`, `c·e^{iau}`,
   `cos(au)` and `sin(au)` (`fourierG_one_eq`, `fourierG_const_eq`,
   `fourierG_exp_eq`, `fourierG_exp_I_eq`, `fourierG_const_mul_exp_I_eq`,
   `fourierG_cos_eq`, `fourierG_sin_eq`, `fourierG_id_eq`, `fourierG_sq_eq`, `fourierG_cube_eq`), and the derivative correspondence (`hasDerivAt_fourierG`, `deriv_fourierG`, `hasDerivAt_fourierG_moment`, the iterated form `iteratedDeriv_fourierG`, the Riemann–Lebesgue decay `norm_fourierG_le_div`, the limit `tendsto_fourierG_atTop`, the IBP identity `fourierG_ibp`, the `C²` decay `norm_fourierG_le_div_sq`, the full-line Fourier bridge (`fourier_fourierGExt`, `integrable_fourierGExt`), the conditional inversion `fourier_inversion_conditional`, the **unconditional Fourier inversion `fourier_inversion`**, and the Paley–Wiener test function (`paleyWiener`, its symmetries, its entirety `differentiable_paleyWiener`, and the assembled contour-shift identity `contour_shift_paleyWiener`); the four prime-measure Fourier
   identities (termwise, closed coefficient, closed term, full closed sum) with
   their `u = 0` consistency; the Fourier-kernel and closed `Z'/Z` identities;
   the archimedean critical-line realness (`digamma_add_conj_critical`,
   `archimedeanTerm_critical_line_real`, `integral_archimedean_term_real`,
   `conj_integral_archimedean_fourier`), numerically confirmed.

**Remaining:**

0. ~~Rectangle derivative Cauchy formula~~ — **done**:
   `rectIntegral_mul_inv_sq_eq` (`∮ h·((z−a)²)⁻¹ = 2πi·h′(a)`), built from
   `rectIntegral_inv_sq_eq_zero`, the winding integral, the `dslope`
   decomposition, and Cauchy for the analytic remainder; numerically confirmed
   to `10⁻²⁵`.

1. **Critical-line route to the classical Weil explicit formula**: the Fourier
   and prime-measure ingredients are Lean-checked (item 8); what remains is
   **Fourier inversion**, the archimedean integral against a general test
   function, and the assembled formula with constants fixed from Weil 1972 /
   Iwaniec–Kowalski Thm 5.12 (see `notes/60-critical-line-route.md`).
2. **Weil's criterion / infinite-level cone positivity** — the genuinely open,
   RH-relevant statement. The finite cone rungs (2×2, 4×4) are Lean-checked;
   the 6×6 interval certificate is numerical only (margin `~4·10⁻¹⁰`).
3. Optional: strengthen the numerical certificate for the finite cone.

## 6. Mathlib gaps and workarounds

- **No general argument principle or residue theorem** for `f'/f` in Mathlib.
  We built the base case, the product count, the simple-zero local-to-global
  case, the zero-free case, the multi-zero case, the reciprocal lemmas, the
  simple pole and the divisor form on circles, and the full rectangle version
  (Cauchy–Goursat, winding integral, product count, divisor form). What is
  still missing is the passage from a function `f` to its divisor (a global
  quotient extension at simple zeros); Mathlib has the local factorisation
  (formalised as `AnalyticAt.exists_eventuallyEq_sub_mul`) but no packaged
  gluing.
- **No `circleIntegral` sum/add linearity.** We built
  `circleIntegral_finset_sum`, `_of_continuousOn`,
  `circleIntegral_add_of_continuousOn`, `circleIntegral_congr`,
  `circleIntegral_neg` from the interval-integral definition.
- **`𝓝` notation is not in scope in `Symbol.lean`.** Use `nhds` /
  `nhdsWithin` explicitly.
- **No bundled complex `mul_pos`.** Use `Complex.pos_iff` (real part positive,
  imaginary part zero) and `open scoped ComplexOrder` for `0 < z` on `ℂ`.
- **`Matrix.det_fin_four` is absent.** For triangular determinants use
  `Matrix.det_of_isLowerTriangular`; for unit lower-triangular factors we used
  an explicit inverse and `IsUnit.of_mul_eq_one`.
- **`Finset.filter` / `if` in statements** needs decidability: put
  `open Classical` **before** the docstring (placing it between a docstring
  and the theorem gives "unexpected token `open`; expected `lemma`").
- **Pi product vs lambda** for `deriv_mul` / `logDeriv_prod`: bridge with a
  `funext` equality (`hfun`) before rewriting.
- **Hypothesis names shadow functions** in `have h : ... f ...`: rename to
  avoid the shadowing (e.g. `hquot` instead of `h`).
- **`simp` sometimes "makes no progress"** when a hypothesis is a `∀ w ∈ S`
  rewrite rule; use `Finset.sum_congr` explicitly instead.

## 7. Numerical layer

- `python/rescue_probe.py`: interval/omega machinery, Gaussian and
  compact-support Gram intervals, exact rational PSD checks.
- Tests: symbol pure-imaginary, log-derivative symmetries, zero quadruple,
  critical-line reality, pole residues, argument-principle counts (both-inside,
  mixed, simple zero, multi-zero), zero-free integral, cone-positivity LDL
  constants, Gram interval certificates.
- `python/gram6_certificate.json`: 6×6 interval data at `h=0.004`, `T=100`
  (`t=1.596e-3`); the smallest minor is `~4·10⁻¹⁰`, hence not Lean-certified.
- No truncated series is used where a bound is available; the interval
  certificates are exact rational centre/error checks on the recorded boxes.

## 8. What not to claim (while it remains true)

- Do not claim an RH proof until it gets proven. Use the phrase **No RH proof yet.** to state that it hasn't been proven yet, until it is proven.
- Do not claim the explicit formula is formalised; only its pole terms, the
  symbol identity, the prime-side von Mangoldt sum, and the argument-principle
  chain are.
- Do not claim the infinite cone positivity; only the finite 2×2/4×4 rungs.
- Do not claim the 6×6 Lean certificate; it is numerical only.
- Do not claim the Hadamard factorisation unconditionally; the order-1 growth
  of `f/P` is open (the polynomial case is covered).
- Do not claim the Bost–Connes infinite-level compatibility; only finite
  levels are formalised.
