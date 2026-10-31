# Note 65 — assembling the critical-line explicit formula: roadmap

**Status: No RH proof yet.** With the Fourier inversion now Lean-checked
(note 64), this note records the precise remaining steps to the classical
critical-line Weil formula, and the subtleties encountered.

## 1. The target

For a suitable even test function `h` on the critical line (the Fourier
transform of a compactly supported `g`), the classical explicit formula
relates

`Σ_ρ h(γ_ρ)` (over nontrivial zeros `ρ = 1/2 + iγ`)

to an **archimedean integral**, a **prime sum** `Σ_n Λ(n)n^{-1/2}ĝ(log n)`
(up to normalisation), and the **pole terms** `h(0), h(1)`.

## 2. What is Lean-checked

- The test-function zero side on a rectangle:
  `∮ Z'/Z·h = 2πi(Σh(ρ) − h(0) − h(1))` (`test_function_explicit_formula`).
- The contour-shift identity `contour_shift_symmetric'` for holomorphic
  symmetric `h` (finite `T`).
- The right-vertical closed Fourier identities
  (`integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed`).
- The archimedean critical-line realness and the reality of its integral.
- The **Fourier inversion** `fourier_inversion`
  (`𝓕⁻ (𝓕 g_ext) u = g u` for `C²` `g` with `g(±1)=0`, `u ∈ (−1,1)`).
- The **Paley–Wiener test function** `paleyWiener g s = ∫_{−1}^{1} g(u)e^{i(s−1/2)u}du`:
  entire (`differentiable_paleyWiener`), symmetric for even `g`
  (`paleyWiener_one_sub`), with conjugation `conj h(s) = h(1−conj s)`
  (`paleyWiener_conj`); its constant case is the classical
  `2 sin(s−1/2)/(s−1/2)` (`paleyWiener_one`), and it is real on the
  critical line (`paleyWiener_critical_line_real`).
- **The assembled contour-shift identity for the Paley–Wiener class**
  (`contour_shift_paleyWiener`), instantiating
  `contour_shift_symmetric'` with all its hypotheses discharged.
- The whole `fourierG` calculus, including the derivative correspondence and
  the Riemann–Lebesgue bounds.

## 3. The missing assembly, and its subtleties

1. **The horizontal terms at `T → ∞`.** For holomorphic `h` the horizontal
   integrals grow like `e^{aT}` (note 58 §6); the classical derivation instead
   uses the fact that `h` is a Fourier transform and pairs the horizontal
   terms against the **sum over zeros** via the explicit formula on the
   critical line. The finite-`T` identity is Lean-checked; the limit needs
   the Weil form of the zero sum.
2. **The prime side.** The finite-`T` Fubini swap is now Lean-checked
   (`integral_logDeriv_paleyWiener_swap`), expressing the right-vertical
   integral as `∫_u g(u)e^{3iu/2}·∫_y (Z'/Z)(2+iy)e^{−yu}dy`; the remaining
   task is evaluating the inner `y`-integral against the closed prime measure. The formal computation
   `∫_ℝ n^{-2−iy}h(2+iy)dy` with `h(s) = ∫g(u)e^{i(s−1/2)u}du` suggests
   `2π n^{-1/2}g(log n)` after the `y`-integration, but the exchange of
   integrals is only distributional (the Gaussian factor `e^{−yu}` grows for
   `u<0`), so the rigorous route is the contour/residue argument rather than
   Fubini. This is the constant that must be fixed carefully against
   Iwaniec–Kowalski Thm 5.12.
3. **The archimedean term.** Its critical-line integral against `h` is
   Lean-checked as real; the exact normalisation is to be matched.

## 4. Why the numerical constant-matching failed

A naive numerical comparison with a Gaussian test function was inconclusive:
the Gaussian is not compactly supported (the explicit formula's sums need
decay) and the normalisation of `h` versus `ĝ` must be fixed first. The
numerical check must use a compactly supported `g` and the precise
Iwaniec–Kowalski normalisation.

## 5. Numerical coverage of the Paley–Wiener assembly

The finite-`T` identity `contour_shift_paleyWiener` is numerically exercised
by `test_contour_shift_paley_wiener` for `g ≡ 1`, i.e.
`h(s) = 2 sin(s−1/2)/(s−1/2)` (relative agreement `10⁻¹⁷`), and by the
Gaussian and quadratic instances.

## 6. Next steps

1. Fix the normalisation and state the explicit formula with a compactly
   supported `g`.
2. Formalise the distributional prime-side identity via the contour argument
   (not Fubini).
3. Combine with the Fourier inversion and the archimedean reality.

**No RH proof yet.**
