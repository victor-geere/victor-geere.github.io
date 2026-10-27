# T18 — the greedy support is Sylvester-sparse

**Kind:** Theorem
**Status:** PROVED (paper argument; NUMERICAL, verified internally: 0 violations in 53 159 consecutive pairs)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.1, row T18 of the "What is proved" table

## Statement

> **T18** — the greedy support is **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1`, so `A(N) = O(log log N)`.

The row's status and provenance: THEOREM (+ NUMERICAL) | programme-internal: `rh47/truths.md` §1, [`02`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) Thm 4.1 | **verified internally** (prose proof + 0 violations in 53 159 consecutive pairs).

## Hypotheses and notation

- `m_i` are the elements of the greedy support (the support of the signed greedy support of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) Theorem 2.3).
- `A(N) = #{m ≤ N : m ∈ A}` is the counting function of the support.
- "Sylvester-sparse" refers to the Sylvester-type recursion `m_{i+1} ≥ m_i(m_i−1)+1`, which forces doubly exponentially growing elements and hence `A(N) = O(log log N)`.

## Proof / evidence

- The row records a **prose proof** in `rh47/truths.md` §1 and dictionary file `02` Theorem 4.1, together with a numerical verification: "0 violations in 53 159 consecutive pairs".
- The source's status is "THEOREM (+ NUMERICAL)" with the parenthetical "**verified internally**".

## Dependencies and related results

- [Corollary 6.1](tpp-dict-03-corollary-6-1-greedy-support-loglog.md) combines this row with [F5](tpp-dict-03-f5-corrected-sparse-bound.md) to show the greedy support cannot be a positive-density witness.
- The `rh47/truths.md` §1 and §4 material and [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) Theorem 4.1 are the programme-internal context; barrier rows [F5](tpp-dict-03-f5-corrected-sparse-bound.md) and [F6](tpp-dict-03-f6-no-signal-greedy-support.md) are the companions that use it.

## Notes

- This is a **programme-internal** result (not literature): the source attributes it to `rh47/truths.md` §1 and `02` Thm 4.1, and records it as verified internally with a prose proof plus a numerical check (0 violations in 53 159 consecutive pairs).
- The numerical component is a finite check; the recursion is the mathematical content.
