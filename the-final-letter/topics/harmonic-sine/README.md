# Harmonic sine — research programme

**Status:** reconstructed geometric core + exact computation layer. The source's Riemann-hypothesis claim is **archived and superseded**; it is not a theorem here.
**Source:** [`archive/maths/rh/research/harmonic-sine/harmonic-sine-rh.html`](../../archive/maths/rh/research/harmonic-sine/harmonic-sine-rh.html) (the 9 KB ebook of 7 March 2026), with the sibling geometric note [`sine-harmonic.html`](../../archive/maths/rh/research/harmonic-sine/sine-harmonic.html) and its TeX source [`sine-harmonic.tex`](../../archive/maths/rh/research/harmonic-sine/sine-harmonic.tex).
**Inventory:** [Scraps](../../scraps.html) item 15 · [Topic index](../README.md).

## Provenance and what this folder is

The source is a short, fragmentary ebook. Its first half defines a greedy reconstruction of `sin(πx)` from harmonic angle steps `π/(n+2)` fused by the Pythagorean rotation rule; its second half claims that a "harmonic sheaf" over the zeta landscape, plus an extension of Matomäki–Radziwiłł discorrelation to `1/n` phases, yields the Riemann hypothesis. The inventory entry marks the RH material as an **archived claim** and **superseded**, and this reconstruction treats it that way.

What survives as genuine mathematics is the finite geometry: the angle sequence, the rotation update, the invariant that the rotation preserves the unit circle, and the one-step greedy residual bound. Those are formalised in [`lean/Topic.lean`](lean/Topic.lean) and checked exactly in [`python/programme.py`](python/programme.py). The analytic limit theorem and every zeta/RH statement are recorded as source claims or open items below, not as results of this folder.

The source itself is inconsistent about the step size. `harmonic-sine-rh.html` defines

\[
h_n=\sqrt{\frac{1-\cos(\pi/(n+2))}{2}},
\]

which is `sin(π/(2(n+2)))`, the **half**-angle, while the rotation update needs `sin(π/(n+2))`. The sibling `sine-harmonic.tex` instead writes `h_n = dyadic_sin(1/(n+2))`. The Python layer verifies the exact half-angle identity and records the discrepancy as an erratum (row C2); the Lean core uses the correct `sin ε_n`/`cos ε_n` pair. A second clash is between the angle step `π/(n+2)` and the residual bound `π/(n+1)`: the reconstruction uses `π/(n+2)` for the angle and records `π/(n+1)` only as the source's bound.

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| Harmonic step | `ε n = π / (n + 2)` |
| Target | `π y`, with `y ∈ [0, 1]` measured in units of `π` |
| Selection word | `δ n ∈ {0,1}`, with `δ n = 1` iff `r n ≥ ε n` |
| Accumulated angle | `θ n = Σ_{j<n} δ j ε j` |
| Residual | `r n = π y − θ n` |
| Rotation pair | `(s n, c n)` intended to equal `(sin θ n, cos θ n)` |
| Step pair | `(h n, ch n) = (sin ε n, cos ε n)` |
| Rotation | `rotate (s,c) h ch = (s ch + c h, c ch − s h)` |
| One-step residual | `residStep r n = r − (ε n if ε n ≤ r else 0)` |
| Source's `h n` | `√((1 − cos ε n)/2) = sin(ε n/2)` — see erratum |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The harmonic step is positive: `0 < ε n` for every `n`. | `HarmonicSine.eps_pos` |
| T2 | Theorem | The step sequence is strictly antitone: `n ↦ ε n` decreases. | `HarmonicSine.eps_strictAnti` |
| T3 | Theorem | The step sequence tends to zero: `ε n → 0`. | `HarmonicSine.eps_tendsto_zero` |
| T4 | Theorem | The exact scaling identity `(n + 2) ε n = π`. | `HarmonicSine.scaled_eps` |
| T5 | Theorem | The rotation preserves the unit circle: if `s² + c² = 1` and `h² + ch² = 1`, then the rotated pair is again a unit vector. | `HarmonicSine.rotate_unit` |
| T6 | Theorem | The rotation pair `(sin θ, cos θ)` rotated by `(sin ε, cos ε)` is exactly `(sin(θ+ε), cos(θ+ε))`. | `HarmonicSine.rotate_trig` |
| T7 | Theorem | One greedy residual step preserves the invariant: if `0 ≤ r ≤ ε n`, then `0 ≤ residStep r n ≤ ε n`. | `HarmonicSine.residStep_bounds` |
| C1 | Computation | The source's half-angle expression equals `sin(ε n/2)` exactly for `n ≤ 11`, and its square equals `(1 − cos ε n)/2`. | `test_half_angle_sine_identity_exact` |
| C2 | Computation | Erratum: the source's `h n` is not `sin ε n` for `n ≤ 5`; doubling the half-angle recovers `sin ε n` exactly. | `test_source_half_angle_is_not_the_rotation_sine` |
| C3 | Computation | Symbolically, the rotation of `(sin θ, cos θ)` by `ε` equals `(sin(θ+ε), cos(θ+ε))`. | `test_rotation_is_angle_addition_symbolic` |
| C4 | Computation | Symbolically, the rotation preserves `s² + c² = 1`; zero and right-angle rotations give the expected pairs. | `test_rotation_preserves_unit_circle_symbolic` |
| C5 | Computation | The source's residual bound `0 ≤ r n ≤ π/(n+1)` holds exactly on a rational grid with `n_max` up to 200. | `test_greedy_residual_bound_on_grid` |
| C6 | Computation | The source's boundary equality is attained: at `y = 1`, `n = 1`, `r 1 = 1/2 = 1/(1+1)` in `π` units. | `test_greedy_residual_boundary_equality_at_y_equals_one` |
| C7 | Computation | The rotation reconstruction of `sin(π y)` agrees with the reference to within `10⁻¹²` for 400 steps on a 13-point grid (`k/12`, `k = 1..11`, plus `0` and `1`), including `y = 0, 1/2, 1`. | `test_reconstruction_convergence_with_stated_tolerance` |

