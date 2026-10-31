# Absolute polarized Hodge-index realization

**Status:** research programme, **reopened in round 45 and formalised in
round 49**. The **local** rank-three Hodge-index realization is Lean-backed
(sibling `Topic.lean`). The **absolute/global** realization is not achieved.
The recorded normalization of the global functional is falsified: it is
sign-indefinite on exact tests. The exact compact-support test (no grid
truncation, no missing weights) supports the sibling's **cosh \(+\Omega\)
form**: its \(4\times4\) Gram is positive semidefinite
(\(0,1.1\cdot10^{-7},9.98\cdot10^{-5},1.67\cdot10^{-3}\)), while the
\(-\Omega\) form has a small negative residual. The earlier \(-\Omega\)
verdict was a missing-quadrature-weight artefact. **Interval certificates now exist for the
\(2\times2\), \(4\times4\), \(6\times6\) and \(8\times8\) Gaussian Gram
matrices** (cosh \(+\Omega\)), via a fast recurrence/Binet \(\Omega\) enclosure and
exact rational leading-minor checks. The \(6\times6\) certificate at
\(h=0.005\), \(T=100\) was recomputed in round 133 (uncertainty
\(t=2.49\cdot10^{-3}\), smallest leading minor \(2.37\cdot10^{-10}>0\)); the
margin is thin, so it is recorded as a one-off certificate rather than a
default test. The compact-support rung has an interval-certified **positive** diagonal
entry (\(W_{00}\in[4.44\cdot10^{-5},3.86\cdot10^{-4}]\), note 47); it is not
a PSD certificate.
The finite-rung margin **collapses** as the basis grows (note 45), so finite
positive-definite certificates cannot reach the cone. The algebraic core is Lean-checked in
[`lean/Rescue.lean`](lean/Rescue.lean); the analytic identities and all
eigenvalues are text proofs or computations, not Lean. **No RH proof yet.**
See [`notes/38-rescue.md`](notes/38-rescue.md) and
[`notes/39-broad-test-discrepancy.md`](notes/39-broad-test-discrepancy.md).

