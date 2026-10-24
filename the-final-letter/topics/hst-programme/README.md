# Harmonic Sine Transform programme — reconstruction

**Inventory:** [Scraps](../../scraps.html) · item 27  
**Status:** duplicate programme hub; finite formal core and exact computation layer reconstructed, the analytic programme left as source claims.  
**Source:** [`archive/maths/hst/index.html`](../../archive/maths/hst/index.html) (23 files, including build outputs).  
**Canonical sibling:** [item 17, Harmonic Sine Transform](../harmonic-sine-transform/README.md), whose source is [`hst-research-guide.md`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md).  
**Topic index:** [topics/](../README.md).

## Provenance and scope

The archived landing page is a **duplicate programme hub**. It presents the
same eight-programme HST corpus catalogued under item 17: greedy expansion of
angles, the Haar tree and HST isometry, the transfer operator, the Fredholm
determinant identity, harmonic sine `L`-functions, and the speculative
Programme IIX route to GRH. Item 27 is the hub page; the papers themselves are
in [`archive/maths/hst/`](../../archive/maths/hst), and item 17 names the
research guide as its source.

This folder therefore does **not** invent a second programme. It reconstructs
the finite mathematical seed that both items share — the greedy harmonic
expansion of a normalised angle — and cites the duplicate for everything else.
The landing page is prose and link metadata, not a proof document; its
mathematical claims are inherited from the linked papers (principally
[`01-hst-proof-step.tex`](../../archive/maths/hst/01-hst-proof-step.tex)).

Two source-status facts matter for honesty:

1. The landing page calls Programmes I–V **fully rigorous**, but its own
   Fredholm-proof card says the proof *"contains gaps that need to be filled
   before it can be used in this programme"*, and Programme IIX is labelled
   **speculative** with an explicitly open monotonicity inequality. The
   "rigorous" labels are recorded below as source claims, not verified here.
2. The research guide for item 17 states the digit recursion as
   `δ_n = ⌊(n+2) r_n⌋` while calling the digits binary. That recursion is not
   binary: for `x = 9/10` it gives `δ_1 = 2`. Programme I and the landing page
   instead use the binary rule below, which is the rule the Haar-tree
   construction needs. The discrepancy is tested, not hidden.

## Reconstructed objects and notation

Work with the normalised angle `x = θ/π ∈ [0,1]` and the harmonic fractions

```
d_n = 1/(n+2),        n = 0,1,2,…
```

The binary greedy recursion is

```
r_0 = x,
δ_n = 1  if d_n ≤ r_n,   δ_n = 0 otherwise,
r_{n+1} = r_n − δ_n d_n.
```

The finite greedy partial sum is `s_N = Σ_{n<N} δ_n d_n`, and the residual is
`r_N = x − s_N`. The programme's series claim is `x = Σ_{n≥0} δ_n/(n+2)`.

| Object | Definition / status |
|---|---|
| Harmonic fraction | `d n = 1/(n+2)`; reconstructed. |
| Greedy digit | `δ n(x) ∈ {0,1}`; reconstructed. |
| Residual | `r n(x)`; reconstructed. |
| Greedy partial sum | `s_N(x)`; reconstructed. |
| Theta threshold | `θ_n*`; not reconstructed (source claim of Programme I). |
| Greedy harmonic tree / Haar basis `B` | Source object; not reconstructed. |
| HST isometry `H : L²[0,π] → ℓ²(B)` | Source object; not reconstructed. |
| Transfer operator `L_s`, determinant `det(I−L_s)` | Source object; not reconstructed. |
| Harmonic sine `L`-functions `L_χ(θ,s)` | Source object; not reconstructed. |

## Theorem ledger

