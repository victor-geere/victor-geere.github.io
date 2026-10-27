# Frozen truths — research programme

**Status:** reconstructed elementary formal core + exact computation layer; the ninety archived claims are preserved separately; five appear as the finite theorems T1–T5, and the rest are recorded as source claims or open items.  
**Source:** [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md) (site root copy; bundle copy at [`geometric-dynamical-phase-transitions/truths.md`](../../geometric-dynamical-phase-transitions/truths.md)).  
**Inventory:** [Scraps](../../scraps.html) item 5 · [Topic index](../README.md).

## Provenance

`truths.md` is a 509-line sidecar to the geometric-dynamical programme. It collects ninety numbered statements ("frozen truths") that the author regards as independent of later choices of path-closure, measure, or "balanced/unrestricted" vocabulary. Its opening paragraph says explicitly that it is **not a proof of the Riemann hypothesis** and that anything depending on a later definition is restated as an inequality or omitted.

The file also lists three **withdrawn falsehoods** so that they are not restored: a wrong value for an \(L^1\) integral, a wrong local diagonal \(c_1=\tfrac12\rho^2\), and a false lower bound on \(|\eta|\) at an off-line zero. Those entries are recorded below as withdrawn, not as theorems.

This folder reconstructs the part of the source that is elementary, finite, and checkable without the analytic estimates: the last-chord boundary term of §11, its twin pairing and self-dual abscissa, the integer-ratio identity of 1.14, and the hyperbolic-cosine weight of the cosine kernel in §12. Everything else is a source claim or an open item.

## Reconstructed objects and notation

| Object | Definition / meaning |
|---|---|
| Last chord | \(H_N(s)=\frac{1-N}{2}N^{-2s}\), the order-zero unmatched Euler–Maclaurin boundary term (11.1, 2.8). |
| Pairing value | \(Q_N=\frac{(N-1)^2}{4N^2}\). |
| Twin moduli | \(|H_N(\sigma)|=\frac{N-1}{2}N^{-2\sigma}\) and \(|H_N(1-\sigma)|=\frac{N-1}{2}N^{2\sigma-2}\). |
| Self-dual abscissa | The unique \(\sigma\) with \(|H_N(\sigma)|=|H_N(1-\sigma)|\), namely \(\sigma=\tfrac12\). |
| Integer-ratio weight | \(\exp(-|\log(m/n)|)=\min(m,n)/\max(m,n)\) for \(m,n>0\) (1.14). |
| Three comparison scales | \(P_N=|1-N^{1-s}|\), \(F_N=(1+|t|)N^{1-2\sigma}\), \(D_N=N^{1/2-\varepsilon}\) (4.5; not formalised). |
| Cosine kernel | \(K(\alpha,\gamma)=\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du\), with \(\Phi\) the Jacobi-theta kernel of 12.1 (not formalised). |
| Cosine weight | \(\cosh(\alpha u)\), even in \(u\) and in \(\alpha\), strictly \(>1\) for \(\alpha u\neq0\). |
| Gaussian model | \(\Phi_G(u)=e^{-u^2}\), used only as an exact model of the solved \(\gamma=0\) slice 15.1. |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | \(H_N(s)H_N(1-s)=Q_N\) for every real \(s\) and \(N>0\) (11.1, 14.1). | `FrozenTruths.lastChord_mul_twin` |
| T2 | Theorem | For \(N>1\), \(\lvert H_N(\sigma)\rvert=\frac{N-1}{2}N^{-2\sigma}\) (2.8, 11.2). | `FrozenTruths.lastChord_abs` |
| T3 | Theorem | For \(N>1\), \(\lvert H_N(\sigma)\rvert=\lvert H_N(1-\sigma)\rvert\) iff \(\sigma=\tfrac12\) (11.2, 14.4). | `FrozenTruths.lastChord_twin_abs_eq_iff` |
| T4 | Theorem | \(Q_N\to\tfrac14\) as \(N\to\infty\) (11.1). | `FrozenTruths.lastChord_limit` |
| T5 | Theorem | \(\exp(-\lvert\log(m/n)\rvert)=\min(m,n)/\max(m,n)\) for \(m,n>0\) (1.14). | `FrozenTruths.exp_neg_abs_log_ratio` |
| T6 | Theorem | If \(\alpha\neq0\) and \(u>0\), then \(1<\cosh(\alpha u)\) (12.3, 13.3). | `FrozenTruths.cosh_weight_gt_one` |
| T7 | Theorem | \(\cosh(\alpha u)=\cosh((-\alpha)u)\) (12.3). | `FrozenTruths.cosh_weight_even` |
| C1 | Computation | The exact pairing \(H_N(s)H_N(1-s)\) equals \(Q_N\) for \(N=2,\dots,12\) at a complex \(s\), and both sides vanish at \(N=1\). | `test_last_chord_pairing_exact` |
| C2 | Computation | The boundary-term modulus formula holds for \(N\in\{2,3,10,97\}\) on a rational \(\sigma\)-grid, and the twin moduli agree exactly at \(\sigma=\tfrac12\) and nowhere else. | `test_boundary_modulus_and_self_dual_abscissa` |
| C3 | Computation | \(Q_{10^6}\) is within \(10^{-6}\) of \(\tfrac14\); exact value \(Q_2=\tfrac1{16}\). | `test_last_chord_limit_tolerance` |
| C4 | Computation | The integer-ratio identity holds for six pairs, including \(m=n\). | `test_integer_ratio_identity` |
| C5 | Computation | The cosine weight is even in \(\alpha\), strictly \(>1\) for \(\alpha\neq0\), and exactly \(1\) at \(\alpha=0\). | `test_cosh_weight_strict_and_even` |
| C6 | Computation | For the Gaussian model, \(\int_0^\infty e^{-u^2}\cosh(\alpha u)\,du=\frac{\sqrt\pi}{2}e^{\alpha^2/4}>0\) at four rational \(\alpha\). | `test_gaussian_zero_slice_positive_exact` |
| C7 | Computation | Invalid arguments (zero/negative length, non-integer \(N\), non-real \(\alpha\)) are rejected. | `test_invalid_inputs` |

