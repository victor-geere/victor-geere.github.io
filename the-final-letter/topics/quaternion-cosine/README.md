# Quaternion–cosine framework — research programme

**Status:** reconstructed elementary formal core + exact computation layer. The archived source is a speculative essay; its central conjecture about the Riemann hypothesis is preserved as an open claim and is **not** proved here.  
**Source:** [`archive/essays/rh/riemann-hypothesis.html`](../../archive/essays/rh/riemann-hypothesis.html) — “Exploring a Quaternion-Cosine Geometric Approach to the Riemann Hypothesis”.  
**Inventory:** [Scraps](../../scraps.html) item 39 · [Topic index](../README.md).  
**Related archive material:** the condensed exposition [`rh-cosine-quaternion-framework.html`](../../archive/essays/rh/rh-cosine-quaternion-framework.html) and the follow-up [`dictionary-cos-quaternions.html`](../../archive/essays/rh/dictionary-cos-quaternions.html). Neither adds a proof; both repeat the same conjectural programme.

## Provenance and status

The source is an extended, conversation-derived essay. Its own framing is explicit:

> “While the approach remains highly speculative and currently lacks rigorous justification, it offers an interesting visualization-based intuition…” (source, §1)

and again in the conclusion: the framework “remains far from a rigorous proof of the Riemann Hypothesis.” The essay contains a long list of acknowledged gaps (§8): no bridge from the continuous energy functional to prime sums, no rigorous connection between cosine alignment and zeros of `ξ`, no sharp nonlinear exponential-sum bounds, an unjustified logarithmic-to-geometric substitution, and uncontrolled constants.

What the source *does* define precisely enough to reconstruct is a small, genuine elementary core:

- Hamilton quaternion units `i, j, k` with `i² = j² = k² = −1` and `ij = −ji = k`;
- a lifted cosine phase `φ(x) = cos(2πx) i + cos(2πp/x) j`;
- a scalar divisor detector `cos(2πx) + cos(2πp/x) − 2`;
- the periodicity fact `cos(2πn) = 1` for integers `n`;
- an alignment energy `E = (1 − cos(2πx))² + (1 − cos(2πp/x))²`;
- a warping factor `2σ − 1` associated with the functional equation.

Those objects are reconstructed below. The leap from them to the Riemann hypothesis is not.

## Reconstructed objects and notation

| Object | Definition | Role in the source |
|---|---|---|
| Quaternion units | `i, j, k` with `i² = j² = k² = −1`, `ij = k`, `ji = −k` | The algebra in which the two cosine phases are separated. |
| Divisor detector | `D(x,p) = cos(2πp/x) + cos(2πx) − 2` | Claimed to vanish exactly at positive divisors `x` of `p`. |
| Cosine phase | `φ(x) = cos(2πx) i + cos(2πp/x) j` | Lifts the two scalar cosines into orthogonal quaternion coordinates. |
| Lifted displacement | `δ(x) = (1 − cos(2πx)) i + (1 − cos(2πp/x)) j` | The vector from the target `i + j` to the phase. |
| Alignment energy | `E(x) = (1 − cos(2πx))² + (1 − cos(2πp/x))²` | Squared distance from perfect alignment; always non-negative. |
| Warping factor | `w(σ) = 2σ − 1` | Vanishes on the critical line; the source uses it to model functional-equation distortion. |
| Warped height | `t' = t / (2σ − 1)` | Formal expression only; undefined at `σ = 1/2`. |

Two notational points matter:

1. The source’s prose writes the warped height as `t' ~ t/(2σ−1)`, but its sample Python code uses `effective_t = t / abs(sigma - 0.5)`. These differ even by a factor of two. The reconstruction records the prose expression exactly and treats the code version as an inconsistency, not a definition.
2. The source sometimes says alignment with “`i + j` (or any scaled version thereof)”. The energy `E` vanishes only at `(1,1)`, so the formal core uses `i + j` exactly.

## Theorem ledger

