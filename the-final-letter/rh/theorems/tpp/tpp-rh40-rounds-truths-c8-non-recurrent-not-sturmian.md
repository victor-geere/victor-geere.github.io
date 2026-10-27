# C8 — the word is finitely supported, hence non-recurrent, hence not Sturmian

**Kind:** Claim
**Status:** VERIFIED (elementary)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C8

## Statement

> The word is finitely supported and eventually zero, hence **non-recurrent**, hence not Sturmian; `p(L) = L + 1` for all `L` is therefore impossible (Morse–Hedlund)

## Hypotheses and notation

- `w` is finitely supported and eventually zero.
- Morse–Hedlund: a recurrent word with `p(L) = L + 1` for all `L` is (ultimately) periodic; the source uses the contrapositive together with non-recurrence.

## Proof / evidence

Register row C8's evidence cell reads: "`tests/...::test_disproven_formulas_fail`". The source states this as elementary, without a written proof.

## Dependencies and related results

- Register row J7 (the refuted Sturmian-like law `p(L) = L + 1` for all `L`).
- Register row C1 (`p(L) = L + 1` does hold for `1 ≤ L ≤ min gap`).

## Notes

- The status word is the source's own: `VERIFIED` (elementary).
