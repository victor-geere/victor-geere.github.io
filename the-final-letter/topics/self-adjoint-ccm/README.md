# Self-adjoint / CCM operator — research programme

**Status:** speculative source blueprint; reconstructed elementary formal core + exact computation layer. The CCM Conjecture 1, the self-adjointness assertion, the torsion-distribution limit, and the trace formula are preserved as source claims and open items, not proved here.  
**Inventory:** [Scraps](../../scraps.html) item 22 · [Topic index](../README.md).  
**Source:** [`archive/maths/rh/research/self-adjoint-operator/rh-ccm-generalised-helix-path.html`](../../archive/maths/rh/research/self-adjoint-operator/rh-ccm-generalised-helix-path.html) (a 2025 geometric blueprint; the same directory also holds its `.tex` source and a companion `rh-ccm-conjecture1-generalised-helix.tex`).  
**Bridge assessment:** [`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md) ranks this dossier as the best available *shape* of route to Weil positivity (B4). The bridge development in [`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) shows that the operator as written has a lattice spectrum, and that its finite compression has a negative corner growing with the band limit; the advertised first concrete step (M0) is therefore a refutation, not a positive certificate.

## Provenance and status of the source

The archived paper, *The Generalised Riemann Helix and the Connes–Consani–Moscovici Spectral Triple: A Geometric Blueprint for the Hilbert–Pólya Programme*, is a **blueprint, not a proof**. It does three things:

1. it defines a classical curve — the generalised Riemann helix — whose angular phase is tuned to the non-trivial zeros of an `L`-function;
2. it writes down a Dirac operator `D_λ` with point interactions at the prime logarithms `m log p`, and asserts that this operator is the self-adjoint realisation of the CCM scaling operator;
3. it reduces the CCM Conjecture 1 to two analytic problems — WKB asymptotics and a finite-dimensional trace formula, the two halves of the source's **Gap 3** — with spectrum identification as **Gap 4**. The source's Gap 1 (the phase construction) and Gap 2 (the rigorous Dirac operator) remain source claims here.

The paper is explicit that RH and GRH are *not* proved by it. Its construction of the phase `φ` assumes the zeros lie on the critical line (GRH) and are enumerated there. This dossier therefore separates:

- what can be **proved** from the paper's own definitions (a small calculus and bookkeeping core, in Lean and sympy);
- what the paper **asserts** (self-adjointness, the CCM matrix identification, the trace formula, the torsion distribution);
- what remains **open** (Conjecture 1, WKB estimates, trace convergence, spectrum identification).

A caution on scope: the inventory note calls this "the largest genuine research corpus". That describes the *file count* of the surrounding directory (the rh1–rh25 sequence, torus papers, Lean files), not the logical status of this particular paper. The source page used here is a single speculative blueprint.

## Weil-positivity bridge: the short version

The bridge survey asks which dossier can reach `W(g) ≥ 0`. The chain is: a self-adjoint operator `D` with spectrum `{γ_n}`, its spectral measure `Σ δ_{γ_n}`, an identification `W(f*f̌) = ∫ ĝ dμ_D`, and positivity. The last step is formal; the identification is the bridge.

[`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) develops the CCM candidate through this chain and records two finite obstructions. First, with the blueprint's constant matching condition, the spectrum of `D_λ` is the arithmetic progression `(Θ + 2πn)/L` (or the antiperiodic shift), independent of the prime positions; it cannot be the zero set. Second, the formal band-limited compression `Q_{kℓ} = ⟨e_k, D_λ e_ℓ⟩` has diagonal `ε μ_k + S/L`; the corner `Q_{−N,−N}` diverges linearly and is negative for all sufficiently large `N`. The compression is therefore not positive semidefinite and cannot be the positive CCM Weil matrix.

What survives is a genuine finite core — Hermiticity (T8), the exact diagonal (T9), positivity of the prime/delta part (T10), and unitarity of the matching product (T11) — together with a sharp filter on repairs. The recommended finite step is a Weil Gram matrix on a smooth test basis, as in [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md); a first numerical 4×4 instance with an active prime term is in [`WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md). The operator repair needs an energy-dependent matching, which the displayed equation does not have.

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| Period | `L = 2 log λ`, with `λ > 1` |
| Hilbert space | `H_λ = L²[0, L]`; the prose says periodic, but the half-integer modes `e_k` are antiperiodic |
| Fourier modes | `e_k(x) = exp(i μ_k x)`, `μ_k = (2π/L)(k + ½)`, `k ∈ ℤ` |
| Band limit | `E_N(λ) = span{e_k : |k| ≤ N}`, of dimension `2N + 1` |
| Helix phase | smooth, strictly increasing `φ` with `φ(γ_n) = 2πn` |
| Generalised helix | `C(t) = (cos φ(t), sin φ(t), t)` |
| Torsion (source eq. 1) | `τ = p(p⁴ − p r + 3q²)/(p⁶ + p⁴ + q²)`, `p = φ'`, `q = φ''`, `r = φ'''` |
| Point-interaction potential | `D_λ = i d/dx + Σ_{p^m ≤ λ²} c(p^m) p^{−m/2} δ(x − m log p mod L)` |
| Matching condition | `ψ(x_j⁺) = exp(i c(p^m) p^{−m/2}) ψ(x_j⁻)` |
| Arithmetic coefficients | `c(p^m)` from `−L'/L(s)`; for `ζ`, `c(p^m) = log p` for every `m ≥ 1`, matching Λ(p^m) |
| Logarithmic coordinate | `x = log t`, so a prime power sits at `x = m log p` |

