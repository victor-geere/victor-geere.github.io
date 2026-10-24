# R8 (refuted) — the interval count grows like 2^{#{gaps}} in any p-free way

**Kind:** Claim
**Status:** REFUTED (witness list below)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R8

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R8 | the interval count grows like `2^{#{gaps}}` in any `p`-free way | the count is `2^{n_min(p)−1}`, i.e. `1, 2, 4, 16, 128, 1024, 4096, 32768` at `p = 1.5, 2, 2.5, 4, 6, 8, 10, 12` |

## Hypotheses and notation

- The "interval count" is the number of disjoint intervals whose union is the reachable set `S_1` (Theorem 10).
- The refuted claim is that the count is `2^{#{gaps}}` — a function of the support's gaps alone, independent of `p`.
- Correct count: `2^{n_min(p)−1}`, with `n_min(p)` the first complete positive tail (Theorem 7, Theorem 8).

## Proof / evidence

[Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md) proves the count is `2^{n_min(p) − 1}` and the §4 table lists the counts (`1, 2, 4, 16, 128, 1 024, 4 096, 32 768` at `p = 1.5, 2, 2.5, 4, 6, 8, 10, 12`). The §5 note repeats the pattern for first gaps: "at `p = 4` four times (16 intervals), at `p = 12` fifteen times (32 768 intervals) — the census theorem's `2^{n_min−1}`."

## Dependencies and related results

- [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md), [Theorem 7 (unimodality)](tpp-rh42-truths-theorem-7-unimodality.md).
- The exponent dependence is exactly what makes the count `p`-dependent, since `n_min(p)` grows with `p`.

## Notes

- The witness list in §9 is printed as `1, 2, 4, 16, 128, 1024, 4096, 32768`; the §4 table prints the same values with thin-space thousands separators (`1 024`, `4 096`, `32 768`). Both forms are reproduced above, each in its own location.
