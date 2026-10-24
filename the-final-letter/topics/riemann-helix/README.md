# Riemann helix — research programme

**Status:** reconstructed elementary formal core, exact computation layer, and an honest audit of the archived RH-equivalence. The distributional limit and the Riemann Hypothesis itself remain open and are **not** proved here.
**Source:** [`archive/maths/r-helix/conjecture.html`](../../archive/maths/r-helix/conjecture.html) and its TeX source [`conjecture.tex`](../../archive/maths/r-helix/conjecture.tex).
**Inventory:** [Scraps](../../scraps.html) item 30 · [Topic index](../README.md).

## What the programme is

The archived note proposes a geometric reformulation of the Riemann Hypothesis (RH). Write the non-trivial zeros with positive imaginary part as

\[
\rho_n=\beta_n+i\gamma_n,\qquad 0<\gamma_1<\gamma_2<\cdots,
\]

with no assumption on the real parts \(\beta_n\in(0,1)\). Choose a smooth increasing phase \(\phi\) interpolating the ordinates, \(\phi(\gamma_n)=2\pi n\), and consider the unit-radius helix

\[
C_1(t)=(\cos\phi(t),\sin\phi(t),t).
\]

The note claims that the torsion \(\tau_1\) of \(C_1\) converges, as distributions, to a prime-supported measure

\[
\tau_0(t)=\sum_{p,m}\frac{\log p}{p^{m/2}}\,\delta(t-m\log p)+\tau_{\mathrm{arch}}(t),
\tag{1}
\]

independently of the \(\beta_n\). It then lets \(r\) interpolate the real parts, \(r(\gamma_n)=\beta_n\), and considers the varying-radius helix

\[
C_r(t)=(r(t)\cos\phi(t),r(t)\sin\phi(t),t),
\]

