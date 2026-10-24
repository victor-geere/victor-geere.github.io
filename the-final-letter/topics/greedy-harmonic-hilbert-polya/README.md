# Greedy-harmonic Hilbert–Pólya — research programme

**Status:** reconstructed formal core (local quadratic factors + finite trace bookkeeping) and an exact computation layer; the analytic framework and the Mellin bijectivity remain source claims / open. The archived "RH/GRH proved" page is recorded as a **withdrawn archived claim**, not as a theorem.  
**Source:** [`archive/maths/greedy-harmonic-hilbert-polya/index.html`](../../archive/maths/greedy-harmonic-hilbert-polya/index.html) (14 files in the folder).  
**Inventory:** [Scraps](../../scraps.html) item 26 · [Topic index](../README.md).

## Provenance and archive status

The folder is not a single coherent paper. It contains at least four layers written at different times:

| File | What it is | Status used here |
|---|---|---|
| [`index.html`](../../archive/maths/greedy-harmonic-hilbert-polya/index.html) | Summary of the framework: remainder map, transfer operator, self-adjoint `H`, resolvent kernel, quadratic factors, trace formula, spectral shift, twisted Selberg formula, Galois action, and the **open** Mellin bijectivity. | Primary source; own status: open gap. |
| [`paper.md`](../../archive/maths/greedy-harmonic-hilbert-polya/paper.md) | Long paper version of the same programme. Sections 7–8 give the local quadratics and explicit Galerkin eigenvalues used below. | Source for the algebraic core. |
| [`phi.html`](../../archive/maths/greedy-harmonic-hilbert-polya/phi.html), [`analytic-continuation.html`](../../archive/maths/greedy-harmonic-hilbert-polya/analytic-continuation.html) | Later extensions (eta sign-flip, mismatch `Δ(t)`, fixed-point map `φ`, Jacobian-conditioned mismatch). | Source claims; not formalised. |
| [`framework.html`](../../archive/maths/greedy-harmonic-hilbert-polya/framework.html) | Claims a "complete proof of RH/GRH" via global monotonicity of `Δ(t)`. | **Archived claim, withdrawn/superseded.** Contradicted by `index.html`, `phi.html` and by the audit files below. Never presented as a theorem. |
| [`deepseek-checked*.html`](../../archive/maths/greedy-harmonic-hilbert-polya/deepseek-checked4.html) | Audit records. They state explicitly that the Fredholm determinant identity, self-adjointness of `ℒ_{1/2+it}`, and the bijectivity are **not proved**, and that RH/GRH is not proved. | Used as the honest-status authority where pages conflict. |
| [`ghd-inversion.html`](../../archive/maths/greedy-harmonic-hilbert-polya/ghd-inversion.html) | Corrected diagonal-plus-rank-2 construction; explicitly says it "does not prove the Riemann Hypothesis". | Source claim for the rank-2 determinant factorisation; not formalised. |

The reconstruction therefore takes the **algebraic core that the source actually writes down** — the local quadratic factors and their roots/Vieta data — and proves that core. Everything analytic (operator domain, determinant identity, trace formula, Mellin bijectivity) is left where the archive leaves it: asserted or open.

## What the programme is

The greedy harmonic decomposition writes a target angle `θ ∈ [0, π]` as a sub-sum of harmonic angles

\[
\alpha_n=\frac{\pi}{n+2},\qquad n=0,1,2,\ldots
\]

using the greedy rule: include `α_n` iff the remaining residual is at least `α_n`. The scaled remainder `x_n = (n+2) r_n / π` obeys the source's remainder map

\[
x_{n+1}=\left(1+\frac{1}{n+2}\right)\bigl(x_n-\mathbf 1_{x_n\ge 1}\bigr),
\]

whose continuous limit is claimed to be the Berry–Keating sawtooth flow `x(τ) = {x_0 e^τ}`, `τ = log(n+2)`.

The Hilbert–Pólya step of the archive is a quantisation of that flow:

\[
H=-i\left(x\frac{\partial}{\partial x}+\tfrac12\right),\qquad
D(H)=\{\phi\in H^1([0,1]):\phi(1^-)=\phi(0^+)\}.
\]

Projecting `H` onto a greedy-adapted Haar basis is claimed to give `2 × 2` blocks whose characteristic polynomials are the **local quadratic factors**

\[
Q_0(s)=s^2-\tfrac32 s+\tfrac14,
\]

\[
Q_n(s)=s^2-\frac{2n+3}{n+2}\,s+\frac{2n+3}{(n+1)(n+2)^2}
\qquad(n\ge 1).
\]

Their roots are the explicit Galerkin eigenvalues

