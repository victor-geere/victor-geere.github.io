# Round 108 — the boundary stratum

*Written before the computation of this round.*

Round 107 left one concrete defect: the coprime-pair expansion of the twin count disagreed with the count.
This round fixes it and asks what the fix means for the window programme.

---

## 1. The envisioned path (unchanged in outline, sharpened here)

The path of round 107 stands: the irreducible indicator is the Legendre sieve over primes of degree `≤ n/2`,
the twin count is its correlation, and the expansion over coprime divisor pairs is the object a window method
would manipulate. What round 107 could not do was evaluate that expansion correctly. The diagnosis is now
clear enough to state as part of the path:

**The truncation is the error.** The expansion

```
T(n) = Σ_{d,e | P_y, gcd(d,e)=1} μ(d)μ(e) · #{f : deg f = n, d | f, e | f+2}
```

has terms with `deg d + deg e > n`. Round 107 dropped them, on the reasoning that the CRT class has degree
`deg d + deg e` and cannot contain a polynomial of smaller degree. That reasoning is wrong: a class modulo `m`
with `deg m > n` contains **at most one** polynomial of degree `n`, and whether it contains one is a genuine
condition — not an automatic zero. Those boundary terms are exactly the ones the window method is supposed to
control, so dropping them was dropping the interesting part.

This gives the path for this round a clean shape:

1. Count the pairs correctly: `C(d,e) = q^{n−deg d−deg e}` when `deg d + deg e ≤ n`, and
   `C(d,e) ∈ {0,1}` — decided by the canonical representative of the CRT class — when `deg d + deg e > n`.
2. Verify `T(n)` is reproduced exactly.
3. Stratify by `k = deg d + deg e` and measure how much of the count lives at `k > n`.
4. Compare the boundary with `q^{n/2}`: if the boundary is the `q^{n/2}`-sized term, then the window method's
   error term *is* the boundary stratum, and the programme knows exactly which object to bound.

## 2. Wild guess 49

> **Wild guess 49.** In the corrected expansion, the boundary stratum `k > n` carries the whole correction to
> the truncated (Euler-product) value, and its size is `≍ q^{n/2}` — the Weil scale. Equivalently, the main term
> is the `k ≤ n` part and the error term of the twin asymptotic is exactly the boundary sum.

**Why guess it.** The `k ≤ n` part is a finite Euler product evaluated at `q`, i.e. the singular series; the
`k > n` part is a sum over large divisors, which is the bilinear regime. If the boundary were negligible the
parity barrier would be a technicality, which it is not. The `q^{n/2}` scale is the only scale in the problem.

**Falsification test.** Compute the strata for `q = 3, n = 2..6` and `q = 5, n = 3..5`, and compare
`|boundary|` with `q^{n/2}` and with the defect `T(n) − T_{k≤n}(n)`. If the boundary is much smaller than the
defect, or much larger than `q^{n/2}`, the guess is dead.

## 3. The plan

1. Add an exact pair count to the library (CRT + representative test) and an exact expansion; verify it against
   brute force for `q = 3, 5` and `n ≤ 6`.
2. Stratify and measure.
3. Unit tests: expansion = brute force; `k ≤ n` part = truncated product; boundary = difference.
4. Lean: the uniqueness lemma that makes `C ∈ {0,1}` on the boundary — two monic polynomials of degree `n`
   congruent modulo `m` with `deg m > n` are equal.

Results follow in §4.

---

## 4. Results and verdict

### 4.1 The bug, found and fixed

Round 107 dropped every pair with `deg d + deg e > n`, on the argument that the CRT class has degree
`deg d + deg e` and so cannot contain a polynomial of degree `n`. The argument is wrong: a class modulo `m`
contains at most one polynomial of degree `n < deg m` — but "at most one" is not "none". The boundary terms
exist, each with coefficient `0` or `1`.

The `0/1` statement is now a Lean theorem (`lean/Boundary.lean`):

```lean
theorem Boundary.unique_of_deg_lt {m f g : F[X]} (hm : m.Monic) {n : ℕ}
    (hdeg : n < m.natDegree) (hfn : f.natDegree = n) (hgn : g.natDegree = n)
    (hdvd : m ∣ f - g) : f = g
```

i.e. two degree-`n` polynomials congruent modulo a monic `m` of larger degree coincide. With it, the boundary
coefficient is `1` exactly when the canonical CRT representative is monic of degree `n`, and `0` otherwise.

