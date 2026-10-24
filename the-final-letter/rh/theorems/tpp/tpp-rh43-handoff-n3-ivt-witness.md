# N = 3 is balanced with the explicit IVT witness `t = 5/2`

**Kind:** Proposition
**Status:** PROVED (Lean, 38 theorems, no `sorry`, no new axiom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.3 "The reduction, and the answer"

## Statement

> * `N = 3`: `Re S_3(0) = 3 > 0`, `Re S_3(5/2) < 0` (certified `-0.084335758298…`), so IVT gives a root. **PROVED** in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean), 38 theorems, no `sorry`, no new axiom; the two inputs are the trigonometric bounds `cos((5/2)log 2) < -0.16`, `cos((5/2)log 3) < -0.92`, derived from Mathlib's `log`/`π` bounds and the sine/cosine Taylor inequalities.

## Hypotheses and notation

- `S_3(t) = 1 + 2^{-it} + 3^{-it}`; `Re S_3(0) = 3 > 0` and `Re S_3(5/2) < 0` with certified value `-0.084335758298…`.
- Inputs to the Lean proof: `cos((5/2)log 2) < -0.16`, `cos((5/2)log 3) < -0.92`, derived from Mathlib's `log`/`π` bounds and the sine/cosine Taylor inequalities.
- The development contains 38 theorems, no `sorry`, no new axiom.

## Proof / evidence

- **PROVED** in Lean — [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean), 38 theorems + 4 definitions, `./check.sh --all` → exit 0, no `sorry`, `#print axioms` = `[propext, Classical.choice, Quot.sound]`.
- The intermediate value theorem gives a root in `(0, 5/2)`.

## Dependencies and related results

- Harvested truths counterpart: [Theorem 4 (existence of a balanced partial sum)](tpp-rh43-truths-n3-existence-ivt.md), ledger row [T5](tpp-rh43-truths-n3-balanced-ledger.md).
- Related: [N = 4 is balanced by the same route](tpp-rh43-handoff-n4-same-route.md); [The answer: yes, for every N ≥ 2](tpp-rh43-handoff-answer-yes-every-n.md).

## Notes

- HANDOFF.md gives the certified value with an ellipsis, `-0.084335758298…`; truths.md §1.2 prints the longer `-0.08433575829842532…`.
- The source states that no new axiom is used and that the audit reports only `[propext, Classical.choice, Quot.sound]`.
