# The half-spectrum zeta limit

This note proves the limit used in the QEFE dossier. It is elementary and
self-contained; it is not taken from the literature.

## Statement

For `k ≥ 1` put `N = k + 2` and

```
d_j = sin(π(j+1)/N) / sin(π/N),     j = 0, …, k.
```

For every real `s > 1/2`,

```
lim_{k→∞} Σ_{j=0}^{⌊k/2⌋} d_j^{-2s} = ζ(2s),
lim_{k→∞} Σ_{j=0}^{⌊k/2⌋} (−1)^j d_j^{-2s} = η(2s) = (1 − 2^{1−2s}) ζ(2s).
```

The unsigned full-spectrum sum has limit `2ζ(2s)`; the alternating full-spectrum
sum is `0` for odd `k` and has limit `2η(2s)` for even `k`.

## Proof

Write `n = j + 1` and `θ = π/N`. Then `d_{n−1} = sin(nθ)/sin θ`. For
`1 ≤ n ≤ N/2` we have `0 < nθ ≤ π/2`, and Jordan's inequality gives

```
sin(nθ) ≥ (2/π) nθ = 2n/N.
```

Also `sin θ ≤ θ = π/N`. Hence

```
d_{n−1}^{-2s}
  = (sin θ / sin(nθ))^{2s}
  ≤ ((π/N) / (2n/N))^{2s}
  = (π/2)^{2s} n^{-2s}.                                      (1)
```

The right-hand side is summable because `2s > 1`.

For fixed `n`, as `k → ∞` (so `N → ∞`),

```
d_{n−1} = sin(nπ/N)/sin(π/N) → n,
```

hence `d_{n−1}^{-2s} → n^{-2s}`. By dominated convergence for series (apply it
to the counting measure on `ℕ`, using the domination (1)),

```
lim_{k→∞} Σ_{n=1}^{⌊N/2⌋} d_{n−1}^{-2s}
  = Σ_{n=1}^∞ n^{-2s}
  = ζ(2s).
```

This is the first limit. The signed sum is identical with the extra factor
`(−1)^{n−1}`; dominated convergence gives

```
Σ_{n=1}^∞ (−1)^{n−1} n^{-2s} = η(2s).
```

For the full spectrum the same argument applies to `n = 1, …, N−1`. The
unsigned sum doubles the half-spectrum limit because `sin²(π(N−n)/N) =
sin²(πn/N)`, so the terms for `n` and `N−n` agree. The alternating sum pairs
`n` with `N−n`; the pair cancels when `N` is odd and adds when `N` is even. In
the even case the full alternating sum is twice the half-spectrum alternating
sum.

## Integer zeros

For integer `s ≥ 1`, the alternating full-spectrum polynomial vanishes once
`k ≥ 2s − 1`. Expanding `sin^{2s}(πx)` as a finite cosine polynomial
`Σ_{r=0}^s a_r cos(2πrx)` and summing `(−1)^{n−1} cos(2πrn/N)` over
`n = 1, …, N−1` gives `1` for even `N` and `0` for odd `N`; the constant term
is `sin^{2s}(0) = 0`. Hence the whole sum is zero. This is the exact
counterpart of the numerical certificate in `tests/test_programme.py`
(`test_su2k_integer_zeros`).

## Status

The limit is cited in the dossier as an in-house theorem, not as a literature
input. The numerical certificate at `k = 2048` is in
`test_su2k_half_spectrum_zeta`.
