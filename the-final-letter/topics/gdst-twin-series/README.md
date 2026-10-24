# GDST twin series — research programme

**Status:** reconstructed finite formal core + exact computation layer. The
archived programme's infinite analytic claims and its Riemann-hypothesis
characterisation are preserved as source claims, not promoted to theorems.

**Source:** [`archive/maths/gdst-twin-series/gdst-twin-series.html`](../../archive/maths/gdst-twin-series/gdst-twin-series.html)
(LaTeX: [`gdst-twin-series.tex`](../../archive/maths/gdst-twin-series/gdst-twin-series.tex)).

**Inventory:** [Scraps](../../scraps.html) item 24 · [Topic index](../README.md).
**Related inventory entry:** [item 9, GDST](../gdst/README.md) — the foundational
paper cited by this programme.

## What the source is

The archived paper is a **research programme**, not a proof paper. It defines
the Greedy Dirichlet Sub-Sum Transform (GDST) twin series — a *selected*
series `E(θ,s)` and a *rejected* series `Ω(θ,s)` — from the greedy harmonic
digits `δ_n(θ)`, and sets out four phases of open problems around them.

The paper is explicit that it "does not claim a proof of the Riemann
Hypothesis". Its central "Theorem 1.1 (RH Equivalence)" is quoted from a
companion foundational paper and is described as an equivalence to be
investigated; it is not proved in the archived programme and it is not proved
here. The related foundational paper is inventoried separately as item 9.

The source folder also contains
[`gdst-programme-results.tex`](../../archive/maths/gdst-twin-series/gdst-programme-results.tex)
(the foundational-results paper),
[`gdst-riemann-siegel-hybrid.tex`](../../archive/maths/gdst-twin-series/gdst-riemann-siegel-hybrid.tex)
(a hybrid Riemann–Siegel model),
[`gdst-animation.html`](../../archive/maths/gdst-twin-series/gdst-animation.html),
and [`gdst-twin-series.pdf`](../../archive/maths/gdst-twin-series/gdst-twin-series.pdf).
Only the twin-series programme paper is reconstructed in this folder. The
claims of the accompanying papers are not audited or adopted here.

## Reconstructed objects

Let `θ ∈ [0, π]`, let `x = θ/π`, and let the greedy harmonic fractions be
`α_n = π/(n+2)`. The greedy digits are defined by the residual recursion

```
ρ_0 = x,     δ_n(θ) = 1 iff ρ_n ≥ 1/(n+2),     ρ_{n+1} = ρ_n − δ_n(θ)/(n+2).
```

Equivalently, in angle form, `δ_n(θ) = 1` iff the residual angle is at least
`α_n`. The reconstruction works with the following finite prefixes of `N`
terms (`n = 0, …, N−1`):

| Object | Definition |
|---|---|
| Dirichlet weight | `term n s = (n+2)^(-s)` |
| Selected prefix | `E_N(θ,s) = Σ_{n<N, δ_n(θ)=1} (n+2)^(-s)` |
| Rejected prefix | `Ω_N(θ,s) = Σ_{n<N, δ_n(θ)=0} (n+2)^(-s)` |
| Full prefix | `H_N(s) = Σ_{n<N} (n+2)^(-s)` |
| Infinite twins | `E(θ,s), Ω(θ,s)` — the `N → ∞` limits, source claims only |

