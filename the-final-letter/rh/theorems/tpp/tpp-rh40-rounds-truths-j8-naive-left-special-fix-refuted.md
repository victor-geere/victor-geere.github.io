# J8 (refuted) — the finite-word fix p(L+1) − p(L) = RS(L) − LS(L+1)

**Kind:** Claim
**Status:** REFUTED (fails for every `L` with `Z(L) = 1`, i.e. all of `[N − a_m − 1, N − 1]`; `LS ≡ 0` (C7) so the term does nothing)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J8

## Statement

> The finite-word fix is `p(L+1) − p(L) = RS(L) − LS(L+1)`

## Hypotheses and notation

- `RS(L)` is the right-special count, `LS(L+1)` the left-special count of length `L+1`; `Z(L) = |F(L)| − #{prefixes of F(L+1)}` (register row C3).
- `N` = truncation length; `a_m` = last support position.

## Proof / evidence

Register row J8's verdict cell reads: "`REFUTED`"; its witness cell reads: "fails for every `L` with `Z(L) = 1`, i.e. all of `[N − a_m − 1, N − 1]`; `LS ≡ 0` (C7) so the term does nothing". The section preamble: "Each was refuted by exact enumeration."

## Dependencies and related results

- Register rows C2, C4 (the corrected identity), C7 (`LS ≡ 0`), D4.
- The ledger records the same claim as a mediator error (row 3 of `ledger.md`) and its catch by Agent B.

## Notes

- The correct object is `Z(L)`, "a terminal-uniqueness indicator, **not** a left-special count". Do not re-propose this fix.
