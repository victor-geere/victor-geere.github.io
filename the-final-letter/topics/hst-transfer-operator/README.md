# HST transfer operator — O5 finite reconstruction

**Status:** finite reconstruction and exact computation layer. The greedy map,
inverse branches, archived two-branch operator, finite truncations, infinite
limit, linearity and operator bounds are Lean-proved. Trace-classness, the
Fredholm determinant and the determinant identity are **not** proved.

**Source:** [`harmonic-sine-transform.tex`](../../archive/maths/rh/research/harmonic-sine-transform/harmonic-sine-transform.tex)
and [`hst-further-research-results.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research-results.tex).
**Parent programme:** [`harmonic-sine-transform`](../harmonic-sine-transform/README.md).
**Topic index:** [`../README.md`](../README.md).

## Why this topic exists

The parent dossier closed O1/F2/F4/O3 and built the finite HST core, but left the
analytic O5 operator open. This topic isolates that work: it fixes the greedy
map, records the source defects that affect it, and builds the finite operator
core that any future trace-class or Fredholm argument must start from.

No Riemann-hypothesis or GRH claim is made.

## Reconstructed objects

| Object | Definition | Lean name |
|---|---|---|
| Normalised greedy map | `T_n(x) = (1+1/(n+2))(x − 1_{x≥1})` | `greedyT` |
| Zero branch | `y ↦ y/(1+1/(n+2))` | `branch0` |
| One branch | `y ↦ y/(1+1/(n+2)) + 1` | `branch1` |
| Weight | `w_{n,k} = (n+1)/(n+2)^k` | `weight` |
| Finite operator | `L_N f(y) = Σ_{n<N} w_{n,k}[f(γ_{n,1}y)+f(γ_{n,2}y)]` | `greedyL` |
| Infinite operator | `L f(y) = Σ_{n≥0} w_{n,k}[f(γ_{n,1}y)+f(γ_{n,2}y)]` | `greedyLInf` |

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean). Every
**Computation** row has a test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `T_n(0)=0`. | `HSTTransfer.greedyT_zero` |
| T2 | Theorem | `T_n(1)=0`. | `HSTTransfer.greedyT_one` |
| T3 | Theorem | The zero branch is a right inverse on `y < 1+1/(n+2)`. | `HSTTransfer.greedyT_branch0` |
| T4 | Theorem | The one branch is a right inverse on `y ≥ 0`. | `HSTTransfer.greedyT_branch1` |
| T5 | Theorem | The branches recover `x` on `x<1` and `x≥1`. | `HSTTransfer.greedyT_branch_partition` |
| T6 | Theorem | The finite operator is additive in `f`. | `HSTTransfer.greedyL_add` |
| T7 | Theorem | The finite operator is homogeneous in `f`. | `HSTTransfer.greedyL_smul` |
| T8 | Theorem | The finite operator on constants is `2c Σ w`. | `HSTTransfer.greedyL_const` |
| T9 | Theorem | The `k=1` weight series diverges. | `HSTTransfer.weight_one_not_summable` |
| T10 | Theorem | The weights are summable for `k ≥ 3`. | `HSTTransfer.weight_summable` |
| T11 | Theorem | Finite operator bound `|L_N f| ≤ C·2Σ_{n<N} w`. | `HSTTransfer.greedyL_abs_le` |
| T12 | Theorem | Branch terms are summable for bounded `f`, `k ≥ 3`. | `HSTTransfer.summable_greedyL_term` |
| T13 | Theorem | Finite truncations converge to `L`. | `HSTTransfer.greedyL_tendsto` |
| T14 | Theorem | `L 0 = 0` and `L(−f) = −L f`. | `HSTTransfer.greedyLInf_zero`, `HSTTransfer.greedyLInf_neg` |
| T15 | Theorem | Infinite operator bound `|L f| ≤ C·2Σ' w` for `k ≥ 3`. | `HSTTransfer.greedyLInf_abs_le` |
| C1 | Computation | Both branches are exact right inverses. | `test_branch_inverses_exact` |
| C2 | Computation | The `k=1` weight is at least `1/2` for `n<100`. | `test_k_one_weight_at_least_half` |
| C3 | Computation | Constant action equals the direct branch sum. | `test_constant_action_matches_direct_sum` |
| C4 | Computation | `k=3` weights decrease; the first tail is exact. | `test_weight_k3_decreasing_and_tail` |
| C5 | Computation | `T_n(0)=T_n(1)=0`. | `test_greedy_map_endpoints` |

## Source defects carried in

- **R17:** the corpus gives two different `L_s` descriptions; neither is derived
  from the digit map. The finite formula used here is the archived two-branch
  sum, not a canonical operator.
- **R18:** the source's displayed `T` uses scaling `(n+2)/(n+1)` and threshold
  `1/(n+2)`; the actual normalised remainder uses `(n+3)/(n+2)` and threshold
  `1`. At `n=0` the source map sends `1` to `1`, the actual map sends `1` to `0`.

## Cross-topic support (authorised)

The following finite HP/CCM results are recorded as supporting material for a
future O7 attempt, not imported as O5 theorems:

- [`greedy-harmonic-hilbert-polya`](../greedy-harmonic-hilbert-polya/README.md):
  local quadratics and Galerkin eigenvalues, T1–T7.
- [`harmonic-categorical-hilbert-polya`](../harmonic-categorical-hilbert-polya/README.md):
  finite transfer matrix and determinant, T1–T6.
- [`self-adjoint-ccm`](../self-adjoint-ccm/README.md): finite Hermitian
  compression, T8–T11; its constant-matching spectrum is a lattice and is
  explicitly excluded by `WEIL-BRIDGE.md`.

**R14 resolution.** The “greedy–MTC bijection” passage in
`hst-further-research.tex` is a research question; the results paper proves no
literal bijection exists while preserving branching. The categorical branch may
use only the transfer-operator route, not a tree bijection.

## What is not formalised

- Trace-classness on `H²(𝔻)` or a weighted `L²` space.
- The Fredholm determinant and `det(I − L_s) = ζ(s)/ζ(2s)e^{P(s)}`.
- Meromorphic continuation to `Re s > 1/2`.
- The explicit formula and weights.
- Any self-adjoint or Hilbert–Pólya statement.

These are recorded as source claims or open items, not theorems.

## Python layer

Exact rational functions: `branch0`, `branch1`, `greedy_map`, `weight`,
`weight_sum`, `constant_action`, `weight_one_lower`.

```bash
python3 -m pytest tests -q
./lean/check.sh
```

Recorded result: **6 passed**; Lean core OK.

## Open items

| # | Kind | Statement |
|---|---|---|
| O1 | Open | Define the operator on a Banach/Hardy space and prove trace-classness for `Re s > 1`. |
| O2 | Open | Prove the Fredholm determinant identity with an explicit entire factor `P(s)`. |
| O3 | Open | Extend to `Re s > 1/2` with Hilbert–Schmidt estimates. |
| O4 | Open | Construct the HST test-function class and weights for the explicit formula. |
| O5 | Open | Any self-adjoint spectral/Hilbert–Pólya realisation. |