The torsion formula is a genuine identity for the curve as defined: `python/programme.frenet_torsion` computes the Frenet–Serret torsion independently and agrees with the source formula symbolically (computation C2). What the source does **not** prove is that this torsion converges to the arithmetic delta distribution, nor that the quantised operator has the claimed spectrum.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a passing test in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The helix projects onto the unit cylinder: `(cos φ)² + (sin φ)² = 1`. | `CCM.helix_on_unit_cylinder` |
| T2 | Theorem | The torsion denominator is positive: `0 < p⁶ + p⁴ + q²` for `p > 0`. | `CCM.torsion_denom_pos` |
| T3 | Theorem | For a constant phase rate (`q = r = 0`) the source torsion is the exact constant `p/(1 + p²)`. | `CCM.torsion_const_phase` |
| T4 | Theorem | That constant is positive for `p > 0`. | `CCM.torsion_const_phase_pos` |
| T5 | Theorem | The point-interaction matching coefficient is unitary: `‖exp(i c)‖ = 1`. | `CCM.matching_unitary` |
| T6 | Theorem | The CCM frequencies satisfy `μ_{−k−1} = −μ_k` (conjugate-mode symmetry). | `CCM.frequency_symmetry` |
| T7 | Theorem | For `p > 1`, `λ > 0`: `p^m ≤ λ² ⇔ m log p ≤ 2 log λ` (the logarithmic cutoff dictionary). | `CCM.prime_power_cutoff_iff` |
| T8 | Theorem | The finite CCM compression `Q_{kℓ}` is Hermitian. | `CCM.ccmMatrix_isHermitian` |
| T9 | Theorem | In the dossier's sign convention its diagonal is exactly `μ_k + S/L`, with `S = Σ α_j`; the opposite convention negates the free term. | `CCM.ccmMatrix_diag` |
| T10 | Theorem | The prime/delta part is positive semidefinite for non-negative couplings. | `CCM.deltaForm_nonneg` |
| T11 | Theorem | The product of the point-interaction matching phases is unitary. | `CCM.matchingProduct_unitary` |
| C1 | Computation | The helix projection has squared norm `1` for several test phases. | `test_helix_lies_on_unit_cylinder` |
| C2 | Computation | The Frenet–Serret torsion equals the source formula (1) for three regular phases. | `test_frenet_torsion_matches_source_formula` |
| C3 | Computation | Constant-phase torsion is exactly `ω/(1 + ω²)`, with `τ(ω) = τ(1/ω)` and the factorisation `p⁶ + p⁴ = p⁴(p² + 1)`. | `test_constant_phase_torsion_exact_and_symmetric` |
| C4 | Computation | The frequency gap is `2π/L`, independent of `k`, and `μ_{−k−1} = −μ_k` on a grid. | `test_frequency_gap_and_conjugate_symmetry` |
| C5 | Computation | `|exp(i c)|² = 1` symbolically and at four sample couplings. | `test_matching_coefficient_has_unit_modulus` |
| C6 | Computation | `log(p^m) = m log p` exactly, and the cutoff `p^m ≤ λ²` agrees with `m log p ≤ 2 log λ` on a grid (50-digit log comparison). | `test_log_prime_power_and_cutoff_dictionary` |
| C7 | Computation | The zeta coefficients are `c(p, m) = log p` for every `m ≥ 1`, consistent with `Λ(p^m) = log p` on prime powers. | `test_zeta_arithmetic_coefficients` |
| C8 | Computation | Degenerate inputs are rejected: zero or negative phase rate, zero period, `p ≤ 1`, non-prime base. | `test_edge_cases_reject_degenerate_phase` |
| C9 | Computation | `Q` is Hermitian to `< 10^{−30}`, its corner is negative, and the delta part is PSD to `< 10^{−25}` at `λ=5, N=5` (40 digits). | `test_ccm_compression_is_hermitian_with_negative_corner` |
| C10 | Computation | The smallest eigenvalue is negative and deepens linearly: `−6.8581` at `N=5`, `−16.7031` at `N=10` for `λ=5`. | `test_ccm_compression_is_not_positive_and_corner_scales` |
| C11 | Computation | The constant-matching spectrum is equally spaced, with phase `−1` (antiperiodic) or `+1` (periodic), to `< 10^{−30}`. | `test_uniform_matching_spectrum_is_equally_spaced` |

