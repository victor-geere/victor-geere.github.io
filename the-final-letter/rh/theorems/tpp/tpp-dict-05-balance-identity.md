# P7 — the balance identity

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P7 (source round rh43)

## Statement

> the balance identity `P_N + M_N = Re S_N`, and balance ⟺ `Re S_N = 0`

## Hypotheses and notation

- `P_N` and `M_N` are the two partial sums entering the balance criterion of round rh43; `S_N` is the corresponding complex partial sum (the dictionary does not restate their definitions).
- `Re` denotes the real part.
- "Balance" is the balance condition of the programme; the ledger states it is equivalent to `Re S_N = 0`.

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean), sourced to round rh43. No proof text or declaration names are given in the dictionary.

## Dependencies and related results

- Round rh43 (cited by the ledger as this row's source); the dictionary links no harvested file for it.

## Notes

- This is a ledger restatement of a result of round rh43 (the dictionary's own id for it is P7).
- The dictionary gives the identity and the equivalence but no definitions of `P_N`, `M_N`, `S_N`; they are not invented here.
