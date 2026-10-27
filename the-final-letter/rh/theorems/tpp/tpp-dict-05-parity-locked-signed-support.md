# P5 — the signed support is parity-locked

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P5 (source round rh42)

## Statement

> the signed support is **parity-locked** (gaps even `≥ 2`)

## Hypotheses and notation

- "Signed support" is the set of indices at which the signed (Tau) greedy rule takes a term; a gap is a gap of that support.
- "Parity-locked" means every take of a positive target sits at an even index and every take of a negative target at an odd index, so every support gap is even and at least `2`.
- The alphabet used in the round-rh42 statement is `α_n = (−1)^n/(n+2)^p` for the signed word; the dictionary row does not restate it.

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean), sourced to round rh42. No proof text or declaration names are given in the dictionary.

## Dependencies and related results

- Round rh42 (cited by the ledger as this row's source).
- Harvested in full from that round as [Theorem 14 (parity lock, T9)](tpp-rh42-truths-theorem-14-parity-lock.md).
- Used later in §3 (N2) of the same dictionary.

## Notes

- This is a ledger restatement of a result of round rh42 (the dictionary's own id for it is P5).