whose torsion \(\tau_r\) acquires extra terms involving \(r',r''\). The source's Theorem 4.1 asserts that RH (all \(\beta_n=\tfrac12\)) is equivalent to the existence of such an interpolation with \(\tau_r=\tau_0\).

This folder reconstructs the elementary helix/torsion geometry that the argument actually uses, together with the algebraic criterion relating curvature and torsion. It does **not** formalise the distributional limit or the RH equivalence. Section “Source claims” below keeps those assertions at their archived status, and “Audit” records two defects in the source's proof sketch.

## Objects and notation

| Object | Definition |
|---|---|
| Circular helix | \(C_{R,c}(t)=(R\cos t,R\sin t,ct)\), radius \(R>0\), pitch \(c>0\) |
| Curvature | \(\kappa(R,c)=R/(R^2+c^2)\) |
| Torsion | \(\tau(R,c)=c/(R^2+c^2)\) |
| Unit-radius helix | \(C_1\) with phase \(\phi\), i.e. \(R=1\), angular derivative \(\phi'\) |
| Prime support | \(\{\,m\log p : p\text{ prime},\ m\ge1\,\}\), the logarithms of prime powers |
| Conditional helix | \(C_r(t)=(r(t)\cos\phi(t),r(t)\sin\phi(t),t)\) |
| Interpolation | \(r(\gamma_n)=\beta_n\) for every \(n\) |

The classical helix formulae are the ones used by the source: for \(C_{R,c}\), both \(\kappa\) and \(\tau\) are constant, and the torsion is \(\tau=c/(R^2+c^2)\). A direct Frenet computation (verified symbolically in the Python layer) gives these closed forms.

## Audit of the archived argument

The source is a short fragment (four sections, no detailed derivation of the distributional limit). Three observations matter for reconstruction.

1. **The displayed torsion formula is not the Frenet torsion.** For \(C_1(t)=(\cos\phi(t),\sin\phi(t),t)\), the source displays

   \[
   \tau_1=\frac{\phi'[\phi'^4-\phi'\phi'''+3\phi''^2]}
   {(\phi'^2+1)(\phi'^4+\phi''^2+\phi'^6)}.
   \]

   Direct computation gives the denominator \(\phi'^6+\phi'^4+\phi''^2\). At constant \(\phi'=k\), the source's expression is \(k/(1+k^2)^2\), while the correct torsion is \(k/(1+k^2)\). This is checked exactly by `test_source_torsion_formula_disagrees` (C3).

2. **Torsion is not scale invariant.** The source's \((i)\Rightarrow(ii)\) proof says that \(C_{1/2}\) is “a scaling of the unit-radius helix” and that “scaling does not change the torsion”. Torsion has dimension \(1/\text{length}\): uniformly scaling the constant-rate helix by \(\lambda\) gives \(\tau\mapsto\tau/\lambda\). Moreover \(C_{1/2}\) as displayed is not a uniform scaling of \(C_1\), because the vertical coordinate is left equal to \(t\). In the representative constant-rate case \(\phi(t)=t\), the radius-\(1/2\), pitch-\(1\) helix has \(\tau=4/5\), not \(1/2\). The Lean theorems `torsion_scale`, `torsion_not_scale_invariant`, and `torsion_half_ne_unit` formalise the scaling law and this counterexample.

3. **The density wording is slightly too strong.** The source says \(\{m\log p\}\) is dense in \([0,\infty)\). Its least element is \(\log 2\), so it is not dense in \([0,\infty)\). It is dense in \([\log 2,\infty)\) assuming the prime number theorem (consecutive prime logarithms differ by \(\to0\)). The argument only needs density on the range of the ordinates \(\gamma_n\), so this is a presentational rather than structural defect; it is recorded as source claim S6 and not used as a theorem.

These defects do not show that no geometric criterion of this kind can work. They do show that the archived proof sketch does not establish the stated equivalence, and that a repaired criterion must handle the physical dimension of torsion (for example by comparing a dimensionless combination such as \(\tau/\kappa\)).

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The helix satisfies \(x^2+y^2=R^2\): it lies on a cylinder of radius \(R\). | `RiemannHelix.helix_on_cylinder` |
| T2 | Theorem | For \(R,c>0\), the torsion \(c/(R^2+c^2)\) is positive. | `RiemannHelix.torsion_pos` |
| T3 | Theorem | For fixed \(c>0\), torsion is strictly decreasing in \(R\). | `RiemannHelix.torsion_strictAnti_radius` |
| T4 | Theorem | Uniform scaling by \(\lambda>0\) gives \(\tau(\lambda R,\lambda c)=\tau(R,c)/\lambda\). | `RiemannHelix.torsion_scale` |
| T5 | Theorem | If \(\lambda\ne1\), scaling changes torsion: \(\tau(\lambda R,\lambda c)\ne\tau(R,c)\). | `RiemannHelix.torsion_not_scale_invariant` |
| T6 | Theorem | In the constant-rate case, halving the radius and fixing the pitch changes torsion: \(\tau(\tfrac12,1)\ne\tau(1,1)\) (exact values \(4/5\) and \(1/2\)). This is the simplest counterexample to the source's “scaling does not change torsion” step. | `RiemannHelix.torsion_half_ne_unit` |
| T7 | Theorem | Algebraic criterion: \(\kappa^2+\tau^2=1/(R^2+c^2)\), \(R=\kappa/(\kappa^2+\tau^2)\), \(c=\tau/(\kappa^2+\tau^2)\). | `RiemannHelix.curvature_torsion_inversion` |
| C1 | Computation | The direct Frenet torsion of \(C_{R,c}\) equals \(c/(R^2+c^2)\) symbolically. | `test_frenet_torsion_matches_closed_form` |
| C2 | Computation | The direct Frenet curvature of \(C_{R,c}\) equals \(R/(R^2+c^2)\) symbolically. | `test_frenet_curvature_matches_closed_form` |
| C3 | Computation | The source's displayed torsion formula disagrees with the Frenet torsion; the exact difference at \(\phi'=k\) is \(-k^3/(1+k^2)^2\). | `test_source_torsion_formula_disagrees` |
| C4 | Computation | The scaling law \(\tau(\lambda R,\lambda c)-\tau(R,c)/\lambda=0\) holds symbolically. | `test_torsion_scale_law` |
| C5 | Computation | \(\tau(1,1)=1/2\), \(\tau(\tfrac12,1)=4/5\), \(\tau(2,2)=1/4\); the source's “scaling does not change torsion” inference fails. | `test_scaling_changes_torsion` |
| C6 | Computation | The algebraic inversion of C7/T7 holds exactly. | `test_curvature_torsion_inversion` |
| C7 | Computation | Exact AM–GM slack: \(1/(2R)-c/(R^2+c^2)=(R-c)^2/(2R(R^2+c^2))\ge0\), so \(\tau\le1/(2R)\). | `test_amgm_bound` |
| C8 | Computation | Edge case: at \(R=0\) the curve is a straight line, the Frenet torsion is undefined (`nan`), and the AM–GM check rejects the degenerate input. | `test_zero_radius_edge_case` |

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| S1 | The displayed torsion formula for \(C_1\). | Archived formula. Contradicted by direct computation (C3); recorded, not adopted. |
| S2 | Distributional limit (1): \(\tau_1\to\tau_0\) with prime-supported weights \(\log p/p^{m/2}\). | Archived claim, derivation not given in the note. Not formalised. |
| S3 | Theorem 4.1: RH is equivalent to the existence of \(r\) with \(r(\gamma_n)=\beta_n\) and \(\tau_r=\tau_0\). | Archived “Theorem”, but its proof is a sketch with the invalid scaling step above. RH itself is not proved; this is a source claim. |
| S4 | Converse: \(\tau_r=\tau_0\) forces \(r'\equiv r''\equiv0\), hence \(r\) constant, hence \(\beta_n=\tfrac12\). | Source proof sketch. The required singularity analysis of \(\tau_r\) is asserted, not derived. Not formalised. |
| S5 | Smooth interpolating \(\phi\) and \(r\) exist (Hermite interpolation plus mollification). | Source assertion; classical in outline, not formalised here. |
| S6 | \(\{m\log p\}\) is dense in \([0,\infty)\). | True on \([\log2,\infty)\) given PNT; literally false on \([0,\infty)\). Not formalised. |
| S7 | \(\tau_1=\tau_0\) independently of the real parts \(\beta_n\). | Source claim; depends on S1/S2 and a precise choice of \(\phi\). Not formalised. |

## Open items and known gaps

| # | Kind | Statement |
|---|---|---|
| O1 | Open / conjecture | The Riemann Hypothesis: all non-trivial zeros satisfy \(\beta_n=\tfrac12\). |
| O2 | Open | Derive the exact varying-radius torsion \(\tau_r\) and prove that \(\tau_r=\tau_0\) forces \(r\) to be constant (the source's key step S4). |
| O3 | Open | Repair the equivalence using a scale-covariant normalisation: torsion has dimension \(1/\text{length}\), so compare a dimensionless invariant such as \(\tau/\kappa\), or fix the parametrisation and scale explicitly. |
| O4 | Open | Formalise the distributional explicit-formula limit S2, including the archimedean term \(\tau_{\mathrm{arch}}\). |
| O5 | Open | Decide whether any criterion of this geometric shape is genuinely equivalent to RH, rather than a restatement with an unproved analytic input. |

## Python layer

[`python/programme.py`](python/programme.py) is an exact sympy layer:

- `helix(radius, pitch, parameter)`, `frenet_curvature`, `frenet_torsion`;
- `helix_curvature`, `helix_torsion` (closed forms);
- `source_torsion_formula` (the archived display, for comparison);
- `torsion_scale_law`, `curvature_torsion_inversion`;
- `amgm_slack`, `amgm_bound_holds` (with input validation).

Run the tests:

```bash
python3 -m pytest the-final-letter/topics/riemann-helix/tests -q
```

Current result: **8 passed** (about 7 s).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `RiemannHelix.helix`, `curvature`, and `torsion`, and proves T1–T7. It imports Mathlib and uses only elementary order, field, and trigonometric facts.

```bash
the-final-letter/topics/riemann-helix/lean/check.sh
```

The committed [build log](lean/BUILD.log) records the last successful check. What is *not* formalised — the varying-radius torsion, the distributional limit, and the RH equivalence — is documented in [`lean/README.md`](lean/README.md).

## Provenance

- [`scraps.html`](../../scraps.html) — inventory item 30, tagged `fragment` and `open statement`.
- [`topics/README.md`](../README.md) — all topic folders.
- Archived source: [`conjecture.html`](../../archive/maths/r-helix/conjecture.html) and [`conjecture.tex`](../../archive/maths/r-helix/conjecture.tex).
- Overlaps inventory items 10 (`geometrc-reformulation`) and 22 (`self-adjoint-operator`); this topic isolates the two-file `r-helix` note.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
