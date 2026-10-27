# The monotone analogue of ζ is a zero-locator — and the raw partial sums are not

Companion: [`monotone_zerolocator.py`](monotone_zerolocator.py). Context: §§6, 8, 9, 10 of
[`value-greedy.md`](value-greedy.md).

This note records a positive result that the earlier verdicts under-sold. The "monotone
selection" in the eta/zeta setting is the period-2 (alternating, thermometer) coefficient
sequence `(−1)^{n−1}`. It is not decoration: it is exactly what makes the partial sums
converge on the critical line, and therefore exactly what turns them into a zero-locator.
The raw (non-monotone) partial sums fail at this, and provably so.

## 1. The two objects

```
monotone / alternating :   eta_N(s) = Σ_{n≤N} (−1)^{n−1} n^{−s}
raw / non-alternating  :   zeta_N(s) = Σ_{n≤N} n^{−s}
```

Both are partial sums of the same Dirichlet series with the thermometer code inserted.
The distinction is precisely the one the greedy analysis is about: `(−1)^{n−1}` is the
monotone (index-parity, period-2) selection; `n^{−s}` alone is the unselected one.

## 2. The contrast, and why it is forced

**Theorem.** *Let `s₀ = ½ + iγ` be a simple zero of `ζ`.* Then

1. `eta_N → eta` locally uniformly on `Re s > 0` (Dirichlet's test), and
   `eta = (1 − 2^{1−s}) ζ`; the factor has modulus `≥ √2 − 1` on the critical line, so
   `eta(s₀) = 0`. By Hurwitz's theorem the zeros of `eta_N` converge to `s₀`. The rate is
   the tail: by summation by parts,
   `eta_N(s₀) = −Σ_{n>N} (−1)^{n−1} n^{−s₀} = O(N^{−1/2})`,
   so the nearest zero of `eta_N` sits at distance `O(N^{−1/2})`.
2. `zeta_N(s₀) = −Σ_{n>N} n^{−s₀} = N^{1−s₀}/(1−s₀) + O(N^{−s₀})` (Euler–Maclaurin),
   so `|zeta_N(s₀)| ~ N^{1/2} → ∞`: for large `N` there is **no** zero of `zeta_N` near
   `s₀`, and the nearest ones sit far to the right.

So the monotone selection is not merely *a* way to reach the zeros; it is the one that
works, and the non-monotone one provably cannot. This is the honest positive content
behind "we have a monotone analogue of ζ".

## 3. Numerics

`monotone_zerolocator.py`, Newton from a coarse grid minimum, `s₀ = 0.5 + 14.134725141735i`:

| `N` | `Re s_N` (eta) | `Im s_N` (eta) | `\|s_N − s₀\|` | nearest zero of `zeta_N`: `Re` |
|---|---|---|---|---|
| 10 | 0.491731472 | 14.029958658 | 1.051·10⁻¹ | — |
| 100 | 0.483745410 | 14.111606855 | 2.826·10⁻² | 0.705570 |
| 1 000 | 0.491338506 | 14.136547706 | 8.851·10⁻³ | 0.740741 |
| 10 000 | 0.499394853 | 14.137324735 | 2.669·10⁻³ | 0.863069 |
| 100 000 | 0.500645438 | 14.135253372 | 8.340·10⁻⁴ | 0.853281 |
| 1 000 000 | 0.500239820 | 14.134612985 | 2.648·10⁻⁴ | 0.842906 |

Fitted slope of `log|s_N − s₀|` against `log N` over the last four rows: **−0.5078**,
against the predicted `−1/2`. The alternating real parts converge to `0.5`; the raw ones
drift to `≈ 0.84` and do not approach the critical line at all.

## 4. What this is and is not

- **Is**: a correct, sharp, *provable* statement that the monotone (alternating)
  regularisation is what converts partial sums into a critical-line zero-locator, with an
  explicit `N^{−1/2}` rate — and that the raw partial sums provably fail. It is the
  cleanest positive fact in the whole 004/005 body of work.
- **Is not**: new number theory. The three ingredients — Dirichlet's test for `eta`,
  `eta = (1 − 2^{1−s})ζ`, and Hurwitz's theorem — are textbook, and the `N^{−1/2}` rate is
  just the tail size. The *contrast* is the part worth writing down; the mechanism is
  classical.
- **Is not**: a route to RH. It locates zeros that are already known (and found far faster
  by the Euler-transformed `eta`, which reaches `10⁻¹⁴` with ~100 terms — §8 of
  `value-greedy.md`). Raw truncation at `N^{−1/2}` is the slowest possible method; the
  monotone selection buys convergence, not speed.

## 5. The one genuinely non-classical object, and its honest status

The greedy support itself defines a Dirichlet series. For the Sylvester ladder
`s_{j+1} = s_j² − s_j + 1`,

```
D(s) = Σ_j s_j^{−s} ,        D(s) − D(2s) = 2^{−s} + correction,
```

the correction being `~20 %` (measured ratio `|D(s)−D(2s)|/|2^{−s}| = 1.19–1.24` for real
`s`, `3.3` at `s = 0.5 + 14.13i`) because `s_{j+1} ≈ s_j²` but not exactly. So `D` is an
*almost* Mahler (self-similar) lacunary Dirichlet series. **CORRECTED — see
[`closed-form.md`](closed-form.md) §4.** The series converges for `Re s > 0` and diverges
on `Re s = 0` (a natural boundary); it is zero-free for `Re s ≥ 1` (first-term dominance,
with the boundary pinned by the closed form `Σ_{j≥1} 1/s_j = 1/2`), and its zeros lie in the
strip `0 < Re s < 1`. float64 locates them with no overflow; arbitrary precision is needed
only for accurate values (one zero is pinned to 60 digits in `closed-form.md` §3).

That object — a lacunary Dirichlet series with an asymptotic functional equation — is a
real mathematical topic (Mahler functions, lacunary series, natural boundaries; cf. the
classical theory going back to Fatou and the modern theory of Mahler equations). It is
**not** Egyptian-fraction trivia, and it is **not** ζ. Whether it has a sharp theorem worth
publishing is an open question, not a result; the natural first targets would be (i) an
exact functional equation for the true Sylvester ladder or a proof that none exists,
(ii) the zero distribution in the strip, (iii) whether the boundary `Re s = 0` is a
natural boundary.

## 6. What gold would have to look like

For the record, in this framework "gold" would be one of:

1. a monotone selection whose partial sums converge **faster** than `N^{−1/2}` at a zero
   without external acceleration — which would be a new zero-location method;
2. a greedy-support series `D_x(s)` with an **exact** functional equation or Euler product
   for some explicit `x` — which would make it arithmetic;
3. a proof that no such `x` exists — a sharp no-go.

None of the three is established here. What is established is the contrast in §2, which is
small, true, and — unlike most of this folder — positive rather than a refutation.

*Status — THEOREM: the contrast of §2 (Dirichlet + Hurwitz + Euler–Maclaurin); the
`N^{−1/2}` rate. NUMERICAL: the tables and the fitted slope `−0.508`; the Mahler-correction
ratios. OPEN: everything in §5 and §6.*
