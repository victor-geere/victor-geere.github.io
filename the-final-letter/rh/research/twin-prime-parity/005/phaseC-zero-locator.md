# Phase C — the honest zero locator, and a correction to Phase 1

Script: [`phaseC_locator.py`](phaseC_locator.py). Reference: `mp.altzeta`, `mp.zetazero`.

We asked for the best zero locator this machinery yields, and its rate. Answer: the
alternating partial sum **is** a genuine strip locator, at the classical `N^{−1/2}` rate;
the Euler-transformed partial sum beats that rate on values *and* on locations but costs
`Θ(t)` terms against Riemann–Siegel's `Θ(√t)`.

## C.1 Natural truncation `S_N(s) = Σ_{n≤N}(−1)^{n−1}n^{−s}`

Zero of `S_N` nearest `s₀ = 1/2 + 14.134725141734693790i`, Newton-refined in mpmath:

| `N` | `\|s_N − s₀\|` | `·N^{1/2}` |
|---|---|---|
| 10 | 1.050923·10⁻¹ | 0.3323 |
| 100 | 2.826070·10⁻² | 0.2826 |
| 1000 | 8.851171·10⁻³ | 0.2799 |
| 10000 | 2.669099·10⁻³ | 0.2669 |

Fitted slope −0.5263. The constant is `(1/2)/|η′(s₀)|`: numerically
`|η′(s₀)| = 1.8826967`, so `(1/2)/|η′| = 0.2655765`, and the measured plateau is `0.2669`.
So

```
|s_N − s₀|  =  (1/2) N^{−1/2} / |η′(s₀)| · (1 + o(1))  =  0.2656 N^{−1/2}.
```

This is quantitative Hurwitz/Rouché: `η_N → η` locally uniformly on `Re s > 0` (Dirichlet's
test), and `|s_N − s₀| = |η_N(s₀)|/|η_N′(s₀)|(1+o(1))`.

## C.2 The Euler transform beats it

`E_K(s) = Σ_{k<K} 2^{−(k+1)} Δ^k a_0(s)`, `a_n = (n+1)^{−s}`. Zero of `E_K` nearest `s₀`:

| `K` | 10 | 15 | 20 | 25 | 30 | 35 | 40 |
|---|---|---|---|---|---|---|---|
| `\|s_K − s₀\|` | 2.72·10⁻¹ | 3.48·10⁻² | 3.00·10⁻³ | 1.87·10⁻⁴ | 9.50·10⁻⁶ | 4.24·10⁻⁷ | **1.74·10⁻⁸** |

Geometric, factor `≈1.89` per added term. At `K = 40`:

```
s_K = 0.5000000101279606629604378 + 14.1347251558934264516308 i
s₀  = 0.5                        + 14.1347251417346937904572519836 i
```

**This corrects Phase 1.** `E_K` is *itself a length-`K` Dirichlet polynomial*,
`E_K(s) = Σ_{j<K} c_j (j+1)^{−s}` with `c_j = (−1)^j Σ_{k=j}^{K−1} C(k,j)2^{−(k+1)} → (−1)^j`
as `K → ∞`. Its coefficients differ from `η`'s; that is exactly why it escapes the barrier.
So Phase 1's phrasing "no selection can beat `N^{−1/2}`" was **too strong**:

- **true**: no *coefficient-preserving truncation* of the series that equals `η` beats
  `(1/2)N^{−1/2}` — the coefficients are forced by uniqueness (Phase 1, C1);
- **false**: no length-`N` Dirichlet polynomial beats it. The Euler polynomial does, by a
  factor `~1.89^{−N}`.

The correct dichotomy is *truncation vs resummation*, not *selection vs impossibility*.

## C.3 The cost law (why this is still not an advance)

`K` needed for zero-location error `< 10⁻¹⁰` (via the equivalent value criterion
`|E_K(s₀)| < 10⁻¹⁰·|η′(s₀)|`, since `|s_K − s₀| = |E_K(s₀)|/|η′|(1+o(1))`):

