# Round 2 notes — singular series, and what has no zeros

## The singular series

`S(q) = ∏_{℘} (1−2/N(℘))/(1−1/N(℘))²`, with `N(℘)=q^{deg ℘}`. Local factor
`(1−2/Q)/(1−1/Q)² = (Q−2)Q/(Q−1)²` (sympy: exact; Lean: `Qrime.local_factor`).

| q | 3 | 5 | 7 | 11 | 13 |
|---|---|---|---|---|---|
| S(q) *corrected* | **0.396104** | **0.709544** | **0.812706** | **0.891687** | **0.910723** |

> **Correction (round 4).** The values first reported here — `0.4614, 0.7092,
> 0.8317, 0.8971, 0.8877` — were produced by evaluating
> `(1−2/Q)/(1−1/Q)²` in double precision. For large `d` the ratio rounds to
> `1±1e-16`, and `log(lf)·I(d)` with `I(d)~q^d/d` is corrupted; the product
> drifts by up to `6.5e-2`. The stable form `∏ (1 − 1/(Q−1)²)` gives the
> corrected values above. See [`round4.md`](round4.md) §2 and
> [`lib/singular_series.py`](../lib/singular_series.py).

Measured `T(n)n²/qⁿ` approaches the corrected `S(q)`; with the correction the
approach is fast, not `O(1/n)`. The cleanest check is now `q=3, n=16`:
`0.3961077` vs `S(3) = 0.3961043` (relative error `8.5e-6`). The earlier
"`q=7, n=5`: `0.8330` vs `0.8317`" was a match against the wrong constant. The
residual oscillation is arithmetic, not a `c/n` second-order term
([`round4.md`](round4.md) §2.3–2.4).

## The decisive linear/bilinear statement

`ζ_{ℙ¹}(T) = 1/((1−T)(1−qT))` has **no zeros** (`P(T)=1`), yet twin qrimes exist
(`T(3)=1` over `𝔽₃`, `T(3)=10` over `𝔽₅`, `T(2)=7` over `𝔽₇`). Therefore:

> the zeta zeros **cannot** encode the twin-qrime count. The count is a pair
> correlation, not a zeta coefficient.

Higher-genus curve zeros encode point counts (linear statistics) only. The twin
count needs 2D Chebotarev / large sieve, available for `𝔽_q[x]`, unavailable for ℤ.

## Status

Objective criteria are met: dictionary verified; counts computed and matched to
`S(q)`; parity-barrier analysis with reproducible evidence (the equal-size
witness + the no-zero zeta); Lean green (4 declarations). Nothing claims to
solve twin primes or the barrier over ℚ.

## Round 3

The claim "the zeta is linear data, the twin count is not" is made precise in
[`round3-formal-statement.md`](round3-formal-statement.md): the zeta ⇔ degree
counts (Euler product + Möbius, Lean-checked), the non-factorisation
`B ≠ Φ(Z)` with an explicit `𝔽₇` witness (Lean-checked), and the pinned
normalisation `T(n) ~ S(q) qⁿ/n²` against Pollack's Conjecture 2.

