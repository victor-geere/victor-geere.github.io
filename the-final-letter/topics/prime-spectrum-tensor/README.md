# Prime-spectrum tensor — research programme

**Status:** reconstructed finite formal core + exact computation layer; the source's defining inequality is an archived claim that the companion resolution refutes, not a theorem of this folder.  
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
| C1 | Computation | `Λ` is exact (`Λ(8)=log 2`, `Λ(9)=log 3`, `Λ(6)=Λ(12)=0`) with the `n<0` edge case rejected. | `test_von_mangoldt_exact_and_edge_cases` |
| C2 | Computation | Prime weights are non-negative; the finite prime current on the constant test function is positive and vanishes for an empty truncation. | `test_prime_weights_are_nonnegative` |
| C3 | Computation | The pole weight identity `|f̂₀(i/2)|² = 4 cos²(γ/4) e^{-(γ²-1/4)/2}` is exact (sympy, no tolerance). | `test_pole_weight_identity_is_exact` |
| C4 | Computation | The closed form of `g₀ = f₀*f₀` matches direct convolution at three points to `< 10^{-20}` (mpmath, 30 dps). | `test_witness_convolution_matches_closed_form` |
| C5 | Computation | The Theorem B witness has `Π(g₀) = -0.6776451473…`, `Θ(g₀) = +0.0003426692…` and total `-0.6773024781… < 0` (mpmath, 25 dps, tolerance `10^{-6}`/`10^{-8}`). | `test_theorem_b_witness_is_negative` |
| C6 | Computation | Every Jacobi term and the truncated series are positive on a grid for `u ≥ 0`; the empty series is zero and `n=0` is rejected. | `test_jacobi_terms_and_series_are_positive` |
| C7 | Computation | The finite Gram form agrees with the modal sum `Σ_k w_k|Z_k|²` to `< 10^{-20}` and has non-negative real part; the empty tuple gives zero and mismatched lengths are rejected. | `test_finite_gram_form_is_nonnegative_and_matches_modes` |

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

1. **RH / Weil positivity.** The statement `⟨W, f*f̌⟩ ≥ 0` for all `f` in the cone is equivalent to RH and remains open. This folder does not assume it, prove it, or use it. A route assessment of the five proposed capture mechanisms, with a recommended finite first target, is in [`WEIL-POSITIVITY.md`](WEIL-POSITIVITY.md).
2. **Explicit formula.** Formalising Lemmas 2.1–2.4 (Fourier transform of the square, `Φ̂ = ½ Ξ_cos`, contour shift, Weil explicit formula) is the main analytic gap.
3. **Infinite spectral resolution.** The companion's Theorem A and Theorem C are analytic identities on the cone; the Lean file only treats a finite positive atomic model.
4. **Joint non-vanishing.** The surviving open statement of `tensor.md` Corollary 6.2 — that `K(α,·)` and `S(α,·)` never vanish jointly for `α ≠ 0` — is exactly RH and is not formalised.
5. **Higher tensors.** Pair correlation and `n`-point analogues (`tensor.html` §7) are a programme, not results; no formal core is attempted here.
6. **Numerical scope.** C5 uses the first `2×10⁴` prime powers and 13 Jacobi terms; the truncated tails are below the stated tolerances, but this is a reproduction of the source's witness, not a proof of Theorem B.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact objects:

- `von_mangoldt(n)`, `prime_weight(n)`, `prime_current(f, N)`;
- `phi_term(n, u)`, `phi_series(u, terms)` for the Jacobi density;
- `fhat0(t, gamma)`, `g0(v, gamma)`, `pole_weight(gamma)` for the Gaussian witness;
- `atomic_kernel`, `mode_sum`, `gram_form`, `mode_sq_sum` for the finite spectral model.

Symbolic identities use sympy; the numerical checks use mpmath at 25–30 significant digits and state their tolerances in the tests. Importing the module has no side effects.

Run the suite:

```bash
cd the-final-letter/topics/prime-spectrum-tensor
python3 -m pytest -q tests
```

Current result: **7 passed** (under two seconds).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and defines the namespace `PrimeSpectrumTensor`. It proves T1–T7. There is no `sorry`, `axiom` or `admit`.

```bash
cd the-final-letter/topics/prime-spectrum-tensor
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See [`lean/README.md`](lean/README.md) for exactly what is and is not formalised.

## Provenance

- [`tensor.html`](../../geometric-dynamical-phase-transitions/tensor.html) — the canonical source, inventory item 4.
- [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md) — companion resolution: Theorem A, the refutation Theorem B, the Weil-current repair Theorem C, and the numerical appendix.
- [`scraps.html`](../../scraps.html) — the scrap inventory.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