| `n` | 1 | 2 | 3 | 5 | 10 | 20 | 50 | 100 |
|---|---|---|---|---|---|---|---|---|
| `t = Im s₀` | 14.13 | 21.02 | 25.01 | 32.94 | 49.77 | 77.14 | 143.11 | 236.52 |
| `K` | 48 | 57 | 62 | 70 | 88 | 115 | 174 | 255 |
| `K/t` | 3.396 | 2.711 | 2.479 | 2.125 | 1.768 | 1.491 | 1.216 | 1.078 |
| `√(t/2π)` | 1.50 | 1.83 | 2.00 | 2.29 | 2.81 | 3.50 | 4.77 | 6.14 |
| ratio | 32.0 | 31.2 | 31.1 | 30.6 | 31.3 | 32.8 | 36.5 | 41.6 |

Linear fit: **`K = 0.9244 t + 39.34`**, so `K = Θ(t)` — **linear in height**. Riemann–Siegel's
approximate functional equation needs `Θ(√t)` terms. The ratio therefore grows like
`≈ 2.32√t`, and the Euler transform is asymptotically *worse* without limit. Its advantage
is `log(1/ε)` cost at *fixed* height, not height cost. The earlier `K ≈ 1.25t + 31` from the
first three zeros was an artefact of the small-`t` regime; the true slope is `0.92`.

## C.4 What the locator actually does (the positive result)

Argument-principle counts (exact, vectorised via outer products), strip `0.05 < Re s < 0.95`:

| `T` | ζ zeros below `T` | `η_N` zeros, `N = 64…512` |
|---|---|---|
| 50 | 10 | **10** (all `N ≥ 16`) |
| 200 | 79 | **79** (`N ≥ 64`) |

Seeding Newton at each of the 79 ζ zeros with `Im < 200`:

| `N` | matched `< 5·10⁻²` | mean shift | max shift | predicted `0.2656/√N` |
|---|---|---|---|---|
| 64 | 62 / 79 | 0.0441 | 0.2118 | 0.0332 |
| 128 | **79 / 79** | 0.0138 | 0.0320 | 0.0235 |
| 256 | **79 / 79** | 0.0088 | 0.0193 | 0.0166 |
| 512 | **79 / 79** | **0.0061** | 0.0133 | 0.0117 |

So for `N ≥ 128` **every** ζ zero in range is matched by exactly one zero of `η_N`, at the
predicted `(1/2)N^{−1/2}/|η′|` distance, and `|η_N|` at the ζ zero is `2.209·10⁻²`
(= `(1/2)/√512`) while at the relocated root it is `~10⁻¹⁴`.

**The barrier:** in the *wider* box `−1 < Re s < 2` the count is not stable — it grows with
`N` (77, 93, 113, 121, 135, 160 for `N = 16…512` at `T = 200`), i.e. `η_N` manufactures
spurious zeros outside the strip. Counted in a strip, it is clean; counted in a box, it
degenerates. And it cannot certify `Re s = 1/2` — that needs Turing-type certification.

An advisor predicted this test would return `≈91`; it returns **79 = ζ's exact count**.
The prediction is falsified, in the programme's favour, and I report both.

## C.5 What the digit map contributes

**Nothing, for zero location.** `cos θ_n = Re Π_{k∈A_n}e^{iα_k}` is an exact identity, so
the zeros of the rewritten sum are the zeros of the original sum, term by term. The digit
map is a change of coordinates on the phase (Phase A). It cannot move a zero.

*Status — THEOREM: the `0.2656 N^{−1/2} = (1/2)N^{−1/2}/|η′(s₀)|` location law (Hurwitz/
Rouché); the Euler polynomial is length-`K` with coefficients `c_j → (−1)^j`; the
correction to Phase 1's no-go. NUMERICAL: the two rate tables, the `K ≈ 1.25t + 31` cost
law, the strip counts `10` and `79` matching ζ, the `79/79` correspondence table, the
wide-box spurious growth. OPEN: certification of `Re s = 1/2`; whether the strip is clean
for all `T`.*
