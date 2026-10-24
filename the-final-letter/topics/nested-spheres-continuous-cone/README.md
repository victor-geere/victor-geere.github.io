# Nested spheres and continuous cone — research programme

**Status:** reconstructed elementary formal core and exact computation layer.
Both archived notes claim a geometric proof of the Riemann hypothesis; that
claim is **not accepted** here and is recorded as an archived source claim.
**Inventory:** [Scraps](../../scraps.html) item 3 · [Topic index](../README.md).
**Sources:** [`maths/nested_spheres_RH.html`](../../geometric-dynamical-phase-transitions/maths/nested_spheres_RH.html)
and [`maths/continuous_cone_RH_solution.html`](../../geometric-dynamical-phase-transitions/maths/continuous_cone_RH_solution.html).
**Audit:** [`summary/13-working-notes/`](../../summary/13-working-notes/README.md),
especially [nested-spheres.md](../../summary/13-working-notes/nested-spheres.md)
and [continuous-cone.md](../../summary/13-working-notes/continuous-cone.md).

## What the programme is

The two notes attempt to convert the finite mean-zero filter of the
Riemann-zeta programme into a geometric and measure-theoretic argument.

* The **nested-spheres** note places the polygonal paths of the coherent sum
  on three-sphere fibres of the quaternionic Hopf fibration, scales successive
  fibre radii by `N⁻¹`, and claims that tightness plus pure-point limits
  supported on critical-line zeros imply RH.
* The **continuous-cone** note replaces the integer scale `N` by a real radius
  `R`, asserts a local quadratic form with constant `c₁ = 1/2`, derives a
  differential inequality, and claims a power-saving depth-of-closure bound
  and hence RH.

The audit in `summary/13-working-notes` finds that the set-up, the exact
filter identity, parity independence and the `O(N⁻¹)` sampling estimate are
consistent with the canonical paper. It rejects the decisive steps: the local
diagonal with constant `1/2` is false (the canonical Lemma 6.3 gives
`-1 + R∫φ²`), the differential inequality is withdrawn, the second-moment
bound omits an `N³` term, and support of the limit measures only on the
critical line is already RH-strength. Neither note is part of the canonical
proof chain.

This folder therefore reconstructs only the geometry, filter and regularity
facts that survive. The RH conclusion, the residual-mass and tail bounds, the
differential inequality and the pure-point limit theorem remain source claims
or open items.

## Provenance and audit status

| Note | What it attempts | Audit verdict |
|---|---|---|
| [Nested spheres](../../geometric-dynamical-phase-transitions/maths/nested_spheres_RH.html) | All `N ≥ 2`, nested Hopf fibres, tightness, pure-point limits on critical-line zeros. | Definitions and exact identity consistent; support and depth claims are not established. |
| [Continuous cone](../../geometric-dynamical-phase-transitions/maths/continuous_cone_RH_solution.html) | Real radius `R`, local quadratic form `c₁ = 1/2`, differential inequality, RH. | Local quadratic form false; differential inequality and RH conclusion not established. |
| [Working-notes audit](../../summary/13-working-notes/README.md) | Claim-by-claim comparison with the canonical paper. | Records the withdrawn `c₁ = 1/2` route and the surviving elementary material. |

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| Nested fibre radius | `r_N = 1 / N`, with `r_{N+1} < r_N` and `r_N → 0` |
| Mean-zero coefficient | `c_m(N) = 1 - N` if `N ∣ m`, otherwise `1` |
| Coherent sum | `η_N(M)(s) = ∑_{m≤M} c_m(N) m^{-s}`, with `M = N²` |
| Purification factor | `1 - N^{1-s}`, multiplying `ζ(s)` |
| Sampling chord | `2 sin(π/N)` for one edge of the regular `N`-gon |
| Sampling arc | `2π/N` |
| Residual function | `ρ_N(t) = |η_N(N²)(1/2 + it)|` |
| Residual measure | `μ_N(dt) = ρ_N(t)(1+t²)^{-1} dt` |
| Corrected local diagonal | `∫_{-1}^{1}(1 - Rφ)(-φ) du = -∫φ + R∫φ²` |

