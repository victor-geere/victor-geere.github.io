# A lower-bound expansion for `ζ(σ)^2` from the Lambert/Mellin integral

**Status:** derived, numerically verified, and complete as a mathematical result.
The Lean core is proved (`lambert_eq_double`, `lambert_majorant`,
`gaussian_moment`, `cpow_sq`).  The integrated `J=0`/`J=1` bound is accepted as a
**paper/numerical result**; the Lean formalisation item was closed by decision on
2026-11-10 because the Mellin substitution is blocked by a Lean coercion issue
(see §5), not by a mathematical gap.
This is the first result of the inequality direction.  It is unconditional, uses
`d(n) ≥ 0` through the positivity of the Mellin integrand, and is **not** a
coefficientwise Dirichlet-series comparison: the proof replaces the divisor
coefficients by a two-dimensional lattice sum via the AM–GM identity
`k² + m² ≥ 2km`.

## 1. Statement

For real `σ > 1` and every integer `J ≥ 0`,

```
ζ(σ)^2  ≥  2^σ  Σ_{j=0}^{J}  (Γ(σ+j) / (j! Γ(σ)))  E_j(σ+j),
```

where

```
E_j(τ) = Σ_{k,m≥1} (k − m)^{2j} / (k² + m²)^τ.
```

The `j = 0` term is the AM–GM bound `2^σ E_0(σ)`.  Each additional term is
non-negative, so the lower bounds increase with `J`.  Numerically the sequence
converges upward to `ζ(σ)^2` (see §3), which is consistent with the exponential
series in the proof.

## 2. Proof

Start from the Lambert series

```
L(q) = Σ_{n≥1} d(n) q^n = Σ_{k,m≥1} q^{km},
```

and put `q = e^{−u²}`:

```
L(e^{−u²}) = Σ_{k,m≥1} e^{−km u²}
           = Σ_{k,m≥1} e^{−(k²+m²)u²/2} · e^{(k−m)²u²/2}.
```

For `x ≥ 0` and `J ≥ 0`, `e^x ≥ Σ_{j=0}^{J} x^j/j!`.  Hence, with
`x = (k−m)²u²/2`,

```
L(e^{−u²})
  ≥ Σ_{j=0}^{J} (1/j!) Σ_{k,m≥1} ((k−m)²u²/2)^j e^{−(k²+m²)u²/2}.
```

All terms are non-negative, so the sum and the integral may be interchanged
(Tonelli).  The Mellin identity proved in Lean (`lambert_mellin`) is

```
Γ(σ) ζ(σ)^2 = ∫_0^∞ t^{σ−1} L(e^{−t}) dt,
```

and the substitution `t = u²` gives

```
Γ(σ) ζ(σ)^2 = 2 ∫_0^∞ u^{2σ−1} L(e^{−u²}) du.
```

For `a > 0` and `Re τ > 0`,

```
∫_0^∞ u^{2τ−1} e^{−a u²} du = (1/2) Γ(τ) a^{−τ}.
```

Applying this with `τ = σ + j` and `a = (k²+m²)/2` gives

```
∫_0^∞ u^{2σ−1+2j} e^{−(k²+m²)u²/2} du
  = 2^{σ+j−1} Γ(σ+j) (k²+m²)^{−(σ+j)}.
```

Therefore

```
2 ∫_0^∞ u^{2σ−1} L(e^{−u²}) du
  ≥ 2 Σ_{j=0}^{J} (1/j!) 2^{σ−1} Γ(σ+j) E_j(σ+j)
  = 2^σ Σ_{j=0}^{J} (Γ(σ+j)/j!) E_j(σ+j),
```

and dividing by `Γ(σ)` proves the claim.

## 3. Numerical verification

Ratios `bound_J / ζ(σ)^2` for `J = 0, 1, 2, 3, 4` (the bound is always below
`1`, and increases with `J`):

| σ | J=0 | J=1 | J=2 | J=3 | J=4 | J=5 | J=6 |
|---|---|---|---|---|---|---|---|
| 1.5 | 0.4282 | 0.5367 | 0.5960 | 0.6341 | 0.6611 | 0.6815 | 0.6974 |
| 2.0 | 0.6271 | 0.7434 | 0.8046 | 0.8412 | 0.8658 | 0.8835 | 0.8968 |
| 2.5 | 0.7407 | 0.8380 | 0.8885 | 0.9168 | 0.9344 | 0.9464 | 0.9551 |
| 3.0 | 0.8160 | 0.8914 | 0.9312 | 0.9523 | 0.9647 | 0.9726 | 0.9781 |
| 4.0 | 0.9053 | 0.9461 | 0.9694 | 0.9814 | 0.9877 | 0.9913 | 0.9936 |

