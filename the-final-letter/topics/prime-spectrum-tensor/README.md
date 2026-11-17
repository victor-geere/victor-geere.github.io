# Prime-spectrum tensor — research programme

**Status:** reconstructed finite formal core + exact computation layer; the source's defining inequality is an archived claim that the companion resolution refutes, not a theorem of this folder. The exact Gaussian Weil–Gram matrices at `σ = 1/20` are now **Lean-proved positive definite** for the 4×4 basis (T13, O4 closed), the 5×5 basis (T14, M0′), the 6×6 basis (T17), the 7×7 basis (T25) and the 8×8 basis (T27); all are finite certificates, not the infinite Weil cone and not RH. A first rung of the Weil ladder is isolated (T15), the margin-scaling wall is recorded in [`MARGIN-SCALING.md`](MARGIN-SCALING.md) (C24), and the zero-side half of the bridge is Lean-checked in [`../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean) (see [`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md)); the equality with `W` is numerical (C25) and open. [`WEIL-GRAM.md`](WEIL-GRAM.md) also records the earlier numerical 4×4 interval certificate at a conservative `10^{−4}` margin, backed by [`TAIL-PROOF.md`](TAIL-PROOF.md) and the final `U=6` run (C22). The ladder is closed to `n = 8` with a clean audit, and frozen as an executable calibration target ([`CALIBRATION.md`](CALIBRATION.md)); the sub-cone route to the infinite form is analysed, with three candidates excluded, in [`SUB-CONE.md`](SUB-CONE.md).
**Source:** [`tensor.html`](../../geometric-dynamical-phase-transitions/tensor.html) and the companion resolution [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md).  
**Inventory:** [Scraps](../../scraps.html) item 4 · [Topic index](../README.md).  
**Zero-side programme:** [`../zero-side-bridge/`](../zero-side-bridge/README.md) — the
formal route from the finite certificates to `Σ_ρ ĝ_c(γ_ρ)`, with the contour half
Lean-checked and the equality numerical.
**Next-stage handoff:** [`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) — the ladder
closed to `n = 6`, the `n = 7` rung and its one open band, the calibration
target, and the analysed routes beyond.

## Abstract

`tensor.html` proposes to replace the Riemann hypothesis by a positivity statement
on the additive group `ℝ` — `⟨P, f∗f̌⟩ ≥ 0` for every `f` in the Weil cone, with
`P = Π + Θ` — and reads the zeros of `ξ` as the atoms of the resulting spectrum.
The companion [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md)
refutes that statement as written and identifies Weil's classical current `W` as
the correct repair, whose positivity is Weil's criterion and therefore equivalent
to RH. This folder reconstructs the unconditionally checkable core of that story
and certifies it.

**What was achieved.** The exact Gaussian Weil–Gram matrices at `σ = 1/20` are
Lean-proved positive definite, with no hypotheses and a clean audit, on the 4-,
5-, 6-, 7- and 8-point bases (T13, T14, T17, T25, T27). Each is a finite rational
certificate — exact matrix, eight-decimal Toeplitz centre, rational `LDLᵀ` with
rational margin `t`, entrywise transfer `n·ε < t < λ_min` — resting on certified
interval enclosures of all three terms of the explicit formula: eight density
chains of 780–1042 panels on the second-order `h³` rule, rational pole enclosures,
and bespoke von Mangoldt prime enclosures at each new separation. The ladder is
frozen as an executable calibration target ([`CALIBRATION.md`](CALIBRATION.md))
with its margins and witness vectors, and the zero-side half of the bridge is
Lean-checked against it.

**What was not achieved.** No step whatever to the infinite form. The ladder is
*measured* to terminate: `λ_min` falls from `2.271·10⁻²` at `n = 4` to
`9.743·10⁻³` at `n = 8`, then collapses by a factor `10.9` at `n = 9`, which
would need `ε < 9.96·10⁻⁵` and roughly ten times the panel count — beyond this
machine. The cause is structural, not arithmetic: the pole term is exactly rank
two and unbounded (T24), yet the pole-free subspace `{u = 0}` collapses at the
same rate as the full matrix (C30), so the degeneracy is intrinsic to the
Gaussian basis and no sub-cone of it survives (see [`SUB-CONE.md`](SUB-CONE.md)).
And because a finite truncation of a positive form is automatically positive
definite, no rung can ever *support* RH — the ladder can only fail, and the value
of the computation lies in locating the ceiling rather than in approaching it.

Everything here is a finite certificate or a negative structural result. Nothing
here is a proof of the Riemann hypothesis, and the equality with the zero side
remains numerical.

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
| T13 | Theorem | **Finite 4×4 Gaussian Weil–Gram certificate (O4, closed):** the exact matrix at `σ = 1/20`, centres `−0.3, −0.1, 0.1, 0.3`, is positive definite. The entrywise enclosure is closed by the generated density bands `DensityE0…E3`, the pole and prime enclosures, and the exact rational `L D Lᵀ` transfer. | `PrimeSpectrumTensor.gaussianGram4_posDef` |
| T14 | Theorem | **Finite 5×5 Gaussian Weil–Gram certificate (M0′, closed):** the exact matrix at `σ = 1/20`, centres `−0.4, −0.2, 0, 0.2, 0.4`, is positive definite. The new separation `c = 4/5` is enclosed by `DensityE4` and `primeTerm_mem_four_fifths`; the transfer is `L5 D5 L5ᵀ`. | `PrimeSpectrumTensor.gaussianGram5_posDef` |
| T15 | Theorem | **First rung of the Weil ladder:** the single Gaussian at `σ = 1/20` has `0.0396 < W(0) < 0.0467`; the lower bound is the numerical margin of `WEIL-POSITIVITY.md` §6. | `PrimeSpectrumTensor.gaussianW_zero_mem`, `gaussianW_zero_pos` |
| T16 | Theorem | **Zero-side pole identity:** the pole term of the finite Gram entry is exactly `H_c(0)+H_c(1)` for the zero-side Gaussian `H_c(s)=2πσ²e^{σ²(s−1/2)²}e^{−c(s−1/2)}`. This is the first formal link between the Gram side and the explicit-formula side; the archimedean and prime terms are not identified here. | `PrimeSpectrumTensor.poleTerm_eq_zeroSideGaussian_pole`, `poleTerm_eq_zeroSideGaussian_pole_re` |
| T17 | Theorem | **Finite 6×6 Gaussian Weil–Gram certificate (M0′ at `n=6`, closed):** the exact matrix at `σ = 1/20`, centres `0, 1/5, …, 1`, is positive definite with no hypotheses. The six density bands come from the compact chains `DensityG0 … G5` (779-panel partition to `T = 80`, second-order `h³` panel rule, shared `Ω` module, rounded cumulative sums, and the `|Ω′| ≤ 5/(2t)` Lipschitz constant of T18); the entry budget is `ε = 8·10⁻⁴` with `6ε = 0.0048 < 1/70`, and every separation is inside the `n = 7` budget `ε < 1.777·10⁻³`. | `PrimeSpectrumTensor.gaussianGram6_posDef` |
| T18 | Theorem | **Sharper Lipschitz constant for `Ω`:** `|Ω′(t)| ≤ 5/(2t)` for `t ≥ 1`, from `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 5/(2a)`. The previous bound was `6/t`; the true constant is `2.148/t`, so this is within 4% of optimal for the head/tail route. Every panel error is linear in it: the same 1878-panel partition now certifies `K = 4.92·10⁻⁴` instead of `7.64·10⁻⁴`. | `PrimeSpectrumTensor.deriv_Omega_abs_le_five_halves` |
| T19 | Theorem | **Second derivative of `Ω`:** `|Ω″(t)| ≤ 5/t²` for `t ≥ 1`, from `ψ″ = −2Σ(z+j)⁻³` and the `5/(2a)` tsum bound; also `deriv Ω` differentiable. This is the analytic input of the second-order panel rule. | `PrimeSpectrumTensor.abs_deriv2_Omega_le` |
| T20 | Theorem | **Second-order panel certificate:** with `B` a bound on the panel integrand's second derivative, `|∫ wΩ − h·w(m)Ω(m)| ≤ B·h³/4` — `h³` per panel instead of `h²`. Bundled with the panel form `|(wΩ)″| ≤ W₂·|Ω| + 2W₁L + W·|Ω″|` and the decaying weight bounds `|w′| ≤ (1/400)(|t|/200+|c|)`, `|w″| ≤ (1/400)e^{−a²/400}(…)`. | `PrimeSpectrumTensor.panel_certificate_second_order` |
| T21 | Theorem | **Density tail at any split point `T ≥ 60`:** the Gaussian moment integrates exactly, so `|∫_{T}^{∞} wΩ| ≤ e^{−T²/400}/2`; at `T = 80` this is below `10⁻⁷` (against `6.2·10⁻⁵` at `T = 60`). Moving `T` is only available under the second-order rule, whose weight bounds carry no upper limit. | `PrimeSpectrumTensor.density_tail_le_of`, `density_tail_le_eighty` |
| T22 | Theorem | **Second-order panel certificate, generator form:** `panel_second_order_certificate` takes the `Ω` bracket, the rational node value and the six panel bounds, and returns the enclosure in the `R = qmid·(h·w0)` form the cumulative chain consumes. `panels.py --order 2` emits it. | `PrimeSpectrumTensor.panel_second_order_certificate` |
| T23 | Theorem | **Second-order density chains (`DensityG0 … DensityG5`):** 779 panels to `T = 80`, five chunks each, shared `DensitySO9`; the 6×6 re-closed with `ε = 8·10⁻⁴` (was `15·10⁻⁴`), worst entry deviation `7.356·10⁻⁴`. 2.4× fewer chunks than the superseded 1878-panel first-order chains and a 1.9× tighter bound. | `PrimeSpectrumTensor.G0.density_mem_c0` … `G5.density_mem_c5` |
| T24 | Theorem | **The pole term is rank two and unbounded:** `poleTerm c σ = 4πσ²e^{σ²/4}cosh(c/2)`; for any finite centre family `Σ_{a,b} x_a x_b poleTerm(c_a−c_b)σ = 4πσ²e^{σ²/4}·u·v` with `u = Σ x_a e^{c_a/2}`, `v = Σ x_a e^{−c_a/2}`; hence no decay, Hilbert–Schmidt or diagonal-dominance argument reaches the Weil Gram matrix. Also `u = 0 ⇒` the pole part vanishes (the natural codimension-two pole-free subspace). | `PrimeSpectrumTensor.sum_poleTerm_eq`, `poleTerm_growth`, `poleTerm_unbounded`, `sum_poleTerm_eq_zero` |
| T25 | Theorem | **The `7 × 7` installation, unconditional:** the exact matrix `gaussianGram7`, the Toeplitz centre matrix `gramCentre7` with its rational `LDLᵀ` (margin `3/250`, min pivot `2.57·10⁻³`), the entrywise transfer `gaussianGram7_posDef_of_entry_bound`, the pole enclosure at `c = 6/5` (`[0.037264, 0.037267]`), and the prime enclosure at `c = 6/5` — `primeTerm (6/5) ∈ [−0.042181, −0.042124]`, `primeTerm (−6/5) ∈ [−10⁻⁵, 0]`, hence the symmetrised band — discharging the last hypothesis. `ε = 11/10000`, `7ε = 0.0077 < 1/100`. | `PrimeSpectrumTensor.gaussianGram7_posDef` |
| T27 | Theorem | **The `8 × 8` installation, unconditional:** the exact matrix `gaussianGram8`, the Toeplitz centre matrix `gramCentre8` with its rational `LDLᵀ` (margin `1/110`, all pivots positive), the pole enclosure at `c = 7/5` (`[0.039455, 0.039458]`), the density chain `DensityG7` (1042 panels on `gen/edges_1042_c75.txt`, `densityTerm` half-width `6.373·10⁻⁴`) and the prime band `primeTerm (7/5) ∈ [−0.06192, −0.06185]` in [`lean/PrimeEnclosure8.lean`](lean/PrimeEnclosure8.lean). `ε = 11/10000`, `8ε = 0.0088 < 1/110 = 0.00909`. | `PrimeSpectrumTensor.gaussianGram8_posDef` |
| T26 | Benchmark | **The calibration target** ([`CALIBRATION.md`](CALIBRATION.md)): the certified ladder `n = 4, 5, 6, 7, 8` (all unconditional), the witness vectors (minimising unit eigenvectors rounded to `1/1000`) with their numerical Rayleigh quotients and certified windows, the zero-side table, and four acceptance criteria for a claimed positivity bridge. | `CALIBRATION.md` |

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
| C23 | Computation | The 5×5 Gaussian Weil–Gram matrix at `σ=1/20`, centres `−0.4,−0.2,0,0.2,0.4`, is symmetric with diagonal `0.043135958…`, smallest eigenvalue `2.1424·10^{−2}`, eigenvalues `[0.021423782, 0.022829404, 0.036997559, 0.049985978, 0.084443069]`, and an active prime term `−0.0277501…` at `c=0.8` (30 digits; numerical companion to T14, not a certificate). | `test_gaussian_weil_gram_5x5_rung_is_positive` |
| C24 | Computation | **Margin-scaling audit:** the spacing-0.2 ladder at `σ=1/20` has `λ_min(6)=0.016707845`, `λ_min(9)=0.000896802`; the factor-10 collapse at `n=9` and the budget `n·ε < λ_min(n)` rule out continuing at the current panel width. See [`MARGIN-SCALING.md`](MARGIN-SCALING.md). | `test_gaussian_margin_scaling_wall` |
| C25 | Computation | **Zero-side bridge check:** the first 40 non-trivial zeros reproduce `gaussianGramEntry 0 c (1/20)` for `c = 0, 1/5, 2/5, 3/5, 4/5` to `< 10^{−17}`; the zero sum is symmetrised by the zero set, so it lands on the Gram entry. See [`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md). | `test_zero_side_sum_matches_gaussian_gram_entry` |
| C26 | Computation | **Compact certificate audit:** the six `densityTerm` bands at the 1878-panel error-equalising partition, built with `|Ω′| ≤ 5/(2t)`, certify entry errors `1.00–1.01·10⁻³` (`c = 0, 1/5, 2/5, 3/5`), `1.36·10⁻³` (`c = 4/5`) and `1.25·10⁻³` (`c = 1`), all below `ε = 1.5·10⁻³ < 1/420`. The predicted half-widths are reproduced exactly by `lean/gen/predict.py`. See [`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §1–2. | `test_six_by_six_entry_bound_is_met_by_the_certified_bands` |
| C27 | Computation | **Lipschitz-cost audit (T18):** with `|Ω′| ≤ 5/(2t)` the error-equalising partition reaches `K = 7.13·10⁻⁴` with 1270 panels (against 1878 panels for `7.64·10⁻⁴` at `6/t`), and at the unchanged 1878 midpoints `K` falls to `4.92·10⁻⁴`. Reproduced by `lean/gen/predict.py --lip-c`. See [`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §4.2. | `predict.py --lip-c 5/2` |
| C28 | Computation | **Second-order panel-rule audit:** modelling `PanelSecondOrder.panel_certificate_second_order` with `gen/predict.py --order 2`, the `c = 0` chain reaches `K = 2.34·10⁻⁴` with 388 panels (3.3× fewer than the 1270-panel first-order certificate, at 3× tighter width), and `K = 1.08·10⁻⁴` at 1270 panels; the floor is the `1/10000` tail bound of `density_tail_le` at `T = 60`. See [`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §4.4. | `predict.py --order 2` |
| C29 | Computation | **Sub-cone numerics:** the Weil kernel at `σ = 1/20` reproduced to 15 digits (`W(0) = 0.043135958394838`, `G(0.2) = −0.01648926`, `G(0.6) = −0.00222044`); the pole term grows from `0.0314` to `2.33` at separation `10` while the prime term cancels it to `−2.36`, leaving a residual of order `10⁻²` — the zeros' contribution. `Ω(0) = −5.37218`, first zero at `t₀ = 6.28984`, so the density symbol is negative on `(0, t₀)`. See [`SUB-CONE.md`](SUB-CONE.md) §2.3, §3.2. | `SUB-CONE.md` §2.3 |
| C30 | Computation | **The pole-free sub-cone fails numerically:** annihilating the pole exactly on `{u = 0}` leaves `λ_min` collapsing at the same rate as the full Gram matrix (`1.67·10⁻²` at `n = 6` → `1.44·10⁻⁸` at `n = 34`, on the natural ladder `0, 1/5, …`). Also: the pole term reads `f̂(±i/2)`, so a real-frequency band-pass cannot control it; the correct candidate imposes both conditions. See [`SUB-CONE.md`](SUB-CONE.md) §5.1–§5.2. | `SUB-CONE.md` §5.1 |
| C31 | Computation | **The `c = 6/5` density chain:** `DensityG6`, 779 panels, second-order `h³` rule, five chunks, shared `DensitySO9`; band `[-0.0054554, -0.0040457]` (`densityTerm` half-width `1.41·10⁻³`). Wider than the other six separations because `edges_779` was optimised for `c = 0` and the second-order constant grows like `c²`. | `PrimeSpectrumTensor.G6.density_mem_c6` |

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
7. **Finite Gram matrix.** [`WEIL-GRAM.md`](WEIL-GRAM.md) records the numerical rungs and a rational shadow certified by T12. The `Ω` interval layer (C9) encloses `Ω` pointwise; the interval quadrature of the density term is generated ([`lean/DensityG0_0.lean`](lean/DensityG0_0.lean) … [`lean/DensityG5_4.lean`](lean/DensityG5_4.lean), on a shared `Ω` module) and the pole and prime terms are enclosed ([`lean/PoleEnclosure.lean`](lean/PoleEnclosure.lean), [`lean/PrimeEnclosure.lean`](lean/PrimeEnclosure.lean)). Together they certify the exact 4×4 matrix (`gaussianGram4_posDef`, T13) and, with the new `c = 4/5` separation, the exact 5×5 matrix (`gaussianGram5_posDef`, T14) and, with the `c = 1` separation, the exact 6×6 matrix (`gaussianGram6_posDef`, T17), and, with the `c = 6/5` separation, the exact 7×7 matrix (`gaussianGram7_posDef`, T25). The generated chains are `lean/DensityG0_0 … G5_4` (779 panels, second-order rule, `T = 80`) plus the shared `DensitySO9` module; the first-order `DensityF*` chains and their `DensitySO_*` module, the intermediate `DensityE*` chains (built with `6/t`) and the legacy `DensityC*` chains were removed on 2026-11-16/17 and 2026-11-15 respectively (recoverable from git history). The infinite Gram/positivity statement remains open.

8. **Zero-side bridge.** The explicit-formula contour identity for the Gaussian
   zero-side test function is Lean-checked
   (`gaussian_zero_side_contour`, T20 in
   [`../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean)).
   The equality of the zero sum with `W` is numerical to `< 10⁻¹⁷` (C25) and
   remains open as a theorem: the prime/archimedean evaluation and the
   infinite-zero limit are the missing analytic inputs.  See
   [`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md).
9. **Margin scaling.** The finite ladder's `λ_min` collapses at `n = 9`; the
   budget `n·ε < λ_min(n)` and the required panel widths are recorded in
   [`MARGIN-SCALING.md`](MARGIN-SCALING.md) (C24).

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

Current result: **26 passed** (about one minute; C8 matrix/Cholesky, C9 interval enclosure, C10 prime tail, C11 Simpson rule, C12 derivative diagnostic, C13/C14 jet layer, C15–C17 Taylor panels and assembly, C18–C22 PSD certificates, comparisons, audited rerun and tail-proof certificate).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and defines the namespace `PrimeSpectrumTensor`. It proves T1–T12; [`lean/DensityCertificates.lean`](lean/DensityCertificates.lean) proves T13 and [`lean/DensityCertificates5.lean`](lean/DensityCertificates5.lean) proves T14, and
[`lean/Closure6.lean`](lean/Closure6.lean) proves T17. There is no `sorry`, `axiom` or
`admit`; `./lean/check.sh Audit.lean` prints the axiom dependencies of all three rungs.

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
