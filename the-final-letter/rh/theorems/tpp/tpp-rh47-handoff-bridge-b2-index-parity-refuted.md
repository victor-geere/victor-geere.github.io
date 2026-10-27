# B2 — the zeta budgets separate index parity, not `Ω`-parity (HANDOFF)

**Kind:** Claim
**Status:** REFUTED (direction: the budgets are sign-blind combinations of `ζ(p)`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §2 "The bridge that the goal needs — and the barrier", table row **B2**, line 76

## Statement

> | # | candidate bridge | status |
> |---|---|---|
> | **B2** | the zeta budgets `P(p), N(p)` (rh42) carry parity information | **REFUTED direction**: the budgets are sign-blind combinations of `ζ(p)` — `P+N = ζ−1`, `P−N = 1−η` — so they separate *parity of index* (even/odd denominators), not the parity of `Ω(n)` |

## Hypotheses and notation

- The zeta budgets are rh42's `P(p) = 2^{−p}ζ(p)` and `N(p) = (1−2^{−p})ζ(p)−1`.
- The quoted identities are `P+N = ζ−1` and `P−N = 1−η`, with `η` the Dirichlet eta function.
- "Parity of index" is the parity of the index (even/odd denominators); `Ω(n)` counts prime factors with multiplicity.

## Proof / evidence

The HANDOFF states the refutation and its witness identities `P+N = ζ−1`, `P−N = 1−η`; the numerical account is in `truths.md` §2 (index parity and `Ω`-parity independent, `χ²(1) = 2.944`; twist identity `Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly, `0/10⁶` mismatches).

## Dependencies and related results

- [HANDOFF B1](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) and [HANDOFF B3](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md) — the other rows of the same table.
- [HANDOFF barrier](tpp-rh47-handoff-barrier-additive-character-open.md).
- [B2 in the ledger](tpp-rh47-truths-bridge-b2-index-parity-independent.md) and [B2 in the README](tpp-rh47-readme-bridge-b2-index-parity-independent.md) — the same bridge.
- [Negative budget `N(p) = (1−2^{−p})ζ(p)−1`](tpp-dict-00-negative-budget.md) and [positive budget `P(p)`](tpp-dict-00-positive-budget.md) — the harvested rh42 identities.
- Earlier ledger row: [bridge B2](tpp-dict-00-bridge-b2-index-parity.md).

## Notes

- The HANDOFF's "REFUTED direction" is deliberately narrower than `truths.md`'s plain "REFUTED": it refutes the *direction* (budgets → `Ω`-parity), and the identities `P+N = ζ−1`, `P−N = 1−η` are what make the budgets sign-blind.
- The round's "do not re-propose" list repeats the item: "The budget identities separate *index parity*, not `Ω`-parity (rh42 §2)."
