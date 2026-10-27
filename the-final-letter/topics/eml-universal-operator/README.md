# EML universal operator — research programme

**Status:** fragment reconstructed as a small formal core plus an exact computation layer. The archived zeta and Riemann-hypothesis material is preserved as source claim / conjecture, never as a theorem.  
**Source:** [`archive/maths/rh/research/eml/eml-harmonic-zeta.html`](../../archive/maths/rh/research/eml/eml-harmonic-zeta.html), with the companion write-ups [`eml.tex`](../../archive/maths/rh/research/eml/eml.tex) and [`eml-harmonic-zeta.tex`](../../archive/maths/rh/research/eml/eml-harmonic-zeta.tex).  
**Inventory:** [Scraps](../../scraps.html) item 8 · [Topic index](../README.md).

## What the programme is

The source is a short, generated conversation record (15 April 2026) rather than a research paper. Its mathematical substance is the binary operator

\[
\operatorname{eml}(x,y)=\exp(x)-\ln(y),\qquad y>0,
\]

with the constant \(1\), together with the base identities

\[
\exp(z)=\operatorname{eml}(z,1),\qquad
\ln(z)=\operatorname{eml}\!\left(1,\operatorname{eml}\!\left(\operatorname{eml}(1,z),1\right)\right),
\]

and the square-root subtree

\[
\sqrt{u}=\exp\!\left(\tfrac12\ln u\right)=\operatorname{eml}\!\left(\tfrac12\ln u,\,1\right).
\]

The source then asserts functional completeness for elementary functions, recasts one step of Victor Geere's greedy harmonic sine reconstruction as a finite eml tree, and sketches a link to the Riemann zeta functional equation followed by a conjectural route to RH.

This folder reconstructs only the elementary, checkable part: the operator, its two base identities, the square-root identity, and the order structure of `eml · 1`. The three-gate logarithm identity is the nontrivial formal result. Functional completeness, the harmonic fusion rule, the correlation kernel, and the RH sketch are recorded with their source status.

### A source-level defect worth recording

The printed one-step fusion rule is

\[
s_{n+1}=s_n\sqrt{1-h_n^2}+\delta_n\left(h_n\sqrt{1-s_n^2}+s_n\sqrt{1-h_n^2}\right),
\qquad h_n\approx\sin(\pi/(n+2)).
\]

For \(\delta_n=1\) this is \(2s_n\cos h_n+h_n\cos s_n\), not the sine-addition value \(s_n\cos h_n+h_n\cos s_n\). The Python listing in the source uses a third variant, `s += h*sqrt(1-s**2) + s*sqrt(1-h**2)`. Both readings fail once two harmonic angles are selected; at \(\theta=5\pi/12\) the printed recurrence gives about \(0.567\) and the listing about \(1.83\), against \(\sin(5\pi/12)\approx0.966\). The corrected recurrence used in this folder is ordinary sine addition applied only on a selection. This is a source defect, not a result of the reconstruction; see computation C5.

## Objects and notation

| Object | Definition |
|---|---|
| eml operator | `eml(x, y) = exp(x) − log(y)`, with `y > 0` |
| Exponential identity | `exp(z) = eml(z, 1)` |
| Logarithm identity | `log(z) = eml(1, eml(eml(1, z), 1))` |
| Square-root identity | `sqrt(u) = eml(log(u)/2, 1)` |
| First-argument order | `x ↦ eml(x, 1)` is strictly increasing |
| Harmonic angle | `α n = π/(n+2)` |
| Greedy selector | `δ n(θ) = 1` when `θ − accumulated ≥ α n`, else `0` |
| Printed fusion rule | `F(s, h, δ) = s sqrt(1−h²) + δ (h sqrt(1−s²) + s sqrt(1−h²))` |
| Corrected fusion | `sin(A+α) = sin A cos α + cos A sin α`, applied only on a selection |
| Correlation kernel | `K(n,m) = ∫₀^π (δ n(θ) − θ/π)(δ m(θ) − θ/π) dθ` (source claim) |

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every **Computation** row is tested in [`tests/test_programme.py`](tests/test_programme.py). **Source claim** and **Open / conjecture** rows are not theorems of this reconstruction.

T1–T3 are definitional unfoldings of `eml`: they record the definition rather than independent discoveries, and should be read as such in the count.

