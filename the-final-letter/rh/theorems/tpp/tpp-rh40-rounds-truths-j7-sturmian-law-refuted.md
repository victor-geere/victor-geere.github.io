# J7 (refuted) — p(L) = L + 1 for all L (Sturmian-like)

**Kind:** Claim
**Status:** REFUTED (impossible — the word is finitely supported, so non-recurrent; Morse–Hedlund forbids it)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J7

## Statement

> `p(L) = L + 1` for all `L` (Sturmian-like)

## Hypotheses and notation

- `p(L)` is the distinct-factor count; a word with `p(L) = L + 1` for all `L` is Sturmian (for a recurrent word).
- The word here is finitely supported and eventually zero (register row C8).

## Proof / evidence

Register row J7's verdict cell reads: "`REFUTED`"; its witness cell reads: "impossible — the word is finitely supported, so non-recurrent; Morse–Hedlund forbids it". The section preamble: "Each was refuted by exact enumeration."

## Dependencies and related results

- Register row C8 (non-recurrence and the Morse–Hedlund citation), C1 (the law holds only for `1 ≤ L ≤ min gap`).
- The ledger records the same law among the closed items (row 27 of `ledger.md` is about `A(N)`, not this law; HANDOFF §5 records the complexity-formula family).

## Notes

- The refutation is structural, not a single witness; do not re-propose this law.