The **finite complement identity** `E_N(θ,s) + Ω_N(θ,s) = H_N(s)` is the exact
combinatorial core. It holds for every binary selection word, not only for
greedy digits; the greedy rule enters through the Python computation of
`δ_n(θ)`. The source's infinite identity `E + Ω = ζ(s) − 1` requires
convergence on `Re s > 0` and is not formalised.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is
tested in [`tests/test_programme.py`](tests/test_programme.py). Source claims
and open items are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Every weight is positive: `0 < term n s` for `term n s = (n+2)^(-s)`. | `GDSTTwin.term_pos` |
| T2 | Theorem | The selected prefix is non-negative: `0 ≤ E_N(s)`. | `GDSTTwin.selected_nonneg` |
| T3 | Theorem | The rejected prefix is non-negative: `0 ≤ Ω_N(s)`. | `GDSTTwin.rejected_nonneg` |
| T4 | Theorem | Finite complement identity: `E_N(s) + Ω_N(s) = H_N(s)` for every binary word `δ`. | `GDSTTwin.selected_add_rejected` |
| T5 | Theorem | The selected prefix is bounded by the full prefix: `E_N(s) ≤ H_N(s)`. | `GDSTTwin.selected_le_partialZeta` |
| T6 | Theorem | At `s = 0` every weight is `1`, so `H_N(0) = N` (the prefix over `N` indices). | `GDSTTwin.partialZeta_zero` |
| C1 | Computation | `θ = 0` gives the all-zero word; `θ = π` starts with `δ_0 = 1`; negative indices are rejected. | `test_greedy_digits_edge_values` |
| C2 | Computation | The finite complement residual is exactly zero for symbolic `s`, several `θ`, and `N ∈ {1,2,6,12}`. | `test_finite_complement_identity_symbolic` |
| C3 | Computation | At `s = 0`, `E_N + Ω_N = N` and equals the number of selected plus rejected indices. | `test_complement_at_s_zero_counts_indices` |
| C4 | Computation | At `s = 1`, `E_N + Ω_N` equals the exact rational harmonic prefix `Σ 1/(n+2)`. | `test_complement_is_exact_harmonic_prefix_at_s_one` |
| C5 | Computation | `E_N, Ω_N ≥ 0` and `E_N ≤ H_N` on a grid of `θ` and `s` values. | `test_selected_prefix_is_nonnegative_and_bounded` |
| C6 | Computation | Invalid negative indices raise `ValueError`. | `test_invalid_weight_index_raises` |

## Source claims (not promoted to theorems)

These are assertions of the archived programme and its cited companion paper.
They are recorded with their source status; none is proved in this folder.

| # | Claim | Source status | Reconstruction note |
|---|---|---|---|
| S1 | For every `θ ∈ [0,π]`, `E(θ,s)` and `Ω(θ,s)` converge conditionally and are holomorphic on `Re s > 0`. | Source theorem (foundational paper, item 9) | The finite prefixes are formalised; no convergence or holomorphy is proved here. |
| S2 | `E(θ,s) + Ω(θ,s) = Σ_{n≥0}(n+2)^(-s) = ζ(s) − 1` for `Re s > 0`. | Source identity | Finite identity T4 is proved; the infinite limit and `ζ` are not formalised. |
| S3 | On `s = 1/2 + it`, both series have at most linear growth in `∣t∣`. | Source analytic fact (foundational paper) | Not formalised or numerically certified here. |
| S4 | `E(θ,1/2+it) = −Ω(θ,1/2+it) + O(∣t∣^{1/6+ε})`. | Source cancellation claim | Depends on S1/S2 and a convexity bound; not proved here. |
| S5 | **RH equivalence (source Theorem 1.1):** all non-trivial zeros of `ζ` lie on `Re s = 1/2` iff for every `s` with `0 < Re s < 1`, `Re s ≠ 1/2`, and every `θ ∈ [0,π]`, `Re E(θ,s) ≠ −1/2`. | Source theorem, quoted from the foundational paper | **Not a theorem of this reconstruction.** The archived paper does not prove it, and this folder neither proves nor refutes it. |
| S6 | At a zero `ρ`, `E(θ,ρ) + Ω(θ,ρ) = −1`; at `θ = π`, `Re E(π,ρ) ≤ −1`, so a balance angle exists by an intermediate-value argument. | Source proof sketch | The source itself flags that regulated functions need not be Darboux; the argument is incomplete. Not formalised. |
| S7 | `E` is sparse (digit density zero) and `Ω` is co-sparse (density one). | Source claim | Not formalised; no density theorem is asserted. |

## Open and conjectural items

