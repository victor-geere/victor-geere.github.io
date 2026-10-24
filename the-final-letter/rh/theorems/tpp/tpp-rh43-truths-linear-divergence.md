# Theorem 12 (linear divergence)

**Kind:** Theorem
**Status:** PROVED (paper argument, first-order Euler summation) + VERIFIED (numerical, certified values)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §4 "Why only finite partial sums: the series diverges" (ledger row T12)

## Statement

> **Theorem 12 (linear divergence).** For every real `t`, `S_N(t)` does not converge as `N -> infinity` in the ordinary sense; in fact
>
> ```
> |S_N(t)| / N  ->  1 / sqrt(1 + t^2)      (Euler summation: the main term of
>                                           sum_{n<=N} n^{-it} is N^{1-it}/(1-it))
> ```
>
> **PROVED** (first-order Euler summation gives `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N` with `|R_N| <= (|t|/2) log N`, hence `|S_N| >= N/sqrt(1+t^2) - (|t|/2) log N - O(1) -> infinity`), **VERIFIED** by the auditor with certified values (`|S_10| = 7.845596, |S_100| = 70.798738, |S_1000| = 707.396987`, `|S_{10^4}| = 7071.771405` at `t = 1`, against `1/sqrt 2 = 0.70710678`, with a maximum deviation of `5.44e-7` at `N = 10^6`), and empirically in the script §6.

> The naive picture `|S_N| ~ sqrt N` belongs to `Re(S) = 1/2`, not to `Re(S) = 0`; at `Re(S) = 0` the sum grows **linearly**. The "partial sum" of the question is therefore necessarily a *finite* one.

## Hypotheses and notation

- `t` real fixed; `S_N(t) = sum_{n=1}^{N} n^{-it}`.
- Euler-summation expansion: `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N` with `|R_N| <= (|t|/2) log N`.
- The claimed limit is `|S_N(t)|/N -> 1/sqrt(1+t^2)`; certified values at `t = 1`, compared against `1/sqrt 2 = 0.70710678`.

## Proof / evidence

- **PROVED** by first-order Euler summation (the written argument is quoted in full above).
- **VERIFIED** by the auditor with the certified values above; the maximum deviation is `5.44e-7` at `N = 10^6`.
- Ledger row T12: status "**PROVED**+**VERIFIED**", evidence "§4, auditor C6"; the script's empirical check is §6.
- HANDOFF.md §2.4 records this as the third trap: "`|S_N(t)|/N → 1/√(1+t²)` (certified: `|S_{10^4}(1)| = 7071.771405`), so the series is not ordinarily summable at `Re(S) = 0`".

## Dependencies and related results

- Refuted statement [F5](tpp-rh43-truths-f5-sqrt-n-growth-refuted.md) ("`|S_N(t)|` grows like `N^{1/2}`") is the negation of this result's contrast with `Re(S) = 1/2`.
- Related: [The N -> infinity asymptotic of the split](tpp-rh43-truths-n-to-infinity-asymptotic-split.md) (T15), which uses the same Euler-summation remainder.

## Notes

- The source quotes the growth as *linear* with coefficient `1/sqrt(1+t^2)`; the assertion "does not converge in the ordinary sense" follows from the divergence of `|S_N|`.
- The source's own §9/§4 warning: "The naive picture `|S_N| ~ sqrt N` belongs to `Re(S) = 1/2`, not to `Re(S) = 0`."
