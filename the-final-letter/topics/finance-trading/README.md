# Finance / trading ebooks — research programme

**Status:** reconstructed finite formal core + exact computation layer; the ebooks' market and modelling claims are preserved separately as source claims.  
**Source:** [`archive/ebooks/index.html`](../../archive/ebooks/index.html) — the ebooks index.  
**Inventory:** [Scraps](../../scraps.html) item 44 · [Topic index](../README.md).  
**Scope note:** this topic is **out of scope for the Riemann-hypothesis programme**. It is reconstructed on its own terms around one finite finance identity; no RH narrative is imposed.

## Provenance and what the source actually contains

The archived source is a 1.6 KB table of contents, not a paper. It lists fourteen entries (numbered with a duplicated `12`, no visible `14`, and one entry — “Coherence Resonance” — linking to `heston-model.html`). The mathematical content sits in the linked self-contained ebooks:

| Linked document | Content | Status of the document |
|---|---|---|
| [`math-rigour.html`](../../archive/ebooks/math-rigour.html) | Mathematical rigour: definitions, notation, proof conventions | Expository; entry 1 of the index |
| [`continuous-lattice.html`](../../archive/ebooks/continuous-lattice.html) | Binomial lattice, action sums, continuous-time/Malliavin sketch | Authored by “Grok 3, Built by xAI”; expository |
| [`fractional-kelly.html`](../../archive/ebooks/fractional-kelly.html) | Volatility drag, fractional Kelly, FX rebalancing | AI-generated long-form ebook; **unlisted in the source index** |
| [`volatility-drag.html`](../../archive/ebooks/volatility-drag.html) | The `μ/σ²` metric and the `g ≈ μ − σ²/2` approximation | AI-generated expository ebook |
| [`volatility-harvesting.html`](../../archive/ebooks/volatility-harvesting.html) | Summary of Rabault (2017), excess growth rate | Derivative summary of a third-party paper |
| `heston-model.html`, `optimal-exit.html`, `technical-indicators.html`, `dynamic-asset-allocation.html`, `risk-adjusted-returns.html`, `portfolio-theory.html`, `talagrand_probability.html`, `concentration-inequalities.html` | Catalogue entries | Listed only; no finite identity was extracted here |
| `talagrand_bounds_stochastic_processes.pdf` | Book, entry 11 | Not vendored (9.6 MB); the repository-root `archive/ebooks/` copy is canonical |

This is a catalogue of heterogeneous, largely AI-generated expository ebooks. It contains no unified definitions, no theorem numbering, no proofs, and no datasets. The reconstruction therefore does **not** adopt the ebooks' performance numbers, thresholds, or modelling claims. It extracts the one finite computation that `continuous-lattice.html` §3–§4 states completely, plus the exact two-point inequality behind the volatility-drag approximation.

## Reconstructed objects

The reconstruction keeps the source's notation and makes each object finite and exact.

| Object | Definition |
|---|---|
| Lattice node | `S k j = S₀ · u^j · d^(k−j)`, for `0 ≤ j ≤ k` |
| Binomial weight | `w k j(p) = C(k,j) · p^j · (1−p)^(k−j)` |
| Exposure | `a(S) = 1 / (S · ε)`, with `ε > 0` |
| Action | `f(S, a) = S · a = 1/ε` |
| Level action sum | `A k(p, ε) = Σ_{j=0}^{k} w k j(p) · f(S k j, a(S k j))` |
| Total action sum | `T n(p, ε) = Σ_{k=0}^{n} A k(p, ε)` |
| Two-point gross returns | `1 + r` and `1 − r`, each with probability `1/2` |
| Two-point log growth | `g(r) = ½ log((1+r)(1−r)) = ½ log(1−r²)` |
| Volatility drag approximation | `−σ²/2` with `σ² = r²` |

The finite identity at the centre of the programme is

\[
\sum_{j=0}^{k}\binom{k}{j}p^{j}(1-p)^{k-j}\cdot\frac{1}{\varepsilon}=\frac{1}{\varepsilon},
\qquad
T_n=\sum_{k=0}^{n}\frac{1}{\varepsilon}=\frac{n+1}{\varepsilon}.
\]