## Source claims (not promoted to theorems)

| # | Claim | Source status | Reconstruction note |
|---|---|---|---|
| S1 | **CCM Conjecture 1**: the ground-state coefficients equal `c_j = Σ_{p ≤ λ²} (log p)/√p · exp(−i(2π/L)(j − N + ½) log p) + E_j`, with `|E_j| ≪ (log L)^C L^{−δ}`. | Open conjecture (restated from CCM 2025); explicitly the central open problem. | Not formalised; no test claims it. |
| S2 | The torsion of the helix is `Σ c(p^m) p^{−m/2} δ(t − m log p)` plus a smooth background. | Source claim, derived via a bump-width limit of `φ'`; no proof. | Only the algebraic torsion formula is checked (C2); the distributional limit is not. |
| S3 | `D_λ` is essentially self-adjoint on its natural domain, with purely discrete real spectrum. | Source claim, citing Albeverio–Gesztesy–Høegh-Krohn–Holden. | T5/T11 prove unitarity of the matching only; the domain is not constructed. [`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) shows that constant matching gives a lattice spectrum, so self-adjointness alone would not give the zeros. |
| S4 | The band-limited projection of `D_λ` coincides with the CCM Weil matrix `Q_{kℓ} = QW(e_k, e_ℓ)`. | Source claim; the "dictionary". | Not formalised, and false for the formal compression as written: `Q` has diagonal `ε μ_k + S/L` and a negative corner for large `N` (T9, C9–C10), so it is not the positive Weil matrix. The test-space side is also ill-posed on the half-integer modes. |
| S5 | Finite-dimensional trace formula `Tr_{E_N}(h(D_λ)) = Σ c(p^m) p^{−m/2} h(m log p) + smooth errors`. | Source claim, eq. (4). | Not formalised; error term unspecified beyond "smooth". |
| S6 | Conjecture 1 reduces to WKB asymptotics and the trace formula (Gap 3a/3b). | Source claim / programme. | This is a reduction claim, not a theorem. |
| S7 | Eigenvalues of `D_∞` are exactly `±γ_n`. | Source claim, conditional on Gap 3. | Not formalised. For the displayed constant-matching operator, Proposition 1 of [`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) excludes this. |
| S8 | The construction generalises to all automorphic `L`-functions, giving a uniform route to GRH. | Source claim; assumes GRH to build `φ`. | Not formalised; GRH is not proved. |
| S9 | A smooth strictly increasing `φ` with `φ(γ_n) = 2πn` exists. | Construction conditional on the zeros being on the critical line and enumerated (GRH assumed "for simplicity"). | Not formalised; existence is by monotone interpolation once GRH is assumed. |

## Open items and gaps

