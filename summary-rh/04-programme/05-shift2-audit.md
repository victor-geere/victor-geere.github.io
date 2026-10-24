# The shift-2 odd-core audit

**Source:** [`research/shift2-audit/REPORT.md`](../rh/research/shift2-audit/REPORT.md).
**Status:** closed audit. No proof of Chowla, twin primes, or the odd core.

## Headline correction

The brief’s premise — that `Σ_{n≤x} λ(n)λ(n+1) = o(x)` is a theorem of Matomäki–Radziwiłł–Tao (2015) — is **false**. The primary sources give:

- Matomäki–Radziwiłł, Corollary 2: for every `h ≥ 1`, `(1/X)|Σ_{n≤X}λ(n)λ(n+h)| ≤ 1 − δ(h)` for large `X` — a bound away from `1`, not `o(1)`;
- Matomäki–Radziwiłł–Tao, *An averaged form of Chowla’s conjecture*: “This conjecture remains unproven for any `h₁,…,h_k` with `k ≥ 2`”;
- Tao–Teräväinen: “No further cases of the unweighted Chowla conjecture are currently known” beyond `k = 1` (PNT).

What `h = 1` actually has is a `1−δ` bound, a logarithmically averaged vanishing, an almost-all-scales vanishing, a shift-averaged vanishing, and positive-density sign patterns. Nothing un-averaged.

## The exact split

With `S_h(x) = Σ_{n≤x} λ(n)λ(n+h)` and `C(K) = Σ_{k≤K} λ(2k−1)λ(2k+1)`:

```
S_2(x) = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋)          exactly.
```

Verified numerically with discrepancy `0` at `x = 10³, 10⁵, 10⁷`. Hence

```
S_2 = o(x)  ⟺  S_1 = o(x)  AND  C = o(K),
```

and the core alone does not give shift 2. Both halves are open. The core is the even-`m` half of `Σ λ(m²−1)`, and the `h=1` problem is the odd-`m` half: two halves of one degree-2 polynomial Chowla problem, not two different objects.

## Consequence for the programme

The brief’s “given MRT, shift 2 is equivalent to `C(K)=o(K)`” is valid only **conditionally** on the `h=1` statement, which is open. The audit records this as the `ERRATUM-mrt-misattribution` carried into the programme.

[Back to folder README](summary-rh/04-programme/README.md) · [Back to the summary index](summary-rh/README.md)
