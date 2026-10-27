# B2 — the zeta budgets do not carry parity information (README)

**Kind:** Claim
**Status:** REFUTED (index parity and `Ω`-parity are independent; max relative deviation `<1%`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) — §2 table "The bridge the goal needs — and the barrier", row **B2**, line 56

## Statement

> | bridge | statement | status |
> |---|---|---|
> | **B2** | the zeta budgets carry parity information | **index parity and `Ω`-parity are independent** (measured max relative deviation `<1%`); the budgets are sign-blind combinations of `ζ` |

## Hypotheses and notation

- The zeta budgets are those of rh42: `P(p) = 2^{−p}ζ(p)` and `N(p) = (1−2^{−p})ζ(p)−1`, quoted in README §1(A).
- `Ω`-parity means the parity of `Ω(n)`; "index parity" is the parity of the index `n`.
- `ζ` is the Riemann zeta function.

## Proof / evidence

The README records the measured independence (max relative deviation `<1%`) and the sign-blindness of the budgets; the detailed measurement is in `truths.md` §2 (`χ²(1) = 2.944`, `z = 0.99`; permutation `z = 1.47, 1.30`) and includes the auditor's decisive twist-invariance identity `Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (`0/10⁶` mismatches).

## Dependencies and related results

- [truths.md B2 §2](tpp-rh47-truths-bridge-b2-index-parity-independent.md) — the full numerical account.
- [README B1](tpp-rh47-readme-bridge-b1-no-signal.md) and [README B3](tpp-rh47-readme-bridge-b3-no-euler-product.md) — the other two bridge rows.
- [README barrier](tpp-rh47-readme-barrier-additive-character-open.md).
- Restated in HANDOFF: [B2 "REFUTED direction"](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md), with the identities `P+N = ζ−1`, `P−N = 1−η`.
- Earlier ledger row: [bridge B2](tpp-dict-00-bridge-b2-index-parity.md).

## Notes

- The README's status wording is "index parity and `Ω`-parity are independent"; the round's ledger states the same result as REFUTED (the budgets separate index parity, not `Ω`-parity).
- The budget identities later quoted in HANDOFF are `P+N = ζ−1` and `P−N = 1−η`.
