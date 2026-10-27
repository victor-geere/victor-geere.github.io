# P3 — Brown's criterion

**Kind:** Theorem
**Status:** PROVED (one-step lemmas in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P3 (source round rh42)

## Statement

> **Brown's criterion**: sub-sums fill `[0,A]` ⟺ `a_k ≤ T_{k+1}` ∀`k`

## Hypotheses and notation

- The dictionary row does not restate the sequence hypotheses; they are the ones carried by the round-rh42 statement of the criterion (harvested as [Theorem 6](tpp-rh42-truths-theorem-6-brown-criterion.md)): `a_1 ≥ a_2 ≥ … > 0` with `A = Σ a_n < ∞`.
- `T_{k+1}` is the tail after `a_k`; "sub-sums fill `[0,A]`" means the set of all sub-sums of the sequence is exactly the interval `[0,A]`. These readings are taken from that same rh42 statement, not restated by the dictionary.
- The ledger notes only that the one-step lemmas are in Lean.

## Proof / evidence

- The ledger records the status as **THEOREM** (one-step lemmas in Lean), sourced to round rh42. No proof text is given in the dictionary.

## Dependencies and related results

- Round rh42 (cited by the ledger as this row's source).
- Harvested in full from that round as [Theorem 6 (Brown's criterion, T10/T13 core)](tpp-rh42-truths-theorem-6-brown-criterion.md).

## Notes

- This is a ledger restatement of a result of round rh42 (the dictionary's own id for it is P3).
- The ledger attributes the criterion to Brown by name and marks it THEOREM; it is recorded here as a ledger row with that status, not as a bare literature mention.
