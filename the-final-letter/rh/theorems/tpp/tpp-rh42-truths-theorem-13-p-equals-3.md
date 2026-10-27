# Theorem 13 (p = 3)

**Kind:** Theorem
**Status:** VERIFIED (exact rational arithmetic; structure from Theorem 10)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §5 "The exact structure at `p = 2` and `p = 3`"

## Statement

> At `p = 3`, `n_min = 3` and
>
> ```
> S_3 = [0, 0.009632112895] ∪ [0.015625, 0.025257112895]
>     ∪ [0.125, 0.134632112895] ∪ [0.140625, 0.150257112895].
> ```

## Hypotheses and notation

- `p = 3`, alphabet/positive half `a_k = (2k)^{−3}`.
- `S_3` — the sub-sum set of `a_3, a_4, …` (indices as in Theorem 10).
- `n_min = 3`; the four intervals are the census decomposition `2^{n_min−1} = 4` of §5.
- The interval endpoints use `ζ(3)` enclosed by exact rationals (Euler–Maclaurin, outward-rounded, width `3.1·10⁻¹⁸`).
- Targets listed as "reach `0`" are exactly the reachable ones; "stall at `x − …`" gives the residual of the unreachable ones.

## Proof / evidence

The source states this as:

> **VERIFIED** exactly: `ζ(3)` is enclosed by exact rationals (Euler–Maclaurin,
> outward-rounded, width `3.1·10⁻¹⁸`) and seven rational targets land exactly where
> the intervals predict (`1/50`, `13/100`, `1/8`, `3/20` reach `0`; `1/20`, `7/50`,
> `1/5` stall at `x − 0.024742887…`, `x − 0.005367887…`, `x − 0.049742887…`).

The structural form (four intervals at `n_min(3) = 3`) is proved by [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md); the handoff ledger row T12 records the transition from VERIFIED to **PROVED** (Theorem 10) + **VERIFIED** exactly.

## Dependencies and related results

- [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md); the interval count `2^{n_min−1}`.
- Handoff ledger row T12 (§11): "at `p = 3` the reachable set is the four intervals".

## Notes

- The source adds the general remark on first gaps, quoted verbatim: "**The first gap of each exponent.** At `p = 2` it is `(P − a_1, a_1)`; at `p = 3` the recursion runs twice, at `p = 4` four times (16 intervals), at `p = 12` fifteen times (32 768 intervals) — the census theorem's `2^{n_min−1}`."
- All endpoints, widths and stall residuals above are quoted exactly as printed in the source.