Every **Theorem** row is a declaration in [`lean/Topic.lean`](lean/Topic.lean),
proved with no `sorry`, `axiom`, or `admit`. Every **Computation** row has a
test in [`tests/test_programme.py`](tests/test_programme.py). Nothing labelled
a source claim or open problem is presented as a theorem.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Every harmonic fraction is positive: `0 < d n`. | `HST.d_pos` |
| T2 | Theorem | The harmonic fractions are strictly decreasing. | `HST.d_strictAnti` |
| T3 | Theorem | For `x ≥ 0` the greedy residual never becomes negative. | `HST.rem_nonneg` |
| T4 | Theorem | For `x < 1`, `r_n < 1/(n+1)` — the finite form of the source's error estimate `θ − θ_n ≤ π/(n+1)`. | `HST.rem_lt` |
| T5 | Theorem | Exact finite identity: `r_n + Σ_{k<n} δ_k/(k+2) = x`. | `HST.rem_add_sum` |
| T6 | Theorem | For `0 ≤ x < 1`, the residual tends to `0`. | `HST.rem_tendsto_zero` |
| T7 | Theorem | For `0 ≤ x < 1`, the greedy partial sums converge to `x` (the normalised series theorem of Programme I). | `HST.sum_tendsto` |
| C1 | Computation | `d n = 1/(n+2)` exactly, strictly decreasing; negative or non-integer indices are rejected. | `test_harmonic_fractions_exact` |
| C2 | Computation | On an exact rational grid the digits are binary, `s_N + r_N = x`, and `0 ≤ r_N < 1/(N+1)` for `x < 1`. | `test_digits_binary_and_exact_telescoping` |
| C3 | Computation | Terminating expansions are exact, including `1/2`, `1/3`, `2/3`, `9/10`, the endpoint `1 = 1/2+1/3+1/6`, and `3/7` after 230 digits. | `test_terminating_expansions_exact` |
| C4 | Computation | Greedy partial sums are non-decreasing and never exceed the target. | `test_partial_sums_monotone_and_bounded_by_target` |
| C5 | Computation | Sine reconstruction is exact at terminating angles: `sin(π/2)=1`, `sin(π/3)=√3/2`, `sin(π)=0`. | `test_sine_reconstruction_exact` |
| C6 | Computation | The research guide's floor recursion is not binary: `x=9/10` gives `[1,2,1,3,0,0]`, unlike the binary word `[1,1,0,0,0,0]`. | `test_guide_floor_recursion_is_not_binary` |
| C7 | Computation | Edge cases: `x=0` has the empty word, `x=1` terminates, and out-of-range or non-exact inputs raise. | `test_edge_cases_and_invalid_input` |

## Source claims (not promoted to theorems)

| Claim | Archived status | Reconstruction note |
|---|---|---|
| Every angle `θ ∈ [0,π]` has a binary greedy expansion `θ/π = Σ δ_n/(n+2)`. | Source theorem (Programme I) | T7 proves the normalised statement for `x < 1`; the endpoint `x=1` is verified exactly in C3 but not covered by the Lean limit hypotheses. |
| Digits are non-decreasing in `θ`, with thresholds `θ_n*`. | Source theorem (Programme I) | Not formalised; the monotonicity of the decision in `x` is not in the Lean core. |
| Cylinder intervals are half-open and lengths obey `ℓ(ε1)=α_n`, `ℓ(ε0)=ℓ(ε)−α_n`. | Source proposition (Programme I) | Not formalised. |
| The greedy harmonic tree yields an orthonormal Haar basis `B` of `L²[0,π]`. | Source theorem (Programme II), labelled rigorous | Not formalised. The research guide itself notes an earlier non-orthogonal centred basis was wrong (unbounded synthesis operator). |
| `H : L²[0,π] → ℓ²(B)` is an isometric isomorphism. | Source theorem (Programme III) | Not formalised. |
| The HST Dirichlet series converges absolutely for `Re s > 1`. | Source theorem (Programme III) | Not formalised. |
| `L_s` is trace-class for `Re s > 1` and extends to a compact family for `Re s > 1/2`. | Source theorem (Programme IV), labelled rigorous | Not formalised; no transfer-operator development here. |
| `det(I−L_s) = ζ(s)/ζ(2s)·e^{P(s)}`, with `P` entire and zero-free in the critical strip. | Source theorem (Programme V) | Not formalised, and the landing page's own proof card says the proof is incomplete. The identity is an **archived claim**, not a theorem of this reconstruction. |
| Zeros of `ζ` correspond to eigenvalue-1 of `L_{1/2+it}`. | Source corollary (Programme V) | Not formalised; depends on the unverified determinant identity. |
| Harmonic sine `L`-functions `L_χ(θ,s)` have poles only at non-trivial zeros of `L(s,χ)`. | Source theorem (Programme VII) | Not formalised. |
| The Programme IIX monotonicity inequality implies GRH. | Speculative proposal; critical step called open | Not formalised. GRH is **not** proved here. |
| Programmes I–V are "fully rigorous". | Source claim on the landing page | Not independently verified; contradicts the "incomplete proof" label on the linked proof page. |

