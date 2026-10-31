# Note 56 — the explicit-formula chain: formalisation status

**Status: No RH proof yet.** This note consolidates the contour/explicit-formula
chain built in rounds 250–295. It distinguishes **Lean-checked**, **numerical**,
and **text-proof** claims.

## 1. Contour argument principle (Lean-checked)

Circles (`lean/Symbol.lean`):

- base case `circleIntegral_sub_inv_linear` and the outside case
  `circleIntegral_sub_inv_eq_zero`;
- linearity, congruence, the product count `circleIntegral_logDeriv_prod(_eq)`;
- local-to-global simple zero `circleIntegral_logDeriv_simple_zero`, zero-free
  `circleIntegral_logDeriv_eq_zero`, multi-zero `circleIntegral_logDeriv_mul_prod`;
- simple pole `circleIntegral_logDeriv_simple_pole`;
- divisor form `circleIntegral_logDeriv_div_prod`.

Rectangles (`lean/Rectangle.lean`):

- `rectIntegral`, Cauchy–Goursat (`rectIntegral_eq_zero_of_differentiableOn`,
  and the off-countable form), linearity and congruence;
- winding integral: `rectIntegral_inv_of_mem` (`∮ dz/(z−w) = 2πi` inside),
  `rectIntegral_inv_of_not_mem` (zero outside);
- product count `rectIntegral_logDeriv_prod_eq` and divisor form
  `rectIntegral_logDeriv_div_prod`;
- simple-zero count `rectIntegral_logDeriv_eq_card_of_simple_zeros`;
- **multiplicity quotient construction** (`polyProdPow`,
  `quotientExtensionPow`, `exists_eventuallyEq_pow_mul_of_order`) and the
  multiplicity count `rectIntegral_logDeriv_eq_sum_multiplicity`;
- **divisor-derived count** `rectIntegral_logDeriv_eq_divisor_sum_of_analytic`:
  the zero set and multiplicities come from Mathlib's meromorphic divisor
  (`divisor_openRect_support_finite`, `analyticOrderNatAt_eq_divisor_toNat`);
- zeta zero side `rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`:
  `∮ Z'/Z = 2πi·(∑ div − 2)` with the zeros derived, the `−2` from the poles
  at `0,1`.

## 2. Completed zeta (Lean-checked, `lean/Symbol.lean`)

Symbol identity (Im ξ > 1, continued, critical-line form), conjugation,
anti-symmetry, critical-line reality, the zero quadruple, pole residues
`1` at `s=1` and `−1` at `s=0`, log-derivative symmetries, and three
equivalent RH formulations.

## 3. Prime side (Lean-checked, `lean/ExplicitFormula.lean`)

- vertical modulus `‖n^{-(c+iy)}‖ = n^{-c}`, continuity of the terms, majorant
  summability;
- term-by-term integration `integral_lseries_vonMangoldt`;
- closed form `integral_lseries_vonMangoldt_closed`:
  `∫_{y₁}^{y₂} L_Λ(c+iy)dy = Σ′_n iΛ(n)(n^{-(c+iy₂)} − n^{-(c+iy₁)})/log n`.

## 4. Horizontal sides (Lean-checked — exact, no Stirling estimates)

On the symmetric rectangle `[1−x₂, x₂] × [−T,T]`:

- `integral_logDeriv_completedZeta_bottom_eq_neg_top`: `bottom = −top`
  (change of variable `x ↦ 1−x` plus the functional equation);
- `integral_logDeriv_completedZeta_bottom_eq_conj_top`: `bottom = conj(top)`;
- `integral_logDeriv_completedZeta_top_pure_imaginary`: `top = −conj(top)`;
- `integral_logDeriv_completedZeta_bottom_pure_imaginary`: `bottom = −conj(bottom)`.

Hence the horizontal difference is exactly `−2·top = 2·bottom`, a purely
imaginary quantity. **Text-proof (not formalised):** with a continuous branch
of `log Z` along the top side, `top = 2i·Im log Z(x₂+iT)` modulo the winding
integer, i.e. the horizontal contribution is an argument of `Z` at one corner.

