# Topological zeta — research programme

**Status:** reconstructed finite formal core + exact computation layer. The RH/topological realisation is retained as a **source claim / open**, never as a theorem.
**Source:** [`archive/maths/rh/research/topological-zeta/index.html`](../../archive/maths/rh/research/topological-zeta/index.html) (a link hub for eleven pages).
**Inventory:** [Scraps](../../scraps.html) item 23 · [Topic index](../README.md).
**Overlap:** the inventory records an overlap with item 21; the S-matrix/Egyptian core below is the self-contained part of this corpus.

## 1. What the programme claims

The corpus is a unified narrative from “geometric sine” to a would-be proof of the Riemann Hypothesis. Its stages are:

1. a trigonometric-free construction of the sine function by dyadic bisection and greedy harmonic selection;
2. Egyptian-fraction decompositions of angles;
3. a “quantum Egyptian” functional equation attached to modular tensor categories (MTCs);
4. identification of greedy selectors with Galois characters, producing **Greedy-Egyptian MTCs**;
5. realisation of the zeta function as a limit of Reshetikhin–Turaev braid invariants, with the critical line as a toroidal symmetry axis and zeros as topological defects;
6. a numerical “non-vanishing floor” programme intended to supply the constants for a contradiction argument.

The source is explicit in several places that stages 4–6 are **frontier, conditional, or speculative**. The introductory ebook says “No published proof exists—this is frontier conjecture”; the proof sketch labels the key inputs Conjecture 1 and an asymmetry lemma; the numerical papers say numerics “does not replace human proof”.

The part of the corpus that is genuinely finite and checkable is the **modular data algebra**: quantum dimensions, the total dimension, Egyptian denominators, the Ising/`SU(2)₄` S-matrices, and the finite Dirichlet polynomials. That is what this folder reconstructs and formalises.

## 2. Provenance

The archived folder contains twelve files (the index plus eleven pages):

| File | Role |
|---|---|
| [`index.html`](../../archive/maths/rh/research/topological-zeta/index.html) | Link hub; states the unified pathway in its introduction. |
| [`path-to-rh-proof.html`](../../archive/maths/rh/research/topological-zeta/path-to-rh-proof.html) | Unified paper: Pythagoras → Egyptian fractions → MTCs → topological zeta → RH. |
| [`greedy-egyptian-mtcs.html`](../../archive/maths/rh/research/topological-zeta/greedy-egyptian-mtcs.html) | Greedy selectors as Galois characters; “Greedy-Egyptian MTCs” frontier statement. Contains the Egyptian-identity misstatement corrected below. |
| [`mtc-dirichlet-functional-equation.html`](../../archive/maths/rh/research/topological-zeta/mtc-dirichlet-functional-equation.html) | The most careful paper: finite-rank MTC data, Egyptian identity, `Ψ_{C,χ}`, completion, conditional functional equation, Ising and `SU(2)₄` examples, three open problems. |
| [`topological-zeta-introduction.html`](../../archive/maths/rh/research/topological-zeta/topological-zeta-introduction.html) | Speculative ebook; chapter 5 claims RH “in this speculative framework”, chapter 6 retracts it as not a proof. |
| [`topological-zeta-proof-sketch.html`](../../archive/maths/rh/research/topological-zeta/topological-zeta-proof-sketch.html) | Conditional “Topological Zeta Rigidity” theorem; Conjecture 1 and asymmetry lemma stated as gaps. |
| [`topological-zeta-limiting-factor.html`](../../archive/maths/rh/research/topological-zeta/topological-zeta-limiting-factor.html) | Braids → coloured Jones → RT → zeta; the missing `k → ∞` limit. |
| [`numerical-path-to-proof.html`](../../archive/maths/rh/research/topological-zeta/numerical-path-to-proof.html) | Computing the floor `δ_k`; claims a crossing by `k ≈ 50`. |
| [`path-to-rigorous-proof.html`](../../archive/maths/rh/research/topological-zeta/path-to-rigorous-proof.html) | The four analytic steps a human proof would still need. |
| [`quaternion-lifting-of-rh.html`](../../archive/maths/rh/research/topological-zeta/quaternion-lifting-of-rh.html) | Quaternion-lifted energy functional reformulation. |
| [`quaternion-lifting-of-rh-v2.html`](../../archive/maths/rh/research/topological-zeta/quaternion-lifting-of-rh-v2.html) | Revised quaternion lifting. |
| [`quaternion-lifting-of-rh.tex`](../../archive/maths/rh/research/topological-zeta/quaternion-lifting-of-rh.tex) | LaTeX source of the quaternion paper. |

