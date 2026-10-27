# P11 — smoothing does not remove √N

**Kind:** Theorem
**Status:** PROVED (asymptotic; plus numerical component)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P11 (source round rh044)

## Statement

> **smoothing does not remove `√N`**: `|S_N^φ−ζ|/√N → |M_φ(s)|`

## Hypotheses and notation

- `S_N^φ` is the smoothed partial sum with smoothing kernel `φ`; `ζ = ζ(s)` is the zeta value being approximated.
- `M_φ(s)` is the transform of the smoothing kernel `φ` that appears as the limit; the dictionary row does not define it further.
- The convergence `→` is an asymptotic statement in `N`; the ledger marks the row THEOREM (asymptotic) + NUMERICAL.
- `|·|` denotes modulus (the source escapes the bars as `\|` inside its table).

## Proof / evidence

- The ledger records the status as **THEOREM** (asymptotic) + NUMERICAL, sourced to round rh044. The dictionary gives no proof text, declaration names or numerical precision.

## Dependencies and related results

- Round rh044 (cited by the ledger as this row's source).
- Related same-dictionary rows: P10 (sharp error at a zero) and P12 (exponential accuracy requires the functional equation).

## Notes

- This is a ledger restatement of a result of round rh044 (the dictionary's own id for it is P11).
- The statement is an asymptotic one; the ledger explicitly labels it "(asymptotic)".
