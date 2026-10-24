# T12 — `|S_N(t)|/N -> 1/sqrt(1+t^2)`; no ordinary summability

**Kind:** Theorem
**Status:** PROVED (paper argument, first-order Euler summation) + VERIFIED (numerical, certified values)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T12 (§4, auditor C6)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T12 | `\|S_N(t)\|/N -> 1/sqrt(1+t^2)`; no ordinary summability | **PROVED**+**VERIFIED** | §4, auditor C6 |

The §4 numbered form:

> **Theorem 12 (linear divergence).** For every real `t`, `S_N(t)` does not converge as `N -> infinity` in the ordinary sense; in fact
>
> ```
> |S_N(t)| / N  ->  1 / sqrt(1 + t^2)      (Euler summation: the main term of
>                                           sum_{n<=N} n^{-it} is N^{1-it}/(1-it))
> ```
>
> **PROVED** (first-order Euler summation gives `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N` with `|R_N| <= (|t|/2) log N`, hence `|S_N| >= N/sqrt(1+t^2) - (|t|/2) log N - O(1) -> infinity`), **VERIFIED** by the auditor with certified values (`|S_10| = 7.845596, |S_100| = 70.798738, |S_1000| = 707.396987`, `|S_{10^4}| = 7071.771405` at `t = 1`, against `1/sqrt 2 = 0.70710678`, with a maximum deviation of `5.44e-7` at `N = 10^6`).

## Hypotheses and notation

- `t` real fixed; `S_N(t) = Σ_{n≤N} n^{-it}`.
- Euler-summation expansion `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N`, `|R_N| <= (|t|/2) log N`.
- Certified values at `t = 1`: `|S_10| = 7.845596`, `|S_100| = 70.798738`, `|S_1000| = 707.396987`, `|S_{10^4}| = 7071.771405`; limit constant `1/sqrt 2 = 0.70710678`; max deviation `5.44e-7` at `N = 10^6`.

## Proof / evidence

- Ledger row T12: "**PROVED**+**VERIFIED**", evidence "§4, auditor C6".
- The written proof is the Euler-summation argument quoted above; the auditor's C6 supplies the certified values.

## Dependencies and related results

- The numbered form is [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md).
- Related: [T15 (N -> infinity asymptotic of the split)](tpp-rh43-truths-n-to-infinity-asymptotic-split.md); refuted statement [F5](tpp-rh43-truths-f5-sqrt-n-growth-refuted.md).

## Notes

- Ledger row T12 restates §4 Theorem 12. The source contrasts this with the `sqrt N` picture, which "belongs to `Re(S) = 1/2`".