## Theorem ledger

The ledger has four kinds. A **Theorem** row is proved in
[`lean/Topic.lean`](lean/Topic.lean) with no unfinished proof and no new
axiom. A **Computation** row is tested in
[`tests/test_programme.py`](tests/test_programme.py). A **Source claim** row is
asserted by an archived note and is not a theorem of this reconstruction. An
**Open / conjecture** row is a precise unresolved statement.

| # | Kind | Statement | Evidence / status |
|---|---|---|---|
| T1 | Theorem | `0 < r_N` for every `N ≥ 1`. | `NestedSpheres.fibreRadius_pos` |
| T2 | Theorem | The nested radii strictly decrease: `r_{N+1} < r_N` for `N ≥ 1`. | `NestedSpheres.fibreRadius_strictAnti` |
| T3 | Theorem | `r_N → 0` as `N → ∞`. | `NestedSpheres.fibreRadius_tendsto_zero` |
| T4 | Theorem | The exceptional coefficient is `c_N(N) = 1 - N`. | `NestedSpheres.meanZeroCoeff_self` |
| T5 | Theorem | One full period of the filter sums to zero: `∑_{i=0}^{N-1} c_{i+1}(N) = 0`. | `NestedSpheres.meanZeroCoeff_period_sum` |
| T6 | Theorem | A polygonal edge is no longer than its arc: `2 sin(π/N) ≤ 2π/N` for `N ≥ 1`. | `NestedSpheres.chord_le_arc` |
| T7 | Theorem | Corrected local diagonal: `∫_{-1}^{1}(1 - Rφ)(-φ) = -∫φ + R∫φ²`. | `NestedSpheres.localDiagonal_integral` |
| C1 | Computation | The exact radii are positive, strictly nested and rational for `N ≤ 50`. | `test_fibre_radius_pos_and_nesting` |
| C2 | Computation | Period sums vanish for `N ≤ 30`, `c_N(N)=1-N`, and the `N=1` edge case is zero. | `test_mean_zero_coeff_and_period_sum` |
| C3 | Computation | The purification factor equals `0` at `s=1` and `1-N` at `s=0`. | `test_purification_factor_vanishes_at_one` |
| C4 | Computation | `2 sin(π/N) < 2π/N` for `2 ≤ N ≤ 200`; the chord/arc ratio increases towards `1`. | `test_sampling_chord_below_arc` |
| C5 | Computation | For two explicit normalised `φ`, the exact integral equals `-∫φ + R∫φ²`. | `test_local_diagonal_integral_corrected` |
| C6 | Computation | Local-diagonal edge cases: `R=0` and `∫φ²=0` give `-1`; the slope in `R` is `∫φ²`. | `test_local_diagonal_edge_cases` |
| S1 | Source claim | Purification identity `∑_{m≥1} c_m(N)m^{-s} = (1-N^{1-s})ζ(s)` for `Re s > 1`, with meromorphic continuation. | Archived lemma; elementary and consistent with the canonical paper. Only the period mean-zero sum is formalised (T5). |
| S2 | Source claim | Parity independence: all estimates hold for every integer `N ≥ 2`. | Archived lemma; consistent, not formalised. |
| S3 | Source claim | Hausdorff distance between the polygon and a complete fibre curve is `O(N⁻¹)`, uniformly in the height `t`. | Archived lemma; the per-edge bound T6 is formalised, the uniform geometric comparison is not. |
| S4 | Source claim | Balanced path-closures of depth `N^{1/2-ε}` occur if and only if `Re s = 1/2`. | Archived claim; **overstated**. The canonical theorem only confines closures to a half-strip and does not characterise the line. |
| S5 | Source claim | Residual mass `‖μ_N‖ = O(N⁻¹)` uniformly. | Archived claim; **unsupported as written**; proof uses a different second-moment argument. |
| S6 | Source claim | Second-moment bound `∫_{-T}^{T}|η_N(N²)(1/2+it)|² dt ≤ C₀NT log(2T)`. | Archived claim; **not correct as stated**: the spike term contributes an additive `N³`. |
| S7 | Source claim | The family `{μ_N}` is tight. | Archived claim; true in the canonical paper (Theorem 9.1) but not established by the note's argument. |
| S8 | Source claim | Every weak-star limit is pure-point and supported on critical-line zeros. | Archived claim; **not established**. Support only on the line is already RH-strength. |
| S9 | Source claim | Depth of closure `|η_R(R²)(1/2+iγ)| ≤ C_γ R^{1/2-η}`. | Archived claim; **not established**. Rests on the withdrawn `c₁=1/2` inequality. |
| S10 | Source claim | Residual-measure tails `μ_R({|t|>R^α}) = O(R^{-α/2})`. | Archived claim; unsupported as written. |
| S11 | Source claim | Continuous filter `ρ(R,s)` is `C¹` in `R` (continuous-cone Lemma 1.3). | Archived lemma; consistent with the canonical treatment, not formalised. |
| S12 | Source claim | Local quadratic form with constant `c₁ = 1/2` (continuous-cone Lemma 2.1). | **False / withdrawn.** The correct integral is T7; the constant is not `-1/2`. |
| S13 | Source claim | Differential inequality `∂_R ρ ≤ -c R^{-1/2}ρ + …` (continuous-cone Theorem 2.2). | Archived claim; not established; the canonical paper explicitly does not use it. |
| S14 | Source claim | Continuous-cone tightness and tails (Theorems 3.3, Lemma 3.4), and off-line lower bound (Theorem 4.1). | Archived claims; tightness/tails unsupported, and the off-line bound has no proof. |
| S15 | Source claim | The Riemann hypothesis follows from either note. | **Archived claim / not accepted.** No row above promotes it; the canonical Corollary 12.3 is a conversion, not a proof. |
| O1 | Open / conjecture | Uniform-in-height Hausdorff `O(N⁻¹)` comparison of the polygon with a complete fibre curve. | Open; only the per-edge chord bound is proved. |
| O2 | Open / conjecture | Full purification identity and meromorphic continuation as a Dirichlet-series statement. | Open in this reconstruction; T5 captures only the period sum. |
| O3 | Open / conjecture | The correct local quadratic form of the continuous cone, and whether any differential inequality with a genuine negative drift survives. | Open; the `c₁=1/2` route is withdrawn. |
| O4 | Open / conjecture | Uniform residual mass and tail bounds for `{μ_N}` / `{μ_R}`. | Open; the archived proofs are incomplete or incorrect. |
| O5 | Open / conjecture | Every weak-star limit is supported exactly on the imaginary parts of critical-line zeros. | Open; equivalent to the surviving gap, not a theorem. |
| O6 | Open / conjecture | A power-saving depth-of-closure bound derived from the canonical Theorem 4.1 rather than the withdrawn inequality. | Open. |
| O7 | Open / conjecture | The Riemann hypothesis. | Open; not claimed by this reconstruction. |

