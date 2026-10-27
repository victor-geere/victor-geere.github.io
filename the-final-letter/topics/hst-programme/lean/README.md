# Lean layer — what is and is not formalised

`Topic.lean` is the formal core of the finite greedy harmonic recursion that
the HST landing page and its Programme I use. It imports Mathlib, lives in the
namespace `HST`, and contains **no `sorry`, `axiom`, or `admit`**.

## Formalised

| Lean name | Statement |
|---|---|
| `HST.d` | The normalised harmonic fraction `d n = 1/(n+2)`. |
| `HST.step`, `HST.rem`, `HST.digit` | The greedy recursion: subtract `d n` from the residual iff it fits. |
| `HST.d_pos` | `0 < d n`. |
| `HST.d_strictAnti` | `n ↦ d n` is strictly decreasing. |
| `HST.rem_nonneg` | For `0 ≤ x`, the residual never becomes negative. |
| `HST.rem_lt` | For `x < 1`, `rem x n < 1/(n+1)`: the finite error estimate behind the source's `θ − θ_n ≤ π/(n+1)`. |
| `HST.rem_add_sum` | The exact finite identity `rem x n + Σ_{k<n} δ_k d_k = x`. |
| `HST.rem_tendsto_zero` | For `0 ≤ x < 1`, `rem x n → 0`. |
| `HST.sum_tendsto` | For `0 ≤ x < 1`, the greedy partial sums converge to `x`: the source's series theorem, normalised. |

The proof of `sum_tendsto` derives the partial sum as `x − rem x n` from
`rem_add_sum` and applies `rem_tendsto_zero`.

## Not formalised

The following are **source claims**, not Lean theorems:

- the Haar tree, the orthonormal Haar basis `B`, and the isometric
  isomorphism `H : L²[0,π] → ℓ²(B)` (Programme II–III);
- the HST Dirichlet series and its absolute convergence for `Re s > 1`;
- the transfer operator `L_s`, its trace-class property and analytic
  extension (Programme IV);
- the Fredholm determinant identity
  `det(I − L_s) = ζ(s)/ζ(2s) · exp(P(s))` and the regularised determinant
  (Programme V). The landing page calls the proof rigorous but the linked
  proof page is itself marked "Incomplete proof"; this reconstruction does
  not adjudicate that dispute;
- the harmonic sine `L`-functions (Programme VII);
- the Programme IIX monotonicity inequality
  `Im tr((I − L_{1/2+it,χ})⁻¹ dL/dt) ≥ 0`, which the source labels
  speculative and open. Neither RH nor GRH is proved here.

## Gaps and restrictions

1. **Endpoint `x = 1`.** The Lean convergence theorems assume `x < 1`
   because the first strict bound `rem 1 1 < 1/2` is false. The endpoint is
   nevertheless exact: `1 = 1/2 + 1/3 + 1/6`, verified by
   `tests/test_programme.py`. A Lean proof for `x = 1` would need a separate
   eventual-stability argument.
2. **Two incompatible digit conventions in the source.** Programme I and the
   landing page use a binary rule (`δ_n ∈ {0,1}`). The research guide for
   item 17 prints `δ_n = ⌊(n+2) r_n⌋` and still calls the digits binary; that
   recursion produces digits greater than one (for `x = 9/10` it produces
   `[1,2,1,3,…]`). The formal core follows the binary rule, which is the one
   the Haar-tree construction needs. The discrepancy is recorded as a source
   issue and tested in `test_guide_floor_recursion_is_not_binary`.
3. **No analytic number theory.** Nothing about zeros of `ζ`, Dirichlet
   `L`-functions, Mayer–Efrat theory, or determinant regularisation is
   formalised. Mathlib does not provide the required transfer-operator or
   Fredholm-determinant infrastructure.

## Build

```bash
cd the-final-letter/topics/hst-programme
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Last successful output: see [`BUILD.log`](BUILD.log).
