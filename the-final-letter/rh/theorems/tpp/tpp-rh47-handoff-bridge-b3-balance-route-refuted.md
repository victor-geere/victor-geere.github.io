# B3 — the greedy balance condition cannot force a correlation (HANDOFF)

**Kind:** Claim
**Status:** REFUTED (as a route: the balance error is `√N·|M_φ(s)|` for every one-sided weight, and the correlation is not multiplicative)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §2 "The bridge that the goal needs — and the barrier", table row **B3**, line 77

## Statement

> | # | candidate bridge | status |
> |---|---|---|
> | **B3** | use the greedy **balance** condition (rh43) to force a correlation | **REFUTED as a route**: rh44 showed the balance error is `√N·|M_φ(s)|` for every one-sided weight, so no balance condition can see `o(x)`; and rh46 showed the correlation is *not multiplicative*, so the `ζ`-based machinery does not apply to it at all |

## Hypotheses and notation

- The greedy **balance** condition is rh43's `P_N = |M_N| ⟺ Re S_N(t) = 0`.
- The balance error scale is `√N·|M_φ(s)|` for every one-sided weight `φ` (rh44).
- `λ(n) = (−1)^{Ω(n)}`; the correlation `f(n) = λ(n)λ(n+2)` is *not* multiplicative (rh46), so no Euler product / `ζ`-based machinery applies.

## Proof / evidence

The HANDOFF states the route is refuted and cites rh44 (smoothing does not remove `√N`) and rh46 (non-multiplicativity). The supporting harvested results are [smoothing does not remove `√N`](tpp-dict-00-smoothing-does-not-remove-sqrt-n.md) (rh44) and [the correlation is not multiplicative; no Euler product](tpp-dict-00-correlation-not-multiplicative.md) (rh46). The round's own account of the non-multiplicativity is in `truths.md` §2 ([B3](tpp-rh47-truths-bridge-b3-no-euler-product.md)).

## Dependencies and related results

- [HANDOFF B1](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) and [HANDOFF B2](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md) — the other rows of the same table.
- [HANDOFF barrier](tpp-rh47-handoff-barrier-additive-character-open.md) — quotes the same discrepancy `2.0144` at `s=2`.
- [B3 in the ledger](tpp-rh47-truths-bridge-b3-no-euler-product.md) and [B3 in the README](tpp-rh47-readme-bridge-b3-no-euler-product.md) — the same bridge.
- Earlier ledger row: [bridge B3](tpp-dict-00-bridge-b3-zeta-machinery.md).

## Notes

- This B3 differs from the README's B3: the HANDOFF's row is about the **balance route** (rh43/rh44), the README's row about the **`ζ`-machinery**; both reduce to the non-multiplicativity of the correlation plus a scaling obstruction.
- The round's "do not re-propose" list repeats the item: "Smoothing cannot beat `√N` on the critical line (rh44)."