## Python layer

The module uses exact sympy rationals throughout and no floating point;
`mpmath` is not needed.

```python
import sympy as sp
from programme import expansion, greedy_digits, residual, sine_reconstruction

greedy_digits(sp.Rational(1, 3), 5)      # [0, 1, 0, 0, 0]
residual(sp.Rational(3, 7), 230)         # 0
expansion(sp.Rational(1))                # digits (1, 1, 0, 0, 1), residual 0
sine_reconstruction(sp.Rational(1, 3), 2)  # sqrt(3)/2
```

Functions: `harmonic_fraction`, `greedy_digits`, `partial_sum`, `residual`,
`expansion`, `sine_reconstruction`, and `guide_floor_digits` (the archived
alternative recursion, kept for the discrepancy test).

Run the suite:

```bash
cd the-final-letter/topics/hst-programme
python3 -m pytest -q tests
```

Current result: **7 passed**.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `HST.d`, `HST.step`, `HST.rem`,
and `HST.digit`, and proves T1–T7. It imports Mathlib and uses elementary
order, field, and filter facts; it contains no `sorry`, `axiom`, or `admit`.
[`lean/README.md`](lean/README.md) records exactly what is not formalised.

```bash
cd the-final-letter/topics/hst-programme
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

## Open items and gaps

1. **Haar tree and HST isometry are absent.** The source's Programme II–III
   claims (orthonormal Haar basis, isometric isomorphism, Dirichlet-series
   convergence) are not formalised. A faithful reconstruction would need a
   measurable-space development of the cylinder intervals and `L²` bases.
2. **The Fredholm determinant identity is unverified.** The landing page calls
   it rigorous, the linked proof page calls itself incomplete, and this
   reconstruction has no formalisation of `L_s`, Mayer–Efrat theory, or
   regularised determinants. It remains an archived claim.
3. **The Programme IIX monotonicity inequality is open.** The inequality
   `Im tr((I−L_{1/2+it,χ})⁻¹ dL/dt) ≥ 0` is the source's own declared open
   problem and is labelled speculative. No RH or GRH conclusion is drawn.
4. **Source digit conventions conflict.** The binary rule of Programme I and
   the floor rule of the research guide disagree (C6). This reconstruction
   uses the binary rule because the Haar tree and the formal core depend on
   it; the source needs an explicit correction.
5. **Endpoint and threshold formalisation.** T6–T7 assume `x < 1`; `x = 1` is
   only computed exactly. The threshold functions `θ_n*` and digit
   monotonicity in `θ` are not formalised.
6. **Status review vs landing page.** The corpus's "fully rigorous" claim and
   the "incomplete proof" label have not been reconciled; the canonical record
   should settle which applies to Programme V.

## Provenance and links

- [Scraps inventory](../../scraps.html) — item 27.
- [Topic index](../README.md) — all topic folders.
- Canonical duplicate: [item 17, Harmonic Sine Transform](../harmonic-sine-transform/README.md).
- Archived landing page: [`archive/maths/hst/index.html`](../../archive/maths/hst/index.html).
- Programme I proof source: [`01-hst-proof-step.tex`](../../archive/maths/hst/01-hst-proof-step.tex).
- Research guide: [`hst-research-guide.md`](../../archive/maths/rh/research/harmonic-sine-transform/hst-research-guide.md).
- [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
