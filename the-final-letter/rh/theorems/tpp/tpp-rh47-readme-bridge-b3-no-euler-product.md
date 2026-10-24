# B3 — the `ζ`-machinery does not apply to the correlation (README): no Euler product

**Kind:** Claim
**Status:** REFUTED (no Euler product; `D(2)` differs from the naive product by `≈2.01`, beyond the tail bound)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) — §2 table "The bridge the goal needs — and the barrier", row **B3**, line 57

## Statement

> | bridge | statement | status |
> |---|---|---|
> | **B3** | the `ζ`-machinery applies to the correlation | **no Euler product**: `f(n) = λ(n)λ(n+2)` is not multiplicative (`f(1) ≠ 1`, coprime counterexamples); `D(2)` differs from the naive product by `≈2.01`, beyond the tail bound |

## Hypotheses and notation

- `f(n) = λ(n)λ(n+2)`, with `λ(n) = (−1)^{Ω(n)}` the Liouville function.
- `D(2)` is the correlation Dirichlet series at `s = 2`; the source's ledger prints `D(2) = Σ_{n≤10⁶} f(n)/n² = −1.12681304` against a naive multiplicative model `0.88757352`.
- The refined discrepancy is `2.01438655` against a rigorous tail `1.84·10⁻⁵` (truths.md §2); the README quotes `≈2.01`.

## Proof / evidence

The README records the failure of multiplicativity (`f(1) ≠ 1` and coprime counterexamples) and the Dirichlet-series discrepancy `≈2.01` beyond the tail bound; the full computation is in `truths.md` §2 and in [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) → `verify/greedy_parity_probe.log` (**23/23 checks**, exit 0).

## Dependencies and related results

- [truths.md B3 §2](tpp-rh47-truths-bridge-b3-no-euler-product.md) — the full numerical account.
- [README B1](tpp-rh47-readme-bridge-b1-no-signal.md) and [README B2](tpp-rh47-readme-bridge-b2-index-parity-independent.md) — the other two bridge rows.
- [README barrier](tpp-rh47-readme-barrier-additive-character-open.md).
- Restated in HANDOFF: [B3 "REFUTED as a route"](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md), with the discrepancy `2.0144` at `s=2`.
- Earlier ledger row: [bridge B3](tpp-dict-00-bridge-b3-zeta-machinery.md).

## Notes

- The README gives the coarse figure `≈2.01`; the ledger's finer value is `|difference| = 2.01438655`, and HANDOFF quotes `2.0144`. All three are the same measurement at different precision.
- The source states no analytic proof; the obstruction `f(1) ≠ 1` is exact and the rest is numerical.
