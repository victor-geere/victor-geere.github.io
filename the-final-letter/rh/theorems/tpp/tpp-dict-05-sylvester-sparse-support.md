# P18 — the greedy support is Sylvester-sparse

**Kind:** Theorem
**Status:** PROVED (paper argument; plus numerical component)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P18 (source round rh47)

## Statement

> the greedy support is **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1`

## Hypotheses and notation

- The `m_i` are the positions of the greedy support (the indices taken by the greedy rule), in increasing order `m_1 < m_2 < …`.
- "Sylvester-sparse" refers to the Sylvester-type growth `m_{i+1} ≥ m_i(m_i−1)+1`.
- The row is marked THEOREM + NUMERICAL.

## Proof / evidence

- The ledger records the status as **THEOREM** + NUMERICAL, sourced to round rh47. No proof text, declaration names or precision figure are given in the dictionary.

## Dependencies and related results

- Round rh47 (cited by the ledger as this row's source).
- Used in the same dictionary's §3 (N2): "the support is Sylvester-sparse (P18)", and §4, where "its own structure theorems (P18, B2, B4) say why the greedy ones cannot be it".
- §5 of the same dictionary calls this "the **Sylvester-sparsity theorem**, which shows the greedy support is far too thin to be the positive-density witness any proof of `o(x)` would need".

## Notes

- This is a ledger restatement of a result of round rh47 (the dictionary's own id for it is P18).
- The recurrence is quoted exactly: `m_{i+1} ≥ m_i(m_i−1)+1`.
