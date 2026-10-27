# Geometric reformulation — research programme

**Status:** reconstructed elementary formal core + exact computation layer. The central torsion identity, the geometric equivalence to RH, and the CCM relation remain **source claims / open**; none is presented as a theorem of this reconstruction.

**Source:** [`archive/maths/rh/research/geometrc-reformulation/geometric-reformulation.html`](../../archive/maths/rh/research/geometrc-reformulation/geometric-reformulation.html) — a single archived HTML paper, *A Geometric Framework for the Riemann Hypothesis: Twin Helices, the Riemann Helix, and the CCM Spectral Triple*.
**Inventory:** [Scraps](../../scraps.html) item 10 · [Topic index](../README.md) · [The Final Letter](../../index.html).
**Browser version:** [`index.html`](index.html) (self-contained, mirrors this dossier).

## What the programme is

The archived paper proposes a geometric restatement of the Riemann Hypothesis in four layers.

1. **Twin conical helices.** For `s = σ + it` with `σ > 1`, the Dirichlet terms `n^{-s}` and `n^{-s̄}` are embedded at height `n`:

   \[
   C_\pm(x)=\bigl(x^{-\sigma}\cos(t\log x),\,\pm x^{-\sigma}\sin(t\log x),\,x\bigr),\qquad x\ge 1 .
   \]

   Both curves lie on the cone `r = z^{-σ}` and wind in opposite directions. They intersect when `sin(t log x) = 0`, i.e. at `x_k = exp(kπ/t)`, giving the planar polygon points

   \[
   P_k=\bigl((-1)^k x_k^{-\sigma},\,0,\,x_k\bigr).
   \]

2. **Geometric prime distribution.** The paper applies Möbius inversion to the superposition of the twin helices and asserts a distributional measure supported on prime-power logarithms,

   \[
   \tau_{\mathrm{prime}}(t)=\sum_{p,m}\frac{\log p}{p^{m/2}}\,\delta(t-m\log p).
   \]

3. **Riemann helix.** Given the non-trivial zeros `ρ_n = β_n + iγ_n` with `0 < γ_1 < γ_2 < …`, choose an increasing phase `φ` with `φ(γ_n) = 2πn` and define

   \[
   C_1(t)=(\cos φ(t),\,\sin φ(t),\,t),\qquad
   C_r(t)=(r(t)\cos φ(t),\,r(t)\sin φ(t),\,t),
   \]

   where `r(γ_n) = β_n`. The paper derives a torsion formula for `C_1`, states the **Geometric Explicit Formula** (Conjecture 3.1)

   \[
   \operatorname{tors}_1=\tau_{\mathrm{prime}}+\tau_{\mathrm{arch}},
   \]

   and claims the conditional **Theorem 4.1**: assuming Conjecture 3.1, RH is equivalent to the existence of a smooth `r` with `r(γ_n)=β_n` and `tors_r = tors_1`.

4. **CCM dictionary.** The paper identifies the geometric picture with the Connes–Consani–Moscovici spectral triple: a Dirac operator with point interactions at the prime logarithms, a finite Fourier truncation `Q_{kℓ}`, and the Eigencoefficient Prime Sum Conjecture as the quantum counterpart of Conjecture 3.1.

This folder reconstructs the *finite, checkable* geometry — the torsion of the constant-pitch helices, the conical-helix radius and intersection polygon, the prime-power weights, and a finite Fourier matrix modelled on the source's `Q_{kℓ}` — and records the rest honestly as source claims or open items. In particular **RH and CCM Conjecture 1 are not proved here**.

## Reconstructed objects and notation

