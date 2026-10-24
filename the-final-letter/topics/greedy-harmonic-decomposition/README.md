# Greedy harmonic decomposition — research programme

**Status:** reconstructed formal core + exact computation layer; source claims preserved separately.  
**Source:** [`archive/maths/rh/research/greedy-harmonic/greedy-harmonic-decomposition.html`](../../archive/maths/rh/research/greedy-harmonic/greedy-harmonic-decomposition.html) and the threshold paper [`greedy-harmonic-thresholds.html`](../../archive/maths/rh/research/greedy-harmonic/greedy-harmonic-thresholds.html).  
**Inventory:** [Scraps](../../scraps.html) item 11 · [Topic index](../README.md).

## What the programme is

The greedy harmonic decomposition (GHD) decomposes a target angle `θ ∈ [0, π]` into a sub-sum of the harmonic angles

\[
\alpha_n=\frac{\pi}{n+2},\qquad n=0,1,2,\ldots
\]

At step `n` the algorithm selects `α_n` when the remaining residual is at least `α_n`. The resulting binary word `δ_n(θ)` reconstructs `sin θ` through the angle-addition formula. The threshold paper proves that the first target at which index `n` is selected is exactly `θ_n* = α_n`, and derives closed forms for the correlation kernel

\[
K(n,m)=\int_0^\pi\left(\delta_n(\theta)-\frac{\theta}{\pi}\right)
\left(\delta_m(\theta)-\frac{\theta}{\pi}\right)d\theta .
\]

This folder reconstructs the programme around that finite, checkable core. The analytic convergence theorem and the full infinite threshold recursion remain source claims; the formal core below records the order and kernel facts that can be proved in Lean, and the Python layer verifies the finite computations exactly.

## Objects and notation

| Object | Definition |
|---|---|
| Harmonic angle | `α n = π / (n + 2)` |
| Selection word | `δ n(θ) ∈ {0,1}`, with `δ n = 1` when `θ − accumulated ≥ α n` |
| Accumulated angle | sum of the selected `α k` for `k < n` |
| Threshold | `θ n* = inf { θ : δ n(θ) = 1 }` |
| Diagonal kernel | `K(n,n) = (t³ + (π − t)³) / (3π²)`, `t = θ n*` |
| Off-diagonal kernel | the three-interval integral with `t n* ≤ t m*` |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry` or `axiom`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `0 < α n` for every `n`. | `GHD.alpha_pos` |
| T2 | Theorem | `n ↦ α n` is strictly antitone. | `GHD.alpha_strictAnti` |
| T3 | Theorem | `α n → 0` as `n → ∞`. | `GHD.alpha_tendsto_zero` |
| T4 | Theorem | `(n + 2) α n = π`; the rescaled threshold is `1`. | `GHD.scaled_alpha` |
| T5 | Theorem | The diagonal kernel is positive for `0 < t < π`. | `GHD.Kdiag_pos` |
| T6 | Theorem | The diagonal kernel is symmetric: `Kdiag t = Kdiag (π − t)`. | `GHD.Kdiag_symm` |
| T7 | Theorem | `Kdiag (π/2) = π/12`. | `GHD.Kdiag_half` |
| C1 | Computation | The exact threshold recursion returns `θ n* = α n` for `n ≤ 40`. | `test_threshold_identity_exact` |
| C2 | Computation | At `θ = α n`, index `n` is selected and no earlier index is. | `test_threshold_at_own_angle_selects` |
| C3 | Computation | The residual bound `0 ≤ θ − θ_N ≤ π/(N+2)` holds on a grid. | `test_residual_bound` |
| C4 | Computation | The closed-form diagonal kernel equals the defining integral. | `test_diagonal_kernel_matches_integral` |
| C5 | Computation | The closed-form off-diagonal kernel equals the defining integral. | `test_off_diagonal_kernel_matches_integral` |
| C6 | Computation | The diagonal kernel is positive and symmetric on the grid. | `test_diagonal_kernel_symmetry_and_half_value` |

## Source claims (not promoted to theorems)

These are recorded with the source's status, not adopted as proved here.

| Claim | Source status | Reconstruction note |
|---|---|---|
| Harmonic reconstruction `sin θ = lim s_N` with `O(1/N)` rate | Source theorem, with a proof sketch | Not formalised; the finite greedy layer is tested, the limit is not. |
| Selection monotonicity `θ ↦ δ n(θ)` | Source lemma | Not formalised. |
| Full threshold identity `θ n* = α n` for all `n` | Source theorem, derived by induction | Verified exactly for `n ≤ 40`; the Lean file proves the order facts, not the induction. |
| Selection density `D(N,θ) = (θ/π) log(N+2) + O(1)` | Source lemma | Not formalised. The finite fraction is not used as a theorem; for exact harmonic targets the word can terminate early. |
| Asymptotic threshold distribution | Source proposition | Open/exploratory; not formalised. |

## Python layer

[`python/programme.py`](python/programme.py) implements:

- `alpha(n)`, `alpha_scaled(n)`;
- `greedy_digits(theta, n_max)` and `greedy_accumulated`;
- `thresholds(n_max)` using the exact rational recursion;
- `Kdiag(t)`, `Koff(tn, tm)`, `kernel_integral(tn, tm)`;
- `residual_bound_holds(theta, n_max)`.

Run the tests:

```bash
python3 -m pytest the-final-letter/topics/greedy-harmonic-decomposition/tests -q
```

Current result: **10 passed**.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `GHD.alpha` and `GHD.Kdiag` and proves T1–T7. It imports Mathlib and uses only elementary order, limit, and field facts.

```bash
the-final-letter/topics/greedy-harmonic-decomposition/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

## Open items and gaps

1. **Formalise the threshold induction.** The source proves `θ n* = α n` by induction; the Lean core currently proves the order facts and the Python layer verifies the finite recursion. A full Lean proof would need a formal greedy recursion and an induction over selection histories.
2. **Formalise the reconstruction limit.** The `O(1/N)` sine reconstruction needs a formal residual lemma and a limit argument; the source proof sketch is not yet a Lean proof.
3. **Selection density.** The source's density lemma deserves a precise statement before formalisation; exact harmonic targets are a boundary case.
4. **Kernel positivity in general.** T5 proves positivity for a single threshold; the full kernel matrix is not shown positive semidefinite here.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 11.
- [`topics/README.md`](../README.md) — all topic folders.
- [`summary/14-legacy-conjectures/`](../../summary/14-legacy-conjectures/README.md) — the deduplicated conjecture index.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
