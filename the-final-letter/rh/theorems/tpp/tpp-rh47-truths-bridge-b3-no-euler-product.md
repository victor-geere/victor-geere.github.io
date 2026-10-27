# B3 — the `ζ`-machinery does not apply to the correlation: no Euler product

**Kind:** Claim
**Status:** REFUTED (the correlation is not multiplicative; the naive Euler product misses by `2.01438655` against a rigorous tail `1.84·10⁻⁵`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §2, "B3 — does the `ζ`-machinery apply to the correlation?  **REFUTED**", line 73

## Statement

> ### B3 — does the `ζ`-machinery apply to the correlation?  **REFUTED**
>
> `f(n) = λ(n)λ(n+2)` is not multiplicative (`f(1) = −1 ≠ 1`; coprime witnesses `f(2)f(11) = −1 ≠ f(22) = 1`, `f(2)f(13) = 1 ≠ f(26) = −1`; 11 942 failing coprime pairs below 200), so there is no Euler product:
>
> ```
> D(2) = Σ_{n≤10⁶} f(n)/n² = −1.12681304      (tail ≤ 1.0·10⁻⁶)
> naive multiplicative model = 0.88757352
> |difference| = 2.01438655 > rigorous tail 1.84·10⁻⁵   (by ~10⁵)
> ```

## Hypotheses and notation

- `f(n) = λ(n)λ(n+2)` with `λ(n) = (−1)^{Ω(n)}` the Liouville function.
- `f(1) = −1 ≠ 1` already blocks multiplicativity (a multiplicative function must satisfy `f(1) = 1`).
- Coprime witnesses: `f(2)f(11) = −1 ≠ f(22) = 1` and `f(2)f(13) = 1 ≠ f(26) = −1`; 11 942 failing coprime pairs below 200.
- `D(2) = Σ_{n≤10⁶} f(n)/n²` with tail `≤ 1.0·10⁻⁶`; the naive multiplicative model value is `0.88757352`; the rigorous tail is `1.84·10⁻⁵`.

## Proof / evidence

Numerical, from [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) → `verify/greedy_parity_probe.log` (**23/23 checks**, exit 0), audited by `verify/independent_check.py` (**31/31 checks**, exit 0). The witness `f(1) = −1` is an exact obstruction; the coprime counterexamples and the 11 942 failing coprime pairs below 200 are enumerated; the Dirichlet-series discrepancy `|difference| = 2.01438655` exceeds the rigorous tail `1.84·10⁻⁵` by ~10⁵.

## Dependencies and related results

- [B1](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md) and [B2](tpp-rh47-truths-bridge-b2-index-parity-independent.md) — the other two bridges.
- [The corrected sparse bound](tpp-rh47-truths-corrected-sparse-bound.md) — shares the rigorous tail `1.84·10⁻⁵`, where the source also notes rh46's stated product tail `1.808988` is mis-derived.
- Restated in this round: [README B3](tpp-rh47-readme-bridge-b3-no-euler-product.md) (`D(2)` differs by `≈2.01`), [HANDOFF B3](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md) (discrepancy `2.0144`).
- Earlier ledger row: [bridge B3](tpp-dict-00-bridge-b3-zeta-machinery.md).

## Notes

- The source's status is **REFUTED**, with the multiplicity failure as the exact obstruction and the Dirichlet-series discrepancy as the quantitative leg.
- The numbers are quoted exactly as printed: `D(2) = −1.12681304`, model `0.88757352`, `|difference| = 2.01438655`, tail `1.84·10⁻⁵` (so the discrepancy exceeds the tail by ~10⁵).
- The source's summary elsewhere rounds this to `2.0144`; the fine value here is the one to use.
