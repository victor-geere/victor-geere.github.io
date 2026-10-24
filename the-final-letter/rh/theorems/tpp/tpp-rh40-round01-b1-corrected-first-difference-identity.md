# B1 — p(L+1) − p(L) = RS(L) − Z(L) exactly, all L

**Kind:** Claim
**Status:** VERIFIED (numerical, mediator-reproduced for all L on 5 words by an independent bit-string route)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.1 "From Agent B", verdict-table row B1; evidence in §3.1

## Statement

> `p(L+1) − p(L) = RS(L) − Z(L)` exactly, all L, `Z(L) = |F(L)| − #prefixes(F(L+1))`

## Hypotheses and notation

- `RS(L)` is the right-special factor count of length `L`; `Z(L) = |F(L)| − #{prefixes of F(L+1)}` is the terminal-uniqueness indicator.
- `N` = truncation length; the identity is asserted for every `L`.

## Proof / evidence

The verdict-table row's mediator check reads: "reproduced for all L on 5 words by an independent bit-string route; see §3.1". §3.1 gives the independent route: "bit strings, no `digitword` helpers except `p_offset`; `bRS`, `bLS`, `bZ` written from scratch in `../verify/verify_agentB.py`", and the five words with ✅ on every column (1/π 1399/1399; log 2; √2−1; (10,20,40,80) 81; true e−2 54).

## Dependencies and related results

- The same identity as register row C4 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), harvested as [tpp-rh40-rounds-truths-c4-corrected-finite-word-identity.md](tpp-rh40-rounds-truths-c4-corrected-finite-word-identity.md).
- Rows B2, B3, B4, B13 of the same table; the ledger's attributed-results row 1.

## Notes

- **Restatement.** This row restates register entry C4 of `truths.md` (round 1 of the rh40 dialogue); the ledger credits the repair to Agent B, mediator-reproduced.
- In this file the actor is Agent B; the source's own headline calls it one of "three new standing results".