## Source claims (not promoted to theorems)

These are recorded with the source's status. None is a theorem of this reconstruction.

| Claim | Source status | Reconstruction note |
|---|---|---|
| `sin(πx) = sgn(x) lim s_n(|x| mod 2)` for all real `x`, with periodic extension. | Source theorem, proof sketch only | The finite rotation identity (T6) and one-step bound (T7) are proved; the limit and the periodic/reflection reduction are not. |
| `s_n = sin θ_n` by induction. | Source proof step | T6 proves a single rotation step; the induction over the greedy history is not formalised. |
| `h_n = √((1 − cos(π/(n+2)))/2)` is computed geometrically and used as the step sine. | Source definition | **Erratum:** this is `sin(π/(2(n+2)))`, not `sin(π/(n+2))`. The correct pair is used in Lean and Python (C1, C2). |
| Convergence is `O(1/n)`, slower than the dyadic `O(1/2^n)` construction. | Source remark | The finite residual bound `r n ≤ π/(n+1)` is tested (C5); the asymptotic rate is not formalised. |
| Harmonic angles parallel the Euler product and zeta's explicit formula ("phase fusion", "multiplicative interference"). | Speculative analogy | The source's table is an analogy, not a stated identity; no precise claim is available to formalise. |
| Zeros off the critical line force non-alignment of harmonic phases, and RH follows from "acyclicity in a harmonic sheaf". | **Archived claim**, superseded | No sheaf, energy functional, or implication is defined precisely. Not formalised; not used as a premise anywhere here. |
| Extension of Matomäki–Radziwiłł discorrelation to `1/n` phases: for `α ∉ ℚ`, `H = x^{1/2+ε}`, `|Σ_{n≤x} cos(2πα/n)| ≪ x^{1−δ}`. | Source claim, proof sketch | No complete proof in the source; the differencing/van der Corput sketch is not formalised. This is a substantial open analytic statement. |
| Off-line energy bound `inf_x E(x) > c > 0`, with `c = x^{-1/4}`. | Source conjecture | `E(x)` is not defined precisely; not formalised. |
| "This ... offers a complete pathway to proving Riemann Hypothesis." | **Archived claim**, superseded | The conclusion is not supported by the source and is not a theorem here. RH remains open. |

## Errata