## 5. Left vertical side (Lean-checked)

`integral_logDeriv_completedZeta_left_side` and
`integral_logDeriv_completedZeta_left_eq_neg_right`: the functional-equation
reflection `(Z'/Z)(1−s) = −(Z'/Z)(s)` reduces the left side to minus the right
side over the reflected interval.

## 6. Assembly (Lean-checked)

- `integral_logDeriv_completedZeta_right_side'` (unconditional): the right
  vertical side equals `i·(∫ archSymbol − primeSide)`;
- `explicit_formula_h1_symmetric_exact`: the horizontal difference replaced by
  `2·bottom`;
- **`explicit_formula_h1_symmetric_divisor`**: for `g = s(s−1)Z` analytic on a
  neighbourhood of the rectangle with finite order and all zeros in the open
  rectangle,

  `(∑_{w∈S} div(w) − 2)·2πi = 2·bottom + 2·(∫ archSymbol − primeSide)·i`,

  where `S` is the divisor support. This is the `h ≡ 1` explicit formula with a
  divisor-derived zero side.

## 7. Numerical layer

`tests/test_rescue.py` (173 cases) includes: symbol and log-derivative
symmetries, pole residues, circle argument-principle counts (including simple
poles and divisor forms), rectangle winding integrals, the completed-zeta count
(`∫ Z'/Z = 2πi·4` on `[−1,2]×[−30,30]` with six zeros), the vertical term
integral, the termwise prime-side interchange, and the exact horizontal
reflection (`|bottom + top| < 4·10⁻³²`, `|top + conj top| < 10⁻³¹`).

## 8. What is not formalised

- The **test-function version** `∮ (Z'/Z)·h`: the Cauchy integral formula on a
  rectangle (`rectIntegral_mul_inv_sub_eq`) and the simple-zero residue
  (`tendsto_sub_mul_logDeriv_of_simple_zero`, zeta instance
  `tendsto_sub_mul_logDeriv_completedZeta_zero`) and the simple-pole residue
  `tendsto_sub_mul_logDeriv_of_simple_pole` are Lean-checked; the zeta pole extensions (residues `1` at `1`, `−1` at `0`) are now
  Lean-checked (`poleExtensionOne`, `poleExtensionZero`) with the pole residues
  of `Z'/Z` equal to `−1`, and the local residue subtractions
  `exists_analyticAt_logDeriv_mul_sub_residue` (zero; closed form
  `dslope h ρ + h·logDeriv g`) and
  `exists_analyticAt_logDeriv_mul_add_residue_pole` (pole; closed form
  `h·logDeriv F − dslope h p`), with zeta instances at `1` and `0`, the residue sum
  `rectIntegral_sum_const_inv_sub`, and the residue assembly
  `rectIntegral_logDeriv_mul_eq_residue_sum`. The **pole-free form**
  `logDeriv_completedZeta_eq_logDeriv_poleExtension` reduces the global
  remainder to
  `Ψ = h·F'/F − Σ h(ρ)/(s−ρ) − dslope h 0 − dslope h 1`; the **finite patching**
  `exists_analyticOnNhd_of_differentiableOn_compl_finset` assembles these germs
  into one analytic function on the whole neighbourhood. The complete
  test-function formula is additionally verified numerically for `h(s) = s` on
  `[−1,2]×[−30,30]` (both sides `4πi`) and for `h(s) = s²` (both sides
  `−15921.712…i`), and the global remainder is numerically bounded near a
  simple zero. Numerically the residue limits converge
  linearly to `1` (simple zero) and `−1` (poles).
- The **branch/winding closed form** of the horizontal contribution.
- **Weil's criterion and the infinite-level cone positivity.** The concrete
  contour identities above are not the Weil positivity statement; the
  arithmetic Hodge-index/cone positivity at infinite level remains open, and
  with it the Riemann hypothesis. **No RH proof yet.**