The corpus is coherent but repetitive: the same conditional argument is restated across the ebooks. It is **not** a proof of RH, and it does not claim to be one in its most careful paper.

## 3. Reconstructed objects and notation

| Object | Definition |
|---|---|
| Simple objects | `X_i`, `i = 0, …, r−1`, with `X_0 = 1` the unit. |
| Quantum dimensions | `d_i > 0`; `d_0 = 1`; `d_{i*} = d_i`. |
| Total dimension | `D² = ∑_i d_i²`, `D > 0`. |
| Egyptian denominator | `m_i = D² / d_i²`; integral when `d_i² ∣ D²`. |
| Egyptian identity | `∑_i 1/m_i = 1`; with the unit separated, `∑_{i≠0} 1/m_i = 1 − 1/D²`. |
| S-matrix | `S_{ij}`, symmetric and unitary, with `S_{0i} = d_i/D`. |
| Galois character | `χ_σ : I → {±1}` induced by `σ ∈ Gal(K/ℚ)` acting on `S_{0i}` with signs `ε_σ`. |
| MTC Dirichlet polynomial | `Ψ_{C,χ}(s) = ∑_i χ(m_i) m_i^{−s}` (a finite exponential polynomial, entire). |
| Completion | `Λ(s) = (q/π)^{(s+a)/2} Γ((s+a)/2) Ψ(s)`, `q = D²`, `a ∈ {0,1}`. |
| Ising data | `(d_i) = (1, √2, 1)`, `D² = 4`, `(m_i) = (4, 2, 4)`, `χ = (1, −1, 1)`. |
| `SU(2)₄` data | `(d_i) = (1, √3, 2, √3, 1)`, `D² = 12`, `(m_i) = (12, 4, 3, 4, 12)`. |
| Ising polynomial | `Ψ(s) = 2·4^{−s} − 2^{−s} = 2^{−s}(2^{1−s} − 1)`, zero at `s = 1`. |

The “topological zeta” of the title is **not** a new zeta function defined in the corpus: it is the name for the proposed limit `lim_k Z_k(s) = ζ(s)` of normalised Reshetikhin–Turaev invariants. That limit is a conjecture.

## 4. Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | For squared quantum dimensions `d_i²` with `D² = ∑ d_i² ≠ 0`, `∑_i d_i²/D² = 1`. | `TopologicalZeta.egyptian_identity` |
| T2 | Theorem | If the unit has `d_0² = 1`, then `∑_{i≠0} d_i²/D² = 1 − 1/D²` (the non-unit Egyptian identity). | `TopologicalZeta.egyptian_nonunit` |
| T3 | Theorem | The Ising S-matrix is symmetric. | `TopologicalZeta.isingS_symm` |
| T4 | Theorem | The Ising S-matrix is an involution, `S · S = 1` (unitarity, since `S` is real symmetric). | `TopologicalZeta.isingS_mul_self` |
| T5 | Theorem | The Ising polynomial factorises: `2·4^{−s} − 2^{−s} = 2^{−s}(2^{1−s} − 1)` for real `s`. | `TopologicalZeta.isingPsi_factor` |
| T6 | Theorem | The Ising polynomial vanishes at `s = 1`: `Ψ(1) = 0`. | `TopologicalZeta.isingPsi_one` |
| T7 | Theorem | `1/12 + 1/4 + 1/3 + 1/4 + 1/12 = 1` exactly (the `SU(2)₄` Egyptian identity). | `TopologicalZeta.su2_4_egyptian` |
| C1 | Computation | Ising `D² = 4`, `(m_i) = (4,2,4)`, `∑ 1/m_i = 1`, non-unit sum `3/4`. | `test_ising_egyptian_data` |
| C2 | Computation | `SU(2)₄`: `D² = 12`, `(m_i) = (12,4,3,4,12)`, `∑ 1/m_i = 1`, non-unit sum `11/12`. | `test_su2_4_egyptian_data` |
| C3 | Computation | The Ising S-matrix is symmetric, unitary, and satisfies `S_{0i} = d_i/D`. | `test_ising_s_matrix` |
| C4 | Computation | `SU(2)_k` S-matrices are symmetric, unitary, and satisfy `S_{0i} = d_i/D` for `k = 1,2,4`. | `test_su2_s_matrix_levels` |
| C5 | Computation | `Ψ(s)` factorises and `Ψ(1) = 0`, `Ψ(2) = −1/8`. | `test_ising_psi_factorisation_and_zero` |
| C6 | Computation | The source's completion of `Ψ` has **no constant root number**: `Λ(s)/Λ(1−s)` varies by more than `0.1` across samples (30-digit mpmath). | `test_claimed_completion_functional_equation_fails` |
| C7 | Computation | Degenerate inputs (empty, non-positive, mismatched, level `0`) raise `ValueError`. | `test_edge_cases_reject_degenerate_data` |

