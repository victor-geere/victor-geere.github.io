# P16 — finite-prefix indeterminacy

**Kind:** Theorem
**Status:** PROVED (Lean slice layer)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P16 (source round rh46)

## Statement

> **finite-prefix indeterminacy**: `λ'' = λ` on `[1,10⁸]`, `1` beyond, has `S''/x → 1`

## Hypotheses and notation

- `λ` is the Liouville function; `λ''` is the function that agrees with `λ` on `[1,10⁸]` and equals `1` beyond `10⁸`.
- `S''` is the partial-sum function built from `λ''`; the conclusion is `S''/x → 1`.
- The ledger records the proof layer as "Lean slice layer".

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean slice layer), sourced to round rh46. No proof text or declaration names are given in the dictionary.

## Dependencies and related results

- Round rh46 (cited by the ledger as this row's source).
- Used in the same dictionary's §3 (N1): "`λ''` agreeing with `λ` on `[1,10⁸]` has `S''(x)/x → 1` (P16), so prefix data cannot decide the asymptotic."
- §5 of the same dictionary calls this "the **certified finite-prefix theorem** (its one clean new theorem for the parity side) showing that no computation can decide `o(x)`".

## Notes

- This is a ledger restatement of a result of round rh46 (the dictionary's own id for it is P16).
- The bound `10⁸` and the limit `1` are quoted exactly.
- The dictionary's §5 language calls it "certified"; the ledger row's own qualifier is "Lean slice layer", reproduced in the Status line.