It is exactly the source's §4 computation: because `f(S,a) = S·a = 1/ε` is constant, the binomial sum collapses by the binomial theorem. The programme also proves the exact two-point drag inequality `g(r) < −r²/2` for `0 < r < 1`; this is the sharp finite counterpart of the source's approximation `g ≈ μ − σ²/2` in the case `μ = 0`, `σ² = r²`.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Binomial weights are non-negative for `0 ≤ p ≤ 1`. | `FinanceLattice.binomWeight_nonneg` |
| T2 | Theorem | The level-`k` binomial weights sum to `1`. | `FinanceLattice.sum_binomialWeight` |
| T3 | Theorem | Every lattice node value is positive when `S₀, u, d > 0`. | `FinanceLattice.nodeValue_pos` |
| T4 | Theorem | The action equals the constant `1/ε` when `S ≠ 0` and `ε ≠ 0`. | `FinanceLattice.action_eq_inv` |
| T5 | Theorem | The probability-weighted action sum on level `k` is `1/ε`. | `FinanceLattice.sum_lattice_action` |
| T6 | Theorem | The total action over `n + 1` levels is `(n+1)/ε`. | `FinanceLattice.total_action_sum` |
| T7 | Theorem | Two-point volatility drag: `½ log(1−r²) < −r²/2` for `0 < r < 1`. | `FinanceLattice.log_two_point_growth_lt` |
| C1 | Computation | Binomial weights take the stated rational values, including degenerate `p = 0, 1`. | `test_binomial_weight_values` |
| C2 | Computation | The weights sum to `1` exactly for rational `p` and `k ≤ 25`, and for the algebraic case `p = 2`. | `test_binomial_weights_sum_to_one` |
| C3 | Computation | The `k = 0`, `p = 0`, `p = 1` edge cases hold; out-of-range indices raise. | `test_binomial_identity_edge_cases` |
| C4 | Computation | The one-step node ratio is exactly `u/d`; tree values are exact rationals. | `test_node_value_and_lattice_ratio` |
| C5 | Computation | The action is exactly `1/ε` for every tested `S`; zero `S` or `ε` raises. | `test_action_is_constant_one_over_eps` |
| C6 | Computation | Level sums equal `1/ε` for `k ≤ 15` and total sums equal `(n+1)/ε` for `n ≤ 20`. | `test_level_and_total_action_sum` |
| C7 | Computation | Exact two-point log growth is strictly below `−r²/2`; its correction is `−r⁴/4 + O(r⁶)`. | `test_two_point_volatility_drag` |

“All theorems are proved” means exactly that T1–T7 have Lean declarations without `sorry`/`axiom`/`admit`, and C1–C7 have passing pytest tests. The source claims and open items below are **not** theorems of this reconstruction.

## Source claims (not promoted to theorems)

Every row in this section is a **Source claim**: it is recorded with the archived document's status and is not a theorem of the reconstruction.

| Claim | Source location | Status in the source | Reconstruction note |
|---|---|---|---|
| For `f(S,a) = e^{aS}`, the sum is a moment-generating function and a geometric series in `u, d, p`. | `continuous-lattice.html` §4 | Asserted, no closed form given | Not formalised: the source does not state the series precisely. |
| The binomial lattice converges to geometric Brownian motion / Black–Scholes as the step shrinks. | `continuous-lattice.html` §5 | Expository claim | Not formalised; no limiting theorem is stated or proved. |
| `S₀(e^{rT}−1)/r = ∫₀^T S₀ e^{rt} dt`. | `continuous-lattice.html` §5 | Asserted calculus identity | Elementary, but outside the chosen finite core; not formalised here. |
| Malliavin calculus yields option Greeks. | `continuous-lattice.html` §6 | Expository claim | No stochastic calculus is constructed. |
| Volatility drag `g ≈ μ − σ²/2`, exact for continuous-time GBM. | `volatility-drag.html` §2; `fractional-kelly.html` §2 | Approximation / modelling claim | T7 proves only the strict two-point inequality with `μ = 0`, `σ² = r²`; the general GBM statement is not formalised. |
| Kelly fraction `f* = μ/σ²` maximises `g`. | `volatility-drag.html` §2 | Asserted from a derivative | No optimisation is formalised; the source's derivation is informal. |
| `μ/σ²` thresholds (`> 2.0` excellent, `0.2–0.5` weak, etc.) and the asset table. | `volatility-drag.html` §3 | Editorial/empirical claims | Not reproduced; the archive contains no supporting dataset. |
| Fractional Kelly and dynamic Kelly scaling improve growth by 5–15%. | `fractional-kelly.html` §3 | Simulation/editorial claim | Not formalised and not independently tested. |
| Heston, optimal exit, technical indicators, dynamic allocation, Talagrand, concentration inequalities. | Index entries 3–13 | Catalogue entries | Link labels only; no statement was extracted or reconstructed. |

