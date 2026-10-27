# Theorem 1 (Euler–Maclaurin, full first terms)

**Kind:** Theorem
**Status:** PROVED (paper argument, Euler–Maclaurin; each coefficient checked exactly and the limit VERIFIED numerically)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §1 "The sharp cutoff (T1)", line 42

## Statement

For `s = 1/2 + it` and any fixed `t`, as `N → ∞`

```
S_N(s) − ζ(s) = N^{1−s}/(1−s) + (1/2)N^{−s} − (s/12)N^{−s−1} + …
```

hence

> `|S_N(s) − ζ(s)| = √N/|s−1| + O(1)` and `|S_N−ζ|/√N → 1/|s−1| = 1/√(1/4+t²)`.

At a zero `ζ(1/2+it) = 0`, the partial sum is therefore `≈ √N/|s−1|` — it never "sees" the zero; the zero appears only after the cancellation `ζ − S_N = −√N/|s−1| + O(N^{−1/2})`.

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum of the Riemann zeta function `ζ`.
- `s = 1/2 + it` on the critical line, with `t` fixed.
- The displayed series is the Euler–Maclaurin expansion of the partial sum; the source writes `R_1`, `R_2` for the successive correction terms it checks exactly at `N = 102400` (it does not label which displayed term each `R_k` is).
- The ledger label for this section is **T1** ("The sharp cutoff (T1)").

## Proof / evidence

The source's status line: "**PROVED** (Euler–Maclaurin), **VERIFIED**". Each coefficient is checked exactly at `N = 102400`: `|R_1|·√N = 0.49999959` (against `1/2`) and `|R_2|·N^{3/2} = 1.178630488` (against `|s|/12 = 1.178630487`). The phase also matches: `|S_N|√(1/4+t²)/√N → 1.00000244` and `arg S_N + t log N − arctan(2t) → −6.9·10^{−5}`.

The source's table of `|S_N−ζ|/√N` at `N = 10^2, 10^3, 10^4, 10^5`:

| `t` | `1/√(1/4+t²)` | measured `\|S_N−ζ\|/√N` |
|---|---|---|
| 14.134725141734693 | 0.0707035277318 | 0.0709386, 0.0707218, 0.07070530, 0.07070370 |
| 21.022039638771555 | 0.0475556741611 | 0.0477615, 0.0475684, 0.04755687, 0.04755579 |

## Dependencies and related results

- [R1 — the sharp fluctuation constant is `1/√(2t)`](tpp-rh044-truths-r1-sharp-fluctuation-constant.md) — refuted; this theorem supplies the correcting constant `1/|s−1|`.
- [R3 — the scaled ratio `|S_N|·√(2t)/√N → 1`](tpp-rh044-truths-r3-sharp-scaled-ratio-limit.md) — refuted by the same constant.
- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the smoothing generalisation; the sharp cutoff `φ ≡ 1` is its `M_φ(s) = 1/(s−1)` case.
- [README fact 1 — the sharp cutoff is the Euler–Maclaurin main term](tpp-rh044-readme-fact-1-sharp-cutoff-euler-maclaurin.md) — restates this result.
- The source frames the result as repairing the gap of `../rh43/truths.md` §7.6 (cited by the source, outside this harvest's source set).

## Notes

- Status is the source's `PROVED` (Euler–Maclaurin), with its independent numerical verification recorded alongside; the exact coefficient checks are the source's.
- The remainder `O(1)` in `|S_N(s) − ζ(s)| = √N/|s−1| + O(1)` is the source's own; the README states the same expansion with remainder `O(N^{−1/2})`.
- The source draws the consequence that at a zero the sharp partial sum is `≈ √N/|s−1|` and "never sees the zero".
