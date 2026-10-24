# `f(n) = λ(n)λ(n+2)` is not multiplicative; no Euler product

**Kind:** Theorem
**Status:** PROVED (Lean; source records THEOREM (Lean) + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F3, line 105

## Statement

The ledger row, verbatim:

> | F3 | `f(n) = λ(n)λ(n+2)` is **not multiplicative**; no Euler product | THEOREM (Lean) + NUMERICAL (`D(2)` discrepancy `2.0144`) | rh46 |

## Hypotheses and notation

- `f(n) = λ(n)λ(n+2)`, with `λ` the Liouville function (which *is* completely multiplicative — [Lemma 2.1](tpp-dict-01-liouville-completely-multiplicative.md)).
- "Not multiplicative" is the ledger's assertion; the consequence recorded is: **no Euler product**.
- The numerical certificate quoted exactly is the `D(2)` discrepancy `2.0144`.

## Proof / evidence

The ledger records `THEOREM (Lean) + NUMERICAL` with source `rh46` and gives no proof. The capstone chapter records the same as [P17 — the correlation is not multiplicative](tpp-dict-05-correlation-not-multiplicative.md) (PROVED (Lean; plus numerical component)), with the `D(2)` figures `D(2) = −1.12681304` against the naive `0.88757352`.

## Dependencies and related results

- [Lemma 2.1 (multiplicativity)](tpp-dict-01-liouville-completely-multiplicative.md) — the contrast: `λ` is completely multiplicative, `f` is not.
- [(P4) Abel/partial summation](tpp-dict-01-abel-partial-summation.md) — the failure of the converse is the recorded reason the Euler-product route is dead (source [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §3, §5).
- [F8 — the ζ-machinery does not apply to the correlation](tpp-dict-00-bridge-b3-zeta-machinery.md).

## Notes

- Ledger entry restating round **rh46**.
- The discrepancy `2.0144` is a finite numerical figure; the ledger's primary status for the non-multiplicativity itself is Lean.
