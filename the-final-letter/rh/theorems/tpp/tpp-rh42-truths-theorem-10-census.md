# Theorem 10 (census, new)

**Kind:** Theorem
**Status:** PROVED (paper argument; machine-checked finite form; VERIFIED to 3.9·10⁻⁶² on every endpoint)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §4 "The census theorem: exactly which targets are writable"

## Statement

> With `a_k = (2k)^{−p}`, `S_n` the sub-sum set of `a_n, a_{n+1}, …`, and
> `T_n = Σ_{k≥n} a_k`,
>
> ```
> S_n = [0, T_n]                              for every n ≥ n_min(p),
> S_n = S_{n+1} ∪ (a_n + S_{n+1})             with the two pieces DISJOINT for n < n_min(p),
> ```
>
> hence
>
> ```
> S_1  is a union of exactly  2^{n_min(p) − 1}  disjoint intervals,
> measure(S_1) = 2^{n_min(p) − 1} · T_{n_min(p)},
> S_1 = ⋃_{A ⊆ {1,…,n_min−1}} ( Σ_{k∈A} a_k + [0, T_{n_min}] ).
> ```

## Hypotheses and notation

- `a_k = (2k)^{−p}` — the positive half-series (even indices of `ζ`), `p > 1`.
- `S_n` — the set of sub-sums of `a_n, a_{n+1}, …` (arbitrary subsets, infinite included).
- `T_n = Σ_{k≥n} a_k` — the tail sum from `n`.
- `n_min(p)` — the first complete positive tail (Theorem 7, Theorem 8).
- `measure` is Lebesgue measure; the union in the last line is over all subsets `A ⊆ {1,…,n_min−1}`, and `T_{n_min}` is written for `T_{n_min(p)}` in the source's display.

## Proof / evidence

> **PROVED** (Brown's criterion gives the complete tails; for `n < n_min` one has
> `h(n) < 0`, i.e. `a_n > T_{n+1} = T_n − a_n`, so `S_{n+1} ⊆ [0,T_{n+1}]` and
> `a_n + S_{n+1} ⊆ [a_n, T_n]` cannot meet, and each level doubles the count;
> machine-checked in the finite form `subSums_cons_disjoint`). **VERIFIED** in [`reachable.py`](../../research/twin-prime-parity/rounds/rh42/reachable.py) §2 by
> two independent routes — the census formula and the plain recursion
> `S_k = S_{k+1} ∪ (a_k + S_{k+1})` — agreeing to `3.9·10⁻⁶²` on every endpoint, for
> thirteen exponents from `p = 1.2` to `p = 12`.

The source's §4 table (reproduced values exactly as printed):

| `p` | `P(p)` | `n_min` | #intervals | measure | measure/P |
|---|---|---|---|---|---|
| 1.2 … 1.7 | 2.434 … 0.632 | 1 | 1 | `P` | **1.000** |
| 1.8 | 0.540529 | 2 | 2 | 0.506708 | 0.937430 |
| 2 | 0.411234 | 2 | 2 | 0.322467 | 0.784146 |
| 2.2 | 0.324398 | 2 | 2 | 0.213521 | 0.658207 |
| 2.5 | 0.237144 | 3 | 4 | 0.116468 | 0.491128 |
| 3 | 0.150257 | 3 | 4 | 0.0385285 | 0.256417 |
| 4 | 0.0676452 | 5 | 16 | 0.00357130 | 0.0527946 |
| 6 | 0.0158960 | 8 | 128 | 1.64918·10⁻⁵ | 0.00103748 |
| 8 | 0.00392218 | 11 | 1 024 | 3.97707·10⁻⁸ | 1.013996·10⁻⁵ |
| 10 | 0.000977534 | 13 | 4 096 | 5.82549·10⁻¹¹ | 5.959375·10⁻⁸ |
| 12 | 0.000244201 | 16 | 32 768 | 5.73073·10⁻¹⁴ | 2.346729·10⁻¹⁰ |

## Dependencies and related results

- [Theorem 6 (Brown's criterion)](tpp-rh42-truths-theorem-6-brown-criterion.md) gives the complete tails; [Theorem 7 (unimodality)](tpp-rh42-truths-theorem-7-unimodality.md) gives `h(n) < 0` for `n < n_min`.
- Supplies the structure used in Theorem 12 (`p = 2`), Theorem 13 (`p = 3`), and the refuted rows R7, R8.
- Handoff ledger row T11 (§11): "at `p = 2` the reachable set is one-gap", PROOF-SKETCH → **PROVED** (Theorem 10) + **VERIFIED** exactly; row T12: "at `p = 3` the reachable set is the four intervals", VERIFIED → **PROVED** (Theorem 10) + **VERIFIED** exactly.

## Notes

- The source states that the negative half "obeys the same census with its own `n_min^odd` (1, 1, 2, 2, 3, 4, 7 at `p = 1.5, 2, 2.2, 2.5, 3, 4, 6`) and thresholds `q`."
- The source's emphasized conclusion, quoted verbatim: "**The reachable fraction of the budget collapses to zero as `p → ∞`**: at high exponent almost no sine is writable even though the budget is positive."
- The verification precision `3.9·10⁻⁶²` and the range "thirteen exponents from `p = 1.2` to `p = 12`" are quoted exactly.
