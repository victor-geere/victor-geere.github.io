# Prime-spectrum tensor — research programme

**Status:** reconstructed finite formal core + exact computation layer; the source's defining inequality is an archived claim that the companion resolution refutes, not a theorem of this folder. [`WEIL-GRAM.md`](WEIL-GRAM.md) now records a finite 4×4 Gaussian Gram matrix PSD certificate at a conservative `10^{−4}` interval margin, backed by the term-by-term tail proof in [`TAIL-PROOF.md`](TAIL-PROOF.md) and the final `U=6` run (C22); it is a finite computational certificate, not a Lean theorem and not RH.
**Source:** [`tensor.html`](../../geometric-dynamical-phase-transitions/tensor.html) and the companion resolution [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md).  
**Inventory:** [Scraps](../../scraps.html) item 4 · [Topic index](../README.md).

## What the programme is

`tensor.html` proposes to replace the Riemann hypothesis by a positivity statement on the additive group `ℝ`. It defines the prime current

\[
\Pi(f)=\sum_{n\ge 2}\frac{\Lambda(n)}{\sqrt n}\,f(\log n),
\qquad
\Theta(f)=\int_{\mathbb R}\Phi(u)\,f(u)\,du,
\qquad
\mathcal P=\Pi+\Theta,
\]

where `Φ` is Riemann's even positive Jacobi density, and asks for

\[
\bigl\langle\mathcal P,\,f*\check f\bigr\rangle\ge 0
\qquad\text{for every }f\text{ in the Weil cone.}
\tag{\(\star\)}
\]

The note then defines the "prime spectrum" as the Bochner measure of `P` and reads the zeros of `ξ` as its atoms.

The companion [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md) resolves the question and is the authority for the mathematical status of the source:

1. **Theorem A** (companion) computes `⟨P, f* f̌⟩` exactly by the Weil explicit formula. The spectral resolution of `P` is *signed*: a positive pole term at `±i/2`, a negative atom of weight `1/2` at each zero frequency, and a density that is negative near the origin.
2. **Theorem B** (companion) shows that `(⋆)` is **false**: the explicit even witness `f₀` gives `⟨P, f₀*f₀⟩ = -0.6773024781… < 0`. The refutation is unconditional and does not bear on the Riemann hypothesis.
3. **Theorem C** (companion) identifies the repair: Weil's current `W` (prime term with the opposite sign, digamma density, pole modes) has spectrum exactly `Σ_ρ δ_{γ_ρ}`; its positivity on the cone is Weil's classical criterion, hence equivalent to RH.
4. The finite-tuple kernel form of `(⋆)` fails already for the density part: `Φ` is positive but not of positive type (`Φ̂ = ½ Ξ_cos` changes sign).

This folder reconstructs the elementary, unconditionally checkable core of that story. It does **not** claim `(⋆)`, the positivity of `P`, the positivity of `W`, or RH. The analytic theorems A–C remain source claims or open formalisation items; the Lean file proves only finite positivity and symmetry lemmas that the reconstruction actually uses.

## Objects and notation

| Object | Definition | Where |
|---|---|---|
| `Λ(n)` | von Mangoldt function, `log p` on prime powers | `primeWeight`, `von_mangoldt` |
| `Π(f)` | prime current `Σ Λ(n)/√n f(log n)` | `primeCurrent` (finite truncation) |
| `Φ(u)` | Jacobi density, the term-by-term series of `tensor.md` §2 | `jacobiTerm`, `phi_term` |
| `Θ(f)` | archimedean current `∫ Φ f du` | not formalised; `phi_series` |
| `P` | `Π + Θ`, the source's completed current | not formalised |
| `(⋆)` | `⟨P, f*f̌⟩ ≥ 0` on the Weil cone | source claim; refuted in `tensor.md` |
| `f₀` | `(2/√π) e^{-u²} cos(γ₁u)`, Theorem B witness | `fhat0`, `g0` |
| `g₀` | `f₀*f₀`, closed form | `g0` |
| `W` | Weil current: `2∫g cosh(u/2) - 2Π(g) + (1/2π)∫ĝΩ` | not formalised |
| atomic kernel | `K(x)=Σ_k w_k e^{iγ_kx}`, finite real-frequency model of `W`'s spectrum | `atomicKernel`, `atomic_kernel` |
| Gram form | `Σ_{j,l} a_j conj(a_l) K(u_j-u_l)` | `gramForm`, `gram_form` |