### Source claims (not promoted to theorems)

| # | Claim | Archived status | Reconstruction note |
|---|---|---|---|
| S1 | **Conjecture 1:** `Z_k(s) = lim_N RT_k(B_N(s))/RT_k(B_N(0))` has an analytic continuation and `lim_k Z_k(s) = ζ(s)` uniformly on compacts. | Source conjecture; open | Not formalised. No definition of `RT_k` or of the limit is given in the corpus. |
| S2 | **Asymmetry lemma:** for `Re(s) ≠ 1/2`, `RT_k(B_N(s)) ≠ 0` for large `k,N`, and the normalised limit is non-zero. | Source lemma without proof; open | Not formalised. The source itself lists it as a gap. |
| S3 | **Topological Zeta Rigidity:** S1 + S2 imply RH. | Source “conditional theorem” | The implication is only as strong as S1–S2, neither of which is proved. It is **not** a theorem of this reconstruction. |
| S4 | “Hence no off-line zeros. RH holds. Q.E.D. (in this speculative framework).” | Archived speculative claim, explicitly caveated by the same source | Recorded as speculative; the source’s chapter 6 says it is “not a formal proof”. |
| S5 | The Ising and `SU(2)₄` completions satisfy `Λ(s) = εΛ(1−s)` with `ε = 1`, “verified numerically to 10 significant figures”. | Source claim | **Erratum:** not reproducible. C6 shows the ratio `Λ(s)/Λ(1−s)` is not constant, so no `ε` of modulus one exists for the stated completion. |
| S6 | “In an MTC of rank `r`, `∑_{i=1}^r 1/m_i = 1 − 1/D²`.” | Source claim in `greedy-egyptian-mtcs.html` | **Misstatement:** the full sum is `1` (T1). The non-unit sum `∑_{i≠0} 1/m_i = 1 − 1/D²` is T2, and is the version the later rigorous paper states. |
| S7 | “There exists a hybrid family of Greedy-Egyptian MTCs…” with exact finite functional equations and an asymptotic irrational case. | Source “Theorem”; frontier/speculative | No construction of the family is given, and the convergence of the `k → ∞` limit is undefined. Not formalised. |
| S8 | Numerical floor `δ_k ≥ k^{−C}` and modular error `≤ exp(−πk)`, crossing by `k ≈ 50`. | Source numerical plan | Not a computation performed in the source; no data tables are supplied. Recorded as an open numerical programme. |

## 5. Python layer

[`python/programme.py`](python/programme.py) implements the exact finite layer:

- `quantum_denominators(dims)` → `(D², m_i)`, with positivity validation;
- `denominators_are_integral(ms)`, `egyptian_sum(ms)`, `nonunit_egyptian_sum(ms)`;
- `ising_dims()`, `su2_dims(k)` (quantum dimensions from `q`-integers);
- `ising_S()`, `su2_S(k)`, `is_unitary`, `is_symmetric`, `s_matrix_quantum_dimensions`;
- `psi(ms, chi, s)`, `ising_psi(s)`, `ising_psi_factored(s)`;
- `completed_psi(...)`, `ising_completion(s)`, `completion_ratios(samples)` for the
  high-precision check of the source's claimed functional equation.