| Object | Definition | Status |
|---|---|---|
| Intersection abscissa | `x_k = exp(kπ/t)`, `k ≥ 0` | Source definition; computed |
| Cone radius | `r_k = x_k^{-σ} = exp(−σ k π / t)` | Source definition; proved monotone/positive |
| Intersection point | `P_k = ((−1)^k r_k, 0, x_k)` | Source definition; computed |
| Unit-helix torsion | `τ(ω) = ω / (1 + ω²)` | Derived from Frenet–Serret; proved |
| Constant-radius torsion | `τ_c(ω) = ω / (1 + c²ω²)` | Derived from Frenet–Serret; proved |
| Source equation (3.2) | `ω/(1+ω²)²` at linear phase | Archived formula; **does not equal** the Frenet torsion |
| Prime-power weight | `w(p,m) = log p / p^{m/2}` | Source definition; proved positive |
| Finite CCM Fourier matrix | `Q_{kℓ} = −μ_ℓ δ_{kℓ} + (1/L) Σ_j w_j e^{i(μ_ℓ−μ_k)x_j}` | Model of source's stated matrix elements; computed Hermitian |

The torsion definitions are the constant-pitch special case `φ(t) = ωt`. The general non-linear-phase torsion is recorded below as a source formula and is **not** formalised.

## Theorem ledger

Every row marked **Theorem** is a Lean declaration in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a pytest test in [`tests/test_programme.py`](tests/test_programme.py). Theorems are statements about the reconstructed definitions, not about RH.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | For `ω > 0`, the unit-helix torsion is positive: `0 < τ(ω)`. | `GeometricReformulation.helixTorsion_pos` |
| T2 | Theorem | For `ω ≠ 1`, `τ(ω) < 1/2`; the pitch-`1` helix is the extremal case. | `GeometricReformulation.helixTorsion_lt_half` |
| T3 | Theorem | Reciprocal-pitch symmetry: `τ(ω) = τ(1/ω)` for `ω ≠ 0`. | `GeometricReformulation.helixTorsion_symm` |
| T4 | Theorem | The radius-`1/2`, pitch-`1` helix has torsion `4/5`. | `GeometricReformulation.scaledTorsion_half_one` |
| T5 | Theorem | Constant radius rescaling is **not** torsion-preserving: `τ_{1/2}(1) ≠ τ(1)`. | `GeometricReformulation.scaling_not_torsion_invariant` |
| T6 | Theorem | For `σ, t > 0`, the cone radius is positive for every `k` and strictly decreasing in `k`. | `GeometricReformulation.coneRadius_pos_and_strictAnti` |
| T7 | Theorem | Every prime-power weight `log p / p^{m/2}` is positive for `p > 1`. | `GeometricReformulation.primeWeight_pos` |
| C1 | Computation | The Frenet torsion of `(cos ωt, sin ωt, t)` equals `ω/(1+ω²)` for rational test pitches. | `test_helix_torsion_from_frenet_formula` |
| C2 | Computation | The Frenet torsion of `(c cos ωt, c sin ωt, t)` equals `ω/(1+c²ω²)`; `c=1/2, ω=1` gives `4/5`, not `1/2`. | `test_scaled_helix_and_constant_radius_counterexample` |
| C3 | Computation | Source equation (3.2) at linear phase equals `ω/(1+ω²)²`, i.e. the true torsion divided by `1+ω²`. | `test_source_torsion_formula_is_not_frenet_torsion` |
| C4 | Computation | Cone radii obey `r_{k+1}/r_k = exp(−σπ/t)`, decay strictly, and `r_0 = 1`. | `test_cone_radius_ratio_decay_and_edge` |
| C5 | Computation | The points `P_k` lie in the `xz`-plane on the stated cone, with `P_0 = (1,0,1)` and increasing abscissae. | `test_intersection_polygon_points` |
| C6 | Computation | The coefficient of `p^{-ks}` in `Σ_n μ(n)/n log ζ(ns)` is `1` for `k=1` and `0` otherwise; the source's right-hand side has coefficient `−1/k`. | `test_mobius_identity_source_mismatch` |
| C7 | Computation | The prime-power weights are positive, with exact values at `m=0` and `m=1`. | `test_prime_power_weights_positive` |
| C8 | Computation | The finite CCM Fourier matrix `Q` is Hermitian and its derivative part is `−μ_ℓ δ_{kℓ}`. | `test_ccm_fourier_matrix_hermitian_and_shift` |

