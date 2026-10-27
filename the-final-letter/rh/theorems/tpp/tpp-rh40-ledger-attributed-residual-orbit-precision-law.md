# The residual-orbit precision law steps ≈ 2 + log₂(dps)

**Kind:** Claim
**Status:** VERIFIED (numerical; refutes the handoff's protocol)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/ledger.md`](../../research/twin-prime-parity/rounds/rh40/rounds/ledger.md) — "Attributed results (not errors — recorded so credit and status are clear)", row 8

## Statement

> The residual-orbit precision law `steps ≈ 2 + log₂(dps)`

## Hypotheses and notation

- dps = decimal digits of working precision; "steps" is the number of usable residual-orbit steps before the residual underflows.
- The law refutes HANDOFF §6.5's protocol, which asks for "~40–50 steps" per target.

## Proof / evidence

The ledger's attributed-results table gives the who/status cells: "**mediator**" and "`VERIFIED`; refutes the handoff's protocol". The measured table is register row I5 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md): dps 60→7 steps, 120→8, 200→9, 400→10, 800→11, 1600→12, 3200→13.

## Dependencies and related results

- Register rows I5, I6 (the protocol is unachievable: 40–50 steps needs `2^38`–`2^48` decimal digits), I7, I8.
- The ledger's error row 19, which records the same HANDOFF defect.

## Notes

- **Restatement.** This row restates register entry I5 of `truths.md` (same round, rh40).