The Gaussian model in C6 is a model of 15.1, **not** an evaluation of the source's Jacobi-theta \(\Phi\). It illustrates the solved \(\gamma=0\) slice; it does not prove positivity for the source kernel.

## Source claims (not promoted to theorems)

The source has exactly ninety numbered entries. The rows below group them by role and record the archived status.

| # | Claim | Source status | Reconstruction note |
|---|---|---|---|
| S1 | §1 classical black boxes: functional equation for \(\Xi\), Euler–Maclaurin, Hilbert's inequality, Gallagher/Sobolev, Riemann–von Mangoldt, stereographic formulae, Speiser equivalence (1.1–1.15). | Classical facts, cited not proved. | Recorded as source claims; no attempt to re-prove the black boxes. |
| S2 | §2 integer filter: \(c_m^{(N)}\), \(\sum c_m m^{-s}=(1-N^{1-s})\zeta(s)\), the Dirichlet-polynomial identity for \(\eta_N^{(N^2)}\), and the coefficient asymptotics \(\sum|c_m|^2\asymp N^3\), \(\sum|c_m|^2/m\asymp N\log N\) (2.1–2.8). | Source identities and asymptotics. | The identities are elementary but not formalised; the asymptotic constants are not proved here. |
| S3 | §3 uniform Euler–Maclaurin expansions for \(\eta\), the \(\alpha=2\) scale, and the derivative expansion (3.1–3.4). | Source theorems (Theorems 4.1, 4.3; Proposition 4.2; Lemma 4.5), with proof sketches. | Not formalised; these are the main analytic inputs of the programme. |
| S4 | §4 size of \(\eta\) at zeros: upper bounds on the line, strip bounds, the floor \(|\eta|\ge\frac14N^{1-2\sigma}\) on the tightness window, and the three scales (4.1–4.8). | Source corollaries, conditional on §3. | Recorded as source claims; no Lean or pytest theorem. |
| S5 | §5 derivative bounds at simple and multiple zeros (5.1–5.4). | Source lemmas, conditional on §3. | Not formalised. |
| S6 | §6 mean values: the \(L^2\) bound, the exact weighted identity 6.2, and the local-mean discussion (6.1–6.3). | Source claim; 6.2 is an exact weighted identity. | Not formalised. |
| S7 | §7 continuous filter: \(C^1\) interpolation, the packet identity 7.2, and the local diagonal. | Source claim. | The earlier local diagonal \(c_1=\frac12\rho^2\) is explicitly **withdrawn** by the source; see below. |
| S8 | §8 stereographic comparison, §9 prefactor arithmetic, §10 Rouché counting (8.1–10.2). | Source claims, conditional on §3 and on classical function theory. | Not formalised. |
| S9 | §11.3–11.6 two-sided tracking at twins, product at twins, dichotomy, north/south lift. | Source claims, conditional on Euler–Maclaurin. | T1–T4 formalise only the algebraic last-chord layer (11.1–11.2); the tracking and dichotomy are not proved here. |
| S10 | §12.1 Riemann's \(\Phi>0\), the cosine representation, and §12.4–12.6 counterexamples, the Laguerre–Pólya sufficient condition, and the seven RH equivalences. | Source claims / classical theorems. | Not formalised. The equivalences are recorded as equivalences, not as proofs of RH. |
| S11 | §13 the four equivalent writings of the remaining statement (right-half atom, twin divergence, non-real zero of the cosine transform, failure of Weil positivity). | Source claim; explicitly says the Dirichlet polygon does not decide it. | Recorded as a source claim. |
| S12 | §15.1 \(K(\alpha,0)>0\) for the source \(\Phi\), and §15.2 \(K(0,\gamma)\) vanishes at on-line zeros. | Source claims. | Only the Gaussian model is computed (C6); the source \(\Phi\) is not constructed here. |
| S13 | §15.5–15.9 moments \(m_{2k}<\infty\), the Jensen tower, Li positivity, and the Griffin–Ono–Rolen–Zagier limit. | Source claims; 15.8 is a cited theorem, 15.6 is an RH-equivalent statement. | Recorded as source claims/open items; not formalised. |