1. **Half-angle substitution.** `harmonic-sine-rh.html` uses `h_n = √((1 − cos ε_n)/2) = sin(ε_n/2)` but the angle-addition update requires `sin ε_n`. As written, the recurrence would advance by half the selected angle. The sibling geometric note avoids this by taking `h_n = dyadic_sin(1/(n+2))`, i.e. the full step sine. T6, C1 and C2 isolate the correct identity.
2. **`√(1 − s_n²)` is not `cos θ_n`.** The RH ebook's update uses `h_n√(1−s_n²) + s_n√(1−h_n²)`; the first radical is `|cos θ_n|`, which flips sign after `θ_n > π/2`. The sibling `sine-harmonic.html` explicitly repairs this by carrying `c_n` forward. The Lean rotation `(s,c) ↦ (s ch + c h, c ch − s h)` is the repaired form.
3. **Same text, three files.** `harmonic-sine-rh.html`, `harmonic-sine-zeta.html` and the essay-level copy are near-duplicates. The reconstruction cites the RH file as the designated source and notes the duplication rather than treating the copies as independent evidence.

## Python layer

[`python/programme.py`](python/programme.py) uses `sympy` for exact rational/trigonometric work and `mpmath` (50 digits) for the rotation reconstruction. The greedy layer works in exact rational multiples of `π`, so the residual comparisons never round.

| Function | Purpose |
|---|---|
| `harmonic_angle(n)` | `ε n = π/(n+2)` |
| `half_angle_sine(n)` | the source's `√((1 − cos ε n)/2)` |
| `step_sine(n)` | the required `sin ε n` |
| `rotation_step(s, c, ε)` | the angle-addition rotation |
| `greedy_word(y, n_max)` | exact greedy selection word for target `π y` |
| `greedy_residuals(y, n_max)` | exact residuals `r n` in `π` units |
| `residual_bound_holds(y, n_max)` | checks `0 ≤ r n ≤ 1/(n+1)` for `n ≥ 1` |
| `reconstruct_sine(y, n_max, dps)` | high-precision `sin(π y)` by rotation only |

Run from the repository root:

```bash
python3 -m pytest the-final-letter/topics/harmonic-sine/tests -q
```

Recorded result: **8 passed** in about 2 seconds.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `HarmonicSine` namespace, defines `eps`, `Point`, `rotate`, and `residStep`, and proves T1–T7. It contains no `sorry`, `axiom`, or `admit`.

```bash
the-final-letter/topics/harmonic-sine/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See [`lean/README.md`](lean/README.md) for exactly what is and is not formalised.

## Open items and gaps

1. **Full greedy recursion.** Formalise the finite sequence `θ n`, prove by induction that `0 ≤ r n ≤ π/(n+1)` for `n ≥ 1`, and derive `r n → 0`. T7 is only the one-step induction step.
2. **Reconstruction limit.** Prove `|sin a − sin b| ≤ |a − b|` in the needed form (or use the existing Mathlib Lipschitz lemma) and combine it with `r n → 0` and the reflection `y ↦ 2 − y` to obtain the boxed source identity.
3. **Resolve the `h n` erratum.** Decide the canonical definition across the v2/v3 files and the geometric note, and state the corrected recurrence in one place.
4. **Precise zeta correspondence.** The source's harmonic/zeta table is an analogy; no explicit identity or map is stated, so there is nothing yet to prove or refute formally.
5. **`1/n`-phase discorrelation.** The claimed Matomäki–Radziwiłł extension is a substantial analytic statement with no complete proof in the source. It remains open and unformalised.
6. **The RH claim.** "Harmonic sheaf acyclicity implies RH" is an archived, superseded claim. The Riemann hypothesis is not proved here, and nothing in this folder should be cited as a proof.

## Provenance and links

- [Source ebook: `harmonic-sine-rh.html`](../../archive/maths/rh/research/harmonic-sine/harmonic-sine-rh.html)
- [Sibling geometric note: `sine-harmonic.html`](../../archive/maths/rh/research/harmonic-sine/sine-harmonic.html) · [TeX](../../archive/maths/rh/research/harmonic-sine/sine-harmonic.tex)
- [Scraps inventory](../../scraps.html) — item 15, tagged *archived claim* and *superseded*
- [Topic index](../README.md) · [The Final Letter](../../index.html)

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