The ledger uses four kinds: **Theorem**, **Computation**, **Source claim**, and **Open / conjecture**. Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is covered by [`tests/test_programme.py`](tests/test_programme.py). Source claims and open statements are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The quaternion units satisfy `i² = j² = k² = −1`, `ij = k`, and `ji = −k`. | `QuaternionCosine.quaternion_relations` |
| T2 | Theorem | The lifted phase `φ = a i + b j` has squared norm `a² + b²`. | `QuaternionCosine.phase_normSq` |
| T3 | Theorem | `cos(2πx) = 1` if and only if `x` is an integer. | `QuaternionCosine.cos_two_pi_mul_eq_one_iff` |
| T4 | Theorem | For `x ≠ 0`, `D(x,p) = 0` if and only if both `x` and `p/x` are integers. | `QuaternionCosine.detector_eq_zero_iff` |
| T5 | Theorem | The alignment energy is non-negative: `0 ≤ E(x)`. | `QuaternionCosine.energy_nonneg` |
| T6 | Theorem | `E(x) = 0` if and only if both cosines equal `1`. | `QuaternionCosine.energy_eq_zero_iff` |
| T7 | Theorem | The warping factor vanishes exactly on the critical line: `2σ − 1 = 0 ↔ σ = 1/2`. | `QuaternionCosine.warp_eq_zero_iff` |
| C1 | Computation | The exact Hamilton product gives `i² = j² = k² = −1`, `ij = k`, `ji = −k`. | `test_quaternion_units_are_exact` |
| C2 | Computation | The squared quaternion norm of the phase equals the sum of squared cosines, and the squared norm of the displacement equals the alignment energy. | `test_phase_norm_matches_alignment_energy` |
| C3 | Computation | The detector vanishes exactly at every divisor of `12`, and `is_divisor` agrees with sympy’s divisor list `[1,2,3,4,6,12]`. | `test_detector_vanishes_at_all_divisors` |
| C4 | Computation | The detector is strictly negative at the non-divisors `x = 5` and `x = 7/2` for `p = 12`. | `test_detector_negative_off_divisors` |
| C5 | Computation | The energy is `0` at every divisor of `12` and equals `4` at `(x,p) = (1/2,1)`. | `test_alignment_energy_zero_at_divisors_and_positive_off` |
| C6 | Computation | `w(1/2) = 0`, `w(3/4) = 1/2`, and `t' = 28` for `t = 14`, `σ = 3/4`; `warped_height` raises at `σ = 1/2`. | `test_warp_factor_vanishing_and_warped_height` |
| C7 | Computation | Non-positive `x`, non-positive `p`, and non-positive moduli are rejected; the edge case `p = 1` has the single divisor `1` and zero detector there. | `test_edge_cases_reject_nonpositive_inputs` |

T4 is the source’s elementary divisor-detector claim, formalised for real `x ≠ 0`; for integer `p` the two integer conditions are exactly divisibility, and the Lean statement does not assume `p` is an integer. The Lean proof of T4 uses T3 twice. T1 and T2 are the quaternion facts the source actually uses; they are not `rfl` restatements, since the product and squared norm are computed from the structure of `ℍ[ℝ]`.

## Source claims (not promoted to theorems)

These are recorded with the source’s own status. None is a theorem of this reconstruction.

| # | Kind | Claim | Source status | Reconstruction note |
|---|---|---|---|---|
| S1 | Source claim | Perfect alignment means `inf_{x>0} E(x) = 0`. | Source definition / heuristic | The finite equivalence `E = 0 ↔ both cosines = 1` is T6. The infimum over `x > 0` is not analysed here. |
| S2 | Source claim | If `σ ≠ 1/2`, then `inf_x E(x) > 0`, so no zero can occur off the critical line. | Archived claim, **unproved** | The central gap. Nothing in the source establishes this implication. |
| S3 | Source claim | `ξ(s) = 0` if and only if the geometric, dyadic, and symmetry conditions of the “central conjecture” hold. | Archived conjecture | The dyadic condition is not given a precise mathematical definition; the equivalence is open. |
| S4 | Source claim | Functional-equation reflection produces the warping `t → t/(2σ−1)`, which breaks cosine alignment. | Source heuristic | No derivation from `ξ(s) = ξ(1−s)` is supplied. The prose factor also disagrees with the sample code. |
| S5 | Source claim | Prime phase cancellation, via sums such as `∑_p cos(t log p)/√p`, controls the energy. | Source speculation | The source itself calls this the most speculative step and notes the required exponential-sum bounds exceed known results. |
| S6 | Source claim | Numerical experiment shows minimum energy near zero on the critical line and positive off it. | Archived numerical illustration | The sample code is a crude visualisation, not a proof; no reproducible numerical result is claimed here. |
| S7 | Source claim | The dyadic sine construction converges exponentially. | Cited background claim (Geere) | Not part of the quaternion–cosine formal core. |

