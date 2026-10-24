# R7 (refuted) — the reachable set has measure P(p) for every p

**Kind:** Claim
**Status:** REFUTED (false for every p > p*)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R7

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R7 | the reachable set has measure `P(p)` for every `p` | false for every `p > p*`; measure `= 2^{n_min−1} T_{n_min}` (Theorem 10) |

## Hypotheses and notation

- `P(p) = Σ_{k≥1} (2k)^{−p}` — the positive budget.
- `p* = 1.7286472389981836181…` — the completeness threshold of Theorem 8 (`ζ(p*) = 2`).
- `n_min = n_min(p)`; `T_{n_min} = Σ_{k≥n_min} (2k)^{−p}`.
- The correct measure is `measure(S_1) = 2^{n_min(p) − 1} · T_{n_min(p)}` (Theorem 10).

## Proof / evidence

[Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md) proves the measure formula `measure(S_1) = 2^{n_min(p) − 1} · T_{n_min(p)}`, which coincides with `P(p)` only while `n_min(p) = 1`, i.e. for `p ≤ p*` (Theorem 8).

## Dependencies and related results

- [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md), [Theorem 8 (completeness thresholds, T10, T13)](tpp-rh42-truths-theorem-8-completeness-thresholds.md).
- The §4 table shows the collapse: `measure/P` = `0.937430` at `p = 1.8`, `0.784146` at `p = 2`, down to `2.346729·10⁻¹⁰` at `p = 12`.

## Notes

- The row's witness says "false for every `p > p*`" — the failure is exactly for exponents past the positive-half completeness threshold.
- "Smallest witness" in the row is a scope statement plus the corrected formula, not a single finite object.
