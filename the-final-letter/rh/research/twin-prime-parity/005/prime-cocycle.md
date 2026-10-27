# The prime-cocycle experiment — the last live route, now closed

Script: [`prime_cocycle.py`](prime_cocycle.py). This was the single route left open by the
debate ([`debate.md`](debate.md) §"Unresolved" 2): the digit map destroys the exact
multiplicative cocycle `θ_{mn} = θ_m + θ_n`, so apply the numeration where that cocycle
actually lives — to the **primes**.

The advisor's prediction: *digit-word statistics over `p ≤ X` show an explicit-formula-sized
anomaly at `t = γ_k` that is absent over all `n ≤ X`.*

**Verdict: half right. The prime sum does carry the zero. The digit-word statistic does
not — and the reason it does not is the digit map itself.**

## 1. The prime sum carries the zero, with the exact `log X` signature

Explicit formula:
`Σ_{n≤X} Λ(n)n^{−s} = X^{1−s}/(1−s) − Σ_ρ X^{ρ−s}/(ρ−s) + …`

A naive peak search over `t` finds **nothing** at `γ₁`: the sum is dominated by the `s = 1`
term `X^{1−s}/(1−s)`, of size `√X/|t| ≈ 31.6` at `X = 2·10⁵, t = 14.13` — which is exactly
the median `32.2` I measured. The zero is buried.

Subtract that main term and the zero appears with the pole-residue signature:

| `X` | `\|R(γ₁)\|` | `log X` | median `\|R\|` | argmax `t` |
|---|---|---|---|---|
| 10⁴ | 9.37 | 9.21 | 1.57 | 14.1197 |
| 10⁵ | 11.52 | 11.51 | 1.59 | **14.1347** |
| 10⁶ | 14.40 | 13.82 | 1.64 | **14.1347** |
| 4·10⁶ | 15.48 | 15.20 | 1.44 | **14.1347** |

So **`|R(γ₁)| = log X + O(1)`** — the pole residue of `−ζ′/ζ` at `ρ₁` — the argmax lands
exactly on `γ₁` from `X = 10⁵` on, and the ratio to the median grows `6.0 → 10.7`.
At generic `t` (`γ₁+0.7`, `γ₁+1.9`) the residual stays `1–3` with no growth, and the `X×10`
ratios follow `log X` (1.23, 1.25, 1.07) rather than `√X` (3.16).

**The advisor's mechanism is correct.**

## 2. RETRACTED — see [`salvage.md`](salvage.md) §1

**This section is wrong.** I scored the *raw* statistic without subtracting the `s = 1` main
term, so the `√X/|t| ≈ 31` pole term swamped the zeros. With the main term removed the
digit-word statistic **does** detect them: `z(γ₁) = +4.61` at bandwidth `M = 1`, `+3.57` for
the hard indicator, `max|z| = 3.78–4.61` over the first ten zeros against a `2.81`
Bonferroni threshold, and `0/400` null heights exceed the value at `γ₁` at `X = 4·10⁶`
(`p < 0.0025`). The mechanism given in §3 below is also wrong in detail — the odd-harmonic
series is not absolutely summable, so the resummation is unjustified and fails at the jump.

What survives is stronger and is the real result: the digit map is a **phase relabeling**, so
every digit statistic is a Fourier combination `Σ_m a_m A(mt)` of classical prime sums and
can add nothing. See [`salvage.md`](salvage.md) §2.

*Original (incorrect) section retained below for the record.*

## 2-original. The digit-word statistic does not isolate it

Statistic `S(t) = Σ_{p≤X} (log p)/√p · (2δ₀(θ_p(t)) − 1)` — the first greedy digit, weighted
by the natural prime weight. Null: 400 random heights in `[10,46]`, mean `1.05`, sd `40.11`.

| `k` | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| `γ_k` | 14.13 | 21.02 | 25.01 | 30.42 | 32.94 | 37.59 | 40.92 | 43.33 | 48.01 | 49.77 |
| z | −0.53 | −1.30 | +0.44 | +0.91 | −0.13 | +1.00 | +0.44 | −0.42 | +0.57 | +0.28 |

**max |z| = 1.30**, against a Bonferroni 5 % threshold of 2.81 for ten tests. Over all
`n ≤ X`, max |z| = 1.62. **No anomaly in either case.**

## 3. Why it fails — and it is the digit map's own fault

`2δ₀(θ) − 1` is a **square wave** in the phase: `+1` iff `cos φ ≤ 0`. Its Fourier content is
the odd harmonics, so the weighted sum becomes

```
Σ_p (log p) p^{−1/2} (2δ₀−1)  =  −(4/π) Σ_{m odd} (−1)^{(m−1)/2}/m · A(m t),
      A(u) = Σ_p (log p) p^{−1/2−iu} .
```

The zero signal therefore reappears at `t = γ_k/m` for odd `m` — **smeared across the
harmonics instead of localised at `γ_k`**. Measured directly: the digit-weighted residual
`|R_d|` at `γ₁` is `77.4` against a median `67.0` (ratio 1.15) with argmax at `11.82`, not
`γ₁`. The constant-weight residual at the same point gives ratio `7.91` with argmax exactly
`γ₁`.

That is a quantitative statement, not a technicality: **the digit map is a discontinuous
recoding of the folded phase, and discontinuity in the phase = harmonic spreading in `t`.**
The prime route works precisely because `−ζ′/ζ` localises at a single frequency; the digit
map destroys that localisation. The two facts are the same fact.

## 4. The support-only statistic is `t`-free

Count of primes with `δ₀ = 1` over `t ∈ [γ₁−2.5, γ₁+2.5]`: at `γ₁` it is `37908` against a
median of `39231` (≈ `π(X)/2 = 39249` ✓), with a min–max spread of `24 %` — no correlation
with the zeros. This confirms Advisor 1's core claim in the form in which it survives: the
*support alone* carries no zero information.

## 5. The contrast is confirmed

The all-n side is a **dip**, not a peak: `|η_N(1/2 + iγ₁)| = 0.0079` against a window median
of `2.0391`, argmin at `14.1397`. So: arithmetic (prime) sum → peak growing like `log X`;
plain sum → zero.

## What this settles

- **Confirmed:** the prime sum detects `γ₁` with the explicit-formula `log X` signature, and
  the mechanism (the multiplicative cocycle lives on the primes) is right.
- **Refuted:** that the *digit-word* statistic over primes shows a corresponding anomaly. It
  does not, at `|z| ≤ 1.6`, and the obstruction is structural (harmonic spreading under a
  discontinuous phase recoding), not numerical.
- **Closed:** the last route the debate left open. The greedy digit map cannot carry the zero
  signal from the primes to the words, for the same reason it fails everywhere else in this
  programme: it is an exact, discontinuous recoding of the phase, and the localisation the
  explicit formula needs does not survive it.

*Status — NUMERICAL, with a matched theoretical prediction (`|R(γ₁)| = log X + O(1)` from the
pole residue) and a matched null test (10 zeros vs 400 random heights, Bonferroni-corrected).
MECHANISM: verified by direct measurement of the harmonic smearing. OPEN: nothing in this
route; the prime sum itself is classical explicit-formula territory.*