| # | Kind | Statement | Lean / test / status |
|---|---|---|---|
| T1 | Theorem | `eml z 1 = exp z` — the exponential is one eml gate. | `EML.exp_identity` |
| T2 | Theorem | `eml 0 1 = 1` — the constant `1` is realised by the gate. | `EML.unit_identity` |
| T3 | Theorem | `eml x y = eml x 1 − log y` — the operator separates into exponential and logarithmic parts. | `EML.eml_eq_exp_sub_log` |
| T4 | Theorem | If `0 ≤ x` then `1 ≤ eml x 1`. | `EML.one_le_eml` |
| T5 | Theorem | `x ↦ eml x 1` is strictly increasing. | `EML.strictMono_first` |
| T6 | Theorem | For `0 < z`, `eml 1 (eml (eml 1 z) 1) = log z` — the three-gate logarithm identity. | `EML.log_identity` |
| T7 | Theorem | For `0 < u`, `eml (log u / 2) 1 = sqrt u` — the square-root subtree. | `EML.sqrt_identity` |
| C1 | Computation | The exponential identity is exact symbolically and at `z = 0, π`. | `test_eml_exp_identity_exact` |
| C2 | Computation | The three-gate logarithm identity is exact for a positive symbol and for `z = 1, 2/3, e, e^e`. | `test_eml_log_identity_exact` |
| C3 | Computation | The square-root identity is exact for `u = 1, 4, 9/16, 2`. | `test_eml_sqrt_identity_exact` |
| C4 | Computation | Numeric second arguments `≤ 0` and non-real arguments are rejected; symbolic positive arguments are accepted. | `test_eml_rejects_nonpositive_second_argument` |
| C5 | Computation | At `θ = 5π/12` the source's printed recurrence and Python listing both fail to reconstruct `sin θ`, while the corrected recurrence is accurate to `1e-12`. | `test_source_fusion_rule_counterexample` |
| C6 | Computation | On a grid in `[0, π/2]` and `N = 120`, the corrected reconstruction satisfies the source's `π/(N+2)` error bound. | `test_corrected_reconstruction_error_bound` |
| C7 | Computation | The corrected reconstruction is exact at `θ = 0`, `π/2`, and `π` (within floating-point tolerance). | `test_reconstruction_endpoints` |
| C8 | Computation | Selection counts obey the boundary cases `0 ↦ 0`, `π/2 ↦ 1`, `π ↦ 3`; at an exact harmonic angle no earlier angle is selected. | `test_selection_count_boundary_cases` |
| S1 | Source claim | `eml` together with `1` is functionally complete for all elementary functions via finite binary trees (cited to Odrzywołek, arXiv:2603.21852). | Source claim; not formalised. |
| S2 | Source claim | Geere's greedy harmonic sine reconstruction: `sin θ = lim s_N(θ)` with `|sin θ − s_N(θ)| ≤ π/(N+2)`. | Archived claim; the printed recurrence fails C5, so the source does not establish it. |
| S3 | Source claim | Selection density `D(N, θ) = (θ/π) ln(N+2) + O(1)`. | Not formalised; finite selection counts are not monotone in `θ`. |
| S4 | Source claim | Diagonal kernel `K(n,n) = ((θ n*)³ + (π − θ n*)³)/(3π²)`, with `π/12 ≤ K(n,n) ≤ π/3`. | Not formalised here. |
| S5 | Source claim | The kernel is positive semidefinite, from its integral representation. | Not formalised here. |
| S6 | Source claim | Eigenvalue bounds `0 ≤ λ k^(N) ≤ π(N+1)` and `π/12 ≤ λ max^(N) ≤ π(N+1)/3`. | Not formalised here; the source itself leaves the limiting distribution open. |
| S7 | Source claim | Any finite-`N` harmonic sine approximant is a single finite eml tree. | Not formalised; depends on S1 and on repairing the fusion rule. |
| S8 | Source claim | Finite eml trees feed into the zeta functional equation, placing the kernel inside analytic continuation. | Not formalised; a standard functional equation is not evidence for RH. |
| S9 | Source claim | Conjecture: a normalised energy `E(σ)` is strictly positive off the critical line, yielding RH. | Archived conjecture; the source's own conclusion says RH is not proved. |
| O1 | Open / conjecture | Give an inductive eml tree syntax and prove closure under `exp`, `log`, `sqrt`, and the arithmetic operations. | Open; the source's completeness assertion is a citation, not a proof. |
| O2 | Open / conjecture | Decide the correct greedy harmonic fusion recurrence and prove the `O(1/N)` reconstruction bound for it. | Open; C5 shows the printed rule cannot be the intended one. |
| O3 | Open / conjecture | Formalise the truncated kernel matrix and prove positive semidefiniteness from the integral representation. | Open. |
| O4 | Open / conjecture | Prove the spectral bounds and identify the limiting spectral distribution. | Open; the source lists this as an open question. |
| O5 | Open / conjecture | Make the energy-misalignment functional `E(σ)` precise and settle its positivity. | Open; the Riemann hypothesis remains open and is not claimed here. |

