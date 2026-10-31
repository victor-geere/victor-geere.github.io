# Note 62 — programme synthesis (round 365)

**Status: No RH proof yet.** This note is a consolidated, honest summary of the
absolute-polarized Hodge-index programme as formalised and verified up to
journal round 432: 549 Lean declarations in 9 files, 185 Python tests, and
notes 1–61.

## 1. What is Lean-checked

### 1.1 The algebraic core (`Rescue.lean`, `Shadow.lean`)

- The local rank-three Hodge-index realization.
- The finite cone positivity rungs: the 4×4 Gaussian Weil Gram shadow is
  positive definite from the rational centre, the exact LDLᵀ factorisation and
  the interval box.
- Three Lean-checked equivalent formulations of RH (including the absence of
  zeros in `0 < Re s < 1/2`).

### 1.2 Hadamard/Weierstrass (`Hadamard.lean`)

Canonical products, convergence, divisors, Jensen, zero-free logs, the quotient
normal form, `f = P·exp g`, variable order/divisor, order-1 growth conditions.

### 1.3 Symbol layer (`Symbol.lean`)

The explicit-formula symbol `M = −Z'/Z` on `Im ξ > 1`, continued to `s ≠ 1`,
and on the critical line; conjugation, anti-symmetry `M(1−s) = −M(s)`, and the
pure-imaginary property `M(1/2+it) = −conj M(1/2+it)`; completed-zeta
conjugation, reflection, zero-quadruple and log-derivative symmetries; finite
conjugation-paired zero sums real.

### 1.4 Contour layer (`Rectangle.lean`)

- Rectangle boundary integral, linearity, congruence, Cauchy–Goursat.
- Winding integrals: `∮(z−a)⁻¹ = 2πi` (inside), `0` (outside); **inverse-square
  and inverse-cube windings vanish** (`∮(z−a)⁻ⁿ = 0`, `n = 2, 3`).
- The rectangle **Cauchy formula** `∮ h/(z−a) = 2πi·h(a)` and the rectangle
  **derivative Cauchy formula** `∮ h/(z−a)² = 2πi·h′(a)`, with the
  completed-zeta instances `∮ Z/(z−a) = 2πi·Z(a)`,
  `∮ Z/(z−a)² = 2πi·Z′(a)`.
- The argument principle: product count, simple-zero local-to-global,
  zero-free, multi-zero, simple pole, divisor forms on circles and rectangles;
  the divisor-derived count `∮ f'/f = 2πi·∑ div`; the completed-zeta instances.

### 1.5 Explicit-formula chain (`ExplicitFormula.lean`)

- **Zero side**: `test_function_explicit_formula`
  (`∮ Z'/Z·h = 2πi(∑_ρ h(ρ) − h(0) − h(1))`) with local residue subtractions,
  finite patching, global remainder, and residue assembly; instances for
  `h ≡ 1`, `h = s`, `h = s²`, `h = (s−1/2)²`.
- **Prime side**: pointwise, integrated, and termwise against a continuous
  factor; the closed vertical term integral; the closed prime sum.
- **`h ≡ 1` assembly**: `explicit_formula_h1_symmetric` and its divisor form,
  with the **exact horizontal reflection** `bottom = −top = conj(top)` (no
  Stirling estimates).
- **Contour shift** for holomorphic symmetric test functions
  (`contour_shift_symmetric'`), with Gaussian and quadratic instances.
