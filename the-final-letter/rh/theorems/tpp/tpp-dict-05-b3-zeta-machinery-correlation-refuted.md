# B3 — the ζ-machinery applies to the correlation (refuted)

**Kind:** Claim
**Status:** REFUTED
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §2 "The bridges, each disposed of", row B3

## Statement

> | bridge | claim | disposal |
> |---|---|---|
> | **B3** | the `ζ`-machinery applies to the correlation | **REFUTED**: `f` is not multiplicative; `D(2) = −1.12681304` vs naive product `0.88757352`, discrepancy `2.0144` against tail `1.84·10⁻⁵` |

## Hypotheses and notation

- `f(n) = λ(n)λ(n+2)` is the twin-prime correlation function (cf. P17).
- `D(2)` is the programme's Dirichlet-series-type quantity at the value `2`; the ledger compares it with the naive Euler product `0.88757352`.
- The discrepancy quoted is `2.0144`, against a tail `1.84·10⁻⁵`.

## Proof / evidence

- The ledger records the disposal as **REFUTED**, with the numerical comparison `D(2) = −1.12681304` vs `0.88757352`, discrepancy `2.0144`, tail `1.84·10⁻⁵`. No further derivation is given in the dictionary.

## Dependencies and related results

- P17 (the correlation is not multiplicative; no Euler product), which the ledger marks THEOREM (Lean) + NUMERICAL for round rh46 — the positive counterpart of this refutation.
- Cited in §3 (N2) of the same dictionary among the proved structure theorems ("the correlation has no Euler product (P17)").

## Notes

- This entry harvests a *refutation*: the bridge claim is the refuted proposition, and its honest status is REFUTED. It is not a positive theorem of the programme.
- The numbers `−1.12681304`, `0.88757352`, `2.0144` and `1.84·10⁻⁵` are quoted exactly from the ledger.
