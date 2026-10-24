# T6 — N = 4 is balanced via IVT, `Re S_4(12/5) < 0`

**Kind:** Theorem
**Status:** PROVED (numerically certified, paper argument); Lean formalises the `N = 3` witness only
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T6 (§1.2)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T6 | `N = 4` balanced via IVT, `Re S_4(12/5) < 0` | **PROVED** (numerically certified) | §1.2, script §3 |

The §1.2 numbered form:

> **Theorem 5 (the same route at N = 4).** `Re S_4(0) = 4 > 0` and `Re S_4(12/5) = -0.950677206742… < 0`, so `N = 4` is balanced in `(0, 12/5)` too;

## Hypotheses and notation

- `S_4(t) = 1 + 2^{-it} + 3^{-it} + 4^{-it}`; `Re S_4(0) = 4 > 0`, `Re S_4(12/5) = -0.950677206742… < 0`.
- Continuity and the intermediate value theorem give a root in `(0, 12/5)`.

## Proof / evidence

- Ledger row T6: "**PROVED** (numerically certified)", evidence "§1.2, script §3".
- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §3 with the rigorous enclosure; the source notes the Lean development currently formalises the `N = 3` witness, the `N = 4` enclosure being the numerical route's.

## Dependencies and related results

- The numbered form is [Theorem 5 (the same route at N = 4)](tpp-rh43-truths-n4-ivt-witness.md); same route as [T5](tpp-rh43-truths-n3-balanced-ledger.md).
- Related: [T7](tpp-rh43-truths-certified-root-ledger.md), [T8](tpp-rh43-truths-existence-every-n-ledger.md).

## Notes

- Ledger row T6 restates §1.2 Theorem 5. The status is the source's own hedge: numerically certified, not Lean-formalised.