## Theorem ledger (continued): source claims and open conjectures

The table above records the **Theorem** and **Computation** rows; this table records the **Source claim** and **Open / conjecture** rows. Together they form the four-kind ledger. The archived paper's own status is retained. Several statements are not merely unproved here; two are **mathematically incorrect as written**, and the reconstruction records the correction.

| # | Kind | Claim | Source status | Reconstruction note |
|---|---|---|---|---|
| S1 | Source claim | Twin conical helices and the intersection polygon `P_k` | Source §2.1–2.2, definitions and direct computation | Formalised as definitions and computations (C4–C5). The polygon itself implies nothing about zeros. |
| S2 | Source claim | `Σ_{n≥1} (μ(n)/n) log ζ(ns) = Σ_p log(1−p^{-s})` | Archived claim used to justify prime cancellation | **Incorrect as stated.** The left coefficient at `p^{-ks}` is `(1/k)Σ_{d|k}μ(d)`, i.e. `1` at `k=1` and `0` otherwise; the right coefficient is `−1/k` at every `k`. The correct classical identity is `Σ_n (μ(n)/n) log ζ(ns) = Σ_p p^{-s}` (C6). |
| S3 | Source claim | Geometric prime distribution `τ_prime(t)=Σ_{p,m} (log p/p^{m/2}) δ(t−m log p)` | Source §2.3, heuristic derivation | The weights are formalised and positive (T7); the distributional derivation from the helices is not established, and its stated Möbius input (S2) is wrong. |
| S4 | Open / conjecture | Conjecture 3.1: `tors_1 = τ_prime + τ_arch` in `D'(R)` | Source conjecture; source says it is equivalent to the CCM Eigencoefficient Prime Sum Conjecture | Open. No Lean or Python proof; it requires the Weil explicit formula and a distributional limit not present in the source. |
| S5 | Source claim | Equation (3.2) for `tors_1` | Archived formula | **Incorrect for the stated curve.** For `φ(t)=ωt` it gives `ω/(1+ω²)²`; the Frenet torsion is `ω/(1+ω²)` (C1, C3). The correct general expression is `φ'(φ'⁴−φ'φ'''+3φ''²)/(φ'⁶+φ'⁴+φ''²)`; the archived denominator has an extra factor `(φ'²+1)`. |
| S6 | Open / conjecture | Theorem 4.1: assuming Conjecture 3.1, RH is equivalent to `tors_r = tors_1` for some smooth `r` interpolating the real parts | Source theorem, conditional | **Not a theorem of this reconstruction.** Two gaps in the printed proof: (a) the step `r ≡ 1/2` uses “torsion is invariant under constant scaling”, which is false — `τ_c(ω)=ω/(1+c²ω²)` (T4–T5, C2); (b) the set `{m log p}` is asserted dense, but this is unsupported and false as stated: the interval `(log 2, log 3)` contains no `m log p` with `m ≥ 1`. The implication `(ii) ⇒ (i)` is therefore not established, and RH remains open. |
| S7 | Source claim | CCM dictionary: `D_λ = i d/dx + Σ (log p/p^{m/2}) δ(x−m log p mod L)` is self-adjoint, and its finite truncation is the CCM matrix | Source §5, citing Albeverio et al. | Not formalised. C8 only checks a finite Hermitian model of the source's Fourier matrix elements; it does not construct the self-adjoint extension or identify it with the CCM spectral triple. |
| S8 | Open / conjecture | Eigencoefficient Prime Sum Conjecture | CCM conjecture, restated by the source | Open; not formalised. |
| S9 | Open / conjecture | The regularised spectral determinant of `D_λ` converges to `Ξ(z)`, so the spectrum is the zero set and the trace formula is Weil's explicit formula | Source conclusion | Source claim / open. No construction or proof is given here. |

