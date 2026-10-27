# T3 — N = 1 is degenerate (`Re S_1 ≡ 1`)

**Kind:** Theorem
**Status:** PROVED (paper argument, from the definition) + VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T3 (§1.1)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T3 | `N = 1` degenerate (`Re S_1 ≡ 1`) | **PROVED**+**VERIFIED** | §1.1, script §2 |

The §1.1 numbered form:

> **Theorem 2 (N = 1 is degenerate).** `Re S_1(t) = 1` for every `t`: there is one positive part and no negative part, so the split has nothing to balance.

## Hypotheses and notation

- `S_1(t) = 1^{-it} = 1`; `P_1 = 1`, `M_1 = 0` (empty sum).
- `≡` denotes identity in `t`.

## Proof / evidence

- Ledger row T3: "**PROVED**+**VERIFIED**", evidence "§1.1, script §2".
- **PROVED** (definition); **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §2.

## Dependencies and related results

- The numbered form is [N = 1 is degenerate](tpp-rh43-truths-n1-degenerate.md).
- Related: [F3 (N = 1 is the same as N = 2 — refuted)](tpp-rh43-truths-f3-n1-equals-n2-refuted.md).

## Notes

- Ledger row T3 restates §1.1 Theorem 2.