## Why the archived proof does not go through

1. **The local diagonal is wrong.** The continuous-cone note evaluates
   `∫(1-Rφ)(-φ)` as `-1/2 + O(R⁻¹)`. The correct value is
   `-1 + R∫φ²`, which is not `-1/2` and carries the `R`-dependence that the
   drift term needs. T7 formalises the correction; C5 verifies it exactly.
2. **The differential inequality inherits the error.** Without a negative
   constant there is no drift, and the integrating-factor argument collapses.
   The canonical changelog and `gaps.html` record the inequality as withdrawn
   and do not use it.
3. **The second-moment bound drops a term.** The archived
   `C₀NT log(2T)` estimate omits the additive `N³` spike contribution; at
   fixed `T` and large `N` it is too strong to support the claimed `O(N⁻¹)`
   residual mass.
4. **The support claim is the gap.** The canonical measure theory removes the
   left half-strip but not the right half-strip; a right-half zero remains an
   unrestricted atom. Asserting that limits live only on the critical line is
   already the open conversion, not a consequence.
5. **Neither note is in the canonical proof chain.** They are working notes
   linked from the paper, not accepted proofs.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact computation
layer with `sympy`:

- `fibre_radius`, `fibre_radii` — nested rational radii;
- `mean_zero_coeff`, `period_coeff_sum` — the filter and its period identity;
- `purification_factor` — the exact factor `1 - N^{1-s}`;
- `sampling_chord`, `sampling_arc`, `sampling_ratio` — the `N`-gon sampling;
- `phi_mean`, `phi_energy`, `local_diagonal`, `local_diagonal_integral` — the
  corrected continuous-cone diagonal.