## Python layer

[`python/programme.py`](python/programme.py) is an exact sympy layer. It implements:

- `helix`, `scaled_helix`, `frenet_torsion`;
- `helix_torsion`, `scaled_helix_torsion`, `source_torsion_linear_phase`;
- `cone_radius`, `intersection_abscissa`, `intersection_point`, `cone_radius_ratio`;
- `prime_weight`, `prime_power_weights`, `mobius_log_coefficient`, `source_log_coefficient`;
- `ccm_fourier_matrix` (finite truncation of the source's `Q_{kℓ}`).

Run the suite:

```bash
python3 -m pytest the-final-letter/topics/geometric-reformulation/tests -q
```

Current result: **8 passed** (about 9 seconds). The tests use exact symbolic differentiation and rational arithmetic; no floating-point tolerance is used except the explicit `sp.N(..., 40)` decay comparisons.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the namespace `GeometricReformulation`, and proves T1–T7. It defines `helixTorsion`, `scaledTorsion`, `coneRadius`, and `primeWeight`. There is no `sorry`, `axiom`, or `admit`.

```bash
the-final-letter/topics/geometric-reformulation/lean/check.sh 2>&1 | tee lean/BUILD.log
```

The script is a thin wrapper around the shared [`tools/check-lean.sh`](../tools/check-lean.sh) and uses the local Mathlib installation. The committed [`lean/BUILD.log`](lean/BUILD.log) records the last successful check.

**What is not formalised:** the Frenet–Serret derivative computation itself (the closed forms are checked symbolically in Python, C1–C2, and taken as definitions in Lean); the general non-linear-phase torsion; the analytic phase interpolation `φ(γ_n)=2πn`; Conjecture 3.1; the distributional explicit formula; the corrected Theorem 4.1; the CCM operator and its self-adjointness. See [`lean/README.md`](lean/README.md) for the precise boundary.

## Open items and known gaps

1. **Conjecture 3.1 (Geometric Explicit Formula).** Give a rigorous distributional proof, or a precise counterexample. This is the main open item of the source.
2. **Repair Theorem 4.1.** The constant-radius step is false (T5) and the density claim for `{m log p}` is unsupported. A correct equivalence would need a different deformation or an additional argument; as printed, the theorem does not establish RH.
3. **Correct the torsion formula (3.2).** Replace the archived denominator by `φ'⁶+φ'⁴+φ''²`, and formalise the non-linear-phase case.
4. **Correct the Möbius identity.** Use `Σ_n (μ(n)/n) log ζ(ns) = Σ_p p^{-s}`, then justify the further step from this identity to `τ_prime`.
5. **CCM layer.** Construct the self-adjoint Dirac operator with point interactions, identify the finite truncation with the CCM quadratic form, and state the Eigencoefficient Prime Sum Conjecture precisely.
6. **Explicit formula.** Relate the torsion distribution to the Weil explicit formula; the source asserts this relation but does not prove it.

The reconstruction therefore has a genuine elementary core (torsion bounds, cone-radius monotonicity, prime-weight positivity, finite Hermitian matrix) and a large speculative periphery. **No archived RH, GRH, twin-prime, Chowla, or CCM claim is promoted to a theorem.**

## Provenance and links

- Archived source paper: [`geometric-reformulation.html`](../../archive/maths/rh/research/geometrc-reformulation/geometric-reformulation.html) (directory name retains the archived spelling `geometrc`).
- Inventory entry: [`scraps.html`](../../scraps.html) item 10.
- All reconstructed topics: [`topics/README.md`](../README.md).
- Final-letter index: [`../../index.html`](../../index.html).
- Programme standard: [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).
- Old harvest note: the topic overlaps inventory items 22 and 30; this folder supersedes the earlier one-paragraph stub.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
