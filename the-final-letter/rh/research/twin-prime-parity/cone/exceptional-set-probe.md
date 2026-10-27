> **ERRATUM (see [`ERRATUM-mrt-misattribution.md`](ERRATUM-mrt-misattribution.md)).**  This
> document, as originally written, described `Σ λ(n)λ(n+1)` as *solved* and concluded that shift 2
> is *equivalent* to the odd core.  **That premise is false**: the un-averaged Chowla conjecture is
> open for every `k ≥ 2` ([MRT](https://arxiv.org/abs/1503.05121): "remains unproven for any
> h_1,…,h_k with k ≥ 2").  The correct consequence of the split below is a **sufficiency** — both
> halves open — not an equivalence.  The identities are unaffected.

# Where does the shift-2 correlation deviate? A probe with the solved case as control

*Goal 4, round 1.  Script: [`exceptional_set.py`](exceptional_set.py) · log:
[`verify/exceptional_set.log`](verify/exceptional_set.log).  **HEURISTIC throughout.***

## The question

`Σ_{n≤x} λ(n)λ(n+1) = o(x)` is a theorem (Matomäki–Radziwiłł–Tao); `Σ_{n≤x} λ(n)λ(n+2) = o(x)` is
open.  The difference is not in the parity barrier — both are two-point correlations of the same
function — so the natural question is where, in `x`, the two differ.  If the open case had a
gross scale-localised conspiracy, that would be a lead and a constraint on any proof.  If the two
cases are statistically indistinguishable, then the h=2 difficulty is not a visible bad-scales
phenomenon at accessible ranges — also a constraint, in the opposite direction.

Parity plays no role in this probe: the object of study is the *scale structure* of the deviation.

## Method and validation

`f1(n) = λ(n)λ(n+1)`, `f2(n) = λ(n)λ(n+2)`, sieved to `N = 2²⁶ = 67108864`, with two independent
random ±1 controls put through the identical pipeline.  On a geometric grid of 30000 scales `x`:

```
d_i(x) = S_i(x)/√x          S_i(x) = Σ_{n≤x} f_i(n)          (un-averaged, normalised)
l_i(x) = L_i(x)/√(log x)    L_i(x) = Σ_{n≤x} f_i(n)/n        (log-averaged, normalised)
T_i(x,H) = (Σ_{x<n≤x+H} f_i(n))/√H,   H = x^θ, θ ∈ {0.10, 0.25, 0.50}
```

Two estimator bugs were found and fixed during this run, both by checks rather than by inspection:
a `np.add.reduceat` prefix-sum convention that was silently off, and short-interval windows that
were limited by the grid spacing (so `θ = 0.1` was measuring a 300-term window at large `x`).  The
script now asserts its estimator against brute force at five scales before doing anything else, and
the short windows are computed at exact boundaries.  The numbers below are post-fix.

## Results

| statistic | f1 (solved, h=1) | f2 (open, h=2) | ctrl1 | ctrl2 |
|---|---|---|---|---|
| `S(N)/√N` | −0.582 | −0.718 | −0.982 | −0.996 |
| `max_x \|d(x)\|` | 1.673 | 1.159 | 2.111 | 2.848 |
| `max_x \|l(x)\|` | 0.275 | 0.449 | 0.369 | 0.106 |
| `max_x \|T\|`, θ=0.10 | 2.45 | 2.45 | 2.45 | 2.45 |
| `max_x \|T\|`, θ=0.25 | 4.23 | 4.12 | 4.39 | 3.97 |
| `max_x \|T\|`, θ=0.50 | 4.49 | 4.06 | 4.05 | 4.83 |

Correlation between the two deviation processes, `corr(d₁,d₂)`: `+0.2514` for the λ shifts.  Null
distribution from 40 independent control pairs at `N = 2²²`: mean `+0.047`, **sd `0.357`**, range
`[−0.653, +0.796]`.  So the observed value is `z = +0.57` — **indistinguishable from the null**.

Extreme scales: the top-20 of `d₁` and the top-20 of `d₂` have **zero overlap** — but six of the
top ten for `d₂` are adjacent scales near `x ≈ 4×10⁴`, i.e. one local excursion, not ten independent
extreme scales.

## Reading, with the caveats that matter

1. **No anomaly is visible for h=2** at any of these scales, on any statistic.  Both λ-based
   sequences are, if anything, *less* extreme than the random controls (`max|d|` 1.67 and 1.16
   against 2.11 and 2.85) — mild sub-random behaviour, consistent with the periodogram result of
   the (c3) diagnostic.
2. **The "same scales?" test has low power.**  A null sd of `0.357` on the correlation means a
   shared component below roughly `0.7` would be invisible at this range.  So the honest statement
   is "no shared structure *detectable by this statistic*", not "none exists".
3. **Extreme scales are not independent.**  Reporting "top-10 extreme scales" overstates the
   information: for `d₂` it is mostly one excursion.  Any future version of this probe should count
   excursions, not grid points.
4. **Short intervals show nothing** for either shift, at all three exponents, versus the controls.

## What this does and does not do

It rules out a *gross*, scale-localised conspiracy in the shift-2 correlation up to `6.7×10⁷`: if
one existed at that size, these statistics would show it.  It says **nothing** about the
asymptotics, and it neither supports nor undermines any proof strategy.  Finite-range null results
of this kind are consistent with the conjecture and with many alternatives — the archive's F4
records that finite prefixes cannot decide Chowla — and this note should be read as a description of
what the data looks like, not as evidence for the theorem.