\[
\lambda_{0,\pm}=\frac{3\pm\sqrt5}{4},
\qquad
\lambda_{n,\pm}=
\frac{(2n+3)\pm\sqrt{\dfrac{(2n+3)(2n^2+5n-1)}{n+1}}}{2(n+2)}
\quad(n\ge 1).
\]

This folder reconstructs **the quadratics and the finite bookkeeping of their roots**. It does not reconstruct the derivation of the quadratics from `H`, because that derivation is only a proof sketch in the source and depends on the unformalised operator.

## Reconstructed objects and notation

| Object | Definition used here |
|---|---|
| Harmonic angle | `α n = π/(n+2)` |
| Base local factor | `Q₀(s) = s² − (3/2)s + 1/4` |
| General local factor | `Qₙ(s) = s² − ((2n+3)/(n+2))s + (2n+3)/((n+1)(n+2)²)`, `n ≥ 1` |
| Base discriminant | `disc₀ = (3/2)² − 4·(1/4) = 5/4` |
| General discriminant | `disc n = ((2n+3)/(n+2))² − 4(2n+3)/((n+1)(n+2)²)` |
| Roots | `λ n,±` as displayed above |
| Block trace | `trₙ = λ n,− + λ n,+ = (2n+3)/(n+2)` (and `3/2` for `n = 0`) |
| Block determinant | `detₙ = λ n,− · λ n,+ = (2n+3)/((n+1)(n+2)²)` (and `1/4` for `n = 0`) |
| Finite trace | `∑_{n<N} trₙ = 2N + 1 − H_{N+1}` |
| Finite determinant | `∏_{n<N} detₙ = (2N+1)! / (3·2^N·(N!)²·((N+1)!)²)` for `N ≥ 1`, and `1` for `N = 0` |
| Mellin correspondence | Source object `spec(H) ↔ {t : L(1/2+it,χ)=0}`; **not constructed here** |

The finite trace and determinant closed forms are derived in the Python layer and proved as finite identities; they are bookkeeping consequences of Vieta, not new spectral theorems.

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every **Computation** row is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The base discriminant is positive. | `GHHP.disc0_pos` |
| T2 | Theorem | The explicit base roots `(3 ± √5)/4` satisfy `Q₀`. | `GHHP.Q0_roots` |
| T3 | Theorem | The constant term of every `Qₙ` is strictly positive. | `GHHP.Q_const_pos` |
| T4 | Theorem | `disc n = (2n+3)(2n²+5n−1)/((n+1)(n+2)²)` exactly. | `GHHP.Q_discriminant` |
| T5 | Theorem | For `n ≥ 1`, `disc n > 0`. | `GHHP.Q_discriminant_pos` |
| T6 | Theorem | For `n ≥ 1`, the explicit `λ n,±` are roots of `Qₙ`. | `GHHP.Q_roots` |
| T7 | Theorem | Vieta bookkeeping: `λ n,− + λ n,+` and `λ n,− · λ n,+` equal the `Qₙ` coefficients. | `GHHP.Q_vieta` |
| C1 | Computation | `Q₀` has exact roots `(3 ± √5)/4`, sum `3/2`, product `1/4`, discriminant `5/4`. | `test_q0_exact_roots_and_coefficients` |
| C2 | Computation | The coefficient discriminant equals the source closed form for `1 ≤ n ≤ 50`. | `test_qn_discriminant_closed_form` |
| C3 | Computation | The explicit roots satisfy `Qₙ` exactly for `1 ≤ n ≤ 40`. | `test_qn_closed_form_roots_satisfy_quadratic` |
| C4 | Computation | Vieta sum/product and block trace/determinant agree for `1 ≤ n ≤ 50`. | `test_qn_vieta_bookkeeping` |
| C5 | Computation | The ordering `0 < λ n,− < 1 < λ n,+` holds to 40 digits for `0 ≤ n ≤ 150`. | `test_eigenvalue_ordering_and_tolerance_edge` |
| C6 | Computation | Partial trace equals `2N + 1 − H_{N+1}` exactly for `0 ≤ N ≤ 30`. | `test_partial_trace_closed_form` |
| C7 | Computation | Partial determinant equals the factorial closed form for `0 ≤ N ≤ 15`. | `test_partial_determinant_closed_form` |
| C8 | Computation | Index errors, the `n = 0` separation, and a near-miss non-root. | `test_index_and_edge_cases` |

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| Remainder map limit is the Berry–Keating sawtooth flow. | Source proof sketch | Not formalised; the map is discrete and finite, the limit is analytic. |
| `det(I − ℒ_s) = ζ(s)/ζ(2s) · e^{P(s)}`. | Source "theorem", proof sketch; audit files say **not proved**. | Recorded as a source claim. The audit explicitly lists the missing link to `ζ`. |
| `H = −i(x∂_x + 1/2)` is essentially self-adjoint on its domain. | Source proof sketch; audit says self-adjointness of `ℒ_{1/2+it}` not proved. | Not formalised. No operator domain is constructed in Lean. |
| Explicit resolvent kernel `K_λ(x,y)`. | Source proof sketch | Not formalised; depends on the operator and inverse branches. |
| `Qₙ` is the characteristic polynomial of the Galerkin projection of `H`. | Source "Theorem 7.1", integration-by-parts sketch. | **Only the quadratics themselves are formalised.** The derivation from `H` is not. |
| Haar trace formula `tr(e^{−iτH}) = ∑ₙ(e^{−iτλ n,+}+e^{−iτλ n,−})`. | Source proof sketch; depends on the same Galerkin claim. | Not formalised. T7 supplies the per-block trace only. |
| Spectral shift function `ξ(t)` series. | Source proposition | Not formalised. |
| Twisted Selberg trace formula for Dirichlet characters. | Source claim; no proof in the archive. | Not formalised. |
| Galois invariance of the Galerkin spectrum. | Source observation from rational coefficients. | Not formalised; the rational coefficients are visible in T4. |
| Inclusion `Z_η ⊆ {t : Δ(t) = 0}`. | Source "proved inclusion", proof sketch. | Not formalised; `Δ` is not constructed here. |
| Numerical agreement with the first 100 zeros. | Source numerical claim; not reproducible from the folder. | Not used as evidence for a theorem. |
| "RH and GRH are proved" (`framework.html`). | **Archived claim, withdrawn/superseded.** Contradicted by `index.html`, `phi.html`, and `deepseek-checked*.html`. | **Not a theorem. Not accepted.** |

