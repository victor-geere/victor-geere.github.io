# Iota helix function — research programme

**Status:** reconstructed finite formal core and exact computation layer. The source is a speculative fragment; the geometric Riemann-hypothesis route remains **open**.  
**Source:** [`archive/maths/rh/research/iota-helix-function/iota-framework.html`](../../archive/maths/rh/research/iota-helix-function/iota-framework.html), with the companion note [`iota-function.tex`](../../archive/maths/rh/research/iota-helix-function/iota-function.tex) used for the helix notation.  
**Inventory:** [Scraps](../../scraps.html) item 18 · [Topic index](../README.md).

## What the source is, and what it is not

The archived folder is a fragment of AI-generated drafts, not a completed programme. `iota-framework.html` is a narrative exposition of the “iota function”: it reads the Dirichlet eta series

\[
\eta(s)=\sum_{n=1}^{\infty}(-1)^{n-1}n^{-s},\qquad s=\sigma+it,
\]

as a planar walk whose steps are the individual terms. The companion `iota-function.tex` adds a three-dimensional helix parametrisation. Neither file proves anything about the zeros of \(\eta\) or \(\zeta\). The claim that the “greedy condition” is equivalent to RH is an **archived source claim**, not a theorem of this reconstruction.

The source also contains two sign/convention inconsistencies, documented under [Source claims](#source-claims-not-promoted-to-theorems):

1. `iota-framework.html` defines \(v_n=(-1)^{n-1}n^{-s}\) but writes its components with \(+\sin(t\log n)\), i.e. \(n^{\bar s}\) instead of \(n^{-s}\). The companion note uses the unwrapped phase \(\Phi_n=\pi(n-1)-t\log n\), which is consistent with \(n^{-s}\).
2. The companion note's greedy pairing uses \(w_N=N^{-s}\) without the alternating sign, whereas the actual step is \(v_N=(-1)^{N-1}N^{-s}\). As written, the pairing is not the dot product with the step; computation C8 exhibits the discrepancy.

This folder therefore reconstructs only the finite objects the source actually defines, proves their elementary identities in Lean, checks the finite computations exactly in Python, and records the RH route as a source claim/open item.

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| Eta term / step | \(v_n(s)=(-1)^{n-1}n^{-s}\), \(s=\sigma+it\) |
| Step radius | \(r_n=n^{-\sigma}\) |
| Unwrapped helix phase | \(\Phi_n=\pi(n-1)-t\log n\) |
| Planar helix step | \((x_n,y_n)=(r_n\cos\Phi_n,\;r_n\sin\Phi_n)\) |
| Helix point | \(P_n=(r_n\cos\Phi_n,\;r_n\sin\Phi_n,\;n)\in\mathbb{R}^3\) |
| Partial position | \(S_N=\sum_{n=1}^{N}v_n\) |
| Greedy pairing | \(D_N=\operatorname{Re}(\overline{S_{N-1}}\,v_N)\) |
| Finite real-axis eta sum | \(E_N(\sigma)=\sum_{n=1}^{N}(-1)^{n-1}n^{-\sigma}\) |

In Lean the radius, phase, coordinates, point and finite eta sum are `Iota.radius`, `Iota.phase`, `Iota.xcoord`, `Iota.ycoord`, `Iota.point`, `Iota.etaPartial`.

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every **Computation** row has a test in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not promoted.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | For \(n\ge1\), the step radius is positive: \(0<r_n\). | `Iota.radius_pos` |
| T2 | Theorem | For \(\sigma>0\) and \(0<m<n\), the radius is strictly decreasing: \(r_n<r_m\). | `Iota.radius_lt_radius` |
| T3 | Theorem | The step has length \(r_n\): \(x_n^2+y_n^2=r_n^2\). | `Iota.step_length` |
| T4 | Theorem | The phase increments by \(\Phi_{n+1}-\Phi_n=\pi-t\log\frac{n+1}{n}\) for \(n\ge1\). | `Iota.phase_succ_sub` |
| T5 | Theorem | The first helix point is \(P_1=(1,0,1)\). | `Iota.point_one` |
| T6 | Theorem | On the real axis (\(t=0\)), \(x_n=(-1)^{n-1}r_n\) and \(y_n=0\); the helix reduces to the eta terms. | `Iota.real_axis_term` |
| T7 | Theorem | For \(\sigma>0\) and \(N\ge1\), the finite alternating eta sum is positive: \(E_N(\sigma)>0\). | `Iota.etaPartial_pos` |
| C1 | Computation | The helix coordinates equal the eta-term components exactly for \(n=1,\dots,7\) and several \(\sigma,t\). | `test_helix_components_match_eta_terms` |
| C2 | Computation | The first step is \(v_1=1\). | `test_first_step_is_one` |
| C3 | Computation | Radius/edge cases: \(r_1=1\), \(r_n=1\) at \(\sigma=0\), and \(n=0\) is rejected. | `test_radius_and_index_edge_cases` |
| C4 | Computation | Step length identity \(|v_n|^2=r_n^2\). | `test_step_length_identity` |
| C5 | Computation | Phase increment identity. | `test_phase_increment_identity` |
| C6 | Computation | Even eta partial sums equal the paired positive sums. | `test_finite_eta_pairing` |
| C7 | Computation | At \(t=0\), the greedy pairing is zero at \(N=1\), negative at even \(N\), and positive at odd \(N\ge3\). | `test_real_axis_greedy_pattern` |
| C8 | Computation | The source's \(w_N=N^{-s}\) pairing omits the sign \((-1)^{N-1}\); it differs from \(D_N\) accordingly. | `test_source_pairing_omits_alternating_sign` |

**All seven Theorem rows are Lean-proved; all eight Computation rows are pytest-tested.**

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| The greedy condition (GC) is equivalent to RH. | Archived claim, cited to unnamed “referenced works” | Not proved here. The source does not supply a proof; the cited derivation from Riemann–Siegel is not given. |
| Every non-trivial zero on \(\sigma=1/2\) satisfies GC. | Archived claim | Not formalised. No zero data or argument is included in the source. |
| If a zero satisfies GC, then \(\sigma=1/2\). | Archived claim | Not formalised; this is the reverse direction of the claimed equivalence. |
| The discrete iota map \(s\mapsto\iota(s)\) is injective, with recovery formulas for \(\sigma\) and \(t\). | Source theorem with proof sketch | Not formalised. The discrete points determine phases only modulo \(2\pi\); the claim that the unwrapped phase is “directly accessible” needs a separate argument. |
| The continuous iota map is injective and the continuous GC inequality is equivalent to the discrete one. | Source proposition | Not formalised. The integral \(\Sigma(\tau)\) and its GC inequality are not defined rigorously in the source. |
| The arc length of \(\iota_c\) from \(\tau=1\) to \(\infty\) is finite iff \(\sigma>1\). | Source claim | Plausible from the asymptotic speed \(\sim1\) plus horizontal length \(\sim\pi\tau^{-\sigma}\), but not proved here. |
| For \(\sigma>1/2\) the steps “shrink too fast for the walk to return to zero”; at \(\sigma=1/2\) the balance is critical. | Source claim, partly garbled in the HTML | The HTML sentence is cut off. No theorem is asserted here. |
| The iota lens unifies Nyman–Beurling, Báez-Duarte, Bombieri and GC. | Speculative source claim | Recorded as motivation only. No formal link is established. |

## Open items

1. **GC \(\Rightarrow\) critical line.** The central unresolved claim. A precise statement of GC (with the correct sign, see C8) and a proof that it forces \(\sigma=1/2\) remain open.
2. **Convergence and zeros.** The source treats \(\eta(s)\) as a limit of the walk; convergence for complex \(s\), analytic continuation, and the relation to \(\zeta\) are not formalised.
3. **Continuous GC.** Define \(\Sigma(\tau)=\int_1^\tau e^{i\pi(u-1)}u^{-s}\,du\) and formalise the continuous inequality, then relate it to the discrete pairing.
4. **Injectivity.** Settle the phase-unwrapping issue in the recovery formula before claiming injectivity of the discrete map.
5. **Arc length.** Prove the claimed finite/infinite trichotomy at \(\sigma=1\).
6. **Sign conventions.** Decide whether the principal object is \(n^{-s}\) (used here) or its conjugate (as in the framework's component formulas), and restate the source claims in one convention.
7. **GC is not vacuous.** C7 shows that on the real axis the greedy pairing already alternates sign; any RH-facing statement must explain why zeros on the critical line behave differently.

## Python layer

[`python/programme.py`](python/programme.py) uses sympy only. It provides:

- `radius(sigma, n)`, `phase(t, n)`;
- `helix_x`, `helix_y`, `eta_x`, `eta_y`, `eta_term`;
- `eta_partial(sigma, N)`, `paired_partial(sigma, M)`;
- `greedy_dot(sigma, t, N)` (correct pairing with the step);
- `source_greedy_dot(sigma, t, N)` (the note's \(w_N\) expression, kept for comparison).

Run the tests:

```bash
python3 -m pytest the-final-letter/topics/iota-helix-function/tests -q
```

Recorded result: **8 passed** in about 8 seconds.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, uses `namespace Iota`, and proves T1–T7. The proof of T7 includes a private finite alternating-sum lemma (`altSum_even`, `altSum_pos`) that pairs consecutive terms. There is no `sorry`, `axiom`, or `admit`.

```bash
the-final-letter/topics/iota-helix-function/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK   Topic.lean`.

What is **not** formalised: the infinite eta series, the complex exponential identity \(r_ne^{i\Phi_n}=(-1)^{n-1}n^{-s}\) as a complex function, injectivity, the continuous iota curve, the greedy condition for zeros, and every RH-facing equivalence. See [`lean/README.md`](lean/README.md).

## Provenance

- [`iota-framework.html`](../../archive/maths/rh/research/iota-helix-function/iota-framework.html) — source start page, inventory item 18.
- [`iota-function.tex`](../../archive/maths/rh/research/iota-helix-function/iota-function.tex) — companion note supplying the helix phase and radius notation.
- [`deepseek_latex_geometric_reformulation.html`](../../archive/maths/rh/research/iota-helix-function/deepseek_latex_geometric_reformulation.html), [`deepseek_latex_20260405_5fff6d.html`](../../archive/maths/rh/research/iota-helix-function/deepseek_latex_20260405_5fff6d.html), [`deepseek_latex_20260405_d8a76a.html`](../../archive/maths/rh/research/iota-helix-function/deepseek_latex_20260405_d8a76a.html) — overlapping geometric-reformulation drafts; no additional proved material was extracted from them.
- [`scraps.html`](../../scraps.html) — inventory entry 18.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
