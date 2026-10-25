# Greedy Dirichlet Sub-Sum Transform (GDST) — research programme

**Status:** reconstructed finite formal core + exact computation layer; the archived global RH claim is preserved as a source claim, not promoted.  
**Source:** [`archive/maths/rh/research/gdst/rh-proof/proof.html`](../../archive/maths/rh/research/gdst/rh-proof/proof.html) — a walk-through of the Isabelle file `GDST_Riemann_Hypothesis.thy`.  
**Inventory:** [Scraps](../../scraps.html) item 9 · [Topic index](../README.md).  
**Overlaps:** [GDST twin series](../gdst-twin-series/README.md) (item 24), [Theorems / paper series](../theorems-paper-series/README.md) (item 32), and the [greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) pilot (item 11).

## Provenance and status

The archived source is a long, generated HTML walk-through of an Isabelle development. It presents a five-part argument: a greedy harmonic expansion on `[0,1]`, a correlation kernel built from its digits, the GDST Dirichlet sub-series `E(θ,s)`, a Ruelle transfer operator with a Fredholm-determinant identity, and a spectral/Jacobi-matrix construction intended to force `Re(ρ) = 1/2`.

The document itself lists the assumptions it uses in an **Axiom Registry** (AX1–AX6, `AX_tr`, `AX_zm`, `correction_bound`, `Hadamard_pair_bound`, and others). It also **retracts AX5**, an earlier closed form for the diagonal kernel, because that formula becomes negative at `n = 0`. The global Riemann Hypothesis statement is therefore conditional on a substantial list of analytic and operator-theoretic assertions, several of which are not proved in the source. This reconstruction records it as an *archived claim*. It does **not** claim that RH, GRH, twin primes, Chowla, Sarnak or Elliott has been proved.

What is genuinely elementary and source-defined is the finite greedy recursion of Part I and the finite selected/rejected split of Part III. That is the formal core below.

## Objects and notation

| Object | Definition |
|---|---|
| Harmonic fraction | `α n = 1/(n+2)` on `[0,1]` |
| Digit at zero | `δ 0(x) = 1` iff `x ≥ 1/2 = α 0`, else `0` |
| Digit at `n+1` | `δ (n+1)(x) = 1` iff `r n(x) ≥ 1/(n+3) = α (n+1)`, else `0` |
| Remainder | `r 0(x) = x − δ 0(x)/2`, `r (n+1)(x) = r n(x) − δ (n+1)(x)/(n+3)` |
| Finite selected sum | `E_N(x,s) = Σ_{k≤N, δ k(x)=1} (k+2)^(−s)` |
| Finite rejected sum | `Ω_N(x,s) = Σ_{k≤N, δ k(x)=0} (k+2)^(−s)` |
| Dirichlet prefix | `D_N(s) = Σ_{k≤N} (k+2)^(−s)` |
| Angle lift | `θ ∈ [0,π]` with `x = θ/π`; the source writes `δ n(θ) = δ n(θ/π)` |
| Centred digit | `f n(θ) = δ n(θ) − θ/π` |
| Correlation kernel | `K(n,m) = ∫_0^π f n(θ) f m(θ) dθ` |
| GDST series | `E(θ,s) = Σ_{δ n(θ)=1} (n+2)^(−s)`, `Ω(θ,s)` the complement |

## Theorem ledger

Every row marked **Theorem** has a declaration in [`lean/Topic.lean`](lean/Topic.lean) proved with no `sorry`, `axiom` or `admit`. Every row marked **Computation** has an exact test in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Every greedy digit is binary: `δ n(x) = 0 ∨ δ n(x) = 1`. | `GDST.delta_zero_or_one` |
| T2 | Theorem | The remainder is non-negative for `x ≥ 0`: `0 ≤ r n(x)`. | `GDST.rem_nonneg` |
| T3 | Theorem | On `[0,1]`, `r n(x) ≤ 1/(n+2)`. | `GDST.rem_bound` |
| T4 | Theorem | Finite partial-sum identity: `x = Σ_{k≤N} δ k(x)/(k+2) + r N(x)`. | `GDST.finite_identity` |
| T5 | Theorem | Post-selection bound: if `x ≤ 1` and `δ (n+1)(x) = 1`, then `r (n+1)(x) ≤ 1/((n+2)(n+3))`. | `GDST.rem_after_selection` |
| T6 | Theorem | Finite selected/rejected split: `E_N(x,s) + Ω_N(x,s) = D_N(s)`. | `GDST.selected_add_rejected` |
| T7 | Theorem | Both finite sums are non-negative: `0 ≤ E_N(x,s)` and `0 ≤ Ω_N(x,s)`. | `GDST.selected_rejected_nonneg` |
| C1 | Computation | `α 0 = 1/2`, `α 1 = 1/3`, `α 3 = 1/5`; negative indices are rejected. | `test_alpha_values_and_edge_cases` |
| C2 | Computation | The finite partial-sum identity has zero exact residual for rational targets and `N` up to `50`. | `test_finite_partial_sum_identity_exact` |
| C3 | Computation | `0 ≤ r N(x) ≤ 1/(N+2)` on an exact rational grid. | `test_remainder_bounds_and_post_selection_bound` |
| C4 | Computation | The post-selection quadratic bound holds whenever a selection occurs. | `test_remainder_bounds_and_post_selection_bound` |
| C5 | Computation | `E_N(x,s) + Ω_N(x,s) = D_N(s)` exactly for integer `s` and `N ≤ 30`. | `test_selected_rejected_split_exact` |
| C6 | Computation | The selected and rejected finite weights are non-negative. | `test_selected_and_rejected_weights_are_nonnegative` |
| C7 | Computation | The source's non-monotonicity witness: `δ 1(2/5) = 1` but `δ 1(3/5) = 0`. | `test_digit_non_monotonicity_counterexample` |
| C8 | Computation | The retracted AX5 formula gives `−π/24` at `n = 0`, while the actual kernel value is `K(0,0) = π/12`. | `test_retracted_ax5_formula_is_negative_at_zero` |

