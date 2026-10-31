# Note 60 — the critical-line route to the Weil explicit formula

**Status: No RH proof yet.** This note records the remaining analytic route to
the classical (Weil) explicit formula, after the correction of note 58 §6: the
finite-`T` holomorphic contour identity is Lean-checked, but the classical
formula is an identity for test functions **on the critical line**, not a
`T → ∞` limit of a holomorphic contour integral.

## 1. Why a different route is needed

A holomorphic test function cannot decay in both horizontal directions (it would
be bounded and decaying on a strip, hence zero). The Gaussian in `s` and the
Paley–Wiener functions grow like `e^{a|Im s|}`. The classical derivation
therefore keeps the test function on the line: one considers

```
Σ_ρ g(γ_ρ),  ρ = 1/2 + iγ_ρ,
```

for a test function `g : ℝ → ℝ` (even, smooth, compactly supported, or with
Fourier transform supported in `[−1/2, 1/2]`), and proves an identity of the
form

```
Σ_ρ g(γ_ρ) = (archimedean term)(g) + (prime term)(g),
```

where the prime term is a sum over `n` of `Λ(n)/√n` times the Fourier
transform of `g` at `log n` (together with `−log n`), and the archimedean term
is an integral of `g` against the real part of `ψ(1/4 + it/2) − log π`.

## 2. The derivation route (text-proof)

The standard proofs use one of two equivalent strategies:

1. **Hadamard product / divisor of `ξ`.** Write the completed zeta as
   `ξ(s) = (1/2)s(s−1)Z(s)` with the Hadamard product over the zeros, take the
   logarithmic derivative, and integrate against a test function on the line.
   The functional equation pairs `γ` with `−γ`; the prime side appears through
   the Euler product of `−ζ'/ζ` on `Re > 1`, and the contour is shifted using
   the decay of `g` (or compact support of its Fourier transform).
2. **Contour shift with a non-holomorphic cutoff.** Integrate
   `(ξ'/ξ)(1/2+it)g(t)` over `t` and move the line of integration; the
   horizontal segments are controlled by the decay of `g` on the line (not by
   holomorphy in the strip), and the functional equation reflects `t ↦ −t`.

Both use the **Fourier transform** of `g` and the **prime measure**
`Σ_n Λ(n)n^{−1/2}δ_{log n}`. A convenient normalization is
`h(s) = ∫ g(u)e^{i(s−1/2)u}du` on the line, where only the values `s = 1/2+it`
(real `t`) are used.

## 3. What the dossier already supplies (Lean-checked)

- The **zero side** for holomorphic test functions
  (`test_function_explicit_formula`) and its linear case.
- The **prime side**: the von Mangoldt L-series, its termwise integration
  (`integral_lseries_vonMangoldt_mul`) and closed term integral.
- The **archimedean symbol** and digamma continuity on the right half-plane
  (`continuousAt_digamma_of_re_pos`).
- The **functional equation** in log-derivative form and conjugation symmetry.
- The **divisor-derived zero count** (`rectIntegral_logDeriv_eq_divisor_sum_derived`).
- The **contour-shift identity** for holomorphic symmetric test functions
  (`contour_shift_symmetric'`), a finite-`T` identity.

## 4. What remains to be formalised

1. **Fourier transform on `ℝ`** for the test function class: begun with
   `fourierG`, `fourierG_even`, `fourierG_conj` (evenness and reality),
   `continuous_fourierG`, `norm_fourierG_le` (regularity and `L¹` bound), the
   full linearity package (`fourierG_add`, `fourierG_sub`, `fourierG_neg`,
   `fourierG_const_mul`, `fourierG_zero`, `fourierG_finset_sum`,
   `fourierG_congr`), and the closed transforms of `1`, `c`, `e^{bu}`,
   `e^{iau}`, `c·e^{iau}`, `cos(au)` and `sin(au)` (`fourierG_one_eq`,
   `fourierG_const_eq`, `fourierG_exp_eq`, `fourierG_exp_I_eq`,
   `fourierG_const_mul_exp_I_eq`, `fourierG_cos_eq`, `fourierG_sin_eq`,
   `fourierG_exp_zero_eq`); the full Paley–Wiener class and Fourier inversion
   remain.
2. **The prime measure identity**: for `Re s > 1`,
   `−ζ'/ζ(s) = Σ_n Λ(n)n^{−s}` (Lean-checked), with its Fourier form on an
   interval Lean-checked as `integral_lseries_vonMangoldt_fourier`, the
   closed Fourier coefficient as
   `integral_natCast_cpow_vertical_fourier`, and the closed termwise Fourier
   term as `integral_lseriesTerm_vonMangoldt_fourier`, the full closed
   Fourier form as `integral_lseries_vonMangoldt_fourier_closed`, and the
   Fourier-kernel prime-side identity as
   `integral_logDeriv_mul_I_eq_neg_arch_prime_fourier`, with its closed form
   `integral_logDeriv_mul_I_eq_neg_arch_prime_fourier_closed` (using
   `fourierCoeffClosed`, and numerically confirmed to `1.2·10⁻⁷`), whose structural properties
   (`fourierCoeffClosed_self`, `fourierCoeffClosed_add`) confirm its
   boundary-difference nature, and `fourierCoeffClosed_zero` shows it
   specialises to the known `u = 0` closed term.
3. **The explicit formula on the line**: the precise identity with the
   archimedean integral and the prime sum, with constants fixed from a
   reference (Weil 1972; Iwaniec–Kowalski, *Analytic Number Theory*, Thm 5.12).
4. **Weil's criterion**: positivity of the resulting functional on the class of
   test functions with Fourier transform supported in `[−1/2, 1/2]`, equivalent
   to RH. This is the genuinely open statement; no proof exists. **No RH proof yet.**
