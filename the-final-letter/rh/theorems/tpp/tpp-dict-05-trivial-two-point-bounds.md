# P15 — the trivial two-point bounds, and o(x) fails for λ ≡ 1

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P15 (source round rh46)

## Statement

> the trivial two-point bounds `|S(x)| ≤ x`, `S(x,0) = x`, and `o(x)` fails for `λ ≡ 1`

## Hypotheses and notation

- `S(x)` is the partial sum of the `λ`-sum under study; `S(x,0)` is the two-argument quantity as the ledger writes it — the dictionary does not define its second slot.
- `λ` is the Liouville function; `λ ≡ 1` is the constant-`1` function replacing it.
- `o(x)` is the assertion `S(x) = o(x)`; the row states that this fails when `λ ≡ 1`.

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean), sourced to round rh46. No proof text or declaration names are given in the dictionary.

## Dependencies and related results

- Round rh46 (cited by the ledger as this row's source).
- Same-dictionary neighbours: P16 (finite-prefix indeterminacy, rh46) and P17 (non-multiplicativity of the correlation, rh46).

## Notes

- This is a ledger restatement of a result of round rh46 (the dictionary's own id for it is P15).
- The ledger itself calls these "trivial"; the word is the source's, not a hedge added here.
- `S(x,0)` is reproduced exactly as the ledger writes it; the dictionary does not define the second slot.