**No Riemann-hypothesis, GRH, twin-prime, Chowla, or Sarnak statement is asserted as proved anywhere in this folder.**

## Python layer

[`python/programme.py`](python/programme.py) implements exact sympy computations:

- `phase(x,p)` — the quaternion `cos(2πx) i + cos(2πp/x) j` as a four-tuple;
- `quaternion_mul`, `quaternion_norm_sq` — Hamilton product and squared norm;
- `detector(x,p)` — `cos(2πp/x) + cos(2πx) − 2`;
- `alignment_energy(x,p)`, `displacement_quaternion(x,p)`;
- `is_divisor(p,x)`, `divisors_exact(p)`, `detector_on_divisors(p)`;
- `warp_factor(σ)`, `warped_height(t,σ)`;
- `is_aligned(x,p, tol=None)`.

All decisions in the tests are exact; the only approximate helper is the optional `tol` branch of `is_aligned`, which is not used by the suite. Run from the topic directory:

```bash
cd the-final-letter/topics/quaternion-cosine
python3 -m pytest -q tests
```

Current result: **7 passed** (about 0.3 s). The suite covers every Computation row and the edge cases `x ≤ 0`, `p ≤ 0`, and `p = 1`.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens `QuaternionCosine`, defines the quaternion units, the lifted phase, the energy, the detector, and the warping factor, and proves T1–T7. It contains no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/quaternion-cosine
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK   Topic.lean (5s)`. See [`lean/README.md`](lean/README.md) for what the formal core does and does not cover.

## Open items and known gaps

| # | Kind | Statement | Why it is open |
|---|---|---|---|
| O1 | Open / conjecture | `inf_x E(x) = 0` is equivalent to `ξ(σ+it) = 0`. | The energy–zero bridge is missing in both directions; the source identifies this as the central gap (§8.2). |
| O2 | Open / conjecture | The warping `t′ ~ t/(2σ−1)` follows from `ξ(s) = ξ(1−s)`. | It is asserted, not derived; the source’s own code uses a different factor. A rigorous treatment needs a precise definition of “effective frequency”. |
| O3 | Open / conjecture | For `σ ≠ 1/2`, `inf_x E(x) > c > 0` for some universal `c`. | The off-line lower bound is not established, and no explicit constant is given. |
| O4 | Open / conjecture | Prime-phase cancellation connects `E` to sums over primes. | Requires nonlinear exponential-sum bounds that the source acknowledges are beyond current technology. |
| O5 | Open / conjecture | The “dyadic condition” of the central conjecture is well defined. | The source refers to a dyadic expansion “aligned with the natural logarithmic spacing of primes” but states no precise condition; it cannot be formalised as written. |
| O6 | Open / conjecture | The pointwise divisor identity can be upgraded to a statement about minimisation over `x > 0`. | T4 and C3–C5 verify the detector and energy at exact points; they say nothing about minimisation, which is where the RH conjecture lives. |
| O7 | Open / conjecture | Probabilistic or spectral input (GUE, Berry–Keating, Connes) supplies a proof. | That discussion is contextual in the source, not part of a proved argument. |

## Verification

```bash
cd the-final-letter/topics/quaternion-cosine
python3 -m pytest -q tests
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Both commands pass. The ledger above is the one implemented by the files in this folder.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 39.
- [`topics/README.md`](../README.md) — all topic folders.
- [`archive/essays/rh/riemann-hypothesis.html`](../../archive/essays/rh/riemann-hypothesis.html) — the archived source.
- [`rh-cosine-quaternion-framework.html`](../../archive/essays/rh/rh-cosine-quaternion-framework.html) and [`dictionary-cos-quaternions.html`](../../archive/essays/rh/dictionary-cos-quaternions.html) — related archived restatements.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