The finite atomic model is the part of Theorem C that is purely algebraic: if the spectrum is a positive combination of atoms at real frequencies, the Gram form is non-negative. The infinite statement — that `W`'s spectrum is exactly the zero multiset, and that its positivity is RH — is not formalised.

A first finite step toward the actual `W` (rather than the atomic model) is in [`WEIL-GRAM.md`](WEIL-GRAM.md): a Gaussian test basis, the closed-form reflected convolution, and a numerical 4×4 Gram matrix whose prime side is active and whose smallest eigenvalue is `2.27·10^{−2}`. It is a numerical rung, not a certificate; the missing layer is an interval enclosure of `Ω`.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom` or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). Nothing in this table asserts RH, GRH, twin primes or Chowla.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The prime-current weight is non-negative: `0 ≤ Λ(n)/√n`. | `PrimeSpectrumTensor.primeWeight_nonneg` |
| T2 | Theorem | A finite truncation of `Π` is non-negative on a pointwise non-negative test function. | `PrimeSpectrumTensor.primeCurrent_nonneg` |
| T3 | Theorem | Each Jacobi-density term is positive for `n ≥ 1` and `u ≥ 0`. | `PrimeSpectrumTensor.jacobiTerm_pos` |
| T4 | Theorem | The Fourier atom is Hermitian: `K(-x) = conj K(x)`. | `PrimeSpectrumTensor.atom_neg` |
| T5 | Theorem | The one-frequency Gram form equals `w · Z · conj Z` with `Z = Σ_j a_j e^{iγu_j}`. | `PrimeSpectrumTensor.atomForm_eq` |
| T6 | Theorem | The finite Gram form factors as `Σ_k w_k · Z_k · conj Z_k`. | `PrimeSpectrumTensor.gramForm_eq` |
| T7 | Theorem | If all atomic weights are non-negative, the finite Gram form has non-negative real part. | `PrimeSpectrumTensor.gramForm_re_nonneg` |
| T8 | Theorem | **Finite P5 certificate:** a rational Cholesky factor `L3` gives `G3 = L3ᴴ L3`, hence `G3` is positive semidefinite. | `PrimeSpectrumTensor.G3_posSemidef` |
| T9 | Theorem | **DH-shaped negative witness:** the sign-flipped finite Gram matrix `GDH` is not positive semidefinite; the rational vector `(1,-1)` gives form value `-2`. | `PrimeSpectrumTensor.GDH_not_posSemidef` |
| T10 | Theorem | **Generic finite P5 certificate:** any rational matrix `Lᴴ L` is positive semidefinite. | `PrimeSpectrumTensor.posSemidef_of_cholesky` |
| T11 | Theorem | **Generic negative witness:** a rational vector with negative form value refutes positive semidefiniteness. | `PrimeSpectrumTensor.not_posSemidef_of_neg` |
| T12 | Theorem | **Rational-shadow certificate:** the rounded 4×4 Cholesky factor `L4Shadow` gives a PSD matrix. This certifies the shadow, not the exact transcendental matrix; the numerical proximity is C8, not formalised. | `PrimeSpectrumTensor.L4Shadow_posSemidef` |
| C1 | Computation | `Λ` is exact (`Λ(8)=log 2`, `Λ(9)=log 3`, `Λ(6)=Λ(12)=0`) with the `n<0` edge case rejected. | `test_von_mangoldt_exact_and_edge_cases` |
| C2 | Computation | Prime weights are non-negative; the finite prime current on the constant test function is positive and vanishes for an empty truncation. | `test_prime_weights_are_nonnegative` |
| C3 | Computation | The pole weight identity `|f̂₀(i/2)|² = 4 cos²(γ/4) e^{-(γ²-1/4)/2}` is exact (sympy, no tolerance). | `test_pole_weight_identity_is_exact` |
| C4 | Computation | The closed form of `g₀ = f₀*f₀` matches direct convolution at three points to `< 10^{-20}` (mpmath, 30 dps). | `test_witness_convolution_matches_closed_form` |
| C5 | Computation | The Theorem B witness has `Π(g₀) = -0.6776451473…`, `Θ(g₀) = +0.0003426692…` and total `-0.6773024781… < 0` (mpmath, 25 dps, tolerance `10^{-6}`/`10^{-8}`). | `test_theorem_b_witness_is_negative` |
| C6 | Computation | Every Jacobi term and the truncated series are positive on a grid for `u ≥ 0`; the empty series is zero and `n=0` is rejected. | `test_jacobi_terms_and_series_are_positive` |
| C7 | Computation | The finite Gram form agrees with the modal sum `Σ_k w_k|Z_k|²` to `< 10^{-20}` and has non-negative real part; the empty tuple gives zero and mismatched lengths are rejected. | `test_finite_gram_form_is_nonnegative_and_matches_modes` |
| C8 | Computation | The 4×4 Gaussian Weil Gram matrix at `σ=0.05`, centres `−0.3,−0.1,0.1,0.3`, is symmetric, has diagonal `0.043135958…`, smallest eigenvalue `2.271·10^{−2}`, a positive numerical Cholesky factor, a rational shadow `L L^T` within `4.0·10^{−13}`, and an active prime term `−0.03648…` at `c=0.6` (30 digits; numerical, not certified). | `test_gaussian_weil_gram_is_positive_and_prime_active` |
| C9 | Computation | The interval layer encloses `Ω(t)=Re ψ(1/4+it/2)−log π` at `t=0,0.5,1,10`; widths are `0.0304, 0.00286, 0.00376, 7.1·10^{−5}`. The true values lie inside. This is a rigorous `Ω` enclosure, not yet the density quadrature. | `test_omega_interval_encloses_digamma` |
| C10 | Computation | The crude Gaussian prime-tail bound beyond `X=20000` is below `10^{−100}` for `σ=0.05` and `|c|≤0.6`; the numerical difference between the `X=20000` and `X=40000` truncations is below it. | `test_gaussian_prime_tail_bound_is_negligible` |
| C11 | Computation | The rational-node Simpson rule with `n=4000`, `T=200`, reproduces the adaptive density quadrature at `c=0` and `c=0.6` to `< 10^{−8}`. This is the numerical rule intended for the derivative-bound certificate, not yet a certified quadrature. | `test_gaussian_density_simpson_matches_quadrature` |
| C12 | Computation | The numerical fourth `t`-derivative of the density integrand is below `10^4` at `t=0,1,10` for `σ=0.05,c=0.6`; this sets the target for a rigorous Simpson bound (not a certificate). | `test_gaussian_density_fourth_derivative_is_bounded` |
| C13 | Computation | The interval Taylor-jet layer reproduces the derivatives of `exp`, `log`, `cos` and `sin` at a sample point. | `test_interval_jet_derivatives_match_elementary_functions` |
| C14 | Computation | The `Ω` t-jet encloses the value and first four `t`-derivatives at `t=0.5` (with the current conservative series/tail constants). | `test_omega_t_jet_contains_numeric_derivatives` |
| C15 | Computation | The certified Taylor density panel encloses the true integral on `[0.4,0.6]`, `[10,10.2]`, `[0,0.2]` and `[0.2,0.4]` for `σ=0.05,c=0.6`. | `test_gaussian_density_panel_taylor_encloses_true_integral` |
| C16 | Computation | Ten assembled certified panels enclose the density integral on `[−1,1]` for `σ=0.05,c=0.6`. | `test_gaussian_density_certified_short_range` |
| C17 | Computation | The shared-`Ω` multi-`c` assembly encloses the density integrals at `c=0` and `c=0.6` on `[−1,1]`. | `test_gaussian_density_certified_multi_short_range` |
| C18 | Computation | **Exact PSD certificate** for the `H=0.08` interval Gram matrix, with a conservative `10^{−4}` jet-remainder margin: the center minus `t I` (`t=0.020975…`) has positive rational leading minors; the last is `1.13·10^{−8}`. | `test_h008_interval_gram_center_error_certificate` |
| C19 | Computation | Direct interval leading minors at the `10^{−4}` margin are inconclusive at the fourth minor (`[−1.58·10^{−6}, 6.23·10^{−6}]`), while the center/error certificate succeeds with positive rational shifted minors. | `test_interval_minors_vs_center_error_certificate` |
| C20 | Computation | Exact rational LDL pivots of `center − tI` are positive and equal the Sylvester ratios of the leading minors, confirming the finite PSD check against the exact minor test. | `test_exact_ldl_pivots_match_leading_minors` |
| C21 | Computation | **End-to-end audited rerun** (`H=0.1`, `T=100`, `U=4`, series/tail-audited jet, `10^{−4}` entry margin): `t=0.0210956719`, shifted minors positive; `CERTIFIED`. | `test_audited_h01_interval_gram_certificate` |
| C22 | Computation | **Term-by-term-tail-backed certificate** (`H=0.1`, `T=100`, `U=6`, proven `10^{−5}` tail allowance): `t=0.0211003138`, shifted minors positive; `CERTIFIED`. This supersedes C21 for the tail audit. | `test_tailproof_u6_interval_gram_certificate` |

## Source claims (not promoted to theorems)

These are recorded with the source's status. None is a theorem of this folder.

| Claim | Source status | Reconstruction note |
|---|---|---|
| `(⋆)`: `⟨P, f*f̌⟩ ≥ 0` on the Weil cone | Archived claim; **refuted** by companion Theorem B with value `-0.6773024781…` | C5 verifies the witness numerically. The infinite analytic statement is not formalised, and is not true. |
| Definition 4.1: the prime spectrum is the Bochner measure of `P` | Conditional definition; empty as defined | The antecedent `(⋆)` fails; the object that exists is the spectrum of `W`. |
| "The zeros are real because the group is `ℝ`" | Source assertion; invalid | `P` is not tempered and its resolution has mass off `ℝ` (`tensor.md` Remark 3.2). |
| Kernel form `Σ a_j conj(a_l) P(u_j-u_l) ≥ 0` | Archived claim; **refuted** | `Φ` is not of positive type (`tensor.md` Prop. 5.1); only the finite atomic model is proved here (T7). |
| `(⋆)` replaces / is equivalent to RH | Source claim; **false** | `(⋆)` is false while RH is open; the correct equivalence is Weil positivity for `W` (companion Theorem C). |
| Theorem A: exact signed resolution of `P` | Analytic source theorem (companion), proof by explicit formula | Not formalised; needs the explicit formula and contour estimates. |
| Theorem B: explicit numerical refutation of `(⋆)` | Analytic + numerical source theorem (companion) | C5 reproduces the number from primes and `Φ` only; Lean does not formalise the analytic estimate. |
| Theorem C: Weil current identity and RH equivalence | Classical theorem (Weil 1952; Bombieri 2000), identified in the companion | Not formalised; positivity of `W` on the cone is RH and is open. |
| Propositions 5.1, 6.1–6.3 (positive type, tilted moments, sign law) | Source propositions with analytic proofs and 25-digit checks | Not formalised; recorded as source claims. |

## Open items and gaps

1. **RH / Weil positivity.** The statement `⟨W, f*f̌⟩ ≥ 0` for all `f` in the cone is equivalent to RH and remains open. This folder does not assume it, prove it, or use it. A route assessment of the five proposed capture mechanisms, with a recommended finite first target, is in [`WEIL-POSITIVITY.md`](WEIL-POSITIVITY.md); the survey of which topic dossier supplies the positivity is in [`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md).
2. **Explicit formula.** Formalising Lemmas 2.1–2.4 (Fourier transform of the square, `Φ̂ = ½ Ξ_cos`, contour shift, Weil explicit formula) is the main analytic gap.
3. **Infinite spectral resolution.** The companion's Theorem A and Theorem C are analytic identities on the cone; the Lean file only treats a finite positive atomic model.
4. **Joint non-vanishing.** The surviving open statement of `tensor.md` Corollary 6.2 — that `K(α,·)` and `S(α,·)` never vanish jointly for `α ≠ 0` — is exactly RH and is not formalised.
5. **Higher tensors.** Pair correlation and `n`-point analogues (`tensor.html` §7) are a programme, not results; no formal core is attempted here.
6. **Numerical scope.** C5 uses the first `2×10⁴` prime powers and 13 Jacobi terms; the truncated tails are below the stated tolerances, but this is a reproduction of the source's witness, not a proof of Theorem B.
7. **Finite Gram matrix.** [`WEIL-GRAM.md`](WEIL-GRAM.md) records a numerical PSD Gaussian Gram matrix, including a prime-active row, and a rational shadow certified by T12. The `Ω` interval layer (C9) now encloses `Ω` pointwise; the missing step is interval quadrature of the density term and the prime-tail bound, after which T8/T10 can certify the actual matrix.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact objects:

- `von_mangoldt(n)`, `prime_weight(n)`, `prime_current(f, N)`;
- `phi_term(n, u)`, `phi_series(u, terms)` for the Jacobi density;
- `fhat0(t, gamma)`, `g0(v, gamma)`, `pole_weight(gamma)` for the Gaussian witness;
- `atomic_kernel`, `mode_sum`, `gram_form`, `mode_sq_sum` for the finite spectral model;
- `omega_density`, `gaussian_convolution`, `weil_gaussian_pole`, `weil_gaussian_density`, `weil_gaussian_prime`, `weil_gaussian_W`, `weil_gaussian_cross`, `weil_gaussian_gram`, `gram_eigenvalues` for the Gaussian Weil Gram matrix;
- `omega_interval` and `omega_interval_width` for the rigorous `Ω` enclosure layer;
- `gaussian_prime_tail_bound` for the Gaussian prime-tail estimate;
- `weil_gaussian_density_simpson` for the deterministic density quadrature prototype;
- `omega_t_jet` and the `jet.Jet` interval Taylor algebra for the `t`-jet layer;
- `gaussian_density_panel_taylor` for a certified Taylor panel of the density integrand;
- `gaussian_density_certified` and `gaussian_density_certified_multi` for assembled certified density intervals.

Symbolic identities use sympy; the numerical checks use mpmath at 25–30 significant digits and state their tolerances in the tests. Importing the module has no side effects.

