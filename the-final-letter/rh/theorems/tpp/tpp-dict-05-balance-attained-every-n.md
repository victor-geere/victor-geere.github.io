# P8 — balance is attained for every N ≥ 2

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P8 (source round rh43)

## Statement

> balance is attained for every `N ≥ 2` (`N=2` exactly at `π/log 2`; `N=3,4` by IVT)

## Hypotheses and notation

- `N` is the truncation length of the partial sum.
- `IVT` = the intermediate value theorem; `π/log 2` is the exact location of the balance point for `N = 2`.
- "Balance" is the balance condition of the programme (cf. P7).

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean), sourced to round rh43. No proof text or declaration names are given in the dictionary.

## Dependencies and related results

- P7 (the balance identity, same dictionary §1) and the equivalence balance ⟺ `Re S_N = 0` recorded there.
- Round rh43 (cited by the ledger as this row's source).

## Notes

- This is a ledger restatement of a result of round rh43 (the dictionary's own id for it is P8).
- The ledger states the methods inside its own statement ("exactly at `π/log 2`", "by IVT"); they are quoted, not added.
