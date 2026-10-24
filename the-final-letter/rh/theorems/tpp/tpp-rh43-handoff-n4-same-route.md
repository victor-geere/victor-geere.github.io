# N = 4 is balanced by the same route

**Kind:** Proposition
**Status:** VERIFIED (numerical, certified enclosure)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.3 "The reduction, and the answer"

## Statement

> * `N = 4`: `Re S_4(12/5) = -0.9506772… < 0`, same route.

## Hypotheses and notation

- `S_4(t) = 1 + 2^{-it} + 3^{-it} + 4^{-it}`; `Re S_4(0) = 4 > 0` (the general identity `Re S_N(0) = N`) and `Re S_4(12/5) = -0.9506772… < 0`.
- "Same route" means continuity plus the intermediate value theorem on `(0, 12/5)`.

## Proof / evidence

- The source states this as the numerical route's enclosure; the round's ledger records it as **T6**, "**PROVED** (numerically certified)", evidence "§1.2, script §3".
- The source does not claim this case is Lean-formalised: truths.md §1.2 notes "The Lean development currently formalises the `N = 3` witness; the `N = 4` enclosure is the numerical route's."

## Dependencies and related results

- Harvested truths counterpart: [Theorem 5 (the same route at N = 4)](tpp-rh43-truths-n4-ivt-witness.md), ledger row [T6](tpp-rh43-truths-n4-balanced-ledger.md).
- Related: [N = 3 is balanced with the explicit IVT witness t = 5/2](tpp-rh43-handoff-n3-ivt-witness.md).

## Notes

- HANDOFF.md quotes the value as `-0.9506772…`; truths.md §1.2 prints the longer `-0.950677206742…`. Both are the source's own renderings of the same certified number.
