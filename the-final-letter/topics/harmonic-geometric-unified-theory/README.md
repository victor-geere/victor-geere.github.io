# Harmonic–Geometric Unified Theory plan — research programme

**Status:** plan only. This folder reconstructs the programme's elementary harmonic/Egyptian arithmetic and records the plan's analytic claims as open. It does **not** claim any part of the Harmonic–Geometric Unified Theory, the Spectral Riemann Hypothesis, or the Generalised Riemann Hypothesis as proved.
**Source:** [`archive/maths/research-programme.html`](../../archive/maths/research-programme.html) (dated May 2026).
**Inventory:** [Scraps](../../scraps.html) item 34 · [Topic index](../README.md).

## What the source is

The source is a three-year, seven-phase research *plan*:

| Phase | Title | Stated duration | Archived status |
|---|---|---|---|
| 1 | Foundational strengthening | 6–9 months | Proposed |
| 2 | Operator-theoretic completion | 9–12 months | Proposed |
| 3 | Spectral equivalence | 12–18 months | Proposed |
| 4 | Generalisation to Dirichlet L-functions | 12–15 months | Proposed |
| 5 | Categorical and topological lift | 15–24 months | Proposed |
| 6 | Numerical verification and heuristics | ongoing | In Progress |
| 7 | Final synthesis and publication | 18–30 months | Proposed |

Its overall goal is to "derive the Riemann zeta function and its generalizations from the greedy harmonic expansion of angles, and prove the Spectral Riemann Hypothesis together with its generalizations". The plan names the objects it intends to use — the Greedy Harmonic Tree, the Harmonic Sine Transform, the transfer operator `L_s`, Greedy–Egyptian Modular Tensor Categories, the Quantum–Egyptian Functional Equations — but gives **no definitions, lemmas, or proofs** for them. It also does not define the "greedy harmonic expansion of angles" or the "Egyptian" construction beyond their names.

The honest reconstruction is therefore small: formalise the elementary unit-fraction and harmonic arithmetic that the plan's terminology presupposes, check the plan's own duration/timeline arithmetic exactly, and leave every analytic claim in the source-claim/open tables. The companion topic [`greedy-harmonic-decomposition`](../greedy-harmonic-decomposition/README.md) reconstructs the angle expansion itself; this folder does not duplicate that work.

## Provenance and inventory

- Source page: [`archive/maths/research-programme.html`](../../archive/maths/research-programme.html).
- Inventory row: [`scraps.html`](../../scraps.html) item 34, "Harmonic–Geometric Unified Theory plan", tagged **plan only**.
- Related topic folders: [Greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md), [HST programme](../hst-programme/README.md), [QEFE](../qefe/README.md), [Topological zeta](../topological-zeta/README.md), [Greedy harmonic transfer operator](../greedy-harmonic-transfer-operator/README.md).

## Reconstructed objects and notation

The source does not define these objects. They are the minimal exact objects implicit in its harmonic/Egyptian vocabulary; all are defined in [`python/programme.py`](python/programme.py) and the first three in [`lean/Topic.lean`](lean/Topic.lean).

| Object | Definition | Role in the plan |
|---|---|---|
| Egyptian unit weight | `w n = 1/(n + 1)` | the `n`-th unit fraction of a greedy Egyptian expansion |
| Harmonic angle | `α n = π/(n + 2)` | the greedy harmonic angle named by the plan's "greedy harmonic expansion of angles" |
| Harmonic partial sum | `H N = Σ_{n<N} w n` | finite truncation of the harmonic/Egyptian series |
| Greedy Egyptian expansion | at each step take `q = ceil(1/r)`, replace `r` by `r − 1/q` | the "Greedy–Egyptian" construction named in Phase 5 |
| Phase table | the seven phases with their stated duration ranges and statuses | the plan's schedule |
| Timeline horizon | `3 × 12 = 36` months | the plan's three-year horizon |

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every **Computation** row has a test in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Every Egyptian unit weight is positive: `0 < w n`. | `HGU.egyptWeight_pos` |
| T2 | Theorem | The Egyptian weights are strictly decreasing: `w` is strictly antitone. | `HGU.egyptWeight_strictAnti` |
| T3 | Theorem | `w n → 0` as `n → ∞`, so the greedy remainder can be made arbitrarily small. | `HGU.egyptWeight_tendsto_zero` |
| T4 | Theorem | The rescaled harmonic angle is exact: `(n + 2) α n = π`. | `HGU.harmonicAngle_scaled` |
| T5 | Theorem | The harmonic sums satisfy `H (N+1) = H N + w N`. | `HGU.harmonicSum_succ` |
| T6 | Theorem | The harmonic sums are monotone: `H` is monotone. | `HGU.harmonicSum_mono` |
| T7 | Theorem | `H 4 = 1 + 1/2 + 1/3 + 1/4 = 25/12`. | `HGU.harmonicSum_four` |
| C1 | Computation | The weights are exact, strictly decreasing, and `w(−1)` is rejected. | `test_egyptian_weight_exact_and_edge` |
| C2 | Computation | `H 0 = 0`, `H 1 = 1`, `H 3 = 11/6`, `H 4 = 25/12`, and `H` is strictly increasing on the tested range. | `test_harmonic_sum_exact` |
| C3 | Computation | The greedy Egyptian expansion of `4/13` is `1/4 + 1/18 + 1/468`, exactly. | `test_greedy_egyptian_known_values` |
| C4 | Computation | For every non-trivial `k/17`, the first denominator is `ceil(1/r)`, the denominators strictly increase, and the expansion reconstructs `r` exactly. | `test_greedy_egyptian_is_greedy_and_distinct` |
| C5 | Computation | Edge cases: `0`, `1`, negative and `> 1` inputs are rejected; `1/7` terminates in one step; `63/64` reconstructs exactly. | `test_greedy_egyptian_edge_cases` |
| C6 | Computation | The stated phase durations total `(72, 108)` months, so the plan's maximum exceeds the `36`-month horizon and the phases must overlap. | `test_phase_table_arithmetic` |
| C7 | Computation | The milestone years cover phases 1–6 exactly once; Phase 7 is absent; `open_problems()` returns four non-empty strings with “Monotonicity” second. The source's stated ranking is not checked. | `test_milestones_and_open_problems` |