Run the suite:

```bash
cd the-final-letter/topics/prime-spectrum-tensor
python3 -m pytest -q tests
```

Current result: **22 passed** (about one minute; C8 matrix/Cholesky, C9 interval enclosure, C10 prime tail, C11 Simpson rule, C12 derivative diagnostic, C13/C14 jet layer, C15–C17 Taylor panels and assembly, C18–C22 PSD certificates, comparisons, audited rerun and tail-proof certificate).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and defines the namespace `PrimeSpectrumTensor`. It proves T1–T12. There is no `sorry`, `axiom` or `admit`.

```bash
cd the-final-letter/topics/prime-spectrum-tensor
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See [`lean/README.md`](lean/README.md) for exactly what is and is not formalised.

## Provenance

- [`tensor.html`](../../geometric-dynamical-phase-transitions/tensor.html) — the canonical source, inventory item 4.
- [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md) — companion resolution: Theorem A, the refutation Theorem B, the Weil-current repair Theorem C, and the numerical appendix.
- [`WEIL-GRAM.md`](WEIL-GRAM.md) — finite Gaussian Gram matrix and its certified interval result.
- [`TAIL-PROOF.md`](TAIL-PROOF.md) — term-by-term bound for the `Ω` jet tail.
- [`scraps.html`](../../scraps.html) — the scrap inventory.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