## Source claims (not promoted)

These are assertions made by the archived document. They are recorded with the source's status and are **not** Lean theorems here.

| # | Claim | Source status | Reconstruction note |
|---|---|---|---|
| S1 | Greedy harmonic expansion: every `x ∈ [0,1]` satisfies `x = Σ_n δ n(x)/(n+2)`. | Source theorem, from the finite identity and `r N → 0` | The finite identity T4 is formalised; the limit and the convergence of the remainder are not. |
| S2 | Selected indices grow super-exponentially: `n_{k+1} ≥ n_k(n_k − 1)`. | Source theorem | Not formalised. Would need a formal sequence of selected indices and the post-selection bound. |
| S3 | The correlation kernel `K(n,m)` is symmetric and positive semidefinite. | Source theorem, by writing the quadratic form as `∫ (Σ a_n f_n)^2` | Not formalised; the Lean core does not define the integral kernel or the angle lift. C8 checks only the single `K(0,0)` value. |
| S4 | The GDST series `E(θ,·)` is holomorphic on `Re(s) > 0`, and `ζ(s) − 1 = E(θ,s) + Ω(θ,s)` for `Re(s) > 1`. | Source theorem | The finite split T6 is formalised. Holomorphy and the infinite identity are not. |
| S5 | Fredholm determinant identity `det_(2)(I − L_s) = ζ(s)/ζ(2s) · e^{P(s)}`. | Source theorem, conditional on AX1–AX4 | Not formalised; depends on the transfer-operator axioms. |
| S6 | The regularised Stieltjes transform has poles exactly at translates of the non-trivial zeros; the support of `μ_σ` equals the translated zero set. | Source theorem, conditional on AX6, `AX_tr`, `AX_zm` and error bounds | Not formalised. The source's own Axiom Registry lists these as assumptions. |
| S7 | `J_{1/2}` is self-adjoint, hence its spectrum is real, hence `Re(ρ) = 1/2` for every non-trivial zero. | Source claim of the global theorem | **Archived claim only.** The implication is conditional on AX6f–g and on the spectral-support identification; it is not a theorem of this reconstruction. |
| S8 | AX5: `K(n,n) = π/12 · (1 − 3/(n+2))`. | **Retracted by the source** | C8 reproduces the failure: at `n = 0` the formula is `−π/24`, not `π/12`. |

## Open items and gaps

1. **Formalise the limit of the greedy expansion (S1).** The finite identity and the remainder bound are in Lean; the passage `r N → 0` and the infinite sum are not. A Lean proof would need a topology of finite partial sums and the squeeze argument.
2. **Formalise the angle lift and the correlation kernel (S3).** This requires interval integrals of step functions on `[0,π]`, the definition `f n(θ) = δ n(θ/π) − θ/π`, and a finite Gram quadratic-form argument. The kernel is the bridge to the source's spectral construction.
3. **Audit the transfer-operator axioms (S5–S6).** AX1–AX4, `AX_tr`, `AX_zm`, `correction_bound` and `Hadamard_pair_bound` are assumptions in the source. Whether they are true as stated, and whether the Fredholm identity follows without them, are open audit questions.
4. **The final RH step (S7).** Even granting the spectral-support identification, the source's conclusion depends on the self-adjointness axiom AX6f and on `spectrum(J_σ) = supp μ_σ` (AX6g). These have not been derived from the greedy construction here. The global RH claim therefore remains archived and conditional.
5. **Super-exponential growth (S2).** The arithmetic core `n(n−1) ≥ n` for `n ≥ 2` is elementary, but the selection-history induction is not formalised.

## Python layer

[`python/programme.py`](python/programme.py) uses `sympy` for exact rational arithmetic. It implements:

- `alpha(n)`, `greedy_trajectory(x, n_max)`, `greedy_digits`, `greedy_remainders`;
- `partial_sum(x, N)` and `finite_identity_residual(x, N)`;
- `selected_weight(x, s, N)`, `rejected_weight(x, s, N)`, `dirichlet_prefix(s, N)`;
- `remainder_bound_holds(x, N)`, `post_selection_bound_holds(x, n)`;
- `ax5_diagonal(n)`, `K00_integral()`, `non_monotone_counterexample()`.

Run the exact tests:

```bash
python3 -m pytest the-final-letter/topics/gdst/tests -q
```

Current result: **8 passed**. The suite is exact and finishes in well under a second.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, defines `alpha`, `digit0`, `nextDigit`, `state`, `delta`, `rem`, `dirichletPrefix`, `selectedWeight` and `rejectedWeight`, and proves T1–T7. There is no `sorry`, `axiom` or `admit`.

```bash
the-final-letter/topics/gdst/lean/check.sh
```

The shared checker is [`../tools/check-lean.sh`](../tools/check-lean.sh), using the local Mathlib installation at `~/lean/mathlib4`. Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

See [`lean/README.md`](lean/README.md) for the exact statement-to-declaration map and for what is deliberately not formalised.

## Provenance and links

- Archived source: [`proof.html`](../../archive/maths/rh/research/gdst/rh-proof/proof.html), with companion `gdst_visualise.py`, `test_k_corr.py`, and the Isabelle/AFP material in the same directory.
- Inventory entry: [Scraps](../../scraps.html) item 9.
- Topic index: [`topics/README.md`](../README.md).
- The pilot dossier that this folder follows: [greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md).
- Programme standard: [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