1. **CCM Conjecture 1 (S1).** The central open statement; nothing here bears on its truth.
2. **WKB asymptotics (Gap 3a).** Uniform resolvent analysis of `D_λ` near zero energy with many weak point interactions; not attempted.
3. **Trace-formula convergence (Gap 3b).** The source expects an `O(L^{−1/3+ε})` error via Krein's spectral shift function; not proved.
4. **Spectrum identification (Gap 4).** Conditional on 2 and 3; not proved.
5. **Derivation of the torsion formula in Lean.** `torsionFormula` is a definition taken from the source; T2–T4 study it, but the equality with the Frenet–Serret torsion of `helix` is only checked symbolically in Python (C2). A Lean derivation needs a `ℝ³` cross-product/Frenet development.
6. **Self-adjointness (S3).** Even the elementary unitary matching condition (T5) does not give a self-adjoint operator; deficiency indices, domains, and resolvents are outside this core.
7. **Distributional torsion (S2) and the smooth background.** The bump construction and its limit are not formalised.
8. **The `2N + 1` dimension of `E_N(λ)`** is stated in the source and is elementary (`Finset.Icc (−N) N`), but is not included in the Lean core because it plays no role in the torsion analysis below.
9. **Bridge obstruction (constant matching).** For the displayed matching condition, the spectrum is a lattice independent of the prime positions; this excludes S7 as written: S3 may still hold, but it cannot deliver the zeros. See [`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) §2.
10. **Compression is not the positive Weil matrix.** Its diagonal has a negative corner for large `N` (T9, C9–C10); the delta part alone is PSD (T10). A repair must renormalise or replace the compression, not merely symmetrise it.
11. **Test-space mismatch.** The half-integer modes are antiperiodic and lie outside the Weil cone, so `QW(e_k,e_ℓ)` is not defined without a regularisation. S4 is ill-posed as stated.
12. **Energy-dependent matching.** The only operator repair that escapes the lattice no-go is a genuinely energy-dependent scattering matrix from a different quantisation; none is constructed here.

## Python layer

[`python/programme.py`](python/programme.py) is a sympy-exact module with no import side effects. It implements:

- `helix(phi, t)` and `helix_projection_norm_sq(phi)`;
- `frenet_torsion(phi, t)` from the curve, and `source_torsion(phi, t)` from equation (1);
- `torsion_denominator(p, q)` and `const_phase_torsion(omega)`;
- `frequency(L, k)`, `frequency_gap(L)`;
- `matching_coefficient(c)` and `matching_modulus_sq(c)`;
- `log_prime_power(p, m)` and `prime_power_cutoff(p, m, lam)`;
- `zeta_coefficient(p, m)` and `von_mangoldt(n)`;
- `prime_power_terms(lam)` and `prime_power_weight_sum(lam)` for the exact coupling data;
- `ccm_frequencies(L, N)`, `ccm_compression_matrix(lam, N, sign)` and `ccm_compression_diagonal(lam, N, k, sign)` for the finite bridge matrix;
- `uniform_matching_spectrum(L, theta, n, antiperiodic)` for the constant-matching no-go.

Run the suite:

```bash
cd the-final-letter/topics/self-adjoint-ccm
python3 -m pytest -q tests
```

Current result: **11 passed** (about 3 seconds). C6 still compares logarithms at 50 digits; the new C9–C11 use 40-digit `mpmath` for the Hermitian matrix, its eigenvalues and the matching phase. All other checks are exact symbolic algebra.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports `Mathlib`, opens the namespace `CCM`, and proves T1–T11. It contains no `sorry`, `axiom`, or `admit`. [`lean/README.md`](lean/README.md) records what is and is not formalised.

```bash
cd the-final-letter/topics/self-adjoint-ccm
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK   Topic.lean (23s)`.

## What would change the verdict

The programme would become a mathematical proof of RH only if S1–S7 were proved, and in particular if the WKB estimate and the trace-formula convergence were established with the stated error bounds. The bridge development shows a prior obstruction: S4/S7 fail for the displayed constant-matching operator, and S3—even if proved—would only give a lattice; proving S1 alone would not close the bridge. The dossier would reopen if an energy-dependent matching or a renormalised operator with a bounded diagonal and the correct spectral measure were constructed (see [`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) §6). Until then this folder documents a geometric *reduction* with a verified elementary core. The honest summary is: **the helix and its torsion formula are real and checkable; the operator is a proposal whose spectrum is a lattice; the positivity bridge is blocked as written.**

## Provenance

- [`WEIL-BRIDGE.md`](WEIL-BRIDGE.md) — the bridge development, the constant-matching no-go, and the compression obstruction.
- [`scraps.html`](../../scraps.html) — inventory entry 22.
- [`topics/README.md`](../README.md) — all topic folders.
- [`archive/maths/rh/research/self-adjoint-operator/`](../../archive/maths/rh/research/self-adjoint-operator) — the source directory: the blueprint HTML, its `.tex`, the companion Conjecture 1 note, and the helix/torus papers.
- The completed pilot, [`greedy-harmonic-decomposition/`](../greedy-harmonic-decomposition/README.md), supplies the dossier and ledger format.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