### Withdrawn falsehoods

These are the source's own corrections and are **not** ledger claims:

- \(\int(1-R\varphi)(-\varphi)\,du=-\tfrac12\) is false; the integral is \(-1+R\int\varphi^2\).
- The local diagonal of Section 6 is not \(c_1=\tfrac12\) times \(\rho^2\).
- At an off-line zero, \(|\eta_N^{(N^2)}(\rho)|\ge cN^{1/2-\varepsilon}\) on the tightness range is false; Corollary 4.3.1 gives the opposite upper bound for \(\sigma>\tfrac14+\varepsilon/2\).

## Open items and gaps

| # | Kind | Statement | Status |
|---|---|---|---|
| O1 | Open / conjecture | The Riemann hypothesis: every non-trivial zero of \(\zeta\) has real part \(\tfrac12\). | Open. The source explicitly disclaims a proof; the programme locates the statement but does not decide it. |
| O2 | Open / conjecture | \(K(\alpha,\gamma)\neq0\) for every \(\alpha\neq0\) and every real \(\gamma\). | Open; equivalent to RH through 12.3/12.6, and explicitly not proved in 13.5/15.10. |
| O3 | Open / conjecture | Hyperbolicity of the full Jensen tower of \((m_{2k})\), equivalently positivity of the Li jet. | Open; 15.6 identifies it with RH. |
| O4 | Open (formalisation) | Uniform Euler–Maclaurin with explicit constants, the two-sided tracking 11.3, and the Rouché count 10.1. | Source claims only; formalising them would require a substantial analytic development not attempted here. |

## Python layer

[`python/programme.py`](python/programme.py) is the exact computation layer. It uses sympy only (no numerical integration is needed for the tests). It provides:

- `last_chord(N, s)`, `last_chord_square(N)`, `last_chord_product(N, s)`;
- `last_chord_abs(N, sigma)`, `twin_moduli_equal(N, sigma)`, `last_chord_limit(N)`;
- `exp_neg_log_ratio(m, n)` and `ratio_min_max(m, n)`;
- `cosh_weight(alpha, u)`;
- `gaussian_zero_slice(alpha)` and `gaussian_zero_slice_integral(alpha)` for the model computation.

Run the tests from the repository root:

```bash
python3 -m pytest the-final-letter/topics/frozen-truths/tests -q
```

Recorded result: **7 passed in 0.95s**.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `FrozenTruths` namespace, and proves T1–T7. It defines `lastChord N s = ((1-N)/2) * N^(-2s)` and `lastChordSquare N = (N-1)^2/(4N^2)`. The proofs use only elementary order, field, `Real.rpow`, limit, `Real.log`/`Real.exp`, and `Real.cosh` facts; there is no analytic estimate and no `sorry`/`axiom`/`admit`.

```bash
the-final-letter/topics/frozen-truths/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean (5s)`.

See [`lean/README.md`](lean/README.md) for the exact theorem list and the formalisation limits.

## What is not formalised

The formal core deliberately stops at the algebraic last-chord layer. In particular it does not contain:

- the uniform Euler–Maclaurin expansion of 3.2 or the floor of 4.4;
- the two-sided tracking 11.3 or the product-at-twins 11.4;
- the construction of Riemann's \(\Phi\), the cosine representation 12.1, or any statement about the zeros of its transform;
- the mean-value, Rouché, or Jensen/Li arguments;
- the Riemann hypothesis, twin primes, Chowla, Sarnak, or Elliott.

These are source claims or open items above, not theorems of this reconstruction.

## Provenance links

- [Scraps inventory](../../scraps.html) — item 5.
- [Topic index](../README.md) — all reconstructed topics.
- [Source `truths.md`](../../geometric-dynamical-phase-transitions/truths.md) · [bundle copy](../../geometric-dynamical-phase-transitions/truths.md).
- [Geometric-dynamical programme](../../geometric-dynamical-phase-transitions/publication.html) · [projection note](../../geometric-dynamical-phase-transitions/projection.html) · [tensor note](../../geometric-dynamical-phase-transitions/tensor.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