## Source assessment

- **Fragment, not a programme.** The HTML is a 13 KB conversation transcript. The two TeX files `eml.tex` and `eml-harmonic-zeta.tex` are the actual write-ups, and `eml.html` / `eml-harmonic-zeta.html` are their browser renderings.
- **Genuine elementary core.** The two base identities and the square-root identity are correct; `eml.tex` gives the full algebraic verification, and this folder formalises all three in Lean.
- **Functional completeness is borrowed.** The claim is attributed to Odrzywołek (March 2026) and is not proved in the source. This reconstruction does not formalise an eml-tree syntax.
- **The fusion rule is defective as printed.** The prose recurrence, the displayed geometric rule, and the Python listing are not the same map, and none is sine addition. The corrected recurrence is recorded and tested, not silently substituted for the source.
- **The zeta/RH material is archived.** The functional equation is quoted without proof, the bridge step is motivational, and the RH "conjecture" is explicitly conjectural. Nothing in this folder upgrades it.

## Python layer

[`python/programme.py`](python/programme.py) implements:

- `eml(x, y)`, `exp_via_eml(z)`, `log_via_eml(z)`, `sqrt_via_eml(u)` — exact sympy identities;
- `source_fusion_step(s, h, delta)` — the printed recurrence as a symbolic expression;
- `source_harmonic_sine(theta, n_max)` and `source_python_sine(theta, n_max)` — the two source readings, in floating point;
- `harmonic_sine(theta, n_max)` — the corrected sine-addition reconstruction;
- `selection_count(theta, n_max)` — the finite greedy selection count.

Run the suite:

```bash
cd the-final-letter/topics/eml-universal-operator
python3 -m pytest -q tests
```

Recorded result: **8 passed** in under one second. The identity checks are exact sympy simplifications; the greedy loops use floating point and state their tolerances in the tests.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `EML.eml` and proves T1–T7. It imports Mathlib and uses only elementary order, `exp`, `log`, and `sqrt` facts.

```bash
cd the-final-letter/topics/eml-universal-operator
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. There is no `sorry`, `axiom`, or `admit`. What is *not* formalised is listed in [`lean/README.md`](lean/README.md): functional completeness, the harmonic fusion rule, the correlation kernel and its spectral theory, and every zeta/RH claim.

## Open items and gaps

1. **eml-tree syntax and completeness (O1).** The central claim of the source — universality of the gate — needs an inductive syntax, an evaluation semantics, and closure proofs. Only the base identities are formalised here.
2. **The fusion rule (O2, C5).** The source's recurrence must be repaired before its `O(1/N)` theorem can be assessed. The corrected recurrence is tested on `[0, π/2]`; the full interval and the stated bound remain open.
3. **Correlation kernel (O3, S4–S6).** The diagonal formula and the spectral bounds are plausible for a corrected threshold model, but they are not derived or formalised in this folder.
4. **The zeta bridge and RH (S8–S9, O5).** The archived zeta/RH material is motivational. The Riemann hypothesis, GRH, twin primes, Chowla, and related statements are not proved, assumed, or used as axioms anywhere in this reconstruction.
5. **Provenance of the generated text.** The conversation record is not peer-reviewed; claims should be checked against the two TeX write-ups and against Geere's greedy-harmonic programme before reuse.

## Provenance

- [`archive/maths/rh/research/eml/eml-harmonic-zeta.html`](../../archive/maths/rh/research/eml/eml-harmonic-zeta.html) — the inventory source (conversation record).
- [`archive/maths/rh/research/eml/eml.tex`](../../archive/maths/rh/research/eml/eml.tex) — "Proof of the eml Universal Operator"; source of the base-identity proofs.
- [`archive/maths/rh/research/eml/eml-harmonic-zeta.tex`](../../archive/maths/rh/research/eml/eml-harmonic-zeta.tex) — TeX version of the conversation record.
- [Scraps inventory](../../scraps.html) — item 8.
- [Topic index](../README.md) — all reconstructed topics.
- [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
