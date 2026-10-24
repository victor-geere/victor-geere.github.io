# P1 — the factor-complexity law

**Kind:** Theorem
**Status:** PROVED (Lean, 144 declarations)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P1 (source round rh41)

## Statement

> the factor-complexity law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for `L ≥ a_m+1`

## Hypotheses and notation

- `p(L)` is the factor complexity (number of distinct factors of length `L`) of the greedy word of round rh41.
- `a_m` and `N` are the greedy word's own parameters; the dictionary does not restate their definitions.
- `[·]` is the indicator of the bracketed condition.
- The law is asserted for `L ≥ a_m+1`.

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean, 144 declarations), with source round rh41. The dictionary supplies no proof text and names no individual Lean declaration.

## Dependencies and related results

- Round rh41, cited by the ledger as the source of this row; the dictionary links no other harvested file for it.

## Notes

- This is a ledger restatement of a result of round rh41 (the dictionary's own id for it is P1); the entry carries no proof and no declaration names.
- The ledger's own qualifier, "Lean, 144 declarations", is reproduced exactly in the Status line; the dictionary does not name the declarations.