## Open items and gaps

1. **Mellin bijectivity (the main open statement).** The source claims that the critical-line correspondence is unitary, that one direction (critical zeros → spectrum of `H`) is proved, and that the converse is open and equivalent to RH/GRH. The audit files confirm the equivalence is unproven in both directions. No part of this is formalised here.
2. **Fredholm determinant identity.** The link `det(I − ℒ_s) = ζ(s)/ζ(2s)e^{P(s)}` is asserted but not derived in the archive; the audit files call it unproved. It is a source claim.
3. **Self-adjointness and the operator domain.** `H` is written down formally, but essential self-adjointness and the transmission condition are not checked. This is a prerequisite for any Hilbert–Pólya reading.
4. **Galerkin derivation of `Qₙ`.** The source's integration-by-parts argument is a sketch. This reconstruction starts from the quadratics, not from `H`.
5. **Global monotonicity of `Δ(t)`.** `framework.html` uses it to claim RH; `phi.html` still calls the exhaustion of real zeros open. The monotonicity claim has no proof in the archive.
6. **Trace formula convergence.** Even the per-block trace identity T7 does not give convergence of the infinite trace. Conditional convergence and the periodic-orbit side are untouched.
7. **No RH/GRH claim.** Nothing in this folder proves, assumes, or implies RH, GRH, twin primes, Chowla, or Sarnak.

## Python layer

[`python/programme.py`](python/programme.py) is an exact sympy layer. It defines `q0`, `q_n`, `disc0`, `discriminant`, `discriminant_closed_form`, `roots0`, `roots_n`, `vieta_sum`, `vieta_product`, `block_trace`, `block_constant`, `partial_trace`, `partial_trace_closed_form`, `partial_determinant`, `partial_determinant_closed_form`, and a high-precision ordering check `eigenvalue_ordering_holds`. It has no import-time side effects and raises `ValueError`/`TypeError` on invalid indices.

Run the tests:

```bash
cd the-final-letter/topics/greedy-harmonic-hilbert-polya
python3 -m pytest -q tests
```

Current result: **8 passed** (about 5 s). The suite uses sympy only; no floating-point tolerance is used except in the explicitly numerical ordering check, which is evaluated to 40 significant digits.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `GHHP` namespace, defines `Q0`, `Q`, `disc0`, `disc`, `lamPlus`, `lamMinus`, and proves T1–T7. There is no `sorry`, `axiom`, or `admit`. The file is checked against the local Mathlib installation by the shared script:

```bash
cd the-final-letter/topics/greedy-harmonic-hilbert-polya
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See [`lean/README.md`](lean/README.md) for the precise boundary between the formal core and the source claims.

## Links

- [Scraps inventory, item 26](../../scraps.html)
- [Topic index](../README.md)
- [Programme standard](../PROGRAMME-STANDARD.md)
- [The Final Letter](../../index.html)
- [Pilot topic: greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md)

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
