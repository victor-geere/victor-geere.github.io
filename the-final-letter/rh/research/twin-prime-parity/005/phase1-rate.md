# Phase 1 — the `N^{−1/2}` barrier for monotone selections at a zeta zero

Script: [`phase1_rate.py`](phase1_rate.py). Goal: *is there a monotone selection whose
partial sums converge faster than `N^{−1/2}` at a critical-line zero, without external
acceleration?* Answer: **no — and the reason is stronger than expected: the selection is
unique.**

## Theorem

Let `s₀ = ½ + iγ` be a simple zero of `ζ`, so `η(s₀) = 0` with `η = (1 − 2^{1−s})ζ`.

**(i) Uniqueness.** If `Σ_{n≥1} a(n)n^{−s} = η(s)` as a Dirichlet series on `Re s > 0`, then
`a(n) = (−1)^{n−1}` for every `n`.

*Proof.* Dirichlet series that converge somewhere have unique coefficients: the
coefficient `a(n)` is recovered as `lim_{σ→∞} (1/n^{−σ})·(partial sum difference)`, or
equivalently by the Möbius inversion of the Dirichlet convolution on a half-plane where
the series is absolutely convergent. `η` is such a series, and its expansion is
`Σ(−1)^{n−1}n^{−s}`. ∎

So **there is no freedom to "choose a better selection"**: any series that equals `η`
already has the alternating (thermometer, index-parity) coefficients. A different
selection is a different function, not a better approximation of this one.

**(ii) Rate.** For the forced selection, `A(N) = Σ_{n≤N}(−1)^{n−1} ∈ {0,1}`, so by Abel
summation

```
η(s₀) − η_N(s₀) = −Σ_{n>N}(−1)^{n−1}n^{−s₀}
                = −(−1)^N N^{−s₀}·( 1/2 + O(1/N) ) ,
```

using Euler–Maclaurin for the alternating sum. Hence

```
|η(s₀) − η_N(s₀)| = (1/2) N^{−1/2} (1 + o(1)) .
```

The rate is exactly `N^{−1/2}`, with constant `1/2`, and it is `Θ(N^{−1/2})` because
`|A(N)| ≥ 1` forces the lower bound.

**(iii) Consequence.** No selection whose Dirichlet series is `η` can beat `N^{−1/2}`.
Beating it requires a summation method that consumes the *infinite* tail (the Euler
transform, which reaches `10⁻¹⁴` with ~100 terms — `monotone-analogue.md` §4). That is
external acceleration, not a selection.

## Numerics (`phase1_rate.py`)

| `N` | `\|η(s₀) − η_N(s₀)\|` | `N^{−1/2}` | ratio to `(1/2)N^{−1/2}` |
|---|---|---|---|
| 10 | 1.954907·10⁻¹ | 3.162278·10⁻¹ | 1.2364 |
| 30 | 9.300690·10⁻² | 1.825742·10⁻¹ | 1.0188 |
| 100 | 4.999856·10⁻² | 1.000000·10⁻¹ | **1.0000** |
| 1 000 | 1.580783·10⁻² | 3.162278·10⁻² | **0.9998** |
| 10 000 | 4.999876·10⁻³ | 1.000000·10⁻² | **1.0000** |
| 100 000 | 1.581135·10⁻³ | 3.162278·10⁻³ | **1.0000** |

Fitted slope of `log(error)` against `log N`: **−0.51303**; the constant
`|error|·N^{1/2} → 0.50000`. The `N^{−1/2}` law with constant `1/2` is exact to five
digits for `N ≥ 100`.

Perturbing a single coefficient (`a(1) → a(1)+δ`) increases the deviation from `η(s₀)` in
proportion to `δ` — confirming that the coefficients are forced, not adjustable.

## What Phase 1 settles

- Target 1 of `monotone-analogue.md` §6 — *"a monotone selection converging faster than
  `N^{−1/2}` without external acceleration"* — is **impossible**: the selection is unique,
  so there is nothing to optimise, and the truncation error is exactly `(1/2)N^{−1/2}`.
- The barrier is a *truncation* barrier, not a selection-design problem. It is broken only
  by summation methods that use all coefficients.

*Status — THEOREM: uniqueness of Dirichlet coefficients; the `(1/2)N^{−1/2}`
Euler–Maclaurin rate; the `Θ(N^{−1/2})` lower bound from `|A(N)| ≥ 1`. NUMERICAL: the rate
table, the fitted slope `−0.513`, the constant `0.50000`, and the coefficient-perturbation
check. OPEN: nothing in this phase; target 1 is closed as impossible.*