All checks are exact over `ℚ(√2)` and `ℚ(√3)` except the completion test, which uses
mpmath at 30 decimal digits (tolerance stated in the test).

```bash
cd the-final-letter/topics/topological-zeta
python3 -m pytest -q tests
```

Recorded result: **7 passed** in under 1 second.

## 6. Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the namespace `TopologicalZeta`, and proves T1–T7. The formal core is deliberately small: it contains the Egyptian identity (general and non-unit), the symmetry and involution property of the Ising S-matrix, the Ising polynomial factorisation and zero, and the exact `SU(2)₄` identity.

```bash
cd the-final-letter/topics/topological-zeta
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

What is **not** formalised is listed in [`lean/README.md`](lean/README.md): no category theory, no ribbon/MTC axioms, no Reshetikhin–Turaev invariants, no analytic continuation, no zeta function, no limit `k → ∞`, no Galois action on modular data, and no functional equation. In particular, the Lean file does **not** prove the source's conditional rigidity theorem or anything about RH.

## 7. Errata and limitations

1. **The stated functional equation is false for the stated completion.** With `q = 4`, `a = 0`, `Ψ(s) = 2·4^{−s} − 2^{−s}`, the ratio `Λ(s)/Λ(1−s)` takes values approximately `−0.63 − 0.15i`, `0.043 + 0.20i`, and `−0.0038 − 0.019i` at `s = 0.7+2i`, `1.5+3i`, `2.0+i`. No constant `ε` can satisfy the claimed equation. The source's “10 significant figures” verification is not reproducible.
2. **The Egyptian identity is misstated in the greedy paper.** The full sum is `1`, not `1 − 1/D²`; the latter is the sum over non-unit objects. The later `mtc-dirichlet-functional-equation.html` paper contains the correction.
3. **“Topological zeta” is a proposed limit, not a defined object.** The corpus does not define the braid family or the RT invariant precisely enough to state Conjecture 1 as a mathematical conjecture in a fixed formalism.
4. **The RH conclusion is conditional and speculative.** The source's own caveats (intro chapter 6; proof-sketch conclusion; numerical paper conclusion) say so. This dossier follows those caveats.
5. **The quaternion-lifting papers are not reconstructed here.** They are a separate reformulation of the “geometric RH”; they are listed in provenance but are not part of the finite MTC core.

## 8. Open / conjecture items (not proved)

Every row below is **Open / conjecture**: none is proved in this reconstruction.

| # | Open / conjecture | Status |
|---|---|---|
| O1 | Prove Hypothesis 6.1 (Galois self-duality) for arbitrary weakly integral MTCs. | Source Open Problem 10.1; open. |
| O2 | Control the infinite-rank limit `SU(2)_k`, `k → ∞`: convergence, functional equation, root number. | Source Open Problem 10.2; open. |
| O3 | The MTC analogue of RH: are all zeros of `Ψ_{C,χ}` on `Re(s) = 1/2`? | Source Open Problem 10.3; open (and false as a literal analogue for the Ising polynomial, whose only zero is `s = 1`). |
| O4 | Define the braid family `B_N(s)` and `RT_k` precisely; prove or refute Conjecture 1. | Open; source gives no definition adequate for formalisation. |
| O5 | Establish the non-vanishing floor `δ_k ≥ k^{−C}` and the modular error `≤ exp(−πk)` uniformly. | Open analytic programme; no data in the source. |
| O6 | Find the correct completion/functional equation, if any, for finite MTC Dirichlet polynomials. | Open; the stated completion fails (C6). |
| O7 | Give a precise definition of “Greedy-Egyptian MTCs” and of their claimed asymptotic functional equation. | Open; the source's “Theorem” has no construction. |

## 9. Provenance and links

- Source hub: [`archive/.../topological-zeta/index.html`](../../archive/maths/rh/research/topological-zeta/index.html)
- Careful finite paper: [`mtc-dirichlet-functional-equation.html`](../../archive/maths/rh/research/topological-zeta/mtc-dirichlet-functional-equation.html)
- [Scraps inventory](../../scraps.html) — item 23.
- [Topic index](../README.md) — all reconstructed topics.
- [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