| # | Open item | Status |
|---|---|---|
| O1 | Decide the source's RH characterisation S5. | Open; the central open problem of the programme. |
| O2 | Natural boundary: is `Re s = 0` a natural boundary for `E` and `Ω` for almost all `θ`? | Open Problem 3.1 / F2. |
| O3 | Determine the true vertical growth and mean-square `∫_0^T ∣E(θ,1/2+it)∣² dt` asymptotics. | Open Problem 3.2 / A3. |
| O4 | Uniqueness, monotonicity, and distribution of balance angles `θ_bal(ρ)`. | Open Problem 5.1 / Z7. |
| O5 | Existence and tree representation of the digit autocorrelation `R_m(θ)`. | Open Problem 4.1 / C5. |
| O6 | A central limit theorem for `E(θ,1/2+it)` in the `t`-aspect. | Open Problem 4.2 / C6. |
| O7 | An explicit formula expressing `E(θ,s)` through the von Mangoldt function and primes. | Open Problem 5.2 / Z8. |
| O8 | Classify the `θ` for which `δ_n(θ)` is eventually periodic. | Foundational Problem F1 (item 9). |
| O9 | Bounded variation of `B_s(θ)` for `Re s > 2`, and the behaviour of `B_s` in the critical strip. | Open Problem 3.3 / A4. |

## Python layer

[`python/programme.py`](python/programme.py) implements the greedy digits and
the exact finite prefixes with sympy:

- `alpha(n)` — the harmonic fraction `π/(n+2)`;
- `greedy_digits(theta, n_max)` — exact greedy word, with a 60-digit fallback;
- `term(n, s)`, `partial_zeta(s, n_max)`;
- `selected_sum(theta, s, n_max)`, `rejected_sum(theta, s, n_max)`;
- `complement_residual(theta, s, n_max)` — the exact residual `E_N + Ω_N − H_N`;
- `count_selected`, `selected_fraction`.

Run the tests from the topic folder:

```bash
cd the-final-letter/topics/gdst-twin-series
python3 -m pytest -q tests
```

Current result: **6 passed** (about 3 seconds). The tests use exact sympy
arithmetic, with a `1e-25` numerical tolerance only for the displayed
inequality checks in C5.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and defines, in namespace
`GDSTTwin`:

- `term n s = (n+2)^(-s)`;
- `partialZeta s N`, `selected δ s N`, `rejected δ s N` for an arbitrary
  binary word `δ : ℕ → Bool`.

It proves T1–T6. The complement identity T4 is the finite, word-level core;
it does not assume that `δ` is greedy. No `sorry`, `axiom`, or `admit` occurs.

```bash
cd the-final-letter/topics/gdst-twin-series
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK   Topic.lean`.
See [`lean/README.md`](lean/README.md) for what is and is not formalised.

## Open items and known gaps

1. **Infinite convergence and `ζ`.** The step from `H_N` to `ζ(s) − 1`, and
   from the finite twins to `E` and `Ω`, is not formalised. It needs the
   source's summation-by-parts argument and a treatment of the limit.
2. **RH equivalence.** The source's Theorem 1.1 is an archived claim, not a
   theorem. No Lean declaration or pytest test asserts it. In particular this
   folder does **not** claim the Riemann hypothesis, GRH, twin primes, Chowla,
   Sarnak, or Elliott.
3. **Greedy-specific formal content.** T4 holds for every binary word. The
   genuine greedy recursion (residual bounds, threshold structure) is in the
   related [item 9 folder](../gdst/README.md); this folder deliberately keeps
   the twin-series complement as its formal core.
4. **Balance-angle argument.** The source's existence proof invokes an
   intermediate-value property for a limit of step functions; the source
   itself notes that regulated functions need not be Darboux. The gap is
   recorded as S6/O4, not repaired here.
5. **Companion papers.** The results paper and the Riemann–Siegel hybrid are
   not audited. Their stronger analytic and numerical claims are outside the
   scope of this reconstruction.

## Provenance

- [Twin-series programme paper (HTML)](../../archive/maths/gdst-twin-series/gdst-twin-series.html)
  and [LaTeX source](../../archive/maths/gdst-twin-series/gdst-twin-series.tex).
- [Programme results paper](../../archive/maths/gdst-twin-series/gdst-programme-results.tex),
  [Riemann–Siegel hybrid note](../../archive/maths/gdst-twin-series/gdst-riemann-siegel-hybrid.tex),
  [animation](../../archive/maths/gdst-twin-series/gdst-animation.html),
  [PDF](../../archive/maths/gdst-twin-series/gdst-twin-series.pdf).
- [Scraps inventory](../../scraps.html) item 24; related item 9, [GDST](../gdst/README.md).
- [Topic index](../README.md) · [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