At `σ = 2` the `J = 0` bound is `1.6971` against `ζ(2)^2 = 2.7058`; `J = 4`
raises it to `2.3429`, and `J = 6` to `2.4270` (ratio `0.897`).  At `σ = 4` the
`J = 6` bound is `1.1640` against `1.1714` (ratio `0.994`).

The verification functions are in
[`python/programme.py`](python/programme.py) and the tests in
[`tests/test_programme.py`](tests/test_programme.py).

### 3.1 Comparison with standard bounds

At `σ = 2, 2.5, 3, 4` the `J = 4` lattice bound is closer to `ζ(σ)^2` than both
standard upper bounds

```
ζ(σ) ≤ σ/(σ−1)                  (integral test),
ζ(σ)^2 ≤ ζ(σ−1)  (σ > 2)       (coefficientwise d(n) ≤ n).
```

| σ | `ζ(σ)^2` | lattice `J=4` | ratio | `σ²/(σ−1)²` | ratio | `ζ(σ−1)` | ratio |
|---|---|---|---|---|---|---|---|
| 2.0 | 2.7058 | 2.3426 | 0.866 | 4.0000 | 1.478 | — | — |
| 2.5 | 1.7996 | 1.6815 | 0.934 | 2.7778 | 1.544 | 2.6124 | 1.452 |
| 3.0 | 1.4449 | 1.3939 | 0.965 | 2.2500 | 1.557 | 1.6449 | 1.138 |
| 4.0 | 1.1714 | 1.1570 | 0.988 | 1.7778 | 1.518 | 1.2021 | 1.026 |

The lattice bound is a **lower** bound, the two standard ones are **upper**
bounds; the table compares their relative error.  At `σ = 4` the lattice bound
is within `1.3%` of `ζ(4)^2`, while the coefficientwise bound `ζ(3)` is `2.6%`
above it and the integral-test bound `16/9` is `52%` above it.

## 4. Novelty and literature

The `J = 0` case is an AM–GM/lattice-sum inequality which may already be known
in the theory of Epstein zeta functions; the higher-`J` family, obtained by
truncating the exponential series in the `(k−m)²` term, appears to be new in this
form.  The closest related work found is Alzer and Volkmer, *Inequalities for the
Lambert series*, The Ramanujan Journal (2026),
[doi:10.1007/s11139-026-01365-x](https://link.springer.com/article/10.1007/s11139-026-01365-x).
The search snippets indicate that paper studies convexity/monotonicity
inequalities for Lambert-series kernels (a function `Λ` increasing on
`(0, a₀]`, and a convexity hypothesis `φ''(t) > 0`), rather than the lattice-sum
lower bound obtained here.  The full text is paywalled, so this comparison is
based on the abstract/snippet level only.  Targeted searches for the exact
inequality `ζ(σ)^2 ≥ 2^σ Σ (k²+m²)^{−σ}` did not find it.  Until the full
literature check is done, this is reported as **a new derivation and a
numerically verified family**, not as a claim of priority.

## 5. Formalisation status

The pointwise bound is formalised as `lambert_majorant` in
[`lean/Topic.lean`](lean/Topic.lean):

```
Σ_{k,m≥1} e^{−km u²} ≥ (Σ_{k≥1} e^{−k²u²/2})²        (u > 0).
```

The Lean-proved items are:

1. ~~the Gaussian moment~~ — `gaussian_moment`;
2. ~~the identification `F(u²) = Σ_{k,m≥1} e^{−km u²}`~~ — `lambert_eq_double`,
   via Mathlib's `tsum_prod_pow_eq_tsum_sigma`;
3. ~~the complex-power identity `((x:ℂ)^2)^(s−1) = (x:ℂ)^(2(s−1))`~~ — `cpow_sq`;
4. the pointwise majorant — `lambert_majorant`.

The integrated `J = 0`/`J = 1` instances are **not** Lean-proved.  The Mellin
substitution `Γ(σ)ζ(σ)^2 = 2∫u^{2σ−1}F(u²)du` and the Tonelli interchange are
the missing steps; Lean elaboration produces definitionally equal but
syntactically distinct coercions (`↑2` versus `2 : ℂ`, and
`((x² : ℝ) : ℂ)` versus `(x : ℂ)^2`) that `rw`/`convert` do not match.  This is
recorded as an engineering blocker, not a mathematical one; the integrated bound
is accepted as a paper/numerical result.

None of this is RH-equivalent, and no positivity of `ζ` is claimed: the only
positivity used is `d(n) ≥ 0` and the non-negativity of the exponential series.
