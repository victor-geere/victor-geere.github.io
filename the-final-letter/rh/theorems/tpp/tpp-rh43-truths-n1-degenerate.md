# Theorem 2 (N = 1 is degenerate)

**Kind:** Theorem
**Status:** PROVED (paper argument, from the definition); VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §1.1 "The small cases" (ledger row T3)

## Statement

> **Theorem 2 (N = 1 is degenerate).** `Re S_1(t) = 1` for every `t`: there is one positive part and no negative part, so the split has nothing to balance.

## Hypotheses and notation

- `t` ranges over the reals; `S_1(t) = 1^{-it} = 1`, so `P_1 = 1` and `M_1` is an empty sum, `0`.

## Proof / evidence

- **PROVED** (definition). **VERIFIED** in §2 of [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py).
- The ledger row T3 gives the status as "**PROVED**+**VERIFIED**", evidence "§1.1, script §2".
- [`README.md`](../../research/twin-prime-parity/rounds/rh43/README.md) records `N = 1` as "`Re S_1 ≡ 1`: one positive part, no negative part — the only degenerate case", status **PROVED**.

## Dependencies and related results

- Related: [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md) (T4) — the contrast `N = 1` versus `N = 2` is the refuted statement F3.
- The claim `N = 1` is the *only* case with no negative part is used in [Theorem 10 (balance needs only the real equation)](tpp-rh43-truths-balance-needs-only-real-equation.md).

## Notes

- The source states this without a separate written proof: it is immediate from the definition of `S_1` and is labelled "(definition)" by the source itself.
