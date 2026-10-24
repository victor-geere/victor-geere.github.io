# p(L+1) − p(L) = RS(L) − Z(L), the finite-word Cassaigne repair

**Kind:** Claim
**Status:** VERIFIED (numerical; mediator-reproduced by an independent bit-string route — **all** `L` on the `N = 500` word and ≈405 sampled `L` on each of the other four, 0 failures)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/ledger.md`](../../research/twin-prime-parity/rounds/rh40/rounds/ledger.md) — "Attributed results (not errors — recorded so credit and status are clear)", row 1

## Statement

> `p(L+1) − p(L) = RS(L) − Z(L)`, the finite-word Cassaigne repair

## Hypotheses and notation

- `RS(L)` is the right-special factor count of length `L`; `Z(L) = |F(L)| − #{prefixes of F(L+1)}` is the terminal-uniqueness indicator.
- The identity is asserted for every `L` of the finitely supported word `w`.

## Proof / evidence

The ledger's attributed-results table gives the who/status cells: "**Agent B** (round 1), mediator-reproduced" and "`STANDING`". The independent route is an "independent bit-string route" (the ledger's narrative), with the details in [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) §3.1.

## Dependencies and related results

- Register row C4 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — the same identity, harvested as [tpp-rh40-rounds-truths-c4-corrected-finite-word-identity.md](tpp-rh40-rounds-truths-c4-corrected-finite-word-identity.md).
- Register rows C3 and C7 (the definition of `Z` and `LS ≡ 0`).
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) rows B1 and B4.

## Notes

- **Restatement.** This row restates register entry C4 of `truths.md` (same round, rh40); it is recorded here as the ledger's attribution of the repair to Agent B.
- The ledger's own heading distinguishes this section from the error table: these rows are "not errors — recorded so credit and status are clear".

- **Correction (2025-10-06, session 003 residual-defect repair).** The Status credited a mediator reproduction "on 5 words for all L". The committed script is explicit that it is not: `research/twin-prime-parity/rounds/rh40/verify/verify_agentB.py:112-118` says "B's own sweep is all L; the words with N >= 2000 are sampled here for runtime (the identity is L-local, so a dense sample is as good)" and then tests every `L` only for the `N ≤ 600` word while drawing ≈405 sampled `L` for each of the others. The scope is now stated as it is; the identity and its 0-failure result are unchanged.
