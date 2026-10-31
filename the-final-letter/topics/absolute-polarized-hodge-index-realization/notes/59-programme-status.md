# Note 59 — programme status: the verified chain and the open frontier

**Status: No RH proof yet.** This note is a synthesis of the
absolute-polarized Hodge-index programme after rounds 250–328. It separates
what is **Lean-checked**, what is **numerical**, what is **text-proof**, and
what remains **open**.

## 1. The verified chain (Lean-checked, 549 declarations, 9 files)

### Contour argument principle

- **Circles** (`lean/Symbol.lean`): base winding integral, outside case,
  product count, simple zero, zero-free, multi-zero, simple pole, divisor form.
- **Rectangles** (`lean/Rectangle.lean`): `rectIntegral`, Cauchy–Goursat
  (including the off-countable form), winding integral, product/divisor forms,
  simple-zero and multiplicity counts via the quotient construction, and the
  **divisor-derived count** `rectIntegral_logDeriv_eq_divisor_sum_of_analytic`
  (finite support, values = analytic orders).
- **Cauchy integral formula on a rectangle**:
  `rectIntegral_mul_inv_sub_eq` (`∮ h(z)/(z−a) dz = 2πi·h(a)`).

### Completed zeta

- Symbol identity (`arch + L_Λ = −Z'/Z` for `Re > 1`), conjugation and
  anti-symmetry, critical-line reality, zero quadruple, pole residues,
  log-derivative symmetries, three RH formulations.
- Digamma continuity/differentiability on `Re > 0`
  (`continuousAt_digamma_of_re_pos`).

### Explicit formula, `h ≡ 1`

- Prime side: termwise integration (`integral_lseries_vonMangoldt`, closed
  form `integral_natCast_cpow_vertical`), archimedean symbol.
- Exact horizontal difference: `bottom = −top`, `bottom = conj top`,
  `top = −conj top`, `bottom = −conj bottom` — no Stirling estimates.
- Functional-equation reflection of the left side.
- Assembly: `explicit_formula_h1_symmetric` and its divisor-derived form
  `explicit_formula_h1_symmetric_divisor`.

### Explicit formula, test function

- Local residue subtractions: `exists_analyticAt_logDeriv_mul_sub_residue`
  (zero), `exists_analyticAt_logDeriv_mul_add_residue_pole` (pole), with zeta
  instances.
- Finite patching: `exists_analyticOnNhd_of_differentiableOn_compl_finset`.
- Global remainder: `exists_analyticOnNhd_globalRemainder`,
  `differentiableOn_globalRemainder`.
- Boundary decomposition: `logDeriv_mul_eq_remainder_plus_residues`.
- Residue sum and assembly: `rectIntegral_sum_const_inv_sub`,
  `rectIntegral_logDeriv_mul_eq_residue_sum`.
- **Zero side for arbitrary `h`**: `test_function_explicit_formula`
  (`∮ (Z'/Z)·h = 2πi(∑_ρ h(ρ) − h(0) − h(1))`), plus the linear case.
- **Prime side**: pointwise (`logDeriv_mul_I_eq_neg_arch_add_prime`),
  integrated (`integral_logDeriv_mul_I_eq_neg_arch_prime'`), and termwise
  against a continuous factor (`integral_lseries_vonMangoldt_mul`).
- **Rectangle derivative Cauchy formula**: `rectIntegral_mul_inv_sq_eq`
  (`∮ h·((z−a)²)⁻¹ = 2πi·h′(a)`), with the inverse-square winding
  `rectIntegral_inv_sq_eq_zero` and the inverse-cube winding
  `rectIntegral_inv_cube_eq_zero` (prerequisite for the second-derivative
  formula).
- **Contour shift for symmetric test functions**: `Left = −Right`,
  `Bottom = conj(Top)`, and the assembled identity
  `contour_shift_symmetric'`:
  `(∑_ρ h(ρ) − h(0) − h(1))·2πi = 2i·Right − 2i·Im(Top)`.

### Fourier layer (critical-line route)

- `fourierG`, `fourierG_even`, `fourierG_conj`, `continuous_fourierG`,
  `norm_fourierG_le` — the Fourier transform of a compactly supported
  function, its symmetries, continuity and `L¹` bound.
- Prime measure in Fourier form: `integral_lseries_vonMangoldt_fourier`,
  `integral_natCast_cpow_vertical_fourier`,
  `integral_lseriesTerm_vonMangoldt_fourier`,
  `integral_lseries_vonMangoldt_fourier_closed` (and its named form
  `..._closed'` with `fourierCoeffClosed`).
- The integrated `Z'/Z` with Fourier kernel:
  `integral_logDeriv_mul_I_eq_neg_arch_prime_fourier` and its closed form
  `..._fourier_closed`.

### Concrete instance

`gaussianTest` (and `contour_shift_gaussian`) for
`h(s) = exp(−(s−1/2)²/1000)` — a finite-`T` instance.

## 2. Numerical layer (185 tests)

Symbol and log-derivative symmetries, pole residues, circle/rectangle argument
principle counts, winding integrals, the completed-zeta count
`∮ Z'/Z = 2πi·4`, the vertical term integral, the termwise prime side
(`7·10⁻⁸`), the residue limits (`1` at a simple zero, `−1` at the poles), the
horizontal reflection (`4·10⁻³²`), and the test-function zero side for
`h = 1, s, s², eˢ`, cross-checked on a second rectangle and for the
Paley–Wiener example `2 sin(s−1/2)/(s−1/2)` (relative `10⁻¹⁷`).

## 3. Text-proof remainder

1. **The critical-line route**: the classical Weil explicit formula is stated
   for a test function `h(t)` on the critical line, with the Fourier transform
   of the prime measure (see note 60). This is *not* a `T → ∞` limit of the
   holomorphic contour identity: a holomorphic test function with sufficient
   horizontal decay cannot exist (Liouville), and the Paley–Wiener functions
   `∫ g(u)e^{i(s−1/2)u}du` grow like `e^{a|Im s|}`. The Fourier and prime-side
   ingredients are Lean-checked (see the Fourier layer above); the archimedean
   integral, Fourier inversion and the assembled explicit formula on the line
   remain.
2. **The external *Angular Bochner framework* note** (note 61) independently
   confirms the boundary: finite-stage Bochner/sector Gram matrices are
   unconditionally PSD, but uniform undamping is equivalent to Weil
   positivity/RH and no new fact about the zeros is proved.
2. **Gaussian caveat**: `exp(−(s−1/2)²/1000)` grows along horizontal lines, so
   `contour_shift_gaussian` is a finite-`T` identity only (note 58, §6).

## 4. The open frontier: Weil positivity

Even with the full explicit formula, RH requires **Weil's criterion**:
the Weil functional

```
W(h) = ∑_ρ h(ρ) − (archimedean term) − (prime term)
```

is positive (or nonnegative) for every test function `h` whose Fourier
transform is supported in `[−1/2, 1/2]`, with `h` satisfying the reflection
symmetry. Equivalently, the infinite-level cone positivity of the arithmetic
Hodge-index programme. This is the genuinely open statement; the contour
identities above are its analytic prelude, not its proof. **No RH proof yet.**
