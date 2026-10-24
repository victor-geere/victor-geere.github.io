# P17 — the correlation is not multiplicative (no Euler product)

**Kind:** Theorem
**Status:** PROVED (Lean; plus numerical component)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P17 (source round rh46)

## Statement

> `f(n) = λ(n)λ(n+2)` is **not multiplicative**; no Euler product (`D(2)` off by `2.0144`)

## Hypotheses and notation

- `λ` is the Liouville function; `f(n) = λ(n)λ(n+2)` is the twin-prime correlation function.
- `D(2)` is the programme's Dirichlet-series-type quantity at the value `2`; the ledger reports it is "off by `2.0144`" from the naive Euler product.
- The row is marked THEOREM (Lean) + NUMERICAL.

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean) + NUMERICAL, sourced to round rh46. No proof text, declaration names or precision figure are given in the dictionary.

## Dependencies and related results

- Round rh46 (cited by the ledger as this row's source).
- Used in the same dictionary's §2 (B3), which adds the numerical detail `D(2) = −1.12681304` against the naive product `0.88757352`, discrepancy `2.0144`, against a tail `1.84·10⁻⁵` (harvested as [B3](tpp-dict-05-b3-zeta-machinery-correlation-refuted.md)).
- Used in §3 (N2): "the correlation has no Euler product (P17)".

## Notes

- This is a ledger restatement of a result of round rh46 (the dictionary's own id for it is P17).
- The discrepancy figure `2.0144` is quoted exactly as in the ledger.
