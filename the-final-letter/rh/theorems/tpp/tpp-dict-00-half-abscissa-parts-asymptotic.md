# at `σ = 1/2` the parts are `~ (2/π)√N`; the sharp error is `√N/|s−1|`

**Kind:** Theorem
**Status:** PROVED (paper argument; source records THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D9, line 85

## Statement

The ledger row, verbatim:

> | D9 | at `σ = 1/2` the parts are `~ (2/π)√N`; the sharp error is `√N/\|s−1\|` | THEOREM + NUMERICAL | rh43 §7.6, [`../../../rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) |

## Hypotheses and notation

- The abscissa is `σ = 1/2`, i.e. the critical line; `s = σ + it` and the partial sums are those of the Dirichlet series at that abscissa.
- "The parts" are the positive/negative-signed parts of the partial sums (the balance split of row D1, a **DEFINITION**, not harvested), whose size is recorded as `~ (2/π)√N`.
- The sharp error against `ζ(1/2+it)` is `√N/|s−1|`; at `σ = 1/2` this equals `√N/√(1/4+t²)` — the constant of [(P3)](tpp-dict-01-critical-line-truncation-error.md).

## Proof / evidence

The ledger records `THEOREM + NUMERICAL` with sources `rh43 §7.6` and `rh044/truths.md` (workspace path `../rounds/rh044/truths.md` from the dictionary), and gives no proof. The capstone chapter records the sharp-error half as [P10 — the sharp error at a zero](tpp-dict-05-sharp-error-at-a-zero.md) and the zeta-relations chapter as [the sharp error at a zero](tpp-dict-04-sharp-error-at-a-zero.md).

## Dependencies and related results

- [(P3) The Dirichlet series on the critical line](tpp-dict-01-critical-line-truncation-error.md).
- [The sharp constant `1/|s−1|`, not `1/√(2t)`](tpp-dict-00-sharp-constant-refuted.md) (E2) is the correction attached to this constant.
- [Linear growth at `σ = 0`](tpp-dict-00-linear-growth-of-sn.md) (D8) is the companion asymptotic at the other abscissa.

## Notes

- Ledger entry restating rounds **rh43 (§7.6)** and **rh044**.
- The row states two separate asymptotic facts (the size `~ (2/π)√N` of the parts and the sharp error `√N/|s−1|`) in one ledger line; both are preserved here together, as the source gives them.