No `mpmath` is needed; the only numerical comparison is the finite-precision
sign check in the sampling test, with a stated 40-digit evaluation.

Run from the repository root:

```bash
python3 -m pytest the-final-letter/topics/nested-spheres-continuous-cone/tests -q
```

Recorded result: **6 passed** (under 1 second).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `NestedSpheres.fibreRadius`,
`NestedSpheres.meanZeroCoeff`, `NestedSpheres.chord` and proves T1–T7. It
imports Mathlib and uses only elementary order, filter, finite-sum, division
and interval-integral facts. The file contains no unfinished proof and no new
axiom.

```bash
the-final-letter/topics/nested-spheres-continuous-cone/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.
See [`lean/README.md`](lean/README.md) for the precise boundary of what is
formalised.

## Open items and known gaps

1. **Uniform sampling geometry.** T6 gives the per-edge chord bound, but the
   archived Lemma 3.2 also asserts uniformity in the height `t` for the
   Hausdorff distance to a complete fibre curve. That comparison is not
   formalised.
2. **The full purification identity.** T5 is the mean-zero period sum. The
   infinite Dirichlet series and its meromorphic continuation remain outside
   the Lean core.
3. **The corrected local quadratic form.** T7 proves the integral identity,
   not the differential inequality. Whether a modified inequality with a
   genuine negative drift can be derived is open.
4. **Residual mass and tails.** The archived `O(N⁻¹)` and `O(R^{-α/2})`
   estimates are not established; the canonical paper uses a different route.
5. **Support of the limit measures.** Removing the right half-strip is the
   surviving open problem and is not a consequence of the geometric picture.
6. **RH itself.** Neither note proves it. The canonical Corollary 12.3 is an
   equivalence/conversion, not a proof.

## Verification

```bash
cd the-final-letter/topics/nested-spheres-continuous-cone
python3 -m pytest -q tests
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Both commands pass as recorded in this dossier.

## Provenance

- [Scraps inventory](../../scraps.html) — item 3.
- [Topic index](../README.md) — all reconstructed topics.
- [Nested-spheres source](../../geometric-dynamical-phase-transitions/maths/nested_spheres_RH.html).
- [Continuous-cone source](../../geometric-dynamical-phase-transitions/maths/continuous_cone_RH_solution.html).
- [Working-notes audit](../../summary/13-working-notes/README.md).
- [Canonical Lemma 6.3](../../summary/04-continuous-radius-and-mean-values/03-lemma-6.3.md) — the corrected local diagonal.
- [Canonical Theorem 4.1](../../summary/02-exact-filter-and-remainder/04-theorem-4.1.md) — the depth bound actually used.
- [Canonical Corollary 12.3](../../summary/05-spectral-measures-and-tightness/13-corollary-12.3.md) — the conversion, not a proof of RH.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