No archived claim about market performance is presented as a theorem. Nothing in this folder concerns the Riemann hypothesis, GRH, twin primes, Chowla, Sarnak, or Elliott.

## Open / conjecture

Every row in this section is an **Open / conjecture** item: it has no Lean proof and no test in this folder.

| # | Open / conjecture | Why it is open here |
|---|---|---|
| O1 | Prove the binomial-lattice convergence to GBM (a Donsker/CLT statement) with explicit hypotheses on `u, d, p`. | The source only sketches this; a rigorous limit theorem needs a probability space and a mode of convergence. |
| O2 | Determine the exact finite-`n` correction to volatility drag for the `n`-step lattice, not just the two-point case. | T7 handles one step and one pair of outcomes; the general finite-`n` expansion is not stated in the source. |
| O3 | Prove Kelly optimality `f* = μ/σ²` for a general return distribution, and justify fractional Kelly. | The source gives a one-variable derivative for a simple model; no general optimisation or risk constraint is formalised. |
| O4 | Validate the `μ/σ²` threshold table and the 5–15% dynamic-Kelly improvement empirically. | The archive contains no data or reproducible experiment; the numbers are editorial. |
| O5 | Establish a canonical catalogue: resolve the duplicate `12`, the mislabelled “Coherence Resonance” link, and the unlisted ebooks (`fractional-kelly.html`, `random-walk-lattice.html`, etc.). | This is an editorial gap in the source index, not a mathematical one. |

## Python layer

[`python/programme.py`](python/programme.py) implements exact sympy arithmetic:

- `binomial_weight(p, k, j)` and `binomial_sum(p, k)`;
- `node_value(S0, u, d, k, j)`;
- `action(S, eps)`, `level_action_sum(...)`, `total_action_sum(n, eps, p)`;
- `two_point_log_growth(r)` and `two_point_drag_approx(r)`.

Inputs are validated; out-of-range indices, `S = 0`, `ε = 0`, `n < 0`, and `r ∉ (0,1)` raise `ValueError`. The module imports without side effects. Tests are exact except for stated high-precision comparisons (`sp.N(..., 40)`).

Run the tests from the topic folder:

```bash
cd the-final-letter/topics/finance-trading
python3 -m pytest -q tests
```

Current result: **7 passed**.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens `namespace FinanceLattice`, and proves T1–T7 with elementary order, field, binomial-theorem, and logarithm facts. It defines `binomWeight`, `nodeValue`, and `action`.

```bash
cd the-final-letter/topics/finance-trading
./lean/check.sh
```

The wrapper calls the shared [`tools/check-lean.sh`](../tools/check-lean.sh). Recorded build: [`lean/BUILD.log`](lean/BUILD.log).

## Limits of the reconstruction

1. The source is an index, and its mathematical pages are expository AI-generated ebooks. The formal core is correspondingly small: one finite lattice identity and one two-point inequality.
2. The reconstruction deliberately does **not** formalise stochastic calculus, Heston dynamics, optimal stopping, or portfolio theory. Those are catalogue entries, not statements in the archive.
3. The volatility-drag theorem T7 is a strict inequality for the simplest symmetric two-point lattice. It does not assert the general approximation `g ≈ μ − σ²/2`, and it does not justify any trading strategy.
4. No empirical claim in the ebooks is verified; no dataset ships with the archive.

## Provenance

- [`archive/ebooks/index.html`](../../archive/ebooks/index.html) — the archived index.
- [`archive/ebooks/continuous-lattice.html`](../../archive/ebooks/continuous-lattice.html) — source of the lattice action computation.
- [`archive/ebooks/volatility-drag.html`](../../archive/ebooks/volatility-drag.html) — source of the `μ/σ²` and volatility-drag discussion.
- [`scraps.html`](../../scraps.html) — inventory item 44.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