**Current state (round 273).** The Hadamard/Weierstrass factorisation is
Lean-checked up to the order-1 growth of the quotient `f/P`: canonical
product, quotient normal form, `f = P·Q`, `f = P·exp g`, and the affine
refinement conditional on `HasLogGrowthOne (f/P)`. The order-1 class is
closed under products, finite products, powers, scalar multiples, controlled
division, affine reparametrisation, zero-free sums, and constant shifts, and
contains every complex polynomial. The symbol symmetry chain is Lean-checked:
identity (on `Im ξ>1`, continued to `s ≠ 1`, and on the critical line,
including the explicit form `M(1/2+it) = -(Z'/Z)(1/2+it)`), conjugation,
anti-symmetry `M(1-s) = -M(s)`, and the pure-imaginary property
`M(1/2+it) = -conj(M(1/2+it))`. The completed zeta has Lean-checked
conjugation, reflection, zero-quadruple and log-derivative symmetries, is real
on the critical line, and its log-derivative is purely imaginary there. Finite
conjugation-paired zero sums are real. RH has three Lean-checked equivalent
formulations, including the absence of zeros in `0 < Re s < 1/2`. These
structural layers are confirmed numerically. The RH-relevant frontier remains
the **global cone positivity** (Weil's criterion), which needs the
distributional explicit formula; the Bost–Connes level compatibility and the
scaling-site Riemann–Roch/Hodge index are also open. A consolidated assessment is in
[`notes/54-final-assessment.md`](notes/54-final-assessment.md), and the continuing
research entry point is [`HANDOFF.md`](HANDOFF.md). The finite
cone positivity is now formalised: the 4×4 Gaussian Weil Gram shadow is
positive definite, Lean-checked from the rational centre, the exact LDLᵀ
factorisation and the interval box
([`notes/55-cone-positivity-import.md`](notes/55-cone-positivity-import.md)).
The **circle-contour argument principle is complete** and Lean-checked:
`circleIntegral_logDeriv_prod_eq` (product count), `circleIntegral_logDeriv_simple_zero`
(local-to-global), `circleIntegral_logDeriv_eq_zero` (zero-free),
`circleIntegral_logDeriv_mul_prod` (multi-zero), `circleIntegral_logDeriv_simple_pole`
(simple pole, `∮ f'/f = -2πi`) and the divisor form
`circleIntegral_logDeriv_div_prod` (`∮ f'/f = 2πi·(#zeros - #poles)`).
The **rectangle contour layer** is also Lean-checked in
[`lean/Rectangle.lean`](lean/Rectangle.lean): linearity and congruence of the
rectangle boundary integral, the rectangle Cauchy–Goursat theorem, the
zero-free log-derivative integral, and the **winding integral**
`rectIntegral_inv_of_mem` (`∮ dz/(z-w) = 2πi` for `w` strictly inside) /
`rectIntegral_inv_of_not_mem` (`= 0` for `w` outside). The contour identity itself is now Lean-checked in the rectangle form:
**`rectIntegral_logDeriv_div_prod`** — for `f = P_Z·P_P⁻¹·h` with zeros `Z`
and poles `P` strictly inside the rectangle and `h` differentiable and
zero-free near it, `∮ f'/f = 2πi·(#Z − #P)` — together with the product count
`rectIntegral_logDeriv_prod_eq` and the boundary-only linearity lemmas. The analytic divisor is now built as well: the **quotient extension**
(`polyProd`, `quotientExtension`, removable values, analyticity at simple
zeros), the **argument principle for analytic functions with simple zeros**
(`rectIntegral_logDeriv_eq_card_of_simple_zeros`: `∮ f'/f = 2πi·#S` when the
zeros in an open set containing the rectangle are exactly the simple set `S`),
and its zeta instance
**`rectIntegral_logDeriv_completedZeta_eq_card`**: `∮ Z'/Z = 2πi·(#S − 2)` over
the rectangle, the **zero side of the explicit formula**. The multiplicity
form is Lean-checked as well: **`rectIntegral_logDeriv_eq_sum_multiplicity`**
(`∮ f'/f = 2πi·∑ m w` when `f = (∏(z-w)^{m w})·q` with `q` zero-free) and
**`rectIntegral_logDeriv_completedZeta_eq_sum`** (`∮ Z'/Z = 2πi·(∑ m − 2)`
without assuming simple zeros). The quotient factorisation is now
*constructed* from the analytic order rather than assumed:
**`rectIntegral_logDeriv_eq_divisor_sum`** and
**`rectIntegral_logDeriv_completedZeta_eq_divisor_sum`** give the same counts
from the order data `analyticOrderNatAt f w = m w`, so the only remaining
hypotheses are the zero-set/order description and the absence of other zeros
in the chosen neighbourhood. The **prime side** is started in
[`lean/ExplicitFormula.lean`](lean/ExplicitFormula.lean): the vertical modulus
identity `‖n^{-(c+iy)}‖ = n^{-c}`, continuity of the von Mangoldt terms, the
majorant summability, and **`integral_lseries_vonMangoldt`** — term-by-term
integration of `L_Λ` on a vertical segment `Re s = c > 1` — and the
**closed-form term evaluation**
`integral_natCast_cpow_vertical` / `integral_lseries_vonMangoldt_closed`:
`∫_{y₁}^{y₂} n^{-(c+iy)}dy = i(n^{-(c+iy₂)} − n^{-(c+iy₁)})/log n`, so the
prime side is a closed von Mangoldt sum. The **right vertical side** is then
assembled and now **unconditional**:
`integral_logDeriv_completedZeta_right_side'` gives
`∫ (Z'/Z)(c+iy)·i dy = i·(∫ arch − Σ′ term_n)` for every `c > 1`, combining
the symbol identity with the closed-form prime side; the integrability is
discharged by `continuousOn_lseries_vonMangoldt` and
`continuousOn_logDeriv_completedZeta`. The **left vertical side** is now Lean-checked too:
`integral_logDeriv_completedZeta_left_side` uses the substitution `y ↦ −y` and
the reflection `(Z'/Z)(1−s) = −(Z'/Z)(s)` to reduce the left side of a
rectangle with `1 < x₂ < 3` to minus the right side over the reflected
interval. The **assembly** is Lean-checked for the `h ≡ 1` contour on a symmetric
rectangle: `explicit_formula_h1_symmetric` gives
`(Σ m − 2)·2πi = (bottom − top) + 2·(∫ archSymbol − primeSide)·i`, combining
the zero side, the unconditional right side and the reflected left side.
The **horizontal difference is computed exactly, with no Stirling-type
estimate**: `integral_logDeriv_completedZeta_bottom_eq_neg_top` shows that the
bottom horizontal integral equals minus the top one (change of variable
`x ↦ 1−x` plus the functional equation), so the assembly becomes
**`explicit_formula_h1_symmetric_exact`**:
`(Σ m − 2)·2πi = 2·bottom + 2·(∫ archSymbol − primeSide)·i`.
The top side is **formally** purely imaginary as well:
`integral_logDeriv_completedZeta_bottom_eq_conj_top` (`bottom = conj(top)`)
and `integral_logDeriv_completedZeta_top_pure_imaginary`
(`top = −conj(top)`), so the horizontal difference is
`−2·top = 2·bottom`, an exact purely imaginary quantity.
The zero set is now **derived from `f` itself** rather than assumed:
`rectIntegral_logDeriv_eq_divisor_sum_of_analytic` uses Mathlib's meromorphic
divisor on the open rectangle (finite support, values equal to the analytic
orders) to produce the Finset `S` and the multiplicities, giving
`∮ f'/f = 2πi·∑_{w∈S} div(w)` under analyticity, finite order, and the
condition that all zeros in `U` lie in the open rectangle. The zeta instance
**`rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`** gives
`∮ Z'/Z = 2πi·(∑ div − 2)` with the zeros counted by the divisor — the zero
side of the explicit formula no longer assumes its divisor.
The **full `h ≡ 1` explicit formula** is now Lean-checked with the zero side
derived from the divisor:
`explicit_formula_h1_symmetric_divisor` states
`(∑ div − 2)·2πi = 2·bottom + 2·(∫ archSymbol − primeSide)·i` for the
symmetric rectangle, under only analyticity, finite order and the choice of a
neighbourhood `U` whose zeros lie in the rectangle. What remains is the
infinite-level Weil cone positivity. The consolidated status of the whole
chain is in [`notes/56-explicit-formula-chain.md`](notes/56-explicit-formula-chain.md);
the test-function formula and the remaining prime-side gap are described in
[`notes/57-test-function-formula-and-prime-side.md`](notes/57-test-function-formula-and-prime-side.md),
the contour-shift derivation for symmetric test functions in
[`notes/58-contour-shift-symmetric-test-functions.md`](notes/58-contour-shift-symmetric-test-functions.md),
a full programme-status synthesis (verified chain, numerical layer,
text-proof remainder, open frontier) in
[`notes/59-programme-status.md`](notes/59-programme-status.md), the
critical-line route to the classical Weil explicit formula in
[`notes/60-critical-line-route.md`](notes/60-critical-line-route.md) (with the
critical-line archimedean realness
`archimedeanTerm_critical_line_real`, the reality of the archimedean
integral `integral_archimedean_term_real`, numerically confirmed for
`h(t) = e^{−t²}`, and its Fourier conjugate symmetry
`conj_integral_archimedean_fourier`), and the closed prime Fourier coefficient
with its boundary-difference properties (`fourierCoeffClosed`,
`fourierCoeffClosed_self`, `fourierCoeffClosed_add`, numerically confirmed at
`u = 0.7` against the direct integral to `1.2·10⁻⁷`), and the assembled closed
Fourier identity `integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed`
(numerically confirmed to `1.2·10⁻⁷`), and the
external *Angular Bochner framework* note (with its explicitly limitative
boundary) in
[`notes/61-angular-bochner-framework.md`](notes/61-angular-bochner-framework.md). Its
Lean ingredients now include the Fourier-transform symmetries
`fourierG_even`/`fourierG_conj` and the regularity/boundedness
`continuous_fourierG`/`norm_fourierG_le`, the Fourier form of the
prime-measure identity `integral_lseries_vonMangoldt_fourier`, the closed
Fourier coefficient `integral_natCast_cpow_vertical_fourier`, the closed
Fourier term `integral_lseriesTerm_vonMangoldt_fourier`, the full closed
Fourier form `integral_lseries_vonMangoldt_fourier_closed`, and the
Fourier-kernel prime-side identity
`integral_logDeriv_mul_I_eq_neg_arch_prime_fourier`.
Its pointwise cores and the integrated left reflection are Lean-checked:
`logDeriv_mul_one_sub`, `logDeriv_mul_conj`,
`integral_logDeriv_mul_left_eq_neg_right_two` and
`integral_horizontal_bottom_eq_conj_top_two`, and their assembly is
`contour_shift_symmetric` (`(Σh − h(0) − h(1))·2πi = 2i·Right − 2i·Im(Top)`), with
the reflection hypotheses discharged in `contour_shift_symmetric'`. The finite-`T` identity
is numerically confirmed for the quadratic symmetric test function
`h(s) = (s−1/2)²` (agreement `10⁻⁷`) and is Lean-checked for the concrete symmetric test function
`h(s) = exp(−(s−1/2)²/1000)` (`contour_shift_gaussian`) and confirmed
numerically. Note that this Gaussian grows along horizontal lines, so the
`T → ∞` limit requires a Paley–Wiener test function (see note 58, §6); the
identity is numerically confirmed for the Paley–Wiener example
`h(s) = 2 sin(s−1/2)/(s−1/2)`. The passage to the classical explicit formula
is **not** a `T → ∞` limit of this holomorphic identity (holomorphic test
functions cannot decay horizontally; see note 58, §6): the classical formula
is derived on the critical line with the Fourier transform of the prime
measure.
The **Cauchy integral formula on a rectangle** is now Lean-checked
(`rectIntegral_mul_inv_sub_eq`: `∮ h(z)/(z−a) dz = 2πi·h(a)`), the key tool
for the test-function version of the explicit formula, together with the
**simple-zero residue** `tendsto_sub_mul_logDeriv_of_simple_zero`
(`(s−ρ)·f'/f → 1` at a simple zero) and its zeta instance
`tendsto_sub_mul_logDeriv_completedZeta_zero`, and the **simple-pole residue**
`tendsto_sub_mul_logDeriv_of_simple_pole` (`(s−p)·f'/f → −1`). The zeta pole
extensions are built (`poleExtensionOne`, `poleExtensionZero`) and the pole
residues of `Z'/Z` are Lean-checked:
`tendsto_sub_mul_logDeriv_completedZeta_pole_one` and
`tendsto_mul_logDeriv_completedZeta_pole_zero` (both `→ −1`). All local
residue data for the test-function explicit formula are now formalised, and
the **local residue subtractions** are Lean-checked in closed form:
`exists_analyticAt_logDeriv_mul_sub_residue` (the germ `dslope h ρ + h·logDeriv g`
agrees off `ρ` with `(f'/f)·h − h(ρ)/(s−ρ)`) and
`exists_analyticAt_logDeriv_mul_add_residue_pole` (the germ
`h·logDeriv F − dslope h p` agrees off `p` with `(f'/f)·h + h(p)/(s−p)`),
with the zeta instances at `1` and `0`. The **residue sum** for simple
fractions is also Lean-checked: `rectIntegral_sum_const_inv_sub`
(`∮ ∑ c(w)/(z−w) dz = (∑ c(w))·2πi`) and the **residue assembly**
`rectIntegral_logDeriv_mul_eq_residue_sum` (boundary decomposition
`(Z'/Z)·h = ψ + ∑ c(w)/(z−w)` with `∮ψ = 0` ⇒ `∮(Z'/Z)·h = (∑ c(w))·2πi`).
The **pole-free form** `logDeriv_completedZeta_eq_logDeriv_poleExtension`
(`Z'/Z = F'/F − 1/s − 1/(s−1)` for `F = s(s−1)Z`) reduces the global remainder
of the test-function formula to
`Ψ = h·F'/F − Σ_ρ h(ρ)/(s−ρ) − dslope h 0 − dslope h 1`, which is analytic off
the zeros with removable singularities at them; its differentiability off the
zero set is Lean-checked (`differentiableOn_globalRemainder`), and it has an
analytic extension on a neighbourhood of the rectangle
(`exists_analyticOnNhd_globalRemainder`), with the **boundary decomposition**
`logDeriv_mul_eq_remainder_plus_residues` expressing the integrand as the
remainder plus the residue fractions. This yields the **test-function explicit
formula** (zero side):
`test_function_explicit_formula` states
`∮ (Z'/Z)·h = 2πi(∑_ρ h(ρ) − h(0) − h(1))` for `h` differentiable on a
neighbourhood of the rectangle; the linear case is
`test_function_explicit_formula_linear`; the prime side is begun by
`integral_lseries_vonMangoldt_mul` (termwise integration against a continuous
factor) and `logDeriv_mul_I_eq_neg_arch_add_prime` (the pointwise prime-side
identity), and assembled on a vertical line by
`integral_logDeriv_mul_I_eq_neg_arch_prime`
(`∫ Z'/Z·h·i = −∫ arch·h·i − ∫ L_Λ·h·i`), whose archimedean continuity
hypothesis is now discharged: `continuousAt_digamma_of_re_pos` (digamma is
continuous on `Re > 0`) and `continuousOn_arch_mul`, giving
`integral_logDeriv_mul_I_eq_neg_arch_prime'` and its constant form
`integral_logDeriv_mul_I_eq_neg_arch_prime_const`. Numerically the prime-side
identity and the termwise von Mangoldt sum are verified on `Re = 2`. Numerically the formula is verified
for `h = 1, s, s², exp`, and cross-checked on a second rectangle
`[-1.5,2.5]×[-20,20]` where the predicted value vanishes exactly. The **finite patching**
`exists_analyticOnNhd_of_differentiableOn_compl_finset` assembles the local
germs into one analytic function on a neighbourhood of the rectangle.
Numerically the complete test-function formula is verified for `h(s) = s` on
`[−1,2]×[−30,30]`: both sides equal `4πi`; for `h(s) = s²` both sides equal
`−15921.712…i` (difference `2.4·10⁻⁷`), and for the rational `h(s) = 1/((s−5)²+1)`
the formula holds to `2.4·10⁻⁸`. The global remainder is numerically
bounded near a simple zero. Numerically the residue limits
`(s−ρ)Z'/Z → 1`, `(s−p)Z'/Z → −1` are confirmed with linear convergence and
Richardson extrapolation.
**No RH proof yet.**
**Current state (round 422).** The dossier now has **549 Lean
declarations** across 9 files (no `sorry`/`axiom`/`admit`) and **184 Python
tests**. The explicit-formula chain is Lean-checked through the test-function
zero side, the prime side (including its closed Fourier form), the
contour-shift identity for holomorphic symmetric test functions, the
critical-line archimedean realness, the rectangle Cauchy and derivative Cauchy
formulas, and the Fourier calculus on `[-1,1]` (symmetries, continuity, `L¹`
bound, full linearity, modulation, conjugation shift, and the closed
transforms of `1`, `c`, `e^{bu}`, `e^{iau}`, `cos(au)`, `sin(au)`, `u`, `u²`,
`u³`). Notes 56–62 document the chain, the contour shift, the programme status,
the critical-line route, the external *Angular Bochner framework* note (which
independently confirms that finite-stage positivity is classical and uniform
undamping is equivalent to Weil positivity), and the consolidated synthesis.
The open frontier is the **assembled critical-line explicit formula** and
**uniform Weil positivity**. **No RH proof yet.**


## The target

Construct a proper polarized arithmetic/adelic surface — or the strongest
rigorous substitute — whose intersection pairing

\[
\langle D(f),D(f)\rangle = Z(f)\cdot Z(f)
\]

computes the CCM scaling-correspondence pairing and is negative definite on
degree-zero classes. Then the Yuan–Zhang arithmetic Hodge index theorem would
give

\[
Z(f)\cdot Z(f)\le 0
\quad\Longrightarrow\quad
\operatorname{Tr}\bigl(\vartheta_m(f\star f^\#)\mid H^1\bigr)\ge0
\quad\Longrightarrow\quad \mathrm{RH}.
\]

The open realization problem is recorded in
[`../intersection-form-zeta/notes/07-riemann-roch-square.md`](../intersection-form-zeta/notes/07-riemann-roch-square.md)
§4.2 and
[`../intersection-form-zeta/notes/08-three-attacks-and-the-wall.md`](../intersection-form-zeta/notes/08-three-attacks-and-the-wall.md).

## The construction

The absolute object is not a scheme of finite type over a number field. The
candidate is a **fibered polarized Hodge-index realization**

\[
\pi:\mathcal{H}\longrightarrow \mathcal{S},
\]

where \(\mathcal{S}\) is the Scaling Site and the fibre over the periodic orbit
at \(p\) is the abelian surface

\[
\mathcal{H}_p = E_p\times E_p,
\qquad
E_p=\mathbb{C}\Big/\Bigl(\mathbb{Z}+\frac{\log p}{2\pi i}\mathbb{Z}\Bigr).
\]

- **Fibrewise.** \(\operatorname{NS}(\mathcal{H}_p)\) has the rank-three
  basis \(H,V,\Delta\), with Gram matrix
  \[
  \begin{pmatrix}0&1&1\\1&0&1\\1&1&0\end{pmatrix}.
  \]
  The ample class \(A=H+V+\Delta\) satisfies \(A^2=6\), and the Hodge index
  \(6D^2\le(A\cdot D)^2\) holds. This is the Lean model T5–T9 of
  [`../intersection-form-zeta/lean/Topic.lean`](../intersection-form-zeta/lean/Topic.lean).
- **Globally.** The fibrewise pairings are assembled by the transverse measure
  of the foliation; the resulting pairing is the CCM trace
  \(Z(f)\cdot Z(f)=s(f,f)\). The assembly is the **longitudinal
  Hirzebruch–Riemann–Roch formula** on \(\mathcal{H}\), which remains open.

## Rescue status (round 45, historical)

**The objective is not achieved, and the dossier is not closed.** Round 45
found that the round-44 assessment mistook a normalization error for a
mathematical wall:

- The recorded symbol satisfies the exact identity
  \(M(\xi)=A_{\text{arch}}(\xi)+Q(\xi)=-Z'/Z(-i\xi)\) on
  \(\operatorname{Im}\xi>1\). It is the completed-zeta symbol on the
  **imaginary axis**, not on the critical line. The \(n^{-1/2}\) of the
  explicit formula is exactly the contour shift \(\sigma\mapsto\sigma+\frac12\).
- The recorded functional is **indefinite** on exact mean-zero
  compact-support tests (smallest eigenvalue \(-1.7\cdot10^{-3}\), stable to
  eight digits across quadrature orders). This is not a truncation artefact.
  A single relative rescaling of its two halves also fails.
- On the certified four-Gaussian basis, the recorded \(N\) has eigenvalues
  \((-0.0408,-0.0195,-0.0173,+0.0624)\), while the correct \(W\) has
  \((0.0227,0.0270,0.0449,0.0780)\), reproducing
  [`../prime-spectrum-tensor/WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md).
  The sibling's \(+\Omega\) functional passes the narrow-Gaussian test but
  fails the broad compact-support test. The standard \(-\Omega\) formula is
  **near-positive** on broad supports (smallest eigenvalue
  \(-4.4\cdot10^{-3}\), or \(-2.7\cdot10^{-4}\) on a smooth bump); the residual is the open problem of note 39.
- The pointwise sign problem of notes 25–27 is ill-posed: the prime half is a
  measure on the log-lattice, not a boundary value of a meromorphic function.
- The uniform-bound and relative-form obstructions of notes 34–36 are
  withdrawn: the inductive limit needs compatibility, not a uniform bound.
- The sign convention is resolved by \(s=-W\): the geometric self-intersection
  is the negative of the Weil functional.

The corrected objective is Weil positivity for the correct \(W\) (pole
integral, \(n^{-1/2}\) prime sum, and the \(\Omega\) archimedean density),
with the finite Gram certificates as acceptance tests.
See [`notes/37-final-assessment.md`](notes/37-final-assessment.md) and
[`notes/38-rescue.md`](notes/38-rescue.md).  No sign claim about the CCM form
should be based on the pointwise symbol, and no RH proof is claimed yet.

## What is proved, what is not

**Note (round 24).** The finite-\(K\) gap studies in notes 14–21 are
**compression diagnostics**, not the full-space spectral gap. Finite
compressions can have spurious eigenvalues; the \(K=32\) resonance is one.
The full-space formulation is in
[`notes/22-continuum-gap.md`](notes/22-continuum-gap.md).

| layer | statement | status |
|---|---|---|
| local | rank-three NS Hodge index \(6D^2\le(A\cdot D)^2\) | Lean T5–T9 |
| local | polarised abelian surface \(E_p\times E_p\), \(A^2=6>0\) | constructed |
| local KMS | finite KMS Hodge index \(-B\preceq0\) on the kernel of the state | proved (note 03) |
| local HR | half-weight polarization \(C_{1/2}\succ0\), with \(B=-C'_0\) | proved (note 04) |
| finite crossed product | finite-dimensional \(C^*\)-algebra theorem, \(C^*(S_3)\) check | proved (note 05) |
| dictionary | diagonal half-weight derivative vanishes; the local term is off-diagonal/symplectic | structural (note 06) |
| real structure | fixed \(J\) gives a **state-dependent** signature \((4,2,3),(2,4,3),(0,6,3)\); not a universal \((1,\rho-1)\) | corrected (note 07) |
| Krein/Hodge | Lorentzian \(Q\), fundamental symmetry \(S^2=1\), \(h=QS\succ0\) | proved (note 08) |
| CCM probe | bilinear form antisymmetric-dominated (\(\sim200\times\)); quadratic refinement small | probe, uncertified (note 09) |
| CCM split | Hermitian split \(s=S+i\Omega\); \(S\) is the Hodge-index form, \(\Omega\) the symplectic form | structural (note 10) |
| CCM cross-check | fast Gauss–Legendre matches mpmath to \(7.5\cdot10^{-9}\) | numerical (note 09) |
| Hodge star probe | \(S\) indefinite, cond \(\sim1.6\cdot10^{3}\); \(T^2\) not scalar; no compatible star from the raw probe | obstruction (note 11) |
| polarization | \(L^2\) polarization \(H\), compatible \(U\) by polar decomposition, \(R=\Omega U\) symmetric **negative definite** | constructed (note 12) |
| orthonormal / degree-zero | \(R=-(-\Omega^2)^{1/2}\) negative definite, full and on the exact degree-zero subspace | proved (note 13) |
| spectral gap | even \(K\): definite, gap \(0.415\to0.250\to0.191\to0.166\) with slowing decay; odd \(K\): zero mode; uniform limit unresolved | truncation diagnostic (note 14) |
| plain-basis gap | stable to \(K=20\); near-degeneracy at \(K=16\) (\(0.037\)), non-monotone; uniform gap not established | truncation diagnostic (note 15) |
| prime/arch split | prime gap \(\sim0.002\)–\(0.02\), arch gap \(\sim0.21\)–\(0.26\); the \(K=16\) collapse is **prime-driven** | truncation diagnostic (note 16) |
| UV localization | the \(K=16\) total small vector sits in the top four modes (PR \(4.74\), top mass \(0.84\)); likely a truncation artefact | truncation diagnostic (note 17) |
| smooth window | \(C^1\) \(\sin^2\) window, cond \(210\)–\(2964\); gap stabilises in \([0.038,0.054]\) for \(K=16\)–\(26\) | truncation diagnostic (note 18) |
| window robustness | \(\sin^2\) and poly\(_2\) stable at \(0.04\)–\(0.055\); \(\sin^4\) and poly\(_4\) decrease with conditioning | truncation diagnostic (note 19) |
| large-\(K\) poly\(_2\) | gaps \(0.041,0.040,0.015,0.020,0.025\) for \(K=24,28,32,36,40\); \(K=32\) resonance stable under quadrature | truncation diagnostic (note 20) |
| generic \(K=32\) | \(\sin^2\) and poly\(_2\) both dip at \(K=32\) (\(0.0070\), \(0.0150\)) and recover at \(36,40\) | truncation diagnostic (note 21) |
| archimedean symbol | exact \(A_{\text{arch}}(\xi)=\tfrac12[\log\pi-\psi(-i\xi/2)]\) | proved (note 23) |
| prime symbol | naive cutoff at \(\Re(s)=1/2\) fails (oscillatory tail); the prime half is the measure \(\sum\Lambda(n)\delta_{\log n}\), not a boundary value | corrected (notes 24, 38 §2.1) |
| symbol identity | \(M(\xi)=A_{\text{arch}}(\xi)+Q(\xi)=-Z'/Z(-i\xi)\) on \(\operatorname{Im}\xi>1\), with the **continued form** for \(s\ne1\) (hence on the critical line) | proved (note 38, §3; `symbol_identity_continued`) |
| Gram test | recorded \(N\) indefinite on exact mean-zero compact-support tests: \((-1.67\cdot10^{-3},-1.48\cdot10^{-4},1.3\cdot10^{-7},2.6\cdot10^{-5})\), stable to \(10^{-8}\) | numerical, decisive (note 38, §4) |
| same-basis comparison | on the certified Gaussian basis, \(N\): \((-0.0408,-0.0195,-0.0173,+0.0624)\); correct \(W\): \((0.0227,0.0270,0.0449,0.0780)\) | decisive (note 38, §4) |
| sibling Weil functional | \(W=2\int h\cosh(u/2)-2\sum\Lambda(n)n^{-1/2}h(\log n)+(1/2\pi)\int\widehat h\,\Omega\): narrow-Gaussian certificate, broad test fails | different convention (note 39) |
| exact compact-support test | cosh \(+\Omega\) form PSD (\(0,1.1\cdot10^{-7},9.98\cdot10^{-5},1.67\cdot10^{-3}\)); \(-\Omega\) forms have small negative residuals | numerical; sign question closed on this rung (note 41) |
| interval Gaussian Gram | 2×2, 4×4, 6×6 and 8×8 cosh \(+\Omega\) Gram matrices certified PSD by centre-plus-slack and exact rational minors | interval certificate (note 44) |
| compatible positivity | unbounded \(\|H_N\|\) is compatible with compatible positive forms; \(B_N\) agrees to \(8\cdot10^{-16}\) while \(\|H_N\|\) grows \(1.5\to14.0\) | proved + numerical (note 38, §2.2) |
| symbol sign | \(M\le0\Rightarrow s\le0\) is proved; the converse fails. The prime half is a measure, so the pointwise formulation is ill-posed | corrected (notes 25, 38 §2) |
| archimedean sign | \(\Re A_{\text{arch}}\) crosses zero at \(\xi_c=6.22885\); the archimedean part alone is indefinite | proved (note 26) |
| Abel regularization | prime sums oscillate (\(-5.55,14.56,-21.35\) at \(\xi=1\)) and do not converge to \(-\zeta'/\zeta\) | obstruction (note 27) |
| test-function class | CCM functions are compactly supported; their Fourier transforms do not decay on the critical line; the zero sum is conditional, and Gaussian checks are invalid | correction (note 28) |
| zero-sum divergence | tent: \(N(h)\approx1.37\), but \(|\widehat F(1/2+i\gamma)|\) grows (\(1.06\to1.2\cdot10^{6}\) for \(\gamma=1\to20\)); the naive zero sum diverges | obstruction (note 29) |
| Fejér normalization | \(N(h)\approx8.783\) vs zero sum \(0.184\); \(N\) is for convolution squares, not arbitrary \(h\) | normalization (note 30) |
| sign convention | the geometric form is \(s=-W\); the probe's positive directions are the expected sign of the Weil functional, not a counterexample | Lean-checked (`hodge_sign_iff`) |
| von Mangoldt L-series | partial sum at \(s=2\) to \(N=20000\) matches \(-\zeta'/\zeta(2)\) within the explicit tail bound \((\log N+1)/N\) | numerical, tail-bounded (test suite) |
| completed-zeta functional equation | \(Z(s)=Z(1-s)\) verified at 30 dps to \(10^{-20}\) at four complex points | numerical, exact identity (test suite) |
| von Mangoldt, complex \(s\) | partial sums at \(s=2+3i\) and \(1.5-2i\) match \(-\zeta'/\zeta(s)\) within the integral tail bound \(N^{1-\sigma}(\log N/(\sigma-1)+1/(\sigma-1)^2)\) | numerical, tail-bounded (test suite) |
| symbol on the critical line | \(\operatorname{Re} M(1/2+it)=0\) at \(t=0.5,2,10,20\) to \(10^{-25}\) (30 dps) | numerical, finite evaluation (test suite); matches `symbol_critical_line_pure_imaginary` |
| log-derivative conjugation | \((Z'/Z)(\bar s)=\overline{(Z'/Z)(s)}\) at three points to \(10^{-20}\) (30 dps) | numerical, finite evaluation (test suite); matches `logDeriv_completedZeta_conj` |
| critical-line log-derivative | \(\operatorname{Re}((Z'/Z)(1/2+it))=0\) at \(t=2,10,20\) to \(10^{-20}\) (30 dps) | numerical, finite evaluation (test suite); matches `logDeriv_completedZeta_critical_line_imaginary` |
| critical-line symbol form | \(M(1/2+it)=-(Z'/Z)(1/2+it)\) at \(t=2,10,20\) to \(10^{-20}\) (30 dps) | numerical, finite evaluation (test suite); matches `symbol_critical_line_eq_neg_logDeriv` |
| log-derivative anti-symmetry | \((Z'/Z)(1-s)=-(Z'/Z)(s)\) at three points to \(10^{-20}\) (30 dps) | numerical, finite evaluation (test suite); matches `logDeriv_completedZeta_one_sub` |
| zero quadruple | the first zero \(\rho\) and \(1-\rho,\bar\rho,1-\bar\rho\) all satisfy \(Z=0\) to \(10^{-15}\) (30 dps) | numerical, finite evaluation (test suite); matches `completedZeta_zero_quadruple` |
| critical-line reality of \(Z\) | \(\operatorname{Im}Z(1/2+it)=0\) at \(t=1,5,10,20\) to \(10^{-20}\) (30 dps) | numerical, finite evaluation (test suite); matches `completedZeta_critical_line_real` |
| argument-principle count | for \(f=(z-a)(z-b)\): count \(2\) (both inside) and \(1\) (one inside, one outside), to \(10^{-20}\) | numerical, finite evaluation (test suite); matches `circleIntegral_logDeriv_prod` |
| pole residue | \((s-1)Z(s)\to1\) as \(s\to1\) at \(\varepsilon=10^{-3},10^{-4}\) | numerical, finite evaluation (test suite); matches `completedZeta_residue_one` |
| Hadamard/Weierstrass | elementary factors, finite/infinite canonical products, convergence, analyticity, zeros with multiplicity | Lean-checked (`Hadamard.lean`) |
| Hadamard/Weierstrass | Jensen's formula and inequality; general zero-counting bound | Lean-checked |
| Hadamard/Weierstrass | zero-free logarithm on balls and on the whole plane | Lean-checked |
| Hadamard/Weierstrass | the canonical product is entire | Lean-checked (`differentiable_tprod_weierstrassFactor`) |
| Hadamard/Weierstrass | quotient normal form `f/P` entire and zero-free; global `f = P·Q` | Lean-checked |
| Hadamard/Weierstrass | quotient-form factorisation `f = P · exp g` | Lean-checked (`exists_factorization_of_divisor_match`) |
| Hadamard/Weierstrass | order-1 affine form `f = P · exp (a + bz)` | Lean-checked **conditional** on `HasLogGrowthOne (f/P)` |
| Hadamard/Weierstrass | order-1 log-growth of `f/P` (minimum-modulus estimate) | open |
| normalization dictionary | exact: \(A_{\text{arch}}+Q=-Z'/Z(-i\xi)\) on \(\operatorname{Im}\xi>1\); the \(n^{-1/2}\) is the contour shift \(\sigma\mapsto\sigma+\tfrac12\) | proved (notes 32, 38 §3) |
| archimedean comparison | exact identity \(\operatorname{Re}A_{\text{arch}}(\xi)=-\tfrac12\Omega(\xi+\tfrac i2)\); the round-37 comparison mixed two contours | proved (notes 33, 38 §3) |
| inductive limit | compatible positivity lemma: the limit form is semidefinite on the dense union under compatibility alone; no uniform bound | Lean-checked (`lean/Rescue.lean`) |
| uniform bound | \(\|H_N\|\sim\beta\log N\) does grow, but unbounded norms are compatible with compatible positive forms; the “obstruction” is withdrawn | withdrawn (note 38, §2.2) |
| relative modular form | the relative form is a difference of positive operators; its indefiniteness is expected and does not close the route | withdrawn (note 38, §2.3) |
| local metric | \(E_p=\mathbb{C}^*/(p^{\mathbb{Z}})\) is the Tate curve with \(q=p\); the factor \(p^{-k/2}\) is the \(p\)-adic norm of the period | identified; not yet integrated |
| global | fibre-to-trace assembly \(\sum_p\) local pairings \(=s(f,f)\) | open |
| absolute | proper polarized surface over \(\mathbb{Q}\) with the CCM pairing | open; a realization would prove RH |

Three candidates have been examined:

0. **Bost–Connes endomotive / modular tower.**  The profinite tower
   \(\varprojlim X_0(N)\) (equivalently
   \(C^*(\mathbb{Q}/\mathbb{Z})\rtimes\mathbb{N}^\times\)) carries the
   Hecke correspondences, the Petersson/Hodge–Riemann polarization, and the
   KMS half-weight \(p^{-k/2}\).  It is the strongest candidate for the
   global metrized object.  The finite-level Hodge–Riemann positivity is
   checked; the transverse \(\log p\) length is the missing theorem.  See
   [`notes/02-endomotive-candidate.md`](notes/02-endomotive-candidate.md).

The two algebraic candidates below fail for proved reasons:

1. **Hecke/Shimura surface.** \(X_0(N)\times X_0(N)\) is proper and polarized
   over \(\mathbb{Q}\), and the Hecke correspondences \(T_p\) are algebraic; the
   Hodge index applies. But the trace is the Hecke eigenvalue \(a_p\), not the
   CCM local term \(\frac{\log p}{p^{k/2}}(f(p^k)+f(p^{-k}))\). The dictionary
   fails.
2. **Scaling Site square.** The complex lift
   \(\Gamma_\mathbb{Q}^2\) carries the correct pairing, but it is a foliated
   complex space, not a variety of finite type over a number field. Yuan–Zhang
   does not apply.

## Layout

- [`notes/01-fibered-construction.md`](notes/01-fibered-construction.md) —
  the fibered construction, the local theorem, and the two algebraic
  obstructions.
- [`notes/02-endomotive-candidate.md`](notes/02-endomotive-candidate.md) —
  the Bost–Connes/modular-tower candidate and the transverse Hodge–Riemann
  conjecture.
- [`notes/03-kms-hodge-index.md`](notes/03-kms-hodge-index.md) — the finite
  KMS Hodge-index theorem and its proof.
- [`notes/04-finite-hodge-riemann.md`](notes/04-finite-hodge-riemann.md) —
  the half-weight polarization and the finite Hodge–Riemann package.
- [`notes/05-finite-crossed-product.md`](notes/05-finite-crossed-product.md) —
  the finite-dimensional \(C^*\)-algebra theorem and the \(C^*(S_3)\)
  crossed-product check.
- [`notes/06-off-diagonal-dictionary.md`](notes/06-off-diagonal-dictionary.md)
  — the off-diagonal/symplectic dictionary correction.
- [`notes/07-finite-real-structure.md`](notes/07-finite-real-structure.md) —
  the finite real form and the state-dependence correction.
- [`notes/08-finite-krein-hodge.md`](notes/08-finite-krein-hodge.md) — the
  correct Lorentzian Hodge star \(S^2=1\) and the Hodge–Riemann form
  \(h=QS\).
- [`notes/09-ccm-pairing-probe.md`](notes/09-ccm-pairing-probe.md) — the
  direct probe of the CCM bilinear form and its antisymmetric structure.
- [`notes/10-hermitian-ccm-pairing.md`](notes/10-hermitian-ccm-pairing.md) —
  the Hermitian split \(s=S+i\Omega\) and the Hodge-index real part.
- [`notes/11-hodge-star-obstruction.md`](notes/11-hodge-star-obstruction.md) —
  the Hodge-star compatibility obstruction and the polarization remedy.
- [`notes/12-polarization-hodge-index.md`](notes/12-polarization-hodge-index.md)
  — the \(L^2\) polarization, compatible \(U\), and negative-definite
  \(R=\Omega U\).
- [`notes/13-orthonormal-degree-zero.md`](notes/13-orthonormal-degree-zero.md)
  — the orthonormal theorem and the exact degree-zero projection.
- [`notes/14-spectral-gap-truncation.md`](notes/14-spectral-gap-truncation.md)
  — the shrinking gap and the odd-\(K\) zero mode.
- [`notes/15-plain-basis-near-degeneracy.md`](notes/15-plain-basis-near-degeneracy.md)
  — the plain orthogonal basis and the \(K=16\) near-degeneracy.
- [`notes/16-prime-archimedean-split.md`](notes/16-prime-archimedean-split.md)
  — the prime versus archimedean gap split.
- [`notes/17-uv-localization.md`](notes/17-uv-localization.md) — the UV
  localization of the \(K=16\) small eigenvector.
- [`notes/18-smooth-window-stability.md`](notes/18-smooth-window-stability.md)
  — the smooth-window gap stability.
- [`notes/19-window-robustness.md`](notes/19-window-robustness.md) — the
  gap across four smooth windows and its conditioning dependence.
- [`notes/20-large-k-resonance.md`](notes/20-large-k-resonance.md) — the
  \(K=32\) resonance and the failure of uniform stability.
- [`notes/21-generic-resonance.md`](notes/21-generic-resonance.md) — the
  same \(K=32\) dip in two well-conditioned windows.
- [`notes/22-continuum-gap.md`](notes/22-continuum-gap.md) — the full-space
  reformulation: the gap is a symbol/spectral quantity, not a truncation.
- [`notes/23-archimedean-symbol.md`](notes/23-archimedean-symbol.md) — the
  exact archimedean symbol in terms of the digamma function.
- [`notes/24-prime-symbol.md`](notes/24-prime-symbol.md) — the prime-symbol
  regularization problem.
- [`notes/25-symbol-sign.md`](notes/25-symbol-sign.md) — the symbol-sign
  theorem and the reduction of the Hodge index to \(M\le0\).
- [`notes/26-archimedean-sign.md`](notes/26-archimedean-sign.md) — the exact
  archimedean sign change and its consequence.
- [`notes/27-abel-obstruction.md`](notes/27-abel-obstruction.md) — the
  Abel-regularization obstruction for the prime symbol.
- [`notes/28-test-function-class.md`](notes/28-test-function-class.md) — the
  compact-support test-function class and the conditional zero sum.
- [`notes/29-zero-sum-divergence.md`](notes/29-zero-sum-divergence.md) — the
  exponential growth and the divergence of the naive zero sum.
- [`notes/30-status.md`](notes/30-status.md) — consolidation and the Fejér
  normalization mismatch.
- [`notes/31-sign-convention.md`](notes/31-sign-convention.md) — the
  unresolved overall sign of the CCM functional.
- [`notes/32-normalization-dictionary.md`](notes/32-normalization-dictionary.md)
  — the term-by-term comparison with the explicit formula.
- [`notes/33-archimedean-comparison.md`](notes/33-archimedean-comparison.md)
  — the CCM versus Weil archimedean factors.
- [`notes/34-inductive-limit.md`](notes/34-inductive-limit.md) — the
  conditional inductive-limit theorem for the Bost–Connes dense union.
- [`notes/35-uniform-bound.md`](notes/35-uniform-bound.md) — the failure of
  the naive uniform bound and the need for a relative modular form.
- [`notes/36-relative-form.md`](notes/36-relative-form.md) — the
  indefiniteness of the naive and symmetrized relative modular forms.
- [`notes/37-final-assessment.md`](notes/37-final-assessment.md) — the
  revised assessment: objective not achieved, recorded normalization
  falsified, programme reopened.
- [`notes/38-rescue.md`](notes/38-rescue.md) — the rescue: the exact symbol
  identity, the contour error, the Gram test, and the withdrawn obstructions.
- [`notes/39-broad-test-discrepancy.md`](notes/39-broad-test-discrepancy.md) —
  the broad compact-support test, the two-rung acceptance test, and the open
  pole/trivial-zero completion.
- [`notes/40-goal-status.md`](notes/40-goal-status.md) — the eight-round audit
  and handoff: what is Lean-checked, what is numerical, and what remains.
- [`notes/41-quadrature-correction.md`](notes/41-quadrature-correction.md) —
  the missing-weight correction: the sibling's cosh \(+\Omega\) form is
  positive semidefinite on the exact compact-support test.
- [`notes/42-interval-status.md`](notes/42-interval-status.md) — the measured
  obstruction to an interval-certified Gram entry and the precise next
  computation.
- [`notes/43-certified-density-blockade.md`](notes/43-certified-density-blockade.md)
  — the certified-density performance blockade and the replacement
  recurrence/asymptotic algorithm.
- [`notes/44-first-interval-entry.md`](notes/44-first-interval-entry.md) — the
  first interval-certified analytic Gram entry (Gaussian diagonal, width
  \(4.9\cdot10^{-4}\)), and the 2×2/4×4/6×6 matrix certificates.
- [`notes/45-margin-collapse.md`](notes/45-margin-collapse.md) — the finite-rung
  margin collapses; finite positive-definite certificates do not reach the
  cone.
- [`notes/47-compact-interval-entry.md`](notes/47-compact-interval-entry.md) —
  the interval-certified compact-support entry and its certified positivity.
- [`notes/48-frontier.md`](notes/48-frontier.md) — the precise remaining gap
  to an RH proof: distributional explicit formula, Bost–Connes identification,
  and global cone positivity.
- [`notes/50-hadamard-project.md`](notes/50-hadamard-project.md) — the
  commissioned Hadamard/Weierstrass project: scope, milestone 1, and the
  remaining milestones.
- [`notes/52-hadamard-status.md`](notes/52-hadamard-status.md) — status and
  frontier of the Hadamard project: Lean-checked factorisation up to the
  order-1 growth estimate.
- [`notes/53-priorities.md`](notes/53-priorities.md) — status of the five
  priority items after the Hadamard formalisation.
- [`notes/49-naive-zero-sum.md`](notes/49-naive-zero-sum.md) — the naive zero
  sum diverges exponentially on compact support; the explicit formula must be
  distributional / Gaussian-class.
- [`lean/Rescue.lean`](lean/Rescue.lean) — the Lean-checked algebraic core:
  finite KMS positivity, compatible positivity, the non-compatibility
  counterexample, the sign convention, and the quadratic-form criterion.
- [`lean/Shadow.lean`](lean/Shadow.lean) — rational shadow certificates:
  `G4_psd` for the certified Gaussian Gram and `N4_not_psd` for the recorded
  one.
  Build with [`lean/check.sh`](lean/check.sh); scope in
  [`lean/README.md`](lean/README.md).
- [`research-journal.md`](research-journal.md) — minimal round-by-round record.
- [`python/local_polarization.py`](python/local_polarization.py) — numerical
  check of the rank-three local Hodge index.
- [`python/modular_tower.py`](python/modular_tower.py) — level-11 Hecke
  eigenvalues and the Ramanujan–Petersson bound.
- [`python/kms_transverse.py`](python/kms_transverse.py) — finite KMS
  transverse form and the Hodge-index sign.
- [`python/finite_hodge_riemann.py`](python/finite_hodge_riemann.py) —
  half-weight form, positivity, and the derivative identity.
- [`python/finite_crossed_product.py`](python/finite_crossed_product.py) —
  the regular representation of \(C^*(S_3)\) and the Hodge-index check.
- [`python/off_diagonal.py`](python/off_diagonal.py) — the off-diagonal
  half-weight-times-log form and its symplectic nature.
- [`python/real_structure.py`](python/real_structure.py) — the fixed complex
  structure \(J\) and the state-dependent signature.
- [`python/krein_hodge.py`](python/krein_hodge.py) — the fundamental symmetry
  \(S\) and the positive Hodge–Riemann form.
- [`python/ccm_pairing_probe.py`](python/ccm_pairing_probe.py) — the
  uncertified CCM bilinear-form probe.
- [`python/ccm_structure.py`](python/ccm_structure.py) — the exact
  symmetric/antisymmetric split of the probe matrix.
- [`python/ccm_fast.py`](python/ccm_fast.py) — the fast Gauss–Legendre
  cross-check of the probe.
- [`python/hodge_star_probe.py`](python/hodge_star_probe.py) — the
  \(T=S^{-1}\Omega\) diagnostic and the non-scalar \(T^2\) defect.
- [`python/polarization.py`](python/polarization.py) — the \(L^2\)
  polarization, compatible star, and negative-definite Hodge-index form.
- [`python/truncation_gap.py`](python/truncation_gap.py) — the finite
  spectral-gap table.
- [`python/plain_basis_gap.py`](python/plain_basis_gap.py) — the
  well-conditioned plain-sine-basis gap computation.
- [`python/prime_arch_split.py`](python/prime_arch_split.py) — the prime and
  archimedean components and their spectra.
- [`python/uv_localization.py`](python/uv_localization.py) — the small
  eigenvectors and their participation ratios.
- [`python/smooth_window_gap.py`](python/smooth_window_gap.py) — the
  \(C^1\) \(\sin^2\)-windowed gap computation.
- [`python/window_robustness.py`](python/window_robustness.py) — the
  four-window conditioning/gap comparison.
- [`python/large_k_gap.py`](python/large_k_gap.py) — the large-\(K\)
  poly\(_2\) gap table.
- [`python/generic_resonance.py`](python/generic_resonance.py) — the
  two-window \(K=32\) table.
- [`python/arch_symbol.py`](python/arch_symbol.py) — the exact archimedean
  symbol and its series check.
- [`python/prime_abel_probe.py`](python/prime_abel_probe.py) — the Abel
  regularization probe.
- [`python/zero_sum_probe.py`](python/zero_sum_probe.py) — the critical-line
  growth of the tent transform.
- [`python/arch_compare.py`](python/arch_compare.py) — the CCM/Weil
  archimedean comparison.
- [`python/uniform_bound.py`](python/uniform_bound.py) — the finite bound and
  the KMS norm growth.
- [`python/relative_form.py`](python/relative_form.py) — the relative modular
  form and its indefinite sign.
- [`python/rescue_probe.py`](python/rescue_probe.py) — the archimedean and
  symbol identities, the exact CCM Gram matrix, and the compatible-positivity
  examples.
- [`tests/test_local_polarization.py`](tests/test_local_polarization.py) —
  local positivity tests.
- [`tests/test_rescue.py`](tests/test_rescue.py) — the rescue and continuation
  tests (100 test functions, 184 cases).

## Lean

The formal core spans seven files in `lean/`, checked with `lean/check.sh`
against Mathlib (Lean 4.34.0), no `sorry`, `axiom` or `admit`:

```bash
the-final-letter/topics/absolute-polarized-hodge-index-realization/lean/check.sh
# [check] OK   Rescue.lean      [check] OK   Shadow.lean
# [check] OK   Archimedean.lean [check] OK   Symbol.lean
# [check] OK   Limit.lean       [check] OK   Weil.lean
# [check] OK   Hadamard.lean
```

`Rescue.lean` holds the finite KMS positivity, compatibility, the sign
convention `s = -W` and the finite quadratic-form criterion. `Shadow.lean`
holds the finite Hodge-index model and the finite cone-positivity
certificates. `Archimedean.lean` and `Symbol.lean` hold the archimedean
symbol, the digamma/zeta identities, the completed-zeta symmetries, both pole
terms and the argument-principle chain. `Limit.lean` holds the scaling-site
limit form; `Weil.lean` the pole/prime signs; `Hadamard.lean` the canonical
products, Jensen theory, the order-1 class and the factorisation.

It does **not** yet cover the distributional explicit formula, the infinite
cone positivity, or the analytic eigenvalue; see
[`lean/README.md`](lean/README.md) and [`HANDOFF.md`](HANDOFF.md).

## Next (round 272)

Continue from [`HANDOFF.md`](HANDOFF.md). The immediate next steps are:

1. **Simple-pole theorem**: apply the simple-zero theorem to `1/f` and use
   `logDeriv_inv_comp` / `circleIntegral_neg` to get `∮ f'/f = -2πi`.
2. **Multi-pole theorem**: combine finitely many simple poles with the
   multi-zero count.
3. **`Z'/Z` on a rectangle**: zeros inside minus the poles at `0, 1`; needs a
   rectangle argument principle / residue theorem (not in Mathlib).
4. **Explicit formula**: boundary evaluations (archimedean side already
   Lean-checked via the symbol identity; prime side via von Mangoldt; horizontal
   tails open).
5. **Infinite cone positivity** (Weil's criterion) and then the RH statement.

The round-45 normalization items are now resolved: the symbol identity holds on
the critical line (`symbol_critical_line_eq_neg_logDeriv`), both pole terms are
Lean-checked (`completedZeta_residue_one`, `completedZeta_residue_zero`), and
the trivial-zero convention is documented. The current frontier is the contour
identity, not the normalization.

[Back to the topic index](../README.md) · [Intersection form dossier](../intersection-form-zeta/README.md) · [Handoff](HANDOFF.md)