“All theorems are proved” means: T1–T7 have Lean declarations and C1–C7 have tests. The source's analytic claims are not in this count.

## Source claims (not promoted to theorems)

These are assertions of the archived plan. They are recorded with the source's status; none is proved or tested here.

| Claim | Source location | Archived status | Reconstruction note |
|---|---|---|---|
| The Riemann zeta function and its generalisations are derived from the greedy harmonic expansion of angles. | Overall Goal | Proposed programme | No derivation is given in the source; not formalised. |
| The Spectral Riemann Hypothesis is proved. | Overall Goal, Phase 3 | Proposed programme | Explicitly a target, not a result. Not formalised. |
| `L_s` is trace-class for `Re s > 1`, with explicit trace-norm bounds. | Phase 2 | Proposed | No operator definition or bound is given. Open. |
| `L_s` has a compact operator-valued analytic continuation for `Re s > 1/2`. | Phase 2 | Proposed | No proof. Open. |
| The periodic-orbit trace converts `ζ(2s+1)/ζ(2s)` into `ζ(s)/ζ(2s)`. | Phase 2 | Proposed | Source calls the gaps unfilled. Open. |
| The entire factor `e^{P(s)}` is zero-free in the critical strip. | Phase 2 | Proposed; source calls it "the weakest link" | Open. |
| The Fredholm determinant identity for the Greedy Harmonic Transfer Operator. | Phase 2 | Proposed paper | Open. |
| `det_(2)(I − L_{1/2+it}) = 0` iff `ζ(1/2 + it) = 0`. | Phase 3 | Proposed | This is the spectral equivalence target. Open. |
| The monotonicity inequality for the twisted operator `L_{s,χ}`. | Phase 4 | Proposed | The source states it as a conjecture to prove. Open. |
| The Generalised Riemann Hypothesis follows from the monotonicity conjecture. | Phase 4 | Proposed | Conditional on the conjecture; not a theorem. Open. |
| The Greedy–Egyptian Modular Tensor Categories can be constructed rigorously. | Phase 5 | Proposed | No construction is given. Open. |
| The Quantum–Egyptian Functional Equations (v1–v8) hold with analytic continuation. | Phase 5 | Proposed | Not formalised here; see the [QEFE topic](../qefe/README.md). |
| The monotonicity inequality can be verified numerically for the first 1000 zeros. | Phase 6 | In Progress | No numerical data or code is archived with this page. Open. |
| The full unified theory and its main conjectures can be published within three years. | Phase 7 | Proposed | A scheduling aspiration, not a mathematical claim. |

## Python layer

[`python/programme.py`](python/programme.py) implements:

- `egyptian_weight(n)` and `harmonic_sum(N)` — exact sympy rationals;
- `greedy_egyptian(r)` and `egyptian_total(denominators)` — exact greedy Egyptian expansion and its exact reconstruction;
- `phase_table()`, `phase_duration_totals()`, `timeline_months()`, `overlap_required()` — the plan's schedule arithmetic;
- `milestones()`, `open_problems()`, `phase_dicts()` — the plan's milestone and ranking data.

All arithmetic is exact `sympy.Rational`; no tolerance is used in the tests. Run:

```bash
cd the-final-letter/topics/harmonic-geometric-unified-theory && python3 -m pytest -q tests
```

Recorded result: **7 passed**.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, defines `HGU.egyptWeight`, `HGU.harmonicAngle`, and `HGU.harmonicSum`, and proves T1–T7 with no `sorry`, `axiom`, or `admit`. The file is deliberately small: the source supplies no analytic definitions to formalise.

```bash
cd the-final-letter/topics/harmonic-geometric-unified-theory && ./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log). The exact scope and the list of non-formalised claims are in [`lean/README.md`](lean/README.md).

## Open items and known gaps

1. **No analytic definitions in the source.** `L_s`, the Fredholm determinant, `P(s)`, the twisted operator, and the MTC data are named but never defined. Formalising any of them would require a source other than this plan.
2. **Spectral equivalence and Spectral RH.** The implication `det = 0 ↔ ζ(1/2+it) = 0` is the central target and is entirely open.
3. **Monotonicity inequality.** The Phase 4 inequality is stated without proof; GRH is conditional on it.
4. **Zero-free factor.** The source itself flags `e^{P(s)}` zero-freeness as the weakest link.
5. **Greedy–Egyptian categories and QEFE.** No construction or analytic continuation is supplied here.
6. **Schedule inconsistency.** The stated phase maxima total 108 months, while the milestone section proposes a 36-month horizon; the plan only works with heavy overlap. This is a planning observation (C6), not a mathematical result.
7. **The "harmonic/Egyptian" core is reconstructed, not quoted.** The source does not define `w n`, `α n`, or the greedy Egyptian algorithm. The formal core is the elementary arithmetic those names presuppose; it should not be read as a formalisation of the theory's analytic content.

## Verification

```bash
cd the-final-letter/topics/harmonic-geometric-unified-theory
python3 -m pytest -q tests
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
