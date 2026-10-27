# Round 109 — the main term, the Weil-scale error, and the sieve level

*The plan below was fixed at the start of the round (see `rounds.log`, BEFORE line); the numbers are the
round's results.*

---

## 1. The envisioned path

Phase 020's question is whether the function-field zeta, read through windows, can supply what the linear
statistics lack. Round 108 removed the naive answer (a degree truncation is arbitrary and the "remainder" is
larger than the answer). Two things must therefore be established before any window method is meaningful:

1. **The main term is real and the error is at the Weil scale.** If the twin count is `S(q)q^n/n² + E(n)` with
   `E(n) = O(q^{n/2})`, then a window method has a target: it must reproduce the main term and control an error
   of that size. If `E` were much larger, windows could not help.
2. **The sieve gives a bound of the right *shape*.** The classical `Λ²` sieve produces upper bounds of the form
   `c(level)·q^n`; the question is how `c` depends on the level, and whether at level `θn` it reaches the
   `X/log²X` scale. That constant is the parity factor in this language.

This round does (1) fully and (2) for small levels, and states the precise computation needed for the `θ = 1/2`
level.

## 2. Wild guess 50

> **Wild guess 50.** The singular series is the exact main term and the error is at the Weil scale:
> `T(n) = S(q)q^n/n² + E(n)` with `|E(n)| ≤ C q^{n/2}` for a small constant `C`, uniformly in the computed range.

**Why guess it.** Every error term in the programme has been a `q^{n/2}` oscillation. If this holds, the window
has a real chance — the error is one square-root of the main scale, not the main scale.

**Falsification test.** Compute `S(q)` from the convergent Euler product, form `E(n) = T(n) − S(q)q^n/n²`, and
tabulate `|E(n)|/q^{n/2}`. A ratio that grows without bound kills the guess; a bounded ratio supports it.

## 3. Results

### 3.1 The singular series is the main term

`S(q) = Π_P (1−2/Q)/(1−1/Q)²` computed from the exact qrime counts `I(n) = (1/n)Σ_{d|n} μ(d)q^{n/d}`:

| `q` | 3 | 5 | 7 |
|---|---|---|---|
| `S(q)` | 0.396104 | 0.709544 | 0.812706 |

These reproduce the 018 values. The comparison `T(n)` against `S(q)q^n/n²`:

| `q` | `n` | `T(n)` | `S(q)q^n/n²` | `E(n)` | `q^{n/2}` | `|E|/q^{n/2}` |
|---|---|---|---|---|---|
| 3 | 6 | 6 | 8.02 | −2.02 | 27 | 0.07 |
| 3 | 8 | 36 | 40.61 | −4.61 | 81 | 0.06 |
| 3 | 10 | 216 | 233.90 | −17.90 | 243 | 0.07 |
| 3 | 12 | 1506 | 1461.85 | +44.15 | 729 | 0.06 |
| 5 | 5 | 98 | 88.69 | +9.31 | 55.9 | 0.17 |
| 5 | 8 | 4500 | 4330.71 | +169.29 | 625 | 0.27 |
| 7 | 6 | 2667 | 2655.95 | +11.05 | 343 | 0.03 |

The ratio is bounded by `0.9` across all computed `(q,n)` and settles around `0.06` for `q = 3`. **Wild guess 50
is confirmed**: the main term is the singular series and the error is at the Weil scale.

One refinement matters for the programme: the ratio does *not* decay, it fluctuates. Combined with round 107's
refutation of spectrality (no finite linear recurrence), the natural reading is that `E(n)` is a sum of
**infinitely many** `q^{n/2}`-sized oscillations — the zero spectrum of a genuine `L`-function, not a finite set
of Frobenius eigenvalues. That is the object a window method would have to control.

### 3.2 The Selberg bound and the level

Implemented the degree-level `Λ²` sieve: weights supported on all monic `d` with `deg d ≤ κ`, with

```
A[d,e] = #{f : lcm(d,e) | f(f+2)} = 2^{ω(lcm(d,e))} q^{n − deg lcm(d,e)}   (deg lcm ≤ n),
bound(κ) = 1 / (A^{-1})_{1,1}.
```

The local factor `2` is the dimensionality of the sieve (each prime divides `f` or `f+2`); it is Lean-checked
in `lean/SieveLocal.lean` (`card_roots_mul`: exactly two residues solve `a(a+h) = 0`).

Results at `q = 3`:

| `κ` | support | `bound/q^n` | ratio to truth at `n = 9` | growth of ratio |
|---|---|---|---|---|
| 1 | 4 | 0.1429 | 26.8 | like `n²` |
| 2 | 13 | 0.0504 | 9.4 | like `n²` |
| 3 | 40 | 0.0297 | 5.6 | like `n²` |

> **Erratum (round 110).** The `κ = 3` entry originally read `0.053` / `10.0`; the `ω` (distinct-factor)
> counter used here over-counted repeated factors. The corrected values are `0.0297` / `5.6`; `κ = 1` and
> `κ = 2` were unaffected. The structural conclusion (bound `= c(κ)q^n`, so fixed level captures no power
> saving) is unchanged, and is sharpened in round 110.

At fixed level the bound is exactly `c(κ)·q^n` (a unit test pins this), so the ratio to the truth grows like
`n²`. The sieve therefore captures *no* power saving unless the level grows with `n`. The classical scaling is
`level = q^{θn}`; at `θ = 1/2` the bound should reach the `q^n/log²(q^{θn})` shape. That computation needs the
closed form of the level-restricted meet-matrix inverse (the fundamental lemma), not a dense matrix, and is the
first task of round 110.

**The parity question is now a single number.** If `c(θ=1/2)` is computed and compared with `S(q)/n²`, their
ratio is the sieve's parity factor: `1` would mean the sieve crosses the barrier, any constant `>1` is the
barrier quantified. The expectation — from the dimension-2 structure — is a factor `2² = 4`, and measuring it is
the point.

### 3.3 State

* Wild guess 50 confirmed (`|E|/q^{n/2} ≤ 0.9`, typically `0.06`).
* The error is Weil-scale but not spectral (rounds 107 + 109): an infinite zero spectrum.
* The `Λ²` bound at fixed level is `c(κ)q^n`; the level must grow like `n`; `c(1/2)` is the missing number.
* 15 unit tests green; `SieveLocal.card_roots_mul` added to Lean.

### 3.4 Next round (110)

1. Derive the fundamental-lemma closed form for `bound(θn)` and compute `c(θ)` for `θ ∈ (0,1)`.
2. Measure the parity factor at `θ = 1/2` against the truth.
3. If the factor is `4` (or `2`), state it as the quantitative barrier and reconnect to the `χ₂(2)` correction
   of 019.