- **Fourier layer**: `fourierG` symmetries/continuity/`L¹` bound, full
  linearity (`add`, `sub`, `neg`, `const_mul`, `zero`, `finset_sum`) and the closed transforms `∫_{−1}^{1} e^{−ixu}du = 2 sin x/x` (`fourierG_one_eq`) and
  `∫_{−1}^{1} e^{bu}e^{−ixu}du = (e^{b−ix} − e^{−b+ix})/(b−ix)`
  (`fourierG_exp_eq`), `∫_{−1}^{1} e^{iau}e^{−ixu}du = 2 sin(a−x)/(a−x)`
  (`fourierG_exp_I_eq`), and their constant/scaled corollaries
  (`fourierG_const_eq`, `fourierG_const_mul_exp_I_eq`), the cosine
  transform `fourierG_cos_eq`, and the sine transform `fourierG_sin_eq`, the identity transform
  `fourierG_id_eq`, and the square transform `fourierG_sq_eq`, with their `x = 0` values, the cube transform `fourierG_cube_eq` and the trigonometric `x = 0` values, and the modulation property
  `fourierG_modulation`, the conjugation shift `fourierG_conj_shift`, and the
  derivative correspondence (`deriv_fourierG`, `hasDerivAt_fourierG_moment`, `iteratedDeriv_fourierG`), the Riemann–Lebesgue decay `norm_fourierG_le_div`, the limit `tendsto_fourierG_atTop`, the `C²` decay `norm_fourierG_le_div_sq`, the full-line Fourier bridge (`fourier_fourierGExt`), the conditional inversion `fourier_inversion_conditional`, the unconditional **Fourier inversion `fourier_inversion`**, the Paley–Wiener test function with its symmetries and entirety, and the assembled contour-shift identity `contour_shift_paleyWiener`;
  the prime measure in Fourier form (termwise, closed coefficient, closed
  term, full closed sum), `u = 0` consistency and its equality with
  `primeSide`; the Fourier-kernel and closed `Z'/Z` identities (and their
  `u = 0` cases).
- **Archimedean critical line**: `digamma_add_conj_critical`,
  `archimedeanTerm_critical_line_real`, `integral_archimedean_term_real`,
  `conj_integral_archimedean_fourier`.

### 1.6 Archimedean layer (`Archimedean.lean`)

`digamma_conj`, analyticity/differentiability/continuity of `Γ` and `ψ` on
`Re > 0`, and the critical-line digamma sum and realness.

## 2. Numerical layer (185 tests)

- The test-function formula for `h = s`, `s²`, and the rational
  `1/((s−5)²+1)` (agreement `10⁻⁷`–`10⁻⁸`).
- The contour shift for the Gaussian (`10⁻¹⁰`), the quadratic (`10⁻⁷`), and
  the Paley–Wiener `2 sin(s−1/2)/(s−1/2)` (relative `10⁻¹⁷`).
- The residue limits `(s−ρ)Z'/Z → 1`, `(s−p)Z'/Z → −1`.
- The closed Fourier prime sum at `u = 0.7` and `u = 1.5` (agreement
  `1.2·10⁻⁷`, `4.1·10⁻⁸`) and the assembled closed Fourier identity at
  `u = 0.7` (`1.2·10⁻⁷`); the closed transform `2 sin x/x` (`10⁻²⁰`).
- The archimedean-integral reality for a Gaussian test function.
- The winding, inverse-square and inverse-cube integrals; the derivative
  and second-derivative Cauchy formulas (`∮ h/(z−a)² = 2πi h′(a)`,
  `∮ h/(z−a)³ = πi h″(a)`); and the completed-zeta Cauchy instances.

## 3. The open frontier

1. ~~Fourier inversion~~ — **DONE (note 64)**: `fourier_inversion` gives
   `𝓕⁻ (𝓕 g_ext) u = g u` for `C²` `g` with `g(±1)=0` and `u ∈ (−1,1)`,
   by bridging to Mathlib's full-line inversion theorem.
2. **The assembled explicit formula on the critical line** with the
   archimedean, prime and zero terms and the constants fixed from Weil 1972 /
   Iwaniec–Kowalski Thm 5.12 (notes 60 and 65). The prime-side constant needs
   the contour/residue argument (the naive Fourier interchange is only
   distributional).
3. **Weil's criterion / uniform infinite-level cone positivity** — the
   genuinely open, RH-equivalent statement. The finite rungs are Lean-checked;
   the 6×6 interval certificate is numerical only; the external *Angular
   Bochner framework* note (note 61) independently confirms that uniform
   undamping is equivalent to Weil positivity and that finite-stage positivity
   is classical.

## 4. What would be needed to go further

- The **distributional prime-side identity** via the contour/residue
  argument, and the archimedean normalisation (note 65).
- The **archimedean integral against a general test function** and its
  assembly with the prime sum on the critical line.
- A genuinely new idea for **uniform positivity** — which, per note 61, must
  lie outside the finite angular/Bochner calculus.

**No RH proof yet.**