The library now has `pair_count` (CRT + representative test) and `expansion_twin_count`. The expansion
reproduces the brute-force count **exactly**:

| `q, n` | expansion | brute force |
|---|---|---|
| 3, 2 | 0 | 0 |
| 3, 3 | 1 | 1 |
| 3, 4 | 0 | 0 |
| 3, 5 | 6 | 6 |
| 3, 6 | 6 | 6 |
| 5, 3 | 10 | 10 |
| 5, 4 | 20 | 20 |
| 5, 5 | 98 | 98 |

So the round-107 defect is closed: the identity holds as an exact rearrangement, boundary included.

### 4.2 Wild guess 49: half right, half wrong

The boundary `T(n) − (k ≤ n part)` is measured below. It is **not** negligible — that half of the guess holds.
It is also **not** at the `q^{n/2}` scale: it grows far faster.

| `q` | `n` | `T(n)` | truncated `k ≤ n` | boundary | `q^{n/2}` | ratio |
|---|---|---|---|---|---|---|
| 3 | 5 | 6 | −33 | 39 | 15.6 | 2.5 |
| 3 | 6 | 6 | −155 | 161 | 27 | 6.0 |
| 3 | 8 | 36 | −723 | 759 | 81 | 9.4 |
| 3 | 10 | 216 | −2523 | 2739 | 243 | 11.3 |
| 5 | 4 | 20 | −65 | 85 | 25 | 3.4 |
| 5 | 6 | 240 | −2625 | 2865 | 125 | 22.9 |
| 5 | 7 | 1140 | −5285 | 6425 | 279.5 | 23.0 |

The ratio grows, so the boundary is not a `q^{n/2}` object.

### 4.3 Why: the raw product diverges

The truncated part is the coefficient sum of `∏_{deg Q ≤ n/2} (1 − 2 t^{deg Q})` at `t = 1/q`. Its logarithm is

```
Σ_{deg Q ≤ n/2} log(1 − 2/q^{deg Q}) ≈ −2 Σ_{d ≤ n/2} (#primes of degree d)/q^d ≈ −2 Σ_{d ≤ n/2} 1/d,
```

and `Σ 1/d` diverges logarithmically. So **the truncated product is not the singular series**: it is a partial
product of a divergent product, and its value grows in magnitude with `n` (the table shows `−33, −155, −2523`
against `T(n) = 6, 6, 216`). The exact count is the *full* alternating sum, in which the truncated part and the
boundary cancel almost completely.

This is the technical shape of the parity barrier in this language: the raw Möbius/Legendre sieve does not split
into "main term + small error". The main term of the twin asymptotic is not a truncation of this product; it is a
*renormalised* object (the singular series `Π (1−2/Q)/(1−1/Q)²`, which converges because of the normalisation by
`(1−1/Q)²`). Getting from the divergent product to the convergent series is exactly what the sieve weights do,
and exactly what the parity theorem forbids for bounded-support weights.

### 4.4 Consequences for the programme

1. **The "window" cannot be a degree truncation.** Round 107's plan was to truncate at `k ≈ n` and call the
   remainder the error. That is now refuted: the truncation is arbitrary and the remainder is larger than the
   answer. The window has to be built from normalised weights, not from a cut in `k`.
2. **The object to bound is the cancellation.** Since truncated and boundary are both `≍ q^n`, the twin count is
   a small (relative) residue of a large cancellation. That is the same phenomenon as the `q^{n/2}` error over
   function fields: the main term is `q^n/n²`, i.e. a `1/n²` fraction of the raw size — the cancellation is the
   whole game.
3. **Next round** should implement the normalised (Selberg `Λ²`-type) weights in the function-field model and
   check whether *they* produce main term `+ O(q^{n/2})`. If they do, the parity theorem's exclusion of
   bounded-support weights will show up as a necessary growth of the level — which is the precise transfer
   demand for `ℤ`.

### 4.5 What this round established

* the expansion is exact (bug closed, verified on 8 cases);
* the boundary stratum is `0/1` and is certified as such in Lean (`Boundary.unique_of_deg_lt`);
* wild guess 49 is half-confirmed and half-refuted, and the refutation is understood analytically (divergent
  partial product);
* 12 unit tests green.
